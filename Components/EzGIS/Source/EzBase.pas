Unit EzBase;

{***********************************************************}
{     EzGIS/CAD Components                                  }
{   (c) 2002 EzSoft Engineering                             }
{         All Rights Reserved                               }
{***********************************************************}

{ Miscelaneous components and other classes needed }
{$I EZ_FLAG.PAS}
Interface

Uses
  SysUtils, Windows, Classes, Graphics, Controls, EzBaseExpr, EzLib, Db;

Const
  { the width of the point in nth of an inch }
  POINT_WIDTH = 48;

Type

  TEzEntityID = ( idNone,
                  idPoint,
                  idPlace,
                  idPolyline,
                  idPolygon,
                  idRectangle,
                  idArc,
                  idEllipse,
                  idPictureRef,
                  idPersistBitmap,
                  idBandsBitmap,
                  idBandsTiff,
                  idSpline,
                  idTable,
                  idGroup,
                  idTrueTypeText,
                  idAlignedTTText,
                  idJustifVectText,
                  idFittedVectText,
                  idDimHorizontal,
                  idDimVertical,
                  idDimParallel,
                  idRtfText,
                  idBlockInsert,
                  idSplineText,
                  idCustomPicture,
                  idNode,
                  idNodeLink,
{$IFDEF ER_MAPPER}
                  idERMapper,
{$ENDIF}
                  idPreview,
                  idMap500,
                  idCadastralBlock,
                  idAxis,
                  idPrintArea,
				          idPage,
                  idRtfText2,
                  idAlignedText2,
                  idBitmapRef,
                  idSquareText
                 );

  TEzEntityIDs = Set Of TEzEntityID;

const

  NonAerialEntities = [ idNone,
                        idPictureRef,
                        idPersistBitmap,
                        idBandsBitmap,
                        idTable,
                        idJustifVectText,
                        idFittedVectText,
                        idDimHorizontal,
                        idDimVertical,
                        idDimParallel,
                        idCustomPicture,
                        idNode,
                        idNodeLink,
                        idRtfText,
                        idRtfText2,
                        idPreview ];

  TextEntities = [ idTrueTypeText,
                   idAlignedTTText, 
                   idAlignedText2, 
                   idJustifVectText,
                   idFittedVectText,
                   idRtfText,
                   idSplineText,
                   idRtfText2 ];

  ImageEntities = [idPictureRef,
                   idPersistBitmap,
                   idBandsBitmap,
                   idCustomPicture
{$IFDEF ER_MAPPER}
                   , idERMapper
{$ENDIF}
                   ];

type

  TEzTransformType = ( ttTranslate, ttRotate, ttScale, ttMirror );

  TEzDirPos = ( dpStart, dpMiddle, dpEnd );
  TEzDirectionPos = Set Of TEzDirPos;

  TEzCoordSystem = ( csCartesian, csLatLon, csProjection );

  TEzClipAreaKind = ( cpkRectangular, cpkPolygonal );

  // polygon clipping operations
  TEzPolyClipOp = ( pcDiff, // Difference
                    pcInt, // Intersection
                    pcXor, // Exclusive or
                    pcUnion, // Union
                    pcSplit ); // Split (actually pcDIFF + pcINT is performed)

  // when populating a TMapTable or TMapScript
  TEzFilterInclude = ( fiAllRecords, fiSelection, fiExcludeSelection );

  TEzDirection = ( diForward, diBackward );
  TEzOrigin = ( orEntire, orCurrRow );

  TDegMinSec = Packed Record
    Degrees: integer;
    Minutes: byte;
    Seconds: Double;
  End;

  TEzScaleUnits = ( suInches, suMms, suCms );

  TEzOutputDevice = ( odCanvas, odBitmap );

  TEzOutputDevices = Set Of TEzOutputDevice;

  { units }
  TEzCoordsUnits = ( cum, cukm, cudm, cucm, cumm, cukmi, cuin, cuft, cuyd,
    cumi, cufath, cuch, culink, cuus_in, cuus_ft, cuus_yd,
    cuus_ch, cuus_mi, cuind_yd, cuind_ft, cuind_ch, cudeg // cudeg = not used in calculations
    );

  TEzPJ_UNITS = Record
    id: PChar;
    to_meter: Double;
    name: PChar;
  End;

  { Object Snap Settings }
  TEzOSNAPSetting = ( osEndPoint, osMidPoint, osCenter, osIntersect,
    osPerpend, osTangent, osNearest, osOrigin, osParallel, osKeyPoint, osBisector );

  { for autolabeling position in event OnLabelEntity }
  TEzLabelPos = ( lpCenter, lpCenterUp, lpUpperLeft, lpUpperRight, lpCenterLeft,
    lpCenterRight, lpLowerLeft, lpCenterDown, lpLowerRight );

  { how to handle the overlapped text}
  TEzOverlappedTextAction = ( otaDoNothing, otaHideOverlapped, otaShowOverlappedOnColor );

  { Layer main file header (in desktop is used in .EZD file) }
  TEzLayerHeader = Packed Record
    HeaderID: SmallInt;
    VersionNumber: SmallInt; //100, 110, etc.
    RecordCount: Longint; {number of records in file }
    Extension: TEzRect; {max, min extensions of layer }
    IDCounter: Integer; // four bytes for next entity identifier

    Visible: Boolean;
    Selectable: Boolean;
    IsMemoryLayer: Boolean; { the layer is a memory/cosmethic layer ? }
    IsAnimationLayer: Boolean;
    IsIndexed: Boolean;
    CoordSystem: TEzCoordSystem;
    CoordsUnits: TEzCoordsUnits;
    UseAttachedDB: Boolean;
    NotUsed: Boolean;
    TextHasShadow: Boolean;
    TextFixedSize: Integer; { if > 0 the font is drawn with same size }
    OverlappedTextAction: TEzOverlappedTextAction;
    OverlappedTextColor: TColor; { the color with which the overlapped text is painted }
    Locked: Boolean;   { layer is locked: no copy,paste,insert,delete,etc.}
    NodeCount: Integer;
    NodeLinkCount: Integer;
    Reserved: Array[0..90] Of Byte; {for future use}
  End;

  TEzLayerName = String[60];

  { main map file header information file .EZM }
  TEzMapHeader = Packed Record
    HeaderID: smallint;
    VersionNumber: SmallInt;
    NumLayers: SmallInt; { num layers in map              }
    Extension: TEzRect; { max,min extents of map         }
    CurrentLayer: TEzLayerName; { the name of the active layer   }
    AerialViewLayer: TEzLayerName;
    LastView: TEzRect; {max,min of last view           }

    { Internal units of the map  }
    CoordSystem: TEzCoordSystem;
    CoordsUnits: TEzCoordsUnits; // previously ViewCoordSystem: TCoordSystem;
    IsAreaClipped: Boolean; {clip an area ?}
    AreaClipped: TEzRect; {the clipped rectangular area}
    ClipAreaKind: TEzClipAreaKind; {the kind of clipping: polygonal, rectangular or from selection}
    Reserved: Array[0..99] Of Byte; { reserved for future use }
  End;

  // for print preview
  TEzPrintMode = ( pmAll, pmSelection, pmExcludeSelection );

  TEzPreviewPresentation = ( ppQuality, ppDraft );

  // used in TEzDrawBox methods

  {  The developers guide explains the following enumeration more in depth }
  TEzGraphicOperator = ( goWithin,
                         goEntirelyWithin,
                         goContains,
                         goContainsEntire,
                         goIntersects,
                         goEntirelyWithinNoEdgeTouched,
                         goContainsEntireNoEdgeTouched,
                         goExtentOverlaps,
                         goShareCommonPoint,
                         goShareCommonLine,
                         goLineCross,
                         goCommonPointOrLineCross,
                         goEdgeTouch,
                         goEdgeTouchOrIntersect,
                         goPointInPolygon,
                         goCentroidInPolygon,
                         goIdentical );          { A is equal to B }


  TEzGraphicOperators = Set Of TEzGraphicOperator;

  {-----------------------------------------------------------------------------}
  {    Image handling class for idPictureRef entities                           }
  {-----------------------------------------------------------------------------}

  TEzGraphicLink = Class
  Private
    FBitmap: TBitmap;
  Public
    Constructor Create;
    Destructor Destroy; Override;
    Procedure ReadGeneric( Const FileName: String );
{$IFDEF JPEG_SUPPORT}
    Procedure readJPG( Const FileName: String );
    Procedure putJPG( Bitmap: TBitmap; Const FileName: String );
{$ENDIF}
    Procedure readBMP( Const FileName: String );
    Procedure putBMP( Bitmap: TBitmap; Const FileName: String );
{$IFDEF GIF_SUPPORT}
    Procedure readGIF( Const FileName: String );
    Procedure putGIF( Bitmap: TBitmap; Const FileName: String );
{$ENDIF}
    Procedure readWMF( Const FileName: String );
    Procedure putWMF( Bitmap: TBitmap; Const FileName: String );
    Procedure readEMF( Const FileName: String );
    Procedure putEMF( Bitmap: TBitmap; Const FileName: String );
    Procedure readICO( Const FileName: String );

    { properties }
    Property Bitmap: TBitmap Read FBitmap Write FBitmap;
  End;

  { ----- TEzPreferences ----- }

  { TEzPointTool }
  TEzPointTool = Class( TPersistent )
  Private
    Function GetX: double;
    Procedure SetX( Const value: double );
    Function GetY: double;
    Procedure SetY( Const value: double );
  Public
    FPoint: TEzPoint;
    Procedure LoadFromStream( Stream: TStream );
    Procedure SaveToStream( Stream: TStream );
    Procedure Assign( Source: TPersistent ); Override;
  Published
    Property X: Double Read GetX Write SetX;
    Property Y: Double Read GetY Write SetY;
  End;

  { TEzSymbolTool }
  TEzSymbolApply = set of (saIndex, saRotangle, saHeight);

  TEzSymbolTool = Class( TPersistent )
  Private
    Function GetIndex: Integer;
    Procedure SetIndex( Value: Integer );
    Function GetRotangle: Double;
    Procedure SetRotangle( Const Value: Double );
    Function GetHeight: Double;
    Procedure SetHeight( Const Value: Double );
  Public
    FSymbolStyle: TEzSymbolStyle;
    Procedure LoadFromStream( Stream: TStream );
    Procedure SaveToStream( Stream: TStream );
    Procedure Assign( Source: TPersistent ); Override;
  Published
    Property Index: Integer Read GetIndex Write SetIndex;
    Property Rotangle: Double Read GetRotangle Write SetRotangle;
    Property Height: Double Read GetHeight Write SetHeight;
  End;

  { TEzPenTool }
  TEzPenApply = set of (paStyle, paColor, paWidth);

  TEzPenTool = Class( TPersistent )
  Private
    FScale: Double;
    Function GetStyle: Integer;
    Procedure SetStyle( Value: Integer );
    Function GetColor: TColor;
    Procedure SetColor( Value: TColor );
    Function GetWidth: Double;
    Procedure SetWidth( Const Value: Double );
  Public
    FPenStyle: TEzPenStyle;
    Procedure LoadFromStream( Stream: TStream );
    Procedure SaveToStream( Stream: TStream );
    Procedure Assign( Source: TPersistent ); Override;
  Published
    Property Style: Integer Read GetStyle Write SetStyle;
    Property Color: TColor Read GetColor Write SetColor;
    Property Scale: Double Read FScale Write FScale;
    Property Width: Double Read GetWidth Write SetWidth;
  End;

  { TEzBrushTool }
  TEzBrushApply = set of (baPattern, baForeColor, baBackColor);

  TEzBrushTool = Class( TPersistent )
  Private
    Function GetPattern: Integer;
    Procedure SetPattern( Value: Integer );
    Function GetColor: TColor;
    Procedure SetColor( Value: TColor );
    Function GetAngle: Single;
    Procedure SetAngle( Const Value: Single );
    Function GetScale: Double;
    Procedure SetScale( Const Value: Double );
    Function GetBackColor: TColor;
    Function GetForeColor: TColor;
    Procedure SetBackColor( Const Value: TColor );
    Procedure SetForeColor( Const Value: TColor );
  Public
    FBrushStyle: TEzBrushStyle;
    Procedure LoadFromStream( Stream: TStream );
    Procedure SaveToStream( Stream: TStream );
    Procedure Assign( Source: TPersistent ); Override;

    { first choice is used if a hatch pattern is used }
    { second choice is used if a bitmap fill pattern is used }
    Property Color: TColor Read GetColor Write SetColor Default clblack;
    Property Scale: Double Read GetScale Write SetScale;
    Property Angle: Single Read GetAngle Write SetAngle;
  Published
    Property Pattern: Integer Read GetPattern Write SetPattern;
    Property ForeColor: TColor Read GetForeColor Write SetForeColor;
    Property BackColor: TColor Read GetBackColor Write SetBackColor;
  End;

  { TEzFontTool }
  TEzFontApply = Set Of (faName, faAngle, faHeight, faColor, faStyle);

  TEzFontTool = Class( TPersistent )
  Private
    Function GetName: String;
    Procedure SetName( Const Value: String );
    Function GetColor: TColor;
    Procedure SetCOlor( Value: TColor );
    Function GetAngle: Single;
    Procedure SetAngle( Const Value: Single );
    Function GetHeight: Double;
    Procedure SetHeight( Const Value: Double );
    Function GetStyle: TFontStyles;
    Procedure SetStyle( Const Value: TFontStyles );
  Public
    FFontStyle: TEzFontStyle;
    Constructor Create;
    Procedure LoadFromStream( Stream: TStream );
    Procedure SaveToStream( Stream: TStream );
    Procedure Assign( Source: TPersistent ); Override;
  Published
    Property Name: String Read GetName Write SetName;
    Property Angle: Single Read GetAngle Write SetAngle;
    Property Height: Double Read GetHeight Write SetHeight;
    Property Color: TColor Read GetColor Write SetColor;
    Property Style: TFontStyles Read GetStyle Write SetStyle;
  End;

  { TEzPolyClipTool}
  TEzPolyClipTool = Class( TPersistent )
  Private
    Procedure SetOperation( value: TEzPolyClipOp );
    Procedure SetPreserveOriginals( value: Boolean );
  Public
    FOperation: TEzPolyClipOp;
    FPreserveOriginals: boolean;
    Constructor Create;
    Procedure LoadFromStream( Stream: TStream );
    Procedure SaveToStream( Stream: TStream );
    Procedure Assign( Source: TPersistent ); Override;
  Published
    Property Operation: TEzPolyClipOp Read FOperation Write SetOperation Default pcUNION;
    Property PreserveOriginals: boolean Read FPreserveOriginals Write SetPreserveOriginals Default True;
  End;

  { TEzScreenGrid }
  TEzScreenGrid = Class( TPersistent )
  Private
    FColor: TColor;
    FShow: Boolean;
    FStep: TEzPointTool;
    Procedure SetStep( value: TEzPointTool );
    Procedure SetColor( value: TColor );
    Procedure SetShow( value: Boolean );
  Public
    Constructor Create;
    Destructor Destroy; Override;
    Procedure LoadFromStream( Stream: TStream );
    Procedure SaveToStream( Stream: TStream );
    Procedure Assign( Source: TPersistent ); Override;
  Published
    Property Color: TColor Read FColor Write SetColor Default clSilver;
    Property Show: Boolean Read FShow Write SetShow Default False;
    Property Step: TEzPointTool Read FStep Write SetStep;
  End;

  { TEzThematicSeriesColor }

  TEzThematicSeriesColor = Class
  Private
    FList: TList;
    Function GetItem( Index: Integer ): TColor;
    Procedure SetItem( Index: Integer; Value: TColor );
  Public
    Constructor Create;
    Destructor Destroy; Override;
    Procedure Add( Value: TColor );
    Function Count: Integer;
    Property Items[Index: Integer]: TColor Read GetItem Write SetItem; Default;
  End;

  {-----------------------------------------------------------------------------}
  {    The global map preferences                                               }
  {-----------------------------------------------------------------------------}

  TEzPreferences = Class
  Private
    { objects }
    FDefPenStyle: TEzPenTool;
    FDefBrushStyle: TEzBrushTool;
    FDefSymbolStyle: TEzSymbolTool;
    FDefFontStyle: TEzFontTool;
    FDefTTFontStyle: TEzFontTool;
    FSelectionPen: TEzPenTool;
    FSelectionBrush: TEzBrushTool;
    FPreloadedImages: TStrings;
    FPreloadedBandedImages: TStrings;
    FPreloadedBlocks: TStrings;
    FDirectionArrowSize: Double;

    { ordinal types }
    FPointEntitySize: Integer;
    FUsePreloadedBlocks: Boolean;
    FUsePreloadedImages: Boolean;
    FUsePreloadedBandedImages: Boolean;
    FBandsBitmapChunkSize: Integer;
    FControlPointsWidth: integer;
    FApertureWidth: integer;
    FMinDrawLimit: integer;
    FAerialMinDrawLimit: integer;
    FShowText: Boolean;
    FSelectPickingInside: Boolean;
    FPlineGen: Boolean;
    FSplineSegs: Integer;
    FArcSegs: Integer;
    FEllipseSegs: Integer;
    FCommonSubDir: String;
    FGNumPoint: Integer;
    FGRotatePoint: TEzPoint;
    FPatternPlotterOptimized: Boolean;
    FHintColor: TColor;
    FHintFont: TFont;

    FOnChange: TNotifyEvent;
    { object types }
    Procedure SetDefPenStyle( value: TEzPenTool );
    Procedure SetDefBrushStyle( value: TEzBrushTool );
    Procedure SetDefSymbolStyle( value: TEzSymbolTool );
    Procedure SetDefFontStyle( value: TEzFontTool );
    Procedure SetDefTTFontStyle( value: TEzFontTool );
    Procedure SetSelectionPen( value: TEzPenTool );
    Procedure SetSelectionBrush( value: TEzBrushTool );
    Procedure SetBandsBitmapChunkSize( value: Integer );
    Procedure SetCommonSubDir( Const value: String );
    Procedure SetHintFont( Value: TFont );

  Public
    { methods }
    Constructor Create;
    Destructor Destroy; Override;
    Procedure ApplyChanges;
    Procedure Assign( Source: TEzPreferences );
    Procedure LoadFromFile( Const Filename: String );
    Procedure SaveToFile( Const FileName: String );
    Procedure SetToDefault;
    Procedure AddPreloadedImage( Const FileName: String );
    Procedure AddPreloadedBandedImage( Const FileName: String );
    Procedure AddPreloadedBlock( Const FileName: String );
    Procedure DeletePreloadedImage( Const FileName: String );
    Procedure DeletePreloadedBandedImage( Const FileName: String );
    Procedure DeletePreloadedBlock( Const FileName: String );
    Procedure ClearPreloadedImages;
    Procedure ClearPreloadedBandedImages;
    Procedure ClearPreloadedBlocks;

    {properties}
    Property GRotatePoint: TEzPoint Read FGRotatePoint Write FGRotatePoint;
    Property GNumPoint: Integer Read FGNumPoint Write FGNumPoint;

    Property DirectionArrowSize: Double read FDirectionArrowSize write FDirectionArrowSize;
    Property PointEntitySize: Integer Read FPointEntitySize Write FPointEntitySize;
    Property PreloadedBlocks: TStrings Read FPreloadedBlocks;
    Property PreloadedImages: TStrings Read FPreloadedImages;
    Property PreloadedBandedImages: TStrings Read FPreloadedBandedImages;
    Property UsePreloadedBlocks: Boolean Read FUsePreloadedBlocks Write FUsePreloadedBlocks;
    Property UsePreloadedImages: Boolean Read FUsePreloadedImages Write FUsePreloadedImages;
    Property UsePreloadedBandedImages: Boolean Read FUsePreloadedBandedImages Write FUsePreloadedBandedImages;
    Property PatternPlotterOptimized: Boolean Read FPatternPlotterOptimized Write FPatternPlotterOptimized;
    Property PlineGen: Boolean Read FPlineGen Write FPlineGen;
    Property SplineSegs: Integer Read FSplineSegs Write FSplineSegs;
    Property EllipseSegs: Integer Read FEllipseSegs Write FEllipseSegs;
    Property ArcSegs: Integer Read FArcSegs Write FArcSegs;
    Property CommonSubDir: String Read FCommonSubDir Write SetCommonSubDir;
    Property BandsBitmapChunkSize: Integer Read FBandsBitmapChunkSize Write SetBandsBitmapChunkSize;
    Property DefPenStyle: TEzPenTool Read FDefPenStyle Write SetDefPenStyle;
    Property DefBrushStyle: TEzBrushTool Read FDefBrushStyle Write SetDefBrushStyle;
    Property DefSymbolStyle: TEzSymbolTool Read FDefSymbolStyle Write SetDefSymbolStyle;
    Property DefFontStyle: TEzFontTool Read FDefFontStyle Write SetDefFontStyle;
    Property DefTTFontStyle: TEzFontTool Read FDefTTFontStyle Write SetDefTTFontStyle;
    Property ShowText: boolean Read FShowText Write FShowText;
    Property SelectionPen: TEzPenTool Read FSelectionPen Write SetSelectionPen;
    Property SelectionBrush: TEzBrushTool Read FSelectionBrush Write SetSelectionBrush;
    Property ControlPointsWidth: integer Read FControlPointsWidth Write FControlPointsWidth;
    Property ApertureWidth: integer Read FApertureWidth Write FApertureWidth;
    Property MinDrawLimit: integer Read FMinDrawLimit Write FMinDrawLimit;
    Property AerialMinDrawLimit: integer Read FAerialMinDrawLimit Write FAerialMinDrawLimit;
    Property SelectPickingInside: Boolean Read FSelectPickingInside Write FSelectPickingInside;
    Property HintColor: TColor Read FHintColor Write FHintColor;
    Property HintFont: TFont Read FHintFont Write SetHintFont;
    { events }
    Property OnChange: TNotifyEvent Read FOnChange Write FOnChange;
  End;

  { TEzModifyPreferences - a bridge to the global variable
    ezsystem.Ez_Preferences: TEzPreferences }

  TEzModifyPreferences = Class( TComponent )
  Private
    FOnChange: TNotifyEvent;
    Function GetDefBrushStyle: TEzBrushTool;
    Function GetDefPenStyle: TEzPenTool;
    Function GetAerialMinDrawLimit: integer;
    Function GetApertureWidth: integer;
    Function GetArcSegs: Integer;
    Function GetBandsBitmapChunkSize: Integer;
    Function GetControlPointsWidth: integer;
    Function GetDefFontStyle: TEzFontTool;
    Function GetDefSymbolStyle: TEzSymbolTool;
    Function GetDefTTFontStyle: TEzFontTool;
    Function GetEllipseSegs: Integer;
    Function GetHintColor: TColor;
    Function GetHintFont: TFont;
    Function GetCommonSubDir: String;
    Function GetMinDrawLimit: integer;
    Function GetPatternPlotterOptimized: Boolean;
    Function GetPlineGen: Boolean;
    Function GetPointEntitySize: Integer;
    Function GetDirectionArrowSize: Double;
    function GetPreloadedBlocks: TStrings;
    Function GetPreloadedImages: TStrings;
    Function GetPreloadedBandedImages: TStrings;
    Function GetSelectionBrush: TEzBrushTool;
    Function GetSelectionPen: TEzPenTool;
    Function GetSelectPickingInside: Boolean;
    Function GetShowText: boolean;
    Function GetSplineSegs: Integer;
    function GetUsePreloadedBlocks: Boolean;
    Function GetUsePreloadedBandedImages: Boolean;
    Function GetUsePreloadedImages: Boolean;
    Procedure SetAerialMinDrawLimit( Const Value: integer );
    Procedure SetApertureWidth( Const Value: integer );
    Procedure SetArcSegs( Const Value: Integer );
    Procedure SetBandsBitmapChunkSize( Const Value: Integer );
    Procedure SetControlPointsWidth( Const Value: integer );
    Procedure SetDefBrushStyle( Const Value: TEzBrushTool );
    Procedure SetDefFontStyle( Const Value: TEzFontTool );
    Procedure SetDefPenStyle( Const Value: TEzPenTool );
    Procedure SetDefSymbolStyle( Const Value: TEzSymbolTool );
    Procedure SetDefTTFontStyle( Const Value: TEzFontTool );
    Procedure SetEllipseSegs( Const Value: Integer );
    Procedure SetHintColor( Const Value: TColor );
    Procedure SetHintFont( Const Value: TFont );
    Procedure SetCommonSubDir( Const Value: String );
    Procedure SetMinDrawLimit( Const Value: integer );
    Procedure SetPatternPlotterOptimized( Const Value: Boolean );
    Procedure SetPlineGen( Const Value: Boolean );
    Procedure SetPointEntitySize( Const Value: Integer );
    Procedure SetDirectionArrowSize(const Value: Double);
    Procedure SetSelectionBrush( Const Value: TEzBrushTool );
    Procedure SetSelectionPen( Const Value: TEzPenTool );
    Procedure SetSelectPickingInside( Const Value: Boolean );
    Procedure SetShowText( Const Value: boolean );
    Procedure SetSplineSegs( Const Value: Integer );
    Procedure SetUsePreloadedBandedImages( Const Value: Boolean );
    Procedure SetUsePreloadedImages( Const Value: Boolean );
    procedure SetUsePreloadedBlocks(const Value: Boolean);
  Public
    { methods }
    Procedure ApplyChanges;
    Procedure LoadFromFile( Const Filename: String );
    Procedure SaveToFile( Const FileName: String );
    Procedure AddPreloadedBlock( Const FileName: String );
    Procedure AddPreloadedImage( Const FileName: String );
    Procedure AddPreloadedBandedImage( Const FileName: String );
    Procedure ClearPreloadedBlocks;
    Procedure ClearPreloadedImages;
    Procedure ClearPreloadedBandedImages;

    Property PreloadedBlocks: TStrings Read GetPreloadedBlocks;
    Property PreloadedImages: TStrings Read GetPreloadedImages;
    Property PreloadedBandedImages: TStrings Read GetPreloadedBandedImages;
  Published
    {properties}
    Property PointEntitySize: Integer Read GetPointEntitySize Write SetPointEntitySize;
    Property DirectionArrowSize: Double Read GetDirectionArrowSize Write SetDirectionArrowSize;
    Property UsePreloadedBlocks: Boolean Read GetUsePreloadedBlocks Write SetUsePreloadedBlocks;
    Property UsePreloadedImages: Boolean Read GetUsePreloadedImages Write SetUsePreloadedImages;
    Property UsePreloadedBandedImages: Boolean Read GetUsePreloadedBandedImages Write SetUsePreloadedBandedImages;
    Property PatternPlotterOptimized: Boolean Read GetPatternPlotterOptimized Write SetPatternPlotterOptimized;
    Property PlineGen: Boolean Read GetPlineGen Write SetPlineGen;
    Property SplineSegs: Integer Read GetSplineSegs Write SetSplineSegs;
    Property EllipseSegs: Integer Read GetEllipseSegs Write SetEllipseSegs;
    Property ArcSegs: Integer Read GetArcSegs Write SetArcSegs;
    Property CommonSubDir: String Read GetCommonSubDir Write SetCommonSubDir;
    Property BandsBitmapChunkSize: Integer Read GetBandsBitmapChunkSize Write SetBandsBitmapChunkSize;
    Property DefPenStyle: TEzPenTool Read GetDefPenStyle Write SetDefPenStyle;
    Property DefBrushStyle: TEzBrushTool Read GetDefBrushStyle Write SetDefBrushStyle;
    Property DefSymbolStyle: TEzSymbolTool Read GetDefSymbolStyle Write SetDefSymbolStyle;
    Property DefFontStyle: TEzFontTool Read GetDefFontStyle Write SetDefFontStyle;
    Property DefTTFontStyle: TEzFontTool Read GetDefTTFontStyle Write SetDefTTFontStyle;
    Property ShowText: boolean Read GetShowText Write SetShowText;
    Property SelectionPen: TEzPenTool Read GetSelectionPen Write SetSelectionPen;
    Property SelectionBrush: TEzBrushTool Read GetSelectionBrush Write SetSelectionBrush;
    Property ControlPointsWidth: integer Read GetControlPointsWidth Write SetControlPointsWidth;
    Property ApertureWidth: integer Read GetApertureWidth Write SetApertureWidth;
    Property MinDrawLimit: integer Read GetMinDrawLimit Write SetMinDrawLimit;
    Property AerialMinDrawLimit: integer Read GetAerialMinDrawLimit Write SetAerialMinDrawLimit;
    Property SelectPickingInside: Boolean Read GetSelectPickingInside Write SetSelectPickingInside;
    Property HintColor: TColor Read GetHintColor Write SetHintColor;
    Property HintFont: TFont Read GetHintFont Write SetHintFont;
    { events }
    Property OnChange: TNotifyEvent Read FOnChange Write FOnChange;
  End;

  { TEzGridInfo }
  TEzGridInfo = Class( TPersistent )
  Private
    Procedure SetShowGrid( value: boolean );
    Procedure SetGridColor( value: TColor );
    Procedure SetGridOffset( value: TEzPointTool );
    Procedure SetGrid( value: TEzPointTool );
    Procedure SetDrawAsCross( value: boolean );
    Procedure SetSnapToGrid( value: boolean );
    Procedure SetGridSnap( value: TEzPointTool );
  Public
    { this is here for fast access}
    FShowGrid: Boolean;
    FGrid: TEzPointTool;
    FGridColor: TColor;
    FGridOffset: TEzPointTool;
    FDrawAsCross: Boolean;
    FSnapToGrid: Boolean;
    FGridSnap: TEzPointTool;

    Constructor Create;
    Destructor Destroy; Override;
    Procedure Assign( Source: TPersistent ); Override;
    Procedure LoadFromStream( Stream: TStream );
    Procedure SaveToStream( Stream: TStream );
  Published
    Property ShowGrid: Boolean Read FShowGrid Write SetShowGrid Default false;
    Property Grid: TEzPointTool Read FGrid Write SetGrid;
    Property GridColor: TColor Read FGridColor Write SetGridColor Default clBlack;
    Property GridOffset: TEzPointTool Read FGridOffset Write SetGridOffset;
    Property DrawAsCross: Boolean Read FDrawAsCross Write SetDrawAsCross Default False;
    Property SnapToGrid: Boolean Read FSnapToGrid Write SetSnapToGrid Default False;
    Property GridSnap: TEzPointTool Read FGridSnap Write SetGridSnap;
  End;


  {-------------------------------------------------------------------------------}
  {                  TEzSortField to sort with variable type columns                 }
  {-------------------------------------------------------------------------------}
  TEzSortFields = class;

  TEzSortField = Class( TObject )
  Private
    FFields: TEzSortFields;
    FDataType: TExprType;
    FDataSize: Integer;
    FDesc: Boolean;
    FBufferOffset: Integer;
    Function GetData( Buffer: Pointer ): Boolean;
    Procedure SetData( Buffer: Pointer );
  Protected
    Function GetAsString: String; Virtual; Abstract;
    Procedure SetAsString( Const Value: String ); Virtual; Abstract;
    Function GetAsFloat: double; Virtual; Abstract;
    Procedure SetAsFloat( Value: double ); Virtual; Abstract;
    Function GetAsInteger: Longint; Virtual; Abstract;
    Procedure SetAsInteger( Value: Longint ); Virtual; Abstract;
    Function GetAsBoolean: Boolean; Virtual; Abstract;
    Procedure SetAsBoolean( Value: Boolean ); Virtual; Abstract;
    Procedure SetDataType( Value: TExprType );
  Public
    Constructor Create( Fields: TEzSortFields ); Virtual;

    Property DataType: TExprType Read FDataType Write SetDataType;
    Property DataSize: Integer Read FDataSize Write FDataSize;
    Property Desc: Boolean Read FDesc Write FDesc;
    Property BufferOffset: Integer Read FBufferOffset Write FBufferOffset;

    Property AsString: String Read GetAsString Write SetAsString;
    Property AsFloat: Double Read GetAsFloat Write SetAsFloat;
    Property AsInteger: Longint Read GetAsInteger Write SetAsInteger;
    Property AsBoolean: Boolean Read GetAsBoolean Write SetAsBoolean;
  End;

  {-------------------------------------------------------------------------------}
  {                  TEzSortStringField                                              }
  {-------------------------------------------------------------------------------}

  TEzSortStringField = Class( TEzSortField )
  Private
    Function GetValue( Var Value: String ): Boolean;
  Protected
    Function GetAsString: String; Override;
    Procedure SetAsString( Const Value: String ); Override;
    Function GetAsFloat: double; Override;
    Procedure SetAsFloat( Value: double ); Override;
    Function GetAsInteger: Longint; Override;
    Procedure SetAsInteger( Value: Longint ); Override;
    Function GetAsBoolean: Boolean; Override;
    Procedure SetAsBoolean( Value: Boolean ); Override;
  Public
    Constructor Create( Fields: TEzSortFields ); Override;
  End;

  {-------------------------------------------------------------------------------}
  {                  Define TEzSortFloatField                                        }
  {-------------------------------------------------------------------------------}

  TEzSortFloatField = Class( TEzSortField )
  Protected
    Function GetAsString: String; Override;
    Procedure SetAsString( Const Value: String ); Override;
    Function GetAsFloat: double; Override;
    Procedure SetAsFloat( Value: double ); Override;
    Function GetAsInteger: Longint; Override;
    Procedure SetAsInteger( Value: Longint ); Override;
    Function GetAsBoolean: Boolean; Override;
    Procedure SetAsBoolean( Value: Boolean ); Override;
  Public
    Constructor Create( Fields: TEzSortFields ); Override;
  End;

  {-------------------------------------------------------------------------------}
  {                  Define TEzSortIntegerField                                      }
  {-------------------------------------------------------------------------------}

  TEzSortIntegerField = Class( TEzSortField )
  Protected
    Function GetAsString: String; Override;
    Procedure SetAsString( Const Value: String ); Override;
    Function GetAsInteger: Longint; Override;
    Procedure SetAsInteger( Value: Longint ); Override;
    Function GetAsFloat: double; Override;
    Procedure SetAsFloat( Value: double ); Override;
    Function GetAsBoolean: Boolean; Override;
    Procedure SetAsBoolean( Value: Boolean ); Override;
  Public
    Constructor Create( Fields: TEzSortFields ); Override;
  End;

  {-------------------------------------------------------------------------------}
  {                  Define TEzSortBooleanField                                      }
  {-------------------------------------------------------------------------------}

  TEzSortBooleanField = Class( TEzSortField )
  Protected
    Function GetAsString: String; Override;
    Procedure SetAsString( Const Value: String ); Override;
    Function GetAsBoolean: Boolean; Override;
    Procedure SetAsBoolean( Value: Boolean ); Override;
    Function GetAsInteger: Longint; Override;
    Procedure SetAsInteger( Value: Longint ); Override;
    Function GetAsFloat: double; Override;
    Procedure SetAsFloat( Value: double ); Override;
  Public
    Constructor Create( Fields: TEzSortFields ); Override;
  End;

  {-------------------------------------------------------------------------------}
  {                  Define TEzSortFields                                            }
  {-------------------------------------------------------------------------------}

  TEzSortList = Class;

  TEzSortFields = Class
    fSortList: TEzSortList;
    fItems: TList;
    Function GetCount: Integer;
    Function GetItem( Index: Integer ): TEzSortField;
  Public
    Constructor Create( SortList: TEzSortList );
    Destructor Destroy; Override;
    Function Add( DataType: TExprType ): TEzSortField;
    Procedure Clear;

    Property Count: Integer Read GetCount;
    Property Items[Index: Integer]: TEzSortField Read GetItem; Default;
    Property SortList: TEzSortList Read fSortList;
  End;

  {-------------------------------------------------------------------------------}
  {                  Define TEzSortList                                           }
  {-------------------------------------------------------------------------------}
  TEzSortList = Class( TObject )
  Private
    fFields: TEzSortFields;
    fRecNo: Integer;
    fRecordBufferSize: Integer;

    Function ActiveBuffer: PChar; Virtual; Abstract;
  Protected
    Function GetFieldData( Field: TEzSortField; Buffer: Pointer ): Boolean; Virtual; Abstract;
    Procedure SetFieldData( Field: TEzSortField; Buffer: Pointer ); Virtual; Abstract;
    Procedure SetRecno( Value: Integer );
    Function GetRecno: Integer;
    Procedure SetSourceRecno( Value: Integer ); Virtual; Abstract;
    Function GetSourceRecno: Integer; Virtual; Abstract;
    Function GetRecordCount: Integer; Virtual; Abstract;
  Public
    Constructor Create;
    Destructor Destroy; Override;
    Procedure AddField( pDataType: TExprType; pDataSize: Integer; pDescending: Boolean );
    Procedure Insert; Virtual; Abstract;
    Procedure Sort;
    Procedure Exchange( Recno1, Recno2: Integer ); Virtual; Abstract;
    Procedure Clear; Virtual; Abstract;

    Property Count: Integer Read GetRecordCount;
    Property Recno: Integer Read GetRecno Write SetRecno;
    Property SourceRecno: Integer Read GetSourceRecno Write SetSourceRecno;
    Property Fields: TEzSortFields Read fFields;
  End;

  TEzMemSortList = Class( TEzSortList )
  Private
    fBufferList: TList;
    Function ActiveBuffer: PChar; Override;
  Protected
    Function GetFieldData( Field: TEzSortField; Buffer: Pointer ): Boolean; Override;
    Procedure SetFieldData( Field: TEzSortField; Buffer: Pointer ); Override;
    Function GetRecordCount: Integer; Override;
    Procedure SetSourceRecno( Value: Integer ); Override;
    Function GetSourceRecno: Integer; Override;
  Public
    Constructor Create;
    Destructor Destroy; Override;
    Procedure Insert; Override;
    Procedure Exchange( Recno1, Recno2: Integer ); Override;
    Procedure Clear; Override;
  End;


Const
  MAX_LINETYPES = 62;
  
{ picking constants }
Const
  PICKED_NONE = -3; { no point or interior picked }
  PICKED_INTERIOR = -2; { picked inside entity (only closed entities) }
  PICKED_POINT = -1; { picked on a line segment }

  { units array constant }
  pj_units: Array[TEzCoordsUnits] Of TEzPJ_UNITS = (
    ( id:'m'      ; to_meter: 1.0; name: 'Meter' ),
    ( id:'km'     ; to_meter: 1000; name: 'Kilometer' ),
    ( id:'dm'     ; to_meter: 0.10; name: 'Decimeter' ),
    ( id:'cm'     ; to_meter: 0.01; name: 'Centimeter' ),
    ( id:'mm'     ; to_meter: 0.001; name: 'Millimeter' ),
    ( id:'kmi'    ; to_meter: 1852.0; name: 'International Nautical Mile' ),
    ( id:'in'     ; to_meter: 0.0254; name: 'International Inch' ),
    ( id:'ft'     ; to_meter: 0.3048; name: 'International Foot' ),
    ( id:'yd'     ; to_meter: 0.9144; name: 'International Yard' ),
    ( id:'mi'     ; to_meter: 1609.344; name: 'International Statute Mile' ),
    ( id:'fath'   ; to_meter: 1.8288; name: 'International Fathom' ),
    ( id:'ch'     ; to_meter: 20.1168; name: 'International Chain' ),
    ( id:'link'   ; to_meter: 0.201168; name: 'International Link' ),
    ( id:'us-in'  ; to_meter: 0.0254000508001; name: 'U.S. Surveyor''s Inch' ),
    ( id:'us-ft'  ; to_meter: 0.304800609601219; name: 'U.S. Surveyor''s Foot' ),
    ( id:'us-yd'  ; to_meter: 0.914401828803658; name: 'U.S. Surveyor''s Yard' ),
    ( id:'us-ch'  ; to_meter: 20.11684023368047; name: 'U.S. Surveyor''s Chain' ),
    ( id:'us-mi'  ; to_meter: 1609.347218694437; name: 'U.S. Surveyor''s Statute Mile' ),
    ( id:'ind-yd' ; to_meter: 0.91439523; name: 'Indian Yard' ),
    ( id:'ind-ft' ; to_meter: 0.30479841; name: 'Indian Foot' ),
    ( id:'ind-ch' ; to_meter: 20.11669506; name: 'Indian Chain' ),
    ( id:'deg'    ; to_meter: 1.0; name: 'Degrees' )
    );

Function UnitCodeFromID( Const id: String ): TEzCoordsUnits;

Procedure BitmapToWMF( Bitmap: TBitmap; MetaFile: TMetaFile );
Procedure WMFToBitmap( Bitmap: TBitmap; MetaFile: TMetaFile );

Implementation

Uses
  TypInfo, Inifiles, EzSystem, EzConsts, EzEntities, ezbasegis
{$IFDEF USE_GRAPHICEX}
  , GraphicEx
{$ENDIF}
{$IFDEF JPEG_SUPPORT}
  , Jpeg
{$ENDIF}
{$IFDEF GIF_SUPPORT}
  , GifImage
{$ENDIF}
  ;

Function UnitCodeFromID( Const ID: String ): TEzCoordsUnits;
Var
  i: TEzCoordsUnits;
  //en: String;
Begin
  result := cuM; // meter the default
  For i := Low( pj_units ) To High( pj_units ) Do
  Begin
    //en := GetEnumName( System.TypeInfo( TEzCoordsUnits ), Ord( i ) );
    If AnsiCompareText( {copy( en, 3, length( en ) )} pj_units[i].ID, ID ) = 0 Then
    Begin
      result := i;
      exit;
    End;
  End;
End;

{function UnitCodeFromName(const Name:String) : TEzCoordsUnits;
var
  i : TEzCoordsUnits;
begin
  result :=  cuM;    // meter the default
  for i :=  Low(pj_units) to High(pj_units) do
     if AnsiCompareText(pj_units[i].name,Name)=0 then
     begin
        result :=  i;
        exit;
     end;
end; }

{-------------------------------------------------------------------------------}
{                  Utilities                                                    }
{-------------------------------------------------------------------------------}

Procedure BitmapToWMF( Bitmap: TBitmap; MetaFile: TMetaFile );
Var
  MetafileCanvas: TMetafileCanvas;
Begin
  MetaFile.Width := Bitmap.Width;
  MetaFile.Height := Bitmap.Height;
  MetafileCanvas := TMetafileCanvas.CreateWithComment( MetaFile, 0, 'EzGis', 'EzGis Components' );
  Try
    BitBlt( MetafileCanvas.Handle, 0, 0, Bitmap.Width, Bitmap.Height,
      Bitmap.Canvas.Handle, 0, 0, SRCCOPY );
  Finally
    MetafileCanvas.Free;
  End;
End;

Procedure WMFToBitmap( Bitmap: TBitmap; MetaFile: TMetaFile );
Var
  B: TBitmap;
Begin
  B := TBitmap.Create;
  B.Monochrome := False;
  B.Width := MetaFile.Width;
  B.Height := MetaFile.Height;
  B.Canvas.Draw( 0, 0, MetaFile );
  Bitmap.Assign( B );
  B.Free;
End;

Function GetDeviceRes( DC: THandle ): Integer;
Var
  Noc: Integer;
Begin
  Result := 8;
  Noc := GetDeviceCaps( DC, BITSPIXEL );
  If Noc <= 4 Then
    Result := 4
  Else If Noc = 8 Then
    Result := 8
  Else If Noc >= 16 Then
    Result := 24;
End;

{-------------------------------------------------------------------------------}
{                  Implements TEzGraphicLink                                      }
{-------------------------------------------------------------------------------}

Constructor TEzGraphicLink.Create;
Begin
  Inherited Create;
  FBitmap := TBitmap.Create;
End;

Destructor TEzGraphicLink.Destroy;
Begin
  FBitmap.Free;
  Inherited Destroy;
End;

Procedure TEzGraphicLink.readWMF( Const FileName: String );
Var
  Metafile: TMetafile;
Begin
  Metafile := TMetafile.Create;
  Try
    Metafile.LoadFromFile( FileName );
    WMFToBitmap( Bitmap, Metafile );
  Finally
    Metafile.free;
  End;
End;

Procedure TEzGraphicLink.readEMF( Const FileName: String );
Begin
  readWMF( FileName );
End;

Procedure TEzGraphicLink.readICO( Const FileName: String );
Var
  TmpBitmap: TBitmap;
  Icon: TIcon;
Begin
  Icon := TIcon.Create;
  Try
    Icon.LoadFromFile( FileName );
    TmpBitmap := CreateBitmapFromIcon( Icon, clOlive );
    Bitmap.Assign( TmpBitmap );
    TmpBitmap.Free;
  Finally
    Icon.Free;
  End;
End;

Procedure TEzGraphicLink.readBMP( Const FileName: String );
Begin
  FBitmap.LoadFromFile( FileName );
End;

{$IFDEF JPEG_SUPPORT}

Procedure TEzGraphicLink.readJPG( Const FileName: String );
Var
  Jpg: TJpegImage;
  JpegStream: TStream;
Begin
  Jpg := TJpegImage.Create;
  Try
    JpegStream := TFileStream.Create( FileName, fmOpenRead Or fmShareDenyWrite );
    If Jpg.PixelFormat = jf24bit Then
      Bitmap.PixelFormat := pf24bit
    Else
      Bitmap.PixelFormat := pf8bit;
    Jpg.LoadFromStream( JpegStream );
    Jpg.PixelFormat := jf8bit;

    Bitmap.Width := Jpg.Width;
    Bitmap.Height := Jpg.Height;
    Bitmap.Canvas.Draw( 0, 0, Jpg );
  Finally
    Jpg.Free;
  End;
End;

Procedure TEzGraphicLink.putJPG( Bitmap: TBitmap; Const FileName: String );
Var
  Jpg: TJpegImage;
Begin
  Jpg := TJpegImage.Create;
  Try
    Jpg.Assign( Bitmap );
    Jpg.PixelFormat := jf24Bit;
    //Jpg.Scale:= jsQuarter;
    Jpg.Smoothing := true;
    Jpg.CompressionQuality := 50;
    Jpg.Compress;
    Jpg.SaveToFile( FileName );
  Finally
    Jpg.Free;
  End;
End;
{$ENDIF}

{$IFDEF GIF_SUPPORT}

Procedure TEzGraphicLink.readGIF( Const FileName: String );
Begin
  With TGifImage.Create Do
  Try
    LoadFromFile( FileName );
    Self.Bitmap.Assign( Bitmap );
  Finally
    Free;
  End;
End;

Procedure TEzGraphicLink.putGIF( Bitmap: TBitmap; Const FileName: String );
Var
  bmp: TBitmap;
Begin
  bmp := Bitmap;
  With TGifImage.Create Do
  Try
    Assign( bmp );
    SaveToFile( FileName );
  Finally
    Free;
  End;
End;
{$ENDIF}

Procedure TEzGraphicLink.putBMP( Bitmap: TBitmap; Const FileName: String );
Begin
  Bitmap.SaveToFile( FileName );
End;

Procedure TEzGraphicLink.putWMF( Bitmap: TBitmap; Const FileName: String );
Var
  Metafile: TMetafile;
Begin
  Metafile := TMetafile.Create;
  Try
    BitmapToWMF( Bitmap, Metafile );
    Metafile.Enhanced := false;
    Metafile.SaveToFile( FileName );
  Finally
    Metafile.free;
  End;
End;

Procedure TEzGraphicLink.putEMF( Bitmap: TBitmap; Const FileName: String );
Var
  Metafile: TMetafile;
Begin
  Metafile := TMetafile.Create;
  Try
    BitmapToWMF( Bitmap, Metafile );
    Metafile.Enhanced := True;
    Metafile.SaveToFile( FileName );
  Finally
    Metafile.free;
  End;
End;

Procedure TEzGraphicLink.ReadGeneric( Const FileName: String );
Var
  Ext: String;
  Handled: Boolean;
{$IFDEF USE_GRAPHICEX}
  GraphicClass: TGraphicExGraphicClass;
{$ENDIF}
Begin
  { release memory occupied by previous bitmap}
  FBitmap.Free;
  { and create again for avoid memory leaks }
  FBitmap := TBitmap.Create;
  Ext := AnsiLowerCase(ExtractFileExt( FileName ));
  Handled := False;
{$IFDEF JPEG_SUPPORT}
  If AnsiCompareText( Ext, '.jpg' ) = 0 Then
  Begin
    readJPG( FileName );
    Handled := True;
  End
  Else
{$ENDIF}
    If AnsiCompareText( Ext, '.bmp' ) = 0 Then
    Begin
      readBMP( FileName );
      Handled := True;
    End
{$IFDEF GIF_SUPPORT}
    Else If AnsiCompareText( Ext, '.gif' ) = 0 Then
    Begin
      readGIF( FileName );
      Handled := True;
    End
{$ENDIF}
    Else If AnsiCompareText( Ext, '.wmf' ) = 0 Then
    Begin
      readWMF( FileName );
      Handled := True;
    End
    Else If AnsiCompareText( Ext, '.emf' ) = 0 Then
    Begin
      readEMF( FileName );
      Handled := True;
    End
    Else If AnsiCompareText( Ext, '.ico' ) = 0 Then
    Begin
      readICO( FileName );
      Handled := True;
    End
      // graphicex is at last
{$IFDEF USE_GRAPHICEX}
    Else
    Begin
      GraphicClass := FileFormatList.GraphicFromContent( FileName );
      If GraphicClass <> Nil Then
      Begin
        Try
          FBitmap := GraphicClass.Create;
          FBitmap.LoadFromFile( FileName );
          Handled := True;
        Except
          Handled := False;
        End;
      End;
    End;
{$ENDIF}
  ;
  If Not Handled Then
    EzGISError( SWrongImageFormat );
End;

{ ----- TEzPreferences ----- }

{-------------------------------------------------------------------------------}
{                  Implements Tools                                             }
{-------------------------------------------------------------------------------}

{ TEzPointTool }

Procedure TEzPointTool.LoadFromStream( Stream: TStream );
Begin
  Stream.Read( FPoint, sizeof( FPoint ) );
End;

Procedure TEzPointTool.SaveToStream( Stream: TStream );
Begin
  Stream.Write( FPoint, sizeof( FPoint ) );
End;

Function TEzPointTool.GetX: double;
Begin
  result := FPoint.X;
End;

Procedure TEzPointTool.SetX( Const value: double );
Begin
  FPoint.X := value;
End;

Function TEzPointTool.GetY: double;
Begin
  result := FPoint.Y;
End;

Procedure TEzPointTool.SetY( Const value: double );
Begin
  FPoint.Y := value;
End;

Procedure TEzPointTool.Assign( Source: TPersistent );
Var
  Src: TEzPointTool Absolute Source;
Begin
  If Source Is TEzPointTool Then
    FPoint := Src.FPoint
  Else
    Inherited;
End;

{ TEzSymbolTool }

Procedure TEzSymbolTool.LoadFromStream( Stream: TStream );
Begin
  Stream.Read( FSymbolStyle, sizeof( FSymbolStyle ) );
End;

Procedure TEzSymbolTool.SaveToStream( Stream: TStream );
Begin
  Stream.Write( FSymbolStyle, sizeof( FSymbolStyle ) );
End;

Function TEzSymbolTool.GetIndex: Integer;
Begin
  result := FSymbolStyle.Index;
End;

Procedure TEzSymbolTool.SetIndex( Value: Integer );
Begin
  FSymbolStyle.Index := Value;
End;

Function TEzSymbolTool.GetRotangle: Double;
Begin
  result := FSymbolStyle.Rotangle;
End;

Procedure TEzSymbolTool.SetRotangle( Const Value: Double );
Begin
  FSymbolStyle.Rotangle := Value;
End;

Function TEzSymbolTool.GetHeight: Double;
Begin
  result := FSymbolStyle.Height;
End;

Procedure TEzSymbolTool.SetHeight( Const Value: Double );
Begin
  FSymbolStyle.Height := Value;
End;

Procedure TEzSymbolTool.Assign( Source: TPersistent );
Var
  Src: TEzSymbolTool Absolute Source;
Begin
  If Source Is TEzSymbolTool Then
    FSymbolStyle := Src.FSymbolStyle
  Else
    Inherited;
End;

{ TEzPenTool }

Procedure TEzPenTool.LoadFromStream( Stream: TStream );
var
  B: Byte;
Begin
  Stream.Read( FPenStyle, sizeof( FPenStyle ) );
  B := FPenStyle.Style;
  if B >= 100 then
  begin
    FPenStyle.Style := B - 100;
    Stream.Read(FScale, Sizeof(FScale));
  end;
End;

Procedure TEzPenTool.SaveToStream( Stream: TStream );
var
  B: Byte;
Begin
  B := FPenStyle.Style;
  if FPenStyle.Style > MAX_LINETYPES then
    FPenStyle.Style := FPenStyle.Style + 100;
  Stream.Write( FPenStyle, sizeof( FPenStyle ) );
  if B > MAX_LINETYPES then
    Stream.Write(FScale, SizeOf(FScale));
  FPenStyle.Style := B;
End;

Function TEzPenTool.GetStyle: Integer;
Begin
  result := FPenStyle.Style;
End;

Procedure TEzPenTool.SetStyle( Value: Integer );
Begin
  FPenStyle.Style := Value;
End;

Function TEzPenTool.GetColor: TColor;
Begin
  result := FPenStyle.Color;
End;

Procedure TEzPenTool.SetCOlor( Value: TColor );
Begin
  FPenStyle.Color := Value;
End;

Function TEzPenTool.GetWidth: Double;
Begin
  result := FPenStyle.Width;
End;

Procedure TEzPenTool.SetWidth( Const Value: Double );
Begin
  FPenStyle.Width := Value;
End;

Procedure TEzPenTool.Assign( Source: TPersistent );
Var
  Src: TEzPenTool Absolute Source;
Begin
  If Source Is TEzPenTool Then
  begin
    FPenStyle := Src.FPenStyle;
    FScale := FScale;
  end
  Else
    Inherited;
End;

{ TEzBrushTool }

Procedure TEzBrushTool.LoadFromStream( Stream: TStream );
Begin
  Stream.Read( FBrushStyle, sizeof( FBrushStyle ) );
End;

Procedure TEzBrushTool.SaveToStream( Stream: TStream );
Begin
  Stream.Write( FBrushStyle, sizeof( FBrushStyle ) );
End;

Function TEzBrushTool.GetPattern: Integer;
Begin
  result := FBrushStyle.Pattern;
End;

Procedure TEzBrushTool.SetPattern( Value: Integer );
Begin
  FBrushStyle.Pattern := Value;
End;

Function TEzBrushTool.GetColor: TColor;
Begin
  result := FBrushStyle.Color;
End;

Procedure TEzBrushTool.SetColor( Value: TColor );
Begin
  FBrushStyle.Color := Value;
End;

Procedure TEzBrushTool.Assign( Source: TPersistent );
Var
  Src: TEzBrushTool Absolute Source;
Begin
  If Source Is TEzBrushTool Then
    FBrushStyle := Src.FBrushStyle
  Else
    Inherited;
End;

Function TEzBrushTool.GetAngle: Single;
Begin
  result := FBrushstyle.Angle;
End;

Procedure TEzBrushTool.SetAngle( Const Value: Single );
Begin
  FBrushstyle.Angle := Value;
End;

Function TEzBrushTool.GetScale: Double;
Begin
  result := FBrushstyle.Scale;
End;

Procedure TEzBrushTool.SetScale( Const Value: Double );
Begin
  FBrushstyle.Scale := Value;
End;

Function TEzBrushTool.GetBackColor: TColor;
Begin
  result := FBrushstyle.BackColor;
End;

Function TEzBrushTool.GetForeColor: TColor;
Begin
  result := FBrushstyle.ForeColor;
End;

Procedure TEzBrushTool.SetBackColor( Const Value: TColor );
Begin
  FBrushstyle.BackColor := Value;
End;

Procedure TEzBrushTool.SetForeColor( Const Value: TColor );
Begin
  FBrushstyle.ForeColor := Value;
End;

{ TEzFontTool }

Constructor TEzFontTool.Create;
Begin
  Inherited Create;
  FFontStyle.Name := EzSystem.DefaultFontName;
  FFontStyle.Height := 1;
End;

Procedure TEzFontTool.LoadFromStream( Stream: TStream );
Begin
  Stream.Read( FFontStyle, sizeof( FFontStyle ) );
End;

Procedure TEzFontTool.SaveToStream( Stream: TStream );
Begin
  Stream.Write( FFontStyle, sizeof( FFontStyle ) );
End;

Function TEzFontTool.GetName: String;
Begin
  result := FFontStyle.Name;
End;

Procedure TEzFontTool.SetName( Const Value: String );
Begin
  FFontStyle.Name := Value;
End;

Function TEzFontTool.GetColor: TColor;
Begin
  result := FFontStyle.Color;
End;

Procedure TEzFontTool.SetCOlor( Value: TColor );
Begin
  FFontStyle.Color := Value;
End;

Function TEzFontTool.GetAngle: Single;
Begin
  result := FFontStyle.Angle;
End;

Procedure TEzFontTool.SetAngle( Const Value: Single );
Begin
  FFontStyle.Angle := Value;
End;

Function TEzFontTool.GetHeight: Double;
Begin
  Result := FFontStyle.Height;
End;

Procedure TEzFontTool.SetHeight( Const Value: Double );
Begin
  FFontStyle.Height := Value;
End;

Procedure TEzFontTool.Assign( Source: TPersistent );
Var
  Src: TEzFontTool Absolute Source;
Begin
  If Source Is TEzFontTool Then
    FFontStyle := Src.FFontStyle
  Else
    Inherited;
End;

Function TEzFontTool.GetStyle: TFontStyles;
Begin
  result := FFontStyle.Style;
End;

Procedure TEzFontTool.SetStyle( Const Value: TFontStyles );
Begin
  FFontStyle.Style := Value;
End;

{ TEzPolyClipTool }

Constructor TEzPolyClipTool.Create;
Begin
  Inherited Create;
  FOperation := pcUnion;
  FPreserveOriginals := True;
End;

Procedure TEzPolyClipTool.Assign( Source: TPersistent );
Var
  Src: TEzPolyClipTool Absolute Source;
Begin
  If Source Is TEzPolyClipTool Then
  Begin
    FOperation := Src.FOperation;
    FPreserveOriginals := Src.FPreserveOriginals;
  End
  Else
    Inherited;
End;

Procedure TEzPolyClipTool.LoadFromStream( Stream: TStream );
Begin
  Stream.Read( FOperation, sizeof( FOperation ) );
  Stream.Read( FPreserveOriginals, sizeof( Boolean ) );
End;

Procedure TEzPolyClipTool.SaveToStream( Stream: TStream );
Begin
  Stream.Write( FOperation, sizeof( FOperation ) );
  Stream.Write( FPreserveOriginals, sizeof( Boolean ) );
End;

Procedure TEzPolyClipTool.SetOperation( value: TEzPolyClipOp );
Begin
  FOperation := value;
End;

Procedure TEzPolyClipTool.SetPreserveOriginals( value: Boolean );
Begin
  FPreserveOriginals := value;
End;

{ TEzPreferences }

Constructor TEzPreferences.Create;
Begin
  Inherited Create;
  { objects that are properties }
  FDefPenStyle := TEzPenTool.Create;
  FDefBrushStyle := TEzBrushTool.Create;
  FDefSymbolStyle := TEzSymbolTool.Create;
  FDefFontStyle := TEzFontTool.Create;
  FDefTTFontStyle := TEzFontTool.Create;
  FSelectionPen := TEzPenTool.Create;
  FSelectionBrush := TEzBrushTool.Create;
  FBandsBitmapChunkSize := 65535;
  //FCommonSubDir:= AddSlash(ExtractFilePath(Application.ExeName));
  FPreloadedBlocks := TStringList.Create;
  FPreloadedImages := TStringList.Create;
  FPreloadedbandedImages := TStringList.Create;
  FUsePreloadedImages := true;
  FHintColor := clInfoBk;
  FHintFont := DefaultFont;

  FGRotatePoint:= INVALID_POINT;

  SetToDefault;
End;

Destructor TEzPreferences.Destroy;
Begin
  FDefPenStyle.Free;
  FDefBrushStyle.Free;
  FDefSymbolStyle.Free;
  FDefFontStyle.Free;
  FDefTTFontStyle.Free;
  FSelectionPen.Free;
  FSelectionBrush.Free;
  ClearPreloadedImages;
  FPreloadedImages.Free;
  ClearPreloadedBandedImages;
  FPreloadedBandedImages.Free;
  ClearPreloadedBlocks;
  FPreloadedBlocks.Free;
  FHintFont.Free;
  Inherited Destroy;
End;

Procedure TEzPreferences.Assign( Source: TEzPreferences );
Var
  FileName: String;
Begin
  FileName := GetTemporaryFileName( 'PRF' );
  Source.SaveToFile( FileName );
  Self.LoadFromFile( FileName );
  SysUtils.DeleteFile( FileName );
End;

Procedure TEzPreferences.ApplyChanges;
Begin
  If Assigned( FOnChange ) Then
    FOnChange( Self );
End;

Procedure TEzPreferences.LoadFromFile( Const FileName: String );
Var
  Inifile: TInifile;
  //TempDecimalSeparator, SaveDecimalSeparator: Char;
  //WasChanged: Boolean;
Begin
  Inifile := TInifile.Create( FileName );
  Try
    With Inifile Do
    Begin
      {s:= ReadString( 'General', 'DecimalSeparator', '.' );
      if Length(s) > 0 then TempDecimalSeparator:= s[1] else TempDecimalSeparator:= '.';
      WasChanged:=false;
      SaveDecimalSeparator:= DecimalSeparator;
      if TempDecimalSeparator <> DecimalSeparator then
      begin
        DecimalSeparator:= TempDecimalSeparator;
        WasChanged:=true;
      end; }

      FDefPenStyle.Style := ReadIntFromIni( Inifile, 'DefPen', 'Style', 1 );
      FDefPenStyle.Color := ReadIntFromIni( Inifile, 'DefPen', 'Color', clBlack );
      //FDefPenStyle.Width := ReadFloatFromIni( Inifile, 'DefPen', 'Scale', 0.0 );
      FDefPenStyle.Width := ReadFloatFromIni( Inifile, 'DefPen', 'Width', 0.0 );

      FDefBrushStyle.Pattern := ReadIntFromIni( Inifile, 'DefBrush', 'Pattern', 0 );
      FDefBrushStyle.Color := ReadIntFromIni( Inifile, 'DefBrush', 'Color', clBlack );
      FDefBrushStyle.Scale := ReadFloatFromIni( Inifile, 'DefBrush', 'Scale', 0 );
      FDefBrushStyle.Angle := ReadFloatFromIni( Inifile, 'DefBrush', 'Angle', 0 );
      FDefBrushStyle.ForeColor := ReadIntFromIni( Inifile, 'DefBrush', 'ForeColor', clblack );
      FDefBrushStyle.BackColor := ReadIntFromIni( Inifile, 'DefBrush', 'BackColor', clblack );

      FDefSymbolStyle.Index := ReadIntFromIni( Inifile, 'DefSymbol', 'Index', 0 );
      FDefSymbolStyle.Rotangle := ReadFloatFromIni( Inifile, 'DefSymbol', 'Rotangle', 0.0 );
      FDefSymbolStyle.Height := ReadFloatFromIni( Inifile, 'DefSymbol', 'Height', -10.0 );

      FDefFontStyle.Name := ReadString( 'DefFont', 'Name', 'Txt' );
      FDefFontStyle.Angle := ReadFloatFromIni( Inifile, 'DefFont', 'Angle', 0.0 );
      FDefFontStyle.Height := ReadFloatFromIni( Inifile, 'DefFont', 'Height', 12.0 );
      FDefFontStyle.Color := ReadIntFromIni( Inifile, 'DefFont', 'Color', clBlack );
      //FDefFontStyle.Style:= ReadIntFromIni( Inifile, DefFont', 'Style', 0.0);

      FDefTTFontStyle.Name := ReadString( 'DefTTFont', 'Name', EzSystem.DefaultFontName );
      FDefTTFontStyle.Angle := ReadFloatFromIni( Inifile, 'DefTTFont', 'Angle', 0.0 );
      FDefTTFontStyle.Height := ReadFloatFromIni( Inifile, 'DefTTFont', 'Height', 12.0 );
      FDefTTFontStyle.Color := ReadIntFromIni( Inifile, 'DefTTFont', 'Color', clBlack );
      FDefTTFontStyle.Style := [];
      If ReadBool( 'DefTTFont', 'Bold', false ) Then
        FDefTTFontStyle.Style := FDefTTFontStyle.Style + [fsbold];
      If ReadBool( 'DefTTFont', 'Italic', false ) Then
        FDefTTFontStyle.Style := FDefTTFontStyle.Style + [fsitalic];
      If ReadBool( 'DefTTFont', 'Underline', false ) Then
        FDefTTFontStyle.Style := FDefTTFontStyle.Style + [fsunderline];
      If ReadBool( 'DefTTFont', 'StrikeOut', false ) Then
        FDefTTFontStyle.Style := FDefTTFontStyle.Style + [fsstrikeout];

      FSelectionPen.Style := ReadIntFromIni( Inifile, 'SelPen', 'Style', 1 );
      FSelectionPen.Color := ReadIntFromIni( Inifile, 'SelPen', 'Color', clRed );
      //FSelectionPen.Scale := ReadFloatFromIni( Inifile, 'SelPen', 'Scale', 0.0 );
      FSelectionPen.Width := ReadFloatFromIni( Inifile, 'SelPen', 'Width', 0.0 );

      FSelectionBrush.Pattern := ReadIntFromIni( Inifile, 'SelBrush', 'Pattern', 1 );
      FSelectionBrush.Color := ReadIntFromIni( Inifile, 'SelBrush', 'Color', clYellow );
      FSelectionBrush.Scale := ReadFloatFromIni( Inifile, 'SelBrush', 'Scale', 0 );
      FSelectionBrush.Angle := ReadFloatFromIni( Inifile, 'SelBrush', 'Angle', 0 );
      FSelectionBrush.ForeColor := ReadIntFromIni( Inifile, 'SelBrush', 'ForeColor', clblack );
      FSelectionBrush.BackColor := ReadIntFromIni( Inifile, 'SelBrush', 'BackColor', clblack );

      FBandsBitmapChunkSize := ReadIntFromIni( Inifile, 'General', 'BandsBitmapChunkSize', 65535 );
      FShowText := ReadBool( 'General', 'ShowText', true );
      FControlPointsWidth := ReadIntFromIni( Inifile, 'General', 'ControlPointsWidth', 10 );
      FApertureWidth := ReadIntFromIni( Inifile, 'General', 'ApertureWidth', 8 );
      FMinDrawLimit := ReadIntFromIni( Inifile, 'General', 'MinDrawLimit', 5 );
      FAerialMinDrawLimit := ReadIntFromIni( Inifile, 'General', 'AerialMinDrawLimit', 5 );
      FSelectPickingInside := ReadBool( 'General', 'SelectPickingInside', true );
      FCommonSubDir := ReadString( 'General', 'CommonSubDir', '' );
      FSplineSegs := ReadIntFromIni( Inifile, 'General', 'SplineSegs', 100 );
      FEllipseSegs := ReadIntFromIni( Inifile, 'General', 'EllipseSegs', 50 );
      FArcSegs := ReadIntFromIni( Inifile, 'General', 'ArcSegs', 20 );
      FPointEntitySize := ReadIntFromIni( Inifile, 'General', 'PointEntitySize', 2 );
      FDirectionArrowSize := ReadFloatFromIni( Inifile, 'General', 'DirectionArrowSize', 6.0 );

      {if WasChanged then
      begin
        DecimalSeparator:= SaveDecimalSeparator;
      end; }
    End;
  Finally
    Inifile.free;
  End;
  ApplyChanges;
End;

Procedure TEzPreferences.SaveToFile( Const FileName: String );
Var
  Inifile: TInifile;
Begin
  Inifile := TInifile.Create( FileName );
  Try
    With Inifile Do
    Begin
      //WriteString( 'General', 'DecimalSeparator', DecimalSeparator );

      WriteInteger( 'DefPen', 'Style', FDefPenStyle.Style );
      WriteInteger( 'DefPen', 'Color', FDefPenStyle.Color );
      //WriteFloatToIni( Inifile, 'DefPen', 'Scale', FDefPenStyle.Scale );
      WriteFloatToIni( Inifile, 'DefPen', 'Width', FDefPenStyle.Width );

      WriteInteger( 'DefBrush', 'Pattern', FDefBrushStyle.Pattern );
      WriteInteger( 'DefBrush', 'Color', FDefBrushStyle.Color );
      WriteFloatToIni( Inifile, 'DefBrush', 'Scale', FDefBrushStyle.Scale );
      WriteFloatToIni( Inifile, 'DefBrush', 'Angle', FDefBrushStyle.Angle );
      WriteInteger( 'DefBrush', 'ForeColor', FDefBrushStyle.ForeColor );
      WriteInteger( 'DefBrush', 'BackColor', FDefBrushStyle.BackColor );

      WriteInteger( 'DefSymbol', 'Index', FDefSymbolStyle.Index );
      WriteFloatToIni( Inifile, 'DefSymbol', 'Rotangle', FDefSymbolStyle.Rotangle );
      WriteFloatToIni( Inifile, 'DefSymbol', 'Height', FDefSymbolStyle.Height );

      WriteString( 'DefFont', 'Name', FDefFontStyle.Name );
      WriteFloatToIni( Inifile, 'DefFont', 'Angle', FDefFontStyle.Angle );
      WriteFloatToIni( Inifile, 'DefFont', 'Height', FDefFontStyle.Height );
      WriteInteger( 'DefFont', 'Color', FDefFontStyle.Color );

      WriteString( 'DefTTFont', 'Name', FDefTTFontStyle.Name );
      WriteFloatToIni( Inifile, 'DefTTFont', 'Angle', FDefTTFontStyle.Angle );
      WriteFloatToIni( Inifile, 'DefTTFont', 'Height', FDefTTFontStyle.Height );
      WriteInteger( 'DefTTFont', 'Color', FDefTTFontStyle.Color );
      WriteBool( 'DefTTFont', 'Bold', fsbold In FDefTTFontStyle.Style );
      WriteBool( 'DefTTFont', 'Italic', fsitalic In FDefTTFontStyle.Style );
      WriteBool( 'DefTTFont', 'Underline', fsunderline In FDefTTFontStyle.Style );
      WriteBool( 'DefTTFont', 'StrikeOut', fsstrikeout In FDefTTFontStyle.Style );

      WriteInteger( 'SelPen', 'Style', FSelectionPen.Style );
      WriteInteger( 'SelPen', 'Color', FSelectionPen.Color );
      //WriteFloatToIni( Inifile, 'SelPen', 'Scale', FSelectionPen.Scale );
      WriteFloatToIni( Inifile, 'SelPen', 'Width', FSelectionPen.Width );

      WriteInteger( 'SelBrush', 'Pattern', FSelectionBrush.Pattern );
      WriteInteger( 'SelBrush', 'Color', FSelectionBrush.Color );
      WriteFloatToIni( Inifile, 'SelBrush', 'Scale', FSelectionBrush.Scale );
      WriteFloatToIni( Inifile, 'SelBrush', 'Angle', FSelectionBrush.Angle );
      WriteInteger( 'SelBrush', 'ForeColor', FSelectionBrush.ForeColor );
      WriteInteger( 'SelBrush', 'BackColor', FSelectionBrush.BackColor );

      WriteInteger( 'General', 'BandsBitmapChunkSize', FBandsBitmapChunkSize );
      WriteBool( 'General', 'ShowText', FShowText );
      WriteInteger( 'General', 'ControlPointsWidth', FControlPointsWidth );
      WriteInteger( 'General', 'ApertureWidth', FApertureWidth );
      WriteInteger( 'General', 'MinDrawLimit', FMinDrawLimit );
      WriteInteger( 'General', 'AerialMinDrawLimit', FAerialMinDrawLimit );
      WriteBool( 'General', 'SelectPickingInside', FSelectPickingInside );
      WriteString( 'General', 'CommonSubDir', FCommonSubDir );
      WriteInteger( 'General', 'SplineSegs', FSplineSegs );
      WriteInteger( 'General', 'EllipseSegs', FEllipseSegs );
      WriteInteger( 'General', 'ArcSegs', FArcSegs );
      WriteInteger( 'General', 'PointEntitySize', FPointEntitySize );
      WriteFloatToIni( IniFile, 'General', 'DirectionArrowSize', FDirectionArrowSize );
    End;
  Finally
    Inifile.free;
  End;
End;

Procedure TEzPreferences.SetToDefault;
Begin
  With FDefPenStyle.FPenStyle Do
  Begin
    Style := 1;
  End;

  With FDefSymbolStyle.FSymbolStyle Do
  Begin
    Index := 0;
    height := -10;
  End;

  With FDefFontStyle.FFontStyle Do
  Begin
    Name := 'txt';
    Height := 12.0;
  End;

  With FDefFontStyle.FFontStyle Do
  Begin
    Name := EzSystem.DefaultFontName;
    Height := 12.0;
  End;

  FShowText := true;

  With FSelectionPen.FPenStyle Do
  Begin
    Style := 1;
    Color := clRed;
    Width := 0;
    FSelectionPen.Scale := 0;
  End;

  With FSelectionBrush.FBrushStyle Do
  Begin
    Pattern := 1;
    Color := clYellow;
  End;

  FControlPointsWidth := 10;
  FApertureWidth := 8;
  FMinDrawLimit := 5;
  FAerialMinDrawLimit := 5;
  FSplineSegs := 100;
  FEllipseSegs := 50;
  FArcSegs := 20;

  FSelectPickingInside := True;
End;

Procedure TEzPreferences.SetDefBrushStyle( value: TEzBrushTool );
Begin
  FDefBrushStyle.Assign( value );
End;

Procedure TEzPreferences.SetDefFontStyle( value: TEzFontTool );
Begin
  FDefFontStyle.Assign( value );
End;

Procedure TEzPreferences.SetDefTTFontStyle( value: TEzFontTool );
Begin
  FDefTTFontStyle.Assign( value );
End;

Procedure TEzPreferences.SetDefPenStyle( value: TEzPenTool );
Begin
  FDefPenStyle.Assign( value );
End;

Procedure TEzPreferences.SetDefSymbolStyle( value: TEzSymbolTool );
Begin
  FDefSymbolStyle.Assign( value );
End;

Procedure TEzPreferences.SetSelectionBrush( value: TEzBrushTool );
Begin
  FSelectionBrush.Assign( value );
End;

Procedure TEzPreferences.SetSelectionPen( value: TEzPenTool );
Begin
  FSelectionPen.Assign( value );
End;

Procedure TEzPreferences.SetBandsBitmapChunkSize( value: Integer );
Begin
  If Value <= 0 Then
    Value := 65535;
  FBandsBitmapChunkSize := Value;
End;

Procedure TEzPreferences.SetCommonSubDir( Const value: String );
Begin
  FCommonSubDir := AddSlash( value );
End;

Procedure TEzPreferences.AddPreloadedImage( Const FileName: String );
Var
  GraphicLink: TEzGraphicLink;
Begin
  If Not FileExists( FileName ) Then Exit;
  GraphicLink := TEzGraphicLink.Create;
  Try
    GraphicLink.ReadGeneric( FileName );
  Except
    GraphicLink.Free;
    Raise;
  End;
  FPreloadedImages.AddObject( ExtractFileName( FileName ), GraphicLink );
End;

Procedure TEzPreferences.DeletePreloadedImage( Const FileName: String );
var
  Index: Integer;
begin
  Index:= FPreloadedImages.IndexOf(ExtractFileName(Filename));
  If Index < 0 then Exit;
  TEzGraphicLink(FPreloadedImages.Objects[Index]).Free;
  FPreloadedImages.Delete(Index);
end;

Procedure TEzPreferences.AddPreloadedBandedImage( Const FileName: String );
Var
  Stream: TMemoryStream;
Begin
  If Not FileExists( FileName ) Then Exit;
  Stream := TMemoryStream.Create;
  Try
    Stream.LoadFromFile( FileName );
  Except
    Stream.free;
    Raise;
  End;
  FPreloadedBandedImages.AddObject( ExtractFileName( FileName ), Stream );
End;

Procedure TEzPreferences.DeletePreloadedBandedImage( Const FileName: String );
var
  Index: Integer;
begin
  Index:= FPreloadedBandedImages.IndexOf(ExtractFileName(Filename));
  If Index < 0 then Exit;
  TMemoryStream(FPreloadedBandedImages.Objects[Index]).Free;
  FPreloadedBandedImages.Delete(Index);
end;

procedure TEzPreferences.AddPreloadedBlock(const FileName: String);
Var
  Block: TEzSymbol;
  Stream: TStream;
Begin
  If Not FileExists( FileName ) Then Exit;
  Block := TEzSymbol.Create(Nil);
  Stream:= TFileStream.Create(FileName, fmOpenRead or fmShareDenyNone);
  Try
    Block.LoadFromStream(Stream);
  Except
    Block.Free;
    Raise;
  End;
  FPreloadedBlocks.AddObject( ExtractFileName( FileName ), Block );
end;

Procedure TEzPreferences.DeletePreloadedBlock( Const FileName: String );
var
  Index: Integer;
begin
  Index:= FPreloadedBlocks.IndexOf(ExtractFileName(Filename));
  If Index < 0 then Exit;
  TEzSymbol(FPreloadedBlocks.Objects[Index]).Free;
  FPreloadedBlocks.Delete(Index);
end;

Procedure TEzPreferences.ClearPreloadedImages;
Var
  I: Integer;
Begin
  For I := 0 To FPreloadedImages.Count - 1 Do
    TEzGraphicLink( FPreloadedImages.Objects[I] ).Free;
  FPreloadedImages.Clear;
End;

Procedure TEzPreferences.ClearPreloadedBandedImages;
Var
  I: Integer;
Begin
  For I := 0 To FPreloadedBandedImages.Count - 1 Do
    TStream( FPreloadedBandedImages.Objects[I] ).Free;
  FPreloadedBandedImages.Clear;
End;

Procedure TEzPreferences.SetHintFont( Value: TFont );
Begin
  If Value = Nil Then Exit;
  FHintFont.Assign( Value );
End;

procedure TEzPreferences.ClearPreloadedBlocks;
Var
  I: Integer;
Begin
  For I := 0 To FPreloadedBlocks.Count - 1 Do
    TEzSymbol( FPreloadedBlocks.Objects[I] ).Free;
  FPreloadedBlocks.Clear;
end;

{ TEzScreenGrid }

Procedure TEzScreenGrid.Assign( Source: TPersistent );
Var
  Src: TEzScreenGrid Absolute Source;
Begin
  If Source Is TEzScreenGrid Then
  Begin
    FColor := Src.FColor;
    FShow := Src.FShow;
    FStep.Assign( Src.FStep );
  End
  Else
    Inherited;
End;

Constructor TEzScreenGrid.Create;
Begin
  Inherited Create;
  FStep := TEzPointTool.Create;
End;

Destructor TEzScreenGrid.Destroy;
Begin
  FStep.Free;
  Inherited Destroy;
  ;
End;

Procedure TEzScreenGrid.LoadFromStream( Stream: TStream );
Begin
  Stream.Read( FColor, sizeof( TColor ) );
  Stream.Read( FShow, sizeof( boolean ) );
  FStep.LoadFromStream( Stream );
End;

Procedure TEzScreenGrid.SaveToStream( Stream: TStream );
Begin
  Stream.Write( FColor, sizeof( TColor ) );
  Stream.Write( FShow, sizeof( boolean ) );
  FStep.SaveToStream( Stream );
End;

Procedure TEzScreenGrid.SetColor( value: TColor );
Begin
  FColor := value;
End;

Procedure TEzScreenGrid.SetShow( value: Boolean );
Begin
  FShow := value;
End;

Procedure TEzScreenGrid.SetStep( value: TEzPointTool );
Begin
  FStep.Assign( value );
End;

{ TEzGridInfo }

Constructor TEzGridInfo.Create;
Begin
  Inherited Create;
  FGrid := TEzPointTool.Create;
  FGridOffset := TEzPointTool.Create;
  { set default values }
  FGrid.FPoint := Point2D( 1.0, 1.0 );
  FDrawAsCross := True;
  FGridColor := clMaroon;
  FGridSnap := TEzPointTool.Create;
  FGridSnap.FPoint := Point2D( 0.5, 0.5 );
End;

Destructor TEzGridInfo.Destroy;
Begin
  FGrid.Free;
  FGridOffset.Free;
  FGridSnap.Free;
  Inherited Destroy;
End;

Procedure TEzGridInfo.SetShowGrid( value: boolean );
Begin
  FShowGrid := value
End;

Procedure TEzGridInfo.SetGridColor( value: TColor );
Begin
  FGridColor := value
End;

Procedure TEzGridInfo.SetGridOffset( value: TEzPointTool );
Begin
  FGridOffset.Assign( value );
End;

Procedure TEzGridInfo.SetGrid( value: TEzPointTool );
Begin
  FGrid.Assign( value );
End;

Procedure TEzGridInfo.SetDrawAsCross( value: boolean );
Begin
  FDrawAsCross := value
End;

Procedure TEzGridInfo.SetSnapToGrid( value: boolean );
Begin
  FSnapToGrid := value;
End;

Procedure TEzGridInfo.SetGridSnap( value: TEzPointTool );
Begin
  FGridSnap.Assign( value );
End;

Procedure TEzGridInfo.LoadFromStream( Stream: TStream );
Begin
  { first save the objects }
  FGrid.LoadFromStream( Stream );
  FGridOffset.LoadFromStream( Stream );
  { and then ordinal types }
  With Stream Do
  Begin
    Read( FShowGrid, sizeof( FShowGrid ) );
    Read( FGridColor, sizeof( FGridColor ) );
    Read( FDrawAsCross, sizeof( FDrawAsCross ) );
  End;
End;

Procedure TEzGridInfo.SaveToStream( Stream: TStream );
Begin
  { first save the objects }
  FGrid.SaveToStream( Stream );
  FGridOffset.SaveToStream( Stream );
  { and then ordinal types }
  With Stream Do
  Begin
    Write( FShowGrid, sizeof( FShowGrid ) );
    Write( FGridColor, sizeof( FGridColor ) );
    Write( FDrawAsCross, sizeof( FDrawAsCross ) );
  End;
End;

Procedure TEzGridInfo.Assign( Source: TPersistent );
Var
  src: TEzGridInfo Absolute Source;
Begin
  If Source Is TEzGridInfo Then
  Begin
    FGrid.FPoint := src.FGrid.FPoint;
    FGridOffset.FPoint := src.FGridOffset.FPoint;
    FShowGrid := src.FShowGrid;
    FDrawAsCross := src.FDrawAsCross;
    FGridColor := src.FGridColor;
  End
  Else
    Inherited;
End;

{ TEzThematicSeriesColor }

Constructor TEzThematicSeriesColor.Create;
Begin
  Inherited Create;
  FList := TList.Create;
  Add( clRed );
  Add( clYellow );
  Add( clAqua );
  Add( $00FF0080 );
  Add( $008000FF );
  Add( clFuchsia );
  Add( clInfoBk );
  Add( $00C080FF );
  Add( clTeal );
  Add( $000080FF );
  Add( $0080FF80 );
End;

Destructor TEzThematicSeriesColor.Destroy;
Begin
  FList.Free;
  Inherited Destroy;
End;

Procedure TEzThematicSeriesColor.Add( Value: TColor );
Begin
  FList.Add( Pointer( Value ) );
End;

Function TEzThematicSeriesColor.GetItem( Index: Integer ): TColor;
Begin
  Result := clBlack;
  If ( Index < 0 ) Or ( Index > FList.Count - 1 ) Then
    Exit;
  Result := TColor( FList[Index] );
End;

Procedure TEzThematicSeriesColor.SetItem( Index: Integer; Value: TColor );
Begin
  If ( Index < 0 ) Or ( Index > FList.Count - 1 ) Then
    Exit;
  FList[Index] := Pointer( Value );
End;

Function TEzThematicSeriesColor.Count: Integer;
Begin
  result := FList.Count;
End;

{ TEzModifyPreferences }

Procedure TEzModifyPreferences.AddPreloadedBandedImage( Const FileName: String );
Begin
  ezsystem.Ez_Preferences.AddPreloadedBandedImage( FileName );
End;

Procedure TEzModifyPreferences.AddPreloadedImage( Const FileName: String );
Begin
  ezsystem.Ez_Preferences.AddPreloadedImage( FileName );
End;

Procedure TEzModifyPreferences.ApplyChanges;
Begin
  ezsystem.Ez_Preferences.ApplyChanges
End;

Procedure TEzModifyPreferences.ClearPreloadedBandedImages;
Begin
  ezsystem.Ez_Preferences.ClearPreloadedBandedImages;
End;

Procedure TEzModifyPreferences.ClearPreloadedImages;
Begin
  ezsystem.Ez_Preferences.ClearPreloadedImages;
End;

Function TEzModifyPreferences.GetDefBrushStyle: TEzBrushTool;
Begin
  result := ezsystem.Ez_Preferences.DefBrushStyle;
End;

Function TEzModifyPreferences.GetDefPenStyle: TEzPenTool;
Begin
  result := ezsystem.Ez_Preferences.DefPenStyle;
End;

Function TEzModifyPreferences.GetAerialMinDrawLimit: integer;
Begin
  result := ezsystem.Ez_Preferences.AerialMinDrawLimit;
End;

Function TEzModifyPreferences.GetApertureWidth: integer;
Begin
  result := ezsystem.Ez_Preferences.ApertureWidth
End;

Function TEzModifyPreferences.GetArcSegs: Integer;
Begin
  result := ezsystem.Ez_Preferences.ArcSegs
End;

Function TEzModifyPreferences.GetBandsBitmapChunkSize: Integer;
Begin
  result := ezsystem.Ez_Preferences.BandsBitmapChunkSize
End;

Function TEzModifyPreferences.GetControlPointsWidth: integer;
Begin
  result := ezsystem.Ez_Preferences.ControlPointsWidth
End;

Function TEzModifyPreferences.GetDefFontStyle: TEzFontTool;
Begin
  result := ezsystem.Ez_Preferences.DefFontStyle
End;

Function TEzModifyPreferences.GetDefSymbolStyle: TEzSymbolTool;
Begin
  result := ezsystem.Ez_Preferences.DefSymbolStyle
End;

Function TEzModifyPreferences.GetDefTTFontStyle: TEzFontTool;
Begin
  result := ezsystem.Ez_Preferences.DefTTFontStyle
End;

Function TEzModifyPreferences.GetEllipseSegs: Integer;
Begin
  result := ezsystem.Ez_Preferences.EllipseSegs
End;

Function TEzModifyPreferences.GetHintColor: TColor;
Begin
  result := ezsystem.Ez_Preferences.HintColor
End;

Function TEzModifyPreferences.GetHintFont: TFont;
Begin
  result := ezsystem.Ez_Preferences.HintFont
End;

Function TEzModifyPreferences.GetCommonSubDir: String;
Begin
  result := ezsystem.Ez_Preferences.CommonSubDir
End;

Function TEzModifyPreferences.GetMinDrawLimit: integer;
Begin
  result := ezsystem.Ez_Preferences.MinDrawLimit
End;

Function TEzModifyPreferences.GetPatternPlotterOptimized: Boolean;
Begin
  result := ezsystem.Ez_Preferences.PatternPlotterOptimized
End;

Function TEzModifyPreferences.GetPlineGen: Boolean;
Begin
  result := ezsystem.Ez_Preferences.PlineGen
End;

Function TEzModifyPreferences.GetPointEntitySize: Integer;
Begin
  result := ezsystem.Ez_Preferences.PointEntitySize
End;

Function TEzModifyPreferences.GetDirectionArrowSize: Double;
Begin
  result := ezsystem.Ez_Preferences.DirectionArrowSize
End;

Function TEzModifyPreferences.GetPreloadedBandedImages: TStrings;
Begin
  result := ezsystem.Ez_Preferences.PreloadedBandedImages
End;

Function TEzModifyPreferences.GetPreloadedImages: TStrings;
Begin
  result := ezsystem.Ez_Preferences.PreloadedImages
End;

Function TEzModifyPreferences.GetSelectionBrush: TEzBrushTool;
Begin
  result := ezsystem.Ez_Preferences.SelectionBrush
End;

Function TEzModifyPreferences.GetSelectionPen: TEzPenTool;
Begin
  result := ezsystem.Ez_Preferences.SelectionPen
End;

Function TEzModifyPreferences.GetSelectPickingInside: Boolean;
Begin
  result := ezsystem.Ez_Preferences.SelectPickingInside
End;

Function TEzModifyPreferences.GetShowText: boolean;
Begin
  result := ezsystem.Ez_Preferences.ShowText
End;

Function TEzModifyPreferences.GetSplineSegs: Integer;
Begin
  result := ezsystem.Ez_Preferences.SplineSegs
End;

Function TEzModifyPreferences.GetUsePreloadedBandedImages: Boolean;
Begin
  result := ezsystem.Ez_Preferences.UsePreloadedBandedImages
End;

Function TEzModifyPreferences.GetUsePreloadedImages: Boolean;
Begin
  result := ezsystem.Ez_Preferences.UsePreloadedImages
End;

Procedure TEzModifyPreferences.LoadFromFile( Const Filename: String );
Begin
  ezsystem.Ez_Preferences.LoadFromFile( FileName );
End;

Procedure TEzModifyPreferences.SaveToFile( Const FileName: String );
Begin
  ezsystem.Ez_Preferences.SaveToFile( FileName );
End;

Procedure TEzModifyPreferences.SetAerialMinDrawLimit( Const Value: integer );
Begin
  ezsystem.Ez_Preferences.AerialMinDrawLimit := value;
End;

Procedure TEzModifyPreferences.SetApertureWidth( Const Value: integer );
Begin
  ezsystem.Ez_Preferences.ApertureWidth := value;
End;

Procedure TEzModifyPreferences.SetArcSegs( Const Value: Integer );
Begin
  ezsystem.Ez_Preferences.ArcSegs := value;
End;

Procedure TEzModifyPreferences.SetBandsBitmapChunkSize( Const Value: Integer );
Begin
  ezsystem.Ez_Preferences.BandsBitmapChunkSize := value;
End;

Procedure TEzModifyPreferences.SetControlPointsWidth( Const Value: integer );
Begin
  ezsystem.Ez_Preferences.ControlPointsWidth := value;
End;

Procedure TEzModifyPreferences.SetDefBrushStyle( Const Value: TEzBrushTool );
Begin
  ezsystem.Ez_Preferences.DefBrushStyle.Assign( value );
End;

Procedure TEzModifyPreferences.SetDefFontStyle( Const Value: TEzFontTool );
Begin
  ezsystem.Ez_Preferences.DefFontStyle.assign( value );
End;

Procedure TEzModifyPreferences.SetDefPenStyle( Const Value: TEzPenTool );
Begin
  ezsystem.Ez_Preferences.DefPenStyle.assign( value );
End;

Procedure TEzModifyPreferences.SetDefSymbolStyle( Const Value: TEzSymbolTool );
Begin
  ezsystem.Ez_Preferences.DefSymbolStyle.assign( value );
End;

Procedure TEzModifyPreferences.SetDefTTFontStyle( Const Value: TEzFontTool );
Begin
  ezsystem.Ez_Preferences.DefTTFontStyle.assign( value );
End;

Procedure TEzModifyPreferences.SetEllipseSegs( Const Value: Integer );
Begin
  ezsystem.Ez_Preferences.EllipseSegs := value;
End;

Procedure TEzModifyPreferences.SetHintColor( Const Value: TColor );
Begin
  ezsystem.Ez_Preferences.HintColor := value;
End;

Procedure TEzModifyPreferences.SetHintFont( Const Value: TFont );
Begin
  ezsystem.Ez_Preferences.HintFont := value;
End;

Procedure TEzModifyPreferences.SetCommonSubDir( Const Value: String );
Begin
  ezsystem.Ez_Preferences.CommonSubDir := value;
End;

Procedure TEzModifyPreferences.SetMinDrawLimit( Const Value: integer );
Begin
  ezsystem.Ez_Preferences.MinDrawLimit := value;
End;

Procedure TEzModifyPreferences.SetPatternPlotterOptimized( Const Value: Boolean );
Begin
  ezsystem.Ez_Preferences.PatternPlotterOptimized := value;
End;

Procedure TEzModifyPreferences.SetPlineGen( Const Value: Boolean );
Begin
  ezsystem.Ez_Preferences.PlineGen := value;
End;

Procedure TEzModifyPreferences.SetPointEntitySize( Const Value: Integer );
Begin
  ezsystem.Ez_Preferences.PointEntitySize := value;
End;

Procedure TEzModifyPreferences.SetDirectionArrowSize( Const Value: Double );
Begin
  ezsystem.Ez_Preferences.DirectionArrowSize := Value;
End;

Procedure TEzModifyPreferences.SetSelectionBrush( Const Value: TEzBrushTool );
Begin
  ezsystem.Ez_Preferences.SelectionBrush.assign( value );
End;

Procedure TEzModifyPreferences.SetSelectionPen( Const Value: TEzPenTool );
Begin
  ezsystem.Ez_Preferences.SelectionPen.assign( value );
End;

Procedure TEzModifyPreferences.SetSelectPickingInside( Const Value: Boolean );
Begin
  ezsystem.Ez_Preferences.SelectPickingInside := value;
End;

Procedure TEzModifyPreferences.SetShowText( Const Value: boolean );
Begin
  ezsystem.Ez_Preferences.ShowText := value;
End;

Procedure TEzModifyPreferences.SetSplineSegs( Const Value: Integer );
Begin
  ezsystem.Ez_Preferences.SplineSegs := value;
End;

Procedure TEzModifyPreferences.SetUsePreloadedBandedImages( Const Value: Boolean );
Begin
  ezsystem.Ez_Preferences.UsePreloadedBandedImages := value;
End;

Procedure TEzModifyPreferences.SetUsePreloadedImages( Const Value: Boolean );
Begin
  ezsystem.Ez_Preferences.UsePreloadedImages := value;
End;

procedure TEzModifyPreferences.AddPreloadedBlock(const FileName: String);
begin
  ezsystem.Ez_Preferences.AddPreloadedBlock(FileName)
end;

procedure TEzModifyPreferences.ClearPreloadedBlocks;
begin
  ezsystem.Ez_Preferences.ClearPreloadedBlocks;
end;

function TEzModifyPreferences.GetPreloadedBlocks: TStrings;
begin
  Result:= ezsystem.Ez_Preferences.PreloadedBlocks;
end;

function TEzModifyPreferences.GetUsePreloadedBlocks: Boolean;
begin
  Result:= ezsystem.Ez_Preferences.UsePreloadedBlocks;
end;

procedure TEzModifyPreferences.SetUsePreloadedBlocks(const Value: Boolean);
begin
  ezsystem.Ez_Preferences.UsePreloadedBlocks := value;
end;



{-------------------------------------------------------------------------------}
{                  implements TEzSortField                                         }
{-------------------------------------------------------------------------------}

Constructor TEzSortField.Create( Fields: TEzSortFields );
Begin
  Inherited Create;
  fFields := Fields;
End;

Function TEzSortField.GetData( Buffer: Pointer ): Boolean;
Begin
  Result := fFields.fSortList.GetFieldData( Self, Buffer );
End;

Procedure TEzSortField.SetData( Buffer: Pointer );
Begin
  fFields.fSortList.SetFieldData( Self, Buffer );
End;

Procedure TEzSortField.SetDataType( Value: TExprType );
Begin
  fDataType := Value;
End;

{-------------------------------------------------------------------------------}
{                  implements TEzSortStringField                                   }
{-------------------------------------------------------------------------------}

Constructor TEzSortStringField.Create( Fields: TEzSortFields );
Begin
  Inherited Create( Fields );
  SetDataType( ttString );
End;

Function TEzSortStringField.GetValue( Var Value: String ): Boolean;
Var
  Buffer: Array[0..dsMaxStringSize] Of Char;
Begin
  Result := GetData( @Buffer );
  If Result Then
    Value := Buffer;
End;

Function TEzSortStringField.GetAsString: String;
Begin
  If Not GetValue( Result ) Then
    Result := '';
End;

Procedure TEzSortStringField.SetAsString( Const Value: String );
Var
  Buffer: Array[0..dsMaxStringSize] Of Char;
  L: Integer;
Begin
  FillChar( Buffer, fDataSize, 0 );
  L := Length( Value );
  StrLCopy( Buffer, PChar( Value ), L );
  SetData( @Buffer );
End;

Function TEzSortStringField.GetAsFloat: double;
Begin
  Result := 0;
End;

Procedure TEzSortStringField.SetAsFloat( Value: double );
Begin
End;

Function TEzSortStringField.GetAsInteger: Longint;
Begin
  Result := 0;
End;

Procedure TEzSortStringField.SetAsInteger( Value: Longint );
Begin
End;

Function TEzSortStringField.GetAsBoolean: Boolean;
Begin
  Result := False;
End;

Procedure TEzSortStringField.SetAsBoolean( Value: Boolean );
Begin
End;

{-------------------------------------------------------------------------------}
//                  implements TEzSortFloatField
{-------------------------------------------------------------------------------}

Constructor TEzSortFloatField.Create( Fields: TEzSortFields );
Begin
  Inherited Create( Fields );
  SetDataType( ttFloat );
End;

Function TEzSortFloatField.GetAsFloat: double;
Begin
  If Not GetData( @Result ) Then
    Result := 0;
End;

Procedure TEzSortFloatField.SetAsFloat( Value: double );
Begin
  SetData( @Value );
End;

Function TEzSortFloatField.GetAsString: String;
Var
  F: Double;
Begin
  If GetData( @F ) Then
    Result := FloatToStr( F )
  Else
    Result := '';
End;

Procedure TEzSortFloatField.SetAsString( Const Value: String );
Var
  F: Extended;
Begin
  If Value = '' Then
    SetAsFloat( 0 )
  Else
  Begin
    If Not TextToFloat( PChar( Value ), F, fvExtended ) Then
      EzGisError( Format(SIsInvalidFloatValue, [Value]) );
    SetAsFloat( F );
  End;
End;

Function TEzSortFloatField.GetAsInteger: Longint;
Begin
  Result := 0;
End;

Procedure TEzSortFloatField.SetAsInteger( Value: Longint );
Begin
End;

Function TEzSortFloatField.GetAsBoolean: Boolean;
Begin
  Result := False;
End;

Procedure TEzSortFloatField.SetAsBoolean( Value: Boolean );
Begin
End;

{-------------------------------------------------------------------------------}
{                  implements TEzSortIntegerField                                      }
{-------------------------------------------------------------------------------}

Constructor TEzSortIntegerField.Create( Fields: TEzSortFields );
Begin
  Inherited Create( Fields );
  SetDataType( ttInteger );
End;

Function TEzSortIntegerField.GetAsInteger: Longint;
Begin
  If Not GetData( @Result ) Then
    Result := 0;
End;

Procedure TEzSortIntegerField.SetAsInteger( Value: Longint );
Begin
  SetData( @Value );
End;

Function TEzSortIntegerField.GetAsString: String;
Var
  L: Longint;
Begin
  If GetData( @L ) Then
    Str( L, Result )
  Else
    Result := '';
End;

Procedure TEzSortIntegerField.SetAsString( Const Value: String );
Var
  E: Integer;
  L: Longint;
Begin
  Val( Value, L, E );
  If E <> 0 Then
    EzGisError( Format(SIsInvalidIntegerValue, [Value]) );
  SetAsInteger( L );
End;

Function TEzSortIntegerField.GetAsFloat: double;
Begin
  Result := 0;
End;

Procedure TEzSortIntegerField.SetAsFloat( Value: double );
Begin
End;

Function TEzSortIntegerField.GetAsBoolean: Boolean;
Begin
  Result := False;
End;

Procedure TEzSortIntegerField.SetAsBoolean( Value: Boolean );
Begin
End;

{-------------------------------------------------------------------------------}
{                  implements TEzSortBooleanField                                      }
{-------------------------------------------------------------------------------}

Constructor TEzSortBooleanField.Create( Fields: TEzSortFields );
Begin
  Inherited Create( Fields );
  SetDataType( ttBoolean );
End;

Function TEzSortBooleanField.GetAsBoolean: Boolean;
Var
  B: WordBool;
Begin
  If GetData( @B ) Then
    Result := B
  Else
    Result := False;
End;

Procedure TEzSortBooleanField.SetAsBoolean( Value: Boolean );
Var
  B: WordBool;
Begin
  If Value Then
    Word( B ) := 1
  Else
    Word( B ) := 0;
  SetData( @B );
End;

Function TEzSortBooleanField.GetAsString: String;
Var
  B: WordBool;
Begin
  If GetData( @B ) Then
    Result := Copy( EzBaseExpr.NBoolean[B], 1, 1 )
  Else
    Result := '';
End;

Procedure TEzSortBooleanField.SetAsString( Const Value: String );
Var
  L: Integer;
Begin
  L := Length( Value );
  If L = 0 Then
  Begin
    SetAsBoolean( False );
  End
  Else
  Begin
    If AnsiCompareText( Value, Copy( EzBaseExpr.NBoolean[False], 1, L ) ) = 0 Then
      SetAsBoolean( False )
    Else If AnsiCompareText( Value, Copy( EzBaseExpr.NBoolean[True], 1, L ) ) = 0 Then
      SetAsBoolean( True )
    Else
      EzGisError( Format(SIsInvalidBoolValue, [Value]) );
  End;
End;

Function TEzSortBooleanField.GetAsInteger: Longint;
Begin
  Result := 0;
End;

Procedure TEzSortBooleanField.SetAsInteger( Value: Longint );
Begin
End;

Function TEzSortBooleanField.GetAsFloat: double;
Begin
  Result := 0;
End;

Procedure TEzSortBooleanField.SetAsFloat( Value: double );
Begin
End;

{-------------------------------------------------------------------------------}
{                  implements TEzSortFields                                            }
{-------------------------------------------------------------------------------}

Constructor TEzSortFields.Create( SortList: TEzSortList );
Begin
  Inherited Create;
  fSortList := SortList;
  fItems := TList.Create;
End;

Destructor TEzSortFields.Destroy;
Begin
  Clear;
  fItems.Free;
  Inherited Destroy;
End;

Function TEzSortFields.GetCount: Integer;
Begin
  Result := fItems.Count;
End;

Function TEzSortFields.GetItem( Index: Integer ): TEzSortField;
Begin
  Result := fItems[Index];
End;

Function TEzSortFields.Add( DataType: TExprType ): TEzSortField;
Begin
  Result := Nil;
  Case DataType Of
    ttString: Result := TEzSortStringField.Create( Self );
    ttFloat: Result := TEzSortFloatField.Create( Self );
    ttInteger: Result := TEzSortIntegerField.Create( Self );
    ttBoolean: Result := TEzSortBooleanField.Create( Self );
  End;
  fItems.Add( Result );
End;

Procedure TEzSortFields.Clear;
Var
  I: Integer;
Begin
  For I := 0 To fItems.Count - 1 Do
    TEzSortField( fItems[I] ).Free;
  fItems.Clear;
End;

{-------------------------------------------------------------------------------}
{                  Define TEzSortList                                           }
{-------------------------------------------------------------------------------}

Constructor TEzSortList.Create;
Begin
  Inherited Create;
  fFields := TEzSortFields.Create( Self );
  fRecNo := -1;
  fRecordBufferSize := SizeOf( Integer ); { first data is the SourceRecNo property }
End;

Destructor TEzSortList.Destroy;
Begin
  fFields.Free;
  Inherited Destroy;
End;

Procedure TEzSortList.SetRecno( Value: Integer );
Begin
  If ( Value < 1 ) Or ( Value > GetRecordCount ) Then
    EzGISError( SRecnoInvalid );
  fRecNo := Value;
End;

Function TEzSortList.GetRecno: Integer;
Begin
  Result := fRecNo;
End;

Procedure TEzSortList.AddField( pDataType: TExprType;
  pDataSize: Integer; pDescending: Boolean );
Begin
  With fFields.Add( pDataType ) Do
  Begin
    BufferOffset := fRecordBufferSize;
    DataType := pDataType;
    Case DataType Of
      ttString: DataSize := pDataSize + 1;
      ttFloat: DataSize := SizeOf( Double );
      ttInteger: DataSize := SizeOf( Integer );
      ttBoolean: DataSize := SizeOf( WordBool );
    End;
    Desc := pDescending;
    Inc( fRecordBufferSize, DataSize );
  End;
End;

Procedure TEzSortList.Sort;
Var
  I, Idx: Integer;
  Index: Integer;
  Pivot: Integer;
  DataType: TExprType;
  IsDesc: Boolean;
  TempL, TempR: String;

  Function SortCompare_S( Recno: Integer; Const Value: String ): Integer;
  Var
    s: String;
  Begin
    SetRecno( Recno );
    s := fFields[Idx].AsString;
    If s = Value Then
    Begin
      Result := 0;
      Exit;
    End;
    If IsDesc Then
    Begin
      If s < Value Then
        Result := 1
      Else
        Result := -1;
    End
    Else
    Begin
      If s < Value Then
        Result := -1
      Else
        Result := 1;
    End;
  End;

  Function SortCompare_F( Recno: Integer; Const Value: Double ): Integer;
  Var
    f: Double;
  Begin
    SetRecno( Recno );
    f := fFields[Idx].AsFloat;
    If f = Value Then
    Begin
      Result := 0;
      Exit;
    End;
    If IsDesc Then
    Begin
      If f < Value Then
        Result := 1
      Else
        Result := -1;
    End
    Else
    Begin
      If f < Value Then
        Result := -1
      Else
        Result := 1;
    End;
  End;

  Function SortCompare_I( Recno: Integer; Value: Integer ): Integer;
  Var
    i: Integer;
  Begin
    SetRecno( Recno );
    i := fFields[Idx].AsInteger;
    If i = Value Then
    Begin
      Result := 0;
      Exit;
    End;
    If IsDesc Then
    Begin
      If i < Value Then
        Result := 1
      Else
        Result := -1;
    End
    Else
    Begin
      If i < Value Then
        Result := -1
      Else
        Result := 1;
    End;
  End;

  Function SortCompare_B( Recno: Integer; Value: Boolean ): Integer;
  Var
    b: Boolean;
  Begin
    SetRecno( Recno );
    b := fFields[Idx].AsBoolean;
    If Ord( b ) = Ord( Value ) Then
    Begin
      Result := 0;
      Exit;
    End;
    If IsDesc Then
    Begin
      If Ord( b ) < Ord( Value ) Then
        Result := 1
      Else
        Result := -1;
    End
    Else
    Begin
      If Ord( b ) < Ord( Value ) Then
        Result := -1
      Else
        Result := 1;
    End;
  End;

  Procedure QuickSort( L, R: Integer );
  Var
    I, J, P: Integer;
    s1: String;
    f1: Double;
    i1: Integer;
    b1: Boolean;
  Begin
    Repeat
      I := L;
      J := R;
      P := ( L + R ) Shr 1;
      SetRecno( P );
      f1 := 0;
      i1 := 0;
      b1 := False;
      Case DataType Of
        ttString: s1 := fFields[Idx].AsString;
        ttFloat: f1 := fFields[Idx].AsFloat;
        ttInteger: i1 := fFields[Idx].AsInteger;
        ttBoolean: b1 := fFields[Idx].AsBoolean;
      End;
      Repeat
        Case DataType Of
          ttString:
            Begin
              While SortCompare_S( I, s1 ) < 0 Do
                Inc( I );
            End;
          ttFloat:
            Begin
              While SortCompare_F( I, f1 ) < 0 Do
                Inc( I );
            End;
          ttInteger:
            Begin
              While SortCompare_I( I, i1 ) < 0 Do
                Inc( I );
            End;
          ttBoolean:
            Begin
              While SortCompare_B( I, b1 ) < 0 Do
                Inc( I );
            End;
        End;

        Case DataType Of
          ttString:
            Begin
              While SortCompare_S( J, s1 ) > 0 Do
                Dec( J );
            End;
          ttFloat:
            Begin
              While SortCompare_F( J, f1 ) > 0 Do
                Dec( J );
            End;
          ttInteger:
            Begin
              While SortCompare_I( J, i1 ) > 0 Do
                Dec( J );
            End;
          ttBoolean:
            Begin
              While SortCompare_B( J, b1 ) > 0 Do
                Dec( J );
            End;
        End;
        If I <= J Then
        Begin
          Exchange( I, J );
          Inc( I );
          Dec( J );
        End;
      Until I > J;
      If L < J Then
        QuickSort( L, J );
      L := I;
    Until I >= R;
  End;

Begin
  If ( fFields.Count = 0 ) Or ( GetRecordCount = 0 ) Then Exit;
  Idx := 0;
  DataType := fFields[0].DataType;
  IsDesc := fFields[0].Desc;
  QuickSort( 1, GetRecordCount );
  For Idx := 1 To fFields.Count - 1 Do
  Begin
    SetRecno( 1 );
    DataType := fFields[Idx].DataType;
    IsDesc := fFields[Idx].Desc;
    Index := 1;
    Pivot := 1;
    TempL := '';
    For I := 0 To Idx - 1 Do
      TempL := TempL + fFields[I].AsString;
    While Index <= GetRecordCount Do
    Begin
      SetRecno( Index );
      TempR := '';
      For I := 0 To Idx - 1 Do
        TempR := TempR + fFields[I].AsString;
      If TempL <> TempR Then
      Begin
        If Index - 1 > Pivot Then
          QuickSort( Pivot, Index - 1 );

        Pivot := Index;
        SetRecno( Pivot );
        TempL := TempR;
        Index := Pivot - 1;
      End;
      Inc( Index );
    End;
    If ( ( Index - 1 ) <= GetRecordCount ) And ( Index - 1 > Pivot ) Then
      QuickSort( Pivot, Index - 1 );
  End;
End;

{-------------------------------------------------------------------------------}
{                  implements TEzMemSortList                                      }
{-------------------------------------------------------------------------------}

Constructor TEzMemSortList.Create;
Begin
  Inherited Create;
  fBufferList := TList.Create;
End;

Destructor TEzMemSortList.Destroy;
Begin
  Clear;
  fBufferList.Free;
  Inherited Destroy;
End;

Procedure TEzMemSortList.Clear;
Var
  I: Integer;
  Buffer: PChar;
Begin
  For I := 0 To fBufferList.Count - 1 Do
  Begin
    Buffer := fBufferList[I];
    FreeMem( Buffer, fRecordBufferSize );
  End;
  fBufferList.Clear;
  fFields.Clear;
  fRecordBufferSize := SizeOf( Integer );
  fRecNo := -1;
End;

Function TEzMemSortList.ActiveBuffer: PChar;
Begin
  Result := Nil;
  If ( fRecNo < 1 ) Or ( fRecNo > fBufferList.Count ) Then Exit;
  Result := fBufferList[fRecNo - 1];
End;

Function TEzMemSortList.GetFieldData( Field: TEzSortField; Buffer: Pointer ): Boolean;
Var
  RecBuf: PChar;
Begin
  Result := False;
  RecBuf := ActiveBuffer;
  If RecBuf = Nil Then Exit;
  Move( ( RecBuf + Field.BufferOffset )^, Buffer^, Field.DataSize );
  Result := True;
End;

Procedure TEzMemSortList.SetFieldData( Field: TEzSortField; Buffer: Pointer );
Var
  RecBuf: PChar;
Begin
  RecBuf := ActiveBuffer;
  If ( RecBuf = Nil ) Or ( Buffer = Nil ) Then Exit;
  Move( Buffer^, ( RecBuf + Field.BufferOffset )^, Field.DataSize );
End;

Procedure TEzMemSortList.Insert;
Var
  Buffer: PChar;
Begin
  GetMem( Buffer, fRecordBufferSize );
  FillChar( Buffer^, fRecordBufferSize, 0 );
  fBufferList.Add( Buffer );
  fRecNo := fBufferList.Count;
End;

Function TEzMemSortList.GetRecordCount: Integer;
Begin
  Result := fBufferList.Count;
End;

Procedure TEzMemSortList.Exchange( Recno1, Recno2: Integer );
Begin
  fBufferList.Exchange( Recno1 - 1, Recno2 - 1 );
End;

Function TEzMemSortList.GetSourceRecno: Integer;
Var
  Buffer: PChar;
Begin
  Result := 0;
  If ( fRecNo < 1 ) Or ( fRecNo > GetRecordCount ) Then Exit;
  Buffer := PChar( fBufferList[fRecNo - 1] );
  Move( ( Buffer + 0 )^, Result, SizeOf( Integer ) );
End;

Procedure TEzMemSortList.SetSourceRecno( Value: Integer );
Var
  Buffer: PChar;
Begin
  If ( fRecNo < 1 ) Or ( fRecNo > GetRecordCount ) Then Exit;
  Buffer := PChar( fBufferList[fRecNo - 1] );
  Move( Value, ( Buffer + 0 )^, SizeOf( Integer ) );
End;


Initialization
  RegisterClasses( [TEzPointTool,
    TEzSymbolTool,
      TEzPenTool,
      TEzBrushTool,
      TEzFontTool,
      TEzPolyClipTool,
      TEzScreenGrid,
      TEzGridInfo] );

End.
