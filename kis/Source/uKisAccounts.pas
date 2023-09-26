unit uKisAccounts;

interface

uses
  Classes, DB, Contnrs, SysUtils, Types, Controls, Windows, Variants,
  //
  uDataSet, uCommonUtils, uGC,
  //
  uKisClasses, uKisSQLClasses, uKisBanks, uKisEntityEditor, uKisAccontForm,
  uKisAppModule, uKisConsts, uKisBankAccountsForm, uKisUtils, uKisIntf;


type
  TKisAccountType = (atLS, atRS);

  TKisContragentAccount = class(TKisVisualEntity)
  private
    FBank: TKisBank;
    FNumber: String;
    FAccountType: TKisAccountType;
    FIsDefault: Boolean;
    function GetContragentId: Integer;
    procedure SetContragentId(const Value: Integer);
    function GetContragent: TKisEntity;
    procedure SetContragent(const Value: TKisEntity);
    function GetBank: TKisBank;
    function GetBankId: Integer;
    procedure SetBank(const Value: TKisBank);
    procedure SetBankId(const Value: Integer);
    procedure SetNumber(const Value: String);
    procedure SetAccountType(const Value: TKisAccountType);
    procedure SetIsDefault(const Value: Boolean);
    function GetAccountEditor: TKisAccountForm;
    procedure FindBankHandler(Sender: TObject);
    function DoFindBank(const BIK: String): Boolean;
    procedure SelectBank(Sender: TObject);
    procedure UpdateBankView;
    function GetAccountTypeName: String;
  protected
    function CreateEditor: TKisEntityEditor; override;
    function GetCaption: String; override;
    procedure PrepareEditor(AEditor: TKisEntityEditor); override;
    procedure LoadDataIntoEditor(AEditor: TKisEntityEditor); override;
    procedure ReadDataFromEditor(AEditor: TKisEntityEditor); override;
    function CheckEditor(AEditor: TKisEntityEditor): Boolean; override; 
    property AccountEditor: TKisAccountForm read GetAccountEditor;
  public
    class function EntityName: String; override;
    procedure Copy(Source: TKisEntity); override;
    function IsEmpty: Boolean; override;
    function Equals(Entity: TKisEntity): Boolean; override;
    procedure Load(DataSet: TDataSet); override;
    function ContrMngr: TKisSQLMngr;
    function BankName: String;
    function Clone: TKisContragentAccount;
    property ContragentId: Integer read GetContragentId write SetContragentId;
    property Contragent: TKisEntity read GetContragent write SetContragent;
    property BankId: Integer read GetBankId write SetBankId;
    property Bank: TKisBank read GetBank write SetBank;
    property Number: String read FNumber write SetNumber;
    property AccountType: TKisAccountType read FAccountType write SetAccountType;
    property AccountTypeName: String read GetAccountTypeName;
    property IsDefault: Boolean read FIsDefault write SetIsDefault;
  end;

  TKisContrAccountCtrlr = class(TKisEntityController)
  private
    procedure SetDefaultAccount(Index: Integer);
    function GetAccounts(const Index: Integer): TKisContragentAccount;
    procedure SetAccountTypeName(Sender: TField; const Text: String);
    procedure AfterInsertEdit(DataSet: TDataSet);
    procedure BeforeDelete(DataSet: TDataSet);
  public
    procedure FillFieldDefs(FieldDefsRef: TFieldDefs); override;
    function GetFieldData(Index: Integer; Field: TField; out Data): Boolean; override;
    procedure SetFieldData(Index: Integer; Field: TField; var Data); override;
    function ShowEditor(const LeftTop: TPoint; var Account: TKisContragentAccount): Boolean;
    property Accounts[const Index: Integer]: TKisContragentAccount read GetAccounts;
  end;

  TKisAccountsMngr = class(TKisMngr)
  private
    FConnection: IKisConnection;
    function GetConnection: IKisConnection;
    procedure SetConnection(const Value: IKisConnection);
  protected
    function GetIdent: TKisMngrs; override;
    function IsSupported(Entity: TKisEntity): Boolean; override;
    function GenEntityID(EntityKind: TKisEntities = keDefault): Integer; override;
  public
    constructor Create(AOwner: TComponent); override;
    function CreateEntity(EntityKind: TKisEntities = keDefault): TKisEntity; override;
    function CreateNewEntity(EntityKind: TKisEntities = keDefault): TKisEntity; override;
    function GetEntity(EntityID: Integer; EntityKind: TKisEntities = keDefault): TKisEntity; override;
    function EditEntity(Entity: TKisEntity): TKisEntity; override;
    procedure SaveEntity(Entity: TKisEntity); override;
    function DeleteEntity(Entity: TKisEntity): Boolean; override;
    function IsEntityInUse(Entity: TKisEntity): Boolean; override;
{    function IsEntityStored(Entity: TKisEntity): Boolean; virtual; abstract; 
    function DuplicateEntity(Entity: TKisEntity): TKisEntity; virtual; abstract; }
    procedure LoadController(Ctrlr: TKisContrAccountCtrlr; const ContragentId: Integer);
    procedure SaveController(Ctrlr: TKisContrAccountCtrlr);
    property Connection: IKisConnection read GetConnection write SetConnection;
  end;

implementation

{$R *.dfm}

uses
  uKisContragents;

const
  SQ_LOAD_ACCOUNT = 'SELECT ID, CONTRAGENTS_ID, BANKS_ID, ACCOUNT, ACCOUNT_TYPE, IS_DEFAULT FROM CONTR_ACCOUNTS WHERE ID=:ID';
  SQ_SAVE_ACCOUNT = 'EXECUTE PROCEDURE SAVE_CONTR_ACCOUNT(:ID, :CONTRAGENTS_ID, :BANKS_ID, :ACCOUNT, :ACCOUNT_TYPE, :IS_DEFAULT)';
  SQ_DELETE_ACCOUNT = 'DELETE FROM CONTR_ACCOUNTS WHERE ID=%d';
  SQ_LOAD_ACCOUNTS = 'SELECT * FROM CONTR_ACCOUNTS WHERE CONTRAGENTS_ID=%d ORDER BY ID';

{ TKisAccountsMngr }

constructor TKisAccountsMngr.Create(AOwner: TComponent);
begin
  inherited;
  FConnection := nil;
end;

function TKisAccountsMngr.CreateEntity(
  EntityKind: TKisEntities): TKisEntity;
begin
  Result := TKisContragentAccount.Create(Self);
end;

function TKisAccountsMngr.CreateNewEntity(
  EntityKind: TKisEntities): TKisEntity;
begin
  Result := CreateEntity;
  Result.ID := GenEntityID;
end;

function TKisAccountsMngr.DeleteEntity(Entity: TKisEntity): Boolean;
begin
  inherited DeleteEntity(Entity);
  Connection.GetDataSet(Format(SQ_DELETE_ACCOUNT, [Entity.ID])).Open;
end;

function TKisAccountsMngr.EditEntity(Entity: TKisEntity): TKisEntity;
begin
  Result := Entity;
end;

function TKisAccountsMngr.GenEntityID(EntityKind: TKisEntities): Integer;
begin
  Result := AppModule.GetID(SG_CONTRAGENT_ACCOUNTS, nil);
end;

function TKisAccountsMngr.GetConnection: IKisConnection;
begin
  if Assigned(FConnection) then
    Result := FConnection
  else
    raise Exception.Create('Нет соединения для модуля банковских счетов!');
end;

function TKisAccountsMngr.GetEntity(EntityID: Integer;
  EntityKind: TKisEntities): TKisEntity;
var
  Connection: IKisConnection;
  Account: TKisContragentAccount;
  DataSet: TDataSet;
begin
  Connection := GetConnection;
  Account := TKisContragentAccount(CreateNewEntity);
  Account.ID := EntityId;
  DataSet := Connection.GetDataSet(SQ_LOAD_ACCOUNT);
  Connection.SetParam(DataSet, SF_ID, EntityId);
  DataSet.Open;
  Account.Load(DataSet);
  DataSet.Close;
  Result := Account;
end;

function TKisAccountsMngr.GetIdent: TKisMngrs;
begin
  Result := kmAccounts;
end;

function TKisAccountsMngr.IsEntityInUse(Entity: TKisEntity): Boolean;
begin
  with TKisContragentAccount(Entity) do
    Result := IsDefault and not IsEmpty;
end;

function TKisAccountsMngr.IsSupported(Entity: TKisEntity): Boolean;
begin
  Result := inherited IsSupported(Entity);
  if Result then
    Result := Entity is TKisContragentAccount;
end;

procedure TKisAccountsMngr.LoadController(Ctrlr: TKisContrAccountCtrlr;
  const ContragentId: Integer);
var
  DataSet: TDataSet;
  Account: TKisContragentAccount;
begin
  if Assigned(Ctrlr) then
  begin
    Ctrlr.DirectClear;
    if not Assigned(Ctrlr.HeadEntity) then
      Ctrlr.HeadEntity := AppModule[kmContragents].GetEntity(ContragentId, keContragent);
    DataSet := Connection.GetDataSet(Format(SQ_LOAD_ACCOUNTS, [ContragentId]));
    DataSet.Open;
    while not DataSet.Eof do
    begin
      Account := TKisContragentAccount(CreateEntity);
      Account.Load(DataSet);
      Ctrlr.DirectAppend(Account);
      DataSet.Next;
    end;
  end;
end;

procedure TKisAccountsMngr.SaveController(Ctrlr: TKisContrAccountCtrlr);
var
  I: Integer;
begin
  if Assigned(Ctrlr) then
  begin
    for I := 1 to Ctrlr.GetRecordCount do
      if Ctrlr.Elements[I].Modified then
        SaveEntity(Ctrlr.Elements[I]);
    for I := 0 to Pred(Ctrlr.DeletedCount) do
      DeleteEntity(Ctrlr.DeletedElements[I]);
  end;
end;

procedure TKisAccountsMngr.SaveEntity(Entity: TKisEntity);
var
  DataSet: TDataSet;
  Account: TKisContragentAccount;
begin
  Account := TKisContragentAccount(Entity);
  DataSet := Connection.GetDataSet(SQ_SAVE_ACCOUNT);
  if Account.ID < 1 then
    Account.ID := GenEntityID();
  Connection.SetParam(DataSet, SF_ID, Account.ID);
  Connection.SetParam(DataSet, SF_CONTRAGENTS_ID, Account.ContragentId);
  Connection.SetParam(DataSet, SF_BANKS_ID, Account.BankId);
  Connection.SetParam(DataSet, SF_ACCOUNT, Account.Number);
  Connection.SetParam(DataSet, SF_ACCOUNT_TYPE, Integer(Account.AccountType));
  Connection.SetParam(DataSet, SF_IS_DEFAULT, Integer(Account.IsDefault));
  DataSet.Open;
end;

procedure TKisAccountsMngr.SetConnection(const Value: IKisConnection);
begin
  FConnection := Value;
end;

{ TKisContrAccountCtrlr }

procedure TKisContrAccountCtrlr.BeforeDelete(DataSet: TDataSet);
begin
  if Accounts[DataSet.RecNo].IsDefault then
    if GetRecordCount > 1 then
      Accounts[1].IsDefault := True; 
end;

procedure TKisContrAccountCtrlr.AfterInsertEdit(DataSet: TDataSet);
begin
  if DataSet.State = dsInsert then
    Accounts[0].ID := TKisAccountsMngr(Accounts[0].Manager).GenEntityID();
  if GetRecordCount = 0 then
    Accounts[0].IsDefault := True;
  if Accounts[0].Edit then
    DataSet.Post
  else
    DataSet.Cancel;
end;

procedure TKisContrAccountCtrlr.FillFieldDefs(FieldDefsRef: TFieldDefs);
begin
  FieldDefsRef.Clear;
  with FieldDefsRef.AddFieldDef do
  begin
    DataType := ftInteger;
    FieldNo := 1;
    Name := SF_ID;
  end;
  with FieldDefsRef.AddFieldDef do
  begin
    DataType := ftInteger;
    FieldNo := 2;
    Name := SF_CONTRAGENTS_ID;
  end;
  with FieldDefsRef.AddFieldDef do
  begin
    DataType := ftInteger;
    FieldNo := 3;
    Name := SF_BANK_ID;
  end;
  with FieldDefsRef.AddFieldDef do
  begin
    DataType := ftString;
    FieldNo := 4;
    Name := SF_NUMBER;
    Size := 20;
  end;
  with FieldDefsRef.AddFieldDef do
  begin
    DataType := ftInteger;
    FieldNo := 5;
    Name := SF_ACCOUNT_TYPE;
  end;
  with FieldDefsRef.AddFieldDef do
  begin
    DataType := ftBoolean;
    FieldNo := 6;
    Name := SF_IS_DEFAULT;
  end;
  with FieldDefsRef.AddFieldDef do
  begin
    DataType := ftString;
    FieldNo := 7;
    Name := SF_BANK_NAME;
    Size := 150;
  end;
  with FieldDefsRef.AddFieldDef do
  begin
    DataType := ftString;
    Size := 3;
    FieldNo := 8;
    Name := SF_ACCOUNT_TYPE_NAME;
  end;
end;

function TKisContrAccountCtrlr.GetAccounts(const Index:
  Integer): TKisContragentAccount;
begin
  Result := TKisContragentAccount(Elements[Index]);
end;

function TKisContrAccountCtrlr.GetFieldData(Index: Integer; Field: TField;
  out Data): Boolean;
var
  Account: TKisContragentAccount;
begin
  Result := True;
  try
    Account := Elements[Index] as TKisContragentAccount;
    case Field.FieldNo of
      1 : GetInteger(Account.ID, Data);
      2 : GetInteger(Account.ContragentId, Data);
      3 : GetInteger(Account.BankId, Data);
      4 : GetString(Account.Number, Data);
      5 : GetBoolean(Account.AccountType = atRS, Data);
      6 : GetBoolean(Account.IsDefault, Data);
      7 : GetString(Account.BankName, Data);
      8 :
          begin
            if Account.AccountType = atLS then
              GetString('л/с', Data)
            else
              GetString('р/с', Data);
          end;
    end;
  except
    Result := False;
  end;
end;

procedure TKisContrAccountCtrlr.SetAccountTypeName(Sender: TField;
  const Text: String);
begin
  if Text = 'р/с' then
    Sender.DataSet.FieldByName(SF_ACCOUNT_TYPE).AsInteger := Integer(atRS)
  else
  if Text = 'л/с' then
    Sender.DataSet.FieldByName(SF_ACCOUNT_TYPE).AsInteger := Integer(atLS)
  else
    Abort;
end;

procedure TKisContrAccountCtrlr.SetDefaultAccount(Index: Integer);
var
  I: Integer;
begin
  for I := 1 to GetRecordCount do
    TKisContragentAccount(Elements[I]).IsDefault := (I = Index);
end;

procedure TKisContrAccountCtrlr.SetFieldData(Index: integer; Field: TField;
  var Data);
var
  Account: TKisContragentAccount;
begin
  try
    Account := TKisContragentAccount(Elements[Index]);
    case Field.FieldNo of
    1 : Account.ID := SetInteger(Data);
    2 : ;// только для чтения;
    3 : Account.BankId := SetInteger(Data);
    4 : Account.Number := StrPas(@Data);
    5 : if SetBoolean(Data) then
          Account.AccountType := atRS
        else
          Account.AccountType := atLS;
    6 : begin
          if SetBoolean(Data) then
          begin
            Account.IsDefault := True;
            SetDefaultAccount(Index);
          end;
        end;
    8 : begin
          if StrPas(@Data) = 'р/с' then
            Account.FAccountType := atRS
          else
            Account.FAccountType := atLS;
        end;
    end;
  except
    Exit;
  end;
end;

function TKisContrAccountCtrlr.ShowEditor(const LeftTop: TPoint;
  var Account: TKisContragentAccount): Boolean;
var
  DataSet: TCustomDataSet;
begin
  Account := nil;
  DataSet := nil;
  // Создаем окно
  with TKisBankAccountsForm.Create(nil) do
  try
    // Цепляем к нему датасет
    DataSet := TCustomDataSet.Create(nil);
    DataSet.Controller := Self;
    DataSet.Open;
    DataSet.FieldByName(SF_ACCOUNT_TYPE_NAME).OnSetText := SetAccountTypeName;
    DataSet.AfterInsert := AfterInsertEdit;
    DataSet.AfterEdit := AfterInsertEdit;
    DataSet.BeforeDelete := BeforeDelete;
    DataSource.DataSet := DataSet;
    if LeftTop.X > 0 then
      Left := LeftTop.X;
    if LeftTop.Y > 0 then
      Top := LeftTop.Y;
    // работаем
    Result := ShowModal = mrOK;
    if Result then
      if DataSet.RecordCount > 0 then
        Account := Accounts[DataSet.RecNo];
  finally
    Free;
    FreeAndNil(DataSet);
  end;
end;

{ TKisContragentAccount }

function TKisContragentAccount.BankName: String;
begin
  if Assigned(Bank) then
    Result := FBank.AsText
  else
    Result := '';
end;

function TKisContragentAccount.CheckEditor(
  AEditor: TKisEntityEditor): Boolean;
begin
  Result := False;
  with TKisAccountForm(AEditor) do
  begin
    if not StrIsNumber(edNumber.Text) then
    begin
{      MessageBox(Handle, PChar(S_CHECK_ACCOUNT_NUMBER),
        PChar(S_WARN), MB_OK + MB_ICONWARNING);
      edNumber.SetFocus;
      Exit;}
    end;
    if Self.BankId < 1 then
    begin
      MessageBox(Handle, PChar(S_CHECK_BANK),
        PChar(S_WARN), MB_OK + MB_ICONWARNING);
      edBIK.SetFocus;
      Exit;
    end;
    Result := True;
  end;
end;

function TKisContragentAccount.Clone: TKisContragentAccount;
begin
  Result := TKisContragentAccount(TKisAccountsMngr(Manager).CreateEntity);
  Result.Assign(Self);
end;

function TKisContragentAccount.ContrMngr: TKisSQLMngr;
begin
  Result := TKisContragentMngr(Manager);
end;

procedure TKisContragentAccount.Copy(Source: TKisEntity);
begin
  inherited;
  with TKisContragentAccount(Source) do
  begin
    Self.BankId := BankId;
    Self.FNumber := Number;
    Self.FAccountType := AccountType;
    Self.FIsDefault := IsDefault;
    Self.ContragentId := ContragentId;
  end;
end;

function TKisContragentAccount.CreateEditor: TKisEntityEditor;
begin
  Result := TKisAccountForm.Create(AppModule);
end;

function TKisContragentAccount.DoFindBank(const BIK: String): Boolean;
var
  Value: Variant;
begin
  Value := NULL;
  Result := False;
  if AppModule.GetFieldValue(nil, ST_BANKS, SF_BIK, SF_ID, BIK, Value) then
  begin
    Result := not VarIsEmpty(Value) and not VarIsNull(Value);
    if Result then
      Self.BankId := Value;
  end;
end;

class function TKisContragentAccount.EntityName: String;
begin
  Result := SEN_CONTR_ACCOUNT;
end;

function TKisContragentAccount.Equals(Entity: TKisEntity): Boolean;
begin
  Result := inherited Equals(Entity);
  if Result then
  with TKisContragentAccount(Entity) do
    Result := (Self.Number = Number) and (Self.BankId = BankId)
      and (Self.AccountType = AccountType);
end;

procedure TKisContragentAccount.FindBankHandler(Sender: TObject);
begin
  with AccountEditor do
    if not DoFindBank(edBIK.Text) then
      MessageBox(Handle, PChar(S_BANK_NOT_FOUND), PChar(S_WARN), MB_OK + MB_ICONWARNING)
    else
      UpdateBankView;
end;

function TKisContragentAccount.GetAccountEditor: TKisAccountForm;
begin
  Result := TKisAccountForm(EntityEditor); 
end;

function TKisContragentAccount.GetAccountTypeName: String;
begin
  case FAccountType of
  atRS : Result := 'р/счет';
  atLS : Result := 'л/счет';
  else
         Result := '';
  end;
end;

function TKisContragentAccount.GetBank: TKisBank;
begin
  Result := FBank;
end;

function TKisContragentAccount.GetBankId: Integer;
begin
  if Assigned(FBank) then
    Result := FBank.ID
  else
    Result := -1;
end;

function TKisContragentAccount.GetCaption: String;
begin
  if IsEmpty then
    Result := 'Новый счет'
  else
   Result := 'Счет'; 
end;

function TKisContragentAccount.GetContragent: TKisEntity;
begin
  Result := Head;
end;

function TKisContragentAccount.GetContragentId: Integer;
begin
  Result := HeadId;
end;

function TKisContragentAccount.IsEmpty: Boolean;
begin
  Result := (Number = '') and (BankId < 0);
end;

procedure TKisContragentAccount.Load(DataSet: TDataSet);
begin
  ID := DataSet.FieldByName(SF_ID).AsInteger;
  FNumber := DataSet.FieldByName(SF_ACCOUNT).AsString;
  FAccountType := TKisAccountType(DataSet.FieldByName(SF_ACCOUNT_TYPE).AsInteger);
  FIsDefault := Boolean(DataSet.FieldByName(SF_IS_DEFAULT).AsInteger);
  BankId := DataSet.FieldByName(SF_BANKS_ID).AsInteger;
  Modified := False;
end;

procedure TKisContragentAccount.LoadDataIntoEditor(
  AEditor: TKisEntityEditor);
begin
  inherited;
  with TKisAccountForm(AEditor) do
  begin
    if Assigned(Bank) then
    begin
      edBIK.Text := Bank.BIK;
      mBank.Text := Self.BankName;
    end
    else
    begin
      edBIK.Clear;
      mBank.Clear;
    end;
    edNumber.Text := Self.Number;
    cbType.ItemIndex := Integer(Self.AccountType);
    cbDefault.Checked := IsDefault;
  end;
end;

procedure TKisContragentAccount.PrepareEditor(AEditor: TKisEntityEditor);
begin
  inherited;
  with TKisAccountForm(AEditor) do
  begin
    btnFind.OnClick := FindBankHandler;
    btnSelect.OnClick := SelectBank;
  end;
end;

procedure TKisContragentAccount.ReadDataFromEditor(
  AEditor: TKisEntityEditor);
begin
  inherited;
  with TKisAccountForm(AEditor) do
  begin
    Number := edNumber.Text;
    AccountType := TKisAccountType(cbType.ItemIndex);
  end;
end;

procedure TKisContragentAccount.SelectBank(Sender: TObject);
var
  BankMngr: TKisBankMngr;
  Bank: TKisEntity;
begin
  BankMngr := TKisBankMngr(AppModule[kmBanks]);
  Bank := BankMngr.SelectEntity(True, nil, True, Self.BankId);
  Bank.Forget();
  if Assigned(Bank) then
    Self.BankId := Bank.Id;
  UpdateBankView;
end;

procedure TKisContragentAccount.SetAccountType(
  const Value: TKisAccountType);
begin
  if FAccountType <> Value then
  begin
    FAccountType := Value;
    Modified := True;
  end;
end;

procedure TKisContragentAccount.SetBank(const Value: TKisBank);
begin
  if not Assigned(FBank) then
  begin
    if Assigned(Value) then
    begin
      FBank := Value;
      Modified := True;
    end;
  end
  else
  begin
    if Assigned(Value) then
    begin
      if not FBank.Equals(Value) then
      begin
        FBank := Value;
        Modified := True;
      end
    end
    else
    begin
      FBank := Value;
      Modified := True;
    end;
  end;
end;

procedure TKisContragentAccount.SetBankId(const Value: Integer);
var
  BankMngr: TKisBankMngr;
begin
  BankMngr := TKisBankMngr(AppModule.Mngrs[kmBanks]);
  Bank := TKisBank(BankMngr.GetEntity(Value, keDefault));
end;

procedure TKisContragentAccount.SetContragent(const Value: TKisEntity);
begin
  Head := Value;
end;

procedure TKisContragentAccount.SetContragentId(const Value: Integer);
begin
  if HeadId <> Value then
  begin
    Head := ContrMngr.GetEntity(Value, keDefault);
  end;
end;

procedure TKisContragentAccount.SetIsDefault(const Value: Boolean);
begin
  if Value <> FIsDefault then
  begin
    FIsDefault := Value;
    Modified := True;
  end;
end;

procedure TKisContragentAccount.SetNumber(const Value: String);
begin
  if FNumber <> Value then
  begin
    FNumber := Value;
    Modified := True;
  end;
end;

procedure TKisContragentAccount.UpdateBankView;
begin
  if Assigned(EntityEditor) then
    AccountEditor.mBank.Text := BankName;
end;

end.
