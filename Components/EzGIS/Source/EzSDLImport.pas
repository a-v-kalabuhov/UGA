unit EzSDLImport;

{***********************************************************}
{     EzGIS/CAD Components                                  }
{   (c) 2002 EzSoft Engineering                             }
{         All Rights Reserved                               }
{***********************************************************}

{$I EZ_FLAG.PAS}
Interface

Uses
  Controls, SysUtils, Classes, Windows, Dialogs,
  EzLib, EzBase, EzBaseGIS, EzProjections, EzImportBase;

type

  SDLError = class(Exception);

  TSDLObjType = ( soPoint, soLine, soPolygon );

  TSDLPointList = Class
  Private
    FType: TSDLObjType;
    FPoints: TEzVector;
    FVectorList: TList;
  Public
    Constructor Create;
    Destructor Destroy; Override;
    Procedure Clear;
    procedure ClearVectorList;
    Function ArrangePartPos: integer;
  End;

  TEzSDLImport = Class( TEzBaseImport )
  Private
    SDLInputFile: TextFile;
    SDLPtList: TSDLPointList;
    SDLObjType: tSDLObjType;
    defPen: TEzPenStyle;
    defbrush: TEzBrushStyle;
    defsymbol: TEzsymbolstyle;
    ColumnInfo: TStringList;
    fOK: Boolean;
    LastPointCount: Integer;
    MinX :Double;
    Miny :Double;
    MaxX :Double;
    Maxy :Double;
    Line: string;
    { for progress messages }
    nFileSize: Integer;
    Function GetNextSDLObjectType( Var Line: String; Var SDLObjType: tSDLObjType ): boolean;
    function GetField(const line: string; No: Integer; Del: Char): string;
    function ReadSDLLine(var Line: string): boolean; { returns false if end-of-file before reading }
  Public
    Constructor Create(AOwner: TComponent); Override;
    Destructor Destroy; Override;
    Procedure ImportInitialize; Override;
    Procedure GetSourceFieldList( FieldList: TStrings ); Override;
    Procedure ImportFirst; Override;
    Function ImportEof: Boolean; Override;
    Function GetNextEntity(var progress,entno: Integer): TEzEntity; Override;
    Procedure AddSourceFieldData(DestLayer: TEzBaseLayer; DestRecno: Integer); Override;
    Procedure ImportNext; Override;
    Function GetSourceExtension: TEzRect; Override;
    Procedure ImportEnd; Override;
  End;

  TEzSDLExport = Class( TEzBaseExport )
  Private
    FCanceled: Boolean;
    FCoordList : TStringList;
    SDLOutfileL: Text;
    SDLOutfileM: Text;
    SDLOutfileP: Text;
  Public
    Constructor Create( AOwner: TComponent ); Override;
    Destructor Destroy; Override;
    Procedure ExportInitialize; Override;
    Procedure ExportEntity( SourceLayer: TEzBaseLayer; Entity: TEzEntity ); Override;
    Procedure ExportEnd; Override;
  End;

implementation

uses
  EzEntities, EzSystem;

Const
  SDLDelim = ',';
  SDLObjStr: Array[tSDLObjType] Of String = ( 'M', 'L', 'P' );

{ TEzSDLImport }

constructor TEzSDLImport.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  ColumnInfo := TStringList.Create;
  SDLPtList := TSDLPointList.Create;
  defPen:= Ez_Preferences.DefPenStyle.FPenStyle;
  defbrush:= Ez_Preferences.DefBrushStyle.FBrushStyle;
  defsymbol:= Ez_Preferences.DefSymbolStyle.FSymbolStyle;
end;

destructor TEzSDLImport.Destroy;
begin
  ColumnInfo.Free;
  SDLPtList.Free;
  inherited;
end;

procedure TEzSDLImport.ImportInitialize;
begin
  MinX := 1E+10;
  Miny := 1E+10;
  MaxX := -1E+10;
  Maxy := -1E+10;

  AssignFile( SDLInputFile, FileName );
  Reset( SDLInputFile );
  nFileSize:= FileSize(SDLInputFile);

end;

procedure TEzSDLImport.ImportFirst;
begin
  fOK := GetNextSDLObjectType(Line, SDLObjType);
end;

function TEzSDLImport.ImportEof: Boolean;
begin
  Result:= Not fOK;
end;

Function TEzSDLImport.GetNextSDLObjectType( Var Line: String; Var SDLObjType: tSDLObjType ): boolean;
Var
  GotIt: boolean;
  ObjStr: String;
  ObjType: tSDLObjType;

Begin

  GotIt := false;
  Result := true;

  Line := '';
  Repeat
    ObjStr := uppercase( GetField( Line, 1, SDLDelim ) );
    For ObjType := low( tSDLObjType ) To high( tSDLObjType ) Do
    Begin
      If ObjStr = SDLObjStr[ObjType] Then
      Begin
        GotIt := true;
        SDLObjType := ObjType;
      End;
    End;
    If Not GotIt Then
      Result := ReadSDLLine( Line );
  Until GotIt Or Not Result;

End;

procedure TEzSDLImport.ImportNext;
begin
  fOK := GetNextSDLObjectType(Line, SDLObjType);
end;

function TEzSDLImport.GetField(const line: string; No: Integer; Del: Char): string;

var
  i, Delimeter_pos, end_pos: integer;
  tmp_line: string;

begin
  tmp_line := line;

  if No > 1 then
    for i := 0 to No - 2 do
    begin
      Delimeter_pos := Pos(Del, tmp_line);
      tmp_line := Copy(tmp_line, Delimeter_pos + 1, length(tmp_line) - Delimeter_pos)
    end;

  end_pos := Pos(Del, tmp_line);
  if end_pos <> 0 then
    tmp_line := Copy(tmp_line, 1, end_pos - 1);

  Result := tmp_line;
  if not (tmp_line = '') then
    if tmp_line[1] = '"' then
      Result := Copy(tmp_line, 2, Length(Result) - 2);

end;

function TEzSDLImport.ReadSDLLine(var Line: string): boolean; { returns false if end-of-file before reading }
begin
  Result := false;
  if not eof(SDLInputFile) then begin
    Result := true;
    readln(SDLInputFile, Line);

    //Check For Header Skipping.
    if (Copy(Line, 1, 1) = ';') or (Copy(Line, 1, 1) = '#') then
      while (not Eof(SDLInputfile)) and ((Copy(Line, 1, 1) = ';') or (Copy(Line, 1, 1) = '#')) do
        readln(SDLInputFile, Line);

    if Eof(SDLinputfile) then Result := false;
  end;
end;

function TEzSDLImport.GetNextEntity(var progress,entno: Integer): TEzEntity;

  Procedure CompareBoundary( Const x, y: double );
  Begin
    If x < minx Then
      minx := x;
    If y < miny Then
      miny := y;
    If x > maxx Then
      maxx := x;
    If y > maxy Then
      maxy := y;
  End;

  function ReadSDLCommand(var Command, Line: string): boolean;
  begin
    Result := ReadSDLLine(Line);
    Line := lowercase(Line);
    Command := GetField(Line, 1, SDLDelim);
  end;

  function GetSDLCoord(const Line: string; FieldPos: byte): TEzPoint;
  begin
    try
      Result.Y := StrToFloat(GetField(Line, FieldPos, SDLDelim));
      Result.X := StrToFloat(GetField(Line, FieldPos + 1, SDLDelim));
    except
      on e: Exception do begin
        raise SDLError.Create(e.Message + ' - Import terminated');
      end;
    end;
  end;

  function GetSDLCoordWithString(const Line: string; FieldPos: byte): string;
  begin
    try Result := GetField(line, FieldPos, SDLDelim);
    except
      on e: EXCEPTION do begin
        raise SDLError.Create(e.Message + ' - Import terminated');
      end;
    end;
  end;

Var
  pointCount: Integer;
  TmpEntity: TEzEntity;
  i, j, PartOffset: integer;
  TmpPt: TEzPoint;
  V: TEzVector;
begin

  entno:= FilePos(SDLInputFile);
  progress:= Round((entno / nFileSize) * 100);

  Result:= Nil;
  pointCount := StrToInt( GetField( line, 5, SDLDelim ) );
  Case SDLObjType Of
    // M, Points
    soPoint:
      Begin
        TmpEntity := TEzPlace.Create( pointCount );
        TEzPlace( TmpEntity ).Symboltool.FSymbolStyle := defsymbol;
        SDLPtList.FType := soPoint;
      End;
    // L, Polylines
    soLine:
      Begin
        TmpEntity := TEzPolyline.Create( pointCount );
        TEzPolyline( TmpEntity ).Pentool.FPenStyle := defPen;
        SDLPtList.FType := soLine;
      End;
    // P, Polygons
    soPolygon:
      Begin
        TmpEntity := TEzPolygon.Create( pointCount );
        TEzPolygon( TmpEntity ).Pentool.FPenStyle := defPen;
        TEzPolygon( TmpEntity ).Brushtool.FBrushStyle := defbrush;
        SDLPtList.FType := soPolygon;
      End;
  Else
    Exit;
  End;

  ColumnInfo.Clear;
  Columninfo.Add( GetField( line, 1, SDLDelim ) );
  Columninfo.Add( GetField( line, 2, SDLDelim ) );
  Columninfo.Add( GetField( line, 3, SDLDelim ) );
  Columninfo.Add( GetField( line, 4, SDLDelim ) );
  Columninfo.Add( GetField( line, 5, SDLDelim ) );

  For i := 0 To pointCount - 1 Do
  Begin
    ReadSDLLine( line );
    TmpPt := GetSDLCoord( line, 1 );
    SDLPtList.FPoints.Add( TmpPt );
  End;

  If SDLPtList.FType <> soPoint Then
  Begin
    SDLPtList.ArrangePartPos;
    PartOffset:= 0;
    For i:= 0 to SDLPtList.FVectorList.Count - 1 do
    begin
      V:= TEzVector(SDLPtList.FVectorList[i]);
      for j:= 0 to V.Count - 1 do
      begin
        TmpPt:= V[j];
        Compareboundary( TmpPt.X, TmpPt.Y );
        TmpEntity.Points.Add( TmpPt );
      end;
      If SDLPtList.FVectorList.Count > 1 Then
        TmpEntity.Points.Parts.Add(PartOffset);
      Inc(PartOffset, V.Count);
    end;
  End Else
    TmpEntity.Points.Add( SDLPtList.FPoints[0] );

  LastPointCount:= TmpEntity.Points.Count;
  If LastPointCount > 0 Then
    Result:= TmpEntity
  Else
  Begin
    Result:= Nil;
    TmpEntity.Free;
  End;

  SDLPtList.Clear;

end;

procedure TEzSDLImport.AddSourceFieldData(DestLayer: TEzBaseLayer; DestRecno: Integer);
begin
  If (DestLayer.DBTable = Nil) Or (LastPointCount <= 0) Then Exit;
  DestLayer.DBTable.Recno:= DestRecno;
  DestLayer.DBTable.BeginTrans;
  Try
    with DestLayer.DBTable do
    begin
      Edit;
      StringPut( 'TYPE', Columninfo[0] );
      StringPut( 'NAME', Columninfo[1] );
      StringPut( 'KEY', Columninfo[2] );
      StringPut( 'URLLINK', Columninfo[3] );
      StringPut( 'NUMPTS', Columninfo[4] );
      Post;
      EndTrans;
    end;
  Except
    DestLayer.DBTable.RollbackTrans;
    raise;
  End;
end;

function TEzSDLImport.GetSourceExtension: TEzRect;
begin
  Result:= Rect2d(minx,miny,maxx,maxy);
end;

procedure TEzSDLImport.GetSourceFieldList(FieldList: TStrings);
begin
  FieldList.Add('UID;N;12;0');
  FieldList.Add('TYPE;C;1;0');
  FieldList.Add('NAME;C;255;0');
  FieldList.Add('KEY;C;255;0');
  FieldList.Add('URLLINK;C;255;0');
  FieldList.Add('NUMPTS;N;5;0');
end;

procedure TEzSDLImport.ImportEnd;
begin
  CloseFile( SDLInputFile );
end;

{ TSDLPointList }

constructor TSDLPointList.Create;
begin
  Inherited Create;
  FPoints:= TEzVector.Create(1000);
  FVectorList:= TList.Create;
end;

Destructor TSDLPointList.Destroy;
begin
  FPoints.free;
  ClearVectorList;
  FVectorList.Free;
  inherited;
end;

procedure TSDLPointList.Clear;
begin
  FPoints.clear;
  ClearVectorList;
end;

procedure TSDLPointList.ClearVectorList;
var
  I: Integer;
Begin
  for I:= 0 to FVectorList.Count-1 do
    TEzVector(FVectorList[I]).Free;
  FVectorList.Clear;
End;

function TSDLPointList.ArrangePartPos: integer;
var
  partStart: TEzPoint;
  isPartStart: Boolean;
  I: integer;
  TempV: TEzVector;
begin
  ClearVectorList;

  isPartStart := False;

  TempV:= Nil;
  for i := 0 to FPoints.Count - 1 do
  begin
    if not isPartStart then
    begin
      TempV:= TEzVector.Create(10);
      FVectorList.Add( TempV );
      partStart:= FPoints[i];
      TempV.Add( partStart );
      isPartStart := True;
    end
    else if EqualPoint2d(partStart, FPoints[i]) then
    begin
      If FType = soPolygon then
        TempV.Add( FPoints[i] );
      isPartStart := False;
    end else
    begin
      TempV.Add( FPoints[i] );
    end;
  end;
  Result := FVectorList.Count;
end;

{ TEzSDLExport }

constructor TEzSDLExport.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FCoordList := TStringList.Create;
end;

destructor TEzSDLExport.Destroy;
begin
  FCoordList.Free;
  inherited;
end;

procedure TEzSDLExport.ExportInitialize;
var
  S: string;

  procedure writeHeader(var Txt: Textfile);
  begin
    writeln(Txt, '; Lines starting with "#" are header data generated by SDF Loader.');
    writeln(Txt, '; Do not edit these lines.');
    writeln(Txt, '#VERSION=2.1');
    writeln(Txt, '#METADATA_BEGIN=CoordinateSystem');
    writeln(Txt, '#GEOGCS["LL84",DATUM["WGS_1984",SPHEROID["WGS 84",6378137,0],TOWGS84[0,0,0,0,0,0,0]],PRIMEM["Greenwich",0],UNIT["Degrees",1]]');
    writeln(Txt, '#METADATA_END');
  end;

begin
  s := ChangeFileExt(FileName, '.');
{$I-}
  AssignFile(SDLOutfileL, FileName + '_L.SDL');
  AssignFile(SDLOutfileM, FileName + '_M.SDL');
  AssignFile(SDLOutfileP, FileName + '_P.SDL');
  Rewrite(SDLOutfileL);
  Rewrite(SDLOutfileM);
  Rewrite(SDLOutfileP);

{$I+}
  FCanceled := IOResult <> 0;
  If FCanceled Then Exit;
  WriteHeader(SDLOutfileL);
  WriteHeader(SDLOutfileM);
  WriteHeader(SDLOutfileP);
end;

procedure TEzSDLExport.ExportEnd;
begin
  CloseFile(SDLOutfileL);
  CloseFile(SDLOutfileM);
  CloseFile(SDLOutfileP);
end;

procedure TEzSDLExport.ExportEntity(SourceLayer: TEzBaseLayer; Entity: TEzEntity);
var
  SDLType: TSDLObjType;
  s: string;
  ENTPointCount: integer;

  function GetNumPTS(SDL: TSDLObjType; ENT: TEzEntity): integer;
  begin
    Result := 0;
    if ENT.Points.Parts.Count > 0 then
      case SDL of
        soPoint: Result := ENT.Points.Count;
                 // Result := 1;
        soLine: Result := ENT.Points.Count + ENT.Points.Parts.Count - 1;
        soPolygon: Result := ENT.Points.Count;
      end
    else
      Result := ENT.Points.Count;
  end;

  procedure WriteCoord(var Txt: TextFile; coordList: TStringList);
  var
    i: integer;
  begin
    for i := 0 to CoordList.Count - 1 do
      Writeln(Txt, CoordList.Strings[i]);
  end;

  Procedure SetCoordListForWrite(Ent: TEzEntity);
  var
    i, PointCount, PartCount: integer;
    tmpList: TStringList;
    partStartCoord: string;
    NextPartNewStart: string;
    insertCount : integer;
  begin
    tmpList := TStringList.Create;
    try
      FCoordList.Clear;

      PointCount := ENT.Points.Count;
      PartCount := ENT.Points.Parts.Count;

      for i := 0 to PointCount - 1 do
        tmpList.Add(FloatToStr(ENT.Points[i].Y) + ',' + FloatToStr(ENT.Points[i].X));

      if ((SDLType = soline) and (PartCount > 0)) then
      begin
        insertCount := 0;
        for i := 1 to PartCount - 1 do
        begin
          partStartCoord := FloatToStr(ENT.Points[ENT.Points.Parts[i - 1]].Y) + ',' +
            FloatToStr(ENT.Points[ENT.Points.Parts[i - 1]].X);
          NextPartNewStart := FloatToStr(ENT.Points[ENT.Points.Parts[i] - 2].Y) + ',' +
            FloatToStr(ENT.Points[ENT.Points.Parts[i] - 1].X);

          if tmpList.Strings[ENT.Points.Parts[i] + insertCount - 1] = partStartCoord then
          begin
            tmpList.Insert(ENT.Points.Parts[i] + insertCount, partStartCoord);
            inc(insertCount);
            tmpList.Insert(ENT.Points.Parts[i] + insertCount, NextPartNewStart);
            inc(insertCount);
          end;

          tmpList.Insert(ENT.Points.Parts[i] + insertCount, partStartCoord);
          inc(insertCount);
        end;
      end;

      FCoordList.Add(tmpList.Strings[0]);
      for i := 1 to tmpList.Count - 1 do
      begin
        if ((FCoordList.Strings[0] = tmpList.Strings[i]) and (PartCount < 2) and (i <> tmpList.Count - 1)) then
          case SDLType of
            soLine:
              begin
                FCoordList.Add(tmpList.Strings[i]);
                FCoordList.Add(tmpList.Strings[i - 1]);
              end;
            soPolygon:
              FCoordList.Add(FCoordList.Strings[0]);
          end;

        FCoordList.Add(tmpList.Strings[i]);
      end;
    finally
      tmpList.Free;
    end;
  end;

begin

  case Entity.EntityID of
    idPlace, idTrueTypeText: SDLType := soPoint;
    idPolyline: SDLType := soLine;
    idPolygon: SDLType := soPolygon;
    idRectangle: SDLType := soPolygon;
    idArc: SDLType := soline;
    idEllipse: SDLType := soPolygon;
    idPictureRef, idBandsBitmap, idPersistBitmap: SDLType := soPolygon;
    idSpline: SDLType := soline;
    idTable: SDLType := soPolygon;
  else
    exit;
  end;

  S := '';
  case SDLType of
    soPoint: s := 'M,';
    soLine: s := 'L,';
    soPolygon: s := 'P,';
  end;

  SetCoordListForWrite(Entity);

  ENTPointCount := FCoordList.Count;
  //      ENTPointCount := GetNumPts(SDLType, ENT);
  //      if FLayer.EntHeader.UseDBF = false then
  //      begin
  S := S + '"","' + InttoStr(SourceLayer.Recno) + '","",' + inttostr(ENTPointCount);
  {      end else begin
    FLayer.DataSet.RecNo := idx;
    Fld_Name := FLayer.DataSet.FieldByName('NAME');
    FLD_KEY := FLayer.DataSet.FieldByName('KEY');
    FLD_URLLink := FLayer.DataSet.FieldByName('URLLINK');

  // Name of Feature in Mapguide SDL Field
    if FLD_NAME <> nil then S := S + '"' + Fld_Name.AsString + '"'
    else S := S + '""';

  // KEY of Feature in Mapguide SDL Field
    if FLD_KEY <> nil then S := S + ',"' + Fld_KEY.AsString + '"'
    else S := S + ',"' + FLayer.DataSet.fieldbyname('IDMAP').asString + '"';

  // KEY of Feature in Mapguide SDL Field
    if FLD_URLLink <> nil then S := S + ',"' + Fld_URLLink.AsString + '",'
    else S := S + ',"",';

    S := S + inttostr(EntPointCount);
  end; // end of UseDBF
  }


  case SDLType of
    soPoint:
      begin
        Writeln(SDLOutfileM, S);
        WriteCoord(SDLOutFileM, FCoordList);
      end;
    soLine:
      begin
        Writeln(SDLOutfileL, S);
        WriteCoord(SDLOutFileL, FCoordList);
      end;
    soPolygon:
      begin
        Writeln(SDLOutfileP, S);
        WriteCoord(SDLOutFileP, FCoordList);
      end;
  end;

end;


end.
