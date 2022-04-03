Unit EzIBGIS;

{$I EZ_FLAG.PAS}
//{$DEFINE IBTRIAL_VERSION}
//{$DEFINE COMPRESSED_ENTITY} //uncomment if you want to compress entity when saving
Interface

Uses
  SysUtils, Windows, Classes, Graphics, Controls, forms, db,
  IBSQL, IBDatabase, ezbasegis, ezbase, ezlib, ezprojections,
  ezrtree, ezbaseexpr;

// this constant delimits how many records to pass right in the sql by converting
// integer values to string format, instead of using a temporary table
// increase if Interbase can support more records in a IN() clause
const
  MAX_RECORDS_SQL_IN_CLAUSE = 1500;

Type

  TEzIBField = Class;

  { we have here the information needed by the client local configuration
    in order to avoid having the server updated with configuration needed at that
    moment by the client }

  TEzIBLayerClientData = Class
  Private
    CoordsUnits: TEzCoordsUnits;
    CoordsUnits_init: Boolean;
    CoordSystem: TEzCoordSystem;
    CoordSystem_init: Boolean;
    Visible: Boolean;
    Visible_init: Boolean;
    Selectable: Boolean;
    Selectable_init: Boolean;
    TextHasShadow: Boolean;
    TextHasShadow_init: Boolean;
    TextFixedSize: Byte;
    TextFixedSize_init: Boolean;
    OverlappedTextAction: TEzOverlappedTextAction;
    OverlappedTextAction_init: Boolean;
    OverlappedTextColor: TColor;
    OverlappedTextColor_init: Boolean;
    RecCount: Integer;
    RecCount_init: Boolean;
  Public
    Procedure Invalidate;
  End;

  TEzIBLayerInfo = Class( TEzBaseLayerInfo )
  Private
    FClientData: TEzIBLayerClientData;
  {$IFDEF BCB} (*_*)
    function GetClientData: TEzIBLayerClientData;
  {$ENDIF}
  Protected
    Function GetOverlappedTextAction: TEzOverlappedTextAction; Override;
    Procedure SetOverlappedTextAction( Value: TEzOverlappedTextAction ); Override;
    Function GetOverlappedTextColor: TColor; Override;
    Procedure SetOverlappedTextColor( Value: TColor ); Override;
    Function GetTextHasShadow: Boolean; Override;
    Procedure SetTextHasShadow( Value: Boolean ); Override;
    Function GetTextFixedSize: Byte; Override;
    Procedure SetTextFixedSize( Value: Byte ); Override;
    Function GetVisible: Boolean; Override;
    Procedure SetVisible( Value: Boolean ); Override;
    Function GetSelectable: Boolean; Override;
    Procedure SetSelectable( Value: Boolean ); Override;
    Function GetIsCosmethic: Boolean; Override;
    Procedure SetIsCosmethic( value: Boolean ); Override;
    Function GetExtension: TEzRect; Override;
    Procedure SetExtension( Const Value: TEzRect ); Override;
    Function GetIDCounter: integer; Override;
    Procedure SetIDCounter( Value: integer ); Override;
    Function GetIsAnimationLayer: Boolean; Override;
    Procedure SetIsAnimationLayer( Value: Boolean ); Override;
    Function GetIsIndexed: Boolean; Override;
    Procedure SetIsIndexed( Value: Boolean ); Override;
    Function GetCoordsUnits: TEzCoordsUnits; Override;
    Procedure SetCoordsUnits( Value: TEzCoordsUnits ); Override;
    Function GetCoordSystem: TEzCoordSystem; Override;
    Procedure SetCoordSystem( Value: TEzCoordSystem ); Override;
    Function GetUseAttachedDB: Boolean; Override;
    Procedure SetUseAttachedDB( Value: Boolean ); Override;
  Public
    Constructor Create( Layer: TEzBaseLayer ); Override;
    Destructor Destroy; Override;

    Property ClientData: TEzIBLayerClientData
      read {$IFDEF BCB} GetClientData {$ELSE} FClientData {$ENDIF}; (*_*)
  End;


  { TEzIBLayer - class definition }

  TEzIBLayer = Class( TEzBaseLayer )
  Private
    FDBTable: TEzBaseTable;
    { for the layer Header }
    FIBHeader: TIBSQL;
    FIBField: TEzIBField;           // read/write fields from the header of the layer
    { for the entities  }
    FIBEntities: TIBSQL;
    FFiltered: Boolean;
    FIsOpen: Boolean;
    FUpdateRtree: Boolean;
    FBatchUpdate: Boolean;
    Procedure BuildRTreeInMemory(var rt: TRTree);
    Procedure UpdateMapExtension( Const R: TEzRect );
    Function InternalLoadEntity( IBSQL: TIBSQL ): TEzEntity;
    Function DataSet: TIBSQL;
  {$IFDEF BCB} (*_*)
    function GetIBEntities: TIBSQL;
  {$ENDIF}
  Protected
    Function GetRecno: Integer; Override;
    Procedure SetRecno( Value: Integer ); Override;
    Function GetRecordCount: Integer; Override;
    Function GetDBTable: TEzBaseTable; Override;
    Function GetActive: Boolean; Override;
    Procedure SetActive( Value: Boolean ); Override;
  Public
    Constructor Create( Layers: TEzBaseLayers; Const AFileName: String ); Override;
    Destructor Destroy; Override;
    Procedure InitializeOnCreate( Const FileName: String;
      AttachedDB, IsAnimation: Boolean; CoordSystem: TEzCoordSystem;
      CoordsUnits: TEzCoordsUnits; FieldList: TStrings ); Override;
    Procedure Assign( Source: TEzBaseLayer ); Override;
    Procedure Open; Override;
    Procedure Close; Override;
    Procedure ForceOpened; Override;
    Procedure WriteHeaders( FlushFiles: Boolean ); Override;
    Function AddEntity( Entity: TEzEntity ): Integer; Override;
    Procedure DeleteEntity( RecNo: Integer ); Override;
    Procedure UnDeleteEntity( RecNo: Integer ); Override;
    Function UpdateExtension: TEzRect; Override;
    Function QuickUpdateExtension: TEzRect; Override;
    Function LoadEntityWithRecNo( RecNo: Longint): TEzEntity; Override;
    Procedure UpdateEntity( RecNo: Integer; Entity2D: TEzEntity ); Override;
    Procedure Pack( ShowMessages: Boolean ); Override;
    Procedure Zap; Override;

    Procedure First; Override;
    Procedure Last; Override;
    Procedure Next; Override;
    Function Eof: Boolean; Override;
    Procedure Synchronize; Override;
    Procedure StartBuffering; Override;
    Procedure EndBuffering; Override;
    Procedure SetGraphicFilter( s: TSearchType; Const visualWindow: TEzRect ); Override;
    Procedure CancelFilter; Override;
    Function ContainsDeleted: Boolean; Override;
    Procedure Recall; Override;

    Function GetBookmark: Pointer; Override;
    Procedure GotoBookmark( Bookmark: Pointer ); Override;
    Procedure FreeBookmark( Bookmark: Pointer ); Override;

    Function SendEntityToBack( ARecno: Integer ): Integer; Override;
    Function BringEntityToFront( ARecno: Integer ): Integer; Override;
    Function RecIsDeleted: Boolean; Override;
    Procedure RecLoadEntity2( Entity: TEzEntity ); Override;
    Function RecLoadEntity: TEzEntity; Override;
    Function RecExtension: TEzRect; Override;
    Function RecEntityID: TEzEntityID; Override;
    Procedure StartBatchInsert; Override;
    Procedure CancelBatchInsert; Override;
    Procedure FinishBatchInsert; Override;
    Procedure GetFieldList( Strings: TStrings ); Override;

    Procedure RebuildTree; Override;

    Procedure CopyRecord( SourceRecno, DestRecno: Integer ); Override;
    Function DefineScope( Const Scope: String ): Boolean; Override;
    Function DefinePolygonScope( Polygon: TEzEntity; Const Scope: String;
      Operator: TEzGraphicOperator ): Boolean; Override;
    Function IsClientServer: Boolean; Override;
    Function DeleteLayerFiles: Boolean; Override;
    function GetExtensionForRecords( List: TIntegerList ): TEzRect; Override;

    { for the entities  }
    Property IBEntities: TIBSQL Read {$IFDEF BCB} GetIBEntities {$ELSE} FIBEntities {$ENDIF}; (*_*)
  End;


  { TEzIBLayers - class definition }

  TEzIBLayers = Class( TEzBaseLayers )
  Public
    Function Add( Const FileName: String; LayerType: TEzLayerType ): Integer; Override;
    Function CreateNew( Const FileName: String; FieldList: TStrings = Nil): TEzBaseLayer; Override;
    Function CreateNewEx( Const FileName: String;
                          CoordSystem: TEzCoordSystem;
                          CoordsUnits: TEzCoordsUnits;
                          FieldList: TStrings = Nil ): TEzBaseLayer; Override;
    Function CreateNewCosmethic( Const FileName: String ): TEzBaseLayer; Override;
    Function CreateNewAnimation( Const FileName: String ): TEzBaseLayer; Override;
    Function Delete( Const LayerName: String; DeleteFiles: Boolean ): Boolean; Override;
    Function IsClientServer: Boolean; Override;
  End;


  { TEzIBField - this class is used for reading info from tables that contains
    only one record, like the header on the layer or the map header }

  TEzIBField = Class
  Private
    FTableName: String;
    FIBSQL: TIBSQL;
    Procedure OpenIBSQL( Const ASQL: String );
    Procedure ExecuteIBSQL( Const Asql: String );
    Function GetAsBoolean( Const FieldName: String ): Boolean;
    Function GetAsDateTime( Const FieldName: String ): TDateTime;
    Function GetAsFloat( Const FieldName: String ): Double;
    Function GetAsInteger( Const FieldName: String ): Integer;
    Function GetAsString( Const FieldName: String ): String;
    Procedure SetAsBoolean( Const FieldName: String; Const Value: Boolean );
    Procedure SetAsDateTime( Const FieldName: String; Const Value: TDateTime );
    Procedure SetAsFloat( Const FieldName: String; Const Value: Double );
    Procedure SetAsInteger( Const FieldName: String; Const Value: Integer );
    Procedure SetAsString( Const FieldName, Value: String );
    Function GetIsNull( Const FieldName: String ): Boolean;
  Public
    Constructor Create( Const TableName: String; IBSQL: TIBSQL );
    Procedure ReadBlob( Const FieldName: String; stream: TStream );
    Procedure WriteBlob( Const FieldName: String; stream: TStream );
    Procedure SetAsNull( Const FieldName: String );

    Property AsString[Const FieldName: String]: String Read GetAsString Write SetAsString;
    Property AsInteger[Const FieldName: String]: Integer Read GetAsInteger Write SetAsInteger;
    Property AsBoolean[Const FieldName: String]: Boolean Read GetAsBoolean Write SetAsBoolean;
    Property AsFloat[Const FieldName: String]: Double Read GetAsFloat Write SetAsFloat;
    Property AsDateTime[Const FieldName: String]: TDateTime Read GetAsDateTime Write SetAsDateTime;
    Property IsNull[Const FieldName: String]: Boolean Read GetIsNull;
  End;

  { TEzIBMapClientData }
  TEzIBMapClientData = Class
  Private
    CurrentLayer: String;
    CurrentLayer_init: Boolean;
    AerialViewLayer: String;
    AerialViewLayer_init: Boolean;
    CoordsUnits: TEzCoordsUnits;
    CoordsUnits_init: Boolean;
    CoordSystem: TEzCoordSystem;
    coordsystem_init: Boolean;
    IsAreaClipped: Boolean;
    IsAreaClipped_init: Boolean;
    AreaClipped: TEzRect;
    AreaClipped_init: Boolean;
    ClipAreaKind: TEzClipAreaKind;
    ClipAreaKind_init: Boolean;
  Public
    Procedure Invalidate;
  End;

  { TEzIBMapInfo used in desktop }
  TEzIBMapInfo = Class( TEzBaseMapInfo )
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
    Function GetIsAreaClipped: Boolean; Override;
    Procedure SetIsAreaClipped( Value: Boolean ); Override;
    Function GetAreaClipped: TEzRect; Override;
    Procedure SetAreaClipped( Const Value: TEzRect ); Override;
    Function GetClipAreaKind: TEzClipAreaKind; Override;
    Procedure SetClipAreaKind( Value: TEzClipAreaKind ); Override;
  Public
    Procedure Initialize; Override;
    Function IsValid: Boolean; Override;
  End;

  TEzCreateIBSQLEvent = Procedure ( Sender: TObject; var IBSQL: TIBSQL ) Of Object;

  TEzIBGis = Class( TEzBaseGis )
  Private
    { the map header information }
    FIBHeader: TIBSQL;
    FIBField: TEzIBField;
    FIsOpen: Boolean;
    FClientData: TEzIBMapClientData;
    FQueryBasicFields: Boolean;
    TmpDecimalSeparator, TmpThousandSeparator: Char;

    FOnCreateIBSQL : TEzCreateIBSQLEvent;
    Procedure SetGISVersion( Const Value: TEzAbout );
    Function GetGISVersion: TEzAbout;
    Procedure SaveWindowsSeparators;
    Procedure RestoreWindowsSeparators;
  {$IFDEF BCB} (*_*)
    function GetIBHeader: TIBSQL;
    function GetOnCreateIBSQL: TEzCreateIBSQLEvent;
    function GetQueryBasicFields: Boolean;
    procedure SetOnCreateIBSQL(const Value: TEzCreateIBSQLEvent);
    procedure SetQueryBasicFields(const Value: Boolean);
  {$ENDIF}
  Protected
    Procedure WriteMapHeader( Const Filename: String ); Override;
  Public
    Constructor Create( AOwner: TComponent ); Override;
    Destructor Destroy; Override;
    Function CreateLayer( Const LayerName: String; LayerType: TEzLayerType ): TEzBaseLayer; Override;
    Procedure Open; Override;
    Procedure Close; Override;
    Procedure SaveAs( Const Filename: String ); Override;
    Procedure AddGeoref( Const LayerName, FileName: String ); Override;
    Procedure CreateNew( Const FileName: String ); Override;
    Function IsClientServer: Boolean; Override;
    Procedure InvalidateClientInfo;

    Procedure ClearLayerInformation;
    Property IBHeader: TIBSQL Read FIBHeader;
  Published
    Property About: TEzAbout read GetGisVersion write SetGisVersion;
    Property QueryBasicFields: Boolean
      read {$IFDEF BCB} GetQueryBasicFields {$ELSE} FQueryBasicFields {$ENDIF}
      write {$IFDEF BCB} SetQueryBasicFields {$ELSE} FQueryBasicFields {$ENDIF} default true; (*_*)
    { In this event all required TIBSQL datasets must be returned }
    Property OnCreateIBSQL : TEzCreateIBSQLEvent
      read {$IFDEF BCB} GetOnCreateIBSQL {$ELSE} FOnCreateIBSQL {$ENDIF}
      write {$IFDEF BCB} SetOnCreateIBSQL {$ELSE} FOnCreateIBSQL {$ENDIF} ; (*_*)
  End;

  { r-tree descendant classes }
  TIBRTNode = Class( TRTNode )
  Public
    Procedure Read( NId: Integer ); Override;
    Procedure Write; Override;
    Procedure AddNodeToFile; Override;
    Procedure DeleteNodeFromFile; Override;
  End;

  { TIBRTree used in desktop }
  TIBRTree = Class( TRTree )
  Private
    IdxOpened: Boolean;
  Public
    Function CreateNewNode: TRTNode; Override;
    Function Open( Const Name: String; Mode: Word ): integer; Override;
    Procedure Close; Override;
    Function CreateIndex( Const Name: String; Multiplier: Integer ): integer; Override;
    Procedure FlushFiles; Override;
    Procedure ReadCatalog( Var IdxInfo: TRTCatalog ); Override;
    Procedure WriteCatalog( Const IdxInfo: TRTCatalog ); Override;
    Procedure DropIndex; Override;
  End;

  { TEzIBTable - class used for accessing to the database }
  TEzIBTable = Class( TEzBaseTable )
  Private
    FLayer: TEzIBLayer;
    FCurrRecno: Integer;
    Function Dataset: TIBSQL;
    Procedure OpenIBSQL( Const ASQL: String );
    Procedure ExecuteIBSQL( Const Asql: String );
    Function TheTableName: string;
  {$IFDEF BCB} (*_*)
    function GetLayer: TEzIBLayer;
    procedure SetLayer(const Value: TEzIBLayer);
  {$ENDIF}
  Protected
    Function GetActive: Boolean; Override;
    Procedure SetActive( Value: Boolean ); Override;
    Function GetRecNo: Integer; Override;
    Procedure SetRecNo( Value: Integer ); Override;
  Public
    Procedure BeginTrans; Override;
    Procedure RollBackTrans; Override;
    Procedure EndTrans; Override;
    Procedure Append( NewRecno: Integer ); Override;
    Function Bof: Boolean; Override;
    Function Eof: Boolean; Override;
    Function DateGet( Const FieldName: String ): TDateTime; Override;
    Function DateGetN( FieldNo: integer ): TDateTime; Override;
    Function Deleted: Boolean; Override;
    Function Field( FieldNo: integer ): String; Override;
    Function FieldCount: integer; Override;
    Function FieldDec( FieldNo: integer ): integer; Override;
    Function FieldGet( Const FieldName: String ): String; Override;
    Function FieldGetN( FieldNo: integer ): String; Override;
    Function FieldLen( FieldNo: integer ): integer; Override;
    Function FieldNo( Const FieldName: String ): integer; Override;
    Function FieldType( FieldNo: integer ): char; Override;
    function FieldTypeEx(FieldNo: Integer): Char;
    Function Find( Const ss: String; IsExact, IsNear: Boolean ): Boolean; Override;
    Function FloatGet( Const FieldName: String ): Double; Override;
    Function FloatGetN( FieldNo: Integer ): Double; Override;
    Function IndexCount: integer; Override;
    Function IndexAscending( Value: integer ): Boolean; Override;
    Function Index( Const INames, Tag: String ): integer; Override;
    Function IndexCurrent: String; Override;
    Function IndexUnique( Value: integer ): Boolean; Override;
    Function IndexExpression( Value: integer ): String; Override;
    Function IndexTagName( Value: integer ): String; Override;
    Function IndexFilter( Value: integer ): String; Override;
    Function IntegerGet( Const FieldName: String ): Integer; Override;
    Function IntegerGetN( FieldNo: integer ): Integer; Override;
    Function LogicGet( Const FieldName: String ): Boolean; Override;
    Function LogicGetN( FieldNo: integer ): Boolean; Override;
    Procedure MemoSave( Const FieldName: String; Stream: TStream ); Override;
    Procedure MemoSaveN( FieldNo: integer; Stream: TStream ); Override;
    Function MemoSize( Const FieldName: String ): Integer; Override;
    Function MemoSizeN( FieldNo: integer ): Integer; Override;
    Function RecordCount: Integer; Override;
    Function StringGet( Const FieldName: String ): String; Override;
    Function StringGetN( FieldNo: integer ): String; Override;
    Procedure DatePut( Const FieldName: String; value: TDateTime ); Override;
    Procedure DatePutN( FieldNo: integer; value: TDateTime ); Override;
    Procedure Delete; Override;
    Procedure Edit; Override;
    Procedure FieldPut( Const FieldName, Value: String ); Override;
    procedure FieldPutEx(const FieldName, Value: String); override;
    Procedure FieldPutN( FieldNo: integer; Const Value: String ); Override;
    procedure FieldPutNEx(FieldNo: Integer; const Value: String); override;
    Procedure First; Override;
    Procedure FloatPut( Const FieldName: String; Const Value: Double ); Override;
    Procedure FloatPutN( FieldNo: integer; Const Value: Double ); Override;
    Procedure FlushDB; Override;
    Procedure Go( n: Integer ); Override;
    Procedure IndexOn( Const IName, tag, keyexp, forexp: String;
      uniq: TEzIndexUnique; ascnd: TEzSortStatus ); Override;
    Procedure IntegerPut( Const FieldName: String; Value: Integer ); Override;
    Procedure IntegerPutN( FieldNo: integer; Value: Integer ); Override;
    Procedure Last; Override;
    Procedure LogicPut( Const FieldName: String; value: Boolean ); Override;
    Procedure LogicPutN( fieldno: integer; value: Boolean ); Override;
    Procedure MemoLoad( Const FieldName: String; Stream: TStream ); Override;
    Procedure MemoLoadN( fieldno: integer; Stream: TStream ); Override;
    Procedure Next; Override;
    Procedure Pack; Override;
    Procedure Post; Override;
    Procedure Prior; Override;
    Procedure Recall; Override;

    Procedure Refresh; Override;
    Procedure Reindex; Override;
    Procedure SetTagTo( Const TName: String ); Override;
    Procedure SetUseDeleted( tf: Boolean ); Override;
    Procedure StringPut( Const FieldName, value: String ); Override;
    Procedure StringPutN( fieldno: integer; Const value: String ); Override;
    Procedure Zap; Override;
    function DBTableExists( const TableName: string ): Boolean; Override;

    Property Layer: TEzIBLayer
      read {$IFDEF BCB} GetLayer {$ELSE} FLayer {$ENDIF}
      write {$IFDEF BCB} SetLayer {$ELSE} FLayer {$ENDIF}; (*_*)
  End;

Implementation

Uses
  Inifiles, ezsystem, ezconsts, ezentities, ezctrls, ezcadctrls,
  ezbasicctrls, ezimpl, IBHeader
{$IFDEF COMPRESSED_ENTITY}
  , EzZLibUtil
{$ENDIF}
{$IFDEF LEVEL6}
  , Variants
{$ENDIF}
  ;

Resourcestring

  SEz_GisIBVersion = 'TEzIBGis Version 1.95 (Ene, 2003)';

  SQL_GETLAYERLIST =
    'SELECT rdb$relation_name FROM rdb$relations WHERE UPPER( rdb$relation_name) LIKE ''LAYINFO%''';

  SQL_CHECKTABLEEXISTS =
    'SELECT rdb$relation_name FROM rdb$relations WHERE UPPER(rdb$relation_name) = ''%s''';

  SQL_CHECKPROCEXISTS =
    'SELECT rdb$procedure_name FROM rdb$procedures WHERE UPPER(rdb$procedure_name) = ''%s''';

  SQL_CHECKGENERATOREXISTS =
    'SELECT rdb$generator_name FROM rdb$generators WHERE UPPER(rdb$generator_name) = ''%s''';

  //SQL_CHECKTRIGGEREXISTS =
  //  'SELECT rdb$trigger_name FROM rdb$triggers WHERE UPPER(rdb$trigger_name) = ''%s''';

  SQL_CHECKUDFEXISTS =
    'SELECT rdb$function_name FROM rdb$functions WHERE UPPER(rdb$function_name) = ''%s''';

  SQL_DOMAIN1 = 'CREATE DOMAIN dmnBOOLEAN AS CHAR(1) CHECK ( VALUE IN (''Y'', ''N'') ) NOT NULL ;';

  SQL_DECLAREUDF1 =
  'DECLARE EXTERNAL FUNCTION ezsearch_init ' + crlf +
	'  INTEGER, INTEGER, INTEGER, INTEGER ' + crlf +
	'  RETURNS INTEGER BY VALUE ' + crlf +
	'  ENTRY_POINT ''IB_ezsearch_init'' MODULE_NAME ''ib_ezudfs''; ' ;

  SQL_DECLAREUDF2 =
  'DECLARE EXTERNAL FUNCTION ezsearch_find ' + crlf +
	'  INTEGER, INTEGER, INTEGER, CSTRING(10), CSTRING(3010), INTEGER ' + crlf +
	'  RETURNS INTEGER BY VALUE ' + crlf +
	'  ENTRY_POINT ''IB_ezsearch_find'' MODULE_NAME ''ib_ezudfs''; ' ;

  SQL_DECLAREUDF3 =
  'DECLARE EXTERNAL FUNCTION ezsearch_first ' + crlf +
	'  INTEGER ' + crlf +
	'  RETURNS INTEGER BY VALUE ' + crlf +
	'  ENTRY_POINT ''IB_ezsearch_first'' MODULE_NAME ''ib_ezudfs''; ' ;

  SQL_DECLAREUDF4 =
  'DECLARE EXTERNAL FUNCTION ezsearch_next ' + crlf +
	'  INTEGER ' + crlf +
	'  RETURNS INTEGER BY VALUE ' + crlf +
	'  ENTRY_POINT ''IB_ezsearch_next'' MODULE_NAME ''ib_ezudfs''; ' ;

  SQL_DECLAREUDF5 =
  'DECLARE EXTERNAL FUNCTION ezsearch_finish ' + crlf +
	'  INTEGER ' + crlf +
	'  RETURNS INTEGER BY VALUE ' + crlf +
	'  ENTRY_POINT ''IB_ezsearch_finish'' MODULE_NAME ''ib_ezudfs''; ' ;

  SQL_CREATELAYINFO1 =
    'CREATE TABLE LAYINFO_%s (' +
    'VERSION int DEFAULT 141,' +
    'LASTUID int DEFAULT 0,' +
    'VISIBLE dmnBOOLEAN DEFAULT ''Y'' ,' +   //CHECK (VALUE = UPPER(VALUE))
    'SELECTABLE dmnBOOLEAN DEFAULT ''Y'' ,' +    //CHECK (VALUE = UPPER(VALUE))
    'CANCELEVENTS dmnBOOLEAN DEFAULT ''N'' ,' +    // CHECK (VALUE = UPPER(VALUE))
    'TEXT_HAS_SHADOW dmnBOOLEAN DEFAULT ''N'' ,';  //CHECK (VALUE = UPPER(VALUE))

  SQL_CREATELAYINFO2 =
    'EXTENSION_x1 DOUBLE PRECISION DEFAULT 1000000000,' +
    'EXTENSION_y1 DOUBLE PRECISION DEFAULT 1000000000,' +
    'EXTENSION_x2 DOUBLE PRECISION DEFAULT -1000000000,' +
    'EXTENSION_y2 DOUBLE PRECISION DEFAULT -1000000000,';

  SQL_CREATELAYINFO3 =
    'COORDSUNITS int DEFAULT 0,' +
    'COORDSYSTEM int DEFAULT 0,';

  SQL_CREATELAYINFO4 =
    'OVERLAPPED_TEXT_ACTION smallint DEFAULT 0,' +
    'OVERLAPPED_TEXT_COLOR int DEFAULT 0,' +
    'TEXT_FIXED_SIZE smallint DEFAULT 0,';

  SQL_CREATELAYINFO5 = // r-tree information also goes here
    'ROOTNODE int DEFAULT 0,' +
    'DEPTH	int DEFAULT 0,' +
    'TREETYPE int DEFAULT 0,' +
    'MULTIPLIER integer DEFAULT 1,' +
    'BUCKETSIZE int DEFAULT 50,' +
    'LOWERBOUND int DEFAULT 20)';

  SQL_CREATEENT =
    'CREATE TABLE ENT_%s (' +
    'UID int NOT NULL PRIMARY KEY,' +
    'DELETED dmnBOOLEAN DEFAULT ''N'' ,'+    //CHECK (VALUE = UPPER(VALUE))
    'XMIN DOUBLE PRECISION DEFAULT 0,' +
    'YMIN DOUBLE PRECISION DEFAULT 0,' +
    'XMAX DOUBLE PRECISION DEFAULT 0,' +
    'YMAX DOUBLE PRECISION DEFAULT 0,' +
    'SHAPETYPE smallint DEFAULT 0,';

  SQL_CREATERTX =
    'CREATE TABLE RTX_%s (' +
    'PAGEID int NOT NULL PRIMARY KEY,' +
    'PARENT int DEFAULT 0,' +
    'FULLENTRIES int DEFAULT 0,' +
    'LEAF dmnBOOLEAN DEFAULT ''Y'' ,' +    //CHECK (VALUE = UPPER(VALUE))
    'ENTRIES char(3000) )';

  SQL_UPDATENODE = 'UPDATE rtx_%s SET parent = %d, fullentries = %d, leaf = ''%s'', ' +
    'entries = ''%s'' WHERE pageid = %d';

  // what a disappointment !!!: not possible to pass BLOBs to stored procedures in InterBase
  SP_ADDENTITY = 'CREATE PROCEDURE addentity_xxx ( ' + crlf +
    '  v_xmin DOUBLE PRECISION, v_ymin DOUBLE PRECISION, ' + crlf +
    '  v_xmax DOUBLE PRECISION, v_ymax DOUBLE PRECISION, v_shapetype int)' + crlf +
    '  RETURNS ( newuid int )' + crlf +
    'AS' + crlf +
    'BEGIN' + crlf +
    '  newuid = gen_id( gen_ent_xxx, 1 ) ;' + crlf +
    '  INSERT INTO ent_xxx ( uid, deleted, xmin, ymin, xmax, ymax, shapetype)' + crlf +
    '    VALUES ( :newuid, ''N'', :v_xmin, :v_ymin, :v_xmax, :v_ymax, :v_shapetype );' + crlf +
    '  SUSPEND;' + crlf +
    'END';

  SP_ADDNODE = 'CREATE PROCEDURE addnode_xxx (' + crlf +
    '  v_parent INT, v_fullentries INT, v_leaf CHAR(1), v_entries char(3000) ) ' + crlf +
    '  RETURNS ( oid INT )' + crlf +
    'AS' + crlf +
    'BEGIN' + crlf +
    '  oid = gen_id( gen_rtx_xxx, 1 ) ;' + crlf +
    '  INSERT INTO rtx_xxx (pageid, parent, fullentries, leaf, entries)' + crlf +
    '    VALUES (:oid, :v_parent, :v_fullentries, :v_leaf, :v_entries ) ;' + crlf +
    '  SUSPEND;' + crlf +
    'END' ;

  SP_SEARCH1 =
    'create procedure search_xxx( x1 int, y1 int, x2 int, y2 int )' + crlf +
    '  returns ( uid int )' + crlf +
    'as' + crlf +
    '  declare variable v_leaf char(1) ;' + crlf +
    '  declare variable v_entries char(3000) ;' + crlf +
    '  declare variable v_fullentries int ;' + crlf +
    '  declare variable v_pid int ;' + crlf +
    '  declare variable runid int;' + crlf +
    '  declare variable zone int ;' + crlf +
    '  declare variable temp varchar(1) ;' + crlf +
    'begin' + crlf +
    '  select rootnode from layinfo_xxx into :v_pid ;' + crlf +
    '' + crlf +
    '  runid = ezsearch_init ( x1, y1, x2, y2 );' + crlf +
    '' + crlf +
    '  zone = 0;   /* zone to reentry */' + crlf +
    '  while (v_pid <> 0) do' + crlf +
    '  begin' + crlf +
    '' + crlf ;
  SP_SEARCH2 =
    '    SELECT leaf, fullentries, entries FROM rtx_xxx WHERE pageid = :v_pid' + crlf +
    '      into :v_leaf, :v_fullentries, :v_entries ;' + crlf +
    '' + crlf +
    '    temp = v_leaf;' + crlf +
    '    v_pid = ezsearch_find( runid, zone, v_pid, temp, v_entries, v_fullentries );' + crlf +
    '' + crlf +
    '    if (v_pid <> 0) then' + crlf +
    '    begin' + crlf +
    '      if (v_pid < 0) then' + crlf +
    '      begin' + crlf +
    '        v_pid = -v_pid;' + crlf +
    '        zone = 1;' + crlf +
    '      end else' + crlf +
    '      begin' + crlf +
    '        zone = 0;' + crlf +
    '      end' + crlf +
    '    end' + crlf +
    '  end' + crlf +
    '' + crlf +
    '  /* retrieve the results */' + crlf +
    '  uid = ezsearch_first ( runid );' + crlf +
    '  while (uid <> 0) do' + crlf +
    '  begin' + crlf +
    '    suspend;' + crlf +
    '    uid = ezsearch_next( runid );' + crlf +
    '  end' + crlf +
    '' + crlf +
    '  runid = ezsearch_finish ( runid );' + crlf +
    '' + crlf +
    'end' ;

  SQL_CREATEMAPHEADER1 =
    'CREATE TABLE MAP_HEADER (' +
    '  VERSION int DEFAULT 141,' +
    '  EXTENSION_x1 DOUBLE PRECISION DEFAULT 1.0E100,' +
    '  EXTENSION_y1 DOUBLE PRECISION DEFAULT 1.0E100,' +
    '  EXTENSION_x2 DOUBLE PRECISION DEFAULT -1.0E100,' +
    '  EXTENSION_Y2 DOUBLE PRECISION DEFAULT -1.0E100,' +
    '  CURRENTLAYER varchar(60) DEFAULT '''',' +
    '  AERIALVIEWLAYER varchar(60) DEFAULT '''',' +
    '  LASTVIEW_x1 DOUBLE PRECISION DEFAULT 0,' +
    '  LASTVIEW_y1 DOUBLE PRECISION DEFAULT 0,' +
    '  LASTVIEW_x2 DOUBLE PRECISION DEFAULT 100,' +
    '  LASTVIEW_y2 DOUBLE PRECISION DEFAULT 100,' +
    '  COORDSUNITS int DEFAULT 0,' +
    '  COORDSYSTEM int DEFAULT 0,' ;
  SQL_CREATEMAPHEADER2 =
    '  ISAREACLIPPED dmnBOOLEAN DEFAULT ''N'' ,' +  //CHECK (VALUE = UPPER(VALUE))
    '  AREACLIPPED_x1 DOUBLE PRECISION DEFAULT 0,' +
    '  AREACLIPPED_y1 DOUBLE PRECISION DEFAULT 0,' +
    '  AREACLIPPED_x2 DOUBLE PRECISION DEFAULT 0,' +
    '  AREACLIPPED_y2 DOUBLE PRECISION DEFAULT 0,' +
    '  CLIPAREAKIND int DEFAULT 0,' +
    '  POLYCLIPAREA BLOB SUB_TYPE 0 SEGMENT SIZE 1024,' +
    '  PROJ_PARAMS BLOB SUB_TYPE 0 SEGMENT SIZE 120,' +
    '  GUIDELINES BLOB SUB_TYPE 0 SEGMENT SIZE 1024,' +
    '  SYMBOLS BLOB SUB_TYPE 0 SEGMENT SIZE 1024,' +
    '  LAYERS BLOB SUB_TYPE 1 SEGMENT SIZE 120 )';

  STableNotFound = 'Table %s was not found';


  {------------------------------------------------------------------------------}
  {                  Trial Version stuff                                         }
  {------------------------------------------------------------------------------}

{$IFDEF IBTRIAL_VERSION}
Const
  MAX_HOURS = 50;

Resourcestring
  SHiddenFile = 'IBHLP.DLL';
  STimeExpired = 'Demo time of TEzIBGis Component has expired !';
  SDemoVersion =
    'You are using a demonstration version of TEzIBGis Component' + CrLf +
    'This message is only displayed on the demo version' + CrLf +
    'of this software. To register, contact us at:' + CrLf +
    'http://www.ezgis.com' + CrLf;

Type
  TSecurityFileRec = Record
    MagicNumber: LongInt;
    Seconds: DWORD;
    Runs: DWORD;
    LastCheck: DWORD;
  End;

Const
  MAGIC_NUMBER = DWORD( 040508 ); {08=LA, 05=K, 04=KJ}

Var
  IBGisInstances: Integer;
  IBSecurityFile: String; { Security File }

Function BuildSecurityFile: boolean;
Var
  IO: TFileStream;
  SecFileRec: TSecurityFileRec;
  I: integer;
  R: TDateTime;
Begin
  IO := TFileStream.Create( IBSecurityFile, fmCreate );
  Try
    FillChar( SecFileRec, sizEof( SecFileRec ), 0 );
    SecFileRec.MagicNumber := MAGIC_NUMBER;
    IO.Write( SecFileRec, sizEof( SecFileRec ) );
    { write random data }
    For I := 1 To 1500 Do
    Begin
      R := Random;
      IO.Write( R, sizEof( double ) );
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
  If Not FileExists( IBSecurityFile ) Then
    Exit;
  IO := TFileStream.Create( IBSecurityFile, fmOpenRead Or fmShareDenyNone );
  Try
    IO.Read( SecFileRec, sizEof( SecFileRec ) );
    If SecFileRec.MagicNumber <> MAGIC_NUMBER Then
      exit;
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
  If Not FileExists( IBSecurityFile ) Then Exit;
  IO := TFileStream.Create( IBSecurityFile, fmOpenReadWrite Or fmShareDenyNone );
  Try
    IO.Read( SecFileRec, sizEof( SecFileRec ) );
    If SecFileRec.MagicNumber <> MAGIC_NUMBER Then Exit;
    TimeEnd := GetTickCount;
    SecsUsed := ( TimeEnd - TimeStart ) Div 1000;
    With SecFileRec Do
    Begin
      Inc( Seconds, SecsUsed );
      Inc( Runs );
    End;
    IO.Seek( 0, 0 );
    IO.Write( SecFileRec, sizEof( SecFileRec ) );
    result := true;
  Finally
    IO.free;
  End;
End;

Procedure SecurityDemoTimeUsed( Var Seconds, LastCheck, Runs: DWORD );
Var
  IO: TFileStream;
  SecFileRec: TSecurityFileRec;
Begin
  If Not FileExists( IBSecurityFile ) Then Exit;
  IO := TFileStream.Create( IBSecurityFile, fmOpenRead Or fmShareDenyNone );
  Try
    IO.Read( SecFileRec, sizEof( SecFileRec ) );
    If SecFileRec.MagicNumber <> MAGIC_NUMBER Then Exit;
    Seconds := SecFileRec.Seconds;
    Runs := SecFileRec.Runs;
    LastCheck := SecFileRec.LastCheck;
  Finally
    IO.Free;
  End;
End;

Function SecurityCheckIfValid( ShowWarning: Boolean ): Boolean;
Var
  Buffer: PChar;
  SystemDir: String;
  Runs, HoursUsed, SecondsUsed, LastCheck: DWORD;
  Stream: TFileStream;
  SecFileRec: TSecurityFileRec;
Begin
  Result := false;
  Buffer := StrAlloc( 255 );
  Try
    GetSystemDirectory( Buffer, 255 );
    SystemDir := AddSlash( StrPas( Buffer ) );
  Finally
    StrDispose( Buffer );
  End;
  IBSecurityFile := SystemDir + SHiddenFile;

  If Not FileExists( IBSecurityFile ) And Not BuildSecurityFile Then Exit;

  SecurityDemoTimeUsed( SecondsUsed, LastCheck, Runs );
  HoursUsed := ( SecondsUsed Div 3600 );
  If ( HoursUsed >= MAX_HOURS ) And ShowWarning Then
  Begin
    Application.MessageBox( pchar( STimeExpired ),
      pchar( smsgwarning ),
      MB_OK Or MB_ICONWARNING );
    Exit;
  End;
  { show demo version window }
  If ShowWarning Then
  Begin
    If ( SecondsUsed - LastCheck ) >= ( 10 * 60 ) Then // check every n minutes
    Begin
      Application.MessageBox( PChar( Format( SDemoVersion, [MAX_HOURS - HoursUsed] ) ),
        PChar( smsgwarning ), MB_OK Or MB_ICONWARNING );

      Stream := TFileStream.create( IBSecurityFile, fmOpenReadWrite Or fmShareDenyNone );
      Try
        Stream.Read( SecFileRec, sizEof( SecFileRec ) );
        SecFileRec.LastCheck := SecondsUsed;
        Stream.Seek( 0, 0 );
        Stream.Write( SecFileRec, sizEof( SecFileRec ) );
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
{                  Helper procedures                                           }
{------------------------------------------------------------------------------}


Procedure IBStartTrans( IBSQL: TIBSQL );
Begin
  If ( IBSQL.Database.Connected ) And ( IBSQL.Transaction.InTransaction = False ) Then
    IBSQL.Transaction.StartTransaction;
End;

Procedure IBRollbackTrans( IBSQL: TIBSQL );
Begin
  If ( IBSQL.Database.Connected ) And ( IBSQL.Transaction.InTransaction = True ) Then
    IBSQL.Transaction.RollBack;
End;

Procedure IBCommitTrans( IBSQL: TIBSQL );
Begin
  If ( IBSQL.Database.Connected ) And ( IBSQL.Transaction.InTransaction = True ) Then
  begin
    try
      IBSQL.Transaction.Commit;
    except
      IBRollbackTrans( IBSQL );
      raise;
    end;
  end;
End;

Function TableExists( Const TableName: String; IBSQL: TIBSQL ): Boolean;
Begin
  With IBSQL Do
  Begin
    Close;
    SQL.Text := Format( SQL_CHECKTABLEEXISTS, [UpperCase(TableName)] );
    IBStartTrans( IBSQL );
    ExecQuery;
    Result := Not Eof;
    IBCommitTrans( IBSQL );
    Close;
  End;
End;

Function StoredProcExists( Const StoredProcName: String; IBSQL: TIBSQL ): Boolean;
Begin
  With IBSQL Do
  Begin
    Close;
    SQL.Text := Format( SQL_CHECKPROCEXISTS, [UpperCase(StoredProcName)] );
    IBStartTrans( IBSQL );
    ExecQuery;
    Result := Not Eof;
    IBCommitTrans( IBSQL );
    Close;
  End;
End;

Function GeneratorExists( Const GeneratorName: String; IBSQL: TIBSQL ): Boolean;
Begin
  With IBSQL Do
  Begin
    Close;
    SQL.Text := Format( SQL_CHECKGENERATOREXISTS, [UpperCase(GeneratorName)] );
    IBStartTrans( IBSQL );
    ExecQuery;
    Result := Not Eof;
    IBCommitTrans( IBSQL );
    Close;
  End;
End;

{Function TriggerExists( Const TriggerName: String; IBSQL: TIBSQL ): Boolean;
Begin
  With IBSQL Do
  Begin
    Close;
    SQL.Text := Format( SQL_CHECKTRIGGEREXISTS, [UpperCase(TriggerName)] );
    IBStartTrans( IBSQL );
    ExecQuery;
    Result := Not Eof;
    IBCommitTrans( IBSQL );
    Close;
  End;
End;}

Function InterbaseUDFExists( Const UdfName: String; IBSQL: TIBSQL ): Boolean;
Begin
  With IBSQL Do
  Begin
    Close;
    SQL.Text := Format( SQL_CHECKUDFEXISTS, [UpperCase(UdfName)] );
    IBStartTrans( IBSQL );
    ExecQuery;
    Result := Not Eof;
    IBCommitTrans( IBSQL );
    Close;
  End;
End;

Procedure CreateLayerElements( Const LayerName: String; IBSQL: TIBSQL );
Var
  tbl: String;

  Procedure CreateElement(const Ele: string);
  Begin
    With IBSQL Do
    Begin
      Close;
      ParamCheck:=false;
      SQL.Text:= Ele;
      IBStartTrans( IBSQL );
      ExecQuery;
      IBCommitTrans( IBSQL );
      Close;
    End;
  End;

Begin

  // GENERATORS
  If Not GeneratorExists( 'gen_ent_' + LayerName, IBSQL ) then
  Begin
    tbl := 'CREATE GENERATOR gen_ent_'+layername;
    CreateElement(tbl);
    //tbl := 'SET GENERATOR gen_ent_' + layername + ' TO 0';
    //CreateElement(tbl);
  End;

  If Not GeneratorExists( 'gen_rtx_' + LayerName, IBSQL ) then
  Begin
    tbl := 'CREATE GENERATOR gen_rtx_'+layername;
    CreateElement(tbl);
    //tbl:= 'SET GENERATOR gen_rtx_' + layername + ' TO ';
    //CreateElement(tbl);
  End;

  // TRIGGERS
  {If Not TriggerExists( 'set_ent_uid_' + LayerName, IBSQL ) then
  Begin
    tbl := TRIGGER_ENT;
    tbl:= StringReplace( tbl, '_xxx', '_' + LayerName, [rfReplaceAll, rfIgnoreCase] );
    CreateElement(tbl);
  End;

  If Not TriggerExists( 'set_rtx_pageid_' + LayerName, IBSQL ) then
  Begin
    tbl := TRIGGER_RTX;
    tbl:= StringReplace( tbl, '_xxx', '_' + LayerName, [rfReplaceAll, rfIgnoreCase] );
    CreateElement(tbl);
  End; }

  // addentity stored procedure
  If Not StoredProcExists( 'addentity_' + LayerName, IBSQL ) Then
  Begin
    tbl := SP_ADDENTITY;
    tbl:= StringReplace( tbl, '_xxx', '_' + LayerName, [rfReplaceAll, rfIgnoreCase] );
    CreateElement(tbl);
  End;

  // add node procedure
  If Not StoredProcExists( 'addnode_' + LayerName, IBSQL ) Then
  Begin
    tbl := SP_ADDNODE;
    tbl:= StringReplace( tbl, '_xxx', '_' + LayerName, [rfReplaceAll, rfIgnoreCase] );
    CreateElement(tbl);
  End;

  // rtree search procedure
  If Not StoredProcExists( 'search_' + LayerName, IBSQL ) Then
  Begin
    tbl := SP_SEARCH1+SP_SEARCH2;
    tbl:= StringReplace( tbl, '_xxx', '_' + LayerName, [rfReplaceAll, rfIgnoreCase] );
    CreateElement(tbl);
  End;

End;

Procedure CreateGlobalElements( IBSQL: TIBSQL );
Begin
  With IBSQL Do
  Begin

    If Not TableExists( 'temp_records', IBSQL ) Then
    begin
      SQL.Text := 'CREATE TABLE temp_records (uid INT NOT NULL PRIMARY KEY)';
      IBStartTrans( IBSQL );
      ExecQuery;
      IBCommitTrans( IBSQL );
      Close;
    end;

    If Not InterbaseUDFExists( 'ezsearch_init', IBSQL ) Then
    Begin
      SQL.Text := SQL_DECLAREUDF1;
      IBStartTrans( IBSQL );
      ExecQuery;
      IBCommitTrans( IBSQL );
      Close;
    End;

    If Not InterbaseUDFExists( 'ezsearch_find', IBSQL ) Then
    Begin
      SQL.Text := SQL_DECLAREUDF2;
      IBStartTrans( IBSQL );
      ExecQuery;
      IBCommitTrans( IBSQL );
      Close;
    End;

    If Not InterbaseUDFExists( 'ezsearch_first', IBSQL ) Then
    Begin
      SQL.Text := SQL_DECLAREUDF3;
      IBStartTrans( IBSQL );
      ExecQuery;
      IBCommitTrans( IBSQL );
      Close;
    End;

    If Not InterbaseUDFExists( 'ezsearch_next', IBSQL ) Then
    Begin
      SQL.Text := SQL_DECLAREUDF4;
      IBStartTrans( IBSQL );
      ExecQuery;
      IBCommitTrans( IBSQL );
      Close;
    End;

    If Not InterbaseUDFExists( 'ezsearch_finish', IBSQL ) Then
    Begin
      SQL.Text := SQL_DECLAREUDF5;
      IBStartTrans( IBSQL );
      ExecQuery;
      IBCommitTrans( IBSQL );
      Close;
    End;
  End;

End;

Procedure LeftSet( Var s: String; Const value: String; start, len: integer );
Var
  i: integer;
Begin
  For i := 1 To ezlib.imin( length( value ), len ) Do
    s[start + i - 1] := value[i];
End;

Procedure SetDataToString( Const Data: TDiskPage; Var s: String );
Var
  i: integer;
Begin
  SetLength( s, 12 * 5 * 50 );
  FillChar( s[1], 12 * 5 * 50, #32 );
  For i := 0 To Data.FullEntries - 1 Do
  Begin
    LeftSet( s, IntToStr( Data.Entries[i].R.x1 ), i * ( 12 * 5 ) + 1, 12 );
    LeftSet( s, IntToStr( Data.Entries[i].R.y1 ), i * ( 12 * 5 ) + 13, 12 );
    LeftSet( s, IntToStr( Data.Entries[i].R.x2 ), i * ( 12 * 5 ) + 25, 12 );
    LeftSet( s, IntToStr( Data.Entries[i].R.y2 ), i * ( 12 * 5 ) + 37, 12 );
    LeftSet( s, IntToStr( Data.Entries[i].Child ), i * ( 12 * 5 ) + 49, 12 );
  End;
End;

Procedure SetStringToData( Const s: String; Var Data: TDiskPage );
Var
  i: integer;
Begin
  FillChar( Data.Entries, sizEof( Data.Entries ), 0 );
  For i := 0 To Data.FullEntries - 1 Do
  Begin
    Data.Entries[i].R.x1 := StrToInt( TrimRight( copy( s, i * ( 12 * 5 ) + 1, 12 ) ) );
    Data.Entries[i].R.y1 := StrToInt( TrimRight( copy( s, i * ( 12 * 5 ) + 13, 12 ) ) );
    Data.Entries[i].R.x2 := StrToInt( TrimRight( copy( s, i * ( 12 * 5 ) + 25, 12 ) ) );
    Data.Entries[i].R.y2 := StrToInt( TrimRight( copy( s, i * ( 12 * 5 ) + 37, 12 ) ) );
    Data.Entries[i].Child := StrToInt( TrimRight( copy( s, i * ( 12 * 5 ) + 49, 12 ) ) );
  End;
End;


{------------------------------------------------------------------------------}
{                  TEzIBTable - class implementation                          }
{------------------------------------------------------------------------------}

Function TEzIBTable.Dataset: TIBSQL;
Begin
  { regresa el dataset que se esta usando en ese momento}
  Result:= FLayer.DataSet;
End;

Function TEzIBTable.GetActive: boolean;
Begin
  result := Dataset.Open;
End;

Procedure TEzIBTable.SetActive( Value: boolean );
Begin
  // nothing to do here
End;

Function TEzIBTable.GetRecNo: Integer;
Begin
  Result := FCurrRecno;
End;

Procedure TEzIBTable.SetRecNo( Value: Integer );
Begin
  FCurrRecno:= Value;
End;

Procedure TEzIBTable.Append( NewRecno: Integer );
Begin
  // nothing to do here
End;

Function TEzIBTable.Bof: Boolean;
Begin
  result := Dataset.Bof;
End;

Function TEzIBTable.Eof: Boolean;
Begin
  result := Dataset.Eof;
End;

Procedure TEzIBTable.OpenIBSQL( Const ASQL: String );
Begin
  With DataSet Do
  Begin
    Close;
    SQL.Text := ASQL;
    IBStartTrans( DataSet );
    ExecQuery;
  End;
End;

Procedure TEzIBTable.ExecuteIBSQL( Const Asql: String );
Begin
  With Dataset Do
  Begin
    Close;
    SQL.Text := Asql;
    IBStartTrans( Dataset );
    ExecQuery;
    IBCommitTrans( Dataset );
    Close;
  End;
End;

Function TEzIBTable.DateGet( Const FieldName: String ): TDateTime;
Begin
  OpenIBSQL( Format( 'SELECT %s FROM %s WHERE uid = %d', [FieldName, Self.TheTableName, FCurrRecno] ) );
  result := Dataset.Fields[0].AsDateTime;
  IBCommitTrans( Dataset );
  Dataset.Close;
End;

Function TEzIBTable.DateGetN( FieldNo: integer ): TDateTime;
Begin
  OpenIBSQL( Format( 'SELECT * FROM %s WHERE uid = %d', [Self.TheTableName, FCurrRecno] ) );
  result := Dataset.Fields[FieldNo-1].AsDateTime;
  IBCommitTrans( Dataset );
  Dataset.Close;
End;

Function TEzIBTable.Deleted: Boolean;
Begin
  result := FLayer.RecIsDeleted;
End;

Function TEzIBTable.Field( FieldNo: integer ): String;
Begin
  OpenIBSQL( Format( 'SELECT * FROM %s WHERE uid = %d', [Self.TheTableName, FCurrRecno] ) );
  result := Dataset.Fields[FieldNo-1].Name;
  IBCommitTrans( Dataset );
  Dataset.Close;
End;

Function TEzIBTable.FieldCount: integer;
Begin
  OpenIBSQL( Format( 'SELECT * FROM %s WHERE uid = %d', [Self.TheTableName, FCurrRecno] ) );
  result:=dataset.Current.Count;
  IBCommitTrans( Dataset );
  Dataset.Close;
End;

Function TEzIBTable.FieldDec( FieldNo: integer ): integer;
Begin
  Result:=0;
End;

Function TEzIBTable.FieldGet( Const FieldName: String ): String;
Begin
  OpenIBSQL( Format( 'SELECT %s FROM %s WHERE uid = %d', [FieldName, Self.TheTableName, FCurrRecno] ) );
  result := Dataset.Fields[0].AsTrimString;
  IBCommitTrans( Dataset );
  Dataset.Close;
End;

Function TEzIBTable.FieldGetN( FieldNo: integer ): String;
Begin
  OpenIBSQL( Format( 'SELECT * FROM %s WHERE uid = %d', [Self.TheTableName, FCurrRecno] ) );
  result := Dataset.Fields[FieldNo-1].AsTrimString;
  IBCommitTrans( Dataset );
  Dataset.Close;
End;

Function TEzIBTable.FieldLen( FieldNo: integer ): integer;
Begin
  Result:=0;
End;

Function TEzIBTable.FieldNo( Const FieldName: String ): integer;
Begin
  OpenIBSQL( Format( 'SELECT * FROM %s WHERE uid = %d', [Self.TheTableName, FCurrRecno] ) );
  result := Dataset.FieldIndex[ FieldName ] + 1;
  IBCommitTrans( Dataset );
  Dataset.Close;
End;

Function TEzIBTable.TheTableName: string;
begin
  Result:= 'ENT_' + FLayer.Name;
end;

Function TEzIBTable.FieldType( FieldNo: integer ): char;
Begin
  Result := #0;
  OpenIBSQL( Format( 'SELECT * FROM %s WHERE uid = %d', [ Self.TheTableName, FCurrRecno] ) );
  case Dataset.Fields[ FieldNo-1 ].SQLType of
    SQL_TEXT, SQL_VARYING:
       Result:= 'C';
    SQL_DOUBLE, SQL_FLOAT, SQL_D_FLOAT:
       Result:= 'N';
    SQL_LONG, SQL_SHORT, SQL_INT64:
       Result:= 'N';
    SQL_TIMESTAMP, SQL_TYPE_TIME, SQL_TYPE_DATE:
       Result:= 'D';
    SQL_BLOB: Result:= 'B';
  end;
  IBCommitTrans( Dataset );
  Dataset.Close;
End;

Function TEzIBTable.Find( Const ss: String; IsExact, IsNear: boolean ): boolean;
Begin
  Result:=false;
End;

Function TEzIBTable.FloatGet( Const Fieldname: String ): Double;
Begin
  OpenIBSQL( Format( 'SELECT %s FROM %s WHERE uid = %d', [FieldName, Self.TheTableName, FCurrRecno] ) );
  result := Dataset.Fields[0].AsDouble;
  IBCommitTrans( Dataset );
  Dataset.Close;
End;

Function TEzIBTable.FloatGetN( FieldNo: Integer ): Double;
Begin
  OpenIBSQL( Format( 'SELECT * FROM %s WHERE uid = %d', [Self.TheTableName, FCurrRecno] ) );
  result := Dataset.Fields[FieldNo-1].AsDouble;
  IBCommitTrans( Dataset );
  Dataset.Close;
End;

Function TEzIBTable.IndexCount: integer;
Begin
  result := 0;  // inexact
End;

Function TEzIBTable.IndexAscending( Value: integer ): boolean;
Begin
  Result := true;   // default e inexact
End;

Function TEzIBTable.Index( Const INames, Tag: String ): integer;
Begin
  // nothing to do here
End;

Function TEzIBTable.IndexCurrent: String;
Begin
  result := '';
End;

Function TEzIBTable.IndexUnique( Value: integer ): boolean;
Begin
  Result := true;
End;

Function TEzIBTable.IndexExpression( Value: integer ): String;
Begin
  result := '';
End;

Function TEzIBTable.IndexTagName( Value: integer ): String;
Begin
  result := '';
End;

Function TEzIBTable.IndexFilter( Value: integer ): String;
Begin
  result := '';
End;

Function TEzIBTable.IntegerGet( Const FieldName: String ): Integer;
Begin
  OpenIBSQL( Format( 'SELECT %s FROM %s WHERE uid = %d', [FieldName, Self.TheTableName, FCurrRecno] ) );
  result := Dataset.Fields[0].AsInteger;
  IBCommitTrans( Dataset );
  Dataset.Close;
End;

Function TEzIBTable.IntegerGetN( FieldNo: integer ): Integer;
Begin
  OpenIBSQL( Format( 'SELECT * FROM %s WHERE uid = %d', [Self.TheTableName, FCurrRecno] ) );
  result := Dataset.Fields[FieldNo-1].AsInteger;
  IBCommitTrans( Dataset );
  Dataset.Close;
End;

Function TEzIBTable.LogicGet( Const FieldName: String ): Boolean;
Begin
  OpenIBSQL( Format( 'SELECT %s FROM %s WHERE uid = %d', [FieldName, Self.TheTableName, FCurrRecno] ) );
  result := Dataset.Fields[0].AsString = 'Y';
  IBCommitTrans( Dataset );
  Dataset.Close;
End;

Function TEzIBTable.LogicGetN( FieldNo: integer ): Boolean;
Begin
  OpenIBSQL( Format( 'SELECT * FROM %s WHERE uid = %d', [Self.TheTableName, FCurrRecno] ) );
  result := Dataset.Fields[FieldNo-1].AsString = 'Y';
  IBCommitTrans( Dataset );
  Dataset.Close;
End;

procedure TEzIBTable.MemoSave( Const FieldName: String; stream: tstream );
Begin
  // don't save with this
End;

Procedure TEzIBTable.MemoSaveN( FieldNo: integer; stream: tstream );
Begin
  // don't save with this
End;

Function TEzIBTable.MemoSize( Const FieldName: String ): Integer;
Begin
  // don't use this
End;

Function TEzIBTable.MemoSizeN( FieldNo: integer ): Integer;
Begin
  // don't use this
End;

Function TEzIBTable.RecordCount: Integer;
Begin
  result := FLayer.GetRecordCount;
End;

Function TEzIBTable.StringGet( Const FieldName: String ): String;
Begin
  OpenIBSQL( Format( 'SELECT %s FROM %s WHERE uid = %d', [FieldName, Self.TheTableName, FCurrRecno] ) );
  result := Dataset.Fields[0].AsString;
  IBCommitTrans( Dataset );
  Dataset.Close;
End;

Function TEzIBTable.StringGetN( FieldNo: integer ): String;
Begin
  OpenIBSQL( Format( 'SELECT * FROM %s WHERE uid = %d', [Self.TheTableName, FCurrRecno] ) );
  result := Dataset.Fields[FieldNo-1].AsString;
  IBCommitTrans( Dataset );
  Dataset.Close;
End;

Procedure TEzIBTable.DatePut( Const FieldName: String; value: TDateTime );
Begin
  ExecuteIBSQL( Format( 'UPDATE %s SET %s = ''%s'' WHERE uid = %d', [Self.TheTableName, FieldName, FormatDateTime( 'm/d/yyyy', Value ), FCurrRecno] ) );
End;

Procedure TEzIBTable.DatePutN( FieldNo: integer; value: TDateTime );
Begin
  ExecuteIBSQL( Format( 'UPDATE %s SET %s = ''%s'' WHERE uid = %d', [Self.TheTableName, Self.Field(FieldNo), FormatDateTime( 'm/d/yyyy', Value ), FCurrRecno] ) );
End;

Procedure TEzIBTable.Delete;
Begin
  // nothing to do here
End;

Procedure TEzIBTable.Edit;
Begin
  // don't use this
End;

Procedure TEzIBTable.FieldPut( Const FieldName, Value: String );
var
  Code: Integer;
  ValFloat: Double;
Begin
  case FieldType( FieldNo(FieldName) ) Of
    'C': StringPut( FieldName,Value);
    'N':
      Begin
        Val( Trim(Value), ValFloat, Code);
        If Code = 0 then
          FloatPut( FieldName,ValFloat )
        else
          FloatPut( FieldName, 0 );
      End;
    'D': DatePut( FieldName,StrToDate(Trim(Value)));
    'B': ;
  end;
End;

Procedure TEzIBTable.FieldPutN( FieldNo: integer; Const Value: String );
var
  Code: Integer;
  ValFloat: Double;
Begin
  case FieldType( FieldNo ) Of
    'C': StringPutN( FieldNo,Value);
    'N':
      Begin
        Val( Trim(Value), ValFloat, Code);
        If Code = 0 then
          FloatPutN( FieldNo,ValFloat )
        else
          FloatPutN( FieldNo, 0 );
      End;
    'D': DatePutN( FieldNo,StrToDate(Trim(Value)));
    'B': ;
  end;
End;

Procedure TEzIBTable.First;
Begin
  // don't use this
End;

Procedure TEzIBTable.FloatPut( Const FieldName: String; Const Value: Double );
Begin
  ExecuteIBSQL( Format( 'UPDATE %s SET %s = %.6f WHERE uid = %d', [Self.TheTableName, FieldName, Value, FCurrRecno] ) );
End;

Procedure TEzIBTable.FloatPutN( FieldNo: integer; Const Value: Double );
Begin
  ExecuteIBSQL( Format( 'UPDATE %s SET %s = %.6f WHERE uid = %d', [Self.TheTableName, Self.Field(FieldNo), Value, FCurrRecno] ) );
End;

Procedure TEzIBTable.FlushDB;
Begin
  // nothing to do here
End;

Procedure TEzIBTable.Go( n: Integer );
Begin
  FCurrRecno:= n ;
End;

Procedure TEzIBTable.IndexOn( Const IName, tag, keyexp, forexp: String;
  uniq: TEzIndexUnique; ascnd: TEzSortStatus );
Begin
  // nothing to do here
End;

Procedure TEzIBTable.IntegerPut( Const Fieldname: String; Value: Integer );
Begin
  ExecuteIBSQL( Format( 'UPDATE %s SET %s = %d WHERE uid = %d', [Self.TheTableName, FieldName, Value, FCurrRecno] ) );
End;

Procedure TEzIBTable.IntegerPutN( FieldNo: integer; Value: Integer );
Begin
  ExecuteIBSQL( Format( 'UPDATE %s SET %s = %d WHERE uid = %d', [Self.TheTableName, Self.Field(FieldNo), Value, FCurrRecno] ) );
End;

Procedure TEzIBTable.Last;
Begin
  // don't use this
End;

Procedure TEzIBTable.LogicPut( Const fieldname: String; value: boolean );
var
  yn: string;
Begin
  if value then yn:= 'Y' else yn:= 'N';
  ExecuteIBSQL( Format( 'UPDATE %s SET %s = ''%s'' WHERE uid = %d', [Self.TheTableName, fieldname, yn, FCurrRecno] ) );
End;

Procedure TEzIBTable.LogicPutN( fieldno: integer; value: boolean );
var
  yn: string;
Begin
  if value then yn:= 'Y' else yn:= 'N';
  ExecuteIBSQL( Format( 'UPDATE %s SET %s = ''%s'' WHERE uid = %d', [Self.TheTableName, Self.field(fieldno), yn, FCurrRecno] ) );
End;

Procedure TEzIBTable.MemoLoad( Const fieldname: String; stream: tstream );
Begin
  // don't use this
End;

Procedure TEzIBTable.MemoLoadN( fieldno: integer; stream: tstream );
Begin
  // don't use this
End;

Procedure TEzIBTable.Next;
Begin
  // don't use this
End;

Procedure TEzIBTable.Pack;
Begin
  // nothing to do here
End;

Procedure TEzIBTable.Post;
Begin
  // don't use this
End;

Procedure TEzIBTable.Prior;
Begin
  // don't use this
End;

Procedure TEzIBTable.Recall;
Begin
  // don't use this
End;

Procedure TEzIBTable.Refresh;
Begin
  // don't use this
End;

Procedure TEzIBTable.Reindex;
Begin
  // don't use this
End;

Procedure TEzIBTable.SetTagTo( Const TName: String );
Begin
  // don't use this
End;

Procedure TEzIBTable.SetUseDeleted( tf: boolean );
Begin
  // don't use this
End;

Procedure TEzIBTable.StringPut( Const fieldname, value: String );
Begin
  ExecuteIBSQL( Format( 'UPDATE %s SET %s = ''%s'' WHERE uid = %d', [Self.TheTableName, fieldname, value, FCurrRecno] ) );
End;

Procedure TEzIBTable.StringPutN( fieldno: integer; Const value: String );
Begin
  ExecuteIBSQL( Format( 'UPDATE %s SET %s = ''%s'' WHERE uid = %d', [Self.TheTableName, Self.field(fieldno), value, FCurrRecno] ) );
End;

Procedure TEzIBTable.Zap;
Begin
  // don't use this
End;

function TEzIBTable.DBTableExists( const TableName: string ): Boolean;
begin
  result:= true;
end;

Procedure TEzIBTable.BeginTrans;
begin
  // don't use this
end;

Procedure TEzIBTable.EndTrans;
begin
  // don't use this
end;

Procedure TEzIBTable.RollbackTrans;
begin
  // don't use this
end;

{$IFDEF BCB}
function TEzIBTable.GetLayer: TEzIBLayer;
begin
  Result := FLayer;
end;

procedure TEzIBTable.SetLayer(const Value: TEzIBLayer);
begin
  FLayer := Value;
end;
{$ENDIF}

{-------------------------------------------------------------------------------}
{                  TEzIBLayerInfo - class implementation                         }
{-------------------------------------------------------------------------------}

Constructor TEzIBLayerInfo.Create( Layer: TEzBaseLayer );
Begin
  Inherited Create( Layer );
  FClientData:= TEzIBLayerClientData.Create;
End;

Destructor TEzIBLayerInfo.Destroy;
Begin
  FClientData.Free;
  Inherited Destroy;
End;

Function TEzIBLayerInfo.GetVisible: Boolean;
Begin
  with FClientData do
  begin
    If Not visible_init Then
    Begin
      visible := TEzIBLayer( FLayer ).FIBField.AsBoolean['VISIBLE'];
      visible_init := true;
    End;
    result := visible;
  end;
End;

Procedure TEzIBLayerInfo.SetVisible( Value: Boolean );
Begin
  if GetVisible=Value then Exit;
  TEzIBLayer( FLayer ).FIBField.AsBoolean['VISIBLE'] := value;
  FClientData.visible := value;
  FClientData.visible_init:= true;
  with FLayer.Layers.GIS do
    If Assigned( OnVisibleLayerChange ) Then
      OnVisibleLayerChange( FLayer, FLayer.Name );
  SetModifiedStatus( FLayer );
End;

Function TEzIBLayerInfo.GetSelectable: Boolean;
Begin
  with FClientData do
  begin
    If Not selectable_init Then
    Begin
      selectable := TEzIBLayer( FLayer ).FIBField.AsBoolean['SELECTABLE'];
      selectable_init := true;
    End;
    result := selectable;
  end;
End;

Procedure TEzIBLayerInfo.SetSelectable( Value: Boolean );
Begin
  if GetSelectable=Value then exit;
  TEzIBLayer( FLayer ).FIBField.AsBoolean['SELECTABLE'] := value;
  FClientData.selectable := value;
  FClientData.selectable_init:= true;
  with FLayer.Layers.GIS do
    If Assigned( OnSelectableLayerChange ) Then
      OnSelectableLayerChange( FLayer, FLayer.Name );
  SetModifiedStatus( FLayer );
End;

Function TEzIBLayerInfo.GetIsCosmethic: Boolean;
Begin
  Result:= False;
End;

Procedure TEzIBLayerInfo.SetIsCosmethic( value: Boolean );
Begin
  // nothing to do here
End;

Function TEzIBLayerInfo.GetExtension: TEzRect;
Begin
  With result, TEzIBLayer( FLayer ).FIBField Do
  Begin
    X1 := AsFloat['EXTENSION_x1'];
    Y1 := AsFloat['EXTENSION_y1'];
    X2 := AsFloat['EXTENSION_x2'];
    Y2 := AsFloat['EXTENSION_y2'];
  End;
End;

Procedure TEzIBLayerInfo.SetExtension( Const Value: TEzRect );
Begin
  With Value, TEzIBLayer( FLayer ).FIBField Do
  Begin
    AsFloat['EXTENSION_x1'] := x1;
    AsFloat['EXTENSION_y1'] := y1;
    AsFloat['EXTENSION_x2'] := x2;
    AsFloat['EXTENSION_y2'] := y2;
  End;
  SetModifiedStatus( FLayer );
End;

Function TEzIBLayerInfo.GetIDCounter: integer;
Begin
  result := 0;
End;

Procedure TEzIBLayerInfo.SetIDCounter( Value: integer );
Begin
  // nothing to do here
End;

Function TEzIBLayerInfo.GetIsAnimationLayer: Boolean;
Begin
  Result:= False;
End;

Procedure TEzIBLayerInfo.SetIsAnimationLayer( Value: Boolean );
Begin
  // nothing to do here
End;

Function TEzIBLayerInfo.GetIsIndexed: Boolean;
Begin
  Result:= true;
End;

Procedure TEzIBLayerInfo.SetIsIndexed( Value: Boolean );
Begin
  // nothing to do here
End;

Function TEzIBLayerInfo.GetCoordsUnits: TEzCoordsUnits;
Begin
  With TEzIBLayer( FLayer ), FClientData Do
  Begin
    If Not coordsunits_init Then
    Begin
      coordsunits := TEzCoordsUnits( FIBField.AsInteger['COORDSUNITS'] );
      coordsunits_init := true;
    End;
    result := coordsunits;
  End;
End;

Procedure TEzIBLayerInfo.SetCoordsUnits( Value: TEzCoordsUnits );
Begin
  With TEzIBLayer( FLayer ) Do
  Begin
    FClientData.coordsunits := value;
    FClientData.coordsunits_init := true;
    FIBField.AsInteger['COORDSUNITS'] := Ord( Value );
  End;
  SetModifiedStatus( FLayer );
End;

Function TEzIBLayerInfo.GetCoordSystem: TEzCoordSystem;
Begin
  With TEzIBLayer( FLayer ), FClientData Do
  Begin
    If Not coordsystem_init Then
    Begin
      coordsystem := TEzCoordSystem( FIBField.AsInteger['COORDSYSTEM'] );
      coordsystem_init := true;
    End;
    result := coordsystem;
  End;
End;

Procedure TEzIBLayerInfo.SetCoordSystem( Value: TEzCoordSystem );
Begin
  With TEzIBLayer( FLayer ) Do
  Begin
    FClientData.coordsystem := value;
    FClientData.coordsystem_init := true;
    FIBField.AsInteger['COORDSYSTEM'] := Ord( Value );
    If Value = csLatLon Then
    Begin
      CoordMultiplier := DEG_MULTIPLIER;
      FIBField.AsInteger['COORDSUNITS'] := Ord( cuDeg );
    End
    Else
      CoordMultiplier := 1;
  End;
  SetModifiedStatus( FLayer );
End;

Function TEzIBLayerInfo.GetUseAttachedDB: Boolean;
Begin
  result := True;
End;

Procedure TEzIBLayerInfo.SetUseAttachedDB( Value: Boolean );
Begin
  // nothing to do here
End;

Function TEzIBLayerInfo.GetOverlappedTextAction: TEzOverlappedTextAction;
Begin
  With TEzIBLayer( FLayer ), FClientData Do
  Begin
    If Not overlappedtextaction_init Then
    Begin
      overlappedtextaction := TEzOverlappedtextaction( FIBField.AsInteger['OVERLAPPED_TEXT_ACTION'] );
      overlappedtextaction_init := true;
    End;
    result := overlappedtextaction;
  End;
End;

Procedure TEzIBLayerInfo.SetOverlappedTextAction( Value: TEzOverlappedTextAction );
Begin
  With TEzIBLayer( FLayer ) Do
  Begin
    FClientData.overlappedtextaction := value;
    FClientData.overlappedtextaction_init := True;
    FIBField.AsInteger['OVERLAPPED_TEXT_ACTION'] := Ord( value );
  End;
  SetModifiedStatus( FLayer );
End;

Function TEzIBLayerInfo.GetOverlappedTextColor: TColor;
Begin
  With TEzIBLayer( FLayer ), FClientData Do
  Begin
    If Not overlappedtextcolor_init Then
    Begin
      overlappedtextcolor := TColor( FIBField.AsInteger['OVERLAPPED_TEXT_COLOR'] );
      overlappedtextcolor_init := true;
    End;
    result := overlappedtextcolor;
  End;
End;

Procedure TEzIBLayerInfo.SetOverlappedTextColor( Value: TColor );
Begin
  With TEzIBLayer( FLayer ) Do
  Begin
    FClientData.overlappedtextcolor := value;
    FClientData.overlappedtextcolor_init := true;
    FIBField.AsInteger['OVERLAPPED_TEXT_COLOR'] := value;
  End;
  SetModifiedStatus( FLayer );
End;

Function TEzIBLayerInfo.GetTextFixedSize: Byte;
Begin
  With TEzIBLayer( FLayer ), FClientData Do
  Begin
    If Not textfixedsize_init Then
    Begin
      textfixedsize := FIBField.AsInteger['TEXT_FIXED_SIZE'];
      textfixedsize_init := true;
    End;
    result := textfixedsize;
  End;
End;

Procedure TEzIBLayerInfo.SetTextFixedSize( Value: Byte );
Begin
  With TEzIBLayer( FLayer ) Do
  Begin
    FClientData.textfixedsize := value;
    FClientData.textfixedsize_init := true;
    FIBField.AsInteger['TEXT_FIXED_SIZE'] := value;
  End;
  SetModifiedStatus( FLayer );
End;

Function TEzIBLayerInfo.GetTextHasShadow: Boolean;
Begin
  With TEzIBLayer( FLayer ), FClientData Do
  Begin
    TextHasShadow := FIBField.AsBoolean['TEXT_HAS_SHADOW'];
    TextHasShadow_init := True;
    result := TextHasShadow;
  End;
End;

Procedure TEzIBLayerInfo.SetTextHasShadow( value: Boolean );
Begin
  With TEzIBLayer( FLayer ) Do
  Begin
    FIBField.AsBoolean['TEXT_HAS_SHADOW'] := value;
    FClientData.TextHasShadow := value;
    FClientData.TextHasShadow_init := true;
  End;
  SetModifiedStatus( FLayer );
End;

{$IFDEF BCB}
function TEzIBLayerInfo.GetClientData: TEzIBLayerClientData;
begin
  Result := FClientData;
end;
{$ENDIF}


{-------------------------------------------------------------------------------}
{                  TEzIBLayer - class implementation                                }
{-------------------------------------------------------------------------------}

Constructor TEzIBLayer.Create( Layers: TEzBaseLayers; Const AFileName: String );
Begin
  Inherited Create( Layers, AFileName );
  FDBTable:= TEzIBTable.Create( Layers.Gis, '', true, true);
  TEzIBTable(FDBTable).FLayer:= Self;

  FLayerInfo := TEzIBLayerInfo.Create( Self );
  { in this case, FileName = Name because it is a table on the Interbase Server database }
  Self.FileName := AFileName;
  Self.Name := AFileName;

  CoordMultiplier := 1;
  FUpdateRtree := true;
End;

Destructor TEzIBLayer.Destroy;
Begin
  Close;
  If FIBHeader <> Nil Then FreeAndNil( FIBHeader );
  If FIBEntities <> Nil Then FreeAndNil( FIBEntities );
  If FIBField <> Nil Then FreeAndNil( FIBField );
  FreeAndNil( FDBTable );
  Inherited Destroy;
End;

Procedure TEzIBLayer.InitializeOnCreate( Const FileName: String;
                                          AttachedDB, IsAnimation: Boolean;
                                          CoordSystem: TEzCoordSystem;
                                          CoordsUnits: TEzCoordsUnits;
                                          FieldList: TStrings );
Begin
  Modified := True;
End;

Function TEzIBLayer.IsClientServer: Boolean;
Begin
  result := True;
End;

Procedure TEzIBLayer.StartBatchInsert;
Begin
  if FBatchUpdate = true then exit;
  FBatchUpdate:= true;
  //IBStartTrans( FIBEntities );
End;

Procedure TEzIBLayer.CancelBatchInsert;
Begin
  if FBatchUpdate = false then exit;
  FBatchUpdate := false;
  //IBRollbackTrans( FIBEntities );
End;

Procedure TEzIBLayer.FinishBatchInsert;
Begin
  if FBatchUpdate = false then exit;
  FBatchUpdate := false;
  //IBCommitTrans( FIBEntities );
  RebuildTree;
  UpdateMapExtension(QuickUpdateExtension);
End;

Function TEzIBLayer.DataSet: TIBSQL;
Begin
  Result:= FIBEntities;
End;

Function TEzIBLayer.DefineScope( Const Scope: String ): Boolean;
Begin
  { It is assumed that the expression is passed onto directly to SQL server WHERE clause}
  With FIBEntities Do
  Begin
    Close;
    if TEzIBGis(Layers.Gis).FQueryBasicFields then
      SQL.Text := 'SELECT uid,deleted,shapetype,xmin,ymin,xmax,ymax,geometry FROM ENT_%s WHERE ' + Scope
    else
      SQL.Text := 'SELECT * FROM ENT_%s WHERE ' + Scope;
    IBStartTrans( FIBEntities );
    ExecQuery;
  End;
  result := True;
End;

function TEzIBLayer.GetBookmark: Pointer;
begin
  // nothing to do here
end;

procedure TEzIBLayer.GotoBookmark(Bookmark: Pointer);
begin
  // nothing to do here
end;

procedure TEzIBLayer.FreeBookmark(Bookmark: Pointer);
begin
  // nothing to do here
end;

Function TEzIBLayer.DefinePolygonScope( Polygon: TEzEntity; Const Scope: String;
  Operator: TEzGraphicOperator ): Boolean;
Var
  searchType: TSearchType;
Begin
  Case Operator Of
    goWithin, goContains, goIntersects:
      searchType := stOverlap;
    goEntirelyWithin, goContainsEntire:
      searchType := stEnclosure;
  Else
    searchType := stOverlap;
  End;
  SetGraphicFilter( searchType, Polygon.FBox );
  result := true;
End;

Procedure TEzIBLayer.Zap;
Begin
  // nothing to do here
End;

Procedure TEzIBLayer.GetFieldList( Strings: TStrings );
var
  I: Integer;
Begin
  for I:= 1 to DBTable.FieldCount do
    Strings.Add( Format('%s;%s;%d;%d', [DBTable.Field(I), DBTable.FieldType(I),
      DBTable.FieldLen(I), DBTable.FieldDec(I)]) );
End;

Function TEzIBLayer.GetDBTable: TEzBaseTable;
Begin
  result := FDBTable;
End;

Function TEzIBLayer.GetRecno: Integer;
Begin
  result := 0;
  if FIBEntities.Eof then Exit;
  result := FIBEntities.FieldByName( 'uid' ).AsInteger;
End;

Procedure TEzIBLayer.SetRecno( Value: Integer );
Begin
  //if GetRecno = Value then Exit;
  With FIBEntities Do
  Begin
    Close;
    SQL.Text := Format( 'SELECT * FROM ent_%s WHERE uid = %d', [self.Name, Value] );
    IBStartTrans( FIBEntities );
    ExecQuery;
  End;
End;

Procedure TEzIBLayer.SetGraphicFilter( s: TSearchType; Const VisualWindow: TEzRect );
Var
  treeBBox, viewBBox: TRect_rt;
  I, LenBasesql: Integer;
  st, Basesql, StrNum: string;
  rl: TIntegerList;
Begin
  treeBBox := Frt.RootExtent;
  viewBBox := FloatRect2Rect( VisualWindow );

  If Contains_rect( viewBBox, treeBBox ) Then
  Begin
    // return all the records
    With FIBEntities Do
    Begin
      Close;
      if TEzIBGis(Layers.Gis).FQueryBasicFields then
        SQL.Text :=
          Format( 'SELECT uid, deleted, shapetype, xmin, ymin, xmax, ymax, ' +
                  ' geometry FROM ENT_%s', [Self.Name] )
      else
        SQL.Text := Format( 'SELECT * FROM ENT_%s', [Self.Name] );
      IBStartTrans( FIBEntities );
      ExecQuery;
    End;
  End
  Else
  Begin
    with FIBEntities do
    begin
      Close;
      GotoFirstRecordOnExecute:=true;
      SQL.Text :=
        Format( 'SELECT uid FROM search_%s( %d, %d, %d, %d );',
        [ Self.Name, viewBBox.x1, viewBBox.y1, viewBBox.x2, viewBBox.y2 ] );
      IBStartTrans( FIBEntities );
      ExecQuery;
      rl:= TIntegerList.Create;
      try
        while not Eof do
        begin
          rl.Add( Fields[0].AsInteger );
          Next;
        end;
        IBCommitTrans( FIBEntities );
        Close;
        if rl.count > 0 then
        begin
          if rl.Count < MAX_RECORDS_SQL_IN_CLAUSE then
          begin
            if TEzIBGis(Layers.Gis).FQueryBasicFields then
              BaseSQL:= Format('SELECT uid,deleted,shapetype,xmin,ymin,xmax,ymax,geometry ' +
                               ' FROM ENT_%s WHERE uid IN (', [Self.Name])
            else
              BaseSQL:= Format('SELECT * FROM ENT_%s WHERE uid IN (', [Self.Name]);
            LenBasesql := Length(Basesql);
            SetLength( st, LenBasesql + rl.Count * 8 + 1 );
            FillChar(st[1], Length(st), #32);
            LeftSet( st, Basesql, 1, Length(Basesql) );
            for I:= 0 to rl.Count - 1 do
            begin
              if I < rl.Count - 1 then
                StrNum := IntToStr( rl[I] ) + ','
              else
                StrNum := IntToStr( rl[I] );
              LeftSet( st, StrNum, LenBasesql + 1 + I * 8, 8 );
            end;
            st[Length(st)] := ')';
            IBStartTrans( FIBEntities );
            SQL.Text:= st;
            ExecQuery;
          end else
          begin
            Close;
            if TEzIBGis(Layers.Gis).FQueryBasicFields then
            begin
              SQL.Text :=
                {Format('SELECT e.uid,e.deleted,e.shapetype,e.xmin,e.ymin,e.xmax,e.ymax,e.geometry FROM search_%s( %d, %d, %d, %d ) s ' +
                       'INNER JOIN ent_%s e ON ( s.uid = e.uid ) ; ',
                       [ Self.Name, viewBBox.x1, viewBBox.y1, viewBBox.x2, viewBBox.y2, Self.Name ] ); }
                Format('SELECT e.uid, e.deleted, e.shapetype, e.xmin, e.ymin, e.xmax, ' +
                       ' e.ymax, e.geometry FROM ent_%s e INNER JOIN search_%s( %d, %d, %d, %d ) s ' +
                       ' ON ( e.uid = s.uid ) ;',
                       [Self.Name, Self.Name, viewBBox.x1, viewBBox.y1, viewBBox.x2, viewBBox.y2]);
            end else
            begin
              SQL.Text :=
                Format('SELECT e.* FROM ent_%s e ' +
                       'INNER JOIN search_%s( %d, %d, %d, %d ) s ON ( e.uid = s.uid ) ; ',
                  [Self.Name, viewBBox.x1, viewBBox.y1, viewBBox.x2, viewBBox.y2, Self.Name]);
            end;
            IBStartTrans( FIBEntities );
            ExecQuery;
          end;
        end;
      finally
        rl.free;
      end;
    end;
  End;
  FFiltered := FIBEntities.Open and Not FIBEntities.Eof;
End;

Procedure TEzIBLayer.CancelFilter;
Begin
  IBCommitTrans(FIBEntities);
  FIBEntities.Close;
  FFiltered := False;
End;

Function TEzIBLayer.Eof: Boolean;
Begin
  result := FIBEntities.Eof;
  If result Then FFiltered := FALSE;
End;

Procedure TEzIBLayer.First;
Begin
  If Not FFiltered Then
  Begin
    // return all the records
    With FIBEntities Do
    Begin
      Close;
      GotoFirstRecordOnExecute:=true;
      if TEzIBGis( Layers.Gis ).QueryBasicFields then
        SQL.Text :=
          Format( 'SELECT uid,deleted,shapetype,xmin,ymin,xmax,ymax,geometry FROM ENT_%s',
                  [Self.Name] )
      else
        SQL.Text := Format( 'SELECT * FROM ENT_%s', [Self.Name] );
      IBStartTrans( FIBEntities );
      ExecQuery;
    End;
    FFiltered := TRUE;
  End;
End;

Procedure TEzIBLayer.Next;
Begin
  If FIBEntities.Eof Then
  Begin
    IBCommitTrans( FIBEntities );
    FFiltered := FALSE;
    Exit;
  End;
  FIBEntities.Next;
  If FIBEntities.Eof Then
  begin
    FFiltered := FALSE;
    IBCommitTrans( FIBEntities );
  end;
End;

Procedure TEzIBLayer.Last;
Begin
  // not possible with TIBSQL
End;

Procedure TEzIBLayer.StartBuffering;
Begin
End;

Procedure TEzIBLayer.EndBuffering;
Begin
  IBCommitTrans(FIBEntities);
End;

Procedure TEzIBLayer.Assign( Source: TEzBaseLayer );
Begin
  If Not ( Source Is TEzIBLayer ) Then Exit;
  // pendiente de implementar
  {With FIBHeader Do
  Begin
    Close;
    SQL.Text := 'SELECT * FROM LAYINFO_' + Self.Name;
    IBStartTrans( FIBHeader );
    ExecQuery;
  End;
  With TEzIBLayer( Source ).FIBHeader Do
  Begin
    close;
    SQL.Text := 'SELECT * FROM LAYINFO_' + Source.Name;
    IBStartTrans( TEzIBLayer( Source ).FIBHeader );
    ExecQuery;
  End;
  With FIBHeader Do
  Begin
    For I := 0 To Fields.Count - 1 Do
    Begin
      If ( AnsiCompareText( Fields[I].FieldName, 'LASTUID' ) = 0 ) Or
        ( AnsiCompareText( Fields[I].FieldName, 'COORDSUNITS' ) = 0 ) Or
        ( AnsiCompareText( Fields[I].FieldName, 'rootnode' ) = 0 ) Or
        ( AnsiCompareText( Fields[I].FieldName, 'depth' ) = 0 ) Or
        ( AnsiCompareText( Fields[I].FieldName, 'treetype' ) = 0 ) Or
        ( AnsiCompareText( Fields[I].FieldName, 'multiplier' ) = 0 ) Or
        ( AnsiCompareText( Fields[I].FieldName, 'BucketSize' ) = 0 ) Or
        ( AnsiCompareText( Fields[I].FieldName, 'LowerBound' ) = 0 ) Then
        Continue;
      Fields[I].AsString := TEzIBLayer( Source ).FIBHeader.Fields[I].AsString;
    End;
  End;
  FIBHeader.Close;
  TEzIBLayer( Source ).FIBHeader.Close; }
End;

function TEzIBLayer.GetExtensionForRecords( List: TIntegerList ): TEzRect;
var
  I, LenBasesql: Integer;
  s, Basesql, StrNum: string;
begin
  Result:= INVALID_EXTENSION;
  if (List=nil) or (List.Count=0) then Exit;
  if List.Count < MAX_RECORDS_SQL_IN_CLAUSE then
  begin
    Basesql:=
      Format('SELECT MIN(xmin), MIN(ymin), MAX(xmax), MAX(ymax) FROM ent_%s WHERE uid IN (',
             [Self.Name] );
    // 9999999
    // 8=size of integer in a string format plus comma
    LenBasesql := Length(Basesql);
    SetLength( s, LenBasesql + List.Count * 8 + 1 );
    FillChar(s[1], Length(s), #32);
    LeftSet( s, Basesql, 1, Length(Basesql) );
    for I:= 0 to List.Count - 1 do
    begin
      if I < List.Count - 1 then
        StrNum := IntToStr( List[I] ) + ','
      else
        StrNum := IntToStr( List[I] );
      LeftSet( s, StrNum, LenBasesql + 1 + I * 8, 8 );
    end;
    s[Length(s)] := ')';
    with FIBHeader do
    begin
      Close;
      SQL.Text := s ;
      IBStartTrans( FIBHeader );
      ExecQuery;
    end;
  end else
  begin
    { we need to create a temporary table for that purposes }
    with FIBHeader do
    begin
      Close;
      SQL.Text := 'DELETE FROM temp_records;' ;
      IBStartTrans( FIBHeader );
      ExecQuery;
      IBCommitTrans( FIBHeader );

      Close;
      { now add all the required records to this table }
      for I:= 0 to List.Count-1 do
      begin
        Close;
        SQL.Text := Format('INSERT INTO temp_records VALUES (%d) ;', [List[I]]);
        IBStartTrans( FIBHeader );
        ExecQuery;
        IBCommitTrans( FIBHeader );
      end;
      { now return the result }
      Close;
      SQL.Text :=
        Format( 'SELECT MIN(xmin),MIN(ymin),MAX(xmax),MAX(ymax) FROM ent_%s WHERE uid IN (SELECT uid FROM temp_records);', [Self.Name] );
      IBStartTrans( FIBHeader );
      ExecQuery;
    end;
  end;
  with FIBHeader do
  begin
    { store the result}
    Result.Emin.X:= Fields[0].AsDouble;
    Result.Emin.Y:= Fields[1].AsDouble;
    Result.Emax.X:= Fields[2].AsDouble;
    Result.Emax.Y:= Fields[3].AsDouble;
  end;
  IBCommitTrans( FIBHeader );

end;

Procedure TEzIBLayer.BuildRTreeInMemory(var rt: TRTree);
Var
  I, RecCount: Integer;
  Gis: TEzIBGis;
  Extents: TEzRect;
begin
  Gis := TEzIBGis( Layers.GIS );
  //RecCount := Self.RecordCount;

  { A memory r-tree used for fast speed }
  if rt <> Nil then FreeAndNil( rt );
  rt := TMemRTree.Create( Self, RTYPE, 0 );
  // Create the index
  rt.CreateIndex( '', CoordMultiplier );

  RecCount := Self.RecordCount;

  With FIBEntities Do
  Begin
    Close;
    GotoFirstRecordOnExecute:= true;
    SQL.Text :=
      Format( 'SELECT uid,shapetype,xmin,ymin,xmax,ymax FROM ENT_%s WHERE deleted = ''N''',
              [Self.Name] );
    IBStartTrans( FIBHeader );
    ExecQuery;
  End;
  Try
    // Create the index
    I := 0;
    If RecCount > 0 Then
      Gis.StartProgress( Format( SRebuildTree, [Name] ), 1, RecCount );
    While Not FIBEntities.Eof Do
    Begin
      Inc( I );
      Gis.UpdateProgress( I );
      With Extents, FIBEntities Do
      Begin
        x1 := FieldByName( 'xmin' ).AsDouble;
        y1 := FieldByName( 'ymin' ).AsDouble;
        x2 := FieldByName( 'xmax' ).AsDouble;
        y2 := FieldByName( 'ymax' ).AsDouble;

        If Not EqualRect2D( Extents, INVALID_EXTENSION ) Then
          rt.Insert( FloatRect2Rect( Extents ), FieldByName( 'uid' ).AsInteger );
      End;
      FIBEntities.Next;
    End;
    If RecCount > 0 Then
      Gis.EndProgress;
  Finally
    IBCommitTrans( FIBEntities );
    FIBEntities.Close;
  End;
end;

Procedure TEzIBLayer.RebuildTree;
Var
  Gis: TEzIBGis;
  IdxInfo: TRTCatalog;
  dp: PDiskPage;
  s,yn: String;
  I: Integer;
  Mode: Word;
Begin
  Gis := TEzIBGis( Layers.GIS );
  If Gis.ReadOnly Then Exit;
  If Not FIsOpen Then Exit;

  Mode := Gis.OpenMode;

  If Self.Frt <> Nil Then
    FreeAndNil( self.Frt );

  BuildRTreeInMemory( Frt );

  { update the header }
  Frt.ReadCatalog( IdxInfo );
  With FIBField Do
  Begin
    AsInteger['rootnode'] := IdxInfo.RootNode; //**(IdxInfo.RootNode div sizEof(TDiskPage)) + 1;
    AsInteger['depth'] := IdxInfo.Depth;
    AsInteger['multiplier'] := IdxInfo.Multiplier;
    AsInteger['BucketSize'] := BUCKETSIZE;
    AsInteger['LowerBound'] := LOWERBOUND;
  End;
  { now recreate the RTX_xxx file }
  If TableExists( 'rtx_' + Self.Name, FIBHeader ) Then
  Begin
    With FIBHeader Do
    Begin

      { delete all records }
      Close;
      SQL.Text := Format( 'DELETE FROM rtx_%s ;', [Self.Name] );
      IBStartTrans( FIBHeader );
      ExecQuery;
      IBCommitTrans( FIBHeader );

      {initialize the generator }
      Close;
      SQL.Text := Format( 'SET GENERATOR gen_rtx_%s TO 0;', [Self.Name] );
      IBStartTrans( FIBHeader );
      ExecQuery;
      IBCommitTrans( FIBHeader );
      Close;

      { now insert all the nodes
        Note: We assume here that the pageid will be created consecutively
        starting from 1 }
      For I := 0 To TMemRTree( Frt ).PageCount - 1 Do
      Begin
        dp := TMemRTree( Frt ).DiskPagePtr[I];
        SetDataToString( dp^, s );

        With FIBHeader do
        Begin
          Close;
          if dp.Leaf then yn:= 'Y' else yn:= 'N';
          SQL.Text:= Format( 'SELECT oid FROM addnode_%s ( %d, %d, ''%s'', ''%s'' ) ;',
            [Self.Name, dp^.Parent, dp^.FullEntries, yn, s ] );
          IBStartTrans( FIBHeader );
          ExecQuery;
          IBCommitTrans( FIBHeader );
        End;
      End;
    End;
  End;

  Frt := TIBRTree.Create( Self, RTYPE, Mode );
  Frt.Open( Self.FileName, Mode );

  WriteHeaders( true );
End;

Procedure TEzIBLayer.Open;
Var
  Gis: TEzIBGis;
  Mode: Word;
Begin

  Close;
  If ( ( FIBHeader = Nil ) Or
     Not ( FIBField.AsBoolean['VISIBLE'] ) ) And ( Frt <> Nil ) Then
     Frt.Close;

  Gis := Layers.GIS as TEzIBGis;
  Mode := Gis.OpenMode;

  If FIBHeader = Nil Then
  begin
    if Assigned(TEzIBGis( Gis ).FOnCreateIBSQL) then
    begin
      TEzIBGis( Gis ).FOnCreateIBSQL( Gis, FIBHeader );
    end;
  end;

  If FIBEntities = Nil Then
  begin
    if assigned(TEzIBGis( Gis ).FOnCreateIBSQL) then
    begin
      TEzIBGis( Gis ).FOnCreateIBSQL( Gis, FIBEntities );
    end;
  end;
  If ( FIBHeader = Nil ) Or ( FIBEntities = Nil ) Then Exit;

  TEzIBTable(FDBTable).FLayer:= Self;

  If FIBField <> Nil Then
    FreeAndNil( FIBField );
  FIBField := TEzIBField.Create( 'LAYINFO_' + Self.Name, FIBHeader );

  { check for minimum layer files needed }
  If Not TableExists( 'LAYINFO_' + Self.Name, FIBHeader ) Then
    Raise Exception.CreateFmt( STableNotFound, ['LAYINFO_' + self.Name] );
  If Not TableExists( 'ENT_' + Self.Name, FIBHeader ) Then
    Raise Exception.CreateFmt( STableNotFound, ['ENT_' + self.Name] );
  { rebuild the r-tree if was deleted }
  If Not TableExists( 'RTX_' + Self.Name, FIBHeader ) Then
    RebuildTree;

  If Gis.MapInfo.CoordsUnits = cuDeg Then
    CoordMultiplier := DEG_MULTIPLIER
  Else
    CoordMultiplier := 1;

  FIsOpen := true;

  { re-create the stored procedures if were deleted }
  CreateLayerElements( Self.Name, FIBHeader );

  Frt := TIBRTree.Create( Self, RTYPE, Mode );
  Frt.Open( self.FileName, Mode );

End;

Procedure TEzIBLayer.Close;
Begin
  If FIBHeader <> Nil Then FIBHeader.Close;
  If FIBEntities <> Nil Then FIBEntities.Close;
  If Frt <> Nil Then FreeAndNil( Frt );
  Modified := false;
  FIsOpen := false;
End;

Procedure TEzIBLayer.ForceOpened;
Begin
  If Not FIsOpen Then Open;
End;

Procedure TEzIBLayer.WriteHeaders( FlushFiles: Boolean );
Begin
  // nothing to do here but this
  Modified := False;
End;

Procedure TEzIBLayer.UpdateMapExtension( Const R: TEzRect );
Var
  MapExt: TEzRect;
Begin
  { new map extension }
  If ( Layers = Nil ) Or ( Layers.GIS = Nil ) Then Exit;
  With Layers.GIS Do
  Begin
    MapExt := MapInfo.Extension;
    MaxBound( MapExt.Emax, R.Emax );
    MinBound( MapExt.Emin, R.Emin );
    MapInfo.Extension := MapExt;
    Modified := true;
  End;
End;

// this function will return the UID of the added entity

Function TEzIBLayer.AddEntity( Entity: TEzEntity ): Integer;
Var
  Extents, LayExtents: TEzRect;
  TmpID: TEzEntityID;
  NewRecno: Integer;
  stream: TMemoryStream;
Begin
  result := 0;
  ForceOpened;
  If Layers.GIS.ReadOnly Or Not FIsOpen Then Exit;

  NormalizePolygon( Entity );

  TmpID := Entity.EntityID;

  FIBEntities.Close;

  Extents := Entity.FBox;
  with FIBEntities do
  begin
    Close;
    TEzIBGis(Layers.Gis).SaveWindowsSeparators;
    SQL.Text:= Format( 'SELECT newuid FROM addentity_%s ( %.6f, %.6f, %.6f, %.6f, %d ) ;',
      [Self.Name, Extents.X1, Extents.Y1, Extents.X2, Extents.Y2, Ord(TmpID)] );
    TEzIBGis(Layers.Gis).RestoreWindowsSeparators;
    IBStartTrans( FIBEntities );
    ExecQuery;
    NewRecno := Fields[0].AsInteger;
    IBCommitTrans( FIBEntities );
    Close;
    { now add the blob data }
    SQL.Text:= Format( 'UPDATE ent_%s SET geometry = :geometry WHERE uid = %d ;',
      [Self.Name, NewRecno] );
    IBStartTrans( FIBEntities );
    stream:= TMemoryStream.Create;
    try
      Entity.SaveToStream( stream );
      stream.Position:= 0;
      ParamByname('geometry').LoadFromStream( stream );
    finally
      stream.free;
    end;
    ExecQuery;
    IBCommitTrans( FIBEntities );
    Close;
  end;

  // add to the r-tree
  result := NewRecno;
  if not FBatchUpdate then
  begin
    { calculate the extension for the header }
    With FIBField Do
    Begin
      With LayExtents Do
      Begin
        x1 := AsFloat['EXTENSION_x1'];
        y1 := AsFloat['EXTENSION_y1'];
        x2 := AsFloat['EXTENSION_x2'];
        y2 := AsFloat['EXTENSION_y2'];
      End;
      MaxBound( LayExtents.Emax, Extents.Emax );
      MinBound( LayExtents.Emin, Extents.Emin );
      With LayExtents Do
      Begin
        AsFloat['EXTENSION_x1'] := x1;
        AsFloat['EXTENSION_y1'] := y1;
        AsFloat['EXTENSION_x2'] := x2;
        AsFloat['EXTENSION_y2'] := y2;
      End;
    End;
    If TmpID <> idNone Then
    begin
      Frt.Insert( FloatRect2Rect( Extents ), NewRecno );
    end;
    UpdateMapExtension( Extents );
  End;

  TEzIBLayerInfo(FLayerInfo).FClientData.RecCount_init:= false;
End;

Procedure TEzIBLayer.UndeleteEntity( RecNo: Integer );
var
  ShapeType: TEzEntityID;
  Extents: TEzRect;
  N: Integer;
Begin
  N:= RecNo;
  { check if it is deleted }
  With FIBHeader Do
  Begin
    Close;
    SQL.Text :=
      Format( 'SELECT shapetype,xmin,ymin,xmax,ymax FROM ent_%s ' +
              ' WHERE uid = %d and deleted = ''Y'' ; ', [Self.Name, N] );
    IBStartTrans( FIBHeader );
    ExecQuery;
    if Eof then
    begin
      IBCommitTrans( FIBHeader );
      Exit;
    end;
    ShapeType:= TEzEntityID( FieldByName('shapetype').AsInteger );
    Extents.Emin.X:= FieldByName('xmin').AsDouble;
    Extents.Emin.Y:= FieldByName('ymin').AsDouble;
    Extents.Emax.X:= FieldByName('xmax').AsDouble;
    Extents.Emax.Y:= FieldByName('ymax').AsDouble;
    IBCommitTrans( FIBHeader );
    Close;
    // undeleted
    SQL.Text := Format( 'UPDATE ent_%s SET deleted = ''N'' WHERE uid = %d ;', [Self.Name, N] );
    IBStartTrans( FIBHeader );
    ExecQuery;
    IBCommitTrans( FIBHeader );
  End;
  { now update the r-tree }
  If ( ShapeType <> idNone ) And ( Frt <> nil ) Then
  begin
    Frt.Insert( FloatRect2Rect( Extents ), Recno );
  end;
  TEzIBLayerInfo(FLayerInfo).FClientData.RecCount_init:= false;
End;

Procedure TEzIBLayer.DeleteEntity( RecNo: Integer );
Var
  Extents: TEzRect;
  N: Integer;
Begin
  If Layers.GIS.ReadOnly Or Not FIsOpen Then Exit;
  { retrieve the record extension for r-tree update }
  N := Recno;
  With FIBHeader Do
  Begin
    Close;
    SQL.Text :=
      Format( 'SELECT shapetype,xmin,ymin,xmax,ymax FROM ent_%s ' +
              ' WHERE (uid = %d ) and (deleted = ''N'') ; ', [Self.Name, N] );
    IBStartTrans( FIBHeader );
    ExecQuery;
    if Eof then
    begin
      IBCommitTrans( FIBHeader );
      Exit;
    end;
    Extents.X1 := FieldByName( 'XMIN' ).AsDouble;
    Extents.Y1 := FieldByName( 'YMIN' ).AsDouble;
    Extents.X2 := FieldByName( 'XMAX' ).AsDouble;
    Extents.Y2 := FieldByName( 'YMAX' ).AsDouble;
    IBCommitTrans( FIBHeader );

    Close;
    SQL.Text :=
      Format( 'UPDATE ent_%s SET DELETED = ''Y'' WHERE uid = %d ;',
              [self.Name, N] );
    IBStartTrans( FIBHeader );
    ExecQuery;
    IBCommitTrans( FIBHeader );
    Close;
  End;
  // Delete from r-tree
  If Not EqualRect2D( Extents, INVALID_EXTENSION ) Then
  begin
    Frt.Delete( FloatRect2Rect( Extents ), N );
  end;
  TEzIBLayerInfo(FLayerInfo).FClientData.RecCount_init:= false;
  Modified := False;
End;

Function TEzIBLayer.InternalLoadEntity( IBSQL: TIBSQL ): TEzEntity;
Var
  TmpClass: TEzEntityClass;
  stream: TMemoryStream;
Begin
  TmpClass := GetClassFromID( TEzEntityID( IBSQL.FieldByName( 'shapetype' ).AsInteger ) );
  Result := TmpClass.Create( 1 );
  stream := TMemoryStream.create;
  Try
    IBSQL.FieldByName( 'geometry' ).SaveToStream( stream );
{$IFDEF COMPRESSED_ENTITY}
    DeCompressMemStream(Stream);
{$ENDIF}
    Stream.Position := 0;
    Result.LoadFromStream( stream );
  Finally
    stream.free;
  End;
End;

Function TEzIBLayer.QuickUpdateExtension: TEzRect;
Var
  Gis: TEzBaseGIS;
Begin
  Gis := Layers.GIS;
  If Gis.ReadOnly Then Exit;
  ForceOpened;
  Result := INVALID_EXTENSION;
  With FIBEntities Do
  Begin
    Close;
    SQL.Text := Format( 'SELECT MIN(xmin),MIN(ymin),MAX(xmax),MAX(ymax) FROM ent_%s WHERE deleted <> ''Y'' and shapetype <> 0 ', [Self.Name] );
    IBStartTrans( FIBHeader );
    ExecQuery;
    Result.X1 := Fields[0].AsDouble;
    Result.Y1 := Fields[1].AsDouble;
    Result.X2 := Fields[2].AsDouble;
    Result.Y2 := Fields[3].AsDouble;
    IBCommitTrans( FIBHeader );
    Close;
  End;
  With FIBField Do
  Begin
    AsFloat['EXTENSION_x1'] := Result.X1;
    AsFloat['EXTENSION_y1'] := Result.Y1;
    AsFloat['EXTENSION_x2'] := Result.X2;
    AsFloat['EXTENSION_y2'] := Result.Y2;
  End;
  Modified := true;
End;

Function TEzIBLayer.UpdateExtension: TEzRect;
Var
  Entity: TEzEntity;
  Gis: TEzBaseGIS;
  Extents: TEzRect;
  TheUID: Integer;
Begin
  //QuickUpdateExtension;
  Gis := Layers.GIS;
  If Gis.ReadOnly Then Exit;

  ForceOpened;
  Result := INVALID_EXTENSION;
  Try
    With FIBEntities Do
    Begin
      Close;
      GotoFirstRecordOnExecute:=true;
      SQL.Text :=
        Format( 'SELECT uid,shapetype,geometry FROM ent_%s WHERE deleted = ''N'' and shapetype <> 0;',
                [self.Name] );
      IBStartTrans( FIBEntities );
      ExecQuery;
      While Not Eof Do
      Begin
        Entity := InternalLoadEntity( FIBEntities );
        Try
          Extents := Entity.FBox;
          FIBHeader.Close;
          TheUID:= FieldByName('uid').AsInteger;
          TEzIBGis(Layers.Gis).SaveWindowsSeparators;
          FIBHeader.SQL.Text:=
            Format( ' UPDATE ent_%s SET xmin = %.6f, ymin= %.6f, xmax = %.6f, ymax = %.6f ' +
                    ' WHERE uid = %d' ,
            [Self.Name, Extents.X1, Extents.Y1, Extents.X2, Extents.Y2, TheUID] );
          TEzIBGis(Layers.Gis).RestoreWindowsSeparators;
          IBStartTrans( FIBHeader );
          FIBHeader.ExecQuery;
          IBCommitTrans( FIBHeader );
          FIBHeader.Close;
          MaxBound( Result.Emax, Extents.Emax );
          MinBound( Result.Emin, Extents.Emin );
        Finally
          Entity.Free;
        End;
        Next;
      End;
      IBCommitTrans( FIBEntities );
    End;
    With FIBField Do
    Begin
      AsFloat['EXTENSION_x1'] := Result.X1;
      AsFloat['EXTENSION_y1'] := Result.Y1;
      AsFloat['EXTENSION_x2'] := Result.X2;
      AsFloat['EXTENSION_y2'] := Result.Y2;
    End;
    // rebuild the r-tree
    RebuildTree;
  Finally
    Modified := true;
  End;
End;

Function TEzIBLayer.LoadEntityWithRecNo( RecNo: Longint): TEzEntity;
Var
  n: Integer;
Begin
  { RecNo is base 1 }
  n := Recno;
  Result := Nil;
  With FIBHeader Do
  Begin
    Close;
    GotoFirstRecordOnExecute:=true;
    SQL.Text := Format( 'SELECT shapetype,geometry FROM ent_%s WHERE uid = %d', [Self.Name, n] );
    IBStartTrans( FIBHeader );
    ExecQuery;
    If Eof Then
    begin
      IBCommitTrans( FIBHeader );
      Exit;
    end;
    Result := InternalLoadEntity( FIBHeader );
    IBCommitTrans( FIBHeader );
    Close;
  End;
End;

Procedure TEzIBLayer.UpdateEntity( RecNo: Integer; Entity2D: TEzEntity );
Var
  I, N: Integer;
  Prev: TEzRect;
  GIS: TEzIBGis;
  Extents, LayerExtents: TEzRect;
  stream: TMemoryStream;
  DrawBox: TEzBaseDrawBox;
Begin
  Gis:= Layers.Gis as TEzIBGis;
  If Gis.ReadOnly Or Not FIsOpen Then Exit;

  NormalizePolygon( Entity2d );

  N := Recno;
  With FIBHeader Do
  Begin
    Close;
    GotoFirstRecordOnExecute:=true;
    SQL.Text :=
      Format( 'SELECT xmin,ymin,xmax,ymax,shapetype,geometry FROM ent_%s WHERE uid = %d', [Self.Name, N] );
    IBStartTrans( FIBHeader );
    ExecQuery;
    If Eof Then
    begin
      IBCommitTrans( FIBHeader );
      Close;
      Exit;
    end;
    Prev.X1 := FieldByName( 'XMIN' ).AsDouble;
    Prev.Y1 := FieldByName( 'YMIN' ).AsDouble;
    Prev.X2 := FieldByName( 'XMAX' ).AsDouble;
    Prev.Y2 := FieldByName( 'YMAX' ).AsDouble;
    IBCommitTrans( FIBHeader );
    Close;

    Entity2D.UpdateExtension;
    Extents := Entity2D.FBox;
    stream := TMemoryStream.Create;
    Try
      Entity2D.SaveToStream( stream );
      {$IFDEF COMPRESSED_ENTITY}
      CompressmemStream(Stream, 1);
      {$ENDIF}
      stream.Position:= 0;
      TEzIBGis(Layers.Gis).SaveWindowsSeparators;
      SQL.Text :=
        Format( ' UPDATE ent_%s SET xmin = %.6f, ymin = %.6f, xmax = %.6f, ymax = %.6f, ' +
                ' shapetype = %d, geometry = :geometry WHERE uid = %d',
                [ Self.Name, Extents.X1, Extents.Y1, Extents.X2, Extents.Y2,
                  Ord( Entity2D.EntityID ), N] );
      TEzIBGis(Layers.Gis).RestoreWindowsSeparators;
      IBStartTrans( FIBHeader );
      ParamByName( 'geometry').LoadFromStream( stream );
      ExecQuery;
      IBCommitTrans( FIBHeader );
    Finally
      stream.free;
      Close;
    End;
  End;

  // update the r-tree
  If ( Entity2D.EntityID <> idNone ) And Not EqualRect2D( Prev, Extents ) Then
  begin
    Frt.Update( FloatRect2Rect( Prev ), Recno, FloatRect2Rect( Extents ) );
  end;

  LayerExtents := LayerInfo.Extension;
  MaxBound( LayerExtents.Emax, Extents.Emax );
  MinBound( LayerExtents.Emin, Extents.Emin );
  LayerInfo.Extension := LayerExtents;

  TEzIBLayerInfo(FLayerInfo).FClientData.RecCount_init:= false;

  Modified := true;

  { new map extension }
  UpdateMapExtension( Extents );
  If Not ( ( Layers = Nil ) And ( Layers.GIS = Nil ) ) Then
  Begin
    For I := 0 To GIS.DrawBoxList.Count - 1 Do
    Begin
      DrawBox := GIS.DrawBoxList[i];
      If Assigned( DrawBox.OnEntityChanged ) Then
        DrawBox.OnEntityChanged( DrawBox, Self, Recno );
    End;
  End;

  { restore the status after updating }
  
End;

Procedure TEzIBLayer.Pack( ShowMessages: Boolean );
Begin
  With FIBHeader Do
  Begin
    { now delete the records }
    Close;
    SQL.Text := Format( 'DELETE FROM ent_%s WHERE deleted = ''Y''', [Self.Name] );
    IBStartTrans( FIBHeader );
    ExecQuery;
    IBCommitTrans( FIBHeader );
  End;
  RebuildTree;
End;

Function TEzIBLayer.RecExtension: TEzRect;
Begin
  result := INVALID_EXTENSION;
  If not FIBEntities.Open Or FIBEntities.Eof Then Exit;
  With FIBEntities Do
  Begin
    result.X1 := FieldByName( 'XMIN' ).AsDouble;
    result.Y1 := FieldByName( 'YMIN' ).AsDouble;
    result.X2 := FieldByName( 'XMAX' ).AsDouble;
    result.Y2 := FieldByName( 'YMAX' ).AsDouble;
  End;
End;

Function TEzIBLayer.RecLoadEntity: TEzEntity;
Begin
  result := Nil;
  If not FIBEntities.Open Or FIBEntities.Eof Then Exit;
  result := InternalLoadEntity( FIBEntities );
End;

Procedure TEzIBLayer.RecLoadEntity2( Entity: TEzEntity );
Var
  stream: TMemoryStream;
Begin
  If not FIBEntities.Open Or FIBEntities.Eof Then Exit;
  stream := TMemoryStream.Create;
  Try
    FIBEntities.FieldByName( 'GEOMETRY' ).SaveToStream( stream );
    {$IFDEF COMPRESSED_ENTITY}
    DeCompressMemStream(Stream);
    {$ENDIF}
    stream.Position := 0;
    Entity.LoadFromStream( stream );
  Finally
    stream.free;
  End;
End;

Function TEzIBLayer.RecEntityID: TEzEntityID;
Begin
  result := Low( TEzEntityID );
  If not FIBEntities.Open Or FIBEntities.Eof Then Exit;
  result := TEzEntityID( FIBEntities.FieldByName( 'shapetype' ).AsInteger );
End;

Function TEzIBLayer.RecIsDeleted: Boolean;
Begin
  Result:= false;
  If not FIBEntities.Open Or FIBEntities.Eof Then Exit;
  result := FIBEntities.FieldByName( 'deleted' ).AsString = 'Y';
End;

Procedure TEzIBLayer.CopyRecord( SourceRecno, DestRecno: Integer );
Begin
  // nothing to do here
End;

Function TEzIBLayer.ContainsDeleted: Boolean;
Begin
  With FIBHeader Do
  Begin
    { now delete the records }
    Close;
    GotoFirstRecordOnExecute:=true;
    SQL.Text := Format( 'SELECT COUNT(*) FROM ent_%s WHERE deleted = ''Y'' ;', [Self.Name] );
    IBStartTrans( FIBHeader );
    ExecQuery;
    Result:= Fields[0].AsInteger > 0;
    IBCommitTrans( FIBHeader );
    Close;
  End;
End;

Procedure TEzIBLayer.Recall;
Begin
  UndeleteEntity(Recno);
End;

Function TEzIBLayer.GetRecordCount: Integer;
Begin
  // in client/server not possible to get this in an effective and quick way
  if not TEzIBLayerInfo(FLayerInfo).FClientData.RecCount_init then
  begin
    With FIBHeader Do
    Begin
      Close;
      SQL.Text := Format( 'SELECT COUNT(*) FROM ent_%s WHERE deleted = ''N''', [self.Name] );
      IBStartTrans( FIBHeader );
      ExecQuery;
      TEzIBLayerInfo(FLayerInfo).FClientData.RecCount:= Fields[0].AsInteger;
      TEzIBLayerInfo(FLayerInfo).FClientData.RecCount_init:= true;
      IBCommitTrans( FIBHeader );
      Close;
    End;
  end;
  Result:= TEzIBLayerInfo(FLayerInfo).FClientData.RecCount;
End;

function TEzIBLayer.BringEntityToFront(ARecno: Integer): Integer;
begin
  // not yet implemented
end;

function TEzIBLayer.SendEntityToBack(ARecno: Integer): Integer;
begin
  // not yet implemented
end;

function TEzIBLayer.DeleteLayerFiles: Boolean;
begin
  // not yet implemented
  Result:= True;
end;

function TEzIBLayer.GetActive: Boolean;
begin
  Result:= FIsOpen
end;

procedure TEzIBLayer.SetActive(Value: Boolean);
begin
  if Value then Open else Close;
end;

procedure TEzIBLayer.Synchronize;
begin
  TEzIBTable(FDBTable).FCurrRecno:=GetRecno;
end;

{$IFDEF BCB}
function TEzIBLayer.GetIBEntities: TIBSQL;
begin
  Result := FIBEntities;
end;
{$ENDIF}

//----------------- TEzIBLayers - class implementation ----------------------

Function TEzIBLayers.IsClientServer: Boolean;
Begin
  result := true;
End;

Function TEzIBLayers.Add( Const FileName: String; LayerType: TEzLayerType ): Integer;
Var
  CanInsert: Boolean;
  Layer: TEzBaseLayer;
Begin
  Result := 0;
  CanInsert := true;
  If Assigned( GIS.OnBeforeInsertLayer ) Then
    GIS.OnBeforeInsertLayer( GIS, FileName, CanInsert );

  If Not CanInsert Then Exit;

  Layer := Gis.CreateLayer( FileName, LayerType );
  Result := Layer.Index;

  If Assigned( GIS.OnAfterInsertLayer ) Then
    GIS.OnAfterInsertLayer( GIS, FileName );

End;

Function AddLayerTo( GIS: TEzIBGis; Const FileName: String;
  CoordSystem: TEzCoordSystem; CoordsUnits: TEzCoordsUnits;
  FieldList: TStrings ): TEzBaseLayer;
Var
  i: Integer;
  layname, cmd, s: String;
  IBSQL: TIBSQL;
  p: integer;
  fs: String;
  ft: String;
  fl: integer;
  fd: integer;
  v: Boolean;
  Multiplier: integer;
  fldlst: TStrings;

  Procedure LoadField;
  Begin
    p := pos( ';', s );
    fs := '';
    If p > 0 Then
    Begin
      fs := system.copy( s, 1, pred( p ) );
      system.delete( s, 1, p );
    End
    Else
      v := false;

    p := pos( ';', s );
    ft := '';
    If p > 0 Then
    Begin
      Try
        ft := system.copy( s, 1, pred( p ) );
        system.delete( s, 1, p );
      Except
        On Exception Do
          v := false;
      End;
    End
    Else
      v := false;

    p := pos( ';', s );
    fl := 0;
    If p > 0 Then
    Begin
      Try
        fl := StrToInt( system.copy( s, 1, pred( p ) ) );
        system.delete( s, 1, p );
      Except
        On Exception Do
          v := false;
      End;
    End
    Else
      v := false;

    fd := 0;
    Try
      fd := StrToInt( system.copy( s, 1, 3 ) );
    Except
      On Exception Do
        v := false;
    End;
  End;

Begin
  If GIS.ReadOnly Or Not Assigned(Gis.FOnCreateIBSQL) Then Exit;
  If Length( Trim( FileName ) ) = 0 Then
    EzGISError( Format( SWronglayerName, [FileName] ) );
  { check if table exists}
  Gis.FOnCreateIBSQL( Gis, IBSQL );
  If IBSQL = Nil Then exit;
  layname := GetValidLayerName( ExtractFileName(ChangeFileExt(FileName,'')) );

  { check if the layer already exists }
  If TableExists( 'LAYINFO_' + layname, IBSQL ) Then
  begin
    IBSQL.free;
    EzGISError( SDuplicatelayer );
  end;
  Result := TEzIBLayer.Create( GIS.Layers, layname );
  fldlst := FieldList;
  // create the files
  Try
    Try

      With IBSQL Do
      Begin
        Close;
        { create the header }
        SQL.Text := Format( SQL_CREATELAYINFO1 + SQL_CREATELAYINFO2 +
          SQL_CREATELAYINFO3 + SQL_CREATELAYINFO4 + SQL_CREATELAYINFO5, [layname] );
        IBStartTrans( IBSQL );
        ExecQuery;
        IBCommitTrans( IBSQL );
        Close;

        { insert first record }
        If GIS.MapInfo.CoordsUnits = cuDeg Then
          Multiplier := DEG_MULTIPLIER
        Else
          Multiplier := 1;
        SQL.Text := Format( 'INSERT INTO layinfo_%s (' + crlf +
          'rootnode, depth, treetype, multiplier, bucketsize, lowerbound)', [layname] ) +
          Format( ' VALUES (1,0,0,%d,50,20)', [Multiplier] );
        IBStartTrans( IBSQL );
        ExecQuery;
        IBCommitTrans( IBSQL );

        { now create the entities file ENT_xxx }
        Close;
        cmd := Format( SQL_CREATEENT, [layname] );
        { add the fields required to this file }
        If ( fldlst <> Nil ) And ( fldlst.Count > 0 ) Then
        Begin
          cmd := cmd + 'GEOMETRY BLOB,';
          For i := 0 To fldlst.Count - 1 Do
          Begin
            s := fldlst.Strings[i];
            While ( length( s ) > 0 ) And ( s[length( s )] In [' ', ';'] ) Do
              system.Delete( s, length( s ), 1 );
            If s <> '' Then
              LoadField;
            If ( AnsiCompareText( fs, 'UID' ) = 0 ) Or
              ( AnsiCompareText( fs, 'DELETED' ) = 0 ) Or
              ( AnsiCompareText( fs, 'XMIN' ) = 0 ) Or
              ( AnsiCompareText( fs, 'YMIN' ) = 0 ) Or
              ( AnsiCompareText( fs, 'XMAX' ) = 0 ) Or
              ( AnsiCompareText( fs, 'YMAX' ) = 0 ) Or
              ( AnsiCompareText( fs, 'SHAPETYPE' ) = 0 ) Or
              ( AnsiCompareText( fs, 'GEOMETRY' ) = 0 ) Then
              Continue;

            { the fields can be received in two formats: DBF and SQL server:
              FIELD1;C;30;0
              or
              FIELD1;varchar;30;0 }
            // look for reserved words in fields
            if AnsiCompareText(fs,'TYPE')=0 then
              fs:=fs+'_';
            If length( ft ) = 1 Then
            Begin
              Case ft[1] Of
                'C': s := Format( '%s varchar(%d)', [fs, fl] );
                'L': s := Format( '%s CHAR(1)', [fs] );
                'D': s := Format( '%s date', [fs] );
                'T': s := Format( '%s time', [fs] );
                'N':
                  If fd = 0 Then
                  Begin
                    If fl <= 5 Then
                      s := Format( '%s smallint', [fs] )
                    Else
                      s := Format( '%s int', [fs] );
                  End
                  Else
                  Begin
                    s := Format( '%s double precision', [fs] );
                  End;
                'M': s := Format( '%s BLOB SUB_TYPE TEXT', [fs] );
                'B', 'G': s := Format( '%s BLOB', [fs] );
              End;
            End
            Else
            Begin
              If ( AnsiCompareText( ft, 'char' ) = 0 ) Or
                ( AnsiCompareText( ft, 'nchar' ) = 0 ) Or
                ( AnsiCompareText( ft, 'varchar' ) = 0 ) Or
                ( AnsiCompareText( ft, 'nvarchar' ) = 0 ) Then
                s := Format( '%s %s(%d)', [fs, ft, fl] )
              Else If ( AnsiCompareText( ft, 'numeric' ) = 0 ) Or
                ( AnsiCompareText( ft, 'decimal' ) = 0 ) Then
                s := Format( '%s %s(%d,%d)', [fs, ft, fl, fd] )
              Else
                s := Format( '%s %s', [fs, ft] );
            End;
            If i < fldlst.Count - 1 Then
              s := s + ',';
            cmd := cmd + s;
          End;
        End
        Else
          cmd := cmd + 'GEOMETRY BLOB';

        if (length(cmd) > 0) and (cmd[length(cmd)] = ',') then
          cmd:= copy(cmd,1,length(cmd)-1);

        cmd := cmd + ')';
        SQL.Text := cmd;
        IBStartTrans( IBSQL );
        ExecQuery;
        IBCommitTrans( IBSQL );

        { now create r-tree pages file }
        Close;
        SQL.Text := Format( SQL_CREATERTX, [layname] );
        IBStartTrans( IBSQL );
        ExecQuery;
        IBCommitTrans( IBSQL );

        { Create the stored procedures/triggers/generators for this layer }
        CreateLayerElements( layname, IBSQL );

        { insert the root node }
        Close;
        SQL.Text := Format( 'SELECT oid FROM addnode_%s (%d, %d, ''%s'', ''%s'' ) ;',
          [layname, -1, 0, 'Y', ''] );
        IBStartTrans( IBSQL );
        ExecQuery;
        IBCommitTrans( IBSQL );
        Close;
      End;

    Finally
      IBSQL.Free;
    End;
  Except
    FreeAndNil( Result );
    Raise;
  End;

  Result.Open;

End;

Function TEzIBLayers.CreateNew( Const FileName: String; FieldList: TStrings ): TEzBaseLayer;
Var
  CanInsert: Boolean;
Begin
  CanInsert := true;
  If Assigned( GIS.OnBeforeInsertLayer ) Then
    GIS.OnBeforeInsertLayer( GIS, FileName, CanInsert );

  Result := AddLayerTo( GIS As TEzIBGis, FileName,
    GIS.MapInfo.CoordSystem, GIS.MapInfo.CoordsUnits, FieldList );

  If Assigned( GIS.OnAfterInsertLayer ) Then
    GIS.OnAfterInsertLayer( GIS, FileName );
End;


Function TEzIBLayers.CreateNewEx( Const FileName: String; CoordSystem: TEzCoordSystem;
  CoordsUnits: TEzCoordsUnits; FieldList: TStrings ): TEzBaseLayer;
Var
  CanInsert: Boolean;
Begin
  CanInsert := true;
  If Assigned( GIS.OnBeforeInsertLayer ) Then
    GIS.OnBeforeInsertLayer( GIS, FileName, CanInsert );

  Result := AddLayerTo( GIS As TEzIBGis, FileName, CoordSystem, CoordsUnits, FieldList );

  If Assigned( GIS.OnAfterInsertLayer ) Then
    GIS.OnAfterInsertLayer( GIS, FileName );
End;

Function TEzIBLayers.CreateNewCosmethic( Const FileName: String ): TEzBaseLayer;
Var
  CanInsert: Boolean;
Begin
  Result := Nil;
  CanInsert := true;
  If Assigned( GIS.OnBeforeInsertLayer ) Then
    GIS.OnBeforeInsertLayer( GIS, FileName, CanInsert );
  If Not CanInsert Then Exit;
  If FileExists( FileName ) Then
    SysUtils.DeleteFile( FileName );

  Result := ezbasicctrls.AddLayerTo( GIS, FileName,
                                     FALSE, FALSE, ltMemory,
                                     GIS.MapInfo.CoordSystem,
                                     GIS.MapInfo.CoordsUnits, Nil );

  If Assigned( GIS.OnAfterInsertLayer ) Then
    GIS.OnAfterInsertLayer( GIS, FileName );
End;

Function TEzIBLayers.CreateNewAnimation( Const FileName: String ): TEzBaseLayer;
Var
  CanInsert: Boolean;
Begin
  Result := Nil;
  CanInsert := true;
  If Assigned( GIS.OnBeforeInsertLayer ) Then
    GIS.OnBeforeInsertLayer( GIS, FileName, CanInsert );
  If Not CanInsert Then
    Exit;

  Result := ezbasicctrls.AddLayerTo( GIS, FileName,
    TRUE, FALSE, ltDesktop,
    GIS.MapInfo.CoordSystem,
    GIS.MapInfo.CoordsUnits, Nil );

  If Assigned( GIS.OnAfterInsertLayer ) Then
    GIS.OnAfterInsertLayer( GIS, FileName );
End;

Function TEzIBLayers.Delete( Const LayerName: String; DeleteFiles: Boolean ): Boolean;
Var
  Layer: TEzBaseLayer;
  IBSQL: TIBSQL;
  index: integer;
  CanDelete: Boolean;
Begin
  Result:= False;
  If GIS.ReadOnly Or Not Assigned(TEzIBGis(Gis).FOnCreateIBSQL) Then Exit;
  { delete layer Index }
  Index := IndexOfName( LayerName );
  If Index < 0 Then Exit;
  Layer := Items[Index];
  CanDelete:= True;
  If Assigned( GIS.OnBeforeDeleteLayer ) Then
    GIS.OnBeforeDeleteLayer( Gis, LayerName, CanDelete );
  If Not CanDelete Then Exit;
  Layer.Close;
  Try
    If Layer Is TEzIBLayer Then
    Begin
      TEzIBGis(Gis).FOnCreateIBSQL( Gis, IBSQL );
      If IBSQL = Nil Then Exit;
      Try
        With IBSQL Do
        Begin
          { now delete the stored procedures/generators/triggers }
          Close;
          SQL.Text := Format( 'DROP PROCEDURE addentity_%s', [Layer.Name] );
          IBStartTrans( IBSQL );
          ExecQuery;
          IBCommitTrans( IBSQL );

          Close;
          SQL.Text := Format( 'DROP PROCEDURE search_%s', [Layer.Name] );
          IBStartTrans( IBSQL );
          ExecQuery;
          IBCommitTrans( IBSQL );
          
          // LAYINFO_xxx
          Close;
          SQL.Text := Format( 'DROP TABLE layinfo_%s', [Layer.Name] );
          IBStartTrans( IBSQL );
          ExecQuery;
          IBCommitTrans( IBSQL );

          // ENT_xxx
          Close;
          SQL.Text := Format( 'DROP TABLE ent_%s', [Layer.Name] );
          IBStartTrans( IBSQL );
          ExecQuery;
          IBCommitTrans( IBSQL );

          // RTX_xxx
          Close;
          SQL.Text := Format( 'DROP TABLE rtx_%s', [Layer.Name] );
          IBStartTrans( IBSQL );
          ExecQuery;
          IBCommitTrans( IBSQL );


          {Close;
          SQL.Text := Format( 'DROP TRIGGER set_ent_uid_%s', [Layer.Name] );
          IBStartTrans( IBSQL );
          ExecQuery;
          IBCommitTrans( IBSQL );

          Close;
          SQL.Text := Format( 'DROP TRIGGER set_rtx_pageid_%s', [Layer.Name] );
          IBStartTrans( IBSQL );
          ExecQuery;
          IBCommitTrans( IBSQL ); }

          Close;
          SQL.Text := Format( 'DROP GENERATOR gen_ent_%s', [Layer.Name] );
          IBStartTrans( IBSQL );
          ExecQuery;
          IBCommitTrans( IBSQL );

          Close;
          SQL.Text := Format( 'DROP GENERATOR gen_rtx_%s', [Layer.Name] );
          IBStartTrans( IBSQL );
          ExecQuery;
          IBCommitTrans( IBSQL );
          Close;

        End;
      Finally
        IBSQL.Free;
      End;
    End Else
    Begin
      If DeleteFiles And Not Layer.DeleteLayerFiles Then
      Begin
        Layer.Open;
        EzGISError( SCannotDeleteLayer );
      End;
    End;
    { take it as deleted }
    Layer.Free;
    If Assigned( GIS.OnAfterDeleteLayer ) Then
      GIS.OnAfterDeleteLayer( Gis, LayerName );
  Except
    Layer.Open;
    Raise;
  End;
  Result:= True;
End;


{-------------------------------------------------------------------------------}
{                  TEzIBMapInfo - class implementation                       }
{-------------------------------------------------------------------------------}

Procedure TEzIBMapInfo.Initialize;
Begin
  // nothing to do here
End;

Function TEzIBMapInfo.IsValid: Boolean;
Begin
  result := ( TEzIBGis( GIS ).FIBHeader <> Nil ) And TEzIBGis( GIS ).FIsOpen;
End;

Function TEzIBMapInfo.GetNumLayers: Integer;
Begin
  With TEzIBGis( GIS ) Do
  Begin
    result := Layers.Count;
  End;
End;

Procedure TEzIBMapInfo.SetNumLayers( Value: Integer );
Begin
End;

Function TEzIBMapInfo.GetExtension: TEzRect;
Begin
  result := Rect2D( 0, 0, 100, 100 );
  If TEzIBGis( GIS ).FIBField = Nil Then  exit;
  With TEzIBGis( GIS ).FIBField Do
  Begin
    result.x1 := AsFloat['EXTENSION_x1'];
    result.y1 := AsFloat['EXTENSION_y1'];
    result.x2 := AsFloat['EXTENSION_x2'];
    result.y2 := AsFloat['EXTENSION_y2'];
  End;
End;

Procedure TEzIBMapInfo.SetExtension( Const Value: TEzRect );
Begin
  With TEzIBGis( GIS ).FIBField Do
  Begin
    AsFloat['EXTENSION_x1'] := value.x1;
    AsFloat['EXTENSION_y1'] := value.y1;
    AsFloat['EXTENSION_x2'] := value.x2;
    AsFloat['EXTENSION_y2'] := value.y2;
  End;
  SetGisModifiedStatus( FGIS );
End;

Function TEzIBMapInfo.GetCurrentLayer: String;
Begin
  With TEzIBGis( GIS ), TEzIBGis( GIS ).FClientData Do
  Begin
    If Not currentlayer_init Then
    Begin
      CurrentLayer := FIBField.AsString['CURRENTLAYER'];
      CurrentLayer_init := true;
    End;
    result := CurrentLayer;
  End;
End;

Procedure TEzIBMapInfo.SetCurrentLayer( Const Value: String );
Begin
  With TEzIBGis( GIS ) Do
  Begin
    FClientData.CurrentLayer := value;
    FClientData.CurrentLayer_init := true;
    FIBField.AsString['CURRENTLAYER'] := value;
  End;
  Inherited SetCurrentLayer( Value );
  SetGisModifiedStatus( FGIS );
End;

Function TEzIBMapInfo.GetAerialViewLayer: String;
Begin
  With TEzIBGis( GIS ) Do
  Begin
    If Not FClientData.aerialviewlayer_init Then
    Begin
      FClientData.aerialviewlayer := FIBField.AsString['AERIALVIEWLAYER'];
      FClientData.aerialviewlayer_init := true;
    End;
    result := FClientData.aerialviewlayer;
  End;
End;

Procedure TEzIBMapInfo.SetAerialViewLayer( Const Value: String );
Begin
  With TEzIBGis( GIS ) Do
  Begin
    FClientData.aerialviewlayer := value;
    FClientData.aerialviewlayer_init := true;
    FIBField.AsString['AERIALVIEWLAYER'] := Value;
  End;
  SetGisModifiedStatus( FGIS );
End;

Function TEzIBMapInfo.GetLastView: TEzRect;
Begin
  With TEzIBGis( GIS ).FIBField Do
  Begin
    result.x1 := AsFloat['LASTVIEW_x1'];
    result.y1 := AsFloat['LASTVIEW_y1'];
    result.x2 := AsFloat['LASTVIEW_x2'];
    result.y2 := AsFloat['LASTVIEW_y2'];
  End;
End;

Procedure TEzIBMapInfo.SetLastView( Const Value: TEzRect );
Begin
  With TEzIBGis( GIS ).FIBField Do
  Begin
    AsFloat['LASTVIEW_x1'] := value.x1;
    AsFloat['LASTVIEW_y1'] := value.y1;
    AsFloat['LASTVIEW_x2'] := value.x2;
    AsFloat['LASTVIEW_y2'] := value.y2;
  End;
  SetGisModifiedStatus( FGIS );
End;

Function TEzIBMapInfo.GetCoordSystem: TEzCoordSystem;
Begin
  With TEzIBGis( GIS ) Do
  Begin
    If (FIBField <> Nil) And Not FClientData.CoordSystem_init Then
    Begin
      FClientData.CoordSystem := TEzCoordSystem( FIBField.AsInteger['COORDSYSTEM'] );
      FClientData.CoordSystem_init := true;
    End;
    result := FClientData.CoordSystem;
  End;
End;

Procedure TEzIBMapInfo.SetCoordSystem( Value: TEzCoordSystem );
Begin
  With TEzIBGis( GIS ) Do
  Begin
    if FIBField=nil then Exit;
    FClientData.CoordSystem := value;
    FClientData.CoordSystem_init := true;
    FIBField.AsInteger['COORDSYSTEM'] := Ord( value );
  End;
  SetGisModifiedStatus( FGIS );
End;

Function TEzIBMapInfo.GetCoordsUnits: TEzCoordsUnits;
Begin
  With TEzIBGis( GIS ) Do
  Begin
    If Not FClientData.coordsunits_init Then
    Begin
      FClientData.coordsunits := TEzCoordsUnits( FIBField.AsInteger['COORDSUNITS'] );
      FClientData.coordsunits_init := true;
    End;
    result := FClientData.coordsunits;
  End;
End;

Procedure TEzIBMapInfo.SetCoordsUnits( Value: TEzCoordsUnits );
Begin
  With TEzIBGis( GIS ) Do
  Begin
    FClientData.coordsunits := value;
    FClientData.coordsunits_init := true;
    FIBField.AsInteger['COORDSUNITS'] := Ord( value );
  End;
  SetGisModifiedStatus( FGIS );
End;

Function TEzIBMapInfo.GetIsAreaClipped: Boolean;
Begin
  If GIS.filename = '' Then
  Begin
    Result := false;
    Exit;
  End;
  With TEzIBGis( GIS ) Do
  Begin
    If Not FClientData.isareaclipped_init Then
    Begin
      FClientData.isareaclipped := FIBField.AsBoolean['ISAREACLIPPED'];
      FClientData.isareaclipped_init := true;
    End;
    result := FClientData.isareaclipped;
  End;
End;

Procedure TEzIBMapInfo.SetIsAreaClipped( Value: Boolean );
Begin
  With TEzIBGis( GIS ) Do
  Begin
    FClientData.IsAreaClipped := value;
    FClientData.isareaclipped_init := true;
    FIBField.AsBoolean['ISAREACLIPPED'] := value;
  End;
  SetGisModifiedStatus( FGIS );
End;

Function TEzIBMapInfo.GetAreaClipped: TEzRect;
Begin
  With TEzIBGis( GIS ) Do
  Begin
    If Not FClientData.areaclipped_init Then
    Begin
      result.x1 := FIBField.AsFloat['AREACLIPPED_x1'];
      result.Y1 := FIBField.AsFloat['AREACLIPPED_y1'];
      result.x2 := FIBField.AsFloat['AREACLIPPED_x2'];
      result.Y2 := FIBField.AsFloat['AREACLIPPED_Y2'];
      FClientData.areaclipped_init := true;
    End;
    result := FClientData.areaclipped;
  End;
End;

Procedure TEzIBMapInfo.SetAreaClipped( Const Value: TEzRect );
Begin
  With TEzIBGis( GIS ) Do
  Begin
    FClientData.areaclipped := value;
    FClientData.areaclipped_init := true;
    FIBField.AsFloat['AREACLIPPED_x1'] := value.x1;
    FIBField.AsFloat['AREACLIPPED_Y1'] := value.Y1;
    FIBField.AsFloat['AREACLIPPED_x2'] := value.x2;
    FIBField.AsFloat['AREACLIPPED_Y2'] := value.Y2;
  End;
  SetGisModifiedStatus( FGIS );
End;

Function TEzIBMapInfo.GetClipAreaKind: TEzClipAreaKind;
Begin
  With TEzIBGis( GIS ) Do
  Begin
    If Not FClientData.ClipAreaKind_init Then
    Begin
      FClientData.ClipAreaKind := TEzClipAreaKind( FIBField.AsInteger['CLIPAREAKIND'] );
      FClientData.ClipAreaKind_init := true;
    End;
    result := FClientData.ClipAreaKind;
  End;
End;

Procedure TEzIBMapInfo.SetClipAreaKind( Value: TEzClipAreaKind );
Begin
  With TEzIBGis( GIS ) Do
  Begin
    FClientData.clipareakind := value;
    FClientData.ClipAreaKind_init := true;
    FIBField.AsInteger['CLIPAREAKIND'] := ord( value );
  End;
  SetGisModifiedStatus( FGIS );
End;

{-------------------------------------------------------------------------------}
{                  TEzIBGis - class implementation                             }
{-------------------------------------------------------------------------------}

Constructor TEzIBGis.Create( Aowner: TComponent );
Begin
  Layers := TEzIBLayers.Create( Self );
  Inherited Create( AOwner );
  FMapInfo := TEzIBMapInfo.Create( self );  { destroyed in the parent class }
  FClientData := TEzIBMapClientData.Create;
  FQueryBasicFields:= true;

{$IFDEF IBTRIAL_VERSION}
  If Not IsDesigning Then
  Begin
    If Not SecurityCheckIfValid( true ) Then
      Application.Terminate;
    Inc( IBGisInstances );
  End;
{$ENDIF}

End;

Destructor TEzIBGis.Destroy;
Begin
  If FIBHeader <> Nil Then FIBHeader.Free;
  If FIBField <> Nil Then FIBField.Free;
  FClientData.Free;

{$IFDEF IBTRIAL_VERSION}
  If Not IsDesigning Then
  Begin
    Dec( IBGisInstances );
    If IBGisInstances = 0 Then
      SecurityEndProgram;
  End;
{$ENDIF}

  Inherited Destroy;
End;

Procedure TEzIBGis.SaveWindowsSeparators;
begin
  TmpDecimalSeparator:= SysUtils.DecimalSeparator;
  TmpThousandSeparator:= SysUtils.ThousandSeparator;
  SysUtils.DecimalSeparator:= '.';
  SysUtils.ThousandSeparator:= ',';
end;

Procedure TEzIBGis.RestoreWindowsSeparators;
begin
  SysUtils.DecimalSeparator:= TmpDecimalSeparator;
  SysUtils.ThousandSeparator:=TmpThousandSeparator;
end;

procedure TEzIBGis.InvalidateClientInfo;
var
  I: Integer;
begin
  FClientData.Invalidate;
  for I:= 0 to Layers.Count-1 do
    if Layers[I] is TEzIBLayer then
    begin
      TEzIBLayerInfo( Layers[I].LayerInfo).ClientData.Invalidate;
    end;
end;

procedure TEzIBGis.ClearLayerInformation;
begin
  if ReadOnly or not FIsOpen then exit;
  with FIBField.FIBSQL do
  begin
    Close;
    SQL.Text:= 'UPDATE map_header SET LAYERS = NULL';
    IBStartTrans( FIBField.FIBSQL );
    ExecQuery;
    IBCommitTrans( FIBField.FIBSQL );
    Close;
  end;
end;

procedure TEzIBGis.AddGeoref(const LayerName, FileName: String);
Var
  Layer: TEzBaseLayer;
  Ent: TEzEntity;
  GeorefImage: TEzGeorefImage;
Begin
  If ( Length( FileName ) = 0 ) Or Not FileExists( FileName ) Then Exit;

  Layer := Layers.LayerByName(LayerName);
  If Layer = Nil Then Exit;

  GeorefImage := TEzGeorefImage.Create( Nil );
  Ent := TEzBandsBitmap.CreateEntity( Point2D( 0, 0 ), Point2D( 0, 0 ), '' );
  Try
    GeorefImage.FileName := FileName;
    GeorefImage.Open;
    Ent.Points[0] := GeorefImage.Extents.Emin;
    Ent.Points[1] := GeorefImage.Extents.Emax;
    TEzBandsBitmap(Ent).FileName := GeorefImage.ImageName;
    Ent.UpdateExtension;
    Layer.AddEntity(Ent);
  Finally
    Ent.Free;
    GeorefImage.Free;
  End;
end;

procedure TEzIBGis.Close;
begin
  Inherited Close;
  If FIBHeader <> Nil Then
    FreeAndNil( FIBHeader );
  If FIBField <> Nil Then
    FreeAndNil( FIBField );
end;

function TEzIBGis.CreateLayer(const LayerName: String; LayerType: TEzLayerType): TEzBaseLayer;
begin
  If LayerType = ltMemory Then
    Result := TEzMemoryLayer.Create( Layers, LayerName )
  Else If LayerType = ltDesktop then
    Result := TEzLayer.Create( Layers, LayerName )
  Else if LayerType = ltClientServer then
    Result:= TEzIBLayer.Create( Layers, LayerName )
  else
    Result:= nil;
end;

procedure TEzIBGis.CreateNew(const FileName: String);
Begin
  { calls the inherited }
  Inherited CreateNew( FileName );
  { open the file }
  If FIBHeader <> Nil Then
    FreeAndNil( FIBHeader );
  if Assigned(FOnCreateIBSQL) then
    FOnCreateIBSQL( Self, FIBHeader );
  If FIBHeader = Nil Then Exit;

  If FIBField <> Nil Then
    FreeAndNil( FIBField );
  FIBField := TEzIBField.Create( 'map_header', FIBHeader );

  { create the database }
  With FIBHeader Do
  Begin

    Close;
    SQL.Text := SQL_DOMAIN1;
    IBStartTrans( FIBHeader );
    ExecQuery;
    IBCommitTrans( FIBHeader );
    Close;

    SQL.Text := SQL_CREATEMAPHEADER1+SQL_CREATEMAPHEADER2;
    IBStartTrans( FIBHeader );
    ExecQuery;
    IBCommitTrans( FIBHeader );

    { insert the only record here}
  {SQL_INSERTMAPHDRREC = 'INSERT INTO MAP_HEADER ' +
    ' (POLYCLIPAREA, PROJ_PARAMS, GUIDELINES, SYMBOLS)' +
    ' VALUES (NULL,NULL,NULL,NULL,NULL)'; }

    Close;
    SQL.Text := 'INSERT INTO MAP_HEADER (POLYCLIPAREA) VALUES (NULL)'; // dummy insert only
    IBStartTrans( FIBHeader );
    ExecQuery;
    IBCommitTrans( FIBHeader );
    Close;

    { create stored procedures for all the map }
    CreateGlobalElements( FIBHeader );
    Close;
  End;
end;

function TEzIBGis.GetGISVersion: TEzAbout;
begin
  Result:= SEz_GisIBVersion;
end;

procedure TEzIBGis.SetGISVersion(const Value: TEzAbout);
begin
end;

Function TEzIBGis.IsClientServer: Boolean;
Begin
  result := true;
End;

Procedure TEzIBGis.WriteMapHeader( Const Filename: String );
Begin
  { this method must not be implemented in c/s }
End;

Procedure TEzIBGis.Open;
Var
  LayerName, s: String;
  I, n, L, Index, hcount, vcount: Integer;
  TmpModified: Boolean;
  X, Y, Coord: Double;
  stream: TMemoryStream;
  LayStr: TStringList;
  Inifile: TIniFile;
  Found: Boolean;
  LastView: TEzRect;
  Section: string;
  Box: TEzRect;
Begin
  If IsDesigning or Not Assigned(FOnCreateIBSQL) Then Exit;

  Close;

  Inherited Open;

  { open the file }
  If FIBHeader <> Nil Then FreeAndNil( FIBHeader );
  FOnCreateIBSQL( Self, FIBHeader );
  If FIBHeader = Nil Then Exit;

  If FIBField <> Nil Then FreeAndNil( FIBField );
  FIBField := TEzIBField.Create( 'map_header', FIBHeader );
  { check if the database exists... pendiente de implementar
    if not FileExists(Filename) then
    begin
      Self.FileName:= '';
      Modified:=FALSE;
      Exit;
    end;
    }
  TmpModified := False;

  { Load the Layers from the map_header table, Nakijun }
  With FIBField Do
  Begin
    //if (FIBSQL.Fields.FindField('LAYERS')<>Nil) and
    If Not IsNull['LAYERS'] Then
    Begin
      Laystr := TStringlist.Create;
      Stream := TMemoryStream.Create;
      Try
        ReadBlob( 'LAYERS', Stream );
        Stream.Seek( 0, 0 );
        LayStr.LoadFromStream( Stream );
        For i := 0 To LayStr.Count - 1 Do
        Begin
          layername := LayStr[i];
          { check if basic files for LayerName exists and if not, don't open this }
          If TableExists( 'LAYINFO_' + layername, FIBHeader ) And
            TableExists( 'ENT_' + layername, FIBHeader ) Then
          Begin
            Index := Layers.Add( layername, ltClientServer );
            If Index >= 0 Then
            Begin
              Layers[Index].Open;
              Layers[Index].LayerInfo.CoordsUnits := MapInfo.CoordsUnits;
            End;
          End;
        End;
      Finally
        LayStr.free;
        Stream.free;
      End;
    End
    Else
    Begin
      With FIBHeader Do
      Begin
        Close;
        GotoFirstRecordOnExecute:=true;
        SQL.Text := SQL_GETLAYERLIST;
        IBStartTrans( FIBHeader );
        ExecQuery;
        Laystr := TStringlist.Create;
        While Not Eof Do
        Begin
          layername := TrimRight(FieldByName( 'rdb$relation_name' ).AsString);
          layername := copy( layername, 9, Length( layername ) );
          Laystr.Add( layername );
          Next;
        end;
        IBCommitTrans( FIBHeader );
        for I:= 0 to Laystr.Count-1 do
        begin
          layername:= Laystr[I];
          If TableExists( 'LAYINFO_' + layername, FIBHeader ) And
            TableExists( 'ENT_' + layername, FIBHeader ) Then
          Begin
            Index := Layers.Add( layername, ltClientServer );
            If Index >= 0 Then
            Begin
              Layers[Index].Open;
              Layers[Index].LayerInfo.CoordsUnits := MapInfo.CoordsUnits;
            End;
          End;
        End;
      End;
      { recreate stored procedures if were deleted }
      CreateGlobalElements( FIBHeader );
    End;

    (* read the coord system and check params *)
    ProjectionParams.Clear;
    If Not IsNull['PROJ_PARAMS'] Then
    Begin
      Stream := TMemoryStream.Create;
      Try
        ReadBlob( 'PROJ_PARAMS', stream );
        stream.Seek( 0, 0 );
        Stream.Read( n, sizEof( n ) );
        For I := 1 To n Do
        Begin
          stream.Read( L, SizEof( L ) );
          s := '';
          If L > 0 Then
          Begin
            SetLength( s, L );
            stream.Read( s[1], L );
          End;
          ProjectionParams.Add( s );
        End;
      Finally
        stream.free;
      End;
    End;

    { now read the guidelines}
    HGuidelines.Clear;
    VGuidelines.Clear;
    If Not IsNull['GUIDELINES'] Then
    Begin
      Stream := TMemoryStream.Create;
      Try
        ReadBlob( 'GUIDELINES', stream );
        stream.Seek( 0, 0 );
        Stream.Read( hcount, SizEof( hcount ) );
        Stream.Read( vcount, SizEof( vcount ) );
        For I := 1 To hcount Do
        Begin
          Stream.Read( Coord, sizEof( Coord ) );
          HGuidelines.Add( Coord );
        End;
        If hcount > 0 Then
          HGuideLines.Sort;
        For I := 1 To vcount Do
        Begin
          Stream.Read( Coord, sizEof( Coord ) );
          VGuidelines.Add( Coord );
        End;
        If vcount > 0 Then
          VGuideLines.Sort;
      Finally
        stream.free;
      End;
    End;

    { now read the polygonal clipping area }
    ClipPolygonalArea.Clear;
    If Not IsNull['POLYCLIPAREA'] Then
    Begin
      Stream := TMemoryStream.Create;
      Try
        ReadBlob( 'POLYCLIPAREA', stream );
        stream.Seek( 0, 0 );
        Stream.Read( n, sizEof( n ) );
        For I := 1 To n Do
        Begin
          stream.Read( X, sizEof( X ) );
          stream.Read( Y, sizEof( Y ) );
          ClipPolygonalArea.Add( Point2D( X, Y ) );
        End;
      Finally
        stream.free;
      End;
    End;

  End;
  If ( Length( MapInfo.AerialViewLayer ) > 0 ) And
    ( Layers.IndexOfName( MapInfo.AerialViewLayer ) = -1 ) Then
  Begin
    MapInfo.AerialViewLayer := '';
    Modified := true;
  End;

  If ( Layers.IndexOfName( MapInfo.CurrentLayer ) < 0 ) And ( Layers.Count > 0 ) Then
    CurrentLayerName := Layers[0].Name
  Else
    CurrentLayerName := MapInfo.CurrentLayer;

  If Assigned( OnCurrentLayerChange ) Then
    OnCurrentLayerChange( Self, CurrentLayerName );

  //Self.FileName := FileName;
  If Assigned( OnFileNameChange ) Then
    OnFileNameChange( Self );
  { Clear temp entities }
  For I := 0 To DrawBoxList.Count - 1 Do
    DrawBoxList[I].TempEntities.Clear;

  { redisplay the viewports
    the last view of the map is controled:
    - in local file EzGis.Ini
    - if does not exists that section, then read from the map}
  Inifile := TIniFile.Create( AddSlash( ExtractFilepath( Application.ExeName ) ) + 'EzGis.Ini' );
  Try
    Section:= ChangeFileExt( ExtractFileName( FileName ), '');;
    Found := Inifile.SectionExists( Section );
    If Found Then
    Begin
      SaveWindowsSeparators;
      Box:= MapInfo.Extension;
      LastView.X1 := ReadFloatFromIni( Inifile, Section, 'LastViewX1', Box.X1 );
      LastView.Y1 := ReadFloatFromIni( Inifile, Section, 'LastViewY1', Box.Y1 );
      LastView.X2 := ReadFloatFromIni( Inifile, Section, 'LastViewX2', Box.X2 );
      LastView.Y2 := ReadFloatFromIni( Inifile, Section, 'LastViewY2', Box.Y2 );
      RestoreWindowsSeparators;
    End
    Else
      LastView := MapInfo.LastView;
    For I := 0 To DrawBoxList.Count - 1 Do
      With DrawBoxList[I] Do
      Begin
        //SendMessage(Handle, CM_COLORCHANGED, 0, 0);   // fix rubber banding bug
        If Self.AutoSetLastView Then
          Grapher.SetViewTo( LastView );
        Grapher.Clear;
      End;
  Finally
    Inifile.free;
  End;
  FIsOpen := true;
  Modified := TmpModified;
End;

Procedure TEzIBGis.SaveAs( Const FileName: String );
Var
  I, n, hcount, vcount: Integer;
  s, TmpFileName: String;
  Stream: TMemoryStream;
  X, Y, Coord: double;
  Inifile: TInifile;
  LastView: TEzRect;
  LayStr: TStringList;
  Section: string;
Begin
  If ReadOnly Or Not FIsOpen Then Exit;
  { in c/s FileName parameter is ignored because we cannot save to other file
    to what is currently opened }

  TmpFilename := Self.FileName;
  { save the last view from one of the viewports }
  If Length( TmpFileName ) = 0 Then Exit;
  If DrawBoxList.Count > 0 Then
    FMapInfo.LastView := DrawBoxList[0].Grapher.CurrentParams.VisualWindow;
  LastView := FMapInfo.LastView;
  { save the last view in a local .INI file }
  { redisplay the viewports
    the last view of the map is controled:
    - in local file EzGis.Ini
    - if does not exists that section, then read from the map}
  Inifile := TIniFile.Create( AddSlash( ExtractFilepath( Application.ExeName ) ) + 'EzGis.Ini' );
  Try
    SaveWindowsSeparators;
    Section:= ChangeFileExt( ExtractFileName( FileName ), '');;
    WriteFloatToIni( Inifile, Section, 'LastViewX1', LastView.X1 );
    WriteFloatToIni( Inifile, Section, 'LastViewY1', LastView.Y1 );
    WriteFloatToIni( Inifile, Section, 'LastViewX2', LastView.X2 );
    WriteFloatToIni( Inifile, Section, 'LastViewY2', LastView.Y2 );
    RestoreWindowsSeparators;
  Finally
    Inifile.free;
  End;

  With FIBField Do
  Begin
    For I := 0 To Layers.Count - 1 Do
      Layers[I].WriteHeaders( true ); // true=flush files

    // save the coord system
    if ProjectionParams.Count = 0 then
      SetAsNull( 'PROJ_PARAMS' )
    else
    begin
      stream := TMemoryStream.Create;
      Try
        n := ProjectionParams.Count;
        Stream.Write( n, sizEof( n ) );
        For I := 0 To n - 1 Do
        Begin
          s := ProjectionParams[i];
          n := Length( s );
          Stream.Write( n, sizEof( n ) );
          If n > 0 Then
            Stream.Write( s[1], n );
        End;
        stream.seek( 0, 0 );
        WriteBlob( 'PROJ_PARAMS', stream );
      Finally
        stream.free;
      End;
    end;

    { save the guidelines }
    if ( HGuideLines.Count = 0 ) And ( VGuideLines.Count = 0) then
      SetAsNull( 'GUIDELINES' )
    else
    begin
      stream := TMemoryStream.Create;
      Try
        hcount := HGuideLines.Count;
        vcount := VGuideLines.Count;
        Stream.Write( hcount, SizEof( hcount ) );
        Stream.Write( vcount, SizEof( vcount ) );
        For I := 0 To hcount - 1 Do
        Begin
          Coord := HGuidelines[I];
          stream.write( coord, sizEof( coord ) );
        End;
        For I := 0 To vcount - 1 Do
        Begin
          Coord := VGuidelines[I];
          stream.write( coord, sizEof( coord ) );
        End;
        stream.seek( 0, 0 );
        WriteBlob( 'GUIDELINES', stream );
      Finally
        stream.free;
      End;
    end;

    { save the polygonal clipping area }
    if ClipPolygonalArea.Count=0 then
      SetAsNull( 'POLYCLIPAREA' )
    else
    begin
      stream := TMemoryStream.Create;
      Try
        n := ClipPolygonalArea.Count;
        Stream.Write( n, sizEof( n ) );
        For i := 0 To n - 1 Do
        Begin
          X := ClipPolygonalArea[I].X;
          Y := ClipPolygonalArea[I].Y;
          Stream.Write( X, sizEof( X ) );
          Stream.Write( Y, sizEof( Y ) );
        End;
        stream.seek( 0, 0 );
        WriteBlob( 'POLYCLIPAREA', stream );
      Finally
        stream.free;
      End;
    end;

    //Fill Layer information to Layer field
    //if (FIBSQL.Fields.FindField('LAYERS')<>Nil) and
    If Layers.Count = 0 Then
      SetAsNull( 'LAYERS' )
    else
    Begin
      Laystr := TStringlist.Create;
      Stream := TMemoryStream.Create;
      Try
        For i := 0 To Layers.Count - 1 Do
          LayStr.Add( Layers[i].Name );
        LayStr.SaveToStream( stream );
        stream.Seek( 0, 0 );
        WriteBlob( 'LAYERS', stream );
      Finally
        LayStr.free;
        stream.free;
      End;
    End;
  End;

  Modified := False;
End;

{$IFDEF BCB}
function TEzIBGis.GetIBHeader: TIBSQL;
begin
  Result := FIBHeader;
end;

function TEzIBGis.GetOnCreateIBSQL: TEzCreateIBSQLEvent;
begin
  Result := FOnCreateIBSQL;
end;

function TEzIBGis.GetQueryBasicFields: Boolean;
begin
  Result := FQueryBasicFields;
end;

procedure TEzIBGis.SetOnCreateIBSQL(const Value: TEzCreateIBSQLEvent);
begin
  FOnCreateISBQL := Value;
end;

procedure TEzIBGis.SetQueryBasicFields(const Value: Boolean);
begin
  FQueryBasicFields := Value;
end;
{$ENDIF}

{ r-tree stuff }
{ TIBRTNode }

Procedure TIBRTNode.Read( NId: Longint );
Var
  s: String;
Begin
  With TEzIBLayer( TIBRTree( rt ).Layer ) Do
  Begin
    With FIBHeader Do
    Begin
      Close;
      SQL.Text :=
        Format( 'SELECT * FROM rtx_%s WHERE pageid = %d',
                [TEzIBLayer( TIBRTree( rt ).Layer ).Name, NID] );
      IBStartTrans( FIBHeader );
      ExecQuery;
      If Eof Then
      Begin
        IBCommitTrans( FIBHeader );
        Close;
        EzGISError( Format( '%d node not found', [NID] ) );
      End;
      Data.Parent := FieldByName( 'PARENT' ).AsInteger;
      Data.FullEntries := FieldByName( 'FULLENTRIES' ).AsInteger;
      Data.Leaf := FieldByName( 'LEAF' ).AsString='Y';
      s := FieldByName( 'ENTRIES' ).Asstring;
      SetStringToData( s, Data );
      IBCommitTrans( FIBHeader );
      Close;
    End;
  End;
  Self.oid := NId;
End;

// Update the object with the data pointed to by the Data field

Procedure TIBRTNode.Write;
Var
  YN, s: String;
Begin
  With TEzIBLayer( TIBRTree( rt ).Layer ) Do
  Begin
    With FIBHeader Do
    Begin
      Close;
      if Data.Leaf then YN := 'Y' else YN := 'N';
      {SQL_UPDATENODE = 'UPDATE rtx_%s SET parent = %d, fullentries = %d, leaf = ''%s'', ' +
        'entries = ''%s'' WHERE pageid = %d'; }
      SetDataToString( Data, s );
      SQL.Text := Format( SQL_UPDATENODE, [TEzIBLayer( TIBRTree( rt ).Layer ).Name,
        Data.Parent, Data.FullEntries, YN, s, oid] );
      IBStartTrans( FIBHeader );
      ExecQuery;
      IBCommitTrans( FIBHeader );
      Close;
    End;
  End;
End;

// Create a new node with initial data pointed to by the Data field

Procedure TIBRTNode.AddNodeToFile;
Var
  YN, s: String;
Begin
  With TEzIBLayer( TIBRTree( rt ).Layer ) Do
  Begin
    With FIBHeader Do
    Begin
      Close;
      if Data.Leaf then YN := 'Y' else YN := 'N';
      SetDataToString( Data, s );
      SQL.Text := Format( 'SELECT oid FROM addnode_%s (%d, %d, ''%s'', ''%s'' ) ;',
        [TEzIBLayer( TIBRTree( rt ).Layer ).Name, Data.Parent, Data.FullEntries, YN, s] );
      IBStartTrans( FIBHeader );
      ExecQuery;
      oid := Fields[0].AsInteger;
      IBCommitTrans( FIBHeader );
      Close;
    End;
  End;
End;

// Delete this object

Procedure TIBRTNode.DeleteNodeFromFile;
Begin
  With TEzIBLayer( TIBRTree( rt ).Layer ) Do
  Begin
    With FIBHeader Do
    Begin
      Close;
      SQL.Text := Format( 'DELETE FROM rtx_%s WHERE pageid =%d',
        [TEzIBLayer( TIBRTree( rt ).Layer ).Name, oid] );
      IBStartTrans( FIBHeader );
      ExecQuery;
      IBCommitTrans( FIBHeader );
      Close;
    End;
  End;
End;

{-------------------------------------------------------------------------------}
{                  TIBRTree - class implementation                             }
{-------------------------------------------------------------------------------}

Function TIBRTree.CreateNewNode: TRTNode;
Begin
  result := TIBRTNode.Create( self );
End;

Function TIBRTree.Open( Const Name: String; Mode: Word ): integer;
Begin
  Result:= TREE_ERROR;
  If IdxOpened Or ( TEzIBLayer( FLayer ).FIBHeader = Nil ) Then Exit;
  With TEzIBLayer( FLayer ).FIBField Do
  Begin
    RootId := AsInteger['rootnode'];
    Depth := AsInteger['depth'];
  End;

  RootNode.Read( RootId );
  fName := Name;

  IdxOpened := true;
  result := OK;
End;

Procedure TIBRTree.Close;
Begin
  If Not IdxOpened Then Exit; // Nothing to close
  IdxOpened := false;
End;

Procedure TIBRTree.FlushFiles;
Begin
  // nothing to do here
End;

Procedure TIBRTree.ReadCatalog( Var IdxInfo: TRTCatalog );
Begin
  With TEzIBLayer( FLayer ).FIBField Do
  Begin
    IdxInfo.RootNode := AsInteger['rootnode'];
    IdxInfo.Depth := AsInteger['depth'];
    IdxInfo.multiplier := AsInteger['multiplier'];
    IdxInfo.BucketSize := AsInteger['BucketSize'];
    IdxInfo.LowerBound := AsInteger['LowerBound'];
  End;
End;

Procedure TIBRTree.WriteCatalog( Const IdxInfo: TRTCatalog );
Begin
  With TEzIBLayer( FLayer ).FIBField Do
  Begin
    AsInteger['rootnode'] := IdxInfo.RootNode;
    AsInteger['depth'] := IdxInfo.Depth;
    AsInteger['multiplier'] := IdxInfo.multiplier;
    AsInteger['BucketSize'] := IdxInfo.BucketSize;
    AsInteger['LowerBound'] := IdxInfo.LowerBound;
  End;
End;

// Destroy an R-Tree index file.

Procedure TIBRTree.DropIndex;
Begin
  Close;
  // nothing to do here
End;

// Create an R-Tree with the given name

Function TIBRTree.CreateIndex( Const Name: String; Multiplier: Integer ): integer;
var
  YN: string;
Begin

  If IdxOpened Then Close;

  With TIBRTNode( RootNode ) Do
  Begin
    FillChar( Data, sizEof( TDiskPage ), 0 );
    Data.FullEntries := 0;
    Data.Parent := -1;
    Data.Leaf := True;
  End;

  // Fill in the index entry
  Self.Depth := 0;
  RootId := 1;

  TIBRTNode( RootNode ).oid := 1;

  { Delete all the r-tree records }
  with TEzIBLayer( FLayer ) do
    If TableExists( 'RTX_' + Name, FIBHeader ) Then
      With FIBHeader Do
      Begin
        Close;
        SQL.Text := Format( 'DROP TABLE RTX_%s', [Name] );
        IBStartTrans( FIBHeader );
        ExecQuery;
        IBCommitTrans( FIBHeader );
        Close;

        {SQL_CREATERTX =
          'CREATE TABLE RTX_%s (' +
          'PAGEID int NOT NULL PRIMARY KEY,' +
          'PARENT int DEFAULT 0,' +
          'FULLENTRIES int DEFAULT 0,' +
          'LEAF CHAR(1) DEFAULT ''N'' ,' +
          'ENTRIES char(3000) )'; }

        SQL.Text := Format( SQL_CREATERTX, [TEzIBLayer( FLayer ).Name] );
        IBStartTrans( FIBHeader );
        ExecQuery;
        IBCommitTrans( FIBHeader );

        { insert the root node }
        YN:= 'Y';
        SQL.Text := Format( 'SELECT oid FROM addnode_%s (%d, %d, ''%s'', ''%s'' ) ;',
          [TEzIBLayer( FLayer ).Name, -1, 0, YN, ''] );
        IBStartTrans( FIBHeader );
        ExecQuery;
        RootID:= FieldByName('oid').AsInteger;
        IBCommitTrans( FIBHeader );
        Close;
      End;
  // update the catalog
  With TEzIBLayer( FLayer ).FIBField Do
  Begin
    AsInteger['rootnode'] := 1;
    AsInteger['depth'] := 0;
    AsInteger['multiplier'] := Multiplier;
    AsInteger['BucketSize'] := BUCKETSIZE;
    AsInteger['LowerBound'] := LOWERBOUND;
  End;
  // Create the root node
  //RootNode.AddNodeToFile;
  IdxOpened := true;
  FName := Name;
  result := OK;
End;

{ TEzIBField }

Constructor TEzIBField.Create( Const TableName: String; IBSQL: TIBSQL );
Begin
  Inherited Create;
  FTableName := TableName;
  FIBSQL := IBSQL;
End;

Procedure TEzIBField.OpenIBSQL( Const ASQL: String );
Begin
  With FIBSQL Do
  Begin
    Close;
    SQL.Text := ASQL;
    IBStartTrans( FIBSQL );
    ExecQuery;
  End;
End;

Function TEzIBField.GetAsBoolean( Const FieldName: String ): Boolean;
Begin
  OpenIBSQL( Format( 'SELECT %s FROM %s', [FieldName, FTableName] ) );
  result := FIBSQL.Fields[0].AsString='Y';
  IBCommitTrans( FIBSQL );
  FIBSQL.Close;
End;

Function TEzIBField.GetAsDateTime( Const FieldName: String ): TDateTime;
Begin
  OpenIBSQL( Format( 'SELECT %s FROM %s', [FieldName, FTableName] ) );
  result := FIBSQL.Fields[0].AsDateTime;
  IBCommitTrans( FIBSQL );
  FIBSQL.Close;
End;

Function TEzIBField.GetAsFloat( Const FieldName: String ): Double;
Begin
  OpenIBSQL( Format( 'SELECT %s FROM %s', [FieldName, FTableName] ) );
  result := FIBSQL.Fields[0].AsDouble;
  IBCommitTrans( FIBSQL );
  FIBSQL.Close;
End;

Function TEzIBField.GetAsInteger( Const FieldName: String ): Integer;
Begin
  OpenIBSQL( Format( 'SELECT %s FROM %s', [FieldName, FTableName] ) );
  result := FIBSQL.Fields[0].AsInteger;
  IBCommitTrans( FIBSQL );
  FIBSQL.Close;
End;

Function TEzIBField.GetAsString( Const FieldName: String ): String;
Begin
  OpenIBSQL( Format( 'SELECT %s FROM %s', [FieldName, FTableName] ) );
  result := FIBSQL.Fields[0].AsString;
  IBCommitTrans( FIBSQL );
  FIBSQL.Close;
End;

Function TEzIBField.GetIsNull( Const FieldName: String ): Boolean;
Begin
  OpenIBSQL( Format( 'SELECT %s FROM %s', [FieldName, FTableName] ) );
  result := FIBSQL.Fields[0].IsNull;
  IBCommitTrans( FIBSQL );
  FIBSQL.Close;
End;

Procedure TEzIBField.ReadBlob( Const FieldName: String; stream: TStream );
Begin
  OpenIBSQL( Format( 'SELECT %s FROM %s', [FieldName, FTableName] ) );
  Stream.Position:=0;
  FIBSQL.Fields[0].SaveToStream( stream );
  IBCommitTrans( FIBSQL );
  FIBSQL.Close;
End;

Procedure TEzIBField.ExecuteIBSQL( Const Asql: String );
Begin
  With FIBSQL Do
  Begin
    Close;
    SQL.Text := Asql;
    IBStartTrans( FIBSQL );
    ExecQuery;
    IBCommitTrans( FIBSQL );
    Close;
  End;
End;

Procedure TEzIBField.SetAsNull( Const FieldName: String );
Begin
  ExecuteIBSQL( Format( 'UPDATE %s SET %s = NULL', [FTableName, FieldName] ) );
End;

Procedure TEzIBField.SetAsBoolean( Const FieldName: String; Const Value: Boolean );
var
  yn: string;
Begin
  if value then yn:= 'Y' else yn:= 'N';
  ExecuteIBSQL( Format( 'UPDATE %s SET %s = ''%s''', [FTableName, FieldName, yn] ) );
End;

Procedure TEzIBField.SetAsDateTime( Const FieldName: String; Const Value: TDateTime );
Begin
  ExecuteIBSQL( Format( 'UPDATE %s SET %s = ''%s''', [FTableName, FieldName, FormatDateTime( 'm/d/yyyy', Value )] ) );
End;

Procedure TEzIBField.SetAsFloat( Const FieldName: String; Const Value: Double );
var
  TmpDecimalSeparator, TmpThousandSeparator: Char;
Begin
  TmpDecimalSeparator:= SysUtils.DecimalSeparator;
  TmpThousandSeparator:= SysUtils.ThousandSeparator;
  SysUtils.DecimalSeparator:= '.';
  SysUtils.ThousandSeparator:= ',';
  ExecuteIBSQL( Format( 'UPDATE %s SET %s = %.6f', [FTableName, FieldName, Value] ) );
  SysUtils.DecimalSeparator:= TmpDecimalSeparator;
  SysUtils.ThousandSeparator:=TmpThousandSeparator;
End;

Procedure TEzIBField.SetAsInteger( Const FieldName: String; Const Value: Integer );
Begin
  ExecuteIBSQL( Format( 'UPDATE %s SET %s = %d', [FTableName, FieldName, Value] ) );
End;

Procedure TEzIBField.SetAsString( Const FieldName, Value: String );
Begin
  ExecuteIBSQL( Format( 'UPDATE %s SET %s = ''%s''', [FTableName, FieldName, Value] ) );
End;

Procedure TEzIBField.WriteBlob( Const FieldName: String; stream: TStream );
Begin
  With FIBSQL Do
  Begin
    Close;
    SQL.Text:= Format('UPDATE %s SET %s = :param1', [FTableName, FieldName]);
    IBStartTrans( FIBSQL );
    ParamByName('param1').LoadFromStream( stream );
    ExecQuery;
    IBCommitTrans( FIBSQL );
    Close;
  End;
End;

{ TEzIBLayerClientData }

Procedure TEzIBLayerClientData.Invalidate;
begin
  CoordsUnits_init:=false;
  CoordSystem_init:=false;
  Visible_init:=false;
  Selectable_init:=false;
  TextHasShadow_init:=false;
  TextFixedSize_init:=false;
  OverlappedTextAction_init:=false;
  OverlappedTextColor_init:=false;
  RecCount_init:=false;
end;

{ TEzIBMapClientData }

Procedure TEzIBMapClientData.Invalidate;
Begin
  CurrentLayer_init := false;
  AerialViewLayer_init := false;
  coordsunits_init := false;
  IsAreaClipped_init := false;
  AreaClipped_init := false;
  ClipAreaKind_init := false;
End;

function TEzIBTable.FieldTypeEx(FieldNo: Integer): Char;
begin
  OpenIBSQL( Format( 'SELECT * FROM %s WHERE uid = %d', [ Self.TheTableName, FCurrRecno] ) );
  case Dataset.Fields[ FieldNo-1 ].SQLType of
    SQL_TEXT, SQL_VARYING:
       Result:= 'C';
    SQL_DOUBLE, SQL_FLOAT, SQL_D_FLOAT:
       Result:= 'N';
    SQL_LONG, SQL_SHORT, SQL_INT64:
       Result:= 'I';
    SQL_TIMESTAMP, SQL_TYPE_TIME, SQL_TYPE_DATE:
       Result:= 'D';
    SQL_BLOB: Result:= 'B';
  end;
  IBCommitTrans( Dataset );
  Dataset.Close;
end;

procedure TEzIBTable.FieldPutNEx(FieldNo: Integer; const Value: String);
var
  Code: Integer;
  ValFloat: Double;
  ValInteger: Integer;
Begin
  case FieldType( FieldNo ) Of
    'C': StringPutN( FieldNo,Value);
    'N':
      Begin
        Val( Trim(Value), ValFloat, Code);
        If Code = 0 then
          FloatPutN( FieldNo,ValFloat )
        else
          FloatPutN( FieldNo, 0 );
      End;
    'I':
      Begin
        Val( Trim(Value), ValInteger, Code);
        If Code = 0 then
          IntegerPutN( FieldNo,ValInteger )
        else
          IntegerPutN( FieldNo, 0 );
      End;
    'D': DatePutN( FieldNo,StrToDate(Trim(Value)));
    'B': ;
  end;
end;

procedure TEzIBTable.FieldPutEx(const FieldName, Value: String);
var
  Code, ValInteger: Integer;
  ValFloat: Double;
Begin
  case FieldTypeEx( FieldNo(FieldName) ) Of
    'C': StringPut( FieldName,Value);
    'N':
      Begin
        Val( Trim(Value), ValFloat, Code);
        If Code = 0 then
          FloatPut( FieldName,ValFloat )
        else
          FloatPut( FieldName, 0 );
      End;
    'I':
      Begin
        Val( Trim(Value), ValInteger, Code);
        If Code = 0 then
          IntegerPut( FieldName,ValInteger )
        else
          IntegerPut( FieldName, 0 );
      End;
    'D': DatePut( FieldName,StrToDate(Trim(Value)));
    'B': ;
  end;
end;

End.
