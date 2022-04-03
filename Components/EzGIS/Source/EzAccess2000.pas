unit EzAccess2000;

{***********************************************************}
{     EzGIS/CAD Components                                  }
{   (c) 2002 EzSoft Engineering                             }
{         All Rights Reserved                               }
{***********************************************************}

{$I EZ_FLAG.PAS}

{ This unit will override a low level access database by using ADOX for Access2000
  for later using as the attached Db file for every layer.
  For using this unit:
    - just add this unit to your project
    - Also, be sure that in unit ezimpl.pas, all the defines for using an attached
      table for every layer, are turned off. Currently we have the following:

      //$DEFINE NATIVEDB
      //$DEFINE DATASET_PROVIDER
      //$DEFINE HALCYONDB
      //$DEFINE BORLAND_BDE
      //$DEFINE DBISAMDB

    All must be turned off as is shown above.
  }

// This code was tested with ADO/ADOX 2.6.


// ADODB_TLB can be obtained by importing the ADO Type Library:
//
// Select Project/Import Type Library...
// Select 'Microsoft ActiveX Data Objects 2.6 Library'
// or Add C:\Program Files\Common Files\System\ADO\msado15.dll
//
// ADOX_TLB can be obtained by importing the ADOX Type Library:
//
// Select Project/Import Type Library...
// Select 'Microsoft ADO Ext. 2.6 for DDL and Security'
// or Add C:\Program Files\Common Files\System\ado\msadox.dll
//
// The Generate Code Wrapper option is not needed.
//
// ADOX is documented in ado260.chm, which is available as a separate download
// from www.microsoft.com/data, or as part of the Platform SDK or the MSDN
// library, specifically:
//
// Data Access Services/
// Microsoft Data Access Components (MDAC) SDK/
// Microsoft ActiveX Data Objects/
// Microsoft ADOX Programmer's Reference
//
// The OLE DB provider properties (as distinct from ADOX object properties)
// are documented in:
//
// Data Access Services/
// Microsoft Data Access Components (MDAC) SDK/
// Microsoft Data Access Technical Articles/
// ActiveX Data Objects (ADO) Technical Articles/
// Migrating from DAO to ADO/
// Appendix B: Microsoft Jet 4.0 OLE DB Properties Reference.


interface

uses
  SysUtils, Windows, Classes, ezbase, ezbasegis, Db, ADODB, ADOX_TLB, ADODB_TLB
{$IFDEF LEVEL6}
  , Variants
{$ENDIF}
  ;

const
  { the string used for the connection. The database must not be defined because
   in every map new, map open the actual database will be defined there. }
  ACCESS_CONNECTION_STRING = 'Provider=Microsoft.Jet.OLEDB.4.0;Data Source=%s;Jet OLEDB:Engine Type=5' ;

Type

  TEzADOXTable = Class( TEzBaseTable )
  Private
    FADOTable: TADOTable;
  Protected
    Function GetActive: boolean; Override;
    Procedure SetActive( Value: boolean ); Override;
    Function GetRecNo: Integer; Override;
    Procedure SetRecNo( Value: Integer ); Override;
  Public
    Constructor Create( Gis: TEzBaseGis; Const FName: String;
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
    Procedure MemoSave( Const FieldName: String; Stream: Classes.TStream ); Override;
    Procedure MemoSaveN( FieldNo: integer; Stream: Classes.TStream ); Override;
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
    Procedure MemoLoad( Const fieldname: String; Stream: Classes.TStream ); Override;
    Procedure MemoLoadN( fieldno: integer; Stream: Classes.TStream ); Override;
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

Var
  { This object is used for all the connections. From your main form
    you must define the connection  parameters for this variable.
    This variable is instantiated on the initialization section of this unit }
  ADOConnection: TADOConnection;

implementation

uses
  EzSystem, EzConsts ;

Function TEzADOXTable.DBRenameTable( const Source, Target: string): Boolean;
begin
  { don't know for now how to rename a table }
end;

Function TEzADOXTable.DBDropIndex( const TableName: string): Boolean;
begin
  { don't know for now how to drop an index. Please us MS Access }
end;

Function TEzADOXTable.DBDropTable( const TableName: string): Boolean;
begin
  { don't know for now how to drop a table. Use MS Access }
end;

function TEzADOXTable.DBTableExists( const TableName: string ): Boolean;
var
  AccessMdb, DataSource: string ;
  Catalog : _Catalog ;
  Connection : _Connection ;
  I: Integer;
  TblNam: string;
begin
  Result:= false;
  AccessMdb:= ChangeFileExt( Gis.FileName, '.mdb' );
  If Not FileExists( AccessMdb ) then exit;

  Catalog := CoCatalog.Create;

  DataSource := Format( ACCESS_CONNECTION_STRING, [AccessMdb] );

  Connection := CoConnection.Create;

  with Connection do
  begin
    ConnectionString := DataSource;
    // Specify exclusive access because we intend modifying the database's
    // structure.  The default is adModeUnknown.
    Mode := adModeShareExclusive;
    Open('', '', '', Unassigned);
  end;
  // Link the Catalog object to the open connection
  Catalog._Set_ActiveConnection(Connection);

  Try
    TblNam:= ChangeFileExt( ExtractFileName( TableName ), '' );
    For I:= 0 to Catalog.Tables.Count-1 do
      If AnsiCompareText( Catalog.Tables[I].Name, TblNam ) = 0 then
      begin
        Result:= true;
        Break;
      end;
  Finally
    Catalog.Set_ActiveConnection(Unassigned);
  End;

  Catalog := Nil;
  Connection := Nil;

end;

Function TEzADOXTable.DBCreateTable( Const fname: String; AFieldList: TStringList ): boolean;
Var
  s: String;
  v: boolean;
  i: integer;
  p: integer;
  fs: String;
  ft: String[1];
  fl: integer;
  fd: integer;
  DataSource: string;
  Catalog: _Catalog;
  Table: _Table;
  Index1, Index2 : _Index;
  Column, Column1, Column2: _Column;
  Connection: _Connection;
  AccessMdb: string;

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
  AccessMdb:= ChangeFileExt( Gis.FileName, '.mdb' );

  // Create a catalog (database) object using the provided COM object
  // creation method - no need for wrappers and no need for garbage
  // collection.  All COM objects created will be automatically destroyed
  // when they go out of scope. (The OP compiler adds code to decrement
  // each object's reference count when they go out of scope.  Since creating
  // the object in OP automatically increments its reference count to 1, this
  // ensures that COM will destroy the object because its reference count
  // then equals 0.  Note that the scope is defined by the object's
  // declaration procedure, which is not necessarily where they are created).
  Catalog := CoCatalog.Create;

  // Set the connection string.
  // Note that properties specified in the connection string, such as
  // Jet OLEDB:Engine Type or Jet OLEDB:Encrypt Database are subsequently
  // used in the Catalog.Create method, but not all connection properties are
  // supported.  See the Microsoft Jet 4.0 OLE DB Properties Reference for
  // further details.
  // BTW, Jet Engine Type 5 = Access 2000; Type 4 = Access 97
  DataSource := Format( ACCESS_CONNECTION_STRING, [AccessMdb] );

  If not FileExists( AccessMdb ) then
  begin

    // Create a new Access database
    Catalog.Create( DataSource );

    Catalog.Set_ActiveConnection(Unassigned);

    Catalog := nil;

  end;

  Connection := CoConnection.Create;

  with Connection do
  begin
    ConnectionString := DataSource;
    // Specify exclusive access because we intend modifying the database's
    // structure.  The default is adModeUnknown.
    Mode := adModeShareExclusive;
    Open('', '', '', Unassigned);
  end;
  // Recreate the Catalog object
  Catalog := CoCatalog.Create;
  // Link the Catalog object to the open connection
  Catalog._Set_ActiveConnection(Connection);

  { now create the table }
  Table := CoTable.Create;
  with Table do
  begin
    ParentCatalog := Catalog;
    Name := ExtractFilePath( fname );
  end;

  { create the columns }
  // Create the column objects for the master table
  Column1 := CoColumn.Create;
  with Column1 do
    begin
      ParentCatalog := Catalog;
      Name := 'UID';
      Type_ := adInteger;
      // A bug in ADO 2.5 means that the Default property value will not be
      // accepted and no error will be given. This bug is not in 2.1 or 2.6.
      Properties['Default'].Value := 0;

      // Expression to be evaluated on a column to validate its value before
      // allowing it to be set. This operates in a fashion similar to SQL-92
      // CHECK clauses.
      Properties['Jet OLEDB:Column Validation Rule'].Value := '>= 1';
      // Error string to display when the validation rule specified in
      // Jet OLEDB:Column Validation Rule is not met.
      Properties['Jet OLEDB:Column Validation Text'].Value :=
        'Please enter a number greater than or equal to 1';

      // Specify a human-readable string description of the column.
      //
      // Note that you must use the expanded syntax in order to write to
      // the Properties collection.  If you try to use an abbreviated syntax
      // based on the Properties collection default (Value), such as:
      //
      //   Properties['x'] := false
      //
      // you will get a compiler error about trying to write to a read-only
      // property.
      Properties['Description'].Value :=
        'This column is the identifier for the entities';
      // Specify whether this column allows NULLs.  The Nullable property
      // = Access's Required property but the specification is inverted:
      //
      //   If Nullable = false then Required = true
      Properties['Nullable'].Value := false;
    end;
  Table.Columns.Append(Column1, Unassigned, Unassigned);

  Column2 := CoColumn.Create;
  with Column1 do
    begin
      ParentCatalog := Catalog;
      Name := 'DELETED';
      Type_ := adBoolean;
      // A bug in ADO 2.5 means that the Default property value will not be
      // accepted and no error will be given. This bug is not in 2.1 or 2.6.
      Properties['Default'].Value := False;

      // Specify a human-readable string description of the column.
      //
      // Note that you must use the expanded syntax in order to write to
      // the Properties collection.  If you try to use an abbreviated syntax
      // based on the Properties collection default (Value), such as:
      //
      //   Properties['x'] := false
      //
      // you will get a compiler error about trying to write to a read-only
      // property.
      Properties['Description'].Value :=
        'This column indicates if the entity is considered deleted';
      // Specify whether this column allows NULLs.  The Nullable property
      // = Access's Required property but the specification is inverted:
      //
      //   If Nullable = false then Required = true
      Properties['Nullable'].Value := false;
    end;
  Table.Columns.Append(Column2, Unassigned, Unassigned);

  For I := 0 To AFieldList.count - 1 Do
  Begin
    s:= AFieldList[I];
    LoadField;
    If Not v Then
      EzGisError( SErrWrongField );

    Column:= CoColumn.Create;

    Case ft[1] Of
      'C':
        begin
          with Column do
            begin
              ParentCatalog := Catalog;
              Name := fs;
              // The adVarWchar and adWchar types produce Unicode (WideString) strings
              // in Access 2000.  If you are creating an Access 97 database you will
              // get adVarChar and adChar (ANSI) strings instead.
              Type_ := adVarChar;
              // DefinedSize only has meaning for strings (but not memos).
              DefinedSize := fl; // characters
              // Specify a human-readable string description of the column.
              //
              // Note that you must use the expanded syntax in order to write to
              // the Properties collection.  If you try to use an abbreviated syntax
              // based on the Properties collection default (Value), such as:
              //
              //   Properties['x'] := false
              //
              // you will get a compiler error about trying to write to a read-only
              // property.
              //Properties['Description'].Value :=
              //  'This column is part 1 of a multi-column primary key';
              // Specify whether this column allows NULLs.  The Nullable property
              // = Access's Required property but the specification is inverted:
              //
              //   If Nullable = false then Required = true
              Properties['Nullable'].Value := false;
              // Determines whether zero-length strings can be inserted into this
              // column. Ignored for data types that are not strings. This is similar
              // to the Nullable property but distinct. Zero-length strings are not
              // NULLs in Jet.
              Properties['Jet OLEDB:Allow Zero Length'].Value := false;
              // Determines whether Jet should compress UNICODE strings on the disk.
              // This applies only to the version 4.0 .mdb file format and is ignored
              // when running against all other storage formats.  The default is true.
              //Properties['Jet OLEDB:Compressed UNICODE Strings'].Value := true;
            end;
        end;
      'F', 'N':
        If fd = 0 Then
        begin
          with Column do
          begin
            ParentCatalog := Catalog;
            Name := fs;
            Type_ := adInteger;
            //Properties['Default'].Value := 0;

            //Properties['Jet OLEDB:Column Validation Text'].Value :=
            //  'Please enter a number greater than or equal to 1';  adBoolean

            //Properties['Description'].Value :=
            //  'This column is the identifier for the entities';
            //Properties['Nullable'].Value := false;
          end;
        end Else
        begin
          with Column do
          begin
            ParentCatalog := Catalog;
            Name := fs;
            Type_ := adDouble;
            //Properties['Default'].Value := 0;

            //Properties['Jet OLEDB:Column Validation Text'].Value :=
            //  'Please enter a number greater than or equal to 1';  adBoolean

            //Properties['Description'].Value :=
            //  'This column is the identifier for the entities';
            //Properties['Nullable'].Value := false;
          end;
        end;
      'M':
        begin
          with Column do
            begin
              ParentCatalog := Catalog;
              Name := fs;
              Type_ := adLongVarChar;
              //Properties['Default'].Value := 0;

              //Properties['Jet OLEDB:Column Validation Text'].Value :=
              //  'Please enter a number greater than or equal to 1';  adBoolean

              //Properties['Description'].Value :=
              //  'This column is the identifier for the entities';
              //Properties['Nullable'].Value := false;
            end;
        end;
      'G', 'B':
        begin
          with Column do
            begin
              ParentCatalog := Catalog;
              Name := fs;
              Type_ := adVarBinary;
              //Properties['Default'].Value := 0;

              //Properties['Jet OLEDB:Column Validation Text'].Value :=
              //  'Please enter a number greater than or equal to 1';  adBoolean

              //Properties['Description'].Value :=
              //  'This column is the identifier for the entities';
              //Properties['Nullable'].Value := false;
            end;
        end;
      'L':
        begin
          with Column do
            begin
              ParentCatalog := Catalog;
              Name := fs;
              Type_ := adBoolean;
              //Properties['Default'].Value := 0;

              //Properties['Jet OLEDB:Column Validation Text'].Value :=
              //  'Please enter a number greater than or equal to 1';  adBoolean

              //Properties['Description'].Value :=
              //  'This column is the identifier for the entities';
              //Properties['Nullable'].Value := false;
            end;
        end;
      'D':
        begin
          with Column do
            begin
              ParentCatalog := Catalog;
              Name := fs;
              Type_ := adDBDate;
              //Properties['Default'].Value := 0;

              //Properties['Jet OLEDB:Column Validation Text'].Value :=
              //  'Please enter a number greater than or equal to 1';  adBoolean

              //Properties['Description'].Value :=
              //  'This column is the identifier for the entities';
              //Properties['Nullable'].Value := false;
            end;
        end;
      'T':
        begin
          with Column do
            begin
              ParentCatalog := Catalog;
              Name := fs;
              Type_ := adDBTime;
              //Properties['Default'].Value := 0;

              //Properties['Jet OLEDB:Column Validation Text'].Value :=
              //  'Please enter a number greater than or equal to 1';  adBoolean

              //Properties['Description'].Value :=
              //  'This column is the identifier for the entities';
              //Properties['Nullable'].Value := false;
            end;
        end;
      'I':
        begin
          with Column do
            begin
              ParentCatalog := Catalog;
              Name := fs;
              Type_ := adInteger;
              //Properties['Default'].Value := 0;

              //Properties['Jet OLEDB:Column Validation Text'].Value :=
              //  'Please enter a number greater than or equal to 1';  adBoolean

              //Properties['Description'].Value :=
              //  'This column is the identifier for the entities';
              //Properties['Nullable'].Value := false;
            end;
        end;
    End;
    Table.Columns.Append(Column, Unassigned, Unassigned);
  End;

  { append table to catalog }
  Catalog.Tables.Append( Table );

  // Refresh the database schema
  Catalog.Tables.Refresh;

  { create indexes }
  Index1 := CoIndex.Create;
  with Index1 do
  begin
    Name := Column1.Name;
    Columns.Append(Column1.Name, Column1.Type_, Column1.DefinedSize);
    PrimaryKey := false;
    Unique := true;
  end;

  { create primary key }
  Index2 := CoIndex.Create;
  with Index2 do
  begin
    Name := 'PrimaryKey';
    Columns.Append(Column1.Name, Column1.Type_, Column1.DefinedSize);
    // The SortOrder property only has meaning for index columns.
    // adSortAscending is the default.
    Columns[Column1.Name].SortOrder := adSortAscending;
    PrimaryKey := True;
    // The Unique property here seems to be ignored when the PrimaryKey
    // property is true, hence the use of the MIndex1 & MIndex2 objects
    // above.
    Unique := True;
    // Columns which are null will not have an index entry.
    // adIndexNullsDisallow is the default.
    IndexNulls := adIndexNullsDisallow;
    // Specify whether the index is clustered.  The default is false.
    // Access does not support clustering, but SQL Server does.
    Clustered := false;
  end;

  { append indexes to tables }
  Table.Indexes.Append(Index1, EmptyParam);

  { append primary keys to tables }
  Table.Indexes.Append(Index2, EmptyParam);

  Catalog.Set_ActiveConnection(Unassigned);

  Catalog := nil;

End;

Constructor TEzADOXTable.Create( Gis: TEzBaseGis; Const FName: String;
  ReadWrite, Shared: boolean );
var
  AccessMdb: string;
Begin
  inherited Create( Gis, FName, ReadWrite, Shared );
  if Length(FName) > 0 then
  begin
    AccessMdb:= ChangeFileExt( Gis.FileName, '.mdb' );
    If not ADOConnection.Connected then
    begin
      { the connection string must be already defined in main unit }
      ADOConnection.Connected:= true;
    end;
    FADOTable:= TADOTable.Create( Nil );
    With FADOTable Do
    Begin
      Connection := ADOConnection;
      TableName:= ChangeFileExt( ExtractFileName( FName ), '' );
      ReadOnly:= Not ReadWrite;
      //Exclusive:= Not Shared;
      Open;
    End;
  end;
End;

Destructor TEzADOXTable.Destroy;
Begin
  If FADOTable <> Nil then
    FADOTable.Free;
  Inherited Destroy;
End;

Function TEzADOXTable.GetActive: boolean;
Begin
  result := FADOTable.Active;
End;

Procedure TEzADOXTable.SetActive( Value: boolean );
Begin
  FADOTable.Active := value;
End;

Function TEzADOXTable.GetRecNo: Integer;
Begin
  result := FADOTable.FieldByName( 'UID' ).AsInteger;
End;

Procedure TEzADOXTable.SetRecNo( Value: Integer );
Begin
  if FADOTable.IndexName <> '' then
  begin
    FADOTable.IndexName := ''; // primary index
    If Not FADOTable.Locate( 'UID',Value, [] ) Then
      EzGisError( 'Record not found !' );
  end else
  begin
    if FADOTable.FieldByName( 'UID' ).AsInteger <> Value then
    begin
      If Not FADOTable.Locate( 'UID',Value, [] ) Then
        EzGisError( 'Record not found !' );
    end;
  end;
End;

Procedure TEzADOXTable.Append( NewRecno: Integer );
Begin
  FADOTable.Insert;
  FADOTable.FieldByName( 'UID' ).AsInteger := NewRecno;
  FADOTable.Post;
End;

Function TEzADOXTable.BOF: Boolean;
Begin
  result := FADOTable.BOF;
End;

Function TEzADOXTable.EOF: Boolean;
Begin
  result := FADOTable.EOF;
End;

Function TEzADOXTable.DateGet( Const FieldName: String ): TDateTime;
Begin
  result := FADOTable.FieldByName( FieldName ).AsDateTime;
End;

Function TEzADOXTable.DateGetN( FieldNo: integer ): TDateTime;
Begin
  result := FADOTable.Fields[FieldNo - 1].AsdateTime;
End;

Function TEzADOXTable.Deleted: Boolean;
Begin
  result := FADOTable.FieldByName( 'DELETED' ).AsBoolean;
End;

Function TEzADOXTable.Field( FieldNo: integer ): String;
Begin
  result := FADOTable.Fields[FieldNo - 1].FieldName;
End;

Function TEzADOXTable.FieldCount: integer;
Begin
  result := FADOTable.Fields.Count;
End;

Function TEzADOXTable.FieldDec( FieldNo: integer ): integer;
Var
  Datatype: TFieldType;
Begin
  Datatype := FADOTable.Fields[FieldNo - 1].Datatype;
  If Datatype In ftNonTexttypes Then
    Result := 0
  Else
    Case Datatype Of
      ftstring{$IFDEF LEVEL4}, ftFixedChar,
      ftWidestring{$ENDIF}
{$IFDEF LEVEL5}, ftGUID{$ENDIF}:
        Result := 0;
      ftBCD:
        Result := FADOTable.Fields[FieldNo - 1].Size;
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

Function TEzADOXTable.FieldGet( Const FieldName: String ): String;
Begin
  result := FADOTable.FieldByName( FieldName ).AsString;
End;

Function TEzADOXTable.FieldGetN( FieldNo: integer ): String;
Begin
  result := FADOTable.Fields[FieldNo - 1].AsString;
End;

Function TEzADOXTable.FieldLen( FieldNo: integer ): integer;
Var
  Datatype: TFieldType;
Begin
  Datatype := FADOTable.Fields[FieldNo - 1].Datatype;
  If Datatype In ftNonTexttypes Then
    Result := 0
  Else
    Case Datatype Of
      ftstring{$IFDEF LEVEL4}, ftFixedChar,
      ftWidestring{$ENDIF}
{$IFDEF LEVEL5}, ftGUID{$ENDIF}:
        Result := FADOTable.Fields[FieldNo - 1].Size;
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

Function TEzADOXTable.FieldNo( Const FieldName: String ): integer;
Var
  Field: TField;
Begin
  Field := FADOTable.FindField( FieldName );
  If Field = Nil Then
    Result := 0
  Else
    Result := Field.Index + 1;
End;

Function TEzADOXTable.FieldType( FieldNo: integer ): char;
Var
  Datatype: TFieldType;
Begin
  Datatype := FADOTable.Fields[FieldNo - 1].Datatype;
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

Function TEzADOXTable.Find( Const ss: String; IsExact, IsNear: boolean ): boolean;
Begin
  // you must use locate instead
End;

Function TEzADOXTable.FloatGet( Const Fieldname: String ): Double;
Begin
  result := FADOTable.FieldByName( FieldName ).Asfloat;
End;

Function TEzADOXTable.FloatGetN( FieldNo: Integer ): Double;
Begin
  result := FADOTable.Fields[FieldNo - 1].Asfloat;
End;

Function TEzADOXTable.IndexCount: integer;
Begin
  result := FADOTable.IndexDefs.Count;
End;

Function TEzADOXTable.IndexAscending( Value: integer ): boolean;
Begin
  Result := Not ( ixDescending In FADOTable.IndexDefs[Value].Options );
End;

Function TEzADOXTable.Index( Const INames, Tag: String ): integer;
Begin
  // nothing to do here
End;

Function TEzADOXTable.IndexCurrent: String;
Begin
  result := FADOTable.IndexName;
End;

Function TEzADOXTable.IndexUnique( Value: integer ): boolean;
Begin
  Result := ixUnique In FADOTable.IndexDefs[Value].Options;
End;

Function TEzADOXTable.IndexExpression( Value: integer ): String;
Begin
  result := FADOTable.IndexDefs[Value].FieldExpression;
End;

Function TEzADOXTable.IndexTagName( Value: integer ): String;
Begin
  result := FADOTable.IndexDefs[Value].Name;
End;

Function TEzADOXTable.IndexFilter( Value: integer ): String;
Begin
  result := '';
End;

Function TEzADOXTable.IntegerGet( Const FieldName: String ): Integer;
Begin
  result := FADOTable.FieldByName( Fieldname ).AsInteger;
End;

Function TEzADOXTable.IntegerGetN( FieldNo: integer ): Integer;
Begin
  result := FADOTable.Fields[FieldNo - 1].AsInteger;
End;

Function TEzADOXTable.LogicGet( Const FieldName: String ): Boolean;
Begin
  result := FADOTable.FieldByName( FieldName ).AsBoolean;
End;

Function TEzADOXTable.LogicGetN( FieldNo: integer ): Boolean;
Begin
  result := FADOTable.Fields[FieldNo - 1].AsBoolean;
End;

Procedure TEzADOXTable.MemoSave( Const FieldName: String; Stream: Classes.TStream );
Begin
  MemoSaveN( FADOTable.FieldByname( FieldName ).Index + 1, Stream );
End;

Procedure TEzADOXTable.MemoSaveN( FieldNo: integer; Stream: Classes.TStream );
Begin
  stream.Position:= 0;
  ( FADOTable.Fields[FieldNo - 1] As TBlobField ).LoadFromStream( stream );
End;

Function TEzADOXTable.MemoSize( Const FieldName: String ): Integer;
Begin
  result := ( FADOTable.FieldByName( FieldName ) As TBlobField ).BlobSize;
End;

Function TEzADOXTable.MemoSizeN( FieldNo: integer ): Integer;
Begin
  result := ( FADOTable.Fields[FieldNo - 1] As TBlobField ).BlobSize;
End;

Function TEzADOXTable.RecordCount: Integer;
Begin
  result := FADOTable.RecordCount;
End;

Function TEzADOXTable.StringGet( Const FieldName: String ): String;
Begin
  result := FADOTable.FieldByname( FieldName ).AsString;
End;

Function TEzADOXTable.StringGetN( FieldNo: integer ): String;
Begin
  result := FADOTable.Fields[FieldNo - 1].AsString;
End;

{Procedure TEzADOXTable.CopyStructure( Const FileName, APassword: String );
Begin
  // nothing to do
End;

Procedure TEzADOXTable.CopyTo( Const FileName, APassword: String );
Begin
  // nothing to do
End; }

Procedure TEzADOXTable.DatePut( Const FieldName: String; value: TDateTime );
Begin
  FADOTable.FieldByName( FieldName ).AsDateTime := value;
End;

Procedure TEzADOXTable.DatePutN( FieldNo: integer; value: TDateTime );
Begin
  FADOTable.Fields[FieldNo - 1].AsDateTime := value;
End;

Procedure TEzADOXTable.Delete;
Begin
  // only mark as deleted
  FADOTable.Edit;
  FADOTable.FieldByName( 'DELETED' ).AsBoolean := True;
  FADOTable.Post;
End;

Procedure TEzADOXTable.Edit;
Begin
  FADOTable.Edit;
End;

Procedure TEzADOXTable.FieldPut( Const FieldName, Value: String );
Begin
  FADOTable.FieldByName( FieldName ).AsString := Value;
End;

Procedure TEzADOXTable.FieldPutN( FieldNo: integer; Const Value: String );
Begin
  FADOTable.Fields[Fieldno - 1].Asstring := value;
End;

Procedure TEzADOXTable.First;
Begin
  FADOTable.First;
End;

Procedure TEzADOXTable.FloatPut( Const FieldName: String; Const Value: Double );
Begin
  FADOTable.Fieldbyname( Fieldname ).AsFloat := value;
End;

Procedure TEzADOXTable.FloatPutN( FieldNo: integer; Const Value: Double );
Begin
  FADOTable.Fields[FieldNo - 1].AsFloat := value;
End;

Procedure TEzADOXTable.FlushDB;
Begin
  FADOTable.UpdateBatch;
End;

Procedure TEzADOXTable.Go( n: Integer );
Begin
  FADOTable.IndexName := '';
  If Not FADOTable.Locate('UID', n, [] ) Then
    EzGisError( 'Record not found !' );
End;

Procedure TEzADOXTable.IndexOn( Const IName, tag, keyexp, forexp: String;
  uniq: TEzIndexUnique; ascnd: TEzSortStatus );
Begin
  // indexed must be with MS Access
End;

Procedure TEzADOXTable.IntegerPut( Const Fieldname: String; Value: Integer );
Begin
  FADOTable.FieldByname( Fieldname ).Asinteger := value;
End;

Procedure TEzADOXTable.IntegerPutN( FieldNo: integer; Value: Integer );
Begin
  FADOTable.Fields[Fieldno - 1].AsInteger := value;
End;

Procedure TEzADOXTable.Last;
Begin
  FADOTable.Last;
End;

Procedure TEzADOXTable.LogicPut( Const fieldname: String; value: boolean );
Begin
  FADOTable.FieldByname( Fieldname ).asboolean := value;
End;

Procedure TEzADOXTable.LogicPutN( fieldno: integer; value: boolean );
Begin
  FADOTable.fields[fieldno - 1].asboolean := value;
End;

Procedure TEzADOXTable.MemoLoad( Const fieldname: String; Stream: Classes.TStream );
Var
  field: TField;
Begin
  field := FADOTable.FindField( Fieldname );
  If field = Nil Then Exit;
  MemoLoadN( field.index + 1, Stream );
End;

Procedure TEzADOXTable.MemoLoadN( fieldno: integer; Stream: Classes.TStream );
Begin
  ( FADOTable.Fields[fieldno - 1] As TBlobfield ).SaveToStream( stream );
  stream.seek( 0, 0 );
End;

Procedure TEzADOXTable.Next;
Begin
  FADOTable.Next;
End;

Procedure TEzADOXTable.Pack;
Begin
  FADOTable.First;
  While Not FADOTable.Eof Do
  Begin
    If FADOTable.FieldByName( 'DELETED' ).AsBoolean Then
      FADOTable.Delete
    Else
      FADOTable.Next;
  End;
End;

Procedure TEzADOXTable.Post;
Begin
  FADOTable.Post;
End;

Procedure TEzADOXTable.Prior;
Begin
  FADOTable.Prior;
End;

Procedure TEzADOXTable.Recall;
Begin
  If FADOTable.FieldByname( 'DELETED' ).AsBoolean Then
  Begin
    FADOTable.Edit;
    FADOTable.FieldByname( 'DELETED' ).AsBoolean := False;
    FADOTable.Post;
  End;
End;

Procedure TEzADOXTable.Refresh;
Begin
  FADOTable.Refresh;
End;

Procedure TEzADOXTable.Reindex;
Begin
  // nothing to do
End;

Procedure TEzADOXTable.SetTagTo( Const TName: String );
Begin
  FADOTable.IndexName := TName;
End;

Procedure TEzADOXTable.SetUseDeleted( tf: boolean );
Begin
  // nothing to do
End;

Procedure TEzADOXTable.StringPut( Const fieldname, value: String );
Begin
  FADOTable.FieldByname( fieldname ).Asstring := value;
End;

Procedure TEzADOXTable.StringPutN( fieldno: integer; Const value: String );
Begin
  FADOTable.Fields[Fieldno - 1].Asstring := value;
End;

Procedure TEzADOXTable.Zap;
Begin
  FADOTable.DeleteRecords( arAll );
End;

//initialization
  //EzBaseGis.BaseTableClass := TEzADOXTable;

end.
