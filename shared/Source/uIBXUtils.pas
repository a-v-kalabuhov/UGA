{*******************************************************}
{                                                       }
{       "Утилиты"                                       }
{       Interbase Express Components Utilities Unit     }
{                                                       }
{       Copyright (c) 2004, Калабухов А.В.              }
{                                                       }
{       Автор: Калабухов А.В.                           }
{                                                       }
{*******************************************************}

{ Описание:
  Имя модуля: Interbase Express Utils
  Версия: 1.3
  Дата последнего изменения: 27.07.2004
  Цель: содержит утилиты для работы с компонентами IBX
  Используется: проект KIS
  Использует:
  Исключения:
  Вывод в БД:
  Вывод:
  До вызова:
  После вызова:   }
unit uIBXUtils;

interface

{$DEFINE TESTING}

uses
  SysUtils, Classes, Math,
  IBDatabase, IBQuery,
  uGC, uClasses, uDB, uSQL;

type
  TIBIsolationLevel = (ilReadCommited, ilReadCommitedNoRecVersion,
    ilSnapShot, ilSnapShotTableStability);
  TIBAccessMode = (amReadOnly, amReadWrite, amWriteOnly);
  TIBLockMode = (lmWait, lmNoWait);

const
  DefPoolSize = 10;

type
  TTransactionRec = record
    Transaction: TIBTransaction;
    InUse: Boolean;
  end;

  TPoolDefaultBackAction = (daCommit, daRollBack);

  TIBTransactionPool = class(TComponent)
  private
    FItems: array of TTransactionRec;
    FDatabase: TIBDatabase;
    FDefAction: TPoolDefaultBackAction;
    function IndexOf(Transaction: TIBTransaction): Integer;
  public
    constructor Create(AOwner: TComponent; Database: TIBDatabase;
      PoolSize: Integer = DefPoolSize); reintroduce;
    destructor Destroy; override;
    function Get: TIBTransaction;
    procedure Back(Transaction: TIBTransaction);
    function Size: Integer;
    property DefaultBackAction: TPoolDefaultBackAction read FDefAction
      write FDefAction;
  end;

const
  S_SYSDBA = 'SYSDBA';
  S_ADMINISTRATOR = 'ADMINISTRATOR';
  S_PUBLIC = 'PUBLIC';
  S_GUEST = 'GUEST';
  S_ERROR = 'Ошибка!';
  S_BAD_PASSWORD = 'Неверное имя пользователя или пароль';
  S_BAD_CONNECTION_STRING = 'Невозможно соединиться с базой данных.'
    + #13 + 'Необходимо проверить настройки соединения.'
    + #13 + 'Обратитесь к администратору.';
  S_ACCESS_DENIED = 'Отказано в доступе.' + #13 + 'Обратитесь к администратору.';
  S_LOCK_CONFLICT = 'Данные заблокированы другим польователем!';
  S_OP = 'Операция: ';
  S_OBJ = 'Объект: ';
  S_POOL_BUSY = 'Pool is busy!';

  S_IBDB_PARAM_USERNAME = 'user_name';
  S_IBDB_PARAM_PASSWORD = 'password';
  S_IBDB_PARAM_CHARSET = 'lc_ctype';

type
  TIBTransactionHelper = class helper for TIBTransaction
  public
    procedure Init(
      IsolationLevel: TIBIsolationLevel = ilReadCommited;
      AccessMode: TIBAccessMode = amReadWrite;
      LockMode: TIBLockMode = lmNoWait);
    function CanRead(): Boolean;
    function CanWrite(): Boolean;
  end;

  TIBDatabaseHelper = class helper for TIBDatabase
  private
    function GetPassword(): String;
    procedure SetPassword(const Value: String);
    function GetCurrentUserName(): String;
    procedure SetCurrentUserName(const Value: String);
    function GetCurrentRole(): String;
    procedure SetCurrentRole(const Value: String);
  public
    function UserIsAdministrator(): Boolean;
    property CurrentRole: string read GetCurrentRole write SetCurrentRole;
    property CurrentUserName: string read GetCurrentUserName write SetCurrentUserName;
    property Password: string read GetPassword write SetPassword;
  end;

  TSQLErrorEvent = procedure (E: Exception; const OldSQL, NewSQL: string) of object;

  TIBQueryHelper = class helper for TIBQuery
  public
    function AsSQL: ISQL;
    procedure Reset(NewSQL: TStrings; OnError: TSQLErrorEvent); overload;
    procedure Reset(NewSQL: TStrings; SavePosition: Boolean; OnError: TSQLErrorEvent); overload;
  end;

  // Exception handler
  procedure HandleIBXException(E: Exception; out Handled: Boolean);
  function HandleIBXDisconnect(E: Exception): Boolean;

implementation

uses
  IBHeader, IB, Windows;

const
  S_NOT_TRANSACTION = 'Объект %s невозможно поместить в интерфейс ITransaction';

procedure HandleIBXException(E: Exception; out Handled: Boolean);
var
  S: String;
  I: Integer;
  ErrCode: Integer;
  ErrCode2: Integer;
begin
  Handled := False;
  if E is EIBError then
  begin
    Handled := True;
    ErrCode := EIBError(E).SQLCode;
    ErrCode2 := EIBError(E).IBErrorCode;
    case ErrCode of
    -551 :
      begin
        I := Pos('access', E.Message);
        S := S_ACCESS_DENIED + #13#13;
        S := S + S_OP + Copy(E.Message, 19, I - 19) + #13;
        S := S + S_OBJ + Copy(E.Message, I + 10, Length(E.Message) - I - 9);
        E.Message := S;
      end;
    -901 :
      if ErrCode2 = 335544345 then
        if Pos('Your user name and password are not defined', E.Message) > 0 then
          E.Message := S_BAD_PASSWORD
        else
          E.Message := S_LOCK_CONFLICT + sLineBreak  + sLineBreak + E.Message;
    -902 :
      case ErrCode2 of
      335544476, 335544471: // обрыв соединения
        ;
      335544472:
        E.Message := S_BAD_PASSWORD;
      335544344 :
        E.Message := S_BAD_CONNECTION_STRING;
      else
        begin
          Handled := False;
          Beep(440, 1000);
        end;
      end;
    end;
  end;
end;

function HandleIBXDisconnect(E: Exception): Boolean;
begin
  Result := False;
  if E is EIBError then
  with E as EIBError do
  case SQLCode of
  -902 :
    case IBErrorCode of
    335544476, 335544471, 335544721: // обрыв соединения
      begin
        Result := True;
        MessageBox(0, PChar('Соединение с сервером потеряно!'#13#10'Часть данных может быть не сохранена!'),
          PChar(S_ERROR), MB_OK + MB_ICONSTOP);
      end;
    end;
  end;
end;

{ TIBTransactionPool }

procedure TIBTransactionPool.Back(Transaction: TIBTransaction);
var
  I: Integer;
begin
  I := IndexOf(Transaction);
  if (I >= 0) and FItems[I].InUse then
  begin
    if FItems[I].Transaction.Active then
      if FDefAction = daRollBack then
        FItems[I].Transaction.Rollback
      else
        FItems[I].Transaction.Commit;
    FItems[I].InUse := False;
  end;
end;

constructor TIBTransactionPool.Create(AOwner: TComponent; Database: TIBDatabase;
  PoolSize: Integer = 10);
var
  I: Integer;
begin
  inherited Create(AOwner);
  FDatabase := Database;
  SetLength(FItems, PoolSize);
  for I := 0 to Pred(PoolSize) do
  begin
    FItems[I].Transaction := TIBTransaction.Create(Self);
    FItems[I].Transaction.DefaultDatabase := Database;
    FItems[I].Transaction.Init(ilReadCommited, amReadWrite);
    FItems[I].InUse := False;
  end;
  FDefAction := daRollBack;
end;

destructor TIBTransactionPool.Destroy;
var
  I, L, H: Integer;
begin
  L := Low(FItems);
  H := High(FItems);
  for I := L to H do
    FItems[I].Transaction.Free;
end;

function TIBTransactionPool.Get: TIBTransaction;
var
  I, H, L: Integer;
begin
  Result := nil;
  L := Low(FItems);
  H := High(FItems);
  for I := L to H do
  if not FItems[I].InUse then
  begin
    Result := FItems[I].Transaction;
    FItems[I].InUse := True;
    Exit;
  end;
  if Result = nil then
  begin
    SetLength(FItems, Length(FItems) + 1);
    FItems[High(FItems)].Transaction := TIBTransaction.Create(Self);
    FItems[High(FItems)].Transaction.DefaultDatabase := FDatabase;
    FItems[High(FItems)].InUse := True;
    Result := FItems[High(FItems)].Transaction;
  end;
//    raise EAbort.Create(S_POOL_BUSY);
end;

function TIBTransactionPool.IndexOf(Transaction: TIBTransaction): Integer;
var
  I, L, H: Integer;
begin
  L := Low(FItems);
  H := High(FItems);
  for I := L to H do
  if FItems[I].Transaction = Transaction then
  begin
    Result := I;
    Exit;
  end;
  Result := -1;
end;

function TIBTransactionPool.Size: Integer;
begin
  Result := Length(FItems);
end;

{ TIBTransactionHelper }

function TIBTransactionHelper.CanRead: Boolean;
begin
  Result := True;
end;

function TIBTransactionHelper.CanWrite: Boolean;
begin
  Result := (Self.Params.IndexOf(TPBConstantNames[9]) >= 0)
            or
            (Self.Params.IndexOf(TPBConstantNames[8]) < 0);
end;

procedure TIBTransactionHelper.Init(IsolationLevel: TIBIsolationLevel; AccessMode: TIBAccessMode;
  LockMode: TIBLockMode);
begin
  Self.Params.Clear;
  case AccessMode of
  amReadOnly :
    Self.Params.Add(TPBConstantNames[8]{'read'});
  amWriteOnly :
    Self.Params.Add(TPBConstantNames[9]{'write'});
  amReadWrite :
    begin
      Self.Params.Add(TPBConstantNames[8]{'read'});
      Self.Params.Add(TPBConstantNames[9]{'write'});
    end;
  end;
  case IsolationLevel of
  ilReadCommited :
    begin
      Self.Params.Add(TPBConstantNames[15]{'read_committed'});
      Self.Params.Add(TPBConstantNames[17]{'rec_version'});
    end;
  ilReadCommitedNoRecVersion :
    begin
      Self.Params.Add(TPBConstantNames[15]{'read_committed'});
      Self.Params.Add(TPBConstantNames[18]{'no_rec_version'});
    end;
  ilSnapShot :
    begin
      Self.Params.Add(TPBConstantNames[2]{'concurrency'});
    end;
  ilSnapShotTableStability :
    begin
      Self.Params.Add(TPBConstantNames[8]{'read'});
      Self.Params.Add(TPBConstantNames[1]{'cosistency'});
    end;
  end;
  case LockMode of
  lmWait :
    Self.Params.Add(TPBConstantNames[6]{'wait'});
  lmNoWait :
    Self.Params.Add(TPBConstantNames[7]{'nowait'});
  end;
end;

{ TIBDatabaseHelper }

function TIBDatabaseHelper.GetCurrentRole: String;
begin
  Result := Self.DBParamByDPB[isc_dpb_sql_role_name];
end;

function TIBDatabaseHelper.GetCurrentUserName: String;
begin
  Result := Self.DBParamByDPB[isc_dpb_user_name];
end;

function TIBDatabaseHelper.GetPassword: String;
begin
  Result := Self.DBParamByDPB[isc_dpb_password];
end;

procedure TIBDatabaseHelper.SetCurrentRole(const Value: String);
begin
  Self.DBParamByDPB[isc_dpb_sql_role_name] := Value;
end;

procedure TIBDatabaseHelper.SetCurrentUserName(const Value: String);
begin
  Self.DBParamByDPB[isc_dpb_user_name] := Value;
end;

procedure TIBDatabaseHelper.SetPassword(const Value: String);
begin
  Self.DBParamByDPB[isc_dpb_password] := Value;
end;

function TIBDatabaseHelper.UserIsAdministrator: Boolean;
begin
  Result := ((GetCurrentRole() = S_ADMINISTRATOR)
            or
            (GetCurrentUserName() = S_SYSDBA));
end;

{ TIBQueryHelper }

procedure TIBQueryHelper.Reset(NewSQL: TStrings; OnError: TSQLErrorEvent);
var
  CurActive: Boolean;
  OldSQL: TStrings;
begin
  CurActive := Active;
  DisableControls;
  Active := False;
  OldSQL := TStringList.Create;
  OldSQL.Forget();
  try
    try
      OldSQL.Assign(SQL);
      SQL.Assign(NewSQL);
      Active := CurActive;
    except
      on E: Exception do
      begin
        if Assigned(OnError) then
          OnError(E, OldSQL.Text, NewSQL.Text)
        else
          raise E;
        SQL.Assign(OldSQL);
        Active := CurActive;
      end;
    end;
  finally
    EnableControls;
  end;
end;

function TIBQueryHelper.AsSQL: ISQL;
begin
  Result := TSQLFactory.CreateNew(Self.SQL);
end;

procedure TIBQueryHelper.Reset(NewSQL: TStrings; SavePosition: Boolean; OnError: TSQLErrorEvent);
var
  CurActive: Boolean;
  OldSQL: TStrings;
  CurId: Integer;
begin
  CurId := 0;
  if SavePosition then
    CurId := Self.GetId();
  CurActive := Active;
  DisableControls;
  Active := False;
  OldSQL := TStringList.Create;
  try
    try
      OldSQL.Assign(SQL);
      SQL.Assign(NewSQL);
      Active := CurActive;
    except
      on E: Exception do
      begin
        if Assigned(OnError) then
          OnError(E, OldSQL.Text, NewSQL.Text)
        else
          raise E;
        SQL.Assign(OldSQL);
        Active := CurActive;
      end;
    end;
    Self.LocateId(CurId);
  finally
    OldSQL.Free;
    EnableControls;
  end;
end;

end.
