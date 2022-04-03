unit ViewerU;

{$I EZ_FLAG.PAS}
interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Menus, ComCtrls, Math, Buttons, ExtCtrls, ToolWin,
  EzLib, EzBase, EzBaseGIS, EzCtrls, EzCmdLine, EzBasicCtrls;

type
  TfrmMain = class(TForm)
    MainMenu1: TMainMenu;
    File1: TMenuItem;
    Exit1: TMenuItem;
    DrawBox1: TEzDrawBox;
    CmdLine1: TEzCmdLine;
    PopupMenu1: TPopupMenu;
    EndOf2: TMenuItem;
    Midpoint2: TMenuItem;
    Centerpoint2: TMenuItem;
    Intersection2: TMenuItem;
    N19: TMenuItem;
    Preferences2: TMenuItem;
    N22: TMenuItem;
    N24: TMenuItem;
    N25: TMenuItem;
    N26: TMenuItem;
    N27: TMenuItem;
    Perpend2: TMenuItem;
    Help1: TMenuItem;
    About1: TMenuItem;
    SnapModes1: TMenuItem;
    Pan2: TMenuItem;
    ZoomRealtime2: TMenuItem;
    ZoomWindow1: TMenuItem;
    ZoomAll1: TMenuItem;
    ZoomPrevious1: TMenuItem;
    ZoomIn2: TMenuItem;
    ZoomOut2: TMenuItem;
    Zoom1: TMenuItem;
    ObjectStyle1: TMenuItem;
    SelectOne1: TMenuItem;
    Select2: TMenuItem;
    SelectRectangle1: TMenuItem;
    SelectCircle1: TMenuItem;
    SelectMuliObject1: TMenuItem;
    SelectPolyline1: TMenuItem;
    EditDatabaseInfo1: TMenuItem;
    Gis1: TEzGis;
    StatusBar1: TStatusBar;
    ToolBar1: TToolBar;
    BtnStop: TSpeedButton;
    BtnHand: TSpeedButton;
    BtnZoomRT: TSpeedButton;
    ZoomWBtn: TSpeedButton;
    ZoomAll: TSpeedButton;
    PriorViewBtn: TSpeedButton;
    ZoomIn: TSpeedButton;
    ZoomOut: TSpeedButton;
    SelectBtn: TSpeedButton;
    BtnMedidas: TSpeedButton;
    BtnRectSelect: TSpeedButton;
    BtnCircleSelect: TSpeedButton;
    BtnMultisel: TSpeedButton;
    BtnPolylineSel: TSpeedButton;
    ToolButton1: TToolButton;
    ToolButton2: TToolButton;
    ToolButton3: TToolButton;
    StartAnimation1: TMenuItem;
    EndAnimation1: TMenuItem;
    N1: TMenuItem;
    BtnStart: TSpeedButton;
    Timer1: TTimer;
    bar1: TProgressBar;
    procedure Exit1Click(Sender: TObject);
    procedure ZoomInClick(Sender: TObject);
    procedure ZoomOutClick(Sender: TObject);
    procedure ZoomWBtnClick(Sender: TObject);
    procedure ZoomAllClick(Sender: TObject);
    procedure BtnHandClick(Sender: TObject);
    procedure BtnMedidasClick(Sender: TObject);
    procedure PriorViewBtnClick(Sender: TObject);
    procedure BtnZoomRTClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure ComboLayer1Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure Object1Click(Sender: TObject);
    procedure About1Click(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
    procedure BtnStartClick(Sender: TObject);
    procedure BtnStopClick(Sender: TObject);
    procedure DrawBox1GridError(Sender: TObject);
    procedure CmdLine1StatusMessage(Sender: TObject;
      const AMessage: String);
    procedure Gis1Progress(Sender: TObject; Stage: TEzProgressStage;
      const Caption: String; Min, Max, Position: Integer);
    procedure DrawBox1MouseMove2D(Sender: TObject; Shift: TShiftState; X,
      Y: Integer; const WX, WY: Double);
    procedure DrawBox1BeginRepaint(Sender: TObject);
    procedure Gis1BeforeSymbolPaint(Sender: TObject; Layer: TEzBaseLayer;
      Recno: Integer; Grapher: TEzGrapher; Canvas: TCanvas;
      const Clip: TEzRect; Style: TEzSymbolTool);
  private
    { Private declarations }
    Finitialized: Boolean;
    FAnimateLayer: TEzBaseLayer;
    FStart: Boolean;
    FPNTLOC: Variant;
    FPNTDIR: Variant;
    procedure SetMenuitem;
  public
    { Public declarations }
    procedure CreateAllCar;
  end;

var
  frmMain: TfrmMain;

implementation

{$R *.DFM}

uses

  ezentities, ezSystem, EzConsts, EzActions
{$IFDEF LEVEL6}
  , Variants
{$ENDIF}
  ;

procedure TfrmMain.Exit1Click(Sender: TObject);
begin
  Close;
end;

procedure TfrmMain.ZoomInClick(Sender: TObject);
begin
  CmdLine1.Clear;
  CmdLine1.DoCommand(SCmdZoomIn, '');
end;

procedure TfrmMain.ZoomOutClick(Sender: TObject);
begin
  CmdLine1.Clear;
  CmdLine1.DoCommand(SCmdZoomOut, '');
end;

procedure TfrmMain.ZoomWBtnClick(Sender: TObject);
begin
  CmdLine1.Clear;
  CmdLine1.DoCommand(SCmdZoomWindow, '');
end;

procedure TfrmMain.ZoomAllClick(Sender: TObject);
begin
  CmdLine1.Clear;
  DrawBox1.ZoomToExtension;
end;

procedure TfrmMain.BtnHandClick(Sender: TObject);
begin
  CmdLine1.Clear;
  CmdLine1.DoCommand(SCmdHandScroll, '');
end;

procedure TfrmMain.BtnMedidasClick(Sender: TObject);
begin
  CmdLine1.DoCommand(SCmdMeasures, '');
end;

procedure TfrmMain.PriorViewBtnClick(Sender: TObject);
begin
  CmdLine1.Clear;
  DrawBox1.ZoomPrevious;
end;

procedure TfrmMain.BtnZoomRTClick(Sender: TObject);
begin
  CmdLine1.Clear;
  CmdLine1.DoCommand(SCmdRealTimeZoom, '');
end;

procedure TfrmMain.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  Timer1.Enabled:=false;
  VarClear(FPNTLOC);
  VarClear(FPNTDir);
end;

procedure TfrmMain.ComboLayer1Click(Sender: TObject);
begin
  DrawBox1.SetFocus;
end;

procedure TfrmMain.FormCreate(Sender: TObject);
var
  MapPath, Path: string;
begin
  Path:= AddSlash(ExtractFilePath(ExpandFilename('..\..\data\txt.fnt')));
  if not FileExists(Path+'txt.fnt') then
  begin
    ShowMessage('No font files found !');
  end;
  Ez_VectorFonts.AddFontFile(Path+'complex.fnt');
  Ez_VectorFonts.AddFontFile(Path+'txt.fnt');

  Ez_Symbols.FileName:= Path + 'symbols.ezs';
  if FileExists(Path + 'symbols.ezs') then
    Ez_Symbols.Open;

  // load line types
  Ez_LineTypes.FileName:=Path + 'Linetypes.ezl';
  if FileExists(Path + 'Linetypes.ezl') then
  begin
    Ez_LineTypes.Open;
  end;

  FStart := false; // false set to flag
  Gis1.Filename:= Path + 'animate.ezm';
  Gis1.Open;
  FAnimateLayer:= Gis1.Layers.LayerByName('ANIMATE');
  if FAnimateLayer = Nil then
  begin
    MapPath:= AddSlash(ExtractFilePath(Gis1.FileName));
    if FileExists(MapPath + 'ANIMATE.EZD') then
      SysUtils.DeleteFile(MapPath + 'ANIMATE.EZD');
    if FileExists(MapPath + 'ANIMATE.EZX') then
      SysUtils.DeleteFile(MapPath + 'ANIMATE.EZX');
    if FileExists(MapPath + 'ANIMATE.DBF') then
      SysUtils.DeleteFile(MapPath + 'ANIMATE.DBF');
    if FileExists(MapPath + 'ANIMATE.EZC') then
      SysUtils.DeleteFile(MapPath + 'ANIMATE.EZC');
    FAnimateLayer:= Gis1.Layers.CreateNewCosmethic(MapPath + 'ANIMATE');
    FAnimateLayer.LayerInfo.IsAnimationLayer:= True;
  end;
  DrawBox1.zoomtoextension;
end;

procedure TfrmMain.SetMenuitem;
//var
  //Enabled: Boolean;
  //NumSel: Integer;
begin
  //NumSel := DrawBox1.Selection.NumSelected;
  //Enabled := NumSel > 0;
end;

procedure TfrmMain.Object1Click(Sender: TObject);
begin
  SetMenuitem;
end;

procedure TfrmMain.About1Click(Sender: TObject);
begin
  Application.MessageBox('EzGis Animation v1.0' + #13#13 +
    'ANIMATION LAYER EXAMPLE ON DELPHI' + #13#13 +
    '(c) 2002 EzSoft Engineering',
    'EzGis', MB_OK);
end;

procedure TfrmMain.Timer1Timer(Sender: TObject);
var
  Ent: TEzEntity;
  Angle: double;

  // RETURN CAR'S NEXT POINT LOCATION

  function GetNextNode(ENT: TEzEntity; RECNO: integer; var Angle: double): TEzPoint;
  var
    NO: integer;
    Layer: TEzBaseLayer;
    Road: TEzEntity;
    PT1, PT2: TEzPoint;
  begin
    Layer := Gis1.Layers.LayerByName('ANroads_');
    Road := Layer.LoadEntityWithRecNo(RecNo);
    if Road=nil then Exit;

    NO := FPNTLoc[RecNO];
    PT1 := Point2d(Road.points[No].x, Road.points[No].y); //for angle calculation

    // Increase Node Number and Direction Check
    if FPNTDir[RecNo] = 0 then
      if NO = (Road.points.count - 1) then begin
        NO := Road.points.count - 1;
        FPNTDir[RecNo] := 1;
      end else INC(NO)
    else if NO = 0 then begin
      NO := 0;
      FPNTDir[RecNo] := 0;
    end else DEC(NO);

    Result := Point2d(Road.points[No].x, Road.points[No].y);
    FPNTLoc[RecNO] := No;

    PT2 := Point2d(Road.points[No].x, Road.points[No].y); //for angle calculation
    Angle := Angle2D(Pt1, Pt2); //for angle calculation
    Road.free;
  end;

begin
  if not Assigned(FAnimateLayer) then Exit;
  Timer1.Enabled := False;

  FAnimateLayer.First;
  while not FAnimateLayer.Eof do
  begin
    try
      if FAnimateLayer.RecIsDeleted then Continue;
      Ent := FAnimateLayer.RecLoadEntity;
      try
        if Ent.EntityID = idPlace then
        begin
          Ent.Points[0] := GetNextNode(ENT, FAnimateLayer.Recno, Angle);
          TEzPlace(Ent).SymbolTool.Rotangle := Angle + degtorad(180);
          FAnimateLayer.UpdateEntity(FAnimateLayer.Recno, Ent);
        end;
      finally
        Ent.Free;
      end;
    finally
      FAnimateLayer.Next;
    end;
  end;

  DrawBox1.Invalidate; //REDRAW
  Timer1.Enabled := True;
end;

procedure TfrmMain.BtnStartClick(Sender: TObject);
var
  Layer: TEzBaseLayer;
  I: Integer;
  Found: Boolean;
begin
  Fstart := true;
  FAnimateLayer := nil;
  Found := False;
  for I := 0 to Gis1.Layers.Count - 1 do
  begin
    Layer := Gis1.Layers[I];
    if Layer.Layerinfo.IsAnimationLayer then
    begin
      FAnimateLayer := Layer;
      Found := True;
      Break; { Only one animation layer for now }
    end;
  end;

  if not Found then
  begin
    ShowMessage('NEED ONE OR MORE ANIMATION LAYERS ON THE MAP!');
    Exit;
  end;
  CreateAllCar; // ANIMATE LAYER ENTITY CREATION
  Timer1.Enabled := True;
end;

procedure TfrmMain.BtnStopClick(Sender: TObject);
begin
  Fstart := false;
  Timer1.Enabled := false;
end;

procedure TfrmMain.CreateAllCar;
var
  Layer: TEzBaseLayer;
  Ent: TEzEntity;
  PNT: TEzEntity;
  X, Y: Double;
  i: Integer;
begin
  // ANIMATE LAYER'S ALL ENTITY DELETE

  if Finitialized then Exit;

  Finitialized:= true;

  // CREATE POINT ENTITY TO ANIMATION LAYER
  if FAnimateLayer.RecordCount=0 then
  begin
    Layer := Gis1.Layers.LayerByName('ANroads_');
    if Layer = Nil then Exit;
    Layer.First;
    while not Layer.Eof do
    begin
      Ent := Layer.RecLoadEntity;
      X := Ent.Points[0].X;
      Y := Ent.Points[0].Y;
      PNT := TEzPlace.CreateEntity(POINT2D(x, y));
      with TEzPlace(PNT).SymbolTool do
      begin
        Height := DrawBox1.Grapher.PointsToDistY(8); // Calculation of Real Point Height
        case FAnimateLayer.Recno mod 3 of
          0 : Index := $016;
          1 : Index := $014;
          2 : Index := $012;
        end;
      end; //with
      FAnimateLayer.AddEntity(PNT);
      PNT.free; // MUST Free Required...
      Layer.Next;
    end;
  end;

  // Prepare Value for Storing Node Location and Direction.
  VarClear(FPNTLOC);
  VarClear(FPNTDIR);
  FPNTLOC := vararraycreate([1, FAnimateLayer.RecordCount], Varinteger);
  FPNTDir := vararraycreate([1, FAnimateLayer.RecordCount], Varinteger);
  for i := 1 to FAnimateLayer.RecordCount do
  begin
    FPNTLOC[i] := 0;
    FPNTDir[i] := 0;
  end;
end;

procedure TfrmMain.DrawBox1GridError(Sender: TObject);
begin
  StatusBar1.Panels[0].Text := 'Grid too dense to display';
end;

procedure TfrmMain.CmdLine1StatusMessage(Sender: TObject;
  const AMessage: String);
begin
  StatusBar1.Panels[0].Text := AMessage;
end;

procedure TfrmMain.Gis1Progress(Sender: TObject; Stage: TEzProgressStage;
  const Caption: String; Min, Max, Position: Integer);
begin
  case Stage of
    epsStarting:
      begin
        bar1.Visible := True;
        bar1.Min := Min;
        bar1.Max := Max;
        bar1.Position := 0;
      end;
    epsMessage:
      begin
        bar1.Position := Position;
      end;
    epsEnding:
      begin
        bar1.Visible := False;
      end;
    epsUpdating:
      begin
      end;
  end;
end;

procedure TfrmMain.DrawBox1MouseMove2D(Sender: TObject; Shift: TShiftState;
  X, Y: Integer; const WX, WY: Double);
begin
  StatusBar1.Panels[1].Text := DrawBox1.CoordsToDisplayText(WX, WY);
end;

procedure TfrmMain.DrawBox1BeginRepaint(Sender: TObject);
begin
  StatusBar1.Panels[0].Text := '';
end;

procedure TfrmMain.Gis1BeforeSymbolPaint(Sender: TObject;
  Layer: TEzBaseLayer; Recno: Integer; Grapher: TEzGrapher;
  Canvas: TCanvas; const Clip: TEzRect; Style: TEzSymbolTool);
begin
  Style.Height := Grapher.PointsToDistY(9);
end;

end.

