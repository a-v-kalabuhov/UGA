unit fMain;

{***********************************************************}
{     EzGIS/CAD Components   - TEzADO demo                  }
{   (c) 2002 EzSoft Engineering                             }
{         All Rights Reserved                               }
{***********************************************************}

{$I EZ_FLAG.PAS}
interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms,
  Dialogs, Menus, ComCtrls, ToolWin, EzBaseGIS, EzCtrls, EzCmdLine,
  Buttons, ExtCtrls, fPrnPg, Printers, Clipbrd, fAerial,
  EzLib, fEditDB, EzBasicCtrls, EzBase, StdCtrls, EzADOGIS, Db, ADODB,
  Mask, EzThematics, EzUtils, DBTables, EzBDEGIS, fLegend,
  EzMiscelCtrls;

type

  TForm1 = class(TForm)
    MainMenu1: TMainMenu;
    File1: TMenuItem;
    New1: TMenuItem;
    Open1: TMenuItem;
    Save1: TMenuItem;
    N1: TMenuItem;
    Saveclipped1: TMenuItem;
    N49: TMenuItem;
    Config1: TMenuItem;
    Print1: TMenuItem;
    N4: TMenuItem;
    Exit1: TMenuItem;
    Edit1: TMenuItem;
    Undo1: TMenuItem;
    N5: TMenuItem;
    Cut1: TMenuItem;
    Copy1: TMenuItem;
    Paste1: TMenuItem;
    Delete1: TMenuItem;
    N9: TMenuItem;
    Copyclipboard1: TMenuItem;
    N47: TMenuItem;
    Group1: TMenuItem;
    Ungroup1: TMenuItem;
    N41: TMenuItem;
    ToFront1: TMenuItem;
    ToBack1: TMenuItem;
    N12: TMenuItem;
    Orto1: TMenuItem;
    Grid1: TMenuItem;
    View1: TMenuItem;
    Regen1: TMenuItem;
    N7: TMenuItem;
    Pan1: TMenuItem;
    N20: TMenuItem;
    ZoomIn1: TMenuItem;
    ZoomOut1: TMenuItem;
    ZoomRealtime1: TMenuItem;
    Window1: TMenuItem;
    Previous1: TMenuItem;
    Selection1: TMenuItem;
    ZoomLayer1: TMenuItem;
    All1: TMenuItem;
    N18: TMenuItem;
    Addmarker2: TMenuItem;
    ClearMarkers1: TMenuItem;
    Object1: TMenuItem;
    SelectTarget1: TMenuItem;
    Select3: TMenuItem;
    SelectRectangle2: TMenuItem;
    SelectCircle2: TMenuItem;
    SelectMultiObject1: TMenuItem;
    SelectPolyline2: TMenuItem;
    N2: TMenuItem;
    EditDatabaseInfo2: TMenuItem;
    N17: TMenuItem;
    Combine1: TMenuItem;
    Fit2: TMenuItem;
    N28: TMenuItem;
    CLIP1: TMenuItem;
    Fit1: TMenuItem;
    N13: TMenuItem;
    Trim1: TMenuItem;
    Extend1: TMenuItem;
    Break1: TMenuItem;
    Fillet1: TMenuItem;
    N29: TMenuItem;
    ToPolyline1: TMenuItem;
    ToPolygon1: TMenuItem;
    N16: TMenuItem;
    Revertdirection1: TMenuItem;
    Define1: TMenuItem;
    Line1: TMenuItem;
    Polyline1: TMenuItem;
    Polygon1: TMenuItem;
    Rectangle1: TMenuItem;
    N21: TMenuItem;
    Arc1: TMenuItem;
    Ellipse1: TMenuItem;
    Spline1: TMenuItem;
    Text1: TMenuItem;
    Symbol1: TMenuItem;
    N23: TMenuItem;
    Picture1: TMenuItem;
    PersistentBitmap1: TMenuItem;
    BandsBitmap1: TMenuItem;
    GeoreferencedImage1: TMenuItem;
    Tool1: TMenuItem;
    LineStyle1: TMenuItem;
    FillStyle1: TMenuItem;
    SymbolStyle1: TMenuItem;
    TextStyle1: TMenuItem;
    N36: TMenuItem;
    DrawingAids1: TMenuItem;
    EndPoint1: TMenuItem;
    MidPoint1: TMenuItem;
    Center1: TMenuItem;
    Intersect1: TMenuItem;
    Perpend1: TMenuItem;
    N15: TMenuItem;
    Aerial1: TMenuItem;
    N33: TMenuItem;
    Symbols2: TMenuItem;
    LinetypeEditor1: TMenuItem;
    Options2: TMenuItem;
    Select1: TMenuItem;
    SelectAll1: TMenuItem;
    UnSelectAll1: TMenuItem;
    N30: TMenuItem;
    Entire1: TMenuItem;
    N32: TMenuItem;
    CopySelectionTo1: TMenuItem;
    Table1: TMenuItem;
    Import1: TMenuItem;
    Export1: TMenuItem;
    N42: TMenuItem;
    Restructure1: TMenuItem;
    Pack1: TMenuItem;
    Options1: TMenuItem;
    Hints1: TMenuItem;
    Coords1: TMenuItem;
    ShowCmdLine1: TMenuItem;
    N14: TMenuItem;
    Snap1: TMenuItem;
    Snap2: TMenuItem;
    Map1: TMenuItem;
    Reindex1: TMenuItem;
    N46: TMenuItem;
    Layers1: TMenuItem;
    N39: TMenuItem;
    Browse1: TMenuItem;
    N11: TMenuItem;
    QuickUpdateExtension1: TMenuItem;
    Update1: TMenuItem;
    N3: TMenuItem;
    ClipBoundary1: TMenuItem;
    ClippedArea1: TMenuItem;
    PolygonClip1: TMenuItem;
    SetClipBoundaryfromSelection1: TMenuItem;
    Cancelclipped1: TMenuItem;
    Help1: TMenuItem;
    About1: TMenuItem;
    Point1: TMenuItem;
    JustifiedText1: TMenuItem;
    DrawBox1: TEzDrawBox;
    CmdLine1: TEzCmdLine;
    GIS1: TEzBDEGis;
    MainToolbar: TPanel;
    BtnHand: TSpeedButton;
    BtnZoomRT: TSpeedButton;
    ZoomWBtn: TSpeedButton;
    ZoomAll: TSpeedButton;
    PriorViewBtn: TSpeedButton;
    ZoomIn: TSpeedButton;
    ZoomOut: TSpeedButton;
    BtnEditDB: TSpeedButton;
    SelectBtn: TSpeedButton;
    BtnRectSelect: TSpeedButton;
    BtnCircleSelect: TSpeedButton;
    BtnMultisel: TSpeedButton;
    BtnPolylineSel: TSpeedButton;
    BtnMedidas: TSpeedButton;
    Dock971: TPanel;
    EditToolbar: TPanel;
    BtnPaste: TSpeedButton;
    BtnCut: TSpeedButton;
    BtnCopy: TSpeedButton;
    BtnUndo: TSpeedButton;
    SpeedButton7: TSpeedButton;
    SpeedButton9: TSpeedButton;
    ViewToolbar: TPanel;
    BtnAerialView: TSpeedButton;
    BtnSymbolEditor: TSpeedButton;
    BtnTable: TSpeedButton;
    DrawToolbar: TPanel;
    BtnLine: TSpeedButton;
    BtnPolyline: TSpeedButton;
    BtnPolygon: TSpeedButton;
    BtnRect: TSpeedButton;
    BtnArc: TSpeedButton;
    BtnEllipse: TSpeedButton;
    BtnSpline: TSpeedButton;
    BtnSymbol: TSpeedButton;
    BtnAutoLabel: TSpeedButton;
    BtnTxtPlace: TSpeedButton;
    btnDimHorz: TSpeedButton;
    btnDimVert: TSpeedButton;
    btnDimPar: TSpeedButton;
    btnPoint: TSpeedButton;
    FileToolbar: TPanel;
    BtnPrint: TSpeedButton;
    BtnSave: TSpeedButton;
    BtnOpen: TSpeedButton;
    BtnNew: TSpeedButton;
    BtnImport: TSpeedButton;
    btnExit: TSpeedButton;
    Panel1: TPanel;
    BtnMove: TSpeedButton;
    BtnScale: TSpeedButton;
    BtnRotate: TSpeedButton;
    BtnReshape: TSpeedButton;
    BtnInsVertex: TSpeedButton;
    BtnDelVertex: TSpeedButton;
    HGuides: TSpeedButton;
    VGuides: TSpeedButton;
    BtnLayers: TSpeedButton;
    EzGeorefImage1: TEzGeorefImage;
    Raster2: TMenuItem;
    Emf1: TMenuItem;
    OpenDialog1: TOpenDialog;
    BtnCircleCR: TSpeedButton;
    BtnCircle3P: TSpeedButton;
    btnSnapNearest: TSpeedButton;
    btnSnapEnd: TSpeedButton;
    btnSnapMiddle: TSpeedButton;
    btnSnapInters: TSpeedButton;
    btnSnapCenter: TSpeedButton;
    btnSnapPerpend: TSpeedButton;
    BtnSnapTangent: TSpeedButton;
    SaveDialog1: TSaveDialog;
    Reproject1: TMenuItem;
    StatusBar1: TStatusBar;
    bar1: TProgressBar;
    N6: TMenuItem;
    AddEntity1: TMenuItem;
    N19: TMenuItem;
    OpenDialog2: TOpenDialog;
    BandedTiff1: TMenuItem;
    Panel2: TPanel;
    BtnPic: TSpeedButton;
    btnBands: TSpeedButton;
    SpeedButton2: TSpeedButton;
    btnJustText: TSpeedButton;
    btnFittedText: TSpeedButton;
    BtnBannerText: TSpeedButton;
    btnCallout: TSpeedButton;
    btnBulletLeader: TSpeedButton;
    BtnText: TSpeedButton;
    Explode2: TMenuItem;
    Offset1: TMenuItem;
    Join1: TMenuItem;
    btnOffset: TSpeedButton;
    BtnRefresh: TSpeedButton;
    BtnTIFF: TSpeedButton;
    MoveGuidelines1: TMenuItem;
    Preferences1: TEzModifyPreferences;
    N8: TMenuItem;
    ConvertAutoCADDWGDXF1: TMenuItem;
    OpenDialog3: TOpenDialog;
    N22: TMenuItem;
    HotSpot1: TMenuItem;
    SaveDialog2: TSaveDialog;
    N24: TMenuItem;
    CreateThumnaillbitmap1: TMenuItem;
    SaveDialog3: TSaveDialog;
    N25: TMenuItem;
    Clippolygon1: TMenuItem;
    LayerGridBox1: TEzLayerGridBox;
    N26: TMenuItem;
    Makeblockfromselection1: TMenuItem;
    ARRAYfromselection1: TMenuItem;
    Deleterepetitions1: TMenuItem;
    ThematicBuilder1: TEzThematicBuilder;
    N27: TMenuItem;
    ThematicsEditor1: TMenuItem;
    BtnGraphInfo: TSpeedButton;
    BtnSplineText: TSpeedButton;
    BtnSplineTextTT: TSpeedButton;
    N34: TMenuItem;
    Preferences2: TMenuItem;
    N35: TMenuItem;
    Viewportconfig1: TMenuItem;
    N37: TMenuItem;
    Gisconfig1: TMenuItem;
    N38: TMenuItem;
    Layersconfig1: TMenuItem;
    Database1: TDatabase;
    procedure New1Click(Sender: TObject);
    procedure Exit1Click(Sender: TObject);
    procedure Open1Click(Sender: TObject);
    procedure Layers1Click(Sender: TObject);
    procedure Save1Click(Sender: TObject);
    procedure BtnHandClick(Sender: TObject);
    procedure BtnEditDBClick(Sender: TObject);
    procedure BtnZoomRTClick(Sender: TObject);
    procedure ZoomWBtnClick(Sender: TObject);
    procedure ZoomAllClick(Sender: TObject);
    procedure PriorViewBtnClick(Sender: TObject);
    procedure ZoomInClick(Sender: TObject);
    procedure ZoomOutClick(Sender: TObject);
    procedure SelectBtnClick(Sender: TObject);
    procedure BtnMedidasClick(Sender: TObject);
    procedure BtnRectSelectClick(Sender: TObject);
    procedure BtnCircleSelectClick(Sender: TObject);
    procedure BtnMultiselClick(Sender: TObject);
    procedure BtnPolylineSelClick(Sender: TObject);
    procedure btnPointClick(Sender: TObject);
    procedure BtnLineClick(Sender: TObject);
    procedure BtnPolylineClick(Sender: TObject);
    procedure BtnPolygonClick(Sender: TObject);
    procedure BtnRectClick(Sender: TObject);
    procedure BtnArcClick(Sender: TObject);
    procedure BtnEllipseClick(Sender: TObject);
    procedure BtnSplineClick(Sender: TObject);
    procedure btnJustTextClick(Sender: TObject);
    procedure btnFittedTextClick(Sender: TObject);
    procedure BtnBannerTextClick(Sender: TObject);
    procedure btnCalloutClick(Sender: TObject);
    procedure btnBulletLeaderClick(Sender: TObject);
    procedure BtnSymbolClick(Sender: TObject);
    procedure BtnTxtPlaceClick(Sender: TObject);
    procedure BtnPicClick(Sender: TObject);
    procedure BtnAutoLabelClick(Sender: TObject);
    procedure btnDimHorzClick(Sender: TObject);
    procedure btnDimVertClick(Sender: TObject);
    procedure btnDimParClick(Sender: TObject);
    procedure BtnMoveClick(Sender: TObject);
    procedure BtnScaleClick(Sender: TObject);
    procedure BtnRotateClick(Sender: TObject);
    procedure BtnReshapeClick(Sender: TObject);
    procedure BtnInsVertexClick(Sender: TObject);
    procedure BtnDelVertexClick(Sender: TObject);
    procedure HGuidesClick(Sender: TObject);
    procedure VGuidesClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure Undo1Click(Sender: TObject);
    procedure Cut1Click(Sender: TObject);
    procedure Copy1Click(Sender: TObject);
    procedure Paste1Click(Sender: TObject);
    procedure Delete1Click(Sender: TObject);
    procedure Copyclipboard1Click(Sender: TObject);
    procedure Group1Click(Sender: TObject);
    procedure Ungroup1Click(Sender: TObject);
    procedure ToFront1Click(Sender: TObject);
    procedure ToBack1Click(Sender: TObject);
    procedure Orto1Click(Sender: TObject);
    procedure Grid1Click(Sender: TObject);
    procedure LinetypeEditor1Click(Sender: TObject);
    procedure Symbols2Click(Sender: TObject);
    procedure Raster2Click(Sender: TObject);
    procedure Coords1Click(Sender: TObject);
    procedure DrawBox1ShowCoords(Sender: TObject; X, Y: Integer; XWorld,
      YWorld: Double);
    procedure GeoreferencedImage1Click(Sender: TObject);
    procedure GIS1PrintBegin(Sender: TObject);
    procedure GIS1PrintProgress(Sender: TObject; Percent: Integer;
      var Cancel: Boolean);
    procedure GIS1PrintEnd(Sender: TObject);
    procedure BtnPrintClick(Sender: TObject);
    procedure Config1Click(Sender: TObject);
    procedure Edit1Click(Sender: TObject);
    procedure Emf1Click(Sender: TObject);
    procedure Regen1Click(Sender: TObject);
    procedure Pan1Click(Sender: TObject);
    procedure ZoomIn1Click(Sender: TObject);
    procedure ZoomOut1Click(Sender: TObject);
    procedure ZoomRealtime1Click(Sender: TObject);
    procedure Window1Click(Sender: TObject);
    procedure Previous1Click(Sender: TObject);
    procedure Selection1Click(Sender: TObject);
    procedure ZoomLayer1Click(Sender: TObject);
    procedure All1Click(Sender: TObject);
    procedure Addmarker2Click(Sender: TObject);
    procedure ClearMarkers1Click(Sender: TObject);
    procedure SelectTarget1Click(Sender: TObject);
    procedure SelectRectangle2Click(Sender: TObject);
    procedure EditDatabaseInfo2Click(Sender: TObject);
    procedure Combine1Click(Sender: TObject);
    procedure Fit2Click(Sender: TObject);
    procedure CLIP1Click(Sender: TObject);
    procedure Fit1Click(Sender: TObject);
    procedure Trim1Click(Sender: TObject);
    procedure Extend1Click(Sender: TObject);
    procedure Break1Click(Sender: TObject);
    procedure Fillet1Click(Sender: TObject);
    procedure ToPolyline1Click(Sender: TObject);
    procedure ToPolygon1Click(Sender: TObject);
    procedure Revertdirection1Click(Sender: TObject);
    procedure PersistentBitmap1Click(Sender: TObject);
    procedure BandsBitmap1Click(Sender: TObject);
    procedure EndPoint1Click(Sender: TObject);
    procedure MidPoint1Click(Sender: TObject);
    procedure Center1Click(Sender: TObject);
    procedure Intersect1Click(Sender: TObject);
    procedure Perpend1Click(Sender: TObject);
    procedure Hints1Click(Sender: TObject);
    procedure ShowCmdLine1Click(Sender: TObject);
    procedure Snap1Click(Sender: TObject);
    procedure Snap2Click(Sender: TObject);
    procedure osnap1Click(Sender: TObject);
    procedure Preferences1Click(Sender: TObject);
    procedure Reindex1Click(Sender: TObject);
    procedure Browse1Click(Sender: TObject);
    procedure QuickUpdateExtension1Click(Sender: TObject);
    procedure Update1Click(Sender: TObject);
    procedure ClippedArea1Click(Sender: TObject);
    procedure PolygonClip1Click(Sender: TObject);
    procedure SetClipBoundaryfromSelection1Click(Sender: TObject);
    procedure Cancelclipped1Click(Sender: TObject);
    procedure Import1Click(Sender: TObject);
    procedure GIS1FileNameChange(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure BtnCircle3PClick(Sender: TObject);
    procedure BtnCircleCRClick(Sender: TObject);
    procedure btnSnapNearestClick(Sender: TObject);
    procedure BtnAerialViewClick(Sender: TObject);
    procedure DrawBox1ZoomChange(Sender: TObject; const Scale: Double);
    procedure LineStyle1Click(Sender: TObject);
    procedure SymbolStyle1Click(Sender: TObject);
    procedure TextStyle1Click(Sender: TObject);
    procedure About1Click(Sender: TObject);
    procedure Export1Click(Sender: TObject);
    procedure Pack1Click(Sender: TObject);
    procedure SelectAll1Click(Sender: TObject);
    procedure UnSelectAll1Click(Sender: TObject);
    procedure Entire1Click(Sender: TObject);
    procedure CopySelectionTo1Click(Sender: TObject);
    procedure Restructure1Click(Sender: TObject);
    procedure DrawBox1MouseMove2D(Sender: TObject; Shift: TShiftState; X,
      Y: Integer; const WX, WY: Double);
    procedure btnBandsClick(Sender: TObject);
    procedure SpeedButton2Click(Sender: TObject);
    procedure Saveclipped1Click(Sender: TObject);
    procedure Options2Click(Sender: TObject);
    procedure FillStyle1Click(Sender: TObject);
    procedure AddEntity1Click(Sender: TObject);
    procedure GIS1BeforePaintEntity(Sender: TObject; Layer: TEzBaseLayer;
      Recno: Integer; Entity: TEzEntity; Grapher: TEzGrapher;
      Canvas: TCanvas; const Clip: TEzRect; DrawMode: TEzDrawMode;
      var CanShow: Boolean);
    procedure Reproject1Click(Sender: TObject);
    procedure DrawBox1GridError(Sender: TObject);
    procedure GIS1Progress(Sender: TObject; Stage: TEzProgressStage;
      const Caption: String; Min, Max, Position: Integer);
    procedure BtnTextClick(Sender: TObject);
    procedure CmdLine1StatusMessage(Sender: TObject;
      const AMessage: String);
    procedure GIS1BeforePaintLayer(Sender: TObject; Layer: TEzBaseLayer;
      Grapher: TEzGrapher; var CanShow, WasFiltered: Boolean);
    procedure Explode2Click(Sender: TObject);
    procedure Offset1Click(Sender: TObject);
    procedure Join1Click(Sender: TObject);
    procedure BtnTIFFClick(Sender: TObject);
    procedure DrawBox1ShowHint(Sender: TObject; Layer: TEzBaseLayer;
      Recno: Integer; var Hint: String; var ShowHint: Boolean);
    procedure CmdLine1AfterCommand(Sender: TObject; const Command,
      ActionID: String);
    procedure CmdLine1BeforeCommand(Sender: TObject; const Command,
      ActionID: String; var ErrorMessage: String; var Accept: Boolean);
    procedure MoveGuidelines1Click(Sender: TObject);
    procedure DrawBox1EntityDblClick(Sender: TObject; Layer: TEzBaseLayer;
      RecNo: Integer; var Processed: Boolean);
    procedure ConvertAutoCADDWGDXF1Click(Sender: TObject);
    procedure HotSpot1Click(Sender: TObject);
    procedure CreateThumnaillbitmap1Click(Sender: TObject);
    procedure Clippolygon1Click(Sender: TObject);
    procedure BandedTiff1Click(Sender: TObject);
    procedure FormPaint(Sender: TObject);
    procedure Makeblockfromselection1Click(Sender: TObject);
    procedure ARRAYfromselection1Click(Sender: TObject);
    procedure Deleterepetitions1Click(Sender: TObject);
    procedure ThematicsEditor1Click(Sender: TObject);
    procedure BtnGraphInfoClick(Sender: TObject);
    procedure BtnSplineTextClick(Sender: TObject);
    procedure Preferences2Click(Sender: TObject);
    procedure Viewportconfig1Click(Sender: TObject);
    procedure Gisconfig1Click(Sender: TObject);
    procedure Layersconfig1Click(Sender: TObject);
    procedure GIS1GisTimer(Sender: TObject; var CancelPainting: Boolean);
    procedure GIS1LabelEntity(Sender: TObject; Layer: TEzBaseLayer;
      Recno: Integer; Entity: TEzEntity; Grapher: TEzGrapher;
      Canvas: TCanvas; const Clip: TEzRect; Captions: TStrings;
      var Position: TEzLabelPos; var AlignLabels, RepeatInSegments,
      SmartShowing: Boolean; LabelsFont: TEzFontTool; var TrueType,
      Accept: Boolean);
  private
    { Private declarations }
    frmAerial: TfrmAerial;
    frmEditDB: TfrmEditDB;
    FTestBitmap: TBitmap;
    FWasPainted: Boolean;
    FOldWidth, FOldHeight: Integer;
    FLayersOptions: TEzLayersOptions;
    frmLegend: TfrmLegend;
    //FTileBitmap: TBitmap;
    procedure FileProgress(Sender: TObject; const Filename: string;
      Progress, NoEntities, BadEntities: Integer; var CanContinue: Boolean);
    procedure SetConnectionDefaults;
    procedure WMEnterSizeMove( Var m: TMessage ); Message WM_ENTERSIZEMOVE;
    procedure WMExitSizeMove( Var m: TMessage ); Message WM_EXITSIZEMOVE;
  public
    { Public declarations }
    Property LayersOptions: TEzLayersOptions read FLayersOptions;
  end;

  Function DetectCancelPaint( DrawBox: TEzBaseDrawBox ): Boolean;
  procedure ShadeIt(f: TForm; c: TControl; Width: Integer; Color: TColor);

var
  Form1: TForm1;

implementation

{$R *.dfm}

uses
  ezentities, ezsystem, EzPolyClip, Inifiles, fLayers, ezrtree,
  ezconsts, fLineTypeEd, fdemoprevw, fSymbEd, fRasterImageEd, fSelectImage, fUDFs,
  fBrowse, fProgr, ezshpimport, EzDxfImport, EzMIFIMport, EzDGNImport,
  fLineType, fSymbolType, fFontStyle, fLayerSelect, fRestructure, fMapUnits,
  fBrushStyle, fAddEntity, fReproject, fAbout, fRichEdit, ezhtmlmap, ShellAPI,
  fThemsEditor, fRepeat, fInspector, EzInspect, EzActions, EzMiscelEntities,
  fPref, fDBInspector, fGisInspector, fLayerInspector, EzActionLaunch;


procedure ShadeIt(f: TForm; c: TControl; Width: Integer; Color: TColor); 
var 
  rect: TRect; 
  old: TColor; 
begin 
  if (c.Visible) then 
  begin 
    rect := c.BoundsRect; 
    rect.Left := rect.Left + Width; 
    rect.Top := rect.Top + Width; 
    rect.Right := rect.Right + Width; 
    rect.Bottom := rect.Bottom + Width; 
    old := f.Canvas.Brush.Color; 
    f.Canvas.Brush.Color := Color; 
    f.Canvas.fillrect(rect); 
    f.Canvas.Brush.Color := old; 
  end; 
end;

Function DetectCancelPaint( DrawBox: TEzBaseDrawBox ): Boolean;
var
  Msg: TMsg;
begin
  DrawBox.Refresh;
  Result:= False;
  // is a message waiting on the message pool ?
  if PeekMessage(Msg, DrawBox.Handle, WM_KEYDOWN, WM_KEYDOWN, PM_REMOVE) and
     { (Msg.Message = WM_KEYDOWN) and } (Msg.WParam = VK_ESCAPE) then
  begin
    Result:= true;
    Exit;
  end;
  if PeekMessage(Msg, DrawBox.Handle, WM_LBUTTONDOWN, WM_LBUTTONDOWN, PM_NOREMOVE) then
    //Msg.Message >= WM_LBUTTONDOWN then
  begin
    Result:= true;
    Exit;
  end;
  if PeekMessage(Msg, DrawBox.Handle, WM_LBUTTONDBLCLK, WM_LBUTTONDBLCLK, PM_NOREMOVE) then
    //Msg.Message >= WM_LBUTTONDBLCLK then
  begin
    Result:= true;
    Exit;
  end;
  if PeekMessage(Msg, DrawBox.Handle, WM_RBUTTONDOWN, WM_RBUTTONDOWN, PM_NOREMOVE) then
    //Msg.Message >= WM_RBUTTONDOWN then
  begin
    Result:= true;
    Exit;
  end;
  if PeekMessage(Msg, DrawBox.Handle, WM_HSCROLL, WM_VSCROLL, PM_NOREMOVE) and
    (Msg.Message = WM_HSCROLL) or (Msg.Message = WM_VSCROLL) then
  begin
    Result:= true;
    Exit;
  end;
  if PeekMessage(Msg, DrawBox.Handle, WM_MBUTTONDOWN, WM_MBUTTONDOWN, PM_NOREMOVE) then
    //Msg.Message >= WM_MBUTTONDOWN then
  begin
    Result:= true;
    Exit;
  end;
  if PeekMessage(Msg, DrawBox.Handle, WM_MBUTTONDBLCLK, WM_MBUTTONDBLCLK, PM_NOREMOVE) then
    //Msg.Message >= WM_MBUTTONDBLCLK then
  begin
    Result:= true;
    Exit;
  end;
End;


procedure TForm1.SetConnectionDefaults;
begin
  Database1.Connected:= False;
  Database1.AliasName := 'SQLBDE_ALIAS';
  Database1.LoginPrompt:= False;
  //Database1.Params.Add('USER NAME=SYSDBA');
  //Database1.Params.Add('PASSWORD=masterkey');
  Database1.Connected:= true;
end;


procedure TForm1.New1Click(Sender: TObject);
var
  NewMapName: string;
begin
  Gis1.Close;
  SetConnectionDefaults;

  NewMapName := Inputbox( 'Create new map', 'New map name :', '');
  if Length(NewMapname) = 0 then exit;

  { Now, create all files on this database }
  Gis1.CreateNew( NewMapName );
  Gis1.FileName:= NewMapName;
  Gis1.Open;

end;

procedure TForm1.Exit1Click(Sender: TObject);
begin
  Close;
end;

procedure TForm1.Open1Click(Sender: TObject);
var
  MapName: string;
begin
  Gis1.Close;
  SetConnectionDefaults;
  MapName := Inputbox( 'Create new map', 'New map name :', '');
  if Length( Mapname ) = 0 then Exit;

  Gis1.FileName := MapName;
  Gis1.Open;
end;

procedure TForm1.Layers1Click(Sender: TObject);
begin
  if not GIS1.Active then exit;
  with TfrmLayers.Create(Nil) do
    try
      Enter( Self.DrawBox1 );
    finally
      Free;
    end;
end;

procedure TForm1.Save1Click(Sender: TObject);
begin
  if Length( Gis1.FileName ) = 0 then Exit;
  Gis1.Save;
end;

procedure TForm1.BtnHandClick(Sender: TObject);
begin
  CmdLine1.Clear;
  CmdLine1.DoCommand('SCROLL','');
end;

procedure TForm1.BtnEditDBClick(Sender: TObject);
begin
  EditDBParentHWND:= Self.Handle;

  TfrmEditDB.Create(Nil).Enter(CmdLine1, nil);
end;

procedure TForm1.BtnZoomRTClick(Sender: TObject);
begin
  CmdLine1.Clear;
  CmdLine1.DoCommand('REALTIMEZOOM','');
end;

procedure TForm1.ZoomWBtnClick(Sender: TObject);
begin
  CmdLine1.Clear;
  CmdLine1.DoCommand('ZOOMWIN','');
end;

procedure TForm1.ZoomAllClick(Sender: TObject);
begin
  CmdLine1.Clear;
  DrawBox1.ZoomToExtension;
end;

procedure TForm1.PriorViewBtnClick(Sender: TObject);
begin
  CmdLine1.Clear;
  DrawBox1.ZoomPrevious;
end;

procedure TForm1.ZoomInClick(Sender: TObject);
begin
  CmdLine1.Clear;
  CmdLine1.DoCommand('ZOOMIN','');
end;

procedure TForm1.ZoomOutClick(Sender: TObject);
begin
  CmdLine1.Clear;
  CmdLine1.DoCommand('ZOOMOUT','');
end;

procedure TForm1.SelectBtnClick(Sender: TObject);
begin
  CmdLine1.Clear ;
  DrawBox1.Cursor := crDefault ;
end;

procedure TForm1.BtnMedidasClick(Sender: TObject);
begin
  CmdLine1.DoCommand('MEASURES','');
end;

procedure TForm1.BtnRectSelectClick(Sender: TObject);
begin
  CmdLine1.Clear;
  CmdLine1.DoCommand('SELECT','');
end;

procedure TForm1.BtnCircleSelectClick(Sender: TObject);
begin
  CmdLine1.Clear;
  CmdLine1.DoCommand('CIRCLESEL','');
end;

procedure TForm1.BtnMultiselClick(Sender: TObject);
begin
  CmdLine1.Clear;
  CmdLine1.DoCommand('POLYGONSEL','');
end;

procedure TForm1.BtnPolylineSelClick(Sender: TObject);
begin
  CmdLine1.Clear;
  CmdLine1.DoCommand('SELPLINE','');
end;

procedure TForm1.btnPointClick(Sender: TObject);
begin
  CmdLine1.DoCommand( 'POINT', '' );
end;

procedure TForm1.BtnLineClick(Sender: TObject);
begin
  CmdLine1.DoCommand( 'LINE', '' );
end;

procedure TForm1.BtnPolylineClick(Sender: TObject);
begin
  CmdLine1.DoCommand( 'PLINE', '' );
end;

procedure TForm1.BtnPolygonClick(Sender: TObject);
begin
  CmdLine1.DoCommand( 'POLYGON', '' );
end;

procedure TForm1.BtnRectClick(Sender: TObject);
begin
  CmdLine1.DoCommand('RECTANGLE','');
end;

procedure TForm1.BtnArcClick(Sender: TObject);
begin
  CmdLine1.DoCommand('ARC','');
end;

procedure TForm1.BtnEllipseClick(Sender: TObject);
begin
  CmdLine1.DoCommand('ELLIPSE','');
end;

procedure TForm1.BtnSplineClick(Sender: TObject);
begin
  CmdLine1.DoCommand('SPLINE','');
end;

procedure TForm1.btnJustTextClick(Sender: TObject);
begin
  CmdLine1.DoCommand('JUSTIFTEXT','');
end;

procedure TForm1.btnFittedTextClick(Sender: TObject);
begin
  CmdLine1.DoCommand('FITTEDTEXT','');
end;

procedure TForm1.BtnBannerTextClick(Sender: TObject);
begin
  CmdLine1.DoCommand('BANNER','');
end;

procedure TForm1.btnCalloutClick(Sender: TObject);
begin
   CmdLine1.DoCommand('CALLOUTTEXT','');
end;

procedure TForm1.btnBulletLeaderClick(Sender: TObject);
begin
   CmdLine1.DoCommand('BULLETLEADER','');
end;

procedure TForm1.BtnSymbolClick(Sender: TObject);
begin
  CmdLine1.DoCommand('SYMBOL', 'CUSTOMERS');  // dummy stateID
end;

procedure TForm1.BtnTxtPlaceClick(Sender: TObject);
begin
   CmdLine1.DoCommand('TEXTSYMBOL', '');
end;

procedure TForm1.BtnPicClick(Sender: TObject);
begin
  CmdLine1.DoCommand('PICTUREREF','');
end;

procedure TForm1.BtnAutoLabelClick(Sender: TObject);
begin
  CmdLine1.DoCommand('AUTOLABEL','');
end;

procedure TForm1.btnDimHorzClick(Sender: TObject);
begin
  CmdLine1.DoCommand('DIMHORZ','');
end;

procedure TForm1.btnDimVertClick(Sender: TObject);
begin
  CmdLine1.DoCommand('DIMVERT','');
end;

procedure TForm1.btnDimParClick(Sender: TObject);
begin
  CmdLine1.DoCommand('DIMPARALL','');
end;

procedure TForm1.BtnMoveClick(Sender: TObject);
begin
  CmdLine1.DoCommand('MOVE','');
end;

procedure TForm1.BtnScaleClick(Sender: TObject);
begin
  CmdLine1.DoCommand('SCALE','');
end;

procedure TForm1.BtnRotateClick(Sender: TObject);
begin
  CmdLine1.DoCommand('ROTATE','');
end;

procedure TForm1.BtnReshapeClick(Sender: TObject);
begin
  CmdLine1.DoCommand('RESHAPE','');
end;

procedure TForm1.BtnInsVertexClick(Sender: TObject);
begin
  CmdLine1.DoCommand('INSERTVERTEX','');
end;

procedure TForm1.BtnDelVertexClick(Sender: TObject);
begin
  CmdLine1.DoCommand('DELVERTEX','');
end;

procedure TForm1.HGuidesClick(Sender: TObject);
begin
  CmdLine1.DoCommand('HGLINE','');
end;

procedure TForm1.VGuidesClick(Sender: TObject);
begin
  CmdLine1.DoCommand('VGLINE','');
end;

procedure TForm1.FormCreate(Sender: TObject);
var
  Path, FileName: string;
  Inifile: TInifile;
begin

  Database1.Connected:= true;

  FLayersOptions:= TEzLayersOptions.Create;

  Path:= AddSlash(ExtractFilePath(ExpandFilename('..\..\data\txt.fnt')));
  //Path:= AddSlash(ExtractFilePath(Application.ExeName));
  if not FileExists(Path+'txt.fnt') then
  begin
    ShowMessage('No font files found !');
  end;
  Ez_VectorFonts.AddFontFile(Path+'complex.fnt');
  Ez_VectorFonts.AddFontFile(Path+'txt.fnt');
  Ez_VectorFonts.AddFontFile(Path+'romanc.fnt');
  Ez_VectorFonts.AddFontFile(Path+'arial.fnt');

  { ALWAYS load the symbols after the vectorial fonts
    because the symbols can include vectorial fonts entities and
    if the vector font is not found, then the entity will be configured
    with another font }
  Ez_Symbols.FileName:= Path + 'symbols.ezs';
  if FileExists(Path + 'symbols.ezs') then
  begin
    Ez_Symbols.Open;
  end;

  // load line types
  Ez_LineTypes.FileName:=Path + 'Linetypes.ezl';
  if FileExists(Path + 'Linetypes.ezl') then
  begin
    Ez_LineTypes.Open;
  end;

  { load the preferences from a file

    WARNING!!!
    If you modify preferences at design time, it will not be persistent because
    we are loading from a file here

    Comment this three lines in order to use the design time preferences }
  FileName:= ExtractFilePath(Application.ExeName) + 'Preferences.ini';
  if FileExists(FileName) then
    Preferences1.LoadFromFile(FileName);

  Preferences1.CommonSubDir:= Path;

  Preferences1.ApertureWidth:= DrawBox1.Grapher.ScreenDpiY div 12;

  if FileExists(Path + 'gray_aluminum.bmp') then
  begin
    FTestBitmap:= TBitmap.create;
    FTestBitmap.LoadFromFile(Path + 'gray_aluminum.bmp');
  end;

  //**** uncomment if you want a tile bitmap on the viewport
  //FTileBitmap:= TBitmap.create;
  //FTileBitmap.LoadFromFile(Path + 'greenred_marble.bmp');
  //DrawBox1.TileBitmap:= FTileBitmap;

  //Preferences1.AddPreloadedBandedImage('c:\ezgis1\demos\data\bahia kino2.tif');
  //Preferences1.UsePreloadedBandedImages:= true;

  { if you want to save viewport configurations }
  Inifile:= TInifile.Create(ExtractFilePath(Application.Exename)+'MapConfig.ini');
  try
    drawbox1.Color:= Inifile.ReadInteger('Viewport Config', 'BackColor', drawbox1.Color);
    drawbox1.RubberPen.Color:= Inifile.ReadInteger('Viewport Config', 'RubberBandColor', drawbox1.RubberPen.Color);
    if Inifile.ReadBool('Viewport Config', 'ShowScrollBars', True) then
      drawbox1.ScrollBars:= ssBoth
    else
      drawbox1.ScrollBars:= ssNone;
    { the grid }
    with drawbox1.GridInfo do
    begin
      ShowGrid:= Inifile.ReadBool('Viewport Config', 'Grid_Show', False);
      DrawAsCross:= Inifile.ReadBool('Viewport Config', 'Grid_Cross', true);
      Grid.X:= Inifile.ReadFloat('Viewport Config', 'Grid_X', 1);
      Grid.Y:= Inifile.ReadFloat('Viewport Config', 'Grid_Y', 1);
      GridColor:= Inifile.ReadInteger('Viewport Config', 'Grid_Color', clMaroon);
      GridOffset.X:= Inifile.ReadFloat('Viewport Config', 'Grid_OffsetX', 0);
      GridOffset.Y:= Inifile.ReadFloat('Viewport Config', 'Grid_OffsetY', 0);
    end;
  finally
    Inifile.free;
  end;
end;

procedure TForm1.Undo1Click(Sender: TObject);
begin
  Screen.Cursor:= crHourglass;
  DrawBox1.UndoUndo;
  Screen.Cursor:= crDefault;
end;

procedure TForm1.Cut1Click(Sender: TObject);
begin
  DrawBox1.UndoAddCut;
end;

procedure TForm1.Copy1Click(Sender: TObject);
begin
  DrawBox1.UndoAddCopy;
end;

procedure TForm1.Paste1Click(Sender: TObject);
begin
  DrawBox1.UndoPaste;
end;

procedure TForm1.Delete1Click(Sender: TObject);
begin
  DrawBox1.DeleteSelection;
end;

procedure TForm1.Copyclipboard1Click(Sender: TObject);
begin
  DrawBox1.CopyToClipboardAsBmp;
end;

procedure TForm1.Group1Click(Sender: TObject);
begin
   DrawBox1.GroupSelection;
end;

procedure TForm1.Ungroup1Click(Sender: TObject);
begin
   DrawBox1.UnGroupSelection;
end;

procedure TForm1.ToFront1Click(Sender: TObject);
begin
  DrawBox1.BringToFront;
end;

procedure TForm1.ToBack1Click(Sender: TObject);
begin
  DrawBox1.SendToBack;
end;

procedure TForm1.Orto1Click(Sender: TObject);
begin
  Orto1.Checked := not Orto1.Checked;
  CmdLine1.UseOrto := Orto1.Checked;
end;

procedure TForm1.Grid1Click(Sender: TObject);
begin
  Grid1.Checked := not Grid1.Checked;
  DrawBox1.GridInfo.ShowGrid := Grid1.Checked;
  DrawBox1.Repaint;
end;

procedure TForm1.LinetypeEditor1Click(Sender: TObject);
begin
  with TfrmLinetypes.create(Nil) do
    try
       ShowModal;
    finally
      free;
    end;
end;

procedure TForm1.Symbols2Click(Sender: TObject);
begin
  with TfrmSymbols.Create(Nil) do
    try
      ShowModal;
    finally
      free;
    end;
end;

procedure TForm1.Raster2Click(Sender: TObject);
begin
  with TfrmRasterImgEditor.create(Nil) do
    try
      ShowModal;
    finally
      Free;
    end;
end;

procedure TForm1.Coords1Click(Sender: TObject);
begin
  CmdLine1.DoCommand('COORDS','');
end;

procedure TForm1.DrawBox1ShowCoords(Sender: TObject; X, Y: Integer; XWorld,
  YWorld: Double);
var
  ShowText: string;
begin
  // copy the coords to the clipboard and show on a dialog box
  ShowText:= Format('Clicked on (%.*n, %.*n)',
    [DrawBox1.NumDecimals, XWorld,
     DrawBox1.NumDecimals, YWorld]);
  Clipboard.AsText := ShowText;
  ShowMessage(ShowText);
end;

procedure TForm1.GeoreferencedImage1Click(Sender: TObject);
var
  Subdir, filnam: string;
begin
  Subdir:=ezsystem.AddSlash(Preferences1.CommonSubDir);
  with TfrmSelImage.Create(Nil) do
    try
      if not Execute(Subdir, '*.gri', liAllImages) then Exit;
      filnam:=ListBox1.Items[ListBox1.ItemIndex];
    finally
      Free;
    end;
  DrawBox1.Gis.AddGeoref(DrawBox1.Gis.CurrentLayerName, Subdir+filnam);
  DrawBox1.Repaint;
end;

var
  frmPrintProgress: TfrmPrintProgress;

procedure TForm1.GIS1PrintBegin(Sender: TObject);
begin
  frmPrintProgress:= TfrmPrintProgress.Create(Application);
  With frmPrintProgress do
  begin
    Show;
    Application.ProcessMessages;
    lblPrinter.Caption:=
      Format('Printing on Printer %s',[Printer.Printers[Printer.PrinterIndex]]);
    lblFileName.Caption:=GIS1.FileName;
    Update;
    Bar1.Position := 0;
  end;
end;

procedure TForm1.GIS1PrintProgress(Sender: TObject; Percent: Integer;
  var Cancel: Boolean);
begin
  frmPrintProgress.Bar1.Position := Percent;
  Application.ProcessMessages;
  Cancel:= frmPrintProgress.ModalResult=mrCancel;
end;

procedure TForm1.GIS1PrintEnd(Sender: TObject);
begin
  frmPrintProgress.Free;
end;

procedure TForm1.BtnPrintClick(Sender: TObject);
begin
  CmdLine1.Clear;
  frmDemoPreview:= TfrmDemoPreview.Create(Nil);
  with frmDemoPreview do
    try
      Enter(Self.DrawBox1);
    finally
      Free;
    end;
end;

procedure TForm1.Config1Click(Sender: TObject);
begin
  with TPrinterSetupDialog.Create(Self) do
     try
        Execute;
     finally
        Free;
     end;
end;

procedure TForm1.Edit1Click(Sender: TObject);
begin
  Undo1.Caption:= DrawBox1.UndoGetVerb;
end;

procedure TForm1.Emf1Click(Sender: TObject);
begin
  DrawBox1.CopyToClipboardAsEMF;
end;

procedure TForm1.Regen1Click(Sender: TObject);
begin
  DrawBox1.RegenDrawing;
end;

procedure TForm1.Pan1Click(Sender: TObject);
begin
  CmdLine1.Clear;
  CmdLine1.DoCommand('SCROLL','');
end;

procedure TForm1.ZoomIn1Click(Sender: TObject);
begin
  CmdLine1.Clear;
  CmdLine1.DoCommand('ZOOMIN','');
end;

procedure TForm1.ZoomOut1Click(Sender: TObject);
begin
  CmdLine1.Clear;
  CmdLine1.DoCommand('ZOOMOUT','');
end;

procedure TForm1.ZoomRealtime1Click(Sender: TObject);
begin
  CmdLine1.Clear;
  CmdLine1.DoCommand('REALTIMEZOOM','');
end;

procedure TForm1.Window1Click(Sender: TObject);
begin
  CmdLine1.Clear;
  CmdLine1.DoCommand('ZOOMWIN','');
end;

procedure TForm1.Previous1Click(Sender: TObject);
begin
  CmdLine1.Clear;
  DrawBox1.ZoomPrevious;
end;

procedure TForm1.Selection1Click(Sender: TObject);
begin
  DrawBox1.ZoomToSelection;
end;

procedure TForm1.ZoomLayer1Click(Sender: TObject);
var
  Layer: TEzBaseLayer;
begin
  Layer:= GetLayerFromDialog(Gis1);
  if Layer=nil then exit;
  DrawBox1.ZoomToLayerRef(Layer.Name);
end;

procedure TForm1.All1Click(Sender: TObject);
begin
  CmdLine1.Clear;
  DrawBox1.ZoomToExtension;
end;

procedure TForm1.Addmarker2Click(Sender: TObject);
begin
  CmdLine1.DoCommand('MARKER','');
end;

procedure TForm1.ClearMarkers1Click(Sender: TObject);
begin
  DrawBox1.TempEntities.Clear;
  DrawBox1.Refresh;
end;

procedure TForm1.SelectTarget1Click(Sender: TObject);
begin
  CmdLine1.Clear ;
  DrawBox1.Cursor := crDefault ;
end;

procedure TForm1.SelectRectangle2Click(Sender: TObject);
begin
  CmdLine1.Clear;
  CmdLine1.DoCommand('SELECT','');
end;

procedure TForm1.EditDatabaseInfo2Click(Sender: TObject);
begin
  CmdLine1.Clear;
  CmdLine1.DoCommand('EDITDB','');
end;

procedure TForm1.Combine1Click(Sender: TObject);
begin
  DrawBox1.JoinSelection(True);
end;

procedure TForm1.Fit2Click(Sender: TObject);
begin
  DrawBox1.FitSelectionToPath(true);
end;

procedure TForm1.CLIP1Click(Sender: TObject);
begin
  CmdLine1.DoCommand('CLIP','');
end;

procedure TForm1.Fit1Click(Sender: TObject);
begin
  DrawBox1.FitSelectionToPath(true);
end;

procedure TForm1.Trim1Click(Sender: TObject);
begin
   CmdLine1.DoCommand('TRIM', '');
end;

procedure TForm1.Extend1Click(Sender: TObject);
begin
   CmdLine1.DoCommand('EXTEND', '');
end;

procedure TForm1.Break1Click(Sender: TObject);
begin
  CmdLine1.DoCommand('BREAK','');
end;

procedure TForm1.Fillet1Click(Sender: TObject);
begin
   CmdLine1.DoCommand('FILLET', '');
end;

procedure TForm1.ToPolyline1Click(Sender: TObject);
begin
   DrawBox1.SelectionToPolyline;
end;

procedure TForm1.ToPolygon1Click(Sender: TObject);
begin
   DrawBox1.SelectionToPolygon;
end;

procedure TForm1.Revertdirection1Click(Sender: TObject);
begin
   DrawBox1.SelectionChangeDirection;
end;

procedure TForm1.PersistentBitmap1Click(Sender: TObject);
begin
  CmdLine1.DoCommand('PERSISTBITMAP','');
end;

procedure TForm1.BandsBitmap1Click(Sender: TObject);
begin
  CmdLine1.DoCommand('BANDSBITMAP','');
end;

procedure TForm1.EndPoint1Click(Sender: TObject);
begin
  CmdLine1.DoCommand('ENDOF','');
end;

procedure TForm1.MidPoint1Click(Sender: TObject);
begin
  CmdLine1.DoCommand('MIDOF','');
end;

procedure TForm1.Center1Click(Sender: TObject);
begin
  CmdLine1.DoCommand('CENTOF','');
end;

procedure TForm1.Intersect1Click(Sender: TObject);
begin
  CmdLine1.DoCommand('INTOF','');
end;

procedure TForm1.Perpend1Click(Sender: TObject);
begin
  CmdLine1.DoCommand('PERPENDTO','');
end;

procedure TForm1.Hints1Click(Sender: TObject);
begin
  CmdLine1.DoCommand('HINTS','');
end;

procedure TForm1.ShowCmdLine1Click(Sender: TObject);
begin
  ShowCmdLine1.Checked:= not ShowCmdLine1.Checked;
  CmdLine1.Visible:= ShowCmdLine1.Checked;
end;

procedure TForm1.Snap1Click(Sender: TObject);
begin
  Snap1.Checked := not Snap1.Checked;
  DrawBox1.GridInfo.SnapToGrid := Snap1.Checked;
end;

procedure TForm1.Snap2Click(Sender: TObject);
begin
  Snap2.Checked := not Snap2.Checked;
  DrawBox1.SnapToGuideLines := Snap2.Checked;
end;

procedure TForm1.osnap1Click(Sender: TObject);
begin
{$IFDEF FALSE}
   AmDialogs1.OsnapSettingsDialog;
{$ENDIF}
end;

procedure TForm1.Preferences1Click(Sender: TObject);
begin
{$IFDEF FALSE}
  AmDialogs1.PreferencesDialog;
{$ENDIF}
end;

procedure TForm1.Reindex1Click(Sender: TObject);
begin
  Screen.Cursor:= crHourglass;
  try
    GIS1.RebuildTree;
  finally
    Screen.Cursor:= crDefault;
  end;
end;

procedure TForm1.Browse1Click(Sender: TObject);
begin
  Browse1.Checked := not Browse1.Checked;
  { this method display always the first layer
    change as needed to display another layer (maybe by asking
    in a dialog window) }
  if Browse1.Checked then
  begin
    if GIS1.Layers.Count=0 then Exit;
    { the form is automatically freed }
    with TfrmDemoBrowse.Create(Nil) do
      Enter(DrawBox1, GIS1.Layers[0]);
  end;
end;

procedure TForm1.QuickUpdateExtension1Click(Sender: TObject);
begin
  Screen.Cursor:= crHourglass;
  try
    GIS1.QuickUpdateExtension;
  finally
    Screen.Cursor:= crDefault;
  end;
end;

procedure TForm1.Update1Click(Sender: TObject);
begin
  Screen.Cursor:= crHourglass;
  try
    GIS1.UpdateExtension;
  finally
    Screen.Cursor:= crDefault;
  end;
end;

procedure TForm1.ClippedArea1Click(Sender: TObject);
begin
   CmdLine1.DoCommand('SETCLIPAREA', '');
end;

procedure TForm1.PolygonClip1Click(Sender: TObject);
begin
  CmdLine1.DoCommand('CLIPPOLYAREA','');
end;

procedure TForm1.SetClipBoundaryfromSelection1Click(Sender: TObject);
begin
  DrawBox1.SetClipBoundaryFromSelection;
end;

procedure TForm1.Cancelclipped1Click(Sender: TObject);
begin
  GIS1.ClearClippedArea;
end;

resourcestring
  SVectFilterAcad= 'AutoCAD DXF (*.DXF)|*.DXF';
  SVectFilterSHP= 'ArcView Shape Files (*.SHP)|*.SHP';
  SVectFilterTAB= 'MapInfo native TAB (*.TAB)|*.TAB';
  SVectFilterMIF= 'MapInfo MIF/MID files (*.MIF)|*.MIF';
  SVectFilterDGN= 'Microstation DGN files (*.DGN)|*.DGN';
  SAllVectorFiles='All Vector files|*.SHP;*.TAB;*.MIF;*.DXF;*.DGN';

var
  ProgressDialog: TfrmProgressDlg;

procedure TForm1.FileProgress(Sender: TObject; const Filename: string;
  Progress, NoEntities, BadEntities: Integer; var CanContinue: Boolean);
begin
  if not ProgressDialog.Visible then ProgressDialog.Show;
  ProgressDialog.ProgressBar1.Position:= Progress;
  ProgressDialog.Label3.Caption:=
    Format('%d Objects created. %d Objects bad', [NoEntities, BadEntities]);
  ProgressDialog.Update;
end;

procedure TForm1.Import1Click(Sender: TObject);
const
  BaseFormats: string = '.SHP.TAB.MIF.DXF.DGN';
var
  FileFormat: Integer;
begin
  OpenDialog1.Filter:=  SAllVectorFiles + '|' +
                        SVectFilterAcad + '|' +
                        SVectFilterSHP  + '|' +
                        SVectFilterTAB  + '|' +
                        SVectFilterMIF  + '|' +
                        SVectFilterDGN;
  if not OpenDialog1.Execute then Exit;
  FileFormat:= AnsiPos(ExtractFileExt(AnsiUpperCase(OpenDialog1.FileName)), BaseFormats) div 4;

  Preferences1.DefPenStyle.Style:= 1;
  Preferences1.DefPenStyle.Scale:= 0;

  ProgressDialog:= TfrmProgressDlg.Create(Nil);
  try
    case FileFormat of
      0:  // Arcview .SHP files
        begin
          ProgressDialog.DispMsg.Caption:=
            Format( 'ArcView shapefile import from %s...',
                    [ProgressDialog.GetShortDispname(OpenDialog1.FileName)] );
          with TEzSHPImport.Create(nil) do
          try
            DrawBox:= Self.DrawBox1;
            Filename:= OpenDialog1.FileName;
            ConfirmProjectionSystem:= true;
            OnFileProgress:= Self.FileProgress;
            Execute;
          finally
            Free;
          end;
          DrawBox1.ZoomToExtension;
        end;
      1,  // Mapinfo .TAB
      2:  // Mapinfo .MIF/MID
        begin
          ProgressDialog.DispMsg.Caption:=
            Format( 'MIF Import from %s...',
                    [ProgressDialog.GetShortDispname(OpenDialog1.FileName)] );
          with TEzMIFImport.Create(nil) do
            try
              DrawBox:= self.DrawBox1;
              Filename:= OpenDialog1.FileName;
              ConfirmProjectionSystem:= true;   // or false
              OnFileProgress:= Self.FileProgress;
              Execute;
            finally
              Free;
            end;
        end;
      3:  // AutoCAD .DXF files
        begin
          { Import DXF to an existing layer (.DXF) }
          if GIS1.Layers.Count=0 then
          begin
            ShowMessage('You need at least one layer for Dxf''s');
            exit;
          end;
          ProgressDialog.DispMsg.Caption:=
            Format( 'DXF Import from %s...',
                    [ProgressDialog.GetShortDispname(OpenDialog1.FileName)] );
          with TEzDxfImport.Create(nil) do
          try
            DrawBox:= Self.DrawBox1;
            FileName:= OpenDialog1.FileName;
            //ImportToSameLayer:= True;
            Layername:= GIS1.CurrentLayerName;
            ConfirmProjectionSystem:= true;
            OnFileProgress:= Self.FileProgress;
            ReadDxf;
            Execute;
            // all went okay
          finally
            Free;
          end;
        end;
      4:  // Microstation .DGN files
        begin
          with TEzDGNImport.Create(nil) do
            try
              DrawBox:= Self.DrawBox1;
              Filename:= Opendialog1.FileName;
              ConfirmProjectionSystem:= true;   // or false
              OnFileProgress:= Self.FileProgress;
              Execute;
            finally
              Free;
            end;
        end;
    end;
  finally
    ProgressDialog.Free;
  end;
end;

procedure TForm1.GIS1FileNameChange(Sender: TObject);
begin
  Caption:= Format('EzGIS Main Demo - %s', [GIS1.FileName]);
  if Not Self.Gis1.Active then
    LayerGridBox1.Gis:= Nil
  else
    LayerGridBox1.Gis:= Self.Gis1;
end;

procedure TForm1.FormClose(Sender: TObject; var Action: TCloseAction);
var
  Inifile: TInifile;
  FileName, Path: string;
begin
  if Length(Gis1.FileName)=0 then Exit;
  Path:= AddSlash(ExtractFilePath(Application.ExeName));
  Inifile:= TInifile.Create(Path + 'MapConfig.INI');
  try
    IniFile.WriteString('RecentFiles','LastWorkedMap',Gis1.FileName);
    Inifile.WriteInteger('Viewport Config', 'BackColor', DrawBox1.Color);
    Inifile.WriteInteger('Viewport Config', 'RubberBandColor', DrawBox1.RubberPen.Color);
    if drawbox1.ScrollBars<>ssNone then
      Inifile.WriteBool('Viewport Config', 'ShowScrollBars', True)
    else
      Inifile.WriteBool('Viewport Config', 'ShowScrollBars', False);
    { the grid }
    with drawbox1.GridInfo do
    begin
      Inifile.WriteBool('Viewport Config', 'Grid_Show', ShowGrid);
      Inifile.WriteBool('Viewport Config', 'Grid_Cross', DrawAsCross);
      Inifile.WriteFloat('Viewport Config', 'Grid_X', Grid.X);
      Inifile.WriteFloat('Viewport Config', 'Grid_Y', Grid.Y);
      Inifile.WriteInteger('Viewport Config', 'Grid_Color', GridColor);
      Inifile.WriteFloat('Viewport Config', 'Grid_OffsetX', GridOffset.X);
      Inifile.WriteFloat('Viewport Config', 'Grid_OffsetY', GridOffset.Y);
    end;
  finally
    Inifile.Free;
  end;

  FTestBitmap.free;
  //FTileBitmap.free;

  { save the preferences to a file }
  FileName:= ExtractFilePath(Application.ExeName) + 'Preferences.ini';
  Preferences1.SaveToFile(FileName);

  FLayersOptions.Free;

end;

procedure TForm1.BtnCircle3PClick(Sender: TObject);
begin
  CmdLine1.DoCommand('CIRCLE3P','');
end;

procedure TForm1.BtnCircleCRClick(Sender: TObject);
begin
  CmdLine1.DoCommand('CIRCLECR','');
end;

procedure TForm1.btnSnapNearestClick(Sender: TObject);
var
  Osnap: TEzOsnapSettings;
begin
  Osnap:= [];
  if btnSnapNearest.Down then Include(Osnap,osNearest);
  if btnSnapEnd.Down then Include(Osnap,osEndPoint);
  if btnSnapMiddle.Down then Include(Osnap,osMidPoint);
  if btnSnapInters.Down then Include(Osnap,osIntersect);
  if btnSnapCenter.Down then Include(Osnap,osCenter);
  if btnSnapPerpend.Down then Include(Osnap,osPerpend);
  if btnSnapTangent.Down then Include(Osnap,osTangent);
  DrawBox1.OsnapSettings:= Osnap;

end;

procedure TForm1.BtnAerialViewClick(Sender: TObject);
begin
  { create the aerial view }
  if frmAerial=nil then
  begin
    ParentAerialHWND:= self.handle;
    frmAerial:= TfrmAerial.Create(Application);
    frmAerial.AerialView1.ParentView:= self.DrawBox1;
  end;
  frmAerial.Show;
end;

procedure TForm1.DrawBox1ZoomChange(Sender: TObject; const Scale: Double);
begin
  if (Gis1.Layers.Count=0) or (frmAerial=nil) then exit;
  frmAerial.AerialView1.Refresh;
end;

procedure TForm1.LineStyle1Click(Sender: TObject);
begin
  with TfrmLineType.create(Nil) do
    try
      Enter(self.DrawBox1);
    finally
      free;
    end;
end;

procedure TForm1.SymbolStyle1Click(Sender: TObject);
begin
  with TfrmSymbolStyle.Create(Nil) do
    try
      Enter(self.DrawBox1);
    finally
      Free;
    end;
end;

procedure TForm1.TextStyle1Click(Sender: TObject);
begin
  with TfrmFontStyle.create(Nil) do
    try
      Enter(self.DrawBox1);
    finally
      free;
    end;
end;

procedure TForm1.About1Click(Sender: TObject);
begin

  //Preferences1.AddImage('c:\ezgis\demos\data\bahia kino1.bmp');

  //DrawBox1.AddEntityFromText('',
  //  'DIMHORIZONTAL (485035.638, 2141328.826), (485455.577, 2141123.388), 2141458.735');
  //DrawBox1.Repaint;

  //DrawBox1.AddEntityFromText('',
  //  'BANDSBITMAP (484441.191, 2137495.992), (486191.942, 2139069.899), "f19d2a_s.bmp"');
  {
  // create a sample entity
  DrawBox1.AddEntityFromText('',
    'RECTANGLE (484441.191, 2137495.992), (486191.942, 2139069.899)');
  Exit;
  // or ...
  Ent:=DrawBox1.CreateEntityFromText(
      'RECTANGLE (484441.191, 2137495.992), (486191.942, 2139069.899)');
  if Ent=nil then Exit;
  // add to the current layer
  DrawBox1.AddEntity('',Ent);
  DrawBox1.Repaint;
  // and free the memory
  Ent.Free;
  }

  with TfrmAbout.create(Nil) do
    try
      showmodal;
    finally
      free;
    end;

end;

procedure TForm1.Export1Click(Sender: TObject);
const
  BaseFormats = '.DXF.SHP';
var
  FileFormat: Integer;
  Layer: TEzBaseLayer;
begin
  if Gis1.Layers.Count=0 then exit;

  SaveDialog1.Filter:=  SVectFilterAcad + '|' +
                        SVectFilterSHP  + '|' +
                        SVectFilterMIF;
  if not SaveDialog1.Execute then Exit;

  FileFormat:=
    AnsiPos(ExtractFileExt(AnsiUpperCase(SaveDialog1.FileName)), BaseFormats) div 4;

  // ask for the layer to export

  Layer := GetLayerFromDialog(Gis1);

  if Layer=nil then Exit;

  ProgressDialog:= TfrmProgressDlg.Create(Nil);
  try
    case FileFormat of
      0:  // DXF
        begin
        with TEzDxfExport.Create(nil) do
          try
            FileName:= SaveDialog1.FileName;
            DrawBox:= Self.DrawBox1;
            LayerNames.Clear;
            // This is only a sample. Optionally you can export all layers by changing here the code
            LayerNames.Add(Layer.Name);
            OnFileProgress:= self.FileProgress;
            Execute;
          finally
            Free;
          end;
        end;
      1:  // SHP
        begin
        if AnsiCompareText( ExtractFilePath(SaveDialog1.FileName),
                            ExtractFilePath(Gis1.FileName))=0 then
        begin
          ShowMessage('You cannot export to same path !');
          exit;
        end;
        with TEzShpExport.Create(nil) do
          try
            DrawBox:= Self.DrawBox1;
            FileName:= SaveDialog1.Filename;
            ExportAs:= ftPolygon;     // you must change here how to export
            OnFileProgress:= Self.FileProgress;
            LayerName:= Layer.Name;
            Execute;
          finally
            Free;
          end;
        end;
      2:  // MIF
        begin
        if AnsiCompareText( ExtractFilePath(SaveDialog1.FileName),
                            ExtractFilePath(Gis1.FileName))=0 then
        begin
          ShowMessage('You cannot export to same path !');
          exit;
        end;
        with TEzMifExport.Create(nil) do
          try
            DrawBox:= Self.DrawBox1;
            FileName:= SaveDialog1.Filename;
            OnFileProgress:= Self.FileProgress;
            LayerName:= Layer.Name;
            Execute;
          finally
            Free;
          end;
        end;
    end;
  finally
    ProgressDialog.free;
  end;
end;

procedure TForm1.Pack1Click(Sender: TObject);
var
  Layer: TEzBaseLayer;
begin
  Layer:= GetLayerFromDialog(Gis1);
  if Layer=nil then exit;
  Screen.Cursor:= crHourglass;
  try
    Layer.Pack(true);
  finally
    Screen.Cursor:= crDefault;
  end;
end;

procedure TForm1.SelectAll1Click(Sender: TObject);
begin
  DrawBox1.SelectAll;
end;

procedure TForm1.UnSelectAll1Click(Sender: TObject);
begin
  DrawBox1.UnSelectAll;
end;

procedure TForm1.Entire1Click(Sender: TObject);
var
  Layer: TEzBaseLayer;
  Canceled: Boolean;
begin
  Layer := GetLayerFromDialog(Gis1);
  if Layer=nil then exit;
  DrawBox1.DoSelectLayer(Layer,Canceled);
  DrawBox1.Repaint;
end;

procedure TForm1.CopySelectionTo1Click(Sender: TObject);
var
  I, L, NewRecno: Integer;
  TmpEntity: TEzEntity;
  Entities: array[TEzEntityID] of TEzEntity;
  cnt, CurrEntityID: TEzEntityID;
  TmpLayer, DestLayer: TEzBaseLayer;
  TmpIndex: Integer;
  DstField, SrcField: Integer;
  TmpRecno, flds: integer;
  fldname: string;
begin
  if DrawBox1.Selection.Count=0 then exit;
  DestLayer:= GetLayerFromDialog(Gis1);
  if DestLayer = nil then Exit;
  with DrawBox1 do
  begin
    Screen.Cursor:= crHourglass;
    { We will create all existing entities to speed up process }
    for cnt:= Low(TEzEntityID) to High(TEzEntityID) do
      Entities[cnt]:= GetClassFromID(cnt).Create(4);
    try
      for L:= 0 to Gis1.Layers.Count - 1 do
      begin
        TmpLayer:= Gis1.Layers[L];
        TmpIndex:= Selection.IndexOf(TmpLayer);
        if (TmpIndex < 0) or (TmpLayer = DestLayer) then Continue;

        with TmpLayer do
        begin
          if not LayerInfo.Visible or (RecordCount=0) then Continue;
          Gis1.StartProgress(Format('Copying layer s', [Name]), 1, Recordcount);

          I:= 0;

          First;
          StartBuffering;
          try
            while not Eof do
            begin
              Inc(I);
              Gis1.UpdateProgress(I);
              try
                if RecIsDeleted then Continue;
                TmpRecno:= Recno;
                CurrEntityID:= RecEntityID;
                TmpEntity:= Entities[CurrEntityID];
                RecLoadEntity2(TmpEntity);
                if Selection[TmpIndex].IsSelected(TmpRecno) then
                begin
                  {copy this entity to the destination layer (DestLayer)}
                  NewRecno:= DestLayer.AddEntity(TmpEntity);
                  if (DestLayer.DBTable <> nil) and (TmpLayer.DBTable <> nil) then
                  begin
                    if TmpLayer.DBTable<>nil then
                      TmpLayer.DBTable.Recno:= NewRecno;
                    DestLayer.DBTable.Last;
                    DestLayer.DBTable.Edit;
                    with DestLayer.DBTable do
                    begin
                      for flds:= 1 to FieldCount - 1 do
                      begin
                        fldname:= Field(flds);
                        if AnsiCompareText(fldname, 'UID') = 0 then Continue;
                        SrcField:= TmpLayer.DBTable.FieldNo(fldname);
                        DstField:= DestLayer.DBTable.FieldNo(fldname);
                        DestLayer.DBTable.AssignFrom(TmpLayer.DBTable, SrcField, DstField);
                      end;
                    end;
                    DestLayer.DBTable.Post;
                  end;
                end;
              finally
                Next;
              end;
            end;
          finally
            EndBuffering;
            Gis1.EndProgress;
          end;
        end;
      end;
      DestLayer.UpdateExtension;
    finally
      for cnt:= Low(TEzEntityID) to High(TEzEntityID) do
        Entities[cnt].Free;
      Screen.Cursor:= crDefault;
    end;
  end;
end;

procedure TForm1.Restructure1Click(Sender: TObject);
var
  Layer: TEzBaseLayer;
begin
  Layer:= GetLayerFromDialog(Gis1);
  if Layer=nil then exit;
  with TfrmRestructDlg.create(Nil) do
    try
      if Enter(Layer)=mrOk then
      begin
      end;
    finally
      free;
    end;
end;

procedure TForm1.DrawBox1MouseMove2D(Sender: TObject; Shift: TShiftState;
  X, Y: Integer; const WX, WY: Double);
begin
  StatusBar1.Panels[1].Text := DrawBox1.CoordsToDisplayText(WX,WY);
end;

procedure TForm1.btnBandsClick(Sender: TObject);
begin
  CmdLine1.DoCommand('BANDSBITMAP','');
end;

procedure TForm1.SpeedButton2Click(Sender: TObject);
begin
  CmdLine1.DoCommand('PERSISTBITMAP','');
end;

procedure TForm1.Saveclipped1Click(Sender: TObject);
var
  SaveTo: string;
  NewGis: TEzGis;
begin
  with TSaveDialog.Create(nil) do
  begin
    try
      Title   := 'Save clipped area to';
      DefaultExt := '.EZM';
      Filter  := 'EzGis Map Files (*.EZM)|*.EZM';
      Options := [ofOverwritePrompt, ofPathMustExist];
      if not Execute then exit;
      SaveTo:= FileName;
    finally
      Free;
    end;
  end;

  if FileExists(SaveTo) then
    EzGisError('The map already exists !');

  NewGis:= TEzGis.Create(Nil);
  try
    NewGis.CreateNew(SaveTo);
    DrawBox1.SaveClippedAreaTo(NewGis);
  finally
    NewGis.Free;
  end;

end;

procedure TForm1.Options2Click(Sender: TObject);
begin
  with TfrmMapOpts.create(Nil) do
    try
      Enter(DrawBox1);
    finally
      free;
    end;
end;

procedure TForm1.FillStyle1Click(Sender: TObject);
begin
  with TfrmBrushStyle.create(Nil) do
    try
      Enter(DrawBox1);
    finally
      free;
    end;
end;

// check if a message is waiting
// if a message is waiting, cancel painting
{ this event is fired every n milliseconds defined in property
  TimerFrequency

  For the printer, the event OnPrintProgress is fired every nth millisecond
  defined in property PrintTimerFrequency
}
procedure TForm1.AddEntity1Click(Sender: TObject);
begin
  with TfrmAddEntity.create(Nil) do
    try
      enter(self.DrawBox1);
    finally
      free;
    end;
end;

procedure TForm1.GIS1BeforePaintEntity(Sender: TObject;
  Layer: TEzBaseLayer; Recno: Integer; Entity: TEzEntity;
  Grapher: TEzGrapher; Canvas: TCanvas; const Clip: TEzRect;
  DrawMode: TEzDrawMode; var CanShow: Boolean);
begin
  //if (AnsiCompareText(Layer.Name,'STATES_')=0) and (Recno=1) then
  //  Entity.Bitmap:= FTestBitmap;
  //if Entity.EntityID=idBandsTiff then
  //  TEzBandsBitmap(Entity).AlphaChannel:= 100;
  {IF (Layer.Name='TEST') and (Entity.EntityID=idPolygon) then
  begin
    if FTestBitmap<>nil then
      Entity.Bitmap:= FTestBitmap;
    //TEzClosedEntity(Entity).BrushTool.Pattern:= 1;
    //TEzClosedEntity(Entity).BrushTool.ForeColor:= clYellow;
    TEzClosedEntity(Entity).BrushTool.BackColor:= clNone;  // transparent filling
  end; }
end;

procedure TForm1.Reproject1Click(Sender: TObject);
begin
  {with TfrmReproject.create(Nil) do
    try
      Enter(Self.Gis1);
    finally
      free;
    end; }
end;

procedure TForm1.DrawBox1GridError(Sender: TObject);
begin
  StatusBar1.Panels[0].Text := 'Grid too dense to display';
end;

procedure TForm1.GIS1Progress(Sender: TObject; Stage: TEzProgressStage;
  const Caption: String; Min, Max, Position: Integer);
begin
   Application.ProcessMessages;
   case Stage of
     epsStarting:
        begin
           // Caption.- contains a descriptive of the activity ('Packing layer...')
           StatusBar1.Panels[0].Text := Caption;
           StatusBar1.Update;
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
           StatusBar1.Panels[0].Text := '';
        end;
     epsUpdating:
        begin
           // you can update here a label message
           //Label1.Caption := Caption
           StatusBar1.Panels[0].Text := Caption;
           StatusBar1.Update;
        end;
   end;
end;

procedure TForm1.BtnTextClick(Sender: TObject);
begin
  CmdLine1.DoCommand('TEXT','');
end;

procedure TForm1.CmdLine1StatusMessage(Sender: TObject;
  const AMessage: String);
begin
  StatusBar1.Panels[0].Text:= AMessage;
end;

procedure TForm1.GIS1BeforePaintLayer(Sender: TObject; Layer: TEzBaseLayer;
  Grapher: TEzGrapher; var CanShow, WasFiltered: Boolean);
begin
{$IFDEF FALSE}
  Layer.LayerInfo.TextHasShadow := true;
  Layer.LayerInfo.TextFixedSize := 0;
  { posible values are:
    TEzOverlappedTextAction = (otaDoNothing, otaHideOverlapped, otaShowOverlappedOnColor);
  }
  Layer.LayerInfo.OverlappedTextAction:= otaHideOverlapped;
  Layer.LayerInfo.OverlappedTextColor:= clLime;
{$ENDIF}
end;

procedure TForm1.Explode2Click(Sender: TObject);
begin
   DrawBox1.ExplodeSelection(False);
end;

procedure TForm1.Offset1Click(Sender: TObject);
begin
  CmdLine1.DoCommand('OFFSET','');
end;

procedure TForm1.Join1Click(Sender: TObject);
begin
  DrawBox1.JoinSelection(True);
end;

procedure TForm1.BtnTIFFClick(Sender: TObject);
begin
  CmdLine1.DoCommand('BANDSTIFF','');
end;

procedure TForm1.DrawBox1ShowHint(Sender: TObject; Layer: TEzBaseLayer;
  Recno: Integer; var Hint: String; var ShowHint: Boolean);
var
  Ent: TEzEntity;
begin
  if AnsiCompareText(Layer.Name,'STATES_')=0 then
  begin
    Layer.DBTable.Recno:= Recno;
    Hint:= Layer.DBTable.StringGetN(3);
    ShowHint:= true;
  end else
  begin
    Ent:= Layer.LoadEntityWithRecno(Recno);
    Hint:= Ent.ClassName;
    Ent.Free;
    ShowHint:= true;
  end;
end;

procedure TForm1.CmdLine1AfterCommand(Sender: TObject; const Command,
  ActionID: String);
begin
  if (Command='EDITDB') and (ActionID='EDITDB_KEY') and (frmEditDB<>nil) then
    frmEditDB.Hide;
end;

procedure TForm1.CmdLine1BeforeCommand(Sender: TObject; const Command,
  ActionID: String; var ErrorMessage: String; var Accept: Boolean);
begin
  if (Command='EDITDB') and (ActionID='EDITDB_KEY') then
  begin
    if frmEditDB=nil then
      frmEditDB:= TfrmEditDB.Create(Application);
    frmEditDB.Enter(CmdLine1, nil);
    frmEditDB.Show;
  end;
end;

procedure TForm1.MoveGuidelines1Click(Sender: TObject);
begin
  CmdLine1.Clear;
  CmdLine1.DoCommand('MOVEGLINE','');
end;

procedure TForm1.DrawBox1EntityDblClick(Sender: TObject;
  Layer: TEzBaseLayer; RecNo: Integer; var Processed: Boolean);
var
  Ent: TEzEntity;
begin
  Ent:= Layer.LoadEntityWithRecno(Recno);
  try
    if Ent.EntityID = idRtfText then
    begin
      if TfrmRichTextEditor.Enter(Ent) = mrOk then
        Layer.UpdateEntity(Recno, Ent);
    end;
  finally
    Ent.Free;
  end;
end;


{ DWG stuff --------------------------

  NOTE: we have provided this DWG stuff as free
  We have compiled the version that read/write AutoCAD until release 14
  so if you need one updated version, you have to got it from:

  http://www.OpenDWG.org

  because we don't have it yet. If you got updated version for AutoCAD
  2000 and 200i , please send to us in order to benefit other people also
  and to us :-).

  OpenDWG consortium does not provide a compiled DLL. Just the source code
  for the DLL files in order to be able to generate DLL with a C compiler.
}

type

  AD_DB_HANDLE  = Pointer;

  Tad_loadometer=procedure(const percent:short); cdecl;
  Tad_Saveometer=procedure(const percent:short); cdecl;

  TadInitAd2 = function (const initfilepath: Pointer;  const userinitfns: SmallInt;  initerror:  PSmallInt): SmallInt; cdecl;
  TadLoadFile = function (const fn: Pointer;const preloadstrat: Byte): AD_DB_HANDLE; cdecl;
  TadSaveFile = function (handle: AD_DB_HANDLE;name: Pointer;filetype:
                          byte;version: SmallInt;dxfnegz: SmallInt;
                          dxfdecprec: SmallInt;dxfwritezeroes: SmallInt;
                          r12dxfvbls: byte): SmallInt; cdecl	;
  TadCloseFile = function (handle: AD_DB_HANDLE): SmallInt; cdecl;
  TadSetupDwgRead = procedure ; cdecl;
  TadSetAd2LoadometerFn = procedure (ad_Loadometer: Tad_loadometer); cdecl;
  TadError = function : SmallInt; cdecl;
  TadErrorStr = function (aderror: SmallInt): PChar; cdecl;
  TadSetAd2SaveometerFn = procedure (ad_Saveometer:Tad_Saveometer); cdecl ;

const
  AD_PRELOAD_ALL = 1;
  AD_DXF = 1;
  AD_ACAD25 = 0; {/* ac1002*/}
  AD_ACAD26 = 1; {/* ac1003*/}
  AD_ACAD9  = 2; {/* ac1004*/}
  AD_ACAD10 = 3; {/* ac1006*/}
  AD_ACAD11 = 4; {/* ac1009*/}
  AD_ACAD13 = 5; {/* ac1012*/}
  AD_ACAD14 = 6;
  AD_MAXACADVER = AD_ACAD14;

function loadometer(const percent:short):short; cdecl;
begin
  Form1.Gis1.UpdateProgress(percent);
  result:= 0;
end;

procedure saveometer(const percent:short); cdecl;
begin
  Form1.Gis1.UpdateProgress(percent);
end;

procedure TForm1.ConvertAutoCADDWGDXF1Click(Sender: TObject);
var
  NewFilename: String;
  LibHandle : THandle;
  DrawingHandle : AD_DB_HANDLE;

  __adInitAd2            : TadInitAd2            ;
  __adSetupDwgRead       : TadSetupDwgRead       ;
  __adSetAd2LoadometerFn : TadSetAd2LoadometerFn ;
  __adSetAd2SaveometerFn : TadSetAd2SaveometerFn ;
  __adLoadFile           : TadLoadFile           ;
  __adSaveFile           : TadSaveFile           ;
  __adError              : TadError              ;
  __adErrorStr           : TadErrorStr           ;
  __adCloseFile          : TadCloseFile          ;

  function LoadDWGDLL: boolean;
  var
     DLLFileName: String;
     FileNameArray: Array[0..256] of char;
     initerr: smallint;

     function AddSlash(const Path: string): string;
     begin
       result := Path;
       if (Length(result) > 0) and (result[length(result)] <> '\') then
         result := result + '\'
     end;

     function SystemDirectory: string;
     var
       buffer: array[0..Windows.MAX_PATH] of char;
     begin
       Windows.GetSystemDirectory(buffer, sizeof(buffer));
       result := AddSlash(StrPas(buffer));
     end;

  begin
     result:=false;
     DLLFileName:= SystemDirectory + 'OpenDWG.DLL';   // the library must be on c:\win\system or app path
     LibHandle:= LoadLibrary( PChar(DLLFileName) );
     if LibHandle < 32 then
     begin
       ShowMessage('Could not find OpenDWG.dll !!!' + #13 +
                   'You must have the following files: OpenDWG.DLL and ADINIT.DAT on'#13+
                   'the System directory in order for this to work' );
       Exit;
     end;

     @__adInitAd2            := GetProcAddress(LibHandle, '__adInitAd2'            );
     @__adLoadFile           := GetProcAddress(LibHandle, '__adLoadFile'           );
     @__adCloseFile          := GetProcAddress(LibHandle, '__adCloseFile'          );
     @__adSaveFile           := GetProcAddress(LibHandle, '__adSaveFile'           );
     @__adSetupDwgRead       := GetProcAddress(LibHandle, '__adSetupDwgRead'       );
     //@__adSetupDxfRead       := GetProcAddress(LibHandle, '__adSetupDxfRead'       );
     @__adSetAd2LoadometerFn := GetProcAddress(LibHandle, '__adSetAd2LoadometerFn' );
     @__adSetAd2SaveometerFn := GetProcAddress(LibHandle, '__adSetAd2SaveometerFn' );
     //@__adNewFile            := GetProcAddress(LibHandle, '__adNewFile'            );
     @__adError              := GetProcAddress(LibHandle, '__adError'              );
     @__adErrorStr           := GetProcAddress(LibHandle, '__adErrorStr'           );

     //Intialization of the viewkit.
     //You can find the description of __adinitad2 on page 119 in the
     //OpenDWG Tool kit Reference manual 1.0.
     //initialize ad2 (OpenDWG)
     StrPCopy(FileNameArray, SystemDirectory + 'adinit.dat');
     if (__adInitAd2(@FileNameArray, 0, @initerr)) <> 1 then
     begin
        ShowMessage('Cannot initialize OpenDWG.dll because some problems with ADINIT.DAT file');
        exit;
     end;

     //Setup OpenDWG for reading and writing dwg
     //Descr on Page 191 and 192 OpenDWG Tool kit Reference manuel 1.0.
     __adSetupDwgRead;
     //__adSetupDxfRead;


     __adSetAd2LoadometerFn(@loadometer);
     __adSetAd2SaveometerFn(@saveometer);

     result:= true;
  end;

  function OpenDWGFile( const FileName: string ):boolean;
  begin
     result:=false;
     Gis1.StartProgress('Reading DWG file...',0,100);
     DrawingHandle:=__adLoadFile(Pointer(FileName),AD_PRELOAD_ALL);//creating pointer to drawinghandle
     Gis1.EndProgress;
     // write to temporary drawing file

     if DrawingHandle= nil then
     begin
       ShowMessage(__adErrorStr(__adError){'This DrawingFile Is Corrupt.'});
     end else
     begin
       result:=true;
     end;
  end;

  function SaveDWGFileAs(FileType:byte;Fileversion:smallint; Filename:string):boolean;
  begin
    Gis1.StartProgress('Saving DWG file...',0,100);
    if __adSaveFile(DrawingHandle,Pointer(Filename) ,Filetype, FileVersion, 0, 6,1,1)<>1 then
    begin
       ShowMessage(__adErrorStr(__adError));
       result:=false;
    end else
    begin
       result:=true;
    end;
    Gis1.EndProgress;

  // For filetypes you can use consts AD_DXF and AD_DWG these can be found in ad2cnst.pas
  // For FileVersion you can use AD_ACAD25, AD_ACAD26, AD_ACAD9, AD_ACAD10, AD_ACAD11, AD_ACAD13, AD_ACAD14.
  // These ara also in ad2cnst.pas
  end;

  procedure CloseDWGFile;
  begin
    if DrawingHandle= nil then exit;
    __adCloseFile(DrawingHandle);
    DrawingHandle:= nil;
  end;


begin
  if not OpenDialog3.Execute then Exit;

  LibHandle:= 0;

  if not LoadDWGDLL then Exit;

  try
    Screen.Cursor:= crHourglass;
    if not OpenDWGFile(OpenDialog3.FileName) then
    begin
      Screen.Cursor:= crDefault;
      Exit;
    end;
    NewFilename:= ChangeFileExt(OpenDialog3.FileName, '.dxf');
    if FileExists(NewFilename) then
      SysUtils.DeleteFile(NewFilename);   // delete ????
    SaveDWGFileAs(AD_DXF, AD_ACAD14, NewFilename);
    CloseDWGFile;
  finally
    FreeLibrary(LibHandle);
  end;
end;

procedure TForm1.HotSpot1Click(Sender: TObject);
var
  Layer  : TEzBaseLayer;
  ViewerHandle: HWND;
begin
  Layer:= GetLayerFromDialog(Gis1);
  if Layer= nil then Exit;
  if not SaveDialog2.Execute then Exit;
  with TEzHTMLMap.Create(nil) do
    try
       DrawBox := Self.DrawBox1;
       HTMLTemplate := ExtractFilePath(Application.ExeName) + 'map.htm';
       ImageWidth := DrawBox1.ClientWidth;
       ImageHeight := DrawBox1.ClientHeight;
       SaveToFile(Layer.Name,SaveDialog2.FileName);
    finally
       Free;
    end;
  ViewerHandle := ShellExecute(0, 'open', PChar(SaveDialog2.FileName), nil, nil, SW_SHOWNORMAL);
  SetForegroundWindow(ViewerHandle);
end;

procedure TForm1.CreateThumnaillbitmap1Click(Sender: TObject);
var
  Bmp: TBitmap;
begin
  if not SaveDialog3.Execute then exit;
  // create a thumbnail bitmap of 50x50 pixels
  Bmp:= TBitmap.create;
  try
    Bmp.PixelFormat:= pf24bit;
    Bmp.Width:= 50;
    Bmp.Height:= 50;
    DrawBox1.CreateThumbnail(Bmp);
    Bmp.SaveToFile(SaveDialog3.FileName);
  finally
    Bmp.free;
  end;
end;

procedure TForm1.Clippolygon1Click(Sender: TObject);
begin
  DrawBox1.ClipPolylineAgainstPolygon;
  DrawBox1.Repaint;
end;

procedure TForm1.BandedTiff1Click(Sender: TObject);
begin
  CmdLine1.DoCommand('BANDSTIFF','');
end;

procedure TForm1.FormPaint(Sender: TObject);
var
  Inifile: TInifile;
  Filename: string;
begin
  if not FWasPainted then
  begin
    FWasPainted:= true;
    Exit;
    Inifile:= TInifile.Create(ExtractFilePath(Application.Exename)+'MapConfig.ini');
    try
      Filename:=IniFile.ReadString('RecentFiles', 'LastWorkedMap', '');
      if Length(Filename) > 0 then
      begin
        { check if the database exists }
        SetConnectionDefaults;
        Gis1.FileName:= FileName;
        Gis1.Open;
      end;
    finally
      Inifile.Free;
    end;
  end;
end;

procedure TForm1.Makeblockfromselection1Click(Sender: TObject);
var
  BlockName: string;
begin
  if DrawBox1.Selection.Count=0 then
  begin
    MessageDlg('No entities selected', mtError, [mbOk], 0);
    exit;
  end;
  BlockName := InputBox( 'Make block', 'Name of new block', '' );
  if Length(BlockName) = 0 then Exit;
  if FileExists(AddSlash(Ez_Preferences.CommonSubDir) + BlockName + '.edb') then
  begin
    // block already exists
    if MessageDlg('Block already exists !' + #13 + 'Add anyway ?', mtConfirmation, [mbYes, mbNo], 0) <> mrYes then Exit;
  end;
  DrawBox1.CreateBlockFromSelection(BlockName);
end;

procedure TForm1.ARRAYfromselection1Click(Sender: TObject);
begin
  if DrawBox1.Selection.Count = 0 then Exit;
  with TfrmRepeat.Create(Nil) do
    Try
      if Not (ShowModal = mrOk) then Exit;
      DrawBox1.ARRAYFromSelection( Trunc( EzNumEd1.NumericValue ),
        Trunc( EzNumEd2.NumericValue ),
        EzNumEd3.NumericValue, EzNumEd4.NumericValue );
      DrawBox1.Repaint;
    Finally
      Free;
    End;
end;

procedure TForm1.Deleterepetitions1Click(Sender: TObject);
var
  Layer: TEzBaseLayer;
begin
  Layer := GetLayerFromDialog(Gis1);
  if Layer=nil then exit;
  { Procedure DeleteRepetitions( const LayerName: string;
    EntityID: TEzEntityID; IncludeAttribs: Boolean; SearchAllLayers: Boolean = False  );
    if EntityID = idNone then all entities are searched otherwise only defined entity
    if IncludeAttribs = true, then only entities with same coordinates and attributes (like
      filling, line type, symbol style, etc.) are deleted
    if SearchAllLayers = false, then only repeated entities in the same layer are deleted
  }
  DrawBox1.DeleteRepetitions( Layer.Name, idNone, False, False);
  DrawBox1.Repaint;
end;

procedure TForm1.ThematicsEditor1Click(Sender: TObject);
begin
  with TfrmThematicsEditor.Create(Nil) do
    try
      Enter(Self.ThematicBuilder1, DrawBox1 ) ;
      if Self.ThematicBuilder1.ShowThematic then
      begin
        if frmLegend = Nil then
        begin
          fLegend.ParentLegendHWND:= Self.Handle;
          frmLegend:= TfrmLegend.Create(Application);
        end;
        frmLegend.Legend1.PopulateFrom( Self.ThematicBuilder1 );
        frmLegend.Show;
      end else
      begin
        if frmLegend = Nil then
        begin
          fLegend.ParentLegendHWND:= Self.Handle;
          frmLegend:= TfrmLegend.Create(Application);
        end;
        frmLegend.Hide;
      end;
    finally
      Free;
    end;
end;

procedure TForm1.BtnGraphInfoClick(Sender: TObject);
begin
  { defines the parent of the inspector form. Take a look at fInspector.pas }
  InspParentHWND:= Self.Handle;

  TfrmInspector.Create(Nil).Enter(CmdLine1);
end;

procedure TForm1.BtnSplineTextClick(Sender: TObject);
var
  AText: string;
  ImageDims: TPoint;
begin
  { SPLINETEXT - command }
  AText:= InputBox('Text in spline', 'Text :', '' );
  if AText= '' then Exit;
  CmdLine1.Push( TAddEntityAction.CreateAction( CmdLine1,
    TEzSplineText.CreateEntity(Sender=BtnSplineTextTT,AText), ImageDims ), true, 'SPLINETEXT', '' )
end;

procedure TForm1.Preferences2Click(Sender: TObject);
begin
  with TfrmPreferences.Create(Nil) do
    try
      Enter(Self.Preferences1);
    finally
      free;
    end;
end;

procedure TForm1.WMEnterSizeMove(var m: TMessage);
begin
  inherited;
  DrawBox1.BeginUpdate;
  FOldWidth:= DrawBox1.Width;
  FOldHeight:= DrawBox1.Height;
end;

procedure TForm1.WMExitSizeMove(var m: TMessage);
begin
  inherited;
  if (DrawBox1.Width = FOldWidth) And (DrawBox1.Height = FOldHeight) then
    DrawBox1.CancelUpdate
  else
    DrawBox1.EndUpdate;
end;

procedure TForm1.Viewportconfig1Click(Sender: TObject);
begin
  with TfrmDBInspector.Create(Nil) do
    try
      Enter( Self.DrawBox1 );
    finally
      Free;
    end;
end;

procedure TForm1.Gisconfig1Click(Sender: TObject);
begin
  with TfrmGisInspector.Create(Nil) do
    try
      enter(Self.Gis1);
    finally
      free;
    end;
end;

procedure TForm1.Layersconfig1Click(Sender: TObject);
begin
  with TfrmLayerInspector.create(nil) do
    try
      enter(self.gis1);
    finally
      free;
    end;
end;

procedure TForm1.GIS1GisTimer(Sender: TObject;
  var CancelPainting: Boolean);
begin
  CancelPainting:= DetectCancelPaint( DrawBox1 );
end;

procedure TForm1.GIS1LabelEntity(Sender: TObject; Layer: TEzBaseLayer;
  Recno: Integer; Entity: TEzEntity; Grapher: TEzGrapher; Canvas: TCanvas;
  const Clip: TEzRect; Captions: TStrings; var Position: TEzLabelPos;
  var AlignLabels, RepeatInSegments, SmartShowing: Boolean;
  LabelsFont: TEzFontTool; var TrueType, Accept: Boolean);
begin
{$IFDEF FALSE}
  if AnsiCompareText(Layer.Name,'STATES_')=0 then
  begin
    if Layer.DBTable=nil then
    begin
      Accept:= false;
      exit;
    end;
    Layer.DBTable.Recno:= Recno;
    Caption:=Layer.DBTable.StringGet('STATE_NAME');
    LabelsFont.Name:= 'Complex';
    LabelsFont.Color:= clBlue;
    LabelsFont.Height:= 0.67;//Grapher.PointsToDistY(10);
    Accept:=true;
  end;

  if AnsiCompareText(Layer.Name,'ROADS_')=0 then
  begin
    if Layer.DBTable=nil then
    begin
      Accept:= false;
      exit;
    end;
    Layer.DBTable.Recno:= Recno;
    Caption:=Layer.DBTable.StringGet('ROUTE');
    LabelsFont.Name:= 'Arial'; // 'Arial'
    LabelsFont.Color:= clBlue;
    LabelsFont.Height:= 0.67;//Grapher.PointsToDistY(10);
    Position:= lpCenterUp;
    AlignLabels:= true;
    RepeatInSegments:= false;
    TrueType:= true;
    Accept:=true;
  end;
{$ENDIF}
end;

end.
