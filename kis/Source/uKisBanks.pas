{*******************************************************}
{                                                       }
{       "ИС МП УГА"                                     }
{       Менеджер банков                                 }
{                                                       }
{       Copyright (c) 2003, МП УГА                      }
{                                                       }
{       Автор: Калабухов А.В.                           }
{                                                       }
{*******************************************************}

{ Описание: операции с банками.
  Имя модуля: Entity Editor
  Версия: 1.16
  Дата последнего изменения: 16.06.2005
  Цель: содержит классы менеджер банков и банк.
  Используется:
  Использует:   только системные юниты
  Исключения:   }
{
  1.06           16.06.2005
     - исправлен метод TKisBank.Copy
     - исправлен метод TKisBank.IsEmpty

  1.05           14.06.2005
     - избавился от свойства DataParams
     - реализован метод TKisBank.Load и переписан TKisBankMngr.GetEntity с его использованием

  1.04           25.04.2005
     - использованы новые методы для работы с главным датасетом

  1.03           10.03.2005
     - использован новый класс TKisConnection
  1.02
     - метод Reopen удален из-за реализации унаследованного
  1.01
     - для приведениия к единому механизму изменена работа с транзакциями
}

unit uKisBanks;

{$I KisFlags.pas}

interface

uses
  // System
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  DB, ImgList, ActnList, IBCustomDataSet, IBDatabase, Grids,
  // Common
  uGC, uIBXUtils, uSQLParsers, uCommonUtils,
  // Project
  uKisClasses, uKisUtils, uKisSQLClasses, uKisAppModule, uKisConsts, uKisIntf, uKisSearchClasses;


type
  EInvalidBIK = EAbort;
  EInvalidKAccount = EAbort;
  EInvalidTown = EAbort;
  EInvalidBankGroup = EAbort;
  EInvalidName = EAbort;

  TKisBank = class(TKisEntity)
  private
    FBIK: String;
    FBankGroup: SmallInt;
    FKAccount: String;
    FName: String;
    FTown: String;
    procedure SetBIK(const Value: String);
    procedure SetName(const Value: String);
    procedure SetKAccount(const Value: String);
    procedure SetTown(const Value: String);
    procedure SetBankGroup(const Value: SmallInt);
    function GetBankGroup: SmallInt;
    function GetTown: String;
    procedure CheckKAccount(const AKAccount: String);
    procedure CheckName(const AName: String);
    function GetKAccount: String;
    function GetBIK: String;
    function GetName: String;
  protected
    {$IFDEF ENTPARAMS}
    procedure InitParams; override;
    {$ENDIF}
    function GetText: String; override;
  public
    constructor Create(Mngr: TKisMngr); override;
    class function EntityName: String; override;
    function Equals(Entity: TKisEntity): Boolean; override;
    procedure Copy(Source: TKisEntity); override;
    function IsEmpty: Boolean; override;
    procedure Load(DataSet: TDataSet); override;
    property Name: String read GetName write SetName;
    property BIK: String read GetBIK write SetBIK;
    property KAccount: String read GetKAccount write SetKAccount;
    property Town: String read GetTown write SetTown;
    property BankGroup: SmallInt read GetBankGroup write SetBankGroup;
  end;

  TKisBankMngr = class(TKisSQLMngr)
    dsBanks: TIBDataSet;
    dsBanksID: TIntegerField;
    dsBanksNAME: TIBStringField;
    dsBanksBIK: TIBStringField;
    dsBanksK_ACCOUNT: TIBStringField;
    dsBanksTOWN: TIBStringField;
    dsBanksBANK_GROUP: TSmallintField;
  protected
    procedure CreateView; override;
    procedure Activate; override;
    procedure Deactivate;  override;
    function GetIdent: TKisMngrs; override;
    function GetMainSQLText: String; override;
    function GetRefreshSQLText: String; override;
    function GetMainDataSet: TDataSet; override;
    procedure PrepareSQLHelper; override;
    procedure ViewGridDblClick(Sender: TObject); override;
  public
    function CreateEntity(EntityKind: TKisEntities = keDefault): TKisEntity; override;
    function GetEntity(EntityID: Integer; EntityKind: TKisEntities = keDefault): TKisEntity; override;
    function CurrentEntity: TKisEntity; override;
    function CreateNewEntity(EntityKind: TKisEntities = keDefault): TKisEntity; override;
    function EditEntity(Entity: TKisEntity): TKisEntity; override;
    function IsEntityInUse(Entity: TKisEntity): Boolean; override;
    function DuplicateEntity(Entity: TKisEntity): TKisEntity; override;
    procedure SaveEntity(Entity: TKisEntity); override;
  end;

implementation

{$R *.dfm}

const
  S_BANK = 'Банк';
  S_BANKS = 'Банки';

  SQ_MAIN = 'SELECT * FROM BANKS'; 
  SQ_SELECT_BANK = 'SELECT * FROM BANKS WHERE ID=%d';

{ TKisBank }

procedure TKisBank.CheckKAccount(const AKAccount: String);
begin
  if (Trim(AKAccount) <> '') and not StrIsNumber(AKAccount) {or ((Length(AKAccount) <> 18) or
    (Length(AKAccount) <> 20))}
  then
//    raise EInvalidKAccount.Create(S_INVALID_BANK_KACCOUNT);
end;

procedure TKisBank.CheckName(const AName: String);
begin
  if Trim(AName) = EmptyStr then
//    raise EInvalidName.Create(S_INVALID_BANK_NAME);
end;

procedure TKisBank.Copy(Source: TKisEntity);
begin
  inherited;
  with Source as TKisBank do
  begin
    Self.FName := Name;
    Self.FBankGroup := BankGroup;
    Self.FKAccount := KAccount;
    Self.FBIK := BIK;
    Self.FTown := Town;
  end;
end;

constructor TKisBank.Create(Mngr: TKisMngr);
begin
  inherited;
  BankGroup := N_ZERO;
end;

function TKisBankMngr.CreateEntity(EntityKind: TKisEntities): TKisEntity;
begin
  if EntityKind in [keDefault, keBank] then
    Result := TKisBank.Create(Self)
  else
    Result := nil;
end;

class function TKisBank.EntityName: String;
begin
  Result := S_BANK;
end;

function TKisBank.Equals(Entity: TKisEntity): Boolean;
begin
  inherited Equals(Entity);
  with Entity as TKisBank do
  begin
    Result := (Self.BIK = BIK) and (Self.Name = Name) and
      (Self.KAccount = KAccount) and (Self.Town = Town) and
      (Self.BankGroup = BankGroup);
  end;
end;

function TKisBank.GetBankGroup: SmallInt;
begin
  Result := FBankGroup;
end;

function TKisBank.GetBIK: String;
begin
  Result := FBIK;
end;

function TKisBank.GetKAccount: String;
begin
  Result := FKAccount;
end;

function TKisBank.GetName: String;
begin
  Result := FName;
end;

function TKisBank.GetText: String;
begin
  if Self.IsEmpty then
    Result := ''
  else
    Result := Self.Name + ', ' + #32 + Self.Town + ', БИК ' + Self.BIK;
end;

function TKisBank.GetTown: String;
begin
  Result := FTown;
end;

{$IFDEF ENTPARAMS}
procedure TKisBank.InitParams;
begin
{  inherited;
  AddParam(SF_BIK);
  AddParam(SF_NAME);
  AddParam(SF_K_ACCOUNT);
  AddParam(SF_TOWN);
  AddParam(SF_BANK_GROUP);}
end;
{$ENDIF}

function TKisBank.IsEmpty: Boolean;
begin
  Result :=
    (FName = '') and
    (FBIK = '') and
    (FBankGroup <= 0) and
    (FKAccount = '') and
    (FTown = '');
end;

procedure TKisBank.Load(DataSet: TDataSet);
var
  S: String;
begin
  ID := DataSet.FieldByName(SF_ID).AsInteger;
  Name := DataSet.FieldByName(SF_NAME).AsString;
  S := DataSet.FieldByName(SF_BIK).AsString;
  BIK := S;
  KAccount := DataSet.FieldByName(SF_K_ACCOUNT).AsString;
  Town := DataSet.FieldByName(SF_TOWN).AsString;
  BankGroup := DataSet.FieldByName(SF_BANK_GROUP).AsInteger;
end;

procedure TKisBank.SetBankGroup(const Value: SmallInt);
begin
  if FBankGroup <> Value then
  begin
    FBankGroup := Value;
    Modified := True;
  end;
end;

procedure TKisBank.SetBIK(const Value: String);
begin
  if FBIK <> Value then
  begin
    FBIK := Value;
    Modified := True;
  end;
end;

procedure TKisBank.SetKAccount(const Value: String);
begin
  CheckKAccount(Value);
  if FKAccount <> Value then
  begin
    FKAccount := Value;
    Modified := True;
  end;
end;

procedure TKisBank.SetName(const Value: String);
begin
  CheckName(Value);
  if FName <> Value then
  begin
    FName := Value;
    Modified := True;
  end;
end;

procedure TKisBank.SetTown(const Value: String);
begin
  if FTown <> Value then
  begin
    FTown := Value;
    Modified := True;
  end;
end;

{ TKisBankMngr }

procedure TKisBankMngr.Activate;
begin
  inherited Activate;
  DefaultTransaction := AppModule.Pool.Get;
  DefaultTransaction.Init(ilReadCommited, amReadOnly);
  DefaultTransaction.AutoStopAction := saNone;
  if not DefaultTransaction.Active then
    DefaultTransaction.StartTransaction;
  dsBanks.Transaction := DefaultTransaction;
  Reopen;
end;

procedure TKisBankMngr.CreateView;
begin
  inherited;
  FView.Caption := S_BANKS;
end;

procedure TKisBankMngr.Deactivate;
begin
  if DefAultTransaction.Active then
    DefAultTransaction.Commit;
  AppModule.Pool.Back(DefaultTransaction);
  dsBanks.Transaction := nil;
  inherited;
end;

function TKisBankMngr.CurrentEntity: TKisEntity;
begin
  if dsbanks.Active then
  begin
    Result := TKisBank.Create(Self);
    with Result as TKisBank do
    begin
      ID := dsBanks.FieldByName(SF_ID).AsInteger;
      Name := dsBanks.FieldByName(SF_NAME).AsString;
      BIK := dsBanks.FieldByName(SF_BIK).AsString;
      KAccount := dsBanks.FieldByName(SF_K_ACCOUNT).AsString;
      Town := dsBanks.FieldByName(SF_TOWN).AsString;
      BankGroup := dsBanks.FieldByName(SF_BANK_GROUP).AsInteger;
    end;
  end
  else
    Result := nil;
end;


function TKisBankMngr.GetIdent: TKisMngrs;
begin
  Result := kmBanks;
end;

function TKisBankMngr.GetEntity(EntityID: Integer;  EntityKind: TKisEntities = keDefault): TKisEntity;
var
  Conn: IKisConnection;
  DataSet: TDataSet;
begin
  Conn := GetConnection(True, False);
  DataSet := Conn.GetDataSet(Format(SQ_SELECT_BANK, [EntityID]));
  try
    DataSet.Open;
    if DataSet.IsEmpty then
      Result := nil
    else
    begin
      Result := Self.CreateEntity(keBank);
      Result.Load(DataSet);
    end;
    DataSet.Close;
  finally
    FreeConnection(Conn, True);
  end;
end;

function TKisBankMngr.GetMainSQLText: String;
begin
  Result := SQ_MAIN;
end;

function TKisBankMngr.CreateNewEntity(EntityKind: TKisEntities = keDefault): TKisEntity;
begin
  Result := nil;
end;

procedure TKisBankMngr.PrepareSQLHelper;
begin
  inherited;
  with FSQLHelper.AddTable do
  begin
    TableName := ST_BANKS;
    TableLabel := 'Основная (банки)';
    AddStringField(SF_NAME, SFL_NAME, 81, [fpSearch, fpSort, fpQuickSearch]);
    AddStringField(SF_BIK, SFL_BIK, 9, [fpSearch, fpSort, fpQuickSearch]);
    AddStringField(SF_K_ACCOUNT, 'Корр/счет', 20, [fpSearch, fpSort, fpQuickSearch]);
    AddStringField(SF_TOWN, 'Населенный пункт', 31, [fpSearch, fpSort, fpQuickSearch]);
  end;
end;

function TKisBankMngr.EditEntity(Entity: TKisEntity): TKisEntity;
begin
  Entity.Modified := False;
  Result := Entity;
end;

function TKisBankMngr.IsEntityInUse(Entity: TKisEntity): Boolean;
begin
  Result := True;
end;

function TKisBankMngr.DuplicateEntity(Entity: TKisEntity): TKisEntity;
begin
  raise Exception.Create('Нельзя копировать банк!');
end;

procedure TKisBankMngr.SaveEntity(Entity: TKisEntity);
begin
  raise Exception.Create('Нельзя сохранять банк!');
end;

procedure TKisBankMngr.ViewGridDblClick(Sender: TObject);
var
  Gc: TGridCoord;
begin
  if Assigned(FView) then
  begin
    Gc := FView.Grid.MouseCoord(FX, FY);
    if (Gc.X > N_ZERO) and (Gc.Y > N_ZERO) then
    if FView.ButtonsPanel.Visible then
      FView.Button1.Click;
  end;
end;

function TKisBankMngr.GetMainDataSet: TDataSet;
begin
  Result := dsBanks;
end;

function TKisBankMngr.GetRefreshSQLText: String;
begin
  Result := 'SELECT * FROM BANKS WHERE ID=:ID';
end;

end.
