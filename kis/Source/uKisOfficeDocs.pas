{*******************************************************}
{                                                       }
{       "ИС МП УГА"                                     }
{       Менеджер документов отделов                     }
{                                                       }
{       Copyright (c) 2004-2006, МП УГА                 }
{                                                       }
{       Автор: Калабухов А.В.                           }
{       Изменения: Бондырев Р.В.                        }
{                                                       }
{*******************************************************}

{ Описание: реализует операции с документами отделов
  Имя модуля: OfficeDocs
  Версия: 1.08
  Дата последнего изменения: 25.07.2006
  Цель: модуль содержит реализации классов менеджера документов отделов,
        документа отдела, визы, связи документ-письмо.
  Используется: AppModule
  Использует: Kernel Classes
  Исключения: нет }
{
  1.08            25.07.2006
     - в метод Copy классов TKisOfficeDocExecutor & TKisOfficeDocLetter
       добавлено Self.Modified := Modified; для сохранения изменений
     - в метод TKisOfficeDocExecutor.Load добавлена строка
       ID := DataSet.FieldByName(SF_ID).AsInteger;
       иначе загруженные исполнители имели ID = 0 что приводило к последующему
       копированию существующих записей с новыми идентификаторами
     - изменен метод TOfficeDocPhasesCtrlr.SetFieldData для предотвращения
       ввода произвольного названия этапа.
     - Для предотвращения сохранения пустого названия этапа изменен метод
       TKisOfficeDoc.CheckEditor.
     - Проверка дат этапов перенесена в метод CheckEditor
       Ранее проверка проводилась в методе BeforePost - проверялись
       старые данные DataSet
     - удален вызов родительского метода в TKisOfficeDocMngr.acInsertUpdate
       проверка на наличие данных и активность DataSet перенесена в дочерний
       класс - для предотвращения непрерыной обновления элементов управления,
       что приводило к мигания кнопок и загрузке процессора
     - добавлен метод TKisOfficeDoc.OrdersPrint для печати заказов из диалогового
       окна свойств заявки
     
  1.07             07.09.2005
     - исправлен глюк с фильтрацией

  1.06             28.08.2005
     - работа с Бд полностью переведена на tKisConnection

  1.05             10.06.2005
     - изменена работа с письмами - добавлен метод TKisOfficeDoc.AttachLetter

  1.04             22.04.2005
     - использованы новые методы работы с главным датасетом

  1.03             27.11.2004
     - метод Reopen удален из-за реализации унаследованного
  1.02
     - реализован метод IsEntityStored
     - добавлена проверка уникальности номера при сохранении документа
  1.01
     - реализован метод IsEntityInUse
     - исправлена работа с транзакциями
}

unit uKisOfficeDocs;

interface

{$I KisFlags.pas}

uses
  // System
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, DB, ImgList, IBCustomDataSet, ActnList, Menus, DateUtils, Grids,
  StdCtrls,
  // Common
  uCommonUtils, uDataSet, uSQLParsers,
  // Project
  uKisClasses, uKisSQLClasses, uKisEntityEditor, uKisFilters;

type
  TKisOfficeDoc = class(TKisSQLEntity)
  private
    FPeopleList: TStringList;
    FOfficeLink: TKisEntity;
    FLettersCtrlr: TKisEntityController;
    FLetters: TCustomDataSet;
    FExecutors: TCustomDataSet;
    FExecutorsCtrlr: TKisEntityController;
    FProject: TKisEntity;
    FObjectAddress: String;
    FStatusId: Integer;

    FPhasesCtrlr: TKisEntityController;
    FPhases: TCustomDataSet;

    FOrdersCtrlr: TKisEntityController;
    FOrders: TCustomDataSet;
    FObjectType: String;
    FEndDate: String;

    //идентификатор текущего заказа для печати
    FOrderIdForPrint: Integer;

    procedure cbObjectTypeChange(Sender: TObject);
    procedure SetDocNumber(const Value: String);
    procedure SetDocDate(const Value: String);
    procedure SetInformation(const Value: String);
    procedure SetOfficeDocTypesId(const Value: Integer);
    procedure SetOfficesId(const Value: Integer);
    function GetPeopleId: Integer;
    function GetOfficesId: Integer;
    function GetDocNumber: String;
    function GetInformation: String;
    function GetOfficeDocTypesId: Integer;
    procedure ShowLetter(Sender: TObject);
    function GetLetters: TDataSet;
     function GetLetterController: TKisEntityController;
    procedure LettersBeforeDelete(DataSet: TDataSet);
    procedure LettersAfterInsert(DataSet: TDataSet);
    function GetExecutors: TDataSet;
    procedure SetObjectAddress(const Value: String);
    procedure ExecutorsAfterInsert(DataSet: TDataSet);
    procedure ExecutorsBeforePost(DataSet: TDataSet);
    procedure CheckExecutor;
    procedure CheckLastExecutorDate;
    function CheckLastExecutorDateAfterPost: Boolean;
    function GetExecutorDate: String;
    procedure InternalCreateDecreeProject(const Header: String);
    procedure SetProjectId(const Value: Integer);
    procedure SetProject(const Value: TKisEntity);
    function GetProjectId: Integer;
    procedure LoadProject(PrjId: Integer);
    procedure UpdateEditorByProject;
    procedure CreateDecreeProject(Sender: TObject);
    procedure ClearDecreeProject(Sender: TObject);
    procedure SelectDecreeProject(Sender: TObject);
    function GetPhases: TDataSet;
    procedure PhasesEdit(Sender: TObject);
    procedure PhasesDelete(Sender: TObject);
    procedure PhasesBeforePost(DataSet: TDataSet);
    procedure PhasesAfterInsert(DataSet: TDataSet);
    procedure PhasesBeforeInsert(DataSet: TDataSet);
    procedure PhasesBeforeEdit(DataSet: TDataSet);
    procedure OrdersAdd(Sender: TObject);
    procedure OrdersEdit(Sender: TObject);
    procedure OrdersDelete(Sender: TObject);
    procedure OrdersPrint(Sender: TObject);
    procedure FillPrintPopUpMenu(AMenu: TPopupMenu);
    procedure PrintReportOrders(Sender: TObject);
    procedure SetStatusId(const Value: Integer);
    procedure UpdateYearNumber;
    function GetDocDate: String;
    procedure SetObjectType(const Value: String);
    procedure SetEndDate(const Value: String);
  protected
    function GetText: String; override;
    {$IFDEF ENTPARAMS}
    procedure InitParams; override;
    {$ENDIF}
    function CreateEditor: TKisEntityEditor; override;
    procedure PrepareEditor(Editor: TKisEntityEditor); override;
    procedure UnprepareEditor(Editor: TKisEntityEditor); override;
    procedure LoadDataIntoEditor(AEditor: TKisEntityEditor); override;
    procedure ReadDataFromEditor(Editor: TKisEntityEditor); override;
    function CheckEditor(Editor: TKisEntityEditor): Boolean; override;
  public
    constructor Create(Mngr: TKisMngr); override;
    destructor Destroy; override;
    class function EntityName: String; override;
    procedure Copy(Source: TKisEntity); override;
    function IsEmpty: Boolean; override;
    procedure Load(DataSet: TDataSet); override;
    procedure AttachLetter(Letter: TKisEntity);
    function GetIDForLetter(const aLetterId: Integer): Integer;
    property DocNumber: String read GetDocNumber write SetDocNumber;
    property DocDate: String read GetDocDate write SetDocDate;
    property OfficeDocTypesId: Integer read GetOfficeDocTypesId write SetOfficeDocTypesId;
    property PeopleId: Integer read GetPeopleId;
    property OfficesId: Integer read GetOfficesId write SetOfficesId;
    property ObjectAddress: String read FObjectAddress write SetObjectAddress;
    property Information: String read GetInformation write SetInformation;
    property ExecutorDate: String read GetExecutorDate;
    property ProjectId: Integer read GetProjectId write SetProjectId;
    property Project: TKisEntity read FProject write SetProject;
    property StatusId: Integer read FStatusId write SetStatusId;
    property ObjectType: String read FObjectType write SetObjectType;
    property EndDate: String read FEndDate write SetEndDate;

    property Letters: TDataSet read GetLetters;
    property LetterCtrlr: TKisEntityController read GetLetterController;
    property Executors: TDataSet read GetExecutors;
    property Phases: TDataSet read GetPhases;
  end;

  TKisOfficeDocLetter = class(TKisEntity)
  private
    function GetLettersId: Integer;
    procedure SetLettersId(const Value: Integer);
    function GetLetterDocNumber: String;
    procedure SetLetterDocNumber(const Value: String);
    function GetLetterDocDate: String;
    procedure SetLetterDocDate(const Value: String);
    function GetLetterMPNumber: String;
    procedure SetLetterMPNumber(const Value: String);
    function GetLetterMPDate: String;
    procedure SetLetterMPDate(const Value: String);
    function GetLetterFirmName: String;
    procedure SetLetterFirmName(const Value: String);
  protected
    {$IFDEF ENTPARAMS}
    procedure InitParams; override;
    {$ENDIF}
  public
    class function EntityName: String; override;
    procedure Load(DataSet: TDataSet); override;
    procedure Copy(Source: TKisEntity); override;
    property LettersId: Integer read GetLettersId write SetLettersId;
    property LetterDocNumber: String read GetLetterDocNumber write SetLetterDocNumber;
    property LetterDocDate: String read GetLetterDocDate write SetLetterDocDate;
    property LetterMPNumber: String read GetLetterMPNumber write SetLetterMPNumber;
    property LetterMPDate: String read GetLetterMPDate write SetLetterMPDate;
    property LetterFirmName: String read GetLetterFirmName write SetLetterFirmName;
  end;

  TOfficeDocLetterCtrlr = class(TKisEntityController)
  public
    procedure FillFieldDefs(FieldDefsRef: TFieldDefs); override;
    function GetFieldData(Index: Integer; Field: TField; out Data): Boolean; override;
    procedure SetFieldData(Index:integer; Field: TField; var Data); override;
    function GetDeleteQueryText: String; override;
  end;

  TKisOfficeDocExecutor = class(TKisEntity)
  private
    FPeopleId: Integer;
    FPeopleName: String;
    FDocDate: String;
    procedure SetPeopleId(const Value: Integer);
    function GetPeopleName: String;
    procedure InitPeopleName;
    procedure SetDocDate(const Value: String);
  protected
    function GetText: String; override;
  public
    class function EntityName: String; override;
    procedure Copy(Source: TKisEntity); override;
    function IsEmpty: Boolean; override;
    function Equals(Entity: TKisEntity): Boolean; override;
    procedure Load(DataSet: TDataSet); override;
    property PeopleId: Integer read FPeopleId write SetPeopleId;
    property PeopleName: String read GetPeopleName;
    property DocDate: String read FDocDate write SetDocDate;
  end;

  TOfficeDocExecutorCtrlr = class(TKisEntityController)
  private
    FExecutors: TStringList;
    FOfficeId: Integer;
    procedure SetOfficeId(const Value: Integer);
    function GetCurrentExecutorId: Integer;
  public
    property OfficeId: Integer read FOfficeId write SetOfficeId;
    property CurrentExecutorId: Integer read GetCurrentExecutorId;

    procedure FillFieldDefs(FieldDefsRef: TFieldDefs); override;
    function GetFieldData(Index: Integer; Field: TField; out Data): Boolean; override;
    procedure SetFieldData(Index:integer; Field: TField; var Data); override;

    function GetDeleteQueryText: String; override;
  end;

  TKisOfficeDocExecutorSaver = class(TKisEntitySaver)
  protected
    procedure PrepareParams(DataSet: TDataSet); override;
    function GetSQL: String; override;
  end;

  TKisOfficeDocPhaseSaver = class(TKisEntitySaver)
  protected
    function GetSQL: String; override;
    procedure PrepareParams(DataSet: TDataSet); override;
  end;

  TKisOfficeDocSaver = class(TKisEntitySaver)
  private
    procedure SaveInfo(Entity: TKisOfficeDoc);
  protected
    procedure PrepareParams(DataSet: TDataSet); override;
    function GetSQL: String; override;
    procedure InternalSave; override;
  end;

  TKisOfficeDocPhase = class(TKisEntity)
  private
    FExecutorId: Integer;
    FPhaseName: String;
    FBeginDate: String;
    FExecutor: String;
    FEndDate: String;
    procedure SetBeginDate(const Value: String);
    procedure SetEndDate(const Value: String);
    procedure SetExecutorId(const Value: Integer);
    procedure SetPhaseName(const Value: String);
  protected
  public
    class function EntityName: String; override;
    procedure Copy(Source: TKisEntity); override;
    function IsEmpty: Boolean; override;
    procedure Load(DataSet: TDataSet); override;
    function Equals(Entity: TKisEntity): Boolean; override;

    property PhaseName: String read FPhaseName write SetPhaseName;
    property BeginDate: String read FBeginDate write SetBeginDate;
    property EndDate: String read FEndDate write SetEndDate;
    property ExecutorId: Integer read FExecutorId write SetExecutorId;
    property Executor: String read FExecutor;
  end;

  TOfficeDocPhasesCtrlr = class(TKisEntityController)
  public
    procedure FillFieldDefs(FieldDefsRef: TFieldDefs); override;
    function GetFieldData(Index: Integer; Field: TField; out Data): Boolean; override;
    procedure SetFieldData(Index:integer; Field: TField; var Data); override;
    function GetLastPhase: TkisOfficeDocPhase;
    function GetDeleteQueryText: String; override;
  end;

  TOfficeDocOrdersCtrlr = class(TKisEntityController)
  public
    procedure FillFieldDefs(FieldDefsRef: TFieldDefs); override;
    function GetFieldData(Index: Integer; Field: TField; out Data): Boolean; override;
    procedure SetFieldData(Index:integer; Field: TField; var Data); override;
    function GetDeleteQueryText: String; override;
  end;

  TKisOfficeDocMngr = class(TKisSQLMngr)
    dsOfficeDocs: TIBDataSet;
    dsOfficeDocsID: TIntegerField;
    dsOfficeDocsDOC_NUMBER: TIntegerField;
    dsOfficeDocsDOC_DATE: TDateField;
    dsOfficeDocsYEAR_NUMBER: TIBStringField;
    dsOfficeDocsOFFICE_DOC_TYPES_ID: TIntegerField;
    dsOfficeDocsPEOPLE_ID: TIntegerField;
    dsOfficeDocsINFORMATION: TMemoField;
    dsOfficeDocsOFFICE_DOC_TYPES_NAME: TIBStringField;
    dsOfficeDocsPEOPLE_NAME: TIBStringField;
    acPrint: TAction;
    dsOfficeDocsOFFICES_ID: TIntegerField;
    dsOfficeDocsOBJECT_ADDRESS: TIBStringField;
    dsOfficeDocsSTATUS: TIntegerField;
    dsOfficeDocsPHASE_NAME: TStringField;
    acFindDocByOrder: TAction;
    procedure acDeleteExecute(Sender: TObject);
    procedure acInsertUpdate(Sender: TObject);
    procedure acPrintExecute(Sender: TObject);
    procedure DataModuleCreate(Sender: TObject);
    procedure acFindDocByOrderExecute(Sender: TObject);
  private
    FIsUpdatedControls: Boolean;
    procedure SaveOfficeDoc(Doc: TKisEntity);
    procedure SaveOfficeDocExecutor(Executor: TKisOfficeDocExecutor);
    procedure SaveOfficeDocPhase(Phase: TKisOfficeDocPhase);
    procedure SaveOfficeDocLetter(Letter: TKisOfficeDocLetter);
    procedure FillPrintPopUpMenu(AMenu: TPopupMenu);
    procedure PrintReport(Sender: TObject);
    procedure LoadLetters(Entity: TKisOfficeDoc);
    procedure LoadLetters1(Entity: TKisOfficeDoc);
    procedure LoadExecutors(Entity: TKisOfficeDoc);
    procedure LoadPhases(Entity: TKisOfficeDoc);
    procedure LoadOrderData(Entity: TKisOfficeDoc);
    procedure LoadProject(OfficeDoc: TKisOfficeDoc; ProjectId: Integer);
    procedure ViewGridCellColors(Sender: TObject;
      Field: TField; var Background, FontColor: TColor; State: TGridDrawState; var FontStyle:TFontStyles);
    procedure OfficeChange(Sender: TObject);
    procedure ViewUpdateOfficeCombo;
    function GetCurrentFilterOfficeId: Integer;
  protected
    procedure Activate; override;
    procedure CreateView; override;
    procedure Deactivate; override;
    function GenEntityID(EntityKind: TKisEntities = keDefault): Integer; override;
    function GetIdent: TKisMngrs; override;
    function GetMainDataSet: TDataSet; override;
    function GetMainSQLText: String; override;
    function GetRefreshSQLText: String; override;
    function IsSupported(Entity: TKisEntity): Boolean; override;
    procedure Locate(AId: Integer; LocateFail: Boolean = False); override;
    procedure PrepareSQLHelper; override;
    function ProcessSQLFilter(aFilter: IKisFilter;
      TheOperation: TKisFilterOperation; Clause: TWhereClause): Boolean; override;
  public
    function CreateEntity(EntityKind: TKisEntities = keDefault): TKisEntity; override;
    function CurrentEntity: TKisEntity; override;
    function GetEntity(EntityID: Integer; EntityKind: TKisEntities = keDefault): TKisEntity; override;
    function CreateNewEntity(EntityKind: TKisEntities = keDefault): TKisEntity; override;
    function EditEntity(Entity: TKisEntity): TKisEntity; override;
    procedure SaveEntity(Entity: TKisEntity); override;
    procedure DeleteEntity(Entity: TKisEntity); override;
    function IsEntityInUse(Entity: TKisEntity): Boolean; override;
    function IsEntityStored(Entity: TKisEntity): Boolean; override;
  end;

implementation

{$R *.dfm}

uses
  // System
  IBDatabase,
  // Fast Report
  FR_IBXQuery,
  // Common
  uGC, uIBXUtils, uKisUtils, 
  // Project
  uKisAppModule, uKisConsts, uKisOfficeDocEditor, uKisPrintModule, uKisIntf,
  uKisMngrView, uKisOrders, Accounts, uKisLetters, uKisDecreeProjects,
  uKisDecreeHeaderForm, uKisPeople, uKisOfficeDocsView, uKisSearchClasses,
  uKisExceptions;

const
  SQ_GEN_OFFICE_DOC_ID = 'SELECT GEN_ID(OFFICE_DOCS_GEN, 1) FROM RDB$DATABASE';
  SQ_GEN_OFFICE_DOC_EXECUTOR_ID = 'SELECT GEN_ID(OFFICE_DOC_EXECUTORS_GEN, 1) FROM RDB$DATABASE';
  SQ_GEN_OFFICE_DOCS_LETTER_ID = 'SELECT GEN_ID(OFFICE_DOC_LETTERS_GEN, 1) FROM RDB$DATABASE';
  SQ_GEN_OFFICE_DOCS_PHASE_ID = 'SELECT GEN_ID(OFFICE_DOC_PHASES_GEN, 1) FROM RDB$DATABASE';

  SQ_SELECT_OFFICE_DOCS_ALL = 'SELECT A.ID, A.DOC_NUMBER, A.DOC_DATE, A.YEAR_NUMBER, '
    + 'A.OFFICE_DOC_TYPES_ID, A.OFFICES_ID, A.PEOPLE_ID, A.OBJECT_ADDRESS, '
    + 'A.INFORMATION, B.NAME AS OFFICE_DOC_TYPES_NAME, C.FULL_NAME AS PEOPLE_NAME, '
    + 'A.STATUS, ODP.PHASE_NAME '
    + 'FROM '
    + 'OFFICE_DOCS A '
    + 'LEFT JOIN OFFICE_DOC_TYPES B ON A.OFFICE_DOC_TYPES_ID=B.ID '
    + 'LEFT JOIN PEOPLE C ON A.PEOPLE_ID=C.ID '
    + 'LEFT JOIN OFFICE_DOC_PHASES ODP ON (A.LAST_PHASE_ID=ODP.ID) ';

  SQ_SELECT_OFFICE_DOCS_ONE_USER = 'SELECT A.ID, A.DOC_NUMBER, A.DOC_DATE, A.YEAR_NUMBER, '
    + 'A.OFFICE_DOC_TYPES_ID, A.OFFICES_ID, A.PEOPLE_ID, A.OBJECT_ADDRESS, '
    + 'A.INFORMATION, B.NAME AS OFFICE_DOC_TYPES_NAME, C.FULL_NAME AS PEOPLE_NAME, '
    + 'A.STATUS, ODP.PHASE_NAME '
    + 'FROM '
    + 'OFFICE_DOC_EXECUTORS ODE '
    + 'LEFT JOIN OFFICE_DOCS A ON (ODE.OFFICE_DOCS_ID=A.ID) '
    + 'LEFT JOIN OFFICE_DOC_TYPES B ON A.OFFICE_DOC_TYPES_ID=B.ID '
    + 'LEFT JOIN PEOPLE C ON A.PEOPLE_ID=C.ID '
    + 'LEFT JOIN OFFICE_DOC_PHASES ODP ON (A.LAST_PHASE_ID=ODP.ID) '
    + 'WHERE (ODE.PEOPLE_ID=%d) '
    //для поиска заявок только последнего исполнителя заявки отдела
    + 'AND (ODE.ID = (SELECT MAX(ID) FROM OFFICE_DOC_EXECUTORS ODD WHERE ODD.office_docs_id = A.ID))';
{
    + 'GROUP BY '
    + 'A.ID, A.DOC_NUMBER, A.DOC_DATE, A.YEAR_NUMBER, '
    + 'A.OFFICE_DOC_TYPES_ID, A.OFFICES_ID, A.PEOPLE_ID, A.OBJECT_ADDRESS, '
    + 'A.INFORMATION, B.NAME, C.FULL_NAME, '
    + 'A.STATUS, ODP.PHASE_NAME';
}
//    SQ_SELECT_OFFICE_DOCS_ONE_USER1 = 'SELECT * FROM GET_OFFICE_DOCS_ONE_USER(%d)';

  SQ_GET_OFFICE_DOC = 'SELECT * FROM OFFICE_DOCS WHERE ID=%d';
  SQ_GET_OFFICE_DOC_LETTER = 'SELECT * FROM OFFICE_DOC_LETTERS WHERE ID=%d';
  SQ_GET_OFFICE_DOC_LETTER2 = 'SELECT ODL.ID, ODL.LETTERS_ID, L.DOC_NUMBER, '
            + 'L.DOC_DATE, L.FIRM_NAME, L.MP_NUMPER, L.MP_DATE '

            + 'FROM OFFICE_DOC_LETTERS ODL LEFT JOIN LETTERS L ON (ODL.LETTERS_ID=L.ID) '
            + 'WHERE ODL.OFFICE_DOCS_ID=%d';
  SQ_GET_OFFICE_DOC_PHASE = 'SELECT * FROM OFFICE_DOC_PHASES WHERE ID=%d';
  SQ_GET_LETTERS_FOR_OFFICE_DOC = 'SELECT ID, LETTERS_ID FROM OFFICE_DOC_LETTERS WHERE OFFICE_DOCS_ID=%d';
  SQ_GET_EXECUTORS_FOR_OFFICE_DOC = 'SELECT * FROM OFFICE_DOC_EXECUTORS WHERE OFFICE_DOCS_ID=%d';
  SQ_GET_PHASES_FOR_OFFICE_DOC = 'SELECT * FROM OFFICE_DOC_PHASES WHERE OFFICE_DOCS_ID=%d';
  SQ_GET_ORDER_DATA = 'SELECT ID FROM ORDERS WHERE OFFICE_DOCS_ID=%d';

  SQ_SAVE_OFFICE_DOC = 'EXECUTE PROCEDURE SAVE_OFFICE_DOC(:ID, :DOC_NUMBER, '
    + ':DOC_DATE, :OFFICE_DOC_TYPES_ID, :PEOPLE_ID, :OFFICES_ID, '
    + ':OBJECT_ADDRESS, :DECREE_PRJS_ID, :STATUS, :OBJECT_TYPE, :END_DATE)';
  SQ_SAVE_OFFICE_DOC_INFO = 'UPDATE OFFICE_DOCS SET INFORMATION=:INFORMATION WHERE ID=:ID';
  SQ_SAVE_OFFICE_DOC_EXECUTOR = 'EXECUTE PROCEDURE SAVE_OFFICE_DOC_EXECUTOR(:ID, :OFFICE_DOCS_ID, :PEOPLE_ID, :RECEIVE_DATE)';
  SQ_SAVE_OFFICE_DOC_LETTER = 'EXECUTE PROCEDURE SAVE_OFFICE_DOC_LETTERS(:OFFICE_DOCS_ID, :ID, :LETTERS_ID)';
  SQ_SAVE_OFFICE_DOC_PHASE = 'EXECUTE PROCEDURE SAVE_OFFICE_DOC_PHASE(:ID, :OFFICE_DOCS_ID, :PHASE_NAME, :BEGIN_DATE, :END_DATE, :EXECUTOR_ID)';
  SQ_DELETE_ORDERS = 'DELETE FROM ORDERS';
//  SQ_CLEAR_OFFICE_DOC_LETTERS = 'DELETE FROM OFFICE_DOC_LETTERS WHERE OFFICE_DOCS_ID=%d';
//  SQ_CLEAR_OFFICE_DOC_EXECUTORS = 'DELETE FROM OFFICE_DOC_EXECUTORS WHERE OFFICE_DOCS_ID=%d';

  SQ_DELETE_OFFICE_DOC = 'DELETE FROM OFFICE_DOCS WHERE ID=%d';
  SQ_OFFICE_DOC_IN_USE = 'SELECT COUNT(ID) FROM OFFICE_DOC_LETTERS WHERE OFFICE_DOCS_ID=%d';
  SQ_CHECK_OFFICE_DOC_ID_STORED = 'SELECT COUNT(ID) FROM OFFICE_DOCS WHERE ID=%d';
  SQ_CHECK_PROJECT_IS_TEMP = 'SELECT * FROM DECREE_PRJS_QUEUED WHERE ID=%d';

  SQ_SELECT_REPORTS = 'SELECT ID, NAME FROM ALL_REPORTS WHERE REPORT_TYPES_ID=8';
  SQ_SELECT_REPORTS_ORDERS = 'SELECT ID, NAME, REPORT_FOR_LIST FROM ALL_REPORTS WHERE REPORT_TYPES_ID=1';

{ TKisOfficeDocMngr }

procedure TKisOfficeDocMngr.Activate;
begin
  inherited;
  dsOfficeDocs.Transaction := AppModule.Pool.Get;
  dsOfficeDocs.Transaction.Init();
  dsOfficeDocs.Transaction.AutoStopAction := saNone;
  Reopen;
end;

function TKisOfficeDocMngr.GenEntityID(EntityKind: TKisEntities): Integer;
var
  S: String;
  Conn: IKisConnection;
begin
  Result := -1;
  Conn := GetConnection(True, False);
  try
    case EntityKind of
    keDefault, keOfficeDoc :
      S := SQ_GEN_OFFICE_DOC_ID;
    keOfficeDocExecutor :
      S := SQ_GEN_OFFICE_DOC_EXECUTOR_ID;
    keOfficeDocLetter :
      S := SQ_GEN_OFFICE_DOCS_LETTER_ID;
    keOfficeDocPhase :
      S := SQ_GEN_OFFICE_DOCS_PHASE_ID;
    else
      raise Exception.CreateFmt(S_GEN_ID_ERROR, [KisMngrNames[Self.Ident]]);
    end;
    with Conn.GetDataSet(S) do
    begin
      Open;
      Result := Fields[0].AsInteger;
      Close;
    end;
  finally
    FreeConnection(Conn, True);
  end;
end;

procedure TKisOfficeDocMngr.Deactivate;
begin
  inherited;
  dsOfficeDocs.Close;
  dsOfficeDocs.Transaction.Commit;
  AppModule.Pool.Back(dsOfficeDocs.Transaction);
end;

function TKisOfficeDocMngr.IsSupported(Entity: TKisEntity): Boolean;
begin
  Result := Assigned(Entity) and (Entity is TKisOfficeDoc) or (Entity is TKisOfficeDocLetter)
    or (Entity is TKisOfficeDocExecutor) or (Entity is TKisOfficeDocPhase);
end;

function TKisOfficeDocMngr.GetIdent: TKisMngrs;
begin
  Result := kmOfficeDocs;
end;

function TKisOfficeDocMngr.GetMainSQLText: String;
begin
  with AppModule.User do
    if IsAdministrator or CanSheduleWorks or (PeopleTypeId in [1, 2])
    then
      Result := SQ_SELECT_OFFICE_DOCS_ALL
    else
      Result := Format(SQ_SELECT_OFFICE_DOCS_ONE_USER, [PeopleId]);
end;

procedure TKisOfficeDocMngr.Locate(AId: Integer; LocateFail: Boolean = False);
begin
  inherited;
  if dsOfficeDocs.Active then
    dsOfficeDocs.Locate(SF_ID, AId, []);
end;

procedure TKisOfficeDocMngr.OfficeChange(Sender: TObject);
var
  Combo: TComboBox;
  aId: Integer;
begin
  if Sender is TComboBox then
  begin
    Combo := TComboBox(Sender);
    if Combo.ItemIndex >= 0 then
    begin
      aId := Integer(Combo.Items.Objects[Combo.ItemIndex]);
      with TFilterFactory do
        ApplyFilters(CreateList(CreateFilter(SF_OFFICES_ID, aId, frEqual)), False);
    end;
  end;
end;

procedure TKisOfficeDocMngr.PrepareSQLHelper;
begin
  inherited;
  with FSQLHelper do
  begin
    with AddTable do
    begin
      TableName := ST_OFFICE_DOCS;
      TableLabel := 'Основная (письма)';
      AddSimpleField(SF_DOC_NUMBER, 'Номер', ftInteger, [fpSearch, fpSort]);
      AddSimpleField(SF_DOC_DATE, 'Дата', ftDate, [fpSearch, fpSort]);
      AddStringField(SF_YEAR_NUMBER, 'Год/Номер', 15, [fpSearch, fpSort, fpQuickSearch]);
      AddSimpleField(SF_PAID, 'Оплачено', ftBoolean, [fpSearch]);
      AddSimpleField(SF_PAY_DATE, 'Дата оплаты', ftDate, [fpSearch, fpSort]);
      AddStringField(SF_BILL_NUMBER, 'Номер счета', 10, [fpSearch, fpSort, fpQuickSearch]);
      AddSimpleField(SF_BILL_DATE, 'Дата счета', ftDate, [fpSearch, fpSort]);
      AddSimpleField(SF_ID, 'Порядок ввода', ftInteger, [fpSort]);
    end;
    with AddTable do
    begin
      TableName := ST_OFFICE_DOC_TYPES;
      TableLabel := 'Типы документов';
      AddStringField(SF_NAME, 'Тип документа', {old value - 50} 300, [fpSearch, fpSort]);
    end;
    with AddTable do
    begin
      TableName := ST_PEOPLE;
      TableLabel := 'Сотрудники';
      AddStringField(SF_INITIAL_NAME, 'Исполнитель', 70, [fpSearch, fpSort]);
    end;
    with AddTable do
    begin
      TableName := ST_OFFICE_DOC_EXECUTORS;
      TableLabel := 'Исполнители';
      AddSimpleField(SF_ID, 'Порядок ввода', ftInteger, []);
    end;
  end;
end;

function TKisOfficeDocMngr.CurrentEntity: TKisEntity;
begin
  if dsOfficeDocs.Active then
  begin
    DefaultTransaction := dsOfficeDocs.Transaction;
    Result := GetEntity(dsOfficeDocsID.AsInteger, keOfficeDoc);
    DefaultTransaction := nil;
  end
  else
    Result := nil;
end;

function TKisOfficeDocMngr.GetCurrentFilterOfficeId: Integer;
var
  Fltr: IKisFilter;
begin
  Fltr := FFilters.Find(SF_OFFICES_ID);
  if Assigned(Fltr) and not VarIsNull(Fltr.Value) then
    Result := Fltr.Value
  else
    Result := 0;
end;

function TKisOfficeDocMngr.GetEntity(EntityID: Integer;
  EntityKind: TKisEntities): TKisEntity;
var
  Conn: IKisConnection;
  S: String;
  Ds: TDataSet;
begin
  Result := nil;
  Conn := GetConnection(True, False);
  try
    case EntityKind of
    keDefault, keOfficeDoc :
      S := Format(SQ_GET_OFFICE_DOC, [EntityID]);
    keOfficeDocLetter :
      S := Format(SQ_GET_OFFICE_DOC_LETTER2, [EntityID]);
    keOfficeDocPhase :
      S := Format(SQ_GET_OFFICE_DOC_PHASE, [EntityID]);
    else
      raise ELoadEntity.Create(EntityID, EntityKind);
    end;
    Ds := Conn.GetDataSet(S);
    Ds.Open;
    if not Ds.IsEmpty then
    begin
      Result := CreateEntity(EntityKind);
      Result.Load(Ds);
    end;
    Ds.Close;
    if EntityKind in [keDefault, keOfficeDoc] then
    begin
      LoadLetters(TKisOfficeDoc(Result));
      LoadExecutors(TKisOfficeDoc(Result));
      LoadOrderData(TKisOfficeDoc(Result));
      LoadPhases(TKisOfficeDoc(Result));
    end;
  finally
    FreeConnection(Conn, True);
  end;
end;

function TKisOfficeDocMngr.CreateNewEntity(
  EntityKind: TKisEntities): TKisEntity;
begin
  case EntityKind of
  keDefault, keOfficeDoc :
    begin
      Result := TKisOfficeDoc.Create(Self);
      Result[SF_DOC_DATE].Value := Date;
      TKisOfficeDoc(Result).OfficesId := AppModule.User.OfficeID;
      TKisOfficeDoc(Result).DocNumber := IntToStr(AppModule.User.GenerateNewOfficeDocNumber);
    end;
  keOfficeDocExecutor :
    Result := TKisOfficeDocExecutor.Create(Self);
  keOfficeDocLetter :
    Result := TKisOfficeDocLetter.Create(Self);
  else
    raise Exception.Create(S_CANT_CREATE_NEW_ENTITY);
  end;
  Result.ID := Self.GenEntityID(EntityKind);
end;

function TKisOfficeDocMngr.EditEntity(Entity: TKisEntity): TKisEntity;
begin
  Result := nil;
  if IsSupported(Entity) and (Entity is TKisOfficeDoc) then
  begin
    Result := TKisOfficeDoc.Create(Self);
    Result.Assign(Entity);
    Result.Modified := TKisOfficeDoc(Result).Edit;
  end;
end;

procedure TKisOfficeDocMngr.SaveEntity(Entity: TKisEntity);
begin
  inherited;
  if Assigned(Entity) then
  if IsSupported(Entity) then
  if (Entity is TKisOfficeDoc) then
    SaveOfficeDoc(Entity)
  else
    if (Entity is TKisOfficeDocLetter) then
      SaveOfficeDocLetter(TKisOfficeDocLetter(Entity))
    else
      if (Entity is TKisOfficeDocExecutor) then
        SaveOfficeDocExecutor(TKisOfficeDocExecutor(Entity))
      else
        if Entity is TKisOfficeDocPhase then
          SaveOfficeDocPhase(TKisOfficeDocPhase(Entity));
end;

procedure TKisOfficeDocMngr.SaveOfficeDoc(Doc: TKisEntity);
var
  Conn: IKisConnection;
  I: Integer;
  OrderMngr: TKisOrderMngr;
begin
  Conn := GetConnection(True, True);
  try
    with Doc as TKisOfficeDoc do
      // Сохраняем проект постановления
      if Assigned(Project) and (Project is TKisTemporaryDecreeProject) then
      begin
        AppModule.SQLMngrs[kmDecreeProjects].DefaultTransaction := Conn.Transaction;
        AppModule.SQLMngrs[kmDecreeProjects].SaveEntity(Project);
        AppModule.SQLMngrs[kmDecreeProjects].DefaultTransaction := nil;
      end;
    //
    if Doc.ID < 1 then
      Doc.ID := Self.GenEntityID(keOfficeDoc);
    with TKisOfficeDocSaver.Create(Conn) do
    try
      Save(Doc);
    finally
      Free;
    end;
    //
    with Doc as TKisOfficeDoc do
    begin
      // Сохраняем письма
//      Conn.GetDataSet(Format(SQ_CLEAR_OFFICE_DOC_LETTERS, [Doc.ID])).Open;
      with FLettersCtrlr do
      begin
        if DeletedCount > 0 then
          Conn.GetDataSet(GetDeleteQueryText).Open;
        for I := 1 to Count do
          if Elements[I].Modified then
            Self.SaveEntity(Elements[I]);
      end;
      // Сохраняем исполнителей
//      Conn.GetDataSet(Format(SQ_CLEAR_OFFICE_DOC_EXECUTORS, [Doc.ID])).Open;
      with FExecutorsCtrlr do
      begin
        if DeletedCount > 0 then
          Conn.GetDataSet(GetDeleteQueryText).Open;
        for I := 1 to Count do
          if Elements[I].Modified then
            Self.SaveEntity(Elements[I]);
      end;
      with FPhasesCtrlr do
      begin
        if DeletedCount > 0 then
          Conn.GetDataSet(GetDeleteQueryText).Open;
        for I := 1 to Count do
          if Elements[I].Modified then
            Self.SaveEntity(Elements[I]);
      end;
      // Сохраняем заказы
      with FOrdersCtrlr do
      begin
        OrderMngr := TKisOrderMngr(AppModule[kmOrders]);
        OrderMngr.DefaultTransaction := Conn.Transaction;
        if DeletedCount > 0 then
          Conn.GetDataSet(GetDeleteQueryText).Open;
        for I := 1 to Count do
          if Elements[I].Modified then
          begin
            TKisOrder(Elements[I]).OfficeDocId := Doc.ID;
            OrderMngr.SaveEntity(Elements[I]);
          end;
        OrderMngr.DefaultTransaction := nil;
      end;
    end;
    // Подтверждаем изменения
    FreeConnection(Conn, True);
  except
    FreeConnection(Conn, False);
    raise;
  end;
end;

procedure TKisOfficeDocMngr.SaveOfficeDocLetter(Letter: TKisOfficeDocLetter);
var
  Conn: IKisConnection;
  DataSet: TDataSet;
begin
  Conn := GetConnection(True, True);
  try
    DataSet := Conn.GetDataSet(SQ_SAVE_OFFICE_DOC_LETTER);
    if Letter.ID < 1 then
      Letter.ID := Self.GenEntityID(keOfficeDocLetter);
    // :OFFICE_DOCS_ID, :ID, :LETTERS_ID
    Conn.SetParam(DataSet, SF_OFFICE_DOCS_ID, Letter.HeadId);
    Conn.SetParam(DataSet, SF_ID, Letter.ID);
    Conn.SetParam(DataSet, SF_LETTERS_ID, Letter.LettersId);
    DataSet.Open;
    FreeConnection(Conn, True);
  except
    FreeConnection(Conn, False);
    raise;
  end;
end;

function TKisOfficeDocMngr.CreateEntity(
  EntityKind: TKisEntities): TKisEntity;
begin
  case EntityKind of
  keDefault, keOfficeDoc :
    Result := TKisOfficeDoc.Create(Self);
  keOfficeDocLetter :
    Result := TKisOfficeDocLetter.Create(Self);
  keOfficeDocExecutor :
    Result := TKisOfficeDocExecutor.Create(Self);
  keOfficeDocPhase :
    Result := TKisOfficeDocPhase.Create(Self);
  else
    Result := nil;
  end;
end;

procedure TKisOfficeDocMngr.CreateView;
begin
  if not Assigned(FView) then
    FView := TKisOfficeDocsView.Create(Self);
  inherited;
  FIsUpdatedControls := AppModule.User.CanDoAction(maInsert, keOfficeDoc);
  FView.Caption := 'Заявки отделов';
  FView.Grid.OnCellColors := ViewGridCellColors;
  with TKisOfficeDocsView(FView) do
  begin
    cbOffice.OnChange := OfficeChange;
    ViewUpdateOfficeCombo;
    cbOffice.Enabled := AppModule.User.CanSeeAllOffices or AppModule.User.IsAdministrator;
  end;
end;

procedure TKisOfficeDocMngr.DeleteEntity(Entity: TKisEntity);
var
  Conn: IKisConnection;
begin
  Conn := GetConnection(True, True);
  try
    if IsEntityInUse(Entity) then
      inherited
    else
    Conn.GetDataSet(Format(SQ_DELETE_OFFICE_DOC, [Entity.ID])).Open;
    FreeConnection(Conn, True);
  except
    FreeConnection(Conn, False);
    raise;
  end;
end;

function TKisOfficeDocMngr.IsEntityInUse(Entity: TKisEntity): Boolean;
var
  Conn: IKisConnection;
begin
  Conn := GetConnection(True, False);
  with Conn.GetDataSet(Format(SQ_OFFICE_DOC_IN_USE, [Entity.ID])) do
  try
    Open;
    Result := Fields[0].AsInteger > 0;
    Close;
  finally
    FreeConnection(Conn, True);
  end;
end;

function TKisOfficeDocMngr.IsEntityStored(Entity: TKisEntity): Boolean;
var
  Conn: IKisConnection;
begin
  Conn := GetConnection(True, False);
  with Conn.GetDataSet(Format(SQ_CHECK_OFFICE_DOC_ID_STORED, [Entity.ID])) do
  try
    Open;
    Result := Fields[0].AsInteger > 0;
    Close;
  finally
    FreeConnection(Conn, True);
  end;
end;

procedure TKisOfficeDocMngr.FillPrintPopUpMenu(AMenu: TPopupMenu);
var
  Item: TMenuItem;
begin
  with GetConnection(True, False) do
    with GetDataSet(SQ_SELECT_REPORTS) do
    begin
      Open;
      while not Eof do
      begin
        Item := TMenuItem.Create(AMenu);
        Item.Caption := FieldByName(SF_NAME).AsString;
        Item.Tag := FieldByName(SF_ID).AsInteger;
        Item.OnClick := PrintReport;
        AMenu.Items.Add(Item);
        Next;
      end;
      Close;
    end;
end;

procedure TKisOfficeDocMngr.PrintReport(Sender: TObject);
var
  I, J, CurrOfficeId: Integer;
  V: Variant;
  ObjectName: String;
begin
  with PrintModule(True) do
  begin
    with GetConnection(True, False).GetDataSet(Format(SQ_SELECT_REPORT_FILENAME, [TComponent(Sender).Tag])) do
    begin
      Open;
      if not IsEmpty then
        ReportFile := AppModule.ReportsPath + Fields[0].AsString
      else
      begin
        Application.MessageBox(PChar(S_REPORT_NOT_FOUND), PChar(S_WARN), MB_OK + MB_ICONWARNING);
        Exit;
      end;
      Close;
    end;
    //
    SetParamValue(SF_OFFICES_ID, GetCurrentFilterOfficeId);
    SetParamValue('IS_ADMIN', AppModule.User.IsAdministrator);
    AppModule.GetFieldValue(dsOfficeDocs.Transaction, ST_OFFICES, SF_ID,
      SF_SHORT_NAME, dsOfficeDocsOFFICES_ID.AsInteger, V);
    SetParamValue(SF_OFFICE_NAME, V);
    //add full name office
    AppModule.GetFieldValue(dsOfficeDocs.Transaction, ST_OFFICES, SF_ID,
      'NAME', dsOfficeDocsOFFICES_ID.AsInteger, V);
    SetParamValue('FULL_OFFICE_NAME', V);

    SetParamValue(SF_PEOPLE_NAME, dsOfficeDocsPEOPLE_NAME.AsString);
    SetParamValue(SF_OBJECT_ADDRESS, dsOfficeDocsOBJECT_ADDRESS.AsString);
    AppModule.GetFieldValue(dsOfficeDocs.Transaction, ST_OFFICES, SF_ID,
      SF_DIRECTOR_L, dsOfficeDocsOFFICES_ID.AsInteger, V);
    SetParamValue(SF_DIRECTOR, V);
    CurrOfficeId := GetCurrentFilterOfficeId;
    with frReport do
    begin
      for I := 0 to Pred(Pages.Count) do
        for J := 0 to Pred(Pages[I].Objects.Count) do
          if Assigned(Pages[I].Objects[J]) and (TObject(Pages[I].Objects[J]) is TfrIBXQuery) then
          begin
            TfrIBXQuery(Pages[I].Objects[J]).Query.Transaction := dsOfficeDocs.Transaction;
            ObjectName := TfrIBXQuery(Pages[I].Objects[J]).Name;
            if ObjectName = 'QueryPeople' then
            begin
              TfrIBXQuery(Pages[I].Objects[J]).Query.ParamByName(SF_OFFICES_ID).AsInteger := CurrOfficeId;//AppModule.User.OfficeID;
              TfrIBXQuery(Pages[I].Objects[J]).Query.Open;
              TfrIBXQuery(Pages[I].Objects[J]).Query.FetchAll;
            end;
            if ObjectName = 'QueryOffices' then
            begin
              TfrIBXQuery(Pages[I].Objects[J]).Query.Open;
              TfrIBXQuery(Pages[I].Objects[J]).Query.FetchAll;
            end;
            if ObjectName = 'QueryData' then
            begin
              TfrIBXQuery(Pages[I].Objects[J]).Query.ParamByName(SF_OFFICES_ID).AsInteger := CurrOfficeId;//AppModule.User.OfficeID;
            end;
            if ObjectName = 'QueryDocs' then
            begin
              TfrIBXQuery(Pages[I].Objects[J]).Query.ParamByName(SF_OFFICES_ID).AsInteger := CurrOfficeId;//AppModule.User.OfficeID;
            end;
          end;
    end;
    PrintReport;
  end;
end;

function TKisOfficeDocMngr.ProcessSQLFilter(aFilter: IKisFilter;
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
        Condition.Text := 'A.OFFICES_ID=' + VarToStr(aFilter.Value);
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

function TKisOfficeDocMngr.GetMainDataSet: TDataSet;
begin
  Result := dsOfficeDocs;
end;

function TKisOfficeDocMngr.GetRefreshSQLText: String;
begin
  Result := GetMainSQLText;
  if Pos('WHERE', Result) < 1 then
//    Result := Result + ' WHERE ID=:OLD_ID'
    Result := Result + ' WHERE A.ID=:OLD_ID'
  else
//    Result := Result + ' AND ID=:OLD_ID';
    Result := Result + ' AND A.ID=:OLD_ID';
end;

procedure TKisOfficeDocMngr.LoadLetters(Entity: TKisOfficeDoc);
var
  Conn: IKisConnection;
begin
  Conn := GetConnection(True, False);
  try
    with Conn.GetDataSet(Format(SQ_GET_LETTERS_FOR_OFFICE_DOC, [Entity.ID])) do
    begin
      Open;
      while not Eof do
      begin
        Entity.Letters.Insert;
        Entity.FLettersCtrlr.Elements[0].ID := FieldByName(SF_ID).AsInteger;
        TKisOfficeDocLetter(Entity.FLettersCtrlr.Elements[0]).LettersId := FieldByName(SF_LETTERS_ID).AsInteger;
        Entity.Letters.Post;
        Next;
      end;
      Close;
    end;
  finally
    FreeConnection(Conn, True);
  end;
end;

procedure TKisOfficeDocMngr.LoadLetters1(Entity: TKisOfficeDoc);
var
  Conn: IKisConnection;
  Letter: TKisOfficeDocLetter;
  Ds: TDataSet;
begin
  Conn := GetConnection(True, False);
  try
    Entity.Letters.Close;
    Ds := Conn.GetDataSet(Format(SQ_GET_LETTERS_FOR_OFFICE_DOC, [Entity.ID]));
    Ds.Open;
    while not Ds.Eof do
    begin
      Letter := TKisOfficeDocLetter(CreateEntity(keOfficeDocLetter));
      Letter.Load(Ds);
      Entity.FLettersCtrlr.DirectAppend(Letter);
      Ds.Next;
    end;
    Ds.Close;
  finally
    FreeConnection(Conn, True);
    Entity.Letters.Open;
    Entity.Letters.First;
  end;
end;

procedure TKisOfficeDocMngr.LoadExecutors(Entity: TKisOfficeDoc);
var
  Conn: IKisConnection;
  Executor: TKisOfficeDocExecutor;
  Ds: TDataSet;
begin
  Conn := GetConnection(True, False);
  try
    Entity.Executors.Close;
    Ds := Conn.GetDataSet(Format(SQ_GET_EXECUTORS_FOR_OFFICE_DOC, [Entity.ID]));
    Ds.Open;
    while not Ds.Eof do
    begin
      Executor := TKisOfficeDocExecutor(CreateEntity(keOfficeDocExecutor));
      Executor.Load(Ds);
      Entity.FExecutorsCtrlr.DirectAppend(Executor);
      Ds.Next;
    end;
    Ds.Close;
  finally
    FreeConnection(Conn, True);
    Entity.Executors.Open;
    Entity.Executors.First;
  end;
end;

procedure TKisOfficeDocMngr.SaveOfficeDocExecutor(
  Executor: TKisOfficeDocExecutor);
var
  Conn: IKisConnection;
begin
  if Executor.ID < 1 then
    Executor.ID := GenEntityID(keOfficeDocExecutor);
  Conn := GetConnection(True, True);
  try
    with TKisOfficeDocExecutorSaver.Create(Conn) do
    try
      Save(Executor);
    finally
      Free;
    end;
    FreeConnection(Conn, True);
  except
    FreeConnection(Conn, False);
    raise;
  end;
end;

procedure TKisOfficeDocMngr.LoadOrderData(Entity: TKisOfficeDoc);
var
  Conn: IKisConnection;
  Tmp: TKisEntity;
begin
  if Assigned(Entity) then
  begin
    Conn := GetConnection(True, False);
    with Conn.GetDataSet(Format(SQ_GET_ORDER_DATA, [Entity.Id])) do
    begin
      Open;
      with AppModule[kmOrders] do
      while not Eof do
      begin
        Tmp := GetEntity(Fields[0].AsInteger, keOrder);
        if Assigned(Tmp) then
        begin
          Entity.FOrdersCtrlr.DirectAppend(Tmp);
          Tmp.Modified := False;
        end;
        Next;
      end;
      Close;
    end;
  end;
end;

procedure TKisOfficeDocMngr.LoadProject(OfficeDoc: TKisOfficeDoc;
  ProjectId: Integer);
var
  Conn: IKisConnection;
  DataSet: TDataSet;
  Prj: TKisEntity;
begin
  if ProjectId < 1 then
    OfficeDoc.Project := nil
  else
  begin
    Conn := GetConnection(True, False);
    try
      DataSet := Conn.GetDataSet(Format(SQ_CHECK_PROJECT_IS_TEMP, [ProjectId]));
      DataSet.Open;
      if not DataSet.IsEmpty then
      begin
        Prj := AppModule[kmDecreeProjects].CreateEntity(keTemporaryDecreeProject);
        Prj.Load(DataSet);
        OfficeDoc.Project := Prj;
      end
      else
        OfficeDoc.Project := AppModule[kmDecreeProjects].GetEntity(ProjectId, keDecreeProject);
    finally
      FreeConnection(Conn, True);
    end;
  end;
end;

procedure TKisOfficeDocMngr.SaveOfficeDocPhase(Phase: TKisOfficeDocPhase);
var
  Conn: IKisConnection;
begin
  if Phase.ID < 1 then
    Phase.ID := GenEntityID(keOfficeDocPhase);
  Conn := GetConnection(True, True);
  try
    with TKisOfficeDocPhaseSaver.Create(Conn) do
    try
      Save(Phase);
    finally
      Free;
    end;
    FreeConnection(Conn, True)
  except
    FreeConnection(Conn, False);
    raise;
  end;
end;

procedure TKisOfficeDocMngr.LoadPhases(Entity: TKisOfficeDoc);
var
  Conn: IKisConnection;
  Phase: TKisOfficeDocPhase;
  Ds: TDataSet;
begin
  Conn := GetConnection(True, False);
  try
    Entity.Phases.Close;
    Ds := Conn.GetDataSet(Format(SQ_GET_PHASES_FOR_OFFICE_DOC, [Entity.ID]));
    Ds.Open;
    while not Ds.Eof do
    begin
      Phase := TKisOfficeDocPhase(CreateEntity(keOfficeDocPhase));
      Phase.Load(Ds);
      Entity.FPhasesCtrlr.DirectAppend(Phase);
      Ds.Next;
    end;
    Ds.Close;
  finally
    FreeConnection(Conn, True);
    Entity.Phases.Open;
    Entity.Phases.First;
  end;
end;

procedure TKisOfficeDocMngr.ViewGridCellColors(Sender: TObject;
  Field: TField; var Background, FontColor: TColor; State: TGridDrawState; var FontStyle:TFontStyles);
begin
  if gdSelected in State then
    Exit;
  case Field.DataSet.FieldByName(SF_STATUS).AsInteger of
  0 : Background := clInfoBk;
  1 : Background := $CCFFCC;
  2 : Background := 8421600;
  end;
end;

procedure TKisOfficeDocMngr.ViewUpdateOfficeCombo;
begin
  if Assigned(FView) then
  with TKisOfficeDocsView(FView) do
  begin
    cbOffice.Items.Assign(IStrings(AppModule.OfficesList(AppModule.User.OrgId)).Strings);
    if AppModule.User.AllowAllOffices(Self.Ident) then
      cbOffice.Items.InsertObject(0, 'Все отделы', nil);
    ComboLocate(cbOffice, GetCurrentFilterOfficeId);
  end;
end;

{ TKisOfficeDoc }

function TKisOfficeDoc.CheckEditor(Editor: TKisEntityEditor): Boolean;
var
  D: TDateTime;
  I: Integer;
  Num: String;
begin
  Result := False;
  with Editor as TKisOfficeDocEditor do
  begin
    if (Trim(edDocNumber.Text) = '') or not StrIsNumber(Trim(edDocNumber.Text)) then
    begin
      MessageBox(Handle, PChar(S_CHECK_DOCNUMBER), PChar(S_WARN), MB_OK + MB_ICONWARNING);
      edDocNumber.SetFocus;
      Exit;
    end;
    if not TryStrToDate(edDocDate.Text, D) then
    begin
      MessageBox(Handle, PChar(S_CHECK_DOCDATE), PChar(S_WARN), MB_OK + MB_ICONWARNING);
      edDocDate.SetFocus;
      Exit;
    end;
/// попытка похерить тип документа
    cbDocTypes.ItemIndex := 0;
{    if cbDocTypes.ItemIndex < 0 then
    begin
      MessageBox(Handle, PChar(S_CHECK_DOCTYPE), PChar(S_WARN), MB_OK + MB_ICONWARNING);
      if cbDocTypes.Enabled then cbDocTypes.SetFocus;
      Exit;
    end;
}
    if not Manager.IsEntityStored(Self) then
    begin
      if AppModule.User.OfficeDocNumberExists(StrToInt(Trim(edDocNumber.Text)),
           YearOf(StrToDate(edDocDate.Text)) ) then
      begin
        Num := IntToStr(AppModule.User.GenerateNewOfficeDocNumber);
        MessageBox(Handle, PChar(Format(S_OFFICE_DOC_NUMBER_EXISTS, [edDocNumber.Text, IntToStr(YearOf(StrToDate(edDocDate.Text))), Num])),
          PChar(S_WARN), MB_OK + MB_ICONWARNING);
        PageControl.ActivePageIndex := 0;
        edDocNumber.Text := Num;
        edDocNumber.SetFocus;
        //IntToStr(AppModule.User.GenerateNewOfficeDocNumber);
        Exit;
      end;
    end;
    if Assigned(dbgExecutors.DataSource) and Assigned(dbgExecutors.DataSource.DataSet) then
    if dbgExecutors.DataSource.DataSet.IsEmpty then
    begin
      MessageBox(Handle, PChar(S_CHECK_EXECUTOR), PChar(S_WARN), MB_OK + MB_ICONWARNING);
      dbgExecutors.SetFocus;
      Exit;
    end;
    if CheckLastExecutorDateAfterPost = False then
      Exit;
//проверить, имя фазы не должно быть пустым
    if Assigned(dbgPhases.DataSource) and Assigned(dbgPhases.DataSource.DataSet) then
    if not dbgPhases.DataSource.DataSet.IsEmpty then
    begin
      with FPhasesCtrlr do
      begin
        for I := 1 to Count do
        begin
          if TKisOfficeDocPhase(Elements[I]).PhaseName = '' then
          begin
            MessageBox(Handle, PChar(S_CHECK_PHASE_NAME), PChar(S_WARN), MB_OK + MB_ICONWARNING);
            PageControl.ActivePageIndex := 1;
            Exit;
          end;
        end;
      end;
    end;
//--------------------------------------------
    if Trim(edObjectAddress.Text) = '' then
    begin
      MessageBox(Handle, PChar(S_CHECK_OBJECT_ADDRESS), PChar(S_WARN), MB_OK + MB_ICONWARNING);
      edObjectAddress.SetFocus;
      Exit;
    end;
    if cbObjectType.ItemIndex < 0 then
    begin
      MessageBox(Handle, PChar(S_CHECK_OBJECT_TYPE), PChar(S_WARN), MB_OK + MB_ICONWARNING);
      if cbObjectType.Enabled then cbObjectType.SetFocus;
      Exit;
    end;
    if edEndDate.Visible then
    begin
      if not TryStrToDate(edEndDate.Text, D) then
      begin
        MessageBox(Handle, PChar(S_CHECK_END_DATE), PChar(S_WARN), MB_OK + MB_ICONWARNING);
        edEndDate.SetFocus;
        Exit;
      end;
    end;
  end;
  Result := True;
end;

procedure TKisOfficeDoc.Copy(Source: TKisEntity);
var
  Prj: TKisEntity;
begin
  inherited;
  Self.FOfficeLink := TKisOfficeDoc(Source).FOfficeLink;
  with TKisOfficeDoc(Source) do
  begin
    Self.FObjectAddress := ObjectAddress;
    Self.StatusId := StatusId;
    Self.Project := nil;
    if Assigned(Project) then
    begin
      Prj := AppModule[kmDecreeProjects].CreateEntity(keDecreeProject);
      Prj.Assign(Project);
      Self.Project := Prj;
    end;
  end;
end;

constructor TKisOfficeDoc.Create(Mngr: TKisMngr);
begin
  inherited;
  FLettersCtrlr := TOfficeDocLetterCtrlr.CreateController(Mngr, Mngr, keOfficeDocLetter);
  FLettersCtrlr.HeadEntity := Self;
  FLetters := TCustomDataSet.Create(Mngr);
  FLetters.Controller := FLettersCtrlr;
  FLetters.Open;
  FLetters.Last;
  FLetters.First;

  FExecutorsCtrlr := TOfficeDocExecutorCtrlr.CreateController(Mngr, Mngr, keOfficeDocExecutor);
  FExecutorsCtrlr.HeadEntity := Self;
  FExecutors := TCustomDataSet.Create(Mngr);
  FExecutors.Controller := FExecutorsCtrlr;
  FExecutors.Open;
  FExecutors.Last;

  FPhasesCtrlr := TOfficeDocPhasesCtrlr.CreateController(Mngr, Mngr, keOfficeDocPhase);
  FPhasesCtrlr.HeadEntity := Self;
  FPhases := TCustomDataSet.Create(Mngr);
  FPhases.Controller := FPhasesCtrlr;
  FPhases.Open;
  FPhases.Last;

  FOrdersCtrlr := TOfficeDocOrdersCtrlr.CreateController(Mngr, AppModule[kmOrders], keOrder);
  FOrdersCtrlr.HeadEntity := Self;
  FOrders := TCustomDataSet.Create(Mngr);
  FOrders.Controller := FOrdersCtrlr;
  FOrders.Open;
  FOrders.Last;
  FOrders.First;
end;

function TKisOfficeDoc.CreateEditor: TKisEntityEditor;
begin
  Result := TKisOfficeDocEditor.Create(Application);
end;

destructor TKisOfficeDoc.Destroy;
begin
  FreeAndNil(FOrders);
  FreeAndNil(FOrdersCtrlr);
  FreeAndNil(FPhases);
  FreeAndNil(FPhasesCtrlr);
  FreeAndNil(FExecutors);
  FreeAndNil(FExecutorsCtrlr);
  FreeAndNil(FLetters);
  FreeAndNil(FLettersCtrlr);
  FreeAndnil(FPeopleList);
  inherited;
end;

class function TKisOfficeDoc.EntityName: String;
begin
  Result := SEN_OFFICE_DOC;
end;

function TKisOfficeDoc.GetDocNumber: String;
begin
  Result := Self[SF_DOC_NUMBER].AsString;
end;

function TKisOfficeDoc.GetExecutors: TDataSet;
begin
  Result := FExecutors;
end;

function TKisOfficeDoc.GetInformation: String;
begin
  Result := Self[SF_INFORMATION].AsString;
end;

function TKisOfficeDoc.GetLetterController: TKisEntityController;
begin
  Result := FLettersCtrlr; 
end;

function TKisOfficeDoc.GetLetters: TDataSet;
begin
  Result := FLetters;
end;

function TKisOfficeDoc.GetOfficeDocTypesId: Integer;
begin
  Result := Self[SF_OFFICE_DOC_TYPES_ID].AsInteger;
end;

function TKisOfficeDoc.GetOfficesId: Integer;
begin
  if Assigned(FOfficeLink) then
    Result := FOfficeLink.ID
  else
    Result := -1;
end;

function TKisOfficeDoc.GetPeopleId: Integer;
begin
  with FExecutorsCtrlr do
  if GetRecordCount > 0 then
    Result := TKisOfficeDocExecutor(Elements[GetRecordCount]).PeopleId
  else
    Result := -1;
end;

function TKisOfficeDoc.GetText: String;
begin
  if Self.IsEmpty then
    Result := ''
  else
    Result := EntityName + ' ' + FOfficeLink[SF_SHORT_NAME].AsString + ' №'
       + DocNumber + ' ' + DocDate + 'г.';
end;

{$IFDEF ENTPARAMS}
procedure TKisOfficeDoc.InitParams;
begin
  inherited;
  AddParam(SF_DOC_NUMBER);
  AddParam(SF_DOC_DATE);
  AddParam(SF_OFFICE_DOC_TYPES_ID);
  AddParam(SF_OFFICES_ID);
  AddParam(SF_INFORMATION);
  AddParam(SF_YEAR_NUMBER);
end;
{$ENDIF}

function TKisOfficeDoc.IsEmpty: Boolean;
begin
  Result := inherited IsEmpty{ and not Assigned(FOfficeLink)
    and not Assigned(FPeopleLink)};
end;

procedure TKisOfficeDoc.LettersAfterInsert(DataSet: TDataSet);
var
  Ent: TKisEntity;
begin
  Ent := AppModule.SQLMngrs[kmLetters].SelectEntity(True);
  if Assigned(Ent) then
  begin
    Ent.Forget();
    Letters.FieldByName(SF_LETTERS_ID).AsInteger := Ent.ID;
    Letters.Post;
  end
  else
    Letters.Cancel;
end;

procedure TKisOfficeDoc.LettersBeforeDelete(DataSet: TDataSet);
begin
  if MessageBox(0, PChar(S_CONFIRM_DELETE_RECORD), PChar(S_CONFIRM), MB_YESNO + MB_ICONQUESTION) <> ID_YES then
    Abort;
end;

procedure TKisOfficeDoc.Load(DataSet: TDataSet);
begin
  inherited;
  with DataSet do
  begin
    Self.ID := FieldByName(SF_ID).AsInteger;
    Self[SF_DOC_NUMBER].Value := FieldByName(SF_DOC_NUMBER).Value;
    Self[SF_DOC_DATE].Value := FieldByName(SF_DOC_DATE).Value;
    Self[SF_OFFICE_DOC_TYPES_ID].Value := FieldByName(SF_OFFICE_DOC_TYPES_ID).Value;
    Self.OfficesId := DataSet.FieldByName(SF_OFFICES_ID).AsInteger;
    Self[SF_INFORMATION].Value := FieldByName(SF_INFORMATION).Value;
    Self.FObjectAddress := FieldByName(SF_OBJECT_ADDRESS).AsString;
    Self.ProjectId := FieldByName(SF_DECREE_PRJS_ID).AsInteger;
    Self.StatusId := FieldByName(SF_STATUS).AsInteger;
    Self.ObjectType := FieldByName(SF_OBJECT_TYPE).AsString;
    Self.FEndDate := FieldByName(SF_END_DATE).AsString;
    UpdateYearNumber;
  end;
  Modified := False;
end;

procedure TKisOfficeDoc.cbObjectTypeChange(Sender: TObject);
var
  Index: Integer;
begin
  with EntityEditor as TKisOfficeDocEditor do
  begin
    Index := cbObjectType.Items.Count-1;
    if (cbObjectType.Tag <> 0) and
          (cbObjectType.ItemIndex = Index) then
    begin
      Application.MessageBox(PChar('Выбранный тип объекта отсутствует в БД. Выберите другой тип!'), PChar(S_WARN), MB_OK + MB_ICONWARNING);
      cbObjectType.ItemIndex := -1;
      cbObjectType.Items.Delete(Index);
      cbObjectType.Tag := 0;
    end;
  end;
end;

procedure TKisOfficeDoc.LoadDataIntoEditor(AEditor: TKisEntityEditor);
var
  Index: Integer;
begin
  inherited;
  with AEditor as TKisOfficeDocEditor do
  begin
    ComboLocate(cbDocTypes,  Self.OfficeDocTypesId);
    edDocDate.Text := DocDate;
    edDocNumber.Text := Self.DocNumber;
    edObjectAddress.Text := Self.ObjectAddress;
    mInformation.Text := Self.Information;
    edEndDate.Text := EndDate;
    cbObjectType.Tag := 0;
    Index := cbObjectType.Items.IndexOf(ObjectType);
    if Index <> -1 then
      cbObjectType.ItemIndex := Index
    else
    begin
      cbObjectType.Items.Add(ObjectType);
      cbObjectType.ItemIndex := cbObjectType.Items.Count - 1;
      cbObjectType.Tag := 1;
    end;
    cbStatus.ItemIndex := StatusId;
    cbStatus.OnChange(nil);
  end;
end;

procedure TKisOfficeDoc.PrepareEditor(Editor: TKisEntityEditor);
var
  I: Integer;
  aUser: TKisUser;
begin
  inherited;
  aUser := AppModule.User;
  with Editor as TKisOfficeDocEditor do
  begin
    cbDocTypes.Items.Assign(TStrings(IObject(AppModule.OfficeDocTypesList(OfficesId)).AObject));
    cbObjectType.Items.Assign(TStrings(IObject(AppModule.ObjectTypesList(OfficesId)).AObject));
    cbObjectType.OnChange := Self.cbObjectTypeChange;

    btnLetterNew.Enabled := not Self.ReadOnly;
    btnLetterDel.Enabled := not Self.ReadOnly;

    btnLetterShow.OnClick := ShowLetter;

    dsLetters.DataSet := Self.Letters;
    Self.Letters.AfterInsert := LettersAfterInsert;
    Self.Letters.BeforeDelete := LettersBeforeDelete;
    btnLetterShow.OnClick := ShowLetter;

    dsExecutors.DataSet := Executors;
    Executors.AfterInsert := ExecutorsAfterInsert;
    Executors.BeforePost := ExecutorsBeforePost;
    FPeopleList := AppModule.PeolpeList(Self.OfficesId);
    dbgExecutors.Columns[0].PickList := FPeopleList;
    dbgExecutors.Enabled := aUser.CanSheduleWorks or aUser.IsAdministrator;


    dbgPhases.DataSource.DataSet := Phases;
    btnPhaseDelete.OnClick := PhasesDelete;
    btnPhaseEdit.OnClick := PhasesEdit;
    Phases.BeforePost := PhasesBeforePost;
    Phases.BeforeInsert := PhasesBeforeInsert;
    Phases.AfterInsert := PhasesAfterInsert;
    Phases.BeforeEdit := PhasesBeforeEdit;
    btnDecreeProjectCreate.OnClick := Self.CreateDecreeProject;
    btnDecreeProjectClear.OnClick := Self.ClearDecreeProject;
    btnDecreeProjectSelect.OnClick := Self.SelectDecreeProject;
    dbgPhases.Columns[0].PickList := AppModule.ExecutionPhaseList(Self.OfficesId);

    dsOrders.dataSet := FOrders;
    FOrders.Active := TRue;
    FOrders.Last;
    FOrders.First;
    btnOrderCreate.OnClick := Self.OrdersAdd;
    btnOrderEdit.OnClick := Self.OrdersEdit;
    btnOrderDelete.OnClick := Self.OrdersDelete;
    btnOrderPrint.OnClick := Self.OrdersPrint;

    UpdateEditorByProject;

    tsProgress.Enabled := FStatusId = 0;
    tsDecreeProject.Enabled := FStatusId = 0;

    for I := 0 to Pred(tsMain.ControlCount) do
      tsMain.Controls[I].Enabled := (FStatusId = 0) and
        (aUser.CanSheduleWorks or aUser.IsAdministrator);
    gbIncoming.Enabled := True;
    cbStatus.Enabled := aUser.CanSheduleWorks or aUser.IsAdministrator;
    btnLetterShow.Enabled := True;
    for I := 0 to Pred(tsOrders.ControlCount) do
      tsOrders.Controls[I].Enabled := (FStatusId = 0);
    btnOrderEdit.Enabled := True;
    btnOrderPrint.Enabled := True;
  end;
end;

procedure TKisOfficeDoc.ReadDataFromEditor(Editor: TKisEntityEditor);
begin
  inherited;
  with Editor as TKisOfficeDocEditor do
  begin
    Self.DocNumber := Trim(edDocNumber.Text);
    Self.DocDate := edDocDate.Text;
    if cbDocTypes.ItemIndex < 0 then
      Self.OfficeDocTypesId := Integer(cbDocTypes.Items.Objects[cbDocTypes.ItemIndex])
    else
      Self.OfficeDocTypesId := -1;
    Self.Information := Trim(mInformation.Text);
    Self.ObjectAddress := Trim(edObjectAddress.Text);
    StatusId := cbStatus.ItemIndex;
    ObjectType := cbObjectType.Text;
    if edEndDate.Visible then
      EndDate := edEndDate.Text
    else
      EndDate := '';
  end;
end;

procedure TKisOfficeDoc.SetDocNumber(const Value: String);
begin
  if DocNumber <> Value then
  begin
    Self[SF_DOC_NUMBER].Value := Value;
    UpdateYearNumber;
    Modified := True;
  end;
end;

procedure TKisOfficeDoc.SetInformation(const Value: String);
begin
  if Information <> Value then
  begin
    Self[SF_INFORMATION].Value := Value;
    Modified := True;
  end;
end;

procedure TKisOfficeDoc.SetOfficeDocTypesId(const Value: Integer);
begin
  if OfficeDocTypesId <> Value then
  begin
    Self[SF_OFFICE_DOC_TYPES_ID].Value := Value;
    Modified := True;
  end;
end;

procedure TKisOfficeDoc.SetOfficesId(const Value: Integer);
begin
  if OfficesId <> Value then
  begin
    FOfficeLink := AppModule[kmOffices].GetEntity(Value);
    if Assigned(FOfficeLink) then
      Self[SF_OFFICES_ID].Value := Value
    else
      Self[SF_OFFICES_ID].Clear;
    TOfficeDocExecutorCtrlr(FExecutorsCtrlr).OfficeId := Value;
    Modified := True;
  end;
end;

procedure TKisOfficeDoc.ShowLetter(Sender: TObject);
var
  Ent: TKisEntity;
begin
  if Letters.Active and not Letters.IsEmpty then
  begin
    Ent := AppModule[kmLetters].GetEntity(Letters.FieldByName(SF_LETTERS_ID).AsInteger, keLetter);
    if Assigned(Ent) then
    begin
      Ent.Forget();
      TKisVisualEntity(Ent).ReadOnly := True;
      TKisVisualEntity(Ent).Edit;
    end;
  end;
end;

procedure TKisOfficeDoc.UnPrepareEditor(Editor: TKisEntityEditor);
begin
  Phases.AfterInsert := nil;
  Phases.BeforeEdit := nil;
  Phases.BeforeInsert := nil;
  Phases.BeforePost := nil;
  Phases.AfterPost := nil;
  Executors.AfterInsert := nil;
  Executors.BeforePost := nil;
  Executors.AfterPost := nil;
  FreeAndNil(FPeopleList);
  inherited;
end;

procedure TKisOfficeDoc.SetObjectAddress(const Value: String);
begin
  if FObjectAddress <> Value then
  begin
    FObjectAddress := Value;
    Modified := True;
  end;
end;

procedure TKisOfficeDoc.ExecutorsAfterInsert(DataSet: TDataSet);
begin
  Executors.FieldByName(SF_RECEIVE_DATE).AsDateTime := Date;
end;

procedure TKisOfficeDoc.ExecutorsBeforePost(DataSet: TDataSet);
begin
  // Проверить заполнение исполнителя и даты передачи
//проверка даты перенесена в метод CheckEditor, т.к. до POST данные не изменены
//  CheckLastExecutorDate;
  CheckExecutor;
end;

procedure TKisOfficeDoc.CheckExecutor;
var
  Ent: TKisOfficeDocExecutor;
begin
  if Executors.Active and (Executors.RecordCount > 0) then
  begin
    if Executors.State in [dsInsert, dsEdit] then
      Ent := FExecutorsCtrlr.TempElement as TKisOfficeDocExecutor
    else
      Ent := FExecutorsCtrlr.Elements[Executors.RecNo] as TKisOfficeDocExecutor;
    with Ent do
      if PeopleId <= 0 then
      begin
        Application.MessageBox(PChar(S_CHECK_EXECUTOR), PChar(S_WARN), MB_OK + MB_ICONWARNING);
        TKisOfficeDocEditor(EntityEditor).dbgExecutors.SetFocus;
        Abort;
      end;
  end;
end;

function TKisOfficeDoc.CheckLastExecutorDateAfterPost: Boolean;
var
  LastDate, PredDate: TDateTime;
begin
  Result := False;
  if Executors.Active then
  begin
    if Executors.RecordCount > 1 then
    begin
      with FExecutorsCtrlr.Elements[Executors.RecordCount] as TKisOfficeDocExecutor do
        if not TryStrToDate(DocDate, LastDate) then
        begin
          Application.MessageBox(PChar(S_CHECK_LAST_DATE), PChar(S_WARN), MB_OK + MB_ICONWARNING);
          TKisOfficeDocEditor(Self.EntityEditor).dbgExecutors.SetFocus;
          Exit;
        end;
      with FExecutorsCtrlr.Elements[Pred(Executors.RecordCount)] as TKisOfficeDocExecutor do
        if not TryStrToDate(DocDate, PredDate) then
        begin
          Application.MessageBox(PChar(S_CHECK_LAST_DATE), PChar(S_WARN), MB_OK + MB_ICONWARNING);
          TKisOfficeDocEditor(Self.EntityEditor).dbgExecutors.SetFocus;
          Exit;
        end
        else
          if PredDate > LastDate then
          begin
            Application.MessageBox(PChar(S_CHECK_LAST_AND_PRED_DATE), PChar(S_WARN), MB_OK + MB_ICONWARNING);
            TKisOfficeDocEditor(Self.EntityEditor).dbgExecutors.SetFocus;
            Exit;
          end;
    end;
  end;
  Result := True;
end;

procedure TKisOfficeDoc.CheckLastExecutorDate;
var
  LastDate, PredDate: TDateTime;
begin
  if Executors.Active then
  begin
    if Executors.RecordCount > 1 then
    begin
      with FExecutorsCtrlr.Elements[Executors.RecordCount] as TKisOfficeDocExecutor do
        if not TryStrToDate(DocDate, LastDate) then
        begin
          Application.MessageBox(PChar(S_CHECK_LAST_DATE), PChar(S_WARN), MB_OK + MB_ICONWARNING);
          TKisOfficeDocEditor(Self.EntityEditor).dbgExecutors.SetFocus;
          Abort;
        end;
      with FExecutorsCtrlr.Elements[Pred(Executors.RecordCount)] as TKisOfficeDocExecutor do
        if not TryStrToDate(DocDate, PredDate) then
        begin
          Application.MessageBox(PChar(S_CHECK_LAST_DATE), PChar(S_WARN), MB_OK + MB_ICONWARNING);
          TKisOfficeDocEditor(Self.EntityEditor).dbgExecutors.SetFocus;
          Abort;
        end;
{
        else
          if PredDate > LastDate then
          begin
            Application.MessageBox(PChar(S_CHECK_LAST_AND_PRED_DATE), PChar(S_WARN), MB_OK + MB_ICONWARNING);
            TKisOfficeDocEditor(Self.EntityEditor).dbgExecutors.SetFocus;
            Abort;
          end;
}
    end;
  end;
end;

procedure TKisOfficeDoc.AttachLetter(Letter: TKisEntity);
var
  OffDocLetter: TKisOfficeDocLetter;
begin
  OffDocLetter := Manager.CreateNewEntity(keOfficeDocLetter) as TKisOfficeDocLetter;
  with Letter as TKisLetter do
  begin
    OffDocLetter.LettersId := ID;
    OffDocLetter.LetterDocNumber := DocNumber;
    OffDocLetter.LetterDocDate := DocDate;
    OffDocLetter.LetterFirmName := FirmName;
    OffDocLetter.LetterMPNumber := MPNumber;
    OffDocLetter.LetterMPDate := MPDate;
    Self.FLettersCtrlr.DirectAppend(OffDocLetter);
    Letters.Last;
  end;
end;

function TKisOfficeDoc.GetExecutorDate: String;
begin
  if FExecutors.IsEmpty then
    Result := ''
  else
    Result := TKisOfficeDocExecutor(FExecutorsCtrlr.Elements[FExecutors.RecordCount]).DocDate;
end;

// Метод проверяет соедине ли документ с письмом и если да, то возвращает ID связи, иначе 0
function TKisOfficeDoc.GetIDForLetter(const aLetterId: Integer): Integer;
var
  I: Integer;
  aOffDocLetter: TKisOfficeDocLetter;
begin
  Result := 0;
  for I := 1 to FLettersCtrlr.GetRecordCount do
  begin
    aOffDocLetter := TKisOfficeDocLetter(FLettersCtrlr.Elements[I]);
    if aOffDocLetter.LettersId = aLetterId then
    begin
      Result := aOffDocLetter.ID;
      Exit;
    end;
  end;
end;

procedure TKisOfficeDoc.InternalCreateDecreeProject(const Header: String);
var
  Prj: TKisTemporaryDecreeProject;
  aModule: TkisDecreeProjectMngr;
begin
  aModule := TkisDecreeProjectMngr(AppModule[kmDecreeProjects]);
  Prj := TKisTemporaryDecreeProject(aModule.CreateNewEntity(keTemporaryDecreeProject));
  Prj.OfficesId := Self.OfficesId;
  if LetterCtrlr.Count > 0 then
    Prj.LettersId := Self.LetterCtrlr.Elements[1].ID;
  Self.FExecutors.Last;
  Prj.ExecutorId := TOfficeDocExecutorCtrlr(FExecutorsCtrlr).CurrentExecutorId;
  Prj.Header := Header;
  Prj.Address := Self.ObjectAddress;
  Self.Project := Prj;
end;

procedure TKisOfficeDoc.SetProjectId(const Value: Integer);
begin
  if ProjectId <> Value then
    LoadProject(Value);
end;

procedure TKisOfficeDoc.SetProject(const Value: TKisEntity);
begin
  if not IsEntitiesEquals(FProject, Value) then
  begin
    FreeAndNil(FProject);
    FProject := Value;
    Modified := True;
  end;
end;

function TKisOfficeDoc.GetProjectId: Integer;
begin
  if Assigned(FProject) then
    Result := Fproject.ID
  else
    Result := 0;
end;

procedure TKisOfficeDoc.LoadProject(PrjId: Integer);
begin
  TKisOfficeDocMngr(Self.Manager).LoadProject(Self, PrjId)
end;

procedure TKisOfficeDoc.UpdateEditorByProject;
begin
  with TKisOfficeDocEditor(EntityEditor) do
  begin
    edSeqNumber.Clear;
    mHeader.Clear;
    dbgVisas.DataSource.DataSet := nil;

    btnDecreeProjectCreate.Enabled := not Assigned(FProject);
    btnDecreeProjectSelect.Enabled := not Assigned(FProject);
    btnDecreeProjectClear.Enabled := Assigned(FProject);
    if Assigned(FProject) then
      if FProject is TKisTemporaryDecreeProject then
        mHeader.Text := TKisTemporaryDecreeProject(FProject).Header
      else
      begin
        mHeader.Text := TKisDecreeProject(FProject).Header;
        edSeqNumber.Text := TKisDecreeProject(FProject).SeqNumber;
        dsVisas.DataSet := TKisDecreeProject(FProject).DecreeVisas;
      end;
  end;
end;

procedure TKisOfficeDoc.ClearDecreeProject(Sender: TObject);
var
  Module: TKisDecreeProjectMngr;
begin
  if Assigned(Self.Project) then
  begin
    if Project is TKisTemporaryDecreeProject then
    begin
      Module := TKisDecreeProjectMngr(AppModule[kmDecreeProjects]);
      Module.DefaultTransaction := SQLMngr.DefaultTransaction;
      Module.DeleteEntity(Project);
      Module.DefaultTransaction := nil;
    end;
    Self.Project := nil;
    UpdateEditorByProject;
  end;
end;

procedure TKisOfficeDoc.CreateDecreeProject(Sender: TObject);
begin
  if AppModule.User.PeopleId = TOfficeDocExecutorCtrlr(FExecutorsCtrlr).GetCurrentExecutorId then
  with TKisDecreeHeaderForm.Create(nil) do
  try
    if ShowModal = mrOK then
    begin
      // покажем форму с заголовком
      InternalCreateDecreeProject(mText.Text);
      UpdateEditorByProject;
    end;
  finally
    Free;
  end;
end;

procedure TKisOfficeDoc.SelectDecreeProject(Sender: TObject);
var
  Prj: TKisEntity;
begin
  with TFilterFactory do
    Prj := AppModule.SQLMngrs[kmDecreeProjects].SelectEntity(True,
      CreateList(CreateFilter(SF_OFFICES_ID, Self.OfficesId, frEqual)), False);
  if Assigned(Prj) then
  begin
    Self.Project := Prj;
    UpdateEditorByProject;
  end;
end;

function TKisOfficeDoc.GetPhases: TDataSet;
begin
  Result := FPhases;
end;

procedure TKisOfficeDoc.PhasesEdit(Sender: TObject);
begin
  Phases.Edit;
end;

procedure TKisOfficeDoc.PhasesDelete(Sender: TObject);
begin
  if AppModule.User.PeopleId = TOfficeDocExecutorCtrlr(FExecutorsCtrlr).GetCurrentExecutorId then
  if MessageBox(EntityEditor.Handle,
       PChar('Удалить последний этап?'), PChar(S_CONFIRM),
       MB_YESNO + MB_ICONQUESTION) = ID_YES
  then
  begin
    Phases.Last;
    Phases.Delete;
  end;
end;

procedure TKisOfficeDoc.PhasesBeforePost(DataSet: TDataSet);
var
  EndDate, BeginDate: TDate;
  I: Integer;
  Phase, PrevPhase: TKisOfficeDocPhase;
begin
  Phase := TKisOfficeDocPhase(FPhasesCtrlr.TempElement);
  if Phase.EndDate <> '' then
  begin
    EndDate := Phases.FieldByName(SF_END_DATE).AsDateTime;
    BeginDate := Phases.FieldByName(SF_BEGIN_DATE).AsDateTime;
    if EndDate < BeginDate then
    begin
      MessageBox(EntityEditor.Handle,
        PChar('Проверте дату завершения!'), PChar(S_WARN),
        MB_OK + MB_ICONWARNING);
      Abort;
    end;
  end;
  if ((DataSet.State = dsEdit) and (Phases.RecordCount > 1))
     or
     ((dataSet.State = dsInsert) and (Phases.RecordCount > 0))
  then
  begin
    Phase := TKisOfficeDocPhase(FPhasesCtrlr.TempElement);
    if dataSet.State = dsEdit then
      I := Pred(DataSet.RecordCount)
    else
      I := DataSet.RecordCount;
    PrevPhase := TKisOfficeDocPhase(FPhasesCtrlr.Elements[I]);
    if StrToDate(PrevPhase.EndDate) > StrToDate(Phase.BeginDate) then
    begin
      MessageBox(EntityEditor.Handle,
        PChar('Проверте дату начала!'), PChar(S_WARN),
        MB_OK + MB_ICONWARNING);
      Abort;
    end;
  end;
end;

procedure TKisOfficeDoc.PhasesBeforeInsert(DataSet: TDataSet);
var
  PrevPhase: TKisOfficeDocPhase;
begin
  if AppModule.User.PeopleId <> TOfficeDocExecutorCtrlr(FExecutorsCtrlr).GetCurrentExecutorId then
  begin
    MessageBox(EntityEditor.Handle,
      PChar('Изменять этапы может только последний исполнитель!'), PChar(S_WARN),
      MB_OK + MB_ICONWARNING);
    Abort;
  end;
  if Phases.RecordCount > 0 then
  begin
    PrevPhase := TKisOfficeDocPhase(FPhasesCtrlr.Elements[DataSet.RecordCount]);
    if PrevPhase.EndDate = '' then
    begin
      MessageBox(EntityEditor.Handle,
        PChar('Завершите текущий этап!'), PChar(S_WARN),
        MB_OK + MB_ICONWARNING);
      Abort;
    end;
  end;
end;

procedure TKisOfficeDoc.PhasesBeforeEdit(DataSet: TDataSet);
begin
  if AppModule.User.PeopleId <> TOfficeDocExecutorCtrlr(FExecutorsCtrlr).GetCurrentExecutorId then
    Abort
  else
  if Phases.RecordCount <> Phases.RecNo then
    Abort;
end;

procedure TKisOfficeDoc.OrdersAdd(Sender: TObject);
var
  Order: TKisOrder;
  Editor: TKisOfficeDocEditor;
begin
  Editor := EntityEditor as TKisOfficeDocEditor;
  if Trim(Editor.edObjectAddress.Text) = '' then
  begin
    MessageBox(0, PChar(S_CHECK_OBJECT_ADDRESS), PChar(S_WARN), MB_OK + MB_ICONWARNING);
    Editor.PageControl.ActivePageIndex := 0;
    Editor.edObjectAddress.SetFocus;
    Exit;
  end;
  FOrders.Append;
  Order := TKisOrder(FOrdersCtrlr.TempElement);
  Order.PeopleId := TOfficeDocExecutorCtrlr(Self.FExecutorsCtrlr).CurrentExecutorId;
  Order.OfficeDocId := Self.Id;
  Order.OrderNumber := AppModule.User.GenerateNewAccountNumber;
  if Self.ObjectAddress = '' then
      Order.ObjectAddress := Trim(Editor.edObjectAddress.Text)
  else
    Order.ObjectAddress := Self.ObjectAddress;
  if FLettersCtrlr.Count > 0 then
    Order.LetterId := TKisOfficeDocLetter(FLettersCtrlr.Elements[0]).LettersId;
  Order.NDS := TKisOrderMngr(Order.SQLMngr).GetActualNDS();
  Order.Modified := False;
  if Order.Edit then
    FOrders.Post
  else
    FOrders.Cancel;
end;

procedure TKisOfficeDoc.OrdersEdit(Sender: TObject);
var
  Order: TKisOrder;
begin
  if FOrders.RecordCount = 0 then
    Exit;
  FOrders.Edit;
  Order := TKisOrder(FOrdersCtrlr.TempElement);
  Order.ReadOnly := not AppModule.User.CanSheduleWorks;
  if Order.Edit then
    FOrders.Post
  else
    FOrders.Cancel;
end;

procedure TKisOfficeDoc.OrdersDelete(Sender: TObject);
begin
  if FOrders.RecordCount > 0 then
  if MessageBox(0,
       PChar('Удалить заказ?'),
       PChar(S_CONFIRM),
       MB_YESNO + MB_ICONQUESTION) = ID_YES
  then
    FOrders.Delete;
end;

procedure TKisOfficeDoc.OrdersPrint(Sender: TObject);
var
  PopUpMenu: TPopupMenu;
  P: TPoint;
//  Order: TKisOrder;
  Conn: IKisConnection;
begin
//  inherited;
  if FOrders.RecordCount = 0 then
    Exit;
  FOrderIdForPrint := FOrders.FieldByName(SF_ID).AsInteger;
//проверить сохранены ли заказы и текущая заявка
  if FOrderIdForPrint = 0 then
  begin
    FOrderIdForPrint := 0;
    if MessageBox(0, PChar(S_CONFIRM_SAFE_ORDER_ALL), PChar(S_CONFIRM), MB_YESNO + MB_ICONQUESTION) = ID_YES then
    begin
      if CheckEditor(EntityEditor) then
      begin
          if SQLMngr.IsEntityStored(Self) then
            Conn := SQLMngr.CreateNewConnection(
                      AppModule, Self.SQLMngr.DefaultTransaction, True, True)
          else
            Conn := nil;
          Self.Modified := True;
          Self.SQLMngr.SaveEntity(Self);
          if Assigned(Conn) then
            TKisOfficeDocMngr(AppModule[kmOfficeDocs]).FreeConnection(Conn, True);
        FOrderIdForPrint := FOrders.FieldByName(SF_ID).AsInteger;//Order.ID;//
      end
      else
        Exit;
    end
    else
      Exit;
  end;

  PopUpMenu := TPopupMenu.Create(TKisOfficeDocEditor(EntityEditor));
  FillPrintPopupMenu(PopUpMenu);
  if PopUpMenu.Items.Count > 0 then
  begin
    P := Point(0, 0);
    if Assigned(EntityEditor) then
    with EntityEditor as TKisOfficeDocEditor do
    begin
      P := ClientToScreen(Point(
            btnOrderPrint.Left,
            btnOrderPrint.Top + btnOrderPrint.Height));
    end;
    PopUpMenu.Popup(P.X, P.Y);
  end;
end;

procedure TKisOfficeDoc.FillPrintPopUpMenu(AMenu: TPopupMenu);
var
  Item: TMenuItem;
  Module: TKisOfficeDocMngr;
begin
  Module := TKisOfficeDocMngr(AppModule[kmOfficeDocs]);
  with Module.GetConnection(True, False) do
  with GetDataSet(SQ_SELECT_REPORTS_ORDERS) do
  begin
    Open;
    while not Eof do
    begin
      Item := TMenuItem.Create(AMenu);
      Item.Caption := FieldByName(SF_NAME).AsString;
      Item.Tag := FieldByName(SF_ID).AsInteger;
      Item.OnClick := PrintReportOrders;
      if FieldByName('REPORT_FOR_LIST').AsInteger = 1 then
        Item.Enabled := False;
      AMenu.Items.Add(Item);
      Next;
    end;
    Close;
  end;
end;

procedure TKisOfficeDoc.PrintReportOrders(Sender: TObject);
var
//  Id: Integer;
  ReportFile: String;
begin
//  Application.MessageBox('No code here', 'Message');
   with TKisOfficeDocMngr(AppModule[kmOfficeDocs]).GetConnection(True, False).
      GetDataSet(Format(SQ_SELECT_REPORT_FILENAME, [TComponent(Sender).Tag])) do
   begin
    Open;
    if not IsEmpty then
      ReportFile := Fields[0].AsString
    else
    begin
      Application.MessageBox(PChar(S_REPORT_NOT_FOUND), PChar(S_WARN), MB_OK + MB_ICONWARNING);
      Exit;
    end;
    Close;
   end;
   if FOrderIdForPrint = 0 then
   begin
    Application.MessageBox('Заявка не сохранена!', PChar(S_WARN), MB_OK + MB_ICONWARNING);
    Exit;
   end;
   TAccountsForm.SelectAccountForPrint(FOrderIdForPrint, ReportFile);
end;

procedure TKisOfficeDoc.SetStatusId(const Value: Integer);
begin
  if FStatusId <> Value then
  begin
    FStatusId := Value;
    Modified := True;
  end;
end;

procedure TKisOfficeDoc.SetDocDate(const Value: String);
begin
  if DocDate <> Value then
  begin
    Self[SF_Doc_Date].Value := Value;
    Modified := True;
    UpdateYearNumber;
  end;
end;

procedure TKisOfficeDoc.UpdateYearNumber;
var
  d: TDateTime;
  S: String;
begin
  S := '';
  if DocNumber <> '' then
    S := DocNumber;
  S := S + '/';
  if TryStrToDate(DocDate, d) then
    S := S + IntToStr(YearOf(d));
  Self[SF_YEAR_NUMBER].Value := S;
end;

function TKisOfficeDoc.GetDocDate: String;
begin
  Result := Self[SF_DOC_DATE].Value;
end;

procedure TKisOfficeDoc.SetObjectType(const Value: String);
begin
  if FObjectType <> Value then
  begin
    FObjectType := Value;
    Modified := True;
  end;
end;

procedure TKisOfficeDoc.PhasesAfterInsert(DataSet: TDataSet);
begin
  Phases.FieldByName(SF_BEGIN_DATE).AsDateTime := Date;
  Phases.FieldByName(SF_EXECUTOR_ID).AsInteger := TOfficeDocExecutorCtrlr(FExecutorsCtrlr).GetCurrentExecutorId;
  with TKisOfficeDocEditor(EntityEditor) do
  begin
    dbgPhases.Columns[0].PickList := AppModule.ExecutionPhaseList(Self.OfficesId);
//    Phases.FieldByName(SF_EXECUTOR_ID).AsInteger := AppModule.ExecutionPhaseList(Self.OfficesId)
  end;
end;

procedure TKisOfficeDoc.SetEndDate(const Value: String);
begin
  if FEndDate <> Value then
  begin
    FEndDate := Value;
    Modified := True;
  end;
end;

{ TKisOfficeDocLetter }

procedure TKisOfficeDocLetter.Copy(Source: TKisEntity);
begin
  inherited;
  Self.LettersId := Source[SF_LETTERS_ID].AsInteger;
  Self.Modified := Modified;
end;

class function TKisOfficeDocLetter.EntityName: String;
begin
  Result := 'Письмо';
end;

function TKisOfficeDocLetter.GetLetterDocDate: String;
begin
  Result := Self[SF_DOC_DATE].AsString;
end;

function TKisOfficeDocLetter.GetLetterDocNumber: String;
begin
  Result := Self[SF_DOC_NUMBER].AsString;
end;

function TKisOfficeDocLetter.GetLetterFirmName: String;
begin
  Result := Self[SF_FIRM_NAME].AsString;
end;

function TKisOfficeDocLetter.GetLetterMPDate: String;
begin
  Result := Self[SF_MP_DATE].AsString;
end;

function TKisOfficeDocLetter.GetLetterMPNumber: String;
begin
  Result := Self[SF_MP_NUMBER].AsString;
end;

function TKisOfficeDocLetter.GetLettersId: Integer;
begin
  Result := Self[SF_LETTERS_ID].AsInteger;
end;

{$IFDEF ENTPARAMS}
procedure TKisOfficeDocLetter.InitParams;
begin
  inherited;
  AddParam(SF_LETTERS_ID);
  AddParam(SF_DOC_NUMBER);
  AddParam(SF_DOC_DATE);
  AddParam(SF_FIRM_NAME);
  AddParam(SF_MP_NUMBER);
  AddParam(SF_MP_DATE);
end;
{$ENDIF}

procedure TKisOfficeDocLetter.Load(DataSet: TDataSet);
begin
  inherited;
  Self.ID := DataSet.FieldByName(SF_ID).AsInteger;
  Self.LettersId := DataSet.FieldByName(SF_LETTERS_ID).AsInteger;
  Self.LetterDocNumber := DataSet.FieldByName(SF_DOC_NUMBER).AsString;
  Self.LetterDocDate := DataSet.FieldByName(SF_DOC_DATE).AsString;
  Self.LetterMPNumber := DataSet.FieldByName(SF_MP_NUMBER).AsString;
  Self.LetterMPDate := DataSet.FieldByName(SF_MP_DATE).AsString;
  Self.LetterFirmName := DataSet.FieldByName(SF_FIRM_NAME).AsString;
  Modified := False;
end;

procedure TKisOfficeDocLetter.SetLetterDocDate(const Value: String);
begin
  if LetterDocDate <> Value then
  begin
    Self[SF_DOC_DATE].Value := Value;
    Modified := True;
  end;
end;

procedure TKisOfficeDocLetter.SetLetterDocNumber(const Value: String);
begin
  if LetterDocNumber <> Value then
  begin
    Self[SF_DOC_NUMBER].Value := Value;
    Modified := True;
  end;
end;

procedure TKisOfficeDocLetter.SetLetterFirmName(const Value: String);
begin
  if LetterFirmName <> Value then
  begin
    Self[SF_FIRM_NAME].Value := Value;
    Modified := True;
  end;
end;

procedure TKisOfficeDocLetter.SetLetterMPDate(const Value: String);
begin
  if LetterMPDate <> Value then
  begin
    Self[SF_MP_DATE].Value := Value;
    Modified := True;
  end;
end;

procedure TKisOfficeDocLetter.SetLetterMPNumber(const Value: String);
begin
  if LetterMPNumber <> Value then
  begin
    Self[SF_MP_NUMBER].Value := Value;
    Modified := True;
  end;
end;

procedure TKisOfficeDocLetter.SetLettersId(const Value: Integer);
begin
  if LettersId <> Value then
  begin
    Self[SF_LETTERS_ID].Value := Value;
    with KisObject(AppModule[kmLetters].GetEntity(Value, keLetter)) do
      if Assigned(AEntity) then
      begin
        LetterDocNumber := AEntity[SF_DOC_NUMBER].AsString;
        LetterDocDate := AEntity[SF_DOC_DATE].AsString;
        LetterMPNumber := AEntity[SF_MP_NUMBER].AsString;
        LetterMPDate := AEntity[SF_MP_DATE].AsString;
        LetterFirmName := AEntity[SF_FIRM_NAME].AsString;
      end
      else
      begin
        LetterDocNumber := '';
        LetterDocDate := '';
        LetterMPNumber := '';
        LetterMPDate := '';
        LetterFirmName := '';
      end;
    Modified := True;
  end;
end;

{ TOfficeDocLetterCtrlr }

procedure TOfficeDocLetterCtrlr.FillFieldDefs(FieldDefsRef: TFieldDefs);
begin
  inherited;
  FieldDefsRef.Clear;
  FieldDefsRef.Add(SF_ID, ftInteger);
  FieldDefsRef.Add(SF_LETTERS_ID, ftInteger);
  FieldDefsRef.Add(SF_OFFICE_DOCS_ID, ftInteger);
  FieldDefsRef.Add(SF_DOC_NUMBER, ftString, 10);
  FieldDefsRef.Add(SF_DOC_DATE, ftString, 10);
  FieldDefsRef.Add(SF_FIRM_NAME, ftString, 120);
  FieldDefsRef.Add(SF_MP_NUMBER, ftString, 10);
  FieldDefsRef.Add(SF_MP_DATE, ftString, 10);
end;

function TOfficeDocLetterCtrlr.GetDeleteQueryText: String;
var
  IDList: String;
  I: Integer;
begin
  Result := 'DELETE FROM OFFICE_DOC_LETTERS WHERE ID IN (%s)';
  IDList := '';
  for I := 0 to Pred(DeletedCount) do
  begin
    if I > 0 then
      IDList := IDList + ',';
    IDList := IDList + IntToStr(DeletedElements[I].ID);
  end;
  Result := Format(Result, [IDList]);
end;

function TOfficeDocPhasesCtrlr.GetDeleteQueryText: String;
var
  IDList: String;
  I: Integer;
begin
  Result := 'DELETE FROM OFFICE_DOC_PHASES WHERE ID IN (%s)';
  IDList := '';
  for I := 0 to Pred(DeletedCount) do
  begin
    if I > 0 then
      IDList := IDList + ',';
    IDList := IDList + IntToStr(DeletedElements[I].ID);
  end;
  Result := Format(Result, [IDList]);
end;

function TOfficeDocExecutorCtrlr.GetDeleteQueryText: String;
var
  IDList: String;
  I: Integer;
begin
  Result := 'DELETE FROM OFFICE_DOC_EXECUTORS WHERE ID IN (%s)';
  IDList := '';
  for I := 0 to Pred(DeletedCount) do
  begin
    if I > 0 then
      IDList := IDList + ',';
    IDList := IDList + IntToStr(DeletedElements[I].ID);
  end;
  Result := Format(Result, [IDList]);
end;

function TOfficeDocLetterCtrlr.GetFieldData(Index: Integer; Field: TField;
  out Data): Boolean;
var
  Ent: TKisOfficeDocLetter;
begin
  try
    Result := True;
    Ent := TKisOfficeDocLetter(Elements[Index]);
    case Field.FieldNo of
    1 : GetInteger(Ent.ID, Data);
    2 : GetInteger(Ent.LettersId, Data);
    3 : GetInteger(Ent.HeadId, Data);
    4 : GetString(Ent[SF_DOC_NUMBER].AsString, Data);
    5 : GetString(Ent[SF_DOC_DATE].AsString, Data);
    6 : GetString(Ent[SF_FIRM_NAME].AsString, Data);
    7 : GetString(Ent[SF_MP_NUMBER].AsString, Data);
    8 : GetString(Ent[SF_MP_DATE].AsString, Data);
    else
      raise EDatabaseError.CreateFmt(S_FIELD_NOT_FOUND, [Field.FullName]);
    end;
  except
    Result := False;
  end;
end;

procedure TOfficeDocLetterCtrlr.SetFieldData(Index: integer; Field: TField;
  var Data);
var
  Ent: TKisOfficeDocLetter;
begin
  Ent := TKisOfficeDocLetter(Elements[Index]);
  case Field.FieldNo of
  1 : Ent.ID := SetInteger(Data);
  2 : Ent.LettersId := SetInteger(Data);
  end;
end;

procedure TKisOfficeDocMngr.acDeleteExecute(Sender: TObject);
begin
  Self.DefaultTransaction := dsOfficeDocs.Transaction;
  inherited;
  Self.DefaultTransaction.CommitRetaining;
  Self.DefaultTransaction := nil;
end;

procedure TKisOfficeDocMngr.acInsertUpdate(Sender: TObject);
begin
//  inherited;
//  if not FIsUpdatedControls then
//  begin
    acInsert.Enabled := Assigned(DataSource.DataSet) and DataSource.DataSet.Active
              and AppModule.User.CanDoAction(maInsert, keOfficeDoc);
//    acInsert.Enabled := acInsert.Enabled and AppModule.User.CanDoAction(maInsert, keOfficeDoc);
//    FIsUpdatedControls := True;
//  end;
end;

procedure TKisOfficeDocMngr.acPrintExecute(Sender: TObject);
var
  I: Integer;
  PopUpMenu: TPopupMenu;
  P: TPoint;
begin
  inherited;
  PopUpMenu := TPopupMenu.Create(Self);
  FillPrintPopupMenu(PopUpMenu);
  if PopUpMenu.Items.Count > 0 then
  begin
    P := Point(0, 0);
    for I := 0 to Pred(FView.ToolBar.ButtonCount) do
      if FView.ToolBar.Buttons[I].Action = Sender then
      begin
        P := FView.ClientToScreen(Point(
            FView.ToolBar.Buttons[I].Left,
            FView.ToolBar.Buttons[I].Top + FView.ToolBar.Buttons[I].Height));
        Break;
      end;
    PopUpMenu.Popup(P.X, P.Y);
  end;
end;

{ TKisOfficeDocExecutor }

procedure TKisOfficeDocExecutor.Copy(Source: TKisEntity);
begin
  inherited;
  with TKisOfficeDocExecutor(Source) do
  begin
    Self.FPeopleId := FPeopleId;
    Self.FPeopleName := FPeopleName;
    Self.FDocDate := FDocDate;
    Self.Modified := Modified;
  end;
end;

class function TKisOfficeDocExecutor.EntityName: String;
begin
  Result := '';
end;

function TKisOfficeDocExecutor.Equals(Entity: TKisEntity): Boolean;
begin
  Result := inherited Equals(Entity);
  if Result then
  with TKisOfficeDocExecutor(Entity) do
    Result := (Self.FPeopleId = FPeopleId) and (Self.FDocDate = FDocdate);
end;

function TKisOfficeDocExecutor.GetPeopleName: String;
begin
  if PeopleId > 0 then
    Result := FPeopleName
  else
    Result := '';
end;

function TKisOfficeDocExecutor.GetText: String;
begin
  Result := '';
end;

procedure TKisOfficeDocExecutor.InitPeopleName;
var
  V: Variant;
begin
  if AppModule.GetFieldValue(nil, ST_PEOPLE, SF_ID, SF_INITIAL_NAME, FPeopleId, V) then
    FPeopleName := V
  else
    FPeopleName := '';
end;

function TKisOfficeDocExecutor.IsEmpty: Boolean;
begin
  Result := (FPeopleId <= 0) and (FDocDate = '');
end;

procedure TKisOfficeDocExecutor.Load(DataSet: TDataSet);
begin
  inherited;
  ID := DataSet.FieldByName(SF_ID).AsInteger;
//  OfficeDocsId := DataSet.FieldByName(SF_OFFICE_DOCS_ID).AsInteger;
  PeopleId := DataSet.FieldByName(SF_PEOPLE_ID).AsInteger;
  DocDate := DataSet.FieldByName(SF_RECEIVE_DATE).AsString;
  Modified := False;
end;

procedure TKisOfficeDocExecutor.SetDocDate(const Value: String);
begin
  if FDocDate <> Value then
  begin
    FDocDate := Value;
    Modified := True;
  end;
end;

procedure TKisOfficeDocExecutor.SetPeopleId(const Value: Integer);
begin
  if FPeopleId <> Value then
  begin
    FPeopleId := Value;
    InitPeopleName;
    Modified := True;
  end;
end;

{ TOfficeDocExecutorCtrlr }

procedure TOfficeDocExecutorCtrlr.FillFieldDefs(FieldDefsRef: TFieldDefs);
begin
//  inherited;
  FieldDefsRef.Clear;
  FieldDefsRef.Add(SF_ID, ftInteger);
  FieldDefsRef.Add(SF_OFFICE_DOCS_ID, ftInteger);
  FieldDefsRef.Add(SF_PEOPLE_ID, ftInteger);
  FieldDefsRef.Add(SF_PEOPLE_NAME, ftString, 78);
  FieldDefsRef.Add(SF_RECEIVE_DATE, ftDate);
end;

function TOfficeDocExecutorCtrlr.GetCurrentExecutorId: Integer;
begin
  if Self.Count = 0 then
    Result := -1
  else
    Result := TKisOfficeDocExecutor(Elements[Count]).PeopleId;
end;

function TOfficeDocExecutorCtrlr.GetFieldData(Index: Integer;
  Field: TField; out Data): Boolean;
var
  Ent: TKisOfficeDocExecutor;
begin
//  inherited;
  try
    Result := True;
    Ent := TKisOfficeDocExecutor(Self.Elements[Index]);
    case Field.FieldNo of
    1 : GetInteger(Ent.ID, Data);
    2 : GetInteger(Ent.HeadId, Data);
    3 : GetInteger(Ent.PeopleId, Data);
    4 : GetString(Ent.PeopleName, Data);
    5 : if Ent.DocDate = '' then
          Result := False
        else
          GetDate(StrToDate(Ent.DocDate), Data);
    else
      raise EDatabaseError.CreateFmt(S_FIELD_NOT_FOUND, [Field.FieldName]);
    end;
  except
    Result := False;
  end;
end;

procedure TOfficeDocExecutorCtrlr.SetFieldData(Index: integer;
  Field: TField; var Data);
var
  Ent: TKisOfficeDocExecutor;
  I: Integer;
begin
//  inherited;
  Ent := TKisOfficeDocExecutor(Self.Elements[Index]);
  case Field.FieldNo of
  1 : Ent.ID := SetInteger(Data);
  2 : ;//Ent.HeadId := SetInteger(Data);
  3 : Ent.PeopleId := SetInteger(Data);
  4 :
      begin
        I := FExecutors.IndexOf(SetString(Data));
        if I >= 0 then
        begin
          Ent.PeopleId := Integer(FExecutors.Objects[I]);
        end;
      end;
  5 : Ent.DocDate := FormatDateTime(S_DATESTR_FORMAT, SetDate(Data));
  else
    raise EDatabaseError.CreateFmt(S_FIELD_NOT_FOUND, [Field.FieldName]);
  end;
end;

{ TKisExecutorSaver }

function TKisOfficeDocExecutorSaver.GetSQL: String;
begin
  Result := SQ_SAVE_OFFICE_DOC_EXECUTOR; 
end;

procedure TKisOfficeDocExecutorSaver.PrepareParams(DataSet: TDataSet);
var
  V: Variant;
begin
  with TKisOfficeDocExecutor(FEntity) do
  begin
    FConnection.SetParam(DataSet, SF_ID, ID);
    FConnection.SetParam(DataSet, SF_OFFICE_DOCS_ID, HeadId);
    FConnection.SetParam(DataSet, SF_PEOPLE_ID, PeopleId);
    if DocDate = '' then
      V := NULL
    else
      V := StrToDate(DocDate);
    FConnection.SetParam(DataSet,SF_RECEIVE_DATE , V);
  end;
end;

procedure TOfficeDocExecutorCtrlr.SetOfficeId(const Value: Integer);
begin
  if FOfficeId <> Value then
  begin
    FOfficeId := Value;
    FreeAndNil(FExecutors);
    FExecutors := AppModule.PeolpeList(Value);
  end;
end;

{ TKisOfficeDocSaver }

function TKisOfficeDocSaver.GetSQL: String;
begin
  Result := SQ_SAVE_OFFICE_DOC;
end;

procedure TKisOfficeDocSaver.InternalSave;
begin
  inherited;
  SaveInfo(FEntity as TKisOfficeDoc);
end;

procedure TKisOfficeDocSaver.SaveInfo(Entity: TKisOfficeDoc);
var
  DataSet: TDataSet;
begin
  DataSet := FConnection.GetDataSet(SQ_SAVE_OFFICE_DOC_INFO);
  FConnection.SetParam(DataSet, SF_INFORMATION, Entity.Information);
  FConnection.SetParam(DataSet, SF_ID, Entity.ID);
  DataSet.Open;
end;

procedure TKisOfficeDocSaver.PrepareParams(DataSet: TDataSet);
begin
  with TKisOfficeDoc(FEntity) do
  begin
    FConnection.SetParam(DataSet, SF_ID, ID);
    FConnection.SetParam(DataSet, SF_DOC_NUMBER, DocNumber);
    FConnection.SetParam(DataSet, SF_DOC_DATE, DocDate);
    if OfficeDocTypesId >= 0 then
      FConnection.SetParam(DataSet, SF_OFFICE_DOC_TYPES_ID, OfficeDocTypesId)
    else
      FConnection.SetParam(DataSet, SF_OFFICE_DOC_TYPES_ID, Null);
    FConnection.SetParam(DataSet, SF_PEOPLE_ID, PeopleId);
    FConnection.SetParam(DataSet, SF_OFFICES_ID, OfficesId);
    FConnection.SetParam(DataSet, SF_OBJECT_ADDRESS, ObjectAddress);
    FConnection.SetParam(DataSet, SF_DECREE_PRJS_ID, ProjectId);
    FConnection.SetParam(DataSet, SF_STATUS, StatusId);
    FConnection.SetParam(DataSet, SF_OBJECT_TYPE, ObjectType);
    FConnection.SetParam(DataSet, SF_END_DATE, EndDate);
  end;
end;

procedure TKisOfficeDocMngr.DataModuleCreate(Sender: TObject);
begin
  inherited;

end;

{ TKisOfficeDocPhase }

procedure TKisOfficeDocPhase.Copy(Source: TKisEntity);
begin
  inherited;
  with TKisOfficeDocPhase(Source) do
  begin
    Self.FExecutorId := FExecutorId;
    Self.FExecutor := FExecutor;
    Self.PhaseName := FPhaseName;
    Self.BeginDate := FBeginDate;
    Self.EndDate := FEndDate;
  end;
end;

class function TKisOfficeDocPhase.EntityName: String;
begin
  Result := 'Этап выполнения заявки отдела';
end;

function TKisOfficeDocPhase.Equals(Entity: TKisEntity): Boolean;
begin
  Result := inherited Equals(Entity);
  if Result then
  with TKisOfficeDocPhase(Entity) do
    Result :=
      (FExecutorId = Self.FExecutorId) and
      (FPhaseName = Self.FPhaseName) and
      (FBeginDate = Self.FBeginDate) and
      (FEndDate = Self.FEndDate);
end;

function TKisOfficeDocPhase.IsEmpty: Boolean;
begin
  Result :=
    (FExecutorId = 0) and
    (FPhaseName = '') and
    (FBeginDate = '') and
    (FEndDate = '');
end;

procedure TKisOfficeDocPhase.Load(DataSet: TDataSet);
begin
  inherited;
  ID := DataSet.FieldByName(SF_ID).AsInteger;
  PhaseName := DataSet.FieldByName(SF_PHASE_NAME).AsString;
  BeginDate := DataSet.FieldByName(SF_BEGIN_DATE).AsString;
  EndDate := DataSet.FieldByName(SF_END_DATE).AsString;
  ExecutorId := DataSet.FieldByName(SF_EXECUTOR_ID).AsInteger;
  Modified := False;
end;

procedure TKisOfficeDocPhase.SetBeginDate(const Value: String);
begin
  if FBeginDate <> Value then
  begin
    FBeginDate := Value;
    Modified := True;
  end;
end;

procedure TKisOfficeDocPhase.SetEndDate(const Value: String);
begin
  if FEndDate <> Value then
  begin
    FEndDate := Value;
    Modified := True;
  end;
end;

procedure TKisOfficeDocPhase.SetExecutorId(const Value: Integer);
var
  aExecutor: TKisEntity;
begin
  if FExecutorId <> Value then
  begin
    FExecutorId := Value;
    aExecutor := AppModule.Mngrs[kmPeople].GetEntity(FExecutorId);
    if Assigned(aExecutor) then
      FExecutor := TKisWorker(aExecutor).InitialName
    else
      FExecutor := '';
    Modified := True;
  end;
end;

procedure TKisOfficeDocPhase.SetPhaseName(const Value: String);
begin
  if FPhaseName <> Value then
  begin
    FPhaseName := Value;
    Modified := True;
  end;
end;

{ TKisOfficeDocPhaseSaver }

function TKisOfficeDocPhaseSaver.GetSQL: String;
begin
  Result := SQ_SAVE_OFFICE_DOC_PHASE;
end;

procedure TKisOfficeDocPhaseSaver.PrepareParams(DataSet: TDataSet);
begin
  inherited;
  // :ID, :OFFICE_DOCS_ID, :PHASE_NAME, :BEGIN_DATE, :END_DATE, :EXECUTOR_ID
  with TkisOfficeDocPhase(FEntity) do
  begin
    FConnection.SetParam(DataSet, SF_ID, ID);
    FConnection.SetParam(DataSet, SF_OFFICE_DOCS_ID, HeadId);
    FConnection.SetParam(DataSet, SF_PHASE_NAME, PhaseName);
    FConnection.SetParam(DataSet, SF_BEGIN_DATE, BeginDate);
    FConnection.SetParam(DataSet, SF_END_DATE, EndDate);
    FConnection.SetParam(DataSet, SF_EXECUTOR_ID, ExecutorId);
  end;
end;

{ TOfficeDocPhasesCtrlr }

procedure TOfficeDocPhasesCtrlr.FillFieldDefs(FieldDefsRef: TFieldDefs);
begin
  FieldDefsRef.Clear;
  FieldDefsRef.Add(SF_ID, ftInteger);
  FieldDefsRef.Add(SF_OFFICE_DOCS_ID, ftInteger);
  FieldDefsRef.Add(SF_PHASE_NAME, ftString, 300);
  FieldDefsRef.Add(SF_BEGIN_DATE, ftDate);
  FieldDefsRef.Add(SF_END_DATE, ftDate);
  FieldDefsRef.Add(SF_EXECUTOR_ID, ftInteger);
  FieldDefsRef.Add(SF_EXECUTOR, ftString, 78);
end;

function TOfficeDocPhasesCtrlr.GetFieldData(Index: Integer; Field: TField;
  out Data): Boolean;
var
  Ent: TKisOfficeDocPhase;
  d: TDateTime;
begin
  try
    Result := True;
    Ent := TKisOfficeDocPhase(Elements[Index]);
    case Field.FieldNo of
    1 : GetInteger(Ent.ID, Data);
    2 : GetInteger(Ent.HeadId, Data);
    3 : GetString(Ent.PhaseName, Data);
    4 : if TryStrToDate(Ent.BeginDate, d) then
          GetDate(d, Data)
        else
          Result := False;
    5 : if TryStrToDate(Ent.EndDate, d) then
          GetDate(d, Data)
        else
          Result := False;
    6 : GetInteger(Ent.ExecutorId, Data);
    7 : GetString(Ent.Executor, Data);
    else
      raise EDatabaseError.CreateFmt(S_FIELD_NOT_FOUND, [Field.FullName]);
    end;
  except
    Result := False;
  end;
end;

function TOfficeDocPhasesCtrlr.GetLastPhase: TkisOfficeDocPhase;
begin
  if Count = 0 then
    Result := nil
  else
    Result := TKisOfficeDocPhase(Elements[Count]);
end;

procedure TOfficeDocPhasesCtrlr.SetFieldData(Index: Integer; Field: TField;
  var Data);
var
  Ent: TKisOfficeDocPhase;
  I: Integer;
begin
  try
    if Pointer(Data) = nil then
      Exit;
  except
    Exit;
  end;
  Ent := TKisOfficeDocPhase(Elements[Index]);
  case Field.FieldNo of
  1 : Ent.ID := SetInteger(Data);
  2 : ;
  3 : {Ent.PhaseName := SetString(Data);}
      begin
        I := AppModule.ExecutionPhaseList(TKisOfficeDoc(HeadEntity).OfficesId).IndexOf(SetString(Data));
        if I >= 0 then
        begin
          Ent.PhaseName := SetString(Data);
        end;
      end;
  4 : Ent.BeginDate := DateToStr(SetDate(Data));
  5 : Ent.EndDate := DateToStr(SetDate(Data));
  6 : Ent.ExecutorId := SetInteger(Data);
  end;
end;

{ TOfficeDocOrdersCtrlr }

procedure TOfficeDocOrdersCtrlr.FillFieldDefs(FieldDefsRef: TFieldDefs);
begin
  inherited;
  FieldDefsRef.Add(SF_ID, ftInteger);
  FieldDefsRef.Add(SF_OFFICE_DOCS_ID, ftInteger);
  FieldDefsRef.Add(SF_ORDER_NUMBER, ftString, 10);
  FieldDefsRef.Add(SF_ORDER_DATE, ftDate);
  FieldDefsRef.Add(SF_DOC_NUMBER, ftString, 10);
  FieldDefsRef.Add(SF_DOC_DATE, ftDate);
//  FieldDefsRef.Add(SF_ACT_NUMBER, ftString, 10);
  FieldDefsRef.Add(SF_ACT_DATE, ftDate);
  FieldDefsRef.Add(SF_EXECUTOR, ftString, 120);
end;

function TOfficeDocOrdersCtrlr.GetDeleteQueryText: String;
var
  IDList: String;
  I: Integer;
begin
  Result := 'DELETE FROM ORDERS WHERE ID IN (%s)';
  IDList := '';
  for I := 0 to Pred(DeletedCount) do
  begin
    if I > 0 then
      IDList := IDList + ',';
    IDList := IDList + IntToStr(DeletedElements[I].ID);
  end;
  Result := Format(Result, [IDList]);
end;

function TOfficeDocOrdersCtrlr.GetFieldData(Index: Integer; Field: TField;
  out Data): Boolean;
var
  Ent: TKisOrder;
  d: TDateTime;
begin
  try
    Result := True;
    Ent := TKisOrder(Elements[Index]);
    case Field.FieldNo of
    1 : GetInteger(Ent.ID, Data);
    2 : GetInteger(Ent.HeadId, Data);
    3 : GetString(Ent.OrderNumber, Data);
    4 : if TryStrToDate(Ent.OrderDate, d) then
          GetDate(d, Data)
        else
          Result := False;
    5 : GetString(Ent.DocNumber, Data);
    6 : if TryStrToDate(Ent.DocDate, d) then
          GetDate(d, Data)
        else
          Result := False;
    7 : if TryStrToDate(Ent.ActDate, d) then
          GetDate(d, Data)
        else
          Result := False;
    8 : GetString(Ent.Executor, Data);
    else
      Result := False;
    end;
  except
    Result := False;
  end;
end;

procedure TOfficeDocOrdersCtrlr.SetFieldData(Index: integer; Field: TField;
  var Data);
var
  Ent: TKisOrder;
begin
  Ent := TKisOrder(Elements[Index]);
  case Field.FieldNo of
  1 : Ent.ID := SetInteger(Data);
  end;
end;

procedure TKisOfficeDocMngr.acFindDocByOrderExecute(Sender: TObject);
var
  NumOrder: String;
  VAL: Variant;
  idDoc: Integer;
  Conn: IKisConnection;
  i: Integer;
  whereSTR, clauseSTR: String;
  Clause: TSQLClause;
  searchSTR: String;
begin
  NumOrder := '';
  NumOrder := InputBox('Поиск заявки по номеру заказа', 'Введите точный номер заказа', '');
  if NumOrder <> '' then begin
    Conn := GetConnection(True, False);
    try
      searchSTR := 'SELECT OFFICE_DOCS_ID FROM ORDERS WHERE ORDER_NUMBER = '''+NumOrder+'''';
      with Conn.GetDataSet(searchSTR) do begin
        Open;
        if not IsEmpty then begin
          i := 0;
          whereSTR := '';
          while not Eof do begin
            VAL := Fields[N_ZERO].Value;
            if VAL <> Null then begin
              idDoc := VAL;
              if i = 0 then
                whereSTR := IntToStr(idDoc)
              else
                whereSTR := whereSTR + ', ' + IntToStr(idDoc);
              i := i + 1;
            end;
            Next;
          end;
          if whereSTR <> '' then begin
            clauseSTR := '(A.ID IN ('+whereSTR+'))';
            with FSQLHelper.Parser do
            begin
              Clause := Clauses[sqlWhere];
              if (Clause.PartCount > 0) then
                clauseSTR := 'AND ' + clauseSTR;
              Clause.AddPart(clauseSTR);
            end;
            FInSearch := True;
            ReOpen;
          end
          else
            Application.MessageBox(PChar('Заказ с номером ' + NumOrder + ' не входит ни в одну заявку'),
              PChar(S_WARN),
              MB_OK + MB_ICONWARNING);
        end
        else
          Application.MessageBox(PChar('Заказ с номером ' + NumOrder + ' не найден'),
            PChar(S_WARN),
            MB_OK + MB_ICONWARNING);
      end;
    finally
      FreeConnection(Conn, True);
    end;
  end;
end;

end.
