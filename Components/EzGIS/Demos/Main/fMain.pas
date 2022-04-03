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
  fClipboard, fClone, fLegend, EzActionLaunch;

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
    Combine1: TMenuItem;
    Fit2: TMenuItem;
    Fit1: TMenuItem;
    Trim1: TMenuItem;
    Extend1: TMenuItem;
    Break1: TMenuItem;
    Fillet1: TMenuItem;
    ToPolyline1: TMenuItem;
    ToPolygon1: TMenuItem;
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
    N10: TMenuItem;
    Restructure1: TMenuItem;
    Pack1: TMenuItem;
    Options1: TMenuItem;
    Hints1: TMenuItem;
    Coords1: TMenuItem;
    ShowCmdLine1: TMenuItem;
    Snap1: TMenuItem;
    Snap2: TMenuItem;
    Spatial1: TMenuItem;
    Reindex1: TMenuItem;
    Layers1: TMenuItem;
    Browse1: TMenuItem;
    N11: TMenuItem;
    QuickUpdateExtension1: TMenuItem;
    Update1: TMenuItem;
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
    GIS1: TEzGIS;
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
    BtnPersist: TSpeedButton;
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
    MoveGuidelines1: TMenuItem;
    Preferences1: TEzModifyPreferences;
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
    BtnAbout: TSpeedButton;
    InsertBlock1: TMenuItem;
    BlocksEditor1: TMenuItem;
    N26: TMenuItem;
    MakeBlockFromSelection1: TMenuItem;
    Mirror1: TMenuItem;
    REPEAT1: TMenuItem;
    Drop1: TMenuItem;
    DeleteRepetitions1: TMenuItem;
    BtnGraphInfo: TSpeedButton;
    N27: TMenuItem;
    Preferences2: TMenuItem;
    N34: TMenuItem;
    ThematicsEditor1: TMenuItem;
    BtnSplineText: TSpeedButton;
    BtnSplineTextTT: TSpeedButton;
    N35: TMenuItem;
    ViewportConfig1: TMenuItem;
    GisConfig1: TMenuItem;
    LayersConfig1: TMenuItem;
    BtnDragDrop: TSpeedButton;
    BtnCustomPicture: TSpeedButton;
    ImageList1: TImageList;
    N40: TMenuItem;
    Query1: TMenuItem;
    N43: TMenuItem;
    Namedviews1: TMenuItem;
    btnArcCRSE: TSpeedButton;
    AddLayer1: TMenuItem;
    UnloadLayer1: TMenuItem;
    OpenDialog7: TOpenDialog;
    Network1: TMenuItem;
    AddNodes1: TMenuItem;
    AddNodeLinks1: TMenuItem;
    N44: TMenuItem;
    Analysis1: TMenuItem;
    N39: TMenuItem;
    Editors1: TMenuItem;
    Load1: TMenuItem;
    Load2: TMenuItem;
    LoadLinetypesFile1: TMenuItem;
    OpenDialog4: TOpenDialog;
    OpenDialog5: TOpenDialog;
    OpenDialog6: TOpenDialog;
    CADEdit1: TMenuItem;
    N14: TMenuItem;
    N15: TMenuItem;
    Zooms1: TMenuItem;
    MostCommon1: TMenuItem;
    extEntities1: TMenuItem;
    Images1: TMenuItem;
    N31: TMenuItem;
    N37: TMenuItem;
    rueTypeText1: TMenuItem;
    BannerText1: TMenuItem;
    CalloutText1: TMenuItem;
    BulletLeaderText1: TMenuItem;
    ransform1: TMenuItem;
    Move1: TMenuItem;
    Scale1: TMenuItem;
    Rotate1: TMenuItem;
    Reshape1: TMenuItem;
    InsertNode1: TMenuItem;
    DeleteNode1: TMenuItem;
    CadActions1: TMenuItem;
    PolygonClipping1: TMenuItem;
    PreserveOriginals1: TMenuItem;
    Union1: TMenuItem;
    Intersection1: TMenuItem;
    Difference1: TMenuItem;
    Split1: TMenuItem;
    Xor1: TMenuItem;
    Dim1: TMenuItem;
    DimHorizontal1: TMenuItem;
    DimVertical1: TMenuItem;
    DimParallel1: TMenuItem;
    Conversions1: TMenuItem;
    Turnoffthematics1: TMenuItem;
    EditGraphicInfo1: TMenuItem;
    BtnPriorMarker: TSpeedButton;
    BtnNextMarker: TSpeedButton;
    N3: TMenuItem;
    BlinkSelection1: TMenuItem;
    SuspendBlinking1: TMenuItem;
    Timer1: TTimer;
    N8: TMenuItem;
    EzSoftEngineeringHOMEPAGE1: TMenuItem;
    WritetoUs1: TMenuItem;
    N13: TMenuItem;
    Block1: TMenuItem;
    N16: TMenuItem;
    AccuDraw1: TMenuItem;
    ConfigureAccuDraw1: TMenuItem;
    UnrotateAccuDraw1: TMenuItem;
    ChangeAccuDrawOrigina1: TMenuItem;
    RotateAccuDraw1: TMenuItem;
    BtnSCS: TSpeedButton;
    BtnSymbolMult: TSpeedButton;
    ShowAccuSnap1: TMenuItem;
    ConfigureAccuSnap1: TMenuItem;
    AccuSnap1: TMenuItem;
    AccuDraw2: TMenuItem;
    Buffer1: TMenuItem;
    BtnRounded: TSpeedButton;
    BtnMulti: TSpeedButton;
    ScaleBar1: TEzScaleBar;
    RotateInteractively1: TMenuItem;
    ChangeRotate1: TMenuItem;
    CopyToClipboard1: TMenuItem;
    N17: TMenuItem;
    Paste2: TMenuItem;
    PasteInteractively1: TMenuItem;
    PasteAndDefinePosition1: TMenuItem;
    ClearClipboard1: TMenuItem;
    BtnView1: TSpeedButton;
    BtnView2: TSpeedButton;
    BtnView4: TSpeedButton;
    BtnView3: TSpeedButton;
    BtnView5: TSpeedButton;
    BtnView6: TSpeedButton;
    N20: TMenuItem;
    RegisterforERMapper1: TMenuItem;
    BtnERMapper: TSpeedButton;
    ERMapperLauncher: TEzActionLauncher;
    BtnSketch: TSpeedButton;
    LayerBox1: TEzLayerGridBox;
    N28: TMenuItem;
    PreloadedImages1: TMenuItem;
    procedure Exit1Click(Sender: TObject);
    procedure Layers1Click(Sender: TObject);
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
    procedure Combine1Click(Sender: TObject);
    procedure Fit2Click(Sender: TObject);
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
    procedure FormPaint(Sender: TObject);
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
    procedure BtnPersistClick(Sender: TObject);
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
    procedure DrawBox1ShowHint(Sender: TObject; Layer: TEzBaseLayer;
      Recno: Integer; var Hint: String; var ShowHint: Boolean);
    procedure MoveGuidelines1Click(Sender: TObject);
    procedure DrawBox1EntityDblClick(Sender: TObject; Layer: TEzBaseLayer;
      RecNo: Integer; var Processed: Boolean);
    procedure ConvertAutoCADDWGDXF1Click(Sender: TObject);
    procedure HotSpot1Click(Sender: TObject);
    procedure CreateThumnaillbitmap1Click(Sender: TObject);
    procedure Clippolygon1Click(Sender: TObject);
    procedure BandedTiff1Click(Sender: TObject);
    procedure InsertBlock1Click(Sender: TObject);
    procedure BlocksEditor1Click(Sender: TObject);
    procedure MakeBlockFromSelection1Click(Sender: TObject);
    procedure Mirror1Click(Sender: TObject);
    procedure GIS1AfterInsertLayer(Sender: TObject;
      const LayerName: String);
    procedure DrawBox1CustomClick(Sender: TObject; X, Y: Integer; XWorld,
      YWorld: Double);
    procedure REPEAT1Click(Sender: TObject);
    procedure Drop1Click(Sender: TObject);
    procedure DeleteRepetitions1Click(Sender: TObject);
    procedure BtnGraphInfoClick(Sender: TObject);
    procedure Preferences2Click(Sender: TObject);
    procedure ThematicsEditor1Click(Sender: TObject);
    procedure BtnSplineTextClick(Sender: TObject);
    procedure ViewportConfig1Click(Sender: TObject);
    procedure GisConfig1Click(Sender: TObject);
    procedure LayersConfig1Click(Sender: TObject);
    procedure BtnDragDropClick(Sender: TObject);
    procedure GIS1AfterDragDrop(Sender: TObject; Layer: TEzBaseLayer;
      Recno: Integer);
    procedure GIS1GisTimer(Sender: TObject; var CancelPainting: Boolean);
    procedure BtnCustomPictureClick(Sender: TObject);
    procedure Query1Click(Sender: TObject);
    procedure DrawBox1BeginRepaint(Sender: TObject);
    procedure GIS1ShowDirection(Sender: TObject; Layer: TEzBaseLayer;
      Recno: Integer; var DirectionPos: TEzDirectionPos;
      DirectionPen: TEzPenTool; DirectionBrush: TEzBrushTool;
      var RevertDirection, CanShow: Boolean);
    procedure Namedviews1Click(Sender: TObject);
    procedure btnArcCRSEClick(Sender: TObject);
    procedure AddLayer1Click(Sender: TObject);
    procedure UnloadLayer1Click(Sender: TObject);
    procedure AddNodes1Click(Sender: TObject);
    procedure AddNodeLinks1Click(Sender: TObject);
    procedure Analysis1Click(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure Load1Click(Sender: TObject);
    procedure Load2Click(Sender: TObject);
    procedure LoadLinetypesFile1Click(Sender: TObject);
    procedure PreserveOriginals1Click(Sender: TObject);
    procedure Union1Click(Sender: TObject);
    procedure Intersection1Click(Sender: TObject);
    procedure Difference1Click(Sender: TObject);
    procedure Split1Click(Sender: TObject);
    procedure Xor1Click(Sender: TObject);
    procedure Turnoffthematics1Click(Sender: TObject);
    procedure BtnPriorMarkerClick(Sender: TObject);
    procedure BtnNextMarkerClick(Sender: TObject);
    procedure FormResize(Sender: TObject);
    procedure BlinkSelection1Click(Sender: TObject);
    procedure SuspendBlinking1Click(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
    procedure EzSoftEngineeringHOMEPAGE1Click(Sender: TObject);
    procedure WritetoUs1Click(Sender: TObject);
    procedure AccuDraw1Click(Sender: TObject);
    procedure CmdLine1AccuDrawActivate(Sender: TObject);
    procedure ConfigureAccuDraw1Click(Sender: TObject);
    procedure UnrotateAccuDraw1Click(Sender: TObject);
    procedure ChangeAccuDrawOrigina1Click(Sender: TObject);
    procedure CmdLine1AccuDrawChange(Sender: TObject);
    procedure RotateAccuDraw1Click(Sender: TObject);
    procedure BtnSCSClick(Sender: TObject);
    procedure BtnSymbolMultClick(Sender: TObject);
    procedure ShowAccuSnap1Click(Sender: TObject);
    procedure CmdLine1AccuSnapChange(Sender: TObject);
    procedure ConfigureAccuSnap1Click(Sender: TObject);
    procedure Buffer1Click(Sender: TObject);
    procedure BtnRoundedClick(Sender: TObject);
    procedure BtnMultiClick(Sender: TObject);
    procedure RotateInteractively1Click(Sender: TObject);
    procedure CmdLine1AfterCommand(Sender: TObject; const Command,
      ActionID: String);
    procedure Legend1DblClick(Sender: TObject);
    procedure ChangeRotate1Click(Sender: TObject);
    procedure New1Click(Sender: TObject);
    procedure Open1Click(Sender: TObject);
    procedure Save1Click(Sender: TObject);
    procedure CopyToClipboard1Click(Sender: TObject);
    procedure Paste2Click(Sender: TObject);
    procedure PasteInteractively1Click(Sender: TObject);
    procedure ClearClipboard1Click(Sender: TObject);
    procedure PasteAndDefinePosition1Click(Sender: TObject);
    procedure BtnView1Click(Sender: TObject);
    procedure GIS1BeforePaintLayer(Sender: TObject; Layer: TEzBaseLayer;
      Grapher: TEzGrapher; var CanShow, WasFiltered: Boolean;
      var EntList: TEzEntityList; var AutoFree: Boolean);
    procedure GIS1BeforePaintEntity(Sender: TObject; Layer: TEzBaseLayer;
      Recno: Integer; Entity: TEzEntity; Grapher: TEzGrapher;
      Canvas: TCanvas; const Clip: TEzRect; DrawMode: TEzDrawMode;
      var CanShow: Boolean; var EntList: TEzEntityList;
      var AutoFree: Boolean);
    procedure GIS1AfterPaintLayer(Sender: TObject; Layer: TEzBaseLayer;
      Grapher: TEzGrapher; var EntList: TEzEntityList;
      var AutoFree: Boolean);
    procedure RegisterforERMapper1Click(Sender: TObject);
    procedure BtnERMapperClick(Sender: TObject);
    procedure ERMapperLauncherTrackedEntity(Sender: TObject;
      const TrackID: String; var TrackedEntity: TEzEntity);
    procedure BtnSketchClick(Sender: TObject);
    procedure PreloadedImages1Click(Sender: TObject);
  private
    { Private declarations }
    FFirstMap: Boolean;
    FAutoLabeling: Boolean;
    FTestBitmap: TBitmap;
    FOldWidth, FOldHeight: Integer;
    FCustomPicture: TPicture; // see OnBeforePaintEntity
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
    FfrmAccuDraw: TfrmAccuDraw;
    FfrmAddPlace: TfrmAddPlace;
    FfrmAccuSnap: TfrmAccuSnap;
    FfrmRounded: TfrmRounded;
    FfrmMultipart: TfrmMultipart;
    FfrmAutoLabel: TfrmAutoLabel;
    FfrmClipboard: TfrmClipboard;
    FfrmLegend: TfrmLegend;
{$IFDEF ER_MAPPER}
    FERMapperFileName: string;
{$ENDIF}
    procedure ClearThematicList;
    procedure LoadNamedViews;
    procedure SaveNamedViews;
    procedure FileProgress(Sender: TObject; const Filename: string;
      Progress, NoEntities, BadEntities: Integer; var CanContinue: Boolean);
    procedure WMEnterSizeMove( Var m: TMessage ); Message WM_ENTERSIZEMOVE;
    procedure WMExitSizeMove( Var m: TMessage ); Message WM_EXITSIZEMOVE;
    function GetDataPath: string;
    function GetGIS: TEzBaseGIS;
    procedure VerifySizes;
    Function IsClipboardContentValid: Boolean;
  public
    { Public declarations }
    ClonedViews: Array[0..5] Of TfrmClone;
    property LayersOptions: TEzLayersOptions read FLayersOptions;
    Property NamedViews: TEzNamedViews read FNamedViews;
    Property frmViews: TfrmViews read FfrmViews write FfrmViews;
    Property frmAerial: TfrmAerial read FfrmAerial write FfrmAerial;
    Property frmBrowse: TfrmDemoBrowse read FfrmBrowse write FfrmBrowse;
    Property frmAccuDraw: TfrmAccuDraw read FfrmAccuDraw write FfrmAccuDraw;
    Property frmAddPlace: TfrmAddPlace read FfrmAddPlace write FfrmAddPlace;
    Property frmAccuSnap: TfrmAccuSnap read FfrmAccuSnap write FfrmAccuSnap;
    Property frmRounded: TfrmRounded read FfrmRounded write FfrmRounded;
    Property frmMultipart: TfrmMultipart read FfrmMultipart write FfrmMultipart;
    Property frmAutoLabel: TfrmAutoLabel read FfrmAutoLabel write FfrmAutoLabel;
    Property frmClipboard: TfrmClipboard read FfrmClipboard write FfrmClipboard;
    Property frmLegend: TfrmLegend read FfrmLegend write FfrmLegend;
    Property GIS: TEzBaseGIS read GetGIS;
  end;

  Function DetectCancelPaint( DrawBox: TEzBaseDrawBox ): Boolean;
  Procedure ShadeIt(f: TForm; c: TControl; Width: Integer; Color: TColor);

var
  Form1: TForm1;

implementation

{$R *.dfm}

uses Math, EzGraphics,
  ezentities, ezsystem, EzPolyClip, Inifiles, fLayers, ezrtree, fSelec, EzBaseExpr,
  ezconsts, fLineTypeEd, fdemoprevw, fSymbEd, fRasterImageEd,
  fProgr, ezshpimport, EzDxfImport, EzMIFIMport, EzDGNImport,
  fLineType, fSymbolType, fFontStyle, fLayerSelect, fRestructure, fMapUnits,
  fBrushStyle, fAddEntity, fReproject, fAbout, fRichEdit, ezhtmlmap, ShellAPI,
  fBlockEd, fRepeat, fPictureDef, fPref, fThemsEditor, EzActions,
  EzMiscelEntities, fDBInspector, fGisInspector, fEditDB, fLayerInspector,
  Chart, Series, TeEngine, fDGNImport, fDxfImport, EzNetwork,
  fNetwork, EzDGNLayer, fAccuDrawSetts, fAccuSnapSetts, fExpressBuilder,
  fVectorialExpr, fSpatialQuery, fDGNExport, EzScrLex, EzScryacc, EzSDLImport
{$IFDEF ER_MAPPER}
  , Registry, EzERMapper
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

procedure ShadeIt(f: TForm; c: TControl; Width: Integer; Color: TColor);
var
  rect: TRect;
  old: TColor;
begin
  exit;
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

function TForm1.GetGIS: TEzBaseGIS;
begin
  Result:= GIS1;
end;

procedure TForm1.Exit1Click(Sender: TObject);
begin
  CmdLine1.Clear;
  Close;
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

procedure TForm1.BtnHandClick(Sender: TObject);
begin
  CmdLine1.Clear;
  CmdLine1.DoCommand('SCROLL','');
end;

procedure TForm1.BtnEditDBClick(Sender: TObject);
begin

  EditDBParentHWND:= Self.Handle;

  TfrmEditDB.Create(Nil).Enter(CmdLine1, nil);

  {CmdLine1.Clear;
  { EDITDB - command }
  //CmdLine1.Push( TEditDBAction.CreateAction( CmdLine1 ), false, 'EDITDB', 'EDITDB_KEY' ); }
end;

procedure TForm1.BtnZoomRTClick(Sender: TObject);
begin
  CmdLine1.Clear;
  { change following to 'REALTIMEZOOM' for a vectorized version }
  { change following to 'REALTIMEZOOMB' for a bitmapped version }
  CmdLine1.DoCommand('REALTIMEZOOM','');
end;

procedure TForm1.ZoomWBtnClick(Sender: TObject);
begin
  CmdLine1.Clear;
  CmdLine1.DoCommand('ZOOMWIN','');
end;

procedure TForm1.ZoomAllClick(Sender: TObject);
begin
  DrawBox1.ZoomToExtension;
end;

procedure TForm1.PriorViewBtnClick(Sender: TObject);
begin
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
  CmdLine1.Clear;
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
  CmdLine1.Clear;
  CmdLine1.DoCommand( 'POINT', '' );
end;

procedure TForm1.BtnLineClick(Sender: TObject);
begin
  CmdLine1.DoCommand( 'LINE', '' );
end;

procedure TForm1.BtnPolylineClick(Sender: TObject);
begin
  CmdLine1.Clear;
  CmdLine1.DoCommand( 'PLINE', '' );
end;

procedure TForm1.BtnPolygonClick(Sender: TObject);
begin
  CmdLine1.Clear;
  CmdLine1.DoCommand( 'POLYGON', '' );
end;

procedure TForm1.BtnRectClick(Sender: TObject);
begin
  CmdLine1.Clear;
  CmdLine1.DoCommand('RECTANGLE','');
end;

procedure TForm1.BtnArcClick(Sender: TObject);
begin
  CmdLine1.Clear;
  CmdLine1.DoCommand('ARC','');
end;

procedure TForm1.BtnEllipseClick(Sender: TObject);
begin
  CmdLine1.Clear;
  CmdLine1.DoCommand('ELLIPSE','');
end;

procedure TForm1.BtnSplineClick(Sender: TObject);
begin
  CmdLine1.Clear;
  CmdLine1.DoCommand('SPLINE','');
end;

procedure TForm1.btnJustTextClick(Sender: TObject);
begin
  VerifySizes;
  CmdLine1.Clear;
  CmdLine1.DoCommand('JUSTIFTEXT','');
end;

procedure TForm1.btnFittedTextClick(Sender: TObject);
begin
  VerifySizes;
  CmdLine1.Clear;
  CmdLine1.DoCommand('FITTEDTEXT','');
end;

procedure TForm1.BtnBannerTextClick(Sender: TObject);
begin
  VerifySizes;
  CmdLine1.Clear;
  CmdLine1.DoCommand('BANNER','');
end;

procedure TForm1.btnCalloutClick(Sender: TObject);
begin
  VerifySizes;
  CmdLine1.Clear;
   CmdLine1.DoCommand('CALLOUTTEXT','');
end;

procedure TForm1.btnBulletLeaderClick(Sender: TObject);
begin
  VerifySizes;
  CmdLine1.Clear;
   CmdLine1.DoCommand('BULLETLEADER','');
end;

procedure TForm1.BtnSymbolClick(Sender: TObject);
begin
  VerifySizes;
  CmdLine1.Clear;
  CmdLine1.DoCommand('SYMBOL', 'CUSTOMERS');  // dummy stateID
end;

procedure TForm1.BtnTxtPlaceClick(Sender: TObject);
begin
  VerifySizes;
  CmdLine1.Clear;
  CmdLine1.DoCommand('TEXTSYMBOL', '');
end;

procedure TForm1.BtnPicClick(Sender: TObject);
begin
  CmdLine1.Clear;
  CmdLine1.DoCommand('PICTUREREF','');
end;

procedure TForm1.BtnAutoLabelClick(Sender: TObject);
begin
  if FfrmAutoLabel=Nil then
  begin
    FfrmAutoLabel:= TfrmAutoLabel.Create(Nil);
    FfrmAutoLabel.Show;
    DrawBox1.SetFocus;
  end else
    FreeAndNil( FfrmAutoLabel );
end;

procedure TForm1.btnDimHorzClick(Sender: TObject);
begin
  CmdLine1.Clear;
  CmdLine1.DoCommand('DIMHORZ','');
end;

procedure TForm1.btnDimVertClick(Sender: TObject);
begin
  CmdLine1.Clear;
  CmdLine1.DoCommand('DIMVERT','');
end;

procedure TForm1.btnDimParClick(Sender: TObject);
begin
  CmdLine1.Clear;
  CmdLine1.DoCommand('DIMPARALL','');
end;

procedure TForm1.BtnMoveClick(Sender: TObject);
begin
  CmdLine1.Clear;
  CmdLine1.DoCommand('MOVE','');
end;

procedure TForm1.BtnScaleClick(Sender: TObject);
begin
  CmdLine1.Clear;
  CmdLine1.DoCommand('SCALE','');
end;

procedure TForm1.BtnRotateClick(Sender: TObject);
begin
  CmdLine1.Clear;
  CmdLine1.DoCommand('ROTATE','');
end;

procedure TForm1.BtnReshapeClick(Sender: TObject);
begin
  CmdLine1.Clear;
  CmdLine1.DoCommand('RESHAPE','');
end;

procedure TForm1.BtnInsVertexClick(Sender: TObject);
begin
  CmdLine1.Clear;
  CmdLine1.DoCommand('INSERTVERTEX','');
end;

procedure TForm1.BtnDelVertexClick(Sender: TObject);
begin
  CmdLine1.Clear;
  CmdLine1.DoCommand('DELVERTEX','');
end;

procedure TForm1.HGuidesClick(Sender: TObject);
begin
  CmdLine1.Clear;
  CmdLine1.DoCommand('HGLINE','');
end;

procedure TForm1.VGuidesClick(Sender: TObject);
begin
  CmdLine1.Clear;
  CmdLine1.DoCommand('VGLINE','');
end;

procedure TForm1.FormCreate(Sender: TObject);
var
  Path, FileName: string;
begin

  FLayersOptions:= TEzLayersOptions.Create;
  FNamedViews:= TEzNamedViews.Create(DrawBox1);

  Path:= GetDataPath;
  //Path:= AddSlash(ExtractFilePath(Application.ExeName));
  if not FileExists(Path+'txt.fnt') then
  begin
    ShowMessage('No font files found !');
  end;
  Gis1.LoadFontFile( Path+'complex.fnt' );
  Gis1.LoadFontFile( Path+'txt.fnt' );
  Gis1.LoadFontFile( Path+'romanc.fnt' );
  Gis1.LoadFontFile( Path+'arial.fnt' );

  { ALWAYS load the symbols after the vectorial fonts
    because the symbols can include vectorial fonts entities and
    if the vector font is not found, then the entity will be configured
    with another font }
  Gis1.LoadSymbolsFile( Path + 'symbols.ezs' );

  // load line types
  Gis1.LoadLineTypesFile( Path + 'Linetypes.ezl' );

  { load the preferences from a file

    WARNING!!!
    If you modify preferences at design time, it will not be persistent because
    we are loading from a file here

    Comment this three lines in order to use the design time preferences }
  FileName:= ExtractFilePath(Application.ExeName) + 'Preferences.ini';
  if FileExists(FileName) then
    Preferences1.LoadFromFile(FileName);
  Preferences1.SelectionBrush.BackColor:= clNone;   // transparent filling !!!
  Preferences1.SelectionBrush.Pattern:= 3;

  drawbox1.rubberpen.color:= clBlack;

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

  FCustomPicture:= TPicture.Create;

  FThematicList:= TList.Create;

  FCurrentMarkerIndex:= -1;


  Path:= AddSlash(ExtractFilePath(Application.ExeName));
  ScaleBar1.LoadFromInifile(Path + 'Config.ini');

  DrawBox1.RubberPen.Color:= clMaroon;

  { show accusnap }
  CmdLine1.AccuSnap.OsnapSetting:= osKeyPoint;
  CmdLine1.AccuSnap.SnapDivisor:= 2;

  ShowAccuSnap1Click(Nil);

  DrawBox1.ScaleBar:= ScaleBar1;

  // defines most apropriate color for highligh
  //Ez_Preferences.SelectionBrush.ForeColor:= EzGraphics.FindContrastColor(DrawBox1.Color);

end;

procedure TForm1.Undo1Click(Sender: TObject);
begin
  If Not DrawBox1.Undo.CanUndo Then Exit;
  Screen.Cursor:= crHourglass;
  Try
    DrawBox1.Selection.Clear;
    DrawBox1.Undo.Undo;
    DrawBox1.Repaint;
  Finally
    Screen.Cursor:= crDefault;
  End;
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
  If Not DrawBox1.Undo.CanPaste Then Exit;
  DrawBox1.Undo.PasteFromClipboardTo();
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
  with TfrmLinetypes.Create(Nil) do
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
  CmdLine1.DoCommand('CUSTOMCLICK','COORDS');
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
  { if an error ocurred Repaint will not repaint the viewport but
    RegenDrawing will restore it }
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
  FCurrentMarkerIndex:= -1;
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

procedure TForm1.Combine1Click(Sender: TObject);
begin
  DrawBox1.JoinSelection(True);
end;

procedure TForm1.Fit2Click(Sender: TObject);
begin
  DrawBox1.FitSelectionToPath(true);
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
  FLayersOptions.Prepare(Gis1);
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
  If LayerBox1.ItemIndex < 0 then exit;
  { this method display always the first layer
    change as needed to display another layer (maybe by asking
    in a dialog window) }
  Browse1.Checked:= Not Browse1.Checked;
  if Browse1.Checked then
  begin
    if GIS1.Layers.Count=0 then Exit;
    { the form is automatically freed }
    BrowseParentHWND:= Self.Handle;   // the parent of the browse form;
    if FfrmBrowse = Nil then
      FfrmBrowse:= TfrmDemoBrowse.Create(Nil);
    FfrmBrowse.Enter(DrawBox1, GIS1.Layers[ LayerBox1.ItemIndex ] );
  end else
    FreeAndNil( FfrmBrowse );
end;

procedure TForm1.QuickUpdateExtension1Click(Sender: TObject);
begin
  GIS1.QuickUpdateExtension;
end;

procedure TForm1.Update1Click(Sender: TObject);
begin
  GIS1.UpdateExtension;
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
  SVectFilterSDL= 'AutoDesk MapGuide files (*.SDL)|*.SDL';
  SAllVectorFiles='All Vector files|*.SHP;*.TAB;*.MIF;*.DXF;*.DGN;*.SDL';

procedure TForm1.FileProgress(Sender: TObject; const Filename: string;
  Progress, NoEntities, BadEntities: Integer; var CanContinue: Boolean);
begin
  if not frmProgressDialog.Visible then frmProgressDialog.Show;
  frmProgressDialog.ProgressBar1.Position:= Progress;
  frmProgressDialog.Label3.Caption:=
    Format('%d Objects created. %d Objects bad', [NoEntities, BadEntities]);
  frmProgressDialog.Update;
end;

procedure TForm1.Import1Click(Sender: TObject);
const
  BaseFormats: string = '.SHP.TAB.MIF.DXF.DGN.SDL';
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
                        SVectFilterSDL  + '|' +
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
          frmProgressDialog.DispMsg.Caption:=
            Format( 'MIF Import from %s...',
                    [frmProgressDialog.GetShortDispname(OpenDialog1.FileName)] );
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
          frmProgressDialog.DispMsg.Caption:=
            Format( 'DXF Import from %s...',
                    [frmProgressDialog.GetShortDispname(OpenDialog1.FileName)] );


          DxfImport:= TEzDxfImport.Create(nil) ;
          try
            Rslt:= MessageDlg('Explode blocks?',mtConfirmation,[mbYes,mbNo,mbCancel],0);
            if Rslt=mrCancel Then Exit;
            DxfImport.ExplodeBlocks:= Rslt=mrYes;
            If Not DxfImport.ExplodeBlocks then
            begin
              Rslt:= MessageDlg('Import blocks to symbols ?',mtConfirmation,[mbYes,mbNo,mbCancel],0);
              DxfImport.ImportBlocks:= Rslt=mrYes;
            end;

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
      5:  // MapGUIDE SDL files
        begin
          With TEzSDLImport.Create(nil) do
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
    frmProgressDialog.Free;
  end;
end;

procedure TForm1.GIS1FileNameChange(Sender: TObject);
begin
  Caption:= Format('EzGIS Main Demo - %s', [GIS1.FileName]);
  LayerBox1.Gis:= Self.Gis1;
end;

procedure TForm1.FormPaint(Sender: TObject);
var
  Inifile: TInifile;
  Path, FileName: string;
begin
  if not FFirstMap then
  begin
    FFirstMap := true;
{$IFDEF FALSE}
    Path      := AddSlash(ExtractFilePath(Application.ExeName));
    Inifile   := TInifile.Create(Path + 'CONFIG.INI');
    try
      FileName:= IniFile.ReadString('MAPS','LAST_OPENED','');
      if (Length(FileName)>0) and FileExists(FileName) then
      begin
        Gis1.FileName:= FileName;
        Gis1.Open;
        FLayersOptions.LoadFromFile( ChangeFileExt(Gis1.FileName, '.opt' ) );
        DrawBox1.Repaint;
        LoadNamedViews;
      end;
    finally
      Inifile.Free;
    end;
{$ENDIF}
  end;
  { check for the scale bar invisibility condition }
  If ScaleBar1.Visible And
     ( (ScaleBar1.Left > DrawBox1.ClientWidth) Or
       ((ScaleBar1.Left + ScaleBar1.Width) < 0 ) Or
       (ScaleBar1.Top > DrawBox1.Clientheight) Or
       ((ScaleBar1.Top + ScaleBar1.Height ) < 0) ) Then
  Begin
    If ScaleBar1.ResizePosition=rpNone then
    begin
      ScaleBar1.ResizePosition:= rpLowerRight;
      ScaleBar1.Reposition;
      ScaleBar1.ResizePosition:= rpNone;
    end else
      ScaleBar1.Reposition;
  End;
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
    faerial.ParentHWND:= Self.handle;
    frmAerial:= TfrmAerial.Create(Nil);
    frmAerial.AerialView1.ParentView:= Self.DrawBox1;
  end;
  frmAerial.Show;
end;

procedure TForm1.DrawBox1ZoomChange(Sender: TObject; const Scale: Double);
begin
  StatusBar1.Panels[2].Text:= Format('1: %.4f', [DrawBox1.CurrentScale]);
  if (Gis1.Layers.Count=0) or (frmAerial=nil) then exit;
  frmAerial.AerialView1.Refresh;
end;

procedure TForm1.LineStyle1Click(Sender: TObject);
begin
  VerifySizes;
  with TfrmLineType.create(Nil) do
    try
      Enter(self.DrawBox1);
    finally
      free;
    end;
end;

procedure TForm1.SymbolStyle1Click(Sender: TObject);
begin
  VerifySizes;
  with TfrmSymbolStyle.Create(Nil) do
    try
      Enter(self.DrawBox1);
    finally
      Free;
    end;
end;

procedure TForm1.TextStyle1Click(Sender: TObject);
begin
  VerifySizes;
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
  BaseFormats = '.DXF.SHP.MIF.DGN.SDL';
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
                        SVectFilterDGN  + '|' +
                        SVectFilterSDL;
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
            DrawBox:= Self.DrawBox1;
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
                DGNExport( Self.GIS1, LayerList, SaveDialog1.FileName,
                  SeedFileName, ExplodeIt );
              finally
                Free;
              end;
          Finally
            LayerList.Free;
          End;
        End;
      4:  // SDL - MapGuide
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
        with TEzSDLExport.Create(nil) do
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
    frmProgressDialog.free;
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
  DrawBox1.Undo.Clear;  // cannot undo after this
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

procedure TForm1.Restructure1Click(Sender: TObject);
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

procedure TForm1.DrawBox1MouseMove2D(Sender: TObject; Shift: TShiftState;
  X, Y: Integer; const WX, WY: Double);
begin
  StatusBar1.Panels[1].Text := DrawBox1.CoordsToDisplayText(WX,WY);
end;

procedure TForm1.btnBandsClick(Sender: TObject);
begin
  CmdLine1.Clear;
  CmdLine1.DoCommand('BANDSBITMAP','');
end;                              

procedure TForm1.BtnPersistClick(Sender: TObject);
begin
  CmdLine1.Clear;
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
      ScaleBar1.Units:= GIS1.MapInfo.CoordsUnits;
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
      Enter(self.DrawBox1);
    finally
      free;
    end;
end;

procedure TForm1.Reproject1Click(Sender: TObject);
begin
  with TfrmReproject.create(Nil) do
    try
      Enter(Self.Gis1);
    finally
      free;
    end;
end;

procedure TForm1.DrawBox1GridError(Sender: TObject);
begin
  StatusBar1.Panels[0].Text := 'Grid too dense to display';
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

procedure TForm1.DrawBox1ShowHint(Sender: TObject; Layer: TEzBaseLayer;
  Recno: Integer; var Hint: String; var ShowHint: Boolean);
var
  lo: TEzLayerOptions;
begin
  lo:= FLayersOptions.LayerByName( Layer.Name );
  if (lo = nil) or not lo.HintActive or not Assigned(lo.HintExpr) then Exit;
  Layer.Recno:= Recno;
  Layer.Synchronize;
  Hint:= lo.HintExpr.Expression.AsString;
  ShowHint:= true;
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

procedure TForm1.InsertBlock1Click(Sender: TObject);
begin
  CmdLine1.DoCommand('INSERT','');
end;

procedure TForm1.BlocksEditor1Click(Sender: TObject);
begin
  with TfrmBlocks.Create(Nil) do
    try
      showmodal;
    finally
      free;
    end;
end;

procedure TForm1.MakeBlockFromSelection1Click(Sender: TObject);
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

procedure TForm1.Mirror1Click(Sender: TObject);
begin
  CmdLine1.DoCommand('MIRROR','');
end;

procedure TForm1.GIS1AfterInsertLayer(Sender: TObject;
  const LayerName: String);
begin
  LayerBox1.Gis:= Self.Gis1; // causes to repopulate the list
end;

procedure TForm1.DrawBox1CustomClick(Sender: TObject; X, Y: Integer;
  XWorld, YWorld: Double);
var
  ShowText: string;
begin
  // copy the coords to the clipboard and show on a dialog box
  ShowText:= Format('Clicked on (%.*n, %.*n)',
    [DrawBox1.NumDecimals, XWorld,
     DrawBox1.NumDecimals, YWorld]);
  Clipboard.AsText:= ShowText;
//   ShowMessage(ShowText);
end;

procedure TForm1.REPEAT1Click(Sender: TObject);
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

procedure TForm1.Drop1Click(Sender: TObject);
var
  NumRepeat: Integer;
begin
  NumRepeat:= StrToInt(InputBox('DROP command', 'Duplicates :', IntToStr(DrawBox1.DropRepeat) ));
  if NumRepeat < 1 then Exit;
  DrawBox1.DropRepeat:= NumRepeat;
  CmdLine1.DoCommand('DROP', '');
end;

procedure TForm1.DeleteRepetitions1Click(Sender: TObject);
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

procedure TForm1.BtnGraphInfoClick(Sender: TObject);
begin
  { defines the parent of the inspector form. Take a look at fInspector.pas }
  InspParentHWND:= Self.Handle;

  TfrmInspector.Create(Nil).Enter(CmdLine1);

  { start the action for the inspector }
  {CmdLine1.Clear;
  CmdLine1.Push(TEditGraphicPropsAction.CreateAction(CmdLine1), True, '',''); }
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

procedure TForm1.ThematicsEditor1Click(Sender: TObject);
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
      If ( Enter( Self.DrawBox1, ABuilder ) = mrOk ) And ABuilder.ShowThematic then
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

          Self.DrawBox1.Repaint;

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
  begin
    DrawBox1.EndUpdate;
    ScaleBar1.Reposition;
  end;
end;

procedure TForm1.ViewportConfig1Click(Sender: TObject);
begin
  with TfrmDBInspector.Create(Nil) do
    try
      Enter( Self.DrawBox1 );
    finally
      Free;
    end;
end;

procedure TForm1.GisConfig1Click(Sender: TObject);
begin
  with TfrmGisInspector.Create(Nil) do
    try
      enter(Self.Gis1);
    finally
      free;
    end;
end;

procedure TForm1.LayersConfig1Click(Sender: TObject);
begin
  with TfrmLayerInspector.create(nil) do
    try
      enter(self.gis1);
    finally
      free;
    end;
end;

procedure TForm1.BtnDragDropClick(Sender: TObject);
begin
  CmdLine1.Clear;
  CmdLine1.DoCommand('DRAG&DROP', '');
end;

procedure TForm1.GIS1AfterDragDrop(Sender: TObject; Layer: TEzBaseLayer;
  Recno: Integer);
begin
  ShowMessage( Format('Dragged entity in Layer : %s, RecNo: %d', [Layer.Name, Recno] ) );
end;

procedure TForm1.GIS1GisTimer(Sender: TObject;
  var CancelPainting: Boolean);
Begin
  CancelPainting:= DetectCancelPaint( DrawBox1 );
end;

procedure TForm1.BtnCustomPictureClick(Sender: TObject);
begin
  CmdLine1.Clear;
  CmdLine1.DoCommand('CUSTOMPICTURE','');
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

(*   If FAutoLabeling Then
  Begin
    Captions.Text:= 'Sample auto-label';
    //SmartShowing:= False;
    TrueType:= True;
    If Entity is TEzClosedEntity Then
      Position:= lpCenter
    Else If Entity.EntityID In [idPlace, idPoint] Then
      Position:= lpCenterDown
    Else If Entity is TEzOpenedEntity Then
    Begin
      Position:= lpCenter;
      AlignLabels:= True;
      RepeatInSegments:= False;
    End;
    LabelsFont.Height := Grapher.PointsToDistY(12);
    Accept:= True;
  End Else
  Begin
    Accept:= false;
    if (Flo=nil) or not Flo.LabelingActive Or Not Assigned( Flo.LabelingExpr) Or
      Not Assigned( Flo.LabelingExpr.Expression) then Exit;
    Layer.Recno:= Recno;
    Layer.Synchronize;
    Captions.Text:= Flo.LabelingExpr.Expression.AsString;
    AlignLabels:= Flo.AlignLabels;
    RepeatInSegments:= Flo.RepeatInSegments;
    SmartShowing:= Flo.SmartShowing;
    TrueType:= Flo.TrueType;
    Position:= Flo.LabelPos;
    LabelsFont.Assign( Flo.LabelsFont );
    if Flo.LabelsKeepSameFontSize then
      { change from fixed points to real size}
      LabelsFont.Height := Grapher.PointsToDistY(Flo.LabelsFont.Height);
    Accept:= True;
  End;

  {if Entity.EntityID = idPolyline then
  begin
    SmartShowing:= true;
    LabelsFont.Name := 'Arial';
    LabelsFont.Height:= Grapher.PointsToDistY(16);
    LabelsFont.Style:= [];
    LabelsFont.Color:= clNavy;
    AlignLabels:= true;
    TrueType := true;
    Accept:= true;
    Captions.Text:= 'Luis Alfonso Moreno Arvayo';
  end;}
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
*)
procedure TForm1.LoadNamedViews;
Begin
  if Length(Gis1.FileName) > 0 then
    FNamedViews.LoadFromFile( ChangeFileExt(Gis1.FileName,'.vws') );
End;

procedure TForm1.SaveNamedViews;
Begin
  if Length(Gis1.FileName) > 0 then
    FNamedViews.SaveToFile( ChangeFileExt(Gis1.FileName,'.vws') );
End;

procedure TForm1.DrawBox1BeginRepaint(Sender: TObject);
begin
  FLayersOptions.Prepare(Gis1);
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

procedure TForm1.Namedviews1Click(Sender: TObject);
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

procedure TForm1.btnArcCRSEClick(Sender: TObject);
begin
  CmdLine1.Clear;
  CmdLine1.DoCommand('ARCSE','');
end;

procedure TForm1.AddLayer1Click(Sender: TObject);
begin
  if not OpenDialog7.Execute then Exit;
  if Gis1.Layers.IndexOfName( ExtractFileName( OpenDialog7.FileName ) ) >=0 then
    raise Exception.Create( 'Layer already exists !' );
  Gis1.Layers.Add( ChangeFileExt(OpenDialog7.FileName,''), ltDesktop );
  Gis1.Layers[Gis1.Layers.Count-1].Open;
  Gis1.RepaintViewports;
end;

procedure TForm1.UnloadLayer1Click(Sender: TObject);
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
  LayerBox1.GIS:= Nil;
  LayerBox1.GIS:= GIS1; // causes to refresh its contents
end;

procedure TForm1.AddNodes1Click(Sender: TObject);
begin
  CmdLine1.Clear;
  CmdLine1.DoCommand('NODE', '');
end;

procedure TForm1.AddNodeLinks1Click(Sender: TObject);
begin
  CmdLine1.Clear;
  CmdLine1.DoCommand('NODELINK', '');
end;

procedure TForm1.Analysis1Click(Sender: TObject);
begin
  TfrmNetwork.create(Application).Enter;
end;

procedure TForm1.FormDestroy(Sender: TObject);
var
  Inifile: TInifile;
  FileName, Path: string;
  I: Integer;
begin
  { clean the clipboard from possible data left there }
  DrawBox1.Undo.Clear;

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

  FCustomPicture.Free;

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
  ScaleBar1.SaveToInifile(Path + 'Config.ini');

end;

procedure TForm1.Load1Click(Sender: TObject);
var
  Path: string;
begin
  Path:= GetDataPath;
  OpenDialog4.FileName:= Path + '*.fnt';
  if not OpenDialog4.Execute then Exit;
  Gis1.LoadFontFile( Path + ExtractFileName(OpenDialog4.FileName) );
end;

procedure TForm1.Load2Click(Sender: TObject);
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

function TForm1.GetDataPath: string;
begin
  Result:= AddSlash(ExtractFilePath(ExpandFilename('..\..\data\txt.fnt')))
end;

procedure TForm1.LoadLinetypesFile1Click(Sender: TObject);
var
  Path: string;
begin
  Path:= GetDataPath;
  OpenDialog6.FileName:= Path + '*.ezl';
  if not OpenDialog6.Execute then Exit;
  Gis1.LoadLineTypesFile( Path + ExtractFileName(OpenDialog6.FileName) );
end;

procedure TForm1.PreserveOriginals1Click(Sender: TObject);
begin
  PreserveOriginals1.Checked:= Not PreserveOriginals1.Checked;
  Gis1.PolygonClipOperation.PreserveOriginals:= PreserveOriginals1.Checked;
end;

procedure TForm1.Union1Click(Sender: TObject);
begin
  Gis1.PolygonClipOperation.Operation:= pcUnion;
  CmdLine1.Clear;
  CmdLine1.DoCommand('CLIP','');
end;

procedure TForm1.Intersection1Click(Sender: TObject);
begin
  Gis1.PolygonClipOperation.Operation:= pcInt;
  CmdLine1.Clear;
  CmdLine1.DoCommand('CLIP','');
end;

procedure TForm1.Difference1Click(Sender: TObject);
begin
  Gis1.PolygonClipOperation.Operation:= pcDiff;
  CmdLine1.Clear;
  CmdLine1.DoCommand('CLIP','');
end;

procedure TForm1.Split1Click(Sender: TObject);
begin
  Gis1.PolygonClipOperation.Operation:= pcSplit;
  CmdLine1.Clear;
  CmdLine1.DoCommand('CLIP','');
end;

procedure TForm1.Xor1Click(Sender: TObject);
begin
  Gis1.PolygonClipOperation.Operation:= pcXor;
  CmdLine1.Clear;
  CmdLine1.DoCommand('CLIP','');
end;

procedure TForm1.Turnoffthematics1Click(Sender: TObject);
begin
  ClearThematicList;
  If Assigned(FfrmLegend) Then
    FreeAndNil( FfrmLegend );
  DrawBox1.Repaint;
end;

procedure TForm1.ClearThematicList;
var
  I: Integer;
begin
  for I:= 0 to FThematicList.Count-1 do
    TEzThematicBuilder( FThematicList[I] ).Free;
  FThematicList.Clear;
end;

procedure TForm1.BtnPriorMarkerClick(Sender: TObject);
begin
  if Drawbox1.TempEntities.Count = 0 then Exit;
  Dec( FCurrentMarkerIndex );
  if FCurrentMarkerIndex < 0 then FCurrentMarkerIndex:= 0;
  if FCurrentMarkerIndex > Drawbox1.TempEntities.Count-1 then
    FCurrentMarkerIndex:= Drawbox1.TempEntities.Count-1;
  Drawbox1.SetEntityInView( Drawbox1.TempEntities[FCurrentMarkerIndex], False );
end;

procedure TForm1.BtnNextMarkerClick(Sender: TObject);
begin
  if Drawbox1.TempEntities.Count = 0 then Exit;
  Inc( FCurrentMarkerIndex );
  if FCurrentMarkerIndex > Drawbox1.TempEntities.Count-1 then
    FCurrentMarkerIndex:= Drawbox1.TempEntities.Count-1;
  Drawbox1.SetEntityInView( Drawbox1.TempEntities[FCurrentMarkerIndex], False );
end;

procedure TForm1.FormResize(Sender: TObject);
begin
  Self.Invalidate;
end;

{ check that text height, symbol height is not big enough}
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

End;

procedure TForm1.BlinkSelection1Click(Sender: TObject);
var
  I,L: Integer;
  SelLayer: TEzSelectionLayer;
begin
  Timer1.Enabled:= False;
  if DrawBox1.Selection.Count=0 then exit;
  For L:= 0 to GIS1.Layers.Count-1 Do
    GIS1.Layers[L].ClearBlinkers;
  For I:= 0 to DrawBox1.Selection.Count-1 do
  begin
    SelLayer:= DrawBox1.Selection[I];
    { assign one integer list (the selection) to other integer list (list of blinkers) }
    SelLayer.Layer.Blinkers.Assign( SelLayer.SelList );
  end;
  DrawBox1.Selection.Clear;
  DrawBox1.Repaint;
  Timer1.Enabled:= True;
end;

procedure TForm1.SuspendBlinking1Click(Sender: TObject);
var
  L: Integer;
begin
  Timer1.Enabled:= False;
  For L:= 0 to GIS1.Layers.Count-1 Do
    GIS1.Layers[L].ClearBlinkers;
end;

procedure TForm1.Timer1Timer(Sender: TObject);
begin
  Timer1.Enabled:= False;
  DrawBox1.BlinkEntities;
  Timer1.Enabled:= true;
end;

procedure JumpToURL(const s : string);
begin
  ShellExecute(Application.Handle, nil, PChar(s), nil, nil, SW_SHOW);
end;

procedure TForm1.EzSoftEngineeringHOMEPAGE1Click(Sender: TObject);
begin
  JumpToURL( 'http://www.ezgis.com' );
end;

procedure TForm1.WritetoUs1Click(Sender: TObject);
begin
  JumpToURL( 'mailto: support@ezgis.com' );
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
  end else if Assigned(frmAccuDraw) then
    FreeAndNil(FfrmAccuDraw);
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

procedure TForm1.ConfigureAccuDraw1Click(Sender: TObject);
begin
  with TfrmAccuDrawSetts.create(nil) do
    try
      if (Enter(Self.CmdLine1)=mrOk) and Self.CmdLine1.AccuDraw.Enabled then
        DrawBox1.Refresh;
    finally
      free;
    end;
end;

procedure TForm1.UnrotateAccuDraw1Click(Sender: TObject);
begin
  If Not CmdLine1.AccuDraw.Showing Then Exit;
  CmdLine1.AccuDraw.ShowUnrotated;
end;

procedure TForm1.ChangeAccuDrawOrigina1Click(Sender: TObject);
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

procedure TForm1.RotateAccuDraw1Click(Sender: TObject);
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

procedure TForm1.BtnSCSClick(Sender: TObject);
begin
  CmdLine1.Clear;
  CmdLine1.DoCommand('ARCFCS','');
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

procedure TForm1.ConfigureAccuSnap1Click(Sender: TObject);
begin
  with TfrmAccuSnapSetts.create(nil) do
    try
      If (enter(Self.CmdLine1)=mrOk) And Assigned(FfrmAccuSnap) Then
        FfrmAccuSnap.Reset;
    finally
      free;
    end;
end;

procedure TForm1.Buffer1Click(Sender: TObject);
begin
  CmdLine1.DoCommand('POLYGONBUFFER','');
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

procedure TForm1.RotateInteractively1Click(Sender: TObject);
begin
  If CmdLine1.CurrentAction Is TRotateAccuDrawAction Then Exit;
  CmdLine1.Push(TRotateAccuDrawAction.CreateAction(CmdLine1),False,'','');
end;

procedure TForm1.CmdLine1AfterCommand(Sender: TObject; const Command,
  ActionID: String);
begin
  If ActionID='AUTOLABELING' then
    FAutoLabeling:= False;
end;

procedure TForm1.Legend1DblClick(Sender: TObject);
begin
  ThematicsEditor1Click(Nil);
end;

procedure TForm1.ChangeRotate1Click(Sender: TObject);
begin
  Ez_Preferences.GRotatePoint:= cmdLine1.GetSnappedPoint;
  DrawBox1.Invalidate;
end;

procedure TForm1.New1Click(Sender: TObject);
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
    finally
      Free;
    end;
  end;
end;

procedure TForm1.Open1Click(Sender: TObject);
begin
  CmdLine1.Clear;
  GIS1.SaveIfModified;
  with TOpenDialog.Create(Self) do
    try
      DefaultExt:= 'EZM';
      Filter:= 'EzGIS Map Files(*.EZM)|*.EZM';
      Title:= 'Open Existing Map';
      Options:= [ofPathMustExist, ofFileMustExist];
      if not Execute then Exit;
      DrawBox1.Selection.Clear;
      GIS1.FileName:= FileName;
      GIS1.Open;
      GIS1.RepaintViewports;
      FLayersOptions.LoadFromFile( ChangeFileExt(Gis1.FileName, '.opt' ) );
      LoadNamedViews;
    finally
      Free;
    end;
end;

procedure TForm1.Save1Click(Sender: TObject);
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

procedure TForm1.CopyToClipboard1Click(Sender: TObject);
var
  I,J: Integer;
  SelLayer: TEzSelectionLayer;
  temp: string;
  Ent: TEzEntity;
  TempDecSep: Char;
begin
  if DrawBox1.Selection.Count=0 then exit;
  TempDecSep:= DecimalSeparator;
  DecimalSeparator:= '.'; // numbers always must be with this decimal separator
  temp:= '';
  Screen.Cursor:=crHourglass;
  for I:= 0 to DrawBox1.Selection.Count-1 do
  begin
    SelLayer:= DrawBox1.Selection[I];
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

Function TForm1.IsClipboardContentValid: Boolean;
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
  parser.DrawBox := DrawBox1;
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
End;

procedure TForm1.Paste2Click(Sender: TObject);
begin
  { check if contents of clipboard is valid }
  If Not IsClipboardContentValid Then Exit;
  CmdLine1.DoCommand( Clipboard.AsText, '' );
end;

procedure TForm1.PasteInteractively1Click(Sender: TObject);
begin
  If Not IsClipboardContentValid Then Exit;
  if FfrmClipboard=Nil then
  begin
    FfrmClipboard:= TfrmClipboard.Create(Nil);
    FfrmClipboard.Enter(False);
    DrawBox1.SetFocus;
  end else
    FreeAndNil( FfrmClipboard );
end;

procedure TForm1.ClearClipboard1Click(Sender: TObject);
begin
  DrawBox1.Undo.Clear(True);
end;

procedure TForm1.PasteAndDefinePosition1Click(Sender: TObject);
begin
  if FfrmClipboard=Nil then
  begin
    FfrmClipboard:= TfrmClipboard.Create(Nil);
    FfrmClipboard.Enter(True);
    DrawBox1.SetFocus;
  end else
    FreeAndNil( FfrmClipboard );
end;

procedure TForm1.BtnView1Click(Sender: TObject);
var
  Item: TEzDrawBoxItem;
Begin
  with (Sender as TSpeedButton) do
  begin
    If Assigned(ClonedViews[Tag]) Then
      FreeAndNil( ClonedViews[Tag] )
    Else
    Begin
      ClonedViews[Tag]:= TfrmClone.Create(Nil);
      ClonedViews[Tag].Tag:= Tag;
      ClonedViews[Tag].DrawBox1.GIS:= Self.GIS1;
      with ClonedViews[Tag].DrawBox1 do
      begin
        RubberPen.Assign( self.DrawBox1.RubberPen );
        NumDecimals:= self.Drawbox1.NumDecimals;
        DefaultScaleUnits:= self.Drawbox1.DefaultScaleUnits;
        NoPickFilter:=self.Drawbox1.NoPickFilter;
      end;
      Item:= self.cmdLine1.DrawBoxList.Add;
      Item.DrawBox:= ClonedViews[Tag].DrawBox1;

      ClonedViews[Tag].DrawBox1.ReSync;  // synchronize internal buffer bitmap and control's dimensions
      ClonedViews[Tag].DrawBox1.Grapher.SetViewTo(DrawBox1.Grapher.CurrentParams.VisualWindow);

      ClonedViews[Tag].Show;

    End;
  end;
end;

procedure TForm1.GIS1BeforePaintLayer(Sender: TObject; Layer: TEzBaseLayer;
  Grapher: TEzGrapher; var CanShow, WasFiltered: Boolean;
  var EntList: TEzEntityList; var AutoFree: Boolean);
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
    cs:= DrawBox1.CurrentScale;
    CanShow:= (cs >= Flo.MinZoomScale) and (cs <= Flo.MaxZoomScale);
  end;
  FCurrentScale:= DrawBox1.CurrentScale;

  For I:= 0 to FThematicList.Count-1 do
  begin
    If AnsiCompareText( TEzThematicBuilder( FThematicList[I] ).LayerName, Layer.Name) = 0 then
    begin
      TEzThematicBuilder( FThematicList[I] ).Prepare( Layer );
    end;
  end;
end;

procedure TForm1.GIS1BeforePaintEntity(Sender: TObject;
  Layer: TEzBaseLayer; Recno: Integer; Entity: TEzEntity;
  Grapher: TEzGrapher; Canvas: TCanvas; const Clip: TEzRect;
  DrawMode: TEzDrawMode; var CanShow: Boolean; var EntList: TEzEntityList;
  var AutoFree: Boolean);
var
  Chart: TChart;
  Series: TChartSeries;
  mf: TMetafile;
  cs:Double;
begin
  if Entity.EntityID = idBandsBitmap then
  begin
    TEzBandsBitmap(Entity).Alphachannel:= 0;    // try with 80
    exit;
  end;
  { this is an example of how tu draw something to a idCustomPicture entity }
  if (Entity.EntityID = idCustomPicture) and (DrawMode = dmNormal) then
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
  end;

  { Flo is assigned in event TEzGis.OnBeforePaintLayer }
  if Flo=nil then exit;

  if Flo.VisibleFilterActive and Assigned(Flo.VisibleFilterExpr) and
     (Flo.VisibleFilterExpr.Expression.ExprType = ttBoolean) then
  begin
    Layer.Recno:= Recno;
    Layer.Synchronize;
    CanShow:= Flo.VisibleFilterExpr.Expression.AsBoolean;
    if not CanShow then exit;
  end;

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
end;

procedure TForm1.GIS1AfterPaintLayer(Sender: TObject; Layer: TEzBaseLayer;
  Grapher: TEzGrapher; var EntList: TEzEntityList; var AutoFree: Boolean);
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
end;

procedure TForm1.RegisterforERMapper1Click(Sender: TObject);
{$IFDEF ER_MAPPER}
var
  Reg: TRegistry;
  KeyName: string;
  ERMapperLibLocation: string;
{$ENDIF}
begin
{$IFDEF ER_MAPPER}
  ERMapperLibLocation:= InputBox('ER Mapper DLL libraries location',
    'Location :', 'c:\Program Files\ER Mapper\ER Mapper SDK 1.0\Bin' );
  If Length(ERMapperLibLocation) = 0 then exit;
  Reg:= TRegistry.create;
  try
    Reg.RootKey:= HKEY_LOCAL_MACHINE;
    //Reg.Access:= KEY_ALL_ACCESS;
    KeyName:= '\Software\Earth Resource Mapping\' +
      ChangeFileExt( ExtractFileName(Application.ExeName), '' ) + '(libversion6.0)' ;
    If Reg.OpenKey(KeyName, True) Then
    Begin
      { register this key }
      Reg.WriteString('BASE_PATH', ERMapperLibLocation);
      Reg.CloseKey;
    End;
  finally
    Reg.free;
  end;
{$ENDIF}
end;

procedure TForm1.BtnERMapperClick(Sender: TObject);
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
      DrawBox1.RepaintRect( TrackedEntity.FBox );
    finally
      Ent.Free;
    end;
  end;
{$ENDIF}
end;

procedure TForm1.BtnSketchClick(Sender: TObject);
begin
  CmdLine1.Clear;
  CmdLine1.DoCommand( 'SKETCH', '' );
end;

procedure TForm1.PreloadedImages1Click(Sender: TObject);
begin
  with TfrmPreloaded.create(Nil) do
    try
      ShowModal;
    finally
      free;
    end;
end;

end.
