unit uMStDialogEditProjectMP;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ComCtrls, ExtCtrls, ActnList, EzBaseGIS, EzCtrls, DB, StdCtrls,
  RxMemDS,
  //
  EzEntities, EzSystem, EzCmdLine, EzBasicCtrls, EzLib, EzBase,
  //
  uMStKernelIBX, uMStConsts, uEzEntityCSConvert,
  //
  uMStClassesProjectsMP, Grids, DBGrids, DBCtrls, uDBGrid;

type
  TmstEditProjectMPDialog = class(TForm)
    PageControl1: TPageControl;
    tsSemantics: TTabSheet;
    tsMap: TTabSheet;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    edAddress: TEdit;
    edDocNum: TEdit;
    edDocDate: TEdit;
    edCustomer: TEdit;
    btnCustomer: TButton;
    edExecutor: TEdit;
    btnExecutor: TButton;
    chbCK36: TCheckBox;
    mdNav: TRxMemoryData;
    dsNav: TDataSource;
    EzGIS1: TEzGIS;
    ActionList1: TActionList;
    acSemCopy: TAction;
    acSemPaste: TAction;
    Label4: TLabel;
    edName: TEdit;
    cbStatusList: TComboBox;
    Label8: TLabel;
    Label9: TLabel;
    edDrawer: TEdit;
    btnDrawer: TButton;
    Label10: TLabel;
    edDrawDate: TEdit;
    MapDrawBox: TEzDrawBox;
    EzCmdLine1: TEzCmdLine;
    Label11: TLabel;
    edRequestNumber: TEdit;
    Panel2: TPanel;
    Splitter1: TSplitter;
    Panel3: TPanel;
    dbgNav: TkaDBGrid;
    Panel4: TPanel;
    Label5: TLabel;
    cbLayers: TComboBox;
    btnCancel: TButton;
    btnOK: TButton;
    Bevel1: TBevel;
    Label12: TLabel;
    edOwner: TEdit;
    btnOwner: TButton;
    mdNavNET_STATE_ID: TIntegerField;
    mdNavNET_STATE_NAME: TStringField;
    mdNavDISMANTLED: TBooleanField;
    mdNavARCHIVED: TBooleanField;
    mdNavAGREED: TBooleanField;
    mdNavROTANGLE: TIntegerField;
    mdNavUNDERGROUND: TBooleanField;
    mdNavDIAM: TIntegerField;
    mdNavPIPE_COUNT: TIntegerField;
    mdNavMATERIAL: TStringField;
    mdNavTOP: TStringField;
    mdNavBOTTOM: TStringField;
    mdNavFLOOR: TStringField;
    mdNavOBJ_ID: TStringField;
    mdNavENT_ID: TIntegerField;
    mdNavLAYER_NAME: TStringField;
    DBNavigator1: TDBNavigator;
    btnLocate: TButton;
    btnProperties: TButton;
    procedure btnCustomerClick(Sender: TObject);
    procedure btnExecutorClick(Sender: TObject);
    procedure btnDrawerClick(Sender: TObject);
    procedure btnOKClick(Sender: TObject);
    procedure btnOwnerClick(Sender: TObject);
    procedure mdNavCalcFields(DataSet: TDataSet);
    procedure EzGIS1AfterPaintEntity(Sender: TObject; Layer: TEzBaseLayer; Recno: Integer; Entity: TEzEntity;
      Grapher: TEzGrapher; Canvas: TCanvas; const Clip: TEzRect; DrawMode: TEzDrawMode);
    procedure edCustomerKeyPress(Sender: TObject; var Key: Char);
    procedure edExecutorKeyPress(Sender: TObject; var Key: Char);
    procedure edOwnerKeyPress(Sender: TObject; var Key: Char);
    procedure edDrawerKeyPress(Sender: TObject; var Key: Char);
    procedure dbgNavDblClick(Sender: TObject);
    procedure cbLayersChange(Sender: TObject);
    procedure btnLocateClick(Sender: TObject);
    procedure mdNavAfterEdit(DataSet: TDataSet);
    procedure mdNavAfterPost(DataSet: TDataSet);
    procedure dbgNavLogicalColumn(Sender: TObject; Column: TColumn; var IsLogical: Boolean);
    procedure dbgNavGetLogicalValue(Sender: TObject; Column: TColumn; var Value: Boolean);
    procedure FormShow(Sender: TObject);
    procedure dbgNavCellColors(Sender: TObject; Field: TField; var Background, FontColor: TColor; State: TGridDrawState;
      var FontStyle: TFontStyles);
    procedure btnPropertiesClick(Sender: TObject);
  private
    FOriginal: TmstProjectMP;
    FTempProject: TmstProjectMP;
    FLayersUpdating: Boolean;
    FNavUpdating: Boolean;
    procedure LoadProject();
    procedure ReadProject();
    //
    procedure LoadProjectSemantics();
    procedure LoadPrjStatus();
    procedure LoadLayerList();
    procedure FindFirstLineLayer(); 
    //
    procedure PrepareGIS();
    procedure BlocksToGIS();
    procedure ProjectToGIS();
    //
    procedure PrepareNavigator();
    procedure FillNavDataSet();
    procedure EditCurrentObjectSemantic();
    //
    function GetOrgName(OrgId: Integer): string;
    function SelectOrg(var Id: Integer; out OrgName: string): Boolean;
    //
    function CheckFormData(): Boolean;
    function GetProjectStatus(): Integer;
    function CheckField(aControl: TEdit; const aFieldName: string): Boolean;
    function CheckDateField(aControl: TEdit; const aFieldName: string): Boolean;
    procedure NeedToFillField(aControl: TEdit; const aFieldName: string);
    function GetCurrentMpObj(): TmstMPObject;
    procedure LoadDataFromNavDataSet(MpObj: TmstMPObject);
  private
    function GetCanSave: Boolean;
    procedure SetCanSave(const Value: Boolean);
  public
    function Execute(aPrj: TmstProjectMP): Boolean;
    //
    property CanSave: Boolean read GetCanSave write SetCanSave;
  end;

var
  mstEditProjectMPDialog: TmstEditProjectMPDialog;

implementation

{$R *.dfm}

uses
  uFileUtils, uCommonUtils,
  uMStClassesProjects, uMStClassesMPStatuses, uMStClassesProjectsUtils,
  uMStModuleApp,
  uMstDialogEditMPObjSemantics;

const
  SQL_GET_ORG_NAME = 'SELECT NAME FROM LICENSED_ORGS WHERE ID=:ID';

{ TmstEditProjectMPDialog }

procedure TmstEditProjectMPDialog.BlocksToGIS;
var
  I, J: Integer;
  Block: TmstProjectBlock;
  Symbol: TEzSymbol;
begin
  for I := 0 to FTempProject.Blocks.Count - 1 do
  begin
    Block := FTempProject.Blocks[I];
    J := Ez_Symbols.IndexOfName(Block.Name);
    if J < 0 then
    begin
      Block.EzData.Position := 0;
      Symbol := TEzSymbol.Create(Ez_Symbols);
      Symbol.LoadFromStream(Block.EzData);
      Symbol.Name := Block.Name;
      Block.SymbolId := Ez_Symbols.Add(Symbol);
    end;
  end;
end;

procedure TmstEditProjectMPDialog.btnCustomerClick(Sender: TObject);
var
  Id: Integer;
  aName: string;
begin
  Id := FTempProject.CustomerOrgId;
  if SelectOrg(Id, aName) then
  begin
    FTempProject.CustomerOrgId := Id;
    edCustomer.Text := aName;
    if FTempProject.ExecutorOrgId = 0 then
    begin
      FTempProject.ExecutorOrgId := Id;
      edExecutor.Text := aName;
    end;    
  end;
end;

procedure TmstEditProjectMPDialog.btnDrawerClick(Sender: TObject);
var
  Id: Integer;
  aName: string;
begin
  Id := FTempProject.DrawOrgId;
  if SelectOrg(Id, aName) then
  begin
    FTempProject.DrawOrgId := Id;
    edDrawer.Text := aName;
  end;
end;

procedure TmstEditProjectMPDialog.btnExecutorClick(Sender: TObject);
var
  Id: Integer;
  aName: string;
begin
  Id := FTempProject.ExecutorOrgId;
  if SelectOrg(Id, aName) then
  begin
    FTempProject.ExecutorOrgId := Id;
    edExecutor.Text := aName;
  end;
end;

procedure TmstEditProjectMPDialog.btnLocateClick(Sender: TObject);
var
  Layer: TEzBaseLayer;
  RecNo: Integer;
  ObjGuid: string;
  MpObj: TmstMPObject;
begin
  ObjGuid := mdNavOBJ_ID.AsString;
  MpObj := FTempProject.Objects.GetByGuid(ObjGuid);
  if Assigned(MpObj) then
  begin
    Layer := EzGIS1.Layers.LayerByName(MPObj.EzLayerName);
    if Assigned(Layer) then
    begin
      RecNo := mdNavENT_ID.AsInteger;
      MapDrawBox.SetEntityInViewEx(Layer.Name, Recno, True);
      MapDrawBox.BlinkEntityEx(Layer.Name, Recno);
    end;
  end;
end;

procedure TmstEditProjectMPDialog.btnOKClick(Sender: TObject);
begin
  if CheckFormData() then
    ModalResult := mrOK;
end;

procedure TmstEditProjectMPDialog.btnOwnerClick(Sender: TObject);
var
  Id: Integer;
  aName: string;
  I: Integer;
  Obj: TmstMPObject;
begin
  Id := FTempProject.OwnerOrgId;
  if SelectOrg(Id, aName) then
  begin
    FTempProject.OwnerOrgId := Id;
    edOwner.Text := aName;
    for I := 0 to FTempProject.Objects.Count - 1 do
    begin
      Obj := FTempProject.Objects[I];
      Obj.Owner := aName;
      Obj.OwnerOrgId := Id;
    end;
  end;
end;

procedure TmstEditProjectMPDialog.btnPropertiesClick(Sender: TObject);
begin
  EditCurrentObjectSemantic();
end;

procedure TmstEditProjectMPDialog.cbLayersChange(Sender: TObject);
begin
  if FLayersUpdating then
    Exit;
  FillNavDataSet();
end;

function TmstEditProjectMPDialog.CheckDateField(aControl: TEdit; const aFieldName: string): Boolean;
var
  S: string;
  TheDate: TDateTime;
begin
  Result := True;
  S := Trim(aControl.Text);
  if S <> '' then
  begin
    if not TryStrToDate(S, TheDate) then
    begin
      NeedToFillField(aControl, aFieldName);
      Result := False;
    end;
  end;
end;

function TmstEditProjectMPDialog.CheckField(aControl: TEdit; const aFieldName: string): Boolean;
begin
  Result := True;
  if Trim(aControl.Text) = '' then
  begin
    NeedToFillField(aControl, aFieldName);
    Result := False;
  end;
end;

function TmstEditProjectMPDialog.CheckFormData: Boolean;
begin
  Result := True;
  if not CheckField(edName, 'Ќаименование проекта')
     or
     not CheckField(edAddress, 'јдрес')
     or
     not CheckField(edDocNum, 'Ќомер проекта')
     or
     not CheckField(edRequestNumber, 'Ќомер за€вки')
     or
     not CheckDateField(edDocDate, 'ƒата проекта')
     or
     not CheckDateField(edDrawDate, 'ƒата нанесени€')
  then
  begin
    Result := False;
    Exit;
  end;
end;

procedure TmstEditProjectMPDialog.dbgNavCellColors(Sender: TObject; Field: TField; var Background, FontColor: TColor;
  State: TGridDrawState; var FontStyle: TFontStyles);
begin
  if mdNav.Active then
    if mdNavNET_STATE_ID.AsInteger < 1 then
      Background := $9999FF; // ошибка в статусе сети
      //8421600
      //$E6E6E6
      //$9999FF
end;

procedure TmstEditProjectMPDialog.dbgNavDblClick(Sender: TObject);
var
  Pt: TPoint;
  Cell: TGridCoord;
begin
  if mdNav.RecordCount = 0 then
    Exit;
  Pt := dbgNav.ScreenToClient(Mouse.CursorPos);
  Cell := dbgNav.MouseCoord(Pt.X, Pt.Y);
  if Cell.X > 0 then
  if Cell.Y > 0 then
  begin
    if Cell.X = dbgNav.Col then
    if Cell.Y = dbgNav.Row then
      EditCurrentObjectSemantic();
  end;
end;

procedure TmstEditProjectMPDialog.dbgNavGetLogicalValue(Sender: TObject; Column: TColumn; var Value: Boolean);
begin
  Value := Column.Field.AsBoolean;
end;

procedure TmstEditProjectMPDialog.dbgNavLogicalColumn(Sender: TObject; Column: TColumn; var IsLogical: Boolean);
begin
  IsLogical := Column.Field.DataType = ftBoolean;
end;

procedure TmstEditProjectMPDialog.edCustomerKeyPress(Sender: TObject; var Key: Char);
begin
  if Key = #13 then
    btnCustomer.Click;
end;

procedure TmstEditProjectMPDialog.edDrawerKeyPress(Sender: TObject; var Key: Char);
begin
  if Key = #13 then
    btnDrawer.Click;
end;

procedure TmstEditProjectMPDialog.edExecutorKeyPress(Sender: TObject; var Key: Char);
begin
  if Key = #13 then
    btnExecutor.Click;
end;

procedure TmstEditProjectMPDialog.EditCurrentObjectSemantic;
begin
  if not mdNav.Active then
    Exit;
  mdNav.Edit();
end;

procedure TmstEditProjectMPDialog.edOwnerKeyPress(Sender: TObject; var Key: Char);
begin
  if Key = #13 then
    btnOwner.Click;
end;

function TmstEditProjectMPDialog.Execute(aPrj: TmstProjectMP): Boolean;
begin
//  FSelectedLine := nil;
  FreeAndNil(FTempProject);
  FOriginal := aPrj;
  FTempProject := TmstProjectMP.Create;
  FTempProject.Assign(FOriginal);
  LoadProject();
  Result := ShowModal = mrOK;
  if Result then
  begin
    ReadProject();
    FOriginal.Assign(FTempProject);
  end;
end;

procedure TmstEditProjectMPDialog.EzGIS1AfterPaintEntity(Sender: TObject; Layer: TEzBaseLayer; Recno: Integer;
  Entity: TEzEntity; Grapher: TEzGrapher; Canvas: TCanvas; const Clip: TEzRect; DrawMode: TEzDrawMode);
begin
  if DrawMode = dmNormal then
  if mdNav.Active then
  begin
    if mdNavENT_ID.AsInteger = Entity.ID then
    begin
      Entity.DrawControlPoints(Grapher, Canvas, Grapher.CurrentParams.VisualWindow, False);
    end;
  end;
end;

function SortObjsByLayerAndEntId(Item1, Item2: Pointer): Integer;
var
  Obj1, Obj2: TmstMPObject;
begin
  Obj1 := TmstMPObject(Item1);
  Obj2 := TmstMPObject(Item2);
  Result := AnsiCompareStr(Obj1.EzLayerName, Obj1.EzLayerName);
  if Result = 0 then
    Result := Obj1.EzLayerRecno - Obj2.EzLayerRecno;
end;

procedure TmstEditProjectMPDialog.FillNavDataSet;
var
  I: Integer;
  Layer: TEzBaseLayer;
  MPObj: TmstMPObject;
  L: TmstProjectLayer;
begin
  if FLayersUpdating then
    Exit;
  if not mdNav.Active then
    mdNav.Open;
  FNavUpdating := True;
  try
    L := TmstProjectLayer(cbLayers.Items.Objects[cbLayers.ItemIndex]);
    FTempProject.Objects.Sort(SortObjsByLayerAndEntId);
    for I := 0 to FTempProject.Objects.Count - 1 do
    begin
      MPObj := FTempProject.Objects[I];
      if (L = nil) or (L.MPLayerId = MPObj.MPLayerId) then
      begin
        Layer := EzGIS1.Layers.LayerByName(MPObj.EzLayerName);
        if Assigned(Layer) then
        begin
          mdNav.Append;
          mdNav.FieldByName('OBJ_ID').AsString := MPObj.MPObjectGuid;
          mdNav.FieldByName('NET_STATE_ID').AsInteger := MPObj.Status;
          mdNav.FieldByName('DISMANTLED').AsBoolean := MPObj.Dismantled;
          mdNav.FieldByName('ARCHIVED').AsBoolean := MPObj.Archived;
          mdNav.FieldByName('AGREED').AsBoolean := MPObj.Confirmed;
          mdNav.FieldByName('ROTANGLE').AsInteger := MPObj.Rotation;
          mdNav.FieldByName('UNDERGROUND').AsBoolean := MPObj.Underground;
          mdNav.FieldByName('DIAM').AsInteger := MPObj.Diameter;
          mdNav.FieldByName('PIPE_COUNT').AsInteger := MPObj.PipeCount;
          mdNav.FieldByName('MATERIAL').AsString := MPObj.Material;
          mdNav.FieldByName('TOP').AsString := MPObj.Top;
          mdNav.FieldByName('BOTTOM').AsString := MPObj.Bottom;
          mdNav.FieldByName('FLOOR').AsString := MPObj.Floor;
          mdNav.FieldByName('ENT_ID').AsInteger := MPObj.EzLayerRecno;
          mdNav.FieldByName('LAYER_NAME').AsString := MPObj.EzLayerName;
          mdNav.Post;
        end;
      end;
    end;
  finally
    FNavUpdating := False;
  end;
  mdNav.First;
end;

procedure TmstEditProjectMPDialog.FindFirstLineLayer;
begin

end;

procedure TmstEditProjectMPDialog.FormShow(Sender: TObject);
begin
  PageControl1.ActivePageIndex := 0;
end;

function TmstEditProjectMPDialog.GetCanSave: Boolean;
begin
  Result := btnOK.Visible;
end;

function TmstEditProjectMPDialog.GetCurrentMpObj: TmstMPObject;
var
  ObjGuid: string;
begin
  ObjGuid := mdNavOBJ_ID.AsString;
  Result := FTempProject.Objects.GetByGuid(ObjGuid);
end;

function TmstEditProjectMPDialog.GetOrgName(OrgId: Integer): string;
var
  aDb: IDb;
  Conn: IIBXConnection;
  Ds: TDataSet;
begin
  if OrgId < 1 then
  begin
    Result := '';
    Exit;
  end;
  aDb := mstClientAppModule.MapMngr as IDb;
  Conn := aDb.GetConnection(cmReadOnly, dmKis);
  Ds := Conn.GetDataSet(SQL_GET_ORG_NAME);
  Conn.SetParam(Ds, SF_ID, OrgId);
  Ds.Open;
  if Ds.IsEmpty then
    Result := ''
  else
    Result := Ds.Fields[0].AsString;
  Ds.Close;
end;

function TmstEditProjectMPDialog.GetProjectStatus: Integer;
begin
  if cbStatusList.ItemIndex >= 0 then
    Result := Integer(cbStatusList.Items.Objects[cbStatusList.ItemIndex])
  else
    Result := -1;
end;

procedure TmstEditProjectMPDialog.LoadDataFromNavDataSet(MpObj: TmstMPObject);
begin
  MpObj.Dismantled := mdNavDISMANTLED.AsBoolean;
  MpObj.Archived := mdNavARCHIVED.AsBoolean;
  MpObj.Confirmed := mdNavAGREED.AsBoolean;
  MpObj.Rotation := mdNavROTANGLE.AsInteger;
  MpObj.Underground := mdNavUNDERGROUND.AsBoolean;
  MpObj.Diameter := mdNavDIAM.AsInteger;
  MpObj.PipeCount := mdNavPIPE_COUNT.AsInteger;
  MpObj.Material := mdNavMATERIAL.AsString;
  MpObj.Top := mdNavTOP.AsString;
  MpObj.Bottom := mdNavBOTTOM.AsString;
  MpObj.Floor := mdNavFLOOR.AsString;
end;

procedure TmstEditProjectMPDialog.LoadLayerList;
var
  I: Integer;
begin
  FLayersUpdating := True;
  try
    cbLayers.Items.Clear;
    if FTempProject.Layers.Count > 1 then
      cbLayers.AddItem('¬се слои', nil);
    for I := 0 to FTempProject.Layers.Count - 1 do
      cbLayers.AddItem(FTempProject.Layers[I].Name, FTempProject.Layers[I]);
    cbLayers.ItemIndex := 0;
  finally
    FLayersUpdating := False;
  end;
  FillNavDataSet();
end;

procedure TmstEditProjectMPDialog.LoadPrjStatus;
var
  I, J, K: Integer;
  S: string;
begin
  // грузим список статусов в комбо
  cbStatusList.Clear;
  if FTempProject.ObjState = mstDrawn then
    K := 4
  else
    K := 1;
  for I := TmstMPStatuses.MinId to TmstMPStatuses.MaxId do
  begin
    S := TmstMPStatuses.StatusName(I);
    J := cbStatusList.Items.AddObject(S, Pointer(I));
    if I = K then
      cbStatusList.ItemIndex := J;
  end;
end;

procedure TmstEditProjectMPDialog.LoadProject;
begin
  LoadProjectSemantics();
  // готовим √»—
  PrepareGIS();
  // готовим навигатор
//  PrepareNavigator();
  // загружаем список слоЄв в комбобокс
  LoadLayerList();
  // показываем первый слой
  FindFirstLineLayer();
end;

procedure TmstEditProjectMPDialog.LoadProjectSemantics;
begin
//    property DrawDate: TDateTime read FDrawDate write SetDrawDate;
//    property DrawOrgId: Integer read FDrawOrgId write SetDrawOrgId;
//    property Name: string read FName write SetName;
//    property RequestNumber: string read FRequestNumber write SetRequestNumber;
//    property Status: Integer read FStatus write SetStatus;

//    property Address: string read FAddress write SetAddress;
//    property DocNumber: string read FDocNumber write SetDocNumber;
//    property DocDate: TDateTime read FDocDate write SetDocDate;
//    property CustomerOrgId: Integer read FCustomerOrgId write SetCustomerOrgId;
//    property ExecutorOrgId: Integer read FExecutorOrgId write SetExecutorOrgId;
//    property Confirmed: Boolean read FConfirmed write SetConfirmed;
//    property ConfirmDate: TDateTime read FConfirmDate write SetConfirmDate;
//    property CK36: Boolean read FCK36 write SetCK36;
  LoadPrjStatus();
  edName.Text := FTempProject.Name;
  edAddress.Text := FTempProject.Address;
  edRequestNumber.Text := FTempProject.RequestNumber;
  edDocNum.Text := FTempProject.DocNumber;
  if FTempProject.DocDate = 0 then
    edDocDate.Text := ''
  else
    edDocDate.Text := DateToStr(FTempProject.DocDate);
  chbCK36.Checked := FTempProject.CK36;
  edCustomer.Text := GetOrgName(FTempProject.CustomerOrgId);
  edExecutor.Text := GetOrgName(FTempProject.ExecutorOrgId);
  edDrawer.Text := GetOrgName(FTempProject.DrawOrgId);
  edOwner.Text := GetOrgName(FTempProject.OwnerOrgId);
  if FTempProject.DrawDate = 0 then
    edDrawDate.Text := ''
  else
    edDrawDate.Text := DateToStr(FTempProject.DrawDate);
end;

procedure TmstEditProjectMPDialog.mdNavAfterEdit(DataSet: TDataSet);
var
  Frm: TmstEditMPObjSemanticsDialog;
begin
  if FNavUpdating then
    Exit;
  Frm := TmstEditMPObjSemanticsDialog.Create(Self);
  try
    Frm.Execute(FTempProject, mdNav);
  finally
    Frm.Free;
  end;
end;

procedure TmstEditProjectMPDialog.mdNavAfterPost(DataSet: TDataSet);
var
  MpObj: TmstMPObject;
begin
  if FNavUpdating then
    Exit;
  MpObj := GetCurrentMpObj();
  if Assigned(MpObj) then
  begin
    LoadDataFromNavDataSet(MpObj);
  end;
end;

procedure TmstEditProjectMPDialog.mdNavCalcFields(DataSet: TDataSet);
begin
  mdNavNET_STATE_NAME.AsString := TmstMPStatuses.StatusName(mdNavNET_STATE_ID.AsInteger);
end;

procedure TmstEditProjectMPDialog.NeedToFillField(aControl: TEdit; const aFieldName: string);
begin
  ShowMessage('«аполните поле "' + aFieldName + '"!');
  PageControl1.ActivePage := tsSemantics;
  aControl.SetFocus();
end;

procedure TmstEditProjectMPDialog.PrepareGIS;
var
  Path: string;
  GisFileName: string;
  I: Integer;
  Ticks: Cardinal;
begin
  // создаЄм новую папку
  // заполн€ем пол€ гис
  // сохран€ем в новый файл в этой папке
  Path := TPath.Combine(mstClientAppModule.SessionDir, GetUniqueString());
  ForceDirectories(Path);
  EzGIS1.LayersSubdir := Path;
  GisFileName := 'import';
  Ticks := GetTickCount();
  GisFileName := GisFileName + IntToStr(Ticks) + '.ezm';
  EzGIS1.CreateNew(TPath.Finish(Path, GisFileName));
  // добавл€ем слои
  for I := 0 to FTempProject.Layers.Count - 1 do
  begin
    EzGIS1.CreateLayer(FTempProject.Layers[I].Name, ltMemory);
  end;
  EzGIS1.Active := True;
  // добавл€ем блоки из проекта в символы
  BlocksToGIS();
  // загружаем проект в √»—
  ProjectToGIS();
  // обновлем картинку
  MapDrawBox.GIS.QuickUpdateExtension;
  MapDrawBox.ZoomToExtension;
end;

procedure TmstEditProjectMPDialog.PrepareNavigator;
begin
  // надо заполнить пол€ датасета - заполнено в редакторе
  // + состо€ние сети - int
  // + демонтированна€ - bool
  // + архивна€ -	bool
  // + согласована -	bool
  //  адрес - текст
  //  номер проекта	текст
  //  название проекта	текст
  //  номер за€вки	текст
  // + угол поворота объекта 	int
  // + подземные -	bool
  // + диаметр -	int
  // + количество проводов/труб -	int
  // + напр€жение -	int
  // + материал	- текст
  // + верх (труб, каналов, коллекторов, пакетов(блоков) при кабельной канализации, бесколодезных прокладок):	текст
  // + низ (каналов, коллекторов, пакетов(блоков) при кабельной канализации, бесколодезных прокладок)	текст
  // + дно колодцев, лотков в самотечных сет€х	текст
  //  заказчик	текст
  //  заказчик проектна€ организаци€	текст
  //  организаци€ котора€ нанесла	текст
  //  дата нанесени€	дата
  //  балансодержатель	текст
// ------------------------------------------
  //  надо добавить записи в датасет
  FillNavDataSet();
end;

procedure TmstEditProjectMPDialog.ProjectToGIS;
var
  I: Integer;
  Layer: TEzBaseLayer;
//  Ent: TEzEntity;
//  EntClass: TEzEntityClass;
//  EntityID: TEzEntityID;
  MPObj: TmstMPObject;
  Ext: TEzRect;
begin
  for I := 0 to FTempProject.Objects.Count - 1 do
  begin
    MPObj := FTempProject.Objects[I];
    Layer := EzGIS1.Layers.LayerByName(MPObj.EzLayerName);
    if Assigned(Layer) then
    begin
      TProjectUtils.AddMpObjToLayer(Layer, MPObj);
//      EntityID := TEzEntityID(MPObj.EzId);
//      EntClass := GetClassFromID(EntityID);
//      Ent := EntClass.Create(0, True);
//      try
//        MPObj.EzData.Position := 0;
//        Ent.LoadFromStream(MPObj.EzData);
//        if FTempProject.CK36 then
//          TEzCSConverter.EntityToVrn(Ent);
//        MPObj.EzLayerName := Layer.Name;
//        MPObj.EzLayerRecno := Layer.AddEntity(Ent);
//      finally
//        FreeAndNil(Ent);
//      end;
    end;
    //
    if MPObj <> nil then
    begin
      Layer := EzGIS1.Layers.LayerByName(MPObj.EzLayerName);
      if Assigned(Layer) then
      begin
        Ext := Layer.UpdateExtension;

      end;
    end;
  end;
end;

procedure TmstEditProjectMPDialog.ReadProject;
begin
  FTempProject.Status := GetProjectStatus(); 
  FTempProject.CK36 := chbCK36.Checked;
  FTempProject.Name := edName.Text;
  FTempProject.Address := edAddress.Text;
  FTempProject.DocNumber := edDocNum.Text;
  if Trim(edDocDate.Text) = '' then
    FTempProject.DocDate := 0
  else
    FTempProject.DocDate := StrToDate(Trim(edDocDate.Text));
  FTempProject.RequestNumber := edRequestNumber.Text;
  //
  if Trim(edDrawDate.Text) = '' then
    FTempProject.DrawDate := 0
  else
    FTempProject.DrawDate := StrToDate(Trim(edDrawDate.Text));
end;

function TmstEditProjectMPDialog.SelectOrg(var Id: Integer; out OrgName: string): Boolean;
begin
  Result := mstClientAppModule.MapMngr.SelectOrg(Id, OrgName);
end;

procedure TmstEditProjectMPDialog.SetCanSave(const Value: Boolean);
begin
  btnOK.Visible := Value;
end;

end.
