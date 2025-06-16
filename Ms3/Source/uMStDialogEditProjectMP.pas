unit uMStDialogEditProjectMP;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ComCtrls, ExtCtrls, ActnList, EzBaseGIS, EzCtrls, DB, StdCtrls, Grids,
  DBGrids, DBCtrls, ImgList, ToolWin,
  RxMemDS,
  //
  EzEntities, EzSystem, EzCmdLine, EzBasicCtrls, EzLib, EzBase,
  //
  uDBGrid, uMStGISEzActions,
  uMStKernelIBX, uMStConsts, uEzEntityCSConvert,
  //
  uMStClassesProjectsMP, uMStModuleDefaultActions, uMStClassesMPPressures, uMStClassesMPVoltages;

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
    lXY: TLabel;
    ToolBar1: TToolBar;
    ToolButton1: TToolButton;
    ToolButton2: TToolButton;
    ToolButton3: TToolButton;
    ToolButton4: TToolButton;
    ToolButton5: TToolButton;
    ToolButton6: TToolButton;
    ToolButton7: TToolButton;
    ToolButton8: TToolButton;
    ToolButton9: TToolButton;
    Label30: TLabel;
    edConfirmDate: TEdit;
    chbConfirmed: TCheckBox;
    mdNavSEWER: TBooleanField;
    mdNavPRESSURE_IDX: TIntegerField;
    mdNavPRESSURE_TXT: TStringField;
    mdNavVOLTAGE_IDX: TSmallintField;
    mdNavVOLTAGE_TXT: TStringField;
    btnFill: TButton;
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
    procedure MapDrawBoxMouseDown2D(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer; const WX,
      WY: Double);
    procedure MapDrawBoxMouseWheel(Sender: TObject; Shift: TShiftState; WheelDelta: Integer; MousePos: TPoint;
      var Handled: Boolean);
    procedure MapDrawBoxMouseMove2D(Sender: TObject; Shift: TShiftState; X, Y: Integer; const WX, WY: Double);
    procedure FormCreate(Sender: TObject);
    procedure mdNavAfterScroll(DataSet: TDataSet);
    procedure MapDrawBoxAfterSelect(Sender: TObject; Layer: TEzBaseLayer; RecNo: Integer);
    procedure btnFillClick(Sender: TObject);
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
    //
    procedure PrepareGIS();
    procedure BlocksToGIS();
    procedure ProjectToGIS();
    //
    procedure FillNavDataSet();
    procedure EditCurrentObjectSemantic();
    procedure FillAllObjectsSemantic();
    //
    function GetOrgName(OrgId: Integer): string;
    function SelectOrg(var Id: Integer; out OrgName: string): Boolean;
    //
    function CheckFormData(): Boolean;
    function GetProjectStatus(): Integer;
    function CheckField(aControl: TEdit; const aFieldName: string): Boolean;
    function CheckDateField(aControl: TEdit; const aFieldName: string; const AllowEmpty: Boolean): Boolean;
    procedure NeedToFillField(aControl: TEdit; const aFieldName: string);
    function GetCurrentMpObj(): TmstMPObject;
    procedure LoadDataFromNavDataSet(MpObj: TmstMPObject);
  private
    FActionsModule: TmstDefaultActionsModule;
    procedure ConnectDefaultActions;
    procedure DoSwitchScrollCommand();
    procedure DoRunAutoScroll(Shift: TShiftState; const X, Y: Integer; const WX, WY: Double);
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

procedure TmstEditProjectMPDialog.btnFillClick(Sender: TObject);
begin
  FillAllObjectsSemantic();
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

function TmstEditProjectMPDialog.CheckDateField(aControl: TEdit; const aFieldName: string; const AllowEmpty: Boolean): Boolean;
var
  S: string;
  TheDate: TDateTime;
begin
  Result := True;
  S := Trim(aControl.Text);
  if (S = '') and not AllowEmpty then
  begin
    NeedToFillField(aControl, aFieldName);
    Result := False;
    Exit;
  end;
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
  if not CheckField(edName, 'Наименование проекта')
     or
     not CheckField(edAddress, 'Адрес')
     or
     not CheckField(edDocNum, 'Номер проекта')
     or
     not CheckField(edRequestNumber, 'Номер заявки')
     or
     not CheckDateField(edDocDate, 'Дата проекта', True)
     or
     not CheckDateField(edDrawDate, 'Дата нанесения', True)
     or
     not CheckDateField(edConfirmDate, 'Дата согласования', True)
  then
  begin
    Result := False;
    Exit;
  end;
end;

procedure TmstEditProjectMPDialog.ConnectDefaultActions;
begin
  FActionsModule.CmdLine := EzCmdLine1;
  FActionsModule.GIS := EzGIS1;
  ToolBar1.Images := FActionsModule.ZoomImageList;
  ToolButton1.Action := FActionsModule.acZoomIn;
  ToolButton2.Action := FActionsModule.acZoomOut;
  ToolButton3.Action := FActionsModule.acZoomRect;
  ToolButton4.Action := FActionsModule.acZoomPrev;
  ToolButton5.Action := FActionsModule.acZoomAll;
  ToolButton7.Action := FActionsModule.acZoomScroll;
  ToolButton8.Action := FActionsModule.acZoomClearAction;
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

procedure TmstEditProjectMPDialog.DoRunAutoScroll(Shift: TShiftState; const X, Y: Integer; const WX, WY: Double);
var
  ScrollAction: TmstAutoHandScrollAction;
begin
  ScrollAction := TmstAutoHandScrollAction.CreateAction(EzCmdLine1);
  ScrollAction.OnMouseDown(Self, mbLeft, Shift, X, Y, WX, WY);
  EzCmdLine1.Push(TmstAutoHandScrollAction.CreateAction(EzCmdLine1), False, 'AUTOSCROLL', '');
end;

procedure TmstEditProjectMPDialog.DoSwitchScrollCommand;
var
  ActId: string;
begin
  ActId := EzCmdLine1.CurrentAction.ActionID;
  if (ActId <> 'SCROLL') and (ActId <> 'CALC') then
  begin
    EzCmdLine1.Clear;
    EzCmdLine1.DoCommand('SCROLL', 'SCROLL');
  end
  else
  begin
    EzCmdLine1.Clear;
    MapDrawBox.Cursor := crDefault;
  end;
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
  lXY.Caption := '   ';
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
//  if DrawMode = dmNormal then
  if mdNav.Active then
  begin
    if mdNavENT_ID.AsInteger = Recno then
    if mdNavLAYER_NAME.AsString = Layer.Name then
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

procedure TmstEditProjectMPDialog.FillAllObjectsSemantic;
var
  TmpDs: TRxMemoryData;
  MpObj: TmstMPObject;
  Rn: Integer;
begin
  if not mdNav.Active then
    Exit;
  mdNav.Edit();
  TmpDs := TRxMemoryData.Create(Self);
  FNavUpdating := True;
  try
    Rn := mdNav.RecNo;
    TmpDs.LoadFromDataSet(mdNav, 0, lmCopy);
    TmpDs.RecNo := Rn;
    mdNav.First;
    while not mdNav.Eof do
    begin
      mdNav.Edit;
      mdNavDISMANTLED.AsBoolean := TmpDs.FieldByName(SF_DISMANTLED).AsBoolean;
      mdNavARCHIVED.AsBoolean := TmpDs.FieldByName(SF_ARCHIVED).AsBoolean;
      //mdNavAGREED.AsBoolean := TmpDs.FieldByName(SF_AGREED).AsBoolean;
      mdNavROTANGLE.AsInteger := TmpDs.FieldByName(SF_ROTANGLE).AsInteger;
      mdNavUNDERGROUND.AsBoolean := TmpDs.FieldByName(SF_UNDERGROUND).AsBoolean;
      mdNavDIAM.AsInteger := TmpDs.FieldByName(SF_DIAM).AsInteger;
      mdNavPIPE_COUNT.AsInteger := TmpDs.FieldByName(SF_PIPE_COUNT).AsInteger;
      mdNavMATERIAL.AsString := TmpDs.FieldByName(SF_MATERIAL).AsString;
      mdNavTOP.AsString := TmpDs.FieldByName(SF_TOP).AsString;
      mdNavBOTTOM.AsString := TmpDs.FieldByName(SF_BOTTOM).AsString;
      mdNavFLOOR.AsString := TmpDs.FieldByName(SF_FLOOR).AsString;
      mdNavPRESSURE_IDX.AsInteger := TmpDs.FieldByName(SF_PRESSURE_IDX).AsInteger;
      mdNavVOLTAGE_IDX.AsInteger := TmpDs.FieldByName(SF_VOLTAGE_IDX).AsInteger;
      mdNavSEWER.AsBoolean := TmpDs.FieldByName(SF_SEWER).AsBoolean;
      mdNav.Post;
      MpObj := GetCurrentMpObj();
      if Assigned(MpObj) then
      begin
        LoadDataFromNavDataSet(MpObj);
      end;
      //
      mdNav.Next;
    end;
    mdNav.RecNo := Rn;
  finally
    FNavUpdating := False;
    TmpDs.Free;
  end;
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
  if mdNav.Active then
    mdNav.Close;
  mdNav.Open;
  FNavUpdating := True;
  try
    L := TmstProjectLayer(cbLayers.Items.Objects[cbLayers.ItemIndex]);
    FTempProject.Objects.Sort(SortObjsByLayerAndEntId);
    for I := 0 to FTempProject.Objects.Count - 1 do
    begin
      MPObj := FTempProject.Objects[I];
      if (L = nil) or (L.DatabaseId = MPObj.MpClassId) then
      begin
        Layer := EzGIS1.Layers.LayerByName(MPObj.EzLayerName);
        if Assigned(Layer) then
        begin
          mdNav.Append;
          mdNav.FieldByName(SF_OBJ_ID).AsString := MPObj.MPObjectGuid;
          mdNav.FieldByName(SF_NET_STATE_ID).AsInteger := MPObj.Status;
          mdNav.FieldByName(SF_DISMANTLED).AsBoolean := MPObj.Dismantled;
          mdNav.FieldByName(SF_ARCHIVED).AsBoolean := MPObj.Archived;
//          mdNav.FieldByName(SF_AGREED).AsBoolean := MPObj.Confirmed;
          mdNav.FieldByName(SF_ROTANGLE).AsInteger := MPObj.Rotation;
          mdNav.FieldByName(SF_UNDERGROUND).AsBoolean := MPObj.Underground;
          mdNav.FieldByName(SF_DIAM).AsInteger := MPObj.Diameter;
          mdNav.FieldByName(SF_PIPE_COUNT).AsInteger := MPObj.PipeCount;
          mdNav.FieldByName(SF_MATERIAL).AsString := MPObj.Material;
          mdNav.FieldByName(SF_TOP).AsString := MPObj.Top;
          mdNav.FieldByName(SF_BOTTOM).AsString := MPObj.Bottom;
          mdNav.FieldByName(SF_FLOOR).AsString := MPObj.Floor;
          mdNav.FieldByName(SF_ENT_ID).AsInteger := MPObj.EzLayerRecno;
          mdNav.FieldByName(SF_LAYER_NAME).AsString := MPObj.EzLayerName;
          mdNav.FieldByName(SF_PRESSURE_IDX).AsInteger := MPObj.PressureIndex;
          mdNav.FieldByName(SF_VOLTAGE_IDX).AsInteger := MPObj.VoltageIndex;
          mdNav.FieldByName(SF_SEWER).AsBoolean := MPObj.Sewer;
          mdNav.Post;
        end;
      end;
    end;
  finally
    FNavUpdating := False;
  end;
  mdNav.First;
end;

procedure TmstEditProjectMPDialog.FormCreate(Sender: TObject);
begin
  FActionsModule := TmstDefaultActionsModule.Create(Self);
  ConnectDefaultActions;
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
  //MpObj.Confirmed := mdNavAGREED.AsBoolean;
  MpObj.Rotation := mdNavROTANGLE.AsInteger;
  MpObj.Underground := mdNavUNDERGROUND.AsBoolean;
  MpObj.Diameter := mdNavDIAM.AsInteger;
  MpObj.PipeCount := mdNavPIPE_COUNT.AsInteger;
  MpObj.Material := mdNavMATERIAL.AsString;
  MpObj.Top := mdNavTOP.AsString;
  MpObj.Bottom := mdNavBOTTOM.AsString;
  MpObj.Floor := mdNavFLOOR.AsString;
  MpObj.PressureIndex := mdNavPRESSURE_IDX.AsInteger;
  MpObj.VoltageIndex := mdNavVOLTAGE_IDX.AsInteger;
  MpObj.Sewer := mdNavSEWER.AsBoolean;
end;

procedure TmstEditProjectMPDialog.LoadLayerList;
var
  I: Integer;
begin
  FLayersUpdating := True;
  try
    cbLayers.Items.Clear;
    if FTempProject.Layers.Count > 1 then
      cbLayers.AddItem('Все слои', nil);
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
  // готовим ГИС
  PrepareGIS();
  // готовим навигатор
//  PrepareNavigator();
  // загружаем список слоёв в комбобокс
  LoadLayerList();
end;

procedure TmstEditProjectMPDialog.LoadProjectSemantics;
begin
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
  if FTempProject.ConfirmDate = 0 then
    edConfirmDate.Text := ''
  else
    edConfirmDate.Text := DateToStr(FTempProject.ConfirmDate);
  chbConfirmed.Checked := FTempProject.Confirmed;
end;

procedure TmstEditProjectMPDialog.MapDrawBoxAfterSelect(Sender: TObject; Layer: TEzBaseLayer; RecNo: Integer);
var
  Bkm: TBookmark;
begin
  if not mdNav.Active then
    Exit;
  Bkm := mdNav.GetBookmark();
  mdNav.DisableControls;
  try
    if not mdNav.Locate('ENT_ID;LAYER_NAME',VarArrayOf([RecNo, Layer.Name]), []) then
    begin
      mdNav.GotoBookmark(Bkm);
      Exit;
    end;
  finally
    mdNav.EnableControls;
  end;
end;

procedure TmstEditProjectMPDialog.MapDrawBoxMouseDown2D(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X,
  Y: Integer; const WX, WY: Double);
begin
  if (Button = mbMiddle) then
  begin
    DoSwitchScrollCommand();
  end;
end;

procedure TmstEditProjectMPDialog.MapDrawBoxMouseMove2D(Sender: TObject; Shift: TShiftState; X, Y: Integer; const WX,
  WY: Double);
begin
  lXY.Caption := 'X: ' + FloatToStrF(WY, ffFixed, 10, 2) + '; Y: ' + FloatToStrF(WX, ffFixed, 10, 2);
end;

procedure TmstEditProjectMPDialog.MapDrawBoxMouseWheel(Sender: TObject; Shift: TShiftState; WheelDelta: Integer;
  MousePos: TPoint; var Handled: Boolean);
begin
  Handled := True;
  if WheelDelta > 0 then
    MapDrawBox.ZoomIn(90)
  else
    MapDrawBox.ZoomOut(90);
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

procedure TmstEditProjectMPDialog.mdNavAfterScroll(DataSet: TDataSet);
begin
  MapDrawBox.RegenDrawing;
end;

procedure TmstEditProjectMPDialog.mdNavCalcFields(DataSet: TDataSet);
begin
  mdNavNET_STATE_NAME.AsString := TmstMPStatuses.StatusName(mdNavNET_STATE_ID.AsInteger);
  mdNavPRESSURE_TXT.AsString := TmstMPPressures.StatusName(mdNavPRESSURE_IDX.AsInteger);
  mdNavVOLTAGE_TXT.AsString := TmstMPVoltages.StatusName(mdNavVOLTAGE_IDX.AsInteger);
end;

procedure TmstEditProjectMPDialog.NeedToFillField(aControl: TEdit; const aFieldName: string);
begin
  ShowMessage('Заполните поле "' + aFieldName + '"!');
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
  // создаём новую папку
  // заполняем поля гис
  // сохраняем в новый файл в этой папке
  Path := TPath.Combine(mstClientAppModule.AppSettings.SessionDir, GetUniqueString());
  ForceDirectories(Path);
  EzGIS1.LayersSubdir := Path;
  GisFileName := 'import';
  Ticks := GetTickCount();
  GisFileName := GisFileName + IntToStr(Ticks) + '.ezm';
  EzGIS1.CreateNew(TPath.Finish(Path, GisFileName));
  // добавляем слои
  for I := 0 to FTempProject.Layers.Count - 1 do
  begin
    EzGIS1.CreateLayer(FTempProject.Layers[I].Name, ltMemory);
  end;
  EzGIS1.Active := True;
  // добавляем блоки из проекта в символы
  BlocksToGIS();
  // загружаем проект в ГИС
  ProjectToGIS();
  // обновлем картинку
  MapDrawBox.GIS.QuickUpdateExtension;
  MapDrawBox.ZoomToExtension;
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
        Ext := Layer.UpdateExtension;
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
  //
  if Trim(edConfirmDate.Text) = '' then
    FTempProject.ConfirmDate := 0
  else
    FTempProject.ConfirmDate := StrToDate(Trim(edConfirmDate.Text));
  FTempProject.Confirmed := chbConfirmed.Checked;
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
