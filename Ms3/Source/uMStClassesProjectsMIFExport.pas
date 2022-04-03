unit uMStClassesProjectsMIFExport;

interface

uses
  SysUtils, Contnrs, Math, Graphics, StrUtils, DB,
  EzBaseGIS, EzLib, EzBase, EzEntities,
  uGC,
  uMStConsts,
  uMStKernelGISUtils, uMStKernelIBX,
  uMStClassesProjects;

type
  TGetProjectEvent = function (Sender: TObject; const ProjectId: Integer): TmstProject of object;
  TmstProjectMIFExport = class
  private
    FGIS: TEzBaseGIS;
    FProjectIds: TIntegerList;
    FFileName: string;
    FOnGetProject: TGetProjectEvent;
    FDrawBox: TezBaseDrawBox;
    FDB: IDb;
    FUseDecartCoords: Boolean;
    procedure SetOnGetProject(const Value: TGetProjectEvent);
    procedure SetDrawBox(const Value: TezBaseDrawBox);
    procedure SetDB(const Value: IDb);
    procedure SetUseDecartCoords(const Value: Boolean);
  strict private
    FMif, FMid: Text;
    procedure ProcessLayer(const LayerName: string);
    procedure StartWrite();
    procedure FinishWrite();
    procedure WriteEntity(Ent: TEzEntity; Prj: TmstProject; Line: TmstProjectLine);
    procedure WriteFields(Prj: TmstProject; Line: TmstProjectLine);
    procedure WriteHeader();
    procedure WMid(const S: String);
    procedure WMif(const S: String);
  strict private
    procedure CalcExtents(out X1, Y1, X2, Y2: Double);
    function MIF2DelphiColor( iColor: Integer ): Integer;
  strict private
    FConn: IIBXConnection;
    FDsOrgName: TDataSet;
    function GetLicOrgName(const OrgId: Integer): string;
  strict private
    procedure WriteArc(Ent: TEzEntity);
    procedure WriteEllipse(Ent: TEzEntity);
    procedure WritePoint(Ent: TEzEntity);
    procedure WritePolygon(Ent: TEzEntity);
    procedure WritePolygonStyle(Ent: TEzEntity);
    procedure WritePolyline(Ent: TEzEntity);
    procedure WritePolylineStyle(Ent: TEzEntity);
  public
    constructor Create;
    destructor Destroy; override;
    //
    procedure Save(GIS: TEzBaseGIS; const aFileName: string);
    //
    property DB: IDb read FDB write SetDB;
    property DrawBox: TezBaseDrawBox read FDrawBox write SetDrawBox;
    property UseDecartCoords: Boolean read FUseDecartCoords write SetUseDecartCoords;
    //
    property OnGetProject: TGetProjectEvent read FOnGetProject write SetOnGetProject;
  end;

implementation

{ TmstProjectMIFExport }

procedure TmstProjectMIFExport.CalcExtents(out X1, Y1, X2, Y2: Double);
var
  EzLayer1, EzLayer2: TEzBaseLayer;
  Xx1, Yy1, Xx2, Yy2: Double;
begin
  EzLayer1 := FGIS.Layers.LayerByName(SL_PROJECT_OPEN);
  EzLayer2 := FGIS.Layers.LayerByName(SL_PROJECT_CLOSED);
  if Assigned(EzLayer1) or Assigned(EzLayer2) then
  begin
    if Assigned(EzLayer1) and Assigned(EzLayer2) then
    begin
      EzLayer1.MaxMinExtents(X1, Y1, X2, Y2);
      EzLayer2.MaxMinExtents(Xx1, Yy1, Xx2, Yy2);
      X1 := Min(X1, Xx1);
      X2 := Max(X2, Xx2);
      Y1 := Min(Y1, Yy1);
      Y2 := Max(Y2, Yy2);
    end
    else
    if Assigned(EzLayer1) then
      EzLayer1.MaxMinExtents(X1, Y1, X2, Y2)
    else
      EzLayer2.MaxMinExtents(X1, Y1, X2, Y2);
  end
  else
  begin
    X1 := 0;
    Y1 := 0;
    X2 := 1000;
    Y2 := 1000;
  end;
end;

constructor TmstProjectMIFExport.Create;
begin
  FProjectIds := TIntegerList.Create;
end;

destructor TmstProjectMIFExport.Destroy;
begin
  FProjectIds.Free;
  inherited;
end;

procedure TmstProjectMIFExport.FinishWrite;
begin
  CloseFile(FMif);
  CloseFile(FMid);
  if Assigned(FDsOrgName) then
    FDsOrgName.Active := False;
  FConn := nil;
end;

function TmstProjectMIFExport.GetLicOrgName(const OrgId: Integer): string;
begin
  try
    if not Assigned(FConn) then
    begin
      FConn := FDb.GetConnection(cmReadOnly, dmKis);
      FDsOrgName := FConn.GetDataSet(SQL_SELECT_LICENSED_ORG_NAME);
    end;
    FDsOrgName.Active := False;
    FConn.SetParam(FDsOrgName, SF_ID, OrgId);
    FDsOrgName.Active := True;
    Result := FDsOrgName.Fields[0].AsString;
    FDsOrgName.Active := False;
  except
    Result := '';
  end;
end;

function TmstProjectMIFExport.MIF2DelphiColor(iColor: Integer): Integer;
Var
  sTmp: String;
  code: integer;
Begin
  sTmp := IntToHex( iColor, 6 );
  val( '$' + Copy( sTmp, 5, 2 ) + Copy( sTmp, 3, 2 ) + Copy( sTmp, 1, 2 ), result, code );
end;

procedure TmstProjectMIFExport.ProcessLayer(const LayerName: string);
var
  EzLayer: TEzBaseLayer;
  Ent: TEzEntity;
  PrjId, LineId: Integer;
  Prj: TmstProject;
  Line: TmstProjectLine;
begin
  EzLayer := FGIS.Layers.LayerByName(LayerName);
  if Assigned(EzLayer) then
  begin
    EzLayer.First;
    while not EzLayer.Eof do
    begin
      if not Ezlayer.RecIsDeleted then
      begin
        Ent := Ezlayer.RecLoadEntity();
        if Assigned(Ent) then
        begin
          EzLayer.DBTable.Recno := EzLayer.Recno;
          PrjId := EzLayer.DBTable.IntegerGet(SF_PROJECT_ID);
          LineId := EzLayer.DBTable.IntegerGet(SF_LINE_ID);
          Prj := FOnGetProject(Self, PrjId);
          Line := nil;
          if Assigned(Prj) then
          begin
            Line := Prj.Lines.ByDbId(LineId);
          end;
          WriteEntity(Ent, Prj, Line);
        end;
      end;
      EzLayer.Next;
    end;
  end;
end;

procedure TmstProjectMIFExport.Save(GIS: TEzBaseGIS; const aFileName: string);
begin
  if not GIS.Active then
    Exit;
  FGis := GIS;
  FFileName := aFileName;
  StartWrite();
  try
    // пробегаем по слоям
    ProcessLayer(SL_PROJECT_OPEN);
    ProcessLayer(SL_PROJECT_CLOSED);
    // выбираем список проектов
    // по проектам строим список слоёв для экспорта
    // для каждого слоя линий надо будет заполнять таблицу данных
    // експортируем
  finally
    FinishWrite();
  end;
end;

procedure TmstProjectMIFExport.SetDB(const Value: IDb);
begin
  FDB := Value;
end;

procedure TmstProjectMIFExport.SetDrawBox(const Value: TezBaseDrawBox);
begin
  FDrawBox := Value;
end;

procedure TmstProjectMIFExport.SetOnGetProject(const Value: TGetProjectEvent);
begin
  FOnGetProject := Value;
end;

procedure TmstProjectMIFExport.SetUseDecartCoords(const Value: Boolean);
begin
  FUseDecartCoords := Value;
end;

procedure TmstProjectMIFExport.StartWrite;
begin
  AssignFile(FMif, FFileName);
  AssignFile(FMid, ChangeFileExt(FFileName, '.mid'));
  Rewrite(FMif);
  Rewrite(FMid);
  WriteHeader();
end;

procedure TmstProjectMIFExport.WMid(const S: String);
begin
  Writeln(FMid, S);
end;

procedure TmstProjectMIFExport.WMif(const S: String);
begin
  Writeln(FMif, S);
end;

procedure TmstProjectMIFExport.WriteArc(Ent: TEzEntity);
Var
  s: String;
  X1, Y1, X2, Y2: Double;
  CX, CY, Rad, sangle, eangle, ca: Double;
  pu, pv: TEzPoint;
  Arc: TEzArc;
  I: Integer;
Begin
  s := 'Arc ';

  Arc := TEzArc(Ent.Clone());
  try
    if not FUseDecartCoords then
    begin
      Arc.BeginUpdate;
      try
      for I := 0 to Arc.Points.Count - 1 do
        Arc.Points[I] := Point2D(Arc.Points[I].Y, Arc.Points[I].X);
      finally
        Arc.EndUpdate;
      end;
    end;

    sangle := radtodeg( Arc.StartAngle );
    eangle := radtodeg( Arc.EndAngle );
    Rad := Arc.Radius;
    CX := Arc.CenterX;
    CY := Arc.CenterY;

    pu := Point2d( CX - rad, CY - rad );
    pv := Point2d( CX + rad, CY + rad );

    X1 := PU.X;
    Y1 := PU.Y;
    X2 := PV.X;
    Y2 := PV.Y;

    If radtodeg( Angle2D( Ent.Points[0], ent.Points[2] ) ) > 0 Then
    Begin
      ca := sangle;
      sangle := eangle;
      eangle := ca;
    End;

    s := s + FloatToStrF( X1, fffixed, 21, 9 ) + ' ';
    s := s + FloatToStrF( Y1, fffixed, 21, 9 ) + ' ';
    s := s + FloatToStrF( X2, fffixed, 21, 9 ) + ' ';
    s := s + FloatToStrF( Y2, fffixed, 21, 9 ) + ' ';
    s := s + FloatToStrF( sangle, fffixed, 21, 9 ) + ' ';
    s := s + FloatToStrF( eangle, fffixed, 21, 9 ) + ' ';
    WMIF( S );
    WritePolylineStyle( ENT );
  finally
    Arc.Free;
  end;
end;

procedure TmstProjectMIFExport.WriteEllipse(Ent: TEzEntity);
Var
  s: String;
  X1, Y1, X2, Y2: Double;
Begin
  s := 'Ellipse ';
  x1 := Ent.Points.X[0];
  Y1 := Ent.Points.Y[0];
  x2 := Ent.Points.X[1];
  Y2 := Ent.Points.Y[1];
  if FUseDecartCoords then
  begin
    s := s + FloatToStrF( X1, ffFixed, 21, 9 ) + ' ';
    s := s + FloatToStrF( Y1, ffFixed, 21, 9 ) + ' ';
    s := s + FloatToStrF( X2, ffFixed, 21, 9 ) + ' ';
    s := s + FloatToStrF( Y2, ffFixed, 21, 9 );
  end
  else
  begin
    s := s + FloatToStrF( Y1, ffFixed, 21, 9 ) + ' ';
    s := s + FloatToStrF( X1, ffFixed, 21, 9 ) + ' ';
    s := s + FloatToStrF( Y2, ffFixed, 21, 9 ) + ' ';
    s := s + FloatToStrF( X2, ffFixed, 21, 9 );
  end;
  WMIF( S );
  WritePolygonStyle( ENT );
end;

procedure TmstProjectMIFExport.WriteEntity(Ent: TEzEntity; Prj: TmstProject; Line: TmstProjectLine);
var
  AddFields: Boolean;
  OldSep: Char;
begin
  AddFields := True;
  OldSep := DecimalSeparator;
  DecimalSeparator := '.';
  try
    try
      case Ent.EntityID of
        idPolygon:
            WritePolygon(Ent);
        idPolyline, idSpline:
            WritePolyline(Ent);
        idPlace, idPoint:
            WritePoint(Ent);
        idArc:
            WriteArc(Ent);
        idEllipse:
            WriteEllipse(Ent);
        else
            AddFields := False;
      end;
    except
      AddFields := False;
    end;
    if AddFields then
      WriteFields(Prj, Line);
  finally
    DecimalSeparator := OldSep;
  end;
end;

procedure TmstProjectMIFExport.WriteFields(Prj: TmstProject; Line: TmstProjectLine);
Var
  s: String;
begin
////  Проекты
//  WMIF('  PROJECT_ID Integer ');
//  WMIF('  ADDRESS Char(120) ');
//  WMIF('  DOC_NUMBER Char(12) ');
//  WMIF('  DOC_DATE Char(10) ');
//  WMIF('  CUSTOMER Char(10) ');
//  WMIF('  EXECUTOR Char(10) ');
//  WMIF('  CONFIRMED Logical ');
//  WMIF('  CONFIRM_DATE Char(10) ');
////  Линии
//  WMIF('  LINE_ID Integer ');
//  WMIF('  LINE_INFO Char(255) ');
//  WMIF('  LINE_DIAMETER Char(50) ');
//  WMIF('  LINE_VOLTAGE Char(50) ');
////  Слои
//  WMIF('  LAYER_NAME Char(255) ');
  s := '';
  if Assigned(Prj) then
  begin
    S := S + IntToStr(Prj.DatabaseId) + ',';
    S := S + '"' + Prj.Address + '",';
    S := S + '"' + Prj.DocNumber + '",';
    S := S + '"' + DateToStr(Prj.DocDate) + '",';
    S := S + '"' + Copy(GetLicOrgName(Prj.CustomerOrgId), 1, 255) + '",';
    S := S + '"' + Copy(GetLicOrgName(Prj.ExecutorOrgId), 1, 255) + '",';
    S := S + StrUtils.IfThen(Prj.Confirmed, 'T', 'F') + '",';
    S := S + '"' + IfThen(Prj.Confirmed, DateToStr(Prj.ConfirmDate), '') + '",';
  end
  else
    S := S + '0,"","","","","",F,"",';
  if Assigned(Line) then
  begin
    S := S + IntToStr(Line.DatabaseId) + ',';
    S := S + '"' + Copy(Line.Info, 1, 255) + '",';
    S := S + '"' + Line.Diameter + '",';
    S := S + '"' + Line.Voltage + '",';
    S := S + '"' + IfThen(Assigned(Line.Layer), Line.Layer.Name, '') + '"';
  end
  else
    S := S + '0,"","","",""';

  //
  WMID( S );
end;

procedure TmstProjectMIFExport.WriteHeader;
var
  S: String;
  X1, Y1, X2, Y2: Double;
begin
  WMif('Version 300');
  WMif('Charset "WindowsCyrillic"');
  WMif('Delimiter ","');
  //Coordinates section.
  CalcExtents(X1, Y1, X2, Y2);
  S := 'CoordSys NonEarth Units "m" Bounds (';
  S := S + FloatToStrF( X1, ffFixed, 21, 9 ) + ', ';
  S := S + FloatToStrF( Y1, ffFixed, 21, 9 ) + ') (';
  S := S + FloatToStrF( X2, ffFixed, 21, 9 ) + ', ';
  S := S + FloatToStrF( Y2, ffFixed, 21, 9 ) + ')';
  WMIF( S );

  WMIF('Columns 13');
//  Проекты
//  ID
//  ADDRESS
//  DOC_NUMBER
//  DOC_DATE
//  CUSTOMER
//  CONFIRMED
//  EXECUTOR
//  CONFIRM_DATE
  WMIF('  PROJECT_ID Integer ');
  WMIF('  ADDRESS Char(120) ');
  WMIF('  DOC_NUMBER Char(12) ');
  WMIF('  DOC_DATE Char(10) ');
  WMIF('  CUSTOMER Char(255) ');
  WMIF('  EXECUTOR Char(255) ');
  WMIF('  CONFIRMED Logical ');
  WMIF('  CONFIRM_DATE Char(10) ');
//  Линии
//  ID
//  INFO
//  DIAMETER
//  VOLTAGE
  WMIF('  LINE_ID Integer ');
  WMIF('  LINE_INFO Char(255) ');
  WMIF('  LINE_DIAMETER Char(50) ');
  WMIF('  LINE_VOLTAGE Char(50) ');
//  Слои
//  NAME
  WMIF('  LAYER_NAME Char(255) ');

  WMIF( 'Data' );
//  WMIF( '' );
end;

procedure TmstProjectMIFExport.WritePoint(Ent: TEzEntity);
Var
  s: String;
  Style, Size: Integer;
  Color: TColor;
  CX, CY: Double;
Begin
  s := 'Point ';
  Ent.Centroid( CX, CY );
  if FUseDecartCoords then
  begin
    s := s + FloatToStrF( CX, fffixed, 21, 9 ) + ' ';
    s := s + FloatToStrF( CY, fffixed, 21, 9 );
  end
  else
  begin
    s := s + FloatToStrF( CY, fffixed, 21, 9 ) + ' ';
    s := s + FloatToStrF( CX, fffixed, 21, 9 );
  end;
  WMIF( S );
  //31 is blank, from 32 mapinfo's symol start.
  Style := 32 + TEzPlace( Ent ).SymbolTool.Index;
  Color := MIF2DelphiColor( clBlack );
  Size := Round( DrawBox.Grapher.DistToPointsY( TEzPlace( Ent ).Symboltool.Height ) );
  WMIF( '    Symbol (' + IntToStr( Style ) + ',' + IntToStr( Color ) + ',' + IntToStr( Size ) + ')' );
end;

procedure TmstProjectMIFExport.WritePolygon(Ent: TEzEntity);
var
  i, j, temp, Parts: integer;
  s: String;
  PartCount, PrvCount: Longint;
begin
  Parts := Ent.DrawPoints.Parts.Count;
  If ( Parts = 0 ) And ( Ent.points.Count = 2 ) Then
    Ent.Points.Add( Ent.points[0] );
  If Parts = 0 Then
    Parts := 1;
  WMIF( 'Region  ' + IntToStr( Parts ) );
  PrvCount := 0;
  for i := 0 to Parts - 1 do
  Begin
    If Parts = 1 Then
      PartCount := Ent.Points.Count
    Else
    Begin
      If i < ( Parts - 1 ) Then
        PartCount := Ent.Points.Parts[i + 1] - Ent.Points.Parts[i]
      Else
        PartCount := Ent.Points.Count - Ent.Points.Parts[i];
    End;
    WMIF( '  ' + IntToStr( PartCount ) );

    temp:=0;
    For j := PrvCount To PrvCount + PartCount - 1 Do
    Begin
      if FUseDecartCoords then
      begin
        S := FloatToStrF( Ent.Points.X[j], ffFixed, 21, 9 ) + ' ';
        S := S + FloatToStrF( Ent.Points.Y[j], ffFixed, 21, 9 );
      end
      else
      begin
        S := FloatToStrF( Ent.Points.Y[j], ffFixed, 21, 9 ) + ' ';
        S := S + FloatToStrF( Ent.Points.X[j], ffFixed, 21, 9 );
      end;
      WMIF( S );
      temp := j;
    end;
    PrvCount := temp;
  end;
  WritePolygonStyle(Ent);
end;

procedure TmstProjectMIFExport.WritePolygonStyle(Ent: TEzEntity);
var
  Penwidth, PenPattern, BPattern: integer;
  PenColor, BForeColor, BBackColor: TColor;
  s: String;
  Cx, Cy: Double;
  Oe: TEzOpenedEntity;
Begin
  Oe := TEzOpenedEntity(Ent);
//  if Oe.PenTool.Width < 0 then
//    PenWidth := Abs(Round(Oe.PenTool.Width))
//  else
  begin
    PenWidth := FDrawBox.Grapher.RealToDistX(Abs(Oe.Pentool.Width));
  end;
  if PenWidth = 0 then
    PenWidth := 1;
  PenPattern := Oe.PenTool.Style + 1;
  PenColor := MIF2DelphiColor(Oe.PenTool.Color );
  BPattern := TEzClosedEntity(Ent).BrushTool.Pattern + 1;
  BForeColor := MIF2DelphiColor(TEzClosedEntity(Ent).Brushtool.ForeColor );
  BBackColor := MIF2DelphiColor(TEzClosedEntity(Ent).Brushtool.BackColor );
  WMIF( 'Pen (' + IntToStr( PenWidth ) + ',' +
                      IntToStr( PenPattern ) + ',' +
                      IntToStr( PenColor ) + ')' );
  WMIF( 'Brush (' + IntToStr( BPattern ) + ',' +
                                  IntToStr( BForeColor ) + ',' +
                                  IntToStr( BBackColor ) + ')' );
  If Ent.EntityID = idPolygon Then
  Begin
    s := 'Center ';
    Ent.Centroid( CX, CY );
    s := s + FloatToStrF( CX, fffixed, 21, 9 ) + ' ';
    s := s + FloatToStrF( CY, fffixed, 21, 9 );
    WMIF(S);
  End;
end;

procedure TmstProjectMIFExport.WritePolyline(Ent: TEzEntity);
Var
  i, j, temp,Parts: integer;
  s: String;
  PartCount, PrvCount: Longint;
Begin
  Parts := Ent.Points.Parts.Count;
  If Parts = 0 Then
    Parts := 1;
  If Parts > 1 Then
    WMIF( 'Pline Multiple ' + IntToStr( Parts ) )
  Else
    WMIF( 'Pline ' + IntToStr( Ent.Points.Count ) );
  PrvCount := 0;
  For i := 0 To Parts - 1 Do
  Begin
    If Parts = 1 Then
      PartCount := Ent.Points.Count
    Else
    Begin
      If i < ( Parts - 1 ) Then
        PartCount := Ent.Points.Parts[i + 1] - Ent.Points.Parts[i]
      Else
        PartCount := Ent.Points.Count - Ent.Points.Parts[i];
    End;
    If Parts > 1 Then
      WMIF( '  ' + IntToStr( PartCount ) );

    temp := 0;
    For j := PrvCount To PrvCount + PartCount - 1 Do
    Begin
      if FUseDecartCoords then
      begin
        S := FloatToStrF( Ent.Points.X[j], ffFixed, 21, 9 ) + ' ';
        S := S + FloatToStrF( Ent.Points.Y[j], ffFixed, 21, 9 );
      end
      else
      begin
        S := FloatToStrF( Ent.Points.Y[j], ffFixed, 21, 9 ) + ' ';
        S := S + FloatToStrF( Ent.Points.X[j], ffFixed, 21, 9 );
      end;
      WMIF( S );
      temp := j;
    End;
    PrvCount := temp;
  End;
  WritePolylineStyle( ENT );
end;

procedure TmstProjectMIFExport.WritePolylineStyle(Ent: TEzEntity);
Var
  Penwidth, PenPattern: integer;
  PenColor: TColor;
Begin
//  if TEzOpenedEntity( Ent ).PenTool.Width < 0 then
//    PenWidth := Abs(Round(TEzOpenedEntity( Ent ).PenTool.Width))
//  else
  begin
    PenWidth := FDrawBox.Grapher.RealToDistX(Abs(TEzOpenedEntity( Ent ).Pentool.Width));
  end;
  If PenWidth = 0 Then
    PenWidth := 1;
  PenPattern := TEzClosedEntity( Ent ).Pentool.Style + 1;
  PenColor := MIF2DelphiColor( TEzClosedEntity( Ent ).Pentool.Color );
  WMIF( 'Pen (' + IntToStr( PenWidth ) + ',' + IntToStr( PenPattern ) + ',' + IntToStr( PenColor ) + ')' );
  //Spline processing here.
  If Ent.EntityID = idSpline Then
    WMIF( 'Smooth' );
end;

end.


