{*******************************************************}
{                                                       }
{       "ИС МП УГА"                                     }
{       Менеджер регистрации и учета движения проектов  }
{       постановлений                                   }
{                                                       }
{       Copyright (c) 2005, МП УГА                      }
{                                                       }
{       Автор: Сирота Е.А.                              }
{                                                       }
{*******************************************************}

{ Описание: реализует операции над проектами постановлений
  Имя модуля: Decree Projects
  Версия: 1.04
  Дата последнего изменения: 07.09.2005
  Цель: модуль содержит реализации классов менеджера проектов постановлений
  Используется: AppModule
  Использует: Kernel Classes
  Исключения: нет }

{
  1.04        07.09.2005
     - добавлены новые поля для поиска и сортировки

  1.03        28.04.2005
     - реализована фильтрация по отделам
     - добавлен отчет "Список с экрана"
     - использован новый модуль печати

  1.02        22.04.2005
     - удален методы менеджера Locate, CloseView и RemoveCurrentTypeFilter, т.к. они были пустой
     - использованы новые методы работы с главным датасетом

  1.01        13.04.2005
     - добавлен поиск по адресам постановлений
}


unit uKisDecreeProjects;

interface

{$I KisFlags.pas}

uses
   // System
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs,  DB, ImgList, ActnList, IBCustomDataSet, DBClient, DBGrids,
  IBSQL, IBDatabase, IBQuery,
  // Common
   uGC, uIBXUtils, uDataSet, uSQLParsers,
  // Project
  uKisClasses, uKisSQLClasses, uKisEntityEditor, uKisUtils, uKisFilters;

type


 //адрес объекта
 TKisDecreeAddress = class(TKisEntity)
  private
    FDecreeAddress: String;
    procedure SetDecreeAddress(const Value: String);
  protected
  public
    class function EntityName: String; override;
    procedure Copy(Source: TKisEntity); override;
    procedure Load(DataSet: TDataSet); override;
    property DecreeAddress: String read FDecreeAddress write SetDecreeAddress;
  end;

  TDecreeAddressesCtrlr = class(TKisEntityController)
  public
    procedure FillFieldDefs(FieldDefsRef: TFieldDefs); override;
    function GetFieldData(Index: Integer; Field: TField; out Data): Boolean; override;
    procedure SetFieldData(Index: Integer; Field: TField; var Data); override;
  end;



  //виза
  TKisDecreeVisa = class(TKisEntity)
  private
    FProjectStateId: Integer;
    FProjectState: String;
    FInDate: String;
    procedure SetProjectStateId(const Value: Integer);
    procedure SetProjectState(const Value: String);
    procedure SetInDate(const Value: String);
  protected
  public
    class function EntityName: String; override;
    procedure Copy(Source: TKisEntity); override;
    procedure Load(DataSet: TDataSet); override;
    property ProjectStateId: Integer read FProjectStateId write SetProjectStateId;
    property ProjectState: String read FProjectState write SetProjectState;
    property InDate: String read FInDate write SetInDate;
  end;

  TDecreeVisasCtrlr = class(TKisEntityController)
  public
    procedure FillFieldDefs(FieldDefsRef: TFieldDefs); override;
    function GetFieldData(Index: Integer; Field: TField; out Data): Boolean; override;
    procedure SetFieldData(Index: Integer; Field: TField; var Data); override;
  end;

  //проекты постановлений
  TKisDecreeProject = class(TKisSQLEntity)
  private
    FDecreeAddressesCtrlr: TDecreeAddressesCtrlr;
    FDecreeAddresses: TCustomDataSet;
    FDecreeVisasCtrlr: TDecreeVisasCtrlr;
    FDecreeVisas: TCustomDataSet;
    FLetterAddresses: TCustomDataSet;
    FHeader: String;
    FExecutorId: Integer;
    FOfficesId: Integer;
    FDateVisa: TDate;
    FLettersId: Integer;
    FNumberMP: String;
    FDateMP: String;
    FLastVisaId: Integer;
    FSeqNumber: String;
    FDecree: TKisEntity;
    FDescription: String;
    procedure SetHeader(const Value: String);
    procedure SetExecutorId(const Value: Integer);
    procedure SetOfficesId(const Value: Integer);
    procedure SetDateVisa(const Value: TDate);
    procedure SetLettersId(const Value: Integer);
    procedure SetNumberMP(const Value: String);
    procedure SetDateMP(const Value: String);
    procedure SetLastVisaId(const Value: Integer);
    procedure SetSeqNumber(const Value: String);

    procedure SelectLetter(Sender: TObject);
    procedure UpdateLetter;
    procedure LoadLetterAddresses(EntityId: Integer);

    procedure SelectDecree(Sender: TObject);
    procedure UpdateEditorByDecree;

    procedure LoadPeopleList(Sender: TObject);

    // Access methods for datasets
    function GetDecreeAddresses: TDataSet;
    function GetDecreeVisas: TDataSet;
    function GetLetterAddresses: TDataSet;

    // Event handlers for editor
    // DecreeAddress
    procedure DecreeAddressInsert(DataSet: TDataSet);
    procedure DecreeAddressEdit(DataSet: TDataSet);
    //

    // DecreeVisas
    procedure DecreeVisaAfterInsert(DataSet: TDataSet);
    procedure DecreeVisaBeforePost(DataSet: TDataSet);
    procedure DecreeVisaBeforeDelete(DataSet: TDataSet);
    //

    function DataSetEquals(DS1, DS2: TCustomDataSet): Boolean;
    function GetCurrentStateId: Integer;
    procedure LoadDecree(DecreeId: Integer);
    procedure SetDescription(const Value: String);
  protected
    function CreateEditor: TKisEntityEditor; override;
    procedure PrepareEditor(Editor: TKisEntityEditor); override;
    procedure UnprepareEditor(Editor: TKisEntityEditor); override;
    procedure LoadDataIntoEditor(Editor: TKisEntityEditor); override;
    procedure ReadDataFromEditor(Editor: TKisEntityEditor); override;
    function CheckEditor(Editor: TKisEntityEditor): Boolean; override;
  public
    constructor Create(Mngr: TKisMngr); override;
    destructor Destroy; override;
    function IsEmpty: Boolean; override;
    class function EntityName: String; override;
    procedure Copy(Source: TKisEntity); override;
    procedure Load(DataSet: TDataSet); override;
    function Equals(Entity: TKisEntity): Boolean; override;
    property Header: String read FHeader write SetHeader;
    property ExecutorId: Integer read FExecutorId write SetExecutorId;
    property OfficesId: Integer read FOfficesId write SetOfficesId;
    property DateVisa: TDate read FDateVisa write SetDateVisa;
    property LettersId: Integer read FLettersId write SetLettersId;
    property NumberMP: String read FNumberMP write SetNumberMP;
    property DateMP: String read FDateMP write SetDateMP;
    property LastVisaId: Integer read FLastVisaId write SetLastVisaId;
    property SeqNumber: String read FSeqNumber write SetSeqNumber;
    property CurrentStateId: Integer read GetCurrentStateId;
    property DecreeAddresses: TDataSet read GetDecreeAddresses;
    property DecreeVisas: TDataSet read GetDecreeVisas;
    property LetterAddresses: TDataSet read GetLetterAddresses;
    property Description: String read FDescription write SetDescription;
  end;

  TKisTemporaryDecreeProject = class(TKisEntity)
  private
    FHeader: String;
    FExecutorId: Integer;
    FOfficesId: Integer;
    FLettersId: Integer;
    FAddress: String;
    procedure SetHeader(const Value: String);
    procedure SetExecutorId(const Value: Integer);
    procedure SetOfficesId(const Value: Integer);
    procedure SetLettersId(const Value: Integer);
    procedure SetAddress(const Value: String);
  public
    procedure Load(DataSet: TDataSet); override;
    property Header: String read FHeader write SetHeader;
    property Address: String read FAddress write SetAddress;
    property ExecutorId: Integer read FExecutorId write SetExecutorId;
    property OfficesId: Integer read FOfficesId write SetOfficesId;
    property LettersId: Integer read FLettersId write SetLettersId;
  end;

  TKisDecreeProjectMngr = class(TKisSQLMngr)
    dsDecreeProjects: TIBDataSet;
    dsDecreeProjectsID: TIntegerField;
    dsDecreeProjectsOFFICES_ID: TIntegerField;
    dsDecreeProjectsLETTERS_ID: TIntegerField;
    dsDecreeProjectsEXECUTOR_ID: TIntegerField;
    dsDecreeProjectsHEADER: TBlobField;
    dsDecreeProjectsOFFICE_NAME: TStringField;
    dsDecreeProjectsPEOPLE_NAME: TStringField;
    dsDecreeProjectsMP_NUMBER: TStringField;
    dsDecreeProjectsMP_DATE: TDateField;
    dsDecreeProjectsPRJ_STATE: TStringField;
    dsDecreeProjectsIN_DATE: TDateField;
    dsDecreeProjectsSEQ_NUMBER: TStringField;
    dsDecreeProjectsADDRESS: TStringField;
    acPrint: TAction;
    dsTemp: TIBDataSet;
    DataSource1: TDataSource;
    acAcceptProject: TAction;
    dsDecreeProjectsDESCRIPTION: TBlobField;
    procedure acEditExecute(Sender: TObject); override;
    procedure acEditUpdate(Sender: TObject);
    procedure acInsertExecute(Sender: TObject);
    procedure acPrintExecute(Sender: TObject);
    procedure acAcceptProjectExecute(Sender: TObject);
    procedure acAcceptProjectUpdate(Sender: TObject);
    procedure dsTempBeforeClose(DataSet: TDataSet);
    procedure dsTempAfterOpen(DataSet: TDataSet);
  private
    procedure SaveDecreeProjects(DecreeProject: TKisEntity);
    procedure SaveTmpDecreeProject(DecreeProject: TKisEntity);
    procedure SaveDecreeAddresses(DecreeAddr: TKisEntity);
    procedure SaveDecreeVisas(DecreeVisa: TKisEntity);
    procedure ReopenTemp;
  protected
    procedure CreateView; override;
    procedure CloseView(Sender: TObject; var Action: TCloseAction); override;
    function GenEntityID(EntityKind: TKisEntities = keDefault): Integer; override;
    procedure Activate; override;
    procedure Deactivate; override;
    function IsSupported(Entity: TKisEntity): Boolean; override;
    function GetIdent: TKisMngrs; override;
    function GetMainSQLText: String; override;
    procedure PrepareSQLHelper; override;
    function GetMainDataSet: TDataSet; override;
    function GetRefreshSQLText: String; override;
    procedure Reopen; override;
    function ProcessSQLFilter(aFilter: IKisFilter;
      TheOperation: TKisFilterOperation; Clause: TWhereClause): Boolean; override;
  public
    function GetEntity(EntityID: Integer; EntityKind: TKisEntities = keDefault): TKisEntity; override;
    function CreateNewEntity(EntityKind: TKisEntities = keDefault): TKisEntity; override;
    procedure SaveEntity(Entity: TKisEntity); override;
    procedure DeleteEntity(Entity: TKisEntity); override;
    function IsEntityInUse(Entity: TKisEntity): Boolean; override;
    function CreateEntity(EntityKind: TKisEntities): TKisEntity; override;
    function CurrentEntity: TKisEntity; override;
    function EditEntity(Entity: TKisEntity): TKisEntity; override;
  end;

implementation

{$R *.dfm}

uses
   // Fastreport
   FR_Class,
   // Common
  // Project
  uKisAppModule, uKisConsts, uKisDecreeProjectEditor, SelectAddress, uKisLetters,
  uKisPrintModule, uKisIntf, uKisDecrees, Decrees, uKisDecreeProjectsView,
  uKisSearchClasses, uKisExceptions;

resourcestring
  // Generators
  SG_DECREE_PROJECT = 'DECREE_PRJS';
  SG_DECREE_ADDRESS = 'DECREE_PRJ_ADDRESSES';
  SG_DECREE_VISA = 'DECREE_PRJ_VISAS';
  // Queries
  // При изменении SQ_MAIN надо менять отчеты !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
  SQ_MAIN = 'SELECT DP.ID, DP.HEADER, DP.OFFICES_ID, DP.LETTERS_ID, '
            + 'DP.EXECUTOR_ID, DP.LAST_VISA_ID, DP.SEQ_NUMBER, DP.ADDRESS, DP.DESCRIPTION, '
            + 'O.NAME AS OFFICE_NAME, '
            + 'P.INITIAL_NAME AS PEOPLE_NAME, '
            + 'L.MP_NUMBER AS MP_NUMBER, L.MP_DATE AS MP_DATE, '
            + 'DPV.PRJ_STATE AS PRJ_STATE, DPV.IN_DATE AS IN_DATE '
            + 'FROM DECREE_PRJS DP '
            + 'LEFT JOIN OFFICES O ON DP.OFFICES_ID=O.ID '
            + 'LEFT JOIN PEOPLE P ON DP.EXECUTOR_ID=P.ID '
            + 'LEFT JOIN DECREE_PRJ_VISAS DPV ON DP.LAST_VISA_ID=DPV.ID '
            + 'LEFT JOIN LETTERS L ON DP.LETTERS_ID=L.ID';
  SQ_SELECT_DECREE_PROJECT = 'SELECT DP.ID, DP.HEADER, DP.OFFICES_ID, DP.LETTERS_ID, DP.EXECUTOR_ID, DP.SEQ_NUMBER, '
                             + 'L.MP_NUMBER AS MP_NUMBER, L.MP_DATE AS MP_DATE, DP.DECREES_ID, DP.DESCRIPTION '
                             + 'FROM DECREE_PRJS DP '
                             + 'LEFT JOIN LETTERS L ON DP.LETTERS_ID=L.ID '
                             + 'WHERE DP.ID=%d';
  SQ_SELECT_TMP_DECREE_PROJECT = 'SELECT * FROM DECREE_PRJS_QUEUED WHERE ID=%d';
  //SQ_SELECT_DECREE_PROJECT = 'SELECT * FROM DECREE_PRJS WHERE ID=%d';
  SQ_DELETE_DECREE_PROJECT = 'DELETE FROM DECREE_PRJS WHERE ID=%d';
  SQ_DELETE_TMP_DECREE_PROJECT = 'DELETE FROM DECREE_PRJS_QUEUED WHERE ID=%d';
  SQ_SELECT_DECREE_ADDRESSES = 'SELECT * FROM DECREE_PRJ_ADDRESSES WHERE ID=%d';
  SQ_SELECT_DECREE_VISAS = 'SELECT * FROM DECREE_PRJ_VISAS WHERE ID=%d';
  SQ_SELECT_DECREE_STATES = 'SELECT NAME, ID FROM DECREE_PRJ_STATES WHERE ID > %d';
  SQ_GET_DECREE_ADDRESSES_ID = 'SELECT ID FROM DECREE_PRJ_ADDRESSES WHERE DECREE_PRJS_ID=%d ORDER BY ID';
  SQ_GET_DECREE_VISAS_ID = 'SELECT ID FROM DECREE_PRJ_VISAS WHERE DECREE_PRJS_ID=%d ORDER BY ID';
  SQ_SAVE_DECREE_PROJECT = 'EXECUTE PROCEDURE SAVE_DECREE_PRJS(:ID, :HEADER, :OFFICES_ID, :LETTERS_ID, :EXECUTOR_ID, :SEQ_NUMBER, :DECREES_ID, :DESCRIPTION)';
  SQ_SAVE_TMP_DECREE_PROJECT = 'EXECUTE PROCEDURE SAVE_TMP_DECREE_PRJS(:ID, :OFFICES_ID, :LETTERS_ID, :EXECUTOR_ID, :HEADER, :ADDRESS)';
  SQ_SAVE_DECREE_ADDRESSES = 'EXECUTE PROCEDURE SAVE_DECREE_PRJ_ADDRESSES(:ID, :DECREE_PRJS_ID, :ADDRESS)';
  SQ_SAVE_DECREE_VISAS = 'EXECUTE PROCEDURE SAVE_DECREE_PRJ_VISAS(:ID, :DECREE_PRJS_ID, :PRJ_STATE_ID, :PRJ_STATE, :IN_DATE)';
//  SQ_CLEAR_DECREE_ADDRESSES = 'DELETE FROM DECREE_PRJ_ADDRESSES WHERE DECREE_PRJS_ID=%d';
//  SQ_CLEAR_DECREE_VISAS = 'DELETE FROM DECREE_PRJ_VISAS WHERE DECREE_PRJS_ID=%d';
  SQ_LOAD_DECREE = 'SELECT A.ID, A.DOC_NUMBER, A.DOC_DATE, A.INT_NUMBER, A.INT_DATE, A.HEADER, '
    + 'A.CONTENT, B.NAME AS DECREE_TYPES_NAME '
    + 'FROM DECREES A LEFT JOIN DECREE_TYPES B ON A.DECREE_TYPES_ID=B.ID '
    + 'WHERE A.ID=%d';


{ TkisDecreeProjects }

function TkisDecreeProject.CheckEditor(Editor: TKisEntityEditor): Boolean;

  procedure SetFocusTo(Control: TWinControl);
  begin
      with Editor as TKisDecreeProjectEditor do
      begin
        PageControl1.ActivePageIndex := 0;
        Control.SetFocus;
      end;
  end;

var
  D: TDateTime;
begin
  Result := False;
  if Editor is TKisDecreeProjectEditor then
    with Editor as TKisDecreeProjectEditor do
    begin
      if (Length(Trim(edHeader.Text)) = 0) then
      begin
        AppModule.Alert(S_CHECK_HEADER);
        SetFocusTo(edHeader);
        Exit;
      end;
      if cbOffice.ItemIndex < 0 then
      begin
        AppModule.Alert(S_CHECK_LETTER_OFFICE_NAME);
        SetFocusTo(cbOffice);
        Exit;
      end;
      if cbExecutor.ItemIndex < 0 then
      begin
        AppModule.Alert(S_CHECK_EXECUTOR);
        SetFocusTo(cbExecutor);
        Exit;
      end;
      if Trim(edNumberMP.Text) = '' then
        begin
          MessageBox(Handle, PChar(S_CHECK_MP_LETTER_NUMBER), PChar(S_WARN), MB_OK + MB_ICONWARNING);
          SetFocusTo(edNumberMP);
          Exit;
        end;
      if (edDateMP.Text = '') or not TryStrToDate(edDateMP.Text, D) or
        ((D > Date) or (D < MIN_DOC_DATE)) then
      begin
        MessageBox(Handle, PChar(S_CHECK_MP_LETTER_DATE), PChar(S_WARN), MB_OK + MB_ICONWARNING);
        SetFocusTo(edDateMP);
        Exit;
      end;
  end;
  Result := True;
end;

procedure TkisDecreeProject.Copy(Source: TKisEntity);
var
  I: Integer;
begin
  inherited;
  with Source as TkisDecreeProject do
  begin
      Self.FHeader := FHeader;
      Self.FExecutorId := FExecutorId;
      Self.FOfficesId := FOfficesId;
      Self.FDateVisa := FDateVisa;
      Self.FLettersId := FLettersId;
      Self.FNumberMP := FNumberMP;
      Self.FDateMP := FDateMP;
      Self.FLastVisaId := FLastVisaId;
      Self.FSeqNumber := FSeqNumber;
      Self.FDescription := FDescription;

      //копируем адреса-объектов
      Self.FDecreeAddressesCtrlr.DirectClear;
      DecreeAddresses.First;
      while not DecreeAddresses.Eof do
      begin
        Self.DecreeAddresses.Append;
        for I := 0 to Pred(Self.DecreeAddresses.FieldCount) do
          Self.DecreeAddresses.Fields[I].Value := DecreeAddresses.Fields[I].Value;
        Self.DecreeAddresses.Post;
        DecreeAddresses.Next;
      end;

      //копируем визы
      Self.FDecreeVisasCtrlr.DirectClear;
      DecreeVisas.First;
      while not DecreeVisas.Eof do
      begin
        Self.DecreeVisas.Append;
        for I := 0 to Pred(Self.DecreeVisas.FieldCount) do
          Self.DecreeVisas.Fields[I].Value := DecreeVisas.Fields[I].Value;
        Self.DecreeVisas.Post;
        DecreeVisas.Next;
      end;

      Self.FDecree := FDecree;
  end;
end;

constructor TkisDecreeProject.Create(Mngr: TKisMngr);
begin
  inherited;
  FDecreeAddressesCtrlr := TDecreeAddressesCtrlr.CreateController(Mngr, Mngr, keDecreeAddress);
  FDecreeAddressesCtrlr.HeadEntity := Self;
  FDecreeAddresses := TCustomDataSet.Create(Mngr);
  FDecreeAddresses.Controller := FDecreeAddressesCtrlr;
  FDecreeAddresses.Open;
  FDecreeAddresses.First;

  FDecreeVisasCtrlr := TDecreeVisasCtrlr.CreateController(Mngr, Mngr, keDecreeVisa);
  FDecreeVisasCtrlr.HeadEntity := Self;
  FDecreeVisas := TCustomDataSet.Create(Mngr);
  FDecreeVisas.Controller := FDecreeVisasCtrlr;
  FDecreeVisas.Open;
  FDecreeVisas.First;
end;

function TkisDecreeProject.CreateEditor: TKisEntityEditor;
begin
  Result := TKisDecreeProjectEditor.Create(Application);
end;

function TkisDecreeProject.DataSetEquals(DS1,
  DS2: TCustomDataSet): Boolean;
var
  I: Integer;
begin
  Result := DS1.RecordCount = DS2.RecordCount;
  if Result then
  begin
    for I := 1 to DS1.RecordCount do
    begin
      Result := TKisEntityController(DS1.Controller).Elements[I].Equals(TKisEntityController(DS2.Controller).Elements[I]);
      if not Result then
        Exit;
    end;
  end;
end;

procedure TkisDecreeProject.DecreeAddressEdit(DataSet: TDataSet);
var
  S: String;
begin
  S := DecreeAddresses.FieldByName(SF_ADDRESS).AsString;
  if DoSelectAddress(True, S) then
  begin
    DecreeAddresses.FieldByName(SF_ADDRESS).AsString := S;
    DecreeAddresses.Post;
  end
  else
    DecreeAddresses.Cancel;
end;

procedure TkisDecreeProject.DecreeAddressInsert(DataSet: TDataSet);
var
  S: String;
begin
  if DoSelectAddress(True, S) then
  begin
    DecreeAddresses.FieldByName(SF_ADDRESS).AsString := S;
    DecreeAddresses.Post;
  end
  else
    DecreeAddresses.Cancel;
end;

procedure TkisDecreeProject.DecreeVisaAfterInsert(DataSet: TDataSet);
begin
  //AddVisa(CurrentStateId);
  DecreeVisas.FieldByName(SF_IN_DATE).AsString := DateToStr(Date);
  with EntityEditor as TKisDecreeProjectEditor do
    dbgVisas.SetFocus;
end;

destructor TkisDecreeProject.Destroy;
begin
  FDecreeAddresses.Close;
  FDecreeAddresses.Free;
  FDecreeAddressesCtrlr.Free;

  FDecreeVisas.Close;
  FDecreeVisas.Free;
  FDecreeVisasCtrlr.Free;

  if Assigned(FLetterAddresses) then
  begin
    FLetterAddresses.Close;
    FLetterAddresses.Free;
  end;

  inherited;
end;

class function TkisDecreeProject.EntityName: String;
begin
  Result := SEN_DECREE_PROJECTS;
end;

function TkisDecreeProject.Equals(Entity: TKisEntity): Boolean;
begin
  inherited Equals(Entity);
  with Entity as TkisDecreeProject do
  begin
    Result := (Self.FHeader = FHeader) and (Self.FExecutorId = FExecutorId)
      and (Self.FOfficesId = FOfficesId) and (Self.FLastVisaId = FLastVisaId)
      and (Self.FDateVisa = FDateVisa) and (Self.FLettersId = FLettersId)
      and (Self.FSeqNumber = FSeqNumber)
      and (Self.FDescription = FDescription);
    if Result then
      Result := Result and DataSetEquals(Self.FDecreeAddresses, FDecreeAddresses);
    if Result then
      Result := Result and DataSetEquals(Self.FDecreeVisas, FDecreeVisas);
  end;
end;

function TkisDecreeProject.GetDecreeAddresses: TDataSet;
begin
  Result := FDecreeAddresses;
end;

function TkisDecreeProject.GetDecreeVisas: TDataSet;
begin
  Result := FDecreeVisas;
end;

function TkisDecreeProject.GetLetterAddresses: TDataSet;
begin
  Result := FLetterAddresses;
end;

function TkisDecreeProject.IsEmpty: Boolean;
begin
  Result := (FHeader = '') and (FExecutorId = N_ZERO)
    and (FOfficesID = N_ZERO)
    and (FLettersId = N_ZERO)
    and (FSeqNumber = '')
    and DecreeAddresses.IsEmpty
    and DecreeVisas.IsEmpty
end;

procedure TkisDecreeProject.Load(DataSet: TDataSet);
var
  Tmp: TKisEntity;
  NeedTransaction: Boolean;
begin
  inherited;
  with DataSet do
  begin
    Self.ID := FieldByName(SF_ID).AsInteger;
    Self.FHeader := FieldByName(SF_HEADER).AsString;
    Self.FExecutorId := FieldByName(SF_EXECUTOR_ID).AsInteger;
    Self.FOfficesId := FieldByName(SF_OFFICES_ID).AsInteger;
    Self.FLettersId := FieldByName(SF_LETTERS_ID).AsInteger;
    Self.FNumberMP := FieldByName(SF_MP_NUMBER).AsString;
    Self.FDateMP := FieldByName(SF_MP_DATE).AsString;
    Self.FSeqNumber := FieldByName(SF_SEQ_NUMBER).AsString;
    Self.FDescription := FieldByName('DESCRIPTION').AsString;
    LoadDecree(FieldByName(SF_DECREES_ID).AsInteger);
  end;
  Assert(True, 'Переделать код загрузки проекта постановления!!!');
  NeedTransaction := not Assigned(SQLMngr.DefaultTransaction);
  with TIBQuery.Create(nil) do
  try
    Forget;
    if NeedTransaction then
    begin
      Transaction := AppModule.Pool.Get;
      Transaction.Init(ilReadCommited, amReadOnly);
      Transaction.StartTransaction;
      SQLMngr.DefaultTransaction := Transaction;
    end
    else
      Transaction := SQLMngr.DefaultTransaction;
    BufferChunks := 10;
    //грузим адреса проектов
    SQL.Text := Format(SQ_GET_DECREE_ADDRESSES_ID, [Self.ID]);
    Open;
    FetchAll;
    while not Eof do
    begin
      Tmp := Manager.GetEntity(FieldByName(SF_ID).AsInteger, keDecreeAddress);
      if Assigned(Tmp) then
        Self.FDecreeAddressesCtrlr.DirectAppend(Tmp);
      Next;
    end;
    Close;
    //грузим адреса заявки
    LoadLetterAddresses(Self.FLettersId);
    //
   //грузим визы
    SQL.Text := Format(SQ_GET_DECREE_VISAS_ID, [Self.ID]);
    Open;
    FetchAll;
    while not Eof do
    begin
      Tmp := Manager.GetEntity(FieldByName(SF_ID).AsInteger, keDecreeVisa);
      if Assigned(Tmp) then
        Self.FDecreeVisasCtrlr.DirectAppend(Tmp);
      Next;
    end;
    Close;
  finally
    if NeedTransaction then
    begin
      SQLMngr.DefaultTransaction := nil;
      Transaction.Commit;
      AppModule.Pool.Back(Transaction);
    end;
  end;
end;

{ TkisDecreeProjectMngr }

procedure TkisDecreeProjectMngr.Activate;
begin
  inherited;
  dsDecreeProjects.Transaction := AppModule.Pool.Get;
  dsDecreeProjects.Transaction.Init();
  dsDecreeProjects.Transaction.AutoStopAction := saNone;
  dsTemp.Transaction := dsDecreeProjects.Transaction;
  Reopen;
end;

function TkisDecreeProjectMngr.CreateEntity(
  EntityKind: TKisEntities): TKisEntity;
begin
  case EntityKind of
  keDefault, keDecreeProject :
    begin
      Result := TKisDecreeProject.Create(Self);
    end;
  keTemporaryDecreeProject :
    begin
      Result := TKisTemporaryDecreeProject.Create(Self);
    end;
  keDecreeAddress :
    begin
      Result := TKisDecreeAddress.Create(Self);
    end;
  keDecreeVisa :
    begin
      Result := TKisDecreeVisa.Create(Self);
    end;
  else
    Result := nil;
  end;
end;

function TkisDecreeProjectMngr.CreateNewEntity(
  EntityKind: TKisEntities): TKisEntity;
begin
  Result := CreateEntity(EntityKind);
  Result.ID := Self.GenEntityID(EntityKind);
end;

procedure TkisDecreeProjectMngr.CreateView;
var
  W: Integer;
begin
  if not Assigned(FView) then
    FView := TKisDecreeProjectsView.Create(Self);
  inherited;
  with TKisDecreeProjectsView(FView) do
  begin
    if dgEditing in dbgTemp.Options then
      dbgTemp.Options := dbgTemp.Options - [dgEditing];
    dbgTemp.DataSource := Self.DataSource1;
    Splitter1.Visible := dbgTemp.Visible;
    W := AppModule.ReadAppParam(Self, dbgTemp, 'Width', varInteger);
    if W <= 0 then
      W := 100;
    dbgTemp.Width := W;
  end;
  FView.Caption := 'Проекты постановлений';
end;

function TkisDecreeProjectMngr.CurrentEntity: TKisEntity;
begin
 Result := GetEntity(dsDecreeProjectsID.AsInteger, keDecreeProject);
end;

procedure TkisDecreeProjectMngr.Deactivate;
begin
  inherited;
  dsDecreeProjects.Close;
  if dsDecreeProjects.Transaction.Active then
     dsDecreeProjects.Transaction.Commit;
  dsTemp.Close;
  dsTemp.Transaction := nil;
  AppModule.Pool.Back(dsDecreeProjects.Transaction);
end;

procedure TkisDecreeProjectMngr.DeleteEntity(Entity: TKisEntity);
var
  Conn: IKisConnection;
  Sql: String;
begin
  if IsEntityInUse(Entity) then
    inherited
  else
  begin
    Conn := GetConnection(True, True);
    try
      if Entity is TKisDecreeProject then
        Sql := SQ_DELETE_DECREE_PROJECT
      else
      if Entity is TKisTemporaryDecreeProject then
        Sql := SQ_DELETE_TMP_DECREE_PROJECT;
      Conn.GetDataSet(Format(Sql, [Entity.ID])).Open;
      FreeConnection(Conn, True);
    except
      FreeConnection(Conn, False);
      raise;
    end;
  end;
end;

function TkisDecreeProjectMngr.EditEntity(Entity: TKisEntity): TKisEntity;
begin
  Result := nil;
  if IsSupported(Entity) and (Entity is TKisDecreeProject) then
  begin
    Result := TKisDecreeProject.Create(Self);
    Result.Assign(Entity);
    Result.Modified := TKisDecreeProject(Result).Edit;
  end;
end;

function TkisDecreeProjectMngr.GenEntityID(
  EntityKind: TKisEntities): Integer;
begin
  case EntityKind of
    keDefault, keDecreeProject :
      Result := AppModule.GetID(SG_DECREE_PROJECT, Self.DefaultTransaction);
    keDecreeAddress :
      Result := AppModule.GetID(SG_DECREE_ADDRESS, Self.DefaultTransaction);
    keDecreeVisa :
      Result := AppModule.GetID(SG_DECREE_VISA, Self.DefaultTransaction);
  else
    Result := -1;
  end;
end;

function TkisDecreeProjectMngr.GetEntity(EntityID: Integer;
  EntityKind: TKisEntities): TKisEntity;
var
  dataSet: TDataSet;
  Conn: IKisConnection;
  QueryText: String;
begin
  Result := nil;
  Conn := GetConnection(True, False);
  try
    case EntityKind of
    keDefault, keDecreeProject :
      QueryText := SQ_SELECT_DECREE_PROJECT;
    keTemporaryDecreeProject :
      QueryText := SQ_SELECT_TMP_DECREE_PROJECT;
    keDecreeAddress :
      QueryText := SQ_SELECT_DECREE_ADDRESSES;
    keDecreeVisa :
      QueryText := SQ_SELECT_DECREE_VISAS;
    else
      raise ELoadEntity.Create(EntityID, EntityKind);
    end;
    DataSet := Conn.GetDataSet(Format(QueryText, [EntityID]));
    DataSet.Open;
    if not DataSet.IsEmpty then
    begin
      Result := CreateEntity(EntityKind);
      Result.Load(DataSet);
    end;
  finally
    FreeConnection(Conn, True);
  end;
end;

function TkisDecreeProjectMngr.GetIdent: TKisMngrs;
begin
  Result := kmDecreeProjects;
end;

function TkisDecreeProjectMngr.GetMainSQLText: String;
begin
  Result := SQ_MAIN;
end;

function TkisDecreeProjectMngr.IsEntityInUse(Entity: TKisEntity): Boolean;
begin
  Result := false;
end;

function TkisDecreeProjectMngr.IsSupported(Entity: TKisEntity): Boolean;
begin
  Result := Assigned(Entity)
    and (   (Entity is TKisDecreeProject)
         or (Entity is TKisTemporaryDecreeProject)
         or (Entity is TKisDecreeAddress)
         or (Entity is TKisDecreeVisa)
        );
  if not Result then
    inherited IsSupported(Entity);
end;

procedure TkisDecreeProjectMngr.PrepareSQLHelper;
var
  I, J, K: Integer;
begin
  inherited;
  with FSQLHelper do
  begin
    with AddTable do
    begin
      TableName := ST_DECREE_PROJECTS;
      TableLabel := 'Основная (Проекты постановлений)';
      AddBlobField(SF_HEADER, SFL_HEADER, 80, [fpSearch, fpSort, fpQuickSearch]);
      AddStringField(SF_SEQ_NUMBER, SFL_NUMBER, 10, [fpSearch, fpSort, fpQuickSearch]);
      AddStringField(SF_ADDRESS, SFL_ADDRESS, 300, [fpSearch, fpSort, fpQuickSearch]);

      if (AppModule.User.RoleName  = S_ROLE_DECREE_CONTROL) or (AppModule.User.IsAdministrator) then
        AddBlobField('DESCRIPTION', 'Описание', 80, [fpSearch, fpSort]);

      I := AddSimpleField(SF_ID, SFL_INSERT_ORDER, ftInteger, [fpSort]);
      K := AddSimpleField(SF_DECREES_ID, '', ftInteger, []);
    end;
    with AddTable do
    begin
      TableName := ST_DECREE_PRJ_VISAS;
      TableLabel := 'Визы';
      AddStringField(SF_PRJ_STATE, SFL_CURRENT_VISA, 100, [fpSearch, fpSort]);
      AddSimpleField(SF_IN_DATE, 'Дата текущей визы', ftDate, [fpSearch, fpSort]);
    end;
    with AddLinkedTable do
    begin
      TableName := ST_DECREE_PRJ_ADDRESSES;
      TableLabel := 'Адреса';
      MasterField := Tables[0].Fields[I];
      AddStringField(SF_ADDRESS, SFL_ADDRESS, 300, [fpSearch]);
      J := AddSimpleField(SF_DECREE_PRJS_ID, '', ftInteger, []);
      DetailField := Fields[J];
    end;
    with AddLinkedTable do
    begin
      TableName := ST_DECREES;
      TableLabel := 'Постановления';
      MasterField := Tables[0].Fields[K];
      AddStringField(SF_DOC_NUMBER, SFL_NUMBER, 10, [fpSearch]);
      AddSimpleField(SF_DOC_DATE, SFL_DATE, ftDate, [fpSearch]);
      AddStringField(SF_HEADER, SFL_HEADER, 300, [fpSearch]);
      AddBlobField(SF_CONTENT, SFL_CONTENT, 300, [fpSearch]);
      J := AddSimpleField(SF_ID, '', ftInteger, []);
      DetailField := Fields[J];
    end;
    with AddTable do
    begin
      TableName := ST_OFFICES;
      TableLabel := 'Отделы';
      AddStringField(SF_NAME, SFL_OFFICE, 80, [fpSearch, fpSort, fpQuickSearch]);
    end;
    with AddTable do
    begin
      TableName := ST_PEOPLE;
      TableLabel := 'Исполнители';
      AddStringField(SF_INITIAL_NAME, 'Исполнитель-создатель', 50, [fpSearch, fpSort, fpQuickSearch]);
    end;
    with AddTable do
    begin
      TableName := ST_LETTERS;
      TableLabel := 'Заявка';
      AddStringField(SF_MP_NUMBER, '№ заявки МП', 10, [fpSearch, fpSort, fpQuickSearch]);
      AddSimpleField(SF_MP_DATE, 'Дата заявки МП', ftDate, [fpSearch, fpSort]);
    end;
  end;
end;

function TKisDecreeProjectMngr.ProcessSQLFilter(aFilter: IKisFilter;
  TheOperation: TKisFilterOperation; Clause: TWhereClause): Boolean;
var
  FltrName: string;
  Condition: TSQLCondition;
begin
  Result := False;
  FltrName := (aFilter as IKisNamedObject).Name;
  if TheOperation = foAddSQL then
  begin
    if (FltrName = SF_OFFICES_ID) then
    begin
      if (aFilter.Value > 0) then
      begin
        Condition := TSQLCondition.Create;
        Condition.Text := 'DP.OFFICES_ID=' + VarToStr(aFilter.Value);
        if Clause.PartCount = 0 then
          Condition.TheOperator := coNone
        else
          Condition.TheOperator := coAnd;
        Condition.Comment := FltrName;
        Clause.AddCondition(Condition);
      end;
      Result := True;
    end;
  end;
  if not Result then
    Result := inherited ProcessSQLFilter(aFilter, TheOperation, Clause);
end;

procedure TkisDecreeProjectMngr.SaveDecreeAddresses(
  DecreeAddr: TKisEntity);
var
  Conn: IKisConnection;
  DataSet: TDataSet;
begin
  Conn := GetConnection(True, True);
  with DecreeAddr as TKisDecreeAddress do
  try
    DataSet := Conn.GetDataSet(SQ_SAVE_DECREE_ADDRESSES);
    if DecreeAddr.ID < 1 then
      DecreeAddr.ID := Self.GenEntityID(keDecreeAddress);
    Conn.SetParam(DataSet, SF_ID, ID);
    Conn.SetParam(DataSet, SF_DECREE_PRJS_ID, HeadId);
    Conn.SetParam(DataSet, SF_ADDRESS, DecreeAddress);
    DataSet.Open;
    FreeConnection(Conn, True);
  except
    FreeConnection(Conn, False);
  end;
end;

procedure TkisDecreeProjectMngr.SaveDecreeProjects(
  DecreeProject: TKisEntity);
var
  Conn: IKisConnection;
  DataSet: TDataSet;
  I: Integer;
begin
  Conn := GetConnection(True, True);
  with DecreeProject as TKisDecreeProject do
  try
    DataSet := Conn.GetDataSet(SQ_SAVE_DECREE_PROJECT);
    if DecreeProject.ID < 1 then
      DecreeProject.ID := Self.GenEntityID(keDecreeProject);
    Conn.SetParam(DataSet, SF_ID, ID);
    Conn.SetParam(DataSet, SF_HEADER, Header);
    Conn.SetParam(DataSet, SF_EXECUTOR_ID, ExecutorId);
    Conn.SetParam(DataSet, SF_OFFICES_ID, OfficesId);
    Conn.SetParam(DataSet, SF_LETTERS_ID, LettersId);
    Conn.SetParam(DataSet, SF_SEQ_NUMBER, SeqNumber);
    Conn.SetParam(DataSet, 'DESCRIPTION', Description);
    if Assigned(FDecree) then
      Conn.SetParam(DataSet, SF_DECREES_ID, FDecree.ID)
    else
      Conn.SetParam(DataSet, SF_DECREES_ID, Null);
    DataSet.Open;

    with FDecreeAddressesCtrlr do
    begin
      for I := 0 to Pred(DeletedCount) do
        Self.DeleteEntity(DeletedElements[I]);
      for I := 1 to Count do
        if Elements[I].Modified then
          Self.SaveDecreeAddresses(Elements[I]);
    end;

    with FDecreeVisasCtrlr do
    begin
      for I := 0 to Pred(DeletedCount) do
        Self.DeleteEntity(DeletedElements[I]);
      for I := 1 to Count do
        if Elements[I].Modified then
          Self.SaveDecreeVisas(Elements[I]);
    end;

    FreeConnection(Conn, True);
  except
    FreeConnection(Conn, False);
    raise;
  end;
end;

procedure TkisDecreeProjectMngr.SaveTmpDecreeProject(
  DecreeProject: TKisEntity);
var
  Conn: IKisConnection;
  DataSet: TDataSet;
begin
  Conn := GetConnection(True, True);
  with DecreeProject as TKisTemporaryDecreeProject do
  try
    DataSet := Conn.GetDataSet(SQ_SAVE_TMP_DECREE_PROJECT);
    if DecreeProject.ID < 1 then
      DecreeProject.ID := Self.GenEntityID(keDecreeProject);
    Conn.SetParam(DataSet, SF_ID, ID);
    Conn.SetParam(DataSet, SF_HEADER, Header);
    Conn.SetParam(DataSet, SF_ADDRESS, Address);
    Conn.SetParam(DataSet, SF_EXECUTOR_ID, ExecutorId);
    Conn.SetParam(DataSet, SF_OFFICES_ID, OfficesId);
    Conn.SetParam(DataSet, SF_LETTERS_ID, LettersId);
    DataSet.Open;

    FreeConnection(Conn, True);
  except
    FreeConnection(Conn, False);
    raise;
  end;
end;

procedure TkisDecreeProjectMngr.SaveDecreeVisas(DecreeVisa: TKisEntity);
var
  Conn: IKisConnection;
  DataSet: TDataSet;
begin
  Conn := GetConnection(True, True);
  with DecreeVisa as TKisDecreeVisa do
  try
    DataSet := Conn.GetDataSet(SQ_SAVE_DECREE_VISAS);
    if DecreeVisa.ID < 1 then
      DecreeVisa.ID := Self.GenEntityID(keDecreeVisa);
    Conn.SetParam(DataSet, SF_ID, ID);
    Conn.SetParam(DataSet, SF_DECREE_PRJS_ID, HeadId);
    Conn.SetParam(DataSet, SF_PRJ_STATE_ID, ProjectStateId);
    Conn.SetParam(DataSet, SF_PRJ_STATE, ProjectState);
    Conn.SetParam(DataSet, SF_IN_DATE, InDate);
    DataSet.Open;

    FreeConnection(Conn, True);
  except
    FreeConnection(Conn, False);
    raise;
  end;
end;

procedure TkisDecreeProjectMngr.SaveEntity(Entity: TKisEntity);
begin
 inherited;
  try
    if Assigned(Entity) then
    if IsSupported(Entity) then
    if (Entity is TKisDecreeProject) then
         SaveDecreeProjects(Entity)
    else
       if (Entity is TKisTemporaryDecreeProject) then
        SaveTmpDecreeProject(Entity)
      else
         if (Entity is TKisDecreeAddress) then
          SaveDecreeAddresses(Entity)
        else
           if (Entity is TKisDecreeVisa) then
             SaveDecreeVisas(Entity)
  except
    raise;
  end;
end;

procedure TkisDecreeProject.LoadDataIntoEditor(Editor: TKisEntityEditor);
begin
  with Editor as TKisDecreeProjectEditor do
  begin
    ComboLocate(cbOffice, OfficesId);
    LoadPeopleList(nil);
    ComboLocate(cbExecutor, ExecutorId);
    edHeader.Text := Header;
    edSeqNumber.Text := SeqNumber;
    UpdateLetter;
    UpdateEditorByDecree;
    memoDesc.Text := Description;
  end;
end;

procedure TkisDecreeProject.LoadLetterAddresses(EntityId: Integer);
var
  Mngr: TKisLetterMngr;
begin
  Mngr := TKisLetterMngr(AppModule[kmLetters]);
  FLetterAddresses := TCustomDataSet.Create(Self.Manager);
  FLetterAddresses.Controller := Mngr.GetAddressController(EntityId);
  FLetterAddresses.Open;
  FLetterAddresses.First;
end;

procedure TkisDecreeProject.LoadPeopleList(Sender: TObject);
var
  P: Integer;
begin
  with EntityEditor as TKisDecreeProjectEditor do
  begin
    if cbOffice.ItemIndex < 0 then
      cbExecutor.Items.Clear
    else
    begin
      P := Integer(cbOffice.Items.Objects[cbOffice.ItemIndex]);
      cbExecutor.Items.Assign(IObject(AppModule.PeolpeList(P)).AObject as TStrings);
    end;
  end;
end;

procedure TkisDecreeProject.PrepareEditor(Editor: TKisEntityEditor);
var
  Lst: TStringList;
begin
  inherited;
  with Editor as TKisDecreeProjectEditor do
  begin
    cbOffice.Items.Assign(IStrings(AppModule.OfficesList(ID_ORGS_UGA)).Strings);
    cbExecutor.Items.Assign(IStrings(AppModule.PeolpeList(Self.FOfficesId)).Strings);
    Lst := AppModule.Lists[klDecreePrjStates];
    Lst.Forget;
    dbgVisas.Columns[1].PickList := Lst;
    //
    if (AppModule.User.RoleName  = S_ROLE_DECREE_CONTROL) or (AppModule.User.IsAdministrator) then begin
      memoDesc.Enabled := True;
      memoDesc.Visible := True;
      Label14.Visible := True;
      tsDesc.TabVisible := True;
    end
    else
    begin
      memoDesc.Enabled := False;
      memoDesc.Visible := False;
      Label14.Visible := False;
      tsDesc.TabVisible := False;
    end;

    btnSelectLetter.OnClick := SelectLetter;

    cbOffice.OnChange := LoadPeopleList;

    dsDecreeAddresses.DataSet := FDecreeAddresses;
    FDecreeAddresses.AfterInsert := DecreeAddressInsert;
    FDecreeAddresses.AfterEdit := DecreeAddressEdit;
    FDecreeAddresses.Refresh;

    dsVisas.DataSet := FDecreeVisas;
    FDecreeVisas.AfterInsert := DecreeVisaAfterInsert;
    FDecreeVisas.BeforePost := DecreeVisaBeforePost;
    FDecreeVisas.BeforeDelete := DecreeVisaBeforeDelete;
    FDecreeVisas.Refresh;

    dsLetterAddresses.DataSet := FLetterAddresses;

    edNumberMP.ReadOnly := True;
    edDateMP.ReadOnly := True;
    dbgLetterAddresses.ReadOnly := True;

    btnSelectDecree.OnClick := SelectDecree;
  end;
end;

procedure TkisDecreeProject.ReadDataFromEditor(Editor: TKisEntityEditor);
begin
  inherited;
  with Editor as TKisDecreeProjectEditor do
  begin
    Header := Trim(edHeader.Text);
    Description := Trim(memoDesc.Text);
    if cbOffice.ItemIndex < N_ZERO then
      OfficesId := N_ZERO
    else
      OfficesId := Integer(cbOffice.Items.Objects[cbOffice.ItemIndex]);
    if cbExecutor.ItemIndex < N_ZERO then
      ExecutorId := N_ZERO
    else
      ExecutorId := Integer(cbExecutor.Items.Objects[cbExecutor.ItemIndex]);
    NumberMP := Trim(edNumberMP.Text);
    DateMP := Trim(edDateMP.Text);
    SeqNumber := Trim(edSeqNumber.Text);
  end;
end;

procedure TkisDecreeProject.SelectLetter(Sender: TObject);
var
  Ent: TKisLetter;
  Filters: IKisFilters;
  aLetterId: Integer;
begin
  with TFilterFactory do
  begin
    Filters := CreateList();
    Filters.Add(CreateFilter(SF_ORGS_ID, ID_ORGS_UGA, frEqual));
  end;
  aLetterId := LettersId;
  if aLetterId = 0 then
    aLetterId := -1;
  Ent := AppModule.SQLMngrs[kmLetters].SelectEntity(False, Filters, True, aLetterId) as TKisLetter;
  if Assigned(Ent) then
  begin
    Ent.Forget();
    if Assigned(SQLMngr.DefaultTransaction) then
      Ent.SQLMngr.DefaultTransaction := SQLMngr.DefaultTransaction;
    LoadLetterAddresses(Ent.ID);
    LettersId := Ent.ID;
    NumberMP := Ent.MPNumber;
    DateMP := Ent.MPDate;
    UpdateLetter;
    if Assigned(SQLMngr.DefaultTransaction) then
      Ent.SQLMngr.DefaultTransaction := nil;
  end;
end;

procedure TkisDecreeProject.SetDateMP(const Value: String);
begin
  if FDateMP <> Value then
  begin
    FDateMP := Value;
    Modified := True;
  end;
end;

procedure TkisDecreeProject.SetDateVisa(const Value: TDate);
begin
  if FDateVisa <> Value then
  begin
    FDateVisa := Value;
    Modified := True;
  end;
end;

procedure TkisDecreeProject.SetExecutorId(const Value: Integer);
begin
  if FExecutorId <> Value then
  begin
    FExecutorId := Value;
    Modified := True;
  end;
end;

procedure TkisDecreeProject.SetHeader(const Value: String);
begin
  if FHeader <> Value then
  begin
    FHeader := Value;
    Modified := True;
  end;
end;

procedure TkisDecreeProject.SetLettersId(const Value: Integer);
begin
  if FLettersId <> Value then
  begin
    FLettersId := Value;
    Modified := True;
  end;
end;

procedure TkisDecreeProject.SetNumberMP(const Value: String);
begin
  if FNumberMP <> Value then
  begin
    FNumberMP := Value;
    Modified := True;
  end;
end;

procedure TkisDecreeProject.SetOfficesId(const Value: Integer);
begin
  if FOfficesId <> Value then
  begin
    FOfficesId := Value;
    Modified := True;
  end;
end;


procedure TkisDecreeProject.UnprepareEditor(Editor: TKisEntityEditor);
begin
  with Editor as TKisDecreeProjectEditor do
  begin
    dsDecreeAddresses.DataSet := nil;
    FDecreeAddresses.AfterInsert := nil;
    FDecreeAddresses.AfterEdit := nil;

    dsVisas.DataSet := nil;
    FDecreeVisas.AfterInsert := nil;
    FDecreeVisas.BeforePost := nil;
    FDecreeVisas.BeforeInsert := nil;
    FDecreeVisas.BeforeDelete := nil;

    dsLetterAddresses.DataSet := nil;

  end;
  inherited;
end;

{ TkisDecreeAddresses }

procedure TkisDecreeAddress.Copy(Source: TKisEntity);
begin
  inherited;
  with Source as TKisDecreeAddress do
  begin
    Self.FDecreeAddress := FDecreeAddress;
  end;
end;

class function TkisDecreeAddress.EntityName: String;
begin
  Result := '';
end;

procedure TkisDecreeAddress.Load(DataSet: TDataSet);
begin
  inherited;
  with DataSet do
  begin
    ID := FieldByName(SF_ID).AsInteger;
    DecreeAddress := FieldByName(SF_ADDRESS).AsString;
    Self.Modified := True;
  end;
end;

procedure TkisDecreeAddress.SetDecreeAddress(const Value: String);
begin
  if FDecreeAddress <> Value then
  begin
    FDecreeAddress := Value;
    Modified := True;
  end;
end;

{ TkisDecreeVisas }

procedure TkisDecreeVisa.Copy(Source: TKisEntity);
begin
  inherited;
  with Source as TKisDecreeVisa do
  begin
    Self.FProjectStateId := FProjectStateId;
    Self.FProjectState := FProjectState;
    Self.FInDate := FInDate;
  end;
end;

class function TkisDecreeVisa.EntityName: String;
begin
  Result := '';
end;

procedure TkisDecreeVisa.Load(DataSet: TDataSet);
begin
  inherited;
  with DataSet do
  begin
    ID := FieldByName(SF_ID).AsInteger;
    ProjectStateId := FieldByName(SF_PRJ_STATE_ID).AsInteger;
    ProjectState := FieldByName(SF_PRJ_STATE).AsString;
    InDate := FieldByName(SF_IN_DATE).AsString;
    Self.Modified := True;
  end;
end;

procedure TkisDecreeVisa.SetInDate(const Value: String);
begin
  if FInDate <> Value then
  begin
    FInDate := Value;
    Modified := True;
  end;
end;

procedure TkisDecreeVisa.SetProjectState(const Value: String);
begin
  if FProjectState <> Value then
  begin
    FProjectState := Value;
    Modified := True;
  end;
end;

procedure TkisDecreeVisa.SetProjectStateId(const Value: Integer);
begin
  if FProjectStateId <> Value then
  begin
    FProjectStateId := Value;
    Modified := True;
  end;
end;

function TkisDecreeProjectMngr.GetMainDataSet: TDataSet;
begin
  Result := dsDecreeProjects;
end;

function TkisDecreeProjectMngr.GetRefreshSQLText: String;
begin
  Result := GetMainSQLText + ' WHERE DP.ID=:ID';
end;

procedure TkisDecreeProjectMngr.Reopen;
begin
  inherited;
  ReopenTemp;
end;

procedure TkisDecreeProjectMngr.ReopenTemp;
begin
  dsTemp.Close;
  dsTemp.Open;
end;

procedure TKisDecreeProjectMngr.CloseView(Sender: TObject;
  var Action: TCloseAction);
begin
  with TKisDecreeProjectsView(FView) do
  begin
    AppModule.SaveAppParam(Self, dbgTemp, 'Width', dbgTemp.Width);
    AppModule.WriteGridProperties(Self, dbgTemp);
  end;
  inherited;
end;

{ TDecreeAddressesCtrlr }

procedure TDecreeAddressesCtrlr.FillFieldDefs(FieldDefsRef: TFieldDefs);
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
    Name := SF_DECREE_PRJS_ID;
  end;
  with FieldDefsRef.AddFieldDef do
  begin
    DataType := ftString;
    FieldNo := 3;
    Name := SF_ADDRESS;
    Size := 300;
  end;
end;

function TDecreeAddressesCtrlr.GetFieldData(Index: Integer; Field: TField;
  out Data): Boolean;
var
  Ent: TKisDecreeAddress;
begin
  try
    Ent := TKisDecreeAddress(Elements[Index]);
    case Field.FieldNo of
    1 : GetInteger(Ent.ID, Data);
    2 : GetInteger(Ent.HeadId, Data);
    3 : GetString(Ent.DecreeAddress, Data);
    else
      raise EDatabaseError.CreateFmt(S_FIELD_NOT_FOUND, [Field.FieldName]);
    end;
    Result := True;
  except
    Result := False;
  end;
end;

procedure TDecreeAddressesCtrlr.SetFieldData(Index: Integer; Field: TField;
  var Data);
begin
  try
    with TKisDecreeAddress(Elements[Index]) do
    case Field.FieldNo of
    1 : ID := SetInteger(Data);
    2 : ;// только для чтения;
    3 : DecreeAddress := SetString(Data);
    end;
  except
    Exit;
  end;
end;

{ TDecreeVisasCtrlr }

procedure TDecreeVisasCtrlr.FillFieldDefs(FieldDefsRef: TFieldDefs);
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
    Name := SF_DECREE_PRJS_ID;
  end;
  with FieldDefsRef.AddFieldDef do
  begin
    DataType := ftInteger;
    FieldNo := 3;
    Name := SF_PRJ_STATE_ID;
  end;
  with FieldDefsRef.AddFieldDef do
  begin
    DataType := ftString;
    FieldNo := 4;
    Size := 100;
    Name := SF_PRJ_STATE;
  end;
  with FieldDefsRef.AddFieldDef do
  begin
    DataType := ftString;
    FieldNo := 5;
    Size := 10;
    Name := SF_IN_DATE;
  end;
end;

function TDecreeVisasCtrlr.GetFieldData(Index: Integer; Field: TField;
  out Data): Boolean;
var
  Ent: TKisDecreeVisa;
begin
  try
    Ent := TKisDecreeVisa(Elements[Index]);
    case Field.FieldNo of
    1 : GetInteger(Ent.ID, Data);
    2 : GetInteger(Ent.HeadId, Data);
    3 : GetInteger(Ent.ProjectStateId, Data);
    4 : GetString(Ent.ProjectState, Data);
    5 : GetString(Ent.InDate, Data);
    else
      raise EDatabaseError.CreateFmt(S_FIELD_NOT_FOUND, [Field.FieldName]);
    end;
    Result := True;
  except
    Result := False;
  end;
end;

procedure TDecreeVisasCtrlr.SetFieldData(Index: Integer; Field: TField;
  var Data);
var
  D: TDateTime;
begin
  try
    with TKisDecreeVisa(Elements[Index]) do
    case Field.FieldNo of
    1 : ID := SetInteger(Data);
    2 : ;// только для чтения;
    3 : ProjectStateId := SetInteger(Data);
    4 : ProjectState := SetString(Data);
    5 : if TryStrToDate(SetString(Data), D) or (SetString(Data) = '') then
          InDate := SetString(Data)
        else
          AppModule.Alert(S_INCORRECT_IN_DATE);
    end;
  except
    Exit;
  end;
end;

procedure TkisDecreeProjectMngr.acEditExecute(Sender: TObject);
begin
  Self.DefaultTransaction := dsDecreeProjects.Transaction;
  try
    EditCurrent;
    Self.DefaultTransaction.CommitRetaining;
  except
    Self.DefaultTransaction.RollbackRetaining;
  end;
  Self.DefaultTransaction := nil;
  dsDecreeProjects.Refresh;
end;

procedure TkisDecreeProjectMngr.acEditUpdate(Sender: TObject);
begin
  if acEdit.Enabled then
    acEdit.Enabled := AppModule.User.CanDoAction(maEdit, keDecreeProject);
end;

procedure TkisDecreeProject.UpdateLetter;
begin
  if Assigned(EntityEditor) then
  with EntityEditor as TKisDecreeProjectEditor do
  begin
    edNumberMP.Text := NumberMP;
    edDateMP.Text := DateMP;
    dsLetterAddresses.DataSet := FLetterAddresses;
  end;
end;

procedure TkisDecreeProject.DecreeVisaBeforePost(DataSet: TDataSet);
var
  PredIndex: Integer;
begin
  // проверка предыдущей
  if DecreeVisas.State = dsInsert then
    PredIndex := DecreeVisas.RecordCount
  else
    PredIndex := Pred(DecreeVisas.RecNo);
  //запись не первая
  if PredIndex > 0 then
  begin
    with FDecreeVisasCtrlr do
    if DecreeVisas.FieldByName(SF_IN_DATE).AsDateTime <
       StrToDate(TKisDecreeVisa(Elements[PredIndex]).InDate)
    then
    begin
      AppModule.Alert(S_CHECK_IN_DATE);
      Abort;
    end;
  end;
  if DecreeVisas.FieldByName(SF_PRJ_STATE).AsString = '' then
  begin
    AppModule.Alert(S_CHECK_PRJ_STATE);
    Abort;
  end;
end;


procedure TkisDecreeProject.SetLastVisaId(const Value: Integer);
begin
  if FLastVisaId <> Value then
  begin
    FLastVisaId := Value;
    Modified := True;
  end;
end;

procedure TkisDecreeProject.DecreeVisaBeforeDelete(DataSet: TDataSet);
begin
  DecreeVisas.Last;
  if MessageDlg('Удалять можно только последнюю визу. Удалить?',
    mtConfirmation, [mbYes, mbNo], 0) = mrNo then
  Abort;
end;

function TkisDecreeProject.GetCurrentStateId: Integer;
begin
  with FDecreeVisasCtrlr do
  if GetRecordCount > 0 then
    Result := TKisDecreeVisa(Elements[GetRecordCount]).FProjectStateId
  else
    Result := 0;
end;

procedure TkisDecreeProject.SetSeqNumber(const Value: String);
begin
  if FSeqNumber <> Value then
  begin
    FSeqNumber := Value;
    Modified := True;
  end;
end;

procedure TkisDecreeProjectMngr.acInsertExecute(Sender: TObject);
var
  Ent: TKisEntity;
begin
  Ent := CreateNewEntity(keDecreeProject);
  Ent.Forget();
  with Ent as TKisDecreeProject do
  begin
    SeqNumber := AppModule.User.GenerateDecreeProjectSeqNumber;
    Modified := False;
    if Edit and Modified then
    begin
      SaveEntity(Ent);
      Reopen;
      Locate(Ent.ID);
    end;
  end;
end;

procedure TkisDecreeProjectMngr.acPrintExecute(Sender: TObject);
var
  RepName: String;
  Conn: IKisConnection;
begin
  with PrintModule(True) do
  begin
    Conn := GetConnection(True, False);
    try
      with Conn.GetDataSet(Format(SQ_GET_REPORTS_FILES, [RT_DECREE_PROJECTS])) do
      begin
        Open;
        if not IsEmpty then
          RepName := AppModule.ReportsPath + Fields[0].AsString
        else
          RepName := '';
        Close;
      end;
    finally
      FreeConnection(Conn, True);
    end;
    if RepName = '' then
      Exit;
    ReportFile := RepName;
    ReportTitle := 'Проекты постановлений';
    SetMasterDataSet(dsDecreeProjects, 'MasterData');
    PrintReport;
  end;
end;

procedure TkisDecreeProject.SelectDecree(Sender: TObject);
var
  DecreeId: Integer;
begin
  if Assigned(FDecree) then
    DecreeId := FDecree.ID
  else
    DecreeId := 0;
  if Decrees.SelectDecree(DecreeId) then
  begin
    LoadDecree(DecreeId);
    Modified := True;
    UpdateEditorByDecree;
  end;
end;

procedure TkisDecreeProject.UpdateEditorByDecree;
begin
  with TKisDecreeProjectEditor(EntityEditor) do
  if Assigned(FDecree) then
  with TKisDecree(FDecree) do
  begin
    edDecreeTypes.Text := DecreeType;
    edDate.Text := DecreeDate;
    edNumber.Text := Number;
    edInt_Date.Text := IntDate;
    edInt_Number.Text := IntNumber;
    mHeader.Text := Header;
    mContent.Text := Content;
  end
  else
  begin
    edDecreeTypes.Clear;
    edDate.Clear;
    edNumber.Clear;
    edInt_Date.Clear;
    edInt_Number.Clear;
    mHeader.Clear;
    mContent.Clear;
  end;
end;

procedure TkisDecreeProject.LoadDecree(DecreeId: Integer);
var
  Q: TIBQuery;
begin
  if DecreeId <= 0 then
    Exit;
  //
  Q := TIBQuery.Create(nil);
  Q.Forget;
  with Q do
  try
    Transaction := AppModule.Pool.Get;
    Transaction.Init(ilReadCommited, amReadOnly);
    Transaction.StartTransaction;
    BufferChunks := 10;
   //грузим адреса проектов
    SQL.Text := Format(SQ_LOAD_DECREE, [DecreeId]);
    Open;
    FDecree := TKisDecree.Create(Self.Manager);
    FDecree.Load(Q);
   finally
     if Transaction.Active then
       Transaction.Commit;
     AppModule.Pool.Back(Transaction);
   end;
end;

{ TKisTemporaryDecreeProject }

procedure TKisTemporaryDecreeProject.Load(DataSet: TDataSet);
begin
  inherited;
  with DataSet do
  begin
    Self.ID := FieldByName(SF_ID).AsInteger;
    Self.FHeader := FieldByName(SF_HEADER).AsString;
    Self.FExecutorId := FieldByName(SF_EXECUTOR_ID).AsInteger;
    Self.FOfficesId := FieldByName(SF_OFFICES_ID).AsInteger;
    Self.FLettersId := FieldByName(SF_LETTERS_ID).AsInteger;
    Self.FAddress := FieldByName(SF_ADDRESS).AsString;
  end;
end;

procedure TKisTemporaryDecreeProject.SetAddress(const Value: String);
begin
  if FAddress <> Value then
  begin
    FAddress := Value;
    Modified := True;
  end;
end;

procedure TKisTemporaryDecreeProject.SetExecutorId(const Value: Integer);
begin
  if FExecutorId <> Value then
  begin
    FExecutorId := Value;
    Modified := True;
  end;
end;

procedure TKisTemporaryDecreeProject.SetHeader(const Value: String);
begin
  if FHeader <> Value then
  begin
    FHeader := Value;
    Modified := True;
  end;
end;

procedure TKisTemporaryDecreeProject.SetLettersId(const Value: Integer);
begin
  if FLettersId <> Value then
  begin
    FLettersId := Value;
    Modified := True;
  end;
end;

procedure TKisTemporaryDecreeProject.SetOfficesId(const Value: Integer);
begin
  if FOfficesId <> Value then
  begin
    FOfficesId := Value;
    Modified := True;
  end;
end;

procedure TkisDecreeProjectMngr.acAcceptProjectExecute(Sender: TObject);
var
  Prj: TKisDecreeProject;
  TmpPrj: TKisTemporaryDecreeProject;
  Letter: TKisLetter;
  Conn: IKisConnection;
  Addr: TKisDecreeAddress;
begin
  inherited;
  Conn := GetConnection(True, True);
  try
    // создаем новый проект
    Prj := TKisDecreeProject(Self.CreateEntity(keDecreeProject));
    Prj.Forget();
    // читаем временный проект
    TmpPrj := TKisTemporaryDecreeProject(Self.CreateEntity(keTemporaryDecreeProject));
    TmpPrj.Forget();
    TmpPrj.Load(dsTemp);
    // копируем данные из временного проекта
    Prj.ID := TmpPrj.ID;
    Prj.Header := TmpPrj.Header;
    Prj.OfficesId := TmpPrj.OfficesId;
    Prj.LettersId := TmpPrj.LettersId;
    Letter := TKisLetter(AppModule[kmLetters].GetEntity(Prj.LettersId, keLetter));
    Letter.Forget();
    if Assigned(Letter) then
    begin
      Prj.NumberMP := Letter.MPNumber;
      Prj.DateMP := Letter.MPDate;
    end;
    Prj.ExecutorId := TmpPrj.ExecutorId;
    if TmpPrj.Address <> '' then
    begin
      Addr := TKisDecreeAddress(Prj.FDecreeAddressesCtrlr.CreateElement);
      Prj.FDecreeAddressesCtrlr.DirectAppend(Addr);
    end;
    Prj.SeqNumber := AppModule.User.GenerateDecreeProjectSeqNumber;
    // сохраняем новый проект
    Self.SaveEntity(Prj);
    // удаляем временный проект
    Self.DeleteEntity(TmpPrj);
    FreeConnection(Conn, True);
    Reopen;
    dsDecreeProjects.Locate(SF_ID, Prj.ID, []);
  except
    FreeConnection(Conn, False);
    raise;
  end;
end;

procedure TkisDecreeProjectMngr.acAcceptProjectUpdate(Sender: TObject);
begin
  inherited;
  acAcceptProject.Enabled := dsTemp.Active and not dsTemp.IsEmpty;
end;

procedure TKisDecreeProjectMngr.dsTempBeforeClose(DataSet: TDataSet);
begin
  inherited;
  if Assigned(FView) then
  with TKisDecreeProjectsView(FView) do
    AppModule.WriteGridProperties(Self, dbgTemp);
end;

procedure TKisDecreeProjectMngr.dsTempAfterOpen(DataSet: TDataSet);
begin
  inherited;
  with TKisDecreeProjectsView(FView) do
    AppModule.ReadGridProperties(Self, dbgTemp);
end;

procedure TKisDecreeProject.SetDescription(const Value: String);
begin
  if FDescription <> Value then
  begin
    FDescription := Value;
    Modified := True;
  end;
end;

end.



