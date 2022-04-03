Unit EzSHPImport;

{***********************************************************}
{     EzGIS/CAD Components                                  }
{   (c) 2002 EzSoft Engineering                             }
{         All Rights Reserved                               }
{***********************************************************}

{$I EZ_FLAG.PAS}
{$DEFINE USENATIVEDLL}
Interface

Uses
  Controls, SysUtils, Classes, Windows, Dialogs, Db,
  EzLib, EzBase, EzBaseGIS, EzProjections, EzImportBase, EzCADCtrls;

Type

  TEzShapeFileType = ( ftPoint, ftArc, ftPolygon, ftMultiPoint );

  { TEzSHPImport - Projector is used for the original .shp file }
  TEzSHPImport = Class( TEzBaseImport )
  Private
    FTempCAD: TEzCAD;
    { for showing progress messages }
    nEntities: Integer;
    MyEntNo: Integer;
    Procedure EraseShpIndexFiles;
  Public
    Constructor Create(AOwner: TComponent); Override;
    Destructor Destroy; Override;
    Procedure ImportInitialize; Override;
    Procedure GetSourceFieldList( FieldList: TStrings ); Override;
    Procedure ImportFirst; Override;
    Procedure AddSourceFieldData(DestLayer: TEzBaseLayer; DestRecno: Integer); Override;
    Function GetSourceExtension: TEzRect; Override;
    Function ImportEof: Boolean; Override;
    Function GetNextEntity(var progress,entno: Integer): TEzEntity; Override;
    Procedure ImportNext; Override;
    Procedure ImportEnd; Override;
  End;

  { TEzSHPExport - Projector is used for exporting to that projection }
  TEzSHPExport = Class( TEzBaseExport )
  Private
    FExportAs: TEzShapeFileType;
    FTempCAD: TEzCAD;
    Procedure CreateShapeFile;
    Procedure EraseShpIndexFiles;
  {$IFDEF BCB}
    function GetExportAs: TEzShapeFileType;
    procedure SetExportAs(const Value: TEzShapeFileType);
  {$ENDIF}
  Public
    Constructor Create( AOwner: TComponent ); Override;
    Destructor Destroy; Override;
    Procedure ExportInitialize; Override;
    Procedure ExportEntity( SourceLayer: TEzBaseLayer; Entity: TEzEntity ); Override;
    Procedure ExportEnd; Override;
  Published
    Property ExportAs: TEzShapeFileType {$IFDEF BCB} Read GetExportAs Write SetExportAs {$ELSE} Read FExportAs Write FExportAs {$ENDIF} Default ftPolygon;
  End;

  { this class is used for reading dBASE .DBF files }
  TEzSHPDbfTable = Class( TEzBaseTable )
  Private
{$IFDEF USENATIVEDLL}
    FDBFHandle: Integer;
    FDLLHandle: THandle;
    FDLLLoaded: Boolean;

    ezInitDBFTable: Function( fname, APassword: PChar; ReadWrite, Shared: boolean ): Integer; stdcall;
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

    Procedure LoadDLL;
{$ELSE}
    FDbf: TDbf;
{$ENDIF}
  Protected
    Function GetActive: boolean; Override;
    Procedure SetActive( Value: boolean ); Override;
    Function GetRecNo: Integer; Override;
    Procedure SetRecNo( Value: Integer ); Override;
  Public
    Constructor Create( Gis: TEzBaseGis; Const fname: String;
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
    procedure MemoSave( Const FieldName: String; Stream: TStream ); Override;
    procedure MemoSaveN( FieldNo: integer; stream: TStream ); Override;
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
    Procedure MemoLoad( Const FieldName: String; stream: tstream ); Override;
    Procedure MemoLoadN( fieldno: integer; stream: tstream ); Override;
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
  End;

Implementation

Uses
  ezimpl, ezConsts, EzSystem, EzBasicCtrls, EzRtree, fProj
{$IFNDEF USENATIVEDLL}
  , dbf
{$ENDIF}
  ;

{$IFDEF USENATIVEDLL}

type

  TEzDBFTypes = ( dtClipper, dtDBaseIII, dtDBaseIV, dtFoxPro2 );

Procedure TEzSHPDbfTable.LoadDLL;
Var
  ErrorMode: Integer;
Begin
  If FDLLLoaded Then Exit;

  ErrorMode := SetErrorMode( SEM_NOOPENFILEERRORBOX );
  FDLLHandle := LoadLibrary( 'ezde10.dll' );
  If FDLLHandle >= 32 Then
  Begin
    FDLLLoaded := True;
    @ezInitDBFTable := GetProcAddress( FDLLHandle, 'InitDBFTable' );
    Assert( @ezInitDBFTable <> Nil );
    @ezReleaseDBFTable := GetProcAddress( FDLLHandle, 'ReleaseDBFTable' );
    Assert( @ezReleaseDBFTable <> Nil );
    @ezGetActive := GetProcAddress( FDLLHandle, 'GetActive' );
    Assert( @ezGetActive <> Nil );
    @ezSetActive := GetProcAddress( FDLLHandle, 'SetActive' );
    Assert( @ezSetActive <> Nil );
    @ezGetRecNo := GetProcAddress( FDLLHandle, 'GetRecNo' );
    Assert( @ezGetRecNo <> Nil );
    @ezSetRecNo := GetProcAddress( FDLLHandle, 'SetRecNo' );
    Assert( @ezSetRecNo <> Nil );
    @ezAppend := GetProcAddress( FDLLHandle, 'Append' );
    Assert( @ezAppend <> Nil );
    @ezBOF := GetProcAddress( FDLLHandle, 'BOF' );
    Assert( @ezBOF <> Nil );
    @ezEOF := GetProcAddress( FDLLHandle, 'EOF' );
    Assert( @ezEOF <> Nil );
    @ezDateGet := GetProcAddress( FDLLHandle, 'DateGet' );
    Assert( @ezDateGet <> Nil );
    @ezDateGetN := GetProcAddress( FDLLHandle, 'DateGetN' );
    Assert( @ezDateGetN <> Nil );
    @ezDeleted := GetProcAddress( FDLLHandle, 'Deleted' );
    Assert( @ezDeleted <> Nil );
    @ezField := GetProcAddress( FDLLHandle, 'Field' );
    Assert( @ezField <> Nil );
    @ezFieldCount := GetProcAddress( FDLLHandle, 'FieldCount' );
    Assert( @ezFieldCount <> Nil );
    @ezFieldDec := GetProcAddress( FDLLHandle, 'FieldDec' );
    Assert( @ezFieldDec <> Nil );
    @ezFieldGet := GetProcAddress( FDLLHandle, 'FieldGet' );
    Assert( @ezFieldGet <> Nil );
    @ezFieldGetN := GetProcAddress( FDLLHandle, 'FieldGetN' );
    Assert( @ezFieldGetN <> Nil );
    @ezFieldLen := GetProcAddress( FDLLHandle, 'FieldLen' );
    Assert( @ezFieldLen <> Nil );
    @ezFieldNo := GetProcAddress( FDLLHandle, 'FieldNo' );
    Assert( @ezFieldNo <> Nil );
    @ezFieldType := GetProcAddress( FDLLHandle, 'FieldType' );
    Assert( @ezFieldType <> Nil );
    @ezFind := GetProcAddress( FDLLHandle, 'Find' );
    Assert( @ezFind <> Nil );
    @ezFloatGet := GetProcAddress( FDLLHandle, 'FloatGet' );
    Assert( @ezFloatGet <> Nil );
    @ezFloatGetN := GetProcAddress( FDLLHandle, 'FloatGetN' );
    Assert( @ezFloatGetN <> Nil );
    @ezIndexCount := GetProcAddress( FDLLHandle, 'IndexCount' );
    Assert( @ezIndexCount <> Nil );
    @ezIndexAscending := GetProcAddress( FDLLHandle, 'IndexAscending' );
    Assert( @ezIndexAscending <> Nil );
    @ezIndex := GetProcAddress( FDLLHandle, 'Index' );
    Assert( @ezIndex <> Nil );
    @ezIndexCurrent := GetProcAddress( FDLLHandle, 'IndexCurrent' );
    Assert( @ezIndexCurrent <> Nil );
    @ezIndexUnique := GetProcAddress( FDLLHandle, 'IndexUnique' );
    Assert( @ezIndexUnique <> Nil );
    @ezIndexExpression := GetProcAddress( FDLLHandle, 'IndexExpression' );
    Assert( @ezIndexExpression <> Nil );
    @ezIndexTagName := GetProcAddress( FDLLHandle, 'IndexTagName' );
    Assert( @ezIndexTagName <> Nil );
    @ezIndexFilter := GetProcAddress( FDLLHandle, 'IndexFilter' );
    Assert( @ezIndexFilter <> Nil );
    @ezIntegerGet := GetProcAddress( FDLLHandle, 'IntegerGet' );
    Assert( @ezIntegerGet <> Nil );
    @ezIntegerGetN := GetProcAddress( FDLLHandle, 'IntegerGetN' );
    Assert( @ezIntegerGetN <> Nil );
    @ezLogicGet := GetProcAddress( FDLLHandle, 'LogicGet' );
    Assert( @ezLogicGet <> Nil );
    @ezLogicGetN := GetProcAddress( FDLLHandle, 'LogicGetN' );
    Assert( @ezLogicGetN <> Nil );
    @ezMemoSave := GetProcAddress( FDLLHandle, 'MemoSave' );
    Assert( @ezMemoSave <> Nil );
    @ezMemoSaveN := GetProcAddress( FDLLHandle, 'MemoSaveN' );
    Assert( @ezMemoSaveN <> Nil );
    @ezMemoSize := GetProcAddress( FDLLHandle, 'MemoSize' );
    Assert( @ezMemoSize <> Nil );
    @ezMemoSizeN := GetProcAddress( FDLLHandle, 'MemoSizeN' );
    Assert( @ezMemoSizeN <> Nil );
    @ezRecordCount := GetProcAddress( FDLLHandle, 'RecordCount' );
    Assert( @ezRecordCount <> Nil );
    @ezStringGet := GetProcAddress( FDLLHandle, 'StringGet' );
    Assert( @ezStringGet <> Nil );
    @ezStringGetN := GetProcAddress( FDLLHandle, 'StringGetN' );
    Assert( @ezStringGetN <> Nil );
    @ezCopyStructure := GetProcAddress( FDLLHandle, 'CopyStructure' );
    Assert( @ezCopyStructure <> Nil );
    @ezCopyTo := GetProcAddress( FDLLHandle, 'CopyTo' );
    Assert( @ezCopyTo <> Nil );
    @ezDatePut := GetProcAddress( FDLLHandle, 'DatePut' );
    Assert( @ezDatePut <> Nil );
    @ezDatePutN := GetProcAddress( FDLLHandle, 'DatePutN' );
    Assert( @ezDatePutN <> Nil );
    @ezDelete := GetProcAddress( FDLLHandle, 'Delete' );
    Assert( @ezDelete <> Nil );
    @ezEdit := GetProcAddress( FDLLHandle, 'Edit' );
    Assert( @ezEdit <> Nil );
    @ezFieldPut := GetProcAddress( FDLLHandle, 'FieldPut' );
    Assert( @ezFieldPut <> Nil );
    @ezFieldPutN := GetProcAddress( FDLLHandle, 'FieldPutN' );
    Assert( @ezFieldPutN <> Nil );
    @ezFirst := GetProcAddress( FDLLHandle, 'First' );
    Assert( @ezFirst <> Nil );
    @ezFloatPut := GetProcAddress( FDLLHandle, 'FloatPut' );
    Assert( @ezFloatPut <> Nil );
    @ezFloatPutN := GetProcAddress( FDLLHandle, 'FloatPutN' );
    Assert( @ezFloatPutN <> Nil );
    @ezFlushDBF := GetProcAddress( FDLLHandle, 'FlushDBF' );
    Assert( @ezFlushDBF <> Nil );
    @ezGo := GetProcAddress( FDLLHandle, 'Go' );
    Assert( @ezGo <> Nil );
    @ezIndexOn := GetProcAddress( FDLLHandle, 'IndexOn' );
    Assert( @ezIndexOn <> Nil );
    @ezIntegerPut := GetProcAddress( FDLLHandle, 'IntegerPut' );
    Assert( @ezIntegerPut <> Nil );
    @ezIntegerPutN := GetProcAddress( FDLLHandle, 'IntegerPutN' );
    Assert( @ezIntegerPutN <> Nil );
    @ezLast := GetProcAddress( FDLLHandle, 'Last' );
    Assert( @ezLast <> Nil );
    @ezLogicPut := GetProcAddress( FDLLHandle, 'LogicPut' );
    Assert( @ezLogicPut <> Nil );
    @ezLogicPutN := GetProcAddress( FDLLHandle, 'LogicPutN' );
    Assert( @ezLogicPutN <> Nil );
    @ezMemoLoad := GetProcAddress( FDLLHandle, 'MemoLoad' );
    Assert( @ezMemoLoad <> Nil );
    @ezMemoLoadN := GetProcAddress( FDLLHandle, 'MemoLoadN' );
    Assert( @ezMemoLoadN <> Nil );
    @ezNext := GetProcAddress( FDLLHandle, 'Next' );
    Assert( @ezNext <> Nil );
    @ezPack := GetProcAddress( FDLLHandle, 'Pack' );
    Assert( @ezPack <> Nil );
    @ezPost := GetProcAddress( FDLLHandle, 'Post' );
    Assert( @ezPost <> Nil );
    @ezPrior := GetProcAddress( FDLLHandle, 'Prior' );
    Assert( @ezPrior <> Nil );
    @ezRecall := GetProcAddress( FDLLHandle, 'Recall' );
    Assert( @ezRecall <> Nil );
    @ezRefresh := GetProcAddress( FDLLHandle, 'Refresh' );
    Assert( @ezRefresh <> Nil );
    @ezReindex := GetProcAddress( FDLLHandle, 'Reindex' );
    Assert( @ezReindex <> Nil );
    @ezSetTagTo := GetProcAddress( FDLLHandle, 'SetTagTo' );
    Assert( @ezSetTagTo <> Nil );
    @ezSetUseDeleted := GetProcAddress( FDLLHandle, 'SetUseDeleted' );
    Assert( @ezSetUseDeleted <> Nil );
    @ezStringPut := GetProcAddress( FDLLHandle, 'StringPut' );
    Assert( @ezStringPut <> Nil );
    @ezStringPutN := GetProcAddress( FDLLHandle, 'StringPutN' );
    Assert( @ezStringPutN <> Nil );
    @ezZap := GetProcAddress( FDLLHandle, 'Zap' );
    Assert( @ezZap <> Nil );
  End
  Else
    FDLLLoaded := False;
  SetErrorMode( ErrorMode );

  If Not FDLLLoaded Then
  Begin
    MessageToUser( 'EzGIS: Unable to load required ezde10.dll', smsgerror, MB_ICONERROR );
  End;
End;

{$ENDIF}

Constructor TEzSHPDbfTable.Create( Gis: TEzBaseGis; Const fname: String;
  ReadWrite, Shared: boolean );
Begin
  Inherited Create( Gis, fname, Readwrite, Shared );
{$IFDEF USENATIVEDLL}
  LoadDLL;
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

Destructor TEzSHPDbfTable.Destroy;
Begin
{$IFDEF USENATIVEDLL}
  ezReleaseDBFTable( FDBFHandle );
  If FDLLLoaded Then
    FreeLibrary( FDLLHandle );
{$ELSE}
  FDbf.Free;
{$ENDIF}
  Inherited Destroy;
End;

Function TEzSHPDbfTable.GetActive: boolean;
Begin
{$IFDEF USENATIVEDLL}
  result := ezGetActive( FDBFHandle );
{$ELSE}
  result := FDbf.Active;
{$ENDIF}
End;

Procedure TEzSHPDbfTable.SetActive( Value: boolean );
Begin
{$IFDEF USENATIVEDLL}
  ezSetActive( FDBFHandle, value );
{$ELSE}
  FDbf.Active := value;
{$ENDIF}
End;

Function TEzSHPDbfTable.GetRecNo: Integer;
Begin
{$IFDEF USENATIVEDLL}
  result := ezGetRecno( FDBFHandle );
{$ELSE}
  result := FDbf.RecNo;
{$ENDIF}
End;

Procedure TEzSHPDbfTable.SetRecNo( Value: Integer );
Begin
{$IFDEF USENATIVEDLL}
  ezSetRecNo( FDBFHandle, Value );
{$ELSE}
  FDbf.Recno:= Value;
{$ENDIF}
End;

Procedure TEzSHPDbfTable.Append( NewRecno: Integer );
Var
{$IFDEF USENATIVEDLL}
  FieldNo: Integer;
{$ELSE}
  Field: TField;
{$ENDIF}
Begin
{$IFDEF USENATIVEDLL}
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

Function TEzSHPDbfTable.BOF: Boolean;
Begin
{$IFDEF USENATIVEDLL}
  result := ezBOF( FDBFHandle );
{$ELSE}
  result := FDbf.Eof;
{$ENDIF}
End;

Function TEzSHPDbfTable.EOF: Boolean;
Begin
{$IFDEF USENATIVEDLL}
  result := ezEOF( FDBFHandle );
{$ELSE}
  result := FDbf.Eof;
{$ENDIF}
End;

Function TEzSHPDbfTable.DateGet( Const FieldName: String ): TDateTime;
{$IFDEF USENATIVEDLL}
var
  Index: Integer;
{$ENDIF}
Begin
{$IFDEF USENATIVEDLL}
  Result:= 0;
  Index:= FieldNo(FieldName);
  if Index > 0 then
    Result:= DateGetN(Index);
{$ELSE}
  Result:= FDbf.FieldByName( FieldName ).AsDateTime;
{$ENDIF}
End;

Function TEzSHPDbfTable.DateGetN( FieldNo: integer ): TDateTime;
{$IFDEF USENATIVEDLL}
var
  s: string;
  yy,mm,dd: word;
{$ENDIF}
Begin
{$IFDEF USENATIVEDLL}
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

Function TEzSHPDbfTable.Deleted: Boolean;
Begin
{$IFDEF USENATIVEDLL}
  result := ezDeleted( FDBFHandle );
{$ELSE}
  result := FDbf.Deleted;
{$ENDIF}
End;

Function TEzSHPDbfTable.Field( FieldNo: integer ): String;
Begin
{$IFDEF USENATIVEDLL}
  result := ezField( FDBFHandle, FieldNo );
{$ELSE}
  result := FDbf.Fields[FieldNo - 1].FieldName;
{$ENDIF}
End;

Function TEzSHPDbfTable.FieldCount: integer;
Begin
{$IFDEF USENATIVEDLL}
  result := ezFieldCount( FDBFHandle );
{$ELSE}
  result := FDbf.Fields.Count;
{$ENDIF}
End;

Function TEzSHPDbfTable.FieldDec( FieldNo: integer ): integer;
{$IFNDEF USENATIVEDLL}
Var
  Datatype: TFieldType;
{$ENDIF}
Begin
{$IFDEF USENATIVEDLL}
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

Function TEzSHPDbfTable.FieldGet( Const FieldName: String ): String;
Begin
{$IFDEF USENATIVEDLL}
  result := ezFieldGet( FDBFHandle, pchar( FieldName ) );
{$ELSE}
  result := FDbf.FieldByName( FieldName ).AsString;
{$ENDIF}
End;

Function TEzSHPDbfTable.FieldGetN( FieldNo: integer ): String;
Begin
{$IFDEF USENATIVEDLL}
  result := ezFieldGetN( FDBFHandle, FieldNo );
{$ELSE}
  result := FDbf.Fields[FieldNo - 1].AsString;
{$ENDIF}
End;

Function TEzSHPDbfTable.FieldLen( FieldNo: integer ): integer;
{$IFNDEF USENATIVEDLL}
Var
  Datatype: TFieldType;
{$ENDIF}
Begin
{$IFDEF USENATIVEDLL}
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

Function TEzSHPDbfTable.FieldNo( Const FieldName: String ): integer;
{$IFNDEF USENATIVEDLL}
Var
  Field: TField;
{$ENDIF}
Begin
{$IFDEF USENATIVEDLL}
  result := ezFieldNo( FDBFHandle, pchar( FieldName ) );
{$ELSE}
  Field := FDbf.FindField( FieldName );
  If Field = Nil Then
    Result := 0
  Else
    Result := Field.Index + 1;
{$ENDIF}
End;

Function TEzSHPDbfTable.FieldType( FieldNo: integer ): char;
{$IFNDEF USENATIVEDLL}
Var
  Datatype: TFieldType;
{$ENDIF}
Begin
{$IFDEF USENATIVEDLL}
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

Function TEzSHPDbfTable.Find( Const ss: String; IsExact, IsNear: boolean ): boolean;
Begin
{$IFDEF USENATIVEDLL}
  result := ezFind( FDBFHandle, pchar( ss ), IsExact, Isnear );
{$ELSE}
  result := false;    // not yet implemented
{$ENDIF}
End;

Function TEzSHPDbfTable.FloatGet( Const FieldName: String ): Double;
Begin
{$IFDEF USENATIVEDLL}
  result := ezFloatGet( FDBFHandle, pchar( FieldName ) );
{$ELSE}
  result := FDbf.FieldByName( FieldName ).Asfloat;
{$ENDIF}
End;

Function TEzSHPDbfTable.FloatGetN( FieldNo: Integer ): Double;
Begin
{$IFDEF USENATIVEDLL}
  result := ezFloatGetN( FDBFHandle, FieldNo );
{$ELSE}
  result := FDbf.Fields[FieldNo - 1].Asfloat;
{$ENDIF}
End;

Function TEzSHPDbfTable.IndexCount: integer;
Begin
{$IFDEF USENATIVEDLL}
  result := ezIndexCount( FDBFHandle );
{$ELSE}
  result := 0;
{$ENDIF}
End;

Function TEzSHPDbfTable.IndexAscending( Value: integer ): boolean;
Begin
{$IFDEF USENATIVEDLL}
  result := ezIndexAscending( FDBFHandle, Value );
{$ELSE}
  Result := true;
{$ENDIF}
End;

Function TEzSHPDbfTable.Index( Const INames, Tag: String ): integer;
Begin
  result := 0;
{$IFDEF USENATIVEDLL}
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

Function TEzSHPDbfTable.IndexCurrent: String;
Begin
{$IFDEF USENATIVEDLL}
  result := ezIndexCurrent( FDBFHandle );
{$ELSE}
  result := FDbf.IndexName;
{$ENDIF}
End;

Function TEzSHPDbfTable.IndexUnique( Value: integer ): boolean;
Begin
{$IFDEF USENATIVEDLL}
  result := ezIndexUnique( FDBFHandle, Value );
{$ELSE}
  result := true;
{$ENDIF}
End;

Function TEzSHPDbfTable.IndexExpression( Value: integer ): String;
Begin
{$IFDEF USENATIVEDLL}
  result := ezIndexExpression( FDBFHandle, Value );
{$ELSE}
  result := '';
{$ENDIF}
End;

Function TEzSHPDbfTable.IndexTagName( Value: integer ): String;
Begin
{$IFDEF USENATIVEDLL}
  result := ezIndexTagName( FDBFHandle, Value );
{$ELSE}
  result := '';
{$ENDIF}
End;

Function TEzSHPDbfTable.IndexFilter( Value: integer ): String;
Begin
{$IFDEF USENATIVEDLL}
  result := ezIndexFilter( FDBFHandle, Value );
{$ELSE}
  result := '';
{$ENDIF}
End;

Function TEzSHPDbfTable.IntegerGet( Const FieldName: String ): Integer;
Begin
{$IFDEF USENATIVEDLL}
  result := ezIntegerget( FDBFHandle, pchar( FieldName ) );
{$ELSE}
  result := FDbf.FieldByName( Fieldname ).AsInteger;
{$ENDIF}
End;

Function TEzSHPDbfTable.IntegerGetN( FieldNo: integer ): Integer;
Begin
{$IFDEF USENATIVEDLL}
  result := ezIntegergetN( FDBFHandle, FieldNo );
{$ELSE}
  result := FDbf.Fields[FieldNo - 1].AsInteger;
{$ENDIF}
End;

Function TEzSHPDbfTable.LogicGet( Const FieldName: String ): Boolean;
Begin
{$IFDEF USENATIVEDLL}
  result := ezLogicGet( FDBFHandle, pchar( FieldName ) );
{$ELSE}
  result := FDbf.FieldByName( FieldName ).AsBoolean;
{$ENDIF}
End;

Function TEzSHPDbfTable.LogicGetN( FieldNo: integer ): Boolean;
Begin
{$IFDEF USENATIVEDLL}
  result := ezLogicgetN( FDBFHandle, FieldNo );
{$ELSE}
  result := FDbf.Fields[FieldNo - 1].AsBoolean;
{$ENDIF}
End;

procedure TEzSHPDbfTable.MemoSave( Const FieldName: String; stream: tstream );
Begin
{$IFDEF USENATIVEDLL}
  MemoSaveN( ezFieldNo( FDBFHandle, pchar( FieldName ) ), stream );
{$ELSE}
  MemoSaveN( FDbf.FieldByname( FieldName ).Index + 1, Buf, cb );
{$ENDIF}
End;

procedure TEzSHPDbfTable.MemoSaveN( FieldNo: integer; stream: tstream );
{$IFDEF USENATIVEDLL}
Var
  BlobLen: Integer;
  Memory: PChar;
{$ENDIF}
Begin
{$IFDEF USENATIVEDLL}
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

Function TEzSHPDbfTable.MemoSize( Const FieldName: String ): Integer;
Begin
{$IFDEF USENATIVEDLL}
  result := ezMemoSize( FDBFHandle, pchar( FieldName ) );
{$ELSE}
  result := ( FDbf.FieldByName( FieldName ) As TBlobField ).BlobSize;
{$ENDIF}
End;

Function TEzSHPDbfTable.MemoSizeN( FieldNo: integer ): Integer;
Begin
{$IFDEF USENATIVEDLL}
  result := ezMemoSizeN( FDBFHandle, FieldNo );
{$ELSE}
  result := ( FDbf.Fields[FieldNo - 1] As TBlobField ).BlobSize;
{$ENDIF}
End;

Function TEzSHPDbfTable.RecordCount: Integer;
Begin
{$IFDEF USENATIVEDLL}
  result := ezRecordCount( FDBFHandle );
{$ELSE}
  result := FDbf.RecordCount;
{$ENDIF}
End;

Function TEzSHPDbfTable.StringGet( Const FieldName: String ): String;
Begin
{$IFDEF USENATIVEDLL}
  result := ezStringGet( FDBFHandle, pchar( FieldName ) );
{$ELSE}
  result := FDbf.FieldByname( FieldName ).AsString;
{$ENDIF}
End;

Function TEzSHPDbfTable.StringGetN( FieldNo: integer ): String;
Begin
{$IFDEF USENATIVEDLL}
  result := ezStringGetN( FDBFHandle, FieldNo );
{$ELSE}
  result := FDbf.Fields[FieldNo - 1].AsString;
{$ENDIF}
End;

Procedure TEzSHPDbfTable.DatePut( Const FieldName: String; value: TDateTime );
Begin
{$IFDEF USENATIVEDLL}
  ezFieldPut( FDBFHandle, pchar( FieldName ), PChar(FormatDateTime('yyyymmdd',value ) ) );
{$ELSE}
  FDbf.FieldByName( FieldName ).AsDateTime := value;
{$ENDIF}
End;

Procedure TEzSHPDbfTable.DatePutN( FieldNo: integer; value: TDateTime );
Begin
{$IFDEF USENATIVEDLL}
  ezFieldPutN( FDBFHandle, FieldNo, PChar( FormatDateTime('yyyymmdd',value ) ) );
{$ELSE}
  FDbf.Fields[FieldNo - 1].AsDateTime := value;
{$ENDIF}
End;

Procedure TEzSHPDbfTable.Delete;
Begin
{$IFDEF USENATIVEDLL}
  ezDelete( FDBFHandle );
{$ELSE}
  FDbf.Delete
{$ENDIF}
End;

Procedure TEzSHPDbfTable.Edit;
Begin
{$IFDEF USENATIVEDLL}
  ezEdit( FDBFHandle );
{$ELSE}
  FDbf.Edit;
{$ENDIF}
End;

Procedure TEzSHPDbfTable.FieldPut( Const FieldName, Value: String );
Begin
{$IFDEF USENATIVEDLL}
  ezFieldPut( FDBFHandle, pchar( FieldName ), pchar( Value ) );
{$ELSE}
  FDbf.FieldByName( FieldName ).AsString := Value;
{$ENDIF}
End;

Procedure TEzSHPDbfTable.FieldPutN( FieldNo: integer; Const Value: String );
Begin
{$IFDEF USENATIVEDLL}
  ezFieldPutN( FDBFHandle, FieldNo, pchar( Value ) );
{$ELSE}
  FDbf.Fields[Fieldno - 1].Asstring := value;
{$ENDIF}
End;

Procedure TEzSHPDbfTable.First;
Begin
{$IFDEF USENATIVEDLL}
  ezFirst( FDBFHandle );
{$ELSE}
  FDbf.First;
{$ENDIF}
End;

Procedure TEzSHPDbfTable.FloatPut( Const FieldName: String; Const Value: Double );
Begin
{$IFDEF USENATIVEDLL}
  ezFloatPut( FDBFHandle, pchar( FieldName ), Value );
{$ELSE}
  FDbf.Fieldbyname( Fieldname ).AsFloat := value;
{$ENDIF}
End;

Procedure TEzSHPDbfTable.FloatPutN( FieldNo: integer; Const Value: Double );
Begin
{$IFDEF USENATIVEDLL}
  ezFloatPutN( FDBFHandle, FieldNo, Value );
{$ELSE}
  FDbf.Fields[FieldNo - 1].AsFloat := value;
{$ENDIF}
End;

Procedure TEzSHPDbfTable.FlushDB;
Begin
{$IFDEF USENATIVEDLL}
  ezFlushDBF( FDBFHandle );
{$ELSE}
  //FDbf.FlushBuffers;
{$ENDIF}
End;

Procedure TEzSHPDbfTable.Go( n: Integer );
Begin
{$IFDEF USENATIVEDLL}
  ezGo( FDBFHandle, n );
{$ELSE}
  FDbf.Recno:= n;
{$ENDIF}
End;

Procedure TEzSHPDbfTable.IndexOn( Const IName, tag, keyexp, forexp: String;
  uniq: TEzIndexUnique; ascnd: TEzSortStatus );
Begin
{$IFDEF USENATIVEDLL}
  SysUtils.DeleteFile( ChangeFileExt(IName,'.cdx') );
  ezIndexOn( FDBFHandle, pchar( ChangeFileExt(IName,'.cdx') ), pchar( tag ),
    pchar( keyexp ), pchar( forexp ), ord( uniq ), ord( ascnd ) );
{$ELSE}
  // how to do ?
{$ENDIF}
End;

Procedure TEzSHPDbfTable.IntegerPut( Const FieldName: String; Value: Integer );
Begin
{$IFDEF USENATIVEDLL}
  ezIntegerPut( FDBFHandle, pchar( FieldName ), Value );
{$ELSE}
  FDbf.FieldByname( Fieldname ).Asinteger := value;
{$ENDIF}
End;

Procedure TEzSHPDbfTable.IntegerPutN( FieldNo: integer; Value: Integer );
Begin
{$IFDEF USENATIVEDLL}
  ezIntegerPutN( FDBFHandle, FieldNo, value );
{$ELSE}
  FDbf.Fields[Fieldno - 1].AsInteger := value;
{$ENDIF}
End;

Procedure TEzSHPDbfTable.Last;
Begin
{$IFDEF USENATIVEDLL}
  ezLast( FDBFHandle );
{$ELSE}
  FDbf.Last;
{$ENDIF}
End;

Procedure TEzSHPDbfTable.LogicPut( Const FieldName: String; value: boolean );
Begin
{$IFDEF USENATIVEDLL}
  ezLogicPut( FDBFHandle, pchar( FieldName ), value );
{$ELSE}
  FDbf.FieldByname( Fieldname ).asboolean := value;
{$ENDIF}
End;

Procedure TEzSHPDbfTable.LogicPutN( fieldno: integer; value: boolean );
Begin
{$IFDEF USENATIVEDLL}
  ezLogicPutN( FDBFHandle, fieldno, value );
{$ELSE}
  FDbf.fields[fieldno - 1].asboolean := value;
{$ENDIF}
End;

Procedure TEzSHPDbfTable.MemoLoad( Const FieldName: String; stream: tstream );
{$IFNDEF USENATIVEDLL}
Var
  field: TField;
{$ENDIF}
Begin
{$IFDEF USENATIVEDLL}
  MemoLoadN( ezFieldNo( FDBFHandle, pchar( FieldName ) ), Stream );
{$ELSE}
  field := FDbf.FindField( Fieldname );
  If field = Nil Then Exit;
  MemoLoadN( field.index + 1, buf, cb );
{$ENDIF}
End;

Procedure TEzSHPDbfTable.MemoLoadN( fieldno: integer; stream: tstream );
Var
{$IFDEF USENATIVEDLL}
  BlobLen: Integer;
  Memory: PChar;
{$ELSE}
  stream: TStream;
{$ENDIF}
Begin
{$IFDEF USENATIVEDLL}
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

Procedure TEzSHPDbfTable.Next;
Begin
{$IFDEF USENATIVEDLL}
  ezNext( FDBFHandle );
{$ELSE}
  FDbf.Next;
{$ENDIF}
End;

Procedure TEzSHPDbfTable.Pack;
Begin
{$IFDEF USENATIVEDLL}
  ezPack( FDBFHandle );
{$ELSE}
  FDbf.PackTable;
{$ENDIF}
End;

Procedure TEzSHPDbfTable.Post;
Begin
{$IFDEF USENATIVEDLL}
  ezPost( FDBFHandle );
{$ELSE}
  FDbf.Post;
{$ENDIF}
End;

Procedure TEzSHPDbfTable.Prior;
Begin
{$IFDEF USENATIVEDLL}
  ezPrior( FDBFHandle );
{$ELSE}
  FDbf.Prior;
{$ENDIF}
End;

Procedure TEzSHPDbfTable.Recall;
Begin
{$IFDEF USENATIVEDLL}
  ezRecall( FDBFHandle );
{$ELSE}
  FDbf.Recall;
{$ENDIF}
End;

Procedure TEzSHPDbfTable.Refresh;
Begin
{$IFDEF USENATIVEDLL}
  ezRefresh( FDBFHandle );
{$ELSE}
  FDbf.Refresh;
{$ENDIF}
End;

Procedure TEzSHPDbfTable.Reindex;
Begin
{$IFDEF USENATIVEDLL}
  ezReindex( FDBFHandle );
{$ELSE}
{$ENDIF}
End;

Procedure TEzSHPDbfTable.SetTagTo( Const TName: String );
Begin
{$IFDEF USENATIVEDLL}
  ezSetTagTo( FDBFHandle, pchar( TName ) );
{$ELSE}
  FDbf.IndexName:= TName;
{$ENDIF}
End;

Procedure TEzSHPDbfTable.SetUseDeleted( tf: boolean );
Begin
{$IFDEF USENATIVEDLL}
  ezSetUseDeleted( FDBFHandle, tf );
{$ELSE}
  FDbf.ShowDeleted:= tf;
{$ENDIF}
End;

Procedure TEzSHPDbfTable.StringPut( Const FieldName, value: String );
Begin
{$IFDEF USENATIVEDLL}
  ezStringPut( FDBFHandle, pchar( FieldName ), pchar( value ) );
{$ELSE}
  FDbf.FieldByname( fieldname ).Asstring := value;
{$ENDIF}
End;

Procedure TEzSHPDbfTable.StringPutN( fieldno: integer; Const value: String );
Begin
{$IFDEF USENATIVEDLL}
  ezStringPutN( FDBFHandle, fieldno, pchar( value ) );
{$ELSE}
  FDbf.Fields[Fieldno - 1].Asstring := value;
{$ENDIF}
End;

Procedure TEzSHPDbfTable.Zap;
Begin
{$IFDEF USENATIVEDLL}
  ezzap( FDBFHandle );
{$ELSE}
  FDbf.First;
  while not FDbf.Eof do FDbf.Delete;
  FDbf.PackTable;
{$ENDIF}
End;

{ SHPPopulateFieldList }
Procedure SHPPopulateFieldList( Const FromDbf: String; FieldList: TStringList );
Var
  Dbf: TEzBaseTable;
  I: Integer;
Begin
  { copy structure from file }
  Dbf := TEzSHPDbfTable.Create( Nil, FromDbf, false, true );
  Try
    FieldList.Add( 'UID;N;12;0' );
    For i := 1 To Dbf.FieldCount Do
    Begin
      if AnsiCompareText(Dbf.Field(i), 'UID') = 0 then Continue;
      FieldList.Add( Format( '%s;%s;%d;%d', [Dbf.Field( i ),
        Dbf.FieldType( i ), Dbf.FieldLen( i ), Dbf.FieldDec( i )] ) );
    End;
  Finally
    Dbf.Free;
  End;
End;

{A new layer is created on import because the DB file can contain
 very different information }

Constructor TEzSHPImport.Create(AOwner: TComponent);
Begin
  Inherited Create(AOwner);
  FTempCAD:= TEzCAD.Create(Nil);
End;

Destructor TEzSHPImport.Destroy;
Begin
  FTempCAD.Free;
  Inherited;
End;

Procedure TEzSHPImport.EraseShpIndexFiles;
Var
  temp: String;
Begin
  temp := ChangeFileExt( Filename, RTCEXT );
  If FileExists( temp ) Then
    SysUtils.DeleteFile( temp );
  temp := ChangeFileExt( Filename, RTXEXT );
  If FileExists( temp ) Then
    SysUtils.DeleteFile( temp );
End;

procedure TEzSHPImport.ImportInitialize;
Var
  ShpLayer: TEzBaseLayer;
Begin
  EraseShpIndexFiles;
  { create a temporary TEzCAD used for opening a .SHP file }
  ShpLayer := TSHPLayer.Create( FTempCAD.Layers, ChangeFileExt( Filename, '' ) );
  FTempCAD.ReadOnly:= True;
  ShpLayer.Open;
  With ShpLayer.LayerInfo.Extension Do
  Begin
    If Abs(Emax.x - Emin.x) <= 360 Then
    Begin
      { presumably source file is defined in degrees }
      Converter.SourceCoordSystem := csLatLon;
      If DrawBox.GIS.Layers.Count = 0 Then
        Converter.DestinCoordSystem := Converter.SourceCoordSystem;
    End;
  End;
  { initialize for progress messages }
  nEntities:= ShpLayer.RecordCount;   // this function must return the number of records to import
  MyEntNo := 0;
End;

Procedure TEzSHPImport.GetSourceFieldList( FieldList: TStrings );
Begin
  SHPPopulateFieldList( ChangeFileExt( Filename, '' ), FieldList As TStringList );
End;

Procedure TEzSHPImport.ImportFirst;
Begin
  FTempCAD.Layers[0].First;
End;

Function TEzSHPImport.ImportEof: Boolean;
Begin
  Result:= FTempCAD.Layers[0].Eof;
End;

Function TEzSHPImport.GetNextEntity(var progress,entno: Integer): TEzEntity;
Begin
  Inc(MyEntNo);
  progress:= Round((MyEntNo / nEntities) * 100);
  entno:=MyEntNo;
  Result:= FTempCAD.Layers[0].RecLoadEntity;
End;

Procedure TEzSHPImport.AddSourceFieldData(DestLayer: TEzBaseLayer; DestRecno: Integer);
Var
  SourceLayer: TEzBaseLayer;
  J: Integer;
Begin
  SourceLayer:= FTempCAD.Layers[0];
  If (DestLayer.DBTable = Nil) Or (SourceLayer.DBTable = Nil) Then Exit;
  DestLayer.DBTable.Recno:= DestRecno;
  DestLayer.DBTable.BeginTrans;
  Try
    DestLayer.DBTable.Edit;
    SourceLayer.DBTable.Recno:= SourceLayer.Recno;
    For J := 1 To SourceLayer.DBTable.FieldCount Do
    Begin
      Try
        With DestLayer.DBTable Do
          AssignFrom( SourceLayer.DBTable, J, FieldNo( SourceLayer.DBTable.Field( J ) ) );
      Except
        // ignore error in fields in DBF file (wrong data)
      End;
    End;
    DestLayer.DBTable.Post;
    DestLayer.DBTable.EndTrans;
  Except
    DestLayer.DBTable.RollbackTrans;
    raise;
  End;
End;

Procedure TEzSHPImport.ImportNext;
Begin
  FTempCAD.Layers[0].Next;
End;

Function TEzSHPImport.GetSourceExtension: TEzRect;
Begin
  Result:= FTempCAD.Layers[0].LayerInfo.Extension
End;

Procedure TEzSHPImport.ImportEnd;
Begin
  EraseShpIndexFiles;
End;

Function ShpCreateDbfTable( Const fname, apassword: String;
  AFieldList: TStringList ): boolean;
Var
{$IFDEF USENATIVEDLL}
  ErrorMode: Integer;
  DLLHandle: THandle;
  ezCreateDBF: Function( fname, apassword: PChar; ftype: integer; Fields: PChar ): boolean; stdcall;

  Function CreateDllList( FieldList: TStringList ): String;
  Var
    i: integer;
  Begin
    Result := '';
    For i := 0 To FieldList.Count - 1 Do
      Result := Result + FieldList[i] + '\';
  End;

{$ELSE}
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
{$IFDEF USENATIVEDLL}
  Result:= False;
  ErrorMode := SetErrorMode( SEM_NOOPENFILEERRORBOX );
  DLLHandle := LoadLibrary( 'ezde10.dll' );
  If DLLHandle >= 32 Then
  Begin
    @ezCreateDBF := GetProcAddress( DLLHandle, 'CreateDBF' );
    Assert( @ezCreateDBF <> Nil );
    result := ezCreateDBF( pchar( ChangeFileExt(fname,'.dbf') ), pchar( apassword ),
                           ord( dtDBaseIII ), PChar( CreateDLLList( AFieldList ) ) );
    SetErrorMode( ErrorMode );
    FreeLibrary( DLLHandle );
  end;
{$ELSE}
  { create a DBF table }
  Result:=false;
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
    Result:=true;
  Finally
    Free;
  End;
{$ENDIF}
End;


{ TEzSHPExport }

Constructor TEzSHPExport.Create( AOwner: TComponent );
Begin
  Inherited Create( AOwner );
  FExportAs := ftPolygon;
  FTempCAD:= TEzCAD.Create(Nil);
End;

destructor TEzSHPExport.Destroy;
begin
  FTempCAD.Free;
  inherited;
end;

Procedure TEzSHPExport.EraseShpIndexFiles;
Var
  temp: String;
Begin
  temp := ChangeFileExt( FileName, RTCEXT );
  If FileExists( temp ) Then
    SysUtils.DeleteFile( temp );
  temp := ChangeFileExt( FileName, RTXEXT );
  If FileExists( temp ) Then
    SysUtils.DeleteFile( temp );
End;

Procedure TEzSHPExport.CreateShapeFile;
Var
  Basename: String;
  shp, shx: TFileStream;
  ShapeHeader: TShapeHeader;
  FieldList: TStringList;
  Layer: TEzBaseLayer;
  I: Integer;
Begin
  BaseName := ChangeFileExt( FileName, '' );
  shp := TFileStream.Create( BaseName + '.SHP', fmCreate );
  FillChar( ShapeHeader, sizeof( TShapeHeader ), 0 );
  ShapeHeader.FileCode := ReverseInteger( 9994 );
  ShapeHeader.FileLength := ReverseInteger( sizeOf( TShapeHeader ) ) Div 2;
  ShapeHeader.Version := 1000;
  Case FExportAs Of
    ftPoint: ShapeHeader.ShapeType := 1;
    ftArc: ShapeHeader.ShapeType := 3;
    ftPolygon: ShapeHeader.ShapeType := 5;
    ftMultiPoint: ShapeHeader.ShapeType := 8;
  End;
  ShapeHeader.Extent := INVALID_EXTENSION;
  shp.Write( ShapeHeader, sizeOf( TShapeHeader ) );
  shp.Free;

  shx := TFileStream.Create( BaseName + '.SHX', fmCreate );
  shx.Write( ShapeHeader, sizeOf( TShapeHeader ) );
  shx.Free;

  { Now create the ArcView DBF file }
  Layer := DrawBox.GIS.Layers.LayerByName( Layername );
  FieldList := TStringList.Create;
  Try
    If Layer.DBTable <> Nil Then
    Begin
      With Layer.DBTable Do
      Begin
        For I := 1 To FieldCount Do
        Begin
          // I don´t know if ArcView supports dBASE III/IV/V or what
          If FieldType( I ) In ['M', 'G', 'B'] Then Continue;

          FieldList.Add( Format( '%s;%s;%d;%d', [Field( I ), FieldType( I ), FieldLen( I ), FieldDec( I )] ) );
        End;
      End;
    End
    Else
      FieldList.Add( 'ID;N;8;0' );
    ShpCreateDbfTable( BaseName, '', FieldList );
  Finally
    FieldList.Free;
  End;
End;

Procedure TEzSHPExport.ExportInitialize;
Var
  ShpLayer: TEzBaseLayer;
Begin
  { create the shape file }
  CreateShapeFile;
  ShpLayer := TSHPLayer.Create( FTempCAD.Layers, ChangeFileExt( FileName, '' ) );
  ShpLayer.Open;
End;

Procedure TEzSHPExport.ExportEntity( SourceLayer: TEzBaseLayer; Entity: TEzEntity );
var
  ShpLayer: TEzBaseLayer;
  J, TheRecno: Integer;
  FSource, FDest: Integer;
Begin
  If ( Entity.Points.Parts.Count = 0 ) And ( Entity.Points.Count = 2 ) Then
    Entity.Points.Add( Entity.Points[0] );

  // the vector direction must be clockwise !!!!
  If IsCounterClockWise( Entity.Points ) Then
    Entity.Points.RevertDirection;

  ShpLayer:= FTempCAD.Layers[0];

  TheRecno:= ShpLayer.AddEntity( Entity );
  If (SourceLayer.DBTable <> Nil) And (ShpLayer.DBTable <> Nil) Then
  Begin
    ShpLayer.DBTable.Recno:= TheRecno;
    ShpLayer.DBTable.Edit;
    // write the new DBF shapefile record
    SourceLayer.DBTable.Recno := SourceLayer.Recno;
    For j := 1 To SourceLayer.DBTable.FieldCount Do
    Begin
      FSource := J;
      FDest := ShpLayer.DBTable.FieldNo( SourceLayer.DBTable.Field( J ) );
      If FDest <> 0 Then
      Begin
        Try
          ShpLayer.DBTable.AssignFrom( SourceLayer.DBTable, FSource, FDest );
        Except
          // probably caused by corrupted data
        End;
      End;
    End;
    ShpLayer.DBTable.Post;
  End
  Else If ShpLayer.DBTable <> Nil Then
  Begin
    // write an empty record
    ShpLayer.DBTable.IntegerPutN( 1, Entity.ID );
    ShpLayer.DBTable.Post;
  End;
End;

Procedure TEzSHPExport.ExportEnd;
Begin
  EraseShpIndexFiles;
End;

{$IFDEF BCB}
function TEzSHPExport.GetExportAs: TEzShapeFileType;
begin
  Result := FExportAs;
end;

procedure TEzSHPExport.SetExportAs(const Value: TEzShapeFileType);
begin
  FExportAs := Value;
end;
{$ENDIF}

End.
