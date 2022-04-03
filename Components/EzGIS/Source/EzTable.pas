Unit EzTable;

{***********************************************************}
{     EzGIS/CAD Components                                  }
{   (c) 2002 EzSoft Engineering                             }
{         All Rights Reserved                               }
{***********************************************************}

{$I EZ_FLAG.PAS}
Interface

Uses
  Classes, SysUtils, Windows, Forms, DB, EzSystem, EzBaseGIS, EzBase,
  EzBaseExpr, EzLib, EzExpressions
{.$IFDEF LEVEL6}
  , Variants
{.$ENDIF}
  ;

Type
  {-------------------------------------------------------------------------------}
  //                  TGXBaseDataset
  {-------------------------------------------------------------------------------}

  TEzBaseDataset = Class( TDataset )
  Private
    FisOpen: Boolean;
    FStartCalculated: Integer;
    FBufferMap: TStringList;
    FRecordSize: Integer; // full buffer size
    FDataSize: Integer; // from bull buffer, only the data size
    //FInternalBookmarkSize: Integer;
    Procedure FillBufferMap;
    Procedure AllocateBLOBPointers( Buffer: PChar );
    Procedure FreeBlobPointers( Buffer: PChar );
  Protected {My simplified methods to override}
    Function DoOpen: Boolean; Virtual; Abstract;
    Procedure DoClose; Virtual; Abstract;
    Procedure DoDeleteRecord; Virtual;
    Procedure DoCreateFieldDefs; Virtual; Abstract;
    Function GetFieldValue( Field: TField ): Variant; Virtual; Abstract;
    Procedure SetFieldValue( Field: TField; Const Value: Variant ); Virtual; Abstract;
    Procedure GetBlobField( Field: TField; Stream: TStream ); Virtual; Abstract;
    Procedure SetBlobField( Field: TField; Stream: TStream ); Virtual; Abstract;
    //Called before and after getting a set of field values
    Procedure DoBeforeGetFieldValue; Virtual;
    Procedure DoAfterGetFieldValue; Virtual;
    Procedure DoBeforeSetFieldValue( Inserting: Boolean ); Virtual;
    Procedure DoAfterSetFieldValue( Inserting: Boolean ); Virtual;
    //Handle buffer ID
    Function AllocateRecordID: Pointer; Virtual; Abstract;
    Procedure DisposeRecordID( Value: Pointer ); Virtual; Abstract;
    Procedure GotoRecordID( Value: Pointer ); Virtual; Abstract;
    //BookMark functions
    Function GetBookMarkSize: Integer; Virtual;  //******
    Procedure DoGotoBookmark( Bookmark: Pointer ); Virtual; Abstract;  //********
    Procedure AllocateBookMark( RecordID: Pointer; Bookmark: Pointer ); Virtual; Abstract;
    //Navigation methods
    Procedure DoFirst; Virtual; Abstract;
    Procedure DoLast; Virtual; Abstract;
    Function Navigate( Buffer: PChar; GetMode: TGetMode; doCheck: Boolean ): TGetResult; Virtual; Abstract;
    //Internal isOpen property
    Property isOpen: Boolean Read FisOpen;
    Function FilterRecord( Buffer: PChar ): Boolean; Virtual;
    Function DoBookmarkValid( Bookmark: TBookmark ): boolean; Virtual; Abstract;
    Function DoCompareBookmarks( Bookmark1, Bookmark2: TBookmark ): Integer; Virtual; Abstract;
  Protected {TEzBaseDataset Internal functions that can be overriden if needed}
    Procedure AllocateBLOBPointer( Field: TField; Var P: Pointer ); Virtual;
    Procedure FreeBLOBPointer( Field: TField; Var P: Pointer ); Virtual;
    Procedure FreeRecordPointers( Buffer: PChar ); Virtual;
    Function GetDataSize: Integer; Virtual;
    Procedure BufferToRecord( Buffer: PChar ); Virtual;
    Procedure RecordToBuffer( Buffer: PChar ); Virtual;
  Protected
    Function AllocRecordBuffer: PChar; Override;
    Procedure FreeRecordBuffer( Var Buffer: PChar ); Override;
    Function GetRecord( Buffer: PChar; GetMode: TGetMode; DoCheck: Boolean ): TGetResult; Override;
    Function GetRecordSize: Word; Override;
    Procedure InternalInsert; Override;
    Procedure InternalClose; Override;
    Procedure InternalDelete; Override;
    Procedure InternalFirst; Override;
    Procedure InternalEdit; Override;
    Procedure InternalHandleException; Override;
    Procedure InternalInitFieldDefs; Override;
    Procedure InternalInitRecord( Buffer: PChar ); Override;
    Procedure InternalLast; Override;
    Procedure InternalOpen; Override;
    Procedure InternalPost; Override;
    Procedure InternalSetToRecord( Buffer: PChar ); Override;
    Procedure InternalAddRecord( Buffer: Pointer; Append: Boolean ); Override;
    Function IsCursorOpen: Boolean; Override;
    Function GetCanModify: Boolean; Override;
    Procedure ClearCalcFields( Buffer: PChar ); Override;
    Function GetActiveRecordBuffer: PChar; Virtual;
    Procedure SetFieldData( Field: TField; Buffer: Pointer ); Override;
    Procedure GetBookmarkData( Buffer: PChar; Data: Pointer ); Override;
    Function GetBookmarkFlag( Buffer: PChar ): TBookmarkFlag; Override;
    Procedure SetBookmarkFlag( Buffer: PChar; Value: TBookmarkFlag ); Override;
    Procedure SetBookmarkData( Buffer: PChar; Data: Pointer ); Override;
    Procedure InternalGotoBookmark( Bookmark: Pointer ); Override;

    Function BCDToCurr( BCD: Pointer; Var Curr: Currency ): Boolean;
{$IFNDEF LEVEL5} //Override;
{$ENDIF}
    Function CurrToBCD( Const Curr: Currency; BCD: Pointer; Precision, Decimals: Integer ): Boolean;
{$IFNDEF LEVEL5} //Override;
{$ENDIF}
  Public
    Constructor Create( AOwner: TComponent ); Override;
    Destructor Destroy; Override;
    Function GetFieldData( Field: TField; Buffer: Pointer ): Boolean; Override;
    Function BookmarkValid( Bookmark: TBookmark ): boolean; Override;
    Function CompareBookmarks( Bookmark1, Bookmark2: TBookmark ): Integer; Override;
    //function CreateBlobStream(Field: TField; Mode: TBlobStreamMode): TStream; override;
{$IFDEF LEVEL4}
    Procedure SetBlockReadSize( Value: Integer ); Override;
{$ENDIF}
  Published
    { inherited events }
    Property BeforeOpen;
    Property AfterOpen;
    Property BeforeClose;
    Property AfterClose;
    Property BeforeInsert;
    Property AfterInsert;
    Property BeforeEdit;
    Property AfterEdit;
    Property BeforePost;
    Property AfterPost;
    Property BeforeCancel;
    Property AfterCancel;
    Property BeforeDelete;
    Property AfterDelete;
    Property BeforeScroll;
    Property AfterScroll;
    Property OnCalcFields;
    Property OnDeleteError;
    Property OnEditError;
    Property OnFilterRecord;
    Property OnNewRecord;
    Property OnPostError;
  End;

  {-------------------------------------------------------------------------------}
  //                  TEzTable
  {-------------------------------------------------------------------------------}

    { for browse one layer }
  TEzGISField = Class( TCollectionItem )
  Private
    FExpression: String;
    FFieldName: String; // used as the TField.FieldName when IsExpression=true
    FIsExpression: Boolean;
    SourceField: Integer; // runtime only
    FResolver: TEzMainExpr; // runtime only
    Procedure SetExpression( Const Value: String ); // used only when FIsExpresion=true
  Protected
    Function GetDisplayName: String; Override;
    Function GetCaption: String;
  Public
    Destructor Destroy; Override;
    Procedure Assign( Source: TPersistent ); Override;

    Property Resolver: TEzMainExpr Read FResolver Write FResolver;
  Published
    Property Expression: String Read FExpression Write SetExpression;
    Property FieldName: String Read FFieldName Write FFieldName;
    Property IsExpression: Boolean Read FIsExpression Write FIsExpression;
  End;

  TEzTable = Class;

  TEzGISFields = Class( TOwnedCollection )
  Private
    FOwner: TEzTable;
    Function GetItem( Index: Integer ): TEzGISField;
    Procedure SetItem( Index: Integer; Value: TEzGISField );
  Public
    Constructor Create( AOwner: TEzTable );
    Function Add: TEzGISField;
    Procedure PopulateFromLayer( Const Layer: TEzBaseLayer );
{$IFDEF LEVEL5}
    Procedure Move( FromIndex, ToIndex: Integer );
{$ENDIF}

    Property Items[Index: Integer]: TEzGISField Read GetItem Write SetItem; Default;
  End;

  TEzTable = Class( TEzBaseDataset )
  Private
    FGIS: TEzBaseGIS;
    FMapFields: TEzGISFields;
    FLayer: TEzBaseLayer;
    FRecords: TIntegerList;
    FFindExpr: TEzMainExpr;
    FFilterExpr: TEzMainExpr;
    FUseDeleted: Boolean;
    FRecordCount: Integer;
    FMaxRecords: Integer;
    FCurRec: Integer;
    FReadOnly: Boolean;
    FFindRow: Integer;
    FLayerName: String;
    { for filtering graphically the database }
    FGraphicFilterList: TIntegerList;
    FGraphicFiltered: Boolean;
    Procedure AddFieldDesc( FieldNo: Word );
    Procedure SetBaseLayer;
    Procedure CreateFilterExpr( Const Text: String );
    Procedure RebuildRecordList;
    Function GetSourceRecNo: Integer;
    Procedure SetGIS( Const Value: TEzBaseGIS );
    Procedure SetReadOnly( Value: Boolean );
    Procedure SetFilterData( Const Text: String );
    Function DoFindFirst: Boolean;
    Procedure SetLayerName( Const Value: String );
  {$IFDEF BCB}
    function GetGIS: TEzBaseGIS;
    function GetLayer: TEzBaseLayer;
    function GetLayerName: String;
    function GetMapFields: TEzGISFields;
    function GetMaxRecords: Longint;
    function GetReadOnly: Boolean;
    function GetUseDeleted: Boolean;
    procedure SetLayer(const Value: TEzBaseLayer);
    procedure SetMaxRecords(const Value: Longint);
    procedure SetUseDeleted(const Value: Boolean);
  {$ENDIF}
  Protected
    Function FilterRecord( Buffer: PChar ): Boolean; Override;
    Procedure InternalRefresh; Override;
    Function DoOpen: Boolean; Override;
    Procedure DoClose; Override;
    Procedure DoDeleteRecord; Override;
    Procedure DoCreateFieldDefs; Override;
    Function GetFieldValue( Field: TField ): Variant; Override;
    Procedure SetFieldValue( Field: TField; Const Value: Variant ); Override;
    //Handle buffer ID
    Function AllocateRecordID: Pointer; Override;
    Procedure DisposeRecordID( Value: Pointer ); Override;
    Procedure GotoRecordID( Value: Pointer ); Override;
    //BookMark functions
    Function GetBookMarkSize: Integer; Override;
    Procedure DoGotoBookmark( Bookmark: Pointer ); Override;
    Procedure AllocateBookMark( RecordID: Pointer; Bookmark: Pointer ); Override;
    Function DoBookmarkValid( Bookmark: TBookmark ): boolean; Override;
    Function DoCompareBookmarks( Bookmark1, Bookmark2: TBookmark ): Integer; Override;
    Procedure DoBeforeGetFieldValue; Override;
    //Navigation methods
    Procedure DoFirst; Override;
    Procedure DoLast; Override;
    Function Navigate( Buffer: PChar; GetMode: TGetMode; doCheck: Boolean ): TGetResult; Override;
    Procedure AllocateBLOBPointer( Field: TField; Var P: Pointer ); Override;
    Procedure FreeBLOBPointer( Field: TField; Var P: Pointer ); Override;
    //Called before and after getting a set of field values
    //procedure DoBeforeGetFieldValue; override;
    //procedure DoAfterGetFieldValue; override;
    Procedure DoBeforeSetFieldValue( Inserting: Boolean ); Override;
    //procedure DoAfterSetFieldValue(Inserting: Boolean); override;
    // other
    Function GetRecordCount: Integer; Override;
    Procedure SetRecNo( Value: Integer ); Override;
    Function GetRecNo: Integer; Override;
    Procedure Notification( AComponent: TComponent; Operation: toperation ); Override;
    Procedure SetFilterText( Const Value: String ); Override;
    Procedure SetFiltered( Value: Boolean ); Override;
    Function GetCanModify: Boolean; Override;
    Procedure GetBlobField( Field: TField; Stream: TStream ); Override;
    Procedure SetBlobField( Field: TField; Stream: TStream ); Override;
  Public
    Constructor Create( AOwner: TComponent ); Override;
    Destructor Destroy; Override;
    Function IsSequenced: Boolean; Override;
    Function Locate( Const KeyFields: String; Const KeyValues: Variant;
      Options: TLocateOptions ): Boolean; Override;
    Function Lookup( Const KeyFields: String;
      Const KeyValues: Variant; Const ResultFields: String ): Variant; Override;

    Function CreateBlobStream( Field: TField; Mode: TBlobStreamMode ): TStream; Override;
    Function Find( Const Expression: String; Direction: TEzDirection; Origin: TEzOrigin ): Boolean;
    Function FindNext: Boolean;
    Procedure OrderBy( Const Expression: String; Descending: Boolean );
    Procedure UnSort;
    Function IsDeleted: boolean;
    Procedure Recall;
    Procedure SelectionFilter( Selection: TEzSelection; ClearBefore: Boolean );
    Procedure ScopeFilter( Const Scope: String; ClearBefore: Boolean );
    Procedure PolygonFilter( Polygon: TEzEntity; Operator: TEzGraphicOperator;
      Const QueryExpression: String; ClearBefore: Boolean );
    Procedure RectangleFilter( Const AxMin, AyMin, AxMax, AyMax: Double;
      Operator: TEzGraphicOperator; Const QueryExpression: String;
      ClearBefore: Boolean );
    Procedure BufferFilter( Buffer: TEzEntity; Operator: TEzGraphicOperator;
      Const QueryExpression: String; CurvePoints: Integer;
      Const Distance: Double; ClearBefore: Boolean );
    Procedure PolylineIntersects( Polyline: TEzEntity;
      Const QueryExpression: String; ClearBefore: Boolean );
    Procedure FilterFromLayer( SourceLayer: TEzBaseLayer;
      Const QueryExpression: String; Operator: TEzGraphicOperator; ClearBefore: Boolean );
    Procedure DoSelect( Selection: TEzSelection );

    Property SourceRecNo: Integer Read GetSourceRecNo;
    Property Layer: TEzBaseLayer {$IFDEF BCB} Read GetLayer Write SetLayer {$ELSE} Read FLayer Write FLayer {$ENDIF};
  Published
    Property ReadOnly: Boolean {$IFDEF BCB} Read GetReadOnly {$ELSE} Read FReadOnly {$ENDIF} Write SetReadOnly Default False;
    Property MaxRecords: Longint {$IFDEF BCB} Read GetMaxRecords Write SetMaxRecords {$ELSE} Read FMaxRecords Write FMaxRecords {$ENDIF};
    Property GIS: TEzBaseGIS {$IFDEF BCB} Read GetGIS {$ELSE} Read FGIS {$ENDIF} Write SetGIS;
    Property UseDeleted: Boolean {$IFDEF BCB} Read GetUseDeleted Write SetUseDeleted {$ELSE} Read FUseDeleted Write FUseDeleted {$ENDIF} Default True;
    Property MapFields: TEzGISFields {$IFDEF BCB} Read GetMapFields {$ELSE} Read FMapFields {$ENDIF};
    Property LayerName: String {$IFDEF BCB} Read GetLayerName {$ELSE} Read FLayerName {$ENDIF} Write SetLayerName;

    { inherited properties }
    Property Filter;
    Property Filtered;

  End;

  { TDesignTable - a dataset used for editing fields when restructuring }
  TEzDesignTable = Class( TEzBaseDataset )
  Private
    FNameColumn: TStringList;
    FAliasColumn: TStringList;
    FTypeColumn: TStringList;
    FSizeColumn: TIntegerList;
    FDecColumn: TIntegerList;
    FOrigFieldNoColumn: TIntegerList;
    FRecordCount: Integer;
    FCurRec: Integer;
    FModified: Boolean;
  Protected
    Procedure InternalRefresh; Override;
    Function DoOpen: Boolean; Override;
    Procedure DoClose; Override;
    Procedure DoDeleteRecord; Override;
    Procedure DoCreateFieldDefs; Override;
    Function GetFieldValue( Field: TField ): Variant; Override;
    Procedure SetFieldValue( Field: TField; Const Value: Variant ); Override;
    //Handle buffer ID
    Function AllocateRecordID: Pointer; Override;
    Procedure DisposeRecordID( Value: Pointer ); Override;
    Procedure GotoRecordID( Value: Pointer ); Override;
    //BookMark functions
    Function GetBookMarkSize: Integer; Override;
    Procedure DoGotoBookmark( Bookmark: Pointer ); Override;
    Procedure AllocateBookMark( RecordID: Pointer; Bookmark: Pointer ); Override;
    Function DoBookmarkValid( Bookmark: TBookmark ): boolean; Override;
    Function DoCompareBookmarks( Bookmark1, Bookmark2: TBookmark ): Integer; Override;
    //Navigation methods
    Procedure DoFirst; Override;
    Procedure DoLast; Override;
    Function Navigate( Buffer: PChar; GetMode: TGetMode; doCheck: Boolean ): TGetResult; Override;
    //Called before and after getting a set of field values
    procedure DoBeforeGetFieldValue; override;
    procedure DoAfterGetFieldValue; override;
    Procedure DoBeforeSetFieldValue( Inserting: Boolean ); Override;
    procedure DoAfterSetFieldValue(Inserting: Boolean); override;
    Procedure GetBlobField( Field: TField; Stream: TStream ); Override;
    Procedure SetBlobField( Field: TField; Stream: TStream ); Override;
    // other
    Function GetRecordCount: Integer; Override;
    Procedure SetRecNo( Value: Integer ); Override;
    Function GetRecNo: Integer; Override;
    Function GetCanModify: Boolean; Override;
  Public
    Constructor Create( AOwner: TComponent ); Override;
    Destructor Destroy; Override;
    Function IsSequenced: Boolean; Override;
  End;

Implementation

Uses
  EzConsts;

type

  PRecordInfo = ^TRecordInfo;
  TRecordInfo = Record
    RecordID: Pointer;
    Bookmark: Pointer;
    BookMarkFlag: TBookmarkFlag;
  End;


{-------------------------------------------------------------------------------}
//                  TEzBaseDataset
{-------------------------------------------------------------------------------}

Constructor TEzBaseDataset.Create( AOwner: TComponent );
Begin
  Inherited Create( AOwner );
  FBufferMap := TStringList.Create;
End;

Destructor TEzBaseDataset.Destroy;
Begin
  If Active Then
    Close;
  FBufferMap.Free;
  Inherited Destroy;
End;

Procedure TEzBaseDataset.FillBufferMap;
Var
  Index, Offset: Integer;
Begin
  FBufferMap.Clear;
  Offset := 0;
  For Index := 0 To FieldCount - 1 Do
  Begin
    FBufferMap.AddObject( Fields[Index].FieldName, Pointer( Offset ) );
    Case FieldbyName( FBufferMap[Index] ).DataType Of
      ftString: inc( Offset, FieldbyName( FBufferMap[Index] ).Size + 1 );
      ftInteger, ftSmallInt, ftDate, ftTime: inc( Offset, sizeof( Integer ) );
      ftDateTime, ftFloat, ftBCD, ftCurrency: inc( Offset, sizeof( Double ) );
      ftBoolean: inc( Offset, sizeof( WordBool ) );
      ftGraphic, ftMemo: inc( Offset, sizeof( Pointer ) );
    End;
  End;
End;

Procedure TEzBaseDataset.InternalOpen;
Begin
  If DoOpen Then
  Begin
    BookmarkSize := GetBookMarkSize; //Bookmarks not supported
    InternalInitFieldDefs;
    If DefaultFields Then
      CreateFields;
    BindFields( True );
    FisOpen := True;
    FillBufferMap;
    FRecordSize := GetRecordSize;
  End;
End;

Function TEzBaseDataset.AllocRecordBuffer: PChar;
Begin
  GetMem( Result, FRecordSize );
  FillChar( Result^, FRecordSize, 0 );
  AllocateBlobPointers( Result );
End;

Procedure TEzBaseDataset.FreeRecordBuffer( Var Buffer: PChar );
Begin
  FreeRecordPointers( Buffer );
  FreeMem( Buffer, FRecordSize );
End;

Procedure TEzBaseDataset.FreeRecordPointers( Buffer: PChar );
Begin
  FreeBlobPointers( Buffer );
  DisposeRecordID( PRecordInfo( Buffer + FDataSize ).RecordID );
  If PRecordInfo( Buffer + FDataSize )^.BookMark <> Nil Then
  Begin
    FreeMem( PRecordInfo( Buffer + FDataSize )^.BookMark );
    PRecordInfo( Buffer + FDataSize )^.BookMark := Nil;
  End;
End;

Procedure TEzBaseDataset.AllocateBLOBPointers( Buffer: PChar );
Var
  Index: Integer;
  Offset: Integer;
  //Stream: TMemoryStream;
  P: Pointer;
Begin
  For Index := 0 To FieldCount - 1 Do
    If Fields[Index].DataType In [ftMemo, ftGraphic] Then
    Begin
      Offset := Integer( FBufferMap.Objects[Index] );
      //Stream:=TMemoryStream.Create;
      //Move(Pointer(Stream),(Buffer+Offset)^,sizeof(Pointer));
      // get the pointer to the blob field
      AllocateBlobPointer( Fields[Index], P );
      Move( P, ( Buffer + Offset )^, sizeof( Pointer ) );
    End;
End;

Procedure TEzBaseDataset.FreeBlobPointers( Buffer: PChar );
Var
  Index: Integer;
  Offset: Integer;
  P: Pointer;
Begin
  For Index := 0 To FieldCount - 1 Do
    If Fields[Index].DataType In [ftMemo, ftGraphic] Then
    Begin
      Offset := Integer( FBufferMap.Objects[Index] );
      Move( ( Buffer + Offset )^, Pointer( P ), sizeof( Pointer ) );
      FreeBlobPointer( Fields[Index], P );
      //if FreeAndNil<>nil then FreeAndNil.Free;
      P := Nil;
      Move( P, ( Buffer + Offset )^, sizeof( Pointer ) );
    End;
End;

Procedure TEzBaseDataset.AllocateBLOBPointer( Field: TField; Var P: Pointer );
Begin
  P := Nil;
End;

Procedure TEzBaseDataset.FreeBLOBPointer( Field: TField; Var P: Pointer );
Begin
  P := Nil;
End;

Procedure TEzBaseDataset.InternalInitFieldDefs;
Begin
  DoCreateFieldDefs;
End;

Procedure TEzBaseDataset.ClearCalcFields( Buffer: PChar );
Begin
  FillChar( Buffer[FStartCalculated], CalcFieldsSize, 0 );
End;

Function TEzBaseDataset.GetActiveRecordBuffer: PChar;
Begin
  Case State Of
    dsBrowse: If isEmpty Then
        Result := Nil
      Else
        Result := ActiveBuffer;
    dsCalcFields: Result := CalcBuffer;
    dsFilter: Result := Nil;
    dsEdit, dsInsert: Result := ActiveBuffer;
    dsNewValue, dsOldValue, dsCurValue: Result := ActiveBuffer;
{$IFDEF level5}
    dsBlockRead: Result := ActiveBuffer;
{$ENDIF}
  Else
    Result := Nil;
  End;
End;

Function TEzBaseDataset.GetCanModify: Boolean;
Begin
  Result := False;
End;

Function TEzBaseDataset.GetRecord( Buffer: PChar; GetMode: TGetMode; DoCheck: Boolean ): TGetResult;
Begin
  Result := Navigate( Buffer, GetMode, DoCheck );
  If ( Result = grOk ) Then
  Begin
    RecordToBuffer( Buffer );
    ClearCalcFields( Buffer );
    GetCalcFields( Buffer );
  End
  Else If ( Result = grError ) And DoCheck Then
    DatabaseError( 'No Records' );
End;

Function TEzBaseDataset.GetRecordSize: Word;
Begin
  FDataSize := GetDataSize;
  Result := FDataSize + sizeof( TRecordInfo ) + CalcFieldsSize;
  FStartCalculated := FDataSize + sizeof( TRecordInfo );
End;

Function TEzBaseDataset.GetDataSize: Integer;
Var
  Index: Integer;
Begin
  Result := 0;
  For Index := 0 To FieldCount - 1 Do
    Case Fields[Index].DataType Of
      ftString: Result := Result + Fields[Index].Size + 1; //Leave space for terminating null
      ftInteger, ftSmallInt, ftDate, ftTime: Result := Result + sizeof( Integer );
      ftFloat, ftCurrency, ftBCD, ftDateTime: Result := Result + sizeof( Double );
      ftBoolean: Result := Result + sizeof( WordBool );
      ftMemo, ftGraphic: Result := Result + sizeof( Pointer );
    End;
End;

Procedure TEzBaseDataset.InternalClose;
Begin
  BindFields( False );
  If DefaultFields Then
    DestroyFields;
  DoClose;
  FisOpen := False;
End;

Procedure TEzBaseDataset.InternalDelete;
Begin
  DoDeleteRecord;
End;

Procedure TEzBaseDataset.InternalEdit;
Begin
  If GetActiveRecordBuffer <> Nil Then
    InternalSetToRecord( GetActiveRecordBuffer );
End;

Procedure TEzBaseDataset.InternalFirst;
Begin
  DoFirst;
End;

Procedure TEzBaseDataset.InternalHandleException;
Begin
  Application.HandleException( Self );
End;

{This is called by the TDataset to initialize an already existing buffer.
We cannot just fill the buffer with 0s since that would overwrite our BLOB pointers.
Therefore we free the blob pointers first, then fill the buffer with zeros, then
reallocate the blob pointers}

Procedure TEzBaseDataset.InternalInitRecord( Buffer: PChar );
Begin
  FreeRecordPointers( Buffer );
  FillChar( Buffer^, FRecordSize, 0 );
  AllocateBlobPointers( Buffer );
End;

Procedure TEzBaseDataset.InternalInsert;
Begin

End;

Procedure TEzBaseDataset.InternalLast;
Begin
  DoLast;
End;

Procedure TEzBaseDataset.InternalPost;
Begin
  If FisOpen Then
  Begin
    DoBeforeSetFieldValue( State = dsInsert );
    BufferToRecord( GetActiveRecordBuffer );
    DoAfterSetFieldValue( State = dsInsert );
  End;
End;

Procedure TEzBaseDataset.InternalAddRecord( Buffer: Pointer; Append: Boolean );
Begin
  If Append Then
    InternalLast;
  DoBeforeSetFieldValue( True );
  BufferToRecord( Buffer );
  DoAfterSetFieldValue( True );
End;

Procedure TEzBaseDataset.InternalSetToRecord( Buffer: PChar );
Begin
  GotoRecordID( PRecordInfo( Buffer + FDataSize ).RecordID );
End;

Function TEzBaseDataset.IsCursorOpen: Boolean;
Begin
  Result := FisOpen;
End;

Procedure TEzBaseDataset.BufferToRecord( Buffer: PChar );
Var
  TempStr: String;
  TempInt: Integer;
  TempDouble: Double;
  TempBool: WordBool;
  Offset: Integer;
  Index: Integer;
  //Stream: TStream;
Begin
  For Index := 0 To FieldCount - 1 Do
  Begin
    Offset := Integer( FBufferMap.Objects[Fields[Index].FieldNo - 1] );
    Case Fields[Index].DataType Of
      ftString:
        Begin
          TempStr := PChar( Buffer + Offset );
          SetFieldValue( Fields[Index], TempStr );
        End;
      ftInteger, ftSmallInt, ftDate, ftTime:
        Begin
          Move( ( Buffer + Offset )^, TempInt, sizeof( Integer ) );
          SetFieldValue( Fields[Index], TempInt );
        End;
      ftFloat, ftBCD, ftCurrency, ftDateTime:
        Begin
          Move( ( Buffer + Offset )^, TempDouble, sizeof( Double ) );
          SetFieldValue( Fields[Index], TempDouble );
        End;
      ftBoolean:
        Begin
          Move( ( Buffer + Offset )^, TempBool, sizeof( Boolean ) );
          SetFieldValue( Fields[Index], TempBool );
        End;
      ftGraphic, ftMemo:
        Begin
          {Move( ( Buffer + Offset )^, Pointer( Stream ), sizeof( Pointer ) );
          Stream.Position := 0;
          SetBlobField( Fields[Index], Stream );}
        End;
    End;
  End;
End;

Procedure TEzBaseDataset.RecordToBuffer( Buffer: PChar );
Var
  Value: Variant;
  TempStr: String;
  TempInt: Integer;
  TempDouble: Double;
  TempBool: WordBool;
  Offset: Integer;
  Index: Integer;
  //Stream: TStream;
Begin
  With PRecordInfo( Buffer + FDataSize )^ Do
  Begin
    BookmarkFlag := bfCurrent;
    RecordID := AllocateRecordID;
    If BookmarkSize > 0 Then
    Begin
      If BookMark = Nil Then
        GetMem( BookMark, BookmarkSize );
      AllocateBookMark( RecordID, BookMark );
    End
    Else
      BookMark := Nil;
  End;
  DoBeforeGetFieldValue;
  For Index := 0 To FieldCount - 1 Do
  Begin
    If Not ( Fields[Index].DataType In [ftMemo, ftGraphic] ) Then
      Value := GetFieldValue( Fields[Index] );
    if Fields[Index].FieldNo < 0 then Continue;
    Offset := Integer( FBufferMap.Objects[Fields[Index].FieldNo - 1] );
    Case Fields[Index].DataType Of
      ftString:
        Begin
          If VarIsNull( Value ) Then
            TempStr := ''
          Else
            TempStr := Value;
          If length( TempStr ) > Fields[Index].Size Then
            System.Delete( TempStr, Fields[Index].Size, length( TempStr ) - Fields[Index].Size );
          StrLCopy( PChar( Buffer + Offset ), PChar( TempStr ), length( TempStr ) );
        End;
      ftInteger, ftSmallInt, ftDate, ftTime:
        Begin
          If VarIsNull( Value ) Then
            TempInt := 0
          Else
            TempInt := Value;
          Move( TempInt, ( Buffer + Offset )^, sizeof( TempInt ) );
        End;
      ftFloat, ftBCD, ftCurrency, ftDateTime:
        Begin
          If VarIsNull( Value ) Then
            TempDouble := 0
          Else
            TempDouble := Value;
          Move( TempDouble, ( Buffer + Offset )^, sizeof( TempDouble ) );
        End;
      ftBoolean:
        Begin
          If VarIsNull( Value ) Then
            TempBool := false
          Else
            TempBool := Value;
          Move( TempBool, ( Buffer + Offset )^, sizeof( TempBool ) );
        End;
      ftMemo, ftGraphic:
        Begin
          {
          Move( ( Buffer + Offset )^, Pointer( Stream ), sizeof( Pointer ) );
          if Stream <> Nil then
          begin
            Stream.Size := 0;
            Stream.Position := 0;
            GetBlobField( Fields[Index], Stream );
          end; }
        End;
    End;
  End;
  DoAfterGetFieldValue;
End;

Procedure TEzBaseDataset.DoDeleteRecord;
Begin
  //Nothing in base class
End;

Function TEzBaseDataset.GetFieldData( Field: TField; Buffer: Pointer ): Boolean;
Var
  RecBuffer: PChar;
  Offset: Integer;
  TempDouble: Double;
  Data: TDateTimeRec;
  TimeStamp: TTimeStamp;
  TempBool: WordBool;
Begin
  Result := false;
  If Not FisOpen Then
    exit;
  RecBuffer := GetActiveRecordBuffer;
  If RecBuffer = Nil Then
    exit;
  If Buffer = Nil Then
  Begin
    //Dataset checks if field is null by passing a nil buffer
    //Tell it is not null by passing back a result of True
    Result := True;
    exit;
  End;
  If ( Field.FieldKind = fkCalculated ) Or ( Field.FieldKind = fkLookup ) Then
  Begin
    inc( RecBuffer, FStartCalculated + Field.Offset );
    If ( RecBuffer[0] = #0 ) Or ( Buffer = Nil ) Then
      exit
    Else
      CopyMemory( Buffer, @RecBuffer[1], Field.DataSize );
  End
  Else
  Begin
    Offset := Integer( FBufferMap.Objects[Field.FieldNo - 1] );
    Case Field.DataType Of
      ftInteger, ftTime, ftDate:
        Move( ( RecBuffer + Offset )^, Integer( Buffer^ ), sizeof( Integer ) );
      ftBoolean:
        Begin
          Move( ( RecBuffer + Offset )^, TempBool, sizeof( WordBool ) );
          Move( TempBool, WordBool( Buffer^ ), sizeof( WordBool ) );
        End;
      ftString:
        Begin
          StrLCopy( Buffer, PChar( RecBuffer + Offset ), StrLen( PChar( RecBuffer + Offset ) ) );
          StrPCopy( Buffer, TrimRight( StrPas( Buffer ) ) );
        End;
      ftCurrency, ftFloat: Move( ( RecBuffer + Offset )^, Double( Buffer^ ), sizeof( Double ) );
      ftDateTime:
        Begin
          Move( ( RecBuffer + Offset )^, TempDouble, sizeof( Double ) );
          TimeStamp := DateTimeToTimeStamp( TempDouble );
          Data.DateTime := TimeStampToMSecs( TimeStamp );
          Move( Data, Buffer^, sizeof( TDateTimeRec ) );
        End;
    End;
  End;
  Result := True;
End;

Procedure TEzBaseDataset.SetFieldData( Field: TField; Buffer: Pointer );
Var
  Offset: Integer;
  RecBuffer: Pchar;
  TempDouble: Double;
  Data: TDateTimeRec;
  TimeStamp: TTimeStamp;
  TempBool: WordBool;
Begin
  If Not Active Then
    exit;
  RecBuffer := GetActiveRecordBuffer;
  If RecBuffer = Nil Then
    exit;
  If Buffer = Nil Then
    exit;
  If ( Field.FieldKind = fkCalculated ) Or ( Field.FieldKind = fkLookup ) Then
  Begin
    Inc( RecBuffer, FStartCalculated + Field.Offset );
    Boolean( RecBuffer[0] ) := ( Buffer <> Nil );
    If Boolean( RecBuffer[0] ) Then
      CopyMemory( @RecBuffer[1], Buffer, Field.DataSize );
  End
  Else
  Begin
    Offset := Integer( FBufferMap.Objects[Field.FieldNo - 1] );
    Case Field.DataType Of
      ftInteger, ftDate, ftTime: Move( Integer( Buffer^ ), ( RecBuffer + Offset )^, sizeof( Integer ) );
      ftBoolean:
        Begin
          Move( WordBool( Buffer^ ), TempBool, sizeof( WordBool ) );
          Move( TempBool, ( RecBuffer + Offset )^, sizeof( WordBool ) );
        End;
      ftString: StrLCopy( PChar( RecBuffer + Offset ), Buffer, StrLen( PChar( Buffer ) ) );
      ftDateTime:
        Begin
          Data := TDateTimeRec( Buffer^ );
          TimeStamp := MSecsToTimeStamp( Data.DateTime );
          TempDouble := TimeStampToDateTime( TimeStamp );
          Move( TempDouble, ( RecBuffer + Offset )^, sizeof( TempDouble ) );
        End;
      ftFloat, ftCurrency: Move( Double( Buffer^ ), ( RecBuffer + Offset )^, sizeof( Double ) );
    End;
  End;
  If Not ( State In [dsCalcFields, dsFilter, dsNewValue] ) Then
    DataEvent( deFieldChange, Longint( Field ) );
End;

Function TEzBaseDataset.GetBookMarkSize: Integer;
Begin
  Result := 0;
End;

Procedure TEzBaseDataset.GetBookmarkData( Buffer: PChar; Data: Pointer );
Begin
  If BookMarkSize > 0 Then
    AllocateBookMark( PRecordInfo( Buffer + FDataSize ).RecordID, Data );
End;

Function TEzBaseDataset.GetBookmarkFlag( Buffer: PChar ): TBookmarkFlag;
Begin
  Result := PRecordInfo( Buffer + FDataSize ).BookMarkFlag;
End;

Procedure TEzBaseDataset.SetBookmarkData( Buffer: PChar; Data: Pointer );
Begin
  If PRecordInfo( Buffer + FDataSize )^.BookMark = Nil Then
    GetMem( PRecordInfo( Buffer + FDataSize )^.BookMark, BookmarkSize );
  Move( PRecordInfo( Buffer + FDataSize ).BookMark^, Data, BookmarkSize );
End;

Procedure TEzBaseDataset.SetBookmarkFlag( Buffer: PChar; Value: TBookmarkFlag );
Begin
  PRecordInfo( Buffer + FDataSize ).BookMarkFlag := Value;
End;

Procedure TEzBaseDataset.InternalGotoBookmark( Bookmark: Pointer );
Begin
  DoGotoBookMark( BookMark );
End;

Function TEzBaseDataset.BookmarkValid( Bookmark: TBookmark ): boolean;
Begin
  result := DoBookmarkValid( Bookmark );
End;

Function TEzBaseDataset.CompareBookmarks( Bookmark1, Bookmark2: TBookmark ): Integer;
Begin
  result := DoCompareBookmarks( Bookmark1, Bookmark2 );
End;

{function TEzBaseDataset.CreateBlobStream(Field: TField; Mode: TBlobStreamMode): TStream;
begin
  Result:=TEzBlobStream.Create(Field as TBlobField, Mode);
end; }

Procedure TEzBaseDataset.DoAfterGetFieldValue;
Begin

End;

Procedure TEzBaseDataset.DoBeforeGetFieldValue;
Begin

End;

Procedure TEzBaseDataset.DoAfterSetFieldValue( Inserting: Boolean );
Begin

End;

Procedure TEzBaseDataset.DoBeforeSetFieldValue( Inserting: Boolean );
Begin

End;

Function TEzBaseDataset.BCDToCurr( BCD: Pointer; Var Curr: Currency ): Boolean;
Begin
  Move( BCD^, Curr, SizeOf( Currency ) );
  Result := True;
End;

Function TEzBaseDataset.CurrToBCD( Const Curr: Currency; BCD: Pointer; Precision,
  Decimals: Integer ): Boolean;
Begin
  Move( Curr, BCD^, SizeOf( Currency ) );
  Result := True;
End;

Function TEzBaseDataset.FilterRecord( Buffer: PChar ): Boolean;
Begin
  result := True;
End;

{$IFDEF LEVEL4}

Procedure TEzBaseDataset.SetBlockReadSize( Value: Integer );
{$IFNDEF LEVEL5}
Var
  DoNext: Boolean;
{$ENDIF}
Begin
  If Value <> BlockReadSize Then
  Begin
    If ( Value > 0 ) Or ( Value < -1 ) Then
    Begin
      Inherited;
      BlockReadNext;
    End
    Else
    Begin
{$IFNDEF LEVEL5}
      doNext := Value = -1;
{$ENDIF}
      Value := 0;
      Inherited;

{$IFNDEF LEVEL5}
      If doNext Then
        Next
      Else
      Begin
{$ENDIF}
        CursorPosChanged;
        Resync( [] );
{$IFNDEF LEVEL5}
      End;
{$ENDIF}
    End;
  End;
End;
{$ENDIF}

//************************** TEzBlobStream ***************************************
{constructor TEzBlobStream.Create(Field: TBlobField; Mode: TBlobStreamMode);
Begin
  inherited Create;
  FField:=Field;
  FMode:=Mode;
  FDataSet:=FField.DataSet as TEzBaseDataset;
  if Mode<>bmWrite then LoadBlobData;
End;

destructor TEzBlobStream.Destroy;
Begin
  if FModified then SaveBlobData;
  inherited Destroy;
End;

function TEzBlobStream.Read(var Buffer; Count: Longint): Longint;
Begin
  Result:=inherited Read(Buffer,Count);
  FOpened:=True;
End;

function TEzBlobStream.Write(const Buffer; Count: Longint): Longint;
Begin
  Result:=inherited Write(Buffer,Count);
  FModified:=True;
End;

procedure TEzBlobStream.LoadBlobData;
var
  Stream: TMemoryStream;
  Offset: Integer;
  RecBuffer: PChar;
Begin
  Self.Size:=0;
  RecBuffer:=FDataset.GetActiveRecordBuffer;
  if RecBuffer<>nil then
    Begin
    Offset:=Integer(FDataset.FBufferMap.Objects[FField.FieldNo-1]);
    Move((RecBuffer+Offset)^,Pointer(Stream),sizeof(Pointer));
    Self.CopyFrom(Stream,0);
    End;
  Position:=0;
End;

procedure TEzBlobStream.SaveBlobData;
var Stream: TMemoryStream;
Offset: Integer;
RecBuffer: Pchar;
Begin
  RecBuffer:=FDataset.GetActiveRecordBuffer;
  if RecBuffer<>nil then
    Begin
    Offset:=Integer(FDataset.FBufferMap.Objects[FField.FieldNo-1]);
    Move((RecBuffer+Offset)^,Pointer(Stream),sizeof(Pointer));
    Stream.Size:=0;
    Stream.CopyFrom(Self,0);
    Stream.Position:=0;
    End;
  FModified:=False;
End; }

{-------------------------------------------------------------------------------}
//                  TEzTable
{-------------------------------------------------------------------------------}

{ TEzGISField }

Destructor TEzGISField.Destroy;
Begin
  If Assigned( FResolver ) Then
    FResolver.Free;

  Inherited Destroy;
End;

Procedure TEzGISField.Assign( Source: TPersistent );
Begin
  If Source Is TEzGISField Then
  Begin
    FExpression := TEzGISField( Source ).Expression;
    FFieldName := TEzGISField( Source ).FieldName;
    FIsExpression := TEzGISField( Source ).IsExpression;
    FreeAndNil( FResolver );
  End
  Else
    Inherited Assign( Source );
End;

Function TEzGISField.GetCaption: String;
Begin
  result := FFieldName;
End;

Function TEzGISField.GetDisplayName: String;
Begin
  result := GetCaption;
  If Result = '' Then
    Result := Inherited GetDisplayName;
End;

Procedure TEzGISField.SetExpression( Const Value: String );
Begin
  FExpression := Value;
  FFieldName := Value;
End;

{ TEzGISFields }

Constructor TEzGISFields.Create( AOwner: TEzTable );
Begin
  FOwner := AOwner;
  Inherited Create( AOwner, TEzGISField );
End;

Function TEzGISFields.Add: TEzGISField;
Begin
  Result := TEzGISField( Inherited Add );
End;

Function TEzGISFields.GetItem( Index: Integer ): TEzGISField;
Begin
  Result := TEzGISField( Inherited GetItem( Index ) );
End;

Procedure TEzGISFields.SetItem( Index: Integer; Value: TEzGISField );
Begin
  Inherited SetItem( Index, Value );
End;

{$IFDEF LEVEL5}

Procedure TEzGISFields.Move( FromIndex, ToIndex: Integer );
Var
  Moved: TEzGISField;
Begin
  Moved := TEzGISField.Create( Self );
  Moved.Assign( GetItem( FromIndex ) );
  Delete( FromIndex );
  Insert( ToIndex );
  GetItem( ToIndex ).Assign( Moved );
  Moved.Free;
End;
{$ENDIF}

Procedure TEzGISFields.PopulateFromLayer( Const Layer: TEzBaseLayer );
Var
  I: Integer;
Begin
  If ( Layer = Nil ) Or ( Layer.DBTable = Nil ) Then exit;

  Clear;
  With Add Do
  Begin
    Expression := 'TYPE(ENT)';
    IsExpression := TRUE;
  End;
  For I := 1 To Layer.DBTable.FieldCount Do
    With Add Do
    Begin
      SourceField := I;
      Expression := Layer.DBTable.Field( I );
      FieldName := Expression;
      IsExpression := False;
    End;
End;

Type

  TMapBlobStream = Class( TMemoryStream )
  Private
    FField: TBlobField;
    FDataSet: TEzTable;
    FIndex: Integer;
    Procedure ReadBlobData;
  Public
    Constructor Create( Field: TBlobField; Mode: TBlobStreamMode );
  End;

Constructor TMapBlobStream.Create( Field: TBlobField; Mode: TBlobStreamMode );
Begin
  Inherited Create;
  FField := Field;
  FIndex := FField.Index;
  FDataSet := FField.DataSet As TEzTable;
  If Mode = bmRead Then
    ReadBlobData;
  If Mode <> bmRead Then
  Begin
    If FField.ReadOnly Then
      DatabaseErrorFmt( 'Field ''%s'' cannot be modified', [FField.DisplayName] );
    If Not ( FDataSet.State In [dsEdit, dsInsert] ) Then
      DatabaseError( SBlobErrNotEditing );
  End;
  If Mode = bmWrite Then
    Clear
  Else
    ReadBlobData;
End;

Procedure TMapBlobStream.ReadBlobData;
Var
  MapField: TEzGISField;
  n: Integer;
Begin
  If FDataSet.RecNo < 1 Then
    Exit;
  MapField := TEzTable( FDataSet ).FMapFields[FIndex];
  n := FDataSet.SourceRecNo;
  With TEzTable( FDataSet ).Layer Do
  Begin
    Recno := n;
    If DBTable <> Nil Then
      DBTable.Recno := n;
    If DBTable <> Nil Then
      DBTable.MemoLoadN( MapField.SourceField, Self );
    //(MapField.SourceField as TBlobField).SaveToStream(Self);
  End;
  Self.Position := 0;
End;

{ TEzTable }

Constructor TEzTable.Create( AOwner: TComponent );
Begin
  Inherited Create( AOwner );
  FMapFields := TEzGISFields.Create( Self );
  FRecords := TIntegerList.Create;
  FGraphicFilterList := TIntegerList.Create;
  FUseDeleted := True;
End;

Destructor TEzTable.Destroy;
Begin
  Inherited Destroy;
  FMapFields.Free;
  FRecords.Free;
  If Assigned( FFilterExpr ) Then
    FFilterExpr.Free;
  If Assigned( FFindExpr ) Then
    FFindExpr.Free;
  FGraphicFilterList.Free;
End;

Function TEzTable.CreateBlobStream( Field: TField; Mode: TBlobStreamMode ): TStream;
Begin
  Result := TMapBlobStream.Create( Field As TBlobField, Mode );
End;

Procedure TEzTable.SetBaseLayer;
Begin
  If FGIS = Nil Then Exit;
  FLayer := Nil;
  If Length( FLayerName ) > 0 Then
    FLayer := FGIS.Layers.LayerByName( FLayerName );
End;

Function TEzTable.DoOpen: Boolean;
Var
  I: Integer;
Begin
  If csDesigning In ComponentState Then
    DatabaseError( SCannotOpenDesignMode );

  If FLayer = Nil Then
    SetBaseLayer;

  If ( FLayer = Nil ) Or Not ( Flayer.Active ) Then
    DatabaseError( SLayerNotAssigned );

  If FMapFields.Count = 0 Then
    FMapFields.PopulateFromLayer( FLayer )
  Else
    { check if FMapFields is defined correctly }
    For I := 0 To FMapFields.Count - 1 Do
      With FMapFields[I] Do
        If Not IsExpression Then
        Begin
          If Layer.DBTable = Nil Then
            DatabaseError( SLayerEmpty );
          If Length( FieldName ) = 0 Then
            DatabaseError( SExpressionEmpty );
          If FLayer.DBTable.FieldNo( FieldName ) = 0 Then
            DatabaseError( Format( SWrongFieldnameCol, [I] ) );
        End
        Else
        Begin
          If Length( FieldName ) = 0 Then
            DatabaseError( SExpressionEmpty );
        End;

  { create the list of records}
  If Assigned( FFilterExpr ) Then
    FreeAndNil( FFilterExpr );

  RebuildRecordList;

  FCurRec := -1;

  Result := True;

End;

Procedure TEzTable.RebuildRecordList;
Var
  I, N, Idx1, Idx2, K: Integer;
  DoFilter, Accepted: Boolean;
Begin
  DoFilter := false;
  If Filtered And ( Length( Filter ) > 0 ) Then
  Begin
    CreateFilterExpr( Filter );
    DoFilter := true;
  End;
  N := FLayer.RecordCount;
  If ( FGraphicFilterList.Count > 0 ) Or FGraphicFiltered Then
  Begin
    Idx1 := 0;
    Idx2 := FGraphicFilterList.Count - 1;
    FGraphicFiltered := true;
  End
  Else
  Begin
    Idx1 := 1;
    Idx2 := N;
    FGraphicFiltered := false;
  End;

  FRecords.Clear;
  FRecords.Capacity := N;
  For I := Idx1 To Idx2 Do
  Begin
    If FGraphicFiltered Then
      K := FGraphicFilterList[I]
    Else
      K := I;
    If Not FUseDeleted Then
    Begin
      FLayer.RecNo := K;
      If FLayer.RecIsDeleted Then
        Continue;
    End;
    Accepted := true;
    If DoFilter Then
    Begin
      FLayer.Recno := K;
      FLayer.Synchronize;
      Accepted:= True;
      if FFilterExpr.Expression <> Nil then
        Accepted := FFilterExpr.Expression.AsBoolean;
    End;
    If Accepted Then
      FRecords.Add( K );
  End;
  If DoFilter Then
    Filtered := False;
  FGraphicFilterList.Clear;
  FRecordCount := FRecords.Count;

End;

Procedure TEzTable.DoClose;
Begin
  FRecords.Clear;
  If Assigned( FFilterExpr ) Then
    FreeAndNil( FFilterExpr );
  If Assigned( FFindExpr ) Then
    FreeAndNil( FFindExpr );
  FGraphicFilterList.Clear;
  FGraphicFiltered := False;
End;

Procedure TEzTable.AllocateBookMark( RecordID, Bookmark: Pointer );
Begin
  PInteger( Bookmark )^ := Integer( RecordID );
End;

Function TEzTable.AllocateRecordID: Pointer;
Begin
  Result := Pointer( FCurRec );
End;

Procedure TEzTable.DisposeRecordID( Value: Pointer );
Begin
  // Do nothing, no need to dispose since pointer is just an integer
End;

Procedure TEzTable.GotoRecordID( Value: Pointer );
Var
  n: Integer;
Begin
  FCurRec := Integer( Value );
  n := FRecords[FCurRec];
  FLayer.Recno := n;
  FLayer.Synchronize;
End;

Procedure TEzTable.AddFieldDesc( FieldNo: Word );
Var
  iFldType: TFieldType;
  Size: Word;
  Name: String;
  typ: char;
Begin
  If FieldNo <= 0 Then Exit;
  Name := FLayer.DBTable.Field( FieldNo );
  Size := 0;
  Typ := FLayer.DBTable.FieldType( FieldNo );
  Case Typ Of
    'C':
      Begin
        iFldType := ftString; { Char string }
        Size := FLayer.DBTable.FieldLen( FieldNo );
      End;
    'F', 'N':
      Begin
        If ( FLayer.DBTable.FieldDec( FieldNo ) > 0 ) Then
        Begin
          iFldType := ftFloat; { Number }
        End
        Else If ( FLayer.DBTable.FieldLen( FieldNo ) > 4 ) Then
        Begin
          iFldType := ftInteger;
        End
        Else
        Begin
          iFldType := ftSmallInt;
        End;
      End;
    'M':
      Begin
        iFldType := ftMemo;
      End;
    'G',
      'B':
      Begin
        iFldType := ftBlob;
      End;
    'L':
      Begin
        iFldType := ftBoolean; { Logical }
      End;
    'D':
      Begin
        iFldType := ftDate; { Date }
      End;
    'I':
      Begin
        iFldType := ftInteger; {VFP integer}
      End;
    'T':
      Begin
        iFldType := ftDateTime; {VFP datetime}
      End;
  Else
    iFldType := ftUnknown;
  End;
  If iFldType <> ftUnknown Then
    FieldDefs.Add( Name, iFldType, Size, false );
End;

Procedure TEzTable.DoCreateFieldDefs;
Var
  I, P: Integer;
  DataType: TFieldType;
  ASize: Word;

  Function UniqueFieldName( Const Value: String ): String;
  Var
    found: Boolean;
    NumTry, J: Integer;
  Begin
    result := Value;
    Numtry := 0;
    Repeat
      Found := False;
      For J := 0 To FieldDefs.Count - 1 Do
        If AnsiCompareText( FieldDefs[J].Name, result ) = 0 Then
        Begin
          Found := True;
          Break;
        End;
      If Found Then
      Begin
        Inc( Numtry );
        result := Value + '_' + IntToStr( Numtry );
      End;
    Until Not Found;
  End;

Begin
  FieldDefs.Clear;
  For I := 0 To FMapFields.Count - 1 Do
    With FMapFields[I] Do
    Begin
      If IsExpression Then
      Begin
        FreeAndNil( FResolver );
        FResolver := TEzMainExpr.Create( FGIS, FLayer );
        FResolver.ParseExpression( Expression );
        ASize := 0;
        Case FResolver.Expression.ExprType Of
          ttString:
            Begin
              DataType := ftString;
              ASize := FResolver.Expression.MaxLen;
              If ASize = 0 Then
                ASize := 10;
            End;
          ttFloat:
            DataType := ftFloat;
          ttInteger:
            DataType := ftInteger;
          ttBoolean:
            DataType := ftBoolean;
        Else
          DataType := ftString;
        End;
        P:= AnsiPos('.', FieldName);
        if P > 0 then
          FieldName:= Copy(FieldName,P+1,Length(FieldName));
        FieldName := UniqueFieldName( FieldName );
        FieldDefs.Add( FieldName, DataType, ASize, false );
        {FldDef:= FieldDefs.AddFieldDef;
        FldDef.Name:= FieldName;
        FldDef.DataType:= DataType;
        FldDef.Size:= ASize;
        FldDef.Required:= False;}
      End
      Else If FLayer.DBTable <> Nil Then
      Begin
        AddFieldDesc( FLayer.DBTable.FieldNo( FieldName ) );
        {FieldName:= FieldName;
        SourceField:= FLayer.DBTable.FieldNo(FieldName);
        FldDef:= FieldDefs.AddFieldDef;
        FldDef.Name:= FLayer.DBTable.Field(SourceField);
        FldDef.DataType:= SourceField.DataType;
        FldDef.Size:= SourceField.Size;
        FldDef.Required:= SourceField.Required;
        if SourceField.DataType = ftBCD then
        begin
          FldDef.Size:= TBCDField(SourceField).Size;
          FldDef.Precision:= TBCDField(SourceField).Precision;
        end; }
      End;
    End;
End;

Procedure TEzTable.DoDeleteRecord;
Begin
  UpdateCursorPos;
  FLayer.DeleteEntity( SourceRecNo );
End;

Procedure TEzTable.DoFirst;
Begin
  FCurRec := -1;
End;

Procedure TEzTable.DoGotoBookmark( Bookmark: Pointer );
Begin
  GotoRecordID( Pointer( PInteger( Bookmark )^ ) );
End;

Procedure TEzTable.DoLast;
Begin
  FCurRec := FRecordCount;
End;

Function TEzTable.GetBookMarkSize: Integer;
Begin
  Result := sizeof( Integer );
End;

Function TEzTable.DoBookmarkValid( Bookmark: TBookmark ): boolean;
Begin
  result := ( PInteger( Bookmark )^ > 0 ) And ( PInteger( Bookmark )^ <= FRecordCount );
End;

Function TEzTable.DoCompareBookmarks( Bookmark1, Bookmark2: TBookmark ): Integer;
Var
  b1, b2: integer;
Begin
  b1 := PInteger( Bookmark1 )^;
  b2 := PInteger( Bookmark2 )^;
  If b1 = b2 Then
    Result := 0
  Else If b1 < b2 Then
    Result := -1
  Else
    Result := 1;
End;

Function TEzTable.Locate( Const KeyFields: String; Const KeyValues: Variant;
  Options: TLocateOptions ): Boolean;
Begin
  result := false;
End;

Function TEzTable.Lookup( Const KeyFields: String;
  Const KeyValues: Variant; Const ResultFields: String ): Variant;
Begin
  result := '';
End;

Function TEzTable.GetFieldValue( Field: TField ): Variant;
Var
  MapField: TEzGISField;
  s: String;
  Ft: Char;
Begin
  If FLayer.RecIsDeleted Then
  Begin
    Result := Null;
    Exit;
  End;
  if Field.FieldNo < 0 then
  begin
    Result:= Field.Value;
    exit;
  end;
  MapField := FMapFields[Field.FieldNo - 1];
  If MapField.IsExpression Then
  Begin
    With MapField.Resolver.Expression Do
      Case ExprType Of
        ttString: result := AsString;
        ttFloat: result := AsFloat;
        ttInteger: result := AsInteger;
        ttBoolean: result := AsBoolean;
      End;
  End
  Else If FLayer.DBTable <> Nil Then
  Begin
    // must be as variant
    Ft := FLayer.DBTable.FieldType( MapField.SourceField );
    Case Ft Of
      'C':
        Begin
          S := FLayer.DBTable.StringGetN( MapField.SourceField );
          If Length( Trim( s ) ) = 0 Then
            Result := Null
          Else
            Result := s;
        End;
      'D', 'T':
        Result := FLayer.DBTable.DateGetN( MapField.SourceField );
      'L':
        Result := FLayer.DBTable.LogicGetN( MapField.SourceField );
      'N', 'F':
        Result := FLayer.DBTable.FloatGetN( MapField.SourceField );
      'I':
        Result := FLayer.DBTable.IntegerGetN( MapField.SourceField );
    End;
  End;
End;

Procedure TEzTable.SetFieldValue( Field: TField; Const Value: Variant );
Var
  MapField: TEzGISField;
Begin
  MapField := FMapFields[Field.FieldNo - 1];
  If MapField.IsExpression Then
    Exit;
  If Not ( FLayer.DBTable.FieldType( MapField.SourceField ) In ['M', 'B', 'G'] ) Then
  Begin
    FLayer.DBTable.Edit;
    FLayer.DBTable.FieldPutN( MapField.SourceField, Value );
    FLayer.DBTable.Post;
  End;
End;

Function TEzTable.Navigate( Buffer: PChar; GetMode: TGetMode; doCheck: Boolean ): TGetResult;
Var
  Acceptable: Boolean;
Begin
  If FRecordCount < 1 Then
    Result := grEOF
  Else
  Begin
    Result := grOK;
    Repeat
      Case GetMode Of
        gmNext:
          If FCurRec >= FRecordCount - 1 Then
            Result := grEOF
          Else
            Inc( FCurRec );
        gmPrior:
          If FCurRec <= 0 Then
          Begin
            Result := grBOF;
            FCurRec := -1;
          End
          Else
            Dec( FCurRec );
        gmCurrent:
          If ( FCurRec < 0 ) Or ( FCurRec >= FRecordCount ) Then
            Result := grError;
      End;
      Acceptable := FilterRecord( Buffer );
      If ( GetMode = gmCurrent ) And Not Acceptable Then
        Result := grError;
      If ( Result = grError ) And DoCheck Then
        DatabaseError( SGetRecordInvalid );
    Until ( Result <> grOk ) Or Acceptable;
  End;
End;

Function TEzTable.Find( Const Expression: String; Direction: TEzDirection;
  Origin: TEzOrigin ): Boolean;
Begin
  result := false;
  If ( FFindExpr <> Nil ) Then
    FreeAndNil( FFindExpr );
  If FRecordCount = 1 Then Exit;
  FFindExpr := TEzMainExpr.Create( FGIS, FLayer );
  Try
    FFindExpr.ParseExpression( Expression );
    If FFindExpr.Expression.ExprType <> ttBoolean Then
    Begin
      DatabaseErrorFmt( 'Expression [''%s''] is not of Boolean type', [Expression] );
      FreeAndNil( FFindExpr );
      Exit;
    End;
    If Origin = orEntire then
      result := DoFindFirst
    Else
    Begin

    End;
  Except
    FreeAndNil( FFindExpr );
  End;
End;

Function TEzTable.DoFindFirst: Boolean;
Var
  n: Integer;
Begin
  result := false;
  If FFindExpr = Nil Then Exit;
  UpdateCursorPos;
  FFindRow := 1;
  While FFindRow <= FRecordCount Do
  Begin
    n := FRecords[FFindRow - 1];
    FLayer.Recno := n;
    If Not Layer.RecIsDeleted Then
      With FGIS Do
      Begin
        FLayer.Synchronize;
        If FFindExpr.Expression.AsBoolean Then
        Begin
          Self.Recno := FFindRow;
          result := true;
          break;
        End;
      End;
    Inc( FFindRow );
  End;
  //if not result then
  //  DatabaseError(SRecordNotFound);
End;

Function TEzTable.FindNext: Boolean;
Var
  n: Longint;
Begin
  result := False;
  If FFindExpr = Nil Then Exit;
  UpdateCursorPos;
  Inc( FFindRow );
  While FFindRow <= FRecordCount Do
  Begin
    n := FRecords[FFindRow - 1];
    FLayer.Recno := n;
    If Not FLayer.RecIsDeleted Then
      With FGIS Do
      Begin
        FLayer.Synchronize;
        If FFindExpr.Expression.AsBoolean Then
        Begin
          Self.Recno := FFindRow;
          result := true;
          Break;
        End;
      End;
    Inc( FFindRow );
  End;
  //if not bfound then
  //  DatabaseError(SRecordNotFound);
End;

Function TEzTable.GetRecNo: Integer;
Begin
  UpdateCursorPos;
  If ( FCurRec = -1 ) And ( FRecordCount > 0 ) Then
    Result := 1
  Else
    Result := FCurRec + 1;
End;

Function TEzTable.GetSourceRecNo: Integer;
Begin
  UpdateCursorPos;
  Result := 0;
  If ( FCurRec < 0 ) Or ( FCurRec > FRecordCount - 1 ) Then Exit;
  result := FRecords[FCurRec];
End;

Function TEzTable.IsDeleted: boolean;
Begin
  UpdateCursorPos;
  result := FLayer.RecIsDeleted;
End;

Procedure TEzTable.SetRecNo( Value: Integer );
Begin
  CheckBrowseMode;
  If ( Value > 0 ) And ( Value <= FRecordCount ) Then
  Begin
    FCurRec := Value - 1;
    FLayer.Recno := FRecords[FCurRec];
    FLayer.Synchronize;
    Resync( [] );
    DoAfterScroll;
  End;
End;

Procedure TEzTable.SetGIS( Const Value: TEzBaseGIS );
Begin
{$IFDEF LEVEL5}
  if Assigned( FGis ) then FGis.RemoveFreeNotification( Self );
{$ENDIF}
  If Value <> Nil Then
  Begin
    Value.FreeNotification( Self );
  End;
  FGIS := Value;
End;

Procedure TEzTable.DoBeforeSetFieldValue( Inserting: Boolean );
Begin
  If Inserting Then
    DatabaseError( SInsertNotAllowed );
End;

Function TEzTable.GetCanModify: Boolean;
Begin
  Result := Not FReadOnly;
End;

Procedure TEzTable.Notification( AComponent: TComponent;
  Operation: toperation );
Begin
  Inherited Notification( AComponent, Operation );
  If ( Operation = opRemove ) And ( AComponent = FGIS ) Then
    FGIS := Nil;
End;

Procedure TEzTable.SetFiltered( Value: Boolean );
Begin
  If IsOpen Then
  Begin
    CheckBrowseMode;
    If Filtered <> Value Then
    Begin
      Inherited SetFiltered( Value );
      If Value Then
        SetFilterData( Filter );
    End;
    First;
  End
  Else
    Inherited SetFiltered( Value );
End;

Procedure TEzTable.SetFilterText( Const Value: String );
Begin
  SetFilterData( Value );
End;

Function TEzTable.IsSequenced: Boolean;
Begin
  Result := Not Filtered;
End;

Procedure TEzTable.SetReadOnly( Value: Boolean );
Begin
  If Value <> FReadOnly Then
  Begin
    If Active Then
      DatabaseError( SWrongReadOnly );
    FReadOnly := Value;
  End;
End;

Procedure TEzTable.CreateFilterExpr( Const Text: String );
Begin
  If Assigned( FFilterExpr ) Then
    FreeAndNil( FFilterExpr );
  If Length( Text ) > 0 Then
  Begin
    FFilterExpr := TEzMainExpr.Create( FGIS, FLayer );
    Try
      FFilterExpr.ParseExpression( Text );
    Except
      FreeAndNil( FFilterExpr );
      Raise;
    End;
  End;
End;

Procedure TEzTable.SetFilterData( Const Text: String );
Begin
  If IsOpen And Filtered And (Length(Text) > 0) Then 
  Begin
    CheckBrowseMode;
    CreateFilterExpr( Text );
    First;
  End;
  Inherited SetFilterText( Text );
End;

Function TEzTable.FilterRecord( Buffer: PChar ): Boolean;
Var
  SaveState: TDatasetState;
Begin
  Result := True;
  If Not Filtered Then
    exit;
  If Not ( Assigned( FFilterExpr ) Or Assigned( OnFilterRecord ) ) Then
    Exit;
  SaveState := SetTempState( dsFilter );
  If Assigned( OnFilterRecord ) Then
    OnFilterRecord( Self, Result );
  If Assigned( FFilterExpr ) And Result Then
  Begin
    FLayer.Recno := FRecords[FCurRec];
    FLayer.Synchronize;
    Result := FFilterExpr.Expression.AsBoolean;
  End;
  RestoreState( SaveState );
End;

Function TEzTable.GetRecordCount: Integer;
Var
  SaveState: TDataSetState;
  SavePosition: integer;
  TempBuffer: PChar;
Begin
  CheckActive;
  If Not Filtered Then
    Result := FRecordCount
  Else
  Begin
    Result := 0;
    SaveState := SetTempState( dsBrowse );
    SavePosition := FCurRec;
    Try
      TempBuffer := AllocRecordBuffer;
      InternalFirst;
      While GetRecord( TempBuffer, gmNext, True ) = grOk Do
        Inc( Result );
    Finally
      RestoreState( SaveState );
      FCurRec := SavePosition;
      FreeRecordBuffer( TempBuffer );
    End;
  End;
End;

Procedure TEzTable.Recall;
Begin
  CheckActive;
  If State In [dsInsert, dsSetKey] Then
    Cancel
  Else
  Begin
    If ( FCurRec < 0 ) Or ( FCurRec >= FRecordCount ) Or
      ( RecordCount = 0 ) Then
      Exit;
    DataEvent( deCheckBrowseMode, 0 );
    DoBeforeScroll;
    UpdateCursorPos;
    FLayer.RecNo := FRecords[FCurRec];
    FLayer.Recall;
    FreeFieldBuffers;
    SetState( dsBrowse );
    Resync( [] );
    DoAfterScroll;
  End;
End;

Procedure TEzTable.OrderBy( Const Expression: String; Descending: Boolean );
Var
  IndexObj: TEzMainExpr;
  Recnum, n, I: Integer;
  SortList: TStringList;
Begin
  If FRecordCount < 2 Then Exit;
  IndexObj := TEzMainExpr.Create( FGIS, Self.FLayer );
  SortList := TStringList.Create;
  DisableControls;
  Try
    IndexObj.ParseExpression( Expression );
    For I := 0 To FRecords.Count - 1 Do
    Begin
      n := FRecords[I];
      FLayer.Recno := n;
      If Not FUseDeleted And FLayer.RecIsDeleted Then Continue;
      FLayer.Synchronize;
      SortList.AddObject( IndexObj.Expression.AsString, Pointer( n ) )
    End;
    SortList.Sort;
    { Now recreate the recno list }
    FRecords.Clear;
    FRecords.Capacity := FRecordCount;
    For I := 0 To SortList.Count - 1 Do
    Begin
      If Descending Then
        Recnum := Integer( SortList.Objects[SortList.Count - I - 1] )
      Else
        Recnum := Integer( SortList.Objects[I] );
      FRecords.Add( Recnum );
    End;
  Finally
    SortList.Free;
    IndexObj.Free;
    First;
    EnableControls;
  End;
End;

Procedure TEzTable.SetLayerName( Const Value: String );
Begin
  InternalClose;
  FLayerName := Value;
  FLayer := Nil;
  FMapFields.Clear;
End;

Procedure TEzTable.InternalRefresh;
Begin
  InternalClose;
  InternalOpen;
End;

Procedure TEzTable.UnSort;
Begin
  RebuildRecordList;
  First;
End;

Procedure TEzTable.DoBeforeGetFieldValue;
Var
  n: Integer;
Begin
  n := FRecords[FCurRec];
  FLayer.Recno := n;
  FLayer.Synchronize;
End;

Procedure TEzTable.BufferFilter( Buffer: TEzEntity;
  Operator: TEzGraphicOperator; Const QueryExpression: String; CurvePoints: Integer;
  Const Distance: Double; ClearBefore: Boolean );
Begin
  SetBaseLayer;
  If ( FLayer = Nil ) Or ( FGIS = Nil ) Then
    Exit;
  FGIS.QueryBuffer( Buffer, FLayer.Name, QueryExpression, Operator, 0,
    CurvePoints, Distance, FGraphicFilterList, ClearBefore );
End;

Procedure TEzTable.ScopeFilter( Const Scope: String; ClearBefore: Boolean );
Begin
  SetBaseLayer;
  If ( FLayer = Nil ) Or ( FGIS = Nil ) Then Exit;
  FGIS.QueryExpression( FLayer.Name, Scope, 0, FGraphicFilterList, ClearBefore );
  FGraphicFiltered := True;
End;

Procedure TEzTable.PolygonFilter( Polygon: TEzEntity;
  Operator: TEzGraphicOperator; Const QueryExpression: String; ClearBefore: Boolean );
Begin
  SetBaseLayer;
  If ( FLayer = Nil ) Or ( FGIS = Nil ) Then Exit;
  FGIS.QueryPolygon( Polygon, FLayer.Name, QueryExpression, Operator, 0,
    FGraphicFilterList, ClearBefore );
  FGraphicFiltered := True;
End;

Procedure TEzTable.RectangleFilter( Const AxMin, AyMin, AxMax, AyMax: Double;
  Operator: TEzGraphicOperator; Const QueryExpression: String; ClearBefore: Boolean );
Begin
  SetBaseLayer;
  If ( FLayer = Nil ) Or ( FGIS = Nil ) Then
    Exit;
  FGIS.QueryRectangle( Axmin, Aymin, Axmax, Aymax, FLayer.Name, QueryExpression,
    Operator, 0, FGraphicFilterList, ClearBefore );
  FGraphicFiltered := True;
End;

Procedure TEzTable.PolylineIntersects( Polyline: TEzEntity;
  Const QueryExpression: String; ClearBefore: Boolean );
Begin
  SetBaseLayer;
  If ( FLayer = Nil ) Or ( FGIS = Nil ) Then Exit;
  FGIS.QueryPolyline( Polyline, FLayer.Name, QueryExpression, 0,
    FGraphicFilterList, ClearBefore );
  FGraphicFiltered := True;
End;

Procedure TEzTable.FilterFromLayer( SourceLayer: TEzBaseLayer;
  Const QueryExpression: String; Operator: TEzGraphicOperator; ClearBefore: Boolean );
Var
  E: TEzEntity;
  WasInit: Boolean;
  DoClearBefore: Boolean;
Begin
  If Sourcelayer = Nil Then
    Exit;
  WasInit := false;
  SourceLayer.First;
  While Not SourceLayer.Eof Do
  Begin
    If SourceLayer.RecIsDeleted Then
    Begin
      SourceLayer.Next;
      Continue;
    End;
    E := SourceLayer.LoadEntityWithRecno( SourceLayer.Recno );
    If E = Nil Then
    Begin
      Sourcelayer.Next;
      Continue;
    End;
    Try
      Try
        If Not ( E.EntityID In [idPolyline,
          idPolygon,
            idArc,
            idEllipse,
            idSpline] ) Then
        Begin
          Sourcelayer.Next;
          Continue;
        End;
        If Not WasInit Then
        Begin
          DoClearBefore := ClearBefore;
          WasInit := true;
        End
        Else
          DoClearBefore := false;
        If E.IsClosed Then
          FGIS.QueryPolygon( E,
            Sourcelayer.Name,
            QueryExpression,
            Operator,
            0,
            FGraphicFilterList,
            DoClearBefore )
        Else
          FGIS.QueryPolyline( E,
            Sourcelayer.Name,
            QueryExpression,
            0,
            FGraphicFilterList,
            DoClearBefore );
      Finally
        E.Free;
      End;
    Finally
      Sourcelayer.Next;
    End;
  End;
  FGraphicFiltered := True;
End;

Procedure TEzTable.AllocateBLOBPointer( Field: TField; Var P: Pointer );
Begin
  // save the source recno in the blob field
  P := Pointer( GetSourceRecNo );
End;

Procedure TEzTable.FreeBLOBPointer( Field: TField; Var P: Pointer );
Begin
  // nothing to do here
End;

Procedure TEzTable.SelectionFilter( Selection: TEzSelection; ClearBefore: Boolean );
Var
  SelIndex: Integer;
  SelLayer: TEzSelectionLayer;
  Layer: TEzBaseLayer;
Begin
  If FGIS = Nil Then Exit;
  Layer:= FGis.Layers.LayerByName( FLayerName );
  if Layer = Nil then Exit;
  SelIndex := Selection.IndexOf( Layer );
  If SelIndex < 0 Then
  begin
    FGraphicFiltered:= true;
    FGraphicFilterList.Clear;
    Exit;
  end;
  SelLayer := Selection[SelIndex];
  If ClearBefore Then
    FGraphicFilterList.Clear;
  FGraphicFilterList.Assign( SelLayer.SelList );
End;

Procedure TEzTable.DoSelect( Selection: TEzSelection );
Var
  I: Integer;
Begin
  If ( FGIS = Nil ) Or ( FLayer = Nil ) Then
    Exit;
  For I := 0 To FRecords.Count - 1 Do
    Selection.Add( Layer, FRecords[I] );
End;

procedure TEzTable.GetBlobField(Field: TField; Stream: TStream);
begin
end;

procedure TEzTable.SetBlobField(Field: TField; Stream: TStream);
begin
end;


{$IFDEF BCB}
function TEzTable.GetGIS: TEzBaseGIS;
begin
  Result := FGis;
end;

function TEzTable.GetLayer: TEzBaseLayer;
begin
  Result := FLayer;
end;

function TEzTable.GetLayerName: String;
begin
  Result := FLayerName;
end;

function TEzTable.GetMapFields: TEzGISFields;
begin
  Result := FMapFields;
end;

function TEzTable.GetMaxRecords: Longint;
begin
  Result := FMaxRecords;
end;

function TEzTable.GetReadOnly: Boolean;
begin
  Result := FReadOnly;
end;

function TEzTable.GetUseDeleted: Boolean;
begin
  Result := FuseDeleted;
end;

procedure TEzTable.SetLayer(const Value: TEzBaseLayer);
begin
  FLayer := Value;
end;

procedure TEzTable.SetMaxRecords(const Value: Longint);
begin
  FMaxRecords := Value;
end;

procedure TEzTable.SetUseDeleted(const Value: Boolean);
begin
  FUseDeleted := Value;
end;
{$ENDIF}

{ TEzDesignTable }

Constructor TEzDesignTable.Create( AOwner: TComponent );
Begin
  Inherited Create( AOwner );
  FNameColumn := TStringList.Create;
  FAliasColumn := TStringList.Create;
  FTypeColumn := TStringList.Create;
  FSizeColumn := TIntegerList.Create;
  FDecColumn := TIntegerList.Create;
  FOrigFieldNoColumn:= TIntegerList.create;
End;

Destructor TEzDesignTable.Destroy;
Begin
  Inherited Destroy;
  FNameColumn.Free;
  FAliasColumn.Free;
  FTypeColumn.Free;
  FSizeColumn.Free;
  FDecColumn.Free;
  FOrigFieldNoColumn.Free;
End;

Procedure TEzDesignTable.AllocateBookMark( RecordID, Bookmark: Pointer );
Begin
  PInteger( Bookmark )^ := Integer( RecordID );
End;

Function TEzDesignTable.AllocateRecordID: Pointer;
Begin
  Result := Pointer( FCurRec );
End;

Function TEzDesignTable.DoBookmarkValid( Bookmark: TBookmark ): boolean;
Begin
  result := ( PInteger( Bookmark )^ > 0 ) And ( PInteger( Bookmark )^ <= FRecordCount );
End;

Function TEzDesignTable.DoCompareBookmarks( Bookmark1, Bookmark2: TBookmark ): Integer;
Var
  b1, b2: integer;
Begin
  b1 := PInteger( Bookmark1 )^;
  b2 := PInteger( Bookmark2 )^;
  If b1 = b2 Then
    Result := 0
  Else If b1 < b2 Then
    Result := -1
  Else
    Result := 1;
End;

Procedure TEzDesignTable.DisposeRecordID( Value: Pointer );
Begin
  // Do nothing, no need to dispose since pointer is just an integer
End;

Procedure TEzDesignTable.DoBeforeSetFieldValue( Inserting: Boolean );
Begin
  If Inserting Then
  Begin
    FNameColumn.Add( 'FIELD1' );
    FAliasColumn.Add( 'FIELD1' );
    FTypeColumn.Add( 'C' );
    FSizeColumn.Add( 10 );
    FDecColumn.Add( 0 );
    FOrigFieldNoColumn.Add( 0 );
    FModified := True;
    FRecordCount := FNameColumn.Count;
    FCurRec := FRecordCount - 1;
  End;
End;

Procedure TEzDesignTable.DoCreateFieldDefs;
Var
  FldDef: TFieldDef;
Begin
  FieldDefs.Clear;
  FldDef := FieldDefs.AddFieldDef;
  FldDef.Name := 'FIELDNAME';
  FldDef.DataType := ftString;
  FldDef.Size := 100;
  FldDef.Required := False;

  FldDef := FieldDefs.AddFieldDef;
  FldDef.Name := 'ALIAS';
  FldDef.DataType := ftString;
  FldDef.Size := 100;
  FldDef.Required := False;

  FldDef := FieldDefs.AddFieldDef;
  FldDef.Name := 'TYPE';
  FldDef.DataType := ftString;
  FldDef.Size := 20;
  FldDef.Required := False;

  FldDef := FieldDefs.AddFieldDef;
  FldDef.Name := 'SIZE';
  FldDef.DataType := ftInteger;
  FldDef.Size := 0;
  FldDef.Required := False;

  FldDef := FieldDefs.AddFieldDef;
  FldDef.Name := 'DEC';
  FldDef.DataType := ftInteger;
  FldDef.Size := 0;
  FldDef.Required := False;

  FldDef := FieldDefs.AddFieldDef;
  FldDef.Name := 'ORIG_FIELDNO';
  FldDef.DataType := ftInteger;
  FldDef.Size := 0;
  FldDef.Required := False;
End;

Procedure TEzDesignTable.DoDeleteRecord;
Begin
  UpdateCursorPos;
  If FRecordCount = 0 Then  Exit;
  FNameColumn.Delete( FCurRec );
  FAliasColumn.Delete( FCurRec );
  FTypeColumn.Delete( FCurRec );
  FSizeColumn.Delete( FCurRec );
  FDecColumn.Delete( FCurRec );
  FOrigFieldNoColumn.Delete( FCurRec );
  FRecordCount := FNameColumn.Count;
  If FCurRec > FRecordCount - 1 Then
    Dec( FCurRec );
  If ( FCurRec < 0 ) And ( FRecordCount > 0 ) Then
    FCurRec := 0;
  FModified := true;
End;

Procedure TEzDesignTable.DoFirst;
Begin
  FCurRec := -1;
End;

Procedure TEzDesignTable.DoGotoBookmark( Bookmark: Pointer );
Begin
  GotoRecordID( Pointer( PInteger( Bookmark )^ ) );
End;

Procedure TEzDesignTable.DoLast;
Begin
  FCurRec := FRecordCount;
End;

Function TEzDesignTable.DoOpen: Boolean;
Begin
  FRecordCount := 0;
  FCurRec := -1;
  Result := True;
End;

Procedure TEzDesignTable.DoClose;
Begin
  FNameColumn.Clear;
  FAliasColumn.Clear;
  FTypeColumn.Clear;
  FSizeColumn.Clear;
  FDecColumn.Clear;
  FOrigFieldNoColumn.Clear;
End;

Function TEzDesignTable.GetBookMarkSize: Integer;
Begin
  Result := sizeof( Integer );
End;

Function TEzDesignTable.GetFieldValue( Field: TField ): Variant;
Begin
  If AnsiCompareText( Field.FieldName, 'FIELDNAME' ) = 0 Then
    result := FNameColumn[FCurRec]
  Else If AnsiCompareText( Field.FieldName, 'ALIAS' ) = 0 Then
    result := FAliasColumn[FCurRec]
  Else If AnsiCompareText( Field.FieldName, 'TYPE' ) = 0 Then
    result := FTypeColumn[FCurRec]
  Else If AnsiCompareText( Field.FieldName, 'SIZE' ) = 0 Then
    result := FSizeColumn[FCurRec]
  Else If AnsiCompareText( Field.FieldName, 'DEC' ) = 0 Then
    result := FDecColumn[FCurRec]
  Else If AnsiCompareText( Field.FieldName, 'ORIG_FIELDNO' ) = 0 Then
    result := Integer( FOrigFieldNoColumn[FCurRec] );
End;

Function TEzDesignTable.GetRecNo: Integer;
Begin
  UpdateCursorPos;
  If ( FCurRec = -1 ) And ( FRecordCount > 0 ) Then
    Result := 1
  Else
    Result := FCurRec + 1;
End;

Function TEzDesignTable.GetRecordCount: Integer;
Begin
  CheckActive;
  Result := FRecordCount
End;

Procedure TEzDesignTable.GotoRecordID( Value: Pointer );
Begin
  FCurRec := Integer( Value );
End;

Procedure TEzDesignTable.InternalRefresh;
Begin
  InternalClose;
  InternalOpen;
End;

Function TEzDesignTable.IsSequenced: Boolean;
Begin
  Result := True;
End;

Function TEzDesignTable.Navigate( Buffer: PChar; GetMode: TGetMode;
  doCheck: Boolean ): TGetResult;
Begin
  If FRecordCount < 1 Then
    Result := grEOF
  Else
  Begin
    Result := grOK;
    Case GetMode Of
      gmNext:
        Begin
          If FCurRec >= FRecordCount - 1 Then
            Result := grEOF
          Else
            Inc( FCurRec );
        End;
      gmPrior:
        Begin
          If FCurRec <= 0 Then
          Begin
            Result := grBOF;
            FCurRec := -1;
          End
          Else
            Dec( FCurRec );
        End;
      gmCurrent:
        If ( FCurRec < 0 ) Or ( FCurRec >= FRecordCount ) Then
          Result := grError;
    End;
  End;
End;

Procedure TEzDesignTable.SetFieldValue( Field: TField; Const Value: Variant );
Var
  n, v: Integer;
Begin
  If FCurRec < 0 Then
    n := 0
  Else
    n := FCurRec;
  If AnsiCompareText( Field.FieldName, 'FIELDNAME' ) = 0 Then
  Begin
    FNameColumn[n] := Value;
    FAliasColumn[n] := Value;
  End Else If AnsiCompareText( Field.FieldName, 'ALIAS' ) = 0 Then
    FAliasColumn[n] := Value
  Else If AnsiCompareText( Field.FieldName, 'TYPE' ) = 0 Then
    FTypeColumn[n] := Value
  Else If AnsiCompareText( Field.FieldName, 'SIZE' ) = 0 Then
  Begin
    v := Value;
    FSizeColumn[n] := v;
  End
  Else If AnsiCompareText( Field.FieldName, 'DEC' ) = 0 Then
  Begin
    v := Value;
    FDecColumn[n] := v;
  End
  Else If AnsiCompareText( Field.FieldName, 'ORIG_FIELDNO' ) = 0 Then
  Begin
    v := Value;
    FOrigFieldNoColumn[n] := v;
  End;
  FModified := True;
End;

Procedure TEzDesignTable.SetRecNo( Value: Integer );
Begin
  If ( Value > 0 ) And ( Value <= FRecordCount ) Then
  Begin
    FCurRec := Value - 1;
    Resync( [] );
    doAfterScroll;
  End;
End;

Function TEzDesignTable.GetCanModify: Boolean;
Begin
  result := true;
End;

procedure TEzDesignTable.DoAfterGetFieldValue;
begin
end;

procedure TEzDesignTable.DoAfterSetFieldValue(Inserting: Boolean);
begin
end;

procedure TEzDesignTable.DoBeforeGetFieldValue;
begin
end;

procedure TEzDesignTable.GetBlobField(Field: TField; Stream: TStream);
begin
end;

procedure TEzDesignTable.SetBlobField(Field: TField; Stream: TStream);
begin
end;

End.
