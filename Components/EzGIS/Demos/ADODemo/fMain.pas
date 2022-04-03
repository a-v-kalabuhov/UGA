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
  Mask, EzThematics, EzUtils, EzMiscelCtrls, fAccuDraw, fAddPlace,
  fBrowse, fAccuSnap, fViews, fRounded, fLegend, fMultipart;

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
    ADOQuery1: TADOQuery;
    SaveDialog4: TSaveDialog;
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
    ShowAccuSnap3: TMenuItem;
    AccuDraw2: TMenuItem;
    N10: TMenuItem;
    N31: TMenuItem;
    NamedViews1: TMenuItem;
    BtnSymbolMult: TSpeedButton;
    BtnRounded: TSpeedButton;
    BtnMulti: TSpeedButton;
    btnArcCRSE: TSpeedButton;
    BtnSCS: TSpeedButton;
    N40: TMenuItem;
    Query1: TMenuItem;
    ShowAccuSnap1: TMenuItem;
    Configure1: TMenuItem;
    AccuDraw1: TMenuItem;
    Configure2: TMenuItem;
    Rotate1: TMenuItem;
    Unrotate1: TMenuItem;
    ChangeOrigin1: TMenuItem;
    ScaleBar1: TEzScaleBar;
    GIS1: TEzADOGIS;
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
    procedure BtnCircle3PClick(Sender: TObject);
    procedure BtnCircleCRClick(Sender: TObject);
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
    procedure Reproject1Click(Sender: TObject);
    procedure DrawBox1GridError(Sender: TObject);
    procedure GIS1Progress(Sender: TObject; Stage: TEzProgressStage;
      const Caption: String; Min, Max, Position: Integer);
    procedure BtnTextClick(Sender: TObject);
    procedure CmdLine1StatusMessage(Sender: TObject;
      const AMessage: String);
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
    procedure FormDestroy(Sender: TObject);
    procedure NamedViews1Click(Sender: TObject);
    procedure BtnSymbolMultClick(Sender: TObject);
    procedure CmdLine1AccuDrawActivate(Sender: TObject);
    procedure CmdLine1AccuDrawChange(Sender: TObject);
    procedure CmdLine1AccuSnapChange(Sender: TObject);
    procedure BtnRoundedClick(Sender: TObject);
    procedure BtnMultiClick(Sender: TObject);
    procedure btnArcCRSEClick(Sender: TObject);
    procedure BtnSCSClick(Sender: TObject);
    procedure Query1Click(Sender: TObject);
    procedure ShowAccuSnap1Click(Sender: TObject);
    procedure Configure1Click(Sender: TObject);
    procedure AccuDraw1Click(Sender: TObject);
    procedure Configure2Click(Sender: TObject);
    procedure Rotate1Click(Sender: TObject);
    procedure Unrotate1Click(Sender: TObject);
    procedure ChangeOrigin1Click(Sender: TObject);
    procedure GIS1AfterPaintLayer(Sender: TObject; Layer: TEzBaseLayer;
      Grapher: TEzGrapher; var EntList: TEzEntityList;
      var AutoFree: Boolean);
    procedure GIS1BeforePaintLayer(Sender: TObject; Layer: TEzBaseLayer;
      Grapher: TEzGrapher; var CanShow, WasFiltered: Boolean;
      var EntList: TEzEntityList; var AutoFree: Boolean);
  private
    { Private declarations }
    FfrmAerial: TfrmAerial;
    frmEditDB: TfrmEditDB;
    FTestBitmap: TBitmap;
    FWasPainted: Boolean;
    FOldWidth, FOldHeight: Integer;
    FCustomPicture: TPicture;
    FLayersOptions: TEzLayersOptions;
    //FTileBitmap: TBitmap;
    FNamedViews: TEzNamedViews;
    FfrmViews: TfrmViews;
    FThematicList: TList;
    FfrmBrowse: TfrmDemoBrowse;
    FfrmAccuDraw: TfrmAccuDraw;
    FfrmAddPlace: TfrmAddPlace;
    FfrmAccuSnap: TfrmAccuSnap;
    FfrmRounded: TfrmRounded;
    FfrmMultipart: TfrmMultipart;
    FfrmLegend: TfrmLegend;
    procedure ClearThematicList;
    procedure LoadNamedViews;
    procedure SaveNamedViews;
    procedure FileProgress(Sender: TObject; const Filename: string;
      Progress, NoEntities, BadEntities: Integer; var CanContinue: Boolean);
    procedure SetConnectionDefaults;
    procedure WMEnterSizeMove( Var m: TMessage ); Message WM_ENTERSIZEMOVE;
    procedure WMExitSizeMove( Var m: TMessage ); Message WM_EXITSIZEMOVE;
    function GetGIS: TEzBaseGIS;
    procedure VerifySizes;
  public
    { Public declarations }
    Property LayersOptions: TEzLayersOptions read FLayersOptions;
    Property NamedViews: TEzNamedViews read FNamedViews;
    Property frmViews: TfrmViews read FfrmViews write FfrmViews;
    Property frmAerial: TfrmAerial read FfrmAerial write FfrmAerial;
    Property frmBrowse: TfrmDemoBrowse read FfrmBrowse write FfrmBrowse;
    Property frmAccuDraw: TfrmAccuDraw read FfrmAccuDraw write FfrmAccuDraw;
    Property frmAddPlace: TfrmAddPlace read FfrmAddPlace write FfrmAddPlace;
    Property frmAccuSnap: TfrmAccuSnap read FfrmAccuSnap write FfrmAccuSnap;
    Property frmRounded: TfrmRounded read FfrmRounded write FfrmRounded;
    Property frmMultipart: TfrmMultipart read FfrmMultipart write FfrmMultipart;
    Property frmLegend: TfrmLegend read FfrmLegend write FfrmLegend;
    Property GIS: TEzBaseGIS read GetGIS;
  end;

  Function DetectCancelPaint( DrawBox: TEzBaseDrawBox ): Boolean;
  procedure ShadeIt(f: TForm; c: TControl; Width: Integer; Color: TColor);

var
  Form1: TForm1;

implementation

{$R *.dfm}

uses Math,
  ezentities, ezsystem, EzPolyClip, Inifiles, fLayers, ezrtree,
  ezconsts, fLineTypeEd, fdemoprevw, fSymbEd, fRasterImageEd, 
  fProgr, ezshpimport, EzDxfImport, EzMIFIMport, EzDGNImport,
  fLineType, fSymbolType, fFontStyle, fLayerSelect, fRestructure, fMapUnits,
  fBrushStyle, fAddEntity, fReproject, fAbout, fRichEdit, ezhtmlmap, ShellAPI,
  fThemsEditor, fRepeat, fInspector, EzInspect, EzActions, EzMiscelEntities,
  fPref, fDBInspector, fGisInspector, fLayerInspector, EzActionLaunch,
  fDGNImport, fDxfImport, fAccuDrawSetts, fAccuSnapSetts, fExpressBuilder,
  fVectorialExpr, fSpatialQuery, fSelec,
  Chart, Series, TeEngine;


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
  Gis1.ADOConnection.ConnectionString:=
    { you must provide/configure here your connection string }
    'Provider=SQLOLEDB.1;Integrated Security=SSPI;Persist Security Info=False;'+
    'Data Source=ALFONSOXP;Use Procedure for Prepare=1;Auto Translate=True;'+
    'Packet Size=4096;Workstation ID=ALFONSOXP;Use Encryption for Data=False;'+
    'Tag with column collation when possible=False';
  Gis1.ADOConnection.CursorLocation:= clUseClient;
  Gis1.ADOConnection.DefaultDatabase:= 'master';
  Gis1.ADOConnection.KeepConnection:= true;
  Gis1.ADOConnection.LoginPrompt:= False;
end;


procedure TForm1.New1Click(Sender: TObject);
var
  DatabaseName: string;
begin
  if not SaveDialog4.Execute then Exit;
  Gis1.Close;
  SetConnectionDefaults;

  DatabaseName:= ChangeFileExt(ExtractFileName(SaveDialog4.FileName),'');
  ADOQuery1.Connection:= Gis1.ADOConnection;

  { create the database }
  with ADOQuery1 do
  begin
    Close;
    SQL.Clear;
    SQL.Add(Format(' CREATE DATABASE %s ',[DatabaseName]));
    SQL.Add(' ON ');
    SQL.Add('(');
    SQL.Add(Format(' NAME = %s, ', [DatabaseName]));
    SQL.Add(Format(' FILENAME = ''%s'' ', [SaveDialog4.FileName]));
    // other possible parameters
    //SQL.Add(', SIZE = 10')
    //SQL.Add(', MAXSIZE = 50')
    //SQL.Add(', FILEGROWTH = 5')
    SQL.Add(')');
    ExecSQL;
    Close;
  end;
  Gis1.ADOConnection.DefaultDatabase := DatabaseName;
  { Now, create all files on this database }
  Gis1.CreateNew( DatabaseName );
  Gis1.FileName:= DatabaseName;
  Gis1.Open;
  LoadNamedViews;
end;

procedure TForm1.Exit1Click(Sender: TObject);
begin
  Close;
end;

procedure TForm1.Open1Click(Sender: TObject);
var
  DatabaseName: string;
begin
  Gis1.Close;
  DatabaseName:= InputBox('Database to open', 'Database :', '');
  if Length(DatabaseName)=0 then Exit;
  SetConnectionDefaults;

  Gis1.ADOConnection.DefaultDatabase:= DatabaseName;
  Gis1.FileName:= DatabaseName;
  Gis1.Open;
  LoadNamedViews;
end;

procedure TForm1.Layers1Click(Sender: TObject);
begin
  if not GIS1.Active then exit;
  with TfrmLayers.Create(Nil) do
    try
      Enter(Self.DrawBox1);
    finally
      Free;
    end;
end;

procedure TForm1.Save1Click(Sender: TObject);
begin
  if Length( Gis1.FileName ) = 0 then Exit;
  Gis1.Save;
  SaveNamedViews;
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
  VerifySizes;
  CmdLine1.DoCommand('JUSTIFTEXT','');
end;

procedure TForm1.btnFittedTextClick(Sender: TObject);
begin
  VerifySizes;
  CmdLine1.DoCommand('FITTEDTEXT','');
end;

procedure TForm1.BtnBannerTextClick(Sender: TObject);
begin
  VerifySizes;
  CmdLine1.DoCommand('BANNER','');
end;

procedure TForm1.btnCalloutClick(Sender: TObject);
begin
   VerifySizes;
   CmdLine1.DoCommand('CALLOUTTEXT','');
end;

procedure TForm1.btnBulletLeaderClick(Sender: TObject);
begin
   VerifySizes;
   CmdLine1.DoCommand('BULLETLEADER','');
end;

procedure TForm1.BtnSymbolClick(Sender: TObject);
begin
  VerifySizes;
  CmdLine1.DoCommand('SYMBOL', 'CUSTOMERS');  // dummy stateID
end;

procedure TForm1.BtnTxtPlaceClick(Sender: TObject);
begin
   VerifySizes;
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
  VerifySizes;
  CmdLine1.DoCommand('DIMHORZ','');
end;

procedure TForm1.btnDimVertClick(Sender: TObject);
begin
  VerifySizes;
  CmdLine1.DoCommand('DIMVERT','');
end;

procedure TForm1.btnDimParClick(Sender: TObject);
begin
  VerifySizes;
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

  FLayersOptions:= TEzLayersOptions.Create;
  FNamedViews:= TEzNamedViews.Create(DrawBox1);
  FCustomPicture:= TPicture.Create;
  FThematicList:= TList.Create;

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

  { show accusnap }
  CmdLine1.AccuSnap.Enabled:= False;
  CmdLine1.AccuSnap.OsnapSetting:= osKeyPoint;
  CmdLine1.AccuSnap.SnapDivisor:= 2;

end;

procedure TForm1.Undo1Click(Sender: TObject);
begin
  Screen.Cursor:= crHourglass;
  DrawBox1.Undo.Undo;
  Screen.Cursor:= crDefault;
end;

procedure TForm1.Cut1Click(Sender: TObject);
begin
  DrawBox1.Undo.CopyToClipboardFromSelection;
  DrawBox1.DeleteSelection;
  GIS1.RepaintViewports;
end;

procedure TForm1.Copy1Click(Sender: TObject);
begin
  DrawBox1.Undo.CopyToClipboardFromSelection;
end;

procedure TForm1.Paste1Click(Sender: TObject);
begin
  DrawBox1.Undo.PasteFromClipboardTo;
  DrawBox1.Repaint;
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
  filnam:=EzActions.SelectCommonElement(Subdir, 'EzGIS Georeferenced Images (*.GRI)', liAllImages);
  if Length(filnam)=0 then exit;
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
  Undo1.Caption:= DrawBox1.Undo.GetVerb;
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
  DGNImport: TEzDGNImport;
  DxfImport: TEzDxfImport;
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
          frmProgressDialog.DispMsg.Caption:=
            Format( 'DXF Import from %s...',
                    [frmProgressDialog.GetShortDispname(OpenDialog1.FileName)] );
          DxfImport:= TEzDxfImport.Create(nil) ;
          try
            DxfImport.DrawBox:= Self.DrawBox1;
            DxfImport.FileName:= OpenDialog1.FileName;
            DxfImport.Layername:= GIS1.CurrentLayerName;
            DxfImport.ConfirmProjectionSystem:= true;
            DxfImport.OnFileProgress:= Self.FileProgress;
            DxfImport.ReadDxf;
            { now allow user to select parameters }
            with TfrmDxfImport.Create(Nil) do
              try
                If Enter( DxfImport ) = mrOk then
                begin
                  DxfImport.Execute;
                end;
              finally
                Free;
              end;
            // all went okay
          finally
            DxfImport.Free;
          end;
        end;
      4:  // Microstation .DGN files
        begin
          DGNImport:= TEzDGNImport.Create(nil);
          try
            DGNImport.DrawBox:= Self.DrawBox1;
            DGNImport.Filename:= Opendialog1.FileName;
            DGNImport.ConfirmProjectionSystem:= true;   // or false
            DGNImport.OnFileProgress:= Self.FileProgress;
            DGNImport.ReadDGN;
            { now allow user to select parameters }
            with TfrmDGNImport.Create(Nil) do
              try
                If Enter( DgnImport ) = mrOk then
                begin
                  DgnImport.Execute;
                end;
              finally
                Free;
              end;
          finally
            DGNImport.Free;
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
  LayerGridBox1.Gis:= Self.Gis1;
end;

procedure TForm1.BtnCircle3PClick(Sender: TObject);
begin
  CmdLine1.DoCommand('CIRCLE3P','');
end;

procedure TForm1.BtnCircleCRClick(Sender: TObject);
begin
  CmdLine1.DoCommand('CIRCLECR','');
end;

procedure TForm1.BtnAerialViewClick(Sender: TObject);
begin
  { create the aerial view }
  if frmAerial=nil then
  begin
    fAerial.ParentHWND:= Self.handle;
    frmAerial:= TfrmAerial.Create(Nil);
    frmAerial.AerialView1.ParentView:= Self.DrawBox1;
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
  VerifySizes;
  CmdLine1.DoCommand('TEXT','');
end;

procedure TForm1.CmdLine1StatusMessage(Sender: TObject;
  const AMessage: String);
begin
  StatusBar1.Panels[0].Text:= AMessage;
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
  Exists: Boolean;
begin
  if not FWasPainted then
  begin
    FWasPainted:= true;
    Inifile:= TInifile.Create(ExtractFilePath(Application.Exename)+'MapConfig.ini');
    try
      Filename:=IniFile.ReadString('RecentFiles', 'LastWorkedMap', '');
      if Length(Filename) > 0 then
      begin
        { check if the database exists }
        SetConnectionDefaults;
        ADOQuery1.Connection:= Gis1.ADOConnection;
        ADOQuery1.Close;
        ADOQuery1.SQL.Clear;
        ADOQuery1.SQL.Add(Format('SELECT name FROM sysdatabases WHERE name = ''%s''',[Filename]));
        ADOQuery1.Open;
        Exists:= Not ADOQuery1.Eof;
        ADOQuery1.Close;
        if Exists then
        begin
          Gis1.ADOConnection.DefaultDatabase:= Filename;
          Gis1.FileName:= FileName;
          Gis1.Open;
        end;
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
  showmessage('Please check main demo for implementation of this option');
end;

procedure TForm1.BtnGraphInfoClick(Sender: TObject);
begin
  InspParentHWND:= Self.Handle;

  TfrmInspector.Create(Nil).Enter(CmdLine1);
end;

procedure TForm1.BtnSplineTextClick(Sender: TObject);
var
  AText: string;
  ImageDims: TPoint;
begin
  VerifySizes;
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

procedure TForm1.FormDestroy(Sender: TObject);
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

  FCustomPicture.Free;

  FreeAndNil(FLayersOptions);
  FreeAndNil(FNamedViews);

  { the stay on top forms .... }
  if FfrmBrowse <> nil then FreeAndNil( FfrmBrowse );
  if FfrmViews <> nil then FreeAndNil( FfrmViews );
  If FfrmAccuDraw <> Nil then FreeAndNil( FfrmAccuDraw );
  If FfrmAddPlace <> Nil then FreeAndNil( FfrmAddPlace );
  If FfrmAerial <> Nil then FreeAndNil( FfrmAerial );
  If FfrmAccuSnap <> Nil then FreeAndNil( FfrmAccuSnap );

  ClearThematicList;
  FThematicList.Free;

  Path:= AddSlash(ExtractFilePath(Application.ExeName));
  ScaleBar1.SaveToInifile(Path + 'Config.ini');

end;

procedure TForm1.NamedViews1Click(Sender: TObject);
begin
  Namedviews1.checked:= not Namedviews1.checked;
  if Namedviews1.checked then
  begin
    if frmViews = nil then
    begin
      NamedViewParentHWND:=Self.Handle;
      FfrmViews:= TfrmViews.create(Nil);
    end;
    FfrmViews.Enter(cmdLine1);
  end else
    if Assigned(FfrmViews) then
      FreeAndNil( FfrmViews );
end;

procedure TForm1.BtnSymbolMultClick(Sender: TObject);
begin
  VerifySizes;
  if BtnSymbolMult.Down then
  begin
    { create the aerial view }
    if FfrmAddPlace=nil then
      FfrmAddPlace:= TfrmAddPlace.Create(Nil);
    FfrmAddPlace.Show;
    Self.SetFocus;
  end else if Assigned( FfrmAddPlace ) then
  begin
    { this causes to:
      - finish the action
      - set variable FfrmAddPlace to Nil from fAddPlace form/unit
    }
    FfrmAddPlace.Launcher1.Finish;
  end;
end;

procedure TForm1.CmdLine1AccuDrawActivate(Sender: TObject);
var
  p: TPoint;
begin
  If CmdLine1.AccuDraw.Enabled then
  begin
    If FfrmAccuDraw = Nil then
    begin
      FfrmAccuDraw := TfrmAccuDraw.Create(Nil);
      p:= Self.ClientToScreen(Point(DrawBox1.Left,DrawBox1.Top));
      FfrmAccuDraw.Left:= p.x;
      FfrmAccuDraw.Top:= p.Y;
    end;

    If CmdLine1.AccuDraw.FrameStyle=fsPolar then
      FfrmAccuDraw.BtnPolar.Down:= true
    else If CmdLine1.AccuDraw.FrameStyle=fsRectangular then
      FfrmAccuDraw.BtnRect.Down:= true;
    with FfrmAccuDraw do
    begin
      NumEd1.NumericValue:= 0;
      NumEd2.NumericValue:= 0;
      chkX.Checked:= false;
      chkY.Checked:= false;
    end;
    FfrmAccuDraw.Show;
    Windows.SetFocus( Self.Handle );
  end;
end;

procedure TForm1.CmdLine1AccuDrawChange(Sender: TObject);
var
  DX,DY: Double;
begin
  If FfrmAccuDraw=Nil Then Exit;
  FfrmAccuDraw.InUpdate:= True;
  try
    with FfrmAccuDraw, CmdLine1.AccuDraw do
    begin
      If FrameStyle = fsRectangular then
      begin
        Label1.Caption:= 'Delta X: ';
        Label2.Caption:= 'Delta Y: ';
      end else
      begin
        Label1.Caption:= 'Distance: ';
        Label2.Caption:= 'Angle   : ';
      end;

      CmdLine1.AccuDraw.CurrentDimensions( DX, DY );
      NumEd1.NumericValue:= DX;   // delta x or distance
      If FrameStyle = fsRectangular Then  // delta y or angle
        NumEd2.NumericValue:= DY
      else
        NumEd2.NumericValue:= RadToDeg( DY );
      ChkX.Checked:= DeltaXLocked;
      ChkY.Checked:= DeltaYLocked;
    end;
  finally
    FfrmAccuDraw.InUpdate:= False;
  end;
end;

procedure TForm1.CmdLine1AccuSnapChange(Sender: TObject);
var
  I: Integer;
begin
  if FfrmAccuSnap=nil then exit;
  { repaint the current default snap }
  FfrmAccuSnap.Paintbox1.Invalidate;
  { configure the speed buttons on the form }
  For I:= 0 to FfrmAccuSnap.ComponentCount-1 do
  begin
    If (FfrmAccuSnap.Components[I] is TSpeedButton) And
      (TSpeedButton(FfrmAccuSnap.Components[I]).Tag <> 0) then
    begin
      { set the button up }
      TSpeedButton(FfrmAccuSnap.Components[I]).Down:=false;
      { if the button correspond with the default override setting, then put it down }
      If CmdLine1.AccuSnap.OverrideOsnap And
        (TEzOsnapSetting( TSpeedButton(FfrmAccuSnap.Components[I]).Tag ) = CmdLine1.AccuSnap.OverrideOsnapSetting) Then
        TSpeedButton(FfrmAccuSnap.Components[I]).Down:= True;
    end;
  end;
end;

procedure TForm1.BtnRoundedClick(Sender: TObject);
begin
  if FfrmRounded=Nil then
  begin
    FfrmRounded:= TfrmRounded.Create(Nil);
    FfrmRounded.Show;
    DrawBox1.SetFocus;
  end else
    FreeAndNil( FfrmRounded );
end;

procedure TForm1.BtnMultiClick(Sender: TObject);
begin
  if FfrmMultipart=Nil then
  begin
    FfrmMultipart:= TfrmMultipart.Create(Nil);
    FfrmMultipart.Show;
    DrawBox1.SetFocus;
  end else
    FreeAndNil( FfrmMultipart );
end;

procedure TForm1.btnArcCRSEClick(Sender: TObject);
begin
  CmdLine1.Clear;
  CmdLine1.DoCommand('ARCSE','');
end;

procedure TForm1.BtnSCSClick(Sender: TObject);
begin
  CmdLine1.Clear;
  CmdLine1.DoCommand('ARCFCS','');
end;

procedure TForm1.Query1Click(Sender: TObject);
var
  Layer: TEzBaseLayer;
begin
  Layer:= GetLayerFromDialog(Gis1);
  if Layer=nil then exit;
  ParentSelectHWND := Self.Handle;
  TfrmSelectDlg.Create(Application).Enter(DrawBox1, CmdLine1, Layer);
end;

procedure TForm1.ClearThematicList;
var
  I: Integer;
begin
  for I:= 0 to FThematicList.Count-1 do
    TEzThematicBuilder( FThematicList[I] ).Free;
  FThematicList.Clear;
end;

function TForm1.GetGIS: TEzBaseGIS;
begin
  Result:= GIS1;
end;

procedure TForm1.LoadNamedViews;
begin
  if Length(Gis1.FileName) > 0 then
    FNamedViews.LoadFromFile( ChangeFileExt(Gis1.FileName,'.vws') );
end;

procedure TForm1.SaveNamedViews;
begin
  if Length(Gis1.FileName) > 0 then
    FNamedViews.SaveToFile( ChangeFileExt(Gis1.FileName,'.vws') );
end;

procedure TForm1.VerifySizes;
var
  Pts: Double;
Begin
  Pts:= DrawBox1.Grapher.DistToPointsY( Ez_Preferences.DefSymbolStyle.Height );
  If ( Pts < 2 ) Or (Pts > 72) Then
  begin
    Pts:= 12;
    Ez_Preferences.DefSymbolStyle.Height:= DrawBox1.Grapher.PointsToDistY( Pts );
  end;
  Pts:= DrawBox1.Grapher.DistToPointsY( Ez_Preferences.DefFontStyle.Height );
  If ( Pts < 2 ) Or (Pts > 72) Then
  begin
    Pts:= 12;
    Ez_Preferences.DefFontStyle.Height:= DrawBox1.Grapher.PointsToDistY( Pts );
  end;
  Pts:= DrawBox1.Grapher.DistToPointsY( Ez_Preferences.DefTTFontStyle.Height );
  If ( Pts < 2 ) Or (Pts > 72) Then
  begin
    Pts:= 12;
    Ez_Preferences.DefTTFontStyle.Height:= DrawBox1.Grapher.PointsToDistY( Pts );
  end;
  Pts:= DrawBox1.Grapher.DistToPointsY( Ez_Preferences.DefPenStyle.Width );
  If ( Pts < 2 ) Or (Pts > 36) Then
  begin
    Ez_Preferences.DefPenStyle.Width:= 0;
  end;
end;

procedure TForm1.ShowAccuSnap1Click(Sender: TObject);
var
  p: TPoint;
begin
  ShowAccuSnap1.Checked:=not ShowAccuSnap1.Checked;
  if ShowAccuSnap1.Checked then
  begin
    { create the aerial view }
    if FfrmAccuSnap=nil then
      FfrmAccuSnap:= TfrmAccuSnap.Create(Nil);
    if FFrmAccuDraw<>Nil then
    begin
      FfrmAccuSnap.Left:= FfrmAccuDraw.Left;
      FfrmAccuSnap.Top:= FfrmAccuDraw.Top + FfrmAccuDraw.Height;
    end else
    begin
      FfrmAccuDraw := TfrmAccuDraw.Create(Nil);
      p:= Self.ClientToScreen(Point(DrawBox1.Left,DrawBox1.Top));
      FfrmAccuSnap.Left:= p.x;
      FfrmAccuSnap.Top:= p.y + FfrmAccuDraw.Height;
      FreeAndNil( FfrmAccuDraw  );
    end;
    FfrmAccuSnap.Show;
    ActiveControl:= DrawBox1;
  end else if Assigned( FfrmAccuSnap ) then
    FreeAndNil( FfrmAccuSnap );
end;

procedure TForm1.Configure1Click(Sender: TObject);
begin
  with TfrmAccuSnapSetts.create(nil) do
    try
      If (enter(Self.CmdLine1)=mrOk) And Assigned(FfrmAccuSnap) Then
        FfrmAccuSnap.Reset;
    finally
      free;
    end;
end;

procedure TForm1.AccuDraw1Click(Sender: TObject);
var
  p: TPoint;
begin
  AccuDraw1.Checked:=not AccuDraw1.Checked;
  if AccuDraw1.Checked then
  begin
    { create the aerial view }
    if frmAccuDraw=nil then
    begin
      frmAccuDraw:= TfrmAccuDraw.Create(Nil);
      p:= Self.ClientToScreen(Point(DrawBox1.Left,DrawBox1.Top));
      FfrmAccuDraw.Left:= p.x;
      FfrmAccuDraw.Top:= p.Y;
    end;
    frmAccuDraw.Show;
    ActiveControl:= DrawBox1;
  end else if Assigned( frmAccuDraw ) then
    FreeAndNil( FfrmAccuDraw );
end;

procedure TForm1.Configure2Click(Sender: TObject);
begin
  with TfrmAccuDrawSetts.create(nil) do
    try
      if (Enter(Self.CmdLine1)=mrOk) and Self.CmdLine1.AccuDraw.Enabled then
        DrawBox1.Refresh;
    finally
      free;
    end;
end;

procedure TForm1.Rotate1Click(Sender: TObject);
var
  Code: Integer;
  S: string;
  Rot:Double;
begin
  S:= InputBox( 'Rotate AccuDraw', 'Rotation angle', FloatToStr( RadToDeg(CmdLine1.AccuDraw.Rotangle) ));
  If S='' then Exit;
  Val(S, Rot, Code);
  If Code<>0 then Exit;
  CmdLine1.AccuDraw.ChangeOrigin( CmdLine1.AccuDraw.AccuOrigin, DegToRad(Rot) );
end;

procedure TForm1.Unrotate1Click(Sender: TObject);
begin
  If Not CmdLine1.AccuDraw.Showing Then Exit;
  CmdLine1.AccuDraw.ShowUnrotated;
end;

procedure TForm1.ChangeOrigin1Click(Sender: TObject);
begin
  If Not CmdLine1.AccuDraw.Showing Then Exit;
  { the AccuDraw origin will be defined to the last position on the draw box
    ( If AccuDraw is not visible, the command will be ignored )
  }
  with CmdLine1.AccuDraw do
    ChangeOrigin( CmdLine1.GetSnappedPoint, Rotangle );
  { you also can define like this in order to preserve AccuDraw current rotation angle
    ( Angle is an optional parameter with default value = 0 ) }
  //CmdLine1.AccuDraw.ChangeOrigin( CmdLine1.GetSnappedPoint, CmdLine1.AccuDraw.Rotangle );
end;

procedure TForm1.GIS1AfterPaintLayer(Sender: TObject; Layer: TEzBaseLayer;
  Grapher: TEzGrapher; var EntList: TEzEntityList; var AutoFree: Boolean);
begin
  If AnsiCompareText( ThematicBuilder1.LayerName, Layer.Name) = 0 then
    ThematicBuilder1.UnPrepare( Layer );
end;

procedure TForm1.GIS1BeforePaintLayer(Sender: TObject; Layer: TEzBaseLayer;
  Grapher: TEzGrapher; var CanShow, WasFiltered: Boolean;
  var EntList: TEzEntityList; var AutoFree: Boolean);
begin
  If AnsiCompareText( ThematicBuilder1.LayerName, Layer.Name) = 0 then
    ThematicBuilder1.Prepare( Layer );
end;

end.
