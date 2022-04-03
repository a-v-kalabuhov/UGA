Unit EzCtrls;

{***********************************************************}
{     EzGIS/CAD Components                                  }
{   (c) 2002 EzSoft Engineering                             }
{         All Rights Reserved                               }
{***********************************************************}

{$I EZ_FLAG.PAS}
Interface

Uses
  SysUtils, Classes, Windows, StdCtrls, Controls, Graphics, Printers, ExtCtrls,
  Forms, EzBaseExpr, EzLib, EzSystem, EzBase, EzRtree, EzBaseGIS, EzEntities,
  Db, EzBasicCtrls;

Type

  {------------------------------------------------------------------------------}
  //            TEzLayerInfo
  {------------------------------------------------------------------------------}

  { Entities index info ( file .EZX ) }
{$IFNDEF SWAPPED_FORMAT}
  PEzxData = ^TEzxData;
  TEzxData = Packed Record
    Case Integer Of
      // the header
      0: (
        HeaderID: smallint;
        VersionNumber: SmallInt;
        RecordCount: Integer;
        MaxRecSize: Integer );
      // the info
      1: (
        Offset: Longint; // Offset in file .ent
        EntityID: TEzEntityID; // kind of entity
        Extension: TEzRect; // max, min extension of entity
        IsDeleted: Boolean ); // is deleted?
  End;
{$ELSE}
  PEzxData = ^TEzxData;
  TEzxData = Packed Record
    Case Integer Of
      // the header
      0: (
        MaxRecSize: Integer;
        RecordCount: Integer;
        VersionNumber: SmallInt;
        HeaderID: smallint );
      // the info
      1: (
        IsDeleted: Boolean; // is deleted?
        Extension: TEzRect; // max, min extension of entity
        EntityID: TEzEntityID; // kind of entity
        Offset: Longint ); // Offset in file .ent
  End;
{$ENDIF}

  TEzLayerInfo = Class( TEzBaseLayerInfo )
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

  {------------------------------------------------------------------------------}
  //            TEzLayer
  {------------------------------------------------------------------------------}

  TEzLayer = Class( TEzBaseLayer )
  Private
    { to open .EZD and .EZX files }
    FHeader: TEzLayerHeader;
    FEzDStream: TStream;
    FEzXStream: TStream;
    FDBTable: TEzBaseTable;
    FUpdateRtree: Boolean;
    FCurrentLoaded: integer;

    { current record information }
    FRecno: Integer;
    FEofCrack: Boolean;
    ol: TIntegerList;
    FFilterRecno: Integer;
    FFiltered: boolean;
    { follows the data that will be read in buffering}
    FEzxData: TEzxData;
    { buffering }
    FBuffEnx, FBuffEnt: TEzBufferedRead;

    FProposedID: Integer; { FProposedID = internal use }

    Procedure ReReadEntHeader;
    Procedure DoPack( ShowMessages: Boolean );
    Function InternalLoadEntity( EntityID: TEzEntityID; Stream: TStream ): TEzEntity;
    Procedure UpdateMapExtension( Const R: TEzRect );
    Function BuffEnt: TStream;
  Protected
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
    Function RecIsDeleted: boolean; Override;
    Procedure RecLoadEntity2( Entity: TEzEntity ); Override;
    Function RecLoadEntity: TEzEntity; Override;
    Function RecExtension: TEzRect; Override;
    Function RecEntityID: TEzEntityID; Override;
    Procedure StartBatchInsert; Override;
    Procedure CancelBatchInsert; Override;
    Procedure FinishBatchInsert; Override;
    Procedure GetFieldList( Strings: TStrings ); Override;
    Function DeleteLayerFiles: Boolean; Override;

    Procedure RebuildTree; Override;

    Procedure CopyRecord( SourceRecno, DestRecno: Integer ); Override;
    Function DefineScope( Const Scope: String ): Boolean; Override;
    Function DefinePolygonScope( Polygon: TEzEntity; Const Scope: String;
      Operator: TEzGraphicOperator ): Boolean; Override;
    function GetExtensionForRecords( List: TIntegerList ): TEzRect; Override;

  End;

  {-----------------------------------------------------------------------------}
  //                   TEzDataSetProvider
  {-----------------------------------------------------------------------------}

  TEzOpenTableEvent = Procedure( Sender: TObject; const FileName: string; ReadWrite, Shared: Boolean;
	  var Dataset: TDataSet; var AutoDispose: Boolean ) Of Object;
  TEzTableFileEvent = Procedure( Sender: TObject; const FileName: string ) Of Object;
  TEzRenameTableEvent = Procedure( Sender: TObject; const SourceFileName, TargetFileName: string ) Of Object;
  TEzQueryTableExistsEvent = Procedure( Sender: TObject; const FileName: string; var Exists: Boolean )Of Object;
  TEzCreateTableEvent = Procedure( Sender: TObject; const FileName: string; FieldList: TStrings ) Of Object;
  TEzGetRecnoEvent = Procedure( Sender: TObject; DataSet: TDataSet; var Recno: Integer ) Of Object;
  TEzRecnoEvent = Procedure( Sender: TObject; Dataset: TDataset; Recno: Integer ) Of Object;
  TEzGetIsDeletedEvent = Procedure( Sender: TObject; DataSet: TDataSet; var IsDeleted: Boolean ) Of Object;
  TEzGetRecordCountEvent = Procedure( Sender: TObject; DataSet: TDataSet; var RecordCount: Integer ) Of Object;
  TEzDataSetEvent = Procedure( Sender: TObject; DataSet: TDataSet ) Of Object;

  TEzDataSetProvider = Class( TComponent )
  Private
    FOnOpenTable: TEzOpenTableEvent;
    FOnDropIndexFile: TEzTableFileEvent;
    FOnDropTable: TEzTableFileEvent;
    FOnRenameTable: TEzRenameTableEvent;
    FOnQueryTableExists: TEzQueryTableExistsEvent;
    FOnCreateTable: TEzCreateTableEvent;
    FOnGetRecno: TEzGetRecnoEvent;
    FOnSetToRecno: TEzRecnoEvent;
    FOnGetIsDeleted: TEzGetIsDeletedEvent;
    FOnAppendRecord: TEzRecnoEvent;
    FOnGetRecordCount: TEzGetRecordCountEvent;
    FOnDeleteRecord: TEzDataSetEvent;
    FOnFlushTable: TEzDataSetEvent;
    FOnPackTable: TEzDataSetEvent;
    FOnRecallRecord: TEzDataSetEvent;
    FOnZapTable: TEzDataSetEvent;
    FOnSetUseDeleted: TEzGetIsDeletedEvent;
  Published
    Property OnOpenTable: TEzOpenTableEvent read FOnOpenTable write FOnOpenTable;
    Property OnDropIndexFile: TEzTableFileEvent read FOnDropIndexFile write FOnDropIndexFile;
    Property OnDropTable: TEzTableFileEvent read FOnDropTable write FOnDropTable;
    Property OnRenameTable: TEzRenameTableEvent read FOnRenameTable write FOnRenameTable;
    Property OnQueryTableExists: TEzQueryTableExistsEvent read FOnQueryTableExists write FOnQueryTableExists;
    Property OnCreateTable: TEzCreateTableEvent read FOnCreateTable write FOnCreateTable;
    Property OnGetRecno: TEzGetRecnoEvent read FOnGetRecno write FOnGetRecno;
    Property OnSetToRecno: TEzRecnoEvent read FOnSetToRecno write FOnSetToRecno;
    Property OnGetIsDeleted: TEzGetIsDeletedEvent read FOnGetIsDeleted write FOnGetIsDeleted;
    Property OnAppendRecord: TEzRecnoEvent read FOnAppendRecord write FOnAppendRecord;
    Property OnGetRecordCount: TEzGetRecordCountEvent read FOnGetRecordCount write FOnGetRecordCount;
    Property OnDeleteRecord: TEzDataSetEvent read FOnDeleteRecord write FOnDeleteRecord;
    Property OnFlushTable: TEzDataSetEvent read FOnFlushTable write FOnFlushTable;
    Property OnPackTable: TEzDataSetEvent read FOnPackTable write FOnPackTable;
    Property OnRecallRecord: TEzDataSetEvent read FOnRecallRecord write FOnRecallRecord;
    Property OnZapTable: TEzDataSetEvent read FOnZapTable write FOnZapTable;
    Property OnSetUseDeleted: TEzGetIsDeletedEvent read FOnSetUseDeleted write FOnSetUseDeleted;
  End;


  {------------------------------------------------------------------------------}
  {                  TEzGIS component                                            }
  {------------------------------------------------------------------------------}

  TEzGIS = Class( TEzBaseGIS )
  private
    FProvider: TEzDataSetProvider;
    procedure SetProvider(const Value: TEzDataSetProvider);
  {$IFDEF BCB}
    function  GetProvider : TEzDataSetProvider;
  {$ENDIF}
  Protected
    Procedure WriteMapHeader( Const Filename: String ); Override;
    Procedure Notification( AComponent: TComponent; Operation: TOperation ); Override;
  Public
    Constructor Create( AOwner: TComponent ); Override;
    Function CreateLayer( Const LayerName: String; LayerType: TEzLayerType ): TEzBaseLayer; Override;
    Procedure Open; Override;
    Procedure SaveAs( Const Filename: String ); Override;
    Procedure AddGeoref( Const LayerName, FileName: String ); Override;
  Published
    Property Provider: TEzDataSetProvider {$IFDEF BCB} read GetProvider {$ELSE} read FProvider {$ENDIF} write SetProvider;
  End;

  TEzMemoryGIS = class( TEzBaseGIS )
  protected
    Procedure WriteMapHeader( Const Filename: String ); Override;
  public
    Constructor Create( AOwner: TComponent ); Override;
    Function CreateLayer( Const LayerName: String; LayerType: TEzLayerType ): TEzBaseLayer; Override;
    Procedure Open; Override;
    Procedure Close; Override;
    Procedure SaveAs( Const Filename: String ); Override;
    Procedure SaveToStream( Stream: TStream );
    Procedure LoadFromStream( Stream: TStream );
  end;

  {------------------------------------------------------------------------------}
  {                  TEzGeorefImage component                                    }
  {------------------------------------------------------------------------------}

    { TEzGeoRefPtRecord }
  TEzGeoRefPt = Record
    XPixel, YPixel: Integer; // corresponding image coordinates in pixels
    XWorld, YWorld: Double; // corresponding map world coordinates
  End;

  { TEzGeoreferencedPt }
  TEzGeorefPoint = Class( TCollectionItem )
  Private
    FGeoRefPt: TEzGeoRefPt;
    Function GetXPixel: Integer;
    Function GetXWorld: Double;
    Function GetYPixel: Integer;
    Function GetYWorld: Double;
    Procedure SetXPixel( Const Value: Integer );
    Procedure SetXWorld( Const Value: Double );
    Procedure SetYPixel( Const Value: Integer );
    Procedure SetYWorld( Const Value: Double );
  Protected
    Function GetDisplayName: String; Override;
    Function GetCaption: String;
  Public
    Procedure Assign( Source: TPersistent ); Override;
    Procedure LoadFromStream( Stream: TStream );
    Procedure SaveToStream( Stream: TStream );
  Published
    Property XPixel: Integer Read GetXPixel Write SetXPixel;
    Property YPixel: Integer Read GetYPixel Write SetYPixel;
    Property XWorld: Double Read GetXWorld Write SetXWorld;
    Property YWorld: Double Read GetYWorld Write SetYWorld;
  End;

  { TEzGeorefPoints }
  TEzGeorefPoints = Class( TOwnedCollection )
  Private
    Function GetItem( Index: Integer ): TEzGeorefPoint;
    Procedure SetItem( Index: Integer; Value: TEzGeorefPoint );
  Public
    Constructor Create( AOwner: TPersistent );
    Function Add: TEzGeorefPoint;
    Procedure LoadFromStream( Stream: TStream );
    Procedure SaveToStream( Stream: TStream );

    Property Items[Index: Integer]: TEzGeorefPoint Read GetItem Write SetItem; Default;
  End;

  { TEzGeorefImage component }
  TEzGeorefImage = Class( TComponent )
  Private
    FFileName: String;
    FImageName: String;
    FGeorefPoints: TEzGeorefPoints;
    FExtents: TEzRect;
    Procedure SetGeorefPoints( Value: TEzGeorefPoints );
  Public
    Constructor Create( AOwner: TComponent ); Override;
    Destructor Destroy; Override;
    Procedure Assign( Source: TPersistent ); Override;
    Procedure Open;
    Procedure Save;
    Procedure New;

    Property Extents: TEzRect Read FExtents Write FExtents;
  Published
    Property GeorefPoints: TEzGeorefPoints Read FGeorefPoints Write SetGeorefPoints;
    Property ImageName: String Read FImageName Write FImageName;
    Property FileName: String Read FFileName Write FFileName;
  End;




Implementation

Uses
  Inifiles, Ezconsts, ezimpl, EzNetwork, EzDGNLayer, EzExpressions;

Const
  LAYER_ID = 8003;
  LAYER_IDX = 8004;

type

  {-----------------------------------------------------------------------------}
  //                    a bookmark for desktop layers
  {-----------------------------------------------------------------------------}

  TEzDesktopBookmark = class
  private
    FRecno: Integer;
    FFiltered: Boolean;
    FEofCrack: Boolean;
    FFilterRecno: Integer;
    FCurrentLoaded: Integer;
    FEzxData: TEzxData;
    FEZDPos: Integer;
    FEZXPos: Integer;
    Fol: TIntegerList;
  Public
    constructor Create;
    destructor Destroy; Override;
  end;


{ TEzDesktopBookmark }

constructor TEzDesktopBookmark.Create;
begin
  inherited Create;
  Fol:= TIntegerList.Create;
end;

destructor TEzDesktopBookmark.Destroy;
begin
  Fol.Free;
  inherited Destroy;
end;


Procedure ExchangeDBRecord( Layer: TEzBaseLayer; SourceRecno, DestRecno: Integer );
Var
  cnt: Integer;
  SrcFieldValues, DstFieldValues: TStringList;
Begin
  With TEzLayer( Layer ) Do
  Begin
    If ( BaseTableClass = Nil ) Or Not FHeader.UseAttachedDB Or ( DBTable = Nil ) Or
      Not ( DBTable.Active ) Then Exit;

    //TmpDataSet:= BaseTableClass.Create(Layer.Filename,'', true,true);
    SrcFieldValues := TStringList.create;
    DstFieldValues := TStringList.create;
    Try
      (* preserve the record sort order *)
      If Layer.DBTable.IndexCount <> 0 Then
        Layer.DBTable.Index( Layer.Name, '' );
      Layer.DBTable.Recno:= SourceRecno;
      For cnt := 1 To Layer.DBTable.FieldCount Do
      Begin
        SrcFieldValues.Add( Layer.DBTable.FieldGetN( cnt ) );
      End;
      Layer.DBTable.Recno:= DestRecno;
      For cnt := 1 To Layer.DBTable.FieldCount Do
      Begin
        DstFieldValues.Add( Layer.DBTable.FieldGetN( cnt ) );
      End;
      { exchange with source }
      Layer.DBTable.Recno:= SourceRecno;
      Layer.DBTable.Edit;
      For cnt := 1 To Layer.DBTable.FieldCount Do
      Begin
        Layer.DBTable.FieldPutN( cnt, DstFieldValues[cnt - 1] );
      End;
      Layer.DBTable.Post;
      { exchange with destination}
      Layer.DBTable.Recno:= DestRecno;
      Layer.DBTable.Edit;
      For cnt := 1 To Layer.DBTable.FieldCount Do
      Begin
        Layer.DBTable.FieldPutN( cnt, SrcFieldValues[cnt - 1] );
      End;
      Layer.DBTable.Post;
    Finally
      SrcFieldValues.Free;
      DstFieldValues.Free;
    End;
  End;
End;

{-------------------------------------------------------------------------------}
{                  TEzLayerInfo - class implementation                         }
{-------------------------------------------------------------------------------}

Function TEzLayerInfo.GetIsCosmethic: boolean;
Begin
  result := TEzLayer( FLayer ).FHeader.IsMemoryLayer;
End;

Procedure TEzLayerInfo.SetIsCosmethic( value: boolean );
Begin
  If TEzLayer( FLayer ).FHeader.IsMemoryLayer = value Then
    Exit;
  TEzLayer( FLayer ).FHeader.IsMemoryLayer := value;
  SetModifiedStatus( FLayer );
End;

Function TEzLayerInfo.GetLocked: Boolean;
Begin
  Result := TEzLayer( FLayer ).FHeader.Locked;
End;

Procedure TEzLayerInfo.SetLocked( Value: Boolean );
Begin
  TEzLayer( FLayer ).FHeader.Locked := Value;
End;

Function TEzLayerInfo.GetUseAttachedDB: boolean;
Begin
  result := TEzLayer( FLayer ).FHeader.UseAttachedDB;
End;

Procedure TEzLayerInfo.SetUseAttachedDB( Value: boolean );
Begin
  If TEzLayer( FLayer ).FHeader.UseAttachedDB = value Then
    Exit;
  TEzLayer( FLayer ).FHeader.UseAttachedDB := Value;
  SetModifiedStatus( FLayer );
End;

Function TEzLayerInfo.GetVisible: boolean;
Begin
  result := TEzLayer( FLayer ).FHeader.Visible;
End;

Procedure TEzLayerInfo.SetVisible( Value: boolean );
Begin
  If TEzLayer( FLayer ).FHeader.Visible = Value Then
    Exit;
  TEzLayer( FLayer ).FHeader.Visible := Value;
  If Assigned( FLayer.Layers.GIS.OnVisibleLayerChange ) Then
    FLayer.Layers.GIS.OnVisibleLayerChange( Self, FLayer.Name );
  SetModifiedStatus( FLayer );
End;

Function TEzLayerInfo.GetOverlappedTextAction: TEzOverlappedTextAction;
Begin
  result := TEzLayer( FLayer ).FHeader.OverlappedTextAction;
End;

Procedure TEzLayerInfo.SetOverlappedTextAction( Value: TEzOverlappedTextAction );
Begin
  If TEzLayer( FLayer ).FHeader.OverlappedTextAction = Value Then
    Exit;
  TEzLayer( FLayer ).FHeader.OverlappedTextAction := Value;
  SetModifiedStatus( FLayer );
End;

Function TEzLayerInfo.GetOverlappedTextColor: TColor;
Begin
  result := TEzLayer( FLayer ).FHeader.OverlappedTextColor;
End;

Procedure TEzLayerInfo.SetOverlappedTextColor( Value: TColor );
Begin
  If TEzLayer( FLayer ).FHeader.OverlappedTextColor = Value Then
    Exit;
  TEzLayer( FLayer ).FHeader.OverlappedTextColor := Value;
  SetModifiedStatus( FLayer );
End;

Function TEzLayerInfo.GetTextHasShadow: boolean;
Begin
  result := TEzLayer( FLayer ).FHeader.TextHasShadow;
End;

Procedure TEzLayerInfo.SetTextHasShadow( Value: boolean );
Begin
  If TEzLayer( FLayer ).FHeader.TextHasShadow = Value Then
    Exit;
  TEzLayer( FLayer ).FHeader.TextHasShadow := Value;
  SetModifiedStatus( FLayer );
End;

Function TEzLayerInfo.GetTextFixedSize: Byte;
Begin
  result := TEzLayer( FLayer ).FHeader.TextFixedSize;
End;

Procedure TEzLayerInfo.SetTextFixedSize( Value: Byte );
Begin
  If TEzLayer( FLayer ).FHeader.TextFixedSize = Value Then
    Exit;
  TEzLayer( FLayer ).FHeader.TextFixedSize := Value;
  SetModifiedStatus( FLayer );
End;

Function TEzLayerInfo.GetSelectable: boolean;
Begin
  result := TEzLayer( FLayer ).FHeader.Selectable;
End;

Procedure TEzLayerInfo.SetSelectable( Value: boolean );
Begin
  If TEzLayer( FLayer ).FHeader.Selectable = Value Then Exit;
  TEzLayer( FLayer ).FHeader.Selectable := Value;
  If Assigned( FLayer.Layers.GIS.OnSelectableLayerChange ) Then
    FLayer.Layers.GIS.OnSelectableLayerChange( Self, FLayer.Name );
  SetModifiedStatus( FLayer );
End;

Function TEzLayerInfo.GetExtension: TEzRect;
Begin
  result := TEzLayer( FLayer ).FHeader.Extension;
End;

Procedure TEzLayerInfo.SetExtension( Const Value: TEzRect );
Begin
  If EqualRect2D( Value, TEzLayer( FLayer ).FHeader.Extension ) Then
    Exit;
  TEzLayer( FLayer ).FHeader.Extension := Value;
  SetModifiedStatus( FLayer );
End;

Function TEzLayerInfo.GetIDCounter: integer;
Begin
  result := TEzLayer( FLayer ).FHeader.IDCounter;
End;

Procedure TEzLayerInfo.SetIDCounter( Value: integer );
Begin
  If TEzLayer( FLayer ).FHeader.IDCounter = Value Then
    Exit;
  TEzLayer( FLayer ).FHeader.IDCounter := Value;
  SetModifiedStatus( FLayer );
End;

Function TEzLayerInfo.GetIsAnimationLayer: boolean;
Begin
  result := TEzLayer( FLayer ).FHeader.IsAnimationLayer;
End;

Procedure TEzLayerInfo.SetIsAnimationLayer( Value: boolean );
Begin
  If TEzLayer( FLayer ).FHeader.IsAnimationLayer = Value Then
    Exit;
  TEzLayer( FLayer ).FHeader.IsAnimationLayer := Value;
  SetModifiedStatus( FLayer );
End;

Function TEzLayerInfo.GetCoordSystem: TEzCoordSystem;
Begin
  result := TEzLayer( FLayer ).FHeader.CoordSystem;
End;

Procedure TEzLayerInfo.SetCoordSystem( Value: TEzCoordSystem );
Begin
  If TEzLayer( FLayer ).FHeader.CoordSystem = Value Then
    Exit;
  With TEzLayer( FLayer ) Do
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

Function TEzLayerInfo.GetCoordsUnits: TEzCoordsUnits;
Begin
  result := TEzLayer( FLayer ).FHeader.CoordsUnits;
End;

Procedure TEzLayerInfo.SetCoordsUnits( Value: TEzCoordsUnits );
Begin
  With TEzLayer( FLayer ) Do
  Begin
    If FHeader.coordsunits = value Then Exit;
    If FHeader.CoordSystem = csLatLon Then
      FHeader.CoordsUnits := cuDeg
    Else
      FHeader.CoordsUnits := Value;
  End;
  SetModifiedStatus( FLayer );
End;

Function TEzLayerInfo.GetIsIndexed: boolean;
Begin
  With TEzLayer( FLayer ) Do
    result := FHeader.IsIndexed And ( Frt <> Nil );
End;

Procedure TEzLayerInfo.SetIsIndexed( Value: boolean );
Begin
  If TEzLayer( FLayer ).FHeader.IsIndexed = Value Then
    Exit;
  TEzLayer( FLayer ).FHeader.IsIndexed := Value;
  SetModifiedStatus( FLayer );
End;

{-------------------------------------------------------------------------------}
{                  TEzLayer - class implementation                                }
{-------------------------------------------------------------------------------}

Constructor TEzLayer.Create( Layers: TEzBaseLayers; Const AFileName: String );
Begin
  Inherited Create( Layers, AFileName );
  FLayerInfo := TEzLayerInfo.Create( self );
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

Destructor TEzLayer.Destroy;
Begin
  Close;
  If ol <> Nil Then
    ol.free;
  If FBuffEnx <> Nil Then
    FBuffEnx.Free;
  If FBuffEnt <> Nil Then
    FBuffEnt.Free;

  // FLayerInfo is destroyed in the inherited class

  Inherited Destroy;

End;

Procedure TEzLayer.Synchronize;
Begin
  If FDBTable <> Nil Then
    FDBTable.Recno := Self.Recno;
End;

function TEzLayer.DeleteLayerFiles: Boolean;
Begin
    Result:= False;
    if LayerInfo.Locked then Exit;
    Result:= EzSystem.DeleteFilesSameName( Self.FileName );
end;

Procedure TEzLayer.InitializeOnCreate( Const FileName: String;
  AttachedDB, IsAnimation: Boolean; CoordSystem: TEzCoordSystem;
  CoordsUnits: TEzCoordsUnits; FieldList: TStrings );
Var
  TempFieldList: TStringList;
  EzxHeader: TEzxData;
Begin
  FHeader.CoordsUnits := CoordsUnits;
  FHeader.CoordSystem := CoordSystem;
  FHeader.IsIndexed := true; // all this kind of layers must be indexed
  FHeader.IsAnimationLayer := IsAnimation;
  FHeader.UseAttachedDB := AttachedDB;
  FEzDStream := TFileStream.Create( FileName + EZDEXT, fmCreate );
  FEzDStream.Write( FHeader, SizeOf( TEzLayerHeader ) );
  FreeAndNil( FEzDStream );
  FreeAndNil( FBuffEnt );
  FEzXStream := TFileStream.Create( FileName + EZXEXT, fmCreate );
  EzxHeader.HeaderID := LAYER_IDX;
  EzxHeader.VersionNumber := LAYER_VERSION_NUMBER;
  EzxHeader.RecordCount := 0;
  EzxHeader.MaxRecSize := 0;
  FEzXStream.Write( EzxHeader, SizeOf( TEzxData ) );
  FreeAndNil( FEzXStream );
  If AttachedDB Then
  Begin
    // Create the DBF file with a standar ID field
    TempFieldList := TStringList.Create;
    Try
      If ( FieldList <> Nil ) And ( FieldList.Count > 0 ) Then
        TempFieldList.AddStrings( FieldList );
      If TempFieldList.Count = 0 Then
        TempFieldList.Add( 'UID;N;11;0' );
      with EzBaseGIS.BaseTableClass.createNoOpen( Layers.Gis ) do
        try
          DBCreateTable( FileName, TempFieldList );
        finally
          free;
        end;
    Finally
      TempFieldList.Free;
    End;
  End;
End;

Procedure TEzLayer.GetFieldList( Strings: TStrings );
Var
  i: Integer;
Begin
    If DBTable <> Nil Then
      For i := 1 To DBTable.FieldCount Do
        Strings.Add( Format( '%s;%s;%d;%d', [DBTable.Field( I ), DBTable.FieldType( I ),
          DBTable.FieldLen( I ), DBTable.FieldDec( I )] ) );
End;

Procedure TEzLayer.StartBatchInsert;
Begin
  FUpdateRtree := false;
End;

Procedure TEzLayer.CancelBatchInsert;
Begin
  FUpdateRtree := false;
End;

Procedure TEzLayer.FinishBatchInsert;
Begin
  FUpdateRtree := true;
  RebuildTree;
End;

Procedure TEzLayer.Zap;
Var
  I: Integer;
  EzxData: TEzxData;
Begin
    For I := 1 To FHeader.RecordCount Do
      With FEzXStream Do
      Begin
        Seek( I * sizeof( TEzxData ), 0 );
        Read( EzxData, sizeof( EzxData ) );
        EzxData.IsDeleted := TRUE;
        Seek( I * sizeof( TEzxData ), 0 );
        Write( EzxData, sizeof( EzxData ) );
      End;
  Pack( False );
End;

Function TEzLayer.GetDBTable: TEzBaseTable;
Begin
  Result := FDBTable;
End;

Function TEzLayer.BuffEnt: TStream;
Var
  EzxHeader: TEzxData;
Begin
    If FBuffEnt = Nil Then
    Begin
      With FEzXStream Do
      Begin
        Seek( 0, 0 );
        Read( EzxHeader, SizeOf( TEzxData ) );
      End;
      FBuffEnt := TEzBufferedRead.Create( FEzDStream, 1024 );
    End;
  Result := FBuffEnt;
End;

Function TEzLayer.GetRecno: Integer;
Begin
  If FFiltered Then
    result := Longint( ol[FFilterRecno] )
  Else
    result := FRecno;
End;

Procedure TEzLayer.SetRecno( Value: Integer );
Begin
  If ( Value < 1 ) Or ( Value > FHeader.RecordCount ) Then
    EzGISError( SRecnoInvalid );
  FRecno := Value;
End;

Function TEzLayer.SendEntityToBack( ARecno: Integer ): Integer;
Var
  EzxData, EzxDataN, EzxData1: TEzxData;
  I: Integer;
  found: boolean;
  Prev: Array[1..2] Of TEzRect;
Begin
  result := 0;
  If Layers.GIS.ReadOnly Or LayerInfo.Locked Then Exit;
  found := false;
  For I := 1 To FHeader.RecordCount Do
  Begin
    With FEzXStream Do
    Begin
      Seek( I * sizeof( TEzxData ), 0 );
      Read( EzxData, sizeof( EzxData ) );
      If Not EzxData.IsDeleted Then
      Begin
        found := true;
        break;
      End;
    End;
  End;
  If Not found Then Exit;
  result := I; // return the record to move
  If ARecno = I Then Exit;
  With FEzXStream Do
  Begin
    { read the selected record }
    Seek( result * SizeOf( TEzxData ), 0 );
    Read( EzxData1, SizeOf( TEzxData ) );
    Prev[1] := EzxData1.Extension;
    {read the selected record}
    Seek( ARecno * SizeOf( TEzxData ), 0 );
    Read( EzxDataN, SizeOf( TEzxData ) );
    Prev[2] := EzxDataN.Extension;
    {and swap}
    Seek( result * SizeOf( TEzxData ), 0 );
    Write( EzxDataN, SizeOf( TEzxData ) );
    Frt.Update( FloatRect2Rect( Prev[1] ), result, FloatRect2Rect( Prev[2] ) );
    Seek( ARecno * SizeOf( TEzxData ), 0 );
    Write( EzxData1, SizeOf( TEzxData ) );
    Frt.Update( FloatRect2Rect( Prev[2] ), ARecno, FloatRect2Rect( Prev[1] ) );
  End;
  ExchangeDBRecord( Self, 1, ARecno );
End;

Function TEzLayer.BringEntityToFront( ARecno: Integer ): Integer;
Var
  EzxData, EzxDataN, EzxDataLast: TEzxData;
  I: Integer;
  found: boolean;
  Prev: Array[1..2] Of TEzRect;
Begin
  result := 0;
  If Layers.GIS.ReadOnly Or LayerInfo.Locked Then Exit;
  found := false;
  For I := FHeader.RecordCount Downto 1 Do
  Begin
    With FEzXStream Do
    Begin
      Seek( I * sizeof( TEzxData ), 0 );
      Read( EzxData, sizeof( EzxData ) );
      If Not EzxData.IsDeleted Then
      Begin
        found := true;
        break;
      End;
    End;
  End;
  If Not found Then Exit;
  Result := I; // return the record to move
  With FEzXStream Do
  Begin
    { read the last record }
    Seek( Result * SizeOf( TEzxData ), 0 );
    Read( EzxDataLast, SizeOf( TEzxData ) );
    Prev[1] := EzxDataLast.Extension;
    {read the selected record}
    Seek( ARecno * SizeOf( TEzxData ), 0 );
    Read( EzxDataN, SizeOf( TEzxData ) );
    Prev[2] := EzxDataN.Extension;
    {and swap}
    Seek( result * SizeOf( TEzxData ), 0 );
    Write( EzxDataN, SizeOf( TEzxData ) );
    Frt.Update( FloatRect2Rect( Prev[1] ), result, FloatRect2Rect( Prev[2] ) );
    Seek( ARecno * SizeOf( TEzxData ), 0 );
    Write( EzxDataLast, SizeOf( TEzxData ) );
    Frt.Update( FloatRect2Rect( Prev[2] ), ARecno, FloatRect2Rect( Prev[1] ) );
  End;
  ExchangeDBRecord( Self, ARecno, RecordCount );
End;

Procedure TEzLayer.SetGraphicFilter( s: TSearchType; Const VisualWindow: TEzRect );
Var
  treeBBox, viewBBox: TRect_rt;
Begin
  Assert( Not FFiltered, SFilterEnabled );
  FFiltered := false;
  If Not FHeader.IsIndexed Then
    Exit;
  if not Assigned(Frt) then
    Exit;
  
  treeBBox := Frt.RootExtent;
  viewBBox := FloatRect2Rect( VisualWindow );
  If Contains_rect( viewBBox, treeBBox ) Then Exit;
  If ol = Nil Then
    ol := TIntegerList.Create
  Else
    ol.clear;
  Frt.Search( S, viewBBox, ol, FHeader.RecordCount );
  //SortList(ol);
  FFiltered := True;
  FFilterRecno := -1;
  FCurrentLoaded := 0;
End;

Procedure TEzLayer.CancelFilter;
Begin
  If ol <> Nil Then
    FreeAndNil( ol );
  FFiltered := False;
End;

Function TEzLayer.Eof: Boolean;
Begin
  Result := FEofCrack
End;

Procedure TEzLayer.First;
Begin
  If FFiltered Then
  Begin
    If ( ol <> Nil ) And ( ol.Count > 0 ) Then
    Begin
      FFilterRecno := 0;
      FEofCrack := false;
    End
    Else
    Begin
      FEofCrack := true;
    End
  End
  Else If FHeader.RecordCount > 0 Then
  Begin
    If FBuffEnx <> Nil Then // is buffering ?
    Begin
      FBuffEnx.Read( FEzxData, SizeOf( TEzxData ) );
    End;
    FRecno := 1;
    FEofCrack := false;
  End
  Else
  Begin
    FEofCrack := true;
  End;
End;

Procedure TEzLayer.Next;
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
          FEofCrack := false;
        End
        Else
        Begin
          FFilterRecno := N - 1;
          FEofCrack := true;
        End;
      End
      Else
      Begin
        FEofCrack := true;
      End
    End
    Else
    Begin
      N := FHeader.RecordCount;
      If N > 0 Then
      Begin
        If FBuffEnx <> Nil Then // is buffering ?
        Begin
          FBuffEnx.Read( FEzxData, SizeOf( TEzxData ) );
        End;
        If FRecno < N Then
        Begin
          Inc( FRecno );
          FEofCrack := false;
        End
        Else
        Begin
          FRecno := N;
          FEofCrack := true;
        End;
      End
      Else
      Begin
        FEofCrack := true;
      End;
    End;
End;

Procedure TEzLayer.Last;
Var
  N: Integer;
Begin
    If FFiltered Then
    Begin
      N := ol.count;
      If N > 0 Then
      Begin
        FFilterRecno := N - 1;
        FEofCrack := false;
      End
      Else
      Begin
        FEofCrack := true;
      End;
    End
    Else
    Begin
      N := FHeader.RecordCount;
      If N > 0 Then
      Begin
        FRecno := N;
        FEofCrack := false;
      End
      Else
      Begin
        FEofCrack := true;
      End;
    End;
End;

Procedure TEzLayer.StartBuffering;
Begin
  EndBuffering;
  If FFiltered or not Active Then Exit; // not allowed buffering when it's filtered
    FEzXStream.Seek( FRecno * SizeOf( TEzxData ), 0 );
    FBuffEnx := TEzBufferedRead.Create( FEzXStream, SIZE_LONGBUFFER );
    FBuffEnx.Read( FEzxData, SizeOf( TEzxData ) ); // read the first record
End;

Procedure TEzLayer.EndBuffering;
Begin
    If FBuffEnx <> Nil Then
      FreeAndNil( FBuffEnx );
    FCurrentLoaded := 0;
End;

Procedure TEzLayer.Assign( Source: TEzBaseLayer );
Var
  TmpID: Integer;
Begin
  If Not (Source Is TEzLayer) Then Exit;
  TmpID := FHeader.IDCounter;
  FHeader := TEzLayer( Source ).FHeader;
  FHeader.IDCounter := TmpID;
  MaxScale := TEzLayer( Source ).MaxScale;
  MinScale := TEzLayer( Source ).MinScale;
End;

function TEzLayer.GetExtensionForRecords( List: TIntegerList ): TEzRect;
var
  I, TheRecno:Integer;
  EzxData: TEzxData;
begin
    Result:= INVALID_EXTENSION;
    if (List=nil) or (List.Count=0) then Exit;
    for I:= 0 to List.Count-1 do
    begin
      TheRecno:= List[I];
      if (TheRecno < 1) or (TheRecno > FHeader.RecordCount) then Continue;
      FEzXStream.Seek( TheRecno * SizeOf( TEzxData ), 0 );
      FEzXStream.Read( EzxData, SizeOf( TEzxData ) );
      MaxBound(Result.Emax, EzxData.Extension.Emax);
      MinBound(Result.Emin, EzxData.Extension.Emin);
    end;
end;

Procedure TEzLayer.RebuildTree;
Var
  BuffEnx: TEzBufferedRead;
  I, J, RecCount: Integer;
  EzxData: TEzxData;
  Mode: Word;
  StreamRtc, StreamRtx: TStream;
  IdxInfo: TRTCatalog;
  dp: PDiskPage;
  Gis: TEzBaseGIS;
Begin
  Gis:= Layers.Gis;
  If Gis.ReadOnly Or Not FHeader.IsIndexed Then Exit;

  ForceOpened;
  If FEzDStream = Nil Then Exit;

  RecCount := Self.RecordCount;


  If Frt <> Nil Then
    FreeAndNil( Frt );
  Mode := Layers.GIS.OpenMode;
  { A memory r-tree used for fast speed }
  Frt := TMemRTree.Create( Self, RTYPE, Mode );
  // Create the index
  Frt.CreateIndex( '', CoordMultiplier );
  // Now add all the entities to the R-tree
  FEzXStream.Seek( SizeOf( TEzxData ), 0 );
  BuffEnx := TEzBufferedRead.Create( FEzXStream, SIZE_LONGBUFFER );

  If RecCount > 0 Then
    GIS.StartProgress( Format( SRebuildTree, [Name] ), 1, RecCount );
  Try
    For I := 1 To RecCount Do
    Begin
      GIS.UpdateProgress( I );
      BuffEnx.Read( EzxData, SizeOf( TEzxData ) );
      If EzxData.IsDeleted Or (EzxData.EntityID=idNone) Then Continue;

      Frt.Insert( FloatRect2Rect( EzxData.Extension ), I );
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
  Finally
    BuffEnx.free;
    Frt.Free; // delete memory rtree
    Frt := TEzRTree.Create( Self, RTYPE, Mode ); // open the disk based r-tree
    Frt.Open( Self.FileName, Mode );
    If RecCount > 0 Then
      GIS.EndProgress;
  End;
  If Not FHeader.Visible Then
    Frt.Close;
  WriteHeaders( true );
End;

Procedure TEzLayer.Open;
Var
  AFileName: String;
  EzxHeader: TEzxData;
  TmpStream: TFileStream;
  Mode: Word;
  GIS: TEzBaseGIS;
  aTable: TEzBaseTable;
Begin

  Close;

  If Not FHeader.Visible Then Exit;

  GIS := Layers.GIS;
  Mode := GIS.OpenMode;

  AFileName := FileName + EZDEXT;
  If FileExists( AFileName ) Then
  Begin
    TmpStream := TFileStream.Create( AFileName, Mode );
    TmpStream.Read( FHeader, SizeOf( TEzLayerHeader ) );
    FEzDStream := TmpStream;
    If GIS.MapInfo.CoordSystem = csLatLon Then
      CoordMultiplier := DEG_MULTIPLIER
    Else
      CoordMultiplier := 1;
    If FHeader.HeaderID <> LAYER_ID then
    begin
      //Raise EExpression.Create( SUnknownFormat );
    end;
  End
  Else If Not GIS.ReadOnly Then
  Begin
    FEzDStream := TFileStream.Create( AFileName, fmCreate Or fmShareDenyNone );
    FEzDStream.Write( FHeader, SizeOf( FHeader ) );
  End;

  AFileName := Self.FileName + EZXEXT;
  If FileExists( AFileName ) Then
  Begin
    FEzXStream := TFileStream.Create( AFileName, Mode );
  End
  Else If Not GIS.ReadOnly Then
  Begin
    FEzXStream := TFileStream.Create( AFileName, fmCreate Or fmShareDenyNone );
    EzxHeader.HeaderID := LAYER_IDX;
    EzxHeader.VersionNumber := LAYER_VERSION_NUMBER;
    EzxHeader.RecordCount := 0;
    EzxHeader.MaxRecSize := 0;
    FEzXStream.Write( EzxHeader, SizeOf( EzxHeader ) );
  End;

  { open the r-tree file }
  If FHeader.IsIndexed Then
  Begin
    Frt := TEzRTree.Create( Self, RTYPE, Mode );
    If Not FileExists( self.FileName + RTXEXT ) Or
      Not FileExists( self.FileName + RTCEXT ) Then
      // create the index
      RebuildTree
        //rt.CreateIndex( self.FileName )
    Else
      Frt.Open( self.FileName, Mode );
  End;

  If FHeader.UseAttachedDB Then
  Begin
    AFileName := Self.FileName;
    if BaseTableClass = Nil then
    begin
      FHeader.UseAttachedDB := False;
      Modified := True;
      EzGISError( SDBFNotFound );
    end;

    aTable := EzBaseGIS.BaseTableClass.createNoOpen( Layers.Gis );
    if Assigned(aTable) then
      try
        if not aTable.DBTableExists( AFileName ) then
        begin
          FHeader.UseAttachedDB := False;
          Modified := True;
          EzGISError( SDBFNotFound );
        end;
      finally
        aTable.Free;
      end;

    FDBTable := EzBaseGIS.BaseTableClass.Create( Gis, AFilename, Not GIS.ReadOnly, true );
    With FDBTable Do
    Begin
      SetUseDeleted( true );
      //Index( AFileName, '' );
    End;
  End;
End;

Function TEzLayer.GetActive: Boolean;
Begin
  Result := FEzDStream <> Nil;
End;

Procedure TEzLayer.SetActive( Value: Boolean );
Begin
  If Value Then Open Else Close;
End;

Procedure TEzLayer.Close;
Var
  EzxHeader: TEzxData;
  I: Integer;
  sl: TStringList;
  ReadOnly: Boolean;
  Gis: TEzBaseGIS;
Begin
  ReadOnly := Layers.GIS.ReadOnly;
  Gis := Layers.Gis;

  If Active Then
  Begin
    If Not ReadOnly And Modified Then
    Begin
      FEzDStream.Seek( 0, 0 );
      FEzDStream.Write( FHeader, SizeOf( TEzLayerHeader ) );
    End;
    FreeAndNil( FEzDStream );
    FreeAndNil( FBuffEnt );
  End;
  If FEzXStream <> Nil Then
  Begin
    If Not ReadOnly And Modified Then
    Begin
      FEzXStream.Seek( 0, 0 );
      FEzXStream.Read( EzxHeader, SizeOf( TEzxData ) );
      EzxHeader.RecordCount := FHeader.RecordCount;
      FEzXStream.Seek( 0, 0 );
      FEzXStream.Write( EzxHeader, SizeOf( TEzxData ) );
    End;
    FreeAndNil( FEzXStream );
  End;
  { save the projection information on file xxx.apj }
  sl := TStringList.Create;
  Try
    sl.Add( '[Projection]' );
    sl.Add( 'CoordSystem=' + IntToStr( Ord( GIS.MapInfo.CoordSystem ) ) );
    sl.Add( 'CoordsUnits=' + IntToStr( Ord( GIS.MapInfo.CoordsUnits ) ) );
    For I := 0 To GIS.ProjectionParams.Count - 1 Do
      sl.Add( GIS.ProjectionParams[I] );
    sl.SaveToFile( FileName + EPJEXT );
  Finally
    sl.free;
  End;
  // free the r-tree
  If Frt <> Nil Then FreeAndNil( Frt );
  If FDBTable <> Nil Then FreeAndNil( FDBTable );
  Modified := false;
End;

Procedure TEzLayer.ForceOpened;
Begin
  If FEzDStream = Nil Then Open;
End;

Procedure TEzLayer.WriteHeaders( FlushFiles: Boolean );
Var
  EzxData: TEzxData;
  Readonly: Boolean;
Begin
  Readonly:= Layers.GIS.ReadOnly;

  If ReadOnly Or ( FEzDStream = Nil ) Then
  Begin
    Modified := false;
    Exit;
  End;

  If Modified Then
  Begin
    FEzDStream.Seek( 0, 0 );
    FEzDStream.Write( FHeader, SizeOf( TEzLayerHeader ) );
    If FlushFiles Then
    Begin
      Windows.FlushFileBuffers( TFileStream( FEzDStream ).Handle );
    End;
  End;
  If FEzXStream <> Nil Then
  Begin
    FEzXStream.Seek( 0, 0 );
    FEzXStream.Read( EzxData, SizeOf( TEzxData ) );
    EzxData.RecordCount := FHeader.RecordCount;
    FEzXStream.Seek( 0, 0 );
    FEzXStream.Write( EzxData, SizeOf( TEzxData ) );
    If FlushFiles Then
    Begin
      Windows.FlushFileBuffers( TFileStream( FEzXStream ).Handle );
    End;
  End;
  If ( Frt <> Nil ) And FlushFiles Then Frt.FlushFiles;

  If ( FDBTable <> Nil ) And FlushFiles Then FDBTable.FlushDB;
  Modified := false;
End;

Procedure TEzLayer.UpdateMapExtension( Const R: TEzRect );
Var
  MapExt: TEzRect;
Begin
  { New map extension }
  With Layers.GIS Do
  Begin
    MapExt := MapInfo.Extension;
    MaxBound( MapExt.Emax, R.Emax );
    MinBound( MapExt.Emin, R.Emin );
    MapInfo.Extension := MapExt;
    Modified := true;
  End;
End;

// this function will return the recno of the added entity

Function TEzLayer.AddEntity( Entity: TEzEntity; Direct: Boolean = False ): Integer;
Var
  EzxData, EzxHeader: TEzxData;
  TmpID: TEzEntityID;
  NewRecNo: Integer;
  TmpSize: Longint;
  RecordSize: Integer;
Begin
  result := 0;
  ForceOpened;
  If Layers.GIS.ReadOnly Or ( FEzDStream = Nil ) Or LayerInfo.Locked Then Exit;

  NormalizePolygon( Entity );

  ReReadEntHeader;

  TmpID := Entity.EntityID;

  With EzxData Do
  Begin
    Offset := FEzDStream.Size;
    EntityID := TmpID;
    IsDeleted := false;
    Extension := Entity.FBox;
  End;
  With FHeader.Extension Do
  Begin
    MaxBound( Emax, EzxData.Extension.Emax );
    MinBound( Emin, EzxData.Extension.Emin );
  End;

  //TmpSize := FEzXStream.Size;
  //NewRecNo := TmpSize div SizeOf(TEzxData);
  NewRecno := FHeader.RecordCount + 1;
  TmpSize := NewRecno * SizeOf( TEzxData );

  If FProposedID = 0 Then
  Begin
    Inc( FHeader.IDCounter );
    { Entity.ID solo se usa en caso de que se necesite un identificador
      unico para cada entidad. De otra manera, se utilizara el numero de
      registro fisico como identificador en una base de datos que no
      soporta registro fisico.
    }
    Entity.ID := FHeader.IDCounter;
  End
  Else
    Entity.ID := FProposedID;
  FProposedID := 0;
  If FDBTable <> Nil Then
  Begin
    FDBTable.Append( NewRecno );
  End;
  FEzXStream.Seek( TmpSize, 0 );
  FEzXStream.Write( EzxData, SizeOf( TEzxData ) );

  RecordSize := 0;
  With FEzDStream Do
  Begin
    Seek( EzxData.Offset, 0 );
    Write( RecordSize, SizeOf( Integer ) );
    Write( RecordSize, SizeOf( Integer ) );
    Write( EzxData.EntityID, SizeOf( TEzEntityID ) );
    Write( EzxData.IsDeleted, SizeOf( Boolean ) );
    Entity.SaveToStream( FEzDStream );
    RecordSize := Position - EzxData.Offset;
    Seek( EzxData.Offset, 0 );
    Write( RecordSize, SizeOf( Integer ) );
    Write( RecordSize, SizeOf( Integer ) );
  End;

  // re-write to disk the header of .Enx file
  With FEzXStream Do
  Begin
    Seek( 0, 0 );
    Read( EzxHeader, SizeOf( TEzxData ) );
    EzxHeader.RecordCount := NewRecno;
    EzxHeader.MaxRecSize := EzLib.IMax( EzxHeader.MaxRecSize, RecordSize );
    Seek( 0, 0 );
    Write( EzxHeader, SizeOf( TEzxData ) );
  End;
  FreeAndNil( FBuffEnt );

  // add to the r-tree
  If ( TmpID <> idNone ) And FUpdateRTree And FHeader.IsIndexed Then
    Frt.Insert( FloatRect2Rect( EzxData.Extension ), NewRecno );

  FHeader.RecordCount := NewRecNo;
  With FEzDStream Do
  Begin // re-write to disk
    Seek( 0, 0 );
    Write( FHeader, SizeOf( TEzLayerHeader ) );
  End;

  Result := NewRecno;

  UpdateMapExtension( EzxData.Extension );
  
  If AutoFlush Then
    WriteHeaders( True );
End;

Procedure TEzLayer.UndeleteEntity( RecNo: Integer );
Var
  EzxData: TEzxData;
  TmpDeleted: Boolean;
Begin
  If Layers.GIS.ReadOnly Or ( FEzDStream = Nil ) Or LayerInfo.Locked Or
    ( RecNo < 1 ) Or ( RecNo > FHeader.RecordCount ) Then Exit;


  { Undelete first in the ENX file }
  With FEzXStream Do
  Begin
    Seek( RecNo * SizeOf( TEzxData ), 0 );
    Read( EzxData, SizeOf( TEzxData ) );
    EzxData.IsDeleted := false;
    Seek( RecNo * SizeOf( TEzxData ), 0 );
    Write( EzxData, SizeOf( TEzxData ) );
  End;
  { now in the ENT file. A deleted record is
    marked in the two files for rebuilding of ENX file purposes }
  TmpDeleted := False;
  With FEzDStream Do
  Begin
    Seek( EzxData.Offset + SizeOf( Integer ) * 2 + SizeOf( TEzEntityID ), 0 );
    Write( TmpDeleted, SizeOf( Boolean ) );
  End;

  FreeAndNil( FBuffEnt );

  // add to the r-tree
  If ( EzxData.EntityID <> idNone ) And FHeader.IsIndexed Then
    Frt.Insert( FloatRect2Rect( EzxData.Extension ), Recno );

  {now undelete the DBF record}
  If FDBTable <> Nil Then
  Begin
    FDBTable.SetTagTo( '' );
    FDBTable.Recno:= RecNo;
    FDBTable.Recall;
    FDBTable.Refresh;
  End;
  UpdateMapExtension( EzxData.Extension );
End;

Procedure TEzLayer.DeleteEntity( RecNo: Integer );
Var
  EzxData: TEzxData;
  TmpDeleted: Boolean;
  Entity: TEzEntity;
Begin
  If Layers.GIS.ReadOnly Or ( FEzDStream = Nil ) Or LayerInfo.Locked Then Exit;

  { First, mark deleted flag in Enx file }
  FEzXStream.Seek( RecNo * SizeOf( TEzxData ), 0 );
  FEzXStream.Read( EzxData, SizeOf( TEzxData ) );
  If EzxData.IsDeleted Then Exit;

  { for nodes and nodelinks }
  If EzxData.EntityID = idNode then
  begin
    Entity:= LoadEntityWithRecno( Recno );
    Try
      TEzNode( Entity ).BeforeDelete( Recno, Self );
    Finally
      Entity.Free;
    end;
  end else If EzxData.EntityID = idNodeLink then
  begin
    Entity:= LoadEntityWithRecno( Recno );
    Try
      TEzNodeLink( Entity ).BeforeDelete( Recno, Self );
    Finally
      Entity.Free;
    end;
  end;

  EzxData.IsDeleted := true;
  FEzXStream.Seek( RecNo * SizeOf( TEzxData ), 0 );
  FEzXStream.Write( EzxData, SizeOf( TEzxData ) );
  // now write to the .ENT file
  With FEzDStream Do
  Begin
    Seek( EzxData.Offset + sizeof( Integer ) * 2 + sizeof( TEzEntityID ), 0 );
    TmpDeleted := True;
    Write( TmpDeleted, SizeOf( Boolean ) );
  End;

  FreeAndNil( FBuffEnt );
  // Delete from r-tree
  If ( EzxData.EntityID <> idNone ) And FHeader.IsIndexed Then
  Begin
    Try
      Frt.Delete( FloatRect2Rect( EzxData.Extension ), Recno );
    Except
      MessageToUser( 'record ' + inttostr( Recno ), smsgerror, MB_ICONERROR );
      Raise;
    End;
  End;

  { now delete the DBF record }
  If FDBTable <> Nil Then
  Begin
    FDBTable.SetTagTo( '' );
    FDBTable.RecNo := RecNo;
    FDBTable.Delete;
  End;
  Modified := True;
  If AutoFlush Then
    WriteHeaders( True );
  Modified := False;
End;

Procedure TEzLayer.ReReadEntHeader;
Begin
  If FEzDStream = Nil Then Exit;

  With FEzDStream Do
  Begin
    Seek( 0, 0 );
    If Modified And Not Layers.GIS.ReadOnly Then
      Write( FHeader, SizeOf( TEzLayerHeader ) )
    Else
      Read( FHeader, SizeOf( TEzLayerHeader ) );
  End;
  Modified := false;
End;

Function TEzLayer.QuickUpdateExtension: TEzRect;
Var
  cnt, RecCount: Integer;
  EzxData: TEzxData;
  Gis: TEzBaseGIS;
Begin
  Assert( Not FFiltered, SFilterEnabled );

  GIS := Layers.GIS;
  If GIS.ReadOnly Then Exit;
  ForceOpened;

  Result := INVALID_EXTENSION;

  RecCount := Self.RecordCount;
  If RecCount > 0 Then
    GIS.StartProgress( Format( SUpdateExtension, [Name] ), 1, RecCount );
  Try
    For cnt := 1 To RecCount Do
    Begin
      GIS.UpdateProgress( cnt );
      FEzXStream.Seek( cnt * SizeOf( EzxData ), 0 );
      FEzXStream.Read( EzxData, SizeOf( TEzxData ) );
      If EzxData.IsDeleted Then Continue;

      MaxBound( Result.Emax, EzxData.Extension.Emax );
      MinBound( Result.Emin, EzxData.Extension.Emin );
    End;
  Finally
    If RecCount > 0 Then
      GIS.EndProgress;
  End;
  Modified := true;
  FHeader.Extension := Result;
  If AutoFlush Then
    WriteHeaders( True );
End;

Function TEzLayer.UpdateExtension: TEzRect;
Var
  cnt, RecCount: Integer;
  EzxData: TEzxData;
  Entity: TEzEntity;
  GIS: TEzBaseGIS;
Begin
  Assert( Not FFiltered, SFilterEnabled );

  GIS := Layers.GIS;
  If GIS.ReadOnly Then Exit;
  ForceOpened;
  Result := INVALID_EXTENSION;
  //FHeader.RecordCount := Pred(FEzXStream.Size div SizeOf(TEzxData));
  RecCount := Self.RecordCount;
  If RecCount > 0 Then
    GIS.StartProgress( Format( SUpdateExtension, [Name] ), 1, RecCount );
  Try
    For cnt := 1 To RecCount Do
    Begin
      GIS.UpdateProgress( cnt );
      FEzXStream.Seek( cnt * SizeOf( EzxData ), 0 );
      FEzXStream.Read( EzxData, SizeOf( TEzxData ) );
      If Not EzxData.IsDeleted Then
      Begin
        BuffEnt.Seek( EzxData.Offset, 0 );
        Entity := InternalLoadEntity( EzxData.EntityID, BuffEnt );
        EzxData.Extension := Entity.FBox;
        if Entity.EntityID = idNone then
          EzxData.Extension := Result;
        Entity.Free;
        FEzXStream.Seek( cnt * SizeOf( EzxData ), 0 );
        FEzXStream.Write( EzxData, SizeOf( TEzxData ) );

        MaxBound( Result.Emax, EzxData.Extension.Emax );
        MinBound( Result.Emin, EzxData.Extension.Emin );
      End;
    End;
    FreeAndNil( FBuffEnt );
  Finally
    If RecCount > 0 Then
      GIS.EndProgress;
  End;
  // rebuild the r-tree
  RebuildTree;
  Modified := true;
  FHeader.Extension := Result;
  If AutoFlush Then
    WriteHeaders( True );
End;

Function TEzLayer.InternalLoadEntity( EntityID: TEzEntityID; Stream: TStream ): TEzEntity;
Var
  TmpClass: TEzEntityClass;
  RecordSize: Integer;
  TmpEntID: TEzEntityID;
  TmpDeleted: Boolean;
Begin
  Stream.Read( RecordSize, SizeOf( Integer ) );
  Stream.Read( RecordSize, SizeOf( Integer ) );
  Stream.Read( TmpEntID, SizeOf( TEzEntityID ) );
  Stream.Read( TmpDeleted, SizeOf( TmpDeleted ) );
  TmpClass := GetClassFromID( EntityID );
  Result := TmpClass.Create( 1 );
  Result.LoadFromStream( Stream );
End;

Function TEzLayer.LoadEntityWithRecNo( RecNo: Longint): TEzEntity;
Var
  EzxData: TEzxData;
Begin
  {RecNo is base 1}
  Result := Nil;
  If ( RecNo < 1 ) Or ( RecNo > FHeader.RecordCount ) Then Exit;
  FEzXStream.Seek( RecNo * SizeOf( TEzxData ), 0 );
  FEzXStream.Read( EzxData, SizeOf( TEzxData ) );
  If EzxData.IsDeleted Then Exit;
  BuffEnt.Seek( EzxData.Offset, 0 );
  Result := InternalLoadEntity( EzxData.EntityID, BuffEnt );
End;

Procedure TEzLayer.UpdateEntity( RecNo: Integer; Entity2D: TEzEntity );
Var
  EzxData, EzxHeader: TEzxData;
  I: Integer;
  Prev: TEzRect;
  GIS: TEzBaseGIS;
  Viewport: TEzBaseDrawBox;
  RecordSize, NewRecordSize, FullRecordSize: Integer;
  TmpEntID: TEzEntityID;
  TmpDeleted: Boolean;

  Procedure SaveToEndOfFile;
  Begin
    With FEzXStream Do
    Begin
      Seek( RecNo * SizeOf( TEzxData ), 0 );
      Read( EzxData, SizeOf( TEzxData ) );
    End;
    Prev := EzxData.Extension; // r-tree
    { mark current occupied record as deleted }
    With FEzDStream Do
    Begin
      Seek( EzxData.Offset, 0 );
      Read( RecordSize, SizeOf( Integer ) );
      Read( RecordSize, SizeOf( Integer ) );
      Read( TmpEntID, SizeOf( TEzEntityID ) );
      TmpDeleted := True;
      Write( TmpDeleted, SizeOf( Boolean ) );
    End;
    EzxData.EntityID := Entity2D.EntityID;
    EzxData.IsDeleted := False;
    EzxData.Offset := FEzDStream.Size;
    RecordSize := 0;
    With FEzDStream Do
    Begin
      Seek( EzxData.Offset, 0 );
      Write( RecordSize, SizeOf( Integer ) );
      Write( RecordSize, SizeOf( Integer ) );
      Write( EzxData.EntityID, SizeOf( TEzEntityID ) );
      Write( EzxData.IsDeleted, SizeOf( Boolean ) );
      Entity2D.SaveToStream( FEzDStream );
      RecordSize := FEzDStream.Position - EzxData.Offset;
      Seek( EzxData.Offset, 0 );
      Write( RecordSize, SizeOf( Integer ) );
      Write( RecordSize, SizeOf( Integer ) );
    End;
    Entity2D.UpdateExtension;
    EzxData.Extension := Entity2D.FBox; //.Points.Extension;
    With FEzXStream Do
    Begin
      Seek( RecNo * SizeOf( TEzxData ), 0 );
      Write( EzxData, SizeOf( TEzxData ) );
      // rewrite the header of .enx file
      Seek( 0, 0 );
      Read( EzxHeader, SizeOf( TEzxData ) );
      If RecordSize > EzxHeader.MaxRecSize Then
      Begin
        EzxHeader.MaxRecSize := RecordSize;
        Seek( 0, 0 );
        Write( EzxHeader, SizeOf( TEzxData ) );
      End;
    End;
  End;

Begin
  If Layers.GIS.ReadOnly Or ( FEzDStream = Nil ) Or LayerInfo.Locked Then Exit;

  NormalizePolygon( Entity2d );

  If Not Entity2D.NeedReposition Then
  Begin
    // save new extension
    With FEzXStream Do
    Begin
      Seek( RecNo * SizeOf( TEzxData ), 0 );
      Read( EzxData, SizeOf( TEzxData ) );
    End;
    Prev := EzxData.Extension; // r-tree
    Entity2D.UpdateExtension;
    EzxData.Extension := Entity2D.FBox; //.Points.Extension;
    If EzxData.EntityID = Entity2D.EntityID Then
    Begin
      { continues to be the same type of entity }
      If Not EqualRect2D( Prev, EzxData.Extension ) Then
      Begin
        FEzXStream.Seek( RecNo * SizeOf( TEzxData ), 0 );
        FEzXStream.Write( EzxData, SizeOf( TEzxData ) );
      End;

      With FEzDStream Do
      Begin
        Seek( EzxData.Offset, 0 );
        Read( FullRecordSize, SizeOf( Integer ) );
        Read( RecordSize, SizeOf( Integer ) );
        Read( TmpEntID, SizeOf( TEzEntityID ) );
        Read( TmpDeleted, SizeOf( Boolean ) );
        Entity2D.SaveToStream( FEzDStream );
        NewRecordSize := FEzDStream.Position - EzxData.Offset;
        If RecordSize <> NewRecordSize Then
        Begin
          Seek( EzxData.Offset, 0 );
          Write( FullRecordSize, SizeOf( Integer ) );
          Write( NewRecordSize, SizeOf( Integer ) );
        End;
      End;
    End
    Else
      SaveToEndOfFile;
  End
  Else
    SaveToEndOfFile;

  // update the r-tree
  If ( EzxData.EntityID <> idNone ) And FHeader.IsIndexed And
    Not EqualRect2D( Prev, EzxData.Extension ) Then
    Frt.Update( FloatRect2Rect( Prev ), Recno, FloatRect2Rect( EzxData.Extension ) );

  FreeAndNil( FBuffEnt );

  MaxBound( FHeader.Extension.Emax, EzxData.Extension.Emax );
  MinBound( FHeader.Extension.Emin, EzxData.Extension.Emin );

  Modified := true;
  If AutoFlush Then
    WriteHeaders( True );

  {new map extension}
  UpdateMapExtension( EzxData.Extension );
  GIS := Layers.GIS;
  For I := 0 To GIS.DrawBoxList.Count - 1 Do
  Begin
    Viewport := GIS.DrawBoxList[i];
    If Assigned( Viewport.OnEntityChanged ) Then
      Viewport.OnEntityChanged( Viewport, self, Recno );
  End;
End;

Procedure TEzLayer.Pack( ShowMessages: Boolean );
Begin
  If LayerInfo.Locked then Exit;
  DoPack( ShowMessages );
End;

// pack layer

Procedure TEzLayer.DoPack( ShowMessages: Boolean );
Var
  RecCount: Integer;
  cnt, J, K, N: Integer;
  NewRecno, NumBadRecords, TmpID: Integer;
  TmpLayer: TEzLayer;
  HasDeleted, IsValid, ThisIsIndexed: Boolean;
  EzxData: TEzxData;
  EzxHeader: TEzxData;
  TmpEntity: TEzEntity;
  TempFileName: String;
  FieldList: TStringList;
  GIS: TEzBaseGIS;
  TempGis: TEzGis;
  NetworkCount: Integer;
  PivotRecnos: TIntegerList;

  Function PointOutOfRange( Const P: TEzPoint ): Boolean;
  Begin
    Result := ( Abs( P.X ) < MINCOORD ) Or ( Abs( P.X ) > MAXCOORD ) Or
              ( Abs( P.Y ) < MINCOORD ) Or ( Abs( P.Y ) > MAXCOORD );
  End;

Begin
  { Warning: This must be done with all threads stopped }

  GIS := Layers.GIS;
  If GIS.ReadOnly Then Exit;
  Close;
  { Try open all files exclusively }
  Try
    Try
      TFileStream.Create( FileName + EZDEXT, fmOpenReadWrite Or fmShareExclusive ).Free;
      TFileStream.Create( FileName + EZXEXT, fmOpenReadWrite Or fmShareExclusive ).Free;
    Except
      If ShowMessages Then
        MessageToUser( SRestNotExclusive, smsgerror, MB_ICONERROR );
      Raise;
    End;
  Finally
    Open;
  End;

  ForceOpened;
  If FEzDStream = Nil Then Exit;

  // Calc correct RecordCount
  RecCount := Self.RecordCount;
  If RecCount = 0 Then Exit;

  HasDeleted := False;
  { check all DBF recs that are not marked for deletion }
  If FDBTable <> Nil Then
    FDBTable.SetTagTo( '' );

  NetworkCount:= 0;

  FEzXStream.Seek( SizeOf( TEzxData ), 0 );
  For cnt := 1 To RecCount Do
  Begin
    Try
      FEzXStream.Read( EzxData, SizeOf( TEzxData ) );
      If EzxData.EntityID In [idNode, idNodeLink] then
        Inc( NetworkCount );
      If EzxData.IsDeleted Then
      Begin
        If FDBTable <> Nil Then
        Begin
          If cnt > FDBTable.RecordCount Then Break;
          FDBTable.RecNo := cnt;
          If Not FDBTable.Deleted Then
            FDBTable.Delete;
        End;
        HasDeleted := True;
        Break;
      End;
    Except
      // ignore error probably caused for hard disk damage
    End;
  End;

  If Not HasDeleted Then
    NetworkCount := 0;

  PivotRecnos:= Nil;
  If NetworkCount > 0 then
  begin
    { create a bit array for marking original record numbers }
    PivotRecnos:= TIntegerList.Create;
    PivotRecnos.Capacity:= RecCount;
    For cnt := 1 To RecCount + 1 Do
    Begin
      PivotRecnos.Add( 0 );
    End;
  end;

  { Now check all entities that are not marked ( based on DBF deleted recs ) }
  If FDBTable <> Nil Then
  Begin
    For cnt := 1 To RecCount Do
    Begin
      If cnt > FDBTable.RecordCount Then Break;

      Try
        FDBTable.RecNo := cnt;
        If FDBTable.Deleted Then
        Begin
          FEzXStream.Seek( cnt * SizeOf( TEzxData ), 0 );
          FEzXStream.Read( EzxData, SizeOf( TEzxData ) );
          If Not EzxData.IsDeleted Then
          Begin
            EzxData.IsDeleted := true;
            FEzXStream.Seek( cnt * SizeOf( TEzxData ), 0 );
            FEzXStream.Write( EzxData, SizeOf( TEzxData ) );
          End;
        End;
      Except
        // ignore error probably caused for damaged DBF
      End;
    End;
  End;

  If ShowMessages Then
  Begin
    If Not HasDeleted And
      ( Application.MessageBox( PChar( SThereAreNoDeleted ), pchar( SMsgConfirm ),
      MB_YESNO Or MB_ICONQUESTION ) <> IDYES ) Then
    begin
      If Assigned( PivotRecnos ) then
        PivotRecnos.Free;
      Exit;
    end;
  End;

  // Create a temp gis and layer for packing
  TempGis:= TEzGis.Create(Nil);
  TempFileName := ChangeFileExt( GetTemporaryLayerName( ExtractFilePath( self.FileName ), 'PAK' ), '' );
  DeleteFilesSameName( TempFileName );
  TempGis.FileName:= TempFileName;
  TempGis.Open;
  TmpLayer := TEzLayer.Create( TempGis.Layers, TempFileName );

  With TmpLayer Do
  Begin
    FHeader := Self.FHeader;
    FHeader.RecordCount := 0;
    FHeader.IDCounter := 0;
    FEzDStream := TFileStream.Create( TempFileName + EZDEXT,
                    fmCreate Or fmShareExclusive );
    FEzDStream.Write( FHeader, Sizeof( TEzLayerHeader ) );
    FEzXStream := TFileStream.Create( TempFileName + EZXEXT,
        fmCreate Or fmShareExclusive );
    EzxHeader.RecordCount := 0;
    EzxHeader.HeaderID := LAYER_ID;
    EzxHeader.VersionNumber := LAYER_VERSION_NUMBER;
    FEzXStream.Write( EzxHeader, Sizeof( TEzxData ) );
    { create DB table }
    FieldList := TStringList.Create;
    try
      For cnt := 1 To Self.FDBTable.FieldCount Do
      Begin
        FieldList.Add( Format( '%s;%s;%d;%d',
          [Self.FDBTable.Field( cnt ), Self.FDBTable.FieldType( cnt ),
           Self.FDBTable.FieldLen( cnt ), Self.FDBTable.FieldDec( cnt )] ) );
      End;
      Self.FDBTable.DBCreateTable( TempFileName, FieldList );
    finally
      FieldList.free;
    end;
    { create the r-tree }
    If FHeader.IsIndexed Then
    Begin
      Frt.free;
      Frt := TEzRTree.Create( TmpLayer, RTYPE, fmOpenReadWrite Or fmShareDenyNone );
      Frt.CreateIndex( TempFileName, CoordMultiplier );
    End;
    Modified:= true;
    Close;
    ForceOpened;
  End;

  FEzXStream.Seek( SizeOf( TEzxData ), 0 );

  N := 0;
  NumBadRecords := 0;
  If (Gis <> Nil) And (RecCount > 0) Then
    GIS.StartProgress( SPackingLayer, 1, RecCount );
  For cnt := 1 To RecCount Do
  Begin
    if Gis <> Nil then GIS.UpdateProgress( cnt );
    Try
      FEzXStream.Read( EzxData, SizeOf( TEzxData ) );
      If EzxData.IsDeleted Or ( EzxData.Offset < 0 ) Or
        ( EzxData.Offset > Pred( FEzDStream.Size ) ) Then
        Continue;
      FEzDStream.Seek( EzxData.Offset, 0 );
      TmpEntity := Self.InternalLoadEntity( EzxData.EntityID, FEzDStream );
      If TmpEntity = Nil Then Continue;

      { Check Points of vector }
      IsValid := true;
      For J := 0 To TmpEntity.Points.Count - 1 Do
      Begin
        If PointOutOfRange( TmpEntity.Points[J] ) Then
        Begin
          IsValid := False;
          Break;
        End;
      End;
      If Not IsValid Then
      Begin
        TmpEntity.Free;
        Continue;
      End;
      TmpID := TmpEntity.ID;
      If FDBTable <> Nil Then
        FDBTable.RecNo := cnt;
      TmpLayer.FProposedID := TmpID;
      NewRecno:= TmpLayer.AddEntity( TmpEntity );
      If (NetworkCount > 0) And (TmpEntity.EntityID In [idNode, idNodeLink]) then
      begin
        { in the new record number is saved the old record number }
        PivotRecnos[NewRecno]:= cnt;
      end;

      if TmpLayer.DBTable <> Nil then
      begin
        TmpLayer.DBTable.Last;
        TmpLayer.DBTable.Edit;
        For K := 1 To FDBTable.FieldCount Do
        Begin
          Try
            //CopyDBFField( FDBTable, K, Halc, K );
            TmpLayer.DBTable.AssignFrom( FDbTable, K, K );
          Except
            // probably caused by wrong data in source file
          End;
        End;
        TmpLayer.DBTable.Post;
      end;
      Inc( N );
      TmpEntity.Free;
    Except
      // continue working on exceptions
      Inc( NumBadRecords );
    End;
  End;

  FHeader.RecordCount := N;
  ThisIsIndexed := TmpLayer.FHeader.IsIndexed;
  TmpLayer.FHeader.RecordCount := N;
  TmpLayer.FHeader.IDCounter := FHeader.IDCounter;
  TmpLayer.Modified := true;

  TmpLayer.Free;
  TempGis.Free;

  // Delete Old files
  FreeAndNil( FEzDStream );
  FreeAndNil( FBuffEnt );
  FreeAndNil( FEzXStream );
  If FDBTable <> Nil Then FreeAndNil( FDBTable );
  If Frt <> Nil Then FreeAndNil( Frt );
  SysUtils.DeleteFile( self.FileName + EZXEXT ); // ENT FILE
  RenameFile( TempFileName + EZXEXT, self.FileName + EZXEXT );
  SysUtils.DeleteFile( self.FileName + EZDEXT ); // ENX FILE
  RenameFile( TempFileName + EZDEXT, self.FileName + EZDEXT );
  If ThisIsIndexed Then
  Begin
    { when the deletion is detected when trying to open
     the index files will be rebuilded automatically }
    SysUtils.DeleteFile( FileName + RTCEXT ); // RTC FILE
    SysUtils.DeleteFile( TempFileName + RTCEXT );
    SysUtils.DeleteFile( FileName + RTXEXT ); // RTX FILE
    SysUtils.DeleteFile( TempFileName + RTXEXT );
  End;
  If FHeader.UseAttachedDB Then
  Begin
    with EzBaseGIS.BaseTableClass.CreateNoOpen( Gis ) do
      try
        DBDropTable( Self.FileName );
        DBRenameTable( TempFileName, Self.FileName );
      finally
        free;
      end;
  End;

  DeleteFilesSameName( TempFileName );

  If (Gis <> Nil) And (RecCount > 0) Then
    GIS.EndProgress;

  If NumBadRecords > 0 Then
    MessageToUser( Format( SWrongRecordsRecover, [NumBadRecords] ),
                   smsgwarning, MB_ICONINFORMATION );

  Try
    Open;

    { now fix all the nodes and links }
    If NetworkCount > 0 then
    begin
      First;
      While not Eof do
      begin
        cnt := PivotRecnos[ Recno ]; // this is the old recno
        if cnt <> 0 then
        begin
          { presumably this is a node or node link }
          TmpEntity:= RecLoadEntity;
          try
            If TmpEntity.EntityID = idNode then
            begin
              with TEzNode( TmpEntity ) do
                For K:= 0 to Links.Count-1 do
                  for J:= 0 to PivotRecnos.Count-1 do
                    If PivotRecnos[J] = Links[K] then
                    begin
                      Links[K] := J;
                      Break;
                    end;
              UpdateEntity( Recno, TmpEntity );
            end else if TmpEntity.EntityID = idNodeLink then
            begin
              with TEzNodeLink( TmpEntity ) do
              begin
                K:= 0;
                for J:= 0 to PivotRecnos.Count-1 do
                begin
                  If PivotRecnos[J] = FromNode then
                  begin
                    FromNode := J;
                    Inc(K);
                  end else If PivotRecnos[J] = ToNode then
                  begin
                    ToNode := J;
                    Inc(K);
                  end;
                  If K = 2 then Break;  // both found
                end;
              end;
              UpdateEntity( Recno, TmpEntity );
            end;
          finally
            TmpEntity.Free;
          end;
        end;
        Next;
      end;
      PivotRecnos.Free;
    end;
  Except
    On E: Exception Do
    Begin
      MessageToUser( E.Message, smsgerror, MB_ICONERROR );
      Raise;
    End;
  End;
End;

Function TEzLayer.RecExtension: TEzRect;
Var
  N: Integer;
Begin
  If FBuffEnx = Nil Then
  Begin
    If FFiltered Then
      N := Longint( ol[FFilterRecno] )
    Else
      N := FRecno;
    If FCurrentLoaded <> N Then
    Begin
      if Assigned(FEzXStream) then
      begin
        With FEzXStream Do
        Begin
          Seek( N * SizeOf( TEzxData ), 0 );
          Read( FEzxData, SizeOf( TEzxData ) );
        End;
        FCurrentLoaded := N;
      end
      else
      begin
        Result := INVALID_EXTENSION;
        Exit;
      end;
    End;
  End;
  Result := FEzxData.Extension;
End;

Function TEzLayer.RecLoadEntity: TEzEntity;
Var
  N, RecordSize: Integer;
  TmpEntID: TEzEntityID;
  TmpDeleted: Boolean;
Begin
  If FBuffEnx = Nil Then
  Begin
    If FFiltered Then
      N := Longint( ol[FFilterRecno] )
    Else
      N := FRecno;
    If FCurrentLoaded <> N Then
    Begin
      With FEzXStream Do
      Begin
        Seek( N * SizeOf( TEzxData ), 0 );
        Read( FEzxData, SizeOf( TEzxData ) );
      End;
      FCurrentLoaded := N;
    End;
  End;
  Result := GetClassFromID( FEzxData.EntityID ).Create( 4 );
  BuffEnt.Seek( FEzxData.Offset, 0 );
  BuffEnt.Read( RecordSize, SizeOf( Integer ) );
  BuffEnt.Read( RecordSize, SizeOf( Integer ) );
  BuffEnt.Read( TmpEntID, SizeOf( TEzEntityID ) );
  BuffEnt.Read( TmpDeleted, SizeOf( Boolean ) );
  Result.LoadFromStream( BuffEnt );
End;

Procedure TEzLayer.RecLoadEntity2( Entity: TEzEntity );
Var
  N, RecordSize: Integer;
  TmpEntID: TEzEntityID;
  TmpDeleted: Boolean;
Begin
  If FBuffEnx = Nil Then
  Begin
    If FFiltered Then
      N := Longint( ol[FFilterRecno] )
    Else
      N := FRecno;
    If FCurrentLoaded <> N Then
    Begin
      With FEzXStream Do
      Begin
        Seek( N * SizeOf( TEzxData ), 0 );
        Read( FEzxData, SizeOf( TEzxData ) );
      End;
      FCurrentLoaded := N;
    End;
  End;
  BuffEnt.Seek( FEzxData.Offset, 0 );
  BuffEnt.Read( RecordSize, SizeOf( Integer ) );
  BuffEnt.Read( RecordSize, SizeOf( Integer ) );
  BuffEnt.Read( TmpEntID, SizeOf( TEzEntityID ) );
  BuffEnt.Read( TmpDeleted, SizeOf( Boolean ) );
  Entity.LoadFromStream( BuffEnt );
End;

Function TEzLayer.RecEntityID: TEzEntityID;
Var
  N: Integer;
Begin
  If FBuffEnx = Nil Then
  Begin
    If FFiltered Then
      N := Longint( ol[FFilterRecno] )
    Else
      N := FRecno;
    If FCurrentLoaded <> N Then
    Begin
      With FEzXStream Do
      Begin
        Seek( N * SizeOf( TEzxData ), 0 );
        Read( FEzxData, SizeOf( TEzxData ) );
      End;
      FCurrentLoaded := N;
    End;
  End;
  Result := FEzxData.EntityID;
End;

Function TEzLayer.RecIsDeleted: boolean;
Var
  N: Integer;
Begin
  If FBuffEnx = Nil Then
  Begin
    If FFiltered Then
      N := Longint( ol[FFilterRecno] )
    Else
      N := FRecno;
    If FCurrentLoaded <> N Then
    Begin
      With FEzXStream Do
      Begin
        Seek( N * SizeOf( TEzxData ), 0 );
        Read( FEzxData, SizeOf( TEzxData ) );
      End;
      FCurrentLoaded := N;
    End;
  End;
  Result := FEzxData.IsDeleted;
End;

Procedure TEzLayer.CopyRecord( SourceRecno, DestRecno: Integer );
Var
  cnt: Integer;
  TmpDataSet: TEzBaseTable;
Begin
  Assert( Not FFiltered, SFilterEnabled );

  If Layers.GIS.ReadOnly Or LayerInfo.Locked Then Exit;
  // copy DBF record procedure

  If ( BaseTableClass = Nil ) Or Not FHeader.UseAttachedDB Or ( DBTable = Nil ) Or
    Not ( DBTable.Active ) Then Exit;

  TmpDataSet := EzBaseGIS.BaseTableClass.Create( Layers.Gis, Filename, true, true );
  Try
    { set the index file name }
    If DBTable.IndexCount <> 0 Then
      TmpDataSet.Index( Name, '' );
    DBTable.Recno:= SourceRecno;
    TmpDataSet.Recno:= DestRecno;
    TmpDataSet.Edit;
    For cnt := 1 To DBTable.FieldCount Do
    Begin
      //CopyDBFField( Layer.DBTable, cnt, TmpDataset, cnt );
      TmpDataSet.AssignFrom( DbTable, cnt, cnt );
    End;
    TmpDataSet.Post;
  Finally
    TmpDataSet.Free;
  End;
End;

Function TEzLayer.ContainsDeleted: boolean;
Var
  EzxData: TEzxData;
  BuffEnx: TEzBufferedRead;
  I: integer;
Begin
  Result := false;
  If FEzXStream = Nil Then Exit;
  FHeader.RecordCount := Pred( FEzXStream.Size Div SizeOf( TEzxData ) );
  FEzXStream.Seek( SizeOf( TEzxData ), 0 );
  BuffEnx := TEzBufferedRead.Create( FEzXStream, SIZE_LONGBUFFER );
  { check all DBF recs that are not marked for deletion }
  For I := 1 To RecordCount Do
  Begin
    BuffEnx.Read( EzxData, SizeOf( TEzxData ) );
    If EzxData.IsDeleted Then
    Begin
      Result := true;
      Exit;
    End;
  End;
End;

Procedure TEzLayer.Recall;
Begin
  If Layers.GIS.ReadOnly Or LayerInfo.Locked Or
    ( FRecno < 1 ) Or ( FRecno > FHeader.RecordCount ) Then Exit;

  FEzXStream.Seek( FRecno * SizeOf( TEzxData ), 0 );
  FEzXStream.Read( FEzxData, SizeOf( TEzxData ) );
  If Not FEzxData.IsDeleted Then Exit;
  FEzxData.IsDeleted := false;
  FEzXStream.Seek( FRecno * SizeOf( TEzxData ), 0 );
  FEzXStream.Write( FEzxData, SizeOf( TEzxData ) );
  { now mark in .ENT file }
  With FEzDStream Do
  Begin
    Seek( FEzxData.Offset + SizeOf( Integer ) * 2 + SizeOf( TEzEntityID ), 0 );
    Write( FEzxData.IsDeleted, SizeOf( Boolean ) );
  End;

  { restore from the r-tree }
  If FHeader.IsIndexed Then
    Frt.Insert( FloatRect2Rect( FEzxData.Extension ), FRecno );

  If FDBTable <> Nil Then
  Begin
    FDBTable.SetTagTo( '' );
    FDBTable.Recno := FRecno;
    FDBTable.Recall;
  End;
End;

Function TEzLayer.GetRecordCount: Integer;
Begin
  ReReadEntHeader;
  result := FHeader.RecordCount;
End;

Function TEzLayer.DefineScope( Const Scope: String ): Boolean;
Var
  Solver: TEzMainExpr;
Begin
  Assert( Not FFiltered, SFilterEnabled );

  If Length(Trim(Scope))=0 then
  begin
    FFiltered := False;
    if ol <> nil then FreeAndNil( ol );
    Result:= true;
    exit;
  end;

  Result := False;
  Solver := TEzMainExpr.Create( Layers.Gis, Self );
  Try
    { ol must be created after this call because a call to one of the
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
          If DBTable <> Nil Then
            DBTable.Recno := Recno;
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
    Result := ( ol <> Nil ) And ( ol.Count > 0 );
  Finally
    Solver.Free;
  End;
End;

Function TEzLayer.DefinePolygonScope( Polygon: TEzEntity; Const Scope: String;
  Operator: TEzGraphicOperator ): Boolean;
Var
  Solver: TEzMainExpr;
  Entity: TEzEntity;
  Pass: Boolean;
  SearchType: TSearchType;
  temp_ol: TIntegerList;
Begin
  Assert( Not FFiltered, SFilterEnabled );

  Result := False;

  temp_ol := TIntegerList.Create;
  Solver := Nil;
  If Length( Scope ) > 0 Then
  Begin
    Solver := TEzMainExpr.Create( Layers.Gis, Self );
  End;
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
            Synchronize;
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
      Result := true;
      if ( Solver <> Nil ) And ( Solver.OrderByCount > 0 ) then
      begin
        FFiltered := False;
        SortOrderList( Self, Solver, ol );
        FFiltered := True;
      end;
    End
    Else
    Begin
      FreeAndNil( temp_ol );
      FFiltered := False;
    End;
  Finally
    If Solver <> Nil Then
      Solver.Free;
  End;
End;

function TEzLayer.GetBookmark: Pointer;
var
  I: Integer;
  bmrk: TEzDesktopBookmark;
begin
  bmrk:= TEzDesktopBookmark.Create;
  bmrk.FRecno:= FRecno;
  bmrk.FFiltered:= FFiltered;
  bmrk.FEofCrack:= FEofCrack;
  bmrk.FFilterRecno:= FFilterRecno;
  bmrk.FCurrentLoaded:= FCurrentLoaded;
  bmrk.FEzxData:= FEzxData;
  bmrk.FEZDPos:= FEzDStream.Position;
  bmrk.FEZXPos:= FEzDStream.Position;
  if (ol <> nil) and (ol.Count > 0) then
  begin
    bmrk.Fol.Capacity:= ol.Count;
    for I:= 0 to ol.Count-1 do
      bmrk.Fol.Add( ol[I] );
  end;
  Result:= bmrk;
end;

procedure TEzLayer.GotoBookmark(Bookmark: Pointer);
var
  I: Integer;
  bmrk: TEzDesktopBookmark;
begin
  bmrk:= TEzDesktopBookmark(Bookmark);
  FRecno:= bmrk.FRecno;
  FFiltered:= bmrk.FFiltered;
  FEofCrack:= bmrk.FEofCrack;
  FFilterRecno:= bmrk.FFilterRecno;
  FCurrentLoaded:= bmrk.FCurrentLoaded;
  FEzxData:= bmrk.FEzxData;
  FEzDStream.Position:= bmrk.FEZDPos;
  FEzXStream.Position:= bmrk.FEZXPos;
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

procedure TEzLayer.FreeBookmark(Bookmark: Pointer);
begin
  TEzDesktopBookmark(Bookmark).Free;
end;

{-------------------------------------------------------------------------------}
{                  TEzGIS - class implementation                             }
{-------------------------------------------------------------------------------}
Constructor TEzGIS.Create( Aowner: TComponent );
begin
  Layers := TEzLayers.Create( Self );
  inherited Create( AOwner );
  FMapInfo := TEzMapInfo.Create( self );
end;

Procedure TEzGIS.Notification( AComponent: TComponent; Operation: TOperation );
begin
  Inherited Notification( AComponent, Operation );
  If ( Operation = opRemove ) And ( AComponent = FProvider) Then
    FProvider := Nil
end;

procedure TEzGIS.SetProvider(const Value: TEzDataSetProvider);
begin
{$IFDEF LEVEL5}
  if Assigned( FProvider ) then FProvider.RemoveFreeNotification( Self );
{$ENDIF}
  If ( Value <> Nil ) And ( Value <> FProvider ) Then
  Begin
    Value.FreeNotification( Self );
  End;
  FProvider := Value;
end;

{$IFDEF BCB}
function TEzGIS.GetProvider: TEzDataSetProvider;
begin
  Result := FProvider;
end;
{$ENDIF}

Procedure TEzGIS.AddGeoref( Const LayerName, FileName: String );
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

Function TEzGIS.CreateLayer( Const LayerName: String; LayerType: TEzLayerType ): TEzBaseLayer;
Begin
  If LayerType = ltMemory Then
    Result := TEzMemoryLayer.Create( Layers, LayerName )
  Else If LayerType = ltDesktop then
    Result := TEzLayer.Create( Layers, LayerName )
  Else
    Result:= nil;
End;

Procedure TEzGIS.WriteMapHeader( Const Filename: String );
Var
  Inifile: TInifile;
  I: Integer;
  TheMapHeader: TEzMapHeader;
  LayerType: Integer;
Begin
  If ReadOnly Or ( Length( FileName ) = 0 ) Then Exit;
  Inifile := TInifile.Create( FileName );
  Try
    TheMapHeader := TEzMapInfo( FMapInfo ).MapHeader;
    With TheMapHeader Do
    Begin
      HeaderID := MAP_ID;
      VersionNumber := MAP_VERSION_NUMBER;
      NumLayers := Layers.Count;
    End;
    TEzMapInfo( FMapInfo ).MapHeader := TheMapHeader;
    With Inifile, TheMapHeader Do
    Begin
      WriteInteger( 'General', 'Version', VersionNumber );
      WriteInteger( 'General', 'FileID', HeaderID );
      WriteInteger( 'General', 'NumLayers', NumLayers );
      WriteFloatToIni( Inifile, 'General', 'Extension_X1', Extension.X1 );
      WriteFloatToIni( Inifile, 'General', 'Extension_Y1', Extension.Y1 );
      WriteFloatToIni( Inifile, 'General', 'Extension_X2', Extension.X2 );
      WriteFloatToIni( Inifile, 'General', 'Extension_Y2', Extension.Y2 );
      Writestring( 'General', 'CurrentLayer', CurrentLayer );
      Writestring( 'General', 'AerialViewLayer', AerialViewLayer );
      WriteFloatToIni( Inifile, 'General', 'LastView_X1', LastView.X1 );
      WriteFloatToIni( Inifile, 'General', 'LastView_Y1', LastView.Y1 );
      WriteFloatToIni( Inifile, 'General', 'LastView_X2', LastView.X2 );
      WriteFloatToIni( Inifile, 'General', 'LastView_Y2', LastView.Y2 );
      WriteInteger( 'General', 'CoordSystem', Ord( CoordSystem ) );
      WriteInteger( 'General', 'CoordsUnits', Ord( CoordsUnits ) );
      WriteBool( 'General', 'IsAreaClipped', IsAreaClipped );
      WriteFloatToIni( Inifile, 'General', 'AreaClipped_X1', AreaClipped.X1 );
      WriteFloatToIni( Inifile, 'General', 'AreaClipped_Y1', AreaClipped.Y1 );
      WriteFloatToIni( Inifile, 'General', 'AreaClipped_X2', AreaClipped.X2 );
      WriteFloatToIni( Inifile, 'General', 'AreaClipped_Y2', AreaClipped.Y2 );
      WriteInteger( 'General', 'ClipAreaKind', Ord( ClipAreaKind ) );
      // now save the name of layers
      Inifile.EraseSection( 'Layers' );
      For I := 0 To Layers.Count - 1 Do
      Begin
        Writestring( 'Layers', 'FileName' + IntTostr( I ), Layers[I].FileName );
        LayerType:= -1 ;
        If Layers[I] Is TEzLayer then
          LayerType:= 0
        Else If Layers[I] Is TEzMemoryLayer then
          LayerType:= 1
        Else If Layers[I] Is TSHPLayer then
          LayerType:= 2
        Else If Layers[I] Is TDGNLayer then
          LayerType:= 3;

        WriteInteger( 'Layers', 'LayerType' + IntTostr( I ), LayerType );
        WriteFloatToIni( Inifile, 'Layers', 'MaxScale', Layers[I].MaxScale );
        WriteFloatToIni( Inifile, 'Layers', 'MinScale', Layers[I].MinScale );
        //Layers[I].WriteHeaders(FlushFiles); // flush files
      End;
    End;
  Finally
    Inifile.free;
  End;
End;

Procedure TEzGIS.Open;
Var
  LayerName, FullName, CurrPath, TmpFile: String;
  I, n, Index, hcount, vcount, Search: Integer;
  Inifile: TInifile;
  TmpModified, Found, MissedInfo: Boolean;
  X, Y, Coord: Double;
  TheMapHeader: TEzMapHeader;
  CanContinue: Boolean;
  //TempDecimalSeparator, SaveDecimalSeparator: Char;
  //WeChanged: Boolean;
  LayerType: Integer;
  MaxScale: Double;
  MinScale: Double;
Begin
  If IsDesigning Or (BaseTableClass = Nil) Then Exit;

  Close;

  Inherited Open;

  If ( Length( FileName ) = 0 ) Or Not FileExists( FileName ) Then
  Begin
    Modified := false;
    Exit;
  End;
  TmpModified := False;
  { is reading from a readonly file ?}
  If HasAttr( FileName, SysUtils.faReadOnly ) Then
    Self.ReadOnly := True;
  MissedInfo := False;
  Inifile := TInifile.Create( FileName );
  Try
    TheMapHeader := TEzMapInfo( FMapInfo ).MapHeader;
    With Inifile, TEzMapInfo( FMapInfo ) Do
    Begin
      With TheMapHeader Do
      Begin
        HeaderID := ReadIntFromIni( Inifile, 'General', 'FileID', 0 );
        VersionNumber := ReadIntFromIni( Inifile, 'General', 'Version', 0 );
        If Not ( ( TheMapHeader.HeaderID = MAP_ID ) And
          ( TheMapHeader.VersionNumber = MAP_VERSION_NUMBER ) ) Then
        Begin
          MessageToUser( SWrongCADFile, smsgerror, MB_ICONERROR );
        End;
        NumLayers := ReadIntFromIni( Inifile, 'General', 'NumLayers', 0 );
        Extension.X1 := ReadFloatFromIni( Inifile, 'General', 'Extension_X1', MAXCOORD );
        Extension.Y1 := ReadFloatFromIni( Inifile, 'General', 'Extension_Y1', MAXCOORD );
        Extension.X2 := ReadFloatFromIni( Inifile, 'General', 'Extension_X2', MINCOORD );
        Extension.Y2 := ReadFloatFromIni( Inifile, 'General', 'Extension_Y2', MINCOORD );
        CurrentLayer := ReadString( 'General', 'CurrentLayer', '' );
        AerialViewLayer := ReadString( 'General', 'AerialViewLayer', '' );
        LastView.X1 := ReadFloatFromIni( Inifile, 'General', 'LastView_X1', MAXCOORD );
        LastView.Y1 := ReadFloatFromIni( Inifile, 'General', 'LastView_Y1', MAXCOORD );
        LastView.X2 := ReadFloatFromIni( Inifile, 'General', 'LastView_X2', MINCOORD );
        LastView.Y2 := ReadFloatFromIni( Inifile, 'General', 'LastView_Y2', MINCOORD );
        CoordSystem := TEzCoordSystem( ReadIntFromIni( Inifile, 'General', 'CoordSystem', 0 ) );
        CoordsUnits := TEzCoordsUnits( ReadIntFromIni( Inifile, 'General', 'CoordsUnits', 0 ) );
        IsAreaClipped := ReadBool( 'General', 'IsAreaClipped', False );
        AreaClipped.X1 := ReadFloatFromIni( Inifile, 'General', 'AreaClipped_X1', 0 );
        AreaClipped.Y1 := ReadFloatFromIni( Inifile, 'General', 'AreaClipped_Y1', 0 );
        AreaClipped.X2 := ReadFloatFromIni( Inifile, 'General', 'AreaClipped_X2', 0 );
        AreaClipped.Y2 := ReadFloatFromIni( Inifile, 'General', 'AreaClipped_Y2', 0 );
        ClipAreaKind := TEzClipAreaKind( ReadIntFromIni( Inifile, 'General', 'ClipAreaKind', 0 ) );
      End;
      TEzMapInfo( FMapInfo ).MapHeader := TheMapHeader;

      Layers.Clear;
      For I := 0 To TheMapHeader.NumLayers - 1 Do
      Begin
        FullName := ChangeFileExt( ReadString( 'Layers', 'FileName' + IntTostr( I ), '' ), '');
        LayerName:= ExtractFileName( ChangeFileExt( FullName, '' ) );
        LayerType := ReadInteger( 'Layers', 'LayerType' + IntTostr( I ), -1 );
        MaxScale := ReadFloatFromIni( Inifile, 'Layers', 'MaxScale', 0);
        MinScale := ReadFloatFromIni( Inifile, 'Layers', 'MinScale', 0);
        Found := False;
        For Search:= 1 to 3 do  // three searchs
        begin
          If Search = 1 then
          Begin
            // now look on the original file
            CurrPath:= Trim( ExtractFilePath( FullName ) );
            If Length( CurrPath ) = 0 then Continue;
            CurrPath:= AddSlash( CurrPath );
          End Else If Search = 2 then
          Begin
            // first, look in the same directory as the map opened
            CurrPath := AddSlash( ExtractFilePath( Self.FileName ) )
          End Else If Search = 3 then
          Begin
            // now look if it is found in the LayersSubdir property
            If Length( LayersSubdir ) > 0 Then
              CurrPath := AddSlash( LayersSubdir )
            Else
              CurrPath := '';
          End;

          Index:= -1;
          If LayerType = -1 then
          Begin
            { try to find the layer if a layer type was not defined }
            TmpFile:= CurrPath + LayerName;
            If FileExists( TmpFile + EZDEXT ) And FileExists( TmpFile + EZXEXT ) Then
              LayerType:= 0
            Else If FileExists( TmpFile + CADEXT ) Then // is this a memory layer ?
              LayerType:= 1
            Else If FileExists( TmpFile + '.shp' ) Then
              LayerType:= 2
            Else If FileExists( TmpFile + '.dgn' ) Then
              LayerType:= 3;
          End;
          If LayerType In [0..3] Then
          Begin
            TmpFile:= CurrPath + LayerName ;
            Case LayerType Of
              0: // Destop Layer
                If FileExists( TmpFile + EZDEXT ) Then
                Begin
                  Index := Layers.Add( TmpFile, ltDesktop );
                End;
              1: // CAD Layer
                If FileExists( TmpFile + CADEXT ) Then
                Begin
                  Index := Layers.Add( TmpFile, ltMemory );
                End;
              2: // ArcView Layer without importing
                If FileExists( TmpFile + '.shp' ) Then
                Begin
                  TSHPLayer.Create( Layers, TmpFile );
                  Index:= Layers.Count-1;
                End;
              3: // DGN Layer without importing
                If FileExists( TmpFile + '.dgn' ) Then
                Begin
                  TDGNLayer.Create( Layers, TmpFile );
                  Index:= Layers.Count-1;
                End;
            End;
          End;
          Found := Index >= 0;
          If Found Then
          begin
            TmpModified := True;
            Layers[Index].MaxScale := MaxScale;
            Layers[Index].MinScale := MinScale;
            Layers[Index].Open;
            Layers[Index].LayerInfo.CoordsUnits := TheMapHeader.CoordsUnits;
            Break;
          End;
        End;
        If Not Found Then
        Begin
          If Assigned( OnError ) Then
          Begin
            CanContinue := true;
            OnError( Self, Format( SLayerFilesNotFound, [LayerName] ), esLayerNotFound, CanContinue );
          End;
          //MessageToUser(Format(SLayerFilesNotFound, [LayerName]), smsgerror, MB_ICONERROR);
          Modified := true;
          MissedInfo := True;
        End;
      End;

      // read the coord system and check params
      ProjectionParams.Clear;
      IniFile.ReadSectionValues( 'Projection', ProjectionParams );

      { now read the guidelines}
      HGuidelines.Clear;
      VGuidelines.Clear;
      hcount := ReadIntFromIni( Inifile, 'General', 'HGuidelines', 0 );
      vcount := ReadIntFromIni( Inifile, 'General', 'VGuidelines', 0 );
      For I := 0 To hcount - 1 Do
      Begin
        Coord := ReadFloatFromIni( Inifile, 'HGuidelines', 'Coord' + IntTostr( I ), 0 );
        HGuidelines.Add( Coord );
      End;
      If hcount > 0 Then
        HGuideLines.Sort;
      For I := 0 To vcount - 1 Do
      Begin
        Coord := ReadFloatFromIni( Inifile, 'VGuidelines', 'Coord' + IntTostr( I ), 0 );
        VGuidelines.Add( Coord );
      End;
      If vcount > 0 Then
        VGuideLines.Sort;

      { now read the polygonal clipping area }
      ClipPolygonalArea.Clear;
      n := ReadIntFromIni( Inifile, 'General', 'ClipPolygonalArea', 0 );
      For I := 0 To n - 1 Do
      Begin
        X := ReadFloatFromIni( Inifile, 'ClipPolygonalArea', Format( 'Point%d_X', [I] ), 0 );
        Y := ReadFloatFromIni( Inifile, 'ClipPolygonalArea', Format( 'Point%d_Y', [I] ), 0 );
        ClipPolygonalArea.Add( Point2D( X, Y ) );
      End;

      { finish reading from .INI file }
      //if WeChanged then
      //begin
      //  DecimalSeparator:= SaveDecimalSeparator;
      //end;

      If ( Length( TheMapHeader.AerialViewLayer ) > 0 ) And
        ( Layers.IndexOfName( TheMapHeader.AerialViewLayer ) = -1 ) Then
      Begin
        TheMapHeader.AerialViewLayer := '';
        Modified := true;
      End;

      If Length( TheMapHeader.CurrentLayer ) > 0 Then
      Begin
        If Not ( ( Layers.Count > 0 ) And ( Layers.IndexOfName( TheMapHeader.CurrentLayer ) >= 0 ) ) Then
          CurrentLayer := ''
      End;

      If Assigned( OnCurrentLayerChange ) Then
        OnCurrentLayerChange( Self, CurrentLayer );

      If Not MissedInfo Then
        MissedInfo:= EqualRect2d( TheMapHeader.Extension, INVALID_EXTENSION);
      If MissedInfo Then
        Self.QuickUpdateExtension;
      If EqualRect2d( TheMapHeader.LastView, INVALID_EXTENSION) Then
      begin
        TheMapHeader:= TEzMapInfo( FMapInfo ).MapHeader;
        TheMapHeader.LastView:= TheMapHeader.Extension;
        TEzMapInfo( FMapInfo ).MapHeader:= TheMapHeader;
      end;

    End;
  Finally
    Inifile.Free;
  End;

  If Assigned( OnFileNameChange ) Then
    OnFileNameChange( Self );
  { Clear temp entities }
  For I := 0 To DrawBoxList.Count - 1 Do
  Begin
    DrawBoxList[I].TempEntities.Clear;
    DrawBoxList[I].Selection.Clear;
  End;

  { redisplay the viewports }
  For I := 0 To DrawBoxList.Count - 1 Do
    With DrawBoxList[I] Do
    Begin
      If Self.AutoSetLastView Then
        Grapher.SetViewTo( FMapInfo.LastView );
      Grapher.Clear;
    End;

  Modified := TmpModified;
End;

Procedure TEzGIS.SaveAs( Const FileName: String );
Var
  I, n, np, hcount, vcount: Integer;
  s, Ident, Value, TmpFileName: String;
  X, Y, Coord: double;
  Inifile: TInifile;
  TheMapHeader: TEzMapHeader;
Begin
  If ( Length( FileName ) = 0 ) Or ReadOnly Then Exit;
  TmpFilename := self.FileName;
  Self.FileName := FileName;
  If TmpFilename <> self.FileName Then
  Begin
    If Assigned( OnFileNameChange ) Then
      OnFileNameChange( Self );
  End;
  If DrawBoxList.Count > 0 Then
    FMapInfo.LastView := DrawBoxList[0].Grapher.CurrentParams.VisualWindow;

  TheMapHeader := TEzMapInfo( FMapInfo ).MapHeader;
  With TheMapHeader Do
  Begin
    HeaderID := MAP_ID;
    VersionNumber := MAP_VERSION_NUMBER;
    NumLayers := Layers.Count;
  End;
  TEzMapInfo( FMapInfo ).MapHeader := TheMapHeader;
  WriteMapHeader( FileName );
  Inifile := TInifile.Create( Self.FileName );
  Try
    { save the memory layers }
    For I := 0 To Layers.Count - 1 Do
      If Layers[I] Is TEzMemoryLayer Then
        TEzMemoryLayer( Layers[I] ).SaveToFile;

    (* save the coord system *)
    For I := 0 To ProjectionParams.Count - 1 Do
    Begin
      s := ProjectionParams[i];
      np := AnsiPos( '=', s );
      If np > 0 Then
      Begin
        Ident := Copy( s, 1, np - 1 );
        Value := Copy( s, np + 1, Length( s ) );
        Inifile.WriteString( 'Projection', Ident, Value );
      End;
    End;

    { save the guidelines }
    hcount := HGuideLines.Count;
    vcount := VGuideLines.Count;
    Inifile.WriteInteger( 'General', 'HGuidelines', hcount );
    Inifile.WriteInteger( 'General', 'VGuidelines', vcount );
    For I := 0 To hcount - 1 Do
    Begin
      Coord := HGuidelines[I];
      WriteFloatToIni( Inifile, 'HGuidelines', 'Coord' + IntTostr( I ), Coord );
    End;
    For I := 0 To vcount - 1 Do
    Begin
      Coord := VGuidelines[I];
      WriteFloatToIni( Inifile, 'VGuidelines', 'Coord' + IntTostr( I ), Coord );
    End;

    { Save the polygonal clipping area }
    n := ClipPolygonalArea.Count;
    If n = 0 Then
      Inifile.EraseSection( 'ClipPolygonalArea' );
    Inifile.WriteInteger( 'General', 'ClipPolygonalArea', n );
    For i := 0 To n - 1 Do
    Begin
      X := ClipPolygonalArea[I].X;
      Y := ClipPolygonalArea[I].Y;
      WriteFloatToIni( Inifile, 'ClipPolygonalArea', Format( 'Point%d_X', [I] ), X );
      WriteFloatToIni( Inifile, 'ClipPolygonalArea', Format( 'Point%d_Y', [I] ), Y );
    End;

    //Inifile.WriteString( 'General', 'DecimalSeparator', DecimalSeparator );

  Finally
    Inifile.Free;
  End;

  Modified := False;
End;

{------------------------------------------------------------------------------}
{                  TEzGeorefImage implementation                               }
{------------------------------------------------------------------------------}

{ TEzGeorefPoint }

Procedure TEzGeorefPoint.Assign( Source: TPersistent );
Var
  Src: TEzGeorefPoint Absolute Source;
Begin
  If Source Is TEzGeorefPoint Then
    FGeorefPt := Src.FGeorefPt
  Else
    Inherited Assign( Source );
End;

Function TEzGeorefPoint.GetCaption: String;
Begin
  With FGeorefPt Do
    Result := Format( '(%d, %d) -> (%.*n, %.*n)', [XPixel,
      YPixel,
        6,
        XWorld,
        6,
        YWorld] );
End;

Function TEzGeorefPoint.GetDisplayName: String;
Begin
  result := GetCaption;
  If Result = '' Then
    Result := Inherited GetDisplayName;
End;

Function TEzGeorefPoint.GetXPixel: Integer;
Begin
  result := FGeorefPt.XPixel;
End;

Function TEzGeorefPoint.GetXWorld: Double;
Begin
  result := FGeorefPt.XWorld;
End;

Function TEzGeorefPoint.GetYPixel: Integer;
Begin
  result := FGeorefPt.YPixel;
End;

Function TEzGeorefPoint.GetYWorld: Double;
Begin
  result := FGeorefPt.YWorld;
End;

Procedure TEzGeorefPoint.LoadFromStream( Stream: TStream );
Begin
  Stream.Read( FGeorefPt, sizeof( FGeorefPt ) );
End;

Procedure TEzGeorefPoint.SaveToStream( Stream: TStream );
Begin
  Stream.Write( FGeorefPt, sizeof( FGeorefPt ) );
End;

Procedure TEzGeorefPoint.SetXPixel( Const Value: Integer );
Begin
  FGeorefPt.XPixel := Value;
End;

Procedure TEzGeorefPoint.SetXWorld( Const Value: Double );
Begin
  FGeorefPt.XWorld := Value;
End;

Procedure TEzGeorefPoint.SetYPixel( Const Value: Integer );
Begin
  FGeorefPt.YPixel := Value;
End;

Procedure TEzGeorefPoint.SetYWorld( Const Value: Double );
Begin
  FGeorefPt.YWorld := Value;
End;

{ TEzGeorefPoints }

Constructor TEzGeorefPoints.Create( AOwner: TPersistent );
Begin
  Inherited Create( AOwner, TEzGeorefPoint );
End;

Function TEzGeorefPoints.Add: TEzGeorefPoint;
Begin
  Result := TEzGeorefPoint( Inherited Add );
End;

Function TEzGeorefPoints.GetItem( Index: Integer ): TEzGeorefPoint;
Begin
  Result := TEzGeorefPoint( Inherited GetItem( Index ) );
End;

Procedure TEzGeorefPoints.LoadFromStream( Stream: TStream );
Var
  I, RecCount: Integer;
Begin
  Clear;
  Stream.Read( RecCount, sizeof( Integer ) );
  For I := 1 To RecCount Do
    Add.LoadFromStream( Stream );
End;

Procedure TEzGeorefPoints.SaveToStream( Stream: TStream );
Var
  I, RecCount: Integer;
Begin
  RecCount := Self.Count;
  Stream.Write( RecCount, SizeOf( RecCount ) );
  For i := 0 To RecCount - 1 Do
    GetItem( I ).SaveToStream( Stream );
End;

Procedure TEzGeorefPoints.SetItem( Index: Integer; Value: TEzGeorefPoint );
Begin
  Inherited SetItem( Index, Value );
End;

{ TEzGeorefImage }

Constructor TEzGeorefImage.Create( AOwner: TComponent );
Begin
  Inherited Create( AOwner );
  FGeorefPoints := TEzGeorefPoints.Create( Self );
End;

Destructor TEzGeorefImage.Destroy;
Begin
  FGeorefPoints.Free;
  Inherited Destroy;
End;

Procedure TEzGeorefImage.SetGeorefPoints( Value: TEzGeorefPoints );
Begin
  FGeorefPoints.Assign( Value );
End;

Procedure TEzGeorefImage.Open;
Var
  IO: TFileStream;
  HeaderID: Integer;
  Version: Integer;
Begin
  If ( Length( FFileName ) = 0 ) Or Not FileExists( FFileName ) Then
    Exit;
  IO := TFileStream.Create( FileName, fmOpenRead Or fmShareDenyNone );
  Try
    IO.Read( HeaderID, sizeof( HeaderID ) );
    If HeaderID <> 8888 Then
      Raise Exception.Create( 'Wrong file header' );
    IO.Read( Version, sizeof( Version ) );
    If Version <> 100 Then
      Raise Exception.Create( 'Wrong version number' );
    FImageName := EzReadStrFromStream( IO );
    IO.Read( FExtents, sizeof( FExtents ) );
    FGeorefPoints.LoadFromStream( IO );
  Finally
    IO.Free;
  End;
End;

Procedure TEzGeorefImage.Save;
Var
  IO: TFileStream;
  HeaderID: Integer;
  Version: Integer;
Begin
  If Length( FFileName ) = 0 Then
    Exit;
  IO := TFileStream.Create( FFileName, fmCreate );
  Try
    HeaderID := 8888;
    IO.Write( HeaderID, SizeOf( HeaderID ) );
    Version := 100;
    IO.Write( Version, SizeOf( Version ) );
    EzWriteStrToStream( FImageName, Io );
    IO.Write( FExtents, sizeof( FExtents ) );
    FGeorefPoints.SaveToStream( IO );
  Finally
    IO.Free;
  End;
End;

Procedure TEzGeorefImage.New;
Begin
  FGeorefPoints.Clear;
  FImageName := '';
  FFileName := '';
End;

Procedure TEzGeorefImage.Assign( Source: TPersistent );
Begin
  If Not ( Source Is TEzGeorefImage ) Then Exit;
  With TEzGeorefImage( Source ) Do
  Begin
    Self.FFileName := FFileName;
    Self.FImageName := FImageName;
    Self.FExtents := FExtents;
    Self.FGeorefPoints.Assign( FGeorefPoints );
  End;
End;


{ TEzDataSetProvider }

function TEzLayer.GetFiltered: Boolean;
begin
  Result := FFiltered;
end;

procedure TEzMemoryGIS.WriteMapHeader( Const Filename: String );
begin
  //
end;

constructor TEzMemoryGIS.Create( AOwner: TComponent ); 
begin
  Layers := TEzLayers.Create( Self );
  Inherited Create( AOwner );
  FMapInfo := TEzMapInfo.Create( self );
end;

function TEzMemoryGIS.CreateLayer( Const LayerName: String; LayerType: TEzLayerType ): TEzBaseLayer;
begin
  if LayerType = ltDesktop then
    Result := TEzLayer.Create(Layers, ExtractFileName(LayerName))
  else
    Result := TEzMemoryLayer.Create(Layers, ExtractFileName(LayerName));
end;

procedure TEzMemoryGIS.Open; 
begin
  //
end;

procedure TEzMemoryGIS.Close; 
var
  I: Integer;
begin
  inherited Close;
  for I := 0 to Layers.Count-1 do
    Layers[I].Close;
end;

procedure TEzMemoryGIS.SaveAs( Const Filename: String ); 
begin
  //
end;

procedure TEzMemoryGIS.SaveToStream( Stream: TStream );
begin
  //
end;

procedure TEzMemoryGIS.LoadFromStream( Stream: TStream );
begin
  //
end;

end.
