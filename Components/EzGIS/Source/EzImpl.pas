Unit EZIMPL;

{***********************************************************}
{     EzGIS/CAD Components                                  }
{   (c) 2002 EzSoft Engineering                             }
{         All Rights Reserved                               }
{***********************************************************}

{$I EZ_FLAG.PAS}

{ MAIN database library - used in GIS layers with an attached database file
  This referes to property TEzBaseLayer.DBTable

  IMPORTANT !: Only ONE of the following consecutive options must be active
}
{$DEFINE NATIVEDB}          // uncomment for using native DBF tables
{.$DEFINE DATASET_PROVIDER} // uncomment for using component TEzDatasetProvider
{.$DEFINE HALCYONDB}        // uncomment for using Halcyon DBFs
{.$DEFINE BORLAND_BDE}      // uncomment for using BDE DBF TABLES
{.$DEFINE DBISAMDB}         // uncomment for using DBISAM

{$IFDEF NATIVEDB}
{.$DEFINE NATIVEDLL}   // uncomment if you want to use our DLL for reading DBF files
                      // otherwise, you will use dbf.pas freeware utility
{$ENDIF}

{.$DEFINE GIFIMAGE_ON}{ uncomment to add support for Gif images
                        We use TGifImage with permission from Anders Melander,
                        latest version you can find on:
                        http://www.melander.dk/delphi/gifimage/ }
Interface

Uses
  SysUtils, Windows, Classes, Graphics, ezbase, EzBaseGIS ;


  Function CreateAndOpenTable( GIS: TEzBaseGIS; const FileName: string;
    ReadWrite, Shared: Boolean ): TEzBaseTable;
  Function CreateTable( GIS: TEzBaseGIS ): TEzBaseTable;
  Function GetDesktopBaseTableClass: TEzBaseTableClass;


// don't move this

{$IFDEF ISACTIVEX}
{.$DEFINE HALCYONDB}
{.$UNDEF NATIVEDB}
{.$UNDEF DBISAMDB}
{$ENDIF}

Implementation

Uses
  Forms, EzEntities, Db, EzSystem, EzConsts
{$IFDEF NATIVEDB}
{$IFNDEF NATIVEDLL}
  , dbf
{$ENDIF}
{$ENDIF}
{$IFDEF GIFIMAGE_ON}
  , GIFImage
{$ENDIF}
{$IFDEF BORLAND_BDE}
  , Bde, DBTables
{$ENDIF}
{$IFDEF DATASET_PROVIDER}
  , ezctrls
{$ENDIF}
{$IFDEF DBISAMDB}
  , DBISAMTb
{$ENDIF}
{$IFDEF HALCYONDB}
  , gs6_shel
{$ENDIF}
  ;


{$IFDEF DATASET_PROVIDER}

//************************ TEzDataSetProvider implementation **********************

Type

  TEzProviderTable = Class( TEzBaseTable )
  Private
    FDataSet: TDataSet;
    FAutoDispose: Boolean;
  Protected
    Function GetActive: boolean; Override;
    Procedure SetActive( Value: boolean ); Override;
    Function GetRecNo: Integer; Override;
    Procedure SetRecNo( Value: Integer ); Override;
  Public
    Constructor Create( Gis: TEzBaseGIS; Const FName: String;
      ReadWrite, Shared: boolean ); Override;
    Destructor Destroy; Override;
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
    Function Find( Const ss: String; IsExact, IsNear: boolean ): boolean; Override;
    Function FloatGet( Const Fieldname: String ): Double; Override;
    Function FloatGetN( FieldNo: Integer ): Double; Override;
    Function IndexCount: integer; Override;
    Function IndexAscending( Value: integer ): boolean; Override;
    Function Index( Const INames, Tag: String ): integer; Override;
    Function IndexCurrent: String; Override;
    Function IndexUnique( Value: integer ): boolean; Override;
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
    Procedure IntegerPut( Const Fieldname: String; Value: Integer ); Override;
    Procedure IntegerPutN( FieldNo: integer; Value: Integer ); Override;
    Procedure Last; Override;
    Procedure LogicPut( Const fieldname: String; value: boolean ); Override;
    Procedure LogicPutN( fieldno: integer; value: boolean ); Override;
    Procedure MemoLoad( Const fieldname: String; Stream: TStream ); Override;
    Procedure MemoLoadN( fieldno: integer; Stream: TStream ); Override;
    Procedure Next; Override;
    Procedure Pack; Override;
    Procedure Post; Override;
    Procedure Prior; Override;
    Procedure Recall; Override;
    Procedure Refresh; Override;
    Procedure Reindex; Override;
    Procedure SetTagTo( Const TName: String ); Override;
    Procedure SetUseDeleted( tf: boolean ); Override;
    Procedure StringPut( Const fieldname, value: String ); Override;
    Procedure StringPutN( fieldno: integer; Const value: String ); Override;
    Procedure Zap; Override;
    { procedures for manipulating databases }
    Function DBCreateTable( Const fname: String;
      AFieldList: TStringList ): boolean; Override;
    function DBTableExists( const TableName: string ): Boolean; Override;
    Function DBDropTable( const TableName: string): Boolean; Override;
    Function DBDropIndex( const TableName: string): Boolean; Override;
    Function DBRenameTable( const Source, Target: string): Boolean; Override;

    Property DataSet: TDataSet read FDataSet Write FDataSet ;
    Property AutoDispose: Boolean read FAutoDispose write FAutoDispose ;
  End;

//************************ TEzDataSetProvider implementation **********************

Function TEzProviderTable.DBRenameTable( const Source, Target: string): Boolean;
begin
  Result:=false;
  if ( Gis is TEzGis ) And Assigned( TEzGis(Gis).Provider.OnRenameTable ) then
  begin
    TEzGis(Gis).Provider.OnRenameTable( TEzGis(Gis).Provider, Source, Target );
    Result:=true;
  end;
end;

Function TEzProviderTable.DBDropIndex( const TableName: string): Boolean;
begin
  Result:=false;
  if ( Gis is TEzGis ) And Assigned( TEzGis(Gis).Provider.OnDropIndexFile ) then
  begin
    TEzGis(Gis).Provider.OnDropIndexFile( TEzGis(Gis).Provider, TableName );
    Result:=true;
  end;
end;

Function TEzProviderTable.DBDropTable( const TableName: string): Boolean;
begin
  Result:= False;
  if ( Gis is TEzGis ) And Assigned( TEzGis(Gis).Provider.OnDropTable ) then
  begin
    TEzGis(Gis).Provider.OnDropTable( TEzGis(Gis).Provider, TableName );
    Result:= True;
  end;
end;

function TEzProviderTable.DBTableExists( const TableName: string ): Boolean;
begin
  Result:=False;
  if ( Gis is TEzGis ) And Assigned( TEzGis(Gis).Provider.OnQueryTableExists ) then
    TEzGis(Gis).Provider.OnQueryTableExists( TEzGis(Gis).Provider, TableName, Result );
end;

Function TEzProviderTable.DBCreateTable( Const fname: String;
  AFieldList: TStringList ): boolean;
Begin
  Result:=False;
  if ( Gis is TEzGis ) And Assigned( TEzGis(Gis).Provider.OnCreateTable ) then
  begin
    TEzGis(Gis).Provider.OnCreateTable( TEzGis(Gis).Provider, fname, AFieldList );
    Result:=true;
  end;
End;

Constructor TEzProviderTable.Create( Gis: TEzBaseGIS; Const FName: String;
  ReadWrite, Shared: boolean );
Begin
  inherited Create( Gis, FName, ReadWrite, Shared );
  with TEzGis(Gis) do
    if Assigned( Provider) and Assigned( Provider.OnOpenTable) then
      Provider.OnOpenTable( Provider, FName, ReadWrite, Shared, FDataSet, FAutoDispose );
End;

Destructor TEzProviderTable.Destroy;
Begin
  if FAutoDispose and ( FDataSet <> Nil ) then
    FDataSet.Free;
  Inherited Destroy;
End;

Function TEzProviderTable.GetActive: boolean;
Begin
  result := FDataSet.Active;
End;

Procedure TEzProviderTable.SetActive( Value: boolean );
Begin
  FDataSet.Active := value;
End;

Function TEzProviderTable.GetRecNo: Integer;
Begin
  with TEzGis(Gis) do
    if Assigned( Provider) and Assigned( Provider.OnGetRecno) then
      Provider.OnGetRecno( Provider, FDataSet, Result );
End;

Procedure TEzProviderTable.SetRecNo( Value: Integer );
Begin
  with TEzGis(Gis) do
    if Assigned( Provider) and Assigned( Provider.OnSetToRecno) then
      Provider.OnSetToRecno( Provider, FDataSet, Value );
End;

Procedure TEzProviderTable.Append( NewRecno: Integer );
Begin
  with TEzGis(Gis) do
    if Assigned( Provider) and Assigned( Provider.OnAppendRecord) then
      Provider.OnAppendRecord( Provider, FDataSet, NewRecno );
End;

Function TEzProviderTable.BOF: Boolean;
Begin
  result := FDataSet.BOF;
End;

Function TEzProviderTable.EOF: Boolean;
Begin
  Result := FDataSet.EOF;
End;

Function TEzProviderTable.DateGet( Const FieldName: String ): TDateTime;
Begin
  Result := FDataSet.FieldByName( FieldName ).AsDateTime;
End;

Function TEzProviderTable.DateGetN( FieldNo: integer ): TDateTime;
Begin
  Result := FDataSet.Fields[FieldNo - 1].AsdateTime;
End;

Function TEzProviderTable.Deleted: Boolean;
Begin
  with TEzGis(Gis) do
    if Assigned( Provider) and Assigned( Provider.OnGetIsDeleted) then
      Provider.OnGetIsDeleted( Provider, FDataSet, Result );
End;

Function TEzProviderTable.Field( FieldNo: integer ): String;
Begin
  result := FDataSet.Fields[FieldNo - 1].FieldName;
End;

Function TEzProviderTable.FieldCount: integer;
Begin
  result := FDataSet.Fields.Count;
End;

Function TEzProviderTable.FieldDec( FieldNo: integer ): integer;
Var
  Datatype: TFieldType;
Begin
  Datatype := FDataSet.Fields[FieldNo - 1].Datatype;
  If Datatype In ftNonTexttypes Then
    Result := 0
  Else
    Case Datatype Of
      ftstring{$IFDEF LEVEL4}, ftFixedChar,
      ftWidestring{$ENDIF}
{$IFDEF LEVEL5}, ftGUID{$ENDIF}:
        Result := 0;
      ftBCD:
        Result := FDataSet.Fields[FieldNo - 1].Size;
      ftFloat, ftCurrency,
        ftAutoInc, ftSmallInt, ftInteger, ftWord
{$IFNDEF LEVEL3}, ftLargeInt{$ENDIF}:
        Result := 0;
      ftDate, ftTime, ftDateTime:
        Result := 0;
      ftBoolean:
        Result := 0;
    End;
End;

Function TEzProviderTable.FieldGet( Const FieldName: String ): String;
Begin
  result := FDataSet.FieldByName( FieldName ).AsString;
End;

Function TEzProviderTable.FieldGetN( FieldNo: integer ): String;
Begin
  result := FDataSet.Fields[FieldNo - 1].AsString;
End;

Function TEzProviderTable.FieldLen( FieldNo: integer ): integer;
Var
  Datatype: TFieldType;
Begin
  Datatype := FDataSet.Fields[FieldNo - 1].Datatype;
  If Datatype In ftNonTexttypes Then
    Result := 0
  Else
    Case Datatype Of
      ftstring{$IFDEF LEVEL4}, ftFixedChar,
      ftWidestring{$ENDIF}
{$IFDEF LEVEL5}, ftGUID{$ENDIF}:
        Result := FDataSet.Fields[FieldNo - 1].Size;
      ftFloat, ftCurrency, ftBCD,
        ftAutoInc, ftSmallInt, ftInteger, ftWord
{$IFNDEF LEVEL3}, ftLargeInt{$ENDIF}:
        Result := 20;
      ftDate, ftTime, ftDateTime:
        Result := 0;
      ftBoolean:
        Result := 0;
    End;
End;

Function TEzProviderTable.FieldNo( Const FieldName: String ): integer;
Var
  Field: TField;
Begin
  Field := FDataSet.FindField( FieldName );
  If Field = Nil Then
    Result := 0
  Else
    Result := Field.Index + 1;
End;

Function TEzProviderTable.FieldType( FieldNo: integer ): char;
Var
  Datatype: TFieldType;
Begin
  Datatype := FDataSet.Fields[FieldNo - 1].Datatype;
  If Datatype In ftNonTexttypes Then
  Begin
    Case DataType Of
      ftMemo, ftFmtMemo: Result := 'M';
      ftGraphic: Result := 'G';
      ftTypedBinary: Result := 'B';
    End;
  End
  Else
    Case Datatype Of
      ftstring{$IFDEF LEVEL4}, ftFixedChar,
      ftWidestring{$ENDIF}
{$IFDEF LEVEL5}, ftGUID{$ENDIF}:
        Result := 'C';
      ftFloat, ftCurrency, ftBCD,
        ftAutoInc, ftSmallInt, ftInteger, ftWord
{$IFNDEF LEVEL3}, ftLargeInt{$ENDIF}:
        Result := 'N';
      ftDate, ftTime, ftDateTime:
        Result := 'D';
      ftBoolean:
        Result := 'L';
    End;
End;

Function TEzProviderTable.Find( Const ss: String; IsExact, IsNear: boolean ): boolean;
Begin
  // this procedure must be done in database specific methods
End;

Function TEzProviderTable.FloatGet( Const Fieldname: String ): Double;
Begin
  result := FDataSet.FieldByName( FieldName ).Asfloat;
End;

Function TEzProviderTable.FloatGetN( FieldNo: Integer ): Double;
Begin
  result := FDataSet.Fields[FieldNo - 1].Asfloat;
End;

Function TEzProviderTable.IndexCount: integer;
Begin
  // this procedure must be done in database specific methods
End;

Function TEzProviderTable.IndexAscending( Value: integer ): boolean;
Begin
  // this procedure must be done in database specific methods
End;

Function TEzProviderTable.Index( Const INames, Tag: String ): integer;
Begin
  // this procedure must be done in database specific methods
End;

Function TEzProviderTable.IndexCurrent: String;
Begin
  // this procedure must be done in database specific methods
End;

Function TEzProviderTable.IndexUnique( Value: integer ): boolean;
Begin
  // this procedure must be done in database specific methods
End;

Function TEzProviderTable.IndexExpression( Value: integer ): String;
Begin
  // this procedure must be done in database specific methods
End;

Function TEzProviderTable.IndexTagName( Value: integer ): String;
Begin
  // this job must be done in database specific methods
End;

Function TEzProviderTable.IndexFilter( Value: integer ): String;
Begin
  // this job must be done in database specific methods
End;

Function TEzProviderTable.IntegerGet( Const FieldName: String ): Integer;
Begin
  result := FDataSet.FieldByName( Fieldname ).AsInteger;
End;

Function TEzProviderTable.IntegerGetN( FieldNo: integer ): Integer;
Begin
  result := FDataSet.Fields[FieldNo - 1].AsInteger;
End;

Function TEzProviderTable.LogicGet( Const FieldName: String ): Boolean;
Begin
  result := FDataSet.FieldByName( FieldName ).AsBoolean;
End;

Function TEzProviderTable.LogicGetN( FieldNo: integer ): Boolean;
Begin
  result := FDataSet.Fields[FieldNo - 1].AsBoolean;
End;

Procedure TEzProviderTable.MemoSave( Const FieldName: String; Stream: TStream );
Begin
  MemoSaveN( FDataSet.FieldByname( FieldName ).Index + 1, Stream );
End;

Procedure TEzProviderTable.MemoSaveN( FieldNo: integer; Stream: TStream );
Begin
  stream.Position:= 0;
  ( FDataSet.Fields[FieldNo - 1] As TBlobField ).LoadFromStream( stream );
End;

Function TEzProviderTable.MemoSize( Const FieldName: String ): Integer;
Begin
  result := ( FDataSet.FieldByName( FieldName ) As TBlobField ).BlobSize;
End;

Function TEzProviderTable.MemoSizeN( FieldNo: integer ): Integer;
Begin
  result := ( FDataSet.Fields[FieldNo - 1] As TBlobField ).BlobSize;
End;

Function TEzProviderTable.RecordCount: Integer;
Begin
  with TEzGis(Gis) do
    if Assigned( Provider) and Assigned( Provider.OnGetRecordCount) then
      Provider.OnGetRecordCount( Provider, FDataSet, Result );
End;

Function TEzProviderTable.StringGet( Const FieldName: String ): String;
Begin
  result := FDataSet.FieldByname( FieldName ).AsString;
End;

Function TEzProviderTable.StringGetN( FieldNo: integer ): String;
Begin
  result := FDataSet.Fields[FieldNo - 1].AsString;
End;

Procedure TEzProviderTable.DatePut( Const FieldName: String; value: TDateTime );
Begin
  FDataSet.FieldByName( FieldName ).AsDateTime := value;
End;

Procedure TEzProviderTable.DatePutN( FieldNo: integer; value: TDateTime );
Begin
  FDataSet.Fields[FieldNo - 1].AsDateTime := value;
End;

Procedure TEzProviderTable.Delete;
Begin
  with TEzGis(Gis) do
    if Assigned( Provider) and Assigned( Provider.OnDeleteRecord) then
      Provider.OnDeleteRecord( Provider, FDataSet );
End;

Procedure TEzProviderTable.Edit;
Begin
  FDataSet.Edit;
End;

Procedure TEzProviderTable.FieldPut( Const FieldName, Value: String );
Begin
  FDataSet.FieldByName( FieldName ).AsString := Value;
End;

Procedure TEzProviderTable.FieldPutN( FieldNo: integer; Const Value: String );
Begin
  FDataSet.Fields[Fieldno - 1].Asstring := value;
End;

Procedure TEzProviderTable.First;
Begin
  FDataSet.First;
End;

Procedure TEzProviderTable.FloatPut( Const FieldName: String; Const Value: Double );
Begin
  FDataSet.Fieldbyname( Fieldname ).AsFloat := value;
End;

Procedure TEzProviderTable.FloatPutN( FieldNo: integer; Const Value: Double );
Begin
  FDataSet.Fields[FieldNo - 1].AsFloat := value;
End;

Procedure TEzProviderTable.FlushDB;
Begin
  with TEzGis(Gis) do
    if Assigned( Provider) and Assigned( Provider.OnFlushTable) then
      Provider.OnFlushTable( Provider, FDataSet );
End;

Procedure TEzProviderTable.Go( n: Integer );
Begin
  SetRecno( n );
End;

Procedure TEzProviderTable.IndexOn( Const IName, tag, keyexp, forexp: String;
  uniq: TEzIndexUnique; ascnd: TEzSortStatus );
Begin
  // this job must be done in database specific methods
End;

Procedure TEzProviderTable.IntegerPut( Const Fieldname: String; Value: Integer );
Begin
  FDataSet.FieldByname( Fieldname ).Asinteger := value;
End;

Procedure TEzProviderTable.IntegerPutN( FieldNo: integer; Value: Integer );
Begin
  FDataSet.Fields[Fieldno - 1].AsInteger := value;
End;

Procedure TEzProviderTable.Last;
Begin
  FDataSet.Last;
End;

Procedure TEzProviderTable.LogicPut( Const fieldname: String; value: boolean );
Begin
  FDataSet.FieldByname( Fieldname ).asboolean := value;
End;

Procedure TEzProviderTable.LogicPutN( fieldno: integer; value: boolean );
Begin
  FDataSet.fields[fieldno - 1].asboolean := value;
End;

Procedure TEzProviderTable.MemoLoad( Const fieldname: String; Stream: TStream );
Var
  field: TField;
Begin
  field := FDataSet.FindField( Fieldname );
  If field = Nil Then Exit;
  MemoLoadN( field.index + 1, Stream );
End;

Procedure TEzProviderTable.MemoLoadN( fieldno: integer; Stream: TStream );
Begin
  ( FDataSet.Fields[fieldno - 1] As TBlobfield ).SaveToStream( stream );
  stream.seek( 0, 0 );
End;

Procedure TEzProviderTable.Next;
Begin
  FDataSet.Next;
End;

Procedure TEzProviderTable.Pack;
Begin
  with TEzGis(Gis) do
    if Assigned( Provider) and Assigned( Provider.OnPackTable) then
      Provider.OnPackTable( Provider, FDataSet );
End;

Procedure TEzProviderTable.Post;
Begin
  FDataSet.Post;
End;

Procedure TEzProviderTable.Prior;
Begin
  FDataSet.Prior;
End;

Procedure TEzProviderTable.Recall;
Begin
  with TEzGis(Gis) do
    if Assigned( Provider) and Assigned( Provider.OnRecallRecord) then
      Provider.OnRecallRecord( Provider, FDataSet );
End;

Procedure TEzProviderTable.Refresh;
Begin
  FDataSet.Refresh;
End;

Procedure TEzProviderTable.Reindex;
Begin
  // this job must be done in database specific methods
End;

Procedure TEzProviderTable.SetTagTo( Const TName: String );
Begin
  // this job must be done in database specific methods
End;

Procedure TEzProviderTable.SetUseDeleted( tf: boolean );
Begin
  with TEzGis(Gis) do
    if Assigned( Provider) and Assigned( Provider.OnSetUseDeleted) then
      Provider.OnSetUseDeleted( Provider, FDataSet, tf );
End;

Procedure TEzProviderTable.StringPut( Const fieldname, value: String );
Begin
  FDataSet.FieldByname( fieldname ).Asstring := value;
End;

Procedure TEzProviderTable.StringPutN( fieldno: integer; Const value: String );
Begin
  FDataSet.Fields[Fieldno - 1].Asstring := value;
End;

Procedure TEzProviderTable.Zap;
Begin
  with TEzGis(Gis) do
    if Assigned( Provider) and Assigned( Provider.OnZapTable) then
      Provider.OnZapTable( Provider, FDataSet );
End;

{$ENDIF}



{$IFDEF BORLAND_BDE}


//************************ BORLAND BDE database implementation **********************

Type

  TEzBDETable = Class( TEzBaseTable )
  Private
    FTable: TTable;
  Protected
    Function GetActive: boolean; Override;
    Procedure SetActive( Value: boolean ); Override;
    Function GetRecNo: Integer; Override;
    Procedure SetRecNo( Value: Integer ); Override;
  Public
    Constructor Create( Gis: TEzBaseGIS; Const FName: String;
      ReadWrite, Shared: boolean ); Override;
    Destructor Destroy; Override;
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
    Function Find( Const ss: String; IsExact, IsNear: boolean ): boolean; Override;
    Function FloatGet( Const Fieldname: String ): Double; Override;
    Function FloatGetN( FieldNo: Integer ): Double; Override;
    Function IndexCount: integer; Override;
    Function IndexAscending( Value: integer ): boolean; Override;
    Function Index( Const INames, Tag: String ): integer; Override;
    Function IndexCurrent: String; Override;
    Function IndexUnique( Value: integer ): boolean; Override;
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
    //Procedure CopyStructure( Const FileName, APassword: String ); Override;
    //Procedure CopyTo( Const FileName, APassword: String ); Override;
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
    Procedure IntegerPut( Const Fieldname: String; Value: Integer ); Override;
    Procedure IntegerPutN( FieldNo: integer; Value: Integer ); Override;
    Procedure Last; Override;
    Procedure LogicPut( Const fieldname: String; value: boolean ); Override;
    Procedure LogicPutN( fieldno: integer; value: boolean ); Override;
    Procedure MemoLoad( Const fieldname: String; Stream: TStream ); Override;
    Procedure MemoLoadN( fieldno: integer; Stream: TStream ); Override;
    Procedure Next; Override;
    Procedure Pack; Override;
    Procedure Post; Override;
    Procedure Prior; Override;
    Procedure Recall; Override;
    Procedure Refresh; Override;
    Procedure Reindex; Override;
    Procedure SetTagTo( Const TName: String ); Override;
    Procedure SetUseDeleted( tf: boolean ); Override;
    Procedure StringPut( Const fieldname, value: String ); Override;
    Procedure StringPutN( fieldno: integer; Const value: String ); Override;
    Procedure Zap; Override;
    Function DBCreateTable( Const fname: String;
      AFieldList: TStringList ): boolean; Override;
    function DBTableExists( const TableName: string ): Boolean; Override;
    Function DBDropTable( const TableName: string): Boolean; Override;
    Function DBDropIndex( const TableName: string): Boolean; Override;
    Function DBRenameTable( const Source, Target: string): Boolean; Override;
  End;

//************************ BORLAND BDE database implementation **********************

Function TEzBDETable.DBRenameTable( const Source, Target: string): Boolean;
begin
  if FileExists( Source + '.dbf' ) then
    SysUtils.RenameFile( Source + '.dbf', Target + '.dbf');
  if FileExists( Source + '.cdx' ) then
    SysUtils.RenameFile( Source + '.cdx', Target + '.cdx');
  if FileExists( Source + '.fpt' ) then
    SysUtils.RenameFile( Source + '.fpt', Target + '.fpt');
end;

Function TEzBDETable.DBDropIndex( const TableName: string): Boolean;
begin
  //SysUtils.DeleteFile( ChangeFileExt( TableName, '.cdx' ));
end;

Function TEzBDETable.DBDropTable( const TableName: string): Boolean;
begin
  SysUtils.DeleteFile( Tablename + '.dbf' );
  SysUtils.DeleteFile( Tablename + '.cdx' );
  SysUtils.DeleteFile( Tablename + '.fpt' );
end;

function TEzBDETable.DBTableExists( const TableName: string ): Boolean;
begin
  Result:= FileExists( ChangeFileExt( TableName, '.dbf' ) );
end;

Function GetRecordNumber( DataSet: TBDEDataSet ): Integer;
Var
  CursorProps: CurProps;
  RecordProps: RECProps;
Begin
  Result := 0;
  With DataSet Do
  Begin
    If State = dsInactive Then Exit;
    Check( DbiGetCursorProps( Handle, CursorProps ) );
    UpdateCursorPos;
    Check( DbiGetRecord( Handle, dbiNOLOCK, Nil, @RecordProps ) );
    Case CursorProps.iSeqNums Of
      0: Result := RecordProps.iPhyRecNum;
      1: Result := RecordProps.iSeqNum;
    End;
  End;
End;

Procedure SetRecordNumber( DataSet: TBDEDataSet; RecNum: Integer );
Var
  CursorProps: CurProps;
Begin
  With DataSet Do
  Begin
    If State = dsInactive Then Exit;

    Check( DbiGetCursorProps( Handle, CursorProps ) );

    Case CursorProps.iSeqNums Of
      0: Check( DBISetToRecordNo( Handle, RecNum ) );
      1: Check( DBISetToSeqNo( Handle, RecNum ) );
    End;
  End;
  DataSet.ReSync( [] );
End;

Function TEzBDETable.DBCreateTable( Const fname: String;
  AFieldList: TStringList ): boolean;
Var
  s: String;
  v: boolean;
  i: integer;
  p: integer;
  fs: String;
  ft: String[1];
  fl: integer;
  fd: integer;

  Procedure LoadField;
  Begin
    v := true;
    p := Ansipos( ';', s );
    fs := '';
    If p > 0 Then
    Begin
      fs := System.Copy( s, 1, pred( p ) );
      System.Delete( s, 1, p );
    End
    Else
      v := false;

    p := Ansipos( ';', s );
    ft := ' ';
    If p = 2 Then
    Begin
      ft := System.Copy( s, 1, 1 );
      System.Delete( s, 1, p );
    End
    Else
      v := false;

    p := Ansipos( ';', s );
    fl := 0;
    If p > 0 Then
    Begin
      Try
        fl := StrToInt( System.Copy( s, 1, pred( p ) ) );
        System.Delete( s, 1, p );
      Except
        On Exception Do
          v := false;
      End;
    End
    Else
      v := false;

    fd := 0;
    Try
      fd := StrToInt( System.Copy( s, 1, 3 ) );
    Except
      On Exception Do
        v := false;
    End;
  End;

Begin
  { create a dBase table }
  With TTable.Create( Nil ) Do
  Try
    Databasename := ExtractFilePath( fname );
    TableName := ChangeFileExt( ExtractFileName( fname ), '.dbf' );
    With FieldDefs Do
    Begin
      Clear;
      Add( 'UID', ftInteger, 0, False );
      For I := 0 To AFieldList.count - 1 Do
      Begin
        s:= AFieldList[I];
        LoadField;
        If Not v Then
          EzGisError( SErrWrongField );
        if AnsiCompareText(fs, 'UID') = 0 then Continue;
        Case ft[1] Of
          'C':
            Add( fs, ftString, fl, False );
          'F', 'N':
            If fd = 0 Then
              Add( fs, ftInteger, 0, False )
            Else
              Add( fs, ftFloat, 0, False );
          'M':
            Add( fs, ftMemo, 0, False );
          'G':
            Add( fs, ftGraphic, 0, False );
          'B':
            Add( fs, ftTypedBinary, 0, False );
          'L':
            Add( fs, ftBoolean, 0, False );
          'D':
            Add( fs, ftDate, 0, False );
          'T':
            Add( fs, ftTime, 0, False );
          'I':
            Add( fs, ftInteger, 0, False );
        End;
      End;
    End;
    With IndexDefs Do
    Begin
      Clear;
      Add( '', 'UID', [ixPrimary] );
    End;
    If Not Exists Then
      CreateTable;
  Finally
    Free;
  End;
End;

Constructor TEzBDETable.Create( Gis: TEzBaseGIS; Const FName: String;
  ReadWrite, Shared: boolean );
Begin
  Inherited Create( Gis, FName, ReadWrite, Shared );
  FTable := TTable.Create( Nil );
  With FTable Do
  Begin
    DatabaseName := ExtractFilePath( FName );
    TableName := ChangeFileExt( ExtractFileName( FName ), '.dbf' );
    TableType:= ttDBase;
    ReadOnly := Not ReadWrite;
    Exclusive := Not Shared;
    Open;
  End;
End;

Destructor TEzBDETable.Destroy;
Begin
  FTable.Free;
  Inherited Destroy;
End;

Function TEzBDETable.GetActive: boolean;
Begin
  Result := FTable.Active;
End;

Procedure TEzBDETable.SetActive( Value: boolean );
Begin
  FTable.Active := Value;
End;

Function TEzBDETable.GetRecNo: Integer;
Begin
  result := GetRecordNumber( FTable );
End;

Procedure TEzBDETable.SetRecNo( Value: Integer );
Begin
  SetRecordNumber( FTable, Value );
End;

Procedure TEzBDETable.Append( NewRecno: Integer );
Begin
  FTable.Insert;
  FTable.FieldByName( 'UID' ).AsInteger := NewRecno;
  FTable.Post;
End;

Function TEzBDETable.BOF: Boolean;
Begin
  result := FTable.BOF;
End;

Function TEzBDETable.EOF: Boolean;
Begin
  result := FTable.EOF;
End;

Function TEzBDETable.DateGet( Const FieldName: String ): TDateTime;
Begin
  result := FTable.FieldByName( FieldName ).AsDateTime;
End;

Function TEzBDETable.DateGetN( FieldNo: integer ): TDateTime;
Begin
  result := FTable.Fields[FieldNo - 1].AsdateTime;
End;

Function TEzBDETable.Deleted: Boolean;
Begin
  result := False;
End;

Function TEzBDETable.Field( FieldNo: integer ): String;
Begin
  result := FTable.Fields[FieldNo - 1].FieldName;
End;

Function TEzBDETable.FieldCount: integer;
Begin
  result := FTable.Fields.Count;
End;

Function TEzBDETable.FieldDec( FieldNo: integer ): integer;
Var
  Datatype: TFieldType;
Begin
  Datatype := FTable.Fields[FieldNo - 1].Datatype;
  If Datatype In ftNonTexttypes Then
    Result := 0
  Else
    Case Datatype Of
      ftstring{$IFDEF LEVEL4}, ftFixedChar,
      ftWidestring{$ENDIF}
{$IFDEF LEVEL5}, ftGUID{$ENDIF}:
        Result := 0;
      ftBCD:
        Result := FTable.Fields[FieldNo - 1].Size;
      ftFloat, ftCurrency,
        ftAutoInc, ftSmallInt, ftInteger, ftWord
{$IFNDEF LEVEL3}, ftLargeInt{$ENDIF}:
        Result := 0;
      ftDate, ftTime, ftDateTime:
        Result := 0;
      ftBoolean:
        Result := 0;
    End;
End;

Function TEzBDETable.FieldGet( Const FieldName: String ): String;
Begin
  result := FTable.FieldByName( FieldName ).AsString;
End;

Function TEzBDETable.FieldGetN( FieldNo: integer ): String;
Begin
  result := FTable.Fields[FieldNo - 1].AsString;
End;

Function TEzBDETable.FieldLen( FieldNo: integer ): integer;
Var
  Datatype: TFieldType;
Begin
  Datatype := FTable.Fields[FieldNo - 1].Datatype;
  If Datatype In ftNonTexttypes Then
    Result := 0
  Else
    Case Datatype Of
      ftstring{$IFDEF LEVEL4}, ftFixedChar,
      ftWidestring{$ENDIF}
{$IFDEF LEVEL5}, ftGUID{$ENDIF}:
        Result := FTable.Fields[FieldNo - 1].Size;
      ftFloat, ftCurrency, ftBCD,
        ftAutoInc, ftSmallInt, ftInteger, ftWord
{$IFNDEF LEVEL3}, ftLargeInt{$ENDIF}:
        Result := 20;
      ftDate, ftTime, ftDateTime:
        Result := 0;
      ftBoolean:
        Result := 0;
    End;
End;

Function TEzBDETable.FieldNo( Const FieldName: String ): integer;
Var
  Field: TField;
Begin
  Field := FTable.FindField( FieldName );
  If Field = Nil Then
    Result := 0
  Else
    Result := Field.Index + 1;
End;

Function TEzBDETable.FieldType( FieldNo: integer ): char;
Var
  Datatype: TFieldType;
Begin
  Datatype := FTable.Fields[FieldNo - 1].Datatype;
  If Datatype In ftNonTexttypes Then
  Begin
    Case DataType Of
      ftMemo, ftFmtMemo: Result := 'M';
      ftGraphic: Result := 'G';
      ftTypedBinary: Result := 'B';
    End;
  End
  Else
    Case Datatype Of
      ftstring{$IFDEF LEVEL4}, ftFixedChar,
      ftWidestring{$ENDIF}
{$IFDEF LEVEL5}, ftGUID{$ENDIF}:
        Result := 'C';
      ftFloat, ftCurrency, ftBCD,
        ftAutoInc, ftSmallInt, ftInteger, ftWord
{$IFNDEF LEVEL3}, ftLargeInt{$ENDIF}:
        Result := 'N';
      ftDate, ftTime, ftDateTime:
        Result := 'D';
      ftBoolean:
        Result := 'L';
    End;
End;

Function TEzBDETable.Find( Const ss: String; IsExact, IsNear: boolean ): boolean;
Begin
  result := FTable.FindKey( [ss] ); // findkey used for now
End;

Function TEzBDETable.FloatGet( Const Fieldname: String ): Double;
Begin
  result := FTable.FieldByName( FieldName ).Asfloat;
End;

Function TEzBDETable.FloatGetN( FieldNo: Integer ): Double;
Begin
  result := FTable.Fields[FieldNo - 1].Asfloat;
End;

Function TEzBDETable.IndexCount: integer;
Begin
  result := FTable.IndexDefs.Count;
End;

Function TEzBDETable.IndexAscending( Value: integer ): boolean;
Begin
  Result := Not ( ixDescending In FTable.IndexDefs[Value].Options );
End;

Function TEzBDETable.Index( Const INames, Tag: String ): integer;
Begin
  // nothing to do here
End;

Function TEzBDETable.IndexCurrent: String;
Begin
  result := FTable.IndexName;
End;

Function TEzBDETable.IndexUnique( Value: integer ): boolean;
Begin
  Result := ixUnique In FTable.IndexDefs[Value].Options;
End;

Function TEzBDETable.IndexExpression( Value: integer ): String;
Begin
  result := FTable.IndexDefs[Value].FieldExpression;
End;

Function TEzBDETable.IndexTagName( Value: integer ): String;
Begin
  result := FTable.IndexDefs[Value].Name;
End;

Function TEzBDETable.IndexFilter( Value: integer ): String;
Begin
  result := '';
End;

Function TEzBDETable.IntegerGet( Const FieldName: String ): Integer;
Begin
  result := FTable.FieldByName( Fieldname ).AsInteger;
End;

Function TEzBDETable.IntegerGetN( FieldNo: integer ): Integer;
Begin
  result := FTable.Fields[FieldNo - 1].AsInteger;
End;

Function TEzBDETable.LogicGet( Const FieldName: String ): Boolean;
Begin
  result := FTable.FieldByName( FieldName ).AsBoolean;
End;

Function TEzBDETable.LogicGetN( FieldNo: integer ): Boolean;
Begin
  result := FTable.Fields[FieldNo - 1].AsBoolean;
End;

Procedure TEzBDETable.MemoSave( Const FieldName: String; Stream: TStream );
Begin
  MemoSaveN( FTable.FieldByname( FieldName ).Index + 1, Stream );
End;

Procedure TEzBDETable.MemoSaveN( FieldNo: integer; Stream: TStream );
Begin
  stream.Position:= 0;
  ( FTable.Fields[FieldNo - 1] As TBlobField ).LoadFromStream( stream );
End;

Function TEzBDETable.MemoSize( Const FieldName: String ): Integer;
Begin
  result := ( FTable.FieldByName( FieldName ) As TBlobField ).BlobSize;
End;

Function TEzBDETable.MemoSizeN( FieldNo: integer ): Integer;
Begin
  result := ( FTable.Fields[FieldNo - 1] As TBlobField ).BlobSize;
End;

Function TEzBDETable.RecordCount: Integer;
Begin
  result := FTable.RecordCount;
End;

Function TEzBDETable.StringGet( Const FieldName: String ): String;
Begin
  result := FTable.FieldByname( FieldName ).AsString;
End;

Function TEzBDETable.StringGetN( FieldNo: integer ): String;
Begin
  result := FTable.Fields[FieldNo - 1].AsString;
End;

{Procedure TEzBDETable.CopyStructure( Const FileName, APassword: String );
Begin
  // nothing to do
End;

Procedure TEzBDETable.CopyTo( Const FileName, APassword: String );
Begin
  // nothing to do
End; }

Procedure TEzBDETable.DatePut( Const FieldName: String; value: TDateTime );
Begin
  FTable.FieldByName( FieldName ).AsDateTime := value;
End;

Procedure TEzBDETable.DatePutN( FieldNo: integer; value: TDateTime );
Begin
  FTable.Fields[FieldNo - 1].AsDateTime := value;
End;

Procedure TEzBDETable.Delete;
Begin
  FTable.Delete;
End;

Procedure TEzBDETable.Edit;
Begin
  FTable.Edit;
End;

Procedure TEzBDETable.FieldPut( Const FieldName, Value: String );
Begin
  FTable.FieldByName( FieldName ).AsString := Value;
End;

Procedure TEzBDETable.FieldPutN( FieldNo: integer; Const Value: String );
Begin
  FTable.Fields[Fieldno - 1].Asstring := value;
End;

Procedure TEzBDETable.First;
Begin
  FTable.First;
End;

Procedure TEzBDETable.FloatPut( Const FieldName: String; Const Value: Double );
Begin
  FTable.Fieldbyname( Fieldname ).AsFloat := value;
End;

Procedure TEzBDETable.FloatPutN( FieldNo: integer; Const Value: Double );
Begin
  FTable.Fields[FieldNo - 1].AsFloat := value;
End;

Procedure TEzBDETable.FlushDB;
Begin
  //pendiente
End;

Procedure TEzBDETable.Go( n: Integer );
Begin
  SetRecordNumber( FTable, n );
End;

Procedure TEzBDETable.IndexOn( Const IName, tag, keyexp, forexp: String;
  uniq: TEzIndexUnique; ascnd: TEzSortStatus );
Var
  IndexOptions: TIndexOptions;
Begin
  { tag receives the name of the new index
    keyexp is a semi-colon delimited list of fields to index on ex.:
    IndexOn('','FullName','LAST;FIRST','',iuUnique,ssDescending);}
  IndexOptions := [];
  If uniq = iuUnique Then IndexOptions := IndexOptions + [ixUnique];
  If ascnd = ssDescending Then IndexOptions := IndexOptions + [ixDescending];
  FTable.AddIndex( tag, keyexp, IndexOptions );
End;

Procedure TEzBDETable.IntegerPut( Const Fieldname: String; Value: Integer );
Begin
  FTable.FieldByname( Fieldname ).Asinteger := value;
End;

Procedure TEzBDETable.IntegerPutN( FieldNo: integer; Value: Integer );
Begin
  FTable.Fields[Fieldno - 1].AsInteger := value;
End;

Procedure TEzBDETable.Last;
Begin
  FTable.Last;
End;

Procedure TEzBDETable.LogicPut( Const fieldname: String; value: boolean );
Begin
  FTable.FieldByname( Fieldname ).asboolean := value;
End;

Procedure TEzBDETable.LogicPutN( fieldno: integer; value: boolean );
Begin
  FTable.fields[fieldno - 1].asboolean := value;
End;

Procedure TEzBDETable.MemoLoad( Const fieldname: String; Stream: TStream );
Var
  field: TField;
Begin
  field := FTable.FindField( Fieldname );
  If field = Nil Then Exit;
  MemoLoadN( field.index + 1, Stream );
End;

Procedure TEzBDETable.MemoLoadN( fieldno: integer; Stream: TStream );
Begin
  Stream.Position:= 0;
  (FTable.Fields[FieldNo-1] as TBlobField).SaveToStream( Stream );
End;

Procedure TEzBDETable.Next;
Begin
  FTable.Next;
End;

Procedure TEzBDETable.Pack;
var
  OldVal: Boolean;
Begin
  // Ensure table is exclusive
   if not FTable.Active then FTable.Open;
   OldVal:= FTable.Exclusive;
   if not FTable.Exclusive then FTable.Exclusive:= True;

   Check( DbiPackTable( FTable.DBHandle, FTable.Handle, nil, szDBASE, True ) );

   FTable.Exclusive:= OldVal;
End;

Procedure TEzBDETable.Post;
Begin
  FTable.Post;
End;

Procedure TEzBDETable.Prior;
Begin
  FTable.Prior;
End;

Procedure TEzBDETable.Recall;
Begin
  FTable.UpdateCursorPos;
  DbiUndeleteRecord(FTable.Handle);
End;

Procedure TEzBDETable.Refresh;
Begin
  FTable.Refresh;
End;

Procedure TEzBDETable.Reindex;
Begin
  // nothing to do
End;

Procedure TEzBDETable.SetTagTo( Const TName: String );
Begin
  FTable.IndexName := TName;
End;

Procedure TEzBDETable.SetUseDeleted( tf: boolean );
var
  rslt: DBIResult;
  szErrMsg: DBIMSG;
Begin
  try
    FTable.DisableControls;
    try
      rslt := DbiSetProp(hDBIObj(FTable.Handle), curSOFTDELETEON, LongInt(tf));
      if rslt <> DBIERR_NONE then
      begin
        DbiGetErrorString(rslt, szErrMsg);
        raise Exception.Create(StrPas(szErrMsg));
      end;
    except
      on E: EDBEngineError do MessageToUser( E.Message, sMsgError, MB_ICONERROR );
      on E: Exception do MessageToUser( E.Message, sMsgError, MB_ICONERROR );
    end;
  finally
    FTable.Refresh;
    FTable.EnableControls;
  end;
End;

Procedure TEzBDETable.StringPut( Const fieldname, value: String );
Begin
  FTable.FieldByname( fieldname ).Asstring := value;
End;

Procedure TEzBDETable.StringPutN( fieldno: integer; Const value: String );
Begin
  FTable.Fields[Fieldno - 1].Asstring := value;
End;

Procedure TEzBDETable.Zap;
Begin
  FTable.EmptyTable;
End;

{$ENDIF}



{$IFDEF DBISAMDB}

//************************ DBISAM database implementation **********************

Type

  TEzDBISAMTable = Class( TEzBaseTable )
  Private
    FDBISAMTable: TDBISAMTable;
  Protected
    Function GetActive: boolean; Override;
    Procedure SetActive( Value: boolean ); Override;
    Function GetRecNo: Integer; Override;
    Procedure SetRecNo( Value: Integer ); Override;
  Public
    Constructor Create( Gis: TEzBaseGIS; Const FName: String;
      ReadWrite, Shared: boolean ); Override;
    Destructor Destroy; Override;
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
    Function Find( Const ss: String; IsExact, IsNear: boolean ): boolean; Override;
    Function FloatGet( Const Fieldname: String ): Double; Override;
    Function FloatGetN( FieldNo: Integer ): Double; Override;
    Function IndexCount: integer; Override;
    Function IndexAscending( Value: integer ): boolean; Override;
    Function Index( Const INames, Tag: String ): integer; Override;
    Function IndexCurrent: String; Override;
    Function IndexUnique( Value: integer ): boolean; Override;
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
    //Procedure CopyStructure( Const FileName, APassword: String ); Override;
    //Procedure CopyTo( Const FileName, APassword: String ); Override;
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
    Procedure IntegerPut( Const Fieldname: String; Value: Integer ); Override;
    Procedure IntegerPutN( FieldNo: integer; Value: Integer ); Override;
    Procedure Last; Override;
    Procedure LogicPut( Const fieldname: String; value: boolean ); Override;
    Procedure LogicPutN( fieldno: integer; value: boolean ); Override;
    Procedure MemoLoad( Const fieldname: String; Stream: TStream ); Override;
    Procedure MemoLoadN( fieldno: integer; Stream: TStream ); Override;
    Procedure Next; Override;
    Procedure Pack; Override;
    Procedure Post; Override;
    Procedure Prior; Override;
    Procedure Recall; Override;
    Procedure Refresh; Override;
    Procedure Reindex; Override;
    Procedure SetTagTo( Const TName: String ); Override;
    Procedure SetUseDeleted( tf: boolean ); Override;
    Procedure StringPut( Const fieldname, value: String ); Override;
    Procedure StringPutN( fieldno: integer; Const value: String ); Override;
    Procedure Zap; Override;
    Function DBCreateTable( Const fname: String;
      AFieldList: TStringList ): boolean; Override;
    function DBTableExists( const TableName: string ): Boolean; Override;
    Function DBDropTable( const TableName: string): Boolean; Override;
    Function DBDropIndex( const TableName: string): Boolean; Override;
    Function DBRenameTable( const Source, Target: string): Boolean; Override;
  End;

//************************ DBISAM database implementation **********************

Function TEzDBISAMTable.DBRenameTable( const Source, Target: string): Boolean;
begin
  if FileExists( Source + '.dat' ) then
    SysUtils.RenameFile( Source + '.dat', Target + '.dat');
  if FileExists( Source + '.idx' ) then
    SysUtils.RenameFile( Source + '.idx', Target + '.idx');
  if FileExists( Source + '.blb' ) then
    SysUtils.RenameFile( Source + '.blb', Target + '.blb');
end;

Function TEzDBISAMTable.DBDropIndex( const TableName: string): Boolean;
begin
  // not used
end;

Function TEzDBISAMTable.DBDropTable( const TableName: string): Boolean;
begin
  SysUtils.DeleteFile( Tablename + '.dat' );
  SysUtils.DeleteFile( Tablename + '.idx' );
  SysUtils.DeleteFile( Tablename + '.blb' );
end;

function TEzDBISAMTable.DBTableExists( const TableName: string ): Boolean;
begin
  Result:= FileExists( ChangeFileExt( TableName, '.dat' ) );
end;

Function TEzDBISAMTable.DBCreateTable( Const fname: String; AFieldList: TStringList ): boolean;
Var
  s: String;
  v: boolean;
  i: integer;
  p: integer;
  fs: String;
  ft: String[1];
  fl: integer;
  fd: integer;

  Procedure LoadField;
  Begin
    v := true;
    p := Ansipos( ';', s );
    fs := '';
    If p > 0 Then
    Begin
      fs := System.Copy( s, 1, pred( p ) );
      System.Delete( s, 1, p );
    End
    Else
      v := false;

    p := Ansipos( ';', s );
    ft := ' ';
    If p = 2 Then
    Begin
      ft := System.Copy( s, 1, 1 );
      System.Delete( s, 1, p );
    End
    Else
      v := false;

    p := Ansipos( ';', s );
    fl := 0;
    If p > 0 Then
    Begin
      Try
        fl := StrToInt( System.Copy( s, 1, pred( p ) ) );
        System.Delete( s, 1, p );
      Except
        On Exception Do
          v := false;
      End;
    End
    Else
      v := false;

    fd := 0;
    Try
      fd := StrToInt( System.Copy( s, 1, 3 ) );
    Except
      On Exception Do
        v := false;
    End;
  End;

Begin
  { create a DBISAM table (.DAT and .IDX files }
  With TDBISAMTable.Create( Nil ) Do
  Try
    Databasename := ExtractFilePath( fname );
    TableName := ChangeFileExt( ExtractFileName( fname ), '' );
    With FieldDefs Do
    Begin
      Clear;
      Add( 'UID', ftInteger, 0, False );
      Add( 'DELETED', ftBoolean, 0, False );
      For I := 0 To AFieldList.count - 1 Do
      Begin
        s:= AFieldList[I];
        LoadField;
        If Not v Then
          EzGisError( SErrWrongField );
        Case ft[1] Of
          'C':
            Add( fs, ftString, fl, False );
          'F', 'N':
            If fd = 0 Then
              Add( fs, ftInteger, 0, False )
            Else
              Add( fs, ftFloat, 0, False );
          'M':
            Add( fs, ftMemo, 0, False );
          'G':
            Add( fs, ftGraphic, 0, False );
          'B':
            Add( fs, ftTypedBinary, 0, False );
          'L':
            Add( fs, ftBoolean, 0, False );
          'D':
            Add( fs, ftDate, 0, False );
          'T':
            Add( fs, ftTime, 0, False );
          'I':
            Add( fs, ftInteger, 0, False );
        End;
      End;
    End;
    With IndexDefs Do
    Begin
      Clear;
      Add( '', 'UID', [ixPrimary] );
    End;
    If Not Exists Then
      CreateTable;
  Finally
    Free;
  End;
End;

Constructor TEzDBISAMTable.Create( Gis: TEzBaseGIS; Const FName: String;
  ReadWrite, Shared: boolean );
Begin
  inherited Create( Gis, FName, ReadWrite, Shared );
  if Length(FName) > 0 then
  begin
    FDBISAMTable := TDBISAMTable.Create( Nil );
    With FDBISAMTable Do
    Begin
      DatabaseName := ExtractFilePath( FName );
      TableName := ChangeFileExt( ExtractFileName( FName ), '' );
      ReadOnly := Not ReadWrite;
      Exclusive := Not Shared;
      Open;
    End;
  end;
End;

Destructor TEzDBISAMTable.Destroy;
Begin
  FDBISAMTable.Free;
  Inherited Destroy;
End;

Function TEzDBISAMTable.GetActive: boolean;
Begin
  result := FDBISAMTable.Active;
End;

Procedure TEzDBISAMTable.SetActive( Value: boolean );
Begin
  FDBISAMTable.Active := value;
End;

Function TEzDBISAMTable.GetRecNo: Integer;
Begin
  result := FDBISAMTable.FieldByName( 'UID' ).AsInteger;
End;

Procedure TEzDBISAMTable.SetRecNo( Value: Integer );
Begin
  if FDBISAMTable.IndexName <> '' then
  begin
    FDBISAMTable.IndexName := ''; // primary index
    If Not FDBISAMTable.FindKey( [Value] ) Then
      EzGisError( 'Record not found !' );
  end else
  begin
    if FDBISAMTable.FieldByName( 'UID' ).AsInteger <> Value then
    begin
      If Not FDBISAMTable.FindKey( [Value] ) Then
        EzGisError( 'Record not found !' );
    end;
  end;
End;

Procedure TEzDBISAMTable.Append( NewRecno: Integer );
Begin
  FDBISAMTable.Insert;
  FDBISAMTable.FieldByName( 'UID' ).AsInteger := NewRecno;
  FDBISAMTable.Post;
End;

Function TEzDBISAMTable.BOF: Boolean;
Begin
  result := FDBISAMTable.BOF;
End;

Function TEzDBISAMTable.EOF: Boolean;
Begin
  result := FDBISAMTable.EOF;
End;

Function TEzDBISAMTable.DateGet( Const FieldName: String ): TDateTime;
Begin
  result := FDBISAMTable.FieldByName( FieldName ).AsDateTime;
End;

Function TEzDBISAMTable.DateGetN( FieldNo: integer ): TDateTime;
Begin
  result := FDBISAMTable.Fields[FieldNo - 1].AsdateTime;
End;

Function TEzDBISAMTable.Deleted: Boolean;
Begin
  result := False;
End;

Function TEzDBISAMTable.Field( FieldNo: integer ): String;
Begin
  result := FDBISAMTable.Fields[FieldNo - 1].FieldName;
End;

Function TEzDBISAMTable.FieldCount: integer;
Begin
  result := FDBISAMTable.Fields.Count;
End;

Function TEzDBISAMTable.FieldDec( FieldNo: integer ): integer;
Var
  Datatype: TFieldType;
Begin
  Datatype := FDBISAMTable.Fields[FieldNo - 1].Datatype;
  If Datatype In ftNonTexttypes Then
    Result := 0
  Else
    Case Datatype Of
      ftstring{$IFDEF LEVEL4}, ftFixedChar,
      ftWidestring{$ENDIF}
{$IFDEF LEVEL5}, ftGUID{$ENDIF}:
        Result := 0;
      ftBCD:
        Result := FDBISAMTable.Fields[FieldNo - 1].Size;
      ftFloat, ftCurrency,
        ftAutoInc, ftSmallInt, ftInteger, ftWord
{$IFNDEF LEVEL3}, ftLargeInt{$ENDIF}:
        Result := 0;
      ftDate, ftTime, ftDateTime:
        Result := 0;
      ftBoolean:
        Result := 0;
    End;
End;

Function TEzDBISAMTable.FieldGet( Const FieldName: String ): String;
Begin
  result := FDBISAMTable.FieldByName( FieldName ).AsString;
End;

Function TEzDBISAMTable.FieldGetN( FieldNo: integer ): String;
Begin
  result := FDBISAMTable.Fields[FieldNo - 1].AsString;
End;

Function TEzDBISAMTable.FieldLen( FieldNo: integer ): integer;
Var
  Datatype: TFieldType;
Begin
  Datatype := FDBISAMTable.Fields[FieldNo - 1].Datatype;
  If Datatype In ftNonTexttypes Then
    Result := 0
  Else
    Case Datatype Of
      ftstring{$IFDEF LEVEL4}, ftFixedChar,
      ftWidestring{$ENDIF}
{$IFDEF LEVEL5}, ftGUID{$ENDIF}:
        Result := FDBISAMTable.Fields[FieldNo - 1].Size;
      ftFloat, ftCurrency, ftBCD,
        ftAutoInc, ftSmallInt, ftInteger, ftWord
{$IFNDEF LEVEL3}, ftLargeInt{$ENDIF}:
        Result := 20;
      ftDate, ftTime, ftDateTime:
        Result := 0;
      ftBoolean:
        Result := 0;
    End;
End;

Function TEzDBISAMTable.FieldNo( Const FieldName: String ): integer;
Var
  Field: TField;
Begin
  Field := FDBISAMTable.FindField( FieldName );
  If Field = Nil Then
    Result := 0
  Else
    Result := Field.Index + 1;
End;

Function TEzDBISAMTable.FieldType( FieldNo: integer ): char;
Var
  Datatype: TFieldType;
Begin
  Datatype := FDBISAMTable.Fields[FieldNo - 1].Datatype;
  If Datatype In ftNonTexttypes Then
  Begin
    Case DataType Of
      ftMemo, ftFmtMemo: Result := 'M';
      ftGraphic: Result := 'G';
      ftTypedBinary: Result := 'B';
    End;
  End
  Else
    Case Datatype Of
      ftstring{$IFDEF LEVEL4}, ftFixedChar,
      ftWidestring{$ENDIF}
{$IFDEF LEVEL5}, ftGUID{$ENDIF}:
        Result := 'C';
      ftFloat, ftCurrency, ftBCD,
        ftAutoInc, ftSmallInt, ftInteger, ftWord
{$IFNDEF LEVEL3}, ftLargeInt{$ENDIF}:
        Result := 'N';
      ftDate, ftTime, ftDateTime:
        Result := 'D';
      ftBoolean:
        Result := 'L';
    End;
End;

Function TEzDBISAMTable.Find( Const ss: String; IsExact, IsNear: boolean ): boolean;
Begin
  result := FDBISAMTable.FindKey( [ss] ); // findkey used for now
End;

Function TEzDBISAMTable.FloatGet( Const Fieldname: String ): Double;
Begin
  result := FDBISAMTable.FieldByName( FieldName ).Asfloat;
End;

Function TEzDBISAMTable.FloatGetN( FieldNo: Integer ): Double;
Begin
  result := FDBISAMTable.Fields[FieldNo - 1].Asfloat;
End;

Function TEzDBISAMTable.IndexCount: integer;
Begin
  result := FDBISAMTable.IndexDefs.Count;
End;

Function TEzDBISAMTable.IndexAscending( Value: integer ): boolean;
Begin
  Result := Not ( ixDescending In FDBISAMTable.IndexDefs[Value].Options );
End;

Function TEzDBISAMTable.Index( Const INames, Tag: String ): integer;
Begin
  // nothing to do here
End;

Function TEzDBISAMTable.IndexCurrent: String;
Begin
  result := FDBISAMTable.IndexName;
End;

Function TEzDBISAMTable.IndexUnique( Value: integer ): boolean;
Begin
  Result := ixUnique In FDBISAMTable.IndexDefs[Value].Options;
End;

Function TEzDBISAMTable.IndexExpression( Value: integer ): String;
Begin
  result := FDBISAMTable.IndexDefs[Value].FieldExpression;
End;

Function TEzDBISAMTable.IndexTagName( Value: integer ): String;
Begin
  result := FDBISAMTable.IndexDefs[Value].Name;
End;

Function TEzDBISAMTable.IndexFilter( Value: integer ): String;
Begin
  result := '';
End;

Function TEzDBISAMTable.IntegerGet( Const FieldName: String ): Integer;
Begin
  result := FDBISAMTable.FieldByName( Fieldname ).AsInteger;
End;

Function TEzDBISAMTable.IntegerGetN( FieldNo: integer ): Integer;
Begin
  result := FDBISAMTable.Fields[FieldNo - 1].AsInteger;
End;

Function TEzDBISAMTable.LogicGet( Const FieldName: String ): Boolean;
Begin
  result := FDBISAMTable.FieldByName( FieldName ).AsBoolean;
End;

Function TEzDBISAMTable.LogicGetN( FieldNo: integer ): Boolean;
Begin
  result := FDBISAMTable.Fields[FieldNo - 1].AsBoolean;
End;

Procedure TEzDBISAMTable.MemoSave( Const FieldName: String; Stream: TStream );
Begin
  MemoSaveN( FDBISAMTable.FieldByname( FieldName ).Index + 1, Stream );
End;

Procedure TEzDBISAMTable.MemoSaveN( FieldNo: integer; Stream: TStream );
Begin
  stream.Position:= 0;
  ( FDBISAMTable.Fields[FieldNo - 1] As TBlobField ).LoadFromStream( stream );
End;

Function TEzDBISAMTable.MemoSize( Const FieldName: String ): Integer;
Begin
  result := ( FDBISAMTable.FieldByName( FieldName ) As TBlobField ).BlobSize;
End;

Function TEzDBISAMTable.MemoSizeN( FieldNo: integer ): Integer;
Begin
  result := ( FDBISAMTable.Fields[FieldNo - 1] As TBlobField ).BlobSize;
End;

Function TEzDBISAMTable.RecordCount: Integer;
Begin
  result := FDBISAMTable.PhysicalRecordCount;
End;

Function TEzDBISAMTable.StringGet( Const FieldName: String ): String;
Begin
  result := FDBISAMTable.FieldByname( FieldName ).AsString;
End;

Function TEzDBISAMTable.StringGetN( FieldNo: integer ): String;
Begin
  result := FDBISAMTable.Fields[FieldNo - 1].AsString;
End;

{Procedure TEzDBISAMTable.CopyStructure( Const FileName, APassword: String );
Begin
  // nothing to do
End;

Procedure TEzDBISAMTable.CopyTo( Const FileName, APassword: String );
Begin
  // nothing to do
End; }

Procedure TEzDBISAMTable.DatePut( Const FieldName: String; value: TDateTime );
Begin
  FDBISAMTable.FieldByName( FieldName ).AsDateTime := value;
End;

Procedure TEzDBISAMTable.DatePutN( FieldNo: integer; value: TDateTime );
Begin
  FDBISAMTable.Fields[FieldNo - 1].AsDateTime := value;
End;

Procedure TEzDBISAMTable.Delete;
Begin
  // only mark as deleted
  FDBISAMTable.Edit;
  FDBISAMTable.FieldByName( 'DELETED' ).AsBoolean := True;
  FDBISAMTable.Post;
End;

Procedure TEzDBISAMTable.Edit;
Begin
  FDBISAMTable.Edit;
End;

Procedure TEzDBISAMTable.FieldPut( Const FieldName, Value: String );
Begin
  FDBISAMTable.FieldByName( FieldName ).AsString := Value;
End;

Procedure TEzDBISAMTable.FieldPutN( FieldNo: integer; Const Value: String );
Begin
  FDBISAMTable.Fields[Fieldno - 1].Asstring := value;
End;

Procedure TEzDBISAMTable.First;
Begin
  FDBISAMTable.First;
End;

Procedure TEzDBISAMTable.FloatPut( Const FieldName: String; Const Value: Double );
Begin
  FDBISAMTable.Fieldbyname( Fieldname ).AsFloat := value;
End;

Procedure TEzDBISAMTable.FloatPutN( FieldNo: integer; Const Value: Double );
Begin
  FDBISAMTable.Fields[FieldNo - 1].AsFloat := value;
End;

Procedure TEzDBISAMTable.FlushDB;
Begin
  FDBISAMTable.FlushBuffers;
End;

Procedure TEzDBISAMTable.Go( n: Integer );
Begin
  FDBISAMTable.IndexName := '';
  If Not FDBISAMTable.FindKey( [n] ) Then
    EzGisError( 'Record not found !' );
End;

Procedure TEzDBISAMTable.IndexOn( Const IName, tag, keyexp, forexp: String;
  uniq: TEzIndexUnique; ascnd: TEzSortStatus );
Var
  IndexOptions: TIndexOptions;
Begin
  { tag receives the name of the new index
    keyexp is a semi-colon delimited list of fields to index on
    ex.:
    IndexOn('','FullName','LAST;FIRST','',iuUnique,ssDescending);}
  IndexOptions := [];
  If uniq = iuUnique Then
    IndexOptions := IndexOptions + [ixUnique];
  If ascnd = ssDescending Then
    IndexOptions := IndexOptions + [ixDescending];
  FDBISAMTable.AddIndex( tag, keyexp, IndexOptions );
End;

Procedure TEzDBISAMTable.IntegerPut( Const Fieldname: String; Value: Integer );
Begin
  FDBISAMTable.FieldByname( Fieldname ).Asinteger := value;
End;

Procedure TEzDBISAMTable.IntegerPutN( FieldNo: integer; Value: Integer );
Begin
  FDBISAMTable.Fields[Fieldno - 1].AsInteger := value;
End;

Procedure TEzDBISAMTable.Last;
Begin
  FDBISAMTable.Last;
End;

Procedure TEzDBISAMTable.LogicPut( Const fieldname: String; value: boolean );
Begin
  FDBISAMTable.FieldByname( Fieldname ).asboolean := value;
End;

Procedure TEzDBISAMTable.LogicPutN( fieldno: integer; value: boolean );
Begin
  FDBISAMTable.fields[fieldno - 1].asboolean := value;
End;

Procedure TEzDBISAMTable.MemoLoad( Const fieldname: String; Stream: TStream );
Var
  field: TField;
Begin
  field := FDBISAMTable.FindField( Fieldname );
  If field = Nil Then Exit;
  MemoLoadN( field.index + 1, Stream );
End;

Procedure TEzDBISAMTable.MemoLoadN( fieldno: integer; Stream: TStream );
Begin
  ( FDBISAMTable.Fields[fieldno - 1] As TBlobfield ).SaveToStream( stream );
  stream.seek( 0, 0 );
End;

Procedure TEzDBISAMTable.Next;
Begin
  FDBISAMTable.Next;
End;

Procedure TEzDBISAMTable.Pack;
Begin
  FDBISAMTable.First;
  While Not FDBISAMTable.Eof Do
  Begin
    If FDBISAMTable.FieldByName( 'DELETED' ).AsBoolean Then
      FDBISAMTable.Delete
    Else
      FDBISAMTable.Next;
  End;
End;

Procedure TEzDBISAMTable.Post;
Begin
  FDBISAMTable.Post;
End;

Procedure TEzDBISAMTable.Prior;
Begin
  FDBISAMTable.Prior;
End;

Procedure TEzDBISAMTable.Recall;
Begin
  If FDBISAMTable.FieldByname( 'DELETED' ).AsBoolean Then
  Begin
    FDBISAMTable.Edit;
    FDBISAMTable.FieldByname( 'DELETED' ).AsBoolean := False;
    FDBISAMTable.Post;
  End;
End;

Procedure TEzDBISAMTable.Refresh;
Begin
  FDBISAMTable.Refresh;
End;

Procedure TEzDBISAMTable.Reindex;
Begin
  // nothing to do
End;

Procedure TEzDBISAMTable.SetTagTo( Const TName: String );
Begin
  FDBISAMTable.IndexName := TName;
End;

Procedure TEzDBISAMTable.SetUseDeleted( tf: boolean );
Begin
  // nothing to do
End;

Procedure TEzDBISAMTable.StringPut( Const fieldname, value: String );
Begin
  FDBISAMTable.FieldByname( fieldname ).Asstring := value;
End;

Procedure TEzDBISAMTable.StringPutN( fieldno: integer; Const value: String );
Begin
  FDBISAMTable.Fields[Fieldno - 1].Asstring := value;
End;

Procedure TEzDBISAMTable.Zap;
Begin
  FDBISAMTable.EmptyTable;
End;

{$ENDIF}


{$IFDEF HALCYONDB}

//************************ Using Halcyon tables **********************

Type

  TEzHalcyonTable = Class( TEzBaseTable )
  Private
    FgsDbfTable: TgsDBFTable;
  Protected
    Function GetActive: boolean; Override;
    Procedure SetActive( Value: boolean ); Override;
    Function GetRecNo: Integer; Override;
    Procedure SetRecNo( Value: Integer ); Override;
  Public
    Constructor Create( Gis: TEzBaseGIS; Const FName: String;
      ReadWrite, Shared: boolean ); Override;
    Destructor Destroy; Override;
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
    Function Find( Const ss: String; IsExact, IsNear: boolean ): boolean; Override;
    Function FloatGet( Const FieldName: String ): Double; Override;
    Function FloatGetN( FieldNo: Integer ): Double; Override;
    Function IndexCount: integer; Override;
    Function IndexAscending( Value: integer ): boolean; Override;
    Function Index( Const INames, Tag: String ): integer; Override;
    Function IndexCurrent: String; Override;
    Function IndexUnique( Value: integer ): boolean; Override;
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
    //Procedure CopyStructure( Const FileName, APassword: String ); Override;
    //Procedure CopyTo( Const FileName, APassword: String ); Override;
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
      uniq: TezIndexUnique; ascnd: TEzSortStatus ); Override;
    Procedure IntegerPut( Const FieldName: String; Value: Integer ); Override;
    Procedure IntegerPutN( FieldNo: integer; Value: Integer ); Override;
    Procedure Last; Override;
    Procedure LogicPut( Const FieldName: String; value: boolean ); Override;
    Procedure LogicPutN( fieldno: integer; value: boolean ); Override;
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
    Procedure SetUseDeleted( tf: boolean ); Override;
    Procedure StringPut( Const FieldName, value: String ); Override;
    Procedure StringPutN( fieldno: integer; Const value: String ); Override;
    Procedure Zap; Override;
    Function DBCreateTable( Const fname: String;
      AFieldList: TStringList ): boolean; Override;
    function DBTableExists( const TableName: string ): Boolean; Override;
    Function DBDropTable( const TableName: string): Boolean; Override;
    Function DBDropIndex( const TableName: string): Boolean; Override;
    Function DBRenameTable( const Source, Target: string): Boolean; Override;
  End;

//************************ Using Halcyon tables **********************

Function TEzHalcyonTable.DBRenameTable( const Source, Target: string): Boolean;
begin
  if FileExists( Source + '.dbf' ) then
    SysUtils.RenameFile( Source + '.dbf', Target + '.dbf');
  if FileExists( Source + '.cdx' ) then
    SysUtils.RenameFile( Source + '.cdx', Target + '.cdx');
  if FileExists( Source + '.fpt' ) then
    SysUtils.RenameFile( Source + '.fpt', Target + '.fpt');
end;

Function TEzHalcyonTable.DBDropIndex( const TableName: string): Boolean;
begin
  SysUtils.DeleteFile( ChangeFileExt( TableName, '.cdx' ));
end;

Function TEzHalcyonTable.DBDropTable( const TableName: string): Boolean;
begin
  SysUtils.DeleteFile( Tablename + '.dbf' );
  SysUtils.DeleteFile( Tablename + '.cdx' );
  SysUtils.DeleteFile( Tablename + '.fpt' );
end;

function TEzHalcyonTable.DBTableExists( const TableName: string ): Boolean;
begin
  Result:= FileExists( ChangeFileExt( TableName, '.dbf') );
end;

Function TEzHalcyonTable.DBCreateTable( Const fname: String; AFieldList: TStringList ): boolean;
Begin
  result := gs6_shel.CreateDBF( ChangeFileExt(fname,'.dbf'), '',
                                gs6_shel.FoxPro2, AFieldList );
End;

Constructor TEzHalcyonTable.Create( Gis: TEzBaseGIS; Const FName: String;
  ReadWrite, Shared: boolean );
Begin
  inherited Create( Gis, fname, ReadWrite, Shared );
  FgsDbfTable := TgsDBFTable.Create( ChangeFileExt(fname,'.dbf'), '', ReadWrite, Shared );
End;

Destructor TEzHalcyonTable.Destroy;
Begin
  FgsDbfTable.Free;
  Inherited Destroy;
End;

Function TEzHalcyonTable.GetActive: boolean;
Begin
  result := FgsDbfTable.Active;
End;

Procedure TEzHalcyonTable.SetActive( Value: boolean );
Begin
  FgsDbfTable.Active := value;
End;

Function TEzHalcyonTable.GetRecNo: Integer;
Begin
  result := FgsDbfTable.Recno;
End;

Procedure TEzHalcyonTable.SetRecNo( Value: Integer );
Begin
  FgsDbfTable.Recno := Value;
End;

Procedure TEzHalcyonTable.Append( NewRecno: Integer );
var
  FieldNo: Integer;
Begin
  FieldNo:= FgsDbfTable.FieldNo('UID');
  FgsDbfTable.Append;
  if FieldNo > 0 then
    FgsDbfTable.IntegerPutN( FieldNo, NewRecno );
  FgsDbfTable.Post;
End;

Function TEzHalcyonTable.BOF: Boolean;
Begin
  result := FgsDbfTable.BOF;
End;

Function TEzHalcyonTable.EOF: Boolean;
Begin
  result := FgsDbfTable.EOF;
End;

Function TEzHalcyonTable.DateGet( Const FieldName: String ): TDateTime;
var
  Index: Integer;
Begin
  Result:= 0;
  Index:= FieldNo(FieldName);
  if Index > 0 then
    Result:= DateGetN(Index);
End;

Function TEzHalcyonTable.DateGetN( FieldNo: integer ): TDateTime;
var
  s: string;
  yy,mm,dd: word;
Begin
  s := TrimRight(FgsDbfTable.FieldGetN(FieldNo));
  Result := 0;
  if (length(s) = 8) and (s <> '00000000') then
  try
     yy := StrToInt(system.copy(s,1,4));
     mm := StrToInt(system.Copy(s,5,2));
     dd := StrToInt(system.Copy(s,7,2));
     Result := EncodeDate(yy,mm,dd);
  except
  end;
End;

Function TEzHalcyonTable.Deleted: Boolean;
Begin
  result := FgsDbfTable.Deleted;
End;

Function TEzHalcyonTable.Field( FieldNo: integer ): String;
Begin
  result := FgsDbfTable.Field( FieldNo );
End;

Function TEzHalcyonTable.FieldCount: integer;
Begin
  result := FgsDbfTable.FieldCount;
End;

Function TEzHalcyonTable.FieldDec( FieldNo: integer ): integer;
Begin
  result := FgsDbfTable.FieldDec( FieldNO );
End;

Function TEzHalcyonTable.FieldGet( Const FieldName: String ): String;
Begin
  result := FgsDbfTable.FieldGet( FieldName );
End;

Function TEzHalcyonTable.FieldGetN( FieldNo: integer ): String;
Begin
  result := FgsDbfTable.FieldGetN( FieldNo );
End;

Function TEzHalcyonTable.FieldLen( FieldNo: integer ): integer;
Begin
  result := FgsDbfTable.FieldLen( FieldNO );
End;

Function TEzHalcyonTable.FieldNo( Const FieldName: String ): integer;
Begin
  result := FgsDbfTable.FieldNo( FieldName );
End;

Function TEzHalcyonTable.FieldType( FieldNo: integer ): char;
Begin
  result := FgsDbfTable.FieldType( FieldNo );
End;

Function TEzHalcyonTable.Find( Const ss: String; IsExact, IsNear: boolean ):
  boolean;
Begin
  result := FgsDbfTable.Find( ss, IsExact, Isnear );
End;

Function TEzHalcyonTable.FloatGet( Const FieldName: String ): Double;
Begin
  result := FgsDbfTable.FloatGet( FieldName );
End;

Function TEzHalcyonTable.FloatGetN( FieldNo: Integer ): Double;
Begin
  result := FgsDbfTable.FloatGetN( FieldNo );
End;

Function TEzHalcyonTable.IndexCount: integer;
Begin
  result := FgsDbfTable.IndexCount;
End;

Function TEzHalcyonTable.IndexAscending( Value: integer ): boolean;
Begin
  result := FgsDbfTable.IndexAscending( Value );
End;

Function TEzHalcyonTable.Index( Const INames, Tag: String ): integer;
Begin
  if FileExists( INames + '.cdx' ) then
    result := FgsDbfTable.Index( INames + '.cdx', Tag );
End;

Function TEzHalcyonTable.IndexCurrent: String;
Begin
  Result := FgsDbfTable.IndexCurrent;
End;

Function TEzHalcyonTable.IndexUnique( Value: integer ): boolean;
Begin
  Result := FgsDbfTable.IndexUnique( Value );
End;

Function TEzHalcyonTable.IndexExpression( Value: integer ): String;
Begin
  Result := FgsDbfTable.IndexExpression( Value );
End;

Function TEzHalcyonTable.IndexTagName( Value: integer ): String;
Begin
  Result := FgsDbfTable.IndexTagName( Value );
End;

Function TEzHalcyonTable.IndexFilter( Value: integer ): String;
Begin
  Result := FgsDbfTable.IndexFilter( Value );
End;

Function TEzHalcyonTable.IntegerGet( Const FieldName: String ): Integer;
Begin
  Result := FgsDbfTable.Integerget( FieldName );
End;

Function TEzHalcyonTable.IntegerGetN( FieldNo: integer ): Integer;
Begin
  result := FgsDbfTable.IntegergetN( FieldNo );
End;

Function TEzHalcyonTable.LogicGet( Const FieldName: String ): Boolean;
Begin
  result := FgsDbfTable.LogicGet( FieldName );
End;

Function TEzHalcyonTable.LogicGetN( FieldNo: integer ): Boolean;
Begin
  result := FgsDbfTable.LogicgetN( FieldNo );
End;

Procedure TEzHalcyonTable.MemoSave( Const FieldName: String; Stream: TStream );
Begin
  MemoSaveN( FgsDbfTable.FieldNo( FieldName ), stream );
End;

Procedure TEzHalcyonTable.MemoSaveN( FieldNo: integer; Stream: TStream );
Var
  BlobLen: Integer;
  Memory: PChar;
Begin
  BlobLen := Stream.Size;
  GetMem( Memory, BlobLen + 1 );
  try
    Memory[BlobLen] := #0;
    Stream.Read( Memory[0], BlobLen );
    FgsDbfTable.MemoSaveN( FieldNo, Memory, BlobLen );
  Finally
    FreeMem( Memory, BlobLen + 1 );
  End;
End;

Function TEzHalcyonTable.MemoSize( Const FieldName: String ): Integer;
Begin
  result := FgsDbfTable.MemoSize( FieldName );
End;

Function TEzHalcyonTable.MemoSizeN( FieldNo: integer ): Integer;
Begin
  result := FgsDbfTable.MemoSizeN( FieldNo );
End;

Function TEzHalcyonTable.RecordCount: Integer;
Begin
  result := FgsDbfTable.RecordCount;
End;

Function TEzHalcyonTable.StringGet( Const FieldName: String ): String;
Begin
  result := FgsDbfTable.StringGet( FieldName );
End;

Function TEzHalcyonTable.StringGetN( FieldNo: integer ): String;
Begin
  result := FgsDbfTable.StringGetN( FieldNo );
End;

{Procedure TEzHalcyonTable.CopyStructure( Const FileName, APassword: String );
Begin
  FgsDbfTable.CopyStructure( FileName, APassword );
End;

Procedure TEzHalcyonTable.CopyTo( Const FileName, APassword: String );
Begin
  FgsDbfTable.CopyTo( FileName, APassword );
End;}

Procedure TEzHalcyonTable.DatePut( Const FieldName: String; value: TDateTime );
Begin
  FgsDbfTable.FieldPut( FieldName, FormatDateTime('yyyymmdd',value) );
End;

Procedure TEzHalcyonTable.DatePutN( FieldNo: integer; value: TDateTime );
Begin
  FgsDbfTable.FieldPutN( FieldNo, FormatDateTime('yyyymmdd',value) );
End;

Procedure TEzHalcyonTable.Delete;
Begin
  FgsDbfTable.Delete;
End;

Procedure TEzHalcyonTable.Edit;
Begin
  FgsDbfTable.Edit;
End;

Procedure TEzHalcyonTable.FieldPut( Const FieldName, Value: String );
Begin
  FgsDbfTable.FieldPut( FieldName, Value );
End;

Procedure TEzHalcyonTable.FieldPutN( FieldNo: integer; Const Value: String );
Begin
  FgsDbfTable.FieldPutN( FieldNo, Value );
End;

Procedure TEzHalcyonTable.First;
Begin
  FgsDbfTable.First;
End;

Procedure TEzHalcyonTable.FloatPut( Const FieldName: String; Const Value: Double );
Begin
  FgsDbfTable.FloatPut( FieldName, Value );
End;

Procedure TEzHalcyonTable.FloatPutN( FieldNo: integer; Const Value: Double );
Begin
  FgsDbfTable.FloatPutN( FieldNo, Value );
End;

Procedure TEzHalcyonTable.FlushDB;
Begin
  FgsDbfTable.FlushDBF;
End;

Procedure TEzHalcyonTable.Go( n: Integer );
Begin
  FgsDbfTable.Go( n );
End;

Procedure TEzHalcyonTable.IndexOn( Const IName, tag, keyexp, forexp: String;
  uniq: TezIndexUnique; ascnd: TEzSortStatus );
Begin
  SysUtils.DeleteFile( ChangeFileExt(IName,'.cdx') );
  FgsDbfTable.IndexOn( ChangeFileExt(IName,'.cdx'), tag, keyexp, forexp,
    gsIndexUnique( ord( uniq ) ), gsSortStatus( ord( ascnd ) ) );
End;

Procedure TEzHalcyonTable.IntegerPut( Const FieldName: String; Value: Integer );
Begin
  FgsDbfTable.IntegerPut( FieldName, Value );
End;

Procedure TEzHalcyonTable.IntegerPutN( FieldNo: integer; Value: Integer );
Begin
  FgsDbfTable.IntegerPutN( FieldNo, value );
End;

Procedure TEzHalcyonTable.Last;
Begin
  FgsDbfTable.Last;
End;

Procedure TEzHalcyonTable.LogicPut( Const FieldName: String; value: boolean );
Begin
  FgsDbfTable.LogicPut( FieldName, value );
End;

Procedure TEzHalcyonTable.LogicPutN( fieldno: integer; value: boolean );
Begin
  FgsDbfTable.LogicPutN( fieldno, value );
End;

Procedure TEzHalcyonTable.MemoLoad( Const FieldName: String; Stream: TStream );
Begin
  MemoLoadN( FgsDbfTable.FieldNo( FieldName ), stream );
End;

Procedure TEzHalcyonTable.MemoLoadN( fieldno: integer; Stream: TStream );
Var
  BlobLen: Integer;
  Memory: PChar;
Begin
  if FieldNo < 1 then Exit;
  BlobLen := FgsDbfTable.MemoSizeN( FieldNo );
  GetMem( Memory, BlobLen + 1 );
  Try
    FgsDbfTable.MemoLoadN( FieldNo, Memory, BlobLen );
    Stream.Write( Memory[0], BlobLen );
    Stream.Position := 0;
  Finally
    FreeMem( Memory, BlobLen + 1 );
  End;
End;

Procedure TEzHalcyonTable.Next;
Begin
  FgsDbfTable.Next;
End;

Procedure TEzHalcyonTable.Pack;
Begin
  FgsDbfTable.Pack;
End;

Procedure TEzHalcyonTable.Post;
Begin
  FgsDbfTable.Post;
End;

Procedure TEzHalcyonTable.Prior;
Begin
  FgsDbfTable.Prior;
End;

Procedure TEzHalcyonTable.Recall;
Begin
  FgsDbfTable.Recall;
End;

Procedure TEzHalcyonTable.Refresh;
Begin
  FgsDbfTable.Refresh;
End;

Procedure TEzHalcyonTable.Reindex;
Begin
  FgsDbfTable.Reindex;
End;

Procedure TEzHalcyonTable.SetTagTo( Const TName: String );
Begin
  FgsDbfTable.SetTagTo( TName );
End;

Procedure TEzHalcyonTable.SetUseDeleted( tf: boolean );
Begin
  FgsDbfTable.SetUseDeleted( tf );
End;

Procedure TEzHalcyonTable.StringPut( Const FieldName, value: String );
Begin
  FgsDbfTable.StringPut( FieldName, value );
End;

Procedure TEzHalcyonTable.StringPutN( fieldno: integer; Const value: String );
Begin
  FgsDbfTable.StringPutN( fieldno, value );
End;

Procedure TEzHalcyonTable.Zap;
Begin
  FgsDbfTable.zap;
End;

{$ENDIF}


{$IFDEF NATIVEDB}

type

  { this class is used for reading dBASE .DBF files }
  TEzNativeDbfTable = Class( TEzBaseTable )
  Private
{$IFDEF NATIVEDLL}
    FDBFHandle: Integer;
{$ELSE}
    FDbf: TDbf;
{$ENDIF}
  Protected
    Function GetActive: boolean; Override;
    Procedure SetActive( Value: boolean ); Override;
    Function GetRecNo: Integer; Override;
    Procedure SetRecNo( Value: Integer ); Override;
  Public
    Constructor Create( Gis: TEzBaseGIS; Const FName: String;
      ReadWrite, Shared: boolean ); Override;
    Destructor Destroy; Override;
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
    Function Find( Const ss: String; IsExact, IsNear: boolean ): boolean; Override;
    Function FloatGet( Const FieldName: String ): Double; Override;
    Function FloatGetN( FieldNo: Integer ): Double; Override;
    Function IndexCount: integer; Override;
    Function IndexAscending( Value: integer ): boolean; Override;
    Function Index( Const INames, Tag: String ): integer; Override;
    Function IndexCurrent: String; Override;
    Function IndexUnique( Value: integer ): boolean; Override;
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
    //Procedure CopyStructure( Const FileName, APassword: String ); Override;
    //Procedure CopyTo( Const FileName, APassword: String ); Override;
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
    Procedure LogicPut( Const FieldName: String; value: boolean ); Override;
    Procedure LogicPutN( fieldno: integer; value: boolean ); Override;
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
    Procedure SetUseDeleted( tf: boolean ); Override;
    Procedure StringPut( Const FieldName, value: String ); Override;
    Procedure StringPutN( fieldno: integer; Const value: String ); Override;
    Procedure Zap; Override;
    Function DBCreateTable( Const fname: String; AFieldList: TStringList ): boolean; Override;
    function DBTableExists( const TableName: string ): Boolean; Override;
    Function DBDropTable( const TableName: string): Boolean; Override;
    Function DBDropIndex( const TableName: string): Boolean; Override;
    Function DBRenameTable( const Source, Target: string): Boolean; Override;
  End;

{$IFDEF NATIVEDLL}

type

  TEzDBFTypes = ( dtClipper, dtDBaseIII, dtDBaseIV, dtFoxPro2 );

Var
  ezInitDBFTable: Function( fname, APassword: PChar; ReadWrite, Shared: boolean ): Integer; stdcall;
  ezCreateDBF: Function( fname, apassword: PChar; ftype: integer; Fields: PChar ): boolean; stdcall;
  ezReleaseDBFTable: Procedure( Handle: Integer ); stdcall;
  ezGetActive: Function( handle: integer ): boolean; stdcall;
  ezSetActive: Procedure( handle: integer; Value: boolean ); stdcall;
  ezGetRecNo: Function( handle: integer ): Integer; stdcall;
  ezSetRecNo: Procedure( handle: integer; Value: Integer ); stdcall;
  ezAppend: Procedure( handle: integer ); stdcall;
  ezBOF: Function( handle: integer ): Boolean; stdcall;
  ezEOF: Function( handle: integer ): Boolean; stdcall;
  ezDateGet: Function( handle: integer; FieldName: pchar ): Integer; stdcall;
  ezDateGetN: Function( handle: integer; FieldNo: integer ): Integer; stdcall;
  ezDeleted: Function( handle: integer ): Boolean; stdcall;
  ezField: Function( handle: integer; FieldNo: integer ): pchar; stdcall;
  ezFieldCount: Function( handle: integer ): integer; stdcall;
  ezFieldDec: Function( handle: integer; FieldNo: integer ): integer; stdcall;
  ezFieldGet: Function( handle: integer; FieldName: pchar ): pchar; stdcall;
  ezFieldGetN: Function( handle: integer; FieldNo: integer ): pchar; stdcall;
  ezFieldLen: Function( handle: integer; FieldNo: integer ): integer; stdcall;
  ezFieldNo: Function( handle: integer; FieldName: pchar ): integer; stdcall;
  ezFieldType: Function( handle: integer; FieldNo: integer ): char; stdcall;
  ezFind: Function( handle: integer; ss: pchar; IsExact, IsNear: boolean ): boolean; stdcall;
  ezFloatGet: Function( handle: integer; FieldName: pchar ): Double; stdcall;
  ezFloatGetN: Function( handle: integer; FieldNo: Integer ): Double; stdcall;
  ezIndexCount: Function( handle: integer ): integer; stdcall;
  ezIndexAscending: Function( handle: integer; Value: integer ): boolean; stdcall;
  ezIndex: Function( handle: integer; INames, Tag: pchar ): integer; stdcall;
  ezIndexCurrent: Function( handle: integer ): pchar; stdcall;
  ezIndexUnique: Function( handle: integer; Value: integer ): boolean; stdcall;
  ezIndexExpression: Function( handle: integer; Value: integer ): pchar; stdcall;
  ezIndexTagName: Function( handle: integer; Value: integer ): pchar; stdcall;
  ezIndexFilter: Function( handle: integer; Value: integer ): pchar; stdcall;
  ezIntegerGet: Function( handle: integer; FieldName: pchar ): Integer; stdcall;
  ezIntegerGetN: Function( handle: integer; FieldNo: integer ): Integer; stdcall;
  ezLogicGet: Function( handle: integer; FieldName: pchar ): Boolean; stdcall;
  ezLogicGetN: Function( handle: integer; FieldNo: integer ): Boolean; stdcall;
  ezMemoSave: Function( handle: integer; FieldName: pchar; Buf: PChar;
    Var cb: Integer ): Integer; stdcall;
  ezMemoSaveN: Function( handle: integer; FieldNo: integer; Buf: PChar;
    Var cb: Integer ): Integer; stdcall;
  ezMemoSize: Function( handle: integer; FieldName: pchar ): Integer; stdcall;
  ezMemoSizeN: Function( handle: integer; FieldNo: integer ): Integer; stdcall;
  ezRecordCount: Function( handle: integer ): Integer; stdcall;
  ezStringGet: Function( handle: integer; FieldName: pchar ): pchar; stdcall;
  ezStringGetN: Function( handle: integer; FieldNo: integer ): pchar; stdcall;
  ezCopyStructure: Procedure( handle: integer; FileName, APassword: pchar ); stdcall;
  ezCopyTo: Procedure( handle: integer; FileName, APassword: pchar ); stdcall;
  ezDatePut: Procedure( handle: integer; FieldName: pchar; jdte: longint ); stdcall;
  ezDatePutN: Procedure( handle: integer; FieldNo: integer; jdte: longint ); stdcall;
  ezDelete: Procedure( handle: integer ); stdcall;
  ezEdit: Procedure( handle: integer ); stdcall;
  ezFieldPut: Procedure( handle: integer; FieldName, Value: pchar ); stdcall;
  ezFieldPutN: Procedure( handle: integer; FieldNo: integer; Value: pchar ); stdcall;
  ezFirst: Procedure( handle: integer ); stdcall;
  ezFloatPut: Procedure( handle: integer; FieldName: pchar; Const Value: Double ); stdcall;
  ezFloatPutN: Procedure( handle: integer; FieldNo: integer; Const Value: Double ); stdcall;
  ezFlushDBF: Procedure( handle: integer ); stdcall;
  ezGo: Procedure( handle: integer; n: Integer ); stdcall;
  ezIndexOn: Procedure( handle: integer; IName, tag, keyexp, forexp: pchar;
    uniq: integer; ascnd: integer ); stdcall;
  ezIntegerPut: Procedure( handle: integer; FieldName: pchar; Value: Integer ); stdcall;
  ezIntegerPutN: Procedure( handle: integer; FieldNo: integer; Value: Integer ); stdcall;
  ezLast: Procedure( handle: integer ); stdcall;
  ezLogicPut: Procedure( handle: integer; FieldName: pchar; value: boolean ); stdcall;
  ezLogicPutN: Procedure( handle: integer; fieldno: integer; value: boolean ); stdcall;
  ezMemoLoad: Procedure( handle: integer; FieldName: pchar; Buf: PChar; Var cb: integer ); stdcall;
  ezMemoLoadN: Procedure( handle: integer; fieldno: integer; buf: PChar; Var cb: integer ); stdcall;
  ezNext: Procedure( handle: integer ); stdcall;
  ezPack: Procedure( handle: integer ); stdcall;
  ezPost: Procedure( handle: integer ); stdcall;
  ezPrior: Procedure( handle: integer ); stdcall;
  ezRecall: Procedure( handle: integer ); stdcall;
  ezRefresh: Procedure( handle: integer ); stdcall;
  ezReindex: Procedure( handle: integer ); stdcall;
  ezSetTagTo: Procedure( handle: integer; TName: pchar ); stdcall;
  ezSetUseDeleted: Procedure( handle: integer; tf: boolean ); stdcall;
  ezStringPut: Procedure( handle: integer; FieldName, value: pchar ); stdcall;
  ezStringPutN: Procedure( handle: integer; fieldno: integer; value: pchar ); stdcall;
  ezZap: Procedure( handle: integer ); stdcall;

  DLLHandle: THandle;
  DLLLoaded: Boolean = False;

Procedure LoadDLL;
Var
  ErrorMode: Integer;
Begin
  If DLLLoaded Then Exit;
  ErrorMode := SetErrorMode( SEM_NOOPENFILEERRORBOX );
  DLLHandle := LoadLibrary( 'ezde10.dll' );
  If DLLHandle >= 32 Then
  Begin
    DLLLoaded := True;
    @ezInitDBFTable := GetProcAddress( DLLHandle, 'InitDBFTable' );
    Assert( @ezInitDBFTable <> Nil );
    @ezCreateDBF := GetProcAddress( DLLHandle, 'CreateDBF' );
    Assert( @ezCreateDBF <> Nil );
    @ezReleaseDBFTable := GetProcAddress( DLLHandle, 'ReleaseDBFTable' );
    Assert( @ezReleaseDBFTable <> Nil );
    @ezGetActive := GetProcAddress( DLLHandle, 'GetActive' );
    Assert( @ezGetActive <> Nil );
    @ezSetActive := GetProcAddress( DLLHandle, 'SetActive' );
    Assert( @ezSetActive <> Nil );
    @ezGetRecNo := GetProcAddress( DLLHandle, 'GetRecNo' );
    Assert( @ezGetRecNo <> Nil );
    @ezSetRecNo := GetProcAddress( DLLHandle, 'SetRecNo' );
    Assert( @ezSetRecNo <> Nil );
    @ezAppend := GetProcAddress( DLLHandle, 'Append' );
    Assert( @ezAppend <> Nil );
    @ezBOF := GetProcAddress( DLLHandle, 'BOF' );
    Assert( @ezBOF <> Nil );
    @ezEOF := GetProcAddress( DLLHandle, 'EOF' );
    Assert( @ezEOF <> Nil );
    @ezDateGet := GetProcAddress( DLLHandle, 'DateGet' );
    Assert( @ezDateGet <> Nil );
    @ezDateGetN := GetProcAddress( DLLHandle, 'DateGetN' );
    Assert( @ezDateGetN <> Nil );
    @ezDeleted := GetProcAddress( DLLHandle, 'Deleted' );
    Assert( @ezDeleted <> Nil );
    @ezField := GetProcAddress( DLLHandle, 'Field' );
    Assert( @ezField <> Nil );
    @ezFieldCount := GetProcAddress( DLLHandle, 'FieldCount' );
    Assert( @ezFieldCount <> Nil );
    @ezFieldDec := GetProcAddress( DLLHandle, 'FieldDec' );
    Assert( @ezFieldDec <> Nil );
    @ezFieldGet := GetProcAddress( DLLHandle, 'FieldGet' );
    Assert( @ezFieldGet <> Nil );
    @ezFieldGetN := GetProcAddress( DLLHandle, 'FieldGetN' );
    Assert( @ezFieldGetN <> Nil );
    @ezFieldLen := GetProcAddress( DLLHandle, 'FieldLen' );
    Assert( @ezFieldLen <> Nil );
    @ezFieldNo := GetProcAddress( DLLHandle, 'FieldNo' );
    Assert( @ezFieldNo <> Nil );
    @ezFieldType := GetProcAddress( DLLHandle, 'FieldType' );
    Assert( @ezFieldType <> Nil );
    @ezFind := GetProcAddress( DLLHandle, 'Find' );
    Assert( @ezFind <> Nil );
    @ezFloatGet := GetProcAddress( DLLHandle, 'FloatGet' );
    Assert( @ezFloatGet <> Nil );
    @ezFloatGetN := GetProcAddress( DLLHandle, 'FloatGetN' );
    Assert( @ezFloatGetN <> Nil );
    @ezIndexCount := GetProcAddress( DLLHandle, 'IndexCount' );
    Assert( @ezIndexCount <> Nil );
    @ezIndexAscending := GetProcAddress( DLLHandle, 'IndexAscending' );
    Assert( @ezIndexAscending <> Nil );
    @ezIndex := GetProcAddress( DLLHandle, 'Index' );
    Assert( @ezIndex <> Nil );
    @ezIndexCurrent := GetProcAddress( DLLHandle, 'IndexCurrent' );
    Assert( @ezIndexCurrent <> Nil );
    @ezIndexUnique := GetProcAddress( DLLHandle, 'IndexUnique' );
    Assert( @ezIndexUnique <> Nil );
    @ezIndexExpression := GetProcAddress( DLLHandle, 'IndexExpression' );
    Assert( @ezIndexExpression <> Nil );
    @ezIndexTagName := GetProcAddress( DLLHandle, 'IndexTagName' );
    Assert( @ezIndexTagName <> Nil );
    @ezIndexFilter := GetProcAddress( DLLHandle, 'IndexFilter' );
    Assert( @ezIndexFilter <> Nil );
    @ezIntegerGet := GetProcAddress( DLLHandle, 'IntegerGet' );
    Assert( @ezIntegerGet <> Nil );
    @ezIntegerGetN := GetProcAddress( DLLHandle, 'IntegerGetN' );
    Assert( @ezIntegerGetN <> Nil );
    @ezLogicGet := GetProcAddress( DLLHandle, 'LogicGet' );
    Assert( @ezLogicGet <> Nil );
    @ezLogicGetN := GetProcAddress( DLLHandle, 'LogicGetN' );
    Assert( @ezLogicGetN <> Nil );
    @ezMemoSave := GetProcAddress( DLLHandle, 'MemoSave' );
    Assert( @ezMemoSave <> Nil );
    @ezMemoSaveN := GetProcAddress( DLLHandle, 'MemoSaveN' );
    Assert( @ezMemoSaveN <> Nil );
    @ezMemoSize := GetProcAddress( DLLHandle, 'MemoSize' );
    Assert( @ezMemoSize <> Nil );
    @ezMemoSizeN := GetProcAddress( DLLHandle, 'MemoSizeN' );
    Assert( @ezMemoSizeN <> Nil );
    @ezRecordCount := GetProcAddress( DLLHandle, 'RecordCount' );
    Assert( @ezRecordCount <> Nil );
    @ezStringGet := GetProcAddress( DLLHandle, 'StringGet' );
    Assert( @ezStringGet <> Nil );
    @ezStringGetN := GetProcAddress( DLLHandle, 'StringGetN' );
    Assert( @ezStringGetN <> Nil );
    @ezCopyStructure := GetProcAddress( DLLHandle, 'CopyStructure' );
    Assert( @ezCopyStructure <> Nil );
    @ezCopyTo := GetProcAddress( DLLHandle, 'CopyTo' );
    Assert( @ezCopyTo <> Nil );
    @ezDatePut := GetProcAddress( DLLHandle, 'DatePut' );
    Assert( @ezDatePut <> Nil );
    @ezDatePutN := GetProcAddress( DLLHandle, 'DatePutN' );
    Assert( @ezDatePutN <> Nil );
    @ezDelete := GetProcAddress( DLLHandle, 'Delete' );
    Assert( @ezDelete <> Nil );
    @ezEdit := GetProcAddress( DLLHandle, 'Edit' );
    Assert( @ezEdit <> Nil );
    @ezFieldPut := GetProcAddress( DLLHandle, 'FieldPut' );
    Assert( @ezFieldPut <> Nil );
    @ezFieldPutN := GetProcAddress( DLLHandle, 'FieldPutN' );
    Assert( @ezFieldPutN <> Nil );
    @ezFirst := GetProcAddress( DLLHandle, 'First' );
    Assert( @ezFirst <> Nil );
    @ezFloatPut := GetProcAddress( DLLHandle, 'FloatPut' );
    Assert( @ezFloatPut <> Nil );
    @ezFloatPutN := GetProcAddress( DLLHandle, 'FloatPutN' );
    Assert( @ezFloatPutN <> Nil );
    @ezFlushDBF := GetProcAddress( DLLHandle, 'FlushDBF' );
    Assert( @ezFlushDBF <> Nil );
    @ezGo := GetProcAddress( DLLHandle, 'Go' );
    Assert( @ezGo <> Nil );
    @ezIndexOn := GetProcAddress( DLLHandle, 'IndexOn' );
    Assert( @ezIndexOn <> Nil );
    @ezIntegerPut := GetProcAddress( DLLHandle, 'IntegerPut' );
    Assert( @ezIntegerPut <> Nil );
    @ezIntegerPutN := GetProcAddress( DLLHandle, 'IntegerPutN' );
    Assert( @ezIntegerPutN <> Nil );
    @ezLast := GetProcAddress( DLLHandle, 'Last' );
    Assert( @ezLast <> Nil );
    @ezLogicPut := GetProcAddress( DLLHandle, 'LogicPut' );
    Assert( @ezLogicPut <> Nil );
    @ezLogicPutN := GetProcAddress( DLLHandle, 'LogicPutN' );
    Assert( @ezLogicPutN <> Nil );
    @ezMemoLoad := GetProcAddress( DLLHandle, 'MemoLoad' );
    Assert( @ezMemoLoad <> Nil );
    @ezMemoLoadN := GetProcAddress( DLLHandle, 'MemoLoadN' );
    Assert( @ezMemoLoadN <> Nil );
    @ezNext := GetProcAddress( DLLHandle, 'Next' );
    Assert( @ezNext <> Nil );
    @ezPack := GetProcAddress( DLLHandle, 'Pack' );
    Assert( @ezPack <> Nil );
    @ezPost := GetProcAddress( DLLHandle, 'Post' );
    Assert( @ezPost <> Nil );
    @ezPrior := GetProcAddress( DLLHandle, 'Prior' );
    Assert( @ezPrior <> Nil );
    @ezRecall := GetProcAddress( DLLHandle, 'Recall' );
    Assert( @ezRecall <> Nil );
    @ezRefresh := GetProcAddress( DLLHandle, 'Refresh' );
    Assert( @ezRefresh <> Nil );
    @ezReindex := GetProcAddress( DLLHandle, 'Reindex' );
    Assert( @ezReindex <> Nil );
    @ezSetTagTo := GetProcAddress( DLLHandle, 'SetTagTo' );
    Assert( @ezSetTagTo <> Nil );
    @ezSetUseDeleted := GetProcAddress( DLLHandle, 'SetUseDeleted' );
    Assert( @ezSetUseDeleted <> Nil );
    @ezStringPut := GetProcAddress( DLLHandle, 'StringPut' );
    Assert( @ezStringPut <> Nil );
    @ezStringPutN := GetProcAddress( DLLHandle, 'StringPutN' );
    Assert( @ezStringPutN <> Nil );
    @ezZap := GetProcAddress( DLLHandle, 'Zap' );
    Assert( @ezZap <> Nil );
  End
  Else
    DLLLoaded := False;
  SetErrorMode( ErrorMode );

{  If Not DLLLoaded Then
  Begin
    Application.MessageBox( pchar( 'EzGIS: Unable to load required ezde10.dll' ), 'Error',
      MB_OK Or MB_ICONERROR );
    //Application.Terminate;
  End;  }
End;

Function CreateDllList( FieldList: TStringList ): String;
Var
  i: integer;
Begin
  Result := '';
  For i := 0 To FieldList.Count - 1 Do
    Result := Result + FieldList[i] + '\';
End;

{$ENDIF}

Function TEzNativeDbfTable.DBDropIndex( const TableName: string ): Boolean;
begin
  Result:= true;
  SysUtils.DeleteFile( ChangeFileExt( TableName, '.cdx' ));
end;

Function TEzNativeDbfTable.DBDropTable( const TableName: string ): Boolean;
begin
  SysUtils.DeleteFile( Tablename + '.dbf' );
{$IFDEF NATIVEDLL}
  SysUtils.DeleteFile( Tablename + '.cdx' );
  SysUtils.DeleteFile( Tablename + '.fpt' );
{$ELSE}
  SysUtils.DeleteFile( Tablename + '.mdx' );
  SysUtils.DeleteFile( Tablename + '.dbt' );
{$ENDIF}
  Result:= true;
end;

Function TEzNativeDbfTable.DBRenameTable( const Source, Target: string ): Boolean;
begin
  if FileExists( Source + '.dbf' ) then
    SysUtils.RenameFile( Source + '.dbf', Target + '.dbf');
{$IFDEF NATIVEDLL}
  if FileExists( Source + '.cdx' ) then
    SysUtils.RenameFile( Source + '.cdx', Target + '.cdx');
  if FileExists( Source + '.fpt' ) then
    SysUtils.RenameFile( Source + '.fpt', Target + '.fpt');
{$ELSE}
  if FileExists( Source + '.mdx' ) then
    SysUtils.RenameFile( Source + '.mdx', Target + '.mdx');
  if FileExists( Source + '.dbt' ) then
    SysUtils.RenameFile( Source + '.dbt', Target + '.dbt');
{$ENDIF}
  Result:= true;
end;

function TEzNativeDbfTable.DBTableExists( const TableName: string ): Boolean;
begin
  Result:= FileExists( ChangeFileExt( TableName, '.dbf' ) );
end;

Function TEzNativeDbfTable.DBCreateTable( Const fname: String;
  AFieldList: TStringList ): boolean;
{$IFNDEF NATIVEDLL}
Var
  s: String;
  v: boolean;
  i: integer;
  p: integer;
  fs: String;
  ft: String[1];
  fl: integer;
  fd: integer;

  Procedure LoadField;
  Begin
    v := true;
    p := Ansipos( ';', s );
    fs := '';
    If p > 0 Then
    Begin
      fs := System.Copy( s, 1, pred( p ) );
      System.Delete( s, 1, p );
    End
    Else
      v := false;

    p := Ansipos( ';', s );
    ft := ' ';
    If p = 2 Then
    Begin
      ft := System.Copy( s, 1, 1 );
      System.Delete( s, 1, p );
    End
    Else
      v := false;

    p := Ansipos( ';', s );
    fl := 0;
    If p > 0 Then
    Begin
      Try
        fl := StrToInt( System.Copy( s, 1, pred( p ) ) );
        System.Delete( s, 1, p );
      Except
        On Exception Do
          v := false;
      End;
    End
    Else
      v := false;

    fd := 0;
    Try
      fd := StrToInt( System.Copy( s, 1, 3 ) );
    Except
      On Exception Do
        v := false;
    End;
  End;

{$ENDIF}
Begin
{$IFDEF NATIVEDLL}
  result := ezCreateDBF( pchar( ChangeFileExt(fname,'.dbf') ), '',
    ord( dtFoxPro2 ), PChar( CreateDLLList( AFieldList ) ) );
{$ELSE}
  { create a DBF table }
  With TDbf.Create( Nil ) Do
  Try
    TableName := ChangeFileExt(fname,'.dbf');
    With FieldDefs Do
    Begin
      Clear;
      For I := 0 To AFieldList.count - 1 Do
      Begin
        s:= AFieldList[I];
        LoadField;
        If Not v Then EzGisError( SErrWrongField );

        Case ft[1] Of
          'C':
            Add( fs, ftString, fl, False );
          'F', 'N':
            If fd = 0 Then
              Add( fs, ftInteger, 0, False )
            Else
              Add( fs, ftFloat, 0, False );
          'M', 'G', 'B':
            Add( fs, ftMemo, 0, False );
          'L':
            Add( fs, ftBoolean, 0, False );
          'D':
            Add( fs, ftDate, 0, False );
          'T':
            Add( fs, ftTime, 0, False );
          'I':
            Add( fs, ftInteger, 0, False );
        End;
      End;
    End;
    CreateTable;
  Finally
    Free;
  End;
  Result:= True;
{$ENDIF}
End;


Constructor TEzNativeDbfTable.Create( Gis: TEzBaseGIS; Const FName: String;
  ReadWrite, Shared: boolean );
Begin
  Inherited Create( Gis, FName, ReadWrite, Shared );
{$IFDEF NATIVEDLL}
  FDBFHandle := ezInitDBFTable( pchar( ChangeFileExt(fname,'.dbf') ), '', ReadWrite, Shared );
{$ELSE}
  FDbf := TDbf.Create( Nil );
  With FDbf Do
  Begin
    TableName := ChangeFileExt(fname,'.dbf');
    ReadOnly := Not ReadWrite;
    Open;
  End;
{$ENDIF}
End;

Destructor TEzNativeDbfTable.Destroy;
Begin
{$IFDEF NATIVEDLL}
  if Assigned(ezReleaseDBFTable) then
    ezReleaseDBFTable( FDBFHandle );
{$ELSE}
  FDbf.Free;
{$ENDIF}
  Inherited Destroy;
End;

Function TEzNativeDbfTable.GetActive: boolean;
Begin
{$IFDEF NATIVEDLL}
  result := ezGetActive( FDBFHandle );
{$ELSE}
  result := FDbf.Active;
{$ENDIF}
End;

Procedure TEzNativeDbfTable.SetActive( Value: boolean );
Begin
{$IFDEF NATIVEDLL}
  ezSetActive( FDBFHandle, value );
{$ELSE}
  FDbf.Active := value;
{$ENDIF}
End;

Function TEzNativeDbfTable.GetRecNo: Integer;
Begin
{$IFDEF NATIVEDLL}
  result := ezGetRecno( FDBFHandle );
{$ELSE}
  result := FDbf.RecNo;
{$ENDIF}
End;

Procedure TEzNativeDbfTable.SetRecNo( Value: Integer );
Begin
{$IFDEF NATIVEDLL}
  ezSetRecNo( FDBFHandle, Value );
{$ELSE}
  FDbf.Recno:= Value;
{$ENDIF}
End;

Procedure TEzNativeDbfTable.Append( NewRecno: Integer );
var
{$IFDEF NATIVEDLL}
  FieldNo: Integer;
{$ELSE}
  Field: TField;
{$ENDIF}
Begin
{$IFDEF NATIVEDLL}
  FieldNo:= ezFieldNo( FDBFHandle, pchar( 'UID' ) );
  ezAppend( FDBFHandle );
  if FieldNo > 0 then
    ezIntegerPutN( FDBFHandle, FieldNo, NewRecno );
  ezPost( FDBFHandle );
{$ELSE}
  Field:= FDbf.FieldByName('UID');
  FDbf.Insert;
  if Field <> Nil then Field.AsInteger:= NewRecno;
  FDbf.Post;
{$ENDIF}
End;

Function TEzNativeDbfTable.BOF: Boolean;
Begin
{$IFDEF NATIVEDLL}
  result := ezBOF( FDBFHandle );
{$ELSE}
  result := FDbf.Eof;
{$ENDIF}
End;

Function TEzNativeDbfTable.EOF: Boolean;
Begin
{$IFDEF NATIVEDLL}
  result := ezEOF( FDBFHandle );
{$ELSE}
  result := FDbf.Eof;
{$ENDIF}
End;

Function TEzNativeDbfTable.DateGet( Const FieldName: String ): TDateTime;
{$IFDEF NATIVEDLL}
var
  Index: Integer;
{$ENDIF}
Begin
{$IFDEF NATIVEDLL}
  Result:= 0;
  Index:= FieldNo(FieldName);
  if Index > 0 then
    Result:= DateGetN(Index);
{$ELSE}
  Result:= FDbf.FieldByName( FieldName ).AsDateTime;
{$ENDIF}
End;

Function TEzNativeDbfTable.DateGetN( FieldNo: integer ): TDateTime;
{$IFDEF NATIVEDLL}
var
  s: string;
  yy,mm,dd: word;
{$ENDIF}
Begin
{$IFDEF NATIVEDLL}
  s := TrimRight( ezFieldGetN( FDBFHandle, FieldNo ) );
  Result := 0;
  if (length(s) = 8) and (s <> '00000000') then
  try
     yy := StrToInt(system.copy(s,1,4));
     mm := StrToInt(system.Copy(s,5,2));
     dd := StrToInt(system.Copy(s,7,2));
     Result := EncodeDate(yy,mm,dd);
  except
  end;
{$ELSE}
  result := FDbf.Fields[FieldNo - 1].AsdateTime;
{$ENDIF}
End;

Function TEzNativeDbfTable.Deleted: Boolean;
Begin
{$IFDEF NATIVEDLL}
  result := ezDeleted( FDBFHandle );
{$ELSE}
  result := FDbf.Deleted;
{$ENDIF}
End;

Function TEzNativeDbfTable.Field( FieldNo: integer ): String;
Begin
{$IFDEF NATIVEDLL}
  result := ezField( FDBFHandle, FieldNo );
{$ELSE}
  result := FDbf.Fields[FieldNo - 1].FieldName;
{$ENDIF}
End;

Function TEzNativeDbfTable.FieldCount: integer;
Begin
{$IFDEF NATIVEDLL}
  result := ezFieldCount( FDBFHandle );
{$ELSE}
  result := FDbf.Fields.Count;
{$ENDIF}
End;

Function TEzNativeDbfTable.FieldDec( FieldNo: integer ): integer;
{$IFNDEF NATIVEDLL}
Var
  Datatype: TFieldType;
{$ENDIF}
Begin
{$IFDEF NATIVEDLL}
  result := ezFieldDec( FDBFHandle, FieldNO );
{$ELSE}
  Datatype := FDbf.Fields[FieldNo - 1].Datatype;
  If Datatype In ftNonTexttypes Then
    Result := 0
  Else
    Case Datatype Of
      ftstring{$IFDEF LEVEL4}, ftFixedChar,
      ftWidestring{$ENDIF}
{$IFDEF LEVEL5}, ftGUID{$ENDIF}:
        Result := 0;
      ftBCD:
        Result := FDbf.Fields[FieldNo - 1].Size;
      ftFloat, ftCurrency,
        ftAutoInc, ftSmallInt, ftInteger, ftWord
{$IFNDEF LEVEL3}, ftLargeInt{$ENDIF}:
        Result := 0;
      ftDate, ftTime, ftDateTime:
        Result := 0;
      ftBoolean:
        Result := 0;
      Else
        Result := 0;
    End;
{$ENDIF}
End;

Function TEzNativeDbfTable.FieldGet( Const FieldName: String ): String;
Begin
{$IFDEF NATIVEDLL}
  result := ezFieldGet( FDBFHandle, pchar( FieldName ) );
{$ELSE}
  result := FDbf.FieldByName( FieldName ).AsString;
{$ENDIF}
End;

Function TEzNativeDbfTable.FieldGetN( FieldNo: integer ): String;
Begin
{$IFDEF NATIVEDLL}
  result := ezFieldGetN( FDBFHandle, FieldNo );
{$ELSE}
  result := FDbf.Fields[FieldNo - 1].AsString;
{$ENDIF}
End;

Function TEzNativeDbfTable.FieldLen( FieldNo: integer ): integer;
{$IFNDEF NATIVEDLL}
Var
  Datatype: TFieldType;
{$ENDIF}
Begin
{$IFDEF NATIVEDLL}
  result := ezFieldLen( FDBFHandle, FieldNO );
{$ELSE}
  Datatype := FDbf.Fields[FieldNo - 1].Datatype;
  If Datatype In ftNonTexttypes Then
    Result := 0
  Else
    Case Datatype Of
      ftstring{$IFDEF LEVEL4}, ftFixedChar,
      ftWidestring{$ENDIF}
{$IFDEF LEVEL5}, ftGUID{$ENDIF}:
        Result := FDbf.Fields[FieldNo - 1].Size;
      ftFloat, ftCurrency, ftBCD,
        ftAutoInc, ftSmallInt, ftInteger, ftWord
{$IFNDEF LEVEL3}, ftLargeInt{$ENDIF}:
        Result := 20;
      ftDate, ftTime, ftDateTime:
        Result := 0;
      ftBoolean:
        Result := 0;
    Else
        Result := 0;
    End;
{$ENDIF}
End;

Function TEzNativeDbfTable.FieldNo( Const FieldName: String ): integer;
{$IFNDEF NATIVEDLL}
Var
  Field: TField;
{$ENDIF}
Begin
{$IFDEF NATIVEDLL}
  result := ezFieldNo( FDBFHandle, pchar( FieldName ) );
{$ELSE}
  Field := FDbf.FindField( FieldName );
  If Field = Nil Then
    Result := 0
  Else
    Result := Field.Index + 1;
{$ENDIF}
End;

Function TEzNativeDbfTable.FieldType( FieldNo: integer ): char;
{$IFNDEF NATIVEDLL}
Var
  Datatype: TFieldType;
{$ENDIF}
Begin
{$IFDEF NATIVEDLL}
  result := ezFieldType( FDBFHandle, FieldNo );
{$ELSE}
  Datatype := FDbf.Fields[FieldNo - 1].Datatype;
  If Datatype In ftNonTexttypes Then
  Begin
    Case DataType Of
      ftMemo, ftFmtMemo: Result := 'M';
      ftGraphic: Result := 'G';
      ftTypedBinary: Result := 'B';
    End;
  End
  Else
    Case Datatype Of
      ftstring{$IFDEF LEVEL4}, ftFixedChar,
      ftWidestring{$ENDIF}
{$IFDEF LEVEL5}, ftGUID{$ENDIF}:
        Result := 'C';
      ftFloat, ftCurrency, ftBCD,
        ftAutoInc, ftSmallInt, ftInteger, ftWord
{$IFNDEF LEVEL3}, ftLargeInt{$ENDIF}:
        Result := 'N';
      ftDate, ftTime, ftDateTime:
        Result := 'D';
      ftBoolean:
        Result := 'L';
    Else
        Result := 'C';
    End;
{$ENDIF}
End;

Function TEzNativeDbfTable.Find( Const ss: String; IsExact, IsNear: boolean ): boolean;
Begin
{$IFDEF NATIVEDLL}
  result := ezFind( FDBFHandle, pchar( ss ), IsExact, Isnear );
{$ELSE}
  result := false;    // not yet implemented
{$ENDIF}
End;

Function TEzNativeDbfTable.FloatGet( Const FieldName: String ): Double;
Begin
{$IFDEF NATIVEDLL}
  result := ezFloatGet( FDBFHandle, pchar( FieldName ) );
{$ELSE}
  result := FDbf.FieldByName( FieldName ).Asfloat;
{$ENDIF}
End;

Function TEzNativeDbfTable.FloatGetN( FieldNo: Integer ): Double;
Begin
{$IFDEF NATIVEDLL}
  result := ezFloatGetN( FDBFHandle, FieldNo );
{$ELSE}
  result := FDbf.Fields[FieldNo - 1].Asfloat;
{$ENDIF}
End;

Function TEzNativeDbfTable.IndexCount: integer;
Begin
{$IFDEF NATIVEDLL}
  result := ezIndexCount( FDBFHandle );
{$ELSE}
  result := 0;
{$ENDIF}
End;

Function TEzNativeDbfTable.IndexAscending( Value: integer ): boolean;
Begin
{$IFDEF NATIVEDLL}
  result := ezIndexAscending( FDBFHandle, Value );
{$ELSE}
  Result := true;
{$ENDIF}
End;

Function TEzNativeDbfTable.Index( Const INames, Tag: String ): integer;
Begin
  result := 0;
{$IFDEF NATIVEDLL}
  if FileExists( INames + '.cdx' ) then
    result := ezIndex( FDBFHandle, pchar( INames + '.cdx' ), pchar( Tag ) );
{$ELSE}
  if FileExists( INames + '.mdx' ) then
  begin
    FDbf.OpenIndexFile(INames + '.mdx');
    FDbf.IndexName:= Tag;
  end;
{$ENDIF}
End;

Function TEzNativeDbfTable.IndexCurrent: String;
Begin
{$IFDEF NATIVEDLL}
  result := ezIndexCurrent( FDBFHandle );
{$ELSE}
  result := FDbf.IndexName;
{$ENDIF}
End;

Function TEzNativeDbfTable.IndexUnique( Value: integer ): boolean;
Begin
{$IFDEF NATIVEDLL}
  result := ezIndexUnique( FDBFHandle, Value );
{$ELSE}
  result := true;
{$ENDIF}
End;

Function TEzNativeDbfTable.IndexExpression( Value: integer ): String;
Begin
{$IFDEF NATIVEDLL}
  result := ezIndexExpression( FDBFHandle, Value );
{$ELSE}
  result := '';
{$ENDIF}
End;

Function TEzNativeDbfTable.IndexTagName( Value: integer ): String;
Begin
{$IFDEF NATIVEDLL}
  result := ezIndexTagName( FDBFHandle, Value );
{$ELSE}
  result := '';
{$ENDIF}
End;

Function TEzNativeDbfTable.IndexFilter( Value: integer ): String;
Begin
{$IFDEF NATIVEDLL}
  result := ezIndexFilter( FDBFHandle, Value );
{$ELSE}
  result := '';
{$ENDIF}
End;

Function TEzNativeDbfTable.IntegerGet( Const FieldName: String ): Integer;
Begin
{$IFDEF NATIVEDLL}
  result := ezIntegerget( FDBFHandle, pchar( FieldName ) );
{$ELSE}
  result := FDbf.FieldByName( Fieldname ).AsInteger;
{$ENDIF}
End;

Function TEzNativeDbfTable.IntegerGetN( FieldNo: integer ): Integer;
Begin
{$IFDEF NATIVEDLL}
  result := ezIntegergetN( FDBFHandle, FieldNo );
{$ELSE}
  result := FDbf.Fields[FieldNo - 1].AsInteger;
{$ENDIF}
End;

Function TEzNativeDbfTable.LogicGet( Const FieldName: String ): Boolean;
Begin
{$IFDEF NATIVEDLL}
  result := ezLogicGet( FDBFHandle, pchar( FieldName ) );
{$ELSE}
  result := FDbf.FieldByName( FieldName ).AsBoolean;
{$ENDIF}
End;

Function TEzNativeDbfTable.LogicGetN( FieldNo: integer ): Boolean;
Begin
{$IFDEF NATIVEDLL}
  result := ezLogicgetN( FDBFHandle, FieldNo );
{$ELSE}
  result := FDbf.Fields[FieldNo - 1].AsBoolean;
{$ENDIF}
End;

Procedure TEzNativeDbfTable.MemoSave( Const FieldName: String; Stream: TStream );
Begin
{$IFDEF NATIVEDLL}
  MemoSaveN( ezFieldNo( FDBFHandle, pchar( FieldName ) ), stream );
{$ELSE}
  Stream.Position:= 0;
  (FDbf.FieldByname( FieldName ) as TBlobField).SaveToStream( Stream );
{$ENDIF}
End;

Procedure TEzNativeDbfTable.MemoSaveN( FieldNo: integer; Stream: TStream );
{$IFDEF NATIVEDLL}
Var
  BlobLen: Integer;
  Memory: PChar;
{$ENDIF}
Begin
{$IFDEF NATIVEDLL}
  BlobLen := Stream.Size;
  GetMem( Memory, BlobLen + 1 );
  Try
    Memory[BlobLen] := #0;
    Stream.Read( Memory[0], BlobLen );
    ezMemoSaveN( FDBFHandle, FieldNo, Memory, BlobLen );
  Finally
    FreeMem( Memory, BlobLen + 1 );
  End;
{$ELSE}
  Stream.Position:= 0;
  (FDbf.Fields[FieldNo-1] as TBlobField).SaveToStream( Stream );
{$ENDIF}
End;

Function TEzNativeDbfTable.MemoSize( Const FieldName: String ): Integer;
Begin
{$IFDEF NATIVEDLL}
  result := ezMemoSize( FDBFHandle, pchar( FieldName ) );
{$ELSE}
  result := ( FDbf.FieldByName( FieldName ) As TBlobField ).BlobSize;
{$ENDIF}
End;

Function TEzNativeDbfTable.MemoSizeN( FieldNo: integer ): Integer;
Begin
{$IFDEF NATIVEDLL}
  result := ezMemoSizeN( FDBFHandle, FieldNo );
{$ELSE}
  result := ( FDbf.Fields[FieldNo - 1] As TBlobField ).BlobSize;
{$ENDIF}
End;

Function TEzNativeDbfTable.RecordCount: Integer;
Begin
{$IFDEF NATIVEDLL}
  result := ezRecordCount( FDBFHandle );
{$ELSE}
  result := FDbf.RecordCount;
{$ENDIF}
End;

Function TEzNativeDbfTable.StringGet( Const FieldName: String ): String;
Begin
{$IFDEF NATIVEDLL}
  result := ezStringGet( FDBFHandle, pchar( FieldName ) );
{$ELSE}
  result := FDbf.FieldByname( FieldName ).AsString;
{$ENDIF}
End;

Function TEzNativeDbfTable.StringGetN( FieldNo: integer ): String;
Begin
{$IFDEF NATIVEDLL}
  result := ezStringGetN( FDBFHandle, FieldNo );
{$ELSE}
  result := FDbf.Fields[FieldNo - 1].AsString;
{$ENDIF}
End;

Procedure TEzNativeDbfTable.DatePut( Const FieldName: String; value: TDateTime );
Begin
{$IFDEF NATIVEDLL}
  ezFieldPut( FDBFHandle, pchar( FieldName ), PChar(FormatDateTime('yyyymmdd',value ) ) );
{$ELSE}
  FDbf.FieldByName( FieldName ).AsDateTime := value;
{$ENDIF}
End;

Procedure TEzNativeDbfTable.DatePutN( FieldNo: integer; value: TDateTime );
Begin
{$IFDEF NATIVEDLL}
  ezFieldPutN( FDBFHandle, FieldNo, PChar( FormatDateTime('yyyymmdd',value ) ) );
{$ELSE}
  FDbf.Fields[FieldNo - 1].AsDateTime := value;
{$ENDIF}
End;

Procedure TEzNativeDbfTable.Delete;
Begin
{$IFDEF NATIVEDLL}
  ezDelete( FDBFHandle );
{$ELSE}
  FDbf.Delete
{$ENDIF}
End;

Procedure TEzNativeDbfTable.Edit;
Begin
{$IFDEF NATIVEDLL}
  ezEdit( FDBFHandle );
{$ELSE}
  FDbf.Edit;
{$ENDIF}
End;

Procedure TEzNativeDbfTable.FieldPut( Const FieldName, Value: String );
Begin
{$IFDEF NATIVEDLL}
  ezFieldPut( FDBFHandle, pchar( FieldName ), pchar( Value ) );
{$ELSE}
  FDbf.FieldByName( FieldName ).AsString := Value;
{$ENDIF}
End;

Procedure TEzNativeDbfTable.FieldPutN( FieldNo: integer; Const Value: String );
Begin
{$IFDEF NATIVEDLL}
  ezFieldPutN( FDBFHandle, FieldNo, pchar( Value ) );
{$ELSE}
  FDbf.Fields[Fieldno - 1].Asstring := value;
{$ENDIF}
End;

Procedure TEzNativeDbfTable.First;
Begin
{$IFDEF NATIVEDLL}
  ezFirst( FDBFHandle );
{$ELSE}
  FDbf.First;
{$ENDIF}
End;

Procedure TEzNativeDbfTable.FloatPut( Const FieldName: String; Const Value: Double );
Begin
{$IFDEF NATIVEDLL}
  ezFloatPut( FDBFHandle, pchar( FieldName ), Value );
{$ELSE}
  FDbf.Fieldbyname( Fieldname ).AsFloat := value;
{$ENDIF}
End;

Procedure TEzNativeDbfTable.FloatPutN( FieldNo: integer; Const Value: Double );
Begin
{$IFDEF NATIVEDLL}
  ezFloatPutN( FDBFHandle, FieldNo, Value );
{$ELSE}
  FDbf.Fields[FieldNo - 1].AsFloat := value;
{$ENDIF}
End;

Procedure TEzNativeDbfTable.FlushDB;
Begin
{$IFDEF NATIVEDLL}
  ezFlushDBF( FDBFHandle );
{$ELSE}
  //FDbf.FlushBuffers;
{$ENDIF}
End;

Procedure TEzNativeDbfTable.Go( n: Integer );
Begin
{$IFDEF NATIVEDLL}
  ezGo( FDBFHandle, n );
{$ELSE}
  FDbf.Recno:= n;
{$ENDIF}
End;

Procedure TEzNativeDbfTable.IndexOn( Const IName, tag, keyexp, forexp: String;
  uniq: TEzIndexUnique; ascnd: TEzSortStatus );
Begin
{$IFDEF NATIVEDLL}
  SysUtils.DeleteFile( ChangeFileExt(IName,'.cdx') );
  ezIndexOn( FDBFHandle, pchar( ChangeFileExt(IName,'.cdx') ), pchar( tag ),
    pchar( keyexp ), pchar( forexp ), ord( uniq ), ord( ascnd ) );
{$ELSE}
  // how to do ?
{$ENDIF}
End;

Procedure TEzNativeDbfTable.IntegerPut( Const FieldName: String; Value: Integer );
Begin
{$IFDEF NATIVEDLL}
  ezIntegerPut( FDBFHandle, pchar( FieldName ), Value );
{$ELSE}
  FDbf.FieldByname( Fieldname ).Asinteger := value;
{$ENDIF}
End;

Procedure TEzNativeDbfTable.IntegerPutN( FieldNo: integer; Value: Integer );
Begin
{$IFDEF NATIVEDLL}
  ezIntegerPutN( FDBFHandle, FieldNo, value );
{$ELSE}
  FDbf.Fields[Fieldno - 1].AsInteger := value;
{$ENDIF}
End;

Procedure TEzNativeDbfTable.Last;
Begin
{$IFDEF NATIVEDLL}
  ezLast( FDBFHandle );
{$ELSE}
  FDbf.Last;
{$ENDIF}
End;

Procedure TEzNativeDbfTable.LogicPut( Const FieldName: String; value: boolean );
Begin
{$IFDEF NATIVEDLL}
  ezLogicPut( FDBFHandle, pchar( FieldName ), value );
{$ELSE}
  FDbf.FieldByname( Fieldname ).asboolean := value;
{$ENDIF}
End;

Procedure TEzNativeDbfTable.LogicPutN( fieldno: integer; value: boolean );
Begin
{$IFDEF NATIVEDLL}
  ezLogicPutN( FDBFHandle, fieldno, value );
{$ELSE}
  FDbf.fields[fieldno - 1].asboolean := value;
{$ENDIF}
End;

Procedure TEzNativeDbfTable.MemoLoad( Const FieldName: String; Stream: TStream );
{$IFNDEF NATIVEDLL}
Var
  field: TField;
{$ENDIF}
Begin
{$IFDEF NATIVEDLL}
  MemoLoadN( ezFieldNo( FDBFHandle, pchar( FieldName ) ), Stream );
{$ELSE}
  field := FDbf.FindField( Fieldname );
  If field = Nil Then Exit;
  MemoLoadN( field.index + 1, stream );
{$ENDIF}
End;

Procedure TEzNativeDbfTable.MemoLoadN( fieldno: integer; Stream: TStream );
{$IFDEF NATIVEDLL}
Var
  BlobLen: Integer;
  Memory: PChar;
{$ENDIF}
Begin
{$IFDEF NATIVEDLL}
  BlobLen := MemoSizeN( FieldNo );
  GetMem( Memory, BlobLen + 1 );
  Try
    //Memory[BlobLen] := #0;
    ezMemoLoadN( FDBFHandle, fieldno, Memory, BlobLen );
    Stream.Write( Memory[0], BlobLen );
    Stream.Position := 0;
  Finally
    FreeMem( Memory, BlobLen + 1 );
  End;
{$ELSE}
  stream.seek( 0, 0 );
  ( FDbf.Fields[fieldno - 1] As TBlobfield ).SaveToStream( stream );
{$ENDIF}
End;

Procedure TEzNativeDbfTable.Next;
Begin
{$IFDEF NATIVEDLL}
  ezNext( FDBFHandle );
{$ELSE}
  FDbf.Next;
{$ENDIF}
End;

Procedure TEzNativeDbfTable.Pack;
Begin
{$IFDEF NATIVEDLL}
  ezPack( FDBFHandle );
{$ELSE}
  FDbf.PackTable;
{$ENDIF}
End;

Procedure TEzNativeDbfTable.Post;
Begin
{$IFDEF NATIVEDLL}
  ezPost( FDBFHandle );
{$ELSE}
  FDbf.Post;
{$ENDIF}
End;

Procedure TEzNativeDbfTable.Prior;
Begin
{$IFDEF NATIVEDLL}
  ezPrior( FDBFHandle );
{$ELSE}
  FDbf.Prior;
{$ENDIF}
End;

Procedure TEzNativeDbfTable.Recall;
Begin
{$IFDEF NATIVEDLL}
  ezRecall( FDBFHandle );
{$ELSE}
  FDbf.Recall;
{$ENDIF}
End;

Procedure TEzNativeDbfTable.Refresh;
Begin
{$IFDEF NATIVEDLL}
  ezRefresh( FDBFHandle );
{$ELSE}
  FDbf.Refresh;
{$ENDIF}
End;

Procedure TEzNativeDbfTable.Reindex;
Begin
{$IFDEF NATIVEDLL}
  ezReindex( FDBFHandle );
{$ELSE}
{$ENDIF}
End;

Procedure TEzNativeDbfTable.SetTagTo( Const TName: String );
Begin
{$IFDEF NATIVEDLL}
  ezSetTagTo( FDBFHandle, pchar( TName ) );
{$ELSE}
  FDbf.IndexName:= TName;
{$ENDIF}
End;

Procedure TEzNativeDbfTable.SetUseDeleted( tf: boolean );
Begin
{$IFDEF NATIVEDLL}
  ezSetUseDeleted( FDBFHandle, tf );
{$ELSE}
  FDbf.ShowDeleted:= tf;
{$ENDIF}
End;

Procedure TEzNativeDbfTable.StringPut( Const FieldName, value: String );
Begin
{$IFDEF NATIVEDLL}
  ezStringPut( FDBFHandle, pchar( FieldName ), pchar( value ) );
{$ELSE}
  FDbf.FieldByname( fieldname ).Asstring := value;
{$ENDIF}
End;

Procedure TEzNativeDbfTable.StringPutN( fieldno: integer; Const value: String );
Begin
{$IFDEF NATIVEDLL}
  ezStringPutN( FDBFHandle, fieldno, pchar( value ) );
{$ELSE}
  FDbf.Fields[Fieldno - 1].Asstring := value;
{$ENDIF}
End;

Procedure TEzNativeDbfTable.Zap;
Begin
{$IFDEF NATIVEDLL}
  ezzap( FDBFHandle );
{$ELSE}
  FDbf.First;
  while not FDbf.Eof do FDbf.Delete;
  FDbf.PackTable;
{$ENDIF}
End;

{$ENDIF}

Function CreateAndOpenTable( GIS: TEzBaseGIS; const FileName: string;
    ReadWrite, Shared: Boolean ): TEzBaseTable;
Begin
  Result:= EzBaseGIS.BaseTableClass.Create(GIS, FileName, ReadWrite, Shared);
End;

Function CreateTable( GIS: TEzBaseGIS ): TEzBaseTable;
Begin
  Result:= EzBaseGIS.BaseTableClass.CreateNoOpen(GIS);
End;

Function GetDesktopBaseTableClass: TEzBaseTableClass;
Begin
{$IFDEF DATASET_PROVIDER}

  Result := TEzProviderTable;

{$ENDIF}

{$IFDEF NATIVEDB}

  {$IFDEF NATIVEDLL}
    LoadDLL;
  {$ENDIF}

  Result := TEzNativeDbfTable;

{$ENDIF}

{$IFDEF HALCYONDB}
  Result := TEzHalcyonTable;
{$ENDIF}

{$IFDEF DBISAMDB}
  Result := TEzDBISAMTable;
{$ENDIF}

{$IFDEF BORLAND_BDE}
  Result := TEzBDETable;
{$ENDIF}
End;

Initialization

  EzBaseGIS.BaseTableClass := GetDesktopBaseTableClass;

{$IFDEF NATIVEDLL}
Finalization
  If DLLLoaded Then
    FreeLibrary( DLLHandle );
{$ENDIF}

End.
