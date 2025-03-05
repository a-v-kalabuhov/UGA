unit uMStModuleMasterPlan;

interface

uses
  SysUtils, Classes, Windows, Dialogs, Math, Variants, Graphics,
  IBCustomDataSet, IBUpdateSQL, DB, IBQuery, IBDatabase,
  EzBaseGIS, EzLib, EzBase,
  RxMemDS,
  uCommonUtils, uGC,
  uEzEntityCSConvert,
  uMStConsts,
  uMStClassesProjects, uMStClassesProjectsMP, uMStKernelGISUtils, uMStClassesMasterPlan, uMStKernelIBX,
  uMStModuleProjectImport, uMStClassesProjectsEz, uMStClassesMPClassif, uMStClassesMPIntf, uMStKernelClasses,
  uMStFormMPBrowser, uMStKernelClassesQueryIndex, uMStKernelAppSettings, uMStClassesMPObjectAdapter,
  uMStDialogMPObjectSemantics, uMStClassesMPMIFExport;

type
  TObjIdEvent = procedure (ObjId: Integer) of object;
  TmstMasterPlanModule = class(TDataModule, ImstMPModule, ImstMPModuleObjList)
    memObjects: TRxMemoryData;
    memBrowser: TRxMemoryData;
    memEzData: TRxMemoryData;
  private
    FDrawBox: TEzBaseDrawBox;
    FImport: TmstProjectImportModule;
    FImportObjState: TmstMPObjectState;
    FImportLayerName: string;
    procedure GetImportLayer(Sender: TObject; out Layer: TEzBaseLayer);
    procedure DoImportExecuted(Sender: TObject; Cancelled: Boolean; aProject: TmstProject);
    function DoCreateProject(): TmstProject;
    function DoCreatePrjReader(): IEzProjectReader;
    procedure DoGetAppSettings(out AppSettings: ImstAppSettings);
    procedure DoGetDb(out aDb: IDb);
    procedure DoGetProjectSaver(out Saver: IProjectSaver);
  private
    FBrowserForm: TmstMPBrowserForm;
    FClassifier: TmstMPClassifier;
    FOnGetAppSettings: TGetAppSettingsEvent;
    FOnGetDb: TGetDbEvent;
    //
    procedure UpdateLayerVisibility(aLayer: TmstLayer);
    function RefreshObjList(): Boolean;
    procedure PrepareBrowserDataSet();
    procedure ApplyChanedRecords(DsChanges: TDataSet; ToUpdate, ToDelete: TIntegerList);
    procedure DeleteRow(Ds: TDataSet; const ObjId: Integer);
    function GetIdx(Ds: TDataSet): TQueryRowIndex;
    procedure FillQueryIndex(Idx: TQueryRowIndex; Ds: TDataSet);
    procedure RefreshRows(DsChanges, DsData: TDataSet; ToUpdate: TIntegerList;
      OnRowRefresh: TObjIdEvent);
    procedure AppendNewRows(DsChanges, DsData: TDataSet; ToInsert: TIntegerList; Idx: TQueryRowIndex);
    procedure RefreshSingleRow(DsChanges, DsData: TDataSet);
    function GetMPTableVersion(Conn: IIBXConnection): Integer;
    procedure ReloadObjectToGis(ObjId: Integer);
    function GetMPLayer: TEzBaseLayer;
  protected
    procedure SetAppSettingsEvent(aEvent: TGetAppSettingsEvent);
    procedure SetDbEvent(Value: TGetDbEvent);
    procedure SetDrawBox(aDrawBox: TEzBaseDrawBox);
    function Classifier: TmstMPClassifier;
    procedure DisplayNavigator(aDrawBox: TEzBaseDrawBox);
    procedure NavigatorClosed();
    procedure ImportDXF(const aObjState: TmstMPObjectState);
  private
    FIdxObjects: TQueryRowIndex;
    FIdxBrowser: TQueryRowIndex;
    FIdxEz: TQueryRowIndex;
    FTableVersion: Integer;
    /// <summary>
    /// Загружает данные по сводному плану в память из базы данных.
    /// </summary>
    procedure LoadFromDb();
    //
    function GetObjByDbId(const ObjId: Integer; LoadEzData: Boolean): TmstMPObject;
    procedure DeleteObj(const ObjId: Integer);
    function EditObjProperties(const ObjId: Integer): Boolean;
    function EditNewObject(const MpObj: TmstMPObject): Boolean;
    function IsObjectVisible(const ObjId: Integer; var aLineColor: TColor): Boolean;
    procedure UpdateLayersVisibility(aLayers: TmstLayerList);
    //
    function HasLoaded(): Boolean;
    function IsLoaded(const ObjId: Integer): Boolean;
    procedure LoadAllToGIS();
    procedure LoadToGis(const ObjId: Integer; const Display: Boolean);
    procedure UnloadAllFromGis();
    function UnloadFromGis(const ObjId: Integer): Boolean;
    //
    procedure GiveOutCertif(const ObjId: Integer; CertifNumber: string; CertifDate: TDateTime);
    procedure CopyToDrawn(const ObjId: Integer);
    function BrowserDataSet(): TDataSet;
    procedure ExportToMif(const aMifFileName: string);
  private
    FMPAdapter: TmstMPObjectAdapter;
    FEzAdapter: TmstMPObjectEzAdapter;
    procedure GetDateTimeText(Sender: TField; var Text: string; DisplayText: Boolean);
    // обновляет данные в детальном датасете
    procedure RefreshMPObjectData(aObj: TmstMPObject);
    // сохраняет в базу
    procedure SaveMPObjectCoords(aObj: TmstMPObject);
    procedure SaveMPObjectSemantics(aObj: TmstMPObject);
    procedure AddCurrentObjToLayer(const Display: Boolean);
    function LocateObj(ObjId: Integer; Ds: TDataSet): Boolean;
    procedure DeleteMpObjFromDb(ObjId: Integer);
  public
    constructor Create(aOwner: TComponent); override;
    destructor Destroy; override;
  end;

implementation

{$R *.dfm}

uses
  uMStClassesProjectsUtils;

const
  SQL_GET_MP_OBJECTS_LIST =
    'SELECT ' +
    '    ID, ' +
    '    MASTER_PLAN_CLASS_ID, ' +
    '    STATUS, ' +
    '    DISMANTLED, ' +
    '    ARCHIVED, ' +
    '    TABLE_VERSION ' +
    'FROM ' +
    '    MASTER_PLAN_OBJECTS ' +
    'ORDER BY ID';

  SQL_GET_EZ_DATA_LIST =
    'SELECT ' +
    '    ID, ' +
    '    EZDATA, ' +
    '    EZ_ID, ' +
    '    LOADED, ' +
    '    EZ_RECNO ' +
    'FROM ' +
    '    MASTER_PLAN_OBJECTS ' +
    'ORDER BY ID';

  SQL_GET_MP_CLASSIFIER =
    'SELECT PL.ID, PL.NAME, PL.CLASS_ID, PL.MP_NET_TYPES_ID AS MP_CATEGORY_ID, MPL.LINE_COLOR '
  + 'FROM PROJECT_LAYERS PL '
  + '     LEFT JOIN MASTER_PLAN_LAYERS MPL ON (PL.MP_NET_TYPES_ID = MPL.ID) '
  + 'ORDER BY PL.NAME ';
//    'SELECT PL.ID, PL.NAME, PL.CLASS_ID, PL.MP_NET_TYPES_ID AS MP_CATEGORY_ID,  '
//  + 'FROM PROJECT_LAYERS PL '
//  + 'ORDER BY PL.NAME ';

  SQL_GET_MP_OBJECTS_LIST_UPDATED =
    'SELECT '
    + 'MPO.ID, '
    + 'MPO.OBJ_ID, '
    + 'MPO.LINKED_OBJ_ID, '
    + 'MPO.MASTER_PLAN_CLASS_ID, '
    + 'MPO.STATUS, '
    + 'MPO.DISMANTLED, '
    + 'MPO.ARCHIVED, '
    + 'MPO.CONFIRMED, '
    + 'MPO.DRAWN, '
    + 'MPO.PROJECTED, '
    + 'MPO.ADDRESS, '
    + 'MPO.DOC_NUMBER, '
    + 'MPO.DOC_DATE, '
    + 'MPO.REQUEST_NUMBER, '
    + 'MPO.REQUEST_DATE, '
    + 'MPO.UNDERGROUND, '
    + 'MPO.DIAMETER, '
    + 'MPO.PIPE_COUNT, '
    + 'MPO.VOLTAGE, '
    + 'MPO.MATERIAL, '
    + 'MPO.TOP, '
    + 'MPO.BOTTOM, '
    + 'MPO.FLOOR, '
    + 'MPO.OWNER, '
    + 'MPO.DRAW_DATE, '
    + 'MPO.IS_LINE, '
    + 'MPO.ROTATION, '
    + 'MPO.EZDATA, '
    + 'MPO.EZ_ID, '
    + 'MPO.MINX, '
    + 'MPO.MINY, '
    + 'MPO.MAXX, '
    + 'MPO.MAXY, '
    + 'MPO.PROJECT_NAME, '
    + 'MPO.CUSTOMER_ORGS_ID, '
    + 'MPO.EXECUTOR_ORGS_ID, '
    + 'MPO.OWNER_ORG_ID, '
    + 'MPO.DRAW_ORGS_ID, '
    + 'MPO.HAS_CERTIF, '
    + 'MPO.CERTIF_NUMBER, '
    + 'MPO.CERTIF_DATE, '
    + 'MPO.CHECK_STATE, '
    + 'MPO.DELETED, '
    + 'MPO.TABLE_VERSION, '
    + 'PL.NAME AS LAYER_NAME, '
    + 'PL.CLASS_ID, '
    + 'MPOS.NAME AS STATUS_NAME, '
    + 'CUSTOMERS.NAME AS CUSTOMER_NAME, '
    + 'DRAWERS.NAME AS DRAWER_NAME, '
    + 'EXECUTORS.NAME AS EXECUTOR_NAME '
  + 'FROM MASTER_PLAN_OBJECTS MPO '
    + 'LEFT JOIN PROJECT_LAYERS PL ON (MPO.MASTER_PLAN_CLASS_ID = PL.ID) '
    + 'LEFT JOIN MASTER_PLAN_OBJECT_STATUSES MPOS ON (MPO.STATUS = MPOS.ID) '
    + 'LEFT JOIN LICENSED_ORGS CUSTOMERS ON (MPO.CUSTOMER_ORGS_ID = CUSTOMERS.ID) '
    + 'LEFT JOIN LICENSED_ORGS DRAWERS ON (MPO.DRAW_ORGS_ID = DRAWERS.ID) '
    + 'LEFT JOIN LICENSED_ORGS EXECUTORS ON (MPO.EXECUTOR_ORGS_ID = EXECUTORS.ID) '
  + 'WHERE MPO.TABLE_VERSION > :TABLE_VERSION '
  + 'ORDER BY MPO.ID';
    
  SQL_GET_MP_OBJECTS_LIST_FOR_BROWSER =
    'SELECT '
    + 'MPO.ID, '
    + 'MPO.OBJ_ID, '
    + 'MPO.LINKED_OBJ_ID, '
    + 'MPO.MASTER_PLAN_CLASS_ID, '
    + 'MPO.STATUS, '
    + 'MPO.DISMANTLED, '
    + 'MPO.ARCHIVED, '
    + 'MPO.CONFIRMED, '
    + 'MPO.DRAWN, '
    + 'MPO.PROJECTED, '
    + 'MPO.ADDRESS, '
    + 'MPO.DOC_NUMBER, '
    + 'MPO.DOC_DATE, '
    + 'MPO.REQUEST_NUMBER, '
    + 'MPO.REQUEST_DATE, '
    + 'MPO.UNDERGROUND, '
    + 'MPO.DIAMETER, '
    + 'MPO.PIPE_COUNT, '
    + 'MPO.VOLTAGE, '
    + 'MPO.MATERIAL, '
    + 'MPO.TOP, '
    + 'MPO.BOTTOM, '
    + 'MPO.FLOOR, '
    + 'MPO.OWNER, '
    + 'MPO.DRAW_DATE, '
    + 'MPO.IS_LINE, '
    + 'MPO.ROTATION, '
    + 'MPO.EZDATA, '
    + 'MPO.EZ_ID, '
    + 'MPO.MINX, '
    + 'MPO.MINY, '
    + 'MPO.MAXX, '
    + 'MPO.MAXY, '
    + 'MPO.LOADED, '
    + 'MPO.PROJECT_NAME, '
    + 'MPO.CUSTOMER_ORGS_ID, '
    + 'MPO.EXECUTOR_ORGS_ID, '
    + 'MPO.OWNER_ORG_ID, '
    + 'MPO.DRAW_ORGS_ID, '
    + 'MPO.HAS_CERTIF, '
    + 'MPO.CERTIF_NUMBER, '
    + 'MPO.CERTIF_DATE, '
    + 'MPO.CHECK_STATE, '
    + 'MPO.DELETED, '
    + 'MPO.TABLE_VERSION, '
    + 'PL.NAME AS LAYER_NAME, '
    + 'PL.CLASS_ID, '
    + 'MPOS.NAME AS STATUS_NAME, '
    + 'CUSTOMERS.NAME AS CUSTOMER_NAME, '
    + 'DRAWERS.NAME AS DRAWER_NAME, '
    + 'EXECUTORS.NAME AS EXECUTOR_NAME '
  + 'FROM MASTER_PLAN_OBJECTS MPO '
    + 'LEFT JOIN PROJECT_LAYERS PL ON (MPO.MASTER_PLAN_CLASS_ID = PL.ID) '
    + 'LEFT JOIN MASTER_PLAN_OBJECT_STATUSES MPOS ON (MPO.STATUS = MPOS.ID) '
    + 'LEFT JOIN LICENSED_ORGS CUSTOMERS ON (MPO.CUSTOMER_ORGS_ID = CUSTOMERS.ID) '
    + 'LEFT JOIN LICENSED_ORGS DRAWERS ON (MPO.DRAW_ORGS_ID = DRAWERS.ID) '
    + 'LEFT JOIN LICENSED_ORGS EXECUTORS ON (MPO.EXECUTOR_ORGS_ID = EXECUTORS.ID) '
  + 'WHERE MPO.DELETED = 0 '
  + 'ORDER BY MPO.ID';

  SQL_UPDATE_MP_OBJECT_SEMANTICS =
    'UPDATE MASTER_PLAN_OBJECTS SET '
//  + 'MASTER_PLAN_CLASS_ID = :MASTER_PLAN_CLASS_ID, '
  + 'OBJ_ID = :OBJ_ID, '
  + 'LINKED_OBJ_ID = :LINKED_OBJ_ID, '
  + 'STATUS = :STATUS, '
  + 'DISMANTLED = :DISMANTLED, '
  + 'ARCHIVED = :ARCHIVED, '
  + 'CONFIRMED = :CONFIRMED, '
  + 'ADDRESS = :ADDRESS, '
  + 'DOC_NUMBER = :DOC_NUMBER, '
  + 'DOC_DATE = :DOC_DATE, '
  + 'REQUEST_NUMBER = :REQUEST_NUMBER, '
  + 'REQUEST_DATE = :REQUEST_DATE, '
  + 'UNDERGROUND = :UNDERGROUND, '
  + 'DIAMETER = :DIAMETER, '
  + 'PIPE_COUNT = :PIPE_COUNT, '
  + 'VOLTAGE = :VOLTAGE, '
  + 'MATERIAL = :MATERIAL, '
  + 'TOP = :TOP, '
  + 'BOTTOM = :BOTTOM, '
  + 'FLOOR = :FLOOR, '
  + 'OWNER = :OWNER, '
  + 'DRAW_DATE = :DRAW_DATE, '
//  + 'IS_LINE = :IS_LINE, '
  + 'ROTATION = :ROTATION, '
  + 'PROJECT_NAME = :PROJECT_NAME, '
//  + 'CK36 = :CK36, '
  + 'CUSTOMER_ORGS_ID = :CUSTOMER_ORGS_ID, '
  + 'EXECUTOR_ORGS_ID = :EXECUTOR_ORGS_ID, '
  + 'OWNER_ORG_ID = :OWNER_ORG_ID, '
  + 'DRAW_ORGS_ID = :DRAW_ORGS_ID, '
//  + 'DELETED = :DELETED, '
  + 'TABLE_VERSION = :TABLE_VERSION, '
  + 'DRAWN = :DRAWN, '
  + 'PROJECTED = :PROJECTED, '
  + 'CERTIF_DATE = :CERTIF_DATE, '
  + 'CERTIF_NUMBER = :CERTIF_NUMBER, '
  + 'HAS_CERTIF = :HAS_CERTIF, '
  + 'CHECK_STATE = :CHECK_STATE '
  + 'WHERE (ID = :ID)';

  SQL_SET_MP_OBJECT_DELETED =
    'UPDATE MASTER_PLAN_OBJECTS '
  + 'SET DELETED = 1, '
  + 'TABLE_VERSION = :TABLE_VERSION '
  + 'WHERE (ID = :ID)';

  SQL_SET_MP_CERTIF_GIVED_OUT =
    'UPDATE MASTER_PLAN_OBJECTS '
  + 'SET HAS_CERTIF = :HAS_CERTIF, '
  + 'CERTIF_NUMBER = :CERTIF_NUMBER, '
  + 'CERTIF_DATE = :CERTIF_DATE, '
  + 'TABLE_VERSION = :TABLE_VERSION '
  + 'WHERE (ID = :ID)';

  SQL_COPY_MP_OBJECT_TO_DRAWN =
    'INSERT INTO MASTER_PLAN_OBJECTS '
  + '(ID, OBJ_ID, MASTER_PLAN_CLASS_ID, STATUS, DISMANTLED, ARCHIVED, CONFIRMED, ADDRESS, '
  + 'DOC_NUMBER, DOC_DATE, REQUEST_NUMBER, REQUEST_DATE, UNDERGROUND, DIAMETER, PIPE_COUNT, '
  + 'VOLTAGE, MATERIAL, TOP, BOTTOM, FLOOR, OWNER, DRAW_DATE, IS_LINE, ROTATION, EZDATA, '
  + 'EZ_ID, EZ_RECNO, MINX, MINY, MAXX, MAXY, LOADED, PROJECT_NAME, CUSTOMER_ORGS_ID, '
  + 'EXECUTOR_ORGS_ID, OWNER_ORG_ID, DRAW_ORGS_ID, DELETED, TABLE_VERSION, DRAWN, PROJECTED, '
  + 'CERTIF_DATE, CERTIF_NUMBER, HAS_CERTIF, CHECK_STATE, LINKED_OBJ_ID) '
  + 'SELECT :NEW_ID, :OBJ_ID, MASTER_PLAN_CLASS_ID, STATUS, DISMANTLED, ARCHIVED, CONFIRMED, ADDRESS, DOC_NUMBER, DOC_DATE, '
  + 'REQUEST_NUMBER, REQUEST_DATE, UNDERGROUND, DIAMETER, PIPE_COUNT, VOLTAGE, MATERIAL, TOP, BOTTOM, FLOOR, OWNER, '
  + 'DRAW_DATE, IS_LINE, ROTATION, EZDATA, EZ_ID, EZ_RECNO, MINX, MINY, MAXX, MAXY, LOADED, PROJECT_NAME, '
  + 'CUSTOMER_ORGS_ID, EXECUTOR_ORGS_ID, OWNER_ORG_ID, DRAW_ORGS_ID, DELETED, :TABLE_VERSION, 1, PROJECTED, '
  + 'CERTIF_DATE, CERTIF_NUMBER, HAS_CERTIF, CHECK_STATE, :LINKED_OBJ_ID '
  + 'FROM MASTER_PLAN_OBJECTS '
  + 'WHERE ID=:ID';


{ TmstMasterPlanModule }

function TmstMasterPlanModule.Classifier: TmstMPClassifier;
begin
  Result := FClassifier;
end;

procedure TmstMasterPlanModule.CopyToDrawn(const ObjId: Integer);
var
  Db: IDb;
  Conn: IIBXConnection;
  Ds: TDataSet;
  Vrs: Integer;
  NewObjId: Integer;
begin
  DoGetDb(Db);
  Conn := Db.GetConnection(cmReadWrite, dmKis);
  try
    FIdxObjects.GetFirstRow(ObjId);
    Vrs := Conn.GenNextValue(SG_MP_OBJECTS_TABLE_VERSION);
    Ds := Conn.GetDataSet(SQL_COPY_MP_OBJECT_TO_DRAWN);
    Conn.SetParam(Ds, SF_ID, ObjId);
    NewObjId := Conn.GetGenValue(SG_MP_OBJECTS);
    Conn.SetParam(Ds, SF_NEW_ID, NewObjId);
    Conn.SetParam(Ds, SF_TABLE_VERSION, Vrs);
    Conn.SetParam(Ds, SF_OBJ_ID, GetUniqueString(False, True));
    Conn.SetParam(Ds, SF_LINKED_OBJ_ID, FMPAdapter.Id);
    Conn.SetParam(Ds, SF_ID, ObjId);
    Conn.ExecDataSet(Ds);
  finally
    Conn.Commit;
  end;
  //
  RefreshObjList();
end;

constructor TmstMasterPlanModule.Create;
begin
  inherited;
  FClassifier := TmstMPClassifier.Create;
  FIdxObjects := TQueryRowIndex.Create;
  FIdxObjects.UseBinarySearch := True;
  FIdxBrowser := TQueryRowIndex.Create;
  FIdxBrowser.UseBinarySearch := True;
  FIdxEz := TQueryRowIndex.Create;
  FIdxEz.UseBinarySearch := True;
  FMPAdapter := TmstMPObjectAdapter.Create(memObjects);
  FEzAdapter := TmstMPObjectEzAdapter.Create(memEzData);
end;

procedure TmstMasterPlanModule.DeleteMpObjFromDb(ObjId: Integer);
var
  Db: IDb;
  Conn: IIBXConnection;
  Ds: TDataSet;
  Vrs: Integer;
begin
  DoGetDb(Db);
  Conn := Db.GetConnection(cmReadWrite, dmKis);
  try
    Vrs := Conn.GenNextValue(SG_MP_OBJECTS_TABLE_VERSION);
    Ds := Conn.GetDataSet(SQL_SET_MP_OBJECT_DELETED);
    Conn.SetParam(Ds, SF_ID, ObjId);
    Conn.SetParam(Ds, SF_TABLE_VERSION, Vrs);
    Conn.ExecDataSet(Ds);
  finally
    Conn.Commit;
  end;
end;

procedure TmstMasterPlanModule.DeleteObj(const ObjId: Integer);
begin
  // отправляем запрос в базу
  DeleteMpObjFromDb(ObjId);
  // удаляем с карты, если загружен
  UnloadFromGis(ObjId);
  // удаляем из датасетов и из индексов
  DeleteRow(memEzData, ObjId);
  DeleteRow(memBrowser, ObjId);
  DeleteRow(memObjects, ObjId);
end;

procedure TmstMasterPlanModule.DeleteRow(Ds: TDataSet; const ObjId: Integer);
var
  Rows: TIntegerList;
  I: Integer;
  Idx: TQueryRowIndex;
begin
  Idx := GetIdx(Ds);
  Rows := Idx.Get(ObjId);
  if Assigned(Rows) and (Rows.Count > 0) then
    for I := Rows.Count - 1 downto 0 do
    begin
      Ds.RecNo := Rows[I];
      Ds.Delete;
    end;
  Idx.Delete(ObjId);
end;

destructor TmstMasterPlanModule.Destroy;
begin
  FEzAdapter.Free;
  FMPAdapter.Free;
  FIdxEz.Free;
  FIdxBrowser.Free;
  FIdxObjects.Free;
  FClassifier.Free;
  inherited;
end;

procedure TmstMasterPlanModule.DisplayNavigator;
var
  AppSettings: ImstAppSettings;
begin
   if RefreshObjList() then
    PrepareBrowserDataSet();
  // если окно не открыто, то открываем и назначаем слой
  if FBrowserForm = nil then
  begin
    FBrowserForm := TmstMPBrowserForm.Create(Self);
  end;
  DoGetAppSettings(AppSettings);
  FBrowserForm.AppSettings := AppSettings;
  FBrowserForm.MP := Self as ImstMPModule;
  FBrowserForm.ObjList := Self as ImstMPModuleObjList;
  // если окно открыто, то назначаем в него слой
  FBrowserForm.DrawBox := aDrawBox;
  FBrowserForm.Browse();
end;

function TmstMasterPlanModule.DoCreatePrjReader(): IEzProjectReader;
begin
  Result := TEzProjectReaderFactory.NewReader(True);
end;

function TmstMasterPlanModule.DoCreateProject: TmstProject;
begin
  Result := TmstProjectMP.Create;
  TmstProjectMP(Result).ObjState := FImportObjState;
  TmstProjectMP(Result).CheckState := ocsImported;
end;

procedure TmstMasterPlanModule.DoGetAppSettings(out AppSettings: ImstAppSettings);
begin
  AppSettings := nil;
  if Assigned(FOnGetAppSettings) then
    FOnGetAppSettings(Self, AppSettings);
end;

procedure TmstMasterPlanModule.DoGetDb(out aDb: IDb);
begin
  aDb := nil;
  if Assigned(FOnGetDb) then
    FOnGetDb(Self, aDb);
end;

procedure TmstMasterPlanModule.DoGetProjectSaver(out Saver: IProjectSaver);
begin
  Saver := TmstMPProjectSaver.Create as IProjectSaver;
end;

procedure TmstMasterPlanModule.DoImportExecuted(Sender: TObject; Cancelled: Boolean; aProject: TmstProject);
var
  View: TEzRect;
  Saver: IProjectSaver;
  Db: IDb;
  Prj: TmstProjectMP;
  Obj: TmstMPObject;
  I: Integer;
begin
  try
    if not Cancelled then
    begin
      // если сохранили, то сохранеям в БД и показываем в слое проектов
      DoGetProjectSaver(Saver);
      DoGetDb(Db);
      Saver.Save(Db, aProject);
      RefreshObjList();
      //
//      TProjectUtils.AddProjectToGIS(aProject);
      Prj := TmstProjectMP(aProject);
      for I := 0 to Prj.Objects.Count - 1 do
      begin
        Obj := Prj.Objects[I];
        LoadToGis(Obj.DatabaseId, False);
      end;
      View := Rect2D(aProject.MinX, aProject.MinY, aProject.MaxX, aProject.MaxY);
      if aProject.CK36 then
        TEzCSConverter.Rect2DToVrn(View, False);
      FDrawBox.SetViewTo(View.ymin, View.xmin, View.ymax, View.xmax);
    end;
  finally
    FDrawBox.GIS.Layers.Delete(FImportLayerName, True);
    FImportLayerName := '';
    FDrawBox.RegenDrawing;
  end;
end;

function TmstMasterPlanModule.EditObjProperties(const ObjId: Integer): Boolean;
var
  MpObj: TmstMPObject;
  Dlg: TmstEditMPObjectSemanticsDialog;
begin
  Result := False;
  // создаём окно и показываем его
  MpObj := GetObjByDbId(ObjId, False);
  if not Assigned(MpObj) then
  begin
    ShowMessage(
      'Не удалось загрузить объект!' +
      sLineBreak +
      'Обратитесь к администратору.');
  end
  else
  begin
    Dlg := TmstEditMPObjectSemanticsDialog.Create(Self);
    if Dlg.EditObject(MpObj, Self as ImstMPModule, False, False) then
    begin
      Result := True;
      SaveMPObjectSemantics(MpObj);
      RefreshMPObjectData(MpObj);
    end;
  end;
end;

procedure TmstMasterPlanModule.ExportToMif(const aMifFileName: string);
var
  Exp: TmstMPMIFExport;
  Ent: TEzEntity;
  Layer: TEzBaseLayer;
  ObjId: Integer;
  MpObj: TmstMPObject;
begin
  Layer := GetMPLayer();
  if Layer = nil then
    Exit;
  Exp := TmstMPMIFExport.Create;
  Exp.Forget();
  Exp.DrawBox := Self.FDrawBox;
  Exp.Layer := Self.GetMPLayer();

  Layer.First;
  while not Layer.Eof do
  begin
    if not Layer.RecIsDeleted then
    begin
      ObjId := Layer.RecEntity.ExtID;
      MpObj := GetObjByDbId(ObjId, False);
      if MpObj <> nil then
        Exp.AddObject(MpObj, Layer.RecEntity);
    end;
    Layer.Next;
  end;
  //
  Exp.Save(aMifFileName);
end;

function TmstMasterPlanModule.EditNewObject(const MpObj: TmstMPObject): Boolean;
var
  Dlg: TmstEditMPObjectSemanticsDialog;
begin
  Result := False;
  // создаём окно и показываем его
  Dlg := TmstEditMPObjectSemanticsDialog.Create(Self);
  if Dlg.EditObject(MpObj, Self as ImstMPModule, True, True) then
  begin
    Result := True;
    MpObj.UpdateObjState();
    MpObj.IsLine := True;
    MpObj.CK36 := False;
    MpObj.ExchangeXY := False;
    //
    SaveMPObjectCoords(MpObj);
    RefreshObjList();
  end;
end;

procedure TmstMasterPlanModule.FillQueryIndex(Idx: TQueryRowIndex; Ds: TDataSet);
var
  Id: Integer;
begin
  Idx.Clear;
  Ds.First;
  while not Ds.Eof do
  begin
    Id := Ds.FieldByName(SF_ID).AsInteger;
    Idx.Add(Id, Ds.RecNo);
    Ds.Next;
  end;
end;

procedure TmstMasterPlanModule.GetDateTimeText(Sender: TField; var Text: string; DisplayText: Boolean);
begin
  DisplayText := Sender.AsDateTime = 0;
end;

function TmstMasterPlanModule.GetIdx(Ds: TDataSet): TQueryRowIndex;
begin
  if Ds = memEzData then
    Result := FIdxEz
  else
  if Ds = memObjects then
    Result := FIdxObjects
  else
  if Ds = memBrowser then
    Result := FIdxBrowser
  else
    Result := nil;
end;

procedure TmstMasterPlanModule.GetImportLayer(Sender: TObject; out Layer: TEzBaseLayer);
var
  Fields: TStringList;
begin
  Layer := nil;
  if FImportLayerName <> '' then
    Layer := FDrawBox.GIS.Layers.LayerByName(FImportLayerName);
  if Layer = nil then
  begin
    Fields := TStringList.Create;
    try
      Fields.Add('UID;N;11;0');
      Fields.Add('LAYER_ID;N;11;0');
      //
      FImportLayerName := 'TEMP_LAYER_' + IntToStr(GetTickCount());
      Layer := FDrawBox.GIS.Layers.LayerByName(FImportLayerName);
      if Layer = nil then
        Layer := FDrawBox.GIS.Layers.CreateNew(FImportLayerName, Fields);
    finally
      Fields.Free;
    end;
  end;
end;

function TmstMasterPlanModule.GetMPLayer: TEzBaseLayer;
begin
  Result := FDrawBox.GIS.Layers.LayerByName(SL_MASTER_PLAN);
end;

function TmstMasterPlanModule.GetMPTableVersion(Conn: IIBXConnection): Integer;
begin
  Result := Conn.GetGenValue(SG_MP_OBJECTS_TABLE_VERSION);
end;

function TmstMasterPlanModule.GetObjByDbId(const ObjId: Integer; LoadEzData: Boolean): TmstMPObject;
begin
  Result := nil;
  if not memBrowser.Active then
    Exit;
  if not LocateObj(ObjId, memBrowser) then
    Exit;
  //
  Result := TmstMPObject.Create;
  //FTableVersion := memBrowser.FieldByName(SF_TABLE_VERSION).AsInteger;
  Result.DatabaseId := memBrowser.FieldByName(SF_ID).AsInteger;
//  WMIF('  ' + SF_CLASS_ID + ' Char(50) ');
//  S := S + DecorateFieldValue(MpObj.MpClassGuid, 50) + ',';
  Result.MpClassGuid := memBrowser.FieldByName(SF_CLASS_ID).AsString;
//  WMIF('  ' + SF_CLASS_NAME + ' Char(255) ');
//  S := S + DecorateFieldValue(MpObj.MpClassName, 255) + ',';
  Result.MpClassName := memBrowser.FieldByName(SF_LAYER_NAME).AsString;
//  WMIF('  ' + SF_OBJ_ID + ' Char(36) ');
//  S := S + DecorateFieldValue(MpObj.MPObjectGuid, 36) + ',';
  Result.MPObjectGuid := memBrowser.FieldByName(SF_OBJ_ID).AsString;
//  WMIF('  ' + SF_LINKED_OBJ_ID + ' Char(36) ');
//  S := S + DecorateFieldValue(MpObj.LinkedObjectGuid, 36) + ',';
  Result.LinkedObjectGuid := memBrowser.FieldByName(SF_LINKED_OBJ_ID).AsString;
//  WMIF('  ' + SF_ADDRESS + ' Char(255) ');
//  S := S + DecorateFieldValue(MpObj.Address, 255) + ',';
  Result.Address := memBrowser.FieldByName(SF_ADDRESS).AsString;
//  WMIF('  ' + SF_DOC_NUMBER + ' Char(12) ');
//  S := S + DecorateFieldValue(MpObj.DocNumber, 12) + ',';
  Result.DocNumber := memBrowser.FieldByName(SF_DOC_NUMBER).AsString;
//  WMIF('  ' + SF_DOC_DATE + ' Char(10) ');
//  S := S + DecorateFieldValue(GetDateStr(MpObj.DocDate), 10) + ',';
  Result.DocDate := memBrowser.FieldByName(SF_DOC_DATE).AsDateTime;
//  WMIF('  ' + SF_PROJECT_NAME + ' Char(255) ');
//  S := S + DecorateFieldValue(MpObj.ProjectName, 255) + ',';
  Result.ProjectName := memBrowser.FieldByName(SF_PROJECT_NAME).AsString;
//  WMIF('  ' + SF_REQUEST_NUMBER + ' Char(12) ');
//  S := S + DecorateFieldValue(MpObj.RequestNumber, 12) + ',';
  Result.RequestNumber := memBrowser.FieldByName(SF_REQUEST_NUMBER).AsString;
//  WMIF('  ' + SF_REQUEST_DATE + ' Char(10) ');
//  S := S + DecorateFieldValue(GetDateStr(MpObj.RequestDate), 10) + ',';
  Result.RequestDate := memBrowser.FieldByName(SF_REQUEST_DATE).AsDateTime;
//  WMIF('  ' + SF_DRAW_DATE + ' Char(10) ');
//  S := S + DecorateFieldValue(GetDateStr(MpObj.DrawDate), 10) + ',';
  Result.DrawDate := memBrowser.FieldByName(SF_DRAW_DATE).AsDateTime;
//  WMIF('  ' + SF_OWNER + ' Char(255) ');
//  S := S + DecorateFieldValue(MpObj.Owner, 255) + ',';
  Result.Owner := memBrowser.FieldByName(SF_OWNER).AsString;
//  WMIF('  ' + SF_CUSTOMER + ' Char(255) ');
//  S := S + DecorateFieldValue(MpObj.CustomerOrg, 255) + ',';
  Result.CustomerOrg := memBrowser.FieldByName(SF_CUSTOMER_NAME).AsString;
//  WMIF('  ' + SF_EXECUTOR + ' Char(255) ');
//  S := S + DecorateFieldValue(MpObj.ExecutorOrg, 255) + ',';
  Result.ExecutorOrg := memBrowser.FieldByName(SF_EXECUTOR_NAME).AsString;
//  WMIF('  ' + SF_DRAW_ORG + ' Char(255) ');
//  S := S + DecorateFieldValue(MpObj.DrawOrg, 255) + ',';
  Result.DrawOrg := memBrowser.FieldByName(SF_DRAWER_NAME).AsString;
//  WMIF('  ' + SF_ROTATION + ' Integer ');
//  S := S + IntToStr(MpObj.Rotation) + ',';
  Result.Rotation := memBrowser.FieldByName(SF_ROTATION).AsInteger;
//  WMIF('  ' + SF_DRAWN + ' Logical ');
//  S := S + GetBoolStr(MpObj.Drawn);
  Result.Drawn := memBrowser.FieldByName(SF_DRAWN).AsInteger = 1;
//  WMIF('  ' + SF_CONFIRMED + ' Logical ');
//  S := S + GetBoolStr(MpObj.Confirmed);
  Result.Confirmed := memBrowser.FieldByName(SF_CONFIRMED).AsInteger = 1;
//  WMIF('  ' + SF_DISMANTLED + ' Logical ');
//  S := S + GetBoolStr(MpObj.Dismantled);
  Result.Dismantled := memBrowser.FieldByName(SF_DISMANTLED).AsInteger = 1;
//  WMIF('  ' + SF_ARCHIVED + ' Logical ');
//  S := S + GetBoolStr(MpObj.Archived);
  Result.Archived := memBrowser.FieldByName(SF_ARCHIVED).AsInteger = 1;
//  WMIF('  ' + SF_UNDERGROUND + ' Logical ');
//  S := S + GetBoolStr(MpObj.Underground);
  Result.Underground := memBrowser.FieldByName(SF_UNDERGROUND).AsInteger = 1;
//  WMIF('  ' + SF_DIAMETER + ' Integer ');
//  S := S + IntToStr(MpObj.Diameter) + ',';
  Result.Diameter := memBrowser.FieldByName(SF_DIAMETER).AsInteger;
//  WMIF('  ' + SF_VOLTAGE + ' Integer ');
//  S := S + IntToStr(MpObj.Voltage) + ',';
  Result.Voltage := memBrowser.FieldByName(SF_VOLTAGE).AsInteger;
//  WMIF('  ' + SF_PIPE_COUNT + ' Integer ');
//  S := S + IntToStr(MpObj.PipeCount) + ',';
  Result.PipeCount := memBrowser.FieldByName(SF_PIPE_COUNT).AsInteger;
//  WMIF('  ' + SF_MATERIAL + ' Char(255) ');
//  S := S + DecorateFieldValue(MpObj.Material, 255) + ',';
  Result.Material := memBrowser.FieldByName(SF_MATERIAL).AsString;
//  WMIF('  ' + SF_TOP + ' Char(255) ');
//  S := S + DecorateFieldValue(MpObj.Top, 255) + ',';
  Result.Top := memBrowser.FieldByName(SF_TOP).AsString;
//  WMIF('  ' + SF_BOTTOM + ' Char(255) ');
//  S := S + DecorateFieldValue(MpObj.Bottom, 255) + ',';
  Result.Bottom := memBrowser.FieldByName(SF_BOTTOM).AsString;
//  WMIF('  ' + SF_FLOOR + ' Char(255) ');
//  S := S + DecorateFieldValue(MpObj.Floor, 255) + ',';
  Result.Floor := memBrowser.FieldByName(SF_FLOOR).AsString;
//  WMIF('  ' + SF_PROJECTED + ' Logical ');
//  S := S + GetBoolStr(MpObj.Projected);
  Result.Projected := memBrowser.FieldByName(SF_PROJECTED).AsInteger = 1;
//  WMIF('  ' + SF_HAS_CERTIF + ' Logical ');
//  S := S + GetBoolStr(MpObj.HasCertif);
  Result.HasCertif := memBrowser.FieldByName(SF_HAS_CERTIF).AsInteger = 1;
//  WMIF('  ' + SF_CERTIF_NUMBER + ' Char(12) ');
//  S := S + DecorateFieldValue(MpObj.CertifNumber, 12) + ',';
  Result.CertifNumber := memBrowser.FieldByName(SF_CERTIF_NUMBER).AsString;
//  WMIF('  ' + SF_CERTIF_DATE + ' Char(10) ');
//  S := S + DecorateFieldValue(GetDateStr(MpObj.CertifDate), 10) + ',';
  Result.CertifDate := memBrowser.FieldByName(SF_CERTIF_DATE).AsDateTime;

  Result.MpClassId := memBrowser.FieldByName(SF_MASTER_PLAN_CLASS_ID).AsInteger;
  Result.IsLine := memBrowser.FieldByName(SF_IS_LINE).AsInteger = 1;
//  Result.CK36 := memBrowser.FieldByName(SF_CK36).AsInteger = 1;
  Result.CustomerOrgId := memBrowser.FieldByName(SF_CUSTOMER_ORGS_ID).AsInteger;
  Result.ExecutorOrgId := memBrowser.FieldByName(SF_EXECUTOR_ORGS_ID).AsInteger;
  Result.DrawOrgId := memBrowser.FieldByName(SF_DRAW_ORGS_ID).AsInteger;
  Result.MinX := memBrowser.FieldByName(SF_MINX).AsFloat;
  Result.MinY := memBrowser.FieldByName(SF_MINY).AsFloat;
  Result.MaxX := memBrowser.FieldByName(SF_MAXY).AsFloat;
  Result.MaxY := memBrowser.FieldByName(SF_MAXY).AsFloat;
  Result.CheckState := TmstMPObjectCheckState(memBrowser.FieldByName(SF_CHECK_STATE).AsInteger);
  //
  Result.UpdateObjState();
  //
  if LoadEzData then
  begin
    raise Exception.Create('TmstMasterPlanModule.GetObjByDbId');
  end;
end;

procedure TmstMasterPlanModule.GiveOutCertif(const ObjId: Integer; CertifNumber: string; CertifDate: TDateTime);
var
  Db: IDb;
  Conn: IIBXConnection;
  Ds: TDataSet;
  RowNum: Integer;
  Vrs: Integer;
begin
  // соединение
  DoGetDb(Db);
  //
  Conn := Db.GetConnection(cmReadWrite, dmKis);
  try
  // выполняем запрос на обновление данных
    Ds := Conn.GetDataSet(SQL_SET_MP_CERTIF_GIVED_OUT);
    Conn.SetParam(Ds, SF_ID, ObjId);
    Conn.SetParam(Ds, SF_CERTIF_NUMBER, CertifNumber);
    Conn.SetParam(Ds, SF_HAS_CERTIF, 1);
    Conn.SetNullableParam(Ds, SF_CERTIF_DATE, CertifDate, 0);
    Vrs := Conn.GenNextValue(SG_MP_OBJECTS_TABLE_VERSION);
    Conn.SetParam(Ds, SF_TABLE_VERSION, Vrs);
    Conn.ExecDataSet(Ds);
    //
    RowNum := FIdxBrowser.GetFirstRow(ObjId);
    memBrowser.RecNo := RowNum;
    memBrowser.Edit;
    memBrowser.FieldByName(SF_CERTIF_NUMBER).Value := CertifNumber;
    memBrowser.FieldByName(SF_CERTIF_DATE).Value := CertifDate;
    memBrowser.FieldByName(SF_HAS_CERTIF).Value := 1;
    memBrowser.Post;
  finally
    Conn.Commit;
  end;
end;

function TmstMasterPlanModule.HasLoaded: Boolean;
var
  Ent: TEzEntity;
  Layer: TEzBaseLayer;
  ObjId: Integer;
begin
  Result := FEzAdapter.Loaded;
  if not Result then
  begin
    memEzData.First;
    Layer := GetMPLayer();
    if Layer = nil then
      Exit;
    Layer.First;
    while not Layer.Eof do
    begin
      Result := not Layer.RecIsDeleted;
      if Result then
        Exit;
      Layer.Next;
    end;
  end;
end;

procedure TmstMasterPlanModule.ImportDXF;
begin
  FImport := TmstProjectImportModule.Create(Self);
  FImportObjState := aObjState;
  // выбрать файл
  if not FImport.BeginImport(FDrawBox,
                             GetImportLayer,
                             DoImportExecuted,
                             DoCreateProject,
                             DoCreatePrjReader
                             )
  then
    Exit;
  FImport.DisplayImportDialog();
end;

function TmstMasterPlanModule.IsLoaded(const ObjId: Integer): Boolean;
var
  RowNum: Integer;
begin
  if FEzAdapter.Id <> ObjId then
  begin
    RowNum := FIdxEz.GetFirstRow(ObjId);
    memEzData.RecNo := RowNum;
  end;
  Result := FEzAdapter.Loaded;
end;

function TmstMasterPlanModule.IsObjectVisible(const ObjId: Integer; var aLineColor: TColor): Boolean;
var
  CatId: Integer;
begin
  memObjects.RecNo := FIdxObjects.GetFirstRow(ObjId);
  CatId := FClassifier.GetClassCategoryId(FMPAdapter.MpClassId);
  Result := FClassifier.GetMPCategoryVisible(FMPAdapter.Status, CatId);
  if Result then
    aLineColor := FClassifier.GetClassCategoryColor(FMPAdapter.MpClassId);
end;

procedure TmstMasterPlanModule.LoadAllToGIS;
begin
  memEzData.First;
  while not memEzData.Eof do
  begin
    if not FEzAdapter.Loaded then
      LoadToGis(FEzAdapter.Id, False);
    memEzData.Next;
  end;
end;

procedure TmstMasterPlanModule.LoadFromDb;
var
  Db: IDb;
  Conn: IIBXConnection;
  Ds: TDataSet;
  Fld: TField;
begin
  DoGetDb(Db);
  //
  Conn := Db.GetConnection(cmReadOnly, dmKis);
  try
    Ds := Conn.GetDataSet(SQL_GET_MP_CLASSIFIER);
    Ds.Open;
    try
      Classifier.LoadFromDataSet(Ds);
    finally
      Ds.Close;
    end;
  finally
    Conn.Commit;
  end;
  //
  Conn := Db.GetConnection(cmReadOnly, dmKis);
  try
    Ds := Conn.GetDataSet(SQL_GET_MP_OBJECTS_LIST);
    Ds.Open;
    try
      memObjects.LoadFromDataSet(Ds, 0, lmCopy);
      memObjects.SortOnFields(SF_ID);
    finally
      Ds.Close;
    end;
    //
    Ds := Conn.GetDataSet(SQL_GET_MP_OBJECTS_LIST_FOR_BROWSER);
    Ds.Open;
    try
      memBrowser.LoadFromDataSet(Ds, 0, lmCopy);
      memBrowser.SortOnFields(SF_ID);
      Fld := memBrowser.FieldByName(SF_DOC_DATE);
      Fld.OnGetText := GetDateTimeText;
      Fld := memBrowser.FieldByName(SF_CERTIF_DATE);
      Fld.OnGetText := GetDateTimeText;
      Fld := memBrowser.FieldByName(SF_REQUEST_DATE);
      Fld.OnGetText := GetDateTimeText;
      //
      memBrowser.First;
      while not memBrowser.Eof do
      begin
        if FTableVersion < FMPAdapter.TableVersion then
          FTableVersion := FMPAdapter.TableVersion;
        memBrowser.Next;
      end;
      memBrowser.First;
    finally
      Ds.Close;
    end;
    //
    Ds := Conn.GetDataSet(SQL_GET_EZ_DATA_LIST);
    Ds.Open;
    try
      memEzData.LoadFromDataSet(Ds, 0, lmCopy);
      memEzData.SortOnFields(SF_ID);
    finally
      Ds.Close;
    end;
  finally
    Conn.Commit;
  end;
  //
  // заполняем индекс
  FillQueryIndex(FIdxObjects, memObjects);
  FillQueryIndex(FIdxBrowser, memBrowser);
  FillQueryIndex(FIdxEz, memEzData);
end;

procedure TmstMasterPlanModule.RefreshMPObjectData(aObj: TmstMPObject);
begin
  if not LocateObj(aObj.DatabaseId, memBrowser) then
    Exit;
  memBrowser.Edit;
  memBrowser.FieldByName(SF_TABLE_VERSION).AsInteger := FTableVersion;
  memBrowser.FieldByName(SF_OBJ_ID).AsString := aObj.MPObjectGuid;
  memBrowser.FieldByName(SF_LINKED_OBJ_ID).AsString := aObj.LinkedObjectGuid;
  memBrowser.FieldByName(SF_ADDRESS).AsString := aObj.Address;
  memBrowser.FieldByName(SF_ARCHIVED).AsInteger := IfThen(aObj.Archived, 1, 0);
  memBrowser.FieldByName(SF_BOTTOM).AsString := aObj.Bottom;
//  memBrowser.FieldByName(SF_MASTER_PLAN_CLASS_ID).AsInteger := aObj.ClassId;
  memBrowser.FieldByName(SF_CONFIRMED).AsInteger := IfThen(aObj.Confirmed, 1, 0);
  memBrowser.FieldByName(SF_DIAMETER).AsInteger := aObj.Diameter;
  memBrowser.FieldByName(SF_DISMANTLED).AsInteger := IfThen(aObj.Dismantled, 1, 0);
  memBrowser.FieldByName(SF_DOC_NUMBER).AsString := aObj.DocNumber;
  memBrowser.FieldByName(SF_DOC_DATE).Value := aObj.DocDate;
  memBrowser.FieldByName(SF_DRAW_DATE).Value := aObj.DrawDate;
  memBrowser.FieldByName(SF_FLOOR).AsString := aObj.Floor;
  memBrowser.FieldByName(SF_IS_LINE).AsInteger := IfThen(aObj.IsLine, 1, 0);
  memBrowser.FieldByName(SF_MATERIAL).AsString := aObj.Material;
  memBrowser.FieldByName(SF_OWNER).AsString := aObj.Owner;
  memBrowser.FieldByName(SF_PIPE_COUNT).AsInteger := aObj.PipeCount;
  memBrowser.FieldByName(SF_REQUEST_NUMBER).AsString := aObj.RequestNumber;
  memBrowser.FieldByName(SF_REQUEST_DATE).Value := aObj.RequestDate;
  memBrowser.FieldByName(SF_ROTATION).AsInteger := aObj.Rotation;
  memBrowser.FieldByName(SF_STATUS).AsInteger := aObj.Status;
  memBrowser.FieldByName(SF_TOP).AsString := aObj.Top;
  memBrowser.FieldByName(SF_UNDERGROUND).AsInteger := IfThen(aObj.Underground, 1, 0);
  memBrowser.FieldByName(SF_VOLTAGE).AsInteger := aObj.Voltage;
  // импорт
  memBrowser.FieldByName(SF_PROJECT_NAME).AsString := aObj.ProjectName;
//  memBrowser.FieldByName(SF_CK36).AsInteger := IfThen(aObj.CK36, 0, 1);
  //memBrowser.FieldByName(SF_).As := IfThen(aObj.ExchangeXY).As := 0).As := 1));
  memBrowser.FieldByName(SF_CUSTOMER_ORGS_ID).AsInteger := aObj.CustomerOrgId;
  memBrowser.FieldByName(SF_EXECUTOR_ORGS_ID).AsInteger := aObj.ExecutorOrgId;
  memBrowser.FieldByName(SF_DRAW_ORGS_ID).AsInteger := aObj.DrawOrgId;
  // используются местная СК: Х - вверх).As := Y - вправо (геодезические кооринаты)
  memBrowser.FieldByName(SF_MINX).AsFloat := aObj.MinX;
  // используются местная СК: Х - вверх).As := Y - вправо (геодезические кооринаты)
  memBrowser.FieldByName(SF_MINY).AsFloat := aObj.MinY;
  // используются местная СК: Х - вверх).As := Y - вправо (геодезические кооринаты)
  memBrowser.FieldByName(SF_MAXY).AsFloat := aObj.MaxX;
  memBrowser.FieldByName(SF_MAXY).AsFloat := aObj.MaxY;
  // используются местная СК: Х - вверх).As := Y - вправо (геодезические кооринаты)
  //
  memBrowser.FieldByName(SF_CHECK_STATE).AsInteger := Integer(aObj.CheckState);
//    memBrowser.FieldByName(SF_).As := aObj.ObjState);
  // нанесён
  memBrowser.FieldByName(SF_DRAWN).AsInteger := IfThen(aObj.Drawn, 1, 0);
  // проектируемый
  memBrowser.FieldByName(SF_PROJECTED).AsInteger := IfThen(aObj.Projected, 1, 0);
  // справка выдана
  memBrowser.FieldByName(SF_HAS_CERTIF).AsInteger := IfThen(aObj.HasCertif, 1, 0);
  // номер справки
  memBrowser.FieldByName(SF_CERTIF_NUMBER).AsString := aObj.CertifNumber;
  // дата справки
  memBrowser.FieldByName(SF_CERTIF_DATE).Value := aObj.CertifDate;
  memBrowser.Post;
end;

function TmstMasterPlanModule.RefreshObjList: Boolean;
var
  Db: IDb;
  Conn: IIBXConnection;
  Ds: TDataSet;
  ToDelete: TIntegerList;
  ToUpdate: TIntegerList;
  TableVrs: Integer;
  ObjDeleted: Boolean;
  ObjId: Integer;
begin
  Result := False;
  //
  DoGetDb(Db);
  //
  Conn := Db.GetConnection(cmReadOnly, dmKis);
  try
    ToDelete := TIntegerList.Create;
    ToUpdate := TIntegerList.Create;
    try
      TableVrs := GetMPTableVersion(Conn);
      if FTableVersion <> TableVrs then
      begin
        // выбираем объект, которые изменились поле последней загрузки данных
        Ds := Conn.GetDataSet(SQL_GET_MP_OBJECTS_LIST_UPDATED);
        Conn.SetParam(Ds, SF_TABLE_VERSION, FTableVersion);
        Ds.Open;
        try
          Result := Ds.RecordCount > 0;
          if Result then
          begin
            while not Ds.Eof do
            begin
              ObjId := Ds.FieldByName(SF_ID).AsInteger;
              ObjDeleted := Ds.FieldByName(SF_DELETED).AsInteger = 1;
              if ObjDeleted then
                ToDelete.Add(ObjId)
              else
                ToUpdate.Add(ObjId);
              Ds.Next;
            end;
            // обновляем браузерный датасет
            ApplyChanedRecords(Ds, ToUpdate, ToDelete);
          end;
        finally
          Ds.Close;
        end;
      end;
    finally
      ToUpdate.Free;
      ToDelete.Free;
    end;
  finally
    Conn.Commit;
  end;
end;

procedure TmstMasterPlanModule.RefreshRows(DsChanges, DsData: TDataSet; ToUpdate: TIntegerList;
  OnRowRefresh: TObjIdEvent);
var
  ObjId: Integer;
  Dummy: Integer;
begin
  if ToUpdate.Count = 0 then
    Exit;
  DsChanges.First;
  while not DsChanges.Eof do
  begin
    ObjId := DsChanges.FieldByName(SF_ID).AsInteger;
    if ToUpdate.Find(ObjId, Dummy) then
    begin
      LocateObj(ObjId, DsData);
      RefreshSingleRow(DsChanges, DsData);
      if Assigned(OnRowRefresh) then
        OnRowRefresh(ObjId);
    end;
    DsChanges.Next;
  end;
end;

procedure TmstMasterPlanModule.RefreshSingleRow(DsChanges, DsData: TDataSet);
var
  I: Integer;
  Fld: TField;
  Fld2: TField;
  Fn: string;
begin
  DsData.Edit;
  try
    for I := 0 to DsData.FieldList.Count - 1 do
    begin
      Fld := DsData.FieldList[I];
      Fn := Fld.FieldName;
      if Fn = SF_ID then
        Continue;
      if Fn = SF_LOADED then
        Continue;
      Fld2 := DsChanges.Fields.FindField(Fn);
      if Assigned(Fld2) then
      begin
        if Fn = SF_EZDATA then
          DsData.FieldValues[Fn] := DsChanges.FieldValues[Fn]
        else
          DsData.FieldValues[Fn] := DsChanges.FieldValues[Fn];
      end;
    end;
  finally
    DsData.Post;
  end;

end;

procedure TmstMasterPlanModule.ReloadObjectToGis(ObjId: Integer);
var
  Ent: TEzEntity;
  Layer: TEzBaseLayer;
begin
  Layer := GetMPLayer();
  if Layer = nil then
    Exit;
  if IsLoaded(ObjId) then
  begin
    Ent := FEzAdapter.GetEntity();
    Layer.Recno := FEzAdapter.EzRecno;
    Layer.UpdateEntity(Layer.Recno, Ent);
  end;
end;

procedure TmstMasterPlanModule.LoadToGis(const ObjId: Integer; const Display: Boolean);
begin
  // есть ли такой объект
  if LocateObj(ObjId, memEzData) then
    // грузим
    AddCurrentObjToLayer(Display);
end;

function TmstMasterPlanModule.LocateObj(ObjId: Integer; Ds: TDataSet): Boolean;
var
  Idx: TQueryRowIndex;
  RowNum: Integer;
begin
  if Ds.RecordCount = 0 then
  begin
    Result := False;
    Exit;
  end;
  //
  if Ds.FieldByName(SF_ID).AsInteger = ObjId then
  begin
    Result := True;
    Exit;
  end;
  Idx := GetIdx(Ds);
  RowNum := Idx.GetFirstRow(ObjId);
  Result := RowNum > 0;
  if Result then
    Ds.RecNo := RowNUm;
end;

procedure TmstMasterPlanModule.NavigatorClosed;
begin
  FBrowserForm := nil;
end;

procedure TmstMasterPlanModule.AddCurrentObjToLayer(const Display: Boolean);
var
  Ent: TEzEntity;
  Layer: TEzBaseLayer;
begin
  Layer := GetMPLayer();
  if Layer = nil then
    Exit;
  Ent := FEzAdapter.GetEntity();
  try
//        if FMPAdapter.CK36 then
//          TEzCSConverter.EntityToVrn(Ent, not FMPAdapter.ExchangeXY);
//        if FMPAdapter.ExchangeXY then
//          TEzCSConverter.ExchangeXY(Ent);
    if FEzAdapter.Loaded then
    begin
      Layer.Recno := FEzAdapter.EzRecno;
      Layer.UpdateEntity(Layer.Recno, Ent);
      if Layer.RecIsDeleted then
        Layer.UnDeleteEntity(Layer.Recno);
    end
    else
    begin
      FEzAdapter.EzRecno := Layer.AddEntity(Ent);
      FEzAdapter.Loaded := True;
      Layer.Recno := FEzAdapter.EzRecno;
    end;
    //
    memBrowser.Edit;
    memBrowser.FieldByName(SF_LOADED).AsInteger := 1;
    memBrowser.Post;
    //
    if Display then
    begin
      FDrawBox.SetEntityInViewEx(Layer.Name, Layer.Recno, True);
      FDrawBox.BlinkEntityEx(Layer.Name, Layer.Recno);
    end;
  finally
    FreeAndNil(Ent);
  end;
end;

procedure TmstMasterPlanModule.AppendNewRows;
var
  ObjId: Integer;
  Dummy: Integer;
  NeedToSort: Boolean;
begin
  if ToInsert.Count = 0 then
    Exit;
  NeedToSort := False;
  DsChanges.First;
  while not DsChanges.Eof do
  begin
    ObjId := DsChanges.FieldByName(SF_ID).AsInteger;
    if ToInsert.Find(ObjId, Dummy) then
    begin
      DsData.Append();
      DsData.FieldByName(SF_ID).AsInteger := ObjId;
      DsData.Post();
      NeedToSort := True;
      Idx.Add(ObjId, DsData.RecNo);
      RefreshSingleRow(DsChanges, DsData);
    end;
    DsChanges.Next;
  end;
  if NeedToSort then
    Idx.Sort(False);
end;

procedure TmstMasterPlanModule.ApplyChanedRecords(DsChanges: TDataSet; ToUpdate, ToDelete: TIntegerList);
var
  NeedRedrawMap: Boolean;
  CurrId: Integer;
  Bkm: Pointer;
  CurrIdDeleted: Boolean;
  ObjId: Integer;
  I, J: Integer;
  ToInsert: TIntegerList;
  RowsToDelete1: TIntegerList;
  RowsToDelete2: TIntegerList;
  RowsToDelete3: TIntegerList;
begin
  NeedRedrawMap := False;
  CurrId := -1;
  Bkm := nil;
  CurrIdDeleted := False;
  if memBrowser.Active then
  begin
    // запомнить текущую строку.
    CurrId := memBrowser.FieldByName(SF_ID).AsInteger;
    Bkm := memBrowser.GetBookmark();
    memBrowser.DisableControls;
  end;
  //
  RowsToDelete1 := TIntegerList.Create;
  RowsToDelete2 := TIntegerList.Create;
  RowsToDelete3 := TIntegerList.Create;
  try
    // удаляем устаревшие записи
    for I := 0 to ToDelete.Count - 1 do
    begin
      ObjId := ToDelete[I];
      if IsLoaded(ObjId) then
      begin
        UnloadFromGis(ObjId);
        NeedRedrawMap := True;
      end;
      J := FIdxObjects.GetFirstRow(ObjId);
      RowsToDelete1.Add(J);
      J := FIdxBrowser.GetFirstRow(ObjId);
      RowsToDelete2.Add(J);
      J := FIdxEz.GetFirstRow(ObjId);
      RowsToDelete3.Add(J);
      DeleteRow(memObjects, ObjId);
      DeleteRow(memBrowser, ObjId);
      DeleteRow(memEzData, ObjId);
      if ObjId = CurrId then
        CurrIdDeleted := True;
    end;
    //
    RowsToDelete3.Sort;
    RowsToDelete2.Sort;
    RowsToDelete1.Sort;
    for I := RowsToDelete3.Count - 1 downto 0 do
    begin

    end;
  finally
    RowsToDelete3.Free;
    RowsToDelete2.Free;
    RowsToDelete1.Free;
  end;
    //
  try
    ToInsert := TIntegerList.Create;
    try
      for I := ToUpdate.Count - 1 downto 0 do
      begin
        ObjId := ToUpdate[I];
        if not FIdxObjects.Contains(ObjId) then
        begin
          ToInsert.Add(ObjId);
          ToUpdate.Delete(I);
        end;
      end;
      //
      RefreshRows(DsChanges, memObjects, ToUpdate, nil);
      AppendNewRows(DsChanges, memObjects, ToInsert, FIdxObjects);
      //
      RefreshRows(DsChanges, memBrowser, ToUpdate, nil);
      AppendNewRows(DsChanges, memBrowser, ToInsert, FIdxBrowser);
      //
      RefreshRows(DsChanges, memEzData, ToUpdate, ReloadObjectToGis);
      AppendNewRows(DsChanges, memEzData, ToInsert, FIdxEz);
    finally
      ToInsert.Free;
    end;
    // 
    if not NeedRedrawMap then
    begin
      for I := 0 to ToUpdate.Count - 1 do
      begin
        ObjId := ToUpdate[I];
        if IsLoaded(ObjId) then
        begin
          NeedRedrawMap := True;
          Break;
        end;
      end;
    end;
  finally
    if memBrowser.Active then
    begin
      if CurrIdDeleted then
        memBrowser.First
      else
        memBrowser.GotoBookmark(Bkm);
      memBrowser.EnableControls;
    end;
  end;
  //
  if NeedRedrawMap then
    FDrawBox.RegenDrawing;
end;

function TmstMasterPlanModule.BrowserDataSet: TDataSet;
begin
  Result := memBrowser;
end;

procedure TmstMasterPlanModule.PrepareBrowserDataSet;
begin

end;

procedure TmstMasterPlanModule.SaveMPObjectCoords;
var
  Db: IDb;
  Saver: ImstObjectSaver;
begin
  DoGetDb(Db);
  Saver := TmstMPObjectSaver.Create() as ImstObjectSaver;
  Saver.Save(Db, aObj);
end;

procedure TmstMasterPlanModule.SaveMPObjectSemantics(aObj: TmstMPObject);
var
  Db: IDb;
  Conn: IIBXConnection;
  Ds: TDataSet;
  Sql: string;
begin
  DoGetDb(Db);
  //
  Conn := Db.GetConnection(cmReadWrite, dmKis);
  try
    // генерируем новое значение TableVersion
    FTableVersion := Conn.GenNextValue(SG_MP_OBJECTS_TABLE_VERSION);
    //
    Sql := SQL_UPDATE_MP_OBJECT_SEMANTICS;
    // создаём запрос на сохранение
    Ds := Conn.GetDataSet(Sql);
    Conn.SetParam(Ds, SF_ID, aObj.DatabaseId);
    Conn.SetParam(Ds, SF_TABLE_VERSION, FTableVersion);
    Conn.SetParam(Ds, SF_OBJ_ID, aObj.MPObjectGuid);
    Conn.SetParam(Ds, SF_LINKED_OBJ_ID, aObj.LinkedObjectGuid);
    Conn.SetParam(Ds, SF_ADDRESS, aObj.Address);
    Conn.SetParam(Ds, SF_ARCHIVED, IfThen(aObj.Archived, 1, 0));
    Conn.SetParam(Ds, SF_BOTTOM, aObj.Bottom);
//    Conn.SetParam(Ds, SF_MASTER_PLAN_CLASS_ID, aObj.ClassId);
    Conn.SetParam(Ds, SF_CONFIRMED, IfThen(aObj.Confirmed, 1, 0));
    Conn.SetParam(Ds, SF_DIAMETER, aObj.Diameter);
    Conn.SetParam(Ds, SF_DISMANTLED, IfThen(aObj.Dismantled, 1, 0));
    Conn.SetParam(Ds, SF_DOC_NUMBER, aObj.DocNumber);
    Conn.SetNullableParam(Ds, SF_DOC_DATE, aObj.DocDate, 0);
    Conn.SetNullableParam(Ds, SF_DRAW_DATE, aObj.DrawDate, 0);
    Conn.SetParam(Ds, SF_FLOOR, aObj.Floor);
//    Conn.SetParam(Ds, SF_IS_LINE, IfThen(aObj.IsLine, 1, 0));
    Conn.SetParam(Ds, SF_MATERIAL, aObj.Material);
    Conn.SetParam(Ds, SF_OWNER, aObj.Owner);
    Conn.SetParam(Ds, SF_PIPE_COUNT, aObj.PipeCount);
    Conn.SetParam(Ds, SF_REQUEST_NUMBER, aObj.RequestNumber);
    Conn.SetNullableParam(Ds, SF_REQUEST_DATE, aObj.RequestDate, 0);
    Conn.SetParam(Ds, SF_ROTATION, aObj.Rotation);
    Conn.SetParam(Ds, SF_STATUS, aObj.Status);
    Conn.SetParam(Ds, SF_TOP, aObj.Top);
    Conn.SetParam(Ds, SF_UNDERGROUND, aObj.Underground);
    Conn.SetParam(Ds, SF_VOLTAGE, aObj.Voltage);
    // импорт
    Conn.SetParam(Ds, SF_PROJECT_NAME, aObj.ProjectName);
    //Conn.SetParam(Ds, SF_CK36, IfThen(aObj.CK36, 1, 0));
    //Conn.SetParam(Ds, SF_, IfThen(aObj.ExchangeXY, 1, 0));
    Conn.SetNullableParam(Ds, SF_OWNER_ORG_ID, aObj.OwnerOrgId, 0);
    Conn.SetNullableParam(Ds, SF_CUSTOMER_ORGS_ID, aObj.CustomerOrgId, 0);
    Conn.SetNullableParam(Ds, SF_EXECUTOR_ORGS_ID, aObj.ExecutorOrgId, 0);
    Conn.SetNullableParam(Ds, SF_DRAW_ORGS_ID, aObj.DrawOrgId, 0);
    // используются местная СК: Х - вверх, Y - вправо (геодезические кооринаты)
    //Conn.SetParam(Ds, SF_MINX, aObj.MinX);
    // используются местная СК: Х - вверх, Y - вправо (геодезические кооринаты)
    //Conn.SetParam(Ds, SF_MINY, aObj.MinY);
    // используются местная СК: Х - вверх, Y - вправо (геодезические кооринаты)
    //Conn.SetParam(Ds, SF_MAXY, aObj.MaxX);
    //Conn.SetParam(Ds, SF_MAXY, aObj.MaxY);
    // используются местная СК: Х - вверх, Y - вправо (геодезические кооринаты)
    //
    Conn.SetParam(Ds, SF_CHECK_STATE, Integer(aObj.CheckState));
//    Conn.SetParam(Ds, SF_, aObj.ObjState);
    // нанесён
    Conn.SetParam(Ds, SF_DRAWN, IfThen(aObj.Drawn, 1, 0));
    // проектируемый
    Conn.SetParam(Ds, SF_PROJECTED, IfThen(aObj.Projected, 1, 0));
    // справка выдана
    Conn.SetParam(Ds, SF_HAS_CERTIF, IfThen(aObj.HasCertif, 1, 0));
    // номер справки
    Conn.SetParam(Ds, SF_CERTIF_NUMBER, aObj.CertifNumber);
    // дата справки
    Conn.SetNullableParam(Ds, SF_CERTIF_DATE, aObj.CertifDate, 0);
    //
    Ds.Open;
  finally
    Conn.Commit; 
  end;
end;

procedure TmstMasterPlanModule.SetAppSettingsEvent(aEvent: TGetAppSettingsEvent);
begin
  FOnGetAppSettings := aEvent;
end;

procedure TmstMasterPlanModule.SetDbEvent(Value: TGetDbEvent);
begin
  FOnGetDb := Value;
end;

procedure TmstMasterPlanModule.SetDrawBox(aDrawBox: TEzBaseDrawBox);
begin
  FDrawBox := aDrawBox;
end;

procedure TmstMasterPlanModule.UnloadAllFromGis;
begin
  memEzData.First;
  while not memEzData.Eof  do
  begin
    if FEzAdapter.Loaded then
      UnloadFromGis(FEzAdapter.Id);
    memEzData.Next;
  end;
end;

function TmstMasterPlanModule.UnloadFromGis(const ObjId: Integer): Boolean;
var
  Layer: TEzBaseLayer;
begin
  if not LocateObj(ObjId, memEzData) then
    Exit;
  if IsLoaded(ObjId) then
  begin
    Layer := GetMPLayer();
    Layer.DeleteEntity(FEzAdapter.EzRecno);
    FEzAdapter.Loaded := False;
    FEzAdapter.EzRecno := -1;
  end;
end;

procedure TmstMasterPlanModule.UpdateLayersVisibility(aLayers: TmstLayerList);
var
  L: TmstLayer;
begin
  L := aLayers.GetByName(SL_MASTER_PLAN, False);
  UpdateLayerVisibility(L);
end;

procedure TmstMasterPlanModule.UpdateLayerVisibility(aLayer: TmstLayer);
var
  I: Integer;
begin
  if aLayer = nil then
    Exit;
  if aLayer.IsMP then
  begin
    if aLayer.MpCategoryId = 0 then
      Classifier.SetMPStatusVisible(aLayer.MpStatusId, aLayer.Visible)
    else
      Classifier.SetMPCategoryVisible(aLayer.MpStatusId, aLayer.MpCategoryId, aLayer.Visible);
    for I := 0 to aLayer.ChildCount - 1 do
      UpdateLayerVisibility(aLayer.Child[I]);
  end;
end;

end.
