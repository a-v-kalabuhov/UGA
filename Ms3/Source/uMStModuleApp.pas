unit uMStModuleApp;

{$WARN UNSAFE_CODE OFF}
{$WARN UNSAFE_TYPE OFF}
{$WARN UNSAFE_CAST OFF}

{$I uMStFlags.pas}

interface

uses
  // System
  Windows, Messages, SysUtils, Classes, Contnrs, Graphics, Forms, Controls, AppEvnts, DB,
  IniFiles, Variants, StdCtrls, DBGrids, Registry, DBClient, Math, jpeg,
  //
  JclDebug, uEcwFuncs,
  // EzGIS
  EzEntities, EzERMapper, EzGraphics, EzBaseGIS, EzBasicCtrls, EzCtrls, EzLib, EzBase, EzSystem,
  // Shared
  uGC, uCommonUtils, uVCLUtils, uFileUtils, uGeoUtils, uGeoTypes,
  // Project
  uMStKernelTypes, uMStKernelClasses, uMStKernelClassesSearch, uMStKernelInterfaces, uMStKernelAppModule,
  uMStKernelStack, uMStKernelIBX, uMStKernelAppSettings, uMStKernelStackConsts,
  uMStModuleMapMngrIBX,
  uMStImportEzClasses,
  uMStClassesLots, uMStClassesProjects, uMStClassesMPIntf, uMStClassesProjectsIntf,
  uMStClassesProjectsMP, uMStKernelClassesPropertiesViewers;

type
  ELayerNotFound = class(Exception);

  TmstAppMode = (amNone, amPrint); 

  TmstHandler = procedure of object;
  TmstProgressEvent = procedure (const Message: String; Percent: Byte;
    Delay: Integer; Ticks: Integer = -1) of object;

  TMStClientAppModule = class(TDataModule, ImstAppModule, ImstLotController, ImstAppSettings, ImstCoordViewList, ImstProjects)
    GIS: TEzGIS;
    ApplicationEvents: TApplicationEvents;
    procedure DataModuleDestroy(Sender: TObject);
    procedure GISBeforePaintEntity(Sender: TObject; Layer: TEzBaseLayer;
      Recno: Integer; Entity: TEzEntity; Grapher: TEzGrapher;
      Canvas: TCanvas; const Clip: TEzRect; DrawMode: TEzDrawMode;
      var CanShow: Boolean; var EntList: TEzEntityList; var AutoFree: Boolean);
    procedure DataModuleCreate(Sender: TObject);
    procedure GISCurrentLayerChange(Sender: TObject; const LayerName: String);
    procedure ApplicationEventsException(Sender: TObject; E: Exception);
    procedure GISAfterPaintEntity(Sender: TObject; Layer: TEzBaseLayer; Recno: Integer; Entity: TEzEntity;
      Grapher: TEzGrapher; Canvas: TCanvas; const Clip: TEzRect; DrawMode: TEzDrawMode);
    procedure GISBeforePaintLayer(Sender: TObject; Layer: TEzBaseLayer; Grapher: TEzGrapher; var CanShow,
      WasFiltered: Boolean; var EntList: TEzEntityList; var AutoFree: Boolean);
  private
    FMainWorkDir: String;
    FSessionDir: String;
    FAlertWindow, FSplash: TForm;
    FMapMngr: TMStIBXMapMngr;
    // Списки объектов
    FLayers: TmstLayerList;
    FMaps: TmstMapList;
    FStreets: TmstStreetList;
    FLotRegistry: TmstLotRegistry;
    FPrjRegistry: TmstProjectList;
//    FMPRegistry: TmstProjectList;
    FAddresses: TmstAddressList;
    FStack: TmstObjectStack;
    FFinder: TmstFinder;
    FShowInvisibleLots: Boolean;
    FPointMarker: Integer;
    FMode: TmstAppMode;
    FUser: TmstUser;
    FLoadedProjects: TIntegerList;
    FNetTypes: TmstProjectNetTypes;
    // GUI инициализации
    procedure StartInit;
    procedure ProgressInit(const Message: String; Percent: Byte; Delay: Integer;
      Ticks: Integer = -1); overload;
    procedure ProgressInit(Step: Byte); overload;
    procedure CloseInit;
    // Этапы инициализации
    function InitApp(ErrorHandler: TmstHandler; ProgressHandler: TmstProgressEvent): Boolean;
    function InitData(ErrorHandler: TmstHandler; ProgressHandler: TmstProgressEvent): Boolean;
    function InitMainForm(ErrorHandler: TmstHandler; ProgressHandler: TmstProgressEvent): Boolean;
    // Работа с временной папкой
    procedure InitWorkDir;
    procedure ClearTempFolder;
    // Работа с соединением с серверами
    procedure ConnectToServers;
    // Работа с внутренними структурами
    procedure InitDataStorages;
    procedure InitGIS;
    // Работа со слоями
    procedure InitLayers(const ProgressStep: Integer);
    procedure DownloadLayers;
    procedure ConnectLayersToGIS;

    // Загрузка данных с сервера по различным объектам
    // улицы
    procedure InitStreets(const ProgressStep: Integer);
    procedure DownloadStreets;
    procedure LinkStreetsToLayer;
    // адреса
    procedure InitAddresses(const ProgressStep: Integer);
    procedure DownloadAddresses;
    procedure LinkAddressesToLayer;
    // отводы
    procedure InitLots(const ProgressStep: Integer);
    procedure DownloadLots;
    procedure LinkLotsToLayer;
    procedure AddLotToLayer(aLot: TmstLot; Layer: TEzBaseLayer);
    procedure ExportLotsToLayer(aList: TmstLotList; Layer: TEzBaseLayer);
    //
    procedure AddProjectToLayer(Prj: TmstProject);
    // планшеты
    procedure InitMaps(const ProgressStep: Integer);
    procedure DownloadMaps;
    procedure LinkMapsToLayer;
    // красные линии
    procedure InitRedLines;
    // сводный план
    procedure InitMP(const ProgressStep: Integer);
    procedure DownloadMP;
    procedure LinkMPToLayer;
    // Загрузка данных о планшетах в список FMaps
    procedure ReLoadMaps;
    // Загрузка данных в слои из списков
    procedure LoadLayerMaps;
    procedure LoadLayerMapImages;
    function GetImageNomenclature(ImageID: Integer): String;
    function GetMapNomenclature(MapEntityID: Integer): String;
    procedure LayerVisibleChanged(Sender: TObject; ALayer: TmstLayer);
    procedure MPLayerVisibleChanged(ALayer: TmstLayer);
    procedure OnDeleteLayer(Sender: TObject; aLayer: TmstLayer);
    procedure OnSelectLayer(Sender: TObject; aLayer: TmstLayer);
    procedure CreateAlertWindow;
    procedure CloseAlertWindow(Sender: TObject; var Action: TCloseAction);
    function GetMapLayer: TEzBaseLayer;
    function GetMapImageLayer: TEzBaseLayer;
    procedure InternalFindLots(DrawBox: TEzDrawBox; const X, Y: Double;
      const LayerName: String; AList: TmstLotList);
    procedure SelectionChange(const OldSelection, NewSelection: TmstSelectedLotInfo);
    procedure RedrawLot(const LotCategoryId, LotId: Integer);
    procedure AddPointMarkers(aEntity: TEzEntity);
    procedure ClearPointMarkers(aEntity: TEzEntity);
    procedure SetShowInvisibleLots(const Value: Boolean);
    procedure BeforeAddLotToList(aList: TmstLotList; var aLot: TmstLot);
    procedure SetMode(const Value: TmstAppMode);
    procedure PrepareLotEntityToNormalMode(Layer: TEzBaseLayer;
      Entity: TEzEntity; var EntList: TEzEntityList; var CanShow: Boolean);
    procedure PrepareEntityToPrintMode(Layer: TEzBaseLayer;
      Entity: TEzEntity; var EntList: TEzEntityList; var CanShow: Boolean);
    procedure PrepareM500Bitmap(aRef: TEzPictureRef);
    procedure DeleteMapEntity(aMap: TmstMap);
    function GetLastUserId: Integer;
    function GetLastUserOfficeId: Integer;
    procedure SaveLastUserId;
    procedure SaveLastUserOfficeId;
    procedure PrepareCadastralBlock(Layer: TEzBaseLayer; Entity: TEzEntity;
      const Clip: TEzRect; var EntList: TEzEntityList);
    function IntLoadMapImage(aMap: TmstMap): Boolean;  // MapId = Entity.ID
    procedure LoadLayersVisibility();
    procedure TurnOffLayer(Sender: TObject; aLayer: TmstLayer);
    //
    procedure SetStackLotsVisibility(IsVisible: Boolean);
    procedure HideAllLotsInStack(Sender: TObject; AObject: TmstObject);
    procedure ShowAllLotsInStack(Sender: TObject; AObject: TmstObject);
    procedure RemoveSelectedObjectFromStack(Sender: TObject; AObject: TmstObject);
    procedure ViewPropertiesSelectedObjectInStack(Sender: TObject; AObject: TmstObject);
    procedure ChangeVisibilitySelectedLotInStack(Sender: TObject; AObject: TmstObject);
    procedure HideAllLotsExceptSelectedInStack(Sender: TObject; AObject: TmstObject);
    procedure ViewSelectedObjInSteckInBrowser(Sender: TObject; AObject: TmstObject);
    procedure LocateSelectedObjectInStack(Sender: TObject; AObject: TmstObject);
    procedure ShowHideSelectedLotContourInStack(Sender: TObject; AObject: TmstObject);
    procedure ShowHideAllLotContoursExceptSelectedInStack(Sender: TObject; AObject: TmstObject);
    procedure LocateSelectedLotContourInStack(Sender: TObject; AObject: TmstObject);
  private
    function IsMPLayer(aLayer: TEzBaseLayer): Boolean;
    function GetMPObjectisVisible(aLayer: TEzBaseLayer; aRecNo: Integer; var LineColor: TColor): Boolean;
  private
    FMasterPlan: ImstMPModule;
    FViewCoordSystem: TCoordSystem;
    function GetMP: ImstMPModule;
    procedure GetAppSettingsForMP(Sender: TObject; out aAppSettings: ImstAppSettings);
    procedure GetDbForMP(Sender: TObject; out aDb: IDb);
    procedure SetViewCoordSystem(const Value: TCoordSystem);
    function GetObjList: ImstMPModuleObjList;
    function GetCoordViews: ImstCoordViewList;
    procedure NotifyCoordViews();
  private
    // ImstProjects
    function GetProject(PrjId: Integer; LoadIsNotExtsts: Boolean): TmstProject;
    procedure LoadProjects(const aLeft, aTop, aRight, aBottom: Double; CallBack: TProgressEvent2);
    procedure LoadProjectsByField(const FieldName, Text: String; OnPrjLoaded: TNotifyEvent);
  private
    FCoordViews: TInterfaceList;
    // ImstCoordViewList
    procedure Subscribe(aView: ImstCoordView);
    procedure UnSubscribe(aView: ImstCoordView);
  protected
    function GetLotLayer(const LotCategoryId: Integer): TEzBaseLayer;
    procedure LoadLotFromDataSets(ALot: TmstLot; MainDataSet, ContoursDataSet, PointsDataSet: TDataSet);
    function GetLotForEntity(Layer: TEzBaseLayer): TmstLot;
  public
    procedure Alert(const Message: String);
    procedure CreateMapMngr;
    // Работа с отводами
    procedure FindLots(DrawBox: TEzDrawBox; const X, Y: Double);
    procedure FindMap(const Nomenclature: String; OnMapFound: TNotifyEvent);
    procedure FindProjects(DrawBox: TEzDrawBox; const X, Y: Double);
    procedure FindMPProjects(DrawBox: TEzDrawBox; const X, Y: Double);
    procedure HideLot(const aCategoryId, DatabaseId: Integer);
    function GetLotList(const aCategoryId: Integer): TmstLotList;
    //
    function  GetOption(const Section, Option, NoValue: String): String;
    procedure SetOption(const Section, Option, Value: String);
    function  Init: Boolean;
    // Загрузка участков на клиента
    procedure LoadLots(const aLeft, aTop, aRight, aBottom: Double; CallBack: TProgressEvent2);
    procedure LoadLotsByField(const FieldName, Text: String; OnLotLoaded: TNotifyEvent);
    // Загрузка изображения планшета
    function LoadMapImage(MapEntityId: Integer): Boolean;  // MapId = Entity.ID
    // Поиск адреса и установке его на экране
    procedure LocateAddress(const DbId: Integer);
    // Поиск участка и установке его на экране
    procedure LocateContour(const aCategoryId, aLotDbId, aContourDbId: Integer);
    procedure LocateLot(const aCategoryId, aDbId: Integer);
    procedure LocateProject(const DbId: Integer);
    procedure LogError(E: Exception; Info: TStrings); overload;
    procedure LogError(E: Exception; const Info: string); overload;
    // Обновление информации по планшетам
    procedure RefreshMaps;
    procedure UnHideLot(const aCategoryId, DatabaseId: Integer);
    // Выгрузка изображения планшета
    function UnLoadMap(MapId: Integer): string;
    // Перерисовка участка
    procedure UpdateLotEntity(Sender: TObject; AObject: TmstObject);
    function UploadMapImage(const FileName: String; var Message: String): Boolean;
    function DeleteMapImage(const MapName: String; var Message: String): Boolean;
    function ClearMapImagesTo399({var Message: String}mLog: TMemo): Boolean;
    procedure MapsPrinted(MapNames: TStrings; Order: IOrder);
    procedure LogUserAcion(const UserAction, Info: string);
    //
    function GetLot(const aCategoryId, aDbId: Integer): TmstLot;
    function GetSelectedLot: TmstLot;
    function GetLots(aLot: TmstLot): ILots;
    function GetOrders(): IOrders;
    procedure ConnectLayerToGIS(aLayer: TmstLayer; UseLayerVisibility: Boolean);

    function GetStats: IStats;

    procedure ConnectToDB(Obj: TObject);
    function  Logon: Boolean;
  private
    // ImstAppSettings
    procedure ReadFormPosition(AOwner: TComponent; Form: TForm);
    procedure WriteFormPosition(AOwner: TComponent; Form: TForm);
    procedure ReadGridProperties(AOwner: TComponent; Grid: TDBGrid);
    procedure WriteGridProperties(AOwner: TComponent; Grid: TDBGrid);
    function  ReadAppParam(AOwner, Component: TComponent;
      const PropertyName: String; DataType: Integer; UseComponentName: Boolean = False): Variant;
    procedure SaveAppParam(AOwner, Component: TComponent; const PropertyName: String;
      const Value: Variant; UseComponentName: Boolean = False);
    function SessionDir: String;
  private
    function GetAppSettings: ImstAppSettings;
    function GetProjects: ImstProjects;
    function GetDb: IDb;
  private
    procedure LoadCKOptions;
  public
    procedure UnloadAllLots;
  public
    procedure SaveLayersVisibility();
    //
    procedure DisplayLayersDialog();
    procedure RepaintViewports;
    //
    function FindProject(const aId: Integer): TmstProject;
    procedure AddLoadedProject(const aId: Integer);
    procedure ClearLoadedProjects();
    function HasLoadedProjects(): Boolean;
    function IsProjectLoaded(const aId: Integer): Boolean;
    procedure RemoveLoadedProject(const aId: Integer);
    //
    property MainWorkDir: String read FMainWorkDir;
    // Слои
    property Layers: TmstLayerList read FLayers;
    property LayerMaps: TEzBaseLayer read GetMapLayer; // M500
    property LayerMapImages: TEzBaseLayer read GetMapImageLayer; // R500
    property Maps: TmstMapList read FMaps;
    property Streets: TmstStreetList read FStreets;
    property Lots: TmstLotRegistry read FLotRegistry;
    property Addresses: TmstAddressList read FAddresses;
    property NetTypes: TmstProjectNetTypes read FNetTypes;
    //
    property AppSettings: ImstAppSettings read GetAppSettings;
    property Db: IDb read GetDb;
    property CoordViews: ImstCoordViewList read GetCoordViews;
    property MP: ImstMPModule read GetMP;
    property ObjList: ImstMPModuleObjList read GetObjList;
    property Projects: ImstProjects read GetProjects;

    property Finder: TmstFinder read FFinder;
    property Stack: TmstObjectStack read FStack;

    property ShowInvisibleLots: Boolean read FShowInvisibleLots write SetShowInvisibleLots;
    property PointMarkerIndex: Integer read FPointMarker;
    property Mode: TmstAppMode read FMode write SetMode;
    property MapMngr: TMStIBXMapMngr read FMapMngr;
    property User: TmstUser read FUser;
    property ViewCoordSystem: TCoordSystem read FViewCoordSystem write SetViewCoordSystem;
  end;

var
  mstClientAppModule: TMStClientAppModule;

implementation

{$R *.dfm}

uses
  uEzLayerUtils,
  uMStConsts,
  uMStKernelGISUtils, uMStKernelConsts, uMStKernelClassesOptions, uMStClassesProjectsUtils,
  uMStFormMain, uMStFormLayers, uMStFormSplash,
  uMStModulePrint, uMStModuleMasterPlan;

const
  PROP_COL = 'Columns.';

{ TMStClientAppModule }

procedure TMStClientAppModule.AddPointMarkers(aEntity: TEzEntity);
begin
  if not Assigned(aEntity) then
    Exit;
  mstClientMainForm.DrawBox.TempEntities.Add(aEntity.Clone);
  mstClientMainForm.DrawBox.ShowControlPoints := True;
end;

procedure TMStClientAppModule.AddProjectToLayer(Prj: TmstProject);
begin
  if Assigned(Prj) then
  begin
    TProjectUtils.GIS := GIS;
    TProjectUtils.AddProjectToGIS(Prj);
  end;
end;

procedure TMStClientAppModule.Alert(const Message: String);
begin
  CreateAlertWindow;
  TLabel(FAlertWindow.Controls[0]).Caption := Message;
  TLabel(FAlertWindow.Controls[0]).Font.Color := clRed;
  FAlertWindow.Show;
  Windows.Beep(440, 300);
end;

procedure TMStClientAppModule.ClearPointMarkers(aEntity: TEzEntity);
begin
  mstClientMainForm.DrawBox.TempEntities.Clear;
end;

procedure TMStClientAppModule.ClearTempFolder;
var
  B: Boolean;
begin
  if FSessionDir <> '' then
  begin
    B := TFileUtils.DontRaiseExceptions;
    try
      TFileUtils.DontRaiseExceptions := True;
//      {$IFDEF DEBUG}
//      TFileUtils.DontRaiseExceptions := False;
//      {$ENDIF}
      TFileUtils.DeleteDirectory(FSessionDir);
    finally
      TFileUtils.DontRaiseExceptions := B;
    end;
  end;
  // TODO : добавить удаление слишком старых папок
end;

procedure TMStClientAppModule.CloseAlertWindow(Sender: TObject; var Action: TCloseAction);
begin
  Action := caFree;
  FAlertWindow := nil;
end;

procedure TMStClientAppModule.CloseInit;
begin
  if Assigned(FSplash) then
  begin
    FSplash.Visible := False;
    FSplash.Release;
  end;
end;

procedure TMStClientAppModule.ConnectLayersToGIS;
var
  I: Integer;
  Cat: TmstLotCategory;
  Lst: TmstLotListEz;
  LayerName: string;
  aLayer: TEzBaseLayer;
  LayerLst: TList;
begin
  GIS.Active := True;
  // Подключение слоев
  LoadLayersVisibility();
  LayerLst := FLayers.GetPlainList();
  LayerLst.Forget();
  for I := 0 to Pred(LayerLst.Count) do
    ConnectLayerToGIS(LayerLst[I], True);
  //
  for I := 0 to FMapMngr.LotCategoriesCount - 1 do
  begin
    Cat := FMapMngr.LotCategories[I];
    LayerName := Cat.GetLayerName();
    aLayer := GIS.Layers.LayerByName(LayerName);
    Lst := TmstLotListEz.Create(aLayer, Cat.Id);
    FLotRegistry.Add(Lst);
  end;  
end;

procedure TMStClientAppModule.ConnectToDB(Obj: TObject);
begin
  FMapMngr.ConnectToDB(Obj);
end;

procedure TMStClientAppModule.ConnectToServers;
begin
  if not FMapMngr.Connected then
    FMapMngr.Connected := True;
end;

procedure TMStClientAppModule.CreateAlertWindow;
begin
  if not Assigned(FAlertWindow) then
    FAlertWindow := TForm.Create(Self);
  FAlertWindow.OnClose := CloseAlertWindow;
  with FAlertWindow do
  begin
    BorderStyle := bsToolWindow;
    FormStyle := fsStayOnTop;
    AlphaBlendValue := 220;
    AlphaBlend := true;
    Height := 110;
    Width := 150;
    Left := Application.MainForm.Width - Application.MainForm.Left - Width - 10;
    Top := Application.MainForm.Height - Application.MainForm.Top - Height - 10;
    InsertControl(TLabel.Create(FAlertWindow));
    with Controls[0] as TLabel do
    begin
      Align := alClient;
      AutoSize := false;
      Alignment := taCenter;
      LayOut := tlCenter;
      WordWrap := True;
    end;
  end;
end;

procedure TMStClientAppModule.CreateMapMngr;
begin
  if not Assigned(FMapMngr) then
  begin
    FMapMngr := TMStIBXMapMngr.Create(Self);
    FMapMngr.AppModule := Self as ImstAppModule;
  end;
end;

procedure TMStClientAppModule.DataModuleDestroy(Sender: TObject);
begin
  try
    GIS.Active := False;
    NCSecwShutdown;
    FNetTypes.Free;
    FLoadedProjects.Free;
    FUser.Free;
    FreeAndNil(FStack);
    FreeAndNil(FAddresses);
    FreeAndNil(FStreets);
    FreeAndNil(FMaps);
    FreeAndNil(FLayers);
    FreeAndNil(FLotRegistry);
    FreeAndNil(FMapMngr);
    FreeAndNil(FCoordViews);
//    FreeAndNil(FMPRegistry);
  finally
    ClearTempFolder;
  end;
end;

procedure TMStClientAppModule.DownloadAddresses;
begin
  FAddresses.Clear;
  FMapMngr.LoadAddresses(FAddresses);
end;

procedure TMStClientAppModule.DownloadMaps;
begin
  // Создем временный список планшетов
  FMaps.Clear;
  FMapMngr.LoadMaps(FMaps);
end;

procedure TMStClientAppModule.DownloadMP;
begin
  MP.LoadFromDb();
end;

procedure TMStClientAppModule.DownloadLayers;
begin
  FMapMngr.LoadLayers(FLayers);
  //
  MP.UpdateLayersVisibility(FLayers);
end;

procedure TMStClientAppModule.DownloadLots;
begin

end;

procedure TMStClientAppModule.DownloadStreets;
begin
  FStreets.Clear;
  FMapMngr.LoadStreets(FStreets);
end;

function TMStClientAppModule.GetAppSettings: ImstAppSettings;
begin
  Result := Self as ImstAppSettings;
end;

procedure TMStClientAppModule.GetAppSettingsForMP(Sender: TObject; out aAppSettings: ImstAppSettings);
begin
  aAppSettings := Self as ImstAppSettings;
end;

function TMStClientAppModule.GetCoordViews: ImstCoordViewList;
begin
  Result := Self as ImstCoordViewList;
end;

function TMStClientAppModule.GetDb: IDb;
begin
  Result := MapMngr as IDb;
end;

procedure TMStClientAppModule.GetDbForMP(Sender: TObject; out aDb: IDb);
begin
  aDb := MapMngr as IDb;
end;

function TMStClientAppModule.GetImageNomenclature(ImageID: Integer): String;
var
  Tmp: TmstMap;
begin
  Tmp := FMaps.GetByMapImageId(ImageId);
  if Assigned(Tmp) then
    Result := Tmp.MapName
  else
   Result := '';
end;

function TMStClientAppModule.GetLot(const aCategoryId, aDbId: Integer): TmstLot;
var
//  Annulled, Checked: Boolean;
  aList: TmstLotListEz;
begin
  Result := nil;
  aList := FLotRegistry.FindByCategory(aCategoryId);
  if Assigned(aList) then
    Result := aList.GetByDatabaseId(aDbId);
//  Annulled := False;
//  Checked := False;
//  case aLotType of
//  ID_ACTUAL_LOT :
//    begin
//      Annulled := False;
//      Checked := True;
//    end;
//  ID_ANNULED_LOT :
//    begin
//      Annulled := True;
//      Checked := False;
//    end;
//  ID_LOT :
//    begin
//      Annulled := False;
//      Checked := False;
//    end;
//  end;
//  with GetLotList(Annulled, Checked) do
//    Result := GetByDatabaseId(aDbId);
end;

function TMStClientAppModule.GetLotLayer(const LotCategoryId: Integer): TEzBaseLayer;
var
  Lst: TmstLotListEz;
begin
  Lst := FLotRegistry.FindByCategory(LotCategoryId);
  if Assigned(Lst) then
    Result := Lst.Layer
  else
    Result := nil;
end;

function TMStClientAppModule.GetLotList(const aCategoryId: Integer): TmstLotList;
begin
  Result := FLotRegistry.FindByCategory(aCategoryId);
end;

function TMStClientAppModule.GetMapImageLayer: TEzBaseLayer;
begin
  Result := GIS.Layers.LayerByName(SL_MAP_IMAGES_LAYER);
end;

function TMStClientAppModule.GetMapLayer: TEzBaseLayer;
begin
  Result := GIS.Layers.LayerByName(SL_MAP_LAYER);
end;

function TMStClientAppModule.GetMapNomenclature(MapEntityID: Integer): String;
var
  Tmp: TmstMap;
begin
  Tmp := FMaps.GetByMapEntityId(MapEntityID);
  if Assigned(Tmp) then
    Result := Tmp.MapName
  else
   Result := '';
end;

function TMStClientAppModule.GetMP: ImstMPModule;
begin
  if FMasterPlan = nil then
  begin
    FMasterPlan := TmstMasterPlanModule.Create(Self) as ImstMPModule;
    FMasterPlan.SetAppSettingsEvent(GetAppSettingsForMP);
    FMasterPlan.SetDbEvent(GetDbForMP);
  end;
  Result := FMasterPlan;
end;

function TMStClientAppModule.GetMPObjectisVisible(aLayer: TEzBaseLayer; aRecNo: Integer; var LineColor: TColor): Boolean;
var
  DbId: Integer;
begin
  // определяем, какому статусу принадлежит объект
  // определяем, какой катеории принадлежит объект
  // из классификатора вытаскиваем виден он или нет
  Result := MP.Classifier.MPVisible;
  if Result then
  begin
    aLayer.Recno := aRecNo;
    DbId := aLayer.RecEntity().ExtID;
    Result := MP.IsObjectVisible(DbId, LineColor);
  end;
end;

function TMStClientAppModule.GetObjList: ImstMPModuleObjList;
begin
  if FMasterPlan = nil then
  begin
    FMasterPlan := TmstMasterPlanModule.Create(Self) as ImstMPModule;
    FMasterPlan.SetAppSettingsEvent(GetAppSettingsForMP);
    FMasterPlan.SetDbEvent(GetDbForMP);
  end;
  Result := FMasterPlan as ImstMPModuleObjList;
end;

function TMStClientAppModule.GetOption(const Section, Option, NoValue: String): String;
var
  IniFileName: string;
begin
  IniFileName := TPath.Finish(ExtractFilePath(ParamStr(0)), 'ms2.ini');
  if not FileExists(IniFileName) then
    IniFileName := 'ms2.ini';
  with TIniFile.Create(IniFileName) do
  try
    Result := ReadString(Section, Option, NoValue);
  finally
    Free;
  end;
end;

function TMStClientAppModule.GetOrders: IOrders;
begin
  Result := FMapMngr.GetOrders;
end;

function TMStClientAppModule.GetProject(PrjId: Integer; LoadIsNotExtsts: Boolean): TmstProject;
var
  Tmp: TmstObject;
  Reg: TmstProjectList;
begin
  Result := nil;
  Reg := FPrjRegistry;
  Tmp := Reg.GetByDatabaseId(PrjId);
  if Assigned(Tmp) then
    Result := TmstProject(Tmp);
  if (Result = nil) and LoadIsNotExtsts then
  begin
    try
      Result := MapMngr.GetProjectById(PrjId);
      if Assigned(Result) then
        Reg.Add(Result);
    except
      Result := nil;
    end;
  end;
end;

function TMStClientAppModule.GetProjects: ImstProjects;
begin
  Result := Self as ImstProjects;
end;

function TMStClientAppModule.Init: Boolean;
begin
  Result := False;
  try
    StartInit;
    if InitApp(CloseInit, ProgressInit) then
      if InitData(CloseInit, ProgressInit) then
        Result := InitMainForm(CloseInit, ProgressInit);
  finally
    CloseInit;
  end;
end;

procedure TMStClientAppModule.InitAddresses;
begin
  DownloadAddresses;
  ProgressInit(ProgressStep);
  LinkAddressesToLayer;
end;

function TMStClientAppModule.InitApp(ErrorHandler: TmstHandler;
  ProgressHandler: TmstProgressEvent): Boolean;
begin
  try
    // 1.	Инициализация каталога для работы
    ProgressInit('Инициализация рабочего каталога', 0, 100, 0);
    ProgressInit('Инициализация рабочего каталога', 50, 100, 0);
    InitWorkDir;
    ProgressInit('Инициализация рабочего каталога', 100, 100, 0);
    // 2.	Чтение настроек
    ProgressInit('Чтение настроек', 0, 100);
    ProgressInit('Чтение настроек', 50, 100);
    ProgressInit('Чтение настроек', 100, 100);
    // 3.	Подключение к серверам
    ProgressInit('Соединение...', 0, 100);
    ConnectToServers;
    ProgressInit('Соединение...', 100, 100, 0);
    // 4.	Инициализация внутренних структур для хранения данных
    ProgressInit('Инициализация внутренних структур', 0, 100);
    InitDataStorages;
    ProgressInit('Инициализация внутренних структур', 100, 100, 0);
    Result := True;
  except
    Result := False;
    Application.HandleException(Self);
    ErrorHandler;
  end;
end;

function TMStClientAppModule.InitData(ErrorHandler: TmstHandler; ProgressHandler: TmstProgressEvent): Boolean;
begin
  try
    // 1.	Инициализация пользователя
    // 2.	Загрузка основного файла данных.
    ProgressInit('Загрузка данных...  ', 0, 100);
    ProgressInit('Загрузка данных...  общие', 5, 100);
    FMapMngr.DownloadSpatialDataFiles(Self.SessionDir);
    ProgressInit('Загрузка данных...  общие', 10, 100, 0);
    // 3.	Создание файла ГИС.
    InitGIS;
    // 4.	Загрузка информации о слоях и создание/подключение нужных слоев.
    ProgressInit('Загрузка данных...  слои', 13, 100, 0);
    InitLayers(2);
    ProgressInit('Загрузка данных...  слои', 17, 100, 0);
    // 5.	Загрузка данных по активным объектам.
    // -	улицы
    ProgressInit('Загрузка данных...  улицы', 20, 100);
    InitStreets(5);
    ProgressInit('Загрузка данных...  улицы', 30, 100, 0);
    // -	адреса
    ProgressInit('Загрузка данных...	адреса', 40, 100);
    InitAddresses(5);
    ProgressInit('Загрузка данных...	адреса', 50, 100, 0);
    // -	отводы
    ProgressInit('Загрузка данных...	отводы', 60, 100);
    InitLots(5);
    ProgressInit('Загрузка данных...	отводы', 70, 100, 0);
    // -	сводный план
    InitMP(5);
    ProgressInit('Загрузка данных...	сводный план', 80, 100, 0);
    // -	планшеты
    ProgressInit('Загрузка данных...	планшеты', 90, 100);
    InitMaps(5);
//    ProgressInit('Загрузка данных...	киоски', 95, 100, 0);
//    InitMAFs;
    ProgressInit('Загрузка данных...	красные линии', 95, 100, 0);
    InitRedLines;
    ProgressInit('Загрузка данных завершена', 100, 500);
    //
    FMapMngr.LoadSettings();
    Result := True;
  except
    Result := False;
    Application.HandleException(Self);
    ErrorHandler;
  end;
end;

procedure TMStClientAppModule.InitDataStorages;
begin
  if not Assigned(FLayers) then
  begin
    FLayers := TmstLayerList.Create;
    FLayers.OnLayerChanged := LayerVisibleChanged;
  end;

  if not Assigned(FMaps) then
  begin
    FMaps := TmstMapList.Create;
  end;

  if not Assigned(FStreets) then
  begin
    FStreets := TmstStreetList.Create;
  end;

  if not Assigned(FLotRegistry) then
  begin
    FLotRegistry := TmstLotRegistry.Create();
  end;
  FLotRegistry.SetBeforeAddLotHandler(BeforeAddLotToList);
  FLotRegistry.SetUpdateObjectHandler(UpdateLotEntity);
  
//  if not Assigned(FLots) then
//  begin
//    FLots := TmstLotList.Create;
//    FLots.OnUpdateObject := UpdateLotEntity;
//    FLots.BeforeAddLot := BeforeAddLotToList;
//  end;
//
//  if not Assigned(FAnnulledLots) then
//  begin
//    FAnnulledLots := TmstLotList.Create;
//    FAnnulledLots.OnUpdateObject := UpdateLotEntity;
//    FAnnulledLots.BeforeAddLot := BeforeAddLotToList;
//  end;
//
//  if not Assigned(FActualLots) then
//  begin
//    FActualLots := TmstLotList.Create;
//    FActualLots.OnUpdateObject := UpdateLotEntity;
//    FActualLots.BeforeAddLot := BeforeAddLotToList;
//  end;

  if not Assigned(FAddresses) then
  begin
    FAddresses := TmstAddressList.Create;
  end;

  if not Assigned(FPrjRegistry) then
  begin
    FPrjRegistry := TmstProjectList.Create;
  end;

  if not Assigned(FStack) then
  begin
    FStack := TmstObjectStack.Create(Self as ImstAppModule, FMapMngr as IDb, FMapMngr as ImstLotCategories, Self as ImstLotController);
    FStack.OnSelectionChange := SelectionChange;
    // Сделать все отводы невидимыми
    FStack.RegisterCommand(
      '{84A0E223-AB5E-4D3E-8A08-E2436D51109B}',
      [ID_NODETYPE_LOT_ROOT, ID_NODETYPE_LOT_ANNULED_ROOT, ID_NODETYPE_LOT_ACTUAL_ROOT, ID_NODETYPE_LOT_CATEGORIZED_ROOT],
      'Скрыть все участки по списку',
      -1,
      HideAllLotsInStack,
      nil
    );
    // Сделать все отводы видимыми
    FStack.RegisterCommand(
      '{4FA5DD99-CEC7-418E-9223-68F4B52565BC}',
      [ID_NODETYPE_LOT_ROOT, ID_NODETYPE_LOT_ANNULED_ROOT, ID_NODETYPE_LOT_ACTUAL_ROOT, ID_NODETYPE_LOT_CATEGORIZED_ROOT],
      'Показать все участки по списку',
      -1,
      ShowAllLotsInStack,
      nil
    );
    // Убрать объект из выбранных
    FStack.RegisterCommand(
      '{8E4DE39A-5B6A-42A0-8C1E-F4B031BFD56D}',
      [ID_NODETYPE_LOT, ID_NODETYPE_LOT_ACTUAL, ID_NODETYPE_LOT_ANNULED, ID_NODETYPE_LOT_CATEGORIZED,
       ID_NODETYPE_STREET, ID_NODETYPE_ADDRESS, ID_NODETYPE_PRJ, ID_NODETYPE_MP_PRJ, ID_NODETYPE_MP_OBJECT],
      'Убрать объект из списка',
      -1,
      RemoveSelectedObjectFromStack,
      nil);
    // Посмотреть информацию
//    menuItem.Caption := 'Посмотреть свойства объекта';
//    menuItem.OnClick := ViewPropertiesHandler;
    FStack.RegisterCommand(
      '{1FA46E55-40FF-41EC-B244-51194E95BAF4}',
      [ID_NODETYPE_LOT, ID_NODETYPE_LOT_ACTUAL, ID_NODETYPE_LOT_ANNULED, ID_NODETYPE_LOT_CATEGORIZED,
       ID_NODETYPE_PRJ, ID_NODETYPE_MP_PRJ, ID_NODETYPE_MP_OBJECT],
      'Посмотреть свойства объекта',
      -1,
      ViewPropertiesSelectedObjectInStack,
      nil);
    //
    // Спрятать/показать (для отводов)
//    menuItem.Caption := 'Спрятать/показать объект';
//    menuItem.OnClick := ChangeVisibilityHandler;
    FStack.RegisterCommand(
      '{69953EEE-0351-4135-8B9C-00FF7A940811}',
      [ID_NODETYPE_LOT, ID_NODETYPE_LOT_ACTUAL, ID_NODETYPE_LOT_ANNULED, ID_NODETYPE_LOT_CATEGORIZED],
      'Спрятать/показать отвод',
      -1,
      ChangeVisibilitySelectedLotInStack,
      nil);
//
    // Спрятать все кроме этого (для отводов)
//    menuItem.Caption := 'Спрятать все кроме выбранного';
//    menuItem.OnClick := HideExceptCurrentHandler;
    FStack.RegisterCommand(
      '{A26DAFDA-729B-4211-BB32-6D051F18C401}',
      [ID_NODETYPE_LOT, ID_NODETYPE_LOT_ACTUAL, ID_NODETYPE_LOT_ANNULED, ID_NODETYPE_LOT_CATEGORIZED],
      'Спрятать все кроме выбранного',
      -1,
      HideAllLotsExceptSelectedInStack,
      nil);
    // Показать в списке
//    menuItem.Caption := 'Показать в списке';
//    menuItem.OnClick := ViewBrowserHandler;
    FStack.RegisterCommand(
      '{1BC6D927-A18F-4697-BFB9-E8E07EB1F9C7}',
      [ID_NODETYPE_MP_OBJECT],
      'Показать в списке сетей',
      -1,
      ViewSelectedObjInSteckInBrowser,
      nil);
  // Показать
//  menuItem.Caption := 'Найти объект на карте';
//  menuItem.OnClick := LocateHandler;
    FStack.RegisterCommand(
      '{28C19363-9EA9-4BAA-9883-C2D4F1F5BA7E}',
      [ID_NODETYPE_LOT, ID_NODETYPE_LOT_ACTUAL, ID_NODETYPE_LOT_ANNULED, ID_NODETYPE_LOT_CATEGORIZED,
       ID_NODETYPE_STREET, ID_NODETYPE_ADDRESS, ID_NODETYPE_PRJ, ID_NODETYPE_MP_PRJ, ID_NODETYPE_MP_OBJECT],
      'Найти объект на карте',
      -1,
      LocateSelectedObjectInStack,
      nil);
  //
//  menuItem.Caption := 'Включить/выключить контур';
//  menuItem.OnClick := OnOffContourHandler;
    FStack.RegisterCommand(
      '{B972FD22-88D2-4364-867E-856CBFF9A21E}',
      [ID_NODETYPE_LOT_CONTOUR],
      'Включить/выключить контур',
      -1,
      ShowHideSelectedLotContourInStack,
      nil);
//  menuItem.Caption := 'Выключить все контуры кроме выбранного';
//  menuItem.OnClick := OnOffAllContourHandler;
    FStack.RegisterCommand(
      '{4002976A-7618-4C71-A879-AE02F70FEC8A}',
      [ID_NODETYPE_LOT_CONTOUR],
      'Выключить все контуры кроме выбранного',
      -1,
      ShowHideAllLotContoursExceptSelectedInStack,
      nil);
//  menuItem.Caption := 'Найти контур на карте';
//  menuItem.OnClick := LocateHandler;
    FStack.RegisterCommand(
      '{84B13513-86B8-46D2-B756-3E5FF3200DDE}',
      [ID_NODETYPE_LOT_CONTOUR],
      'Найти контур на карте',
      -1,
      LocateSelectedLotContourInStack,
      nil);
  end;

  if not Assigned(FFinder) then
  begin
    FFinder := TmstFinder.Create(Self);
    FFinder.Stack := FStack;
  end;
end;

procedure TMStClientAppModule.InitGIS;
begin
  GIS.Active := False;
  GIS.CreateNew(SessionDir + 'gis.ezm');
  GIS.LayersSubDir := SessionDir;
  GIS.MapInfo.AerialViewLayer := SL_CITYLINE;
  GIS.MapInfo.CoordsUnits := cum;
  GIS.Active := False;
end;

procedure TMStClientAppModule.InitLayers;
begin
  DownLoadLayers;
  ProgressInit(ProgressStep);
  ConnectLayersToGIS();
  FLayers.OnDeleteLayer := OnDeleteLayer;
  FLayers.OnSelectLayer := OnSelectLayer;
end;

procedure TMStClientAppModule.InitLots;
begin
  DownloadLots;
  ProgressInit(ProgressStep);
  LinkLotsToLayer;
end;

procedure TMStClientAppModule.LoadCKOptions();
var
  S: string;
  I: Integer;
begin
  S := mstClientAppModule.GetOption('Session', 'ViewInCK36', '0');
  if not TryStrToInt(S, I) then
    I := 0;
  if I <> 0 then
    Self.ViewCoordSystem := csMCK36
  else
    Self.ViewCoordSystem := csVrn;

end;

function TMStClientAppModule.InitMainForm(ErrorHandler: TmstHandler;
  ProgressHandler: TmstProgressEvent): Boolean;
begin
  try
    Result := True;
    mstClientMainForm.GIS := Self.GIS;
    FStack.View := mstClientMainForm.TreeView;
    FStack.ObjectView := mstClientMainForm.ListView;
//    FLayers.LayerControl := mstClientMainForm.LayersListBox;
    FLayers.LayerControl := mstClientMainForm.vstLayers;
    GIS.Save;
    //
    mstClientMainForm.LoadWatermark(FMapMngr);
    //
    FNetTypes.Load(FMapMngr as IDb);
    mstClientMainForm.LoadNetTypes();
    //
    Subscribe(mstClientMainForm);
  except
    Result := False;
    Application.HandleException(Self);
    ErrorHandler;
  end;
end;

procedure TMStClientAppModule.InitMaps;
begin
  DownloadMaps;
  ProgressInit(ProgressStep);
  LinkMapsToLayer;
end;

procedure TMStClientAppModule.InitMP;
begin
  DownloadMP();
  ProgressInit(ProgressStep);
  LinkMPToLayer();
end;

procedure TMStClientAppModule.InitStreets;
begin
  DownloadStreets;
  ProgressInit(ProgressStep);
  LinkStreetsToLayer;
end;

procedure TMStClientAppModule.InitWorkDir;
begin
  FMainWorkDir := TFileUtils.GetSpecialFolderLocation(CSIDL_LOCAL_APPDATA, FOLDERID_LocalAppData);
  FMainWorkDir := TPath.Combine(FMainWorkDir, 'MapStTemp');
  FSessionDir := TPath.Combine(FMainWorkDir, 'Session_' + FormatDateTime('yyyy-mm-dd-hh-mm-ss-nnn', Now));
  ClearTempFolder;
  if not DirectoryExists(FMainWorkDir) then
    if not CreateDirectory(PChar(FMainWorkDir), nil) then
      raise Exception.Create('Не удалось создать временную папку!');
  if not DirectoryExists(FSessionDir) then
    if not CreateDirectory(PChar(FSessionDir), nil) then
      raise Exception.Create('Не удалось создать временную папку сессии!');
end;

procedure TMStClientAppModule.LayerVisibleChanged(Sender: TObject; ALayer: TmstLayer);
var
  Layer: TEzBaseLayer;
begin
  if ALayer.IsMP then
  begin
    MPLayerVisibleChanged(ALayer);
  end
  else
  begin
    Layer := GIS.Layers.LayerByName(ALayer.Name);
    if Assigned(Layer) then
    begin
      Layer.LayerInfo.Visible := ALayer.Visible;
      GIS.RepaintViewports;
    end;
  end;
end;

procedure TMStClientAppModule.LinkAddressesToLayer;
var
  I: Integer;
  Tmp: TmstAddress;
  Layer: TEzBaseLayer;
  Addr: TEzTrueTypeText;
begin
    Layer := GIS.Layers.LayerByName(SL_ADDRESSES);
    if Assigned(Layer) then
    try
      Layer.StartBatchInsert;
      for I := 0 to Pred(FAddresses.Count) do
      begin
        Tmp := FAddresses[I];
        Addr := IEntity(
          TEzTrueTypeText.CreateEntity(
            Point2D(Tmp.X, Tmp.Y), Tmp.Name, Tmp.Height, Tmp.Angle)
        ).Entity as TEzTRueTypeText;
        Addr.FontTool.Color := Tmp.Color;
        Tmp.EntityId := Layer.AddEntity(Addr);
      end;
    finally
      Layer.FinishBatchInsert;
    end;
end;

procedure TMStClientAppModule.LinkLotsToLayer;
begin
//  ExportLotsToLayer(FLots, GetLotLayer(False, False));
//  ExportLotsToLayer(FAnnulledLots, GetLotLayer(True, False));
//  ExportLotsToLayer(FActualLots, GetLotLayer(False, True));
end;

procedure TMStClientAppModule.LinkMapsToLayer;
var
  I: Integer;
  Ent: TEzEntity;
begin
  for I := 0 to Pred(FMaps.Count) do
  begin
    //if FMaps[I].MapName = 'У-0I-14' then
    //  Y := 0;
    Ent := GetMap500Entity(FMaps[I].MapName, clMaroon);
    Ent.Forget();
    FMaps[I].MapEntityId := LayerMaps.AddEntity(Ent);
  end;
end;

procedure TMStClientAppModule.LinkMPToLayer;
begin
  Sleep(1000);
end;

procedure TMStClientAppModule.LinkStreetsToLayer;
var
  I: Integer;
  Layer: TEzBaseLayer;
  Tmp: TmstStreet;
begin
  // Связываем список с файлом слоя
  Layer := GIS.Layers.LayerByName(SL_STREETS);
  if Assigned(Layer) then
  with Layer do
  begin
    First;
    while not Eof do
    begin
      DBTable.RecNo := RecNo;
      I := DBTable.IntegerGet(SF_STREET_ID);
      if I > 0 then
      begin
        Tmp := FStreets.GetByDatabaseId(I);
        if Assigned(Tmp) then
        begin
          Tmp.EntityId := RecNo;
        end;
      end;
      Next;
    end;
  end;
end;

procedure TMStClientAppModule.LoadLayerMapImages;
var
  I: Integer;
  ImgEnt: TEzEntity;
begin
  if Assigned(FMaps) and Assigned(LayerMapImages) then
  try
    for I := 1 to LayerMapImages.RecordCount do
      LayerMapImages.DeleteEntity(I);
    LayerMapImages.Pack(False);
//    LayerMaps.StartBatchInsert;
    for I := 0 to Pred(FMaps.Count) do
      if FMaps[I].ImageLoaded then
      begin
        ImgEnt := GetMapImageEntity(FMaps[I].MapName, FMaps[I].FileName, FMaps[I].ImageExt);
        try
          FMaps[I].MapImageId := LayerMapImages.AddEntity(ImgEnt);
        finally
          FreeAndNil(ImgEnt);
        end;
      end;
  finally
//    LayerMaps.FinishBatchInsert;
  end;
end;

procedure TMStClientAppModule.LoadLayerMaps;
var
  I: Integer;
begin
  if Assigned(FMaps) and Assigned(LayerMaps) then
  try
    mstClientMainForm.DrawBox.BeginUpdate;
    if not LayerMaps.LayerInfo.Visible then
      LayerMaps.LayerInfo.Visible := True;
    for I := 1 to LayerMaps.RecordCount do
      LayerMaps.DeleteEntity(I);
    LayerMaps.Pack(False);
    for I := 0 to Pred(FMaps.Count) do
    begin
      FMaps[I].MapEntityId := LayerMaps.AddEntity(IEntity(GetMap500Entity(FMaps[I].MapName, clMaroon)).Entity);
    end;
  finally
    LayerMaps.FinishBatchInsert;
    mstClientMainForm.DrawBox.EndUpdate;
  end;
end;

procedure TMStClientAppModule.LoadLayersVisibility;
var
  IniFileName: string;
  Ini: TIniFile;
  LayerNames: TStringList;
  I: Integer;
  L: TmstLayer;
  LayerVisible: Boolean;
begin
  IniFileName := TPath.Finish(ExtractFilePath(ParamStr(0)), 'ms2.ini');
  if not FileExists(IniFileName) then
    IniFileName := 'ms2.ini';
  Ini := TIniFile.Create(IniFileName);
  try
    LayerNames := TStringList.Create;
    LayerNames.Forget;
    Ini.ReadSection('Layers', LayerNames);
    if LayerNames.Count > 0 then
    begin
      FLayers.EnumerateLayers(TurnOffLayer);
      // теперь надо найти слой и его пометить как видимый, а остальные как невидимые
      for I := 0 to LayerNames.Count - 1 do
      begin
        L := FLayers.GetByName(LayerNames[I], False);
        if L <> nil then
        begin
          LayerVisible := Ini.ReadBool('Layers', LayerNames[I], False);
          L.Visible := LayerVisible;
        end;
      end;
    end;
  finally
    Ini.Free;
  end;
end;

procedure TMStClientAppModule.LoadLotFromDataSets(ALot: TmstLot;
  MainDataSet, ContoursDataSet, PointsDataSet: TDataSet);
begin
  ALot.LoadMainData(MainDataSet);
  ALot.LoadCoords(ContoursDataSet, PointsDataSet);
end;

procedure TMStClientAppModule.LoadLots(const ALeft, ATop, ARight, ABottom: Double; CallBack: TProgressEvent2);
var
  R: TEzRect;
  I: Integer;
begin
  R := Rect2D(ALeft, ABottom, ARight, ATop);
  R := ReorderRect2D(R);
  for I := 0 to FLotRegistry.Count - 1 do
  begin
    if FLotRegistry[I].Layer.LayerInfo.Visible then
      FMapMngr.LoadLots(R, FLotRegistry[I].LotList, FLotRegistry[I].Layer, FLotRegistry[I].CategoryId, CallBack);
  end;
end;

function TMStClientAppModule.LoadMapImage(MapEntityId: Integer): Boolean;
var
  TmpMap: TmstMap;
  N: TNomenclature;
begin
  if (LayerMaps = nil) or (LayerMapImages = nil) then
    raise ELayerNotFound.Create('Невозможно отобразить планшет!' + #13#10 + 'Отсутствует слой планшетов.');
  TmpMap := FMaps.GetByMapEntityId(MapEntityId);
  Result := IntLoadMapImage(TmpMap);
  if not Result then
  begin
    N := TGeoUtils.GetNomenclature(TmpMap.MapName, False);
    if N.Secret then
    begin
      // не нашли секретный, попытаемся показать обычный
      N.ReBuild(False);
      TmpMap := FMaps.GetByNomenclature(N.Nomenclature, False);
      if Assigned(TmpMap) then
        Result := IntLoadMapImage(TmpMap);
    end;
  end;
end;

procedure TMStClientAppModule.LoadProjects(const aLeft, aTop, aRight, aBottom: Double; CallBack: TProgressEvent2);
var
  R: TEzRect;
  Reg: TmstProjectList;
begin
  Reg := FPrjRegistry;
  R := Rect2D(ABottom, ALeft, ATop, ARight);
  R := ReorderRect2D(R);
  FMapMngr.LoadProjects(R, Reg, CallBack);
end;

procedure TMStClientAppModule.LoadProjectsByField(const FieldName, Text: String; OnPrjLoaded: TNotifyEvent);
var
  IdList: TList;
  I: Integer;
  Id: Integer;
  Prj: TmstProject;
  Added: Boolean;
  Reg: TmstProjectList;
  Lst: TIntegerList;
begin
  Reg := FPrjRegistry;
  Lst := FLoadedProjects;
  IdList := FMapMngr.GetProjectIdsByField(FieldName, Text);
  try
    Added := False;
    for I := 0 to Pred(IdList.Count) do
    begin
      // Перебираем все Id
      Id := Integer(IdList[I]);
      Prj := TmstProject(Reg.GetByDatabaseId(Id));
      if not Assigned(Prj) then
      begin
        Prj := FMapMngr.GetProjectById(Id);
        if Assigned(Prj) then
        begin
          Reg.Add(Prj);
          AddProjectToLayer(Prj);
          Lst.Add(Prj.DatabaseId);
          Added := True;
        end;
      end;
      if Assigned(Prj) then
        if Assigned(OnPrjLoaded) then
          OnPrjLoaded(Prj);
    end;
    //
    if Added then
      Lst.Sort;
  finally
    FreeAndNil(IdList);
  end;
end;

procedure TMStClientAppModule.RefreshMaps;
begin
  ReLoadMaps;
  LoadLayerMaps;
  // Генерируем заново слой картинок (R500)
  LoadLayerMapImages;
end;

procedure TMStClientAppModule.ReLoadMaps;
var
  TmpMaps: TmstMapList;
  TmpMap: TmstMap;
  I: Integer;
begin
  // Создем временный список планшетов
  TmpMaps := TmstMapList.Create;
  // Загружаем данные с сервера в список
  FMapMngr.LoadMaps(TmpMaps);
  for I := 0 to Pred(FMaps.Count) do
  begin
    TmpMap := TmpMaps.GetByDatabaseId(FMaps[I].DatabaseId);
    if Assigned(TmpMap) and FMaps[I].ImageLoaded then
    begin
      TmpMap.ImageLoaded := True;
      TmpMap.FileName := FMaps[I].FileName;
    end;
  end;
  FMaps.Free;
  FMaps := TmpMaps;
end;

procedure TMStClientAppModule.RemoveLoadedProject(const aId: Integer);
var
  Idx: Integer;
begin
  if FLoadedProjects.Find(aId, Idx) then
  begin
    FLoadedProjects.Delete(Idx);
//    FLoadedProjects.Sort;
  end;
end;

procedure TMStClientAppModule.RemoveSelectedObjectFromStack(Sender: TObject; AObject: TmstObject);
begin
  FStack.RemoveSelected();
end;

procedure TMStClientAppModule.RepaintViewports;
begin
  GIS.RepaintViewports;
end;

procedure TMStClientAppModule.StartInit;
begin
  if not Options.NoSplash then
  begin
    FSplash := TmstSplashForm.Create(Self);
    FSplash.Show;
  end;
  ProgressInit('', 0, 300);
end;

procedure TMStClientAppModule.Subscribe(aView: ImstCoordView);
begin
  FCoordViews.Add(aView);
  NotifyCoordViews();
end;

procedure TMStClientAppModule.TurnOffLayer(Sender: TObject; aLayer: TmstLayer);
begin
  aLayer.Visible := False;
end;

function TMStClientAppModule.UnLoadMap(MapId: Integer): string;
var
  TmpMap: TmstMap;
begin
  Result := '';
  if Assigned(LayerMaps) then
  with LayerMaps do
  begin
    TmpMap := FMaps.GetByMapEntityId(MapId);
    if not Assigned(TmpMap) then
      Exit;
    LayerMapImages.DeleteEntity(TmpMap.MapImageId);
    TmpMap.MapImageId := -1;
    Result := TmpMap.FileName;
    TmpMap.FileName := '';
    TmpMap.ImageLoaded := False;
  end;
end;

procedure TMStClientAppModule.UnSubscribe(aView: ImstCoordView);
begin
  FCoordViews.Remove(aView);
end;

procedure TMStClientAppModule.UpdateLotEntity(Sender: TObject; AObject: TmstObject);
var
  Lot: TmstLot;
  Layer: TEzBaseLayer;
  Ent: TEzPolygon;
begin
  if AObject is TmstLot then
  begin
    Lot := TmstLot(AObject);
    Layer := GetLotLayer(Lot.GetCategoryId());
    Ent := GetLotPolygon(Lot);
    if Assigned(Ent) then
    begin
      Ent.PenTool.Color := LotColor(Layer.Name);
      if Lot.EntityID > 0 then
        Layer.UpdateEntity(Lot.EntityID, Ent)
      else
        Lot.EntityID := Layer.AddEntity(Ent);
    end
    else
      if Lot.EntityID > 0 then
      begin
        Layer.DeleteEntity(Lot.EntityID);
        Lot.EntityId := -1;
      end;
  end;
end;

procedure TMStClientAppModule.ExportLotsToLayer(AList: TmstLotList; Layer: TEzBaseLayer);
var
  I: Integer;
  Entity: TEzEntity;
begin
  raise Exception.Create('TMStClientAppModule.ExportLotsToLayer');
  for I := 0 to Pred(AList.Count) do
    if AList[I].PointsLoaded then
    begin
      Entity := ExportLot(AList[I]);
      if Assigned(Entity) then
      begin
        Entity.Forget();
        Layer.AddEntity(Entity);
      end;
    end;
end;

procedure TMStClientAppModule.FindLots(DrawBox: TEzDrawBox; const X, Y: Double);
var
  I: Integer;
begin
  for I := 0 to FLotRegistry.Count - 1 do
    InternalFindLots(DrawBox, X, Y, FLotRegistry[I].Layer.Name, FLotRegistry[I].LotList);
end;

procedure TMStClientAppModule.InternalFindLots(DrawBox: TEzDrawBox;
  const X, Y: Double; const LayerName: String; AList: TmstLotList);
var
  Layer: TEzBaseLayer;
  L: TStringList;
  R, P, I: Integer;
  Tmp: TmstObject;
begin
  L := TStringList.Create;
  L.Forget();
  if DrawBox.PickEntity(X, Y, 0, LayerName, Layer, R, P, L) then
  begin
    for I := 0 to Pred(L.Count) do
    begin
      Tmp := AList.GetByEntityId(Integer(L.Objects[I]));
      if Assigned(Tmp) then
        FStack.AddObject(Tmp);
    end;
  end;
end;

function TMStClientAppModule.IntLoadMapImage(aMap: TmstMap): Boolean;
var
  TmpMapOld: TmstMap;
  TmpMapNew: TmstMap;
  MapEnt: TEzEntity;
  MapName: string;
  N: TNomenclature;
  FileLoaded: Boolean;
begin
//  Result := False;
  TmpMapOld := aMap;
  TmpMapNew := aMap;
  // проверяем по каким правилам сформирована номенклатура - по старым или по новым
  N := TGeoUtils.GetNomenclature(aMap.MapName, False);
  MapName := AnsiUpperCase(N.Nomenclature());
  // если сформирована и записана в базу старая номенклатура, то искать будем сначала новый файл
  if MapName <> AnsiUpperCase(aMap.MapName) then
  begin
    TmpMapNew := FMaps.GetByNomenclature(MapName, False);
    if Assigned(TmpMapNew) then
      aMap := TmpMapNew;
  end;
  FileLoaded := FMapMngr.GetMapImage(FMaps, aMap, Self.SessionDir);
  if FileLoaded then
  begin
    if TmpMapOld.MapImageId < 0 then
    begin
      MapEnt := GetMapImageEntity(aMap.MapName, aMap.FileName, aMap.ImageExt);
      MapEnt.Forget;
      TmpMapOld.MapImageId := LayerMapImages.AddEntity(MapEnt);
    end;
  end;
  // файл не нашли на сервере и номенклатура была старая
  if not FileLoaded and (TmpMapOld <> TmpMapNew) then
  begin
    FileLoaded := FMapMngr.GetMapImage(FMaps, TmpMapOld, Self.SessionDir);
    if FileLoaded then
    begin
      if TmpMapOld.MapImageId < 0 then
      begin
        MapEnt := GetMapImageEntity(TmpMapOld.MapName, TmpMapOld.FileName, TmpMapOld.ImageExt);
        MapEnt.Forget();
        TmpMapOld.MapImageId := LayerMapImages.AddEntity(MapEnt);
      end;
    end;
  end;
  Result := FileLoaded;
end;

function TMStClientAppModule.IsMPLayer(alayer: TEzBaseLayer): Boolean;
begin
  Result := alayer.Name = SL_MASTER_PLAN;
end;

function TMStClientAppModule.IsProjectLoaded(const aId: Integer): Boolean;
var
  Idx: Integer;
begin
  Result := FLoadedProjects.Find(aId, Idx);
end;

procedure TMStClientAppModule.LocateLot(const aCategoryId, aDbId: Integer);
var
  aLot: TmstLot;
  Layer: tEzBaseLayer;
begin
  aLot := GetLot(aCategoryId, aDbId);
  if Assigned(aLot) then
  begin
    Layer := GetLotLayer(aCategoryId);
    mstClientMainForm.DrawBox.SetEntityInViewEx(Layer.Name, aLot.EntityID, True);
  end;
end;

procedure TMStClientAppModule.LocateProject(const DbId: Integer);
var
  Prj: TmstProject;
  Reg: TmstProjectList;
begin
  Reg := FPrjRegistry;
  Prj := Reg.GetByDatabaseId(DbId) as TmstProject;
  if Assigned(Prj) then
  begin
    mstClientMainForm.DrawBox.ZoomWindow(TProjectUtils.Window(Prj));
  end;
end;

procedure TMStClientAppModule.LocateSelectedLotContourInStack(Sender: TObject; AObject: TmstObject);
begin
  FStack.LocateCurrentObject();
end;

procedure TMStClientAppModule.LocateSelectedObjectInStack(Sender: TObject; AObject: TmstObject);
var
  DbId: Integer;
  Lot: TmstLot;
  Prj: TmstProject;
var
  ObjList: ImstMPModuleObjList;
  Browser: ImstMPBrowser;
begin
  if AObject is TmstLot then
  begin
    Lot := TmstLot(AObject);
    LocateLot(Lot.GetCategoryId, Lot.DatabaseId);
  end;
  if AObject is TmstProject then
  begin
    Prj := TmstProject(AObject);
    LocateProject(Prj.DatabaseId);
  end;
  if AObject is TmstMPObject then
  begin
    MP.LoadToGis(AObject.DatabaseId, True, False);
    RepaintViewports;
    ObjList := Self.ObjList;
    Browser := ObjList.Browser();
    if Assigned(Browser) then
      Browser.LocateObj(AObject.DatabaseId);
  end;
end;

procedure TMStClientAppModule.ProgressInit(const Message: String;
  Percent: Byte; Delay: Integer; Ticks: Integer = -1);
begin
  if Assigned(FSplash) then
    with TmstSplashForm(FSplash) do
    begin
      lMessage.Caption := Message;
      if Ticks >= 0 then
        lCounter.Caption := IntToStr(Ticks);
      ProgressBar.Position := Percent;
    end;
  Application.ProcessMessages;
  Sleep(Delay);
end;

procedure TMStClientAppModule.ProgressInit(Step: Byte);
begin
  if Assigned(FSplash) then
    with TmstSplashForm(FSplash) do
      ProgressBar.StepBy(Step);
  Application.ProcessMessages;
end;

procedure TMStClientAppModule.RedrawLot(const LotCategoryId, LotId: Integer);
begin
  with GetLotLayer(LotCategoryId) do
  begin
    RecNo := LotId;
    mstClientMainForm.DrawBox.RegenDrawing;
  end;
end;

procedure TMStClientAppModule.SelectionChange(const OldSelection, NewSelection: TmstSelectedLotInfo);
begin
  if (OldSelection.CategoryId <> NewSelection.CategoryId)
     or
     (OldSelection.Id <> NewSelection.Id)
     or
     (OldSelection.ContourId <> NewSelection.ContourId)
  then
  begin
//    if (OldSelection.LotType >= 0) and (OldSelection.Id >= 0) then
//      RedrawLot(OldSelection.CategoryId, OldSelection.Id);
      GetLotLayer(OldSelection.CategoryId).RecNo := OldSelection.Id;
//    if (NewSelection.LotType >= 0) and (NewSelection.Id >= 0) then
//      RedrawLot(NewSelection.CategoryId, NewSelection.Id);
      GetLotLayer(NewSelection.CategoryId).RecNo := NewSelection.Id;
      mstClientMainForm.DrawBox.RegenDrawing;
  end;
end;

function TMStClientAppModule.SessionDir: String;
begin
  Result := FSessionDir;
end;

procedure TMStClientAppModule.LogError(E: Exception; Info: TStrings);
var
  FileName, S: String;
  Mode: Word;
begin
  try
    FileName := TPath.Finish(Self.MainWorkDir, 'errors.log');
    if FileExists(FileName) then
      Mode := fmOpenReadWrite
    else
      Mode := fmCreate;
    with TFileStream.Create(FileName, Mode) do
    try
      Position := Size;
      S := '==========' + #13#10 + E.ClassName + #13#10 + 'Message: ' + E.Message + #13#10 + Info.Text;
      Write(S[1], Length(S));
    finally
      Free;
    end;
  except
  end;
  try
    if Assigned(FMapMngr) then
      FMapMngr.LogException(E, Info);
  except
  end;
end;

procedure TMStClientAppModule.LocateAddress(const DbId: Integer);
var
  Address: TmstAddress;
  Layer: tEzBaseLayer;
begin
  Address := FAddresses.GetByDatabaseId(DbId);
  if Assigned(Address) and (Address.EntityID > 0) then
  begin
    Layer := GIS.Layers.LayerByName(SL_ADDRESSES);
    if Assigned(Layer) then
      mstClientMainForm.DrawBox.SetEntityInViewEx(SL_ADDRESSES, Address.EntityID, True);
  end;
end;

procedure TMStClientAppModule.LoadLotsByField(const FieldName, Text: String; OnLotLoaded: TNotifyEvent);
var
  IdList: TList;
  I: Integer;
  Id: Integer;
  aLot: TmstLot;
  J: Integer;
  aList: TmstLotListEz;
begin
  IdList := FMapMngr.GetLotIdsByField(FieldName, Text);
  try
    for I := 0 to Pred(IdList.Count) do
    begin
      // Перебираем все Id
      Id := Integer(IdList[I]);
      aLot := nil;
      for J := 0 to FLotRegistry.Count - 1 do
      begin
        aLot := FLotRegistry[J].GetByDatabaseId(Id);
        if Assigned(aLot) then
          Break;
      end;
      if not Assigned(aLot) then
      begin
        aLot := FMapMngr.GetLotById(Id);
        if Assigned(aLot) then
        begin
          aList := FLotRegistry.FindByCategory(aLot.GetCategoryId());
          if not Assigned(aList) then
          begin
            raise Exception.Create(
              'Не найден список объектов для категории отводов!' + sLineBreak +
              IntToStr(aLot.GetCategoryId())
            );
          end;
          aList.Add(aLot);
          AddLotToLayer(aLot, aList.Layer);
        end;
      end;
      if Assigned(aLot) then
        if Assigned(OnLotLoaded) then
          OnLotLoaded(aLot);
    end;
  finally
    FreeAndNil(IdList);
  end;
end;

procedure TMStClientAppModule.AddLoadedProject(const aId: Integer);
var
  Idx: Integer;
begin
  if not FLoadedProjects.Find(aId, Idx) then
  begin
    FLoadedProjects.Add(aId);
    FLoadedProjects.Sort;
  end;
end;

procedure TMStClientAppModule.AddLotToLayer(aLot: TmstLot; Layer: TEzBaseLayer);
var
  Ent: TEzEntity;
begin
  if Assigned(aLot) then
    if aLot.PointsLoaded then
    begin
      Ent := ExportLot(aLot);
      if Assigned(Ent) then
      begin
        Ent.Forget();
        aLot.EntityID := Layer.AddEntity(Ent);
      end;
    end;
end;

procedure TMStClientAppModule.FindMap(const Nomenclature: String; OnMapFound: TNotifyEvent);
var
  I: Integer;
begin
  for I := 0 to Pred(FMaps.Count) do
    if FMaps[I].MapName = Nomenclature then
    begin
      if Assigned(OnMapFound) then
        OnMapFound(TObject(FMaps[I].MapEntityId));
      Break;
    end;
end;

procedure TMStClientAppModule.FindMPProjects(DrawBox: TEzDrawBox; const X, Y: Double);
var
  Obj: TmstMPObject;
  I: Integer;
  ObjList: TList;
begin
  ObjList := MP.PickObjects(X, Y);
  try
    for I := 0 to ObjList.Count - 1 do
    begin
      Obj := ObjList[I];
      FStack.AddObject(Obj);
    end;
  finally
    ObjList.Free;
  end;
end;

function TMStClientAppModule.FindProject(const aId: Integer): TmstProject;
var
  I: Integer;
  aPrj: TmstProject;
  Reg: TmstProjectList;
begin
  Reg := FPrjRegistry;
  for I := 0 to Reg.Count - 1 do
  begin
    aPrj := TmstProject(Reg[I]);
    if aPrj.DatabaseId = aId then
    begin
      Result := aPrj;
      Exit;
    end;
  end;
  Result := nil;
end;

procedure TMStClientAppModule.FindProjects(DrawBox: TEzDrawBox; const X, Y: Double);
var
  Prj: TmstProject;
  PrjExtent: TEzRect;
  Pt: TEzPoint;
  I: Integer;
  Reg: TmstProjectList;
begin
  Reg := FPrjRegistry;
  Pt := Point2D(X, Y);
  for I := 0 to Reg.Count - 1 do
  begin
    Prj := Reg[I] as TmstProject;
    PrjExtent := TProjectUtils.Window(Prj);
    if IsPointInBox2D(Pt, PrjExtent) then
      FStack.AddObject(Prj);
  end;
end;

function TMStClientAppModule.HasLoadedProjects(): Boolean;
begin
  Result := FLoadedProjects.Count > 0;
end;

procedure TMStClientAppModule.HideAllLotsExceptSelectedInStack(Sender: TObject; AObject: TmstObject);
var
  I, C: Integer;
  aLot, TmpLot: TmstLot;
  aLotList: TmstLotList;
  TmpModel: TmstStackViewModel;
begin
  if AObject is TmstLot then
  begin
    aLot := AObject as TmstLot;
    aLotList := FStack.LotLists[aLot.GetCategoryId];
    if Assigned(aLotList) then
    begin
      for I := 0 to aLotList.Count - 1 do
      begin
        if aLotList[I].DatabaseId <> aLot.DatabaseId then
          HideLot(aLotList[I].GetCategoryId, aLotList[I].DatabaseId);
      end;
    end;
  end;
  FStack.UpdateView;
  RepaintViewports;
end;

procedure TMStClientAppModule.HideAllLotsInStack;
begin
  SetStackLotsVisibility(False);
end;

procedure TMStClientAppModule.HideLot(const aCategoryId, DatabaseId: Integer);
var
  I: Integer;
  aLot: TmstLot;
  aList: TmstLotList;
begin
  aLot := nil;
  aList := GetLotList(aCategoryId);
  I := aList.IndexOfDatabaseId(DatabaseId);
  if I >=0 then
    aLot := aList.Items[I];
  if Assigned(aLot) then
    aLot.Visible := False;
end;

procedure TMStClientAppModule.SetShowInvisibleLots(const Value: Boolean);
begin
  FShowInvisibleLots := Value;
end;

procedure TMStClientAppModule.SetStackLotsVisibility(IsVisible: Boolean);
var
  I: Integer;
  SelectedObjects: TList;
  Lot: TmstLot;
begin
  SelectedObjects := FStack.GetSelectedObjects();
  try
    for I := 0 to SelectedObjects.Count - 1 do
    begin
      Lot := SelectedObjects[I];
      Lot.Visible := IsVisible;
//      if IsVisible then
//        UnHideLot(Lot.GetCategoryId, Lot.DatabaseId)
//      else
//        HideLot(Lot.GetCategoryId, Lot.DatabaseId);
    end;
    FStack.UpdateView;
    RepaintViewports;
  finally
    SelectedObjects.Free;
  end;
end;

procedure TMStClientAppModule.SetViewCoordSystem(const Value: TCoordSystem);
begin
  FViewCoordSystem := Value;
  NotifyCoordViews();
end;

procedure TMStClientAppModule.ShowAllLotsInStack;
begin
  SetStackLotsVisibility(True);
end;

procedure TMStClientAppModule.ShowHideAllLotContoursExceptSelectedInStack(Sender: TObject; AObject: TmstObject);
begin
  FStack.OnOffAllContours();
end;

procedure TMStClientAppModule.ShowHideSelectedLotContourInStack(Sender: TObject; AObject: TmstObject);
begin
  FStack.OnOffCurrentContour();
end;

procedure TMStClientAppModule.PrepareCadastralBlock(Layer: TEzBaseLayer;
  Entity: TEzEntity; const Clip: TEzRect; var EntList: TEzEntityList);
var
  aBlock: TEzPolygon;
  Text: TEzEntity;
  S: String;
  X, Y: Double;
begin
  aBlock := TEzPolygon(Entity);
  aBlock.PenTool.Color := clBlue;
  aBlock.BrushTool.Pattern := 0;
  aBlock.BrushTool.BackColor := clNone;
  Layer.DBTable.RecNo := Layer.Recno;
  S := Layer.DBTable.StringGet('KN');
  if S <> '' then
  begin
    if not Assigned(EntList) then
      EntList := TEzEntityList.Create;
    Text := EzGraphics.CreateText(S, lpCenter, 0, aBlock.FBox.Emin, aBlock.FBox.Emax,
      Ez_Preferences.DefFontStyle.FFontStyle, True);
    aBlock.Centroid(X, Y);
    with TEzTrueTypeText(Text) do
    begin
      FontTool.Color := clBlue;
      BasePoint := Point2D(X - (FBox.xmax - FBox.xmin) / 2, Y + (FBox.ymax - FBox.ymin));
    end;
    EntList.Add(Text);
  end;
end;

procedure TMStClientAppModule.PrepareLotEntityToNormalMode(Layer: TEzBaseLayer;
  Entity: TEzEntity; var EntList: TEzEntityList; var CanShow: Boolean);
var
  aLot: TmstLot;
  aContour: TmstLotContour;
  LotEntity: TEzPolygon;
  ContourEntity: TEzEntity;
  I: Integer;
begin
  aLot := GetLotForEntity(Layer);
  if Assigned(aLot) then
  begin
    if not aLot.Visible then
    begin
      CanShow := ShowInvisibleLots;
      if CanShow then
        TEzOpenedEntity(Entity).PenTool.Color := clBtnFace;
    end
    else
    begin
      if Stack.SelectedLot.DatabaseId = aLot.DatabaseId then
      begin
        if aLot.HasColor then
        begin
          for I := 0 to aLot.Contours.Count - 1 do
          begin
            if aLot.Contours[I].Enabled then
            begin
              ContourEntity := ContourToEntity(aLot.Contours[I]);
              if Assigned(ContourEntity) then
              begin
                if not Assigned(EntList) then
                  EntList := TEzEntityList.Create;
                EntList.Add(ContourEntity);
                //
                //TEzOpenedEntity(ContourEntity).PenTool.FPenStyle.Style := 1;
                //TEzOpenedEntity(ContourEntity).PenTool.FPenStyle.Style := 2; // точки
                TEzOpenedEntity(ContourEntity).PenTool.FPenStyle.Style := 4;  // тире
                if Stack.SelectedLot.ContourId = aLot.Contours[I].DatabaseId then
                begin
                  TEzOpenedEntity(ContourEntity).PenTool.Color := clRed;
                  TEzOpenedEntity(ContourEntity).PenTool.Scale := 0;
                  TEzOpenedEntity(ContourEntity).PenTool.Width := -3;
                  //TEzOpenedEntity(ContourEntity).PenTool.FPenStyle.Style := 1;
                  TEzOpenedEntity(ContourEntity).PenTool.FPenStyle.Style := 4;
                  // Добавим маркеры точек к контуру
                  AddContourMarkers(EntList, aLot.Contours[I], mstClientMainForm.DrawBox.CurrentScale);
                end
                else
                begin
                  if not aLot.Contours[I].HasColor then
                    TEzOpenedEntity(ContourEntity).PenTool.Color := LotColor(Layer.Name);
                  TEzOpenedEntity(ContourEntity).PenTool.Width := -3;
                end;
              end;
            end;
          end;
          if Assigned(EntList) and (EntList.Count > 0) then
            Entity.FSkipPainting := True;
          if Stack.SelectedLot.ContourId = 0 then
          begin
            if not Assigned(EntList) then
              EntList := TEzEntityList.Create;
            AddLotMarkers(EntList, aLot, mstClientMainForm.DrawBox.CurrentScale);
          end;
        end
        else
        begin
          TEzOpenedEntity(Entity).PenTool.Color := clWhite;
          LotEntity := GetLotPolygon(aLot);
          if Assigned(LotEntity) then
          begin
            LotEntity.PenTool.Color := clRed;
            //LotEntity.PenTool.FPenStyle.Style := 0;
            //LotEntity.PenTool.FPenStyle.Style := 2;
            LotEntity.PenTool.FPenStyle.Style := 4;
            if not Assigned(EntList) then
              EntList := TEzEntityList.Create;
            EntList.Add(LotEntity);
            if Stack.SelectedLot.ContourId > 0 then
            begin
              aContour := aLot.Contours.GetByDatabaseId(Stack.SelectedLot.ContourId);
              if Assigned(aContour) then
              begin
                ContourEntity := ContourToEntity(aContour);
                if Assigned(ContourEntity) then
                begin
                  TEzOpenedEntity(ContourEntity).PenTool.Color := clRed;
                  TEzOpenedEntity(ContourEntity).PenTool.Scale := 0;
                  TEzOpenedEntity(ContourEntity).PenTool.FPenStyle.Style := 4;
                  EntList.Add(ContourEntity);
                  // Добавим маркеры точек к контуру
                  AddContourMarkers(EntList, aContour, mstClientMainForm.DrawBox.CurrentScale);
                end;
              end;
            end
            else
              // Добавим маркеры точек ко всему участку
              AddLotMarkers(EntList, aLot, mstClientMainForm.DrawBox.CurrentScale);
          end;
        end;
      end
      else
      begin
        //
        TEzOpenedEntity(Entity).PenTool.Color := LotColor(Layer.Name);
        TEzOpenedEntity(Entity).PenTool.Width := 0;
      end;
    end;
  end;
end;

procedure TMStClientAppModule.GISAfterPaintEntity(Sender: TObject; Layer: TEzBaseLayer; Recno: Integer;
  Entity: TEzEntity; Grapher: TEzGrapher; Canvas: TCanvas; const Clip: TEzRect; DrawMode: TEzDrawMode);
var
  NetId: Integer;
  Nt: TmstProjectNetType;
  DrawCP: Boolean;
  ObjId: Integer;
  MPLayer: Boolean;
begin
  if DrawMode = dmNormal then
  begin
    DrawCP := False;
    MPLayer := False;
    Layer.Recno := Recno;
    if (Layer.DBTable <> nil) and (Layer.Name = SL_PROJECT_OPEN) or (Layer.Name = SL_PROJECT_CLOSED) then
    begin
      Layer.DBTable.RecNo := Layer.Recno;
      NetId := Layer.DBTable.IntegerGet(SLF_NET_ID);
      Nt := FNetTypes.ById(NetId);
      if Assigned(Nt) and Nt.Visible then
        if TProjectsSettings.EntityIsCurrent(Layer, Recno) then
          DrawCp := True;
    end
    else
    if IsMPLayer(Layer) then
    begin
      MPLayer := True;
      ObjId := Entity.ExtID;
      if TMPSettings.IsCurrentObj(ObjId) then
        DrawCP := True;
    end;
    //
    if DrawCP then
      Entity.DrawControlPoints(Grapher, Canvas, Grapher.CurrentParams.VisualWindow, False);
  end;
end;

procedure TMStClientAppModule.GISBeforePaintEntity(Sender: TObject;
  Layer: TEzBaseLayer; Recno: Integer; Entity: TEzEntity;
  Grapher: TEzGrapher; Canvas: TCanvas; const Clip: TEzRect;
  DrawMode: TEzDrawMode; var CanShow: Boolean; var EntList: TEzEntityList;
  var AutoFree: Boolean);
var
  Clr: TColor;
  MPLayer: Boolean;
begin
  MPLayer := False;
  Layer.Recno := Recno;
  if Pos('CADASTR_', Layer.Name) = 1 then
    PrepareCadastralBlock(Layer, Entity, Clip, EntList)
  else
  if Layer.Name = SL_WATERMARKS then
    CanShow := Grapher.Device = adPrinter
  else
  if Layer.Name = SL_MAP_IMAGES_LAYER then
  begin
    if Entity.EntityID = idPictureRef then
      PrepareM500Bitmap(TEzPictureRef(Entity));
  end
  else
  if IsMPLayer(Layer) then
  begin
    MPLayer := True;
    CanShow := GetMPObjectIsVisible(Layer, Recno, Clr);
    if CanShow then
      if Entity is TEzOpenedEntity then
        TEzOpenedEntity(Entity).PenTool.Color := Clr;
    if Entity.ExtID = TMPSettings.FIntersectObjId then
    begin
      if not TMPSettings.FIntersectPt1Empty then
        AddPointMarker(
          EntList,
          TMPSettings.FIntersectPt1.x,
          TMPSettings.FIntersectPt1.y,
          mstClientMainForm.DrawBox.CurrentScale,
          'Точка 1',
          mpTop,
          clPurple
        );
      if not TMPSettings.FIntersectPt2Empty then
        AddPointMarker(
          EntList,
          TMPSettings.FIntersectPt2.x,
          TMPSettings.FIntersectPt2.y,
          mstClientMainForm.DrawBox.CurrentScale,
          'Точка 2',
          mpTop,
          clPurple
        );
    end;
  end
  else
  if Mode = amPrint then
  begin
    if Grapher.Device = adPrinter then
    begin
      CanShow := Entity.EntityID <> idPage;
      if CanShow then
      begin
        if Layer.Name = SL_REPORT then
          CanShow := Recno <> mstPrintModule.PrintAreaId;
      end;
    end;
    if CanShow then
      PrepareEntityToPrintMode(Layer, Entity, EntList, CanShow);
  end
  else
  begin
    PrepareLotEntityToNormalMode(Layer, Entity, EntList, CanShow);
  end;
end;

procedure TMStClientAppModule.GISBeforePaintLayer(Sender: TObject; Layer: TEzBaseLayer; Grapher: TEzGrapher;
  var CanShow, WasFiltered: Boolean; var EntList: TEzEntityList; var AutoFree: Boolean);
var
  L: TmstLayer;
  LayerIsVisible: Boolean;
begin
  // проверяем есть ли у слоя родитель
  // если есть, то проверяем его видимость
  L := FLayers.GetByName(Layer.Name, False);
  LayerIsVisible := Layer.LayerInfo.Visible;
  while Assigned(L) do
  begin
    LayerIsVisible := LayerIsVisible and L.Visible;
    L := L.Parent;
  end;
  CanShow := LayerIsVisible;
end;

procedure TMStClientAppModule.DataModuleCreate(Sender: TObject);
var
  aSymbol: TEzSymbol;
  aPoint: TEzEllipse;
  aCross: TEzPolyline;
  aLabel: TEzTrueTypeText;
begin
  FLoadedProjects := TIntegerList.Create;
  FNetTypes := TmstProjectNetTypes.Create;
  FCoordViews := TInterfaceList.Create;
  // создаем симовл для точки выбранного отвода
  aSymbol := TEzSymbol.Create(Ez_Symbols);
  aPoint := TEzEllipse.CreateEntity(Point2D(-1, 1), Point2D(1, -1));
  aPoint.PenTool.Color := clRed;
  aSymbol.Add(aPoint);
  aCross := TEzPolyline.CreateEntity(
    [Point2D(-1, -1),
     Point2D(1, 1),
     Point2D(1, -1),
     Point2D(-1, 1)],
    False);
  aCross.Points.Parts.Add(0);
  aCross.Points.Parts.Add(2);
  aCross.PenTool.Color := clRed;
//  aSymbol.Add(aCross);
  aLabel := TEzTrueTypeText.CreateEntity(aPoint.FBox.Emin, 'Label', 4, 0);
  aLabel.FontTool.Color := clRed;
  aSymbol.Add(aLabel);
  FPointMarker := Ez_Symbols.Add(aSymbol);
  // текущий пользователь
  FUser := TmstUser.Create;
  FUser.Id := GetLastUserId;
  FUser.OfficeId := GetLastUserOfficeId;
  LoadCKOptions();
end;

procedure TMStClientAppModule.BeforeAddLotToList(aList: TmstLotList; var aLot: TmstLot);
begin

end;

procedure TMStClientAppModule.LocateContour(const aCategoryId, aLotDbId, aContourDbId: Integer);
var
  aLot: TmstLot;
  Contour: TmstLotContour;
begin
  aLot := GetLot(aCategoryId, aLotDbId);
  if Assigned(aLot) then
  begin
    Contour := aLot.Contours.GetByDatabaseId(aContourDbId);
    if Assigned(Contour) then
      with ContourRect(Contour) do
      mstClientMainForm.DrawBox.SetViewTo(xmin, ymin, xmax, ymax);
  end;
end;

procedure TMStClientAppModule.UnHideLot(const aCategoryId, DatabaseId: Integer);
var
  I: Integer;
  aLot: TmstLot;
begin
  aLot := nil;
  with GetLotList(aCategoryId) do
  begin
    I := IndexOfDatabaseId(DatabaseId);
    if I >=0 then
      aLot := Items[I];
    if Assigned(aLot) then
      aLot.Visible := True;
  end;
end;

procedure TMStClientAppModule.UnloadAllLots;
var
  I: Integer;
begin
  for I := 0 to FLotRegistry.Count - 1 do
  begin
    TEzLayerUtils.ClearLayer(GIS, FLotRegistry.Items[I].Layer, nil);
    FLotRegistry.Items[I].LotList.Clear;
    FLotRegistry.Items[I].Clear;
  end;
end;

function TMStClientAppModule.GetLots(aLot: TmstLot): ILots;
begin
  if Assigned(aLot) then
    Result := FMapMngr.GetLots(aLot)
  else
    Result := nil;
end;

procedure TMStClientAppModule.ConnectLayerToGIS(aLayer: TmstLayer; UseLayerVisibility: Boolean);
var
  J: Integer;
  Layer: TEzBaseLayer;
  LayerVisible: Boolean;
begin
  case aLayer.LayerType of
  ID_LT_FILE :
    begin
      J := GIS.Layers.Add(Self.SessionDir + aLayer.Name, ltDesktop);
      Layer := GIS.Layers[J];
    end;
  ID_LT_MEMORY :
    begin
      Layer := GIS.Layers.CreateNewCosmethic(aLayer.Name);
    end;
  ID_LT_IMPORTED :
    begin
//      Layer := GIS.Layers.CreateNewAnimation(aLayer.Name);
      J := GIS.Layers.Add(Self.SessionDir + aLayer.Name, ltDesktop);
      Layer := GIS.Layers[J];
    end;
  ID_LT_FAKE :
    begin
      Layer := nil;
    end;
  else
    begin
      DeleteFiles(Self.SessionDir, aLayer.Name + '.*');
      Layer := GIS.Layers.CreateNewEx(Self.SessionDir + aLayer.Name, csCartesian, cum, nil);
    end;
  end;
  if Assigned(Layer) then
  begin
    Layer.Open;
    if UseLayerVisibility then
      LayerVisible := aLayer.Visible
    else
      LayerVisible := True;
    Layer.LayerInfo.Visible := LayerVisible;
  end;
  //
//  for I := 0 to aLayer.ChildCount - 1 do
//    ConnectLayerToGIS(aLayer.Child[I], UseLayerVisibility);
end;

procedure TMStClientAppModule.OnDeleteLayer(Sender: TObject; aLayer: TmstLayer);
begin
  if Assigned(aLayer) and GIS.Active then
    GIS.Layers.Delete(aLayer.Name, True);
end;

procedure TMStClientAppModule.SetMode(const Value: TmstAppMode);
var
  Params: IParameters;
begin
  if FMode <> Value then
  begin
    if (Value = amPrint) then
    begin
      Params := FMapMngr.GetParameters();
      if Assigned(Params) then
      begin
        Params.Open;
        try
          mstPrintModule.WatermarkText := Params.GetWatermarkParameter(WMP_WATERMARK_TEXT) + sLineBreak + IntToStr(User.Id);
        finally
          Params.Close;
        end;
      end;
      mstPrintModule.PrepareReport;
      mstPrintModule.Lot := GetSelectedLot;
    end
    else
    if (Value <> amPrint) and (FMode = amPrint) then
    begin
      mstPrintModule.UnprepareReport;
    end;
    FMode := Value;
  end;
end;

procedure TMStClientAppModule.SetOption(const Section, Option, Value: String);
var
  IniFileName: string;
begin
  IniFileName := TPath.Finish(ExtractFilePath(ParamStr(0)), 'ms2.ini');
  if not FileExists(IniFileName) then
    IniFileName := 'ms2.ini';
  try
    with TIniFile.Create(IniFileName) do
    try
      WriteString(Section, Option, Value);
    finally
      Free;
    end;
  except
    on E: Exception do
    begin
      Application.ShowException(E);
    end;
  end;
end;

function TMStClientAppModule.GetSelectedLot: TmstLot;
var
  I: Integer;
begin
  Result := nil;
  if FStack.SelectedLot.DatabaseId >= 0 then
  begin
    for I := 0 to FLotRegistry.Count - 1 do
    begin
      Result := FLotRegistry[I].GetByDatabaseId(FStack.SelectedLot.DatabaseId);
      if Assigned(Result) then
        Exit;
    end;
  end;
end;

function TMStClientAppModule.GetStats: IStats;
begin
  Result := FMapMngr.GetStats;
end;

procedure TMStClientAppModule.GISCurrentLayerChange(Sender: TObject; const LayerName: String);
begin
  if Assigned(mstClientMainForm) and mstClientMainForm.Visible then
  begin
    mstClientMainForm.DrawBox.Selection.Clear;
    mstClientMainForm.DrawBox.RegenDrawing;
  end;
end;

procedure TMStClientAppModule.OnSelectLayer(Sender: TObject; aLayer: TmstLayer);
begin
  if Assigned(aLayer) then
  if GIS.CurrentLayerName <> aLayer.Name then
    GIS.CurrentLayerName := aLayer.Name;
end;

function TMStClientAppModule.GetLotForEntity(Layer: TEzBaseLayer): TmstLot;
var
  I: Integer;
begin
  Result := nil;
  for I := 0 to FLotRegistry.Count - 1 do
    if FLotRegistry[I].Layer = Layer then
    begin
      Result := FLotRegistry[I].GetByEntityId(Layer.Recno);
      Exit;
    end;
end;

procedure TMStClientAppModule.ApplicationEventsException(Sender: TObject; E: Exception);
var
  Log: TStringList;
  Stack: TStringList;
begin
  Log := TStringList.Create;
  Log.Forget;
  Log.Add('======== Ошибка !!! ========');
  Log.Add(E.Message);
  Log.Add('========================');
  // Применяем функцию из JCL
  Stack := TStringList.Create;
  Stack.Forget;
  JclLastExceptStackListToStrings(Stack, True, False, False);
  Log.AddStrings(Stack);
  LogError(E, Log);
  Application.MessageBox(PChar(Log.Text), PChar('Ошибка!'), MB_OK + MB_ICONSTOP);
end;

function TMStClientAppModule.UploadMapImage(const FileName: String; var Message: String): Boolean;
var
  MapName: String;
  I: Integer;
  TmpMap: TmstMap;
  TmpMapFileName: string;
  TmpMapEnt: TEzEntity;
begin
  Result := False;
  MapName := ExtractFileName(FileName);
  I := Pos('.', MapName);
  if I > 0 then
    SetLength(MapName, I - 1);
  if not TGeoUtils.IsNomenclatureValid(MapName, False) then
  begin
    Message := 'Ошибочная номенклатура: ' + MapName;
    Exit;
  end;
  MapName := TGeoUtils.GetNomenclature(MapName, False).Nomenclature();
  try
    TmpMap := FMaps.GetByNomenclature(MapName, False);
    if not Assigned(TmpMap) then
    begin
      TmpMap := TmstMap.Create;
      TmpMap.MapName := MapName;
      FMaps.Add(TmpMap);
    end;
    if FMapMngr.SetMapImage(FMaps, TmpMap, FileName) then
    begin
      if TmpMap.MapImageId < 0 then
      begin
        TmpMapFileName := TPath.Finish(Self.SessionDir, MapName);
        CopyFile(PChar(FileName), PChar(TmpMapFileName), False);
        TmpMap.FileName := TmpMapFileName;
        TmpMapEnt := GetMapImageEntity(TmpMap.MapName, TmpMap.FileName, TmpMap.ImageExt);
        TmpMapEnt.Forget();
        TmpMap.MapImageId := LayerMapImages.AddEntity(TmpMapEnt);
        TmpMap.ImageLoaded := True;
      end
      else
        CopyFile(PChar(FileName), PChar(TmpMap.FileName), False);
      Message := 'Планшет ' + MapName + ' успешно загружен';
      mstClientMainForm.DrawBox.RegenDrawing;
      Result := True;
    end
    else
    begin
      FMaps.Remove(TmpMap);
      //TmpMap.Free;
      Message := 'Не удалось загрузить планшет ' + MapName + ' из файла ' + FileName + '!';
    end;
  except
    on E: Exception do
    begin
      Message := E.Message + #13#10 + '-' + Message;
      Result := False;
    end;
  end;
end;

procedure TMStClientAppModule.ViewPropertiesSelectedObjectInStack(Sender: TObject; AObject: TmstObject);
var
  Node: TmstTreeNode;
  aLot: TmstLot;
  Prj: TmstProject;
begin
  if AObject is TmstLot then
  begin
    aLot := AObject as TmstLot;
    with TmstLotPropertiesView.Create do
    try
      ShowView(aLot);
    finally
      Free;
    end;
  end;
  //
  if AObject is TmstProject then
  begin
    Prj := AObject as TmstProject;
    if Prj.Edit(True) then
      Prj.Save(FMapMngr as IDb);
  end;
  //
  if AObject is TmstMPObject then
  begin
    MP.EditObjProperties(AObject.DatabaseId);
  end;
end;

procedure TMStClientAppModule.ViewSelectedObjInSteckInBrowser(Sender: TObject; AObject: TmstObject);
var
  ObjList: ImstMPModuleObjList;
  Browser: ImstMPBrowser;
begin
  if AObject is TmstMPObject then
  begin
    ObjList := Self.ObjList;
    Browser := ObjList.Browser();
    if Assigned(Browser) then
      Browser.LocateObj(AObject.DatabaseId);
  end;
end;

procedure TMStClientAppModule.ChangeVisibilitySelectedLotInStack(Sender: TObject; AObject: TmstObject);
var
  Lot: TmstLot;
begin
  if AObject is TmstLot then
  begin
    Lot := AObject as TmstLot;
    Lot.Visible := not Lot.Visible;
  end;
  FStack.UpdateView;
  RepaintViewports;
end;

procedure TMStClientAppModule.ClearLoadedProjects();
begin
  FLoadedProjects.Clear;
end;

function TMStClientAppModule.ClearMapImagesTo399(mLog: TMemo{var Message: String}): Boolean;
var
  MapFiles: TStringList;
  i: Integer;
  TmpMap: TmstMap;
  Message: String;
  countMap: Integer;
begin
  Result := False;
  countMap := 0;
  MapFiles := IStringList(TSTringList.Create).StringList;
  try
    FMapMngr.ClearMapImages(MapFiles);
    if Assigned(MapFiles) then
    begin
      for i := 0 to Pred(MapFiles.Count) do
      begin
        TmpMap := FMaps.GetByNomenclature(MapFiles[i], False);
        if not Assigned(TmpMap) then
        begin
          Message := 'Планшет не обнаружен: ' + MapFiles[i];
          mLog.Lines.Add(Message);
          Continue;
        end;
        DeleteMapEntity(TmpMap);
        Message := 'Планшет ' + MapFiles[i] + ' успешно удален';
        mLog.Lines.Add(Message);
        Application.ProcessMessages();
        countMap := countMap + 1;
      end;
      Result := True;
    end;
    Message := 'Удалено планшетов: ' + IntToStr(countMap);
    mLog.Lines.Add(Message);
  except
    on E: Exception do
    begin
      Message := E.Message + #13#10 + '-' + Message;
      mLog.Lines.Add(Message);
      Result := False;
    end;
  end;
end;

function TMStClientAppModule.DeleteMapImage(const MapName: String; var Message: String): Boolean;
var
  TmpMap: TmstMap;
begin
  Result := False;
  try
    TmpMap := FMaps.GetByNomenclature(MapName, False);
    if not Assigned(TmpMap) then
    begin
      Message := 'Планшет не обнаружен: ' + MapName;
      Exit;
    end;
    if FMapMngr.DeleteMapImage(FMaps, TmpMap) then
    begin
      DeleteMapEntity(TmpMap);
      Message := 'Планшет ' + MapName + ' успешно удален';
      mstClientMainForm.DrawBox.RegenDrawing;
      Result := True;
    end
    else
    begin
      Message := 'Не удалось удалить планшет ' + MapName + ' из файла ' + MapName + '!';
    end;
  except
    on E: Exception do
    begin
      Message := E.Message + #13#10 + '-' + Message;
      Result := False;
    end;
  end;
end;

procedure TMStClientAppModule.DisplayLayersDialog;
var
  Frm: TMStFormLayers;
begin
  // создаём объект для управления слоями
  Frm := TMStFormLayers.Create(Self);
  try
    Frm.Execute();
  finally
    Frm.Free;
  end;
end;

procedure TMStClientAppModule.DeleteMapEntity(aMap: TmstMap);
var
  I: Integer;
begin
  LayerMaps.DeleteEntity(aMap.MapEntityId);
  if aMap.MapImageId > 0 then
    LayerMapImages.DeleteEntity(aMap.MapImageId);
  I := Fmaps.IndexOf(aMap);
  if I >= 0 then
    FMaps.Delete(I);
end;

procedure TMStClientAppModule.LogError(E: Exception; const Info: string);
var
  FileName, S: String;
  Mode: Word;
begin
  FileName := ExtractFilePath(Application.ExeName) + 'errors.log';
  if FileExists(FileName) then
    Mode := fmOpenReadWrite
  else
    Mode := fmCreate;
  with TFileStream.Create(FileName, Mode) do
  try
    Position := Size;
    S := '==========' + #13#10 + E.ClassName + #13#10 + 'Message: ' + E.Message + #13#10 + Info;
    Write(S[1], Length(S));
  finally
    Free;
  end;
end;

function TMStClientAppModule.Logon: Boolean;
begin
  SetLayout(loEng);
  Result := FMapMngr.Logon(FUser);
  if Result then
  begin
    SaveLastUserId;
    SaveLastUserOfficeId;
  end;
  SetLayout(loRus);
end;

procedure TMStClientAppModule.LogUserAcion(const UserAction, Info: string);
begin
  inherited;
  FMapMngr.LogUserAcion(UserAction, Info);
end;

procedure TMStClientAppModule.MapsPrinted;
begin
  FMapMngr.AfterMapsPrint(MapNames, Order);
end;

procedure TMStClientAppModule.MPLayerVisibleChanged(ALayer: TmstLayer);
var
  Redraw: Boolean;
begin
  Redraw := True;
  // надо обновить справочник по видимости объектов в МП
  {
  Что за справочник?
  К каждому объекту привязана ссылка на классификатор объектов.
  В классификаторе есть ID класса.
  ID класса связано с ID слоя МП.
  КРоме того у объекта есть StatsId, который тоже привязан к слою МП.
  StatsId вычисляется только динамически:
  - проектный/нанесённый
  - справка выдана
  - демонтируемый
  }
  if ALayer.Parent = nil then
    MP.Classifier.MPVisible := ALayer.Visible;
  if ALayer.MpStatusId > 0 then
    MP.Classifier.SetMPStatusVisible(ALayer.MpStatusId, ALayer.Visible);
  if ALayer.MpCategoryId > 0 then
    MP.Classifier.SetMPCategoryVisible(ALayer.MpStatusId, ALayer.MpCategoryId, ALayer.Visible);
  //
  GIS.RepaintViewports;
end;

procedure TMStClientAppModule.NotifyCoordViews;
var
  I: Integer;
  S: string;
  TheView: ImstCoordView;
begin
  for I := 0 to FCoordViews.Count - 1 do
  begin
    try
      TheView := ImstCoordView(FCoordViews[I]);
      TheView.CoordSystemChanged(FViewCoordSystem);
    except
      on E: Exception do
      begin
        S := 'I = ' + IntToStr(I);
        LogError(E, S);
      end;
    end;
  end;
end;

function TMStClientAppModule.GetLastUserId: Integer;
begin
  Result := StrToInt(GetOption('User', 'ID', '0'));
end;

function TMStClientAppModule.GetLastUserOfficeId: Integer;
begin
  Result := StrToInt(GetOption('User', 'Office', '0'));
end;

procedure TMStClientAppModule.SaveLastUserId;
var
  IniFileName: string;
begin
  IniFileName := TPath.Finish(ExtractFilePath(ParamStr(0)), 'ms2.ini');
  if not FileExists(IniFileName) then
    IniFileName := 'ms2.ini';
  with TIniFile.Create(IniFileName) do
  try
    WriteInteger('User', 'ID', FUser.Id);
  finally
    Free;
  end;
end;

procedure TMStClientAppModule.SaveLastUserOfficeId;
var
  IniFileName: string;
begin
  IniFileName := TPath.Finish(ExtractFilePath(ParamStr(0)), 'ms2.ini');
  if not FileExists(IniFileName) then
    IniFileName := 'ms2.ini';
  with TIniFile.Create(IniFileName) do
  try
    WriteInteger('User', 'Office', FUser.OfficeId);
  finally
    Free;
  end;
end;

procedure TMStClientAppModule.SaveLayersVisibility;
var
  IniFileName: string;
  Ini: TIniFile;
  I: Integer;
  LayerLst: TList;
  L: TmstLayer;
begin
  IniFileName := TPath.Finish(ExtractFilePath(ParamStr(0)), 'ms2.ini');
  if not FileExists(IniFileName) then
    IniFileName := 'ms2.ini';
  Ini := TIniFile.Create(IniFileName);
  try
    Ini.EraseSection('Layers');
    LayerLst := fLayers.GetPlainList();
    LayerLst.Forget();
    for I := 0 to LayerLst.Count - 1 do
    begin
      L := LayerLst[I];
      Ini.WriteBool('Layers', L.Name, L.Visible);
    end;
    Ini.UpdateFile();
  finally
    Ini.Free;
  end;
end;

type
  THackComponent = class(TComponent)
  end;

procedure TMStClientAppModule.WriteFormPosition(AOwner: TComponent;
  Form: TForm);
var
  Placement: TWindowPlacement;
begin
  if Assigned(Form) then
  begin
    Placement.Length := SizeOf(TWindowPlacement);
    GetWindowPlacement(Form.Handle, @Placement);
    with Placement, TForm(Form) do
    begin
      if (Form = Application.MainForm) and IsIconic(Application.Handle) then
        ShowCmd := SW_SHOWMINIMIZED;
      if (FormStyle = fsMDIChild) and (WindowState = wsMinimized) then
        Flags := Flags or WPF_SETMINPOSITION;
      SaveAppParam(AOwner, Form, 'Flags', Flags);
      SaveAppParam(AOwner, Form, 'ShowCmd', ShowCmd);
      SaveAppParam(AOwner, Form, 'Pixels', Screen.PixelsPerInch);
      
      SaveAppParam(AOwner, Form, 'MinPositionX', ptMinPosition.X);
      SaveAppParam(AOwner, Form, 'MinPositionY', ptMinPosition.Y);
      SaveAppParam(AOwner, Form, 'MaxPositionX', ptMaxPosition.X);
      SaveAppParam(AOwner, Form, 'MaxPositionY', ptMaxPosition.Y);

      SaveAppParam(AOwner, Form, 'NormalPositionL', rcNormalPosition.Left);
      SaveAppParam(AOwner, Form, 'NormalPositionT', rcNormalPosition.Top);
      SaveAppParam(AOwner, Form, 'NormalPositionR', rcNormalPosition.Right);
      SaveAppParam(AOwner, Form, 'NormalPositionB', rcNormalPosition.Bottom);
    end;
  end;
end;

procedure TMStClientAppModule.WriteGridProperties(AOwner: TComponent;
  Grid: TDBGrid);
var
  I: Integer;
  OnlyOneGrid: Boolean;
begin
  OnlyOneGrid := HasOnlyOneGrid(AOwner);
  with Grid do
    for I := 0 to Pred(Columns.Count) do
      SaveAppParam(AOwner, Grid, PROP_COL + Columns[I].FieldName,
        IntToStr(Columns[I].Index) + ',' + IntToStr(Columns[I].Width), not OnlyOneGrid);
end;

procedure TMStClientAppModule.ReadFormPosition(AOwner: TComponent; Form: TForm);
const
  Delims = [',', ' '];
var
  Placement: TWindowPlacement;
  WinState: TWindowState;
  PPP: Integer;
begin
  Placement.Length := SizeOf(TWindowPlacement);
  GetWindowPlacement(Form.Handle, @Placement);
  with Placement, TForm(Form) do
  begin
    if not IsWindowVisible(Form.Handle) then
      ShowCmd := SW_HIDE;
    Flags := ReadAppParam(AOwner, Form, 'Flags', varInteger);
    // Form Position
    ptMinPosition.X := ReadAppParam(AOwner, Form, 'MinPositionX', varInteger);
    ptMinPosition.Y := ReadAppParam(AOwner, Form, 'MinPositionY', varInteger);
    ptMaxPosition.X := ReadAppParam(AOwner, Form, 'MaxPositionX', varInteger);
    ptMaxPosition.Y := ReadAppParam(AOwner, Form, 'MaxPositionY', varInteger);

    rcNormalPosition.Left := ReadAppParam(AOwner, Form, 'NormalPositionL', varInteger);
    rcNormalPosition.Top := ReadAppParam(AOwner, Form, 'NormalPositionT', varInteger);
    rcNormalPosition.Right := ReadAppParam(AOwner, Form, 'NormalPositionR', varInteger);
    rcNormalPosition.Bottom := ReadAppParam(AOwner, Form, 'NormalPositionB', varInteger);

    PPP := ReadAppParam(AOwner, Form, 'Pixels', varInteger);
    if Screen.PixelsPerInch = PPP then
    begin
      if not (BorderStyle in [bsSizeable, bsSizeToolWin]) then
        rcNormalPosition := Rect(rcNormalPosition.Left, rcNormalPosition.Top,
          rcNormalPosition.Left + Width, rcNormalPosition.Top + Height);
      if rcNormalPosition.Right > rcNormalPosition.Left then
      begin
        if (Position in [poScreenCenter, poDesktopCenter]) and
          not (csDesigning in ComponentState) then
        begin
          THackComponent(Form).SetDesigning(True);
          try
            Position := poDesigned;
          finally
            THackComponent(Form).SetDesigning(False);
          end;
        end;
        SetWindowPlacement(Handle, @Placement);
      end;
    end;
    // Form State
    WinState := wsNormal;
    ShowCmd := ReadAppParam(AOwner, Form, 'ShowCmd', varInteger);
    case ShowCmd of
      SW_SHOWNORMAL, SW_RESTORE, SW_SHOW:
        WinState := wsNormal;
      SW_MINIMIZE, SW_SHOWMINIMIZED, SW_SHOWMINNOACTIVE:
        WinState := wsMinimized;
      SW_MAXIMIZE:
        WinState := wsMaximized;
    end;
    if (WinState = wsMinimized) and ((Form = Application.MainForm) or (Application.MainForm = nil) ) then
    begin
      PostMessage(Application.Handle, WM_SYSCOMMAND, SC_MINIMIZE, 0);
      Exit;
    end;
    WindowState := WinState;
    Update;
  end;
end;

procedure TMStClientAppModule.ReadGridProperties(AOwner: TComponent; Grid: TDBGrid);
var
  I, I1: Integer;
  S: String;
  Clmns: TStringList;
  OnlyOneGrid: Boolean;
begin
  OnlyOneGrid := HasOnlyOneGrid(AOwner);
  with Grid do
    try
      Clmns := IObject(TStringList.Create).AObject as TStringList;
      for I := 0 to Pred(Columns.Count) do
      begin
        S := ReadAppParam(AOwner, Grid, PROP_COL + Columns[I].FieldName,
          varString, not OnlyOneGrid);
        I1 := Pos(',', S);
        if (I1 > 0) then
          Clmns.AddObject(PROP_COL + Columns[I].FieldName + '=' +
            Copy(S, 1, Pred(I1)),
            Pointer(StrToInt(Trim(Copy(S, Succ(I1), Length(S) - I1)))));
      end;
      for I := 0 to Pred(Columns.Count) do
      begin
        S := Clmns.Values[PROP_COL + Columns[I].FieldName];
        if S <> '' then
          if StrToInt(S) < Columns.Count then
          try
            Grid.Columns.Items[I].Index := StrToInt(S);
          except
          end;
      end;
      for I := 0 to Pred(Columns.Count) do
      begin
        I1 := Clmns.IndexOfName(PROP_COL + Columns[I].FieldName);
        if (I1 >= 0) and (I1 < Columns.Count) then
        try
          Grid.Columns.Items[I].Width := Integer(Clmns.Objects[I1]);
        except
        end;
      end;
    finally
    end;
end;

function TMStClientAppModule.ReadAppParam(AOwner: TComponent; Component: TComponent;
  const PropertyName: String; DataType: Integer;
  UseComponentName: Boolean = False): Variant;
var
  _Owner: TComponent;
  SectionName: string;
  Ini: TIniFile;
var
  IniFileName: string;
begin
  if not Assigned(AOwner) then
    _Owner := Component.Owner
  else
    _Owner := AOwner;
  if _Owner = nil then
    Exit
  else
  begin
    IniFileName := TPath.Finish(ExtractFilePath(ParamStr(0)), 'ms2.ini');
    if not FileExists(IniFileName) then
      IniFileName := 'ms2.ini';
    Ini := TIniFile.Create(IniFileName);
    if UseComponentName then
      SectionName := _Owner.Name + ': ' + Component.Name
    else
      SectionName := _Owner.Name + ': ' + Component.ClassName;
    case DataType of
      varSmallInt, varInteger, varError, varByte:
        Result:= Ini.ReadInteger(SectionName, PropertyName, 0);
      varSingle, varDouble, varCurrency:
        Result:= Ini.ReadFloat(SectionName, PropertyName, 0);
      varDate:
        Result:= Ini.ReadDateTime(SectionName, PropertyName, 0);
      varOleStr, varStrArg, varString:
        Result:= Ini.ReadString(SectionName, PropertyName, '');
      varBoolean:
        Result:= Ini.ReadBool(SectionName, PropertyName, False);
    end;
    Ini.Free
  end;
end;

procedure TMStClientAppModule.SaveAppParam(AOwner, Component: TComponent;
  const PropertyName: String; const Value: Variant;
      UseComponentName: Boolean = False);
var
  _Owner: TComponent;
  SectionName: String;
  Ini: TIniFile;
  IniFileName: string;
begin
  if Assigned(AOwner) then
    _Owner := AOwner
  else
    _Owner := Component.Owner;
  if _Owner = nil then
    Exit
  else
  begin
    IniFileName := TPath.Finish(ExtractFilePath(ParamStr(0)), 'ms2.ini');
    if not FileExists(IniFileName) then
      IniFileName := 'ms2.ini';
    Ini := TIniFile.Create(IniFileName);
    if UseComponentName then
      SectionName := _Owner.Name + ': ' + Component.Name
    else
      SectionName := _Owner.Name + ': ' + Component.ClassName;
    case VarType(Value) of
      varSmallInt, varInteger, varError, varByte, 19:
        Ini.WriteInteger(SectionName, PropertyName, Value);
      varSingle, varDouble, varCurrency:
        Ini.WriteFloat(SectionName, PropertyName, Value);
      varDate:
        Ini.WriteDateTime(SectionName, PropertyName, Value);
      varOleStr, varStrArg, varString:
        Ini.WriteString(SectionName, PropertyName, Value);
      varBoolean:
        Ini.WriteBool(SectionName, PropertyName, Value);
    else
      Ini.WriteString(SectionName, PropertyName, Value);
    end;
    Ini.Free;
  end;
end;

procedure TMStClientAppModule.PrepareEntityToPrintMode(Layer: TEzBaseLayer;
  Entity: TEzEntity; var EntList: TEzEntityList; var CanShow: Boolean);
var
  aLot: TmstLot;
  I: Integer;
begin
  if Entity.EntityID = idPage then
  begin
    if TEzPageEntity(Entity).Visible then
    begin
      TEzPageEntity(Entity).BrushTool.Color := clNone;
      TEzPageEntity(Entity).BrushTool.Pattern := 0;
    end
    else
    begin
      TEzPageEntity(Entity).BrushTool.Color := clSilver;
      TEzPageEntity(Entity).BrushTool.BackColor := clNone;
      TEzPageEntity(Entity).BrushTool.Pattern := 1;
    end;
    Exit;
  end;
  aLot := GetLotForEntity(Layer);
  if Assigned(aLot) then
  begin
    if not aLot.Visible then
    begin
      CanShow := ShowInvisibleLots;
      if CanShow then
        TEzOpenedEntity(Entity).PenTool.Color := clBtnFace;
    end
    else
    begin
      if mstPrintModule.Lot = aLot then
      begin
        if aLot.HasColor then
        begin
          if not Assigned(EntList) then
            EntList := TEzEntityList.Create;
          GetLotPolygons(aLot, EntList);
          if EntList.Count > 0 then
          begin
            for I := 0 to EntList.Count - 1 do
            begin
              if EntList[I] is TEzOpenedEntity then
                TEzOpenedEntity(EntList[I]).PenTool.Width := mstPrintModule.ReportLines.SelectedLine.MapWidth[mstPrintModule.ReportScale];
            end;
            Entity.FSkipPainting := True;
          end
          else
          if Entity is TEzOpenedEntity then
          begin
            TEzOpenedEntity(Entity).PenTool.Color := mstPrintModule.ReportLines.SelectedLine.Color;
            TEzOpenedEntity(Entity).PenTool.Width := mstPrintModule.ReportLines.SelectedLine.MapWidth[mstPrintModule.ReportScale];
          end;
        end
        else
        begin
          TEzOpenedEntity(Entity).PenTool.Color := mstPrintModule.ReportLines.SelectedLine.Color;
          TEzOpenedEntity(Entity).PenTool.Width := mstPrintModule.ReportLines.SelectedLine.MapWidth[mstPrintModule.ReportScale];
        end;
      end
      else
        case aLot.ObjectId of
        ID_LOT :
          begin
            TEzOpenedEntity(Entity).PenTool.Color := mstPrintModule.ReportLines.LotLine.Color;
            TEzOpenedEntity(Entity).PenTool.Width := mstPrintModule.ReportLines.LotLine.MapWidth[mstPrintModule.ReportScale];
          end;
        ID_ACTUAL_LOT1 :
          begin
            TEzOpenedEntity(Entity).PenTool.Color := mstPrintModule.ReportLines.ActualLine.Color;
            TEzOpenedEntity(Entity).PenTool.Width := mstPrintModule.ReportLines.ActualLine.MapWidth[mstPrintModule.ReportScale];
          end;
        ID_ANNULED_LOT1 :
          begin
            TEzOpenedEntity(Entity).PenTool.Color := mstPrintModule.ReportLines.AnnulledLine.Color;
            TEzOpenedEntity(Entity).PenTool.Width := mstPrintModule.ReportLines.AnnulledLine.MapWidth[mstPrintModule.ReportScale];
          end;
        end;
    end;
  end;
end;

procedure TMStClientAppModule.PrepareM500Bitmap(aRef: TEzPictureRef);
var
  M: TmstMap;
  Bmp: TBitmap;
  JPG: TJPEGImage;
begin
  if aRef.Stream = nil then
  begin
    M := FMaps.GetByMapImageId(aRef.Id);
    if (M <> nil) and (M.ImageExt in [imgBMP, imgJPEG]) then
    begin
      Bmp := TBitmap.Create;
      try
        case M.ImageExt of
          imgBMP:
            begin
              Bmp.PixelFormat := pf24bit;
              Bmp.LoadFromFile(M.FileName);
            end;
          imgJPEG:
            begin
              Bmp.PixelFormat := pf24bit;
              JPG := TJPEGImage.Create;
              try
                JPG.LoadFromFile(M.FileName);
                Bmp.Assign(JPG);
              finally
                FreeAndNil(JPG);
              end;
            end;
        end;
        aRef.Stream := TMemoryStream.Create;
        Bmp.SaveToStream(aRef.Stream);
      finally
        Bmp.Free;
      end;
    end;
  end;
end;

procedure TMStClientAppModule.InitRedLines;
begin
  FMapMngr.LoadRedLines(GIS.Layers.LayerByName(SL_RED_LINES2));
end;

initialization
  JclStartExceptionTracking;

end.
