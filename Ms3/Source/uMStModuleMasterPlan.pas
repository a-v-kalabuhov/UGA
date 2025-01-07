unit uMStModuleMasterPlan;

interface

uses
  SysUtils, Classes, Windows,
  IBCustomDataSet, IBUpdateSQL, DB, IBQuery, IBDatabase,
  EzBaseGIS, EzLib,
  uGC,
  uEzEntityCSConvert,
  uMStConsts,
  uMStClassesProjects, uMStClassesProjectsMP, uMStKernelGISUtils, uMStClassesMasterPlan, uMStKernelIBX,
  uMStModuleProjectImport, uMStModuleApp, uMStClassesProjectsEz,
  uMStFormMPBrowser;

type
  TmstMasterPlanModule = class(TDataModule)
    IBTransaction1: TIBTransaction;
    IBQuery1: TIBQuery;
    IBUpdateSQL1: TIBUpdateSQL;
  private
    FDrawBox: TEzBaseDrawBox;
    FImport: TmstProjectImportModule;
    FImportLayerName: string;
    procedure GetImportLayer(Sender: TObject; out Layer: TEzBaseLayer);
    procedure DoImportExecuted(Sender: TObject; Cancelled: Boolean; aProject: TmstProject);
    function DoCreateProject(): TmstProject;
    function DoCreatePrjReader(): IEzProjectReader;
    procedure DoGetProjectSaver(out Saver: IProjectSaver);
  private
    FItems: TmstMasterPlanList;
    FOrgs: TmstMPOrgs;
    FBrowserForm: TmstMPBrowserForm;
    /// <summary>
    /// Загружает данные по сводному плану в память    
    /// </summary>
    procedure LoadMasterPlanFromDB();
  public
    constructor Create(aOwner: TComponent); override;
    destructor Destroy; override;
    //
    procedure ImportDXF(aDrawBox: TEzBaseDrawBox);
    procedure DisplayNavigator(aDrawBox: TEzBaseDrawBox);
  end;

implementation

uses
  uMStClassesProjectsUtils;

type
  TmstMPObjectAdapter = class
  private
    FDataSet: TDataSet;
    function GetMP_Id: Integer;
    function GetAddress: string;
    function GetProjectName: string;
    function GetProjectNumber: string;
    function GetRequestNumber: string;
    function GetCustomer_Id: Integer;
    function GetExecutor_Id: Integer;
  public
    constructor Create(aDataSet: TDataSet);
    property MP_Id: Integer read GetMP_Id;
    property Address: string read GetAddress;
    property ProjectNumber: string read GetProjectNumber;
    property ProjectName: string read GetProjectName;
    property RequestNumber: string read GetRequestNumber;
    property Customer_Id: Integer read GetCustomer_Id;
    property Executor_Id: Integer read GetExecutor_Id;
  end;

{$R *.dfm}

{ TmstMasterPlanModule }

constructor TmstMasterPlanModule.Create;
begin
  inherited;
  FItems := TmstMasterPlanList.Create;
  FOrgs := TmstMPOrgs.Create;
end;

destructor TmstMasterPlanModule.Destroy;
begin
  FOrgs.Free;
  FItems.Free;
  inherited;
end;

procedure TmstMasterPlanModule.DisplayNavigator;
begin
  if FItems.Count = 0 then
    LoadMasterPlanFromDB();
  // если окно не открыто, то открываем и назначаем слой
  if FBrowserForm = nil then
    FBrowserForm := TmstMPBrowserForm.Create(Self);
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
end;

procedure TmstMasterPlanModule.DoGetProjectSaver(out Saver: IProjectSaver);
begin
  Saver := TmstMPProjectSaver.Create as IProjectSaver;
end;

procedure TmstMasterPlanModule.DoImportExecuted(Sender: TObject; Cancelled: Boolean; aProject: TmstProject);
var
  View: TEzRect;
  Saver: IProjectSaver;
begin
  try
    if not Cancelled then
    begin
      // если сохранили, то сохранеям в БД и показываем в слое проектов
      DoGetProjectSaver(Saver);
      Saver.Save(mstClientAppModule.MapMngr as IDb, aProject);
      //
      TProjectUtils.AddProjectToGIS(aProject);
      //mstClientAppModule.AddLoadedProjectMP(aProject.DatabaseId);
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

procedure TmstMasterPlanModule.ImportDXF;
begin
  FDrawBox := aDrawBox;
  FImport := TmstProjectImportModule.Create(Self);
  // выбрать файл
  if not FImport.BeginImport(aDrawBox,
                             GetImportLayer,
                             DoImportExecuted,
                             DoCreateProject,
                             DoCreatePrjReader
                             )
  then
    Exit;
  FImport.DisplayImportDialog();
end;

procedure TmstMasterPlanModule.LoadMasterPlanFromDB;
var
  MP: TmstMasterPlan;
  Adapter: TmstMPObjectAdapter;
//  MpId: Integer;
begin
  Adapter := TmstMPObjectAdapter.Create(IBQuery1);
  Adapter.Forget;
  // подготавливаем запрос
  IBQuery1.SQL.Text := '';//SQ_SELECT_ALL_MASTER_PLANS;
  // открываем его
  IBQuery1.Open;
  try
    // в запросе получаем список точек + семантика
    // загружаем данные в проекты
    while not IBQuery1.Eof do
    begin
      if Assigned(MP) and (MP.DatabaseId <> Adapter.MP_Id) then
      begin
        FItems.Add(MP);
        FreeAndNil(MP);
      end;
      if MP = nil then
      begin
        MP := TmstMasterPlan.Create;
        // загружаем поля
        MP.DatabaseId := Adapter.MP_Id;
        MP.Address := Adapter.Address;
        MP.ProjectNumber := Adapter.ProjectNumber;
        MP.ProjectName := Adapter.ProjectName;
        MP.RequestNumber := Adapter.RequestNumber;
        MP.Customer := FOrgs.GetById(Adapter.Customer_Id);
        MP.Executor := FOrgs.GetById(Adapter.Executor_Id);
      end;
      // загружаем объект

      //
      IBQuery1.Next;
    end;
  finally
    IBQuery1.Close;
  end;
end;

{ TmstMPObjectAdapter }

constructor TmstMPObjectAdapter.Create(aDataSet: TDataSet);
begin
  FDataSet := aDataSet;
end;

function TmstMPObjectAdapter.GetAddress: string;
begin
  Result := FDataSet.FieldByName(SF_ADDRESS).AsString;
end;

function TmstMPObjectAdapter.GetCustomer_Id: Integer;
begin
  Result := FDataSet.FieldByName(SF_CUSTOMER_ORGS_ID).AsInteger;
end;

function TmstMPObjectAdapter.GetExecutor_Id: Integer;
begin
  Result := FDataSet.FieldByName(SF_EXECUTOR_ORGS_ID).AsInteger;
end;

function TmstMPObjectAdapter.GetMP_Id: Integer;
begin
  Result := FDataSet.FieldByName(SF_ID).AsInteger;
end;

function TmstMPObjectAdapter.GetProjectName: string;
begin
  Result := FDataSet.FieldByName(SF_NAME).AsString;
end;

function TmstMPObjectAdapter.GetProjectNumber: string;
begin
  Result := FDataSet.FieldByName(SF_DOC_NUMBER).AsString;
end;

function TmstMPObjectAdapter.GetRequestNumber: string;
begin
  Result := FDataSet.FieldByName(SF_REQUEST_NUMBER).AsString;
end;

end.
