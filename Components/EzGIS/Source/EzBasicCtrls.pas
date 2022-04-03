Unit EzBasicCtrls;

{***********************************************************}
{     EzGIS/CAD Components                                  }
{   (c) 2002 EzSoft Engineering                             }
{         All Rights Reserved                               }
{***********************************************************}

{$I EZ_FLAG.PAS}
Interface

Uses
  SysUtils, Classes, Windows, StdCtrls, Controls, Graphics, Printers, ExtCtrls,
  Forms, Messages, EzBaseExpr, EzLib, EzSystem, EzBase, EzRtree, EzBaseGIS,
  EzEntities, ezimpl, EzExpressions;

Const
  {(*}
  EZDEXT = '.EZD';
  EZXEXT = '.EZX';
  EPJEXT = '.EPJ';
  MAPEXT = '.EZM';
  UDFEXT = '.UDF';
  CADEXT = '.EZC';
  LONG_FIELDS_EXT = '.FLD';
  LAYER_VERSION_NUMBER = 100;
  MAP_ID = 8006;
  MAP_VERSION_NUMBER = 100;
  {*)}

Type

  {-----------------------------------------------------------------------------}
  //                    TEzMemLayerInfo
  {-----------------------------------------------------------------------------}

  TEzMemLayerInfo = Class( TEzBaseLayerInfo )
  Protected
    Function GetOverlappedTextAction: TEzOverlappedTextAction; Override;
    Procedure SetOverlappedTextAction( Value: TEzOverlappedTextAction ); Override;
    Function GetOverlappedTextColor: TColor; Override;
    Procedure SetOverlappedTextColor( Value: TColor ); Override;
    Function GetTextHasShadow: Boolean; Override;
    Procedure SetTextHasShadow( Value: boolean ); Override;
    Function GetTextFixedSize: Byte; Override;
    Procedure SetTextFixedSize( Value: Byte ); Override;
    Function GetVisible: boolean; Override;
    Procedure SetVisible( Value: boolean ); Override;
    Function GetSelectable: boolean; Override;
    Procedure SetSelectable( Value: boolean ); Override;
    Function GetIsCosmethic: boolean; Override;
    Procedure SetIsCosmethic( value: boolean ); Override;
    Function GetExtension: TEzRect; Override;
    Procedure SetExtension( Const Value: TEzRect ); Override;
    Function GetIDCounter: integer; Override;
    Procedure SetIDCounter( Value: integer ); Override;
    Function GetIsAnimationLayer: boolean; Override;
    Procedure SetIsAnimationLayer( Value: boolean ); Override;
    Function GetIsIndexed: boolean; Override;
    Procedure SetIsIndexed( Value: boolean ); Override;
    Function GetCoordsUnits: TEzCoordsUnits; Override;
    Procedure SetCoordsUnits( Value: TEzCoordsUnits ); Override;
    Function GetCoordSystem: TEzCoordSystem; Override;
    Procedure SetCoordSystem( Value: TEzCoordSystem ); Override;
    Function GetUseAttachedDB: Boolean; Override;
    Procedure SetUseAttachedDB( Value: Boolean ); Override;
    Function GetLocked: Boolean; Override;
    Procedure SetLocked( Value: Boolean ); Override;
  End;


  {-----------------------------------------------------------------------------}
  //                    TEzMemoryLayer - layer used for in memory entities
  {-----------------------------------------------------------------------------}

  TEzMemoryLayer = Class( TEzBaseLayer )
  Private
    FEntities: TList; { entities are maintained in a list }
    FIsOpened: Boolean;
    FCopierStream: TStream;
    { record specific data }
    FRecno: Integer;
    FEofCrack: Boolean;
    ol: TIntegerList;
    FFiltered: Boolean;
    FFilterRecno: Integer;
    Function InternalCopyEntity( Entity: TEzEntity ): TEzEntity;
    Procedure UpdateMapExtension( Const R: TEzRect );
  Protected
    FHeader: TEzLayerHeader;
    FDelStatus: TBits;
    Function GetRecno: Integer; Override;
    Procedure SetRecno( Value: Integer ); Override;
    Function GetRecordCount: Integer; Override;
    Function GetDBTable: TEzBaseTable; Override;
    Function GetActive: Boolean; Override;
    Procedure SetActive( Value: Boolean ); Override;
    function GetFiltered: Boolean; override;
  Public
    Constructor Create( Layers: TEzBaseLayers; Const AFileName: String ); Override;
    Destructor Destroy; Override;
    Procedure InitializeOnCreate( Const FileName: String;
                                  AttachedDB, IsAnimation: Boolean;
                                  CoordSystem: TEzCoordSystem;
                                  CoordsUnits: TEzCoordsUnits;
                                  FieldList: TStrings ); Override;

    Procedure Assign( Source: TEzBaseLayer ); Override;
    Procedure Open; Override;
    Procedure Close; Override;
    Procedure ForceOpened; Override;
    Procedure WriteHeaders( FlushFiles: Boolean ); Override;
    Function AddEntity( Entity: TEzEntity; Direct: Boolean = False ): Integer; Override;
    Procedure DeleteEntity( RecNo: Integer ); Override;
    Procedure UnDeleteEntity( RecNo: Integer ); Override;
    Function QuickUpdateExtension: TEzRect; Override;
    Function UpdateExtension: TEzRect; Override;
    Function LoadEntityWithRecNo( RecNo: Longint): TEzEntity; Override;
    Function EntityWithRecno( Recno: Integer ): TEzEntity; Override;
    Procedure UpdateEntity( RecNo: Integer; Entity2D: TEzEntity ); Override;
    Procedure Pack( ShowMessages: Boolean ); Override;
    Procedure Repair; Override;
    Procedure Zap; Override;

    Procedure First; Override;
    Procedure Last; Override;
    Procedure Next; Override;
    Function Eof: Boolean; Override;
    Procedure StartBuffering; Override;
    Procedure EndBuffering; Override;
    Procedure SetGraphicFilter( s: TSearchType; Const visualWindow: TEzRect ); Override;
    Procedure CancelFilter; Override;
    Function ContainsDeleted: Boolean; Override;
    Procedure Recall; Override;
    Function SendEntityToBack( ARecno: Integer ): Integer; Override;
    Function BringEntityToFront( ARecno: Integer ): Integer; Override;
    Function RecIsDeleted: boolean; Override;
    Procedure RecLoadEntity2( Entity: TEzEntity ); Override;
    Function RecLoadEntity: TEzEntity; Override;
    Function RecExtension: TEzRect; Override;
    Function RecEntityID: TEzEntityID; Override;
    Function RecEntity: TEzEntity; Override;

    Function GetBookmark: Pointer; Override;
    Procedure GotoBookmark( Bookmark: Pointer ); Override;
    Procedure FreeBookmark( Bookmark: Pointer ); Override;

    Procedure RebuildTree; Override;

    Procedure CopyRecord( SourceRecno, DestRecno: Integer ); Override;
    Function DefineScope( Const Scope: String ): Boolean; Override;
    Function DefinePolygonScope( Polygon: TEzEntity; Const Scope: String;
      Operator: TEzGraphicOperator ): Boolean; Override;
    function GetExtensionForRecords( List: TIntegerList ): TEzRect; Override;

    Procedure SaveToFile;
    Procedure LoadFromFile;
    Procedure SaveToStream( Stream: TStream );
    Procedure LoadFromStream( Stream: TStream );
    Function IsDeleted( Recno: Integer ): Boolean;

    Property Entities: TList read FEntities;
  End;

  {-----------------------------------------------------------------------------}
  {                  TEzLayers - for desktop layers                             }
  {-----------------------------------------------------------------------------}

  TEzLayers = Class( TEzBaseLayers )
  Public
    Function Add( Const FileName: String; LayerType: TEzLayerType ): Integer; Override;
    Function CreateNew( Const FileName: String; FieldList: TStrings = Nil ): TEzBaseLayer; Override;
    Function CreateNewEx( Const FileName: String; CoordSystem: TEzCoordSystem;
      CoordsUnits: TEzCoordsUnits; FieldList: TStrings = Nil ): TEzBaseLayer; Override;
    Function CreateNewCosmethic( Const FileName: String ): TEzBaseLayer; Override;
    Function CreateNewAnimation( Const FileName: String ): TEzBaseLayer; Override;
    Function Delete( Const LayerName: String; DeleteFiles: Boolean ): Boolean; Override;
  End;

  {------------------------------------------------------------------------------}
  //            r-tree descendant classes
  {------------------------------------------------------------------------------}

  TEzRTNode = Class( TRTNode )
  Public
    Procedure Read( NId: Integer ); Override;
    Procedure Write; Override;
    Procedure AddNodeToFile; Override;
    Procedure DeleteNodeFromFile; Override;
  End;

  {------------------------------------------------------------------------------}
  //            TRTree used in desktop
  {------------------------------------------------------------------------------}

  TEzRTree = Class( TRTree )
  Public
    IdxRtx: TStream; // The file id of this rtree, if opened
    IdxRtc: TStream; // Catalog stream
    IdxOpened: Boolean;
    Function CreateNewNode: TRTNode; Override;
    Function Open( Const Name: String; Mode: Word ): integer; Override;
    Procedure Close; Override;
    Function CreateIndex( Const Name: String; Multiplier: Integer ): integer; Override;
    Procedure FlushFiles; Override;
    Procedure ReadCatalog( Var IdxInfo: TRTCatalog ); Override;
    Procedure WriteCatalog( Const IdxInfo: TRTCatalog ); Override;
    Procedure DropIndex; Override;
  End;

  { TSHPLayer - a layer for opening ArcView .shp files }

  PFourBytes = ^TFourBytes;
  TFourBytes = Array[0..3] Of byte;

  PEightBytes = ^TEightBytes;
  TEightBytes = Array[0..7] Of byte;

  // 20 bytes
  //TpPointRec = ^TPointRec;
  {(*}
  TPointRec = packed record
    ShapeType  : integer;         // Little         1 - point
    Node       : TEzPoint;
  end;

  //TpPointRec = ^TPointRec;
  TMultiPointRec = packed record
    ShapeType: Integer;           // Little                 8 - multipoint
    Extent   : TEzRect;           // Little
    NumPoints: Integer;           // Little
    // follows every point
  end;

 // 8 bytes
 //TpRecHeader = ^TRecHeader;
 TRecHeader = packed record
   RecNumber  : integer;                 // Big             ? 1 based
   RecLength  : integer;                 // Big             ? # of words
 end;

 // 100 bytes
 //TpShapeHeader = ^TShapeHeader;
 TShapeHeader = packed record
   FileCode   : integer;                 // Big Endian      ( 9994 big )
   Filler1    : array[0..4] of integer;  // Big Endian      0
   FileLength : integer;                 // Big Endian      # of words
   Version    : integer;                 // Little Endian   1000
   ShapeType  : integer;                 // Little Endian   0,1,3,5,8
   Extent     : TEzRect;                 // Little Endian
   Filler2    : array[0..7] of integer;  // Big Endian      0
 end;

 // 8 bytes - offset of first shape object set to 50 words
 //TpIndexRec = ^TIndexRec;
 TIndexRec = packed record
   Offset     : integer;                 // Big Endian
   Length     : integer;                 // Big Endian
 end;

 // 44 bytes
 //TpPartsHeader = ^TPartsHeader;
 TPartsHeader = packed record
   ShapeType  : integer;                 // Little          3,5 - Arc,Polygon
   Extent     : TEzRect;
   NumParts   : integer;                 // Little
   NumPoints  : integer;                 // Little
 end;
  {*)}

{-----------------------------------------------------------------------------}
//                    TSHPLayerInfo
{-----------------------------------------------------------------------------}

  TSHPLayerInfo = Class( TEzBaseLayerInfo )
  Protected
    Function GetOverlappedTextAction: TEzOverlappedTextAction; Override;
    Procedure SetOverlappedTextAction( Value: TEzOverlappedTextAction ); Override;
    Function GetOverlappedTextColor: TColor; Override;
    Procedure SetOverlappedTextColor( Value: TColor ); Override;
    Function GetTextHasShadow: Boolean; Override;
    Procedure SetTextHasShadow( Value: boolean ); Override;
    Function GetTextFixedSize: Byte; Override;
    Procedure SetTextFixedSize( Value: Byte ); Override;
    Function GetVisible: boolean; Override;
    Procedure SetVisible( Value: boolean ); Override;
    Function GetSelectable: boolean; Override;
    Procedure SetSelectable( Value: boolean ); Override;
    Function GetIsCosmethic: boolean; Override;
    Procedure SetIsCosmethic( value: boolean ); Override;
    Function GetExtension: TEzRect; Override;
    Procedure SetExtension( Const Value: TEzRect ); Override;
    Function GetIDCounter: integer; Override;
    Procedure SetIDCounter( Value: integer ); Override;
    Function GetIsAnimationLayer: boolean; Override;
    Procedure SetIsAnimationLayer( Value: boolean ); Override;
    Function GetIsIndexed: boolean; Override;
    Procedure SetIsIndexed( Value: boolean ); Override;
    Function GetCoordsUnits: TEzCoordsUnits; Override;
    Procedure SetCoordsUnits( Value: TEzCoordsUnits ); Override;
    Function GetCoordSystem: TEzCoordSystem; Override;
    Procedure SetCoordSystem( Value: TEzCoordSystem ); Override;
    Function GetUseAttachedDB: Boolean; Override;
    Procedure SetUseAttachedDB( Value: Boolean ); Override;
    Function GetLocked: Boolean; Override;
    Procedure SetLocked( Value: Boolean ); Override;
  End;

  {-----------------------------------------------------------------------------}
  //                    TSHPLayer
  {-----------------------------------------------------------------------------}

  TSHPLayer = Class( TEzBaseLayer )
  Private
    FHeader: TEzLayerHeader;
    FRecno: Integer;
    FSHPStream: TStream;
    FSHXStream: TStream;
    FDbTable: TEzBaseTable;
    FEofCrack: Boolean;
    FCurrentLoaded: integer;
    FUpdateRtree: Boolean;
    { buffering }
    ol: TIntegerList;
    FBuffSHX, FBuffSHP: TEzBufferedRead;
    FFilterRecno: Integer;
    FFiltered: boolean;

    { shape information }
    FShapeHeader: TShapeHeader;
    FShapeType: Integer;
    { follows the data that will be read in buffering }
    FIndexRec: TIndexRec;
    Function InternalLoadEntity( Stream: TStream ): TEzEntity;
    Function BuffSHP: TStream;
    Procedure ReadIndexRec( Recnum: Integer );
    Procedure CheckExtent( Var Extent: TEzRect );
    Procedure CheckNode( Var Node: TEzPoint );
    //Procedure UpdateMapExtension( Const R: TEzRect );
  Protected
    Function GetRecno: Integer; Override;
    Procedure SetRecno( Value: Integer ); Override;
    Function GetRecordCount: Integer; Override;
    Function GetActive: Boolean; Override;
    Procedure SetActive( Value: Boolean ); Override;
    Function GetDBTable: TEzBaseTable; Override;
    function GetFiltered: Boolean; override;
  Public
    Constructor Create( Layers: TEzBaseLayers; Const AFileName: String ); Override;
    Destructor Destroy; Override;
    Procedure InitializeOnCreate( Const FileName: String;
      AttachedDB, IsAnimation: Boolean; CoordSystem: TEzCoordSystem;
      CoordsUnits: TEzCoordsUnits; FieldList: TStrings ); Override;
    Procedure StartBatchInsert; Override;
    Procedure FinishBatchInsert; Override;
    Procedure SetGraphicFilter( s: TSearchType; Const VisualWindow: TEzRect ); Override;
    Procedure CancelFilter; Override;
    Procedure GetFieldList( Strings: TStrings ); Override;
    Procedure Assign( Source: TEzBaseLayer ); Override;
    Procedure Open; Override;
    Procedure Close; Override;
    Procedure ForceOpened; Override;
    Procedure WriteHeaders( FlushFiles: Boolean ); Override;
    Function AddEntity( Entity: TEzEntity; Direct: Boolean = False ): Integer; Override;
    Procedure DeleteEntity( RecNo: Integer ); Override;
    Procedure UnDeleteEntity( RecNo: Integer ); Override;
    Function UpdateExtension: TEzRect; Override;
    Function QuickUpdateExtension: TEzRect; Override;
    Function LoadEntityWithRecNo( RecNo: Longint): TEzEntity; Override;
    Procedure UpdateEntity( RecNo: Integer; Entity2D: TEzEntity ); Override;
    Procedure Pack( ShowMessages: Boolean ); Override;
    Procedure Repair; Override;
    Procedure Zap; Override;

    Function Eof: Boolean; Override;
    Procedure First; Override;
    Procedure Last; Override;
    Procedure Next; Override;
    Procedure StartBuffering; Override;
    Procedure EndBuffering; Override;
    Function ContainsDeleted: Boolean; Override;
    Procedure Recall; Override;

    Function GetBookmark: Pointer; Override;
    Procedure GotoBookmark( Bookmark: Pointer ); Override;
    Procedure FreeBookmark( Bookmark: Pointer ); Override;

    Function SendEntityToBack( ARecno: Integer ): Integer; Override;
    Function BringEntityToFront( ARecno: Integer ): Integer; Override;
    Function RecIsDeleted: boolean; Override;
    Procedure RecLoadEntity2( Entity: TEzEntity ); Override;
    Function RecLoadEntity: TEzEntity; Override;
    Function RecExtension: TEzRect; Override;
    Function RecEntityID: TEzEntityID; Override;
    Procedure RebuildTree; Override;
    Procedure CopyRecord( SourceRecno, DestRecno: Integer ); Override;
    Function DefineScope( Const Scope: String ): Boolean; Override;
    Function DefinePolygonScope( Polygon: TEzEntity; Const Scope: String;
      Operator: TEzGraphicOperator ): Boolean; Override;
    Procedure Synchronize; Override;
    function GetExtensionForRecords( List: TIntegerList ): TEzRect; Override;
  End;

  {-----------------------------------------------------------------------------}
  //                    TEzMapInfo generic for desktop layers
  {-----------------------------------------------------------------------------}

  TEzMapInfo = Class( TEzBaseMapInfo )
  Private
    FMapHeader: TEzMapHeader;
{$IFDEF BCB}
    // unknown bug in BCB
    Function GetMapHeader: TEzMapHeader;
    procedure SetMapHeader(const Value: TEzMapHeader);
{$ENDIF}
  Protected
    Function GetNumLayers: Integer; Override;
    Procedure SetNumLayers( Value: Integer ); Override;
    Function GetExtension: TEzRect; Override;
    Procedure SetExtension( Const Value: TEzRect ); Override;
    Function GetCurrentLayer: String; Override;
    Procedure SetCurrentLayer( Const Value: String ); Override;
    Function GetAerialViewLayer: String; Override;
    Procedure SetAerialViewLayer( Const Value: String ); Override;
    Function GetLastView: TEzRect; Override;
    Procedure SetLastView( Const Value: TEzRect ); Override;
    Function GetCoordsUnits: TEzCoordsUnits; Override;
    Procedure SetCoordsUnits( Value: TEzCoordsUnits ); Override;
    Function GetCoordSystem: TEzCoordSystem; Override;
    Procedure SetCoordSystem( Value: TEzCoordSystem ); Override;
    Function GetIsAreaClipped: boolean; Override;
    Procedure SetIsAreaClipped( Value: Boolean ); Override;
    Function GetAreaClipped: TEzRect; Override;
    Procedure SetAreaClipped( Const Value: TEzRect ); Override;
    Function GetClipAreaKind: TEzClipAreaKind; Override;
    Procedure SetClipAreaKind( Value: TEzClipAreaKind ); Override;
  Public
    Procedure Initialize; Override;
    Property MapHeader: TEzMapHeader {$IFDEF BCB} Read GetMapHeader Write SetMapHeader {$ELSE} Read FMapHeader Write FMapHeader {$ENDIF};
  End;

  {-------------------------------------------------------------------------------}
  {                  TEzDrawBox                                                   }
  {-------------------------------------------------------------------------------}

  TEzScaleBar = Class;

  TEzDrawBox = Class( TEzBaseDrawBox )
  Private
    FScaleBar: TEzScaleBar;
    Procedure SetScaleBar( Value: TEzScaleBar );
  Protected
{$IFDEF FALSE}
    Procedure SetParent( AParent: TWinControl ); Override;
{$ENDIF}
    Procedure UpdateViewport( WCRect: TEzRect ); Override;
    Procedure ViewChanged( Sender: TObject ); Override;
    Procedure Notification( AComponent: TComponent; Operation: TOperation ); Override;
  Public
    Function CurrentScale: Double;
    Property NoPickFilter;

  Published

    Property ScaleBar: TEzScaleBar read FScaleBar write SetScaleBar;

    Property GIS;
    Property DefaultScaleUnits default suInches;

    { inherited }
    property AutoScroll;
    property Anchors;
    property Constraints;
    Property NumDecimals;
    Property DelayShowHint;
    Property PartialSelect;
    Property StackedSelect;
    Property SymbolMarker;
    Property SnapToGuidelines;
    Property SnapToGuidelinesDist;
    Property ScreenGrid;
    Property ShowMapExtents;
    Property ShowLayerExtents;
    Property GridInfo;
    Property RubberPen;
    Property ScrollBars;
    Property FlatScrollBar;
    Property BlinkCount;
    Property BlinkRate;
    Property DropRepeat;

    { inherited }
    Property OnGridError;
    Property OnHScroll;
    Property OnVScroll;
    Property OnHChange;
    Property OnVChange;
    Property OnBeforeScroll;
    Property OnAfterScroll;

    Property OnBeginRepaint;
    Property OnEndRepaint;
    Property OnMouseMove2D;
    Property OnMouseDown2D;
    Property OnMouseUp2D;
    property OnMouseEnter;
    property OnMouseLeave;

    Property OnPaint;

    { drawbox specific events }
    Property OnEntityDblClick;
    Property OnBeforeInsert;
    Property OnAfterInsert;
    Property OnBeforeSelect;
    Property OnAfterSelect;
    Property OnAfterUnSelect;
    Property OnZoomChange;
    Property OnEntityChanged;
    Property OnShowHint;
    Property OnSelectionChanged;
    Property OnCustomClick;
  End;

  {------------------------------------------------------------------------------}
  //                TEzSymbolsBox
  {------------------------------------------------------------------------------}

  TEzSymbolsBox = Class( TEzBaseDrawBox )
  Private
    FShowExtension: Boolean;
{$IFDEF BCB}
    Function GetShowExtension: Boolean;
    procedure SetShowExtension(const Value: Boolean);
{$ENDIF}
  Protected
    Procedure UpdateViewport( WCRect: TEzRect ); Override;
  Public
    Constructor Create( AOwner: TComponent ); Override;
    Destructor Destroy; Override;
    Procedure CreateNewEditor;
    Procedure PopulateFrom( Symbol: TEzSymbol );
    Procedure PopulateTo( Symbol: TEzSymbol );
    Property NoPickFilter;
  Published
    Property ShowExtension: Boolean Read {$IFDEF BCB}GetShowExtension{$ELSE}FShowExtension{$ENDIF} Write {$IFDEF BCB}SetShowExtension {$ELSE} FShowExtension {$ENDIF} default True;

    { inherited }
    Property NumDecimals;
    Property PartialSelect;
    Property StackedSelect;
    Property SnapToGuidelines;
    Property SnapToGuidelinesDist;
    Property ScreenGrid;
    Property GridInfo;
    Property RubberPen;
    Property ScrollBars;
    Property FlatScrollBar;

    { inherited }
    Property OnGridError;
    Property OnHScroll;
    Property OnVScroll;
    Property OnHChange;
    Property OnVChange;

    Property OnBeginRepaint;
    Property OnEndRepaint;
    Property OnMouseMove2D;
    Property OnMouseDown2D;
    Property OnMouseUp2D;

    Property OnPaint;

    { drawbox specific events }
    Property OnBeforeInsert;
    Property OnAfterInsert;
    Property OnBeforeSelect;
    Property OnAfterSelect;
    Property OnAfterUnSelect;
    Property OnZoomChange;
    Property OnEntityChanged;
    Property OnSelectionChanged;
  End;

  {-------------------------------------------------------------------------------}
  //                  Aerial view BOX
  {-------------------------------------------------------------------------------}

  TEzAerialView = Class( TEzBaseDrawBox )
  Private
    FParentView: TEzBaseDrawBox;
    FInnerColor: TColor;
    FOuterColor: TColor;
    FShowInverted: Boolean;
    FSavedDrawLimit: Integer;
    Procedure SetParentView( Const Value: TEzBaseDrawBox );
{$IFDEF BCB}
    Function GetShowInverted: Boolean;
    Procedure SetShowInverted( Value: Boolean );
    Function GetInnerColor: TColor;
    Procedure SetInnerColor( Value: TColor );
    Function GetOuterColor: TColor;
    Procedure SetOuterColor( Value: TColor );
    Function GetParentView: TEzBaseDrawBox;
{$ENDIF}
  Protected
    Procedure UpdateViewport( WCRect: TEzRect ); Override;
    Procedure Notification( AComponent: TComponent; Operation: TOperation ); Override;
  Public
    Constructor Create( AOwner: TComponent ); Override;
    Procedure BeginRepaint; Override;
    Procedure EndRepaint; Override;

  Published
    Property ShowInverted: Boolean {$IFDEF BCB}Read GetShowInverted Write SetSHowInverted {$ELSE} Read FShowInverted Write FShowInverted {$ENDIF};
    Property InnerColor: TColor {$IFDEF BCB}Read GetInnerColor write SetInnerColor{$ELSE}Read FInnerColor Write FInnerColor{$ENDIF};
    Property OuterColor: TColor {$IFDEF BCB}Read GetOuterColor write SetOuterColor{$ELSE}Read FOuterColor Write FOuterColor{$ENDIF};
    Property ParentView: TEzBaseDrawBox {$IFDEF BCB}Read GetParentView {$ELSE}Read FParentView{$ENDIF} Write SetParentView;

    { inherited }
    Property ShowMapExtents;
    Property ShowLayerExtents;

    { inherited }

    Property OnBeginRepaint;
    Property OnEndRepaint;
    Property OnMouseMove2D;
    Property OnMouseDown2D;
    Property OnMouseUp2D;

    Property OnPaint;

    { drawbox specific events }
    Property OnZoomChange;

  End;


  {-------------------------------------------------------------------------------}
  //                  an in-memory r-tree
  {-------------------------------------------------------------------------------}

    { TMemRTNode }
  TMemRTNode = Class( TRTNode )
  Public
    Procedure Read( NId: Integer ); Override;
    Procedure Write; Override;
    Procedure AddNodeToFile; Override;
    Procedure DeleteNodeFromFile; Override;
  End;

  { TMemRTree an in memory r-tree implementation }
  TMemRTree = Class( TRTree )
  Private
    IdxOpened: Boolean;
    FList: TList;
    Catalog: TRTCatalog;
    Function Get( Index: Integer ): PDiskPage;
  Public
    Destructor Destroy; Override;
    Function CreateNewNode: TRTNode; Override;
    Procedure Clear;
    Function Open( Const Name: String; Mode: Word ): integer; Override;
    Procedure Close; Override;
    Function CreateIndex( Const Name: String; Multiplier: Integer ): integer; Override;
    Procedure FlushFiles; Override;
    Procedure ReadCatalog( Var IdxInfo: TRTCatalog ); Override;
    Procedure WriteCatalog( Const IdxInfo: TRTCatalog ); Override;
    Procedure DropIndex; Override;
    Function PageCount: Integer;
    Procedure LoadFromStream( Stream: TStream );
    Procedure SaveToStream( Stream: TStream );

    Property DiskPagePtr[Index: Integer]: PDiskPage Read Get;
  End;


  { TEzScaleBar component }

  TEzBarAppearance = ( apBlockAlternate, apBlock, apRuller );
  TEzResizePosition = (rpNone, rpUpperLeft, rpUpperRight, rpLowerLeft, rpLowerRight );

  TEzScaleBar = class(TCustomControl)
  private
    FResizePosition: TEzResizePosition;
    FMoving   : Boolean ;
    FOnMove   : TNotifyEvent ;
    FFont     : TFont;
    FColor    : TColor;
    FLinesPen : TPen;
    FMinorBrush: TBrush;
    FMajorBrush: TBrush;
    FAppearance: TEzBarAppearance;
    FIntervalLengthUnits: TEzScaleUnits;
    FIntervalLength: Double;
    FIntervalNumber: Integer;
    FBarHeight: Integer;
    FNumDecimals: Integer;
    FUnits: TEzCoordsUnits;
    FShowTrailingZeros: Boolean;
    FTransparent: Boolean;

    { temp data }
    FPaintSuspended: Boolean;
    FNeedReposition: Boolean;
    procedure SetFont(const Value: TFont);
    procedure SetColor(const Value: TColor);
    procedure SetAppearance(const Value: TEzBarAppearance);
    procedure SetIntervalLength(const Value: Double);
    procedure SetIntervalLengthUnits(const Value: TEzScaleUnits);
    procedure SetBarHeight(const Value: Integer);
    procedure SetIntervalNumber(const Value: Integer);
    procedure SetNumDecimals(const Value: Integer);
    procedure WMMove(var Message: TWMMove); message WM_MOVE ;
    procedure SetLinesPen(const Value: TPen);
    procedure SetUnits(const Value: TEzCoordsUnits);
    procedure SetMajorBrush(const Value: TBrush);
    procedure SetMinorBrush(const Value: TBrush);
    procedure SetShowTrailingZeros(const Value: Boolean);
    procedure SetTransparent(const Value: Boolean);
  protected
    procedure MouseDown(Button: TMouseButton; Shift: TShiftState; X, Y:Integer); override ;
    procedure Paint; override ;
  public
    constructor Create(AOwner: TComponent) ; override  ;
    destructor Destroy; override;
    procedure Reposition;
    Procedure SaveToInifile( const FileName: string );
    Procedure LoadFromInifile( const Filename: string );
    procedure NeededDimensions( ACanvas: TCanvas; Const UnitsFactor: Double;
      var NeededWidth, NeededHeight: Integer;
      var RealDist: Double; var ScaleDistPixels, ATextHeight: Integer );
    procedure PaintTo( ACanvas: TCanvas; Const ARect: TRect;
      const UnitsFactor: Double; AWidth, AHeight: Integer; const RealDist: Double;
      ScaleDistPixels, TotalTextHeight: Integer );
  published
    Property Font: TFont read FFont write SetFont;
    Property Color: TColor read FColor write SetColor;
    Property Appearance: TEzBarAppearance read FAppearance write SetAppearance default apBlock;
    Property LinesPen: TPen read FLinesPen write SetLinesPen;
    Property MinorBrush: TBrush read FMinorBrush write SetMinorBrush;
    Property MajorBrush: TBrush read FMajorBrush write SetMajorBrush;
    Property IntervalLengthUnits: TEzScaleUnits read FIntervalLengthUnits write SetIntervalLengthUnits default suInches;
    Property IntervalLength: Double read FIntervalLength write SetIntervalLength;
    Property BarHeight: Integer read FBarHeight write SetBarHeight default 16;
    Property IntervalNumber: Integer read FIntervalNumber write SetIntervalNumber default 3;
    Property NumDecimals: Integer read FNumDecimals write SetNumDecimals default 2;
    Property ResizePosition: TEzResizePosition read FResizePosition write FResizePosition default rpLowerRight;
    Property Units: TEzCoordsUnits read FUnits write SetUnits;
    Property ShowTrailingZeros: Boolean read FShowTrailingZeros write SetShowTrailingZeros default false;
    Property Transparent: Boolean read FTransparent write SetTransparent default false;

    property Visible;
    property ShowHint;

    property OnMove : TNotifyEvent read FOnMove    write FOnMove ;
  end ;

Procedure SortOrderList( Layer: TEzBaseLayer; Solver: TEzMainExpr; var ol: TIntegerList);
Function ReverseInteger( value: integer ): integer;
Function AddShapeLayer( GIS: TEzBaseGIS; Const Filename: String;
  RepaintViewports: Boolean ): Integer;
Function AddDGNLayer( GIS: TEzBaseGIS; Const Filename: String;
  RepaintViewports: Boolean ): Integer;
Procedure SetModifiedStatus( Layer: TEzBaseLayer );
Procedure SetGISModifiedStatus( GIS: TEzBaseGIS );
Procedure NormalizePolygon( Entity: TEzEntity );
Function AddLayerTo( GIS: TEzBaseGIS; Const FileName: String;
  IsAnimation, WithDB: Boolean; LayerType: TEzLayerType;
  CoordSystem: TEzCoordSystem; CoordsUnits: TEzCoordsUnits;
  FieldList: TStrings ): TEzBaseLayer;

Implementation

Uses
  Inifiles, EzConsts, EzCADCtrls, EzMiscelEntities, EzShpImport, EzDGNLayer;

type

  {-----------------------------------------------------------------------------}
  //                    a bookmark for memory layers
  {-----------------------------------------------------------------------------}
  TEzMemBookmark = class
  private
    FRecno: Integer;
    FFiltered: Boolean;
    FEofCrack: Boolean;
    FFilterRecno: Integer;
    Fol: TIntegerList;
  Public
    constructor Create;
    destructor Destroy; Override;
  end;

  {-----------------------------------------------------------------------------}
  //                    a bookmark for SHAPE layers
  {-----------------------------------------------------------------------------}

  TEzShapeBookmark = class
  private
    FRecno: Integer;
    FFiltered: Boolean;
    FEofCrack: Boolean;
    FFilterRecno: Integer;
    FCurrentLoaded: Integer;
    FIndexRec: TIndexRec;
    FSHPPos: Integer;
    FSHXPos: Integer;
    Fol: TIntegerList;
  Public
    constructor Create;
    destructor Destroy; Override;
  end;

{ TEzMemBookmark }

constructor TEzMemBookmark.Create;
begin
  inherited Create;
  Fol:= TIntegerList.Create;
end;

destructor TEzMemBookmark.Destroy;
begin
  Fol.Free;
  inherited Destroy;
end;

{ TEzShapeBookmark }

constructor TEzShapeBookmark.Create;
begin
  inherited Create;
  Fol:= TIntegerList.Create;
end;

destructor TEzShapeBookmark.Destroy;
begin
  Fol.Free;
  inherited Destroy;
end;


{ general procedures }

Procedure SetModifiedStatus( Layer: TEzBaseLayer );
Begin
  If Layer = Nil Then Exit;
  Layer.Modified := True;
  If ( Layer.Layers <> Nil ) And ( Layer.Layers.GIS <> Nil ) Then
    Layer.Layers.GIS.Modified := True;
End;

Procedure SetGISModifiedStatus( GIS: TEzBaseGIS );
Begin
  If GIS <> Nil Then
    GIS.Modified := True;
End;

{ if first point is not equal to last point, then add last point }

Procedure NormalizePolygon( Entity: TEzEntity );
Var
  n, Idx1, Idx2: integer;
  Found: boolean;
Begin
  With Entity Do
  Begin
    If EntityID = idPolygon Then
    Begin
      If Points.Parts.Count < 2 Then
      Begin
        If Not EzLib.FuzzEqualPoint2D( Points[0], Points[Points.Count - 1] ) Then
          Points.Add( Points[0] );
      End
      Else
      Begin
        n := 0;
        Repeat
          Found := False;
          Idx1 := Points.Parts[n];
          If n < Points.Parts.Count - 1 Then
            Idx2 := Points.Parts[n + 1] - 1
          Else
            Idx2 := Points.Count - 1;
          Repeat
            If Not EzLib.FuzzEqualPoint2D( Points[Idx1], Points[Idx2] ) Then
            Begin
              If Idx2 < Points.Count - 1 Then
                Points.Insert( Idx2 + 1, Points[Idx1] )
              Else
                Points.Add( Points[Idx1] );
              Found := True;
              Inc( n );
              Break;
            End;
            Inc( n );
            If n >= Points.Parts.Count Then
              Break;
            Idx1 := Points.Parts[n];
            If n < Points.Parts.Count - 1 Then
              Idx2 := Points.Parts[n + 1] - 1
            Else
              Idx2 := Points.Count - 1;
          Until False;
        Until ( Not Found ) Or ( n >= Points.Parts.Count );
      End;
    End;
  End;
End;

// utilities

Function AddShapeLayer( GIS: TEzBaseGIS; Const Filename: String;
  RepaintViewports: boolean ): Integer;
Var
  TmpName, s: String;
  Layer: TEzBaseLayer;
  I, PriorCount: Integer;
  Extents: TEzRect;
  AFileName: string;
  ShpLayerExtents: TEzRect;
Begin
  Result := -1;
  AFileName:= ChangeFileExt( Filename, '' );
  TmpName := ExtractFileName( AFileName );
  PriorCount := GIS.Layers.Count;
  If GIS.Layers.IndexOfName( TmpName ) >= 0 Then
  Begin
    MessageToUser( SDuplicateLayer, smsgerror, MB_ICONERROR );
    Exit;
  End;
  Layer := TSHPLayer.Create( GIS.Layers, AFileName );
  Result:= Gis.Layers.IndexOfName( TmpName );
  //GIS.Layers.AddLayer(Layer);
  s := AFileName + '.EZA';
  If FileExists( s ) Then
    SysUtils.DeleteFile( s );
  s := AFileName + '.RTC';
  If FileExists( s ) Then
    SysUtils.DeleteFile( s );
  s := AFileName + '.RTX';
  If FileExists( s ) Then
    SysUtils.DeleteFile( s );
  If GIS.Layers.Count = 1 Then
    Extents := INVALID_EXTENSION
  Else
    Extents := GIS.MapInfo.Extension;
  Layer.Open;
  Layer.Modified:= True;
  ShpLayerExtents:= TSHPLayer( Layer ).FShapeHeader.Extent;
  With ShpLayerExtents Do
  Begin
    MaxBound( Extents.Emax, Emax );
    MinBound( Extents.Emin, Emin );
  End;
  Layer.LayerInfo.Extension := ShpLayerExtents;
  GIS.MapInfo.Extension := Extents;
  If PriorCount = 0 Then
  begin
    GIS.MapInfo.LastView:= Extents;
    GIS.CurrentLayerName:= TmpName;
  end;
  Layer.LayerInfo.CoordsUnits := GIS.MapInfo.CoordsUnits;
  If RepaintViewports Then
  Begin
    Layer.Open;
    GIS.MapInfo.CurrentLayer := TmpName;
    If PriorCount = 0 Then
      For I := 0 To GIS.DrawBoxList.Count - 1 Do
      Begin
        GIS.DrawBoxList[I].ZoomToExtension;
      End;
  End;
  GIS.Modified := True;
End;

Function AddDGNLayer( GIS: TEzBaseGIS; Const Filename: String;
  RepaintViewports: boolean ): Integer;
Var
  TmpName, s: String;
  Layer: TEzBaseLayer;
  I, PriorCount: Integer;
  Extents, DGNLayerExtents: TEzRect;
  DGNFile: TEzDGNFile;
  AFileName: string;
Begin
  Result := -1;
  AFileName:= ChangeFileExt( Filename, '' );
  TmpName := ExtractFileName( AFileName );
  PriorCount := GIS.Layers.Count;
  If (PriorCount>0) And (GIS.Layers.IndexOfName( TmpName ) >= 0) Then
  Begin
    MessageToUser( SDuplicateLayer, smsgerror, MB_ICONERROR );
    Exit;
  End;
  Layer := TDGNLayer.Create( GIS.Layers, AFileName );
  Result:= Gis.Layers.IndexOfName( TmpName );
  //GIS.Layers.AddLayer(Layer);
  s := AFileName + '.EZG';
  If FileExists( s ) Then
    SysUtils.DeleteFile( s );
  s := AFileName + '.RTC';
  If FileExists( s ) Then
    SysUtils.DeleteFile( s );
  s := AFileName + '.RTX';

  { calculate extension of DGN layer }
  DGNFile:= TEzDGNFile.Create;
  Try
    DGNFile.FileName := AFileName + '.DGN';
    DGNFile.MemoryLoaded:= False;
    DGNFile.Open;
    DGNLayerExtents.Emin.x:= DGNFile.XMin;
    DGNLayerExtents.Emin.y:= DGNFile.YMin;
    DGNLayerExtents.Emax.x:= DGNFile.XMax;
    DGNLayerExtents.Emax.y:= DGNFile.YMax;
    DGNFile.Close;
  Finally
    DGNFile.Free;
  End;
  If GIS.Layers.Count = 1 Then
    Extents := INVALID_EXTENSION
  Else
    Extents := GIS.MapInfo.Extension;
  With DGNLayerExtents Do
  Begin
    MaxBound( Extents.Emax, Emax );
    MinBound( Extents.Emin, Emin );
  End;
  Layer.LayerInfo.Extension := DGNLayerExtents;
  GIS.MapInfo.Extension := Extents;
  If PriorCount = 0 Then
  begin
    GIS.MapInfo.LastView:= Extents;
    GIS.CurrentLayerName:= TmpName;
  end;
  Layer.LayerInfo.CoordsUnits := GIS.MapInfo.CoordsUnits;
  Layer.Modified:= True;
  //GIS.Layers.AddLayer(Layer);
  If RepaintViewports Then
  Begin
    Layer.Open;
    GIS.MapInfo.CurrentLayer := TmpName;
    If PriorCount = 0 Then
      For I := 0 To GIS.DrawBoxList.Count - 1 Do
      Begin
        GIS.DrawBoxList[I].ZoomToExtension;
      End;
  End;
  GIS.Modified := True;
End;

{ TEzMemLayerInfo implementation }

{-------------------------------------------------------------------------------}
{                  TEzMemLayerInfo - class implementation                    }
{-------------------------------------------------------------------------------}

Function TEzMemLayerInfo.GetIsCosmethic: boolean;
Begin
  result := True; //TEzMemoryLayer( FLayer ).FHeader.IsMemoryLayer;
End;

Procedure TEzMemLayerInfo.SetIsCosmethic( value: boolean );
Begin
  If TEzMemoryLayer( FLayer ).FHeader.IsMemoryLayer = value Then Exit;
  TEzMemoryLayer( FLayer ).FHeader.IsMemoryLayer := value;
End;

Function TEzMemLayerInfo.GetLocked: Boolean;
Begin
  Result := TEzMemoryLayer( FLayer ).FHeader.Locked;
End;

Procedure TEzMemLayerInfo.SetLocked( Value: Boolean );
Begin
  TEzMemoryLayer( FLayer ).FHeader.Locked:= Value;
End;

Function TEzMemLayerInfo.GetUseAttachedDB: boolean;
Begin
  result := TEzMemoryLayer( FLayer ).FHeader.UseAttachedDB;
End;

Procedure TEzMemLayerInfo.SetUseAttachedDB( Value: boolean );
Begin
  TEzMemoryLayer( FLayer ).FHeader.UseAttachedDB := Value;
  SetModifiedStatus( FLayer );
End;

Function TEzMemLayerInfo.GetVisible: boolean;
Begin
  result := TEzMemoryLayer( FLayer ).FHeader.Visible;
End;

Procedure TEzMemLayerInfo.SetVisible( Value: boolean );
Begin
  If TEzMemoryLayer( FLayer ).FHeader.Visible = Value Then Exit;
  TEzMemoryLayer( FLayer ).FHeader.Visible := Value;
  If Assigned( FLayer.Layers.GIS.OnVisibleLayerChange ) Then
    FLayer.Layers.GIS.OnVisibleLayerChange( Self, FLayer.Name );
  SetModifiedStatus( FLayer );
End;

Function TEzMemLayerInfo.GetOverlappedTextAction: TEzOverlappedTextAction;
Begin
  result := TEzMemoryLayer( FLayer ).FHeader.OverlappedTextAction;
End;

Procedure TEzMemLayerInfo.SetOverlappedTextAction( Value: TEzOverlappedTextAction );
Begin
  If TEzMemoryLayer( FLayer ).FHeader.OverlappedTextAction = Value Then
    Exit;
  TEzMemoryLayer( FLayer ).FHeader.OverlappedTextAction := Value;
  SetModifiedStatus( FLayer );
End;

Function TEzMemLayerInfo.GetOverlappedTextColor: TColor;
Begin
  result := TEzMemoryLayer( FLayer ).FHeader.OverlappedTextColor;
End;

Procedure TEzMemLayerInfo.SetOverlappedTextColor( Value: TColor );
Begin
  If TEzMemoryLayer( FLayer ).FHeader.OverlappedTextColor = Value Then
    Exit;
  TEzMemoryLayer( FLayer ).FHeader.OverlappedTextColor := Value;
  SetModifiedStatus( FLayer );
End;

Function TEzMemLayerInfo.GetTextHasShadow: boolean;
Begin
  result := TEzMemoryLayer( FLayer ).FHeader.TextHasShadow;
End;

Procedure TEzMemLayerInfo.SetTextHasShadow( Value: boolean );
Begin
  If TEzMemoryLayer( FLayer ).FHeader.TextHasShadow = Value Then
    Exit;
  TEzMemoryLayer( FLayer ).FHeader.TextHasShadow := Value;
  SetModifiedStatus( FLayer );
End;

Function TEzMemLayerInfo.GetTextFixedSize: Byte;
Begin
  result := TEzMemoryLayer( FLayer ).FHeader.TextFixedSize;
End;

Procedure TEzMemLayerInfo.SetTextFixedSize( Value: Byte );
Begin
  If TEzMemoryLayer( FLayer ).FHeader.TextFixedSize = Value Then
    Exit;
  TEzMemoryLayer( FLayer ).FHeader.TextFixedSize := Value;
  SetModifiedStatus( FLayer );
End;

Function TEzMemLayerInfo.GetSelectable: boolean;
Begin
  result := TEzMemoryLayer( FLayer ).FHeader.Selectable;
End;

Procedure TEzMemLayerInfo.SetSelectable( Value: boolean );
Begin
  If TEzMemoryLayer( FLayer ).FHeader.Selectable = Value Then Exit;
  TEzMemoryLayer( FLayer ).FHeader.Selectable := Value;
  If Assigned( FLayer.Layers.GIS.OnSelectableLayerChange ) Then
    FLayer.Layers.GIS.OnSelectableLayerChange( Self, FLayer.Name );
  SetModifiedStatus( FLayer );
End;

Function TEzMemLayerInfo.GetExtension: TEzRect;
Begin
  result := TEzMemoryLayer( FLayer ).FHeader.Extension;
End;

Procedure TEzMemLayerInfo.SetExtension( Const Value: TEzRect );
Begin
  If EqualRect2D( Value, TEzMemoryLayer( FLayer ).FHeader.Extension ) Then
    Exit;
  TEzMemoryLayer( FLayer ).FHeader.Extension := Value;
  SetModifiedStatus( FLayer );
End;

Function TEzMemLayerInfo.GetIDCounter: integer;
Begin
  result := TEzMemoryLayer( FLayer ).FHeader.IDCounter;
End;

Procedure TEzMemLayerInfo.SetIDCounter( Value: integer );
Begin
  If TEzMemoryLayer( FLayer ).FHeader.IDCounter = Value Then
    Exit;
  TEzMemoryLayer( FLayer ).FHeader.IDCounter := Value;
  SetModifiedStatus( FLayer );
End;

Function TEzMemLayerInfo.GetIsAnimationLayer: boolean;
Begin
  result := TEzMemoryLayer( FLayer ).FHeader.IsAnimationLayer;
End;

Procedure TEzMemLayerInfo.SetIsAnimationLayer( Value: boolean );
Begin
  If TEzMemoryLayer( FLayer ).FHeader.IsAnimationLayer = Value Then Exit;
  TEzMemoryLayer( FLayer ).FHeader.IsAnimationLayer := Value;
  SetModifiedStatus( FLayer );
End;

Function TEzMemLayerInfo.GetCoordSystem: TEzCoordSystem;
Begin
  result := TEzMemoryLayer( FLayer ).FHeader.CoordSystem;
End;

Procedure TEzMemLayerInfo.SetCoordSystem( Value: TEzCoordSystem );
Begin
  If TEzMemoryLayer( FLayer ).FHeader.CoordSystem = Value Then
    Exit;
  With TEzMemoryLayer( FLayer ) Do
  Begin
    FHeader.CoordSystem := Value;
    If Value = csLatLon Then
    Begin
      CoordMultiplier := DEG_MULTIPLIER;
      FHeader.coordsunits := cuDeg;
    End
    Else
      CoordMultiplier := 1;
  End;
  SetModifiedStatus( FLayer );
End;

Function TEzMemLayerInfo.GetCoordsUnits: TEzCoordsUnits;
Begin
  result := TEzMemoryLayer( FLayer ).FHeader.CoordsUnits;
End;

Procedure TEzMemLayerInfo.SetCoordsUnits( Value: TEzCoordsUnits );
Begin
  With TEzMemoryLayer( FLayer ) Do
  Begin
    If FHeader.coordsunits = value Then Exit;
    If FHeader.CoordSystem = csLatLon Then
      FHeader.CoordsUnits := cuDeg
    Else
      FHeader.CoordsUnits := Value;
  End;
  SetModifiedStatus( FLayer );
End;

Function TEzMemLayerInfo.GetIsIndexed: boolean;
Begin
  With TEzMemoryLayer( FLayer ) Do
    result := FHeader.IsIndexed And ( Frt <> Nil );
End;

Procedure TEzMemLayerInfo.SetIsIndexed( Value: boolean );
Begin
  If TEzMemoryLayer( FLayer ).FHeader.IsIndexed = Value Then
    Exit;
  TEzMemoryLayer( FLayer ).FHeader.IsIndexed := Value;
  SetModifiedStatus( FLayer );
End;

{ TEzMemoryLayer - class implementation }

Constructor TEzMemoryLayer.Create( Layers: TEzBaseLayers; Const AFileName: String );
Begin
  Inherited Create( Layers, AFileName );
  FLayerInfo := TEzMemLayerInfo.Create( self );
  FEntities := TList.Create;
  FDelStatus := TBits.Create;

  Self.FileName := ChangeFileExt( AFileName, '' );
  Self.Name := ExtractFileName( AFileName );
  With FHeader Do
  Begin
    HeaderID := 8003;
    VersionNumber := LAYER_VERSION_NUMBER;
    IDCounter := 0;
    Extension := INVALID_EXTENSION;
    Visible := True;
    Selectable := True;
    FillChar( Reserved, SizeOf( Reserved ), 0 );
    IsMemoryLayer:= true;
  End;
  CoordMultiplier := 1;

  FCopierStream := TMemoryStream.Create;
End;

Destructor TEzMemoryLayer.Destroy;
Begin
  Inherited Destroy;
  Close;
  FEntities.Free;
  FDelStatus.Free;
  FCopierStream.Free;
End;

function TEzMemoryLayer.GetBookmark: Pointer;
var
  I: Integer;
  bmrk: TEzMemBookmark;
begin
  bmrk:= TEzMemBookmark.Create;
  bmrk.FRecno:= FRecno;
  bmrk.FFiltered:= FFiltered;
  bmrk.FEofCrack:= FEofCrack;
  bmrk.FFilterRecno:= FFilterRecno;
  if (ol <> nil) and (ol.Count > 0) then
  begin
    bmrk.Fol.Capacity:= ol.Count;
    for I:= 0 to ol.Count-1 do
      bmrk.Fol.Add( ol[I] );
  end;
  Result:= bmrk;
end;

procedure TEzMemoryLayer.GotoBookmark(Bookmark: Pointer);
var
  I: Integer;
  bmrk: TEzMemBookmark;
begin
  bmrk:= TEzMemBookmark(Bookmark);
  FRecno:= bmrk.FRecno;
  FFiltered:= bmrk.FFiltered;
  FEofCrack:= bmrk.FEofCrack;
  FFilterRecno:= bmrk.FFilterRecno;
  if bmrk.Fol.Count > 0 then
  begin
    if ol = nil then ol := TIntegerList.Create;
    ol.clear;
    ol.Capacity:= bmrk.Fol.Count;
    for I:= 0 to bmrk.Fol.Count-1 do
      ol.Add( bmrk.Fol[I] );
  end else if ol <> nil then
    ol.clear;
end;

procedure TEzMemoryLayer.FreeBookmark(Bookmark: Pointer);
begin
  TEzMemBookmark(Bookmark).Free;
end;

function TEzMemoryLayer.GetExtensionForRecords( List: TIntegerList ): TEzRect;
var
  I, TheRecno:Integer;
  Extent: TEzRect;
begin
  Result:= INVALID_EXTENSION;
  if (List=nil) or (List.Count=0) then Exit;
  for I:= 0 to List.Count-1 do
  begin
    TheRecno:= List[I];
    if (TheRecno < 1) or (TheRecno > FEntities.Count) then Continue;
    Extent:= TEzEntity(FEntities[TheRecno-1]).FBox;
    MaxBound(Result.Emax, Extent.Emax);
    MinBound(Result.Emin, Extent.Emin);
  end;
end;

Procedure TEzMemoryLayer.InitializeOnCreate( Const FileName: String;
  AttachedDB, IsAnimation: Boolean; CoordSystem: TEzCoordSystem;
  CoordsUnits: TEzCoordsUnits; FieldList: TStrings );
Var
  Stream: TFileStream;
Begin
  { initialize this layer
   warning !!!
   this method is for internal use only and you must never call this method }
  FHeader.CoordsUnits := CoordsUnits;
  FHeader.IsIndexed := True;
  FHeader.IsAnimationLayer := False;
  FHeader.UseAttachedDB := False;
  // initialize the file
  Stream := TFileStream.Create( FileName + CADEXT, fmCreate );
  Try
    Stream.Write( FHeader, sizeof( TEzLayerHeader ) );
  Finally
    Stream.free;
  End;
  If Frt <> Nil Then
    Frt.free;
  Frt := TMemRTree.Create( Self, RTYPE, fmCreate );
  Frt.CreateIndex( '', CoordMultiplier );
  If FDelStatus <> Nil Then
    FDelStatus.Free;
  FDelStatus := TBits.Create;
  Modified := True;
End;

Procedure TEzMemoryLayer.Zap;
Var
  I: Integer;
Begin
  For I := 0 To FEntities.Count - 1 Do
    TEzEntity( FEntities[I] ).Free;
  FEntities.Clear;
  Frt.free;
  Frt := TMemRTree.Create( Self, RTYPE, fmCreate );
  Frt.CreateIndex( FileName, CoordMultiplier );
  If FDelStatus <> Nil Then
    FDelStatus.Free;
  FDelStatus := TBits.Create;
  Modified := True;
End;

Function TEzMemoryLayer.GetDBTable: TEzBaseTable;
Begin
  result := Nil;
End;

Function TEzMemoryLayer.GetRecno: Integer;
Begin
  If FFiltered Then
    result := Longint( ol[FFilterRecno] )
  Else
    result := FRecno;
End;

Procedure TEzMemoryLayer.SetRecno( Value: Integer );
Begin
  If ( Value < 1 ) Or ( Value > FEntities.Count ) Then
    EzGISError( SRecnoInvalid );
  FRecno := Value;
End;

Function TEzMemoryLayer.SendEntityToBack( ARecno: Integer ): Integer;
Var
  Ent: TEzEntity;
  bbox: TEzRect;
Begin
  Result := 0;
  if LayerInfo.Locked then Exit;
  If ( ARecno > 1 ) And ( ARecno < FEntities.Count ) Then
  Begin
    ent := TEzEntity( FEntities[ARecno - 1] );
    bbox := ent.FBox;
    FEntities.Delete( ARecno - 1 );
    FEntities.Insert( 0, ent );
    Frt.Delete( FloatRect2Rect( bbox ), ARecno );
    Frt.Insert( FloatRect2Rect( bbox ), 1 );
    Result := 1;
    { pendiente que pasa cuando esta borrado }
  End;
End;

Function TEzMemoryLayer.BringEntityToFront( ARecno: Integer ): Integer;
Var
  Ent: TEzEntity;
Begin
  Result := 0;
  If LayerInfo.Locked then Exit;
  If ( ARecno > 0 ) And ( ARecno < FEntities.Count ) Then
  Begin
    ent := TEzEntity( FEntities[ARecno - 1] );
    FEntities.Delete( ARecno - 1 );
    FEntities.Add( ent );
    Frt.Delete( FloatRect2Rect( ent.FBox ), ARecno );
    Frt.Insert( FloatRect2Rect( ent.FBox ), FEntities.Count );
    Result := 1;
    { pendiente que pasa cuando esta borrado }
  End;
End;

Function TEzMemoryLayer.GetActive: Boolean;
Begin
  Result := FIsOpened;
End;

Procedure TEzMemoryLayer.SetActive( Value: Boolean );
Begin
End;

Procedure TEzMemoryLayer.SetGraphicFilter( s: TSearchType; Const VisualWindow: TEzRect );
Var
  treeBBox, viewBBox: TRect_rt;
Begin
  FFiltered := False;
  If Not FHeader.IsIndexed or (Frt = Nil) Then Exit;
  If ol = Nil Then
    ol := TIntegerList.Create
  Else
    ol.clear;
  treeBBox := Frt.RootExtent;
  viewBBox := FloatRect2Rect( VisualWindow );
  If Contains_rect( viewBBox, treeBBox ) Then
  Begin
    FreeAndNil( ol );
    Exit;
  End;
  Frt.Search( S, viewBBox, ol, FEntities.Count );
  FFiltered := True;
  FFilterRecno := -1;
End;

Procedure TEzMemoryLayer.CancelFilter;
Begin
  If ol <> Nil Then
    FreeAndNil( ol );
  FFiltered := False;
End;

Function TEzMemoryLayer.Eof: Boolean;
Begin
  result := FEofCrack;
End;

Procedure TEzMemoryLayer.First;
Begin
  If FFiltered Then
  Begin
    If ( ol <> Nil ) And ( ol.Count > 0 ) Then
    Begin
      FFilterRecno := 0;
      FEofCrack := False;
    End
    Else
    Begin
      FEofCrack := True;
    End
  End
  Else
  Begin
    If FEntities.Count > 0 Then
    Begin
      FRecno := 1;
      FEofCrack := False;
    End
    Else
    Begin
      FEofCrack := True;
    End;
  End;
End;

Procedure TEzMemoryLayer.Next;
Var
  N: Integer;
Begin
  If FFiltered Then
  Begin
    N := ol.count;
    If N > 0 Then
    Begin
      If FFilterRecno < N - 1 Then
      Begin
        Inc( FFilterRecno );
        FEofCrack := False;
      End
      Else
      Begin
        FFilterRecno := N - 1;
        FEofCrack := True;
      End;
    End
    Else
    Begin
      FEofCrack := True;
    End
  End
  Else
  Begin
    N := FEntities.Count;
    If N > 0 Then
    Begin
      If FRecno < N Then
      Begin
        Inc( FRecno );
        FEofCrack := False;
      End
      Else
      Begin
        FRecno := N;
        FEofCrack := True;
      End;
    End
    Else
    Begin
      FEofCrack := True;
    End;
  End;
End;

Procedure TEzMemoryLayer.Last;
Var
  N: Integer;
Begin
  If FFiltered Then
  Begin
    N := ol.count;
    If N > 0 Then
    Begin
      FFilterRecno := N - 1;
      FEofCrack := False;
    End
    Else
    Begin
      FEofCrack := True;
    End;
  End
  Else
  Begin
    N := FEntities.Count;
    If N > 0 Then
    Begin
      FRecno := N;
      FEofCrack := False;
    End
    Else
    Begin
      FEofCrack := True;
    End;
  End;
End;

Procedure TEzMemoryLayer.StartBuffering;
Begin
End;

Procedure TEzMemoryLayer.EndBuffering;
Begin
End;

Procedure TEzMemoryLayer.Assign( Source: TEzBaseLayer );
Var
  TmpID: Integer;
Begin
  If Not ( Source Is TEzMemoryLayer ) Then Exit;

  TmpID := FHeader.IDCounter;
  FHeader := TEzMemoryLayer( Source ).FHeader;
  FHeader.IDCounter := TmpID;
End;

Procedure TEzMemoryLayer.RebuildTree;
Var
  I, RecCount: Integer;
  GIS: TEzBaseGIS;
  Mode: Word;
Begin
  GIS := Layers.GIS;
  If GIS.ReadOnly Then Exit;

  ForceOpened;
  RecCount := FEntities.Count;
  Mode := GIS.OpenMode;

  If Frt <> Nil Then
    FreeAndNil( Frt );

  Frt := TMemRTree.Create( Self, RTYPE, Mode );
  Frt.CreateIndex( FileName, CoordMultiplier );

  For I := 1 To RecCount Do
  Begin
    If IsDeleted( I ) Then
      Continue;

    Frt.Insert( FloatRect2Rect( TEzEntity( FEntities[I - 1] ).FBox ), I );
  End;
  If Not FHeader.Visible Then Frt.Close;
End;

Procedure TEzMemoryLayer.WriteHeaders( FlushFiles: Boolean );
Begin
  // nothing to do here
End;

Procedure TEzMemoryLayer.Open;
Begin
  Close;
  If Not FHeader.Visible Then Exit;
  If Frt <> Nil Then
    FreeAndNil( Frt );
  Frt := TMemRTree.Create( Self, RTYPE, fmCreate );
  Frt.CreateIndex( '', CoordMultiplier );
  FIsOpened := True;
End;

Procedure TEzMemoryLayer.Close;
Var
  I: Integer;
Begin
  If Not FIsOpened Then Exit;

  For I := 0 To FEntities.Count - 1 Do
    TEzEntity( FEntities[I] ).Free;
  FEntities.Clear;
  If Frt <> Nil Then
    FreeAndNil( Frt );
  FDelStatus.Free;
  FDelStatus := TBits.Create;

  FIsOpened := False;
End;

Procedure TEzMemoryLayer.LoadFromFile;
Var
  Stream: TStream;
  AFileName: String;
Begin
  AFileName := FileName + CADEXT;

  If Not FIsOpened Or Not FileExists( AFileName ) Then Exit;
  Stream := TFileStream.Create( AFileName, Layers.GIS.OpenMode );
  Try
    LoadFromStream( Stream );
  Finally
    Stream.Free;
  End;
End;

Procedure TEzMemoryLayer.SaveToFile;
Var
  Stream: TStream;
Begin
  If Not FIsOpened Or Layers.GIS.ReadOnly Or Not Modified Or LayerInfo.Locked Then
  Begin
    Modified := False;
    Exit;
  End;
  Stream := TFileStream.Create( FileName + CADEXT, fmCreate );
  Try
    SaveToStream( Stream );
  Finally
    Stream.Free;
  End;
End;

Procedure TEzMemoryLayer.LoadFromStream( Stream: TStream );
Var
  I: Integer;
  Ent: TEzEntity;
  EntityID: TEzEntityID;
Begin
  With Stream Do
  Begin
    If Frt <> Nil Then
      FreeAndNil( Frt );
    Frt := TMemRTree.Create( Self, RTYPE, fmCreate );
    Frt.CreateIndex( '', CoordMultiplier );
    FDelStatus.Free;
    FDelStatus := TBits.Create;

    Read( FHeader, SizeOf( TEzLayerHeader ) );
    If FHeader.RecordCount > 0 Then
      Layers.GIS.StartProgress( Format( SLoadingCAD, [Self.Name] ), 1, FHeader.RecordCount );
    For I := 1 To FHeader.RecordCount Do
    Begin
      Layers.GIS.UpdateProgress( I );
      Read( EntityID, sizeof( TEzEntityID ) );
      Ent := GetClassFromID( EntityID ).Create( 4 );
      Ent.LoadFromStream( Stream );
      { add this entity }
      FEntities.Add( Ent );
      Frt.Insert( FloatRect2Rect( Ent.FBox ), I );
    End;
    If FHeader.RecordCount > 0 Then
      Layers.GIS.EndProgress;
  End;
End;

Procedure TEzMemoryLayer.SaveToStream( Stream: TStream );
Var
  I, n: Integer;
  Ent: TEzEntity;
  EntityID: TEzEntityID;
Begin
  If LayerInfo.Locked then Exit;
  With Stream Do
  Begin
    { count effective entities }
    n := 0;
    For I := 1 To FEntities.Count Do
      If Not IsDeleted( I ) Then
        Inc( n );
    If FEntities.Count > 0 Then
      Layers.GIS.StartProgress( Format( SSavingCAD, [Self.Name] ), 1, FEntities.Count );
    Try
      FHeader.RecordCount := n;
      Write( FHeader, SizeOf( FHeader ) );
      FHeader.RecordCount := FEntities.Count;
      For I := 1 To FEntities.Count Do
      Begin
        Layers.GIS.UpdateProgress( I );
        If IsDeleted( I ) Then Continue;

        Ent := TEzEntity( FEntities[I - 1] );
        EntityID := Ent.EntityID;
        Write( EntityID, sizeof( TEzEntityID ) );
        Ent.SaveToStream( Stream );
      End;
    Finally
      If FEntities.Count > 0 Then
        Layers.GIS.EndProgress;
    End;
  End;
End;

Procedure TEzMemoryLayer.ForceOpened;
Begin
  If FIsOpened Then Exit;
  Open;
End;

Procedure TEzMemoryLayer.UpdateMapExtension( Const R: TEzRect );
Var
  MapExt: TEzRect;
Begin
  { new map extension }
  With Layers.GIS Do
  Begin
    MapExt := MapInfo.Extension;
    if (MapExt.X1 = 0)
       and
       (MapExt.X2 = 0)
       and
       (MapExt.Y1 = 0)
       and
       (MapExt.Y2 = 0)
    then
      MapExt := R
    else
    begin
      MaxBound( MapExt.Emax, R.Emax );
      MinBound( MapExt.Emin, R.Emin );
    end;
    MapInfo.Extension := MapExt;
    Modified := True;
  End;
End;

Function TEzMemoryLayer.AddEntity( Entity: TEzEntity; Direct: Boolean = False ): Integer;
Var
  ent: TEzEntity;
  Extents: TEzRect;
Begin
  result := 0;
  ForceOpened;

  If Layers.GIS.ReadOnly Or LayerInfo.Locked Then Exit;

  NormalizePolygon( Entity );

  Extents := Entity.FBox;
  With FHeader.Extension Do
  Begin
    MaxBound( Emax, Extents.Emax );
    MinBound( Emin, Extents.Emin );
  End;

  Inc( FHeader.IDCounter );
  Entity.ID := FHeader.IDCounter;
  { Add the entity }
  ent := InternalCopyEntity( Entity );
  FEntities.Add( ent );
  result := FEntities.Count;
  FHeader.RecordCount := result;
  If Frt <> Nil Then
    Frt.Insert( FloatRect2Rect( ent.FBox ), FHeader.RecordCount );
  UpdateMapExtension( Extents );
  Modified := True;
End;

Procedure TEzMemoryLayer.DeleteEntity( RecNo: Integer );
Var
  bbox: TEzRect;
Begin

  If Layers.GIS.ReadOnly Or ( Recno < 1 ) Or LayerInfo.Locked Or
    ( Recno > FEntities.Count ) Or IsDeleted( Recno ) Then Exit;

  bbox := TEzEntity( FEntities[Recno - 1] ).FBox;
  If Frt <> Nil Then
    Frt.Delete( FloatRect2Rect( bbox ), Recno );
  FHeader.RecordCount := FEntities.Count;
  FDelStatus[Recno] := True;
  //Layers.GIS.UpdateExtension;
  Modified := True;
End;

Procedure TEzMemoryLayer.UndeleteEntity( RecNo: Integer );
Var
  bbox: TEzRect;
Begin
  If Not IsDeleted( Recno ) Or LayerInfo.Locked Then Exit;
  bbox := TEzEntity( FEntities[Recno - 1] ).FBox;
  Frt.Insert( FloatRect2Rect( bbox ), Recno );
  FDelStatus[Recno] := False;
  Modified := True;
End;

Function TEzMemoryLayer.IsDeleted( Recno: Integer ): Boolean;
Begin
  Result := True;
  If ( Recno < 1 ) Or ( Recno > FEntities.Count ) Then Exit;
  If RecNo <= FDelStatus.Size - 1 Then
    result := FDelStatus[Recno]
  Else
    result := False;
End;

Function TEzMemoryLayer.QuickUpdateExtension: TEzRect;
begin
  UpdateExtension;
end;

Function TEzMemoryLayer.UpdateExtension: TEzRect;
Var
  cnt, RecCount: Integer;
  Entity: TEzEntity;
  Extents: TEzRect;
Begin
  If Layers.GIS.ReadOnly Then Exit;
  Result := INVALID_EXTENSION;
  Try
    RecCount := FEntities.Count;
    For cnt := 1 To RecCount Do
    Begin
      If IsDeleted( cnt ) Then Continue;

      Entity := TEzEntity( FEntities[cnt - 1] );
      If Entity.EntityID = idNone Then Continue;

      Extents := Entity.FBox;
      MaxBound( Result.Emax, Extents.Emax );
      MinBound( Result.Emin, Extents.Emin );
    End;
  Finally
    Modified := True;
    FHeader.Extension := Result;
  End;
End;

Function TEzMemoryLayer.InternalCopyEntity( Entity: TEzEntity ): TEzEntity;
Begin
  FCopierStream.Seek( 0, 0 );
  Entity.SaveToStream( FCopierStream );
  FCopierStream.seek( 0, 0 );
  result := GetClassFromID( Entity.EntityID ).Create( imax( 1, Entity.Points.Count ) );
  result.LoadFromStream( FCopierStream );
  result.ExtID := Entity.ExtID; 
End;

Function TEzMemoryLayer.LoadEntityWithRecNo( RecNo: Longint): TEzEntity;
Begin
  { RecNo is base 1 }
  Result := Nil;
  If not IsDeleted( Recno ) then
    if (RecNo > 0) and (RecNo <= FEntities.Count) Then
      Result := InternalCopyEntity( TEzEntity( FEntities[Recno - 1] ) );
End;

Function TEzMemoryLayer.EntityWithRecno( Recno: Integer ): TEzEntity;
Begin
  Result := Nil;
  If IsDeleted( Recno ) Or ( RecNo < 1 ) Or ( RecNo > FEntities.Count ) Then Exit;
  result := TEzEntity( FEntities[Recno - 1] );
End;

Function TEzMemoryLayer.RecEntity: TEzEntity;
Var
  n: Integer;
Begin
  If FFiltered Then
    n := Longint( ol[FFilterRecno] )
  Else
    n := FRecno;
  Result := Nil;

  If IsDeleted( n ) Then Exit;

  result := TEzEntity( FEntities[n - 1] );
End;

Procedure TEzMemoryLayer.UpdateEntity( RecNo: Integer; Entity2D: TEzEntity );
Var
  ent: TEzEntity;
  GIS: TEzBaseGIS;
  Extents: TEzRect;
  I: Integer;
  DrawBox: TEzBaseDrawBox;
  prev_bbox: TEzRect;
Begin
  If Layers.GIS.ReadOnly Or LayerInfo.Locked Or
    IsDeleted( Recno ) Or ( Recno < 1 ) Or ( Recno > FEntities.Count ) Then Exit;
  NormalizePolygon( Entity2D );
  Extents := Entity2D.FBox;
  ent := InternalCopyEntity( Entity2D );
  prev_bbox := TEzEntity( FEntities[Recno - 1] ).FBox;
  TEzEntity( FEntities[Recno - 1] ).Free;
  FEntities[Recno - 1] := ent;
  If Frt <> Nil Then
  Begin
    Frt.Delete( FloatRect2Rect( prev_bbox ), Recno );
    Frt.Insert( FloatRect2Rect( ent.FBox ), Recno );
  End;

  MaxBound( FHeader.Extension.Emax, Extents.Emax );
  MinBound( FHeader.Extension.Emin, Extents.Emin );

  Modified := True;

  UpdateMapExtension( Extents );
  GIS := Layers.GIS;
  For I := 0 To GIS.DrawBoxList.Count - 1 Do
  Begin
    DrawBox := GIS.DrawBoxList[i];
    If Assigned( DrawBox.OnEntityChanged ) Then
      DrawBox.OnEntityChanged( DrawBox, Self, Recno );
  End;
  Modified := True;
End;

Procedure TEzMemoryLayer.Pack( ShowMessages: Boolean );
Var
  I: Integer;
Begin
  If LayerInfo.Locked Then Exit;
  For I := RecordCount Downto 1 Do
  Begin
    If IsDeleted( I ) Then
    Begin
      TEzEntity( FEntities[I - 1] ).Free;
      FEntities.Delete( I - 1 );
    End;
  End;
  If FDelStatus <> Nil Then
    FDelStatus.Free;
  FDelStatus := TBits.Create;
  RebuildTree;
  FHeader.RecordCount := FEntities.Count;
  Modified := True;
End;

Procedure TEzMemoryLayer.Repair;
Begin
  If LayerInfo.Locked Then Exit;
  Pack( False );
End;

Function TEzMemoryLayer.RecExtension: TEzRect;
Var
  N: Integer;
Begin
  If FFiltered Then
    N := Longint( ol[FFilterRecno] )
  Else
    N := FRecno;
  Result := INVALID_EXTENSION;
  If IsDeleted( N ) Then Exit;
  result := TEzEntity( FEntities[N - 1] ).FBox;
End;

Function TEzMemoryLayer.RecLoadEntity: TEzEntity;
Var
  N: Integer;
Begin
  If FFiltered Then
    N := Longint( ol[FFilterRecno] )
  Else
    N := FRecno;
  Result := Nil;
  If IsDeleted( N ) Then Exit;
  result := InternalCopyEntity( TEzEntity( FEntities[N - 1] ) );
End;

Procedure TEzMemoryLayer.RecLoadEntity2( Entity: TEzEntity );
Var
  N: Integer;
Begin
  If FFiltered Then
    N := Longint( ol[FFilterRecno] )
  Else
    N := FRecno;
  If IsDeleted( N ) Then Exit;
  FCopierStream.Seek( 0, 0 );
  TEzEntity( FEntities[N - 1] ).SaveToStream( FCopierStream );
  FCopierStream.Seek( 0, 0 );
  Entity.LoadFromStream( FCopierStream );
  Entity.ExtID := TEzEntity( FEntities[N - 1] ).ExtID;
End;

Function TEzMemoryLayer.RecEntityID: TEzEntityID;
Var
  N: Integer;
Begin
  If FFiltered Then
    N := Longint( ol[FFilterRecno] )
  Else
    N := FRecno;
  result := TEzEntity( FEntities[N - 1] ).EntityID;
End;

Function TEzMemoryLayer.RecIsDeleted: boolean;
Var
  N: Integer;
Begin
  If FFiltered Then
    N := Longint( ol[FFilterRecno] )
  Else
    N := FRecno;
  result := IsDeleted( N );
End;

Procedure TEzMemoryLayer.CopyRecord( SourceRecno, DestRecno: Integer );
Begin
End;

Function TEzMemoryLayer.ContainsDeleted: boolean;
Var
  I: Integer;
Begin
  Result := False;
  For I := 1 To RecordCount Do
    If IsDeleted( I ) Then
    Begin
      Result := True;
      Exit;
    End;
End;

Procedure TEzMemoryLayer.Recall;
Var
  N: Integer;
Begin
  If LayerInfo.Locked Then Exit;
  If FFiltered Then
    N := Longint( ol[FFilterRecno] )
  Else
    N := FRecno;
  If IsDeleted( N ) Then
    FDelStatus[N] := False;
  Modified := True;
End;

Function TEzMemoryLayer.GetRecordCount: Integer;
Begin
  result := FEntities.Count;
End;

Procedure SortOrderList( Layer: TEzBaseLayer; Solver: TEzMainExpr; var ol: TIntegerList);
var
  SortList: TEzSortList;
  templ: TIntegerList;
  I, J, Len: Integer;
Begin
  SortList:= TEzMemSortList.Create;
  Try
    { generate the sort fields }
    for I:= 0 to Solver.OrderByCount-1 do
    Begin
      Len := 0;
      if Solver.OrderByList[I].ExprType = ttString then
      begin
        Len := Solver.OrderByList[I].MaxLen;
      end;
      SortList.AddField( Solver.OrderByList[I].ExprType, Len,
        Solver.OrderDescending[I] );
    End;
    For I:= 0 to ol.Count-1 do
    begin
      Layer.Recno := ol[I];
      Layer.Synchronize;
      SortList.Insert;
      SortList.SourceRecno:= ol[I];
      For J := 0 To Solver.OrderByCount-1 Do
      begin
        Case Solver.OrderByList[J].ExprType Of
          ttString:
            SortList.Fields[J].Asstring := Solver.OrderByList[J].Asstring;
          ttFloat:
            SortList.Fields[J].AsFloat := Solver.OrderByList[J].AsFloat;
          ttInteger:
            SortList.Fields[J].AsInteger := Solver.OrderByList[J].AsInteger;
          ttBoolean:
            SortList.Fields[J].AsBoolean := Solver.OrderByList[J].AsBoolean;
        End;
      end;
    end;
    SortList.Sort;  // do sort
    { now create a new order list }
    templ:= TIntegerList.Create;
    For I:= 1 to SortList.Count do
    begin
      SortList.Recno := I;
      templ.Add( SortList.SourceRecno );
    end;
    ol.free;     // free old list
    ol:= templ;  // assign new order list
  Finally
    SortList.Free;
  End;
End;

Function TEzMemoryLayer.DefineScope( Const Scope: String ): Boolean;
Var
  Solver: TEzMainExpr;
Begin
  result := False;
  CancelFilter;
  Solver := TEzMainExpr.Create( Layers.GIS, Self );
  Try
    { ol must be created after this because a call to one of the
      queryxxx expression could cause ol to be set to nil }
    Solver.ParseExpression( Scope );
    If Solver.Expression.ExprType <> ttBoolean Then
      Raise EExpression.Create( SExprFail );
    ol := TIntegerList.Create;
    First;
    While Not Eof Do
    Begin
      If Not Solver.Expression.AsBoolean Then
        Continue;
      ol.Add( Recno );
    End;
    FFiltered := True;
    If ol.count > 0 Then
    Begin
      FFilterRecno := -1;
      { is a sorting defined ? }
      if Solver.OrderByCount > 0 then
      begin
        FFiltered := False;
        SortOrderList( Self, Solver, ol );
        FFiltered := True;
      end;
    End
    Else
    Begin
      FreeAndNil( ol );
      FFiltered := False;
    End;
  Finally
    Solver.Free;
  End;
End;

Function TEzMemoryLayer.DefinePolygonScope( Polygon: TEzEntity;
  Const Scope: String; Operator: TEzGraphicOperator ): Boolean;
Var
  Solver: TEzMainExpr;
  Entity: TEzEntity;
  Pass: Boolean;
  SearchType: TSearchType;
  temp_ol: TIntegerList;
Begin
  Result := False;
  CancelFilter;
  temp_ol := TIntegerList.Create;
  Solver := Nil;
  If Scope <> '' Then
  begin
    Solver := TEzMainExpr.Create( Layers.GIS, Self );
  end;
  Try
    If Solver <> Nil Then
    Begin
      Solver.ParseExpression( Scope );
      If Solver.Expression.ExprType <> ttBoolean Then
        Raise EExpression.Create( SExprFail );
    End;
    Case Operator Of
      goWithin, goContains, goIntersects:
        searchType := stOverlap;
      goEntirelyWithin, goContainsEntire:
        searchType := stEnclosure;
    Else
      searchType := stOverlap;
    End;
    SetGraphicFilter( searchType, Polygon.FBox );
    First;
    While Not Eof Do
    Begin
      Try
        Entity := RecLoadEntity;
        If Entity = Nil Then
          Continue;
        Try
          Pass := Entity.CompareAgainst( Polygon, Operator );
        Finally
          Entity.Free;
        End;
        If Pass Then
        Begin
          If Solver <> Nil Then
          Begin
            If DBTable <> Nil Then
              DBTable.Recno := Recno;
            If Not Solver.Expression.AsBoolean Then
              Continue;
          End;
          temp_ol.Add( Recno );
        End;
      Finally
        Next;
      End;
    End;
    CancelFilter;
    FFiltered := True;
    If temp_ol.count > 0 Then
    Begin
      FFilterRecno := -1;
      ol := temp_ol;
      { is a sorting defined ? }
      if ( Solver <> Nil ) And ( Solver.OrderByCount > 0 ) then
      begin
        FFiltered := False;
        SortOrderList( Self, Solver, ol );
        FFiltered := True;
      end;
      Result := True;
    End
    Else
    Begin
      FFiltered := False;
      FreeAndNil( temp_ol );
    End;
  Finally
    If Solver <> Nil Then
      Solver.Free;
  End;
End;

{-------------------------------------------------------------------------------}
{                  TSHPLayerInfo - class implementation                    }
{-------------------------------------------------------------------------------}

Function TSHPLayerInfo.GetIsCosmethic: boolean;
Begin
  result := TSHPLayer( FLayer ).FHeader.IsMemoryLayer;
End;

Procedure TSHPLayerInfo.SetIsCosmethic( value: boolean );
Begin
  If TSHPLayer( FLayer ).FHeader.IsMemoryLayer = value Then Exit;
  TSHPLayer( FLayer ).FHeader.IsMemoryLayer := value;
End;

Function TSHPLayerInfo.GetLocked: Boolean;
Begin
  result := TSHPLayer( FLayer ).FHeader.Locked;
End;

Procedure TSHPLayerInfo.SetLocked( Value: Boolean );
Begin
  TSHPLayer( FLayer ).FHeader.Locked := Value;
End;

Function TSHPLayerInfo.GetUseAttachedDB: boolean;
Begin
  result := TSHPLayer( FLayer ).FHeader.UseAttachedDB;
End;

Procedure TSHPLayerInfo.SetUseAttachedDB( Value: boolean );
Begin
  TSHPLayer( FLayer ).FHeader.UseAttachedDB := Value;
  SetModifiedStatus( FLayer );
End;

Function TSHPLayerInfo.GetVisible: boolean;
Begin
  result := TSHPLayer( FLayer ).FHeader.Visible;
End;

Procedure TSHPLayerInfo.SetVisible( Value: boolean );
Begin
  If TSHPLayer( FLayer ).FHeader.Visible = Value Then Exit;
  TSHPLayer( FLayer ).FHeader.Visible := Value;
  If Assigned( FLayer.Layers.GIS.OnVisibleLayerChange ) Then
    FLayer.Layers.GIS.OnVisibleLayerChange( Self, FLayer.Name );
  SetModifiedStatus( FLayer );
End;

Function TSHPLayerInfo.GetOverlappedTextAction: TEzOverlappedTextAction;
Begin
  result := TSHPLayer( FLayer ).FHeader.OverlappedTextAction;
End;

Procedure TSHPLayerInfo.SetOverlappedTextAction( Value: TEzOverlappedTextAction );
Begin
  If TSHPLayer( FLayer ).FHeader.OverlappedTextAction = Value Then Exit;
  TSHPLayer( FLayer ).FHeader.OverlappedTextAction := Value;
  SetModifiedStatus( FLayer );
End;

Function TSHPLayerInfo.GetOverlappedTextColor: TColor;
Begin
  result := TSHPLayer( FLayer ).FHeader.OverlappedTextColor;
End;

Procedure TSHPLayerInfo.SetOverlappedTextColor( Value: TColor );
Begin
  If TSHPLayer( FLayer ).FHeader.OverlappedTextColor = Value Then Exit;
  TSHPLayer( FLayer ).FHeader.OverlappedTextColor := Value;
  SetModifiedStatus( FLayer );
End;

Function TSHPLayerInfo.GetTextHasShadow: boolean;
Begin
  result := TSHPLayer( FLayer ).FHeader.TextHasShadow;
End;

Procedure TSHPLayerInfo.SetTextHasShadow( Value: boolean );
Begin
  If TSHPLayer( FLayer ).FHeader.TextHasShadow = Value Then Exit;
  TSHPLayer( FLayer ).FHeader.TextHasShadow := Value;
  SetModifiedStatus( FLayer );
End;

Function TSHPLayerInfo.GetTextFixedSize: Byte;
Begin
  result := TSHPLayer( FLayer ).FHeader.TextFixedSize;
End;

Procedure TSHPLayerInfo.SetTextFixedSize( Value: Byte );
Begin
  If TSHPLayer( FLayer ).FHeader.TextFixedSize = Value Then Exit;
  TSHPLayer( FLayer ).FHeader.TextFixedSize := Value;
  SetModifiedStatus( FLayer );
End;

Function TSHPLayerInfo.GetSelectable: boolean;
Begin
  result := TSHPLayer( FLayer ).FHeader.Selectable;
End;

Procedure TSHPLayerInfo.SetSelectable( Value: boolean );
Begin
  If TSHPLayer( FLayer ).FHeader.Selectable = Value Then Exit;
  TSHPLayer( FLayer ).FHeader.Selectable := Value;
  If Assigned( FLayer.Layers.GIS.OnSelectableLayerChange ) Then
    FLayer.Layers.GIS.OnSelectableLayerChange( Self, FLayer.Name );
  SetModifiedStatus( FLayer );
End;

Function TSHPLayerInfo.GetExtension: TEzRect;
Begin
  result := TSHPLayer( FLayer ).FHeader.Extension;
End;

Procedure TSHPLayerInfo.SetExtension( Const Value: TEzRect );
Begin
  If EqualRect2D( Value, TSHPLayer( FLayer ).FHeader.Extension ) Then Exit;
  TSHPLayer( FLayer ).FHeader.Extension := Value;
  SetModifiedStatus( FLayer );
End;

Function TSHPLayerInfo.GetIDCounter: integer;
Begin
  result := TSHPLayer( FLayer ).FHeader.IDCounter;
End;

Procedure TSHPLayerInfo.SetIDCounter( Value: integer );
Begin
  If TSHPLayer( FLayer ).FHeader.IDCounter = Value Then Exit;
  TSHPLayer( FLayer ).FHeader.IDCounter := Value;
  SetModifiedStatus( FLayer );
End;

Function TSHPLayerInfo.GetIsAnimationLayer: boolean;
Begin
  result := TSHPLayer( FLayer ).FHeader.IsAnimationLayer;
End;

Procedure TSHPLayerInfo.SetIsAnimationLayer( Value: boolean );
Begin
  If TSHPLayer( FLayer ).FHeader.IsAnimationLayer = Value Then Exit;
  TSHPLayer( FLayer ).FHeader.IsAnimationLayer := Value;
  SetModifiedStatus( FLayer );
End;

Function TSHPLayerInfo.GetCoordSystem: TEzCoordSystem;
Begin
  result := TSHPLayer( FLayer ).FHeader.CoordSystem;
End;

Procedure TSHPLayerInfo.SetCoordSystem( Value: TEzCoordSystem );
Begin
  If TSHPLayer( FLayer ).FHeader.CoordSystem = Value Then Exit;
  With TSHPLayer( FLayer ) Do
  Begin
    FHeader.CoordSystem := Value;
    If Value = csLatLon Then
    Begin
      CoordMultiplier := DEG_MULTIPLIER;
      FHeader.coordsunits := cuDeg;
    End
    Else
      CoordMultiplier := 1;
  End;
  SetModifiedStatus( FLayer );
End;

Function TSHPLayerInfo.GetCoordsUnits: TEzCoordsUnits;
Begin
  result := TSHPLayer( FLayer ).FHeader.CoordsUnits;
End;

Procedure TSHPLayerInfo.SetCoordsUnits( Value: TEzCoordsUnits );
Begin
  With TSHPLayer( FLayer ) Do
  Begin
    If FHeader.coordsunits = value Then
      Exit;
    If FHeader.CoordSystem = csLatLon Then
      FHeader.CoordsUnits := cuDeg
    Else
      FHeader.CoordsUnits := Value;
  End;
  SetModifiedStatus( FLayer );
End;

Function TSHPLayerInfo.GetIsIndexed: boolean;
Begin
  With TSHPLayer( FLayer ) Do
    result := FHeader.IsIndexed And ( Frt <> Nil );
End;

Procedure TSHPLayerInfo.SetIsIndexed( Value: boolean );
Begin
  If TSHPLayer( FLayer ).FHeader.IsIndexed = Value Then Exit;
  TSHPLayer( FLayer ).FHeader.IsIndexed := Value;
  SetModifiedStatus( FLayer );
End;

{-------------------------------------------------------------------------------}
{                  TSHPLayer - class implementation                            }
{-------------------------------------------------------------------------------}

Function ReverseInteger( value: integer ): integer;
Var
  pRes, pSrc: PFourBytes;
Begin
  pRes := @result;
  pSrc := @Value;

  pRes^[0] := pSrc^[3];
  pRes^[1] := pSrc^[2];
  pRes^[2] := pSrc^[1];
  pRes^[3] := pSrc^[0];
End;

Function ReverseDouble( Const value: double ): double;
Var
  pRes, pSrc: PEightBytes;
Begin
  pRes := @result;
  pSrc := @Value;

  pRes^[0] := pSrc^[7];
  pRes^[1] := pSrc^[6];
  pRes^[2] := pSrc^[5];
  pRes^[3] := pSrc^[4];
  pRes^[4] := pSrc^[3];
  pRes^[5] := pSrc^[2];
  pRes^[6] := pSrc^[1];
  pRes^[7] := pSrc^[0];
End;

Constructor TSHPLayer.Create( Layers: TEzBaseLayers; Const AFileName: String );
Begin
  Inherited Create( Layers, AFileName );
  FLayerInfo := TSHPLayerInfo.Create( self );
  FUpdateRtree := True;

  Self.FileName := ChangeFileExt( AFileName, '' );
  Self.Name := ExtractFileName( AFileName );
  With FHeader Do
  Begin
    HeaderID := 8003;
    VersionNumber := LAYER_VERSION_NUMBER;
    IDCounter := 0;
    Extension := INVALID_EXTENSION;
    Visible := True;
    Selectable := True;
    FillChar( Reserved, SizeOf( Reserved ), 0 );
  End;
  CoordMultiplier := 1;
End;

Destructor TSHPLayer.Destroy;
Begin
  Close;
  If ol <> Nil Then ol.free;
  If FBuffSHX <> Nil Then FBuffSHX.Free;
  If FBuffSHP <> Nil Then FBuffSHP.Free;
  // FLayerInfo is destroyed in the inherited class
  Inherited Destroy;
End;

Procedure TSHPLayer.InitializeOnCreate( Const FileName: String;
  AttachedDB, IsAnimation: Boolean; CoordSystem: TEzCoordSystem;
  CoordsUnits: TEzCoordsUnits; FieldList: TStrings );
Begin
  // for now, .shp files will not be created with this method
End;

function TSHPLayer.GetBookmark: Pointer;
var
  I: Integer;
  bmrk: TEzShapeBookmark;
begin
  bmrk:= TEzShapeBookmark.Create;
  bmrk.FRecno:= FRecno;
  bmrk.FFiltered:= FFiltered;
  bmrk.FEofCrack:= FEofCrack;
  bmrk.FFilterRecno:= FFilterRecno;
  bmrk.FCurrentLoaded:= FCurrentLoaded;
  bmrk.FIndexRec:= FIndexRec;
  bmrk.FSHPPos:= FSHPStream.Position;
  bmrk.FSHXPos:= FSHXStream.Position;
  if (ol <> nil) and (ol.Count > 0) then
  begin
    bmrk.Fol.Capacity:= ol.Count;
    for I:= 0 to ol.Count-1 do
      bmrk.Fol.Add( ol[I] );
  end;
  Result:= bmrk;
end;

procedure TSHPLayer.GotoBookmark(Bookmark: Pointer);
var
  I: Integer;
  bmrk: TEzShapeBookmark;
begin
  bmrk:= TEzShapeBookmark(Bookmark);
  FRecno:= bmrk.FRecno;
  FFiltered:= bmrk.FFiltered;
  FEofCrack:= bmrk.FEofCrack;
  FFilterRecno:= bmrk.FFilterRecno;
  FCurrentLoaded:= bmrk.FCurrentLoaded;
  FIndexRec:= bmrk.FIndexRec;
  FSHPStream.Position:= bmrk.FSHPPos;
  FSHXStream.Position:= bmrk.FSHXPos;
  if bmrk.Fol.Count > 0 then
  begin
    if ol = nil then ol := TIntegerList.Create;
    ol.Clear;
    ol.Capacity:= bmrk.Fol.Count;
    for I:= 0 to bmrk.Fol.Count-1 do
      ol.Add( bmrk.Fol[I] );
  end else if ol <> nil then
    ol.Clear;
end;

procedure TSHPLayer.FreeBookmark(Bookmark: Pointer);
begin
  TEzShapeBookmark(Bookmark).Free;
end;

Procedure TSHPLayer.GetFieldList( Strings: TStrings );
Var
  i: Integer;
Begin
  If DBTable <> Nil Then
    For i := 1 To DBTable.FieldCount Do
      Strings.Add( Format( '%s;%s;%d;%d', [DBTable.Field( I ), DBTable.FieldType( I ),
        DBTable.FieldLen( I ), DBTable.FieldDec( I )] ) );
End;

Procedure TSHPLayer.StartBatchInsert;
Begin
  FUpdateRtree := False;
End;

Procedure TSHPLayer.FinishBatchInsert;
Begin
  FUpdateRtree := True;
  RebuildTree;
End;

Procedure TSHPLayer.Zap;
Begin
  // nothing to do here
End;

Function TSHPLayer.GetDBTable: TEzBaseTable;
Begin
  result := FDbTable;
End;

Function TSHPLayer.GetRecno: Integer;
Begin
  If FFiltered Then
    result := Longint( ol[FFilterRecno] )
  Else
    result := FRecno;
End;

Procedure TSHPLayer.SetRecno( Value: Integer );
Begin
  If ( Value < 1 ) Or ( Value > FHeader.RecordCount ) Then
    EzGISError( SRecnoInvalid );
  FRecno := Value;
End;

Function TSHPLayer.SendEntityToBack( ARecno: Integer ): Integer;
Begin
  Result := 0;
  // nothing to do here
End;

Function TSHPLayer.BringEntityToFront( ARecno: Integer ): Integer;
Begin
  Result := 0;
  // nothing to do here
End;

Procedure TSHPLayer.SetGraphicFilter( s: TSearchType; Const VisualWindow: TEzRect );
Var
  treeBBox, viewBBox: TRect_rt;
Begin
  FFiltered := False;
  If Not FHeader.IsIndexed Then
    Exit;
  If ol = Nil Then
    ol := TIntegerList.Create
  Else
    ol.clear;
  treeBBox := Frt.RootExtent;
  viewBBox := FloatRect2Rect( VisualWindow );
  If Contains_rect( viewBBox, treeBBox ) Then
  Begin
    FreeAndNil( ol );
    Exit;
  End;
  Frt.Search( S, viewBBox, ol, FHeader.RecordCount );
  //SortList(ol);
  FFiltered := True;
  FFilterRecno := -1;
  FCurrentLoaded := 0;
End;

Procedure TSHPLayer.CancelFilter;
Begin
  If ol <> Nil Then FreeAndNil( ol );
  FFiltered := False;
End;

Function TSHPLayer.Eof: Boolean;
Begin
  result := FEofCrack;
End;

Procedure TSHPLayer.First;
Begin
  If FFiltered Then
  Begin
    If ol.Count > 0 Then
    Begin
      FFilterRecno := 0;
      FEofCrack := False;
    End
    Else
    Begin
      FEofCrack := True;
    End
  End
  Else If FHeader.RecordCount > 0 Then
  Begin
    If FBuffSHX <> Nil Then // is buffering ?
    Begin
      FBuffSHX.Read( FIndexRec, SizeOf( TIndexRec ) );
    End;
    FRecno := 1;
    FEofCrack := False;
  End
  Else
  Begin
    FEofCrack := True;
  End;
End;

Procedure TSHPLayer.Next;
Var
  N: Integer;
Begin
  If FFiltered Then
  Begin
    N := ol.count;
    If N > 0 Then
    Begin
      If FFilterRecno < N - 1 Then
      Begin
        Inc( FFilterRecno );
        FEofCrack := False;
      End
      Else
      Begin
        FFilterRecno := N - 1;
        FEofCrack := True;
      End;
    End
    Else
    Begin
      FEofCrack := True;
    End
  End
  Else
  Begin
    N := FHeader.RecordCount;
    If N > 0 Then
    Begin
      If FBuffSHX <> Nil Then // is buffering ?
      Begin
        FBuffSHX.Read( FIndexRec, SizeOf( TIndexRec ) );
      End;
      If FRecno < N Then
      Begin
        Inc( FRecno );
        FEofCrack := False;
      End
      Else
      Begin
        FRecno := N;
        FEofCrack := True;
      End;
    End
    Else
    Begin
      FEofCrack := True;
    End;
  End;
End;

Procedure TSHPLayer.Synchronize;
Begin
  If FDbTable <> Nil Then
    FDbTable.Recno := Self.Recno;
End;

Procedure TSHPLayer.Last;
Var
  N: Integer;
Begin
  If FFiltered Then
  Begin
    N := ol.count;
    If N > 0 Then
    Begin
      FFilterRecno := N - 1;
      FEofCrack := False;
    End
    Else
    Begin
      FEofCrack := True;
    End;
  End
  Else
  Begin
    N := FHeader.RecordCount;
    If N > 0 Then
    Begin
      FRecno := N;
      FEofCrack := False;
    End
    Else
    Begin
      FEofCrack := True;
    End;
  End;
End;

Procedure TSHPLayer.StartBuffering;
Begin
  EndBuffering;
  If FFiltered Then Exit; // not allowed buffering when it's filtered
  FSHXStream.Seek( sizeOf( TShapeHeader ) + ( FRecno - 1 ) * sizeOf( TIndexRec ), 0 );
  FBuffSHX := TEzBufferedRead.Create( FSHXStream, SIZE_LONGBUFFER );
  FBuffSHX.Read( FIndexRec, SizeOf( TIndexRec ) );
End;

Procedure TSHPLayer.EndBuffering;
Begin
  If FBuffSHX <> Nil Then
    FreeAndNil( FBuffSHX );
  FCurrentLoaded := 0;
End;

Procedure TSHPLayer.Assign( Source: TEzBaseLayer );
Begin
  // nothing to do here
End;

Procedure TSHPLayer.CheckNode( Var Node: TEzPoint );
Begin
  If ( Abs( Node.X ) < 1E-20 ) Or ( Abs( Node.X ) > MAXCOORD ) Then
    NOde.X := 0;
  If ( Abs( Node.Y ) < 1E-20 ) Or ( Abs( Node.Y ) > MAXCOORD ) Then
    NOde.Y := 0;
End;

Procedure TSHPLayer.CheckExtent( Var Extent: TEzRect );
Begin
  CheckNode( Extent.Emin );
  CheckNode( Extent.Emax );
End;

Procedure TSHPLayer.RebuildTree;
Var
  I, J, RecCount, Offset: Integer;
  GIS: TEzBaseGIS;
  Extent: TEzRect;
  PointRec: TPointRec;
  MultiPointRec: TMultiPointRec;
  PartsHeader: TPartsHeader;
  StreamRtc: TFileStream;
  StreamRtx: TFileStream;
  IdxInfo: TRTCatalog;
  dp: PDiskPage;
  Mode: Word;
Begin
  If Layers.GIS.ReadOnly Or Not FHeader.IsIndexed Then Exit;
  ForceOpened;
  If Not Active Then Exit;
  RecCount := Self.RecordCount;
  If Frt <> Nil Then FreeAndNil( Frt );
  Frt := TMemRTree.Create( Self, RTYPE, fmCreate );
  // Create the index
  Frt.CreateIndex( '', CoordMultiplier );
  // Now add all the entities to the tree
  FSHXStream.Seek( sizeOf( TShapeHeader ), 0 );

  GIS := Layers.GIS;
  Mode:= GIS.OpenMode;

  If RecCount > 0 Then
    GIS.StartProgress( Format( SRebuildTree, [Name] ), 1, RecCount );
  Try
    Try
      For I := 1 To RecCount Do
      Begin
        GIS.UpdateProgress( I );
        FSHXStream.Seek( ( I - 1 ) * sizeof( TIndexRec ) + sizeof( TShapeHeader ), 0 );
        FSHXStream.Read( FIndexRec, SizeOf( TIndexRec ) );
        Offset := ( ReverseInteger( FIndexRec.Offset ) * 2 ) + sizeOf( TRecHeader );
        BuffSHP.Seek( Offset, 0 );
        Case FShapeType Of
          1: // point
            Begin
              BuffSHP.Read( PointRec, sizeOf( TPointRec ) );
              If PointRec.ShapeType = 0 Then
                Continue; //null record
              Extent.Emin := PointRec.Node;
              Extent.Emax := Extent.Emin;
            End;
          3, 5: // arc, polygon
            Begin
              BuffSHP.Read( PartsHeader, sizeOf( TPartsHeader ) );
              If PartsHeader.ShapeType = 0 Then
                Continue; // null record
              Extent := PartsHeader.Extent;
            End;
          8: // multi-point
            Begin
              BuffSHP.Read( MultiPointRec, sizeOf( TMultiPointRec ) );
              If MultiPointRec.ShapeType = 0 Then
                Continue;
              Extent := MultiPointRec.Extent;
            End;
        End;
        CheckExtent( Extent );
        Frt.Insert( FloatRect2Rect( Extent ), I );
      End;
      { now create the files based on the memory r-tree }

      StreamRtc := TFileStream.Create( FileName + RTCEXT, fmCreate );
      StreamRtx := TFileStream.Create( FileName + RTXEXT, fmCreate );
      Try
        FillChar( IdxInfo, sizeof( IdxInfo ), 0 );
        With IdxInfo Do
        Begin
          PageCount := TMemRTree( Frt ).PageCount;
          Depth := TMemRTree( Frt ).Depth;
          FreePageCount := 0;
          RootNode := ( TMemRTree( Frt ).RootId - 1 ) * sizeof( TDiskPage );
          Implementor := 1; // 1=luis, 2=Garry
          TreeType := ttRTree;
          PageSize := 1;
          Version := TREE_VERSION;
          Multiplier := CoordMultiplier;
          BucketSize := ezrtree.BUCKETSIZE;
          LowerBound := ezrtree.LOWERBOUND;
          LastUpdate := Now;
        End;

        StreamRtc.Write( IdxInfo, sizeof( IdxInfo ) );
        { now write all the pages }
        For I := 0 To IdxInfo.PageCount - 1 Do
        Begin
          dp := TMemRTree( Frt ).DiskPagePtr[I];
          If dp^.Parent <> -1 Then
            dp^.Parent := ( dp^.Parent - 1 ) * sizeof( TDiskPage );
          If Not dp^.Leaf Then
            For J := 0 To dp^.FullEntries - 1 Do
              dp^.Entries[J].Child := ( dp^.Entries[J].Child - 1 ) * sizeof( TDiskPage );
          StreamRtx.Write( dp^, sizeof( TDiskPage ) );
        End;
      Finally
        StreamRtc.free;
        StreamRtx.free;
      End;

      Frt.Free; // delete memory rtree
      Frt := TEzRTree.Create( Self, RTYPE, Mode ); // open the disk based r-tree
      Frt.Open( Self.FileName, Mode );

    Except
      On E: Exception Do
      Begin
        MessageToUser( E.message, smsgerror, MB_ICONERROR );
        Raise;
      End;
    End;
  Finally
    If RecCount > 0 Then
      GIS.EndProgress;
  End;
  If Not FHeader.Visible Then
    Frt.Close;
End;

{Procedure TSHPLayer.UpdateMapExtension( Const R: TEzRect );
Var
  MapExt: TEzRect;
Begin
  If ( Layers = Nil ) Or ( Layers.GIS = Nil ) Then Exit;
  With Layers.GIS Do
  Begin
    MapExt := MapInfo.Extension;
    MaxBound( MapExt.Emax, R.Emax );
    MinBound( MapExt.Emin, R.Emin );
    MapInfo.Extension := MapExt;
    Modified := True;
  End;
End; }

Procedure TSHPLayer.Open;
Var
  AFileName: String;
  Mode: Word;
  GIS: TEzBaseGIS;
Begin

  Close;
  If Not FHeader.Visible Then Exit;

  GIS := Layers.GIS;

  Mode := GIS.OpenMode;
  AFileName := FileName + '.SHP';
  If Not FileExists( AFileName ) Then Exit;
  
  Try
    FSHPStream := TFileStream.Create( AFileName, Mode );
  Except
    On E: Exception Do
    Begin
      MessageToUser( E.Message, smsgerror, MB_ICONERROR );
      Raise;
    End;
  End;
  FSHPStream.Read( FShapeHeader, sizeOf( TShapeHeader ) );

  AFileName := Self.FileName + '.SHX';
  If Not FileExists( AFileName ) Then
  Begin
    Close;
    Exit;
  End;
  FSHXStream := TFileStream.Create( AFileName, Mode );

  AFileName := FileName + '.EZA'; // ArcView Link file
  If FileExists( AFileName ) Then
  Begin
    With TFileStream.Create( AFileName, fmOpenRead Or fmShareDenyNone ) Do
    Try
      Read( FHeader, sizeOf( TEzLayerHeader ) );
    Finally
      Free;
    End;
  End;

  FShapeType := FShapeHeader.ShapeType;
  With FHeader Do
  Begin
    UseAttachedDB := True;
    IsIndexed := True;
    RecordCount := ( FSHXStream.Size - sizeOf( TShapeHeader ) ) Div sizeOf( TIndexRec );
    If Layers.GIS.MapInfo.CoordSystem = csLatLon Then
      self.CoordMultiplier := DEG_MULTIPLIER
    Else
      self.CoordMultiplier := 1;
    Extension := FShapeHeader.Extent;
    //UpdateMapExtension( FShapeHeader.Extent );
  End;

  { open the r-tree file }
  Frt := TEzRTree.Create( Self, RTYPE, Mode );
  If Not FileExists( Self.FileName + RTXEXT ) Or
    Not FileExists( Self.FileName + RTCEXT ) Then
    // create the index
    RebuildTree
  Else
    Frt.Open( Self.FileName, Mode );

  AFileName := Self.FileName;
  If Not FileExists( AFileName + '.dbf' ) Then
  Begin
    FHeader.UseAttachedDB := False;
    Modified := True;
    //EzGISError( SDBFNotFound );
    //MessageToUser(SDBFNotFound, smsgerror, MB_ICONERROR);
    Exit;
  End Else
  Begin
    FDbTable := TEzSHPDbfTable.Create(Gis, AFileName, not Gis.ReadOnly, True);
    FDbTable.SetUseDeleted( True );
    //FDbTable.Index( Self.Name, '' );
  End;

End;

Procedure TSHPLayer.Close;
Var
  AFilename: String;
  Mode: Word;
Begin
  If FSHPStream <> Nil Then
  Begin
    If Not Layers.GIS.ReadOnly And Modified Then
    Begin
      AFileName := FileName + '.EZA';
      If Not FileExists( AFileName ) Then
        Mode := fmCreate
      Else
        Mode := fmOpenReadWrite Or fmShareDenyNone;
      With TFileStream.Create( AFilename, Mode ) Do
        Try
          Write( FHeader, sizeOf( TEzLayerHeader ) );
        Finally
          Free;
        End;
    End;
    FreeAndNil( FSHPStream );
    FreeAndNil( FBuffSHP );
  End;
  If FSHXStream <> Nil Then
  Begin
    FreeAndNil( FSHXStream );
  End;
  // free the r-tree
  If Frt <> Nil Then
    FreeAndNil( Frt );
  If FDbTable <> Nil Then
    FreeAndNil( FDbTable );

  Modified := False;
End;

Function TSHPLayer.GetActive: Boolean;
Begin
  result := FSHPStream <> Nil;
End;

Procedure TSHPLayer.SetActive( Value: Boolean );
Begin
  If Value Then
    Open
  Else
    Close;
End;

Procedure TSHPLayer.ForceOpened;
Begin
  If FSHPStream = Nil Then
    Open;
End;

Procedure TSHPLayer.WriteHeaders( FlushFiles: boolean );
Var
  AFilename: String;
  Mode: Word;
Begin
  If Layers.GIS.ReadOnly Or ( FSHPStream = Nil ) Then
  Begin
    Modified := False;
    Exit;
  End;
  If Modified Then
  Begin
    AFileName := FileName + '.EZA';
    If Not FileExists( AFilename ) Then
      Mode := fmCreate
    Else
      Mode := fmOpenReadWrite Or fmShareDenyNone;
    With TFileStream.Create( AFilename, Mode ) Do
    Try
      Write( FHeader, sizeOf( TEzLayerHeader ) );
    Finally
      Free;
    End;
    If FlushFiles Then
      Windows.FlushFileBuffers( TFileStream( FSHPStream ).Handle );
  End;
  If ( FSHXStream <> Nil ) And FlushFiles Then
  Begin
    Windows.FlushFileBuffers( TFileStream( FSHXStream ).Handle );
  End;
  If ( Frt <> Nil ) And FlushFiles Then Frt.FlushFiles;

  If ( FDbTable <> Nil ) And FlushFiles Then FDbTable.FlushDB;

  Modified := False;
End;

Function TSHPLayer.AddEntity( Entity: TEzEntity; Direct: Boolean = False ): Integer;
Var
  TmpID: TEzEntityID;
  I, np, NewRecNo: Integer;
  ShxOffset: Integer;
  IsShapeNative: Boolean;
  p: TEzPoint;
  PointRec: TPointRec;
  //MultiPointRec: TMultiPointRec;
  PartsHeader: TPartsHeader;
  AExtent: TEzRect;
  RecHeader: TRecHeader;
  IndexRec: TIndexRec;
  StartPos: Integer;
  V: TEzVector;
Begin
  { add a new entity to the shape file }
  result := 0;
  ForceOpened;
  If Layers.GIS.ReadOnly Or ( FSHPStream = Nil ) Or LayerInfo.Locked Then Exit;

  TmpID := Entity.EntityID;

  { check the entity }
  IsShapeNative := False;
  Case FShapeHeader.ShapeType Of
    1:
      Begin
        If Not ( TmpID In [idPlace] ) Then
          Exit;
        IsShapeNative := True;
      End;
    3:
      Begin
        If Not ( TmpID In [idPolyline, idArc, idSpline] ) Then
          Exit;
        IsShapeNative := ( TmpID = idPolyline );
      End;
    5:
      Begin
        If Not ( TmpID In [idPolygon, idRectangle, idEllipse] ) Then
          Exit;
        IsShapeNative := ( TmpID = idPolygon );
      End;
    8:
      Begin
        Exit;
        //if not (TmpID in [idPlace]) then Exit;
      End;
  End;

  If ( Entity.Points.Parts.Count > 1 ) Or IsShapeNative Then
    V := Entity.Points
  Else
    V := Entity.DrawPoints;

  If FShapeHeader.ShapeType = 1 Then
  Begin
    AExtent.Emin := V[0];
    AExtent.Emax := AExtent.Emin;
  End
  Else
    AExtent := Entity.FBox;
  //IndexRec.Offset:= ReverseInteger(StartPos div 2);
  With FShapeHeader.Extent Do
  Begin
    MaxBound( Emax, AExtent.Emax );
    MinBound( Emin, AExtent.Emin );
  End;
  With FHeader.Extension Do
  Begin
    MaxBound( Emax, AExtent.Emax );
    MinBound( Emin, AExtent.Emin );
  End;

  NewRecno := FHeader.RecordCount + 1;

  { add a new DBF record }
  If FDbTable <> Nil Then
  Begin
    FDbTable.Append( NewRecno );
    FDbTable.Post;
  End;

  { calculate the content length in big endian }
  Case FShapeHeader.ShapeType Of
    1:
      Begin
        PointRec.ShapeType := FShapeHeader.ShapeType;
        PointRec.Node := V[0];
        RecHeader.RecLength := ReverseInteger( ( 40 + 16 * 1 ) Div 2 );
      End;
    3, 5:
      Begin
        PartsHeader.ShapeType := FShapeHeader.ShapeType;
        PartsHeader.Extent := AExtent;
        PartsHeader.NumParts := EzLib.IMax( 1, V.Parts.Count );
        PartsHeader.NumPoints := V.Count;
        RecHeader.RecLength :=
          ReverseInteger( ( 44 + 4 * PartsHeader.NumParts + 16 * PartsHeader.NumPoints ) Div 2 );
      End;
  End;
  { calculate the record number in big endian }
  RecHeader.RecNumber := ReverseInteger( NewRecno );
  { Fill IndexRec }
  StartPos := FSHPStream.Size;
  IndexRec.Offset := ReverseInteger( StartPos Div 2 );
  IndexRec.Length := RecHeader.RecLength;
  ShxOffset := FSHXStream.Size; //sizeof(TShapeHeader) + (NewRecno - 1) * SizeOf(TIndexRec);
  FSHXStream.Seek( ShxOffset, 0 );
  FSHXStream.Write( IndexRec, SizeOf( TIndexRec ) );
  { write the record header }
  FSHPStream.Seek( StartPos, 0 );
  FSHPStream.Write( RecHeader, sizeof( TRecHeader ) );
  { write the info for this record }
  Case FShapeHeader.ShapeType Of
    1:
      Begin
        FSHPStream.Write( PointRec, sizeOf( TPointRec ) );
      End;
    3, 5:
      Begin
        FSHPStream.Write( PartsHeader, sizeOf( TPartsHeader ) );
        If PartsHeader.NumParts = 1 Then
        Begin
          np := 0;
          FSHPStream.Write( np, sizeOf( Integer ) );
        End
        Else
        Begin
          For I := 0 To PartsHeader.NumParts - 1 Do
          Begin
            np := Entity.Points.Parts[I];
            FSHPStream.Write( np, sizeOf( Integer ) );
          End;
        End;
        For I := 0 To V.Count - 1 Do
        Begin
          p := V[I];
          FSHPStream.Write( p, sizeOf( TEzPoint ) );
        End;
      End;
  End;
  { update the file extents }
  EzLib.MaxBound( FShapeHeader.Extent.Emax, AExtent.Emax );
  EzLib.MinBound( FShapeHeader.Extent.Emin, AExtent.Emin );

  { write the header of .shp file }
  FShapeHeader.FileLength := ReverseInteger( FSHPStream.Size Div 2 );
  FSHPStream.Seek( 0, 0 );
  FSHPStream.Write( FShapeHeader, sizeof( TShapeHeader ) );

  { write the header of .shx file }
  FShapeHeader.FileLength := ReverseInteger( FSHXStream.Size Div 2 );
  FSHXStream.Seek( 0, 0 );
  FSHXStream.Write( FShapeHeader, sizeof( TShapeHeader ) );

  { update the r-tree }
  Frt.Insert( FloatRect2Rect( AExtent ), NewRecno );

  { update the record count }
  FHeader.RecordCount := NewRecNo;

  //if AutoFlush then FlushFiles;

  result := NewRecno;

End;

Procedure TSHPLayer.UndeleteEntity( RecNo: Integer );
Begin
  // not possible to do
End;

Procedure TSHPLayer.DeleteEntity( RecNo: Integer );
Begin
  // nothing to do
End;

Function TSHPLayer.QuickUpdateExtension: TEzRect;
Begin
  UpdateExtension;
End;

Function TSHPLayer.UpdateExtension: TEzRect;
Var
  I, RecCount, Offset: Integer;
  GIS: TEzBaseGIS;
  PointRec: TPointRec;
  MultiPointRec: TMultiPointRec;
  PartsHeader: TPartsHeader;
  Extent: TEzRect;
Begin
  GIS := Layers.GIS;
  If GIS.ReadOnly Then Exit;
  ForceOpened;
  Result := INVALID_EXTENSION;
  // Now add all the entities to the tree
  FSHXStream.Seek( sizeOf( TShapeHeader ), 0 );
  FBuffSHX := TEzBufferedRead.Create( FSHXStream, SIZE_LONGBUFFER );
  //FHeader.RecordCount := Pred(FSHXStream.Size div SizeOf(TShxData));
  Try
    RecCount := Self.RecordCount;
    If RecCount > 0 Then
      GIS.StartProgress( Format( SUpdateExtension, [Name] ), 1, RecCount );
    For I := 1 To RecCount Do
    Begin
      GIS.UpdateProgress( I );
      FBuffSHX.Read( FIndexRec, SizeOf( TIndexRec ) );
      If ReverseInteger( FIndexRec.Length ) * 2 = 2 Then
        Continue;
      Offset := ( ReverseInteger( FIndexRec.Offset ) * 2 ) + sizeOf( TRecHeader );
      BuffSHP.Seek( Offset, 0 );
      Case FShapeType Of
        1:
          Begin
            BuffSHP.Read( PointRec, sizeOf( TPointRec ) );
            If PointRec.ShapeType = 0 Then
              continue;
            Extent.Emin := PointRec.Node;
            Extent.Emax := PointRec.Node;
          End;
        3, 5:
          Begin
            BuffSHP.Read( PartsHeader, sizeOf( TPartsHeader ) );
            If PartsHeader.ShapeType = 0 Then
              continue;
            Extent := PartsHeader.Extent;
          End;
        8:
          Begin
            BuffSHP.Read( MultiPointRec, sizeOf( TMultiPointRec ) );
            If MultiPointRec.ShapeType = 0 Then
              continue;
            Extent := MultiPointRec.Extent;
          End;
      End;
      CheckExtent( Extent );
      MaxBound( Result.Emax, Extent.Emax );
      MinBound( Result.Emin, Extent.Emin );
    End;
    FreeAndNil( FBuffSHP );
    // rebuild the r-tree
    RebuildTree;
    If RecCount > 0 Then
      GIS.EndProgress;
  Finally
    FreeAndNil( FBuffSHX );
  End;
  Modified := True;
  FHeader.Extension := Result;
  If AutoFlush Then
    WriteHeaders( True );
End;

Function TSHPLayer.InternalLoadEntity( Stream: TStream ): TEzEntity;
Var
  //EntityID: TEzEntityID;
  I, Offset, K: Integer;
  PartsHeader: TPartsHeader;
  Node: TEzPoint;
  MultiPointRec: TMultiPointRec;
  PointRec: TPointRec;
  ent: TEzEntity;
Begin
  result := Nil;
  If ReverseInteger( FIndexRec.Length ) * 2 = 2 Then Exit;

  Offset := ( ReverseInteger( FIndexRec.Offset ) * 2 ) + sizeOf( TRecHeader );
  Stream.Seek( Offset, 0 );

  Case FShapeType Of
    1:
      Begin
        Stream.Read( PointRec, sizeOf( TPointRec ) );
        If PointRec.ShapeType = 0 Then Exit;
        CheckNode( PointRec.Node );
        result := TEzPlace.CreateEntity( PointRec.Node );
        TEzPlace( result ).SymbolTool.Assign( Ez_Preferences.DefSymbolStyle );
      End;
    3, 5:
      Begin
        Stream.Read( PartsHeader, sizeOf( TPartsHeader ) );
        If PartsHeader.ShapeType = 0 Then Exit;

        If FShapeType = 5 Then
        Begin
          Result := TEzPolygon.Create( PartsHeader.NumPoints );
          TEzPolygon( result ).BrushTool.Assign( Ez_Preferences.DefBrushStyle );
        End
        Else
          Result := TEzPolyLine.Create( PartsHeader.NumPoints );
        TEzPolyline( result ).PenTool.Assign( Ez_Preferences.DefPenStyle );
        If PartsHeader.NumParts = 1 Then
          Stream.Read( K, sizeOf( Integer ) )
        Else
        Begin
          //if PartsHeader.NumParts>EzLib.MAX_PARTS then
          //  EzGISError(IntToStr(PartsHeader.NumParts));
          For I := 1 To PartsHeader.NumParts Do
          Begin
            Stream.Read( K, sizeOf( Integer ) );
            //if I <= EzLib.MAX_PARTS then
            Result.Points.Parts.Add( K )
          End;
        End;
        //if PartsHeader.NumPoints>EzLib.MAX_POINTS then  no limits on no. of points now!!!
        //  EzGISError(IntToStr(PartsHeader.NumPoints));
        result.BeginUpdate;
        For I := 1 To PartsHeader.NumPoints Do
        Begin
          Stream.Read( Node, sizeOf( TEzPoint ) );
          CheckNode( Node );
          //if I <= EzLib.MAX_POINTS then
          Result.Points.Add( Node );
        End;
        result.EndUpdate;
      End;
    8:
      Begin
        Stream.Read( MultiPointRec, sizeOf( TMultiPointRec ) );
        If MultiPointRec.ShapeType = 0 Then
          Exit;
        result := TEzGroupEntity.CreateEntity;
        For I := 1 To MultiPointRec.NumPoints Do
        Begin
          Stream.Read( Node, sizeOf( TEzPoint ) );
          CheckNode( Node );
          ent := TEzPlace.CreateEntity( Node );
          TEzPlace( ent ).SymbolTool.Assign( Ez_Preferences.DefSymbolStyle );
          TEzGroupEntity( result ).Add( ent );
        End;
      End
  End;
End;

Function TSHPLayer.LoadEntityWithRecNo( RecNo: Longint): TEzEntity;
Begin
  { RecNo is base 1 }
  Result := Nil;
  If ( RecNo < 1 ) Or ( RecNo > FHeader.RecordCount ) Then Exit;
  FSHXStream.Seek( sizeOf( TShapeHeader ) + ( RecNo - 1 ) * SizeOf( TIndexRec ), 0 );
  FSHXStream.Read( FIndexRec, SizeOf( TIndexRec ) );
  Result := InternalLoadEntity( BuffSHP );
End;

Procedure TSHPLayer.UpdateEntity( RecNo: Integer; Entity2D: TEzEntity );
Begin
End;

Procedure TSHPLayer.Pack;
Begin
End;

Procedure TSHPLayer.Repair;
Begin
End;

Procedure TSHPLayer.ReadIndexRec( Recnum: Integer );
Begin
  FSHXStream.Seek( sizeOf( TShapeHeader ) + ( Recnum - 1 ) * sizeOf( TIndexRec ), 0 );
  FSHXStream.Read( FIndexRec, sizeOf( TIndexRec ) );
End;

function TSHPLayer.GetExtensionForRecords(List: TIntegerList): TEzRect;
var
  I, TheRecno, Offset :Integer;
  PointRec: TPointRec;
  MultiPointRec: TMultiPointRec;
  PartsHeader: TPartsHeader;
  Extent: TEzRect;
begin
  Result:= INVALID_EXTENSION;
  if (List=nil) or (List.Count=0) then Exit;
  for I:= 0 to List.Count-1 do
  begin
    TheRecno:= List[I];
    if (TheRecno < 1) or (TheRecno > FHeader.RecordCount) then Continue;
    ReadIndexRec( TheRecno );
    Offset := ( ReverseInteger( FIndexRec.Offset ) * 2 ) + sizeOf( TRecHeader );
    BuffSHP.Seek( Offset, 0 );
    Case FShapeType Of
      1: // point
        Begin
          BuffSHP.Read( PointRec, sizeOf( TPointRec ) );
          If PointRec.ShapeType = 0 Then
            Continue; //null record
          Extent.Emin := PointRec.Node;
          Extent.Emax := Extent.Emin;
        End;
      3, 5: // arc, polygon
        Begin
          BuffSHP.Read( PartsHeader, sizeOf( TPartsHeader ) );
          If PartsHeader.ShapeType = 0 Then
            Continue; // null record
          Extent := PartsHeader.Extent;
        End;
      8: // multi-point
        Begin
          BuffSHP.Read( MultiPointRec, sizeOf( TMultiPointRec ) );
          If MultiPointRec.ShapeType = 0 Then
            Continue;
          Extent := MultiPointRec.Extent;
        End;
    End;
    CheckExtent( Extent );
    MaxBound(Result.Emax, Extent.Emax);
    MinBound(Result.Emin, Extent.Emin);
  end;
end;

Function TSHPLayer.RecExtension: TEzRect;
Var
  N: Integer;
  Offset: Integer;
  PartsHeader: TPartsHeader;
  MultiPointRec: TMultiPointRec;
  PointRec: TPointRec;
Begin
  If FFiltered Then
    N := Longint( ol[FFilterRecno] )
  Else
    N := FRecno;
  ReadIndexRec( N );
  Offset := ( ReverseInteger( FIndexRec.Offset ) * 2 ) + sizeOf( TRecHeader );
  BuffSHP.Seek( Offset, 0 );
  Case FShapeType Of
    1:
      Begin
        BuffSHP.Read( PointRec, sizeOf( TPointRec ) );
        Result.Emin := PointRec.Node;
        Result.Emax := PointRec.Node;
      End;
    3, 5:
      Begin
        BuffSHP.Read( PartsHeader, sizeOf( TPartsHeader ) );
        Result := PartsHeader.Extent;
      End;
    8:
      Begin
        BuffSHP.Read( MultiPointRec, sizeOf( TMultiPointRec ) );
        Result := MultiPointRec.Extent;
      End;
  End;
  CheckExtent( Result );
  FCurrentLoaded := N;
End;

Function TSHPLayer.RecLoadEntity: TEzEntity;
Var
  N: Integer;
Begin
  If FBuffSHX = Nil Then
  Begin
    If FFiltered Then
      N := Longint( ol[FFilterRecno] )
    Else
      N := FRecno;
    If FCurrentLoaded <> N Then
    Begin
      ReadIndexRec( N );
      FCurrentLoaded := N;
    End;
  End;
  result := InternalLoadEntity( BuffSHP );
End;

Procedure TSHPLayer.RecLoadEntity2( Entity: TEzEntity );
Var
  I, N, Offset, K: Integer;
  Node: TEzPoint;
  PartsHeader: TPartsHeader;
  MultiPointRec: TMultiPointRec;
  PointRec: TPointRec;
  GroupEnt: TEzEntity;
Begin
  If FBuffSHX = Nil Then
  Begin
    If FFiltered Then
      N := Longint( ol[FFilterRecno] )
    Else
      N := FRecno;
    If FCurrentLoaded <> N Then
    Begin
      ReadIndexRec( N );
      FCurrentLoaded := N;
    End;
  End;
  Entity.Points.Clear;
  If ReverseInteger( FIndexRec.Length ) * 2 = 2 Then Exit;

  Offset := ( ReverseInteger( FIndexRec.Offset ) * 2 ) + sizeOf( TRecHeader );
  BuffSHP.Seek( Offset, 0 );
  Case FShapeType Of
    1:
      Begin
        BuffSHP.Read( PointRec, sizeOf( TPointRec ) );
        If PointRec.ShapeType = 0 Then Exit;
        CheckNode( PointRec.Node );
        Entity.Points.Add( PointRec.Node );
        TEzPlace( Entity ).SymbolTool.Assign( Ez_Preferences.DefSymbolStyle );
      End;
    3, 5:
      Begin
        BuffSHP.Read( PartsHeader, sizeOf( TPartsHeader ) );
        If PartsHeader.ShapeType = 0 Then Exit;
        If PartsHeader.NumParts = 1 Then
          BuffSHP.Read( K, sizeOf( Integer ) )
        Else
        Begin
          For I := 1 To PartsHeader.NumParts Do
          Begin
            BuffSHP.Read( K, sizeOf( Integer ) );
            If K > PartsHeader.NumPoints - 1 Then
              EzGISError( SInternalListError );
            //if I <= EzLib.MAX_PARTS then
            Entity.Points.Parts.Add( K );
          End;
        End;
        For I := 1 To PartsHeader.NumPoints Do
        Begin
          BuffSHP.Read( Node, sizeOf( TEzPoint ) );
          CheckNode( Node );
          //if I <= EzLib.MAX_POINTS then
          Entity.Points.Add( Node );
        End;
        If FShapeType = 5 Then
        Begin
          TEzPolygon( Entity ).BrushTool.Assign( Ez_Preferences.DefBrushStyle );
        End;
        TEzPolyline( Entity ).PenTool.Assign( Ez_Preferences.DefPenStyle );
      End;
    8: // a group entity is used
      Begin
        ( Entity As TEzGroupEntity ).Clear;
        BuffSHP.Read( MultiPointRec, sizeOf( TMultiPointRec ) );
        If MultiPointRec.ShapeType = 0 Then Exit;
        For I := 1 To MultiPointRec.NumPoints Do
        Begin
          BuffSHP.Read( Node, sizeOf( TEzPoint ) );
          CheckNode( Node );
          GroupEnt:= TEzPlace.CreateEntity( Node );
          TEzPlace( GroupEnt ).SymbolTool.Assign( Ez_Preferences.DefSymbolStyle );
          TEzGroupEntity( Entity ).Add( GroupEnt );
        End;
      End
  End;
End;

Function TSHPLayer.RecEntityID: TEzEntityID;
Begin
  Case FShapeType Of
    1: result := idPlace;
    3: result := idPolyline;
    5: result := idPolygon;
    8: result := idGroup;
  Else
    result := idPlace;
  End;
End;

Function TSHPLayer.RecIsDeleted: boolean;
Var
  N, Offset: Integer;
  PartsHeader: TPartsHeader;
  MultiPointRec: TMultiPointRec;
  PointRec: TPointRec;
Begin
  If FBuffSHX = Nil Then
  Begin
    If FFiltered Then
      N := Longint( ol[FFilterRecno] )
    Else
      N := FRecno;
    If FCurrentLoaded <> N Then
    Begin
      ReadIndexRec( N );
      FCurrentLoaded := N;
    End;
  End;
  result := ReverseInteger( FIndexRec.Length ) * 2 = 2;
  If result = False Then
  Begin
    Offset := ( ReverseInteger( FIndexRec.Offset ) * 2 ) + sizeOf( TRecHeader );
    FSHPStream.Seek( Offset, 0 );
    Case FShapeType Of
      1:
        Begin
          FSHPStream.Read( PointRec, sizeOf( TPointRec ) );
          result := PointRec.ShapeType = 0;
        End;
      3, 5:
        Begin
          FSHPStream.Read( PartsHeader, sizeOf( TPartsHeader ) );
          result := PartsHeader.ShapeType = 0;
        End;
      8:
        Begin
          FSHPStream.Read( MultiPointRec, sizeOf( TMultiPointRec ) );
          result := MultiPointRec.ShapeType = 0;
        End;
    End;
  End;
End;

Procedure TSHPLayer.CopyRecord( SourceRecno, DestRecno: Integer );
Begin
  // nothing to do here
End;

Function TSHPLayer.ContainsDeleted: boolean;
Begin
  Result := False;
End;

Procedure TSHPLayer.Recall;
Begin
  // nothing to do here
End;

Function TSHPLayer.BuffSHP: TStream;
Begin
  If FShapeType In [1, 8] Then
  Begin
    Result := FSHPStream;
    Exit;
  End;
  If FBuffSHP = Nil Then
  Begin
    FBuffSHP := TEzBufferedRead.Create( FSHPStream, 512 * 2 );
  End;
  Result := FBuffSHP;
End;

Function TSHPLayer.GetRecordCount: Integer;
Begin
  result := FHeader.RecordCount;
End;

Function TSHPLayer.DefineScope( Const Scope: String ): Boolean;
Var
  Solver: TEzMainExpr;
Begin
  result := False;
  CancelFilter;
  Solver := TEzMainExpr.Create( Layers.GIS, Self );
  Try
    { ol must be create after this because a call to one of the
      queryxxx expression could cause ol to be set to nil }
    Solver.ParseExpression( Scope );
    If Solver.Expression.ExprType <> ttBoolean Then
      Raise EExpression.Create( SExprFail );
    ol := TIntegerList.Create;
    First;
    StartBuffering;
    Try
      While Not Eof Do
      Begin
        Try
          If RecIsDeleted Then
            Continue;
          Self.Synchronize;
          If Not Solver.Expression.AsBoolean Then Continue;

          ol.Add( Recno );
        Finally
          Next;
        End;
      End;
      FFiltered := True;
      If ol.count > 0 Then
      Begin
        FFilterRecno := -1;
        FCurrentLoaded := 0;
        { is a sorting defined ? }
        if Solver.OrderByCount > 0 then
        begin
          FFiltered := False;
          SortOrderList( Self, Solver, ol );
          FFiltered := True;
        end;
      End
      Else
      Begin
        FFiltered := False;
        FreeAndNil( ol );
      End;
    Finally
      EndBuffering;
    End;
  Finally
    Solver.Free;
  End;
End;

Function TSHPLayer.DefinePolygonScope( Polygon: TEzEntity; Const Scope: String;
  Operator: TEzGraphicOperator ): Boolean;
Var
  Solver: TEzMainExpr;
  Entity: TEzEntity;
  Pass: Boolean;
  SearchType: TSearchType;
  temp_ol: TIntegerList;
Begin
  Result := False;
  CancelFilter;
  temp_ol := TIntegerList.Create;
  Solver := Nil;
  If Length( Scope ) > 0 Then
    Solver := TEzMainExpr.Create( Layers.GIS, Self );
  Try
    If Solver <> Nil Then
    Begin
      Solver.ParseExpression( Scope );
      If Solver.Expression.ExprType <> ttBoolean Then
        Raise EExpression.Create( SExprFail );
    End;
    Case Operator Of
      goWithin, goContains, goIntersects:
        searchType := stOverlap;
      goEntirelyWithin, goContainsEntire:
        searchType := stEnclosure;
    Else
      searchType := stOverlap;
    End;
    SetGraphicFilter( searchType, Polygon.FBox );
    First;
    While Not Eof Do
    Begin
      Try
        If RecIsDeleted Then
          Continue;
        Entity := RecLoadEntity;
        If Entity = Nil Then
          Continue;
        Try
          Pass := Entity.CompareAgainst( Polygon, Operator );
        Finally
          Entity.Free;
        End;
        If Pass Then
        Begin
          If Solver <> Nil Then
          Begin
            Self.Synchronize;
            If Not Solver.Expression.AsBoolean Then Continue;
          End;
          temp_ol.Add( Recno );
        End;
      Finally
        Next;
      End;
    End;
    CancelFilter;
    FFiltered := True;
    If temp_ol.count > 0 Then
    Begin
      FFilterRecno := -1;
      FCurrentLoaded := 0;
      ol := temp_ol;
      Result := True;
      { is a sorting defined ? }
      if ( Solver <> Nil ) And ( Solver.OrderByCount > 0 ) then
      begin
        FFiltered := False;
        SortOrderList( Self, Solver, ol );
        FFiltered := True;
      end;
    End
    Else
    Begin
      FFiltered := False;
      FreeAndNil( temp_ol );
    End;
  Finally
    If Solver <> Nil Then
      Solver.Free;
  End;
End;

{-----------------------------------------------------------------------------}
{                  TEzLayers - class implementation                           }
{-----------------------------------------------------------------------------}

Function TEzLayers.Add( Const FileName: String; LayerType: TEzLayerType ): Integer;
Var
  CanInsert: Boolean;
  Layer: TEzBaseLayer;
Begin
  Result := -1;
  if Gis.ReadOnly then Exit;
  CanInsert := True;
  If Assigned( GIS.OnBeforeInsertLayer ) Then
    GIS.OnBeforeInsertLayer( GIS, FileName, CanInsert );

  If Not CanInsert Then Exit;

  Layer := Gis.CreateLayer( FileName, LayerType );
  Result := Layer.Index;

  If Assigned( GIS.OnAfterInsertLayer ) Then
    GIS.OnAfterInsertLayer( GIS, FileName );
End;

Function AddLayerTo( GIS: TEzBaseGIS;
                     Const FileName: String;
                     IsAnimation, WithDB: Boolean;
                     LayerType: TEzLayerType;
                     CoordSystem: TEzCoordSystem;
                     CoordsUnits: TEzCoordsUnits;
                     FieldList: TStrings ): TEzBaseLayer;
Var
  FilePath, news, layname: String;

  Function LayerExists( Const FileName: String): Boolean;
  Var
    layname: String;
  Begin
    layname := ChangeFileExt( FileName, '' );
    If LayerType= ltMemory Then
      Result := FileExists( layname + CADEXT )
    Else
      Result := FileExists( layname + EZDEXT ) And
                FileExists( layname + EZXEXT );
  End;

Begin

  If GIS.ReadOnly Then Exit;

  If CoordSystem = csLatLon Then
    CoordsUnits := cuDeg;

  If Length( Trim( FileName ) ) = 0 Then
    EzGISError( Format( SWronglayerName, [FileName] ) );

  If LayerExists( FileName) Then
    EzGISError( SDuplicatelayer );

  layname := FileName;
  FilePath := ExtractFilePath( layname );
  If Length( FilePath ) = 0 Then
    FilePath := ExtractFilePath( GIS.FileName );
  FilePath := AddSlash( FilePath );
  news := EzSystem.GetValidLayerName( ExtractFileName( layname ) );
  While GIS.Layers.IndexOfName( ExtractFilename( news ) ) >= 0 do
    news:= news + '_';
  layname:= FilePath + news;

  Result := Gis.CreateLayer( layname, LayerType );
  Try
    Result.InitializeOnCreate( layname, WithDb, IsAnimation, CoordSystem,
      CoordsUnits, FieldList );
  Except
    FreeAndNil( Result );
    Raise;
  End;
  Result.Open;
End;

{ creates a standar layer }
Function TEzLayers.CreateNew( Const FileName: String; FieldList: TStrings ): TEzBaseLayer;
Var
  CanInsert: Boolean;
Begin
  Result := Nil;
  if Gis.ReadOnly then Exit;
  CanInsert := True;
  If Assigned( GIS.OnBeforeInsertLayer ) Then
    GIS.OnBeforeInsertLayer( GIS, FileName, CanInsert );

  If Not CanInsert Then Exit;

  Result := AddLayerTo( GIS, FileName, False, True, ltDesktop, GIS.MapInfo.CoordSystem,
    GIS.MapInfo.CoordsUnits, FieldList );
  If Assigned( GIS.OnAfterInsertLayer ) Then
    GIS.OnAfterInsertLayer( GIS, FileName );
End;

{ creates a standard layer with coordinate parameters }
Function TEzLayers.CreateNewEx( Const FileName: String; CoordSystem: TEzCoordSystem;
  CoordsUnits: TEzCoordsUnits; FieldList: TStrings ): TEzBaseLayer;
Var
  CanInsert: Boolean;
Begin
  Result := Nil;
  if Gis.ReadOnly then Exit;
  CanInsert := True;
  If Assigned( GIS.OnBeforeInsertLayer ) Then
    GIS.OnBeforeInsertLayer( GIS, FileName, CanInsert );
  If Not CanInsert Then Exit;
  Result := AddLayerTo( GIS, FileName, False, True, ltDesktop, CoordSystem, CoordsUnits, FieldList );
  If Assigned( GIS.OnAfterInsertLayer ) Then
    GIS.OnAfterInsertLayer( GIS, FileName );
End;

{ create new cosmethic / memory layer }
Function TEzLayers.CreateNewCosmethic( Const FileName: String ): TEzBaseLayer;
Var
  CanInsert: Boolean;
Begin
  Result := Nil;
  if Gis.ReadOnly then Exit;
  CanInsert := True;
  If Assigned( GIS.OnBeforeInsertLayer ) Then
    GIS.OnBeforeInsertLayer( GIS, FileName, CanInsert );
  If Not CanInsert Then Exit;
  If FileExists( FileName ) Then
    SysUtils.DeleteFile( FileName );

  Result := AddLayerTo( GIS, FileName,
                        False, False, ltMemory,
                        GIS.MapInfo.CoordSystem,
                        GIS.MapInfo.CoordsUnits, Nil );

  If Assigned( GIS.OnAfterInsertLayer ) Then
    GIS.OnAfterInsertLayer( GIS, FileName );
End;

Function TEzLayers.CreateNewAnimation( Const FileName: String ): TEzBaseLayer;
Var
  CanInsert: Boolean;
Begin
  Result := Nil;
  if Gis.ReadOnly then Exit;
  CanInsert := True;
  If Assigned( GIS.OnBeforeInsertLayer ) Then
    GIS.OnBeforeInsertLayer( GIS, FileName, CanInsert );
  If Not CanInsert Then Exit;

  Result := AddLayerTo( GIS, FileName,
    True, False, ltDesktop,
    GIS.MapInfo.CoordSystem,
    GIS.MapInfo.CoordsUnits, Nil );

  If Assigned( GIS.OnAfterInsertLayer ) Then
    GIS.OnAfterInsertLayer( GIS, FileName );
End;

Function TEzLayers.Delete( Const LayerName: String; DeleteFiles: Boolean ): Boolean;
Var
  Layer: TEzBaseLayer;
  i, Index: Integer;
  CanDelete: Boolean;
Begin
  Result:= False;
  If GIS.ReadOnly Then Exit;
  { delete layer Index }
  Index := IndexOfName( LayerName );
  If Index < 0 Then Exit;
  Layer := Items[Index];
  CanDelete := True;
  If Assigned( GIS.OnBeforeDeleteLayer ) Then
    GIS.OnBeforeDeleteLayer( Self, LayerName, CanDelete );
  If Not CanDelete Then Exit;
  { notify to all DrawBox about deletion of layer }
  If GIS.MapInfo.IsValid Then
  Begin
    For I := 0 To GIS.DrawBoxList.Count - 1 Do
      GIS.DrawBoxList[I].Selection.DeleteLayer( Layer );
  End;

  Layer.Close;
  Try
    If DeleteFiles And Not Layer.DeleteLayerFiles Then
    Begin
      Layer.Open;
      EzGISError( SCannotDeleteLayer );
    End;

    { take it as deleted }
    Layer.Free;
    { notify of deletion of layer }
    If Assigned( GIS.OnAfterDeleteLayer ) Then
      GIS.OnAfterDeleteLayer( Self, LayerName );
  Except
    Layer.Open;
    Raise;
  End;
  Result:= True;

End;

{-------------------------------------------------------------------------------}
{                  TEzDrawBox - class implementation                         }
{-------------------------------------------------------------------------------}

Function TEzDrawBox.CurrentScale: Double;
Var
  ScaleDist: Integer;
  Units: TEzScaleUnits;
Begin
  Units:= DefaultScaleUnits;
  If FScaleBar <> Nil Then
    Units:= FScaleBar.IntervalLengthUnits;
  Case Units Of
    suInches: ScaleDist := Grapher.ScreenDpiX; // inches
    suMms: ScaleDist := Round( Grapher.ScreenDpiX / 25.4 ); // mms
    suCms: ScaleDist := Round( Grapher.ScreenDpiX / 2.54 ); // cms
  Else
    ScaleDist := Grapher.ScreenDpiX;
  End;
  Result := Grapher.DistToRealX( ScaleDist );
End;

procedure TEzDrawBox.ViewChanged(Sender: TObject);
begin
  inherited ViewChanged( Sender );
  If Assigned( FScaleBar ) And FScaleBar.Visible then
  Begin
    FScaleBar.Invalidate;
  End;
  If Assigned( OnZoomChange ) Then
    OnZoomChange( Self, Self.CurrentScale );
end;

procedure TEzDrawBox.Notification(AComponent: TComponent;
  Operation: TOperation);
begin
  Inherited Notification( AComponent, Operation );
  If ( Operation = opRemove ) And ( AComponent = FScaleBar ) Then
    FScaleBar := Nil
end;

procedure TEzDrawBox.SetScaleBar(Value: TEzScaleBar);
begin
{$IFDEF LEVEL5}
  if Assigned( FScaleBar ) then FScaleBar.RemoveFreeNotification( Self );
{$ENDIF}
  If Value <> Nil Then
  Begin
    Value.FreeNotification( Self );
    Value.Parent:= Self;
    Value.FNeedReposition:= True;
    If Assigned( GIS ) And Assigned( GIS.MapInfo ) And GIS.MapInfo.IsValid Then
      Value.FUnits:= GIS.MapInfo.CoordsUnits;
  End;
  FScaleBar:= Value;
end;

Procedure TEzDrawBox.UpdateViewport(WCRect: TEzRect);
Var
  TheCanvas: TCanvas;
  VisualWindow: TEzRect;

Begin
  //If Not Showing then Exit;
  { check if WCRect is bigger than current view area }
  VisualWindow := Grapher.CurrentParams.VisualWindow;
  if (WCRect.X1 < VisualWindow.X1) or (WCRect.Y1 < VisualWindow.Y1) or
     (WCRect.X2 > VisualWindow.X2) or (WCRect.Y2 > VisualWindow.Y2) then
  begin
    WCRect:= IntersectRect2D(WCRect, VisualWindow);
    if EqualRect2D(WCRect, NULL_EXTENSION) then Exit;
  end;

  Inherited UpdateViewport( WCRect );

  TheCanvas := Canvas;
  If odCanvas In OutputDevices Then
    TheCanvas := Canvas
  Else If odBitmap In OutputDevices Then
    TheCanvas := ScreenBitmap.Canvas;

  With TEzPainterObject.Create(Nil) Do
  Try
    DrawEntities( WCRect,
                  GIS,
                  TheCanvas,
                  Grapher,
                  Selection,
                  False,
                  False,
                  pmAll,
                  Self.ScreenBitmap );
  Finally
    Free;
  End;

  { draw the ruler }
  If ScreenGrid.Show Then
    EzSystem.PaintDrawBoxFSGrid( Self, Grapher.CurrentParams.VisualWindow );
End;

{-------------------------------------------------------------------------------}
{                  TEzSymbolsBox - class implementation                     }
{-------------------------------------------------------------------------------}

Constructor TEzSymbolsBox.Create( AOwner: TComponent );
Begin
  Inherited Create( AOwner );
  GIS := TEzCAD.Create( Nil );
  FShowExtension:= True;
  CreateNewEditor;
End;

Destructor TEzSymbolsBox.Destroy;
Begin
  GIS.Free;
  Inherited Destroy;
End;

Procedure TEzSymbolsBox.CreateNewEditor;
Begin
  GIS.Close;
  GIS.Open;
  GIS.Layers.CreateNewCosmethic( 'A0' );
  GIS.CurrentLayerName := 'A0';
  Grapher.Clear;
End;

{$IFDEF BCB}
Function TEzSymbolsBox.GetShowExtension: Boolean;
Begin
  Result:= FShowExtension;
End;

procedure TEzSymbolsBox.SetShowExtension(const Value: Boolean);
begin
  FShowExtension := Value;
end;
{$ENDIF}

Procedure TEzSymbolsBox.UpdateViewport( WCRect: TEzRect );
Var
  BoundEnt: TEzEntity;
  BoundRect: TEzRect;
  DistX, DistY: Double;
  DrawMode: TEzDrawMode;
  Extent: TEzRect;
  Xc, Yc: Double;
  TheCanvas: TCanvas;
  VisualWindow: TEzRect;
Begin
  //If Not Showing then Exit;

  { check if WCRect is bigger than current view area }
  VisualWindow := Grapher.CurrentParams.VisualWindow;
  if (WCRect.X1 < VisualWindow.X1) or (WCRect.Y1 < VisualWindow.Y1) or
     (WCRect.X2 > VisualWindow.X2) or (WCRect.Y2 > VisualWindow.Y2) then
  begin
    WCRect:= IntersectRect2D(WCRect, VisualWindow);
    if EqualRect2D(WCRect, NULL_EXTENSION) then Exit;
  end;

  Inherited UpdateViewport( WCRect );

  TheCanvas := Canvas;
  If odCanvas In OutputDevices Then
    TheCanvas := Canvas
  Else If odBitmap In OutputDevices Then
    TheCanvas := ScreenBitmap.Canvas;

  With TEzPainterObject.Create(Nil) Do
  Try
    DrawEntities( WCRect,
                  GIS,
                  TheCanvas,
                  Grapher,
                  Selection,
                  False,
                  False,
                  pmAll,
                  Self.ScreenBitmap );
  Finally
    Free;
  End;

  If FShowExtension And (odBitmap In OutputDevices) Then
  Begin
    If GIS.Layers[0].RecordCount = 0 Then Exit;
    Extent := GIS.MapInfo.Extension;
    DrawMode := dmNormal;
    BoundEnt := TEzRectangle.CreateEntity( Extent.Emin, Extent.Emax );
    With TEzRectangle( BoundEnt ) Do
    Begin
      Pentool.Style := 2;
      Pentool.Color := clred;
      Brushtool.Pattern := 0;
      Draw( Grapher,
            ScreenBitmap.Canvas,
            Grapher.CurrentParams.VisualWindow,
            DrawMode );
      Free;
    End;
    DistX := Grapher.DistToRealX( 3 );
    DistY := Grapher.DistToRealY( 3 );
    Xc := ( Extent.Emin.X + Extent.Emax.X ) / 2;
    Yc := ( Extent.Emin.Y + Extent.Emax.Y ) / 2;
    BoundRect := Rect2d( Xc - DistX, Yc + DistY,
                         Xc + DistX, Yc - DistY );
    BoundEnt := TEzEllipse.CreateEntity( BoundRect.Emin, BoundRect.Emax );
    With TEzEllipse(BoundEnt) Do
    Begin
      Pentool.Style := 1;
      Pentool.Color := clred;
      Brushtool.Pattern := 0;
      Draw( Grapher, ScreenBitmap.Canvas, Grapher.CurrentParams.VisualWindow, DrawMode );
      Free;
    End;
  End;

End;

Procedure TEzSymbolsBox.PopulateFrom( Symbol: TEzSymbol );
Var
  Layer: TEzBaseLayer;
  I: Integer;
Begin
  { delete all records }
  Layer := GIS.Layers[0];
  Layer.Zap;
  For I := 0 To Symbol.Count - 1 Do
    Layer.AddEntity( Symbol.Entities[I] );
  GIS.UpdateExtension;
End;

Procedure TEzSymbolsBox.PopulateTo( Symbol: TEzSymbol );
Var
  Layer: TEzBaseLayer;
  Entity: TEzEntity;
Begin
  { delete all records }
  Symbol.Clear;
  Layer := GIS.Layers[0];
  Layer.First;
  While Not Layer.Eof Do
  Begin
    If Not Layer.RecIsDeleted Then
    Begin
      Entity := Layer.RecLoadEntity;
      Symbol.Add( Entity );
    End;
    Layer.Next;
  End;
End;

{ TEzAerialView }

Constructor TEzAerialView.Create( AOwner: TComponent );
Begin
  Inherited Create( Aowner );
  ZoomWithMargins:= False;
  FInnerColor := clWhite;
  FOuterColor := clRed;
  FShowInverted := False;
  IsAerial := True;
  ScrollBars := ssNone;
End;

{$IFDEF BCB}
Function TEzAerialView.GetShowInverted: Boolean;
Begin
  Result:= FShowInverted;
End;

Procedure TEzAerialView.SetShowInverted( Value: Boolean );
Begin
  FShowInverted:= Value;
End;

Function TEzAerialView.GetInnerColor: TColor;
Begin
  Result:= FInnerColor;
End;

Procedure TEzAerialView.SetInnerColor( Value: TColor );
Begin
  FInnerColor:= Value;
End;

Function TEzAerialView.GetOuterColor: TColor;
Begin
  Result:= FOuterColor;
End;

Procedure TEzAerialView.SetOuterColor( Value: TColor );
Begin
  FOuterColor:=Value;
End;

Function TEzAerialView.GetParentView: TEzBaseDrawBox;
Begin
  Result:= FParentView;
End;
{$ENDIF}

Procedure TEzAerialView.BeginRepaint;
begin
  FSavedDrawLimit:= Ez_Preferences.MinDrawLimit;
  Ez_Preferences.MinDrawLimit:= Ez_Preferences.AerialMinDrawLimit;
  inherited;
end;

Procedure TEzAerialView.EndRepaint;
begin
  Ez_Preferences.MinDrawLimit:= FSavedDrawLimit;
  inherited;
end;

Procedure TEzAerialView.UpdateViewport( WCRect: TEzRect );
Var
  TheCanvas: TCanvas;
  VisualWindow: TEzRect;
Begin
  //If Not Showing then Exit;
  { check if WCRect is bigger than current view area }
  VisualWindow := Grapher.CurrentParams.VisualWindow;
  if (WCRect.X1 < VisualWindow.X1) or (WCRect.Y1 < VisualWindow.Y1) or
     (WCRect.X2 > VisualWindow.X2) or (WCRect.Y2 > VisualWindow.Y2) then
  begin
    WCRect:= IntersectRect2D(WCRect, VisualWindow);
    if EqualRect2D(WCRect, NULL_EXTENSION) then Exit;
  end;

  Inherited UpdateViewport( WCRect );

  TheCanvas := Canvas;
  If odBitmap In OutputDevices Then
    TheCanvas := ScreenBitmap.Canvas;

  With TEzPainterObject.Create(Nil) Do
    Try
      DrawEntities( WCRect,
                    GIS,
                    TheCanvas,
                    Grapher,
                    Selection,
                    True,
                    False,
                    pmAll,
                    Self.ScreenBitmap );
    Finally
      free;
    End;

End;

Procedure TEzAerialView.SetParentView( Const Value: TEzBaseDrawBox );
Begin
{$IFDEF LEVEL5}
  if Assigned( FParentView ) then FParentView.RemoveFreeNotification( Self );
{$ENDIF}
  if Value <> Nil then
  begin
    Value.FreeNotification( Self );
    GIS := Value.GIS;
    Color := value.Color;
    RubberPen.Color := clRed;
    ScrollBars := ssNone;
    Cursor := crCross;
    IsAerial := True;
  end;
  FParentView := value;
End;

procedure TEzAerialView.Notification(AComponent: TComponent;
  Operation: TOperation);
begin
  Inherited Notification( AComponent, Operation );
  If ( Operation = opRemove ) And ( AComponent = FParentView ) Then
    FParentView := Nil;
end;

{ TMemRTNode }

Procedure TMemRTNode.Read( NId: Longint );
Begin
  Data := PDiskPage( TMemRTree( rt ).FList[NId - 1] )^;
  oid := NId;
End;

// Update the object with the data pointed to by the Data field

Procedure TMemRTNode.Write;
Begin
  PDiskPage( TMemRTree( rt ).FList[oid - 1] )^ := Data;
End;

// Create a new object with initial data pointed to by the Data field

Procedure TMemRTNode.AddNodeToFile;
Var
  dp: PDiskPage;
  Index: Integer;
Begin
  New( dp );
  dp^ := Data;
  { elements marked as nil are previously deleted pages }
  If TMemRTree( rt ).FList.Count > 0 Then
    Index := TMemRTree( rt ).FList.IndexOf( Nil )
  Else
    Index := -1;
  If Index < 0 Then
  Begin
    TMemRTree( rt ).FList.Add( dp );
    oid := TMemRTree( rt ).FList.Count;
  End
  Else
  Begin
    TMemRTree( rt ).FList[Index] := dp;
    oid := Index + 1;
  End;
End;

// Delete this object

Procedure TMemRTNode.DeleteNodeFromFile;
Begin
  With TMemRTree( rt ) Do
  Begin
    Dispose( PDiskPage( FList[self.oid - 1] ) );
    { mark only as nil because other pages reference by position }
    FList[self.oid - 1] := Nil;
  End;
End;

{-------------------------------------------------------------------------------}
{                  TMemRTree - class implementation                             }
{-------------------------------------------------------------------------------}

Destructor TMemRTree.Destroy;
Begin
  Inherited Destroy;
  Clear;
  If Assigned( FList ) Then
    FList.Free;
End;

Function TMemRTree.CreateNewNode: TRTNode;
Begin
  result := TMemRTNode.Create( self );
End;

Procedure TMemRTree.Clear;
Var
  I: Integer;
Begin
  If FList = Nil Then
    Exit;

  For I := 0 To FList.Count - 1 Do
    If FList[I] <> Nil Then
      Dispose( PDiskPage( FList[I] ) );
  FList.Clear;
End;

Procedure TMemRTree.LoadFromStream( Stream: TStream );
Var
  I, n: Integer;
  DiskPage: PDiskPage;
Begin
  { WARNING: this code is wrong because when a page is deleted, its position
    on the FList is marked with a nil pointer FList[NodeDeleted] := nil;
   Althoug, this code is not yet used. }
  Clear;
  With Stream Do
  Begin
    Read( Catalog, sizeof( Catalog ) );
    Read( n, sizeof( n ) );
    For I := 1 To n Do
    Begin
      New( DiskPage );
      Read( DiskPage^, sizeof( TDiskPage ) );
      FList.Add( DiskPage );
    End;
  End;
End;

Procedure TMemRTree.SaveToStream( Stream: TStream );
Var
  I, n: Integer;
  DiskPage: PDiskPage;
Begin
  { WARNING: this code is wrong because when a page is deleted, its position
    on the FList is marked with a nil pointer FList[NodeDeleted] := nil;
   Althoug, this code is not yet used. }
  With Stream Do
  Begin
    Write( Catalog, sizeof( Catalog ) );
    n := FList.Count;
    Write( n, sizeof( n ) );
    For I := 0 To n - 1 Do
    Begin
      DiskPage := FList[I];
      Write( DiskPage^, sizeof( TDiskPage ) );
    End;
  End;
End;

Function TMemRTree.Open( Const Name: String; Mode: Word ): integer;
Begin
  IdxOpened := True;
  result := OK;
End;

Procedure TMemRTree.Close;
Begin
  If Not IdxOpened Then
    Exit;
  Clear;
  IdxOpened := False;
End;

Procedure TMemRTree.FlushFiles;
Begin
  // nothing to do here
End;

Procedure TMemRTree.ReadCatalog( Var IdxInfo: TRTCatalog );
Begin
  IdxInfo := Self.Catalog;
End;

Procedure TMemRTree.WriteCatalog( Const IdxInfo: TRTCatalog );
Begin
  Self.Catalog := IdxInfo;
End;

// Destroy an R-Tree index file.

Procedure TMemRTree.DropIndex;
Begin
  Close;
  // nothing to do here
End;

// Create an R-Tree with the given name

Function TMemRTree.CreateIndex( Const Name: String; Multiplier: Integer ): integer;
Var
  dp: PDiskPage;
Begin

  If IdxOpened Then
    Close;

  If FList = Nil Then
    FList := TList.Create
  Else
    Clear;

  With TMemRTNode( RootNode ) Do
  Begin
    FillChar( Data, sizeof( TDiskPage ), 0 );
    Data.FullEntries := 0;
    Data.Parent := -1;
    Data.Leaf := True;
  End;

  // Fill in the index entry
  Self.Depth := 0;
  RootId := 1;

  TMemRTNode( RootNode ).oid := 1;

  New( dp );
  dp^ := TMemRTNode( RootNode ).Data;
  FList.Add( dp );

  // update the catalog
  Catalog.rootnode := 1;
  Catalog.depth := 0;
  Catalog.multiplier := Multiplier;
  Catalog.BucketSize := BUCKETSIZE;
  Catalog.LowerBound := LOWERBOUND;

  IdxOpened := True;
  FName := Name;
  result := OK;
End;

Function TMemRTree.Get( Index: Integer ): PDiskPage;
Begin
  result := FList[Index];
End;

Function TMemRTree.PageCount: Integer;
Begin
  result := FList.Count;
End;


{-------------------------------------------------------------------------------}
{                  TEzMapInfo - class implementation                       }
{-------------------------------------------------------------------------------}

Procedure TEzMapInfo.Initialize;
Begin
  FillChar( FMapHeader, SizeOf( TEzMapHeader ), 0 );
  With FMapHeader Do
  Begin
    HeaderID := MAP_ID;
    VersionNumber := MAP_VERSION_NUMBER;
    Extension := Rect2D( 0, 0, 100, 100 );
    LastView := Rect2D( 0, 0, 100, 100 ); //INVALID_EXTENSION;
    CoordsUnits := cuM;
  End;
End;

{$IFDEF BCB}
Function TEzMapInfo.GetMapHeader;
Begin
  Result:= FMapHeader;
End;

procedure TEzMapInfo.SetMapHeader(const Value: TEzMapHeader);
begin
  FMapheader := Value;
end;
{$ENDIF}

Function TEzMapInfo.GetNumLayers: Integer;
Begin
  result := FMapHeader.NumLayers;
End;

Procedure TEzMapInfo.SetNumLayers( Value: Integer );
Begin
  FMapHeader.NumLayers := Value;
  SetGISModifiedStatus( FGIS );
End;

Function TEzMapInfo.GetExtension: TEzRect;
Begin
  result := FMapHeader.Extension;
End;

Procedure TEzMapInfo.SetExtension( Const Value: TEzRect );
Begin
  FMapHeader.Extension := Value;
  SetGISModifiedStatus( FGIS );
End;

Function TEzMapInfo.GetCurrentLayer: String;
Begin
  result := FMapHeader.CurrentLayer;
End;

Procedure TEzMapInfo.SetCurrentLayer( Const Value: String );
Begin
  If AnsiCompareText( Self.GetCurrentLayer, Value ) = 0 Then  Exit;
  FMapHeader.CurrentLayer := Value;
  SetGISModifiedStatus( FGIS );
  Inherited SetCurrentLayer( Value );
End;

Function TEzMapInfo.GetAerialViewLayer: String;
Begin
  result := FMapHeader.AerialViewLayer;
End;

Procedure TEzMapInfo.SetAerialViewLayer( Const Value: String );
Begin
  FMapHeader.AerialViewLayer := Value;
  SetGISModifiedStatus( FGIS );
End;

Function TEzMapInfo.GetLastView: TEzRect;
Begin
  result := FMapHeader.LastView;
End;

Procedure TEzMapInfo.SetLastView( Const Value: TEzRect );
Begin
  FMapHeader.LastView := Value;
  SetGISModifiedStatus( FGIS );
End;

Function TEzMapInfo.GetCoordSystem: TEzCoordSystem;
Begin
  result := FMapHeader.CoordSystem;
End;

Procedure TEzMapInfo.SetCoordSystem( Value: TEzCoordSystem );
Begin
  FMapHeader.CoordSystem := Value;
  If Value = csLatLon Then
    FMapHeader.CoordsUnits := cuDeg;
  SetGISModifiedStatus( FGIS );
End;

Function TEzMapInfo.GetCoordsUnits: TEzCoordsUnits;
Begin
  result := FMapHeader.CoordsUnits;
End;

Procedure TEzMapInfo.SetCoordsUnits( Value: TEzCoordsUnits );
Begin
  If FMapHeader.CoordSystem = csLatLon Then
    FMapHeader.CoordsUnits := cuDeg
  Else
    FMapHeader.CoordsUnits := Value;

  SetGISModifiedStatus( FGIS );
End;

Function TEzMapInfo.GetIsAreaClipped: boolean;
Begin
  result := FMapHeader.IsAreaClipped;
End;

Procedure TEzMapInfo.SetIsAreaClipped( Value: Boolean );
Begin
  FMapHeader.IsAreaClipped := Value;
  SetGISModifiedStatus( FGIS );
End;

Function TEzMapInfo.GetAreaClipped: TEzRect;
Begin
  result := FMapHeader.AreaClipped;
End;

Procedure TEzMapInfo.SetAreaClipped( Const Value: TEzRect );
Begin
  FMapHeader.AreaClipped := Value;
  SetGISModifiedStatus( FGIS );
End;

Function TEzMapInfo.GetClipAreaKind: TEzClipAreaKind;
Begin
  result := FMapHeader.ClipAreaKind;
End;

Procedure TEzMapInfo.SetClipAreaKind( Value: TEzClipAreaKind );
Begin
  FMapHeader.ClipAreaKind := Value;
  SetGISModifiedStatus( FGIS );
End;


{-------------------------------------------------------------------------------}
{                  TEzRTNode - class implementation                            }
{-------------------------------------------------------------------------------}
// Get the data of the node into memory

Procedure TEzRTNode.Read( NId: Longint );
Begin
  TEzRTree( rt ).IdxRtx.Seek( NId, 0 );
  TEzRTree( rt ).IdxRtx.Read( Data, SizeOf( TDiskPage ) );

  Self.oid := NId;
End;

// Update the object with the data pointed to by the Data field

Procedure TEzRTNode.Write;
Begin
  TEzRTree( rt ).IdxRtx.Seek( oid, 0 );
  TEzRTree( rt ).IdxRtx.Write( Data, sizeof( TDiskPage ) );
End;

// Create a new object with initial data pointed to by the Data field

Procedure TEzRTNode.AddNodeToFile;
Var
  IdxInfo: TRTCatalog;
Begin
  { check if there are available disk pages }
  rt.ReadCatalog( IdxInfo );
  If IdxInfo.FreePageCount > 0 Then
  Begin
    TEzRTree( rt ).IdxRtc.Seek( sizeof( IdxInfo ) + ( IdxInfo.FreePageCount - 1 ) *
      sizeof( Longint ), 0 );
    TEzRTree( rt ).IdxRtc.Read( oid, sizeof( Longint ) );
    { update the free pages }
    Dec( IdxInfo.FreePageCount );
  End
  Else
  Begin
    Inc( IdxInfo.PageCount );
    oid := ( IdxInfo.PageCount - 1 ) * SizeOf( TDiskPage );
  End;
  TEzRTree( rt ).IdxRtx.Seek( oid, 0 );
  TEzRTree( rt ).IdxRtx.Write( Data, sizeof( TDiskPage ) );
  // update the page counter
  rt.WriteCatalog( IdxInfo );
  //Read(oid);
End;

// Delete this object

Procedure TEzRTNode.DeleteNodeFromFile;
Var
  IdxInfo: TRTCatalog;
Begin
  { add to the list of available pages }
  rt.ReadCatalog( IdxInfo );
  Inc( IdxInfo.FreePageCount );
  { write new data }
  rt.WriteCatalog( IdxInfo );

  { write the offset address of the available page }
  TEzRTree( rt ).IdxRtc.Seek( sizeof( IdxInfo ) + ( IdxInfo.FreePageCount - 1 ) * sizeof( Longint ), 0 );
  TEzRTree( rt ).IdxRtc.Write( oid, sizeof( Longint ) );
End;

{-------------------------------------------------------------------------------}
{                  TEzRTree - class implementation                             }
{-------------------------------------------------------------------------------}

Function TEzRTree.CreateNewNode: TRTNode;
Begin
  result := TEzRTNode.Create( self );
End;

Function TEzRTree.Open( Const Name: String; Mode: Word ): integer;
Var
  IdxInfo: TRTCatalog;
Begin

  If IdxOpened Then
    Close;

  OpenMode := Mode;
  // open the r-tree catalog
  IdxRtc := TFileStream.Create( ChangeFileExt( Name, RTCEXT ), Mode );

  IdxRtc.Read( IdxInfo, sizeof( IdxInfo ) );

  // open the r-tree index
  RootId := IdxInfo.RootNode;
  IdxRtx := TFileStream.Create( ChangeFileExt( Name, RTXEXT ), Mode );
  Depth := IdxInfo.Depth;

  RootNode.Read( RootId );

  fName := Name;

  IdxOpened := true;
  result := OK;
End;

Procedure TEzRTree.Close;
Begin
  If Not IdxOpened Then
    Exit; // Nothing to close
  IdxRtc.free;
  IdxRtc := Nil;
  IdxRtx.free;
  IdxRtx := Nil;
  IdxOpened := false;
End;

Procedure TEzRTree.FlushFiles;
Begin
  If ( IdxRtx <> Nil ) And ( IdxRtx Is TFileStream ) Then
    Windows.FlushFileBuffers( TFileStream( IdxRtx ).Handle );
  If ( IdxRtc <> Nil ) And ( IdxRtc Is TFileStream ) Then
    Windows.FlushFileBuffers( TFileStream( IdxRtc ).Handle );
End;

Procedure TEzRTree.ReadCatalog( Var IdxInfo: TRTCatalog );
Begin
  IdxRtc.Seek( 0, 0 );
  IdxRtc.Read( IdxInfo, SizeOf( IdxInfo ) );
End;

Procedure TEzRTree.WriteCatalog( Const IdxInfo: TRTCatalog );
Begin
  IdxRtc.Seek( 0, 0 );
  IdxRtc.Write( IdxInfo, SizeOf( IdxInfo ) );
End;

// Destroy an R-Tree index file.

Procedure TEzRTree.DropIndex;
Begin

  //if not IdxOpened then Exit;       // Nothing to destroy!

  Close;

  SysUtils.DeleteFile( fName + RTCEXT );
  SysUtils.DeleteFile( fName + RTXEXT );

End;

// Create an R-Tree with the given name

Function TEzRTree.CreateIndex( Const Name: String; Multiplier: Integer ): integer;
Var
  IdxInfo: TRTCatalog;
Begin

  If IdxOpened Then
    Close;

  // Create the catalog
  IdxRtc := TFileStream.Create( Name + RTCEXT, fmCreate );
  FillChar( IdxInfo, sizeof( IdxInfo ), 0 );
  //IdxRtc.Write(IdxInfo,sizeof(IdxInfo));

// Create the file
  IdxRtx := TFileStream.Create( Name + RTXEXT, fmCreate );

  With TEzRTNode( RootNode ) Do
  Begin
    FillChar( Data, sizeof( TDiskPage ), 0 );
    Data.FullEntries := 0;
    Data.Parent := -1;
    Data.Leaf := True;
  End;

  // Fill in the index entry
  Depth := 0;
  IdxInfo.Depth := 0;
  TEzRTNode( RootNode ).oid := 0;
  RootId := TEzRTNode( RootNode ).oid;

  IdxInfo.RootNode := RootId;
  IdxInfo.PageCount := 0;
  IdxInfo.Implementor := 1; // 1=luis, 2=Garry
  IdxInfo.TreeType := TreeType;
  IdxInfo.PageSize := 1;
  IdxInfo.Version := TREE_VERSION;
  IdxInfo.Multiplier := Multiplier;
  IdxInfo.BucketSize := BUCKETSIZE;
  IdxInfo.LowerBound := LOWERBOUND;
  IdxInfo.LastUpdate := Now;

  // Add the entry to the catalog
  IdxRtc.Seek( 0, 0 );
  IdxRtc.Write( IdxInfo, sizeof( IdxInfo ) );

  // Create the root node
  RootNode.AddNodeToFile;

  IdxRtc.Free;
  IdxRtc := TFileStream.Create( Name + RTCEXT, OpenMode );
  IdxRtx.Free;
  IdxRtx := TFileStream.Create( Name + RTXEXT, OpenMode );

  IdxOpened := true;
  fName := Name;

  result := OK;

End;



//******************* TEzScaleBar **********************************

{ TEzScaleBar }

constructor TEzScaleBar.Create(AOwner: TComponent);
begin
  inherited Create( AOwner ) ;
  ControlStyle := ControlStyle - [csSetCaption, csOpaque, csFramed] ;
  TabStop:= False;
  FFont:= EzSystem.DefaultFont;
  FFont.Size:= 6;
  Width:= 217;
  Height:= 33;
  FNumDecimals:= 0;
  FResizePosition:= rpLowerRight;
  Cursor:= crHandPoint;

  FTransparent:= False;
  FColor:= clWindow;
  FLinesPen:= TPen.Create;
  FLinesPen.Color:= clRed;
  FMinorBrush:= TBrush.Create;
  FMinorBrush.Color:= TColor($F0CAA6); // clSkyBlue
  FMajorBrush:= TBrush.Create;
  FMajorBrush.Color:= clNavy;
  FAppearance:= apBlock;
  FIntervalLengthUnits:= suCms;
  FIntervalLength:= 1.0; // 1 cm every separation
  FIntervalNumber:= 2;
  FBarHeight:= 8;  // pixels
  FUnits:= cuM;

end;

destructor TEzScaleBar.Destroy;
begin
  FFont.Free;
  FLinesPen.Free;
  FMinorBrush.Free;
  FMajorBrush.Free;
  inherited Destroy;
end;

procedure TEzScaleBar.MouseDown(Button: TMouseButton; Shift: TShiftState;
  X, Y: Integer);
const
  SC_DRAGMOVE : Longint = $F012 ;
begin
  { Might also want to check for Client alignment too. }
  if (Align = alNone) then
  begin
    FMoving := True ;
    ReleaseCapture ;
    SendMessage(Handle, WM_SYSCOMMAND, SC_DRAGMOVE, 0) ;
  end else
    inherited MouseDown(Button, Shift, X, Y) ;
end;

procedure TEzScaleBar.WMMove(var Message: TWMMove);
begin
  inherited ;
  if FMoving then
  begin
    FMoving := False ;
    Parent.Realign ;
    if Assigned(FOnMove) then
      FOnMove(Self) ;
    Invalidate
  end else if FTransparent then
    Invalidate;
end;

{ following two methods not yet working }
Procedure TEzScaleBar.SaveToInifile( const FileName: string );
var
  Inifile: TInifile;
  MyName: string;

  Procedure SaveBrush( Brush: TBrush; const Ident: string );
  begin
    Inifile.WriteInteger( MyName, Ident+'_Color', Brush.Color );
    Inifile.WriteInteger( MyName, Ident+'_Style', ord(Brush.Style) );
  end;

Begin
  Inifile:= TInifile.Create(Filename);
  try
    MyName:= Self.Name;
    If Length(MyName)=0 then MyName:=Classname;
    Inifile.WriteInteger( MyName, 'Color', Color );
    Inifile.WriteInteger( MyName, 'Appearance', Ord(Appearance) );
    Inifile.WriteInteger( MyName, 'LinesPen_Color', LinesPen.Color );
    Inifile.WriteInteger( MyName, 'LinesPen_Style', Ord(LinesPen.Style) );
    Inifile.WriteInteger( MyName, 'LinesPen_Width', LinesPen.Width );
    SaveBrush( MinorBrush, 'MinorBrush' );
    SaveBrush( MajorBrush, 'MajorBrush' );
    Inifile.WriteInteger( MyName, 'IntervalLengthUnits', ord(IntervalLengthUnits) );
    WriteFloatToIni( Inifile, MyName, 'IntervalLength', IntervalLength );
    Inifile.WriteInteger( MyName, 'BarHeight', BarHeight );
    Inifile.WriteInteger( MyName, 'IntervalNumber', IntervalNumber );
    Inifile.WriteInteger( MyName, 'NumDecimals', NumDecimals );
    Inifile.WriteInteger( MyName, 'Units', ord(Units) );
    Inifile.WriteBool( MyName, 'ShowTrailingZeros', ShowTrailingZeros );
    Inifile.WriteBool( MyName, 'Transparent', Transparent );
    Inifile.WriteBool( MyName, 'Visible', Visible );
    Inifile.WriteInteger( MyName, 'Left', Left );
    Inifile.WriteInteger( MyName, 'Top', Top );
    { save the font }
    EzSystem.SaveFont(Inifile, MyName, Self.Font );

  finally
    Inifile.free;
  end;
End;

Procedure TEzScaleBar.LoadFromInifile( const Filename: string );
var
  Inifile: TInifile;
  MyName: string;

  Procedure LoadBrush( Brush: TBrush; const Ident: string; Default: TColor );
  begin
    Brush.Color:= Inifile.ReadInteger( MyName, Ident+'_Color', Default );
    Brush.Style:= TBrushStyle(Inifile.ReadInteger( MyName, Ident+'_Style', ord(bsSolid) ));
  end;

Begin
  Inifile:= TInifile.create(Filename);
  try
    MyName:= Self.Name;
    If Length(MyName)=0 then MyName:=Classname;
    Color:= Inifile.ReadInteger( MyName, 'Color', clWindow );
    Appearance:= TEzBarAppearance(Inifile.ReadInteger( MyName, 'Appearance', Ord(apBlock) ));
    LinesPen.Color:=Inifile.ReadInteger( MyName, 'LinesPen_Color', clRed );
    LinesPen.Style:= TPenStyle(Inifile.ReadInteger( MyName, 'LinesPen_Style', Ord(psSolid) ));
    LinesPen.Width:= Inifile.ReadInteger( MyName, 'LinesPen_Width', 1 );
    LoadBrush( MinorBrush, 'MinorBrush',TColor($F0CAA6) );
    LoadBrush( MajorBrush, 'MajorBrush',clNavy );
    IntervalLengthUnits:= TEzScaleUnits(Inifile.ReadInteger( MyName, 'IntervalLengthUnits', ord(suCms) ));
    IntervalLength:= ReadFloatFromIni( Inifile, MyName, 'IntervalLength', 1.0 );
    BarHeight:= Inifile.ReadInteger( MyName, 'BarHeight', 8 );
    IntervalNumber:= Inifile.ReadInteger( MyName, 'IntervalNumber', 2 );
    NumDecimals:= Inifile.ReadInteger( MyName, 'NumDecimals', 0 );
    Units:= TEzCoordsUnits(Inifile.ReadInteger( MyName, 'Units', ord(cuM) ));
    ShowTrailingZeros:=Inifile.ReadBool( MyName, 'ShowTrailingZeros', false );
    Transparent:=Inifile.ReadBool( MyName, 'Transparent', True );
    Visible:=Inifile.ReadBool( MyName, 'Visible', true );
    Left:=Inifile.ReadInteger( MyName, 'Left', 0 );
    Top:=Inifile.ReadInteger( MyName, 'Top', 0 );
    Self.Font.Handle:= EzSystem.DefaultFontHandle;
    EzSystem.LoadFont(Inifile, MyName, Self.Font );
  finally
    Inifile.free;
  end;
End;

procedure TEzScaleBar.NeededDimensions( ACanvas: TCanvas; Const UnitsFactor: Double;
  var NeededWidth, NeededHeight: Integer;
  var RealDist: Double; var ScaleDistPixels, ATextHeight: Integer );
var
  I, TextWdth: Integer;
  ScaleDist, TotalDist: Double;
  UnitsStr: string;
  temp: Double;
Begin

  NeededWidth:= 0;
  NeededHeight:= 0;

  ACanvas.Font.Assign( Self.Font );
  TextWdth:= ACanvas.TextWidth( Format( '%.*f', [FNumDecimals, 0.0] ) );

  NeededWidth := (TextWdth div 2) + 1;
  { sumale el numero de intervalos }
  //If csDesigning in ComponentState Then
  ScaleDist := GetDeviceCaps( ACanvas.Handle, LOGPIXELSX );
  //Else
  //  ScaleDist := TEzBaseDrawbox(Parent).Grapher.ScreenDpiX;
  If FIntervalLengthUnits=suMms then
    ScaleDist := ScaleDist / 25.4
  Else If FIntervalLengthUnits=suCms then
    ScaleDist := ScaleDist / 2.54;

  ScaleDistPixels := Round( ScaleDist * FIntervalLength );

  Inc( NeededWidth, ScaleDistPixels * FIntervalNumber );
  { calculate the text length of last interval }

  If csDesigning in ComponentState Then
    RealDist:= 10
  Else
    RealDist:= TEzBaseDrawbox(Parent).Grapher.DistToRealY( ScaleDistPixels );
  TotalDist:=  RealDist * FIntervalNumber;
  temp := TotalDist * UnitsFactor;
  If Not FShowTrailingZeros And (temp = Int( temp )) Then
    TextWdth:= ACanvas.TextWidth( FloatToStr( temp ) )
  Else
    TextWdth:= ACanvas.TextWidth( Format( '%.*f', [FNumDecimals, temp] ) );
  Inc( NeededWidth, TextWdth div 2 );

  If (TEzDrawBox(Parent).GIS<>Nil) And (TEzDrawBox(Parent).GIS.MapInfo.IsValid) And
     (TEzDrawBox(Parent).GIS.MapInfo.CoordsUnits = cuDeg) then
    UnitsStr:= pj_units[cuDeg].id
  else
    UnitsStr:= pj_units[FUnits].id;
  Inc( NeededWidth, ACanvas.TextWidth( #32+UnitsStr ) + 1 );

  { now calculate the needed height }
  ATextHeight:= ezlib.IMax( ACanvas.TextHeight('0'), ACanvas.TextHeight( UnitsStr ) ) ;
  TotalDist:= 0;
  for I:= 1 to FIntervalNumber do
  begin
    TotalDist:= TotalDist + RealDist;
    //Dist:= TotalDist * ( 1 / pj_units[Self.FUnits].to_meter )
    ATextHeight:= EzLib.IMax(ACanvas.TextHeight( FloatToStr( TotalDist*UnitsFactor ) ), ATextHeight);
  end;

  NeededHeight:= ATextHeight + 1 + FLinesPen.Width + FBarHeight + FLinesPen.Width + 2 ;

End;

procedure TEzScaleBar.Reposition;
Begin
  case ResizePosition of
    rpUpperLeft:
      Begin
        Left:= 2;
        Top:= 2;
      End;
    rpUpperRight:
      Begin
        Left:= Parent.ClientWidth - Width - 2;
        Top:= 2;
      End;
    rpLowerLeft:
      Begin
        Left:= 2;
        Top:= Parent.ClientHeight - height - 2;
      End;
    rpLowerRight:
      Begin
        Left:= Parent.ClientWidth - Width - 2;
        Top:= Parent.ClientHeight - height - 2;
      End;
  Else Begin End;
  end;
End;

procedure TEzScaleBar.PaintTo( ACanvas: TCanvas; Const ARect: TRect;
  const UnitsFactor: Double; AWidth, AHeight: Integer; const RealDist: Double;
  ScaleDistPixels, TotalTextHeight: Integer );
var
  TextStr, UnitsID: String;
  TmpR: TRect;
  TmpDist, TotalDist: Double;
  I: Integer;
  Alternate: Boolean;
  HalfR: TRect;
  HalfHeight: Integer;
begin
  { now to paint the scale }
  // TEzBaseDrawBox( Parent )
  With ACanvas Do
  Begin

    Brush.Style:= bsSolid;

    Brush.Color:= Self.FColor;

    If Not(csDesigning in ComponentState) And Self.FTransparent then
    begin
      { Is this really a transparency :-) I am copying the buffer bitmap of the
        cursor only }
      TmpR:= ARect;
      TmpR.TopLeft:= Parent.ScreenToClient( Self.ClientToScreen( TmpR.TopLeft ) );
      TmpR.BottomRight:= Parent.ScreenToClient( Self.ClientToScreen( TmpR.BottomRight ) );
      Self.Canvas.CopyRect(Self.ClientRect, TEzDrawBox( Parent ).ScreenBitmap.Canvas, TmpR );
    end else
      FillRect( ARect );

    Pen.Assign( Self.FLinesPen );

    Alternate:= True;

    TotalDist:= 0;

    If Not FShowTrailingZeros And ( TotalDist = Int( TotalDist ) ) Then
      AWidth:= TextWidth( FloatToStr( TotalDist ) )
    Else
      AWidth:= TextWidth( Format( '%.*f', [FNumDecimals, TotalDist] ) );
    TmpR.Left:= 1 + (AWidth div 2);
    TmpR.Top:= TotalTextHeight + 1;
    TmpR.Right:= TmpR.Left + ScaleDistPixels;
    TmpR.Bottom:= TmpR.Top + FLinesPen.Width * 2 + FBarHeight;

    for I:= 1 to FIntervalNumber do
    begin
      If FAppearance=apBlockAlternate then
      begin
        HalfR:= TmpR;
        HalfHeight:= (TmpR.Bottom - TmpR.Top) div 2;
        Halfr.Bottom:= HalfR.Top + HalfHeight;
        If Alternate then
          Brush.Assign( FMajorBrush )
        else
          Brush.Assign( FMinorBrush );
        with HalfR do Rectangle( Left, Top, Right, Bottom );

        HalfR.Top:= HalfR.Bottom-1;
        Halfr.Bottom:= HalfR.Top + HalfHeight;
        If Alternate Then
          Brush.Assign( FMinorBrush )
        else
          Brush.Assign( FMajorBrush );
        with halfR do Rectangle( Left, Top, Right, Bottom );
      End Else If FAppearance=apBlock then
      begin
        If Alternate then
          Brush.Assign( FMajorBrush )
        else
          Brush.Assign( FMinorBrush );
        with TmpR do Rectangle( Left, Top, Right, Bottom )
      end else
        with TmpR do
        begin
          MoveTo(Left, Top);
          LineTo(Left, Bottom);
          LineTo(Right, Bottom);
          LineTo(Right, Top);
        end;

      TmpDist:= TotalDist*UnitsFactor;
      if not FShowTrailingZeros and (TmpDist = Int(TmpDist)) Then
        TextStr := FloatToStr( TmpDist )
      Else
        TextStr := Format( '%.*f', [FNumDecimals, TmpDist] );
      AWidth:= TextWidth( TextStr );

      Windows.SetBkMode( Handle, Windows.TRANSPARENT );
      TextOut( TmpR.Left - (AWidth div 2), 0, TextStr );

      OffsetRect( TmpR, ScaleDistPixels-1, 0 );

      TotalDist:= TotalDist + RealDist ;

      Alternate := Not Alternate;
    end;
    { TotalDist is in real map units. Now we need to change to units of Scale Bar }
    TmpDist:= TotalDist * UnitsFactor ;
    If Not FShowTrailingZeros And (TmpDist = Int(TmpDist) ) Then
      TextStr := FloatToStr( TmpDist )
    Else
      TextStr := Format( '%.*f', [FNumDecimals, TmpDist] );
    AWidth:= TextWidth( TextStr );
    Windows.SetBkMode( Handle, Windows.TRANSPARENT );
    If TEzDrawBox(Parent).GIS.MapInfo.IsValid And (TEzDrawBox(Parent).GIS.MapInfo.CoordsUnits = cuDeg) then
      UnitsID:= String( EzBase.pj_units[cuDeg].ID )
    else
      UnitsID:= String( EzBase.pj_units[Self.FUnits ].ID );
    TextOut( TmpR.Left - (AWidth div 2), 1, TextStr + #32 + UnitsID );

  End;
end;

procedure TEzScaleBar.Paint;
var
  RealDist, UnitsFactor: Double;
  AWidth, AHeight: Integer;
  ScaleDistPixels, TotalTextHeight: Integer;
begin
  inherited Paint ;

  If FPaintSuspended Or Not Assigned(Parent) Or Not(Parent is TEzDrawBox) Or
    Not Assigned(TEzDrawbox(Parent).GIS) Then Exit;

  If csDesigning in ComponentState then
    UnitsFactor:= 1.0
  Else
  Begin
    If TEzDrawBox(Parent).GIS.MapInfo.IsValid Then
    Begin
      If TEzDrawBox(Parent).GIS.MapInfo.CoordsUnits = cuDeg then
        UnitsFactor:= 1.0
      Else
        UnitsFactor:= pj_units[TEzBaseDrawbox(Parent).GIS.MapInfo.CoordsUnits].to_meter * ( 1 / pj_units[Self.FUnits].to_meter );
    End Else
      UnitsFactor:= 1.0;
  End;

  NeededDimensions( Self.Canvas, UnitsFactor, AWidth, AHeight, RealDist, ScaleDistPixels, TotalTextHeight );

  If ( AWidth <= 0 ) Or ( AHeight <= 0 ) then Exit;

  If ( Self.ClientWidth <> AWidth ) Or (Self.ClientHeight <> AHeight ) Then
  Begin
    FPaintSuspended:= True;
    try
      Self.ClientWidth:= ezlib.IMin( Parent.Width, AWidth );
      Self.ClientHeight:= ezlib.IMin( Parent.Height, AHeight );
    finally
      FPaintSuspended:= False;
    end;
  End;

  PaintTo( Self.Canvas, Self.ClientRect, UnitsFactor, AWidth, AHeight, RealDist,
           ScaleDistPixels, TotalTextHeight );

end;

procedure TEzScaleBar.SetAppearance(const Value: TEzBarAppearance);
begin
  if FAppearance = Value Then Exit;
  FAppearance := Value;
  Invalidate;
end;

procedure TEzScaleBar.SetBarHeight(const Value: Integer);
begin
  If FBarHeight = Value Then Exit;
  FBarHeight := Value;
  Invalidate;
end;

procedure TEzScaleBar.SetColor(const Value: TColor);
begin
  If FColor = Value Then Exit;
  FColor := Value;
  Invalidate;
end;

procedure TEzScaleBar.SetFont(const Value: TFont);
begin
  FFont.Assign( Value );
  Invalidate;
end;

procedure TEzScaleBar.SetIntervalLength(const Value: Double);
begin
  If FIntervalLength = Value Then Exit;
  FIntervalLength := Value;
  Invalidate;
end;

procedure TEzScaleBar.SetIntervalLengthUnits(const Value: TEzScaleUnits);
begin
  If FIntervalLengthUnits = Value Then Exit;
  FIntervalLengthUnits := Value;
  Invalidate;
end;

procedure TEzScaleBar.SetIntervalNumber(const Value: Integer);
begin
  If FIntervalNumber = Value Then Exit;
  FIntervalNumber := Value;
  Invalidate;
end;

procedure TEzScaleBar.SetNumDecimals(const Value: Integer);
begin
  If FNumDecimals = Value Then Exit;
  FNumDecimals := Value;
  Invalidate;
end;

procedure TEzScaleBar.SetLinesPen(const Value: TPen);
begin
  FLinesPen.Assign( Value );
  Invalidate;
end;

procedure TEzScaleBar.SetUnits(const Value: TEzCoordsUnits);
begin
  If FUnits = Value Then Exit;
  FUnits := Value;
  Invalidate;
end;

procedure TEzScaleBar.SetMajorBrush(const Value: TBrush);
begin
  FMajorBrush.Assign( Value );
  Invalidate;
end;

procedure TEzScaleBar.SetMinorBrush(const Value: TBrush);
begin
  FMinorBrush.Assign( Value );
  Invalidate;
end;

procedure TEzScaleBar.SetShowTrailingZeros(const Value: Boolean);
begin
  If FShowTrailingZeros = Value Then Exit;
  FShowTrailingZeros := Value;
  Invalidate;
end;

procedure TEzScaleBar.SetTransparent(const Value: Boolean);
begin
  If FTransparent = Value Then Exit;
  FTransparent := Value;
  RecreateWnd;
end;

function TEzMemoryLayer.GetFiltered: Boolean;
begin
  Result := FFiltered;
end;

function TSHPLayer.GetFiltered: Boolean;
begin
  Result := FFiltered;
end;

End.
