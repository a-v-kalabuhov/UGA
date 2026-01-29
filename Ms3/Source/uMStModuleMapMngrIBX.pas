unit uMStModuleMapMngrIBX;

interface

{$I uMStFlags.pas}

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, DB, IBDatabase, IBQuery, Contnrs,
  //
  EzLib, EzBaseGIS, EzEntities,
  //
  uGC, uCommonUtils, uIBXUtils, SciZipFile, uGeoUtils,
  //
  uMStConsts, uMStKernelTypes, 
  uMStKernelAppModule, uMStKernelSemantic, uMStKernelClassesOptions, uMStKernelGISUtils,
  uMStKernelClasses, uMStKernelConsts, uMStKernelInterfaces, uMStKernelIBX, uMStKernelIBXLotLoader,
  uMStImportEzClasses,
  uMStDialogLogin,
  uMStClassesLots, uMStClassesProjects, uMStClassesProjectsMP,
  uMStModuleStats, uMStModuleGlobalParameters, uMStFTPConnection, uMStModuleOrders, uMStModuleLotData,
  uMStModuleMPColorSettings;

type
  TmstDataKind = (dkMaps, dkLayers, dkStreets, dkAddresses, dkLotsMain);
  TProgressEvent = procedure (Sender: TObject; Current, Count: Integer) of object;

  TIBXConnection = class(TInterfacedObject, IIBXConnection)
  private
    FCounter: Integer;
    FDataSets: TComponent;
    FTransaction: TIBTransaction;
    procedure ClearDataSets;
  protected
    procedure ExecDataSet(DataSet: TDataSet);
    procedure ExecSQL(const Sql: string);
    function  GetDataSet(const aSQL: String): TDataSet;
    function  GetGenValue(const GenName: string): Integer;
    function  GenNextValue(const GenName: string): Integer;
    function  GetRecordCount(const aSQL: String; const Fetch: Boolean): Integer;
    procedure SetNullableParam(DataSet: TDataSet; const ParamName: String; const ParamValue: Variant;
      const NullValue: Variant);
    procedure SetParam(DataSet: TDataSet; const ParamName: String; const ParamValue: Variant);
    procedure SetBlobParam(DataSet: TDataSet; const ParamName: String; Stream: TStream);
    procedure Commit();
    procedure Rollback();
  public
    constructor Create;
    destructor Destroy; override;
  end;

  TMStIBXMapMngr = class(TDataModule, ISqlSource, IDb, ImstLotCategories)
    dbKis: TIBDatabase;
    dbGeo: TIBDatabase;
    procedure OnLogin(Database: TIBDatabase; LoginParams: TStrings);
    procedure dbKisBeforeConnect(Sender: TObject);
    procedure dbGeoBeforeConnect(Sender: TObject);
    procedure DataModuleCreate(Sender: TObject);
  private
    FIP: string;
    FUser: TmstUser;
    FUsers: TStringList;
    FConnected: Boolean;
    FLotCategories: TObjectList;
    FMPLayers: TObjectList;
    function OnLogonUser(const PeopleId: Integer;
      const UserName, RoleName, Password: String): Boolean;
    procedure GetLastUser(var OfficeId, UserID: Integer);
    function GetCanPrint(): Boolean;
    function GetCanManageProjects: Boolean;
    function GetMapReportErrorMode(): TmstMapReportErrorMode;
    procedure LoadLotCategoriesLayers(aLayerList: TmstLayerList);
    function GetLotCategoriesCount: Integer;
    function GetLotCategories(Index: Integer): TmstLotCategory;
    procedure LoadMasterPlanLayers(aLayerList: TmstLayerList);
    procedure LoadMasterPlanSubLayers(aLayer: TmstLayer; const aStatusId, aLayerId: Integer; var Position: Integer);
    procedure LoadMPLayers();
    procedure AddMPLayer(aMPLayer: TmstMPLayer; aParentLayer: TmstLayer;const aStatusId: Integer; AddedLayers: TList; var Position: Integer);
  private
    FAppModule: ImstAppModule;
    FUserLogActive: Boolean;
    procedure LoadLotCategories();
    procedure SetAppModule(const Value: ImstAppModule);
    function GetAppInfo: string;
  protected
    function  GetConnection(Mode: TConnectionMode; DbMode: TDbMode): IIBXConnection;
    procedure SetConnected(const Value: Boolean);
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;

    procedure AfterMapsPrint(MapNames: TStrings; Order: IOrder);
    function  ClearMapImages(var MapFiles: TStringList): Boolean;
    procedure ConnectToDB(Obj: TObject);
    function  DeleteMapImage(aMapList: TmstMapList; aMap: TmstMap): Boolean;
    procedure DeleteMaps;
    procedure DownloadSpatialDataFiles(const DirectoryName: String);
    //
    function  GetLotById(const LotId: Integer): TmstLot;
    function  GetLots(aLot: TmstLot): ILots;
    function  GetLotIdsByField(const FieldName, Value: String): TList;
    //
    function  GetProjectById(const aId: Integer): TmstProject;
    function  GetProjectIdsByField(const FieldName, Value: String): TList;
    function  GetMapImage(aMapList: TmstMapList; aMap: TmstMap; const Directory: String): Boolean;
    function  GetOrders(): IOrders;
    function  GetParameters(): IParameters;
    function  GetStats: IStats;
    function  GetUserList(OfficeId: Integer): TStrings;
    procedure LoadAddresses(aAddressList: TmstAddressList);
    procedure LoadLayers(aLayerList: TmstLayerList);
    procedure LoadLots(const Rect: TEzRect; LotList: TmstLotList;
      Layer: TEzBaseLayer; LotCategory: Integer; CallBack: TProgressEvent2);
    procedure LoadMaps(aMapList: TmstMapList);
    procedure LoadProjects(const Rect: TEzRect; aList: TmstObjectList; CallBack: TProgressEvent2);
    procedure LoadRedLines(Layer: TEzBaseLayer);
    procedure LoadStreets(aStreetList: TmstStreetList); 
    function  Logon(aUser: TmstUser): Boolean;
    procedure LogUserAcion(const UserAction, Info: string);
    function  SetMapImage(aMapList: TmstMapList; aMap: TmstMap; const FileName: String): Boolean;
    procedure DeleteLayer(aLayer: TmstLayer);
    procedure SaveLayer(aLayer: TmstLayer);
    function GenId(const aTable: string): Integer;
    function LayerHasSemantic(aLayer: TmstLayer): Boolean;
    function GetSemanticFields(const ObjId: string): TmstObjectSemantic;
    function SelectOrg(var Id: Integer; out OrgName: string): Boolean;
    //
    procedure LoadSettings();
    //
    procedure LogException(E: Exception; Info: TStrings);
    //
    property Connected: Boolean read FConnected write SetConnected;
    //
    property AppModule: ImstAppModule read FAppModule write SetAppModule;
    property LotCategoriesCount: Integer read GetLotCategoriesCount;
    property LotCategories[Index: Integer]: TmstLotCategory read GetLotCategories;
    function CategoryById(CategoryId: Integer): TmstLotCategory;
  public
    function GetSqlText(Conn: IIBXConnection; const aName: string): string;
    function GetSqlTextOrCrash(Conn: IIBXConnection; const aName: string): string;
  public
    procedure LoadSettingValue(const aSettingName: string; out Value: string; out Exists: Boolean);
    procedure SaveSettingValue(const aSettingName: string; const Value: string);
  end;

implementation

uses
  uMStModuleApp,
  uMStClassesMPStatuses, uMStClassesProjectsUtils,
  uMStDialogSelectOrg;

{$R *.dfm}

const
  SQ_GET_LAYERS = 'SELECT * FROM LAYERS ORDER BY LAYER_POSITION';
  SQ_GET_LAYERS_BY_PARENT = 'SELECT ID, PARENT_ID FROM LAYERS WHERE NOT PARENT_ID IS NULL ORDER BY PARENT_ID DESC';
  SQ_GET_STREETS = 'SELECT ID, NAME, STREET_MARKING_NAME FROM STREETS ORDER BY ID';
  SQ_GET_ADDRESSES = 'SELECT * FROM ADDRESSES';
  SQ_GET_MAPS = 'SELECT ID, NOMENCLATURE FROM MAP_IMAGES';
  SQ_GET_RED_LINES = 'SELECT RED_LINES_ID, X, Y FROM RED_LINE_POINTS ORDER BY RED_LINES_ID, ID';
  SQ_GET_KIOSKS = 'SELECT * FROm KIOSKS ORDER BY ID';
  SQ_GET_KIOSK_POINTS = 'SELECT * FROM KIOSK_POINTS ORDER BY KIOSK_ID, ID';
  SQ_GET_ALLOTMENT_CONTOURS = 'SELECT * FROM GET_CONTOURS_BY_RECT(:MINX, :MAXX, :MINY, :MAXY, :CHECKED, :CANCELLED) ORDER BY ALLOTMENTS_ID, ID';
  SQ_GET_ALLOTMENT_POINTS = 'SELECT * FROM GET_POINTS_BY_RECT(:MINX, :MAXX, :MINY, :MAXY, :CHECKED, :CANCELLED) ORDER BY ALLOTMENTS_ID, CONTOURS_ID, ID';
  SQ_GET_ALLOTMENT_MAIN_DATA = 'SELECT ID, ADDRESS, DOC_NUMBER, DOC_DATE, AREA, EXECUTOR, CHECKED, CANCELLED, VRS '
    + 'FROM ALLOTMENTS WHERE ID=:ID';
  SQ_GET_CONTOUR_POINTS = 'SELECT * FROM ALLOTMENT_POINTS WHERE ALLOTMENTS_ID=:ID AND CONTOURS_ID=:CONTOURS_ID ORDER BY ID';
  SQ_GET_CONTOURS_FOR_ALLOTMENT = 'SELECT * FROM ALLOTMENT_CONTOURS WHERE ALLOTMENTS_ID=:ID ORDER BY ID';
  SQ_SAVE_PRINTED_MAP =
      'INSERT INTO PRINTED_MAPS(ACCOUNT_NAME, NOMENCLATURE, OFFICES_ID, PEOPLE_ID, USER_NAME) '
    + 'VALUES (:ACCOUNT_NAME, :NOMENCLATURE, :OFFICES_ID, :PEOPLE_ID, :USER_NAME)';
  SQ_LOG_USER_ACTION =
      'INSERT INTO USER_LOG (OFFICES_ID, PEOPLE_ID, IP_ADDRESS, USER_NAME, ACCOUNT_NAME, USER_ACTION, DETAILS) '
    + 'VALUES (:OFFICES_ID, :PEOPLE_ID, :IP_ADDRESS, :USER_NAME, :ACCOUNT_NAME, :USER_ACTION, :DETAILS)';
  SQ_GET_OFFICES = 'SELECT ID, NAME FROM OFFICES ORDER BY NAME';
  SQ_GET_PARAMETERS = 'SELECT MAP_REPORT_ERROR_MODE FROM PARAMETERS';
  SQ_GET_PEOPLE = 'SELECT ID, FULL_NAME FROM PEOPLE ORDER BY FULL_NAME';
  SQ_GET_PEOPLE_1 = 'SELECT ID, INITIAL_NAME FROM PEOPLE ORDER BY INITIAL_NAME';
  SQ_GET_PEOPLE_2 = 'SELECT ID, INITIAL_NAME FROM PEOPLE WHERE OFFICE_ID=%d ORDER BY INITIAL_NAME';
  SQ_GET_PEOPLE_RIGHTS = 'SELECT CAN_MS_PRINT, CAN_MS_PROJECTS FROM PEOPLE WHERE ID=%d';

  SQL_GET_LOT_CATEGORIES = 'SELECT * FROM LOT_KINDS ORDER BY ID';
//  SQ_GET_ALLOTMENT_CONTOURS = 'SELECT * FROM GET_CONTOURS_BY_RECT(:MINX, :MAXX, :MINY, :MAXY, :CHECKED, :CANCELLED) ORDER BY ALLOTMENTS_ID, ID';
//  SQ_GET_ALLOTMENT_POINTS = 'SELECT * FROM GET_POINTS_BY_RECT(:MINX, :MAXX, :MINY, :MAXY, :CHECKED, :CANCELLED) ORDER BY ALLOTMENTS_ID, CONTOURS_ID, ID';
//  SQ_GET_CONTOURS_FOR_ALLOTMENT = 'SELECT * FROM ALLOTMENT_CONTOURS WHERE ALLOTMENTS_ID=:ID ORDER BY ID';
//  SQ_GET_POINTS_FOR_ALLOTMENT = 'SELECT * FROM ALLOTMENT_POINTS WHERE ALLOTMENTS_ID=:ID ORDER BY CONTOURS_ID, ID';
//  SQ_GET_ALLOTMENT_MAIN_DATA = 'SELECT ID, ADDRESS, DOC_NUMBER, DOC_DATE, AREA, EXECUTOR, CHECKED, CANCELLED, VRS '
//    + 'FROM ALLOTMENTS WHERE ID=:ID';

  SQL_GET_SQL_TEXT = 'SELECT SQL_TEXT FROM SQL_QUERIES WHERE NAME=:NAME';

  SQL_GET_LOTS_XY_COUNT_WITH_KIND = 'GET_LOTS_XY_COUNT_WITH_KIND';
  SQL_GET_LOTS_XY_WITH_KIND = 'GET_LOTS_XY_WITH_KIND';
  SQL_GET_ALLOTMENTS = 'SELECT * FROM GET_ALLOTMENTS_BY_RECT(:MINX, :MAXX, :MINY, :MAXY, :CHECKED, :CANCELLED)';
  SQL_GET_ALLOTMENTS_COUNT = 'SELECT COUNT(*) FROM GET_ALLOTMENTS_BY_RECT(:MINX, :MAXX, :MINY, :MAXY, :CHECKED, :CANCELLED)';
  SQL_GET_ALLOTMENT_CONTOURS = 'SELECT * FROM GET_CONTOURS_BY_RECT(:MINX, :MAXX, :MINY, :MAXY, :CHECKED, :CANCELLED) ORDER BY ALLOTMENTS_ID, ID';
  SQL_GET_ALLOTMENT_POINTS = 'SELECT * FROM GET_POINTS_BY_RECT(:MINX, :MAXX, :MINY, :MAXY, :CHECKED, :CANCELLED) ORDER BY ALLOTMENTS_ID, CONTOURS_ID, ID';
  SQL_GET_ALLOTMENT_MAIN_DATA = 'GET_ALLOTMENT_MAIN_DATA';
  SQL_GET_CURRENT_ID = 'SELECT GEN_ID(%s_GEN, 0) FROM RDB$DATABASE';
  SQL_GET_NEXT_ID = 'SELECT GEN_ID(%s_GEN, 1) FROM RDB$DATABASE';
  SQL_GET_LAYER_HAS_SEMANTIC = 'SELECT FIRST 1 ID FROM LAYERS_SEMANTIC WHERE LAYERS_ID=:LAYERS_ID';
//  SQL_GET_LAYER_HAS_SEMANTIC = 'SELECT COUNT(ID) FROM LAYERS_SEMANTIC WHERE LAYERS_ID=:LAYERS_ID';
  SQL_GET_OBJECT_SEMANTIC = 'SELECT * FROM LAYERS_SEMANTIC WHERE OBJECT_ID=:OBJECT_ID';
  SQL_LOG_ERROR = 'INSERT INTO ERROR_LOG ("MESSAGE", CLASS_NAME, NATIVE_MESSAGE, NATIVE_CLASS_NAME, DEBUG_INFO, OBJECT_INFO) '
    + 'VALUES(:MES, :CLASS, ''-'', ''-'', :INFO, :INFO2)';
//  SQL_GET_SETTINGS = 'SELECT * FROM SETTINGS';
  SQL_GET_MP_LAYERS = 'SELECT * FROM MASTER_PLAN_LAYERS ORDER BY ID, GROUP_ID';

  SQ_GET_SETTING_VALUE = 'SELECT NAME, "VALUE" FROM SETTINGS WHERE NAME=:NAME';
  SQ_INSERT_SETTING_VALUE = 'INSERT INTO SETTINGS (NAME, "VALUE") VALUES (:NAME, :VALUE)';
  SQ_UPDATE_SETTING_VALUE = 'UPDATE SETTINGS SET "VALUE"=:VALUE WHERE NAME=:NAME';

const
  ProjectPlanSubLayers: array [0..9] of string = (
    'Газ',
    'Вода',
    'Канализация',
    'Канализация ливневая',
    '',
    '',
    '',
    '',
    '',
    '');

  { TMStIBXMapMngr }

procedure TMStIBXMapMngr.SaveLayer(aLayer: TmstLayer);
var
  Conn: IIBXConnection;
  dsSaveLayer: TDataSet;
  Sql: string;
begin
  Conn := GetConnection(cmReadWrite, dmGeo);
  // если есть id то обновляем
  // если нет id то вставляем
  if aLayer.Id = 0 then
  begin
    aLayer.Id := Conn.GenNextValue(SG_LAYERS);
    //
    Sql := 'insert into LAYERS (ID, NAME, VISIBLE_NAME, LAYER_TYPE, VISIBLE, LAYER_POSITION) ' + sLineBreak +
           'values (:ID, :NAME, :VISIBLE_NAME, :LAYER_TYPE, :VISIBLE, :LAYER_POSITION)';
  end
  else
  begin
    Sql :=  'update LAYERS ' +
            'set NAME = :NAME, ' +
            '    VISIBLE_NAME = :VISIBLE_NAME, ' +
            '    LAYER_TYPE = :LAYER_TYPE, ' +
            '    VISIBLE = :VISIBLE, ' +
            '    LAYER_POSITION = :LAYER_POSITION ' +
            'where (ID = :ID)';
  end;
  dsSaveLayer := Conn.GetDataSet(Sql);
  Conn.SetParam(dsSaveLayer, SF_ID, aLayer.Id);
  Conn.SetParam(dsSaveLayer, SF_NAME, aLayer.Name);
  Conn.SetParam(dsSaveLayer, SF_VISIBLE_NAME, aLayer.Caption);
  Conn.SetParam(dsSaveLayer, SF_LAYER_TYPE, aLayer.LayerType);
  Conn.SetParam(dsSaveLayer, SF_VISIBLE, aLayer.Visible);
  Conn.SetParam(dsSaveLayer, SF_LAYER_POSITION, aLayer.Position);
  Conn.ExecDataSet(dsSaveLayer);
end;

procedure TMStIBXMapMngr.SaveSettingValue(const aSettingName, Value: string);
var
  Conn: IIBXConnection;
  Ds: TDataSet;
  Sql: string;
  Exists: Boolean;
  NewId: Integer;
begin
  Conn := GetConnection(cmReadWrite, dmKis);
  Ds := Conn.GetDataSet(SQ_GET_SETTING_VALUE);
  Conn.SetParam(Ds, SF_NAME, aSettingName);
  Ds.Open;
  try
    Exists := Ds.RecordCount > 0;
  finally
    Ds.Close;
  end;
  if Exists then
    Sql := SQ_UPDATE_SETTING_VALUE
  else
    Sql := SQ_INSERT_SETTING_VALUE;
  Ds := Conn.GetDataSet(Sql);
  Conn.SetParam(Ds, SF_NAME, aSettingName);
  Conn.SetParam(Ds, SF_VALUE, Value);
  Conn.ExecDataSet(Ds);
end;

function TMStIBXMapMngr.SelectOrg(var Id: Integer; out OrgName: string): Boolean;
begin
  if mstSelectOrgDialog = nil then
  begin
    mstSelectOrgDialog := TmstSelectOrgDialog.Create(Self);
  end;
  Result := mstSelectOrgDialog.Execute(Id, OrgName);
end;

procedure TMStIBXMapMngr.SetAppModule(const Value: ImstAppModule);
begin
  FAppModule := Value;
end;

procedure TMStIBXMapMngr.SetConnected(const Value: Boolean);
begin
  dbKis.Connected := True;
  dbGeo.Connected := True; 
  inherited;
end;

procedure TMStIBXMapMngr.OnLogin(Database: TIBDatabase; LoginParams: TStrings);
begin
  inherited;
  {.$IFDEF DEFAULT_USER}
//  LoginParams.Clear;
  LoginParams.Values['lc_ctype'] := 'WIN1251';
  LoginParams.Values['user_name'] := FUser.UserName;
  LoginParams.Values['password'] := FUser.Password;
//  LoginParams.Add('lc_ctype=WIN1251');
//  LoginParams.Add('user_name=SYSDBA');
//  LoginParams.Add('password=masterkey');
  {.$ENDIF}
end;

procedure TMStIBXMapMngr.LoadLayers(aLayerList: TmstLayerList);
var
  Conn: IIBXConnection;
  DataSet: TDataSet;
  Layer: TmstLayer;
  ParentId: Integer;
  LayerId: Integer;
begin
  if Assigned(aLayerList) then
  begin
    Conn := GetConnection(cmReadOnly, dmGeo);
    DataSet := Conn.GetDataSet(SQ_GET_LAYERS);
    DataSet.Active := True;
    try
      aLayerList.Clear;
      //
      while not DataSet.Eof do
      begin
        Layer := aLayerList.AddLayer();
        Layer.Id := DataSet.FieldByName(SF_ID).AsInteger;
        Layer.Name := DataSet.FieldByName(SF_NAME).AsString;
        Layer.Caption := DataSet.FieldByName(SF_VISIBLE_NAME).AsString;
        Layer.Position := DataSet.FieldByName(SF_LAYER_POSITION).AsInteger;
        Layer.LayerType := DataSet.FieldByName(SF_LAYER_TYPE).AsInteger;
        Layer.Visible := Boolean(DataSet.FieldByName(SF_VISIBLE).AsInteger);
        DataSet.Next;
      end;
    finally
      DataSet.Active := False;
    end;
    //
    DataSet := Conn.GetDataSet(SQ_GET_LAYERS_BY_PARENT);
    DataSet.Active := True;
    try
      DataSet.First;
      while not DataSet.Eof do
      begin
        ParentId := DataSet.FieldByName(SF_PARENT_ID).AsInteger;
        if ParentId <> 0 then
        begin
          LayerId := DataSet.FieldByName(SF_ID).AsInteger;
          Layer := aLayerList.GetById(LayerId);
          if Assigned(Layer) then
            aLayerList.Connect(Layer, ParentId);
        end;
        DataSet.Next;
      end;
    finally
      DataSet.Active := False;
    end;
  end;
  //
  LoadLotCategoriesLayers(aLayerList);
  //
  LoadMasterPlanLayers(aLayerList);
end;

function TMStIBXMapMngr.GenId(const aTable: string): Integer;
var
  Conn: IIBXConnection;
begin
  Conn := GetConnection(cmReadOnly, dmGeo);
  try
    Result := Conn.GenNextValue(aTable);
  finally
    Conn.Commit;
  end;
end;

function TMStIBXMapMngr.GetAppInfo: string;
begin
  Result := #13#10 + #13#10 + 'Active Form:' + #13#10;
  if Assigned(Screen.ActiveForm) then
    Result := Result + 'Class = ' + Screen.ActiveForm.ClassName + #13#10 +
      'Name = ' + Screen.ActiveForm.Name + #13#10 + 'Caption = ' + Screen.ActiveForm.Caption
  else
    Result := Result + 'none';
  Result := Result + #13#10 + #13#10;
  if Screen.ActiveCustomForm <> Screen.ActiveForm then
  begin
    Result := 'Active Custom Form:' + #13#10;
    if Assigned(Screen.ActiveCustomForm) then
      Result := Result + 'Class = ' + Screen.ActiveCustomForm.ClassName + #13#10 +
        'Name = ' + Screen.ActiveCustomForm.Name + #13#10 + 'Caption = ' + Screen.ActiveCustomForm.Caption
    else
      Result := Result + 'none';
  end;
  Result := Result + #13#10 + #13#10 + GetVersionInfo(Application.ExeName);
  Result := Result + #13#10 + #13#10 + 'Exe file: ' + Application.ExeName;
end;

function TMStIBXMapMngr.GetCanManageProjects: Boolean;
var
  Conn: IIBXConnection;
  Ds: TDataSet;
begin
  Result := False;
  if FUser.Id > 0 then
  begin
    Conn := GetConnection(cmReadOnly, dmKis);
    Ds := Conn.GetDataSet(Format(SQ_GET_PEOPLE_RIGHTS, [FUser.Id]));
    Ds.Open;
    if not Ds.Eof then
      Result := Ds.FieldByName(SF_CAN_MS_PROJECTS).AsInteger > 0;
  end;
end;

function TMStIBXMapMngr.GetCanPrint: Boolean;
var
  Conn: IIBXConnection;
  Ds: TDataSet;
begin
  Result := False;
  if FUser.Id > 0 then
  begin
    Conn := GetConnection(cmReadOnly, dmKis);
    Ds := Conn.GetDataSet(Format(SQ_GET_PEOPLE_RIGHTS, [FUser.Id]));
    Ds.Open;
    if not Ds.Eof then
      Result := Ds.FieldByName(SF_CAN_MS_PRINT).AsInteger > 0;
  end;
end;

function TMStIBXMapMngr.GetConnection(Mode: TConnectionMode; DbMode: TDbMode): IIBXConnection;
var
  Tmp: TIBXConnection;
  AccessMode: TIBAccessMode;
begin
  Tmp := TIBXConnection.Create;
  Tmp.FTransaction := TIBTransaction.Create(nil);
  case DbMode of
  dmGeo :
    Tmp.FTransaction.DefaultDatabase := dbGeo;
  dmKis :
    Tmp.FTransaction.DefaultDatabase := dbKis;
  end;
  case Mode of
  cmReadOnly  : AccessMode := amReadOnly;
  cmReadWrite : AccessMode := amReadWrite;
  cmWriteOnly : AccessMode := amWriteOnly;
  else          AccessMode := amReadOnly;
  end;
  Tmp.FTransaction.Init(ilReadCommited, AccessMode);
  Result := Tmp;
end;

procedure TMStIBXMapMngr.DownloadSpatialDataFiles(const DirectoryName: String);
var
  InStream, OutStream: TStream;
begin
  inherited;
  InStream := nil;
  OutStream := nil;
  if not Options.DontUseFTP then
    with TMStFTPConnection.Create(Self) do
    try
      Init(Fuser.IsAdministrator,
           mstClientAppModule.GetOption('FTP', 'Host', ''),
           StrToInt(mstClientAppModule.GetOption('FTP', 'Port', '21')));
      InStream := GetDataFile('');
      InStream.Position := 0;
      OutStream := TFileStream.Create(DirectoryName + 'data.zip', fmCreate);
      OutStream.CopyFrom(InStream, InStream.Size);
    finally
      Free;
      FreeAndNil(InStream);
      FreeAndNil(OutStream);
    end
  else
  begin
    CopyFile(
      PChar(ExtractFilePath(Application.ExeName) + 'data.zip'),
      PChar(DirectoryName + 'data.zip'), False
    );
  end;
  if FileExists(DirectoryName + 'data.zip') then
    UnzipFile(DirectoryName + 'data.zip', DirectoryName, True);
end;

procedure TMStIBXMapMngr.LoadSettings;
var
  SettName, SettVal: string;
  VFloat: Double;
  Exists: Boolean;
  VInt: Integer;
begin
  LoadSettingValue('PROJECT_LINE_WIDTH', SettVal, Exists);
  if Exists then
  begin
    if TryStrToFloat(SettVal, VFloat) then
      TProjectsSettings.PenWidth := VFloat;
  end;
  //
  TmstMPColorSettingsModule.LinePenWidth := 1;
  LoadSettingValue('MP_LINE_WIDTH', SettVal, Exists);
  if Exists then
  begin
    if TryStrToInt(SettVal, VInt) then
      TmstMPColorSettingsModule.LinePenWidth := VInt;
  end;
  //
  TmstMPColorSettingsModule.EdgingWidth := 1;
  LoadSettingValue('MP_EDGING_WIDTH', SettVal, Exists);
  if Exists then
  begin
    if TryStrToInt(SettVal, VInt) then
      TmstMPColorSettingsModule.EdgingWidth := VInt;
  end;
end;

procedure TMStIBXMapMngr.LoadSettingValue(const aSettingName: string; out Value: string; out Exists: Boolean);
var
  Conn: IIBXConnection;
  Ds: TDataSet;
  Sql: string;
  NewId: Integer;
begin
  Value := '';
  Conn := GetConnection(cmReadOnly, dmKis);
  Ds := Conn.GetDataSet(SQ_GET_SETTING_VALUE);
  Conn.SetParam(Ds, SF_NAME, aSettingName);
  Ds.Open;
  try
    Exists := Ds.RecordCount > 0;
    if Exists then
      Value := Ds.FieldByName(SF_VALUE).AsString;
  finally
    Ds.Close;
  end;
end;

procedure TMStIBXMapMngr.LoadStreets(aStreetList: TmstStreetList);
var
  Conn: IIBXConnection;
  DataSet: TDataSet;
  Street: TmstStreet;
begin
  if Assigned(aStreetList) then
  begin
    Conn := GetConnection(cmReadOnly, dmKis);
    DataSet := Conn.GetDataSet(SQ_GET_STREETS);
    begin
      DataSet.Active := True;
      aStreetList.Clear;
      while not DataSet.Eof do
      begin
        Street := aStreetList.AddStreet;
        Street.DatabaseId := DataSet.FieldByName(SF_ID).AsInteger;
        Street.Name := DataSet.FieldByName(SF_NAME).AsString;
        Street.Mark := DataSet.FieldByName(SF_STREET_MARKING_NAME).AsString;
        DataSet.Next;
      end;
      DataSet.Active := False;
    end;
  end;
end;

function TMStIBXMapMngr.LayerHasSemantic(aLayer: TmstLayer): Boolean;
var
  Conn: IIBXConnection;
  DataSet: TDataSet;
begin
  Conn := GetConnection(cmReadOnly, dmGeo);
  DataSet := Conn.GetDataSet(SQL_GET_LAYER_HAS_SEMANTIC);
  Conn.SetParam(DataSet, 'LAYERS_ID', aLayer.Id);
  DataSet.Active := True;
  Result := not DataSet.Eof;
  DataSet.Active := False;
end;

procedure TMStIBXMapMngr.LoadAddresses(aAddressList: TmstAddressList);
var
  Conn: IIBXConnection;
  DataSet: TDataSet;
  Address: TmstAddress;
begin
  if Assigned(aAddressList) then
  begin
    Conn := GetConnection(cmReadOnly, dmGeo);
    DataSet := Conn.GetDataSet(SQ_GET_ADDRESSES);
    begin
      DataSet.Active := True;
      aAddressList.Clear;
      while not DataSet.Eof do
      begin
        Address := aAddressList.AddAddress;
        Address.DatabaseId := DataSet.FieldByName(SF_ID).AsInteger;
        Address.Name := DataSet.FieldByName(SF_NAME).AsString;
        Address.Color := DataSet.FieldByName(SF_COLOR).AsInteger;
        Address.StreetDatabaseId := DataSet.FieldByName(SF_EXT_STREET_ID).AsInteger;
        Address.X := DataSet.FieldByName(SF_X).AsFloat;
        Address.Y := DataSet.FieldByName(SF_Y).AsFloat;
        Address.Angle := DataSet.FieldByName(SF_ANGLE).AsFloat;
        Address.Height := DataSet.FieldByName(SF_HEIGHT).AsFloat;
        DataSet.Next;
      end;
      DataSet.Active := False;
    end;
  end;
end;

procedure TMStIBXMapMngr.LoadMaps(aMapList: TmstMapList);
var
  Conn: IIBXConnection;
  DataSet: TDataSet;
  Map: TmstMap;
begin
  if Assigned(aMapList) then
  begin
    Conn := GetConnection(cmReadOnly, dmGeo);
    DataSet := Conn.GetDataSet(SQ_GET_MAPS);
    begin
      DataSet.Active := True;
      aMapList.Clear;
      while not DataSet.Eof do
      begin
        Map := aMapList.AddMap;
        Map.DatabaseId := DataSet.FieldByName(SF_ID).AsInteger;
        Map.MapName := DataSet.FieldByName(SF_NOMENCLATURE).AsString;
        DataSet.Next;
      end;
      DataSet.Active := False;
    end;
  end;
end;

procedure TMStIBXMapMngr.LoadMPLayers;
var
  Conn: IIBXConnection;
  DataSet: TDataSet;
  L: TmstMPLayer;
begin
  FMPLayers.Clear;
  //
  Conn := GetConnection(cmReadOnly, dmKis);
  DataSet := Conn.GetDataSet(SQL_GET_MP_LAYERS);
  begin
    DataSet.Active := True;
    while not DataSet.Eof do
    begin
      L := TmstMPLayer.Create;
      FMPLayers.Add(L);
      L.Id := DataSet.FieldByName(SF_ID).AsInteger;
      L.Name := DataSet.FieldByName(SF_NAME).AsString;
      L.IsGroup := DataSet.FieldByName(SF_IS_GROUP).AsInteger;
      L.GroupId := DataSet.FieldByName(SF_GROUP_ID).AsInteger;
      DataSet.Next;
    end;
    DataSet.Active := False;
  end;
end;

procedure TMStIBXMapMngr.LoadMasterPlanLayers(aLayerList: TmstLayerList);
var
  LLayer: TmstLayer;
  LayerId: Integer;
  Position: Integer;
  I: Integer;
begin
  LoadMPLayers(); // зарузка из БД
  if Assigned(aLayerList) then
  begin
    Position := aLayerList.GetMaxPosition + 1;
    LLayer := aLayerList.GetByName(SL_MASTER_PLAN, False);
    if LLayer = nil then
    begin
      //
      LLayer := aLayerList.AddLayer();
      LLayer.Caption := 'Сводный план';
      LLayer.Position := Position;
      LayerId := TProjectUtils.GetMPLayerCode(0, 0);//50000000;
      LLayer.Id := LayerId;
      LLayer.Name := SL_MASTER_PLAN;//TProjectUtils.GetMPLayerName(0, 0);
    end;
    Inc(Position);
    LLayer.LayerType := 2;
    LLayer.Visible := True;
    LLayer.IsMP := True;
    LLayer.MpStatusId := 0;
    LLayer.MpCategoryId := 0;
    //
    for I := TmstMPStatuses.MinId to TmstMPStatuses.MaxId do
    begin
      LoadMasterPlanSubLayers(LLayer, I, LayerId, Position);
    end;
  end;
end;

procedure TMStIBXMapMngr.LoadMasterPlanSubLayers(aLayer: TmstLayer;
 const aStatusId, aLayerId: Integer; var Position: Integer);
var
  SubLayer: TmstLayer;
//  Layer, ElLayer: TmstLayer;
//  LayerId, ElLayerId: Integer;
  I: Integer;
  MpL: TmstMPLayer;
  Added: TList;
begin
  SubLayer := aLayer.AddChild();
  SubLayer.Id := TProjectUtils.GetMPLayerCode(aStatusId, 0);
  SubLayer.Name := TProjectUtils.GetMPLayerName(aStatusId, 0);
  SubLayer.Caption := TmstMPStatuses.StatusName(aStatusId);
  SubLayer.Position := Position;
  SubLayer.LayerType := 2;
  SubLayer.Visible := True;
  SubLayer.IsMP := True;
  SubLayer.MpStatusId := aStatusId;
  SubLayer.MpCategoryId := 0;
  Inc(Position);
  //
  Added := TList.Create;
  try
    for I := 0 to FMPLayers.Count - 1 do
    begin
      MpL := TmstMPLayer(FMPLayers[I]);
      if MpL.GroupId = 0 then
        AddMPLayer(MpL, SubLayer, aStatusId, Added, Position);
    end;
  finally
    Added.Free;
  end;
end;

procedure TMStIBXMapMngr.LoadProjects(const Rect: TEzRect; aList: TmstObjectList; CallBack: TProgressEvent2);
var
  Loader: IEzProjectLoader;
begin
  inherited;
  if Assigned(aList) then
  begin
    Loader := TMStEzProjectLoaderFactory.CreateLoader(False);
    Loader.SetDb(Self as IDb);
    Loader.SetList(aList);
    Loader.SetRect(Rect);
    Loader.SetSqlSource(Self);
    Loader.Execute(CallBack);
  end;
end;

function TMStIBXMapMngr.GetMapImage(aMapList: TmstMapList;
  aMap: TmstMap; const Directory: String): Boolean;
var
  InStream, OutStream: TStream;
  FileName: String;
  ImgExt: TftpImageExt;
begin
  Result := False;
  if Assigned(aMapList) and Assigned(aMap) then
  begin
    // Смотрим номенклатуру карты
    // Создаем соединение с FTP
    with TMStFTPConnection.Create(Self) do
    try
      Init(Fuser.IsAdministrator,
           mstClientAppModule.GetOption('FTP', 'Host', ''),
           StrToInt(mstClientAppModule.GetOption('FTP', 'Port', '21')));
      // качаем файл
      InStream := GetImgFile(aMap.MapName, ImgExt);
      if inStream <> nil then
      begin
        try
          if InStream.Size > 0 then
          begin
            // увеличиваем счетчик файлов на 1
            aMapList.IncCounter;
            InStream.Position := 0;
            FileName := Directory + IntToStr(aMapList.ImageCounter) + '.map';
            OutStream := TFileStream.Create(FileName, fmCreate);
            try
              OutStream.CopyFrom(InStream, InStream.Size);
            finally
              FreeAndNil(OutStream);
            end;
          end;
        finally
          FreeAndNil(InStream);
        end;
      end;
      // обновляем параметры aMap
      aMap.FileName := FileName;
      aMap.ImageLoaded := True;
      case ImgExt of
        ftpGFA  : aMap.ImageExt := imgGFA;
        ftpBMP  : aMap.ImageExt := imgBMP;
        ftpJPEG : aMap.ImageExt := imgJPEG;
      end;
      Result := True;
    finally
      Free;
    end;
  end;
end;

function TMStIBXMapMngr.GetMapReportErrorMode: TmstMapReportErrorMode;
var
  Conn: IIBXConnection;
  Ds: TDataSet;
begin
  Result := mreDeny;
  if FUser.Id > 0 then
  begin
    Conn := GetConnection(cmReadOnly, dmKis);
    Ds := Conn.GetDataSet(SQ_GET_PARAMETERS);
    Ds.Open;
    if not Ds.Eof then
      Result := TmstMapReportErrorMode(Ds.FieldByName(SF_MAP_REPORT_ERROR_MODE).AsInteger);
  end;
end;

function TMStIBXMapMngr.GetOrders: IOrders;
var
  M: TmstOrdersDataModule;
begin
  M := TmstOrdersDataModule.Create(Self);
  M.trKis.DefaultDatabase := dbKis;
  Result := M as IOrders;
end;

function TMStIBXMapMngr.GetParameters: IParameters;
var
  M: TmstParametersModule;
begin
  M := TmstParametersModule.Create(Self);
  M.trKis.DefaultDatabase := dbKis;
  Result := M as IParameters;
end;

function TMStIBXMapMngr.GetProjectIdsByField(const FieldName, Value: String): TList;
var
  Conn: IIBXConnection;
  DataSet: TDataSet;
begin
  Result := TList.Create;
  Conn := GetConnection(cmReadOnly, dmKis);
  DataSet := Conn.GetDataSet('SELECT ID FROM PROJECTS WHERE UPPER(' + FieldName + ') LIKE :VALUE');
  Conn.SetParam(DataSet, 'VALUE', AnsiUpperCase(Value));
  DataSet.Open;
  while not DataSet.Eof do
  begin
    Result.Add(Pointer(DataSet.Fields[0].AsInteger));
    DataSet.Next;
  end;
  DataSet.Close;
end;

function TMStIBXMapMngr.GetProjectById(const aId: Integer): TmstProject;
begin
  Result := TmstProject.Create;
  Result.DatabaseId := aId;
  if not Result.Load(Self as IDb) then
    FreeAndNil(Result);
end;

function TMStIBXMapMngr.GetSemanticFields(const ObjId: string): TmstObjectSemantic;
var
  Ds: TDataSet;
  Conn: IIBXConnection;
  FldName, FldVal, FldType: string;
  Fld: TmstLayerField;
begin
  Result := TmstObjectSemantic.Create;
  Conn := GetConnection(cmReadOnly, dmGeo);
  Ds := Conn.GetDataSet(SQL_GET_OBJECT_SEMANTIC);
  Conn.SetParam(Ds, SF_OBJECT_ID, ObjId);
  Ds.Open;
  try
    if not Ds.IsEmpty then
    begin
      while not Ds.Eof do
      begin
        FldName := Ds.FieldByName(SF_FIELD_NAME).AsString;
        FldVal := Ds.FieldByName(SF_FIELD_VALUE).AsString;
        FldType := Ds.FieldByName(SF_FIELD_TYPE).AsString;
        //
        Fld := Result.Fields.AddNew;
        Fld.Name := FldName;
        Fld.DataTypeName := FldType;
        Result.FieldValues.Value[FldName] := FldVal;
        //
        Ds.Next;
      end;
    end;
  finally
    Ds.Close;
  end;
end;

function TMStIBXMapMngr.GetSqlText(Conn: IIBXConnection; const aName: string): string;
var
  Ds: TDataSet;
begin
  if Conn = nil then
    Conn := GetConnection(cmReadOnly, dmKis);
  Ds := Conn.GetDataSet(SQL_GET_SQL_TEXT);
  Conn.SetParam(Ds, SF_NAME, aName);
  Ds.Open;
  if not Ds.IsEmpty then
    Result := Ds.Fields[0].AsString
  else
    Result := '';
  Ds.Close;
end;

function TMStIBXMapMngr.GetSqlTextOrCrash(Conn: IIBXConnection; const aName: string): string;
begin
  Result := GetSqlText(Conn, aName);
  if Result = '' then
    raise Exception.Create('Запрос ' + aName + ' не обнаружен!');
end;

function TMStIBXMapMngr.GetStats: IStats;
var
  M: TmstStatDataModule;
begin
  M := TmstStatDataModule.Create(Self);
  M.trKis.DefaultDatabase := dbKis;
  M.trGeo.DefaultDatabase := dbGeo;
  M.ibqOffices.Open;
  M.ibqPeople.Open;
  Result := M as IStats;
end;

function TMStIBXMapMngr.GetUserList(OfficeId: Integer): TStrings;
var
  Conn: IIBXConnection;
  Ds: TDataSet;
  InitialName: String;
  Id: Integer;
begin
  if FUsers = nil then
  begin
    FUsers := TStringList.Create;
    Conn := GetConnection(cmReadOnly, dmKis);
    if OfficeId > 0 then
      Ds := Conn.GetDataSet(Format(SQ_GET_PEOPLE_2, [OfficeId]))
    else
      Ds := Conn.GetDataSet(SQ_GET_PEOPLE_1);
    //
    Ds.Open;
    while not Ds.Eof do
    begin
      Id := Ds.FieldByName(SF_ID).AsInteger;
      InitialName := Ds.FieldByName(SF_INITIAL_NAME).AsString;
      FUsers.AddObject(InitialName, Pointer(Id));
      Ds.Next;
    end;
  end;
  Result := FUsers;
end;

procedure TMStIBXMapMngr.LoadLotCategories;
var
  Conn: IIBXConnection;
  DataSet: TDataSet;
  Category: TmstLotCategory;
begin
  FLotCategories.Clear;
  Category := TmstLotCategory.Create;
  Category.Id := -2;
  Category.Name := SL_ANNULLED_LOTS;
  FLotCategories.Add(Category);
  //
  Category := TmstLotCategory.Create;
  Category.Id := -1;
  Category.Name := SL_ACTUAL_LOTS;
  FLotCategories.Add(Category);
  //
  Category := TmstLotCategory.Create;
  Category.Id := -3;
  Category.Name := SL_LOTS;
  FLotCategories.Add(Category);
  //
  Conn := GetConnection(cmReadOnly, dmKis);
  DataSet := Conn.GetDataSet(SQL_GET_LOT_CATEGORIES);
  begin
    DataSet.Active := True;
    while not DataSet.Eof do
    begin
      Category := TmstLotCategory.Create;
      FLotCategories.Add(Category);
      Category.Id := DataSet.FieldByName(SF_ID).AsInteger;
      Category.Name := DataSet.FieldByName(SF_NAME).AsString;
      DataSet.Next;
    end;
    DataSet.Active := False;
  end;
end;

procedure TMStIBXMapMngr.LoadLotCategoriesLayers(aLayerList: TmstLayerList);
var
  LLayer, Layer: TmstLayer;
  I, LayerId: Integer;
  Category: TmstLotCategory;
  Position: Integer;
begin
  LoadLotCategories();
  if Assigned(aLayerList) then
  begin
    Position := aLayerList.GetMaxPosition + 1;
    if FLotCategories.Count > 0 then
    begin
      LLayer := aLayerList.AddLayer();
      LLayer.Name := SL_LOTS + '_Отводы';//GetUniqueString();
      LLayer.Caption := 'Отводы';
      LLayer.Position := Position;
      Inc(Position);
      LLayer.LayerType := 2;
      LLayer.Visible := True;
      LayerId := MaxInt div 2 + 100;
      LLayer.Id := LayerId;
      LLayer.IsLotCategory := True;
      //
      for I := 0 to FLotCategories.Count - 1 do
      begin
        Category := LotCategories[I];
        if Category.Id >= 0 then
        begin
          Layer := LLayer.AddChild();
          LayerId := LayerId + 1;
          Layer.Id := LayerId;
//          Layer.Name := SL_LOTS + '_Отводы_' + Category.Name;
          Layer.Name := Category.GetLayerName();
          Layer.Caption := 'Отводы - ' + Category.Name;
          Layer.Position := Position;
          Layer.LayerType := 2;
          Layer.Visible := True;
          Layer.IsLotCategory := True;
          Inc(Position);
        end;
      end;
    end;
  end;
end;

procedure TMStIBXMapMngr.LoadLots(const Rect: TEzRect; LotList: TmstLotList;
  Layer: TEzBaseLayer; LotCategory: Integer; CallBack: TProgressEvent2);
var
  Loader: IEzLotLoader;
begin
  inherited;
  if Assigned(LotList) and Assigned(Layer) then
  begin
    Loader := TMStEzLotLoaderFactory.CreateLoader(LotCategory);
    Loader.SetConnection(GetConnection(cmReadOnly, dmKis));
    Loader.SetLayer(Layer);
    Loader.SetLotList(LotList);
    Loader.SetRect(Rect);
    Loader.SetSqlSource(Self);
    Loader.Execute(CallBack);
  end;
end;

function TMStIBXMapMngr.GetLotIdsByField(const FieldName, Value: String): TList;
var
  Conn: IIBXConnection;
  DataSet: TDataSet;
begin
  Result := TList.Create;
  Conn := GetConnection(cmReadOnly, dmKis);
  DataSet := Conn.GetDataSet('SELECT ID FROM ALLOTMENTS WHERE UPPER(' + FieldName + ') LIKE :VALUE');
  Conn.SetParam(DataSet, 'VALUE', AnsiUpperCase(Value));
  DataSet.Open;
  while not DataSet.Eof do
  begin
    Result.Add(Pointer(DataSet.Fields[0].AsInteger));
    DataSet.Next;
  end;
  DataSet.Close;
end;

function TMStIBXMapMngr.GetLotById(const LotId: Integer): TmstLot;
var
  Conn: IIBXConnection;
  DataSet: TDataSet;
  I: Integer;
  Sql1: string;
begin
  Result := nil;
  Conn := GetConnection(cmReadOnly, dmKis);
  Sql1 := GetSqlTextOrCrash(Conn, SQL_GET_ALLOTMENT_MAIN_DATA);
  DataSet := Conn.GetDataSet(Sql1);
  Conn.SetParam(DataSet, SF_ID, LotId);
  DataSet.Open;
  if not DataSet.IsEmpty then
  begin
    Result := TmstLot.Create;
    Result.LoadMainData(DataSet);
  end;
  DataSet.Close;
  if not Assigned(Result) then
    Exit;

  DataSet := Conn.GetDataSet(SQ_GET_CONTOURS_FOR_ALLOTMENT);
  Conn.SetParam(DataSet, SF_ID, LotId);
  DataSet.Open;
  while not DataSet.Eof do
  begin
    Result.LoadContour(DataSet);
    DataSet.Next;
  end;
  DataSet := Conn.GetDataSet(SQ_GET_CONTOUR_POINTS);
  for I := 0 to Pred(Result.Contours.Count) do
  begin
    Conn.SetParam(DataSet, SF_ID, LotId);
    Conn.SetParam(DataSet, SF_CONTOURS_ID,Result.Contours[I].DatabaseId);
    DataSet.Open;
    Result.Contours[I].LoadPoints(DataSet);
    DataSet.Close;
  end;
  if not Result.PointsLoaded then
    FreeAndNil(Result);
end;

function TMStIBXMapMngr.GetLotCategories(Index: Integer): TmstLotCategory;
begin
  Result := FLotCategories[Index] as TmstLotCategory;
end;

function TMStIBXMapMngr.GetLotCategoriesCount: Integer;
begin
  Result := FLotCategories.Count;
end;

function TMStIBXMapMngr.GetLots(aLot: TmstLot): ILots;
var
  M: TmstLotDataModule;
begin
  M := TmstLotDataModule.Create(Self);
  M.ibqOwners.ParamByName(SF_ID).AsInteger := aLot.DatabaseId;
  M.ibqDocs.ParamByName(SF_ID).AsInteger := aLot.DatabaseId;
  M.ibqLot.ParamByName(SF_ID).AsInteger := aLot.DatabaseId;
  M.Transaction.DefaultDatabase := dbKis;
  M.Activate;
  Result := M as ILots
end;

function TMStIBXMapMngr.SetMapImage(aMapList: TmstMapList; aMap: TmstMap; const FileName: String): Boolean;
var
  Stream: TStream;
  Conn: IIBXConnection;
  MapNameUp: string;
begin
  Result := False;
  if Assigned(aMapList) and Assigned(aMap) then
  begin
    with TMStFTPConnection.Create(Self) do
    try
      Init(FUser.IsAdministrator,
           mstClientAppModule.GetOption('FTP', 'Host', ''),
           StrToInt(mstClientAppModule.GetOption('FTP', 'Port', '21')));
      Stream := TFileStream.Create(FileName, fmOpenRead);
      Stream.Forget;
      SetFile(ftImage, aMap.MapName, Stream);
      Conn := GetConnection(cmWriteOnly, dmGeo);
      MapNameUp := QuotedStr(AnsiUpperCase(aMap.MapName));
      with Conn.GetDataSet('SELECT * FROM MAP_IMAGES WHERE UPPER(NOMENCLATURE)=' + MapNameUp) do
      begin
        Open;
        if IsEmpty then
          Conn.GetDataSet('INSERT INTO MAP_IMAGES (NOMENCLATURE) VALUES(' + MapNameUp + ')').Open
        else
          Conn.GetDataSet('UPDATE MAP_IMAGES SET NOMENCLATURE=' + MapNameUp + ' WHERE UPPER(NOMENCLATURE)=' + MapNameUp).Open;
      end;
    finally
      Free;
    end;
    Result := True;
  end;
end;

procedure TMStIBXMapMngr.DeleteMaps;
var
  Conn: IIBXConnection;
begin
  Conn := GetConnection(cmWriteOnly, dmGeo);
  Conn.GetDataSet('EXECUTE PROCEDURE CLEAR_DATA').Open;
end;

destructor TMStIBXMapMngr.Destroy;
begin
  FMPLayers.Free;
  FLotCategories.Free;
  inherited;
end;

procedure TMStIBXMapMngr.AddMPLayer(aMPLayer: TmstMPLayer; aParentLayer: TmstLayer;
  const aStatusId: Integer; AddedLayers: TList;
  var Position: Integer);
var
  Layer: TmstLayer;
  I: Integer;
  MpL: TmstMPLayer;
begin
  if AddedLayers.IndexOf(aMPLayer)>= 0 then
    Exit;
  Layer := aParentLayer.AddChild();
  Layer.Id := TProjectUtils.GetMPLayerCode(aStatusId, aMPLayer.Id);
  Layer.Name := TProjectUtils.GetMPLayerName(aStatusId, aMPLayer.Id);
  Layer.Caption := aMPLayer.Name;
  Layer.Position := Position;
  Layer.LayerType := 2;
  Layer.Visible := True;
  Layer.IsMP := True;
  Layer.MpStatusId := aStatusId;
  Layer.MpCategoryId := aMPLayer.Id;
  Inc(Position);
  AddedLayers.Add(aMPLayer);
  //
  if aMPLayer.IsGroup <> 0 then
  begin
    for I := 0 to FMPLayers.Count - 1 do
    begin
      MpL := TmstMPLayer(FMPLayers[I]);
      if MpL.GroupId = aMPLayer.Id then
        AddMPLayer(MpL, Layer, aStatusId, AddedLayers, Position);
    end;
  end;
end;

procedure TMStIBXMapMngr.AfterMapsPrint(MapNames: TStrings; Order: IOrder);
var
  Conn: IIBXConnection;
  DataSet: TDataSet;
  I: Integer;
  S: string;
begin
  if Assigned(MapNames) then
  begin
    Conn := GetConnection(cmReadWrite, dmGeo);
    DataSet := Conn.GetDataSet(SQ_SAVE_PRINTED_MAP);
    begin
      for I := 0 to MapNames.Count - 1 do
      begin
//    + 'VALUES (:ACCOUNT_NAME, :NOMENCLATURE, :OFFICES_ID, :PEOPLE_ID, :USER_NAME)';
        Conn.SetParam(DataSet, SF_ACCOUNT_NAME, FUser.InitialName);
        Conn.SetParam(DataSet, SF_NOMENCLATURE, MapNames[I]);
        Conn.SetParam(DataSet, SF_OFFICES_ID, FUser.OfficeId);
        Conn.SetParam(DataSet, SF_PEOPLE_ID, FUser.Id);
        Conn.SetParam(DataSet, SF_USER_NAME, FUser.UserName);
        DataSet.Open;
      end;
      S := '';
      if Assigned(Order) then
        S := 'Заказ: ' + Order.Info;
      if S <> '' then
        S := S + sLineBreak + sLineBreak;
      S := S + MapNames.Text;
      LogUserAcion('Печать', S);
    end;
  end;
end;

function TMStIBXMapMngr.CategoryById(CategoryId: Integer): TmstLotCategory;
var
  I: Integer;
begin
  for I := 0 to FLotCategories.Count - 1 do
  begin
    if LotCategories[I].Id = CategoryId then
    begin
      Result := LotCategories[I];
      Exit;
    end;
  end;
  Result := nil;
end;

function TMStIBXMapMngr.ClearMapImages(var MapFiles: TStringList): Boolean;
var
  Conn1: IIBXConnection;
  dsMapTmp: TDataSet;
begin
  if not Assigned(MapFiles) then
    MapFiles := TStringList.Create;
  //clear table
  DeleteMaps;
  Conn1 := GetConnection(cmReadOnly, dmGeo);
  dsMapTmp := Conn1.GetDataSet('SELECT NOMENCLATURE FROM MAP_IMAGES_TMP');
  dsMapTmp.Open;
  if not dsMapTmp.IsEmpty then
  begin
    while not dsMapTmp.Eof do
    begin
      MapFiles.Add(dsMapTmp.FieldByName('NOMENCLATURE').AsString);
      dsMapTmp.Next;
    end;
    if Application.MessageBox(PChar('Удалить файлы планшетов с FTP сервера?'), PChar('Подтверждение'),
        MB_YESNO + MB_ICONQUESTION) = mrYes
    then
    begin
      with TMStFTPConnection.Create(Self) do
      try
        Init(Fuser.IsAdministrator,
             mstClientAppModule.GetOption('FTP', 'Host', ''),
             StrToInt(mstClientAppModule.GetOption('FTP', 'Port', '21')));
        DeleteFiles(MapFiles);
      finally
        Free;
      end;
    end;
  end;
  Result := True;
end;

procedure TMStIBXMapMngr.ConnectToDB(Obj: TObject);
begin
  inherited;
  if Obj is TIBTransaction then
    TIBTransaction(Obj).DefaultDatabase := dbGeo;
end;

constructor TMStIBXMapMngr.Create(AOwner: TComponent);
begin
  inherited;
  FLotCategories := TObjectList.Create;
  FMPLayers := TObjectList.Create;
end;

procedure TMStIBXMapMngr.DataModuleCreate(Sender: TObject);
begin
  inherited;
  try
    FIP := GetIP();
  except
    FIP := 'не определён';
  end;
end;

procedure TMStIBXMapMngr.DeleteLayer(aLayer: TmstLayer);
var
  Conn: IIBXConnection;
  Ds: TDataSet;
begin
  if Assigned(aLayer) then
  begin
    Conn := GetConnection(cmWriteOnly, dmGeo);
    Ds := Conn.GetDataSet('DELETE FROM LAYERS WHERE ID=' + IntToStr(aLayer.Id));
    Conn.ExecDataSet(Ds);
  end;
end;

function TMStIBXMapMngr.DeleteMapImage(aMapList: TmstMapList; aMap: TmstMap): Boolean;
var
  Conn: IIBXConnection;
begin
  Result := False;
  if Assigned(aMapList) and Assigned(aMap) then
  begin
    // Создаем соединение с FTP
    with TMStFTPConnection.Create(Self) do
    try
      Init(Fuser.IsAdministrator,
           mstClientAppModule.GetOption('FTP', 'Host', ''),
           StrToInt(mstClientAppModule.GetOption('FTP', 'Port', '21')));
      DeleteFile(ftImage, aMap.MapName);
      Conn := GetConnection(cmWriteOnly, dmGeo);
      Conn.GetDataSet('DELETE FROM MAP_IMAGES WHERE NONENCLATURE=' + QuotedStr(aMap.MapName)).Open;
    finally
      Free;
    end;
    Result := True;
  end;
end;

procedure TMStIBXMapMngr.LogException(E: Exception; Info: TStrings);
var
  AppInfo: String;
  TheTransaction: TIBTransaction;
  TheQuery: TIBQuery;
begin
  if dbKis.Connected then
  begin
    AppInfo := GetAppInfo;
    TheTransaction := TIBTransaction.Create(Self);
    TheTransaction.Forget;
    TheTransaction.DefaultDatabase := dbKis;
    TheTransaction.Init(ilReadCommited, amWriteOnly);
    TheTransaction.StartTransaction;
    //
    TheQuery := TIBQuery.Create(Self);
    TheQuery.Forget;
    TheQuery.Transaction := TheTransaction;
    TheQuery.SQL.Text := SQL_LOG_ERROR;
    TheQuery.Params[0].AsString := E.Message;
    TheQuery.Params[1].AsString := E.ClassName;
    if Assigned(Info) then
      TheQuery.Params[2].AsBlob := Info.Text;
    TheQuery.Params[3].AsBlob := AppInfo;
    TheQuery.ExecSQL;
  end;
end;

function TMStIBXMapMngr.Logon(aUser: TmstUser): Boolean;
var
  TheTransaction: TIBTransaction;
begin
  FUser := aUser;
  with TRegForm.Create(nil) do
  try
    Caption := 'Планшетохранилище';
    if not dbKis.Connected then
      dbKis.Open;
    TheTransaction := TIBTransaction.Create(Self);
    TheTransaction.Forget;
    TheTransaction.DefaultDatabase := dbKis;
    TheTransaction.Init(ilReadCommited, amReadOnly);
    TheTransaction.StartTransaction;
    OnLogon := Self.OnLogonUser;
    OnReadLastUser := GetLastUser;
    ibqOffices.Transaction := TheTransaction;
    ibqPeople.Transaction := TheTransaction;
    Result := ShowModal = mrOK;
    if Result then
    begin
      FUser.OfficeId := GetCurrentOfficeId;
      FUser.InitialName := GetCurrentInitialName;
      FUser.CanPrint := GetCanPrint;
      FUser.CanManageProjects := GetCanManageProjects;
      FUser.MapReportErrorMode := GetMapReportErrorMode;
      dbKis.Close;
      dbKis.Open;
      LogUserAcion('Вход', '');
    end;
  finally
    Free;
  end;
end;

procedure TMStIBXMapMngr.LogUserAcion(const UserAction, Info: string);
var
  Conn: IIBXConnection;
  Q: TDataSet;
begin
   if not FUserLogActive then
     Exit;
  Conn := GetConnection(cmWriteOnly, dmGeo);
  Q := Conn.GetDataSet(SQ_LOG_USER_ACTION);
//    + 'VALUES (:OFFICES_ID, :PEOPLE_ID, :IP_ADDRESS, :USER_NAME, :ACCOUNT_NAME, :USER_ACTION, :DETAILS)';
  Conn.SetParam(Q, SF_OFFICES_ID, FUser.OfficeId);
  Conn.SetParam(Q, SF_PEOPLE_ID, FUser.Id);
  Conn.SetParam(Q, SF_IP_ADDRESS, FIP);
  Conn.SetParam(Q, SF_USER_NAME, FUser.UserName);
  Conn.SetParam(Q, SF_ACCOUNT_NAME, FUser.InitialName);
  Conn.SetParam(Q, SF_USER_ACTION, UserAction);
  Conn.SetParam(Q, SF_DETAILS, Info);
  Conn.ExecDataSet(Q);
end;

function TMStIBXMapMngr.OnLogonUser(const PeopleId: Integer;
  const UserName, RoleName, Password: String): Boolean;
var
  Db: TIBDatabase;
begin
  FUser.UserName := UserName;
  FUser.IsAdministrator := RoleName = 'ADMINISTRATOR';
  FUser.Id := PeopleId;
  FUser.Password := Password;
  Db := TIBDatabase.Create(nil);
  Db.Forget();
  try
    Db.LoginPrompt := False;
    Db.DatabaseName := dbKis.DatabaseName;
    Db.CurrentUserName := UserName;
    Db.Password := Password;
    Db.CurrentRole := RoleName;
//    Params.Add('lc_ctype=WIN1251');
//    Params.Add('user_name=' + UserName);
//    Params.Add('password=' + Password);
    Db.Open;
    Result := True;
  except
    Result := False;
    MessageDlg('Неверное имя пользователя или пароль!', mtError, [mbOK], 0);
  end;
end;

procedure TMStIBXMapMngr.GetLastUser(var OfficeId, UserID: Integer);
begin
  OfficeId := FUser.OfficeId;
  UserId := FUser.Id;
end;

procedure TMStIBXMapMngr.LoadRedLines(Layer: TEzBaseLayer);
var
  Conn: IIBXConnection;
  DataSet: TDataSet;
  Line: TEzPolyline;
  I: Integer;
begin
  if Assigned(Layer) then
  begin
    //
{    Layer.First;
    while not Layer.Eof do
    begin
      Layer.DeleteEntity(Layer.Recno);
      Layer.Next;
    end;
    Layer.Pack(False);}
    //
    Conn := GetConnection(cmReadOnly, dmGeo);
    DataSet := Conn.GetDataSet(SQ_GET_RED_LINES);
    begin
      DataSet.Active := True;
      I := -1;
      Line := nil;
      while not DataSet.Eof do
      begin
        if I <> DataSet.FieldByName(SF_RED_LINES_ID).AsInteger then
        begin
          I := DataSet.FieldByName(SF_RED_LINES_ID).AsInteger;
          // добавляем линию в слой
          if Assigned(Line) then
          begin
            if Line.Points.Count> 1 then
              Layer.AddEntity(Line);
            // очищаем линию
            Line.Points.Clear;
          end
          else
          begin
            Line := TEzPolyline.CreateEntity([], True);
            Line.PenTool.Color := $CC;
          end;
        end;
        Line.Points.AddPoint(
          DataSet.FieldByName(SF_Y).AsFloat,
          DataSet.FieldByName(SF_X).AsFloat
        );
        DataSet.Next;
      end;
      if Assigned(Line) then
        if Line.Points.Count> 1 then
          Layer.AddEntity(Line);
      FreeAndNil(Line);
      DataSet.Active := False;
    end;
  end;
end;


{ TIBXConnection }

procedure TIBXConnection.ClearDataSets;
begin
  FreeAndNil(FDataSets);
  FDataSets := TComponent.Create(nil);
end;

procedure TIBXConnection.Commit;
begin
  if Assigned(FTransaction) then
  begin
    if FTransaction.Active then
      FTransaction.CommitRetaining;
  end;
  ClearDataSets;
end;

constructor TIBXConnection.Create;
begin
  FDataSets := TComponent.Create(nil);
end;

destructor TIBXConnection.Destroy;
begin
  FreeAndNil(FDataSets);
  if Assigned(FTransaction) then
  begin
    if FTransaction.Active then
      FTransaction.Commit;
    FTransaction.Free;
  end;
  inherited;
end;

procedure TIBXConnection.ExecDataSet(DataSet: TDataSet);
begin
  if Assigned(DataSet) then
  begin
    if DataSet is TIBQuery then
      TIBQuery(DataSet).ExecSQL;
  end;
end;

procedure TIBXConnection.ExecSQL(const Sql: string);
var
  Query: TIBQuery;
begin
  Query := TIBQuery.Create(nil);
  try
    Query.Transaction := FTransaction;
    Query.SQL.Text := SQL;
    Query.ExecSQL();
  finally
    Query.Free;
  end;
end;

function TIBXConnection.GenNextValue(const GenName: string): Integer;
var
  dsGetNewId: TDataSet;
  Sql: string;
begin
  Sql := Format(SQL_GET_NEXT_ID, [GenName]);
//  Sql := 'SELECT GEN_ID(' + GenName + '_GEN, 1) FROM RDB$DATABASE';
  dsGetNewId := GetDataSet(Sql);
  dsGetNewId.Open;
  Result := dsGetNewId.Fields[0].AsInteger;
  dsGetNewId.Close;
end;

function TIBXConnection.GetDataSet(const aSQL: String): TDataSet;
begin
  Result := TIBQuery.Create(nil);
  Inc(FCounter);
  Result.Name := 'ds' + IntToStr(FCounter);
  with TIBQuery(Result) do
  begin
    Transaction := FTransaction;
    BufferChunks := 10;
    SQL.Text := aSQL;
    Prepare;
  end;
  FDataSets.InsertComponent(Result);
end;

function TIBXConnection.GetGenValue(const GenName: string): Integer;
var
  Sql: string;
  Ds: TDataSet;
begin
  Sql := Format(SQL_GET_CURRENT_ID, [GenName]);
  Ds := GetDataSet(Sql);
  Ds.Open;
  Result := Ds.Fields[0].AsInteger;
  Ds.Close;
end;

function TIBXConnection.GetRecordCount(const aSQL: String; const Fetch: Boolean): Integer;
var
  Query: TIBQuery;
begin
//  Result := -1;
  Query := TIBQuery.Create(nil);
  try
    Query.Transaction := FTransaction;
    Query.SQL.Text := aSQL;
    Query.Open;
    if Fetch then
      Query.FetchAll();
    Result := Query.RecordCount;
  finally
    Query.Free;
  end;
end;

procedure TIBXConnection.Rollback;
begin
  if Assigned(FTransaction) then
  begin
    if FTransaction.Active then
    begin
      FTransaction.RollbackRetaining();
    end;
  end;
  ClearDataSets;
end;

procedure TIBXConnection.SetBlobParam(DataSet: TDataSet; const ParamName: String; Stream: TStream);
begin
  if not Assigned(FDataSets) then
    Exit;
  if Assigned(Stream) then
  begin
    Stream.Position := 0;
    TIBQuery(DataSet).ParamByName(ParamName).LoadFromStream(Stream, ftBlob);
  end;
end;

procedure TIBXConnection.SetNullableParam(DataSet: TDataSet; const ParamName: String;
  const ParamValue, NullValue: Variant);
var
  R: TVariantRelationship;
  V: Variant;
begin
  R := VarCompareValue(ParamValue, NullValue);
  if R = vrEqual then
    V := Null
  else
    V := ParamValue;
  SetParam(DataSet, ParamName, V);
end;

procedure TIBXConnection.SetParam(DataSet: TDataSet;
  const ParamName: String; const ParamValue: Variant);
var
  Query: TIBQuery;
  Param: TParam;
begin
  if Assigned(DataSet) then
  begin
    Query := TIBQuery(FDataSets.FindComponent(DataSet.Name));
    if Assigned(Query) then
    begin
      Param := Query.Params.FindParam(ParamName);
      if Assigned(Param) then
        Param.Value := ParamValue;
    end;
  end;
end;

procedure TMStIBXMapMngr.dbKisBeforeConnect(Sender: TObject);
begin
  inherited;
  dbKis.DatabaseName := mstClientAppModule.GetOption('Database', 'Kis', '');
end;

procedure TMStIBXMapMngr.dbGeoBeforeConnect(Sender: TObject);
begin
  inherited;
  dbGeo.DatabaseName := mstClientAppModule.GetOption('Database', 'Geo', '');
end;

end.
