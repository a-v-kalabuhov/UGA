{*******************************************************}
{                                                       }
{       "ИС МП УГА"                                     }
{       Менеджер организаций                            }
{                                                       }
{       Copyright (c) 2004-2005, МП УГА                 }
{                                                       }
{       Автор: Калабухов А.В.                           }
{                                                       }
{*******************************************************}

{ Описание: реализует операции над организациями.
            Организации не обязательно являются контрагентами,
            они используются при работе с корреспонденцией,
            при назначении собственников отводам и т.п.
  Имя модуля: Firms
  Версия: 1.03
  Дата последнего изменения: 10.06.2005
  Цель: модуль содержит реализации классов организации и менеджера организаций
  Используется:
  Использует: Kernel Classes
  Исключения: нет }
{
  1.03             10.06.2005
     - использован класс TKisConnection
     - убрано свойство DataParams
     - добавлен класс TKisFirmSaver

  1.02             27.11.2004
     - метод Reopen удален из-за реализации унаследованного
  1.01
     - добавлены заголовки окон
     - исправлена работа с транзакциями
     - исправлена ошибка с загрузкой объекта из БД
     - исправлено имя генератора
}

unit uKisFirms;

interface

{$I KisFlags.pas}

uses
  // System
  Windows, Messages, SysUtils, Variants, Classes, Graphics, DB, ImgList,
  ActnList, IBCustomDataSet, IBDatabase, Controls,
  // Project
  uKisClasses, uKisSQLClasses, uKisEntityEditor;

type
  TKisFirm = class(TKisVisualEntity)
  private
    FAddress: String;
    FBank: String;
    FDirector: String;
    FName: String;
    FShortName: String;
    FInn: String;
    FKpp: String;
    FOkpo: String;
    FOwner: String;
    FPhones: String;
    procedure SetAddress(const Value: String);
    procedure SetBank(const Value: String);
    procedure SetDirector(const Value: String);
    procedure SetINN(const Value: String);
    procedure SetKPP(const Value: String);
    procedure SetName(const Value: String);
    procedure SetOKPO(const Value: String);
    procedure SetOwnerFirm(const Value: String);
    procedure SetPhones(const Value: String);
    procedure SetShortname(const Value: String);
  protected
    function CreateEditor: TKisEntityEditor; override;
    procedure LoadDataIntoEditor(Editor: TKisEntityEditor); override;
    procedure ReadDataFromEditor(Editor: TKisEntityEditor); override;
    function CheckEditor(Editor: TKisEntityEditor): Boolean; override;
  public
    class function EntityName: String; override;
    function IsEmpty: Boolean; override;
    function Equals(Entity: TKisEntity): Boolean; override;
    procedure Load(DataSet: TDataSet); override;
    procedure Copy(Source: TKisEntity); override;
    property Name: String read FName write SetName;
    property Shortname: String read FShortname write SetShortname;
    property INN: String read FINN write SetINN;
    property OKPO: String read FOKPO write SetOKPO;
    property Address: String read FAddress write SetAddress;
    property Bank: String read FBank write SetBank;
    property OwnerFirm: String read FOwner write SetOwnerFirm;
    property Director: String read FDirector write SetDirector;
    property Phones: String read FPhones write SetPhones;
    property KPP: String read FKPP write SetKPP;
  end;

  TKisFirmSaver = class(TKisEntitySaver)
  protected
    procedure PrepareParams(DataSet: TDataSet); override;
    function GetSQL: String; override;
  end;

  TKisFirmMngr = class(TKisSQLMngr)
    dsFirms: TIBDataSet;
    dsFirmsID: TIntegerField;
    dsFirmsNAME: TIBStringField;
    dsFirmsSHORT_NAME: TIBStringField;
    dsFirmsINN: TIBStringField;
    dsFirmsOKPO: TIBStringField;
    dsFirmsADDRESS: TIBStringField;
    dsFirmsBANK: TIBStringField;
    dsFirmsOWNER_FIRM: TIBStringField;
    dsFirmsDIRECTOR: TIBStringField;
    dsFirmsPHONES: TIBStringField;
    dsFirmsKPP: TIBStringField;
    procedure acInsertUpdate(Sender: TObject);
    procedure acDeleteUpdate(Sender: TObject);
    procedure acEditUpdate(Sender: TObject);
  protected
    procedure CreateView; override;
    function GetMainSQLText: String; override;
    function GetRefreshSQLText: String; override;
    function GetMainDataSet: TDataSet; override;
    function GenEntityID(EntityKind: TKisEntities = keDefault): Integer; override;
    procedure Activate; override;
    procedure Deactivate; override;
    function IsSupported(Entity: TKisEntity): Boolean; override;
    function GetIdent: TKisMngrs; override;
    procedure PrepareSQLHelper; override;
    procedure Locate(AId: Integer; LocateFail: Boolean = False); override;
  public
    function CurrentEntity: TKisEntity; override;
    function GetEntity(EntityID: Integer; EntityKind: TKisEntities = keDefault): TKisEntity; override;
    function CreateNewEntity(EntityKind: TKisEntities = keDefault): TKisEntity; override;
    function EditEntity(Entity: TKisEntity): TKisEntity; override;
    procedure SaveEntity(Entity: TKisEntity); override;
    function DeleteEntity(Entity: TKisEntity): Boolean; override;
    function CreateEntity(EntityKind: TKisEntities = keDefault): TKisEntity; override;
    function IsEntityInUse(Entity: TKisEntity): Boolean; override;
  end;

implementation

{$R *.dfm}

uses
  // Common
  uIBXUtils, uGC, uVCLUtils,
  // Project
  uKisAppModule, uKisConsts, uKisFirmEditor, uKisUtils, uKisIntf,
  uKisSearchClasses;

const
  SQ_GET_FIRMS = 'SELECT ID, NAME, SHORT_NAME, INN, OKPO, ADDRESS, BANK, '
                 + 'OWNER_FIRM, DIRECTOR, PHONES, KPP FROM FIRMS';
  SQ_GET_FIRM = SQ_GET_FIRMS + ' WHERE ID=%d';
  SQ_SAVE_FIRM = 'EXECUTE PROCEDURE SAVE_FIRM(:ID, :NAME, :SHORT_NAME, :INN, :OKPO, :ADDRESS, :BANK, :OWNER_FIRM, :DIRECTOR, :PHONES, :KPP)';
  SQ_DELETE_FIRM = 'DELETE FROM FIRMS WHERE ID=%d';
  SG_FIRMS = 'FIRMS';

{ TKisFirmMngr }

function TKisFirmMngr.GetMainSQLText: String;
begin
  Result := SQ_GET_FIRMS;
end;

procedure TKisFirmMngr.Activate;
begin
  inherited;
  dsFirms.Transaction := AppModule.Pool.Get;
  dsFirms.Transaction.Init(ilReadCommited, amReadWrite);
  dsFirms.Transaction.AutoStopAction := saNone;
  if not dsFirms.Transaction.Active then
    dsFirms.Transaction.StartTransaction;
  Reopen;
end;

procedure TKisFirmMngr.Deactivate;
begin
  if Assigned(dsFirms.Transaction) then
  begin
    if dsFirms.Transaction.Active then
      dsFirms.Transaction.Commit;
    AppModule.Pool.Back(dsFirms.Transaction);
    dsFirms.Transaction := nil;
  end;
end;

function TKisFirmMngr.GenEntityID(EntityKind: TKisEntities): Integer;
begin
  Result := AppModule.GetID(SG_FIRMS, Self.DefaultTransaction);
end;

function TKisFirmMngr.GetIdent: TKisMngrs;
begin
  Result := kmFirms;
end;

function TKisFirmMngr.IsSupported(Entity: TKisEntity): Boolean;
begin
  Result := Assigned(Entity) and (Entity is TKisFirm);
end;

procedure TKisFirmMngr.Locate(AId: Integer; LocateFail: Boolean = False);
begin
  inherited;
  if dsFirms.Active then
  begin
    dsFirms.Locate(SF_ID, AId, []);
  end;
end;

procedure TKisFirmMngr.PrepareSQLHelper;
begin
  inherited;
  with FSQLHelper.AddTable do
  begin
    TableName := ST_FIRMS;
    TableLabel := 'Основная (организации)';
    AddStringField(SF_NAME, SFL_NAME, 120, [fpSearch, fpSort, fpQuickSearch]);
    AddStringField(SF_SHORT_NAME, SFL_SHORTNAME, 80, [fpSearch, fpSort, fpQuickSearch]);
    AddStringField(SF_DIRECTOR, SFL_DIRECTOR, 50, [fpSearch, fpSort, fpQuickSearch]);
    AddStringField(SF_ADDRESS, SFL_ADDRESS, 120, [fpSearch, fpSort, fpQuickSearch]);
    AddStringField(SF_OWNER_FIRM, SFL_OWNER_FIRM, 120, [fpSearch, fpSort, fpQuickSearch]);
    AddStringField(SF_BANK, SFL_PROPERTIES, 120, [fpSearch, fpSort, fpQuickSearch]);
    AddStringField(SF_PHONES, SFL_PHONES, 30, [fpSearch, fpSort, fpQuickSearch]);
    AddStringField(SF_INN, SFL_INN, 12, [fpSearch, fpSort, fpQuickSearch]);
    AddSimpleField(SF_ID, SFL_INSERT_ORDER, ftInteger, [fpSort]);
  end;
end;

function TKisFirmMngr.CreateEntity(EntityKind: TKisEntities): TKisEntity;
begin
  if EntityKind in [keDefault, keFirm] then
    Result := TKisFirm.Create(Self)
  else
    Result := nil;
end;

function TKisFirmMngr.CreateNewEntity(
  EntityKind: TKisEntities): TKisEntity;
begin
  if EntityKind in [keDefault, keFirm] then
  begin
    Result := Self.CreateEntity(EntityKind);
    Result.ID := Self.GenEntityID(EntityKind);
  end
  else
    raise Exception.Create(S_CANT_CREATE_NEW_ENTITY);
end;

function TKisFirmMngr.CurrentEntity: TKisEntity;
begin
  if dsFirms.Active then
  begin
    Result := Self.CreateEntity();
    Result.Load(dsFirms);
    Result.ID := dsFirmsID.AsInteger;
  end
  else
    Result := nil;
end;

function TKisFirmMngr.EditEntity(Entity: TKisEntity): TKisEntity;
begin
  Result := nil;
  if IsSupported(Entity) then
  begin
    Result := CreateEntity(keDefault);
    Result.Assign(Entity);
    Result.Modified := TKisFirm(Result).Edit;
  end;
end;

function TKisFirmMngr.GetEntity(EntityID: Integer;
  EntityKind: TKisEntities): TKisEntity;
var
  Conn: IKisConnection;
  DataSet: TDataSet;
begin
  Result := nil;
  Conn := GetConnection(True, False);
  try
    if EntityKind in [keDefault, keFirm] then
    begin
      DataSet := Conn.GetDataSet(Format(SQ_GET_FIRM, [EntityID]));
      DataSet.Open;
      if not DataSet.IsEmpty then
      begin
        Result := Self.CreateEntity(EntityKind);
        Result.Load(DataSet);
        Result.ID := EntityID;
      end;
      DataSet.Close;
    end;
  finally
    FreeConnection(Conn, True);
  end;
end;

procedure TKisFirmMngr.SaveEntity(Entity: TKisEntity);
var
  Conn: IKisConnection;
begin
  inherited;
  Conn := GetConnection(True, True);
  try
    if IsSupported(Entity) then
      with TKisFirmSaver.Create(Conn) do
      try
        Save(Entity);
      finally
        Free;
      end;
    FreeConnection(Conn, True);
  except
    FreeConnection(Conn, False);
    raise;
  end;
end;

function TKisFirmMngr.DeleteEntity(Entity: TKisEntity): Boolean;
var
  Conn: IKisConnection;
begin
  Conn := GetConnection(True, True);
  try
    if IsEntityInUse(Entity) then
    begin
      Result := False;
      inherited DeleteEntity(Entity);
    end
    else
    begin
      Conn.GetDataSet(Format(SQ_DELETE_FIRM, [Entity.ID])).Open;
      Result := True;
    end;
    FreeConnection(Conn, True);
  except
    FreeConnection(Conn, False);
    raise;
  end;
end;

procedure TKisFirmMngr.CreateView;
begin
  inherited;
  FView.Caption := 'Организации/заказчики';
end;

function TKisFirmMngr.GetMainDataSet: TDataSet;
begin
  Result := dsFirms;
end;

function TKisFirmMngr.GetRefreshSQLText: String;
begin
  Result := 'SELECT * FROM FIRMS WHERE ID=:ID';
end;

function TKisFirmMngr.IsEntityInUse(Entity: TKisEntity): Boolean;
begin
  // [!!!] Надо переписать на вызов нормального запроса!!!
  Result := True;
end;

{ TKisFirm }

function TKisFirm.CheckEditor(Editor: TKisEntityEditor): Boolean;
var
  I1, I2: Integer;
begin
  Result := False;
  with Editor as TKisFirmEditor do
  begin
    if (Trim(edName.Text) = '') or BadFirmName(Trim(edName.Text), I1, I2) then
    begin
      MessageBox(Editor.Handle, PChar(S_CHECK_NAME), PChar(S_WARN), MB_OK + MB_ICONWARNING);
      edName.SetFocus;
      if (I1 > 0) and (I2 > 0) then
        SetEditSelection(edName, I1, I2);
      Exit;
    end;
    if (Trim(edShortName.Text) = '') or BadFirmName(Trim(edShortName.Text), I1, I2) then
    begin
      MessageBox(Editor.Handle, PChar(S_CHECK_SHORTNAME), PChar(S_WARN), MB_OK + MB_ICONWARNING);
      edShortName.SetFocus;
      if (I1 > 0) and (I2 > 0) then
        SetEditSelection(edShortName, I1, I2);
      Exit;
    end;
    if (Trim(edOwnerFirm.Text) <> '') and BadFirmName(Trim(edOwnerFirm.Text), I1, I2) then
    begin
      MessageBox(Editor.Handle, PChar(S_CHECK_OWNER_FIRM_NAME), PChar(S_WARN), MB_OK + MB_ICONWARNING);
      edOwnerFirm.SetFocus;
      if (I1 > 0) and (I2 > 0) then
        SetEditSelection(edOwnerFirm, I1, I2);
      Exit;
    end;
    if (Trim(edDirector.Text) <> '') and BadFirmName(Trim(edDirector.Text), I1, I2) then
    begin
      MessageBox(Editor.Handle, PChar(S_CHECK_CHIEF), PChar(S_WARN), MB_OK + MB_ICONWARNING);
      edDirector.SetFocus;
      if (I1 > 0) and (I2 > 0) then
        SetEditSelection(edDirector, I1, I2);
      Exit;
    end;
  end;
  Result := True;
end;

procedure TKisFirm.Copy(Source: TKisEntity);
begin
  inherited;
  with Source as TKisFirm do
  begin
    Self.FAddress := Address;
    Self.FBank := Bank;
    Self.FDirector := Director;
    Self.FName := Name;
    Self.FShortName := ShortName;
    Self.FInn := INN;
    Self.FKpp := KPP;
    Self.FOkpo := OKPO;
    Self.FOwner := OwnerFirm;
    Self.FPhones := Phones;
  end;
end;

function TKisFirm.CreateEditor: TKisEntityEditor;
begin
  EntityEditor := TKisFirmEditor.Create(Manager);
  Result := EntityEditor;
end;

class function TKisFirm.EntityName: String;
begin
  Result := 'Организация/заказчик';
end;

function TKisFirm.Equals(Entity: TKisEntity): Boolean;
begin
  inherited Equals(Entity);
  with Entity as TKisFirm do
  begin
    Result := (Self.Name = Name) and (Self.Shortname = Shortname)
      and (Self.Address = Address) and (Self.Bank = Bank) and (Self.Phones = Phones)
      and (Self.Director = Director) and (Self.INN = INN) and (Self.KPP = KPP)
      and (Self.OKPO = OKPO) and (Self.OwnerFirm = OwnerFirm)
  end;
end;

function TKisFirm.IsEmpty: Boolean;
begin
  Result := (Name = '') and
    (Self.Shortname = '') and
    (Self.INN = '') and
    (Self.KPP = '') and
    (Self.Phones = '') and
    (Self.Address = '') and
    (Self.OwnerFirm = '') and
    (Self.Bank = '') and
    (Self.Director = '') and
    (Self.OKPO = '');
end;

procedure TKisFirm.Load(DataSet: TDataSet);
begin
  with DataSet do
  begin
    Self.Name := FieldByName(SF_NAME).AsString;
    Self.Shortname := FieldByName(SF_SHORT_NAME).AsString;
    Self.Address := FieldByName(SF_ADDRESS).AsString;
    Self.Phones := FieldByName(SF_PHONES).AsString;
    Self.Director := FieldByName(SF_DIRECTOR).AsString;
    Self.INN := FieldByName(SF_INN).AsString;
    Self.OKPO := FieldByName(SF_OKPO).AsString;
    Self.KPP := FieldByName(SF_KPP).AsString;
    Self.OwnerFirm := FieldByName(SF_OWNER_FIRM).AsString;
    Self.Bank := FieldByName(SF_BANK).AsString;
  end;
end;

procedure TKisFirm.LoadDataIntoEditor(Editor: TKisEntityEditor);
begin
  inherited;
  with Editor as TKisFirmEditor do
  begin
    edName.Text := Self.Name;
    edShortName.Text := Self.Shortname;
    edPhones.Text := Self.Phones;
    edDirector.Text := Self.Director;
    edOwnerFirm.Text := Self.OwnerFirm;
    edAddress.Text := Self.Address;
    edBank.Text := Self.Bank;
  end;
end;

procedure TKisFirm.ReadDataFromEditor(Editor: TKisEntityEditor);
begin
  inherited;
  with Editor as TKisFirmEditor do
  begin
    Self.Name := Trim(edName.Text);
    Self.Shortname := Trim(edShortName.Text);
    Self.Phones := Trim(edPhones.Text);
    Self.Director := Trim(edDirector.Text);
    Self.OwnerFirm := Trim(edOwnerFirm.Text);
    Self.Address := Trim(edAddress.Text);
    Self.Bank := Trim(edBank.Text);
  end;
end;

procedure TKisFirm.SetAddress(const Value: String);
begin
  if FAddress <> Value then
  begin
    FAddress := Value;
    Modified := True;
  end;
end;

procedure TKisFirm.SetBank(const Value: String);
begin
  if FBank <> Value then
  begin
    FBank := Value;
    Modified := True;
  end;
end;

procedure TKisFirm.SetDirector(const Value: String);
begin
  if FDirector <> Value then
  begin
    FDirector := Value;
    Modified := True;
  end;
end;

procedure TKisFirm.SetINN(const Value: String);
begin
  if FInn <> Value then
  begin
    FInn := Value;
    Modified := True;
  end;
end;

procedure TKisFirm.SetKPP(const Value: String);
begin
  if FKpp <> Value then
  begin
    FKpp := Value;
    Modified := True;
  end;
end;

procedure TKisFirm.SetName(const Value: String);
begin
  if FName <> Value then
  begin
    FName := Value;
    Modified := True;
  end;
end;

procedure TKisFirm.SetOKPO(const Value: String);
begin
  if FOkpo <> Value then
  begin
    FOkpo := Value;
    Modified := True;
  end;
end;

procedure TKisFirm.SetOwnerFirm(const Value: String);
begin
  if FOwner <> Value then
  begin
    FOwner := Value;
    Modified := True;
  end;
end;

procedure TKisFirm.SetPhones(const Value: String);
begin
  if FPhones <> Value then
  begin
    FPhones := Value;
    Modified := True;
  end;
end;

procedure TKisFirm.SetShortname(const Value: String);
begin
  if FShortName <> Value then
  begin
    FShortName := Value;
    Modified := True;
  end;
end;

procedure TKisFirmMngr.acInsertUpdate(Sender: TObject);
begin
  inherited;
  if acInsert.Enabled then
    acInsert.Enabled := AppModule.User.CanDoAction(maInsert, keFirm);
end;

procedure TKisFirmMngr.acDeleteUpdate(Sender: TObject);
begin
  inherited;
  if acDelete.Enabled then
    acDelete.Enabled := AppModule.User.CanDoAction(maDelete, keFirm);
end;

procedure TKisFirmMngr.acEditUpdate(Sender: TObject);
begin
  inherited;
  if acEdit.Enabled then
    acEdit.Enabled := AppModule.User.CanDoAction(maEdit, keFirm);
end;

{ TKisFirmSaver }

function TKisFirmSaver.GetSQL: String;
begin
  Result := SQ_SAVE_FIRM;
end;

procedure TKisFirmSaver.PrepareParams(DataSet: TDataSet);
begin
  inherited;
  with FEntity as TKisFirm do
  begin
    FConnection.SetParam(DataSet, SF_ID, ID);
    FConnection.SetParam(DataSet, SF_NAME, Name);
    FConnection.SetParam(DataSet, SF_SHORT_NAME, Shortname);
    FConnection.SetParam(DataSet, SF_ADDRESS, Address);
    FConnection.SetParam(DataSet, SF_OWNER_FIRM, OwnerFirm);
    FConnection.SetParam(DataSet, SF_DIRECTOR, Director);
    FConnection.SetParam(DataSet, SF_PHONES, Phones);
    FConnection.SetParam(DataSet, SF_INN, Inn);
    FConnection.SetParam(DataSet, SF_OKPO, Okpo);
    FConnection.SetParam(DataSet, SF_KPP, Kpp);
    FConnection.SetParam(DataSet,SF_BANK , Bank);
  end;
end;

end.
