Unit EzIndyGIS;

{$I EZ_FLAG.PAS}
{$DEFINE TRANSPORT_COMPRESSED} //uncomment if you want to compress entity when transporting
{$DEFINE MW_TRIAL_VERSION}
Interface

Uses
  SysUtils, Windows, Classes, Graphics, Controls, db, Forms,
  EzBaseGIS, ezbase, ezlib, ezprojections, ezrtree, ezbaseexpr, EzCtrls,
  idTCPClient;

Type

  TEzIndyLayer = Class;
  TEzIndyClientGIS = Class;
  TMWSparseList = Class;

  TEzIndyLayerInfo = Class( TEzBaseLayerInfo )
  Private
    Function GetTCPClient: TIdTCPClient;
    Function IsBuffered: Boolean;
    Function BufferGIS: TEzGIS;
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
  End;


  { TEzIndyTable - class used for accessing to the attached table }

  TEzIndyTable = Class(TEzBaseTable)
  Private
    FLayer: TEzIndyLayer;
    FLastSetRecno: Integer;
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
    Function BOF: Boolean; Override;
    Function EOF: Boolean; Override;
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
    Procedure FieldPutN( FieldNo: integer; Const Value: String ); Override;
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
    Function DBCreateTable( Const fname: String; AFieldList: TStringList ): boolean; Override;
    Function DBTableExists( const TableName: string ): Boolean; Override;
    Function DBDropTable( const TableName: string): Boolean; Override;
    Function DBDropIndex( const TableName: string): Boolean; Override;
    Function DBRenameTable( const Source, Target: string): Boolean; Override;

    Property Layer: TEzIndyLayer read FLayer write FLayer;
  End;


  { TEzIndyLayer - class definition }

  TEzIndyLayer = Class( TEzBaseLayer )
  Private
    FDBTable: TEzBaseTable;
    { FOR BUFFERING SetGraphicFilter method }
    FBufferList: TEzEntityList;
    FBufferCurrent: Integer;
    FRecnoList: TIntegerList;   // used for detecting last record numbers that were readen from server when TEzIndyClientGIS.TransportBufferSize > 0
    { For linking to a temporary local layer }
    FMWSparseList: TMWSparseList;  // the link of one record on the server to one record on the local computer
    FServerRecordCount: Integer;  // presumably the no. of records on the server. Initialized when created the local TEzIndyGIS.FBufferGIS
    FClientHasAllData: Boolean;
    Procedure TransportImage(AEntity: TEzEntity);
    Function GetLocalRecno( ServerRecno: Integer ): Integer;
    Procedure SetLocalRecno( ServerRecno, Value: Integer );
    Function GetLocalDataExists( ServerRecno: Integer ): Boolean;
    Procedure SetLocalDataExists( ServerRecno: Integer; Value: Boolean );
    Function LocalLayer: TEzBaseLayer;
    Function GetTCPClient: TIdTCPClient;
    Procedure GetNextBuffer;
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
    Function LoadEntityWithRecNo( RecNo: Longint ): TEzEntity; Override;
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
    Procedure FinishBatchInsert; Override;
    Procedure GetFieldList( Strings: TStrings ); Override;

    Procedure RebuildTree; Override;

    Procedure CopyRecord( SourceRecno, DestRecno: Integer ); Override;
    Function DefineScope( Const Scope: String ): Boolean; Override;
    Function DefinePolygonScope( Polygon: TEzEntity; Const Scope: String;
      Operator: TEzGraphicOperator ): Boolean; Override;
    Function IsClientServer: Boolean; Override;
    Function DeleteLayerFiles: Boolean; Override;
    Function GetExtensionForRecords( List: TIntegerList ): TEzRect; Override;

    { invalidating a record will cause the entity to be re-read from the server }
    Procedure InvalidateRecord(Index: Integer);

    Property LocalRecno[ServerRecno: Integer]: Integer read GetLocalRecno Write SetLocalRecno;
    Property LocalDataExists[ServerRecno: Integer]: Boolean read GetLocalDataExists Write SetLocalDataExists;
  End;

  { TEzIndyLayers - class definition }

  TEzIndyLayers = Class( TEzBaseLayers )
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

  { TMapInfo used in desktop }
  TEzIndyMapInfo = Class( TEzBaseMapInfo )
  Private
    Function GetTCPClient: TIdTCPClient;
    Function BufferGIS: TEzGIS;
    Function IsBuffered: Boolean;
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

  TEzTransportImages = (tiNonExistingOnly, tiAlwaysOverwrite, tiNone );

  TEzIndyClientGIS = Class(TEzBaseGIS)
  Private
    { the connection }
    FTCPClient: TIdTCPClient;
    FTransportBufferSize: Integer;
    FLogin: string;
    FPassword: string;
    FLoginPrompt: Boolean;
    { this is the buffer GIS used. All data coming from TCP/IP will be stored
      temporary on a subdirectory defined by property
      TEzIndyClientGIS.LayersSubdir: string;
      The file will be automatically overwritten when opening / closing the connexion
      Also, ClientDataBuffered property must be set to true
    }
    FBufferGIS: TEzGIS;
    FClientBuffered: Boolean;
    FDataBuffered: Boolean;
    FPersistentClientBuffered: Boolean;
    FNonBufferedLayers: TStrings;
    FTransportImages: TEzTransportImages;
    Procedure SetGISVersion( Const Value: TEzAbout );
    Function GetGISVersion: TEzAbout;
    Procedure SetIdTCPClient(Value: TIdTCPClient);
  Protected
    Procedure Notification( AComponent: TComponent; Operation: TOperation ); Override;
  Public
    Constructor Create( AOwner: TComponent ); Override;
    Destructor Destroy; Override;
    Function CreateLayer( Const LayerName: String; LayerType: TEzLayerType ): TEzBaseLayer; Override;
    Procedure Open; Override;
    Procedure SaveAs( Const Filename: String ); Override;
    Procedure AddGeoref( Const LayerName, FileName: String ); Override;
    Procedure CreateNew( Const FileName: String ); Override;
    Function IsClientServer: Boolean; Override;
    Procedure UpdateInfoFromServer;
    { This method forces invalidates the layers to force to be read from the server
      next time an entity on that layer is needed. If LayerName ='' all
      layers are forced }
    Procedure InvalidateClientBuffer( const LayerName: string );
    { This method read all the entities from the server to the client.
     If LayerName = '', all layers are loaded to local buffer map }
    Procedure LoadFullLayerToBuffer( const LayerName: string );
    Procedure LoadSymbolsFromServer;
    Procedure LoadVectorialFontsFromServer;
    Procedure LoadLineTypesFromServer;
    Procedure Connect;
    Procedure Disconnect;

  Published
    Property About: TEzAbout read GetGisVersion write SetGisVersion;
    Property TCPClient: TIdTCPClient read FTCPClient write SetIdTCPClient;
    Property Login: string read FLogin write FLogin;
    Property Password: string read FPassword write FPassword;
    Property LoginPrompt: Boolean read FLoginPrompt write FLoginPrompt;
    { this data defines the number of entities read from the server when a
      graphic filter is set or when repainting the drawbox }
    Property TransportBufferSize: Integer read FTransportBufferSize write FTransportBufferSize default 1000;
    // this property defines if a local buffer is used for buffering entities from the server
    Property ClientBuffered: Boolean read FClientBuffered write FClientBuffered default False;
    // if this property set to true, the database information is bring also to the client (Layer.DBTable information)
    Property DataBuffered: Boolean read FDataBuffered write FDataBuffered default False;
    // This property defines if the local buffered are mantained in the local subdirectory
    // between every open and close for the map
    Property PersistentClientBuffered: Boolean read FPersistentClientBuffered write FPersistentClientBuffered default False;
    // This property defines the name of the layers that always will be read from
    // the server when the drawbox is repainted
    Property NonBufferedLayers: TStrings Read FNonBufferedLayers;
    // this property defines what to do with raster images for entities on the server
    // none action, the raster image can be transparted if non existing locally, or always overwrite ever if exists
    Property TransportImages: TEzTransportImages read FTransportImages write FTransportImages;
  End;

  { A sparse list array }

  PPointer = ^Pointer;

  TSPAApply = Function( TheIndex: Integer; TheItem: Pointer ): Integer;

  TSecDir = Array[0..4095] Of Pointer;
  PSecDir = ^TSecDir;
  TSPAQuantum = ( SPASmall, SPALarge );

  TSparsePointerArray = Class( TObject )
  Private
    secDir: PSecDir;
    slotsInDir: Word;
    indexMask, secShift: Word;
    FHighBound: Integer;
    FSectionSize: Word;
    cachedIndex: Integer;
    cachedPointer: Pointer;
    Function GetAt( Index: Integer ): Pointer;
    Function MakeAt( Index: Integer ): PPointer;
    Procedure PutAt( Index: Integer; Item: Pointer );
  Public
    Constructor Create( Quantum: TSPAQuantum );
    Destructor Destroy; Override;

    Function ForAll( ApplyFunction: Pointer {TSPAApply} ): Integer;

    Procedure ResetHighBound;

    Property HighBound: Integer Read FHighBound;
    Property SectionSize: Word Read FSectionSize;
    Property Items[Index: Integer]: Pointer Read GetAt Write PutAt; Default;
  End;

  { TSparseList class }

  TSparseList = Class( TObject )
  Private
    FList: TSparsePointerArray;
    FCount: Integer;
    FQuantum: TSPAQuantum;
    Procedure NewList( Quantum: TSPAQuantum );
  Protected
    Procedure Error; Virtual;
    Function Get( Index: Integer ): Pointer;
    Procedure Put( Index: Integer; Item: Pointer );
  Public
    Constructor Create( Quantum: TSPAQuantum );
    Destructor Destroy; Override;
    Function Add( Item: Pointer ): Integer;
    Procedure Clear;
    Procedure Delete( Index: Integer );
    Procedure Exchange( Index1, Index2: Integer );
    Function First: Pointer;
    Function ForAll( ApplyFunction: Pointer {TSPAApply} ): Integer;
    Function IndexOf( Item: Pointer ): Integer;
    Procedure Insert( Index: Integer; Item: Pointer );
    Function Last: Pointer;
    Procedure Move( CurIndex, NewIndex: Integer );
    Procedure Pack;
    Function Remove( Item: Pointer ): Integer;
    Property Count: Integer Read FCount;
    Property Items[Index: Integer]: Pointer Read Get Write Put; Default;
  End;

  { TAggSparseList class }

  TMWSparseList = Class
  Private
    FList: TSparseList;
  Protected
    Function Get( Index: Integer ): Integer;
    Function GetDataExists( Index: Integer ): Boolean;
    Procedure Put( Index: Integer; Value: Integer );
    Procedure PutDataExists( Index: Integer; Value: Boolean );
    Procedure Error;
  Public
    Constructor Create( Capacity: Integer );
    Destructor Destroy; Override;
    Function HasData( Index: Integer ): Boolean;
    Procedure Delete( Index: Integer );
    Procedure Exchange( Index1, Index2: Integer );
    Procedure Insert( Index: Integer; Const Value: Integer );
    Procedure Clear;

    Property LocalRecno[Index: Integer]: Integer Read Get Write Put;
    Property DataExists[Index: Integer]: Boolean Read GetDataExists Write PutDataExists;
  End;

Implementation

Uses
  Inifiles, ezsystem, ezconsts, ezentities,
  ezbasicctrls, ezimpl, EzGisTiff
{$IFDEF TRANSPORT_COMPRESSED}
  , EzZLibUtil
{$ENDIF}
{$IFDEF LEVEL6}
  , Variants
{$ENDIF}
  ;

resourcestring
  SEz_GisIndyVersion = 'TEzIndyClientGIS Version 1.95 (Ene, 2003)';
  SUnassignedTCPCLient = 'Indy TIdTCPClient not assigned';


Type

  { Item management for TMWSparseList }

  PMWItem = ^TMWItem;
  TMWItem = Record
    LocalRecno: Integer;    // the record number in the local storage
    DataExists: Boolean;    // exists database information ?
  End;

  { Exception classes }

  EAggregateSparseListError = Class( Exception );

Function NewMWItem( ALocalRecno: Integer; ADataExists: Boolean ): PMWItem;
Begin
  New( Result );
  Result^.LocalRecno := ALocalRecno;
  Result^.DataExists := ADataExists;
End;

Procedure DisposeMWItem( P: PMWItem );
Begin
  If P=Nil then Exit;
  Dispose( P );
End;

{ TSparsePointerArray }

Const
  SPAIndexMask: Array[TSPAQuantum] Of Byte = ( 15, 255 );
  SPASecShift: Array[TSPAQuantum] Of Byte = ( 4, 8 );

Function ExpandDir( secDir: PSecDir; Var slotsInDir: Word;
  newSlots: Word ): PSecDir;
Begin
  Result := secDir;
  ReallocMem( Result, newSlots * SizeOf( Pointer ) );
  FillChar( Result^[slotsInDir], ( newSlots - slotsInDir ) * SizeOf( Pointer ), 0 );
  slotsInDir := newSlots;
End;

Function MakeSec( SecIndex: Integer; SectionSize: Word ): Pointer;
Var
  SecP: Pointer;
  Size: Word;
Begin
  Size := SectionSize * SizeOf( Pointer );
  GetMem( secP, size );
  FillChar( secP^, size, 0 );
  MakeSec := SecP
End;

Constructor TSparsePointerArray.Create( Quantum: TSPAQuantum );
Begin
  SecDir := Nil;
  SlotsInDir := 0;
  FHighBound := -1;
  FSectionSize := Word( SPAIndexMask[Quantum] ) + 1;
  IndexMask := Word( SPAIndexMask[Quantum] );
  SecShift := Word( SPASecShift[Quantum] );
  CachedIndex := -1
End;

Destructor TSparsePointerArray.Destroy;
Var
  i: Integer;
  size: Word;
Begin
  i := 0;
  size := FSectionSize * SizeOf( Pointer );
  While i < slotsInDir Do
  Begin
    If secDir^[i] <> Nil Then
      FreeMem( secDir^[i], size );
    Inc( i )
  End;

  If secDir <> Nil Then
    FreeMem( secDir, slotsInDir * SizeOf( Pointer ) );
End;

Function TSparsePointerArray.GetAt( Index: Integer ): Pointer;
Var
  byteP: PChar;
  secIndex: Cardinal;
Begin
  If Index = cachedIndex Then
    Result := cachedPointer
  Else
  Begin
    secIndex := Index Shr secShift;
    If secIndex >= slotsInDir Then
      byteP := Nil
    Else
    Begin
      byteP := secDir^[secIndex];
      If byteP <> Nil Then
      Begin
        Inc( byteP, ( Index And indexMask ) * SizeOf( Pointer ) );
      End
    End;
    If byteP = Nil Then
      Result := Nil
    Else
      Result := PPointer( byteP )^;
    cachedIndex := Index;
    cachedPointer := Result
  End
End;

Function TSparsePointerArray.MakeAt( Index: Integer ): PPointer;
Var
  dirP: PSecDir;
  p: Pointer;
  byteP: PChar;
  secIndex: Word;
Begin
  secIndex := Index Shr secShift; { Unsigned shift }
  If secIndex >= slotsInDir Then
    dirP := expandDir( secDir, slotsInDir, secIndex + 1 )
  Else
    dirP := secDir;

  secDir := dirP;
  p := dirP^[secIndex];
  If p = Nil Then
  Begin
    p := makeSec( secIndex, FSectionSize );
    dirP^[secIndex] := p
  End;
  byteP := p;
  Inc( byteP, ( Index And indexMask ) * SizeOf( Pointer ) );
  If Index > FHighBound Then
    FHighBound := Index;
  Result := PPointer( byteP );
  cachedIndex := -1
End;

Procedure TSparsePointerArray.PutAt( Index: Integer; Item: Pointer );
Begin
  If ( Item <> Nil ) Or ( GetAt( Index ) <> Nil ) Then
  Begin
    MakeAt( Index )^ := Item;
    If Item = Nil Then
      ResetHighBound
  End
End;

Function TSparsePointerArray.ForAll( ApplyFunction: Pointer {TSPAApply} ):
  Integer;
Var
  itemP: PChar;
  item: Pointer;
  i, callerBP: Cardinal;
  j, index: Integer;
Begin
  Result := 0;
  i := 0;
  Asm
    mov   eax,[ebp]
    mov   callerBP,eax
  End;
  While ( i < slotsInDir ) And ( Result = 0 ) Do
  Begin
    itemP := secDir^[i];
    If itemP <> Nil Then
    Begin
      j := 0;
      index := i Shl SecShift;
      While ( j < FSectionSize ) And ( Result = 0 ) Do
      Begin
        item := PPointer( itemP )^;
        If item <> Nil Then
          { ret := ApplyFunction(index, item.Ptr); }
          Asm
            mov   eax,index
            mov   edx,item
            push  callerBP
            call  ApplyFunction
            pop   ecx
            mov   @Result,eax
          End;
        Inc( itemP, SizeOf( Pointer ) );
        Inc( j );
        Inc( index )
      End
    End;
    Inc( i )
  End;
End;

Procedure TSparsePointerArray.ResetHighBound;
Var
  NewHighBound: Integer;

  Function Detector( TheIndex: Integer; TheItem: Pointer ): Integer; Far;
  Begin
    If TheIndex > FHighBound Then
      Result := 1
    Else
    Begin
      Result := 0;
      If TheItem <> Nil Then
        NewHighBound := TheIndex
    End
  End;

Begin
  NewHighBound := -1;
  ForAll( @Detector );
  FHighBound := NewHighBound
End;

{ TSparseList }

Constructor TSparseList.Create( Quantum: TSPAQuantum );
Begin
  NewList( Quantum )
End;

Destructor TSparseList.Destroy;
Begin
  If FList <> Nil Then
    FList.Destroy
End;

Function TSparseList.Add( Item: Pointer ): Integer;
Begin
  Result := FCount;
  FList[Result] := Item;
  Inc( FCount )
End;

Procedure TSparseList.Clear;
Begin
  FList.Destroy;
  NewList( FQuantum );
  FCount := 0
End;

Procedure TSparseList.Delete( Index: Integer );
Var
  I: Integer;
Begin
  If ( Index < 0 ) Or ( Index >= FCount ) Then
    Exit;
  For I := Index To FCount - 1 Do
    FList[I] := FList[I + 1];
  FList[FCount] := Nil;
  Dec( FCount );
End;

Procedure TSparseList.Error;
Begin
  Raise EListError.Create( 'List Index Error!' )
End;

Procedure TSparseList.Exchange( Index1, Index2: Integer );
Var
  temp: Pointer;
Begin
  temp := Get( Index1 );
  Put( Index1, Get( Index2 ) );
  Put( Index2, temp );
End;

Function TSparseList.First: Pointer;
Begin
  Result := Get( 0 )
End;

{ Jump to TSparsePointerArray.ForAll so that it looks like it was called
  from our caller, so that the BP trick works. }

Function TSparseList.ForAll( ApplyFunction: Pointer {TSPAApply} ): Integer; Assembler;
Asm
        MOV     EAX,[EAX].TSparseList.FList
        JMP     TSparsePointerArray.ForAll
End;

Function TSparseList.Get( Index: Integer ): Pointer;
Begin
  If Index < 0 Then
    Error;
  Result := FList[Index]
End;

Function TSparseList.IndexOf( Item: Pointer ): Integer;
Var
  MaxIndex, Index: Integer;

  Function IsTheItem( TheIndex: Integer; TheItem: Pointer ): Integer; Far;
  Begin
    If TheIndex > MaxIndex Then
      Result := -1 { Bail out }
    Else If TheItem <> Item Then
      Result := 0
    Else
    Begin
      Result := 1; { Found it, stop traversal }
      Index := TheIndex
    End
  End;

Begin
  Index := -1;
  MaxIndex := FList.HighBound;
  FList.ForAll( @IsTheItem );
  Result := Index
End;

Procedure TSparseList.Insert( Index: Integer; Item: Pointer );
Var
  i: Integer;
Begin
  If Index < 0 Then
    Error;
  I := FCount;
  While I > Index Do
  Begin
    FList[i] := FList[i - 1];
    Dec( i )
  End;
  FList[Index] := Item;
  If Index > FCount Then
    FCount := Index;
  Inc( FCount )
End;

Function TSparseList.Last: Pointer;
Begin
  Result := Get( FCount - 1 );
End;

Procedure TSparseList.Move( CurIndex, NewIndex: Integer );
Var
  Item: Pointer;
Begin
  If CurIndex <> NewIndex Then
  Begin
    Item := Get( CurIndex );
    Delete( CurIndex );
    Insert( NewIndex, Item );
  End;
End;

Procedure TSparseList.NewList( Quantum: TSPAQuantum );
Begin
  FQuantum := Quantum;
  FList := TSparsePointerArray.Create( Quantum )
End;

Procedure TSparseList.Pack;
Var
  i: Integer;
Begin
  For i := FCount - 1 Downto 0 Do
    If Items[i] = Nil Then
      Delete( i )
End;

Procedure TSparseList.Put( Index: Integer; Item: Pointer );
Begin
  If Index < 0 Then Error;
  FList[Index] := Item;
  FCount := FList.HighBound + 1
End;

Function TSparseList.Remove( Item: Pointer ): Integer;
Begin
  Result := IndexOf( Item );
  If Result <> -1 Then
    Delete( Result )
End;

{ TMWSparseList }

Constructor TMWSparseList.Create( Capacity: Integer );
Var
  quantum: TSPAQuantum;
Begin
  If Capacity > 256 Then
    quantum := SPALarge
  Else
    quantum := SPASmall;
  FList := TSparseList.Create( Quantum );
End;

Destructor TMWSparseList.Destroy;
Begin
  If FList <> Nil Then
  Begin
    Clear;
    FList.Destroy
  End
End;

Function TMWSparseList.HasData( Index: Integer ): Boolean;
Begin
  Result:= FList[Index] <> Nil;
End;

Function TMWSparseList.Get( Index: Integer ): Integer;
Var
  p: PMWItem;
Begin
  p := PMWItem( FList[Index] );
  If p = Nil Then
    Result := 0
  Else
    Result := p^.LocalRecno;
End;

Function TMWSparseList.GetDataExists( Index: Integer ): Boolean;
Var
  p: PMWItem;
Begin
  p := PMWItem( FList[Index] );
  If p = Nil Then
    Result := False
  Else
    Result := p^.DataExists;
End;

Procedure TMWSparseList.Put( Index: Integer; Value: Integer );
Var
  p: PMWItem;
Begin
  p := PMWItem( FList[Index] );
  If p = Nil Then
    FList[Index] := NewMWItem( Value, False )
  Else
    p^.LocalRecno := Value;
End;

Procedure TMWSparseList.PutDataExists( Index: Integer; Value: Boolean );
Var
  p: PMWItem;
Begin
  p := PMWItem( FList[Index] );
  If p = Nil Then
    FList[Index] := NewMWItem( 0, Value )
  Else
    p^.DataExists := Value;
End;

Procedure TMWSparseList.Error;
Begin
  Raise EAggregateSparseListError.Create( 'Put Counts Error!' )
End;

Procedure TMWSparseList.Delete( Index: Integer );
Var
  p: PMWItem;
Begin
  p := PMWItem( FList[Index] );
  If p <> Nil Then
    DisposeMWItem( p );
  FList.Delete( Index );
End;

Procedure TMWSparseList.Exchange( Index1, Index2: Integer );
Begin
  FList.Exchange( Index1, Index2 );
End;

Procedure TMWSparseList.Insert( Index: Integer; Const Value: Integer );
Begin
  FList.Insert( Index, NewMWItem( Value, False ) );
End;

Procedure TMWSparseList.Clear;

  Function ClearItem( TheIndex: Integer; TheItem: Pointer ): Integer; Far;
  Begin
    DisposeMWItem( PMWItem( TheItem ) ); { Item guaranteed non-nil }
    Result := 0
  End;

Begin
  FList.ForAll( @ClearItem );
  FList.Clear;
End;


  {------------------------------------------------------------------------------}
  {                  Trial Version stuff                                         }
  {------------------------------------------------------------------------------}

{$IFDEF MW_TRIAL_VERSION}
Const
  MAX_HOURS = 50;

Resourcestring
  SHiddenFile = 'MWHLP.DLL';
  STimeExpired = 'Demo time of TEzIndyClientGIS Component has expired !';
  SDemoVersion =
    'You are using a demonstration version of TEzIndyClientGIS Component' + CrLf +
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
  ADOGisInstances: Integer;
  ADOSecurityFile: String; { Security File }

Function BuildSecurityFile: boolean;
Var
  IO: TFileStream;
  SecFileRec: TSecurityFileRec;
  I: integer;
  R: TDateTime;
Begin
  IO := TFileStream.Create( ADOSecurityFile, fmCreate );
  Try
    FillChar( SecFileRec, SizeOf( SecFileRec ), 0 );
    SecFileRec.MagicNumber := MAGIC_NUMBER;
    IO.Write( SecFileRec, SizeOf( SecFileRec ) );
    { write random data }
    For I := 1 To 1500 Do
    Begin
      R := Random;
      IO.Write( R, SizeOf( double ) );
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
  If Not FileExists( ADOSecurityFile ) Then
    Exit;
  IO := TFileStream.Create( ADOSecurityFile, fmOpenRead Or fmShareDenyNone );
  Try
    IO.Read( SecFileRec, SizeOf( SecFileRec ) );
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
  If Not FileExists( ADOSecurityFile ) Then Exit;
  IO := TFileStream.Create( ADOSecurityFile, fmOpenReadWrite Or fmShareDenyNone );
  Try
    IO.Read( SecFileRec, SizeOf( SecFileRec ) );
    If SecFileRec.MagicNumber <> MAGIC_NUMBER Then Exit;
    TimeEnd := GetTickCount;
    SecsUsed := ( TimeEnd - TimeStart ) Div 1000;
    With SecFileRec Do
    Begin
      Inc( Seconds, SecsUsed );
      Inc( Runs );
    End;
    IO.Seek( 0, 0 );
    IO.Write( SecFileRec, SizeOf( SecFileRec ) );
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
  If Not FileExists( ADOSecurityFile ) Then Exit;
  IO := TFileStream.Create( ADOSecurityFile, fmOpenRead Or fmShareDenyNone );
  Try
    IO.Read( SecFileRec, SizeOf( SecFileRec ) );
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
  ADOSecurityFile := SystemDir + SHiddenFile;

  If Not FileExists( ADOSecurityFile ) And Not BuildSecurityFile Then Exit;

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

      Stream := TFileStream.Create( ADOSecurityFile, fmOpenReadWrite Or fmShareDenyNone );
      Try
        Stream.Read( SecFileRec, SizeOf( SecFileRec ) );
        SecFileRec.LastCheck := SecondsUsed;
        Stream.Seek( 0, 0 );
        Stream.Write( SecFileRec, SizeOf( SecFileRec ) );
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
{                  TEzIndyTable - class implementation                          }
{------------------------------------------------------------------------------}

Function TEzIndyTable.GetActive: Boolean;
Begin
  with TEzIndyClientGIS(FLayer.Layers.GIS).FTCPClient do
  begin
    WriteLn('DBT_GETACTIVE');
    WriteLn(FLayer.Name);
    Result:= ReadSmallInt <> 0;
  end;
End;

Procedure TEzIndyTable.SetActive( Value: Boolean );
Begin
  with TEzIndyClientGIS(FLayer.Layers.GIS).FTCPClient do
  begin
    WriteLn('DBT_SETACTIVE');
    WriteLn(FLayer.Name);
    WriteSmallInt( Ord(Value));
  end;
  If TEzIndyClientGIS(FLayer.Layers.GIS).FClientBuffered Then
    FLayer.LocalLayer.DBTable.Active:= Value;
End;

Function TEzIndyTable.GetRecNo: Integer;
Begin
  with TEzIndyClientGIS(FLayer.Layers.GIS).FTCPClient do
  begin
    WriteLn('DBT_GETRECNO');
    WriteLn(FLayer.Name);
    Result:= ReadInteger;
  end;
End;

Procedure TEzIndyTable.SetRecNo( Value: Integer );
Begin
  with TEzIndyClientGIS(FLayer.Layers.GIS) do
    {If FClientBuffered and FLayer.LocalDataExists[Value-1] Then
      // set position to corresponding record number of local storage
      FLayer.LocalLayer.DBTable.Recno:= FLayer.LocalRecno[Value-1]
    else }
      with FTCPClient do
      Begin
        WriteLn('DBT_SETRECNO');
        WriteLn(FLayer.Name);
        WriteInteger(Value);
      End;
  FLastSetRecno:= Value;
End;

Procedure TEzIndyTable.Append( NewRecno: Integer );
Begin
  with TEzIndyClientGIS(FLayer.Layers.GIS).FTCPClient do
  Begin
    WriteLn('DBT_APPEND');
    WriteLn(FLayer.Name);
    WriteInteger(NewRecno);
  End;
End;

Function TEzIndyTable.BOF: Boolean;
Begin
  with TEzIndyClientGIS(FLayer.Layers.GIS) do
    {If FClientBuffered and (FLastSetRecno>0) and FLayer.LocalDataExists[FLastSetRecno-1] Then
      Result:= FLayer.LocalLayer.DBTable.BOF
    else }
      with FTCPClient do
      Begin
        WriteLn('DBT_BOF');
        WriteLn(FLayer.Name);
        Result := ReadSmallInt <> 0;
      End;
End;

Function TEzIndyTable.EOF: Boolean;
Begin
  with TEzIndyClientGIS(FLayer.Layers.GIS) do
    {If FClientBuffered and (FLastSetRecno>0) and FLayer.LocalDataExists[FLastSetRecno-1] Then
      Result:= FLayer.LocalLayer.EOF
    else}
      with FTCPClient do
      Begin
        WriteLn('DBT_EOF');
        WriteLn(FLayer.Name);
        Result := ReadSmallInt <> 0;
      End;
End;

Function TEzIndyTable.DateGet( Const FieldName: String ): TDateTime;
Begin
  with TEzIndyClientGIS(FLayer.Layers.GIS) do
    {If FClientBuffered and (FLastSetRecno>0) and FLayer.LocalDataExists[FLastSetRecno-1] Then
      Result:= FLayer.LocalLayer.DBTable.DateGet(FieldName)
    else}
      with FTCPClient do
      Begin
        WriteLn('DBT_DATEGET');
        WriteLn(FLayer.Name);
        WriteLn(FieldName);
        ReadBuffer(Result, SizeOf(Result));
      End;
End;

Function TEzIndyTable.DateGetN( FieldNo: integer ): TDateTime;
Begin
  with TEzIndyClientGIS(FLayer.Layers.GIS).FTCPClient do
  Begin
    WriteLn('DBT_DATEGETN');
    WriteLn(FLayer.Name);
    WriteInteger(FieldNo);
    ReadBuffer(Result, SizeOf(Result));
  End;
End;

Function TEzIndyTable.Deleted: Boolean;
Begin
  with TEzIndyClientGIS(FLayer.Layers.GIS).FTCPClient do
  Begin
    WriteLn('DBT_DELETED');
    WriteLn(FLayer.Name);
    Result := ReadSmallInt <> 0;
  End;
End;

Function TEzIndyTable.Field( FieldNo: integer ): String;
Begin
  with TEzIndyClientGIS(FLayer.Layers.GIS).FTCPClient do
  Begin
    WriteLn('DBT_FIELD');
    WriteLn(FLayer.Name);
    WriteInteger(FieldNo);
    Result := ReadLn;
  End;
End;

Function TEzIndyTable.FieldCount: integer;
Begin
  with TEzIndyClientGIS(FLayer.Layers.GIS).FTCPClient do
  Begin
    WriteLn('DBT_FIELDCOUNT');
    WriteLn(FLayer.Name);
    Result := ReadInteger;
  End;
End;

Function TEzIndyTable.FieldDec( FieldNo: integer ): integer;
Begin
  with TEzIndyClientGIS(FLayer.Layers.GIS).FTCPClient do
  Begin
    WriteLn('DBT_FIELDDEC');
    WriteLn(FLayer.Name);
    WriteInteger(FieldNo);
    Result := ReadInteger;
  End;
End;

Function TEzIndyTable.FieldGet( Const FieldName: String ): String;
Begin
  with TEzIndyClientGIS(FLayer.Layers.GIS).FTCPClient do
  Begin
    WriteLn('DBT_FIELDGET');
    WriteLn(FLayer.Name);
    WriteLn(FieldName);
    Result := ReadLn;
  End;
End;

Function TEzIndyTable.FieldGetN( FieldNo: integer ): String;
Begin
  with TEzIndyClientGIS(FLayer.Layers.GIS).FTCPClient do
  Begin
    WriteLn('DBT_FIELDGETN');
    WriteLn(FLayer.Name);
    WriteInteger(FieldNo);
    Result := ReadLn;
  End;
End;

Function TEzIndyTable.FieldLen( FieldNo: integer ): integer;
Begin
  with TEzIndyClientGIS(FLayer.Layers.GIS).FTCPClient do
  Begin
    WriteLn('DBT_FIELDLEN');
    WriteLn(FLayer.Name);
    WriteInteger(FieldNo);
    Result := ReadInteger;
  End;
End;

Function TEzIndyTable.FieldNo( Const FieldName: String ): integer;
begin
  with TEzIndyClientGIS(FLayer.Layers.GIS).FTCPClient do
  Begin
    WriteLn('DBT_FIELDNO',);
    WriteLn(FLayer.Name);
    WriteLn(FieldName);
    Result := ReadInteger;
  End;
End;

Function TEzIndyTable.FieldType( FieldNo: integer ): char;
Begin
  with TEzIndyClientGIS(FLayer.Layers.GIS).FTCPClient do
  Begin
    WriteLn('DBT_FIELDTYPE');
    WriteLn(FLayer.Name);
    WriteInteger(FieldNo);
    Result := Char(ReadSmallInt);
  End;
End;

Function TEzIndyTable.Find( Const ss: String; IsExact, IsNear: Boolean ): Boolean;
Begin
  with TEzIndyClientGIS(FLayer.Layers.GIS).FTCPClient do
  Begin
    WriteLn('DBT_FIND');
    WriteLn(FLayer.Name);
    WriteLn(ss);
    WriteSmallInt(Ord(IsExact));
    WriteSmallInt(Ord(IsNear));
    Result := ReadSmallInt <> 0;
  End;
End;

Function TEzIndyTable.FloatGet( Const Fieldname: String ): Double;
Begin
  with TEzIndyClientGIS(FLayer.Layers.GIS).FTCPClient do
  Begin
    WriteLn('DBT_FLOATGET');
    WriteLn(FLayer.Name);
    WriteLn(FieldName);
    Readbuffer(Result,SizeOf(result));
  End;
End;

Function TEzIndyTable.FloatGetN( FieldNo: Integer ): Double;
Begin
  with TEzIndyClientGIS(FLayer.Layers.GIS).FTCPClient do
  Begin
    WriteLn('DBT_FLOATGETN');
    WriteLn(FLayer.Name);
    WriteInteger(FieldNo);
    Readbuffer(Result,SizeOf(result));
  End;
End;

Function TEzIndyTable.IndexCount: integer;
Begin
  with TEzIndyClientGIS(FLayer.Layers.GIS).FTCPClient do
  Begin
    WriteLn('DBT_INDEXCOUNT');
    WriteLn(FLayer.Name);
    Result:= ReadInteger;
  End;
End;

Function TEzIndyTable.IndexAscending( Value: integer ): Boolean;
Begin
  with TEzIndyClientGIS(FLayer.Layers.GIS).FTCPClient do
  Begin
    WriteLn('DBT_INDEXASCENDING');
    WriteLn(FLayer.Name);
    WriteInteger(Value);
    Result:= ReadSmallInt <> 0;
  End;
End;

Function TEzIndyTable.Index( Const INames, Tag: String ): integer;
var
  atag:string;
Begin
  atag:=tag;
  with TEzIndyClientGIS(FLayer.Layers.GIS).FTCPClient do
  Begin
    WriteLn('DBT_INDEX');
    WriteLn(FLayer.Name);
    WriteLn(INames);
    WriteLn(aTag);
    Result:= ReadInteger;
  End;
End;

Function TEzIndyTable.IndexCurrent: String;
Begin
  with TEzIndyClientGIS(FLayer.Layers.GIS).FTCPClient do
  Begin
    WriteLn('DBT_INDEXCURRENT');
    WriteLn(FLayer.Name);
    Result:= ReadLn;
  End;
End;

Function TEzIndyTable.IndexUnique( Value: integer ): Boolean;
Begin
  with TEzIndyClientGIS(FLayer.Layers.GIS).FTCPClient do
  Begin
    WriteLn('DBT_INDEXUNIQUE');
    WriteLn(FLayer.Name);
    Result:= ReadSmallInt <> 0;
  End;
End;

Function TEzIndyTable.IndexExpression( Value: integer ): String;
Begin
  with TEzIndyClientGIS(FLayer.Layers.GIS).FTCPClient do
  Begin
    WriteLn('DBT_INDEXEXPRESSION');
    WriteLn(FLayer.Name);
    WriteInteger(Value);
    Result:= ReadLn;
  End;
End;

Function TEzIndyTable.IndexTagName( Value: integer ): String;
Begin
  with TEzIndyClientGIS(FLayer.Layers.GIS).FTCPClient do
  Begin
    WriteLn('DBT_INDEXTAGNAME');
    WriteLn(FLayer.Name);
    WriteInteger(Value);
    Result:= ReadLn;
  End;
End;

Function TEzIndyTable.IndexFilter( Value: integer ): String;
Begin
  with TEzIndyClientGIS(FLayer.Layers.GIS).FTCPClient do
  Begin
    WriteLn('DBT_INDEXFILTER');
    WriteLn(FLayer.Name);
    WriteInteger(Value);
    Result:= ReadLn;
  End;
End;

Function TEzIndyTable.IntegerGet( Const FieldName: String ): Integer;
Begin
  with TEzIndyClientGIS(FLayer.Layers.GIS).FTCPClient do
  Begin
    WriteLn('DBT_INTEGERGET');
    WriteLn(FLayer.Name);
    WriteLn(FieldName);
    Result:= ReadInteger;
  End;
End;

Function TEzIndyTable.IntegerGetN( FieldNo: integer ): Integer;
Begin
  with TEzIndyClientGIS(FLayer.Layers.GIS).FTCPClient do
  Begin
    WriteLn('DBT_INTEGERGETN');
    WriteLn(FLayer.Name);
    WriteInteger(FieldNo);
    Result:= ReadInteger;
  End;
End;

Function TEzIndyTable.LogicGet( Const FieldName: String ): Boolean;
Begin
  with TEzIndyClientGIS(FLayer.Layers.GIS).FTCPClient do
  Begin
    WriteLn('DBT_LOGICGET');
    WriteLn(FLayer.Name);
    WriteLn(FieldName);
    Result:= ReadSmallInt<>0;
  End;
End;

Function TEzIndyTable.LogicGetN( FieldNo: integer ): Boolean;
Begin
  with TEzIndyClientGIS(FLayer.Layers.GIS).FTCPClient do
  Begin
    WriteLn('DBT_LOGICGETN');
    WriteLn(FLayer.Name);
    WriteInteger(FieldNo);
    Result:= ReadSmallInt<>0;
  End;
End;

Procedure TEzIndyTable.MemoSave( Const FieldName: String; Stream: TStream );
Begin
  with TEzIndyClientGIS(FLayer.Layers.GIS).FTCPClient do
  Begin
    WriteLn('DBT_MEMOSAVE');
    WriteLn(FLayer.Name);
    WriteLn(FieldName);
{$IFDEF TRANSPORT_COMPRESSED}
    CompressmemStream(TMemoryStream(Stream), 1);
    Stream.Position:= 0;
{$ENDIF}
    OpenWriteBuffer;
    WriteStream(Stream,true,true);
    CloseWriteBuffer;
  End;
End;

Procedure TEzIndyTable.MemoSaveN( FieldNo: integer; Stream: TStream );
Begin
  with TEzIndyClientGIS(FLayer.Layers.GIS).FTCPClient do
  Begin
    WriteLn('DBT_MEMOSAVEN');
    WriteLn(FLayer.Name);
    WriteInteger(FieldNo);
{$IFDEF TRANSPORT_COMPRESSED}
    CompressmemStream(TMemoryStream(Stream), 1);
    Stream.Position:= 0;
{$ENDIF}
    OpenWriteBuffer;
    WriteStream(Stream,true,true);
    CloseWriteBuffer;
  End;
End;

Function TEzIndyTable.MemoSize( Const FieldName: String ): Integer;
Begin
  with TEzIndyClientGIS(FLayer.Layers.GIS).FTCPClient do
  Begin
    WriteLn('DBT_MEMOSIZE');
    WriteLn(FLayer.Name);
    WriteLn(FieldName);
    Result:= ReadInteger;
  End;
End;

Function TEzIndyTable.MemoSizeN( FieldNo: integer ): Integer;
Begin
  with TEzIndyClientGIS(FLayer.Layers.GIS).FTCPClient do
  Begin
    WriteLn('DBT_MEMOSIZEN');
    WriteLn(FLayer.Name);
    WriteInteger(FieldNo);
    Result:= ReadInteger;
  End;
End;

Function TEzIndyTable.RecordCount: Integer;
Begin
  with TEzIndyClientGIS(FLayer.Layers.GIS).FTCPClient do
  Begin
    WriteLn('DBT_RECORDCOUNT');
    WriteLn(FLayer.Name);
    Result:= ReadInteger;
  End;
End;

Function TEzIndyTable.StringGet( Const FieldName: String ): String;
Begin
  with TEzIndyClientGIS(FLayer.Layers.GIS).FTCPClient do
  Begin
    WriteLn('DBT_STRINGGET');
    WriteLn(FLayer.Name);
    WriteLn(FieldName);
    Result:= ReadLn;
  End;
End;

Function TEzIndyTable.StringGetN( FieldNo: integer ): String;
Begin
  with TEzIndyClientGIS(FLayer.Layers.GIS).FTCPClient do
  Begin
    WriteLn('DBT_STRINGGETN');
    WriteLn(FLayer.Name);
    WriteInteger(FieldNo);
    Result:= ReadLn;
  End;
End;

Procedure TEzIndyTable.DatePut( Const FieldName: String; value: TDateTime );
Begin
  with TEzIndyClientGIS(FLayer.Layers.GIS).FTCPClient do
  Begin
    WriteLn('DBT_DATEPUT');
    WriteLn(FLayer.Name);
    WriteLn(FieldName);
    WriteBuffer(value,SizeOf(value));
  End;
End;

Procedure TEzIndyTable.DatePutN( FieldNo: integer; value: TDateTime );
Begin
  with TEzIndyClientGIS(FLayer.Layers.GIS).FTCPClient do
  Begin
    WriteLn('DBT_DATEPUTN');
    WriteLn(FLayer.Name);
    WriteInteger(FieldNo);
    WriteBuffer(value,SizeOf(value));
  End;
End;

Procedure TEzIndyTable.Delete;
Begin
  with TEzIndyClientGIS(FLayer.Layers.GIS).FTCPClient do
  Begin
    WriteLn('DBT_DELETE');
    WriteLn(FLayer.Name);
  End;
End;

Procedure TEzIndyTable.Edit;
Begin
  with TEzIndyClientGIS(FLayer.Layers.GIS).FTCPClient do
  Begin
    WriteLn('DBT_EDIT');
    WriteLn(FLayer.Name);
  End;
End;

Procedure TEzIndyTable.FieldPut( Const FieldName, Value: String );
Begin
  with TEzIndyClientGIS(FLayer.Layers.GIS).FTCPClient do
  Begin
    WriteLn('DBT_FIELDPUT');
    WriteLn(FLayer.Name);
    WriteLn(FieldName);
    WriteLn(Value);
  End;
End;

Procedure TEzIndyTable.FieldPutN( FieldNo: integer; Const Value: String );
Begin
  with TEzIndyClientGIS(FLayer.Layers.GIS).FTCPClient do
  Begin
    WriteLn('DBT_FIELDPUTN');
    WriteLn(FLayer.Name);
    WriteInteger(FieldNo);
    WriteLn(Value);
  End;
End;

Procedure TEzIndyTable.First;
Begin
  with TEzIndyClientGIS(FLayer.Layers.GIS).FTCPClient do
  Begin
    WriteLn('DBT_FIRST');
    WriteLn(FLayer.Name);
  End;
End;

Procedure TEzIndyTable.FloatPut( Const FieldName: String; Const Value: Double );
Begin
  with TEzIndyClientGIS(FLayer.Layers.GIS).FTCPClient do
  Begin
    WriteLn('DBT_FLOATPUT');
    WriteLn(FLayer.Name);
    WriteLn(FieldName);
    WriteBuffer(Value,SizeOf(value));
  End;
End;

Procedure TEzIndyTable.FloatPutN( FieldNo: integer; Const Value: Double );
Begin
  with TEzIndyClientGIS(FLayer.Layers.GIS).FTCPClient do
  Begin
    WriteLn('DBT_FLOATPUTN');
    WriteLn(FLayer.Name);
    WriteInteger(FieldNo);
    WriteBuffer(Value,SizeOf(value));
  End;
End;

Procedure TEzIndyTable.FlushDB;
Begin
  with TEzIndyClientGIS(FLayer.Layers.GIS).FTCPClient do
  Begin
    WriteLn('DBT_FLUSHDB');
    WriteLn(FLayer.Name);
  End;
End;

Procedure TEzIndyTable.Go( n: Integer );
Begin
  with TEzIndyClientGIS(FLayer.Layers.GIS).FTCPClient do
  Begin
    WriteLn('DBT_GO');
    WriteLn(FLayer.Name);
    WriteInteger(n);
  End;
End;

Procedure TEzIndyTable.IndexOn( Const IName, tag, keyexp, forexp: String;
  uniq: TEzIndexUnique; ascnd: TEzSortStatus );
var
  atag:string;
Begin
  atag:=tag;
  with TEzIndyClientGIS(FLayer.Layers.GIS).FTCPClient do
  Begin
    WriteLn('DBT_INDEXON');
    WriteLn(FLayer.Name);
    WriteLn(IName);
    WriteLn(aTag);
    WriteLn(keyexp);
    WriteLn(forexp);
    WriteSmallInt(ord(uniq));
    WriteSmallInt(ord(ascnd));
  End;
End;

Procedure TEzIndyTable.IntegerPut( Const Fieldname: String; Value: Integer );
Begin
  with TEzIndyClientGIS(FLayer.Layers.GIS).FTCPClient do
  Begin
    WriteLn('DBT_INTEGERPUT');
    WriteLn(FLayer.Name);
    WriteLn(Fieldname);
    WriteInteger(value);
  End;
End;

Procedure TEzIndyTable.IntegerPutN( FieldNo: integer; Value: Integer );
Begin
  with TEzIndyClientGIS(FLayer.Layers.GIS).FTCPClient do
  Begin
    WriteLn('DBT_INTEGERPUTN');
    WriteLn(FLayer.Name);
    WriteInteger(FieldNo);
    WriteInteger(value);
  End;
End;

Procedure TEzIndyTable.Last;
Begin
  with TEzIndyClientGIS(FLayer.Layers.GIS).FTCPClient do
  Begin
    WriteLn('DBT_LAST');
    WriteLn(FLayer.Name);
  End;
End;

Procedure TEzIndyTable.LogicPut( Const fieldname: String; value: Boolean );
Begin
  with TEzIndyClientGIS(FLayer.Layers.GIS).FTCPClient do
  Begin
    WriteLn('DBT_LOGICPUT');
    WriteLn(FLayer.Name);
    WriteLn(FieldName);
    WriteSmallInt(Ord(value));
  End;
End;

Procedure TEzIndyTable.LogicPutN( fieldno: integer; value: Boolean );
Begin
  with TEzIndyClientGIS(FLayer.Layers.GIS).FTCPClient do
  Begin
    WriteLn('DBT_LOGICPUTN');
    WriteLn(FLayer.Name);
    WriteInteger(FieldNo);
    WriteSmallInt(Ord(value));
  End;
End;

Procedure TEzIndyTable.MemoLoad( Const fieldname: String; stream: TStream );
Begin
  with TEzIndyClientGIS(FLayer.Layers.GIS).FTCPClient do
  Begin
    WriteLn('DBT_MEMOLOAD');
    WriteLn(FLayer.Name);
    WriteLn(FieldName);
    ReadStream(Stream,-1,False);
{$IFDEF TRANSPORT_COMPRESSED}
    Stream.Position:= 0;
    DeCompressmemStream(TMemoryStream(Stream));
{$ENDIF}
    Stream.Position:= 0;
  End;
End;

Procedure TEzIndyTable.MemoLoadN( fieldno: integer; stream: TStream );
Begin
  with TEzIndyClientGIS(FLayer.Layers.GIS).FTCPClient do
  Begin
    WriteLn('DBT_MEMOLOADN');
    WriteLn(FLayer.Name);
    WriteInteger(FieldNo);
    ReadStream(Stream,-1,False);
{$IFDEF TRANSPORT_COMPRESSED}
    Stream.Position:= 0;
    DeCompressmemStream(TMemoryStream(Stream));
{$ENDIF}
    Stream.Position:= 0;
  End;
End;

Procedure TEzIndyTable.Next;
Begin
  with TEzIndyClientGIS(FLayer.Layers.GIS).FTCPClient do
  Begin
    WriteLn('DBT_NEXT');
    WriteLn(FLayer.Name);
  End;
End;

Procedure TEzIndyTable.Pack;
Begin
  with TEzIndyClientGIS(FLayer.Layers.GIS).FTCPClient do
  Begin
    WriteLn('DBT_PACK');
    WriteLn(FLayer.Name);
  End;
End;

Procedure TEzIndyTable.Post;
Begin
  with TEzIndyClientGIS(FLayer.Layers.GIS).FTCPClient do
  Begin
    WriteLn('DBT_POST');
    WriteLn(FLayer.Name);
  End;
End;

Procedure TEzIndyTable.Prior;
Begin
  with TEzIndyClientGIS(FLayer.Layers.GIS).FTCPClient do
  Begin
    WriteLn('DBT_PRIOR');
    WriteLn(FLayer.Name);
  End;
End;

Procedure TEzIndyTable.Recall;
Begin
  with TEzIndyClientGIS(FLayer.Layers.GIS).FTCPClient do
  Begin
    WriteLn('DBT_RECALL');
    WriteLn(FLayer.Name);
  End;
End;

Procedure TEzIndyTable.Refresh;
Begin
  with TEzIndyClientGIS(FLayer.Layers.GIS).FTCPClient do
  Begin
    WriteLn('DBT_REFRESH');
    WriteLn(FLayer.Name);
  End;
End;

Procedure TEzIndyTable.Reindex;
Begin
  with TEzIndyClientGIS(FLayer.Layers.GIS).FTCPClient do
  Begin
    WriteLn('DBT_REINDEX');
    WriteLn(FLayer.Name);
  End;
End;

Procedure TEzIndyTable.SetTagTo( Const TName: String );
Begin
  with TEzIndyClientGIS(FLayer.Layers.GIS).FTCPClient do
  Begin
    WriteLn('DBT_SETTAGTO');
    WriteLn(FLayer.Name);
    WriteLn(TName);
  End;
End;

Procedure TEzIndyTable.SetUseDeleted( tf: Boolean );
Begin
  with TEzIndyClientGIS(FLayer.Layers.GIS).FTCPClient do
  Begin
    WriteLn('DBT_SETUSEDELETED');
    WriteLn(FLayer.Name);
    WriteSmallInt(Ord(tf));
  End;
End;

Procedure TEzIndyTable.StringPut( Const fieldname, value: String );
Begin
  with TEzIndyClientGIS(FLayer.Layers.GIS).FTCPClient do
  Begin
    WriteLn('DBT_STRINGPUT');
    WriteLn(FLayer.Name);
    WriteLn(FieldName);
    WriteLn(value);
  End;
End;

Procedure TEzIndyTable.StringPutN( fieldno: integer; Const value: String );
Begin
  with TEzIndyClientGIS(FLayer.Layers.GIS).FTCPClient do
  Begin
    WriteLn('DBT_STRINGPUTN');
    WriteLn(FLayer.Name);
    WriteInteger(FieldNo);
    WriteLn(value);
  End;
End;

Procedure TEzIndyTable.Zap;
Begin
  with TEzIndyClientGIS(FLayer.Layers.GIS).FTCPClient do
  Begin
    WriteLn('DBT_ZAP');
    WriteLn(FLayer.Name);
  End;
End;

Function TEzIndyTable.DBCreateTable( Const fname: String; AFieldList: TStringList ): boolean;
var
  TempStrings: TStrings;
begin
  with TEzIndyClientGIS(FLayer.Layers.GIS).FTCPClient do
  Begin
    WriteLn('DBT_DBCREATETABLE');
    WriteLn(fname);
    TempStrings:= TStringList.Create;
    try
      If Assigned(AFieldList) Then
        TempStrings.Assign(AFieldList);
      WriteStrings(TempStrings, true);
    finally
      TempStrings.Free;
    end;
  End;
end;

Function TEzIndyTable.DBTableExists( const TableName: string ): Boolean;
begin
  with TEzIndyClientGIS(FLayer.Layers.GIS).FTCPClient do
  Begin
    WriteLn('DBT_DBTABLEEXITS');
    WriteLn(TableName);
    Result:=ReadSmallInt<>0;
  End;
end;

Function TEzIndyTable.DBDropTable( const TableName: string): Boolean;
begin
  with TEzIndyClientGIS(FLayer.Layers.GIS).FTCPClient do
  Begin
    WriteLn('DBT_DBDROPTABLE');
    WriteLn(TableName);
    Result:=ReadSmallInt<>0;
  End;
end;

Function TEzIndyTable.DBDropIndex( const TableName: string): Boolean;
begin
  with TEzIndyClientGIS(FLayer.Layers.GIS).FTCPClient do
  Begin
    WriteLn('DBT_DBDROPINDEX');
    WriteLn(TableName);
    Result:=ReadSmallInt<>0;
  End;
end;

Function TEzIndyTable.DBRenameTable( const Source, Target: string): Boolean;
begin
  with TEzIndyClientGIS(FLayer.Layers.GIS).FTCPClient do
  Begin
    WriteLn('DBT_DBRENAMETABLE');
    WriteLn(Source);
    WriteLn(Target);
    Result:=ReadSmallInt<>0;
  End;
end;

Procedure TEzIndyTable.BeginTrans;
begin
  with TEzIndyClientGIS(FLayer.Layers.GIS).FTCPClient do
  Begin
    WriteLn('DBT_BEGINTRANS');
    WriteLn(FLayer.Name);
  End;
end;

Procedure TEzIndyTable.EndTrans;
begin
  with TEzIndyClientGIS(FLayer.Layers.GIS).FTCPClient do
  Begin
    WriteLn('DBT_ENDTRANS');
    WriteLn(FLayer.Name);
  End;
end;

Procedure TEzIndyTable.RollbackTrans;
begin
  with TEzIndyClientGIS(FLayer.Layers.GIS).FTCPClient do
  Begin
    WriteLn('DBT_ROLLBACKTRANS');
    WriteLn(FLayer.Name);
  End;
end;


{-------------------------------------------------------------------------------}
{                  TEzIndyLayerInfo - class implementation                         }
{-------------------------------------------------------------------------------}

Function TEzIndyLayerInfo.GetTCPClient: TIdTCPClient;
begin
  Result:= TEzIndyClientGIS(FLayer.Layers.GIS).FTCPClient;
end;

Function TEzIndyLayerInfo.BufferGIS: TEzGIS;
Begin
  Result:= TEzIndyClientGIS(FLayer.Layers.GIS).FBufferGIS;
End;

Function TEzIndyLayerInfo.IsBuffered: Boolean;
Begin
  With TEzIndyClientGIS(FLayer.Layers.GIS) Do
    Result:= FClientBuffered And FBufferGIS.Active;
End;

Function TEzIndyLayerInfo.GetVisible: Boolean;
Var
  Layer: TEzBaseLayer;
Begin
  Result:= False;
  If GetTCPClient<>Nil Then
  Begin
    { read from server if not buffered }
    if Not IsBuffered Then
      with GetTCPClient do
      Begin
        WriteLn('LI_GETVISIBLE');
        WriteLn(FLayer.Name);
        Result := ReadSmallInt<>0;
      End
    Else
    Begin
      { read from the buffer GIS }
      Layer:= BufferGIS.Layers.LayerByName(Flayer.Name);
      If Layer <> Nil Then
        Result:= Layer.LayerInfo.Visible;
    End;
  End;
End;

Procedure TEzIndyLayerInfo.SetVisible( Value: Boolean );
Var
  Layer: TEzBaseLayer;
Begin
  If GetTCPClient<>Nil then
  Begin
    { always write to the server }
    with GetTCPClient do
    Begin
      WriteLn('LI_SETVISIBLE');
      WriteLn(FLayer.Name);
      WriteSmallInt(Ord(Value));
    End;
    { update the buffer GIS }
    Layer:= BufferGIS.Layers.LayerByName(FLayer.Name);
    If Layer <> Nil Then
      Layer.LayerInfo.Visible:= Value;
  End;
  with FLayer.Layers.GIS do
    If Assigned( OnVisibleLayerChange ) Then
      OnVisibleLayerChange( FLayer, FLayer.Name );
  SetModifiedStatus( FLayer );
End;

Function TEzIndyLayerInfo.GetSelectable: Boolean;
Var
  Layer: TEzBaseLayer;
Begin
  Result:= False;
  If GetTCPClient<>Nil Then
  Begin
    if Not IsBuffered  Then
      with GetTCPClient do
      Begin
        WriteLn('LI_GETSELECTABLE');
        WriteLn(FLayer.Name);
        Result := ReadSmallInt<>0;
      End
    Else
    Begin
      Layer:= BufferGIS.Layers.LayerByName(Flayer.Name);
      If Layer <> Nil Then
        Result:= Layer.LayerInfo.Selectable;
    End;
  End;
End;

Procedure TEzIndyLayerInfo.SetSelectable( Value: Boolean );
Var
  Layer: TEzBaseLayer;
Begin
  If (GetTCPClient<>Nil) Then
  Begin
    with GetTCPClient do
    Begin
      WriteLn('LI_SETSELECTABLE');
      WriteLn(FLayer.Name);
      WriteSmallInt(Ord(value));
    End;
    { update the buffer GIS }
    Layer:= BufferGIS.Layers.LayerByName(FLayer.Name);
    If Layer <> Nil Then Layer.LayerInfo.Selectable:= Value;
  End;
  with FLayer.Layers.GIS do
    If Assigned( OnSelectableLayerChange ) Then
      OnSelectableLayerChange( FLayer, FLayer.Name );
  SetModifiedStatus( FLayer );
End;

Function TEzIndyLayerInfo.GetIsCosmethic: Boolean;
Var
  Layer: TEzBaseLayer;
Begin
  Result:= False;
  If GetTCPClient<>Nil Then
  Begin
    if Not IsBuffered  Then
      with GetTCPClient do
      Begin
        WriteLn('LI_GETISCOSMETHIC');
        WriteLn(FLayer.Name);
        Result:= ReadSmallInt<>0;
      End
    Else
    Begin
      Layer:= BufferGIS.Layers.LayerByName(Flayer.Name);
      If Layer <> Nil Then
        Result:= Layer.LayerInfo.IsCosmethic;
    End;
  End ;
End;

Procedure TEzIndyLayerInfo.SetIsCosmethic( value: Boolean );
Var
  Layer: TEzBaseLayer;
Begin
  If GetTCPClient<>Nil Then
  Begin
    with GetTCPClient do
    Begin
      WriteLn('LI_SETISCOSMETHIC');
      WriteLn(FLayer.Name);
      WriteSmallInt(Ord(value));
    End;
    { update the buffer GIS }
    Layer:= BufferGIS.Layers.LayerByName(FLayer.Name);
    If Layer <> Nil Then
      Layer.LayerInfo.IsCosmethic:= Value;
  End;
End;

Function TEzIndyLayerInfo.GetExtension: TEzRect;
Var
  Layer: TEzBaseLayer;
Begin
  Result:= INVALID_EXTENSION;
  If GetTCPClient<>Nil Then
  Begin
    if Not IsBuffered  Then
      with GetTCPClient do
      Begin
        WriteLn('LI_GETEXTENSION');
        WriteLn(FLayer.Name);
        ReadBuffer(Result.X1,SizeOf(double));
        ReadBuffer(Result.Y1,SizeOf(double));
        ReadBuffer(Result.X2,SizeOf(double));
        ReadBuffer(Result.Y2,SizeOf(double));
      End
    Else
    Begin
      Layer:= BufferGIS.Layers.LayerByName(Flayer.Name);
      If Layer <> Nil Then
        Result:= Layer.LayerInfo.Extension;
    End;
  End
End;

Procedure TEzIndyLayerInfo.SetExtension( Const Value: TEzRect );
Var
  Layer: TEzBaseLayer;
Begin
  If GetTCPClient<>Nil Then
  Begin
    with GetTCPClient do
    Begin
      WriteLn('LI_SETEXTENSION');
      WriteLn(FLayer.Name);
      WriteBuffer(value.X1,SizeOf(double));
      WriteBuffer(value.Y1,SizeOf(double));
      WriteBuffer(value.X2,SizeOf(double));
      WriteBuffer(value.Y2,SizeOf(double));
    End;
    { update the buffer GIS }
    Layer:= BufferGIS.Layers.LayerByName(FLayer.Name);
    If Layer <> Nil Then
      Layer.LayerInfo.Extension:= Value;
  End;
  SetModifiedStatus( FLayer );
End;

Function TEzIndyLayerInfo.GetIDCounter: integer;
Begin
  Result:= 0;
  If GetTCPClient<>Nil Then
  Begin
    { IDCounter must be read from server because it is used for new insertions }
    //if Not IsBuffered  Then
      with GetTCPClient do
      Begin
        WriteLn('LI_GETIDCOUNTER');
        WriteLn(FLayer.Name);
        Result:= ReadInteger;
      End;
    {Else
    Begin
      Layer:= BufferGIS.Layers.LayerByName(Flayer.Name);
      If Layer <> Nil Then
        Result:= Layer.LayerInfo.IDCounter;
    End; }
  End;
End;

Procedure TEzIndyLayerInfo.SetIDCounter( Value: integer );
Begin
  If GetTCPClient<>Nil Then
    with GetTCPClient do
    Begin
      WriteLn('LI_SETIDCOUNTER');
      WriteLn(FLayer.Name);
      WriteInteger(value);
    End;
    // nothing to update on client
End;

Function TEzIndyLayerInfo.GetIsAnimationLayer: Boolean;
Var
  Layer: TEzBaseLayer;
Begin
  Result:= False;
  If GetTCPClient<>Nil Then
  Begin
    if Not IsBuffered  Then
      with GetTCPClient do
      Begin
        WriteLn('LI_GETISANIMATION');
        WriteLn(FLayer.Name);
        Result:= ReadSmallInt<>0;
      End
    Else
    Begin
      Layer:= BufferGIS.Layers.LayerByName(Flayer.Name);
      If Layer <> Nil Then
        Result:= Layer.LayerInfo.IsAnimationLayer;
    End;
  End;
End;

Procedure TEzIndyLayerInfo.SetIsAnimationLayer( Value: Boolean );
Var
  Layer: TEzBaseLayer;
Begin
  If GetTCPClient<>Nil Then
  Begin
    with GetTCPClient do
    Begin
      WriteLn('LI_SETISANIMATION');
      WriteLn(FLayer.Name);
      WriteSmallInt(Ord(value));
    End;
    { update the buffer GIS }
    Layer:= BufferGIS.Layers.LayerByName(FLayer.Name);
    If Layer <> Nil Then 
      Layer.LayerInfo.IsAnimationLayer:= Value;
  End;
End;

Function TEzIndyLayerInfo.GetIsIndexed: Boolean;
Var
  Layer: TEzBaseLayer;
Begin
  Result:= True;  // by default
  If GetTCPClient<>Nil Then
  Begin
    if Not IsBuffered  Then
      with GetTCPClient do
      Begin
        WriteLn('LI_GETISINDEXED');
        WriteLn(FLayer.Name);
        Result:= ReadSmallInt<>0;
      End
    Else
    Begin
      Layer:= BufferGIS.Layers.LayerByName(Flayer.Name);
      If Layer <> Nil Then
        Result:= Layer.LayerInfo.IsIndexed;
    End;
  End;
End;

Procedure TEzIndyLayerInfo.SetIsIndexed( Value: Boolean );
Var
  Layer: TEzBaseLayer;
Begin
  If GetTCPClient<>Nil Then
  Begin
    with GetTCPClient do
    Begin
      WriteLn('LI_SETISINDEXED');
      WriteLn(FLayer.Name);
      WriteSmallInt(ord(value));
    End;
    { update the buffer GIS }
    Layer:= BufferGIS.Layers.LayerByName(FLayer.Name);
    If Layer <> Nil Then
      Layer.LayerInfo.IsIndexed:= Value;
  End;
End;

Function TEzIndyLayerInfo.GetCoordsUnits: TEzCoordsUnits;
Var
  Layer: TEzBaseLayer;
Begin
  Result:= Low(TEzCoordsUnits);
  if Not IsBuffered  Then
    If GetTCPClient<>Nil Then
      with GetTCPClient do
      Begin
        WriteLn('LI_GETCOORDSUNITS');
        WriteLn(FLayer.Name);
        Result:= TEzCoordsUnits( ReadSmallInt );
      End
  Else
  Begin
    Layer:= BufferGIS.Layers.LayerByName(Flayer.Name);
    If Layer <> Nil Then
      Result:= Layer.LayerInfo.CoordsUnits;
  End;
End;

Procedure TEzIndyLayerInfo.SetCoordsUnits( Value: TEzCoordsUnits );
Var
  Layer: TEzBaseLayer;
Begin
  if GetTCPClient<>Nil then
  Begin
    with GetTCPClient do
    Begin
      WriteLn('LI_SETCOORDSUNITS');
      WriteLn(FLayer.Name);
      WriteSmallInt(Ord(value));
    End;
    { update the buffer GIS }
    Layer:= BufferGIS.Layers.LayerByName(FLayer.Name);
    If Layer <> Nil Then
      Layer.LayerInfo.CoordsUnits:= Value;
  End;
  SetModifiedStatus( FLayer );
End;

Function TEzIndyLayerInfo.GetCoordSystem: TEzCoordSystem;
var
  Layer: TEzBaseLayer;
Begin
  Result:=Low(TEzCoordSystem);
  If GetTCPClient<>Nil Then
  Begin
    if Not IsBuffered  Then
      with GetTCPClient do
      Begin
        WriteLn('LI_GETCOORDSYSTEM');
        WriteLn(FLayer.Name);
        Result:= TEzCoordSystem( ReadSmallInt );
      End
    Else
    Begin
      Layer:= BufferGIS.Layers.LayerByName(Flayer.Name);
      If Layer <> Nil Then
        Result:= Layer.LayerInfo.CoordSystem;
    End;
  End;
End;

Procedure TEzIndyLayerInfo.SetCoordSystem( Value: TEzCoordSystem );
Var
  Layer: TEzBaseLayer;
Begin
  if GetTCPClient<>Nil then
  begin
    with GetTCPClient do
    Begin
      WriteLn('LI_SETCOORDSYSTEM');
      WriteLn(FLayer.Name);
      WriteSmallInt(ord(value));
    End;
    { update the buffer GIS }
    Layer:= BufferGIS.Layers.LayerByName(FLayer.Name);
    If Layer <> Nil Then
      Layer.LayerInfo.CoordSystem:= Value;
    If Value = csLatLon Then
    Begin
      FLayer.CoordMultiplier := DEG_MULTIPLIER;
      Layer.CoordMultiplier := DEG_MULTIPLIER;
      SetCoordsUnits( cuDeg );
    End
    Else
    Begin
      FLayer.CoordMultiplier := 1;
      Layer.CoordMultiplier := DEG_MULTIPLIER;
    End;
  end;
  SetModifiedStatus( FLayer );
End;

Function TEzIndyLayerInfo.GetUseAttachedDB: Boolean;
Var
  Layer: TEzBaseLayer;
Begin
  Result:= True;
  if GetTCPClient<>Nil then
  begin
    if Not IsBuffered  Then
      with GetTCPClient do
      Begin
        WriteLn('LI_GETUSEATTACHEDDB');
        WriteLn(FLayer.Name);
        Result:= ReadSmallInt<>0;
      End
    Else
    Begin
      Layer:= BufferGIS.Layers.LayerByName(Flayer.Name);
      If Layer <> Nil Then
        Result:= Layer.LayerInfo.UseAttachedDB;
    End;
  end;
End;

Procedure TEzIndyLayerInfo.SetUseAttachedDB( Value: Boolean );
Var
  Layer: TEzBaseLayer;
Begin
  if GetTCPClient<>Nil then
  begin
    with GetTCPClient do
    Begin
      WriteLn('LI_SETUSEATTACHEDDB');
      WriteLn(FLayer.Name);
      WriteSmallInt(ord(value));
    End;
    { update the buffer GIS }
    Layer:= BufferGIS.Layers.LayerByName(FLayer.Name);
    If Layer <> Nil Then
      Layer.LayerInfo.UseAttachedDB:= Value;
  end;
End;

Function TEzIndyLayerInfo.GetOverlappedTextAction: TEzOverlappedTextAction;
Var
  Layer: TEzBaseLayer;
Begin
  Result:=Low(TEzOverlappedTextAction);
  If GetTCPClient<>Nil Then
  Begin
    if Not IsBuffered  Then
      with GetTCPClient do
      Begin
        WriteLn('LI_GETOVERLAPPEDTEXTACTION');
        WriteLn(FLayer.Name);
        Result:= TEzOverlappedtextaction( ReadSmallInt );
      End
    Else
    Begin
      Layer:= BufferGIS.Layers.LayerByName(Flayer.Name);
      If Layer <> Nil Then
        Result:= Layer.LayerInfo.OverlappedTextAction;
    End;
  End;
End;

Procedure TEzIndyLayerInfo.SetOverlappedTextAction( Value: TEzOverlappedTextAction );
Var
  Layer: TEzBaseLayer;
Begin
  If GetTCPClient<>Nil Then
  begin
    with GetTCPClient do
    Begin
      WriteLn('LI_SETOVERLAPPEDTEXTACTION');
      WriteLn(FLayer.Name);
      WriteSmallInt(ord(value));
    End;
    { update the buffer GIS }
    Layer:= BufferGIS.Layers.LayerByName(FLayer.Name);
    If Layer <> Nil Then
      Layer.LayerInfo.OverlappedTextAction:= Value;
  end;
  SetModifiedStatus( FLayer );
End;

Function TEzIndyLayerInfo.GetOverlappedTextColor: TColor;
Var
  Layer: TEzBaseLayer;
Begin
  Result:= clblack;
  If GetTCPClient<>Nil Then
  Begin
    if Not IsBuffered  Then
      with GetTCPClient do
      Begin
        WriteLn('LI_GETOVERLAPPEDTEXTCOLOR');
        WriteLn(FLayer.Name);
        overlappedtextcolor := TColor( ReadInteger );
      End
    Else
    Begin
      Layer:= BufferGIS.Layers.LayerByName(Flayer.Name);
      If Layer <> Nil Then
        Result:= Layer.LayerInfo.OverlappedTextColor;
    End;
  End;
End;

Procedure TEzIndyLayerInfo.SetOverlappedTextColor( Value: TColor );
Var
  Layer: TEzBaseLayer;
Begin
  if GetTCPClient<>Nil then
  begin
    with GetTCPClient do
    Begin
      WriteLn('LI_SETOVERLAPPEDTEXTCOLOR');
      WriteLn(FLayer.Name);
      WriteInteger(value);
    End;
    { update the buffer GIS }
    Layer:= BufferGIS.Layers.LayerByName(FLayer.Name);
    If Layer <> Nil Then
      Layer.LayerInfo.OverlappedTextColor:= Value;
  end;
  SetModifiedStatus( FLayer );
End;

Function TEzIndyLayerInfo.GetTextFixedSize: Byte;
Var
  Layer: TEzBaseLayer;
Begin
  Result:=0;
  If GetTCPClient<>Nil Then
  Begin
    if Not IsBuffered  Then
      with GetTCPClient do
      Begin
        WriteLn('LI_GETTEXTFIXEDSIZE');
        WriteLn(FLayer.Name);
        result:= ReadInteger;
      End
    Else
    Begin
      Layer:= BufferGIS.Layers.LayerByName(Flayer.Name);
      If Layer <> Nil Then
        Result:= Layer.LayerInfo.TextFixedSize;
    End;
  End;
End;

Procedure TEzIndyLayerInfo.SetTextFixedSize( Value: Byte );
Var
  Layer: TEzBaseLayer;
Begin
  if GetTCPClient<>Nil then
  begin
    with GetTCPClient do
    Begin
      WriteLn('LI_SETTEXTFIXEDSIZE');
      WriteLn(FLayer.Name);
      WriteInteger(value);
    End;
    { update the buffer GIS }
    Layer:= BufferGIS.Layers.LayerByName(FLayer.Name);
    If Layer <> Nil Then
      Layer.LayerInfo.TextFixedSize:= Value;
  end;
  SetModifiedStatus( FLayer );
End;

Function TEzIndyLayerInfo.GetTextHasShadow: Boolean;
Var
  Layer: TEzBaseLayer;
Begin
  Result:= False;
  if GetTCPClient<>Nil then
  begin
    if Not IsBuffered  Then
      with GetTCPClient do
      Begin
        WriteLn('LI_GETTEXTHASSHADOW');
        WriteLn(FLayer.Name);
        Result := ReadSmallInt<>0;
      End
    Else
    Begin
      Layer:= BufferGIS.Layers.LayerByName(Flayer.Name);
      If Layer <> Nil Then
        Result:= Layer.LayerInfo.TextHasShadow;
    End;
  end;
End;

Procedure TEzIndyLayerInfo.SetTextHasShadow( value: Boolean );
Var
  Layer: TEzBaseLayer;
Begin
  if GetTCPClient<>Nil then
  begin
    with GetTCPClient do
    Begin
      WriteLn('LI_SETTEXTHASSHADOW');
      WriteLn(FLayer.Name);
      WriteSmallInt(ord(value));
    End;
    { update the buffer GIS }
    Layer:= BufferGIS.Layers.LayerByName(FLayer.Name);
    If Layer <> Nil Then 
      Layer.LayerInfo.TextHasShadow:= Value;
  end;
  SetModifiedStatus( FLayer );
End;

{-------------------------------------------------------------------------------}
{                  TEzIndyLayer - class implementation                                }
{-------------------------------------------------------------------------------}

Constructor TEzIndyLayer.Create( Layers: TEzBaseLayers; Const AFileName: String );
Begin
  Inherited Create( Layers, AFileName );
  FDBTable:= TEzIndyTable.Create( Layers.Gis, '', true, true);
  TEzIndyTable(FDBTable).FLayer:= Self;

  FLayerInfo := TEzIndyLayerInfo.Create( Self );
  Self.FileName := AFileName;
  Self.Name := ExtractFileName(AFileName);

  CoordMultiplier := 1;

  FBufferList:= TEzEntityList.Create;
  FBufferCurrent:= 0;
  FRecnoList:= TIntegerList.Create;
  FMWSparseList:= TMWSparseList.Create(1000);
End;

Destructor TEzIndyLayer.Destroy;
Begin
  Close;
  FDBTable.Free;
  FBufferList.Free;
  FRecnoList.Free;
  FMWSparseList.Free;
  Inherited Destroy;
End;

procedure TEzIndyLayer.InvalidateRecord(Index: Integer);
begin
  If Not TEzIndyClientGIS(Layers.GIS).FClientBuffered Then Exit;
  { invalidating a record will cause the entity to re-read from the server }
  If FMWSparseList.HasData(Index-1) Then
  begin
    FMWSparseList.LocalRecno[Index-1]:= 0;
    FMWSparseList.DataExists[Index-1]:= False;
  end;
end;

Function TEzIndyLayer.GetLocalDataExists( ServerRecno: Integer ): Boolean;
begin
  Result:= False;
  If Not TEzIndyClientGIS(Layers.GIS).FClientBuffered Then Exit;
  Result:= FMWSparseList.DataExists[ServerRecno-1];
end;

Procedure TEzIndyLayer.SetLocalDataExists( ServerRecno: Integer; Value: Boolean );
begin
  If Not TEzIndyClientGIS(Layers.GIS).FClientBuffered Then Exit;
  FMWSparseList.DataExists[ServerRecno-1]:= Value;
end;

Function TEzIndyLayer.GetLocalRecno( ServerRecno: Integer ): Integer;
begin
  Result:= 0;
  If Not TEzIndyClientGIS(Layers.GIS).FClientBuffered Then Exit;
  Result:= FMWSparseList.LocalRecno[ServerRecno-1];
end;

Procedure TEzIndyLayer.SetLocalRecno( ServerRecno, Value: Integer );
begin
  If Not TEzIndyClientGIS(Layers.GIS).FClientBuffered Then Exit;
  FMWSparseList.LocalRecno[ServerRecno-1]:= Value;
end;

Function TEzIndyLayer.LocalLayer: TEzBaseLayer;
Begin
  Result:= Nil;
  If Not TEzIndyClientGIS(Layers.GIS).FClientBuffered Then Exit;
  Result:= TEzIndyClientGIS(Layers.GIS).FBufferGIS.Layers.LayerByName( Self.Name );
End;

Procedure TEzIndyLayer.InitializeOnCreate( Const FileName: String;
  AttachedDB, IsAnimation: Boolean; CoordSystem: TEzCoordSystem;
  CoordsUnits: TEzCoordsUnits; FieldList: TStrings );
Begin
  // almost nothing to do here
  Modified := True;
End;

Function TEzIndyLayer.GetTCPClient: TIdTCPClient;
begin
  Result:= TEzIndyClientGIS(Layers.GIS).FTCPClient;
end;

Function TEzIndyLayer.IsClientServer: Boolean;
Begin
  if GetTCPClient<>nil then
    with GetTCPClient do
    Begin
      WriteLn('LAY_ISCLIENTSERVER');
      WriteLn(Self.Name);
      Result:= ReadSmallInt<>0;
    End
  Else
    result:=false;
End;

Procedure TEzIndyLayer.StartBatchInsert;
Begin
  If Not FClientHasAllData Then
  Begin
    with GetTCPClient do
    Begin
      WriteLn('LAY_STARTBATCHINSERT');
      WriteLn(Self.Name);
    End;
  End Else
  Begin
    LocalLayer.StartBatchInsert;
  End;
End;

Procedure TEzIndyLayer.FinishBatchInsert;
Begin
  If Not FClientHasAllData Then
  Begin
    with GetTCPClient do
    Begin
      WriteLn('LAY_FINISHBATCHINSERT');
      WriteLn(Self.Name);
    End;
  End Else
  Begin
    LocalLayer.FinishBatchInsert;
  End;
End;

Function TEzIndyLayer.DefineScope( Const Scope: String ): Boolean;
Begin
  If Not FClientHasAllData Then
  Begin
    with GetTCPClient do
    Begin
      WriteLn('LAY_DEFINESCOPE');
      WriteLn(Self.Name);
      WriteLn(Scope);
      Result:= ReadSmallInt<>0;
    End;
  End Else
  Begin
    Result:=LocalLayer.DefineScope( Scope );
  End;
End;

Function TEzIndyLayer.GetBookmark: Pointer;
Begin
  If Not FClientHasAllData Then
  Begin
    with GetTCPClient do
    Begin
      WriteLn('LAY_GETBOOKMARK');
      WriteLn(Self.Name);
      Result:= Pointer(ReadInteger);
    End;
  End Else
  Begin
    Result:= LocalLayer.GetBookmark;
  End;
end;

Procedure TEzIndyLayer.GotoBookmark(Bookmark: Pointer);
Begin
  If Not FClientHasAllData Then
  Begin
    with GetTCPClient do
    Begin
      WriteLn('LAY_GOTOBOOKMARK');
      WriteLn(Self.Name);
      WriteInteger(Integer(Bookmark));
    End;
  End Else
  Begin
    LocalLayer.GotoBookmark( Bookmark );
  End;
end;

Procedure TEzIndyLayer.FreeBookmark(Bookmark: Pointer);
Begin
  If Not FClientHasAllData Then
  Begin
    with GetTCPClient do
    Begin
      WriteLn('LAY_FREEBOOKMARK');
      WriteLn(Self.Name);
      WriteInteger(Integer(Bookmark));
    End;
  End Else
  Begin
    LocalLayer.FreeBookmark( Bookmark );
  End;
end;

Function TEzIndyLayer.DefinePolygonScope( Polygon: TEzEntity; Const Scope: String;
  Operator: TEzGraphicOperator ): Boolean;
var
  Stream: TStream;
Begin
  If Not FClientHasAllData Then
  Begin
    with GetTCPClient do
    Begin
      WriteLn('LAY_DEFINEPOLYGONSCOPE');
      WriteLn(Self.Name);
      WriteSmallInt( Ord( Polygon.EntityID ) );
      Stream:= TMemoryStream.Create;
      Try
        Polygon.SaveToStream(Stream);
        Stream.Position:= 0;
{$IFDEF TRANSPORT_COMPRESSED}
        CompressmemStream(TMemoryStream(Stream), 1);
        Stream.Position:= 0;
{$ENDIF}
        OpenWriteBuffer;
        WriteStream(Stream,true,true);
        CloseWriteBuffer;
      Finally
        Stream.Free;
      End;
      WriteLn(Scope);
      WriteSmallInt(Ord(Operator));
      Result:= ReadSmallInt<>0;
    End;
  End Else
  Begin
    Result:= LocalLayer.DefinePolygonScope(Polygon, Scope, Operator);
  End;
End;

Procedure TEzIndyLayer.Zap;
Begin
  with GetTCPClient do
  Begin
    WriteLn('LAY_ZAP');
    WriteLn(Self.Name);
  End;
  If FClientHasAllData Then
  Begin
    LocalLayer.Zap;
    FMWSparseList.Clear;
  End;
End;

Procedure TEzIndyLayer.GetFieldList( Strings: TStrings );
Begin
  If Not FClientHasAllData Then
  Begin
    with GetTCPClient do
    Begin
      WriteLn('LAY_GETFIELDLIST');
      WriteLn(Self.Name);
      ReadStrings(Strings);
    End;
  End Else
  Begin
    LocalLayer.GetFieldList( Strings );
  End;
End;

Function TEzIndyLayer.GetDBTable: TEzBaseTable;
Begin
  Result := FDBTable;
End;

Function TEzIndyLayer.GetRecno: Integer;
Begin
  If Not FClientHasAllData Then
  begin
    If (FBufferList.Count = 0) Or (FBufferCurrent > FBufferList.Count-1) then
    begin
      with GetTCPClient do
      Begin
        WriteLn('LAY_GETRECNO');
        WriteLn(Self.Name);
        Result:= ReadInteger;
      End;
    End Else
      Result:= FRecnoList[FBufferCurrent];
  End Else
  begin
    Result:= LocalLayer.Recno;
  end;
End;

Procedure TEzIndyLayer.SetRecno( Value: Integer );
Begin
  If Not FClientHasAllData Then
  begin
    with GetTCPClient do
    Begin
      WriteLn('LAY_SETRECNO');
      WriteLn(Self.Name);
      WriteInteger(Value);
    End;
  End Else
  begin
    LocalLayer.Recno:= Value;
  end;
End;

Procedure TEzIndyLayer.GetNextBuffer;
var
  Stream: TStream;
  TmpClass: TEzEntityClass;
  Entity: TEzEntity;
  value: integer;
  valuesi: SmallInt;
Begin
  with GetTCPClient do
  Begin
    WriteLn('LAY_GETNEXTBUFFER');
    WriteLn(Self.Name);
    // request this no. of entities from server
    WriteInteger(TEzIndyClientGIS(Layers.GIS).FTransportBufferSize);
    FBufferList.Clear;
    FRecnoList.Clear;
    FBufferCurrent:= 0;
    Stream:= TMemoryStream.Create;
    try
      ReadStream(Stream,-1,False);
{$IFDEF TRANSPORT_COMPRESSED}
      Stream.Position:= 0;
      DeCompressmemStream(TMemoryStream(Stream));
{$ENDIF}
      Stream.Position:= 0;
      while Stream.Position < Stream.Size-1 do
      begin
        { read record number }
        Stream.Read(value,SizeOf(Integer));
        FRecnoList.Add( value );
        { read the entity }
        Stream.Read(valuesi,SizeOf(SmallInt));
        TmpClass := GetClassFromID( TEzEntityID(valuesi) );
        Entity:= TmpClass.Create( 1 );
        Entity.LoadFromStream( Stream );
        FBufferList.Add( Entity );
      end;
    finally
      Stream.free;
    end;
  end;
End;

Procedure TEzIndyLayer.SetGraphicFilter( s: TSearchType; Const VisualWindow: TEzRect );
Begin
  If Not FClientHasAllData Then  // All buffered is set only when all records have been local stored
  Begin
    with GetTCPClient do
    Begin
      WriteLn('LAY_SETGRAPHICFILTER');
      WriteLn(Self.Name);
      WriteSmallInt(Ord(s));
      WriteBuffer(VisualWindow.X1,SizeOf(double));
      WriteBuffer(VisualWindow.Y1,SizeOf(double));
      WriteBuffer(VisualWindow.X2,SizeOf(double));
      WriteBuffer(VisualWindow.Y2,SizeOf(double));

      If TEzIndyClientGIS(Layers.GIS).FTransportBufferSize > 0 then
      Begin
        WriteLn('LAY_FIRST');
        WriteLn(Self.Name);

        GetNextBuffer;
      End;
    End;
  End Else
  Begin
    LocalLayer.SetGraphicFilter(s, VisualWindow);
  End;
End;

Procedure TEzIndyLayer.CancelFilter;
Begin
  If Not FClientHasAllData Then
  Begin
    with GetTCPClient do
    Begin
      WriteLn('LAY_CANCELFILTER');
      WriteLn(Self.Name);
    End;
    FBufferList.Clear;
    FRecnoList.Clear;
    FBufferCurrent:= 0;
  End Else
    LocalLayer.CancelFilter;
End;

Function TEzIndyLayer.Eof: Boolean;
Begin
  If Not FClientHasAllData Then
  Begin
    If FBufferList.Count = 0 then
    begin
      with GetTCPClient do
      Begin
        WriteLn('LAY_EOF');
        WriteLn(Self.Name);
        Result:= ReadSmallInt<>0;
      End;
    End Else
      Result:= (FBufferCurrent >= FBufferList.Count);
  End Else
    Result:= LocalLayer.Eof;
End;

Procedure TEzIndyLayer.First;
Begin
  If Not FClientHasAllData Then
  Begin
    If FBufferList.Count = 0 then
    begin
      with GetTCPClient do
      Begin
        WriteLn('LAY_FIRST');
        WriteLn(Self.Name);
      End;
    End Else
      FBufferCurrent:= 0;
  End Else
    LocalLayer.First;
End;

Procedure TEzIndyLayer.Next;
Begin
  If Not FClientHasAllData Then
  Begin
    If FBufferList.Count = 0 then
    begin
      with GetTCPClient do
      Begin
        WriteLn('LAY_NEXT');
        WriteLn(Self.Name);
      End;
    End Else
    begin
      If FBufferCurrent < FBufferList.Count-1 then
        Inc(FBufferCurrent)
      Else
        GetNextBuffer;
    end;
  End Else
    LocalLayer.Next;
End;

Procedure TEzIndyLayer.Last;    // this Procedure is seldom used
Begin
  If Not FClientHasAllData Then
  Begin
    with GetTCPClient do
    Begin
      WriteLn('LAY_LAST');
      WriteLn(Self.Name);
    End;
  End Else
    LocalLayer.Last;
End;

Procedure TEzIndyLayer.StartBuffering;
Begin
  If Not FClientHasAllData Then
  Begin
    If FBufferList.Count = 0 Then
    Begin
      with GetTCPClient do
      Begin
        WriteLn('LAY_FIRST');
        WriteLn(Self.Name);

        GetNextBuffer;
      End;
    End;
  End Else
    LocalLayer.StartBuffering;
End;

Procedure TEzIndyLayer.EndBuffering;
Begin
  If Not FClientHasAllData Then
  Begin
    FBufferList.Clear;
    FRecnoList.Clear;
    FBufferCurrent:= 0;
  End Else
    LocalLayer.EndBuffering;
End;

Procedure TEzIndyLayer.Assign( Source: TEzBaseLayer );
Begin
  If Not FClientHasAllData Then
  Begin
    with GetTCPClient do
    Begin
      WriteLn('LAY_ASSIGN');
      WriteLn(Self.Name);
      WriteLn(Source.Name);
    End;
  End Else
    LocalLayer.Assign(Source);
End;

Function TEzIndyLayer.GetExtensionForRecords( List: TIntegerList ): TEzRect;
var
  I,n: integer;
begin
  If Not FClientHasAllData Then
  Begin
    with GetTCPClient do
    Begin
      WriteLn('LAY_GETEXTENSIONFORRECORDS');
      WriteLn(Self.Name);
      n:= List.Count;
      WriteInteger(n);
      for I:= 0 to n-1 do
        WriteInteger(List[I]);
      ReadBuffer(Result.X1,SizeOf(double));
      ReadBuffer(Result.Y1,SizeOf(double));
      ReadBuffer(Result.X2,SizeOf(double));
      ReadBuffer(Result.Y2,SizeOf(double));
    End;
  End Else
    Result:= LocalLayer.GetExtensionForRecords(List);
end;

Procedure TEzIndyLayer.RebuildTree;
Begin
  If Not FClientHasAllData Then
  Begin
    with GetTCPClient do
    Begin
      WriteLn('LAY_REBUILDTREE');
      WriteLn(Self.Name);
    End;
  End Else
    LocalLayer.RebuildTree;
End;

Procedure TEzIndyLayer.Open;
Begin
  If Not FClientHasAllData Then
  Begin
    with GetTCPClient do
    Begin
      WriteLn('LAY_OPEN');
      WriteLn(Self.Name);
    End;
  End Else
    LocalLayer.Open;
End;

Procedure TEzIndyLayer.Close;
Begin
  If GetTCPClient = Nil then Exit;
  If Not FClientHasAllData Then
  Begin
    with GetTCPClient do
    Begin
      WriteLn('LAY_CLOSE');
      WriteLn(Self.Name);
    End;
  End Else
    LocalLayer.Close;
End;

Procedure TEzIndyLayer.ForceOpened;
Begin
  If Not FClientHasAllData Then
  Begin
    with GetTCPClient do
    Begin
      WriteLn('LAY_FORCEOPENED');
      WriteLn(Self.Name);
    End;
  End Else
    LocalLayer.ForceOpened;
End;

Procedure TEzIndyLayer.WriteHeaders( FlushFiles: Boolean );
Begin
  If Not FClientHasAllData Then
  Begin
    with GetTCPClient do
    Begin
      WriteLn('LAY_WRITEHEADERS');
      WriteLn(Self.Name);
      WriteSmallInt( Ord(FlushFiles));
    End;
  End Else
    LocalLayer.Writeheaders(FlushFiles);
End;

Function TEzIndyLayer.AddEntity( Entity: TEzEntity ): Integer;
var
  stream: TStream;
Begin
  with GetTCPClient do
  Begin
    WriteLn('LAY_ADDENTITY');
    WriteLn(Self.Name);
    WriteSmallInt(Ord(Entity.EntityID));
    stream:= TMemoryStream.Create;
    try
      Entity.SaveToStream( Stream );
      Stream.Position:= 0;
{$IFDEF TRANSPORT_COMPRESSED}
      CompressmemStream(TMemoryStream(Stream), 1);
      Stream.Position:= 0;
{$ENDIF}
      OpenWriteBuffer;
      WriteStream(Stream,true,true);
      CloseWriteBuffer;
      Result:= ReadInteger;
    finally
      stream.free;
    end;
  End;
  If LocalLayer<>Nil Then
    LocalLayer.AddEntity( Entity );
End;

Procedure TEzIndyLayer.UndeleteEntity( RecNo: Integer );
Begin
  with GetTCPClient do
  Begin
    WriteLn('LAY_UNDELETEENTITY');
    WriteLn(Self.Name);
    WriteInteger(Recno);
  end;
  If LocalLayer<>Nil Then
    LocalLayer.UndeleteEntity( Recno );
End;

Procedure TEzIndyLayer.DeleteEntity( RecNo: Integer );
Begin
  with GetTCPClient do
  Begin
    WriteLn('LAY_DELETEENTITY');
    WriteLn(Self.Name);
    WriteInteger(Recno);
  end;
  If LocalLayer<>Nil Then
    LocalLayer.DeleteEntity( Recno );
End;

Function TEzIndyLayer.QuickUpdateExtension: TEzRect;
Begin
  If Not FClientHasAllData Then
  Begin
    with GetTCPClient do
    Begin
      WriteLn('LAY_QUICKUPDATEEXTENSION');
      WriteLn(Self.Name);
      ReadBuffer(Result.x1,SizeOf(double));
      ReadBuffer(Result.y1,SizeOf(double));
      ReadBuffer(Result.x2,SizeOf(double));
      ReadBuffer(Result.y2,SizeOf(double));
    end;
  End Else
    Result:= LocalLayer.QuickUpdateExtension;
End;

Function TEzIndyLayer.UpdateExtension: TEzRect;
Begin
  If Not FClientHasAllData Then
  Begin
    with GetTCPClient do
    Begin
      WriteLn('LAY_UPDATEEXTENSION');
      WriteLn(Self.Name);
      ReadBuffer(Result.x1,SizeOf(double));
      ReadBuffer(Result.y1,SizeOf(double));
      ReadBuffer(Result.x2,SizeOf(double));
      ReadBuffer(Result.y2,SizeOf(double));
    end;
  End Else
    Result:= LocalLayer.UpdateExtension;
End;

Procedure TEzIndyLayer.TransportImage(AEntity: TEzEntity);
var
  Stream, FileStream: TStream;
  FullName,FileName: string;
Begin
  If (AEntity=Nil) Or Not (AEntity.EntityID in [idPictureRef, idBandsBitmap]) Or
    (TEzIndyClientGIS(Layers.GIS).FTransportImages = tiNone) Then Exit;

  case AEntity.EntityID of
    idPictureRef:
      FileName:= TEzPictureRef(AEntity).FileName;
    idBandsBitmap:
      FileName:= TEzBandsBitmap(AEntity).FileName;
  end;
  FullName:= AddSlash(Ez_Preferences.CommonSubdir) + Filename;
  If (TEzIndyClientGIS(Layers.GIS).FTransportImages = tiNonExistingOnly) And
    FileExists(FullName) Then Exit;

  with GetTCPClient do
  Begin
    WriteLn('GLB_GETIMAGE');
    WriteLn(FileName);
    { read the image }
    Stream:= TMemoryStream.Create;
    try
      ReadStream(Stream,-1,False);
{$IFDEF TRANSPORT_COMPRESSED}
      Stream.Position:= 0;
      DeCompressmemStream(TMemoryStream(Stream));
{$ENDIF}
      Stream.Position:= 0;
      FileStream:= TFileStream.Create(FullName, fmCreate);
      try
        FileStream.CopyFrom( Stream, Stream.Size );
      finally
        FileStream.Free;
      end;
    Finally
      Stream.Free;
    end;
  end;
End;

Function TEzIndyLayer.LoadEntityWithRecNo( RecNo: Longint ): TEzEntity;
var
  ID: TEzEntityID;
  TmpClass: TEzEntityClass;
  Stream: TStream;
Begin
  If LocalRecno[Recno] = 0 Then
  Begin
    with GetTCPClient do
    Begin
      WriteLn('LAY_LOADENTITYWITHRECNO');
      WriteLn(Self.Name);
      WriteInteger(Recno);
      ID:= TEzEntityID( ReadSmallInt );
      TmpClass := GetClassFromID( ID );
      Result:= TmpClass.Create( 1 );
      Stream:= TMemoryStream.Create;
      try
        ReadStream(Stream,-1,False);
{$IFDEF TRANSPORT_COMPRESSED}
        Stream.Position:= 0;
        DeCompressmemStream(TMemoryStream(Stream));
{$ENDIF}
        Stream.Position:= 0;
        Result.LoadFromStream( Stream );

        TransportImage(Result);

      finally
        Stream.Free;
      end;
    end;
    If LocalLayer <> Nil Then
      { add the entity to the local layer }
      LocalRecno[Recno]:= LocalLayer.AddEntity( Result );
  End Else
  Begin
    Result:= LocalLayer.LoadEntityWithRecno( LocalRecno[Recno] );
  End;
End;

Procedure TEzIndyLayer.UpdateEntity( RecNo: Integer; Entity2D: TEzEntity );
var
  stream: TStream;
Begin
  NormalizePolygon( Entity2d );

  with GetTCPClient do
  Begin
    WriteLn('LAY_UPDATEENTITY');
    WriteLn(Self.Name);
    WriteInteger(Recno);
    WriteSmallInt(Ord(Entity2d.EntityID));
    stream:= TMemoryStream.Create;
    try
      Entity2d.SaveToStream(stream);
      Stream.Position:= 0;
{$IFDEF TRANSPORT_COMPRESSED}
      CompressmemStream(TMemoryStream(Stream), 1);
      Stream.Position:= 0;
{$ENDIF}
      OpenWriteBuffer;
      WriteStream(Stream,true,true);
      CloseWriteBuffer;
    finally
      stream.free;
    end;
  end;
  If LocalRecno[Recno] = 0 Then
    LocalRecno[Recno]:= LocalLayer.AddEntity( Entity2d )
  Else
    LocalLayer.UpdateEntity( LocalRecno[Recno], Entity2d );
End;

Procedure TEzIndyLayer.Pack( ShowMessages: Boolean );
Begin
  with GetTCPClient do
  Begin
    WriteLn('LAY_PACK');
    WriteLn(Self.Name);
    WriteSmallInt(Ord(ShowMessages));
  End;
  If FClientHasAllData Then
    LocalLayer.Pack(ShowMessages);
End;

Function TEzIndyLayer.RecExtension: TEzRect;
Begin
  If Not FClientHasAllData Then
  begin
    If (FBufferList.Count = 0) Or (FBufferCurrent > FBufferList.Count-1) then
    begin
      with GetTCPClient do
      Begin
        WriteLn('LAY_RECEXTENSION');
        WriteLn(Self.Name);
        ReadBuffer(Result.x1,SizeOf(double));
        ReadBuffer(Result.y1,SizeOf(double));
        ReadBuffer(Result.x2,SizeOf(double));
        ReadBuffer(Result.y2,SizeOf(double));
      End;
    End Else
      Result:= FBufferList[FBufferCurrent].FBox;
  End Else
    Result:= LocalLayer.RecExtension;
End;

Function TEzIndyLayer.RecLoadEntity: TEzEntity;
var
  ID: TEzEntityID;
  TmpClass: TEzEntityClass;
  Stream: TStream;
  ServerRecno: Integer;
  RetrieveFromServer: Boolean;
Begin
  If Not FClientHasAllData Then
  begin
    RetrieveFromServer:= True;
    If TEzIndyClientGIS(Layers.GIS).FClientBuffered Then
    Begin
      { read the record number from the server }
      If (FBufferList.Count = 0) Or (FBufferCurrent > FBufferList.Count-1) then
      begin
        with GetTCPClient do
        Begin
          WriteLn('LAY_GETRECNO');
          WriteLn(Self.Name);
          ServerRecno:= ReadInteger;
        End;
      End Else
        ServerRecno:= FRecnoList[FBufferCurrent];

      RetrieveFromServer:= (LocalRecno[ServerRecno] = 0);
    End;
    If RetrieveFromServer Then
    Begin
      If (FBufferList.Count = 0) Or (FBufferCurrent > FBufferList.Count-1) then
      Begin
        With GetTCPClient do
        Begin
          WriteLn('LAY_RECLOADENTITY');
          WriteLn(Self.Name);
          ID:= TEzEntityID( ReadSmallInt );
          TmpClass := GetClassFromID( ID );
          Result:= TmpClass.Create( 1 );
          Stream:= TMemoryStream.Create;
          Try
            ReadStream(Stream,-1,False);
{$IFDEF TRANSPORT_COMPRESSED}
            Stream.Position:= 0;
            DeCompressmemStream(TMemoryStream(Stream));
{$ENDIF}
            Stream.Position:= 0;
            Result.LoadFromStream( Stream );
          Finally
            Stream.Free;
          End;
        End;
      End Else
      Begin
        { read from the buffer }
        ID:= FBufferList[FBufferCurrent].EntityID;
        TmpClass := GetClassFromID( ID );
        Result:= TmpClass.Create( 1 );
        Result.Assign(FBufferList[FBufferCurrent]);
      End;
      { Now save to the local layer }
      If TEzIndyClientGIS(Layers.GIS).FClientBuffered And
         (LocalRecno[ServerRecno] = 0) Then
        LocalRecno[ServerRecno]:= LocalLayer.AddEntity( Result );
    End Else If TEzIndyClientGIS(Layers.GIS).FClientBuffered Then
      Result:= LocalLayer.LoadEntityWithRecno( LocalRecno[ServerRecno] );
  End Else
    Result:= LocalLayer.RecLoadEntity;

  TransportImage(Result);
End;

Procedure TEzIndyLayer.RecLoadEntity2( Entity: TEzEntity );
var
  Stream: TStream;
  ServerRecno: Integer;
  TempEntity: TEzEntity;
  RetrieveFromServer: Boolean;
Begin
  If Not FClientHasAllData Then
  begin
    RetrieveFromServer:= True;
    If TEzIndyClientGIS(Layers.GIS).FClientBuffered Then
    Begin
      { read the record number from the server }
      If (FBufferList.Count = 0) Or (FBufferCurrent > FBufferList.Count-1) then
      begin
        with GetTCPClient do
        Begin
          WriteLn('LAY_GETRECNO');
          WriteLn(Self.Name);
          ServerRecno:= ReadInteger;
        End;
      End Else
        ServerRecno:= FRecnoList[FBufferCurrent];

      RetrieveFromServer:= (LocalRecno[ServerRecno] = 0);
    End;
    If RetrieveFromServer Then
    Begin
      If (FBufferList.Count = 0) Or (FBufferCurrent > FBufferList.Count-1) then
      begin
        with GetTCPClient do
        Begin
          WriteLn('LAY_RECLOADENTITY2');
          WriteLn(Self.Name);
          WriteSmallInt(Ord(Entity.EntityID));
          Stream:= TMemoryStream.Create;
          try
            ReadStream(Stream,-1,False);
{$IFDEF TRANSPORT_COMPRESSED}
            Stream.Position:= 0;
            DeCompressmemStream(TMemoryStream(Stream));
{$ENDIF}
            Stream.Position:= 0;
            Entity.LoadFromStream( Stream );
          finally
            Stream.Free;
          end;
        End;
      End Else
      Begin
        Entity.Assign( FBufferList[FBufferCurrent] );
      End;
      If TEzIndyClientGIS(Layers.GIS).FClientBuffered And
         (LocalRecno[ServerRecno] = 0) Then
        LocalRecno[ServerRecno]:= LocalLayer.AddEntity( Entity );
    End Else
    Begin
      TempEntity:= LocalLayer.LoadEntityWithRecno( LocalRecno[ServerRecno] );
      Try
        Entity.Assign(TempEntity);
      Finally
        TempEntity.Free;
      End;
    End;
  End Else
    LocalLayer.RecLoadEntity2(Entity);

  TransportImage(Entity);
End;

Function TEzIndyLayer.RecEntityID: TEzEntityID;
Begin
  If Not FClientHasAllData Then
  begin
    If (FBufferList.Count = 0) Or (FBufferCurrent > FBufferList.Count-1) then
    begin
      with GetTCPClient do
      Begin
        WriteLn('LAY_RECENTITYID');
        WriteLn(Self.Name);
        Result:= TEzEntityID( ReadSmallInt );
      End;
    End Else
      Result:= FBufferList[FBufferCurrent].EntityID;
  End Else
    Result:= LocalLayer.RecEntityID;
End;

Function TEzIndyLayer.RecIsDeleted: Boolean;
Begin
  If Not FClientHasAllData Then
  begin
    If (FBufferList.Count = 0) Or (FBufferCurrent > FBufferList.Count-1) then
    begin
      with GetTCPClient do
      Begin
        WriteLn('LAY_RECISDELETED');
        WriteLn(Self.Name);
        Result:= ReadSmallInt<>0;
      End;
    End Else
      Result:= (FBufferList[FBufferCurrent] = Nil);
  End Else
    Result:= LocalLayer.RecIsDeleted;
End;

Procedure TEzIndyLayer.CopyRecord( SourceRecno, DestRecno: Integer );
Begin
  with GetTCPClient do
  Begin
    WriteLn('LAY_COPYRECORD');
    WriteLn(Self.Name);
    WriteInteger(SourceRecno);
    WriteInteger(DestRecno);
  End;
  If FClientHasAllData Then
    LocalLayer.CopyRecord( SourceRecno, DestRecno );
End;

Function TEzIndyLayer.ContainsDeleted: Boolean;
Begin
{.$IFDEF FALSE}
  with GetTCPClient do
  Begin
    WriteLn('LAY_CONTAINSDELETED');
    WriteLn(Self.Name);
    Result:= ReadSmallInt<>0;
  End;
{.$ENDIF}
  { supposedly must be synchronized the deleted record on the server than locally }
{$IFDEF FALSE}
  Result:= LocalLayer.ContainsDeleted;
{$ENDIF}
End;

Procedure TEzIndyLayer.Recall;
Begin
  with GetTCPClient do
  Begin
    WriteLn('LAY_RECALL');
    WriteLn(Self.Name);
  End;
  If FClientHasAllData Then
    LocalLayer.Recall;
End;

Function TEzIndyLayer.GetRecordCount: Integer;
Begin
  If Not FClientHasAllData Then
  begin
    with GetTCPClient do
    Begin
      WriteLn('LAY_GETRECORDCOUNT');
      WriteLn(Self.Name);
      Result:=ReadInteger;
    End;
  End Else
    Result:= LocalLayer.RecordCount;
End;

Function TEzIndyLayer.BringEntityToFront(ARecno: Integer): Integer;
begin
  with GetTCPClient do
  Begin
    WriteLn('LAY_BRINGTOFRONT');
    WriteLn(Self.Name);
    WriteInteger(ARecno);
    Result:=ReadInteger;
  End;
  If FClientHasAllData Then
    LocalLayer.BringEntityToFront(ARecno);
end;

Function TEzIndyLayer.SendEntityToBack(ARecno: Integer): Integer;
begin
  with GetTCPClient do
  Begin
    WriteLn('LAY_SENDTOBACK');
    WriteLn(Self.Name);
    WriteInteger(ARecno);
    Result:=ReadInteger;
  End;
  If FClientHasAllData Then
    LocalLayer.SendEntityToBack(ARecno);
end;

Function TEzIndyLayer.DeleteLayerFiles: Boolean;
begin
  with GetTCPClient do
  Begin
    WriteLn('LAY_DELETELAYERFILES');
    WriteLn(Self.Name);
    Result:= ReadSmallInt<>0;
  End;
  If FClientHasAllData Then
    LocalLayer.DeleteLayerFiles;
end;

Function TEzIndyLayer.GetActive: Boolean;
begin
  If Not FClientHasAllData Then
  begin
    with GetTCPClient do
    Begin
      WriteLn('LAY_GETACTIVE');
      WriteLn(Self.Name);
      Result:= ReadSmallInt<>0;
    End;
  End Else
    Result:= LocalLayer.Active;
end;

Procedure TEzIndyLayer.SetActive(Value: Boolean);
begin
  If Not FClientHasAllData Then
  begin
    with GetTCPClient do
    Begin
      WriteLn('LAY_SETACTIVE');
      WriteLn(Self.Name);
      WriteSmallInt(Ord(Value));
    End;
  End Else
    LocalLayer.Active:= value;
end;

Procedure TEzIndyLayer.Synchronize;
begin
  If Not FClientHasAllData Then
  begin
    with GetTCPClient do
    Begin
      WriteLn('LAY_SYNCHRONIZE');
      WriteLn(Self.Name);
    End;
  End Else
    LocalLayer.Synchronize;
end;

//----------------- TEzIndyLayers - class implementation ----------------------

Function TEzIndyLayers.IsClientServer: Boolean;
Begin
  Result := true;
End;

Function TEzIndyLayers.Add( Const FileName: String; LayerType: TEzLayerType ): Integer;
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

Function TEzIndyLayers.CreateNew( Const FileName: String; FieldList: TStrings ): TEzBaseLayer;
Var
  CanInsert: Boolean;
Begin
  // no debe de poderse crear aqui
  CanInsert := true;
  If Assigned( GIS.OnBeforeInsertLayer ) Then
    GIS.OnBeforeInsertLayer( GIS, FileName, CanInsert );

  //Result := AddLayerTo( GIS As TEzIndyClientGIS, FileName,
  //  GIS.MapInfo.CoordSystem, GIS.MapInfo.CoordsUnits, FieldList );

  If Assigned( GIS.OnAfterInsertLayer ) Then
    GIS.OnAfterInsertLayer( GIS, FileName );
End;


Function TEzIndyLayers.CreateNewEx( Const FileName: String; CoordSystem: TEzCoordSystem;
  CoordsUnits: TEzCoordsUnits; FieldList: TStrings ): TEzBaseLayer;
Var
  CanInsert: Boolean;
Begin
  // no debe de poderse crear aqui
  CanInsert := true;
  If Assigned( GIS.OnBeforeInsertLayer ) Then
    GIS.OnBeforeInsertLayer( GIS, FileName, CanInsert );

  //Result := AddLayerTo( GIS As TEzIndyClientGIS, FileName, CoordSystem, CoordsUnits, FieldList );

  If Assigned( GIS.OnAfterInsertLayer ) Then
    GIS.OnAfterInsertLayer( GIS, FileName );
End;

Function TEzIndyLayers.CreateNewCosmethic( Const FileName: String ): TEzBaseLayer;
Var
  CanInsert: Boolean;
Begin
  // no debe de poderse crear aqui
  Result := Nil;
  CanInsert := true;
  If Assigned( GIS.OnBeforeInsertLayer ) Then
    GIS.OnBeforeInsertLayer( GIS, FileName, CanInsert );
  If Not CanInsert Then Exit;
  If FileExists( FileName ) Then
    SysUtils.DeleteFile( FileName );

  //Result := ezbasicctrls.AddLayerTo( GIS, FileName,
  //                                   FALSE, FALSE, ltMemory,
  //                                   GIS.MapInfo.CoordSystem,
  //                                   GIS.MapInfo.CoordsUnits, Nil );

  If Assigned( GIS.OnAfterInsertLayer ) Then
    GIS.OnAfterInsertLayer( GIS, FileName );
End;

Function TEzIndyLayers.CreateNewAnimation( Const FileName: String ): TEzBaseLayer;
Var
  CanInsert: Boolean;
Begin
  // no se puede en esta version
  Result := Nil;
  CanInsert := true;
  If Assigned( GIS.OnBeforeInsertLayer ) Then
    GIS.OnBeforeInsertLayer( GIS, FileName, CanInsert );
  If Not CanInsert Then Exit;

  //Result := ezbasicctrls.AddLayerTo( GIS, FileName,
  //  TRUE, FALSE, ltDesktop,
  //  GIS.MapInfo.CoordSystem,
  //  GIS.MapInfo.CoordsUnits, Nil );

  If Assigned( GIS.OnAfterInsertLayer ) Then
    GIS.OnAfterInsertLayer( GIS, FileName );
End;

Function TEzIndyLayers.Delete( Const LayerName: String; DeleteFiles: Boolean ): Boolean;
Begin
  // no se permiten borrar capas mas que en el servidor
  Result:= false;
End;


{-------------------------------------------------------------------------------}
{                  TEzIndyMapInfo - class implementation                       }
{-------------------------------------------------------------------------------}

Function TEzIndyMapInfo.BufferGIS: TEzGIS;
Begin
  Result:= TEzIndyClientGIS(GIS).FBufferGIS;
End;

Function TEzIndyMapInfo.IsBuffered: Boolean;
Begin
  With TEzIndyClientGIS(GIS) Do
    Result:= FClientBuffered And FBufferGIS.Active;
End;

Function TEzIndyMapInfo.GetTCPClient: TIdTCPClient;
Begin
  Result:= TEzIndyClientGIS( GIS ).FTCPClient;
End;

Procedure TEzIndyMapInfo.Initialize;
Begin
  with GetTCPClient do
  Begin
    WriteLn('MI_INITIALIZE');
  End;
End;

Function TEzIndyMapInfo.IsValid: Boolean;
Begin
  If Not IsBuffered Then
  Begin
    If (GetTCPClient=Nil) Or Not TEzIndyClientGIS( GIS ).FTCPClient.Connected then
    begin
      Result:= False;
      exit;
    end;
    with TEzIndyClientGIS( GIS ).FTCPClient do
    Begin
      WriteLn('MI_ISVALID');
      Result:= ReadSmallInt<>0;
    End;
  End Else
    Result:= BufferGIS.MapInfo.IsValid;
End;

Function TEzIndyMapInfo.GetNumLayers: Integer;
Begin
  with GetTCPClient do
  Begin
    If Not IsBuffered Then
    Begin
      WriteLn('MI_GETNUMLAYERS');
      Result:= ReadInteger;
    End Else If BufferGIS <> Nil Then
      Result:= BufferGIS.MapInfo.NumLayers;
  End;
End;

Procedure TEzIndyMapInfo.SetNumLayers( Value: Integer );
Begin
  with GetTCPClient do
  Begin
    WriteLn('MI_SETNUMLAYERS');
    WriteInteger(Value);
    If BufferGIS <> Nil Then
      BufferGIS.MapInfo.NumLayers:= Value;
  End;
End;

Function TEzIndyMapInfo.GetExtension: TEzRect;
Begin
  with GetTCPClient do
  Begin
    If Not IsBuffered Then
    begin
      WriteLn('MI_GETEXTENSION');
      ReadBuffer(Result.x1,SizeOf(double));
      ReadBuffer(Result.y1,SizeOf(double));
      ReadBuffer(Result.x2,SizeOf(double));
      ReadBuffer(Result.y2,SizeOf(double));
    End Else If BufferGIS <> Nil Then
      result:= BufferGIS.MapInfo.Extension;
  End;
End;

Procedure TEzIndyMapInfo.SetExtension( Const Value: TEzRect );
Begin
  with GetTCPClient do
  Begin
    WriteLn('MI_SETEXTENSION');
    WriteBuffer(Value.x1,SizeOf(double));
    WriteBuffer(Value.y1,SizeOf(double));
    WriteBuffer(Value.x2,SizeOf(double));
    WriteBuffer(Value.y2,SizeOf(double));
    If BufferGIS <> Nil Then
      BufferGIS.MapInfo.Extension:=value;
  End;
End;

Function TEzIndyMapInfo.GetCurrentLayer: String;
Begin
  with GetTCPClient do
  Begin
    If Not IsBuffered Then
    Begin
      WriteLn('MI_GETCURRENTLAYER');
      Result:= ReadLn;
    End Else If BufferGIS <> Nil Then
      Result:= BufferGIS.MapInfo.CurrentLayer;
  end;
End;

Procedure TEzIndyMapInfo.SetCurrentLayer( Const Value: String );
Begin
  with GetTCPClient do
  Begin
    WriteLn('MI_SETCURRENTLAYER');
    WriteLn(Value);
    If BufferGIS <> Nil Then
      BufferGIS.MapInfo.CurrentLayer:= Value;
  End;
  Inherited SetCurrentLayer( Value );
  SetGisModifiedStatus( FGIS );
End;

Function TEzIndyMapInfo.GetAerialViewLayer: String;
Begin
  with GetTCPClient do
  Begin
    If Not IsBuffered Then
    Begin
      WriteLn('MI_GETAERIALVIEWLAYER');
      Result:= ReadLn;
    End Else If BufferGIS <> Nil Then
      Result:= BufferGIS.MapInfo.AerialViewLayer;
  end;
End;

Procedure TEzIndyMapInfo.SetAerialViewLayer( Const Value: String );
Begin
  with GetTCPClient do
  Begin
    WriteLn('MI_SETAERIALVIEWLAYER');
    WriteLn(Value);
    If BufferGIS <> Nil Then
      BufferGIS.MapInfo.AerialViewLayer:= Value;
  End;
  SetGisModifiedStatus( FGIS );
End;

Function TEzIndyMapInfo.GetLastView: TEzRect;
Begin
  with GetTCPClient do
  Begin
    If Not IsBuffered Then
    Begin
      WriteLn('MI_GETLASTVIEW');
      ReadBuffer(Result.x1,SizeOf(double));
      ReadBuffer(Result.y1,SizeOf(double));
      ReadBuffer(Result.x2,SizeOf(double));
      ReadBuffer(Result.y2,SizeOf(double));
    End Else If BufferGIS <> Nil Then
      Result:= BufferGIS.MapInfo.LastView;
  End;
End;

Procedure TEzIndyMapInfo.SetLastView( Const Value: TEzRect );
Begin
  with GetTCPClient do
  Begin
    WriteLn('MI_SETLASTVIEW');
    WriteBuffer(Value.x1,SizeOf(double));
    WriteBuffer(Value.y1,SizeOf(double));
    WriteBuffer(Value.x2,SizeOf(double));
    WriteBuffer(Value.y2,SizeOf(double));
    If BufferGIS <> Nil Then
      BufferGIS.MapInfo.LastView:= Value;
  End;
End;

Function TEzIndyMapInfo.GetCoordSystem: TEzCoordSystem;
Begin
  with GetTCPClient do
  Begin
    If Not IsBuffered Then
    Begin
      WriteLn('MI_GETCOORDSYS');
      Result:= TEzCoordSystem( ReadSmallInt );
    End Else If BufferGIS <> Nil Then
      Result:= BufferGIS.MapInfo.CoordSystem;
  end;
End;

Procedure TEzIndyMapInfo.SetCoordSystem( Value: TEzCoordSystem );
Begin
  with GetTCPClient do
  Begin
    WriteLn('MI_SETCOORDSYS');
    WriteSmallInt(ord(value));
    If BufferGIS <> Nil Then
      BufferGIS.MapInfo.CoordSystem:= Value;
  End;
  SetGisModifiedStatus( FGIS );
End;

Function TEzIndyMapInfo.GetCoordsUnits: TEzCoordsUnits;
Begin
  with GetTCPClient do
  Begin
    If Not IsBuffered Then
    Begin
      WriteLn('MI_GETCOORDSUNITS');
      Result:= TEzCoordsUnits( ReadSmallInt);
    End Else If BufferGIS <> Nil Then
      Result:= BufferGIS.MapInfo.CoordsUnits;
  End;
End;

Procedure TEzIndyMapInfo.SetCoordsUnits( Value: TEzCoordsUnits );
Begin
  with GetTCPClient do
  Begin
    WriteLn('MI_SETCOORDSUNITS');
    WriteSmallInt(ord(value));
    If BufferGIS <> Nil Then
      BufferGIS.MapInfo.CoordsUnits:= Value;
  End;
  SetGisModifiedStatus( FGIS );
End;

Function TEzIndyMapInfo.GetIsAreaClipped: Boolean;
Begin
  with GetTCPClient do
  Begin
    If Not IsBuffered Then
    Begin
      WriteLn('MI_GETISAREACLIPPED');
      Result:= ReadSmallInt<>0;
    End Else If BufferGIS <> Nil Then
      Result:= BufferGIS.MapInfo.IsAreaClipped;
  End;
End;

Procedure TEzIndyMapInfo.SetIsAreaClipped( Value: Boolean );
Begin
  with GetTCPClient do
  Begin
    WriteLn('MI_SETISAREACLIPPED');
    WriteSmallInt(ord(value));
    If BufferGIS <> Nil Then
      BufferGIS.MapInfo.IsAreaClipped:= Value;
  End;
  SetGisModifiedStatus( FGIS );
End;

Function TEzIndyMapInfo.GetAreaClipped: TEzRect;
Begin
  with GetTCPClient do
  Begin
    If Not IsBuffered Then
    Begin
      WriteLn('MI_GETAREACLIPPED');
      ReadBuffer(Result.x1,SizeOf(double));
      ReadBuffer(Result.y1,SizeOf(double));
      ReadBuffer(Result.x2,SizeOf(double));
      ReadBuffer(Result.y2,SizeOf(double));
    End Else If BufferGIS <> Nil Then
      Result:= BufferGIS.MapInfo.AreaClipped;
  End;
End;

Procedure TEzIndyMapInfo.SetAreaClipped( Const Value: TEzRect );
Begin
  with GetTCPClient do
  Begin
    WriteLn('MI_SETAREACLIPPED');
    WriteBuffer(value.x1,SizeOf(double));
    WriteBuffer(value.y1,SizeOf(double));
    WriteBuffer(value.x2,SizeOf(double));
    WriteBuffer(value.y2,SizeOf(double));
    If BufferGIS <> Nil Then
      BufferGIS.MapInfo.AreaClipped:= Value;
  End;
  SetGisModifiedStatus( FGIS );
End;

Function TEzIndyMapInfo.GetClipAreaKind: TEzClipAreaKind;
Begin
  with GetTCPClient do
  Begin
    If Not IsBuffered Then
    Begin
      WriteLn('MI_GETCLIPAREAKIND');
      Result:= TEzClipAreaKind( ReadSmallInt);
    End Else If BufferGIS <> Nil Then
      Result:= BufferGIS.MapInfo.ClipAreaKind;
  End;
End;

Procedure TEzIndyMapInfo.SetClipAreaKind( Value: TEzClipAreaKind );
Begin
  with GetTCPClient do
  Begin
    WriteLn('MI_SETCLIPAREAKIND');
    WriteSmallInt(ord(value));
    If BufferGIS <> Nil Then
      BufferGIS.MapInfo.ClipAreaKind:= Value;
  End;
  SetGisModifiedStatus( FGIS );
End;

{-------------------------------------------------------------------------------}
{                  TEzIndyClientGIS - class implementation                             }
{-------------------------------------------------------------------------------}

Constructor TEzIndyClientGIS.Create( Aowner: TComponent );
Begin

  Layers := TEzIndyLayers.Create( Self );
  Inherited Create( AOwner );
  FMapInfo := TEzIndyMapInfo.Create( Self );  { destroyed in the parent class }

{$IFDEF MW_TRIAL_VERSION}
  If Not IsDesigning Then
  Begin
    If Not SecurityCheckIfValid( true ) Then
      Application.Terminate;
    Inc( ADOGisInstances );
  End;
{$ENDIF}

  FTransportBufferSize:= 1000;
  FBufferGIS:= TEzGIS.Create(Nil);
  FNonBufferedLayers:= TStringList.Create

End;

Destructor TEzIndyClientGIS.Destroy;
Begin

{$IFDEF MW_TRIAL_VERSION}
  If Not IsDesigning Then
  Begin
    Dec( ADOGisInstances );
    If ADOGisInstances = 0 Then
      SecurityEndProgram;
  End;
{$ENDIF}

  FreeAndNil( FBufferGIS );

  FNonBufferedLayers.Free;

  Inherited Destroy;
End;

Procedure TEzIndyClientGIS.Connect;
var
  alogin, apasswd: string;
Begin
  if Not Assigned( FTCPClient ) then Exit;
  If Not FTCPClient.Connected Then
    FTCPClient.Connect;
  alogin:= Self.Login;
  if Length(Trim(aLogin))=0 then aLogin:= 'Login';
  apasswd:= Self.FPassword;
  if Length(Trim(apasswd))=0 then apasswd:= 'Password';
  // send to the server the command for connecting
  FTCPClient.WriteLn(Format('OPEN %s %s %s', [aLogin, apasswd, FileName] ));
  Open;
End;

Procedure TEzIndyClientGIS.Disconnect;
Begin
  if Not Assigned( FTCPClient ) Or Not FTCPClient.Connected then Exit;
  FTCPClient.Disconnect;
  Close;
End;

Procedure TEzIndyClientGIS.Notification( AComponent: TComponent; Operation: TOperation );
begin
  Inherited Notification( AComponent, Operation );
  If ( Operation = opRemove ) And ( AComponent = FTCPClient) Then
    FTCPClient:= Nil
end;

Procedure TEzIndyClientGIS.SetIdTCPClient(Value: TIdTCPClient);
begin
{$IFDEF LEVEL5}
  if Assigned( FTCPClient ) then FTCPClient.RemoveFreeNotification( Self );
{$ENDIF}
  If ( Value <> Nil ) And ( Value <> FTCPClient ) Then
  Begin
    Value.FreeNotification( Self );
  End;
  FTCPClient := Value;
end;

Procedure TEzIndyClientGIS.AddGeoref(const LayerName, FileName: String);
Begin
  with FTCPClient do
  Begin
    WriteLn('GIS_ADDGEOREF');
    WriteLn(LayerName);
    WriteLn(FileName);
  End;
end;

Function TEzIndyClientGIS.CreateLayer(const LayerName: String; LayerType: TEzLayerType): TEzBaseLayer;
begin
  If LayerType = ltMemory Then
    Result := TEzMemoryLayer.Create( Layers, LayerName )
  Else If LayerType = ltDesktop then
    Result := TEzLayer.Create( Layers, LayerName )
  Else if LayerType = ltClientServer then
    Result:= TEzIndyLayer.Create( Layers, LayerName )
  Else
    Result:= nil;
end;

Procedure TEzIndyClientGIS.CreateNew(const FileName: String);
Begin
  with FTCPClient do
  Begin
    WriteLn('GIS_CREATENEW'); // not yet working
    WriteLn(FileName);
  End;
end;

Function TEzIndyClientGIS.GetGISVersion: TEzAbout;
begin
  Result:= SEz_GisIndyVersion;
end;

Procedure TEzIndyClientGIS.SetGISVersion(const Value: TEzAbout);
begin
end;

Function TEzIndyClientGIS.IsClientServer: Boolean;
Begin

  with FTCPClient do
  Begin
    WriteLn('GIS_ISCLIENTSERVER');
    Result:= ReadSmallInt<>0;
  End;
End;

Procedure TEzIndyClientGIS.UpdateInfoFromServer;
Var
  i,n: Integer;
  TempStrings: TStrings;
  value: double;
  stream: TStream;
Begin

  { read the layers }
  Layers.Clear;
  with FTCPClient do
  Begin
    WriteLn('GIS_GETLAYERLIST');
    TempStrings:= TStringList.Create;
    try
      ReadStrings(TempStrings);
      { now add the layers }
      for I:= 0 to TempStrings.Count-1 do
      begin
        TEzIndyLayer.Create( Layers, TempStrings[I] );
      end;
    finally
      TempStrings.free;
    end;

    { read projection params }
    ProjectionParams.Clear;
    WriteLn('GIS_GETPROJPARAMS');
    TempStrings:= TStringList.Create;
    try
      ReadStrings(TempStrings);
      ProjectionParams.Assign(TempStrings);
    finally
      TempStrings.free;
    end;
    { read guidelines }
    HGuidelines.Clear;
    WriteLn('GIS_GETHGUIDELINES');
    n:= ReadInteger;
    for i:= 0 to n-1 do
    begin
      ReadBuffer(value,SizeOf(double));
      HGuidelines.Add(value);
    end;

    VGuidelines.Clear;
    WriteLn('GIS_GETVGUIDELINES');
    n:= ReadInteger;
    for i:= 0 to n-1 do
    begin
      ReadBuffer(value,SizeOf(double));
      VGuidelines.Add(value);
    end;
    { read the polygonal clipping area }
    ClipPolygonalArea.Clear;
    WriteLn('GIS_GETPOLYCLIPAREA');
    stream:= TMemoryStream.Create;
    try
      ReadStream(Stream,-1,False);
{$IFDEF TRANSPORT_COMPRESSED}
      Stream.Position:= 0;
      DeCompressmemStream(TMemoryStream(Stream));
{$ENDIF}
      Stream.Position:= 0;
      ClipPolygonalArea.LoadFromStream(stream);
    finally
      stream.free;
    end;
  End;
End;

Procedure TEzIndyClientGIS.InvalidateClientBuffer( const LayerName: string );

  Procedure InvalidateOne(Layer: TEzIndyLayer);
  var
    LocalLayer: TEzBaseLayer;
    TempBaseTableClass: TEzBaseTableClass;
  Begin
    //If Layer = Nil Then Exit;
    LocalLayer:= Layer.LocalLayer;
    If LocalLayer = Nil Then Exit;
    { configure for local database access }
    TempBaseTableClass:= EzBaseGIS.BaseTableClass;
    EzBaseGIS.BaseTableClass:= EzImpl.GetDesktopBaseTableClass;
    Try
      LocalLayer.Zap;
    Finally
      EzBaseGIS.BaseTableClass:= TempBaseTableClass;
    End;
    Layer.FMWSparseList.Clear;
    Layer.FClientHasAllData:= False;
  End;

var
  I: Integer;
begin
  If Length(LayerName) = 0 Then
  Begin
    For I:= 0 to Layers.Count-1 do
      InvalidateOne( Layers[I] As TEzIndyLayer );
  End Else
    InvalidateOne( Layers.layerByName( LayerName ) As TEzIndyLayer );
end;

Procedure TEzIndyClientGIS.LoadFullLayerToBuffer( const LayerName: string );

  Procedure LoadFullOne(Layer: TEzIndyLayer);
  var
    LocalLayer: TEzBaseLayer;
    TempEntity: TEzEntity;
    J: Integer;
  Begin
    //If Layer = Nil Then Exit;
    LocalLayer:= Layer.LocalLayer;
    If LocalLayer = Nil Then Exit;
    { load only entities that are not already on the buffer map }
    Layer.StartBuffering;
    Layer.First;
    While Not Layer.Eof Do
    Begin
      If Layer.RecIsDeleted then
      begin
        Layer.Next;
        Continue;
      end;
      TempEntity:= Layer.RecLoadEntity;
      Try
        Layer.LocalRecno[Layer.Recno]:= LocalLayer.AddEntity(TempEntity);
        Layer.TransportImage(TempEntity);
        { now save the DBTable information }
        If FDataBuffered And (LocalLayer.DBTable <> Nil ) And (Layer.DBTable <> Nil) Then
        begin
          LocalLayer.Recno:= Layer.LocalRecno[Layer.Recno];
          LocalLayer.DBTable.BeginTrans;
          Try
            LocalLayer.DBTable.Edit;
            Layer.DBTable.Recno:= Layer.Recno;
            For J := 1 To Layer.DBTable.FieldCount Do
            Begin
              Try
                With LocalLayer.DBTable Do
                  AssignFrom( Layer.DBTable, J, FieldNo( Layer.DBTable.Field( J ) ) );
              Except
                // ignore error in fields in DBF file (wrong data)
              End;
            End;
            LocalLayer.DBTable.Post;
            LocalLayer.DBTable.EndTrans;
          Except
            LocalLayer.DBTable.RollbackTrans;
            raise;
          End;
        end;
      Finally
        TempEntity.Free;
      End;
      Layer.Next;
    End;
    Layer.StartBuffering;
    Layer.FClientHasAllData:= True;
  End;

var
  I: Integer;
begin
  InvalidateClientBuffer( LayerName );
  If Length(LayerName) = 0 Then
  Begin
    For I:= 0 to Layers.Count-1 do
      LoadFullOne( Layers[I] As TEzIndyLayer );
  End Else
    LoadFullOne( Layers.layerByName( LayerName ) As TEzIndyLayer );
end;

Procedure TEzIndyClientGIS.Open;
var
  i: Integer;
  LastView: TEzRect;
  FileName: string;
  TempClientBuffered: Boolean;

  Procedure CreateClientLocalMap;
  Var
    I: Integer;
    Source, Local: TEzBaseLayer;
    FieldList: TStrings;
    TempBaseTableClass: TEzBaseTableClass;
    TempClientBuffered: Boolean;
  Begin
    If FBufferGIS.Active Then
      FBufferGIS.SaveIfModified;
    FBufferGIS.Close;
    If Not FClientBuffered Then Exit;

    { Create a temporary project }
    If FClientBuffered And DirectoryExists(RemoveSlash(LayersSubdir)) Then
    Begin
      TempClientBuffered:= FClientBuffered;
      FClientBuffered:= False;
      { create a new map }
      FileName:= AddSlash(LayersSubDir) + 'Buffer.ezm';
      { delete possible existing files }
      EzSystem.DeleteFilesSameName(Filename);
      FBufferGIS.CreateNew(FileName);
      FBufferGIS.Open;
      FBufferGIS.MapInfo.Assign( Self.MapInfo );
      FBufferGIS.MapInfo.NumLayers:= 0;
      { Create the layers }
      TempBaseTableClass:= EzBaseGIS.BaseTableClass;
      EzBaseGIS.BaseTableClass:= EzImpl.GetDesktopBaseTableClass;
      FieldList:= TStringList.Create;
      Try
        For I:= 0 to Self.Layers.Count - 1 do
        Begin
          Source:= Self.Layers[I];

          FileName:= AddSlash(LayersSubdir) + Source.Name;

          { first delete possible files existing there }
          EzSystem.DeleteFilesSameName(FileName);

          { extract the field names }
          Source.GetFieldList( FieldList );
          { now build a local layer with same fields }
          Local:= FBufferGIS.Layers.CreateNewEx( FileName, Source.LayerInfo.CoordSystem,
            Source.LayerInfo.CoordsUnits, FieldList );

          Local.Assign( Source );
          Local.LayerInfo.CoordsUnits := Self.MapInfo.CoordsUnits;

          { initialize links from server records to local records }
          With TEzIndyLayer(Source) Do
          Begin
            FServerRecordCount:= GetRecordCount;
          End;

        End;
      Finally
        FieldList.Free;
        EzBaseGIS.BaseTableClass:= TempBaseTableClass;
        FClientBuffered:= TempClientBuffered;
      End;
    End Else
      FClientBuffered:= False;
  End;

Begin
  If (FTCPClient=Nil) Or IsDesigning Or Not FTCPClient.Connected Then Exit;

  Close;

  Inherited Open;

  TempClientBuffered:= FClientBuffered;
  FClientBuffered:= False;

  UpdateInfoFromServer;

  If ( Layers.IndexOfName( MapInfo.CurrentLayer ) < 0 ) And ( Layers.Count > 0 ) Then
    CurrentLayerName := Layers[0].Name
  Else
    CurrentLayerName := MapInfo.CurrentLayer;

  If Assigned( OnCurrentLayerChange ) Then
    OnCurrentLayerChange( Self, CurrentLayerName );

  If Assigned( OnFileNameChange ) Then
    OnFileNameChange( Self );

  For I := 0 To DrawBoxList.Count - 1 Do
    DrawBoxList[I].TempEntities.Clear;

  LastView := MapInfo.LastView;

  For I := 0 To DrawBoxList.Count - 1 Do
    With DrawBoxList[I] Do
    Begin
      If Self.AutoSetLastView Then
        Grapher.SetViewTo( LastView );
      Grapher.Clear;
    End;

  { Read locally if FClientBuffered = True }
  FClientBuffered:= TempClientBuffered;

  CreateClientLocalMap;

End;

Procedure TEzIndyClientGIS.SaveAs( Const FileName: String );
Begin
  with FTCPClient do
  Begin
    WriteLn('GIS_SAVE');
  End;
  If FClientBuffered And FBufferGIS.Active Then
    FBufferGIS.SaveAs( FBufferGIS.Filename );
End;

Procedure TEzIndyClientGIS.LoadLineTypesFromServer;
var
  Stream: TStream;
begin
  If (TCPClient=Nil) Or Not TCPClient.Connected Then Exit;
  // GS stands for "G"eneral "S"ervice
  TCPClient.WriteLn('GS_LOADLINETYPES');
  Stream:= TMemoryStream.create;
  try
    TCPClient.ReadStream(Stream,-1,False);
{$IFDEF TRANSPORT_COMPRESSED}
    Stream.Position:= 0;
    DeCompressmemStream(TMemoryStream(Stream));
{$ENDIF}
    Stream.Position:= 0;
    { now load the symbols from the stream }
    Ez_LineTypes.LoadFromStream(Stream);
  finally
    Stream.free;
  end;
end;

Procedure TEzIndyClientGIS.LoadSymbolsFromServer;
var
  Stream: TStream;
begin
  If (TCPClient=Nil) Or Not TCPClient.Connected Then Exit;
  // GS stands for "G"eneral "S"ervice
  TCPClient.WriteLn('GS_LOADSYMBOLS');
  Stream:= TMemoryStream.create;
  try
    TCPClient.ReadStream(Stream,-1,False);
{$IFDEF TRANSPORT_COMPRESSED}
    Stream.Position:= 0;
    DeCompressmemStream(TMemoryStream(Stream));
{$ENDIF}
    Stream.Position:= 0;
    { now load the symbols from the stream }
    Ez_Symbols.LoadFromStream(Stream);
  finally
    Stream.free;
  end;
end;

Procedure TEzIndyClientGIS.LoadVectorialFontsFromServer;
var
  Stream: TStream;
  VectorFont: TEzVectorFont;
  I, n: Integer;
begin
  If (TCPClient=Nil) Or Not TCPClient.Connected Then Exit;
  // GS stands for "G"eneral "S"ervice
  TCPClient.WriteLn('GS_LOADVECTFONTS');
  Stream:= TMemoryStream.create;
  Ez_VectorFonts.Clear;
  try
    n:= TCPClient.ReadInteger;
    TCPClient.ReadStream(Stream,-1,False);
{$IFDEF TRANSPORT_COMPRESSED}
    Stream.Position:= 0;
    DeCompressmemStream(TMemoryStream(Stream));
{$ENDIF}
    Stream.Position:= 0;
    For I:= 1 to n do
    begin
      VectorFont := TEzVectorFont.Create;
      VectorFont.LoadFromStream( Stream );
      Ez_VectorFonts.AddFont( VectorFont );
    end;
  finally
    Stream.free;
  end;
end;

initialization
  EzBaseGIS.BaseTableClass := TEzIndyTable;

End.
