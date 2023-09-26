{*******************************************************}
{                                                       }
{       "ИС МП УГА"                                     }
{       Менеджер по учету состояния и выдачи планшетов  }
{       из планшетохранилища                            }
{                                                       }
{                                                       }
{       Copyright (c) 2005, МП УГА                      }
{                                                       }
{       Автор: Сирота Е.А.                              }
{                                                       }
{*******************************************************}

{ Описание: реализует операции над планшетами
  Имя модуля: uKisMap500
  Версия: 0.1
  Дата изменения: 9.06.2005
  Дата последнего изменения: 16.04.2012  ed
  Цель: модуль содержит реализации классов менеджера планшетов
  Используется: AppModule
  Использует: Kernel Classes
  Исключения: нет }


unit uKisMap500;

interface

uses
  // system
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  DB, DBGrids, IBCustomDataSet, ImgList, ActnList, IBDatabase, IBQuery, ExtCtrls, Contnrs, Grids,
  // Common
  uGC, uIBXUtils, uDataSet, uVCLUtils, uDBgrid, uGeoUtils, uCommonUtils,
  // Project
  uKisSQLClasses, uKisClasses, uKisEntityEditor, uKisMapHistoryClasses;

type
  TKisGivenMap = class(TKisSQLEntity)   //факт выдачи планшета
  private
    FMap500Id: Integer;
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
    procedure SetMap500Id(const Value: Integer);
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
    procedure LoadPeopleList(Sender: TObject);
    procedure LoadOrgs(Sender: TObject);
    procedure LoadOfficesAndPeople(Sender: TObject);
    procedure PrepareEditorForGive(AEditor: TKisEntityEditor);
    procedure PrepareEditorForBack(AEditor: TKisEntityEditor);
    procedure SelectOrg(Sender: TObject);
  protected
    function CreateEditor: TKisEntityEditor; override;
    procedure PrepareEditor(AEditor: TKisEntityEditor); override;
    procedure LoadDataIntoEditor(AEditor: TKisEntityEditor); override;
    procedure ReadDataFromEditor(AEditor: TKisEntityEditor); override;
    function CheckEditor(AEditor: TKisEntityEditor): Boolean; override;
  public
    constructor Create(aMngr: TKisMngr); override;
    class function EntityName: String; override;
    procedure Copy(Source: TKisEntity); override;
    procedure Load(DataSet: TDataSet); override;
    property Map500Id: Integer read FMap500Id write SetMap500Id;
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
    property OfficeId: Integer read FOfficeId write SetOfficeId;
    property PeopleName: String read FPeopleName write SetPeopleName;

    property InBack: Boolean read FInBack write FInBack;
    property InGive: Boolean read FInGive write FInGive;
  end;

  TGivenMapCtrlr = class(TKisEntityController)
  private
    function GetGivenMaps(const Index: Integer): TKisGivenMap;
  public
    procedure FillFieldDefs(FieldDefsRef: TFieldDefs); override;
    function GetFieldData(Index: Integer; Field: TField; out Data): Boolean; override;
    procedure SetFieldData(Index: Integer; Field: TField; var Data); override;
    function GetLastHolderName: String;
    property GivenMaps[const Index: Integer]: TKisGivenMap read GetGivenMaps;
  end;

  /// <summary>
  /// Элемент истории планшета.  
  /// </summary>
  TKisMap500HistoryElement = class(TKisMapHistoryElement)
  private
    FMap500Id: Integer;
    procedure SetMap500Id(const Value: Integer);
  protected
    function CreateFigureInstance(): TKisMapHistoryFigure; override;
  public
    class function EntityName: String; override;
    procedure Copy(Source: TKisEntity); override;
    procedure Load(DataSet: TDataSet); override;
    //
    property Map500Id: Integer read FMap500Id write SetMap500Id;
  end;

  TMap500HistoryCtrlr = class(TKisEntityController)
  public
    procedure FillFieldDefs(FieldDefsRef: TFieldDefs); override;
    function GetFieldData(Index: Integer; Field: TField; out Data): Boolean; override;
    procedure SetFieldData(Index: Integer; Field: TField; var Data); override;
  end;

  TKisScanning = class(TKisVisualEntity)   //список сканирования
  private
    FMap500Id: Integer;
    FDateOfScan: String;
    FOrderNumber: String;
    FOrdersId: Integer;
    FOfficesId: Integer;
    FPeopleId: Integer;
    FWorkType: String;
    FOfficeName: String;
    FPeopleName: String;
    procedure SetMap500Id(const Value: Integer);
    procedure SetDateOfScan(const Value: String);
    procedure SetOrderNumber(const Value: String);
    procedure SetOrdersId(const Value: Integer);
    procedure SetOfficesId(const Value: Integer);
    procedure SetPeopleId(const Value: Integer);
    procedure SetWorkType(const Value: String);
    procedure SetOfficeName(const Value: String);
    procedure SetPeopleName(const Value: String);

    procedure LoadPeopleList(Sender: TObject);
  protected
    function CreateEditor: TKisEntityEditor; override;
    procedure PrepareEditor(AEditor: TKisEntityEditor); override;
    procedure LoadDataIntoEditor(AEditor: TKisEntityEditor); override;
    procedure ReadDataFromEditor(AEditor: TKisEntityEditor); override;
    function CheckEditor(AEditor: TKisEntityEditor): Boolean; override;
  public
    class function EntityName: String; override;
    procedure Copy(Source: TKisEntity); override;
    procedure Load(DataSet: TDataSet); override;
    property Map500Id: Integer read FMap500Id write SetMap500Id;
    property DateOfScan: String read FDateOfScan write SetDateOfScan;
    property OrderNumber: String read FOrderNumber write SetOrderNumber;
    property OrdersId: Integer read FOrdersId write SetOrdersId;
    property OfficesId: Integer read FOfficesId write SetOfficesId;
    property PeopleId: Integer read FPeopleId write SetPeopleId;
    property WorkType: String read FWorkType write SetWorkType;
    property OfficeName: String read FOfficeName write SetOfficeName;
    property PeopleName: String read FPeopleName write SetPeopleName;
  end;

  TScanningCtrlr = class(TKisEntityController)
  public
    procedure FillFieldDefs(FieldDefsRef: TFieldDefs); override;
    function GetFieldData(Index: Integer; Field: TField; out Data): Boolean; override;
    procedure SetFieldData(Index: Integer; Field: TField; var Data); override;
  end;

  TKisMap500 = class(TKisSQLEntity)
  private
    FGivenMapCtrlr: TGivenMapCtrlr;
    FGivenMap: TCustomDataSet;
    FMapHistoryCtrlr: TMap500HistoryCtrlr;
    FMapHistory: TCustomDataSet;
    FScanningCtrlr: TScanningCtrlr;
    FScanning: TCustomDataSet;
    FNomenclature: String;
    FOriginYear: Integer;
    FMapOriginOrg: String;
    FBasisType: String;
    FStatus: Integer;
    FSecret: Integer;
    FAnnulDate: String;
    FScanStatus: Integer;
    FNumber: String;
    FIsNew: Boolean;
    procedure SetNomenclature(const Value: String);
    procedure SetOriginYear(const Value: Integer);
    procedure SetMapOriginOrg(const Value: String);
    procedure SetBasisType(const Value: String);
    procedure SetStatus(const Value: Integer);
    procedure SetAnnulDate(const Value: String);
    procedure SetScanStatus(const Value: Integer);
    procedure SetNumber(const Value: String);

    function GetGivenMap: TDataSet;
    function GetMapHistory: TDataSet;
    function GetScanning: TDataSet;

    procedure CopyMain(Source: TKisMap500);
    procedure CopyGivenMap(Source: TKisMap500);
    procedure CopyMapHistory(Source: TKisMap500);
    procedure CopyScanning(Source: TKisMap500);

    procedure GivanMapsAfterScroll(DataSet: TDataSet);
    procedure GivenMapGiveOutHandler(Sender: TObject);
    procedure GivenMapBackHandler(Sender: TObject);
    procedure GivenMapDelete(Sender: TObject);
    procedure UpdateEditorBtns;

    procedure EditMapHistory(Sender: TObject);
    procedure MapHistoryBeforeDelete(DataSet: TDataSet);
    procedure MapHistoryInsert(DataSet: TDataSet);
    procedure MapHistoryAfterScroll(DataSet: TDataSet);

    procedure ScanningInsert(DataSet: TDataSet);
    procedure ScanningBeforeDelete(DataSet: TDataSet);
    procedure EditScanning(Sender: TObject);

    function CanGiveOut: Boolean;
    function CanGiveBack: Boolean;
    function IsNomenclatureUnique(const Value: String): Boolean;
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
    procedure Copy(Source: TKisEntity); override;
    function Equals(Entity: TKisEntity): Boolean; override;
    class function EntityName: String; override;
    function IsEmpty: Boolean; override;
    procedure Load(DataSet: TDataSet); override;
    // Выдать планшет на руки
    procedure GiveOutMap;
    function GiveBackMap: Boolean;
    property Nomenclature: String read FNomenclature write SetNomenclature;
    property OriginYear: Integer read FOriginYear write SetOriginYear;
    property MapOriginOrg: String read FMapOriginOrg write SetMapOriginOrg;
    property BasisType: String read FBasisType write SetBasisType;
    property Status: Integer read FStatus write SetStatus;
    property Secret: Integer read FSecret;///  write SetSecret
    ///  property Secret: Boolean read FSecret;///  write SetSecret
    property AnnulDate: String read FAnnulDate write SetAnnulDate;
    property ScanStatus: Integer read FScanStatus write SetScanStatus;
    property Number: String read FNumber write SetNumber;
    property GivenMaps: TDataSet read GetGivenMap;
    property MapHistory: TDataSet read GetMapHistory;
    property Scanning: TDataSet read GetScanning;
  end;

  TKisMap500Figure = class(TKisMapHistoryFigure)
  public
    class function EntityName: String; override;
    function Clone: TKisMapHistoryFigure; override;
  end;

  TKisMap500Mngr = class(TKisSQLMngr)
    dsMap500: TIBDataSet;
    dsMap500ID: TIntegerField;
    dsMap500NOMENCLATURE: TStringField;
    dsMap500ORIGIN_YEAR: TIntegerField;
    dsMap500MAP_ORIGIN_ORG: TStringField;
    dsMap500BASIS_TYPE: TStringField;
    dsMap500STATUS: TIntegerField;
    dsMap500ANNUL_DATE: TDateField;
    dsMap500SCAN_STATUS: TIntegerField;
    dsMap500NUMBER: TStringField;
    dsMap500HOLDER_NAME: TStringField;
    dsMap500DATE_OF_GIVE: TDateField;
    acGiveMap: TAction;
    acBackMap: TAction;
    dsMap500EXPIRED: TSmallintField;
    dsMap500GIVE_STATUS: TSmallintField;
    dsMap500IS_SECRET: TSmallintField;
    dsMap500DEFINITION_NUMBER: TStringField;
    Action4: TAction;
    acLegend: TAction;
    acPrint: TAction;
    Action5: TAction;
    acGoToScans: TAction;
    Action6: TAction;
    procedure acGiveMapExecute(Sender: TObject);
    procedure acBackMapExecute(Sender: TObject);
    procedure acGiveMapUpdate(Sender: TObject);
    procedure acBackMapUpdate(Sender: TObject);
    procedure acLegendExecute(Sender: TObject);
    procedure acPrintExecute(Sender: TObject);
    procedure acGoToScansExecute(Sender: TObject);
  private
    procedure SaveMap500(Map500: TKisEntity);
    procedure SaveGivenMap(MapList: TKisEntity);
    procedure SaveMapHistoryElement(HistList: TKisEntity);
    procedure SaveScanning(ScanList: TKisEntity);
    procedure SaveFigures(HistElement: TKisMapHistoryElement);
    procedure SaveFigurePoints(aFigure: TKisMap500Figure);
    procedure LoadHistory(const SQLText: String; Map500: TKisEntity; FCtrlr: TKisEntityController);
    procedure SetOrderId(EntKind: TKisEntities; Ent: TKisEntity);
    procedure SetOrderIdInGivenMap(Ent: TKisEntity);
    procedure SetOrderIdInScanning(Ent: TKisEntity);
    function FindOfficeId(GivenMap: TKisEntity; out OffId: Integer): Boolean;
    procedure AddFigure(HistElement: TKisEntity; FigureId: Integer);
    procedure GetHistoryElementFigures(HistoryElementId: Integer; HistElement: TKisMap500HistoryElement);
    procedure GridCellColors(Sender: TObject; Field: TField;
      var Background, FontColor: TColor; State: TGridDrawState; var FontStyle:TFontStyles);
    procedure GridLogicalColumn(Sender: TObject; Column: TColumn; var IsLogical: Boolean);
    procedure GridGetLogicalValue(Sender: TObject; Column: TColumn; var Value: Boolean);
  protected
    procedure Activate; override;
    procedure CreateView; override;
    procedure Deactivate; override;
    function GenEntityID(EntityKind: TKisEntities = keDefault): Integer; override;
    function GetIdent: TKisMngrs; override;
    function GetRefreshSQLText: String; override;
    function GetMainDataSet: TDataSet; override;
    function GetMainSQLText: String; override;
    function IsSupported(Entity: TKisEntity): Boolean; override;
    procedure PrepareSQLHelper; override;
  public
    function CreateEntity(EntityKind: TKisEntities): TKisEntity; override;
    function CreateNewEntity(EntityKind: TKisEntities = keDefault): TKisEntity; override;
    function CurrentEntity: TKisEntity; override;
    function DeleteEntity(Entity: TKisEntity): Boolean; override;
    function GetEntity(EntityID: Integer; EntityKind: TKisEntities = keDefault): TKisEntity; override;
    function IsEntityInUse(Entity: TKisEntity): Boolean; override;
    procedure SaveEntity(Entity: TKisEntity); override;
  end;

implementation

{$R *.dfm}

uses
  Types,
  // Common
  uSQLParsers, uLegend,
  // Project
  uKisAppModule, uKisConsts, uKisMap500Editor, uKisGivenMapListEditor,
  uKisScanningListEditor, uKisIntf, uKisLicensedOrgs,
  uKisPrintModule, uKisSearchClasses, uKisExceptions, uKisMapScans, uKisUtils;

resourcestring
  // Generators
  SG_MAP_500 = 'MAP_500';
  SG_GIVEN_MAP_500_LIST = 'GIVEN_MAP_LIST';
  SG_HISTORY_LIST = 'MAP_500_HISTORY';
  SG_SCANNING_500_LIST = 'SCANNING_LIST';
  SG_HISTORY_ELEMENT = 'HISTORY_ELEMENT';
  SG_FIGURE = 'MAP_500_FIGURES';

  // Queries
//  SQ_MAIN =
//    'SELECT M.ID, M.NOMENCLATURE, M.ORIGIN_YEAR, M.MAP_ORIGIN_ORG, M.BASIS_TYPE, M.STATUS, M.ANNUL_DATE, M.NUMBER, M.SCAN_STATUS, GML.HOLDER_NAME, GML.DATE_OF_GIVE, GML.EXPIRED, GML.STATUS AS GIVE_STATUS, M.IS_SECRET, GML.DEFINITION_NUMBER '
//  + 'FROM'
//  + '  MAP_500_GIVEOUTS_VIEW MGV'
//  + '  LEFT JOIN MAP_500 M ON (MGV.MAP_500_ID = M.ID)'
//  + '  LEFT JOIN GIVEN_MAP_LIST GML ON (MGV.ID=GML.ID)';
  SQ_MAIN =
    'SELECT'
  + '  M.ID, M.NOMENCLATURE, M.ORIGIN_YEAR, M.MAP_ORIGIN_ORG, M.BASIS_TYPE,'
  + '  M.STATUS, M.ANNUL_DATE, M.NUMBER, M.SCAN_STATUS, M.HOLDER_NAME,'
  + '  M.DATE_OF_GIVE, M.EXPIRED, M.GIVE_STATUS, M.IS_SECRET, M.DEFINITION_NUMBER '
  + 'FROM '
  + '  MAP_500_VIEW M ';
//  + '  LEFT JOIN GIVEN_MAP_LIST GML ON (M.LAST_GIVE_ID=GML.ID)';

  SQ_SELECT_MAP_500 =
    'SELECT M.ID, M.NOMENCLATURE, M.ORIGIN_YEAR, M.MAP_ORIGIN_ORG, M.BASIS_TYPE,'
  + 'M.STATUS, M.ANNUL_DATE, M.SCAN_STATUS, M.NUMBER, M.HOLDER_NAME, M.DATE_OF_GIVE '
  + 'FROM MAP_500_VIEW M '
  + 'WHERE ID=%d';
  SQ_SELECT_GIVEN_MAP_LIST = 'SELECT ML.ID, ML.MAP_500_ID, ML.DATE_OF_BACK, ML.DATE_OF_GIVE, ML.DEFINITION_NUMBER, ML.GIVEN_OBJECT, '
                             + 'ML.HOLDER, ML.HOLDER_NAME, ML.ORDER_NUMBER, ML.ORDERS_ID, ML.LICENSED_ORGS_ID, ML.PEOPLE_ID, ML.PERSON_WHO_GIVE_ID, ML.TERM_OF_GIVE, ML.ADDRESS, ML.OFFICES_ID, '
                             + 'P.INITIAL_NAME AS PEOPLE_NAME, '
                             + 'P1.INITIAL_NAME AS PERSON_WHO_GIVE '
                             + 'FROM GIVEN_MAP_LIST ML '
                             + 'LEFT JOIN PEOPLE P ON ML.PEOPLE_ID=P.ID '
                             + 'LEFT JOIN PEOPLE P1 ON ML.PERSON_WHO_GIVE_ID = P1.ID '
//                             + 'WHERE (P1.OFFICES_ID = 19) AND (ML.ID=%d)';
                             + 'WHERE (ML.ID=%d)';
  SQ_GET_GIVEN_MAP_LIST_ID = 'SELECT ID FROM GIVEN_MAP_LIST WHERE MAP_500_ID=%d ORDER BY ID';
  SQ_SELECT_HISTORY_LIST = 'SELECT * FROM MAP_500_HISTORY WHERE ID=%d';
  SQ_GET_HISTORY_LIST_ID = 'SELECT ID FROM MAP_500_HISTORY WHERE MAP_500_ID=%d ORDER BY ID';
  SQ_SELECT_SCANNING_LIST = 'SELECT SL.ID, SL.MAP_500_ID, SL.DATE_OF_SCAN, SL.OFFICES_ID, SL.ORDER_NUMBER, SL.ORDERS_ID, SL.PEOPLE_ID, SL.WORK_TYPE, '
                            + 'O.NAME AS OFFICE_NAME, P.INITIAL_NAME AS EXECUTOR '
                            + 'FROM SCANNING_LIST SL '
                            + 'LEFT JOIN OFFICES O ON SL.OFFICES_ID=O.ID '
                            + 'LEFT JOIN PEOPLE P ON SL.PEOPLE_ID=P.ID '
                            + 'WHERE SL.ID=%d';
  SQ_GET_SCANNING_LIST_ID = 'SELECT ID FROM SCANNING_LIST WHERE MAP_500_ID=%d ORDER BY ID';
  SQ_DELETE_MAP_500 = 'DELETE FROM MAP_500 WHERE ID=%d';
  SQ_DELETE_MAP_GIVE = 'DELETE FROM GIVEN_MAP_LIST WHERE ID=%d';
  SQ_DELETE_MAP_HISTORY_ELEMENT = 'DELETE FROM MAP_500_HISTORY WHERE ID=%d';
  SQ_DELETE_MAP_FIGURE = 'DELETE FROM MAP_500_FIGURES WHERE ID=%d';
  SQ_DELETE_SCANNING = 'DELETE FROM SCANNING_LIST WHERE ID=%d';
  SQ_SAVE_MAP_500 =
    'EXECUTE PROCEDURE SAVE_MAP_500('
  + ':ID, :NOMENCLATURE, :ORIGIN_YEAR, :MAP_ORIGIN_ORG, :BASIS_TYPE, :STATUS,'
  + ':ANNUL_DATE, :NUMBER, :IS_SECRET)';
  SQ_SAVE_GIVEN_MAP_LIST = 'EXECUTE PROCEDURE SAVE_GIVEN_MAP500(:ID, :MAP_500_ID, :DATE_OF_BACK, :DATE_OF_GIVE, '
                            +':DEFINITION_NUMBER, :GIVEN_OBJECT, :HOLDER, :HOLDER_NAME, :ORDER_NUMBER, :ORDERS_ID, :LICENSED_ORGS_ID, :PEOPLE_ID, :PERSON_WHO_GIVE_ID, :TERM_OF_GIVE, :ADDRESS, :OFFICES_ID)';
  SQ_SAVE_HISTORY_LIST = 'EXECUTE PROCEDURE SAVE_MAP_500_HISTORY(:ID, :MAP_500_ID, :CHIEF, :CURRENT_CHANGES_MAPPING, :DATE_OF_ACCEPT, :DATE_OF_WORKS, :DRAFT_WORKS_EXECUTOR, :ENGIN_NET_MAPPING, :HIGH_RISE_MAPPING, :HORIZONTAL_MAPPING, :MENS_MAPPING, '
                          + ':NEWLY_BUILDING_MAPPING, :ORDER_NUMBER, :TACHEOMETRIC_MAPPING, :TOTAL_SUM, :WORKS_EXECUTOR)';
  SQ_SAVE_SCANNING_LIST = 'EXECUTE PROCEDURE SAVE_MAP500_SCANNING(:ID, :MAP_500_ID, :DATE_OF_SCAN, :OFFICES_ID, :ORDER_NUMBER, :ORDERS_ID,  :PEOPLE_ID, :WORK_TYPE)';
  SQ_SAVE_FIGURE = 'EXECUTE PROCEDURE SAVE_MAP_500_FIGURES(:ID, :FIGURE_COLOR, :HISTORY_ELEMENT_ID, :FIGURE_TYPE, :EXTENT_LEFT, :EXTENT_RIGHT, :EXTENT_TOP, :EXTENT_BOTTOM)';
  SQ_SAVE_FIGURE_POINT = 'EXECUTE PROCEDURE SAVE_MAP_500_FIGURE_POINT(:ID, :FIGURE_ID, :X, :Y)';
  SQ_DELETE_FIGURE_POINTS = 'DELETE FROM MAP_500_FIGURE_POINTS WHERE FIGURE_ID=%d';
  SQ_CLEAR_GIVEN_MAP_LIST = 'DELETE FROM GIVEN_MAP_LIST WHERE MAP_500_ID=%d';
  SQ_CLEAR_HISTORY_LIST = 'DELETE FROM MAP_500_HISTORY WHERE MAP_500_ID=%d';
  SQ_CLEAR_SCANNING_LIST = 'DELETE FROM SCANNING_LIST WHERE MAP_500_ID=%d';
  SQ_FIND_ORDER = 'SELECT ID FROM ORDERS_ALL WHERE OFFICES_ID=%d AND ORDER_NUMBER=''%s''';
  SQ_FIND_OFFICE_ID = 'SELECT OFFICES_ID FROM PEOPLE WHERE ID=%d';
  SQ_SELECT_FIGURE = 'SELECT F.*, P.X, P.Y FROM MAP_500_FIGURES F LEFT JOIN MAP_500_FIGURE_POINTS P ON (F.ID = P.FIGURE_ID) WHERE F.ID=%d ORDER BY P.ID';
  SQ_GET_FIGURE_NUMBERS = 'SELECT ID FROM MAP_500_FIGURES WHERE HISTORY_ELEMENT_ID = %d ORDER BY ID';


{ TkisMap500 }

function TkisMap500.CreateEditor: TKisEntityEditor;
begin
  Result := TKisMap500Editor.Create(Application);
end;

procedure TkisMap500.Copy(Source: TKisEntity);
var
  Map500: TKisMap500;
begin
  inherited;
  Map500 := Source as TKisMap500;
  CopyMain(Map500);
  CopyGivenMap(Map500);
  CopyMapHistory(Map500);
  CopyScanning(Map500);
end;


function TkisMap500.IsEmpty: Boolean;
begin
  Result :=
    (FNomenclature = '')
    and (FOriginYear = N_ZERO)
    and (FMapOriginOrg = '')
    and (FBasisType = '')
    and (FStatus = N_ZERO)
    and (FAnnulDate = '')
    and (FScanStatus = N_ZERO)
    and (FNumber = '')
//    and (FDateOfScan = N_ZERO)
//    and (FDateOfGive = N_ZERO)
    and GivenMaps.IsEmpty
    and MapHistory.IsEmpty
    and Scanning.IsEmpty;
end;

procedure TKisMap500Mngr.Activate;
begin
  inherited;
  dsMap500.Transaction := AppModule.Pool.Get;
  dsMap500.Transaction.Init();
  dsMap500.Transaction.AutoStopAction := saNone;
  Reopen;
end;

procedure TKisMap500Mngr.CreateView;
begin
  inherited CreateView;
  FView.Caption := 'Планшеты 1:500';  //заголовок формы
  FView.Grid.OnCellColors := GridCellColors;
  FView.Grid.OnLogicalColumn := GridLogicalColumn;
  FView.Grid.OnGetLogicalValue := GridGetLogicalValue;
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
    with Items.Add do
    begin
      Color := $E4B59E;
      Caption := 'Отсканирован';
    end;
  end;
  //
  FView.ToolBarNav.Visible := True;
end;

procedure TKisMap500Mngr.Deactivate;
begin
  inherited;
  dsMap500.Close;
  if not dsMap500.Transaction.Active then
    dsMap500.Transaction.Commit;
  AppModule.Pool.Back(dsMap500.Transaction);
end;

function TkisMap500Mngr.GenEntityID(EntityKind: TKisEntities): Integer;
begin
  case EntityKind of
    keDefault, keMap500 :
      Result := AppModule.GetID(SG_MAP_500, Self.DefaultTransaction);
    keGivenMap :
      Result := AppModule.GetID(SG_GIVEN_MAP_500_LIST, Self.DefaultTransaction);
    keMap500HistoryElement :
      Result := AppModule.GetID(SG_HISTORY_LIST, Self.DefaultTransaction);
    keScanning :
      Result := AppModule.GetID(SG_SCANNING_500_LIST, Self.DefaultTransaction);
    keMap500HistoryFigure :
      Result := AppModule.GetID(SG_FIGURE, Self.DefaultTransaction);
  else
    Result := -1;
  end;
end;

function TkisMap500Mngr.GetIdent: TKisMngrs;
begin
  Result := kmMapCases500;
end;

function TkisMap500Mngr.GetMainSQLText: String;
begin
  Result := SQ_MAIN;
end;

function TkisMap500Mngr.IsSupported(Entity: TKisEntity): Boolean;
begin
  Result := Assigned(Entity)
    and ((Entity is TKisMap500)
         or (Entity is TKisGivenMap)
         or (Entity is TKisMapHistoryElement)
         or (Entity is TKisScanning));
  if not Result then
    inherited IsSupported(Entity);
end;

function TkisMap500Mngr.CreateEntity(EntityKind: TKisEntities): TKisEntity;
begin
  case EntityKind of
  keDefault, keMap500 :
    begin
      Result := TKisMap500.Create(Self);
    end;
  keGivenMap :
    begin
      Result := TKisGivenMap.Create(Self);
    end;
  keMap500HistoryElement :
    begin
      Result := TKisMap500HistoryElement.Create(Self);
    end;
  keScanning :
    begin
      Result := TKisScanning.Create(Self);
    end;
  keMap500HistoryFigure :
    begin
      Result := TKisMap500Figure.Create(Self);
    end;
  else
    Result := nil;
  end;
end;

function TKisMap500.Equals(Entity: TKisEntity): Boolean;
begin
  inherited Equals(Entity);
  with Entity as TKisMap500 do
  begin
    Result := 
      (Self.FNomenclature = FNomenclature)
      and (Self.FOriginYear = FOriginYear)
      and (Self.FMapOriginOrg = FMapOriginOrg)
      and (Self.FBasisType = FBasisType)
      and (Self.FStatus = FStatus)
      and (Self.FAnnulDate = FAnnulDate)
      and (Self.FScanStatus = FScanStatus)
      and (Self.FNumber = FNumber);
//      and (Self.FDateOfScan = FDateOfScan)
//      and (Self.FDateOfGive = FDateOfGive);
    if Result then
      Result := Result and Self.FGivenMapCtrlr.EqualsTo(FGivenMapCtrlr);
    if Result then
      Result := Result and Self.FMapHistoryCtrlr.EqualsTo(FMapHistoryCtrlr);
    if Result then
      Result := Result and Self.FScanningCtrlr.EqualsTo(FScanningCtrlr);
  end;
end;

procedure TKisMap500.Load(DataSet: TDataSet);
var
  theMngr: TKisSQLMngr;
begin
  inherited;
  with DataSet do
  begin
    ID := FieldByName(SF_ID).AsInteger;
    FNomenclature := FieldByName(SF_NOMENCLATURE).AsString;
    FOriginYear := FieldByName(SF_ORIGIN_YEAR).AsInteger;
    FMapOriginOrg := FieldByName(SF_MAP_ORIGIN_ORG).AsString;
    FBasisType := FieldByName(SF_BASIS_TYPE).AsString;
    FStatus := FieldByName(SF_STATUS).AsInteger;
    FAnnulDate := FieldByName(SF_ANNUL_DATE).AsString;
    FScanStatus := FieldByName(SF_SCAN_STATUS).AsInteger;
    FNumber := FieldByName(SF_NUMBER).AsString;
//    Self.FDateOfScan := FieldByName(SF_DATE_OF_SCAN).AsDateTime;
//    Self.FDateOfGive := FieldByName(SF_DATE_OF_GIVE).AsDateTime;
  end;
  theMngr := SQLMngr;
  //грузим список выдачи планшетов
  theMngr.LoadController(SQ_GET_GIVEN_MAP_LIST_ID, ID, keGivenMap, FGivenMapCtrlr);
  //грузим историю планшета
  theMngr.LoadController(SQ_GET_HISTORY_LIST_ID, ID, keMap500HistoryElement, FMapHistoryCtrlr);
  // [!!!] ОТКЛЮЧЕНО
  //грузим список сканирования
  //LoadList(SQ_GET_SCANNING_LIST_ID, Self, keScanning, Self.FScanningCtrlr);
end;

procedure TKisMap500.SetAnnulDate(const Value: String);
begin
  if FAnnulDate <> Value then
  begin
    FAnnulDate := Value;
    Modified := True;
  end;
end;

procedure TKisMap500.SetBasisType(const Value: String);
begin
  if FBasisType <> Value then
  begin
    FBasisType := Value;
    Modified := True;
  end;
end;

procedure TKisMap500.SetMapOriginOrg(const Value: String);
begin
  if FMapOriginOrg <> Value then
  begin
    FMapOriginOrg := Value;
    Modified := True;
  end;
end;

procedure TKisMap500.SetNomenclature(const Value: String);
begin
  if FNomenclature <> Value then
  begin
    FNomenclature := Value;
    Modified := True;
  end;
end;

procedure TKisMap500.SetNumber(const Value: String);
begin
  if FNumber <> Value then
  begin
    FNumber := Value;
    Modified := True;
  end;
end;

procedure TKisMap500.SetOriginYear(const Value: Integer);
begin
  if FOriginYear <> Value then
  begin
    FOriginYear := Value;
    Modified := True;
  end;
end;

procedure TKisMap500.SetScanStatus(const Value: Integer);
begin
  if FScanStatus <> Value then
  begin
    FScanStatus := Value;
    Modified := True;
  end;
end;

procedure TKisMap500.SetStatus(const Value: Integer);
begin
  if FStatus <> Value then
  begin
    FStatus := Value;
    Modified := True;
  end;
end;


function TkisMap500Mngr.CreateNewEntity(EntityKind: TKisEntities): TKisEntity;
begin
  Result := CreateEntity(EntityKind);
  if Assigned(Result) then
  begin
    Result.ID := Self.GenEntityID(EntityKind);
    if Result is TKisMap500 then
      TKisMap500(Result).FIsNew := True;
  end
  else
    raise Exception.Create(S_CANT_CREATE_NEW_ENTITY);
end;

function TkisMap500Mngr.CurrentEntity: TKisEntity;
begin
  Result := GetEntity(dsMap500.FieldByName(SF_ID).AsInteger, keMap500);
  if Assigned(Result) then
    Result.Modified := False;
end;

function TkisMap500Mngr.DeleteEntity(Entity: TKisEntity): Boolean;
var
  Conn: IKisConnection;
  S: String;
begin
  Conn := GetConnection(True, True);
  if IsEntityInUse(Entity) then
  begin
    Result := False;
    inherited DeleteEntity(Entity);
  end
  else
    try
      S := '';
      if Entity is TKisGivenMap then
        S := SQ_DELETE_MAP_GIVE
      else
      if Entity is TKisMapHistoryElement then
        S := SQ_DELETE_MAP_HISTORY_ELEMENT
      else
      if Entity is TKisMap500Figure then
        S := SQ_DELETE_MAP_FIGURE
      else
      if Entity is TKisScanning then
        S := SQ_DELETE_SCANNING
      else
      if Entity is TKisMap500 then
        S := SQ_DELETE_MAP_500;

      Conn.GetDataSet(Format(S, [Entity.ID])).Open;
      Result := True;
      FreeConnection(Conn, True);
    except
      FreeConnection(Conn, False);
      raise;
    end;
end;

function TkisMap500Mngr.GetEntity(EntityID: Integer;
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
    keDefault, keMap500 :
      SQLText := Format(SQ_SELECT_MAP_500, [EntityID]);
    keGivenMap :
      SQLText := Format(SQ_SELECT_GIVEN_MAP_LIST, [EntityID]);
    keMap500HistoryElement :
      SQLText := Format(SQ_SELECT_HISTORY_LIST, [EntityID]);
    keMap500HistoryFigure :
      SQLText := Format(SQ_SELECT_FIGURE, [EntityID]);
    keScanning :
      SQLText := Format(SQ_SELECT_SCANNING_LIST, [EntityID]);
    else
      raise ELoadEntity.Create(EntityID, EntityKind);
    end;
    DataSet := Conn.GetDataSet(SQLText);
    DataSet.Open;
    if not DataSet.IsEmpty then
    begin
      Result := CreateEntity(EntityKind);
      Result.Load(DataSet);
    end
    else
      raise ELoadEntity.Create(EntityID, EntityKind);
  finally
    FreeConnection(Conn, True);
  end;
end;

function TKisMap500Mngr.IsEntityInUse(Entity: TKisEntity): Boolean;
begin
  Result := False;
end;

procedure TKisMap500Mngr.PrepareSQLHelper;
begin
  inherited;
  with FSQLHelper.AddTable do
  begin
    TableName := ST_MAP_500_VIEW;
    TableLabel := 'Основная (планшеты)';
    AddStringField(SF_NOMENCLATURE, SFL_NOMENCLATURE, 20, [fpSearch, fpSort, fpQuickSearch]);
    AddSimpleField(SF_ORIGIN_YEAR, SFL_ORIGIN_YEAR, ftSmallInt, [fpSearch, fpSort, fpQuickSearch]);
    AddSimpleField(SF_DATE_OF_GIVE, SFL_DATE_OF_GIVE, ftDate, [fpSearch]);
    AddSimpleField(SF_DATE_OF_BACK, SFL_DATE_OF_BACK, ftDate, [fpSearch]);
    AddStringField(SF_DEFINITION_NUMBER, SFL_DEFINITION_NUMBER, 10, [fpSearch, fpQuickSearch]);
    AddSimpleField(SF_EXPIRED, SFL_EXPIRED, ftBoolean, [fpSearch, fpSort]);
    AddStringField(SF_HOLDER_NAME, SFL_HOLDER_NAME, 300, [fpSearch, fpSort, fpQuickSearch]);
    AddStringField(SF_ADDRESS, SFL_ADDRESS, 400, [fpSearch]);
    AddStringField(SF_NUMBER, SFL_NUMBER, 10, [fpSearch, fpSort, fpQuickSearch]);
    AddSimpleField(SF_GIVE_STATUS, SFL_GIVE_STATUS, ftBoolean, [fpSearch, fpSort]);
    AddSimpleField(SF_SCAN_STATUS, SFL_SCAN_STATUS, ftBoolean, [fpSearch, fpSort]);
    AddSimpleField(SF_ID, SFL_ID, ftInteger, [fpSort]);
  end;
  with FSQLHelper.AddTable do
  begin
    TableName := ST_GIVEN_MAP_LIST;
    TableLabel := 'Выдача планшетов';
  end;
end;

procedure TKisMap500Mngr.SaveEntity(Entity: TKisEntity);
begin
  inherited;
  if Assigned(Entity) then
  if IsSupported(Entity) then
  if (Entity is TKisMap500) then
       SaveMap500(Entity)
  else
     if (Entity is TKisGivenMap) then
        SaveGivenMap(Entity)
      else
        if (Entity is TKisMapHistoryElement) then
          SaveMapHistoryElement(Entity)
        else
          if (Entity is TKisScanning) then
            SaveScanning(Entity)
end;

function TKisMap500.GetGivenMap: TDataSet;
begin
  Result := FGivenMap;
end;

function TKisMap500.GetMapHistory: TDataSet;
begin
  Result := FMapHistory;
end;

function TKisMap500.GetScanning: TDataSet;
begin
  Result := FScanning;
end;

constructor TKisMap500.Create(Mngr: TKisMngr);
begin
  inherited;
  FGivenMapCtrlr := TGivenMapCtrlr.CreateController(Mngr, Mngr, keGivenMap);
  FGivenMapCtrlr.HeadEntity := Self;
  FGivenMap := TCustomDataSet.Create(Mngr);
  FGivenMap.Controller := FGivenMapCtrlr;
  FGivenMap.Open;
  FGivenMap.First;

  FMapHistoryCtrlr := TMap500HistoryCtrlr.CreateController(Mngr, Mngr, keMap500HistoryElement);
  FMapHistoryCtrlr.HeadEntity := Self;
  FMapHistory := TCustomDataSet.Create(Mngr);
  FMapHistory.Controller := FMapHistoryCtrlr;
  FMapHistory.Open;
  FMapHistory.First;

  FScanningCtrlr := TScanningCtrlr.CreateController(Mngr, Mngr, keScanning);
  FScanningCtrlr.HeadEntity := Self;
  FScanning := TCustomDataSet.Create(Mngr);
  FScanning.Controller := FScanningCtrlr;
  FScanning.Open;
  FScanning.First;

  FStatus := Integer(True);
end;

destructor TKisMap500.Destroy;
begin
  FGivenMap.Close;
  FGivenMap.Free;
  FGivenMapCtrlr.Free;

  FMapHistory.Close;
  FMapHistory.Free;
  FMapHistoryCtrlr.Free;

  FScanning.Close;
  FScanning.Free;
  FScanningCtrlr.Free;

  inherited;
end;

class function TKisMap500.EntityName: String;
begin
  Result := SEN_MAP_500;
end;

procedure TKisMap500.CopyMain(Source: TKisMap500);
begin
  with Source do
  begin
    Self.FNomenclature := FNomenclature;
    Self.FOriginYear := FOriginYear;
    Self.FMapOriginOrg := FMapOriginOrg;
    Self.FBasisType := FBasisType;
    Self.FStatus := FStatus;
    Self.FAnnulDate := FAnnulDate;
    Self.FScanStatus := FScanStatus;
    Self.FNumber := FNumber;
  end;
end;

procedure TKisMap500.CopyGivenMap(Source: TKisMap500);
begin
  FGivenMapCtrlr.DirectClear;
  CopyDataSet(Source.GivenMaps, Self.GivenMaps);
end;

procedure TKisMap500.CopyMapHistory(Source: TKisMap500);
begin
  FMapHistoryCtrlr.DirectClear;
  CopyDataSet(Source.MapHistory, Self.MapHistory);
end;

procedure TKisMap500.CopyScanning(Source: TKisMap500);
begin
  FScanningCtrlr.DirectClear;
  CopyDataSet(Source.Scanning, Self.Scanning);
end;

function TKisMap500.CheckEditor(Editor: TKisEntityEditor): Boolean;
var
  D: TDateTime;
  B: Boolean;
  I: Int64;
//  S, S1: String;
  N: TNomenclature;
begin
  Result := False;
  if Editor is TKisMap500Editor then
    with Editor as TKisMap500Editor do
    begin
      N.Init(edNomenclature.Text + '-' + edNom2.Text + '-' + edNom3.Text, False);
      if not N.Valid then
      begin
        MessageBox(Handle, PChar(S_CHECK_NOMENCLATURE), PChar(S_WARN), MB_OK + MB_ICONWARNING);
        edNomenclature.SetFocus;
        Exit;
      end
      else
      begin
        edNomenclature.Text := N.Part1;
        edNom2.Text := N.Part2;
        edNom3.Text := N.Part3;
      end;
      if FIsNew then
      if not IsNomenclatureUnique(N.Nomenclature()) then
      begin
        MessageBox(Handle, PChar(S_CHECK_NOMENCLATURE_IS_UNIQUE), PChar(S_WARN), MB_OK + MB_ICONWARNING);
        edNomenclature.SetFocus;
        Exit;
      end;
      B := Trim(edOriginYear.Text) = '';
      if not B then
        B := not StrIsNumber(Trim(edOriginYear.Text), I);
      if not B then
        B := (I < 1940) or (I > CurrentYear);
      if B then
      begin
        AppModule.Alert(S_CHECK_ORIGIN_YEAR);
        pcMap500.ActivePageIndex := 0;
        edOriginYear.SetFocus;
        Exit;
      end;
      if (Length(Trim(edNumber.Text)) = 0) then
      begin
        AppModule.Alert(S_CHECK_MAP_NUMBER);
        pcMap500.ActivePageIndex := 0;
        edNumber.SetFocus;
        Exit;
      end;
      if (Length(Trim(cbOriginOrg.Text)) = 0) then
      begin
        AppModule.Alert(S_CHECK_ORIGIN_ORG);
        pcMap500.ActivePageIndex := 0;
        cbOriginOrg.SetFocus;
        Exit;
      end;
      if (Length(Trim(edBasisType.Text)) = 0) then
      begin
        AppModule.Alert(S_CHECK_BASIS_TYPE);
        pcMap500.ActivePageIndex := 0;
        edBasisType.SetFocus;
        Exit;
      end;
      if not cbStatus.Checked then
      if not TryStrToDate(edAnnulDate.Text, D) or
            ((D > Date) or (D < MIN_DOC_DATE))
      then
      begin
        AppModule.Alert(S_CHECK_ANNUL_DATE);
        pcMap500.ActivePageIndex := 0;
        edAnnulDate.SetFocus;
        Exit;
      end;
  end;
  Result := True;
end;

procedure TKisMap500.LoadDataIntoEditor(Editor: TKisEntityEditor);
var
  NomParts: TStringList;
  S: String;
  N: TNomenclature;
begin
  with Editor as TKisMap500Editor do
  begin
    if Nomenclature = '' then
    begin
      edNomenclature.Clear;
      edNom2.Clear;
      edNom3.Clear;
    end
    else
    begin
      S := Nomenclature;
      N.Init(S, False);
      if N.Valid then
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
    end;

    if OriginYear > N_ZERO then
      edOriginYear.Text := IntToStr(OriginYear)
    else
      edOriginYear.Text := '';
    edNumber.Text := Number;
    cbOriginOrg.Text := MapOriginOrg;
    edBasisType.Text := BasisType;
    cbStatus.Checked := Boolean(Status);
    if AnnulDate <> '' then
      edAnnulDate.Text := AnnulDate;
    cbScanStatus.Checked := Boolean(ScanStatus);
    MapHistory.First;
  end;
end;

procedure TKisMap500.PrepareEditor(Editor: TKisEntityEditor);
begin
  inherited;
  with Editor as TKisMap500Editor do
  begin
    dsGivenMap.DataSet := FGivenMap;
    FGivenMap.Last;
    FGivenMap.AfterScroll := GivanMapsAfterScroll;

    btnGiveMap.OnClick := GivenMapGiveOutHandler;
    btnBack.OnClick := GivenMapBackHandler;
    btnDeleteGivenMap.OnClick := GivenMapDelete;

    dsMapHistory.DataSet := FMapHistory;
    FMapHistory.AfterInsert := MapHistoryInsert;
    FMapHistory.BeforeDelete := MapHistoryBeforeDelete;
    FMapHistory.AfterScroll := MapHistoryAfterScroll;
    FMapHistory.Refresh;

    btnEditHistory.OnClick := EditMapHistory;

    dsScanning.DataSet := FScanning;
    FScanning.AfterInsert := ScanningInsert;
    FScanning.BeforeDelete := ScanningBeforeDelete;
    FScanning.Refresh;

    btnEditScann.OnClick := EditScanning;

    edBasisType.Items := IStringList(AppModule.Lists[klMapCasesBasis]).StringList;

    cbOriginOrg.Items := IStringList(AppModule.Lists[klOriginOrgs]).StringList;
    //
    with AppModule.User do
    begin
      tbScan.Enabled := (OfficeID = ID_OFFICE_GIS) or IsAdministrator;
      tbMapCase.Enabled := (OfficeID = ID_OFFICE_KGO) or IsAdministrator;
      tbHistory.Enabled := (OfficeID = ID_OFFICE_KGO) or IsAdministrator;
    end;
    //
    UseScanningList := True;
  end;
  UpdateEditorBtns;
end;

procedure TKisMap500.ReadDataFromEditor(Editor: TKisEntityEditor);
begin
  inherited;
  with Editor as TKisMap500Editor do
  begin
    Nomenclature := edNomenclature.Text + '-' + edNom2.Text + '-' + edNom3.Text;
    OriginYear := StrToInt(Trim(edOriginYear.Text));
    MapOriginOrg := Trim(cbOriginOrg.Text);
    BasisType := Trim(edBasisType.Text);
    Status := Integer(cbStatus.Checked);
    AnnulDate := Trim(edAnnulDate.Text);
    ScanStatus := Integer(cbScanStatus.Checked);
    Number := Trim(edNumber.Text);
  end;
end;

procedure TKisMap500.UnprepareEditor(Editor: TKisEntityEditor);
begin
  with Editor as TKisMap500Editor do
  begin
    dsGivenMap.DataSet := nil;
    FGivenMap.AfterInsert := nil;
    FGivenMap.BeforeDelete := nil;
    FMapHistory.AfterScroll := nil;
  end;
  inherited;
end;

procedure TKisMap500.GivenMapDelete(Sender: TObject);
begin
  if not FGivenMap.IsEmpty then
  if MessageBox(EntityEditor.Handle,
                PChar(S_CONFIRM_DELETE_GIVEN_MAP_LIST), PChar(S_CONFIRM),
                MB_YESNO + MB_ICONQUESTION) = ID_YES
  then
  begin
    FGivenMap.Last;
    FGivenMap.Delete;
    FGivenMap.Last;
  end;
end;

procedure TKisMap500.GivenMapGiveOutHandler(Sender: TObject);
begin
  if Assigned(EntityEditor) then
  if CanGiveOut then
  begin
    GiveOutMap;
    GivenMaps.Last;
  end;
end;

procedure TKisMap500.EditMapHistory(Sender: TObject);
var
  Index: Integer;
begin
  // Здесь показываем редактор истории планшета
  Index := MapHistory.RecNo;
  if not MapHistory.IsEmpty then
  begin
    //MapHistory.Edit;
    //Index := 0;
    if not TKisVisualEntity(FMapHistoryCtrlr.Elements[Index]).Edit then ;
{       MapHistory.Cancel
    else
       MapHistory.Post; }
  end;
  MapHistory.First;
  MapHistory.RecNo := Index;
end;

procedure TKisMap500.MapHistoryBeforeDelete(DataSet: TDataSet);
begin
  if DataSet.IsEmpty then
    Abort;
  if MessageBox(EntityEditor.Handle, PChar(S_CONFIRM_DELETE_HISTORY_LIST), PChar(S_CONFIRM),
    MB_YESNO + MB_ICONQUESTION) <> ID_YES then
    Abort;
end;

procedure TKisMap500.MapHistoryInsert(DataSet: TDataSet);
begin
  // Здесь показываем редактор истории планшета
  if not TKisVisualEntity(FMapHistoryCtrlr.Elements[0]).Edit then
    DataSet.Cancel
  else
  begin
    DataSet.Post;
  end;
end;

procedure TKisMap500.EditScanning(Sender: TObject);
begin
  // Здесь показываем редактор сканирования планшета
  if not Scanning.IsEmpty then
  begin
    Scanning.Edit;
    if not TKisVisualEntity(FScanningCtrlr.Elements[0]).Edit then
       Scanning.Cancel
    else
       Scanning.Post;
  end;
end;

procedure TKisMap500.ScanningBeforeDelete(DataSet: TDataSet);
begin
  if DataSet.IsEmpty then
    Abort;
  if MessageBox(EntityEditor.Handle, PChar(S_CONFIRM_DELETE_SCANNING_LIST), PChar(S_CONFIRM),
    MB_YESNO + MB_ICONQUESTION) <> ID_YES then
    Abort;
end;

procedure TKisMap500.ScanningInsert(DataSet: TDataSet);
begin
  // Здесь показываем редактор сканирования выдачи планшетов
  if not TKisVisualEntity(FScanningCtrlr.Elements[0]).Edit then
    DataSet.Cancel
  else
    DataSet.Post;
end;

procedure TKisMap500.GiveOutMap;
var
  Mngr: TKisMap500Mngr;
  MapGive: TKisGivenMap;
begin
  GivenMaps.Last;
  if CanGiveOut then
  begin
    Mngr := TKisMap500Mngr(Manager);
    MapGive := TKisGivenMap(Mngr.CreateNewEntity(keGivenMap));
    MapGive.DateOfGive := FormatDateTime(S_DATESTR_FORMAT, Date);
    MapGive.TermOfGive := 10;
    MapGive.Modified := False;
    MapGive.InGive := True;
    if MapGive.Edit then
    begin
      FGivenMapCtrlr.DirectAppend(MapGive);
      Self.Modified := True;
    end;
    MapGive.InGive := False;
  end
  else
    raise Exception.Create(S_CANT_GIVE_OUT_MAP);
end;

function TKisMap500.CanGiveOut: Boolean;
begin
  Result := (FGivenMapCtrlr.Count = 0) or (FGivenMapCtrlr.GivenMaps[FGivenMapCtrlr.Count].DateOfBack <> '');
end;

function TKisMap500.CanGiveBack: Boolean;
begin
  Result := (FGivenMapCtrlr.Count > 0) and (FGivenMapCtrlr.GivenMaps[FGivenMapCtrlr.Count].DateOfBack = '');
end;

function TKisMap500.GiveBackMap: Boolean;
var
  MapGive: TKisGivenMap;
begin
  Result := False;
  MapGive := TKisGivenMap(FGivenMapCtrlr.Elements[FGivenMapCtrlr.Count]);
  MapGive.InBack := True;
  MapGive.DateOfBack := DateToStr(Date);
  if MapGive.Edit then
    Result := MapGive.Modified;
  MapGive.InBack := False;
end;

procedure TKisMap500.GivenMapBackHandler(Sender: TObject);
begin
  if Assigned(EntityEditor) then
  if CanGiveBack then
  begin
    GiveBackMap;
    GivenMaps.Last;
  end;
end;

procedure TKisMap500.UpdateEditorBtns;
begin
  with TKisMap500Editor(EntityEditor) do
  begin
    btnGiveMap.Enabled := CanGiveOut;
    btnDeleteGivenMap.Enabled := not FGivenMap.IsEmpty;
    btnBack.Enabled := CanGiveBack;
  end;
end;

procedure TKisMap500.GivanMapsAfterScroll(DataSet: TDataSet);
begin
  UpdateEditorBtns;
end;

function TKisMap500.IsNomenclatureUnique(const Value: String): Boolean;
var
  V: Variant;
begin
  Result := not AppModule.GetFieldValue(nil, ST_MAP_500, SF_NOMENCLATURE, SF_ID, Value, V);
end;

procedure TKisMap500.mapHistoryAfterScroll(DataSet: TDataSet);
var
  History: TKisMapHistoryElement;
begin
  if Assigned(EntityEditor) then
  if MapHistory.IsEmpty then
    with TKisMap500Editor(EntityEditor) do
      pbPreview.Canvas.FillRect(pbPreview.ClientRect)
  else
  begin
    History := TKisMapHistoryElement(FMapHistoryCtrlr.Elements[MapHistory.RecNo]);
    with TKisMap500Editor(EntityEditor) do
      History.PaintFigures(pbPreview);
  end;
end;

{ TKisGivenMap }

function TKisGivenMap.CheckEditor(AEditor: TKisEntityEditor): Boolean;
var
  B: Boolean;
  I: Int64;
  GiveDate, BackDate: TDateTime;

  procedure ErrorInBackDate;
  begin
    MessageBox(AEditor.Handle, PChar(S_CHECK_DATE_OF_BACK), PChar(S_WARN), MB_OK + MB_ICONWARNING);
    with AEditor as TKisGivenMapListEditor do
      edDateOfBack.SetFocus;
  end;

begin
  Result := False;
  if AEditor is TKisGivenMapListEditor then
    with AEditor as TKisGivenMapListEditor do
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
    end;
  end;
  Result := True;
end;

procedure TKisGivenMap.Copy(Source: TKisEntity);
begin
  inherited;
  with Source as TKisGivenMap do
  begin
    Self.FMap500Id := FMap500Id;
    Self.FGivenObject := FGivenObject;
    Self.FDateOfGive := FDateOfGive;
    Self.FTermOfGive := FTermOfGive;
    Self.FHolder := FHolder;
    Self.FPeopleId := FPeopleId;
    Self.FLicensedOrgId := FLicensedOrgId;
    Self.FHolderName := FHolderName;
    Self.FDateOfBack := FDateOfBack;
    Self.FDefinitionNumber := FDefinitionNumber;
    Self.FOrderNumber := FOrderNumber;
    Self.FOrdersId := FOrdersId;
    Self.FAddress := FAddress;
    Self.FPersonWhoGiveId := FPersonWhoGiveId;
    Self.FOfficeId := FOfficeId;
    Self.FPeopleName := FPeopleName;
    Self.FPersonWhoGive := FPersonWhoGive;
  end;
end;

function TKisGivenMap.CreateEditor: TKisEntityEditor;
begin
  Result := TKisGivenMapListEditor.Create(Application);
end;

class function TKisGivenMap.EntityName: String;
begin
  Result := 'Список выдачи';
end;

procedure TKisGivenMap.Load(DataSet: TDataSet);
begin
  inherited;
  with DataSet do
  begin
    ID := FieldByName(SF_ID).AsInteger;
    Map500Id := FieldByName(SF_MAP_500_ID).AsInteger;
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
    PersonWhoGive := FieldByName(SF_PERSON_WHO_GIVE).AsString;
    PersonWhoGiveId := FieldByName(SF_PERSON_WHO_GIVE_ID).AsInteger;
    TermOfGive := FieldByName(SF_TERM_OF_GIVE).AsInteger;
    OfficeId := FieldByName(SF_OFFICES_ID).AsInteger;
    PeopleName := FieldByName(SF_PEOPLE_NAME).AsString;
    Self.Modified := False;
  end;
end;

procedure TKisGivenMap.LoadDataIntoEditor(AEditor: TKisEntityEditor);
begin
  inherited;
  with AEditor as TKisGivenMapListEditor do
  begin
    edDateOfGive.Text := DateOfGive;
    if TermOfGive = 0 then
      edTermOfGive.Text := ''
    else
      edTermOfGive.Text := IntToStr(TermOfGive);
    if DateOfBack <> '' then
      edDateOfBack.Text := DateOfBack;
    edDefinitionNumber.Text := DefinitionNumber;
    edOrderNumber.Text := OrderNumber;
    edAddress.Text := Address;
    cbPersonWhoGive.Items := IStringList(AppModule.PeolpeList(ID_OFFICE_KGO)).StringList;
    if PersonWhoGiveId > 0 then
      ComboLocate(cbPersonWhoGive, PersonWhoGiveId)
    else
      cbPersonWhoGive.ItemIndex := cbPersonWhoGive.Items.IndexOf(AppModule.User.FullName);//ShortName);
    RadBtnOrgs.Checked := Holder;
    RadBtnMP.Checked := not RadBtnOrgs.Checked;
    if Holder then
    begin
      //грузим сторониие организации
      Label4.Caption := 'Наименование';
      Label5.Caption := 'Контактное лицо';
      cbPeople.Visible := false;
      edOrgname.Text := HolderName;
      edContacter.Visible := True;
      edContacter.Text := PeopleName;
    end
    else
    begin
      //грузим отделы и исполнителей
      Label4.Caption := 'Отдел';
      Label5.Caption := 'Исполнитель';
      cbPeople.Visible := true;
      cbOffices.ItemIndex := OfficeId;
      ComboLocate(cbOffices, OfficeId);
      LoadPeopleList(nil);
      cbPeople.ItemIndex := PeopleId;
      ComboLocate(cbPeople, PeopleId);
      cbPeople.Text := PeopleName;
    end;
  end;
end;

procedure TKisGivenMap.PrepareEditor(AEditor: TKisEntityEditor);
begin
  inherited;
  with AEditor as TKisGivenMapListEditor do
  begin
    cbOffices.OnChange := LoadPeopleList;
    RadBtnOrgs.OnClick := LoadOrgs;
    RadBtnMP.OnClick := LoadOfficesAndPeople;
    if InBack then
      PrepareEditorForBack(AEditor)
    else
      PrepareEditorForGive(AEditor);
  end;
end;

procedure TKisGivenMap.ReadDataFromEditor(AEditor: TKisEntityEditor);
begin
  inherited;
  with AEditor as TKisGivenMapListEditor do
  begin
    DateOfGive := Trim(edDateOfGive.Text);
    Holder := RadBtnOrgs.Checked;
    if Holder then
    begin
      PeopleId := 0;
      OfficeId := 0;
      PeopleName := Trim(edContacter.Text);
      HolderName := Trim(edOrgname.Text);
    end
    else
    begin
      OfficeId := Integer(cbOffices.Items.Objects[cbOffices.ItemIndex]);
      PeopleId := Integer(cbPeople.Items.Objects[cbPeople.ItemIndex]);
      LicensedOrgId := N_ZERO;
      HolderName := 'МП "УГА" - ' + cbPeople.Text;
      PeopleName := cbPeople.Text;
    end;
    TermOfGive := StrToInt(Trim(edTermOfGive.Text));
    DateOfBack := Trim(edDateOfBack.Text);
    DefinitionNumber := Trim(edDefinitionNumber.Text);
    OrderNumber := Trim(edOrderNumber.Text);
    Address := Trim(edAddress.Text);
    PersonWhoGiveId := Integer(cbPersonWhoGive.Items.Objects[cbPersonWhoGive.ItemIndex]);
    PeopleName := Trim(cbPeople.Text);
    PersonWhoGive := Trim(cbPersonWhoGive.Text);
  end;
end;

procedure TKisGivenMap.SetAddress(const Value: String);
begin
  if FAddress <> Value then
  begin
    FAddress := Value;
    Modified := True;
  end;
end;

procedure TKisGivenMap.SetDateOfBack(const Value: String);
begin
  if FDateOfBack <> Value then
  begin
    FDateOfBack := Value;
    Modified := True;
  end;
end;

procedure TKisGivenMap.SetDateOfGive(const Value: String);
begin
  if FDateOfGive <> Value then
  begin
    FDateOfGive := Value;
    Modified := True;
  end;
end;

procedure TKisGivenMap.SetDefinitionNumber(const Value: String);
begin
  if FDefinitionNumber <> Value then
  begin
    FDefinitionNumber := Value;
    Modified := True;
  end;
end;

procedure TKisGivenMap.SetHolder(const Value: Boolean);
begin
  if FHolder <> Value then
  begin
    FHolder := Value;
    Modified := True;
  end;
end;

procedure TKisGivenMap.SetHolderName(const Value: String);
begin
  if FHolderName <> Value then
  begin
    FHolderName := Value;
    Modified := True;
  end;
end;

procedure TKisGivenMap.SetMap500Id(const Value: Integer);
begin
  if FMap500Id <> Value then
  begin
    FMap500Id := Value;
    Modified := True;
  end;
end;

procedure TKisGivenMap.SetOrderNumber(const Value: String);
begin
  if FOrderNumber <> Value then
  begin
    FOrderNumber := Value;
    Modified := True;
  end;
end;

procedure TKisGivenMap.SetOrdersId(const Value: Integer);
begin
  if FOrdersId <> Value then
  begin
    FOrdersId := Value;
    Modified := True;
  end;
end;

procedure TKisGivenMap.SetLicensedOrgId(const Value: Integer);
begin
  if FLicensedOrgId <> Value then
  begin
    FLicensedOrgId := Value;
    Modified := True;
  end;
end;

procedure TKisGivenMap.SetPeopleId(const Value: Integer);
begin
  if FPeopleId <> Value then
  begin
    FPeopleId := Value;
    Modified := True;
  end;
end;

procedure TKisGivenMap.SetPersonWhoGiveId(const Value: Integer);
begin
  if FPersonWhoGiveId <> Value then
  begin
    FPersonWhoGiveId := Value;
    Modified := True;
  end;
end;

procedure TKisGivenMap.SetTermOfGive(const Value: Integer);
begin
  if FTermOfGive <> Value then
  begin
    FTermOfGive := Value;
    Modified := True;
  end;
end;


procedure TKisMap500Mngr.SetOrderId(EntKind: TKisEntities; Ent: TKisEntity);
begin
  case EntKind of
  keGivenMap:
  begin
    SetOrderIdInGivenMap(Ent);
  end;
  keScanning:
  begin
    SetOrderIdInScanning(Ent);
  end;
end;

end;

procedure TKisGivenMap.LoadPeopleList(Sender: TObject);
var
  P: Integer;
begin
  with EntityEditor as TKisGivenMapListEditor do
  begin
    if cbOffices.ItemIndex < 0 then
      cbPeople.Items.Clear
    else
    begin
      cbPeople.Text := '';
      P := Integer(cbOffices.Items.Objects[cbOffices.ItemIndex]);
      cbPeople.Items := IStringList(AppModule.PeolpeList(P)).StringList;
    end;
  end;
end;

procedure TKisGivenMap.SetOfficeId(const Value: Integer);
begin
  if FOfficeId <> Value then
  begin
    FOfficeId := Value;
    Modified := True;
  end;
end;

procedure TKisGivenMap.LoadOfficesAndPeople(Sender: TObject);
begin
  with EntityEditor as TKisGivenMapListEditor do
  begin
    if RadBtnMP.Checked then
    begin
      //грузим отделы и исполнителей
      Label4.Visible := true;
      Label5.Visible := true;
      cbPeople.Visible := true;
      cbOffices.Visible := True;
      cbOffices.Items := IStringList(AppModule.Lists[klOffices]).StringList;
      cbOffices.ItemIndex := OfficeId;
      ComboLocate(cbOffices, OfficeId);
      edContacter.Visible := False;
      btnSelectOrg.Visible := False;
      edOrgname.Visible := False;
    end;
  end;
end;

procedure TKisGivenMap.LoadOrgs(Sender: TObject);
begin
  with EntityEditor as TKisGivenMapListEditor do
  begin
    if RadBtnOrgs.Checked then
    begin
      //грузим сторониие организации
      RadBtnMP.Checked := false;
      Label4.Visible := false;
      Label5.Visible := false;
      cbPeople.Visible := false;
      cbOffices.Visible := False;
      edOrgname.Visible := True;
      edContacter.Visible := True;
      btnSelectOrg.Visible := True;
    end;
  end;  
end;

procedure TKisGivenMap.SetPeopleName(const Value: String);
begin
  if FPeopleName <> Value then
  begin
    FPeopleName := Value;
    Modified := True;
  end;
end;

procedure TKisGivenMap.SetPersonWhoGive(const Value: String);
begin
  if FPersonWhoGive <> Value then
  begin
    FPersonWhoGive := Value;
    Modified := True;
  end;
end;

procedure TKisGivenMap.PrepareEditorForBack(AEditor: TKisEntityEditor);
begin
  with TKisGivenMapListEditor(AEditor) do
  begin
    gbGive.Enabled := False;
    edDateOfGive.Color := clBtnFace;
    cbPersonWhoGive.Color := clBtnFace;
    edTermOfGive.Color := clBtnFace;
    gbSender.Enabled := False;
    edOrgname.Color := clBtnFace;
    cbPeople.Color := clBtnFace;
    RadBtnOrgs.Color := clBtnFace;
    RadBtnMP.Color := clBtnFace;
    edAddress.Color := clBtnFace;
    edDefinitionNumber.Color := clBtnFace;
    edOrderNumber.Color := clBtnFace;
    RadBtnOrgs.Color := clbtnFace;
    RadBtnMP.Color := clBtnFace;
    gbBack.Enabled := True;
  end;
end;

procedure TKisGivenMap.PrepareEditorForGive(AEditor: TKisEntityEditor);
begin
  with TKisGivenMapListEditor(AEditor) do
  begin
    gbBack.Visible := False;
    ClientHeight := ClientHeight - gbBack.Height;
//    btnOK.Top := btnOK.Top - gbBack.Height;
//    btnCancel.Top := btnCancel.Top - gbBack.Height;
    btnSelectOrg.OnClick := SelectOrg;
  end;
end;

constructor TKisGivenMap.Create(aMngr: TKisMngr);
begin
  inherited;
  FGivenObject := True;
  FTermOfGive := 10;
end;

procedure TKisGivenMap.SelectOrg(Sender: TObject);
var
  Ent: TKisEntity;
begin
  with TKisLicensedOrgMngr(AppModule[kmLicensedOrgs]) do
  begin
    Ent := KisObject(SelectEntity).AEntity;
    if Assigned(Ent) then
    with TKisGivenMapListEditor(EntityEditor) do
    begin
      edOrgname.Text := TKisLicensedOrg(Ent).Name;
      edContacter.Text := TKisLicensedOrg(Ent).MapperFio;
      LicensedOrgId := Ent.ID;
    end;
  end;
end;

{ TGivenMapCtrlr }

procedure TGivenMapCtrlr.FillFieldDefs(FieldDefsRef: TFieldDefs);
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
    Name := SF_MAP_500_ID;
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
end;

function TGivenMapCtrlr.GetFieldData(Index: Integer; Field: TField;
  out Data): Boolean;
var
  Ent: TKisGivenMap;
begin
  try
    Ent := TKisGivenMap(Elements[Index]);
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
    else
      raise EDatabaseError.CreateFmt(S_FIELD_NOT_FOUND, [Field.FieldName]);
    end;
    Result := True;
  except
    Result := False;
  end;
end;

function TGivenMapCtrlr.GetGivenMaps(const Index: Integer): TKisGivenMap;
begin
  Result := TKisGivenMap(Elements[Index]);
end;

function TGivenMapCtrlr.GetLastHolderName: String;
begin
  Result := '';
  if Count > 0 then
    Result := TkisGivenMap(Elements[Pred(Count)]).HolderName;
end;

procedure TGivenMapCtrlr.SetFieldData(Index: Integer; Field: TField;
  var Data);
var
  Ent: TKisGivenMap;
begin
  try
    Ent := TKisGivenMap(Elements[Index]);
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
    end;
  except
  end;
end;

procedure TKisMap500HistoryElement.Copy(Source: TKisEntity);
begin
  inherited;
  with Source as TKisMap500HistoryElement do
    Self.FMap500Id := FMap500Id;
end;

function TKisMap500HistoryElement.CreateFigureInstance: TKisMapHistoryFigure;
begin
  Result := TKisMap500Figure.Create(Manager);
end;

class function TKisMap500HistoryElement.EntityName: String;
begin
  Result := 'Формуляр планшета 1:500';
end;

procedure TKisMap500HistoryElement.Load(DataSet: TDataSet);
begin
  inherited;
  Map500Id := DataSet.FieldByName(SF_MAP_500_ID).AsInteger;
end;


procedure TKisMap500HistoryElement.SetMap500Id(const Value: Integer);
begin
  if FMap500Id <> Value then
  begin
    FMap500Id := Value;
    Modified := True;
  end;
end;

{ TMapHistoryCtrlr }

procedure TMap500HistoryCtrlr.FillFieldDefs(FieldDefsRef: TFieldDefs);
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
    Name := SF_MAP_500_ID;
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
    Name := SF_EXECUTOR;
  end;
end;

function TMap500HistoryCtrlr.GetFieldData(Index: Integer; Field: TField;
  out Data): Boolean;
var
  Ent: TKisMapHistoryElement;
begin
  try
    Ent := TKisMapHistoryElement(Elements[Index]);
    case Field.FieldNo of
    1 : GetInteger(Ent.ID, Data);
    2 : GetInteger(Ent.HeadId, Data);
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
    else
      raise EDatabaseError.CreateFmt(S_FIELD_NOT_FOUND, [Field.FieldName]);
    end;
    Result := True;
  except
    Result := False;
  end;
end;

procedure TMap500HistoryCtrlr.SetFieldData(Index: Integer; Field: TField;
  var Data);
var
  Ent: TKisMapHistoryElement;
begin
  try
    Ent := TKisMapHistoryElement(Elements[Index]);
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
    end;
  except
  end;
end;

{ TKisScanning }

function TKisScanning.CheckEditor(AEditor: TKisEntityEditor): Boolean;
Var
  D: TDateTime;
begin
  Result := False;
  if AEditor is TKisScanningListEditor then
    with AEditor as TKisScanningListEditor do
    begin
      if (Length(Trim(edDateOfScan.Text)) = 0) or not TryStrToDate(edDateOfScan.Text, D) or
            ((D > Date) or (D < MIN_DOC_DATE)) then
          begin
            AppModule.Alert(S_CHECK_DATE_OF_SCAN);
            edDateOfScan.SetFocus;
            Exit;
          end;
      if (Length(Trim(edOrderNumber.Text)) = 0) then
      begin
        AppModule.Alert(S_CHECK_ORDER_NUMBER);
        edOrderNumber.SetFocus;
        Exit;
      end;
      if (Length(Trim(cbOffice.Text)) = 0) then
      begin
        AppModule.Alert(S_CHECK_OFFICE);
        cbOffice.SetFocus;
        Exit;
      end;
      if (Length(Trim(cbExecutor.Text)) = 0) then
      begin
        AppModule.Alert(S_CHECK_EXECUTOR);
        cbExecutor.SetFocus;
        Exit;
      end;
      if (Length(Trim(edWorkType.Text)) = 0) then
      begin
        AppModule.Alert(S_CHECK_WORK_TYPE);
        edWorkType.SetFocus;
        Exit;
      end;
  end;
  Result := True;
end;

procedure TKisScanning.Copy(Source: TKisEntity);
begin
  inherited;
  with Source as TKisScanning do
  begin
    Self.FMap500Id := FMap500Id;
    Self.FDateOfScan := FDateOfScan;
    Self.FOrderNumber := FOrderNumber;
    Self.FOrdersId := FOrdersId;
    Self.FOfficesId := FOfficesId;
    Self.FPeopleId := FPeopleId;
    Self.FWorkType := FWorkType;
    Self.FOfficeName := FOfficeName;
    Self.FPeopleName := FPeopleName;
  end;
end;

function TKisScanning.CreateEditor: TKisEntityEditor;
begin
  Result := TKisScanningListEditor.Create(Application);
end;

class function TKisScanning.EntityName: String;
begin
  Result := 'Список сканирования';
end;

procedure TKisScanning.Load(DataSet: TDataSet);
begin
  inherited;
  with DataSet do
  begin
    ID := FieldByName(SF_ID).AsInteger;
    Map500Id := FieldByName(SF_MAP_500_ID).AsInteger;
    DateOfScan := FieldByName(SF_DATE_OF_SCAN).AsString;
    OfficesId := FieldByName(SF_OFFICES_ID).AsInteger;
    OrderNumber := FieldByName(SF_ORDER_NUMBER).AsString;
    OrdersId := FieldByName(SF_ORDERS_ID).AsInteger;
    PeopleId := FieldByName(SF_PEOPLE_ID).AsInteger;
    WorkType := FieldByName(SF_WORK_TYPE).AsString;
    OfficeName := FieldByName(SF_OFFICE_NAME).AsString;
    PeopleName := FieldByName(SF_EXECUTOR).AsString;
    Self.Modified := True;
  end;
end;

procedure TKisScanning.LoadDataIntoEditor(AEditor: TKisEntityEditor);
begin
  inherited;
  with AEditor as TKisScanningListEditor do
  begin
    edOrderNumber.Text := OrderNumber;
    edDateOfScan.Text := DateOfScan;
    edWorkType.Text := WorkType;
    ComboLocate(cbOffice, OfficesId);
    LoadPeopleList(nil);
    ComboLocate(cbExecutor, PeopleId);
  end;
end;

procedure TKisScanning.LoadPeopleList(Sender: TObject);
var
  P: Integer;
begin
  with EntityEditor as TKisScanningListEditor do
  begin
    if cbOffice.ItemIndex < 0 then
      cbExecutor.Items.Clear
    else
    begin
      cbExecutor.Text := '';
      P := Integer(cbOffice.Items.Objects[cbOffice.ItemIndex]);
      cbExecutor.Items := IStringList(AppModule.PeolpeList(P)).StringList;
    end;
  end;
end;

procedure TKisScanning.PrepareEditor(AEditor: TKisEntityEditor);
begin
  inherited;
  with AEditor as TKisScanningListEditor do
  begin
    cbOffice.Items := IStringList(AppModule.Lists[klOffices]).StringList;
    cbOffice.OnChange := LoadPeopleList;
  end;
end;

procedure TKisScanning.ReadDataFromEditor(AEditor: TKisEntityEditor);
begin
  inherited;
  with AEditor as TKisScanningListEditor do
  begin
    OrderNumber := Trim(edOrderNumber.Text);
    DateOfScan := Trim(edDateOfScan.Text);
    if cbOffice.ItemIndex < N_ZERO then
      OfficesId := N_ZERO
    else
      OfficesId := Integer(cbOffice.Items.Objects[cbOffice.ItemIndex]);
    if cbExecutor.ItemIndex < N_ZERO then
      PeopleId := N_ZERO
    else
      PeopleId := Integer(cbExecutor.Items.Objects[cbExecutor.ItemIndex]);
    WorkType := Trim(edWorkType.Text);
    OfficeName := Trim(cbOffice.Text);
    PeopleName := Trim(cbExecutor.Text);
  end;
end;

procedure TKisScanning.SetDateOfScan(const Value: String);
begin
  if FDateOfScan <> Value then
  begin
    FDateOfScan := Value;
    Modified := True;
  end;
end;

procedure TKisScanning.SetMap500Id(const Value: Integer);
begin
  if FMap500Id <> Value then
  begin
    FMap500Id := Value;
    Modified := True;
  end;
end;

procedure TKisScanning.SetOfficeName(const Value: String);
begin
  if FOfficeName <> Value then
  begin
    FOfficeName := Value;
    Modified := True;
  end;
end;

procedure TKisScanning.SetOfficesId(const Value: Integer);
begin
  if FOfficesId <> Value then
  begin
    FOfficesId := Value;
    Modified := True;
  end;
end;

procedure TKisScanning.SetOrderNumber(const Value: String);
begin
  if FOrderNumber <> Value then
  begin
    FOrderNumber := Value;
    Modified := True;
  end;
end;

procedure TKisScanning.SetOrdersId(const Value: Integer);
begin
  if FOrdersId <> Value then
  begin
    FOrdersId := Value;
    Modified := True;
  end;
end;

procedure TKisScanning.SetPeopleId(const Value: Integer);
begin
  if FPeopleId <> Value then
  begin
    FPeopleId := Value;
    Modified := True;
  end;
end;

procedure TKisScanning.SetPeopleName(const Value: String);
begin
  if FPeopleName <> Value then
  begin
    FPeopleName := Value;
    Modified := True;
  end;
end;

procedure TKisScanning.SetWorkType(const Value: String);
begin
  if FWorkType <> Value then
  begin
    FWorkType := Value;
    Modified := True;
  end;
end;

{ TScanningCtrlr }

procedure TScanningCtrlr.FillFieldDefs(FieldDefsRef: TFieldDefs);
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
    Name := SF_MAP_500_ID;
  end;
  with FieldDefsRef.AddFieldDef do
  begin
    DataType := ftString;
    FieldNo := 3;
    Size := 10;
    Name := SF_DATE_OF_SCAN;
  end;
  with FieldDefsRef.AddFieldDef do
  begin
    DataType := ftInteger;
    FieldNo := 4;
    Name := SF_OFFICES_ID;
  end;
  with FieldDefsRef.AddFieldDef do
  begin
    DataType := ftString;
    FieldNo := 5;
    Size := 10;
    Name := SF_ORDER_NUMBER;
  end;
  with FieldDefsRef.AddFieldDef do
  begin
    DataType := ftInteger;
    FieldNo := 6;
    Name := SF_ORDERS_ID;
  end;
  with FieldDefsRef.AddFieldDef do
  begin
    DataType := ftInteger;
    FieldNo := 7;
    Name := SF_PEOPLE_ID;
  end;
  with FieldDefsRef.AddFieldDef do
  begin
    DataType := ftString;
    FieldNo := 8;
    Size := 50;
    Name := SF_WORK_TYPE;
  end;
  with FieldDefsRef.AddFieldDef do
  begin
    DataType := ftString;
    FieldNo := 9;
    Size := 78;
    Name := SF_EXECUTOR;
  end;
  with FieldDefsRef.AddFieldDef do
  begin
    DataType := ftString;
    FieldNo := 10;
    Size := 80;
    Name := SF_OFFICE_NAME;
  end;
end;

function TScanningCtrlr.GetFieldData(Index: Integer; Field: TField;
  out Data): Boolean;
var
  Ent: TKisScanning;
begin
  try
    Ent := TKisScanning(Elements[Index]);
    case Field.FieldNo of
    1 : GetInteger(Ent.ID, Data);
    2 : GetInteger(Ent.HeadId, Data);
    3 : if Ent.DateOfScan <> '' then
          GetString(Ent.DateOfScan, Data)
        else
        begin
          Result := False;
          Exit;
        end;
    4 : GetInteger(Ent.OfficesId, Data);
    5 : GetString(Ent.OrderNumber, Data);
    6 : GetInteger(Ent.OrdersId, Data);
    7 : GetInteger(Ent.PeopleId, Data);
    8 : GetString(Ent.WorkType, Data);
    9 : GetString(Ent.PeopleName, Data);
    10 : GetString(Ent.OfficeName, Data);
    else
      raise EDatabaseError.CreateFmt(S_FIELD_NOT_FOUND, [Field.FieldName]);
    end;
    Result := True;
  except
    Result := False;
  end;

end;

procedure TScanningCtrlr.SetFieldData(Index: Integer; Field: TField;
  var Data);
var
  Ent: TKisScanning;
begin
  try
    Ent := TKisScanning(Elements[Index]);
    case Field.FieldNo of
    1 : Ent.ID := SetInteger(Data);
    3 : Ent.DateOfScan := SetString(Data);
    4 : Ent.OfficesId := SetInteger(Data);
    5 : Ent.OrderNumber := SetString(Data);
    6 : Ent.OrdersId := SetInteger(Data);
    7 : Ent.PeopleId := SetInteger(Data);
    8 : Ent.WorkType := SetString(Data);
    9 : Ent.PeopleName := SetString(Data);
    10 : Ent.OfficeName := SetString(Data);
    end;
  except
  end;
end;

procedure TKisMap500Mngr.SaveGivenMap(MapList: TKisEntity);
var
  Conn: IKisConnection;
begin
  Conn := GetConnection(True, True);
  with MapList as TKisGivenMap do
  with TIBQuery.Create(Self) do
  try
    Forget;
    SetOrderId(keGivenMap, Maplist);
    Transaction := Conn.Transaction;
    BufferChunks := 10;
    SQL.Text := SQ_SAVE_GIVEN_MAP_LIST;
    if MapList.ID < 1 then
      MapList.ID := Self.GenEntityID(keGivenMap);
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
    ExecSQL;
  finally
    FreeConnection(Conn, True);
  end;
end;

procedure TKisMap500Mngr.SaveMap500(Map500: TKisEntity);
var
  I: Integer;
  Conn: IKisConnection;
  DataSet: TDataSet;
begin
  Conn := GetConnection(True, True);
  with Map500 as TKisMap500 do
  try
    DataSet := Conn.GetDataSet(SQ_SAVE_MAP_500);
    if ID < 1 then
      ID := Self.GenEntityID(keMap500);
    Conn.SetParam(DataSet, SF_ID, ID);
    Conn.SetParam(DataSet, SF_ANNUL_DATE, AnnulDate);
    Conn.SetParam(DataSet, SF_BASIS_TYPE, BasisType);
    Conn.SetParam(DataSet, SF_MAP_ORIGIN_ORG, MapOriginOrg);
    Conn.SetParam(DataSet, SF_NOMENCLATURE, Nomenclature);
    Conn.SetParam(DataSet, SF_NUMBER, Number);
    Conn.SetParam(DataSet, SF_ORIGIN_YEAR, OriginYear);
    Conn.SetParam(DataSet, SF_STATUS, Integer(Status));
    Conn.SetParam(DataSet, SF_IS_SECRET, Integer(Secret));
    //SF_IS_SECRET
    DataSet.Open;

    // Сохраняем список выдачи планшетов
    with FGivenMapCtrlr do
    begin
      for I := 1 to Count do
        if Elements[I].Modified then
          Self.SaveEntity(Elements[I]);
      for I := 0 to Pred(DeletedCount) do
        Self.DeleteEntity(DeletedElements[I]);
    end;

    // Сохраняем историю планшета
    with FMapHistoryCtrlr do
    begin
      for I := 1 to Count do
      begin
        if Elements[I].Modified then
          Self.SaveEntity(Elements[I]);
        Self.SaveFigures(Elements[I] as TKisMapHistoryElement);
      end;
      for I := 0 to Pred(DeletedCount) do
        Self.DeleteEntity(DeletedElements[I]);
    end;

    // Сохраняем список сканирования
    with FScanningCtrlr do
    begin
      for I := 1 to Count do
        if Elements[I].Modified then
          Self.SaveEntity(Elements[I]);
      for I := 0 to Pred(DeletedCount) do
        Self.DeleteEntity(DeletedElements[I]);
    end;

    FreeConnection(Conn, True);
  except
    FreeConnection(Conn, False);
    raise;
  end;
end;

procedure TKisMap500Mngr.SaveMapHistoryElement(HistList: TKisEntity);
var
  Conn: IKisConnection;
begin
  Conn := GetConnection(True, True);
  with HistList as TKisMapHistoryElement do
  with TIBQuery.Create(nil) do
  try
    Forget;
    BufferChunks := 10;
    Transaction := Conn.Transaction; 
    SQL.Text := SQ_SAVE_HISTORY_LIST;
    if HistList.ID < 1 then
      HistList.ID := Self.GenEntityID(keMap500HistoryElement);
    Params[0].AsInteger := ID;
    Params[1].AsInteger := HeadId;
    Params[2].AsString := Chief;
    Params[3].AsString := CurrentChangesMapping;
    Params[4].AsString := DateOfAccept;
    Params[5].AsString := DateOfWorks;
    Params[6].AsString := DraftWorksExecutor;
    Params[7].AsString := EnginNetMapping;
    Params[8].AsString := HighRiseMapping;
    Params[9].AsString := HorizontalMapping;
    Params[10].AsString := MensMapping;
    Params[11].AsString := NewlyBuildingMapping;
    Params[12].AsString := OrderNumber;
    Params[13].AsString := TacheometricMapping;
    Params[14].AsString := TotalSum;
    Params[15].AsString := WorksExecutor;
    ExecSQL;
  finally
    FreeConnection(Conn, True);
  end;
end;

procedure TKisMap500Mngr.SaveScanning(ScanList: TKisEntity);
var
  Conn: IKisConnection;
begin
  /// [!!!] Отключено
  Exit;
  Conn := GetConnection(True, True);
  with ScanList as TKisScanning do
  with TIBQuery.Create(Self) do
  try
    Forget;
    BufferChunks := 10;
    SetOrderId(keScanning, ScanList);
    Transaction := Conn.Transaction;
    SQL.Text := SQ_SAVE_SCANNING_LIST;
    if ScanList.ID < 1 then
      ScanList.ID := Self.GenEntityID(keScanning);
    Params[0].AsInteger := ID;
    Params[1].AsInteger := HeadId;
    Params[2].AsString := DateOfScan;
    Params[3].AsInteger := OfficesId;
    Params[4].AsString := OrderNumber;
    if OrdersId > 0 then
      Params[5].AsInteger := OrdersId
    else
      Params[5].Clear;
    Params[6].AsInteger := PeopleId;
    Params[7].AsString := WorkType;
    ExecSQL;
  finally
    FreeConnection(Conn, True);
  end;
end;

function TKisMap500Mngr.GetRefreshSQLText: String;
begin
  Result := GetMainSQLText + ' WHERE M.ID=:ID';
end;

function TKisMap500Mngr.GetMainDataSet: TDataSet;
begin
  Result := dsMap500;
end;

function TKisMap500Mngr.FindOfficeId(GivenMap: TKisEntity;
  out OffId: Integer): Boolean;
var
  Conn: IKisConnection;
begin
  Conn := GetConnection(True, True);
  with GivenMap as TKisGivenMap do
  begin
    with Conn.GetDataSet(Format(SQ_FIND_OFFICE_ID, [PeopleId])) do
    try
      Open;
      OffId := FieldByName(SF_OFFICES_ID).AsInteger;
      Result := RecordCount > 0;
      Close;
    finally
      FreeConnection(Conn, True);
    end;
  end;
end;

procedure TKisMap500Mngr.SetOrderIdInGivenMap(Ent: TKisEntity);
Var
  Conn: IKisConnection;
  OffId: Integer;
begin
  Conn := GetConnection(True, True);
  with Ent as TKisGivenMap do
    begin
      if not Holder then
      begin
        if FindOfficeId(Ent, OffId) then
           OfficeId := OffId;
        with Conn.GetDataSet(Format(SQ_FIND_ORDER, [OfficeId, OrderNumber])) do
        try
          Open;
          OrdersId := FieldByName(SF_ID).AsInteger;
          Close;
        finally
          FreeConnection(Conn, True);
        end;
      end;
  end;
end;

procedure TKisMap500Mngr.SetOrderIdInScanning;
Var
  Conn: IKisConnection;
  OfficeId: Integer;
begin
  Conn := GetConnection(True, True);
  with Ent as TKisScanning do
    begin
      OfficeId := TKisScanning(Ent).OfficesId;
      with Conn.GetDataSet(Format(SQ_FIND_ORDER, [OfficeId, OrderNumber])) do
        try
          Open;
          OrdersId := FieldByName(SF_ID).AsInteger;
          Close;
        finally
          FreeConnection(Conn, True);
        end;
    end;
end;

procedure TKisMap500Mngr.AddFigure(HistElement: TKisEntity; FigureId: Integer);
var
  Conn: IKisConnection;
  Figure: TKisMap500Figure;
  DataSet: TDataSet;
begin
  Conn := GetConnection(True, False);
  DataSet := Conn.GetDataSet(Format(SQ_SELECT_FIGURE, [FigureId]));
  with DataSet do
  try
    Open;
    Figure := TKisMap500Figure(CreateEntity(keMap500HistoryFigure));
    Figure.Load(DataSet);
    while not Eof do
    begin
      Figure.AddPoint(FieldByName(SF_X).AsInteger, FieldByName(SF_Y).AsInteger);
      Next;
    end;
  finally
    FreeConnection(Conn, True);
  end;
  with HistElement as TKisMap500HistoryElement do
    AddFigure(Figure);
end;

procedure TKisMap500Mngr.GetHistoryElementFigures(HistoryElementId: Integer; HistElement: TKisMap500HistoryElement);
var
  Conn: IKisConnection;
begin
  Conn := GetConnection(True, False);
  with Conn.GetDataSet(Format(SQ_GET_FIGURE_NUMBERS, [HistoryElementId])) do
  try
    Open;
    while not Eof do
    begin
      AddFigure(HistElement, FieldByName(SF_ID).AsInteger);
      Next;
    end;
  finally
    FreeConnection(Conn, True);
  end;
end;

procedure TKisMap500Mngr.SaveFigures(HistElement: TKisMapHistoryElement);
var
  I: Integer;
  Conn: IKisConnection;
  DataSet: TDataSet;
begin
  with HistElement as TKisMapHistoryElement do
  begin
    Conn := GetConnection(True, True);
    with Conn do
    try
      for I := 0 to Pred(FigureCount) do
      with Figures[I] do
      begin
        DataSet := GetDataSet(SQ_SAVE_FIGURE);
        if ID < 1 then
          ID := Self.GenEntityID(keMap500HistoryFigure);
        SetParam(DataSet, SF_ID, ID);
        SetParam(DataSet, SF_HISTORY_ELEMENT_ID, HistoryElementId);
        SetParam(DataSet, SF_FIGURE_COLOR, FigureColor);
        SetParam(DataSet, SF_FIGURE_TYPE, Integer(FigureType));
        SetParam(DataSet, SF_EXTENT_BOTTOM, Extent.Bottom);
        SetParam(DataSet, SF_EXTENT_LEFT, Extent.Left);
        SetParam(DataSet, SF_EXTENT_RIGHT, Extent.Right);
        SetParam(DataSet, SF_EXTENT_TOP, Extent.Top);
        DataSet.Open;
        SaveFigurePoints(Figures[I] as TKisMap500Figure);
      end;
      FreeConnection(Conn, True);
    except
      FreeConnection(Conn, False);
      raise;
    end;
  end;
end;

procedure TKisMap500Mngr.LoadHistory(const SQLText: String;
  Map500: TKisEntity; FCtrlr: TKisEntityController);
var
  Conn: IKisConnection;
  Tmp: TKisEntity;
  Index: Integer;
begin
  Conn := GetConnection(True, True);
  with Map500 as TKisMap500 do
  with Conn.GetDataSet(Format(SQLText, [ID])) do
  try
    Open;
    Index := 0;
    while not Eof do
    begin
      Tmp := Self.GetEntity(FieldByName(SF_ID).AsInteger, keMap500HistoryElement);
      if Assigned(Tmp) then
      begin
         Index := Index + 1;
         FCtrlr.DirectAppend(Tmp);
         GetHistoryElementFigures(FieldByName(SF_ID).AsInteger, TKisMap500HistoryElement(FCtrlr.Elements[Index]));
      end;
      Next;
    end;
  finally
     FreeConnection(Conn, True);
  end;
end;

procedure TKisMap500Mngr.acGiveMapExecute(Sender: TObject);
var
  Conn: IKisConnection;
  Map: TKisMap500;
begin
  Conn := GetConnection(True, True);
  try
    Map := KisObject(CurrentEntity).AEntity as TKisMap500;
    Map.Modified := False;
    Map.GiveOutMap;
    if Map.Modified then
      SaveEntity(Map);
    FreeConnection(Conn, True);
    dsMap500.Refresh;
  except
    FreeConnection(Conn, False);
    raise;
  end;
end;

procedure TKisMap500Mngr.acBackMapExecute(Sender: TObject);
var
  Conn: IKisConnection;
  Map: TKisMap500;
begin
  Conn := GetConnection(True, True);
  try
    Map := KisObject(CurrentEntity).AEntity as TKisMap500;
    Map.Modified := False;
    if Map.GiveBackMap then
      SaveEntity(Map);
    FreeConnection(Conn, True);
    dsMap500.Refresh;
  except
    FreeConnection(Conn, False);
    raise;
  end;
end;

procedure TKisMap500Mngr.acGiveMapUpdate(Sender: TObject);
begin
  inherited;
  acGiveMap.Enabled := (not dsMap500.IsEmpty) and Boolean(dsMap500STATUS.AsInteger)
    and not Boolean(dsMap500GIVE_STATUS.AsInteger);
end;

procedure TKisMap500Mngr.acGoToScansExecute(Sender: TObject);
var
  Ent: TKisEntity;
  Val: Variant;
  Found: Boolean;
begin
  inherited;
  Found := False;
  if AppModule.GetFieldValue(dsMap500.Transaction, ST_MAP_SCANS,
    SF_NOMENCLATURE, SF_ID, dsMap500NOMENCLATURE.AsString, Val) then
  begin
    Ent := AppModule.SQLMngrs[kmMapScans].GetEntity(Val, keMapScan);
    if Assigned(Ent) then
    begin
      Found := True;
      AppModule.SQLMngrs[kmMapScans].ShowEntities(nil, Val);
    end;
  end;
  if not Found then
    MessageBox(Application.Handle, 'Планшет не отсканирован!', 'Ошибка', MB_OK + MB_ICONWARNING);
end;

procedure TKisMap500Mngr.acBackMapUpdate(Sender: TObject);
begin
  inherited;
  acBackMap.Enabled := (not dsMap500.IsEmpty) and Boolean(dsMap500STATUS.AsInteger)
    and Boolean(dsMap500GIVE_STATUS.AsInteger);
end;

procedure TKisMap500Mngr.GridCellColors(Sender: TObject; Field: TField;
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
//      if Field.FieldName = SF_NOMENCLATURE then
      if Boolean(dsMap500SCAN_STATUS.AsInteger) then
        BackGround := $E4B59E
      else
      if dsMap500IS_SECRET.AsInteger = 1 then
      begin
        BackGround := $CCFFCC;
      end
      else
      if dsMap500EXPIRED.AsInteger = 1 then
        BackGround := $9999FF
      else
      if dsMap500GIVE_STATUS.AsInteger = 1 then
      begin
        BackGround := $99FFFF;
        FontColor := clNavy;
      end;
    end;
  //ed выделение цифрового планшета толстым синим шрифтои
  if dsMap500BASIS_TYPE.AsString = 'цифра' then
  begin
    FontColor := clBlue;
    FontStyle := [fsbold];
  end
  else
  /// выделение толстым зеленым шрифтом планшета тока в векторе
  if dsMap500BASIS_TYPE.AsString = 'вектор' then
  begin
    FontColor := $00BF00;
    FontStyle := [fsbold];
  end;
  //end ed
end;

procedure TKisMap500Mngr.GridGetLogicalValue(Sender: TObject; Column: TColumn;
  var Value: Boolean);
begin
  Value := Boolean(Column.Field.AsInteger);
end;

procedure TKisMap500Mngr.GridLogicalColumn(Sender: TObject; Column: TColumn;
  var IsLogical: Boolean);
begin
  IsLogical := (Column.Field = dsMap500SCAN_STATUS) or
    (Column.Field = dsMap500EXPIRED) or
    (Column.Field = dsMap500GIVE_STATUS) or
    (Column.Field = dsMap500STATUS) or
    (Column.Field = dsMap500IS_SECRET);
end;

procedure TKisMap500Mngr.SaveFigurePoints(aFigure: TKisMap500Figure);
var
  I: Integer;
  Conn: IKisConnection;
  DataSet: TDataSet;
begin
  Conn := GetConnection(True, True);
  try
    DataSet := Conn.GetDataSet(Format(SQ_DELETE_FIGURE_POINTS, [aFigure.ID]));
    DataSet.Open;
    DataSet := Conn.GetDataSet(SQ_SAVE_FIGURE_POINT);
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
    FreeConnection(Conn, True);
  except
    FreeConnection(Conn, False);
    raise;
  end;
end;

procedure TKisMap500Mngr.acLegendExecute(Sender: TObject);
begin
  inherited;
  with FView do
    Legend.ShowLegend(ClientHeight - Legend.FormHeight,
                      ClientWidth - Legend.FormWidth - 10);
end;

procedure TKisMap500Mngr.acPrintExecute(Sender: TObject);
begin
  inherited;
  with PrintModule do
  begin
    ReportFile := AppModule.ReportsPath + 'КГО\Планшеты_с_экрана.frf';
    ReportTitle := 'Список планшетов';
    SetMasterDataSet(dsMap500, 'MasterData');
    PrintReport;
  end;
end;

{ TKisMap500Figure }

function TKisMap500Figure.Clone: TKisMapHistoryFigure;
begin
  Result := TKisMap500Figure.Create(Manager);
  Result.Copy(Self);
end;

class function TKisMap500Figure.EntityName: String;
begin
  Result := 'Область изменения планшета';
end;

end.
