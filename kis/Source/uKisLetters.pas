{*******************************************************}
{                                                       }
{       "ИС МП УГА"                                     }
{       Менеджер корреспонденции                        }
{                                                       }
{       Copyright (c) 2004-2005, МП УГА                 }
{                                                       }
{       Автор: Калабухов А.В., Сирота Е.А.              }
{                                                       }
{*******************************************************}

{ Описание: реализует операции над корреспонденцией
  Имя модуля: Letters
  Версия:     1.09
  Дата последнего изменения: 24.08.2005
  Цель: модуль содержит реализации классов менеджера корреспонденции, письма,
        визы, элемента движения письма, адреса объекта, связи заказ-письмо,
        связи документа отдела-письмо.
  Используется: AppModule
  Использует: Kernel Classes
  Исключения: нет }
{
  1.09      24.08.2005
     - переписано сохранение письма;
       теперь сохраняются только изменившиеся части, удаляются только удаленные записи и т.п.
     - используются только новые методы работы с БД - GetConnection и FreeConnection

  1.08      30.06.2005
     - исправлена ошибка в создании документа отдела - при нажатии "Отмена" документ добавлялся в письмо
     - добавлен класс TKisLetterBuilder
     - переписан метод TKisLetter.Load, добавлены методы загрузки контроллеров

  1.07      16.06.2005
     - устранено двойное переоткрытие датасетов при выходе из поиска
     - изменена работа с dsCandidates (если пользователь не может с ним работать,
       то он не будет открываться)

  1.06      10.06.2005
     - изменена работа с документами отделов - см. методы
          TKisLetter.AttachOfficeDoc
          TKisLetter.CreateOfficeDocInterface
     - удален метод TKisLetterMngr.SaveOfficeDoc 

  1.05      22.04.2005
     - использованы новые методы работы с главным датасетом

  1.04      30.03.2005
     - изменена длина поля ORG_NUMBER

  1.03
     - в методе TKisLetter.PrepareEditor добавлена активация/деактивация кнопок
       управления исходящими письмами
     - удалены неиспользуемые перменные
     
  1.02
     - метод Reopen изменен из-за реализации унаследованного
}

unit uKisLetters;

{$I KisFlags.pas}

interface

uses
  // System
  Windows, SysUtils, Variants, Classes, Graphics, Controls, Forms, DB, Menus,
  ImgList, ActnList, Contnrs, IBDatabase, Grids, DBGrids, IBCustomDataSet,
  // Common
  uDataSet, uSQLParsers,
  // Project
  uKisClasses, uKisAppModule, uKisEntityEditor, uKisSQLClasses, uKisStreets,
  uKisFilters;

type
  EKisLetterError = class(Exception);

  EKisLetterNumberExists = class(EKisLetterError);

  EKisLetterMPNumberExists = class(EKisLetterNumberExists);
  EKisLetterKGANumberExists = class(EKisLetterNumberExists);

  // адрес объекта
  TKisLetterObjAddress = class(TKisEntity)
  private
    FAddress: String;
    procedure SetAddress(const Value: String);
    function GetAddress: String;
  protected
    {$IFDEF ENTPARAMS}
    procedure InitParams; override;
    {$ENDIF}
    function GetText: String; override;
  public
    class function EntityName: String; override;
    procedure Load(DataSet: TDataSet); override;
    function IsEmpty: Boolean; override;
    procedure Copy(Source: TKisEntity); override;
    function Equals(Entity: TKisEntity): Boolean; override;
    property Address: String read GetAddress write SetAddress;
  end;

  TLetterObjAddressController = class(TKisEntityController)
  public
    procedure FillFieldDefs(FieldDefsRef: TFieldDefs); override;
    function GetFieldData(Index: Integer; Field: TField; out Data): Boolean; override;
    procedure SetFieldData(Index:integer; Field: TField; var Data); override;
    function GetDeleteQueryText: String; override;
  end;

  // виза
  TKisLetterVisa = class(TKisVisualEntity)
  private
    procedure SetContent(const Value: String);
    procedure SetControlDate(const Value: String);
    procedure SetDocDate(const Value: String);
    procedure SetSignature(const Value: String);
    function GetDocDate: String;
    function GetControlDate: String;
    function GetContent: String;
    function GetSignature: String;
  protected
    {$IFDEF ENTPARAMS}
    procedure InitParams; override;
    {$ENDIF}
    function GetText: String; override;
    function CreateEditor: TKisEntityEditor; override;
    procedure PrepareEditor(AEditor: TKisEntityEditor); override;
    procedure LoadDataIntoEditor(AEditor: TKisEntityEditor); override;
    procedure ReadDataFromEditor(AEditor: TKisEntityEditor); override;
    function CheckEditor(AEditor: TKisEntityEditor): Boolean; override;
  public
    class function EntityName: String; override;
    function IsEmpty: Boolean; override;
    procedure Load(DataSet: TDataSet); override;
    property DocDate: String read GetDocDate write SetDocDate;
    property ControlDate: String read GetControlDate write SetControlDate;
    property Content: String read GetContent write SetContent;
    property Signature: String read GetSignature write SetSignature;
  end;

  TLetterVisaCtrlr = class(TKisEntityController)
  public
    procedure FillFieldDefs(FieldDefsRef: TFieldDefs); override;
    function GetFieldData(Index: Integer; Field: TField; out Data): Boolean; override;
    procedure SetFieldData(Index: Integer; Field: TField; var Data); override;
    function GetDeleteQueryText: String; override;
  end;

  // элемент движения
  TKisLetterPassing = class(TKisVisualEntity)
  private
    FPeopleLink: TKisEntity;
    FOfficeLink: TKisEntity;
    procedure SetContent(const Value: String);
    procedure SetDocDate(const Value: String);
    procedure SetOfficesId(const Value: SmallInt);
    procedure SetPeopleId(const Value: Integer);
    function GetOfficeShortName: String;
    function GetOfficesId: SmallInt;
    function GetPeopleId: Integer;
    function GetPeopleFullName: String;
    function GetContent: String;
    function GetDocDate: String;
    procedure SetOfficesList(AList: TStrings);
    procedure SetPeopleList(AList: TStrings);
    procedure OfficeChange(Sender: TObject);
    function GetExecuted: Boolean;
    procedure SetExecuted(const Value: Boolean);
    function GetOrgsId: Integer;
  protected
    {$IFDEF ENTPARAMS}
    procedure InitParams; override;
    {$ENDIF}
    function GetText: String; override;
    function CreateEditor: TKisEntityEditor; override;
    procedure PrepareEditor(AEditor: TKisEntityEditor); override;
    procedure UnprepareEditor(AEditor: TKisEntityEditor); override;
    procedure LoadDataIntoEditor(AEditor: TKisEntityEditor); override;
    procedure ReadDataFromEditor(AEditor: TKisEntityEditor); override;
    function CheckEditor(AEditor: TKisEntityEditor): Boolean; override;
  public
    constructor Create(AMngr: TKisMngr); override;
    destructor Destroy; override;
    class function EntityName: String; override;
    procedure Copy(Source: TKisEntity); override;
    procedure Load(DataSet: TDataSet); override;
    property DocDate: String read GetDocDate write SetDocDate;
    property Content: String read GetContent write SetContent;
    property Executed: Boolean read GetExecuted write SetExecuted;
    property OfficesId: SmallInt read GetOfficesId write SetOfficesId;
    property PeopleId: Integer read GetPeopleId write SetPeopleId;
    property OfficeShortName: String read GetOfficeShortName;
    property PeopleFullName: String read GetPeopleFullName;
    property OrgsId: Integer read GetOrgsId;
  end;

  TLetterPassingCtrlr = class(TKisEntityController)
  public
    procedure FillFieldDefs(FieldDefsRef: TFieldDefs); override;
    function GetFieldData(Index: Integer; Field: TField; out Data): Boolean; override;
    procedure SetFieldData(Index: Integer; Field: TField; var Data); override;
    function GetDeleteQueryText: String; override;
  end;

  TLetterParentPassingCtrlr = class(TKisEntityController)
  public
    procedure FillFieldDefs(FieldDefsRef: TFieldDefs); override;
    function GetFieldData(Index: Integer; Field: TField; out Data): Boolean; override;
    procedure SetFieldData(Index: Integer; Field: TField; var Data); override;
  end;

  // письмо
  // связь документ отдела-письмо
  TKisLetterOfficeDoc = class(TKisEntity)
  private
    FOfficeLink: TKisEntity;
    FPeopleLink: TKisEntity;
    FExecutorDate: String;
    function GetOfficeId: Integer;
    function GetPeopleId: Integer;
    procedure SetOfficeId(const Value: Integer);
    procedure SetPeolpeId(const Value: Integer);
    function GetOfficeDocId: Integer;
    procedure SetOfficeDocId(const Value: Integer);
    function GetDocDate: String;
    procedure SetDocDate(const Value: String);
    function GetDocNumber: String;
    procedure SetDocNumber(const Value: String);
    function GetExecutorDate: String;
  protected
    {$IFDEF ENTPARAMS}
    procedure InitParams; override;
    {$ENDIF}
  public
    class function EntityName: String; override;
    procedure Copy(Source: TKisEntity); override;
    procedure Load(DataSet: TDataSet); override;
    property PeopleId: Integer read GetPeopleId write SetPeolpeId;
    property OfficeId: Integer read GetOfficeId write SetOfficeId;
    property People: TKisEntity read FPeopleLink;
    property Office: TKisEntity read FOfficeLink;
    property OfficeDocId: Integer read GetOfficeDocId write SetOfficeDocId;
    property DocDate: String read GetDocDate write SetDocDate;
    property DocNumber: String read GetDocNumber write SetDocNumber;
    property ExecutorDate: String read GetExecutorDate;
  end;

  TLetterOfficeDocController = class(TKisEntityController)
    procedure FillFieldDefs(FieldDefsRef: TFieldDefs); override;
    function GetFieldData(Index: Integer; Field: TField; out Data): Boolean; override;
    procedure SetFieldData(Index:integer; Field: TField; var Data); override;
  public
    function GetDeleteQueryText: String; override;
  end;

  //исходящее письмо
  TKisOutcomLetter = class(TKisEntity)
  private
    FSeqNumber: String;
    FNumber: String;
    FDateReg: String;
    FFirmId: Integer;
    FFirm: String;
    FOutcomLetterId: Integer;
    procedure SetSeqNumber(const Value: String);
    procedure SetNumber(const Value: String);
    procedure SetDateReg(const Value: String);
    procedure SetFirmId(const Value: Integer);
    procedure SetFirm(const Value: String);
    procedure SetOutcomLetterId(const Value: Integer);
  protected
  public
    class function EntityName: String; override;
    procedure Copy(Source: TKisEntity); override;
    procedure Load(DataSet: TDataSet); override;
    property SeqNumber: String read FSeqNumber write SetSeqNumber;
    property Number: String read FNumber write SetNumber;
    property DateReg: String read FDateReg write SetDateReg;
    property FirmId: Integer read FFirmId write SetFirmId;
    property Firm: String read FFirm write SetFirm;
    property OutcomLetterId: Integer read FOutcomLetterId write SetOutcomLetterId;
  end;

   TOutcomLetterController = class(TKisEntityController)
    procedure FillFieldDefs(FieldDefsRef: TFieldDefs); override;
    function GetFieldData(Index: Integer; Field: TField; out Data): Boolean; override;
    procedure SetFieldData(Index:integer; Field: TField; var Data); override;
    function GetDeleteQueryText: String; override;
  end;

  TKisLetter = class(TKisSQLEntity)
  private
    FAddrCtrlr: TLetterObjAddressController;
    FVisasCtrlr: TLetterVisaCtrlr;
    FPassingCtrlr: TLetterPassingCtrlr;
    FParentPassingCtrlr: TLetterParentPassingCtrlr;
    FOfficeDocCtrlr: TLetterOfficeDocController;
    FOutcomLetterCtrlr: TOutcomLetterController;
    FDocTypesId: SmallInt;
    FOrgsId: Integer;
    FOfficesId: SmallInt;
    FOrgNumber: String;
    FOrgDate: String;
    FAdmNumber: String;
    FAdmDate: String;
    FFirmId: Integer;
    FContent: String;
    FExecuted: Boolean;
    FExecuteInfo: String;
    FControlDate: String;
    FAddresses: TCustomDataSet;
    FOfficesDocs: TCustomDataSet;
    FPassings: TCustomDataSet;
    FParentPassings: TCustomDataSet;
    FVisas: TCustomDataSet;
    FOutcomLetter: TCustomDataSet;
    FObjectTypeId: Integer;
    FParentId: Integer;
    FIsCandidate: Boolean;
    FSelector: TKisStreetSelector;
//    FControlDate2: String;
//    FExecuted2: Boolean;
    FOrderControlDate: TDateTime;
    FOrderStatus: Integer;
    function GetSelector: TKisStreetSelector;
    // Access methods
    procedure SetAdmDate(const Value: String);
    procedure SetAdmNumber(const Value: String);
    procedure SetContent(const Value: String);
    procedure SetControlDate(const Value: String);
    procedure SetDocDate(const Value: String);
    procedure SetDocNumber(const Value: String);
    procedure SetDocTypesId(const Value: SmallInt);
    procedure SetExecuted(const Value: Boolean);
    procedure SetExecuteInfo(const Value: String);
    procedure SetFirmName(const Value: String);
    procedure SetOfficesId(const Value: SmallInt);
    procedure SetOrgDate(const Value: String);
    procedure SetOrgNumber(const Value: String);
    procedure SetFirmId(const Value: Integer);
    procedure SetOrgsId(const Value: Integer);
    procedure SetMPNumber(const Value: String);
    procedure SetMPDate(const Value: String);
    procedure SetObjectTypeId(const Value: Integer);
    procedure SetParentId(const Value: Integer);
    function GetDocNumber: String;
    function GetDocDate: String;
    function GetFirmName: String;
    function GetMPDate: String;
    function GetMPNumber: String;
    function GetExecutor: String;
    procedure SetExecutor(const Value: String);

    // Access methods for datasets
    function GetAddresses: TDataSet;
    function GetOfficesDocs: TDataSet;
    function GetPassings: TDataSet;
    function GetParentPassings: TDataSet;
    function GetVisas: TDataSet;
    function GetOutcomLetter: TDataSet;
    // Event handlers for editor
    // Address
    procedure AddressInsert(DataSet: TDataSet);
    procedure AddressEdit(DataSet: TDataSet);
    //
    procedure PassingsInsert(DataSet: TDataSet);
    procedure PassingsBeforeDelete(DataSet: TDataSet);
    //
    procedure VisasInsert(DataSet: TDataSet);
    procedure VisasBeforeDelete(DataSet: TDataSet);
    //
    procedure EditPassingOrVisa(Sender: TObject);
    procedure EditPassings;
    procedure EditVisas;
    //
    procedure GenerateMPNumber(Sender: TObject);
    procedure UpdateMPNumber;
    procedure GenerateKGANumber(Sender: TObject);
    procedure UpdateKGANumber;
    //
    procedure DocTypeChange(Sender: TObject);
    //
    procedure SelectFirm(Sender: TObject);
    procedure ShowFirm(Sender: TObject);
    procedure ClearFirm(Sender: TObject);
    procedure UpdateFirm;
    //
    procedure CreateOfficeDoc(Sender: TObject);
    procedure DeleteOfficeDoc(Sender: TObject);
    procedure EditOfficeDoc(Sender: TObject);
    //
    //
    procedure CreateOutcomLetter(Sender: TObject);
    procedure EditOutcomLetter(Sender: TObject);
    //
    function DataSetEquals(DS1, DS2: TCustomDataSet): Boolean;
    procedure DBGridDrawColumnCell(Sender: TObject; const Rect: TRect;
      DataCol: Integer; Column: TColumn; State: TGridDrawState);
    function GetHasChild: Boolean;
    function GetHasCandidate: Boolean;
    function GetChildId: Integer;
    procedure EditorSetExecuted(Sender: TObject);

    function AddressesAsText: String;

    function CreateOfficeDocInterface(OfficeDoc: TKisEntity): TKisLetterOfficeDoc;
    procedure AttachOfficeDoc(AOfficeDoc: TKisEntity);
    procedure CopyMain(Source: TKisLetter);
    procedure CopyVisas(Source: TKisLetter);
    procedure CopyOfficeDocs(Source: TKisLetter);
    procedure CopyAddresses(Source: TKisLetter);
    procedure CopyPassings(Source: TKisLetter);
    procedure CopyParentPassings(Source: TKisLetter);
    procedure CopyOutcomings(Source: TKisLetter);

    procedure AddressOnCreateEditor(Sender: TObject; var aEditor: TInplaceEdit; var DefaultEditor: Boolean);
    procedure AddressOnEditorChange(Sender: TObject);
    procedure AddressOnEditorExit(Sender: TObject);
    procedure AddressOnEditorKeyPress(Sender: TObject; var Key: Char);

    property Selector: TKisStreetSelector read GetSelector;
    procedure SetControlDate2(const Value: String);
    procedure SetExecuted2(const Value: Boolean);
  protected
    {$IFDEF ENTPARAMS}
    procedure InitParams; override;
    {$ENDIF}
    function CreateEditor: TKisEntityEditor; override;
    function GetCaption: String; override;
    procedure PrepareEditor(Editor: TKisEntityEditor); override;
    procedure UnprepareEditor(Editor: TKisEntityEditor); override;
    procedure LoadDataIntoEditor(Editor: TKisEntityEditor); override;
    procedure ReadDataFromEditor(Editor: TKisEntityEditor); override;
    function GetText: String; override;
    function CheckEditor(Editor: TKisEntityEditor): Boolean; override;
  public
    constructor Create(Mngr: TKisMngr); override;
    destructor Destroy; override;
    class function EntityName: String; override;
    procedure Copy(Source: TKisEntity); override;
    function IsEmpty: Boolean; override;
    function Equals(Entity: TKisEntity): Boolean; override;
    procedure Load(DataSet: TDataSet); override;
    // Номер КГА
    property DocNumber: String read GetDocNumber write SetDocNumber;
    property DocDate: String read GetDocDate write SetDocDate;
    // Номер организации-отправитлея
    property OrgNumber: String read FOrgNumber write SetOrgNumber;
    property OrgDate: String read FOrgDate write SetOrgDate;
    // Номер администрации города
    property AdmNumber: String read FAdmNumber write SetAdmNumber;
    property AdmDate: String read FAdmDate write SetAdmDate;
    // Номер МП
    property MPNumber: String read GetMPNumber write SetMPNumber;
    property MPDate: String read GetMPDate write SetMPDate;
    // Тип документа
    property DocTypesId: SmallInt read FDocTypesId write SetDocTypesId;
    // Отправитель
    property FirmId: Integer read FFirmId write SetFirmId;
    property FirmName: String read GetFirmName write SetFirmName;
    // Параметры письма
    property Content: String read FContent write SetContent;
    property Executed: Boolean read FExecuted write SetExecuted;
//    property Executed2: Boolean read FExecuted2 write SetExecuted2;
    property ExecuteInfo: String read FExecuteInfo write SetExecuteInfo;
    property ControlDate: String read FControlDate write SetControlDate;
//    property ControlDate2: String read FControlDate2 write SetControlDate2;
    /// <summary>
    /// Организация-созатель
    /// </summary>
    property OrgsId: Integer read FOrgsId write SetOrgsId;
    /// <summary>
    /// Отдел-создатель
    /// </summary>
    property OfficesId: SmallInt read FOfficesId write SetOfficesId;
    /// <summary>
    /// ID статуса письма по его заказам - оплачен, заказы закрыты, просрочены и т.п.
    /// </summary>
    property OrderStatus: Integer read FOrderStatus;
    /// <summary>
    /// Контрольная дата, вычисляемая по заказам.
    /// </summary>
    property OrderControlDate: TDateTime read FOrderControlDate;
    property ObjectTypeId: Integer read FObjectTypeId write SetObjectTypeId;
    property ParentId: Integer read FParentId write SetParentId;
    property Executor: String read GetExecutor write SetExecutor;

    property Addresses: TDataSet read GetAddresses;
    property OfficesDocs: TDataSet read GetOfficesDocs;
    property Passings: TDataSet read GetPassings;
    property ParentPassings: TDataSet read GetParentPassings;
    property Visas: TDataSet read GetVisas;
    property OutcomLetter: TDataSet read GetOutcomLetter;

    property IsCandidate: Boolean read FIsCandidate write FIsCandidate;
    property HasChild: Boolean read GetHasChild;
    property HasCandidate: Boolean read GetHasCandidate;
  end;

  TKisLetterSaver = class(TKisEntitySaver)
  private
    procedure SaveContent(aLetter: TKisLetter);
  protected
    function GetSQL: String; override;
    procedure PrepareParams(DataSet: TDataSet); override;
    procedure InternalSave; override;
  end;

  TKisLetterMngr = class(TKisSQLMngr)
    dsLetters: TIBDataSet;
    dsLettersID: TIntegerField;
    dsLettersDOC_NUMBER: TIBStringField;
    dsLettersDOC_DATE: TDateTimeField;
    dsLettersORG_NUMBER: TIBStringField;
    dsLettersORG_DATE: TDateTimeField;
    dsLettersADM_NUMBER: TIBStringField;
    dsLettersADM_DATE: TDateTimeField;
    dsLettersDOC_TYPES_ID: TSmallintField;
    dsLettersFIRMS_ID: TIntegerField;
    dsLettersFIRM_NAME: TIBStringField;
    dsLettersCONTENT: TMemoField;
    dsLettersEXECUTED: TSmallintField;
    dsLettersEXECUTE_INFO: TIBStringField;
    dsLettersCONTROL_DATE: TDateTimeField;
    dsLettersOFFICES_ID: TSmallintField;
    dsLettersYEAR_NUMBER: TIBStringField;
    dsLettersINSERT_NAME: TIBStringField;
    dsLettersINSERT_TIME: TDateTimeField;
    dsLettersOBJECT_TYPE_ID: TIntegerField;
    dsLettersORGS_ID: TIntegerField;
    dsLettersDOC_TYPES_NAME: TIBStringField;
    dsLettersOFFICES_NAME: TIBStringField;
    dsLettersMP_NUMBER: TIBStringField;
    dsLettersMP_DATE: TDateField;
    dsLettersMP_YEAR_NUMBER: TIBStringField;
    dsLettersORG_NAME: TIBStringField;
    dsLettersIS_OVERDUE: TIntegerField;
    acLegend: TAction;
    dsCandidates: TIBDataSet;
    dsCandidatesSource: TDataSource;
    acEditCandidate: TAction;
    dsCandidatesPARENT_ID: TIntegerField;
    dsCandidatesDOC_NUMBER: TIBStringField;
    dsCandidatesDOC_DATE: TDateTimeField;
    dsCandidatesDOC_TYPES_ID: TSmallintField;
    dsCandidatesFIRM_NAME: TIBStringField;
    dsCandidatesDOC_TYPES_NAME: TStringField;
    dsCandidatesSEND_DATE: TDateTimeField;
    acPrint: TAction;
    pmPrint: TPopupMenu;
    dsLettersOBJECT_TYPE_NAME: TStringField;
    dsOrdersSource: TDataSource;
    dsOrders: TIBDataSet;
    dsOrdersID: TIntegerField;
    dsOrdersACT_DATE: TDateField;
    dsOrdersVAL_PERIOD: TSmallintField;
    dsOrdersPAY_DATE: TDateField;
    dsOrdersCHECKED: TSmallintField;
    dsOrdersORDER_NUMBER: TStringField;
    dsOrdersEXECUTOR: TStringField;
    dsOrdersDOC_NUMBER: TStringField;
    dsOrdersDOC_DATE: TDateField;
    dsOrdersEND_DATE: TDateField;
    dsLettersLETTER_STATUS: TSmallintField;
    dsLettersSTATUS_NAME: TIBStringField;
    dsLettersCONTROL_DATE_2: TDateField;
    procedure acLegendExecute(Sender: TObject);
    procedure dsLettersIS_OVERDUEGetText(Sender: TField; var Text: String;
      DisplayText: Boolean);
    procedure dsLettersEXECUTEDGetText(Sender: TField; var Text: String;
      DisplayText: Boolean);
    procedure acInsertUpdate(Sender: TObject);
    procedure acDeleteUpdate(Sender: TObject);
    procedure acEditUpdate(Sender: TObject);
    procedure acEditCandidateExecute(Sender: TObject);
    procedure acEditCandidateUpdate(Sender: TObject);
    procedure dsCandidatesBeforeOpen(DataSet: TDataSet);
    procedure acInsertExecute(Sender: TObject);
    procedure acEditExecute(Sender: TObject); override;
    procedure acDeleteExecute(Sender: TObject);
    procedure acPrintExecute(Sender: TObject);
    procedure acPrintUpdate(Sender: TObject);
    procedure acReopenExecute(Sender: TObject);
    procedure dsLettersAfterScroll(DataSet: TDataSet);
    procedure DataModuleCreate(Sender: TObject);
    procedure dsOrdersCalcFields(DataSet: TDataSet);
  private const
    Color_ControlDate = $CD9BFF;
    Color_Executed = clMoneyGreen;
    Color_Overdue = $6666FF;//clRed;
    Color_Standard = clInfoBk;
  private
    FCandidateX, FCandidateY: Integer;
    procedure SaveLetter(Letter: TKisLetter);
    procedure SaveLetterAddresses(Letter: TKisLetter);
    procedure SaveLetterVisas(Letter: TKisLetter);
    procedure SaveLetterPassings(Letter: TKisLetter);
    procedure SaveLetterOfficeDocs(Letter: TKisLetter);
    procedure SaveLetterOutcomings(Letter: TKisLetter);
    procedure SaveLetterCandidate(Letter: TKisLetter);
    procedure SaveLetterAddress(Addr: TKisEntity);
    procedure SaveLetterVisa(Visa: TKisEntity);
    procedure SaveLetterPassing(Passing: TKisEntity);
    procedure SaveLetterOfficeDoc(OfficeDoc: TKisEntity);
    procedure SaveOutcomLetter(OutcomLetter: TKisEntity);
    procedure GridCellColors(Sender: TObject; Field: TField;
      var Background, FontColor: TColor; State: TGridDrawState; var FontStyle:TFontStyles);
    procedure OrdersCellColors(Sender: TObject; Field: TField;
      var Background, FontColor: TColor; State: TGridDrawState; var FontStyle:TFontStyles);
    procedure CandidatesGridDblClick(Sender: TObject);
    procedure CandidatesGridMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure ReadReports;
    procedure PrintItemClick(Sender: TObject);
    procedure PrintReport(ReportID: Integer);
    function IsLetterHasChild(const Id: Integer): Boolean;
    procedure ReopenCandidates;
    function CandidatesEnabled: Boolean;
    procedure LoadAddressesToLetter(Letter: TKisLetter);
    procedure LoadOfficeDocsToLetter(Letter: TKisLetter);
    procedure LoadOutcomingsToLetter(Letter: TKisLetter);
    procedure LoadParentPassingsToLetter(Letter: TKisLetter;
      const ParentId: Integer);
    procedure LoadPassingsToLetter(Letter: TKisLetter);
    procedure LoadVisasToLetter(Letter: TKisLetter);
    function LetterHasChild(Letter: TKisLetter): Boolean;
    function CreateOfficeDocForLetter(Letter: TKisLetter): TKisEntity;
    procedure UpdateViewCaption(const OrgsId, DocTypesId: Integer);
    procedure PrepareViewLegend;
    function GetLetterHasChild(const LetterId: Integer): Integer;
    procedure DateFilterChange(Sender: TObject);
    procedure OfficeChange(Sender: TObject);
    procedure ViewUpdateOfficeCombo;
    function CreateDateFilter: IKisFilter;
    //
    function GetFilterId(const FilterName: String): Integer;
    function GetFilterDocTypeId: Integer;
    function GetFilterOfficeId: Integer;
    function GetFilterOrgId: Integer;
  protected
    procedure Activate; override;
    procedure ApplyFilters(aFilters: IKisFilters; ClearExisting: Boolean); override;
    procedure CancelFilters(aFilters: IKisFilters); override;
    procedure CloseView(Sender: TObject; var Action: TCloseAction); override;
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
    procedure ReadViewState; override;
    procedure Reopen; override;
    procedure WriteViewState; override;
    function ProcessSQLFilter(aFilter: IKisFilter;
      TheOperation: TKisFilterOperation; Clause: TWhereClause): Boolean; override;
  public
    function CurrentEntity: TKisEntity; override;
    procedure EditCurrent; override;
    function GetEntity(EntityID: Integer; EntityKind: TKisEntities = keDefault): TKisEntity; override;
    function CreateNewEntity(EntityKind: TKisEntities = keDefault): TKisEntity; override;
    function EditEntity(Entity: TKisEntity): TKisEntity; override;
    procedure SaveEntity(Entity: TKisEntity); override;
    procedure DeleteEntity(Entity: TKisEntity); override;
    function CreateEntity(EntityKind: TKisEntities = keDefault): TKisEntity; override;
    function IsEntityInUse(Entity: TKisEntity): Boolean; override;
    function IsLetterStored(const LetterId: Integer): Boolean;
    function GetAddressController(const EntityId: Integer): TLetterObjAddressController;
    procedure LoadAddressesToController(const LetterId: Integer; Ctrlr: TLetterObjAddressController);
    /// <summary>
    ///  Поиск письма по номеру организации.
    ///  Для ID_ORGS_KGA в OrgNumber нужно вставлять номер КГА.
    ///  Для ID_ORGS_UGA в OrgNumber нужно вставлять номер МП.
    /// </summary>
    ///  <param name="ExactNumber">Если False, то номер нужно "подобрать" с помощью маски типа документа.
    ///  Если True, то ищем прямо по точному совпадению с значением параметра OrgNumber.
    /// </param>
    function FindLetter(const OrdId, DocTypeId: Integer; const OrgNumber: String;
      const LetterDate: TDateTime; const ExactNumber: Boolean): TKisLetter;
  end;

  TKisLetterBuilder = class
  private
    procedure CreateAddresses(Letter: TKisLetter);
    procedure CreateVisas(Letter: TKisLetter);
    procedure CreateOfficeDocs(Letter: TKisLetter);
    procedure CreateOutcomings(Letter: TKisLetter);
    procedure CreatePassings(Letter: TKisLetter);
    procedure CreateParentPassings(Letter: TKisLetter);
  public
    function CreateLetter(Mngr: TKisLetterMngr): TKisLetter;
  end;

implementation

{$R *.dfm}

uses
  // System
  StdCtrls, ComCtrls, DateUtils, Types,
  // Common
  uGC, uIBXUtils, uVCLUtils, FR_Class, FR_IBXQuery,
  // Project
  uKisConsts, uKisLetterEditor, uKisUtils, uKisLetterVisaEditor, uKisFirms,
  uKisLetterPassingEditor, uKisLettersView, uKisPrintModule, uKisOrgs,
  uKisOfficeDocs, SelectAddress, uKisOutcomingLetters, uKisIntf,
  uKisOutcomingLetterEditor, uKisSearchClasses, uKisExceptions;

const
  SQ_SELECT_LETTERS_MAIN =
    'SELECT L.ID, L.DOC_NUMBER, L.DOC_DATE, L.ORG_NUMBER, L.ORG_DATE, '
  + 'L.ADM_NUMBER, L.ADM_DATE, L.DOC_TYPES_ID, L.FIRMS_ID, L.FIRM_NAME, '
  + 'L.CONTENT, L.EXECUTED, L.EXECUTE_INFO, L.CONTROL_DATE, L.OFFICES_ID, '
  + 'L.YEAR_NUMBER, L.INSERT_NAME, L.INSERT_TIME, L.OBJECT_TYPE_ID, L.ORGS_ID,'
  + 'DT.NAME AS DOC_TYPES_NAME, O.NAME AS OFFICES_NAME, L.MP_NUMBER, L.MP_DATE,'
  + 'LOT.NAME AS OBJECT_TYPE_NAME, L.MP_YEAR_NUMBER, ORGS.NAME AS ORG_NAME, '
  + 'L.IS_OVERDUE, L.EXECUTOR, ' //L.CONTROL_DATE_2, L.EXECUTED_2, '
  + 'GLS.LETTER_CONTROL_DATE AS CONTROL_DATE_2, GLS.LETTER_STATUS,  '
  + 'LSN.NAME AS STATUS_NAME '
  + 'FROM LETTERS L '
  + 'LEFT JOIN DOC_TYPES DT ON (L.DOC_TYPES_ID=DT.ID AND L.ORGS_ID=DT.ORGS_ID) '
  + 'LEFT JOIN OFFICES O ON L.OFFICES_ID=O.ID '
  + 'LEFT JOIN ORGS ON (L.ORGS_ID=ORGS.ID) '
  + 'LEFT JOIN LETTER_OBJECT_TYPES LOT ON (L.OBJECT_TYPE_ID=LOT.ID) '
  + 'LEFT JOIN GET_LETTER_STATUS(L.ID) GLS ON (L.ID=GLS.LETTERS_ID) '
  + 'LEFT JOIN LETTER_STATUS_NAMES LSN ON (GLS.LETTER_STATUS=LSN.ID)';
  SQ_GET_LETTER =
    'SELECT L.*, GLS.LETTER_CONTROL_DATE, GLS.LETTER_STATUS '
  + 'FROM LETTERS L '
  + 'LEFT JOIN GET_LETTER_STATUS(L.ID) GLS ON (L.ID=GLS.LETTERS_ID) '
  + 'WHERE L.ID=%d';
  SQ_LETTER_IS_STORED = 'SELECT COUNT(ID) FROM LETTERS WHERE ID=%d';
  SQ_LETTER_WHERE = 'WHERE LETTERS_ID=%d ORDER BY ID';
  SQ_GET_LETTER_ADDRESSES_ID = 'SELECT ID FROM LETTER_ADDRESSES ' + SQ_LETTER_WHERE;
  SQ_GET_LETTER_PASSINGS_ID = 'SELECT ID FROM LETTER_PASSINGS WHERE LETTERS_ID=%d ORDER BY DOC_DATE';
  SQ_GET_LETTER_VISAS_ID = 'SELECT ID FROM LETTER_VISAS WHERE LETTERS_ID=%d ORDER BY DOC_DATE';
  SQ_GET_LETTER_OFFICE_DOCS_ID = 'SELECT ID FROM OFFICE_DOC_LETTERS ' + SQ_LETTER_WHERE;
  SQ_GET_OUTCOM_LETTERS_ID = 'SELECT ID FROM LETTERS_LINK WHERE INCOMLETTER_ID=%d ORDER BY ID';

  SQ_GET_LETTER_ADDRESS = 'SELECT * FROM LETTER_ADDRESSES WHERE ID=%d';
  SQ_GET_LETTER_PASSING = 'SELECT * FROM LETTER_PASSINGS WHERE ID=%d';
  SQ_GET_LETTER_VISA = 'SELECT * FROM LETTER_VISAS WHERE ID=%d';
  SQ_GET_LETTER_OFFICE_DOC =
      'SELECT ODL.OFFICE_DOCS_ID, ODL.ID, ODL.LETTERS_ID, '
    + '  OD.DOC_NUMBER, OD.DOC_DATE, OD.PEOPLE_ID, OD.OFFICES_ID, OD.EXECUTOR_DATE '
    + 'FROM OFFICE_DOC_LETTERS ODL LEFT JOIN OFFICE_DOCS OD ON (ODL.OFFICE_DOCS_ID=OD.ID) '
    + 'WHERE ODL.ID=%d';
  SQ_GET_OUTCOM_LETTERS = 'SELECT LL.ID, LL.OUTCOMLETTER_ID, L.SEQ_NUMBER, L.NUMBER, L.DATE_REG, L.FIRMS_ID, L.FIRM FROM LETTERS_LINK LL, OUTCOMING_LETTERS L WHERE LL.ID = %d AND LL.OUTCOMLETTER_ID = L.ID';
  SQ_GET_CANDIDATE_LETTERS = 'SELECT CL.PARENT_ID, CL.SEND_DATE, L.DOC_NUMBER, L.DOC_DATE, '
                              + 'L.ORG_NUMBER, L.ORG_DATE, L.ADM_NUMBER, '
                              + 'L.ADM_DATE, '
                              + 'L.DOC_TYPES_ID, DT.NAME AS DOC_TYPES_NAME, '
                              + 'L.FIRM_NAME '
                              + 'FROM CANDIDATE_LETTERS CL '
                              + 'LEFT JOIN LETTERS L ON (CL.PARENT_ID=L.ID) '
                              + 'LEFT JOIN DOC_TYPES DT ON (L.DOC_TYPES_ID=DT.ID) '
                              + 'WHERE (CL.TO_ORG_ID=%d) AND (DT.ORGS_ID=%d)'
                              + 'ORDER BY CL.SEND_DATE';
  SQ_GET_LETTER_CHILD_COUNT = 'SELECT COUNT(ID) FROM LETTERS WHERE PARENT_ID=%d';
  SQ_GET_LETTER_CANDIDATE_COUNT = 'SELECT COUNT(PARENT_ID) FROM LETTERS WHERE PARENT_ID=%d';
  SQ_GET_LETTER_REPORTS = 'SELECT ID, NAME FROM ALL_REPORTS WHERE REPORT_TYPES_ID=%d ORDER BY NAME';
  SQ_GET_LETTER_ORDERS = 'SELECT O.ID, O.DOC_NUMBER, O.DOC_DATE, O.ACT_DATE, O.VAL_PERIOD, O.PAY_DATE, O.CHECKED, O.ORDER_NUMBER, O.EXECUTOR '
                       + 'FROM OFFICE_DOC_LETTERS ODL, ORDERS O '
                       + 'WHERE O.OFFICE_DOCS_ID = ODL.OFFICE_DOCS_ID AND ODL.LETTERS_ID=:L_ID';


  SQ_SAVE_LETTER = 'EXECUTE PROCEDURE SAVE_LETTER2(:ID,:DOC_TYPES_ID,:ORGS_ID,'
                 + ':OFFICES_ID,:OBJECT_TYPE_ID,:DOC_NUMBER,:DOC_DATE,:ORG_NUMBER,'
                 + ':ORG_DATE,:ADM_NUMBER,:ADM_DATE,:MP_NUMBER,:MP_DATE,:FIRMS_ID,'
                 + ':FIRM_NAME,:EXECUTED,:EXECUTE_INFO,:CONTROL_DATE,:PARENT_ID,'
                 + ':CONTROL_DATE_2, :EXECUTED_2)';
  SQ_SAVE_LETTER_CONTENT = 'UPDATE LETTERS SET CONTENT=:CONTENT WHERE ID=%d';
  SQ_SAVE_LETTER_ADDRESS = 'EXECUTE PROCEDURE SAVE_LETTER_ADDRESS(:ID, :LETTERS_ID, :ADDRESS)';
  SQ_SAVE_LETTER_VISA = 'EXECUTE PROCEDURE SAVE_LETTER_VISA(:LETTERS_ID,:ID,:DOC_DATE,:CONTROL_DATE,:CONTENT,:SIGNATURE)';
  SQ_SAVE_LETTER_PASSING = 'EXECUTE PROCEDURE SAVE_LETTER_PASSING(:LETTERS_ID,:ID,:DOC_DATE,:CONTENT,:OFFICES_ID,:PEOPLE_ID,:EXECUTED)';
  SQ_SAVE_OFFICE_DOC_LETTER = 'EXECUTE PROCEDURE SAVE_OFFICE_DOC_LETTERS(:OFFICE_DOCS_ID, :ID, :LETTERS_ID)';
  SQ_SAVE_OUTCOM_LETTERS = 'EXECUTE PROCEDURE SAVE_LETTERS_LINK(:ID, :INCOMLETTER_ID, :OUTCOMLETTER_ID)';

  SQ_CLEAR_LETTER_ADDRESSES = 'DELETE FROM LETTER_ADDRESSES WHERE LETTERS_ID=%d';
  SQ_CLEAR_LETTER_VISAS = 'DELETE FROM LETTER_VISAS WHERE LETTERS_ID=%d';
  SQ_CLEAR_LETTER_PASSINGS = 'DELETE FROM LETTER_PASSINGS WHERE LETTERS_ID=%d';
  SQ_CLEAR_LETTER_OFFICE_DOCS = 'DELETE FROM OFFICE_DOC_LETTERS WHERE LETTERS_ID=%d';

  SQ_GEN_LETTER_ID = 'SELECT GEN_ID(LETTERS_GEN, 1) FROM RDB$DATABASE';
  SQ_GEN_LETTER_ADDRESS_ID = 'SELECT GEN_ID(LETTER_ADDRESSES_GEN, 1) FROM RDB$DATABASE';
  SQ_GEN_LETTER_PASSING_ID = 'SELECT GEN_ID(LETTER_PASSINGS_GEN, 1) FROM RDB$DATABASE';
  SQ_GEN_LETTER_VISA_ID = 'SELECT GEN_ID(LETTER_VISAS_GEN, 1) FROM RDB$DATABASE';
  SQ_GEN_LETTER_OFFICE_DOCS_ID = 'SELECT GEN_ID(OFFICE_DOC_LETTERS_GEN, 1) FROM RDB$DATABASE';
  SQ_GEN_LETTERS_LINK_ID = 'SELECT GEN_ID(LETTERS_LINK_GEN, 1) FROM RDB$DATABASE';

  SQ_DELETE_LETTER = 'DELETE FROM LETTERS WHERE ID=%d';
  SQ_DELETE_CANDIDATES = 'DELETE FROM CANDIDATE_LETTERS WHERE PARENT_ID=%d';
  SQ_DELETE_OUTCOM_LETTERS = 'DELETE FROM LETTERS_LINK WHERE INCOMLETTER_ID=%d';

  SQ_INSERT_CANDIDATE_LETTER = 'INSERT INTO CANDIDATE_LETTERS(PARENT_ID, TO_ORG_ID) '
                               + 'VALUES (%d, %d)';

  SQ_CHECK_LETTER_OFFICE_DOCS = 'SELECT COUNT(LETTERS_ID) FROM OFFICE_DOC_LETTERS WHERE LETTERS_ID=%d';
  SQ_CHECK_LETTER_CHILDS = 'SELECT COUNT(ID) FROM LETTERS WHERE PARENT_ID=%d';

  SQ_UPDATE_PARENT_LETTER_PASSINGS = 'UPDATE LETTER_PASSINGS SET EXECUTED=%d WHERE LETTERS_ID=%d AND ORGS_ID=%d';
  SQ_UPDATE_PARENT_LETTER = 'UPDATE LETTERS SET %s=%s, %s=%s WHERE ID=%d';

  SQ_FIND_DGA_LETTER = 'SELECT ID FROM LETTERS WHERE (ADM_NUMBER=:DOC_NUMBER) AND (EXTRACT(YEAR FROM ADM_DATE)=:DOC_DATE)';
  SQ_FIND_KGA_LETTER = 'SELECT ID FROM LETTERS WHERE (DOC_NUMBER=:DOC_NUMBER) AND (EXTRACT(YEAR FROM DOC_DATE)=:DOC_DATE)';
  SQ_FIND_UGA_LETTER = 'SELECT ID FROM LETTERS WHERE (MP_NUMBER=:DOC_NUMBER) AND (EXTRACT(YEAR FROM MP_DATE)=:DOC_DATE)';

  FF_LETTERS_OFFICE_PASSING_FILTER = 'EXISTS (SELECT ID FROM LETTER_PASSINGS WHERE OFFICES_ID=%d AND LETTERS_ID=L.ID)';

{ TKisLetterVisa }

function TKisLetterVisa.CheckEditor(AEditor: TKisEntityEditor): Boolean;
var
  aDocDate, aControlDate: TDateTime;
begin
  with AEditor as TKisLetterVisaEditor do
  begin
    if (edDocDate.Text = '') or (not TryStrToDate(edDocDate.Text, aDocDate) or
      ((aDocDate > Date) or (aDocDate < MIN_DOC_DATE))) then
    begin
      MessageBox(Handle, PChar(S_CHECK_DATE), PChar(S_WARN), MB_OK + MB_ICONWARNING);
      edDocDate.SetFocus;
      Result := False;
      Exit;
    end;
    if (edControlDate.Text <> '') and (not TryStrToDate(edControlDate.Text, aControlDate) or
      (aControlDate < aDocDate)) then
    begin
      MessageBox(Handle, PChar(S_CHECK_CONTROL_DATE), PChar(S_WARN), MB_OK + MB_ICONWARNING);
      edControlDate.SetFocus;
      Result := False;
      Exit;
    end;
    if (cbSignature.Text = '') or BadName(cbSignature.Text)  then
    begin
      MessageBox(Handle, PChar(S_CHECK_SIGNATURE), PChar(S_WARN), MB_OK + MB_ICONWARNING);
      cbSignature.SetFocus;
      Result := False;
      Exit;
    end;
  end;
  Result := True;
end;

function TKisLetterVisa.CreateEditor: TKisEntityEditor;
begin
  EntityEditor := TKisLetterVisaEditor.Create(Application);
  Result := EntityEditor;
end;

class function TKisLetterVisa.EntityName: String;
begin
  Result := SEN_VISA;
end;

function TKisLetterVisa.GetContent: String;
begin
  Result := DataParams[SF_CONTENT].Value;
end;

function TKisLetterVisa.GetControlDate: String;
begin
  Result := DataParams[SF_CONTROL_DATE].AsString;
end;

function TKisLetterVisa.GetDocDate: String;
begin
  Result := DataParams[SF_DOC_DATE].AsString;
end;

function TKisLetterVisa.GetSignature: String;
begin
  Result := DataParams[SF_SIGNATURE].AsString;
end;

function TKisLetterVisa.GetText: String;
begin
  Result := DocDate;
  if Result <> '' then
    Result := Result + ' - ';
   Result := Result + Signature + ' : ' + Content;
end;

{$IFDEF ENTPARAMS}
procedure TKisLetterVisa.InitParams;
begin
  inherited;
  AddParam(SF_LETTERS_ID);
  AddParam(SF_DOC_DATE);
  AddParam(SF_CONTROL_DATE);
  AddParam(SF_CONTENT);
  AddParam(SF_SIGNATURE);
end;
{$ENDIF}

function TKisLetterVisa.IsEmpty: Boolean;
begin
  Result := (Content = '') and (Signature = ''); 
end;

procedure TKisLetterVisa.Load(DataSet: TDataSet);
begin
  inherited;
  with DataSet do
  begin
    ID := FieldByName(SF_ID).AsInteger;
    Content := FieldByName(SF_CONTENT).AsString;
    Signature := FieldByName(SF_SIGNATURE).AsString;
    ControlDate := FieldByName(SF_CONTROL_DATE).AsString;
    DocDate := FieldByName(SF_DOC_DATE).AsString;
    Self.Modified := True;
  end;
end;

procedure TKisLetterVisa.LoadDataIntoEditor(AEditor: TKisEntityEditor);
begin
  inherited;
  with AEditor as TKisLetterVisaEditor do
  begin
    edDocDate.Text := DocDate;
    edControldate.Text := Controldate;
    cbSignature.Text := Signature;
    edContent.Text := Content;
  end;
end;

procedure TKisLetterVisa.PrepareEditor(AEditor: TKisEntityEditor);
begin
  inherited;
  with AEditor as TKisLetterVisaEditor do
    cbSignature.Items.Assign(IStringList(AppModule.Lists[klSignatures]).StringList);
end;

procedure TKisLetterVisa.ReadDataFromEditor(AEditor: TKisEntityEditor);
begin
  inherited;
  with AEditor as TKisLetterVisaEditor do
  begin
    DocDate := edDocDate.Text;
    ControlDate := edControldate.Text;
    Signature := cbSignature.Text;
    Content := edContent.Text;
  end;
end;

procedure TKisLetterVisa.SetContent(const Value: String);
begin
  if Content <> Value then
  begin
    DataParams[SF_CONTENT].Value := Value;
    Modified := True;
  end;
end;

procedure TKisLetterVisa.SetControlDate(const Value: String);
begin
  if ControlDate <> Value then
  begin
    DataParams[SF_CONTROL_DATE].Value := Value;
    Modified := True;
  end;
end;

procedure TKisLetterVisa.SetDocDate(const Value: String);
begin
  if DocDate <> Value then
  begin
    DataParams[SF_DOC_DATE].Value := Value;
    Modified := True;
  end;
end;

procedure TKisLetterVisa.SetSignature(const Value: String);
begin
  if Signature <> Value then
  begin
    DataParams[SF_SIGNATURE].Value := Value;
    Modified := True;
  end;
end;

{ TKisLetterObjAddress }

procedure TKisLetterObjAddress.Copy(Source: TKisEntity);
begin
  inherited;
  Self.FAddress := TKisLetterObjAddress(Source).Address;
end;

class function TKisLetterObjAddress.EntityName: String;
begin
  Result := SEN_ADDRESS;
end;

function TKisLetterObjAddress.Equals(Entity: TKisEntity): Boolean;
begin
  inherited Equals(Entity);
  with Entity as TKisLetterObjAddress do
    Result := (Self.Address = Address);
end;

function TKisLetterObjAddress.GetAddress: String;
begin
  Result := FAddress;
end;

function TKisLetterObjAddress.GetText: String;
begin
  Result := FAddress;
end;

{$IFDEF ENTPARAMS}
procedure TKisLetterObjAddress.InitParams;
begin
  inherited;
  AddParam(SF_ADDRESS);
end;
{$ENDIF}

function TKisLetterObjAddress.IsEmpty: Boolean;
begin
  Result := FAddress = '';
end;

procedure TKisLetterObjAddress.Load(DataSet: TDataSet);
begin
  inherited;
  ID := DataSet.FieldByName(SF_ID).AsInteger;
  Address := DataSet.FieldByName(SF_ADDRESS).AsString;
  Self.Modified := True;
end;

procedure TKisLetterObjAddress.SetAddress(const Value: String);
begin
  if FAddress <> Value then
  begin
    FAddress := Value;
    Modified := True;
  end;
end;

{ TLetterObjAddressController }

procedure TLetterObjAddressController.FillFieldDefs(FieldDefsRef: TFieldDefs);
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
    Name := SF_LETTERS_ID;
  end;
  with FieldDefsRef.AddFieldDef do
  begin
    DataType := ftString;
    FieldNo := 3;
    Name := SF_ADDRESS;
    Size := 300;
  end;
end;

function TLetterObjAddressController.GetDeleteQueryText: String;
var
  IDList: String;
  I: Integer;
begin
  Result := 'DELETE FROM LETTER_ADDRESSES WHERE ID IN (%s)';
  IDList := '';
  for I := 0 to Pred(DeletedCount) do
  begin
    if I > 0 then
      IDList := IDList + ',';
    IDList := IDList + IntToStr(DeletedElements[I].ID);
  end;
  Result := Format(Result, [IDList]);
end;

function TLetterObjAddressController.GetFieldData(Index: Integer;
  Field: TField; out Data): Boolean;
begin
  Result := (Index >= 0) and (Index <= GetRecordCount);
  if Result then
  try
    with Elements[Index] as TKisLetterObjAddress do
    case Field.FieldNo of
      1 :
        begin
          GetInteger(ID, Data);
        end;
      2 :
        begin
          GetInteger(HeadId, Data);
        end;
      3 :
        begin
          GetString(Address, Data);
        end;
      else
        raise EDatabaseError.CreateFmt(S_FIELD_NOT_FOUND, [Field.FieldName]);
    end;
    Result := True;
  except
    Result := False;
  end;
end;

procedure TLetterObjAddressController.SetFieldData(Index: integer;
  Field: TField; var Data);
begin
  try
    with TKisLetterObjAddress(Elements[Index]) do
    case Field.FieldNo of
    1 : ID := SetInteger(Data);
    2 : ;// только для чтения;
    3 : Address := StrPas(@Data);
    end;
  except
    Exit;
  end;
end;

{ TKisLetter }

procedure TKisLetter.AddressInsert(DataSet: TDataSet);
var
  S: String;
begin
  if DoSelectAddress(True, S) then
  begin
    Addresses.FieldByName(SF_ADDRESS).AsString := S;
    Addresses.Post;
  end
  else
    Addresses.Cancel;
end;

function TKisLetter.CheckEditor(Editor: TKisEntityEditor): Boolean;
var
  D: TDateTime;
  I1, I2: Integer;
begin
  Result := False;
  I1 := 0;
  I2 := 0;
  if Editor is TKisLetterEditor then
  with Editor as TKisLetterEditor do
  begin
    if cbDocTypesName.ItemIndex < 0 then
    begin
      MessageBox(Handle, PChar(S_CHECK_LETTER_DOC_TYPE), PChar(S_WARN), MB_OK + MB_ICONWARNING);
      PageControl.ActivePageIndex := 0;
      cbDocTypesName.SetFocus;
      Exit;
    end;
    if cbOfficeName.ItemIndex < 0 then
    begin
      MessageBox(Handle, PChar(S_CHECK_LETTER_OFFICE_NAME), PChar(S_WARN), MB_OK + MB_ICONWARNING);
      cbOfficeName.SetFocus;
      Exit;
    end;
    case Self.OrgsId of
    ID_ORGS_UGA :
      begin
        if Trim(edMPNumber.Text) = '' then
        begin
          MessageBox(Handle, PChar(S_CHECK_MP_LETTER_NUMBER), PChar(S_WARN), MB_OK + MB_ICONWARNING);
          PageControl.ActivePageIndex := 0;
          edMPNumber.SetFocus;
          Result := False;
          Exit;
        end;
        if (edMPDate.Text = '') or not TryStrToDate(edMPDate.Text, D) or
          ((D > Date) or (D < MIN_DOC_DATE)) then
        begin
          MessageBox(Handle, PChar(S_CHECK_MP_LETTER_DATE), PChar(S_WARN), MB_OK + MB_ICONWARNING);
          PageControl.ActivePageIndex := 0;
          edMPDate.SetFocus;
          Result := False;
          Exit;
        end;
{
        if not TKisLetterMngr(Manager).IsLetterStored(Self.ID) then
        begin
          if AppModule.User.LetterNumberExists(MPNumber,
            Self.DocTypesId, YearOf(StrToDate(MPDate))) then
          begin
            MessageBox(Handle, PChar(Format(S_LETTER_NUMBER_EXISTS, [MPNumber])), PChar(S_WARN), MB_OK + MB_ICONWARNING);
            edMPNumber.SetFocus;
            Result := False;
            Exit;
          end;
        end;
}
      end;
    ID_ORGS_KGA :
      begin
        if Trim(edDocNumber.Text) = '' then
        begin
          MessageBox(Handle, PChar(S_CHECK_LETTER_NUMBER), PChar(S_WARN), MB_OK + MB_ICONWARNING);
          PageControl.ActivePageIndex := 0;
          edDocNumber.SetFocus;
          Result := False;
          Exit;
        end;
        if (edDocDate.Text = '') or not TryStrTodate(edDocDate.Text, D) or
          ((D > Date) or (D < MIN_DOC_DATE)) then
        begin
          MessageBox(Handle, PChar(S_CHECK_LETTER_DATE), PChar(S_WARN), MB_OK + MB_ICONWARNING);
          PageControl.ActivePageIndex := 0;
          edDocDate.SetFocus;
          Result := False;
          Exit;
        end;
{
        if not TKisLetterMngr(Manager).IsLetterStored(Self.ID) then
        begin
          if AppModule.User.LetterNumberExists(DocNumber,
            Self.DocTypesId, YearOf(StrToDate(DocDate))) then
          begin
            MessageBox(Handle, PChar(Format(S_LETTER_NUMBER_EXISTS, [DocNumber])), PChar(S_WARN), MB_OK + MB_ICONWARNING);
            edMPNumber.SetFocus;
            Result := False;
            Exit;
          end;
        end;
}
      end;
    end;
    if (edOrgDate.Text <> '') then
    if not TryStrToDate(edOrgDate.Text, D) or ((D > Date) or (D < MIN_DOC_DATE)) then
    begin
      MessageBox(Handle, PChar(S_CHECK_LETTER_ORG_DATE), PChar(S_WARN), MB_OK + MB_ICONWARNING);
      PageControl.ActivePageIndex := 0;
      edOrgDate.SetFocus;
      Result := False;
      Exit;
    end;
    if (edAdmDate.Text <> '') then
    if not TryStrToDate(edAdmDate.Text, D) or ((D > Date) or (D < MIN_DOC_DATE)) then
    begin
      MessageBox(Handle, PChar(S_CHECK_LETTER_ADM_DATE), PChar(S_WARN), MB_OK + MB_ICONWARNING);
      PageControl.ActivePageIndex := 0;
      edAdmDate.SetFocus;
      Result := False;
      Exit;
    end;
    if (Trim(edFirmName.Text) = '') or
       ((edFirmName.Text <> '') and BadFirmName(edFirmName.Text, I1, I2)) then
    begin
      MessageBox(Handle, PChar(S_CHECK_LETTER_AUTHOR), PChar(S_WARN), MB_OK + MB_ICONWARNING);
      PageControl.ActivePageIndex := 0;
      edFirmName.SetFocus;
      if (I1 > 0) and (I2 > 0) then
      begin
        edFirmName.SelStart := I1;
        edFirmName.SelLength := Succ(I2 - I1);
      end;
      Result := False;
      Exit;
    end;
    if (edControlDate.Text <> '') then
    if not TryStrToDate(edControlDate.Text, D)
       and ((D < MIN_DOC_DATE) or (D > IncYear(Date))) then
    begin
      MessageBox(Handle, PChar(S_CHECK_LETTER_CONTROL_DATE), PChar(S_WARN), MB_OK + MB_ICONWARNING);
      PageControl.ActivePageIndex := 0;
      edControlDate.SetFocus;
      Result := False;
      Exit;
    end;
    if Trim(Edit1.Text) <> '' then
    if not TryStrToDate(Trim(Edit1.Text), D)
       and ((D < MIN_DOC_DATE) or (D > IncYear(Date))) then
    begin
      MessageBox(Handle, PChar(S_CHECK_LETTER_CONTROL_DATE), PChar(S_WARN), MB_OK + MB_ICONWARNING);
      PageControl.ActivePageIndex := 0;
      Edit1.SetFocus;
      Result := False;
      Exit;
    end;
    Result := True;
  end
  else
    raise Exception.Create(S_BAD_LETTER_EDITOR);
end;

procedure TKisLetter.Copy(Source: TKisEntity);
var
  Letter: TKisLetter;
begin
  inherited;
  Letter := Source as TKisLetter;
  CopyMain(Letter);
  CopyVisas(Letter);
  CopyOfficeDocs(Letter);
  CopyAddresses(Letter);
  CopyPassings(Letter);
  CopyOutcomings(Letter);
  CopyParentPassings(Letter);
end;

constructor TKisLetter.Create(Mngr: TKisMngr);
begin
  inherited;
  FIsCandidate := False;
end;

function TKisLetter.CreateEditor: TKisEntityEditor;
begin
  Result := TKisLetterEditor.Create(Application);
  EntityEditor := Result;
end;

function TKisLetter.DataSetEquals(DS1, DS2: TCustomDataSet): Boolean;
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

destructor TKisLetter.Destroy;
begin
  FAddresses.Close;
  FAddresses.Free;
  FAddrCtrlr.Free;
  FVisas.Close;
  FVisas.Free;
  FVisasCtrlr.Free;
  FPassings.Close;
  FPassings.Free;
  FPassingCtrlr.Free;
  FParentPassings.Close;
  FParentPassings.Free;
  FParentPassingCtrlr.Free;
  FOfficesDocs.Close;
  FOfficesDocs.Free;
  FOfficeDocCtrlr.Free;
  FOutcomLetter.Close;
  FOutcomLetter.Free;
  FOutcomLetterCtrlr.Free;
  if Assigned(FSelector) then
    FSelector.Free;
  inherited;
end;

class function TKisLetter.EntityName: String;
begin
  Result := 'Письмо';
end;

function TKisLetter.Equals(Entity: TKisEntity): Boolean;
begin
  inherited Equals(Entity);
  with Entity as TKisLetter do
  begin
    Result := (Self.DocTypesId = DocTypesId) and (Self.OrgsId = OrgsId)
      and (Self.OfficesId = OfficesId)
      and (Self.DocNumber = DocNumber) and (Self.DocDate = DocDate)
      and (Self.OrgNumber = OrgNumber) and (Self.OrgDate = OrgDate)
      and (Self.AdmNumber = AdmNumber) and (Self.AdmDate = AdmDate)
      and (Self.MPNumber = MPNumber) and (Self.MPDate = MPDate)
      and (Self.FirmId = FirmId) and (Self.FirmName = FirmName)
      and (Self.Executed = Executed) and (Self.ExecuteInfo = ExecuteInfo)
      and (Self.Content = Content) and (Self.ControlDate = ControlDate)
//      and (Self.ControlDate2 = ControlDate2) and (Self.Executed2 = Executed2)
      ;
    if Result then
      Result := Result and DataSetEquals(Self.FAddresses, FAddresses);
    if Result then
      Result := Result and DataSetEquals(Self.FVisas, FVisas);
    if Result then
      Result := Result and DataSetEquals(Self.FOfficesDocs, FOfficesDocs);
    if Result then
      Result := Result and DataSetEquals(Self.FPassings, FPassings);
    if Result then
      Result := Result and DataSetEquals(Self.FOutcomLetter, FOutcomLetter);
  end;
end;

procedure TKisLetter.GenerateKGANumber(Sender: TObject);
begin
  if DocNumber <> '' then
  begin
    if MessageBox(EntityEditor.Handle,
        PChar(Format(S_LETTER_NUMBER_ALREADY_FILLED, [DocNumber])),
        PChar(S_WARN),
        MB_YESNO + MB_ICONWARNING) = ID_NO then
      Exit;
  end;
  if FDocTypesId < 0 then
  begin
    MessageBox(0, PChar(S_CHECK_LETTER_DOC_TYPE), PChar(S_WARN), MB_OK);
    Exit;
  end;
  DocNumber := AppModule.User.GenerateNewLetterNumber(FDocTypesId);
  UpdateKGANumber;
end;

procedure TKisLetter.GenerateMPNumber(Sender: TObject);
begin
  if MPNumber <> '' then
  begin
    if MessageBox(EntityEditor.Handle,
        PChar(Format(S_LETTER_NUMBER_ALREADY_FILLED, [MPNumber])),
        PChar(S_WARN),
        MB_YESNO + MB_ICONWARNING) = ID_NO then
      Exit;
  end;
  if FDocTypesId < 0 then
  begin
    MessageBox(0, PChar(S_CHECK_LETTER_DOC_TYPE), PChar(S_WARN), MB_OK);
    Exit;
  end;
  MPNumber := AppModule.User.GenerateNewLetterNumber(FDocTypesId);
  UpdateMpNumber;
end;

function TKisLetter.GetAddresses: TDataSet;
begin
  Result := FAddresses;
end;

function TKisLetter.GetCaption: String;
begin
  case FDocTypesId of
  ID_LETTER_TYPE_INCOMING :
    begin
      Result := 'Входящая корреспонденция';
    end;
  ID_LETTER_TYPE_DEP_ORDER :
    begin
      Result := 'Приказ департамента';
    end;
  ID_LETTER_TYPE_COMPLAINT :
    begin
      Result := 'Жалоба';
    end;
  else
    begin
      Result := 'Письмо';
    end;
  end;
  if ReadOnly then
    Result := Result + ' - только для чтения';
end;

function TKisLetter.GetOfficesDocs: TDataSet;
begin
  Result := FOfficesDocs;
end;

function TKisLetter.GetPassings: TDataSet;
begin
  Result := FPassings;
end;

function TKisLetter.GetText: String;
begin
  Result := 'Письмо №' + DocNumber + ' от ' + DocDate;
end;

function TKisLetter.GetVisas: TDataSet;
begin
  Result := FVisas;
end;

function TKisLetter.IsEmpty: Boolean;
begin
  Result := (DocNumber = '') and (DocDate = '')
        and (OrgNumber = '') and (OrgDate = '')
        and (AdmNumber = '') and (AdmDate = '')
        and (MPNumber = '') and (MPDate = '')
        and (FirmID = 0) and (FirmName = '')
        and (DocTypesId = 0) and (OrgsId = 0) and (OfficesId = 0)
        and (Content = '') and (Executed = False) and (ExecuteInfo = '')
        and (ControlDate = '')
//        and (ControlDate2 = '') and (Executed2 = False)
        and Addresses.IsEmpty and OfficesDocs.IsEmpty
        and Passings.IsEmpty and Visas.IsEmpty
        and OutcomLetter.IsEmpty;
end;

procedure TKisLetter.Load(DataSet: TDataSet);
var
  TmpId: Integer;
begin
  inherited;
  with DataSet do
  begin
    ID := FieldByName(SF_ID).AsInteger;
    FDocTypesId := FieldByName(SF_DOC_TYPES_ID).AsInteger;
    FOrgsId := FieldByName(SF_ORGS_ID).AsInteger;
    FOfficesId := FieldByName(SF_OFFICES_ID).AsInteger;
    DocNumber := FieldByName(SF_DOC_NUMBER).AsString;
    DocDate := FieldByName(SF_DOC_DATE).AsString;
    FOrgNumber := FieldByName(SF_ORG_NUMBER).AsString;
    FOrgDate := FieldByName(SF_ORG_DATE).AsString;
    FAdmNumber := FieldByName(SF_ADM_NUMBER).AsString;
    FAdmDate := FieldByName(SF_ADM_DATE).AsString;
    FFirmId := FieldByName(SF_FIRMS_ID).AsInteger;
    FirmName := FieldByName(SF_FIRM_NAME).AsString;
    FContent := FieldByName(SF_CONTENT).AsString;
    FExecuted := Boolean(FieldByName(SF_EXECUTED).AsInteger);
    FExecuteInfo := FieldByName(SF_EXECUTE_INFO).AsString;
    FControlDate := FieldByName(SF_CONTROL_DATE).AsString;
//    FControlDate2 := FieldByName(SF_CONTROL_DATE_2).AsString;
//    FExecuted2 := Boolean(FieldByName(SF_EXECUTED_2).AsInteger);
    MPNumber := FieldByName(SF_MP_NUMBER).AsString;
    MPDate := FieldByName(SF_MP_DATE).AsString;
    FObjectTypeId := FieldByName(SF_OBJECT_TYPE_ID).AsInteger;
    FParentId := FieldByName(SF_PARENT_ID).AsInteger;
    Executor := FieldByName(SF_EXECUTOR).AsString;
    FOrderControlDate := FieldByName(SF_LETTER_CONTROL_DATE).AsDateTime;
    FOrderStatus := FieldByName(SF_LETTER_STATUS).AsInteger;
  end;

  TKisLetterMngr(Manager).LoadAddressesToLetter(Self);
  TKisLetterMngr(Manager).LoadOfficeDocsToLetter(Self);
  TKisLetterMngr(Manager).LoadOutcomingsToLetter(Self);
  TKisLetterMngr(Manager).LoadPassingsToLetter(Self);

  if Self.ParentId > 1 then
    TmpId := Self.ParentId
  else
    if Self.HasChild then
      TmpId := Self.GetChildId
    else
      TmpId := 0;

  TKisLetterMngr(Manager).LoadParentPassingsToLetter(Self, TmpId);
  TKisLetterMngr(Manager).LoadVisasToLetter(Self);
end;

procedure TKisLetter.LoadDataIntoEditor(Editor: TKisEntityEditor);
begin
  if Editor is TKisLetterEditor then
  with Editor as TKisLetterEditor do
  begin
    // загружаем параметры
    if not ComboLocate(cbDocTypesName, FDocTypesId) then
      cbOfficeName.ItemIndex := -1;
    if not ComboLocate(cbOfficeName, FOfficesId) then
      cbOfficeName.ItemIndex := -1;
    edDocNumber.Text := DocNumber;
    edDocDate.Text := DocDate;
    edOrgNumber.Text := FOrgNumber;
    edOrgDate.Text := FOrgDate;
    edAdmNumber.Text := FAdmNumber;
    edAdmDate.Text := FAdmDate;
    edMPNumber.Text := MPNumber;
    edMPDate.Text := MPDate;
    edFirmName.Text := FirmName;
    mContent.Text := FContent;
    cbObjectType.ItemIndex := FObjectTypeId;
    chExecuted.Checked := FExecuted;
    edExecutedInfo.Text := FExecuteInfo;
    edControlDate.Text := FControlDate;
//    Edit1.Text := FControlDate2;
//    CheckBox1.Checked := FExecuted2;
    if FOrderControlDate = 0 then
      Edit1.Clear
    else
      Edit1.Text := DateToStr(FOrderControlDate);
    CheckBox1.Checked := FOrderStatus = 3;
  end;
end;

procedure TKisLetter.PassingsInsert(DataSet: TDataSet);
begin
  // Здесь показвыаем редактор списания
  TKisLetterPassing(FPassingCtrlr.Elements[0]).DocDate := FormatDateTime(S_DATESTR_FORMAT, Date);
  if not TKisVisualEntity(FPassingCtrlr.Elements[0]).Edit then
    DataSet.Cancel
  else
  begin
    DataSet.Post;
  end;
end;

procedure TKisLetter.PrepareEditor(Editor: TKisEntityEditor);
var
  Flag: Boolean;
  RoleId: Integer;
begin
  // [!!!] Разбить на несколько мелких
  inherited;
  with Editor as TKisLetterEditor do
  begin
    PageControl.ActivePageIndex := 0;

    cbDocTypesName.Items.Assign(IStrings(AppModule.DocTypeList(Self.FOrgsId, 1)).Strings);
    cbOfficeName.Items.Assign(IStrings(AppModule.Lists[klOffices]).Strings);

    cbDocTypesName.OnChange := DocTypeChange;

    tsPassingAdditional.TabVisible := Self.HasChild or (Self.ParentId > 0);
    if Self.OrgsId = ID_ORGS_KGA then
    begin
      tsPassingMain.Caption := 'КГА';
      tsPassingAdditional.Caption := 'МП УГА';
    end
    else
    begin
      tsPassingMain.Caption := 'МП УГА';
      tsPassingAdditional.Caption := 'КГА';
    end;
    dsParentPassings.DataSet := FParentPassings;
    FParentPassings.Refresh;
    pcPassing.ActivePage := tsPassingMain;

    dsAddresses.DataSet := FAddresses;
    FAddresses.AfterInsert := AddressInsert;
    FAddresses.AfterEdit := AddressEdit;
    FAddresses.Refresh;
    dsOfficeDocs.DataSet := FOfficesDocs;
    FOfficesDocs.Refresh;
    dsPassings.DataSet := FPassings;
    FPassings.AfterInsert := PassingsInsert;
    FPassings.BeforeDelete := PassingsBeforeDelete;
    FPassings.Refresh;
    dsVisas.DataSet := FVisas;
    FVisas.AfterInsert := VisasInsert;
    FVisas.BeforeDelete := VisasBeforeDelete;
    FVisas.Refresh;

    dsOutcomLetters.DataSet := FOutcomLetter;
    FOutcomLetter.Refresh;
    ///  [!!!] задесь закомментировано ограничение на изменение признака
    ///  принадлежности к отделу у писем
    ///  по идее владельцем письма всегда может быть один отдел,
    ///  и если надо его списать в другой, то происходт списание
    ///  но люди создают письма не в тех отделах, поэтому разрешим пока
    ///  менять этот признак владельца
    //Flag := AppModule.User.IsAdministrator;
    Flag := True;
    cbOfficeName.Enabled := True;
    btnGenerateMPNumber.Visible := Flag or (Self.OrgsId = ID_ORGS_UGA);
    edDocNumber.Enabled := Flag or (Self.OrgsId = ID_ORGS_KGA);
    edDocDate.Enabled := Flag or (Self.OrgsId = ID_ORGS_KGA);
    edMPNumber.Enabled := Flag or (Self.OrgsId = ID_ORGS_UGA);
    edMPDate.Enabled := Flag or (Self.OrgsId = ID_ORGS_UGA);
    btnGenerateKGANumber.OnClick := GenerateKGANumber;
    btnGenerateMPNumber.OnClick := GenerateMPNumber;
    btnGenerateKGANumber.Enabled := not Self.ReadOnly;
    btnGenerateMPNumber.Enabled := not Self.ReadOnly;
    //
    btnFirmSelect.OnClick := SelectFirm;
    btnFirmDetail.OnClick := ShowFirm;
    btnFirmClear.OnClick := ClearFirm;
    btnFirmSelect.Enabled := not Self.ReadOnly;
    btnFirmClear.Enabled := not Self.ReadOnly;
    //
    btnSelectOutcomLetter.OnClick := CreateOutcomLetter;
    btnEditOutcomLetter.OnClick := EditOutcomLetter;
    //
    btnNew.Enabled := not Self.ReadOnly;
    btnDel.Enabled := not Self.ReadOnly;
    btnShow.Enabled := not Self.ReadOnly;
    btnShow.OnClick := Self.EditPassingOrVisa;

//    if AppModule.User.OrgId = ID_ORGS_UGA then
      RoleId := ID_ROLE_MP_CHANCELLERY;
//    else
//      RoleId := ID_ROLE_CHANCELLERY;

    btnSelectOutcomLetter.Enabled := KisAppModule.User.RoleID = RoleId;
    btnDeleteOutcomLetter.Enabled := btnSelectOutcomLetter.Enabled;
    

    if Self.ReadOnly then
      dbgAddresses.Options := dbgAddresses.Options - [dgEditing];
    btnAddAddress.Enabled := not Self.ReadOnly;
    btnDeleteAddress.Enabled := not Self.ReadOnly;
    btnEditAddress.Enabled := not Self.ReadOnly;

    btnOfficeDocCreate.OnClick := Self.CreateOfficeDoc;
    btnOfficeDocEdit.OnClick := Self.EditOfficeDoc;
    btnOfficeDocDelete.OnClick := Self.DeleteOfficeDoc;

    chExecuted.OnClick := EditorSetExecuted;

    dbgPassings.OnDrawColumnCell := Self.DBGridDrawColumnCell;
    dbgParentPassings.OnDrawColumnCell := Self.DBGridDrawColumnCell;

//    dbgAddresses.OnCreateEditor := AddressOnCreateEditor; 
  end;
  if IsCandidate then
  begin
    Editor.btnOk.Caption := 'Принять письмо';
    if Editor.btnOk.Width <> 100 then
    begin
      Editor.btnOk.Width := 100;
      Editor.btnOk.Left := Editor.btnOk.Left - 25;
    end;
    Editor.btnCancel.Caption := 'Отказаться';
  end
  else
  begin
    Editor.btnOk.Caption := 'ОК';
    if Editor.btnOk.Width <> 75 then
    begin
      Editor.btnOk.Width := 75;
      Editor.btnOk.Left := Editor.btnOk.Left + 25;
    end;
    Editor.btnCancel.Caption := 'Отмена';
  end;
end;

procedure TKisLetter.ReadDataFromEditor(Editor: TKisEntityEditor);
begin
  inherited;
  if Editor is TKisLetterEditor then
  with Editor as TKisLetterEditor do
  begin
    DocTypesId := Integer(cbDocTypesName.Items.Objects[cbDocTypesName.ItemIndex]);
    OfficesId := Integer(cbOfficeName.Items.Objects[cbOfficeName.ItemIndex]);
    DocNumber := Trim(edDocNumber.Text);
    DocDate := Trim(edDocDate.Text);
    OrgNumber := Trim(edOrgNumber.Text);
    OrgDate := Trim(edOrgDate.Text);
    AdmNumber := Trim(edAdmNumber.Text);
    AdmDate := Trim(edAdmDate.Text);
    FirmName := Trim(edFirmName.Text);
    Content := Trim(mContent.Text);
    ObjectTypeId := cbObjectType.ItemIndex;
    Executed := chExecuted.Checked;
    ExecuteInfo := Trim(edExecutedInfo.Text);
    ControlDate := edControlDate.Text;
    MPNumber := Trim(edMPNumber.Text);
    MPDate := edMPDate.Text;
//    ControlDate2 := Trim(Edit1.Text);
//    Executed2 := CheckBox1.Checked;
  end
  else
    raise Exception.Create(S_BAD_LETTER_EDITOR);
end;

procedure TKisLetter.SetAdmDate(const Value: String);
begin
  if FAdmDate <> Value then
  begin
    FAdmDate := Value;
    Modified := True;
  end;
end;

procedure TKisLetter.SetAdmNumber(const Value: String);
begin
  if FAdmNumber <> Value then
  begin
    FAdmNumber := Value;
    Modified := True;
  end;
end;

procedure TKisLetter.SetContent(const Value: String);
begin
  if FContent <> Value then
  begin
    FContent := Value;
    Modified := True;
  end;
end;

procedure TKisLetter.SetControlDate(const Value: String);
begin
  if FControlDate <> Value then
  begin
    FControlDate := Value;
    Modified := True;
  end;
end;

procedure TKisLetter.SetDocDate(const Value: String);
begin
  if DocDate <> Value then
  begin
    Self[SF_DOC_DATE].Value := Value;
    Modified := True;
  end;
end;

procedure TKisLetter.SetDocNumber(const Value: String);
begin
  if DocNumber <> Value then
  begin
    Self[SF_DOC_NUMBER].Value := Value;
    Modified := True;
  end;
end;

procedure TKisLetter.SetDocTypesId(const Value: SmallInt);
begin
  if FDocTypesId <> Value then
  begin
    FDocTypesId := Value;
    Modified := True;
  end;
end;

procedure TKisLetter.SetExecuted(const Value: Boolean);
begin
  if FExecuted <> Value then
  begin
    FExecuted := Value;
    Modified := True;
  end;
end;

procedure TKisLetter.SetExecuteInfo(const Value: String);
begin
  if FExecuteInfo <> Value then
  begin
    FExecuteInfo := Value;
    Modified := True;
  end;
end;

procedure TKisLetter.SetFirmId(const Value: Integer);
begin
  if FFirmId <> Value then
  begin
    FFirmId := Value;
    Modified := True;
  end;
end;

procedure TKisLetter.SetFirmName(const Value: String);
begin
  if FirmName <> Value then
  begin
    Self[SF_FIRM_NAME].Value := Value;
    Modified := True;
  end;
end;

procedure TKisLetter.SetMPDate(const Value: String);
begin
  if MPDate <> Value then
  begin
    Self[SF_MP_DATE].Value := Value;
    Modified := True;
  end;
end;

procedure TKisLetter.SetMPNumber(const Value: String);
begin
  if MPNumber <> Value then
  begin
    Self[SF_MP_NUMBER].Value := Value;
    Modified := True;
  end;
end;

procedure TKisLetter.SetObjectTypeId(const Value: Integer);
begin
  if FObjectTypeId <> Value then
  begin
    FObjectTypeId := Value;
    Modified := True;
  end;
end;

procedure TKisLetter.SetOfficesId(const Value: SmallInt);
begin
  if FOfficesId <> Value then
  begin
    FOfficesId := Value;
    Modified := True;
  end;
end;

procedure TKisLetter.SetOrgDate(const Value: String);
begin
  if FOrgDate <> Value then
  begin
    FOrgDate := Value;
    Modified := True;
  end;
end;

procedure TKisLetter.SetOrgNumber(const Value: String);
begin
  if FOrgNumber <> Value then
  begin
    FOrgNumber := Value;
    Modified := True;
  end;
end;

procedure TKisLetter.SetOrgsId(const Value: Integer);
begin
  if Value <> FOrgsId then
  begin
    FOrgsId := Value;
    Modified := True;
  end;
end;

procedure TKisLetter.UnprepareEditor(Editor: TKisEntityEditor);
begin
  with Editor as TKisLetterEditor do
  begin
    dsAddresses.DataSet := nil;
    FAddresses.AfterInsert := nil;
    dsOfficeDocs.DataSet := nil;
    FOfficesDocs.AfterInsert := nil;
    dsPassings.DataSet := nil;
    FPassings.AfterInsert := nil;
    Passings.BeforeDelete := nil;
    dsVisas.DataSet := nil;
    FVisas.AfterInsert := nil;
    Visas.BeforeDelete := nil;
    btnGenerateKGANumber.OnClick := nil;
    btnGenerateMPNumber.OnClick := nil;
    btnFirmSelect.OnClick := nil;
    btnFirmDetail.OnClick := nil;
    btnFirmClear.OnClick := nil;
    dbgPassings.OnDrawColumnCell := nil;
    btnOfficeDocCreate.OnClick := nil;
    btnOfficeDocDelete.OnClick := nil;
  end;
  inherited;
end;

procedure TKisLetter.UpdateKGANumber;
begin
  if Assigned(EntityEditor) then
  with EntityEditor as TKisLetterEditor do
    edDocNumber.Text := DocNumber;
end;

procedure TKisLetter.UpdateMPNumber;
begin
  if Assigned(EntityEditor) then
  with EntityEditor as TKisLetterEditor do
    edMPNumber.Text := MPNumber;
end;

procedure TKisLetter.VisasInsert(DataSet: TDataSet);
begin
  // Здесь показываем редактор подписи
  TKisLetterVisa(FVisasCtrlr.Elements[0]).DocDate := FormatDateTime(S_DATESTR_FORMAT, Date);
  if not TKisVisualEntity(FVisasCtrlr.Elements[0]).Edit then
    DataSet.Cancel
  else
    DataSet.Post;
end;

procedure TKisLetter.UpdateFirm;
begin
  if Assigned(EntityEditor) then
  with EntityEditor as TKisLetterEditor do
    edFirmName.Text := Self.FirmName;
end;

procedure TKisLetter.ShowFirm(Sender: TObject);
begin
  if FFirmId > 0 then
    with KisObject(AppModule.Mngrs[kmFirms].GetEntity(FFirmId)) do
    if Assigned(AEntity) then
      with AEntity as TKisVisualEntity do
      begin
        ReadOnly := True;
        Edit;
      end;
end;

procedure TKisLetter.ClearFirm(Sender: TObject);
begin
  FirmId := -1;
  FirmName := '';
  UpdateFirm;
end;

procedure TKisLetter.SetParentId(const Value: Integer);
begin
  if FParentId <> Value then
  begin
    FParentId := Value;
    Modified := True;
  end;
end;

procedure TKisLetter.DBGridDrawColumnCell(Sender: TObject;
  const Rect: TRect; DataCol: Integer; Column: TColumn;
  State: TGridDrawState);
var
  I, X, Y: Integer;
begin
  // отрисовка галочки в чек-боксе
  if Sender is TDBGrid then
  if Column.FieldName = SF_EXECUTED then
  begin
    with IObject(TBitmap.Create) do
    begin
      if Column.Field.AsBoolean then
        I := 21
      else
        I := 20;
      SQLMngr.ImageList.GetBitmap(I, TBitmap(AObject));
      TBitmap(AObject).TransparentColor := TBitmap(AObject).Canvas.Pixels[0, 0];
      TBitmap(AObject).Transparent := True;
      Y := Rect.Top + (Rect.Bottom - Rect.Top - TBitmap(AObject).Height) div 2;
      X := Rect.Left + (Rect.Right - Rect.Left - TBitmap(AObject).Width) div 2;
      TDBGrid(Sender).Canvas.FillRect(Rect);
      TDBGrid(Sender).Canvas.Draw(X, Y, TBitmap(AObject));
    end;
  end;
end;

function TKisLetter.GetHasChild: Boolean;
begin
  Result := TKisLetterMngr(Self.Manager).IsLetterHasChild(Self.ID);
end;

procedure TKisLetter.PassingsBeforeDelete(DataSet: TDataSet);
begin
  if DataSet.IsEmpty then
    Abort;
  if MessageBox(EntityEditor.Handle, PChar(S_CONFIRM_DELETE_PASSING), PChar(S_CONFIRM),
    MB_YESNO + MB_ICONQUESTION) <> ID_YES then
    Abort;
end;

procedure TKisLetter.VisasBeforeDelete(DataSet: TDataSet);
begin
  if Visas.IsEmpty then
    Abort;
  if MessageBox(EntityEditor.Handle, PChar(S_CONFIRM_DELETE_VISA), PChar(S_CONFIRM),
    MB_YESNO + MB_ICONQUESTION) <> ID_YES then
        Abort;
end;

function TKisLetter.GetHasCandidate: Boolean;
begin
  Result := TKisLetterMngr(Manager).LetterHasChild(Self);
end;

procedure TKisLetter.EditPassingOrVisa(Sender: TObject);
begin
  if Assigned(EntityEditor) and (Screen.ActiveForm = EntityEditor) then
    with EntityEditor as TKisLetterEditor do
    begin
      if dbgPassings.Focused then
        EditPassings
      else
      if dbgVisas.Focused then
        EditVisas;
    end;
end;

{$IFDEF ENTPARAMS}
procedure TKisLetter.InitParams;
begin
  inherited;
  AddParam(SF_DOC_NUMBER);
  AddParam(SF_DOC_DATE);
  AddParam(SF_FIRM_NAME);
  AddParam(SF_MP_NUMBER);
  AddParam(SF_MP_DATE);
  AddParam(SF_EXECUTOR);
end;
{$ENDIF}

function TKisLetter.GetDocNumber: String;
begin
  Result := Self[SF_DOC_NUMBER].AsString;
end;

function TKisLetter.GetDocDate: String;
begin
  Result := Self[SF_DOC_DATE].AsString;
end;

function TKisLetter.GetFirmName: String;
begin
  Result := Self[SF_FIRM_NAME].AsString;
end;

function TKisLetter.GetMPDate: String;
begin
  Result := Self[SF_MP_DATE].AsString;
end;

function TKisLetter.GetMPNumber: String;
begin
  Result := Self[SF_MP_NUMBER].AsString;
end;

procedure TKisLetter.CreateOfficeDoc(Sender: TObject);
var
  OfficeDoc: TKisEntity;
begin
  OfficeDoc := TKisLetterMngr(Manager).CreateOfficeDocForLetter(Self);
  if Assigned(OfficeDoc) then
  begin
    Self.AttachOfficeDoc(OfficeDoc);
    OfficesDocs.Last;
    OfficesDocs.Refresh;
  end;
end;

procedure TKisLetter.DeleteOfficeDoc(Sender: TObject);
begin
  if Self.OfficesDocs.Active and not Self.OfficesDocs.IsEmpty then
    if MessageBox(EntityEditor.Handle, PChar(S_CONFIRM_DELETE_OFF_DOC_LETTER),
         PChar(S_CONFIRM), MB_YESNO + MB_ICONQUESTION) = ID_YES then
    begin
      Self.OfficesDocs.Delete;
    end;
end;

procedure TKisLetter.EditOfficeDoc(Sender: TObject);
var
  OfficeDoc: TKisOfficeDoc;
  aId: Integer;
begin
  if OfficesDocs.Active and not OfficesDocs.IsEmpty then
  begin
    // [!!!]  Перекинуть код по управлению транзакциями в менеджер
    if Assigned(SQLMngr.DefaultTransaction) then
      AppModule.SQLMngrs[kmOfficeDocs].DefaultTransaction := SQLMngr.DefaultTransaction;
    try
      aId := OfficesDocs.FieldByName(SF_OFFICE_DOCS_ID).AsInteger;
      OfficeDoc := KisObject(AppModule[kmOfficeDocs].GetEntity(aId, keOfficeDoc)).AEntity as TKisOfficeDoc;
      begin
        if Assigned(OfficeDoc) then
        begin
          if (AppModule.User.OfficeID = OfficeDoc.OfficesId)
             or AppModule.User.IsAdministrator then
          begin
            OfficeDoc.Modified := False;
            OfficeDoc.ReadOnly := False;
            if OfficeDoc.Edit and OfficeDoc.Modified then
            begin
              AppModule[kmOfficeDocs].SaveEntity(OfficeDoc);
              with OfficesDocs do
              begin
                Edit;
                FieldByName(SF_OFFICE_DOCS_ID).AsInteger := OfficeDoc.ID;
                FieldbyName(SF_PEOPLE_ID).AsInteger := OfficeDoc.PeopleId;
                FieldByName(SF_DOC_DATE).Value := OfficeDoc.DocDate;
                FieldByName(SF_DOC_NUMBER).Value := OfficeDoc.DocNumber;
                Post;
                Refresh;
              end;
            end;
          end
          else
            MessageBox(EntityEditor.Handle, PChar(S_CANT_EDIT_OFFICE_DOC), PChar(S_WARN), MB_OK);
        end;
      end;
    finally
      if Assigned(SQLMngr.DefaultTransaction) then
        AppModule.SQLMngrs[kmOfficeDocs].DefaultTransaction := nil;
    end;
  end;
end;

procedure TKisLetter.DocTypeChange(Sender: TObject);
begin
  with EntityEditor as TKisLetterEditor do
    if cbDocTypesName.ItemIndex >= 0 then
      Self.DocTypesId := Integer(cbDocTypesName.Items.Objects[cbDocTypesName.ItemIndex])
    else
      Self.DocTypesId := -1;
end;

function TKisLetter.GetExecutor: String;
begin
  Result := Self[SF_EXECUTOR].AsString;
end;

procedure TKisLetter.SetExecutor(const Value: String);
begin
  if Executor <> Value then
  begin
    Self[SF_EXECUTOR].Value := Value;
    Modified := True;
  end;
end;

function TKisLetter.GetChildId: Integer;
begin
  Result := (Self.Manager as TKisLetterMngr).GetLetterHasChild(ID);
end;

procedure TKisLetter.AddressEdit(DataSet: TDataSet);
var
  S: String;
begin
  S := Addresses.FieldByName(SF_ADDRESS).AsString;
  if DoSelectAddress(True, S) then
  begin
    Addresses.FieldByName(SF_ADDRESS).AsString := s;
    Addresses.Post;
  end
  else
    Addresses.Cancel;
end;

procedure TKisLetter.EditorSetExecuted(Sender: TObject);
var
  I: Integer;
begin
  if Assigned(EntityEditor) then
    with EntityEditor as TKisLetterEditor do
      if chExecuted.Checked then
      if not Executed then // письмо еще не исполнено
        for I := 1 to FPassingCtrlr.GetRecordCount do
          if not TKisLetterPassing(FPassingCtrlr.Elements[I]).Executed then
          begin
            AppModule.Alert('Вы не можете списать письмо,'#13#10'т.к. есть не исполненные движения!');
            chExecuted.Checked := False;
            Exit;
          end;
end;

function TKisLetter.GetParentPassings: TDataSet;
begin
  Result := FParentPassings;
end;

function TKisLetter.GetOutcomLetter: TDataSet;
begin
  Result := FOutcomLetter;
end;

procedure TKisLetter.CreateOutcomLetter(Sender: TObject);
var
  Ent: TKisOutcomingLetter;
  LettLnk: TKisLettersLink;
  NeedBack: Boolean;
begin
  Ent := KisObject(AppModule[kmOutcomingLetters].CreateNewEntity(keOutcomingLetter)).AEntity as TKisOutcomingLetter; //создаем исходящее письмо
  if Assigned(Ent) then
  with Ent do
  begin
    //добавляем входящее в Исходящих
    LettLnk := AppModule[kmOutcomingLetters].CreateNewEntity(keLettersLink) as TKisLettersLink;
    LettLnk.IncomLetterId := Self.ID; //запоминаем ID входящего в Исходящих
    LettLnk.DocNumber := Self.DocNumber;
    LettLnk.DocDate := Self.DocDate;
    LettLnk.NumberMP := Self.MPNumber;
    LettLnk.DateMP := Self.MPDate;
    Ent.LettersLinkCtrlr.DirectAppend(LettLnk);
    Ent.LettersLink.Last;
    Ent.OrgsId := FOrgsId;
    Ent.OfficeID := FOfficesId;
    Ent.IsIncomLetter := True;
    if Edit then
    begin
      NeedBack := Assigned(SQLMngr.DefaultTransaction);
      if Needback then
        AppModule.SQLMngrs[kmOutcomingLetters].DefaultTransaction := SQLMngr.DefaultTransaction;
      AppModule[kmOutcomingLetters].SaveEntity(Ent);
      if Needback then
        AppModule.SQLMngrs[kmOutcomingLetters].DefaultTransaction := nil;
      //Добавляем исходящее письмо
      OutcomLetter.Append;
      OutcomLetter.FieldByName(SF_ID).AsInteger := LettLnk.ID;
     // OutcomLetter.FieldByName(SF_INCOMLETTER_ID).AsInteger := LettLnk.IncomLetterId;
      OutcomLetter.FieldByName(SF_OUTCOMLETTER_ID).AsInteger := Ent.ID;
      OutcomLetter.FieldByName(SF_SEQ_NUMBER).AsString := Ent.SeqNumber;
      OutcomLetter.FieldByName(SF_NUMBER).AsString := Ent.Number;
      OutcomLetter.FieldByName(SF_DATE_REG).AsString := DateToStr(Ent.DateReg);
      OutcomLetter.FieldByName(SF_FIRMS_ID).AsInteger := Ent.FirmId;
      OutcomLetter.FieldByName(SF_FIRM).AsString := Ent.Firm;
      //TKisOutcomLetter(FOutcomLetterCtrlr.Elements[0]).PeopleId := Ent.PeopleId;
      //TKisOutcomLetter(FOutcomLetterCtrlr.Elements[0]).OfficeId := Ent.OfficesId;
      OutcomLetter.Post;
      OutcomLetter.Refresh;
    end;
  end
end;

procedure TKisLetter.EditOutcomLetter(Sender: TObject);
begin
  if OutcomLetter.Active and not OutcomLetter.IsEmpty then
  begin
    if Assigned(SQLMngr.DefaultTransaction) then
      AppModule.SQLMngrs[kmOutcomingLetters].DefaultTransaction := SQLMngr.DefaultTransaction;
    try
      with KisObject(AppModule[kmOutcomingLetters].GetEntity(OutcomLetter.FieldByName(SF_OUTCOMLETTER_ID).AsInteger, keOutcomingLetter)) do
      begin
        if Assigned(AEntity) then
        begin
          if (AppModule.User.OrgId = TKisOutcomingLetter(AEntity).OrgsId)
             or AppModule.User.IsAdministrator then
          begin
            TKisVisualEntity(AEntity).ReadOnly := False;
            TKisOutcomingLetter(AEntity).IsIncomLetter := True;
            if TKisVisualEntity(AEntity).Edit then
              begin
              AppModule[kmOutcomingLetters].SaveEntity(AEntity);
              with OutcomLetter do
              begin
                Edit;
                FieldByName(SF_OUTCOMLETTER_ID).AsInteger := AEntity.ID;
                FieldbyName(SF_SEQ_NUMBER).AsString := TKisOutcomingLetter(AEntity).SeqNumber;
                FieldByName(SF_NUMBER).AsString := TKisOutcomingLetter(AEntity).Number;
                FieldByName(SF_DATE_REG).AsDateTime := TKisOutcomingLetter(AEntity).DateReg;
                FieldByName(SF_FIRMS_ID).AsInteger := TKisOutcomingLetter(AEntity).FirmId;
                FieldByName(SF_FIRM).AsString := TKisOutcomingLetter(AEntity).Firm;
                Post;
                Refresh;
              end;
            end;
          end
          else
            MessageBox(EntityEditor.Handle, PChar(S_CANT_EDIT_OFFICE_DOC), PChar(S_WARN), MB_OK);
        end;
      end;
    finally
      if Assigned(SQLMngr.DefaultTransaction) then
        AppModule.SQLMngrs[kmOutcomingLetters].DefaultTransaction := nil;
    end;
  end;
end;

function TKisLetter.AddressesAsText: String;
begin
  Result := '';
  with Self.Addresses do
  begin
    First;
    while not Eof do
    begin
      if Result <> '' then
        Result := Result + ', ';
      Result := Result + FieldByName(SF_ADDRESS).AsString;
      Next;
    end;
  end;
end;

procedure TKisLetter.AttachOfficeDoc(AOfficeDoc: TKisEntity);
var
  LOfficeDoc: TKisLetterOfficeDoc;
  I, Index: Integer;
begin
  LOfficeDoc := CreateOfficeDocInterface(AOfficeDoc);
  if not Assigned(LOfficeDoc) then
    Exit;
  // Ищем есть ли уже такой документ
  Index := 0;
  for I := 1 to OfficesDocs.RecordCount do
    if TKisLetterOfficeDoc(FOfficeDocCtrlr.Elements[I]).OfficeDocId = AOfficeDoc.ID then
    begin
      Index := I;
      Break;
    end;
  if Index > 0 then
    // Если есть, то заменяем
    FOfficeDocCtrlr.DirectReplace(Index, LOfficeDoc)
  else // Иначе добавляем
    FOfficeDocCtrlr.DirectAppend(LOfficeDoc);
  Modified:= True;
end;

function TKisLetter.CreateOfficeDocInterface(
  OfficeDoc: TKisEntity): TKisLetterOfficeDoc;
begin
  Result := nil;
  if not Assigned(OfficeDoc) then
    Exit;
  Result := Manager.CreateEntity(keLetterOfficeDoc) as TKisLetterOfficeDoc;
  with OfficeDoc as TKisOfficeDoc do
  begin
    Result.ID := GetIDForLetter(Self.ID);
    Result.OfficeId := OfficesId;
    Result.PeopleId := PeopleId;
    Result.OfficeDocId := OfficeDoc.ID;
    Result.DocDate := DocDate;
    Result.DocNumber := DocNumber;
    Result.FExecutorDate := ExecutorDate;
  end;

end;

procedure TKisLetter.CopyMain(Source: TKisLetter);
begin
  with Source do
  begin
    Self.FDocTypesId := DocTypesId;
    Self.DocNumber := DocNumber;
    Self.DocDate := DocDate;
    Self.FOrgNumber := OrgNumber;
    Self.FOrgDate := OrgDate;
    Self.FAdmNumber := AdmNumber;
    Self.FAdmDate := AdmDate;
    Self.MPNumber := MPNumber;
    Self.MPDate := MPDate;
    Self.FFirmId := FirmId;
    Self.FirmName := FirmName;
    Self.FContent := Content;
    Self.FExecuted := Executed;
    Self.FExecuteInfo := ExecuteInfo;
    Self.FControlDate := ControlDate;
    Self.FOrgsId := OrgsId;
    Self.FOfficesId := OfficesId;
//    Self.FControlDate2 := ControlDate2;
//    Self.FExecuted2 := Executed2;
  end;
end;

procedure TKisLetter.CopyVisas(Source: TKisLetter);
begin
  FVisasCtrlr.DirectClear;
  CopyDataSet(Source.Visas, Self.Visas);
end;

procedure TKisLetter.CopyOfficeDocs(Source: TKisLetter);
begin
  Self.FOfficeDocCtrlr.DirectClear;
  CopyDataSet(Source.OfficesDocs, Self.OfficesDocs);
end;

procedure TKisLetter.CopyAddresses(Source: TKisLetter);
begin
  Self.FAddrCtrlr.DirectClear;
  CopyDataSet(Source.Addresses, Self.Addresses);
end;

procedure TKisLetter.CopyPassings(Source: TKisLetter);
begin
  Self.FPassingCtrlr.DirectClear;
  CopyDataSet(Source.Passings, Self.Passings);
end;

procedure TKisLetter.CopyOutcomings(Source: TKisLetter);
begin
  Self.FOutcomLetterCtrlr.DirectClear;
  CopyDataSet(Source.OutcomLetter, Self.OutcomLetter);
end;

procedure TKisLetter.CopyParentPassings(Source: TKisLetter);
begin
  Self.FParentPassingCtrlr.DirectClear;
  CopyDataSet(Source.ParentPassings, Self.ParentPassings);
end;

procedure TKisLetter.EditPassings;
var
  Tmp: TKisLetterPassing;
begin
  if not Passings.IsEmpty then
  begin
    Passings.Edit;
    Tmp := TKisLetterPassing(FPassingCtrlr.TempElement);
    if not AppModule.User.IsAdministrator then
      Tmp.ReadOnly := Self.ReadOnly or (Tmp.OrgsId <> Self.OrgsId);
    if Tmp.Edit then
      Passings.Post
    else
      Passings.Cancel;
  end;
end;

procedure TKisLetter.EditVisas;
var
  Tmp: TKisLetterVisa;
begin
  if not Visas.IsEmpty then
  begin
    Visas.Edit;
    Tmp := TKisLetterVisa(FVisasCtrlr.TempElement);
    Tmp.ReadOnly := Self.ReadOnly;
    if Tmp.Edit then
      Visas.Post
    else
      Visas.Cancel;
  end;
end;

procedure TKisLetter.AddressOnEditorChange(Sender: TObject);
begin
  if Selector.Active then
    Selector.Find(TKisLetterEditor(EntityEditor).dbgAddresses.InplaceEditor.Text);
end;

procedure TKisLetter.AddressOnEditorExit(Sender: TObject);
begin
  if Selector.Active then
    Selector.CloseForm(False);
end;

function TKisLetter.GetSelector: TKisStreetSelector;
begin
  if not Assigned(FSelector) then
    FSelector := TKisStreetSelector.Create;
  Result := FSelector;
end;

procedure TKisLetter.AddressOnEditorKeyPress(Sender: TObject;
  var Key: Char);
var
  S: String;
begin
  if Selector.Active then
  case Key of
  #13 :
    begin
      S := Selector.CloseForm(True);
      TKisLetterEditor(EntityEditor).dbgAddresses.InplaceEditor.Text := S;
    end;
  Chr(VK_ESCAPE) :
    Selector.CloseForm(False);
  end;
end;

procedure TKisLetter.AddressOnCreateEditor(Sender: TObject; var aEditor: TInplaceEdit; var DefaultEditor: Boolean);
begin
  aEditor := nil;
//  Selector.GetSelectorForm(TkisLetterEditor(EntityEditor).dbgAddresses.InplaceEditor).Show;
end;

procedure TKisLetter.SetControlDate2(const Value: String);
begin
//  if FControlDate2 <> Value then
//  begin
//    FControlDate2 := Value;
//    Modified := True;
//  end;
end;

procedure TKisLetter.SetExecuted2(const Value: Boolean);
begin
//  if FExecuted2 <> Value then
//  begin
//    FExecuted2 := Value;
//    Modified := True;
//  end;
end;

{ TLetterVisaCtrlr }

procedure TLetterVisaCtrlr.FillFieldDefs(FieldDefsRef: TFieldDefs);
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
    Name := SF_LETTERS_ID;
  end;
  with FieldDefsRef.AddFieldDef do
  begin
    DataType := ftString;
    FieldNo := 3;
    Size := 10;
    Name := SF_DOC_DATE;
  end;
  with FieldDefsRef.AddFieldDef do
  begin
    DataType := ftString;
    FieldNo := 4;
    Size := 10;
    Name := SF_CONTROL_DATE;
  end;
  with FieldDefsRef.AddFieldDef do
  begin
    DataType := ftString;
    FieldNo := 5;
    Name := SF_CONTENT;
    Size := 150;
  end;
  with FieldDefsRef.AddFieldDef do
  begin
    DataType := ftString;
    FieldNo := 6;
    Name := SF_SIGNATURE;
    Size := 25;
  end;
end;

function TLetterVisaCtrlr.GetDeleteQueryText: String;
var
  IDList: String;
  I: Integer;
begin
  Result := 'DELETE FROM LETTER_VISAS WHERE ID IN (%s)';
  IDList := '';
  for I := 0 to Pred(DeletedCount) do
  begin
    if I > 0 then
      IDList := IDList + ',';
    IDList := IDList + IntToStr(DeletedElements[I].ID);
  end;
  Result := Format(Result, [IDList]);
end;

function TLetterPassingCtrlr.GetDeleteQueryText: String;
var
  IDList: String;
  I: Integer;
begin
  Result := 'DELETE FROM LETTER_PASSINGS WHERE ID IN (%s)';
  IDList := '';
  for I := 0 to Pred(DeletedCount) do
  begin
    if I > 0 then
      IDList := IDList + ',';
    IDList := IDList + IntToStr(DeletedElements[I].ID);
  end;
  Result := Format(Result, [IDList]);
end;

function TLetterOfficeDocController.GetDeleteQueryText: String;
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

function TOutcomLetterController.GetDeleteQueryText: String;
var
  IDList: String;
  I: Integer;
begin
  Result := 'DELETE FROM LETTERS_LINK WHERE ID IN (%s)';
  IDList := '';
  for I := 0 to Pred(DeletedCount) do
  begin
    if I > 0 then
      IDList := IDList + ',';
    IDList := IDList + IntToStr(DeletedElements[I].ID);
  end;
  Result := Format(Result, [IDList]);
end;

function TLetterVisaCtrlr.GetFieldData(Index: Integer; Field: TField;
  out Data): Boolean;
begin
  try
    with Elements[Index] as TKisLetterVisa do
    case Field.FieldNo of
      1 :
        begin
          GetInteger(ID, Data);
        end;
      2 :
        begin
          GetInteger(HeadId, Data);
        end;
      3 :
        begin
          GetString(DocDate, Data);
        end;
      4 :
        begin
          GetString(ControlDate, Data);
        end;
      5 :
        begin
          GetString(Content, Data);
        end;
      6 :
        begin
          GetString(Signature, Data);
        end;
      else
        raise EDatabaseError.CreateFmt(S_FIELD_NOT_FOUND, [Field.FieldName]);
    end;
    Result := True;
  except
    Result := False;
  end;
end;

procedure TLetterVisaCtrlr.SetFieldData(Index: Integer; Field: TField;
  var Data);
begin
  try
    with TKisLetterVisa(Elements[Index]) do
    case Field.FieldNo of
    1 : ID := SetInteger(Data);
    2 : ; // LeterId только для чтения;
    3 : DocDate := StrPas(@Data);
    4 : ControlDate := StrPas(@Data);
    5 : Content := StrPas(@Data);
    6 : Signature := StrPas(@Data);
    end;
  except
    Exit;
  end;
end;

{ TKisLetterPassing }

constructor TKisLetterPassing.Create(AMngr: TKisMngr);
begin
  inherited;
  FOfficeLink := nil;
end;

destructor TKisLetterPassing.Destroy;
begin
{  if Assigned(FOffice) then
    FOffice.Free;}
  inherited;
end;

function TKisLetterPassing.GetOfficeShortName: String;
begin
  if Assigned(FOfficeLink) then
    Result := FOfficeLink.DataParams[SF_SHORT_NAME].Value
  else
    Result := '';
end;

function TKisLetterPassing.GetOfficesId: SmallInt;
begin
  if Assigned(FOfficeLink) then
    Result := FOfficeLink.ID
  else
    Result := 0;
end;

function TKisLetterPassing.GetPeopleId: Integer;
begin
  if Assigned(FPeopleLink) then
    Result := FPeopleLink.ID
  else
    Result := 0;
end;

function TKisLetterPassing.GetPeopleFullName: String;
begin
  if Assigned(FPeopleLink) then
    Result := FPeopleLink.DataParams[SF_FULL_NAME].Value
  else
    Result := '';
end;

procedure TKisLetterPassing.Load(DataSet: TDataSet);
begin
  inherited;
  with DataSet do
  begin
    ID := FieldByName(SF_ID).AsInteger;
    PeopleId := FieldByName(SF_PEOPLE_ID).AsInteger;
    OfficesId := FieldByName(SF_OFFICES_ID).AsInteger;
    Content := FieldByName(SF_CONTENT).AsString;
    DocDate := FieldByName(SF_DOC_DATE).AsString;
    Executed := Boolean(FieldByName(SF_EXECUTED).AsInteger);
    Self.Modified := True;
  end;
end;

procedure TKisLetterPassing.SetContent(const Value: String);
begin
  if Content <> Value then
  begin
    DataParams[SF_CONTENT].Value := Value;
    Modified := True;
  end;
end;

procedure TKisLetterPassing.SetDocDate(const Value: String);
begin
  if DocDate <> Value then
  begin
    DataParams[SF_DOC_DATE].Value := Value;
    Modified := True;
  end;
end;

procedure TKisLetterPassing.SetOfficesId(const Value: SmallInt);
begin
  if OfficesId <> Value then
  begin
    FOfficeLink := AppModule.Mngrs[kmOffices].GetEntity(Value);
    Modified := True;
  end;
end;

procedure TKisLetterPassing.SetPeopleId(const Value: Integer);
begin
  if PeopleId <> Value then
  begin
    FPeopleLink := AppModule.Mngrs[kmPeople].GetEntity(Value);
    Modified := True;
  end;
end;

procedure TKisLetterPassing.Copy(Source: TKisEntity);
begin
  inherited;
  with TKisLetterPassing(Source) do
  begin
    Self.FPeopleLink := FPeopleLink;
    Self.FOfficeLink := FOfficeLink;
  end;
end;

{$IFDEF ENTPARAMS}
procedure TKisLetterPassing.InitParams;
begin
  inherited;
  AddParam(SF_CONTENT);
  AddParam(SF_DOC_DATE);
  AddParam(SF_EXECUTED);
end;
{$ENDIF}

function TKisLetterPassing.GetContent: String;
begin
  Result := DataParams[SF_CONTENT].AsString;
end;

function TKisLetterPassing.GetDocDate: String;
begin
  Result := DataParams[SF_DOC_DATE].AsString;
end;

function TKisLetterPassing.GetText: String;
begin
  Result := DocDate;
  if Result <> '' then
    Result := Result + ': ';
  Result := Result + OfficeShortName + ' ' + PeopleFullName + ' ' + Content;
end;

function TKisLetterPassing.CreateEditor: TKisEntityEditor;
begin
  EntityEditor := TKisLetterPassingEditor.Create(nil);
  Result := EntityEditor;
end;

procedure TKisLetterPassing.PrepareEditor(AEditor: TKisEntityEditor);
begin
  inherited;
  with AEditor as TKisLetterPassingEditor do
  begin
    SetOfficesList(cbOffices.Items);
    cbOffices.OnChange := OfficeChange;
  end;
end;

procedure TKisLetterPassing.OfficeChange(Sender: TObject);
begin
  if Assigned(EntityEditor) then
  with EntityEditor as TKisLetterPassingEditor do
  begin
    if cbOffices.ItemIndex < 0 then
      Self.OfficesId := 0
    else
      Self.OfficesId := Integer(cbOffices.Items.Objects[cbOffices.ItemIndex]);
    SetPeopleList(cbPeople.Items);
    cbPeople.ItemIndex := -1;
  end;
end;

procedure TKisLetterPassing.SetOfficesList(AList: TStrings);
var
  OrgIdForList: Integer;
begin
  if Self.OrgsId > 0 then
    OrgIdForList := Self.OrgsId
  else
    OrgIdForList := TKisLetter(Self.Head).OrgsId;

  Alist.Clear;
  AList.Assign(IObject(AppModule.OfficesList(OrgIdForList)).AObject as TStrings);
  if {((TKisLetter(Self.Head).ParentId < 1) and (not TKisLetter(Self.Head).HasChild)
    and} (not TKisLetter(Self.Head).HasCandidate){)} then
  begin
    if TKisLetter(Self.Head).OrgsId = ID_ORGS_KGA then
      AList.AddObject('МП УГА Администрация', Pointer(ID_OFFICE_MP_ADMIN))
    else
    if TKisLetter(Self.Head).OrgsId = ID_ORGS_UGA then
      AList.AddObject('КГА Администрация', Pointer(ID_OFFICE_KGA_ADMIN));
  end
  else
  begin
    if TKisLetter(Self.Head).OrgsId <> Self.OrgsId then
    begin
      if Self.OrgsId = ID_ORGS_UGA then
        AList.AddObject('МП УГА Администрация', Pointer(ID_OFFICE_MP_ADMIN))
      else
      if Self.OrgsId = ID_ORGS_KGA then
        AList.AddObject('КГА Администрация', Pointer(ID_OFFICE_KGA_ADMIN));
    end;
  end;
end;

procedure TKisLetterPassing.SetPeopleList(AList: TStrings);
begin
  Alist.Clear;
  AList.Assign(IObject(AppModule.PeolpeList(Self.OfficesId)).AObject as TStrings);
end;

procedure TKisLetterPassing.UnprepareEditor(AEditor: TKisEntityEditor);
begin
  with AEditor as TKisLetterPassingEditor do
  begin
    cbOffices.OnChange := nil;
  end;
  inherited;
end;

procedure TKisLetterPassing.LoadDataIntoEditor(AEditor: TKisEntityEditor);
begin
  inherited;
  with AEditor as TKisLetterPassingEditor do
  begin
    edDocDate.Text := DocDate;
    edContent.Text := Content;
    chbExecuted.Checked := Boolean(Self.Executed);
    uKisUtils.ComboLocate(cbOffices, Self.OfficesId);
    OfficeChange(nil);
    uKisUtils.ComboLocate(cbPeople, Self.PeopleId);
  end;
end;

procedure TKisLetterPassing.ReadDataFromEditor(AEditor: TKisEntityEditor);
begin
  inherited;
  with AEditor as TKisLetterPassingEditor do
  begin
    DocDate := Trim(edDocDate.Text);
    Content := Trim(edContent.Text);
    Executed := chbExecuted.Checked;
    OfficesId := Integer(cbOffices.Items.Objects[cbOffices.ItemIndex]);
    PeopleId := Integer(cbPeople.Items.Objects[cbPeople.ItemIndex]);
  end;
end;

function TKisLetterPassing.CheckEditor(AEditor: TKisEntityEditor): Boolean;
var
  D: TDateTime;
begin
  with AEditor as TKisLetterPassingEditor do
  begin
    if (edDocDate.Text = '') or (not TryStrToDate(edDocDate.Text, D) or
      ((D > Date) or (D < MIN_DOC_DATE))) then
    begin
      MessageBox(Handle, PChar(S_CHECK_DATE), PChar(S_WARN), MB_OK + MB_ICONWARNING);
      edDocDate.SetFocus;
      Result := False;
      Exit;
    end;
    if cbOffices.ItemIndex < 0 then
    begin
      MessageBox(Handle, PChar(S_CHECK_OFFICE), PChar(S_WARN), MB_OK + MB_ICONWARNING);
      cbOffices.SetFocus;
      Result := False;
      Exit;
    end;
    if cbPeople.ItemIndex < 0 then
    begin
      MessageBox(Handle, PChar(S_CHECK_WORKER), PChar(S_WARN), MB_OK + MB_ICONWARNING);
      cbPeople.SetFocus;
      Result := False;
      Exit;
    end;
  end;
  Result := True;
end;

function TKisLetterPassing.GetExecuted: Boolean;
begin
  Result := DataParams[SF_EXECUTED].AsBoolean;
end;

procedure TKisLetterPassing.SetExecuted(const Value: Boolean);
begin
  if Executed <> Value then
  begin
    DataParams[SF_EXECUTED].Value := Value;
    Modified := True;
  end;
end;

class function TKisLetterPassing.EntityName: String;
begin
  Result := SEN_PASSING;
end;

function TKisLetterPassing.GetOrgsId: Integer;
begin
  if Assigned(FOfficeLink) then
    Result := FOfficeLink[SF_ORGS_ID].AsInteger
  else
    Result := 0;
end;

{ TLetterPassingCtrlr }

procedure TLetterPassingCtrlr.FillFieldDefs(FieldDefsRef: TFieldDefs);
begin
{   LETTERS_ID  INTEGER NOT NULL,
    ID          SMALLINT NOT NULL,
    DOC_DATE    TIMESTAMP NOT NULL,
    CONTENT     VARCHAR(150) COLLATE PXW_CYRL,
    OFFICES_ID  SMALLINT NOT NULL,
    PEOPLE_ID   INTEGER NOT NULL,
    ORGS_ID     INTEGER}
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
    Name := SF_LETTERS_ID;
  end;
  with FieldDefsRef.AddFieldDef do
  begin
    DataType := ftString;
    FieldNo := 3;
    Size := 10;
    Name := SF_DOC_DATE;
  end;
  with FieldDefsRef.AddFieldDef do
  begin
    DataType := ftString;
    FieldNo := 4;
    Name := SF_CONTENT;
    Size := 150;
  end;
  with FieldDefsRef.AddFieldDef do
  begin
    DataType := ftInteger;
    FieldNo := 5;
    Name := SF_OFFICES_ID;
  end;
  with FieldDefsRef.AddFieldDef do
  begin
    DataType := ftInteger;
    FieldNo := 6;
    Name := SF_PEOPLE_ID;
  end;
  with FieldDefsRef.AddFieldDef do
  begin
    DataType := ftString;
    FieldNo := 7;
    Name := SF_OFFICES_NAME;
    Size := 25;
  end;
  with FieldDefsRef.AddFieldDef do
  begin
    DataType := ftString;
    FieldNo := 8;
    Name := SF_PEOPLE_FULL_NAME;
    Size := 77;
  end;
  with FieldDefsRef.AddFieldDef do
  begin
    DataType := ftBoolean;
    FieldNo := 9;
    Name := SF_EXECUTED;
  end;
end;

function TLetterPassingCtrlr.GetFieldData(Index: Integer; Field: TField;
  out Data): Boolean;
var
  Ent: TKisLetterPassing;
begin
  try
    Ent := TKisLetterPassing(Elements[Index]);
    case Field.FieldNo of
    1 : GetInteger(Ent.ID, Data);
    2 : GetInteger(Ent.HeadId, Data);
    3 : GetString(Ent.DocDate, Data);
    4 : GetString(Ent.Content, Data);
    5 : GetInteger(Ent.OfficesId, Data);
    6 : GetInteger(Ent.PeopleId, Data);
    7 : GetString(Ent.OfficeShortName, Data);
    8 : GetString(Ent.PeopleFullName, Data);
    9 : GetBoolean(Ent.Executed, Data);
    else
      raise EDatabaseError.CreateFmt(S_FIELD_NOT_FOUND, [Field.FieldName]);
    end;
    Result := True;
  except
    Result := False;
  end;
end;

procedure TLetterPassingCtrlr.SetFieldData(Index: Integer; Field: TField;
  var Data);
var
  Ent: TKisLetterPassing;
begin
  try
    Ent := TKisLetterPassing(Elements[Index]);
    case Field.FieldNo of
    1 : Ent.ID := SetInteger(Data);
    2 : ;//Ent.HeadId := SetInteger(Data);
    3 : Ent.DocDate := SetString(Data);
    4 : Ent.Content := SetString(Data);
    5 : Ent.OfficesId := SetInteger(Data);
    6 : Ent.PeopleId := SetInteger(Data);
    7 : ;//Ent.OfficesShortName := SetInteger(Data);
    9 : Ent.Executed := SetBoolean(Data);
    end;
  except
  end;
end;

{ TKisLetterOfficeDoc }

procedure TKisLetterOfficeDoc.Copy(Source: TKisEntity);
begin
  inherited;
  with TKisLetterOfficeDoc(Source) do
  begin
    Self.PeopleId := PeopleId;
    Self.OfficeId := OfficeId;
    Self.FExecutorDate := FExecutorDate;
  end;
end;

class function TKisLetterOfficeDoc.EntityName: String;
begin
  Result := SEN_OFFICE_DOC;
end;

function TKisLetterOfficeDoc.GetDocNumber: String;
begin
  Result := Self[SF_DOC_NUMBER].AsString;
end;

function TKisLetterOfficeDoc.GetDocDate: String;
begin
  Result := Self[SF_DOC_DATE].AsString;
end;

function TKisLetterOfficeDoc.GetExecutorDate: String;
begin
  Result := FExecutorDate;
end;

function TKisLetterOfficeDoc.GetOfficeDocId: Integer;
begin
  Result := Self[SF_OFFICE_DOCS_ID].AsInteger;
end;

function TKisLetterOfficeDoc.GetOfficeId: Integer;
begin
  if Assigned(FOfficeLink) then
    Result := FOfficeLink.ID
  else
    Result := 0;
end;

function TKisLetterOfficeDoc.GetPeopleId: Integer;
begin
  if Assigned(FPeopleLink) then
    Result := FPeopleLink.ID
  else
    Result := 0;
end;

{$IFDEF ENTPARAMS}
procedure TKisLetterOfficeDoc.InitParams;
begin
  inherited;
  AddParam(SF_OFFICE_DOCS_ID);
  AddParam(SF_DOC_DATE);
  AddParam(SF_DOC_NUMBER);
  AddParam(SF_ACCOUNT);
  AddParam(SF_ACCOUNT_DATE);
  AddParam(SF_PEOPLE_ID);
  AddParam(SF_OFFICES_ID);
end;
{$ENDIF}

procedure TKisLetterOfficeDoc.Load(DataSet: TDataSet);
begin
  inherited;
  Id := DataSet.FieldByName(SF_ID).AsInteger;
//  DocId := DataSet.FieldByName(SF_OFFICE_DOCS_ID).AsInteger;
  Self[SF_OFFICE_DOCS_ID].Value := DataSet.FieldByName(SF_OFFICE_DOCS_ID).Value;
  Self[SF_DOC_DATE].Value := DataSet.FieldByName(SF_DOC_DATE).Value;
  Self[SF_DOC_NUMBER].Value := DataSet.FieldByName(SF_DOC_NUMBER).Value;
  Self.PeopleId := DataSet.FieldByName(SF_PEOPLE_ID).Value;
  Self.OfficeId := DataSet.FieldByName(SF_OFFICES_ID).AsInteger;
  Self.FExecutorDate := DataSet.FieldByName(SF_EXECUTOR_DATE).AsString;
  Modified := True;
end;

{ TKisLetterOfficeDocController }

procedure TLetterOfficeDocController.FillFieldDefs(
  FieldDefsRef: TFieldDefs);
begin
  FieldDefsRef.Clear;
  FieldDefsRef.Add(SF_ID, ftInteger);
  FieldDefsRef.Add(SF_LETTERS_ID, ftInteger);
  FieldDefsRef.Add(SF_OFFICE_DOCS_ID, ftInteger);
  FieldDefsRef.Add(SF_DOC_DATE, ftString, 4);
  FieldDefsRef.Add(SF_DOC_NUMBER, ftString, 10);
  FieldDefsRef.Add(SF_EXECUTOR, ftString, 50);
  FieldDefsRef.Add(SF_OFFICES_NAME, ftString, 10);
  FieldDefsRef.Add(SF_PEOPLE_ID, ftInteger);
  FieldDefsRef.Add(SF_EXECUTOR_DATE, ftString, 10);
end;

function TLetterOfficeDocController.GetFieldData(Index: Integer;
  Field: TField; out Data): Boolean;
var
  Ent: TKisLetterOfficeDoc;
begin
  try
    Result := True;
    Ent := TKisLetterOfficeDoc(Elements[Index]);
    if Index > 1 then
    begin
      Result := Index > 1;
    end;
    case Field.FieldNo of
    1 : GetInteger(Ent.ID, Data);
    2 : Integer(Data) := Ent.HeadId;
    3 : GetInteger(Ent[SF_OFFICE_DOCS_ID].AsInteger, Data);
    4 : GetString(Ent[SF_DOC_DATE].AsString, Data);
    5 : GetString(Ent[SF_DOC_NUMBER].AsString, Data);
    6 : if Assigned(Ent.People) then
          GetString(Ent.People[SF_INITIAL_NAME].AsString, Data)
        else
          Result := False;
    7 : if Assigned(Ent.Office) then
          GetString(Ent.Office[SF_SHORT_NAME].AsString, Data)
        else
          Result := False;
    8 : GetInteger(Ent.PeopleId, Data);
    9 : GetString(Ent.ExecutorDate, Data);
    else
      raise EDatabaseError.CreateFmt(S_FIELD_NOT_FOUND, [Field.FieldName]);
    end;
  except
    Result := False;
  end;
end;

procedure TLetterOfficeDocController.SetFieldData(Index: integer;
  Field: TField; var Data);
var
  Ent: TKisLetterOfficeDoc;
begin
  try
    Ent := TKisLetterOfficeDoc(Elements[Index]);
    case Field.FieldNo of
    1 : Ent.ID := SetInteger(Data);
    3 : Ent[SF_OFFICE_DOCS_ID].Value := SetInteger(Data);
    4 : Ent[SF_DOC_DATE].Value := SetString(Data);
    5 : Ent[SF_DOC_NUMBER].Value := SetString(Data);
    8 : Ent.PeopleId := SetInteger(Data);
    end;
  except
  end;
end;

procedure TKisLetterOfficeDoc.SetDocNumber(const Value: String);
begin
  if Self[SF_DOC_NUMBER].AsString <> Value then
  begin
    Self[SF_DOC_NUMBER].Value := Value;
    Modified := True;
  end;
end;

procedure TKisLetterOfficeDoc.SetDocDate(const Value: String);
begin
  if Self[SF_DOC_DATE].AsString <> Value then
  begin
    Self[SF_DOC_DATE].Value := Value;
    Modified := True;
  end;
end;

procedure TKisLetterOfficeDoc.SetOfficeDocId(const Value: Integer);
begin
  if Self[SF_OFFICE_DOCS_ID].AsInteger <> Value then
  begin
    Self[SF_OFFICE_DOCS_ID].Value := Value;
    Modified := True;
  end;
end;

procedure TKisLetterOfficeDoc.SetOfficeId(const Value: Integer);
begin
  if OfficeId <> Value then
  begin
    FOfficeLink := AppModule[kmOffices].GetEntity(Value);
    if Assigned(FOfficeLink) then
      Self[SF_OFFICES_ID].Value := FOfficeLink.ID
    else
      Self[SF_OFFICES_ID].Clear;
    Modified := True;
  end;
end;

procedure TKisLetterOfficeDoc.SetPeolpeId(const Value: Integer);
begin
  if PeopleId <> Value then
  begin
    FPeopleLink := AppModule[kmPeople].GetEntity(Value);
    if Assigned(FPeopleLink) then
      Self[SF_PEOPLE_ID].Value := FPeopleLink.ID
    else
      Self[SF_PEOPLE_ID].Clear;
    Modified := True;
  end;
end;

{ TKisLetterMngr }

procedure TKisLetterMngr.Activate;
begin
  inherited;
  dsLettersID.Visible := AppModule.User.IsAdministrator;
  //
  dsLetters.Transaction := AppModule.Pool.Get;
  dsLetters.Transaction.Init(ilReadCommited, amReadWrite);
  dsLetters.Transaction.AutoStopAction := saNone;
  dsCandidates.Transaction := dsLetters.Transaction;
  dsOrders.Transaction := dsLetters.Transaction;
  Reopen;
end;

function TKisLetterMngr.CreateNewEntity(
  EntityKind: TKisEntities): TKisEntity;
begin
  Result := CreateEntity(EntityKind);
  Result.ID := Self.GenEntityID(EntityKind);
end;

procedure TKisLetterMngr.DataModuleCreate(Sender: TObject);
begin
  inherited;
  dsOrders.SelectSQL.Text := SQ_GET_LETTER_ORDERS;
end;

procedure TKisLetterMngr.DateFilterChange(Sender: TObject);
var
  Combo: TComboBox;
  OldCursor: TCursor;
//  Tc1, Tc2: Cardinal;
begin
//  Tc1 := GetTickCount;
  if Sender is TComboBox then
  begin
    Combo := TComboBox(Sender);
    OldCursor := FView.Cursor;
    FView.Cursor := crSQLWait;
    try
      if Combo.ItemIndex = 1 then
        ApplyFilters(TFilterFactory.CreateList(CreateDateFilter), False)
      else
        CancelFilters(TFilterFactory.CreateList(CreateDateFilter));
    finally
      FView.Cursor := OldCursor;
    end;
  end;
//  Tc2 := GetTickCount;
//  ShowMessage(IntToStr(Tc2 - Tc1));
end;

procedure TKisLetterMngr.Deactivate;
begin
  if dsLetters.Transaction.Active then
    dsLetters.Transaction.Commit;
  AppModule.Pool.Back(dsLetters.Transaction);
  dsLetters.Transaction := nil;
  dsCandidates.Transaction := nil;
  inherited;
end;

function TKisLetterMngr.EditEntity(Entity: TKisEntity): TKisEntity;
begin
  Result := nil;
  if IsSupported(Entity) and (Entity is TKisLetter) then
  begin
    Result := TKisLetter.Create(Self);
    Result.Assign(Entity);
    Result.Modified := TKisLetter(Result).Edit;
  end;
end;

function TKisLetterMngr.FindLetter(const OrdId, DocTypeId: Integer;
  const OrgNumber: String; const LetterDate: TDateTime;
  const ExactNumber: Boolean): TKisLetter;
var
  Conn: IKisConnection;
  Sql: String;
  Ds: TDataSet;
  Mask: TNumberMask;
  MaskText, WFNum: String;
begin
  Result := nil;
  Conn := GetConnection(True, False);
  try
    case OrdId of
    ID_ORGS_DGA: Sql := SQ_FIND_DGA_LETTER;
    ID_ORGS_KGA: Sql := SQ_FIND_KGA_LETTER;
    ID_ORGS_UGA: Sql := SQ_FIND_UGA_LETTER;
    end;
    Ds := Conn.GetDataSet(Sql);
    Conn.SetParam(Ds, SF_DOC_DATE, YearOf(LetterDate));
    //
    MaskText := AppModule.User.GetDocTypeMask(OrdId, DocTypeId);
    Mask := IObject(TNumberMask.Create(MaskText)).AObject as TNumberMask;
    if ExactNumber or (Mask.NumberLength = 0) then
    begin
      Conn.SetParam(Ds, SF_DOC_NUMBER, OrgNumber);
      Ds.Open;
      if not Ds.IsEmpty then
        Result := GetEntity(Ds.Fields[0].AsInteger, keLetter) as TKisLetter;
      Ds.Close;
    end
    else
    begin
      while (not Assigned(Result)) and (Mask.NumberLength > 0) do
      begin
        if Mask.FormatNumber(OrgNumber, WFNum) then
        begin
          Conn.SetParam(Ds, SF_DOC_NUMBER, WFNum);
          Ds.Open;
          if not Ds.IsEmpty then
            Result := GetEntity(Ds.Fields[0].AsInteger, keLetter) as TKisLetter;
          Ds.Close;
        end;
        Mask.NumberLength := Mask.NumberLength - 1;
      end;
    end;
  finally
    FreeConnection(Conn, True);
  end;
end;

function TKisLetterMngr.GenEntityID(EntityKind: TKisEntities): Integer;
var
  Conn: IKisConnection;
  S: String;
begin
  case EntityKind of
  keDefault, keLetter :
    S := SQ_GEN_LETTER_ID;
  keLetterObjAddress :
    S := SQ_GEN_LETTER_ADDRESS_ID;
  keLetterPassing :
    S := SQ_GEN_LETTER_PASSING_ID;
  keLetterVisa :
    S := SQ_GEN_LETTER_VISA_ID;
  keLetterOfficeDoc :
    S := SQ_GEN_LETTER_OFFICE_DOCS_ID;
  keLettersLink :
    S := SQ_GEN_LETTERS_LINK_ID;
  else
    raise Exception.CreateFmt(S_GEN_ID_ERROR, [KisMngrNames[Self.Ident]]);
  end;
  Conn := GetConnection(True, False);
  try
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

function TKisLetterMngr.GetEntity(EntityID: Integer;
  EntityKind: TKisEntities = keDefault): TKisEntity;
var
  S: String;
  DataSet: TDataSet;
  Conn: IKisConnection;
begin
  Result := nil;
  Conn := GetConnection(True, False);
  try
    case EntityKind of
    keDefault, keLetter :
      S := Format(SQ_GET_LETTER, [EntityID]);
    keLetterObjAddress :
      S := Format(SQ_GET_LETTER_ADDRESS, [EntityID]);
    keLetterPassing :
      S := Format(SQ_GET_LETTER_PASSING, [EntityID]);
    keLetterVisa :
      S := Format(SQ_GET_LETTER_VISA, [EntityID]);
    keLetterOfficeDoc :
      S := Format(SQ_GET_LETTER_OFFICE_DOC, [EntityID]);
    keLettersLink :
      S := Format(SQ_GET_OUTCOM_LETTERS, [EntityID]);
    else
      raise ELoadEntity.Create(EntityID, EntityKind);
    end;
    DataSet := Conn.GetDataSet(S);
    with DataSet do
    begin
      Open;
      if not IsEmpty then
      begin
        Result := CreateEntity(EntityKind);
        Result.Load(DataSet);
      end;
      Close;
    end;
  finally
    FreeConnection(Conn, True);
  end;
end;

function TKisLetterMngr.GetFilterDocTypeId: Integer;
begin
  Result := GetFilterId(SF_DOC_TYPES_ID);
end;

function TKisLetterMngr.GetFilterId(const FilterName: String): Integer;
var
  Fltr: IKisFilter;
begin
  Fltr := FFilters.Find(FilterName);
  if Assigned(Fltr) then
    Result := Fltr.Value
  else
    Result := 0;
end;

function TKisLetterMngr.GetFilterOfficeId: Integer;
begin
  Result := GetFilterId(SF_OFFICES_ID);
end;

function TKisLetterMngr.GetFilterOrgId: Integer;
begin
  Result := GetFilterId(SF_ORGS_ID);
end;

function TKisLetterMngr.GetIdent: TKisMngrs;
begin
  Result := kmLetters;
end;

function TKisLetterMngr.GetMainSQLText: String;
begin
  Result := SQ_SELECT_LETTERS_MAIN;
end;

function TKisLetterMngr.IsSupported(Entity: TKisEntity): Boolean;
begin
  Result := Assigned(Entity)
    and (   (Entity is TKisLetter)
         or (Entity is TKisLetterObjAddress)
         or (Entity is TKisLetterVisa)
         or (Entity is TKisLetterPassing)
         or (Entity is TKisLetterOfficeDoc)
         or (Entity is TKisOutcomLetter)
        );
  if not Result then
    inherited IsSupported(Entity);
end;

procedure TKisLetterMngr.SaveEntity(Entity: TKisEntity);
begin
  inherited;
  try
    if Assigned(Entity) then
    if IsSupported(Entity) then
    if (Entity is TKisLetter) then
      SaveLetter(Entity as TKisLetter)
    else
      if (Entity is TKisLetterObjAddress) then
        SaveLetterAddress(Entity)
      else
        if (Entity is TKisLetterVisa) then
          SaveLetterVisa(Entity)
        else
          if (Entity is TKisLetterPassing) then
            SaveLetterPassing(Entity)
          else
            if (Entity is TKisLetterOfficeDoc) then
              SaveLetterOfficeDoc(Entity)
            else
            if (Entity is TKisOutcomLetter) then
              SaveOutcomLetter(Entity);
  except
    //on E: EKisLetterError do
      //HandleKisLetterError(E, Entity);
    raise;
  end;
end;

procedure TKisLetterMngr.SaveLetter(Letter: TKisLetter);
var
  Conn: IKisConnection;
begin
  Conn := GetConnection(True, True);
  try
    if Letter.ID < 1 then
      Letter.ID := Self.GenEntityID(keLetter);
    // Сохраняем письмо
    with TKisLetterSaver.Create(Conn) do
    try
      Save(Letter);
    finally
      Free;
    end;
    // Сохраняем адреса
    SaveLetterAddresses(Letter);
    // Сохраняем визы
    SaveLetterVisas(Letter);
    // Сохраняем движение
    SaveLetterPassings(Letter);
    // Сохраняем документы отделов
    SaveLetterOfficeDocs(Letter);
    // Сохраняем исходящие письма
    SaveLetterOutcomings(Letter);
    // Сохраняем кандидатов
    SaveLetterCandidate(Letter);
    FreeConnection(Conn, True);
  except
    FreeConnection(Conn, False);
    raise;
  end;
end;

procedure TKisLetterMngr.SaveLetterAddress(Addr: TKisEntity);
var
  Conn: IKisConnection;
  DataSet: TDataSet;
begin
  Conn := GetConnection(True, True);
  try
    DataSet := Conn.GetDataSet(SQ_SAVE_LETTER_ADDRESS);
    if Addr.ID <= 1 then
      Addr.ID := Self.GenEntityID(keLetterObjAddress);
    with Addr as TKisLetterObjAddress do
    begin
      // :ID, :LETTERS_ID, :ADDRESS
      Conn.SetParam(DataSet, SF_ID, ID);
      Conn.SetParam(DataSet, SF_LETTERS_ID, HeadId);
      Conn.SetParam(DataSet, SF_ADDRESS, Address);
    end;
    DataSet.Open;
    FreeConnection(Conn, True);
  except
    FreeConnection(Conn, False);
    raise;
  end;
end;

procedure TKisLetterMngr.SaveLetterPassing(Passing: TKisEntity);
var
  Conn: IKisConnection;
  DataSet: TDataSet;
begin
  Conn := GetConnection(True, True);
  try
    DataSet := Conn.GetDataSet(SQ_SAVE_LETTER_PASSING);
//    :LETTERS_ID,:ID,:DOC_DATE,:CONTENT,:OFFICES_ID,:PEOPLE_ID,:EXECUTED
    if Passing.ID < 1 then
      Passing.ID := Self.GenEntityID(keLetterPassing);
    with Passing as TKisLetterPassing do
    begin
      Conn.SetParam(dataSet, SF_LETTERS_ID, HeadId);
      Conn.SetParam(DataSet, SF_ID, ID);
      if DocDate = '' then
        Conn.SetParam(DataSet, SF_DOC_DATE, NULL)
      else
        Conn.SetParam(DataSet, SF_DOC_DATE, StrToDate(DocDate));
      Conn.SetParam(DataSet, SF_CONTENT, Content);
      Conn.SetParam(DataSet, SF_OFFICES_ID, OfficesId);
      Conn.SetParam(DataSet, SF_PEOPLE_ID, PeopleId);
      Conn.SetParam(DataSet, SF_EXECUTED, Integer(Executed));
    end;
    DataSet.Open;
    FreeConnection(Conn, True);
  except
    FreeConnection(Conn, False);
    raise;
  end;
end;

procedure TKisLetterMngr.SaveLetterVisa(Visa: TKisEntity);
var
  Conn: IKisConnection;
  DataSet: TDataSet;
begin
  Conn := GetConnection(True, True);
  try
    DataSet := Conn.GetDataSet(SQ_SAVE_LETTER_VISA);
    if Visa.ID < 1 then
      Visa.ID := Self.GenEntityID(keLetterVisa);
    with Visa as TKisLetterVisa do
    begin
      // :LETTERS_ID,:ID,:DOC_DATE,:CONTROL_DATE,:CONTENT,:SIGNATURE
      Conn.SetParam(DataSet, SF_LETTERS_ID, HeadId);
      Conn.SetParam(DataSet, SF_ID, ID);
      Conn.SetParam(DataSet, SF_DOC_DATE, DocDate);
      Conn.SetParam(DataSet, SF_CONTROL_DATE, ControlDate);
      Conn.SetParam(DataSet, SF_CONTENT, Content);
      Conn.SetParam(DataSet, SF_SIGNATURE, Signature);
    end;
    DataSet.Open;
    FreeConnection(Conn, True);
  except
    FreeConnection(Conn, False);
    raise;
  end;
end;

procedure TKisLetterMngr.SaveLetterOfficeDoc(OfficeDoc: TKisEntity);
var
  Conn: IKisConnection;
  DataSet: TDataSet;
begin
  Conn := GetConnection(True, True);
  try
    DataSet := Conn.GetDataSet(SQ_SAVE_OFFICE_DOC_LETTER);
    if OfficeDoc.ID < 1 then
      OfficeDoc.ID := Self.GenEntityID(keLetterOfficeDoc);
    // :OFFICE_DOCS_ID, :ID, :LETTERS_ID
    with OfficeDoc as TKisLetterOfficeDoc do
    begin
      Conn.SetParam(DataSet, SF_OFFICE_DOCS_ID, OfficeDocId);
      Conn.SetParam(DataSet, SF_ID, OfficeDoc.ID);
      Conn.SetParam(DataSet, SF_LETTERS_ID, HeadId);
    end;
    DataSet.Open;
    FreeConnection(Conn, True);
  except
    FreeConnection(Conn, False);
    raise;
  end;
end;

procedure TKisLetterMngr.ApplyFilters(aFilters: IKisFilters; ClearExisting: Boolean);
var
  Fltr: IKisFilter;
begin
  if Assigned(FView) then
  begin
    Fltr := aFilters.Find(SF_DOC_DATE);
    if TKisLettersView(FView).cbDateFilter.ItemIndex = 1 then
    begin
      if not Assigned(Fltr) then
        aFilters.Add(CreateDateFilter);
    end;
  end;
  inherited;
  UpdateViewCaption(GetFilterOrgId, GetFilterDocTypeId);
  ViewUpdateOfficeCombo;
end;

procedure TKisLetterMngr.CreateView;
begin
  if not Assigned(FView) then
  begin
    FView := TKisLettersView.Create(Self);
    ReadReports;
  end;
  inherited;
  PrepareViewLegend;
  FView.Grid.OnCellColors := Self.GridCellColors;
  with TKisLettersView(FView) do
  begin
    if dgEditing in dbgCandidates.Options then
      dbgCandidates.Options := dbgCandidates.Options - [dgEditing];
    dbgCandidates.DataSource := Self.dsCandidatesSource;
    dbgCandidates.OnDblClick := CandidatesGridDblClick;
    dbgCandidates.OnMouseUp := CandidatesGridMouseUp;
    dbgCandidates.Visible := CandidatesEnabled;
    Splitter.Visible := dbgCandidates.Visible;
    dbgOrders.DataSource := dsOrdersSource;
    dbgOrders.OnCellColors := OrdersCellColors;
    cbOffice.OnChange := OfficeChange;
    ViewUpdateOfficeCombo;
    cbOffice.Enabled := AppModule.User.CanSeeAllOffices or AppModule.User.IsAdministrator;
    cbDateFilter.OnChange := DateFilterChange;
  end;
end;

procedure TKisLetterMngr.GridCellColors(Sender: TObject; Field: TField;
  var Background, FontColor: TColor; State: TGridDrawState; var FontStyle:TFontStyles);
var
  DataSet: TDataSet;
  Status: Integer;
begin
  DataSet := Field.DataSet;
  if gdSelected in State then
  begin
    BackGround := clHighlight;
    FontColor := clWhite;
  end
  else
  begin
    Status := DataSet.FieldByName(SF_LETTER_STATUS).AsInteger;
    case Status of
    0 : // нет заказов
        begin
          if not DataSet.FieldByName(SF_CONTROL_DATE).IsNull then
          begin
            if Boolean(DataSet.FieldByName(SF_EXECUTED).AsInteger) then
              Background := Color_Executed // исполнено
            else
            if (DataSet.FieldByName(SF_CONTROL_DATE).AsDateTime < Today)
               and
               (DataSet.FieldByName(SF_CONTROL_DATE).AsDateTime > EncodeDate(1990, 1, 1))
            then
              BackGround := Color_Overdue // просрочено
            else
              BackGround := Color_ControlDate;// с контрольной даты
          end
          else
          begin
            if Boolean(DataSet.FieldByName(SF_EXECUTED).AsInteger) then
              Background := Color_Executed // исполнено
            else
              BackGround := Color_Standard;
          end;
        end;
    1 : // не оплачен
        begin
          BackGround := Color_Standard;
        end;
    2 : // оплачен, но не выполнен
        begin
          BackGround := Color_ControlDate;
        end;
    3 : // выполнен
        begin
          Background := Color_Executed;
        end;
    4 : // просрочен
        begin
          BackGround := Color_Overdue;
        end;
    else
        BackGround := Color_Standard;
    end;
  end;
end;

procedure TKisLetterMngr.acLegendExecute(Sender: TObject);
begin
  inherited;
  FView.Legend.ShowLegend(FView.Height - FView.Legend.FormHeight,
                          FView.Width - FView.Legend.FormWidth);
end;

procedure TKisLetterMngr.PrepareSQLHelper;
var
  I: Integer;
begin
  inherited PrepareSQLHelper;
  with FSQLHelper do
  begin
    with AddTable do
    begin
      TableName := ST_LETTERS;
      TableLabel := 'Основная (письма)';
      AddStringField(SF_DOC_NUMBER, 'Номер КГА', 12, [fpSearch, fpSort, fpQuickSearch]);
      AddSimpleField(SF_DOC_DATE, 'Дата КГА', ftDate, [fpSearch, fpSort]);
      AddStringField(SF_MP_NUMBER, 'Номер МП УГА', 12, [fpSearch, fpSort, fpQuickSearch]);
      AddSimpleField(SF_MP_DATE, 'Дата МП УГА', ftDate, [fpSearch, fpSort]);
      AddStringField(SF_FIRM_NAME, 'Заказчик', 120, [fpSearch, fpSort, fpQuickSearch]);
      AddStringField(SF_EXECUTOR, 'Исполнитель', 300, [fpSearch, fpSort, fpQuickSearch]);
      AddSimpleField(SF_EXECUTED, 'Исполнено', ftBoolean, [fpSearch, fpSort]);
      AddStringField(SF_EXECUTE_INFO, 'Отметка об исполнении', 120, [fpSearch, fpSort, fpQuickSearch]);
      AddBlobField(SF_CONTENT, 'Содержание', 100, [fpSearch, fpSort]);
      AddStringField(SF_ORG_NUMBER, 'Номер отправителя', 20, [fpSearch, fpSort, fpQuickSearch]);
      AddSimpleField(SF_ORG_DATE, 'Дата отправителя', ftDate, [fpSearch, fpSort]);
      AddStringField(SF_ADM_NUMBER, 'Номер администрации', 10, [fpSearch, fpSort, fpQuickSearch]);
      AddSimpleField(SF_ADM_DATE, 'Дата администрации', ftDate, [fpSearch, fpSort]);
      AddSimpleField(SF_CONTROL_DATE, 'Контрольная дата', ftDate, [fpSearch, fpSort]);
      AddStringField(SF_YEAR_NUMBER, 'Год/Номер КГА', 19, [fpSearch, fpSort, fpQuickSearch]);
      AddStringField(SF_MP_YEAR_NUMBER, 'Год/Номер МП УГА', 19, [fpSearch, fpSort, fpQuickSearch]);
      AddSimpleField(SF_IS_OVERDUE, 'Просрочено', ftBoolean, [fpSearch, fpSort]);
      I := AddSimpleField(SF_LETTER_CONTROL_DATE{SF_CONTROL_DATE_2}, 'Контрольная дата 2', ftDate, [fpSearch, fpSort]);
      Fields[I].FIsForeign := True;
      Fields[I].FForeignTableName := 'GLS';//'GET_LETTER_STATUS';
      
      AddSimpleField(SF_EXECUTED_2, 'Исполнено 2', ftBoolean, [fpSearch, fpSort]);
      AddLookUpField(SF_LETTER_STATUS, 'Статус заказа', ST_LETTER_STATUS_NAMES, SF_ID, SF_NAME);
      I := AddSimpleField(SF_ID, SFL_INSERT_ORDER, ftInteger, [fpSort]);
    end;
{    with AddLinkedTable do
    begin
      TableName := ST_LETTER_PASSINGS;
      TableLabel := 'Движение';
      MasterField := Tables[0].Fields[I];
      AddStringField(SF_OFFICES_ID, 'Отдел', 300, [fpSearch]);
      I := AddSimpleField(SF_LETTERS_ID, '', ftInteger, []);
      DetailField := Fields[I];
    end;    }
    with AddLinkedTable do
    begin
      TableName := ST_LETTER_ADDRESSES;
      TableLabel := 'Адреса объектов';
      MasterField := Tables[0].Fields[I];
      AddStringField(SF_ADDRESS, 'Адрес', 300, [fpSearch]);
      I := AddSimpleField(SF_LETTERS_ID, '', ftInteger, []);
      DetailField := Fields[I];
    end;
    with AddTable do
    begin
      TableName := ST_DOC_TYPES;
      TableLabel := 'Типы входящих документов';
      AddStringField(SF_NAME, 'Тип документа', 30, [fpSearch, fpSort]);
    end;
    with AddTable do
    begin
      TableName := ST_OFFICES;
      TableLabel := 'Отделы';
      AddStringField(SF_NAME, 'Отдел', 80, [fpSearch, fpSort]);
    end;
    with AddTable do
    begin
      TableName := ST_ORGS;
      TableLabel := 'Организации';
      AddStringField(SF_NAME, 'Организация', 50, [fpSearch, fpSort]);
    end;
    with AddTable do
    begin
      TableName := ST_LETTER_OBJECT_TYPES;
      TableLabel := 'Типы объектов';
      AddStringField(SF_NAME, 'Тип объекта', 20, [fpSearch, fpSort]);
    end;
  end;
end;

procedure TKisLetterMngr.Reopen;
begin
  inherited;
  ReopenCandidates;
end;

procedure TKisLetterMngr.dsLettersIS_OVERDUEGetText(Sender: TField;
  var Text: String; DisplayText: Boolean);
begin
  inherited;
  Text := GetBoolText(dsLettersIS_OVERDUE);
end;

procedure TKisLetterMngr.dsOrdersCalcFields(DataSet: TDataSet);
begin
  inherited;
  if (not dsOrdersPAY_DATE.IsNull) and (dsOrdersVAL_PERIOD.Value > 0) then
    dsOrdersEND_DATE.Value := IncDay(dsOrdersPAY_DATE.Value, dsOrdersVAL_PERIOD.Value)
  else
    dsOrdersEND_DATE.Clear;
end;

procedure TKisLetterMngr.dsLettersAfterScroll(DataSet: TDataSet);
begin
  inherited;
  dsOrders.Active := False;
  if not dsOrders.Prepared then
      dsOrders.Prepare;
  dsOrders.Params[0].AsInteger := dsLettersID.AsInteger;
  dsOrders.Active := True;
end;

procedure TKisLetterMngr.dsLettersEXECUTEDGetText(Sender: TField;
  var Text: String; DisplayText: Boolean);
begin
  inherited;
  Text := GetBoolText(dsLettersEXECUTED);
end;

function TKisLetterMngr.CurrentEntity: TKisEntity;
begin
  if dsLetters.Active then
  begin
    DefaultTransaction := dsLetters.Transaction;
    Result := GetEntity(dsLettersID.AsInteger, keDefault);
    DefaultTransaction := nil;
  end
  else
    Result := nil;
end;

function TKisLetterMngr.CreateDateFilter: IKisFilter;
begin
  Result := TFilterFactory.CreateFilter(SF_DOC_DATE, IncYear(Date, -1), frNone)
end;

function TKisLetterMngr.CreateEntity(EntityKind: TKisEntities): TKisEntity;
begin
  case EntityKind of
  keDefault, keLetter :
    begin
      Result := (IObject(TKisLetterBuilder.Create).AObject as TKisLetterBuilder).CreateLetter(Self);// TKisLetter.Create(Self);
    end;
  keLetterObjAddress :
    begin
      Result := TKisLetterObjAddress.Create(Self);
    end;
  keLetterVisa :
    begin
      Result := TKisLetterVisa.Create(Self);
    end;
  keLetterPassing :
    begin
      Result := TKisLetterPassing.Create(Self);
    end;
  keLetterOfficeDoc :
    begin
      Result := TKisLetterOfficeDoc.Create(Self);
    end;
  keLettersLink :
    begin
      Result := TKisOutcomLetter.Create(Self);
    end;
  else
    Result := nil;
  end;
end;

procedure TKisLetterMngr.Locate(AId: Integer; LocateFail: Boolean = False);
begin
  inherited;
  dsLetters.DisableControls;
  try
    dsLetters.Locate(SF_ID, AId, []);
  finally
    dsLetters.EnableControls;
  end;
end;

procedure TKisLetterMngr.OfficeChange(Sender: TObject);
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
        ApplyFilters(
          CreateList(CreateFilter(FF_OFFICE_PASSING, aId,  frNone)),
          False);
    end;
  end;
end;

procedure TKisLetterMngr.OrdersCellColors(Sender: TObject; Field: TField;
  var Background, FontColor: TColor; State: TGridDrawState;
  var FontStyle: TFontStyles);
var
  DataSet: TDataSet;
begin
  DataSet := Field.DataSet;
  if gdSelected in State then
  begin
    BackGround := clHighlight;
    FontColor := clWhite;
  end
  else
    if not DataSet.FieldByName(SF_ACT_DATE).IsNull then
      Background := Color_Executed // исполнено
    else
      if DataSet.FieldByName(SF_END_DATE).IsNull then
        BackGround := Color_Standard // без контрольной даты
      else
//        if DataSet.FieldByName(SF_END_DATE).AsDateTime < DataSet.FieldByName(SF_ACT_DATE).AsDateTime then
        if DataSet.FieldByName(SF_END_DATE).AsDateTime < SysUtils.Date then
          BackGround := Color_Overdue // просрочено
        else
          BackGround := Color_ControlDate;// с контрольной даты
end;

procedure TKisLetterMngr.acInsertUpdate(Sender: TObject);
begin
//  inherited;
  acInsert.Enabled := AppModule.User.CanDoAction(maInsert, keLetter);
end;

procedure TKisLetterMngr.acDeleteUpdate(Sender: TObject);
begin
//  inherited;
//  if acDelete.Enabled then
    acDelete.Enabled := AppModule.User.CanDoAction(maDelete, keLetter);
end;

procedure TKisLetterMngr.acEditUpdate(Sender: TObject);
begin
//  inherited;
//  if acEdit.Enabled then
    acEdit.Enabled := AppModule.User.CanDoAction(maEdit, keLetter);
end;

procedure TKisLetter.SelectFirm(Sender: TObject);
var
  Id: Integer;
  Firm: TKisFirm;
begin
  if Self.FFirmId > 0 then
    Id := FFirmId
  else
    Id := -1;
  Firm := KisObject(AppModule.SQLMngrs[kmFirms].SelectEntity(False, nil, False, Id)).AEntity as TKisFirm;
  if Assigned(Firm) then
  begin
    FirmId := Firm.ID;
    FirmName := Firm.Name;
  end;
  UpdateFirm;
end;

procedure TKisLetterMngr.DeleteEntity(Entity: TKisEntity);
var
  Conn: IKisConnection;
begin
  Conn := GetConnection(True, True);
  try
    if IsEntityInUse(Entity) then
      inherited
    else
    with Conn.GetDataSet(Format(SQ_DELETE_LETTER, [Entity.ID])) do
      Open;
    FreeConnection(Conn, True);
  except
    FreeConnection(Conn, False);
    raise;
  end;
end;

function TKisLetterMngr.IsEntityInUse(Entity: TKisEntity): Boolean;
var
  Conn: IKisConnection;
begin
  Result := True;
  if not (Entity is TKisLetter) then
    Exit;
  Conn := GetConnection(True, False);
  with Conn.GetDataSet(Format(SQ_CHECK_LETTER_OFFICE_DOCS, [Entity.ID])) do
  try
    Open;
    Result := Fields[0].AsInteger > 0;
    Close;
    if not Result then
    with Conn.GetDataSet(Format(SQ_CHECK_LETTER_CHILDS, [Entity.ID])) do
    begin
      Open;
      Result := Fields[0].AsInteger > 0;
      Close;
    end;
  finally
    FreeConnection(Conn, True);
  end;
end;

procedure TKisLetterMngr.CandidatesGridDblClick(Sender: TObject);
var
  Gc: TGridCoord;
begin
  if Assigned(FView) then
  with FView as TKisLettersView do
  begin
    Gc := dbgCandidates.MouseCoord(FCandidateX, FCandidateY);
    if (Gc.X > N_ZERO) and (Gc.Y > N_ZERO) then
      acEditCandidateExecute(Self);
  end;
end;

procedure TKisLetterMngr.acEditCandidateExecute(Sender: TObject);
var
  NeedBack: Boolean;
  I: Integer;
begin
  inherited;
  Needback := not Assigned(Self.DefaultTransaction);
  if Needback then
  begin
    Self.DefaultTransaction := dsCandidates.Transaction;
  end;
  with KisObject(Self.GetEntity(dsCandidatesPARENT_ID.AsInteger, keLetter)) do
  if Assigned(AEntity) then
  begin
    with AEntity as TKisLetter do
    begin
      if HasChild then
      begin
        // Письмо уже передавалось - показываем предупреждение
        MessageBox(Self.FView.Handle,
          PChar(Format(S_LETTER_PASS_AGAIN, [DocNumber])),
          PChar(S_WARN),
          MB_OK + MB_ICONWARNING);
      end
      else
      begin
        // Письмо еще не передавалось - создаем новую копию письма в БД
        ParentId := AEntity.ID;
        ID := Self.GenEntityID(keLetter);
        OrgsId := AppModule.User.OrgId;
        IsCandidate := True;
        for I := 1 to FAddrCtrlr.GetRecordCount do
          FAddrCtrlr.Elements[I].ID := Self.GenEntityID(keLetterObjAddress);
        for I := 1 to FVisasCtrlr.GetRecordCount do
          FVisasCtrlr.Elements[I].ID := Self.GenEntityID(keLetterVisa);
        // Движения не копируем!
        FParentPassingCtrlr.DirectClear;
        for I := 1 to FPassingCtrlr.GetRecordCount do
          FParentPassingCtrlr.DirectAppend(Self.GetEntity(FPassingCtrlr.Elements[I].ID, keLetterPassing));;
        FPassingCtrlr.DirectClear;
        {// Документы отделов не копируем!!!
        for I := 1 to FOfficeDocCtrlr.GetRecordCount do
          FOfficeDocCtrlr.Elements[I].ID := Self.GenEntityID(keLetterOfficeDoc); }
        if Edit then
        try
          Self.SaveEntity(AEntity);
          dsCandidates.Transaction.CommitRetaining;
          Self.Reopen;
          Self.Locate(AEntity.ID);
          FView.Grid.SetFocus;
        except
          dsCandidates.Transaction.RollbackRetaining;
          if NeedBack then
            Self.DefaultTransaction := nil;
          raise;
        end;
      end;
      if NeedBack then
        Self.DefaultTransaction := nil;
    end;
  end;
end;

procedure TKisLetterMngr.CandidatesGridMouseUp(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  FCandidateX := X;
  FCandidateY := Y;
end;

procedure TKisLetterMngr.CloseView(Sender: TObject; var Action: TCloseAction);
begin
  inherited;

end;

procedure TKisLetterMngr.acEditCandidateUpdate(Sender: TObject);
begin
  inherited;
  with FView as TKisLettersView do
  begin
    acEditCandidate.Enabled := (dbgCandidates.Focused) and dsCandidates.Active
      and not dsCandidates.IsEmpty;
  end;
end;

procedure TKisLetterMngr.dsCandidatesBeforeOpen(DataSet: TDataSet);
begin
  inherited;
  dsCandidates.SelectSQL.Text := Format(SQ_GET_CANDIDATE_LETTERS,
    [AppModule.User.OrgId, AppModule.User.OrgId]);
end;

procedure TKisLetterMngr.acInsertExecute(Sender: TObject);
begin
  Self.DefaultTransaction := dsLetters.Transaction;
  try
    with KisObject(CreateNewEntity(keLetter)) do
    begin
      with AEntity as TKisLetter do
      begin
        DocTypesId := GetFilterDocTypeId;
        OrgsId := AppModule.User.OrgId;
        OfficesId := AppModule.User.OfficeID;
        case AppModule.User.OrgId of
        ID_ORGS_KGA :
          begin
            if DocTypesId > 0 then
              DocNumber := AppModule.User.GenerateNewLetterNumber(DocTypesId);
            DocDate := FormatDateTime(S_DATESTR_FORMAT, SysUtils.Date);
          end;
        ID_ORGS_UGA :
          begin
            if DocTypesId > 0 then
              MPNumber := AppModule.User.GenerateNewLetterNumber(DocTypesId);
            MPDate := FormatDateTime(S_DATESTR_FORMAT, SysUtils.Date);
          end;
        end;
        if Edit then
          SaveEntity(AEntity);
      end;
      Self.DefaultTransaction.CommitRetaining;
      Reopen;
      Locate(AEntity.ID);
    end;
  except
    Self.DefaultTransaction.RollbackRetaining;
    MessageBox(FView.Handle, PChar(S_CANT_SAVE_LETTER), PChar(S_ERROR),
      MB_OK + MB_ICONSTOP);
  end;
  Self.DefaultTransaction := nil;
end;

procedure TKisLetterMngr.acEditExecute(Sender: TObject);
begin
  Self.DefaultTransaction := dsLetters.Transaction;
  try
    EditCurrent;
    ReopenCandidates;
  finally
    Self.DefaultTransaction.RollbackRetaining;
    Self.DefaultTransaction := nil;
  end;
end;

procedure TKisLetterMngr.acDeleteExecute(Sender: TObject);
begin
  Self.DefaultTransaction := dsLetters.Transaction;
  try
    inherited;
    Self.DefaultTransaction.CommitRetaining;
  except
    Self.DefaultTransaction.RollbackRetaining;
    MessageBox(FView.Handle, PChar(S_CANT_DELETE_LETTER), PChar(S_ERROR),
      MB_OK + MB_ICONSTOP);
  end;
  Self.DefaultTransaction := nil;
end;

procedure TKisLetterMngr.EditCurrent;
var
  NeedRemove, NeedCommit: Boolean;
begin
  NeedCommit := False;
  if Assigned(dsLetters.Transaction) then
  begin
    NeedRemove := not Assigned(Self.DefaultTransaction);
    if NeedRemove then
      Self.DefaultTransaction := dsLetters.Transaction;
  end
  else
    raise Exception.CreateFmt(S_DEFAULT_TRANSACTION_MISSED, [Self.ClassName]);
  with KisObject(CurrentEntity) do
    if Assigned(AEntity) then
    with AEntity as TKisLetter do
    begin
      Modified := False;
      if AppModule.User.IsAdministrator then
        ReadOnly := False;
      ///  [!!!] здесь забита привязка писем к отделу
      ///  если человек из другого отдела, то по идее он не может
      ///  редактировать письма другого отдела
      ///  но в отделах стоит вой, поэтому проверка закомментирована
      //else
      //  ReadOnly := ((AppModule.User.OrgId <> OrgsId) or (AppModule.User.OfficeId <> OfficesId));
      if TKisVisualEntity(AEntity).Edit and AEntity.Modified then
      begin
        SaveEntity(AEntity);
        NeedCommit := True;
      end;
    end;
  if Assigned(dsLetters.Transaction) then
  begin
    if NeedCommit then
    begin
      Self.DefaultTransaction.CommitRetaining;
      dsLetters.Refresh;
    end
    else
      Self.DefaultTransaction.RollbackRetaining;
    if NeedRemove then
      Self.DefaultTransaction := nil;
  end;
end;

procedure TKisLetterMngr.acPrintExecute(Sender: TObject);
var
  I, X, Y: Integer;
  Pt: TPoint;
begin
  inherited;
  for I := 0 to Pred(FView.ToolBar.ControlCount) do
  begin
    if FView.ToolBar.Controls[I].Action = acPrint then
      if FView.ToolBar.Controls[I] is TToolButton then
      with FView.ToolBar.Controls[I] as TToolButton do
      begin
        X := Left;
        Y := Succ(Top + Height);
        Pt := Point(X, Y);
        Pt := FView.ToolBar.ClientToScreen(Pt);
      end;
  end;
  pmPrint.Popup(Pt.X, Pt.Y);
end;

procedure TKisLetterMngr.ReadReports;
var
  Item: TMenuItem;
  Conn: IKisConnection;
begin
  Conn := GetConnection(True, False);
  try
    with Conn.GetDataSet(Format(SQ_GET_LETTER_REPORTS, [5])) do
    begin
      Open;
      pmPrint.Items.Clear;
      while not Eof do
      begin
        Item := TMenuItem.Create(Self);
        Item.Caption := Fields[1].AsString;
        Item.Tag := Fields[0].AsInteger;
        Item.OnClick := PrintItemClick;
        pmPrint.Items.Add(Item);
        Next;
      end;
      Close;
    end;
  finally
    FreeConnection(Conn, True);
  end;
end;

procedure TKisLetterMngr.PrintItemClick(Sender: TObject);
begin
  if Sender is TMenuItem then
  with Sender as TMenuItem do
  begin
    PrintReport(Tag);
  end;
end;

procedure TKisLetterMngr.PrintReport(ReportID: Integer);
var
  MasterData: TfrView;
  Dir, RFileName: String;
  I, J: Integer;
  Conn: IKisConnection;
begin
  inherited;
  with PrintModule(True) do
  with frReport do
  begin
    Dir := GetCurrentDir;
    Conn := GetConnection(True, False);
    try
      with Conn.GetDataSet(Format(SQ_SELECT_REPORT_FILENAME, [ReportID])) do
      begin
        Open;
        if not IsEmpty then
          RFileName := AppModule.ReportsPath + Fields[0].AsString
        else
        begin
          MessageBox(FView.Handle, PChar(S_REPORT_NOT_FOUND), PChar(S_WARN), MB_OK + MB_ICONWARNING);
          Exit;
        end;
        Close;
      end;
    finally
      FreeConnection(Conn, True);
    end;
    if not FileExists(RFileName) then
    begin
      MessageBox(FView.Handle, PChar(S_REPORT_NOT_FOUND), PChar(S_WARN), MB_OK + MB_ICONWARNING);
      Exit;
    end;

    LoadFromFile(RFileName);
    SetCurrentDir(Dir);
    //присваиваем источник данных полосы
    if ReportId = 14 then
    begin
      frDataSet.DataSet := dsLetters;
      MasterData := FindObject('MasterData1');
      if (MasterData <> nil) and (MasterData is TfrBandView) then
        TfrBandView(MasterData).DataSet := 'frDataSet';
    end;
    for I := 0 to Pred(Pages.Count) do
      for J := 0 to Pred(Pages[I].Objects.Count) do
        if Assigned(Pages[I].Objects[J])
           and (TObject(Pages[I].Objects[J]) is TfrIBXQuery ) then
           begin
             TfrIBXQuery(Pages[I].Objects[J]).Query.Transaction := dsLetters.Transaction;
             if ReportId <> 14 then
               TfrIBXQuery(Pages[I].Objects[J]).Query.SQL.Text := dsLetters.SelectSQL.Text;
           end;
    //выводим отчет
    ShowReport;
  end;
end;

function TKisLetterMngr.ProcessSQLFilter(aFilter: IKisFilter;
  TheOperation: TKisFilterOperation; Clause: TWhereClause): Boolean;
var
  I: Integer;
  FltrName, DateField: string;
  Condition: TSQLCondition;
begin
  Result := False;
  FltrName := (aFilter as IKisNamedObject).Name;
  if TheOperation = foAddSQL then
  begin
    if (FltrName = SF_ORGS_ID) then
    begin
      if (aFilter.Value > 0) then
      begin
        Condition := TSQLCondition.Create;
        Condition.Text := 'L.ORGS_ID=' + VarToStr(aFilter.Value);
        if Clause.PartCount = 0 then
          Condition.TheOperator := coNone
        else
          Condition.TheOperator := coAnd;
        Condition.Comment := FltrName;
        Clause.AddCondition(Condition);
      end;
      Result := True;
    end
    else
    if (FltrName = SF_DOC_TYPES_ID) then
    begin
      if (aFilter.Value > 0) then
      begin
        Condition := TSQLCondition.Create;
        Condition.Text := 'L.DOC_TYPES_ID=' + VarToStr(aFilter.Value);
        if Clause.PartCount = 0 then
          Condition.TheOperator := coNone
        else
          Condition.TheOperator := coAnd;
        Condition.Comment := FltrName;
        Clause.AddCondition(Condition);
      end;
      Result := True;
    end
    else
    if (FltrName = SF_DOC_DATE) then
    begin
      Condition := TSQLCondition.Create;
      case GetFilterOrgId of
      ID_ORGS_DGA : DateField := 'L.DOC_DATE';
      ID_ORGS_KGA : DateField := 'L.DOC_DATE';
      ID_ORGS_UGA : DateField := 'L.MP_DATE';
      else
                    DateField := 'L.DOC_DATE';
      end;
      Condition.Text := DateField + '>=''' + VarToStr(aFilter.Value) + '''';
      if Clause.PartCount = 0 then
        Condition.TheOperator := coNone
      else
        Condition.TheOperator := coAnd;
      Condition.Comment := FltrName;
      Clause.AddCondition(Condition);
      Result := True;
    end
    else
    if (FltrName = FF_OFFICE_PASSING)  then
    begin
      if (aFilter.Value > 0) then
      begin
        Condition := TSQLCondition.Create;
        I := aFilter.Value;
        Condition.Text := Format(FF_LETTERS_OFFICE_PASSING_FILTER, [I]);
        if Clause.PartCount = 0 then
          Condition.TheOperator := coNone
        else
          Condition.TheOperator := coAnd;
        Condition.Comment := FltrName;
        Clause.AddCondition(Condition);
      end;
      Result := True;
    end
  end;
  if not Result then
    Result := inherited ProcessSQLFilter(aFilter, TheOperation, Clause);
end;

procedure TKisLetterMngr.acPrintUpdate(Sender: TObject);
begin
  inherited;
  acPrint.Enabled := pmPrint.Items.Count > 0;
end;

procedure TKisLetterMngr.acReopenExecute(Sender: TObject);
begin
  dsLetters.Transaction.Commit;
  dsLetters.Transaction.StartTransaction;
  inherited;
end;

procedure TKisLetterMngr.ReadViewState;
var
  I: Integer;
begin
  inherited;
  if Assigned(FView) and not (csdestroying in FView.ComponentState) then
  with FView as TKisLettersView do
  begin
    I := AppModule.ReadAppParam(Self, FView, 'CANDIDTAE_GRID_WIDTH', varInteger);
    if I > 0 then
      dbgCandidates.Width := I
    else
      dbgCandidates.Width := FView.Width div 5;
  end;
end;

procedure TKisLetterMngr.WriteViewState;
begin
  inherited;
  if Assigned(FView) and not (csdestroying in FView.ComponentState) then
  with FView as TKisLettersView do
  begin
    AppModule.SaveAppParam(Self, FView, 'CANDIDATE_GRID_WIDTH', dbgCandidates.Width);
  end;
end;

function TKisLetterMngr.IsLetterStored(const LetterId: Integer): Boolean;
var
  Conn: IKisConnection;
begin
  Conn := GetConnection(True, False);
  try
    with Conn.GetDataSet(Format(SQ_LETTER_IS_STORED, [LetterId])) do
    begin
      Open;
      Result := Fields[0].AsInteger > 0;
      Close;
    end;
  finally
    FreeConnection(Conn, True);
  end;
end;

function TKisLetterMngr.IsLetterHasChild(const Id: Integer): Boolean;
var
  Conn: IKisConnection;
begin
  Conn := GetConnection(True, False);
  try
    with Conn.GetDataSet(Format(SQ_GET_LETTER_CHILD_COUNT, [Id])) do
    begin
      Open;
      Result := Fields[0].AsInteger > 0;
      Close;
    end;
  finally
    FreeConnection(Conn, True);
  end
end;

procedure TKisLetterMngr.SaveOutcomLetter(OutcomLetter: TKisEntity);
var
  Conn: IKisConnection;
  DataSet: TDataSet;
begin
  Conn := GetConnection(True, True);
  try
    DataSet := Conn.GetDataSet(SQ_SAVE_OUTCOM_LETTERS);
    if OutcomLetter.ID < 1 then
      OutcomLetter.ID := Self.GenEntityID(keLettersLink);
    with OutcomLetter as TKisOutcomLetter do
    begin
      // :ID, :INCOMLETTER_ID, :OUTCOMLETTER_ID
      Conn.SetParam(DataSet, SF_ID, ID);
      Conn.SetParam(DataSet, SF_INCOMLETTER_ID, HeadId);
      Conn.SetParam(DataSet, SF_OUTCOMLETTER_ID, OutcomLetterId);
    end;
    DataSet.Open;
    FreeConnection(Conn, True);
  except
    FreeConnection(Conn, False);
    raise;
  end;
end;

function TKisLetterMngr.GetAddressController(
  const EntityId: Integer): TLetterObjAddressController;
begin
  Result := TLetterObjAddressController.CreateController(Self, Self, keLetterObjAddress);
  LoadAddressesToController(EntityId, Result);
end;

procedure TKisLetterMngr.LoadAddressesToLetter(Letter: TKisLetter);
var
  Tmp: TKisEntity;
  Conn: IKisConnection;
begin
  // [!!!] Переписать! Убрать GetEntity! Заменить одним запросом + CreateEntity + Load
  Conn := GetConnection(True, False);
  try
    with Conn.GetDataSet(Format(SQ_GET_LETTER_ADDRESSES_ID, [Letter.Id])) do
    begin
      Open;
      while not Eof do
      begin
        Tmp := Self.GetEntity(FieldByName(SF_ID).AsInteger, keLetterObjAddress);
        if Assigned(Tmp) then
          Letter.FAddrCtrlr.DirectAppend(Tmp);
        Next;
      end;
      Close;
    end;
  finally
    FreeConnection(Conn, True);
  end;
end;

function TKisLetterMngr.GetMainDataSet: TDataSet;
begin
  Result := dsLetters;
end;

function TKisLetterMngr.GetRefreshSQLText: String;
begin
  Result := GetMainSQLtext + ' WHERE LETTERS.ID=:ID';
end;

procedure TKisLetterMngr.LoadAddressesToController(const LetterId: Integer;
  Ctrlr: TLetterObjAddressController);
var
  Tmp: TKisEntity;
  Conn: IKisConnection;
begin
  Conn := GetConnection(True, False);
  try
    with Conn.GetDataSet(Format(SQ_GET_LETTER_ADDRESSES_ID, [LetterId])) do
    begin
      Open;
      while not Eof do
      begin
        Tmp := Self.GetEntity(FieldByName(SF_ID).AsInteger, keLetterObjAddress);
        if Assigned(Tmp) then
          Ctrlr.DirectAppend(Tmp);
        Next;
      end;
      Close;
    end;
  finally
    FreeConnection(Conn, True);
  end;
end;

procedure TKisLetterMngr.ReopenCandidates;
begin
  if CandidatesEnabled then
  begin
    dsCandidates.Close;
    dsCandidates.Open;
  end;
end;

procedure TKisLetterMngr.CancelFilters(aFilters: IKisFilters);
begin
  inherited;
  UpdateViewCaption(GetFilterOrgId, GetFilterDocTypeId);
  ViewUpdateOfficeCombo;
end;

function TKisLetterMngr.CandidatesEnabled: Boolean;
begin
  Result := AppModule.User.IsAdministrator
     or (AppModule.User.OfficeId = ID_OFFICE_CANCELLARY);
end;

procedure TKisLetterMngr.LoadVisasToLetter(Letter: TKisLetter);
var
  Conn: IKisConnection;
  Tmp: TKisEntity;
begin
  // [!!!] Переписать! Убрать GetEntity! Заменить одним запросом + CreateEntity + Load
  if Assigned(Letter) then
  begin
    Conn := GetConnection(True, False);
    try
      with Conn.GetDataSet(Format(SQ_GET_LETTER_VISAS_ID, [Letter.ID])) do
      begin
        Open;
        while not Eof do
        begin
          Tmp := Self.GetEntity(FieldByName(SF_ID).AsInteger, keLetterVisa);
          if Assigned(Tmp) then
            Letter.FVisasCtrlr.DirectAppend(Tmp);
          Next;
        end;
        Close;
      end;
    finally
      FreeConnection(Conn, True);
    end;
  end;
end;

procedure TKisLetterMngr.LoadPassingsToLetter(Letter: TKisLetter);
var
  Tmp: TKisEntity;
  Conn: IKisConnection;
begin
  // [!!!] Переписать! Убрать GetEntity! Заменить одним запросом + CreateEntity + Load
  Conn := GetConnection(True, False);
  try
    with Conn.GetDataSet(Format(SQ_GET_LETTER_PASSINGS_ID, [Letter.Id])) do
    begin
      Open;
      while not Eof do
      begin
        Tmp := GetEntity(FieldByName(SF_ID).AsInteger, keLetterPassing);
        if Assigned(Tmp) then
          Letter.FPassingCtrlr.DirectAppend(Tmp);
        Next;
      end;
      Close;
    end;
  finally
    FreeConnection(Conn, True);
  end;
end;

procedure TKisLetterMngr.LoadParentPassingsToLetter(Letter: TKisLetter;
  const ParentId: Integer);
var
  Tmp: TKisEntity;
  Conn: IKisConnection;
begin
  // [!!!] Переписать! Убрать GetEntity! Заменить одним запросом + CreateEntity + Load
  Conn := GetConnection(True, False);
  try
    with Conn.GetDataSet(Format(SQ_GET_LETTER_PASSINGS_ID, [ParentId])) do
    begin
      Open;
      while not Eof do
      begin
        Tmp := GetEntity(FieldByName(SF_ID).AsInteger, keLetterPassing);
        if Assigned(Tmp) then
          Letter.FParentPassingCtrlr.DirectAppend(Tmp);
        Next;
      end;
      Close;
    end;
  finally
    FreeConnection(Conn, True);
  end;
end;

procedure TKisLetterMngr.LoadOfficeDocsToLetter(Letter: TKisLetter);
var
  Tmp: TKisEntity;
  Conn: IKisConnection;
begin
  // [!!!] Переписать! Убрать GetEntity! Заменить одним запросом + CreateEntity + Load
  Conn := GetConnection(True, False);
  try
    with Conn.GetDataSet(Format(SQ_GET_LETTER_OFFICE_DOCS_ID, [Letter.Id])) do
    begin
      Open;
      while not Eof do
      begin
        Tmp := GetEntity(FieldByName(SF_ID).AsInteger, keLetterOfficeDoc);
        if Assigned(Tmp) then
          Letter.FOfficeDocCtrlr.DirectAppend(Tmp);
        Next;
      end;
      Close;
    end;
  finally
    FreeConnection(Conn, True);
  end;
end;

procedure TKisLetterMngr.LoadOutcomingsToLetter(Letter: TKisLetter);
var
  Tmp: TKisEntity;
  Conn: IKisConnection;
begin
  // [!!!] Переписать! Убрать GetEntity! Заменить одним запросом + CreateEntity + Load
  Conn := GetConnection(True, False);
  try
    with Conn.GetDataSet(Format(SQ_GET_OUTCOM_LETTERS_ID, [Letter.Id])) do
    begin
      Open;
      while not Eof do
      begin
        Tmp := GetEntity(FieldByName(SF_ID).AsInteger, keLettersLink);
        if Assigned(Tmp) then
          Letter.FOutcomLetterCtrlr.DirectAppend(Tmp);
        Next;
      end;
      Close;
    end;
  finally
    FreeConnection(Conn, True);
  end;
end;

function TKisLetterMngr.LetterHasChild(Letter: TKisLetter): Boolean;
var
  Conn: IKisConnection;
begin
  Conn := GetConnection(True, False);
  try
    with Conn.GetDataSet(Format(SQ_GET_LETTER_CANDIDATE_COUNT, [Letter.ID])) do
    begin
      Open;
      Result := Fields[0].AsInteger > 0;
      Close;
    end;
  finally
    FreeConnection(Conn, True);
  end;
end;

function TKisLetterMngr.CreateOfficeDocForLetter(Letter: TKisLetter): TKisEntity;
var
  Conn: IKisConnection;
  OfficeDoc: TKisOfficeDoc;
  OfficeDocMngr: TKisSQLMngr;
begin
  Conn := GetConnection(True, True);
  OfficeDocMngr := AppModule.SQLMngrs[kmOfficeDocs];
  OfficeDocMngr.DefaultTransaction := Conn.Transaction;
  try
    OfficeDoc := OfficeDocMngr.CreateNewEntity(keOfficeDoc) as TKisOfficeDoc;
    if Assigned(OfficeDoc) then
    begin
      OfficeDoc.ObjectAddress := System.Copy(Letter.AddressesAsText, 1, 120);
      OfficeDoc.OfficesId := AppModule.User.OfficeID;
      OfficeDoc.AttachLetter(Letter);
      OfficeDoc.Modified := False;
      if OfficeDoc.Edit then
        OfficeDocMngr.SaveEntity(OfficeDoc)
      else
        FreeAndNil(OfficeDoc);
    end;
    OfficeDocMngr.DefaultTransaction := nil;

    FreeConnection(Conn, True);
    Result := OfficeDoc;
  except
    OfficeDocMngr.DefaultTransaction := nil;
    FreeConnection(Conn, False);
    FreeAndNil(OfficeDoc);
    raise;
  end;
end;

procedure TKisLetterMngr.UpdateViewCaption(const OrgsId, DocTypesId: Integer);
var
  S: String;
  Tmp: TKisOrg;
begin
  if Assigned(FView) then
  begin
    S := '';
    if OrgsId <> 0 then
    begin
      Tmp := AppModule.Mngrs[kmOrgs].GetEntity(OrgsId) as TKisOrg;
      if Assigned(Tmp) then
        S := Tmp.ShortName;
    end;
    if S <> '' then
      S := S + ' - ';
    if DocTypesId > 0 then
      S := S + DocTypeNames[DocTypesId]
    else
      S := S + DocTypeNames[0];
    FView.Caption := S;
  end;
end;

procedure TKisLetterMngr.ViewUpdateOfficeCombo;
begin
  if Assigned(FView) then
    with TKisLettersView(FView) do
    begin
      cbOffice.Items.Assign(IStrings(AppModule.OfficesList(GetFilterOrgId)).Strings);
      if AppModule.User.AllowAllOffices(Self.Ident) then
        cbOffice.Items.InsertObject(0, 'Все отделы', nil);
      ComboLocate(cbOffice, GetFilterOfficeId);
    end;
end;

procedure TKisLetterMngr.PrepareViewLegend;
begin
  FView.Legend.Caption := 'Письма';
  FView.Legend.ItemOffset := 8;
  with FView.Legend.Items.Add do
  begin
    Color := RGB(255, 128, 255);//clWhite;
    Caption := 'С контрольной датой';
  end;
  with FView.Legend.Items.Add do
  begin
    Color := clRed;
    Caption := 'Просрочено';
  end;
  with FView.Legend.Items.Add do
  begin
    Color := clMoneyGreen;
    Caption := 'Исполнено';
  end;
  with FView.Legend.Items.Add do
  begin
    Color := clInfoBk;
    Caption := 'Без контрольной даты';
  end;
end;

procedure TKisLetterMngr.SaveLetterAddresses(Letter: TKisLetter);
var
  Conn: IKisConnection;
  Address: TKisLetterObjAddress;
  DataSet: TDataSet;
begin
  Conn := GetConnection(True,True);
  try
    // удаляем удаленные
    if Letter.FAddrCtrlr.DeletedCount > 0 then
    begin
      Conn.GetDataSet(Letter.FAddrCtrlr.GetDeleteQueryText).Open;
      Letter.FAddrCtrlr.ClearDeleted;
    end;
    // потом сохраняем остальные
    if Letter.FAddrCtrlr.GetRecordCount > 0 then
    begin
      DataSet := Conn.GetDataSet(SQ_SAVE_LETTER_ADDRESS);
      Conn.PrepareDataSet(DataSet);
      Letter.Addresses.First;
      while not Letter.Addresses.Eof do
      begin
        Address := TKisLetterObjAddress(Letter.FAddrCtrlr.Elements[Letter.Addresses.RecNo]);
        if Address.ID < 1 then
        begin
          Address.ID := GenEntityID(keLetterObjAddress);
          Address.Modified := True;
        end;
        if Address.Modified then
        begin
          // (:ID, :LETTERS_ID, :ADDRESS)
          Conn.SetParam(DataSet, SF_ID, Letter.Addresses.FieldByName(SF_ID).Value);
          Conn.SetParam(DataSet, SF_LETTERS_ID, Letter.ID);
          Conn.SetParam(DataSet, SF_ADDRESS, Letter.Addresses.FieldByName(SF_ADDRESS).Value);
          DataSet.Open;
        if DataSet.Active then
          DataSet.Close;
        end;
        Letter.Addresses.Next;
      end;
    end;

    FreeConnection(Conn, True);
  except
    FreeConnection(Conn, False);
    raise;
  end;
end;

procedure TKisLetterMngr.SaveLetterVisas(Letter: TKisLetter);
var
  Conn: IKisConnection;
  Visa: TKisLetterVisa;
  DataSet: TDataSet;
begin
  Conn := GetConnection(True,True);
  try
    // удаляем удаленные
    if Letter.FVisasCtrlr.DeletedCount > 0 then
    begin
      Conn.GetDataSet(Letter.FVisasCtrlr.GetDeleteQueryText).Open;
      Letter.FVisasCtrlr.ClearDeleted;
    end;
    // потом сохраняем остальные
    if Letter.FVisasCtrlr.GetRecordCount > 0 then
    begin
      DataSet := Conn.GetDataSet(SQ_SAVE_LETTER_VISA);
      Conn.PrepareDataSet(DataSet);
      Letter.Visas.First;
      while not Letter.Visas.Eof do
      begin
        Visa := TKisLetterVisa(Letter.FVisasCtrlr.Elements[Letter.Visas.RecNo]);
        if Visa.ID < 1 then
        begin
          Visa.ID := GenEntityID(keLetterVisa);
          Visa.Modified := True;
        end;
        if Visa.Modified then
        begin
          // (:LETTERS_ID,:ID,:DOC_DATE,:CONTROL_DATE,:CONTENT,:SIGNATURE)
          Conn.SetParam(DataSet, SF_LETTERS_ID, Letter.ID);
          Conn.SetParam(DataSet, SF_ID, Visa.ID);
          Conn.SetParam(DataSet, SF_DOC_DATE, Visa.DocDate);
          Conn.SetParam(DataSet, SF_CONTROL_DATE, Visa.ControlDate);
          Conn.SetParam(DataSet, SF_CONTENT, Visa.Content);
          Conn.SetParam(DataSet, SF_SIGNATURE, Visa.Signature);
          DataSet.Open;
        end;
        if DataSet.Active then
          DataSet.Close;
        Letter.Visas.Next;
      end;
      Conn.UnPrepareDataSet(DataSet);
    end;
    FreeConnection(Conn, True);
  except
    FreeConnection(Conn, False);
    raise;
  end;
end;

procedure TKisLetterMngr.SaveLetterPassings(Letter: TKisLetter);
var
  Conn: IKisConnection;
  Passing: TKisLetterPassing;
  DataSet: TDataSet;
begin
  Conn := GetConnection(True,True);
  try
    // удаляем удаленные
    if Letter.FPassingCtrlr.DeletedCount > 0 then
    begin
      Conn.GetDataSet(Letter.FPassingCtrlr.GetDeleteQueryText).Open;
      Letter.FPassingCtrlr.ClearDeleted;
    end;
    // потом сохраняем остальные
    if Letter.FPassingCtrlr.GetRecordCount > 0 then
    begin
      DataSet := Conn.GetDataSet(SQ_SAVE_LETTER_PASSING);
      Conn.PrepareDataSet(DataSet);
      Letter.Passings.First;
      while not Letter.Passings.Eof do
      begin
        Passing := TKisLetterPassing(Letter.FPassingCtrlr.Elements[Letter.Passings.RecNo]);
        if Passing.ID < 1 then
        begin
          Passing.ID := GenEntityID(keLetterPassing);
          Passing.Modified := True;
        end;
        if Passing.Modified then
        begin
          DataSet.Close;
          // (:LETTERS_ID,:ID,:DOC_DATE,:CONTENT,:OFFICES_ID,:PEOPLE_ID,:EXECUTED)
          Conn.SetParam(DataSet, SF_LETTERS_ID, Letter.ID);
          Conn.SetParam(DataSet, SF_ID, Passing.ID);
          Conn.SetParam(DataSet, SF_DOC_DATE, Passing.DocDate);
          Conn.SetParam(DataSet, SF_CONTENT, Passing.Content);
          Conn.SetParam(DataSet, SF_OFFICES_ID, Passing.OfficesId);
          Conn.SetParam(DataSet, SF_PEOPLE_ID, Passing.PeopleId);
          Conn.SetParam(DataSet, SF_EXECUTED, Integer(Passing.Executed));
          DataSet.Open;
        if DataSet.Active then
          DataSet.Close;
        end;
        Letter.Passings.Next;
      end;
    end;
    FreeConnection(Conn, True);
  except
    FreeConnection(Conn, False);
    raise;
  end;
end;

procedure TKisLetterMngr.SaveLetterOfficeDocs(Letter: TKisLetter);
var
  Conn: IKisConnection;
  OfficeDoc: TKisLetterOfficeDoc;
  DataSet: TDataSet;
begin
  Conn := GetConnection(True,True);
  try
    // удаляем удаленные
    if Letter.FOfficeDocCtrlr.DeletedCount > 0 then
    begin
      Conn.GetDataSet(Letter.FOfficeDocCtrlr.GetDeleteQueryText).Open;
      Letter.FOfficeDocCtrlr.ClearDeleted;
    end;
    // потом сохраняем остальные
    if Letter.FOfficeDocCtrlr.GetRecordCount > 0 then
    begin
      DataSet := Conn.GetDataSet(SQ_SAVE_OFFICE_DOC_LETTER);
      Conn.PrepareDataSet(DataSet);
      Letter.OfficesDocs.First;
      while not Letter.OfficesDocs.Eof do
      begin
        OfficeDoc := TKisLetterOfficeDoc(Letter.FOfficeDocCtrlr.Elements[Letter.OfficesDocs.RecNo]);
        if OfficeDoc.ID < 1 then
        begin
          OfficeDoc.ID := GenEntityID(keLetterOfficeDoc);
          OfficeDoc.Modified := True;
        end;
        if OfficeDoc.Modified then
        begin
          // (:OFFICE_DOCS_ID, :ID, :LETTERS_ID)
          Conn.SetParam(DataSet, SF_LETTERS_ID, Letter.ID);
          Conn.SetParam(DataSet, SF_ID, OfficeDoc.ID);
          Conn.SetParam(DataSet, SF_OFFICE_DOCS_ID, OfficeDoc.OfficeDocId);
          DataSet.Open;
        if DataSet.Active then
          DataSet.Close;
        end;
        Letter.OfficesDocs.Next;
      end;
    end;
    FreeConnection(Conn, True);
  except
    FreeConnection(Conn, False);
    raise;
  end;
end;

procedure TKisLetterMngr.SaveLetterOutcomings(Letter: TKisLetter);
var
  Conn: IKisConnection;
  Outcoming: TKisOutcomLetter;
  DataSet: TDataSet;
begin
  Conn := GetConnection(True,True);
  try
    // удаляем удаленные
    if Letter.FOutcomLetterCtrlr.DeletedCount > 0 then
    begin
      Conn.GetDataSet(Letter.FOutcomLetterCtrlr.GetDeleteQueryText).Open;
      Letter.FOutcomLetterCtrlr.ClearDeleted;
    end;
    // потом сохраняем остальные
    if Letter.FOutcomLetterCtrlr.GetRecordCount > 0 then
    begin
      DataSet := Conn.GetDataSet(SQ_SAVE_OUTCOM_LETTERS);
      Conn.PrepareDataSet(DataSet);
      Letter.OutcomLetter.First;
      while not Letter.OutcomLetter.Eof do
      begin
        Outcoming := TKisOutcomLetter(Letter.FOutcomLetterCtrlr.Elements[Letter.OutcomLetter.RecNo]);
        if Outcoming.ID < 1 then
        begin
          Outcoming.ID := GenEntityID(keLetterPassing); // [!!!] Ошибка
          Outcoming.Modified := True;
        end;
        if Outcoming.Modified then
        begin
          // (:ID, :INCOMLETTER_ID, :OUTCOMLETTER_ID)
          Conn.SetParam(DataSet, SF_ID, Outcoming.ID);
          Conn.SetParam(DataSet, SF_INCOMLETTER_ID, Letter.ID);
          Conn.SetParam(DataSet, SF_OUTCOMLETTER_ID, Outcoming.OutcomLetterId);
          DataSet.Open;
        if DataSet.Active then
          DataSet.Close;
        end;
        Letter.OutcomLetter.Next;
      end;
    end;
    FreeConnection(Conn, True);
  except
    FreeConnection(Conn, False);
    raise;
  end;
end;

procedure TKisLetterMngr.SaveLetterCandidate(Letter: TKisLetter);
var
  Conn: IKisConnection;
  Passing: TKisLetterPassing;
  I: Integer;
begin
  Conn := GetConnection(True, True);
  try
    // Удаляем кандидатов, если это дочернее письмо
    // т.к. письмо было принято
    if (Letter.ParentId > BAD_LETTER_PARENT) then
    begin
      Conn.GetDataSet(Format(SQ_DELETE_CANDIDATES, [Letter.ParentId])).Open;
    end
    else
    begin
      // Удаляем кандидатов и записываем их заново, т.к. они могли измениться
      Conn.GetDataSet(Format(SQ_DELETE_CANDIDATES, [Letter.ID])).Open;
      if not Letter.HasChild then
      with Letter.FPassingCtrlr do
        for I := 1 to GetRecordCount do
        begin
          Passing := TKisLetterPassing(Elements[I]);
          if not ((Letter.ParentId = 1) and (StrTodate(Passing.DocDate) <= LAST_OLD_LETTER_DATE)) then
          if (Passing.OrgsId > 0) and (Passing.OrgsId <> Letter.OrgsId) then
          begin
            // Создаем кандидата
            Conn.GetDataSet(
              Format(SQ_INSERT_CANDIDATE_LETTER, [Letter.ID, Passing.OrgsId])
            ).Open;
            Break;
          end;
        end;
    end;
    // Изменяем родительское письмо
    if (Letter.ParentId > BAD_LETTER_PARENT) then
    begin
      // Обновляем статус списания
      Conn.GetDataSet(
        Format(SQ_UPDATE_PARENT_LETTER_PASSINGS, [Integer(Letter.Executed), Letter.ParentId, Letter.OrgsId])
      ).Open;
      // Обновляем номера писем
      if Letter.OrgsId = ID_ORGS_UGA then
        Conn.GetDataSet(
          Format(SQ_UPDATE_PARENT_LETTER,
                 [SF_MP_NUMBER, QuotedStr(Letter.MPNumber), SF_MP_DATE, QuotedStr(Letter.MPDate), Letter.ParentId])
        ).Open
      else
        Conn.GetDataSet(
          Format(SQ_UPDATE_PARENT_LETTER,
            [SF_DOC_NUMBER, QuotedStr(Letter.DocNumber), SF_DOC_DATE, QuotedStr(Letter.DocDate), Letter.ParentId])
        ).Open;
    end;
    FreeConnection(Conn, True);
  except
    FreeConnection(Conn, False);
    raise;
  end;
end;

function TKisLetterMngr.GetLetterHasChild(const LetterId: Integer): Integer;
var
  Conn: IKisConnection;
begin
  Conn := GetConnection(True, False);
  try
    with Conn.GetDataSet('SELECT ID FROM LETTERS WHERE PARENT_ID=' + IntToStr(LetterId)) do
    begin
      Open;
      if IsEmpty then
        Result := 0
      else
        Result := Fields[0].AsInteger;
      Close;
    end;
  finally
    FreeConnection(Conn, True);
  end;
end;

{ TLetterParentPassingCtrlr }

procedure TLetterParentPassingCtrlr.FillFieldDefs(
  FieldDefsRef: TFieldDefs);
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
    Name := SF_LETTERS_ID;
  end;
  with FieldDefsRef.AddFieldDef do
  begin
    DataType := ftString;
    FieldNo := 3;
    Size := 10;
    Name := SF_DOC_DATE;
  end;
  with FieldDefsRef.AddFieldDef do
  begin
    DataType := ftString;
    FieldNo := 4;
    Name := SF_CONTENT;
    Size := 150;
  end;
  with FieldDefsRef.AddFieldDef do
  begin
    DataType := ftInteger;
    FieldNo := 5;
    Name := SF_OFFICES_ID;
  end;
  with FieldDefsRef.AddFieldDef do
  begin
    DataType := ftInteger;
    FieldNo := 6;
    Name := SF_PEOPLE_ID;
  end;
  with FieldDefsRef.AddFieldDef do
  begin
    DataType := ftString;
    FieldNo := 7;
    Name := SF_OFFICES_NAME;
    Size := 25;
  end;
  with FieldDefsRef.AddFieldDef do
  begin
    DataType := ftString;
    FieldNo := 8;
    Name := SF_PEOPLE_FULL_NAME;
    Size := 77;
  end;
  with FieldDefsRef.AddFieldDef do
  begin
    DataType := ftBoolean;
    FieldNo := 9;
    Name := SF_EXECUTED;
  end;
end;

function TLetterParentPassingCtrlr.GetFieldData(Index: Integer;
  Field: TField; out Data): Boolean;
var
  Ent: TKisLetterPassing;
begin
  try
    Ent := TKisLetterPassing(Elements[Index]);
    case Field.FieldNo of
    1 : GetInteger(Ent.ID, Data);
    2 : GetInteger(Ent.HeadId, Data);
    3 : GetString(Ent.DocDate, Data);
    4 : GetString(Ent.Content, Data);
    5 : GetInteger(Ent.OfficesId, Data);
    6 : GetInteger(Ent.PeopleId, Data);
    7 : GetString(Ent.OfficeShortName, Data);
    8 : GetString(Ent.PeopleFullName, Data);
    9 : GetBoolean(Ent.Executed, Data);
    else
      raise EDatabaseError.CreateFmt(S_FIELD_NOT_FOUND, [Field.FieldName]);
    end;
    Result := True;
  except
    Result := False;
  end;
end;

procedure TLetterParentPassingCtrlr.SetFieldData(Index: Integer;
  Field: TField; var Data);
var
  Ent: TKisLetterPassing;
begin
  try
    Ent := TKisLetterPassing(Elements[Index]);
    case Field.FieldNo of
    1 : Ent.ID := SetInteger(Data);
    2 : ;//Ent.HeadId := SetInteger(Data);
    3 : Ent.DocDate := SetString(Data);
    4 : Ent.Content := SetString(Data);
    5 : Ent.OfficesId := SetInteger(Data);
    6 : Ent.PeopleId := SetInteger(Data);
    7 : ;//Ent.OfficesShortName := SetInteger(Data);
    9 : Ent.Executed := SetBoolean(Data);
    end;
  except
  end;
end;

{ TkisOutcomLetter }

procedure TkisOutcomLetter.Copy(Source: TKisEntity);
begin
  inherited;
  with Source as TKisOutcomLetter do
  begin
    Self.OutcomLetterId := FOutcomLetterId;
    Self.SeqNumber := FSeqNumber;
    Self.Number := FNumber;
    Self.DateReg := FDateReg;
    Self.FirmId := FFirmId;
    Self.Firm := Firm;
  end;
end;

class function TKisOutcomLetter.EntityName: String;
begin
  Result := '';
end;

procedure TkisOutcomLetter.Load(DataSet: TDataSet);
begin
  inherited;
  with DataSet do
  begin
    ID := FieldByName(SF_ID).AsInteger;
    OutcomLetterId := FieldByName(SF_OUTCOMLETTER_ID).AsInteger;
    SeqNumber := FieldByName(SF_SEQ_NUMBER).AsString;
    Number := FieldByName(SF_NUMBER).AsString;
    DateReg := FieldByName(SF_DATE_REG).AsString;
    FirmId := FieldByName(SF_FIRMS_ID).AsInteger;
    Firm := FieldByName(SF_FIRM).AsString;
    Self.Modified := True;
  end;
end;

procedure TkisOutcomLetter.SetDateReg(const Value: String);
begin
  if FDateReg <> Value then
  begin
    FDateReg := Value;
    Modified := True;
  end;
end;

procedure TkisOutcomLetter.SetFirm(const Value: String);
begin
  if FFirm <> Value then
  begin
    FFirm := Value;
    Modified := True;
  end;
end;

procedure TkisOutcomLetter.SetFirmId(const Value: Integer);
begin
  if FFirmId <> Value then
  begin
    FFirmId := Value;
    Modified := True;
  end;
end;

procedure TkisOutcomLetter.SetNumber(const Value: String);
begin
  if FNumber <> Value then
  begin
    FNumber := Value;
    Modified := True;
  end;
end;

procedure TkisOutcomLetter.SetOutcomLetterId(const Value: Integer);
begin
  if FOutcomLetterId <> Value then
  begin
    FOutcomLetterId := Value;
    Modified := True;
  end;
end;

procedure TkisOutcomLetter.SetSeqNumber(const Value: String);
begin
  if FSeqNumber <> Value then
  begin
    FSeqNumber := Value;
    Modified := True;
  end;
end;

{ TOutcomLetterController }

procedure TOutcomLetterController.FillFieldDefs(FieldDefsRef: TFieldDefs);
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
    Name := SF_OUTCOMLETTER_ID;
  end;
  with FieldDefsRef.AddFieldDef do
  begin
    DataType := ftInteger;
    FieldNo := 3;
    Name := SF_INCOMLETTER_ID;
  end;
  with FieldDefsRef.AddFieldDef do
  begin
    DataType := ftString;
    FieldNo := 4;
    Size := 4;
    Name := SF_SEQ_NUMBER;
  end;
  with FieldDefsRef.AddFieldDef do
  begin
    DataType := ftString;
    FieldNo := 5;
    Size := 10;
    Name := SF_NUMBER;
  end;
  with FieldDefsRef.AddFieldDef do
  begin
    DataType := ftString;
    FieldNo := 6;
    Size := 10;
    Name := SF_DATE_REG;
  end;
  with FieldDefsRef.AddFieldDef do
  begin
    DataType := ftInteger;
    FieldNo := 7;
    Name := SF_FIRMS_ID;
  end;
  with FieldDefsRef.AddFieldDef do
  begin
    DataType := ftString;
    FieldNo := 8;
    Size := 120;
    Name := SF_FIRM;
  end;
end;


function TOutcomLetterController.GetFieldData(Index: Integer;
  Field: TField; out Data): Boolean;
var
  Ent: TKisOutcomLetter;
begin
  try
    Ent := TKisOutcomLetter(Elements[Index]);
    case Field.FieldNo of
    1 : GetInteger(Ent.ID, Data);
    2 : GetInteger(Ent.OutcomLetterId, Data);
    3 : GetInteger(Ent.HeadId, Data);
    4 : GetString(Ent.SeqNumber, Data);
    5 : GetString(Ent.Number, Data);
    6 : GetString(Ent.DateReg, Data);
    7 : GetInteger(Ent.FirmId, Data);
    8 : GetString(Ent.Firm, Data);
    else
      raise EDatabaseError.CreateFmt(S_FIELD_NOT_FOUND, [Field.FieldName]);
    end;
    Result := True;
  except
    Result := False;
  end;
end;

procedure TOutcomLetterController.SetFieldData(Index: integer;
  Field: TField; var Data);
var
  Ent: TKisOutcomLetter;
begin
  try
    Ent := TKisOutcomLetter(Elements[Index]);
    case Field.FieldNo of
    1 : Ent.ID := SetInteger(Data);
    2 : Ent.OutcomLetterId := SetInteger(Data);
    //3 : Ent.OutcomLetterId := SetInteger(Data);
    4 : Ent.SeqNumber:= SetString(Data);
    5 : Ent.Number := SetString(Data);
    6 : Ent.DateReg := SetString(Data);
    7 : Ent.FirmId := SetInteger(Data);
    8 : Ent.Firm := SetString(Data);
    end;
  except
  end;
end;

{ TKisLetterBuilder }

procedure TKisLetterBuilder.CreateAddresses(Letter: TKisLetter);
begin
  Letter.FAddrCtrlr := TLetterObjAddressController.CreateController(Letter.Manager, Letter.Manager, keLetterObjAddress);
  Letter.FAddrCtrlr.HeadEntity := Letter;
  Letter.FAddresses := TCustomDataSet.Create(Letter.Manager);
  Letter.FAddresses.Controller := Letter.FAddrCtrlr;
  Letter.FAddresses.Open;
  Letter.FAddresses.First;
end;

function TKisLetterBuilder.CreateLetter(Mngr: TKisLetterMngr): TKisLetter;
begin
  Result := TKisLetter.Create(Mngr);
  CreateAddresses(Result);
  CreateVisas(Result);
  CreateOfficeDocs(Result);
  CreateOutcomings(Result);
  CreatePassings(Result);
  CreateParentPassings(Result);
end;

procedure TKisLetterBuilder.CreateOfficeDocs(Letter: TKisLetter);
begin
  Letter.FOfficeDocCtrlr := TLetterOfficeDocController.CreateController(Letter.Manager, Letter.Manager, keLetterOfficeDoc);
  Letter.FOfficeDocCtrlr.HeadEntity := Letter;
  Letter.FOfficesDocs := TCustomDataSet.Create(Letter.Manager);
  Letter.FOfficesDocs.Controller := Letter.FOfficeDocCtrlr;
  Letter.FOfficesDocs.Open;
  Letter.FOfficesDocs.First;
end;

procedure TKisLetterBuilder.CreateOutcomings(Letter: TKisLetter);
begin
  Letter.FOutcomLetterCtrlr := TOutcomLetterController.CreateController(Letter.Manager, Letter.Manager, keLettersLink);
  Letter.FOutcomLetterCtrlr.HeadEntity := Letter;
  Letter.FOutcomLetter := TCustomDataSet.Create(Letter.Manager);
  Letter.FOutcomLetter.Controller := Letter.FOutcomLetterCtrlr;
  Letter.FOutcomLetter.Open;
  Letter.FOutcomLetter.First;
end;

procedure TKisLetterBuilder.CreateParentPassings(Letter: TKisLetter);
begin
  Letter.FParentPassingCtrlr := TLetterParentPassingCtrlr.CreateController(Letter.Manager, Letter.Manager, keLetterPassing);
  Letter.FParentPassingCtrlr.HeadEntity := Letter;
  Letter.FParentPassings := TCustomDataSet.Create(Letter.Manager);
  Letter.FParentPassings.Controller := Letter.FParentPassingCtrlr;
  Letter.FParentPassings.Open;
  Letter.FParentPassings.First;
end;

procedure TKisLetterBuilder.CreatePassings(Letter: TKisLetter);
begin
  Letter.FPassingCtrlr := TLetterPassingCtrlr.CreateController(Letter.Manager, Letter.Manager, keLetterPassing);
  Letter.FPassingCtrlr.HeadEntity := Letter;
  Letter.FPassings := TCustomDataSet.Create(Letter.Manager);
  Letter.FPassings.Controller := Letter.FPassingCtrlr;
  Letter.FPassings.Open;
  Letter.FPassings.First;
end;

procedure TKisLetterBuilder.CreateVisas(Letter: TKisLetter);
begin
  Letter.FVisasCtrlr := TLetterVisaCtrlr.CreateController(Letter.Manager, Letter.Manager, keLetterVisa);
  Letter.FVisasCtrlr.HeadEntity := Letter;
  Letter.FVisas := TCustomDataSet.Create(Letter.Manager);
  Letter.FVisas.Controller := Letter.FVisasCtrlr;
  Letter.FVisas.Open;
  Letter.FVisas.First;
end;

{ TKisLetterSaver }

function TKisLetterSaver.GetSQL: String;
begin
  Result := SQ_SAVE_LETTER;
end;

procedure TKisLetterSaver.InternalSave;
begin
  inherited InternalSave;
  SaveContent(TKisLetter(FEntity));
end;

procedure TKisLetterSaver.SaveContent(aLetter: TKisLetter);
var
  DataSet: TDataSet;
begin
  DataSet := FConnection.GetDataSet(Format(SQ_SAVE_LETTER_CONTENT, [aLetter.ID]));
  FConnection.SetParam(DataSet, SF_CONTENT, aLetter.Content);
  DataSet.Open;
end;

procedure TKisLetterSaver.PrepareParams(DataSet: TDataSet);
var
  V: Variant;
begin
  inherited;
  with TKisLetter(FEntity) do
  begin
    FConnection.SetParam(DataSet, SF_ID, ID);
    FConnection.SetParam(DataSet, SF_DOC_TYPES_ID, DocTypesId);
    FConnection.SetParam(DataSet, SF_ORGS_ID, OrgsId);
    FConnection.SetParam(DataSet, SF_OFFICES_ID, OfficesId);
    FConnection.SetParam(DataSet, SF_OBJECT_TYPE_ID, ObjectTypeId);
    FConnection.SetParam(DataSet, SF_DOC_NUMBER, DocNumber);
    FConnection.SetParam(DataSet, SF_DOC_DATE, DocDate);
    FConnection.SetParam(DataSet, SF_ORG_NUMBER, OrgNumber);
    FConnection.SetParam(DataSet, SF_ORG_DATE, OrgDate);
    FConnection.SetParam(DataSet, SF_ADM_NUMBER, AdmNumber);
    FConnection.SetParam(DataSet, SF_ADM_DATE, AdmDate);
    FConnection.SetParam(DataSet, SF_MP_NUMBER, MPNumber);
    FConnection.SetParam(DataSet, SF_MP_DATE, MPDate);
    if FirmId > 0 then
      V := FirmId
    else
      V := NULL;
    FConnection.SetParam(DataSet, SF_FIRMS_ID, V);
    FConnection.SetParam(DataSet, SF_FIRM_NAME, FirmName);
    FConnection.SetParam(DataSet, SF_EXECUTED, Integer(Executed));
    FConnection.SetParam(DataSet, SF_EXECUTE_INFO, ExecuteInfo);
    FConnection.SetParam(DataSet, SF_CONTROL_DATE, ControlDate);
//    FConnection.SetParam(DataSet, SF_EXECUTED_2, Integer(Executed2));
//    FConnection.SetParam(DataSet, SF_CONTROL_DATE_2, ControlDate2);
    if ParentId > 0 then
      V := ParentId
    else
      V := NULL;
    FConnection.SetParam(DataSet, SF_PARENT_ID, V);
  end;
end;

end.


