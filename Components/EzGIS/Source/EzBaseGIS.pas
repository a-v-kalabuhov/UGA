Unit EzBaseGIS;

{***********************************************************}
{     EzGIS/CAD Components                                  }
{   (c) 2002 EzSoft Engineering                             }
{         All Rights Reserved                               }
{***********************************************************}

{$I EZ_FLAG.PAS}
{$R ..\RES\EzGISRES.dcr}
Interface

Uses
  Windows, SysUtils, Classes, Graphics, Controls, StdCtrls, Forms,
  Messages, EzRtree, EzLib, EzBase, EzBaseExpr, Dialogs ;

Const
  RTYPE = ttRTree;

Type

  { forwards }
  TEzBaseLayer = Class;
  TEzBaseLayers = Class;
  TEzBaseGIS = Class;
  TEzBaseDrawBox = Class;
  TEzDrawBoxList = Class;
  TEzSelection = Class;
  TEzPainterThread = Class;
  TEzPainterObject = Class;
  TEzBaseTable = Class;
  TEzEntityList = Class;

  EGISException = class(Exception);

  {-------------------------------------------------------------------------------}
  {                  TEzEntity main class                                       }
  {-------------------------------------------------------------------------------}

  TEzControlPointType = ( cptNode, cptMove, cptRotate );

  TEzControlPointTypes = Set Of TEzControlPointType;

  { TEzEntity }
  TEzEntity = Class( TObject )
  Private
    FTransformMatrix: PEzMatrix;

    { temporary used }
    FBitmap: TBitmap;
    FWasSuspended: Boolean;

    { here follows the info only used by some entities }
    FPainterObject: TEzPainterObject;
    { this is assigned from the screen bitmap or nil if printing }
    FBufferBitmap: TBitmap;
    { if <> [] then the set marks what control points to show }
    FControlPointsToShow: TEzControlPointTypes;
  Protected
    FPoints: TEzVector;
    FSelectedVertex: Integer;

    Function GetEntityID: TEzEntityID; Virtual; Abstract;
    Function GetDrawPoints: TEzVector; Virtual;

    Function BasicInfoAsString: string; Dynamic;
    Function AttribsAsString: string; Dynamic;

  Public
    ID: Integer; {  the unique ID for this entity }
    ExtID: Integer; 
    FBox: TEzRect;
    FOriginalSize: Integer;
    FSkipPainting: Boolean;
    Constructor Create( NPts: Integer; CanGrow: Boolean = True ); Virtual;
    Destructor Destroy; Override;
    Procedure Initialize; Virtual;
    Function Clone: TEzEntity;

    Function StorageSize: Integer; Virtual;

    Procedure LoadFromStream( Stream: TStream ); Virtual;
    Procedure SaveToStream( Stream: TStream ); Virtual;

    Function Area: Double; Dynamic;
    Function Perimeter: Double; Dynamic;

    Procedure Centroid( Var CX, CY: Double ); Dynamic;

    Procedure Assign( Source: TEzEntity );
    Procedure DrawControlPoints( Grapher: TEzGrapher; Canvas: TCanvas;
      Const VisualWindow: TEzRect; TransfPts: Boolean;
      DefaultPaint: Boolean = True; HideVertexNumber: Boolean = False );

    Procedure UpdateExtension; Virtual;
    Procedure Draw( Grapher: TEzGrapher; Canvas: TCanvas; Const Clip: TEzRect;
      DrawMode: TEzDrawMode; Data: Pointer = Nil ); Virtual; Abstract;

    Procedure ShowDirection( Grapher: TEzGrapher; Canvas: TCanvas; Const Clip: TEzRect;
      DrawMode: TEzDrawMode; DirectionPos: TEzDirectionpos;
      Const DirectionPen: TEzPenStyle; Const DirectionPenScale: Double;
      Const DirectionBrush: TEzBrushStyle;
      RevertDirection: Boolean ); Virtual;

    { returns true if this entity is visible in rectangle Clip and by
      using a drawing limit given in parameter MinDrawLimit }
    Function IsVisible( Const Clip: TEzRect ): Boolean;

    Function PointCode( Const Pt: TEzPoint; Const Aperture: Double;
      Var Distance: Double; SelectPickingInside: Boolean; UseDrawPoints: Boolean = True ): Integer; Virtual;

    Procedure MoveTo( Const Pt, DragPt: TEzPoint );

    Function NeedReposition: Boolean;

    { returns true if entity is closed (rectangle, polygon, ellipse, etc)}
    Function IsClosed: Boolean; Virtual;

    { comparison between one entity and other }
    Function CompareAgainst( Entity: TEzEntity; aOperator: TEzGraphicOperator ): Boolean;

    { returns true if this entity is inside OtherEntity }
    Function IsInsideEntity( _OtherEntity: TEzEntity; _FullInside: Boolean ): boolean;

    { returns true if point (X,Y) is inside this entity }
    Function IsPointInsideMe( Const X, Y: Double ): Boolean;

    { returns if OtherEntity intersects to this one }
    Function IntersectEntity( OtherEntity: TEzEntity;
      ConsidereFullyInside: Boolean = True ): boolean;

    { returns max min extents of the entity }
    Procedure MaxMinExtents( Var AXMin, AYMin, AXMax, AYMax: Double );

    Function TravelDistance( Const Distance: Double;
      Var p: TEzPoint; Var Index1, Index2: Integer ): Boolean;

    { returns true if the entity rotates clockwise or false if not }
    Function RotatesClockWise: Boolean;
    { returns true if both entities are similar }
    Function IsEqualTo( Entity: TEzEntity; IncludeAttribs: Boolean  = false): Boolean; Dynamic; Abstract;
    Procedure UpdateControlPoint( Index: Integer; Const Value: TEzPoint; Grapher: TEzGrapher=Nil); Dynamic;
    Procedure UpdateExtensionFromControlPts; Dynamic;

    Procedure BeginUpdate;
    Procedure EndUpdate;

    Procedure SetTransformMatrix( Const Matrix: TEzMatrix );
    Function GetTransformMatrix: TEzMatrix;
    Procedure ApplyTransform; Dynamic;
    Function HasTransform: Boolean;
    Function AsString( IncludeAttribs: Boolean = False; IncludeData: Boolean = False;
      DbTable: TEzBaseTable=Nil ): string;

    { this property can return the control points of the entity. Usually, this
      property is the same as property Points, but sometimes more control points
      are built in order to do richest editing.
      Important: If you call this function, after you use the vector returned
      you must free the memory }
    Function GetControlPoints(TransfPts: Boolean; Grapher: TEzGrapher=Nil): TEzVector; Virtual;
    Function GetControlPointType( Index: Integer ): TEzControlPointType; Virtual;

    { this property return the list of points of the entity}
    Property Points: TEzVector Read FPoints;
    { this property returns the points used to draw the entity
      Usually, this is the same as Points property, but sometimes, like in
      spline curves an internal vector is used }
    Property DrawPoints: TEzVector Read GetDrawPoints;
    { this property is used when editing the control points and is usually
      used in order to draw that control point with larger dimensions }
    Property SelectedVertex: Integer Read FSelectedVertex Write FSelectedVertex;
    Property EntityID: TEzEntityID Read GetEntityID;
    { If this property is assigned, then a bitmap filling will be used instead.
      This class is not responsible for freeing the bitmap resources used.
      An 8x8 b/w bitmap is accepted for Windows 9x }
    Property Bitmap: TBitmap Read FBitmap Write FBitmap;
    { the entity was suspended before finished painting }
    Property WasSuspended: Boolean Read FWasSuspended Write FWasSuspended;
    { the painting thread on this entity, used for firing some events from the
      entity }
    Property PainterObject: TEzPainterObject Read FPainterObject Write FPainterObject;
    { This is the bitmap where the AlphaChannel will be blended from
      another created internal bitmap. Usually this corresponds to the
      buffer Bitmap of the viewport and if =nil, then it means that the
      output goes to the printer
      This is used only in image entities, like TEzBandsBitmap, TEzPictureRef, etc.}
    Property BufferBitmap: TBitmap Read FBufferBitmap Write FBufferBitmap;
    Property ControlPointsToShow: TEzControlPointTypes read FControlPointsToShow write FControlPointsToShow;

  End;

  TEzEntityClass = Class Of TEzEntity;

  { TEzOpenedEntity }
  TEzOpenedEntity = Class( TEzEntity )
  Private
    Function GetPenTool: TEzPenTool;
  {$IFDEF BCB} (*_*)
    procedure SetPenTool(const Value: TEzPenTool);
  {$ENDIF}
  Protected
    FPenTool: TEzPenTool;

    Procedure MoveAndRotateControlPts( Var MovePt, RotatePt: TEzPoint; Grapher: TEzGrapher );

    Function AttribsAsString: string; Override;
  Public

    Constructor CreateEntity( Const Pts: Array Of TEzPoint; CanGrow: Boolean = True );
    Destructor Destroy; Override;
    Procedure Initialize; Override;

    Procedure LoadFromStream( Stream: TStream ); Override;
    Procedure SaveToStream( Stream: TStream ); Override;
    Procedure Draw( Grapher: TEzGrapher; Canvas: TCanvas; Const Clip: TEzRect;
      DrawMode: TEzDrawMode; Data: Pointer = Nil ); Override;

    Function PointCode( Const Pt: TEzPoint; Const Aperture: Double;
      Var Distance: Double; SelectPickingInside: Boolean; UseDrawPoints: Boolean = True ): Integer; Override;

    Function Area: Double; Override;
    Function IsEqualTo( Entity: TEzEntity; IncludeAttribs: Boolean  = false): Boolean; Override;

    Procedure ShowDirection( Grapher: TEzGrapher; Canvas: TCanvas; Const Clip: TEzRect;
      DrawMode: TEzDrawMode; DirectionPos: TEzDirectionpos;
      Const DirectionPen: TEzPenStyle; Const DirectionPenScale: Double;
      Const DirectionBrush: TEzBrushStyle;
      RevertDirection: Boolean ); Override;
    Function GetControlPoints(TransfPts: Boolean; Grapher: TEzGrapher=Nil): TEzVector; Override;
    Function GetControlPointType( Index: Integer ): TEzControlPointType; Override;

    Property PenTool: TEzPenTool Read GetPenTool Write {$IFDEF BCB} SetPenTool {$ELSE} FPenTool {$ENDIF}; (*_*)
  End;

  { TEzClosedEntity }
  TEzClosedEntity = Class( TEzOpenedEntity )
  Private
    Function GetBrushTool: TEzBrushTool;
  {$IFDEF BCB} (*_*)
    procedure SetBrushTool(const Value: TEzBrushTool);
  {$ENDIF}
  Protected
    FBrushTool: TEzBrushTool;

    Function AttribsAsString: string; Override;
  Public
    Destructor Destroy; Override;
    Procedure Initialize; Override;

    Function IsClosed: Boolean; Override;
    Function IsEqualTo( Entity: TEzEntity; IncludeAttribs: Boolean  = false): Boolean; Override;

    Procedure LoadFromStream( Stream: TStream ); Override;
    Procedure SaveToStream( Stream: TStream ); Override;

    Procedure Draw( Grapher: TEzGrapher; Canvas: TCanvas; Const Clip: TEzRect;
      DrawMode: TEzDrawMode; Data: Pointer = Nil ); Override;

    Function PointCode( Const Pt: TEzPoint; Const Aperture: Double;
      Var Distance: Double; SelectPickingInside: Boolean; UseDrawPoints: Boolean = True ): Integer; Override;

    Property BrushTool: TEzBrushTool Read GetBrushTool Write {$IFDEF BCB} SetBrushTool {$ELSE} FBrushTool {$ENDIF}; (*_*)
  End;

  {-----------------------------------------------------------------------------}
  //        TEzBaseTable - a virtual abstract access to a database table
  {-----------------------------------------------------------------------------}

  TEzIndexUnique = ( iuUnique,    iuDuplicates );
  TEzSortStatus =  ( ssAscending, ssDescending );

  TEzBaseTable = Class( TObject )
  Private
    FGis: TEzBaseGIS;
    FLongFieldNames: TStrings;
    Function GetFieldAlias( FieldNo: Integer ): String;
    Procedure SetFieldAlias( FieldNo: Integer; const Value: string );
    function GetFieldAliasByName(const FieldName: String): string;
    procedure SetFieldAliasByName(const FieldName, Value: string);
  Protected
    Function GetActive: boolean; Virtual; Abstract;
    Procedure SetActive( Value: boolean ); Virtual; Abstract;
    Function GetRecNo: Integer; Virtual; Abstract;
    Procedure SetRecNo( Value: Integer ); Virtual; Abstract;
  Public
    { the constructor must open the table }
    Constructor Create( Gis: TEzBaseGIS; Const FName: String;
      ReadWrite, Shared: Boolean ); Virtual;
    Constructor CreateNoOpen( Gis: TEzBaseGIS ); Virtual;
    Destructor Destroy; Override;
    Procedure BeginTrans; Virtual;
    Procedure RollBackTrans; Virtual;
    Procedure EndTrans; Virtual;
    Function DateGet( Const FieldName: String ): TDateTime; Virtual; Abstract;
    Function DateGetN( FieldNo: Integer ): TDateTime; Virtual; Abstract;
    Function FieldGetN( FieldNo: Integer ): String; Virtual; Abstract;
    Function FieldNo( Const FieldName: String ): Integer; Virtual; Abstract;
    Function FloatGetN( FieldNo: Integer ): Double; Virtual; Abstract;
    Function IndexCount: Integer; Virtual; Abstract;
    Function IndexAscending( Value: Integer ): boolean; Virtual; Abstract;
    {Sets an index to a dBase file, example:
     Index('GSDMO_06.CDX','LName'); }
    Function Index( Const INames, Tag: String ): Integer; Virtual; Abstract;
    {Returns the name of the tag currently used as the master index. }
    Function IndexCurrent: String; Virtual; Abstract;
    {Returns the state of the Unique flag of the index tag located in Value
     order in the index list}
    Function IndexUnique( Value: Integer ): boolean; Virtual; Abstract;
    {Returns the key expression of the index tag located in Value order in the
     index list}
    Function IndexExpression( Value: Integer ): String; Virtual; Abstract;
    {Returns the name of the index tag located in Value order in the index list.}
    Function IndexTagName( Value: Integer ): String; Virtual; Abstract;
    Function IndexFilter( Value: Integer ): String; Virtual; Abstract;
    Function IntegerGetN( FieldNo: Integer ): Integer; Virtual; Abstract;
    Function LogicGetN( FieldNo: Integer ): Boolean; Virtual; Abstract;
    Procedure MemoSave( Const FieldName: String; Stream: TStream ); Virtual; Abstract;
    Procedure MemoSaveN( FieldNo: Integer; Stream: TStream ); Virtual; Abstract;
    Function MemoSizeN( FieldNo: Integer ): Integer; Virtual; Abstract;
    Function MemoSize( Const FieldName: String ): Integer; Virtual; Abstract;
    Function StringGetN( FieldNo: Integer ): String; Virtual; Abstract;
    Procedure DatePut( Const FieldName: String; value: TDateTime ); Virtual; Abstract;
    Procedure DatePutN( FieldNo: Integer; value: TDateTime ); Virtual; Abstract;
    Procedure FieldPutN( FieldNo: Integer; Const Value: String ); Virtual; Abstract;
    Procedure FieldPutNEx( FieldNo: Integer; Const Value: String ); Virtual; Abstract;
    Procedure FloatPutN( FieldNo: Integer; Const Value: Double ); Virtual; Abstract;
    Procedure FlushDB; Virtual; Abstract;
    Procedure IndexOn( Const IName, tag, keyexp, forexp: String;
      uniq: TEzIndexUnique; ascnd: TEzSortStatus ); Virtual; Abstract;
    Procedure LogicPutN( fieldno: Integer; value: boolean ); Virtual; Abstract;
    Procedure MemoLoadN( fieldno: Integer; Stream: TStream ); Virtual; Abstract;
    Procedure MemoLoad( Const fieldname: String; Stream: TStream ); Virtual; Abstract;
    Procedure Pack; Virtual; Abstract;
    Procedure Recall; Virtual; Abstract;
    Procedure Reindex; Virtual; Abstract;
    Procedure SetTagTo( Const TName: String ); Virtual; Abstract;
    Procedure SetUseDeleted( tf: boolean ); Virtual; Abstract;
    Procedure StringPutN( fieldno: Integer; Const value: String ); Virtual; Abstract;
    Procedure Zap; Virtual; Abstract;
    { this class must handle assigning from Dataset,FieldNo to the
      current record in this dataset in field DstFieldNo
      care must be taken for memo fields }
    Procedure AssignFrom( Dataset: TEzBaseTable; SrcFieldNo, DstFieldNo: Integer );
    Function FieldDec( FieldNo: Integer ): Integer; Virtual; Abstract;
    Function Field( FieldNo: Integer ): String; Virtual; Abstract;
    Function Deleted: Boolean; Virtual; Abstract;
    Function FieldLen( FieldNo: Integer ): Integer; Virtual; Abstract;
    Procedure Append( NewRecno: Integer ); Virtual; Abstract;
    Function BOF: Boolean; Virtual; Abstract;
    Function EOF: Boolean; Virtual; Abstract;
    Function FieldCount: Integer; Virtual; Abstract;
    Function FieldGet( Const FieldName: String ): String; Virtual; Abstract;
    { returns 'M','B','G', 'F','N', 'C', 'L','D', 'I', 'T' }
    Function FieldType( FieldNo: Integer ): char; Virtual; Abstract;
    Function Find( Const ss: String; IsExact, IsNear: boolean ): boolean; Virtual; Abstract;
    Function FloatGet( Const Fieldname: String ): Double; Virtual; Abstract;
    Function IntegerGet( Const FieldName: String ): Integer; Virtual; Abstract;
    Function LogicGet( Const FieldName: String ): Boolean; Virtual; Abstract;
    Function RecordCount: Integer; Virtual; Abstract;
    Function StringGet( Const FieldName: String ): String; Virtual; Abstract;
    //Procedure CopyStructure( Const FileName, APassword: String ); Virtual; Abstract;
    //Procedure CopyTo( Const FileName, APassword: String ); Virtual; Abstract;
    Procedure Delete; Virtual; Abstract;
    Procedure Edit; Virtual; Abstract;
    Procedure FieldPut( Const FieldName, Value: String ); Virtual; Abstract;
    Procedure FieldPutEx( Const FieldName, Value: String ); Virtual; Abstract;
    Procedure First; Virtual; Abstract;
    Procedure FloatPut( Const FieldName: String; Const Value: Double ); Virtual; Abstract;
    Procedure Go( n: Integer ); Virtual; Abstract;
    Procedure IntegerPut( Const Fieldname: String; Value: Integer ); Virtual; Abstract;
    Procedure IntegerPutN( FieldNo: Integer; Value: Integer ); Virtual; Abstract;
    Procedure Last; Virtual; Abstract;
    Procedure LogicPut( Const fieldname: String; value: boolean ); Virtual; Abstract;
    Procedure Next; Virtual; Abstract;
    Procedure Post; Virtual; Abstract;
    Procedure Prior; Virtual; Abstract;
    Procedure Refresh; Virtual; Abstract;
    Procedure StringPut( Const fieldname, value: String ); Virtual; Abstract;
    { procedures for manipulating databases }
    Function DBCreateTable( Const fname: String; AFieldList: TStringList ): boolean; Virtual;
    function DBTableExists( const TableName: string ): Boolean; Virtual;
    Function DBDropTable( const TableName: string): Boolean; Virtual;
    Function DBDropIndex( const TableName: string): Boolean; Virtual;
    Function DBRenameTable( const Source, Target: string): Boolean; Virtual;
    function FieldNoFromAlias( const AliasName: String ): Integer;

    Property Active: boolean Read GetActive Write SetActive;
    Property RecNo: Integer Read GetRecNo Write SetRecNo;
    Property Gis: TEzBaseGIS read FGis write FGis;
    Property LongFieldNames: TStrings read FLongFieldNames;
    Property FieldAlias[FieldNo: Integer]: string read GetFieldAlias write SetFieldAlias;
    Property FieldAliasByName[const FieldName: String]: string read GetFieldAliasByName write SetFieldAliasByName;
  End;

  TEzBaseTableClass = Class Of TEzBaseTable;

  {-------------------------------------------------------------------------------}
  {                  Layers                                                       }
  {-------------------------------------------------------------------------------}

  { TEzBaseLayerInfo }
  TEzBaseLayerInfo = Class
  Protected
    FLayer: TEzBaseLayer; // a reference

    Function GetOverlappedTextAction: TEzOverlappedTextAction; Virtual; Abstract;
    Procedure SetOverlappedTextAction( Value: TEzOverlappedTextAction ); Virtual; Abstract;

    Function GetOverlappedTextColor: TColor; Virtual; Abstract;
    Procedure SetOverlappedTextColor( Value: TColor ); Virtual; Abstract;

    Function GetTextHasShadow: Boolean; Virtual; Abstract;
    Procedure SetTextHasShadow( Value: boolean ); Virtual; Abstract;

    Function GetTextFixedSize: Byte; Virtual; Abstract;
    Procedure SetTextFixedSize( Value: Byte ); Virtual; Abstract;

    Function GetVisible: boolean; Virtual; Abstract;
    Procedure SetVisible( Value: boolean ); Virtual;

    Function GetSelectable: boolean; Virtual; Abstract;
    Procedure SetSelectable( Value: boolean ); Virtual;

    Function GetIsCosmethic: boolean; Virtual; Abstract;
    Procedure SetIsCosmethic( value: boolean ); Virtual; Abstract;

    Function GetExtension: TEzRect; Virtual; Abstract;
    Procedure SetExtension( Const Value: TEzRect ); Virtual; Abstract;

    Function GetIDCounter: Integer; Virtual; Abstract;
    Procedure SetIDCounter( Value: Integer ); Virtual; Abstract;

    Function GetIsAnimationLayer: boolean; Virtual; Abstract;
    Procedure SetIsAnimationLayer( Value: boolean ); Virtual; Abstract;

    Function GetIsIndexed: boolean; Virtual; Abstract;
    Procedure SetIsIndexed( Value: boolean ); Virtual; Abstract;

    Function GetCoordsUnits: TEzCoordsUnits; Virtual; Abstract;
    Procedure SetCoordsUnits( Value: TEzCoordsUnits ); Virtual; Abstract;

    Function GetCoordSystem: TEzCoordSystem; Virtual; Abstract;
    Procedure SetCoordSystem( Value: TEzCoordSystem ); Virtual; Abstract;

    Function GetUseAttachedDB: Boolean; Virtual;
    Procedure SetUseAttachedDB( Value: Boolean ); Virtual;

    Function GetLocked: Boolean; Virtual;
    Procedure SetLocked( Value: Boolean ); Virtual;

  Public
    Constructor Create( Layer: TEzBaseLayer ); Virtual;
    procedure Assign( Source: TEzBaseLayerInfo );

    Property Extension: TEzRect Read GetExtension Write SetExtension;
    Property IDCounter: Integer Read GetIDCounter Write SetIDCounter;

    Property UseAttachedDB: Boolean Read GetUseAttachedDB Write SetUseAttachedDB;
    Property IsCosmethic: boolean Read GetIsCosmethic Write SetIsCosmethic;
    Property IsAnimationLayer: Boolean Read GetIsAnimationLayer Write SetIsAnimationLayer;
    Property IsIndexed: Boolean Read GetIsIndexed Write SetIsIndexed;

    Property CoordsUnits: TEzCoordsUnits Read GetCoordsUnits Write SetCoordsUnits;
    Property CoordSystem: TEzCoordSystem Read GetCoordSystem Write SetCoordSystem;
    Property Visible: Boolean Read GetVisible Write SetVisible;
    Property Selectable: Boolean Read GetSelectable Write SetSelectable;

    Property TextHasShadow: Boolean Read GetTextHasShadow Write SetTextHasShadow;
    Property TextFixedSize: Byte Read GetTextFixedSize Write SetTextFixedSize;

    Property OverlappedTextAction: TEzOverlappedTextAction Read GetOverlappedTextAction Write SetOverlappedTextAction;
    Property OverlappedTextColor: TColor Read GetOverlappedTextColor Write SetOverlappedTextColor;
    Property Locked: Boolean Read GetLocked Write SetLocked;

  End;

  { layer events }
  TEzBeforePaintEntityEvent = Procedure( Sender: TObject;
    Layer: TEzBaseLayer;
    Recno: Integer;
    Entity: TEzEntity;
    Grapher: TEzGrapher;
    Canvas: TCanvas;
    Const Clip: TEzRect;
    DrawMode: TEzDrawMode;
    Var CanShow: Boolean;
    Var EntList: TEzEntityList;
    Var AutoFree: Boolean ) Of Object;

  TEzAfterPaintEntityEvent = Procedure( Sender: TObject;
    Layer: TEzBaseLayer;
    Recno: Integer;
    Entity: TEzEntity;
    Grapher: TEzGrapher;
    Canvas: TCanvas;
    Const Clip: TEzRect;
    DrawMode: TEzDrawMode ) Of Object;

  { TEzBaseLayer }
  TEzBaseLayer = Class
  Private
    FLayers: TEzBaseLayers;
    FCoordMultiplier: Integer;
    FModified: Boolean;
    FAutoFlush: Boolean;
    FName: String;
    FFileName: String;
    FBlinkers: TIntegerList;

    FOnBeforePaintEntity: TEzBeforePaintEntityEvent;
    FOnAfterPaintEntity: TEzAfterPaintEntityEvent;
    FMinScale: Double;
    FMaxScale: Double;

    Function GetIndex: Integer;
    function GetBlinkers: TIntegerList;
    procedure SetMaxScale(const Value: Double);
    procedure SetMinScale(const Value: Double);

  Protected
    FLayerInfo: TEzBaseLayerInfo;
    Frt: TRTree;

    Function GetRecno: Integer; Virtual; Abstract;
    Procedure SetRecno( Value: Integer ); Virtual; Abstract;

    Function GetRecordCount: Integer; Virtual;

    Function GetDBTable: TEzBaseTable; Virtual; Abstract;

    Procedure SetFileName( Const Value: String ); Virtual;

    Function GetActive: Boolean; Virtual; Abstract;
    Procedure SetActive( Value: Boolean ); Virtual; Abstract;

    function GetFiltered: Boolean; virtual; abstract;

  Public
    Constructor Create( Layers: TEzBaseLayers; Const FileName: String ); Virtual;
    Destructor Destroy; Override;

    { for internal use only }
    Procedure InitializeOnCreate( Const FileName: String; AttachedDB, IsAnimation: Boolean;
      CoordSystem: TEzCoordSystem; CoordsUnits: TEzCoordsUnits;
      FieldList: TStrings ); Dynamic; Abstract;

    Procedure Assign( Source: TEzBaseLayer ); Dynamic; Abstract;

    Procedure Open; Virtual; Abstract;
    Procedure Close; Virtual; Abstract;
    Procedure ForceOpened; Virtual; Abstract;
    Procedure WriteHeaders( FlushFiles: Boolean ); Virtual; Abstract;

    Function AddEntity( Entity: TEzEntity; Direct: Boolean = False ): Integer; Virtual; Abstract;
    Procedure DeleteEntity( RecNo: Integer ); Virtual; Abstract;
    Procedure UnDeleteEntity( RecNo: Integer ); Virtual; Abstract;
    function RecNoOfEntity(ExtId: Integer): Integer;
    Function LoadEntityWithRecNo( RecNo: Longint ): TEzEntity; Virtual; Abstract;
    Function EntityWithRecno( Recno: Integer ): TEzEntity; Virtual; // for in-memory layers only

    Procedure UpdateEntity( RecNo: Integer; Entity2D: TEzEntity ); Virtual; Abstract;
    Function UpdateExtension: TEzRect; Dynamic; Abstract;
    Function QuickUpdateExtension: TEzRect; Dynamic; Abstract;
    Procedure Pack( ShowMessages: Boolean ); Virtual;

    Procedure Repair; Virtual;
    Procedure Zap; Virtual; Abstract;

    Procedure First; Virtual; Abstract;
    Procedure Last; Virtual; Abstract;
    Procedure Next; Virtual; Abstract;

    Function Eof: Boolean; Virtual; Abstract;

    Procedure StartBuffering; Virtual;
    Procedure EndBuffering; Virtual;

    Procedure SetGraphicFilter( s: TSearchType; Const visualWindow: TEzRect ); Virtual; Abstract;
    Procedure CancelFilter; Virtual; Abstract;
    Procedure CancelScope;

    Function ContainsDeleted: Boolean; Dynamic; Abstract;

    Procedure Recall; Dynamic;

    Function SendEntityToBack( ARecno: Integer ): Integer; Dynamic; Abstract;
    Function BringEntityToFront( ARecno: Integer ): Integer; Dynamic; Abstract;

    Function RecIsDeleted: Boolean; Virtual; Abstract;

    Procedure RecLoadEntity2( Entity: TEzEntity ); Virtual; Abstract;
    Function RecLoadEntity: TEzEntity; Virtual; Abstract;
    { used only for in-memory layers and returns a pointer that must not be
      disposed }
    Function RecEntity: TEzEntity; Virtual;

    Function RecExtension: TEzRect; Virtual; Abstract; // for current entity

    Function RecEntityID: TEzEntityID; Virtual; Abstract; // for current entity

    Function GetBookmark: Pointer; Virtual; Abstract;
    Procedure GotoBookmark( Bookmark: Pointer ); Virtual; Abstract;
    Procedure FreeBookmark( Bookmark: Pointer ); Virtual; Abstract;

    Procedure MaxMinExtents( Var AMinX, AMinY, AMaxX, AMaxY: Double );

    Procedure RebuildTree; Dynamic; Abstract;

    { current entity in layer.recno }
    Procedure CopyRecord( SourceRecno, DestRecno: Integer ); Virtual; Abstract;

    Function IsClientServer: Boolean; Virtual;
    Function DeleteLayerFiles: Boolean; Dynamic;

    { not virtual methods }
    Function GetEntityUniqueID( RecNo: Integer ): Integer;
    Function EntityType( RecNo: Integer ): TEzEntityID;

    Procedure PopulateFieldList( Strings: TStrings; WithAlias: Boolean = False );

    Function FloatRect2Rect( Const Rect: TEzRect ): TRect_rt;
    Function Rect2FloatRect( Const Rect: TRect_rt ): TEzRect;

    Function DefineScope( Const Scope: String ): Boolean; Dynamic; Abstract;
    Function DefinePolygonScope( Polygon: TEzEntity; Const Scope: String;
      aOperator: TEzGraphicOperator ): Boolean; Dynamic; Abstract;
    Function DefineBufferScope( Polyline: TEzEntity; Const Scope: String;
      aOperator: TEzGraphicOperator; CurvePoints: Integer;
      Const Distance: Double ): Boolean;
    Function DefineRectangleScope( Const AXmin, AYmin, AXmax, AYmax: Double;
      Const Scope: String; aOperator: TEzGraphicOperator ): Boolean;
    Function DefinePolylineScope( Polyline: TEzEntity;
      Const Scope: String ): Boolean;

    Procedure Synchronize; Virtual;
    Procedure StartBatchInsert; Dynamic;
    Procedure CancelBatchInsert; Dynamic;
    Procedure FinishBatchInsert; Dynamic;

    Procedure GetFieldList( Strings: TStrings ); Dynamic;

    Function LayerUp: Integer;
    Function LayerDown: Integer;

    Function BringToTop: Integer;
    Function SendToBack: Integer;
    function GetExtensionForRecords( List: TIntegerList ): TEzRect; Dynamic; Abstract;
    Function IsCurrent: Boolean;
    Function HasBlinkers: Boolean;
    Procedure ClearBlinkers;

    Property Modified: Boolean Read FModified Write FModified;
    Property Name: String Read FName Write FName;
    Property Recno: Integer Read GetRecno Write SetRecno;
    Property DBTable: TEzBaseTable Read GetDBTable;

    Property RecordCount: Longint Read GetRecordCount;
    Property rt: TRTree Read Frt;
    Property Index: Integer Read GetIndex;
    Property AutoFlush: Boolean Read FAutoFlush Write FAutoFlush;
    Property MaxScale: Double read FMaxScale write SetMaxScale;
    Property MinScale: Double read FMinScale write SetMinScale;

    Property FileName: String Read FFileName Write SetFileName;
    Property LayerInfo: TEzBaseLayerInfo Read FLayerInfo;
    Property Layers: TEzBaseLayers Read FLayers;

    Property Active: Boolean Read GetActive Write SetActive;
    Property Blinkers: TIntegerList read GetBlinkers;

    property Filtered: Boolean read GetFiltered;

    Property CoordMultiplier: Integer Read FCoordMultiplier Write FCoordMultiplier;
    Property OnBeforePaintEntity: TEzBeforePaintEntityEvent read FOnBeforePaintEntity write FOnBeforePaintEntity;
    Property OnAfterPaintEntity: TEzAfterPaintEntityEvent read FOnAfterPaintEntity write FOnAfterPaintEntity;
  End;


  TEzLayerType = ( ltMemory, ltDesktop, ltClientServer );

  { TEzBaseLayers }
  TEzBaseLayers = Class
  Private
    { data }
    FGIS: TEzBaseGIS; // a reference
    FItems: TList;

    Function Get( Index: Integer ): TEzBaseLayer;
    Function GetCount: Integer;
  Public

    Constructor Create( GIS: TEzBaseGIS ); Virtual;
    Destructor Destroy; Override;

    Procedure Clear;
    Procedure Assign( Source: TEzBaseLayers ); Dynamic; Abstract;
    Procedure Exchange( Index1, Index2: Integer );
    Function Add( Const FileName: String; LayerType: TEzLayerType ): Integer; Dynamic; Abstract;

    Function CreateNew( Const FileName: String; FieldList: TStrings = Nil ): TEzBaseLayer; Dynamic; Abstract;
    Function CreateNewEx( Const FileName: String;
                          CoordSystem: TEzCoordSystem;
                          CoordsUnits: TEzCoordsUnits;
                          FieldList: TStrings = Nil ): TEzBaseLayer; Dynamic; Abstract;
    Function CreateNewCosmethic( Const FileName: String ): TEzBaseLayer; Dynamic; Abstract;
    Function CreateNewAnimation( Const FileName: String ): TEzBaseLayer; Dynamic; Abstract;

    Function Delete( Const LayerName: String; DeleteFiles: Boolean ): Boolean; Dynamic; Abstract;
    Function IndexOf( Layer: TEzBaseLayer ): Integer;
    Function IndexOfName( Const LayerName: String ): Integer;
    Function LayerByName( Const LayerName: String ): TEzBaseLayer;
    Procedure Sort;

    Procedure OpenLayers;

    Function LayerUp( Index: Integer ): Integer;
    Function LayerDown( Index: Integer ): Integer;
    Function BringToTop( Index: Integer ): Integer;
    Function SendToBack( Index: Integer ): Integer;

    { populate Strings with the list of layer names }
    Procedure PopulateList( Strings: TStrings );
    Function IsClientServer: Boolean; Virtual;

    Property Items[Index: Integer]: TEzBaseLayer Read Get; Default;
    Property Count: Integer Read GetCount;
    Property GIS: TEzBaseGIS Read FGIS;

  End;


  {-------------------------------------------------------------------------------}
  {                  TEzBaseGIS                                                   }
  {-------------------------------------------------------------------------------}

  { TEzBaseMapInfo }
  TEzBaseMapInfo = Class
  Protected
    FGIS: TEzBaseGIS;

    Function GetNumLayers: Integer; Virtual; Abstract;
    Procedure SetNumLayers( Value: Integer ); Virtual; Abstract;

    Function GetExtension: TEzRect; Virtual; Abstract;
    Procedure SetExtension( Const Value: TEzRect ); Virtual; Abstract;

    Function GetCurrentLayer: String; Virtual; Abstract;
    Procedure SetCurrentLayer( Const Value: String ); Virtual;

    Function GetAerialViewLayer: String; Virtual; Abstract;
    Procedure SetAerialViewLayer( Const Value: String ); Virtual; Abstract;

    Function GetLastView: TEzRect; Virtual; Abstract;
    Procedure SetLastView( Const Value: TEzRect ); Virtual; Abstract;

    Function GetCoordsUnits: TEzCoordsUnits; Virtual; Abstract;
    Procedure SetCoordsUnits( Value: TEzCoordsUnits ); Virtual; Abstract;

    Function GetCoordSystem: TEzCoordSystem; Virtual; Abstract;
    Procedure SetCoordSystem( Value: TEzCoordSystem ); Virtual; Abstract;

    Function GetIsAreaClipped: boolean; Virtual; Abstract;
    Procedure SetIsAreaClipped( Value: Boolean ); Virtual; Abstract;

    Function GetAreaClipped: TEzRect; Virtual; Abstract;
    Procedure SetAreaClipped( Const Value: TEzRect ); Virtual; Abstract;

    Function GetClipAreaKind: TEzClipAreaKind; Virtual; Abstract;
    Procedure SetClipAreaKind( Value: TEzClipAreaKind ); Virtual; Abstract;

  Public
    { methods }
    Constructor Create( GIS: TEzBaseGIS );

    Procedure Initialize; Dynamic; Abstract;

    Procedure Assign( Source: TEzBaseMapInfo );
    Function IsValid: Boolean; Dynamic;

    Function UnitsVerb: String;
    Function UnitsLongVerb: String;

    { properties }
    Property NumLayers: Integer Read GetNumLayers Write SetNumLayers;
    Property Extension: TEzRect Read GetExtension Write SetExtension;
    Property CurrentLayer: String Read GetCurrentLayer Write SetCurrentLayer;
    Property AerialViewLayer: String Read GetAerialViewLayer Write SetAerialViewLayer;

    Property LastView: TEzRect Read GetLastView Write SetLastView;
    Property CoordsUnits: TEzCoordsUnits Read GetCoordsUnits Write SetCoordsUnits;
    Property CoordSystem: TEzCoordSystem Read GetCoordSystem Write SetCoordSystem;
    Property IsAreaClipped: Boolean Read GetIsAreaClipped Write SetIsAreaClipped;

    Property AreaClipped: TEzRect Read GetAreaClipped Write SetAreaClipped;
    Property ClipAreaKind: TEzClipAreaKind Read GetClipAreaKind Write SetClipAreaKind;
    Property GIS: TEzBaseGIS Read FGIS;
  End;

  { TEzDrawBoxList }
  TEzDrawBoxList = Class
  Private
    FItems: TList;
    Function GetCount: Integer;
    Function GetItem( Index: Integer ): TEzBaseDrawBox;
  Public
    Constructor Create;
    Destructor Destroy; Override;
    Procedure Add( Item: TEzBaseDrawBox );
    Procedure Delete( Index: Integer );
    Function IndexOf( Item: TEzBaseDrawBox ): Integer;

    Property Count: Integer Read GetCount;
    Property Items[Index: Integer]: TEzBaseDrawBox Read GetItem; Default;
  End;

  { events definition for TEzGIS}

  TEzProgressStage = ( epsStarting, epsMessage, epsEnding, epsUpdating );

  { the result of a query method:
    Data: any additional info for IDentifying the caller
    Layername: the name of the layer of the entity detected
    Recno: the record number }
  TEzQueryResultsEvent = Procedure( Sender: TObject;
    Data: Longint;
    Const Layername: String;
    Recno: Integer ) Of Object;

  TEzEntityEvent = Procedure( Sender: TObject;
    Layer: TEzBaseLayer;
    Recno: Integer ) Of Object;

  TEzEntityAcceptEvent = Procedure( Sender: TObject;
    Layer: TEzBaseLayer;
    Recno: Integer;
    Var Accept: Boolean ) Of Object;

  TEzBeforeTransformEvent = Procedure( Sender: TObject;
    Layer: TEzBaseLayer;
    Recno: Integer;
    Entity: TEzEntity;
    TransformType: TEzTransformType;
    Var Accept: Boolean ) Of Object;

  { Before insert an entity (can be used to filter the inserted entities) }
  TEzBeforeInsertEvent = Procedure( Sender: TObject;
    Layer: TEzBaseLayer;
    Entity: TEzEntity;
    Var Accept: Boolean ) Of Object;

  TEzUDFCheckEvent = Procedure( Sender: TObject;
    Const LayerName, Identifier: String;
    Params: TParameterList;
    Var DataType: TExprType; Var MaxLen: Integer;
    Var Accept: Boolean ) Of Object;

  TEzUDFSolveEvent = Procedure( Sender: TObject;
    Const Identifier: String;
    Params: TParameterList;
    Layer: TEzBaseLayer; RecNo: Integer;
    Var Value: String ) Of Object;

  TEzStartExternalPopulateEvent = Procedure( Sender: TObject;
    Const LayerName: string; Var Accept: Boolean ) Of Object;

  TEzExternalPopulateEvent = Procedure( Sender: TObject; Const LayerName: string;
    Var Identifier: string ) Of object;

  TEzEndExternalPopulateEvent = Procedure( Sender: TObject; Const LayerName: string ) Of Object;

  TEzBeforePaintLayerEvent = Procedure( Sender: TObject;
    Layer: TEzBaseLayer;
    Grapher: TEzGrapher;
    Var CanShow: Boolean;
    Var WasFiltered: Boolean;
    Var EntList: TEzEntityList;
    Var AutoFree: Boolean ) Of Object;

  TEzAfterPaintLayerEvent = Procedure( Sender: TObject;
    Layer: TEzBaseLayer;
    Grapher: TEzGrapher;
    Var EntList: TEzEntityList;
    Var AutoFree: Boolean ) Of Object;

  TEzBeforeSymbolPaintEvent = Procedure( Sender: TObject;
    Layer: TEzBaseLayer;
    Recno: Integer;
    Grapher: TEzGrapher;
    Canvas: TCanvas;
    Const Clip: TEzRect;
    Style: TEzSymbolTool ) Of Object;

  TEzBeforeBrushPaintEvent = Procedure( Sender: TObject;
    Layer: TEzBaseLayer;
    Recno: Integer;
    Grapher: TEzGrapher;
    Canvas: TCanvas;
    Const Clip: TEzRect;
    Style: TEzBrushTool ) Of Object;

  TEzBeforePenPaintEvent = Procedure( Sender: TObject;
    Layer: TEzBaseLayer;
    Recno: Integer;
    Grapher: TEzGrapher;
    Canvas: TCanvas;
    Const Clip: TEzRect;
    Style: TEzPenTool ) Of Object;

  TEzBeforeFontPaintEvent = Procedure( Sender: TObject;
    Layer: TEzBaseLayer;
    Recno: Integer;
    Grapher: TEzGrapher;
    Canvas: TCanvas;
    Const Clip: TEzRect;
    Style: TEzFontTool ) Of Object;

  { show progress status for internal map actions }
  TEzProgressEvent = Procedure( Sender: TObject;
    Stage: TEzProgressStage;
    Const Caption: String;
    Min, Max, Position: Integer ) Of Object;

  TEzShowHintEvent = Procedure( Sender: TObject;
    Layer: TEzBaseLayer;
    Recno: Integer;
    Var Hint: String;
    Var ShowHint: Boolean ) Of Object;

  TEzShowDirectionEvent = Procedure( Sender: TObject;
    Layer: TEzBaseLayer;
    Recno: Integer;
    Var DirectionPos: TEzDirectionPos;
    DirectionPen: TEzPenTool;
    DirectionBrush: TEzBrushTool;
    Var RevertDirection: Boolean;
    Var CanShow: Boolean ) Of Object;

  TEzBeforeLayerEvent = Procedure( Sender: TObject;
    Const LayerName: String;
    Var Proceed: Boolean ) Of Object;

  TEzLayerEvent = Procedure( Sender: TObject;
    Const LayerName: String ) Of Object;

  TEzPrintProgressEvent = Procedure( Sender: TObject; Percent: Integer;
    Var Cancel: Boolean ) Of Object;

  TEzErrorSource = ( esUndefined, esImporting, esLayerNotFound );

  TEzErrorEvent = Procedure( Sender: TObject; Const Msg: String;
    ErrorSource: TEzErrorSource; Var CanContinue: Boolean ) Of Object;

  TEzGisTimerEvent = Procedure( Sender: TObject; Var CancelPainting: Boolean ) Of Object;

  TEzFontShadowStyle = ( fssLowerRight, fssUpperRight, fssLowerLeft, fssUpperLeft );

  { TEzBaseGIS }

  TEzBaseGIS = Class( TComponent )
  Private
    FActive: Boolean;
    FFileName: String;
    FDrawBoxList: TEzDrawBoxList;
    FLayers: TEzBaseLayers; { Layers of the component. }
    FHGuideLines: TEzDoubleList;
    FVGuideLines: TEzDoubleList;
    FModified: Boolean;
    FReadOnly: Boolean;
    FAutoSetLastView: Boolean;
    FClipPolygonalArea: TEzVector;
    FShowWaitCursor: Boolean;
    FTimerFrequency: Cardinal;

    { the subdirectory to search for layer files. Mainly used in c/s when
      desktop layers are added to the list of layers. }
    FLayersSubdir: String;
    FProjectionParams: TStrings;

    { This class is used when clipping by using the selected entities }
    FClippedEntities: TEzSelection;

    { used for internal procedures }
    FProgressMin: Integer;
    FProgressMax: Integer;
    FProgressPosition: Integer;
    FPolygonClipOperation: TEzPolyClipTool;

    FPrintTimerFrequency: Integer;
    FFontShadowStyle: TEzFontShadowStyle;
    FFontShadowColor: TColor;
    FFontShadowOffset: Integer;

    {Events}
    FOnUDFCheck: TEzUDFCheckEvent;
    FOnUDFSolve: TEzUDFSolveEvent;
    FOnFileNameChange: TNotifyEvent;

    FOnBeforePaintEntity: TEzBeforePaintEntityEvent;
    FOnAfterPaintEntity: TEzAfterPaintEntityEvent;

    FOnBeforeSymbolPaint: TEzBeforeSymbolPaintEvent;
    FOnBeforeBrushPaint: TEzBeforeBrushPaintEvent;
    FOnBeforePenPaint: TEzBeforePenPaintEvent;
    FOnBeforeFontPaint: TEzBeforeFontPaintEvent;

    FOnProgress: TEzProgressEvent;

    FOnBeforePaintLayer: TEzBeforePaintLayerEvent;
    FOnAfterPaintLayer: TEzAfterPaintLayerEvent;
    FOnBeforePaintLayers: TNotifyEvent;
    FOnAfterPaintLayers: TNotifyEvent;

    FOnShowDirection: TEzShowDirectionEvent;
    FOnBeforeClose: TNotifyEvent;
    FOnBeforeOpen: TNotifyEvent;

    FOnBeforeDeleteLayer: TEzBeforeLayerEvent;
    FOnAfterDeleteLayer: TEzLayerEvent;
    FOnBeforeInsertLayer: TEzBeforeLayerEvent;
    FOnAfterInsertLayer: TEzLayerEvent;
    FOnBeforeTransform: TEzBeforeTransformEvent;
    FOnAfterTransform: TEzEntityEvent;
    FOnBeforeDragDrop: TEzEntityAcceptEvent;
    FOnAfterDragDrop: TEzEntityEvent;

    FOnQueryResults: TEzQueryResultsEvent;

    FOnVisibleLayerChange: TEzLayerEvent;
    FOnSelectableLayerChange: TEzLayerEvent;
    FOnCurrentLayerChange: TEzLayerEvent;

    FOnModified: TNotifyEvent;
    FOnClippedAreaChanged: TNotifyEvent;

    FOnPrintBegin: TNotifyEvent;
    FOnPrintProgress: TEzPrintProgressEvent;
    FOnPrintEnd: TNotifyEvent;

    FOnError: TEzErrorEvent;
    FOnGisTimer: TEzGisTimerEvent;
    FOnStartExternalPopulate: TEzStartExternalPopulateEvent;
    FOnEndExternalPopulate: TEzEndExternalPopulateEvent;
    FOnExternalPopulate: TEzExternalPopulateEvent;

    Procedure SetLayers( Value: TEzBaseLayers );

    Function GetCurrentLayerName: String;
    Procedure SetCurrentLayerName( Const Value: String );

    Function GetCurrentLayer: TEzBaseLayer;
    Function InternalPolyClipEx( Const Entity1, Entity2: TEzEntity; Op: TEzPolyClipOp ): TEzEntity;
    Function FoundFirstCosmethicLayer: TEzBaseLayer;
    Procedure SetModified( Value: Boolean );
    Procedure SetActive( Value: Boolean );
    Procedure SetPolygonClipOperation( value: TEzPolyClipTool );
    procedure SetCurrentLayer(const Value: TEzBaseLayer);
  Protected

    FMapInfo: TEzBaseMapInfo;

    Procedure WriteMapHeader( Const Filename: String ); Dynamic; Abstract;
    Procedure SetFilename( const Value: string ); Virtual;

  Public
    { Public declarations }

    { methods }
    Constructor Create( AOwner: TComponent ); Override;
    Destructor Destroy; Override;
    Function IsDesigning: Boolean;

    Function CreateLayer( Const LayerName: String; LayerType: TEzLayerType ): TEzBaseLayer; Dynamic; Abstract;
    Procedure Open; Dynamic;
    Procedure Close; Dynamic;
    Procedure Save;
    Procedure SaveAs( Const FileName: String ); Dynamic; Abstract;

    Procedure SaveIfModified;
    Procedure UpdateExtension;
    Procedure QuickUpdateExtension;
    Procedure CreateNew( Const FileName: String ); Dynamic;

    Procedure RepaintViewports;
    Procedure RefreshViewports;
    Procedure ClearClippedArea;

    Function VectIntersect( Vector1, Vector2, IntersectVector: TEzVector ): Boolean;
    Procedure RebuildTree;
    Function OpenMode: Word;
{$IFDEF GIS_CONTROLS}
    Procedure AddShape( Const FileName: String );
    Procedure AddDGN( Const FileName: String );
{$ENDIF}
    Procedure AddGeoref( Const LayerName, FileName: String ); Dynamic;

    Procedure StartProgress( Const ACaption: String; AMin, AMax: Integer );
    Procedure UpdateProgress( Position: Integer );
    Procedure UpdateCaption( Const ACaption: String );
    Procedure EndProgress;

    Function IsClientServer: Boolean; Virtual;

    { methods changed from the viewport to this control }
    Procedure MaxMinExtents( Var AXMin, AYMin, AXMax, AYMax: Double );

    Function EntityDifference( Const Entity1, Entity2: TEzEntity ): TEzEntity;

    Function EntityIntersect( Const Entity1, Entity2: TEzEntity ): TEzEntity;

    Function EntityUnion( Const Entity1, Entity2: TEzEntity ): TEzEntity;

    Function EntityXor( Const Entity1, Entity2: TEzEntity ): TEzEntity;
    Function EntitySplit( Const Entity1, Entity2: TEzEntity ): TEzEntity;
    Function CreateBufferEntity( Entity: TEzEntity; CurvePoints: Integer;
      Const Distance: Double ): TEzEntity;
    Function WithinDistance( Entity1, Entity2: TEzEntity;
      Const Distance: Double ): Boolean;

    Function EntitiesRelate( Entity1, Entity2: TEzEntity;
      GraphicOperator: TEzGraphicOperator ): Boolean;
    { the query methods }
    Procedure QueryExpression( Const LayerName, Expression: String; Data: Longint;
      List: TIntegerList; ClearBefore: Boolean );

    Procedure QueryRectangle( Const AxMin, AyMin, AxMax, AyMax: double;
      Const Layername, QueryExpression: String; aOperator: TEzGraphicOperator;
      Data: Longint; List: TIntegerList; ClearBefore: Boolean );

    Procedure QueryPolygon( Polygon: TEzEntity;
      Const Layername, QueryExpression: String; aOperator: TEzGraphicOperator;
      Data: Longint; List: TIntegerList; ClearBefore: Boolean );

    Procedure QueryBuffer( Polyline: TEzEntity; Const Layername, QueryExpression: String;
      aOperator: TEzGraphicOperator; Data: Longint; CurvePoints: Integer;
      Const Distance: Double; List: TIntegerList; ClearBefore: Boolean );

    Procedure QueryPolyline( Polyline: TEzEntity;
      Const Layername, QueryExpression: String; Data: Longint; List: TIntegerList;
      ClearBefore: Boolean );

    procedure LoadFontFile(const FileName: string);
    procedure LoadSymbolsFile(const FileName: string);
    procedure LoadLineTypesFile(const FileName: string);

    Property Layers: TEzBaseLayers Read FLayers Write SetLayers;
    Property Modified: Boolean Read FModified Write SetModified;
    Property DrawBoxList: TEzDrawBoxList Read FDrawBoxList;
    Property CurrentLayer: TEzBaseLayer Read GetCurrentLayer write SetCurrentLayer;

    Property CurrentLayerName: String Read GetCurrentLayerName Write SetCurrentLayerName;
    Property ClipPolygonalArea: TEzVector Read FClipPolygonalArea;
    Property ClippedEntities: TEzSelection Read FClippedEntities;
    Property MapInfo: TEzBaseMapInfo Read FMapInfo;

    Property VGuidelines: TEzDoubleList Read FVGuidelines;
    Property HGuidelines: TEzDoubleList Read FHGuidelines;
    Property ProjectionParams: TStrings Read FProjectionParams;

  Published
    { Published declarations }
    Property Active: Boolean Read FActive Write SetActive;
    Property FileName: String Read FFileName Write SetFileName;
    Property LayersSubdir: String Read FLayersSubdir Write FLayersSubdir;

    Property AutoSetLastView: Boolean Read fAutoSetLastView Write fAutoSetLastView Default True;
    Property ReadOnly: Boolean Read FReadOnly Write FReadOnly Default False;
    Property ShowWaitCursor: Boolean Read FShowWaitCursor Write FShowWaitCursor Default True;

    Property PolygonClipOperation: TEzPolyClipTool Read FPolygonClipOperation Write SetPolygonClipOperation;

    Property FontShadowStyle: TEzFontShadowStyle Read FFontShadowStyle Write FFontShadowStyle Default fssLowerRight;
    Property FontShadowColor: TColor Read FFontShadowColor Write FFontShadowColor Default clSilver;
    Property FontShadowOffset: Integer Read FFontShadowOffset Write FFontShadowOffset Default 1;
    Property TimerFrequency: Cardinal Read FTimerFrequency Write FTimerFrequency Default 200;
    Property PrintTimerFrequency: Integer Read FPrintTimerFrequency Write FPrintTimerFrequency Default 800;

    { events }
    Property OnBeforePaintLayer: TEzBeforePaintLayerEvent Read FOnBeforePaintLayer Write FOnBeforePaintLayer;
    Property OnAfterPaintLayer: TEzAfterPaintLayerEvent Read FOnAfterPaintLayer Write FOnAfterPaintLayer;

    Property OnUDFCheck: TEzUDFCheckEvent Read FOnUDFCheck Write FOnUDFCheck;
    Property OnUDFSolve: TEzUDFSolveEvent Read FOnUDFSolve Write FOnUDFSolve;

    Property OnFileNameChange: TNotifyEvent Read FOnFileNameChange Write FOnFileNameChange;

    Property OnBeforeSymbolPaint: TEzBeforeSymbolPaintEvent Read FOnBeforeSymbolPaint Write FOnBeforeSymbolPaint;
    Property OnBeforeBrushPaint: TEzBeforeBrushPaintEvent Read FOnBeforeBrushPaint Write FOnBeforeBrushPaint;
    Property OnBeforePenPaint: TEzBeforePenPaintEvent Read FOnBeforePenPaint Write FOnBeforePenPaint;
    Property OnBeforeFontPaint: TEzBeforeFontPaintEvent Read FOnBeforeFontPaint Write FOnBeforeFontPaint;
    Property OnBeforePaintEntity: TEzBeforePaintEntityEvent Read FOnBeforePaintEntity Write FOnBeforePaintEntity;
    Property OnAfterPaintEntity: TEzAfterPaintEntityEvent Read FOnAfterPaintEntity Write FOnAfterPaintEntity;

    Property OnProgress: TEzProgressEvent Read FOnProgress Write FOnProgress;
    Property OnShowDirection: TEzShowDirectionEvent Read FOnShowDirection Write FOnShowDirection;

    Property OnBeforeClose: TNotifyEvent Read FOnBeforeClose Write FOnBeforeClose;
    Property OnBeforeOpen: TNotifyEvent Read FOnBeforeOpen Write FOnBeforeOpen;

    Property OnBeforeDeleteLayer: TEzBeforeLayerEvent Read FOnBeforeDeleteLayer Write FOnBeforeDeleteLayer;
    Property OnAfterDeleteLayer: TEzLayerEvent Read FOnAfterDeleteLayer Write FOnAfterDeleteLayer;

    Property OnBeforeInsertLayer: TEzBeforeLayerEvent Read FOnBeforeInsertLayer Write FOnBeforeInsertLayer;
    Property OnAfterInsertLayer: TEzLayerEvent Read FOnAfterInsertLayer Write FOnAfterInsertLayer;

    Property OnQueryResults: TEzQueryResultsEvent Read FOnQueryResults Write FOnQueryResults;

    Property OnVisibleLayerChange: TEzLayerEvent Read FOnVisibleLayerChange Write FOnVisibleLayerChange;
    Property OnSelectableLayerChange: TEzLayerEvent Read FOnSelectableLayerChange Write FOnSelectableLayerChange;
    Property OnCurrentLayerChange: TEzLayerEvent Read FOnCurrentLayerChange Write FOnCurrentLayerChange;

    Property OnModified: TNotifyEvent Read FOnModified Write FOnModified;
    Property OnClippedAreaChanged: TNotifyEvent Read FOnClippedAreaChanged Write FOnClippedAreaChanged;

    Property OnPrintBegin: TNotifyEvent Read FOnPrintBegin Write FOnPrintBegin;
    Property OnPrintProgress: TEzPrintProgressEvent Read FOnPrintProgress Write FOnPrintProgress;
    Property OnPrintEnd: TNotifyEvent Read FOnPrintEnd Write FOnPrintEnd;
    Property OnBeforeTransform: TEzBeforeTransformEvent read FOnBeforeTransform write FOnBeforeTransform;
    Property OnAfterTransform: TEzEntityEvent read FOnAfterTransform write FOnAfterTransform;
    Property OnBeforeDragDrop: TEzEntityAcceptEvent read FOnBeforeDragDrop write FOnBeforeDragDrop;
    Property OnAfterDragDrop: TEzEntityEvent read FOnAfterDragDrop write FOnAfterDragDrop;

    Property OnError: TEzErrorEvent Read FOnError Write FOnError;
    Property OnGisTimer: TEzGisTimerEvent Read FOnGisTimer Write FOnGisTimer;
    Property OnExternalPopulate: TEzExternalPopulateEvent read FOnExternalPopulate write FOnExternalPopulate;
    Property OnStartExternalPopulate: TEzStartExternalPopulateEvent read FOnStartExternalPopulate write FOnStartExternalPopulate;
    Property OnEndExternalPopulate: TEzEndExternalPopulateEvent read FOnEndExternalPopulate write FOnEndExternalPopulate;
    Property OnBeforePaintLayers: TNotifyEvent read FOnBeforePaintLayers write FOnBeforePaintLayers;
    Property OnAfterPaintLayers: TNotifyEvent read FOnAfterPaintLayers write FOnAfterPaintLayers;

  End;

  {-------------------------------------------------------------------------------}
  {                  Selection                                                    }
  {-------------------------------------------------------------------------------}

    { TEzSelectionLayer
      This class is for maintaining the selected entities in a layer}
  TEzSelectionLayer = Class
  Private
    FSelection: TEzSelection; // belongs to
    FLayer: TEzBaseLayer; {the selected layer}
    FSelList: TIntegerList;

    FIsSelectEvent: Boolean;
    FIsUnSelectEvent: Boolean;
    FIsBeforeSelectEvent: Boolean;

  Public
    Constructor Create( Selection: TEzSelection; Layer: TEzBaseLayer );
    Destructor Destroy; Override;
    Procedure Add( RecNo: Integer );
    Procedure Delete( RecNo: Integer );
    Function IsSelected( Recno: Integer ): Boolean;

    Property Layer: TEzBaseLayer Read FLayer Write FLayer;
    Property SelList: TIntegerList Read FSelList;
  End;

  { TEzSelection - Main Selection object. Contains the list of selected layers }

  TEzSelection = Class
  Private
    { List of TEzSelectionLayer where there are entities selected }
    FList: TList;
    FDrawBox: TEzBaseDrawBox; { the DrawBox to what this belongs to }
    FInUpdate: Boolean;
    FNumSelected: Integer;
    Function Get( Index: Integer ): TEzSelectionLayer;
    Function GetCount: Integer;
    Function GetNumSelected: Integer;
    procedure CalcNumSelected;
  Public
    Constructor Create( DrawBox: TEzBaseDrawBox );
    Destructor Destroy; Override;

    Procedure Assign( Source: TEzSelection );
    Procedure Clear;

    Procedure Add( Layer: TEzBaseLayer; RecNo: Integer );
    Procedure Delete( Layer: TEzBaseLayer; RecNo: Integer );
    Procedure AddLayer( Layer: TEzBaseLayer );
    Procedure DeleteLayer( Layer: TEzBaseLayer );

    Function IndexOf( Layer: TEzBaseLayer ): Integer;
    Procedure DeleteSelection;
    Function NumSelectedInLayer( Layer: TEzBaseLayer ): Integer;
    Procedure Toggle( Layer: TEzBaseLayer; RecNo: Integer );

    Function IsSelected( Layer: TEzBaseLayer; RecNo: Integer ): Boolean;
    Procedure RepaintSelectionArea;
    Procedure UnSelectAndRepaint;
    Function GetExtension: TEzRect;
    function ContainsEntityId(EntityIds: TEzEntityIDs; var Num: Integer): Boolean;
    function FirstSelected(var Layer: TEzBaseLayer; var RecNo: Integer): Boolean; overload;
    function FirstSelected: TEzEntity; overload;

    Procedure BeginUpdate;
    Procedure EndUpdate;

    Procedure ApplySymbolStyle( Style: TEzSymbolTool; const Apply: TEzSymbolApply );
    Procedure ApplyPenStyle( Style: TEzPenTool; const Apply: TEzPenApply );
    Procedure ApplyBrushStyle( Style: TEzBrushTool; const Apply: TEzBrushApply );
    Procedure ApplyFontStyle( Style: TEzFontTool; const Apply: TEzFontApply );

    Property Count: Integer Read GetCount;
    Property NumSelected: Integer Read GetNumSelected;
    Property DrawBox: TEzBaseDrawBox Read FDrawBox Write FDrawBox;
    Property InUpdate: Boolean Read FInUpdate Write FInUpdate;
    Property Items[Index: Integer]: TEzSelectionLayer Read Get; Default;
  End;

  {-------------------------------------------------------------------------------}
  {                  Undo object                                                  }
  {-------------------------------------------------------------------------------}

  TEzUndoAction = ( uaUndelete, uaDelete, uaUnTransform );

  { TEzUndoSingle }
  TEzUndoSingle = Class
  Private
    FGlobalUndoAction: TEzUndoAction;
    FLastOffset: Integer;
    FDrawBox: TEzBaseDrawBox;
    FCount: Integer;
    FTempStream: TStream;
    FMustReset: Boolean;
    Function GetUndoStream: TStream;
  Public
    Constructor Create( DrawBox: TEzBaseDrawBox );
    Destructor Destroy; Override;

    Procedure BeginUndo(GlobalUndoAction: TEzUndoAction);
    Procedure AddUndo( Layer: TEzBaseLayer; Recno: Integer;
      UndoAction: TEzUndoAction );
    Procedure EndUndo;

    { mark all entities for copying from the selection }
    { mark all the deleted entities from the selection }
    Procedure AddUnDeleteFromSelection;
    { mark all transformed entities from selection}
    Procedure AddUnTransformFromSelection;
    { mark one entity for transform }
    Procedure AddUnTransform( Layer: TEzBaseLayer; RecNo: Integer );

    Procedure Undo;
    Function GetVerb: String;
  End;

  TEzUndoPool = Class
  Private
    FDrawBox: TEzBaseDrawBox;
    FUndoLimit: Integer;
    FList: TList;
    FMulti: TEzUndoSingle;
    FUndoFileName: string;

    Procedure SetUndoLimit( Value: Integer );
    Procedure AdjustStack;
  Public
    Constructor Create( DrawBox: TEzBaseDrawBox );
    Destructor Destroy; Override;

    Procedure BeginUndo(GlobalUndoAction: TEzUndoAction);
    Procedure AddUndo( Layer: TEzBaseLayer; Recno: Integer;
      Action: TEzUndoAction );
    Procedure EndUndo;
    Procedure Pop;

    { mark all entities for copying from the selection }
    Procedure CopyToClipboardFromSelection;
    { mark all the deleted entities from the selection }
    Procedure AddUnDeleteFromSelection;
    { mark all transformed entities from selection}
    Procedure AddUnTransformFromSelection;
    { mark one entity for transform }
    Procedure AddUnTransform( Layer: TEzBaseLayer; RecNo: Integer );
    Procedure PasteFromClipboardTo(GIS: TEzBaseGIS=Nil);

    Function CanUndo: boolean;
    Function CanPaste: Boolean;
    Procedure Undo;
    Procedure Clear(Clean: Boolean=False);
    Function GetVerb: String;

    Property UndoLimit: Integer Read FUndoLimit Write SetUndoLimit;
  End;

  {-------------------------------------------------------------------------------}
  {                  TEzEntityList                                                }
  {-------------------------------------------------------------------------------}

  TEzEntityList = Class
  Private
    FList: TList;
    FOwnEntities: Boolean;

    Function Get( Index: Integer ): TEzEntity;
    procedure SetOwnEntities(const Value: Boolean);
  Public
    Constructor Create;
    Destructor Destroy; Override;

    Procedure Add( Ent: TEzEntity );
    Procedure Insert( Index: Integer; Ent: TEzEntity );
    Procedure Delete( Index: Integer );
    Procedure Extract( Index: Integer );
    Procedure Exchange( Index1, Index2: Integer );
    Procedure ExtractAll;
    function  IndexOf(Entity: TEzEntity): Integer;

    Function Count: Integer;
    Procedure Clear;

    Property Items[Index: Integer]: TEzEntity Read Get; Default;
    property OwnEntities: Boolean read FOwnEntities write SetOwnEntities;
  End;

  {-------------------------------------------------------------------------------}
  {                  TEzBaseDrawBox                                               }
  {-------------------------------------------------------------------------------}

  { Events definition for TEzBaseDrawBox }

  TEzMouseEvent = Procedure( Sender: TObject; Button: TMouseButton;
    Shift: TShiftState; X, Y: Integer; Const WX, WY: Double ) Of Object;

  TEzMouseMoveEvent = Procedure( Sender: TObject; Shift: TShiftState;
    X, Y: Integer; Const WX, WY: Double ) Of Object;

  TEzZoomChangeEvent = Procedure( Sender: TObject; Const Scale: Double ) Of Object;

  TEzBeforeSelectEvent = Procedure( Sender: TObject; Layer: TEzBaseLayer;
    Recno: Integer; Var CanSelect: Boolean ) Of Object;

  { This event is used for both: when the entity is selected and unselected }
  TEzEntitySelectEvent = Procedure( Sender: TObject; Layer: TEzBaseLayer;
    RecNo: Integer ) Of Object;

  { When an entity is DOUBLE clicked in a TEzBaseDrawBox }
  TEzEntityDblClickEvent = Procedure( Sender: TObject; Layer: TEzBaseLayer;
    RecNo: Integer; Var Processed: Boolean ) Of Object;

  { When an entity is clicked in a TEzBaseDrawBox }
  TEzEntityClickEvent = Procedure( Sender: TObject; Button: TMouseButton;
    Shift: TShiftState; X, Y: Integer; Const WX, WY: Double;
    Layer: TEzBaseLayer; RecNo: Integer; var Processed: Boolean ) Of Object;

  TEzClickEvent = Procedure( Sender: TObject; X, Y: Integer;
    const XWorld, YWorld: Double ) Of Object;

  {-------------------------------------------------------------------------------}
  //             TEzBaseDrawBox - abstract control
  {-------------------------------------------------------------------------------}

  TEzBaseDrawBox = Class( TCustomControl )
  Private
    FGIS: TEzBaseGIS;
    FGrapher: TEzGrapher;
    FScreenBitmap: TBitmap;
    FIsAerial: Boolean;

    FSelection: TEzSelection;
    FUndo: TEzUndoPool;
    FBlinkCount: Integer;
    FBlinkRate: Integer;

    FHMin: Integer;
    FHMax: Integer;
    FHPosition: Integer;
    FVMin: Integer;
    FVMax: Integer;
    FVPosition: Integer;
    FHSmallChange: TScrollBarInc;
    FHLargeChange: TScrollBarInc;
    FVSmallChange: TScrollBarInc;
    FVLargeChange: TScrollBarInc;
    //FPageSize: Integer;
    FScrollBars: TScrollStyle;

    FBorderStyle: TBorderStyle; {border style to use}
    FFlatScrollBar: Boolean;
    FComCtlVersion: Boolean;

    FRubberPen: TPen;
    FOutputDevices: TEzOutputDevices;
    FShowControlPoints: Boolean;
    FShowTransfPoints: Boolean;

    FTempEntities: TEzEntityList; { List used for temporary entities }
    FNeedsRepaint: Boolean;

    FGridInfo: TEzGridInfo;
    FScreenGrid: TEzScreenGrid;
    FShowMapExtents: Boolean;
    FShowLayerExtents: Boolean;

    FSnapToGuidelinesDist: double;
    FSnapToGuidelines: boolean;
    FHideVertexNumber: Boolean;

    FSymbolMarker: Integer;
    FNumDecimals: Integer;
    FNoPickFilter: TEzEntityIDs;
    FStackedSelect: Boolean;
    FPartialSelect: Boolean;
    FDelayShowHint: Integer;
    FTileBitmap: TBitmap;
    FThematicSeriesColors: TEzThematicSeriesColor;
    FUpdateOnScroll: Boolean;
    FDropRepeat: Integer;
    //FOldSize: TPoint;
    FDefaultScaleUnits: TEzScaleUnits;
    FInUpdate: Boolean;
    FInRepaint: Boolean;
    FZoomWithMargins: Boolean;

    { threads }
    FUseThread: Boolean;

    { BASIC event handlers }
    FOnPaint: TNotifyEvent;
    FOnBeginRepaint: TNotifyEvent;
    FOnEndRepaint: TNotifyEvent;
    FOnGridError: TNotifyEvent;
    FOnMouseDown2D: TEzMouseEvent;
    FOnMouseUp2D: TEzMouseEvent;
    FOnMouseMove2D: TEzMouseMoveEvent;

    FOnHScroll: TScrollEvent;
    FOnVScroll: TScrollEvent;
    FOnHChange: TNotifyEvent;
    FOnVChange: TNotifyEvent;
    FOnBeforeScroll: TNotifyEvent;
    FOnAfterScroll: TNotifyEvent;

    { event handlers. }
    FOnCustomClick: TEzClickEvent;
    FOnEntityDblClick: TEzEntityDblClickEvent;
    FOnBeforeInsert: TEzBeforeInsertEvent;

    FOnAfterInsert: TEzEntityEvent;
    FOnBeforeSelect: TEzBeforeSelectEvent;
    FOnAfterSelect: TEzEntitySelectEvent;
    FOnAfterUnSelect: TEzEntitySelectEvent;

    FOnZoomChange: TEzZoomChangeEvent;
    FOnEntityChanged: TEzEntityEvent;
    FOnShowHint: TEzShowHintEvent;

    FOnSelectionChanged: TNotifyEvent;
    FOnGisChanged: TNotifyEvent;
    FOnMouseLeave: TNotifyEvent;
    FOnMouseEnter: TNotifyEvent;
    FAutoScroll: Boolean;

    { basic procedures }
    Procedure CalcScrollBarDeltas( var DeltaX, DeltaY: Integer );
    Procedure SetBorderStyle( Const Value: forms.TBorderStyle );
    Procedure SetScrollBars( Value: TScrollStyle );

    Procedure WMHScroll( Var Msg: TWMHScroll ); Message WM_HSCROLL;
    Procedure WMVScroll( Var Msg: TWMVScroll ); Message WM_VSCROLL;
    Procedure CMCtl3DChanged( Var m: TMessage ); Message CM_CTL3DCHANGED;
    Procedure WMEraseBkgnd( Var m: TWMEraseBkgnd ); Message WM_ERASEBKGND;

    Procedure SetFlatScrollBar( Value: Boolean );
    Procedure SetGridInfo( value: TEzGridInfo );
    Procedure SetScreenGrid( value: TEzScreenGrid );
    Procedure SetShowLayerExtents( value: boolean );
    Procedure SetShowMapExtents( value: boolean );

    { GIS specific procedures }
    Procedure SetHParams( APosition, AMin, AMax: Integer );
    Procedure SetVParams( APosition, AMin, AMax: Integer );
    Procedure SetPageSize( Value: Integer );
    procedure CMMouseEnter (var Msg: TMessage); message CM_MOUSEENTER;
    procedure CMMouseLeave (var Msg: TMessage); message CM_MOUSELEAVE;

  Protected

    { protected declarations }
    Procedure ViewChanged( Sender: TObject ); Dynamic;
    Procedure HChange; Dynamic;
    Procedure VChange; Dynamic;
    Procedure CreateWnd; Override;
    Procedure HScroll( ScrollCode: TScrollCode; Var ScrollPos: Integer ); Dynamic;
    Procedure VScroll( ScrollCode: TScrollCode; Var ScrollPos: Integer ); Dynamic;

    Procedure Paint; Override;

    function IsAutoScrollEnabled: boolean;

    Procedure MouseMove( Shift: TShiftState; X, Y: Integer ); Override;
    Procedure MouseDown( Button: TMouseButton; Shift: TShiftState; X, Y: Integer ); Override;
    Procedure MouseUp( Button: TMouseButton; Shift: TShiftState; X, Y: Integer ); Override;

    { repaint all the objects contained in WCRect. }
    Procedure UpdateViewport( WCRect: TEzRect ); Virtual;
    Procedure DrawGrid( Const WCRect: TEzRect );
    Function IsDesigning: Boolean;

    { GIS specific }
    Procedure SetGIS( Value: TEzBaseGIS );
    Procedure Notification( AComponent: TComponent; Operation: TOperation ); Override;
    Function GetLayerByName( Const LayerName: String ): TEzBaseLayer;

    procedure Click; override;
  Public
    { public declarations }
    Constructor Create( AOwner: TComponent ); Override;
    Destructor Destroy; Override;

    Procedure Resize; Override;
    Procedure CreateParams( Var Params: TCreateParams ); Override;

    Procedure BeginRepaint; Dynamic;
    Procedure EndRepaint; Dynamic;
    Procedure ClearCanvas( Canvas: TCanvas; ARect: TRect; BackCol: TColor );
    Procedure ReSync;
    Procedure DrawEntity( Ent: TEzEntity; DrawMode: TEzDrawMode = dmNormal );
    Procedure DrawEntity2D( Ent: TEzEntity; CtrlPts: Boolean; DrawMode: TEzDrawMode = dmNormal );
    Procedure DrawEntityRubberBand( Ent: TEzEntity );
    Procedure DrawEntity2DRubberBand( Entity: TEzEntity; CtrlPts: Boolean = False; TransfPts: Boolean=False );
    Procedure DrawControlPointsWithRubber( Ent: TEzEntity );

    Procedure ZoomWindow( Const NewWindow: TEzRect );
    Procedure MoveWindow( Const NewStartX, NewStartY: Double );
    Procedure DoCopyCanvas;

    Procedure ZoomIn(percent:byte);
    Procedure ZoomOut(percent:byte);
    Procedure ZoomPrevious;

    Procedure ClearViewsHistory;
    Procedure Panning( Const DeltaX, DeltaY: Double );
    Procedure RegenDrawing;
    Procedure AddMarker( Const X, Y: Double; SetInView: Boolean );

    Procedure DrawCross( Canvas: TCanvas; pt: TPoint );
    Procedure Repaint; Override;
    Procedure Refresh;
    Procedure RepaintRect( Const WCRect: TEzRect );

    Procedure RefreshRect( Const WCRect: TEzRect );
    Procedure DrawBoxToWorld( X, Y: Integer; Var WX, WY: Double );
    Procedure WorldToDrawBox( Const WX, WY: Double; Var X, Y: Integer );
    Procedure BeginUpdate;
    Procedure CancelUpdate;
    Procedure EndUpdate;
    Procedure ForceEndUpdate;
    Function AddEntity( Const Layername: String; Entity: TEzEntity ): Integer;
    Function AddEntityFromText( Const LayerName, EntityText: String ): Integer;

    Function CreateEntityFromText( Const EntityText: String ): TEzEntity;

    procedure ZoomOnPoint(const WX, WY, ZoomPercent: Double; const IsZoomIn: Boolean);
    Procedure ZoomToExtension;
    Procedure ZoomToLayerRef( Const LayerName: String );
    Function PickEntity( Const X, Y: Double; Aperture: Integer; Const LayerName: String;
      Var NLayer: TEzBaseLayer; Var NRecNo, NPoint: Integer;
      List: TStrings ): Boolean;

    Procedure ZoomToSelection;
    Procedure ZoomToScale( Const Scale: Double; ScaleUnits: TEzScaleUnits );
    Procedure ZoomToHorzDistance( Const Distance: Double );

    Procedure ScaleToHorzDistance( Const Scale: Double; ScaleUnits: TEzScaleUnits;
      Var HorzDistance: Double );
    Procedure HorzDistanceToScale( Const HorzDistance: Double; Var Scale: Double;
      ScaleUnits: TEzScaleUnits );

    Procedure DeleteSelection;
    function JoinSelection( DeleteOriginals: Boolean ): Integer;
    Procedure ExplodeSelection( PreserveOriginals: Boolean );

    Procedure BlinkEntity( Entity: TEzEntity );
    Procedure BlinkEntityEx( Const LayerName: String; RecNo: Integer );
    { this method will blink all the entities defines in TEzBaseLayer.Blinkers and
      in all layers }
    Procedure BlinkEntities;

    // to simulate GPS like movement on symbols
    Procedure MovePlace( Const LayerName: String; RecNo: Integer;
      Const NewX, NewY: Double );

    Procedure SelectionChangeDirection;

    Procedure SaveAsBMP( Const FileName: String );
{$IFDEF JPEG_SUPPORT}
    Procedure SaveAsJPG( Const FileName: String );
{$ENDIF}
{$IFDEF GIF_SUPPORT}
    Procedure SaveAsGIF( Const FileName: String );
{$ENDIF}
    Procedure SaveAsEMF( Const FileName: String );
{$IFDEF TRIAL_VERSION}
    Procedure DrawTrialBanner;
{$ENDIF}
    Procedure CopyToClipboardAsBMP;
    Procedure CopyToClipboardAsEMF;

    Procedure SetEntityInView( Entity: TEzEntity; UseExtents: Boolean );
    Procedure SetEntityInViewEx( Const LayerName: String;
      Recno: Integer; UseExtents: Boolean );
    Procedure SelectAll;
    Procedure UnSelectAll;

    Procedure SendToBack;
    Procedure BringToFront;

    Procedure SelectionToPolygon;
    Procedure SelectionToPolyline;

    Procedure GroupSelection;
    Procedure UnGroupSelection;

    Procedure CurrentExtents(var AXMin, AYMin, AXMax, AYMax: Double);
    Procedure SetViewTo(const AXMin, AYMin, AXMax, AYMax: Double); overload;
    Procedure SetViewTo(const aRect: TEzRect); overload;
    Function PointRelate( Entity: TEzEntity; Aperture: Integer;
      Const X, Y: Double ): Integer;

    { the select methods }
    Procedure ExpressionSelect( Const Layername, Expression: String );

    Procedure RectangleSelect( Const AxMin, AyMin, AxMax, AyMax: double;
      Const Layername, QueryExpression: String; aOperator: TEzGraphicOperator );

    Procedure BufferSelect( Polyline: TEzEntity;
      Const Layername, QueryExpression: String; aOperator: TEzGraphicOperator;
      CurvePoints: Integer; Const Distance: Double );

    Procedure PolygonSelect( Polygon: TEzEntity;
      Const Layername, QueryExpression: String; aOperator: TEzGraphicOperator );

    Procedure PolylineSelect( Polyline: TEzEntity;
      Const Layername, QueryExpression: String );

    { add entities section }
    Function CreateEntity( EntType: TEzEntityID ): TEzEntity;
    Procedure BlinkThis( Const X, Y: Double );
    Procedure DoSelectLayer( Layer: TEzBaseLayer; Var Canceled: Boolean );
    Function GetCurrentOneSelectedEntity( Var LayerName: String; Var Recno: Integer ): TEzEntity;

    Procedure DrawPie( Const Drawlayer, FieldName: String );

    Procedure CreatePieThematic( Const LayerName, FieldNames: String;
      Fill: Boolean; Radian: Double; StartColor: Integer );

    Procedure CreateBarThematic( Const LayerName, FieldNames: String;
      Fill: Boolean; Width, Height: Double; StartColor: Integer );

    Procedure CreateDotThematic( Const Layername, FieldName: String;
      Fill: Boolean; DotRange: Double; Dotsize, DotColor: Integer );

    Procedure CreateSymbolThematic( Const Layername, FieldName: String;
      SymbolSize, SymbolIndex: Integer );

    Procedure FitSelectionToPath( AdjustTextWidth: Boolean );

    Function CoordsToDisplayText( Const AX, AY: Double ): String;
    Function CoordsToDisplaySuffix( Const AX, AY: Double ): String;

    { returns true if point inside Entity  }
    Function PointInPolygon( Entity: TEzEntity; Const X, Y: Double ): Boolean;

    Procedure SetClipBoundaryFromSelection;
    Procedure SaveClippedAreaTo( NewGis: TEzBaseGIS );
    Procedure CreateThumbNail(Bitmap: TBitmap);
    Procedure ClipPolylineAgainstPolygon;
    Procedure CreateBlockFromSelection(const BlockName: string);
    Procedure ARRAYFromSelection( Rows, Columns: Integer;
      const XOffset, YOffset: Double );
    { delete repeated entities :
      - if LayerName = "", search on all layers or the layer defined
      - if EntityID = idNone, all the entities or the entity type defined }
    Procedure DeleteRepetitions( const LayerName: string;
      EntityID: TEzEntityID; IncludeAttribs: Boolean; SearchAllLayers: Boolean );
    { repeat the selected entities at position Wx,Wy TEzBaseDrawBox.DropRepeat times}
    Procedure DropSelectionAt( const Wx, Wy: Double );
    { This method will find the closest entity that is near point WX, WY
      - if ShapeType =[] then any kind of entity will be accepted
      - if ShapeType in [idNone, idPoint, idPlace, idPolyline, ... ] then
        the closest entity of that type will be accepted
      - If LayerName <> '' then only that layer will be searched, otherwise,
        all layers will be considered
      - Scope is any additionaly expression that can be added like
        STATE_NAME IN ("Washington", "Ohio")

      The method will return in LayerName and Recno the found entity.
      If LayerName = '' and/or Recno = 0 then no entity was found
    }
    Function FindClosestEntity( const WX, WY: Double; const Scope: string;
      const ShapeType: TEzEntityIDs; Var LayerName: string; Var Recno: Integer ): Boolean;

    { threads }
    Procedure DoFullPainting(const WCRect: TEzRect; Canvas: TCanvas;
      Grapher: TEzGrapher );
    Procedure StopPaintingThread;
    Procedure WaitForPaintingThread;
    Procedure ThreadDone;

    { basic properties }
    Property Canvas;
    Property Grapher: TEzGrapher Read FGrapher;
    Property ScreenBitmap: TBitmap Read FScreenBitmap;
    Property OutputDevices: TEzOutputDevices Read FOutputDevices Write FOutputDevices Default [odBitmap];
    Property TempEntities: TEzEntityList Read FTempEntities;

    Property ShowControlPoints: Boolean Read FShowControlPoints Write FShowControlPoints Default False;
    Property ShowTransfPoints: Boolean Read FShowTransfPoints Write FShowTransfPoints Default False;

    { drawbox specific properties }
    Property GIS: TEzBaseGIS Read FGIS Write SetGIS;
    Property Selection: TEzSelection Read FSelection;
    Property IsAerial: Boolean Read FIsAerial Write FIsAerial;
    Property Undo: TEzUndoPool Read FUndo;
    Property TileBitmap: TBitmap Read FTileBitmap Write FTileBitmap;

    Property ThematicSeriesColors: TEzThematicSeriesColor Read FThematicSeriesColors;

    { properties to be published in descendants }
    Property DropRepeat: Integer Read FDropRepeat Write FDropRepeat Default 1;
    Property NumDecimals: Integer Read FNumDecimals Write FNumDecimals Default 3;
    Property DelayShowHint: Integer Read FDelayShowHint Write FDelayShowHint Default 200;
    Property PartialSelect: Boolean Read FPartialSelect Write FPartialSelect Default False;
    Property StackedSelect: Boolean Read FStackedSelect Write FStackedSelect Default True;
    Property NoPickFilter: TEzEntityIDs Read FNoPickFilter Write FNoPickFilter;
    Property SymbolMarker: Integer Read FSymbolMarker Write FSymbolMarker Default 0;

    Property SnapToGuidelines: Boolean Read FSnapToGuidelines Write FSnapToGuidelines Default False;
    Property SnapToGuidelinesDist: Double Read FSnapToGuidelinesDist Write FSnapToGuidelinesDist;

    Property ScreenGrid: TEzScreenGrid Read FScreenGrid Write SetScreenGrid;
    Property ShowMapExtents: Boolean Read FShowMapExtents Write SetShowMapExtents;

    Property ShowLayerExtents: Boolean Read FShowLayerExtents Write SetShowLayerExtents;

    Property GridInfo: TEzGridInfo Read FGridInfo Write SetGridInfo;
    Property RubberPen: TPen Read FRubberPen Write FRubberPen;
    Property ScrollBars: TScrollStyle Read fScrollBars Write SetScrollBars Default ssBoth;
    Property FlatScrollBar: Boolean Read FFlatScrollBar Write SetFlatScrollBar;
    Property BlinkCount: Integer Read FBlinkCount Write FBlinkCount Default 3;
    Property BlinkRate: Integer Read FBlinkRate Write FBlinkRate Default 100;
    Property DefaultScaleUnits: TEzScaleUnits read FDefaultScaleUnits write FDefaultScaleUnits;

    Property InUpdate: Boolean Read FInUpdate Write FInUpdate;
    Property InRepaint: Boolean Read FInRepaint Write FInRepaint;
    Property ZoomWithMargins: Boolean Read FZoomWithMargins Write FZoomWithMargins;

    { events to be published in descendants }
    Property OnGridError: TNotifyEvent Read FOnGridError Write FOnGridError;
    Property OnHScroll: TScrollEvent Read fOnHScroll Write fOnHScroll;
    Property OnVScroll: TScrollEvent Read fOnVScroll Write fOnVScroll;
    Property OnHChange: TNotifyEvent Read fOnHChange Write fOnHChange;
    Property OnVChange: TNotifyEvent Read fOnVChange Write fOnVChange;
    Property OnBeforeScroll: TNotifyEvent Read FOnBeforeScroll Write FOnBeforeScroll;
    Property OnAfterScroll: TNotifyEvent Read FOnAfterScroll Write FOnAfterScroll;

    Property OnBeginRepaint: TNotifyEvent Read FOnBeginRepaint Write FOnBeginRepaint;
    Property OnEndRepaint: TNotifyEvent Read FOnEndRepaint Write FOnEndRepaint;
    Property OnMouseMove2D: TEzMouseMoveEvent Read FOnMouseMove2D Write FOnMouseMove2D;
    Property OnMouseDown2D: TEzMouseEvent Read FOnMouseDown2D Write FOnMouseDown2D;
    Property OnMouseUp2D: TEzMouseEvent Read FOnMouseUp2D Write FOnMouseUp2D;

    Property OnPaint: TNotifyEvent Read FOnPaint Write FOnPaint;

    { drawbox specific events }
    Property OnEntityDblClick: TEzEntityDblClickEvent Read FOnEntityDblClick Write FOnEntityDblClick;
    Property OnBeforeInsert: TEzBeforeInsertEvent Read FOnBeforeInsert Write FOnBeforeInsert;
    Property OnAfterInsert: TEzEntityEvent Read FOnAfterInsert Write FOnAfterInsert;
    Property OnBeforeSelect: TEzBeforeSelectEvent Read FOnBeforeSelect Write FOnBeforeSelect;
    Property OnAfterSelect: TEzEntitySelectEvent Read FOnAfterSelect Write FOnAfterSelect;
    Property OnAfterUnSelect: TEzEntitySelectEvent Read FOnAfterUnSelect Write FOnAfterUnSelect;
    Property OnZoomChange: TEzZoomChangeEvent Read FOnZoomChange Write FOnZoomChange;
    Property OnEntityChanged: TEzEntityEvent Read FOnEntityChanged Write FOnEntityChanged;
    Property OnShowHint: TEzShowHintEvent Read FOnShowHint Write FOnShowHint;

    Property OnSelectionChanged: TNotifyEvent Read FOnSelectionChanged Write FOnSelectionChanged;

    Property OnCustomClick: TEzClickEvent Read FOnCustomClick Write FOnCustomClick;
    Property OnGisChanged: TNotifyEvent read FOnGisChanged write FOnGisChanged;
    Property OnMouseLeave: TNotifyEvent read FOnMouseLeave write FOnMouseLeave;
    Property OnMouseEnter: TNotifyEvent read FOnMouseEnter write FOnMouseEnter;

    property AutoScroll: Boolean read FAutoScroll write FAutoScroll default False;
  Published
    { published declarations }

    Property HideVertexNumber: Boolean read FHideVertexNumber write FHideVertexNumber default False;
    Property UpdateOnScroll: Boolean read FUpdateOnScroll write FUpdateOnScroll default False;
    Property BorderStyle: TBorderStyle Read fBorderStyle Write SetBorderStyle Default bsSingle;
    Property UseThread: Boolean read FUseThread write FUseThread;

    Property Height Default 100;
    Property Width Default 100;
    {inherited properties}
    Property Align;
    Property Color;
    Property Ctl3D;
    Property DragCursor;
    Property Enabled;
    Property ParentShowHint;
    Property PopupMenu;
    property ShowHint;
    Property TabOrder;
    Property TabStop Default True;
    Property Visible;

    {inherited events}
    Property OnClick;
    Property OnDblClick;
    Property OnDragDrop;
    Property OnDragOver;
    Property OnStartDrag;
    Property OnEndDrag;
    Property OnEnter;
    Property OnExit;
    Property OnKeyDown;
    Property OnKeyPress;
    Property OnKeyUp;
    Property OnMouseDown;
    Property OnMouseMove;
    Property OnMouseUp;
    Property OnResize;
    property OnMouseWheel;
    property OnMouseWheelDown;
    property OnMouseWheelUp;

  End;

{----------------------------------------------------------------------------}
//         TEzPainterThread
{----------------------------------------------------------------------------}

  TEzPainterThread = Class(TThread)
  Private
    FPainterObject: TEzPainterObject;
    WCRect: TEzRect;
    DrawBox: TEzBaseDrawBox;
    ShowAnimationLayers: Boolean;
    PrintMode: TEzPrintMode;
    procedure DoUpdate;
  Public
    { this has the same parameters as DrawEntities below }
    constructor Create(WhenDone: TNotifyEvent;
      aWCRect: TEzRect; aDrawBox: TEzBaseDrawBox;
      aShowAnimationLayers: Boolean; aPrintMode: TEzPrintMode );
    Destructor Destroy; Override;
    Procedure Execute; Override;

    property PainterObject: TEzPainterObject read FPainterObject;

    property Terminated;
  End;

 {----------------------------------------------------------------------------}
 {         TEzPainterObject class used for drawing entities on any device    }
 {----------------------------------------------------------------------------}

  TEzPainterObject = Class
  Private
    FSourceGis: TEzBaseGIS;
    { this is initialized when the painting is in a thread }
    FThread: TEzPainterThread;
    { these are used when the painting is not in a thread }
    FTickStart: DWord;
    FIsTimer: Boolean;
    FAllPainted: Boolean;
    FWasUpdated: Boolean;
  Public
    Constructor Create( Thread: TEzPainterThread );
    Procedure DrawEntities( WCRect: TEzRect;
                            AGis: TEzBaseGIS;
                            Canvas: TCanvas;
                            Grapher: TEzGrapher;
                            Selection: TEzSelection;
                            IsAerial: Boolean;
                            ShowAnimationLayers: Boolean;
                            PrintMode: TEzPrintMode;
                            BufferBitmap: TBitmap );
    Property AllPainted: Boolean read FAllPainted;
    Property TickStart: DWord Read FTickStart Write FTickStart;
    Property IsTimer: Boolean Read FIsTimer Write FIsTimer;
    Property SourceGis: TEzBaseGIS Read FSourceGis Write FSourceGis;
    Property WasUpdated: Boolean read FWasUpdated;
    Property Thread: TEzPainterThread read FThread;
  End;

{ other procedures }
Function GetClassFromID( EntityID: TEzEntityID ): TEzEntityClass;
//function GetIDFromClass(EntityClass: TClass): TEzEntityID;

var
  { this is for connecting to any desktop database }
  BaseTableClass: TEzBaseTableClass = Nil;

Implementation

Uses
  Math, Clipbrd, Consts, CommCtrl, Printers, TypInfo, EzImpl, EzSystem,
  EzConsts, Ezpolyclip, EzEntities, ezdims, EzScryacc, EzScrlex, EzBasicCtrls,
  EzMiscelEntities, ezgraphics, EzNetwork
{$IFDEF ER_MAPPER}
  , EzERMapper,
{$ENDIF}
  uLtAdditionalEntities;

  {-------------------------------------------------------------------------------}
  {                  Miscellaneous procedures and data used                       }
  {-------------------------------------------------------------------------------}
Const
  CtrlStyle = [csAcceptsControls, csClickEvents, csCaptureMouse, csOpaque,
    csDoubleClicks];

{ CheckComctlVersion }

Function CheckComctlVersion: Boolean;
Var
  hInst: THandle;
Begin
  hInst := LoadLibrary( 'comctl32.dll' );
  If hInst < 32 Then
    Result := False
  Else
    //only the new version of comctl32.dll has this function
    Result := GetProcAddress( hInst, 'DllGetVersion' ) <> Nil;
  FreeLibrary( hInst );
End;

{ TRIAL-VERSION stuff }

{$IFDEF TRIAL_VERSION}
Const
  //MAX_HOURS = 80;
  MAX_DAYS = 90;

Resourcestring
  SHiddenFile = 'LAKKJ.DLL';
  STimeExpired = 'Demo time of these Software has expired !';
  SDemoVersion =
    'You are using a demonstration version of these components' + CrLf +
    'This message is only displayed on the demo version' + CrLf +
    'of this software. To register, contact us at:' + CrLf +
{$IFDEF CYBERMAPS}
    'http://www.pendiente.com' + CrLf +
{$ELSE}
    'http://www.ezgis.com' + CrLf +
{$ENDIF}
    'Expiration Date : ';

Type
  TSecurityFileRec = Record
    MagicNumber: LongInt;
    Seconds: DWORD;
    Runs: DWORD;
    LastCheck: DWORD;
    InstallDate: TDateTime;
  End;

Const
  MAGIC_NUMBER = DWORD( 080504 ); {08=LA, 05=K, 04=KJ}

Var
  GisInstances: Integer;
  SecurityFile: String; { Security File }

Function BuildSecurityFile: boolean;
Var
  IO: TFileStream;
  SecFileRec: TSecurityFileRec;
  I: Integer;
  R: TDateTime;
Begin
  IO := TFileStream.Create( SecurityFile, fmCreate );
  Try
    FillChar( SecFileRec, sizeof( SecFileRec ), 0 );
    SecFileRec.MagicNumber := MAGIC_NUMBER;
    SecFileRec.InstallDate:= Now;
    IO.Write( SecFileRec, sizeof( SecFileRec ) );
    { write random data }
    For I := 1 To 1500 Do
    Begin
      R := Random;
      IO.Write( R, sizeof( double ) );
    End;
    result := true;
  Finally
    IO.free;
  End;
End;

Var
  TimeStart: DWORD;

Function SecurityStartProgram: boolean;
Var
  IO: TFileStream;
  SecFileRec: TSecurityFileRec;
Begin
  result := false;
  If Not FileExists( SecurityFile ) Then Exit;
  IO := TFileStream.Create( SecurityFile, fmOpenRead Or fmShareDenyNone );
  Try
    IO.Read( SecFileRec, sizeof( SecFileRec ) );
    If SecFileRec.MagicNumber <> Longint(MAGIC_NUMBER) Then exit;
    TimeStart := GetTickCount;
    result := true;
  Finally
    IO.Free;
  End;
End;

Function SecurityEndProgram: boolean;
Var
  IO: TFileStream;
  SecFileRec: TSecurityFileRec;
  TimeEnd: DWORD;
  Secsused: DWORD;
Begin
  Result := false;
  If Not FileExists( SecurityFile ) Then Exit;
  IO := TFileStream.Create( SecurityFile, fmOpenReadWrite Or fmShareDenyNone );
  Try
    IO.Read( SecFileRec, sizeof( SecFileRec ) );
    If SecFileRec.MagicNumber <> Longint(MAGIC_NUMBER) Then
      exit;
    TimeEnd := GetTickCount;
    SecsUsed := ( TimeEnd - TimeStart ) Div 1000;
    With SecFileRec Do
    Begin
      Inc( Seconds, SecsUsed );
      Inc( Runs );
    End;
    IO.Seek( 0, 0 );
    IO.Write( SecFileRec, sizeof( SecFileRec ) );
    result := true;
  Finally
    IO.free;
  End;
End;

Procedure SecurityDemoTimeUsed( Var Seconds, LastCheck, Runs: DWORD;
  var InstallDate: TDateTime );
Var
  IO: TFileStream;
  SecFileRec: TSecurityFileRec;
Begin
  If Not FileExists( SecurityFile ) Then exit;
  IO := TFileStream.Create( SecurityFile, fmOpenRead Or fmShareDenyNone );
  Try
    IO.Read( SecFileRec, sizeof( SecFileRec ) );
    If SecFileRec.MagicNumber <> Longint(MAGIC_NUMBER) Then exit;
    Seconds := SecFileRec.Seconds;
    Runs := SecFileRec.Runs;
    LastCheck := SecFileRec.LastCheck;
    InstallDate:= SecFileRec.InstallDate;
  Finally
    IO.Free;
  End;
End;

Function SecurityCheckIfValid( ShowWarning: Boolean ): Boolean;
Var
  Buffer: PChar;
  SystemDir: String;
  //HoursUsed,
  Runs, SecondsUsed, LastCheck: DWORD;
  Stream: TFileStream;
  SecFileRec: TSecurityFileRec;
  InstallDate, FinishDate: TDateTime;
Begin
  Result := false;
  Buffer := StrAlloc( 255 );
  Try
    GetSystemDirectory( Buffer, 255 );
    SystemDir := AddSlash( StrPas( Buffer ) );
  Finally
    StrDispose( Buffer );
  End;
  SecurityFile := SystemDir + SHiddenFile;

  If Not FileExists( SecurityFile ) And Not BuildSecurityFile Then Exit;

  SecurityDemoTimeUsed( SecondsUsed, LastCheck, Runs, InstallDate );
  //HoursUsed := ( SecondsUsed Div 3600 );
  FinishDate:= InstallDate + MAX_DAYS;
  If ShowWarning And (Now >= FinishDate) Then //( HoursUsed >= MAX_HOURS ) And  Then
  Begin
    Application.MessageBox( PChar( STimeExpired ), pchar( smsgwarning ),
      MB_OK Or MB_ICONWARNING );
    Exit;
  End;
  { show demo version window }
  If ShowWarning Then
  Begin
    If ( SecondsUsed - LastCheck ) >= ( 10 * 60 ) Then // check every n minutes
    Begin
      Application.MessageBox( PChar( SDemoVersion + FormatDateTime('mmm/dd/yyyy', FinishDate ) ),
        PChar( smsgwarning ), MB_OK Or MB_ICONWARNING );

      Stream := TFileStream.create( SecurityFile, fmOpenReadWrite Or fmShareDenyNone );
      Try
        Stream.Read( SecFileRec, sizeof( SecFileRec ) );
        SecFileRec.LastCheck := SecondsUsed;
        Stream.Seek( 0, 0 );
        Stream.Write( SecFileRec, sizeof( SecFileRec ) );
      Finally
        Stream.Free;
      End;
    End;
  End;
  { mark the start of use of this software }
  If SecurityStartProgram = false Then Exit;
  Result := true;
End;

{$ENDIF}

{------------------------------------------------------------------------------}
//                  TEzEntityList
{------------------------------------------------------------------------------}

Constructor TEzEntityList.Create;
Begin
  Inherited Create;
  FList := TList.create;
  FOwnEntities := True;
End;

Destructor TEzEntityList.Destroy;
Begin
  Clear;
  FList.free;
  Inherited Destroy;
End;

Procedure TEzEntityList.ExtractAll;
Begin
  FList.Clear;
End;

Function TEzEntityList.Count: Integer;
Begin
  result := FList.Count;
End;

Function TEzEntityList.Get( Index: Integer ): TEzEntity;
Begin
  result := Nil;
  If ( Index < 0 ) Or ( Index > FList.Count - 1 ) Then Exit;
  result := FList[Index];
End;

Procedure TEzEntityList.Add( Ent: TEzEntity );
Begin
  FList.Add( Ent );
End;

function TEzEntityList.IndexOf(Entity: TEzEntity): Integer;
begin
  Result := FList.IndexOf(Entity);
end;

Procedure TEzEntityList.Insert( Index: Integer; Ent: TEzEntity );
Begin
  FList.Insert( Index, Ent );
End;

procedure TEzEntityList.SetOwnEntities(const Value: Boolean);
begin
  FOwnEntities := Value;
end;

Procedure TEzEntityList.Delete( Index: Integer );
Begin
  TEzEntity( FList[Index] ).Free;
  FList.Delete( Index );
End;

Procedure TEzEntityList.Extract( Index: Integer );
Begin
  FList.Delete( Index );
End;

Procedure TEzEntityList.Exchange( Index1, Index2: Integer );
Begin
  FList.Exchange( Index1, Index2 );
End;

Procedure TEzEntityList.Clear;
Var
  I: Integer;
Begin
  if FOwnEntities then
  begin
    For I := 0 To FList.Count - 1 Do
      TEzEntity( FList[I] ).Free;
  end;
  FList.Clear;
End;

{-------------------------------------------------------------------------------}
{                  Layers and auxiliary classes                                 }
{-------------------------------------------------------------------------------}

{ TEzBaseLayerInfo - class implementation }

Constructor TEzBaseLayerInfo.Create( Layer: TEzBaseLayer );
Begin
  Inherited Create;
  FLayer := Layer;
End;

procedure TEzBaseLayerInfo.Assign(Source: TEzBaseLayerInfo);
begin
  Extension:= Source.Extension;
  UseAttachedDB:= Source.UseAttachedDB;
  IsCosmethic:= Source.IsCosmethic;
  IsAnimationLayer:= Source.IsAnimationLayer;
  IsIndexed:= Source.IsIndexed;
  CoordsUnits:= Source.CoordsUnits;
  CoordSystem:= Source.CoordSystem;
  Visible:= Source.Visible;
  Selectable:= Source.Selectable;
  TextHasShadow:= Source.TextHasShadow;
  TextFixedSize:= Source.TextFixedSize;
  OverlappedTextAction:= Source.OverlappedTextAction;
  OverlappedTextColor:= Source.OverlappedTextColor;
  Locked:= Source.Locked;
end;

Function TEzBaseLayerInfo.GetLocked: Boolean;
Begin
  Result:= False;
End;

Procedure TEzBaseLayerInfo.SetLocked( Value: Boolean );
Begin
End;

Function TEzBaseLayerInfo.GetUseAttachedDB: boolean;
Begin
  result := true; // default for C/S version
End;

Procedure TEzBaseLayerInfo.SetUseAttachedDB( Value: boolean );
Begin
End;

Procedure TEzBaseLayerInfo.SetVisible( Value: boolean );
Var
  I: Integer;
Begin
  If FLayer = Nil Then
    exit;
  With FLayer.Layers.GIS Do
  Begin
    For I := 0 To FDrawBoxList.Count - 1 Do
      FDrawBoxList[I].Selection.DeleteLayer( FLayer );
  End;
End;

Procedure TEzBaseLayerInfo.SetSelectable( Value: boolean );
Var
  I: Integer;
Begin
  If FLayer = Nil Then
    exit;
  With FLayer.Layers.GIS Do
  Begin
    For I := 0 To FDrawBoxList.Count - 1 Do
      FDrawBoxList[I].Selection.DeleteLayer( FLayer );
  End;
End;

{ TEzBaseLayer - class implementation }

Constructor TEzBaseLayer.Create( Layers: TEzBaseLayers; Const FileName: String );
Begin
  Inherited Create;
  FLayers := Layers;
  FCoordMultiplier := 1;
  If ( Length( FileName ) > 0 ) And ( Layers <> Nil ) And
    ( Layers.IndexOfName( ExtractFileName( FileName ) ) < 0 ) Then
    Layers.FItems.Add( Self );
End;

Destructor TEzBaseLayer.Destroy;
Begin
  If FLayers <> Nil Then
  Begin
    If Assigned( FLayers.GIS.OnAfterDeleteLayer ) Then
      FLayers.GIS.OnAfterDeleteLayer( FLayers, FName );
    FLayers.FItems.Remove( Self );
  End;
  Close;
  FLayerInfo.Free;
  If FBlinkers <> Nil then
    FreeAndNil( FBlinkers );
  Inherited Destroy;
End;

function TEzBaseLayer.HasBlinkers: Boolean;
begin
  Result:= (FBlinkers <> Nil ) And (FBlinkers.Count > 0);
end;

Procedure TEzBaseLayer.ClearBlinkers;
Begin
  FreeAndNil( FBlinkers );
End;

function TEzBaseLayer.GetBlinkers: TIntegerList;
begin
  If FBlinkers = Nil Then
    FBlinkers:= TIntegerList.Create;
  Result:= FBlinkers;
end;

Function TEzBaseLayer.IsCurrent: Boolean;
begin
  Result:= False;
  if FLayers = Nil then Exit;
  Result:= AnsiCompareText(FLayers.GIS.MapInfo.CurrentLayer, FName) = 0;
end;

Procedure TEzBaseLayer.SetFileName( Const Value: String );
Begin
  FFileName := ChangeFileExt( Value, '' );
  FName := ExtractFileName( Value );
End;

procedure TEzBaseLayer.SetMaxScale(const Value: Double);
begin
  FMaxScale := Value;
end;

procedure TEzBaseLayer.SetMinScale(const Value: Double);
begin
  FMinScale := Value;
end;

Function TEzBaseLayer.IsClientServer: Boolean;
Begin
  result := False;
End;

Function TEzBaseLayer.DeleteLayerFiles: Boolean;
begin
  Result:= true;
end;

Procedure TEzBaseLayer.CancelScope;
Begin
  CancelFilter;
End;

Procedure TEzBaseLayer.GetFieldList( Strings: TStrings );
Begin
  // nothing to do
End;

Procedure TEzBaseLayer.Synchronize;
begin
  // nothing to do
end;

Procedure TEzBaseLayer.StartBatchInsert;
Begin
End;

Procedure TEzBaseLayer.CancelBatchInsert;
Begin
End;

Procedure TEzBaseLayer.FinishBatchInsert;
Begin
End;

Procedure TEzBaseLayer.StartBuffering;
Begin
  // nothing to do here
End;

Procedure TEzBaseLayer.EndBuffering;
Begin
  // nothing to do here
End;

Function TEzBaseLayer.EntityType( RecNo: Integer ): TEzEntityID;
Var
  Entity: TEzEntity;
Begin
  Result:= Low(TEzEntityID);
  If LayerInfo.IsCosmethic Then
  Begin
    Entity := EntityWithRecno( Recno );
    If Entity <> Nil Then
      Result := Entity.EntityID;
  End
  Else
  Begin
    Entity := LoadEntityWithRecNo( RecNo );
    Try
      Result := Entity.EntityID;
    Finally
      Entity.Free;
    End;
  End;
End;

Function TEzBaseLayer.RecEntity: TEzEntity;
Begin
  Result := Nil;
End;

function TEzBaseLayer.RecNoOfEntity(ExtId: Integer): Integer;
var
  Rn: Integer;
  Ent: TEzEntity;
begin
  Result := -1;
  Rn := RecNo;
  try
    First;
    while not Eof do
    begin
      Ent := Self.RecLoadEntity;
      if Assigned(Ent) then
      if Ent.ExtID = ExtId then
      begin
        Result := RecNo;
        Break;
      end;
      Next;
    end;
  finally
    RecNo := Rn;
  end;
end;

Function TEzBaseLayer.EntityWithRecno( Recno: Integer ): TEzEntity;
Begin
  Result := Nil;
End;

Procedure TEzBaseLayer.Recall;
Begin
End;

Procedure TEzBaseLayer.PopulateFieldList( Strings: TStrings;
  WithAlias: Boolean = False );
Var
  I: Integer;
  FieldName: String;
  TmpSL: TStringList;
Begin
  { populate lbColumns with fields of native database }
  Strings.Clear;
  Strings.AddObject( AddBrackets( FName ) + SEntityField, Nil );
  Strings.AddObject( AddBrackets( FName ) + SRecNoField, Nil );
  If Self.IsClientServer Then
  Begin
    TmpSL := TStringList.create;
    Try
      Self.GetFieldList( TmpSL );
      For I := 0 To TmpSL.Count - 1 Do
        Strings.Add( AddBrackets( FName ) + '.' + AddBrackets( TmpSL[I] ) );
    Finally
      TmpSL.Free;
    End;
  End
  Else If DBTable <> Nil Then
    With DBTable Do
      For I := 1 To FieldCount Do
      Begin
        if WithAlias then
          FieldName:= FieldAlias[ I ]
        else
          FieldName:= Field( I );
        Strings.AddObject( AddBrackets( FName ) + '.' + AddBrackets( FieldName ), Nil );
      End;
End;

Function TEzBaseLayer.GetRecordCount: Integer;
Begin
  result := 0;
End;

Procedure TEzBaseLayer.Pack;
Begin
  // nothing to do here
End;

Procedure TEzBaseLayer.Repair;
Begin
  // nothing to do here
End;

Function TEzBaseLayer.FloatRect2Rect( Const Rect: TEzRect ): TRect_rt;
Begin
  With Result Do
  Begin
    x1 := Trunc( Rect.Emin.X * FCoordMultiplier );
    y1 := Trunc( Rect.Emin.y * FCoordMultiplier );
    x2 := Trunc( Rect.Emax.X * FCoordMultiplier );
    y2 := Trunc( Rect.Emax.y * FCoordMultiplier );
  End;
End;

Function TEzBaseLayer.Rect2FloatRect( Const Rect: TRect_rt ): TEzRect;
Begin
  With Result Do
  Begin
    Emin.X := Rect.X1 / FCoordMultiplier;
    Emin.Y := Rect.Y1 / FCoordMultiplier;
    Emax.X := Rect.X2 / FCoordMultiplier;
    Emax.Y := Rect.Y2 / FCoordMultiplier;
  End;
End;

Procedure TEzBaseLayer.MaxMinExtents( Var AMinX, AMinY, AMaxX, AMaxY: Double );
Begin
  With LayerInfo.Extension Do
  Begin
    AMinX := xmin;
    AMinY := ymin;
    AMaxX := xmax;
    AMaxY := ymax;
  End;
End;

Function TEzBaseLayer.GetEntityUniqueID( RecNo: Integer ): Integer;
Var
  Entity: TEzEntity;
Begin
  Result := 0;
  Entity := LoadEntityWithRecNo( RecNo );
  If Entity <> Nil Then
  Begin
    Try
      Result := Entity.ID;
    Finally
      Entity.Free;
    End;
  End;
End;

Function TEzBaseLayer.GetIndex: Integer;
Begin
  Result := FLayers.IndexOfName( Self.FName );
End;

Function TEzBaseLayer.LayerUp: Integer;
Begin
  Result := FLayers.LayerUp( GetIndex );
End;

Function TEzBaseLayer.LayerDown: Integer;
Begin
  Result := FLayers.LayerDown( GetIndex );
End;

Function TEzBaseLayer.BringToTop: Integer;
Begin
  Result := FLayers.BringToTop( GetIndex );
End;

Function TEzBaseLayer.SendToBack: Integer;
Begin
  Result := FLayers.SendToBack( GetIndex );
End;

function TEzBaseLayer.DefineBufferScope(Polyline: TEzEntity;
  const Scope: String; aOperator: TEzGraphicOperator; CurvePoints: Integer;
  const Distance: Double): Boolean;
Var
  Polygon: TEzEntity;
Begin
  Polygon := EzSystem.CreateBufferFromEntity( Polyline, CurvePoints, Distance, True );
  Try
    Result := DefinePolygonScope( Polygon, Scope, aOperator );
  Finally
    Polygon.Free;
  End;
end;

function TEzBaseLayer.DefinePolylineScope(Polyline: TEzEntity;
  const Scope: String): Boolean;
begin
  Result := DefinePolygonScope( Polyline, Scope, goIntersects );
end;

function TEzBaseLayer.DefineRectangleScope(const AXmin, AYmin, AXmax,
  AYmax: Double; const Scope: String;
  aOperator: TEzGraphicOperator): Boolean;
Var
  Polygon: TEzEntity;
Begin
  Polygon := TEzPolygon.CreateEntity( [Point2D( AxMin, AyMin ),
    Point2D( AxMax, AyMin ),
      Point2D( AxMax, AyMax ),
      Point2D( AxMin, AyMax ),
      Point2D( AxMin, AyMin )] );
  Try
    Result := DefinePolygonScope( Polygon, Scope, aOperator );
  Finally
    Polygon.Free;
  End;
end;

//----------------- TEzBaseLayers - class implementation ----------------------

Constructor TEzBaseLayers.Create( GIS: TEzBaseGIS );
Begin
  Inherited Create;
  FGIS := GIS;
  FItems := TList.Create;
End;

Destructor TEzBaseLayers.Destroy;
Begin
  Clear;
  FItems.Free;
  Inherited Destroy;
End;

Procedure TEzBaseLayers.Sort;
var
  SortList: TStringList;
  I: Integer;
Begin
  SortList:= TStringList.Create;
  try
    For I:= 0 to FItems.Count - 1 do
    begin
      SortList.AddObject( TEzBaseLayer( FItems[I] ).FName, FItems[I] );
    end;
    SortList.Sort;
    For I:= 0 to SortList.Count - 1 do
    begin
      FItems[I] := SortList.Objects[I];
    end;
    Gis.Modified:= true;
  finally
    SortList.Free;
  end;
End;

Function TEzBaseLayers.IsClientServer: Boolean;
Begin
  result := false;
End;

Procedure TEzBaseLayers.Clear;
Var
  I, n: Integer;
Begin
  n := FItems.Count - 1;
  For I := 0 To n Do
    TEzBaseLayer( FItems[0] ).Free;
  FItems.Clear;
End;

Function TEzBaseLayers.Get( Index: Integer ): TEzBaseLayer;
Begin
  If ( Index < 0 ) Or ( Index > FItems.Count - 1 ) Then
    raise Exception.Create( SLayerIndexOutOfRange );
  Result := TEzBaseLayer( FItems[Index] );
End;

Function TEzBaseLayers.GetCount: Integer;
Begin
  Result := FItems.Count;
End;

Procedure TEzBaseLayers.Exchange( Index1, Index2: Integer );
Begin
  FItems.Exchange( Index1, Index2 );
End;

Function TEzBaseLayers.LayerByName( Const LayerName: String ): TEzBaseLayer;
Var
  Index: Integer;
Begin
  Result := Nil;
  Index := IndexOfName( LayerName );
  If Index < 0 Then Exit;
  Result := TEzBaseLayer( FItems[Index] );
End;

Function TEzBaseLayers.IndexOf( Layer: TEzBaseLayer ): Integer;
Begin
  Result := FItems.IndexOf( Layer );
End;

Function TEzBaseLayers.IndexOfName( Const LayerName: String ): Integer;
Var
  I: Integer;
Begin
  Result := -1;
  For I := 0 To FItems.Count - 1 Do
    If AnsiCompareText( TEzBaseLayer( FItems[I] ).FName, LayerName ) = 0 Then
    Begin
      Result := I;
      Exit;
    End;
End;

Procedure TEzBaseLayers.OpenLayers;
Var
  I: Integer;
Begin
  For I := 0 To FItems.Count - 1 Do
    TEzBaseLayer( FItems[I] ).Open;
End;

Function TEzBaseLayers.LayerUp( Index: Integer ): Integer;
Begin
  Result := -1;
  If ( Index <= 0 ) Or ( Index > Count - 1 ) Then
  begin
    Exit;
  end;
  Result := Index - 1;
  Exchange( Index, Result );
End;

Function TEzBaseLayers.LayerDown( Index: Integer ): Integer;
Begin
  Result := -1;
  If ( Index < 0 ) Or ( Index >= Count - 1 ) Then Exit;
  Result := Index + 1;
  Exchange( Index, Result );
End;

Function TEzBaseLayers.BringToTop( Index: Integer ): Integer;
Var
  I: Integer;
  Temp: Pointer;
Begin
  result := 0;
  If ( Index < 0 ) Or ( Index >= Count - 1 ) Then
    Exit;
  Temp := FItems[Index];
  For I := Index To Count - 2 Do
    FItems[I] := FItems[I + 1];
  FItems[Count - 1] := Temp;
  Result := Count - 1;
End;

Function TEzBaseLayers.SendToBack( Index: Integer ): Integer;
Var
  I: Integer;
  Temp: Pointer;
Begin
  result := 0;
  If ( Index < 0 ) Or ( Index >= Count - 1 ) Then
    Exit;
  Temp := FItems[Index];
  For I := Index Downto 1 Do
    FItems[I] := FItems[I - 1];
  FItems[0] := Temp;
  Result := 0;
End;

Procedure TEzBaseLayers.PopulateList( Strings: TStrings );
Var
  I: Integer;
Begin
  With Strings Do
  Begin
    BeginUpdate;
    Clear;
    For I := 0 To FItems.Count - 1 Do
      AddObject( TEzBaseLayer( FItems[I] ).FName, TEzBaseLayer( FItems[I] ) );
    EndUpdate;
  End;
End;

{------------------------------------------------------------------------------}
//           TEzBaseTable - class implementation
{------------------------------------------------------------------------------}


{ TEzBaseTable }

Constructor TEzBaseTable.CreateNoOpen( Gis: TEzBaseGIS ); 
begin
  inherited create;
  FGis:= Gis;
  FLongFieldNames:= TStringList.Create;
end;

Constructor TEzBaseTable.Create( Gis: TEzBaseGIS; Const FName: String;
  ReadWrite, Shared: boolean );
var
  FileName: string;
Begin
  Inherited Create;
  FGis:= Gis;
  FLongFieldNames:= TStringList.Create;
  if Length(ExtractFilePath( FName )) = 0 then Exit;
  { now read virtual fields }
  FileName:= ChangeFileExt(FName, LONG_FIELDS_EXT);
  if Not FileExists( FileName ) then Exit;
  FLongFieldNames.LoadFromFile( FileName );
End;

Destructor TEzBaseTable.Destroy;
Begin
  FLongFieldNames.Free;
  inherited Destroy;
End;

function TEzBaseTable.FieldNoFromAlias( const AliasName: String ): Integer;
var
  I, Index: Integer;
  S: string;
begin
  Result:= -1;
  for I:= 0 to FLongFieldNames.Count-1 do
  begin
    s:= FLongFieldNames[I];
    Index:= AnsiPos('=', S );
    if (Index > 0) And
       (AnsiCompareText( Copy( S, Index + 1, Length(S)), AliasName ) = 0 ) then
    begin
      Result:= FieldNo( Copy(S, 1, Index - 1) );
      Exit;
    end;
  end;
end;

function TEzBaseTable.GetFieldAlias( FieldNo: Integer ): String;
var
  Index: Integer;
begin
  Result:= Field( FieldNo );
  Index := FLongFieldNames.IndexOfName( Result );
  if Index < 0 then Exit;
  Result:= FLongFieldNames.Values[ Result ];
end;

Procedure TEzBaseTable.SetFieldAlias( FieldNo: Integer; const Value: String );
{var
  FieldName: string;
  Index: Integer; }
begin
  //FieldName:= Field( FieldNo );
  FLongFieldNames.Values[ Field( FieldNo ) ]:= Value;
  {Index:= FLongFieldNames.IndexOfName( FieldName );
  if Index < 0 then
    FLongFieldNames.Add( FieldName + '=' + Value )
  else
    FLongFieldNames[Index]:= FieldName + '=' + Value; }
end;

function TEzBaseTable.GetFieldAliasByName( const FieldName: String ): String;
begin
  Result:= GetFieldAlias( FieldNo( FieldName ) );
end;

procedure TEzBaseTable.SetFieldAliasByName(const FieldName, Value: string);
begin
  SetFieldAlias( FieldNo( FieldName ), Value );
end;

Procedure TEzBaseTable.BeginTrans;
Begin
End;

Procedure TEzBaseTable.RollBackTrans;
Begin
End;

Procedure TEzBaseTable.EndTrans;
Begin
End;

Procedure TEzBaseTable.AssignFrom( Dataset: TEzBaseTable; SrcFieldNo, DstFieldNo: Integer );
Var
  SrcTyp, DstTyp: Char;
  BlobLen: Integer;
  stream: TStream;
  E: Integer;
  L: Double;
Begin
  If ( SrcFieldNo = 0 ) Or ( DstFieldNo = 0 ) Then Exit;
  SrcTyp := Dataset.FieldType( SrcFieldno );
  DstTyp := Self.FieldType( DstFieldno );
  Case DstTyp Of
    'M', 'B', 'G':
      Begin
        If Not ( SrcTyp In ['M', 'B', 'G'] ) Then exit;
        BlobLen := Dataset.MemoSizeN( SrcFieldNo );
        If BlobLen > 0 Then
        Begin
          stream:= TMemoryStream.Create;
          Try
            Dataset.MemoLoadN( SrcFieldNo, stream );
            stream.Position:= 0;
            Self.MemoSaveN( DstFieldNo, stream );
          Finally
            stream.free;
          End;
        End;
      End;
  Else
    Begin
      If ( SrcTyp = 'C' ) And (DstTyp <> 'C' ) Then
      Begin
        { possible conflict here with wrong assign }
        Val( Trim(Dataset.StringGetN( SrcFieldNo )), L, E );
        If E <> 0 Then L:= 0;
        FieldPutN( DstFieldNo, FloatToStr( L ) );
      End
      Else
        FieldPutN( DstFieldNo, Dataset.FieldGetN( SrcFieldNo ) );
    End;
  End;
End;

Function TEzBaseTable.DBCreateTable( Const fname: String;
  AFieldList: TStringList ): boolean;
Begin
  Result:= false;
End;

function TEzBaseTable.DBTableExists( const TableName: string ): Boolean;
Begin
  Result:= false;
End;

Function TEzBaseTable.DBDropTable( const TableName: string): Boolean;
Begin
  Result:= false;
End;

Function TEzBaseTable.DBDropIndex( const TableName: string): Boolean;
Begin
  Result:= false;
End;

Function TEzBaseTable.DBRenameTable( const Source, Target: string): Boolean;
Begin
  Result:= false;
End;

{------------------------------------------------------------------------------}
{                  TEzBaseGIS and auxiliary classes                            }
{------------------------------------------------------------------------------}

{ TEzDrawBoxList }

Constructor TEzDrawBoxList.Create;
Begin
  Inherited Create;
  FItems := TList.Create;
End;

Destructor TEzDrawBoxList.Destroy;
Begin
  FItems.Free;
  Inherited Destroy;
End;

Procedure TEzDrawBoxList.Add( Item: TEzBaseDrawBox );
Begin
  FItems.Add( Item );
End;

Function TEzDrawBoxList.IndexOf( Item: TEzBaseDrawBox ): Integer;
Var
  I: Integer;
Begin
  result := -1;
  For I := 0 To FItems.Count - 1 Do
    If FItems[I] = Item Then
    Begin
      result := I;
      exit;
    End;
End;

Procedure TEzDrawBoxList.Delete( Index: Integer );
Begin
  If ( Index < 0 ) Or ( Index > FItems.Count - 1 ) Then
    exit;
  FItems.Delete( Index );
End;

Function TEzDrawBoxList.GetCount: Integer;
Begin
  Result := FItems.Count;
End;

Function TEzDrawBoxList.GetItem( Index: Integer ): TEzBaseDrawBox;
Begin
  Result := FItems[Index];
End;

{ TEzBaseMapInfo - component class implementation }

Constructor TEzBaseMapInfo.Create( GIS: TEzBaseGIS );
Begin
  Inherited Create;
  FGIS := GIS;
End;

Function TEzBaseMapInfo.IsValid: Boolean;
Begin
  result := true;
  { in client/server sometimes this property can be false }
End;

Procedure TEzBaseMapInfo.Assign( Source: TEzBaseMapInfo );
Begin
  If Not IsValid Then Exit;
  NumLayers := Source.NumLayers;
  Extension := Source.Extension;
  CurrentLayer := Source.CurrentLayer;
  AerialViewLayer := Source.AerialViewLayer;
  LastView := Source.LastView;
  CoordsUnits := Source.CoordsUnits;
  IsAreaClipped := Source.IsAreaClipped;
  AreaClipped := Source.AreaClipped;
  ClipAreaKind := Source.ClipAreaKind;
End;

Function TEzBaseMapInfo.UnitsVerb: String;
//Var
  //en: String;
Begin
  //en := GetEnumName( System.TypeInfo( TEzCoordsUnits ), Ord( CoordsUnits ) );
  //result := copy( en, 3, length( en ) );
  Result:= ezbase.pj_units[CoordsUnits].id;
End;

Function TEzBaseMapInfo.UnitsLongVerb: String;
Begin
  result := ezbase.pj_units[CoordsUnits].name;
End;

Procedure TEzBaseMapInfo.SetCurrentLayer( Const Value: String );
Begin
  { Descendants must set the current layer. Here we will notify to TEzBaseGIS only }
  If Assigned( FGIS.FOnCurrentLayerChange ) Then
    FGIS.FOnCurrentLayerChange( FGIS, Value );
End;

{ ***** TEzBaseGIS - main component ***** }

Constructor TEzBaseGIS.Create( AOwner: TComponent );
Begin
  Inherited Create( AOwner );

  FDrawBoxList := TEzDrawBoxList.Create;
  FVGuideLines := TEzDoubleList.Create;
  FHGuideLines := TEzDoubleList.Create;
  FAutoSetLastView := True;
  FShowWaitCursor := true;

  FClipPolygonalArea := TEzVector.Create( 4 );
  FClippedEntities := TEzSelection.Create( Nil );
  FProjectionParams := TStringList.Create;
  FLayersSubdir := AddSlash( ExtractFilePath( Application.ExeName ) );

  FPolygonClipOperation := TEzPolyClipTool.Create;
  FTimerFrequency := 200;
  FPrintTimerFrequency := 800;

  FFontShadowStyle := fssLowerRight;
  FFontShadowColor := clSilver;
  FFontShadowOffset := 1;
end;

destructor TEzBaseGIS.Destroy;
var
  I: Integer;
Begin

  For I := 0 To FDrawBoxList.Count - 1 Do
    FDrawBoxList[I].FGIS := Nil;
  FDrawBoxList.Free;
  FLayers.Free;
  FProjectionParams.Free;

  FVGuideLines.Free;
  FHGuideLines.Free;

  FClipPolygonalArea.Free;
  FClippedEntities.Free;

  if Assigned(FMapInfo) then
    FMapInfo.Free;

  FPolygonClipOperation.Free;

  inherited Destroy;
end;

procedure TEzBaseGIS.SetFilename( const Value: string ); 
Begin
  FFileName:= Value;
End;

{$IFDEF GIS_CONTROLS}
Procedure TEzBaseGIS.AddShape( Const FileName: String );
var
  Index: Integer;
Begin
  Index:= AddShapeLayer( Self, FileName, false );
  If Index >= 0 then
    Layers[Index].Open;
end;

Procedure TEzBaseGIS.AddDGN( Const FileName: String );
var
  Index: Integer;
Begin
  Index:= AddDGNLayer( Self, FileName, false );
  If Index >= 0 then
    Layers[Index].Open;
end;
{$ENDIF}

procedure TEzBaseGIS.LoadFontFile(const FileName: string);
begin
  if not FileExists(FileName) then exit;
  Ez_VectorFonts.AddFontFile(FileName);
end;

procedure TEzBaseGIS.LoadSymbolsFile(const FileName: string);
begin
  if not FileExists(FileName) then exit;
  Ez_Symbols.FileName:= FileName;
  Ez_Symbols.Open;
end;

procedure TEzBaseGIS.LoadLineTypesFile(const FileName: string);
begin
  if not FileExists(FileName) then exit;
  Ez_LineTypes.FileName:=FileName;
  Ez_LineTypes.Open;
end;

Procedure TEzBaseGIS.AddGeoref( Const LayerName, FileName: String );
begin
  // nothing to do here
end;

Procedure TEzBaseGIS.SetPolygonClipOperation( value: TEzPolyClipTool );
Begin
  FPolygonClipOperation.Assign( value );
End;

Procedure TEzBaseGIS.SetModified( Value: Boolean );
Begin
  FModified := Value;
  If FModified And Assigned( FOnModified ) Then
    FOnModified( Self );
End;

Procedure TEzBaseGIS.SetLayers( Value: TEzBaseLayers );
Begin
  If FLayers <> Nil Then
    FLayers.Free;
  FLayers := Value;
End;

Function TEzBaseGIS.IsClientServer: Boolean;
Begin
  result := false;
End;

Procedure TEzBaseGIS.ClearClippedArea;
Begin
  FMapInfo.IsAreaClipped := False;
  FClippedEntities.Clear;
  FClipPolygonalArea.Clear;
  RepaintViewports;
End;

Function TEzBaseGIS.OpenMode: Word;
Begin
  If FReadOnly Then
    result := fmOpenRead Or fmShareDenyNone
  Else
    result := fmOpenReadWrite Or fmShareDenyNone;
End;

Function TEzBaseGIS.IsDesigning: Boolean;
Begin
  Result := ( csDesigning In ComponentState );
End;

Procedure TEzBaseGIS.SaveIfModified;
Begin
  If FReadOnly Then Exit;
  If ( Length( FFileName ) > 0 ) And FModified Then
  Begin
    SaveAs( FFileName );
  End;
End;

Procedure TEzBaseGIS.CreateNew( Const FileName: String );
Var
  I: Integer;
Begin
  Close;
  { initialize all the map information }
  If FMapInfo.IsValid Then
  Begin
    FMapInfo.Initialize;
    FMapInfo.CoordSystem := csCartesian;
    FMapInfo.CoordsUnits := cuM;
  End;
  { write all header information }
  WriteMapHeader( Filename );
  FFileName := FileName;
  If Assigned( FOnFileNameChange ) Then
    FOnFileNameChange( Self );
  Layers.Clear;
  
  If FMapInfo.IsValid Then
  Begin
    For I := 0 To FDrawBoxList.Count - 1 Do
    Begin
      with FDrawBoxList[I] do
      begin
        Selection.Clear;
        ZoomWindow( FMapInfo.Extension );
        Grapher.Clear;
      end;
    End;
  End;
  if Assigned( FOnCurrentLayerChange ) then
    FOnCurrentLayerChange( Self, '' );
  FActive := true;
  RepaintViewports;
End;

Function TEzBaseGIS.GetCurrentLayer;
Var
  Index: Integer;
Begin
  Result := Nil;
  Index := FLayers.IndexOfName( FMapInfo.CurrentLayer );
  If Index < 0 Then
  Begin
    If FLayers.Count > 0 Then
    Begin
      FMapInfo.CurrentLayer := FLayers[0].Name;
      Index := 0;
    End
    Else
      Exit;
  End;
  Result := FLayers[Index];
End;

Function TEzBaseGIS.GetCurrentLayerName: String;
Var
  Layer: TEzBaseLayer;
Begin
  result := '';
  Layer := GetCurrentLayer;
  If Layer = Nil Then Exit;
  Result := AnsiUpperCase( Layer.Name );
End;

procedure TEzBaseGIS.SetCurrentLayer(const Value: TEzBaseLayer);
Var
  Index: Integer;
Begin
  Index := FLayers.IndexOf(Value);// FMapInfo.CurrentLayer );
  If Index >= 0 Then
    FMapInfo.CurrentLayer := Value.Name;
end;

Procedure TEzBaseGIS.SetCurrentLayerName( Const Value: String );
Var
  Index: Integer;
Begin
  Index := FLayers.IndexOfName( Value );
  If (Index < 0) Or Not FLayers[Index].LayerInfo.Visible Then Exit;
  FMapInfo.CurrentLayer := AnsiUpperCase( Value );
End;

Procedure TEzBaseGIS.Save;
Begin
  SaveAs( FFileName );
  FActive := true;
End;

Procedure TEzBaseGIS.SetActive( Value: Boolean );
Begin
  If FActive = Value Then exit;
//  FActive := Value;
  If Value Then
    Open
  Else
    Close;
End;

Procedure TEzBaseGIS.Open;
Var
  I: Integer;
Begin
  If IsDesigning Then Exit;
  If Assigned( FOnBeforeOpen ) Then
    FOnBeforeOpen( Self );
  If FMapInfo.IsValid Then
  Begin
    For I := 0 To FDrawBoxList.Count - 1 Do
    Begin
      FDrawBoxList[I].Grapher.Clear;
    End;
  End;
  FActive := true;
End;

Procedure TEzBaseGIS.Close;
Var
  I: Integer;
Begin
  If IsDesigning Or Not FActive Then Exit;
  If Not FReadOnly Then
    SaveIfModified;
  If Assigned( FOnBeforeClose ) Then
  Begin
    FOnBeforeClose( Self );
  End;
  For I := 0 To FDrawBoxList.Count - 1 Do
  Begin
    FDrawBoxList[I].TempEntities.Clear;
  End;
  If FMapInfo.IsValid Then
  Begin
    FMapInfo.IsAreaClipped := False;
  End;
  For I := 0 To Layers.Count - 1 Do
  Begin
    Layers[I].WriteHeaders( true ); // flush files
  End;
  FClippedEntities.Clear;
  FClipPolygonalArea.Clear;
  FLayers.Clear;
  FVGuidelines.Clear;
  FHGuidelines.Clear;
  FActive := False;
End;

Procedure TEzBaseGIS.RepaintViewports;
Var
  I: Integer;
Begin
  //if IsDesigning then Exit;
  For i := 0 To FDrawBoxList.Count - 1 Do
    FDrawBoxList[i].Repaint;
End;

Procedure TEzBaseGIS.RefreshViewports;
Var
  I: Integer;
Begin
  For I := 0 To FDrawBoxList.Count - 1 Do
    FDrawBoxList[I].Refresh;
End;

Procedure TEzBaseGIS.QuickUpdateExtension;
Var
  I: Integer;
  TmpExt: TEzRect;
Begin
  If FDrawBoxList.Count = 0 Then
    Exit;
  TmpExt := INVALID_EXTENSION;
  For I := 0 To FLayers.Count - 1 Do
  Begin
    With FLayers[I] Do
    Begin
      If Not LayerInfo.Visible Then
        Continue;
      QuickUpdateExtension;
      MaxBound( TmpExt.Emax, LayerInfo.Extension.Emax );
      MinBound( TmpExt.Emin, LayerInfo.Extension.Emin );
    End;
  End;
  FMapInfo.Extension := TmpExt;
End;

Procedure TEzBaseGIS.UpdateExtension;
Var
  I: Integer;
  TmpExt: TEzRect;
Begin
  //If FDrawBoxList.Count = 0 Then Exit;
  TmpExt := INVALID_EXTENSION;
  For I := 0 To FLayers.Count - 1 Do
  Begin
    With FLayers[I] Do
    Begin
      If Not LayerInfo.Visible Then Continue;
      UpdateExtension;
      MaxBound( TmpExt.Emax, LayerInfo.Extension.Emax );
      MinBound( TmpExt.Emin, LayerInfo.Extension.Emin );
    End;
  End;
  FMapInfo.Extension := TmpExt;
End;

Function TEzBaseGIS.VectIntersect( Vector1, Vector2, IntersectVector: TEzVector ): Boolean;
Begin
  Result := EzLib.VectIntersect( Vector1, Vector2, IntersectVector, true, true );
End;

Procedure TEzBaseGIS.RebuildTree;
Var
  i: Integer;
Begin
  For i := 0 To FLayers.Count - 1 Do
    FLayers[i].RebuildTree;
End;

Procedure TEzBaseGIS.StartProgress( Const ACaption: String; AMin, AMax: Integer );
Begin
  EndProgress;
  If Not Assigned( FOnProgress ) Then
    Exit;
  FProgressMin := AMin;
  FProgressPosition := AMin;
  FProgressMax := AMax;
  FOnProgress( Self, epsStarting, ACaption, AMin, AMax, AMin );
End;

Procedure TEzBaseGIS.EndProgress;
Begin
  If Not Assigned( FOnProgress ) Then
    Exit;
  FOnProgress( Self, epsEnding, '', FProgressMin, FProgressMax, FProgressPosition );
End;

Procedure TEzBaseGIS.UpdateProgress( Position: Integer );
Var
  TmpPosition, Range, Progress: Integer;
Begin
  If Not Assigned( FOnProgress ) Then Exit;
  Range := FProgressMax - FProgressMin;
  TmpPosition := MulDiv( FProgressPosition, 100, Range );
  Progress := MulDiv( Position, 100, Range );
  If Progress > TmpPosition + 5 Then
  Begin
    FProgressPosition := Position;
    FOnProgress( Self, epsMessage, '', FProgressMin, FProgressMax, Position );
  End;
End;

Procedure TEzBaseGIS.UpdateCaption( Const ACaption: String );
Begin
  If Not Assigned( FOnProgress ) Then Exit;
  FOnProgress( Self, epsUpdating, ACaption, FProgressMin, FProgressMax, FProgressPosition );
End;

Procedure TEzBaseGIS.MaxMinExtents( Var AXMin, AYMin, AXMax, AYMax: Double );
Begin
  With FMapInfo.Extension Do
  Begin
    AXMin := X1;
    AYMin := Y1;
    AXMax := X2;
    AYMax := Y2;
  End;
End;

Function TEzBaseGIS.EntityDifference( Const Entity1, Entity2: TEzEntity ): TEzEntity;
Begin
  Result := Self.InternalPolyclipEx( Entity1, Entity2, pcDIFF );
End;

Function TEzBaseGIS.EntityIntersect( Const Entity1, Entity2: TEzEntity ): TEzEntity;
Begin
  Result := Self.InternalPolyclipEx( Entity1, Entity2, pcINT );
End;

Function TEzBaseGIS.EntityUnion( Const Entity1, Entity2: TEzEntity ): TEzEntity;
Begin
  Result := Self.InternalPolyclipEx( Entity1, Entity2, pcUNION );
End;

Function TEzBaseGIS.EntityXor( Const Entity1, Entity2: TEzEntity ): TEzEntity;
Begin
  Result := Self.InternalPolyclipEx( Entity1, Entity2, pcXOR );
End;

Function TEzBaseGIS.EntitySplit( Const Entity1, Entity2: TEzEntity ): TEzEntity;
Begin
  Result := Self.InternalPolyclipEx( Entity1, Entity2, pcDIFF );
End;

{ generate operation clipping }

Function TEzBaseGIS.InternalPolyClipEx( Const Entity1, Entity2: TEzEntity; Op: TEzPolyClipOp ): TEzEntity;
Var
  subject, clipping, clipresult: TEzEntityList;
  TmpEnt: TEzEntity;
  I, J, part: Integer;

Begin
  If Not Entity1.IsClosed Or Not Entity2.IsClosed Then
    EzGISError( SEntityNotClosed );

  subject := TEzEntityList.create;
  clipping := TEzEntityList.create;
  clipresult := TEzEntityList.create;
  Try
    If ( Entity1.Points.Parts.Count < 2 ) And ( Entity2.Points.Parts.Count < 2 ) Then
    Begin
      subject.add( Entity1 );
      subject.OwnEntities := False;
      clipping.Add( Entity2 );
      clipping.OwnEntities := False;
    End
    Else
      EzGISError( SMultiPartNotSupported );
    If Op = pcSPLIT Then
    Begin
      PolygonClip( pcDIFF, subject, clipping, clipresult, Nil );
      clipresult.free;
      clipresult := TEzEntityList.Create;
      polygonClip( pcINT, clipping, subject, clipresult, Nil );
    End
    Else
      PolygonClip( Op, subject, clipping, clipresult, Nil );
    Result := TEzPolygon.CreateEntity( [] );
    part := 0;
    For I := 0 To clipresult.count - 1 Do
    Begin
      If I > 0 Then
      Begin
        If I = 1 Then
          Result.Points.Parts.Add( 0 );
        Result.Points.Parts.Add( part );
      End;
      TmpEnt := clipresult[I];
      For J := 0 To TmpEnt.Points.Count - 1 Do
      Begin
        Result.Points.Add( TmpEnt.Points[J] );
        Inc( part );
      End;
    End;
    If Result.Points.Count = 0 Then
      FreeAndNil( Result );
    If Result <> Nil Then
    Begin
      TEzOpenedEntity( Result ).PenTool.Assign( TEzOpenedEntity( Entity1 ).PenTool );
      TEzClosedEntity( Result ).BrushTool.Assign( TEzClosedEntity( Entity1 ).BrushTool );
    End;
  Finally
    subject.free;
    clipping.free;
    clipresult.free;
  End;
End;

{ Generates a buffer polygon around a geometry
  Curvepoints is the number of points used to smooth the curve on every corner (you can use 50)
  Distance is the distance the buffer to be created }

Function TEzBaseGIS.CreateBufferEntity( Entity: TEzEntity; CurvePoints: Integer; Const Distance: Double ): TEzEntity;
Begin
  Result := EzSystem.CreateBufferFromEntity( Entity, CurvePoints, Distance, True );
End;

{ this function returns true if two entities are within a given distance apart }

Function TEzBaseGIS.WithinDistance( Entity1, Entity2: TEzEntity;Const Distance: Double ): Boolean;
Var
  TmpDistance: Double;
  Min1, Min2: TEzPoint;
Begin
  EzLib.GetMinimumDistance2D( Entity1.DrawPoints, Entity2.DrawPoints, TmpDistance, Min1, Min2 );
  Result := TmpDistance <= Distance;
End;

{ indicates if two entities relate as defined in the GraphicOperator parameter
  example of values for GraphicOperator :
  goWithin -> left entity is inside (maybe not full inside) right entity
  goEntirelyWithin -> left entity fully inside right entity
  goContains -> left entity partially or fully contains right entity
  goContainsEntire -> left entity fully contains right entity
  goIntersects -> left entity and right entity have at least one point in common
  }

Function TEzBaseGIS.EntitiesRelate( Entity1, Entity2: TEzEntity; GraphicOperator: TEzGraphicOperator ): Boolean;
Begin
  Result:= Entity1.CompareAgainst(Entity2, GraphicOperator)
End;

{ the Query methods }

Procedure TEzBaseGIS.QueryPolygon( Polygon: TEzEntity;
  Const Layername, QueryExpression: String; aOperator: TEzGraphicOperator;
  Data: Longint; List: TIntegerList; ClearBefore: Boolean );
Var
  Layer: TEzBaseLayer;
  i: Integer;

  Procedure DoQuery( aLayer: TEzBaseLayer );
  Begin
    If ( List <> Nil ) And ClearBefore Then
    begin
      List.Clear;
      ClearBefore:= False;
    end;
    If Not aLayer.DefinePolygonScope( Polygon, QueryExpression, aOperator ) Then Exit;
    aLayer.First;
    While Not aLayer.Eof Do
    Begin
      Try
        If aLayer.RecIsDeleted Then
          Continue;
        If Assigned( FOnQueryResults ) Then
          FOnQueryResults( Self, Data, aLayer.Name, aLayer.Recno );
        If ( List <> Nil ) And ( Length( Layername ) > 0 ) Then
          List.Add( aLayer.Recno );
      Finally
        aLayer.Next;
      End;
    End;
    aLayer.CancelFilter;
  End;

Begin
  If Not ( Assigned( FOnQueryResults ) Or ( List <> Nil ) ) Then Exit;
  If Length( Layername ) > 0 Then
  Begin
    Layer := Layers.LayerByName( Layername );
    If Layer = Nil Then
      EzGISError( SLayerNotFound );
    DoQuery( Layer );
  End
  Else
    For i := 0 To Layers.Count - 1 Do
      DoQuery( Layers[i] );
End;

Procedure TEzBaseGIS.QueryExpression( Const Layername, Expression: String;
  Data: Longint; List: TIntegerList; ClearBefore: Boolean );
Var
  Layer: TEzBaseLayer;
  I: Integer;

  Procedure DoQuery( aLayer: TEzBaseLayer );
  Begin
    If ( List <> Nil ) And ClearBefore Then
    begin
      List.Clear;
      ClearBefore:= False;
    end;
    If Not aLayer.DefineScope( Expression ) Then  Exit;
    aLayer.First;
    While Not aLayer.Eof Do
    Begin
      Try
        If aLayer.RecIsDeleted Then
          Continue;
        If Assigned( FOnQueryResults ) Then
          FOnQueryResults( Self, Data, aLayer.Name, aLayer.Recno );
        If ( List <> Nil ) And ( Length( Layername ) > 0 ) Then
          List.Add( aLayer.Recno );
      Finally
        aLayer.Next;
      End;
    End;
    aLayer.CancelFilter;
  End;

Begin
  If Not ( Assigned( FOnQueryResults ) Or ( List <> Nil ) ) Then Exit;
  If Length( Layername ) > 0 Then
  Begin
    Layer := Layers.LayerByName( Layername );
    If Layer = Nil Then
      EzGISError( SLayerNotFound );
    DoQuery( Layer );
  End
  Else
    For i := 0 To Layers.Count - 1 Do
      DoQuery( Layers[i] );
End;

Procedure TEzBaseGIS.QueryRectangle( Const AxMin, AyMin, AxMax, AyMax: double;
  Const Layername, QueryExpression: String; aOperator: TEzGraphicOperator;
  Data: Longint; List: TIntegerList; ClearBefore: Boolean );
Var
  Polygon: TEzEntity;
Begin
  Polygon := TEzPolygon.CreateEntity( [Point2D( AxMin, AyMin ),
    Point2D( AxMax, AyMin ),
      Point2D( AxMax, AyMax ),
      Point2D( AxMin, AyMax ),
      Point2D( AxMin, AyMin )] );
  Try
    Self.QueryPolygon( Polygon,  Layername, QueryExpression, aOperator,
      Data, List, ClearBefore );
  Finally
    Polygon.Free;
  End;
End;

Procedure TEzBaseGIS.QueryBuffer( Polyline: TEzEntity;
  Const Layername, QueryExpression: String; aOperator: TEzGraphicOperator; Data: Longint;
  CurvePoints: Integer; Const Distance: Double; List: TIntegerList; ClearBefore: Boolean );
Var
  Polygon: TEzEntity;
Begin
  Polygon := EzSystem.CreateBufferFromEntity( Polyline, CurvePoints, Distance, True );
  Try
    Self.QueryPolygon( Polygon, Layername, QueryExpression, aOperator, Data,
      List, ClearBefore );
  Finally
    Polygon.Free;
  End;
End;

{ this method will retieve only the entities that intersects the
  given polyline (obviously, there is no other choice with polylines)}

Procedure TEzBaseGIS.QueryPolyline( Polyline: TEzEntity;
  Const Layername, QueryExpression: String; Data: Longint; List: TIntegerList; ClearBefore: Boolean );
Begin
  Self.QueryPolygon( Polyline, Layername, QueryExpression, goIntersects, Data, List, ClearBefore );
End;

Function TEzBaseGIS.FoundFirstCosmethicLayer: TEzBaseLayer;
Var
  I: Integer;
Begin
  Result := Nil;
  For I := 0 To Layers.Count - 1 Do
    If Layers[I].LayerInfo.IsCosmethic Then
    Begin
      Result := Layers[I];
      Exit;
    End;
End;

{------------------------------------------------------------------------------}
{                  The selection object and aux classes                        }
{------------------------------------------------------------------------------}

{ the selection and the undo objects }
{TEzSelectionLayer - class implementation}

Constructor TEzSelectionLayer.Create( Selection: TEzSelection; Layer: TEzBaseLayer );
Begin
  Inherited Create;
  FSelection := Selection;
  FIsSelectEvent := Assigned( Selection.FDrawBox.OnAfterSelect );
  FIsUnSelectEvent := Assigned( Selection.FDrawBox.OnAfterUnSelect );
  FIsBeforeSelectEvent := Assigned( Selection.FDrawBox.OnBeforeSelect );
  FLayer := Layer;
  FSelList := TIntegerList.Create;
End;

Destructor TEzSelectionLayer.Destroy;
Var
  I: Integer;
Begin
  If FIsUnSelectEvent Then
  Begin
    For I := 0 To FSelList.Count - 1 Do
      FSelection.FDrawBox.OnAfterUnSelect( FSelection.FDrawBox, FLayer, FSelList[I] );
  End;
  FSelList.Free;
  Inherited Destroy;
End;

Procedure TEzSelectionLayer.Add( RecNo: Integer );
Var
  CanSelect: Boolean;
Begin
  If FIsBeforeSelectEvent Then
  Begin
    CanSelect := True;
    TEzBaseDrawBox( FSelection.FDrawBox ).OnBeforeSelect( FSelection.FDrawBox, FLayer, Recno, CanSelect );
    If Not CanSelect Then Exit;
  End;

  If FSelList.IndexOfValue( Recno ) >= 0 Then Exit; // already in list
  FSelList.Add( Recno );
  If FIsSelectEvent Then
  Begin
    TEzBaseDrawBox( FSelection.FDrawBox ).OnAfterSelect( FSelection.FDrawBox, FLayer, Recno );
  End;
End;

Procedure TEzSelectionLayer.Delete( RecNo: Integer );
Var
  Index: Integer;
Begin
  Index := FSelList.IndexOfValue( Recno );
  If Index = -1 Then
    Exit; // not in list
  FSelList.Delete( Index );
  If FIsUnSelectEvent Then
  Begin
    TEzBaseDrawBox( FSelection.FDrawBox ).OnAfterUnSelect( FSelection.FDrawBox, FLayer, Recno );
  End;
End;

Function TEzSelectionLayer.IsSelected( Recno: Integer ): Boolean;
Begin
  If FSelList.Count = 0 Then
    Result := false
  Else
    Result := ( FSelList.IndexOfValue( Recno ) >= 0 );
End;

{ TEzSelection - class implementation }

Constructor TEzSelection.Create( DrawBox: TEzBaseDrawBox );
Begin
  Inherited Create;
  FList := TList.Create;
  FDrawBox := DrawBox;
End;

Destructor TEzSelection.Destroy;
Begin
  Clear;
  FList.Free;
  Inherited Destroy;
End;

Procedure TEzSelection.BeginUpdate;
Begin
  FInUpdate := True;
End;

Procedure TEzSelection.EndUpdate;
Begin
  If Not FInUpdate Then Exit;
  FInUpdate := false;
  CalcNumSelected;
  If ( FDrawBox <> Nil ) And Assigned( FDrawBox.OnSelectionChanged ) Then
    FDrawBox.OnSelectionChanged( Self );
End;

function TEzSelection.FirstSelected(var Layer: TEzBaseLayer;
  var RecNo: Integer): Boolean;
var
  I: Integer;
  J: Integer;
begin
  Result := False;
  for I := 0 to Count - 1 do
    for J := 0 to Items[I].SelList.Count - 1 do
    begin
      Layer := Items[I].Layer;
      Recno := Items[I].SelList[J];
      Result := True;
      Break;
    end;
end;

function TEzSelection.FirstSelected: TEzEntity;
var
  L: TEzBaseLayer;
  Rn: Integer;
begin
  Result := nil;
  if FirstSelected(L, Rn) then
    Result := L.LoadEntityWithRecNo(Rn);
end;

Procedure TEzSelection.Assign( Source: TEzSelection );
Var
  I, J: Integer;
Begin
  Clear;
  FDrawBox := Source.FDrawBox;
  For I := 0 To Source.Count - 1 Do
    With Source[I] Do
    Begin
      AddLayer( Layer );
      For J := 0 To FSelList.Count - 1 Do
        Self.Add( Layer, FSelList[J] );
    End;
End;

Procedure TEzSelection.Clear;
Var
  I: Integer;
Begin
  For I := 0 To Count - 1 Do
    DeleteLayer( Items[0].Layer );
  FList.Clear;
  CalcNumSelected;
  If ( FDrawBox <> Nil ) And Not ( csDestroying In FDrawBox.ComponentState ) And
    Assigned( FDrawBox.OnSelectionChanged ) Then
    FDrawBox.OnSelectionChanged( FDrawBox );
End;

function TEzSelection.ContainsEntityId(EntityIds: TEzEntityIDs; var Num: Integer): Boolean;
var
  I: Integer;
  J: Integer;
begin
  Result := False;
  Num := 0;
  for I := 0 to Count - 1 do
    for J := 0 to Items[I].SelList.Count - 1 do
    begin
      Items[I].FLayer.RecNo := Items[I].SelList[J];
      if Items[I].FLayer.RecEntityID in EntityIds then
      begin
        Result := True;
        Inc(Num);
      end;
    end;
end;

Procedure TEzSelection.AddLayer( Layer: TEzBaseLayer );
Var
  Index: Integer;
  SelectionLayer: TEzSelectionLayer;
Begin
  If Layer = Nil Then
    Exit;
  Index := IndexOf( Layer );
  If Index >= 0 Then
    Exit; {already in the list}
  SelectionLayer := TEzSelectionLayer.Create( Self, Layer );
  FList.Add( SelectionLayer );
End;

Procedure TEzSelection.Add( Layer: TEzBaseLayer; RecNo: Integer );
Var
  Index: Integer;
  OldNum: Integer;
Begin
  OldNum := NumSelected;
  Index := IndexOf( Layer );
  If Index = -1 Then
  Begin
    AddLayer( Layer );
    Index := FList.Count - 1;
  End;
  TEzSelectionLayer( FList[Index] ).Add( RecNo );
  CalcNumSelected;
  If ( FDrawBox <> Nil ) And Not FInUpdate And Assigned( FDrawBox.OnSelectionChanged ) Then
  If OldNum <> NumSelected then
    FDrawBox.OnSelectionChanged( Self );
End;

Procedure TEzSelection.Delete( Layer: TEzBaseLayer; RecNo: Integer );
Var
  Index: Integer;
Begin
  //If ( Not Layer.IsClientServer ) And
  //   (( RecNo < 1 ) Or ( RecNo > Layer.RecordCount )) Then Exit;
  Index := IndexOf( Layer );
  If Index = -1 Then Exit;

  With TEzSelectionLayer( FList[Index] ) Do
  Begin
    Delete( RecNo );
    If FSelList.Count = 0 Then
      DeleteLayer( Layer );
  End;
  CalcNumSelected;
  If ( FDrawBox <> Nil ) And Not FInUpdate And Assigned( FDrawBox.OnSelectionChanged ) Then
    FDrawBox.OnSelectionChanged( Self );
End;

Procedure TEzSelection.DeleteLayer( Layer: TEzBaseLayer );
Var
  Index: Integer;
Begin
  Index := IndexOf( Layer );
  If Index = -1 Then
    Exit;
  TEzSelectionLayer( FList[Index] ).Free;
  FList.Delete( Index );
  CalcNumSelected;
  If ( FDrawBox <> Nil ) And Not FInUpdate And Assigned( FDrawBox.OnSelectionChanged ) Then
    FDrawBox.OnSelectionChanged( Self );
End;

Function TEzSelection.IndexOf( Layer: TEzBaseLayer ): Integer;
Var
  I: Integer;
Begin
  Result := -1;
  For I := 0 To Count - 1 Do
    If Items[I].Layer = Layer Then
    Begin
      Result := I;
      Exit;
    End;
End;

Function TEzSelection.GetCount: Integer;
Begin
  Result := FList.Count;
End;

Function TEzSelection.GetNumSelected: Integer;
Begin
  Result := FNumSelected;
End;

procedure TEzSelection.CalcNumSelected;
Var
  Cnt: Integer;
Begin
  FNumSelected := 0;
  For Cnt := 0 To FList.Count - 1 Do
    Inc( FNumSelected, TEzSelectionLayer( FList[Cnt] ).FSelList.Count );
End;

Function TEzSelection.NumSelectedInLayer( Layer: TEzBaseLayer ): Integer;
Var
  Index: Integer;
Begin
  Result := 0;
  Index := IndexOf( Layer );
  If Index >= 0 Then
    Result := TEzSelectionLayer( FList[Index] ).FSelList.Count;
End;

Function TEzSelection.Get( Index: Integer ): TEzSelectionLayer;
Begin
  Result := Nil;
  If ( Index < 0 ) Or ( Index > FList.Count - 1 ) Then
    Exit;
  Result := TEzSelectionLayer( FList[Index] );
End;

Procedure TEzSelection.DeleteSelection;
Var
  J, L: Integer;
Begin
  {Delete all selected entities}
  If Count = 0 Then Exit;
  For L := 0 To Count - 1 Do
  Begin
    With Items[L] Do
    Begin
      For J := 0 To FSelList.Count - 1 Do
        Layer.DeleteEntity( FSelList[J] );
    End;
  End;
  Clear;
End;

Procedure TEzSelection.Toggle( Layer: TEzBaseLayer; RecNo: Integer );
Var
  Index: Integer;
Begin
  Index := IndexOf( Layer );
  If Index >= 0 Then
    With TEzSelectionLayer( FList[Index] ) Do
    Begin
      If IsSelected( RecNo ) Then
        Delete( RecNo )
      Else
        Add( RecNo )
    End
  Else
    Add( Layer, RecNo );
  CalcNumSelected;
  If ( FDrawBox <> Nil ) And Not FInUpdate And Assigned( FDrawBox.OnSelectionChanged ) Then
    FDrawBox.OnSelectionChanged( Self );
End;

Function TEzSelection.IsSelected( Layer: TEzBaseLayer; RecNo: Integer ): Boolean;
Var
  Index: Integer;
Begin
  Result := false;
  Index := IndexOf( Layer );
  If Index < 0 Then
    Exit;
  Result := TEzSelectionLayer( FList[Index] ).IsSelected( RecNo );
End;

Procedure TEzSelection.UnSelectAndRepaint;
Var
  Box: TEzRect;
Begin
  Box := GetExtension;
  Clear;
  If Not EqualRect2D( Box, INVALID_EXTENSION ) Then
    FDrawBox.RepaintRect( Box );
End;

Procedure TEzSelection.RepaintSelectionArea;
Var
  R: TEzRect;
  Factor: Double;
Begin
  If ( FDrawBox = Nil ) Or ( FList.Count = 0 ) Then Exit;
  With FDrawBox Do
  Begin
    { with Grapher.OriginalParams.VisualWindow do d1:= Dist2D(Emin, Emax);
      with Grapher.CurrentParams.VisualWindow do d2:= Dist2D(Emin, Emax);
      Factor:= d2 / d1; }
    Factor := 1;
    If Factor < 0.2500 Then
      { if currentview is <= 25% of total view then use all visible area }
      Repaint
    Else
    Begin
      R := GetExtension;
      //if EqualRect2D(R, INVALID_EXTENSION) then Exit;
      RepaintRect( R );
    End;
  End;
End;

Function TEzSelection.GetExtension: TEzRect;
Var
  I: Integer;
  Extent: TEzRect;
  //Buff: TEzBufferedRead;
  d1, d2: Double;
  Found: Boolean;
  cvw: TEzRect;
Begin
  Result := INVALID_EXTENSION;
  try
    If ( FDrawBox = Nil ) Or ( Count = 0 ) Then Exit;
    With FDrawBox.Grapher Do
    Begin
      cvw := CurrentParams.VisualWindow;
      //MapExtent:= ezgis.MapInfo.Extension;
      //if IsBoxFullInBox2D(MapExtent,cvw) then
      //begin
      //  result:= cvw;
      //  exit;
      //end;
    End;
    Found := false;
    For I := 0 To FList.Count - 1 Do
    Begin
      With TEzSelectionLayer( FList[I] ) Do
      Begin
        If Not Layer.Active Then Continue;
        Extent:= Layer.GetExtensionForRecords(FSelList);
        if not EqualRect2d(Extent, INVALID_EXTENSION) then
        begin
          MaxBound( Result.Emax, Extent.Emax );
          MinBound( Result.Emin, Extent.Emin );
          Found := true;
        end;
      End;
    End;
    If found Then
    Begin
      // increase with the defaultpen width
      With FDrawBox.Grapher, Ez_Preferences.SelectionPen.FPenStyle Do
      Begin
        d1 := DistToRealX( 4 ); //IMax(6,getsizeinpoints(Scale)));
        d2 := DistToRealY( 4 ); //IMax(6,getsizeinpoints(Scale)));
        With Result Do
        Begin
          X1 := X1 - d1;
          X2 := X2 + d1;
          Y1 := Y1 - d2;
          Y2 := Y2 + d2;
        End;
      End;
    End;
    If IsBoxFullInBox2D( cvw, result ) Then
      result := cvw
    Else If IsBoxFullInBox2D( result, cvw ) Then
    Begin
      //result:=result
    End
    Else If IsBoxInBox2D( cvw, result ) Then
      result := IntersectRect2D( cvw, result );
  except
  
  end;
End;

Procedure TEzSelection.ApplySymbolStyle( Style: TEzSymbolTool; const Apply: TEzSymbolApply );
var
  SelLayer: TEzSelectionLayer;
  I,J: Integer;
  Entity: TEzEntity;
Begin
  If ( FDrawBox = Nil ) Or ( Count = 0 ) Then Exit;
  for I:=0 to Count-1 do
  begin
    SelLayer:= TEzSelectionLayer( FList[I] );
    for J:=0 to SelLayer.SelList.Count-1 do
    begin
      Entity:= SelLayer.Layer.LoadEntityWithRecno(SelLayer.SelList[J]);
      try
        if Entity is TEzPlace then
        begin
          if (Apply = []) or (saIndex in Apply) then
            TEzPlace(Entity).Symboltool.Index:= Style.Index;
          if (Apply = []) or (saRotangle in Apply) then
            TEzPlace(Entity).Symboltool.Rotangle:= Style.Rotangle;
          if (Apply = []) or (saHeight in Apply) then
            TEzPlace(Entity).Symboltool.Height:= Style.Height;
          SelLayer.Layer.UpdateEntity(SelLayer.SelList[J],Entity);
        end;
      finally
        Entity.Free;
      end;
    end;
  end;
End;

Procedure TEzSelection.ApplyPenStyle( Style: TEzPenTool; const Apply: TEzPenApply );
var
  SelLayer: TEzSelectionLayer;
  I,J: Integer;
  Entity: TEzEntity;
Begin
  If ( FDrawBox = Nil ) Or ( Count = 0 ) Then Exit;
  for I:=0 to Count-1 do
  begin
    SelLayer:= TEzSelectionLayer( FList[I] );
    for J:=0 to SelLayer.SelList.Count-1 do
    begin
      Entity:= SelLayer.Layer.LoadEntityWithRecno(SelLayer.SelList[J]);
      try
        if Entity is TEzOpenedEntity then
        begin
          if (Apply = []) or (paStyle in Apply) then
            TEzOpenedEntity(Entity).Pentool.Style:= Style.Style;
          if (Apply = []) or (paColor in Apply) then
            TEzOpenedEntity(Entity).Pentool.Color:= Style.Color;
          if (Apply = []) or (paWidth in Apply) then
            TEzOpenedEntity(Entity).Pentool.Width:= Style.Width;
          SelLayer.Layer.UpdateEntity(SelLayer.SelList[J],Entity);
        end;
      finally
        Entity.Free;
      end;
    end;
  end;
End;

Procedure TEzSelection.ApplyBrushStyle( Style: TEzBrushTool; const Apply: TEzBrushApply );
var
  SelLayer: TEzSelectionLayer;
  I,J: Integer;
  Entity: TEzEntity;
Begin
  If ( FDrawBox = Nil ) Or ( Count = 0 ) Then Exit;
  for I:=0 to Count-1 do
  begin
    SelLayer:= TEzSelectionLayer( FList[I] );
    for J:=0 to SelLayer.SelList.Count-1 do
    begin
      Entity:= SelLayer.Layer.LoadEntityWithRecno(SelLayer.SelList[J]);
      try
        if Entity is TEzClosedEntity then
        begin
          if (Apply = []) or (baPattern in Apply) then
            TEzClosedEntity(Entity).Brushtool.Pattern:= Style.Pattern;
          if (Apply = []) or (baForeColor in Apply) then
            TEzClosedEntity(Entity).Brushtool.ForeColor:= Style.ForeColor;
          if (Apply = []) or (baBackColor in Apply) then
            TEzClosedEntity(Entity).Brushtool.BackColor:= Style.BackColor;
          SelLayer.Layer.UpdateEntity(SelLayer.SelList[J],Entity);
        end;
      finally
        Entity.Free;
      end;
    end;
  end;
End;

Procedure TEzSelection.ApplyFontStyle( Style: TEzFontTool; const Apply: TEzFontApply );
var
  SelLayer: TEzSelectionLayer;
  I,J: Integer;
  Entity: TEzEntity;
Begin
  If ( FDrawBox = Nil ) Or ( Count = 0 ) Then Exit;
  for I:=0 to Count-1 do
  begin
    SelLayer:= TEzSelectionLayer( FList[I] );
    for J:=0 to SelLayer.SelList.Count-1 do
    begin
      Entity:= SelLayer.Layer.LoadEntityWithRecno(SelLayer.SelList[J]);
      try
        if Entity is TEzClosedEntity then
        begin
          if Entity is TEzFittedVectorText then
          begin
            with TEzFittedVectorText(Entity) do
            begin
              BeginUpdate;
              if (Apply = []) or (faName in Apply) then
                FontName:= Style.Name;
              if (Apply = []) or (faHeight in Apply) then
                Height:= Style.Height;
              if (Apply = []) or (faColor in Apply) then
                FontColor:= Style.Color;
              EndUpdate;
            end;
            SelLayer.Layer.UpdateEntity(SelLayer.SelList[J],Entity);
          end else if Entity is TEzJustifVectorText then
          begin
            with TEzJustifVectorText(Entity) do
            begin
              BeginUpdate;
              if (Apply = []) or (faName in Apply) then
                FontName:= Style.Name;
              if (Apply = []) or (faHeight in Apply) then
                Height:= Style.Height;
              if (Apply = []) or (faColor in Apply) then
                FontColor:= Style.Color;
              EndUpdate;
            end;
            SelLayer.Layer.UpdateEntity(SelLayer.SelList[J],Entity);
          end else if Entity is TEzTrueTypeText then
          begin
            with TEzTrueTypeText(Entity) do
            begin
              BeginUpdate;
              if (Apply = []) or (faName in Apply) then
                FontTool.Name:= Style.Name;
              if (Apply = []) or (faAngle in Apply) then
                FontTool.Angle:= Style.Angle;
              if (Apply = []) or (faHeight in Apply) then
                FontTool.Height:= Style.Height;
              if (Apply = []) or (faColor in Apply) then
                FontTool.Color:= Style.Color;
              if (Apply = []) or (faStyle in Apply) then
                FontTool.Style:= Style.Style;
              EndUpdate;
            end;
            SelLayer.Layer.UpdateEntity(SelLayer.SelList[J],Entity);
          end;
        end;
      finally
        Entity.Free;
      end;
    end;
  end;
End;

{------------------------------------------------------------------------------}
{                  The Undo object and aux classes                             }
{------------------------------------------------------------------------------}

Constructor TEzUndoSingle.Create( DrawBox: TEzBaseDrawBox );
Begin
  Inherited Create;
  FDrawBox := DrawBox;
  with GetUndoStream do
    try
      Read(FLastOffset,sizeof(Integer));
    finally
      Free;
    end;
  FMustReset:= True;
End;

Destructor TEzUndoSingle.Destroy;
Begin
  If FMustReset Then
    with GetUndoStream do
      Try
        Write(FLastOffset, sizeof(Integer));
      Finally
        Free;
      End;
  Inherited Destroy;
End;

Function TEzUndoSingle.GetUndoStream: TStream;
Begin
  Result:= TFileStream.Create(FDrawBox.FUndo.FUndoFileName, fmOpenReadWrite or fmShareDenyNone);
End;

Procedure TEzUndoSingle.BeginUndo(GlobalUndoAction: TEzUndoAction);
Begin
  FGlobalUndoAction:= GlobalUndoAction;
  FTempStream:= GetUndoStream;
  FTempStream.Position:= FLastOffset;
  FCount:= 0;
End;

Procedure TEzUndoSingle.AddUndo( Layer: TEzBaseLayer; Recno: Integer;
  UndoAction: TEzUndoAction );
Var
  Entity: TEzEntity;
  EntityID: TEzEntityID;
Begin
  Entity := Nil;
  If UndoAction = uaUnTransform Then
  Begin
    Entity := Layer.LoadEntityWithRecNo( RecNo );
    If Entity = Nil then Exit;
  End;
  with FTempStream do
  begin
    Write( UndoAction, SizeOf(UndoAction));
    EzWriteStrToStream( Layer.Name, FTempStream );
    Write(Recno,Sizeof(Recno));
    { now write the needed undo information }
    If UndoAction = uaUntransform Then
    Begin
      EntityID := Entity.EntityID;
      Write(EntityID, SizeOf(EntityID));
      Entity.SaveToStream(FTempStream);
      Entity.Free;
    End;
  End;
  Inc(FCount);
End;

Procedure TEzUndoSingle.EndUndo;
var
  n: Integer;
Begin
  with FTempStream do
  begin
    { now write the next available offset }
    n:= Position;
    Position:= 0;
    Write(n,Sizeof(n));
    Free;
  end;
End;

Procedure TEzUndoSingle.AddUnTransformFromSelection;
Var
  I, J, n: Integer;
  Layer: TEzBaseLayer;
  SelLayer: TEzSelectionLayer;
Begin
  BeginUndo( uaUnTransform );
  Try
    With FDrawBox Do
    Begin
      n := Selection.Count;
      For I := 0 To n - 1 Do
      begin
        SelLayer := Selection[I];
        Layer := SelLayer.Layer;
        if Layer.LayerInfo.Locked then Continue;
        For J := 0 To SelLayer.SelList.Count - 1 Do
          AddUndo( Layer, SelLayer.SelList[J], uaUnTransform );
      end;
    end;
  Finally
    EndUndo;
  End;
End;

Procedure TEzUndoSingle.AddUnTransform( Layer: TEzBaseLayer; RecNo: Integer );
Begin
  BeginUndo( uaUnTransform );
  try
    AddUndo( Layer, Recno, uaUnTransform );
  finally
    EndUndo;
  end;
End;

Procedure TEzUndoSingle.AddUnDeleteFromSelection;
Var
  I,J: Integer;
  Layer: TEzBaseLayer;
  SelLayer: TEzSelectionLayer;
Begin
  BeginUndo(uaUnDelete);
  Try
    With FDrawBox Do
    Begin
      For I := 0 To Selection.Count - 1 Do
      begin
        SelLayer := Selection[I];
        Layer := SelLayer.Layer;
        if Layer.LayerInfo.Locked then Continue;
        For J := 0 To SelLayer.SelList.Count - 1 Do
          AddUndo( Layer, SelLayer.SelList[J], uaUnDelete );
      end;
    end;
  Finally
    EndUndo;
  End;
End;

Procedure TEzUndoSingle.Undo;
Var
  Entity: TEzEntity;
  EntityID: TEzEntityID;
  I: Integer;
  Action: TEzUndoAction;
  LayerName: string;
  Recno: Integer;
  Stream: TStream;
  TmpClass: TEzEntityClass;
  Layer: TEzBaseLayer;
Begin
  If FCount = 0 Then Exit;
  Stream:= GetUndoStream;
  with Stream do
    try
      Position:= FLastOffset;
      For I:= 1 to FCount do
      Begin
        Read(Action, SizeOf(TEzUndoAction));
        Layername:= EzReadStrFromStream( Stream );
        Read(Recno,Sizeof(Integer));
        Entity:= Nil;
        If Action = uaUnTransform Then
        Begin
          Read(EntityID, Sizeof(TEzEntityID));
          TmpClass := GetClassFromID( EntityID );
          Entity:= TmpClass.Create( 1 );
          Entity.LoadFromStream( Stream );
        End;
        Layer := FDrawBox.GIS.Layers.LayerByName( Layername );
        If Layer = Nil Then Continue;
        Case Action Of
          uaUndelete :
            Layer.UndeleteEntity( Recno );
          uaDelete :
            Layer.DeleteEntity( Recno );
          uaUnTransform :
            Begin
              Layer.UpdateEntity( Recno, Entity );
              Entity.Free;
            End;
        End;
      End;
    finally
      free;
    end;
End;

Function TEzUndoSingle.GetVerb: String;
Begin
  Case FGlobalUndoAction Of
    uaUndelete: result := SUndoDelete;
    uaDelete: result := SUndoInsert;
    uaUnTransform: result := SUndoTransform;
  Else
    result := SCannotUndo;
  End;
End;

{ TEzUndoPool }

Constructor TEzUndoPool.Create( DrawBox: TEzBaseDrawBox );
var
  n: Integer;
Begin
  Inherited Create;
  FDrawBox := DrawBox;
  FList := TList.Create;
  FUndoLimit := 1000;
  FUndoFileName := GetTemporaryFileName( '~EZ' );
  // recreate file
  with TFileStream.Create(FUndoFileName, fmCreate) do
    try
      n:= Sizeof(Integer);
      Write(n,Sizeof(n));
    finally
      Free;
    end;
End;

Destructor TEzUndoPool.Destroy;
Begin
  Clear;
  FList.Free;
  If FileExists(FUndoFileName) Then
    SysUtils.DeleteFile(FUndoFileName);
  Inherited Destroy;
End;

Procedure TEzUndoPool.SetUndoLimit( Value: Integer );
Begin
  If Value < 1 Then Exit;
  FUndoLimit := Value;
  AdjustStack;
End;

Procedure TEzUndoPool.AdjustStack;
Var
  u: TEzUndoSingle;
  I: Integer;
Begin
  If FList.Count = 0 Then Exit;
  If FList.Count > FUndoLimit Then
    For I := 0 To FUndoLimit - 1 Do
    Begin
      u := FList[0];
      u.FMustReset:= False;
      u.Free;
      FList.Delete( 0 );
    End;
End;

Procedure TEzUndoPool.AddUnDeleteFromSelection;
Var
  u: TEzUndoSingle;
Begin
  AdjustStack;
  u := TEzUndoSingle.Create( FDrawBox );
  u.AddUnDeleteFromSelection;
  FList.Add( u );
End;

Procedure TEzUndoPool.AddUnTransformFromSelection;
Var
  u: TEzUndoSingle;
Begin
  AdjustStack;
  u := TEzUndoSingle.Create( FDrawBox );
  u.AddUnTransformFromSelection;
  FList.Add( u );
End;

Procedure TEzUndoPool.AddUnTransform( Layer: TEzBaseLayer; RecNo: Integer );
Var
  u: TEzUndoSingle;
Begin
  AdjustStack;
  u := TEzUndoSingle.Create( FDrawBox );
  u.AddUnTransform( Layer, Recno );
  FList.Add( u );
End;

Procedure TEzUndoPool.BeginUndo( GlobalUndoAction: TEzUndoAction );
Var
  u: TEzUndoSingle;
Begin
  AdjustStack;
  u := TEzUndoSingle.Create( FDrawBox );
  u.BeginUndo( GlobalUndoAction );
  FList.Add( u );
  FMulti := u;
End;

Procedure TEzUndoPool.AddUndo( Layer: TEzBaseLayer; RecNo: Integer; Action: TEzUndoAction );
Begin
  If FMulti = Nil Then exit;
  FMulti.AddUndo( Layer, Recno, Action );
End;

Procedure TEzUndoPool.EndUndo;
Begin
  If FMulti = Nil Then Exit;
  FMulti.EndUndo;
  FMulti := Nil;
End;

Function TEzUndoPool.CanUndo: boolean;
Begin
  Result := FList.Count > 0;
End;

Procedure TEzUndoPool.Undo;
Var
  u: TEzUndoSingle;
Begin
  If FList.Count = 0 Then Exit;
  u := FList[FList.Count - 1];
  u.Undo;
  u.Free;
  FList.Delete( FList.Count - 1 );
End;

Procedure TEzUndoPool.Pop;
Var
  u: TEzUndoSingle;
Begin
  If FList.Count = 0 Then Exit;
  u := FList[FList.Count - 1];
  u.Free;
  FList.Delete( FList.Count - 1 );
End;

Function TEzUndoPool.GetVerb: String;
Var
  u: TEzUndoSingle;
Begin
  result := SCannotUndo;
  If FList.Count = 0 Then Exit;
  u := FList[FList.Count - 1];
  Result := u.GetVerb;
End;

const
  EZGISDATA = 'CF_EZGIS'; // constant to register the format to the clipboard

Var
  CF_EZGISDATA : Word;

Procedure TEzUndoPool.CopyToClipboardFromSelection;
Var
  I,J,n: Integer;
  Layer: TEzBaseLayer;
  SelLayer: TEzSelectionLayer;
  Entity: TEzEntity;
  Data: THandle;
  DataPtr: Pointer;
  Stream: TMemoryStream;
  EntityID: TEzEntityID;
Begin
  { this will copy to the clipboard in special format }
  Stream:= TMemoryStream.Create;
  Try
    // write all the selection, to the memory stream
    n:= 0;
    Stream.Write(n,Sizeof(n));
    For I := 0 To FDrawBox.Selection.Count - 1 Do
    begin
      SelLayer := FDrawBox.Selection[I];
      Layer := SelLayer.Layer;
      if Layer.LayerInfo.Locked then Continue;
      For J := 0 To SelLayer.SelList.Count - 1 Do
      begin
        Entity := Layer.LoadEntityWithRecNo( SelLayer.SelList[J] );
        If Entity=Nil Then Continue;
        Try
          EntityID:= Entity.EntityID;
          Stream.Write(EntityID,Sizeof(EntityID));
          Entity.SaveToStream(Stream);
          Inc(n);
        Finally
          Entity.Free;
        End;
      end;
      Stream.Position:= 0;
      Stream.Write(n,Sizeof(n));
    end;
    // now write to clipboard
    Data:= GlobalAlloc(GMEM_MOVEABLE, Stream.Size);
    Try
      DataPtr := GlobalLock( Data );
      Try
        Move( Stream.Memory^, DataPtr^, Stream.Size );
        //Clipboard.Open;
        Clipboard.SetAsHandle(CF_EZGISDATA, Data);
        //Clipboard.Close;
      Finally
        GlobalUnlock(Data);
      End;
    Except
      GlobalFree(Data);
      raise;
    End;
  Finally
    Stream.Free;
  end;
End;

Function TEzUndoPool.CanPaste: Boolean;
Begin
  Result:= Clipboard.HasFormat(CF_EZGISDATA);
End;

Procedure TEzUndoPool.PasteFromClipboardTo(GIS: TEzBaseGIS=Nil);
Var
  Data: THandle;
  DataPtr: Pointer;
  I, n, Size: Integer;
  Stream: TMemoryStream;
  Layer: TEzBaseLayer;
  EntityID: TEzEntityID;
  Entity: TEzEntity;
  TmpClass: TEzEntityClass;
Begin
  If Not CanPaste Then Exit;

  If GIS = Nil Then
    Layer:= FDrawBox.GIS.CurrentLayer
  Else
    Layer:= GIS.CurrentLayer;
  If Layer=Nil then Exit;

  Data := Clipboard.GetAsHandle(CF_EZGISDATA);
  If Data=0 Then Exit;

  Stream:= TMemoryStream.Create;
  DataPtr:= GlobalLock(Data);
  Try
    Size:= GlobalSize(Data);
    Stream.Size:= Size;
    Move(DataPtr^, Stream.Memory^, Size);
    // now read all the entities
    Stream.Position:= 0;
    Stream.Read(n,Sizeof(n));
    For I:=1 to n do
    Begin
      Stream.Read(EntityID, Sizeof(TEzEntityID));
      TmpClass := GetClassFromID( EntityID );
      Entity:= TmpClass.Create( 1 );
      Try
        Entity.LoadFromStream( Stream );
        Layer.AddEntity( Entity );
      Finally
        Entity.Free;
      End;
    End;
  Finally
    GlobalUnlock(Data);
    Stream.Free;
  End;
End;

Procedure TEzUndoPool.Clear(Clean: Boolean=False);
Var
  I, n: Integer;
Begin
  // first clear the internal "clipboard"
  For I := FList.Count - 1 downto 0 Do
    TEzUndoSingle( FList[I] ).Free;
  FList.Clear;
  If Clean Then
  Begin
    // recreate file
    with TFileStream.Create(FUndoFileName, fmCreate) do
      try
        n:= Sizeof(Integer);
        Write(n,Sizeof(n));
      finally
        Free;
      end;

    // now delete the Windows clipboard memory used
    Clipboard.Clear;
  End;
End;

{------------------------------------------------------------------------------}
{                  TEzEntity main entities class                             }
{------------------------------------------------------------------------------}

Var
  EntitiesRegistered: Array[TEzEntityID] Of TEzEntityClass;

Function GetClassFromID( EntityID: TEzEntityID ): TEzEntityClass;
Begin
  Result := EntitiesRegistered[EntityID];
End;

{function GetIDFromClass(EntityClass: TClass): TEzEntityID;
begin
  for Result:= Low(TEzEntityID) to High(TEzEntityID) do
    if EntityClass = EntitiesRegistered[Result] then Exit;
  Result:=idNone;
end;}

Procedure RegisterEntitiesClasses;
Begin
  EntitiesRegistered[idNone]           := TEzNone;
  EntitiesRegistered[idPoint]          := TEzPointEntity;
  EntitiesRegistered[idPlace]          := TEzPlace;
  EntitiesRegistered[idPolyline]       := TEzPolyLine;
  EntitiesRegistered[idPolygon]        := TEzPolygon;
  EntitiesRegistered[idRectangle]      := TEzRectangle;
  EntitiesRegistered[idArc]            := TEzArc;
  EntitiesRegistered[idEllipse]        := TEzEllipse;
  EntitiesRegistered[idPictureRef]     := TEzPictureRef;
  EntitiesRegistered[idPersistBitmap]  := TEzPersistBitmap;
  EntitiesRegistered[idBandsBitmap]    := TEzBandsBitmap;
  EntitiesRegistered[idBandsTiff]      := TEzBandsBitmap;   // for future use
  EntitiesRegistered[idSpline]         := TEzSpline;
  EntitiesRegistered[idTable]          := TEzTableEntity;
  EntitiesRegistered[idGroup]          := TEzGroupEntity;
  EntitiesRegistered[idTrueTypeText]   := TEzTrueTypeText;
  EntitiesRegistered[idAlignedTTText]   := TEzAlignedTTText;
  EntitiesRegistered[idJustifVectText] := TEzJustifVectorText;
  EntitiesRegistered[idFittedVectText] := TEzFittedVectorText;
  EntitiesRegistered[idDimHorizontal]  := TEzDimHorizontal;
  EntitiesRegistered[idDimVertical]    := TEzDimVertical;
  EntitiesRegistered[idDimParallel]    := TEzDimParallel;
  EntitiesRegistered[idRtfText]        := TEzRtfText;
  EntitiesRegistered[idBlockInsert]    := TEzBlockInsert;
  EntitiesRegistered[idSplineText]     := TEzSplineText;
  EntitiesRegistered[idCustomPicture]  := TEzCustomPicture;
  EntitiesRegistered[idNode]           := TEzNode;
  EntitiesRegistered[idNodeLink]       := TEzNodeLink;
{$IFDEF ER_MAPPER}
  EntitiesRegistered[idERMapper]       := EzERMapper.TEzERMapper;
{$ENDIF}
  EntitiesRegistered[idPreview]        := TEzPreviewEntity;
  EntitiesRegistered[idMap500]         := TEzMap500Entity;
  EntitiesRegistered[idCadastralBlock] := TEzCadastralBlockEntity;
  EntitiesRegistered[idAxis]           := TEzAxis;
  EntitiesRegistered[idPrintArea]      := TEzPrintArea;
  EntitiesRegistered[idPage]           := TEzPageEntity;
  EntitiesRegistered[idRtfText2]       := TEzRtfText2;
  EntitiesRegistered[idAlignedText2]   := TEzAlignedText2;
  EntitiesRegistered[idBitmapRef]      := TEzBitmapRef;
  EntitiesRegistered[idSquareText]      := TEzSquareText;
End;

{ TEzEntity class implementaton }

Constructor TEzEntity.Create( NPts: Integer; CanGrow: Boolean = True );
Begin
  Inherited Create;
  FBox := INVALID_EXTENSION;//Rect2D( MINCOORD, MINCOORD, MAXCOORD, MAXCOORD );

  { Create the internal vector }
  If Npts <= 0 Then Npts := 1;
  FPoints := TEzVector.Create( NPts );
  FPoints.CanGrow:= CanGrow;

  { initialize the entity }
  Initialize;

  FOriginalSize := -1;
  FSelectedVertex := -1;
  FPoints.OnChange := UpdateExtension;

End;

Destructor TEzEntity.Destroy;
Begin
  If FPoints <> Nil Then
    FPoints.Free;
  If FTransformMatrix <> Nil Then
    FreeMem( FTransformMatrix, SizeOf( TEzMatrix ) );
  Inherited Destroy;
End;

Procedure TEzEntity.Initialize;
begin
end;

Procedure TEzEntity.BeginUpdate;
Begin
  FPoints.DisableEvents:= True;
End;

Procedure TEzEntity.EndUpdate;
Begin
  FPoints.DisableEvents:= False;
  UpdateExtension;
End;

Procedure TEzEntity.LoadFromStream( Stream: TStream );
Begin
  Stream.Read( ID, SizeOf( ID ) );
  FPoints.LoadFromStream( Stream );
End;

Procedure TEzEntity.SaveToStream( Stream: TStream );
Begin
  Stream.Write( ID, SizeOf( ID ) );
  FPoints.SaveToStream( Stream );
End;

Function TEzEntity.GetDrawPoints: TEzVector;
Begin
  Result := FPoints;
End;

Procedure TEzEntity.Centroid( Var CX, CY: Double );
Var
  CG: TEzPoint;
Begin
  EzLib.FindCG( GetDrawPoints, CG, Self.IsClosed );
  CX := CG.X;
  CY := CG.Y;
End;

Function TEzEntity.Area: Double;
Begin
  Result := 0;
End;

Function TEzEntity.Perimeter: Double;
Begin
  Result := EzSystem.Perimeter( GetDrawPoints, false );
End;

Function TEzEntity.GetControlPointType( Index: Integer ): TEzControlPointType;
Begin
  result := cptNode;
End;

Function TEzEntity.GetControlPoints(TransfPts: Boolean; Grapher: TEzGrapher=Nil): TEzVector;
Begin
  { the default is to return the FPoints}
  Result := FPoints;
End;

Procedure TEzEntity.UpdateControlPoint( Index: Integer; Const Value: TEzPoint; Grapher: TEzGrapher=Nil);
Begin
  { this is the default behaviour }
  If Index > FPoints.Count - 1 Then Exit;
  FPoints[Index] := Value;
End;

Procedure TEzEntity.UpdateExtensionFromControlPts;
Begin
  { by default, call to UpdateExtension method.
    Other descendant can do its own action }
  UpdateExtension;
End;

Procedure TEzEntity.DrawControlPoints( Grapher: TEzGrapher;
  Canvas: TCanvas; Const VisualWindow: TEzRect; TransfPts: Boolean;
  DefaultPaint: Boolean = True; HideVertexNumber: Boolean = False );
Var
  Pt: TEzPoint;
  TmpPt: TPoint;
  I, Wdt, SelWdt, RotWdt, UseWdt: Integer;
  EntID: TEzEntityID;
  ControlPoints: TEzVector;
  IsEqual: Boolean;
  CtlPtType: TEzControlPointType;
  MovePt: TPoint;
  MovePtFound: Boolean;
Begin
  EntID := GetEntityID;
  With Ez_Preferences.DefFontStyle Do
  Begin
    Canvas.Font.Name := Name;
    Canvas.Font.Color := Color;
  End;
  If DefaultPaint then
  begin
    Canvas.Pen.Style:= psSolid;
    Canvas.Pen.Color:= clBlack;
    Canvas.Brush.Style:= bsSolid;
    Canvas.Brush.Color:= clLime;
  end;
  Canvas.Font.Size := 6;
  ControlPoints := GetControlPoints(TransfPts, Grapher);
  IsEqual := (FPoints.Count > 1) And FuzzEqualPoint2D( FPoints[0], FPoints[FPoints.Count - 1] );
  { returning nil means no control points can be edited }
  If ControlPoints = Nil Then Exit;
  Try
    MovePtFound := false;
    Wdt := Ez_Preferences.ControlPointsWidth Div 2;
    RotWdt := MulDiv( Wdt, 2, 3 );
    SelWdt := MulDiv( Wdt, 4, 3 );
    For I := 0 To ControlPoints.Count - 1 Do
    Begin
      If IsEqual And ( I = FPoints.Count - 1 ) Then Continue;
      Pt := TransformPoint2D( ControlPoints[I], Self.GetTransformMatrix );
      If Not IsPointInBox2D( Pt, VisualWindow ) Then Continue;
      TmpPt := Grapher.RealToPoint( Pt );
      CtlPtType := GetControlPointType( I );
      if Not( (FControlPointsToShow = []) Or
              (CtlPtType in FControlPointsToShow) ) Then Continue;

      { check what control points to draw }
      If CtlPtType = cptRotate Then
        UseWdt := RotWdt
      Else If ( CtlPtType = cptNode ) And ( I = FSelectedVertex ) Then
        UseWdt := SelWdt
      Else
        UseWdt := Wdt;
      Canvas.Pen.Style := psSolid;
      With TmpPt Do
        If CtlPtType = cptNode Then
          Canvas.Rectangle( X - UseWdt, Y - UseWdt, X + UseWdt, Y + UseWdt )
        Else If CtlPtType = cptMove Then
        Begin
          Canvas.Ellipse( X - UseWdt, Y - UseWdt, X + UseWdt, Y + UseWdt );
          Canvas.MoveTo( X, Y - UseWdt );
          Canvas.LineTo( X, Y + UseWdt );
          Canvas.MoveTo( X - UseWdt, Y );
          Canvas.LineTo( X + UseWdt, Y );
          MovePt := TmpPt;
          MovePtFound := true;
        End
        Else If ( CtlPtType = cptRotate ) And MovePtFound Then
        Begin
          Canvas.Ellipse( X - UseWdt, Y - UseWdt, X + UseWdt, Y + UseWdt );
          Canvas.MoveTo( MovePt.X, MovePt.Y );
          Canvas.LineTo( X, Y );
        End;
      { now draw the node's number }
      If Not HideVertexNumber And Not ( EntID In [idPlace, idJustifVectText, idFittedVectText] ) Then
      Begin
        If I <> FSelectedVertex Then
          Canvas.TextOut( TmpPt.X + UseWdt + 1, TmpPt.Y + UseWdt + 1, IntToStr( I + 1 ) );
      End;
    End;
  Finally
    If ControlPoints <> FPoints Then
      ControlPoints.Free;
  End;
End;

Procedure TEzEntity.UpdateExtension;
Begin
  If FPoints = Nil Then Exit;
  { Change the extension. }
  FBox := ReorderRect2D( TransformBoundingBox2D( Points.Extension, self.GetTransformMatrix ) );
End;

Function TEzEntity.NeedReposition: Boolean;
Begin
  Result := ( FOriginalSize >= 0 ) And ( Self.StorageSize > FOriginalSize );
End;

Function TEzEntity.Clone: TEzEntity;
Begin
  Result := GetClassFromID(GetEntityID).Create(EzLib.Imax(1, Points.Count));
  Result.Assign(Self);
End;

Procedure TEzEntity.Assign( Source: TEzEntity );
Var
  Stream: TMemoryStream;
Begin
  If Not ( Source.EntityID = Self.EntityID ) Then Exit;
  self.SetTransformMatrix( Source.GetTransformMatrix );
  stream := TMemoryStream.Create;
  Try
    Source.SaveToStream( stream );
    stream.seek( 0, 0 );
    Self.LoadFromStream( stream );
    ExtID := Source.ExtID;
  Finally
    stream.free;
  End;
End;

Procedure TEzEntity.MoveTo( Const Pt, DragPt: TEzPoint );
Var
  TmpMatrix: TEzMatrix;
Begin
  TmpMatrix := Translate2D( Pt.X - DragPt.X, Pt.Y - DragPt.Y );
  SetTransformMatrix( MultiplyMatrix2D( Self.GetTransformMatrix, TmpMatrix ) );
  UpdateExtension;
End;

Function TEzEntity.HasTransform: Boolean;
Begin
  Result := Assigned(FTransformMatrix);
End;

Function TEzEntity.GetTransformMatrix: TEzMatrix;
Begin
  if Assigned(FTransformMatrix) then
    Result := FTransformMatrix^
  else
    Result := IDENTITY_MATRIX2D;
End;

Procedure TEzEntity.SetTransformMatrix( Const Matrix: TEzMatrix );
Begin
  If EqualMatrix2D( Matrix, IDENTITY_MATRIX2D ) Then
  Begin
    If FTransformMatrix <> Nil Then
      FreeMem( FTransformMatrix, SizeOf( TEzMatrix ) );
    FTransformMatrix := Nil;
    Exit;
  End;
  If FTransformMatrix = Nil Then
  Begin
    GetMem( FTransformMatrix, SizeOf( TEzMatrix ) );
    FTransformMatrix^ := Matrix;
  End
  Else
    FTransformMatrix^ := Matrix;
  UpdateExtension;
End;

Procedure TEzEntity.ApplyTransform;
Var
  Cnt: Integer;
Begin
  For Cnt := 0 To FPoints.Count - 1 Do
    FPoints[Cnt] := TransformPoint2D( FPoints[Cnt], Self.GetTransformMatrix );
  Self.SetTransformMatrix( IDENTITY_MATRIX2D );
  UpdateExtension;
End;

Function TEzEntity.IsClosed: Boolean;
Begin
  result := False;
End;

Function TEzEntity.IsVisible( Const Clip: TEzRect ): Boolean;
Begin
  If EntityID = idNone Then
  Begin
    result := False;
    Exit;
  End;
  If EntityID in [idPlace, idPoint] Then
    Result := IsRectVisibleForPlace( FBox, Clip )
  Else
    Result := IsRectVisible( FBox, Clip );
End;

Function TEzEntity.PointCode( Const Pt: TEzPoint; Const Aperture: Double;
  Var Distance: Double; SelectPickingInside: Boolean; UseDrawPoints: Boolean = True ): Integer;
Var
  I: Integer;
  MinDist: Double;
  V: TEzVector;
Begin
  { PICKED_NONE     - not on entity
    PICKED_INTERIOR - point inside entity
    PICKED_POINT    - point on any segment
    > = 0           - point on that entity point }
  Result := PICKED_NONE;
  MinDist := Aperture + 1.0;
  If UseDrawPoints Then
    V := GetDrawPoints
  Else
    V := Points;
  For I := 0 To V.Count - 1 Do
    If IsNearPoint2D( Pt, TransformPoint2D( V[I], Self.GetTransformMatrix ), Aperture, Distance ) And
      ( Distance < MinDist ) Then
    Begin
      Result := I;
      MinDist := Distance;
      Ez_Preferences.GNumPoint := I;
    End;
End;

Procedure TEzEntity.ShowDirection( Grapher: TEzGrapher; Canvas: TCanvas;
  Const Clip: TEzRect; DrawMode: TEzDrawMode; DirectionPos: TEzDirectionpos;
  Const DirectionPen: TEzPenStyle; Const DirectionPenScale: Double;
  Const DirectionBrush: TEzBrushStyle;
  RevertDirection: Boolean );
Begin
  // nothing to do here
End;

Function TEzEntity.CompareAgainst( Entity: TEzEntity; aOperator: TEzGraphicOperator ): Boolean;

  Function HaveCommonPoint: Boolean;
  Var
    I, J: Integer;
    SelfPoints, EntityPoints: TEzVector;
  Begin
    HaveCommonPoint:= False;
    SelfPoints:= Self.DrawPoints;
    EntityPoints:= Entity.Drawpoints;
    for I:= 0 to SelfPoints.Count-1 do
      for J:= 0 to EntityPoints.Count-1 do
        if EqualPoint2d( SelfPoints[I], EntityPoints[J] ) then
        Begin
          HaveCommonPoint:= true;
          Exit;
        End;
  End;

  Function HaveEdgeTouched: Boolean;
  var
    IntVect: TEzVector;
    TmpDistance: Double;
    Min1, Min2: TEzPoint;
  Begin
    IntVect:= TEzVector.Create( 4 );
    Try
      { si se intersectan entonces no cumplen }
      If Self.IsInsideEntity( Entity, False ) Or
         Entity.IsInsideEntity( Self, False ) then
      begin
        HaveEdgeTouched:= False;
        Exit;
      end;
      HaveEdgeTouched:= VectIntersect( Self.DrawPoints, Entity.DrawPoints, IntVect, True,true );
      If Not HaveEdgeTouched Then
      Begin
        { busca si estan en una minima distancia }
        EzLib.GetMinimumDistance2D( Self.DrawPoints, Entity.DrawPoints, TmpDistance, Min1, Min2 );
        HaveEdgeTouched:= TmpDistance <= 1E-6;
      End;
    Finally
      IntVect.Free;
    End;
  End;

var
  I, J: Integer;
  sP1, sP2, eP1, eP2: TEzPoint;
  CX, CY: Double;
Begin
  Result:= False;
  case aOperator of
    goWithin:
      { Self is partial/fully inside Entity if its centroid is inside also }
      Result:= Self.IsInsideEntity( Entity, false );
    goEntirelyWithin:
      { Self is fully inside Entity if its centroid is inside also }
      Result:= Self.IsInsideEntity( Entity, true );
    goContains:
      { Entity is partial/fully inside Self if its centroid is inside also }
      Result:= Entity.IsInsideEntity( Self, false );
    goContainsEntire:
      { Entity is fully inside Self if its centroid is inside also }
      Result:= Entity.IsInsideEntity( Self, true );
    goIntersects:
      { Self intersects entity . if self is fully inside entity or
        entity is fully inside self is considered intersection }
      Result:= Entity.IntersectEntity( Self, True );
    goEntirelyWithinNoEdgeTouched:
      Result:= (Not HaveEdgeTouched) And Self.IsInsideEntity( Entity, True );
    goContainsEntireNoEdgeTouched:
      Result:= (Not HaveEdgeTouched) And Entity.IsInsideEntity( Self, True );
    goLineCross:
      { Returns true if self intersects to entity }
      Result:= Entity.IntersectEntity( Self, False );
    goExtentOverlaps:
      { Returns true if self extents overlap entity extent  }
      Result:= IsBoxInBox2D( Self.Points.Extension, Entity.Points.Extension );
    goShareCommonPoint:
      { Returns if Self share at least one identical common point with Entity }
      Result:= HaveCommonPoint;
    goCommonPointOrLineCross:
      { Returns true if both operations }
      Result:= HaveCommonPoint Or Self.IntersectEntity( Entity, False );
    goEdgeTouch:
      Result:= HaveEdgeTouched;
    goEdgeTouchOrIntersect:
      Result:= Self.IntersectEntity( Entity, false) Or HaveEdgeTouched;
    goShareCommonLine:
      Begin
        Result:= false;
        for I:= 0 to Self.Points.Count-2 do
        begin
          sP1:= Self.Points[I];
          sP2:= Self.Points[I+1];
          for J:= 0 to Entity.Points.Count - 2 do
          begin
            eP1:= Entity.Points[J];
            eP2:= Entity.Points[J+1];
            if ( EqualPoint2d( sP1, eP1 ) And EqualPoint2d( sP2, eP2 ) ) Or
               ( EqualPoint2d( sP1, eP2 ) And EqualPoint2d( sP2, eP1 ) ) Then
            Begin
              Result:= true;
              Exit;
            End;
          end;
        end;
      End;
    goPointInPolygon:
      begin
        { if first point of entity is inside polygon entity }
        Result:= false;
        If Not Entity.IsClosed Or ( Self.Points.Count < 1 ) then Exit;
        Result:= Entity.IsPointInsideMe( Self.Points[0].X, Self.Points[0].Y );
      End;
    goCentroidInPolygon:
      Begin
        { return true if self centroid is inside polygon entity }
        Result:= false;
        If Not Entity.IsClosed Or ( Self.Points.Count < 1 ) then Exit;
        Self.Centroid( CX, CY );
        Result:= Entity.IsPointInsideMe( CX, CY );
      End;
    goIdentical:
      Result:= Self.Points.IsEqualTo( Entity.Points );
  End;
End;

Function TEzEntity.IsInsideEntity( _OtherEntity: TEzEntity;
  _FullInside: Boolean ): Boolean;
Var
  pc, cnt, Idx1, Idx2, n, np: Integer;
  oe_cnt, oe_Idx1, oe_Idx2, oe_n, oe_np: Integer;
  Distance: Double;
  Vector, TmpV1, TmpV2, TmpV3: TEzVector;
  AtLeastOnePointIsInside, NoIntersection: Boolean;
  Dist: Double;
Begin
  If FPoints.Parts.Count < 2 Then
  begin
    If ( FPoints.Count = 1 ) And (_OtherEntity.FPoints.Count = 1) Then
    Begin
      Result:= EqualPoint2d( FPoints[0], _OtherEntity.FPoints[0] );
      Exit;
    End;
    If (FPoints.Count = 1) And (_OtherEntity.FPoints.Count > 1) then
    begin
      Result:= _OtherEntity.GetDrawPoints.PointInPolygon2D( FPoints[0], Dist,
        0, GetTransformMatrix) >= PICKED_INTERIOR;
      Exit;
    end;
    If (_OtherEntity.FPoints.Count = 1) And (FPoints.Count > 1) then
    begin
      Result:= GetDrawPoints.PointInPolygon2D( _OtherEntity.FPoints[0], Dist,
        0, GetTransformMatrix) >= PICKED_INTERIOR;
      Exit;
    End;
  End;

  If FPoints.Parts.Count < 2 Then
    Vector := GetDrawPoints
  Else
    Vector := FPoints;
  np := Vector.Parts.Count;
  n := 0;
  If np < 2 Then
  Begin
    Idx1 := 0;
    Idx2 := Vector.Count - 1;
  End
  Else
  Begin
    Idx1 := Vector.Parts[n];
    Idx2 := Vector.Parts[n + 1] - 1;
  End;
  Repeat
    AtLeastOnePointIsInside := false;
    For cnt := Idx1 To Idx2 Do
    Begin
      pc := _OtherEntity.PointCode( Vector[cnt], 0.0, Distance, True );
      If pc >= PICKED_INTERIOR Then
      Begin
        AtLeastOnePointIsInside := true;
        Break;
      End;
    End;
    { check if it is fully inside }
    NoIntersection := true;
    { if there is no intersection between this entity and _OtherEntity,
      then this entity is not fully inside _OtherEntity }
    TmpV1 := TEzVector.Create( 2 );
    TmpV2 := TEzVector.Create( 4 );
    TmpV3 := TEzVector.Create( 2 );
    Try
      For cnt := Idx1 To Idx2 - 1 Do
      Begin
        TmpV1.Clear;
        TmpV1.Add( Vector[cnt] );
        TmpV1.Add( Vector[cnt + 1] );

        oe_np := _OtherEntity.Points.Parts.Count;
        oe_n := 0;
        If oe_np < 2 Then
        Begin
          oe_Idx1 := 0;
          oe_Idx2 := _OtherEntity.Points.Count - 1;
        End
        Else
        Begin
          oe_Idx1 := _OtherEntity.Points.Parts[0];
          oe_Idx2 := _OtherEntity.Points.Parts[1] - 1;
        End;
        Repeat
          TmpV2.Clear;
          For oe_cnt := oe_Idx1 To oe_Idx2 Do
          Begin
            TmpV2.Add( _OtherEntity.Points[oe_cnt] );
          End;
          { if this segment of this entity intersects to this part
            of the other entity, then it is not fully inside }
          If VectIntersect( TmpV1, TmpV2, TmpV3, True,true ) Then
          Begin
            NoIntersection := false;
            Break;
          End;
          If oe_np < 2 Then break;

          Inc( oe_n );
          If oe_n >= oe_np Then Break;

          oe_Idx1 := _OtherEntity.Points.Parts[oe_n];
          If oe_n < oe_np - 1 Then
            oe_Idx2 := _OtherEntity.Points.Parts[oe_n + 1] - 1
          Else
            oe_Idx2 := _OtherEntity.Points.Count - 1;
        Until false
      End;
    Finally
      TmpV1.Free;
      TmpV2.Free;
      TmpV3.Free;
    End;

    If _FullInside Then // is completely inside ?
      Result := AtLeastOnePointIsInside And NoIntersection
    Else
      { fully inside is also considered intersection }
      Result := ( AtLeastOnePointIsInside And NoIntersection ) Or Not NoIntersection;

    If Result Or ( np < 2 ) Then Break;

    Inc( n );
    If n >= np Then Break;
    Idx1 := FPoints.Parts[n];
    If n < np - 1 Then
      Idx2 := FPoints.Parts[n + 1] - 1
    Else
      Idx2 := FPoints.Count - 1;
  Until False;
End;

Function TEzEntity.IsPointInsideMe( Const X, Y: Double ): Boolean;
Var
  Dist: Double;
Begin
  Result := GetDrawPoints.PointInPolygon2D( Point2D( X, Y ), Dist, 0, Self.GetTransformMatrix ) >= PICKED_INTERIOR;
End;

Function TEzEntity.IntersectEntity( OtherEntity: TEzEntity;
  ConsidereFullyInside: Boolean = True ): Boolean;
Var
  TmpVect, IntVect, OtherVect: TEzVector;
Begin
  If FPoints.Count = 1 Then
  Begin
    TmpVect := TEzVector.Create( 5 );
    With TmpVect, FBox Do
    Begin
      Add( Emin );
      Add( Point2D( emax.x, emin.y ) );
      Add( Emax );
      Add( Point2D( emin.x, emax.y ) );
      Add( Emin );
    End;
  End
  Else
    TmpVect := GetDrawPoints;
  If OtherEntity.FPoints.Count = 1 Then
  Begin
    OtherVect := TEzVector.Create( 5 );
    With OtherVect, OtherEntity.FBox Do
    Begin
      Add( Emin );
      Add( Point2D( emax.x, emin.y ) );
      Add( Emax );
      Add( Point2D( emin.x, emax.y ) );
      Add( Emin );
    End;
  End
  Else
    OtherVect := OtherEntity.DrawPoints;
  IntVect := TEzVector.Create( 2 );
  Try
    Result := VectIntersect( OtherVect, TmpVect, IntVect, true,true );
    If ( Result = false ) And ConsidereFullyInside Then
    Begin
      // also, intersects is true if one of the entities is entirely inside the other
      If OtherEntity.IsClosed Then
        Result := Self.IsInsideEntity( OtherEntity, True );
      If ( Result = false ) And ( Self.IsClosed ) Then
        Result := OtherEntity.IsInsideEntity( Self, True );
    End;
  Finally
    If FPoints.Count = 1 Then
      TmpVect.Free;
    IntVect.Free;
    If OtherEntity.FPoints.Count = 1 Then
      OtherVect.Free;
  End;
End;

Procedure TEzEntity.MaxMinExtents( Var AXMin, AYMin, AXMax, AYMax: Double );
Begin
  With FBox Do
  Begin
    AXMin := xmin;
    AYMin := ymin;
    AXMax := xmax;
    AYMax := ymax;
  End;
End;

Function TEzEntity.StorageSize: Integer;
Begin
  Result := FPoints.Count * SizeOf( TEzPoint ) + FPoints.Parts.Count * SizeOf( Word );
End;

Function TEzEntity.RotatesClockWise: Boolean;
Begin
  Result := Not EzLib.IsCounterClockWise( FPoints );
End;

{ Determines the points that is apart a given Distance from startpoint
  until the given distance is reached }

Function TEzEntity.TravelDistance( Const Distance: Double;
  Var p: TEzPoint;
  Var Index1, Index2: Integer ): Boolean;
Var
  V: TEzVector;
Begin
  V := TEzVector.Create( DrawPoints.Count );
  Try
    V.Assign( DrawPoints );
    Result := V.TravelDistance( Distance, P, Index1, Index2 );
  Finally
    V.Free;
  End;
End;

Function TEzEntity.AttribsAsString: string;
Begin
  Result:= '';
End;

Function TEzEntity.BasicInfoAsString: string;
Begin
  Result:= '';
End;

Function TEzEntity.AsString( IncludeAttribs: Boolean = False;
  IncludeData: Boolean = False; DbTable: TEzBaseTable=Nil ): string;
Var
  BasicInfo, DataInfo, AttribsInfo: string;
  sdelim,edelim,quotes: string;
  I: Integer;
  FieldType: Char;
Begin
  If IncludeAttribs Then
    AttribsInfo:= Self.AttribsAsString + CrLf
  Else
    AttribsInfo:= '';

  BasicInfo:= Self.BasicInfoAsString + CrLf;

  If IncludeData And (DbTable <> Nil) then
  begin
    sdelim:= '{' + CrLf;
    edelim:= '}' + CrLf;
    DataInfo:= sDataInfo + CrLf;
    for I:= 1 to DbTable.FieldCount Do
    Begin
      FieldType:= DbTable.FieldType(I);
      { returns 'M','B','G', 'F','N', 'C', 'L','D', 'I', 'T' }
      If FieldType in ['M','B','G'] Then Continue;
      If FieldType='C' Then
        quotes:= '"'
      else
        quotes:= '';
      DataInfo:= DataInfo + Format(sFieldValue, [DbTable.Field(I), quotes + DbTable.StringGetN(I) + quotes ]) + CrLf;
    End;
  end else
  begin
    sdelim:= '';
    edelim:= '';
    DataInfo:= '';
  end;
  Result:= AttribsInfo + sdelim + BasicInfo + DataInfo + edelim;
End;


{ TEzOpenedEntity }

Constructor TEzOpenedEntity.CreateEntity( Const Pts: Array Of TEzPoint; CanGrow: Boolean = True );
Begin
  Inherited Create(High(Pts) - Low(Pts) + 1);
  FPoints.AddPoints(Pts);
  FPoints.CanGrow:= CanGrow;
End;

Destructor TEzOpenedEntity.Destroy;
Begin
  FPenTool.Free;
  Inherited Destroy;
End;

Procedure TEzOpenedEntity.Initialize;
begin
  PenTool.Assign(Ez_Preferences.DefPenStyle);
end;

Function TEzOpenedEntity.AttribsAsString: string;
Begin
  Result:= Format( sPenInfo, [Pentool.Style, Pentool.Color, Pentool.Width]);
End;

Function TEzOpenedEntity.GetPenTool: TEzPenTool;
Begin
  If FPenTool = Nil Then
    FPenTool := TEzPenTool.Create;
  result := FPenTool;
End;

Procedure TEzOpenedEntity.LoadFromStream( Stream: TStream );
Begin
  If FPenTool = Nil Then
    FPenTool := TEzPenTool.Create;
  FPoints.DisableEvents := true;
  Inherited LoadFromStream( Stream ); // read ID and points
  FPenTool.LoadFromStream( Stream ); // read pen

  FPoints.DisableEvents := false;
  FPoints.OnChange := UpdateExtension;
  FOriginalSize := StorageSize;
End;

Procedure TEzOpenedEntity.SaveToStream( Stream: TStream );
Begin
  Inherited SaveToStream( Stream ); // save ID and points
  FPenTool.SaveToStream( Stream ); // save pen
  FOriginalSize := StorageSize;
End;

Procedure TEzOpenedEntity.Draw( Grapher: TEzGrapher; Canvas: TCanvas;
  Const Clip: TEzRect; DrawMode: TEzDrawMode; Data: Pointer = Nil );
Begin
  if not FSkipPainting then
    GetDrawPoints.DrawOpened( Canvas, Clip, FBox, Grapher, Pentool.FPenStyle,
      PenTool.Scale, Self.GetTransformMatrix, DrawMode );
End;

Procedure TEzOpenedEntity.ShowDirection( Grapher: TEzGrapher;
                                         Canvas: TCanvas;
                                         Const Clip: TEzRect;
                                         DrawMode: TEzDrawMode;
                                         DirectionPos: TEzDirectionpos;
                                         Const DirectionPen: TEzPenStyle;
                                         Const DirectionPenScale: Double;
                                         Const DirectionBrush: TEzBrushStyle;
                                         RevertDirection: Boolean );
Var
  TmpVect: TEzVector;
  ArrowHeight, ArrowLength, Angle: Double;
  TmpPt, FromPt, ToPt: TEzPoint;
  I, J, N, Idx1, Idx2: Integer;
  TmpMatrix: TEzMatrix;
  DirPos: ezbase.TEzDirPos;
  Vector: TEzVector;
Begin
  If FPoints.Parts.Count < 2 Then
    Vector := DrawPoints
  Else
    Vector := FPoints;
  If Not ( DrawMode In [dmNormal, dmSelection] ) Or ( Vector.Count < 2 ) Then
    Exit;
  {Calculate the length of the arrow}
  ArrowLength := Grapher.PointsToDistY( dMax(2,Ez_Preferences.DirectionArrowSize) ); // points arrow size
  ArrowHeight := ArrowLength / 2;
  TmpVect := TEzVector.Create( 3 );
  Try
    n := 0;
    If FPoints.Parts.Count < 2 Then
    Begin
      Idx1 := 0;
      Idx2 := Vector.Count - 1;
    End
    Else
    Begin
      Idx1 := FPoints.Parts[n];
      Idx2 := FPoints.Parts[n + 1] - 1;
    End;
    Repeat
      TmpVect.Clear;
      {now we must rotate the arrow and translate}
      For I := Idx1 To Idx2 - 1 Do
      Begin
        If RevertDirection Then
        Begin
          FromPt := Vector[I + 1];
          ToPt := Vector[I];
        End
        Else
        Begin
          FromPt := Vector[I];
          ToPt := Vector[I + 1];
        End;
        Angle := Angle2D( FromPt, ToPt );
        For DirPos := Low( TEzDirPos ) To High( TEzDirPos ) Do
        Begin
          If Not ( DirPos In DirectionPos ) Then
            Continue;
          Case DirPos Of
            dpStart:
              Begin
                {point 0}
                TmpVect[0] := Point2D( ArrowLength, 0 );
                {point 1}
                TmpVect[1] := Point2D( 0, ArrowHeight );
                {point 2}
                TmpVect[2] := Point2D( 0, -ArrowHeight );
                TmpPt := Vector[I];
              End;
            dpMiddle:
              Begin
                {point 0}
                TmpVect[0] := Point2D( ArrowLength / 2, 0 );
                {point 1}
                TmpVect[1] := Point2D( -ArrowLength / 2, ArrowHeight );
                {point 2}
                TmpVect[2] := Point2D( -ArrowLength / 2, -ArrowHeight );
                TmpPt := Point2D( ( Vector[I].X + Vector[I + 1].X ) / 2,
                  ( Vector[I].Y + Vector[I + 1].Y ) / 2 );
              End;
            dpEnd:
              Begin
                {point 0}
                TmpVect[0] := Point2D( 0, 0 );
                {point 1}
                TmpVect[1] := Point2D( -ArrowLength, ArrowHeight );
                {point 2}
                TmpVect[2] := Point2D( -ArrowLength, -ArrowHeight );
                TmpPt := Vector[I + 1];
              End;
          End;
          TmpMatrix := MultiplyMatrix2D( Rotate2D( Angle, TmpPt ), Translate2D( TmpPt.X, TmpPt.Y ) );
          For J := 0 To TmpVect.Count - 1 Do
            TmpVect[J] := TransformPoint2D( TmpVect[J], TmpMatrix );
          TmpVect.DrawClosed( Canvas,
                              Clip,
                              TmpVect.Extension,
                              Grapher,
                              DirectionPen,
                              DirectionPenScale,
                              DirectionBrush,
                              self.GetTransformMatrix,
                              DrawMode,
                              Nil );
        End;
      End;
      If FPoints.Parts.Count < 2 Then
        Break;
      Inc( n );
      If n >= FPoints.Parts.Count Then
        Break;
      Idx1 := FPoints.Parts[n];
      If n < FPoints.Parts.Count - 1 Then
        Idx2 := FPoints.Parts[n + 1] - 1
      Else
        Idx2 := Vector.Count - 1;
    Until False;
  Finally
    TmpVect.Free;
  End;
End;

Function TEzOpenedEntity.IsEqualTo( Entity: TEzEntity; IncludeAttribs: Boolean  = false): Boolean;
Begin
  Result:= False;
  if Not (Entity is TEzOpenedEntity) Or Not FPoints.IsEqualTo( Entity.FPoints )
     {$IFDEF FALSE}Or ( IncludeAttribs And
       Not CompareMem( @FPenTool.FPenStyle,
                       @TEzOpenedEntity(Entity).FPenTool.FPenStyle,
                       SizeOf( TEzPenStyle ) ) ){$ENDIF} Then Exit;
  Result:= True;
End;

Function TEzOpenedEntity.Area: Double;
Begin
  Result := ezlib.Area2D( GetDrawPoints )
End;

Function TEzOpenedEntity.PointCode( Const Pt: TEzPoint;
  Const Aperture: Double; Var Distance: Double;
  SelectPickingInside: Boolean; UseDrawPoints: Boolean = True ): Integer;
Var
  Idx1, Idx2, n, cnt: Integer;
  TmpVect, V: TEzVector;
Begin
  // first, detect if a vertex was clicked
  Result := Inherited PointCode( Pt, Aperture, Distance, SelectPickingInside, UseDrawPoints );
  If Result >= PICKED_INTERIOR Then Exit;
  // if a vertex was not clicked, then check clicked line segments
  If UseDrawPoints Then V := GetDrawPoints else V := Points;
  If V.Parts.Count < 2 Then
    Result := V.PointOnPolyLine2D( 0, Pt, Distance, Aperture, self.GetTransformMatrix, False )
  Else
  Begin
    n := 0;
    Idx1 := V.Parts[n];
    Idx2 := V.Parts[n + 1] - 1;
    TmpVect := TEzVector.Create( 4 );
    Try
      Repeat
        TmpVect.Clear;
        For cnt := Idx1 To Idx2 Do
          TmpVect.Add( V[cnt] );
        Result := TmpVect.PointOnPolyLine2D( Idx1, Pt, Distance, Aperture, self.GetTransformMatrix, False );
        If Result >= PICKED_INTERIOR Then
          Exit; { found on one part }
        Inc( n );
        If n >= V.Parts.Count Then
          Break;
        Idx1 := V.Parts[n];
        If n < V.Parts.Count - 1 Then
          Idx2 := V.Parts[n + 1] - 1
        Else
          Idx2 := V.Count - 1;
      Until false;
    Finally
      TmpVect.Free;
    End;
  End;
End;

{ next three procedures is useful for opened and closed entities }

Procedure TEzOpenedEntity.MoveAndRotateControlPts( Var MovePt, RotatePt: TEzPoint; Grapher: TEzGrapher );
Begin
  If Not EqualPoint2d(Ez_Preferences.GRotatePoint, INVALID_POINT) Then
  Begin
    MovePt:= Ez_Preferences.GRotatePoint;
  End Else
  Begin
    Self.Centroid( MovePt.X, MovePt.Y );
  End;
  RotatePt.Y := MovePt.Y;
  If Grapher <> Nil Then
    RotatePt.X := MovePt.X + Grapher.DistToRealX(Grapher.ScreenDpiX div 2)
  Else
    RotatePt.X := MovePt.X + ( FBox.Emax.X - MovePt.X ) * ( 2 / 3 );
End;

Function TEzOpenedEntity.GetControlPoints(TransfPts: Boolean; Grapher: TEzGrapher=Nil): TEzVector;
Var
  MovePt, RotatePt: TEzPoint;
Begin
  Result := TEzVector.Create( FPoints.Count + 2 );
  Result.Assign( FPoints );
  if TransfPts then
  begin
    MoveAndRotateControlPts( MovePt, RotatePt, Grapher );
    Result.Add( MovePt );
    Result.Add( RotatePt );
  end;
End;

Function TEzOpenedEntity.GetControlPointType( Index: Integer ): TEzControlPointType;
Begin
  Result := cptNode;
  If ( Index >= 0 ) And ( Index <= FPoints.Count - 1 ) Then
    Result := cptNode
  Else If Index = FPoints.Count Then
    Result := cptMove
  Else If Index = FPoints.Count + 1 Then
    Result := cptRotate;
End;

{$IFDEF BCB}
procedure TEzOpenedEntity.SetPenTool(const Value: TEzPenTool);
begin
  FPenTool := Value;
end;
{$ENDIF}

{ TEzClosedEntity }

Destructor TEzClosedEntity.Destroy;
Begin
  FBrushTool.free;
  Inherited Destroy;
End;

Procedure TEzClosedEntity.Initialize;
begin
  Inherited;
  BrushTool.Assign(Ez_Preferences.DefBrushStyle);
end;

Function TEzClosedEntity.AttribsAsString: string;
Begin
  Result:= Inherited AttribsAsString + CrLf +
    Format(sBrushInfo, [Brushtool.Pattern,Brushtool.ForeColor, Brushtool.Backcolor]);
End;

Function TEzClosedEntity.GetBrushTool: TEzBrushTool;
Begin
  If FBrushTool = Nil Then
    FBrushTool := TEzBrushTool.Create;
  result := FBrushTool;
End;

Procedure TEzClosedEntity.LoadFromStream( Stream: TStream );
Begin
  Inherited LoadFromStream( Stream );
  If FBrushTool = Nil Then
    FBrushTool := TEzBrushTool.Create;
  FBrushTool.LoadFromStream( Stream );
End;

Procedure TEzClosedEntity.SaveToStream( Stream: TStream );
Begin
  Inherited SaveToStream( Stream );
  FBrushTool.SaveToStream( Stream );
End;

Function TEzClosedEntity.IsClosed: Boolean;
Begin
  result := True;
End;

Procedure TEzClosedEntity.Draw( Grapher: TEzGrapher; Canvas: TCanvas;
  Const Clip: TEzRect; DrawMode: TEzDrawMode; Data: Pointer = Nil );
Var
  Tmpbool: Boolean;
  Resname: String;
  BmpRes: HBitmap;
Begin
  if FSkipPainting then
    Exit;
  Tmpbool := false;
  If ( DrawMode = dmNormal ) And ( FBitmap = Nil ) And ( BrushTool.Pattern >= 2 ) And
    ( BrushTool.Pattern <= 89 ) Then
  Begin
    { load the resource bitmap }
    Resname := '#' + IntToStr( 98 + BrushTool.Pattern );
    BmpRes := LoadBitmap( HInstance, PChar( Resname ) );
    If BmpRes <> 0 Then
    Begin
      FBitmap := TBitmap.Create;
      FBitmap.Handle := BmpRes;
      Tmpbool := true;
    End;
  End;
{$IFDEF FALSE}
  If ( FBitmap = Nil ) And ( BrushTool.Pattern >= 90 ) And
    ( ( BrushTool.Pattern - 90 ) <= Ez_Hatches.Count - 1 ) Then
  Begin
    GetDrawPoints.DrawHatch( Canvas, Clip, FBox, Grapher, BrushTool.FBrushStyle,
      self.GetTransformMatrix, DrawMode );
  End;
{$ENDIF}
  GetDrawPoints.DrawClosed( Canvas, Clip, FBox, Grapher, PenTool.FPenStyle,
    PenTool.Scale,
    BrushTool.FBrushStyle, self.GetTransformMatrix, DrawMode, FBitmap );
  If Tmpbool Then
  Begin
    DeleteObject( FBitmap.Handle );
    FreeAndNil( FBitmap );
  End;
End;

Function TEzClosedEntity.PointCode( Const Pt: TEzPoint; Const Aperture: Double;
  Var Distance: Double; SelectPickingInside: Boolean; UseDrawPoints: Boolean = True ): Integer;
Var
  Idx1, Idx2, n, cnt: Integer;
  TmpVect, V: TEzVector;
Begin
  Result := Inherited PointCode( Pt, Aperture, Distance, selectpickinginside, UseDrawPoints ); // is on a vertex ?

  If ( Result >= PICKED_INTERIOR ) Or Not SelectPickingInside Then Exit;

  If UseDrawPoints Then V := GetDrawPoints Else V := Points;
  If V.Parts.Count < 2 Then
  Begin
    Result := V.PointInPolygon2D( Pt, Distance, Aperture, self.GetTransformMatrix );
  End
  Else
  Begin
    n := 0;
    Idx1 := V.Parts[n];
    Idx2 := V.Parts[n + 1] - 1;
    TmpVect := TEzVector.Create( 4 );
    Try
      Repeat
        TmpVect.Clear;
        For cnt := Idx1 To Idx2 Do
          TmpVect.Add( V[cnt] );
        Result := TmpVect.PointInPolygon2D( Pt, Distance, Aperture, self.GetTransformMatrix );
        If Result >= PICKED_INTERIOR Then Exit;
        Inc( n );
        If n >= V.Parts.Count Then Break;
        Idx1 := V.Parts[n];
        If n < V.Parts.Count - 1 Then
          Idx2 := V.Parts[n + 1] - 1
        Else
          Idx2 := V.Count - 1;
      Until false;
    Finally
      TmpVect.Free;
    End;
  End;
End;

Function TEzClosedEntity.IsEqualTo( Entity: TEzEntity; IncludeAttribs: Boolean  = false ): Boolean;
Begin
  Result:= False;
  if Not (Entity is TEzClosedEntity) Or
    ( Inherited IsEqualTo( Entity, IncludeAttribs ) = False )
    {$IFDEF FALSE}Or ( IncludeAttribs And
      Not CompareMem( @FBrushTool.FBrushStyle,
                      @TEzClosedEntity(Entity).FBrushTool.FBrushStyle,
                      SizeOf( TEzBrushStyle ) ) ){$ENDIF} Then Exit;
  Result:= True;
End;

{$IFDEF BCB}
procedure TEzClosedEntity.SetBrushTool(const Value: TEzBrushTool);
begin
  FBrushTool := Value;
end;
{$ENDIF}

{------------------------------------------------------------------------------}
{                  TEzBaseDrawBox and auxiliary classes                        }
{------------------------------------------------------------------------------}

{ TEzBaseDrawBox }

Constructor TEzBaseDrawBox.Create( AOwner: TComponent );
Var
  DeltaX, DeltaY: Integer;
Begin
  Inherited Create( AOwner );
  { basic initialization }
  FComCtlVersion := CheckComCtlVersion;
  { before in scrollp }
  If NewStyleControls Then
    ControlStyle := CtrlStyle
  Else
    ControlStyle := CtrlStyle + [csFramed];
  FZoomWithMargins:= True;
  FScrollBars := ssBoth;
  FBorderStyle := bsSingle;
  FHMin := 0;
  FHMax := 100;
  FHSmallChange := 1;
  FHLargeChange := 10;
  FHPosition := 50;
  FVMin := 0;
  FVMax := 100;
  FVSmallChange := 1;
  FVLargeChange := 10;
  FVPosition := 50;
  { inherited properties }
  ParentColor := False;
  //Color:= clWindow;
  Width := 100;
  Height := 100;
  { this class data }
  FGridInfo := TEzGridInfo.Create;
  FScreenGrid := TEzScreenGrid.Create;
  With FScreenGrid Do
  Begin
    Color := clSilver;
    Step.FPoint := Point2D( 1, 1 );
  End;
  FTempEntities := TEzEntityList.Create;
  FOutputDevices := [odBitmap];
  FShowControlPoints := False;
  FGrapher := TEzGrapher.Create( 10, adScreen );
  FGrapher.OnChange := Self.ViewChanged;
  CalcScrollBarDeltas( DeltaX, DeltaY );
  FGrapher.SetViewport( 0, 0, Width - DeltaX - 1, Height - DeltaY - 1 );
  FGrapher.SetWindow( 0, DEFAULT_EXTENSION.X2, 0, DEFAULT_EXTENSION.Y2 );
  FRubberPen := TPen.Create;
  With FRubberPen Do
  Begin
    Style := psSolid;
    Mode := pmXor;
    Color := clRed;
  End;
  { forces rubber pen to update its color }
  FScreenBitmap := TBitmap.Create;
  FScreenBitmap.PixelFormat := pf24bit;
  With FGrapher.ViewportRect Do
  Begin
    FScreenBitmap.Height := Succ(Trunc(Abs( Y2-Y1 )));
    FScreenBitmap.Width := Succ(Trunc(Abs( X2-X1 )));
  End;
  //FScreenBitmap.HandleType:= bmDIB;
  FNeedsRepaint := True;
  FSnapToGuidelinesDist := 1.0;
  { includes all }
  FNoPickFilter := [];
  FStackedSelect := True;
  FDelayShowHint := 200;
  FThematicSeriesColors := TEzThematicSeriesColor.Create;
  FNumDecimals := 3;
  { inherited properties }
  TabStop := True;

  { for GIS }
  FSelection := TEzSelection.Create( Self );
  FUndo := TEzUndoPool.Create( Self );
  FBlinkCount := 3;
  FBlinkRate := 100;

  FDropRepeat:= 1;

  FAutoScroll := False;
End;

Destructor TEzBaseDrawBox.Destroy;
Begin

  { dispose GIS related }
  If FGIS <> Nil Then
  Begin
    With FGIS.DrawBoxList Do
      Delete( IndexOf( Self ) );
  End;

  FSelection.Free;
  FUndo.Free;

  { dispose basic information }
  FScreenBitmap.Free;
  FGrapher.Free;
  FTempEntities.Free;
  FGridInfo.Free;
  FScreenGrid.Free;
  FThematicSeriesColors.Free;
  FRubberPen.Free;
  Inherited Destroy;
End;

{ basic TEzDrawBox procedures }

Procedure TEzBaseDrawBox.CreateParams( Var Params: TCreateParams );
Const
  BorderStyles: Array[Forms.TBorderStyle] Of Longint = ( 0, WS_BORDER );
Begin
  Inherited CreateParams( Params );
  With Params Do
  Begin
    Style := Style Or DWORD( BorderStyles[FBorderStyle] );
    If fScrollBars In [ssVertical, ssBoth] Then
      Style := Style Or WS_VSCROLL;
    If fScrollBars In [ssHorizontal, ssBoth] Then
      Style := Style Or WS_HSCROLL;
    //WindowClass.style:= WindowClass.style and CS_DBLCLKS;
    If NewStyleControls And Ctl3D And ( FBorderStyle = bsSingle ) Then
    Begin
      Style := Style And Not WS_BORDER;
      If FComCtlVersion = True Then
      Begin
        If FFlatScrollBar = True Then
          //for better visual effect if use flat scrollbar
          ExStyle := ExStyle Or WS_EX_STATICEDGE
        Else
          ExStyle := ExStyle Or WS_EX_CLIENTEDGE;
      End
      Else
        ExStyle := ExStyle Or WS_EX_CLIENTEDGE;
    End;
    //WindowClass.style := WindowClass.style and not (CS_HREDRAW or CS_VREDRAW);
  End;
End;

Procedure TEzBaseDrawBox.CreateWnd;
Begin
  Inherited CreateWnd;
  If FComCtlVersion = True Then
  Begin
    If FFlatScrollBar = true Then
      InitializeFlatSB( Handle )
    Else
      UninitializeFlatSB( Handle );

    If fScrollBars = ssBoth Then
    Begin
      FlatSB_ShowScrollBar( Handle, SB_BOTH, True );
    End
    Else If fScrollBars = ssHorizontal Then
    Begin
      FlatSB_ShowScrollBar( Handle, SB_HORZ, True )
    End
    Else If fScrollBars = ssVertical Then
    Begin
      FlatSB_ShowScrollBar( Handle, SB_VERT, True );
    End;

    If fScrollBars In [ssHorizontal, ssBoth] Then
    Begin
      FlatSB_SetScrollRange( Handle, SB_HORZ, fHMin, fHMax, False );
      FlatSB_SetScrollPos( Handle, SB_HORZ, fHPosition, True );
    End;
    If fScrollBars In [ssVertical, ssBoth] Then
    Begin
      FlatSB_SetScrollRange( Handle, SB_VERT, fVMin, fVMax, False );
      FlatSB_SetScrollPos( Handle, SB_VERT, fVPosition, True );
    End;
  End
  Else
  Begin
    If fScrollBars = ssBoth Then
    Begin
      ShowScrollBar( Handle, SB_BOTH, True );
    End
    Else If fScrollBars = ssHorizontal Then
    Begin
      ShowScrollBar( Handle, SB_HORZ, True )
    End
    Else If fScrollBars = ssVertical Then
    Begin
      ShowScrollBar( Handle, SB_VERT, True );
    End;

    If fScrollBars In [ssHorizontal, ssBoth] Then
    Begin
      SetScrollRange( Handle, SB_HORZ, fHMin, fHMax, False );
      SetScrollPos( Handle, SB_HORZ, fHPosition, True );
    End;
    If fScrollBars In [ssVertical, ssBoth] Then
    Begin
      SetScrollRange( Handle, SB_VERT, fVMin, fVMax, False );
      SetScrollPos( Handle, SB_VERT, fVPosition, True );
    End;
  End;
End;

Procedure TEzBaseDrawBox.ClearCanvas( Canvas: TCanvas; ARect: TRect; BackCol: TColor );
Var
  lb: TLogBrush;
  oldBkMode: Integer;
  oldFillMode: Integer;
  Vertices: Array[0..4] Of TPoint;
Begin
  Canvas.Lock;
  Try
    If FTileBitmap <> Nil Then
    Begin
      FTileBitmap.HandleType := bmDIB; //bmDDB;
      lb.lbColor := BackCol;
      lb.lbStyle := BS_PATTERN;
      lb.lbHatch := Longint( FTileBitmap.Handle );
      Canvas.Brush.Handle := CreateBrushIndirect( lb );
      oldFillMode := Windows.GetPolyFillMode( Canvas.Handle );
      oldBkMode := Windows.GetBkMode( Canvas.Handle );

      Windows.SetPolyFillMode( Canvas.Handle, Alternate );
      Windows.SetBkMode( Canvas.Handle, TRANSPARENT );

      Vertices[0] := Point( 0, 0 );
      Vertices[1] := Point( 0, Height );
      Vertices[2] := Point( Width, Height );
      Vertices[3] := Point( Width, 0 );
      Vertices[4] := Point( 0, 0 );
      Polygon( Canvas.Handle, Vertices, 5 );

      Windows.SetBkMode( Canvas.Handle, oldBkMode );
      Windows.SetPolyFillMode( Canvas.Handle, oldFillMode );
    End
    Else
    Begin
      With Canvas Do
      Begin
        Brush.Color := BackCol;
        Brush.Style := bsSolid;
        FillRect( ARect );
      End;
    End;
  Finally
    Canvas.UnLock;
  End;
End;

Procedure TEzBaseDrawBox.SetBorderStyle( Const Value: forms.TBorderStyle );
Begin
  If fBorderStyle <> Value Then
  Begin
    fBorderStyle := Value;
    RecreateWnd;
  End;
End;

Procedure TEzBaseDrawBox.SetScrollBars( Value: TScrollStyle );
Begin
  If fScrollBars <> Value Then
  Begin
    fScrollBars := Value;
    RecreateWnd;
    Resync;
  End;
End;

Procedure TEzBaseDrawBox.SetPageSize( Value: Integer );
{Var
  ScrollInfo: TScrollInfo;}
Begin
  {Exit;
  If ( FPageSize = Value ) Or ( Value > FHMax ) Or ( Value > FVMax ) Then Exit;
  FPageSize := Value;
  ScrollInfo.cbSize := SizeOf( ScrollInfo );
  ScrollInfo.nPage := Value;
  ScrollInfo.fMask := SIF_PAGE;
  If HandleAllocated Then
  Begin
    If FComCtlVersion = True Then
      FlatSB_SetScrollInfo( Handle, SB_CTL, ScrollInfo, True )
    Else
      SetScrollInfo( Handle, SB_CTL, ScrollInfo, True );
  End; }
End;

Procedure TEzBaseDrawBox.SetHParams( APosition, AMin, AMax: Integer );
Begin
  If AMax < AMin Then
    Raise EInvalidOperation.Create( SScrollBarRange );
  If APosition < AMin Then
    APosition := AMin;
  If APosition > AMax Then
    APosition := AMax;
  If ( fHMin <> AMin ) Or ( fHMax <> AMax ) Then
  Begin
    fHMin := AMin;
    fHMax := AMax;
    If HandleAllocated Then
    Begin
      If FComCtlVersion = True Then
        FlatSB_SetScrollRange( Handle, SB_HORZ, AMin, AMax, fHPosition = APosition )
      Else
        SetScrollRange( Handle, SB_HORZ, AMin, AMax, fHPosition = APosition );
    End;
  End;
  If fHPosition <> APosition Then
  Begin
    FHPosition := APosition;
    If HandleAllocated Then
    Begin
      If FComCtlVersion = True Then
        FlatSB_SetScrollPos( Handle, SB_HORZ, APosition, True )
      Else
        SetScrollPos( Handle, SB_HORZ, APosition, True );
      SetPageSize( ezlib.IMin( FHMax, FVMax ) Div 5 );
    End;
    HChange;
  End;
End;

Procedure TEzBaseDrawBox.SetVParams( APosition, AMin, AMax: Integer );
Begin
  If AMax < AMin Then
    Raise EInvalidOperation.Create( SScrollBarRange );
  If APosition < AMin Then
    APosition := AMin;
  If APosition > AMax Then
    APosition := AMax;
  If ( fVMin <> AMin ) Or ( fVMax <> AMax ) Then
  Begin
    fVMin := AMin;
    fVMax := AMax;
    If HandleAllocated Then
    Begin
      If FComCtlVersion = True Then
        FlatSB_SetScrollRange( Handle, SB_VERT, AMin, AMax, fVPosition = APosition )
      Else
        SetScrollRange( Handle, SB_VERT, AMin, AMax, fVPosition = APosition );
    End;
  End;
  If fVPosition <> APosition Then
  Begin
    fVPosition := APosition;
    If HandleAllocated Then
    Begin
      If FComCtlVersion = True Then
        FlatSB_SetScrollPos( Handle, SB_VERT, APosition, True )
      Else
        SetScrollPos( Handle, SB_VERT, APosition, True );
      SetPageSize( ezlib.IMin( FHMax, FVMax ) Div 5 );
    End;
    VChange;
  End;
End;

Procedure TEzBaseDrawBox.HChange;
Begin
  If Assigned( fOnHChange ) Then
    fOnHChange( Self );
End;

Procedure TEzBaseDrawBox.VChange;
Begin
  If Assigned( fOnVChange ) Then
    fOnVChange( Self );
End;

Procedure TEzBaseDrawBox.HScroll( ScrollCode: TScrollCode; Var ScrollPos: Integer );
Var
  Cx, DistX: Double;
  Moved: Integer;
Begin
  If ScrollPos <> FHPosition Then
  Begin
    With FGrapher.CurrentParams Do
    Begin
      Cx := MidPoint.X;
      Moved := ScrollPos - FHPosition;
      With VisualWindow Do
      Begin
        DistX := ( Emax.X - Emin.X ) / 50;
        MidPoint.X := MidPoint.X + Moved * DistX;
        Emin.X := Emin.X - ( Cx - MidPoint.X );
        Emax.X := Emax.X - ( Cx - MidPoint.X );
      End;
      If Assigned( FGrapher.OnChange ) Then
        FGrapher.OnChange( Self );
      Repaint;
    End;
  End;
  If ( ScrollPos = FHMax ) Or ( ScrollPos = FHMin ) Then
    ScrollPos := 50;
  If Assigned( fOnHScroll ) Then
    fOnHScroll( Self, ScrollCode, ScrollPos );
End;

Procedure TEzBaseDrawBox.VScroll( ScrollCode: TScrollCode; Var ScrollPos: Integer );
Var
  Cy: Double;
  Moved: Integer;
Begin
  If ScrollPos <> FVPosition Then
  Begin
    With FGrapher.CurrentParams Do
    Begin
      Cy := MidPoint.Y;
      Moved := ScrollPos - FVPosition;
      With VisualWindow Do
      Begin
        MidPoint.Y := MidPoint.Y - Moved * ( Emax.Y - Emin.Y ) / 50;
        Emin.Y := Emin.Y - ( Cy - MidPoint.Y );
        Emax.Y := Emax.Y - ( Cy - MidPoint.Y );
      End;
      If Assigned( FGrapher.OnChange ) Then
        FGrapher.OnChange( Self );
    End;
    Repaint;
  End;
  If ( ScrollPos = FVMax ) Or ( ScrollPos = FVMin ) Then
    ScrollPos := 50;
  If Assigned( fOnVScroll ) Then
    fOnVScroll( Self, ScrollCode, ScrollPos );
End;

Procedure TEzBaseDrawBox.WMHScroll( Var Msg: TWMHScroll );
Var
  ScrollPos: Integer;
  NewPos: Longint;
Begin
  If Assigned( FOnBeforeScroll ) Then
    FOnBeforeScroll( Self );
  With Msg Do
  Begin
    NewPos := fHPosition;
    Case TScrollCode( ScrollCode ) Of
      scLineUp:
        Dec( NewPos, fHSmallChange );
      scLineDown:
        Inc( NewPos, fHSmallChange );
      scPageUp:
        Dec( NewPos, fHLargeChange );
      scPageDown:
        Inc( NewPos, fHLargeChange );
      scPosition, scTrack:
        NewPos := Pos;
      scTop:
        NewPos := fHMin;
      scBottom:
        NewPos := fHMax;
    End;
    If NewPos < fHMin Then
      NewPos := fHMin;
    If NewPos > fHMax Then
      NewPos := fHMax;
    ScrollPos := NewPos;
    HScroll( TScrollCode( ScrollCode ), ScrollPos );
    SetHParams( ScrollPos, fHMin, fHMax );
  End;
  If Assigned( FOnAfterScroll ) Then
    FOnAfterScroll( Self );
End;

Procedure TEzBaseDrawBox.WMVScroll( Var Msg: TWMVScroll );
Var
  ScrollPos: Integer;
  NewPos: Longint;
Begin
  If Assigned( FOnBeforeScroll ) Then
    FOnBeforeScroll( Self );
  With Msg Do
  Begin
    NewPos := fVPosition;
    Case TScrollCode( ScrollCode ) Of
      scLineUp:
        Dec( NewPos, fVSmallChange );
      scLineDown:
        Inc( NewPos, fVSmallChange );
      scPageUp:
        Dec( NewPos, fVLargeChange );
      scPageDown:
        Inc( NewPos, fVLargeChange );
      scPosition, scTrack:
        NewPos := Pos;
      scTop:
        NewPos := fVMin;
      scBottom:
        NewPos := fVMax;
    End;
    If NewPos < fVMin Then
      NewPos := fVMin;
    If NewPos > fVMax Then
      NewPos := fVMax;
    ScrollPos := NewPos;
    VScroll( TScrollCode( ScrollCode ), ScrollPos );
    SetVParams( ScrollPos, fVMin, fVMax );
  End;
  If Assigned( FOnAfterScroll ) Then
    FOnAfterScroll( Self );
End;

Procedure TEzBaseDrawBox.DrawEntity( Ent: TEzEntity; DrawMode: TEzDrawMode = dmNormal );
Begin
  With Ent, FGrapher.CurrentParams Do
  Begin
    If Not IsVisible( VisualWindow ) Then Exit;
    If odBitmap In FOutputDevices Then
    Begin
      Draw( FGrapher, FScreenBitmap.Canvas, VisualWindow, DrawMode );
      If FShowControlPoints Then
        DrawControlPoints( FGrapher, FScreenBitmap.Canvas, VisualWindow, FShowTransfPoints );
    End;
    If odCanvas In FOutputDevices Then
    Begin
      Draw( FGrapher, Canvas, VisualWindow, DrawMode );
      If FShowControlPoints Then
        DrawControlPoints( FGrapher, Canvas, VisualWindow, FShowTransfPoints );
    End;
  End;
End;

Procedure TEzBaseDrawBox.DrawEntity2D( Ent: TEzEntity; CtrlPts: Boolean; DrawMode: TEzDrawMode = dmNormal );
Var
  TmpFlag: Boolean;
Begin
  TmpFlag := ShowControlPoints;
  ShowControlPoints := ShowControlPoints Or CtrlPts;
  DrawEntity( Ent, DrawMode );
  ShowControlPoints := TmpFlag;
End;

Procedure TEzBaseDrawBox.DrawControlPointsWithRubber( Ent: TEzEntity );
Begin
  With Ent, FGrapher.CurrentParams Do
  Begin
    If Not IsVisible( VisualWindow ) Then Exit;
    With Canvas Do
    Begin
      Pen.Assign( FRubberPen );
      Pen.Color := ColorToRGB( Pen.Color ) Xor ColorToRGB( Self.Color );
      Brush.Style := bsclear;
      //Brush.Color:= clLime;
    End;
    DrawControlPoints( FGrapher, Canvas, VisualWindow, FShowTransfPoints, False );
  End;
End;

Procedure TEzBaseDrawBox.DrawEntityRubberBand( Ent: TEzEntity );
Begin
  If Ent.Points.Count = 0 Then Exit;
  With Ent, FGrapher.CurrentParams Do
  Begin
    If Not IsVisible( VisualWindow ) Then Exit;

    With Canvas Do
    Begin
      Pen.Assign( FRubberPen );
      Pen.Color := ColorToRGB( FRubberPen.Color ) Xor ColorToRGB( Self.Color ) ;
      Brush.Style := bsClear;
    End;
    Draw( FGrapher, Canvas, VisualWindow, dmRubberPen, Self );
    If FShowControlPoints Then
      DrawControlPoints( FGrapher, Canvas, VisualWindow, FShowTransfPoints, False, Self.HideVertexNumber );
  End;
End;

Procedure TEzBaseDrawBox.DrawEntity2DRubberBand( Entity: TEzEntity;
  CtrlPts: Boolean = False; TransfPts: Boolean = False );
Var
  TmpFlag1, TmpFlag2: Boolean;
Begin
  TmpFlag1 := FShowControlPoints;
  TmpFlag2 := FShowTransfPoints;
  FShowControlPoints := FShowControlPoints Or CtrlPts;
  FShowTransfPoints := FShowTransfPoints Or TransfPts;
  DrawEntityRubberBand( Entity );
  FShowControlPoints := TmpFlag1;
  FShowTransfPoints := TmpFlag2;
End;

{ BeginUpdate...EndUpdate...CancelUpdate used for stopping the redrawing }
Procedure TEzBaseDrawBox.BeginUpdate;
Begin
  FInUpdate := True;
End;

Procedure TEzBaseDrawBox.CancelUpdate;
begin
  FInUpdate := False;
end;

Procedure TEzBaseDrawBox.EndUpdate;
Begin
  FInUpdate := False;
  Repaint;
End;

Procedure TEzBaseDrawBox.ForceEndUpdate;
Begin
  FInUpdate := False;
  FInRepaint := False;
End;

Procedure TEzBaseDrawBox.Paint;
Var
  { basic data }
  SaveState: TEzOutputDevices;
  I: Integer;
  //ValidParent: Boolean;

  Procedure PaintEntities;
  Var
    TmpEntity: TEzEntity;
    L: Integer;
    Layer: TEzBaseLayer;
    VisualWindow: TEzRect;
    UpdRect: TRect;
  Begin
    // paint animation layers and others, only after full repainting the map
    { will draw all Animation layers }
    //VisualWindow:= Grapher.CurrentParams.VisualWindow;
    If Not Windows.GetUpdateRect( Self.Handle, UpdRect, false ) Then
      VisualWindow := Grapher.CurrentParams.VisualWindow
    Else
      VisualWindow := Grapher.RectToReal( UpdRect );
    If Not ( FInRepaint Or Self.IsDesigning Or ( FGIS = Nil ) Or
      Not FGIS.MapInfo.Isvalid Or ( FGIS.Layers.Count = 0 ) Or
      FIsAerial Or IsRectEmpty2D( VisualWindow ) ) Then
    Begin

      With TEzPainterObject.Create(Nil) Do
        Try
          DrawEntities( VisualWindow,
                        FGIS,
                        Canvas,
                        Grapher,
                        Selection,
                        FALSE,
                        TRUE,
                        pmAll,
                        Self.ScreenBitmap );
        Finally
          Free;
        End;
    End;

    { paint map extents }
    If ShowMapExtents Or ShowLayerExtents Then
    Begin
      TmpEntity := TEzRectangle.CreateEntity( Point2D( 0, 0 ), Point2D( 0, 0 ) );
      Try
        With TEzRectangle( TmpEntity ).PenTool Do
        Begin
          Style := 1;
          Color := clRed;
          Width := 0;
        End;
        TEzRectangle( TmpEntity ).Brushtool.Pattern := 0;
        If ShowMapExtents Then
        Begin
          With GIS.MapInfo.Extension Do
          Begin
            TmpEntity.Points[0] := Emin;
            TmpEntity.Points[1] := Emax;
          End;
          TmpEntity.Draw( Grapher, Canvas, VisualWindow, dmNormal );
        End;
        { paint layer extents }
        If ShowLayerExtents Then
        Begin
          TEzRectangle( TmpEntity ).Pentool.Color := clBlue;
          For L := 0 To FGIS.Layers.Count - 1 Do
          Begin
            Layer := GIS.Layers[L];
            If Not Layer.Eof And
              Not EqualRect2D( Layer.LayerInfo.Extension, INVALID_EXTENSION )
            Then
              With Layer.LayerInfo.Extension Do
              Begin
                TmpEntity.Points[0] := Emin;
                TmpEntity.Points[1] := Emax;
                TmpEntity.Draw( Grapher, Canvas, VisualWindow, dmNormal );
              End;
          End;
        End;
      Finally
        TmpEntity.Free;
      End;
    End;
    { now draw the guidelines... }
    EzSystem.ShowGuideLines( Self, FGIS.HGuideLines, FGIS.FVGuideLines );
  End;

Begin
  If FInUpdate Then Exit;

  If Self.IsDesigning Or (FGis = Nil) Then
  Begin
    ClearCanvas( Canvas, ClientRect, Color );
    Exit;
  End;
  If FNeedsRepaint Then
  Begin
    Repaint;
    Exit;
  End;

  DoCopyCanvas;

  If Not IsRectEmpty2D(FGrapher.CurrentParams.VisualWindow) And Not FInRepaint Then
  Begin
    SaveState := FOutputDevices;
    FOutputDevices := [odCanvas];
    Try
      With Canvas.Pen Do
      Begin
        Style := psSolid;
        Mode := pmCopy;
      End;

      { now paint the entities of the layers }
      PaintEntities;

      { paint temporary entities }
      For I := 0 To Pred(FTempEntities.Count) Do
        DrawEntity( FTempEntities[I] );
    Finally
      FOutputDevices := SaveState;
    End;
  End;
  DrawGrid( FGrapher.CurrentParams.VisualWindow );

  If Assigned( FOnPaint ) Then
    FOnPaint( Self );
End;

Procedure TEzBaseDrawBox.RefreshRect( Const WCRect: TEzRect );
Var
  ARect: TRect;
Begin
  ARect := FGrapher.RealToRect( WCRect );
  InflateRect( ARect, 1, 1 );
  Canvas.CopyRect( ARect, FScreenBitmap.Canvas, ARect );
End;

Procedure TEzBaseDrawBox.CalcScrollBarDeltas( var DeltaX, DeltaY: Integer );
Begin
  DeltaX:= 0;
  DeltaY:= 0;
  if ScrollBars in [ssHorizontal, ssBoth] then
    DeltaX:= GetSystemMetrics( SM_CXHTHUMB );
  if ScrollBars in [ssVertical, ssBoth] then
    DeltaY:= GetSystemMetrics( SM_CXHTHUMB );
End;

Procedure TEzBaseDrawBox.Resync;
Var
  NewW, NewH, DeltaX, DeltaY: Integer;
  P1, P2: TEzPoint;
Begin
  CalcScrollBarDeltas( DeltaX, DeltaY );
  If (Width<=DeltaX) Or (Height<=DeltaY) then Exit;
  NewW := Width - DeltaX;
  NewH := Height - DeltaY;

  FScreenBitmap.Width := NewW;
  FScreenBitmap.Height := NewH;

  P1 := FGrapher.PointToReal( Point( 0, NewH - 1 ) );
  P2 := FGrapher.PointToReal( Point( NewW - 1, 0 ) );

  FGrapher.SetViewport( 0, 0, NewW - 1, NewH - 1 );
  FGrapher.Window( P1.X, P2.X, P1.Y, P2.Y );
  With FScreenBitmap Do
    ClearCanvas(Canvas, Rect(0, 0, Width, FScreenBitmap.Height), Self.Color);
End;

Procedure TEzBaseDrawBox.Resize;
Begin
  Inherited;
  Resync;
  Repaint;
  FGrapher.Clear; { clear history }
End;

Procedure TEzBaseDrawBox.WMEraseBkgnd( Var m: TWMEraseBkgnd );
Begin
  m.Result := LRESULT( False );
End;

Procedure TEzBaseDrawBox.CMCtl3DChanged( Var m: TMessage );
Begin
  If NewStyleControls And ( FBorderStyle = bsSingle ) Then
    RecreateWnd;
  Inherited;
End;

Procedure TEzBaseDrawBox.BeginRepaint;
Begin
  FInRepaint:= True;
  If Assigned( FOnBeginRepaint ) Then
    FOnBeginRepaint( Self );
End;

Procedure TEzBaseDrawBox.EndRepaint;
Begin
  FInRepaint:= False;
  If Assigned( FOnEndRepaint ) Then
    FOnEndRepaint( Self );
End;

Procedure TEzBaseDrawBox.RepaintRect( Const WCRect: TEzRect );
Var
  R: TEzRect;
  DX, DY: Double;
Begin

  If (Abs(WCRect.X1) > 1E100) or (Abs(WCRect.Y1) > 1E100) or
     (Abs(WCRect.X2) > 1E100) or (Abs(WCRect.Y2) > 1E100) Then Exit;

  FNeedsRepaint := False;
  If FInRepaint Or FInUpdate Then Exit;

  BeginRepaint;
  R := WCRect;
  DX := FGrapher.DistToRealX( FGrapher.ScreenDpiX Div 16 );
  DY := FGrapher.DistToRealY( FGrapher.ScreenDpiY Div 16 );
  With R Do
  Begin
    If X1 = X2 Then
      X2 := X1 + DX;
    If Y1 = Y2 Then
      Y2 := Y1 + DY;
  End;

  UpdateViewport( R );

  EndRepaint;
  Invalidate;
End;

Procedure TEzBaseDrawBox.DrawCross( Canvas: TCanvas; pt: TPoint );
Var
  pa, pb: TPoint;
Begin
  With Canvas Do
  Begin
    pa.x := pt.X - 2;
    pa.y := pt.Y;
    pb.x := pt.X + 3;
    pb.y := pt.Y;
    Moveto( pa.x, pa.y );
    Lineto( pb.x, pb.y );
    pa.x := pt.X;
    pa.y := pt.Y - 2;
    pb.x := pt.X;
    pb.y := pt.Y + 3;
    Moveto( pa.x, pa.y );
    Lineto( pb.x, pb.y );
  End;
End;

Procedure TEzBaseDrawBox.DrawGrid( Const WCRect: TEzRect );
Var
  X, Y, AX1, AY1, AX2, AY2, SpacingX, SpacingY, OffsetX, OffsetY: Double;
  DeltaX, DeltaY: Integer;
  Clr: TColor;
  p: TPoint;
  DrawAsCross: Boolean;
Begin
  If ( Not FGridInfo.FShowGrid ) Or ( FGridInfo.FGrid.X <= 0.0 ) Or
    ( FGridInfo.FGrid.Y <= 0.0 ) Then Exit;

  DrawAsCross := FGridInfo.FDrawAsCross;
  With {FScreenBitmap.}  Canvas Do
  Begin
    Clr := FGridInfo.FGridColor;
    Pen.Color := Clr;
    Pen.Mode := pmCopy;
    Pen.Width := 1;
    With FGridInfo.FGrid Do
    Begin
      SpacingX := FPoint.X;
      SpacingY := FPoint.Y;
    End;
    With FGridInfo.FGridOffset Do
    Begin
      OffsetX := FPoint.X;
      OffsetY := FPoint.Y;
    End;
    DeltaX := Abs( FGrapher.RealToDistX( SpacingX ) );
    DeltaY := Abs( FGrapher.RealToDistY( SpacingY ) );
    If ( DeltaX < 8 ) Or ( DeltaY < 8 ) Then
    Begin
      If Assigned( FOnGridError ) Then
        FOnGridError( Self );
      Exit;
    End;
    If OffsetX > SpacingX Then
      OffsetX := 0;
    If OffsetY > SpacingY Then
      OffsetY := 0;
    AX1 := Trunc( WCRect.Emin.X / SpacingX ) * SpacingX + OffsetX;
    AY1 := Trunc( WCRect.Emin.Y / SpacingY ) * SpacingY + OffsetY;
    AX2 := WCRect.Emax.X;
    AY2 := WCRect.Emax.Y;
    X := AX1;
    While X < AX2 Do
    Begin
      Y := AY1;
      While Y < AY2 Do
      Begin
        p := FGrapher.RealToPoint( Point2D( X, Y ) );
        If DrawAsCross Then
          DrawCross( Canvas, p )
        Else
          Pixels[p.X, p.Y] := Clr;
        Y := Y + SpacingY;
      End;
      X := X + SpacingX;
    End;
  End;
End;

Procedure TEzBaseDrawBox.Repaint;
Begin
  If ( csLoading In ComponentState ) Or FInUpdate Or Self.IsDesigning Then Exit;
  With FScreenBitmap Do
    ClearCanvas(Canvas, Rect(0, 0, Width, Height), Self.Color);
  RepaintRect( FGrapher.CurrentParams.VisualWindow );
End;

Procedure TEzBaseDrawBox.Refresh;
Begin
  If FInUpdate then Exit;
  { refresh causes to repaint the internal bitmap to the canvas }
  DoCopyCanvas;
  Paint;
End;

Procedure TEzBaseDrawBox.ZoomWindow( Const NewWindow: TEzRect );
Begin
  ForceEndUpdate;
  If EqualRect2D( NewWindow, INVALID_EXTENSION ) Or
    ( Abs( NewWindow.X2 - NewWindow.X1 ) < 1E-08 ) Or
    ( Abs( NewWindow.Y2 - NewWindow.Y1 ) < 1E-08 ) Then Exit;

  FGrapher.SetViewTo( NewWindow );
  Repaint;
End;

Procedure TEzBaseDrawBox.MoveWindow( Const NewStartX, NewStartY: Double );
Var
  TmpWin: TEzRect;
  Temp: Double;
Begin
  With FGrapher.CurrentParams.VisualWindow Do
  Begin
    Temp := X2 - X1;
    TmpWin.X1 := NewStartX;
    TmpWin.X2 := NewStartX + Temp;
    Temp := Y2 - Y1;
    TmpWin.Y1 := NewStartY;
    TmpWin.Y2 := NewStartY + Temp;
  End;
  FGrapher.SetViewTo( TmpWin );
  Repaint;
End;

Procedure TEzBaseDrawBox.ZoomPrevious;
Begin
  If Not FGrapher.CanPop Then Exit;
  FGrapher.Pop;
  Repaint;
End;

Procedure TEzBaseDrawBox.ZoomIn(percent:byte);
Begin
  FGrapher.Zoom( (percent/100) );
  Repaint;
End;

Procedure TEzBaseDrawBox.ZoomOut(percent:byte);
Begin
  FGrapher.Zoom( 1/(percent/100) );
  Repaint;
End;

Procedure TEzBaseDrawBox.Panning( Const DeltaX, DeltaY: Double );
Var
  TmpWin: TEzRect;
Begin
  With FGrapher.CurrentParams.VisualWindow Do
  Begin
    TmpWin.X1 := X1 + DeltaX;
    TmpWin.X2 := X2 + DeltaX;
    TmpWin.Y1 := Y1 + DeltaY;
    TmpWin.Y2 := Y2 + DeltaY;
  End;
  FGrapher.SetViewTo( TmpWin );
  Repaint;
End;

Procedure TEzBaseDrawBox.MouseMove( Shift: TShiftState; X, Y: Integer );
Var
  TmpPt: TEzPoint;
Begin
  If Assigned( FOnMouseMove2D ) Then
  Begin
    TmpPt := FGrapher.PointToReal( Point( X, Y ) );
    FOnMouseMove2D( Self, Shift, X, Y, TmpPt.X, TmpPt.Y );
  End;
  Inherited MouseMove( Shift, X, Y );
End;

Procedure TEzBaseDrawBox.MouseDown( Button: TMouseButton; Shift: TShiftState; X, Y: Integer );
Var
  TmpPt: TEzPoint;
Begin
  If Not Focused Then
    Windows.SetFocus( Handle );
  Inherited MouseDown( Button, Shift, X, Y );
  If Assigned( FOnMouseDown2D ) Then
  Begin
    TmpPt := FGrapher.PointToReal( Point( X, Y ) );
    FOnMouseDown2D( Self, Button, Shift, X, Y, TmpPt.X, TmpPt.Y );
    if IsAutoScrollEnabled then
    begin

    end;
  End;
End;

Procedure TEzBaseDrawBox.MouseUp( Button: TMouseButton; Shift: TShiftState; X, Y: Integer );
Var
  TmpPt: TEzPoint;
Begin
  Inherited MouseUp( Button, Shift, X, Y );
  If Assigned( FOnMouseUp2D ) Then
  Begin
    TmpPt := FGrapher.PointToReal( Point( X, Y ) );
    FOnMouseUp2D( Self, Button, Shift, X, Y, TmpPt.X, TmpPt.Y );
  End;
End;

Procedure TEzBaseDrawBox.UpdateViewport(WCRect: TEzRect);
Begin
  If not HandleAllocated Or (FGIS = Nil) Then
    Exit;
  ClearCanvas(FScreenBitmap.Canvas, FGrapher.RealToRect(WCRect), Self.Color);
End;

Procedure TEzBaseDrawBox.RegenDrawing;
Begin
  FInRepaint := False;
  Repaint;
End;

Procedure TEzBaseDrawBox.AddMarker( Const X, Y: Double; SetInView: Boolean );
Begin
  EzSystem.AddMarker( Self, X, Y, SetInView );
End;

Procedure TEzBaseDrawBox.DrawBoxToWorld( X, Y: Integer; Var WX, WY: Double );
Var
  TmpPt: TEzPoint;
Begin
  TmpPt := FGrapher.PointToReal( Point( X, Y ) );
  WX := TmpPt.X;
  WY := TmpPt.Y;
End;

Procedure TEzBaseDrawBox.WorldToDrawBox( Const WX, WY: Double; Var X, Y:
  Integer );
Var
  TmpPt: TPoint;
Begin
  TmpPt := FGrapher.RealToPoint( Point2D( WX, WY ) );
  X := TmpPt.X;
  Y := TmpPt.Y;
End;

Procedure TEzBaseDrawBox.ClearViewsHistory;
Begin
  FGrapher.Clear;
End;

Function TEzBaseDrawBox.IsDesigning: Boolean;
Begin
  Result := ( csDesigning In ComponentState );
End;

Procedure TEzBaseDrawBox.SetFlatScrollBar( Value: Boolean );
Begin
  If FFlatScrollbar = Value Then
  begin
    Exit;
  end;
  FFlatScrollbar := Value;
  If FComCtlVersion = False Then
  Begin
    MessageToUser( SFlatScrollBarNotAllowed, smsgerror, MB_ICONERROR );
    Exit;
  End;

  FFlatScrollbar := Value;
  RecreateWnd;
End;

Procedure TEzBaseDrawBox.SetGridInfo( value: TEzGridInfo );
Begin
  FGridInfo.Assign( value );
End;

{procedure TEzBaseDrawBox.WMGetDlgCode(var Message: TWMGetDlgCode);
begin
  inherited;
  Message.Result := Message.Result or DLGC_WANTTAB;
end; }

{ GIS specific procedures }

Procedure TEzBaseDrawBox.ZoomToHorzDistance( Const Distance: Double );
Begin
  With FGrapher.ViewportRect do
    ZoomToScale( 1 / ( Abs(X2 - X1) / FGrapher.ScreenDpiX ) * Distance, suInches )
End;

Procedure TEzBaseDrawBox.ZoomToScale( Const Scale: Double; ScaleUnits: TEzScaleUnits );
Var
  SemiDistX, SemiDistY: Double;
Begin
  With FGrapher.ViewportRect do
  begin
    SemiDistX := ( ( Abs(X2 - X1)  / FGrapher.ScreenDpiX ) * Scale ) / 2;
    SemiDistY := ( ( Abs(Y2 - Y1) / FGrapher.ScreenDpiY ) * Scale ) / 2;
  end;
  If ScaleUnits = suMms Then
  Begin
    SemiDistX := SemiDistX * 25.4;
    SemiDistY := SemiDistY * 25.4;
  End Else If ScaleUnits = suCms Then
  Begin
    SemiDistX := SemiDistX * 2.54;
    SemiDistY := SemiDistY * 2.54;
  End;
  // now adjust current coordinates
  With FGrapher.CurrentParams.MidPoint Do
    FGrapher.SetViewTo( Rect2D( X - SemiDistX, Y - SemiDistY, X + SemiDistX, Y + SemiDistY ) );
  Repaint;
End;

Procedure TEzBaseDrawBox.ScaleToHorzDistance( Const Scale: Double; ScaleUnits: TEzScaleUnits;
  Var HorzDistance: Double );
Var
  temp: Extended;
Begin
  temp := ( Width / FGrapher.ScreenDpiX );
  If ScaleUnits = suMms Then
    temp := temp * 25.4
  Else If ScaleUnits = suCms Then
    temp := temp * 2.54;
  HorzDistance := temp * scale;
End;

Procedure TEzBaseDrawBox.HorzDistanceToScale( Const HorzDistance: Double;
  Var Scale: Double; ScaleUnits: TEzScaleUnits );
Var
  temp: Extended;
Begin
  temp := ( Width / FGrapher.ScreenDpiX );
  If ScaleUnits = suMms Then
    temp := temp * 25.4
  Else If ScaleUnits = suCms Then
    temp := temp * 2.54;
  Scale := HorzDistance / temp;
End;

Procedure TEzBaseDrawBox.SetGIS( Value: TEzBaseGIS );
Begin
{$IFDEF LEVEL5}
  if Assigned( FGis ) then FGis.RemoveFreeNotification( Self );
{$ENDIF}
  If Value <> Nil Then
  Begin
    Value.FreeNotification( Self );
    If Not IsDesigning Then
    Begin
      Value.DrawBoxList.Add( Self );
      If FGIS <> Nil Then
        With FGIS.DrawBoxList Do
          Delete( IndexOf( Self ) );
    End;
  End;
  FGIS := Value;
  if Assigned(FOnGisChanged) then
    FOnGisChanged(Self);
End;

Procedure TEzBaseDrawBox.ZoomToLayerRef( Const LayerName: String );
Var
  TmpMarginX, TmpMarginY: Double;
  MaxExtents: TEzRect;
  Layer: TEzBaseLayer;
Begin
  Assert( FGIS <> Nil );
  Layer := GIS.Layers.LayerByName( LayerName );
  If Layer = Nil Then Exit;

  MaxExtents := Layer.LayerInfo.Extension;
  If EqualRect2D( MaxExtents, INVALID_EXTENSION ) Or
       EqualRect2D( MaxExtents, NULL_EXTENSION ) Then  Exit;
  With MaxExtents Do
  Begin
    TmpMarginX := ( Emax.X - Emin.X ) / 20;
    TmpMarginY := ( Emax.Y - Emin.Y ) / 20;
    Emin.X := Emin.X - TmpMarginX;
    Emax.X := Emax.X + TmpMarginX;
    Emin.Y := Emin.Y - TmpMarginY;
    Emax.Y := Emax.Y + TmpMarginY;
    Grapher.SetViewTo( MaxExtents );
  End;
  Repaint;
End;

procedure TEzBaseDrawBox.ZoomOnPoint(const WX, WY, ZoomPercent: Double; const IsZoomIn: Boolean);
Var 
  OldPoint, NewPoint, MidPoint: TEzPoint;
  DevOldPoint: TPoint;
Begin
  // ZoomPercent can be 0.85 (as an example) as we use in Zoom In
  OldPoint := Point2D( WX, WY );
  DevOldPoint:= Self.Grapher.RealToPoint( OldPoint );
  Self.Grapher.InUpdate := true; //for don't generate two history views
  If IsZoomIn Then
    Self.Grapher.Zoom( ZoomPercent )
  Else  // is a zoom out
    Self.Grapher.Zoom( 1 / ZoomPercent );
  Self.Grapher.InUpdate := false;
  NewPoint := Self.Grapher.PointToReal( DevOldPoint );
  MidPoint := Self.Grapher.CurrentParams.MidPoint;
  { in every zoom the point clicked must stay on same mouse coordinates }
  Self.Grapher.ReCentre( MidPoint.X + ( OldPoint.X - NewPoint.X ),  MidPoint.Y + ( OldPoint.Y - NewPoint.Y ) );
  Self.Repaint;
end;

Procedure TEzBaseDrawBox.ZoomToExtension;
Var
  TmpMarginX, TmpMarginY, DeltaX, DeltaY: Double;
  MaxExtents: TEzRect;
Begin
  Assert( FGIS <> Nil );
  If FGIS.FMapInfo.IsAreaClipped Then
  Begin
    with FGIS.FMapInfo.AreaClipped do
    begin
      TmpMarginX := 0;
      TmpMarginY := 0;
      if FZoomWithMargins then
      begin
        TmpMarginX := Abs( Emax.X - Emin.X ) / 40;
        TmpMarginY := Abs( Emax.Y - Emin.Y ) / 40;
      end;

      SetViewTo( Emin.X - TmpMarginX,
                 Emin.Y - TmpMarginY,
                 Emax.X + TmpMarginX,
                 Emax.Y + TmpMarginY );
    end;
  End
  Else
  Begin
    MaxExtents := FGIS.FMapInfo.Extension;
    If Not EqualRect2D( MaxExtents, Grapher.OriginalParams.VisualWindow ) Then
    Begin
      If EqualRect2D( MaxExtents, INVALID_EXTENSION ) Or
        EqualRect2D( MaxExtents, NULL_EXTENSION ) Then
      Begin
        FGIS.QuickUpdateExtension;
        MaxExtents := FGIS.FMapInfo.Extension;
        If EqualRect2D( MaxExtents, INVALID_EXTENSION ) Then
          MaxExtents := DEFAULT_EXTENSION;
      End;
      DeltaX:= MaxExtents.X2-MaxExtents.X1;
      DeltaY:= MaxExtents.Y2-MaxExtents.Y1;
      If (DeltaX <= 0) Or (DeltaY<=0) Or ( DeltaX <= MINCOORD) or (DeltaY <= MINCOORD) Or
        (DeltaX>=MAXCOORD) Or (DELTAY>=MAXCOORD) Then
      Begin
        FGIS.QuickUpdateExtension;
        MaxExtents := FGIS.FMapInfo.Extension;
        If EqualRect2D( MaxExtents, INVALID_EXTENSION ) Then
          MaxExtents := DEFAULT_EXTENSION;
      End;
      with MaxExtents do
      begin
        TmpMarginX := 0;
        TmpMarginY := 0;
        if FZoomWithMargins then
        begin
          TmpMarginX := ( Emax.X - Emin.X ) / 40;
          TmpMarginY := ( Emax.Y - Emin.Y ) / 40;
        end;

        Grapher.SetWindow( Emin.X - TmpMarginX,
                           Emax.X + TmpMarginX ,
                           Emin.Y - TmpMarginY,
                           Emax.Y + TmpMarginY  );
      End;
    End;
    Grapher.Zoom( 1 );
    Repaint;
  End;
End;

Procedure TEzBaseDrawBox.ZoomToSelection;
Begin
  If Selection.Count = 0 Then
    Exit;
  Grapher.SetViewTo( Selection.GetExtension );
  Repaint;
End;

{$IFDEF JPEG_SUPPORT}

Procedure TEzBaseDrawBox.SaveAsJPG( Const FileName: String );
Var
  GraphicLink: ezbase.TEzGraphicLink;
Begin
  GraphicLink := EzBase.TEzGraphicLink.Create;
  Try
    GraphicLink.putJPG( ScreenBitmap, FileName );
  Finally
    GraphicLink.Free;
  End;
End;
{$ENDIF}

{$IFDEF GIF_SUPPORT}

Procedure TEzBaseDrawBox.SaveAsGIF( Const FileName: String );
Var
  GraphicLink: TEzGraphicLink;
Begin
  GraphicLink := EzBase.TEzGraphicLink.Create;
  Try
    GraphicLink.putGIF( ScreenBitmap, FileName );
  Finally
    GraphicLink.Free;
  End;
End;
{$ENDIF}

Procedure TEzBaseDrawBox.SaveAsBMP( Const FileName: String );
Var
  GraphicLink: TEzGraphicLink;
Begin
  GraphicLink := EzBase.TEzGraphicLink.Create;
  Try
    GraphicLink.putBMP( ScreenBitmap, FileName );
  Finally
    GraphicLink.Free;
  End;
End;

Procedure TEzBaseDrawBox.SaveAsEMF( Const FileName: String );
Var
  Metafile: TMetafile;
  MetafileCanvas: TMetafileCanvas;
  ABox: TEzRect;
Begin

  Metafile := TMetafile.Create;

  MetaFile.width := Width;
  MetaFile.Height := height;
  Metafile.Enhanced := false;

  ABox := Grapher.CurrentParams.VisualWindow;
  MetafileCanvas := TMetafileCanvas.Create( MetaFile, 0);

  With TEzPainterObject.Create(Nil) Do
    Try
      DrawEntities( ABox,
                    FGIS,
                    MetafileCanvas,
                    Grapher,
                    Selection,
                    FALSE,
                    FALSE,
                    pmAll,
                    Nil );
    Finally
      Free;
    End;

  MetafileCanvas.Free;

  Try
    Metafile.SaveToFile( FileName );
  Finally
    Metafile.free;
  End;
End;

Procedure TEzBaseDrawBox.ViewChanged( Sender: TObject );
Begin
  If FGIS <> Nil Then
    FGIS.FModified := true;
End;

Procedure TEzBaseDrawBox.UnSelectAll;
Begin
  If Selection.Count = 0 Then Exit;
  Selection.Clear;
  Repaint;
End;

Procedure TEzBaseDrawBox.SelectAll;
Var
  i: Integer;
  Canceled: Boolean;
Begin
  Selection.BeginUpdate;
  Selection.Clear;
  For i := 0 To FGIS.FLayers.Count - 1 Do
  Begin
    DoSelectLayer( FGIS.FLayers[i], Canceled );
    If Canceled Then
      Break;
  End;
  Selection.EndUpdate;
  Self.Repaint;
End;

Procedure TEzBaseDrawBox.DoSelectLayer( Layer: TEzBaseLayer; Var Canceled: Boolean );
Var
  TickStart: DWORD;
  Msg: TMsg;
  cnt, RecCount: Integer;
  SelectionInUpdate: Boolean;
Begin
  Assert( FGIS <> Nil );
  Canceled := False;
  If ( Layer = Nil ) Or Not layer.Active Or Not Layer.LayerInfo.Selectable Or
    Not Layer.LayerInfo.Visible Then Exit;
  SelectionInUpdate := FSelection.InUpdate;
  If Not SelectionInUpdate Then
    FSelection.BeginUpdate;
  With Layer Do
  Begin
    First;
    StartBuffering;
    Try
      RecCount := RecordCount;
      If RecCount > 0 Then
        FGIS.StartProgress( SSelectinLayer + Name, 1, RecCount );
      TickStart := GetTickCount;
      cnt := 0;
      While Not Eof Do
      Begin
        If GetTickCount >= TickStart + 500 Then
        Begin // 1/2 second the test
          // check if specific messages are waiting and if so, cancel internal selecting
          PeekMessage( Msg, Handle, WM_KEYDOWN, WM_KEYDOWN, PM_REMOVE );
          If ( Msg.Message = WM_KEYDOWN ) And ( Msg.WParam = VK_ESCAPE ) Then
          Begin
            Canceled := True;
            Break;
          End;

          TickStart := GetTickCount;
        End;
        inc( cnt );
        FGIS.UpdateProgress( cnt );
        Try
          If RecIsDeleted Then
            Continue;
          If Not(RecEntityID In NoPickFilter) Then
            Selection.Add( Layer, Layer.Recno );
        Finally
          Next;
        End;
      End;
      If RecCount > 0 Then
        FGIS.EndProgress;
    Finally
      EndBuffering;
      If Not SelectionInUpdate Then
        FSelection.EndUpdate
    End;
  End;
End;

Procedure TEzBaseDrawBox.SetEntityInViewEx( Const LayerName: String;
  Recno: Integer; UseExtents: Boolean );
Var
  Layer: TEzBaseLayer;
  ent: TEzEntity;
Begin
  Assert( FGIS <> Nil );
  Layer := GIS.Layers.LayerByName( LayerName );
  If Layer = Nil Then exit;
  ent := Layer.LoadEntityWithRecno( Recno );
  If ent = Nil Then exit;
  Try
    SetEntityInView( ent, UseExtents );
  Finally
    ent.free;
  End;
End;

Procedure TEzBaseDrawBox.SetEntityInView( Entity: TEzEntity; UseExtents: Boolean );
Var
  Extents: TEzRect;
  CX, CY, TmpWidth, TmpHeight, TmpMarginX, TmpMarginY: Double;
Begin
  If ( Entity = Nil ) Or ( Entity.EntityID = idNone ) Then Exit;
  Extents := Entity.FBox;
  With Extents Do
  Begin
    CX := ( Emin.X + EMax.X ) / 2;
    CY := ( Emin.Y + EMax.Y ) / 2;
  End;
  If UseExtents Then
    With Extents Do
    Begin
      TmpWidth := ( Emax.X - Emin.X ) / 2;
      TmpHeight := ( Emax.Y - Emin.Y ) / 2;
      TmpMarginX := TmpWidth / 20;
      TmpMarginY := TmpHeight / 20;
    End
  Else
    With Grapher.CurrentParams.VisualWindow Do
    Begin
      TmpWidth := ( Emax.X - Emin.X ) / 2;
      TmpHeight := ( Emax.Y - Emin.Y ) / 2;
      TmpMarginX := 0;
      TmpMarginY := 0;
    End;
  With Extents Do
  Begin
    Emin.X := CX - TmpWidth - TmpMarginX;
    Emax.X := CX + TmpWidth + TmpMarginX;
    Emin.Y := CY - TmpHeight - TmpMarginY;
    Emax.Y := CY + TmpHeight + TmpMarginY;
  End;
  Grapher.SetViewTo( Extents );
  Repaint;
End;

Procedure TEzBaseDrawBox.DeleteSelection;
Var
  I: Integer;
  TmpR: TEzRect;
Begin

  If FSelection.Count = 0 Then  Exit;
  TmpR := Selection.GetExtension;
  If EqualRect2D( TmpR, INVALID_EXTENSION ) Then Exit;
  FUndo.AddUnDeleteFromSelection;
  Selection.DeleteSelection;
  For I := 0 To FGIS.FDrawBoxList.Count - 1 Do
    FGIS.FDrawBoxList[I].RepaintRect( TmpR );
End;

Function TEzBaseDrawBox.PickEntity( Const X, Y: Double;
                                    Aperture: Integer;
                                    Const LayerName: String;
                                    Var NLayer: TEzBaseLayer;
                                    Var NRecNo, NPoint: Integer;
                                    List: TStrings ): Boolean;
(* If Assigned(List) then what we want is a list of all entities
   that are picked. List contains in string part the layer name and in the object part,
   the recno of entity selected in that layer*)
Var
  Cnt, J, TmpNPoint, TmpRecno: Integer;
  MinDist, Distance, NewAperture: Double;
  RealAperture: TEzPoint;
  //Entities: Array[TEzEntityID] Of TEzEntity;
  //Cont: TEzEntityID;
  Pt: TEzPoint;
  VisualWindow: TEzRect;
  //Found,
  HasClipped: Boolean;
  HasClippedThis: Boolean;
  TmpClipIndex: Integer;
  TmpLayer: TEzBaseLayer;
  I, ARecno: Integer;
  TmpEntity: TEzEntity;
  TmpExt: TEzRect;
  EntityID: TEzEntityID;
  n1, n2: Integer;
Begin
  Result := false;
  If FGIS = Nil Then Exit;
  Pt := Point2D( X, Y );
  VisualWindow := Grapher.CurrentParams.VisualWindow;
  With FGIS.FMapInfo Do
  Begin
    If IsAreaClipped Then
    Begin
      With VisualWindow Do
      Begin
        If Emin.X < AreaClipped.Emin.X Then
          Emin.X := AreaClipped.Emin.X;
        If Emin.Y < AreaClipped.Emin.Y Then
          Emin.Y := AreaClipped.Emin.Y;
        If Emax.X > AreaClipped.Emax.X Then
          Emax.X := AreaClipped.Emax.X;
        If Emax.Y > AreaClipped.Emax.Y Then
          Emax.Y := AreaClipped.Emax.Y;
      End;
      If Not IsPointInBox2D( Pt, VisualWindow ) Then
        Exit;
    End;
  End;

  Aperture := Aperture Div 2;
  RealAperture := Point2D( Grapher.DistToRealX( Aperture ), Grapher.DistToRealY( Aperture ) );
  If RealAperture.X > RealAperture.Y Then
    NewAperture := RealAperture.X
  Else
    NewAperture := RealAperture.Y;
  NewAperture := Sqrt( 2 ) * NewAperture;
  MinDist := NewAperture;
  //For Cont := Low( TEzEntityID ) To High( TEzEntityID ) Do
  //  Entities[Cont] := GetClassFromID( Cont ).Create( 4 );
  HasClipped := FGIS.FClippedEntities.Count > 0;
  //Try
  If Length( LayerName ) > 0 Then
  Begin
    n1 := FGIS.Layers.IndexOfName( LayerName );
    n2 := n1;
    If n1 < 0 Then
    Begin
      n1 := FGIS.FLayers.Count - 1;
      n2 := 0;
    End;
  End
  Else
  Begin
    n1 := FGIS.FLayers.Count - 1;
    n2 := 0;
  End;
  { search from topmost layer }
  For cnt := n1 Downto n2 Do
  Begin
    TmpLayer := FGIS.FLayers[cnt];
    With TmpLayer Do
    Begin

      If Not LayerInfo.Visible Or Not LayerInfo.Selectable Then Continue;

      TmpClipIndex := -1;
      If HasClipped Then
      Begin
        TmpClipIndex := FGIS.FClippedEntities.IndexOf( FGIS.FLayers[cnt] );
        HasClippedThis := TmpClipIndex >= 0;
      End
      Else
        HasClippedThis := false;

      SetGraphicFilter( stOverlap, Rect2D( X - MinDist, Y - MinDist, X + MinDist, Y + MinDist ) );

      First;
      StartBuffering;
      Try
        //Found:= False;
        While Not Eof Do
        Begin
          ARecno := Recno;
          TmpExt := RecExtension;
          Try
            If RecIsDeleted Or
              Not IsRectVisible( TmpExt, VisualWindow ) Then
              Continue;

            If HasClippedThis And
              Not FGIS.FClippedEntities[TmpClipIndex].IsSelected( ARecno ) Then
              Continue;

            { inflate the rect }
            With TmpExt, RealAperture Do
            Begin
              X1 := X1 - X;
              X2 := X2 + X;
              Y1 := Y1 - Y;
              Y2 := Y2 + Y;
            End;
            If Not IsPointInBox2D( Pt, TmpExt ) Then
              Continue;

            EntityID := RecEntityID;

            If EntityID In NoPickFilter Then Continue;

            //TmpEntity := Entities[EntityID];
            //RecLoadEntity2( TmpEntity );

            TmpEntity:= RecLoadEntity;

            Try
              If ( EntityID In [idJustifVectText, idFittedVectText] ) And
                Not Ez_Preferences.ShowText Then Continue;

              TmpNPoint := TmpEntity.PointCode( Pt,
                                                NewAperture,
                                                Distance,
                                                Ez_Preferences.SelectPickingInside );
              If ( TmpNPoint >= PICKED_INTERIOR ) And ( Distance <= MinDist ) Then
              Begin
                Result := true; // the function result
                If List <> Nil Then
                Begin
                  If List.Count = 0 Then
                  Begin
                    NLayer := TmpLayer;
                    NRecNo := ARecno;
                    NPoint := TmpNPoint;
                  End;
                  List.AddObject( TmpLayer.Name, Pointer( ARecno ) );
                  //Found:= True;
                  //break;
                End
                Else
                Begin
                  NLayer := TmpLayer;
                  NRecNo := ARecno;
                  NPoint := TmpNPoint;
                  exit;
                End;
              End;
            Finally
              TmpEntity.Free;
            End;
            //if Found then Break;
          Finally
            Next;
          End;
        End;
      Finally
        EndBuffering;
        CancelFilter;
      End;
    End;
  End;
  {Finally
    For Cont := Low( TEzEntityID ) To High( TEzEntityID ) Do
      Entities[Cont].Free;
  End; }
End;

{ general use procedures }

{------------------------------------------------------------------------------}
{            DrawEntities main procedure used in viewing/printing maps         }
{------------------------------------------------------------------------------}

Constructor TEzPainterObject.Create( Thread: TEzPainterThread );
Begin
  Inherited Create;
  FThread:= Thread;
End;

Procedure TEzPainterObject.DrawEntities( WCRect: TEzRect; AGis: TEzBaseGIS;
  Canvas: TCanvas; Grapher: TEzGrapher; Selection: TEzSelection;
  IsAerial: Boolean; ShowAnimationLayers: Boolean; PrintMode: TEzPrintMode;
  BufferBitmap: TBitmap );
Var
  IsScreenDevice: Boolean;
  I, L, N, ARecno, retCode: Integer;
  TmpEntity: TEzEntity;
  Entities: Array[TEzEntityID] Of TEzEntity;
  Cont, EntityID: TEzEntityID;
  IsMemLayer: Boolean;
  CanShow: Boolean;
  AllVisibles: Boolean;
  WasClipped: Boolean;
  TmpDeleted: Boolean;
  HasSelection: Boolean;
  HasSelectionThis: Boolean;
  HasClipped: Boolean;
  HasClippedThis: Boolean;
  IsBeforeSome: Boolean;
  IsBeforeBrush: Boolean;
  IsBeforePen: Boolean;
  IsBeforeFont: Boolean;
  IsBeforeSymbol: Boolean;
  IsOnShowDirection: Boolean;
  IsBeforePaintEntity: Boolean;
  IsAfterPaintEntity: Boolean;
  IsLayerBeforePaintEntity: Boolean;
  IsLayerAfterPaintEntity: Boolean;
  IsTextHasShadow: Boolean;
  WasSame: Boolean;
  TmpLayer: TEzBaseLayer;
  TmpIndex, TmpClipIndex: Integer;
  DrawMode: TEzDrawMode;
  VisualWindow, TmpR: TEzRect;
  AClipRect: TRect;
  ClipPoints: PPointArray;
  ClipSize: Integer;
  ClippedVector: TEzVector;
  TmpVect: TEzVector;
  VisiblePts: TBits;
  ScreenCanvas: TCanvas;
  W, H, Delta, PrevFontHeight: Double;
  Accept, CanContinue, WasFiltered: boolean;
  PrintedEntities: Integer;
  NumPrintEntities: Integer;
  { show direction info }
  DirectionPen: TEzPenTool;
  DirectionPenScale: Double;
  DirectionBrush: TEzBrushTool;
  DirectionPos: TEzDirectionPos;
  RevertDirection: Boolean;
  cx, cy: Double;
  CancelPrint: Boolean;
  Bitmap: TBitmap;
  APrintTimerFrequency: Cardinal;
  TextTmp: TEzTrueTypeText;
  MyPnt: TPoint;
  MyPtnW: TEzPoint;
  FontOffsetX, FontOffsetY: Double;
  TheTextFixedSize: Integer;
  SavedCursor: TCursor;
  EntList, LayEntList: TEzEntityList;
  AutoFree: Boolean;
  LabelFont: TEzFontTool;

Begin

  FAllPainted:= False;
  FWasUpdated:= False;
  If ( AGis = Nil ) Or AGis.IsDesigning Or ( AGis.Layers.Count = 0 ) Or
    Not AGis.MapInfo.Isvalid Or IsRectEmpty2D( Grapher.CurrentParams.VisualWindow ) Then
  Begin
    FAllPainted:= True;
    Exit;
  End;

  VisualWindow := Grapher.CurrentParams.VisualWindow;
  { Visual Window is the client area of the DrawBox
     while WCRect is the area that must be updated only }
  WasClipped := False;
  With AGis.MapInfo Do
  Begin
    WasSame := CompareMem( @VisualWindow, @WCRect, SizeOf( TEzRect ) );
    If Not WasSame Or IsAreaClipped Then
    Begin
      If WasSame Then
        TmpR := VisualWindow
      Else
        TmpR := WCRect;
      If ( WasSame And IsAreaClipped ) Or ( Not WasSame ) Then
      Begin
        If IsAreaClipped Then
        Begin
          ClippedVector := TEzVector.Create( 5 );
          If ClipAreaKind = cpkPolygonal Then
            TmpVect := AGis.ClipPolygonalArea
          Else
          Begin
            TmpVect := TEzVector.Create( 4 );
            With TmpVect Do
            Begin
              Add( AreaClipped.Emin );
              Add( Point2D( AreaClipped.Emax.X, AreaClipped.Emin.Y ) );
              Add( AreaClipped.Emax );
              Add( Point2D( AreaClipped.Emin.X, AreaClipped.Emax.Y ) );
              Add( AreaClipped.Emin );
            End;
          End;
          ClipPolygonToArea( TmpVect, ClippedVector, TmpR );
          N := ClippedVector.Count;
          if N > 0 then
          begin
            ClipSize := ( N + 2 ) * sizeof( TPoint );
            GetMem( ClipPoints, ClipSize );
            Try
              For I := 0 To N - 1 Do
                ClipPoints^[I] := Grapher.RealToPoint( ClippedVector[I] );
              If N = 0 Then
              Begin
                { a dummy box when outside the clipped area }
                N := 5;
                For I := 0 To N - 1 Do
                  ClipPoints^[I] := Point( 0, 0 );
              End;
              Grapher.CanvasRegionStacker.Push( Canvas, CreatePolygonRgn( ClipPoints^, N, WINDING ) );
            Finally
              FreeMem( ClipPoints, ClipSize );
            End;
          End;
          If Not EqualRect2D( ClippedVector.Extension, INVALID_EXTENSION ) Then
            TmpR := ClippedVector.Extension
          Else
            With VisualWindow Do
            Begin
              W := Emax.X - Emin.X;
              H := Emax.Y - Emin.Y;
              Delta := dmin( W, H ) / 100;
              With VisualWindow Do
                TmpR := Rect2D( Emin.X, Emin.Y, Emin.X + Delta, Emin.Y + Delta );
            End;
          WasClipped := True;
          ClippedVector.Free;
          If Not ( ClipAreaKind = cpkPolygonal ) Then
            TmpVect.Free
        End
        Else
        Begin
          AClipRect := Grapher.RealToRect( TmpR );
          With AClipRect Do
            Grapher.CanvasRegionStacker.Push( Canvas, CreateRectRgn( Left, Top, Right, Bottom ) );
          WasClipped := True;
        End;
      End;
      WCRect := TmpR;
    End;
  End;

  IsScreenDevice := ( Grapher.Device = adScreen );

  If (FThread=Nil) And AGis.ShowWaitCursor Then
  Begin
    SavedCursor:= Screen.Cursor;
    Screen.Cursor := crHourglass;
  End;

  IsBeforeBrush := Assigned( AGis.OnBeforeBrushPaint );
  IsBeforePen := Assigned( AGis.OnBeforePenPaint );
  IsBeforeFont := Assigned( AGis.OnBeforeFontPaint );
  IsBeforeSymbol := Assigned( AGis.OnBeforeSymbolPaint );
  IsBeforePaintEntity := Assigned( AGis.OnBeforePaintEntity );
  IsAfterPaintEntity := Assigned( AGis.OnAfterPaintEntity );
  IsBeforeSome := IsBeforeBrush Or IsBeforePen Or IsBeforeFont Or IsBeforeSymbol;
  IsOnShowDirection := Assigned( AGis.OnShowDirection );
  Self.FIsTimer := (FThread=Nil) And IsScreenDevice And (AGis.FTimerFrequency > 50)
    And Assigned( AGis.FOnGisTimer );
  If AGis <> Nil Then
    APrintTimerFrequency := AGis.FPrintTimerFrequency
  Else
    APrintTimerFrequency := 800;
  { calculate font offset in real units }
  Case AGis.FFontShadowStyle Of
    fssLowerRight:
      Begin
        FontOffsetX := Grapher.DistToRealX( AGis.FFontShadowOffset );
        FontOffsetY := -Grapher.DistToRealY( AGis.FFontShadowOffset );
      End;
    fssUpperRight:
      Begin
        FontOffsetX := Grapher.DistToRealX( AGis.FFontShadowOffset );
        FontOffsetY := Grapher.DistToRealY( AGis.FFontShadowOffset );
      End;
    fssLowerLeft:
      Begin
        FontOffsetX := -Grapher.DistToRealX( AGis.FFontShadowOffset );
        FontOffsetY := -Grapher.DistToRealY( AGis.FFontShadowOffset );
      End;
    fssUpperLeft:
      Begin
        FontOffsetX := -Grapher.DistToRealX( AGis.FFontShadowOffset );
        FontOffsetY := Grapher.DistToRealY( AGis.FFontShadowOffset );
      End;
  Else
    Begin
      FontOffsetX := Grapher.DistToRealX( AGis.FFontShadowOffset );
      FontOffsetY := -Grapher.DistToRealY( AGis.FFontShadowOffset );
    End;
  End;

  PrintedEntities := 0;
  If Not IsScreenDevice Then
  Begin
    { display a progress dialog }
    NumPrintEntities := 0;
    For L := 0 To Pred(AGis.Layers.Count) Do
      with AGis.Layers[L] do
        if LayerInfo.Visible or (RecordCount > 0 ) then //Continue;
          Inc(NumPrintEntities, RecordCount);

    If Assigned( AGis.OnPrintBegin ) Then
      AGis.OnPrintBegin( AGis );
  End;

  { fire event OnBeforePaintLayers }
  If Assigned( AGis.OnBeforePaintLayers ) Then
    AGis.OnBeforePaintLayers( AGis );

  { We will create all existing entities to speed up process }
  For Cont := Low( TEzEntityID ) To High( TEzEntityID ) Do
  Begin
    Entities[Cont] := GetClassFromID( Cont ).Create( 4 );
    Entities[Cont].FPainterObject := Self;
    { for creating transparent bitmaps if BufferBitmap <> Nil }
    Entities[Cont].FBufferBitmap := BufferBitmap;
  End;
  DirectionPen := TEzPenTool.Create;
  DirectionBrush := TEzBrushTool.Create;

  LabelFont := TEzFontTool.Create;

  Grapher.BeginOptimizer( 4096, 50 );
  Try
    If Selection <> Nil Then
      HasSelection := Selection.Count > 0
    Else
      HasSelection := false;
    HasClipped := AGis.ClippedEntities.Count > 0;
    Self.FTickStart := GetTickCount;
    Self.FSourceGis := AGis;

    For L := 0 To Pred(AGis.Layers.Count) Do
    Begin
      TmpLayer := AGis.Layers[L];

      { Animation layers goes to the Paint method }
      If IsScreenDevice Then
      Begin

        If ( ShowAnimationLayers And Not TmpLayer.LayerInfo.IsAnimationLayer ) Or
           ( Not ShowAnimationLayers And TmpLayer.LayerInfo.IsAnimationLayer ) Then
          Continue;

      End;

      With AGis.MapInfo Do
        If IsScreenDevice And IsAerial And ( Length( AerialViewLayer ) > 0 ) Then
        Begin
          TmpIndex := AGis.Layers.IndexOfName( AerialViewLayer );

          If ( TmpIndex >= 0 ) And Not ( AGis.Layers[TmpIndex] = TmpLayer ) Then
            Continue;

        End;
      { fire event OnBeforePaintLayer }
      WasFiltered := False;
      If Not IsAerial And TmpLayer.LayerInfo.Visible And Assigned( AGis.OnBeforePaintLayer ) Then
      Begin
        CanShow := True;
        LayEntList:= Nil;
        AutoFree:= True;
        AGis.OnBeforePaintLayer( AGis, TmpLayer, Grapher, CanShow, WasFiltered, LayEntList, AutoFree );
        If Not CanShow Then Continue;
        If LayEntList <> Nil Then
        Begin
          For I:= 0 to LayEntList.Count - 1 do
            LayEntList[I].Draw( Grapher, Canvas, VisualWindow, dmNormal );
          If AutoFree Then
            FreeAndNil( LayEntList );
        End;
      End;

      TmpIndex := -1;
      If HasSelection Then
      Begin
        TmpIndex := Selection.IndexOf( TmpLayer );
        HasSelectionThis := TmpIndex >= 0;
      End
      Else
        HasSelectionThis := false;

      TmpClipIndex := -1;
      If HasClipped Then
      Begin
        TmpClipIndex := AGis.ClippedEntities.IndexOf( TmpLayer );
        HasClippedThis := TmpClipIndex >= 0;
      End
      Else
        HasClippedThis := false;

      With TmpLayer Do
      Begin
        If Not LayerInfo.Visible Or ( HasClipped And Not HasClippedThis ) Then Continue;
        IsMemLayer:= LayerInfo.IsCosmethic;

        IsTextHasShadow := LayerInfo.TextHasShadow;
        TheTextFixedSize := LayerInfo.TextFixedSize;

        IsLayerBeforePaintEntity := Assigned( TmpLayer.OnBeforePaintEntity );
        IsLayerAfterPaintEntity := Assigned( TmpLayer.OnAfterPaintEntity );

        If Not WasFiltered Then
          SetGraphicFilter( stOverlap, WCRect );

        First;
        StartBuffering;
        Try
          While Not Eof Do
          Begin
            If FThread<>Nil then
              Canvas.Lock;
            ARecno := Recno;
            Try
              If RecIsDeleted Or Not IsRectVisible( RecExtension, WCRect ) Then Continue;

              If ( Not IsScreenDevice ) And ( PrintMode <> pmAll ) Then
                Case PrintMode Of
                  pmSelection:
                    If Not ( HasSelectionThis And
                      Selection[TmpIndex].IsSelected( ARecno ) ) Then Continue;

                  pmExcludeSelection:
                    If HasSelectionThis And
                      Selection[TmpIndex].IsSelected( ARecno ) Then
                      Continue;
                End;
              If HasClippedThis And
                Not AGis.ClippedEntities[TmpClipIndex].IsSelected( ARecno ) Then
                Continue;

              EntityID := RecEntityID;

              If IsAerial And ( EntityID In NonAerialEntities ) Then Continue;

              if IsMemLayer then
              begin
                TmpEntity := TmpLayer.RecEntity;
                TmpEntity.FPainterObject := Self;
                TmpEntity.FBufferBitmap := BufferBitmap;
              end else
              begin
                TmpEntity := Entities[EntityID];
                RecLoadEntity2( TmpEntity );
              end;

              If HasSelectionThis And Selection[TmpIndex].IsSelected( ARecno ) Then
                DrawMode := dmSelection
              Else
                DrawMode := dmNormal;

              EntList:= Nil;
              If IsBeforePaintEntity Then
              Begin
                CanShow := True;
                AutoFree:= True;
                AGis.OnBeforePaintEntity( AGis,
                                          TmpLayer,
                                          ARecno,
                                          TmpEntity,
                                          Grapher,
                                          Canvas,
                                          VisualWindow,
                                          DrawMode,
                                          CanShow,
                                          EntList,
                                          AutoFree );
                If Not CanShow Then Continue;
              End;

              If IsLayerBeforePaintEntity then
              begin
                CanShow := True;
                AutoFree:= True;
                TmpLayer.OnBeforePaintEntity( AGis,
                                              TmpLayer,
                                              ARecno,
                                              TmpEntity,
                                              Grapher,
                                              Canvas,
                                              VisualWindow,
                                              DrawMode,
                                              CanShow,
                                              EntList,
                                              AutoFree );
                If Not CanShow Then Continue;
              end;

              If IsBeforeSome And Not ( DrawMode = dmSelection ) And Not IsAerial Then
              Begin
                If IsBeforeSymbol And ( EntityID = idPlace ) Then
                  AGis.OnBeforeSymbolPaint( AGis,
                                            TmpLayer,
                                            ARecno,
                                            Grapher,
                                            Canvas,
                                            VisualWindow,
                                            TEzPlace( TmpEntity ).SymbolTool );

                If IsBeforeFont Then
                Begin
                  If EntityID = idTrueTypetext Then
                  Begin
                    PrevFontHeight := TEzTrueTypeText( TmpEntity ).FontTool.Height;
                    AGis.OnBeforeFontPaint( AGis,
                                            TmpLayer,
                                            ARecno,
                                            Grapher,
                                            Canvas,
                                            VisualWindow,
                                            TEzTrueTypeText( TmpEntity ).FontTool );
                  End
                  Else If EntityID = idJustifVectText Then
                  Begin
                    With TEzJustifVectorText( tmpentity ) Do
                    Begin
                      PrevFontHeight := Height;
                      LabelFont.Height := Height;
                      LabelFont.Angle := Angle;
                      LabelFont.Color := FontColor;
                    End;
                    AGis.OnBeforeFontPaint( AGis,
                                            TmpLayer,
                                            ARecno,
                                            Grapher,
                                            Canvas,
                                            VisualWindow,
                                            LabelFont );
                    With TEzJustifVectorText( tmpentity ) Do
                    Begin
                      // font name is not modified yet
                      Height := LabelFont.Height;
                      Angle := LabelFont.Angle;
                      FontColor := LabelFont.Color;
                    End;
                  End
                  Else If EntityID = idFittedVectText Then
                  Begin
                    With TEzFittedVectorText( tmpentity ) Do
                    Begin
                      PrevFontHeight := Height;
                      If VectorFont <> Nil Then
                        LabelFont.Name := VectorFont.Name;
                      LabelFont.Height := Height;
                      LabelFont.Angle := Angle;
                      LabelFont.Color := FontColor;
                    End;
                    AGis.OnBeforeFontPaint( AGis,
                                            TmpLayer,
                                            ARecno,
                                            Grapher,
                                            Canvas,
                                            VisualWindow,
                                            LabelFont );
                    With TEzFittedVectorText( tmpentity ) Do
                    Begin
                      // font name is not modified yet
                      Height := LabelFont.Height;
                      Angle := LabelFont.Angle;
                      FontColor := LabelFont.Color;
                    End;
                  End;
                End;

                If IsBeforeBrush And ( TmpEntity Is TEzClosedEntity ) Then
                  AGis.OnBeforeBrushPaint( AGis,
                                           TmpLayer,
                                           ARecno,
                                           Grapher,
                                           Canvas,
                                           VisualWindow,
                                           TEzClosedEntity( TmpEntity ).Brushtool );

                If IsBeforePen And ( TmpEntity Is TEzOpenedEntity ) Then
                  AGis.OnBeforePenPaint( AGis,
                                         TmpLayer,
                                         ARecno,
                                         Grapher,
                                         Canvas,
                                         VisualWindow,
                                         TEzClosedEntity( TmpEntity ).PenTool );

              End;

              If ( EntityID = idTrueTypeText ) And ( TheTextFixedSize > 0 ) Then
                TEzTrueTypeText( TmpEntity ).FontTool.Height := Grapher.PointsToDistY( TheTextFixedSize );

              { paint text shadows }
              If IsTextHasShadow And IsScreenDevice And
                ( EntityID = idTrueTypeText ) And ( DrawMode = dmNormal ) Then
              Begin
                MyPtnW := Point2d( TmpEntity.Points[0].X + FontOffsetX,
                  TmpEntity.Points[0].Y + FontOffsetY );
                With TEzTrueTypeText( TmpEntity ) Do
                Begin
                  TextTmp := TEzTrueTypeText.CreateEntity(
                    MyPtnW, Text, FontTool.Height, FontTool.Angle );
                  TextTmp.FontTool.Name := FontTool.Name;
                  TextTmp.FontTool.Style := FontTool.Style;
                End;
                TextTmp.FontTool.Color := AGis.FFontShadowColor;
                TextTmp.Draw( Grapher, Canvas, VisualWindow, DrawMode );
                TextTmp.Free;
              End;

              { some special entities are clipped against the drawing area, and
               others against all the viewport area }
              if EntityID in ImageEntities then
                TmpEntity.Draw( Grapher, Canvas, WCRect{VisualWindow}, DrawMode )
              else
                TmpEntity.Draw( Grapher, Canvas, VisualWindow, DrawMode );

              If not FWasUpdated then FWasUpdated:= True;

              If ( DrawMode = dmNormal ) And IsOnShowDirection And
                 ( TmpEntity Is TEzOpenedEntity ) Then
              Begin
                CanShow := False;
                DirectionPos:= [];
                AGis.OnShowDirection( AGis,
                                      TmpLayer,
                                      ARecno,
                                      DirectionPos,
                                      DirectionPen,
                                      DirectionBrush,
                                      RevertDirection,
                                      CanShow );
                If CanShow And ( DirectionPos <> [] ) Then
                Begin
                  TmpEntity.ShowDirection( Grapher,
                                           Canvas,
                                           VisualWindow,
                                           DrawMode,
                                           DirectionPos,
                                           DirectionPen.FPenStyle,
                                           DirectionPen.Scale,
                                           DirectionBrush.FBrushStyle,
                                           RevertDirection );
                End;
              End;

              { draw here the entities returned on event OnBeforePaintEntity }
              If EntList <> Nil Then
              Begin
                For I:= 0 to EntList.Count - 1 do
                  EntList[I].Draw(Grapher, Canvas, VisualWindow, DrawMode );
                If AutoFree Then
                  FreeAndNil( EntList );
              End;

              If IsAfterPaintEntity Then
              Begin
                AGis.OnAfterPaintEntity( AGis,
                                         TmpLayer,
                                         ARecno,
                                         TmpEntity,
                                         Grapher,
                                         Canvas,
                                         VisualWindow,
                                         DrawMode );
              End;

              If IsLayerAfterPaintEntity Then
              Begin
                TmpLayer.OnAfterPaintEntity( AGis,
                                             TmpLayer,
                                             ARecno,
                                             TmpEntity,
                                             Grapher,
                                             Canvas,
                                             VisualWindow,
                                             DrawMode );
              End;

              If TmpEntity.FWasSuspended Then Exit;

              If IsScreenDevice Then
              Begin
                If (FThread = Nil) And FIsTimer And ( GetTickCount > FTickStart + AGis.FTimerFrequency ) Then
                Begin
                  CancelPrint := False;
                  AGis.OnGisTimer( AGis, CancelPrint );
                  If CancelPrint Then Exit;

                  FTickStart := GetTickCount;
                End Else If FThread <> Nil Then
                Begin

                  If GetTickCount > FTickStart + AGis.FTimerFrequency Then
                  begin
                    Canvas.UnLock;
                    //FThread.DrawBox.DoCopyCanvas;
                    with FThread do Synchronize(DoUpdate);
                    Canvas.Lock;

                    FTickStart := GetTickCount;
                  end;

                  If FThread.Terminated Then Exit;
                End;
              End
              Else
              Begin
                Inc( PrintedEntities );
                If GetTickCount >= ( FTickStart + APrintTimerFrequency ) Then
                Begin
                  If Assigned( AGis.OnPrintProgress ) Then
                  Begin
                    CancelPrint := False;
                    AGis.OnPrintProgress( AGis,
                      IMin( 100, MulDiv( PrintedEntities, 100, NumPrintEntities ) ),
                      CancelPrint );
                    If CancelPrint Then Exit;
                  End;
                  FTickStart := GetTickCount;
                End;
              End;

            Finally
              if Assigned(FThread) then Canvas.UnLock;
              TmpLayer.RecNo := ARecNo;
              Next;
            End;
          End;
        Finally
          EndBuffering;
          CancelFilter;
          If Not IsAerial And TmpLayer.LayerInfo.Visible And Assigned( AGis.OnAfterPaintLayer ) Then
          Begin
            LayEntList:= Nil;
            AutoFree:= True;
            AGis.OnAfterPaintLayer( AGis, TmpLayer, Grapher, LayEntList, AutoFree );
            If LayEntList <> Nil Then
            Begin
              For I:= 0 to LayEntList.Count - 1 do
                LayEntList[I].Draw( Grapher, Canvas, VisualWindow, dmNormal );
              If AutoFree Then
                FreeAndNil( LayEntList );
            End;
          End;

        End;
      End;
    End;
    FAllPainted:= True;
  Finally
    For Cont := Low( TEzEntityID ) To High( TEzEntityID ) Do
      Entities[Cont].Free;
    If WasClipped Then
    Begin
      Grapher.CanvasRegionStacker.PopAll( Canvas );
    End;
    If (FThread=Nil) And AGis.ShowWaitCursor Then
      Screen.Cursor := SavedCursor;
    If Not IsScreenDevice Then
    Begin
      If Assigned( AGis.OnPrintEnd ) Then
        AGis.OnPrintEnd( AGis );
    End;
    DirectionPen.Free;
    DirectionBrush.Free;
    LabelFont.Free;

    Grapher.EndOptimizer;

    If Assigned( AGis.OnAfterPaintLayers ) Then
      AGis.OnAfterPaintLayers( AGis );
  End;
End;

Procedure TEzBaseDrawBox.SendToBack;
Begin
  EzSystem.SendToBack( Self );
End;

Procedure TEzBaseDrawBox.BringToFront;
Begin
  EzSystem.BringToFront( Self );
End;

Procedure TEzBaseDrawBox.Notification( AComponent: TComponent; Operation: TOperation );
Begin
  If ( Operation = opRemove ) And ( AComponent = FGIS ) Then
  Begin
    FGIS := Nil;
  End;
  Inherited Notification( AComponent, Operation );
End;

Procedure TEzBaseDrawBox.CurrentExtents( Var AXMin, AYMin, AXMax, AYMax: Double );
Begin
  With Grapher.CurrentParams.VisualWindow Do
  Begin
    AXMin := xmin;
    AYMin := ymin;
    AXMax := xmax;
    AYMax := ymax;
  End;
End;

Procedure TEzBaseDrawBox.SetViewTo( Const AXMin, AYMin, AXMax, AYMax: Double );
Begin
  Grapher.SetViewTo( Rect2D( AXMin, AYMin, AXMax, AYMax ) );
  Repaint;
End;

function TEzBaseDrawBox.JoinSelection( DeleteOriginals: Boolean ): Integer;
Begin
  Result := EzSystem.CombineSelection( Self, DeleteOriginals );
End;

Procedure TEzBaseDrawBox.ExplodeSelection( PreserveOriginals: Boolean );
Begin
  EzSystem.ExplodeSelection( Self, PreserveOriginals );
End;

Procedure TEzBaseDrawBox.BlinkEntity( Entity: TEzEntity );
Begin
  EzSystem.BlinkEntityIndirect( Self, Entity );
End;

Procedure TEzBaseDrawBox.BlinkEntities;
begin
  EzSystem.BlinkEntities( Self );
end;

Procedure TEzBaseDrawBox.BlinkEntityEx( Const LayerName: String; RecNo: Integer );
Var
  Layer: TEzBaseLayer;
Begin
  Assert( FGIS <> Nil );
  Layer := GIS.Layers.LayerByName( LayerName );
  If Layer = Nil Then Exit;
  EzSystem.BlinkEntity( Self, Layer, RecNo );
End;

Procedure TEzBaseDrawBox.SelectionToPolygon;
Var
  I, J: Integer;
  Entity, TmpEntity: TEzEntity;
  SelLayer: TEzSelectionLayer;
  Layer: TEzBaseLayer;
Begin
  // Changes all selected polylines to polygons
  If Selection.Count = 0 Then Exit;
  For I := 0 To Selection.Count - 1 Do
  Begin
    SelLayer := Selection.Items[I];
    layer := SelLayer.Layer;
    For J := 0 To SelLayer.SelList.Count - 1 Do
    Begin
      Entity := Layer.LoadEntityWithRecno( SelLayer.SelList[J] );
      If Entity <> Nil Then
      Begin
        Try
          If ( Entity.EntityID = idPolyline ) And ( Entity.Points.Count > 2 ) Then
          Begin
            TmpEntity := TEzPolygon.Create( Entity.Points.Count );
            Try
              TEzOpenedEntity(TmpEntity).PenTool.Assign(TEzOpenedEntity(Entity).PenTool);
              TmpEntity.Points.Assign(Entity.Points);
              { fix the last point }
              If ( TmpEntity.Points.Parts.Count < 2 ) And ( Entity.Points.Count > 2 ) And
                Not EqualPoint2D( Entity.Points[0], Entity.Points[Entity.Points.Count - 1] ) Then
                TmpEntity.Points.Add( TmpEntity.Points[0] );
              if ( TmpEntity.Points.Count > 2 ) And
                 not EqualPoint2d(TmpEntity.Points[0],
                                  TmpEntity.Points[TmpEntity.Points.Count-1]) then
                TmpEntity.Points.Add(TmpEntity.Points[0]);
              Layer.UpdateEntity( SelLayer.SelList[J], TmpEntity );
            Finally
              TmpEntity.Free;
            End;
          End;
        Finally
          FreeAndNil( Entity );
        End;
      End;
    End;
  End;
  Selection.RepaintSelectionArea;
End;

Procedure TEzBaseDrawBox.SelectionToPolyline;
Var
  I, J: Integer;
  Entity, TmpEntity: TEzEntity;
  SelLayer: TEzSelectionLayer;
  Layer: TEzBaseLayer;
Begin
  (* Changes all selected polygons to polylines  *)
  If Selection.Count = 0 Then Exit;
  For I := 0 To Selection.Count - 1 Do
  Begin
    SelLayer := Selection.Items[I];
    layer := SelLayer.Layer;
    For J := 0 To SelLayer.SelList.Count - 1 Do
    Begin
      Entity := layer.LoadEntityWithRecno( SelLayer.SelList[J] );
      If Entity <> Nil Then
      Begin
        Try
          If ( Entity.EntityID = idPolygon ) Then
          Begin
            TmpEntity := TEzPolyLine.Create( Entity.Points.Count );
            Try
              TEzOpenedEntity(TmpEntity).PenTool.Assign(TEzOpenedEntity(Entity).PenTool);
              TmpEntity.Points.Assign(Entity.Points);
              Layer.UpdateEntity( SelLayer.SelList[J], TmpEntity );
            Finally
              TmpEntity.Free;
            End;
          End;
        Finally
          FreeAndNil( Entity );
        End;
      End;
    End;
  End;
  FSelection.RepaintSelectionArea;
End;

Procedure TEzBaseDrawBox.SelectionChangeDirection;
Var
  I, J: Integer;
  TmpEnt: TEzEntity;
  Found: Boolean;
  SelLayer: TEzSelectionLayer;
  layer: TEzBaseLayer;
Begin
  If Selection.Count = 0 Then Exit;
  Found := False;
  For I := 0 To Selection.Count - 1 Do
  Begin
    SelLayer := Selection.Items[I];
    layer := SelLayer.Layer;
    For J := 0 To SelLayer.SelList.Count - 1 Do
    Begin
      TmpEnt := layer.LoadEntityWithRecno( SelLayer.SelList[J] );
      If TmpEnt <> Nil Then
      Begin
        Try
          If TmpEnt Is TEzOpenedEntity Then
          Begin
            TmpEnt.Points.RevertDirection;
            Layer.UpdateEntity( SelLayer.SelList[J], TmpEnt );
            Found := True;
          End;
        Finally
          TmpEnt.Free;
        End;
      End;
    End;
  End;
  If Found Then
    Selection.RepaintSelectionArea;
End;

Procedure TEzBaseDrawBox.MovePlace( Const LayerName: String;
  RecNo: Integer; Const NewX, NewY: Double );
Var
  Ent: TEzEntity;
  OldExtents, NewExtents: TEzRect;
  Offset: Double;
  Layer: TEzBaseLayer;
Begin
  Layer := GIS.Layers.LayerByName( LayerName );
  If ( Layer = Nil ) Or ( RecNo < 1 ) Or ( RecNo > Layer.RecordCount ) Then Exit;
  Ent := Layer.LoadEntityWithRecNo( RecNo );
  If Ent = Nil Then Exit;
  Try
    If Not ( Ent.EntityID = idPlace ) Then Exit;
    OldExtents := Ent.FBox;
    Offset := Grapher.DistToRealY( 5 ); // 5 pixeles margin
    InflateRect2D( OldExtents, Offset, Offset );
    Ent.Points[0] := Point2D( NewX, NewY );
    Layer.UpdateEntity( RecNo, Ent );
    NewExtents := Ent.FBox;
    InflateRect2D( NewExtents, Offset, Offset );
  Finally
    Ent.Free;
  End;

  If IsRectVisible( OldExtents, Grapher.CurrentParams.VisualWindow ) Then
    UpdateViewport( OldExtents );

  If IsRectVisible( NewExtents,  Grapher.CurrentParams.VisualWindow ) Then
    UpdateViewport( NewExtents );

  Refresh;
End;

Procedure TEzBaseDrawBox.ExpressionSelect( Const Layername, Expression: String );
Var
  Layer: TEzBaseLayer;

  Procedure DoSelect( aLayer: TEzBaseLayer );
  Begin
    aLayer.DefineScope( Expression );
    aLayer.First;
    While Not aLayer.Eof Do
    Begin
      FSelection.Add( aLayer, aLayer.Recno );
      aLayer.Next;
    End;
    aLayer.CancelFilter;
  End;

Begin
  If FGIS = Nil Then Exit;
  If Length( Layername ) > 0 Then
  Begin
    Layer := FGIS.Layers.LayerByName( Layername );
    If Layer = Nil Then
      EzGISError( SLayerNotFound );
    DoSelect( Layer );
  End
  Else
  Begin
    If FGis.CurrentLayer <> Nil Then
      DoSelect( FGis.CurrentLayer );
  End;
End;

Procedure TEzBaseDrawBox.PolygonSelect( Polygon: TEzEntity;
  Const Layername, QueryExpression: String; aOperator: TEzGraphicOperator );
Var
  Layer: TEzBaseLayer;
  i: Integer;

  Procedure DoSelect( aLayer: TEzBaseLayer );
  Begin
    If Not aLayer.DefinePolygonScope( Polygon, QueryExpression, aOperator ) Then Exit;
    aLayer.First;
    While Not aLayer.Eof Do
    Begin
      Try
        FSelection.Add( aLayer, aLayer.Recno );
      Finally
        aLayer.Next;
      End;
    End;
    aLayer.CancelFilter;
  End;

Begin
  If FGIS = Nil Then Exit;
  If Length( Layername ) > 0 Then
  Begin
    Layer := FGIS.Layers.LayerByName( Layername );
    If Layer = Nil Then
      EzGISError( SLayerNotFound );
    DoSelect( Layer );
  End
  Else
    For i := 0 To FGIS.Layers.Count - 1 Do
      DoSelect( FGIS.Layers[i] );
End;

Procedure TEzBaseDrawBox.RectangleSelect( Const AxMin, AyMin, AxMax, AyMax: double;
  Const Layername, QueryExpression: String; aOperator: TEzGraphicOperator );
Var
  Polygon: TEzEntity;
Begin
  Polygon := TEzPolygon.CreateEntity( [Point2D( AxMin, AyMin ),
    Point2D( AxMax, AyMin ),
      Point2D( AxMax, AyMax ),
      Point2D( AxMin, AyMax ),
      Point2D( AxMin, AyMin )] );
  Try
    Self.PolygonSelect( Polygon, Layername, QueryExpression, aOperator );
  Finally
    Polygon.Free;
  End;
End;

Procedure TEzBaseDrawBox.BufferSelect( Polyline: TEzEntity;
  Const Layername, QueryExpression: String; aOperator: TEzGraphicOperator;
  CurvePoints: Integer; Const Distance: Double );
Var
  Polygon: TEzEntity;
Begin
  Polygon := EzSystem.CreateBufferFromEntity( Polyline, CurvePoints, Distance, True );
  Try
    Self.PolygonSelect( Polygon, Layername, QueryExpression, aOperator );
  Finally
    Polygon.Free;
  End;
End;

Procedure TEzBaseDrawBox.PolylineSelect( Polyline: TEzEntity;
  Const Layername, QueryExpression: String );
Begin
  Self.PolygonSelect( Polyline,
    Layername,
    QueryExpression,
    goIntersects );
End;

Procedure TEzBaseDrawBox.GroupSelection;
Var
  Layer: TEzBaseLayer;
  I, J, Index: Integer;
  Ent, Group: TEzEntity;
  TmpR: TEzRect;
  SelLayer: TEzSelectionLayer;
Begin
  { create a group entity from the selected entities }
  Assert( FGIS <> Nil );
  If FSelection.Count <> 1 Then
    EzGISError( SCannotGroup );
  If FSelection.NumSelected < 2 Then
    Exit;
  TmpR := FSelection.GetExtension;
  Group := TEzGroupEntity.CreateEntity;
  For i := 0 To FGIS.Layers.Count - 1 Do
  Begin
    Layer := FGIS.Layers[i];
    Index := FSelection.IndexOf( Layer );
    If Index >= 0 Then
    Begin
      SelLayer := FSelection[Index];
      For J := 0 To SelLayer.SelList.Count - 1 Do
      Begin
        Ent := Layer.LoadEntityWithRecno( SelLayer.SelList[J] );
        If Ent = Nil Then
          Continue;
        TEzGroupEntity( Group ).Add( Ent );
      End;
      DeleteSelection;
      Layer.AddEntity( Group );
      RepaintRect( TmpR );
      Break;
    End;
  End;
  Group.Free;
End;

Procedure TEzBaseDrawBox.UnGroupSelection;
Var
  Layer: TEzBaseLayer;
  I, J, K, Index: Integer;
  Ent, Group: TEzEntity;
  TmpR: TEzRect;
  SelLayer: TEzSelectionLayer;
Begin
  Assert( FGIS <> Nil );
  If FSelection.Count = 0 Then  exit;
  TmpR := FSelection.GetExtension;
  For i := 0 To FGIS.Layers.Count - 1 Do
  Begin
    Layer := FGIS.Layers[i];
    Index := FSelection.IndexOf( Layer );
    If Index >= 0 Then
    Begin
      SelLayer := FSelection[Index];
      For J := 0 To SelLayer.SelList.Count - 1 Do
      Begin
        Group := layer.LoadEntityWithRecno( SelLayer.SelList[J] );
        If ( Group = Nil ) Or Not ( Group.EntityID = idGroup ) Then
        Begin
          Group.Free;
          Continue;
        End;
        For K := 0 To TEzGroupEntity( Group ).Count - 1 Do
        Begin
          Ent := TEzGroupEntity( Group ).Entities[K];
          Layer.AddEntity( Ent );
        End;
        Layer.DeleteEntity( SelLayer.SelList[J] );
        Group.free;
      End;
      FSelection.Clear;
      RepaintRect( TmpR );
      Break;
    End;
  End;
End;

Function TEzBaseDrawBox.CreateEntity( EntType: TEzEntityID ): TEzEntity;
Var
  p: TEzPoint;
  r: TEzRect;
Begin
  result := Nil;
  p := Point2d( 0, 0 );
  r := Rect2d( 0, 0, 0, 0 );
  Case entType Of
    idNone:
      Result := TEzNone.CreateEntity;
    idPoint:
      Result := TEzPointEntity.CreateEntity( p, clblack );
    idPlace:
      Result := TEzPlace.CreateEntity( p );
    idPolyline:
      Result := TEzPolyLine.CreateEntity( [p, p] );
    idPolygon:
      Result := TEzPolygon.CreateEntity( [p, p] );
    idRectangle:
      Result := TEzRectangle.CreateEntity( p, p );
    idArc:
      Result := TEzArc.CreateEntity( p, p, p );
    idEllipse:
      Result := TEzEllipse.CreateEntity( p, p );
    idPictureRef:
      Result := TEzPictureRef.CreateEntity( p, p, '' );
    idPersistBitmap:
      Result := TEzPersistBitmap.CreateEntity( p, p, '' );
    idBandsBitmap:
      Result := TEzBandsBitmap.CreateEntity( p, p, '' );
    idSpline:
      Result := TEzSpline.CreateEntity( [p, p] );
    idTable:
      Result := TEzSpline.CreateEntity( [p, p] );
    idGroup:
      Result := TEzGroupEntity.CreateEntity;
    idJustifVectText:
      Result := TEzJustifVectorText.CreateEntity( r, 0, '' );
    idFittedVectText:
      Result := TEzFittedVectorText.CreateEntity( p, '', 0, 0, 0 );
    idPreview:
      Result := TEzPreviewEntity.CreateEntity( p, p, pmAll, 0 );
  End;
  If result <> Nil Then
    Result.Points.Clear;
End;

Procedure TEzBaseDrawBox.BlinkThis( Const X, Y: Double );
Var
  Ent: TEzEntity;
  Delta: Double;
Begin
  { This method will blink a given coordinate on the map }
  Delta := Grapher.PointsToDistY( 9 ) / 2;
  Ent := TEzPolyLine.CreateEntity( [Point2D( X - Delta, Y - Delta ),
    Point2D( X + Delta, Y - Delta ),
      Point2D( X + Delta, Y + Delta ),
      Point2D( X - Delta, Y + Delta ),
      Point2D( X - Delta, Y - Delta ),
      Point2D( X, Y - Delta ),
      Point2D( X, Y + Delta ),
      Point2D( X - Delta, Y ),
      Point2D( X + Delta, Y )] );
  Try
    Ent.Points.Parts.Add( 0 );
    Ent.Points.Parts.Add( 5 );
    Ent.Points.Parts.Add( 7 );
    If ent Is TEzOpenedEntity Then
      TEzOpenedEntity( Ent ).Pentool.Width := 0;
    EzSystem.BlinkEntityIndirect( Self, Ent );
  Finally
    Ent.Free;
  End;
End;

Function TEzBaseDrawBox.GetCurrentOneSelectedEntity( Var LayerName: String; Var Recno: Integer ): TEzEntity;
Begin
  Result := Nil;
  Layername := '';
  //Check only one Selection.
  If FSelection.NumSelected <> 1 Then Exit;
  With FSelection[0] Do
  Begin
    Recno:= SelList[0];
    Result := Layer.LoadEntityWithRecNo( Recno );
    Layername := Layer.Name;
  End;
End;

Procedure TEzBaseDrawBox.drawpie( Const Drawlayer, FieldName: String );
Var
  layer: TEzBaseLayer;
  Pos: TEzPoint;
  TmpEnt: TEzEntity;
  VL, CL: TStringList;
  atRate: double;

  Procedure MakehalfCircle( Const Pos: TEzPoint; Rad: Double; ValueList, ColorList: TStringList );
  Var
    obj: TEzPolygon;
    text: TEzFittedVectorText;
    textpt: TEzPoint;
    VtxList1: Array[0..180] Of TEzPoint;
    Sp1, sum: Double;
    X1, Y1, xx, yy, m1, i, j: Integer;
    i1, k1, k2, n1: Extended;
    X0, y0, X, Y: Extended;
    Sx, Sy: String;

  Begin
    X0 := Pos.x;
    y0 := Pos.y;
    X1 := Round( Pos.x );
    y1 := Round( Pos.y );
    i := ValueList.Count - 1;
    sum := 0;
    For j := 0 To i Do
    Begin
      Sum := Sum + strToFloat( ValueList[j] );
    End;

    k2 := 0;

    For j := 0 To i Do
    Begin

      Sp1 := ( strToFloat( ValueList[j] ) ) / ( sum );
      If sp1 = 0 Then
        Continue;
      k1 := sp1 * ( 2 * pi );
      i1 := k2;
      k2 := k2 + k1;
      n1 := k1 / 179;
      m1 := 0;
      vtxList1[m1].x := X1;
      VtxList1[m1].y := Y1;

      While m1 <= 180 Do
      Begin
        X := Rad * sin( i1 );
        y := Rad * cos( i1 );
        X := X0 + X;
        y := Y0 + y;
        str( X: 10: 0, Sx );
        Xx := strToint( Sx );
        str( Y: 10: 0, Sy );
        yy := strToInt( Sy );
        inc( m1 );
        vtxlist1[m1].x := XX;
        vtxList1[m1].y := yy;
        i1 := i1 + n1;
      End;

      Obj := TEzPolygon.CreateEntity( vtxList1 );
      TEzClosedEntity( obj ).Brushtool.Color := strToint( colorList[j] );
      TEzClosedEntity( obj ).Brushtool.Pattern := 1;
      TempEntities.Add( obj );
      Obj.Centroid( Textpt.x, textpt.y );
      Textpt.x := Textpt.X - 75;
      Textpt.y := Textpt.y;
      Text := TEzFittedVectorText.CreateEntity( textpt,
                                                ValueList[j],
                                                100,
                                                -1,
                                                0 );
      TempEntities.Add( Text );
    End;
  End;

Begin
  Layer := GIS.Layers.LayerByName( DrawLayer );
  If layer = Nil Then Exit;

  VL := TStringlist.create;
  CL := Tstringlist.create;

  CL.Add( inttostr( clblue ) );
  CL.Add( inttostr( clwhite ) );

  Layer.First;
  Layer.StartBuffering;
  Try
    While Not Layer.Eof Do
    Begin
      If Layer.RecIsDeleted Then
      Begin
        Layer.Next;
        continue;
      End;
      layer.DBTable.Recno := Layer.Recno;
      TmpEnt := layer.RecLoadEntity;
      Tmpent.Centroid( pos.x, pos.y );
      VL.Clear;
      atRate := layer.DBTable.FloatGet( FieldName );
      VL.Add( floatToStr( atRate ) );
      VL.Add( floatToStr( 1.0 - atRate ) );
      Tmpent.free;

      MakehalfCircle( Pos, 200, VL, CL );

      Layer.Next;
    End;
  Finally
    Layer.EndBuffering;
  End;

  VL.free;
  Cl.free;

End;

Procedure TEzBaseDrawBox.CopyToClipboardAsBMP;
Begin
  Clipboard.Clear;
  Clipboard.Assign( ScreenBitmap );
End;

Procedure TEzBaseDrawBox.CopyToClipboardAsEMF;
Var
  MyFormat: Word;
  AData: Cardinal;
  APalette: HPalette;
  Metafile: TMetafile;
  MetafileCanvas: TMetafileCanvas;
  ABox: TEzRect;

Begin
  Metafile := TMetafile.Create;

  MetaFile.width := Width;
  MetaFile.Height := height;
  Metafile.Enhanced := false;

  ABox := Grapher.CurrentParams.VisualWindow;
  MetafileCanvas :=
    TMetafileCanvas.CreateWithComment( MetaFile, 0, 'EzGIS','EzGIS Components' );

  With TEzPainterObject.Create(Nil) Do
    Try
      DrawEntities( ABox,
                    FGIS,
                    MetafileCanvas,
                    Grapher,
                    Selection,
                    FALSE,
                    FALSE,
                    pmAll,
                    Nil );
    Finally
      Free;
    End;

  MetafileCanvas.Free;

  Try
    Metafile.SaveToClipboardFormat( MyFormat, AData, APalette );
  Finally
    Metafile.free;
  End;

  ClipBoard.SetAsHandle( MyFormat, AData );
End;

{ start of thematic functions }
// Pie Graph Thematic Creation
// Programmed by nakijun, 2001-10-6

//Field Name splits to stringlist from comma separated string;
//nakijun

Function SplitbySemiColon( const FieldNames: String ): TStringList;
Var
  S1, S2: String;
  i: Integer;

  Function splitsSemiColon( const ss: String; Var s1, s2: String ): boolean;
  Var
    i: Integer;
  Begin
    If pos( ';', ss ) = 0 Then
    Begin
      s1 := ss;
      s2 := ss;
      result := false;
      exit;
    End;
    i := pos( ';', ss );
    s1 := copy( ss, 1, i - 1 );
    s2 := copy( ss, i + 1, length( ss ) - i );
    result := true;
  End;

  Function CountSemiColon( const SS: String ): Integer;
  Var
    i: Integer;
  Begin
    Result := 0;
    For i := 1 To length( ss ) Do
      If SS[i] = ';' Then
        Inc( result );
  End;

Begin
  Result := Nil;
  If FieldNames <> '' Then
  Begin
    Result := TStringList.Create;
    S1 := FieldNames;
    For i := 0 To CountSemiColon( FieldNames ) Do
    Begin
      SplitsSemiColon( S1, S2, S1 );
      If S2 <> '' Then
        Result.add( S2 )
      Else
        Result.Add( S1 );
    End;
  End;
End;

Procedure TEzBaseDrawBox.CreatePieThematic( Const LayerName, FieldNames: String;
  Fill: Boolean; Radian: Double; StartColor: Integer );
Var
  layer: TEzBaseLayer;
  Pos: TEzPoint;
  TmpEnt: TEzEntity;
  fl, vl: TStringList;
  i: Integer;
  FMax, Value: double;
  cnt: Integer;
  Group: TEzGroupEntity;
  FileName: String;
  CosmethicLayer: TEzBaseLayer;
  PtInclude: Array[0..100] Of boolean;
  TxPt: Array[0..100] Of TEzPoint; // dimensioned to possible max number of fields passed
  xy: Array[0..180] Of TEzPoint;

  Procedure MakehalfCircle( Const Pos: TEzPoint; Rad: Double; ValueList: TStringList );
  Var
    PgEnt: TEzPolygon;
    TxEnt: TEzFittedVectorText;
    Sp1, sum: Double;
    m1, n, nclr, j: Integer;
    i1, k1, k2, n1: double;
    X0, y0, X, Y: double;

  Begin
    X0 := Pos.x;
    y0 := Pos.y;
    n := imin( 100, ValueList.Count ) - 1;

    //Sum of all value
    sum := 0;
    For j := 0 To n Do
      Sum := Sum + strToFloat( ValueList[j] );

    Rad := Rad * sum / FMax;

    FillChar( PtInclude, sizeof( PtInclude ), 0 );

    k2 := 0;
    For j := 0 To n Do
    Begin
      //if j>n then break;  // why is delphi doing this ???????????????????????????
      Sp1 := ( strToFloat( ValueList[j] ) ) / ( sum );
      If sp1 = 0 Then
        Continue;
      k1 := sp1 * ( 2 * pi ); //Angle of Pie by value percent
      i1 := k2; //Pie's Start angle
      k2 := k2 + k1; //Next Pie's Start Angle
      n1 := k1 / 179; //Angle Splits.

      m1 := 0;
      xy[0].X := x0;
      xy[0].y := y0;

      While m1 <= 180 Do
      Begin
        X := Rad * sin( i1 );
        y := Rad * cos( i1 );
        X := X0 + X;
        y := Y0 + y;
        inc( m1 );
        xy[m1].X := x;
        xy[m1].y := y;
        i1 := i1 + n1;
      End;

      PgEnt := TEzPolygon.CreateEntity( xy );
      nclr := ThematicSeriesColors.Count;
      If Fill Then
      Begin
        TEzPolygon( PgEnt ).Brushtool.Color := ThematicSeriesColors[( j + StartColor ) Mod nclr];
        TEzPolygon( PgEnt ).Brushtool.Pattern := 1;
      End
      Else
      Begin
        With TEzPolygon( PgEnt ) Do
        Begin
          Brushtool.Pattern := 0;
          Pentool.Style := 1;
          Pentool.Color := ThematicSeriesColors[( j + StartColor ) Mod nclr];
        End;
      End;
      PgEnt.Centroid( Txpt[j].x, Txpt[j].y );
      Group.Add( PgEnt );
      PtInclude[j] := true;
    End;

    //avoiding text hideing from another pie polygon,
    //Text will draw final drawing time.
    For j := 0 To n Do
    Begin
      If Not PtInclude[j] Then
        Continue;
      //create text and Calc Text location and height here.
      Y := Rad / 4;
      TxEnt := TEzFittedVectorText.CreateEntity( TxPt[j],
        ValueList[j],
        Y,
        -1,
        0 );
      TxEnt.MakePolyPointsByCenter( TxPt[j] );
      With TEzFittedVectorText( txent ) Do
      Begin
        Pentool.Style := 0;
        Brushtool.Pattern := 0;
      End;
      Group.Add( TxEnt );
    End;
  End;

Begin
  vl := TStringlist.create;

  layer := GIS.Layers.LayerByName( LayerName );
  If ( Layer = Nil ) Or ( Layer.DBTable = Nil ) Then
    exit;

  //initialize
  CosmethicLayer := FGIS.FoundFirstCosmethicLayer;
  If CosmethicLayer = Nil Then
  Begin
    // create a cosmethc layer
    FileName := GetTemporaryLayerName( AddSlash( ExtractFilePath( GIS.FileName ) ), 'CSM' );
    CosmethicLayer := GIS.Layers[GIS.Layers.Add( FileName, ltMemory )];
    CosmethicLayer.Open;
  End
  Else
  Begin
    // clear the cosmethic layer
    CosmethicLayer.Open;
    CosmethicLayer.Zap;
  End;
  fl := SplitbySemiColon( FieldNames );
  If fl.count = 0 Then exit;

  FMax := -1E20;
  Layer.First;
  While Not Layer.Eof Do
  Begin
    If Layer.RecIsDeleted Then
    Begin
      Layer.Next;
      Continue;
    End;
    Layer.DBTable.RecNo := Layer.Recno;
    value := 0;
    For cnt := 0 To fl.count - 1 Do
      Value := Value + layer.DBTable.FloatGet( fl[cnt] );
    FMax := dMax( Value, FMax );

    Layer.Next;
  End;

  Radian := Grapher.DistToRealY( trunc( Radian ) );

  Layer.First;
  If Not Layer.Eof Then
    Repeat
      If layer.RecIsDeleted = false Then
      Begin
        Layer.DBTable.RecNo := Layer.Recno;
        VL.Clear;
        For i := 0 To fl.count - 1 Do
          vl.add( layer.DBTable.StringGet( fl[i] ) );

        TmpEnt := layer.RecLoadEntity;
        Tmpent.Centroid( pos.x, pos.y );
        Tmpent.free;

        Group := TEzGroupEntity.CreateEntity;
        MakehalfCircle( Pos, Radian, VL );
        CosmethicLayer.AddEntity( Group );
        Group.Free;
      End;

      Layer.Next;
    Until layer.Eof;

  vL.free;
  fl.free;
  Repaint;
End;

// Bar Graph Thematic Creation
// Programmed by nakijun, 2001-10-6

Procedure TEzBaseDrawBox.CreateBarThematic( Const LayerName, FieldNames: String;
  Fill: Boolean; Width, Height: Double; StartColor: Integer );
Var
  layer: TEzBaseLayer;
  Pos: TEzPoint;
  TmpEnt: TEzEntity;
  fl, vl: TStringList;
  i: Integer;
  Group: TEzGroupEntity;
  FileName: String;
  CosmethicLayer: TEzBaseLayer;

  FMax, Value: double;
  cnt: Integer;

  Procedure MakeBar( Const Pos: TEzPoint; ValueList: TStringList );
  Var
    pgent: TEzPolygon;
    txent: TEzFittedVectorText;
    xy: Array[0..4] Of TEzPoint;
    th, x0, Sp1, sum: Double;
    xpos, ypos, subwidth: double;
    j, n, nclr: Integer;
    ratio: double;

  Begin
    xpos := pos.X - width / 2;
    X0 := Xpos;
    ypos := Pos.Y;
    subwidth := width / ValueList.count; //width of each bar

    n := ValueList.Count - 1;
    sum := 0;
    For j := 0 To n Do
      Sum := Sum + strToFloat( ValueList[j] ); //sum of whole value

    {width := width * sum / FMax;
    height := height * sum / Fmax;}
    ratio := sum / Fmax;
    subwidth := subwidth * ratio;

    For j := 0 To n Do
    Begin
      If j > n Then
        break;
      If ( Sum <> 0 ) And ( Ratio <> 0 ) Then
        sp1 := ( strToFloat( ValueList[j] ) ) / sum * height * Ratio
      Else
        sp1 := 0;

      Xpos := x0 + j * subwidth;

      //Starting Point
      xy[0].x := xpos;
      xy[0].y := Ypos;
      xy[1].x := xpos - subwidth;
      xy[1].y := Ypos;
      xy[2].x := xpos - subwidth;
      xy[2].y := Ypos + sp1;
      xy[3].x := xpos;
      xy[3].y := Ypos + sp1;
      xy[4].x := xpos;
      xy[4].y := Ypos;

      pgent := TEzPolygon.CreateEntity( xy );
      nclr := ThematicSeriesColors.Count;
      If Fill Then
      Begin
        PgEnt.Brushtool.Color := ThematicSeriesColors[( j + StartColor ) Mod nclr];
        pgent.Brushtool.Pattern := 1;
      End
      Else
      Begin
        pgent.Brushtool.Pattern := 0;
        pgent.Pentool.Style := 1;
        PgEnt.Pentool.Color := ThematicSeriesColors[( j + StartColor ) Mod nclr];
      End;
      Group.Add( pgent );

      th := subwidth / length( inttostr( trunc( sum ) ) );
      TxEnt := TEzFittedVectorText.CreateEntity( xy[1], ValueList[j], th, -1, 0 );
      TxEnt.MakePolyPointsByCenter( point2d( xy[0].x - subwidth / 2, xy[2].y - sp1 / 2 ) );
      TxEnt.Pentool.Style := 0;
      TxEnt.Brushtool.Pattern := 0;
      Group.Add( TxEnt );
    End;
  End;

Begin
  VL := TStringlist.create;

  layer := GIS.Layers.LayerByName( LayerName );
  If ( Layer = Nil ) Or ( Layer.DBTable = Nil ) Then
    exit;

  //initialize
  CosmethicLayer := FGIS.FoundFirstCosmethicLayer;
  If CosmethicLayer = Nil Then
  Begin
    // create a cosmethc layer
    FileName := GetTemporaryLayerName( AddSlash( ExtractFilePath( GIS.FileName ) ), 'CSM' );
    CosmethicLayer := GIS.Layers[GIS.Layers.Add( FileName, ltMemory )];
    CosmethicLayer.Open;
  End
  Else
  Begin
    // clear the cosmethic layer
    CosmethicLayer.Open;
    CosmethicLayer.Zap;
  End;

  fl := SplitbySemiColon( FieldNames );
  If fl.count = 0 Then
    exit;

  Layer.First;
  If Layer.Eof Then
    Exit;

  //Calc Min,Max for bar's sizeing.
  FMax := -1E20;
  Layer.first;
  While Not Layer.Eof Do
  Begin
    If Layer.RecIsDeleted Then
    Begin
      Layer.Next;
      Continue;
    End;
    Layer.DBTable.Recno := Layer.Recno;
    value := 0;
    For cnt := 0 To fl.count - 1 Do
      Value := Value + layer.DBTable.FloatGet( fl[cnt] );
    FMax := dMax( Value, FMax );

    Layer.Next;
  End;

  width := Grapher.DistToRealX( trunc( width ) );
  height := Grapher.DistToRealY( trunc( height ) );

  Layer.First;
  If Not Layer.Eof Then
    Repeat
      If layer.RecIsDeleted = false Then
      Begin
        Layer.DBTable.RecNo := Layer.Recno;
        VL.Clear;
        For i := 0 To fl.count - 1 Do
          vl.add( layer.DBTable.StringGet( fl[i] ) );

        TmpEnt := layer.RecLoadEntity;
        Tmpent.Centroid( pos.x, pos.y );
        Tmpent.free;

        Group := TEzGroupEntity.CreateEntity;
        MakeBar( Pos, VL );
        CosmethicLayer.AddEntity( Group );
        Group.Free;
      End;
      Layer.Next;
    Until layer.Eof;

  vl.free;
  fl.free;
  Repaint;
End;

Procedure TEzBaseDrawBox.CreateDotThematic( Const Layername, FieldName: String;
  Fill: Boolean; DotRange: Double; Dotsize, DotColor: Integer );
Var
  layer: TEzBaseLayer;
  TmpEnt: TEzEntity;
  fl, vl: TStringList;
  i: Integer;
  hWid: double; //half width
  Group: TEzGroupEntity;
  FileName: String;
  CosmethicLayer: TEzBaseLayer;

  Procedure MakeDot( Ent: TEzEntity; ValueList: TStringList );
  Var
    pgent: TEzEllipse;
    xpos, ypos, xwid, ywid: double;
    i, j, k, n: Integer;
    EBox: TEzRect;
  Begin
    n := ValueList.Count - 1;

    xwid := Ent.FBox.Emax.X - Ent.FBox.Emin.X;
    ywid := Ent.FBox.Emax.Y - Ent.FBox.Emin.Y;

    randomize;
    For i := 0 To n Do
    Begin
      k := round( strToFloat( ValueList[i] ) / DotRange );
      For j := 0 To k Do
      Begin
        Repeat
          xpos := Ent.FBox.Emin.X + random * Xwid;
          ypos := Ent.FBox.Emin.Y + random * Ywid;
          If Ent.IsPointInsideMe( Xpos, YPos ) Then
            break;
        Until false;

        EBox.Emin.X := XPos - hwid;
        EBox.Emax.x := Xpos + hwid;
        EBox.Emin.Y := YPos - hwid;
        EBox.Emax.Y := Ypos + hwid;

        pgent := TEzEllipse.CreateEntity( ebox.emin, ebox.emax );
        If Fill Then
        Begin
          PgEnt.Brushtool.Color := DotColor;
          pgent.Brushtool.Pattern := 1;
          pgent.Pentool.Style := 0;
        End
        Else
        Begin
          pgent.Brushtool.Pattern := 0;
          pgent.Pentool.Style := 1;
          pgent.Pentool.Color := DotColor;
        End;
        Group.Add( PgEnt );
      End;
    End;
  End;

Begin
  If FGis = Nil Then
    exit;
  VL := TStringlist.create;

  layer := GIS.Layers.LayerByName( LayerName );
  If ( Layer = Nil ) Or ( Layer.DBTable = Nil ) Then
    exit;

  //initialize
  CosmethicLayer := FGIS.FoundFirstCosmethicLayer;
  If CosmethicLayer = Nil Then
  Begin
    // create a cosmethc layer
    FileName := GetTemporaryLayerName( AddSlash( ExtractFilePath( GIS.FileName ) ), 'CSM' );
    CosmethicLayer := GIS.Layers[GIS.Layers.Add( FileName, ltMemory )];
    CosmethicLayer.Open;
  End
  Else
  Begin
    // clear the cosmethic layer
    CosmethicLayer.Open;
    CosmethicLayer.Zap;
  End;

  fl := SplitbySemiColon( FieldName );
  If fl.Count = 0 Then
    exit;

  //calc dot size
  hwid := Grapher.DistToRealX( Dotsize );

  Layer.First;
  If Not Layer.Eof Then
    Repeat
      If layer.RecIsDeleted = false Then
      Begin
        Layer.DBTable.RecNo := Layer.Recno;
        VL.Clear;
        For i := 0 To fl.count - 1 Do
          vl.add( Layer.DBTable.StringGet( fl[i] ) );

        Group := TEzGroupEntity.CreateEntity;
        TmpEnt := layer.RecLoadEntity;
        MakeDot( TmPent, vl );
        Tmpent.free;
        CosmethicLayer.AddEntity( Group );
        Group.Free;
      End;

      Layer.Next;
    Until layer.Eof;

  vl.free;
  fl.free;
  Repaint;
End;

Procedure TEzBaseDrawBox.CreateSymbolThematic( Const Layername, FieldName: String;
  SymbolSize, SymbolIndex: Integer );
Var
  layer: TEzBaseLayer;
  Pos: TEzPoint;
  TmpEnt: TEzEntity;
  fl, vl: TStringList;
  i: Integer;

  FMax, Value: double;
  cnt: Integer;
  symsize: double;
  Group: TEzGroupEntity;
  FileName: String;
  CosmethicLayer: TEzBaseLayer;

  Procedure MakeSymbol( Const Pos: TEzPoint; height: Double; ValueList: TStringList );
  Var
    PgEnt: TEzPlace;
    i, j: Integer;
  Begin
    i := ValueList.Count - 1;
    For j := 0 To i Do
    Begin
      height := height * strToFloat( ValueList[j] ) / FMax;

      PgEnt := TEzPlace.CreateEntity( pos );
      pgent.Symboltool.Index := symbolindex;
      pgent.Symboltool.height := height;
      Group.Add( PgEnt );
    End;
  End;

Begin
  If FGis = Nil Then
    exit;
  vl := TStringlist.create;

  layer := GIS.Layers.LayerByName( LayerName );
  If ( Layer = Nil ) Or ( Layer.DBTable = Nil ) Then
    exit;

  //initialize
  CosmethicLayer := FGIS.FoundFirstCosmethicLayer;
  If CosmethicLayer = Nil Then
  Begin
    // create a cosmethc layer
    FileName := GetTemporaryLayerName( AddSlash( ExtractFilePath( GIS.FileName ) ), 'CSM' );
    CosmethicLayer := GIS.Layers[GIS.Layers.Add( FileName, ltMemory )];
    CosmethicLayer.Open;
  End
  Else
  Begin
    // clear the cosmethic layer
    CosmethicLayer.Open;
    CosmethicLayer.Zap;
  End;

  fl := SplitbySemiColon( FieldName );
  If fl.Count = 0 Then Exit;

  //Calc Min,Max for Symbol's sizeing.
  FMax := -1E20;
  Layer.First;
  While Not Layer.Eof Do
  Begin
    If Layer.RecIsDeleted Then
    Begin
      Layer.Next;
      Continue;
    End;
    value := 0;
    Layer.DBTable.RecNo := Layer.Recno;
    For cnt := 0 To fl.count - 1 Do
      Value := Value + layer.DBTable.FloatGet( fl[cnt] );
    FMax := dMax( Value, FMax );

    Layer.Next;
  End;

  If FMax = 0 Then
    exit;

  //calc symbol size
  symsize := Grapher.DistToRealX( Symbolsize );

  Layer.First;
  If Not Layer.Eof Then
    Repeat
      If layer.RecIsDeleted = false Then
      Begin
        Layer.DBTable.Recno := Layer.Recno;
        VL.Clear;
        For i := 0 To fl.count - 1 Do
          vl.add( layer.DBTable.StringGet( fl[i] ) );
        TmpEnt := layer.RecLoadEntity;
        Tmpent.Centroid( pos.x, pos.y );
        Tmpent.free;
        Group := TEzGroupEntity.CreateEntity;
        Makesymbol( Pos, symsize, VL );
        CosmethicLayer.AddEntity( Group );
        Group.Free;
      End;

      Layer.Next;
    Until layer.Eof;

  vL.free;
  fl.free;
  Repaint;
End;

Function TEzBaseDrawBox.CoordsToDisplayText( Const AX, AY: Double ): String;
Var
  //temps: String;
  eorw, nors: Char;
  //LonDegMinSec, LatDegMinSec: TDegMinSec;
Begin
  If (FGis = Nil) Or Not FGIS.FMapInfo.IsValid Then Exit;
  With FGIS.FMapInfo Do
    If CoordSystem = csLatLon Then
    Begin
      If AX < 0 Then
        eorw := 'W'
      Else
        eorw := 'E';
      If AY < 0 Then
        nors := 'S'
      Else
        nors := 'N';
      With Ez_Preferences Do
        Result := Format( '%.*n° %s; %.*n° %s', [NumDecimals, Abs(AX), nors, NumDecimals, Abs(AY), eorw] );

      {LonDegMinSec := Extended2DegMinSec( Abs( AX ) );
      LatDegMinSec := Extended2DegMinSec( Abs( AY ) );
      temps := '%d°%.2d''%2.2f"';
      Result := Format( temps + nors + ' ' + temps + eorw,
        [LatDegMinSec.Degrees, LatDegMinSec.Minutes, LatDegMinSec.Seconds,
        LonDegMinSec.Degrees, LonDegMinSec.Minutes, LonDegMinSec.Seconds] ); }
    End
    Else
      With Ez_Preferences Do
        Result := Format( '%.*n; %.*n', [NumDecimals, AX, NumDecimals, AY] );
End;

Function TEzBaseDrawBox.CoordsToDisplaySuffix( Const AX, AY: Double ): String;
//Var
  //en: String;
Begin
  If FGis = Nil Then
    exit;
  With FGIS Do
  Begin
    //en := GetEnumName( System.TypeInfo( TEzCoordsUnits ), Ord( MapInfo.CoordsUnits ) );
    Result := CoordsToDisplayText( AX, AY ) + #32 + pj_units[MapInfo.CoordsUnits].id;{copy( en, 3, length( en ) );}
  End;
End;

Procedure TEzBaseDrawBox.FitSelectionToPath( AdjustTextWidth: Boolean );
Var
  i, J, n: Integer;
  Layer: TEzBaseLayer;
  Index: Integer;
  SelLayer: TEzSelectionLayer;
  Ents: Array[1..2] Of TEzEntity;
  Group: TEzEntity;
  TmpR: TEzRect;
Begin
  If ( FGis = Nil ) Or ( Selection.NumSelected <> 2 ) Then
    Exit;
  TmpR := FSelection.GetExtension;
  n := 0;
  Layer := Nil;
  For i := 0 To FGIS.Layers.Count - 1 Do
  Begin
    Layer := FGIS.Layers[i];
    Index := FSelection.IndexOf( Layer );
    If Index >= 0 Then
    Begin
      SelLayer := FSelection[Index];
      For J := 0 To SelLayer.SelList.Count - 1 Do
      Begin
        inc( n );
        Ents[n] := Layer.LoadEntityWithRecno( SelLayer.SelList[J] );
      End;
    End;
  End;
  If ( Ents[1].EntityID = idFittedVectText ) Or ( Ents[2].EntityID = idFittedVectText ) Then
  Begin
    Group := TEzGroupEntity.CreateEntity;
    DeleteSelection;
    With TEzGroupEntity( Group ) Do
    Begin
      If Ents[1].EntityID = idFittedVectText Then
      Begin
        Ents[1].Points[0] := Ents[2].FBox.Emin;
        If AdjustTextWidth Then
          TEzFittedVectorText( Ents[1] ).Width := EzSystem.Perimeter( Ents[2].DrawPoints, Ents[2].IsClosed );
        Add( Ents[2] );
        Add( Ents[1] );
      End
      Else
      Begin
        Ents[2].Points[0] := Ents[1].FBox.Emin;
        If AdjustTextWidth Then
          TEzFittedVectorText( Ents[2] ).Width := EzSystem.Perimeter( Ents[1].DrawPoints, Ents[1].IsClosed );
        Add( Ents[1] );
        Add( Ents[2] );
      End;
      GroupType := gtFitToPath;
    End;
    If Layer <> Nil Then
      Layer.AddEntity( Group );
    Group.Free;
    RepaintRect( TmpR );
  End;
End;

{ returns a code that describes the relation of a given point with an entity
  parameters:
  Layername -> name of layer
  Recno -> record number for entity to calculate
  Aperture -> a distance in pixels that is an allowed range to consider the point
              related to an entity. Example, if this value is 4, then when the given
              point is 2 pixels apart from any side of a given line segment, then
              it is considered that is touching that line segment. Use 0 if
              want exact position.
  returns:
  PICKED_NONE = don't touch
  PICKED_INTERIOR = point inside entity
  PICKED_POINT = point on a segment
  >= 0 the point is over that index point }

Function TEzBaseDrawBox.PointRelate( Entity: TEzEntity;
  Aperture: Integer; Const X, Y: Double ): Integer;
Var
  MinDist, Distance: Double;
  RealAperture: TEzPoint;
Begin
  Aperture := Aperture Div 2;
  RealAperture := Point2D( Grapher.DistToRealX( Aperture ), Grapher.DistToRealY( Aperture ) );
  {if RealAperture.X > RealAperture.Y then
    MinDist:= RealAperture.X
  else
    MinDist:= RealAperture.Y;
  MinDist:= Sqrt(2) * MinDist; }
  MinDist := 0;
  Result := Entity.PointCode( Point2D( X, Y ), MinDist, Distance, Ez_Preferences.SelectPickingInside );
End;

{ Defines if a point is inside a polygon
  Layername -> the layer of the entity
  Recno -> the recno for the entity
  X,Y -> point coords to evaluate }

Function TEzBaseDrawBox.PointInPolygon( Entity: TEzEntity; Const X, Y: Double ): Boolean;
Var
  Code: Integer;
  MinDist, Distance: Double;
Begin
  If ( Entity = Nil ) Or Not Entity.IsClosed Then
  Begin
    EzGISError( SEntityNotClosed );
  End;
  MinDist := 0;
  Code := Entity.PointCode( Point2D( X, Y ), MinDist, Distance,
    Ez_Preferences.SelectPickingInside );
  Result := ( Code = PICKED_INTERIOR ) And ( Distance <= 0 );
End;

Function TEzBaseDrawBox.AddEntity( Const Layername: String; Entity: TEzEntity ): Integer;
Var
  Layer: TEzBaseLayer;
Begin
  Assert( FGIS <> Nil );
  If Length( LayerName ) = 0 Then
    Layer := FGIS.CurrentLayer
  Else
    Layer := GetLayerByName( LayerName );
  Entity.UpdateExtension;
  result := Layer.AddEntity( Entity );
End;

Function TEzBaseDrawBox.GetLayerByName( Const LayerName: String ): TEzBaseLayer;
Begin
  If FGIS = Nil Then
    EZGISError( SLayerNotFound );
  Result := FGIS.Layers.LayerByName( LayerName );
  If Result = Nil Then
    Result := FGIS.CurrentLayer;
  If Result = Nil Then
    EZGISError( SLayerNotFound );
End;

Procedure TEzBaseDrawBox.SetScreenGrid( value: TEzScreenGrid );
Begin
  FScreenGrid.Assign( value );
End;

Procedure TEzBaseDrawBox.SetShowLayerExtents( value: boolean );
Begin
  FShowLayerExtents := value;
End;

Procedure TEzBaseDrawBox.SetShowMapExtents( value: boolean );
Begin
  FShowMapExtents := value;
End;

Procedure TEzBaseDrawBox.CreateThumbNail(Bitmap: TBitmap);
var
  TmpGrapher: TEzGrapher;
  OldDrawLimit: Integer;
begin
  if Gis=nil then Exit;
  TmpGrapher:= TEzGrapher.Create(10,adScreen);
  OldDrawLimit:= Ez_Preferences.MinDrawLimit;
  Ez_Preferences.MinDrawLimit:= 0;
  try
    TmpGrapher.SetViewport( 0, 0, Bitmap.Width-1, Bitmap.Height-1 );
    with Gis.MapInfo.Extension do
      TmpGrapher.SetWindow( X1, X2, Y1, Y2 );
    With TEzPainterObject.Create(Nil) Do
    Try
      DrawEntities( Gis.MapInfo.Extension,
                    Self.Gis,
                    Bitmap.Canvas,
                    TmpGrapher,
                    Self.Selection,
                    FALSE,
                    FALSE,
                    pmAll,
                    Nil );
    Finally
      free;
    End;
  finally
    TmpGrapher.Free;
    Ez_Preferences.MinDrawLimit:= OldDrawLimit;
  end;
end;

Procedure TEzBaseDrawBox.SaveClippedAreaTo( NewGis: TEzBaseGIS );
Begin
  ezgraphics.SaveClippedAreaTo( Self, NewGis );
End;

Procedure TEzBaseDrawBox.SetClipBoundaryFromSelection;
Begin
  Assert( FGIS <> Nil );
  GIS.ClippedEntities.Assign( Selection );
  Selection.Clear;
  GIS.RepaintViewports;
End;

Function TEzBaseDrawBox.AddEntityFromText( Const LayerName, EntityText: String ): Integer;
Var
  Lexer: TEzScrLexer;
  Parser: TEzScrParser;
  outputStream: TMemoryStream;
  errorStream: TMemoryStream;
  Stream: TStream;
  ErrLine, ErrCol: Integer;
  ErrMsg, Errtxt: String;
Begin
  Result := 0;
  If Length( EntityText ) = 0 Then Exit;
  outputStream := TMemoryStream.create;
  errorStream := TMemoryStream.create;
  Stream := TMemoryStream.Create;
  Stream.Write( EntityText[1], Length( EntityText ) );
  Stream.Seek( 0, 0 );

  lexer := TEzScrLexer.Create;
  lexer.yyinput := Stream;
  lexer.yyoutput := outputStream;
  lexer.yyerrorfile := errorStream;

  parser := TEzScrParser.Create;
  { mark as single script and used for obtaining a single entity }
  TEzScrParser( parser ).JustCreateEntity := True;
  parser.DrawBox := Self;
  parser.checksyntax := False;
  parser.yyLexer := lexer; // lexer and parser linked
  Try
    If parser.yyparse = 1 Then
    Begin
      ErrLine := lexer.yylineno;
      ErrCol := lexer.yycolno - lexer.yytextLen - 1;
      ErrMsg := parser.yyerrormsg;
      lexer.GetyyText( ErrTxt );
      Raise EExpression.CreateFmt( SExprParserError, [ErrMsg, ErrLine, ErrCol, ErrTxt] );
    End;
    Self.AddEntity( LayerName, TEzScrParser( parser ).EntityCreated );
  Finally
    parser.free;
    lexer.free;
    outputStream.free;
    errorStream.free;
    Stream.Free;
  End;
End;

Function TEzBaseDrawBox.CreateEntityFromText( Const EntityText: String ): TEzEntity;
Var
  lexer: TEzScrLexer;
  parser: TEzScrParser;
  outputStream: TMemoryStream;
  errorStream: TMemoryStream;
  Stream: TStream;
  ErrLine, ErrCol: Integer;
  ErrMsg, Errtxt: String;
Begin
  Result := Nil;
  If Length( EntityText ) = 0 Then Exit;
  outputStream := TMemoryStream.create;
  errorStream := TMemoryStream.create;
  Stream := TMemoryStream.Create;
  Stream.Write( EntityText[1], Length( EntityText ) );
  Stream.Seek( 0, 0 );

  lexer := TEzScrLexer.Create;
  lexer.yyinput := Stream;
  lexer.yyoutput := outputStream;
  lexer.yyerrorfile := errorStream;

  parser := TEzScrParser.Create;
  { mark as single script and used for obtaining a single entity }
  TEzScrParser( parser ).JustCreateEntity := True;
  parser.DrawBox := Self;
  parser.checksyntax := False;
  parser.yyLexer := lexer; // lexer and parser linked
  Try
    If parser.yyparse = 1 Then
    Begin
      ErrLine := lexer.yylineno;
      ErrCol := lexer.yycolno - lexer.yytextLen - 1;
      ErrMsg := parser.yyerrormsg;
      lexer.GetyyText( ErrTxt );
      Raise EExpression.CreateFmt( SExprParserError, [ErrMsg, ErrLine, ErrCol, ErrTxt] );
    End;
    Result := TEzScrParser( parser ).EntityCreated;
    // to avoid the destructor of TEzScrParser to free this entity
    TEzScrParser( parser ).EntityCreated := Nil;
  Finally
    parser.free;
    lexer.free;
    outputStream.free;
    errorStream.free;
    Stream.Free;
  End;
End;

Procedure TEzBaseDrawBox.CreateBlockFromSelection(const BlockName: string);
var
  Block: TEzSymbol;
  I, J: Integer;
  Stream: TStream;
  Ent: TEzEntity;
begin
  if Length(Blockname) = 0 then Exit;
  Block:= TEzSymbol.Create(Nil);
  For I := 0 To FSelection.Count - 1 Do
    With FSelection[I] Do
    Begin
      For J := 0 To FSelList.Count - 1 Do
      begin
        Ent:= Layer.LoadEntityWithRecno( FSelList[J] );
        Block.Add(Ent);
      end;
    End;
  Stream:= TFileStream.Create(ChangeFileExt( AddSlash(Ez_Preferences.CommonSubDir) + BlockName, '.edb' ), fmCreate );
  try
    Block.SaveToStream(Stream);
  finally
    Stream.free;
  end;
end;

Procedure TEzBaseDrawBox.ARRAYFromSelection( Rows, Columns: Integer;
  const XOffset, YOffset: Double );
Var
  SelLayer: TEzSelectionLayer;
  I, J, R, C, N, NewRecno: Integer;
  Entity: TEzEntity;
  Tx, Ty: Double;
  M: TEzMatrix;
Begin
  if ( FSelection.Count = 0 ) or ( Rows < 1 ) or ( Columns < 1 ) then Exit;
  Ty:= 0;
  Tx:= XOffset;
  for R:= 1 to Rows do
  begin
    if R = 1 then N := Columns - 1 else N := Columns;
    for C:= 1 to N do
    begin
      M:= Translate2d( Tx, Ty );
      for I:= 0 to FSelection.Count-1 do
      begin
        SelLayer := FSelection[I];
        For J := 0 To SelLayer.SelList.Count - 1 Do
        begin
          Entity := SelLayer.Layer.LoadEntityWithRecno( SelLayer.SelList[J] );
          Try
            Entity.SetTransformMatrix( M );
            Entity.ApplyTransform;
            NewRecno:= SelLayer.Layer.AddEntity( Entity );
            SelLayer.Layer.CopyRecord( SelLayer.SelList[J], NewRecno );
          Finally
            Entity.Free;
          End;
        end;
      end;
      Tx:= Tx + XOffset;
    end;
    Ty:= Ty + YOffset;
    Tx := 0;
  end;
End;

Procedure TEzBaseDrawBox.DropSelectionAt( const Wx, Wy: Double );
Var
  I, J, C, N, NewRecno: Integer;
  Entity: TEzEntity;
  Tx, Ty: Double;
  M: TEzMatrix;
  Sumx, Sumy, Cx, Cy: Double;
  SelLayer: TEzSelectionLayer;
Begin
  if ( FSelection.Count = 0 ) or ( FDropRepeat < 1 ) then Exit;
  Sumx:= 0;
  Sumy:= 0;
  N:= 0;
  for I:= 0 to FSelection.Count-1 do
  begin
    SelLayer:= FSelection[I];
    if SelLayer.Layer.LayerInfo.Locked then Continue;
    for J:= 0 to SelLayer.SelList.Count-1 do
    begin
      Entity:= SelLayer.Layer.LoadEntityWithRecno( SelLayer.SelList[J] );
      Try
        Entity.Centroid( Cx, Cy );
        Sumx := Sumx + Cx;
        Sumy := Sumy + Cy;
        Inc( N );
      Finally
        Entity.Free;
      end;
    end;
  end;
  Tx:= Wx - (Sumx/N);
  Ty:= Wy - (Sumy/N);
  for C:= 1 to FDropRepeat do
  begin
    M:= Translate2d( Tx, Ty );
    for I:= 0 to FSelection.Count-1 do
    begin
      SelLayer := FSelection[I];
      if SelLayer.Layer.LayerInfo.Locked then Continue;
      For J := 0 To SelLayer.SelList.Count - 1 Do
      begin
        Entity := SelLayer.Layer.LoadEntityWithRecno( SelLayer.SelList[J] );
        Try
          Entity.SetTransformMatrix( M );
          Entity.ApplyTransform;
          NewRecno:= SelLayer.Layer.AddEntity( Entity );
          SelLayer.Layer.CopyRecord( SelLayer.SelList[J], NewRecno );
        Finally
          Entity.Free;
        End;
      end;
    end;
  end;
End;

Procedure TEzBaseDrawBox.ClipPolylineAgainstPolygon;
var
  Polygon, Polyline, Entity: TEzEntity;
  SelLayer: TEzSelectionLayer;
  Result: TEzVector;
  I, J, PolylineRecno: Integer;
  PolylineLayer: TEzBaseLayer;
Begin
  if FSelection.NumSelected <> 2 then Exit;
  Polygon:= nil;
  Polyline:= nil;
  Result:= TEzVector.Create(4);
  try
    PolylineRecno:= 0;
    PolylineLayer:= Nil;
    for I:= 0 to FSelection.Count-1 do
    begin
      SelLayer := FSelection[I];
      For J := 0 To SelLayer.SelList.Count - 1 Do
      begin
        Entity := SelLayer.Layer.LoadEntityWithRecno( SelLayer.SelList[J] );
        if Entity.EntityID in [idPolygon, idRectangle, idEllipse] then
        begin
          Polygon:= Entity;
          Entity:= nil;
        end else if Entity.EntityID in [idPolyline, idArc, idSpline] then
        begin
          Polyline:= Entity;
          Entity:= nil;
          PolylineLayer:= SelLayer.Layer;
          PolylineRecno:= SelLayer.SelList[J];
        end;
        if Entity <> nil then
          Entity.Free;
      end;
    end;
    if (Polygon = nil) or (Polyline = nil) then Exit;
    ezgraphics.CyrusBeckLineClip(Polyline.DrawPoints, Polygon.DrawPoints, Result);
    if Result.Count > 0 then
    begin
      Polyline.Points.Assign(Result);
      PolylineLayer.UpdateEntity(PolylineRecno, Polyline);
    end;
  finally
    if Polygon <> nil then Polygon.Free;
    if Polyline<> nil then Polyline.Free;
    Result.free;
  end;
End;

Procedure TEzBaseDrawBox.DeleteRepetitions( const LayerName: string;
  EntityID: TEzEntityID; IncludeAttribs: Boolean; SearchAllLayers: Boolean );
Var
  I, L, FromIndex, ToIndex, TmpRecno: Integer;
  Layer, TestLayer: TEzBaseLayer;
  Bookmark: Pointer;
  Entity, TestEntity: TEzEntity;
  DelList: TIntegerList;
  RecCount, n: Integer;
Begin
  if (FGis = Nil) Or (FGis.Layers.Count = 0) Or (Length(LayerName) = 0) then Exit;
  Layer:= FGis.Layers.LayerByName(LayerName);
  if Layer = Nil then Exit;
  if SearchAllLayers then
  begin
    FromIndex := 0;
    ToIndex:= FGis.Layers.Count-1;
  end else
  begin
    FromIndex:= Layer.Index;
    ToIndex:= FromIndex;
  end;
  RecCount:= Layer.RecordCount;
  DelList:= TIntegerList.Create;
  If RecCount > 0 Then
    FGIS.StartProgress( SSelectinLayer + Name, 1, RecCount );
  Try
    n:= 0;
    Layer.First;
    While Not Layer.Eof Do
    Begin
      Inc(n);
      FGIS.UpdateProgress( n );
      if Layer.RecIsDeleted then
      begin
        Layer.Next;
        Continue;
      end;
      { Search if this has repeated entities }
      Entity:= Layer.RecLoadEntity;
      Try
        TmpRecno:= Layer.Recno;
        For L:= FromIndex to ToIndex do
        begin
          DelList.Clear;
          TestLayer := FGis.Layers[L];
          Bookmark:= Nil;
          if Layer = TestLayer then
          begin
            Bookmark:= Layer.GetBookmark;
          end;
          TestLayer.SetGraphicFilter( stOverlap, Entity.FBox );
          try
            TestLayer.First;
            While not TestLayer.Eof do
            begin
              if TestLayer.RecIsDeleted then
              begin
                TestLayer.Next;
                Continue;
              end;
              if TestLayer.Recno = TmpRecno then
              begin
                TestLayer.Next;
                Continue;
              end;
              TestEntity:= TestLayer.RecLoadEntity;
              Try
                if ( (EntityID = idNone) or (Entity.EntityID = EntityID) ) And
                   Entity.IsEqualTo( TestEntity, IncludeAttribs ) then
                  DelList.Add( TestLayer.Recno );
              Finally
                TestEntity.Free;
              End;
              TestLayer.Next;
            end;
          finally
            TestLayer.CancelFilter;
            if Layer = TestLayer then
            begin
              Layer.GotoBookmark( Bookmark );
              Layer.FreeBookmark( Bookmark );
            end;
          end;
          For I:= 0 to DelList.Count - 1 do
            TestLayer.DeleteEntity( DelList[I] );
        end;
      Finally
        Entity.Free;
      End;
      Layer.Next;
    End;
  Finally
    DelList.Free;
    If RecCount > 0 Then
      FGIS.EndProgress;
  End;
End;

procedure TEzBaseDrawBox.CMMouseEnter (var Msg: TMessage);
Begin
  inherited;
  if Assigned(FOnMouseEnter) then
    FOnMouseEnter(Self);
End;

procedure TEzBaseDrawBox.CMMouseLeave (var Msg: TMessage);
Begin
  inherited;
  if Assigned(FOnMouseLeave) then
    FOnMouseLeave(Self);
End;

Function TEzBaseDrawBox.FindClosestEntity(const WX, WY: Double;
  const Scope: string; const ShapeType: TEzEntityIDs; var LayerName: string;
  var Recno: Integer): Boolean;
const
  FIND_MAX_ITER = 50;
var
  Radius, TestDist: Double;
  List: TIntegerList;
  Circle: TEzEllipse;
  I, NumIter: Integer;
  temp: string;
  Pivot: TEzVector;
  Layer: TEzBaseLayer;

  Function DoFind( const ALayerName: string ): Boolean;
  var
    I: Integer;
    TmpEnt: TEzEntity;
    MinDist: Double;
    MinP1, Minp2: TEzPoint;
  begin
    Result:= False;
    repeat
      FGis.QueryPolygon( Circle, ALayerName, Scope, goWithin, 0, List, True );
      if List.Count = 0 then
      begin
        Inc(NumIter);
        if NumIter > FIND_MAX_ITER then Break;
        Radius := Radius * 2;
        Circle.BeginUpdate;
        Circle.Points[0] := Point2D(WX - Radius, WY - Radius);
        Circle.Points[1] := Point2D(WX + Radius, WY + Radius);
        Circle.EndUpdate;
      end else
      begin
        { now find the closest entity }
        Layer := FGis.Layers.LayerByName( ALayerName );
        for I:= 0 to List.Count-1 do
        begin
          TmpEnt:= Layer.LoadEntityWithRecno( List[ I ] );
          try
            if ( ShapeType = [] ) Or ( TmpEnt.EntityID in ShapeType ) then
            begin
              if TmpEnt.Points.Count > 1 then
                EzLib.GetMinimumDistance2D( TmpEnt.Points, Pivot, MinDist, MinP1, MinP2 )
              else if TmpEnt.Points.Count = 1 then
                MinDist:= Dist2d( TmpEnt.Points[0], Pivot[0] )
              else
                MinDist := MAXCOORD;
              if MinDist < TestDist then
              begin
                TestDist:= MinDist;
                LayerName:= ALayerName;
                Recno := List[I];
                Result:= True;
              end;
            end;
          finally
            TmpEnt.Free;
          end;
        end;

        If Result Then Break;

        Radius := Radius * 2;
        Circle.BeginUpdate;
        Circle.Points[0] := Point2D(WX - Radius, WY - Radius);
        Circle.Points[1] := Point2D(WX + Radius, WY + Radius);
        Circle.EndUpdate;

      end;
    until False;

  end;

begin
  Assert( FGis <> Nil );

  Result:= False;

  { delta is half point }
  Radius:= FGrapher.PointsToDistY(1);

  temp:= LayerName;
  LayerName:= '';
  TestDist := MAXCOORD;
  Recno := 0;
  NumIter := 0;
  Circle:= TEzEllipse.CreateEntity( Point2D(WX - Radius, WY - Radius),
    Point2d(WX + Radius, WY + Radius) );
  with TEzEllipse(Circle) do
  begin
    Pentool.Style := 1;
    Pentool.Color := clBlack;
    Pentool.Width:= 0;
    Brushtool.Pattern:= 0;
  end;
  List:= TIntegerList.create;
  Pivot:= TEzVector.Create(1);
  try
    Pivot.AddPoint( WX, WY );
    if Length( temp ) > 0 then
    begin
      Layer:= FGis.Layers.LayerByName(temp);
      if (Layer=nil) or Not(Layer.LayerInfo.Visible) then Exit;
      Result:= DoFind( temp );
    end else
      For i := FGis.Layers.Count - 1 downto 0 Do
      begin
        If not FGis.Layers[I].LayerInfo.Visible then Continue;
        NumIter:= 0;
        Radius:= FGrapher.PointsToDistY( 1 );
        Circle.BeginUpdate;
        Circle.Points[0] := Point2D(WX - Radius, WY - Radius);
        Circle.Points[1] := Point2D(WX + Radius, WY + Radius);
        Circle.EndUpdate;
        Result:= DoFind( FGis.Layers[I].Name ) ;
        If Result then Break;
      end;
  finally
    List.free;
    Circle.free;
    Pivot.Free;
  end;
end;

{$IFDEF TRIAL_VERSION}
Procedure TEzBaseDrawBox.DrawTrialBanner;
Begin
  If Not IsDesigning Then
    With Canvas Do
    Begin
      SetBkMode(Handle, Windows.TRANSPARENT);
      SetBkMode( Handle, Transparent );
      Font.Name := 'Verdana';
      Font.Size := 9;
      Font.Color := clNavy;
      Font.Style := [];
      TextOut( 0, 0, SUnRegisteredCopy );
    End;
End;
{$ENDIF}

Procedure TEzBaseDrawBox.DoCopyCanvas;
Var
  R: TRect;
Begin
  Canvas.Lock;
  try
    R:= Rect(0,0,ScreenBitmap.Width,ScreenBitmap.Height);
    Canvas.CopyRect( R, ScreenBitmap.Canvas, R );
  finally
    Canvas.UnLock;
  end;
End;

{ threads section }
Procedure TEzBaseDrawBox.DoFullPainting(const WCRect: TEzRect;
  Canvas: TCanvas; Grapher: TEzGrapher );
begin
  If FUseThread Then
  begin

  end else
  begin
    With TEzPainterObject.Create(Nil) Do
    Try
      DrawEntities( WCRect,
                    Self.GIS,
                    Canvas,
                    Grapher,
                    Self.Selection,
                    False,
                    False,
                    pmAll,
                    Self.ScreenBitmap );
    Finally
      Free;
    End;
  End;
end;

Procedure TEzBaseDrawBox.StopPaintingThread;
begin
end;

Procedure TEzBaseDrawBox.WaitForPaintingThread;
begin
end;

Procedure TEzBaseDrawBox.ThreadDone;
begin
end;

function TEzBaseDrawBox.IsAutoScrollEnabled: boolean;
begin
  Result := FAutoScroll;
end;

procedure TEzBaseDrawBox.SetViewTo(const aRect: TEzRect);
begin
  Grapher.SetViewTo(aRect);
  Repaint;
end;

procedure TEzBaseDrawBox.Click;
var
  Pt: TPoint;
  wPt: TEzPoint;
begin
  inherited;
  if Assigned(FOnCustomClick) then
  begin
    Pt := Self.ScreenToClient(Mouse.CursorPos);
    wPt := Self.Grapher.PointToReal(Pt);
    FOnCustomClick(Self, Pt.X, Pt.Y, wPt.X, wPt.Y);
  end;
end;

{ TEzPainterThread }

constructor TEzPainterThread.Create(WhenDone: TNotifyEvent;
  aWCRect: TEzRect; aDrawBox: TEzBaseDrawBox;
  aShowAnimationLayers: Boolean; aPrintMode: TEzPrintMode );
begin
  Inherited Create(True);

  OnTerminate:= WhenDone;
  FreeOnTerminate := False;

  WCRect:= aWCRect;
  DrawBox:= aDrawBox;
  ShowAnimationLayers:= aShowAnimationLayers;
  PrintMode:= aPrintMode;

  FPainterObject:= TEzPainterObject.Create(Self);

end;

destructor TEzPainterThread.Destroy;
begin
  DoTerminate;
  FPainterObject.Free;
  FPainterObject:= Nil;
  inherited;
end;

procedure TEzPainterThread.DoUpdate;
begin
  DrawBox.DoCopyCanvas;
end;

procedure TEzPainterThread.Execute;
begin
  with DrawBox do
    FPainterObject.DrawEntities( WCRect, GIS, ScreenBitmap.Canvas, Grapher,
      Selection, DrawBox is TEzAerialView, ShowAnimationLayers, PrintMode, ScreenBitmap );
end;

Initialization
  RegisterEntitiesClasses;

  CF_EZGISDATA := RegisterClipboardFormat( EZGISDATA );

End.


