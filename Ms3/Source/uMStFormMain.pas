unit uMStFormMain;

interface

{$WARN UNSAFE_CODE OFF}
{$WARN UNSAFE_TYPE OFF}
{$WARN UNSAFE_CAST OFF}

{$I uMStFlags.pas}

uses
  // System
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs, Buttons, Contnrs, ComCtrls, ToolWin,
  ExtCtrls, StdCtrls, Menus, IniFiles, ActnList, OleCtrls, ImgList, DB, CheckLst, Grids, DBGrids,
  // Library
  EzCmdLine, EzBaseGIS, EzBasicCtrls, EzCtrls, EzEntities, EzDxfImport, EzBase, EzActions, EzActionLaunch,
  EzSystem, EzTable, EzLib,
  // VT
  VirtualTrees,
  // shared
  uGeoUtils, uGeoTypes, uCK36, uEzEntityCSConvert,
  // Project
  uMStKernelTypes, uMStKernelClasses, uMStKernelClassesSelection, uMStKernelInterfaces, uMStKernelStack,
  uMStKernelStackConsts, uMStKernelIBX, uMStConsts, uMStClassesMPIntf,
  uMStImport, uMstImportFactory, uMStClassesProjectsEz,
  uMStClassesWatermarkDraw, uMstClassesLots, uMStClassesProjects, uMStClassesProjectsSearch, uMStClassesProjectsMIFExport,
  uMstDialogFactory, uMStClassesProjectsMP, uMStClassesPointsImport,
  uMStModuleMapMngrIBX, uMStModuleProjectImport, uMstModuleMasterPlan, uMStDialogMPLineColors,
  uMStFormLayerBrowser, uMStClassesProjectsExportToMP;

const
  WM_RESTORE_PANELS = WM_USER + 100;

type
  TMstPoint = record
    Name: string[10];
    X: Double;
    Y: Double;
    Length: Double;
    Azimuth: Double;
  end;
  //размер 55 байт, максимальное число точек отвода - 144

  TMstPointArray = array of TMstPoint;

  TCursorState = (
    csNone,
    csArrow,
    csZoomIn,
    csZoomOut,
    csZoomRect,
    csZoomSelection,
    csZoomPrev,
    csReadyToDrag,
    csDraging,
    csProcessing,
    csLotInfo,
    csMapHistory,
    csShowLots,
    csLoadmap,
    csUnloadMap,
    csCalc,
    csCoord,
    csLoadLots,
    csPrintPrepare,
    csPrint,
    csLoadMP);

  TEntityState = (esNone, esResizePointFound, esResizing);

  TmstClientMainForm = class(TForm, ImstCoordView)
    MainMenu: TMainMenu;
    StatusBar: TStatusBar;
    ActionList: TActionList;
    miLayers: TMenuItem;
    miCityLine: TMenuItem;
    miRegions: TMenuItem;
    miStreets: TMenuItem;
    miMaps: TMenuItem;
    Preferences: TEzModifyPreferences;
    acZoomIn: TAction;
    pnMain: TPanel;
    acZoomOut: TAction;
    ImageList: TImageList;
    acZoomRect: TAction;
    acScroll: TAction;
    acSelect: TAction;
    PopupMenu: TPopupMenu;
    acCalc: TAction;
    N3: TMenuItem;
    miFind: TMenuItem;
    miLot: TMenuItem;
    miFindAdre: TMenuItem;
    acFindAddress: TAction;
    acAerial: TAction;
    N2: TMenuItem;
    miAerial: TMenuItem;
    acFindLotByAddress: TAction;
    acShowMapHistory: TAction;
    acAddMap: TAction;
    imMaps: TMenuItem;
    miAdd: TMenuItem;
    acDeleteMap: TAction;
    acZoomAll: TAction;
    miZoomAll: TMenuItem;
    N4: TMenuItem;
    acLotInfo: TAction;
    acZoomPrev: TAction;
    miZoomPrev: TMenuItem;
    acCoord: TAction;
    acSnapCenter: TAction;
    acSnapEnd: TAction;
    acSnapMiddle: TAction;
    acSnapNearestVertex: TAction;
    acSnapTangent: TAction;
    acSnapIntersect: TAction;
    acSnapPerendicular: TAction;
    acExit: TAction;
    N8: TMenuItem;
    N9: TMenuItem;
    N10: TMenuItem;
    N11: TMenuItem;
    N12: TMenuItem;
    N13: TMenuItem;
    N14: TMenuItem;
    N15: TMenuItem;
    N16: TMenuItem;
    N17: TMenuItem;
    pnRight: TPanel;
    ToolBar1: TToolBar;
    ToolButton1: TToolButton;
    ToolButton2: TToolButton;
    ToolButton4: TToolButton;
    ToolButton15: TToolButton;
    ToolButton11: TToolButton;
    ToolButton7: TToolButton;
    ToolButton5: TToolButton;
    ToolButton6: TToolButton;
    ToolButton8: TToolButton;
    tbLotsToTree: TToolButton;
    ToolButton22: TToolButton;
    tbMeasures: TToolButton;
    tbAerial: TToolButton;
    ToolButton21: TToolButton;
    tbExit: TToolButton;
    CmdLine: TEzCmdLine;
    acZoomSelect: TAction;
    ToolButton23: TToolButton;
    N18: TMenuItem;
    acGoToPoint: TAction;
    N19: TMenuItem;
    acSnaps: TAction;
    N20: TMenuItem;
    acMapByName: TAction;
    N21: TMenuItem;
    acLoadLots: TAction;
    tbLoadLots: TToolButton;
    N24: TMenuItem;
    pnLeft: TPanel;
    TreeView: TTreeView;
    pnCenter: TPanel;
    Splitter1: TSplitter;
    Splitter2: TSplitter;
    ListView: TListView;
    acChangeMap: TAction;
    N25: TMenuItem;
    N26: TMenuItem;
    N29: TMenuItem;
    N1: TMenuItem;
    N22: TMenuItem;
    N23: TMenuItem;
    pmCoords: TPopupMenu;
    acCopySelected: TAction;
    acCopyAll: TAction;
    acPastePoints: TAction;
    acPasteAndReplace: TAction;
    acDeletePoint: TAction;
    acInsertPoint: TAction;
    N27: TMenuItem;
    N28: TMenuItem;
    N30: TMenuItem;
    N31: TMenuItem;
    N32: TMenuItem;
    N33: TMenuItem;
    N34: TMenuItem;
    N35: TMenuItem;
    acEditPoint: TAction;
    N36: TMenuItem;
    N13001: TMenuItem;
    N37: TMenuItem;
    N38: TMenuItem;
    N39: TMenuItem;
    acLotVisible: TAction;
    acLotProperties: TAction;
    tbLotProperties: TToolButton;
    pmObjects: TPopupMenu;
    acAllMaps: TAction;
    acGivenMaps: TAction;
    acMapManager: TAction;
    acPrintPrepare: TAction;
    tbPrintPrepare: TToolButton;
    ToolButton27: TToolButton;
    acExportToDXF: TAction;
    SaveDialog1: TSaveDialog;
    DXF1: TMenuItem;
    acPrint: TAction;
    acCancelPrint: TAction;
    acSetScale: TAction;
    N5: TMenuItem;
    acExport2DXF: TAction;
    N6: TMenuItem;
    DXF2: TMenuItem;
    DrawBox: TEzDrawBox;
    LayersListBox: TCheckListBox;
    ObjectsImageList: TImageList;
    tbShowInvisibleLots: TToolButton;
    acShowInvisible: TAction;
    ActionLauncher: TEzActionLauncher;
    alReport: TActionList;
    acReportPrint: TAction;
    acReportCancel: TAction;
    acReportPrinterSetUp: TAction;
    acReportPageVisibility: TAction;
    acReportNumbersVisibility: TAction;
    acReportAddText: TAction;
    acReportDeleteText: TAction;
    acReportLotParams: TAction;
    acReportNextPage: TAction;
    acReportPrevPage: TAction;
    acReportSetScale: TAction;
    acReportPointSize: TAction;
    acReportFont: TAction;
    acReportMovePrintArea: TAction;
    acReportEditPrintArea: TAction;
    acReportMoveText: TAction;
    acReportRotateText: TAction;
    acReportEditText: TAction;
    tbReport: TToolBar;
    ToolButton28: TToolButton;
    tbPrintReport: TToolButton;
    tbCancelReport: TToolButton;
    tbPrinterSetUp: TToolButton;
    ToolButton30: TToolButton;
    ToolButton31: TToolButton;
    ToolButton32: TToolButton;
    ToolButton33: TToolButton;
    ToolButton38: TToolButton;
    ToolButton34: TToolButton;
    tbReportLines: TToolButton;
    tbPointSize: TToolButton;
    tbReportFont: TToolButton;
    tbReportMoveArea: TToolButton;
    ToolButton35: TToolButton;
    cbReportScale: TComboBox;
    ToolButton39: TToolButton;
    tbReportAddText: TToolButton;
    tbReportDeleteText: TToolButton;
    tbReportMoveText: TToolButton;
    tbReportRotateText: TToolButton;
    tbReportEditText: TToolButton;
    tbSnaps: TToolBar;
    ToolButton3: TToolButton;
    ToolButton10: TToolButton;
    ToolButton14: TToolButton;
    ToolButton16: TToolButton;
    ToolButton17: TToolButton;
    ToolButton18: TToolButton;
    ToolButton19: TToolButton;
    ToolButton20: TToolButton;
    tbReloadMaps: TToolButton;
    acReloadMaps: TAction;
    tbReportTableSettings: TToolButton;
    acReportTableSettings: TAction;
    ToolButton9: TToolButton;
    tbAccuDraw: TToolButton;
    acAccuDraw: TAction;
    ToolBar2: TToolBar;
    ToolButton13: TToolButton;
    acTreeClear: TAction;
    ToolButton24: TToolButton;
    acTreeLocate: TAction;
    ToolButton25: TToolButton;
    acReportPageSetup: TAction;
    acTreeRemoveCurrent: TAction;
    ToolButton26: TToolButton;
    ToolButton29: TToolButton;
    acTreeOnOfContour: TAction;
    ToolButton36: TToolButton;
    ToolBar3: TToolBar;
    ToolButton37: TToolButton;
    ToolButton40: TToolButton;
    ToolButton41: TToolButton;
    ToolButton42: TToolButton;
    ToolButton43: TToolButton;
    ToolButton44: TToolButton;
    ToolButton45: TToolButton;
    tbReportEditTable: TToolButton;
    acReportEditTable: TAction;
    acMapPrintStats: TAction;
    N7: TMenuItem;
    N42: TMenuItem;
    N43: TMenuItem;
    N44: TMenuItem;
    tbSearch: TToolBar;
    ToolButton12: TToolButton;
    ToolButton46: TToolButton;
    ToolButton47: TToolButton;
    ToolButton48: TToolButton;
    acFindNomenNet: TAction;
    ToolButton49: TToolButton;
    acReportContoursParams: TAction;
    Label1: TLabel;
    edtFastFindMap: TEdit;
    tbFastFindMap: TToolButton;
    Label2: TLabel;
    edtFastFindLot: TEdit;
    tbFastFindLot: TToolButton;
    N45: TMenuItem;
    acLayers: TAction;
    acLayers1: TMenuItem;
    acImportMidMif: TAction;
    MidMifDialog: TOpenDialog;
    N40: TMenuItem;
    N41: TMenuItem;
    acLayerBrowser: TAction;
    N46: TMenuItem;
    N47: TMenuItem;
    acProjectAdd: TAction;
    acProjectBrowse: TAction;
    acProjectFindByAddress: TAction;
    N48: TMenuItem;
    miDisplayCoordsInMCK36: TMenuItem;
    acProjectAdd2: TAction;
    N49: TMenuItem;
    N50: TMenuItem;
    miProjectNetTypes: TMenuItem;
    acProjectExport: TAction;
    midmif1: TMenuItem;
    SaveDialog2: TSaveDialog;
    vstLayers: TVirtualStringTree;
    Splitter3: TSplitter;
    N51: TMenuItem;
    N52: TMenuItem;
    DXF3: TMenuItem;
    XLS1: TMenuItem;
    N53: TMenuItem;
    N54: TMenuItem;
    acMPClassSettings: TAction;
    N55: TMenuItem;
    N56: TMenuItem;
    DXF4: TMenuItem;
    XLS2: TMenuItem;
    N57: TMenuItem;
    ToolButton50: TToolButton;
    ToolButton51: TToolButton;
    acSavePointList: TAction;
    Label3: TLabel;
    acMPPickupPoints: TAction;
    N58: TMenuItem;
    N59: TMenuItem;
    N60: TMenuItem;
    N61: TMenuItem;
    acMPExportMidMif: TAction;
    midmif2: TMenuItem;
    acMPLoadRect: TAction;
    N62: TMenuItem;
    N63: TMenuItem;
    acGenClassIDforMP: TAction;
    ID1: TMenuItem;
    N64: TMenuItem;
    acLotUnloadAll: TAction;
    acCopyProjectsToMP: TAction;
    N65: TMenuItem;
    acLocateCoordList: TAction;
    N66: TMenuItem;
    ToolButton52: TToolButton;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure FormResize(Sender: TObject);
    procedure acZoomInExecute(Sender: TObject);
    procedure acZoomOutExecute(Sender: TObject);
    procedure acZoomRectExecute(Sender: TObject);
    procedure acScrollExecute(Sender: TObject);
    procedure acSelectExecute(Sender: TObject);
    procedure DrawBoxMouseMove2D(Sender: TObject; Shift: TShiftState; X, Y: Integer; const WX, WY: Double);
    procedure acCalcExecute(Sender: TObject);
    procedure DrawBoxMouseDown2D(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer; const WX, WY: Double);
    procedure acFindAddressExecute(Sender: TObject);
    procedure acAerialExecute(Sender: TObject);
    procedure DrawBoxZoomChange(Sender: TObject; const Scale: Double);
    procedure acFindLotByAddressExecute(Sender: TObject);
    procedure acZoomAllExecute(Sender: TObject);
    procedure acLotInfoExecute(Sender: TObject);
    procedure acLotInfoUpdate(Sender: TObject);
    procedure acFindLotByAddressUpdate(Sender: TObject);
    procedure acShowMapHistoryUpdate(Sender: TObject);
    procedure acDeleteMapExecute(Sender: TObject);
    procedure acDeleteMapUpdate(Sender: TObject);
    procedure FormShortCut(var Msg: TWMKey; var Handled: Boolean);
    procedure acZoomPrevExecute(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure acSnapCenterExecute(Sender: TObject);
    procedure acSnapEndExecute(Sender: TObject);
    procedure acSnapIntersectExecute(Sender: TObject);
    procedure acSnapMiddleExecute(Sender: TObject);
    procedure acSnapPerendicularExecute(Sender: TObject);
    procedure acSnapTangentExecute(Sender: TObject);
    procedure acSnapNearestVertexExecute(Sender: TObject);
    procedure acExitExecute(Sender: TObject);
    procedure acZoomSelectExecute(Sender: TObject);
    procedure acZoomSelectUpdate(Sender: TObject);
    procedure acGoToPointExecute(Sender: TObject);
    procedure GISBeforeClose(Sender: TObject);
    procedure CmdLineAfterCommand(Sender: TObject; const Command, ActionID: string);
    procedure FormMouseWheel(Sender: TObject; Shift: TShiftState; WheelDelta: Integer; const aMousePos: TPoint; var Handled: Boolean);
    procedure acMapByNameExecute(Sender: TObject);
    procedure N1Click(Sender: TObject);
    procedure DrawBoxBeforeSelect(Sender: TObject; Layer: TEzBaseLayer; Recno: Integer; var CanSelect: Boolean);
    procedure TreeViewChange(Sender: TObject; Node: TTreeNode);
    procedure acLoadLotsExecute(Sender: TObject);
    procedure acCopySelectedExecute(Sender: TObject);
    procedure acCopyAllExecute(Sender: TObject);
    procedure acInsertPointExecute(Sender: TObject);
    procedure acInsertPointUpdate(Sender: TObject);
    procedure acDeletePointUpdate(Sender: TObject);
    procedure acCopySelectedUpdate(Sender: TObject);
    procedure acCopyAllUpdate(Sender: TObject);
    procedure acDeletePointExecute(Sender: TObject);
    procedure acEditPointUpdate(Sender: TObject);
    procedure acEditPointExecute(Sender: TObject);
    procedure acShowMapHistoryExecute(Sender: TObject);
    procedure Splitter1Moved(Sender: TObject);
    procedure acAllMapsExecute(Sender: TObject);
    procedure acAllMapsUpdate(Sender: TObject);
    procedure acGivenMapsExecute(Sender: TObject);
    procedure acGivenMapsUpdate(Sender: TObject);
    procedure acMapManagerExecute(Sender: TObject);
    procedure acMapManagerUpdate(Sender: TObject);
    procedure acPrintPrepareExecute(Sender: TObject);
    procedure acPrintPrepareUpdate(Sender: TObject);
    procedure acExportToDXFExecute(Sender: TObject);
    procedure acExportToDXFUpdate(Sender: TObject);
    procedure acZoomInUpdate(Sender: TObject);
    procedure acZoomOutUpdate(Sender: TObject);
    procedure acZoomRectUpdate(Sender: TObject);
    procedure acZoomAllUpdate(Sender: TObject);
    procedure acZoomPrevUpdate(Sender: TObject);
    procedure acPrintUpdate(Sender: TObject);
    procedure acCancelPrintUpdate(Sender: TObject);
    procedure acLoadLotsUpdate(Sender: TObject);
    procedure acCalcUpdate(Sender: TObject);
    procedure acCancelPrintExecute(Sender: TObject);
    procedure acSetScaleExecute(Sender: TObject);
    procedure acSetScaleUpdate(Sender: TObject);
    procedure acCoordUpdate(Sender: TObject);
    procedure acExport2DXFExecute(Sender: TObject);
    procedure acExport2DXFUpdate(Sender: TObject);
    procedure pmObjectsPopup(Sender: TObject);
    procedure DrawBoxBeforeInsert(Sender: TObject; Layer: TEzBaseLayer; Entity: TEzEntity; var Accept: Boolean);
    procedure acShowInvisibleExecute(Sender: TObject);
    procedure TreeViewMouseMove(Sender: TObject; Shift: TShiftState; X, Y: Integer);
    procedure DrawBoxAfterInsert(Sender: TObject; Layer: TEzBaseLayer; Recno: Integer);
    procedure tbCancelReportClick(Sender: TObject);
    procedure acReportPrintExecute(Sender: TObject);
    procedure acReportNumbersVisibilityExecute(Sender: TObject);
    procedure acReportCancelExecute(Sender: TObject);
    procedure acReportPrinterSetUpExecute(Sender: TObject);
    procedure acReportPointSizeExecute(Sender: TObject);
    procedure acReportLotParamsExecute(Sender: TObject);
    procedure acReportFontExecute(Sender: TObject);
    procedure acReportMovePrintAreaExecute(Sender: TObject);
    procedure acReportEditPrintAreaExecute(Sender: TObject);
    procedure DrawBoxAfterSelect(Sender: TObject; Layer: TEzBaseLayer; RecNo: Integer);
    procedure acReportPrevPageExecute(Sender: TObject);
    procedure acReportNextPageExecute(Sender: TObject);
    procedure cbReportScaleChange(Sender: TObject);
    procedure DrawBoxCustomClick(Sender: TObject; X, Y: Integer; const XWorld, YWorld: Double);
    procedure acReportPageVisibilityUpdate(Sender: TObject);
    procedure acReportMoveTextUpdate(Sender: TObject);
    procedure acReportMoveTextExecute(Sender: TObject);
    procedure acReportDeleteTextUpdate(Sender: TObject);
    procedure acReportDeleteTextExecute(Sender: TObject);
    procedure acReportAddTextExecute(Sender: TObject);
    procedure CmdLineActionChange(Sender: TObject);
    procedure acReportRotateTextUpdate(Sender: TObject);
    procedure acReportRotateTextExecute(Sender: TObject);
    procedure acReportPageVisibilityExecute(Sender: TObject);
    procedure acReportAddTextUpdate(Sender: TObject);
    procedure acReportEditTextUpdate(Sender: TObject);
    procedure acReportEditTextExecute(Sender: TObject);
    procedure acReloadMapsExecute(Sender: TObject);
    procedure acReportTableSettingsExecute(Sender: TObject);
    procedure acAccuDrawExecute(Sender: TObject);
    procedure TreeViewClick(Sender: TObject);
    procedure acReportPageSetupExecute(Sender: TObject);
    procedure acTreeOnOfContourUpdate(Sender: TObject);
    procedure acTreeOnOfContourExecute(Sender: TObject);
    procedure acTreeRemoveCurrentExecute(Sender: TObject);
    procedure acTreeLocateExecute(Sender: TObject);
    procedure acTreeClearExecute(Sender: TObject);
    procedure acLotPropertiesExecute(Sender: TObject);
    procedure TreeViewMouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure acReportEditTableExecute(Sender: TObject);
    procedure DrawBoxMouseUp2D(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer; const WX, WY: Double);
    procedure acMapPrintStatsUpdate(Sender: TObject);
    procedure N7Click(Sender: TObject);
    procedure acMapPrintStatsExecute(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure acReportPrintUpdate(Sender: TObject);
    procedure DrawBoxEndRepaint(Sender: TObject);
    procedure N44Click(Sender: TObject);
    procedure acFindNomenNetExecute(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure acReportLotParamsUpdate(Sender: TObject);
    procedure acReportPointSizeUpdate(Sender: TObject);
    procedure acReportTableSettingsUpdate(Sender: TObject);
    procedure acReportEditTableUpdate(Sender: TObject);
    procedure acReportContoursParamsExecute(Sender: TObject);
    procedure edtFastFindMapKeyPress(Sender: TObject; var Key: Char);
    procedure tbFastFindMapClick(Sender: TObject);
    procedure tbFastFindLotClick(Sender: TObject);
    procedure edtFastFindLotKeyPress(Sender: TObject; var Key: Char);
    procedure edtFastFindMapEnter(Sender: TObject);
    procedure edtFastFindLotEnter(Sender: TObject);
    procedure acLayersUpdate(Sender: TObject);
    procedure acImportMidMifExecute(Sender: TObject);
    procedure acLayersExecute(Sender: TObject);
    procedure acLayerBrowserUpdate(Sender: TObject);
    procedure acLayerBrowserExecute(Sender: TObject);
    procedure acProjectBrowseExecute(Sender: TObject);
    procedure acProjectFindByAddressExecute(Sender: TObject);
    procedure miDisplayCoordsInMCK36Click(Sender: TObject);
    procedure acProjectAdd2Execute(Sender: TObject);
    procedure acProjectExportUpdate(Sender: TObject);
    procedure acProjectExportExecute(Sender: TObject);
    procedure DXF3Click(Sender: TObject);
    procedure N53Click(Sender: TObject);
    procedure XLS1Click(Sender: TObject);
    procedure acMPClassSettingsExecute(Sender: TObject);
    procedure DXF4Click(Sender: TObject);
    procedure N57Click(Sender: TObject);
    procedure acSavePointListUpdate(Sender: TObject);
    procedure acMPPickupPointsExecute(Sender: TObject);
    procedure acMPPickupPointsUpdate(Sender: TObject);
    procedure acSavePointListExecute(Sender: TObject);
    procedure acMPExportMidMifUpdate(Sender: TObject);
    procedure acMPExportMidMifExecute(Sender: TObject);
    procedure acMPLoadRectUpdate(Sender: TObject);
    procedure acMPLoadRectExecute(Sender: TObject);
    procedure XLS2Click(Sender: TObject);
    procedure acGenClassIDforMPExecute(Sender: TObject);
    procedure acGenClassIDforMPUpdate(Sender: TObject);
    procedure acLotUnloadAllExecute(Sender: TObject);
    procedure acLotUnloadAllUpdate(Sender: TObject);
    procedure acCopyProjectsToMPExecute(Sender: TObject);
    procedure acCopyProjectsToMPUpdate(Sender: TObject);
    procedure acPastePointsUpdate(Sender: TObject);
    procedure acPastePointsExecute(Sender: TObject);
    procedure acLocateCoordListExecute(Sender: TObject);
  private
    FPoints: TMstPointArray;
    FCursorState: TCursorState;
    FPrevCurState: TCursorState;
    LastLayerName: string;
    WorldX, WorldY: Double;
    FLogged: Boolean;
    FGIS: TEzBaseGIS;
    FLastSearchNomenclature: string;
    FLastSearchCellNomenclature: string;
    FLastSearchStreet: string;
    FLastSearchBuilding: string;
    FLastHintNode: TTreeNode;
    FSelector: TmstGUISelector;
    FCanSelect: Boolean;
    FDragText: Boolean;
    FWatermark: TWatermark;
    FImport: TmstProjectImportModule;
    FRestored: Boolean;
    // X и Y - координаты на карте
    procedure PreparePopupMenuItems(const X, Y: Double; AMenu: TMenu);
    procedure LoadImage(Sender: TObject);
    procedure ReleaseImage(Sender: TObject);
    procedure LoadLotsClick(Sender: TObject); overload;
    procedure LoadLots(const ALeft, ATop, ARight, ABottom: Double); overload;
    procedure LoadProjects(const ALeft, ATop, ARight, ABottom: Double);
    procedure LoadProjectsClick(Sender: TObject);
    procedure LoadMPObjects(const aGeoLeft, aGeoTop, aGeoRight, aGeoBottom: Double);
    procedure LoadMPClick(Sender: TObject);
    procedure SetCursorState(const Value: TCursorState);
    procedure ShowCoord(Vector: TEzVector);
    function CalcAzimuth(P1X, P1Y, P2X, P2Y: Double): Extended;
    procedure CopyPoints(all: Boolean);
    procedure WMHotKey(var Msg: TWMHotKey); message WM_HOTKEY;
    procedure SetGIS(const Value: TEzBaseGIS);
    procedure PrepareToPrint;
    procedure PrepareSelector;
    procedure DeleteSelection;
    procedure DebugMessage(const OwnerName, MethodName: string);
    procedure CheckSnapsSettings;
    function GetPrintPermission(Maps: TStringList; Order: IOrder): TmstPrintPermission;
    procedure ShowWatermarkLayer(const Value: Boolean);
    function SelectOrder(Maps: TStringList): IOrder;
    procedure UpdateButtonSize(Big: Boolean);
    procedure LoadLotInfoToTree(const Wx, Wy: Double);
    procedure FastFindMap();
    procedure FastFindLot();
    function FindLot(const Address: string): Boolean;
    function FindProject(const Address: string): Boolean;
    procedure LocateProjectLine(const ClickPoint: TEzPoint);
    procedure LocateMPLine(const ClickPoint: TEzPoint);
    function GetProjectToExport(Sender: TObject; const ProjectId: Integer): TmstProject;
    procedure LoadSessionOptions();
    procedure RestorePanelsWidth();
    procedure GetProjectImportLayer(Sender: TObject; out Layer: TEzBaseLayer);
    procedure DoProjectImportExecuted(Sender: TObject; Cancelled: Boolean; aProject: TmstProject);
    function DoCreateProject(): TmstProject;
    function DoCreateProjReader(): IEzProjectReader;
    //
    procedure CloseProjectsBrowser();
    procedure CloseMPBrowser();
    procedure DisplayMPClassSettings();
    //
    procedure LoadPointsFromText(const Txt: string);
    function ReadPointsFromText(const aText: string): TmstImportedPointList;
  private
    procedure WmRestorePanels(var Message: TMessage); message WM_RESTORE_PANELS;
    procedure WMPaint(var Msg: TWMPaint); message WM_PAINT;
  private
    FNetTypesUpdate: Boolean;
    procedure NetTypeMenuClick(Sender: TObject);
  private
    FdWX, FdWY: Double;
    procedure DoDrawBoxPopup(const X, Y: Integer; const WX, WY: Double);
    procedure DoLocateEntityInLayerBrowser(const WX, WY: Double);
    procedure DoSwitchScrollCommand();
    procedure DoRunAutoScroll(Shift: TShiftState; const X, Y: Integer; const WX, WY: Double);
  private
    //ImstCoordView
    procedure CoordSystemChanged(const Value: TCoordSystem);
  private
    FLastDisplayedPoint: TEzPoint;
    procedure DisplayLastCoordinates(WX, WY: Double);
    procedure SavePointListToMPObject();
    function SavePointsToMPObject(): TmstMPObject;
  public
    property CursorState: TCursorState read FCursorState write SetCursorState;
    property Logged: Boolean read FLogged write FLogged;
    property GIS: TEzBaseGIS read FGIS write SetGIS;
    //
    procedure LoadNetTypes();
    procedure LoadWatermark(aMapMngr: TMStIBXMapMngr);
  end;

var
  mstClientMainForm: TmstClientMainForm;

implementation

{$R MS3CUR.RES}
{$R *.DFM}

uses
  JPEG, Variants, Types, Math, Clipbrd,
  // EzGIS
  EzMiscelEntities,
  // Common
  uCommonUtils, uGC, uVCLUtils,
  // Project
  uMStModuleApp, uMStKernelGISUtils, uMStKernelConsts, uMStKernelClassesSearch, uMStClassesProjectsUtils,
  uMStDialogAddress, uMStDialogNomenclature, uMStDialogPoint, uMStDialogScale,
  uMStModulePrint, uMStDialogPointSize, uMStFormMapImages, uMStGISEzActions,
  uMStFormRichTextEditor, uMStFormPrintStats, uMStFormLoadLotProgress,
  uMstFormOrderList, uMStFormProjectBrowser, uMStFormMPBrowser, uMStFormMPClassSettings;

procedure TmstClientMainForm.acAerialExecute(Sender: TObject);
begin
  //ShowAerial(DrawBox, CmdLine, 'CITYLINE');
end;

procedure TmstClientMainForm.acCalcExecute(Sender: TObject);
var
  Act: TmstMeasureAction;
begin
  if CursorState = csCalc then
  begin
    CursorState := csNone;
    CmdLine.Clear;
  end
  else
  begin
    CursorState := csCalc;
    Act := TmstMeasureAction.CreateAction(CmdLine);
    Act.OnPointListChange := ShowCoord;
    CmdLine.Push(Act, True, 'CALC', '');
  end;
end;

procedure TmstClientMainForm.acDeleteMapExecute(Sender: TObject);
begin
  ;
end;

procedure TmstClientMainForm.acDeleteMapUpdate(Sender: TObject);
begin
{  try
    b := GIS.Active;
    if b then b := GIS.Layers.LayerByName('M500').LayerInfo.Visible and
      (GIS.Layers.LayerByName('M500').RecordCount > 0);
    acDeleteMap.Enabled := b and (mstMapMngr.Administrator or (mstMapMngr.UserRole = 'GIS'));
  except
    DebugMessage(Self.Handle, Self.Name, 'acDeleteMapUpdate');
  end;              }
end;

procedure TmstClientMainForm.acExitExecute(Sender: TObject);
begin
  Close;
end;

procedure TmstClientMainForm.acFindAddressExecute(Sender: TObject);
var
  Street, Building: string;
begin
  if ShowAddress(Street, Building) then
  begin
    mstClientAppModule.Finder.DoFind(TmstAddressSearchData.Create(Street, Building));
  end;
end;

procedure TmstClientMainForm.acFindLotByAddressExecute(Sender: TObject);
begin
  if ShowAddress(FLastSearchStreet, FLastSearchBuilding) then
    if not FindLot(FLastSearchStreet + ' ' + FLastSearchBuilding) then
      MessageBox(Handle, PChar('По вашему запросу ничего не найдено!'), PChar('Поиск'), MB_OK + MB_ICONWARNING);
end;

procedure TmstClientMainForm.acFindLotByAddressUpdate(Sender: TObject);
begin
  acFindLotByAddress.Enabled := GIS.Active;
end;

procedure TmstClientMainForm.acFindNomenNetExecute(Sender: TObject);
var
  X, Y: Integer;
begin
  if TmstNomenclatureForm.ShowNomenclature(FLastSearchCellNomenclature) then
  begin
    TGeoUtils.MapTopLeft(FLastSearchCellNomenclature, gs500, Y, X);
    DrawBox.SetViewTo(X + 300, Y + 50, X - 50, Y - 300);
  end;
end;

procedure TmstClientMainForm.acGoToPointExecute(Sender: TObject);
var
  P: TEzPoint;
  x1, x2, y1, y2: Double;
  b: Boolean;
  Tmp: Double;
begin
  if TmstPointForm.ShowTargetPoint(P, b) then
  begin
    if mstClientAppModule.ViewCoordSystem = csMCK36 then
    begin
      if TGeoUtils.IsMCK36(P.x, P.y) then
        ToVRN(P.x, P.y, False);
//      ToCK36(P.x, P.y, False);
    end;
    //
    Tmp := P.y;
    P.y := P.x;
    P.x := Tmp;
    //
    DrawBox.CurrentExtents(x1, y1, x2, y2);
    DrawBox.MoveWindow(P.x - (x2 - x1) / 2, P.y - (y2 - y1) / 2);
    if b then
      DrawBox.ZoomToScale(5, suInches);
  end;
end;

procedure TmstClientMainForm.acLayerBrowserExecute(Sender: TObject);
var
  B: Boolean;
  S: string;
  L: TmstLayer;
begin
  S := mstClientAppModule.GIS.CurrentLayerName;
  L := mstClientAppModule.Layers.GetByName(S, False);
  B := Assigned(L);
  if B then
    B := L.LayerType = ID_LT_IMPORTED;
  if B then
    B := mstClientAppModule.MapMngr.LayerHasSemantic(L);
  if not B then
    Exit;
  // если окно не открыто, то открываем и назначаем слой
  if MStLayerBrowserForm = nil then
    MStLayerBrowserForm := TMStLayerBrowserForm.Create(Self);
  // если окно открыто, то назначаем в него слой
  MStLayerBrowserForm.DrawBox := Self.DrawBox;
  MStLayerBrowserForm.Layer := L;
  if not MStLayerBrowserForm.Visible then
    MStLayerBrowserForm.Show;
end;

procedure TmstClientMainForm.acLayerBrowserUpdate(Sender: TObject);
var
  B: Boolean;
  S: string;
  L: TmstLayer;
begin
  S := mstClientAppModule.GIS.CurrentLayerName;
  L := mstClientAppModule.Layers.GetByName(S, False);
  B := Assigned(L);
  if B then
    B := L.LayerType = ID_LT_IMPORTED;
  if B then
    B := mstClientAppModule.MapMngr.LayerHasSemantic(L);
  acLayerBrowser.Enabled := B;
  // слой должен быть импортированным
  // для слоя должны быть объекты в таблице
end;

procedure TmstClientMainForm.acLayersExecute(Sender: TObject);
begin
  mstClientAppModule.DisplayLayersDialog;
end;

procedure TmstClientMainForm.acLayersUpdate(Sender: TObject);
begin
  acLayers.Visible := mstClientAppModule.User.IsAdministrator;
end;

procedure TmstClientMainForm.acLoadLotsExecute(Sender: TObject);
begin
  LastLayerName := GIS.CurrentLayerName;
  CursorState := csLoadLots;
  GIS.CurrentLayerName := 'MEASURES';
  CmdLine.DoCommand('RECTANGLE', '');
end;

procedure TmstClientMainForm.acLotInfoExecute(Sender: TObject);
begin
  CursorState := csLotInfo;
end;

procedure TmstClientMainForm.acLotInfoUpdate(Sender: TObject);
begin
  try
    if Assigned(GIS) then
      if GIS.Active then
        acLotInfo.Enabled := not (CursorState in [csCalc, csLoadLots, csZoomRect, csPrintPrepare])
      else
        acLotInfo.Enabled := False;
  except
    DebugMessage(Self.Name, 'acLotInfoUpdate');
  end;
end;

procedure TmstClientMainForm.acMapByNameExecute(Sender: TObject);
var
  Search: TmstSearchMapData;
  S: string;
  R: TEzRect;
  H, W: Double;
begin
  if TmstNomenclatureForm.ShowNomenclature(FLastSearchNomenclature) then
  try
    Search := TmstSearchMapData.Create(FLastSearchNomenclature);
    mstClientAppModule.Finder.DoFind(Search);
    if Search.Found then
    begin
      R := Search.MapRect;
      W := R.xmax - R.xmin;
      H := R.ymax - R.ymin;
      R.xmin := R.xmin - 0.05 * W;
      R.xmax := R.xmax + 0.05 * W;
      R.ymin := R.ymin - 0.05 * H;
      R.ymax := R.ymax + 0.05 * H;
      DrawBox.SetViewTo(R.xmin, R.ymin, R.xmax, R.ymax);
    end
    else
    begin
      S := 'Планшет %s не отсканирован!' + #13 + 'Обратитесь в отдел ГИС.';
      S := Format(S, [FLastSearchNomenclature]);
      MessageDlg(S, mtWarning, [mbOK], 0);
    end;
  finally
    FreeAndnil(Search);
  end;
end;

procedure TmstClientMainForm.acReportEditTableExecute(Sender: TObject);
begin
  mstPrintModule.DoEditTable;
  DrawBox.Invalidate;
end;

procedure TmstClientMainForm.acReportEditTableUpdate(Sender: TObject);
begin
  acReportEditTable.Enabled := mstPrintModule.HasLot;
end;

procedure TmstClientMainForm.acSavePointListExecute(Sender: TObject);
begin
  SavePointListToMPObject();
end;

procedure TmstClientMainForm.acSavePointListUpdate(Sender: TObject);
var
  B: Boolean;
begin
  B := CmdLine.CurrentAction is TmstMeasureAction;
  if B then
  begin
    B := CmdLine.CurrentActionID = 'PROJECT_LINE';
    if B then
      B := ListView.Items.Count > 1;
  end;
  acSavePointList.Enabled := B;
end;

procedure TmstClientMainForm.acScrollExecute(Sender: TObject);  // +
begin
  CursorState := csReadyToDrag;
  CmdLine.Clear;
  CmdLine.DoCommand('SCROLL', '');
end;

procedure TmstClientMainForm.acSelectExecute(Sender: TObject); // +
begin
  CursorState := csArrow;
  CmdLine.Clear;
  DrawBox.Cursor := crDefault;
end;

procedure TmstClientMainForm.acShowMapHistoryUpdate(Sender: TObject);
begin
  try
    if GIS.Active then
      acShowMapHistory.Enabled := GIS.Layers.LayerByName('M500').LayerInfo.Visible and (GIS.Layers.LayerByName('M500').RecordCount > 0);
  except
    DebugMessage(Self.Name, 'acShowMapHistoryUpdate');
  end;
end;

procedure TmstClientMainForm.acSnapCenterExecute(Sender: TObject);
begin
  CheckSnapsSettings;
end;

procedure TmstClientMainForm.acSnapEndExecute(Sender: TObject);
begin
  CheckSnapsSettings;
end;

procedure TmstClientMainForm.acSnapIntersectExecute(Sender: TObject);
begin
  CheckSnapsSettings;
end;

procedure TmstClientMainForm.acSnapMiddleExecute(Sender: TObject);
begin
  CheckSnapsSettings;
end;

procedure TmstClientMainForm.acSnapNearestVertexExecute(Sender: TObject);
begin
  CheckSnapsSettings;
end;

procedure TmstClientMainForm.acSnapPerendicularExecute(Sender: TObject);
begin
  CheckSnapsSettings;
end;

procedure TmstClientMainForm.acSnapTangentExecute(Sender: TObject);
begin
  CheckSnapsSettings;
end;

procedure TmstClientMainForm.acZoomAllExecute(Sender: TObject);
var
  Xmin, Ymin, Xmax, Ymax: Double;
begin
  GIS.CurrentLayer.MaxMinExtents(Xmin, Ymin, Xmax, Ymax);
  DrawBox.SetViewTo(Xmin, Ymin, Xmax, Ymax);
end;

procedure TmstClientMainForm.acZoomInExecute(Sender: TObject);  // +
begin
  CursorState := csZoomIn;
  CmdLine.Clear;
  CmdLine.DoCommand('ZOOMIN', '');
end;

procedure TmstClientMainForm.acZoomPrevExecute(Sender: TObject);
begin
  CursorState := csZoomPrev;
  DrawBox.ZoomPrevious;
  CursorState := FPrevCurState;
end;

procedure TmstClientMainForm.acZoomRectExecute(Sender: TObject); // +
begin
  CursorState := csZoomRect;
  CmdLine.Clear;
  CmdLine.DoCommand('ZOOMWIN', '');
end;

procedure TmstClientMainForm.acZoomSelectExecute(Sender: TObject);
begin
  CursorState := csZoomSelection;
  DrawBox.ZoomToSelection;
end;

procedure TmstClientMainForm.acZoomSelectUpdate(Sender: TObject);
begin
  acZoomSelect.Enabled := False; {(DrawBox.Selection.Count > 0) and
    (CursorState <> csPrintPrepare);}
end;

procedure TmstClientMainForm.acZoomOutExecute(Sender: TObject);  // +
begin
  CursorState := csZoomOut;
  CmdLine.Clear;
  CmdLine.DoCommand('ZOOMOUT', '');
end;

function TmstClientMainForm.CalcAzimuth(P1X, P1Y, P2X, P2Y: Double): Extended;
begin
  if P2X = P1X then
    if P2Y >= P1Y then
      Result := Pi / 2
    else
      Result := -Pi / 2
  else
    Result := ArcTan((P2Y - P1Y) / (P2X - P1X));
  if P2X >= P1X then
  begin
    if P2Y < P1Y then
      Result := Result + 2 * Pi
  end
  else
    Result := Result + Pi;
end;

procedure TmstClientMainForm.CmdLineAfterCommand(Sender: TObject; const Command, ActionID: string);
var
  Layer: TEzBaseLayer;
begin
  try
    if (Command = 'ZOOMWIN') or (Command = 'ZOOMIN') or (Command = 'ZOOMOUT') then
    begin
      if FPrevCurState = csCalc then
      begin
        CursorState := csCalc;
        DrawBox.Cursor := crMeasure;
      end
      else
      begin
        if Command = 'ZOOMWIN' then
          CursorState := csNone;
      end;
    end
    else
    if (Command = 'CALC') then
    begin
      if (ActionID = 'PROJECT_LINE') then
      begin
        if Sender is TEzAction then
          if not TEzAction(Sender).Cancelled then
          begin
            if CursorState = csCoord then
              SavePointListToMPObject();
          end;
        CursorState := csNone;
      end;
    end;
    //
    if ActionID = 'REPORT' then
    begin
      if Command = 'MOVE' then
        mstPrintModule.UpdatePrintArea
      else
      if Command = 'EDITTEXT' then
      begin
        Layer := Gis.Layers.LayerByName(SL_REPORT);
        Layer.Recno := DrawBox.Selection[0].SelList[0];
        Layer.UpdateEntity(Layer.Recno, Layer.RecEntity.Clone);
      end
      else if Command = 'RESHAPE' then
      begin
        Layer := Gis.Layers.LayerByName(SL_REPORT);
        Layer.Recno := mstPrintModule.PrintAreaId;
        mstPrintModule.PrintArea := Layer.RecExtension;
      end;
    end;
  except
    DebugMessage(Self.Name, 'CmdLineAfterCommand');
  end;
end;

procedure TmstClientMainForm.DrawBoxBeforeSelect(Sender: TObject; Layer: TEzBaseLayer; Recno: Integer; var CanSelect: Boolean);
begin
  if CursorState = csLoadLots then
    CursorState := csNone;
  CanSelect := FCanSelect;
end;

procedure TmstClientMainForm.DrawBoxMouseDown2D(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer; const WX, WY: Double);
begin
  if (Button = mbMiddle) then
  begin
    DoSwitchScrollCommand();
  end
  else
  if Button = mbLeft then
  begin
    FDragText := False;
    if ssCtrl in Shift then
    begin
      DoRunAutoScroll(Shift, X, Y, WX, WY);
    end
    else
    if (mstClientAppModule.Mode = amNone) and (CursorState in [csNone, csArrow]) then
    begin
      if Shift = [ssAlt] then
        LoadLotInfoToTree(WX, WY);
      DoLocateEntityInLayerBrowser(WX, WY);
      LocateProjectLine(Point2D(WX, WY));
      LocateMPLine(Point2D(WX, WY));
      //
//      if FPickPanel <> nil then
//        if FPickPanel.Visible then
//        begin
//          FPickPanel.AddPoint(WX, WY);
//        end;
    end;
  end;
end;

procedure TmstClientMainForm.DisplayLastCoordinates(WX, WY: Double);
begin
  FLastDisplayedPoint.x := WX;
  FLastDisplayedPoint.y := WY;
  if miDisplayCoordsInMCK36.Checked then
  begin
    uCK36.ToCK36(WY, WX);
  end;
  StatusBar.Panels[0].Text := 'X: ' + FloatToStrF(WY, ffFixed, 10, 2) + '; Y: ' + FloatToStrF(WX, ffFixed, 10, 2);
end;

procedure TmstClientMainForm.DrawBoxMouseMove2D(Sender: TObject; Shift: TShiftState; X, Y: Integer; const WX, WY: Double);   // +
begin
  try
    WorldX := WX;
    WorldY := WY;
    DisplayLastCoordinates(WX, WY);
    if ssLeft in Shift then
    begin
      if mstClientAppModule.Mode = amPrint then
      begin
        if DrawBox.Selection.NumSelected > 0 then
        begin
          if SelectionIsInIDSet(DrawBox, [idTrueTypeText, idAlignedTTText, idTable, idRtfText, idRtfText2, idAlignedText2]) then
          if not FDragText then
          begin
            FDragText := True;
            CmdLine.DoCommand('MOVE', '');
            CmdLine.CurrentAction.OnMouseDown(DrawBox, mbLeft, [], X, Y, WX, WY);
          end;
        end;
      end;
    end;
  except
    DebugMessage(Self.Name, 'DrawBoxMouseMove2D');
  end;
end;

procedure TmstClientMainForm.DrawBoxMouseUp2D(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer; const WX, WY: Double);
begin
  if FDragText then
  begin
    FDragText := False;
    CmdLine.CurrentAction.OnMouseDown(DrawBox, mbLeft, [], X, Y, WX, WY);
  end
  else
  if Button = mbRight then
  begin
    // возможно здесь надо сбросить какие-то параметры текущего состояния
    DoDrawBoxPopup(X, Y, WX, WY);
  end;
end;

procedure TmstClientMainForm.DrawBoxZoomChange(Sender: TObject; const Scale: Double);
begin
  if Gis = nil then
    Exit;
  if Gis.Layers.Count = 0 then
    Exit;
  StatusBar.Panels[2].Text := 'Масштаб 1 : ' + Format('%.2f', [Scale * 1000]);
end;

procedure TmstClientMainForm.DXF3Click(Sender: TObject);
begin
  mstClientAppModule.MP.ImportFile(srcDXF, mstProjected);
end;

procedure TmstClientMainForm.DXF4Click(Sender: TObject);
begin
  mstClientAppModule.MP.ImportFile(srcDXF, mstDrawn);
end;

procedure TmstClientMainForm.edtFastFindLotEnter(Sender: TObject);
begin
  edtFastFindLot.SelectAll;
end;

procedure TmstClientMainForm.edtFastFindLotKeyPress(Sender: TObject; var Key: Char);
begin
  if Key = #13 then
    FastFindLot();
end;

procedure TmstClientMainForm.edtFastFindMapEnter(Sender: TObject);
begin
  edtFastFindMap.SelectAll;
end;

procedure TmstClientMainForm.edtFastFindMapKeyPress(Sender: TObject; var Key: Char);
begin
  if Key = #13 then
  begin
    FastFindMap();
  end;
end;

procedure TmstClientMainForm.FastFindLot;
var
  S: string;
begin
  S := Trim(edtFastFindLot.Text);
  if S <> '' then
  begin
    FLastSearchStreet := S;
    if not FindLot(S) then
      MessageBox(Handle, PChar('По вашему запросу ничего не найдено!'), PChar('Поиск'), MB_OK + MB_ICONWARNING);
  end;
end;

procedure TmstClientMainForm.FastFindMap;
var
  X, Y: Integer;
  S: string;
  N: TNomenclature;
begin
  S := Trim(edtFastFindMap.Text);
  N.Init(S, False);
  if N.Valid then
  begin
    FLastSearchNomenclature := N.Nomenclature();
    TGeoUtils.MapTopLeft(S, gs500, Y, X);
    DrawBox.SetViewTo(X + 300, Y + 50, X - 50, Y - 300);
  end;
end;

function TmstClientMainForm.FindLot(const Address: string): Boolean;
var
  Search: TmstSearchData;
begin
  Search := TmstLotAddressSearchData.Create(Address);
  Search.Forget();
  mstClientAppModule.Finder.DoFind(Search);
  Result := Search.Found;
end;

function TmstClientMainForm.FindProject(const Address: string): Boolean;
var
  Search: TmstSearchData;
begin
  Search := TmstProjectAddressSearchData.Create(Address);
  Search.Forget();
  mstClientAppModule.Finder.DoFind(Search);
  Result := Search.Found;
end;

procedure TmstClientMainForm.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  CmdLine.Clear();
  //
  mstClientAppModule.Layers.LayerControl := nil;
  mstClientAppModule.LogUserAcion('Выход', '');
end;

procedure TmstClientMainForm.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
begin
  CanClose := Application.MessageBox(PChar('Закрыть приложение?'), PChar('Подтверждение'), MB_YESNO + MB_ICONQUESTION) = mrYes;
  if CanClose then
    Finalize(FPoints);
  mstClientAppModule.AppSettings.WriteFormPosition(Application, Self);
  mstClientAppModule.SetOption('MainForm', 'LeftPanelWidth', IntToStr(pnLeft.Width));
  mstClientAppModule.SetOption('MainForm', 'RightPanelWidth', IntToStr(pnRight.Width));
  mstClientAppModule.SetOption('Session', 'Map500Search', edtFastFindMap.Text);
  //
  mstClientAppModule.SaveLayersVisibility();
end;

procedure TmstClientMainForm.FormCreate(Sender: TObject);
begin
  FRestored := False;
  FSelector := TmstGUISelector.Create;
  mstClientAppModule.AppSettings.ReadFormPosition(Application, Self);
  CmdLine.AccuSnap.Enabled := False;
  Caption := Application.Title;
  //
  LoadSessionOptions();
end;

procedure TmstClientMainForm.FormDestroy(Sender: TObject); // +
begin
//  UnRegisterHotKey(Handle, id_SnapShot);
  FSelector.Free;
end;

procedure TmstClientMainForm.FormMouseWheel(Sender: TObject; Shift: TShiftState; WheelDelta: Integer; const aMousePos: TPoint; var Handled: Boolean);
var
  WPt: TEzPoint;
  Pt: TPoint;
begin
  if PointInRect(aMousePos, pnCenter.BoundsRect) then
  begin
    Pt := DrawBox.ScreenToClient(aMousePos);
    WPt := DrawBox.Grapher.PointToReal(Pt);
    DrawBox.ZoomOnPoint(WPt.X, WPt.Y, 0.9, WheelDelta > 0);
    Handled := True;
  end;
end;

procedure TmstClientMainForm.FormResize(Sender: TObject);   // +
begin
  if Visible and Assigned(GIS) and GIS.Active then
    GIS.RepaintViewports;
end;

procedure TmstClientMainForm.FormShortCut(var Msg: TWMKey; var Handled: Boolean);
begin
  case Msg.CharCode of
    VK_ESCAPE:
      if (FPrevCurState in [csNone, csPrintPrepare]) or (CursorState = csPrintPrepare) then
        CursorState := csNone;
  end;
end;

procedure TmstClientMainForm.FormShow(Sender: TObject);
var
  B: Boolean;
begin
  B := mstClientAppModule.AppSettings.ReadAppParam(Application, Self, 'MainFormBigButtons', varBoolean);
  N44.Checked := B;
  UpdateButtonSize(B);
  //
  mstClientAppModule.MP.SetDrawBox(Self.DrawBox);
end;

function TmstClientMainForm.GetPrintPermission(Maps: TStringList; Order: IOrder): TmstPrintPermission;
var
  ExtraMaps: TStrings;
//  Msg: string;
begin
  // TODO : TmstClientMainForm.GetPrintPermission - тестировать
  // DONE : TmstClientMainForm.GetPrintPermission - проверить откуда берётся список планшетов
  if mstClientAppModule.User.MapReportErrorMode = mreDeny then
    Result := ppDenied
  else
    Result := ppWaterMark;
  if Assigned(Order) then
  begin
    // сопоставляем номера планшетов с номером заказа
    ExtraMaps := Order.CompareMaps(Maps);
    try
      if ExtraMaps.Count > 0 then
      begin
        // если печатаемые планшеты не совпадают с номером заказа,
        // то показываем сообщение
//        if Result = ppDenied then
//          Msg := 'Печать запрещена!' + sLineBreak;
//        if Result = ppWaterMark then
//          Msg := 'Печать с пометками!' + sLineBreak;
//        Msg := Msg + 'В заказе не указаны планшеты:' + sLineBreak;
//        ShowMessage(Msg + ExtraMaps.Text);
      end
      else
      begin
        // если планшеты совпадают
        // то печатаем без водяных марок
        Result := ppFull;
      end;
    finally
      ExtraMaps.Free;
    end;
  end;
end;

procedure TmstClientMainForm.GetProjectImportLayer(Sender: TObject; out Layer: TEzBaseLayer);
var
  Fields: TStringList;
begin
  Fields := TStringList.Create;
  try
    Fields.Add('UID;N;11;0');
    Fields.Add('LAYER_ID;N;11;0');
    //
    Layer := DrawBox.GIS.Layers.LayerByName(SL_PROJECT_IMPORT);
    if Layer = nil then
      Layer := DrawBox.GIS.Layers.CreateNew(SL_PROJECT_IMPORT, Fields);
  finally
    Fields.Free;
  end;
end;

function TmstClientMainForm.GetProjectToExport(Sender: TObject; const ProjectId: Integer): TmstProject;
begin
  Result := mstClientAppModule.Projects.GetProject(ProjectId, True);
end;

procedure TmstClientMainForm.GISBeforeClose(Sender: TObject);
begin
  CmdLine.Clear;
end;

procedure TmstClientMainForm.LoadImage(Sender: TObject); // +
begin
  Screen.Cursor := crHourGlass;
  try
    if not MStClientAppModule.LoadMapImage(TMenuItem(Sender).Tag) then
    begin
      Application.MessageBox(
        PChar('Не удалось загрузить планшет!'),
        PChar('Ошибка'),
        MB_OK + MB_ICONSTOP);
    end;
    DrawBox.RegenDrawing;
  finally
    Screen.Cursor := crDefault;
  end;
end;

procedure TmstClientMainForm.LoadLotInfoToTree;
var
  Shift: TShiftState;
  KeyState: Windows.TKeyboardState;
  I: Integer;
  aNode: TmstTreeNode;
begin
  try
    GetKeyboardState(KeyState);
    Shift := KeyboardStateToShiftState(KeyState);
    if not (ssShift in Shift) then
      mstClientAppModule.Stack.Clear;
    mstClientAppModule.Stack.BeginUpdate;
    mstClientAppModule.FindLots(DrawBox, WX, WY);
    mstClientAppModule.FindProjects(DrawBox, WX, WY);
    mstClientAppModule.FindMPProjects(DrawBox, WX, WY);
  finally
    mstClientAppModule.Stack.EndUpdate;
    mstClientAppModule.Stack.UpdateView;
    for I := 0 to Pred(TreeView.Items.Count) do
    begin
      aNode := TmstTreeNode(TreeView.Items[I]);
      if aNode.NodeType in mstRootNodeTypes then
        aNode.Expanded := True
      else
      begin
        if aNode.DatabaseId = mstClientAppModule.Stack.SelectedLot.DatabaseId then
          aNode.Expanded := True
        else
          aNode.Expanded := False;
      end;
      if aNode.NodeType in mstLotNodeTypes then
      begin
        if (aNode.DatabaseId = mstClientAppModule.Stack.SelectedLot.DatabaseId) and (mstClientAppModule.Stack.SelectedLot.ContourId < 1) then
          aNode.Selected := True;
      end
      else if aNode.NodeType = ID_NODETYPE_LOT_CONTOUR then
      begin
        if TmstTreeNode(aNode.Parent).DatabaseId = mstClientAppModule.Stack.SelectedLot.DatabaseId then
          if mstClientAppModule.Stack.SelectedLot.ContourId = aNode.DatabaseId then
            aNode.Selected := True;
      end;
    end;
//          TreeView.FullExpand;
  end;
end;

procedure TmstClientMainForm.LoadLots(const ALeft, ATop, ARight, ABottom: Double);
var
  Frm: TmstLoadLotProgressForm;
begin
  Frm := TmstLoadLotProgressForm.Create(Self);
  Enabled := False;
  try
    Frm.Show;
    mstClientAppModule.LoadLots(ALeft, ATop, ARight, ABottom, Frm.OnProgress2);
  finally
    Enabled := True;
    Frm.Free;
  end;
end;

procedure TmstClientMainForm.LoadLotsClick(Sender: TObject);
var
  ALeft, ATop, ARight, ABottom: Double;
begin
  ALeft := FdWY - 100;
  ARight := FdWY + 100;
  ATop := FdWX + 100;
  ABottom := FdWX - 100;
  LoadLots(ALeft, ATop, ARight, ABottom);
  DrawBox.RegenDrawing;
end;

procedure TmstClientMainForm.LoadMPClick(Sender: TObject);
var
  I: Integer;
  TmpMap: TmstMap;
//  aTop, aLeft: Integer;
  N: TNomenclature;
  R: TRect;
  LayerMaps: TEzBaseLayer;
begin
  I := TMenuItem(Sender).Tag;
  LayerMaps := mstClientAppModule.LayerMaps;
  if Assigned(LayerMaps) then
  begin
    TmpMap := mstClientAppModule.Maps.GetByMapEntityId(I);
    if not Assigned(TmpMap) then
      Exit;
    N := TGeoUtils.GetNomenclature(TmpMap.MapName, False);
    if N.Valid then
    begin
      R := N.Bounds;
      LoadMPObjects(R.Left, R.Top, R.Right, R.Bottom);
      DrawBox.RegenDrawing;
    end;
//      if TGeoUtils.MapTopLeft(TmpMap.MapName, aTop, aLeft) then
//      begin
//        LoadMPObjects(aLeft, aTop, aLeft + 250, aTop - 250);
//      end;
  end;
end;

procedure TmstClientMainForm.LoadMPObjects(const aGeoLeft, aGeoTop, aGeoRight, aGeoBottom: Double);
//var
//  Frm: TmstLoadLotProgressForm;
begin
//  Frm := TmstLoadLotProgressForm.Create(Self);
//  Enabled := False;
  try
//    Frm.Show;
    mstClientAppModule.MP.LoadMPObjects(aGeoLeft, aGeoTop, aGeoRight, aGeoBottom);//, Frm.OnProgress2);
  finally
//    Enabled := True;
//    Frm.Free;
  end;
end;

procedure TmstClientMainForm.LoadNetTypes;
var
  I: Integer;
  Mi: TMenuItem;
begin
  Mi := TMenuItem.Create(miProjectNetTypes);
  miProjectNetTypes.Add(Mi);
  Mi.Caption := 'Включить все';
  Mi.Tag := -1;
  Mi.OnClick := NetTypeMenuClick;
  Mi := TMenuItem.Create(miProjectNetTypes);
  miProjectNetTypes.Add(Mi);
  Mi.Caption := '-';
  //
  for I := 0 to mstClientAppModule.NetTypes.Count - 1 do
  begin
    Mi := TMenuItem.Create(miProjectNetTypes);
    miProjectNetTypes.Add(Mi);
    //
    Mi.Caption := mstClientAppModule.NetTypes.Items[I].Name;
    Mi.Checked := True;
    Mi.AutoCheck := True;
    Mi.Tag := mstClientAppModule.NetTypes.Items[I].DatabaseId;
    Mi.OnClick := NetTypeMenuClick;
  end;
end;

procedure TmstClientMainForm.LoadPointsFromText(const Txt: string);
var
  Pts: TmstImportedPointList;
  I: Integer;
  J: Integer;
  XCol, YCol: TmstImportedPointsColumn;
  Pt: TEzPoint;
  Dlg: ImstImportPointsDialog;
  R: TEzRect;
  DisplayRect: Boolean;
begin
  Pts := ReadPointsFromText(Txt);
  if Assigned(Pts) then
  try
    Dlg := TmstDialogFactory.NewPointsImportDialog();
    if not Dlg.Execute(Pts) then
      Exit;
    //
    DisplayRect := Pts.ReplaceOldPoints or (TmstMeasureAction(CmdLine.CurrentAction).Entity.Points.Count = 1);
    try
      if Pts.ReplaceOldPoints then
        TmstMeasureAction(CmdLine.CurrentAction).ClearPoints;
      //
      J := -1;
      if ListView.Selected <> nil then
        J := ListView.Selected.Index;
      XCol := Pts.Columns[Pts.XIndex];
      YCol := Pts.Columns[Pts.YIndex];
      for I := 0 to Pred(XCol.Count) do
      begin
        Pt.X := XCol.Coord[I];
        Pt.Y := YCol.Coord[I];
        Pt := CityToDecartPoint(Pt);
        TmstMeasureAction(CmdLine.CurrentAction).InsertPoint(Pt, J + 1);
        Inc(J);
      end;

      if DisplayRect then
      begin
        R := TmstMeasureAction(CmdLine.CurrentAction).Extenstion;
        InflateRect2D(R, (R.xmax - R.xmin) / 20, (R.ymax - R.ymin) / 20);
        DrawBox.ZoomWindow(R);
      end;
      TmstMeasureAction(CmdLine.CurrentAction).OnPaint(DrawBox);
    finally
      DrawBox.RegenDrawing;
    end;
  finally
    Pts.Free;
  end;
end;

procedure TmstClientMainForm.LoadProjects(const ALeft, ATop, ARight, ABottom: Double);
var
  Frm: TmstLoadLotProgressForm;
begin
  Frm := TmstLoadLotProgressForm.Create(Self);
  Enabled := False;
  try
    Frm.Show;
    mstClientAppModule.Projects.LoadProjects(ALeft, ATop, ARight, ABottom, Frm.OnProgress2);
  finally
    Enabled := True;
    Frm.Free;
  end;
end;

procedure TmstClientMainForm.LoadProjectsClick(Sender: TObject);
var
  I: Integer;
  TmpMap: TmstMap;
  aTop, aLeft: Integer;
begin
  I := TMenuItem(Sender).Tag;
  if Assigned(mstClientAppModule.LayerMaps) then
    with mstClientAppModule.LayerMaps do
    begin
      TmpMap := mstClientAppModule.Maps.GetByMapEntityId(I);
      if not Assigned(TmpMap) then
        Exit;
      if TGeoUtils.MapTopLeft(TmpMap.MapName, aTop, aLeft) then
      begin
        LoadProjects(aLeft, aTop, aLeft + 250, aTop - 250);
      end;
    end;
end;

procedure TmstClientMainForm.LoadSessionOptions;
var
  S: string;
begin
  S := mstClientAppModule.GetOption('Session', 'Map500Search', '');
  if S <> '' then
    edtFastFindMap.Text := S;
end;

procedure TmstClientMainForm.LoadWatermark(aMapMngr: TMStIBXMapMngr);
var
  Params: IParameters;
  UserId: string;
begin
  Params := aMapMngr.GetParameters;
  FWatermark := FWatermark.Default();
  Params.Open;
  try
    UserId := IntToStr(mstClientAppModule.User.Id);
    FWatermark.Text := Params.GetWatermarkParameter(WMP_WATERMARK_TEXT) + sLineBreak + UserId;
    FWatermark.FontName := Params.GetWatermarkParameter(WMP_FONT_NAME);
    FWatermark.FontSize := Params.GetWatermarkParameter(WMP_FONT_SIZE);
    FWatermark.BorderSize := Params.GetWatermarkParameter(WMP_BORDER_SIZE);
    FWatermark.TextWidth := Params.GetWatermarkParameter(WMP_TEXT_WIDTH);
    FWatermark.TextHeight := Params.GetWatermarkParameter(WMP_TEXT_HEIGHT);
    FWatermark.BorderColorA := Params.GetWatermarkParameter(WMP_BORDER_COLOR_A);
    FWatermark.BorderColorR := Params.GetWatermarkParameter(WMP_BORDER_COLOR_R);
    FWatermark.BorderColorG := Params.GetWatermarkParameter(WMP_BORDER_COLOR_G);
    FWatermark.BorderColorB := Params.GetWatermarkParameter(WMP_BORDER_COLOR_B);
    FWatermark.InnerColorA := Params.GetWatermarkParameter(WMP_INNER_COLOR_A);
    FWatermark.InnerColorR := Params.GetWatermarkParameter(WMP_INNER_COLOR_R);
    FWatermark.InnerColorG := Params.GetWatermarkParameter(WMP_INNER_COLOR_G);
    FWatermark.InnerColorB := Params.GetWatermarkParameter(WMP_INNER_COLOR_B);
//    FWatermark.FontColorA := Params.GetWatermarkParameter(WMP_FONT_COLOR_A);
//    FWatermark.FontColorA := Params.GetWatermarkParameter(WMP_FONT_COLOR_A);
//    FWatermark.FontColorR := Params.GetWatermarkParameter(WMP_FONT_COLOR_R);
//    FWatermark.FontColorG := Params.GetWatermarkParameter(WMP_FONT_COLOR_G);
//    FWatermark.FontColorB := Params.GetWatermarkParameter(WMP_FONT_COLOR_B);
  finally
    Params.Close;
  end;
end;

procedure TmstClientMainForm.LocateMPLine(const ClickPoint: TEzPoint);
var
  Layer: TEzBaseLayer;
  NRecNo: Integer;
//  PrjId, LineId: Integer;
  Ent: TEzEntity;
begin
  if Assigned(mstClientAppModule.ObjList.Browser) then
  begin
    // выбираем слой на карте
    // чпокаем в нём объекты
    // первый чпокнутый показываем в браузере
    Layer := GIS.Layers.LayerByName(SL_MASTER_PLAN);
    if Assigned(Layer) and Layer.LayerInfo.Visible then
    begin
      NRecNo := PickSingleEntity(Layer, DrawBox, ClickPoint, 10);
      if NRecNo > 0 then
      begin
        Layer.Recno := NRecNo;
        Ent := Layer.RecLoadEntity();
        try
          mstClientAppModule.ObjList.Browser.LocateObj(Ent.ExtID);
        finally
          Ent.Free;
        end;
      end;
    end;
  end;
end;

procedure TmstClientMainForm.LocateProjectLine(const ClickPoint: TEzPoint);
var
  Layer: TEzBaseLayer;
  NRecNo: Integer;
  PrjId, LineId: Integer;
begin
  if Assigned(mstProjectBrowserForm) and mstProjectBrowserForm.Visible then
  begin
    // выбираем слой на карте
    // чпокаем в нём объекты
    // первый чпокнутый показываем в браузере
    Layer := GIS.Layers.LayerByName(SL_PROJECT_OPEN);
    if Assigned(Layer) and Layer.LayerInfo.Visible then
    begin
      NRecNo := PickSingleEntity(Layer, DrawBox, ClickPoint, 10);
      if NRecNo > 0 then
      begin
        Layer.Recno := NRecNo;
        Layer.DBTable.RecNo := NRecNo;
        PrjId := Layer.DBTable.IntegerGet(SF_PROJECT_ID);
        LineId := Layer.DBTable.IntegerGet(SF_LINE_ID);
        if mstProjectBrowserForm.Locate(PrjId, LineId) then
          Exit;
      end;
    end;
    Layer := GIS.Layers.LayerByName(SL_PROJECT_CLOSED);
    if Assigned(Layer) and Layer.LayerInfo.Visible then
    begin
      NRecNo := PickSingleEntity(Layer, DrawBox, ClickPoint, 10);
      if NRecNo > 0 then
      begin
        Layer.Recno := NRecNo;
        Layer.DBTable.RecNo := NRecNo;
        PrjId := Layer.DBTable.IntegerGet(SF_PROJECT_ID);
        LineId := Layer.DBTable.IntegerGet(SF_LINE_ID);
        mstProjectBrowserForm.Locate(PrjId, LineId);
      end;
    end;
  end;
end;

procedure TmstClientMainForm.N1Click(Sender: TObject);
begin
  acFindLotByAddressExecute(Sender);
end;

procedure TmstClientMainForm.miDisplayCoordsInMCK36Click(Sender: TObject);
var
  S: string;
begin
  miDisplayCoordsInMCK36.Checked := not miDisplayCoordsInMCK36.Checked;
  if mstClientAppModule.ViewCoordSystem = csVrn then
  begin
    mstClientAppModule.ViewCoordSystem := csMCK36;
    S := '1';
  end
  else
  begin
    mstClientAppModule.ViewCoordSystem := csVrn;
    S := '0';
  end;
  mstClientAppModule.SetOption('Session', 'ViewInCK36', S);
end;

function TmstClientMainForm.ReadPointsFromText(const aText: string): TmstImportedPointList;
var
  MaxCount: Integer;
  MaxSep: Char;
  Tmp: TmstImportedPointList;
begin
  Result := nil;
  //
  MaxCount := -1;
  MaxSep := TmstImportedPointList.LastSeparator;
  //
  Tmp := TmstImportedPointList.Create;
  Tmp.Text := aText;
  //
  if (MaxCount < Tmp.ColCount) and (Tmp.XIndex >= 0) and (Tmp.YIndex >= 0) then
  begin
    MaxCount := Tmp.ColCount;
    MaxSep := Tmp.Separator;
  end;
  //
  Tmp.Separator := #9;
  if (MaxCount < Tmp.ColCount) and (Tmp.XIndex >= 0) and (Tmp.YIndex >= 0) then
  begin
    MaxCount := Tmp.ColCount;
    MaxSep := Tmp.Separator;
  end;
  //
  Tmp.Separator := #32;
  if (MaxCount < Tmp.ColCount) and (Tmp.XIndex >= 0) and (Tmp.YIndex >= 0) then
  begin
    MaxCount := Tmp.ColCount;
    MaxSep := Tmp.Separator;
  end;
  //
  Tmp.Separator := MaxSep;
  //
  if (Tmp.XIndex >= 0) and (Tmp.YIndex >= 0) then
    Result := Tmp
  else
    Tmp.Free;
end;

procedure TmstClientMainForm.ReleaseImage(Sender: TObject);
var
  MapFileName: string;
begin
  Screen.Cursor := crHourGlass;
  try
    MapFileName := MStClientAppModule.UnLoadMap(TMenuItem(Sender).Tag);
    DrawBox.RegenDrawing;
    //
    if MapFileName <> '' then    
      DeleteFile(MapFileName);
  finally
    Screen.Cursor := crDefault;
  end;
end;

procedure TmstClientMainForm.RestorePanelsWidth;
var
  S: string;
  Wr, Wl, D: Integer;
begin
  if FRestored then
    Exit;
  S := mstClientAppModule.GetOption('MainForm', 'LeftPanelWidth', '250');
  if not TryStrToInt(S, Wl) then
    Wl := 250;
  S := mstClientAppModule.GetOption('MainForm', 'RightPanelWidth', '200');
  if not TryStrToInt(S, Wr) then
    Wr := 200;
  D := ClientWidth;
  while (Wr + Wl) > D do
  begin
    Wr := Wr div 2;
    Wl := Wl div 2;
  end;
  pnLeft.Width := Wl;
  pnRight.Width := Wr;
  FRestored := True;
end;

procedure TmstClientMainForm.SavePointListToMPObject;
var
  Obj: TmstMPObject;
  ObjList: ImstMPModuleObjList;
  Browser: ImstMPBrowser;
begin
  try
    CmdLine.CurrentAction.Finished := True;
    // копируем список точек в буфер
    Obj := SavePointsToMPObject();
    if Obj <> nil then
    begin
      try
        if mstClientAppModule.MP.EditNewObject(Obj) then
        begin
          Obj.CheckState := ocsEdited;
          mstClientAppModule.MP.LoadToGis(Obj.DatabaseId, False, False);
          ListView.Clear;
          DrawBox.RegenDrawing();
          //
          ObjList := mstClientAppModule.ObjList;
          Browser := ObjList.Browser();
          if Assigned(Browser) then
            Browser.LocateObj(Obj.DatabaseId);
        end;
      finally
        Obj.Free;
      end;
    end;
  finally
    // прерываем действие в CmdLine
    CursorState := csNone;
  end;
end;

function TmstClientMainForm.SavePointsToMPObject: TmstMPObject;
var
  I: Integer;
  Ent: TEzPolyLine;
  EzPoints: array of TEzPoint;
begin
  Result := nil;
  if Length(FPoints) > 1 then
  begin
    SetLength(EzPoints, Length(FPoints));
    Result := TmstMPObject.Create;
    for I := 0 to Length(FPoints) - 1 do
      EzPoints[I] := Point2D(FPoints[I].Y, FPoints[I].X);
    Ent := TEzPolyLine.CreateEntity(EzPoints);
    Ent.UpdateExtension;
    Ent.SaveToStream(Result.EzData);
    Result.EzId := Integer(Ent.EntityID);
    Result.EzData.Position := 0;
    //
    Result.MinX := Ent.FBox.ymin;
    Result.MinY := Ent.FBox.xmin;
    Result.MaxX := Ent.FBox.ymax;
    Result.MaxY := Ent.FBox.xmax;
  end;
end;

function TmstClientMainForm.SelectOrder(Maps: TStringList): IOrder;
var
  Orders: IOrders;
  OpenList: TInterfaceList;
begin
  // TODO : TmstClientMainForm.SelectOrder - устранить ошибки
  Result := nil;
  Orders := mstClientAppModule.GetOrders;
  if Assigned(Orders) then
  begin
    OpenList := Orders.GetOpenOrders(mstClientAppModule.User.Id);
    if Assigned(OpenList) then
    begin
      // DONE : TmstClientMainForm.SelectOrder - сделать форму
      Result := TmstOrderListForm.Execute(OpenList, Maps);
    end;
  end;
end;

procedure TmstClientMainForm.SetCursorState(const Value: TCursorState);
begin
  if FCursorState = Value then
    Exit;
  if FCursorState in [csZoomIn, csZoomOut, csReadyToDrag] then
    CmdLine.Clear;
  if CmdLine.IsBusy and ((FCursorState <> csCalc) and (FCursorState <> csCoord)) then
    Exit;

  if (FCursorState in [csCalc, csCoord]) then
  begin
    FCursorState := Value;
    CmdLine.Clear;
    tbSnaps.Visible := False;
//    CmdLine.AccuSnap.Enabled := False;
    CheckSnapsSettings;
  end;

  case FCursorState of
    csPrintPrepare:
      begin
        FPrevCurState := csPrintPrepare;
      end;
  end; // of case
  FCursorState := Value;
  TreeView.Enabled := FCursorState <> csCoord;
  case FCursorState of
    csCalc:
      tbSnaps.Visible := True;
    csCoord:
      begin
        tbSnaps.Visible := True;
        DrawBox.Cursor := crCoords;
      end;
    csLotInfo:
      DrawBox.Cursor := crHelp;
    csNone, csArrow:
      CmdLine.Clear;
  end;
end;

procedure TmstClientMainForm.ShowCoord(Vector: TEzVector);
var
  I: Integer;
  L: Double;
  LenStr, AzimStr: string;
  Pt1, Pt2: TEzPoint;
  Azimuth: Double;
begin
  try
    //clear TAllotmentPoint to array
    if Length(FPoints) > 0 then
      Finalize(FPoints);
    //allocate memory for array
    if Vector <> nil then
    begin
      if Vector.Count > 0 then
        SetLength(FPoints, Vector.Count);
      with ListView do
      begin
        Clear;
        for I := 0 to Pred(Vector.Count) do
          with Items.Add do
          begin
            Caption := IntToStr(I + 1);
            SubItems.Add(Format('%0.2f', [Vector[I].Y]));
            SubItems.Add(Format('%0.2f', [Vector[I].X]));
            FPoints[I].Name := Caption;
            FPoints[I].X := Vector[I].Y;
            FPoints[I].Y := Vector[I].X;
            if Vector.Count < 2 then
            begin
              LenStr := '';
              AzimStr := '';
              FPoints[I].Length := 0;
              FPoints[I].Azimuth := 0;
            end
            else
            begin
              Pt1 := Vector[I];
              if I = Pred(Vector.Count) then
                Pt2 := Vector[0]
              else
                Pt2 := Vector[Succ(I)];
              L := Dist2D(Pt1, Pt2);
              FPoints[I].Length := L;
              LenStr := Format('%0.2f', [L]);
              //AzimStr := GetDegreeCorner(Angle2D(Pt11, Pt22), True);
              Azimuth := CalcAzimuth(Pt1.y, Pt1.x, Pt2.y, Pt2.x);
              FPoints[I].Azimuth := Azimuth;
              AzimStr := GetDegreeCorner(Azimuth);
            end;
            SubItems.Add(LenStr);
            SubItems.Add(AzimStr);
            ImageIndex := 42;
          end;
        AutoSelectListViewColumnWidth(ListView, 16);
      end;
    end;
  except
    DebugMessage(Self.Name, 'ShowCoord');
  end;
end;

procedure TmstClientMainForm.ShowWatermarkLayer(const Value: Boolean);
var
  Layer: TEzBaseLayer;
begin
  Layer := DrawBox.GIS.Layers.LayerByName(SL_WATERMARKS);
  if Assigned(Layer) then
    Layer.LayerInfo.Visible := Value;
end;

procedure TmstClientMainForm.TreeViewChange(Sender: TObject; Node: TTreeNode);
begin
  // Узнаем, что выбрано
  if Assigned(TreeView.Selected) then
  begin
    with TreeView.Selected as TmstTreeNode do
      if Assigned(TreeView.Selected.Parent) then
      begin
        mstClientAppModule.Stack.SelectObject(NodeType, DatabaseId, TmstTreeNode(Node.Parent).NodeType, TmstTreeNode(Node.Parent).DatabaseId)
      end
      else
        mstClientAppModule.Stack.SelectObject(NodeType, DatabaseId, -1, -1);
  end
  else
    mstClientAppModule.Stack.ClearSelection;
  if Length(FPoints) > 0 then
    Finalize(FPoints);
  TreeView.Realign;
end;

procedure TmstClientMainForm.TreeViewMouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
var
  aNode: TTreeNode;
begin
  if Button = mbRight then
  begin
    aNode := TreeView.GetNodeAt(X, Y);
    if Assigned(aNode) then
      if TreeView.Selected <> aNode then
        TreeView.Selected := aNode;
  end;
end;

procedure TmstClientMainForm.acCopySelectedExecute(Sender: TObject);
begin
  CopyPoints(False);
end;

procedure TmstClientMainForm.CoordSystemChanged(const Value: TCoordSystem);
begin
  miDisplayCoordsInMCK36.Checked := Value = csMCK36;
  DisplayLastCoordinates(FLastDisplayedPoint.x, FLastDisplayedPoint.y);
end;

procedure TmstClientMainForm.CopyPoints(all: Boolean);
var
  i, j: Integer;
  s: string;
begin
  s := '';
  if Length(FPoints) <> 0 then
  begin
{    MessageBox(Handle, PChar('Не удалось скопировать данные!'),
                 PChar('Ошибка!'), MB_OK);
    Exit;

}
    for i := 0 to ListView.Items.Count - 1 do
      if all or ListView.Items[i].Selected then
      begin
        s := s + FPoints[i].Name + #9;
        s := s + Format('%0.9f', [FPoints[i].X]) + #9;
        s := s + Format('%0.9f', [FPoints[i].Y]) + #9;
        s := s + Format('%0.9f', [FPoints[i].Length]) + #9;
        s := s + GetDegreeCorner(FPoints[i].Azimuth) + #9;
        if Length(s) > 0 then
          SetLength(s, Length(s) - 1);
        s := s + #13#10;
      end;
  end
  else
  begin
//original code
    for i := 0 to ListView.Items.Count - 1 do
      if all or ListView.Items[i].Selected then
      begin
        s := s + ListView.Items[i].Caption + #9;
        for j := 0 to ListView.Items[i].SubItems.Count - 1 do
          s := s + ListView.Items[i].SubItems[j] + #9;
        if Length(s) > 0 then
          SetLength(s, Length(s) - 1);
        s := s + #13#10;
      end;
  end;
//work with clipboard
  if Length(s) > 0 then
  begin
    try
      Clipboard.AsText := s;
    except
      MessageBox(Handle, PChar('Не удалось скопировать данные!'), PChar('Ошибка!'), MB_OK);
    end;
  end
  else
    raise EAbort.Create('Нет точек для копирования!');
end;

procedure TmstClientMainForm.acCopyAllExecute(Sender: TObject);
begin
  CopyPoints(True);
end;

procedure TmstClientMainForm.acImportMidMifExecute(Sender: TObject);
var
  Import: ImstImportLayer;
  Dialog: ImstImportLayerDialog;
begin
  // выбираем файл
  if not MidMifDialog.Execute() then
    Exit;
  // создаём объект для импорта
  Import := TmstImportFactory.NewLayerImport(importMifMid);
  // читаем заголовок
  Import.ReadHeader(MidMifDialog.Files[0], DrawBox.Grapher);
  // показываем информацию
  Dialog := TmstDialogFactory.NewImportLayerDialog();
  if Dialog.Execute(Import) then
  begin
    // импортируем, если всё ОК
    Import.DoImport(Dialog.Settings);
  end;
end;

procedure TmstClientMainForm.acInsertPointExecute(Sender: TObject);
var
  Pt: TEzPoint;
begin
  Pt.x := 0;
  Pt.y := 0;
  if TmstPointForm.NewPoint(Pt) then
  begin
    Pt := CityToDecartPoint(Pt);
    TmstMeasureAction(CmdLine.CurrentAction).InsertPoint(Pt, ListView.Selected.Index + 1);
    TmstMeasureAction(CmdLine.CurrentAction).OnPaint(DrawBox);
  end;
end;

procedure TmstClientMainForm.acInsertPointUpdate(Sender: TObject);
begin
  acInsertPoint.Enabled := (CursorState = csCalc);
end;

procedure TmstClientMainForm.acDeletePointUpdate(Sender: TObject);
begin
  acDeletePoint.Enabled := (CursorState = csCalc) and (ListView.Selected <> nil);
end;

procedure TmstClientMainForm.acCopySelectedUpdate(Sender: TObject);
begin
  acCopySelected.Enabled := (ListView.Items.Count > 0) and (ListView.SelCount > 0);
end;

procedure TmstClientMainForm.acCopyAllUpdate(Sender: TObject);
begin
  acCopyAll.Enabled := (ListView.Items.Count > 0);
end;

procedure TmstClientMainForm.acCopyProjectsToMPExecute(Sender: TObject);
var
  Exp: TmstProjectExportToMP;
  Frm: TmstLoadLotProgressForm;
begin
  Frm := TmstLoadLotProgressForm.Create(Self);
  Enabled := False;
  try
    Frm.Show;

    Exp := TmstProjectExportToMP.Create;
    try
      Exp.DoExport(
        mstClientAppModule.Db,
        mstClientAppModule.Projects,
        Frm.OnProgress2);
      ShowMessage('Проекты скопированы.');
    finally
      Exp.Free;
    end;

  finally
    Enabled := True;
    Frm.Free;
  end;
end;

procedure TmstClientMainForm.acCopyProjectsToMPUpdate(Sender: TObject);
begin
  acGenClassIDforMP.Enabled := mstClientAppModule.User.IsAdministrator;
end;

procedure TmstClientMainForm.acDeletePointExecute(Sender: TObject);
begin
  if MessageDlg('Удалить точку?', mtConfirmation, [mbYes, mbNo], 0) = mrYes then
  begin
    with TmstMeasureAction(CmdLine.CurrentAction) do
    begin
      RemovePoint(ListView.Selected.Index);
    end;
    TmstMeasureAction(CmdLine.CurrentAction).OnPaint(DrawBox);
  end;
end;

procedure TmstClientMainForm.acEditPointUpdate(Sender: TObject);
begin
  acEditPoint.Enabled := (CursorState = csCalc) and (ListView.SelCount = 1);
end;

procedure TmstClientMainForm.acEditPointExecute(Sender: TObject);
var
  Pt: TEzPoint;
  X, Y: Double;
begin
  if tbMeasures.Down and (ListView.SelCount = 1) then
  begin
    if TryStrToFloat(ListView.Selected.SubItems[0], X)
       and
       TryStrToFloat(ListView.Selected.SubItems[1], Y)
    then
    begin
      Pt := Point2D(X, Y);
      if TmstPointForm.EditPoint(Pt) then
      begin
        Pt := CityToDecartPoint(Pt);
        TmstMeasureAction(CmdLine.CurrentAction).ReplacePoint(Pt, ListView.Selected.Index);
        TmstMeasureAction(CmdLine.CurrentAction).OnPaint(DrawBox);
      end;
    end;
  end;
end;

procedure TmstClientMainForm.acShowMapHistoryExecute(Sender: TObject);
//var
//  Map: TmstMap;
begin
  if Sender is TMenuItem then
    with Sender as TMenuItem do
    begin
      raise Exception.Create('Check TmstClientMainForm.acShowMapHistoryExecute implementation');
//    Map := mstClientAppModule.Maps.GetByMapEntityId(Tag);
//    if Map <> nil then
//      if mstMapMngr.UpdateMapHistory(Map.MapName) then
//        ShowMapHistory('Планшет ' + Map.MapName));
    end;
end;

procedure TmstClientMainForm.Splitter1Moved(Sender: TObject);
begin
  Windows.ShowScrollBar(TreeView.Handle, SB_BOTH, True);
end;

procedure TmstClientMainForm.acAllMapsExecute(Sender: TObject);
begin
//  mstMapMngr.StartMapsManager(True);
end;

procedure TmstClientMainForm.acAllMapsUpdate(Sender: TObject);
begin
//  acAllMaps.Enabled := (mstMapMngr.UserRole = 'KGO') or (mstMapMngr.UserRole = 'GIS');
end;

procedure TmstClientMainForm.acGenClassIDforMPExecute(Sender: TObject);
begin
  mstClientAppModule.MP.FillClassIDinProjectLayers();
end;

procedure TmstClientMainForm.acGenClassIDforMPUpdate(Sender: TObject);
begin
  acGenClassIDforMP.Enabled := mstClientAppModule.User.IsAdministrator;
end;

procedure TmstClientMainForm.acGivenMapsExecute(Sender: TObject);
begin
//  mstMapMngr.StartMapsManager(False);
end;

procedure TmstClientMainForm.acGivenMapsUpdate(Sender: TObject);
begin
//  acGivenMaps.Enabled := (mstMapMngr.UserRole = 'KGO') or (mstMapMngr.UserRole = 'GIS');
end;

procedure TmstClientMainForm.acMapManagerExecute(Sender: TObject);
begin
  if not Assigned(mstFormMapImages) then
    mstFormMapImages := TmstFormMapImages.Create(Self);
  mstFormMapImages.Show;
  DrawBox.BeginUpdate;
  try
    mstClientAppModule.RefreshMaps;
  finally
    DrawBox.EndUpdate;
  end;
end;

procedure TmstClientMainForm.acMapManagerUpdate(Sender: TObject);
begin
  acMapManager.Enabled := mstClientAppModule.User.IsAdministrator;
end;

procedure TmstClientMainForm.acMapPrintStatsExecute(Sender: TObject);
begin
  with TmstPrintStatsForm.Create(Self) do
  try
    Stats := mstClientAppModule.GetStats;
    try
      ShowModal;
    finally
      Stats.Close;
    end;
  finally
    Free;
  end;
end;

procedure TmstClientMainForm.acMapPrintStatsUpdate(Sender: TObject);
begin
  acMapPrintStats.Enabled := mstClientAppModule.User.IsAdministrator;
end;

procedure TmstClientMainForm.acMPClassSettingsExecute(Sender: TObject);
begin
  // показываем окно для работы с классификатором
  // если открыто окно проектов, то закрываем его
  CloseProjectsBrowser();
  CloseMPBrowser();
  //
  DisplayMPClassSettings();
end;

procedure TmstClientMainForm.acMPExportMidMifExecute(Sender: TObject);
var
  MIFFileName: string;
begin
  if not SaveDialog2.Execute(Handle) then
    Exit;
  MIFFileName := SaveDialog2.Files[0];
  mstClientAppModule.MP.ExportToMif(MIFFileName);
end;

procedure TmstClientMainForm.acMPExportMidMifUpdate(Sender: TObject);
begin
  acMPExportMidMif.Enabled := mstClientAppModule.MP.HasLoaded();
end;

procedure TmstClientMainForm.acMPLoadRectExecute(Sender: TObject);
begin
  LastLayerName := GIS.CurrentLayerName;
  CursorState := csLoadMP;
  GIS.CurrentLayerName := 'MEASURES';
  CmdLine.DoCommand('RECTANGLE', 'LOAD_MP');
end;

procedure TmstClientMainForm.acMPLoadRectUpdate(Sender: TObject);
begin
  acMPLoadRect.Enabled := CursorState in [csNone, csArrow];
end;

procedure TmstClientMainForm.acMPPickupPointsExecute(Sender: TObject);
var
  Act: TmstMeasureAction;
begin
  if CursorState = csCoord then
  begin
    CursorState := csNone;
    CmdLine.Clear;
  end
  else
  begin
    CursorState := csCoord;
    ListView.Clear;
    Act := TmstMeasureAction.CreateAction(CmdLine);
    Act.OnPointListChange := ShowCoord;
    Act.ShowResult := False;
    Act.StopOnRightClick := False;
    CmdLine.Push(Act, True, 'CALC', 'PROJECT_LINE');
  end;
end;

procedure TmstClientMainForm.acMPPickupPointsUpdate(Sender: TObject);
begin
  acMPPickupPoints.Enabled := CursorState in [csNone, csArrow];
  acMPPickupPoints.Checked := CursorState = csCoord;
end;

procedure TmstClientMainForm.acPastePointsExecute(Sender: TObject);
var
  Txt: string;
begin
  Txt := ClipBoard.AsText;
  LoadPointsFromText(Txt);
end;

procedure TmstClientMainForm.acPastePointsUpdate(Sender: TObject);
var
  B: Boolean;
begin
  try
    B := Clipboard.HasFormat(CF_TEXT);
    B := B and (Length(Clipboard.AsText) > 0);
    acPastePoints.Enabled := B;
  except
    B := False;
  end;
  acPastePoints.Enabled := B and (CursorState = csCoord);
end;

procedure TmstClientMainForm.acPrintPrepareExecute(Sender: TObject);
begin
  mstClientAppModule.Mode := amPrint;
  CmdLine.Clear;
  CursorState := csPrintPrepare;
  mstClientAppModule.GIS.CurrentLayerName := SL_REPORT;
  CmdLine.DoCommand('RECTANGLE', 'REPORT');
end;

procedure TmstClientMainForm.acPrintPrepareUpdate(Sender: TObject);
var
  B: Boolean;
begin
  B := TreeView.SelectionCount in [0, 1];
  if TreeView.SelectionCount = 1 then
    B := TmstTreeNode(TReeView.Selected).NodeType in mstLotNodeTypes;
  acPrintPrepare.Enabled := (mstClientAppModule.Mode <> amPrint) and B;
end;

procedure TmstClientMainForm.acExportToDXFExecute(Sender: TObject);
begin
  if SaveDialog1.Execute then
  begin
    with TEzDxfExport.Create(nil) do
    try
      FileName := SaveDialog1.FileName;
      DrawBox := Self.DrawBox;
      LayerNames.Clear;
      LayerNames.Add(GIS.CurrentLayerName);
      Execute;
    finally
      Free;
    end;
  end;
end;

procedure TmstClientMainForm.acExportToDXFUpdate(Sender: TObject);
begin
{  acExportToDXF.Visible := (AnsiUpperCase(mstMapMngr.UserLogin) = 'KALABUHOVAL')
           or (AnsiUpperCase(mstMapMngr.UserLogin) = 'ALEX_SAF'); }
end;

procedure TmstClientMainForm.acZoomInUpdate(Sender: TObject);
begin
//  acZoomIn.Enabled := CursorState <> csPrintPrepare;
end;

procedure TmstClientMainForm.acZoomOutUpdate(Sender: TObject);
begin
//  acZoomOut.Enabled := CursorState <> csPrintPrepare;
end;

procedure TmstClientMainForm.acZoomRectUpdate(Sender: TObject);
begin
//  acZoomRect.Enabled := CursorState <> csPrintPrepare;
end;

procedure TmstClientMainForm.acZoomAllUpdate(Sender: TObject);
begin
//  acZoomAll.Enabled := CursorState <> csPrintPrepare;
end;

procedure TmstClientMainForm.acZoomPrevUpdate(Sender: TObject);
begin
//  acZoomPrev.Enabled := CursorState <> csPrintPrepare;
end;

procedure TmstClientMainForm.acPrintUpdate(Sender: TObject);
begin
  acPrint.Enabled := mstClientAppModule.Mode = amPrint;
end;

procedure TmstClientMainForm.acProjectAdd2Execute(Sender: TObject);
begin
  FImport := TmstProjectImportModule.Create(Self);
  // выбрать файл
  if not FImport.BeginImport(DrawBox,
                             GetProjectImportLayer,
                             DoProjectImportExecuted,
                             DoCreateProject,
                             DoCreateProjReader
                            )
  then
    Exit;
  FImport.DisplayImportDialog(True);
end;

procedure TmstClientMainForm.acProjectBrowseExecute(Sender: TObject);
begin
  // если окно не открыто, то открываем и назначаем слой
  if mstProjectBrowserForm = nil then
    mstProjectBrowserForm := TMStProjectBrowserForm.Create(Self);
  // если окно открыто, то назначаем в него слой
  mstProjectBrowserForm.DrawBox := Self.DrawBox;
  mstProjectBrowserForm.Browse;
end;

procedure TmstClientMainForm.acProjectExportExecute(Sender: TObject);
var
  Exp: TmstProjectMIFExport;
  MIFFileName: string;
begin
  if not SaveDialog2.Execute(Handle) then
    Exit;
  MIFFileName := SaveDialog2.Files[0];
  Exp := TmstProjectMIFExport.Create;
  Exp.Forget();
  Exp.DB := mstClientAppModule.MapMngr as IDb;
  Exp.DrawBox := Self.DrawBox;
  Exp.OnGetProject := GetProjectToExport;
  Exp.Save(GIS, MIFFileName);
end;

procedure TmstClientMainForm.acProjectExportUpdate(Sender: TObject);
begin
  acProjectExport.Enabled := mstClientAppModule.HasLoadedProjects();
end;

procedure TmstClientMainForm.acProjectFindByAddressExecute(Sender: TObject);
begin
  if ShowAddress(FLastSearchStreet, FLastSearchBuilding) then
    if not FindProject(FLastSearchStreet + ' ' + FLastSearchBuilding) then
      MessageBox(Handle, PChar('По вашему запросу ничего не найдено!'), PChar('Поиск'), MB_OK + MB_ICONWARNING);
end;

procedure TmstClientMainForm.acCancelPrintUpdate(Sender: TObject);
begin
  acCancelPrint.Enabled := mstClientAppModule.Mode = amPrint;
end;

procedure TmstClientMainForm.acLoadLotsUpdate(Sender: TObject);
begin
  acLoadLots.Enabled := mstClientAppModule.Mode <> amPrint;
end;

procedure TmstClientMainForm.acLocateCoordListExecute(Sender: TObject);
var
  Exten: TEzRect;
begin
  if not (CmdLine.CurrentAction is TmstMeasureAction) then
    Exit;
  Exten := TmstMeasureAction(CmdLine.CurrentAction).Extenstion;
  if EqualRect2D(Exten, NULL_EXTENSION) then
    Exit;
  if SameValue(Exten.X1, Exten.X2) then
  begin
    Exten.xmin := Exten.X1 - 10;
    Exten.xmax := Exten.X1 + 10;
  end;
  if SameValue(Exten.Y1, Exten.Y2) then
  begin
    Exten.ymin := Exten.Y1 - 10;
    Exten.ymax := Exten.Y1 + 10;
  end;

  InflateRect2D(Exten, Rect2DWidth(Exten) / 20, Rect2DHeight(Exten) / 20);
  DrawBox.SetViewTo(Exten.xmin, Exten.ymin, Exten.xmax, Exten.ymax );
end;

procedure TmstClientMainForm.acCalcUpdate(Sender: TObject);
begin
  acCalc.Enabled := (mstClientAppModule.Mode <> amPrint);
  acCalc.Checked := CursorState = csCalc;
end;

procedure TmstClientMainForm.acCancelPrintExecute(Sender: TObject);
begin
  CursorState := FPrevCurState;
end;

procedure TmstClientMainForm.acSetScaleExecute(Sender: TObject);
var
  aScale: Double;
begin
  aScale := DrawBox.CurrentScale * 1000;
  if SelectScale(aScale) then
    DrawBox.ZoomToScale(aScale / 1000, suMms);
end;

procedure TmstClientMainForm.acSetScaleUpdate(Sender: TObject);
begin
  acSetScale.Enabled := mstClientAppModule.Mode = amPrint;
end;

procedure TmstClientMainForm.acCoordUpdate(Sender: TObject);
begin
  acCoord.Enabled := False;
end;

procedure TmstClientMainForm.acExport2DXFExecute(Sender: TObject);
{var
  pts: T_FloatPoints;
  i: Integer; }
begin
{  if SaveDialog1.Execute then
  begin
    SetLength(pts, ListView.Items.Count);
    for i := 0 to Length(pts) - 1 do
      pts[i] := KalabUtils._FloatPoint(StrToFloat(ListView.Items[i].SubItems[0]), StrToFloat(ListView.Items[i].SubItems[1]));
    PointsToDXF(pts, SaveDialog1.FileName);
  end; }
end;

procedure TmstClientMainForm.acExport2DXFUpdate(Sender: TObject);
begin
  acExport2DXF.Enabled := ListView.Items.Count > 0;
end;

procedure TmstClientMainForm.WMHotKey(var Msg: TWMHotKey);
begin
  if WindowState <> wsMinimized then
    if Msg.HotKey = id_SnapShot then
      Msg.HotKey := 0;
end;

procedure TmstClientMainForm.WMPaint(var Msg: TWMPaint);
begin
  inherited;
  if not FRestored then
    SendMessage(Handle, WM_RESTORE_PANELS, 0, 0);
end;

procedure TmstClientMainForm.WmRestorePanels(var Message: TMessage);
begin
  RestorePanelsWidth();
end;

procedure TmstClientMainForm.XLS1Click(Sender: TObject);
begin
  mstClientAppModule.MP.ImportFile(srcExcel, mstProjected);
end;

procedure TmstClientMainForm.XLS2Click(Sender: TObject);
begin
  mstClientAppModule.MP.ImportFile(srcExcel, mstDrawn);
end;

procedure TmstClientMainForm.SetGIS(const Value: TEzBaseGIS);
begin
  FGIS := Value;
  DrawBox.GIS := FGIS;
  TProjectUtils.GIS := FGIS;
end;

procedure TmstClientMainForm.PreparePopupMenuItems(const X, Y: Double; AMenu: TMenu);
var
  Layer: TEzBaseLayer;
  Recno, NumPoint: Integer;
  MenuItem: TMenuItem;
  List: TStringList;
  I: Integer;
  Map: TmstMap;
begin
  Layer := nil;
  Recno := -1;
  NumPoint := -1;
  AMenu.Items.Clear;
  //
  MenuItem := TMenuItem.Create(Self);
  AMenu.Items.Add(MenuItem);
  MenuItem.Caption := 'Загрузить отводы';
  MenuItem.Tag := REG_LOTS;
  MenuItem.OnClick := LoadLotsClick;
  MenuItem.Enabled := CursorState <> csCoord;
  //
  if GIS.Layers.LayerByName('M500').LayerInfo.Visible then
  begin
    List := TStringList.Create;
    List.Forget;
    // Щелкнули на планшет
    if DrawBox.PickEntity(X, Y, 0, 'M500', Layer, Recno, NumPoint, List) then
    begin
      MenuItem := TMenuItem.Create(Self);
      AMenu.Items.Add(MenuItem);
      MenuItem.Caption := '-';
      //
      for I := 0 to List.Count - 1 do
      begin
        Recno := Integer(List.Objects[I]);
        MenuItem := TMenuItem.Create(Self);
        AMenu.Items.Add(MenuItem);
        MenuItem.Tag := Recno;
        Map := mstClientAppModule.Maps.GetByMapEntityId(Recno);
        if Map.ImageLoaded then
        begin
          MenuItem.Caption := 'Выгрузить планшет ' + Map.MapName;
          MenuItem.OnClick := ReleaseImage;
        end
        else
        begin
          MenuItem.Caption := 'Загрузить планшет ' + Map.MapName;
          MenuItem.OnClick := LoadImage;
        end;
        //
        if mstClientAppModule.User.CanManageProjects then
        begin
          MenuItem := TMenuItem.Create(Self);
          AMenu.Items.Add(MenuItem);
          MenuItem.Caption := 'Загрузить проекты на планшете ' + Map.MapName;
          MenuItem.Tag := Recno;
          MenuItem.OnClick := LoadProjectsClick;
        end;
        //
        if mstClientAppModule.User.CanManageMP then
        begin
          MenuItem := TMenuItem.Create(Self);
          AMenu.Items.Add(MenuItem);
          MenuItem.Caption := 'Загрузить сводный план на планшете ' + Map.MapName;
          MenuItem.Tag := Recno;
          MenuItem.OnClick := LoadMPClick;
        end;
//        MenuItem := TMenuItem.Create(Self);
//        AMenu.Items.Add(MenuItem);
//        MenuItem.Tag := Recno;
//        MenuItem.Caption := 'Показать историю планшета ' + Map.MapName;
//        MenuItem.OnClick := acShowMapHistoryExecute;
//        //
//        MenuItem := TMenuItem.Create(Self);
//        AMenu.Items.Add(MenuItem);
//        MenuItem.Caption := '-';
      end;
    end;
  end;
end;

procedure TmstClientMainForm.pmObjectsPopup(Sender: TObject);
var
  ObjId, ObjType, ParentId, ParentType: Integer;
  Node: TTreeNode;
begin
  ObjType := -1;
  ObjId := -1;
  ParentId := -1;
  ParentType := -1;
  Node := TreeView.Selected;
  if Assigned(Node) then
  begin
    ObjId := TmstTreeNode(Node).DatabaseId;
    ObjType := TmstTreeNode(Node).NodeType;
    Node := Node.Parent;
    if Assigned(Node) then
    begin
      ParentId := TmstTreeNode(Node).DatabaseId;
      ParentType := TmstTreeNode(Node).NodeType;
    end;
  end;
  mstClientAppModule.Stack.PopupOnObject(ObjType, ObjId, ParentType, ParentId, pmObjects);
end;

procedure TmstClientMainForm.N44Click(Sender: TObject);
begin
  N44.Checked := not N44.Checked;
  UpdateButtonSize(N44.Checked);
  mstClientAppModule.AppSettings.SaveAppParam(Application, Self, 'MainFormBigButtons', N44.Checked);
end;

procedure TmstClientMainForm.N53Click(Sender: TObject);
begin
  mstClientAppModule.MP.DisplayNavigator(Self.DrawBox);
end;

procedure TmstClientMainForm.N57Click(Sender: TObject);
var
  Dlg: TmstMPLineColorsDialog;
begin
  Dlg := TmstMPLineColorsDialog.Create(Self);
  try
    Dlg.Execute();
    DrawBox.RegenDrawing;
  finally
    Dlg.Free;
  end;
end;

procedure TmstClientMainForm.N7Click(Sender: TObject);
begin
  ;
end;

procedure TmstClientMainForm.NetTypeMenuClick(Sender: TObject);
var
  Mi: TMenuItem;
  I: Integer;
  Nt: TmstProjectNetType;
begin
  // тут нам надо перерисовать экран
  if Sender is TMenuItem then
  begin
    Mi := TMenuItem(Sender);
    if Mi.Tag < 1 then
    begin
      FNetTypesUpdate := True;
      try
        for I := 0 to miProjectNetTypes.Count - 1 do
        begin
          Mi := miProjectNetTypes.Items[I];
          if Mi <> Sender then
          begin
            Mi.Checked := True;
            Nt := mstClientAppModule.NetTypes.ById(Mi.Tag);
            if Assigned(Nt) then
              Nt.Visible := True;
          end;
        end;
      finally
        FNetTypesUpdate := False;
        DrawBox.RegenDrawing;        
      end;
    end
    else
    begin
      Nt := mstClientAppModule.NetTypes.ById(Mi.Tag);
      if Assigned(Nt) then
      begin
        Nt.Visible := Mi.Checked;
        if not FNetTypesUpdate then
          DrawBox.RegenDrawing;
      end;
    end;
  end;
end;

procedure TmstClientMainForm.DrawBoxBeforeInsert(Sender: TObject; Layer: TEzBaseLayer; Entity: TEzEntity; var Accept: Boolean);
var
  Rect: TEzRect;
begin
  try
    case CursorState of
      csLoadLots:
        begin
          if Assigned(Entity) then
          begin
            FCursorState := csArrow;
            Accept := False;
            Entity.MaxMinExtents(Rect.ymin, Rect.xmin, Rect.ymax, Rect.xmax);
            LoadLots(Rect.xmin, Rect.ymax, Rect.xmax, Rect.ymin);
            GIS.CurrentLayerName := LastLayerName;
            DrawBox.RegenDrawing;
          end;
        end;
      csLoadMP:
        begin
          if Assigned(Entity) then
          begin
            FCursorState := csArrow;
            Accept := False;
            Entity.MaxMinExtents(Rect.xmin, Rect.ymin, Rect.xmax, Rect.ymax);
            LoadMPObjects(Rect.xmin, Rect.ymax, Rect.xmax, Rect.ymin);
            GIS.CurrentLayerName := LastLayerName;
            DrawBox.RegenDrawing;
          end;
        end;
    else
        begin
          if Layer.Name <> SL_REPORT then
            if Entity.EntityID = idTrueTypeText then
            begin
              Accept := False;
              ShowMessage('Текст можно вставлять только в слой [Отчет]!');
            end
            else
              Accept := False;
          //
          if Accept then
          begin
          
          end;
        end;
    end;
  except
//    DebugMessage(Self.Handle, Self.Name, 'DrawBoxAfterInsert');
  end;
end;

procedure TmstClientMainForm.acShowInvisibleExecute(Sender: TObject);
begin
  acShowInvisible.Checked := not acShowInvisible.Checked;
  mstClientAppModule.ShowInvisibleLots := acShowInvisible.Checked;
  DrawBox.RegenDrawing;
end;

procedure TmstClientMainForm.TreeViewMouseMove(Sender: TObject; Shift: TShiftState; X, Y: Integer);
var
  aNode: TTreeNode;
  NodeRect: TRect;
  Pt, TreePt: TPoint;
begin
  aNode := TreeView.GetNodeAt(X, Y);
  if Assigned(aNode) then
  begin
    NodeRect := aNode.DisplayRect(True);
    if not RectInRect(NodeRect, TreeView.ClientRect) then
    begin
      if aNode <> FLastHintNode then
      begin
        Application.HideHint;
        TreeView.Hint := aNode.Text;
        FLastHintNode := aNode;
      end;
      Pt := TreeView.ClientToScreen(Types.Point(NodeRect.Left, NodeRect.Top - 5));
      TreePt := TreeView.ClientToScreen(Types.Point(0, 0));
      if Pt.X < TreePt.X then
        Pt.X := TreePt.X;
      Pt.Y := Pt.Y - (NodeRect.Bottom - NodeRect.Top);
      Application.ActivateHint(Pt);
    end
    else
    begin
      TreeView.Hint := '';
      Application.HideHint;
      FLastHintNode := nil;
    end;
  end
  else
  begin
    FLastHintNode := nil;
    Application.HideHint;
  end;
end;

procedure TmstClientMainForm.UpdateButtonSize(Big: Boolean);
var
  Sz: Integer;
begin
  if Big then
    Sz := 48
  else
    Sz := 24;
  ToolBar1.ButtonHeight := Sz;
  ToolBar1.ButtonWidth := Sz;
  tbSearch.ButtonHeight := Sz;
  tbSearch.ButtonWidth := Sz;
end;

procedure TmstClientMainForm.DrawBoxAfterInsert(Sender: TObject; Layer: TEzBaseLayer; Recno: Integer);
var
  Rect: TEzRect;
begin
  if (CursorState = csPrintPrepare) and (mstPrintModule.PrintAreaId < 0) then
  begin
    PrepareToPrint;
    Layer.Recno := Recno;
    mstPrintModule.PrintAreaId := Recno;
    DrawBox.RegenDrawing;
    FCursorState := csArrow;
    Layer.RecEntity.MaxMinExtents(Rect.xmin, Rect.ymin, Rect.xmax, Rect.ymax);
    mstPrintModule.Lot := mstClientAppModule.GetSelectedLot;
    mstPrintModule.PrintArea := Rect;
    Rect := mstPrintModule.PagesArea;
    DrawBox.SetViewTo(Rect);
  end;
end;

procedure TmstClientMainForm.tbCancelReportClick(Sender: TObject);
begin
  mstPrintModule.UnprepareReport;
  tbReport.Visible := False;
end;

procedure TmstClientMainForm.tbFastFindLotClick(Sender: TObject);
begin
  FastFindLot();
end;

procedure TmstClientMainForm.tbFastFindMapClick(Sender: TObject);
begin
  FastFindMap();
end;

procedure TmstClientMainForm.PrepareToPrint;
begin
  tbReport.Visible := True;
  cbReportScale.ItemIndex := cbReportScale.Items.IndexOf('1:' + IntToStr(mstPrintModule.ReportScale));
end;

procedure TmstClientMainForm.acReportPrintExecute(Sender: TObject);
var
  Pages: TList;
  Maps: TStringList;
  I, J: Integer;
  Page: TmstPage;
  Layer: TEzBaseLayer;
//  EntRecNos: TList;
  Map: TmstMap;
  PrintPerm: TmstPrintPermission;
  Order: IOrder;
  LoadedMaps: TList;
  MapRects: TEzRectList;
  N: string;
  R: TEzRect;
begin
  Pages := TList.Create;
  Maps := TStringList.Create;
  try
    for I := 0 to Pred(mstPrintModule.PageCount) do
      if mstPrintModule.Pages[I].Visible then
        Pages.Add(mstPrintModule.Pages[I]);
    // составляем список планшетов, используемых для печати
    Layer := DrawBox.GIS.Layers.LayerByName(SL_MAP_LAYER);
    if Assigned(Layer) then
    begin
      //if Layer.LayerInfo.Visible then
      begin
        // создаём список загуженных планшетов
        // по этому списку
        LoadedMaps := TList.Create;
        LoadedMaps.Forget;
        MapRects := TEzRectList.Create;
        MapRects.Forget;
        for I := 0 to Pred(mstClientAppModule.Maps.Count) do
        begin
          if mstClientAppModule.Maps[I].ImageLoaded then
          begin
            N := mstClientAppModule.Maps[I].MapName;
            R := GetMap500Rect(N);
            MapRects.Add(R);
            LoadedMaps.Add(mstClientAppModule.Maps[I]);
          end;
        end;
        //
//        N := 'О-XI-1';
//        Map := mstClientAppModule.Maps.GetByNomenclature(N);
//        LoadedMaps.Add(Map);
//        R := GetMap500Rect(N);
//        MapRects.Add(R);
//        N := 'О-XI-2';
//        Map := mstClientAppModule.Maps.GetByNomenclature(N);
//        LoadedMaps.Add(Map);
//        R := GetMap500Rect(N);
//        MapRects.Add(R);
//        //
        for I := 0 to Pages.Count - 1 do
        begin
          Page := Pages[I];
          for J := 0 to MapRects.Count - 1 do
          begin
            Map := LoadedMaps[J];
            R := MapRects[J];
            if GetRect2DRelation(R, Page.PageRect) <> rrNotIntersects then
            begin
              if Maps.IndexOf(Map.MapName) < 0 then
                Maps.Add(Map.MapName);
            end;
          end;
        end;
      end;
    end;
    //
    Order := SelectOrder(Maps);
    PrintPerm := GetPrintPermission(Maps, Order);
    if PrintPerm = ppDenied then
    begin
      MessageBox(Handle, 'Печать запрещена!'#13#10'Обратитесь к администратору!', 'Внимание!', MB_OK + MB_ICONSTOP);
    end
    else
    begin
      ShowWatermarkLayer(ppWaterMark = PrintPerm);
      //
      mstPrintModule.DoPrintReport();
      if Maps.Count > 0 then
        mstClientAppModule.MapsPrinted(Maps, Order);
    end;
  finally
    Maps.Free;
    Pages.Free;
  end;
end;

procedure TmstClientMainForm.acReportPrintUpdate(Sender: TObject);
begin
  acReportPrint.Enabled := mstClientAppModule.User.CanPrint;
end;

procedure TmstClientMainForm.acReportNumbersVisibilityExecute(Sender: TObject);
begin
  acReportNumbersVisibility.Checked := not acReportNumbersVisibility.Checked;
  mstPrintModule.ShowPageNumbers := acReportNumbersVisibility.Checked;
  DrawBox.RegenDrawing;
end;

procedure TmstClientMainForm.acReportCancelExecute(Sender: TObject);
begin
  mstPrintModule.UnprepareReport;
  mstClientAppModule.Mode := amNone;
  tbReport.Visible := False;
  DrawBox.RegenDrawing;
  CmdLine.AccuDraw.Enabled := True;
end;

procedure TmstClientMainForm.acReportContoursParamsExecute(Sender: TObject);
begin
//  mstPrintModule.DoSelectContourParams;
  DrawBox.RegenDrawing;
end;

procedure TmstClientMainForm.acReportPrinterSetUpExecute(Sender: TObject);
begin
  mstPrintModule.DoPrinterSetup;
end;

procedure TmstClientMainForm.acReportPointSizeExecute(Sender: TObject);
begin
  with TmstDialogPointSize.Create(Self) do
  try
    edSize.Text := FloatToStr(mstPrintModule.PointSize);
    if ShowModal = mrOK then
    begin
      mstPrintModule.PointSize := StrToFloat(edSize.Text);
      DrawBox.RegenDrawing;
    end;
  finally
    Free;
  end;
end;

procedure TmstClientMainForm.acReportPointSizeUpdate(Sender: TObject);
begin
  acReportPointSize.Enabled := mstPrintModule.HasLot;
end;

procedure TmstClientMainForm.acReportLotParamsExecute(Sender: TObject);
begin
  mstPrintModule.DoSelectLines;
  DrawBox.RegenDrawing;
end;

procedure TmstClientMainForm.acReportLotParamsUpdate(Sender: TObject);
begin
  acReportLotParams.Enabled := mstPrintModule.HasLot;
end;

procedure TmstClientMainForm.acReportFontExecute(Sender: TObject);
var
  Selection: TList;
  I, J: Integer;
  Layer: TEzBaseLayer;
begin
  Selection := nil;
  Layer := Self.GIS.Layers.LayerByName(SL_REPORT);
  if Assigned(Layer) then
  begin
    Selection := TList.Create;
    I := DrawBox.Selection.IndexOf(Layer);
    if I >= 0 then
      for J := 0 to Pred(DrawBox.Selection[I].SelList.Count) do
        Selection.Add(Pointer(DrawBox.Selection[I].SelList[J]));
  end;
  mstPrintModule.DoSelectFont(Selection);
  with Preferences do
  begin
    DefTTFontStyle.Name := mstPrintModule.Font.Name;
    DefTTFontStyle.Color := mstPrintModule.Font.Color;
    DefTTFontStyle.Style := mstPrintModule.Font.Style;
    DefTTFontStyle.Height := mstPrintModule.GetTextHeight;
  end;
  FreeAndNil(Selection);
  DrawBox.RegenDrawing;
end;

procedure TmstClientMainForm.acReportMovePrintAreaExecute(Sender: TObject);
begin
  CmdLine.Clear;
  FCanSelect := True;
  DrawBox.Selection.Clear;
  DrawBox.Selection.Add(GIS.Layers.LayerByName(SL_REPORT), mstPrintModule.PrintAreaId);
  FCanSelect := False;
  DrawBox.RegenDrawing;
  CmdLine.DoCommand('MOVE', 'REPORT');
end;

procedure TmstClientMainForm.acReportEditPrintAreaExecute(Sender: TObject);
begin
  CmdLine.Clear;
  DrawBox.Selection.Clear;
  DrawBox.Selection.Add(GIS.Layers.LayerByName(SL_REPORT), mstPrintModule.PrintAreaId);
  CmdLine.DoCommand('RESHAPE', 'REPORT');
end;

procedure TmstClientMainForm.DrawBoxAfterSelect(Sender: TObject; Layer: TEzBaseLayer; RecNo: Integer);
begin
  if Layer.Name = SL_PAGES then
  begin
    Layer.Recno := RecNo;
    if Layer.RecEntityID = idPage then
      mstPrintModule.SelectedPageId := RecNo;
  end;
end;

procedure TmstClientMainForm.acReportPrevPageExecute(Sender: TObject);
begin
  mstPrintModule.SelectPrevPage;
  DrawBox.RegenDrawing;
end;

procedure TmstClientMainForm.acReportNextPageExecute(Sender: TObject);
begin
  mstPrintModule.SelectNextPage;
  DrawBox.Selection.Clear;
  DrawBox.Selection.Add(Gis.Layers.LayerByName(SL_PAGES), mstPrintModule.SelectedPageId);
  DrawBox.RegenDrawing;
end;

procedure TmstClientMainForm.cbReportScaleChange(Sender: TObject);
var
  Sc: Integer;
begin
  if cbReportScale.Text = '' then
    Exit;
  Sc := StrToInt(Copy(cbReportScale.Text, 3, Length(cbReportScale.Text)));
  if Sc <> mstPrintModule.ReportScale then
  begin
    mstPrintModule.ReportScale := Sc;
    DrawBox.RegenDrawing;
  end;
end;

procedure TmstClientMainForm.PrepareSelector;
begin
  FSelector.ClearLayers;
  FSelector.ClearEntityIDs;
  if GIS.CurrentLayerName = SL_PAGES then
  begin
    FSelector.AddLayer(SL_PAGES);
    FSelector.AddEntityID(idPage);
  end
  else if GIS.CurrentLayerName = SL_REPORT then
  begin
    FSelector.AddLayer(SL_REPORT);
    FSelector.AddEntityID(idTrueTypeText);
    FSelector.AddEntityID(idRTFText);
    FSelector.AddEntityID(idTable);
  end;
end;

procedure TmstClientMainForm.DrawBoxCustomClick(Sender: TObject; X, Y: Integer; const XWorld, YWorld: Double);
var
  ActId: string;
begin
  if FDragText then
    Exit;
  if (mstClientAppModule.Mode = amPrint) and (mstPrintModule.PrintAreaId > 0) and (CursorState in [csNone, csArrow]) and (CmdLine.CurrentAction is TTheDefaultAction) then
  begin
    FCanSelect := True;
    try
      PrepareSelector;
      FSelector.DoSelect(XWorld, YWorld, DrawBox, not (ssShift in KeyboardStateToShiftState));
      DrawBox.RegenDrawing;
    finally
      FCanSelect := False;
    end;
  end
  else
  begin
    if (CursorState = csLotInfo) then
    begin
      LoadLotInfoToTree(XWorld, YWorld);
    end
    else
    if CmdLine.CurrentAction is TTheDefaultAction then
    begin
      ActId := CmdLine.CurrentAction.ActionID;
      if ActId = '' then
      if (mstClientAppModule.Mode = amNone) and (CursorState in [csNone, csArrow]) then
        LoadLotInfoToTree(XWorld, YWorld);
    end;
//    if (mstClientAppModule.Mode = amNone) and (CursorState in [csNone, csArrow]) then
//    begin
//      GetKeyboardState(KeyState);
//      Shift := KeyboardStateToShiftState(KeyState);
//      if Shift = [ssAlt] then
//        LoadLotInfoToTree(XWorld, YWorld);
//    end;
  end;
end;

procedure TmstClientMainForm.DrawBoxEndRepaint(Sender: TObject);
var
  Wtm: TWatermark;
begin
  Wtm := FWatermark;
  // добавляем водяные марки
  TWatermarkDrawer.Draw(DrawBox.ScreenBitmap, Wtm);
end;

procedure TmstClientMainForm.acReportPageVisibilityUpdate(Sender: TObject);
var
  aPage: TmstPage;
begin
  aPage := mstPrintModule.SelectedPageObject;
  if Assigned(aPage) then
  begin
    acReportPageVisibility.Enabled := True;
    if aPage.Visible then
    begin
      acReportPageVisibility.ImageIndex := 54;
      acReportPageVisibility.Hint := 'Выключить страницу';
    end
    else
    begin
      acReportPageVisibility.ImageIndex := 55;
      acReportPageVisibility.Hint := 'Включить страницу';
    end;
  end
  else
    acReportPageVisibility.Enabled := False;
end;

procedure TmstClientMainForm.acReportMoveTextUpdate(Sender: TObject);
begin
  acReportMoveText.Enabled := SelectionIsInIDSet(DrawBox, [idTrueTypeText, idRTFText, idTable])
end;

procedure TmstClientMainForm.acReportMoveTextExecute(Sender: TObject);
begin
  CmdLine.DoCommand('MOVE', 'REPORT');
end;

procedure TmstClientMainForm.acReportDeleteTextUpdate(Sender: TObject);
begin
  acReportDeleteText.Enabled := SelectionIsInIDSet(DrawBox, [idTrueTypeText]);
end;

procedure TmstClientMainForm.acReportDeleteTextExecute(Sender: TObject);
begin
  DeleteSelection;
  DrawBox.RegenDrawing;
end;

procedure TmstClientMainForm.DeleteSelection;
var
  I, J: Integer;
  Layer: TEzBaseLayer;
begin
  for I := 0 to Pred(DrawBox.Selection.Count) do
  begin
    Layer := DrawBox.Selection[I].Layer;
    for J := 0 to Pred(DrawBox.Selection[I].SelList.Count) do
    begin
      Layer.Recno := DrawBox.Selection[I].SelList[J];
      mstPrintModule.DeleteTextObject(Layer, Layer.Recno);
      Layer.DeleteEntity(DrawBox.Selection[I].SelList[J]);
    end;
  end;
  DrawBox.Selection.Clear;
end;

procedure TmstClientMainForm.DisplayMPClassSettings;
begin
  // создаём окно и показываем
  mstMPClassSettingsForm := TmstMPClassSettingsForm.Create(Self);
  mstMPClassSettingsForm.Display();
end;

function TmstClientMainForm.DoCreateProjReader: IEzProjectReader;
begin
  Result := TEzProjectReaderFactory.NewReader(False);
end;

procedure TmstClientMainForm.DoDrawBoxPopup(const X, Y: Integer; const WX, WY: Double);
var
  C: TPoint;
begin
  FdWX := WX;
  FdWY := WY;
  PreparePopupMenuItems(WX, WY, PopupMenu);
  C := DrawBox.ClientToScreen(Types.Point(X, Y));
  PopupMenu.Popup(C.X, C.Y);
end;

procedure TmstClientMainForm.DoLocateEntityInLayerBrowser;
var
  //ActId,
  ObjId: string;
  NRecNo: Integer;
  Layer: TEzBaseLayer;
begin
  if Assigned(MStLayerBrowserForm) and MStLayerBrowserForm.Visible then
  begin
    if Assigned(MStLayerBrowserForm.Layer) then
    begin
      // выбираем слой на карте
      // чпокаем в нём объекты
      // первый чпокнутый показываем в браузере
      Layer := GIS.Layers.LayerByName(MStLayerBrowserForm.Layer.Name);
      if Assigned(Layer) then
      begin
        NRecNo := PickSingleEntity(Layer, DrawBox, Point2D(WX, WY), 10);
        if NRecNo > 0 then
        begin
          Layer.Recno := NRecNo;
          Layer.DBTable.RecNo := NRecNo;
          ObjId := Layer.DBTable.FieldGet('OBJECT_ID');
          MStLayerBrowserForm.Locate(ObjId);
        end;
      end;
    end;
  end;
end;

function TmstClientMainForm.DoCreateProject: TmstProject;
begin
  Result := TmstProject.Create;
end;

procedure TmstClientMainForm.DoProjectImportExecuted(Sender: TObject; Cancelled: Boolean; aProject: TmstProject);
var
  View: TEzRect;
begin
  try
    if not Cancelled then
    begin
      // если сохранили, то сохранеям в БД и показываем в слое проектов
      aProject.Save(mstClientAppModule.MapMngr as IDb);
      TProjectUtils.AddProjectToGIS(aProject);
//      mstClientAppModule.AddLoadedProject(aProject.DatabaseId);
      //
      View := Rect2D(aProject.MinX, aProject.MinY, aProject.MaxX, aProject.MaxY);
      if aProject.CK36 then
        TEzCSConverter.Rect2DToVrn(View, False);
      DrawBox.SetViewTo(View.ymin, View.xmin, View.ymax, View.xmax);
      // если открыт список проектов, то надо его обновить
      if mstProjectBrowserForm <> nil then
      begin
        mstProjectBrowserForm.RefreshData(aProject.DatabaseId);
      end;
    end;
  finally
    DrawBox.GIS.Layers.Delete(SL_PROJECT_IMPORT, True);
    DrawBox.RegenDrawing;
  end;
end;

procedure TmstClientMainForm.DoRunAutoScroll;
var
  ScrollAction: TmstAutoHandScrollAction;
begin
  ScrollAction := TmstAutoHandScrollAction.CreateAction(CmdLine);
  ScrollAction.OnMouseDown(Self, mbLeft, Shift, X, Y, WX, WY);
  CmdLine.Push(ScrollAction, False, 'AUTOSCROLL', '');
//  CmdLine.Push(TmstAutoHandScrollAction.CreateAction(CmdLine), False, 'AUTOSCROLL', '');
end;

procedure TmstClientMainForm.DoSwitchScrollCommand;
var
  ActId: string;
begin
  FDragText := False;
  ActId := CmdLine.CurrentAction.ActionID;
  if (ActId <> 'SCROLL') and (ActId <> 'CALC') then
  begin
    CursorState := csReadyToDrag;
//    CmdLine.Clear;
    CmdLine.DoCommand('SCROLL', 'SCROLL');
  end
  else
  begin
    CursorState := csArrow;
//    CmdLine.Clear;
    DrawBox.Cursor := crDefault;
  end;
end;

procedure TmstClientMainForm.acReportAddTextExecute(Sender: TObject);
begin
  GIs.CurrentLayerName := SL_REPORT;
  CmdLine.DoCommand('TEXT', 'REPORT');
end;

procedure TmstClientMainForm.CmdLineActionChange(Sender: TObject);
begin
  if CmdLine.CurrentAction is TTheDefaultAction then
  begin
    TTheDefaultAction(CmdLine.CurrentAction).SelectDenied := True;
  end
  else
  if CmdLine.CurrentAction is TAddTextAction then
  begin
    TAddTextAction(CmdLine.CurrentAction).Scale := mstPrintModule.ReportScale;
  end
  else
  if CmdLine.CurrentAction is TEditTextAction then
  begin
    TEditTextAction(CmdLine.CurrentAction).Scale := mstPrintModule.ReportScale;
  end
  else
  if CmdLine.CurrentAction is TReshapeEntityAction then
  begin
    TReshapeEntityAction(CmdLine.CurrentAction).CurrentLayer := Gis.Layers.LayerByName(SL_REPORT);
    TReshapeEntityAction(CmdLine.CurrentAction).CurrentRecno := mstPrintModule.PrintAreaId;
  end;
end;

procedure TmstClientMainForm.acReportRotateTextUpdate(Sender: TObject);
begin
  acReportRotateText.Enabled := SelectionIsInIDSet(DrawBox, [idTrueTypeText]) and (DrawBox.Selection.NumSelected = 1);
end;

procedure TmstClientMainForm.acReportRotateTextExecute(Sender: TObject);
begin
  CmdLine.DoCommand('ROTATE', 'REPORT');
end;

procedure TmstClientMainForm.acReportPageVisibilityExecute(Sender: TObject);
var
  aPage: TmstPage;
begin
  aPage := mstPrintModule.SelectedPageObject;
  if Assigned(aPage) then
  begin
    aPage.Visible := not aPage.Visible;
    aPage.UpdateEntity;
  end;
end;

procedure TmstClientMainForm.acReportAddTextUpdate(Sender: TObject);
begin
  acReportAddText.Enabled := Gis.CurrentLayerName = SL_REPORT;
end;

procedure TmstClientMainForm.acReportEditTextUpdate(Sender: TObject);
begin
  acReportEditText.Enabled := SelectionIsInIDSet(DrawBox, [idTrueTypeText, idRTFText]) and (DrawBox.Selection.NumSelected = 1);
end;

procedure TmstClientMainForm.acReportEditTextExecute(Sender: TObject);
var
  Text: TezEntity;
  Stream: TStream;
begin
  DrawBox.Selection[0].Layer.Recno := DrawBox.Selection[0].SelList[0];
  Text := DrawBox.Selection[0].Layer.RecEntity;
  if Text.EntityID = idTrueTypeText then
    CmdLine.DoCommand('EDITTEXT', 'REPORT')
  else if Text.EntityID = idRTFText then
  begin
    with TfrmEzRichTextEditor.Create(Self) do
    try
      Stream := TMemoryStream.Create;
      Stream.Forget;
      TEzRTFText(Text).Lines.SaveToStream(Stream);
      Stream.Position := 0;
      Editor.Lines.LoadFromStream(Stream);
      if ShowModal = mrYes then
      begin
        Stream := TMemoryStream.Create;
        Stream.Forget;
        Editor.Lines.SaveToStream(Stream);
        Stream.Position := 0;
        TEzRTFText(Text).Lines.LoadFromStream(Stream);
        DrawBox.RegenDrawing;
      end;
    finally
      Free;
    end;
  end;
end;

procedure TmstClientMainForm.DebugMessage(const OwnerName, MethodName: string);
var
  Log: TStringList;
  fm: Word;
  E: Exception;
  S: string;
begin
  Log := IStringList(TStringList.Create).StringList;
  Log.Add('========================');
  Log.Add(DateTimeToStr(Now) + ': Ошибка!!!');
  Log.Add(OwnerName + ': ' + MethodName);
  Log.Add('------------------------');
  E := Exception(ExceptObject);
  Log.Add(E.Message);
  Log.Add('------------------------');
//  JclLastExceptStackListToStrings(Log, True, False, False);
  Log.Add('========================');
  S := ExtractFilePath(Application.ExeName) + 'errors.log';
  if FileExists(S) then
    fm := fmOpenWrite
  else
    fm := fmCreate;
  with TFileStream.Create(S, fm) do
  try
    Position := Size;
    S := #13#10 + Log.Text;
    Write(S[1], Length(S));
  finally
    Free;
  end;
end;

procedure TmstClientMainForm.CheckSnapsSettings;
var
  I: Integer;
  B: Boolean;
begin
  B := False;
  for I := 0 to Pred(tbSnaps.ButtonCount) do
    if tbSnaps.Buttons[I].Style = tbsButton then
      if tbSnaps.Buttons[I] <> tbAccuDraw then
        B := B or tbSnaps.Buttons[I].Down;
  CmdLine.AccuSnap.Enabled := B;
  if B then
    for I := 0 to Pred(tbSnaps.ButtonCount) do
      if tbSnaps.Buttons[I].Style = tbsButton then
        if tbSnaps.Buttons[I] <> tbAccuDraw then
          if tbSnaps.Buttons[I].Down then
          begin
            CmdLine.AccuSnap.OsnapSetting := TEzOSNAPSetting(tbSnaps.Buttons[I].Tag);
            Exit;
          end;
end;

procedure TmstClientMainForm.CloseMPBrowser;
begin
  if mstMPBrowserForm = nil then
    Exit;
  mstMPBrowserForm.Close();
end;

procedure TmstClientMainForm.CloseProjectsBrowser;
begin
  if mstProjectBrowserForm = nil then
    Exit;
  mstProjectBrowserForm.Close();
end;

procedure TmstClientMainForm.acReloadMapsExecute(Sender: TObject);
begin
  mstClientAppModule.RefreshMaps;
  DrawBox.RegenDrawing;
end;

procedure TmstClientMainForm.acReportTableSettingsExecute(Sender: TObject);
begin
  mstPrintModule.DoSelectTable;
  DrawBox.RegenDrawing;
end;

procedure TmstClientMainForm.acReportTableSettingsUpdate(Sender: TObject);
begin
  acReportTableSettings.Enabled := mstPrintModule.HasLot;
end;

procedure TmstClientMainForm.acAccuDrawExecute(Sender: TObject);
begin
  CmdLine.AccuDraw.Enabled := acAccuDraw.Checked;
end;

procedure TmstClientMainForm.TreeViewClick(Sender: TObject);
begin
  ;
end;

procedure TmstClientMainForm.acReportPageSetupExecute(Sender: TObject);
begin
  mstPrintModule.DoPageSetup;
end;

procedure TmstClientMainForm.acTreeOnOfContourUpdate(Sender: TObject);
var
  aLot: TmstLot;
  aContour: TmstLotContour;
begin
  if (mstClientAppModule.Stack.SelectedLot.DatabaseId > 0) and (mstClientAppModule.Stack.SelectedLot.ContourId > 0) then
  begin
    aLot := mstClientAppModule.GetSelectedLot;
    if Assigned(aLot) then
    begin
      acTreeOnOfContour.Enabled := True;
      aContour := aLot.Contours.GetByDatabaseId(mstClientAppModule.Stack.SelectedLot.ContourId);
      if Assigned(aContour) then
        if aContour.Enabled then
        begin
          acTreeOnOfContour.ImageIndex := 47;
          acTreeOnOfContour.Hint := 'Выключить контур';
        end
        else
        begin
          acTreeOnOfContour.ImageIndex := 35;
          acTreeOnOfContour.Hint := 'Включить контур';
        end
      else
      begin
        acTreeOnOfContour.Enabled := False;
        acTreeOnOfContour.ImageIndex := 35;
        acTreeOnOfContour.Hint := '';
      end;
    end;
  end
  else
  begin
    acTreeOnOfContour.Enabled := False;
    acTreeOnOfContour.ImageIndex := 35;
    acTreeOnOfContour.Hint := '';
  end;
end;

procedure TmstClientMainForm.acTreeOnOfContourExecute(Sender: TObject);
begin
  mstClientAppModule.Stack.OnOffCurrentContour;
end;

procedure TmstClientMainForm.acTreeRemoveCurrentExecute(Sender: TObject);
begin
  mstClientAppModule.Stack.RemoveCurrentObject;
end;

procedure TmstClientMainForm.acTreeLocateExecute(Sender: TObject);
begin
  mstClientAppModule.Stack.LocateCurrentObject;
end;

procedure TmstClientMainForm.acTreeClearExecute(Sender: TObject);
begin
  mstClientAppModule.Stack.RemoveAllObjects;
end;

procedure TmstClientMainForm.acLotPropertiesExecute(Sender: TObject);
begin
  mstClientAppModule.Stack.ViewCorrentObjectProperty;
end;

procedure TmstClientMainForm.acLotUnloadAllExecute(Sender: TObject);
begin
  mstClientAppModule.UnloadAllLots;
  DrawBox.RegenDrawing;
  TreeView.Items.Clear;
end;

procedure TmstClientMainForm.acLotUnloadAllUpdate(Sender: TObject);
begin
  acLotUnloadAll.Enabled := not mstClientAppModule.Lots.IsEmpty();
end;

end.

