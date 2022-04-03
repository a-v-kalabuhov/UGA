{*******************************************************}
{                                                       }
{       "ИС МП УГА"                                     }
{       Главный системный модуль                        }
{                                                       }
{       Copyright (c) 2004-2005, МП УГА                 }
{                                                       }
{       Автор: Калабухов А.В.                           }
{                                                       }
{*******************************************************}

{ Описание: доступ к глобальным объектам системы - соединению с БД, пользователем и пр.
  Имя модуля: AppModule
  Версия: 1.02
  Дата последнего изменения: 04.05.2005
  Цель: содержит главный модуль системы.
  Используется:
  Использует: IBX Utilities, Settings, Kernel Classes, Garbage Collector,
              Common Utilities
  Исключения: нет }
{
  1.02            04.05.2005
     - изменения в связи с апгрейдом класса TKisUser

  1.01            18.11.2004
     - исправлена ошибка сохранения параметров приложения типа Cardinal
}


unit uKisAppModule;

interface

{$I KisFlags.pas}

uses
  // System
  Windows, Messages, Dialogs, SysUtils, Classes, Graphics, Controls, Forms, Db,
  IBDatabase, IniFiles, DBGrids, AppEvnts, ShlObj, IB, StrUtils,
  // Common
  uIBXUtils, uGC,  
  // Project
  uKisIntf, uKisClasses, uKisSQLClasses, uKisFactory;

const
  PROP_COL = 'Columns.';
  PROP_WIN_ST = 'WindowState';
  PROP_LEFT = 'Left';
  PROP_TOP = 'Top';
  PROP_WIDTH = 'Width';
  PROP_HEIGHT = 'Height';
  PARAM_LETTERS = 'Letters';
  PARAM_NUMBER_ORDER = 'NumberOrder';
  PARAM_DBNAME = 'DatabaseName'; 

type
  TKisListIndex = (
    klArchDocType,
    klChiefDocType,
    klChiefDocType2, 
    klCountries,
    klDecreePrjStates,
    klLicensedOrg,
    klMapCasesBasis,
    klOfficeDocTypes,
    klOffices,
    klOriginOrgs,
    klPersonDoc,
    klPersonDocOwner,
    klPunktType1,
    klPunktType2,
    klRegions,
    klSignatures,
    klStates,
    klStreetMark,
    klSubdivision,
    klTownKind,
    klVillages
  );

  TAlertEvent = procedure (Sender: TObject; const MessageText: String) of object;

  TKisAppModule = class(TDataModule, IKisFolders)
    Database: TIBDatabase;
    ApplicationEvents: TApplicationEvents;
    DebugIBTran: TIBTransaction;
    DebugIBDB: TIBDatabase;
    procedure DataModuleCreate(Sender: TObject);
    procedure DataModuleDestroy(Sender: TObject);
    procedure ApplicationEventsException(Sender: TObject; E: Exception);
  private
    FUser: TKisUser;
    FMngrs: TList;
    FIni: TIniFile;
    FReportPath, FSQLLogPath, FMapScansPath, FMapScansTemp: String;
    FAppTempPath: string;
    FMapStorageHost: string;
    FMapStoragePort: Integer;
    FCriticalError: Boolean;
    FTransPool: uIBXUtils.TIBTransactionPool;
    FUseINIFile: Boolean;
    FAlertWindow : TForm;
    FLogging: Boolean;
    FLogSQL: Boolean;
    FOnAlert: TAlertEvent;
    FCoreCount: Byte;
    function GetMngr(Ident: TKisMngrs): TKisMngr;
    function GetList(ListIndex: TKisListIndex): TStringList;
    function ConnectAsGuest: Boolean;
    procedure ReadLastUser(var OfficeID, UserId: Integer);
    procedure SetCriticalError(const Value: Boolean);
    procedure CreateAlertWindow;
    procedure CloseAlertWindow(Sender: TObject; var Action: TCloseAction);
    function GetSQLMngr(Ident: TKisMngrs): TKisSQLMngr;
  public
    function Connect(const UserId: Integer; const UserName, RoleName, Password: String): Boolean;
  (* ==== Работа с текущим пользователем ==== *)
    function Logon(const DBName: String): Boolean;
    property User: TKisUser read FUser;
    (* ==== Служебные методы ==== *)
    // Генерация нового ID
    function GetID(const GeneratorName: String; ATransaction: TIBTransaction; const NameIsFull: Boolean = False): Integer;
    //
    //property AppTempPath: string read FAppTempPath;
    //property MapScansPath: string read FMapScansPath;
    //property MapScansTempPath: String read FMapScansTemp;
    //property ReportsPath: String read FReportPath;
    property MapStorageHost: String read FMapStorageHost;
    property MapStoragePort: Integer read FMapStoragePort;
    (* ==== Работа с настройками ==== *)
    function ReadAppParam(AOwner, Component: TComponent; const PropertyName: String; DataType: Integer; UseComponentName: Boolean = False): Variant; overload;
    function ReadAppParam(const SectionName, PropertyName: String; DataType: Integer): Variant; overload;
    function ReadAppParamDef(const SectionName, PropertyName: String; DataType: Integer; const DefaultValue: Variant): Variant; overload;
    function SaveAppParam(AOwner, Component: TComponent; const PropertyName: String; const Value: Variant; UseComponentName: Boolean = False): Boolean; overload;
    function SaveAppParam(const SectionName, PropertyName: String; const Value: Variant): Boolean; overload;
    procedure ReadGridProperties(AOwner: TComponent; Grid: TDBGrid);
    procedure WriteGridProperties(AOwner: TComponent; Grid: TDBGrid);
    procedure ReadFormPosition(AOwner: TComponent; Form: TForm);
    procedure WriteFormPosition(AOwner: TComponent; Form: TForm);
    procedure Alert(const Message: String);
    procedure ClearTempFiles();
    /// <summary>
    ///   Настройка соединения с БД
    /// </summary>
    function Config: Boolean;
    function GetAppInfo: string;
    procedure LogError(const aMessage, aClassName, aNativeMessage, aNativeClassName,
      anObjectInfo: String; Info: TStrings);
    procedure LogException(E: Exception; Info: TStrings);
    procedure LogSQL(SQLText: String);
    property Pool: TIBTransactionPool read FTransPool;
    (* ==== Работа со справочниками ==== *)
    function DocTypeList(OrgId, Incoming: Integer): TStringList;
    function ExecutionPhaseList(OfficeId: Integer): TStringList;
    function ObjectTypesList(OfficeId: Integer): TStrings;
    function OfficeDocTypesList(OfficeId: Integer): TStrings;
    function OfficesList(OrgId: Integer): TStrings;
    // список людей
    function PeolpeList(OfficeId: Integer): TStringList;
    // Выбор значения из справочника
    function GetFieldValue(ATransaction: TIBTransaction; const pTableName,
      pKeyFieldName, pFieldName: String; const pKeyValue: Variant; var pFieldValue: Variant): Boolean;
    // Выбор значения из справочника
    function FieldValues(const aTableName, aFieldName: String): TStringList;
    /// <summary>
    /// Выбор списка значений из справочника.
    /// </summary>
    procedure GetLookupValues(ATransaction: TIBTransaction; const pTableName, pKeyFieldName, pValueFieldName: String; Values: TStrings);
    //
    procedure AddDocInWork(const DocNumber: string);
    procedure DeleteDocInWork(const DocNumber: string);
    function ExistsDocInWork(const DocNumber: string): Boolean;
    procedure SQLErrorHandler(E: Exception; const OldSQL, NewSQL: string);
    //
    property Lists[ListIndex: TKisListIndex]: TStringList read GetList;
    //
    (* ==== Доступ к модулям системы ==== *)
    property Mngrs[Ident: TKisMngrs]: TKisMngr read GetMngr; default;
    property SQLMngrs[Ident: TKisMngrs]: TKisSQLMngr read GetSQLMngr;
    property CriticalError: Boolean read FCriticalError write SetCriticalError;
    property UseINIFile: Boolean read FUseINIFile write FUseINIFile;
    property Logging: Boolean read FLogging write FLogging;
    //
    property OnAlert: TAlertEvent read FOnAlert write FOnAlert;
  public
    { IKisFolders }
    function AppTempPath(): string;
    function MapScansPath(): string;
    function MapScansTempPath(): string;
    function ReportsPath(): string;
    function SQLLogPath(): string;
    function ThreadCount(): Byte;
  end;

  function AppModule: TKisAppModule;
  function GetDebugInfo(): TStrings;
  function GetDebugString(): string;

var
  KisAppModule: TKisAppModule;
  KisMngrFactory: TKisMngrFactory;

implementation

{$R *.DFM}

uses
  // System
  IBHeader, IBQuery, IBSQL, Variants, TypInfo, StdCtrls,
  // JCL
  JclDebug,
  // Common
  uCommonUtils, uVCLUtils, uFileUtils,
  // Project
  uKisMainView, uKisPasswordDlg, Config, uKisConsts, uKisUtils, uKisExceptions;


resourcestring
  SQ_STATES_LIST = 'SELECT ID, NAME, BANK_GROUP FROM RUSSIAN_STATES ORDER BY NAME';
  SQ_COUNTRIES_LIST = 'SELECT ID, NAME FROM COUNTRIES ORDER BY NAME';
  SQ_VILLAGES_LIST = 'SELECT ID, NAME FROM VILLAGES ORDER BY NAME';
  SQ_TOWN_KIND_LIST = 'SELECT ID, NAME_SHORT FROM TOWN_KINDS ORDER BY NAME_SHORT';
  SQ_STREET_MARK_LIST = 'SELECT ID, SHORT_NAME, KIND FROM STREET_MARKING WHERE KIND = 1 ORDER BY SHORT_NAME';
  SQ_PERSON_DOC_TYPES_LIST = 'SELECT ID, NAME FROM PERSON_DOC_TYPES ORDER BY ID';
  SQ_PERSON_DOC_OWNER_LIST = 'SELECT ID, NAME FROM PERSON_DOC_OWNERS ORDER BY ID';
  SQ_ORG_SUBDIV_TYPES_LIST = 'SELECT ID, NAME FROM ORG_SUBDIV_TYPES ORDER BY ID';
  SQ_CHIEF_DOC_TYPES_LIST = 'SELECT ID, NAME FROM CHIEF_DOC_TYPES';
  SQ_CHIEF_DOC_TYPES_LIST2 = 'SELECT ID, NAME_2 FROM CHIEF_DOC_TYPES';
  SQ_GET_MAP_CASES_BASIS_LIST = 'SELECT NAME FROM MAP_CASES_BASIS_TYPES ORDER BY NAME';
  SQ_GPUNKT_TYPE1_LIST = 'SELECT ID, NAME FROM GPUNKT_TYPES_1';
  SQ_GPUNKT_TYPE2_LIST = 'SELECT ID, NAME FROM GPUNKT_TYPES_2';
  SQ_DECREE_PRJ_STATES_LIST = 'SELECT ID, NAME FROM DECREE_PRJ_STATES';
  SQ_ARCH_DOC_TYPE_LIST = 'SELECT ID, NAME FROM ARCHIVAL_DOC_TYPES';
  SQ_LICENSED_ORG_LIST = 'SELECT ID, NAME FROM LICENSED_ORGS';
  SQ_REGIONS_LIST = 'SELECT ID, NAME FROM REGIONS ORDER BY NAME';
  SQ_OFFICES = 'SELECT ID, NAME FROM OFFICES ORDER BY NAME';
  SQ_OFFICES_LIST = 'SELECT A.ID, A.NAME FROM OFFICES A '
    + 'WHERE EXISTS(SELECT ID FROM PEOPLE WHERE OFFICES_ID=A.ID AND ENABLED=''T'') '
    + 'ORDER BY NAME';
  SQ_SIGNATURES_LIST = 'SELECT ID, SIGNATURE FROM SIGNATURES';
  SQ_OFFICE_DOC_TYPES_LIST = 'SELECT ID, NAME FROM OFFICE_DOC_TYPES';
//  SQ_GET_PEOPLE_BY_OFFICE_ID = 'SELECT ID, INITIAL_NAME FROM PEOPLE WHERE OFFICES_ID=:ID ORDER BY 2';
//  SQ_GET_PEOPLE_BY_OFFICE_ID = 'SELECT ID, FULL_NAME AS INITIAL_NAME FROM PEOPLE WHERE OFFICES_ID=:ID ORDER BY 2';
  SQ_GET_PEOPLE_BY_OFFICE_ID = 'SELECT ID, FULL_NAME AS INITIAL_NAME FROM PEOPLE '+
  'WHERE OFFICES_ID=:ID AND ENABLED = ''T'' ORDER BY 2';
  SQ_GET_OFFICE_DOC_TYPES_BY_OFFICE_ID = 'SELECT ID, NAME FROM OFFICE_DOC_TYPES WHERE OFFICES_ID=:ID';
  SQ_GET_OBJECT_TYPES_BY_OFFICE_ID = 'SELECT ID, NAME FROM OBJECT_TYPES WHERE OFFICES_ID=:ID';
  SQ_GET_PHASES_BY_OFFICE_ID = 'SELECT ID, NAME FROM EXECUTION_PHASES WHERE OFFICES_ID=:ID ORDER BY 2';
  SQ_GET_DOC_TYPES_BY_ORG_ID = 'SELECT ID, NAME FROM DOC_TYPES WHERE (ORGS_ID=:ID) AND (INCOMING=:INCOMING) ORDER BY 2';
  SQ_GET_OFFICES_BY_ORG_ID = 'SELECT A.ID, A.NAME FROM OFFICES A '
    + 'WHERE EXISTS(SELECT ID FROM PEOPLE WHERE OFFICES_ID=A.ID AND ENABLED=''T'') AND (ORGS_ID=%d)'
    + 'ORDER BY NAME';
  SQ_ORIGIN_ORGS_LIST = 'SELECT DISTINCT MAP_ORIGIN_ORG FROM MAP_500';
  SQ_LOG_ERROR = 'INSERT INTO ERROR_LOG ("MESSAGE", CLASS_NAME, NATIVE_MESSAGE, NATIVE_CLASS_NAME, DEBUG_INFO, OBJECT_INFO) '
    + 'VALUES(:MES, :CLASS, :MES1, :CLASS1, :INFO, :INFO2)';
  SQ_FIELD_VALUES = 'SELECT DISTINCT(%s) FROM %s';
  //
  SQ_ADD_DOC_IN_WORK = 'INSERT INTO DOCS_IN_WORK (DOC_NUMBER) VALUES (:DOC_NUMBER)';
  SQ_DELETE_DOC_IN_WORK = 'DELETE FROM DOCS_IN_WORK WHERE DOC_NUMBER=:DOC_NUMBER';
  SQ_SELECT_DOC_IN_WORK = 'SELECT DOC_NUMBER FROM DOCS_IN_WORK WHERE DOC_NUMBER=:DOC_NUMBER';

function AppModule: TKisAppModule;
var
  I: Integer;
begin
  Result := nil;
  if Assigned(KisAppModule) then
    Result := KisAppModule
  else
  for I := N_ZERO to Pred(Application.ComponentCount) do
    if Application.Components[I] is TKisAppModule then
      Result := TKisAppModule(Application.Components[I]);
end;

function GetDebugInfo(): TStrings;
begin
  Result := TStringList.Create;
  JclLastExceptStackListToStrings(Result, True, True, True);
end;

function GetDebugString(): string;
var
  L: TStrings;
begin
  L := GetDebugInfo();
  L.Forget();
  Result := L.Text;
end;

procedure TKisAppModule.DataModuleCreate(Sender: TObject);
var
  FileNameIni, sPath : String;
  Windir: string;
  WindirP: PChar;
  Res: Cardinal;
  Ini2: TIniFile;
  Fs: TFormatSettings;
begin
//  FCoreCount := //2;//1;//4;
  FCoreCount := 4;
///ed
  FileNameIni := ChangeFileExt(Application.ExeName, '.INI');
  if not FileExists(FileNameIni) then
  begin
    FileNameIni := ExtractFileName(ChangeFileExt(Application.ExeName, '.INI'));
    WinDirP := StrAlloc(MAX_PATH);
    Res := GetWindowsDirectory(WinDirP, MAX_PATH);
    StrDispose(WinDirP);
    if Res > 0 then
      WinDir := StrPas(WinDirP);
    if not FileExists (WinDir + '\' + FileNameIni) then
    begin
      ShowMessage('Не найден файл настройки ' + WinDir + '\' + FileNameIni +  #13 + 'обратитесь к системному администратору!');
      Halt(1);
    end;
  end;
  FIni := TIniFile.Create(FileNameIni);
  FAppTempPath := TFileUtils.GetSpecialFolderLocation(CSIDL_LOCAL_APPDATA, FOLDERID_LocalAppData);
  if not DirectoryExists(FAppTempPath) then
    FAppTempPath := TFileUtils.GetTempPath;
  Fs.DateSeparator := '-';
  Fs.TimeSeparator := '-';
  Fs.ShortDateFormat := 'yyyy-mm-dd';
  Fs.LongDateFormat := 'yyyy-mm-dd';
  Fs.ShortTimeFormat := 'hh-mm';
  Fs.LongTimeFormat := 'hh-mm-ss-nnn';
//  GetLocaleFormatSettings(0, Fs);
  FAppTempPath := FAppTempPath + 'Kis\Session_' + DateTimeToStr(Now, Fs);
  ForceDirectories(FAppTempPath);
///
{$IFDEF USER}
  FUseIniFile := True;
{$ELSE}
  FUseIniFile := False;
{$ENDIF}
  FUser := TKisUser.Create(database);
  Database.LoginPrompt := False;
  Database.DatabaseName := '';
 {$IFDEF LOCALREPORTS}
  FReportPath := 'k:\Projects\Kis\Reports\';
 {$ELSE}
  sPath := ExtractFilePath(Application.ExeName) + 'Kis_main.ini';
  Ini2 := TIniFile.Create(sPath);
  try
    FReportPath := Ini2.ReadString('Reports','ReportPath', '');
    //
    FLogSQL := AnsiUpperCase(Ini2.ReadString('Logs', 'SQLLog', 'No')) = 'YES';
    FSQLLogPath := Ini2.ReadString('Logs','SQLLogPath', '');
    if FSQLLogPath = '' then
      FSQLLogPath := ExtractFilePath(Application.ExeName);
    FSQLLogPath := ExpandFileName(FSQLLogPath);
    if not DirectoryExists(FSQLLogPath) then
      FLogSQL := False;
    FSQLLogPath := FSQLLogPath + 'sql.log';
    //
    FMapScansPath := Ini2.ReadString('Data','MapScansPath', '');
    FMapScansTemp := Ini2.ReadString('Data','MapScansTempPath', '');
    FMapStorageHost := Ini2.ReadString('Data','FTPHost', '');
    FMapStoragePort := Ini2.ReadInteger('Data','FTPPort', 220);
  finally
    FreeAndNil(Ini2);
  end;
  {$ENDIF}
  FMngrs := TList.Create;
  uKisClasses.MngrList := FMngrs;
  FTransPool := TIBTransactionPool.Create(Self, Database, 5);
  FAlertWindow := nil;
{  with IStringList(TStringList.Create).StringList do
    SaveToFile('kis_log.txt');}
end;

function TKisAppModule.ConnectAsGuest: Boolean;
begin
  with AppModule.Database do
  begin
    if Connected then
      Close;
    Database.CurrentUserName := S_GUEST;
    Database.Password := AnsiLowerCase(S_GUEST);
    Database.CurrentRole := '';
    try
      Open;
      Result := True;
    except
      Result := False;
      if ExceptObject is Exception then
        LogException(Exception(ExceptObject), GetDebugInfo);
    end;
  end;
end;

function TKisAppModule.Logon(const DBName: String): Boolean;
begin
  Result := False;
  if Database.DatabaseName <> DBName then
  begin
    if Assigned(KisMainView) then
      KisMainView.CloseAllWindows;
    Database.Close;
    Database.DatabaseName := DBName;
{$IFDEF USER}
   // Коннект как гость - для авторизации
   while not ConnectAsGuest do
   begin
     MessageBox(0, PChar('Невозможно установить соединение с базой данных!'#13'Обратитесь к администратору!'),
       PChar(S_WARN), MB_OK + MB_ICONWARNING);
     Database.DatabaseName := '';
     if not Config then
     begin
       Result := False;
       Exit;
     end
     else
       Exit;
   end;
   //
   with TRegForm.Create(Self) do
   try
     ibqPeople.Transaction := Pool.Get;
     ibqOffices.Transaction := ibqPeople.Transaction;
     ibqPeople.Transaction.Init(ilReadCommited, amReadOnly);
     OnReadLastUser := ReadLastUser;
     OnLogon := Connect;
     Result := ShowModal = mrOK;
   finally
     if ibqPeople.Transaction.Active then
       ibqPeople.Transaction.Commit;
     Pool.Back(ibqPeople.Transaction);
     Release;
   end;
{$ENDIF}
    if Result then
      Self.SaveAppParam(S_CONNECTION_SECTION, PARAM_DBNAME, Database.DatabaseName)
    else
    begin
      Database.Close;
    end;
  end;
end;

procedure TKisAppModule.LogSQL(SQLText: String);
var
  aStr, aFile: TStream;
  aMode: Word;
begin
  if FLogSQL then
  begin
    SQLText := DateTimeToStr(Now) + #13#10 + SQLText + DupeString('=', 40) + #13#10 + #13#10;
    try
      aStr := TStringStream.Create(SQLText);
      aStr.Forget;
      if FileExists(FSQLLogPath) then
        aMode := fmOpenWrite
      else
        aMode := fmCreate;
      aFile := TFileStream.Create(FSQLLogPath, aMode);
      aFile.Forget;
      aFile.Seek(0, soEnd);
      aFile.CopyFrom(aStr, aStr.Size);
    except
    end;
  end;
end;

function TKisAppModule.MapScansPath: string;
begin
  Result := FMapScansPath;
end;

function TKisAppModule.MapScansTempPath: string;
begin
  Result := FMapScansTemp;
end;

function TKisAppModule.GetAppInfo: string;
begin
  Result := #13#10 + #13#10 + 'Active Form:' + #13#10;
  if Assigned(Screen.ActiveForm) then
    Result := Result + 'Class = ' + Screen.ActiveForm.ClassName + #13#10 +
      'Name = ' + Screen.ActiveForm.Name + #13#10 + 'Caption = ' + Screen.ActiveForm.Caption
  else
    Result := Result + 'none';
  Result := Result + #13#10 + #13#10;
  if Screen.ActiveCustomForm <> Screen.ActiveForm then
  begin
    Result := 'Active Custom Form:' + #13#10;
    if Assigned(Screen.ActiveCustomForm) then
      Result := Result + 'Class = ' + Screen.ActiveCustomForm.ClassName + #13#10 +
        'Name = ' + Screen.ActiveCustomForm.Name + #13#10 + 'Caption = ' + Screen.ActiveCustomForm.Caption
    else
      Result := Result + 'none';
  end;
  Result := Result + #13#10 + #13#10 + GetVersionInfo(Application.ExeName);
  Result := Result + #13#10 + #13#10 + 'Exe file: ' + Application.ExeName;
end;

function TKisAppModule.GetFieldValue(ATransaction: TIBTransaction;
  const pTableName, pKeyFieldName, pFieldName: String; const pKeyValue: Variant;
  var pFieldValue: Variant): Boolean;
var
  NeedCommit: Boolean;
begin
  NeedCommit := False;
  with TIBQuery.Create(nil) do
  try
    Forget;
    BufferChunks := 10;
    if Assigned(ATransaction) then
      Transaction := ATransaction
    else
    begin
      Transaction := Pool.Get;
      Transaction.Init(ilReadCommited, amReadOnly); // readonly transaction
    end;
    NeedCommit := not Transaction.Active;
    if NeedCommit then
      Transaction.StartTransaction;
    SQL.Add('SELECT ' + pFieldName + ' FROM ' + pTableName + ' WHERE ' + pKeyFieldName + '=:PPP');
    Params[N_ZERO].Value := pKeyValue;
    Open;
    Result := not IsEmpty;
    if Result then
      pFieldValue := Fields[N_ZERO].Value;
    Close;
  finally
    if NeedCommit then
      Transaction.Commit;
    if not Assigned(ATransaction) then
      Pool.Back(Transaction);
  end;
end;

function TKisAppModule.GetID(const GeneratorName: String;
  ATransaction: TIBTransaction; const NameIsFull: Boolean = False): Integer;
var
  GenName: String;
begin
  with TIBQuery.Create(nil) do
  try
    Forget;
    BufferChunks := 1;
    if Assigned(ATransaction) then
      Transaction := ATransaction
    else
    begin
      Transaction := Pool.Get;
      Transaction.Init(ilReadCommited, amReadOnly); // readonly transaction
      Transaction.AutoStopAction := saNone;
      Transaction.StartTransaction;
    end;
    //
    GenName := GeneratorName;
    if not NameIsFull then
      GenName := GenName + '_GEN';
    //
    SQL.Add('SELECT GEN_ID(' + GenName + ', 1) FROM RDB$DATABASE');
    Open;
    Result := Fields[N_ZERO].AsInteger;
    Close;
  finally
    if not Assigned(ATransaction) then
    begin
      Transaction.Commit;
      Pool.Back(Transaction);
    end;
  end;
end;

procedure TKisAppModule.DataModuleDestroy(Sender: TObject);
begin
  FMngrs.Free;
  FIni.Free;
  FUser.Free;
end;

procedure TKisAppModule.DeleteDocInWork(const DocNumber: string);
begin
  with TIBQuery.Create(Self) do
  try
    Forget;
    SQL.Text := SQ_DELETE_DOC_IN_WORK;
    Params[0].AsString := DocNumber;
    Transaction := Pool.Get;
    Transaction.Init(ilReadCommited, amReadWrite);
    Transaction.StartTransaction;
    ExecSQL;
  finally
    if Transaction.Active then
      Transaction.Commit;
    Pool.Back(Transaction);
  end;
end;

function TKisAppModule.ReadAppParam(const SectionName, PropertyName: String;
  DataType: Integer): Variant;
begin
  case DataType of
    varSmallInt, varInteger, varError, varByte:
      Result := FIni.ReadInteger(SectionName, PropertyName, N_ZERO);
    varSingle, varDouble, varCurrency:
      Result := FIni.ReadFloat(SectionName, PropertyName, N_ZERO);
    varDate:
      Result := FIni.ReadDateTime(SectionName, PropertyName, N_ZERO);
    varOleStr, varStrArg, varString, varVariant:
      Result := FIni.ReadString(SectionName, PropertyName, '');
    varBoolean:
      Result := FIni.ReadBool(SectionName, PropertyName, False);
  end;
end;

function TKisAppModule.ReadAppParamDef(const SectionName, PropertyName: String;
  DataType: Integer; const DefaultValue: Variant): Variant;
begin
  case DataType of
    varSmallInt, varInteger, varError, varByte:
      Result := FIni.ReadInteger(SectionName, PropertyName, DefaultValue);
    varSingle, varDouble, varCurrency:
      Result := FIni.ReadFloat(SectionName, PropertyName, DefaultValue);
    varDate:
      Result := FIni.ReadDateTime(SectionName, PropertyName, DefaultValue);
    varOleStr, varStrArg, varString, varVariant:
      Result := FIni.ReadString(SectionName, PropertyName, DefaultValue);
    varBoolean:
      Result := FIni.ReadBool(SectionName, PropertyName, DefaultValue);
  end;
end;

function TKisAppModule.SaveAppParam(const SectionName, PropertyName: String;
  const Value: Variant): Boolean;
begin
  Result := True;
  try
    case VarType(Value) of
    varSmallInt, varInteger, varError, varByte, 19:
      FIni.WriteInteger(SectionName, PropertyName, Value);
    varSingle, varDouble, varCurrency:
      FIni.WriteFloat(SectionName, PropertyName, Value);
    varDate:
      FIni.WriteDateTime(SectionName, PropertyName, Value);
    varOleStr, varStrArg, varString:
      FIni.WriteString(SectionName, PropertyName, Value);
    varBoolean:
      FIni.WriteBool(SectionName, PropertyName, Value);
    else
      Result := False;
    end;
  except
    Result := False;
  end;
end;

function TKisAppModule.ReadAppParam(AOwner: TComponent; Component: TComponent;
  const PropertyName: String; DataType: Integer;
  UseComponentName: Boolean = False): Variant;
var
  _Owner: TComponent;
  SectionName: string;
begin
  if not Assigned(AOwner) then
    _Owner := Component.Owner
  else
    _Owner := AOwner;
  if _Owner = nil then
    raise Exception.Create(S_CANT_WRITE_VALUE)
  else
  begin
    if UseComponentName then
      SectionName := _Owner.Name + ': ' + Component.Name
    else
      SectionName := _Owner.Name + ': ' + Component.ClassName;
    case DataType of
      varSmallInt, varInteger, varError, varByte:
        Result:= FIni.ReadInteger(SectionName, PropertyName, N_ZERO);
      varSingle, varDouble, varCurrency:
        Result:= FIni.ReadFloat(SectionName, PropertyName, N_ZERO);
      varDate:
        Result:= FIni.ReadDateTime(SectionName, PropertyName, N_ZERO);
      varOleStr, varStrArg, varString:
        Result:= FIni.ReadString(SectionName, PropertyName, '');
      varBoolean:
        Result:= FIni.ReadBool(SectionName, PropertyName, False);
    end;
  end;
end;

function TKisAppModule.SaveAppParam(AOwner, Component: TComponent;
  const PropertyName: String; const Value: Variant;
  UseComponentName: Boolean = False): Boolean;
var
  _Owner: TComponent;
  SectionName: String;
begin
  Result := True;
  if Assigned(AOwner) then
    _Owner := AOwner
  else
    _Owner := Component.Owner;
  if _Owner = nil then
  begin
    raise Exception.Create(S_CANT_WRITE_VALUE)
  end
  else
    try
      if UseComponentName then
        SectionName := _Owner.Name + ': ' + Component.Name
      else
        SectionName := _Owner.Name + ': ' + Component.ClassName;
      case VarType(Value) of
        varSmallInt, varInteger, varError, varByte, 19:
          FIni.WriteInteger(SectionName, PropertyName, Value);
        varSingle, varDouble, varCurrency:
          FIni.WriteFloat(SectionName, PropertyName, Value);
        varDate:
          FIni.WriteDateTime(SectionName, PropertyName, Value);
        varOleStr, varStrArg, varString:
          FIni.WriteString(SectionName, PropertyName, Value);
        varBoolean:
          FIni.WriteBool(SectionName, PropertyName, Value);
      else
        FIni.WriteString(SectionName, PropertyName, Value);
      end;
    except
      Result := False;
    end;
end;

function TKisAppModule.Config: Boolean;
begin
  with TConfigForm.Create(Application) do
  try
    edtDatabase.Text := Self.Database.DatabaseName;
//    udLettersNumber.Position := Self.ReadAppParam(PARAM_LETTERS, PARAM_NUMBER_ORDER, N_ZERO);
    uCommonUtils.SetLayout(loEng);
    Result := ShowModal = mrOK;
    if Result then
    begin
      Logon(edtDatabase.Text);
    end;
  finally
    Release;
  end;
end;

procedure TKisAppModule.ReadGridProperties(AOwner: TComponent; Grid: TDBGrid);
var
  I, I1: Integer;
  S: String;
  Clmns: TStringList;
  OnlyOneGrid: Boolean;
begin
  OnlyOneGrid := HasOnlyOneGrid(AOwner);
  with Grid do
    try
      Clmns := IObject(TStringList.Create).AObject as TStringList;
      for I := N_ZERO to Pred(Columns.Count) do
      begin
        S := ReadAppParam(AOwner, Grid, PROP_COL + Columns[I].FieldName,
          varString, not OnlyOneGrid);
        I1 := Pos(',', S);
        if (I1 > N_ZERO) then
          Clmns.AddObject(PROP_COL + Columns[I].FieldName + '=' +
            Copy(S, N_ONE, Pred(I1)),
            Pointer(StrToInt(Trim(Copy(S, Succ(I1), Length(S) - I1)))));
      end;
      for I := N_ZERO to Pred(Columns.Count) do
      begin
        S := Clmns.Values[PROP_COL + Columns[I].FieldName];
        if S <> '' then
          if StrToInt(S) < Columns.Count then
          try
            Grid.Columns.Items[I].Index := StrToInt(S);
          except
          end;
      end;
      for I := 0 to Pred(Columns.Count) do
      begin
        I1 := Clmns.IndexOfName(PROP_COL + Columns[I].FieldName);
        if (I1 >= 0) and (I1 < Columns.Count) then
        try
          Grid.Columns.Items[I].Width := Integer(Clmns.Objects[I1]);
        except
        end;
      end;
    except
    end;
end;

procedure TKisAppModule.WriteGridProperties(AOwner: TComponent; Grid: TDBGrid);
var
  I: Integer;
  OnlyOneGrid: Boolean;
begin
  OnlyOneGrid := HasOnlyOneGrid(AOwner);
  with Grid do
    for I := 0 to Pred(Columns.Count) do
      SaveAppParam(AOwner, Grid, PROP_COL + Columns[I].FieldName,
        IntToStr(Columns[I].Index) + ',' + IntToStr(Columns[I].Width), not OnlyOneGrid);
end;

function TKisAppModule.GetMngr(Ident: TKisMngrs): TKisMngr;
var
  I: Integer;
begin
  for I := 0 to Pred(FMngrs.Count) do
    if TKisMngr(FMngrs[I]).Ident = Ident then
    begin
      Result := FMngrs[I];
      Exit;
    end;
  Result := KisMngrFactory.CreateMngr(Ident);
end;


function TKisAppModule.GetSQLMngr(Ident: TKisMngrs): TKisSQLMngr;
begin
  Result := GetMngr(Ident) as TKisSQLMngr;
end;

function TKisAppModule.GetList(ListIndex: TKisListIndex): TStringList;
var
  aSQL: String;
begin
  case ListIndex of
  klArchDocType :       ASQL := SQ_ARCH_DOC_TYPE_LIST;
  klChiefDocType :      ASQL := SQ_CHIEF_DOC_TYPES_LIST;
  klChiefDocType2 :     ASQL := SQ_CHIEF_DOC_TYPES_LIST2;
  klCountries :         ASQL := SQ_COUNTRIES_LIST;
  klDecreePrjStates :   ASQL := SQ_DECREE_PRJ_STATES_LIST;
  klLicensedOrg :       ASQL := SQ_LICENSED_ORG_LIST;
  klMapCasesBasis :     aSQL := SQ_GET_MAP_CASES_BASIS_LIST;
  klOfficeDocTypes :    ASQL := SQ_OFFICE_DOC_TYPES_LIST;
  klOffices :           ASQL := SQ_OFFICES;
  klOriginOrgs :        ASQL := SQ_ORIGIN_ORGS_LIST;
  klPersonDoc :         ASQL := SQ_PERSON_DOC_TYPES_LIST;
  klPersonDocOwner :    ASQL := SQ_PERSON_DOC_OWNER_LIST;
  klPunktType1 :        ASQL := SQ_GPUNKT_TYPE1_LIST;
  klPunktType2 :        ASQL := SQ_GPUNKT_TYPE2_LIST;
  klRegions :           ASQL := SQ_REGIONS_LIST;
  klSignatures :        ASQL := SQ_SIGNATURES_LIST;
  klStates :            ASQL := SQ_STATES_LIST;
  klStreetMark :        ASQL := SQ_STREET_MARK_LIST;
  klSubdivision :       ASQL := SQ_ORG_SUBDIV_TYPES_LIST;
  klTownKind :          ASQL := SQ_TOWN_KIND_LIST;
  klVillages :          ASQL := SQ_VILLAGES_LIST;
  else
    begin
      Result := nil;
      Exit;
    end;
  end;
  Result := TStringList.Create;
  with TIBQuery.Create(Self) do
  try
    Forget;
    BufferChunks := 100;
    SQL.Text := aSQL;
    Transaction := Pool.Get;
    Transaction.Init(ilReadCommited, amReadOnly);
    Transaction.StartTransaction;
    Open;
    while not Eof do
    begin
      if Fields.Count > 1 then
        Result.AddObject(Fields[1].AsString, Pointer(Fields[0].AsInteger))
      else
        Result.Add(Fields[0].AsString);
      Next;
    end;
  finally
    if Transaction.Active then
      Transaction.Commit;
    Pool.Back(Transaction);
  end;
end;

procedure TKisAppModule.GetLookupValues(ATransaction: TIBTransaction;
  const pTableName, pKeyFieldName, pValueFieldName: String; Values: TStrings);
var
  NeedCommit: Boolean;
begin
  NeedCommit := False;
  with TIBQuery.Create(Self) do
  try
    Forget;
    BufferChunks := 10;
    if Assigned(ATransaction) then
      Transaction := ATransaction
    else
    begin
      Transaction := Pool.Get;
      Transaction.Init(ilReadCommited, amReadOnly); // readonly transaction
    end;
    NeedCommit := not Transaction.Active;
    if NeedCommit then
      Transaction.StartTransaction;
    SQL.Add('SELECT ' + pKeyFieldName + ', ' + pValueFieldName + ' FROM ' + pTableName);
    Open;
    Values.Clear;
    while not Eof do
    begin
      Values.AddObject(Fields[1].AsString, Pointer(Fields[0].AsInteger));
      Next;
    end;
    Close;
  finally
    if NeedCommit then
      Transaction.Commit;
    if not Assigned(ATransaction) then
      Pool.Back(Transaction);
  end;
end;

type
  THackComponent = class(TComponent);

procedure TKisAppModule.ReadFormPosition(AOwner: TComponent; Form: TForm);
const
  Delims = [',', ' '];
var
  Placement: TWindowPlacement;
  WinState: TWindowState;
  PPP: Integer;
begin
  Placement.Length := SizeOf(TWindowPlacement);
  GetWindowPlacement(Form.Handle, @Placement);
  with Placement, TForm(Form) do
  begin
    if not IsWindowVisible(Form.Handle) then
      ShowCmd := SW_HIDE;
    Flags := ReadAppParam(AOwner, Form, 'Flags', varInteger);
    // Form Position
    ptMinPosition.X := ReadAppParam(AOwner, Form, 'MinPositionX', varInteger);
    ptMinPosition.Y := ReadAppParam(AOwner, Form, 'MinPositionY', varInteger);
    ptMaxPosition.X := ReadAppParam(AOwner, Form, 'MaxPositionX', varInteger);
    ptMaxPosition.Y := ReadAppParam(AOwner, Form, 'MaxPositionY', varInteger);

    rcNormalPosition.Left := ReadAppParam(AOwner, Form, 'NormalPositionL', varInteger);
    rcNormalPosition.Top := ReadAppParam(AOwner, Form, 'NormalPositionT', varInteger);
    rcNormalPosition.Right := ReadAppParam(AOwner, Form, 'NormalPositionR', varInteger);
    rcNormalPosition.Bottom := ReadAppParam(AOwner, Form, 'NormalPositionB', varInteger);

    PPP := ReadAppParam(AOwner, Form, 'Pixels', varInteger);
    if Screen.PixelsPerInch = PPP then
    begin
      if not (BorderStyle in [bsSizeable, bsSizeToolWin]) then
        rcNormalPosition := Rect(rcNormalPosition.Left, rcNormalPosition.Top,
          rcNormalPosition.Left + Width, rcNormalPosition.Top + Height);
      if rcNormalPosition.Right > rcNormalPosition.Left then
      begin
        if (Position in [poScreenCenter, poDesktopCenter]) and
          not (csDesigning in ComponentState) then
        begin
          THackComponent(Form).SetDesigning(True);
          try
            Position := poDesigned;
          finally
            THackComponent(Form).SetDesigning(False);
          end;
        end;
        SetWindowPlacement(Handle, @Placement);
      end;
    end;
    // Form State
    WinState := wsNormal;
    ShowCmd := ReadAppParam(AOwner, Form, 'ShowCmd', varInteger);
    case ShowCmd of
      SW_SHOWNORMAL, SW_RESTORE, SW_SHOW:
        WinState := wsNormal;
      SW_MINIMIZE, SW_SHOWMINIMIZED, SW_SHOWMINNOACTIVE:
        WinState := wsNormal;
      SW_MAXIMIZE:
        WinState := wsMaximized;
    end;
    if (WinState = wsMinimized)
       and
       ((Form = Application.MainForm) or (Application.MainForm = nil))
    then
    begin
      PostMessage(Application.Handle, WM_SYSCOMMAND, SC_MINIMIZE, 0);
      Exit;
    end;
      WindowState := WinState;
    Update;
  end;
end;

procedure TKisAppModule.WriteFormPosition(AOwner: TComponent; Form: TForm);
var
  Placement: TWindowPlacement;
begin
  if Assigned(Form) then
  begin
    Placement.Length := SizeOf(TWindowPlacement);
    GetWindowPlacement(Form.Handle, @Placement);
    with Placement, TForm(Form) do
    begin
      if (Form = Application.MainForm) and IsIconic(Application.Handle) then
        ShowCmd := SW_SHOWMINIMIZED;
//      if (FormStyle = fsMDIChild) and (WindowState = wsMinimized) then
//        Flags := Flags or WPF_SETMINPOSITION;
      SaveAppParam(AOwner, Form, 'Flags', Flags);
      SaveAppParam(AOwner, Form, 'ShowCmd', ShowCmd);
      SaveAppParam(AOwner, Form, 'Pixels', Screen.PixelsPerInch);
      
      SaveAppParam(AOwner, Form, 'MinPositionX', ptMinPosition.X);
      SaveAppParam(AOwner, Form, 'MinPositionY', ptMinPosition.Y);
      SaveAppParam(AOwner, Form, 'MaxPositionX', ptMaxPosition.X);
      SaveAppParam(AOwner, Form, 'MaxPositionY', ptMaxPosition.Y);

      SaveAppParam(AOwner, Form, 'NormalPositionL', rcNormalPosition.Left);
      SaveAppParam(AOwner, Form, 'NormalPositionT', rcNormalPosition.Top);
      SaveAppParam(AOwner, Form, 'NormalPositionR', rcNormalPosition.Right);
      SaveAppParam(AOwner, Form, 'NormalPositionB', rcNormalPosition.Bottom);
    end;
  end;
end;

function TKisAppModule.PeolpeList(OfficeId: Integer): TStringList;
begin
  Result := TStringList.Create;
  with TIBQuery.Create(nil) do
  try
    Forget;
    BufferChunks := 100;
    SQL.Text := SQ_GET_PEOPLE_BY_OFFICE_ID;
    Params[0].AsInteger := OfficeId;
    Transaction := Pool.Get;
    Transaction.Init(ilReadCommited, amReadOnly);
    Transaction.StartTransaction;
    Open;
    while not Eof do
    begin
      Result.AddObject(Fields[N_ONE].AsString, Pointer(Fields[N_ZERO].AsInteger));
      Next;
    end;
  finally
    if Transaction.Active then
      Transaction.Commit;
    Pool.Back(Transaction);
  end;
end;

function TKisAppModule.ExecutionPhaseList(OfficeId: Integer): TStringList;
begin
  Result := TStringList.Create;
  with TIBQuery.Create(nil) do
  try
    Forget;
    BufferChunks := 10;
    SQL.Text := SQ_GET_PHASES_BY_OFFICE_ID;
    Params[0].AsInteger := OfficeId;
    Transaction := Pool.Get;
    Transaction.Init(ilReadCommited, amReadOnly);
    Transaction.StartTransaction;
    Open;
    while not Eof do
    begin
      Result.AddObject(Fields[1].AsString, Pointer(Fields[0].AsInteger));
      Next;
    end;
    Close;
  finally
    if Transaction.Active then
      Transaction.Commit;
    Pool.Back(Transaction);
  end;
end;

function TKisAppModule.ExistsDocInWork(const DocNumber: string): Boolean;
begin
  with TIBQuery.Create(Self) do
  try
    Forget;
    BufferChunks := 100;
    SQL.Text := SQ_SELECT_DOC_IN_WORK;
    Params[0].AsString := DocNumber;
    Transaction := Pool.Get;
    Transaction.Init(ilReadCommited, amReadOnly);
    Transaction.StartTransaction;
    Open;
    Result := RecordCount > 0;
    Close;
  finally
    if Transaction.Active then
      Transaction.Commit;
    Pool.Back(Transaction);
  end;
end;

function TKisAppModule.FieldValues(const aTableName, aFieldName: String): TStringList;
begin
  Result := TStringList.Create;
  with TIBQuery.Create(Self) do
  try
    Forget;
    BufferChunks := 10;
    SQL.Text := Format(SQ_FIELD_VALUES, [aFieldName, aTableName]);
    Transaction := Pool.Get;
    Transaction.Init(ilReadCommited, amReadOnly);
    Transaction.StartTransaction;
    Open;
    while not Eof do
    begin
      Result.Add(Fields[0].AsString);
      Next;
    end;
    Close;
  finally
    if Transaction.Active then
      Transaction.Commit;
    Pool.Back(Transaction);
  end;
end;

procedure TKisAppModule.ApplicationEventsException(Sender: TObject; E: Exception);
var
  Handled: Boolean;
begin
  Handled := False;
  uIBXUtils.HandleIBXException(E, Handled);
  if not Handled then
    if HandleIBXDisconnect(E) then
    begin
      CriticalError := True;
    end
    else
    begin
      if (E is EIBInterBaseError) then
      with E as EIBInterBaseError do
      if  (IBErrorCode <> 335544345) and (SQLCode <> -901) then
        E.Message := E.Message
        + #13#10 + 'SQLCode: ' + IntToStr(EIBInterBaseError(E).SQLCode)
        + #13#10 + 'IBErrorCode: ' + IntToStr(EIBInterBaseError(E).IBErrorCode);
      if not (E is EAbort) then
      begin
        LogException(E, GetDebugInfo);
        Application.ShowException(E);
      end;
    end;
end;

function TKisAppModule.AppTempPath: string;
begin
  Result := FAppTempPath;
end;

function TKisAppModule.Connect(const UserId: Integer; const UserName,
  RoleName, Password: String): Boolean;
begin
  try
    Database.Close;
    Database.CurrentUserName := UserName;
    Database.Password := Password;
    Database.CurrentRole := RoleName;
    Database.Open;
    User.PeopleId := UserId;
    if FUseINIFile then
    begin
      SaveAppParam(S_CONNECTION_SECTION, 'LastOffice', FUser.OfficeID);
      SaveAppParam(S_CONNECTION_SECTION, 'LastUser', FUser.PeopleId);
    end;
    Result := True;
  except
    Application.HandleException(Self);
    Database.Close;
    ConnectAsGuest;
    Result := False;
  end;
end;

procedure TKisAppModule.ReadLastUser(var OfficeID, UserId: Integer);
begin
  if FUseINIFile then
  begin
    OfficeID := ReadAppParam(S_CONNECTION_SECTION, 'LastOffice', varInteger);
    UserId := ReadAppParam(S_CONNECTION_SECTION, 'LastUser', varInteger);
  end;
end;

function TKisAppModule.ReportsPath: string;
begin
  Result := FReportPath;
end;

function TKisAppModule.DocTypeList(OrgId, Incoming: Integer): TStringList;
begin
  Result := TStringList.Create;
  with TIBQuery.Create(nil) do
  try
    Forget;
    BufferChunks := 30;
    SQL.Text := SQ_GET_DOC_TYPES_BY_ORG_ID;
    Params[0].AsInteger := OrgId;
    Params[1].AsInteger := Incoming;
    Transaction := Pool.Get;
    Transaction.Init(ilReadCommited, amReadOnly);
    Transaction.StartTransaction;
    Open;
    while not Eof do
    begin
      Result.AddObject(Fields[N_ONE].AsString, Pointer(Fields[N_ZERO].AsInteger));
      Next;
    end;
  finally
    if Transaction.Active then
      Transaction.Commit;
    Pool.Back(Transaction);
  end;
end;

function TKisAppModule.OfficesList(OrgId: Integer): TStrings;
begin
  Result := TStringList.Create;
  with TIBQuery.Create(nil) do
  try
    Forget;
    BufferChunks := 10;
    SQL.Text := Format(SQ_GET_OFFICES_BY_ORG_ID, [OrgId]);
    Transaction := Pool.Get;
    Transaction.Init(ilReadCommited, amReadOnly);
    Transaction.StartTransaction;
    Open;
    while not Eof do
    begin
      Result.AddObject(Fields[N_ONE].AsString, Pointer(Fields[N_ZERO].AsInteger));
      Next;
    end;
  finally
    if Transaction.Active then
      Transaction.Commit;
    Pool.Back(Transaction);
  end;
end;

procedure TKisAppModule.SetCriticalError(const Value: Boolean);
begin
  FCriticalError := Value;
  if FCriticalError then
  begin
    if not DataBase.TestConnected then
    begin
      try
        Database.Close;
      except
      end;
      MessageBox(KisMainView.Handle, PChar('Продолжение работы не возможно!'), PChar('Внимание'),
         MB_OK + MB_ICONERROR);
      Application.Terminate;
    end;
  end;
end;

procedure TKisAppModule.SQLErrorHandler;
var
  Esql: ESQLException;
begin
  Esql := ESQLException.Create(E, OldSQL);
  Esql.SQL := NewSQL;
  raise Esql;
end;

function TKisAppModule.SQLLogPath: string;
begin
  Result := FSQLLogPath;
end;

function TKisAppModule.ThreadCount: Byte;
begin
  Result := FCoreCount;
end;

procedure TKisAppModule.CreateAlertWindow;
begin
  if not Assigned(FAlertWindow) then
    FAlertWindow := TForm.Create(Self);
  FAlertWindow.OnClose := CloseAlertWindow;
  with FAlertWindow do
  begin
    BorderStyle := bsToolWindow;
    FormStyle := fsStayOnTop;
    AlphaBlendValue := 220;
    AlphaBlend := true;
    Height := 110;
    Width := 150;
    Left := Application.MainForm.Width - Application.MainForm.Left - Width - 10;
    Top := Application.MainForm.Height - Application.MainForm.Top - Height - 10;
    InsertControl(TLabel.Create(FAlertWindow));
    with Controls[0] as TLabel do
    begin
      Align := alClient;
      AutoSize := false;
      Alignment := taCenter;
      LayOut := tlCenter;
      WordWrap := True;
    end;
  end;
end;

procedure TKisAppModule.AddDocInWork(const DocNumber: string);
begin
  with TIBQuery.Create(Self) do
  try
    Forget;
    BufferChunks := 10;
    SQL.Text := SQ_ADD_DOC_IN_WORK;
    Params[0].AsString := DocNumber;
    Transaction := Pool.Get;
    Transaction.Init(ilReadCommited, amReadWrite);
    Transaction.StartTransaction;
    ExecSQL;
  finally
    if Transaction.Active then
      Transaction.Commit;
    Pool.Back(Transaction);
  end;
end;

procedure TKisAppModule.Alert(const Message: String);
begin
  if Assigned(OnAlert) then
    OnAlert(Self, Message)
  else
  begin
    CreateAlertWindow;
    TLabel(FAlertWindow.Controls[0]).Caption := Message;
    TLabel(FAlertWindow.Controls[0]).Font.Color := clRed;
    FAlertWindow.Show;
    Windows.Beep(440, 300);
  end;
end;

procedure TKisAppModule.ClearTempFiles;
begin
  TFileUtils.ClearDirectory(FAppTempPath);
  RemoveDir(FAppTempPath);
end;

procedure TKisAppModule.CloseAlertWindow(Sender: TObject; var Action: TCloseAction);
begin
  Action := caFree;
  FAlertWindow := nil;
end;

procedure TKisAppModule.LogError(const aMessage, aClassName, aNativeMessage,
  aNativeClassName, anObjectInfo: String; Info: TStrings);
begin
  if Database.Connected then
  begin
    with TIBQuery.Create(Self) do
    try
      Forget;
      Transaction := Pool.Get;
      Transaction.Init(ilReadCommited, amWriteOnly);
      SQL.Text := SQ_LOG_ERROR;
      Params[0].AsString := aMessage;
      Params[1].AsString := aClassName;
      if Assigned(Info) then
        Params[4].AsBlob := Info.Text;
      Params[2].AsString := aNativeMessage;
      Params[3].AsString := aNativeClassName;
      Params[5].AsBlob := anObjectInfo;
      ExecSQL;
    finally
      if Transaction.Active then
        Transaction.Commit;
      Pool.Back(Transaction);
    end;
  end;
  if Assigned(Info) then
    Info.Free;
end;

procedure TKisAppModule.LogException(E: Exception; Info: TStrings);
var
  AppInfo: String;
begin
  if Database.Connected then
  begin
    AppInfo := GetAppInfo;
    with TIBQuery.Create(Self) do
    try
      Forget;
      Transaction := Pool.Get;
      Transaction.Init(ilReadCommited, amWriteOnly);
      SQL.Text := SQ_LOG_ERROR;
      Params[0].AsString := E.Message;
      Params[1].AsString := E.ClassName;
      if Assigned(Info) then
        Params[4].AsBlob := Info.Text;
      if E is EKisException then
      begin
        Params[2].AsString := EKisException(E).NativeMessage;
        Params[3].AsString := EKisException(E).NativeClassName;
        Params[5].AsBlob := EKisException(E).ObjectInfo + AppInfo;
      end
      else
        Params[5].AsBlob := AppInfo;
      ExecSQL;
    finally
      if Transaction.Active then
        Transaction.Commit;
      Pool.Back(Transaction);
    end;
  end;
  if Assigned(Info) then
    Info.Free;
end;

function TKisAppModule.OfficeDocTypesList(OfficeId: Integer): TStrings;
begin
  Result := TStringList.Create;
  with TIBQuery.Create(nil) do
  try
    Forget;
    BufferChunks := 20;
    SQL.Text := SQ_GET_OFFICE_DOC_TYPES_BY_OFFICE_ID;
    Params[0].AsInteger := OfficeId;
    Transaction := Pool.Get;
    Transaction.Init(ilReadCommited, amReadOnly);
    Transaction.StartTransaction;
    Open;
    while not Eof do
    begin
      Result.AddObject(Fields[N_ONE].AsString, Pointer(Fields[N_ZERO].AsInteger));
      Next;
    end;
  finally
    if Transaction.Active then
      Transaction.Commit;
    Pool.Back(Transaction);
  end;
end;

function TKisAppModule.ObjectTypesList(OfficeId: Integer): TStrings;
begin
  Result := TStringList.Create;
  with TIBQuery.Create(nil) do
  try
    Forget;
    BufferChunks := 10;
    SQL.Text := SQ_GET_OBJECT_TYPES_BY_OFFICE_ID;
    Params[0].AsInteger := OfficeId;
    Transaction := Pool.Get;
    Transaction.Init(ilReadCommited, amReadOnly);
    Transaction.StartTransaction;
    Open;
    while not Eof do
    begin
      Result.AddObject(Fields[N_ONE].AsString, Pointer(Fields[N_ZERO].AsInteger));
      Next;
    end;
    Close;
  finally
    if Transaction.Active then
      Transaction.Commit;
    Pool.Back(Transaction);
  end;
end;

initialization
  KisMngrFactory := TKisMngrFactory.Create;
  JclStartExceptionTracking;
/// ed
  DecimalSeparator := ',';
///
finalization
  KisMngrFactory.Free;

end.


