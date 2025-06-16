unit uMStClassesMPMIFExport;

interface

uses
  SysUtils, Contnrs, Math, Graphics, StrUtils, DB, Classes,
  EzBaseGIS, EzLib, EzBase, EzEntities,
  uGC,
  uMStConsts,
  uMStKernelGISUtils, uMStKernelIBX, uMStClassesProjectsMP,
  uMStClassesProjects;

type
  TGetProjectEvent = function (Sender: TObject; const ProjectId: Integer): TmstProject of object;
  TmstMPMIFExport = class
  private
    FFileName: string;
    FDrawBox: TezBaseDrawBox;
    FUseDecartCoords: Boolean;
    FMpObjects: TObjectList;
    FEntites: TList;
    FLayer: TEzBaseLayer;
    procedure SetDrawBox(const Value: TezBaseDrawBox);
    procedure SetUseDecartCoords(const Value: Boolean);
    procedure SetLayer(const Value: TEzBaseLayer);
  strict private
    FMif, FMid: Text;
    procedure ProcessLayer(const LayerName: string);
    procedure StartWrite();
    procedure FinishWrite();
    procedure WriteEntity(MpObj: TmstMpObject; Ent: TEzEntity);
    procedure WriteFields(MpObj: TmstMpObject; Ent: TEzEntity);
    function DecorateFieldValue(const FieldValue: string; MaxLen: Integer): string;
    function GetDateStr(const aDate: TDateTime): string;
    function GetBoolStr(const BoolValue: Boolean): string;
    procedure WriteHeader();
    procedure WMid(const S: String);
    procedure WMif(const S: String);
  strict private
    procedure CalcExtents(out X1, Y1, X2, Y2: Double);
    function MIF2DelphiColor( iColor: Integer ): Integer;
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
    procedure AddObject(MpObj: TmstMPObject; aEntity: TEzEntity);
    procedure Save(const aFileName: string);
    //
    property DrawBox: TEzBaseDrawBox read FDrawBox write SetDrawBox;
    property Layer: TEzBaseLayer read FLayer write SetLayer;
    property UseDecartCoords: Boolean read FUseDecartCoords write SetUseDecartCoords;
  end;

implementation

{ TmstMPMIFExport }

procedure TmstMPMIFExport.AddObject(MpObj: TmstMPObject; aEntity: TEzEntity);
begin
  FMpObjects.Add(MpObj);
  FEntites.Add(aEntity);
end;

procedure TmstMPMIFExport.CalcExtents(out X1, Y1, X2, Y2: Double);
begin
  FLayer.MaxMinExtents(X1, Y1, X2, Y2)
end;

constructor TmstMPMIFExport.Create;
begin
  FMpObjects := TObjectList.Create;
  FEntites := TList.Create;
end;

function TmstMPMIFExport.DecorateFieldValue(const FieldValue: string; MaxLen: Integer): string;
begin
  Result := StringReplace(FieldValue, '"', '""', [rfReplaceAll]);
  if Length(Result) > MaxLen then
    SetLength(Result, MaxLen);
  Result := '"' + Result + '"';
end;

destructor TmstMPMIFExport.Destroy;
begin
  FEntites.Free;
  FMpObjects.Free;
  inherited;
end;

procedure TmstMPMIFExport.FinishWrite;
begin
  CloseFile(FMif);
  CloseFile(FMid);
end;

function TmstMPMIFExport.GetBoolStr(const BoolValue: Boolean): string;
begin
  Result := StrUtils.IfThen(BoolValue, 'T', 'F');
end;

function TmstMPMIFExport.GetDateStr(const aDate: TDateTime): string;
begin
  if aDate = 0 then
    Result := ''
  else
    Result := FormatDateTime('dd.mm.yyyy', aDate);
end;

function TmstMPMIFExport.MIF2DelphiColor(iColor: Integer): Integer;
Var
  sTmp: String;
  code: integer;
Begin
  sTmp := IntToHex( iColor, 6 );
  val( '$' + Copy( sTmp, 5, 2 ) + Copy( sTmp, 3, 2 ) + Copy( sTmp, 1, 2 ), result, code );
end;

procedure TmstMPMIFExport.ProcessLayer(const LayerName: string);
begin

end;

procedure TmstMPMIFExport.Save(const aFileName: string);
var
  C: Char;
  I: Integer;
  MpObj: TmstMpObject;
  Ent: TEzEntity;
begin
  FFileName := aFileName;
  StartWrite();
  C := SysUtils.DecimalSeparator;
  SysUtils.DecimalSeparator := '.';
  try
    for I := 0 to FMpObjects.Count - 1 do
    begin
      MpObj := TmstMpObject(FMpObjects[I]);
      Ent := TEzEntity(FEntites[I]);
      WriteEntity(MpObj, Ent);
    end;
  finally
    SysUtils.DecimalSeparator := C;
    FinishWrite();
  end;
end;

procedure TmstMPMIFExport.SetDrawBox(const Value: TezBaseDrawBox);
begin
  FDrawBox := Value;
end;

procedure TmstMPMIFExport.SetLayer(const Value: TEzBaseLayer);
begin
  FLayer := Value;
end;

procedure TmstMPMIFExport.SetUseDecartCoords(const Value: Boolean);
begin
  FUseDecartCoords := Value;
end;

procedure TmstMPMIFExport.StartWrite;
begin
  AssignFile(FMif, FFileName);
  AssignFile(FMid, ChangeFileExt(FFileName, '.mid'));
  Rewrite(FMif);
  Rewrite(FMid);
  WriteHeader();
end;

procedure TmstMPMIFExport.WMid(const S: String);
begin
  Writeln(FMid, S);
end;

procedure TmstMPMIFExport.WMif(const S: String);
begin
  Writeln(FMif, S);
end;

procedure TmstMPMIFExport.WriteArc(Ent: TEzEntity);
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

procedure TmstMPMIFExport.WriteEllipse(Ent: TEzEntity);
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

procedure TmstMPMIFExport.WriteEntity;
var
  AddFields: Boolean;
begin
  AddFields := True;
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
    WriteFields(MpObj, Ent);
end;

procedure TmstMPMIFExport.WriteFields;
Var
  s: String;
begin
  S := '';
//  WMIF('  ' + SF_CLASS_ID + ' Char(50) ');
  S := S + DecorateFieldValue(MpObj.MpClassGuid, 50) + ',';
//  WMIF('  ' + SF_CLASS_NAME + ' Char(255) ');
  S := S + DecorateFieldValue(MpObj.MpClassName, 255) + ',';
//  WMIF('  ' + SF_OBJ_ID + ' Char(36) ');
  S := S + DecorateFieldValue(MpObj.MPObjectGuid, 36) + ',';
//  WMIF('  ' + SF_LINKED_OBJ_ID + ' Char(36) ');
  S := S + DecorateFieldValue(MpObj.LinkedObjectGuid, 36) + ',';
//  WMIF('  ' + SF_ADDRESS + ' Char(255) ');
  S := S + DecorateFieldValue(MpObj.Address, 255) + ',';
//  WMIF('  ' + SF_DOC_NUMBER + ' Char(12) ');
  S := S + DecorateFieldValue(MpObj.DocNumber, 12) + ',';
//  WMIF('  ' + SF_DOC_DATE + ' Char(10) ');
  S := S + DecorateFieldValue(GetDateStr(MpObj.DocDate), 10) + ',';
//  WMIF('  ' + SF_PROJECT_NAME + ' Char(255) ');
  S := S + DecorateFieldValue(MpObj.ProjectName, 255) + ',';
//  WMIF('  ' + SF_REQUEST_NUMBER + ' Char(12) ');
  S := S + DecorateFieldValue(MpObj.RequestNumber, 12) + ',';
//  WMIF('  ' + SF_REQUEST_DATE + ' Char(10) ');
  S := S + DecorateFieldValue(GetDateStr(MpObj.RequestDate), 10) + ',';
//  WMIF('  ' + SF_DRAW_DATE + ' Char(10) ');
  S := S + DecorateFieldValue(GetDateStr(MpObj.DrawDate), 10) + ',';
//  WMIF('  ' + SF_OWNER + ' Char(255) ');
  S := S + DecorateFieldValue(MpObj.Owner, 255) + ',';
//  WMIF('  ' + SF_CUSTOMER + ' Char(255) ');
  S := S + DecorateFieldValue(MpObj.CustomerOrg, 255) + ',';
//  WMIF('  ' + SF_EXECUTOR + ' Char(255) ');
  S := S + DecorateFieldValue(MpObj.ExecutorOrg, 255) + ',';
//  WMIF('  ' + SF_DRAW_ORG + ' Char(255) ');
  S := S + DecorateFieldValue(MpObj.DrawOrg, 255) + ',';
//  WMIF('  ' + SF_ROTATION + ' Integer ');
  S := S + IntToStr(MpObj.Rotation) + ',';
//  WMIF('  ' + SF_DRAWN + ' Logical ');
  S := S + GetBoolStr(MpObj.Drawn) + ',';
//  WMIF('  ' + SF_CONFIRMED + ' Logical ');
  S := S + GetBoolStr(MpObj.Confirmed) + ',';
//  WMIF('  ' + SF_DISMANTLED + ' Logical ');
  S := S + GetBoolStr(MpObj.Dismantled) + ',';
//  WMIF('  ' + SF_ARCHIVED + ' Logical ');
  S := S + GetBoolStr(MpObj.Archived) + ',';
//  WMIF('  ' + SF_UNDERGROUND + ' Logical ');
  S := S + GetBoolStr(MpObj.Underground) + ',';
//  WMIF('  ' + SF_DIAMETER + ' Integer ');
  S := S + IntToStr(MpObj.Diameter) + ',';
//  WMIF('  ' + SF_VOLTAGE + ' Integer ');
  S := S + IntToStr(MpObj.Voltage) + ',';
//  WMIF('  ' + SF_VOLTAGE_TXT + ' Char(255) ');
  S := S + DecorateFieldValue(MpObj.VoltageText(), 255) + ',';
//  WMIF('  ' + SF_PIPE_COUNT + ' Integer ');
  S := S + IntToStr(MpObj.PipeCount) + ',';
//  WMIF('  ' + SF_SEWER + ' Logical ');
  S := S + GetBoolStr(MpObj.Sewer) + ',';
//  WMIF('  ' + SF_PRESSURE_TXT + ' Logical ');
  S := S + DecorateFieldValue(MpObj.PressureText(), 255) + ',';
//  WMIF('  ' + SF_MATERIAL + ' Char(255) ');
  S := S + DecorateFieldValue(MpObj.Material, 255) + ',';
//  WMIF('  ' + SF_TOP + ' Char(255) ');
  S := S + DecorateFieldValue(MpObj.Top, 255) + ',';
//  WMIF('  ' + SF_BOTTOM + ' Char(255) ');
  S := S + DecorateFieldValue(MpObj.Bottom, 255) + ',';
//  WMIF('  ' + SF_FLOOR + ' Char(255) ');
  S := S + DecorateFieldValue(MpObj.Floor, 255) + ',';
//  WMIF('  ' + SF_PROJECTED + ' Logical ');
  S := S + GetBoolStr(MpObj.Projected) + ',';
//  WMIF('  ' + SF_HAS_CERTIF + ' Logical ');
  S := S + GetBoolStr(MpObj.HasCertif) + ',';
//  WMIF('  ' + SF_CERTIF_NUMBER + ' Char(12) ');
  S := S + DecorateFieldValue(MpObj.CertifNumber, 12) + ',';
//  WMIF('  ' + SF_CERTIF_DATE + ' Char(10) ');
  S := S + DecorateFieldValue(GetDateStr(MpObj.CertifDate), 10);
  //
  WMID( S );
end;

procedure TmstMPMIFExport.WriteHeader;
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
  WMIF(S);

  WMIF('Columns 36');
  WMIF('  ' + SF_CLASS_ID + ' Char(50) ');
  WMIF('  ' + SF_CLASS_NAME + ' Char(255) ');
//    WMIF('  ' + SF_DB_ID + ' ');
  WMIF('  ' + SF_OBJ_ID + ' Char(36) ');
  WMIF('  ' + SF_LINKED_OBJ_ID + ' Char(36) ');
  WMIF('  ' + SF_ADDRESS + ' Char(255) ');
  WMIF('  ' + SF_DOC_NUMBER + ' Char(12) ');
  WMIF('  ' + SF_DOC_DATE + ' Char(10) ');
  WMIF('  ' + SF_PROJECT_NAME + ' Char(255) ');
  WMIF('  ' + SF_REQUEST_NUMBER + ' Char(12) ');
  WMIF('  ' + SF_REQUEST_DATE + ' Char(10) ');
  WMIF('  ' + SF_DRAW_DATE + ' Char(10) ');
  WMIF('  ' + SF_OWNER + ' Char(255) ');
  WMIF('  ' + SF_CUSTOMER + ' Char(255) ');
  WMIF('  ' + SF_EXECUTOR + ' Char(255) ');
  WMIF('  ' + SF_DRAWER_ORG + ' Char(255) ');
  //
  WMIF('  ' + SF_ROTATION + ' Integer ');
  WMIF('  ' + SF_DRAWN + ' Logical ');
  WMIF('  ' + SF_CONFIRMED + ' Logical ');
  WMIF('  ' + SF_CONFIRM_DATE + ' Char(10) ');
  WMIF('  ' + SF_DISMANTLED + ' Logical ');
  WMIF('  ' + SF_ARCHIVED + ' Logical ');
  WMIF('  ' + SF_UNDERGROUND + ' Logical ');
  WMIF('  ' + SF_DIAMETER + ' Integer ');
  WMIF('  ' + SF_VOLTAGE + ' Integer ');
  WMIF('  ' + SF_VOLTAGE_TXT + ' Char(255) ');
  WMIF('  ' + SF_PIPE_COUNT + ' Integer ');
  WMIF('  ' + SF_SEWER + ' Logical ');
  WMIF('  ' + SF_PRESSURE_TXT + ' Char(255) ');
  WMIF('  ' + SF_MATERIAL + ' Char(255) ');
  WMIF('  ' + SF_TOP + ' Char(255) ');
  WMIF('  ' + SF_BOTTOM + ' Char(255) ');
  WMIF('  ' + SF_FLOOR + ' Char(255) ');
  WMIF('  ' + SF_PROJECTED + ' Logical ');
  WMIF('  ' + SF_HAS_CERTIF + ' Logical ');
  WMIF('  ' + SF_CERTIF_NUMBER + ' Char(12) ');
  WMIF('  ' + SF_CERTIF_DATE + ' Char(10) ');
////  Линии
////  ID
////  INFO
////  DIAMETER
////  VOLTAGE
//  WMIF('  LINE_ID Integer ');
//  WMIF('  LINE_INFO Char(255) ');
//  WMIF('  LINE_DIAMETER Char(50) ');
//  WMIF('  LINE_VOLTAGE Char(50) ');
////  Слои
////  NAME
//  WMIF('  LAYER_NAME Char(255) ');

  WMIF( 'Data' );
end;

procedure TmstMPMIFExport.WritePoint(Ent: TEzEntity);
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

procedure TmstMPMIFExport.WritePolygon(Ent: TEzEntity);
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

procedure TmstMPMIFExport.WritePolygonStyle(Ent: TEzEntity);
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

procedure TmstMPMIFExport.WritePolyline(Ent: TEzEntity);
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

procedure TmstMPMIFExport.WritePolylineStyle(Ent: TEzEntity);
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
