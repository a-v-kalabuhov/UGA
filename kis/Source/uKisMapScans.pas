{*******************************************************
{
{       "ИС МКП УГА"
{       Менеджер по учету выдачи сканов планшетов
{       
{
{
{       Copyright (c) 2015, МКП УГА
{
{       Автор: Калабухов А.В.
{
{*******************************************************

{ Описание: реализует операции над сканированными планшетами
  Имя модуля: uKisMapScans
  Версия: 0.1
  Дата последнего изменения: 21.02.2015
  Цель: модуль содержит реализации классов менеджера планшетов
  Исключения: нет }

unit uKisMapScans;

interface

uses
  // system
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms, ExtCtrls, Contnrs, Grids, DBGrids,
  ComObj, StrUtils, DB, IBCustomDataSet, ImgList, ActnList, Dialogs, IBSQL, IBDatabase, IBQuery,
  // Common
  uGC, uIBXUtils, uDataSet, uVCLUtils, uDBGrid, uGeoUtils, uFileUtils,
  // Project
  uKisClasses, uKisSQLClasses, uKisEntityEditor, uKisUtils, uKisFileReport, uKisMapScanGeometry,
  uKisGivenScanEditor, uKisMapHistoryClasses, uKisScanOrders, uKisTakeBackFiles, uMapScanFiles, uKisGivenScanEditor2;

type
  TKisMapScansMngr = class;

  TKisMapScanHistoryElement = class(TKisMapHistoryElement)
  private
    FScanId: Integer;
    FFileOpId: string;
    procedure SetScanId(const Value: Integer);
    procedure SetFileOpId(const Value: string);
  protected
    function CreateFigureInstance: TKisMapHistoryFigure; override;
  public
    class function EntityName: String; override;
    procedure Copy(Source: TKisEntity); override;
    procedure Load(DataSet: TDataSet); override;
    //
    property ScanId: Integer read FScanId write SetScanId;
    property FileOpId: string read FFileOpId write SetFileOpId;
  end;

  TKisMapScanHistoryFigure = class(TKisMapHistoryFigure)
  public
    class function EntityName: String; override;
    function Clone: TKisMapHistoryFigure; override;
  end;

  /// <summary>
  ///   Запись о выдаче скана планшета заказчику.
  /// </summary>
  TKisMapScanGiveOut = class(TKisSQLEntity)
  private
    FGivenObject: Boolean;
    FDateOfGive: String;
    FTermOfGive: Integer;
    FHolder: Boolean;
    FPeopleId: Integer;
    FLicensedOrgId: Integer;
    FHolderName: String;
    FDateOfBack: String;
    FDefinitionNumber: String;
    FOrderNumber: String;
    FOrdersId: Integer;
    FAddress: String;
    FPersonWhoGive: String;
    FPersonWhoGiveId: Integer;
    FOfficeId: Integer;
    FPeopleName: String;
    FInBack: Boolean;
    FInGive: Boolean;
    FMD5Old, FMD5New: string;
    FScanOrderMapId: Integer;
    FPersonWhoTakedBackId: Integer;
    FPersonWhoTakedBack: String;
    FFileId: string;
    FPeopleBackName: String;
    FPeopleBackId: Integer;
    FAllowCloseOrder: Boolean;
    FCloseAfterGive: Boolean;
    FAnnulled: Boolean;
    FSquares: string;
    procedure SetDateOfGive(const Value: String);
    procedure SetTermOfGive(const Value: Integer);
    procedure SetHolder(const Value: Boolean);
    procedure SetPeopleId(const Value: Integer);
    procedure SetLicensedOrgId(const Value: Integer);
    procedure SetHolderName(const Value: String);
    procedure SetDateOfBack(const Value: String);
    procedure SetDefinitionNumber(const Value: String);
    procedure SetOrderNumber(const Value: String);
    procedure SetOrdersId(const Value: Integer);
    procedure SetAddress(const Value: String);
    procedure SetPersonWhoGive(const Value: String);
    procedure SetPersonWhoGiveId(const Value: Integer);
    procedure SetPeopleName(const Value: String);
    procedure SetOfficeId(const Value: Integer);
    procedure SetMD5New(const Value: String);
    procedure SetMD5Old(const Value: String);
    procedure SetScanOrderMapId(const Value: Integer);
    procedure SetPersonWhoTakedBackId(const Value: Integer);
    procedure SetPersonWhoTakedBack(const Value: String);
    procedure SetFileId(const Value: string);
    procedure SetPeopleBackName(const Value: String);
    procedure SetPeopleBackId(const Value: Integer);
    procedure SetAnnulled(const Value: Boolean);
    function GetExpired: Boolean;
    procedure SetSquares(const Value: string);
  strict private
    function GetMyEditor: TKisGivenScanEditor;
{$REGION 'Методы для формы-редактора'}
    procedure LoadPeopleList(Sender: TObject);
    procedure LoadOrgs(Sender: TObject);
    procedure LoadOfficesAndPeople(Sender: TObject);
    procedure SelectOrg(Sender: TObject);
{$ENDREGION}
  strict private 
    procedure PrepareEditorForGive(AEditor: TKisGivenScanEditor);
    procedure PrepareEditorForBack(AEditor: TKisGivenScanEditor);
  protected
    function CreateEditor: TKisEntityEditor; override;
    procedure PrepareEditor(AEditor: TKisEntityEditor); override;
    procedure LoadDataIntoEditor(AEditor: TKisEntityEditor); override;
    procedure ReadDataFromEditor(AEditor: TKisEntityEditor); override;
    function CheckEditor(AEditor: TKisEntityEditor): Boolean; override;
  public
    constructor Create(aMngr: TKisMngr); override;
    //
    class function EntityName: String; override;
    procedure Copy(Source: TKisEntity); override;
    procedure Load(DataSet: TDataSet); override;
    //
    /// <summary>
    ///   Ссылка на скан планшета.
    /// </summary>
    property DateOfGive: String read FDateOfGive write SetDateOfGive;
    property TermOfGive: Integer read FTermOfGive write SetTermOfGive;
    property Holder: Boolean read FHolder write SetHolder;
    property PeopleId: Integer read FPeopleId write SetPeopleId;
    property LicensedOrgId: Integer read FLicensedOrgId write SetLicensedOrgId;
    property HolderName: String read FHolderName write SetHolderName;
    property DateOfBack: String read FDateOfBack write SetDateOfBack;
    property DefinitionNumber: String read FDefinitionNumber write SetDefinitionNumber;
    property OrderNumber: String read FOrderNumber write SetOrderNumber;
    property OrdersId: Integer read FOrdersId write SetOrdersId;
    property Address: String read FAddress write SetAddress;
    property PersonWhoGive: String read FPersonWhoGive write SetPersonWhoGive;
    property PersonWhoGiveId: Integer read FPersonWhoGiveId write SetPersonWhoGiveId;
    property PersonWhoTakedBackId: Integer read FPersonWhoTakedBackId write SetPersonWhoTakedBackId;
    property PersonWhoTakedBack: String read FPersonWhoTakedBack write SetPersonWhoTakedBack;
    property OfficeId: Integer read FOfficeId write SetOfficeId;
    property PeopleName: String read FPeopleName write SetPeopleName;
    property Squares: string read FSquares write SetSquares;
    /// <summary>
    ///   Имя человека, который вернул планшеты.
    /// </summary>
    property PeopleBackId: Integer read FPeopleBackId write SetPeopleBackId;
    property PeopleBackName: String read FPeopleBackName write SetPeopleBackName;
    property MD5Old: String read FMD5Old write SetMD5Old;
    property MD5New: String read FMD5New write SetMD5New;
    property ScanOrderMapId: Integer read FScanOrderMapId write SetScanOrderMapId;
    property FileOperationId: string read FFileId write SetFileId;
    property Annulled: Boolean read FAnnulled write SetAnnulled;
    property Expired: Boolean read GetExpired;
    //
    property AllowCloseOrder: Boolean read FAllowCloseOrder write FAllowCloseOrder;
    //
    property InBack: Boolean read FInBack write FInBack;
    property InGive: Boolean read FInGive write FInGive;
    property CloseAfterGive: Boolean read FCloseAfterGive write FCloseAfterGive;
    //
    property MyEditor: TKisGivenScanEditor read GetMyEditor;
    //
    function HasChangesInMap(): Boolean;
  end;

  TScanGiveOutsCtrlr = class(TKisEntityController)
  private
    function GetScans(const Index: Integer): TKisMapScanGiveOut;
  public
    procedure FillFieldDefs(FieldDefsRef: TFieldDefs); override;
    function GetFieldData(Index: Integer; Field: TField; out Data): Boolean; override;
    procedure SetFieldData(Index: Integer; Field: TField; var Data); override;
    function GetDeleteQueryText: String; override;
    function GetLastHolderName: String;
    property Rows[const Index: Integer]: TKisMapScanGiveOut read GetScans; default;
  end;

  TMapScanHistoryCtrlr = class(TKisEntityController)
  public
    function GetDeleteQueryText: String; override;
    procedure FillFieldDefs(FieldDefsRef: TFieldDefs); override;
    function GetFieldData(Index: Integer; Field: TField; out Data): Boolean; override;
    procedure SetFieldData(Index: Integer; Field: TField; var Data); override;
  end;

  TGiveOutPredicate = function (Gout: TKisMapScanGiveOut): Boolean;

  /// <summary>
  ///   Скан планшета М500.
  /// </summary>
  TKisMapScan = class(TKisSQLEntity)
  private
    FGiveOutsCtrlr: TScanGiveOutsCtrlr;
    FGiveOuts: TCustomDataSet;
    FMapHistoryCtrlr: TMapScanHistoryCtrlr;
    FMapHistory: TCustomDataSet;
    FNomenclature: String;
    FSecret: Integer;
    FStartDate: String;
    FIsNew: Boolean;
    FFormularPicture: TPicture;
    FHistoryFile: string;
    FNewFormularImage: Boolean;
    FUseGiveOutForMapHistory: Boolean;
    procedure SetNomenclature(const Value: String);
    procedure SetStartDate(const Value: String);
    procedure SetHistoryPicture(const Value: TPicture);
    procedure SetHistoryFile(const Value: string);

    function GetGiveOuts: TDataSet;
    function DataSetEquals(DS1, DS2: TCustomDataSet): Boolean;

    procedure CopyMain(Source: TKisMapScan);
    procedure CopyGiveOuts(Source: TKisMapScan);
    procedure CopyMapHistory(Source: TKisMapScan);

    procedure EditMapHistory(Sender: TObject);
    procedure PrintHistory(Sender: TObject);
    procedure MapHistoryAfterDelete(DataSet: TDataSet);
    procedure MapHistoryAfterPost(DataSet: TDataSet);
    procedure MapHistoryBeforeDelete(DataSet: TDataSet);
    procedure MapHistoryInsert(DataSet: TDataSet);
    procedure MapHistoryAfterScroll(DataSet: TDataSet);
    procedure PaintHistory(Sender: TObject);

    function CanGiveOut: Boolean;
    function IsNomenclatureUnique(const Value: String): Boolean;
    function GetMyManager: TKisMapScansMngr;
    function GetActualOrLastGiveOut: TKisMapScanGiveOut;
    function GetActualMD5: string;
    function GetMapHistory: TDataSet;
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
    //
    procedure Copy(Source: TKisEntity); override;
    function Equals(Entity: TKisEntity): Boolean; override;
    class function EntityName: String; override;
    function IsEmpty: Boolean; override;
    procedure Load(DataSet: TDataSet); override;
    //
    function FindGiveOut(const TheScanOrderMapId: Integer; const Last: Boolean): TKisMapScanGiveOut; overload;
    function FindGiveOut(const Predicate: TGiveOutPredicate; const Backward: Boolean): TKisMapScanGiveOut; overload;
    /// <summary>
    ///   Выдать планшет на руки
    /// </summary>
    function GiveOut(const MD5Hash: String): Boolean;
    function GiveOutSilent(Template: TKisMapScanGiveOut): TKisMapScanGiveOut;
    /// <summary>
    /// Добавить запись в формуляр. Вызывается если добавили файл с зоной изменений.
    /// </summary>
    procedure AddHistoryFromGiveOut(aGiveOut: TKisMapScanGiveOut);
    /// <summary>
    /// Заполняет поля данными о принёме планшета от заказчика. Показывает окно.
    /// </summary>
    function TakeBack(MapGive: TKisMapScanGiveOut; const NewMD5Value: String): Boolean;
    procedure TakeBackSilent(MapGive: TKisMapScanGiveOut; Template: TKisMapScanGiveOut);
    //
    property Nomenclature: String read FNomenclature write SetNomenclature;
    property Secret: Integer read FSecret;///  write SetSecret
    property StartDate: String read FStartDate write SetStartDate;
    property GiveOuts: TDataSet read GetGiveOuts;
    function GetGiveOut(const Recno: Integer): TKisMapScanGiveOut;
    /// <summary>
    ///   Формуляр планшета с графическим отображением области изменения.
    /// </summary>
    property MapHistory: TDataSet read GetMapHistory;
    function GetHistoryElement(const Recno: Integer): TKisMapScanHistoryElement;
    //
    /// <summary>
    /// Короткое (без пути) имя файла формуляра.
    /// </summary>
    /// <remarks>
    /// Нужно собственно только расширение, т.к. файл может быть любого формата.
    /// </remarks>
    property HistoryFile: string read FHistoryFile write SetHistoryFile;
    property HistoryPicture: TPicture read FFormularPicture write SetHistoryPicture;
    property NewFormularImage: Boolean read FNewFormularImage;
    //
    property UseGiveOutForMapHistory: Boolean read FUseGiveOutForMapHistory write FUseGiveOutForMapHistory;
    //
    property MyManager: TKisMapScansMngr read GetMyManager;
  end;

  TKisMapScanState = class(TKisEntity)
  private
    FGivedOut: Boolean;
    FExpired: Boolean;
  public
    class function EntityName: String; override;
    procedure Assign(Source: TPersistent); override;
    procedure Load(DataSet: TDataSet); override;
    //
    property GivedOut: Boolean read FGivedOut;
    property Expired: Boolean read FExpired;
  end;

  TAfterDownloadFile = procedure (Order: TObject; Nomenclature: string) of object;

  TKisMapScansMngr = class(TKisSQLMngr)
    dsMapScans: TIBDataSet;
    dsMapScansID: TIntegerField;
    dsMapScansNOMENCLATURE: TStringField;
    dsMapScansSTART_DATE: TDateField;
    dsMapScansHOLDER_NAME: TStringField;
    dsMapScansDATE_OF_GIVE: TDateField;
    dsMapScansEXPIRED: TSmallintField;
    dsMapScansGIVE_STATUS: TSmallintField;
    dsMapScansIS_SECRET: TSmallintField;
    dsMapScansANNULLED: TSmallintField;
    acLegend: TAction;
    acPrint: TAction;
    OpenDialog1: TOpenDialog;
    SaveDialog1: TSaveDialog;
    dsrcScanOrders: TDataSource;
    dsScanOrders: TIBDataSet;
    dsScanOrdersID: TIntegerField;
    dsScanOrdersORDER_DATE: TDateField;
    dsScanOrdersORDER_NUMBER: TIBStringField;
    dsScanOrdersADDRESS: TIBStringField;
    dsScanOrdersWORK_TYPE: TIBStringField;
    dsScanOrdersCUSTOMER: TIBStringField;
    acConfirmOrder: TAction;
    dsrcOrdersTakeBack: TDataSource;
    dsOrdersTakeBack: TIBDataSet;
    dsOrdersTakeBackID: TIntegerField;
    dsOrdersTakeBackORDER_DATE: TDateField;
    dsOrdersTakeBackORDER_NUMBER: TIBStringField;
    dsOrdersTakeBackADDRESS: TIBStringField;
    dsOrdersTakeBackWORK_TYPE: TIBStringField;
    dsOrdersTakeBackCUSTOMER: TIBStringField;
    acTakeBackOrder: TAction;
    acRefreshOrders: TAction;
    acRefreshTakeBack: TAction;
    acGiveOutForView: TAction;
    acGiveOutAgain: TAction;
    acSortGiveOuts: TAction;
    acSortTakeBacks: TAction;
    acAnnullOrder: TAction;
    acTakeBackAsNoChanges: TAction;
    acOrderView: TAction;
    acOrderView2: TAction;
    acGoToOrder: TAction;
    procedure acLegendExecute(Sender: TObject);
    procedure acPrintExecute(Sender: TObject);
    procedure acInsertExecute(Sender: TObject);
    procedure DataModuleCreate(Sender: TObject);
    procedure DataModuleDestroy(Sender: TObject);
    procedure dsScanOrdersBeforeOpen(DataSet: TDataSet);
    procedure acConfirmOrderExecute(Sender: TObject);
    procedure acConfirmOrderUpdate(Sender: TObject);
    procedure acRefreshOrdersExecute(Sender: TObject);
    procedure dsOrdersTakeBackBeforeOpen(DataSet: TDataSet);
    procedure acRefreshTakeBackExecute(Sender: TObject);
    procedure acTakeBackOrderExecute(Sender: TObject);
    procedure acDeleteUpdate(Sender: TObject);
    procedure acTakeBackOrderUpdate(Sender: TObject);
    procedure acGiveOutForViewExecute(Sender: TObject);
    procedure acGiveOutAgainExecute(Sender: TObject);
    procedure acSortGiveOutsExecute(Sender: TObject);
    procedure acSortTakeBacksExecute(Sender: TObject);
    procedure acAnnullOrderExecute(Sender: TObject);
    procedure acTakeBackAsNoChangesExecute(Sender: TObject);
    procedure acOrderViewExecute(Sender: TObject);
    procedure acOrderView2Execute(Sender: TObject);
    procedure acGoToOrderExecute(Sender: TObject);
  private
    procedure SaveMapScan(MapScan: TKisMapScan);
    procedure SaveGiveOut(GiveOut: TKisMapScanGiveOut);
    procedure SaveHistory(aHistory: TKisMapScanHistoryElement);
    procedure SaveFigure(Conn: IKisConnection; aFigure: TKisMapHistoryFigure);
    procedure SetOrderId(Ent: TKisMapScanGiveOut);
    function FindOfficeId(GivenScan: TKisMapScanGiveOut; out OffId: Integer): Boolean;
    procedure GridCellColors(Sender: TObject; Field: TField; var Background, FontColor: TColor;
      State: TGridDrawState; var FontStyle:TFontStyles);
    procedure GridLogicalColumn(Sender: TObject; Column: TColumn; var IsLogical: Boolean);
    procedure GridGetLogicalValue(Sender: TObject; Column: TColumn; var Value: Boolean);
    /// <summary>
    /// По номенклатуре сканов в Maps возвращает список Id и список отсутствующих.
    /// </summary>
    procedure CheckMaps(aConnection: IKisConnection; Maps: TDataSet;
      Missed: TStringList; ConsiderGivedOut, ConsiderOrder: Boolean; OrderId: Integer = 0);
    function GetScanByNomenclature(aConnection: IKisConnection; aNomenclature: string): TKisMapScan;
    function GetScanIdByNomenclature(aConnection: IKisConnection; aNomenclature: string): Integer;
  private
    FReport: TFileReport;
    procedure AddReportLine(const aStatus: Boolean; const aFileName, aText, aDebugInfo: String);
    /// <summary>
    /// Возвращает экземпляр TKisMapScan, если скан с номенклатурой
    /// aNomenclature есть в БД. Иначе возвращает nil.
    /// </summary>
    function FindScan(aConnection: IKisConnection; const aNomenclature: String): TKisMapScan;
    /// <summary>
    ///   Принять несколько файлов сразу.
    /// </summary>
    procedure TakeBackList(var Scans: TMapScanArray; anOrder: TKisEntity);
    /// <summary>
    /// Сохраняем отчёт о загрузке файлов в базу.
    /// </summary>
    procedure LogTakeBackReport(anOrder: TKisScanOrder; var Scans: TMapScanArray);
    procedure ScanOrdersGridDblClick(Sender: TObject);
    procedure OrderTakeBackGridDblClick(Sender: TObject);
    /// <summary>
    /// Показываем визуальный редактор геометрии выдачи сканов.
    /// В редакторе заполняется нужная геометрия.
    /// </summary>
    function DefineGiveOutGeometry(aOrder: TKisScanOrder; out aGeometry: TKisMapScanGeometry): Boolean;
    procedure ProcessOrderWithMissedScans(var Order: TKisScanOrder; MissedScans: TStringList);
    function GetNewGiveOutTemplate(Order: TKisScanOrder; Term: Integer): TKisMapScanGiveOut;
    function GiveOutOrderFiles(Order: TKisScanOrder; Template: TKisMapScanGiveOut; Scans: TList; CopyAllFiles: Boolean): Boolean;
    /// <summary>
    /// Показываем редактор геометрии, по выбранной пользователем геометрии создаём картинки,
    /// далее показываем диалог выбора папки и копируем картинки в эту папку.
    /// </summary>
    function DownloadOrderFiles(Order: TKisScanOrder; Maps: TStrings; AfterDownload: TAfterDownloadFile): Boolean;
    procedure AfterDownloadGiveOutFile(Order: TObject; Nomenclature: string);
    procedure AfterDownloadFileForView(Order: TObject; Nomenclature: string);
    //
    procedure PrintAct(
      const ReportFile: String;
      anOrder: TKisScanOrder;
      Template: TKisMapScanGiveOut;
      KGOWorkerId, CustomerWorkedId: Integer;
      OrgPeopleName: String);
  strict private
    FScansPrintTable: TStringList;
    FGiveOutTemplate: TKisMapScanGiveOut;
    procedure PrintCheckEof(Sender: TObject; var Eof: Boolean);
    procedure GetPrintValue(const ParName: string; var ParValue: Variant);
  strict private
    procedure UploadHistoryFile(aScan: TKisMapScan);
    //
    procedure LoadFigures(Conn: IKisConnection; aHistory: TKisMapScanHistoryElement);
    procedure LoadFigurePoints(Conn: IKisConnection; aFigure: TKisMapScanHistoryFigure);
  private
    FGiveOutsHelper, FTakeBacksHelper: TKisSQLHelper;
    procedure PrepareAdditionalHelpers;
    procedure RefreshDataSet(Ds: TDataSet);
  protected
    procedure Activate; override;
    procedure CreateView; override;
    procedure Deactivate; override;
    procedure DoUserSearch(const Str: String; Field: TField); override;
    function GenEntityID(EntityKind: TKisEntities = keDefault): Integer; override;
    function GetIdent: TKisMngrs; override;
    function GetRefreshSQLText: String; override;
    function GetMainDataSet: TDataSet; override;
    function GetMainSQLText: String; override;
    procedure Locate(AId: Integer; LocateFail: Boolean = False); override;
    function IsSupported(Entity: TKisEntity): Boolean; override;
    procedure PrepareSQLHelper; override;
    procedure Reopen; override;
    procedure ReadOrderState(Helper: TKisSQLHelper; ParamName: string); override;
    procedure WriteOrderState(Helper: TKisSQLHelper; ParamName: string); override;
  public
    constructor Create(AOnwer: TComponent); override;
    destructor Destroy; override;
    function CreateEntity(EntityKind: TKisEntities): TKisEntity; override;
    function CreateNewEntity(EntityKind: TKisEntities = keDefault): TKisEntity; override;
    function CurrentEntity: TKisEntity; override;
    procedure DeleteEntity(Entity: TKisEntity); override;
    function GetEntity(EntityID: Integer; EntityKind: TKisEntities = keDefault): TKisEntity; override;
    function IsEntityInUse(Entity: TKisEntity): Boolean; override;
    procedure SaveEntity(Entity: TKisEntity); override;
    //
//    function FindMapScanByMapId(): TKisMapScan;
  end;

const
  S_FILEOP_NO_CHANGES = 'файл без изменений';
  S_FILEOP_NO_RETURN = 'выдан без возврата';

resourcestring
  SQ_FIND_SCAN_BY_NOMENCLATURE =
    'SELECT '
  + ' MS.ID, '
  + ' MS.GIVE_STATUS AS STATUS,'
  + ' SOM.SCAN_ORDERS_ID, SO.ANNULLED '
  + 'FROM MAP_SCANS MS'
  + '  LEFT JOIN MAP_SCANS_GIVEOUTS MSG ON (MS.ACTIVE_GIVE_ID = MSG.ID)'
  + '  LEFT JOIN SCAN_ORDER_MAPS SOM ON (MSG.SCAN_ORDER_MAPS_ID = SOM.ID)'
  + '  LEFT JOIN SCAN_ORDERS SO ON (SOM.SCAN_ORDERS_ID=SO.ID)'
  + 'WHERE UPPER(MS.NOMENCLATURE)=UPPER(:NOMENCLATURE)';
  SQ_FIND_SCAN_BY_NOMENCLATURE_2 =
    'SELECT ID FROM MAP_SCANS WHERE UPPER(NOMENCLATURE)=UPPER(:NOMENCLATURE)';

implementation

{$R *.dfm}

uses
  Types, FileCtrl,
  // FastReport
  fr_class, fr_dset,
  // Common
  uSQLParsers, uCommonUtils, uLegend, MD5, uImageCompare,
  uGraphics,
  // Project
  uKisAppModule, uKisConsts, uKisMapScanEditor, uKisIntf, uKisPeople,
  uKisLicensedOrgs, uKisPrintModule, uKisSearchClasses,
  uKisExceptions, uKisFileReportForm, uKisMapScansView,
  uMStFTPConnection, uKisMissingScansDlg,
  uKisOffices, uKisMapScanViewGiveOuts, uKisImageViewer,
  uKisMapScanLoadForm2;

resourcestring
  // Generators
  SG_MAP_SCANS = 'MAP_SCANS';
  SG_MAP_SCANS_GIVEOUTS = 'MAP_SCANS_GIVEOUTS';
  SG_MAP_SCANS_HISTORY = 'MAP_SCANS_HISTORY';
  SG_MAP_SCANS_FIGURE = 'MAP_SCANS_FIGURE';
  SG_SCANS_TAKEBACK_REPORT = 'MAP_SCAN_REPORTS';

  // Queries
  SQ_MAIN =
    'SELECT M.ID, M.NOMENCLATURE, M.START_DATE, M.HOLDER_NAME, M.DATE_OF_GIVE,'
  + '  M.EXPIRED, M.GIVE_STATUS, M.IS_SECRET, MSG.ANNULLED '
  + 'FROM '
  + '  MAP_SCANS M LEFT JOIN'
  + '  MAP_SCANS_GIVEOUTS MSG ON (M.ACTIVE_GIVE_ID = MSG.ID)';
//  + '  LEFT JOIN'
//  + '  SCAN_ORDER_MAPS SOM ON (MSG.SCAN_ORDER_MAPS_ID = SOM.ID) LEFT JOIN'
//  + '  SCAN_ORDERS SO ON (SOM.SCAN_ORDERS_ID = SO.ID)';

  SQ_SELECT_MAP_SCAN =
    'SELECT M.ID, M.NOMENCLATURE, M.START_DATE, M.HOLDER_NAME, M.DATE_OF_GIVE,'
  + '  M.EXPIRED, M.GIVE_STATUS, M.IS_SECRET, M.HISTORY_FILE '
  + 'FROM MAP_SCANS M WHERE M.ID=%d' ;
  SQ_SELECT_MAP_SCAN_GIVEOUT =
    'SELECT MSG.ID, MSG.MAP_SCANS_ID, MSG.DATE_OF_BACK, MSG.DATE_OF_GIVE,'
  + '  MSG.DEFINITION_NUMBER, MSG.GIVEN_OBJECT, MSG.HOLDER, MSG.HOLDER_NAME,'
  + '  MSG.ORDER_NUMBER, MSG.ORDERS_ID, MSG.LICENSED_ORGS_ID, MSG.PEOPLE_ID,'
  + '  MSG.PERSON_WHO_GIVE_ID, MSG.TERM_OF_GIVE, MSG.ADDRESS, MSG.OFFICES_ID,'
  + '  MSG.SCAN_ORDER_MAPS_ID, MSG.PERSON_WHO_TAKED_BACK_ID, '
  + '  MSG.PEOPLE_NAME, P1.INITIAL_NAME AS PERSON_WHO_GIVE,'
//  + '  P.INITIAL_NAME AS PEOPLE_NAME, P1.INITIAL_NAME AS PERSON_WHO_GIVE,'
  + '  P2.INITIAL_NAME AS PERSON_WHO_TAKED_BACK,'
  + '  MSG.MD5_OLD, MSG.MD5_NEW, MSG.FILE_OPERATION_ID, MSG.PEOPLE_BACK_ID,'
  + '  MSG.PEOPLE_BACK_NAME, MSG.PEOPLE_BACK_ID, MSG.ANNULLED '
  + 'FROM MAP_SCANS_GIVEOUTS MSG '
//  + '  LEFT JOIN PEOPLE P ON MSG.PEOPLE_ID=P.ID '
  + '  LEFT JOIN PEOPLE P1 ON MSG.PERSON_WHO_GIVE_ID = P1.ID '
  + '  LEFT JOIN PEOPLE P2 ON MSG.PERSON_WHO_TAKED_BACK_ID = P2.ID '
  + 'WHERE (MSG.ID=%d)';
  SQ_GET_MAP_SCAN_GIVEOUTS_ID_LIST =
    'SELECT ID FROM MAP_SCANS_GIVEOUTS WHERE MAP_SCANS_ID=%d ORDER BY ID';
  SQ_GET_MAP_SCAN_HISTORY_ID_LIST =
    'SELECT ID FROM MAP_SCAN_HISTORY WHERE MAP_SCANS_ID=%d ORDER BY ID';
  SQ_DELETE_MAP_SCAN =
    'DELETE FROM MAP_SCANS WHERE ID=%d';
  SQ_DELETE_MAP_SCAN_GIVE =
    'DELETE FROM MAP_SCANS_GIVEOUTS WHERE ID=%d';
  SQ_DELETE_MAP_SCAN_GIVE_2 =
    'DELETE FROM MAP_SCANS_GIVEOUTS WHERE ID IN (%s)';
  SQ_DELETE_MAP_SCAN_HISTORY =
    'DELETE FROM MAP_SCAN_HISTORY WHERE ID=%d';
  SQ_SAVE_MAP_SCAN =
    'EXECUTE PROCEDURE SAVE_MAP_SCAN(:ID, :NOMENCLATURE, :START_DATE, :IS_SECRET, :HISTORY_FILE)';
  SQ_SAVE_MAP_SCAN_GIVEOUT =
    'EXECUTE PROCEDURE SAVE_MAP_SCAN_GIVEOUT'
  + '(:ID, :MAP_SCANS_ID, :DATE_OF_BACK, :DATE_OF_GIVE, :DEFINITION_NUMBER,'
  + ' :GIVEN_OBJECT, :HOLDER, :HOLDER_NAME, :ORDER_NUMBER, :ORDERS_ID, '
  + ' :LICENSED_ORGS_ID, :PEOPLE_ID, :PERSON_WHO_GIVE_ID, :TERM_OF_GIVE,'
  + ' :ADDRESS, :OFFICES_ID, :MD5_OLD, :MD5_NEW, :PERSON_WHO_TAKED_BACK_ID,'
  + ' :FILE_OPERATION_ID, :PEOPLE_NAME, :PEOPLE_BACK_NAME, :PEOPLE_BACK_ID)';
  SQ_CLEAR_MAP_SCAN_GIVE =
    'DELETE FROM MAP_SCANS_GIVEOUTS WHERE MAP_SCANS_ID=%d';
  SQ_FIND_ORDER =
    'SELECT ID FROM ORDERS_ALL WHERE OFFICES_ID=%d AND ORDER_NUMBER=''%s''';
  SQ_FIND_OFFICE_ID =
    'SELECT OFFICES_ID FROM PEOPLE WHERE ID=%d';
  SQ_FIND_SCAN_BY_MD5 =
    'SELECT ID, NOMENCLATURE FROM MAP_SCANS WHERE ACTUAL_MD5=''%s''';
  SQ_GET_ACTIVE_SCAN_ORDERS =
    'SELECT '
  + '  SO.ID, SO.ORDER_DATE, SO.ORDER_NUMBER, SO.ADDRESS, SO.WORK_TYPE, '
  + '  SO. CUSTOMER '
  + 'FROM '
  + '  SCAN_ORDERS_ALL_VIEW_2 SO '
  + 'WHERE '
  + '  (SO.GIVEDOUT = 0) AND (SO.RETURNED = 0) and (SO.ANNULLED = 0)';
  SQ_GET_GIVEN_SCAN_ORDERS =
    'SELECT '
  + '  SO.ID, SO.ORDER_DATE, SO.ORDER_NUMBER, SO.ADDRESS, SO.WORK_TYPE, '
  + '  SO.CUSTOMER '
  + 'FROM '
  + '  SCAN_ORDERS_ALL_VIEW_2 SO '
  + 'WHERE '
  + '  (SO.GIVEDOUT = 1) AND (SO.RETURNED = 0) and (SO.ANNULLED = 0)';
  SQ_UPDATE_MAP_SCAN_GIVEOUT_SCAN_ORDER_ID =
    'UPDATE MAP_SCANS_GIVEOUTS '
  + 'SET SCAN_ORDER_MAPS_ID=:SCAN_ORDER_MAPS_ID '
  + 'WHERE ID=:ID';
  SQ_SELECT_MAP_SCAN_HISTORY =
    'SELECT * '
  + 'FROM MAP_SCAN_HISTORY '
  + 'WHERE ID=%d';
  SQ_SELECT_MAP_SCAN_FIGURE =
    'SELECT * '
  + 'FROM MAP_SCAN_FIGURES '
  + 'WHERE ID=%d ORDER BY ID';
  SQ_SAVE_MAP_SCAN_HISTORY =
    'EXECUTE PROCEDURE SAVE_MAP_SCAN_HISTORY'
  + '  (:ID, :MAP_SCANS_ID, :CHIEF, :CURRENT_CHANGES_MAPPING, :DATE_OF_ACCEPT, '
  + '   :DATE_OF_WORKS, :DRAFT_WORKS_EXECUTOR, :ENGIN_NET_MAPPING, '
  + '   :HIGH_RISE_MAPPING, :HORIZONTAL_MAPPING, :MENS_MAPPING, '
  + '   :NEWLY_BUILDING_MAPPING, :ORDER_NUMBER, :TACHEOMETRIC_MAPPING,'
  + '   :TOTAL_SUM, :WORKS_EXECUTOR, :FILE_OPERATION_ID)';
  SQ_DELETE_MAP_SCAN_FIGURE =
    'DELETE FROM MAP_SCAN_FIGURES WHERE ID=:ID';
  SQ_INSERT_MAP_SCAN_FIGURE =
    'INSERT INTO MAP_SCAN_FIGURES '
  + ' (ID, HISTORY_ELEMENT_ID, FIGURE_TYPE, FIGURE_COLOR, EXTENT_LEFT,'
  + '  EXTENT_RIGHT, EXTENT_TOP, EXTENT_BOTTOM) '
  + 'VALUES '
  + ' (:ID, :HISTORY_ELEMENT_ID, :FIGURE_TYPE, :FIGURE_COLOR, :EXTENT_LEFT,'
  + '  :EXTENT_RIGHT, :EXTENT_TOP, :EXTENT_BOTTOM)';
  SQ_INSERT_MAP_SCAN_FIGURE_POINT =
    'INSERT INTO MAP_SCAN_FIGURE_POINTS (ID, FIGURE_ID, X, Y) '
  + 'VALUES (:ID, :FIGURE_ID, :X, :Y)';
  SQ_GET_MAP_SCAN_FIGURE_POINTS =
    'SELECT * FROM MAP_SCAN_FIGURE_POINTS WHERE FIGURE_ID=%d';
  SQ_GET_MAP_SCAN_FIGURES =
    'SELECT * FROM MAP_SCAN_FIGURES WHERE HISTORY_ELEMENT_ID=%d';
  SQ_DELETE_MAP_SCAN_HISTORY_2 =
    'DELETE FROM MAP_SCAN_HISTORY WHERE ID IN (%s)';
  SQ_SELECT_MAP_SCAN_STATE =
    'SELECT GIVE_STATUS, EXPIRED FROM MAP_SCANS WHERE ID=%d';

  SQ_SAVE_FILE_REPORT =
    'INSERT INTO MAP_SCAN_REPORTS '
  + '   (SCAN_ORDERS_ID, ORDER_NUMBER, ORDER_DATE, NOMENCLATURE, NEW_FILE_NAME,'
  + '    DB_FILE_NAME, ZONE_FILE_NAME, DB_HASH, NEW_HASH, ZONE_HASH, FILE_OP_ID,'
  + '    STATUS, LOG_TEXT) '
  + 'VALUES '
  + '   (:SCAN_ORDERS_ID, :ORDER_NUMBER, :ORDER_DATE, :NOMENCLATURE, :NEW_FILE_NAME,'
  + '    :DB_FILE_NAME, :ZONE_FILE_NAME, :DB_HASH, :NEW_HASH, :ZONE_HASH, :FILE_OP_ID,'
  + '    :STATUS, :LOG_TEXT)';

const
  I_GIVEOUT_TERM = 3; // срок выдачи по умолчанию

{ TKisMapScan }

function TKisMapScan.CreateEditor: TKisEntityEditor;
begin
  Result := TKisMapScanEditor.Create(Application);
end;

procedure TKisMapScan.Copy(Source: TKisEntity);
var
  MapScan: TKisMapScan;
begin
  inherited;
  MapScan := Source as TKisMapScan;
  CopyMain(MapScan);
  CopyGiveOuts(MapScan);
  CopyMapHistory(MapScan);
end;

function TKisMapScan.IsEmpty: Boolean;
begin
  Result :=
    (FNomenclature = '')
    and (FStartDate = '')
    and (FHistoryFile = '')
    and GiveOuts.IsEmpty;
end;

function TKisMapScan.Equals(Entity: TKisEntity): Boolean;
begin
  inherited Equals(Entity);
  with Entity as TKisMapScan do
  begin
    Result := 
      (Self.FNomenclature = FNomenclature)
      and (Self.FStartDate = FStartDate)
      and (Self.FHistoryFile = FHistoryFile);
//      and (Self.FDateOfScan = FDateOfScan)
//      and (Self.FDateOfGive = FDateOfGive);
    if Result then
      Result := Result and DataSetEquals(Self.FGiveOuts, FGiveOuts);
  end;
end;

function TKisMapScan.FindGiveOut(const Predicate: TGiveOutPredicate; const Backward: Boolean): TKisMapScanGiveOut;
var
  I, A1, A2, D: Integer;
  Gout: TKisMapScanGiveOut;
begin
  Result := nil;
  if Backward then
  begin
    A1 := FGiveOuts.RecordCount;
    A2 := 1;
    D := -1;
  end
  else
  begin
    A2 := FGiveOuts.RecordCount;
    A1 := 1;
    D := 1;
  end;
  I := A1;
  while I <> A2 + D do
  begin
    Gout := FGiveOutsCtrlr.Rows[I];
    if Predicate(Gout) then
    begin
      Result := Gout;
      Exit;
    end;
    I := I + D;
  end;
end;

function TKisMapScan.FindGiveOut(const TheScanOrderMapId: Integer;
  const Last: Boolean): TKisMapScanGiveOut;
var
  I: Integer;
begin
  Result := nil;
  if Last then
  begin
    for I := FGiveOuts.RecordCount downto 0 do
      if FGiveOutsCtrlr[I].ScanOrderMapId = TheScanOrderMapId then
      begin
        Result := FGiveOutsCtrlr[I];
        Break;
      end;
  end
  else
  begin
    for I := 1 to FGiveOuts.RecordCount do
      if FGiveOutsCtrlr[I].ScanOrderMapId = TheScanOrderMapId then
      begin
        Result := FGiveOutsCtrlr[I];
        Break;
      end;
  end;
end;

procedure TKisMapScan.Load(DataSet: TDataSet);
begin
  inherited;
  with DataSet do
  begin
    Self.ID := FieldByName(SF_ID).AsInteger;
    Self.FNomenclature := FieldByName(SF_NOMENCLATURE).AsString;
    Self.FStartDate := FieldByName(SF_START_DATE).AsString;
    Self.FHistoryFile := FieldByName(SF_HISTORY_FILE).AsString;
//    Self.FDateOfScan := FieldByName(SF_DATE_OF_SCAN).AsDateTime;
//    Self.FDateOfGive := FieldByName(SF_DATE_OF_GIVE).AsDateTime;
  end;
  //грузим список выдачи планшетов
  MyManager.LoadController(SQ_GET_MAP_SCAN_GIVEOUTS_ID_LIST, ID, keMapScanGiveOut, FGiveOutsCtrlr);
  FGiveOuts.Close;
  FGiveOuts.Open;
  MyManager.LoadController(SQ_GET_MAP_SCAN_HISTORY_ID_LIST, ID, keMapScanHistoryElement, FMapHistoryCtrlr);
  FMapHistory.Close;
  FMapHistory.Open;
end;

procedure TKisMapScan.SetStartDate(const Value: String);
begin
  if FStartDate <> Value then
  begin
    FStartDate := Value;
    Modified := True;
  end;
end;

procedure TKisMapScan.SetHistoryFile(const Value: string);
begin
  if FHistoryFile <> Value then
  begin
    FHistoryFile := Value;
    Modified := True;
  end;
end;

procedure TKisMapScan.SetHistoryPicture(const Value: TPicture);
begin
  FFormularPicture.Assign(Value);
  FNewFormularImage := True;
end;

procedure TKisMapScan.SetNomenclature(const Value: String);
begin
  if FNomenclature <> Value then
  begin
    FNomenclature := Value;
    Modified := True;
  end;
end;

function TKisMapScan.DataSetEquals(DS1, DS2: TCustomDataSet): Boolean;
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

function TKisMapScan.GetActualMD5: string;
var
  TheGiveOut: TKisMapScanGiveOut;
begin
  TheGiveOut := GetActualOrLastGiveOut;
  if Assigned(TheGiveOut) then
  begin
    if TheGiveOut.MD5New = '' then
      Result := TheGiveOut.MD5Old
    else
      Result := TheGiveOut.MD5New;
  end
  else
    Result := '';
end;

function TKisMapScan.GetActualOrLastGiveOut: TKisMapScanGiveOut;
var
  I, GvRecNo: Integer;
  MaxDate, TheDate: TDateTime;
begin
  I := FGiveOuts.RecNo;
  MaxDate := 0;
  GvRecNo := -1;
  FGiveOuts.First;
  while not FGiveOuts.Eof do
  begin
    if not FGiveOuts.FieldByName(SF_DATE_OF_BACK).IsNull then
    if FGiveOuts.FieldByName(SF_ANNULLED).AsInteger = 0 then
    begin
      TheDate := FGiveOuts.FieldByName(SF_DATE_OF_BACK).AsDateTime;
      if (MaxDate = 0) or (MaxDate < TheDate) then
      begin
        MaxDate := TheDate;
        GvRecNo := FGiveOuts.RecNo;
      end;
    end;
    FGiveOuts.Next;
  end;
  //
  if GvRecNo < 0 then
  begin
    FGiveOuts.First;
    while not FGiveOuts.Eof do
    begin
      if not FGiveOuts.FieldByName(SF_DATE_OF_GIVE).IsNull then
      if FGiveOuts.FieldByName(SF_ANNULLED).AsInteger = 0 then
      begin
        TheDate := FGiveOuts.FieldByName(SF_DATE_OF_GIVE).AsDateTime;
        if (MaxDate = 0) or (MaxDate < TheDate) then
        begin
          MaxDate := TheDate;
          GvRecNo := FGiveOuts.RecNo;
        end;
      end;
      FGiveOuts.Next;
    end;
  end;
  //
  if GvRecNo > 0 then
    Result := FGiveOutsCtrlr[GvRecNo]
  else
    Result := nil;
  //
  FGiveOuts.RecNo := I;
end;

function TKisMapScan.GetGiveOut(const Recno: Integer): TKisMapScanGiveOut;
begin
  Result := FGiveOutsCtrlr[Recno] as TKisMapScanGiveOut;
end;

function TKisMapScan.GetGiveOuts: TDataSet;
begin
  Result := FGiveOuts;
end;

function TKisMapScan.GetHistoryElement(const Recno: Integer): TKisMapScanHistoryElement;
begin
  Result := TKisMapScanHistoryElement(FMapHistoryCtrlr.Elements[RecNo]);
end;

function TKisMapScan.GetMapHistory: TDataSet;
begin
  Result := FMapHistory;
end;

function TKisMapScan.GetMyManager: TKisMapScansMngr;
begin
  Result := TKisMapScansMngr(Manager);
end;

constructor TKisMapScan.Create(Mngr: TKisMngr);
begin
  inherited;
  FGiveOutsCtrlr := TScanGiveOutsCtrlr.CreateController(Mngr, Mngr, keMapScanGiveOut);
  FGiveOutsCtrlr.HeadEntity := Self;
  FGiveOuts := TCustomDataSet.Create(Mngr);
  FGiveOuts.Controller := FGiveOutsCtrlr;
  FGiveOuts.Open;
  FGiveOuts.First;
  //
  FMapHistoryCtrlr := TMapScanHistoryCtrlr.CreateController(Mngr, Mngr, keMapScanHistoryElement);
  FMapHistoryCtrlr.HeadEntity := Self;
  FMapHistory := TCustomDataSet.Create(Mngr);
  FMapHistory.Controller := FMapHistoryCtrlr;
  FMapHistory.Open;
  FMapHistory.First;
  //
  FFormularPicture := TPicture.Create;
end;

destructor TKisMapScan.Destroy;
begin
  FreeAndNil(FFormularPicture);
  //
  FMapHistory.Close;
  FMapHistory.Free;
  FMapHistoryCtrlr.Free;
  //
  FGiveOuts.Close;
  FGiveOuts.Free;
  FGiveOutsCtrlr.Free;
  inherited;
end;

procedure TKisMapScan.EditMapHistory(Sender: TObject);
begin
  // Здесь показываем редактор истории планшета
  if not MapHistory.IsEmpty then
    if TKisVisualEntity(FMapHistoryCtrlr.Elements[MapHistory.RecNo]).Edit then
      Modified := True;
end;

class function TKisMapScan.EntityName: String;
begin
  Result := SEN_MAP_SCAN;
end;

procedure TKisMapScan.CopyMain(Source: TKisMapScan);
begin
  Self.FNomenclature := FNomenclature;
  Self.FStartDate := FStartDate;
  Self.FHistoryFile := FHistoryFile;
  Self.FFormularPicture.Assign(FFormularPicture);
  Self.FNewFormularImage := FNewFormularImage;
//  Self.FDateOfScan := FDateOfScan;
//  Self.FDateOfGive := FDateOfGive;
end;

procedure TKisMapScan.CopyMapHistory(Source: TKisMapScan);
var
  I: Integer;
  Elmnt: TKisEntity;
begin
  FMapHistoryCtrlr.DirectClear;
  for I := 0 to Source.FMapHistoryCtrlr.Count - 1 do
  begin
    Elmnt := MyManager.CreateEntity(keMapScanHistoryElement);
    Elmnt.Copy(Source.FMapHistoryCtrlr.Elements[I]);
    FMapHistoryCtrlr.DirectAppend(Elmnt);
  end;
//  CopyDataSet(Source.MapHistory, Self.MapHistory);
end;

procedure TKisMapScan.CopyGiveOuts(Source: TKisMapScan);
begin
  FGiveOutsCtrlr.DirectClear;
  CopyDataSet(Source.GiveOuts, Self.GiveOuts);
end;

function TKisMapScan.CheckEditor(Editor: TKisEntityEditor): Boolean;
var
  N: TNomenclature;
begin
  Result := False;
  if Editor is TKisMapScanEditor then
    with Editor as TKisMapScanEditor do
    begin
      N.Init(edNomenclature.Text + '-' + edNom2.Text + '-' + edNom3.Text, True);
      if not N.Valid then
      begin
        MessageBox(Handle, PChar(S_CHECK_NOMENCLATURE), PChar(S_WARN), MB_OK + MB_ICONWARNING);
        edNomenclature.SetFocus;
        Exit;
      end;
      if FIsNew then
      if not IsNomenclatureUnique(N.Nomenclature()) then
      begin
        MessageBox(Handle, PChar(S_CHECK_NOMENCLATURE_IS_UNIQUE), PChar(S_WARN), MB_OK + MB_ICONWARNING);
        edNomenclature.SetFocus;
        Exit;
      end;
  end;
  Result := True;
end;

procedure TKisMapScan.LoadDataIntoEditor(Editor: TKisEntityEditor);
var
  NomParts: TStringList;
  S: String;
  N: TNomenclature;
begin
  with Editor as TKisMapScanEditor do
  begin
    if Nomenclature = '' then
    begin
      edNomenclature.Clear;
      edNom2.Clear;
      edNom3.Clear;
      edStartDate.Text := DateToStr(Date);
    end
    else
    begin
      N.Init(Nomenclature, False);
      if not N.Valid then
        S := Nomenclature
      else
        S := N.Nomenclature();
      NomParts := TStringList.Create;
      NomParts.Forget();
      TGeoUtils.GetNomenclatureParts(S, NomParts);
      if NomParts.Count > 0 then
        edNomenclature.Text := NomParts[0]
      else
        edNomenclature.Text := '';
      if NomParts.Count > 1 then
        edNom2.Text := NomParts[1]
      else
        edNom2.Text := '';
      if NomParts.Count > 2 then
        edNom3.Text := NomParts[2]
      else
        edNom3.Text := '';
      edStartDate.Text := FStartDate;
    end;
    //
    edMD5.Text := GetActualMD5;
    //
    if HistoryFile <> '' then
    begin
      HistoryImageFile := theMapScansStorage.GetFileName(AppModule, Nomenclature, sfnFormular, ExtractFileExt(HistoryFile));// + Self.HistoryFile;
    end;
  end;
end;

procedure TKisMapScan.MapHistoryAfterDelete(DataSet: TDataSet);
begin
  Modified := True;
end;

procedure TKisMapScan.MapHistoryAfterPost(DataSet: TDataSet);
begin
  MapHistoryAfterScroll(DataSet);
end;

procedure TKisMapScan.MapHistoryAfterScroll(DataSet: TDataSet);
var
  History: TKisMapScanHistoryElement;
  Bmp: TBitmap;
  ImageFile: string;
  B: Boolean;
begin
  if Assigned(EntityEditor) then
  if MapHistory.IsEmpty then
    with TKisMapScanEditor(EntityEditor) do
      pbPreview.Canvas.FillRect(pbPreview.ClientRect)
  else
  begin
    History := TKisMapScanHistoryElement(FMapHistoryCtrlr.Elements[MapHistory.RecNo]);
    with TKisMapScanEditor(EntityEditor) do
    begin
      if (History.FileOpId <> '') and not Assigned(History.Image) then
      begin
        // загружаем картинку
        ImageFile := TMapScanStorage.GetFileName(AppModule, Self.Nomenclature, sfnMiniDiff, History.FileOpId);
        B := FileExists(ImageFile);
        if not B then
        begin
          ImageFile := ChangeFileExt(ImageFile, '.BMP');
          B := FileExists(ImageFile);
        end;
        if not B then
        begin
          ImageFile := ChangeFileExt(ImageFile, '.JPG');
          B := FileExists(ImageFile);
        end;
        if not B then
        begin
          ImageFile := ChangeFileExt(ImageFile, '.JPEG');
          B := FileExists(ImageFile);
        end;
        if not B then
        begin
          ImageFile := ChangeFileExt(ImageFile, '.PNG');
          B := FileExists(ImageFile);
        end;
        if B then
        begin
          Bmp := nil;
          try
            Bmp := TBitmap.CreateFromFile(ImageFile);
            if (Bmp.Width > 0) and (Bmp.Height > 0) then
              History.Image := Bmp;
          except
            FreeAndNil(Bmp);
          end;
        end;
      end;
      History.PaintFigures(pbPreview);
//      pbPreview.Invalidate;
      //
      btnDeleteHistory.Enabled := not Assigned(History.Image);
    end;
  end;
end;

procedure TKisMapScan.MapHistoryBeforeDelete(DataSet: TDataSet);
begin
  if DataSet.IsEmpty then
    Abort;
  if MessageBox(EntityEditor.Handle,
                PChar(S_CONFIRM_DELETE_HISTORY_LIST),
                PChar(S_CONFIRM),
                MB_YESNO + MB_ICONQUESTION) <> ID_YES
  then
    Abort;
end;

procedure TKisMapScan.MapHistoryInsert(DataSet: TDataSet);
var
  Elmnt: TKisMapScanHistoryElement;
  GiveOut: TKisMapScanGiveOut;
begin
  // Здесь показываем редактор истории планшета
  if FUseGiveOutForMapHistory then
  begin
    GiveOut := FGiveOutsCtrlr.Elements[FGiveOuts.RecNo] as TKisMapScanGiveOut;
    Elmnt := FMapHistoryCtrlr.Elements[0] as TKisMapScanHistoryElement;
    Elmnt.Chief := GiveOut.HolderName;
    Elmnt.DateOfWorks := GiveOut.DateOfGive;
    Elmnt.OrderNumber := GiveOut.DefinitionNumber;
    Elmnt.MensMapping := GiveOut.Address;
    Elmnt.FileOpId := GiveOut.FileOperationId;
  end;
  if not TKisVisualEntity(FMapHistoryCtrlr.Elements[0]).Edit then
    DataSet.Cancel
  else
  begin
    DataSet.Post;
    Modified := True;
  end;
end;

procedure TKisMapScan.PaintHistory(Sender: TObject);
begin
  MapHistoryAfterScroll(MapHistory);
end;

procedure TKisMapScan.PrepareEditor(Editor: TKisEntityEditor);
begin
  inherited;
  with Editor as TKisMapScanEditor do
  begin
    dsGiveOuts.DataSet := FGiveOuts;
    FGiveOuts.Last;

    dsMapHistory.DataSet := FMapHistory;
    FMapHistory.AfterInsert := MapHistoryInsert;
    FMapHistory.AfterDelete := MapHistoryAfterDelete;
    FMapHistory.BeforeDelete := MapHistoryBeforeDelete;
    FMapHistory.AfterScroll := MapHistoryAfterScroll;
    FMapHistory.AfterPost := MapHistoryAfterPost;
    FMapHistory.Refresh;
    pbPreview.OnPaint := PaintHistory;

    btnEditHistory.OnClick := EditMapHistory;
//    btnPrintHistory.OnClick := PrintHistory;

    with AppModule.User do
      SetControlState(Editor, (OfficeID <> ID_OFFICE_KGO) and not IsAdministrator);
    edMD5.ReadOnly := True;
  end;
end;

procedure TKisMapScan.PrintHistory(Sender: TObject);
var
  ReportFileName, Cd: string;
  MapPicture: TfrPictureView;
  MapHistElem: TKisMapHistoryElement;
  TheMetafile: TMetafile;
begin
  // Здесь показываем редактор истории планшета
  if MapHistory.IsEmpty then
    Exit;
  //
  MapHistElem := TKisMapHistoryElement(FMapHistoryCtrlr.Elements[MapHistory.RecNo]);

  ReportFileName := TPath.Build(AppModule.ReportsPath, 'КГО').Finish('Формуляр_скан.frf').Path();
  Cd := GetCurrentDir;
  SetCurrentDir(ExtractFilePath(Application.ExeName));
  ReportFileName := ExpandFileName(ReportFileName);
  SetCurrentDir(Cd);
  with PrintModule do
  begin
    frReport.LoadFromFile(ReportFileName);
    //
    MapPicture := frReport.FindObject('MapPicture') as TfrPictureView;
    if Assigned(MapPicture) then
    begin
      TheMetafile := MapHistElem.PrepareMetafile(MapPicture.dx, True);
      TheMetafile.Forget;
      MapPicture.Picture.Graphic := TheMetafile;
    end;
    //
    SetParamValue('ORG_NAME', MapHistElem.Chief);
    SetParamValue('WORK_DATE', MapHistElem.DateOfWorks);
    SetParamValue('ADDRESS', MapHistElem.MensMapping);
    SetParamValue('AREA', MapHistElem.TotalSum);
    SetParamValue('DEFINITION_NUMBER', MapHistElem.OrderNumber);
    SetParamValue('NET_SURVEY', MapHistElem.EnginNetMapping);
    SetParamValue('EXECUTOR', MapHistElem.WorksExecutor);
    //
    frReport.ShowReport;
  end;
  //
  if Assigned(EntityEditor) then
    with EntityEditor as TKisMapScanEditor do
      if Assigned(dsMapHistory.DataSet)
         and
         Assigned(dsMapHistory.DataSet.AfterScroll)
      then
        dsMapHistory.DataSet.AfterScroll(dsMapHistory.DataSet);
end;

procedure TKisMapScan.ReadDataFromEditor(Editor: TKisEntityEditor);
begin
  inherited;
  with Editor as TKisMapScanEditor do
  begin
    Nomenclature := edNomenclature.Text + '-' + edNom2.Text + '-' + edNom3.Text;
    StartDate := edStartDate.Text;
    //
    if HistoryImageChanged then
    begin
      HistoryPicture := HistoryImage;
      HistoryFile := HistoryImageFile;//Nomenclature + '_formular' + ExtractFileExt(HistoryImageFile);
      Modified := True;
    end;
  end;
end;

procedure TKisMapScan.UnprepareEditor(Editor: TKisEntityEditor);
begin
  with Editor as TKisMapScanEditor do
  begin
    dsGiveOuts.DataSet := nil;
    FGiveOuts.AfterInsert := nil;
    FGiveOuts.BeforeDelete := nil;
    //
    dsMapHistory.DataSet := nil;
    FMapHistory.AfterInsert := nil;
    FMapHistory.AfterDelete := nil;
    FMapHistory.BeforeDelete := nil;
    FMapHistory.AfterScroll := nil;
    FMapHistory.AfterPost := nil;
    //
    btnEditHistory.OnClick := nil;
//    btnPrintHistory.OnClick := nil;
  end;
  inherited;
end;

function TKisMapScan.GiveOutSilent(
  Template: TKisMapScanGiveOut): TKisMapScanGiveOut;
begin
  Result := TKisMapScanGiveOut(MyManager.CreateNewEntity(keMapScanGiveOut));
  Result.Copy(Template);
  Result.Modified := False;
  FGiveOutsCtrlr.DirectAppend(Result);
end;

function TKisMapScan.GiveOut(const MD5Hash: String): Boolean;
var
  MapGiveOut: TKisMapScanGiveOut;
begin
  GiveOuts.Last;
  if CanGiveOut then
  begin
    MapGiveOut := TKisMapScanGiveOut(MyManager.CreateNewEntity(keMapScanGiveOut));
    MapGiveOut.DateOfGive := FormatDateTime(S_DATESTR_FORMAT, Date);
    MapGiveOut.TermOfGive := I_GIVEOUT_TERM;
    MapGiveOut.Modified := False;
    MapGiveOut.InGive := True;
    Result := MapGiveOut.Edit;
    if Result then
    begin
      MapGiveOut.MD5Old := MD5Hash;
      FGiveOutsCtrlr.DirectAppend(MapGiveOut);
      Self.Modified := True;
    end;
    MapGiveOut.InGive := False;
  end
  else
    raise Exception.Create(S_CANT_GIVE_OUT_MAP);
end;

procedure TKisMapScan.AddHistoryFromGiveOut(aGiveOut: TKisMapScanGiveOut);
var
  Elmnt: TKisMapScanHistoryElement;
begin
  FMapHistory.Append;
  Elmnt := FMapHistoryCtrlr.Elements[0] as TKisMapScanHistoryElement;
  Elmnt.Chief := aGiveOut.HolderName;
  Elmnt.DateOfWorks := aGiveOut.DateOfBack;
  Elmnt.OrderNumber := aGiveOut.DefinitionNumber;
  Elmnt.MensMapping := aGiveOut.Address;
  Elmnt.FileOpId := aGiveOut.FileOperationId;
  FMapHistory.Post;
end;

function TKisMapScan.CanGiveOut: Boolean;
var
  Gv: TKisMapScanGiveOut;
begin
  if FGiveOuts.RecordCount = 0 then
    Result := True
  else
  begin
    Gv := GetActualOrLastGiveOut;
    Result := (Gv = nil) or (Gv.DateOfBack <> '');
  end;
end;

function TKisMapScan.TakeBack(MapGive: TKisMapScanGiveOut; const NewMD5Value: String): Boolean;
var
  DateOfBack: string;
begin
  Result := False;
//  if MapGive = nil then
//    MapGive := FGiveOutCtrlr[FGiveOutCtrlr.Count];
  MapGive.InBack := True;
  DateOfBack := MapGive.DateOfBack;
  MapGive.DateOfBack := DateToStr(Date);
  if MapGive.Edit then
  begin
    MapGive.MD5New := NewMD5Value;
    Result := MapGive.Modified;
  end
  else
    MapGive.DateOfBack := DateOfBack;
  MapGive.InBack := False;
end;

procedure TKisMapScan.TakeBackSilent(MapGive: TKisMapScanGiveOut;
  Template: TKisMapScanGiveOut);
begin
  MapGive.InBack := True;
  MapGive.DateOfBack := Template.DateOfBack;
  MapGive.PersonWhoTakedBackId := Template.PersonWhoTakedBackId;
  MapGive.PersonWhoTakedBack := Template.PersonWhoTakedBack;
end;

function TKisMapScan.IsNomenclatureUnique(const Value: String): Boolean;
var
  V: Variant;
begin
  Result := not AppModule.GetFieldValue(nil, ST_MAP_SCANS, SF_NOMENCLATURE, SF_ID, Value, V);
end;

{ TKisMapScansMngr }

procedure TKisMapScansMngr.Activate;
begin
  inherited;
  dsMapScans.Transaction := AppModule.Pool.Get;
  dsMapScans.Transaction.Init();
  dsMapScans.Transaction.AutoStopAction := saNone;
  dsScanOrders.Transaction := dsMapScans.Transaction;
  dsOrdersTakeBack.Transaction := dsMapScans.Transaction;
  Reopen;
end;

procedure TKisMapScansMngr.AddReportLine(const aStatus: Boolean;
  const aFileName, aText, aDebugInfo: String);
var
  FileState: TFileState;
begin
  FileState := TFileState.Create;
  FileState.FileName := aFileName;
  FileState.Status := aStatus;
  FileState.Text := aText;
  FileState.DebugInfo := aDebugInfo;
  FReport.Add(FileState);
end;

procedure TKisMapScansMngr.AfterDownloadFileForView(Order: TObject; Nomenclature: string);
var
  Gv2: TKisMapScanGiveOut2;
  ScanOrder: TKisScanOrder;
  ScanId: Integer;
  Conn: IKisConnection;
begin
  ScanOrder := Order as TKisScanOrder;
  Gv2 := AppModule[kmMapScanViewGiveOuts].CreateNewEntity() as TKisMapScanGiveOut2;
  Gv2.Forget;
  Gv2.DateOfGive := DateToStr(Date);
  Gv2.Holder := FGiveOutTemplate.Holder;
  Gv2.PeopleId := FGiveOutTemplate.PeopleId;
  Gv2.LicensedOrgId := FGiveOutTemplate.LicensedOrgId;
  Gv2.HolderName := FGiveOutTemplate.HolderName;
  Gv2.OrdersId := ScanOrder.Id;
  Gv2.Address := FGiveOutTemplate.Address;
  Gv2.PersonWhoGive := FGiveOutTemplate.PersonWhoGive;
  Gv2.PersonWhoGiveId := FGiveOutTemplate.PersonWhoGiveId;
  Gv2.OfficeId := FGiveOutTemplate.OfficeId;
  Gv2.PeopleName := FGiveOutTemplate.PeopleName;
  Gv2.MD5Old := theMapScansStorage.GetMD5Hash(AppModule, Nomenclature);
  Gv2.Nomenclature := Nomenclature;
  Conn := GetConnection(True, False);
  ScanId := GetScanIdByNomenclature(Conn, Nomenclature);
  Gv2.MapScanId := ScanId;
  Gv2.Modified := True;
  //
  AppModule[kmMapScanViewGiveOuts].SaveEntity(Gv2);
end;

procedure TKisMapScansMngr.AfterDownloadGiveOutFile(Order: TObject; Nomenclature: string);
var
  OldMD5: string;
  ScanOrder: TKisScanOrder;
  Map: TKisScanOrderMap;
  Scan: TKisMapScan;
  Conn: IKisConnection;
  Go: TKisMapScanGiveOut;
begin
  OldMD5 := theMapScansStorage.GetMD5Hash(AppModule, Nomenclature);
  FScansPrintTable.Add(Nomenclature + '=' + OldMD5);
  //
  ScanOrder := Order as TKisScanOrder;
  Map := ScanOrder.FindMap(Nomenclature);
  if Map.InStore then
  begin
    Scan := nil;
    try
      Conn := GetConnection(True, True);
      try
        Scan := GetScanByNomenclature(Conn, Nomenclature);
      finally
        FreeConnection(Conn, True);
      end;
      Go := Scan.GiveOutSilent(FGiveOutTemplate);
      Go.MD5Old := OldMD5;
      Go.ScanOrderMapId := Map.Id;
      Go.Modified := True;
      //
      Scan.Modified := True;
      SaveEntity(Scan);
    finally
      FreeAndNil(Scan);
    end;
  end;
end;

procedure TKisMapScansMngr.DataModuleCreate(Sender: TObject);
begin
  inherited;
  FReport := TFileReport.Create;
  FScansPrintTable := TStringList.Create;
end;

procedure TKisMapScansMngr.DataModuleDestroy(Sender: TObject);
begin
  FreeAndNil(FScansPrintTable);
  FreeAndNil(FReport);
  inherited;
end;

procedure TKisMapScansMngr.Deactivate;
begin
  inherited;
  dsScanOrders.Close;
  dsMapScans.Close;
  if not dsMapScans.Transaction.Active then
    dsMapScans.Transaction.Commit;
  AppModule.Pool.Back(dsMapScans.Transaction);
end;

function TKisMapScansMngr.DefineGiveOutGeometry(aOrder: TKisScanOrder; out aGeometry: TKisMapScanGeometry): Boolean;
begin
  aGeometry := TKisMapScanGeometry.Create;
  Result := TKisGivenScanEditor2.Execute(aOrder, aGeometry);
  if not Result then
    FreeAndNil(aGeometry);
end;

function TKisMapScansMngr.GenEntityID(EntityKind: TKisEntities): Integer;
begin
  case EntityKind of
    keDefault, keMapScan :
      Result := AppModule.GetID(SG_MAP_SCANS, Self.DefaultTransaction);
    keMapScanGiveOut :
      Result := AppModule.GetID(SG_MAP_SCANS_GIVEOUTS, Self.DefaultTransaction);
    keMapScanHistoryElement :
      Result := AppModule.GetID(SG_MAP_SCANS_HISTORY, Self.DefaultTransaction, True);
    keMapScanHistoryFigure :
      Result := AppModule.GetID(SG_MAP_SCANS_FIGURE, Self.DefaultTransaction);
  else
    Result := -1;
  end;
end;

function TKisMapScansMngr.GetIdent: TKisMngrs;
begin
  Result := kmMapScans;
end;

function TKisMapScansMngr.GetMainSQLText: String;
begin
  Result := SQ_MAIN;
end;

function TKisMapScansMngr.GetNewGiveOutTemplate(Order: TKisScanOrder; Term: Integer): TKisMapScanGiveOut;
var
  V: Variant;
begin
  Result := TKisMapScanGiveOut.Create(Self);
  Result.DateOfGive := FormatDateTime(S_DATESTR_FORMAT, Date);
  Result.TermOfGive := I_GIVEOUT_TERM;
  Result.OrderNumber := Order.OrderNumber;
  Result.Address := Order.Address;
  Result.OfficeId := Order.OfficeId;
  Result.LicensedOrgId := Order.LicensedOrgId;
  Result.Holder := Order.LicensedOrgId > 0;
  if Result.Holder then
  begin
    if not AppModule.GetFieldValue(
              dsMapScans.Transaction,
              ST_LICENSED_ORGS,
              SF_ID,
              SF_NAME,
              Order.LicensedOrgId, V)
    then
      V := ' ';
    Result.HolderName := VarToStr(V);
  end;
  Result.Modified := False;
end;

procedure TKisMapScansMngr.GetPrintValue(const ParName: string;
  var ParValue: Variant);
begin
  with PrintModule(False) do
  if AnsiCompareText(ParName, 'NOMENCLATURE') = 0 then
    ParValue := FScansPrintTable.Names[UserDataset.RecNo]
  else
  if AnsiCompareText(ParName, 'MD5') = 0 then
    ParValue := FScansPrintTable.ValueFromIndex[UserDataset.RecNo];
end;

function TKisMapScansMngr.IsSupported(Entity: TKisEntity): Boolean;
begin
  Result := Assigned(Entity)
    and ((Entity is TKisMapScan)
         or (Entity is TKisMapScanGiveOut)
         or (Entity is TKisMapScanHistoryElement)
         or (Entity is TKisMapScanHistoryFigure)
         );
  if not Result then
    inherited IsSupported(Entity);
end;

constructor TKisMapScansMngr.Create(AOnwer: TComponent);
begin
  inherited;
  FGiveOutsHelper := TKisSQLHelper.Create(Self);
  FTakeBacksHelper := TKisSQLHelper.Create(Self);
  PrepareAdditionalHelpers;
end;

function TKisMapScansMngr.CreateEntity(EntityKind: TKisEntities): TKisEntity;
begin
  case EntityKind of
  keDefault, keMapScan :
    Result := TKisMapScan.Create(Self);
  keMapScanGiveOut :
    Result := TKisMapScanGiveOut.Create(Self);
  keMapScanHistoryElement :
    Result := TKisMapScanHistoryElement.Create(Self);
  keMapScanHistoryFigure :
    Result := TKisMapScanHistoryFigure.Create(Self);
  keMapScanState :
    Result := TKisMapScanState.Create(Self);
  else
    Result := nil;
  end;
end;

function TKisMapScansMngr.CreateNewEntity(EntityKind: TKisEntities): TKisEntity;
begin
  Result := CreateEntity(EntityKind);
  if Assigned(Result) then
  begin
    Result.ID := Self.GenEntityID(EntityKind);
    if Result is TKisMapScan then
      TKisMapScan(Result).FIsNew := True;
  end
  else
    raise Exception.Create(S_CANT_CREATE_NEW_ENTITY);
end;

function TKisMapScansMngr.CurrentEntity: TKisEntity;
begin
  Result := GetEntity(dsMapScans.FieldByName(SF_ID).AsInteger, keMapScan);
  if Assigned(Result) then
    Result.Modified := False;
end;

procedure TKisMapScansMngr.DeleteEntity(Entity: TKisEntity);
var
  Conn: IKisConnection;
  S: String;
begin
  Conn := GetConnection(True, True);
  if IsEntityInUse(Entity) then
    inherited
  else
    try
      S := '';
      if Entity is TKisMapScanGiveOut then
        S := SQ_DELETE_MAP_SCAN_GIVE
      else
      if Entity is TKisMapScan then
        S := SQ_DELETE_MAP_SCAN
      else
      if Entity is TKisMapScanHistoryElement then
        S := SQ_DELETE_MAP_SCAN_HISTORY;
      //
      Conn.GetDataSet(Format(S, [Entity.ID])).Open;
      FreeConnection(Conn, True);
    except
      FreeConnection(Conn, False);
      raise;
    end;
end;

destructor TKisMapScansMngr.Destroy;
begin
  FreeAndNil(FTakeBacksHelper);
  FreeAndNil(FGiveOutsHelper);
  inherited;
end;

procedure TKisMapScansMngr.DoUserSearch(const Str: String; Field: TField);
var
  NewStr: string;
  N: TNomenclature;
begin
  NewStr := Str;
  if (Str <> '') and (Assigned(Field)) then
    if Field = dsMapScansNOMENCLATURE then
    begin
      N.Init(Str, False);
      if not N.Valid then
      begin
        NewStr := N.GetValidParts();
        if NewStr = '' then
          NewStr := Str;
      end
      else
        NewStr := N.Nomenclature();
    end;
  inherited DoUserSearch(NewStr, Field);
end;

procedure TKisMapScansMngr.dsOrdersTakeBackBeforeOpen(DataSet: TDataSet);
begin
  inherited;
  dsOrdersTakeBack.SelectSQL.Text := FTakeBacksHelper.SQL;
end;

procedure TKisMapScansMngr.dsScanOrdersBeforeOpen(DataSet: TDataSet);
begin
  inherited;
  dsScanOrders.SelectSQL.Text := FGiveOutsHelper.SQL;
end;

function TKisMapScansMngr.GetEntity(EntityID: Integer;
  EntityKind: TKisEntities): TKisEntity;
var
  DataSet: TDataSet;
  Conn: IKisConnection;
  SQLText: String;
begin
  Result := nil;
  Conn := GetConnection(True, False);
  try
    case EntityKind of
    keDefault, keMapScan :
      SQLText := Format(SQ_SELECT_MAP_SCAN, [EntityID]);
    keMapScanGiveOut :
      SQLText := Format(SQ_SELECT_MAP_SCAN_GIVEOUT, [EntityID]);
    keMapScanHistoryElement :
      SQLText := Format(SQ_SELECT_MAP_SCAN_HISTORY, [EntityID]);
    keMapScanHistoryFigure :
      SQLText := Format(SQ_SELECT_MAP_SCAN_FIGURE, [EntityID]);
    keMapScanState :
      SQLText := Format(SQ_SELECT_MAP_SCAN_STATE, [EntityID]);
    else
      raise ELoadEntity.Create(EntityID, EntityKind);
    end;
    DataSet := Conn.GetDataSet(SQLText);
    DataSet.Open;
    if not DataSet.IsEmpty then
    begin
      Result := CreateEntity(EntityKind);
      Result.Load(DataSet);
      //
      if EntityKind = keMapScanHistoryElement then
      begin
        LoadFigures(Conn, Result as TKisMapScanHistoryElement);
      end
      else
      if EntityKind = keMapScanHistoryFigure then
      begin
        LoadFigurePoints(Conn, Result as TKisMapScanHistoryFigure);
      end;
    end
    else
      raise ELoadEntity.Create(EntityID, EntityKind);
  finally
    FreeConnection(Conn, True);
  end;
end;

procedure TKisMapScansMngr.CreateView;
begin
  if not Assigned(FView) then
    FView := TKisMapScansView.Create(Self);
  inherited;
  //
  with FView.Legend do
  begin
    ItemOffset := 8;
    Caption := 'Цвета';
    with Items.Add do
    begin
      Color := clWindow;
      Caption := 'В картохранилище';
    end;
    with Items.Add do
    begin
      Color := $9999FF;
      Caption := 'Просрочен';
    end;
    with Items.Add do
    begin
      Color := $99FFFF;
      Caption := 'Выдан на руки';
    end;
    with Items.Add do
    begin
      Color := $CCFFCC;
      Caption := 'Секретная часть';
    end;
  end;
  //
  FView.Caption := 'Сканы Планшеты 1:500';  //заголовок формы
  FView.Grid.OnCellColors := GridCellColors;
  FView.Grid.OnLogicalColumn := GridLogicalColumn;
  FView.Grid.OnGetLogicalValue := GridGetLogicalValue;
  //
  with TKisMapScansView(FView) do
  begin
    if dgEditing in dbgScanOrders.Options then
      dbgScanOrders.Options := dbgScanOrders.Options - [dgEditing];
    dbgScanOrders.DataSource := dsrcScanOrders;
    dbgScanOrders.OnDblClick := ScanOrdersGridDblClick;
    //
    tbOrders.Images := ImageList;
    tbOrders.Buttons[0].Action := acConfirmOrder;
    tbOrders.Buttons[1].Action := acGiveOutForView;
    tbOrders.Buttons[2].Action := acRefreshOrders;
    tbOrders.Buttons[3].Action := acSortGiveOuts;
    //
    if dgEditing in dbgOrdersTakeBack.Options then
      dbgOrdersTakeBack.Options := dbgOrdersTakeBack.Options - [dgEditing];
    dbgOrdersTakeBack.DataSource := dsrcOrdersTakeBack;
    dbgOrdersTakeBack.OnDblClick := OrderTakeBackGridDblClick;
    //
    tbTakeBack.Images := ImageList;
    tbTakeBack.Buttons[0].Action := acTakeBackOrder;
    tbTakeBack.Buttons[1].Action := acGiveOutAgain;
    tbTakeBack.Buttons[2].Action := acRefreshTakeBack;
    tbTakeBack.Buttons[3].Action := acSortTakeBacks;
    //
    if PopupMenu1.Items.Count = 0 then
    begin
      PopupMenu1.AddNewItem().Action := acAnnullOrder;
      PopupMenu1.AddNewItem().Action := acOrderView;
      PopupMenu2.AddNewItem().Action := acOrderView2;
      PopupMenu2.AddNewItem().Action := acTakeBackAsNoChanges;
    end;
  end;
  //
  FView.ToolBarNav.Visible := True;
end;

function TKisMapScansMngr.IsEntityInUse(Entity: TKisEntity): Boolean;
begin
  Result := False;
end;

procedure TKisMapScansMngr.PrepareAdditionalHelpers;
begin
  FGiveOutsHelper.SQL := SQ_GET_ACTIVE_SCAN_ORDERS;
  with FGiveOutsHelper.AddTable do
  begin
    TableName := ST_SCAN_ORDERS_ALL_VIEW_2;
    TableLabel := 'Выдача';
    AddSimpleField(SF_ORDER_DATE, SFL_SCAN_ORDER_DATE, ftDate, [fpSort]);
    AddStringField(SF_ORDER_NUMBER, SFL_SCAN_ORDER_NUMBER, 20, [fpSort]);
    AddStringField(SF_CUSTOMER, SFL_CUSTOMER, 200, [fpSort]);
//    AddSimpleField(SF_ADDRESS, SFL_ADDRESS, 255, [fpSort]);
//    AddSimpleField(SF_WORK_TYPE, SFL_WGIVE_STATUS, ftBoolean, [fpSearch, fpSort]);
//    AddSimpleField(SF_ID, SFL_ID, ftInteger, [fpSort]);
  end;
  FTakeBacksHelper.SQL := SQ_GET_GIVEN_SCAN_ORDERS;
  with FTakeBacksHelper.AddTable do
  begin
    TableName := ST_SCAN_ORDERS_ALL_VIEW_2;
    TableLabel := 'Приём';
    AddSimpleField(SF_ORDER_DATE, SFL_SCAN_ORDER_DATE, ftDate, [fpSort]);
    AddStringField(SF_ORDER_NUMBER, SFL_SCAN_ORDER_NUMBER, 20, [fpSort]);
    AddStringField(SF_CUSTOMER, SFL_CUSTOMER, 200, [fpSort]);
//    AddSimpleField(SF_ADDRESS, SFL_ADDRESS, 255, [fpSort]);
//    AddSimpleField(SF_WORK_TYPE, SFL_WGIVE_STATUS, ftBoolean, [fpSearch, fpSort]);
//    AddSimpleField(SF_ID, SFL_ID, ftInteger, [fpSort]);
  end;
end;

procedure TKisMapScansMngr.PrepareSQLHelper;
begin
  inherited;
  with FSQLHelper.AddTable do
  begin
    TableName := ST_MAP_SCANS;
    TableLabel := 'Основная (сканы)';
    AddStringField(SF_NOMENCLATURE, SFL_NOMENCLATURE, 20, [fpSearch, fpSort, fpQuickSearch]);
    AddStringField(SF_HOLDER_NAME, SFL_HOLDER_NAME, 300, [fpSearch, fpSort, fpQuickSearch]);
    AddSimpleField(SF_DATE_OF_GIVE, SFL_DATE_OF_GIVE, ftDate, [fpSearch, fpSort]);
    AddSimpleField(SF_GIVE_STATUS, SFL_GIVE_STATUS, ftBoolean, [fpSearch, fpSort]);
    AddSimpleField(SF_EXPIRED, SFL_EXPIRED, ftBoolean, [fpSearch, fpSort]);
    AddSimpleField(SF_START_DATE, SFL_SCAN_DATE, ftDate, [fpSearch, fpSort]);
    AddSimpleField(SF_ID, SFL_ID, ftInteger, [fpSort]);
  end;
end;

procedure TKisMapScansMngr.PrintAct;
var
  ReportFileName, Cd: string;
  OrgTitle, OrgFio, OrgName: string;
  MasterData: TfrView;
  Worker: TKisWorker;
  Office: TKisOffice;
begin
  ReportFileName := TPath.Build(AppModule.ReportsPath, 'КГО').Finish(ReportFile).Path();
  Cd := GetCurrentDir;
  SetCurrentDir(ExtractFilePath(Application.ExeName));
  ReportFileName := ExpandFileName(ReportFileName);
  SetCurrentDir(Cd);
  with PrintModule do
  begin
    frReport.LoadFromFile(ReportFileName);
    //
    UserDataSet.OnCheckEOF := PrintCheckEof;
    frReport.OnGetValue := GetPrintValue;
    MasterData := frReport.FindObject('MasterData1');
    if (MasterData <> nil) and (MasterData is TfrBandView) then
      TfrBandView(MasterData).DataSet := 'UserDataSet';
    //
    SetParamValue('ORDER_DATE', anOrder.OrderDate);
    SetParamValue('ORDER_NUMBER', anOrder.OrderNumber);
    SetParamValue('ADDRESS', anOrder.Address);
    SetParamValue('WORK', anOrder.WorkType);
    SetParamValue('DEFINITION', Template.DefinitionNumber);
    Worker := AppModule[kmPeople].GetEntity(KGOWorkerId) as TKisWorker;
    SetParamValue('KGO_TITLE', Worker.Category);
    SetParamValue('KGO_FIO', Worker.InitialName);
    Office := AppModule.Mngrs[kmOffices].GetEntity(Worker.OfficesId) as TKisOffice;
    SetParamValue('KGO_OFFICE', Office.Name);
    if Template.Holder then
    begin
      OrgTitle := ' ';
      OrgFio := OrgPeopleName;
      OrgName := Template.HolderName;
    end
    else
    begin
      Worker := AppModule[kmPeople].GetEntity(CustomerWorkedId) as TKisWorker;
      OrgTitle := Worker.Category;
      OrgFio := Worker.InitialName;
      Office := AppModule.Mngrs[kmOffices].GetEntity(Worker.OfficesId) as TKisOffice;
      OrgName := Office.Name;
    end;
    SetParamValue('ORG_TITLE', OrgTitle);
    SetParamValue('ORG_FIO', OrgFio);
    SetParamValue('ORG_NAME', OrgName);
    //
    frReport.ShowReport;
    //
    UserDataSet.OnCheckEOF := nil;
    frReport.OnGetValue := nil;
  end;
end;

procedure TKisMapScansMngr.PrintCheckEof(Sender: TObject; var Eof: Boolean);
begin
  if Sender is TfrDataset then
    Eof := TfrDataset(Sender).RecNo >= FScansPrintTable.Count;
end;

procedure TKisMapScansMngr.ProcessOrderWithMissedScans(var Order: TKisScanOrder; MissedScans: TStringList);
var
  UsrChoice: TMissingScansResult;
  NewOrder: TKisScanOrder; 
  OrderMngr: TKisScanOrdersMngr;
  Nomen: string;
  Geometry: TKisMapScanGeometry;
  MapList: TStringList;
begin
  OrderMngr := AppModule[kmScanOrders] as TKisScanOrdersMngr;
  UsrChoice := TMissingScansForm.Execute(Order, MissedScans);
  case UsrChoice of
  msrNewOrder :
    begin
      NewOrder := OrderMngr.CreateNewEntity(keScanOrder) as TKisScanOrder;
      NewOrder.Copy(Order);
      NewOrder.Maps.First;
      while not NewOrder.Maps.Eof do
      begin
        Nomen := NewOrder.Maps.FieldByName(SF_NOMENCLATURE).AsString;
        if MissedScans.IndexOf(Nomen) >= 0 then
          NewOrder.Maps.Delete
        else
          NewOrder.Maps.Next;
      end;
      NewOrder.OrderDate := DateToStr(Date);
      NewOrder.OrderNumber := OrderMngr.GenNewOrderNumber;
      OrderMngr.SaveEntity(NewOrder);
      //
      Order.Annulled := True;
      OrderMngr.SaveEntity(Order);
      //
      OrderMngr.ShowEntities(nil, NewOrder.Id);
    end;
  msrAnnulOrder :
    begin
      Order.Annulled := True;
      OrderMngr.SaveEntity(Order);
      Order := nil;
    end;
  msrCancel :
    begin
      Order := nil;
    end;
  msrNoReturn :
    begin
      Geometry := nil;
      try
        MapList := TStringList.Create;
        MapList.Forget;
        Order.Maps.First;
        while not Order.Maps.Eof do
        begin
          Nomen := Order.Maps.FieldByName(SF_NOMENCLATURE).AsString;
          MapList.Add(Nomen);
          Order.Maps.Next;
        end;
        if DownloadOrderFiles(Order, MapList, nil) then //без возврата, т.к. не все файлы в наличии
        begin
          MissedScans.Clear;
          ShowMessage('Скопировано файлов: ' + IntToStr(Order.Maps.RecordCount) + ' .');
        end;
      finally
        FreeAndNil(Geometry);
      end;
    end;
  end;
end;

procedure TKisMapScansMngr.ReadOrderState;
begin
  inherited ReadOrderState(Helper);
  inherited ReadOrderState(FGiveOutsHelper, 'SortOrder_GO');
  inherited ReadOrderState(FTakeBacksHelper, 'SortOrder_TB');
end;

procedure TKisMapScansMngr.RefreshDataSet(Ds: TDataSet);
var
  B: Boolean;
begin
  Ds.DisableControls;
  try
    B := Ds.RecNo = 1;
    if B then
      Ds.Next
    else
      Ds.Prior;
    SafeReopen(Ds, SF_ID);
    if B then
      Ds.Prior
    else
      Ds.Next;
  finally
    Ds.EnableControls;
  end;
end;

procedure TKisMapScansMngr.Reopen;
begin
  inherited;
  SafeReopen(dsScanOrders, SF_ID);
  SafeReopen(dsOrdersTakeBack, SF_ID);
end;

procedure TKisMapScansMngr.SaveEntity(Entity: TKisEntity);
begin
  inherited;
  if Assigned(Entity) then
  if IsSupported(Entity) then
  if Entity is TKisMapScan then
    SaveMapScan(TKisMapScan(Entity))
  else
     if (Entity is TKisMapScanGiveOut) then
        SaveGiveOut(TKisMapScanGiveOut(Entity))
     else
       if (Entity is TKisMapScanHistoryElement) then
          SaveHistory(TKisMapScanHistoryElement(Entity));
end;

procedure TKisMapScansMngr.SaveFigure(Conn: IKisConnection; aFigure: TKisMapHistoryFigure);
var
  DataSet: TDataSet;
  I: Integer;
begin
  if aFigure.ID < 1 then
    aFigure.ID := Self.GenEntityID(keMapScanHistoryFigure)
  else
  begin
    DataSet := Conn.GetDataSet(SQ_DELETE_MAP_SCAN_FIGURE);
    Conn.SetParam(DataSet, SF_ID, aFigure.ID);
    DataSet.Open;
  end;
  DataSet := Conn.GetDataSet(SQ_INSERT_MAP_SCAN_FIGURE);
  Conn.SetParam(DataSet, SF_ID, aFigure.ID);
  Conn.SetParam(DataSet, SF_HISTORY_ELEMENT_ID, aFigure.HistoryElementId);
  Conn.SetParam(DataSet, SF_FIGURE_COLOR, aFigure.FigureColor);
  Conn.SetParam(DataSet, SF_FIGURE_TYPE, Integer(aFigure.FigureType));
  Conn.SetParam(DataSet, SF_EXTENT_BOTTOM, aFigure.Extent.Bottom);
  Conn.SetParam(DataSet, SF_EXTENT_LEFT, aFigure.Extent.Left);
  Conn.SetParam(DataSet, SF_EXTENT_RIGHT, aFigure.Extent.Right);
  Conn.SetParam(DataSet, SF_EXTENT_TOP, aFigure.Extent.Top);
  DataSet.Open;
  //
  DataSet := Conn.GetDataSet(SQ_INSERT_MAP_SCAN_FIGURE_POINT);
  Conn.PrepareDataSet(DataSet);
  for I := 0 to Pred(aFigure.PointCount) do
  begin
    Conn.SetParam(DataSet, SF_ID, I);
    Conn.SetParam(DataSet, SF_FIGURE_ID, aFigure.ID);
    Conn.SetParam(DataSet, SF_X, aFigure.Points[I].X);
    Conn.SetParam(DataSet, SF_Y, aFigure.Points[I].Y);
    DataSet.Open;
    DataSet.Close;
  end;
end;

{ TKisMapScanGiveOut }

function TKisMapScanGiveOut.CheckEditor(AEditor: TKisEntityEditor): Boolean;
var
  B: Boolean;
  I: Int64;
  GiveDate, BackDate: TDateTime;

  procedure ErrorInBackDate;
  begin
    MessageBox(AEditor.Handle, PChar(S_CHECK_DATE_OF_BACK), PChar(S_WARN), MB_OK + MB_ICONWARNING);
    with AEditor as TKisGivenScanEditor do
      edDateOfBack.SetFocus;
  end;

begin
  Result := False;
  if AEditor is TKisGivenScanEditor then
    with AEditor as TKisGivenScanEditor do
    begin
      if (Length(Trim(edDateOfGive.Text)) = 0) or not TryStrToDate(edDateOfGive.Text, GiveDate) or
            ((GiveDate > Date) or (GiveDate < MIN_DOC_DATE)) then
          begin
            AppModule.Alert(S_CHECK_DATE_OF_GIVE);
            edDateOfGive.SetFocus;
            Exit;
          end;
      if (GiveDate > Date) then
      begin
        MessageBox(AEditor.Handle, PChar('Дата выдачи больше сегодняшней!'), PChar(S_WARN), MB_OK + MB_ICONWARNING);
        edDateOfBack.SetFocus;
        Result := False;
        Exit;
      end;
      B := Trim(edTermOfGive.Text) = '';
      if not B then
        B := not StrIsNumber(Trim(edTermOfGive.Text), I);
      if B then
      begin
        AppModule.Alert(S_CHECK_TERM_OF_GIVE);
        edTermOfGive.SetFocus;
        Exit;
      end;
      //сторонние организации
      if RadBtnOrgs.Checked then
      begin
        if (Length(Trim(edOrgname.Text)) = 0) then
        begin
          AppModule.Alert(S_CHECK_EXTERIOR_ORGS);
          edOrgname.SetFocus;
          Exit;
        end;
      end
      else
      //MP
      begin
        if (Length(Trim(cbOffices.Text)) = 0) then
        begin
          AppModule.Alert(S_CHECK_OFFICE);
          cbOffices.SetFocus;
          Exit;
        end;
        if (Length(Trim(cbPeople.Text)) = 0) then
        begin
          AppModule.Alert(S_CHECK_EXECUTOR);
          cbPeople.SetFocus;
          Exit;
        end;
      end;
      if (Length(Trim(edDefinitionNumber.Text)) = 0) then
      begin
        AppModule.Alert(S_CHECK_DEFINITION_NUMBER);
        edDefinitionNumber.SetFocus;
        Exit;
      end;
      if (Length(Trim(edOrderNumber.Text)) = 0) then
      begin
        AppModule.Alert(S_CHECK_ORDER_NUMBER);
        edOrderNumber.SetFocus;
        Exit;
      end;
      if (Length(Trim(edAddress.Text)) = 0) then
      begin
      /// игнорирование "Адрес проведения работ"
      /// start ed: changes - //
        edAddress.Text := 'адрес не нужен';  //add ed changes
        //AppModule.Alert(S_CHECK_ADDRESS);
        //edAddress.SetFocus;
        //Exit;
      ///end ed
      end;
      if (Length(Trim(cbPersonWhoGive.Text)) = 0) then
      begin
        AppModule.Alert(S_CHECK_PERSON_WHO_GIVE);
        cbPersonWhoGive.SetFocus;
        Exit;
      end;
      if InBack then
      begin
        if (edDateOfBack.Text = '') then
        begin
          ErrorInBackDate;
          Result := False;
          Exit;
        end;
        if not TryStrToDate(edDateOfBack.Text, BackDate) then
        begin
          ErrorInBackDate;
          Result := False;
          Exit;
        end;
        if (BackDate < MIN_DOC_DATE) then
        begin
          ErrorInBackDate;
          Result := False;
          Exit;
        end;
        if BackDate < StrToDate(Self.DateOfGive) then
        begin
          MessageBox(AEditor.Handle, PChar('Дата возврата меньше даты выдачи!'), PChar(S_WARN), MB_OK + MB_ICONWARNING);
          edDateOfBack.SetFocus;
          Result := False;
          Exit;
        end;
        if cbWhoTakedBack.ItemIndex < 0 then
        begin
          AppModule.Alert(S_CHECK_PERSON_WHO_TAKED_BACK);
          cbWhoTakedBack.SetFocus;
          Exit;
        end;
      end;
    end;
  Result := True;
end;

procedure TKisMapScanGiveOut.Copy(Source: TKisEntity);
begin
  inherited;
  with Source as TKisMapScanGiveOut do
  begin
    Self.FGivenObject := FGivenObject;
    Self.FDateOfGive := FDateOfGive;
    Self.FTermOfGive := FTermOfGive;
    Self.FHolder := FHolder;
    Self.FPeopleId := FPeopleId;
    Self.FPeopleName := FPeopleName;
    Self.FLicensedOrgId := FLicensedOrgId;
    Self.FHolderName := FHolderName;
    Self.FDateOfBack := FDateOfBack;
    Self.FDefinitionNumber := FDefinitionNumber;
    Self.FOrderNumber := FOrderNumber;
    Self.FOrdersId := FOrdersId;
    Self.FAddress := FAddress;
    Self.FPersonWhoGiveId := FPersonWhoGiveId;
    Self.FPersonWhoGive := FPersonWhoGive;
    Self.FPersonWhoTakedBackId := FPersonWhoTakedBackId;
    Self.FPersonWhoTakedBack := FPersonWhoTakedBack;
    Self.FOfficeId := FOfficeId;
    Self.FPeopleBackId := FPeopleBackId;
    Self.FPeopleBackName := FPeopleBackName;
    Self.FMD5Old := FMD5Old;
    Self.FMD5New := FMD5New;
    Self.FScanOrderMapId := FScanOrderMapId; 
    Self.FFileId := FFileId;
    Self.FAnnulled := FAnnulled;
    Self.FSquares := FSquares;
  end;
end;

function TKisMapScanGiveOut.CreateEditor: TKisEntityEditor;
begin
  Result := TKisGivenScanEditor.Create(Application);
end;

class function TKisMapScanGiveOut.EntityName: String;
begin
  Result := 'Список выдачи сканов';
end;

function TKisMapScanGiveOut.GetExpired: Boolean;
var
  D: TDateTime;
begin
  if (FDateOfBack = '') and TryStrToDate(FDateOfGive, D) then
    Result := (D + FTermOfGive) < Now
  else
    Result := False;
end;

function TKisMapScanGiveOut.GetMyEditor: TKisGivenScanEditor;
begin
  Result := EntityEditor as TKisGivenScanEditor;
end;

function TKisMapScanGiveOut.HasChangesInMap: Boolean;
begin
  Result := False;
  if Annulled then
    Exit;
  if (FileOperationId = '')
     or
     (FileOperationId = S_FILEOP_NO_CHANGES)
     or
     (FileOperationId = S_FILEOP_NO_RETURN)
  then
    Exit;
  if MD5New = '' then
    Exit;
  if MD5New = MD5Old then
    Exit;
  Result := True;
end;

procedure TKisMapScanGiveOut.Load(DataSet: TDataSet);
begin
  inherited;
  with DataSet do
  begin
    ID := FieldByName(SF_ID).AsInteger;
    Address := FieldByName(SF_ADDRESS).AsString;
    DateOfBack := FieldByName(SF_DATE_OF_BACK).AsString;
    DateOfGive := FieldByName(SF_DATE_OF_GIVE).AsString;
    DefinitionNumber := FieldByName(SF_DEFINITION_NUMBER).AsString;
    Holder := Boolean(FieldByName(SF_HOLDER).AsInteger);
    HolderName := FieldByName(SF_HOLDER_NAME).AsString;
    OrderNumber := FieldByName(SF_ORDER_NUMBER).AsString;
    OrdersId := FieldByName(SF_ORDERS_ID).AsInteger;
    LicensedOrgId := FieldByName(SF_LICENSED_ORGS_ID).AsInteger;
    PeopleId := FieldByName(SF_PEOPLE_ID).AsInteger;
    PeopleName := FieldByName(SF_PEOPLE_NAME).AsString;
    PersonWhoGiveId := FieldByName(SF_PERSON_WHO_GIVE_ID).AsInteger;
    PersonWhoGive := FieldByName(SF_PERSON_WHO_GIVE).AsString;
    PersonWhoTakedBackId := FieldByName(SF_PERSON_WHO_TAKED_BACK_ID).AsInteger;
    PersonWhoTakedBack := FieldByName(SF_PERSON_WHO_TAKED_BACK).AsString;
    TermOfGive := FieldByName(SF_TERM_OF_GIVE).AsInteger;
    OfficeId := FieldByName(SF_OFFICES_ID).AsInteger;
    PeopleBackId := FieldByName(SF_PEOPLE_BACK_ID).AsInteger;
    PeopleBackName := FieldByName(SF_PEOPLE_BACK_NAME).AsString;
    MD5Old := FieldByName(SF_MD5_OLD).AsString;
    MD5New := FieldByName(SF_MD5_NEW).AsString;
    FileOperationId := FieldByName(SF_FILE_OPERATION_ID).AsString;
    FScanOrderMapId := FieldByName(SF_SCAN_ORDER_MAPS_ID).AsInteger;
    FAnnulled := FieldByName(SF_ANNULLED).AsInteger = 1;
    if DataSet.FindField(SF_SQUARES) = nil then
      FSquares := DupeString('1', 25)
    else
      FSquares := FieldByName(SF_SQUARES).AsString;
    Self.Modified := False;
  end;
end;

procedure TKisMapScanGiveOut.LoadDataIntoEditor(AEditor: TKisEntityEditor);
var
  Ed: TKisGivenScanEditor;
begin
  inherited;
  Ed := AEditor as TKisGivenScanEditor;
  // общая информация
  Ed.edDateOfGive.Text := DateOfGive;
  if TermOfGive = 0 then
    Ed.edTermOfGive.Text := ''
  else
    Ed.edTermOfGive.Text := IntToStr(TermOfGive);
  if DateOfBack <> '' then
    Ed.edDateOfBack.Text := DateOfBack;
  Ed.edDefinitionNumber.Text := DefinitionNumber;
  Ed.edOrderNumber.Text := OrderNumber;
  Ed.edAddress.Text := Address;
  // кто выдал
  Ed.cbPersonWhoGive.Items := IStringList(AppModule.PeolpeList(ID_OFFICE_KGO)).StringList;
  if PersonWhoGiveId > 0 then
    ComboLocate(Ed.cbPersonWhoGive, PersonWhoGiveId)
  else
    Ed.cbPersonWhoGive.ItemIndex := Ed.cbPersonWhoGive.Items.IndexOf(AppModule.User.ShortName);//FullName);
  // кому выдал
  Ed.RadBtnOrgs.Checked := Holder;
  Ed.RadBtnMP.Checked := not Ed.RadBtnOrgs.Checked;
  if Holder then
  begin
    //грузим сторониие организации
    Ed.cbPeople.Visible := false;
    Ed.edOrgname.Text := HolderName;
    Ed.edContacter.Visible := True;
    Ed.edContacter.Text := PeopleName;
  end
  else
  begin
    //грузим отделы и исполнителей
    Ed.cbPeople.Visible := true;
    Ed.cbOffices.ItemIndex := OfficeId;
    ComboLocate(Ed.cbOffices, OfficeId);
    LoadPeopleList(nil);
    ComboLocate(Ed.cbPeople, PeopleId);
    Ed.cbPeople.Text := PeopleName;
  end;
  // кто принял
  Ed.cbWhoTakedBack.Items.Assign(Ed.cbPersonWhoGive.Items);
  if PersonWhoTakedBackId > 0 then
    ComboLocate(Ed.cbWhoTakedBack, PersonWhoTakedBackId)
  else
  begin
    Ed.cbWhoTakedBack.ItemIndex := Ed.cbWhoTakedBack.Items.IndexOf(AppModule.User.ShortName);//FullName);
    if Ed.cbWhoTakedBack.ItemIndex < 0 then
       if PersonWhoGiveId > 0 then
        ComboLocate(Ed.cbWhoTakedBack, PersonWhoGiveId)
  end;
  // от кого принял
  if Holder then
  begin
    //грузим сторониие организации
    Ed.cbPeopleBack.Visible := False;
    Ed.edContacterBack.Visible := True;
    Ed.edContacterBack.Text := PeopleBackName;
    if PeopleBackName = '' then
      Ed.edContacterBack.Text := PeopleName;
  end
  else
  begin
    //грузим отделы и исполнителей
    Ed.cbPeopleBack.Visible := True;
//    LoadPeopleList(nil);
    if not ComboLocate(Ed.cbPeopleBack, PeopleBackId) then
      Ed.cbPeopleBack.ItemIndex := Ed.cbPeopleBack.Items.IndexOf(PeopleBackName);
    if Ed.cbPeopleBack.ItemIndex < 0 then
      if not ComboLocate(Ed.cbPeopleBack, PeopleId) then
        Ed.cbPeopleBack.ItemIndex := Ed.cbPeopleBack.Items.IndexOf(PeopleName);
  end;
end;

procedure TKisMapScanGiveOut.PrepareEditor(AEditor: TKisEntityEditor);
var
  Ed: TKisGivenScanEditor;
begin
  inherited;
  Ed := AEditor as TKisGivenScanEditor;
  Ed.cbOffices.OnChange := LoadPeopleList;
  Ed.RadBtnOrgs.OnClick := LoadOrgs;
  Ed.RadBtnMP.OnClick := LoadOfficesAndPeople;
  if InBack then
    PrepareEditorForBack(Ed)
  else
    PrepareEditorForGive(Ed);
end;

procedure TKisMapScanGiveOut.ReadDataFromEditor(AEditor: TKisEntityEditor);
var
  Ed: TKisGivenScanEditor;
begin
  Ed := AEditor as TKisGivenScanEditor;
  DateOfGive := Trim(Ed.edDateOfGive.Text);
  Holder := Ed.RadBtnOrgs.Checked;
  if Holder then
  begin
    PeopleId := 0;
    OfficeId := 0;
    PeopleName := Trim(Ed.edContacter.Text);
    HolderName := Trim(Ed.edOrgname.Text);
  end
  else
  begin
    OfficeId := Integer(Ed.cbOffices.Items.Objects[Ed.cbOffices.ItemIndex]);
    PeopleId := Integer(Ed.cbPeople.Items.Objects[Ed.cbPeople.ItemIndex]);
    LicensedOrgId := N_ZERO;
    HolderName := 'МКП "УГА" - ' + Ed.cbPeople.Text;
    PeopleName := Ed.cbPeople.Text;
  end;
  TermOfGive := StrToInt(Trim(Ed.edTermOfGive.Text));
  DateOfBack := Trim(Ed.edDateOfBack.Text);
  DefinitionNumber := Trim(Ed.edDefinitionNumber.Text);
  OrderNumber := Trim(Ed.edOrderNumber.Text);
  Address := Trim(Ed.edAddress.Text);
  PersonWhoGiveId := Integer(Ed.cbPersonWhoGive.Items.Objects[Ed.cbPersonWhoGive.ItemIndex]);
  PersonWhoGive := Trim(Ed.cbPersonWhoGive.Text);
  if FInBack then
  begin
    PersonWhoTakedBackId := Integer(Ed.cbWhoTakedBack.Items.Objects[Ed.cbWhoTakedBack.ItemIndex]);
    PersonWhoTakedBack := Trim(Ed.cbWhoTakedBack.Text);
    if Holder then
    begin
      PeopleBackId := 0;
      PeopleBackName := Trim(Ed.edContacterBack.Text);
    end
    else
    begin
      PeopleBackId := Integer(Ed.cbPeopleBack.Items.Objects[Ed.cbPeopleBack.ItemIndex]);
      PeopleBackName := Ed.cbPeopleBack.Text;
    end;
  end;
  FCloseAfterGive := Ed.CheckBox1.Visible and Ed.CheckBox1.Checked;
end;

procedure TKisMapScanGiveOut.SetAddress(const Value: String);
begin
  if FAddress <> Value then
  begin
    FAddress := Value;
    Modified := True;
  end;
end;

procedure TKisMapScanGiveOut.SetAnnulled(const Value: Boolean);
begin
  if FAnnulled <> Value then
  begin
    FAnnulled := Value;
    Modified := True;
  end;
end;

procedure TKisMapScanGiveOut.SetDateOfBack(const Value: String);
begin
  if FDateOfBack <> Value then
  begin
    FDateOfBack := Value;
    Modified := True;
  end;
end;

procedure TKisMapScanGiveOut.SetDateOfGive(const Value: String);
begin
  if FDateOfGive <> Value then
  begin
    FDateOfGive := Value;
    Modified := True;
  end;
end;

procedure TKisMapScanGiveOut.SetDefinitionNumber(const Value: String);
begin
  if FDefinitionNumber <> Value then
  begin
    FDefinitionNumber := Value;
    Modified := True;
  end;
end;

procedure TKisMapScanGiveOut.SetFileId(const Value: string);
begin
  if FFileId <> Value then
  begin
    FFileId := Value;
    Modified := True;
  end;
end;

procedure TKisMapScanGiveOut.SetHolder(const Value: Boolean);
begin
  if FHolder <> Value then
  begin
    FHolder := Value;
    Modified := True;
  end;
end;

procedure TKisMapScanGiveOut.SetHolderName(const Value: String);
begin
  if FHolderName <> Value then
  begin
    FHolderName := Value;
    Modified := True;
  end;
end;

procedure TKisMapScanGiveOut.SetOrderNumber(const Value: String);
begin
  if FOrderNumber <> Value then
  begin
    FOrderNumber := Value;
    Modified := True;
  end;
end;

procedure TKisMapScanGiveOut.SetOrdersId(const Value: Integer);
begin
  if FOrdersId <> Value then
  begin
    FOrdersId := Value;
    Modified := True;
  end;
end;

procedure TKisMapScanGiveOut.SetLicensedOrgId(const Value: Integer);
begin
  if FLicensedOrgId <> Value then
  begin
    FLicensedOrgId := Value;
    Modified := True;
  end;
end;

procedure TKisMapScanGiveOut.SetMD5New(const Value: String);
begin
  if FMD5New <> Value then
  begin
    FMD5New := Value;
    Modified := True;
  end;
end;

procedure TKisMapScanGiveOut.SetMD5Old(const Value: String);
begin
  if FMD5Old <> Value then
  begin
    FMD5Old := Value;
    Modified := True;
  end;
end;

procedure TKisMapScanGiveOut.SetPeopleBackId(const Value: Integer);
begin
  if FPeopleBackId <> Value then
  begin
    FPeopleBackId := Value;
    Modified := True;
  end;
end;

procedure TKisMapScanGiveOut.SetPeopleBackName(const Value: String);
begin
  if FPeopleBackName <> Value then
  begin
    FPeopleBackName := Value;
    Modified := True;
  end;
end;

procedure TKisMapScanGiveOut.SetPeopleId(const Value: Integer);
begin
  if FPeopleId <> Value then
  begin
    FPeopleId := Value;
    Modified := True;
  end;
end;

procedure TKisMapScanGiveOut.SetPersonWhoGiveId(const Value: Integer);
begin
  if FPersonWhoGiveId <> Value then
  begin
    FPersonWhoGiveId := Value;
    Modified := True;
  end;
end;

procedure TKisMapScanGiveOut.SetPersonWhoTakedBack(const Value: String);
begin
  if FPersonWhoTakedBack <> Value then
  begin
    FPersonWhoTakedBack := Value;
    Modified := True;
  end;
end;

procedure TKisMapScanGiveOut.SetPersonWhoTakedBackId(const Value: Integer);
begin
  if FPersonWhoTakedBackId <> Value then
  begin
    FPersonWhoTakedBackId := Value;
    Modified := True;
  end;
end;

procedure TKisMapScanGiveOut.SetScanOrderMapId(const Value: Integer);
begin
  if FScanOrderMapId <> Value then
  begin
    FScanOrderMapId := Value;
    Modified := True;
  end;
end;

procedure TKisMapScanGiveOut.SetSquares(const Value: string);
begin
  if FSquares <> Value then
  begin
    FSquares := Value;
    Modified := True;
  end;
end;

procedure TKisMapScanGiveOut.SetTermOfGive(const Value: Integer);
begin
  if FTermOfGive <> Value then
  begin
    FTermOfGive := Value;
    Modified := True;
  end;
end;


procedure TKisMapScansMngr.SetOrderId(Ent: TKisMapScanGiveOut);
var
  Conn: IKisConnection;
  OffId: Integer;
begin
  Conn := GetConnection(True, True);
  if not Ent.Holder then
  begin
    if FindOfficeId(Ent, OffId) then
       Ent.OfficeId := OffId;
    with Conn.GetDataSet(Format(SQ_FIND_ORDER, [Ent.OfficeId, Ent.OrderNumber])) do
    try
      Open;
      Ent.OrdersId := FieldByName(SF_ID).AsInteger;
      Close;
    finally
      FreeConnection(Conn, True);
    end;
  end;
end;

procedure TKisMapScansMngr.TakeBackList;
var
  Conn: IKisConnection;
  I: Integer;
  Template, Gout: TKisMapScanGiveOut;
  TheOrder: TKisScanOrder;
  Nomen, MD5Hash: string;
  TheScan: TKisMapScan;
  Map: TKisScanOrderMap;
begin
  // TODO: надо сначала подготовить список файлов, попытаться залить его, а потом уже сохранять объекты в Бд
  if Assigned(anOrder) then
  begin
    TheOrder := anOrder as TKisScanOrder;
    Template := nil;
    Conn := GetConnection(True, True, True);
    try
      // показываем окно с параметрами
      // Номенклатура первого скана в заявке
      Nomen := Scans[0].Nomenclature;
      TheScan := FindScan(Conn, Nomen);
      TheScan.Forget;
      Map := TheOrder.FindMap(Nomen);
      Template := TheScan.FindGiveOut(Map.ID, True);
      if TheScan.TakeBack(Template, Scans[0].MD5HashNew) then
      begin
        try
          Template.FileOperationId := CreateClassID;
          Scans[0].FileOpId := Template.FileOperationId;
          // обновляем сущности-сканы в БД
          theMapScansStorage.UploadDBFile(AppModule, Scans[0]);
          if Scans[0].MD5HashOld = Scans[0].MD5HashNew then
          begin
            Template.FileOperationId := S_FILEOP_NO_CHANGES;
            Scans[0].FileOpId := S_FILEOP_NO_CHANGES;
          end;
          AddReportLine(True, TheScan.Nomenclature, 'Успешно скопирован!', Scans[0].AsText(True));
          if (sfsDiffZone in Scans[0].State) {and (Scans[0].MD5HashOld <> Scans[0].MD5HashNew)} then
          begin
            TheScan.AddHistoryFromGiveOut(Template);
          end;
          //
          SaveEntity(TheScan);
        except
          on E: Exception do
          begin
//            Jcl
            AddReportLine(False, TheScan.Nomenclature,
              'Ошибка при сохранении планшета! ' + E.Message,
              Scans[0].AsText(True) + sLineBreak +
              'Стек вызовов: ' + sLineBreak + GetDebugString);
            Scans[0].AddLogLine('Ошибка: ' + E.Message);
          end;
        end;
        //
        for I := 1 to Pred(Length(Scans)) do
        try
          Nomen := Scans[I].Nomenclature;
          TheScan := FindScan(Conn, Nomen);
          TheScan.Forget;
          if not Assigned(TheScan) then
            raise EKisException.Create('Скан планшета ' + Nomen + ' не обнаружен в базе данных!');
          //
          Map := TheOrder.FindMap(Nomen);
          Gout := TheScan.FindGiveOut(Map.ID, True);
          TheScan.TakeBackSilent(Gout, Template);
          if sfsDiffZone in Scans[I].State then
          begin
            if not (sfsHashDiff in Scans[I].State) then
              Scans[I].PrepareHash(sfkDiff);
            Gout.MD5New := Scans[I].MD5HashDiff;
          end
          else
          begin
            if not (sfsHashNew in Scans[I].State) then
              Scans[I].PrepareHash(sfkUpload);
            Gout.MD5New := Scans[I].MD5HashNew;
          end;
          Gout.FileOperationId := CreateClassID;
          Scans[I].FileOpId := Gout.FileOperationId;
          //
          theMapScansStorage.UploadDBFile(AppModule, Scans[I]);
          AddReportLine(True, TheScan.Nomenclature, 'Успешно скопирован!', Scans[I].AsText(True));
          // если сделали миниатюру зоны изменений, то надо добавить
          if (sfsDiffZone in Scans[I].State) {and (Scans[I].MD5HashOld <> Scans[I].MD5HashNew)}then
          begin
            TheScan.AddHistoryFromGiveOut(Gout);
          end;
          //
          SaveEntity(TheScan);
        except
          on E: Exception do
          begin
            AddReportLine(False, TheScan.Nomenclature,
              'Ошибка при сохранении планшета! ' + E.Message,
              Scans[I].AsText(True) + sLineBreak +
              'Стек вызовов: ' + sLineBreak + GetDebugString);
            Scans[I].AddLogLine('Ошибка: ' + E.Message);
          end;
        end;
      end
      else
        Template := nil;
    finally
      // если есть ошибки, то откатываем изменения и показываем отчёт
      FreeConnection(Conn, not FReport.ContainsError);
      LogTakeBackReport(TheOrder, Scans);
      // показываем отчёт
      if FReport.ContainsError then
      begin
        if not Assigned(KisFileReportForm) then
          KisFileReportForm := TKisFileReportForm.Create(Application);
        KisFileReportForm.Caption := 'Приём планшетов';
        KisFileReportForm.Execute(FReport);
        AppModule.LogError('Ошибка при приёме файлов!', '', '',
          'TKisMapScansMngr.TakeBackList', AppModule.GetAppInfo,
          FReport.AsStrings(True));
      end
      else
      begin
        if Assigned(Template) then // заявка была обработана
        begin
          FScansPrintTable.Clear;
          for I := 0 to Length(Scans) - 1 do
          begin
            if sfsDiffZone in Scans[I].State then
              MD5Hash := Scans[I].MD5HashDiff
            else
              MD5Hash := Scans[I].MD5HashNew;
            FScansPrintTable.Add(Scans[I].Nomenclature + '=' + MD5Hash);
          end;
          // печать акта приёма
          PrintAct('Акт-приемка.frf', TheOrder, Template, Template.PersonWhoTakedBackId,
            Template.PeopleBackId, IfThen(Template.Holder, Template.PeopleBackName));
        end;
        // обновляем данные на экране
        SafeReopen(dsMapScans, SF_ID);
        //
        if Assigned(TheOrder) then
          SafeReopen(dsOrdersTakeBack, SF_ID);
      end;
    end;
  end;
end;

procedure TKisMapScansMngr.UploadHistoryFile(aScan: TKisMapScan);
begin
  if aScan.NewFormularImage then
  begin
    theMapScansStorage.UploadHistoryFile(AppModule, aScan.Nomenclature, aScan.HistoryFile);
    aScan.HistoryFile := ExtractFileName(theMapScansStorage.GetFileName(AppModule, aScan.Nomenclature, sfnFormular));
  end;
end;

procedure TKisMapScansMngr.WriteOrderState;
begin
  inherited WriteOrderState(Helper);
  inherited WriteOrderState(FGiveOutsHelper, 'SortOrder_GO');
  inherited WriteOrderState(FTakeBacksHelper, 'SortOrder_TB');
end;

procedure TKisMapScanGiveOut.LoadPeopleList(Sender: TObject);
var
  P: Integer;
begin
  with MyEditor do
  begin
    if cbOffices.ItemIndex < 0 then
      cbPeople.Items.Clear
    else
    begin
      cbPeople.Text := '';
      P := Integer(cbOffices.Items.Objects[cbOffices.ItemIndex]);
      cbPeople.Items := IStringList(AppModule.PeolpeList(P)).StringList;
      cbPeopleBack.Items.Assign(cbPeople.Items);
    end;
  end;
end;

procedure TKisMapScanGiveOut.SetOfficeId(const Value: Integer);
begin
  if FOfficeId <> Value then
  begin
    FOfficeId := Value;
    Modified := True;
  end;
end;

procedure TKisMapScanGiveOut.LoadOfficesAndPeople(Sender: TObject);
begin
  with MyEditor do
  begin
    if RadBtnMP.Checked then
    begin
      //грузим отделы и исполнителей
      cbPeople.Visible := true;
      cbOffices.Visible := True;
      cbOffices.Items := IStringList(AppModule.Lists[klOffices]).StringList;
      cbOffices.ItemIndex := OfficeId;
      ComboLocate(cbOffices, OfficeId);
      edContacter.Visible := False;
      btnSelectOrg.Visible := False;
      edOrgname.Visible := False;
      //
      Label4.Caption := 'Отдел';
      Label5.Caption := 'Исполнитель';
    end;
  end;
end;

procedure TKisMapScanGiveOut.LoadOrgs(Sender: TObject);
begin
  with MyEditor do
  begin
    if RadBtnOrgs.Checked then
    begin
      //грузим сторониие организации
      RadBtnMP.Checked := false;
      cbPeople.Visible := false;
      cbOffices.Visible := False;
      edOrgname.Visible := True;
      edContacter.Visible := True;
      btnSelectOrg.Visible := True;
      //
      Label4.Caption := 'Наименование';
      Label5.Caption := 'Контактное лицо';
    end;
  end;
end;

procedure TKisMapScanGiveOut.SetPeopleName(const Value: String);
begin
  if FPeopleName <> Value then
  begin
    FPeopleName := Value;
    Modified := True;
  end;
end;

procedure TKisMapScanGiveOut.SetPersonWhoGive(const Value: String);
begin
  if FPersonWhoGive <> Value then
  begin
    FPersonWhoGive := Value;
    Modified := True;
  end;
end;

procedure TKisMapScanGiveOut.PrepareEditorForBack(AEditor: TKisGivenScanEditor);
begin
  AEditor.gbGive.Enabled := False;
  AEditor.edDateOfGive.Color := clBtnFace;
  AEditor.cbPersonWhoGive.Color := clBtnFace;
  AEditor.edTermOfGive.Color := clBtnFace;
  AEditor.gbSender.Enabled := False;
  AEditor.edOrgname.Color := clBtnFace;
  AEditor.cbPeople.Color := clBtnFace;
  AEditor.RadBtnOrgs.Color := clBtnFace;
  AEditor.RadBtnMP.Color := clBtnFace;
  AEditor.edAddress.Color := clBtnFace;
  AEditor.edDefinitionNumber.Color := clBtnFace;
  AEditor.edOrderNumber.Color := clBtnFace;
  AEditor.RadBtnOrgs.Color := clbtnFace;
  AEditor.RadBtnMP.Color := clBtnFace;
  AEditor.gbBack.Enabled := True;
  AEditor.CheckBox1.Visible := False;
end;

procedure TKisMapScanGiveOut.PrepareEditorForGive(AEditor: TKisGivenScanEditor);
begin
  AEditor.gbBack.Visible := False;
  AEditor.ClientHeight := AEditor.ClientHeight - AEditor.gbBack.Height;
  AEditor.btnSelectOrg.OnClick := SelectOrg;
  AEditor.CheckBox1.Visible := FAllowCloseOrder;
end;

constructor TKisMapScanGiveOut.Create(aMngr: TKisMngr);
begin
  inherited;
  FGivenObject := True;
  FTermOfGive := I_GIVEOUT_TERM;
end;

procedure TKisMapScanGiveOut.SelectOrg(Sender: TObject);
var
  Ent: TKisEntity;
begin
  with TKisLicensedOrgMngr(AppModule[kmLicensedOrgs]) do
  begin
    Ent := KisObject(SelectEntity).AEntity;
    if Assigned(Ent) then
    with MyEditor do
    begin
      edOrgname.Text := TKisLicensedOrg(Ent).Name;
      edContacter.Text := TKisLicensedOrg(Ent).MapperFio;
      LicensedOrgId := Ent.ID;
    end;
  end;
end;

{ TGivenMapCtrlr }

procedure TScanGiveOutsCtrlr.FillFieldDefs(FieldDefsRef: TFieldDefs);
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
    Name := SF_MAP_SCANS_ID;
  end;
  with FieldDefsRef.AddFieldDef do
  begin
    DataType := ftString;
    FieldNo := 3;
    Size := 10;
    Name := SF_DATE_OF_BACK;
  end;
  with FieldDefsRef.AddFieldDef do
  begin
    DataType := ftString;
    FieldNo := 4;
    Size := 10;
    Name := SF_DATE_OF_GIVE;
  end;
  with FieldDefsRef.AddFieldDef do
  begin
    DataType := ftString;
    FieldNo := 5;
    Size := 10;
    Name := SF_DEFINITION_NUMBER;
  end;
  with FieldDefsRef.AddFieldDef do
  begin
    DataType := ftBoolean;
    FieldNo := 6;
    Name := SF_GIVEN_OBJECT;
  end;
  with FieldDefsRef.AddFieldDef do
  begin
    DataType := ftBoolean;
    FieldNo := 7;
    Name := SF_HOLDER;
  end;
  with FieldDefsRef.AddFieldDef do
  begin
    DataType := ftString;
    FieldNo := 8;
    Size := 300;
    Name := SF_HOLDER_NAME;
  end;
  with FieldDefsRef.AddFieldDef do
  begin
    DataType := ftString;
    FieldNo := 9;
    Size := 10;
    Name := SF_ORDER_NUMBER;
  end;
  with FieldDefsRef.AddFieldDef do
  begin
    DataType := ftInteger;
    FieldNo := 10;
    Name := SF_ORDERS_ID;
  end;
  with FieldDefsRef.AddFieldDef do
  begin
    DataType := ftInteger;
    FieldNo := 11;
    Name := SF_LICENSED_ORG_ID;
  end;
  with FieldDefsRef.AddFieldDef do
  begin
    DataType := ftInteger;
    FieldNo := 12;
    Name := SF_PEOPLE_ID;
  end;
  with FieldDefsRef.AddFieldDef do
  begin
    DataType := ftString;
    FieldNo := 13;
    Size := 78;
    Name := SF_PERSON_WHO_GIVE;
  end;
  with FieldDefsRef.AddFieldDef do
  begin
    DataType := ftInteger;
    FieldNo := 14;
    Name := SF_PERSON_WHO_GIVE_ID;
  end;
  with FieldDefsRef.AddFieldDef do
  begin
    DataType := ftInteger;
    FieldNo := 15;
    Name := SF_TERM_OF_GIVE;
  end;
  with FieldDefsRef.AddFieldDef do
  begin
    DataType := ftString;
    FieldNo := 16;
    Size := 400;
    Name := SF_ADDRESS;
  end;
  with FieldDefsRef.AddFieldDef do
  begin
    DataType := ftInteger;
    FieldNo := 17;
    Name := SF_OFFICES_ID;
  end;
  with FieldDefsRef.AddFieldDef do
  begin
    DataType := ftString;
    FieldNo := 18;
    Size := 78;
    Name := SF_PEOPLE_NAME;
  end;
  with FieldDefsRef.AddFieldDef do
  begin
    DataType := ftString;
    FieldNo := 19;
    Size := 32;
    Name := SF_MD5_OLD;
  end;
  with FieldDefsRef.AddFieldDef do
  begin
    DataType := ftString;
    FieldNo := 20;
    Size := 32;
    Name := SF_MD5_NEW;
  end;
  with FieldDefsRef.AddFieldDef do
  begin
    DataType := ftInteger;
    FieldNo := 21;
    Name := SF_PERSON_WHO_TAKED_BACK_ID;
  end;
  with FieldDefsRef.AddFieldDef do
  begin
    DataType := ftString;
    FieldNo := 22;
    Size := 78;
    Name := SF_PERSON_WHO_TAKED_BACK;
  end;
  with FieldDefsRef.AddFieldDef do
  begin
    DataType := ftInteger;
    FieldNo := 23;
    Name := SF_PEOPLE_BACK_ID;
  end;
  with FieldDefsRef.AddFieldDef do
  begin
    DataType := ftString;
    FieldNo := 24;
    Size := 78;
    Name := SF_PEOPLE_BACK_NAME;
  end;
  with FieldDefsRef.AddFieldDef do
  begin
    DataType := ftString;
    FieldNo := 25;
    Size := 50;
    Name := SF_FILE_OPERATION_ID;
  end;
  with FieldDefsRef.AddFieldDef do
  begin
    DataType := ftBoolean;
    FieldNo := 26;
    Name := SF_ANNULLED;
  end;
  with FieldDefsRef.AddFieldDef do
  begin
    DataType := ftBoolean;
    FieldNo := 27;
    Name := SF_EXPIRED;
  end;
end;

function TScanGiveOutsCtrlr.GetDeleteQueryText: String;
var
  IDList: String;
  I: Integer;
begin
  Result := SQ_DELETE_MAP_SCAN_GIVE_2;
  IDList := '';
  for I := 0 to Pred(DeletedCount) do
  begin
    if I > 0 then
      IDList := IDList + ',';
    IDList := IDList + IntToStr(DeletedElements[I].ID);
  end;
  Result := Format(Result, [IDList]);
end;

function TScanGiveOutsCtrlr.GetFieldData(Index: Integer; Field: TField;
  out Data): Boolean;
var
  Ent: TKisMapScanGiveOut;
begin
  try
    Ent := TKisMapScanGiveOut(Elements[Index]);
    case Field.FieldNo of
    1 : GetInteger(Ent.ID, Data);
    2 : GetInteger(Ent.HeadId, Data);
    3 : if Ent.DateOfBack <> '' then
          GetString(Ent.DateOfBack, Data)
        else
        begin
          Result := False;
          Exit;
        end;
    4 : if Ent.DateOfGive <> '' then
          GetString(Ent.DateOfGive, Data)
        else
        begin
          Result := False;
          Exit;
        end;
    5 : GetString(Ent.DefinitionNumber, Data);
    6 : GetBoolean(Ent.FGivenObject, Data);
    7 : GetBoolean(Ent.Holder, Data);
    8 : GetString(Ent.HolderName, Data);
    9 : GetString(Ent.OrderNumber, Data);
    10 : GetInteger(Ent.OrdersId, Data);
    11 : GetInteger(Ent.LicensedOrgId, Data);
    12 : GetInteger(Ent.PeopleId, Data);
    13 : GetString(Ent.PersonWhoGive, Data);
    14 : GetInteger(Ent.PersonWhoGiveId, Data);
    15 : GetInteger(Ent.TermOfGive, Data);
    16 : GetString(Ent.Address, Data);
    17 : GetInteger(Ent.OfficeId, Data);
    18 : GetString(Ent.PeopleName, Data);
    19 : GetString(Ent.MD5Old, Data);
    20 : GetString(Ent.MD5New, Data);
    21 : GetInteger(Ent.PersonWhoTakedBackId, Data);
    22 : GetString(Ent.PersonWhoTakedBack, Data);
    23 : GetInteger(Ent.PeopleBackId, Data);
    24 : GetString(Ent.PeopleBackName, Data);
    25 : GetString(Ent.FileOperationId, Data);
    26 : GetBoolean(Ent.Annulled, Data);
    27 : GetBoolean(Ent.Expired, Data);
    else
      raise EDatabaseError.CreateFmt(S_FIELD_NOT_FOUND, [Field.FieldName]);
    end;
    Result := True;
  except
    Result := False;
  end;
end;

function TScanGiveOutsCtrlr.GetScans(const Index: Integer): TKisMapScanGiveOut;
begin
  Result := TKisMapScanGiveOut(Elements[Index]);
end;

function TScanGiveOutsCtrlr.GetLastHolderName: String;
begin
  Result := '';
  if Count > 0 then
    Result := TKisMapScanGiveOut(Elements[Pred(Count)]).HolderName;
end;

procedure TScanGiveOutsCtrlr.SetFieldData(Index: Integer; Field: TField;
  var Data);
var
  Ent: TKisMapScanGiveOut;
begin
  try
    Ent := Rows[Index];
    case Field.FieldNo of
    1 : Ent.ID := SetInteger(Data);
    3 : Ent.DateOfBack := SetString(Data);
    4 : Ent.DateOfGive := SetString(Data);
    5 : Ent.DefinitionNumber := SetString(Data);
    6 : Ent.FGivenObject := SetBoolean(Data);
    7 : Ent.Holder := SetBoolean(Data);
    8 : Ent.HolderName := SetString(Data);
    9 : Ent.OrderNumber := SetString(Data);
    10 : Ent.OrdersId := SetInteger(Data);
    11 : Ent.LicensedOrgId := SetInteger(Data);
    12 : Ent.PeopleId := SetInteger(Data);
    13 : Ent.PersonWhoGive := SetString(Data);
    14 : Ent.PersonWhoGiveId := SetInteger(Data);
    15 : Ent.TermOfGive := SetInteger(Data);
    16 : Ent.Address := SetString(Data);
    17 : Ent.OfficeId := SetInteger(Data);
    18 : Ent.PeopleName := SetString(Data);
    19 : Ent.MD5Old := SetString(Data);
    20 : Ent.MD5New := SetString(Data);
    21 : Ent.PersonWhoTakedBackId := SetInteger(Data);
    22 : Ent.PersonWhoTakedBack := SetString(Data);
    23 : Ent.PeopleBackId := SetInteger(Data);
    24 : Ent.PeopleBackName := SetString(Data);
    25 : Ent.FileOperationId := SetString(Data);
    end;
  except
  end;
end;

procedure TKisMapScansMngr.LoadFigurePoints(Conn: IKisConnection;
  aFigure: TKisMapScanHistoryFigure);
var
  Ds: TDataSet;
begin
  Ds := Conn.GetDataSet(Format(SQ_GET_MAP_SCAN_FIGURE_POINTS, [aFigure.ID]));
  Ds.Open;
  while not Ds.Eof do
  begin
    aFigure.AddPoint(Ds.FieldByName(SF_X).AsInteger, Ds.FieldByName(SF_Y).AsInteger);
    Ds.Next;
  end;
  Ds.Close;
end;

procedure TKisMapScansMngr.LoadFigures(Conn: IKisConnection;
  aHistory: TKisMapScanHistoryElement);
var
  Ds: TDataSet;
  aFigure: TKisMapScanHistoryFigure;
begin
  Ds := Conn.GetDataSet(Format(SQ_GET_MAP_SCAN_FIGURES, [aHistory.ID]));
  Ds.Open;
  while not Ds.Eof do
  begin
    aFigure := GetEntity(Ds.FieldByName(SF_ID).AsInteger, keMapScanHistoryFigure) as TKisMapScanHistoryFigure;
    aHistory.AddFigure(aFigure);
    Ds.Next;
  end;
  Ds.Close;
end;

procedure TKisMapScansMngr.Locate(AId: Integer; LocateFail: Boolean);
begin
  inherited;
  dsMapScans.DisableControls;
  try
    dsMapScans.Locate(SF_ID, AId, []);
  finally
    dsMapScans.EnableControls;
  end;
end;

procedure TKisMapScansMngr.LogTakeBackReport;
var
  Conn: IKisConnection;
  Query: TIBQuery;
  I: Integer;
begin
  if Length(Scans) = 0 then
    Exit;
  Conn := GetConnection(True, True, True);
  Query := TIBQuery.Create(Self);
  Query.Forget;
  try
    Query.BufferChunks := 10;
    Query.Transaction := Conn.Transaction;
    Query.SQL.Text := SQ_SAVE_FILE_REPORT;
    for I := Low(Scans) to High(Scans) do
    begin
      Query.Params[0].AsInteger := anOrder.ID;
      Query.Params[1].AsString := anOrder.OrderNumber;
      Query.Params[2].AsString := anOrder.OrderDate;
      Query.Params[3].AsString := Scans[I].Nomenclature;
      Query.Params[4].AsString := Scans[I].FullFileName;
      Query.Params[5].AsString := Scans[I].DBFileName;
      Query.Params[6].AsString := Scans[I].ComparedFileName;
      Query.Params[7].AsString := Scans[I].MD5HashOld;
      Query.Params[8].AsString := Scans[I].MD5HashNew;
      Query.Params[9].AsString := Scans[I].MD5HashDiff;
      Query.Params[10].AsString := Scans[I].FileOpId;
      Query.Params[11].AsString := Scans[I].StateAsText;
      Query.Params[12].AsString := Scans[I].AsText(True);
      Query.ExecSQL;
    end;
    FreeConnection(Conn, True);
  except
    FreeConnection(Conn, False);
  end;
end;

procedure TKisMapScansMngr.OrderTakeBackGridDblClick(Sender: TObject);
begin
  if Assigned(FView) then
  with FView as TKisMapScansView do
    acTakeBackOrder.Execute;
end;

procedure TKisMapScansMngr.SaveGiveOut;
var
  Conn: IKisConnection;
  DataSet: TDataSet;
  Query: TIBQuery;
begin
  Conn := GetConnection(True, True);
  Query := TIBQuery.Create(Self);
  Query.Forget;
  with Query do
  try
    SetOrderId(GiveOut);
    Transaction := Conn.Transaction;
    BufferChunks := 10;
    SQL.Text := SQ_SAVE_MAP_SCAN_GIVEOUT;
    if GiveOut.ID < 1 then
      GiveOut.ID := GenEntityID(keMapScanGiveOut);
    with GiveOut do
    begin
      Params[0].AsInteger := ID;
      Params[1].AsInteger := HeadId;
      Params[2].AsString := DateOfBack;
      Params[3].AsString := DateOfGive;
      Params[4].AsString := DefinitionNumber;
      Params[5].AsInteger := Integer(FGivenObject);
      Params[6].AsInteger := Integer(Holder);
      Params[7].AsString := HolderName;
      Params[8].AsString := OrderNumber;
      if OrdersId > 0 then
        Params[9].AsInteger := OrdersId
      else
        Params[9].Clear;
      Params[10].AsInteger := LicensedOrgId;
      Params[11].AsInteger := PeopleId;
      Params[12].AsInteger := PersonWhoGiveId;
      Params[13].AsInteger := TermOfGive;
      Params[14].AsString := Address;
      Params[15].AsInteger := OfficeId;
      Params[16].AsString := MD5Old;
      Params[17].AsString := MD5New;
      Params[18].AsInteger := PersonWhoTakedBackId;
      Params[19].AsString := FileOperationId;
      Params[20].AsString := PeopleName;
      Params[21].AsString := PeopleBackName;
      Params[22].AsInteger := PeopleBackId;
    end;
    ExecSQL;
    //
    if GiveOut.ScanOrderMapId > 0 then
    begin
      DataSet := Conn.GetDataSet(SQ_UPDATE_MAP_SCAN_GIVEOUT_SCAN_ORDER_ID);
      Conn.SetParam(DataSet, SF_ID, GiveOut.Id);
      Conn.SetParam(DataSet, SF_SCAN_ORDER_MAPS_ID, GiveOut.ScanOrderMapId);
      DataSet.Open;
    end;
    FreeConnection(Conn, True);
  except
    FreeConnection(Conn, False);
    raise;
  end;
end;

procedure TKisMapScansMngr.SaveHistory(aHistory: TKisMapScanHistoryElement);
var
  Conn: IKisConnection;
  Ds: TDataSet;
  I: Integer;
begin
  Conn := GetConnection(True, True);
  Ds := Conn.GetDataSet(SQ_SAVE_MAP_SCAN_HISTORY);
  try
    if aHistory.ID < 1 then
      aHistory.ID := Self.GenEntityID(keMapScanHistoryElement);
    Conn.SetParam(Ds, SF_ID, aHistory.ID);
    Conn.SetParam(Ds, SF_MAP_SCANS_ID, aHistory.HeadId);
    Conn.SetParam(Ds, SF_CHIEF, aHistory.Chief);
    Conn.SetParam(Ds, SF_CURRENT_CHANGES_MAPPING, aHistory.CurrentChangesMapping);
    Conn.SetParam(Ds, SF_DATE_OF_ACCEPT, aHistory.DateOfAccept);
    Conn.SetParam(Ds, SF_DATE_OF_WORKS, aHistory.DateOfWorks);
    Conn.SetParam(Ds, SF_DRAFT_WORKS_EXECUTOR, aHistory.DraftWorksExecutor);
    Conn.SetParam(Ds, SF_ENGIN_NET_MAPPING, aHistory.EnginNetMapping);
    Conn.SetParam(Ds, SF_HIGH_RISE_MAPPING, aHistory.HighRiseMapping);
    Conn.SetParam(Ds, SF_HORIZONTAL_MAPPING, aHistory.HorizontalMapping);
    Conn.SetParam(Ds, SF_MENS_MAPPING, aHistory.MensMapping);
    Conn.SetParam(Ds, SF_NEWLY_BUILDING_MAPPING, aHistory.NewlyBuildingMapping);
    Conn.SetParam(Ds, SF_ORDER_NUMBER, aHistory.OrderNumber);
    Conn.SetParam(Ds, SF_TACHEOMETRIC_MAPPING, aHistory.TacheometricMapping);
    Conn.SetParam(Ds, SF_TOTAL_SUM, aHistory.TotalSum);
    Conn.SetParam(Ds, SF_WORKS_EXECUTOR, aHistory.WorksExecutor);
    Conn.SetParam(Ds, SF_FILE_OPERATION_ID, aHistory.FileOpId);
    Ds.Open;
    //
    for I := 0 to aHistory.FigureCount - 1 do
      SaveFigure(Conn, aHistory.Figures[I]);
  finally
    FreeConnection(Conn, True);
  end;
end;

procedure TKisMapScansMngr.SaveMapScan(MapScan: TKisMapScan);
var
  I: Integer;
  Conn: IKisConnection;
  DataSet: TDataSet;
begin
  Conn := GetConnection(True, True);
  try
    UploadHistoryFile(MapScan);
    //
    DataSet := Conn.GetDataSet(SQ_SAVE_MAP_SCAN);
    if MapScan.ID < 1 then
      MapScan.ID := Self.GenEntityID(keMapScan);
    Conn.SetParam(DataSet, SF_ID, MapScan.ID);
    Conn.SetParam(DataSet, SF_NOMENCLATURE, MapScan.Nomenclature);
    Conn.SetParam(DataSet, SF_START_DATE, MapScan.StartDate);
    Conn.SetParam(DataSet, SF_IS_SECRET, Integer(MapScan.Secret));
    Conn.SetParam(DataSet, SF_HISTORY_FILE, MapScan.HistoryFile);

    DataSet.Open;

    // Сохраняем список выдачи планшетов
    with MapScan.FGiveOutsCtrlr do
    begin
      for I := 1 to Count do
        if Elements[I].Modified then
          Self.SaveEntity(Elements[I]);
      for I := 0 to Pred(DeletedCount) do
        Self.DeleteEntity(DeletedElements[I]);
    end;
    //
    // Сохраняем список выдачи планшетов
    with MapScan.FMapHistoryCtrlr do
    begin
      for I := 1 to Count do
        if Elements[I].Modified then
          Self.SaveEntity(Elements[I]);
      for I := 0 to Pred(DeletedCount) do
        Self.DeleteEntity(DeletedElements[I]);
    end;
    //
    FreeConnection(Conn, True);
  except
    FreeConnection(Conn, False);
    raise;
  end;
end;

procedure TKisMapScansMngr.ScanOrdersGridDblClick(Sender: TObject);
begin
  if Assigned(FView) then
  with FView as TKisMapScansView do
    acConfirmOrder.Execute;
end;

function TKisMapScansMngr.GetRefreshSQLText: String;
begin
  Result := GetMainSQLText + ' WHERE M.ID=:ID';
end;

function TKisMapScansMngr.GetScanByNomenclature(aConnection: IKisConnection; aNomenclature: string): TKisMapScan;
var
  DsFindScan: TDataSet;
  ScanId: Integer;
begin
  DsFindScan := aConnection.GetDataSet(SQ_FIND_SCAN_BY_NOMENCLATURE);
  aConnection.SetParam(DsFindScan, SF_NOMENCLATURE, aNomenclature);
  DsFindScan.Open;
  if DsFindScan.IsEmpty then
    ScanId := -1
  else
    ScanId := DsFindScan.Fields[0].AsInteger;
  DsFindScan.Close;
  if ScanId < 0 then
    Result := nil
  else
    Result := GetEntity(ScanId, keMapScan) as TKisMapScan;
end;

function TKisMapScansMngr.GetScanIdByNomenclature(aConnection: IKisConnection; aNomenclature: string): Integer;
var
  DsFindScan: TDataSet;
begin
  DsFindScan := aConnection.GetDataSet(SQ_FIND_SCAN_BY_NOMENCLATURE);
  aConnection.SetParam(DsFindScan, SF_NOMENCLATURE, aNomenclature);
  DsFindScan.Open;
  if DsFindScan.IsEmpty then
    Result := -1
  else
    Result := DsFindScan.Fields[0].AsInteger;
  DsFindScan.Close;
end;

function TKisMapScansMngr.DownloadOrderFiles(Order: TKisScanOrder; Maps: TStrings; AfterDownload: TAfterDownloadFile): Boolean;
var
  TargetDir: string;
  Geometry: TKisMapScanGeometry;
  I: Integer;
begin
  Result := False;
  if not DefineGiveOutGeometry(Order, Geometry) then
    Exit;
  if SelectDirectory('Куда копировать?', '', TargetDir) then
  begin
    for I := 0 to Maps.Count - 1 do
    begin
      if theMapScansStorage.DownloadMap(AppModule, Geometry, Maps[I], TargetDir) then
        if Assigned(AfterDownload) then
          AfterDownload(Order, Maps[I]);
    end;
  end;
  Result := True;
end;

function TKisMapScansMngr.GiveOutOrderFiles(Order: TKisScanOrder; Template: TKisMapScanGiveOut; Scans: TList; CopyAllFiles: Boolean): Boolean;
var
  I: Integer;
  Scan: TKisMapScan;
  MapList: TStringList;
begin
  Result := False;
  MapList := TStringList.Create;
  MapList.Forget;
  //
  for I := 0 to Scans.Count - 1 do
  begin
    Scan := TKisMapScan(Scans[I]);
    MapList.Add(Scan.Nomenclature);
  end;
  //
  FGiveOutTemplate := Template;
  try
    FScansPrintTable.Clear;
    if not DownloadOrderFiles(Order, MapList, AfterDownloadGiveOutFile) then // все файлы заявки в наличии
      Exit;
  finally
    FGiveOutTemplate := nil;
  end;
  // печать акта приёма
  PrintAct(
      'Акт-выдача.frf',
      Order,
      Template,
      Template.PersonWhoGiveId,
      Template.PeopleId,
      IfThen(Template.Holder, Template.PeopleName)
  );
  Result := True;
end;

function TKisMapScansMngr.GetMainDataSet: TDataSet;
begin
  Result := dsMapScans;
end;

procedure TKisMapScansMngr.CheckMaps(aConnection: IKisConnection; Maps: TDataSet; 
  Missed: TStringList; ConsiderGivedOut, ConsiderOrder: Boolean; OrderId: Integer);
var
  DsFindScan: TDataSet;
  Nomen: string;
  NotFound, GivedOut, HasOrder, DifferentOrder, AnnulledOrder: Boolean;
  AddToMissed: Boolean;
begin
  DsFindScan := aConnection.GetDataSet(SQ_FIND_SCAN_BY_NOMENCLATURE);
  Maps.First;
  while not Maps.Eof do
  begin
    Nomen := Maps.FieldByName(SF_NOMENCLATURE).AsString;
    aConnection.SetParam(DsFindScan, SF_NOMENCLATURE, Nomen);
    DsFindScan.Open;
    //
    GivedOut := False;
    AnnulledOrder := False;
    DifferentOrder := False;
    //
    NotFound := DsFindScan.IsEmpty;
    if not NotFound then
      if ConsiderGivedOut then
      begin
        GivedOut := Boolean(DsFindScan.Fields[1].AsInteger);
        HasOrder := DsFindScan.Fields[2].AsInteger > 0;
        AnnulledOrder := HasOrder and Boolean(DsFindScan.Fields[3].AsInteger);
        if ConsiderOrder then
          DifferentOrder := DsFindScan.Fields[2].AsInteger <> OrderId;
      end;
    AddToMissed := NotFound; // скан с такой номенклатурой не найден вообще
    if not AddToMissed then
      if ConsiderGivedOut then // найден, но надо проверить состояние - выдан или нет
        if GivedOut then // выдан
        begin
          AddToMissed := not AnnulledOrder; // если заянка не аннулирована, то добавляем в отсутствующие
          if AddToMissed then // заявка не аннулирована
            if ConsiderOrder then // но надо проверить её ID
              AddToMissed := DifferentOrder; // ID совпадает - скан выдан по другой заявке, выдавать ещё раз нельзя
        end;
    if AddToMissed then
      Missed.Add(Nomen);
    DsFindScan.Close;
    //
    Maps.Next;
  end;
end;

function TKisMapScansMngr.FindOfficeId(GivenScan: TKisMapScanGiveOut;
  out OffId: Integer): Boolean;
var
  Conn: IKisConnection;
begin
  Conn := GetConnection(True, True);
  with Conn.GetDataSet(Format(SQ_FIND_OFFICE_ID, [GivenScan.PeopleId])) do
  try
    Open;
    OffId := FieldByName(SF_OFFICES_ID).AsInteger;
    Result := RecordCount > 0;
    Close;
  finally
    FreeConnection(Conn, True);
  end;
end;

function TKisMapScansMngr.FindScan(aConnection: IKisConnection; const aNomenclature: String): TKisMapScan;
var
  DsFindScan: TDataSet;
begin
  DsFindScan := aConnection.GetDataSet(SQ_FIND_SCAN_BY_NOMENCLATURE_2);
  aConnection.SetParam(DsFindScan, SF_NOMENCLATURE, aNomenclature);
  DsFindScan.Open;
  if DsFindScan.IsEmpty then
    Result := nil
  else
    Result := GetEntity(DsFindScan.Fields[0].AsInteger, keMapScan) as TKisMapScan;
  DsFindScan.Close;
end;

procedure TKisMapScansMngr.acAnnullOrderExecute(Sender: TObject);
var
  OrderId: Integer;
  Conn: IKisConnection;
  Order: TKisScanOrder;
  OrderMngr: TKisScanOrdersMngr;
begin
  inherited;
  if dsScanOrders.Active then
  if not dsScanOrders.IsEmpty then
  begin
    OrderId := dsScanOrdersID.AsInteger;
    OrderMngr := AppModule[kmScanOrders] as TKisScanOrdersMngr;
    Order := KisObject(OrderMngr.GetEntity(OrderId)).AEntity as TKisScanOrder;
    if Assigned(Order) then
    begin
      // проверяем, что все планшеты из заявки есть в наличии
      Conn := GetConnection(True, True);
      try
        Order.Annulled := True;
        OrderMngr.SaveEntity(Order);
        //
        FreeConnection(Conn, True);
      except
        on E: Exception do
        begin
          FreeConnection(Conn, False);
          Application.HandleException(E);
          raise;
        end;
      end;
      //
      if Assigned(Order) then
        RefreshDataSet(dsScanOrders);
    end;
  end;
end;

procedure TKisMapScansMngr.acConfirmOrderExecute(Sender: TObject);
var
  OrderId: Integer;
  Conn: IKisConnection;
  Scan: TKisMapScan;
  Order: TKisScanOrder;
  OrderMngr: TKisScanOrdersMngr;
  Template: TKisMapScanGiveOut;
  Nomen: string;
//  ScanIds: TList;
  MissedScans: TStringList;
  CopyAllFiles, NotInStore: Boolean;
  Scans: TObjectList;
  DoReopen: Boolean;
begin
  // Выдача планшетов по заявке
//  ScanIds := TList.Create;
//  ScanIds.Forget;
  MissedScans := TStringList.Create;
  MissedScans.Forget;
  //
  OrderId := dsScanOrdersID.AsInteger;
  OrderMngr := AppModule[kmScanOrders] as TKisScanOrdersMngr;
  Order := KisObject(OrderMngr.GetEntity(OrderId)).AEntity as TKisScanOrder;
  if Assigned(Order) then
  begin
    DoReopen := True;
    Conn := GetConnection(True, True);
    try
      // проверяем, что все планшеты из заявки есть в наличии
      CheckMaps(Conn, Order.Maps, MissedScans, True, True, OrderId);
      // проверяем что все планшеты есть в наличии
      if MissedScans.Count > 0 then
      begin
        ProcessOrderWithMissedScans(Order, MissedScans);
      end
      else
      begin
        Template := GetNewGiveOutTemplate(Order, I_GIVEOUT_TERM);
        Template.Forget;
        Template.InGive := True;
        if Template.Edit then
        begin
          NotInStore := not Order.IsAllMapsInStore();
          //
          CopyAllFiles := (not NotInStore) or
            (Application.MessageBox(
              'Часть сканов уже выдана заказчику.' + sLineBreak + sLineBreak +
              'Скопировать только те, которые не были выданы - кнопка "Да".' + sLineBreak +
              'Скопировать все сканы - выданные и невыданные - кнопка "Нет".',
              'Внимание!', MB_ICONQUESTION + MB_YESNO) = ID_NO);
          //
          Scans := TObjectList.Create;
          try
            Order.Maps.First;
            while not Order.Maps.Eof do
            begin
              Nomen := Order.MapObjects[Order.Maps.RecNo].Nomenclature;
              if CopyAllFiles or Order.MapObjects[Order.Maps.RecNo].InStore then
              begin
                Scan := GetScanByNomenclature(Conn, Nomen);
                Scans.Add(Scan);
              end;
              Order.Maps.Next;
            end;
            DoReopen := GiveOutOrderFiles(Order, Template, Scans, CopyAllFiles);
          finally
            Scans.Free;
          end;
        end;
      end;
      //
      FreeConnection(Conn, True);
    except
      on E: Exception do
      begin
        FreeConnection(Conn, False);
        Application.HandleException(E);
        raise;
      end;
    end;
    //
    if DoReopen and (MissedScans.Count = 0) then
      SafeReopen(dsMapScans, SF_ID);
    //
    if Assigned(Order) then
    begin
      SafeReopen(dsScanOrders, SF_ID);
      SafeReopen(dsOrdersTakeBack, SF_ID);
    end;
  end;
end;

procedure TKisMapScansMngr.acConfirmOrderUpdate(Sender: TObject);
begin
  inherited;
  acConfirmOrder.Enabled := dsScanOrders.Active and not dsScanOrders.IsEmpty;
  acGiveOutForView.Enabled := acConfirmOrder.Enabled;
end;

procedure TKisMapScansMngr.acDeleteUpdate(Sender: TObject);
begin
//  acDelete.Enabled := False;
//  inherited;
end;

procedure TKisMapScansMngr.acGiveOutAgainExecute(Sender: TObject);
var
  OrderId: Integer;
  Order: TKisScanOrder;
  OrderMngr: TKisScanOrdersMngr;
  MapList: TStringList;
begin
  OrderId := dsOrdersTakeBackID.AsInteger;
  OrderMngr := AppModule[kmScanOrders] as TKisScanOrdersMngr;
  Order := OrderMngr.GetEntity(OrderId) as TKisScanOrder;
  try
    if Assigned(Order) then
    begin
      MapList := TStringList.Create;
      MapList.Forget;
      Order.Maps.First;
      while not Order.Maps.Eof do
      begin
        MapList.Add(Order.Maps.FieldByName(SF_NOMENCLATURE).AsString);
        Order.Maps.Next;
      end;
      DownloadOrderFiles(Order, MapList, nil); // повторная выдача
    end;
  finally
    FreeAndNil(Order);
  end;
end;

procedure TKisMapScansMngr.acGiveOutForViewExecute(Sender: TObject);
var
  OrderId, I: Integer;
  Conn: IKisConnection;
  Order: TKisScanOrder;
  OrderMngr: TKisScanOrdersMngr;
  Template: TKisMapScanGiveOut;
  Nomen: string;
  MissedScans: TStringList;
  TheScan: TKisMapScan;
  TheGiveOut: TKisMapScanGiveOut;
  Map: TKisScanOrderMap;
  MapList: TStringList;
begin
  MissedScans := TStringList.Create;
  MissedScans.Forget;
  //
  OrderId := dsScanOrdersID.AsInteger;
  OrderMngr := AppModule[kmScanOrders] as TKisScanOrdersMngr;
  Order := KisObject(OrderMngr.GetEntity(OrderId)).AEntity as TKisScanOrder;
  if Assigned(Order) then
  begin
    // проверяем, что все планшеты из заявки есть в наличии
    Conn := GetConnection(True, True);
    try
      CheckMaps(Conn, Order.Maps, MissedScans, False, False);
      // проверяем что все планшеты есть в наличии
      if MissedScans.Count > 0 then
      begin
        TMissingScansForm.Execute(Order, MissedScans, True);
        Order := nil;
      end
      else
      begin
        Template := GetNewGiveOutTemplate(Order, 1);
        Template.Forget;
        Template.InGive := True;
        Template.AllowCloseOrder := True;
        // +новый код
        if Template.Edit then
        begin
          MapList := TStringList.Create;
          MapList.Forget;
          Order.Maps.First;
          while not Order.Maps.Eof do
          begin
            Nomen := Order.Maps.FieldByName(SF_NOMENCLATURE).AsString;
            MapList.Add(Nomen);
            Order.Maps.Next;
          end;
          FGiveOutTemplate := Template;
          try
            if DownloadOrderFiles(Order, MapList, AfterDownloadFileForView) then // выдача для просмотра (без последующего приёма)
            begin
              if Template.CloseAfterGive then
              begin
                Template.DateOfBack := DateToStr(Now);
                Template.PersonWhoTakedBackId := Template.PersonWhoGiveId;
                Template.PersonWhoTakedBack := Template.PersonWhoGive;
                for I := 0 to Pred(MapList.Count) do
                begin
                  TheScan := GetScanByNomenclature(Conn, MapList[I]);
                  TheScan.Forget;
                  TheScan.Modified := False;
                  //
                  Map := Order.FindMap(TheScan.Nomenclature);
                  //
                  TheGiveOut := TheScan.GiveOutSilent(Template);
                  TheGiveOut.MD5Old := theMapScansStorage.GetMD5Hash(AppModule, TheScan.Nomenclature);
                  TheGiveOut.ScanOrderMapId := Map.Id;
                  TheGiveOut.Modified := True;
                  //
                  TheScan.TakeBackSilent(TheGiveOut, Template);
                  TheGiveOut.MD5New := TheGiveOut.MD5Old;
                  TheGiveOut.FileOperationId := S_FILEOP_NO_RETURN;
                  //
                  TheScan.Modified := True;
                  SaveEntity(TheScan);
                end;
              end;
            end;
          finally
            FGiveOutTemplate := nil;
          end;
        end;
      end;
      //
      FreeConnection(Conn, True);
    except
      on E: Exception do
      begin
        FreeConnection(Conn, False);
        Application.HandleException(E);
        raise;
      end;
    end;
    //
    if Assigned(Order) then
    begin
      SafeReopen(dsScanOrders, SF_ID);
      SafeReopen(dsOrdersTakeBack, SF_ID);
    end;
  end;
end;

procedure TKisMapScansMngr.acGoToOrderExecute(Sender: TObject);
//var
//  OrderMngr: TKisScanOrdersMngr;
begin
  inherited;
  // Найти окно заявок
  // Если окна нет, то открываем его
  // Снова ищем окно
  // Если оно есть
  // То ищем в окне нужную заявку
//  OrderMngr := AppModule[kmScanOrders] as TKisScanOrdersMngr;
  // Это сложно сдалеть, т.к. в окне может быть включён поиск
  //OrderMngr.IsViewVisible();
end;

procedure TKisMapScansMngr.acTakeBackAsNoChangesExecute(Sender: TObject);
var
  OrderId: Integer;
  Conn: IKisConnection;
  Order: TKisScanOrder;
  OrderMngr: TKisScanOrdersMngr;
  OrderMap: TKisScanOrderMap;
  Scan: TKisMapScan;
  I: Integer;
  Gout: TKisMapScanGiveOut;
  GoutToTakeBack, ScanToTakeBack: TList;
  LoadedScans: TObjectList;
begin
  inherited;
  if dsOrdersTakeBack.Active then
  if not dsOrdersTakeBack.IsEmpty then
  begin
    OrderId := dsOrdersTakeBackID.AsInteger;
    OrderMngr := AppModule[kmScanOrders] as TKisScanOrdersMngr;
    Order := OrderMngr.GetEntity(OrderId) as TKisScanOrder;
    if Assigned(Order) then
    begin
      Order.Forget();
      GoutToTakeBack := TList.Create;
      GoutToTakeBack.Forget();
      ScanToTakeBack := TList.Create;
      ScanToTakeBack.Forget();
      LoadedScans := TObjectList.Create;
      LoadedScans.Forget();
      //
      Order.Maps.First;
      while not Order.Maps.Eof do
      begin
        // для каждого планшета из заявки
        OrderMap := Order.MapObjects[Order.Maps.RecNo];
        // выбрать скан по номенклатуре
        Conn := GetConnection(True, False);
        try
          Scan := Self.FindScan(Conn, OrderMap.Nomenclature);
          LoadedScans.Add(Scan);
        finally
          if Conn.NeedCommit then
            Conn.Commit(True)
          else
          if Conn.NeedBack then
            Conn.Rollback(True);
        end;
        // в этом скане надо выбрать открытую выдачу с совпадающим ID заявки
        I := Scan.FGiveOuts.RecordCount;
        if I > 0 then
        begin
          Gout := Scan.FGiveOutsCtrlr.Rows[I];
          if Gout.ScanOrderMapId = OrderMap.Id then
            if not Gout.Annulled then
              if Gout.DateOfBack = '' then
              begin
                GoutToTakeBack.Add(Gout);
                ScanToTakeBack.Add(Scan);
              end;
        end;
        // для этой выдачи делаем тихий возврат
        Order.Maps.Next;
      end;
      //
      if ScanToTakeBack.Count <> Order.Maps.RecordCount then
      begin
        MessageBox(Application.Handle,
          'Не все планшеты выданы!',
          'Внимание!',
          MB_OK + MB_ICONEXCLAMATION);
        Exit;
      end;
      //
      Conn := GetConnection(True, True, True);
      try
        for I := 0 to ScanToTakeBack.Count - 1 do
        begin
          Scan := TKisMapScan(ScanToTakeBack[I]);
          Scan.Modified := False;
          Gout := TKisMapScanGiveOut(GoutToTakeBack[I]);
          Gout.DateOfBack := DateToStr(Now);
          Gout.PersonWhoTakedBackId := Gout.PersonWhoGiveId;
          Gout.PersonWhoTakedBack := Gout.PersonWhoGive;
          Gout.MD5New := Gout.MD5Old;
          Gout.FileOperationId := S_FILEOP_NO_RETURN;
          Scan.Modified := True;
          SaveEntity(Scan);
        end;
        Conn.Commit(False);
        //
        RefreshDataSet(dsOrdersTakeBack);
      except
        Conn.Rollback(False);
        raise;
      end;
    end;
  end;
end;

procedure TKisMapScansMngr.acTakeBackOrderExecute(Sender: TObject);
var
  Order: TKisScanOrder;
  OrdId: Integer;
  TBFiles: TTakeBackFiles;
  I: Integer;
  Scans: TMapScanArray;
begin
  OrdId := dsOrdersTakeBackID.AsInteger;
  Order := KisObject(AppModule[kmScanOrders].GetEntity(OrdId)).AEntity as TKisScanOrder;
  //
  if not Assigned(Order) then
    AppModule.Alert('Заявка ' + dsOrdersTakeBackORDER_NUMBER.AsString + ' от ' + dsOrdersTakeBackORDER_DATE.AsString + ' не найдена')
  else
  begin
    TBFiles := TTakeBackFiles.Create;
    TBFiles.Forget;
    try
      // визуальное сравнение
      if TKisMapScanLoadForm2.Execute(Order, TBFiles, Scans) then
      begin
        FReport.Clear;
        TakeBackList(Scans, Order);
      end;
    finally
      for I := 0 to TBFiles.Count - 1 do
      try
        TFileUtils.DeleteFile(TBFiles[I].MergedFile);
      except
      end;
    end;
  end;
end;

procedure TKisMapScansMngr.acTakeBackOrderUpdate(Sender: TObject);
begin
  inherited;
  acTakeBackOrder.Enabled := dsOrdersTakeBack.Active and not dsOrdersTakeBack.IsEmpty;
  acGiveOutAgain.Enabled := acTakeBackOrder.Enabled;
end;

procedure TKisMapScansMngr.acInsertExecute(Sender: TObject);
var
  I: Integer;
  FileState: TFileState;
  Conn: IKisConnection;
  Ds: TDataSet;
  B: Boolean;
  Scan: TKisMapScan;
  GiveOut: TKisMapScanGiveOut;
  S, ErrMsg, Nomen, FileOpId: string;
  N: TNomenclature;
begin
  // Выбор файла(ов).
  OpenDialog1.Title := 'Добавляем сканы';
  OpenDialog1.Options := OpenDialog1.Options + [ofAllowMultiSelect];
  if OpenDialog1.Execute() then
  begin
    FReport.Clear;
    for I := 0 to OpenDialog1.Files.Count - 1 do
    begin
      FileOpId := '';
      Nomen := ExtractFileName(OpenDialog1.Files[I]);
      Nomen := ChangeFileExt(Nomen, '');
      S := Nomen;
      N.Init(S, True);
      if not N.Valid then
      begin
        FileState := TFileState.Create;
        FileState.FileName := OpenDialog1.Files[I];
        FileState.Status := False;
        FileState.Text := 'Неверная номенклатура планшета';
        FReport.Add(FileState);
      end
      else
      begin
        Nomen := N.Nomenclature();
        // обработка
        // 1. проверить существует ли файл - добавить в отчёт ошибку
        Conn := GetConnection(True, True, True);
        try
          Ds := Conn.GetDataSet(SQ_FIND_SCAN_BY_NOMENCLATURE_2);
          Conn.SetParam(Ds, SF_NOMENCLATURE, Nomen);
          Ds.Open;
          B := Ds.RecordCount > 0;
          Ds.Close;
          if B then
          begin
            FileState := TFileState.Create;
            FileState.FileName := OpenDialog1.Files[I];
            FileState.Status := False;
            FileState.Text := 'Такой скан уже есть в базе данных.';
            FReport.Add(FileState);
          end
          else
          begin
            // 5. скопировать файл
            try
              FileOpId := CreateClassID();
              theMapScansStorage.UploadFile(AppModule, Nomen, OpenDialog1.Files[I], FileOpId);
              B := True;
              ErrMsg := '';
            except
              on E: Exception do
              begin
                B := False;
                ErrMsg := E.Message;
              end;
            end;
            // 4. создать новый объект, заполнить поля, сохранить
            if B then
            begin
              Scan := CreateNewEntity(keMapScan) as TKisMapScan;
              Scan.Nomenclature := Nomen;
              Scan.StartDate := DateToStr(Date);
              GiveOut := CreateNewEntity(keMapScanGiveOut) as TKisMapScanGiveOut;
              GiveOut.DateOfGive := Scan.StartDate;
              GiveOut.DateOfBack := Scan.StartDate;
              GiveOut.PeopleId := AppModule.User.PeopleId;
              GiveOut.OfficeId := AppModule.User.OfficeID;
              GiveOut.MD5New := theMapScansStorage.GetMD5Hash(AppModule, Nomen);
              GiveOut.FileOperationId := FileOpId;
              GiveOut.Head := Scan;
              //
              Scan.FGiveOutsCtrlr.FList.Add(GiveOut);
              //
              SaveEntity(Scan);
            end;
            // 6. добавить в отчёт запись о сохранении
            FileState := TFileState.Create;
            FileState.FileName := OpenDialog1.Files[I];
            FileState.Status := B;
            if B then
              FileState.Text := 'OK'
            else
              FileState.Text := ErrMsg;
            FReport.Add(FileState);
          end;
          FreeConnection(Conn, True);
        except
          on E: Exception do
          begin
            FreeConnection(Conn, False);
            FileState := TFileState.Create;
            FileState.FileName := OpenDialog1.Files[I];
            FileState.Status := False;
            FileState.Text := 'Oшибка: ' + E.Message;
            FReport.Add(FileState);
          end;
        end;
      end;
    end;
    //
    SafeReopen(dsMapScans, SF_ID);
    // показываем отчёт
    if FReport.ContainsError then
    begin
      if not Assigned(KisFileReportForm) then
        KisFileReportForm := TKisFileReportForm.Create(Application);
      KisFileReportForm.Execute(FReport);
    end;
  end;
end;

procedure TKisMapScansMngr.GridCellColors(Sender: TObject; Field: TField;
  var Background, FontColor: TColor; State: TGridDrawState; var FontStyle:TFontStyles);
begin
  if Sender is TkaDBGrid then
  if (gdSelected in State) or (gdFocused in State) then
  begin
    Background := clHighlight;
    FontColor := clWindow;
  end
  else
  begin
    if dsMapScansIS_SECRET.AsInteger = 1 then
    begin
      BackGround := $CCFFCC;
    end;
    if dsMapScansANNULLED.AsInteger = 0 then
    begin
      if dsMapScansEXPIRED.AsInteger = 1 then
        BackGround := $9999FF
      else
      if dsMapScansGIVE_STATUS.AsInteger = 1 then
      begin
        BackGround := $99FFFF;
        FontColor := clNavy;
      end;
    end;
  end;
end;

procedure TKisMapScansMngr.GridGetLogicalValue(Sender: TObject; Column: TColumn;
  var Value: Boolean);
begin
  Value := Boolean(Column.Field.AsInteger);
end;

procedure TKisMapScansMngr.GridLogicalColumn(Sender: TObject; Column: TColumn;
  var IsLogical: Boolean);
begin
  IsLogical :=
    (Column.Field = dsMapScansEXPIRED) or (Column.Field = dsMapScansIS_SECRET) or
    (Column.Field = dsMapScansGIVE_STATUS);
end;

procedure TKisMapScansMngr.acLegendExecute(Sender: TObject);
begin
  inherited;
  with FView do
    Legend.ShowLegend(ClientHeight - Legend.FormHeight,
                      ClientWidth - Legend.FormWidth - 10);
end;

procedure TKisMapScansMngr.acOrderView2Execute(Sender: TObject);
var
  OrderId: Integer;
  Order: TKisScanOrder;
  OrderMngr: TKisScanOrdersMngr;
begin
  inherited;
  if dsOrdersTakeBack.Active then
  if not dsOrdersTakeBack.IsEmpty then
  begin
    OrderId := dsOrdersTakeBackID.AsInteger;
    OrderMngr := AppModule[kmScanOrders] as TKisScanOrdersMngr;
    Order := KisObject(OrderMngr.GetEntity(OrderId)).AEntity as TKisScanOrder;
    if Assigned(Order) then
    begin
      Order.ReadOnly := True;
      Order.Edit;
    end;
  end;
end;

procedure TKisMapScansMngr.acOrderViewExecute(Sender: TObject);
var
  OrderId: Integer;
  Order: TKisScanOrder;
  OrderMngr: TKisScanOrdersMngr;
begin
  inherited;
  if dsScanOrders.Active then
  if not dsScanOrders.IsEmpty then
  begin
    OrderId := dsScanOrdersID.AsInteger;
    OrderMngr := AppModule[kmScanOrders] as TKisScanOrdersMngr;
    Order := KisObject(OrderMngr.GetEntity(OrderId)).AEntity as TKisScanOrder;
    if Assigned(Order) then
    begin
      Order.ReadOnly := True;
      Order.Edit;
    end;
  end;
end;

procedure TKisMapScansMngr.acPrintExecute(Sender: TObject);
begin
  inherited;
  with PrintModule do
  begin
    ReportFile := AppModule.ReportsPath + 'КГО\Сканы_с_экрана.frf';
    ReportTitle := 'Список сканированных планшетов';
    SetMasterDataSet(dsMapScans, 'MasterData');
    PrintReport;
  end;
end;

procedure TKisMapScansMngr.acRefreshOrdersExecute(Sender: TObject);
begin
  inherited;
  SafeReopen(dsScanOrders, '');
end;

procedure TKisMapScansMngr.acRefreshTakeBackExecute(Sender: TObject);
begin
  inherited;
  SafeReopen(dsOrdersTakeBack, '');
end;

procedure TKisMapScansMngr.acSortGiveOutsExecute(Sender: TObject);
begin
  inherited;
  if FGiveOutsHelper.SortDialog then
    SafeReopen(dsScanOrders, SF_ID);
end;

procedure TKisMapScansMngr.acSortTakeBacksExecute(Sender: TObject);
begin
  inherited;
  if FTakeBacksHelper.SortDialog then
    SafeReopen(dsOrdersTakeBack, SF_ID);
end;

{ TKisMapScanHistoryElement }

procedure TKisMapScanHistoryElement.Copy(Source: TKisEntity);
begin
  inherited;
  FScanId := TKisMapScanHistoryElement(Source).FScanId;
  FFileOpId := TKisMapScanHistoryElement(Source).FFileOpId;
end;

function TKisMapScanHistoryElement.CreateFigureInstance: TKisMapHistoryFigure;
begin
  Result := TKisMapScanHistoryFigure.Create(Manager);
end;

class function TKisMapScanHistoryElement.EntityName: String;
begin
  Result := 'Строка формуляра планшета';
end;

procedure TKisMapScanHistoryElement.Load(DataSet: TDataSet);
begin
  inherited;
  FScanId := DataSet.FieldByName(SF_MAP_SCANS_ID).AsInteger;
  FFileOpId := DataSet.FieldByName(SF_FILE_OPERATION_ID).AsString;
end;

procedure TKisMapScanHistoryElement.SetFileOpId(const Value: string);
begin
  if FFileOpId <> Value then
  begin
    FFileOpId := Value;
    Modified := True;
  end;
end;

procedure TKisMapScanHistoryElement.SetScanId(const Value: Integer);
begin
  if FScanId <> Value then
  begin
    FScanId := Value;
    Modified := True;
  end;
end;

{ TMapScanHistoryCtrlr }

procedure TMapScanHistoryCtrlr.FillFieldDefs(FieldDefsRef: TFieldDefs);
begin
  inherited;
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
    Name := SF_MAP_SCANS_ID;
  end;
  with FieldDefsRef.AddFieldDef do
  begin
    DataType := ftString;
    FieldNo := 3;
    Size := 100;
    Name := SF_CHIEF;
  end;
  with FieldDefsRef.AddFieldDef do
  begin
    DataType := ftString;
    FieldNo := 4;
    Size := 20;
    Name := SF_CURRENT_CHANGES_MAPPING;
  end;
  with FieldDefsRef.AddFieldDef do
  begin
    DataType := ftString;
    FieldNo := 5;
    Size := 10;
    Name := SF_DATE_OF_ACCEPT;
  end;
  with FieldDefsRef.AddFieldDef do
  begin
    DataType := ftString;
    FieldNo := 6;
    Size := 10;
    Name := SF_DATE_OF_WORKS;
  end;
  with FieldDefsRef.AddFieldDef do
  begin
    DataType := ftString;
    FieldNo := 7;
    Size := 100;
    Name := SF_DRAFT_WORKS_EXECUTOR;
  end;
  with FieldDefsRef.AddFieldDef do
  begin
    DataType := ftString;
    FieldNo := 8;
    Size := 20;
    Name := SF_ENGIN_NET_MAPPING;
  end;
  with FieldDefsRef.AddFieldDef do
  begin
    DataType := ftString;
    FieldNo := 9;
    Size := 20;
    Name := SF_HIGH_RISE_MAPPING;
  end;
  with FieldDefsRef.AddFieldDef do
  begin
    DataType := ftString;
    FieldNo := 10;
    Size := 20;
    Name := SF_HORIZONTAL_MAPPING;
  end;
  with FieldDefsRef.AddFieldDef do
  begin
    DataType := ftString;
    FieldNo := 11;
    Size := 20;
    Name := SF_MENS_MAPPING;
  end;
  with FieldDefsRef.AddFieldDef do
  begin
    DataType := ftString;
    FieldNo := 12;
    Size := 20;
    Name := SF_NEWLY_BUILDING_MAPPING;
  end;
  with FieldDefsRef.AddFieldDef do
  begin
    DataType := ftString;
    FieldNo := 13;
    Size := 10;
    Name := SF_ORDER_NUMBER;
  end;
  with FieldDefsRef.AddFieldDef do
  begin
    DataType := ftString;
    FieldNo := 14;
    Size := 20;
    Name := SF_TACHEOMETRIC_MAPPING;
  end;
  with FieldDefsRef.AddFieldDef do
  begin
    DataType := ftString;
    FieldNo := 15;
    Size := 20;
    Name := SF_TOTAL_SUM;
  end;
  with FieldDefsRef.AddFieldDef do
  begin
    DataType := ftString;
    FieldNo := 16;
    Size := 100;
    Name := SF_WORKS_EXECUTOR;
  end;
  with FieldDefsRef.AddFieldDef do
  begin
    DataType := ftString;
    FieldNo := 17;
    Size := 50;
    Name := SF_FILE_OPERATION_ID;
  end;
end;

function TMapScanHistoryCtrlr.GetDeleteQueryText: String;
var
  IDList: String;
  I: Integer;
begin
  Result := SQ_DELETE_MAP_SCAN_HISTORY_2;
  IDList := '';
  for I := 0 to Pred(DeletedCount) do
  begin
    if I > 0 then
      IDList := IDList + ',';
    IDList := IDList + IntToStr(DeletedElements[I].ID);
  end;
  Result := Format(Result, [IDList]);
end;

function TMapScanHistoryCtrlr.GetFieldData(Index: Integer; Field: TField;
  out Data): Boolean;
var
  Ent: TKisMapScanHistoryElement;
begin
  try
    Ent := TKisMapScanHistoryElement(Elements[Index]);
    case Field.FieldNo of
    1 : GetInteger(Ent.ID, Data);
    2 : GetInteger(Ent.ScanId, Data);
    3 : GetString(Ent.Chief, Data);
    4 : GetString(Ent.CurrentChangesMapping, Data);
    5 : if Ent.DateOfAccept <> '' then
          GetString(Ent.DateOfAccept, Data)
        else
        begin
          Result := False;
          Exit;
        end;
    6 : if Ent.DateOfWorks <> '' then
          GetString(Ent.DateOfWorks, Data)
        else
        begin
          Result := False;
          Exit;
        end;
    7 : GetString(Ent.DraftWorksExecutor, Data);
    8 : GetString(Ent.EnginNetMapping, Data);
    9 : GetString(Ent.HighRiseMapping, Data);
    10 : GetString(Ent.HorizontalMapping, Data);
    11 : GetString(Ent.MensMapping, Data);
    12 : GetString(Ent.NewlyBuildingMapping, Data);
    13 : GetString(Ent.OrderNumber, Data);
    14 : GetString(Ent.TacheometricMapping, Data);
    15 : GetString(Ent.TotalSum, Data);
    16 : GetString(Ent.WorksExecutor, Data);
    17 : GetString(Ent.FileOpId, Data);
    else
      raise EDatabaseError.CreateFmt(S_FIELD_NOT_FOUND, [Field.FieldName]);
    end;
    Result := True;
  except
    Result := False;
  end;
end;

procedure TMapScanHistoryCtrlr.SetFieldData(Index: Integer; Field: TField;
  var Data);
var
  Ent: TKisMapScanHistoryElement;
begin
  try
    Ent := TKisMapScanHistoryElement(Elements[Index]);
    case Field.FieldNo of
    1 : Ent.ID := SetInteger(Data);
    3 : Ent.Chief := SetString(Data);
    4 : Ent.CurrentChangesMapping := SetString(Data);
    5 : Ent.DateOfAccept := SetString(Data);
    6 : Ent.DateOfWorks := SetString(Data);
    7 : Ent.DraftWorksExecutor := SetString(Data);
    8 : Ent.EnginNetMapping := SetString(Data);
    9 : Ent.HighRiseMapping := SetString(Data);
    10 : Ent.HorizontalMapping := SetString(Data);
    11 : Ent.MensMapping := SetString(Data);
    12 : Ent.NewlyBuildingMapping := SetString(Data);
    13 : Ent.OrderNumber := SetString(Data);
    14 : Ent.TacheometricMapping := SetString(Data);
    15 : Ent.TotalSum := SetString(Data);
    16 : Ent.WorksExecutor := SetString(Data);
    17 : Ent.FileOpId := SetString(Data);
    end;
  except
  end;
end;

{ TKisMapScanHistoryFigure }

function TKisMapScanHistoryFigure.Clone: TKisMapHistoryFigure;
begin
  Result := TKisMapScanHistoryFigure.Create(Manager);
  Result.Copy(Self);
end;

class function TKisMapScanHistoryFigure.EntityName: String;
begin
  Result := 'Область изменения цифрового планшета';
end;

{ TKisMapScanState }

procedure TKisMapScanState.Assign(Source: TPersistent);
begin
  inherited;
  if Source is TKisMapScanState then
  begin
    FGivedOut := TKisMapScanState(Source).FGivedOut;
    FExpired := TKisMapScanState(Source).FExpired;
  end;
end;

class function TKisMapScanState.EntityName: String;
begin
  Result := 'Состояние скана планшета';
end;

procedure TKisMapScanState.Load(DataSet: TDataSet);
begin
  inherited;
  FGivedOut := DataSet.FieldByName(SF_GIVE_STATUS).AsInteger = 1;
  FExpired := DataSet.FieldByName(SF_EXPIRED).AsInteger = 1;
end;

end.
