unit fMain;

{***********************************************************}
{   EzGIS/CAD Components                                    }
{   (c) 2002 EzSoft Engineering                             }
{   All Rights Reserved                                     }
{***********************************************************}

{$I EZ_FLAG.PAS}

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms,
  Dialogs, Menus, EzBaseGIS, EzCtrls, EzCmdLine,
  Buttons, ExtCtrls, Printers, Clipbrd, fAerial, fPrnPg, EzThematics,
  EzBase, ComCtrls, StdCtrls, EzMiscelCtrls, EzBasicCtrls,
  EzLib, Db, Grids, fViews, fBrowse,
  DBGrids, finspector, EzInspect, EzNumEd, ImgList, EzUtils, 
  fAccuDraw, fAddPlace, fAccuSnap, fRounded, fMultipart, fAutoLabel,
  fClipboard, fClone, fLegend, BandActn, StdActns, ActnMan, ActnList,
  PrjConst, ToolWin, ActnCtrls, ActnMenus, CustomizeDlg, EzActionLaunch,
  XPStyleActnCtrls;

type
  TForm1 = class(TForm)
    CmdLine1: TEzCmdLine;
    StatusBar1: TStatusBar;
    bar1: TProgressBar;
    GIS1: TEzGIS;
    EzGeorefImage1: TEzGeorefImage;
    OpenDialog1: TOpenDialog;
    SaveDialog1: TSaveDialog;
    OpenDialog2: TOpenDialog;
    Preferences1: TEzModifyPreferences;
    OpenDialog3: TOpenDialog;
    SaveDialog2: TSaveDialog;
    SaveDialog3: TSaveDialog;
    OpenDialog7: TOpenDialog;
    OpenDialog4: TOpenDialog;
    OpenDialog5: TOpenDialog;
    OpenDialog6: TOpenDialog;
    Timer1: TTimer;
    ActionManager1: TActionManager;
    FileOpen1: TFileOpen;
    FilePrintSetup1: TFilePrintSetup;
    EditUndo1: TEditUndo;
    EditCut1: TEditCut;
    EditCopy1: TEditCopy;
    EditPaste1: TEditPaste;
    EditDelete1: TEditDelete;
    HelpContents1: THelpContents;
    HelpOnHelp1: THelpOnHelp;
    Action4: TAction;
    Action6: TAction;
    Action7: TAction;
    Action8: TAction;
    Action9: TAction;
    actPrintPreview: TAction;
    Action12: TAction;
    Action17: TAction;
    Action19: TAction;
    Action20: TAction;
    Action21: TAction;
    Action22: TAction;
    Action23: TAction;
    Action24: TAction;
    Action25: TAction;
    Action26: TAction;
    Action27: TAction;
    Action28: TAction;
    Action29: TAction;
    Action30: TAction;
    Action31: TAction;
    Action32: TAction;
    Action33: TAction;
    Action34: TAction;
    Action35: TAction;
    Action36: TAction;
    Action37: TAction;
    Action38: TAction;
    Action39: TAction;
    Action40: TAction;
    Action41: TAction;
    Action42: TAction;
    Action43: TAction;
    Action44: TAction;
    Action45: TAction;
    Action46: TAction;
    Action47: TAction;
    Action48: TAction;
    Action49: TAction;
    Action50: TAction;
    Action51: TAction;
    Action52: TAction;
    Action54: TAction;
    Action55: TAction;
    Action56: TAction;
    actBrowse: TAction;
    Action58: TAction;
    Action59: TAction;
    Action60: TAction;
    Action61: TAction;
    Action62: TAction;
    Action63: TAction;
    Action64: TAction;
    actRepaint: TAction;
    Action66: TAction;
    Action67: TAction;
    Action68: TAction;
    Action69: TAction;
    actZoomWin: TAction;
    Action72: TAction;
    Action73: TAction;
    Action74: TAction;
    actViewGrid: TAction;
    Action76: TAction;
    Action77: TAction;
    actShowCmdLine: TAction;
    Action79: TAction;
    actNamedViews: TAction;
    Action81: TAction;
    Action82: TAction;
    Action83: TAction;
    Action84: TAction;
    Action85: TAction;
    Action86: TAction;
    Action87: TAction;
    actOrto: TAction;
    Action89: TAction;
    Action90: TAction;
    Action91: TAction;
    Action92: TAction;
    Action93: TAction;
    Action94: TAction;
    Action95: TAction;
    Action97: TAction;
    Action98: TAction;
    Action99: TAction;
    Action100: TAction;
    Action101: TAction;
    Action102: TAction;
    Action103: TAction;
    Action104: TAction;
    Action105: TAction;
    Action106: TAction;
    Action107: TAction;
    Action108: TAction;
    Action109: TAction;
    actShowAccuSnap: TAction;
    Action111: TAction;
    actAccuDraw: TAction;
    Action113: TAction;
    Action114: TAction;
    Action115: TAction;
    Action116: TAction;
    Action117: TAction;
    Action118: TAction;
    Action119: TAction;
    Action120: TAction;
    Action121: TAction;
    Action122: TAction;
    Action123: TAction;
    actSnapToGrid: TAction;
    actSnapToGLines: TAction;
    Action126: TAction;
    Action127: TAction;
    Action128: TAction;
    Action129: TAction;
    Action130: TAction;
    Action131: TAction;
    Action132: TAction;
    actMove: TAction;
    actScale: TAction;
    actRotate: TAction;
    Action136: TAction;
    Action137: TAction;
    Action138: TAction;
    Action139: TAction;
    Action140: TAction;
    Action141: TAction;
    Action142: TAction;
    Action143: TAction;
    Action144: TAction;
    Action145: TAction;
    Action146: TAction;
    actPreserveOriginals: TAction;
    Action148: TAction;
    Action149: TAction;
    Action150: TAction;
    Action151: TAction;
    Action152: TAction;
    Action156: TAction;
    Action157: TAction;
    Action158: TAction;
    Action159: TAction;
    Action160: TAction;
    Action161: TAction;
    Action162: TAction;
    Action163: TAction;
    Action164: TAction;
    Action165: TAction;
    Action166: TAction;
    Action167: TAction;
    Action168: TAction;
    Action169: TAction;
    ActionMainMenuBar1: TActionMainMenuBar;
    ActionToolBar1: TActionToolBar;
    ActionToolBar2: TActionToolBar;
    ActionToolBar3: TActionToolBar;
    ActionToolBar4: TActionToolBar;
    ActionToolBar6: TActionToolBar;
    actView1: TAction;
    actView2: TAction;
    actView3: TAction;
    actView4: TAction;
    actView5: TAction;
    actSymbolMult: TAction;
    actTextPlace: TAction;
    actRounded: TAction;
    actNextMarker: TAction;
    actPriorMarker: TAction;
    Images: TImageList;
    actDimHoriz: TAction;
    actDimVertical: TAction;
    actDimParallel: TAction;
    actArcCRSE: TAction;
    actArcSCE: TAction;
    actCircleCR: TAction;
    actCircle3P: TAction;
    actHGLines: TAction;
    actVGLines: TAction;
    actMeasures: TAction;
    actAutoLabel: TAction;
    actMultiPart: TAction;
    CustomizeActionBars2: TCustomizeActionBars;
    ReopenActionList1: TActionList;
    Action1: TAction;
    Action5: TAction;
    Action2: TAction;
    Action3: TAction;
    Action10: TAction;
    Panel1: TPanel;
    actZoomAll: TAction;
    actZoomPrevious: TAction;
    ActionToolBar5: TActionToolBar;
    CustomizeDlg1: TCustomizeDlg;
    Action11: TAction;
    actSketch: TAction;
    Action13: TAction;
    Action14: TAction;
    ERMapperLauncher: TEzActionLauncher;
    Action15: TAction;
    procedure actNewExecute(Sender: TObject);
    procedure actSaveExecute(Sender: TObject);
    procedure actHotSpotExecute(Sender: TObject);
    procedure actSaveclippedExecute(Sender: TObject);
    procedure actCreateThumnaillbitmapExecute(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormPaint(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure FormResize(Sender: TObject);
    procedure actPasteAndDefinePositionExecute(Sender: TObject);
    procedure actClearClipboardExecute(Sender: TObject);
    procedure actDropExecute(Sender: TObject);
    procedure actCopyToClipboardExecute(Sender: TObject);
    procedure actCopyToClipboardAsEmfExecute(Sender: TObject);
    procedure actGroupExecute(Sender: TObject);
    procedure actUngroupExecute(Sender: TObject);
    procedure actToFrontExecute(Sender: TObject);
    procedure actToBackExecute(Sender: TObject);
    procedure actMoveGuidelinesExecute(Sender: TObject);
    procedure actMakeBlockFromSelectionExecute(Sender: TObject);
    procedure actREPEATExecute(Sender: TObject);
    procedure actDeleteRepetitionsExecute(Sender: TObject);
    procedure actPointExecute(Sender: TObject);
    procedure actSymbolExecute(Sender: TObject);
    procedure actLineExecute(Sender: TObject);
    procedure actPolylineExecute(Sender: TObject);
    procedure actPolygonExecute(Sender: TObject);
    procedure actRectangleExecute(Sender: TObject);
    procedure actArcExecute(Sender: TObject);
    procedure actEllipseExecute(Sender: TObject);
    procedure actSplineExecute(Sender: TObject);
    procedure actInsertBlockExecute(Sender: TObject);
    procedure actBufferExecute(Sender: TObject);
    procedure actFittedTextExecute(Sender: TObject);
    procedure actJustifiedTextExecute(Sender: TObject);
    procedure actTrueTypeTextExecute(Sender: TObject);
    procedure actBannerTextExecute(Sender: TObject);
    procedure actCalloutTextExecute(Sender: TObject);
    procedure actBulletLeaderTextExecute(Sender: TObject);
    procedure actPictureRefExecute(Sender: TObject);
    procedure actPersistentBitmapExecute(Sender: TObject);
    procedure actBandsBitmapExecute(Sender: TObject);
    procedure actImportExecute(Sender: TObject);
    procedure actExportExecute(Sender: TObject);
    procedure actLayerControlExecute(Sender: TObject);
    procedure actAddLayerExecute(Sender: TObject);
    procedure actUnloadLayerExecute(Sender: TObject);
    procedure actReindexExecute(Sender: TObject);
    procedure actQuickUpdateExtensionExecute(Sender: TObject);
    procedure actUpdateExtensionExecute(Sender: TObject);
    procedure actRestructureExecute(Sender: TObject);
    procedure actPackLayerExecute(Sender: TObject);
    procedure actRegenExecute(Sender: TObject);
    procedure actPanExecute(Sender: TObject);
    procedure actZoomInExecute(Sender: TObject);
    procedure actZoomOutExecute(Sender: TObject);
    procedure actZoomRealtimeExecute(Sender: TObject);
    procedure actZoomPreviousExecute(Sender: TObject);
    procedure actZoomSelectionExecute(Sender: TObject);
    procedure actZoomLayerExecute(Sender: TObject);
    procedure actZoomAllExecute(Sender: TObject);
    procedure actViewGridExecute(Sender: TObject);
    procedure actShowHintsExecute(Sender: TObject);
    procedure actShowCoordsExecute(Sender: TObject);
    procedure actShowCmdLineExecute(Sender: TObject);
    procedure actAerialViewExecute(Sender: TObject);
    procedure actNamedviewsExecute(Sender: TObject);
    procedure actEditDatabaseInfoExecute(Sender: TObject);
    procedure actEditGraphicInfoExecute(Sender: TObject);
    procedure actRevertdirectionExecute(Sender: TObject);
    procedure actAddMarkerExecute(Sender: TObject);
    procedure actClearMarkersExecute(Sender: TObject);
    procedure actFitToPathExecute(Sender: TObject);
    procedure actFitTextToPathExecute(Sender: TObject);
    procedure actOrtoExecute(Sender: TObject);
    procedure actClipRectangularExecute(Sender: TObject);
    procedure actClipPolygonalExecute(Sender: TObject);
    procedure actSetClipBoundaryfromSelectionExecute(Sender: TObject);
    procedure actCancelclippedExecute(Sender: TObject);
    procedure actGeoreferencedImageExecute(Sender: TObject);
    procedure actSelectRectangleExecute(Sender: TObject);
    procedure actSelectCircleExecute(Sender: TObject);
    procedure actSelectMultiObjectExecute(Sender: TObject);
    procedure actSelectPolylineExecute(Sender: TObject);
    procedure actSelectBufferExecute(Sender: TObject);
    procedure actDefaultActionExecute(Sender: TObject);
    procedure actSelectAllExecute(Sender: TObject);
    procedure actUnSelectAllExecute(Sender: TObject);
    procedure actSelectEntireLayerExecute(Sender: TObject);
    procedure actCopySelectionToExecute(Sender: TObject);
    procedure actBlinkSelectionExecute(Sender: TObject);
    procedure actSuspendBlinkingExecute(Sender: TObject);
    procedure actLineStyleExecute(Sender: TObject);
    procedure actFillStyleExecute(Sender: TObject);
    procedure actSymbolStyleExecute(Sender: TObject);
    procedure actTextStyleExecute(Sender: TObject);
    procedure actShowAccuSnapExecute(Sender: TObject);
    procedure actConfigureAccuSnapExecute(Sender: TObject);
    procedure actConfigureAccuDrawExecute(Sender: TObject);
    procedure actRotateAccuDrawExecute(Sender: TObject);
    procedure actRotateInteractivelyExecute(Sender: TObject);
    procedure actUnrotateAccuDrawExecute(Sender: TObject);
    procedure actChangeAccuDrawOriginExecute(Sender: TObject);
    procedure actSymbolsEditorExecute(Sender: TObject);
    procedure actLinetypeEditorExecute(Sender: TObject);
    procedure actRasterImageEditorExecute(Sender: TObject);
    procedure actBlocksEditorExecute(Sender: TObject);
    procedure actMapUnitsExecute(Sender: TObject);
    procedure actReprojectExecute(Sender: TObject);
    procedure actSnapToGridExecute(Sender: TObject);
    procedure actSnapToGLinesExecute(Sender: TObject);
    procedure actPreferencesExecute(Sender: TObject);
    procedure actViewportConfigExecute(Sender: TObject);
    procedure actGisConfigExecute(Sender: TObject);
    procedure actLayersConfigExecute(Sender: TObject);
    procedure actLoadVectorialFontExecute(Sender: TObject);
    procedure actLoadSymbolsFileExecute(Sender: TObject);
    procedure actLoadLinetypesFileExecute(Sender: TObject);
    procedure actMoveExecute(Sender: TObject);
    procedure actScaleExecute(Sender: TObject);
    procedure actRotateExecute(Sender: TObject);
    procedure actReshapeExecute(Sender: TObject);
    procedure actInsertNodeExecute(Sender: TObject);
    procedure actDeleteNodeExecute(Sender: TObject);
    procedure actMirrorExecute(Sender: TObject);
    procedure actOffsetExecute(Sender: TObject);
    procedure actExplodeExecute(Sender: TObject);
    procedure actTrimExecute(Sender: TObject);
    procedure actExtendExecute(Sender: TObject);
    procedure actBreakExecute(Sender: TObject);
    procedure actFilletExecute(Sender: TObject);
    procedure actJoinExecute(Sender: TObject);
    procedure actPreserveOriginalsExecute(Sender: TObject);
    procedure actUnionExecute(Sender: TObject);
    procedure actIntersectionExecute(Sender: TObject);
    procedure actDifferenceExecute(Sender: TObject);
    procedure actSplitExecute(Sender: TObject);
    procedure actXorExecute(Sender: TObject);
    procedure actDimHorizontal1Execute(Sender: TObject);
    procedure actDimVerticalExecute(Sender: TObject);
    procedure actDimParallelExecute(Sender: TObject);
    procedure actToPolylineExecute(Sender: TObject);
    procedure actToPolygonExecute(Sender: TObject);
    procedure actCombineExecute(Sender: TObject);
    procedure actConvertAutoCADDWGDXFExecute(Sender: TObject);
    procedure actChangeReshapeRotateOriginExecute(Sender: TObject);
    procedure actQueryExecute(Sender: TObject);
    procedure actThematicsEditorExecute(Sender: TObject);
    procedure actTurnoffthematicsExecute(Sender: TObject);
    procedure actAddNodesExecute(Sender: TObject);
    procedure actAddNodeLinksExecute(Sender: TObject);
    procedure actAnalysisExecute(Sender: TObject);
    procedure actAboutExecute(Sender: TObject);
    procedure actEzSoftEngineeringHOMEPAGEExecute(Sender: TObject);
    procedure actWritetoUsExecute(Sender: TObject);
    procedure FileOpen1BeforeExecute(Sender: TObject);
    procedure FileOpen1Accept(Sender: TObject);
    procedure Action12Execute(Sender: TObject);
    procedure EditUndo1Execute(Sender: TObject);
    procedure EditCut1Execute(Sender: TObject);
    procedure EditCopy1Execute(Sender: TObject);
    procedure EditPaste1Execute(Sender: TObject);
    procedure EditDelete1Execute(Sender: TObject);
    procedure GIS1AfterDragDrop(Sender: TObject; Layer: TEzBaseLayer;
      Recno: Integer);
    procedure GIS1AfterInsertLayer(Sender: TObject;
      const LayerName: String);
    procedure GIS1FileNameChange(Sender: TObject);
    procedure GIS1GisTimer(Sender: TObject; var CancelPainting: Boolean);
    procedure GIS1PrintBegin(Sender: TObject);
    procedure GIS1PrintEnd(Sender: TObject);
    procedure GIS1PrintProgress(Sender: TObject; Percent: Integer;
      var Cancel: Boolean);
    procedure GIS1Progress(Sender: TObject; Stage: TEzProgressStage;
      const Caption: String; Min, Max, Position: Integer);
    procedure GIS1ShowDirection(Sender: TObject; Layer: TEzBaseLayer;
      Recno: Integer; var DirectionPos: TEzDirectionPos;
      DirectionPen: TEzPenTool; DirectionBrush: TEzBrushTool;
      var RevertDirection, CanShow: Boolean);
    procedure EditUndo1Update(Sender: TObject);
    procedure actSymbolMultExecute(Sender: TObject);
    procedure actTextPlaceExecute(Sender: TObject);
    procedure actRoundedExecute(Sender: TObject);
    procedure actView1Execute(Sender: TObject);
    procedure actNextMarkerExecute(Sender: TObject);
    procedure actPriorMarkerExecute(Sender: TObject);
    procedure CmdLine1AccuDrawActivate(Sender: TObject);
    procedure CmdLine1AccuDrawChange(Sender: TObject);
    procedure CmdLine1AccuSnapChange(Sender: TObject);
    procedure CmdLine1AfterCommand(Sender: TObject; const Command,
      ActionID: String);
    procedure CmdLine1StatusMessage(Sender: TObject;
      const AMessage: String);
    procedure actHGLinesExecute(Sender: TObject);
    procedure actVGLinesExecute(Sender: TObject);
    procedure actMeasuresExecute(Sender: TObject);
    procedure actCircle3PExecute(Sender: TObject);
    procedure actBrowseExecute(Sender: TObject);
    procedure Action23Execute(Sender: TObject);
    procedure actAutoLabelExecute(Sender: TObject);
    procedure actCircleCRExecute(Sender: TObject);
    procedure Action39Execute(Sender: TObject);
    procedure actArcCRSEExecute(Sender: TObject);
    procedure actArcSCEExecute(Sender: TObject);
    procedure actMultiPartExecute(Sender: TObject);
    procedure actRepaintExecute(Sender: TObject);
    procedure actPrintPreviewExecute(Sender: TObject);
    procedure actPrintPreviewUpdate(Sender: TObject);
    procedure GIS1BeforePaintEntity(Sender: TObject; Layer: TEzBaseLayer;
      Recno: Integer; Entity: TEzEntity; Grapher: TEzGrapher;
      Canvas: TCanvas; const Clip: TEzRect; DrawMode: TEzDrawMode;
      var CanShow: Boolean; var EntList: TEzEntityList;
      var AutoFree: Boolean);
    procedure GIS1BeforePaintLayer(Sender: TObject; Layer: TEzBaseLayer;
      Grapher: TEzGrapher; var CanShow, WasFiltered: Boolean;
      var EntList: TEzEntityList; var AutoFree: Boolean);
    procedure GIS1AfterPaintLayer(Sender: TObject; Layer: TEzBaseLayer;
      Grapher: TEzGrapher; var EntList: TEzEntityList;
      var AutoFree: Boolean);
    procedure Action11Execute(Sender: TObject);
    procedure actZoomWinExecute(Sender: TObject);
    procedure actSketchExecute(Sender: TObject);
    procedure CustomizeActionBars2Execute(Sender: TObject);
    procedure actMoveUpdate(Sender: TObject);
    procedure Action6Update(Sender: TObject);
    procedure EditPaste1Update(Sender: TObject);
    procedure HelpContents1Update(Sender: TObject);
    procedure Action13Execute(Sender: TObject);
    procedure Action14Execute(Sender: TObject);
    procedure ERMapperLauncherTrackedEntity(Sender: TObject;
      const TrackID: String; var TrackedEntity: TEzEntity);
    procedure Action121Execute(Sender: TObject);
    procedure Action167Execute(Sender: TObject);
    procedure Action22Execute(Sender: TObject);
    procedure Action15Execute(Sender: TObject);
    procedure Action15Update(Sender: TObject);
  private
    FDataPath: string;
    FFirstMap: Boolean;
    FAutoLabeling: Boolean;
    FTestBitmap: TBitmap;
    FLayersOptions: TEzLayersOptions;
    { used for fast accessing in different events }
    Flo: TEzLayerOptions;
    FCurrentScale: double;
    //FTileBitmap: TBitmap;
    FfrmAerial: TfrmAerial;
    FNamedViews: TEzNamedViews;
    FfrmViews: TfrmViews;
    FThematicList: TList;
    FCurrentMarkerIndex: Integer;
    FfrmBrowse: TfrmDemoBrowse;
    FfrmAddPlace: TfrmAddPlace;
    FfrmAccuDraw: TfrmAccuDraw;
    FfrmAccuSnap: TfrmAccuSnap;
    FfrmRounded: TfrmRounded;
    FfrmMultipart: TfrmMultipart;
    FfrmAutoLabel: TfrmAutoLabel;
    FfrmClipboard: TfrmClipboard;
    FfrmLegend: TfrmLegend;
    FNextView: Integer;

    ReopenMenuItem: TActionClientItem;
    OpenToolItem: TActionClientItem;
{$IFDEF ER_MAPPER}
    FERMapperFileName: string;
{$ENDIF}
    procedure FindReopenMenuItem(AClient: TActionClient);
    procedure FindOpenToolItem(AClient: TActionClient);

    procedure ClearThematicList;
    procedure LoadNamedViews;
    procedure SaveNamedViews;
    procedure FileProgress(Sender: TObject; const Filename: string;
      Progress, NoEntities, BadEntities: Integer; var CanContinue: Boolean);
    function GetGIS: TEzBaseGIS;
    procedure VerifySizes;
    Function IsClipboardContentValid: Boolean;
    function GetDrawBox: TEzBaseDrawBox;
    procedure AccuDrawFormClose(Sender: TObject);
    procedure AccusnapClose(Sender: TObject);
  public
    { Public declarations }
    ClonedViews: Array[0..5] Of TfrmClone;
    function ViewsCount: Integer;
    function GetAppPath: string;
    function GetDataPath: string;
    Procedure PopulateNativeAndExternalFields( Layer: TEzBaseLayer;
      Fields: TStrings; IncludesLayerName: Boolean = False );

    property LayersOptions: TEzLayersOptions read FLayersOptions;
    Property NamedViews: TEzNamedViews read FNamedViews;
    Property frmViews: TfrmViews read FfrmViews write FfrmViews;
    Property frmAerial: TfrmAerial read FfrmAerial write FfrmAerial;
    Property frmBrowse: TfrmDemoBrowse read FfrmBrowse write FfrmBrowse;
    Property frmAddPlace: TfrmAddPlace read FfrmAddPlace write FfrmAddPlace;
    Property frmRounded: TfrmRounded read FfrmRounded write FfrmRounded;
    Property frmMultipart: TfrmMultipart read FfrmMultipart write FfrmMultipart;
    Property frmAutoLabel: TfrmAutoLabel read FfrmAutoLabel write FfrmAutoLabel;
    Property frmClipboard: TfrmClipboard read FfrmClipboard write FfrmClipboard;
    Property frmLegend: TfrmLegend read FfrmLegend write FfrmLegend;
    Property DrawBox: TEzBaseDrawBox read GetDrawBox;
    Property GIS: TEzBaseGIS read GetGIS;
  end;

  Function DetectCancelPaint( DrawBox: TEzBaseDrawBox ): Boolean;

var
  Form1: TForm1;

implementation

{$R *.dfm}

uses Math,
  ezentities, ezsystem, EzPolyClip, Inifiles, fLayers, ezrtree, fSelec, EzBaseExpr,
  ezconsts, fLineTypeEd, fdemoprevw, fSymbEd, fRasterImageEd, {fUDFs,}
  fProgr, ezshpimport, EzDxfImport, EzMIFIMport, EzDGNImport,
  fLineType, fSymbolType, fFontStyle, fLayerSelect, fRestructure, fMapUnits,
  fBrushStyle, fAddEntity, fReproject, fAbout, fRichEdit, ezhtmlmap, ShellAPI,
  fBlockEd, fRepeat, fPictureDef, fPref, fThemsEditor, EzActions,
  EzMiscelEntities, fDBInspector, fGisInspector, fEditDB, fLayerInspector,
  Chart, Series, TeEngine, fDGNImport, fDxfImport, EzNetwork,
  fNetwork, EzDGNLayer, fAccuDrawSetts, fAccuSnapSetts, fExpressBuilder,
  fVectorialExpr, fSpatialQuery, fDGNExport, EzScrLex, EzScryacc
{$IFDEF ER_MAPPER}
  , EzERMapper
{$ENDIF}
{$IFDEF LEVEL7}
  , XPMan
{$ENDIF}
  , fPreloaded;

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

procedure TForm1.FindReopenMenuItem(AClient: TActionClient);
begin
  // Find the Reopen item by looking at the item caption
  if AClient is TActionClientItem then
    if Pos('Reopen...', TActionClientItem(AClient).Caption) <> 0 then
      ReopenMenuItem := AClient as TActionClientItem
end;

procedure TForm1.FindOpenToolItem(AClient: TActionClient);
begin
  // Find the Open item by looking at the item caption
  if AClient is TActionClientItem then
    if Pos('Open', TActionClientItem(AClient).Caption) <> 0 then
      OpenToolItem := AClient as TActionClientItem;
end;

procedure TForm1.actNewExecute(Sender: TObject);
begin
  CmdLine1.Clear;
  if GIS1.Active then GIS1.SaveIfModified;
  with TSaveDialog.Create(Nil) do
  begin
    DefaultExt:= 'EZM';
    Filter:= 'EzGIS Map Files(*.EZM)|*.EZM';
    Title:= 'Create New Map';
    Options:= [ofPathMustExist];
    try
      if not Execute then Exit;
      GIS1.CreateNew(FileName);
      FLayersOptions.Clear;
      LoadNamedViews;
      cmdLine1.All_Repaint;
    finally
      Free;
    end;
  end;
end;

procedure TForm1.actSaveExecute(Sender: TObject);
begin
  if Length( GIS1.FileName ) = 0 then
  begin
    with TSaveDialog.Create(Nil) do
    begin
       DefaultExt := 'EZM';
       Filter:= 'EzGIS Map Files(*.EZM)|*.EZM';
       Title:= 'Create New Map';
       Options := [ofPathMustExist];
       try
         if not Execute then Exit;
         GIS1.FileName:=FileName;
         GIS1.Save;
         FLayersOptions.SaveToFile( ChangeFileExt(Gis1.FileName, '.opt' ) );
         SaveNamedViews;
       finally
         Free;
       end;
       Exit;
    end;
  end else
  begin
    GIS1.Save;
    FLayersOptions.SaveToFile( ChangeFileExt(Gis1.FileName, '.opt' ) );
    SaveNamedViews;
  end;
end;

procedure TForm1.actHotSpotExecute(Sender: TObject);
var
  Layer  : TEzBaseLayer;
  ViewerHandle: HWND;
begin
  Layer:= GetLayerFromDialog(Gis1);
  if Layer= nil then Exit;
  if not SaveDialog2.Execute then Exit;
  with TEzHTMLMap.Create(nil) do
    try
       DrawBox := Self.DrawBox;
       HTMLTemplate := ExtractFilePath(Application.ExeName) + 'map.htm';
       ImageWidth := DrawBox.ClientWidth;
       ImageHeight := DrawBox.ClientHeight;
       SaveToFile(Layer.Name,SaveDialog2.FileName);
    finally
       Free;
    end;
  ViewerHandle := ShellExecute(0, 'open', PChar(SaveDialog2.FileName), nil, nil, SW_SHOWNORMAL);
  SetForegroundWindow(ViewerHandle);
end;

procedure TForm1.actSaveclippedExecute(Sender: TObject);
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
    DrawBox.SaveClippedAreaTo(NewGis);
  finally
    NewGis.Free;
  end;
end;

procedure TForm1.actCreateThumnaillbitmapExecute(Sender: TObject);
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
    DrawBox.CreateThumbnail(Bmp);
    Bmp.SaveToFile(SaveDialog3.FileName);
  finally
    Bmp.free;
  end;
end;

procedure TForm1.ClearThematicList;
var
  I: Integer;
begin
  for I:= 0 to FThematicList.Count-1 do
    TEzThematicBuilder( FThematicList[I] ).Free;
  FThematicList.Clear;
end;

resourcestring
  SVectFilterAcad= 'AutoCAD DXF (*.DXF)|*.DXF';
  SVectFilterSHP= 'ArcView Shape Files (*.SHP)|*.SHP';
  SVectFilterTAB= 'MapInfo native TAB (*.TAB)|*.TAB';
  SVectFilterMIF= 'MapInfo MIF/MID files (*.MIF)|*.MIF';
  SVectFilterDGN= 'Microstation DGN files (*.DGN)|*.DGN';
  SAllVectorFiles='All Vector files|*.SHP;*.TAB;*.MIF;*.DXF;*.DGN';

procedure TForm1.FileProgress(Sender: TObject; const Filename: string;
  Progress, NoEntities, BadEntities: Integer; var CanContinue: Boolean);
begin
  if not frmProgressDialog.Visible then frmProgressDialog.Show;
  frmProgressDialog.ProgressBar1.Position:= Progress;
  frmProgressDialog.Label3.Caption:=
    Format('%d Objects created. %d Objects bad', [NoEntities, BadEntities]);
  frmProgressDialog.Update;
end;

function TForm1.GetGIS: TEzBaseGIS;
begin
  Result:= GIS1;
end;

function TForm1.GetDataPath: string;
begin
  Result:=
    AddSlash( ExtractFilePath( ExpandFileName(
      AddSlash( ExtractFilePath(Application.ExeName) ) + '..\..\data\*.*' ) ) );
end;

function TForm1.GetAppPath: string;
begin
  Result:= AddSlash( ExtractFilePath(Application.ExeName) );
end;

function TForm1.IsClipboardContentValid: Boolean;
Var
  lexer: TEzScrLexer;
  parser: TEzScrParser;
  outputStream: TMemoryStream;
  errorStream: TMemoryStream;
  Stream: TStream;
  temp: string;
Begin
  Result:=false;
  temp:= Clipboard.AsText;
  If Length( temp ) = 0 Then Exit;
  outputStream := TMemoryStream.create;
  errorStream := TMemoryStream.create;
  Stream := TMemoryStream.Create;
  Stream.Write( temp[1], Length( temp ) );
  Stream.Seek( 0, 0 );

  lexer := TEzScrLexer.Create;
  lexer.yyinput := Stream;
  lexer.yyoutput := outputStream;
  lexer.yyerrorfile := errorStream;

  parser := TEzScrParser.Create;
  parser.DrawBox := DrawBox;
  parser.CmdLine := CmdLine1;
  parser.checksyntax := True;  // just check syntax !!!
  parser.yyLexer := lexer; // lexer and parser linked
  Try
    Result:=  parser.yyparse = 0;
  Finally
    parser.free;
    lexer.free;
    outputStream.free;
    errorStream.free;
    Stream.Free;
  End;
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
  Pts:= DrawBox.Grapher.DistToPointsY( Ez_Preferences.DefSymbolStyle.Height );
  If ( Pts < 2 ) Or (Pts > 72) Then
  begin
    Pts:= 12;
    Ez_Preferences.DefSymbolStyle.Height:= DrawBox.Grapher.PointsToDistY( Pts );
  end;
  Pts:= DrawBox.Grapher.DistToPointsY( Ez_Preferences.DefFontStyle.Height );
  If ( Pts < 2 ) Or (Pts > 72) Then
  begin
    Pts:= 12;
    Ez_Preferences.DefFontStyle.Height:= DrawBox.Grapher.PointsToDistY( Pts );
  end;
  Pts:= DrawBox.Grapher.DistToPointsY( Ez_Preferences.DefTTFontStyle.Height );
  If ( Pts < 2 ) Or (Pts > 72) Then
  begin
    Pts:= 12;
    Ez_Preferences.DefTTFontStyle.Height:= DrawBox.Grapher.PointsToDistY( Pts );
  end;
  Pts:= DrawBox.Grapher.DistToPointsY( Ez_Preferences.DefPenStyle.Width );
  If ( Pts < 2 ) Or (Pts > 36) Then
  begin
    Ez_Preferences.DefPenStyle.Width:= 0;
  end;
end;

procedure TForm1.FormCreate(Sender: TObject);
var
  TempDataPath, AppPath, FileName, Fontname: string;
  Inifile: TInifile;
  I,NumFonts: integer;
  //Configured: Boolean;
{$IFDEF CYBER_PROTECTION}
  CanContinue: Boolean;
{$ENDIF}
Begin

{$IFDEF LEVEL7}
  TXPManifest.Create(Self);
{$ENDIF}

{$IFDEF CYBER_PROTECTION}
  If IsThisCopyRegistered( False, CanContinue ) Then
  begin
    dxBarButton50.Enabled:=false;
    dxBarButton62.Enabled:=false;
  end;
{$ENDIF}

  //actView1.OnExecute(actView1);

  ActionManager1.FileName:= AddSlash(ExtractFilePath(Application.ExeName)) + 'ActionBands.cfg';

  // Find the Reopen... menu item on the ActionMainMenu
  ActionManager1.ActionBars.IterateClients(ActionManager1.ActionBars[0].Items, FindReopenMenuItem);
  // Find the Reopen... menu item on the ActionToolBar
  ActionManager1.ActionBars.IterateClients(ActionManager1.ActionBars[1].Items, FindOpenToolItem);

  //CmdLine1.AccuDraw.Enabled:= True;
  //CmdLine1.AccuSnap.Enabled:= True;

  FLayersOptions:= TEzLayersOptions.Create;
  FNamedViews:= TEzNamedViews.Create;

  TempDataPath:= GetDataPath;
  AppPath:= GetAppPath;

  Application.HelpFile:= AppPath + 'EzGIS.Hlp';

  Inifile:= TInifile.Create(AppPath + 'Config.ini');
  try

    FDataPath:= TempDataPath;

    FDataPath:= AddSlash( ExtractFilePath( ExpandFileName( FDataPath + '*.*' ) ) );

    NumFonts:= Inifile.ReadInteger('VectorialFonts','NumFonts', 0);
    if NumFonts = 0 then
    begin
      if not FileExists(FDataPath+'*.fnt') then
      begin
        ShowMessage(SNoFontFilesFound);
      end;
      Gis1.LoadFontFile( FDataPath+'complex.fnt' );
      Gis1.LoadFontFile( FDataPath+'txt.fnt' );
      Gis1.LoadFontFile( FDataPath+'romanc.fnt' );
      Gis1.LoadFontFile( FDataPath+'arial.fnt' );
    end else
    begin
      for I:= 0 to NumFonts-1 do
      begin
        Fontname:=
          ChangeFileExt(Inifile.Readstring('VectorialFonts', 'Font'+inttostr(I), ''), '.fnt');
        if (Length(Fontname)>0) and FileExists(FDataPath +Fontname) then
        begin
          Gis1.LoadFontFile( FDataPath+Fontname );
        end;
      end;
      if Ez_VectorFonts.Count=0 then
      begin
        Gis1.LoadFontFile( FDataPath+'complex.fnt' );
        Gis1.LoadFontFile( FDataPath+'txt.fnt' );
        Gis1.LoadFontFile( FDataPath+'romanc.fnt' );
        Gis1.LoadFontFile( FDataPath+'arial.fnt' );
      end;
    end;

    { ALWAYS load the symbols after the vectorial fonts
      because the symbols can include vectorial fonts entities and
      if the vector font is not found, then the entity will be configured
      with another font }

    FileName:= Inifile.Readstring('MAPS', 'SymbolsFile', 'Symbols.ezs');

    if FileExists(FDataPath + FileName) then
      Gis1.LoadSymbolsFile( FDataPath + FileName )
    else
      Gis1.LoadSymbolsFile( FDataPath + 'symbols.ezs' );

    // load line types
    FileName:= Inifile.Readstring('MAPS', 'LineTypesFile', 'Linetypes.ezl');
    if FileExists( FDataPath + FileName ) then
      Gis1.LoadLineTypesFile( FDataPath + FileName )
    else
      Gis1.LoadLineTypesFile( FDataPath + 'Linetypes.ezl' );

    //for I:= 0 to LayerList1.Columns.Count-1 do
    //  LayerList1.Columns[I].Width:= Inifile.ReadInteger('DMCols','Col'+IntToStr(I), LayerList1.ColWidths[I]);

  finally
    Inifile.free;
  end;

  { load the preferences from a file

    WARNING!!!
    If you modify preferences at design time, it will not be persistent because
    we are loading from a file here

    Comment this three lines in order to use the design time preferences }
  FileName:= AppPath + 'Preferences.ini';
  if FileExists(FileName) then
  begin
    Preferences1.LoadFromFile(FileName);
  end;
  //Preferences1.SelectionBrush.BackColor:= clNone;   // transparent filling !!!
  //Preferences1.SelectionBrush.Pattern:= 3;

  //drawbox1.rubberpen.color:= clMaroon;

  Preferences1.CommonSubDir:= FDataPath;

  Preferences1.ApertureWidth:= GetDeviceCaps( Self.Canvas.Handle, LOGPIXELSY ) div 12;

  FCurrentMarkerIndex:= -1;

  {Inifile:= TInifile.Create(AppPath + 'Config.ini');
  try
    LayerGridbox1.CurrentTextColor:= Inifile.ReadInteger('LayerColors','Current', clBlack);
    LayerGridbox1.LockedTextColor:= Inifile.ReadInteger('LayerColors','Locked', clRed);
  finally
    Inifile.free;
  end; }

  FThematicList:= TList.Create;

end;

procedure TForm1.FormPaint(Sender: TObject);
var
  Inifile: TInifile;
  Path, FileName: string;
begin
  if not FFirstMap then
  begin
    exit;
    FFirstMap := true;
    Path      := AddSlash(ExtractFilePath(Application.ExeName));
    Inifile   := TInifile.Create(Path + 'CONFIG.INI');
    try
      FileName:= IniFile.ReadString('MAPS','LAST_OPENED','');
      if (Length(FileName)>0) and FileExists(FileName) then
      begin
        Gis1.FileName:= FileName;
        Gis1.Open;
        FLayersOptions.LoadFromFile( ChangeFileExt(Gis1.FileName, '.opt' ) );
        If Drawbox <> Nil Then DrawBox.Repaint;
        LoadNamedViews;
      end;
    finally
      Inifile.Free;
    end;
  end;
end;

procedure TForm1.FormDestroy(Sender: TObject);
var
  Inifile: TInifile;
  FileName, Path: string;
  I: Integer;
begin
  { clean the clipboard from possible data left there }
  If DrawBox <> Nil Then
    DrawBox.Undo.Clear;

  if Length(Gis1.FileName)=0 then Exit;
  Path:= AddSlash(ExtractFilePath(Application.ExeName));
  Inifile:= TInifile.Create(Path + 'CONFIG.INI');
  try
    IniFile.WriteString('MAPS','LAST_OPENED',Gis1.FileName);
  finally
    Inifile.Free;
  end;

  FTestBitmap.free;
  //FTileBitmap.free;

  { save the preferences to a file }
  FileName:= ExtractFilePath(Application.ExeName) + 'Preferences.ini';
  Preferences1.SaveToFile(FileName);

  //FCustomPicture.Free;

  if Gis1.Active then
    FLayersOptions.SaveToFile( ChangeFileExt(Gis1.FileName, '.opt' ) );

  FreeAndNil(FLayersOptions);
  FreeAndNil(FNamedViews);

  { the stay on top forms .... }
  if FfrmBrowse <> nil then FreeAndNil( FfrmBrowse );
  if FfrmViews <> nil then FreeAndNil( FfrmViews );
  If FfrmAccuDraw <> Nil then FreeAndNil( FfrmAccuDraw );
  If FfrmAddPlace <> Nil then FreeAndNil( FfrmAddPlace );
  If FfrmAerial <> Nil then FreeAndNil( FfrmAerial );
  If FfrmAccuSnap <> Nil then FreeAndNil( FfrmAccuSnap );
  If FfrmRounded <> Nil then FreeAndNil( FfrmRounded );
  If FfrmMultiPart <> Nil then FreeAndNil( FfrmMultiPart );
  If FfrmAutoLabel <> Nil then FreeAndNil( FfrmAutoLabel );
  If FfrmClipboard <> Nil then FreeAndNil( FfrmClipboard );
  if FfrmLegend <> Nil then FreeAndNil( FfrmLegend );


  For I:= Low(ClonedViews) to High(ClonedViews) do
    If Assigned(ClonedViews[I]) Then
      FreeAndNil(ClonedViews[I]);

  ClearThematicList;
  FThematicList.Free;

  Path:= AddSlash(ExtractFilePath(Application.ExeName));

end;

procedure TForm1.FormResize(Sender: TObject);
begin
  Self.Invalidate;
end;

procedure TForm1.actPasteAndDefinePositionExecute(Sender: TObject);
begin
  if FfrmClipboard=Nil then
  begin
    FfrmClipboard:= TfrmClipboard.Create(Nil);
    FfrmClipboard.Enter(True);
    DrawBox.SetFocus;
  end else
    FreeAndNil( FfrmClipboard );
end;

procedure TForm1.actClearClipboardExecute(Sender: TObject);
begin
  DrawBox.Undo.Clear(True);
end;

procedure TForm1.actDropExecute(Sender: TObject);
var
  NumRepeat: Integer;
begin
  NumRepeat:= StrToInt(InputBox('DROP command', 'Duplicates :', IntToStr(DrawBox.DropRepeat) ));
  if NumRepeat < 1 then Exit;
  DrawBox.DropRepeat:= NumRepeat;
  CmdLine1.DoCommand('DROP', '');
end;

procedure TForm1.actCopyToClipboardExecute(Sender: TObject);
var
  I,J: Integer;
  SelLayer: TEzSelectionLayer;
  temp: string;
  Ent: TEzEntity;
  TempDecSep: Char;
begin
  if DrawBox.Selection.Count=0 then exit;
  TempDecSep:= DecimalSeparator;
  DecimalSeparator:= '.'; // numbers always must be with this decimal separator
  temp:= '';
  Screen.Cursor:=crHourglass;
  for I:= 0 to DrawBox.Selection.Count-1 do
  begin
    SelLayer:= DrawBox.Selection[I];
    for J:= 0 to SelLayer.SelList.Count-1 do
    begin
      ent:= SelLayer.Layer.LoadEntityWithRecno(SelLayer.SelList[J]);
      if ent=nil then continue;
      try
        { set the attached table to same record in order to retrieve correct db info }
        //activate next two lines and deactivate third line if you want to copy data info also
        //SelLayer.Layer.DbTable.Recno:= SelLayer.SelList[J];
        //temp:= temp + ent.AsString(True,True,SelLayer.Layer.DbTable); // atributes and data
        temp:= temp + ent.AsString(True,False,Nil) + CrLf; // atributes and basic data only
      finally
        ent.free;
      end;
    end;
  end;
  Screen.Cursor:=crDefault;
  DecimalSeparator:= TempDecSep;
  Clipboard.AsText:= temp;
end;

procedure TForm1.actCopyToClipboardAsEmfExecute(Sender: TObject);
begin
  DrawBox.CopyToClipboardAsBmp;
end;

procedure TForm1.actGroupExecute(Sender: TObject);
begin
   DrawBox.GroupSelection;
end;

procedure TForm1.actUngroupExecute(Sender: TObject);
begin
   DrawBox.UnGroupSelection;
end;

procedure TForm1.actToFrontExecute(Sender: TObject);
begin
  DrawBox.BringToFront;
end;

procedure TForm1.actToBackExecute(Sender: TObject);
begin
  DrawBox.SendToBack;
end;

procedure TForm1.actMoveGuidelinesExecute(Sender: TObject);
begin
  CmdLine1.Clear;
  CmdLine1.DoCommand('MOVEGLINE','');
end;

procedure TForm1.actMakeBlockFromSelectionExecute(Sender: TObject);
var
  BlockName: string;
begin
  if DrawBox.Selection.Count=0 then
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
  DrawBox.CreateBlockFromSelection(BlockName);
end;

procedure TForm1.actREPEATExecute(Sender: TObject);
begin
  if DrawBox.Selection.Count = 0 then Exit;
  with TfrmRepeat.Create(Nil) do
    Try
      if Not (ShowModal = mrOk) then Exit;
      DrawBox.ARRAYFromSelection( Trunc( EzNumEd1.NumericValue ),
        Trunc( EzNumEd2.NumericValue ),
        EzNumEd3.NumericValue, EzNumEd4.NumericValue );
      DrawBox.Repaint;
    Finally
      Free;
    End;
end;

procedure TForm1.actDeleteRepetitionsExecute(Sender: TObject);
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
  DrawBox.DeleteRepetitions( Layer.Name, idNone, False, False);
  DrawBox.Repaint;
end;

procedure TForm1.actPointExecute(Sender: TObject);
begin
  CmdLine1.Clear;
  CmdLine1.DoCommand( 'POINT', '' );
end;

procedure TForm1.actSymbolExecute(Sender: TObject);
begin
  VerifySizes;
  CmdLine1.Clear;
  CmdLine1.DoCommand('SYMBOL', 'CUSTOMERS');  // dummy stateID
end;

procedure TForm1.actLineExecute(Sender: TObject);
begin
  CmdLine1.DoCommand( 'LINE', '' );
end;

procedure TForm1.actPolylineExecute(Sender: TObject);
begin
  CmdLine1.Clear;
  CmdLine1.DoCommand( 'PLINE', '' );
end;

procedure TForm1.actPolygonExecute(Sender: TObject);
begin
  CmdLine1.Clear;
  CmdLine1.DoCommand( 'POLYGON', '' );
end;

procedure TForm1.actRectangleExecute(Sender: TObject);
begin
  CmdLine1.Clear;
  CmdLine1.DoCommand('RECTANGLE','');
end;

procedure TForm1.actArcExecute(Sender: TObject);
begin
  CmdLine1.Clear;
  CmdLine1.DoCommand('ARC','');
end;

procedure TForm1.actEllipseExecute(Sender: TObject);
begin
  CmdLine1.Clear;
  CmdLine1.DoCommand('ELLIPSE','');
end;

procedure TForm1.actSplineExecute(Sender: TObject);
begin
  CmdLine1.Clear;
  CmdLine1.DoCommand('SPLINE','');
end;

procedure TForm1.actInsertBlockExecute(Sender: TObject);
begin
  CmdLine1.DoCommand('INSERT','');
end;

procedure TForm1.actBufferExecute(Sender: TObject);
begin
  CmdLine1.DoCommand('POLYGONBUFFER','');
end;

procedure TForm1.actFittedTextExecute(Sender: TObject);
begin
  VerifySizes;
  CmdLine1.Clear;
  CmdLine1.DoCommand('FITTEDTEXT','');
end;

procedure TForm1.actJustifiedTextExecute(Sender: TObject);
begin
  VerifySizes;
  CmdLine1.Clear;
  CmdLine1.DoCommand('JUSTIFTEXT','');
end;

procedure TForm1.actTrueTypeTextExecute(Sender: TObject);
begin
  VerifySizes;
  CmdLine1.DoCommand('TEXT','');
end;

procedure TForm1.actBannerTextExecute(Sender: TObject);
begin
  VerifySizes;
  CmdLine1.Clear;
  CmdLine1.DoCommand('BANNER','');
end;

procedure TForm1.actCalloutTextExecute(Sender: TObject);
begin
  VerifySizes;
  CmdLine1.Clear;
   CmdLine1.DoCommand('CALLOUTTEXT','');
end;

procedure TForm1.actBulletLeaderTextExecute(Sender: TObject);
begin
  VerifySizes;
  CmdLine1.Clear;
   CmdLine1.DoCommand('BULLETLEADER','');
end;

procedure TForm1.actPictureRefExecute(Sender: TObject);
begin
  CmdLine1.Clear;
  CmdLine1.DoCommand('PICTUREREF','');
end;

procedure TForm1.actPersistentBitmapExecute(Sender: TObject);
begin
  CmdLine1.DoCommand('PERSISTBITMAP','');
end;

procedure TForm1.actBandsBitmapExecute(Sender: TObject);
begin
  CmdLine1.DoCommand('BANDSBITMAP','');
end;

procedure TForm1.actImportExecute(Sender: TObject);
const
  BaseFormats: string = '.SHP.TAB.MIF.DXF.DGN';
var
  FileFormat: Integer;
  DGNImport: TEzDGNImport;
  DxfImport: TEzDxfImport ;
  Rslt:Word;
begin
  OpenDialog1.Filter:=  SAllVectorFiles + '|' +
                        SVectFilterAcad + '|' +
                        SVectFilterSHP  + '|' +
                        SVectFilterTAB  + '|' +
                        SVectFilterMIF  + '|' +
                        SVectFilterDGN;
  if not OpenDialog1.Execute then Exit;
  //OpenDialog1.FileName:= 'c:\ezgis1\samples\pruebas\Orebro_sv-v.dgn';
  FileFormat:= AnsiPos(ExtractFileExt(AnsiUpperCase(OpenDialog1.FileName)), BaseFormats) div 4;

  Preferences1.DefPenStyle.Style:= 1;
  Preferences1.DefPenStyle.Scale:= 0;

  { define the parent window of the progress dialog }
  ProgressParentHWND:= Self.Handle;

  frmProgressDialog:= TfrmProgressDlg.Create(Nil);
  try
    case FileFormat of
      0:  // Arcview .SHP files
        begin
          frmProgressDialog.DispMsg.Caption:=
            Format( 'ArcView shapefile import from %s...',
                    [frmProgressDialog.GetShortDispname(OpenDialog1.FileName)] );
          with TEzSHPImport.Create(nil) do
          try
            DrawBox:= Self.DrawBox;
            Filename:= OpenDialog1.FileName;
            ConfirmProjectionSystem:= true;
            OnFileProgress:= Self.FileProgress;
            Execute;
          finally
            Free;
          end;
          DrawBox.ZoomToExtension;
        end;
      1,  // Mapinfo .TAB
      2:  // Mapinfo .MIF/MID
        begin
          frmProgressDialog.DispMsg.Caption:=
            Format( 'MIF Import from %s...',
                    [frmProgressDialog.GetShortDispname(OpenDialog1.FileName)] );
          with TEzMIFImport.Create(nil) do
            try
              DrawBox:= self.DrawBox;
              Filename:= OpenDialog1.FileName;
              ConfirmProjectionSystem:= true;   // or false
              OnFileProgress:= Self.FileProgress;
              LayerName := ChangeFileExt(ExtractFileName(Filename), '');
              Execute;
            finally
              Free;
            end;
        end;
      3:  // AutoCAD .DXF files
        begin
          { Import DXF to an existing layer (.DXF) }
          {if GIS1.Layers.Count=0 then
          begin
            ShowMessage('You need at least one layer for Dxf''s');
            exit;
          end; }

          frmProgressDialog.DispMsg.Caption:=
            Format( 'DXF Import from %s...',
                    [frmProgressDialog.GetShortDispname(OpenDialog1.FileName)] );


          DxfImport:= TEzDxfImport.Create(nil) ;
          try
            Rslt:= MessageDlg('Explode blocks?',mtConfirmation,[mbYes,mbNo,mbCancel],0);
            if Rslt=mrCancel Then Exit;
            DxfImport.ExplodeBlocks:= Rslt=mrYes;

            DxfImport.DrawBox:= Self.DrawBox;
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
            DGNImport.DrawBox:= Self.DrawBox;
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
    frmProgressDialog.Free;
  end;
end;

procedure TForm1.actExportExecute(Sender: TObject);
const
  BaseFormats = '.DXF.SHP.MIF.DGN';
var
  FileFormat: Integer;
  Layer: TEzBaseLayer;
  LayerList: TStrings;
  I: Integer;
  SeedFileName: string;
  ExplodeIt: Boolean;
begin
  if Gis1.Layers.Count=0 then exit;

  SaveDialog1.Filter:=  SVectFilterAcad + '|' +
                        SVectFilterSHP  + '|' +
                        SVectFilterMIF  + '|' +
                        SVectFilterDGN;
  if not SaveDialog1.Execute then Exit;

  FileFormat:=
    AnsiPos(ExtractFileExt(AnsiUpperCase(SaveDialog1.FileName)), BaseFormats) div 4;

  { define the parent window of the progress dialog }
  ProgressParentHWND:= Self.Handle;

  frmProgressDialog:= TfrmProgressDlg.Create(Nil);
  try
    case FileFormat of
      0:  // DXF
        begin
        // ask for the layer to export

        Layer := GetLayerFromDialog(Gis1);

        if Layer=nil then Exit;

        with TEzDxfExport.Create(nil) do
          try
            FileName:= SaveDialog1.FileName;
            DrawBox:= Self.DrawBox;
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
        // ask for the layer to export

        Layer := GetLayerFromDialog(Gis1);

        if Layer=nil then Exit;

        if AnsiCompareText( ExtractFilePath(SaveDialog1.FileName),
                            ExtractFilePath(Gis1.FileName))=0 then
        begin
          ShowMessage('You cannot export to same path !');
          exit;
        end;
        with TEzShpExport.Create(nil) do
          try
            DrawBox:= Self.DrawBox;
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
        // ask for the layer to export

        Layer := GetLayerFromDialog(Gis1);

        if Layer=nil then Exit;

        if AnsiCompareText( ExtractFilePath(SaveDialog1.FileName),
                            ExtractFilePath(Gis1.FileName))=0 then
        begin
          ShowMessage('You cannot export to same path !');
          exit;
        end;
        with TEzMifExport.Create(nil) do
          try
            DrawBox:= Self.DrawBox;
            FileName:= SaveDialog1.Filename;
            OnFileProgress:= Self.FileProgress;
            LayerName:= Layer.Name;
            Execute;
          finally
            Free;
          end;
        end;
      3:  // DGN
        begin
          // ask for the layer to export
          LayerList:= TStringList.Create;
          Try
            { define the seed file }
            SeedFileName:= GetDataPath + 'Template.Dgn';
            If Not FileExists( SeedFileName ) Then SeedFileName:= '';
            with TfrmDGNExport.create(Nil) do
              try
                For I:= 0 to GIS1.Layers.Count-1 do
                  ListBox1.Items.add(GIS1.Layers[I].Name);
                Edit3.Text:= SeedFileName;
                If not (ShowModal=mrOk) Or Not FileExists(Edit3.Text) then Exit;
                ExplodeIt:= chkExplode.Checked;
                SeedFileName:= Edit3.Text;
                For I:= 0 to ListBox1.Items.Count-1 do
                  If ListBox1.Selected[I] Then
                    LayerList.Add(ListBox1.Items[I] );
                If LayerList.Count=0 then exit;
              finally
                free;
              end;
            with TEzDGNExport.Create(nil) do
              try
                DGNExport( Self.GIS1, LayerList, SaveDialog1.FileName, SeedFileName, ExplodeIt );
              finally
                Free;
              end;
          Finally
            LayerList.Free;
          End;
        End;
    end;
  finally
    frmProgressDialog.free;
  end;
end;

procedure TForm1.actLayerControlExecute(Sender: TObject);
begin
  if not GIS1.Active then exit;
  with TfrmLayers.Create(Nil) do
    try
      Enter(Self.DrawBox);
    finally
      Free;
    end;
end;

procedure TForm1.actAddLayerExecute(Sender: TObject);
begin
  if not OpenDialog7.Execute then Exit;
  if Gis1.Layers.IndexOfName( ExtractFileName( OpenDialog7.FileName ) ) >=0 then
    raise Exception.Create( 'Layer already exists !' );
  Gis1.Layers.Add( ChangeFileExt(OpenDialog7.FileName,''), ltDesktop );
  Gis1.Layers[Gis1.Layers.Count-1].Open;
  Gis1.RepaintViewports;
end;

procedure TForm1.actUnloadLayerExecute(Sender: TObject);
var
  Layer: TEzBaseLayer;
  wasActive: boolean;
begin
  Layer:= GetLayerFromDialog( Gis1 );
  if Layer=nil then exit;
  with Gis1 do
  begin
    WasActive:= AnsiComparetext(MapInfo.CurrentLayer, Layer.Name)=0;
    Gis1.Layers.Delete( Layer.Name, False );    // False= don't delete files
    if WasActive and (Layers.Count > 0) then
      MapInfo.CurrentLayer:= Layers[0].Name;
    if Layers.Count = 0 then
      with MapInfo do
      begin
        Extension:= INVALID_EXTENSION;
        CurrentLayer:= '';
      end;
  end;
  Gis1.RepaintViewports;
  //LayerList1.GIS:= Nil;
  //LayerList1.GIS:= GIS1; // causes to refresh its contents
end;

procedure TForm1.actReindexExecute(Sender: TObject);
begin
  Screen.Cursor:= crHourglass;
  try
    GIS1.RebuildTree;
  finally
    Screen.Cursor:= crDefault;
  end;
end;

procedure TForm1.actQuickUpdateExtensionExecute(Sender: TObject);
begin
  GIS1.QuickUpdateExtension;
end;

procedure TForm1.actUpdateExtensionExecute(Sender: TObject);
begin
  GIS1.UpdateExtension;
end;

procedure TForm1.actRestructureExecute(Sender: TObject);
var
  Layer: TEzBaseLayer;
begin
  CmdLine1.Clear;
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

procedure TForm1.actPackLayerExecute(Sender: TObject);
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
  DrawBox.Undo.Clear;  // cannot undo after this
end;

procedure TForm1.actRegenExecute(Sender: TObject);
begin
  { if an error ocurred Repaint will not repaint the viewport but
    RegenDrawing will restore it }
  DrawBox.RegenDrawing;
end;

procedure TForm1.actPanExecute(Sender: TObject);
begin
  CmdLine1.Clear;
  CmdLine1.DoCommand('SCROLL','');
end;

procedure TForm1.actZoomInExecute(Sender: TObject);
begin
  CmdLine1.Clear;
  CmdLine1.DoCommand('ZOOMIN','');
end;

procedure TForm1.actZoomOutExecute(Sender: TObject);
begin
  CmdLine1.Clear;
  CmdLine1.DoCommand('ZOOMOUT','');
end;

procedure TForm1.actZoomRealtimeExecute(Sender: TObject);
begin
  CmdLine1.Clear;
  { change following to 'REALTIMEZOOM' for a vectorized (and slowly) version }
  { change following to 'REALTIMEZOOMB' for a image (and faster) version }
  CmdLine1.DoCommand('REALTIMEZOOM','');
end;

procedure TForm1.actZoomPreviousExecute(Sender: TObject);
begin
  CmdLine1.Clear;
  DrawBox.ZoomPrevious;
end;

procedure TForm1.actZoomSelectionExecute(Sender: TObject);
begin
  DrawBox.ZoomToSelection;
end;

procedure TForm1.actZoomLayerExecute(Sender: TObject);
var
  Layer: TEzBaseLayer;
begin
  Layer:= GetLayerFromDialog(Gis1);
  if Layer=nil then exit;
  DrawBox.ZoomToLayerRef(Layer.Name);
end;

procedure TForm1.actZoomAllExecute(Sender: TObject);
begin
  CmdLine1.Clear;
  DrawBox.ZoomToExtension;
end;

procedure TForm1.actViewGridExecute(Sender: TObject);
begin
  actViewGrid.Checked := not actViewGrid.Checked;
  DrawBox.GridInfo.ShowGrid := actViewGrid.Checked;
  DrawBox.Repaint;
end;

procedure TForm1.actShowHintsExecute(Sender: TObject);
begin
  FLayersOptions.Prepare(Gis1);
  CmdLine1.DoCommand('HINTS','');
end;

procedure TForm1.actShowCoordsExecute(Sender: TObject);
begin
  CmdLine1.DoCommand('CUSTOMCLICK','COORDS');
end;

procedure TForm1.actShowCmdLineExecute(Sender: TObject);
begin
  actShowCmdLine.Checked:= not actShowCmdLine.Checked;
  CmdLine1.Visible:= actShowCmdLine.Checked;
end;

procedure TForm1.actAerialViewExecute(Sender: TObject);
begin
  { create the aerial view }
  if frmAerial=nil then
  begin
    fAerial.ParentHWND:= Self.handle;
    frmAerial:= TfrmAerial.Create(Nil);
    frmAerial.AerialView1.ParentView:= Self.DrawBox;
  end;
  frmAerial.Show;
end;

procedure TForm1.actNamedviewsExecute(Sender: TObject);
begin
  actNamedviews.checked:= not actNamedviews.checked;
  if actNamedviews.checked then
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

procedure TForm1.actEditDatabaseInfoExecute(Sender: TObject);
begin

  EditDBParentHWND:= Self.Handle;

  TfrmEditDB.Create(Nil).Enter(CmdLine1, nil);

  {CmdLine1.Clear;
  { EDITDB - command }
  //CmdLine1.Push( TEditDBAction.CreateAction( CmdLine1 ), false, 'EDITDB', 'EDITDB_KEY' ); }
end;

procedure TForm1.actEditGraphicInfoExecute(Sender: TObject);
begin
  { defines the parent of the inspector form. Take a look at fInspector.pas }
  InspParentHWND:= Self.Handle;

  TfrmInspector.Create(Nil).Enter(CmdLine1);

  { start the action for the inspector }
  {CmdLine1.Clear;
  CmdLine1.Push(TEditGraphicPropsAction.CreateAction(CmdLine1), True, '',''); }
end;

procedure TForm1.actRevertdirectionExecute(Sender: TObject);
begin
   DrawBox.SelectionChangeDirection;
end;

procedure TForm1.actAddMarkerExecute(Sender: TObject);
begin
  CmdLine1.DoCommand('MARKER','');
end;

procedure TForm1.actClearMarkersExecute(Sender: TObject);
begin
  DrawBox.TempEntities.Clear;
  DrawBox.Refresh;
  FCurrentMarkerIndex:= -1;
end;

procedure TForm1.actFitToPathExecute(Sender: TObject);
begin
  DrawBox.FitSelectionToPath(true);
end;

procedure TForm1.actFitTextToPathExecute(Sender: TObject);
begin
  DrawBox.FitSelectionToPath(true);
end;

procedure TForm1.actOrtoExecute(Sender: TObject);
begin
  actOrto.Checked := not actOrto.Checked;
  CmdLine1.UseOrto := actOrto.Checked;
end;

procedure TForm1.actClipRectangularExecute(Sender: TObject);
begin
   CmdLine1.DoCommand('SETCLIPAREA', '');
end;

procedure TForm1.actClipPolygonalExecute(Sender: TObject);
begin
  CmdLine1.DoCommand('CLIPPOLYAREA','');
end;

procedure TForm1.actSetClipBoundaryfromSelectionExecute(Sender: TObject);
begin
  DrawBox.SetClipBoundaryFromSelection;
end;

procedure TForm1.actCancelclippedExecute(Sender: TObject);
begin
  GIS1.ClearClippedArea;
end;

procedure TForm1.actGeoreferencedImageExecute(Sender: TObject);
var
  Subdir, filnam: string;
begin
  Subdir:=ezsystem.AddSlash(Preferences1.CommonSubDir);
  filnam:=EzActions.SelectCommonElement(Subdir, 'EzGIS Georeferenced Images (*.GRI)|*.GRI', liAllImages);
  if Length(filnam)=0 then exit;
  DrawBox.Gis.AddGeoref(DrawBox.Gis.CurrentLayerName, Subdir+ExtractFileName(filnam));
  DrawBox.Repaint;
end;

procedure TForm1.actSelectRectangleExecute(Sender: TObject);
begin
  CmdLine1.Clear;
  CmdLine1.DoCommand('SELECT','');
end;

procedure TForm1.actSelectCircleExecute(Sender: TObject);
begin
  CmdLine1.Clear;
  CmdLine1.DoCommand('CIRCLESEL','');
end;

procedure TForm1.actSelectMultiObjectExecute(Sender: TObject);
begin
  CmdLine1.Clear;
  CmdLine1.DoCommand('SELECT','');
end;

procedure TForm1.actSelectPolylineExecute(Sender: TObject);
begin
  CmdLine1.Clear;
  CmdLine1.DoCommand('POLYGONSEL','');
end;

procedure TForm1.actSelectBufferExecute(Sender: TObject);
begin
  CmdLine1.Clear;
  CmdLine1.DoCommand('POLYGONSEL','');
end;

procedure TForm1.actDefaultActionExecute(Sender: TObject);
begin
  CmdLine1.Clear ;
  DrawBox.Cursor := crDefault ;
end;

procedure TForm1.actSelectAllExecute(Sender: TObject);
begin
  DrawBox.SelectAll;
end;

procedure TForm1.actUnSelectAllExecute(Sender: TObject);
begin
  DrawBox.UnSelectAll;
end;

procedure TForm1.actSelectEntireLayerExecute(Sender: TObject);
var
  Layer: TEzBaseLayer;
  Canceled: Boolean;
begin
  Layer := GetLayerFromDialog(Gis1);
  if Layer=nil then exit;
  DrawBox.DoSelectLayer(Layer,Canceled);
  DrawBox.Repaint;
end;

procedure TForm1.actCopySelectionToExecute(Sender: TObject);
var
  I, L: Integer;
  TmpEntity: TEzEntity;
  Entities: array[TEzEntityID] of TEzEntity;
  cnt, CurrEntityID: TEzEntityID;
  TmpLayer, DestLayer: TEzBaseLayer;
  TmpIndex: Integer;
  DstField, SrcField: Integer;
  TmpRecno, flds: integer;
  fldname: string;
begin
  if DrawBox.Selection.Count=0 then exit;
  DestLayer:= GetLayerFromDialog(Gis1);
  if DestLayer = nil then Exit;
  with DrawBox do
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
                  DestLayer.AddEntity(TmpEntity);
                  if (DestLayer.DBTable <> nil) and (TmpLayer.DBTable <> nil) then
                  begin
                    if TmpLayer.DBTable<>nil then
                      TmpLayer.DBTable.Recno:= TmpRecno;
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

procedure TForm1.actBlinkSelectionExecute(Sender: TObject);
var
  I,L: Integer;
  SelLayer: TEzSelectionLayer;
begin
  Timer1.Enabled:= False;
  if DrawBox.Selection.Count=0 then exit;
  For L:= 0 to GIS1.Layers.Count-1 Do
    GIS1.Layers[L].ClearBlinkers;
  For I:= 0 to DrawBox.Selection.Count-1 do
  begin
    SelLayer:= DrawBox.Selection[I];
    { assign one integer list (the selection) to other integer list (list of blinkers) }
    SelLayer.Layer.Blinkers.Assign( SelLayer.SelList );
  end;
  DrawBox.Selection.Clear;
  DrawBox.Repaint;
  Timer1.Enabled:= True;
end;

procedure TForm1.actSuspendBlinkingExecute(Sender: TObject);
var
  L: Integer;
begin
  Timer1.Enabled:= False;
  For L:= 0 to GIS1.Layers.Count-1 Do
    GIS1.Layers[L].ClearBlinkers;
end;

procedure TForm1.actLineStyleExecute(Sender: TObject);
begin
  VerifySizes;
  with TfrmLineType.create(Nil) do
    try
      Enter(self.DrawBox);
    finally
      free;
    end;
end;

procedure TForm1.actFillStyleExecute(Sender: TObject);
begin
  with TfrmBrushStyle.create(Nil) do
    try
      Enter(DrawBox);
    finally
      free;
    end;
end;

procedure TForm1.actSymbolStyleExecute(Sender: TObject);
begin
  VerifySizes;
  with TfrmSymbolStyle.Create(Nil) do
    try
      Enter(self.DrawBox);
    finally
      Free;
    end;
end;

procedure TForm1.actTextStyleExecute(Sender: TObject);
begin
  VerifySizes;
  with TfrmFontStyle.create(Nil) do
    try
      Enter(self.DrawBox);
    finally
      free;
    end;
end;

procedure TForm1.AccusnapClose(Sender: TObject);
begin
  FfrmAccuSnap:= Nil;
  actShowAccuSnap.Checked:= False;
end;

procedure TForm1.actShowAccuSnapExecute(Sender: TObject);
var
  p: TPoint;
begin
  actShowAccuSnap.Checked:=not actShowAccuSnap.Checked;
  if actShowAccuSnap.Checked then
  begin
    { create the aerial view }
    if FfrmAccuSnap=nil then
    begin
      fAccuSnap.AccuSnapParent:= Self.Handle;
      FfrmAccuSnap:= TfrmAccuSnap.Create(Nil);
      FfrmAccuSnap.OnThisClose:= Self.AccusnapClose;
    end;
    if FFrmAccuDraw<>Nil then
    begin
      FfrmAccuSnap.Left:= FfrmAccuDraw.Left;
      FfrmAccuSnap.Top:= FfrmAccuDraw.Top + FfrmAccuDraw.Height;
    end else
    begin
      fAccuDraw.AccuDrawParent:= Self.Handle;
      FfrmAccuDraw := TfrmAccuDraw.Create(Nil);
      p:= Self.ClientToScreen(Point(Panel1.Left,Panel1.Top));
      FfrmAccuSnap.Left:= p.x;
      FfrmAccuSnap.Top:= p.y + FfrmAccuDraw.Height;
      FreeAndNil( FfrmAccuDraw  );
    end;
    FfrmAccuSnap.Enter(Self.CmdLine1);
    If DrawBox<>Nil then
      ActiveControl:= DrawBox;
  end else if Assigned( FfrmAccuSnap ) then
    FreeAndNil( FfrmAccuSnap );
end;

procedure TForm1.actConfigureAccuSnapExecute(Sender: TObject);
begin
  with TfrmAccuSnapSetts.create(nil) do
    try
      If (enter(Self.CmdLine1)=mrOk) And Assigned(FfrmAccuSnap) Then
        FfrmAccuSnap.Reset;
    finally
      free;
    end;
end;

procedure TForm1.actConfigureAccuDrawExecute(Sender: TObject);
begin
  with TfrmAccuDrawSetts.create(nil) do
    try
      if (Enter(Self.CmdLine1)=mrOk) and Self.CmdLine1.AccuDraw.Enabled then
        DrawBox.Refresh;
    finally
      free;
    end;
end;

procedure TForm1.actRotateAccuDrawExecute(Sender: TObject);
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

procedure TForm1.actRotateInteractivelyExecute(Sender: TObject);
begin
  If CmdLine1.CurrentAction Is TRotateAccuDrawAction Then Exit;
  CmdLine1.Push(TRotateAccuDrawAction.CreateAction(CmdLine1),False,'','');
end;

procedure TForm1.actUnrotateAccuDrawExecute(Sender: TObject);
begin
  If Not CmdLine1.AccuDraw.Showing Then Exit;
  CmdLine1.AccuDraw.ShowUnrotated;
end;

procedure TForm1.actChangeAccuDrawOriginExecute(Sender: TObject);
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

procedure TForm1.actSymbolsEditorExecute(Sender: TObject);
begin
  with TfrmSymbols.Create(Nil) do
    try
      ShowModal;
    finally
      free;
    end;
end;

procedure TForm1.actLinetypeEditorExecute(Sender: TObject);
begin
  with TfrmLinetypes.Create(Nil) do
    try
       ShowModal;
    finally
      free;
    end;
end;

procedure TForm1.actRasterImageEditorExecute(Sender: TObject);
begin
  with TfrmRasterImgEditor.create(Nil) do
    try
      ShowModal;
    finally
      Free;
    end;
end;

procedure TForm1.actBlocksEditorExecute(Sender: TObject);
begin
  with TfrmBlocks.Create(Nil) do
    try
      showmodal;
    finally
      free;
    end;
end;

procedure TForm1.actMapUnitsExecute(Sender: TObject);
var
  I: Integer;
begin
  with TfrmMapOpts.create(Nil) do
    try
      Enter(DrawBox);
      for I:= Low(ClonedViews) to High(ClonedViews) do
        If ClonedViews[I] <> Nil then
          ClonedViews[I].ScaleBar1.Units:= GIS1.MapInfo.CoordsUnits;
    finally
      free;
    end;
end;

procedure TForm1.actReprojectExecute(Sender: TObject);
begin
  with TfrmReproject.create(Nil) do
    try
      Enter(Self.Gis1);
    finally
      free;
    end;
end;

procedure TForm1.actSnapToGridExecute(Sender: TObject);
begin
  actSnapToGrid.Checked := not actSnapToGrid.Checked;
  DrawBox.GridInfo.SnapToGrid := actSnapToGrid.Checked;
end;

procedure TForm1.actSnapToGLinesExecute(Sender: TObject);
begin
  actSnapToGLines.Checked := not actSnapToGLines.Checked;
  DrawBox.SnapToGuideLines := actSnapToGLines.Checked;
end;

procedure TForm1.actPreferencesExecute(Sender: TObject);
begin
  with TfrmPreferences.Create(Nil) do
    try
      Enter(Self.Preferences1);
    finally
      free;
    end;
end;

procedure TForm1.actViewportConfigExecute(Sender: TObject);
begin
  with TfrmDBInspector.Create(Nil) do
    try
      Enter( TEzDrawBox(Self.DrawBox) );
    finally
      Free;
    end;
end;

procedure TForm1.actGisConfigExecute(Sender: TObject);
begin
  with TfrmGisInspector.Create(Nil) do
    try
      enter(Self.Gis1);
    finally
      free;
    end;
end;

procedure TForm1.actLayersConfigExecute(Sender: TObject);
begin
  with TfrmLayerInspector.create(nil) do
    try
      enter(self.gis1);
    finally
      free;
    end;
end;

procedure TForm1.actLoadVectorialFontExecute(Sender: TObject);
var
  Path: string;
begin
  Path:= GetDataPath;
  OpenDialog4.FileName:= Path + '*.fnt';
  if not OpenDialog4.Execute then Exit;
  Gis1.LoadFontFile( Path + ExtractFileName(OpenDialog4.FileName) );
end;

procedure TForm1.actLoadSymbolsFileExecute(Sender: TObject);
var
  Path: string;
begin
  Path:= GetDataPath;
  OpenDialog5.FileName:= Path + '*.ezs';
  if not OpenDialog5.Execute then Exit;
  if AnsiCompareText(Path, ExtractFilePath( OpenDialog5.FileName ) ) <> 0 then
  begin
    ShowMessage( 'Wrong path for finding symbols' + Ez_Preferences.CommonSubdir );
    Exit;
  end;
  Gis1.LoadSymbolsFile( Path + ExtractFileName(OpenDialog5.FileName) );
end;

procedure TForm1.actLoadLinetypesFileExecute(Sender: TObject);
var
  Path: string;
begin
  Path:= GetDataPath;
  OpenDialog6.FileName:= Path + '*.ezl';
  if not OpenDialog6.Execute then Exit;
  Gis1.LoadLineTypesFile( Path + ExtractFileName(OpenDialog6.FileName) );
end;

procedure TForm1.actMoveExecute(Sender: TObject);
begin
  CmdLine1.Clear;
  CmdLine1.DoCommand('MOVE','');
end;

procedure TForm1.actScaleExecute(Sender: TObject);
begin
  CmdLine1.Clear;
  CmdLine1.DoCommand('SCALE','');
end;

procedure TForm1.actRotateExecute(Sender: TObject);
begin
  CmdLine1.Clear;
  CmdLine1.DoCommand('ROTATE','');
end;

procedure TForm1.actReshapeExecute(Sender: TObject);
begin
  CmdLine1.Clear;
  CmdLine1.DoCommand('RESHAPE','');
end;

procedure TForm1.actInsertNodeExecute(Sender: TObject);
begin
  CmdLine1.Clear;
  CmdLine1.DoCommand('INSERTVERTEX','');
end;

procedure TForm1.actDeleteNodeExecute(Sender: TObject);
begin
  CmdLine1.Clear;
  CmdLine1.DoCommand('DELVERTEX','');
end;

procedure TForm1.actMirrorExecute(Sender: TObject);
begin
  CmdLine1.DoCommand('MIRROR','');
end;

procedure TForm1.actOffsetExecute(Sender: TObject);
begin
  CmdLine1.DoCommand('OFFSET','');
end;

procedure TForm1.actExplodeExecute(Sender: TObject);
begin
   DrawBox.ExplodeSelection(False);
end;

procedure TForm1.actTrimExecute(Sender: TObject);
begin
   CmdLine1.DoCommand('TRIM', '');
end;

procedure TForm1.actExtendExecute(Sender: TObject);
begin
   CmdLine1.DoCommand('EXTEND', '');
end;

procedure TForm1.actBreakExecute(Sender: TObject);
begin
  CmdLine1.DoCommand('BREAK','');
end;

procedure TForm1.actFilletExecute(Sender: TObject);
begin
   CmdLine1.DoCommand('FILLET', '');
end;

procedure TForm1.actJoinExecute(Sender: TObject);
begin
  DrawBox.JoinSelection(True);
end;

procedure TForm1.actPreserveOriginalsExecute(Sender: TObject);
begin
  actPreserveOriginals.Checked:= Not actPreserveOriginals.Checked;
  Gis1.PolygonClipOperation.PreserveOriginals:= actPreserveOriginals.Checked;
end;

procedure TForm1.actUnionExecute(Sender: TObject);
begin
  Gis1.PolygonClipOperation.Operation:= pcUnion;
  CmdLine1.Clear;
  CmdLine1.DoCommand('CLIP','');
end;

procedure TForm1.actIntersectionExecute(Sender: TObject);
begin
  Gis1.PolygonClipOperation.Operation:= pcInt;
  CmdLine1.Clear;
  CmdLine1.DoCommand('CLIP','');
end;

procedure TForm1.actDifferenceExecute(Sender: TObject);
begin
  Gis1.PolygonClipOperation.Operation:= pcDiff;
  CmdLine1.Clear;
  CmdLine1.DoCommand('CLIP','');
end;

procedure TForm1.actSplitExecute(Sender: TObject);
begin
  Gis1.PolygonClipOperation.Operation:= pcSplit;
  CmdLine1.Clear;
  CmdLine1.DoCommand('CLIP','');
end;

procedure TForm1.actXorExecute(Sender: TObject);
begin
  Gis1.PolygonClipOperation.Operation:= pcXor;
  CmdLine1.Clear;
  CmdLine1.DoCommand('CLIP','');
end;

procedure TForm1.actDimHorizontal1Execute(Sender: TObject);
begin
  CmdLine1.Clear;
  CmdLine1.DoCommand('DIMHORZ','');
end;

procedure TForm1.actDimVerticalExecute(Sender: TObject);
begin
  CmdLine1.Clear;
  CmdLine1.DoCommand('DIMVERT','');
end;

procedure TForm1.actDimParallelExecute(Sender: TObject);
begin
  CmdLine1.Clear;
  CmdLine1.DoCommand('DIMPARALL','');
end;

procedure TForm1.actToPolylineExecute(Sender: TObject);
begin
   DrawBox.SelectionToPolyline;
end;

procedure TForm1.actToPolygonExecute(Sender: TObject);
begin
   DrawBox.SelectionToPolygon;
end;

procedure TForm1.actCombineExecute(Sender: TObject);
begin
  DrawBox.JoinSelection(True);
end;

{ DWG stuff --------------------------

  NOTE: we have provided this DWG stuff as free
  We have compiled the version that read/write AutoCAD until release 14
  so if you need one updated version, you have to got it from:

  http://www.OpenDWG.org

  because we don't have it yet. If you got updated version for AutoCAD
  2000 and 200i , please send to us in order to benefit other people also
  (  and to us :-)  ).

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

procedure TForm1.actConvertAutoCADDWGDXFExecute(Sender: TObject);
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
    if __adSaveFile(DrawingHandle,Pointer(Filename) ,Filetype, FileVersion,0,6,1,1)<>1 then
    begin
       ShowMessage(__adErrorStr(__adError));
       result:=false;
    end else
    begin
       result:=true;
    end;
    Gis1.EndProgress;

  // For filetypes you can use consts AD_DXF and AD_DWG these can be found in ad2cnst.pas
  // For FileVersion you can use
  //     AD_ACAD25, AD_ACAD26, AD_ACAD9, AD_ACAD10, AD_ACAD11, AD_ACAD13, AD_ACAD14.
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
    SaveDWGFileAs(AD_DXF, AD_ACAD11, NewFilename);
    CloseDWGFile;
  finally
    FreeLibrary(LibHandle);
  end;
end;

procedure TForm1.actChangeReshapeRotateOriginExecute(Sender: TObject);
begin
  Ez_Preferences.GRotatePoint:= cmdLine1.GetSnappedPoint;
  DrawBox.Invalidate;
end;

procedure TForm1.actQueryExecute(Sender: TObject);
var
  Layer: TEzBaseLayer;
begin
  Layer:= GetLayerFromDialog(Gis1);
  if Layer=nil then exit;
  ParentSelectHWND := Self.Handle;
  TfrmSelectDlg.Create(Application).Enter(DrawBox, CmdLine1, Layer);
end;

procedure TForm1.actThematicsEditorExecute(Sender: TObject);
var
  Layer: TEzBaseLayer;
  ABuilder: TEzThematicBuilder;
  IsNew: Boolean;
  I, Index: Integer;
begin
  Layer:= GetLayerFromDialog(Gis1);
  if Layer=nil then exit;
  IsNew:= false;
  { search if this already exists for this layer }
  Index:= -1;
  for I:= 0 to FThematicList.Count-1 do
    if AnsiCompareText( TEzThematicBuilder( FThematicList[I] ).LayerName, Layer.Name ) = 0 then
    begin
      Index:= I;
      break;
    end;
  if Index = -1 then
  begin
    ABuilder:= TEzThematicBuilder.Create( Nil );
    ABuilder.LayerName:= Layer.Name;
    IsNew:= true;
  end else
    ABuilder:= TEzThematicBuilder( FThematicList[Index] );
  with TfrmThematicsEditor.Create( Nil ) do
    try
      If ( Enter( Self.DrawBox, ABuilder ) = mrOk ) And ABuilder.ShowThematic then
      begin
        if ABuilder.ThematicRanges.Count > 0 then
        begin
          { add to the list of thematics }
          If IsNew then
            FThematicList.Add( ABuilder );

          if FfrmLegend=nil then
          begin
            FfrmLegend:= TfrmLegend.Create( Nil );
          end;
          FfrmLegend.Legend1.Visible:=True;
          FfrmLegend.Legend1.PopulateFrom(ABuilder);
          FfrmLegend.Legend1.Invalidate;
          If ABuilder.ApplyPen Then
            FfrmLegend.Legend1.LegendStyle:= ctLineStyle
          Else If ABuilder.ApplyBrush Then
            FfrmLegend.Legend1.LegendStyle:= ctBrushStyle
          Else If ABuilder.ApplySymbol Then
            FfrmLegend.Legend1.LegendStyle:= ctSymbolStyle;

          Self.DrawBox.Repaint;

        end else If IsNew then
          ABuilder.Free;
      end else
      begin
        If IsNew then
          ABuilder.Free;
      end;
    finally
      Free;
    end;
end;

procedure TForm1.actTurnoffthematicsExecute(Sender: TObject);
begin
  ClearThematicList;
  If Assigned(FfrmLegend) Then
    FreeAndNil( FfrmLegend );
  DrawBox.Repaint;
end;

procedure TForm1.actAddNodesExecute(Sender: TObject);
begin
  CmdLine1.Clear;
  CmdLine1.DoCommand('NODE', '');
end;

procedure TForm1.actAddNodeLinksExecute(Sender: TObject);
begin
  CmdLine1.Clear;
  CmdLine1.DoCommand('NODELINK', '');
end;

procedure TForm1.actAnalysisExecute(Sender: TObject);
begin
  TfrmNetwork.create(Application).Enter;
end;

procedure TForm1.actAboutExecute(Sender: TObject);
begin
  cmdLine1.ActiveDrawbox.ZoomToScale(1000,suCms);
  exit;
  //Preferences1.AddImage('c:\ezgis\demos\data\bahia kino1.bmp');

  //DrawBox.AddEntityFromText('',
  //  'DIMHORIZONTAL (485035.638, 2141328.826), (485455.577, 2141123.388), 2141458.735');
  //DrawBox.Repaint;

  //DrawBox.AddEntityFromText('',
  //  'BANDSBITMAP (484441.191, 2137495.992), (486191.942, 2139069.899), "f19d2a_s.bmp"');
  {
  // create a sample entity
  DrawBox.AddEntityFromText('',
    'RECTANGLE (484441.191, 2137495.992), (486191.942, 2139069.899)');
  Exit;
  // or ...
  Ent:=DrawBox.CreateEntityFromText(
      'RECTANGLE (484441.191, 2137495.992), (486191.942, 2139069.899)');
  if Ent=nil then Exit;
  // add to the current layer
  DrawBox.AddEntity('',Ent);
  DrawBox.Repaint;
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

procedure JumpToURL(const url: string);
begin
  ShellExecute(Application.Handle, nil, PChar(url), nil, nil, SW_SHOW);
end;

procedure TForm1.actEzSoftEngineeringHOMEPAGEExecute(Sender: TObject);
begin
  JumpToURL( 'http://www.ezgis.com' );
end;

procedure TForm1.actWritetoUsExecute(Sender: TObject);
begin
  JumpToURL( 'mailto: support@ezgis.com' );
end;

procedure TForm1.FileOpen1BeforeExecute(Sender: TObject);
begin
  CmdLine1.Clear;
  GIS1.SaveIfModified;
end;

procedure TForm1.FileOpen1Accept(Sender: TObject);
begin
  If DrawBox <> Nil then
    DrawBox.Selection.Clear;
  GIS1.FileName:= FileOpen1.Dialog.FileName;
  GIS1.Open;
  GIS1.RepaintViewports;
  FLayersOptions.LoadFromFile( ChangeFileExt(Gis1.FileName, '.opt' ) );
  LoadNamedViews;
  cmdLine1.All_Repaint;
end;

procedure TForm1.Action12Execute(Sender: TObject);
begin
  CmdLine1.Clear;
  Close;
end;

procedure TForm1.EditUndo1Execute(Sender: TObject);
begin
  If Not DrawBox.Undo.CanUndo Then Exit;
  Screen.Cursor:= crHourglass;
  Try
    DrawBox.Selection.Clear;
    DrawBox.Undo.Undo;
    DrawBox.Repaint;
  Finally
    Screen.Cursor:= crDefault;
  End;
end;

procedure TForm1.EditCut1Execute(Sender: TObject);
begin
  DrawBox.Undo.CopyToClipboardFromSelection;
  DrawBox.DeleteSelection;
  GIS1.RepaintViewports;
end;

procedure TForm1.EditCopy1Execute(Sender: TObject);
begin
  DrawBox.Undo.CopyToClipboardFromSelection;
end;

procedure TForm1.EditPaste1Execute(Sender: TObject);
begin
  DrawBox.Undo.PasteFromClipboardTo;
  DrawBox.Repaint;
end;

procedure TForm1.EditDelete1Execute(Sender: TObject);
begin
  DrawBox.DeleteSelection;
end;

procedure TForm1.GIS1AfterDragDrop(Sender: TObject; Layer: TEzBaseLayer;
  Recno: Integer);
begin
  ShowMessage( Format('Dragged entity in Layer : %s, RecNo: %d', [Layer.Name, Recno] ) );
end;

procedure TForm1.GIS1AfterInsertLayer(Sender: TObject;
  const LayerName: String);
begin
  //LayerList1.Gis:= Self.Gis1;
end;

procedure TForm1.GIS1FileNameChange(Sender: TObject);
begin
  Caption:= Format('EzGIS Main Demo - %s', [GIS1.FileName]);
  //LayerList1.Gis:= Self.Gis1;

  If (Length( GIS1.FileName) > 0) And (Self.DrawBox = Nil) Then
    { open the view 1 }
    actView1.OnExecute(actView1);

end;

procedure TForm1.GIS1GisTimer(Sender: TObject;
  var CancelPainting: Boolean);
begin
  CancelPainting:= DetectCancelPaint( DrawBox );
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

procedure TForm1.GIS1PrintEnd(Sender: TObject);
begin
  frmPrintProgress.Free;
end;

procedure TForm1.GIS1PrintProgress(Sender: TObject; Percent: Integer;
  var Cancel: Boolean);
begin
  frmPrintProgress.Bar1.Position := Percent;
  Application.ProcessMessages;
  Cancel:= frmPrintProgress.ModalResult=mrCancel;
end;

procedure TForm1.GIS1Progress(Sender: TObject; Stage: TEzProgressStage;
  const Caption: String; Min, Max, Position: Integer);
begin
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

procedure TForm1.GIS1ShowDirection(Sender: TObject; Layer: TEzBaseLayer;
  Recno: Integer; var DirectionPos: TEzDirectionPos;
  DirectionPen: TEzPenTool; DirectionBrush: TEzBrushTool;
  var RevertDirection, CanShow: Boolean);
begin
  if (Flo=nil) or Not (Flo.ShowLineDirection) then exit;
  DirectionPos:= Flo.DirectionPos;
  DirectionPen.Assign(Flo.DirectionPen);
  DirectionBrush.assign(Flo.DirectionBrush);
  RevertDirection:= Flo.RevertDirection;
  CanShow:= true;  { maybe later we show direction with an expression }
end;

procedure TForm1.EditUndo1Update(Sender: TObject);
begin
  if (DrawBox = Nil) or not (GIS1.Active) Then Exit;
  EditUndo1.Caption:= DrawBox.Undo.GetVerb;
  EditUndo1.Enabled:= GIS1.Active;
end;

procedure TForm1.actSymbolMultExecute(Sender: TObject);
begin
  VerifySizes;
  if actSymbolMult.checked then
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

procedure TForm1.actTextPlaceExecute(Sender: TObject);
begin
  VerifySizes;
  CmdLine1.Clear;
  CmdLine1.DoCommand('TEXTSYMBOL', '');
end;

procedure TForm1.actRoundedExecute(Sender: TObject);
begin
  if FfrmRounded=Nil then
  begin
    FfrmRounded:= TfrmRounded.Create(Nil);
    FfrmRounded.Show;
    DrawBox.SetFocus;
  end else
    FreeAndNil( FfrmRounded );
end;

procedure TForm1.actView1Execute(Sender: TObject);
var
  Item: TEzDrawBoxItem;
  fClone: TFrmClone;
  Action: TAction;
  R: TRect;
Begin
  Action:= Sender as TAction;
  If Assigned(ClonedViews[Action.Tag]) Then
  begin
    If ViewsCount <= 2 then FNextView:= 0;
    If ViewsCount = 1 then Exit;
    FreeAndNil( ClonedViews[Action.Tag] );
    Action.Checked:= False;
  End Else
  Begin
    fClone:= TfrmClone.Create(Nil);
    fClone.Parent:= Panel1;
    fClone.Tag:= Action.Tag;
    fClone.Caption:= Action.Caption;
    fClone.Tag:= Action.Tag;
    fClone.DrawBox1.GIS:= Self.GIS1;

    If ViewsCount > 0 Then
      with fClone.DrawBox1 do
      begin
        RubberPen.Assign( Self.DrawBox.RubberPen );
        NumDecimals:= self.Drawbox.NumDecimals;
        DefaultScaleUnits:= self.Drawbox.DefaultScaleUnits;
        NoPickFilter:=self.Drawbox.NoPickFilter;
      end;

    Item:= self.cmdLine1.DrawBoxList.Add;
    Item.DrawBox:= fClone.DrawBox1;

    fClone.DrawBox1.ReSync;  // synchronize internal buffer bitmap and control's dimensions
    If ViewsCount > 0 Then
      fClone.DrawBox1.Grapher.SetViewTo(DrawBox.Grapher.CurrentParams.VisualWindow)
    Else
      fClone.DrawBox1.Grapher.SetViewTo(DrawBox.GIS.MapInfo.LastView);

    R:= Panel1.ClientRect;
    If ViewsCount > 0 Then
    begin
      case FNextView of
        0:
          begin
          fClone.Left:= 0;
          fClone.Top:= 0;
          end;
        1:
          begin
          fClone.Left:= 0;
          fClone.Top:= Succ(R.Bottom div 2);
          end;
        2:
          begin
          fClone.Left:= (R.Right div 2) + 2;
          fClone.Top:= 0;
          end;
        3:
          begin
          fClone.Left:= (R.Right div 2) + 2;
          fClone.Top:= Succ(R.Bottom div 2);
          end;
      else
          begin
          fClone.Left:= 0;
          fClone.Top:= 0;
          end;
      end;
      fClone.Width:= R.Right div 2;
      fClone.Height:= R.Bottom div 2;
      Inc(FNextView);
      If FNextView > 3 then FNextView:= 0;
    end else
    begin
      fClone.Left:= 0;
      fClone.Top:= 0;
      fClone.Width:= R.Right;
      fClone.Height:= R.Bottom;
    end;

    fClone.Show;

    ClonedViews[Action.Tag]:= fClone;

    Action.Checked:= True;

  End;
end;

procedure TForm1.actNextMarkerExecute(Sender: TObject);
begin
  if Drawbox.TempEntities.Count = 0 then Exit;
  Dec( FCurrentMarkerIndex );
  if FCurrentMarkerIndex < 0 then FCurrentMarkerIndex:= 0;
  if FCurrentMarkerIndex > Drawbox.TempEntities.Count-1 then
    FCurrentMarkerIndex:= Drawbox.TempEntities.Count-1;
  Drawbox.SetEntityInView( Drawbox.TempEntities[FCurrentMarkerIndex], False );
end;

procedure TForm1.actPriorMarkerExecute(Sender: TObject);
begin
  if Drawbox.TempEntities.Count = 0 then Exit;
  Inc( FCurrentMarkerIndex );
  if FCurrentMarkerIndex > Drawbox.TempEntities.Count-1 then
    FCurrentMarkerIndex:= Drawbox.TempEntities.Count-1;
  Drawbox.SetEntityInView( Drawbox.TempEntities[FCurrentMarkerIndex], False );
end;

procedure TForm1.AccuDrawFormClose(Sender: TObject);
begin
  FfrmAccuDraw:= Nil;
  actAccuDraw.Checked:= False;
end;

procedure TForm1.CmdLine1AccuDrawActivate(Sender: TObject);
var
  p: TPoint;
begin
  If CmdLine1.AccuDraw.Enabled then
  begin
    If (FfrmAccuDraw <> Nil) And FfrmAccuDraw.Visible then exit;
    If FfrmAccuDraw = Nil then
    begin
      fAccuDraw.AccuDrawParent:= Self.Handle;
      FfrmAccuDraw := TfrmAccuDraw.Create(Nil);
      FfrmAccuDraw.OnThisClose:= Self.AccuDrawFormClose;
      p:= Self.ClientToScreen(Point(Panel1.Left,Panel1.Top));
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
    FfrmAccuDraw.Enter(Self.CmdLine1);
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
begin
  if FfrmAccuSnap=nil then exit;
  FfrmAccuSnap.ResetToDefault;
end;

procedure TForm1.CmdLine1AfterCommand(Sender: TObject; const Command,
  ActionID: String);
begin
  If ActionID='AUTOLABELING' then
    FAutoLabeling:= False;
end;

procedure TForm1.CmdLine1StatusMessage(Sender: TObject;
  const AMessage: String);
begin
  StatusBar1.Panels[0].Text:= AMessage;
end;

procedure TForm1.actHGLinesExecute(Sender: TObject);
begin
  CmdLine1.Clear;
  CmdLine1.DoCommand('HGLINE','');
end;

procedure TForm1.actVGLinesExecute(Sender: TObject);
begin
  CmdLine1.Clear;
  CmdLine1.DoCommand('VGLINE','');
end;

procedure TForm1.actMeasuresExecute(Sender: TObject);
begin
  CmdLine1.Clear;
  CmdLine1.DoCommand('MEASURES','');
end;

procedure TForm1.actCircle3PExecute(Sender: TObject);
begin
  CmdLine1.DoCommand('CIRCLE3P','');
end;

procedure TForm1.actBrowseExecute(Sender: TObject);
begin
  //If LayerList1.ItemIndex < 0 then exit;
  { this method display always the first layer
    change as needed to display another layer (maybe by asking
    in a dialog window) }
  actBrowse.Checked:= Not actBrowse.Checked;
  if actBrowse.Checked then
  begin
    if GIS1.Layers.Count=0 then Exit;
    { the form is automatically freed }
    BrowseParentHWND:= Self.Handle;   // the parent of the browse form;
    if FfrmBrowse = Nil then
      FfrmBrowse:= TfrmDemoBrowse.Create(Nil);
    FfrmBrowse.Enter(DrawBox, GIS1.Layers[ 0]);//LayerList1.ItemIndex ] );
  end else
    FreeAndNil( FfrmBrowse );
end;

procedure TForm1.Action23Execute(Sender: TObject);
begin
  DrawBox.CopyToClipboardAsBmp;
end;

procedure TForm1.actAutoLabelExecute(Sender: TObject);
begin
  if FfrmAutoLabel=Nil then
  begin
    FfrmAutoLabel:= TfrmAutoLabel.Create(Nil);
    FfrmAutoLabel.Show;
    DrawBox.SetFocus;
  end else
    FreeAndNil( FfrmAutoLabel );
end;

procedure TForm1.actCircleCRExecute(Sender: TObject);
begin
  CmdLine1.DoCommand('CIRCLECR','');
end;

procedure TForm1.Action39Execute(Sender: TObject);
begin
  CmdLine1.Clear;
  CmdLine1.DoCommand('ARC','');
end;

procedure TForm1.actArcCRSEExecute(Sender: TObject);
begin
  CmdLine1.Clear;
  CmdLine1.DoCommand('ARCSE','');
end;

procedure TForm1.actArcSCEExecute(Sender: TObject);
begin
  CmdLine1.Clear;
  CmdLine1.DoCommand('ARCFCS','');
end;

procedure TForm1.actMultiPartExecute(Sender: TObject);
begin
  if FfrmMultipart=Nil then
  begin
    FfrmMultipart:= TfrmMultipart.Create(Nil);
    FfrmMultipart.Show;
    DrawBox.SetFocus;
  end else
    FreeAndNil( FfrmMultipart );
end;

procedure TForm1.PopulateNativeAndExternalFields(
  Layer: TEzBaseLayer; Fields: TStrings; IncludesLayerName: Boolean = False);
var
  J: Integer;
  lo: TEzLayerOptions;
  ALayname,Identifier: string;
  Accept: boolean;
begin
  if Assigned( Layer.DbTable ) then
    For J:=1 to Layer.DBTable.FieldCount Do
    Begin
      Fields.Add( Layer.DbTable.Field( J ) );
    End;
  { now add external fields }
  lo := FLayersOptions.LayerByname( Layer.Name );
  if (lo <> Nil) and lo.Connected then
  begin
    if Assigned( Gis1.OnStartExternalPopulate ) And
       Assigned( Gis1.OnExternalPopulate ) then
    begin

      ALayname:= Layer.Name;
      if AnsiPos( #32, ALayName) > 0 then
        ALayName := '[' + ALayname + ']';

      if Not IncludesLayerName then ALayName := '';

      Accept:= True;
      Gis1.OnStartExternalPopulate( Gis1, Layer.Name, Accept );
      if Accept then
      begin
        Identifier := '';
        Gis1.OnExternalPopulate( Gis1, Layer.Name, Identifier );
        While Length( Identifier ) > 0 do
        begin
          { detect field type }
          if AnsiPos( #32, Identifier ) > 0 then
            Identifier:= '[' + Identifier + ']';
          if Length(ALayname) > 0 then
            Fields.Add( ALayname + '.' + Identifier )
          else
            Fields.Add( Identifier );

          Identifier := '';
          Gis1.OnExternalPopulate( Gis1, Layer.Name, Identifier );
        end;
        if Assigned( Gis1.OnEndExternalPopulate ) then
          Gis1.OnEndExternalPopulate( Gis1, Layer.Name );
      End;
    end;
  end;
end;

function TForm1.GetDrawBox: TEzBaseDrawBox;
begin
  Result:= CmdLine1.ActiveDrawBox;
end;

procedure TForm1.actRepaintExecute(Sender: TObject);
var
  I: Integer;
begin
  for I:= 0 to cmdLine1.DrawBoxList.Count-1 do
    cmdLine1.DrawBoxList[I].DrawBox.Repaint;
end;

procedure TForm1.actPrintPreviewExecute(Sender: TObject);
begin
  CmdLine1.Clear;
  frmDemoPreview:= TfrmDemoPreview.Create(Nil);
  with frmDemoPreview do
    try
      Enter(Self.DrawBox);
    finally
      Free;
    end;
end;

procedure TForm1.actPrintPreviewUpdate(Sender: TObject);
begin
  actPrintPreview.Enabled:= DrawBox <> Nil;
end;

function TForm1.ViewsCount: Integer;
var I: Integer;
begin
  Result:= 0;
  for I:= 0 to 5 do
    If ClonedViews[I] <> Nil Then Inc(Result);
end;

procedure TForm1.GIS1BeforePaintEntity(Sender: TObject;
  Layer: TEzBaseLayer; Recno: Integer; Entity: TEzEntity;
  Grapher: TEzGrapher; Canvas: TCanvas; const Clip: TEzRect;
  DrawMode: TEzDrawMode; var CanShow: Boolean; var EntList: TEzEntityList;
  var AutoFree: Boolean);
var
  //Chart: TChart;
  //Series: TChartSeries;
  //mf: TMetafile;
  cs:Double;
begin
  {if Entity.EntityID = idBandsBitmap then
  begin
    TEzBandsBitmap(Entity).Alphachannel:= 0;    // try with 80
    exit;
  end; }
  { this is an example of how tu draw something to a idCustomPicture entity }
  (*if (Entity.EntityID = idCustomPicture) and (DrawMode = dmNormal) then
  begin
    { create a metafile }
    Chart:= TChart.Create(Self);
    Chart.Parent:= Self;
    Series:= TPieSeries.Create(Self);
    Series.ParentChart:= Chart;
    Series.Clear;
    Series.Add( 1234, 'USA', clBlue );
    Series.Add( 2001, 'Europe', clRed );
    Series.Add( 1900, 'South America', clGreen );
    mf:= Chart.TeeCreateMetafile(true,Chart.ClientRect);
    try
      FCustomPicture.Metafile.Assign( mf );
      TEzCustomPicture( Entity ).Picture := FCustomPicture;
    finally
      Chart.Free;
      mf.free;
    end;
  end; *)

  { Flo is assigned in event TEzGis.OnBeforePaintLayer }
  if Flo=nil then exit;

  { the visibility filter }
  if Flo.VisibleFilterActive and Assigned(Flo.VisibleFilterExpr) and
     (Flo.VisibleFilterExpr.Expression.ExprType = ttBoolean) then
  begin
    Layer.Recno:= Recno;
    Layer.Synchronize;
    CanShow:= Flo.VisibleFilterExpr.Expression.AsBoolean;
    if not CanShow then exit;
  end;

  { the override for the pen for opened entities }
  if Flo.OverridePen and (Entity is TEzOpenedEntity) then
  begin
    if Flo.OverridePen_Style and Flo.OverridePen_Color and Flo.OverridePen_Width then
      TEzOpenedEntity(Entity).Pentool.Assign(Flo.PenOverride)
    else
    begin
       if Flo.OverridePen_Style then
        TEzOpenedEntity(Entity).Pentool.Style := Flo.PenOverride.Style;
       if Flo.OverridePen_Color then
        TEzOpenedEntity(Entity).Pentool.color := Flo.PenOverride.color;
       if Flo.OverridePen_Width then
        TEzOpenedEntity(Entity).Pentool.Width := Flo.PenOverride.Width;
    end;
    if Flo.KeepSameLineWidth then
      TEzOpenedEntity(Entity).Pentool.Width:= Grapher.PointsToDistY(Flo.PenOverride.Width);
  end;

  { the override for the brush for closed entities }
  if Flo.OverrideBrush and (Entity is TEzClosedEntity) then
  begin
    if Flo.OverrideBrush_Pattern and Flo.OverrideBrush_ForeColor and Flo.OverrideBrush_BackColor then
      TEzClosedEntity(Entity).Brushtool.Assign(Flo.BrushOverride)
    else
    begin
      if Flo.OverrideBrush_Pattern then
        TEzClosedEntity(Entity).Brushtool.Pattern := Flo.BrushOverride.Pattern;
      If Flo.OverrideBrush_ForeColor then
        TEzClosedEntity(Entity).Brushtool.Forecolor := Flo.BrushOverride.Forecolor;
      If Flo.OverrideBrush_BackColor then
        TEzClosedEntity(Entity).Brushtool.Backcolor := Flo.BrushOverride.Backcolor;
    end;
  end;

  { the override for symbols }
  if Flo.OverrideSymbol and (Entity.EntityID = idPlace) then
  begin
    if Flo.OverrideSymbol_Index and Flo.OverrideSymbol_Rotangle and Flo.OverrideSymbol_Height then
      TEzPlace(Entity).Symboltool.Assign(Flo.SymbolOverride)
    else
    begin
      if Flo.OverrideSymbol_Index then
        TEzPlace(Entity).Symboltool.Index := Flo.SymbolOverride.index;
      //if Flo.OverrideSymbol_Rotangle then
      if Flo.OverrideSymbol_Height then
        TEzPlace(Entity).Symboltool.height := Flo.SymbolOverride.Height;
    end;
    if Flo.KeepSameSymbolSize then
      TEzPlace(Entity).Symboltool.Height:= Grapher.PointsToDistY(Flo.SymbolOverride.Height);
  end;

  { the zoom range for the text entities }
  if Entity.EntityID in [idTrueTypeText, idJustifVectText, idFittedVectText,
    idSplineText, idRtfText] then
  begin
    if Flo.ZoomRangeActive and(Flo.MaxZoomScaleForText > Flo.MinZoomScaleForText) then
    begin
      cs:= FCurrentScale;
      CanShow:= (cs >= Flo.MinZoomScaleForText) and (cs <= Flo.MaxZoomScaleForText);
    end;
    if CanShow And Flo.OverrideFont then
    begin
      Case Entity.EntityID of
        idTrueTypeText:
          begin
            if Flo.OverrideFont_Name {and Flo.OverrideFont_Angle} and Flo.OverrideFont_Height and
               Flo.OverrideFont_Color and Flo.OverrideFont_Style then
              TEzTrueTypeText(Entity).Fonttool.Assign(Flo.FontOverride)
            else
            begin
              if Flo.OverrideFont_Name then
                TEzTrueTypeText(Entity).Fonttool.Name := Flo.FontOverride.Name;
              //if Flo.OverrideFont_Angle then
              if Flo.OverrideFont_Height then
                TEzTrueTypeText(Entity).Fonttool.height := Flo.FontOverride.Height;
              if Flo.OverrideFont_Color then
                TEzTrueTypeText(Entity).Fonttool.Color := Flo.FontOverride.Color;
              if Flo.OverrideFont_Style then
                TEzTrueTypeText(Entity).Fonttool.Style := Flo.FontOverride.Style;
            end;
            if Flo.KeepSameFontSize then
            begin
              TEzTrueTypeText(Entity).Fonttool.Height:=
                Grapher.PointsToDistY(Flo.FontOverride.Height);
            end;
          end;
        idJustifVectText:
          begin
            TEzJustifVectorText(Entity).Fontcolor:=Flo.FontOverride.Color;
            if Flo.KeepSameFontSize then
              TEzJustifVectorText(Entity).Height:=
                Grapher.PointsToDistY(Flo.FontOverride.Height)
            else
              TEzJustifVectorText(Entity).Height:= Flo.FontOverride.Height;
          end;
        idFittedVectText:
          begin
            TEzFittedVectorText(Entity).Fontcolor:=Flo.FontOverride.Color;
            if Flo.KeepSameFontSize then
              TEzFittedVectorText(Entity).Height:=
                Grapher.PointsToDistY(Flo.FontOverride.Height)
            else
              TEzFittedVectorText(Entity).Height:= Flo.FontOverride.Height;
          end;
      end;
    end;
  end;

  { the labeling for entities }
  If Assigned(Flo) then
  begin
    AutoFree:= True;
    EntList := Flo.CreateLabelEntities(Layer, Recno, Entity, grapher, Clip );
  end;

end;

procedure TForm1.GIS1BeforePaintLayer(Sender: TObject;
  Layer: TEzBaseLayer; Grapher: TEzGrapher; var CanShow,
  WasFiltered: Boolean; var EntList: TEzEntityList; var AutoFree: Boolean);
var
  cs:Double;
  I: Integer;
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
  Flo:= FLayersOptions.LayerByName(Layer.Name);
  if Assigned(Flo) and Flo.ZoomRangeActive and (Flo.MaxZoomScale > Flo.MinZoomScale) then
  begin
    cs:= TEzDrawBox(DrawBox).CurrentScale;
    CanShow:= (cs >= Flo.MinZoomScale) and (cs <= Flo.MaxZoomScale);
  end;
  FCurrentScale:= TEzDrawBox(DrawBox).CurrentScale;

  For I:= 0 to FThematicList.Count-1 do
  begin
    If AnsiCompareText( TEzThematicBuilder( FThematicList[I] ).LayerName, Layer.Name) = 0 then
    begin
      TEzThematicBuilder( FThematicList[I] ).Prepare( Layer );
    end;
  end;

  { for labeling entities }
  If Assigned(Flo) then
    Flo.StartLabeling(Layer, Grapher);
end;

procedure TForm1.GIS1AfterPaintLayer(Sender: TObject;
  Layer: TEzBaseLayer; Grapher: TEzGrapher; var EntList: TEzEntityList;
  var AutoFree: Boolean);
var
  I: Integer;
begin
  For I:= 0 to FThematicList.Count-1 do
  begin
    If AnsiCompareText( TEzThematicBuilder( FThematicList[I] ).LayerName, Layer.Name) = 0 then
    begin
      TEzThematicBuilder( FThematicList[I] ).UnPrepare( Layer );
    end;
  end;

  { for labeling }
  If Assigned(Flo) then
    Flo.EndLabeling(Layer);
end;

procedure TForm1.Action11Execute(Sender: TObject);
begin
  with TfrmPreloaded.create(Nil) do
    try
      ShowModal;
    finally
      Free;
    end;
end;

procedure TForm1.actZoomWinExecute(Sender: TObject);
begin
  CmdLine1.Clear;
  CmdLine1.DoCommand('ZOOMWIN','');
end;

procedure TForm1.actSketchExecute(Sender: TObject);
begin
  CmdLine1.Clear;
  CmdLine1.DoCommand( 'SKETCH', '' );
end;

procedure TForm1.CustomizeActionBars2Execute(Sender: TObject);
begin
  CustomizeDlg1.Show;
end;

procedure TForm1.actMoveUpdate(Sender: TObject);
begin
  If CmdLine1.ActiveDrawBox = Nil then Exit;
  (Sender as TAction).Enabled:= GIS1.Active and (CmdLine1.ActiveDrawBox.Selection.Count > 0);
end;

procedure TForm1.Action6Update(Sender: TObject);
begin
  (Sender as TAction).Enabled:= GIS1.Active;
end;

procedure TForm1.EditPaste1Update(Sender: TObject);
begin
  EditPaste1.Enabled:= GIS1.Active and DrawBox.Undo.CanPaste;
end;

procedure TForm1.HelpContents1Update(Sender: TObject);
begin
  (Sender as TAction).Enabled:=true;
end;

procedure TForm1.Action13Execute(Sender: TObject);
begin
  CmdLine1.DoCommand('CIRCLE2P','');
end;

procedure TForm1.Action14Execute(Sender: TObject);
{$IFDEF ER_MAPPER}
var
  Alg : PEzERInfo;
{$ENDIF}
begin
{$IFDEF ER_MAPPER}
  with TOpenDialog.Create(Nil) do
    try
      DefaultExt := 'ALG';
      Filter := 'ER Mapper Algorithm Files (*.alg)|*.alg|'+
        'ER Mapper Dataset Files (*.ers)|*.ers' ;
      Options := [ofPathMustExist, ofFileMustExist];
      Title := 'Define Algorithm File';
      If not Execute then Exit;
      Self.FERMapperFileName:= FileName;
      { get the image dimensions }
      If Not ERMapperDllLoaded Then
        LoadERMapperDll;
      Alg := getEzERInfo(PChar(FileName));
      if Alg = Nil Then
      begin
        ShowMessage( StrPas(getERS_error_text() ));
        Exit;   // Cannot load algorithm
      end;
      ERMapperLauncher.TrackRectangle('ER MAPPER', Alg^.nr_columns, Alg^.nr_rows );
      FreeEzERInfo( Alg );
    finally
      free;
    end;
{$ENDIF}
end;

function ConvertToLocal(const Pt: TEzPoint): TEzPoint;
const
   var_48 = 0.9999847;
   var_50 = 0.0024039;
   var_58 = 5725278.885;
   const1 = 2.0626480625e5;
   const2 = 500000.0;
   const3 = 1.0;
   const4 = 0.25;
   const5 = 3.333333e-1;
   const6 = 0.166667;
   const7 = 0.5;
   const22 = 4e-3;
   cnt1 = 22.0;
   cnt2 = 2350.0;
   cnt3 = 293622.0;
   cnt4 = 1.0e-10;
   cnt5 = 5.0221746e7;
   cnt6 = 108.973;
   cnt7 = 0.612;
   cnt8 = 2.1562267e4;
   cnt9 = 0.001123;
   cnt10 = 0.6716608738092;
   cnt11 = 1.08973e2;
   cnt12 = 6.399698902e6;
   cnt13 = 3.2140404e4;
   cnt14 = 12900.571;
   cnt15 = 5200000.0;
   cnt16 = 250000;
   cnt17 = 1.123e-3;
   cnt18 = 3.98e-3;
   cnt19 = 7.0e6;
   cnt20 = 0.68067840828;
   cnt21 = 3.369e-3;

    V30 = 1.000009499999999 ;
    V38 = -2.4042e-3; // -0.0024042    -2.4042e-3
    V40 = -5.724097206e6;
    V50 = -5.28076231e5;
    Cosn2 = 2.15622669e4;
    Cosn3 = 6.3675584969e6;
var
  edi, esi1 : Extended;
  st0, st1, st2 : Extended;
  V10, V8, v18, V20, V28, V47C, V68, V70, V78, V80 : Extended;
  Var_A0, Var_98, Var_90 : Extended;
  Var_B8, var_B0, var_A8 : Extended;
  Arg_0_3, Arg_8_3, Arg_10_3, Var_18_3, Var_20_3, Var_28_3, Var_30_3, Var_38_3, Var_40_3, VAr_48_3 :extended;
  Var_8_3, Var_10_3, Var_54_3, ebx3, edi3 : Extended;
  V_8, V_10, V_18, V_20, V_28, v_30, V_38, V_40, V_48, V_50, V_58, V_64 : Extended;
  Var_8 : Extended;
  _X, _Y: Extended;
begin
  Result := Pt;
  _X := Pt.y;
  _Y := Pt.x;
  V8 := _X + cnt15;
  V10 := _Y - 1000000.0;
  V8 :=  V8 + cnt14;
  V10 := V10 - cnt16;


   V_38 := V8 / Cosn3;
   V_48 := Sqr (Cos (V_38));
     st0 := (((((cnt1 * V_48) + cnt2) * V_48) + cnt3) * V_48) +  cnt5;
   V_64 := (st0 * cnt4) * sin(V_38);
   V_30 := (Cos (V_38) * V_64) + V_38;
   V_40 := Sqr (Cos(V_30));
   V_28 :=  cnt12 - ((Cosn2 - ((cnt11 - (cnt7 * V_40)) * V_40)) * V_40);

{if Assigned(Prog) then
 Prog('V_28', V_28); }

   V_8 := Cos (V_30) * (((V_40 *  cnt21) + const7) * Sin (V_30));
   V_10 :=  const5 - (const6 - (cnt17 * V_40)) * V_40;
   V_18 := ((1.6161e-1 + (5.6198e-3 * V_40)) * V_40) + const4;
   V_20 :=  2.0e-1 -  ((const6 - (8.79e-3 * V_40)) * V_40);
   V_50 := V10 / (Cos (V_30) * V_28);
     St0 := const3 - ((V_18 - (1.2e-1 * Sqr (V_50))) * Sqr (V_50));
     St0 :=  (St0 * Sqr (V_50)) * V_8;
   V20 := (((const3 - ((V_10 - (V_20 * Sqr (V_50))) * Sqr (V_50))) * V_50) + cnt10) *  const1;
   Var_10_3 := ((V_30 - St0) * const1) / const1;
   VAr_48_3 := Sqr (Cos (Var_10_3));
   Var_40_3 :=  cnt12 - ((Cosn2 - ((cnt6 - (cnt7 * var_48_3)) * var_48_3)) * var_48_3);
   Var_18_3 :=   cnt13 - ((1.35330199e2 - ((0.7092 - (cnt18 * Var_48_3)) * Var_48_3)) * Var_48_3);
   Var_28_3 :=   (((2.52e-3 * VAr_48_3) + const4) * VAr_48_3) -  4.1659e-2;
   Var_38_3 := ((1.66e-1 * Var_48_3) -  8.4e-2) * Var_48_3;
   Var_20_3 :=   ((const5 + (cnt17 * VAr_48_3)) * Var_48_3) -  const6;
   Var_30_3 := 8.29e-3 -   ((const6 - (((cnt18 * Var_48_3) +  1.968e-1) * Var_48_3)) * Var_48_3);
   Var_8_3 := (V20 - 140400.000002433) /  const1;
   Var_54_3 := (Var_18_3 - ((((((Var_38_3 * Sqr(Var_8_3)) + Var_28_3) * Sqr(Var_8_3)) + const7) * Sqr(Var_8_3)) * Var_40_3)) * Sin (Var_10_3);
   ebx3 := Var_54_3 * (Cos(Var_10_3));
   ebx3 := (Cosn3 * Var_10_3) - ebx3;
     St0 := (((((Var_30_3 * Sqr(VAr_8_3)) + Var_20_3) * SQr (Var_8_3)) + const3) * Var_8_3) * Var_40_3;
   edi3 := ((St0 * (Cos(Var_10_3))) + const2) +  cnt19;
  V80 := edi3 - cnt19;
  V68 := (V80 * V38) + (ebx3 * V30) + V40;
  V70 := (((V80 * V30) + (ebx3 * abs(V38))) * const3) + V50;
  V68 := 0.425 + V68;  //X   оригинальный коэф был 0.389
  V70 := V70 - 0.080;  //Y  оригинальный коэф был 0.189
  Result.y := V68;
  Result.x := V70;
end;

procedure TForm1.Action15Execute(Sender: TObject);
var
  Layer1, Layer2: TEzBaseLayer;
  Ent: TEzEntity;
  I, J: Integer;
begin
  Layer1 := GIS1.Layers.LayerByName('M2021YX');
  Layer2 := GIS1.Layers.LayerByName('M2021YX_LOCAL');
  Layer2.First;
  while not Layer2.Eof do
  begin
    Layer2.DeleteEntity(Layer2.Recno);
    Layer2.Next;
  end;
  Layer2.Pack(False);
  Layer2.DBTable.Pack;
  //
  Layer1.First;
  while not Layer1.Eof do
  begin
    if not Layer1.RecIsDeleted then
    begin
      Ent := Layer1.RecLoadEntity();
      for I := 0 to Ent.Points.Count - 1 do
      begin
        Ent.Points[I] := ConvertToLocal(Ent.Points[I]);
      end;
      Layer2.AddEntity(Ent);
//      Layer2.DBTable.Edit;
//      for J := 1 to Layer1.DBTable.FieldCount do
//      begin
//        Layer2.DBTable.FieldPutN(J, Layer1.DBTable.FieldGetN(J));
//      end;
//      Layer2.DBTable.Post;
    end;
    Layer1.Next;
  end;
end;

procedure TForm1.Action15Update(Sender: TObject);
begin
  Action15.Enabled := True;
end;

procedure TForm1.ERMapperLauncherTrackedEntity(Sender: TObject;
  const TrackID: String; var TrackedEntity: TEzEntity);
{$IFDEF ER_MAPPER}
var
  Ent: TEzEntity;
  Layer: TEzBaseLayer;
{$ENDIF}
begin
{$IFDEF ER_MAPPER}
  Layer:= GIS1.CurrentLayer;
  If Layer = Nil then Exit;
  If AnsiCompareText(TrackID, 'ER MAPPER') = 0 then
  begin
    Ent:= TEzERMapper.CreateEntity( TrackedEntity.Points[0],
      TrackedEntity.Points[1], Self.FERMapperFileName );
    try
      // add to the current layer
      Layer.AddEntity( Ent );
      { repaint the image section only }
      DrawBox.RepaintRect( TrackedEntity.FBox );
    finally
      Ent.Free;
    end;
  end;
{$ENDIF}
end;

procedure TForm1.Action121Execute(Sender: TObject);
begin
  with TfrmBlocks.Create(Nil) do
    try
      showmodal;
    finally
      free;
    end;
end;

procedure TForm1.Action167Execute(Sender: TObject);
begin
  with TfrmAbout.create(Nil) do
    try
      showmodal;
    finally
      free;
    end;
end;

procedure TForm1.Action22Execute(Sender: TObject);
begin
  { check if contents of clipboard is valid }
  If Not IsClipboardContentValid Then Exit;
  //CmdLine1.DoCommand( Clipboard.AsText, '' );
  if FfrmClipboard=Nil then
  begin
    FfrmClipboard:= TfrmClipboard.Create(Nil);
    FfrmClipboard.Enter(False);
    DrawBox.SetFocus;
  end else
    FreeAndNil( FfrmClipboard );
end;

end.
