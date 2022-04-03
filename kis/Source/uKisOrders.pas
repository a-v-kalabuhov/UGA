{*******************************************************}
{                                                       }
{       "ИС МП УГА"                                     }
{       Менеджер заказов                                }
{                                                       }
{       Copyright (c) 2004, МП УГА                      }
{                                                       }
{       Автор: Калабухов А.В.                           }
{                                                       }
{*******************************************************}

{ Описание: реализует операции над заказами
  Имя модуля: Orders
  Версия: 1.06
  Дата последнего изменения: 18.07.2020
  Цель: модуль содержит реализации классов менеджера заказов, заказа,
        позиции заказа.
  Используется: AppModule
  Использует: Custom DataSet, Entity Editor, Kernel Classes
  Исключения: нет }

{
  1.06              18.07.2020
      - добавлен список планшетов для данного заказа
  1.05              07.09.2005
      - добавлена возможность поменять местами заказчика и плательщика

  1.04              06.09.2005
      - добавлена возможность суммирования невидимых работ с видимыми

  1.03              25.08.2005
      - работа с БД полностью переведена на IKisConnection 

  1.02              12.08.2005
      - избавился от ACTUAL_CONTRS_VIEW

  1.01              10.06.2005
      - исправлена ошибка - отдел при изменении в редакторе не сохранялся
}

unit uKisOrders;

interface

{$I KisFlags.pas}

uses
  // System
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  DB, ImgList, ActnList, Contnrs, IBDatabase, DBGrids, Grids, Types,
  // Common
  uDataSet,
  // Project
  uKisEntityEditor, uKisClasses, uKisSQLClasses, uKisSelectMainWork,
  uKisAccounts, uKisOrderEditor;

type
  TKisOrder = class;

  TKisOrderPosition = class;

  TPositionPrintedChange = procedure (Sender: TKisOrderPosition) of object;

  TKisOrderPosition = class(TKisEntity)
  private
    FConnectedTo: Integer;
    FIsSlaveLoaded: Boolean;
    FIsSlave: Boolean;
    FOnPrintedChange: TPositionPrintedChange;
    procedure SetArgument(const Value: String);
    procedure SetAUnit(const Value: String);
    procedure SetWorkTypeCode(const Value: String);
    function GetWorkTypeCode: String;
    function GetAUnit: String;
    function GetWorktypeId: Integer;
    function GetWorkTypeName: String;
    function GetPrice: Double;
    procedure SetPrice(const Value: Double);
    function GetQuantity: Double;
    procedure SetQuantity(const Value: Double);
    procedure SetWorkTypeId(const Value: Integer);
    procedure SetObjectsAmount(const Value: Double);
    function GetArgument: String;
    function GetPrinted: Boolean;
    function GetObjectsAmount: Double;
    procedure SetWorkTypeName(const Value: String);
    procedure SetPrinted(const Value: Boolean);
    function GetConnectedTo: Integer;
    procedure SetConnectedTo(const Value: Integer);
    function GetIsSlave: Boolean;
    procedure LoadIsSlave;
    function OfficesId: Integer;
  protected
    function GetText: String; override;
    procedure InitParams; override;
  public
    constructor Create(Mngr: TKisMngr); override;
    class function EntityName: String; override;
    procedure Copy(Source: TKisEntity); override;
    procedure Load(DataSet: TDataSet); override;
    function Sum: Double;
    property WorkTypeId: Integer read GetWorktypeId write SetWorkTypeId;
    property WorkTypeName: String read GetWorkTypeName write SetWorkTypeName;
    property WorkTypeCode: String read GetWorkTypeCode write SetWorkTypeCode;
    property Price: Double read GetPrice write SetPrice;
    property Quantity: Double read GetQuantity write SetQuantity;
    property ObjectsAmount: Double read GetObjectsAmount write SetObjectsAmount;
    property Argument: String read GetArgument write SetArgument;
    property Printed: Boolean read GetPrinted write SetPrinted;
    property AUnit: String read GetAUnit write SetAUnit;
    property ConnectedTo: Integer read GetConnectedTo write SetConnectedTo;
    property IsSlave: Boolean read GetIsSlave;
    property OnPrintedChange: TPositionPrintedChange read FOnPrintedChange
      write FOnPrintedChange;
  end;

  TPosController = class(TKisEntityController)
  private
    FHandler: TPositionPrintedChange;
    procedure Sort;
    function Positions(const I: Integer): TKisOrderPosition;
    procedure SetHandler(const Value: TPositionPrintedChange);
    property PrintChangeHandler: TPositionPrintedChange read FHandler write SetHandler;
  protected
    function CreateElement: TKisEntity; override;
  public
    procedure FillFieldDefs(FieldDefsRef: TFieldDefs); override;
    function GetFieldData(Index: Integer; Field: TField; out Data): Boolean; override;
    procedure SetFieldData(Index:integer; Field: TField; var Data); override;
  end;

  TKisOrderMap = class(TKisEntity)
  private
    FNomenclature: string;
    procedure SetNomenclature(const Value: string);
  protected
    function GetText: String; override;
    procedure InitParams; override;
  public
    constructor Create(Mngr: TKisMngr); override;
    class function EntityName: String; override;
    procedure Copy(Source: TKisEntity); override;
    procedure Load(DataSet: TDataSet); override;
    //
    property Nomenclature: string read FNomenclature write SetNomenclature;
  end;

  TMapController = class(TKisEntityController)
  private
//    procedure Sort;
//    function Positions(const I: Integer): TKisOrderPosition;
//    procedure SetHandler(const Value: TPositionPrintedChange);
//    property PrintChangeHandler: TPositionPrintedChange read FHandler write SetHandler;
  protected
    function CreateElement: TKisEntity; override;
  public
    procedure FillFieldDefs(FieldDefsRef: TFieldDefs); override;
    function GetFieldData(Index: Integer; Field: TField; out Data): Boolean; override;
    procedure SetFieldData(Index:integer; Field: TField; var Data); override;
  end;    

  TKisOrderMngr = class(TKisSQLMngr)
  private
    function GetPositionIsSlave(aPosition: TKisOrderPosition): Boolean;
    procedure LoadOrderAccount(aOrder: TKisOrder; DataSet: TDataSet);
  protected
    function GenEntityID(EntityKind: TKisEntities = keDefault): Integer; override;
    function IsSupported(Entity: TKisEntity): Boolean; override;
    function GetIdent: TKisMngrs; override;
    function GetMainSQLText: String; override;
    function GetLastCustomerId(CustomerId: Integer; ATransaction: TIBTransaction): Integer;
    function GetMainDataSet: TDataSet; override;
  public
    function CreateEntity(EntityKind: TKisEntities = keDefault): TKisEntity; override;
    function CreateNewEntity(EntityKind: TKisEntities = keDefault): TKisEntity; override;
    function CurrentEntity: TKisEntity; override;
    function GetEntity(EntityID: Integer; EntityKind: TKisEntities = keDefault): TKisEntity; override;
    procedure DeleteEntity(Entity: TKisEntity); override;
    function EditEntity(Entity: TKisEntity): TKisEntity; override;
    function IsEntityInUse(Entity: TKisEntity): Boolean; override;
    procedure SaveEntity(Entity: TKisEntity); override;
    function DuplicateEntity(Entity: TKisEntity): TKisEntity; override;
    function GetCheckBoxImageIndex(Checked: Boolean): Integer;
    function FindOrder(const DocNumber: String; DocDate: TDateTime): TKisOrder;
    function GetActualNDS(): Double;
  end;

  TKisOrder = class(TKisSQLEntity)
  private
    FPosDataSet: TCustomDataSet;
    FPosController: TPosController;
    FMapDataSet: TCustomDataSet;
    FMapController: TMapController;
    FOfficeId: Integer;
    FDocNumber: String;
    FDocDate: String;
    FOrderNumber: String;
    FOrderDate: String;
    FContragent: TKisEntity;
    FNDS: Double;
    FChecked: Boolean;
    FPayDate: String;
    FExecutor: String;
    FActDate: String;
    FContractNumber: String;
    FCustomer: String;
    FObjectAddress: String;
    FValPeriod: Integer;
    FTicket: String;
    FInformation: String;
    FMark: Boolean;
    FClosed: Boolean;
    FSumBase: Double;
    FCancelled: Boolean;
    FPeopleId: Integer;
    FPayer: TKisEntity;
    //FPayerId: Integer;
    FPayerCustomer: String;
    FCustomerBase: String;
    FPrintWorksValue: Boolean;
    FAccount: TKisContragentAccount;
    FOfficeDocId: Integer;
    FLetterId: Integer;
    FAutoLetter: Boolean;
    procedure SetDocNumber(const Value: String);
    procedure SetDocDate(const Value: String);
    procedure SetOrderNumber(const Value: String);
    procedure SetOrderDate(const Value: String);
    procedure SetContragentId(const Value: Integer);
    procedure SetContragent(const Value: TKisEntity);
    procedure SetPayerId(const Value: Integer);
    procedure SetPayer(const Value: TKisEntity);
    procedure SetNDS(const Value: Double);
    procedure SetChecked(const Value: Boolean);
    procedure SetPayDate(const Value: String);
    procedure SetExecutor(const Value: String);
    procedure SetActDate(const Value: String);
    procedure SetContractNumber(const Value: String);
    procedure SetCustomer(const Value: String);
    procedure SetPayerCustomer(const Value: String);
    procedure SetObjectAddress(const Value: String);
    procedure SetValPeriod(const Value: Integer);
    procedure SetTicket(const Value: String);
    procedure SetInformation(const Value: String);
    procedure SetMark(const Value: Boolean);
    procedure SetSumBase(const Value: Double);
    procedure SetCancelled(const Value: Boolean);
    procedure SetPrintWorksValue(const Value: Boolean);
    procedure SelectContragent(Sender: TObject);
    procedure SelectPayer(Sender: TObject);
    procedure ViewContragent(Sender: TObject);
    procedure ClearContragent(Sender: TObject);
    procedure ViewPayer(Sender: TObject);
    procedure ClearPayer(Sender: TObject);
    procedure SetLabelAccount;
    procedure UpdateEditorByContragent(WithPresentative: Boolean = False);
    procedure UpdateEditorByPayer(WithPresentative: Boolean = False);
    procedure PositionsChange(DataSet: TDataSet);
    procedure PositionsInsert(DataSet: TDataSet);
    procedure EditPosition(Sender: TObject);
    function GetContragentId: Integer;
    function GetPayerId: Integer;
    procedure SetPeopleId(const Value: Integer);

    function PrintedWorksExists(PosCtrlr: TPosController): Boolean;

    procedure DBGridDrawColumnCell(Sender: TObject; const Rect: TRect;
      DataCol: Integer; Column: TColumn; State: TGridDrawState);
    procedure DBGridCellClick(Column: TColumn);
    procedure DBGridKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure DBGridColors(Sender: TObject; Field: TField;
      var Background, FontColor: TColor; State: TGridDrawState; var FontStyle: TFontStyles);
    procedure SetCustomerBase(const Value: String);
    procedure SelectPosition;
    procedure OnPositionPrintedChange(aPosition: TKisOrderPosition);
    procedure PositionDisconnectChilds(aPosition: TKisOrderPosition);
    function CheckPositions: Boolean;
    function CheckConnectedPositions: Boolean;
    procedure SelectMainWork(Sender: TObject);
    function CurrentPos: TkisOrderPosition;
    function OrderMngr: TKisOrderMngr;
    procedure CopyAccount(SourceOrder: TKisOrder);
    procedure CopyPositions(SourceOrder: TKisOrder);
    procedure CopyMaps(SourceOrder: TKisOrder);
    procedure ExchangeContragentAndPayer(Sender: TObject);
    procedure SelectAccountHandler(Sender: TObject);
    procedure SetAccount(const Value: TKisContragentAccount);
    procedure UpdateEditorByAccount;
    function OrderEditor: TKisOrderEditor;
    function GetBankId: Integer;
    function GetAccountNumber: String;
    function GetAccountType: TKisAccountType;
    procedure SetOfficeDocId(const Value: Integer);
    procedure SetClosed(const Value: Boolean);
    procedure SetLetterId(const Value: Integer);
  protected
    procedure PrepareEditor(Editor: TKisEntityEditor); override;
    procedure UnprepareEditor(Editor: TKisEntityEditor); override;
    function CreateEditor: TKisEntityEditor; override;
    procedure LoadDataIntoEditor(Editor: TKisEntityEditor); override;
    procedure ReadDataFromEditor(Editor: TKisEntityEditor); override;
    function CheckEditor(Editor: TKisEntityEditor): Boolean; override;
    function GetText: String; override;
  public
    constructor Create(Mngr: TKisMngr); override;
    destructor Destroy; override;
    class function EntityName: String; override;
    function IsEmpty: Boolean; override;
    procedure Assign(Source: TPersistent); override;
    procedure Copy(Source: TKisEntity); override;
    procedure Load(DataSet: TDataSet); override;
    function Sum: Double;
    function SumNDS: Double;
    function SumAll: Double;
    //
    procedure AddMap(aMap: TKisOrderMap);
    procedure AddPosition(APos: TKisOrderPosition);
    procedure UpdateSums;
    //
    property Maps: TCustomDataSet read FMapDataSet;
    property Positions: TCustomDataSet read FPosDataSet;
    //
    property OfficeId: Integer read FOfficeId write FOfficeId;
    property PeopleId: Integer read FPeopleId write SetPeopleId;
    // счет
    property DocNumber: String read FDocNumber write SetDocNumber;
    property DocDate: String read FDocDate write SetDocDate;
    // заказ
    property OrderNumber: String read FOrderNumber write SetOrderNumber;
    property OrderDate: String read FOrderDate write SetOrderDate;
    // Заказчик
    property ContragentId: Integer read GetContragentId write SetContragentId;
    property Contragent: TKisEntity read FContragent write SetContragent;
    property CustomerBase: String read FCustomerBase write SetCustomerBase;
    //
    property ContractNumber: String read FContractNumber write SetContractNumber;
    property ValPeriod: Integer read FValPeriod write SetValPeriod;
    //
    property NDS: Double read FNDS write SetNDS;
    property SumBase: Double read FSumBase write SetSumBase;
    //
    property PayDate: String read FPayDate write SetPayDate;
    property Executor: String read FExecutor write SetExecutor;
    property ActDate: String read FActDate write SetActDate;
    property Customer: String read FCustomer write SetCustomer;
    property ObjectAddress: String read FObjectAddress write SetObjectAddress;
    property Ticket: String read FTicket write SetTicket;
    property Information: String read FInformation write SetInformation;
    //
    property Mark: Boolean read FMark write SetMark;
    property Checked: Boolean read FChecked write SetChecked;
    property Cancelled: Boolean read FCancelled write SetCancelled;
    property Closed: Boolean read FClosed write SetClosed;
    //плательщик
    property PayerId: Integer read GetPayerId write SetPayerId;
    property Payer: TKisEntity read FPayer write SetPayer;
    property PayerCustomer: String read FPayerCustomer write SetPayerCustomer;
    property PrintWorksValue: Boolean read FPrintWorksValue write SetPrintWorksValue;
    property BankAccount: TKisContragentAccount read FAccount write SetAccount;
    property BankId: Integer read GetBankId;
    property AccountNumber: String read GetAccountNumber;
    property AccountType: TKisAccountType read GetAccountType;
    property OfficeDocId: Integer read FOfficeDocId write SetOfficeDocId;
    property LetterId: Integer read FLetterId write SetLetterId;
    property LetterAutoGenerated: Boolean read FAutoLetter write FAutoLetter;
  end;

  TKisOrderSaver = class(TKisEntitySaver)
  protected
    function GetSQL: String; override;
    procedure PrepareParams(DataSet: TDataSet); override;
  end;

  TKisOrderPositionSaver = class(TKisEntitySaver)
  protected
    function GetSQL: String; override;
    procedure PrepareParams(DataSet: TDataSet); override;
  end;

  TKisOrderMapSaver = class(TKisEntitySaver)
  protected
    function GetSQL: String; override;
    procedure PrepareParams(DataSet: TDataSet); override;
  end;

implementation

{$R *.dfm}

uses
  // System
  Math, 
  // Common
  uIBXUtils, uGC, uCommonUtils, uVCLUtils, uCommonClasses,
  // Project
  uKisAppModule, uKisConsts, uKisContragents, uKisUtils, uKisFilters,
  WorkTypes, uKisIntf;

const
  SQ_GET_ORDER = 'SELECT * FROM ORDERS WHERE ID=%d';
  SQ_GET_ORDER_POSITIONS = 'SELECT * FROM ORDER_POSITIONS WHERE ORDERS_ID=%d';
  SQ_GET_ORDER_LETTER_INFO = 'SELECT FIRST 1 LETTERS_ID, KIND FROM LETTERS_ORDERS WHERE ORDERS_ID=%d';// AND KIND = 1';
  SQ_GET_ORDER_MAPS = 'SELECT * FROM ORDER_MAPS WHERE ORDERS_ID=%d';
  SQ_DELETE_ORDER = 'DELETE FROM ORDERS WHERE ID=%d';
  SQ_SAVE_ORDER =
      'EXECUTE PROCEDURE SAVE_ORDER2(:ID, :OFFICES_ID, :DOC_NUMBER,'
    + ':DOC_DATE, :ORDER_NUMBER, :ORDER_DATE, :CONTRAGENTS_ID, :NDS, :SUMMA,'
    + ':SUM_NDS, :CHECKED, :PAY_DATE, :EXECUTOR, :ACT_DATE, :CONTRACT_NUMBER,'
    + ':OBJECT_ADDRESS, :CUSTOMER, :VAL_PERIOD, :TICKET, :INFORMATION,'
    + ':MARK_EXECUTOR, :SUM_BASE, :CANCELLED, :PEOPLE_ID, :PAYER_ID, '
    + ':PAYER_CUSTOMER, :CUSTOMER_BASE, :PRINT_WORKS_VALUE, :PAYER_ACCOUNT,'
    + ':PAYER_BANK_ID, :PAYER_ACCOUNT_TYPE, :OFFICE_DOCS_ID, :CLOSED, :LETTERS_ID)';
  SQ_CLEAR_POSITIONS = 'DELETE FROM ORDER_POSITIONS WHERE ORDERS_ID=%d';
  SQ_CLEAR_ORDER_MAPS = 'DELETE FROM ORDER_MAPS WHERE ORDERS_ID=%d';
  SQ_SAVE_ORDER_POSITION =
      'EXECUTE PROCEDURE SAVE_ORDER_POSITION(:ID,'
    + ':ORDERS_ID, :WORK_TYPES_ID, :WORK_TYPES_NAME, :PRICE, :QUANTITY,'
    + ':SUMMA, :ARGUMENT, :UNIT, :WORK_TYPE_CODE, :OBJECTS_AMOUNT, :PRINTED, :CONNECTED_TO)';
  SQ_SAVE_ORDER_MAP =
      'INSERT INTO ORDER_MAPS (ID, ORDERS_ID, NOMENCLATURE) '
    + 'VALUES (:ID, :ORDERS_ID, :NOMENCLATURE)';
  SQ_CHECK_CONTRAGENT = 'SELECT CONTRAGENTS_ID AS ID FROM CONTRAGENTS_ACTUAL WHERE PARENT_ID=%d';
  SQ_GEL_LAST_CUSTOMER_ID = 'SELECT ID FROM ACTUAL_CUSTOMER_ID(%d)';
  SQ_SELECT_NDS = 'SELECT NDS FROM PARAMETERS';
  SQ_GET_POSITION_IS_SLAVE = 'SELECT IS_SLAVE FROM WORK_TYPES WHERE OFFICES_ID=%d AND ID=%d';
  SQ_FIND_ORDER_1 = 'SELECT ID FROM ORDERS WHERE DOC_NUMBER=:DOC_NUMBER AND DOC_DATE=:DOC_DATE';

  SG_ORDERS = 'ORDERS';
  SG_ORDER_POSITIONS = 'ORDER_POSITIONS';
  SG_ORDER_MAPS = 'ORDER_MAPS';

  S_POS = 'Позиция заказа';
  S_ORDER_MAP = 'Планшет';

{ TKisOrder }

procedure TKisOrder.AddMap(aMap: TKisOrderMap);
begin
  FMapController.DirectAppend(aMap);
end;

procedure TKisOrder.AddPosition(APos: TKisOrderPosition);
begin
  FPosController.DirectAppend(APos);
end;

procedure TKisOrder.SelectPosition;
var
  WorkId, I: Integer;
  WorkName, WorkArgument, WorkCode, AObjectAddress: String;
  WorkPrice: Double;
begin
  if Assigned(EntityEditor) then
  with EntityEditor as TKisOrderEditor do
  begin
    WorkId := Positions.FieldByName(SF_WORK_TYPES_ID).AsInteger;
    if ShowWorkTypes(WorkId, WorkName, WorkArgument, WorkCode, WorkPrice) then
    begin
      for I := 1 to Pred(FPosController.GetRecordCount) do
      with FPosController.Elements[I] as TKisOrderPosition do
        if WorkTypeId = WorkId then
        begin
          MessageBox(Handle, PChar(S_WORKTYPE_ALREADY_EXISTS), PChar(S_WARN), MB_ICONSTOP);
          Positions.Cancel;
          Abort;
        end;
      if not (Positions.State in [dsInsert, dsEdit]) then
        Positions.Edit;
      Positions.FieldByName(SF_WORK_TYPES_ID).AsInteger := WorkId;
      Positions.FieldByName(SF_WORK_TYPE_CODE).AsString := WorkCode;
      AObjectAddress := Trim(edObjectAddress.Text);
      if AObjectAddress <> '' then AObjectAddress := ' ' + AObjectAddress;
      Positions.FieldByName(SF_WORK_TYPES_NAME).AsString := WorkName + AObjectAddress;
      Positions.FieldByName(SF_ARGUMENT).AsString := WorkArgument;
      if WorkPrice > 0 then
        Positions.FieldByName(SF_PRICE).AsFloat := WorkPrice;
      Positions.FieldByName(SF_ID).AsInteger := TKisOrderMngr(Self.Manager).GenEntityID(keOrderPosition);
      Positions.Post;
      dbgPositions.SetFocus;
    end;
  end;
end;

function TKisOrder.CheckEditor(Editor: TKisEntityEditor): Boolean;
var
  OrderDate_, ActDate_: TDateTime;
  TmpDate: TDateTime;
begin
  //проверка правильности заполнения полей в заказе
  Result := False;
  with Editor as TKisOrderEditor do
  begin
    if cbExecutor.ItemIndex < 0 then   //проверка исполнителя 
    begin
      MessageBox(Handle, PChar(S_CHECK_EXECUTOR), PChar(S_WARN), MB_OK);
      PageControl.ActivePageIndex := 0;
      cbExecutor.SetFocus;
      Exit;
    end;
{    if Trim(edObjectAddress.Text) = '' then
    begin
      MessageBox(Handle, PCHECKOBJECTADDRESS, PWARN, MB_OK);
      PageControl.ActivePageIndex := 0;
      edObjectAddress.SetFocus;
      Exit;
    end;  }
     if ContragentId < 1 then
       ContragentId := 0; //попытка подставить нулевого контрагента
{    if ContragentId < 1 then
    begin
      MessageBox(Handle, PChar(S_CHECK_CONTRAGENT), PChar(S_WARN), MB_OK);
      PageControl.ActivePageIndex := 0;
      edContragentName.SetFocus;
      Exit;
    end; }
    if cbChecked.Checked then
    begin
      if not TryStrToDate(edPayDate.Text, TmpDate) then
      begin
        MessageBox(Handle, PChar(S_CHECK_PAY_DATE), PChar(S_WARN), MB_OK);
        PageControl.ActivePageIndex := 0;
        edPayDate.SetFocus;
        Exit;
      end;
      if Trim(edTicket.Text) = '' then
      begin
        MessageBox(Handle, PChar(S_CHECK_TICKET), PChar(S_WARN), MB_OK);
        PageControl.ActivePageIndex := 0;
        edTicket.SetFocus;
        Exit;
      end;
    end;
    if Trim(edOrderNumber.Text) = '' then
    begin
      MessageBox(Handle, PChar(S_CHECK_ORDER_NUMBER), PChar(S_WARN), MB_OK);
      PageControl.ActivePageIndex := 0;
      edOrderNumber.SetFocus;
      Exit;
    end;
    if (not TryStrToDate(edOrderDate.Text, OrderDate_))
      and ((OrderDate_ < MIN_DOC_DATE) or (OrderDate_ > Date)) then
    begin
      MessageBox(Handle, PChar(S_CHECK_ORDER_NUMBER), PChar(S_WARN), MB_OK);
      PageControl.ActivePageIndex := 0;
      edOrderNumber.SetFocus;
      Exit;
    end;
    if not CheckStrIsFloat(edValPeriod.Text) then
    begin
      MessageBox(Handle, PChar(S_CHECK_VAL_PERIOD), PChar(S_WARN), MB_OK);
      PageControl.ActivePageIndex := 0;
      edValPeriod.SetFocus;
      Exit;
    end;
    TmpDate := MIN_DOC_DATE - 1;
    if (edDocDate.Text <> '') then
      if (not TryStrToDate(edDocDate.Text, TmpDate))
        and ((TmpDate < MIN_DOC_DATE) or
             (TmpDate > Date)) then
      begin
        MessageBox(Handle, PChar(S_CHECK_ACCOUNT_DATE), PChar(S_WARN), MB_OK);
        PageControl.ActivePageIndex := 0;
        edDocDate.SetFocus;
        Exit;
      end;
    if (edDocNumber.Text <> '') or (edDocDate.Text <> '') then
    begin
      if Trim(edDocNumber.Text) = '' then
      begin
        MessageBox(Handle, PChar(S_CHECK_ACCOUNT_NUMBER), PChar(S_WARN), MB_OK);
        PageControl.ActivePageIndex := 0;
        edDocNumber.SetFocus;
        Exit;
      end;
    end;
    if edActDate.Text <> '' then
    begin
      if not TryStrToDate(edActDate.Text, ActDate_) and (ActDate_ < OrderDate_)
        and ((ActDate_ < MIN_DOC_DATE) or
             (ActDate_ > Date)) then
      begin
        MessageBox(Handle, PChar(S_CHECK_ACT_DATE), PChar(S_WARN), MB_OK);
        PageControl.ActivePageIndex := 0;
        edActDate.SetFocus;
        Exit;
      end;
    end;
{    if Trim(edContractNumber.Text) = '' then
    begin
      MessageBox(Handle, PCHECKCONTRACTNUMBER, PWARN, MB_OK);
      PageControl.ActivePageIndex := 0;
      edContractNumber.SetFocus;
      Exit;
    end;  }
    if not CheckPositions then
    begin
      PageControl.TabIndex := 1;
      dbgPositions.SetFocus;
      Exit;
    end;
  end;
  Result := True;
end;

procedure TKisOrder.ClearContragent(Sender: TObject);
begin
  if not Self.Contragent.IsEmpty then
  begin
    FContragent.Free;
    FContragent := AppModule.Mngrs[kmContragents].CreateEntity(keDefault);
    UpdateEditorByContragent;
  end;
end;

procedure TKisOrder.Copy(Source: TKisEntity);
var
  CtrType: TKisEntities;
begin
  inherited;
  with Source as TKisOrder do
  begin
    Self.Modified := Modified; 
    Self.FOfficeId := OfficeId;
    Self.FPeopleId := PeopleId;
    Self.FDocNumber := DocNumber;
    Self.FDocDate := DocDate;
    Self.FOrderNumber := OrderNumber;
    Self.FContragent.Free;
    case TKisContragent(Contragent).ContrType of
    CT_ORG : CtrType := keContrOrg;
    CT_PERSON : CtrType := keContrPerson;
    CT_PRIVATE : CtrType := keContrPrivate;
    else
      CtrType := keDefault;
    end;
    Self.FContragent := AppModule.Mngrs[kmContragents].CreateEntity(CtrType);
    Self.FContragent.Assign(Contragent);
    FreeAndNil(Self.FPayer);
    if Assigned(Payer) then
    begin
      case TKisContragent(Payer).ContrType of
        CT_ORG : CtrType := keContrOrg;
        CT_PERSON : CtrType := keContrPerson;
        CT_PRIVATE : CtrType := keContrPrivate;
    else
      CtrType := keDefault;
    end;
      Self.FPayer := AppModule.Mngrs[kmContragents].CreateEntity(CtrType);
      Self.FPayer.Assign(Payer);
    end;
    Self.FOrderDate := OrderDate;
    Self.FNDS := NDS;
    Self.FChecked := Checked;
    Self.FPayDate := PayDate;
    Self.FExecutor := Executor;
    Self.FActDate := ActDate;
    Self.FContractNumber := ContractNumber;
    Self.FCustomer := Customer;
    Self.FPayerCustomer := PayerCustomer;
    Self.FObjectAddress := ObjectAddress;
    Self.FValPeriod := ValPeriod;
    Self.FTicket := Ticket;
    Self.FInformation := Information;
    Self.FMark := Mark;
    Self.FSumBase := SumBase;
    Self.FCancelled := Cancelled;
    Self.FCustomerBase := CustomerBase;
    Self.FPrintWorksValue := PrintWorksValue;
    Self.FOfficeDocId := OfficeDocId;
    Self.FClosed := Closed;
    Self.FLetterId := LetterId;
    Self.FAutoLetter := LetterAutoGenerated;
    // Копруем позиции заказа
    Self.CopyPositions(TKisOrder(Source));
    Self.CopyAccount(TKisOrder(Source));
    Self.CopyMaps(TKisOrder(Source));
  end;
end;

constructor TKisOrder.Create(Mngr: TKisMngr);
begin
  inherited;
  FPosController := TPosController.CreateController(Mngr, Mngr, keOrderPosition);
//  FPosController.ElementType := ;
  FPosController.HeadEntity := Self;
  FPosDataSet := TCustomDataSet.Create(Mngr);
  FPosDataSet.Controller := FPosController;
  //
  FMapController := TMapController.CreateController(Mngr, Mngr, keOrderMap);
  FMapController.HeadEntity := Self;
  FMapDataSet := TCustomDataSet.Create(Mngr);
  FMapDataSet.Controller := FMapController;
  //
  FContragent := AppModule.Mngrs[kmContragents].CreateEntity(keDefault);
  FPayer := AppModule.Mngrs[kmContragents].CreateEntity(keDefault);
  FPosDataSet.Open;
  FMapDataSet.Open;
  FOrderDate := FormatDateTime(S_DATESTR_FORMAT, Date);
  FValPeriod := 50;
  FNDS := 0;
end;

function TKisOrderMngr.EditEntity(Entity: TKisEntity): TKisEntity;
begin
  Result := nil;
  if IsSupported(Entity) then
  begin
    Result := TKisOrder.Create(Self);
    Result.Assign(Entity);
    Result.Modified := TKisOrder(Result).Edit;
  end;
end;

function TKisOrderMngr.FindOrder(const DocNumber: String;
  DocDate: TDateTime): TKisOrder;
var
  Conn: IKisConnection;
  Ds: TDataSet;
begin
  Result := nil;
  Conn := GetConnection(True, False);
  try
    Ds := Conn.GetDataSet(SQ_FIND_ORDER_1);
    Conn.SetParam(Ds, SF_DOC_NUMBER, DocNumber);
    Conn.SetParam(Ds, SF_DOC_DATE, DocDate);
    Ds.Open;
    if Ds.RecordCount > 0 then
      Result := GetEntity(Ds.FieldByName(SF_ID).AsInteger, keOrder) as TKisOrder;
    Ds.Close;
    FreeConnection(Conn, True);
  except
    FreeConnection(Conn, False);
    raise;
  end;
end;

function TKisOrder.CreateEditor: TKisEntityEditor;
begin
  if not Assigned(EntityEditor) then
  begin
    EntityEditor := TKisOrderEditor.Create(Application);
  end;
  Result := EntityEditor;
end;

destructor TKisOrder.Destroy;
begin
  FPosDataSet.Free;
  FPosController.Free;
  FMapDataSet.Free;
  FMapController.Free;
  FreeAndNil(FAccount);
  inherited;
end;

function TKisOrderMngr.GetIdent: TKisMngrs;
begin
  Result := kmOrders;
end;

procedure TKisOrder.PrepareEditor(Editor: TKisEntityEditor);
begin
  inherited;
  with EntityEditor as TKisOrderEditor do
  begin
    Positions.AfterPost := PositionsChange;
    Positions.AfterDelete := PositionsChange;
    Positions.AfterInsert := PositionsInsert;
    btnContragentSelect.OnClick := SelectContragent;
    btnContragentDetail.OnClick := ViewContragent;
    btnContragentClear.OnClick := ClearContragent;
    btnEditPosition.OnClick := EditPosition;
    btnPayerSelect.OnClick := SelectPayer;
    btnPayerClear.OnClick := ClearPayer;
    btnPayerDetail.OnClick := ViewPayer;

    dbgPositions.OnDrawColumnCell := Self.DBGridDrawColumnCell;
    dbgPositions.OnCellColors := DBGridColors;
    dbgPositions.OnCellClick := Self.DBGridCellClick;
    dbgPositions.OnKeyDown := Self.DBGridKeyDown;
    dsPositions.DataSet := Positions;
    dbgPositions.DataSource := dsPositions;

    btnSum.OnClick := SelectMainWork;

    btnExChange.OnClick := ExchangeContragentAndPayer;
    btnSelectAccount.OnClick := SelectAccountHandler;

    FPosController.PrintChangeHandler := OnPositionPrintedChange;
    dsMaps.DataSet := FMapDataSet;
  end;
end;

procedure TKisOrder.UnprepareEditor(Editor: TKisEntityEditor);
begin
  with Editor as TKisOrderEditor do
  begin
    Positions.AfterPost := nil;
    Positions.AfterDelete := nil;
    Positions.AfterInsert := nil;
    btnSum.OnClick := nil;
    btnExChange.OnClick := nil;
    FPosController.PrintChangeHandler := nil;
  end;
  inherited;
end;

procedure TKisOrder.LoadDataIntoEditor(Editor: TKisEntityEditor);
var
  TmpID: Integer;
  VAL: Variant;
  NumDoc: String;
  Letter: TKisEntity;
begin
  inherited;
  if Editor is TKisOrderEditor then
    with Editor as TKisOrderEditor do
    begin
      if Self.OfficeId > 0 then
        TmpID := Self.OfficeId
      else
        TmpId := AppModule.User.OfficeID;
      with IObject(AppModule.Lists[klOffices]) do
        cbOffices.Items := TStringList(AObject);
      cbOffices.ItemIndex := -1;
      ComboLocate(cbOffices, TmpID);
  {    for I := 0 to Pred(cbOffices.Items.Count) do
        if Integer(cbOffices.Items.Objects[I]) = TmpID then
        begin
          cbOffices.ItemIndex := I;
          Break;
        end;   }
      with IObject(AppModule.PeolpeList(TmpID)) do
        cbExecutor.Items := TStringList(AObject);
        if (Self.Executor <> '') then
      if cbExecutor.Items.IndexOf(Self.Executor) < 0 then
        cbExecutor.Items.AddObject(Self.Executor, TObject(Self.PeopleId));
      if Self.PeopleId > 0 then
        TmpID := Self.PeopleId
      else
        TmpId := -1;
      cbExecutor.ItemIndex := -1;
      ComboLocate(cbExecutor, TmpID);
  {    for I := 0 to Pred(cbExecutor.Items.Count) do
        if Integer(cbExecutor.Items.Objects[I]) = TmpID then
        begin
          cbExecutor.ItemIndex := I;
          Break;
        end;   }
      edDocNumber.Text := Self.DocNumber;
      edDocDate.Text := Self.DocDate;
      edOrderNumber.Text := Self.OrderNumber;
      edOrderDate.Text := Self.OrderDate;
      cbChecked.Checked := Self.Checked;
      cbCancelled.Checked := Self.Cancelled;
      edContractNumber.Text := Self.ContractNumber;
      edValPeriod.Text := IntToStr(Self.ValPeriod);
      edSumBase.Text := FloatToStr(Self.SumBase);
      edPayDate.Text := Self.PayDate;
      cbExecutor.Text := Self.Executor;
      edActDate.Text := Self.ActDate;
      edCustomer.Text := Self.Customer;
      edObjectAddress.Text := Self.ObjectAddress;
      edTicket.Text := Self.Ticket;
      edInformation.Text := Self.Information;
      cbMark.Checked := Self.Mark;
      edNDS.Text := FloatToStr(Self.NDS);
      cbPrintWorksValue.Checked := Self.PrintWorksValue;
      cbClosed.Checked := Self.Closed;
      UpdateEditorByContragent;
      UpdateEditorByPayer;
      UpdateEditorByAccount;
      UpdateSums;
      edCustomerBase.Text := Self.CustomerBase;
      //show doc number
      if AppModule.GetFieldValue(nil, 'OFFICE_DOCS', 'ID', 'DOC_NUMBER', FOfficeDocId, VAL)
         and not VarIsNull(VAL)
      then
      begin
        NumDoc := VAL;
        labelNumDoc.Caption := 'Номер заявки  отдела: ' + NumDoc;
      end
      else
        labelNumDoc.Caption := 'Номер заявки  отдела: нет';
      //
      if LetterId = 0 then
        Letter := nil
      else
        Letter := AppModule.Mngrs[kmLetters].GetEntity(LetterId, keLetter);
      UpdateLetterInfo(Letter);
    end;
end;

procedure TKisOrder.ReadDataFromEditor(Editor: TKisEntityEditor);
begin
  inherited;
  if Editor is TKisOrderEditor then
  with Editor as TKisOrderEditor do
  begin
    Self.DocNumber := edDocNumber.Text;
    Self.DocDate := edDocDate.Text;
    Self.OrderNumber := edOrderNumber.Text;
    Self.OrderDate := edOrderDate.Text;
    Self.Checked := cbChecked.Checked;
    Self.Cancelled := cbCancelled.Checked;
    Self.ContractNumber := edContractNumber.Text;
    Self.ValPeriod := StrToInt(edValPeriod.Text);
    Self.SumBase := StrToFloat(edSumBase.Text);
    Self.PayDate := edPayDate.Text;
    Self.Executor := cbExecutor.Text;
    Self.ActDate := edActDate.Text;
    Self.Customer := edCustomer.Text;
    Self.ObjectAddress := edObjectAddress.Text;
    Self.Ticket := edTicket.Text;
    Self.Information := edInformation.Text;
    Self.Mark := cbMark.Checked;
    Self.PeopleId := Integer(cbExecutor.Items.Objects[cbExecutor.ItemIndex]);
    Self.PayerCustomer := edPayerCustomer.Text;
    Self.CustomerBase := Trim(edCustomerbase.Text);
    Self.PrintWorksValue := cbPrintWorksValue.Checked;
    Self.OfficeId := Integer(cbOffices.Items.Objects[cbOffices.ItemIndex]);
    Self.NDS := StrToFloatDef(edNDS.Text, 0);
    Self.Closed := cbClosed.Checked;
    UpdateSums();
  end;
end;

procedure TKisOrder.SelectContragent(Sender: TObject);
var
  ContrMngr: TKisContragentMngr;
  aCustomer, aPayer, aContragent: TKisContragent;
  aContrType: TKisEntities;
  IsSubdivision: Boolean;
begin
  // Выбор контрагента пользователем
  ContrMngr := TKisContragentMngr(AppModule.Mngrs[kmContragents]);
  with TFilterFactory do
    aContragent := ContrMngr.SelectEntity(True,
      CreateList(
        CreateFilter(SF_TYPE_ID, TKisContragent(Self.Contragent).ContrType, frEqual)),
      True, Self.ContragentId) as TKisContragent;
  // Если выбор сделан
  if Assigned(aContragent) then
  begin
    case aContragent.ContrType of
    CT_ORG : aContrType := keContrOrg;
    CT_PERSON : aContrType := keContrPerson;
    CT_PRIVATE : aContrType := keContrPrivate;
    else
      Exit;
    end;
    IsSubdivision := (aContrType = keContrOrg)
      and (TKisContragentOrganisation(aContragent).HeadOrgId > 0);
    if IsSubdivision then
    begin
      aCustomer := TKisContragent(ContrMngr.GetEntity(TKisContragentOrganisation(aContragent).HeadOrgId));
      aPayer := aContragent;
    end
    else
    begin
      aCustomer := aContragent;
      aPayer := TKisContragent(ContrMngr.CreateEntity(aContrType));
      aPayer.Assign(aContragent);
    end;
    Self.Contragent := aCustomer;
    Self.Payer := aPayer;
    UpdateEditorByContragent(TKisOrderEditor(EntityEditor).edCustomer.Text = '');
    UpdateEditorByPayer(TKisOrderEditor(EntityEditor).edPayerCustomer.Text = '');
    UpdateEditorByAccount;
    // Устанавливаем представителем заказчика руководителя филиала 
    if IsSubdivision then
    if Assigned(EntityEditor) then
    begin
      TKisOrderEditor(EntityEditor).edCustomer.Text := aPayer.CustomerRepresentativeName;
      TKisOrderEditor(EntityEditor).edCustomerBase.Text := TKisContragentOrganisation(aPayer).GetChiefDoc;
    end;
  end;
end;

procedure TKisOrder.SetActDate(const Value: String);
begin
  FActDate := Value;
end;

procedure TKisOrder.SetCancelled(const Value: Boolean);
begin
  if FCancelled <> Value then
  begin
    FCancelled := Value;
    Modified := True;
  end;
end;

procedure TKisOrder.SetChecked(const Value: Boolean);
begin
  if FChecked <> Value then
  begin
    FChecked := Value;
    Modified := True;
  end;
end;

procedure TKisOrder.SetClosed(const Value: Boolean);
begin
  if FClosed <> Value then
  begin
    FClosed := Value;
    Modified := True;
  end;
end;

procedure TKisOrder.SetContractNumber(const Value: String);
begin
  FContractNumber := Value;
end;

procedure TKisOrder.SetContragent(const Value: TKisEntity);
begin
  if Assigned(FContragent) then
  begin
    if not FContragent.Equals(Value) then
    begin
      FreeAndNil(FContragent);
      FContragent := Value;
      Modified := True;
    end
  end
  else
  begin
    FContragent := Value;
    Modified := True;
  end;
end;

procedure TKisOrder.SetContragentId(const Value: Integer);
begin
  if ContragentId <> Value then
    Contragent := AppModule.Mngrs[kmContragents].GetEntity(Value);
end;

procedure TKisOrder.SetCustomer(const Value: String);
begin
  if FCustomer <> Value then
  begin
    FCustomer := Value;
    Modified := True;
  end;
end;

procedure TKisOrder.SetDocDate(const Value: String);
begin
  if FDocDate <> Value then
  begin
    FDocDate := Value;
    Modified := True;
  end;
end;

procedure TKisOrder.SetDocNumber(const Value: String);
begin
  if FDocNumber <> Value then
  begin
    FDocNumber := Value;
    Modified := True;
  end;
end;

procedure TKisOrder.SetExecutor(const Value: String);
begin
  if FExecutor <> Value then
  begin
    FExecutor := Value;
    Modified := True;
  end;
end;

procedure TKisOrder.SetInformation(const Value: String);
begin
  if FInformation <> Value then
  begin
    FInformation := Value;
    Modified := True;
  end;
end;

procedure TKisOrder.SetMark(const Value: Boolean);
begin
  if FMark <> Value then
  begin
    FMark := Value;
    Modified := True;
  end;
end;

procedure TKisOrder.SetNDS(const Value: Double);
begin
  FNDS := Value;
  if FNDS <> Value then
  begin
    FNDS := Value;
    Modified := True;
  end;
end;

procedure TKisOrder.SetObjectAddress(const Value: String);
begin
  if FObjectAddress <> Value then
  begin
    FObjectAddress := Value;
    Modified := True;
  end;
end;

procedure TKisOrder.SetOrderDate(const Value: String);
begin
  if FOrderDate <> Value then
  begin
    FOrderDate := Value;
    Modified := True;
  end;
end;

procedure TKisOrder.SetOrderNumber(const Value: String);
begin
  if FOrderNumber <> Value then
  begin
    FOrderNumber := Value;
    Modified := True;
  end;
end;

procedure TKisOrder.SetPayDate(const Value: String);
begin
  if FPayDate <> Value then
  begin
    FPayDate := Value;
    Modified := True;
  end;
end;

procedure TKisOrder.SetSumBase(const Value: Double);
begin
  if FSumBase <> Value then
  begin
    FSumBase := Value;
    Modified := True;
  end;
end;

procedure TKisOrder.SetTicket(const Value: String);
begin
  if FTicket <> Value then
  begin
    FTicket := Value;
    Modified := True;
  end;
end;

procedure TKisOrder.SetValPeriod(const Value: Integer);
begin
  if FValPeriod <> Value then
  begin
    FValPeriod := Value;
    Modified := True;
  end;
end;

function TKisOrder.Sum: Double;
var
  Recno: Integer;
begin
  Result := 0;
  Recno := Positions.RecNo;
  Positions.DisableControls;
  try
    Positions.First;
    while not Positions.Eof do
    begin
      Result := Result + RoundX(Positions.FieldByName(SF_SUMMA).AsFloat, 2);
      Positions.Next;
    end;
  finally
    Positions.EnableControls;
  end;
  Positions.RecNo := RecNo;
end;

function TKisOrder.SumAll: Double;
begin
  Result := Sum + SumNDS;
end;

function TKisOrder.SumNDS: Double;
begin
  Result := RoundX(Sum * NDS / 100, 2);
end;

procedure TKisOrder.UpdateEditorByContragent;
var
  CustomerName, CustomerBaseDoc: String;
  aContragent: TKisContragent;
begin
  SetLabelAccount;
  aContragent := Self.Contragent as TKisContragent;
  if Assigned(EntityEditor) then
  with EntityEditor as TKisOrderEditor do
  begin
    edContragentName.Text := aContragent.AsText;
    edContragentAddress.Text := aContragent.Address1.AsText;
    mContragentProperties.Lines.Text := aContragent.Properties;
    edPhones.Text := aContragent.Phones;
    edINN.Text := aContragent.INN;
    mContragentBank.Text := aContragent.BankName;
    edBankAccount.Text := aContragent.BankAccount;
    if WithPresentative then
    begin
      if aContragent.ContrType = CT_ORG then
        CustomerBaseDoc := TKisContragentOrganisation(aContragent).GetChiefDoc
      else
        CustomerBaseDoc := '';
      CustomerName := aContragent.CustomerRepresentativeName;
    end
    else
      CustomerName := Self.Customer;
    edCustomer.Text := CustomerName;
    edCustomerBase.Text := CustomerBaseDoc;
  end;
end;

procedure TKisOrder.ViewContragent(Sender: TObject);
begin
  if not Self.Contragent.IsEmpty then
  with Self.Contragent as TKisVisualEntity do
  begin
    ReadOnly := True;
    Edit;
    ReadOnly := False;
  end;
end;

procedure TKisOrder.UpdateSums;
begin
  if Assigned(EntityEditor) then
  with EntityEditor as TKisOrderEditor do
  begin
    lAll.Caption := FloatToStr(Self.Sum);
    lNDS.Caption := FloatToStr(Self.SumNDS);
    lAllNDS.Caption := FloatToStr(Self.SumAll);
  end;
end;

procedure TKisOrder.PositionsChange(DataSet: TDataSet);
begin
  UpdateSums;
end;

procedure TKisOrder.EditPosition(Sender: TObject);
begin
  if not Positions.IsEmpty then
  begin
    Positions.Edit;
    SelectPosition;
  end;
end;

procedure TKisOrder.PositionsInsert(DataSet: TDataSet);
begin
  SelectPosition;
end;

function TKisOrder.GetContragentId: Integer;
begin
  Result := Contragent.ID;
end;

function TKisOrder.GetText: String;
begin
 Result := 'Заказ №' + Self.OrderNumber + ' от ' + Self.OrderDate;
end;

class function TKisOrder.EntityName: String;
begin
  Result := SEN_ORDER;
end;

function TKisOrder.IsEmpty: Boolean;
begin
  Result := Positions.IsEmpty;
end;

procedure TKisOrder.SetPeopleId(const Value: Integer);
begin
  if FPeopleId <> Value then
  begin
    FPeopleId := Value;
    Modified := True;
  end;
end;

procedure TKisOrder.Load(DataSet: TDataSet);
begin
  inherited;
  with DataSet do
  begin
    Id := FieldByName(SF_ID).AsInteger;;
    OfficeId := FieldByName(SF_OFFICES_ID).AsInteger;
    PeopleId := FieldByName(SF_PEOPLE_ID).AsInteger;
    DocNumber := FieldbyName(SF_DOC_NUMBER).AsString;
    DocDate := FieldByName(SF_DOC_DATE).AsString;
    OrderNumber := FieldByName(SF_ORDER_NUMBER).AsString;
    OrderDate := FieldByName(SF_ORDER_DATE).AsString;
    ContragentId := FieldByName(SF_CONTRAGENTS_ID).AsInteger;
    PayerId := FieldByName(SF_PAYER_ID).AsInteger;
    ContractNumber := FieldByName(SF_CONTRACT_NUMBER).AsString;
    ValPeriod := FieldByName(SF_VAL_PERIOD).AsInteger;
    NDS := FieldByName(SF_NDS).AsFloat;
    SumBase := FieldByName(SF_SUM_BASE).AsFloat;
    PayDate := FieldByName(SF_PAY_DATE).AsString;
    Executor := FieldByName(SF_EXECUTOR).AsString;
    ActDate := FieldByName(SF_ACT_DATE).AsString;
    Customer := FieldByName(SF_CUSTOMER).AsString;
    PayerCustomer := FieldByName(SF_PAYER_CUSTOMER).AsString;
    ObjectAddress := FieldByName(SF_OBJECT_ADDRESS).AsString;
    Ticket := FieldByName(SF_TICKET).AsString;
    Information := FieldByName(SF_INFORMATION).AsString;
    Mark := Boolean(FieldByName(SF_MARK_EXECUTOR).AsInteger);
    Checked := Boolean(FieldByName(SF_CHECKED).AsInteger);
    Cancelled := Boolean(FieldByName(SF_CANCELLED).AsInteger);
    CustomerBase := FieldByName(SF_CUSTOMER_BASE).AsString;
    PrintWorksValue := Boolean(FieldByName(SF_PRINT_WORKS_VALUE).AsInteger);
    OfficeDocId:= FieldByName(SF_OFFICE_DOCS_ID).AsInteger;
    Closed := Boolean(FieldByName(SF_CLOSED).AsInteger);
  end;
end;

procedure TKisOrder.SetLabelAccount;
begin
  if Assigned(EntityEditor) then
  with EntityEditor as TKisOrderEditor do
  begin
    with Self.Contragent as TKisContragent do
    begin
     if TypeAccount = 1 then
       LabelAccount.Caption := 'Р/счет'
     else
       LabelAccount.Caption := 'Л/счет'
    end;
  end;
end;

procedure TKisOrder.SetLetterId(const Value: Integer);
begin
  if FLetterId <> Value then
  begin
    FLetterId := Value;
    Modified := True;
  end;
end;

procedure TKisOrder.SetPayerCustomer(const Value: String);
begin
  if FPayerCustomer <> Value then
  begin
    FPayerCustomer := Value;
    Modified := True;
  end;
end;

procedure TKisOrder.SetPayerId(const Value: Integer);
begin
  if PayerId <> Value then
    Payer := AppModule.Mngrs[kmContragents].GetEntity(Value);
end;

procedure TKisOrder.SetPayer(const Value: TKisEntity);
begin
  if not FPayer.Equals(Value) then
  begin
    FreeAndNil(FPayer);
    FPayer := Value;
    BankAccount := TKisContragent(FPayer).BankAccountEntity;
    Modified := True;
  end;
end;

function TKisOrder.GetPayerId: Integer;
begin
 if Assigned(Payer) then
    Result := Payer.ID
 else
    Result := 0;
end;

procedure TKisOrder.UpdateEditorByPayer;
var
  S: String;
begin
  SetLabelAccount;
  if Assigned(EntityEditor) then
  with EntityEditor as TKisOrderEditor do
    // плательщик
    if Assigned(Self.Payer) then
    begin
      with Self.Payer as TKisContragent do
      begin
        edPayerName.Text := AsText;
        edPayerAddress.Text := Address1.AsText;
        mPayerProperties.Lines.Text := Properties;
        edPayerPhones.Text := Phones;
        edPayerINN.Text := INN;
        mPayerBank.Text := BankName;
        edPayerBankAccount.Text := BankAccount;
        if WithPresentative then
        case ContrType of
          CT_ORG :
            begin
              S := TKisContragentOrganisation(Self.Payer).ChiefPost + ' '
                 + TKisContragentOrganisation(Self.Payer).Chief;
            end;
          CT_PERSON :
            begin
              S := TKisContragentPerson(Self.Payer).ShortName;
            end;
          CT_PRIVATE :
            begin
              S := TKisContragentPrivate(Self.Payer).ShortName;
            end;
        end
        else
          S := Self.PayerCustomer;
        edPayerCustomer.Text := S;
      end;
    end;
end;

procedure TKisOrder.SelectPayer(Sender: TObject);
var
  Ent: TKisEntity;
  ChangePayerCustomer: Boolean;
begin
  with TFilterFactory do
    Ent := AppModule.SQLMngrs[kmContragents].SelectEntity(True,
      CreateList(CreateFilter(SF_TYPE_ID, TKisContragent(Self.Contragent).ContrType, frEqual)),
      True, Self.ContragentId);
  if Assigned(Ent) then
  begin
    ChangePayerCustomer := (Self.Contragent.Id <> Ent.Id);
//    ChangePayerCustomer := not Self.Contragent.Equals(Ent);
    if Assigned(EntityEditor) then
    with EntityEditor as TKisOrderEditor do
    begin
      ChangePayerCustomer := ChangePayerCustomer and (edPayerCustomer.Text <> '');
    end;
    Self.Payer := Ent;
    UpdateEditorByAccount;
  end
  else
    ChangePayerCustomer := False;
  UpdateEditorByPayer(ChangePayerCustomer);
end;

procedure TKisOrder.ClearPayer(Sender: TObject);
begin
  if not Self.Payer.IsEmpty then
  begin
    FPayer.Free;
    BankAccount := nil;
    FPayer := AppModule.Mngrs[kmContragents].CreateEntity(keDefault);
    UpdateEditorByPayer;
    UpdateEditorByAccount;
  end;
end;

procedure TKisOrder.ViewPayer(Sender: TObject);
begin
  if not Self.Payer.IsEmpty then
  with Self.Payer as TKisVisualEntity do
  begin
    ReadOnly := True;
    Edit;
    ReadOnly := False;
  end;
end;

procedure TKisOrder.DBGridDrawColumnCell(Sender: TObject;
  const Rect: TRect; DataCol: Integer; Column: TColumn;
  State: TGridDrawState);
var
  I, X, Y: Integer;
  BitMap: TBitmap;
  GridCanv: TCanvas;
  OldBk, OldFnt, BkClr, FntClr: TColor;
  OldFontStyle2, FontStyle2: TFontStyles;
begin
  if Sender is TDBGrid then
  if Column.FieldName = SF_PRINTED then
  begin
    with IObject(TBitmap.Create) do
    begin
      if Column.Field.AsBoolean then
        I := 19
      else
        I := 18;
      BitMap := TBitmap(AObject);
      SQLMngr.ImageList.GetBitmap(I, BitMap);
      BitMap.TransparentColor := BitMap.Canvas.Pixels[0, 0];
      BitMap.Transparent := True;
      Y := Rect.Top + (Rect.Bottom - Rect.Top - BitMap.Height) div 2;
      X := Rect.Left + (Rect.Right - Rect.Left - BitMap.Width) div 2;
      GridCanv := TDBGrid(Sender).Canvas;
      if gdSelected in State then
      begin
        GridCanv.Brush.Color := clWhite;
      end;
      GridCanv.FillRect(Rect);
      GridCanv.CopyRect(
        Types.Rect(X, Y, X + BitMap.Width, Y + BitMap.Height),
        BitMap.Canvas,
        Types.Rect(0, 0, BitMap.Width, BitMap.Height)
      );
    end;
  end
  else
  if Column.FieldName = SF_WORK_TYPES_NAME then
  begin
    with CurrentPos do
    if (CurrentPos <> nil) and not Printed and (ConnectedTo > 0) then
    begin
      Bitmap := TBitmap(IObject(TBitmap.Create).AObject);
      SQLMngr.ImageList.GetBitmap(20, BitMap);
      BitMap.TransparentColor := BitMap.Canvas.Pixels[0, 0];
      BitMap.Transparent := True;
      Y := Rect.Top;
      X := Rect.Left;
      GridCanv := TDBGrid(Sender).Canvas;
      DBGridColors(nil, Column.Field, BkClr, FntClr, State, FontStyle2);
      OldBk := GridCanv.Brush.Color;
      OldFnt := GridCanv.Font.Color;
      OldFontStyle2 := GridCanv.Font.Style;
      GridCanv.Brush.Color := BkClr;
      GridCanv.Font.Color := FntClr;
      GridCanv.Font.Style := FontStyle2;
      GridCanv.FillRect(Rect);
      GridCanv.Draw(Succ(X), Succ(Y), BitMap);
      GridCanv.CopyMode := cmMergeCopy;
      GridCanv.TextRect(
        Types.Rect(X + BitMap.Width + 3, Y, Rect.Right, Rect.Bottom),
        X + BitMap.Width + 3, Y, Column.Field.Text);
      GridCanv.Brush.Color := OldBk;
      GridCanv.Font.Color := OldFnt;
      GridCanv.Font.Style := OldFontStyle2;
    end;
  end;
end;



procedure TKisOrder.DBGridKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if Key = 32 then
  begin
    if TDBGrid(Sender).SelectedField.FieldName = SF_PRINTED then
    begin
      if not (Positions.State in [dsInsert, dsEdit]) then
        Positions.Edit;
      Positions.FieldByName(SF_PRINTED).AsBoolean := not Positions.FieldByName(SF_PRINTED).AsBoolean;
    end;
  end;
end;

procedure TKisOrder.SetCustomerBase(const Value: String);
begin
  if FCustomerBase <> Value then
  begin
    FCustomerBase := Value;
    Modified := true;
  end;
end;

procedure TKisOrder.SetPrintWorksValue(const Value: Boolean);
begin
  if FPrintWorksValue <> Value then
  begin
    FPrintWorksValue := Value;
    Modified := True;
  end;
end;

procedure TKisOrder.PositionDisconnectChilds(aPosition: TKisOrderPosition);
var
  Id, I: Integer;
begin
  Id := aPosition.ID;
  for I := 1 to FPosController.GetRecordCount do
    if TKisOrderPosition(FPosController.Elements[I]).ConnectedTo = Id then
      TKisOrderPosition(FPosController.Elements[I]).ConnectedTo := -1;
end;

procedure TKisOrder.DBGridColors(Sender: TObject; Field: TField;
  var Background, FontColor: TColor; State: TGridDrawState; var FontStyle: TFontStyles);
var
  aPosition: TKisOrderPosition;
begin
  aPosition := nil;
  if (Positions.RecordCount = 0)
     or
      (
       (Positions.State in [dsInsert, dsEdit])
        and
       (FPosController.TempElement.ID = FPosController.Positions(Positions.RecNo).ID)
      )
  then
    Exit;
  try
    aPosition := TKisOrderPosition(FPosController.Elements[Self.Positions.RecNo]);
  except
  end;
  if Assigned(aPosition) then
    if not aPosition.Printed then
    begin
      Background := $E6E6E6;//$C0C0C0;
      if (aPosition.ConnectedTo < 0) then
      begin
        FontColor := clRed;
        TDBGrid(Sender).Canvas.Font.Style := TDBGrid(Sender).Canvas.Font.Style + [fsBold];
      end
      else
        FontColor := clBlack;
    end;
end;

function TKisOrder.CheckPositions: Boolean;
begin
  Result := False;
  if Positions.IsEmpty then
  begin
    MessageBox(EntityEditor.Handle, PChar(S_NO_WORKS), PChar(S_WARN), MB_OK + MB_ICONINFORMATION);
    Exit;
  end;
  if not PrintedWorksExists(Self.FPosController) then
  begin
    MessageBox(EntityEditor.Handle, PChar(S_NO_WORKS_FOR_PRINTED), PChar(S_WARN), MB_OK + MB_ICONINFORMATION);
    Exit;
  end;
  if not CheckConnectedPositions then
    Exit;

  Result := True;
end;

function TKisOrder.CheckConnectedPositions: Boolean;
var
  I: Integer;
  aPos: TKisOrderPosition;
begin
  Result := False;
//  aPos := nil;
  for I := 1 to Positions.RecordCount do
  begin
    aPos := TKisOrderPosition(FPosController.Elements[I]);
    if Assigned(aPos) then
    begin
      if not aPos.Printed and (aPos.ConnectedTo < 0) then
      begin
        MessageBox(EntityEditor.Handle,
          PChar(S_CHECK_CONNECTTED_POSITIONS),
          PChar(S_WARN),
          MB_OK + MB_ICONWARNING);
        Positions.RecNo := I;
        Exit;
      end;
    end;
  end;
  Result := True;
end;

procedure TKisOrder.SelectMainWork(Sender: TObject);
var
  I, OldId: Integer;
  TmpPt: TPoint;
  aPos: TkisOrderPosition;
begin
  if  (Positions.IsEmpty)
    or (Positions.State in [dsInsert, dsEdit])
    or Positions.FieldByName(SF_PRINTED).AsBoolean
    or (CurrentPos.ConnectedTo > 0)
  then Exit;
  with TKisConnectWorkForm.Create(nil) do
  try
    for I := 1 to Positions.RecordCount do
    begin
      aPos := TKisOrderPosition(FPosController.Elements[I]);
      if aPos.Printed then
        lbWorks.Items.AddObject(aPos.WorkTypeName, aPos);
    end;
    with EntityEditor as TKisOrderEditor do
    begin
      TmpPt := ClientToScreen(Point(dbgPositions.Width + dbgPositions.Left,
        dbgPositions.Top));
    end;
    Top := TmpPt.Y;
    Left := TmpPt.X;
    lbWorks.ItemIndex := 0;
    if ShowModal = mrOK then
    if lbWorks.ItemIndex >=0 then
    begin
      CurrentPos.ConnectedTo :=
        TKisOrderPosition(lbWorks.Items.Objects[lbWorks.ItemIndex]).ID;
      Positions.Refresh;
      OldId := Positions.FieldByName(SF_ID).AsInteger;
      Positions.Close;
      FPosController.Sort;
      Positions.Open;
      Positions.Locate(SF_ID, OldId, []);
    end;
  finally
    Release;
  end;
end;

function TKisOrder.CurrentPos: TkisOrderPosition;
begin
  if Positions.IsEmpty or (Positions.RecordCount = 0) then
    Result := nil
  else
    Result := TKisOrderPosition(FPosController.Elements[Positions.RecNo]);
end;

function TKisOrder.OrderMngr: TKisOrderMngr;
begin
  Result := TKisOrderMngr(Self.Manager);
end;

procedure TKisOrder.CopyPositions(SourceOrder: TKisOrder);
var
  I: Integer;
  aPos: TKisOrderPosition;
begin
  Self.FPosController.DirectClear;
  for I := 1 to SourceOrder.FPosController.GetRecordCount do
  begin
    aPos := Self.OrderMngr.CreateEntity(keOrderPosition) as TKisOrderPosition;
    aPos.Copy(SourceOrder.FPosController.Elements[I]);
    Self.FPosController.DirectAppend(aPos);
  end;
end;

procedure TKisOrder.ExchangeContragentAndPayer(Sender: TObject);
var
  oldCustomer: String;
  oldContragent: TKisEntity;
begin
  oldContragent := FContragent;
  oldCustomer := FCustomer;
  FContragent := FPayer;
  FCustomer := FPayerCustomer;
  FPayer := oldContragent;
  FPayerCustomer := oldCustomer;
  UpdateEditorByPayer(False);
  UpdateEditorByContragent(False);
  BankAccount := nil;
  UpdateEditorByAccount;
  Modified := True;
end;

procedure TKisOrder.Assign(Source: TPersistent);
var
  I: Integer;
  SourceOrder: TKisOrder;
begin
  inherited Assign(Source);
  SourceOrder := TKisOrder(Source);
  for I := 1 to SourceOrder.FPosController.GetRecordCount do
    Self.FPosController.Elements[I].ID := SourceOrder.FPosController.Elements[I].ID;
  for I := 1 to SourceOrder.FMapController.GetRecordCount do
    Self.FMapController.Elements[I].ID := SourceOrder.FMapController.Elements[I].ID;
end;

procedure TKisOrder.SelectAccountHandler(Sender: TObject);
var
  AccountMngr: TKisAccountsMngr;
  Account: TKisContragentAccount;
begin
  if TKisContragent(Self.Payer).AccountCtrlr.ShowEditor(Point(-1, -1), Account) then
  begin
    Self.BankAccount := Account;
    UpdateEditorbyAccount;

    AccountMngr := TKisAccountsMngr(AppModule[kmAccounts]);
    AccountMngr.Connection := SQLMngr.CreateNewConnection(AppModule, AppModule.Pool.Get, True, True);
    AccountMngr.Connection.Transaction.Init();
    AccountMngr.SaveController(TKisContragent(Self.Payer).AccountCtrlr);
    AccountMngr.Connection := nil;
  end;
end;

procedure TKisOrder.SetAccount(const Value: TKisContragentAccount);
begin
  FAccount := Value;
end;

procedure TKisOrder.UpdateEditorByAccount;
begin
  if Assigned(FAccount) and Assigned(EntityEditor) then
  with OrderEditor do
  begin
    mPayerBank.Text := FAccount.BankName;
    edPayerBankAccount.Text := FAccount.Number;
    edAccountType.Text := FAccount.AccountTypeName;
  end
  else
  with OrderEditor do
  begin
    mPayerBank.Clear;
    edPayerBankAccount.Clear;
    edAccountType.Clear;
  end;
end;

function TKisOrder.OrderEditor: TKisOrderEditor;
begin
  Result := TKisOrderEditor(EntityEditor);
end;

function TKisOrder.GetBankId: Integer;
begin
  if Assigned(FAccount) then
    Result := FAccount.BankId
  else
    Result := 0;
end;

function TKisOrder.GetAccountNumber: String;
begin
  if Assigned(FAccount) then
    Result := FAccount.Number
  else
    Result := '';
end;

function TKisOrder.GetAccountType: TKisAccountType;
begin
  if Assigned(FAccount) then
    Result := FAccount.AccountType
  else
    Result := atRS;
end;

procedure TKisOrder.CopyAccount(SourceOrder: TKisOrder);
begin
  if Assigned(FAccount) and Assigned(SourceOrder.FAccount) then
    FAccount.Assign(SourceOrder.FAccount)
  else
    if Assigned(FAccount) then
      FreeAndNil(FAccount)
    else
      if Assigned(SourceOrder.FAccount) then
        FAccount := SourceOrder.FAccount.Clone;
end;

procedure TKisOrder.CopyMaps(SourceOrder: TKisOrder);
var
  I: Integer;
  Map: TKisOrderMap;
begin
  Self.FMapController.DirectClear;
  for I := 1 to SourceOrder.FMapController.GetRecordCount do
  begin
    Map := Self.OrderMngr.CreateEntity(keOrderMap) as TKisOrderMap;
    Map.Copy(SourceOrder.FMapController.Elements[I]);
    Self.FMapController.DirectAppend(Map);
  end;
end;

procedure TKisOrder.SetOfficeDocId(const Value: Integer);
begin
  if FOfficeDocId <> Value then
  begin
    FOfficeDocId := Value;
    Modified := True;
  end;
end;

{ TKisOrderPosition }

procedure TKisOrderPosition.Copy(Source: TKisEntity);
begin
  inherited;
  FConnectedTo := TKisOrderPosition(Source).FConnectedTo;
end;

constructor TKisOrderPosition.Create(Mngr: TKisMngr);
begin
  inherited;
  Quantity := 1;
  ObjectsAmount := 1;
  AUnit := 'заказ';
  Price := 0;
  Printed := True;
  FConnectedTo := -1;
  Modified := False;
end;

procedure TKisOrder.DBGridCellClick(Column: TColumn);
begin
  if Column.FieldName = SF_PRINTED then
  begin
    FPosController.Positions(Positions.RecNo).Printed :=
      not FPosController.Positions(Positions.RecNo).Printed;
  end;
end;

class function TKisOrderPosition.EntityName: String;
begin
  Result := S_POS;
end;

function TKisOrderPosition.GetArgument: String;
begin
  Result := Self[SF_ARGUMENT].AsString;
end;

function TKisOrderPosition.GetAUnit: String;
begin
  Result := Self[SF_UNIT].AsString;
end;

function TKisOrderPosition.GetConnectedTo: Integer;
begin
  Result := FConnectedTo;
end;

function TKisOrderPosition.GetIsSlave: Boolean;
begin
  if not FIsSlaveLoaded then
    LoadIsSlave;
  Result := FIsSlave;
end;

function TKisOrderPosition.GetObjectsAmount: Double;
begin
  Result := Self[SF_OBJECTS_AMOUNT].AsFloat;
end;

function TKisOrderPosition.GetPrice: Double;
begin
  Result := Self[SF_PRICE].AsFloat;
end;

function TKisOrderPosition.GetPrinted: Boolean;
begin
  Result := Self[SF_PRINTED].AsBoolean;
end;

function TKisOrderPosition.GetQuantity: Double;
begin
  Result := Self[SF_QUANTITY].AsFloat;
end;

function TKisOrderPosition.GetText: String;
begin
  Result := WorkTypeName;
end;

function TKisOrderPosition.GetWorkTypeCode: String;
begin
  Result := Self[SF_WORK_TYPE_CODE].AsString;
end;

function TKisOrderPosition.GetWorktypeId: Integer;
begin
  Result := Self[SF_WORK_TYPES_ID].AsInteger;
end;

function TKisOrderPosition.GetWorkTypeName: String;
begin
  Result := Self[SF_WORK_TYPES_NAME].AsString;
end;

procedure TKisOrderPosition.InitParams;
begin
  inherited;
  AddParam(SF_WORK_TYPES_ID);
  AddParam(SF_QUANTITY);
  AddParam(SF_PRICE);
  AddParam(SF_WORK_TYPES_NAME);
  AddParam(SF_OBJECTS_AMOUNT);
  AddParam(SF_ARGUMENT);
  AddParam(SF_UNIT);
  AddParam(SF_WORK_TYPE_CODE);
  AddParam(SF_PRINTED);
end;

procedure TKisOrderPosition.Load(DataSet: TDataSet);
begin
  inherited;
  with DataSet do
  begin
    ID := FieldByName(SF_ID).AsInteger;
    WorktypeId := FieldByName(SF_WORK_TYPES_ID).AsInteger;
    WorkTypeName := FieldByName(SF_WORK_TYPES_NAME).AsString;
    WorkTypeCode := FieldByName(SF_WORK_TYPE_CODE).AsString;
    Price := FieldByName(SF_PRICE).AsFloat;
    Quantity := FieldByName(SF_QUANTITY).AsFloat;
    ObjectsAmount := FieldByname(SF_OBJECTS_AMOUNT).AsFloat;
    Argument := FieldByname(SF_ARGUMENT).AsString;
    AUnit := FieldByName(SF_UNIT).AsString;
    Printed := Boolean(FieldByName(SF_PRINTED).AsInteger);
    ConnectedTo := FieldByName(SF_CONNECTED_TO).AsInteger;
  end;
end;

procedure TKisOrderPosition.LoadIsSlave;
begin
  FIsSlave := TKisOrderMngr(Manager).GetPositionIsSlave(Self);
end;

function TKisOrderPosition.OfficesId: Integer;
begin
  if Assigned(Head) then
    Result := TKisOrder(Head).OfficeId
  else
    Result := -1;
end;

procedure TKisOrderPosition.SetArgument(const Value: String);
begin
  if Argument <> Value then
  begin
     Self[SF_ARGUMENT].Value := Value;
     Modified := True;
  end;
end;

procedure TKisOrderPosition.SetAUnit(const Value: String);
begin
  if AUnit <> Value then
  begin
    Self[SF_UNIT].Value := Value;
    Modified := True;
  end;
end;

procedure TKisOrderPosition.SetConnectedTo(const Value: Integer);
begin
  if FConnectedTo <> Value then
  begin
    FConnectedTo := Value;
    Modified := True; 
  end;
end;

procedure TKisOrderPosition.SetObjectsAmount(const Value: Double);
begin
   if ObjectsAmount <> Value then
   begin
     Self[SF_OBJECTS_AMOUNT].Value := Value;
     Modified := True;
   end;
end;

procedure TKisOrderPosition.SetPrice(const Value: Double);
begin
   if Price <> Value then
   begin
     Self[SF_PRICE].Value := Value;
     Modified := True;
   end;
end;

procedure TKisOrderPosition.SetPrinted(const Value: Boolean);
begin
  if Printed <> Value then
  begin
    Self[SF_PRINTED].Value := Value;
    Modified := True;
    if Assigned(FOnPrintedChange) then
      FOnPrintedChange(Self);
  end;
end;

procedure TKisOrderPosition.SetQuantity(const Value: Double);
begin
  if Quantity <> Value then
  begin
    Self[SF_QUANTITY].Value := Value;
    Modified := True;
  end;
end;

procedure TKisOrderPosition.SetWorkTypeCode(const Value: String);
begin
  if WorkTypeCode <> Value then
  begin
    Self[SF_WORK_TYPE_CODE].Value := Value;
    Modified := True;
  end;
end;

procedure TKisOrderPosition.SetWorkTypeId(const Value: Integer);
begin
  if WorkTypeId <> Value then
  begin
    Self[SF_WORK_TYPES_ID].Value := Value;
    Modified := True;
  end;
end;

procedure TKisOrderPosition.SetWorkTypeName(const Value: String);
begin
  if WorkTypeName <> Value then
  begin
    Self[SF_WORK_TYPES_NAME].Value := Value;
    Modified := True;
  end;
end;

function TKisOrderPosition.Sum: Double;
begin
  Result := Self.Price * Self.Quantity;
end;

{ TPosController }

function TPosController.CreateElement: TKisEntity;
begin
  Result := inherited CreateElement;
  TkisOrderPosition(Result).OnPrintedChange := FHandler;
end;

procedure TPosController.FillFieldDefs(FieldDefsRef: TFieldDefs);
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
    Name := SF_ORDERS_ID;
  end;
  with FieldDefsRef.AddFieldDef do
  begin
    DataType := ftInteger;
    FieldNo := 3;
    Name := SF_WORK_TYPES_ID;
  end;
  with FieldDefsRef.AddFieldDef do
  begin
    DataType := ftString;
    FieldNo := 4;
    Name := SF_WORK_TYPES_NAME;
    Size := 300;
  end;
  with FieldDefsRef.AddFieldDef do
  begin
    DataType := ftFloat;
    FieldNo := 5;
    Name := SF_PRICE;
    Precision := 9;
//    Size := 2;
  end;
  with FieldDefsRef.AddFieldDef do
  begin
    DataType := ftFloat;
    FieldNo := 6;
    Name := SF_QUANTITY;
    Precision := 9;
//    Size := 4;
  end;
  with FieldDefsRef.AddFieldDef do
  begin
    DataType := ftFloat;
    FieldNo := 7;
    Name := SF_SUMMA;
    Precision := 9;
//    Size := 2;
  end;
  with FieldDefsRef.AddFieldDef do
  begin
    DataType := ftString;
    FieldNo := 8;
    Name := SF_ARGUMENT;
    Size := 100;
  end;
  with FieldDefsRef.AddFieldDef do
  begin
    DataType := ftString;
    FieldNo := 9;
    Name := SF_UNIT;
    Size := 10;
  end;
  with FieldDefsRef.AddFieldDef do
  begin
    DataType := ftString;
    FieldNo := 10;
    Name := SF_WORK_TYPE_CODE;
    Size := 10;
  end;
  with FieldDefsRef.AddFieldDef do
  begin
    DataType := ftFloat;
    FieldNo := 11;
    Name := SF_OBJECTS_AMOUNT;
    Precision := 9;
//    Size := 3;
  end;
  with FieldDefsRef.AddFieldDef do
  begin
    DataType := ftBoolean;
    FieldNo := 12;
    Name := SF_PRINTED;
  end;
end;

function TPosController.GetFieldData(Index: Integer; Field: TField;
  out Data): Boolean;
var
{  PI: PLongint;
  PD: PDouble;
  S: String;
  PS: PChar; }
  Ent: TKisOrderPosition;
begin
  Result := True;
  try
    Ent := Elements[Index] as TKisOrderPosition;
    case Field.FieldNo of
      1 : GetInteger(Ent.ID, Data);
      2 : GetInteger(Ent.HeadId, Data);
      3 : GetInteger(Ent.WorktypeId, Data);
      4 : GetString(Ent.WorkTypeName, Data);
      5 : GetDouble(Ent.Price, Data);
      6 : GetDouble(Ent.Quantity, Data);
      7 : GetDouble(Ent.Sum, Data);
      8 : GetString(Ent.Argument, Data);
      9 : GetString(Ent.AUnit, Data);
      10 : GetString(Ent.WorkTypeCode, Data);
      11 : GetDouble(Ent.ObjectsAmount, Data);
      12 : GetBoolean(Ent.Printed, Data);
    end;
  except
    Result := False;
  end;
end;

function TKisOrder.PrintedWorksExists(PosCtrlr: TPosController): Boolean;
var
  I: Integer;
begin
  Result := False;
  I := 1;
  while not Result and (I <= PosCtrlr.GetRecordCount) do
  begin
    Result := TKisOrderPosition(PosCtrlr.Elements[I]).Printed;
    I := I + 1;
  end;
end;

function TPosController.Positions(const I: Integer): TKisOrderPosition;
begin
  if I > GetRecordCount then
    Result := nil
  else
    Result := TKisOrderPosition(Elements[I]);
end;

procedure TPosController.SetFieldData(Index: integer; Field: TField; var Data);
var
{  D: Double;
  I: Integer;}
  Ent: TKisOrderPosition;
begin
  try
    Ent := TKisOrderPosition(Elements[Index]);
    case Field.FieldNo of
    1 : Ent.ID := SetInteger(Data);
    2 : ;// OrderId только для чтения;
    3 : Ent.WorktypeId := SetInteger(Data);
    4 : Ent.WorktypeName := StrPas(@Data);
    5 : Ent.Price := SetDouble(Data);
    6 : Ent.Quantity := SetDouble(Data);
    7 : ;// Sum только для чтения
    8 : Ent.Argument := StrPas(@Data);
    9 : Ent.AUnit := StrPas(@Data);
    10 : Ent.WorkTypeCode := StrPas(@Data);
    11 : Ent.ObjectsAmount := SetDouble(Data);
    12 : Ent.Printed := SetBoolean(Data);
    end;
  except
    Exit;
  end;
end;

procedure TPosController.SetHandler(const Value: TPositionPrintedChange);
var
  I: Integer;
begin
  FHandler := Value;
  for I := 0 to Pred(FList.Count) do
    TKisOrderPosition(FList[I]).OnPrintedChange := FHandler;
end;

procedure TPosController.Sort;
var
  I, J, Added: Integer;
  ResultList: TObjectList;
begin
  ResultList := TObjectList.Create;
  ResultList.Forget();
  ResultList.OwnsObjects := False;
  // Добваляем все видимые
  I := 1;
  while I <= GetRecordCount do
  begin
    if Positions(I).Printed then
    begin
      ResultList.Add(FList[I]);
      FList.Extract(FList[I]);
    end
    else
      Inc(I);
  end;
  // Добавляем к видимым их дочерние работы
  I := 0;
  while I <= Pred(ResultList.Count) do
  begin
    J := 1;
    Added := 0;
    while J <= GetRecordCount do
    begin
      if Positions(J).ConnectedTo = TKisEntity(ResultList[I]).ID then
      begin
        ResultList.Insert(I + Added + 1, FList[J]);
        FList.Extract(FList[J]);
        Inc(Added);
      end
      else
        Inc(J);
    end;
    I := I + Added + 1;
  end;
  // Добавляем все остальные
  I := 1;
  while I <= GetRecordCount do
  begin
    ResultList.Add(FList[I]);
    FList.Extract(FList[I]);
  end;
  for I := 0 to Pred(ResultList.Count) do
  begin
    FList.Add(ResultList[I]);
  end;
end;

{ TKisOrderMngr }

function TKisOrderMngr.CreateEntity(EntityKind: TKisEntities): TKisEntity;
begin
  case EntityKind of
  keDefault, keOrder :
    Result := TKisOrder.Create(Self);
  keOrderPosition :
    begin
      Result := TKisOrderPosition.Create(Self);
    end;
  keOrderMap :
    begin
      Result := TKisOrderMap.Create(Self);
    end;
  else
    Result := nil;
  end;
end;

function TKisOrderMngr.CreateNewEntity(EntityKind: TKisEntities = keDefault): TKisEntity;
var
  T: TIBTransaction;
begin
  Result := TKisOrder.Create(Self);
  with Result as TKisOrder do
  begin
    OrderNumber := AppModule.User.GenerateNewAccountNumber;
    T := AppModule.Pool.Get;
    try
      ID := GenEntityID();
      OfficeID := AppModule.User.OfficeID;
      T.Init(ilReadCommited, amReadOnly);
      T.StartTransaction;
      NDS := GetActualNDS();
    finally
      T.Commit;
      AppModule.Pool.Back(T);
    end;
  end;
end;

function TKisOrderMngr.CurrentEntity: TKisEntity;
begin
  Result := nil;
end;

procedure TKisOrderMngr.DeleteEntity(Entity: TKisEntity);
var
  Conn: IKisConnection;
begin
  if IsSupported(Entity) then
  begin
    Conn := GetConnection(True, True);
    try
      if IsEntityInUse(Entity) then
        inherited
      else
      begin
        // проверка контрагента
{        with Conn.GetDataSet(Format(SQ_CHECK_CONTRAGENT, [TKisContragent(TKisOrder(Entity).Contragent).ParentID])) do
        begin
          Open;
          if not IsEmpty then
          begin
            if Fields[0].AsInteger > TKisOrder(Entity).ContragentId then
            TKisSQLMngr(AppModule[kmContragents]).DeleteEntity(TKisOrder(Entity).Contragent);
          end;
          Close;
        end;   }
        // удаление заказа
        Conn.GetDataSet(Format(SQ_DELETE_ORDER, [Entity.ID])).Open;
      end;
      FreeConnection(Conn, True);
    except
      FreeConnection(Conn, False);
      raise;
    end;
  end;
end;

function TKisOrderMngr.GenEntityID(EntityKind: TKisEntities = keDefault): Integer;
begin
  case EntityKind of
  keOrderPosition :
    Result := AppModule.GetID(SG_ORDER_POSITIONS, Self.DefaultTransaction);
  keOrderMap :
    Result := AppModule.GetID(SG_ORDER_MAPS, Self.DefaultTransaction);
  else
    Result := AppModule.GetID(SG_ORDERS, Self.DefaultTransaction);
  end;
end;

function TKisOrderMngr.GetEntity(EntityID: Integer;
  EntityKind: TKisEntities = keDefault): TKisEntity;
var
  OrderPos: TKisOrderPosition;
  OrderMap: TKisOrderMap;
  Conn: IKisConnection;
  DataSet: TDataSet;
begin
  Conn := GetConnection(True, False);
  try
    DataSet := Conn.GetDataSet(Format(SQ_GET_ORDER, [EntityID]));
    DataSet.Open;
    if not DataSet.IsEmpty then
    begin
      Result := CreateEntity;
      // загрузка свойств
      with Result as TKisOrder do
      begin
        Load(DataSet);
        // Заргузка счета
        LoadOrderAccount(TKisOrder(Result), DataSet);
        DataSet.Close;
      end;
      // загрузка позиций
      DataSet := Conn.GetDataSet(Format(SQ_GET_ORDER_POSITIONS, [EntityID]));
      DataSet.Open;
      DataSet.First;
      while not DataSet.Eof do
      begin
        OrderPos := TKisOrderPosition.Create(Self);
        OrderPos.Load(DataSet);
        // добавляем позицию в заказ
        TKisOrder(Result).AddPosition(OrderPos);
        DataSet.Next;
      end;
      DataSet.Close;
      // загрузка планшетовs
      DataSet := Conn.GetDataSet(Format(SQ_GET_ORDER_MAPS, [EntityID]));
      DataSet.Open;
      DataSet.First;
      while not DataSet.Eof do
      begin
        OrderMap := TKisOrderMap.Create(Self);
        OrderMap.Load(DataSet);
        // добавляем позицию в заказ
        TKisOrder(Result).AddMap(OrderMap);
        DataSet.Next;
      end;
      DataSet.Close;
      // читаем ссылку на входящее письмо
      DataSet := Conn.GetDataSet(Format(SQ_GET_ORDER_LETTER_INFO, [EntityID]));
      DataSet.Open;
      if DataSet.IsEmpty then
      begin
        TKisOrder(Result).LetterId := 0;
        TKisOrder(Result).LetterAutoGenerated := False;
      end
      else
      begin
        TKisOrder(Result).LetterId := DataSet.Fields[0].AsInteger;
        TKisOrder(Result).LetterAutoGenerated := DataSet.Fields[0].AsInteger <> 1;
      end;
      DataSet.Close;
      //
      Result.Modified := False;
    end
    else
      Result := nil;
  finally
    FreeConnection(Conn, True);
  end;
end;

function TKisOrderMngr.IsEntityInUse(Entity: TKisEntity): Boolean;
begin
  IsSupported(Entity);
  Result := False;
end;

function TKisOrderMngr.IsSupported(Entity: TKisEntity): Boolean;
begin
  Result := Assigned(Entity) and (Entity is TKisOrder);
  if not Result then
    Result := inherited IsSupported(Entity);
end;

procedure TKisOrderMngr.SaveEntity(Entity: TKisEntity);
var
  Conn: IKisConnection;
  Order: TKisOrder;
  Map: TKisEntity;
begin
  Conn := GetConnection(True, True);
  if IsSupported(Entity) then
  begin
    try
      if Entity is TKisOrder then
        if Entity.ID < 1 then
          Entity.ID := GenEntityID(keOrder);
      // Сохраняем заказ
      with TKisOrderSaver.Create(Conn) do
      try
        Save(Entity);
      finally
        Free;  
      end;
      //
      Order := TKisOrder(Entity);
      // Сохраняем позиции
      Conn.GetDataSet(Format(SQ_CLEAR_POSITIONS, [Order.ID])).Open;
      Order.Positions.First;
      if not Order.Positions.IsEmpty then
        with TKisOrderPositionSaver.Create(Conn) do
        try
          while not Order.Positions.Eof do
          begin
            if Order.CurrentPos.ID < 1 then
              Order.CurrentPos.ID := GenEntityID(keOrderMap);
            Save(Order.FPosController.Elements[Order.Positions.RecNo]);
            Order.Positions.Next;
          end;
        finally
          Free;
        end;
      //
      // Сохраняем планшеты
      Conn.GetDataSet(Format(SQ_CLEAR_ORDER_MAPS, [Order.ID])).Open;
      Order.Maps.First;
      if not Order.Maps.IsEmpty then
      begin
        with TKisOrderMapSaver.Create(Conn) do
        try
          while not Order.Maps.Eof do
          begin
            Map := Order.FMapController.Elements[Order.Maps.RecNo];
            if Map.ID < 1 then
              Map.ID := GenEntityID(keOrderMap);
            Save(Map);
            Order.Maps.Next;
          end;
        finally
          Free;
        end;
      end;
      //
      FreeConnection(Conn, True);
    except
      FreeConnection(Conn, False);
      raise;
    end;
  end;
end;

function TKisOrderMngr.GetMainSQLText: String;
begin
  Result := '';
end;

function TKisOrderMngr.DuplicateEntity(Entity: TKisEntity): TKisEntity;
begin
  Result := Self.CreateNewEntity;
  Result.Copy(Entity);
end;

function TKisOrderMngr.GetLastCustomerId(CustomerId: Integer; ATransaction: TIBTransaction): Integer;
var
  Conn: IKisConnection;
begin
  Conn := GetConnection(True, False);
  try
    with Conn.GetDataSet(Format(SQ_GEL_LAST_CUSTOMER_ID, [CustomerId])) do
    begin
      Open;
      Result := Fields[0].AsInteger;
      Close;
    end;
  finally
    FreeConnection(Conn, True);
  end;
end;

function TKisOrderMngr.GetActualNDS(): Double;
var
  Conn: IKisConnection;
begin
  Conn := GetConnection(True, False);
  try
    with Conn.GetDataSet(SQ_SELECT_NDS) do
    begin
      Open;
      Result := Fields[0].AsFloat;
      Close;
    end;
  finally
    FreeConnection(Conn, True);
  end;
end;

function TKisOrderMngr.GetMainDataSet: TDataSet;
begin
  Result := nil;
end;

function TKisOrderMngr.GetPositionIsSlave(aPosition: TKisOrderPosition): Boolean;
var
  Conn: IKisConnection;
begin
  Result := False;
  Conn := GetConnection(True, False);
  try
    with Conn.GetDataSet(Format(SQ_GET_POSITION_IS_SLAVE, [aPosition.OfficesId, aPosition.WorkTypeId])) do
    begin
      Open;
      if not IsEmpty then
        Result := Fields[0].AsInteger = 1;
      Close;
    end;
  finally
    FreeConnection(Conn, True);
  end;
end;

procedure TKisOrder.OnPositionPrintedChange(aPosition: TKisOrderPosition);
var
  OldId: Integer;
begin
  // Сделали видимой
  if aPosition.Printed then
    aPosition.ConnectedTo := -1
  else
    PositionDisconnectChilds(aPosition);
  OldId := Positions.FieldByName(SF_ID).AsInteger;
  FPosController.Sort;
  Positions.First;
  Positions.Locate(SF_ID, OldId, []);
end;

function TKisOrderMngr.GetCheckBoxImageIndex(Checked: Boolean): Integer;
begin
  if Checked then
    Result := 19
  else
    result := 18;
end;

procedure TKisOrderMngr.LoadOrderAccount(aOrder: TKisOrder; DataSet: TDataSet);
var
  AccountMngr: TKisAccountsMngr;
begin
  if Assigned(aOrder) and Assigned(DataSet) then
  begin
    AccountMngr := TKisAccountsMngr(AppModule[kmAccounts]);
    AccountMngr.Connection := GetConnection(True, False);
    try
      aOrder.FAccount := TKisContragentAccount(AccountMngr.CreateEntity);
      aOrder.FAccount.BankId := DataSet.FieldByName(SF_PAYER_BANK_ID).AsInteger;
      aOrder.FAccount.Number := DataSet.FieldByName(SF_PAYER_ACCOUNT).AsString;
      aOrder.FAccount.AccountType := TKisAccountType(DataSet.FieldByName(SF_PAYER_ACCOUNT_TYPE).AsInteger);
    finally
      FreeConnection(AccountMngr.Connection, True);
      AccountMngr.Connection := nil;
    end;
  end;
end;

{ TKisOrderSaver }

function TKisOrderSaver.GetSQL: String;
begin
  Result := SQ_SAVE_ORDER;
end;

procedure TKisOrderSaver.PrepareParams(DataSet: TDataSet);
begin
  with TKisOrder(FEntity) do
  begin
    FConnection.SetParam(DataSet, SF_ID, ID);
    FConnection.SetParam(DataSet, SF_OFFICES_ID, OfficeID);
    FConnection.SetParam(DataSet, SF_PEOPLE_ID, PeopleID);
    FConnection.SetParam(DataSet, SF_DOC_NUMBER, DocNumber);
    FConnection.SetParam(DataSet, SF_DOC_DATE, Trim(DocDate));
    FConnection.SetParam(DataSet, SF_ORDER_NUMBER, OrderNumber);
    FConnection.SetParam(DataSet, SF_ORDER_DATE, StrDateToParamValue(Trim(OrderDate)));
    FConnection.SetParam(DataSet,SF_CONTRAGENTS_ID , ContragentID);
    FConnection.SetParam(DataSet, SF_NDS, NDS);
    FConnection.SetParam(DataSet, SF_SUMMA, Sum);
    FConnection.SetParam(DataSet, SF_SUM_NDS, SumNDS);
    FConnection.SetParam(DataSet, SF_CHECKED, Integer(Checked));
    FConnection.SetParam(DataSet, SF_MARK_EXECUTOR, Integer(Mark));
    FConnection.SetParam(DataSet, SF_CANCELLED, Integer(Cancelled));
    FConnection.SetParam(DataSet, SF_PAY_DATE, StrDateToParamValue(Trim(PayDate)));
    FConnection.SetParam(DataSet, SF_EXECUTOR, Executor);
    FConnection.SetParam(DataSet, SF_ACT_DATE, StrDateToParamValue(Trim(ActDate)));
    FConnection.SetParam(DataSet, SF_CONTRACT_NUMBER, ContractNumber);
    FConnection.SetParam(DataSet, SF_OBJECT_ADDRESS, ObjectAddress);
    FConnection.SetParam(DataSet, SF_CUSTOMER, Customer);
    FConnection.SetParam(DataSet, SF_VAL_PERIOD, ValPeriod);
    FConnection.SetParam(DataSet, SF_TICKET, Ticket);
    FConnection.SetParam(DataSet, SF_INFORMATION, Information);
    FConnection.SetParam(DataSet, SF_SUM_BASE, SumBase);
    FConnection.SetParam(DataSet, SF_PAYER_ID, PayerID);
    FConnection.SetParam(DataSet, SF_PAYER_CUSTOMER, PayerCustomer);
    FConnection.SetParam(DataSet, SF_CUSTOMER_BASE, CustomerBase);
    FConnection.SetParam(DataSet, SF_PRINT_WORKS_VALUE,Integer(PrintWorksValue));
    FConnection.SetParam(DataSet, SF_PAYER_ACCOUNT, AccountNumber);
    FConnection.SetParam(DataSet, SF_PAYER_BANK_ID, BankId);
    FConnection.SetParam(DataSet, SF_PAYER_ACCOUNT_TYPE, Integer(AccountType));
    FConnection.SetParam(DataSet, SF_CLOSED, Integer(Closed));
    if OfficeDocId > 0 then
      FConnection.SetParam(DataSet, SF_OFFICE_DOCS_ID, OfficeDocId);
    if LetterId > 0 then
      FConnection.SetParam(DataSet, SF_LETTERS_ID, LetterId);
  end;
end;

{ TKisOrderPositionSaver }

function TKisOrderPositionSaver.getSQL: String;
begin
  Result := SQ_SAVE_ORDER_POSITION;
end;

procedure TKisOrderPositionSaver.PrepareParams(DataSet: TDataSet);
begin
  inherited;
  with FEntity as TKisOrderPosition do
  begin
    FConnection.SetParam(DataSet, SF_ID, ID);
    FConnection.SetParam(DataSet, SF_ORDERS_ID, HeadId);
    FConnection.SetParam(DataSet, SF_WORK_TYPES_NAME, WorkTypeName);
    FConnection.SetParam(DataSet, SF_WORK_TYPES_ID, WorkTypeId);
    FConnection.SetParam(DataSet, SF_PRICE, Price);
    FConnection.SetParam(DataSet, SF_QUANTITY, Quantity);
    FConnection.SetParam(DataSet, SF_SUMMA, Sum);
    FConnection.SetParam(DataSet, SF_ARGUMENT, Argument);
    FConnection.SetParam(DataSet, SF_WORK_TYPE_CODE, WorkTypeCode);
    FConnection.SetParam(DataSet, SF_UNIT, AUnit);
    FConnection.SetParam(DataSet, SF_OBJECTS_AMOUNT, ObjectsAmount);
    FConnection.SetParam(DataSet, SF_PRINTED, Integer(Printed));
    FConnection.SetParam(DataSet, SF_CONNECTED_TO, ConnectedTo);
  end;
end;

{ TMapController }

function TMapController.CreateElement: TKisEntity;
begin
  Result := inherited CreateElement;
//  TKisOrderMap(Result).OnPrintedChange := FHandler;
end;

procedure TMapController.FillFieldDefs(FieldDefsRef: TFieldDefs);
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
    Name := SF_ORDERS_ID;
  end;
  with FieldDefsRef.AddFieldDef do
  begin
    DataType := ftString;
    FieldNo := 3;
    Name := SF_NOMENCLATURE;
    Size := 20;
  end;
end;

function TMapController.GetFieldData(Index: Integer; Field: TField; out Data): Boolean;
var
  Map: TKisOrderMap;
begin
  Result := True;
  try
    Map := Elements[Index] as TKisOrderMap;
    case Field.FieldNo of
      1 : GetInteger(Map.ID, Data);
      2 : GetInteger(Map.HeadId, Data);
      3 : GetString(Map.Nomenclature, Data);
    end;
  except
    Result := False;
  end;
end;

procedure TMapController.SetFieldData(Index: integer; Field: TField; var Data);
var
  Map: TKisOrderMap;
begin
  try
    Map := TKisOrderMap(Elements[Index]);
    case Field.FieldNo of
    1 : Map.ID := SetInteger(Data);
    2 : ;// OrderId только для чтения;
    3 : Map.Nomenclature := StrPas(@Data);
    end;
  except
    Exit;
  end;
end;

{ TKisOrderMap }

procedure TKisOrderMap.Copy(Source: TKisEntity);
begin
  inherited;
  FNomenclature := TKisOrderMap(Source).Nomenclature;
end;

constructor TKisOrderMap.Create(Mngr: TKisMngr);
begin
  inherited;
  FNomenclature := '';
end;

class function TKisOrderMap.EntityName: String;
begin
  Result := S_ORDER_MAP;
end;

function TKisOrderMap.GetText: String;
begin
  Result := FNomenclature;
end;

procedure TKisOrderMap.InitParams;
begin
  inherited;
  AddParam(SF_NOMENCLATURE);
end;

procedure TKisOrderMap.Load(DataSet: TDataSet);
begin
  inherited;
  with DataSet do
  begin
    ID := FieldByName(SF_ID).AsInteger;
    Nomenclature := FieldByName(SF_NOMENCLATURE).AsString;
  end;
end;

procedure TKisOrderMap.SetNomenclature(const Value: string);
begin
  if FNomenclature <> Value then
  begin
    FNomenclature := Value;
    Modified := True;
  end;
end;

{ TKisOrderMapSaver }

function TKisOrderMapSaver.GetSQL: String;
begin
  Result := SQ_SAVE_ORDER_MAP;
end;

procedure TKisOrderMapSaver.PrepareParams(DataSet: TDataSet);
var
  Map: TKisOrderMap;
begin
  inherited;
  Map := TKisOrderMap(FEntity);
  FConnection.SetParam(DataSet, SF_ID, Map.ID);
  FConnection.SetParam(DataSet, SF_ORDERS_ID, Map.HeadId);
  FConnection.SetParam(DataSet, SF_NOMENCLATURE, Map.Nomenclature);
end;

end.
