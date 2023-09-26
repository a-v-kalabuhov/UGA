{*******************************************************}
{                                                       }
{       "ИС МП УГА"                                     }
{       Базовые SQL классы системы                      }
{                                                       }
{       Copyright (c) 2003-2005, МП УГА                 }
{                                                       }
{       Автор: Калабухов А.В.                           }
{                                                       }
{*******************************************************}

{ Описание:
  Имя модуля: Kernel SQL Classes
  Версия: 1.27
  Дата последнего изменения: 14.05.2005
  Цель: содержит классы, обеспечивающие работу системы с SQL-серверами .
  Используется:
  Использует:   CustomDataSet, IBX Utilities, SQL Parsers,
  Исключения:   }
{
  1.27           14.05.2005
     - добавлен класс  TKisEntitySaver
     - изменен класс TKisConnection и добавлены классы TKisDataSet и TDataSetList

  1.26           04.05.2005
     - классу TKisConnection добавлен метод GetDataSet
     - изменен класс TKisUser

  1.25           25.04.2005
     - добавлен интерфейс IKisConnection

  1.24           22.04.2005
     - менеджеру добавлены методы:
         GetRefreshSQLText
         GetMainDataSet и свойство MainDataSet
         MainDataSetBeforeOpen
         MainDataSetAfterOpen
         MainDataSetBeforeClose
         PrepareMaindataSet
       изменен метод Create  
         
  1.23           21.03.2005
     - добавлен класс TKisSQLEntity 
     - добавлены методы управления дефолтными транзакциями для других менеджеров
       SetTransactionToMngr и FreeTransatcionFromMngr
  1.22
     - добавлен класс TKisConnection
     - у класса TKisSQLMngr добавлены методы для работы с новым классом
       GetConnection и FreeConnection
  1.21
     - изменена реализация метода Reopen
     - в методе SetInSearch вместо деактивации и активации модуля используется Reopen
}

unit uKisSQLClasses;

{$I KisFlags.pas}

interface

uses
  // System
  SysUtils, Classes, DB, ImgList, Controls, ActnList, IBDatabase, Variants,
  IBHeader, IBSQL, IBQuery, ComCtrls, Menus, StdCtrls, IBCustomDataSet, Buttons,
  Forms, Contnrs, Windows, Grids,
  // Common
  uSQLParsers, uDataSet, uGC, uIBXUtils, uVCLUtils, uCommonUtils,
  // Project
  uKisMngrView, uKisEntityEditor, uKisSearchDialog, uKisClasses, uKisFilters,
  uKisSearchClasses, uKisConsts, uKisSortDialog, uKisUtils, uKisExceptions;


type
  EEntityNotEditable = class(Exception);

  {
    Значение - способ оторваться от вариантов
  }
  TValue = class
    FType: TFieldType;
    FString: String;
    FInteger: Integer;
    FDouble: Double;
    FDateTime: TDateTime;
    FBoolean: Boolean;
  public
    procedure SetValue(AType: TFieldType; const AValue: Variant);
    function GetValue: Variant;
    function GetValueStr: String;
    procedure Clear;
  end;

  {
    Условия поиска (точнее фильтрации) данных в SQL-запросе
  }
  TKisSearchConditions = class
  private
    FValue1: TValue;          // для диапазонов - верхняя граница
    FValue2: TValue;          // для значения - собственно значение
    FIsRange: Boolean;
    FCaseSencitive: Boolean;
    FExact: Boolean;
    FEmpty: Boolean;
    function GetTop: Variant;
    procedure SetTop(const Value: Variant);
    function GetBottom: Variant;
    procedure SetBottom(const Value: Variant);
    function GetValue: Variant;
    procedure SetValue(const Value: Variant);
  public
    // поле, на которое налагаются условия
    Field: TKisField;
    property Value: Variant read GetValue write SetValue;
    // признак диапазона или значения
    property IsRange: Boolean read FIsRange write FIsRange;
    property Top: Variant read GetTop write SetTop;
    property Bottom: Variant read GetBottom write SetBottom;
    // для строк - признак условия с учетом регистра символов
    property CaseSencitive: Boolean read FCaseSencitive write FCaseSencitive;
    property Empty: Boolean read FEmpty write FEmpty;
    // для строк - признак поиска точного соответствия
    property Exact: Boolean read FExact write FExact;
    constructor Create;
    destructor Destroy; override;
    procedure Clear;
    function GetConditionString: String;
  end;

  /// <summary>
  ///   Клаcс для упрощения работы с SQL-запросами.
  ///   Парсит текст запроса, показывает диалоги пользователю.
  /// </summary>
  TKisSQLHelper = class(TComponent)
  private
    FTables: TList;
    FSearchDialog: TKisSearchDialog;
    FParser: TSelectSQLParser;
    FSearchConditions: TKisSearchConditions;
    function GetTables(Index: Integer): TKisTable;
    procedure FillSearchFields(Sender: TObject);
    procedure CheckSearchField(Sender: TObject);
    function GetSQL: String;
    procedure SetSQL(const Value: String);
    function GetOrderByStr: String;
    procedure SetOrderByStr(const Value: String);
    procedure ModifySQLWhereClause;
    procedure SetSearchConditions(const Value: TKisSearchConditions);
    function GetWhereStr: String;
    procedure SetWhereStr(const Value: String);
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    // Диалоги
    function SearchDialog: Boolean;
    function SortDialog: Boolean;
    // Организация структуры запроса
    function AddTable: TKisTable;
    function AddLinkedTable: TKisLinkedTable;
    procedure ClearTables;
    function TableCount: Integer;
    property Tables[Index: Integer]: TKisTable read GetTables;
    function TableByName(const TableName: String): TKisTable;
    // Текст запроса
    property SQL: String read GetSQL write SetSQL;
    property OrderByStr: String read GetOrderByStr write SetOrderByStr;
    property WhereStr: String read GetWhereStr write SetWhereStr;
    property Parser: TSelectSQLParser read FParser;
  end;

  TKisSQLMngr = class;

  TKisMngrViewMode = (vmNone, vmSelect, vmShowList);

  /// <summary>
  /// Стек транзакций. Последний вошел - первый вышел.
  /// </summary>
  TKisTransactionStack = class(TComponent)
  private
    FList: TList;
    function GetTransaction: TIBTransaction;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    property Transaction: TIBTransaction read GetTransaction;
    procedure Pop;
    procedure Push(ATransaction: TIBTransaction);
  end;

  TKisConnectionNeedParam = procedure (const ParamName: String; var ParamValue: Variant) of object;

  TKisDataSet = class
  private
    FDataSet: TDataSet;
    FParamHandler: TKisConnectionNeedParam;
  public
    constructor Create(ADataSet: TDataSet);
    destructor Destroy; override;
    property DataSet: TDataSet read FDataSet;
    property ParamHandler: TKisConnectionNeedParam read FParamHandler write FParamHandler;
  end;

  TDataSetList = class(TObjectList)
  protected
    function GetItem(Index: Integer): TKisDataSet;
    procedure SetItem(Index: Integer; DataSet: TKisDataSet);
  public
    property Items[Index: Integer]: TKisDataSet read GetItem write SetItem; default;
    function IndexOfDataSet(DataSet: TDataSet): Integer;
  end;

  IKisConnection = interface
    ['{AE3E1082-3D12-4FE6-BCDB-DD6B247A2DD2}']
{$REGION 'Доступ к свойствам'}
    function GetOnNeedParam(DataSet: TDataSet): TKisConnectionNeedParam;
    procedure SetOnNeedParam(DataSet: TDataSet; const Value: TKisConnectionNeedParam);
{$ENDREGION}
    function GetDataSet(const SQLText: String): TDataSet;
    function GetParam(DataSet: TDataSet; const ParamName: String): TParam;
    procedure Commit(StayActive: Boolean);
    procedure Rollback(StayActive: Boolean);
    procedure SetParam(DataSet: TDataSet; const ParamName: String; const Value: Variant);
    procedure SetBlobParam(DataSet: TDataSet; const ParamName: String; Stream: TStream);
    procedure PrepareDataSet(DataSet: TDataSet);
    procedure UnPrepareDataSet(DataSet: TDataSet);
    function Transaction: TIBTransaction;
    function NeedCommit: Boolean;
    function NeedBack: Boolean;
    property OnNeedParam[DataSet: TDataSet]: TKisConnectionNeedParam read GetOnNeedParam write SetOnNeedParam;
  end;

  /// <summary>
  ///   Класс для сохранения сущности в БД
  /// </summary>
  TKisEntitySaver = class
  protected
    FConnection: IKisConnection;
    FEntity: TKisEntity;
    procedure InternalSave; virtual;
    procedure PrepareParams(DataSet: TDataSet); virtual;
    function GetSQL: String; virtual; abstract;
  public
    constructor Create(Connection: IKisConnection); virtual;
    procedure Save(Entity: TKisEntity);
  end;

  TKisSearch = class
  private
    FMngr: TKisSQLMngr;
    FConn: IKisConnection;
    FDataSet: TDataSet;
    FSQL: String;
  public
    destructor Destroy; override;
    //
    property DataSet: TDataSet read FDataSet;
    property SQL: String read FSQL write FSQL;
  end;

  TKisFilterOperation = (foAddSQL, foRemoveSQL);

  /// <summary>
  ///  Менеджер для работы с SQL-сервером как хранилищем объектов.
  ///  Дополнительно показывает окно со списком (гридом) объектов и пр.
  /// </summary>
  TKisSQLMngr = class(TKisMngr)
    ActionList: TActionList;
    ImageList: TImageList;
    DataSource: TDataSource;
    acInsert: TAction;
    acDelete: TAction;
    acEdit: TAction;
    acFirst: TAction;
    acPrev: TAction;
    acNext: TAction;
    acLast: TAction;
    acReopen: TAction;
    Action1: TAction;
    Action2: TAction;
    acStartSearch: TAction;
    acStopSearch: TAction;
    acSortOrder: TAction;
    Action3: TAction;
    ActionListNav: TActionList;
    acFirstNav: TAction;
    acLastNav: TAction;
    acPriorNav: TAction;
    acNextNav: TAction;
    procedure acReopenExecute(Sender: TObject);
    procedure acFirstExecute(Sender: TObject);
    procedure acPrevExecute(Sender: TObject);
    procedure acNextExecute(Sender: TObject);
    procedure acLastExecute(Sender: TObject);
    procedure acFirstUpdate(Sender: TObject);
    procedure acPrevUpdate(Sender: TObject);
    procedure acNextUpdate(Sender: TObject);
    procedure acLastUpdate(Sender: TObject);
    procedure acSortOrderExecute(Sender: TObject);
    procedure acStartSearchExecute(Sender: TObject);
    procedure acStopSearchExecute(Sender: TObject);
    procedure acStopSearchUpdate(Sender: TObject);
    procedure acInsertExecute(Sender: TObject);
    procedure acDeleteExecute(Sender: TObject);
    procedure acEditExecute(Sender: TObject); virtual;
    procedure acInsertUpdate(Sender: TObject);
    procedure acDeleteUpdate(Sender: TObject);
    procedure acEditUpdate(Sender: TObject);
    procedure acFirstNavExecute(Sender: TObject);
    procedure acFirstNavUpdate(Sender: TObject);
    procedure acNextNavExecute(Sender: TObject);
    procedure acPriorNavExecute(Sender: TObject);
    procedure acLastNavExecute(Sender: TObject);
    procedure acPriorNavUpdate(Sender: TObject);
    procedure acNextNavUpdate(Sender: TObject);
    procedure acLastNavUpdate(Sender: TObject);
  strict private type
    /// <summary>
    /// Класс представляет соединение с БД + средства для исполнения запросов
    /// </summary>
    TKisIBConnection = class(TComponent, IKisConnection)
    private
      FNeedCommit: Boolean;
      FTransaction: TIBTransaction;
      FNeedBack: Boolean;
      FDataSets: TDataSetList;
      procedure OpenDataSet(DataSet: TDataSet);
      procedure SetOnNeedParam(DataSet: TDataSet; const Value: TKisConnectionNeedParam);
      function GetOnNeedParam(DataSet: TDataSet): TKisConnectionNeedParam;
    protected
      procedure Notification(AComponent: TComponent;
        Operation: TOperation); override;
      procedure Commit(StayActive: Boolean);
      procedure RollBack(StayActive: Boolean);
    public
      constructor Create(AOwner: TComponent); override;
      constructor CreateConnection(AOwner: TComponent; Trans: TIBTransaction; aNeedCommit, aNeedBack: Boolean);
      destructor Destroy; override;
      // Создает ДатаСет, при уничтожении он тоже уничтожается
      function GetDataSet(const SQLText: String): TDataSet;
      function  GetParam(DataSet: TDataSet; const ParamName: String): TParam;
      procedure SetParam(DataSet: TDataSet; const ParamName: String; const Value: Variant);
      procedure SetBlobParam(DataSet: TDataSet; const ParamName: String; Stream: TStream);
      procedure PrepareDataSet(DataSet: TDataSet);
      procedure UnPrepareDataSet(DataSet: TDataSet);
      function Transaction: TIBTransaction;
      function NeedCommit: Boolean;
      function NeedBack: Boolean;
    end;
  private
    FSelFieldName: String;
    FActive: Boolean;
    FTransactionStack: TKisTransactionStack;
    FErrorInConnection: Boolean;
    procedure SetActive(const Value: Boolean);
    function GetDefaultTransaction: TIBTransaction;
    procedure SetDefaultTransaction(const Value: TIBTransaction);
    procedure edFilterEnterPress(Sender: TObject; var Key: Char);
    procedure PrepareMainDataSet;
  protected
    FInSearch: Boolean;
    FView: TKisMngrView;
    FViewMode: TKisMngrViewMode;
    FSQLHelper: TKisSQLHelper;
    FX, FY: Integer;
    FFilters: IKisFilters;
    // Работа с окном
    procedure CreateView; virtual;
    procedure CloseView(Sender: TObject; var Action: TCloseAction); virtual;
    procedure ViewGridDblClick(Sender: TObject); virtual;
    procedure ViewGridMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    //
    procedure Activate; virtual;
    procedure Deactivate; virtual;
    procedure Reopen; virtual;
    procedure ReadViewState; virtual;
    procedure WriteViewState; virtual;
    procedure ReadOrderState(Helper: TKisSQLHelper; ParamName: String = 'SortOrder'); virtual;
    procedure WriteOrderState(Helper: TKisSQLHelper; ParamName: String = 'SortOrder'); virtual;
    procedure PrepareSQLHelper; virtual;
    // Обвязка главного датасета
    function GetMainSQLText: String; virtual; abstract;
    function GetRefreshSQLText: String; virtual; abstract;
    function GetMainDataSet: TDataSet; virtual; abstract;
    procedure MainDataSetAfterOpen(DataSet: TDataSet); virtual;
    procedure MainDataSetBeforeClose(DataSet: TDataSet); virtual;
    procedure MainDataSetBeforeOpen(DataSet: TDataSet); virtual;
    // Работа с фильтрами и поиском
    procedure ApplyFilters(aFilters: IKisFilters; ClearExisting: Boolean); virtual;
    procedure CancelFilters(aFilters: IKisFilters); virtual;
    /// <summary>
    /// Этот метод должен добавить в WHERE условия из фильтров.
    /// </summary>
    /// <remarks>
    /// Бывают ситуации, когда необходимо заново сгенерировать SQL запрос для главного датасета.
    /// Генерация запроса выглядит так:
    ///  - добавляем SELECT, т.е. MainSQLText;
    ///  - добавляем WHERE по применённым фильтрам;
    ///  - добавляем ORDER BY из ini файла.
    /// Данный метод по сути должен вызвать ApplyFilters.
    /// Но в нём происходит Reopen.
    ///  </remarks>
    procedure RestoreFilters; virtual;
    /// <summary>
    ///  Добавляет условия от фильтров в главный SQL запрос.
    /// </summary>
    procedure AddFiltersSQL; virtual;
    /// <summary>
    ///  Удаляет условия от фильтров из главного SQL запроса.
    /// </summary>
    procedure RemoveFiltersSQL; virtual;

    function ProcessSQLFilter(aFilter: IKisFilter;
      TheOperation: TKisFilterOperation; Clause: TWhereClause): Boolean; virtual;
    //
    procedure SetInSearch(const Value: Boolean); virtual;
    procedure Locate(AId: Integer; LocateFail: Boolean = False); virtual;
    procedure ReadLastSearch(LastSearch: TKisSearchConditions);
    procedure SaveLastSearch(SearchCond: TKisSearchConditions);
    // Навигация
    procedure DoUserSearch(const Str: String; Field: TField); virtual;
    procedure OnColEnter(Sender: TObject);
    // Фильтрация
    procedure OnSetFilter(Sender: TObject);
    procedure FillFilterFields;
    procedure OnFilterRecord(DataSet: TDataSet; var Accept: Boolean);
    procedure OnFilterTextChange(Sender: TObject);
    // Служебные
    function GetConnection(const Read, Write: Boolean; NewTransaction: Boolean = False): IKisConnection;
    procedure FreeConnection(Connection: IKisConnection;
      Correct: Boolean; StayActive: Boolean = False);
    // Управление дефолтными транзакциями для других менеджеров
    procedure CheckDefaultTransaction;
    procedure SetTransactionToMngr(AMngr: TKisSQLMngr);
    procedure FreeTransactionFromMngr(AMngr: TKisSQLMngr);
    procedure IntShowEntities(aFilters: IKisFilters = nil; StartID: Integer = -1); virtual;
    //
    procedure SafeReopen(aDataSet: TDataSet; const KeyField: string = '');
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    { Текущая сущность в списке }
    function CurrentEntity: TKisEntity; virtual; abstract;
    { Редактирование свойств текущего экземпляра }
    procedure EditCurrent; virtual;
    { Удаление текущего экземпляра }
    procedure DeleteCurrent; virtual;
    { Создание нового экземпляра и заполнение его свойств из Entity }
    function DuplicateCurrent: TKisEntity; virtual;
    { Возвращает датасет с заданным SQL }
    procedure LookFor(Search: TKisSearch); virtual;
    /// <summary>
    /// Выбор сущности пользователем - показывается окно со таблицей и кнопками ОК/Отмена.
    /// </summary>
    function SelectEntity(NewView: Boolean = False; aFilters: IKisFilters = nil;
      ClearExistingFilters: Boolean = True;
      StartID: Integer = -1): TKisEntity; virtual;
    /// <summary>
    ///   Показывает окно для работы со справочником сущностей.
    /// </summary>
    procedure ShowEntities(aFilters: IKisFilters = nil; StartID: Integer = -1);
    //
    function CreateNewConnection(AOwner: TComponent;
      aTransaction: TIBTransaction; aNeedCommit, aNeedBack: Boolean): IKisConnection;
    // загрузка сущностей из БД
    procedure LoadController(const SQLText: String; const Id: Integer;
      EntKind: TKisEntities; aCtrlr: TKisEntityController);
    //
    property Active: Boolean read FActive write SetActive;
    property InSearch: Boolean read FInSearch write SetInSearch;
    property DefaultTransaction: TIBTransaction read GetDefaultTransaction write SetDefaultTransaction;
    property MainDataSet: TDataSet read GetMainDataSet;
  end;

  TKisSQLEntity = class(TKisVisualEntity)
  private
    function GetSQLMngr: TKisSQLMngr;
  public
    property SQLMngr: TKisSQLMngr read GetSQLMngr;
  end;

  TKisEntityActions = (eaGetEntity, eaCreateNew, eaSelect, eaSave, eaDelete);
  TKisMngrAction = (maInsert, maEdit, maDelete);

  {
    Класс описывает текущего пользователя БД и системы.
  }
  TKisUser = class
  private
    FTransaction: TIBTransaction;
    FDatabase: TIBDatabase;
    FName: String;
    FRoleName: String;
    FRoleID: Integer;
    FOrgId: Integer;
    FOrgName: String;
    FOfficeID: Integer;
    FOfficeName: String;
    FPeopleId: Integer;
    FShortName: String;
    FFullName: String;
    FPost: String;
    FPrintWorksValue: Boolean;
    FCanSheduleWorks: Boolean;
    FAllowAllOffices: Boolean;
    FPeopleTypeId: Integer;
    FCanManageKiosks: Boolean;
    FCanManageOrders: Boolean;
    function GetFullName: String;
    function GetPassword: String;
    function GetRoleName: String;
    procedure InitRoleID;
    function GetOfficeName: String;
    function GetOrgName: String;
    function GetPost: String;
    function CheckMaxAccountNumber(CheckOldAccounts: Boolean): Integer;
    procedure SetPeopleId(const Value: Integer);
    procedure Initialize;
    function GetInfo: String;
  public
    constructor Create(Database: TIBDatabase);
    destructor Destroy; override;
    //
    function AllowAllOffices(const MngrId: TKisMngrs): Boolean;
    function CanDoAction(Action: TKisMngrAction; ObjectType: TKisEntities): Boolean;
    function IsAdministrator: Boolean;
    // Работа с номерами докуменов
    function AccountNumberExists(const Number: String; Year: Integer): Boolean;
    function AddressActNumberExists(const Number: String; const Year: Word): Boolean;
    function AddressOrderNumberExists(const Number: String; const Year: Word): Boolean;
    function DecreeProjectSeqNumberExists(const Number: String; const Year: Integer): Boolean;
    function GenerateDecreeProjectSeqNumber: String;
    function GenerateNewAddressActNumber: String;
    function GenerateNewAddressOrderNumber: String;
    function GenerateNewAccountNumber: String;
    function GenerateNewLetterNumber(const DocTypeId: Integer): String;
    function GenerateNewOfficeDocNumber: Integer;
    function GenerateOutcomingLetterSeqNumber: String;
    function LetterNumberExists(const Number: String; const DocTypeId, Year: Integer): Boolean;
    function OfficeDocNumberExists(Number: Integer; Year: Integer): Boolean;
    function OutcomingLetterSeqNumberExists(const Number: String; const Year: Integer): Boolean;
    /// <summary>
    ///   Генерирует полный номер письма из частичного номера,
    ///   используя маску типа документа.
    /// </summary>
    function CheckLetterNumber(const OrgId, DocTypeId: Integer;
      const NumberText: String; var WellFormedNumber: String): Boolean;
    function GetDocTypeMask(const OrgId, DocTypeId: Integer): String;
    //
    property CanSeeAllOffices: Boolean read FAllowAllOffices;
    property CanSheduleWorks: Boolean read FCanSheduleWorks;
    property CanManageKiosks: Boolean read FCanManageKiosks;
    property CanManageOrders: Boolean read FCanManageOrders;
    property Database: TIBDatabase read FDatabase;
    property UserName: String read FName;
    property Password: String read GetPassword;
    property RoleName: String read FRoleName;
    property RoleID: Integer read FRoleID;
    property OrgId: Integer read FOrgId;
    property OrgName: String read GetOrgName;
    property OfficeID: Integer read FOfficeID;
    property OfficeName: String read GetOfficeName;
    property PeopleId: Integer read FPeopleId write SetPeopleId;
    property PeopleTypeId: Integer read FPeopleTypeId;
    property ShortName: String read fShortName;
    property FullName: String read GetFullName;
    property Post: String read GetPost;
    property PrintWorksValue: Boolean read FPrintWorksValue;

    property Info: String read GetInfo;
  end;

implementation

uses
  uKisIntf, uKisAppModule;

{$R *.dfm}

resourcestring
  SQ_SELECT_USER_PARAMS = 'SELECT * FROM PEOPLE WHERE ID=%d';
  SQ_CHECK_OFFICE_DOC_NUMBER =
      'SELECT ID FROM OFFICE_DOCS WHERE EXTRACT(YEAR FROM DOC_DATE)=:DOC_YEAR AND DOC_NUMBER=:DOC_NUMBER '
     +'AND (OFFICES_ID=%d)';
//      'SELECT ID FROM OFFICE_DOCS WHERE EXTRACT(YEAR FROM DOC_DATE)=:DOC_YEAR AND DOC_NUMBER=:DOC_NUMBER';
  SQ_SELECT_OFFICENAME = 'SELECT NAME FROM OFFICES WHERE ID=%d';
  SQ_SELECT_PRINT_WORKS_VALUE = 'SELECT PRINT_WORKS_VALUE FROM OFFICES WHERE ID=%d';
  SQ_SELECT_ORGNAME = 'SELECT NAME FROM ORGS WHERE ID=%d';
  SQ_LAST_LETTER_DOC_NUMBER = 'SELECT DOC_NUMBER FROM LETTERS'
    + ' WHERE ID=(SELECT MAX(ID) FROM LETTERS WHERE ORGS_ID=%d AND DOC_TYPES_ID=%d)';
  SQ_LAST_LETTER_MP_NUMBER = 'SELECT MP_NUMBER FROM LETTERS'
    + ' WHERE ID=(SELECT MAX(ID) FROM LETTERS WHERE ORGS_ID=%d AND DOC_TYPES_ID=%d)';
  SQ_GET_DOC_NUMBER_MASK = 'SELECT NUMBER_MASK FROM DOC_TYPES WHERE ORGS_ID=%d AND ID=%d';
  SQ_CHECK_LETTER_DOC_NUMBER =
      'SELECT ID FROM LETTERS '
    + 'WHERE '
    + 'DOC_NUMBER=:DOC_NUMBER '
    + 'AND DOC_TYPES_ID=:DOC_TYPES_ID '
    + 'AND EXTRACT(YEAR FROM DOC_DATE)=:AYEAR';
  SQ_CHECK_LETTER_MP_NUMBER =
      'SELECT ID FROM LETTERS '
    + 'WHERE MP_NUMBER=:DOC_NUMBER '
    + 'AND DOC_TYPES_ID=:DOC_TYPES_ID '
    + 'AND EXTRACT(YEAR FROM MP_DATE)=:AYEAR';
  SQ_CHECK_ACCOUNT_NUMBER_EXISTS =
      'SELECT ID FROM ACCOUNTS '
    + 'WHERE ORDER_NUMBER=:NUMBER AND OFFICES_ID=:AOFFICES_ID '
    + '  AND EXTRACT(YEAR FROM ORDER_DATE)=:AYEAR '
    + 'UNION '
    + 'SELECT ID FROM ORDERS '
    + 'WHERE ORDER_NUMBER=:NUMBER AND OFFICES_ID=:AOFFICES_ID '
    + '  AND EXTRACT(YEAR FROM ORDER_DATE)=:AYEAR';   

  SQ_GEN_NEW_OFFICE_DOC_NUMBER = 'SELECT DOC_NUMBER FROM OFFICE_DOCS '
    + 'WHERE ID=(SELECT MAX(ID) FROM OFFICE_DOCS '
    + 'WHERE OFFICES_ID=%d AND EXTRACT(YEAR FROM DOC_DATE)=EXTRACT(YEAR FROM CURRENT_DATE))';
  SQ_GEN_ACCOUNT_NUMBER = 'SELECT ORDER_NUMBER FROM %s '
    + 'WHERE ID=('
    + 'SELECT MAX(ID) '
    + 'FROM %s '
    + 'WHERE OFFICES_ID=:OFFICES_ID AND EXTRACT(YEAR FROM ORDER_DATE)=:AYEAR)';
  SQ_GET_MAX_ADDRESS_ACT_NUMBER = 'SELECT ACT_NUMBER '
    + 'FROM ADDRESSES '
    + 'WHERE ID=('
    + 'SELECT MAX(ID) FROM ADDRESSES'// WHERE EXTRACT(YEAR FROM ORDER_DATE)=:AYEAR'
    + ')';
  SQ_GET_MAX_ADDRESS_ORDER_NUMBER = 'SELECT ORDER_NUMBER FROM ADDRESSES WHERE ID=(SELECT MAX(ID) FROM ADDRESSES)';
  SQ_GET_MAX_OUTCOMLETTER_SEQ_NUMBER = 'SELECT SEQ_NUMBER FROM OUTCOMING_LETTERS WHERE ID=(SELECT MAX(ID) FROM OUTCOMING_LETTERS)';
  SQ_GET_MAX_DECREE_PROJECT_SEQ_NUMBER = 'SELECT SEQ_NUMBER FROM DECREE_PRJS WHERE ID=(SELECT MAX(ID) FROM DECREE_PRJS)';

const
  SQL_SORT_DESC = 'DESC';
  SQL_SORT_ASC = 'ASC';

var
  UserCreated: Boolean = False;

{ TKisUser }

function TKisUser.AccountNumberExists(const Number: String;
  Year: Integer): Boolean;
var
  OldTrans: Boolean;
begin
  OldTrans := FTransaction.Active;
  if not OldTrans then
    FTransaction.StartTransaction;
  try
    with TIBQuery.Create(nil) do
    begin
      Forget;
      BufferChunks := 10;
      Database := Self.Database;
      Transaction := FTransaction;
      SQL.Text := SQ_CHECK_ACCOUNT_NUMBER_EXISTS;
      Params[0].AsString := Number;
      Params[1].AsInteger := Self.OfficeId;
      Params[2].AsInteger := Year;
      Open;
      Result := not IsEmpty;
      Close;
    end;
  finally
    if not OldTrans then
      FTransaction.Commit;
  end;
end;

function TKisUser.AddressActNumberExists(const Number: String; const Year: Word): Boolean;
var
  OldTrans: Boolean;
begin
  OldTrans := FTransaction.Active;
  if not OldTrans then
    FTransaction.StartTransaction;
  try
    with TIBQuery.Create(nil) do
    begin
      Forget;
      BufferChunks := 10;
      Database := Self.Database;
      Transaction := FTransaction;
      SQL.Add('SELECT ID FROM ADDRESSES');
      SQL.Add('WHERE ACT_NUMBER=:NUMBER AND EXTRACT(YEAR FROM ORDER_DATE)=:AYEAR');
      Params[0].AsString := Number;
      Params[1].AsInteger := Year;
      Open;
      Result := not IsEmpty;
      Close;
    end;
  finally
    if not OldTrans then
      FTransaction.Commit;
  end;
end;

function TKisUser.AddressOrderNumberExists(const Number: String; const Year: Word): Boolean;
var
  OldTrans: Boolean;
begin
  OldTrans := FTransaction.Active;
  if not OldTrans then
    FTransaction.StartTransaction;
  try
    with TIBQuery.Create(nil) do
    begin
      Forget;
      BufferChunks := 10;
      Database := Self.Database;
      Transaction := FTransaction;
      SQL.Add('SELECT ID FROM ADDRESSES');
      SQL.Add('WHERE ORDER_NUMBER=:NUMBER AND EXTRACT(YEAR FROM ORDER_DATE)=:AYEAR');
      Params[0].AsString := Number;
      Params[1].AsInteger := Year;
      Open;
      Result := not IsEmpty;
      Close;
    end;
  finally
    if not OldTrans then
      FTransaction.Commit;
  end;
end;

function TKisUser.AllowAllOffices(const MngrId: TKisMngrs): Boolean;
begin
  Result := IsAdministrator or FAllowAllOffices;
  if not Result then
    case MngrId of
      kmBanks: ;
      kmContragents: ;
      kmContrAddresses: ;
      kmContrDocs: ;
      kmContrCertificates: ;
      kmOrders: ;
      kmLetters:
          with AppModule.User do
            Result := (RoleName = S_ROLE_CHANCELLERY)
             or (RoleName = S_ROLE_MP_CHANCELLERY) or (RoleName = S_ROLE_EXECUTION_CONTROL);

      kmOffices: ;
      kmOrgs: ;
      kmPeople: ;
      kmDocTypes: ;
      kmFirms: ;
      kmOfficeDocs: ;
      kmOutcomingLetters: ;
      kmStreets: ;
      kmGeoPunkts: ;
      kmDecreeProjects: ;
      kmArchivalDocs: ;
      kmLicensedOrgs: ;
      kmMapCases500: ;
      kmAccounts: ;
      kmMapTracings: ;
    end;
end;

function TKisUser.CanDoAction(Action: TKisMngrAction;
  ObjectType: TKisEntities): Boolean;
begin
  Result := IsAdministrator;
  if not Result then
    case ObjectType of
    keContragent, keContrPerson, keContrOrg, keContrPrivate:
      begin
        Result := True;
      end;
    keGeoPunkts:
      begin
        Result := OfficeId = ID_OFFICE_GIS;
      end;
    keLetter, keOutcomingLetter :
      begin
        case Action of
        maInsert, maDelete :
          Result := RoleID in [ID_ROLE_CHANCELLERY, ID_ROLE_MP_CHANCELLERY];
        maEdit :
          Result := RoleID in [ID_ROLE_CHANCELLERY, ID_ROLE_MP_CHANCELLERY,
             ID_ROLE_PPD, ID_ROLE_PDPZ];
        end;
      end;
    keFirm :
      begin
        Result := RoleID in [ID_ROLE_CHANCELLERY, ID_ROLE_MP_CHANCELLERY,
             ID_ROLE_PPD, ID_ROLE_PDPZ];
      end;
    keOfficeDoc :
      begin
        Result := Self.OfficeId in [ID_OFFICE_PDSZ, ID_OFFICE_PDPZ, ID_OFFICE_PDTOGD,
        ID_OFFICE_REKLAMA, ID_OFFICE_TGP, ID_OFFICE_PPGM, ID_OFFICE_SRP,
        ID_OFFICE_JUSZ, ID_OFFICE_RIELTOR];
      end;
    keOrder :
      begin
        if Action = maInsert then
          Result := (OfficeID in [ID_OFFICE_PRIVATE_BUILDING, ID_OFFICE_KGO,
            ID_OFFICE_GIS, ID_OFFICE_PDSZ, ID_OFFICE_PDPZ])
            or
            Self.CanManageOrders;
      end
    else
      Result := False;
    end;
end;

constructor TKisUser.Create(Database: TIBDatabase);
begin
  if UserCreated then
    raise EAbort.Create(S_TOO_MANY_USERS);
  FDatabase := Database;
  FTransaction := TIBTRansaction.Create(nil);
  FTransaction.DefaultDatabase := FDatabase;
  FTransaction.Init(ilReadCommited);
  UserCreated := True;
end;

destructor TKisUser.Destroy;
begin
  UserCreated := False;
  if FTransaction.Active then
    FTransaction.Rollback;
  FreeAndNil(FTransaction);
  FDatabase := nil;
  inherited;
end;

function TKisUser.GenerateNewAccountNumber: String;
var
  I1, I2: Integer;
  NeedCommit: Boolean;
begin
  NeedCommit := not FTransaction.Active;
  if NeedCommit then
    FTransaction.StartTransaction;
  try
    I1 := CheckMaxAccountNumber(True);
    I2 := CheckMaxAccountNumber(False);
    if I2 > I1 then
      I1 := I2;
    Inc(I1);
    while AccountNumberExists(Format('%d', [I1]), CurrentYear) do
      Inc(I1);
    Result := Format('%d', [I1]);
  finally
    if NeedCommit then
      FTransaction.Commit;
  end;
end;

function TKisUser.GenerateNewAddressActNumber: String;
begin
  with IObject(TIBSQL.Create(nil)).AObject as TIBSQL do
  begin
    SQL.Text := Format(SQ_GET_MAX_ADDRESS_ACT_NUMBER, []);
    Transaction := Self.FTransaction;
    if not Transaction.Active then
      Transaction.StartTransaction;
    ExecQuery;
    Result := '0000/адр';
    if RecordCount > 0 then
    try
      Result := Fields[0].AsString;
    except
      Result := '0000/адр';
    end;
    repeat
      Result := uKisUtils.GetNextNumber(Result, S_ADDR_ACT_NUMBER_MASK);
    until not AddressActNumberExists(Result, CurrentYear);
  end;
end;

function TKisUser.GenerateNewAddressOrderNumber: String;
var
  N: Integer;
begin
  with IObject(TIBSQL.Create(nil)).AObject as TIBSQL do
  begin
    SQL.Text := SQ_GET_MAX_ADDRESS_ORDER_NUMBER;
    Transaction := Self.FTransaction;
    if not Transaction.Active then
      Transaction.StartTransaction;
    ExecQuery;
    N := 0;
    if RecordCount > 0 then
    try
      N := Fields[0].AsInteger;
    except
      N := 0;
    end;
    repeat
      Inc(N);
      Result := IntToStr(N);
    until not AddressOrderNumberExists(Result, CurrentYear);
  end;
end;

function TKisUser.GenerateNewLetterNumber(const DocTypeId: Integer): String;
var
  Mask: String;
begin
  Result := '0';
  with TIBQuery.Create(nil) do
  try
    Forget;
    BufferChunks := 10;
    FTransaction.StartTransaction;
    Transaction := Self.FTransaction;
    SQL.Clear;
    case Self.OrgId of
    ID_ORGS_KGA, ID_ORGS_DGA :
      SQL.Text := Format(SQ_LAST_LETTER_DOC_NUMBER, [Self.OrgId, DocTypeId]);
    ID_ORGS_UGA :
      SQL.Text := Format(SQ_LAST_LETTER_MP_NUMBER, [Self.OrgId, DocTypeId]);
    end;
    Open;
    Result := Fields[0].AsString;
    Close;
    SQL.Text := Format(SQ_GET_DOC_NUMBER_MASK, [Self.OrgId, DocTypeId]);
    Open;
    Mask := Fields[0].AsString;
    Close;
    repeat
      Result := uKisUtils.GetNextNumber(Result, Mask);
    until not LetterNumberExists(Result, DocTypeId, CurrentYear);
  finally
    FTransaction.Commit;
  end;
end;

function TKisUser.GenerateNewOfficeDocNumber: Integer;
const
  K = 10000;

  function OfficePrefix: Integer;
  begin
    case FOfficeID of
    1 :  Result := K;
    13 : Result := 3 * K;
    14 : Result := 2 * K;
    20 : Result := 4 * K;
    else
      Result := N_ZERO;
    end;
  end;

var
  NeedCommit: Boolean;
begin
  NeedCommit := not FTransaction.Active;
  if NeedCommit then
    FTransaction.StartTransaction;
  with IObject(TIBSQL.Create(Application)).AObject as TIBSQL do
  try
    Transaction := FTransaction;
    SQL.Clear;
    SQL.Text := Format(SQ_GEN_NEW_OFFICE_DOC_NUMBER, [OfficeID]);
    ExecQuery;
    Result := Fields[N_ZERO].AsInteger;
    Close;
    Result := Result mod K + OfficePrefix;
    Inc(Result);
    while OfficeDocNumberExists(Result, CurrentYear) do
      Inc(Result);
  finally
    if NeedCommit then
      FTransaction.Commit;
  end;
end;

function TKisUser.GetDocTypeMask(const OrgId, DocTypeId: Integer): String;
begin
  Result := '';
  with TIBQuery.Create(nil) do
  try
    Forget;
    Transaction := FTransaction;
    FTransaction.StartTransaction;
    BufferChunks := 10;
    SQL.Text := Format(SQ_GET_DOC_NUMBER_MASK, [OrgId, DocTypeId]);
    Open;
    Result := Fields[0].AsString;
    Close;
  finally
    FTransaction.Commit;
  end;
end;

function TKisUser.GetFullName: String;
begin
  Result := FFullName;
end;

function TKisUser.CheckLetterNumber(const OrgId, DocTypeId: Integer;
  const NumberText: String; var WellFormedNumber: String): Boolean;
var
  Mask: String;
  DoCommit: Boolean;
begin
  Mask := '';
  DoCommit := not FTransaction.Active;
  with TIBQuery.Create(nil) do
  try
    Forget;
    Transaction := FTransaction;
    BufferChunks := 10;
    if DoCommit then
      FTransaction.StartTransaction;
    SQL.Text := Format(SQ_GET_DOC_NUMBER_MASK, [OrgId, DocTypeId]);
    Open;
    Mask := Fields[0].AsString;
    Close;
  finally
    if DoCommit then
      FTransaction.Commit;
  end;
  //
  if Trim(Mask) = '' then
  begin
    Result := True;
    WellFormedNumber := NumberText;
  end
  else
    with IObject(TNumberMask.Create(Mask)).AObject as TNumberMask do
      Result := FormatNumber(NumberText, WellFormedNumber);
end;

function TKisUser.CheckMaxAccountNumber(CheckOldAccounts: Boolean): Integer;
var
  TableName: String;
begin
  with TIBQuery.Create(nil) do
  begin
    Forget;
    Transaction := FTransaction;
    BufferChunks := 10;
    if CheckOldAccounts then
      TableName := ST_ACCOUNTS
    else
      TableName := ST_ORDERS;
    SQL.Text := Format(SQ_GEN_ACCOUNT_NUMBER, [TableName, TableName]);
    Params[0].AsInteger := OfficeID;
    Params[1].AsInteger := CurrentYear;
    Open;
    if IsEmpty then
      Result := 0
    else
      try
        Result := Fields[0].AsInteger;
      except
        Result := 0;
      end;
    Close;
  end;
end;

function TKisUser.GetOfficeName: String;
begin
  Result := FOfficeName;
end;

function TKisUser.GetOrgName: String;
begin
  Result := FOrgname;
end;

function TKisUser.GetPassword: String;
begin
  Result := Database.Password;
end;

procedure TKisUser.InitRoleID;
begin
  if RoleName = S_ROLE_ADMINISTRATOR then
    FRoleId := ID_ROLE_ADMINISTRATOR
  else
  if RoleName = S_ROLE_INDZASTR then
    FRoleId := ID_ROLE_INDZASTR
  else
  if RoleName = S_ROLE_GIS then
    FRoleId := ID_ROLE_GIS
  else
  if RoleName = S_ROLE_PDPZ then
    FRoleId := ID_ROLE_PDPZ
  else
  if RoleName = S_ROLE_PDSZ then
    FRoleId := ID_ROLE_PDSZ
  else
  if RoleName = S_ROLE_PDT then
    FRoleId := ID_ROLE_PDT
  else
  if RoleName = S_ROLE_PDT_TOPO then
    FRoleId := ID_ROLE_PDT_TOPO
  else
  if RoleName = S_ROLE_PPD then
    FRoleId := ID_ROLE_PPD
  else
  if RoleName = S_ROLE_TGR then
    FRoleId := ID_ROLE_TGR
  else
  if RoleName = S_ROLE_KGO then
    FRoleId := ID_ROLE_KGO
  else
  if RoleName = S_ROLE_BUH_OPERATOR then
    FRoleId := ID_ROLE_BUH_OPERATOR
  else
  if RoleName = S_ROLE_GEOSERVICE_CONTR then
    FRoleId := ID_ROLE_GEOSERVICE_CONTR
  else
  if RoleName = S_ROLE_GEOSERVICE then
    FRoleId := ID_ROLE_GEOSERVICE
  else
  if RoleName = S_ROLE_CHANCELLERY then
    FRoleId := ID_ROLE_CHANCELLERY
  else
  if RoleName = S_ROLE_MP_CHANCELLERY then
    FRoleId := ID_ROLE_MP_CHANCELLERY
  else
  if RoleName = S_ROLE_EXECUTION_CONTROL then
    FRoleId := ID_ROLE_EXECUTION_CONTROL
  else
  if RoleName = S_ROLE_DECREE_CONTROL then
    FRoleId := ID_ROLE_DECREE_CONTROL
  else
    FRoleId := -1;
end;

function TKisUser.GetRoleName: String;
begin
  Result := Database.CurrentRole;
end;

procedure TKisUser.Initialize;
begin
  FName := FDatabase.DBParamByDPB[isc_dpb_user_name];
  FRoleName := GetRoleName;
  InitRoleID;
  FTransaction.StartTransaction;
  with IObject(TIBSQL.Create(nil)).AObject as TIBSQL do
  try
    Transaction := FTransaction;
    SQL.Text := Format(SQ_SELECT_USER_PARAMS, [FPeopleId]);
    ExecQuery;
    if RecordCount = 0 then
    begin
      FOfficeID := -1;
      FPeopleId := -1;
      FOrgID := -1;
    end
    else
    begin
      FOfficeID := FieldByName('OFFICES_ID').AsInteger;
      FOrgID := FieldByName('ORGS_ID').AsInteger;
      FShortname := FieldByName('INITIAL_NAME').AsString;
      FFullname := FieldByName('FULL_NAME').AsString;
      FPost := FieldByName('POST').AsString;
      FAllowAllOffices := Boolean(FieldByName('CAN_SEE_ALL_OFFICES').AsInteger);
      FCanSheduleWorks := Boolean(FieldByName('CAN_SHEDULE_WORKS').AsInteger);
      FCanManageKiosks := Boolean(FieldByName('CAN_MANAGE_KIOSKS').AsInteger);
      FCanManageOrders := Boolean(FieldByName('CAN_CREATE_ORDERS').AsInteger);
      FPeopleTypeId := FieldByName('PEOPLE_TYPES_ID').AsInteger;
    end;
    Close;
    SQL.Text := Format(SQ_SELECT_OFFICENAME, [OfficeId]);
    ExecQuery;
    FOfficeName := Fields[0].AsString;
    Close;
    SQL.Text := Format(SQ_SELECT_PRINT_WORKS_VALUE, [OfficeId]);
    ExecQuery;
    FPrintWorksValue := Boolean(Fields[0].AsInteger);
    Close;
    SQL.Text := Format(SQ_SELECT_ORGNAME, [OrgId]);
    ExecQuery;
    FOrgName := Fields[0].AsString;
    Close;
  finally
    FTransaction.Commit;
  end;
end;

function TKisUser.IsAdministrator: Boolean;
begin
  Result := FRoleID = ID_ROLE_ADMINISTRATOR;//UserIsAdministrator(Database);
end;

function TKisUser.LetterNumberExists(const Number: String; const DocTypeId,
  Year: Integer): Boolean;
var
  OldTrans: Boolean;
begin
  OldTrans := FTransaction.Active;
  if not OldTrans then
    FTransaction.StartTransaction;
  try
    with TIBQuery.Create(nil) do
    begin
      Forget;
      Transaction := FTransaction;
      BufferChunks := 10;
      case Self.OrgId of
      ID_ORGS_KGA, ID_ORGS_DGA :
        SQL.Text := SQ_CHECK_LETTER_DOC_NUMBER;
      ID_ORGS_UGA :
        SQL.Text := SQ_CHECK_LETTER_MP_NUMBER;
      end;
      ParamByName(SF_DOC_NUMBER).AsString := Number;
      ParamByName(SF_DOC_TYPES_ID).AsInteger := DocTypeId;
      ParamByName(SF_AYEAR).AsInteger := Year;
      Open;
      Result := not IsEmpty;
      Close;
    end;
  finally
    if not OldTrans then
      FTransaction.Commit;
  end;
end;

function TKisUser.OfficeDocNumberExists(Number, Year: Integer): Boolean;
var
  OldTrans: Boolean;
begin
  OldTrans := FTransaction.Active;
  if not OldTrans then
    FTransaction.StartTransaction;
  try
    with IObject(TIBSQL.Create(nil)).AObject as TIBSQL do
    begin
      Database := Self.Database;
      Transaction := FTransaction;
      SQL.Text := Format(SQ_CHECK_OFFICE_DOC_NUMBER, [AppModule.User.OfficeID]);
      //SQ_CHECK_OFFICE_DOC_NUMBER;
      // Порядок параметров обуслевлен построением индекса
      // по полям DOC_YEAR и DOC_NUMBER в БД 
      Params[0].AsInteger := Year;
      Params[1].AsInteger := Number;
      ExecQuery;
      Result := RecordCount > 0;
      Close;
    end;
  finally
    if not OldTrans then
      FTransaction.Commit;
  end;
end;

{ TKisEntityMngr }

procedure TKisSQLMngr.CloseView(Sender: TObject; var Action: TCloseAction);
begin
  WriteViewState;
  WriteOrderState(FSQLHelper);
  AppModule.SaveAppParam(Self.ClassName, 'BigButtons', FView.BigButtons);
  if Assigned(FView) then
  if fsModal in FView.FormState then
    Action := caHide
  else
  begin
    Action := caFree;
    FView := nil;
    Active := False;
  end;
end;

procedure TKisSQLMngr.CreateView;

  procedure InsertActions(const ACategory: String; GrIndex: SmallInt);
  var
    I, J: Integer;
    Btn: TToolButton;
    Item, SubItem: TMenuItem;
    HintText: string;
  begin
    Item := TMenuItem.Create(FView.MainMenu);
    Item.Caption := ACategory;
    Item.GroupIndex := GrIndex;
    FView.MainMenu.Items.Insert(0, Item);
    for I := Pred(ActionList.ActionCount) downto N_ZERO do
    for J := N_ZERO to Pred(ActionList.ActionCount) do
      if ActionList.Actions[J].Category = ACategory then
      if ActionList.Actions[J].Tag = I then
      begin
        Btn := TToolButton.Create(FView);
        Btn.Action := ActionList.Actions[J];
        FView.ToolBar.InsertControl(Btn);
        if TAction(ActionList.Actions[J]).Caption = '-' then
        begin
          Btn.Style := tbsSeparator;
          Btn.Width := 7;
        end
        else
        begin
          Btn.ShowHint := True;
          HintText := TAction(ActionList.Actions[J]).Hint;
          if Trim(HintText) = '' then
            HintText := TAction(ActionList.Actions[J]).Caption;
          Btn.Hint := HintText;
        end;
        SubItem := TMenuItem.Create(FView);
        SubItem.Action := ActionList.Actions[J];
        Item.Add(SubItem);
      end;
  end;

  procedure InsertNavActions;
  var
    I, J: Integer;
    Btn: TSpeedButton;
  begin
    for I := 0 to Pred(ActionListNav.ActionCount) do
    for J := 0 to Pred(ActionListNav.ActionCount) do
    if ActionListNav.Actions[J].Tag = I then
    begin
      Btn := TSpeedButton.Create(FView);
      Btn.Flat := True;
      Btn.Action := ActionListNav.Actions[J];
      FView.NavButtonsPanel.InsertControl(Btn);
      Btn.ShowHint := True;
      Btn.Hint := TAction(ActionListNav.Actions[J]).Hint;
      Btn.Align := alLeft;
      Btn.Layout := blGlyphTop;
    end;
  end;

begin
  if not Assigned(FView) then
    FView := TKisMngrView.Create(Self);
  FView.ToolBar.Images := ImageList;
  FView.ToolBarNav.Images := ImageList;
  FView.MainMenu.Images := ImageList;
  InsertActions(S_ACTNCAT_PRINT, 0);
  InsertActions(S_ACTNCAT_DATA, 2);
  InsertNavActions;
  FillFilterFields;
  FView.cbSetFilter.OnClick := OnSetFilter;
  FView.Grid.DataSource := DataSource;
  FView.Grid.OnColEnter := OnColEnter;
  FView.OnClose := CloseView;
  FView.OnSearch := DoUserSearch;
  FView.edFilter.OnKeyPress := edFilterEnterPress;
  ReadOrderState(FSQLHelper);
  FView.BigButtons := AppModule.ReadAppParam(Self.ClassName, 'BigButtons', varBoolean);
end;

procedure TKisSQLMngr.DeleteCurrent;
begin
  with KisObject(CurrentEntity) do
    DeleteEntity(AEntity);
end;

function TKisSQLMngr.DuplicateCurrent: TKisEntity;
var
  OldEnt, NewEnt: TKisEntity;
begin
  OldEnt := KisObject(CurrentEntity).AEntity;
  NewEnt := DuplicateEntity(OldEnt);
  SaveEntity(NewEnt);
  Result := NewEnt;
end;

procedure TKisSQLMngr.EditCurrent;
var
  Conn: IKisConnection;
begin
  Conn := GetConnection(True, True);
  try
    if not Assigned(DefaultTransaction) then
      raise Exception.CreateFmt(S_DEFAULT_TRANSACTION_MISSED, [Self.ClassName]);
    with KisObject(CurrentEntity) do
      if Assigned(AEntity) then
      if AEntity is TKisVisualEntity then
      begin
        AEntity.Modified := False;
        if TKisVisualEntity(AEntity).Edit and AEntity.Modified then
          SaveEntity(AEntity);
      end;
    FreeConnection(Conn, True);
  except
    FreeConnection(Conn, False);
    raise;
  end;
end;

procedure TKisSQLMngr.SetActive(const Value: Boolean);
begin
  if FActive <> Value then
  begin
    if Value then
      Activate
    else
      Deactivate;
    FActive := Value;
  end;
end;

procedure TKisSQLMngr.ShowEntities(aFilters: IKisFilters; StartID: Integer);
var
  Save_Cursor: TCursor;
begin
  Save_Cursor := Screen.Cursor;
  Screen.Cursor := crSQLWait;
  try
    IntShowEntities(aFilters, StartId);
  finally
    Screen.Cursor := Save_Cursor;
  end;
end;

procedure TKisSQLMngr.AddFiltersSQL;
var
  I: Integer;
  Clause: TWhereClause;
begin
  // добавляем условия от фильтров
  if FFilters.Count > 0 then
  begin
    Clause := FSQLHelper.Parser.Where;
    for I := 0 to FFilters.Count - 1 do
      ProcessSQLFilter(FFilters[I], foAddSQL, Clause);
  end;
end;

procedure TKisSQLMngr.acReopenExecute(Sender: TObject);
begin
  Reopen;
end;

procedure TKisSQLMngr.acFirstExecute(Sender: TObject);
begin
  DataSource.DataSet.First;
end;

procedure TKisSQLMngr.acPrevExecute(Sender: TObject);
begin
  DataSource.DataSet.Prior;
end;

procedure TKisSQLMngr.acNextExecute(Sender: TObject);
begin
  DataSource.DataSet.Next;
end;

procedure TKisSQLMngr.acLastExecute(Sender: TObject);
begin
  DataSource.DataSet.Last;
end;

procedure TKisSQLMngr.acFirstUpdate(Sender: TObject);
begin
  acFirst.Enabled := Assigned(DataSource.DataSet) and DataSource.DataSet.Active
    and not DataSource.DataSet.Bof;
end;

procedure TKisSQLMngr.acPrevUpdate(Sender: TObject);
begin
  acPrev.Enabled := Assigned(DataSource.DataSet) and DataSource.DataSet.Active
    and not DataSource.DataSet.Bof;
end;

procedure TKisSQLMngr.acNextUpdate(Sender: TObject);
begin
  acNext.Enabled := Assigned(DataSource.DataSet) and DataSource.DataSet.Active
    and not DataSource.DataSet.Eof;
end;

procedure TKisSQLMngr.acLastUpdate(Sender: TObject);
begin
  acLast.Enabled := Assigned(DataSource.DataSet) and DataSource.DataSet.Active
    and not DataSource.DataSet.Eof;
end;

function TKisSQLMngr.SelectEntity(NewView: Boolean; aFilters: IKisFilters; ClearExistingFilters: Boolean;
  StartID: Integer): TKisEntity;
var
  TmpView: TKisMngrView;
  Save_Cursor: TCursor;
  WasActive: Boolean;
begin
  TmpView := nil;
  WasActive := Active;
  {crSQLWait}
  Save_Cursor := Screen.Cursor;
  Screen.Cursor := crSQLWait;
  try
    try
      RestoreFilters;
      //
      if NewView then
      begin
        TmpView := FView;
        FView := nil;
      end;
      if not Assigned(FView) then
      begin
        CreateView;
        FView.Grid.OnDblClick := ViewGridDblClick;
        FView.Grid.OnMouseUp := ViewGridMouseUp;
      end
      else
        FView.BringToFront;
      FView.FormStyle := fsNormal;
      ReadViewState;
      FView.ButtonsPanel.Visible := True;
      ApplyFilters(aFilters, ClearExistingFilters);
      Active := True;
      Locate(StartId);
    except
      on E: Exception do
      begin
        FreeAndNil(FView);
        raise;
      end;
    end;
  finally
    Screen.Cursor := Save_Cursor;
  end;
  if Assigned(FView) and (FView.ShowModal = mrOK) then
  begin
    Result := CurrentEntity;
  end
  else
    Result := nil;
  CancelFilters(aFilters);
  if NewView then
  begin
    FView.Free;
    FView := TmpView;
  end;
  if not WasActive then
    Active := False;
end;

constructor TKisSQLMngr.Create(AOwner: TComponent);
begin
  inherited;
  FFilters := TFilterFactory.CreateList();
  FTransactionStack := TKisTransactionStack.Create(Self);
  FSQLHelper := TKisSQLHelper.Create(Self);
  FSQLHelper.SQL := GetMainSQLText;
  PrepareSQLHelper;
  InSearch := False;
  PrepareMainDataSet;
  DataSource.DataSet := MainDataSet;
end;

function TKisSQLMngr.CreateNewConnection(AOwner: TComponent;
  aTransaction: TIBTransaction; aNeedCommit,
  aNeedBack: Boolean): IKisConnection;
begin
  Result := TKisIBConnection.CreateConnection(AOwner, aTransaction, aNeedCommit, aNeedBack);
end;

procedure TKisSQLMngr.ReadViewState;
begin
  if Assigned(FView) then
  begin
    AppModule.ReadGridProperties(Self, FView.Grid);
    AppModule.ReadFormPosition(Self, FView);
  end;
end;

procedure TKisSQLMngr.RemoveFiltersSQL;
var
  I: Integer;
  Clause: TWhereClause;
begin
  // удаляем условия от фильтров
  if FFilters.Count > 0 then
  begin
    Clause := FSQLHelper.Parser.Where;
    for I := 0 to FFilters.Count - 1 do
      ProcessSQLFilter(FFilters[I], foRemoveSQL, Clause);
  end;
end;

procedure TKisSQLMngr.WriteViewState;
begin
  if Assigned(FView) then
  begin
    AppModule.WriteGridProperties(Self, FView.Grid);
    AppModule.WriteFormPosition(Self, FView);
  end;
end;

procedure TKisSQLMngr.WriteOrderState(Helper: TKisSQLHelper; ParamName: String);
var
  S: String;
  I: Integer;
begin
  if Assigned(Helper) then
  begin
    S := '';
    for I := 0 to Pred(Helper.FParser.Clauses[sqlOrderBy].PartCount) do
    begin
      if S <> '' then
        S := S + ',';
      S := S + Helper.FParser.Clauses[sqlOrderBy].Parts[I];
    end;
    AppModule.SaveAppParam(Self.ClassName, ParamName, S);
  end;
end;

procedure TKisSQLMngr.ReadOrderState(Helper: TKisSQLHelper; ParamName: String);
var
  S, S1: String;
  I: Integer;
begin
  if Assigned(Helper) then
  begin
    S := AppModule.ReadAppParam(Self.ClassName, ParamName, varString);
    S1 := Helper.FParser.Clauses[sqlOrderBy].Text;
    Delete(S1, 1, Length('ORDER BY '));
    if S = S1 then
      Exit;
    I := Pos(',', S);
    while I > 0 do
    begin
      S1 := Trim(Copy(S, 1, Pred(I)));
      if S1 <> '' then
        Helper.Parser.SafeAddOrderByPart(S1);
      Delete(S, 1, I);
      I := Pos(',', S);
    end;
    S1 := Trim(S);
    if S1 <> '' then
      Helper.Parser.SafeAddOrderByPart(S1);
  end;
end;

procedure TKisSQLMngr.LoadController(const SQLText: String; const Id: Integer;
  EntKind: TKisEntities; aCtrlr: TKisEntityController);
var
  Conn: IKisConnection;
  Tmp: TKisEntity;
  DS: TDataSet;
begin
  Conn := GetConnection(True, True);
  DS := Conn.GetDataSet(Format(SQLText, [Id]));
  try
    DS.Open;
    while not DS.Eof do
    begin
      Tmp := GetEntity(DS.FieldByName(SF_ID).AsInteger, EntKind);
      if Assigned(Tmp) then
         aCtrlr.DirectAppend(Tmp);
      DS.Next;
    end;
     DS.Close;
   finally
     FreeConnection(Conn, True);
  end;
end;

procedure TKisSQLMngr.Locate(AId: Integer; LocateFail: Boolean = False);
begin

end;

procedure TKisSQLMngr.LookFor(Search: TKisSearch);
begin
  if not Assigned(Search) then
    Exit;
  //
  if Assigned(Search.FMngr) then
    if Assigned(Search.FConn) then
      Search.FMngr.FreeConnection(Search.FConn, False);
  //
  Search.FMngr := Self;
  Search.FConn := GetConnection(True, False, True);
  Search.FDataSet := Search.FConn.GetDataSet(Search.SQL);
end;

procedure TKisSQLMngr.SetInSearch(const Value: Boolean);
var
  S: String;
  NeedReopen: Boolean;
begin
  NeedReopen := Active;
  FInSearch := Value;
  if FInSearch then
  begin
    if FSQLHelper.TableCount > 0 then
      FSQLHelper.Tables[0].SelectedField := FView.Grid.SelectedField.FieldName;
//    FSQLHelper.SearchConditions := ReadLastSearch();
    NeedReopen := FSQLHelper.SearchDialog and NeedReopen;
//    SaveLastSearch(FSQLHelper.SearchConditions);
    FInSearch := NeedReopen or FInSearch;
  end
  else
  begin
    S := FSQLHelper.OrderByStr;
    FSQLHelper.SQL := GetMainSQLText;
    FSQLHelper.OrderByStr := S;
    if NeedReopen then
    begin
      RestoreFilters;
    end;
  end;
  if NeedReopen and not (csDestroying in ComponentState) then
    Reopen; 
end;

procedure TKisSQLMngr.Reopen;
var
  aSql: String;
  Handled: Boolean;
begin
  try
    DataSource.DataSet.Active := False;
    DataSource.DataSet.Active := True;
  except
    on E: Exception do
    begin
      if DataSource.DataSet is TIBDataSet then
        aSql := TIBDataSet(DataSource.DataSet).SelectSQL.Text
      else
      if DataSource.DataSet is TIBQuery then
        aSql := TIBQuery(DataSource.DataSet).SQL.Text
      else
        aSql := '';
      HandleIBXException(E, Handled);
      if not Handled then
      if aSql = '' then
        raise E
      else
        with ESQLException.Create(E, ClassName) do
        begin
          Sql := aSql;
          raise Me;
        end;
    end;
  end;
end;

procedure TKisSQLMngr.SafeReopen(aDataSet: TDataSet; const KeyField: string);
var
  Value: Variant;
begin
  aDataSet.DisableControls;
  try
    if aDataSet.Active and (KeyField <> '') then
      Value := aDataSet.FieldValues[KeyField]
    else
      Value := Null;
    aDataSet.Active := False;
    aDataSet.Active := True;
    if (KeyField <> '') and not VarIsNull(Value) then
    begin
      if not aDataSet.Locate(KeyField, Value, []) then
        aDataSet.First;
    end;
  finally
    aDataSet.EnableControls;
  end;
end;

procedure TKisSQLMngr.SaveLastSearch(SearchCond: TKisSearchConditions);
const
  Section = 'LastSearchCoditions';
var
  V1, V2, V3: Variant;
begin
  if SearchCond.IsRange then
  begin
    V1 := SearchCond.Top;
    V2 := SearchCond.Bottom;
    V3 := '';
  end
  else
  begin
    V1 := '';
    V2 := '';
    V3 := SearchCond.Value;
  end;
  AppModule.SaveAppParam(Section, 'Top', V1);
  AppModule.SaveAppParam(Section, 'Bottom', V2);
  AppModule.SaveAppParam(Section, 'Value', V3);
//  AppModule.SaveAppParam('LastSearchCoditions', 'DataType', SearchCond.Field.DataType);
  AppModule.SaveAppParam(Section, 'IsRange', SearchCond.IsRange);
  AppModule.SaveAppParam(Section, 'CaseSencitive', SearchCond.CaseSencitive);
  AppModule.SaveAppParam(Section, 'Exact', SearchCond.Exact);
end;

procedure TKisSQLMngr.ReadLastSearch(LastSearch: TKisSearchConditions);
begin
  LastSearch.Top := AppModule.ReadAppParam('LastSearchCoditions', 'Top', varVariant);
  LastSearch.Bottom := AppModule.ReadAppParam('LastSearchCoditions', 'Bottom', varVariant);
  LastSearch.Value := AppModule.ReadAppParam('LastSearchCoditions', 'Value', varVariant);
//  Result.Field.DataType := AppModule.ReadAppParam('LastSearchCoditions', 'DataType', varInteger);
  LastSearch.IsRange := AppModule.ReadAppParam('LastSearchCoditions', 'IsRange', varBoolean);
  LastSearch.CaseSencitive := AppModule.ReadAppParam('LastSearchCoditions', 'CaseSencitive', varBoolean);
  LastSearch.Exact := AppModule.ReadAppParam('LastSearchCoditions', 'Exact', varBoolean);
end;

procedure TKisSQLMngr.PrepareSQLHelper;
begin
  FSQLHelper.ClearTables;
end;

function TKisSQLMngr.ProcessSQLFilter(aFilter: IKisFilter;
  TheOperation: TKisFilterOperation; Clause: TWhereClause): Boolean;
var
  Condition: TSQLCondition;
  I: Integer;
  FltrName, RelationText: string;
begin
  Result := False;
  FltrName := (aFilter as IKisNamedObject).Name;
  case TheOperation of
  foAddSQL :
    begin
      if aFilter.Relation = frNone then
        raise EKisException.Create('Базовый обработчик фильтров не поддерживает фильтры типа None!');
      Condition := TSQLCondition.Create;
      case aFilter.Relation of
      frEqual:
        RelationText := '=';
      frLess:
        RelationText := '<';
      frLessOrEqual:
        RelationText := '<=';
      frGreater:
        RelationText := '>';
      frGreaterOrEqual:
        RelationText := '>=';
      end;
      Condition.Text := FltrName + RelationText + VarToStr(aFilter.Value);
      if Clause.PartCount = 0 then
        Condition.TheOperator := coNone
      else
        Condition.TheOperator := coAnd;
      Condition.Comment := FltrName;
      Clause.AddCondition(Condition);
      Result := True;
    end;
  foRemoveSQL :
    begin
      for I := Clause.PartCount - 1 downto 0 do
        if Clause.Conditions[I].Comment = FltrName then
          Clause.DeletePart(I);
      Result := True;
    end;
  end;
end;

function TKisSQLMngr.GetConnection(const Read, Write: Boolean; NewTransaction: Boolean = False): IKisConnection;
var
  AM: TIBAccessMode;
  TheConn: TKisIBConnection;
begin
  TheConn := TKisIBConnection.Create(Self);
  TheConn.FNeedBack := NewTransaction or not Assigned(DefaultTransaction);
  if Read then
    TheConn.FNeedBack := TheConn.FNeedBack or not DefaultTransaction.CanRead();
  if Write then
    TheConn.FNeedBack := TheConn.FNeedBack or not DefaultTransaction.CanWrite();
  if TheConn.FNeedBack then
  begin
    TheConn.FTransaction := AppModule.Pool.Get;
    if Read and Write then
      AM := amReadWrite
    else
      if Read then
        AM := amReadOnly
      else
        AM := amWriteOnly;
    TheConn.FTransaction.Init(ilReadCommited, AM);
    TheConn.FTransaction.AutoStopAction := saNone;
    Self.DefaultTransaction := TheConn.FTransaction;
  end
  else
    TheConn.FTransaction := Self.DefaultTransaction;
  TheConn.FNeedCommit := not TheConn.FTransaction.Active;
  if TheConn.FNeedCommit then
    TheConn.FTransaction.StartTransaction;
  //
  Result := TheConn as IKisConnection;
end;

procedure TKisSQLMngr.FreeConnection(Connection: IKisConnection;
  Correct: Boolean; StayActive: Boolean = False);
begin
  if Assigned(Connection) then
  begin
    FErrorInConnection := FErrorInConnection and Correct;
    if Connection.NeedCommit then
    begin
      if FErrorInConnection then
        Connection.Rollback(StayActive)
      else
        Connection.Commit(StayActive);
      FErrorInConnection := False;
    end;
    if Connection.NeedBack then
    begin
      if Self.DefaultTransaction = Connection.Transaction then
        Self.DefaultTransaction := nil;
      AppModule.Pool.Back(Connection.Transaction);
    end;
  end;
end;

function TKisUser.GenerateOutcomingLetterSeqNumber: String;
Var
   N: Integer;
   NeedCommit: Boolean;
begin
  NeedCommit := not FTransaction.Active;
  if NeedCommit then
    FTransaction.StartTransaction;
  try
    with IObject(TIBSQL.Create(Application)).AObject as TIBSQL do
    begin
      Transaction := FTransaction;
      SQL.Text := SQ_GET_MAX_OUTCOMLETTER_SEQ_NUMBER;
      ExecQuery;
      if RecordCount > 0 then
        N := StrToInt(Fields[0].AsString)
      else
        N := 0;
    end;
    repeat
      Inc(N);
    until not OutcomingLetterSeqNumberExists(IntToStr(N), CurrentYear);
  finally
    if NeedCommit then
      FTransaction.Commit;
  end;
  Result := IntToStr(N);
  Result := StringOfChar('0', 4 - Length(Result)) + Result;
end;

function TKisUser.OutcomingLetterSeqNumberExists(const Number: String;
  const Year: Integer): Boolean;
var
  OldTrans: Boolean;
begin
  OldTrans := FTransaction.Active;
  if not OldTrans then
    FTransaction.StartTransaction;
  try
    with TIBQuery.Create(nil) do
    begin
      Forget;
      Database := Self.Database;
      Transaction := FTransaction;
      BufferChunks := 10;
      SQL.Add('SELECT ID FROM OUTCOMING_LETTERS');
      SQL.Add('WHERE SEQ_NUMBER=:NUMBER AND EXTRACT(YEAR FROM DATE_REG)=:AYEAR');
      Params[0].AsString := Number;
      Params[1].AsInteger := Year;
      Open;
      Result := not IsEmpty;
      Close;
    end;
  finally
    if not OldTrans then
      FTransaction.Commit;
  end;
end;

function TKisUser.DecreeProjectSeqNumberExists(const Number: String;
  const Year: Integer): Boolean;
var
  OldTrans: Boolean;
begin
  OldTrans := FTransaction.Active;
  if not OldTrans then
    FTransaction.StartTransaction;
  try
    with TIBQuery.Create(nil) do
    begin
      Forget;
      Database := Self.Database;
      Transaction := FTransaction;
      BufferChunks := 10;
      SQL.Add('SELECT ID FROM DECREE_PRJS');
      SQL.Add('WHERE SEQ_NUMBER=:NUMBER AND SUBSTRING(SEQ_NUMBER FROM 6 FOR 2)=:YEAR');
      Params[0].AsString := Number;
      Params[1].AsInteger := Year;
      Open;
      Result := not IsEmpty;
      Close;
    end;
  finally
    if not OldTrans then
      FTransaction.Commit;
  end;
end;

function TKisUser.GenerateDecreeProjectSeqNumber: String;
var
   I, N, CutYear: Integer;
   NeedCommit: Boolean;
   CurYear: String;
   S: String;
begin
  CurYear := IntToStr(CurrentYear);
  CutYear := StrToInt(CurYear[3] + CurYear[4]);
  NeedCommit := not FTransaction.Active;
  if NeedCommit then
    FTransaction.StartTransaction;
  try
    with IObject(TIBSQL.Create(Application)).AObject as TIBSQL do
    begin
      Transaction := FTransaction;
      SQL.Text := SQ_GET_MAX_DECREE_PROJECT_SEQ_NUMBER;
      ExecQuery;
      if RecordCount > 0 then
      begin
        S := Trim(Fields[0].AsString);
        I := Pos('/', S);
        if I > 0 then
          S := Copy(S, 1, Pred(I));
        if StrIsNumber(S) then
          N := StrToInt(S)
        else
          N := 0;
//        N := StrToInt(Copy(Fields[0].AsString, 1, 4))
      end
      else
        N := 0;
    end;
    repeat
      Inc(N);
    until not DecreeProjectSeqNumberExists(IntToStr(N), CutYear);
  finally
    if NeedCommit then
      FTransaction.Commit;
  end;
  Result := IntToStr(N);
  Result := StringOfChar('0', 4 - Length(Result)) + Result + '/' + CurYear[3] + CurYear[4];
end;

function TKisUser.GetPost: String;
begin

end;

procedure TKisUser.SetPeopleId(const Value: Integer);
begin
  if FPeopleId <> Value then
  begin
    FPeopleId := Value;
    Initialize;
  end;
end;

function TKisUser.GetInfo: String;
begin

end;

{ TKisSQLHelper }

function TKisSQLHelper.AddLinkedTable: TKisLinkedTable;
begin
  Result := TKisLinkedTable.Create;
  FTables.Add(Result);
end;

function TKisSQLHelper.AddTable: TKisTable;
begin
  Result := TKisTable.Create;
  FTables.Add(Result);
end;

procedure TKisSQLHelper.CheckSearchField(Sender: TObject);
begin
  if Assigned(FSearchDialog) then
    with FSearchDialog do
    begin
      GenerateControls(Tables[cbTables.ItemIndex].Fields[cbFields.ItemIndex]);
    end;
end;

procedure TKisSQLHelper.ClearTables;
var
  I: Integer;
  P: Pointer;
begin
  for I := Pred(TableCount) downto 0 do
  begin
    P := Tables[I];
    FreeAndNil(P);
    FTables.Delete(I)
  end;
end;

constructor TKisSQLHelper.Create;
begin
  inherited;
  FSearchConditions := TKisSearchConditions.Create;
  FTables := TList.Create;
  FParser := TSelectSQLParser.Create;
end;

destructor TKisSQLHelper.Destroy;
var
  I: Integer;
  P: Pointer;
begin
  for I := 0 to Pred(FTables.Count) do
  begin
    P := FTables[I];
    FreeAndNil(P);
  end;
  FTables.Free;
  FParser.Free;
  FSearchConditions.Free;
  if Assigned(FSearchDialog) and not (csDestroying in FSearchDialog.ComponentState) then
    FSearchDialog.Release;
  inherited;
end;

procedure TKisSQLMngr.FillFilterFields;
var
  I: Integer;
begin
  with DataSource.DataSet do
  for I := 0 to Pred(FieldCount) do
    if Fields[I].Visible then
      FView.cbFilterFields.Items.AddObject(Fields[I].DisplayName, Fields[I])
end;

procedure TKisSQLHelper.FillSearchFields(Sender: TObject);
var
  I: Integer;
begin
  if Assigned(FSearchDialog) then
  with FSearchDialog.cbTables, Tables[ItemIndex] do
  begin
    FSearchDialog.cbFields.Clear;
    for I := 0 to Pred(FieldCount) do
    if fpSearch in Fields[I].Params then
      FSearchDialog.cbFields.Items.Add(Fields[I].FieldLabel);
    FSearchDialog.cbFields.ItemIndex := 0;
    CheckSearchField(FSearchDialog.cbFields);
  end;
end;

function TKisSQLHelper.GetOrderByStr: String;
begin
  with FParser.Clauses[sqlOrderBy] do
  if IsEmpty then
    Result := ''
  else
    Result := Text;
end;

function TKisSQLHelper.GetSQL: String;
begin
  Result := FParser.Text;
end;

function TKisSQLHelper.GetTables(Index: Integer): TKisTable;
begin
  Result := FTables[Index];
end;

function TKisSQLHelper.GetWhereStr: String;
begin
  with FParser.Clauses[sqlWhere] do
  if IsEmpty then
    Result := ''
  else
    Result := Text;
end;

procedure TKisSQLHelper.ModifySQLWhereClause;
//var
//  I: Integer;
//  S, AFieldName: String;
begin
  with Self.FSearchConditions do
  begin
//    I := FParser.IndexOfTableName(Field.GetTableName);
//    if I >= 0 then
//    begin
//      S := FParser.TableAliases[I];
//      if S <> '' then
//        S := S + '.';
//      AFieldName := S + Field.FieldName;
//    end;
    FParser.Clauses[sqlWhere].AddPart('AND ' + FSearchConditions.GetConditionString);
  end;
end;

function TKisSQLHelper.SearchDialog: Boolean;
var
  I: Integer;
begin
  if TableCount = 0 then
    raise EAbort.Create(S_EMPTY_SEARCH_DATA);
  if not Assigned(FSearchDialog) then
    FSearchDialog := TKisSearchDialog.Create(Self);
  with FSearchDialog do
  try
    cbTables.Clear;
    for I := 0 to Pred(TableCount) do
    if Tables[I].SearchFieldCount > 0 then
      cbTables.Items.Add(Tables[I].TableLabel);
    cbTables.OnChange := FillSearchFields;
    cbFields.OnChange := CheckSearchField;
    RadioButton1.OnClick := CheckSearchField;
    RadioButton2.OnClick := CheckSearchField;
    cbTables.ItemIndex := 0;
    FillSearchFields(Self);
    if Tables[0].SelectedField = '' then
      cbFields.ItemIndex := 0
    else
      for I := 0 to Pred(Tables[0].FieldCount) do
        if Tables[0].Fields[I].FieldName = Tables[0].SelectedField then
        begin
          cbFields.ItemIndex := I;
          Break;
        end
        else
          cbFields.ItemIndex := 0;
    CheckSearchField(Self);
    Result := ShowModal = mrOK;
    if Result then
    with FSearchConditions do
    begin
      Clear;
      Field := Tables[cbTables.ItemIndex].Fields[cbFields.ItemIndex];
      if Field.FLookUp then
      begin
        IsRange := False;
        with TComboBox(Control1) do
          Value := Integer(Items.Objects[ItemIndex]);
        Exact := True;
        Empty := False;
      end
      else
      begin
        case FieldType of
        ftString, ftMemo, ftFmtMemo, ftFixedChar, ftWideString, ftBlob:
          begin
            IsRange := False;
            Value := TEdit(Control1).Text;
            CaseSencitive := CheckBox1.Checked;
            Exact := RadioButton1.Checked;
            Empty := chbEmptyField.Visible and chbEmptyField.Checked;
          end;
        ftSmallint, ftInteger, ftWord:
          begin
            IsRange := RadioButton2.Checked;
            Exact := True;
            if IsRange then
            begin
              Top := StrToInt(TEdit(Control1).Text);
              Bottom := StrToInt(TEdit(Control2).Text);
            end
            else
            begin
              Value := StrToInt(TEdit(Control1).Text);
            end;
            Empty := chbEmptyField.Visible and chbEmptyField.Checked;
          end;
        ftBoolean:
          begin
            IsRange := False;
            Value := Boolean(TComboBox(Control1).ItemIndex);
            Empty := chbEmptyField.Visible and chbEmptyField.Checked;
          end;
        ftFloat:
          begin
            Exact := True;
            IsRange := RadioButton2.Checked;
            if IsRange then
            begin
              Top := StrToFloat(TEdit(Control1).Text);
              Bottom := StrToFloat(TEdit(Control2).Text);
            end
            else
            begin
              Value := StrToFloat(TEdit(Control1).Text);
            end;
            Empty := chbEmptyField.Visible and chbEmptyField.Checked;
          end;
        ftDate, ftDateTime:
          begin
            IsRange := RadioButton2.Checked;
            Exact := True;
            if IsRange then
            begin
              Top := TDateTimePicker(Control1).Date;
              Bottom := TDateTimePicker(Control2).Date;
            end
            else
            begin
              Value := TDateTimePicker(Control1).Date;
            end;
            Empty := chbEmptyField.Visible and chbEmptyField.Checked;
          end;
        else
          raise EAbort.Create(S_UNSUPPORTED_FIELD_TYPE);
        end;
      end;
      ModifySQLWhereClause;
    end;
  finally
    Release;
    FSearchDialog := nil;
  end;
end;

procedure TKisSQLHelper.SetOrderByStr(const Value: String);
begin
  with FParser.Clauses[sqlOrderBy] do
    Text := Value;
end;

procedure TKisSQLHelper.SetSearchConditions(
  const Value: TKisSearchConditions);
begin
  FSearchConditions := Value;
end;

procedure TKisSQLHelper.SetSQL(const Value: String);
begin
  FParser.Text := Value;
end;

procedure TKisSQLHelper.SetWhereStr(const Value: String);
begin
  with FParser.Clauses[sqlWhere] do
    Text := Value;
end;

function TKisSQLHelper.SortDialog: Boolean;
var
  OrClause: TOrderByClause;
  SClause: TSelectClause;
  S, FldName, TblAlias, TblName, FldPseud: String;
  Dialog: TKisSortDialog;

  procedure FillCurrentOrder;
  var
    I, J, K, L: Integer;
    IsDesc: Boolean;
  begin
    with Dialog do
    begin
      SClause := FParser.Clauses[uSQLParsers.sqlSelect] as TSelectClause;
      OrClause := FParser.Clauses[sqlOrderBy] as TOrderByClause;
      if not OrClause.IsEmpty then
      for I := 0 to Pred(OrClause.PartCount) do
      begin
        S := AnsiUpperCase(OrClause.Parts[I]);
        J := Pos(#32 + SQL_SORT_DESC, S);
        IsDesc := J > 0;
        if IsDesc then
          Delete(S, J, Length(#32 + SQL_SORT_DESC))
        else
        begin
          J := Pos(#32 + SQL_SORT_ASC, S);
          if J > 0 then
            Delete(S, J, Length(#32 + SQL_SORT_ASC));
        end;
        if not TryStrToInt(S, J) then
          J := 0;
        if J > 0 then
        begin
          FldName := SClause.Parts[J];
        end
        else
          FldName := S;
        // нашли имя поля в запросе, т.е. корявое типа "A.MY_FIELD AS A_MYFIELD"
        // его теперь надо распарсить и найти метку поля, т.е. его читаемое имя
        SClause.ParseColumnName(FldName, TblAlias, S, FldPseud);
        if FldPseud <> '' then
          FldName := FldPseud
        else
          FldName := S;
        // Ищем имя таблицы в парсере по ее псевдониму (или имени)
        TblName := TblAlias;
        for J := 0 to Pred(FParser.TableCount) do
          if FParser.TableAliases[J] = TblAlias then
          begin
            TblName := FParser.TableNames[J];
            Break;
          end;
        for J := 0 to Pred(TableCount) do
        begin
          if Tables[J].TableName = TblName then
          for K := 0 to Pred(Tables[J].FieldCount) do
          if Tables[J].Fields[K].FieldName = FldName then
          begin
            L := lbOrder.Items.AddObject(Tables[J].Fields[K].FieldLabel, Tables[J].Fields[K]);
            lbOrder.Checked[L] := IsDesc;
          end;
        end;
      end;
    end;
  end;

  procedure FillAllFields;
  var
    I, J: Integer;
  begin
    with Dialog do
      for I := 0 to Pred(TableCount) do
      for J := 0 to Pred(Tables[I].FieldCount) do
        if fpSort in Tables[I].Fields[J].Params then
        if lbOrder.Items.IndexOfObject(Tables[I].Fields[J]) < 0 then
          lbFields.AddItem(Tables[I].Fields[J].FieldLabel, Tables[I].Fields[J]);
  end;

var
  I: Integer;
begin
  Dialog := TKisSortDialog.Create(Self);
  with Dialog do
  begin
    FillCurrentOrder;
    FillAllFields;
    Result := ShowModal = mrOK;
    if Result then
    begin
      S := '';
      if lbOrder.Items.Count > 0 then
      begin
        S := 'ORDER BY ';
        for I := 0 to Pred(lbOrder.Items.Count) do
        with TKisField(lbOrder.Items.Objects[I]) do
        begin
          S := S + FullName;//Table.TableName + '.' + FieldName;
          if lbOrder.Checked[I] then
            S := S + #32 + SQL_SORT_DESC
          else
            S := S + #32 + SQL_SORT_ASC;
          if I <> Pred(lbOrder.Items.Count) then
            S := S + ', ';
        end;
      end;
      FParser.Clauses[sqlOrderBy].Text := S;
    end;
    Release;
  end;
end;

function TKisSQLHelper.TableByName(const TableName: String): TKisTable;
var
  I: Integer;
begin
  Result := nil;
  for I := 0 to Pred(TableCount) do
  begin
    if Tables[I].TableName = TableName then
    begin
      Result := Tables[I];
      Exit;
    end;
  end
end;

function TKisSQLHelper.TableCount: Integer;
begin
  Result := FTables.Count;
end;

{ TKisSearchConditions }

procedure TKisSearchConditions.Clear;
begin
  FValue1.Clear;
  FValue2.Clear;
  Field := nil;
  IsRange := False;
  CaseSencitive := False;
  Exact := False;
end;

constructor TKisSearchConditions.Create;
begin
  FValue1 := TValue.Create;
  FValue2 := TValue.Create;
  Clear;
end;

destructor TKisSearchConditions.Destroy;
begin

  inherited;
end;

function TKisSearchConditions.GetBottom: Variant;
begin
  if FIsRange then
    Result := FValue2.GetValue
  else
    raise Exception.Create(S_ISNT_RANGE);
end;

function TKisSearchConditions.GetConditionString: String;
var
  AFieldName: String;
begin
  if Field.FIsForeign then
    AFieldName := Field.FForeignTableName + '.'
  else
    if Field.GetTableName <> '' then
      AFieldName := Field.GetTableName + '.';
  if Field.FLookUp then
    AFieldName := AFieldName + Field.FLookUpKey
  else
    AFieldName := AFieldName + Field.FieldName;
  case Field.DataType of
  ftString, ftMemo, ftFmtMemo, ftFixedChar, ftWideString:
    begin
      if Empty then
        Result := '((' + AFieldName + ' IS NULL) OR (' + AFieldName + '=''''))'
      else
      begin
        AFieldName := 'CAST(' + AFieldName + ' AS VARCHAR(' + IntToStr(Field.DataSize)
          + ')) COLLATE PXW_CYRL';
        if Exact then
        begin
          Result := FValue1.GetValueStr
        end
        else
        begin
          Result := #32 + FValue1.GetValueStr + #32;
          while Pos('  ', Result) > 0 do
            Result := StringReplace(Result, '  ', ' ', [rfReplaceAll]);
          Result := StringReplace(Result, ' ', '%', [rfReplaceAll]);
        end;
        if not CaseSencitive then
        begin
          Result := AnsiUpperCase(Result);
          AFieldName := 'UPPER(' + AFieldName + ')';
        end;
        if Exact then
          Result := AFieldName + ' = ' + #39 + Result + #39
        else
          Result := AFieldName + ' LIKE ' + #39 + Result + #39;
      end;
    end;
  ftBlob :
    begin
      if Empty then
        Result := '((' + AFieldName + ' IS NULL) OR (' + AFieldName + '=''''))'
      else
      begin
        if Exact then
          Result := FValue1.GetValueStr
        else
        begin
          Result := #32 + FValue1.GetValueStr + #32;
          while Pos('  ', Result) > 0 do
            Result := StringReplace(Result, '  ', ' ', [rfReplaceAll]);
          Result := StringReplace(Result, ' ', '%', [rfReplaceAll]);
        end;
  {      if not CaseSencitive then
        begin
          Result := AnsiUpperCase(Result);
          AFieldName := 'UPPER(' + AFieldName + ')';
        end; }
        Result := AFieldName + ' LIKE ' + #39 + Result + #39;
      end;
    end;
  ftInteger, ftSmallInt, ftWord, ftFloat:
    begin
      if Empty then
        Result := '((' + AFieldName + ' IS NULL) OR (' + AFieldName + '=0))'
      else
        if IsRange then
          Result := AFieldName + ' BETWEEN ' + FValue1.GetValueStr + ' AND ' + FValue2.GetValueStr
        else
          Result := AFieldName + '=' + FValue1.GetValueStr;
    end;
  ftDate, ftDateTime:
    begin
      if Empty then
        Result := '(' + AFieldName + ' IS NULL)'
      else
        if IsRange then
          Result := AFieldName + ' BETWEEN ' + #39 + FValue1.GetValueStr
            + #39  + ' AND ' + #39  + FValue2.GetValueStr + #39
        else
          Result := AFieldName + '=' + #39  + FValue1.GetValueStr + #39;
    end;
  ftBoolean :
    begin
      Result := AFieldName + '=' + FValue1.GetValueStr;
    end;
  end;
  if Field.Table is TKisLinkedTable then
    with Field.Table as TKisLinkedTable do
    begin
      Result := 'EXISTS (SELECT * FROM ' + TableName + ' WHERE '
        + DetailField.FieldName + '=' + MasterField.FullName + ' AND ' + Result + ')';
    end;
end;

function TKisSearchConditions.GetTop: Variant;
begin
  if FIsRange then
    Result := FValue1.GetValue
  else
    raise Exception.Create(S_ISNT_RANGE);
end;

function TKisSearchConditions.GetValue: Variant;
begin
  if not FIsRange then
    Result := FValue1.GetValue
  else
    raise Exception.Create(S_ISNT_RANGE);
end;

procedure TKisSearchConditions.SetBottom(const Value: Variant);
begin
  if FIsRange then
    FValue2.SetValue(Field.DataType, Value)
  else
    raise Exception.Create(S_ISNT_RANGE);
end;

procedure TKisSearchConditions.SetTop(const Value: Variant);
begin
  if FIsRange then
    FValue1.SetValue(Field.DataType, Value)
  else
    raise Exception.Create(S_ISNT_RANGE);
end;

procedure TKisSearchConditions.SetValue(const Value: Variant);
begin
  if not FIsRange then
    FValue1.SetValue(Field.DataType, Value)
  else
    raise Exception.Create(S_ISNT_RANGE);
end;

{ TValue }

procedure TValue.Clear;
begin

end;

function TValue.GetValue: Variant;
begin
  case FType of
  ftString, ftMemo, ftFmtMemo, ftFixedChar, ftWideString, ftBlob:
    begin
      Result := FString;
    end;
  ftSmallint, ftInteger, ftWord:
    begin
      Result := FInteger;
    end;
  ftBoolean:
    begin
      Result := FBoolean;
    end;
  ftFloat:
    begin
      Result := FDouble;
    end;
  ftDate, ftDateTime:
    begin
      Result := FDateTime;
    end;
  end;
end;

function TValue.GetValueStr: String;
begin
  case FType of
  ftString, ftMemo, ftFmtMemo, ftFixedChar, ftWideString, ftBlob:
    begin
      Result := FString;
    end;
  ftSmallint, ftInteger, ftWord:
    begin
      Result := IntToStr(FInteger);
    end;
  ftBoolean:
    begin
      Result := IntToStr(Integer(FBoolean));
    end;
  ftFloat:
    begin
      Result := FloatToStr(FDouble);
    end;
  ftDate, ftDateTime:
    begin
      Result := FormatDateTime(S_DATESTR_FORMAT, FDateTime);
    end;
  end;
end;

procedure TValue.SetValue(AType: TFieldType; const AValue: Variant);
begin
  case AType of
  ftString, ftMemo, ftFmtMemo, ftFixedChar, ftWideString, ftBlob:
    begin
      FString := AValue;
    end;
  ftSmallint, ftInteger, ftWord:
    begin
      FInteger := AValue;
    end;
  ftBoolean:
    begin
      FBoolean := AValue;
    end;
  ftFloat:
    begin
      FDouble := AValue;
    end;
  ftDate, ftDateTime:
    begin
      FDateTime := AValue;
    end;
  else
    raise EAbort.Create(S_UNSUPPORTED_FIELD_TYPE);
  end;
  FType := AType;
end;

{ TKisTransactionStack }

constructor TKisTransactionStack.Create;
begin
  inherited;
  FList := TList.Create;
end;

destructor TKisTransactionStack.Destroy;
begin
  FList.Free;
  inherited;
end;

function TKisTransactionStack.GetTransaction: TIBTransaction;
begin
  if FList.Count > 0 then
    Result := TIBTransaction(FList.Last)
  else
    Result := nil;
end;

procedure TKisTransactionStack.Pop;
begin
  if FList.Count > 0 then
    FList.Delete(Pred(FList.Count));
end;

procedure TKisTransactionStack.Push(ATransaction: TIBTransaction);
begin
  FList.Add(ATransaction);
end;

function TKisSQLMngr.GetDefaultTransaction: TIBTransaction;
begin
  Result := FTransactionStack.Transaction;
end;

procedure TKisSQLMngr.IntShowEntities(aFilters: IKisFilters; StartID: Integer);
begin
  if not Assigned(FView) then
  begin
    CreateView;
    FView.Grid.OnDblClick := ViewGridDblClick;
    FView.Grid.OnMouseUp := ViewGridMouseUp;
    InSearch := False;
  end
  else
    FView.BringToFront;
  ApplyFilters(aFilters, True);
  if Active then
    Reopen
  else
    Active := True;
  if StartID > 0 then
    Locate(StartID);
  FView.FormStyle := fsMDIChild;
  ReadViewState;
  FView.ButtonsPanel.Visible := False;
end;

procedure TKisSQLMngr.SetDefaultTransaction(const Value: TIBTransaction);
begin
  if Assigned(Value) then
    FTransactionStack.Push(Value)
  else
    FTransactionStack.Pop;
end;

procedure TKisSQLMngr.acSortOrderExecute(Sender: TObject);
begin
  inherited;
  if FSQLHelper.SortDialog then
    Reopen;
end;

procedure TKisSQLMngr.acStartSearchExecute(Sender: TObject);
begin
  InSearch := True;
end;

procedure TKisSQLMngr.acStopSearchExecute(Sender: TObject);
begin
  inherited;
  InSearch := False;
end;

procedure TKisSQLMngr.acStopSearchUpdate(Sender: TObject);
begin
  inherited;
  acStopSearch.Enabled := InSearch;
end;

procedure TKisSQLMngr.acInsertExecute(Sender: TObject);
begin
  with KisObject(CreateNewEntity(keDefault)) do
  begin
    if AEntity is TKisVisualEntity then
    if TKisVisualEntity(AEntity).Edit then
    begin
      SaveEntity(AEntity);
      Reopen;
      Locate(AEntity.ID);
    end;
  end;
end;

procedure TKisSQLMngr.acDeleteExecute(Sender: TObject);
var
  CanDelete: Boolean;
  DataSet: TDataSet;
  ID: Integer;
  UpOrDown: Boolean;
begin
  ID := -1;
  with KisObject(CurrentEntity) do
  begin
    if Assigned(FView) then
    begin
      CanDelete := MessageBox(FView.Handle, PChar(S_CONFIRM_DELETE_RECORD), PChar(S_CONFIRM), MB_YESNO + MB_ICONQUESTION) = ID_YES;
      if CanDelete then
      begin
        DataSet := DataSource.DataSet;
        if DataSet.Active then
        begin
          DataSet.DisableControls;
          try
            UpOrDown := True;
            DataSet.Prior;
            if DataSet.Bof then
            begin
              DataSet.MoveBy(2);
              UpOrDown := False;
            end;
            ID := DataSet.FieldByName(SF_ID).AsInteger;
            if UpOrDown then
              DataSet.Next
            else
              DataSet.Prior;
          finally
            DataSet.EnableControls;
          end;
        end
      end;
    end
    else
      CanDelete := True;
    if CanDelete then
    begin
      if DeleteEntity(AEntity) then
        if Assigned(FView) then
        begin
          Reopen;
          Locate(ID);
        end;
    end;
  end;
end;

procedure TKisSQLMngr.ViewGridDblClick(Sender: TObject);
var
  Gc: TGridCoord;
begin
  if Assigned(FView) then
  begin
    Gc := FView.Grid.MouseCoord(FX, FY);
    if (Gc.X > N_ZERO) and (Gc.Y > N_ZERO) then
      acEditExecute(Self);
  end;
end;

procedure TKisSQLMngr.ViewGridMouseUp(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  if Assigned(FView) then
  begin
    FX := X;
    FY := Y;
  end;
end;

procedure TKisSQLMngr.acEditExecute(Sender: TObject);
begin
  EditCurrent;
  DataSource.DataSet.Refresh;
end;

procedure TKisSQLMngr.acInsertUpdate(Sender: TObject);
begin
  inherited;
  acInsert.Enabled := Assigned(DataSource.DataSet) and DataSource.DataSet.Active;
end;

procedure TKisSQLMngr.acDeleteUpdate(Sender: TObject);
begin
  inherited;
  acDelete.Enabled := Assigned(DataSource.DataSet) and DataSource.DataSet.Active
    and not DataSource.DataSet.IsEmpty;
end;

procedure TKisSQLMngr.acEditUpdate(Sender: TObject);
begin
  inherited;
  acEdit.Enabled := Assigned(DataSource.DataSet) and DataSource.DataSet.Active
    and not DataSource.DataSet.IsEmpty;
end;

procedure TKisSQLMngr.RestoreFilters;
begin
  RemoveFiltersSQL;
  AddFiltersSQL;
end;

destructor TKisSQLMngr.Destroy;
begin
  if Self.Active then
    Self.Active := False;
  inherited;
end;

procedure TKisSQLMngr.CancelFilters(aFilters: IKisFilters);
var
  Clause: TWhereClause;
  J: Integer;
  NeedReopen: Boolean;
begin
  if Assigned(aFilters) and (aFilters.Count > 0) then
  begin
    Clause := FSQLHelper.Parser.Where;
    NeedReopen := False;
    for J := aFilters.Count - 1 downto 0 do
    begin
      NeedReopen := ProcessSQLFilter(aFilters[J], foRemoveSQL, Clause) or NeedReopen;
      FFilters.Remove(FFilters.Find((aFilters[J] as IKisNamedObject).Name));
    end;
    if NeedReopen and MainDataSet.Active then
      Reopen;
  end;
end;

procedure TKisSQLMngr.CheckDefaultTransaction;
begin
  if not Assigned(Self.DefaultTransaction) then
    raise Exception.CreateFmt(S_DEFAULT_TRANSACTION_MISSED, [Self.ClassName]);
end;

procedure TKisSQLMngr.DoUserSearch(const Str: String; Field: TField);
begin
  if (Str <> '') and (Assigned(Field)) and (Length(Str) <= Field.Size) then
     if Assigned(DataSource.DataSet) and DataSource.DataSet.Active then
        DataSource.DataSet.Locate(Field.FieldName, Str, [loCaseInsensitive, loPartialKey]);
end;

procedure TKisSQLMngr.OnColEnter(Sender: TObject);
var
  S, ATableName, AFieldName: String;
  I: Integer;
  Enabled: Boolean;
  aTable: TKisTable;
  aFld: TKisField;
begin
  S := StringReplace(FView.Grid.SelectedField.Origin, '"', '', [rfReplaceAll]);
  I := Pos('.', S);
  if I > 0 then
  begin
    ATableName := Copy(S, 1, Pred(I));
    AFieldName := Copy(S, Succ(I), Length(S) - I);
  end;
  if Assigned(FView) and FView.Visible then
  begin
    aTable := FSQLHelper.TableByName(ATableName);
    Enabled := Assigned(aTable);
    if Enabled then
    begin
      aFld := aTable.FieldByName(AFieldName);
      Enabled := Assigned(aFld) and (fpQuickSearch in aFld.Params);
    end
    else
      aFld := nil;
    FView.QuickSearchEnabled := Enabled;
    if Enabled then
       FView.LabelSearchField.Caption := '   ' + aFld.FieldLabel
    else
       FView.LabelSearchField.Caption := '       ';
  end;
end;

procedure TKisSQLMngr.acFirstNavExecute(Sender: TObject);
var
   S: String;
begin
  inherited;
  S := FView.edSearch.Text;
  DoUserSearch(S, FView.Grid.SelectedField);
end;

procedure TKisSQLMngr.acFirstNavUpdate(Sender: TObject);
begin
  acFirstNav.Enabled := (Assigned(FView) and FView.QuickSearchEnabled
    and (DataSource.DataSet.Active) and (FView.edSearch.Text <> ''));
end;

procedure TKisSQLMngr.acNextNavExecute(Sender: TObject);
var
  S: String;
begin
  inherited;
  S := FView.edSearch.Text;
  TIBCustomDataset(DataSource.DataSet).LocateNext(FView.Grid.SelectedField.FieldName, S, [loCaseInsensitive, loPartialKey]);
end;

procedure TKisSQLMngr.acPriorNavExecute(Sender: TObject);
var
  S: String;
  Mark: TBookMark;
  Found: Boolean;
begin
  inherited;
  S := FView.edSearch.Text;
  Mark := DataSource.DataSet.GetBookmark;
  Found := False;
  DataSource.DataSet.DisableControls;
  try
    DataSource.DataSet.Prior;
    while not DataSource.DataSet.Bof do
    begin
      Found := Pos(AnsiUpperCase(S), AnsiUpperCase(FView.Grid.SelectedField.AsString)) = 1;
      if Found then Break;
      DataSource.DataSet.Prior;
    end;
    if not Found then DataSource.DataSet.GotoBookmark(Mark);
    DataSource.DataSet.FreeBookmark(Mark);
  finally
     DataSource.DataSet.EnableControls
  end;
end;

procedure TKisSQLMngr.acLastNavExecute(Sender: TObject);
var
  S: String;
  Mark: TBookMark;
  Found: Boolean;
begin
  inherited;
  S := FView.edSearch.Text;
  Mark := DataSource.DataSet.GetBookmark;
  Found := False;
  DataSource.DataSet.DisableControls;
  try
    DataSource.DataSet.Last;
    while not DataSource.DataSet.Bof do
    begin
      Found := Pos(AnsiUpperCase(S), AnsiUpperCase(FView.Grid.SelectedField.AsString)) = 1;
      if Found then Break;
      DataSource.DataSet.Prior;
    end;
    if not Found then DataSource.DataSet.GotoBookmark(Mark);
    DataSource.DataSet.FreeBookmark(Mark);
  finally
     DataSource.DataSet.EnableControls
  end;
end;

procedure TKisSQLMngr.acPriorNavUpdate(Sender: TObject);
begin
  acPriorNav.Enabled :=
    Assigned(FView)
    and
    (DataSource.DataSet.Active)
    and
    FView.QuickSearchEnabled
    and
    (FView.edSearch.Text <> '');
end;

procedure TKisSQLMngr.acNextNavUpdate(Sender: TObject);
begin
  acNextNav.Enabled :=
    Assigned(FView)
    and
    DataSource.DataSet.Active
    and
    FView.QuickSearchEnabled
    and
    (FView.edSearch.Text <> '');
end;

procedure TKisSQLMngr.acLastNavUpdate(Sender: TObject);
begin
  acLastNav.Enabled :=
    Assigned(FView)
    and
    DataSource.DataSet.Active
    and
    FView.QuickSearchEnabled
    and
    (FView.edSearch.Text <> '');
end;

procedure TKisSQLMngr.OnFilterRecord(DataSet: TDataSet; var Accept: Boolean);
var
  S1, S2: string;
begin
  if Assigned(FView) and (FView.cbFilterFields.ItemIndex >= 0) and (FView.edFilter.Text <> '') then
  begin
    S1 := AnsiUpperCase(FView.edFilter.Text);
    S2 := AnsiUpperCase(TField(FView.cbFilterFields.Items.Objects[FView.cbFilterFields.ItemIndex]).AsString);
    Accept := Pos(S1, S2) = 1;
  end
  else
    Accept := True;
end;

procedure TKisSQLMngr.OnSetFilter(Sender: TObject);
begin
  DataSource.DataSet.Filtered := FView.cbSetFilter.Checked;
end;

procedure TKisSQLMngr.Activate;
begin
  DataSource.DataSet.OnFilterRecord := OnFilterRecord;
end;

procedure TKisSQLMngr.ApplyFilters(aFilters: IKisFilters;
  ClearExisting: Boolean);
var
  B: Boolean;
begin
  B := False;
  if ClearExisting then
  begin
    RemoveFiltersSQL;
    FFilters.Clear;
    B := True;
  end;
  B := FFilters.Update(aFilters) or B;
  if B then
  begin
    if not ClearExisting then
      RemoveFiltersSQL;
    AddFiltersSQL;
    if MainDataSet.Active then
    begin
      MainDataSet.DisableControls;
      try
        Reopen;
      finally
        MainDataSet.EnableControls;
      end;
    end;
  end;
end;

procedure TKisSQLMngr.Deactivate;
begin
  DataSource.DataSet.OnFilterRecord := nil;
end;

procedure TKisSQLMngr.OnFilterTextChange(Sender: TObject);
begin
  if DataSource.DataSet.Filtered then
  ;
end;

procedure TKisSQLMngr.edFilterEnterPress(Sender: TObject; var Key: Char);
begin
  if Key = #13 then
  begin
    DataSource.DataSet.Close;
    DataSource.DataSet.Filtered := True;
    if Assigned(FView) then FView.cbSetFilter.Checked := True;
    DataSource.DataSet.Open;
  end;
end;

procedure TKisSQLMngr.SetTransactionToMngr(AMngr: TKisSQLMngr);
begin
  if Assigned(Self.DefaultTransaction) then
    AMngr.DefaultTransaction := Self.DefaultTransaction;
end;

procedure TKisSQLMngr.FreeTransactionFromMngr(AMngr: TKisSQLMngr);
begin
  if Assigned(Self.DefaultTransaction) and
    (AMngr.DefaultTransaction = Self.DefaultTransaction)
  then
    AMngr.DefaultTransaction := nil;
end;

{ TKisSQLEntity }

function TKisSQLEntity.GetSQLMngr: TKisSQLMngr;
begin
  Result := Manager as TKisSQLMngr;
end;

procedure TKisSQLMngr.PrepareMaindataSet;
var
  DataSet: TDataSet;
begin
  DataSet := MainDataSet;
  if Assigned(DataSet) then
  begin
    DataSet.AfterOpen := MainDataSetAfterOpen;
    DataSet.BeforeClose := MainDataSetBeforeClose;
    DataSet.BeforeOpen := MainDataSetBeforeOpen;
  end;
end;

procedure TKisSQLMngr.MainDataSetAfterOpen(DataSet: TDataSet);
begin
  ReadViewState;
  if Assigned(FView) and (FSelFieldName <> '') and Assigned(MainDataSet) then
  begin
    FView.Grid.SelectedField := MainDataSet.FieldByName(FSelFieldName);
  end;
end;

procedure TKisSQLMngr.MainDataSetBeforeClose(DataSet: TDataSet);
begin
  WriteViewState;
  if Assigned(FView) and Assigned(FView.Grid.SelectedField) then
  begin
    FSelFieldName := FView.Grid.SelectedField.FieldName;
  end;
end;

procedure TKisSQLMngr.MainDataSetBeforeOpen(
  DataSet: TDataSet);
begin
  if MainDataSet is TIBCustomDataSet then
  with TIBDataSet(MainDataSet) do
  begin
    SelectSQL.Text := FSQLHelper.SQL;
    RefreshSQL.Text := GetRefreshSQLText;
    AppModule.LogSQL(SelectSQL.Text);
  end;
end;

{ TKisConnection }

procedure TKisSQLMngr.TKisIBConnection.Commit(StayActive: Boolean);
begin
  if StayActive then
    FTransaction.CommitRetaining
  else
    FTransaction.Commit;
end;

constructor TKisSQLMngr.TKisIBConnection.Create(AOwner: TComponent);
begin
  inherited;
  FDataSets := TDataSetList.Create(True);
end;

destructor TKisSQLMngr.TKisIBConnection.Destroy;
begin
  FreeAndNil(FDataSets);
  inherited;
end;

function TKisSQLMngr.TKisIBConnection.GetDataSet(const SQLText: String): TDataSet;
begin
  Result := TIBQuery.Create(Self);
  with TIBQuery(Result) do
  begin
    Transaction := FTransaction;
    SQL.Text := SQLText;
    BufferChunks := 10;
    FDataSets.Add(TKisDataSet.Create(Result));
//    FreeNotification(Result);
    Result.BeforeOpen := OpenDataSet;
  end;
end;

function TKisSQLMngr.TKisIBConnection.GetOnNeedParam(
  DataSet: TDataSet): TKisConnectionNeedParam;
var
  I: Integer;
begin
  if Assigned(FDataSets) then
  begin
    I := FDataSets.IndexOfDataSet(DataSet);
    if I >= 0 then
      Result := FDataSets[I].ParamHandler
    else
      Result := nil;
  end;
end;

function TKisSQLMngr.TKisIBConnection.GetParam(DataSet: TDataSet;
  const ParamName: String): TParam;
begin
  if Assigned(FDataSets) then
    Result := TIBQuery(DataSet).ParamByName(ParamName)
  else
    Result := nil;
end;

function TKisSQLMngr.TKisIBConnection.NeedBack: Boolean;
begin
  Result := FNeedBack;
end;

function TKisSQLMngr.TKisIBConnection.NeedCommit: Boolean;
begin
  Result := FNeedCommit;
end;

procedure TKisSQLMngr.TKisIBConnection.Notification(AComponent: TComponent;
  Operation: TOperation);
var
  I: Integer;
begin
  inherited Notification(AComponent, Operation);
  if Operation = opRemove then
  begin
    if Assigned(FDataSets) then
    begin
      I := FDataSets.IndexOfDataSet(TDataSet(AComponent));
      if I >= 0 then
        FDataSets.Delete(I);
    end;
  end
  else
    FreeNotification(AComponent);
end;

procedure TKisSQLMngr.TKisIBConnection.OpenDataSet(DataSet: TDataSet);
var
  I: Integer;
  V: Variant;
  Handler: TKisConnectionNeedParam;
  Q: TIBQuery;
begin
  if not Assigned(FDataSets) then
    Exit;
  I := FDataSets.IndexOfDataSet(DataSet);
  if I >= 0 then
  begin
    Handler := FDataSets[I].FParamHandler;
    if Assigned(Handler) then
    begin
      Q := DataSet as TIBQuery;
      for I := 0 to Pred(Q.ParamCount) do
      begin
        Handler(Q.Params[I].Name, V);
        Q.Params[I].Value := V;
      end;
    end;
  end;
end;

procedure TKisSQLMngr.TKisIBConnection.PrepareDataSet(DataSet: TDataSet);
begin
  if not Assigned(FDataSets) then
    Exit;
  TIBQuery(DataSet).Prepare;
end;

procedure TKisSQLMngr.TKisIBConnection.RollBack(StayActive: Boolean);
begin
  if FTransaction.Active then
    if StayActive then
      FTransaction.RollBackRetaining
    else
      FTransaction.RollBack;
end;

procedure TKisSQLMngr.TKisIBConnection.SetBlobParam(DataSet: TDataSet;
  const ParamName: String; Stream: TStream);
begin
  if not Assigned(FDataSets) then
    Exit;
  if Assigned(Stream) then
    TIBQuery(DataSet).ParamByName(ParamName).LoadFromStream(Stream, ftBlob);
end;

procedure TKisSQLMngr.TKisIBConnection.SetOnNeedParam(DataSet: TDataSet;
  const Value: TKisConnectionNeedParam);
var
  I: Integer;
begin
  if not Assigned(FDataSets) then
    Exit;
  I := FDataSets.IndexOfDataSet(DataSet);
  if I >= 0 then
    FDataSets[I].ParamHandler := Value;
end;

procedure TKisSQLMngr.TKisIBConnection.SetParam(DataSet: TDataSet;
  const ParamName: String; const Value: Variant);
begin
  if not Assigned(FDataSets) then
    Exit;
  TIBQuery(DataSet).ParamByName(ParamName).Value := Value;
end;

function TKisSQLMngr.TKisIBConnection.Transaction: TIBTransaction;
begin
  Result := FTransaction;
end;

procedure TKisSQLMngr.TKisIBConnection.UnPrepareDataSet(DataSet: TDataSet);
begin
  if not Assigned(FDataSets) then
    Exit;
  TIBQuery(DataSet).UnPrepare;
end;

constructor TKisSQLMngr.TKisIBConnection.CreateConnection(AOwner: TComponent; Trans: TIBTransaction;
  aNeedCommit, aNeedBack: Boolean);
begin
  inherited Create(AOwner);
  FTransaction := Trans;
  FNeedCommit := aNeedCommit;
  FNeedBack := aNeedBack;
  FDataSets := TDataSetList.Create(True);
end;

{ TDataSetList }

function TDataSetList.GetItem(Index: Integer): TKisDataSet;
begin
  Result := TKisDataSet(inherited GetItem(Index));
end;

function TDataSetList.IndexOfDataSet(DataSet: TDataSet): Integer;
var
  I: Integer;
begin
  for I := 0 to Pred(Count) do
    if Items[I].DataSet = DataSet then
    begin
      Result := I;
      Exit;
    end;
  Result := -1;
end;

procedure TDataSetList.SetItem(Index: Integer; DataSet: TKisDataSet);
begin
  inherited SetItem(Index, DataSet);
end;

{ TKisDataSet }

constructor TKisDataSet.Create(ADataSet: TDataSet);
begin
  FdataSet := ADataSet;
end;

destructor TKisDataSet.Destroy;
begin
  FreeAndNil(FDataSet);
  inherited;
end;

{ TKisEntitySaver }

constructor TKisEntitySaver.Create(Connection: IKisConnection);
begin
  inherited Create;
  FConnection := Connection;
end;

procedure TKisEntitySaver.InternalSave;
var
  DataSet: TDataSet;
begin
  DataSet := FConnection.GetDataSet(GetSQL);
  PrepareParams(DataSet);
  DataSet.Open;
end;

procedure TKisEntitySaver.PrepareParams(DataSet: TDataSet);
begin
  // 
end;

procedure TKisEntitySaver.Save(Entity: TKisEntity);
begin
  FEntity := Entity;
  InternalSave;
  FEntity := nil;
end;

{ TKisSearch }

destructor TKisSearch.Destroy;
begin
  if Assigned(FMngr) then
    if Assigned(FConn) then
      FMngr.FreeConnection(FConn, False, False);
  FConn := nil;
  FMngr := nil;
  inherited;
end;

end.

