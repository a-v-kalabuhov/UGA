unit uMStDialogEditProject;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms, Dialogs, ExtCtrls, Buttons,
  uMStClassesProjects, StdCtrls, Mask, JvExMask, EzBaseGIS, EzBasicCtrls, DB, Grids, DBGrids,
  RxMemDS,
  EzCmdLine, EzCtrls, EzSystem, EzEntities, EzLib, EzBase,
  uDBGrid,
  uFileUtils, uCommonUtils, uCK36,
  uMStModuleApp, uMStKernelIBX, uMStConsts, ActnList;

type
  TmstEditProjectDialog = class(TForm)
    Label1: TLabel;
    edAddress: TEdit;
    Label2: TLabel;
    edDocNum: TEdit;
    Label3: TLabel;
    edDate: TEdit;
    EzDrawBox1: TEzDrawBox;
    Label4: TLabel;
    cbLayers: TComboBox;
    ListBoxLines: TListBox;
    grdCoords: TkaDBGrid;
    dsCoords: TRxMemoryData;
    DataSource1: TDataSource;
    EzGIS1: TEzGIS;
    EzCmdLine1: TEzCmdLine;
    btnOK: TButton;
    btnCancel: TButton;
    chbConfirmed: TCheckBox;
    Label5: TLabel;
    edConfirmDate: TEdit;
    Label6: TLabel;
    edCustomer: TEdit;
    btnCustomer: TButton;
    Label7: TLabel;
    edExecutor: TEdit;
    btnExecutor: TButton;
    Bevel1: TBevel;
    SpeedButton1: TSpeedButton;
    BtnHand: TSpeedButton;
    ZoomWBtn: TSpeedButton;
    ZoomIn: TSpeedButton;
    ZoomOut: TSpeedButton;
    ZoomAll: TSpeedButton;
    lCoords: TLabel;
    chbCK36: TCheckBox;
    dsCoordsX: TFloatField;
    dsCoordsY: TFloatField;
    dsCoordsZ: TFloatField;
    dsCoordsDelta: TFloatField;
    gbObjectSemantic: TGroupBox;
    lSemDiam: TLabel;
    edDiam: TEdit;
    lSemVoltage: TLabel;
    edVoltage: TEdit;
    lHDiff: TLabel;
    lSemInfo: TLabel;
    mInfo: TMemo;
    btnSemCopy: TButton;
    btnSemPaste: TButton;
    ActionList1: TActionList;
    acSemCopy: TAction;
    acSemPaste: TAction;
    procedure grdCoordsExit(Sender: TObject);
    procedure cbLayersChange(Sender: TObject);
    procedure ListBoxLinesClick(Sender: TObject);
    procedure EzDrawBox1MouseMove(Sender: TObject; Shift: TShiftState; X, Y: Integer);
    procedure SpeedButton1Click(Sender: TObject);
    procedure BtnHandClick(Sender: TObject);
    procedure ZoomWBtnClick(Sender: TObject);
    procedure ZoomInClick(Sender: TObject);
    procedure ZoomOutClick(Sender: TObject);
    procedure ZoomAllClick(Sender: TObject);
    procedure dsCoordsAfterPost(DataSet: TDataSet);
    procedure ListBoxLinesDblClick(Sender: TObject);
    procedure chbConfirmedClick(Sender: TObject);
    procedure btnCustomerClick(Sender: TObject);
    procedure btnExecutorClick(Sender: TObject);
    procedure btnOKClick(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure EzDrawBox1AfterSelect(Sender: TObject; Layer: TEzBaseLayer; RecNo: Integer);
    procedure dsCoordsBeforeInsert(DataSet: TDataSet);
    procedure dsCoordsDeltaGetText(Sender: TField; var Text: string; DisplayText: Boolean);
    procedure edCustomerKeyPress(Sender: TObject; var Key: Char);
    procedure edExecutorKeyPress(Sender: TObject; var Key: Char);
    procedure EzGIS1BeforePaintEntity(Sender: TObject; Layer: TEzBaseLayer; Recno: Integer; Entity: TEzEntity;
      Grapher: TEzGrapher; Canvas: TCanvas; const Clip: TEzRect; DrawMode: TEzDrawMode; var CanShow: Boolean;
      var EntList: TEzEntityList; var AutoFree: Boolean);
    procedure DataSource1UpdateData(Sender: TObject);
    procedure dsCoordsAfterScroll(DataSet: TDataSet);
    procedure grdCoordsKeyPress(Sender: TObject; var Key: Char);
    procedure acSemCopyUpdate(Sender: TObject);
    procedure acSemCopyExecute(Sender: TObject);
    procedure acSemPasteExecute(Sender: TObject);
    procedure acSemPasteUpdate(Sender: TObject);
    procedure acSemPasteHint(var HintStr: string; var CanShow: Boolean);
  private
    class var FSemanticBuffer: record
      Diam: String;
      Voltage: String;
      Info: String;
    end;
  private
    FTempProject: TmstProject;
    FOriginal: TmstProject;
    FSelectedLine: TmstProjectLine;
    FCanAddCoords: Boolean;
    FMapSizeUpdated: Boolean;
    procedure LoadProject();
    procedure ReadProject();
    procedure PrepareGIS();
    procedure BlocksToGIS();
    procedure LinesToGIS();
    procedure PlacesToGIS();
    procedure LoadLayerList();
    procedure LoadLinesToListBox(Layer: TmstProjectLayer);
    procedure LoadLineToGrid(Line: TmstProjectLine);
    procedure LoadLineInfo(Line: TmstProjectLine);
    function SelectOrg(var Id: Integer; out OrgName: string): Boolean;
    procedure SaveSelectedLine();
    procedure ChangeSelectedLine();
    function GetOrgName(OrgId: Integer): string;
    procedure ShowZDelta();
    procedure FindFirstLineLayer();
    procedure SetCanSave(const Value: Boolean);
    function GetCanSave: Boolean;
  public
    function Execute(aProject: TmstProject): Boolean;
    //
    property CanSave: Boolean read GetCanSave write SetCanSave;
  end;

var
  mstEditProjectDialog: TmstEditProjectDialog;

implementation

{$R *.dfm}

const
  SQL_GET_ORG_NAME = 'SELECT NAME FROM LICENSED_ORGS WHERE ID=:ID';

{ TmstEditProjectDialog }

procedure TmstEditProjectDialog.acSemCopyExecute(Sender: TObject);
begin
  FSemanticBuffer.Diam := edDiam.Text;
  FSemanticBuffer.Voltage := edVoltage.Text;
  FSemanticBuffer.Info := mInfo.Text;
end;

procedure TmstEditProjectDialog.acSemCopyUpdate(Sender: TObject);
begin
  acSemCopy.Enabled := (edDiam.Text <> '') or (edVoltage.Text <> '') or (mInfo.Lines.DelimitedText <> '');
end;

procedure TmstEditProjectDialog.acSemPasteExecute(Sender: TObject);
begin
  edDiam.Text := FSemanticBuffer.Diam;
  edVoltage.Text := FSemanticBuffer.Voltage;
  mInfo.Text := FSemanticBuffer.Info;
end;

procedure TmstEditProjectDialog.acSemPasteHint(var HintStr: string; var CanShow: Boolean);
var
  S: string;
begin
  S := 'Применить к объекту семантику из буфера';
  if
      (FSemanticBuffer.Diam <> '') or
      (FSemanticBuffer.Voltage <> '') or
      (FSemanticBuffer.Info <> '')
  then
  begin
    S := S + sLineBreak + '=====' + sLineBreak;
    S := S + 'Диаметр: ' + FSemanticBuffer.Diam + sLineBreak;
    S := S + 'Напряжение: ' + FSemanticBuffer.Voltage + sLineBreak;
    S := S + 'Инфо: ' + sLineBreak + FSemanticBuffer.Info;
  end;
  HintStr := S;
end;

procedure TmstEditProjectDialog.acSemPasteUpdate(Sender: TObject);
begin
  acSemPaste.Enabled := not edDiam.ReadOnly and edDiam.Enabled and edDiam.Visible and
    (
      (FSemanticBuffer.Diam <> '') or
      (FSemanticBuffer.Voltage <> '') or
      (FSemanticBuffer.Info <> '')
    );
end;

procedure TmstEditProjectDialog.BlocksToGIS;
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

procedure TmstEditProjectDialog.btnCustomerClick(Sender: TObject);
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

procedure TmstEditProjectDialog.BtnHandClick(Sender: TObject);
begin
  EzCmdLine1.Clear;
  EzCmdLine1.DoCommand('SCROLL','');
end;

procedure TmstEditProjectDialog.btnOKClick(Sender: TObject);
var
  D1: TDateTime;
begin
  SaveSelectedLine();
  if Trim(edAddress.Text) = '' then
  begin
    edAddress.SetFocus;
    ShowMessage('Укажите адрес!');
    Exit;
  end;
  if Trim(edCustomer.Text) = '' then
  begin
//    edCustomer.SetFocus;
    ShowMessage('Укажите заказчика!');
    Exit;
  end;
  if Trim(edExecutor.Text) = '' then
  begin
//    edExecutor.SetFocus;
    ShowMessage('Укажите исполнителя!');
    Exit;
  end;
  if Trim(edDate.Text) <> '' then
  begin
    if not TryStrToDate(Trim(edDate.Text), D1) then
    begin
      edDate.SetFocus;
      ShowMessage('Дата заполнена неверно!');
      Exit;
    end;
  end;
  ModalResult := mrOK;
end;

procedure TmstEditProjectDialog.btnExecutorClick(Sender: TObject);
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

procedure TmstEditProjectDialog.cbLayersChange(Sender: TObject);
var
  L: TmstProjectLayer;
begin
  ListBoxLines.Clear;
  SaveSelectedLine();
  ChangeSelectedLine();
  //
  dsCoords.Active := False;
  if cbLayers.ItemIndex < 0 then
    L := nil
  else
    L := cbLayers.Items.Objects[cbLayers.ItemIndex] as TmstProjectLayer;
  LoadLinesToListBox(L);
  if L.IsLineLayer then  
    ZoomAllClick(nil)
  else
  begin
    EzDrawBox1.ZoomToExtension;
  end;
end;

procedure TmstEditProjectDialog.ChangeSelectedLine;
begin
  if ListBoxLines.ItemIndex >= 0 then
  begin
    FSelectedLine := ListBoxLines.Items.Objects[ListBoxLines.ItemIndex] as TmstProjectLine;
  end
  else
    FSelectedLine := nil;
  LoadLineToGrid(FSelectedLine);
  LoadLineInfo(FSelectedLine);
end;

procedure TmstEditProjectDialog.chbConfirmedClick(Sender: TObject);
begin
  if chbConfirmed.Checked then
    edConfirmDate.Text := DateToStr(Now)
  else
    edConfirmDate.Text := '';
end;

procedure TmstEditProjectDialog.DataSource1UpdateData(Sender: TObject);
begin
  ShowZDelta();
end;

function TmstEditProjectDialog.Execute(aProject: TmstProject): Boolean;
begin
  FSelectedLine := nil;
  FMapSizeUpdated := False;
  FreeAndNil(FTempProject);
  FOriginal := aProject;
  FTempProject := TmstProject.Create;
  FTempProject.Assign(FOriginal);
  LoadProject();
  Result := ShowModal = mrOK;
  if Result then
  begin
    ReadProject();
    FOriginal.Assign(FTempProject);
  end;
end;

procedure TmstEditProjectDialog.EzDrawBox1AfterSelect(Sender: TObject; Layer: TEzBaseLayer; RecNo: Integer);
var
  L: TmstProjectLayer;
  I: Integer;
  J: Integer;
  Line: TmstProjectLine;
begin
  L := FTempProject.Layers.ByName(Layer.Name);
  if Assigned(L) then
  begin
    I := cbLayers.Items.IndexOfObject(L);
    if I >= 0 then
    begin
      if cbLayers.ItemIndex <> I then
      begin
        cbLayers.ItemIndex := I;
        cbLayersChange(cbLayers);
      end;
      for J := 0 to FTempProject.Lines.Count - 1 do
      begin
        Line := FTempProject.Lines[J];
        if Line.Layer = L then
          if Line.EntityId = RecNo then
          begin
            I := ListBoxLines.Items.IndexOfObject(Line);
            if (I >= 0) and (I <> ListBoxLines.ItemIndex) then
            begin
              ListBoxLines.ItemIndex := I;
              SaveSelectedLine();
              ChangeSelectedLine();
            end;
          end;
      end;
    end;
  end;
end;

procedure TmstEditProjectDialog.EzDrawBox1MouseMove(Sender: TObject; Shift: TShiftState; X, Y: Integer);
var
  Wx, Wy: Double;
  S: string;
begin
  if EzGIS1.Active then
  begin
    EzDrawBox1.DrawBoxToWorld(X, Y, Wx, Wy);
    S := FormatFloat('#########0.00', Wy) + ';' + FormatFloat('#########0.00', Wx);
    lCoords.Caption := S;
    lCoords.Visible := True;
  end;
end;

procedure TmstEditProjectDialog.EzGIS1BeforePaintEntity(Sender: TObject; Layer: TEzBaseLayer; Recno: Integer;
  Entity: TEzEntity; Grapher: TEzGrapher; Canvas: TCanvas; const Clip: TEzRect; DrawMode: TEzDrawMode;
  var CanShow: Boolean; var EntList: TEzEntityList; var AutoFree: Boolean);
var
  LineLayer: TEzBaseLayer;
begin
  if Assigned(FSelectedLine) then
    if FSelectedLine.EntityId = Recno then
    begin
      LineLayer := EzGIS1.Layers.LayerByName(FSelectedLine.Layer.Name);
      if LineLayer = Layer then
      begin
        Entity.DrawControlPoints(Grapher, Canvas, Grapher.CurrentParams.VisualWindow, False);
      end;
    end;
end;

procedure TmstEditProjectDialog.FindFirstLineLayer;
var
  I, J: Integer;
  L: TmstProjectLayer;
begin
  J := 0;
  for I := 0 to cbLayers.Items.Count - 1 do
  begin
    L := cbLayers.Items.Objects[I] as TmstProjectLayer;
    if L.IsLineLayer then
    begin
      J := I;
      Break;
    end;
  end;
  cbLayers.ItemIndex := J;
  cbLayers.OnChange(cbLayers);

end;

procedure TmstEditProjectDialog.FormDestroy(Sender: TObject);
begin
  FreeAndNil(FTempProject);
end;

procedure TmstEditProjectDialog.FormShow(Sender: TObject);
begin
  ZoomAll.Click;
//  LoadLineToGrid(FSelectedLine);
//  LoadLineInfo(FSelectedLine);
end;

function TmstEditProjectDialog.GetCanSave: Boolean;
begin
  Result := btnOK.Visible;
end;

function TmstEditProjectDialog.GetOrgName(OrgId: Integer): string;
var
  aDb: IDb;
  Conn: IIBXConnection;
  Ds: TDataSet;
begin
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

procedure TmstEditProjectDialog.grdCoordsExit(Sender: TObject);
begin
  if grdCoords.DataSource.DataSet.State = dsEdit then
  begin
    grdCoords.DataSource.DataSet.Post;
  end;
end;

procedure TmstEditProjectDialog.grdCoordsKeyPress(Sender: TObject; var Key: Char);
begin
  if Key = #27 then
    if grdCoords.DataSource.DataSet.State in dsEditModes then
    begin
      try
        grdCoords.DataSource.DataSet.Post;
      except
      end;
    end;
end;

procedure TmstEditProjectDialog.LinesToGIS;
var
  I: Integer;
  Line: TmstProjectLine;
  Layer: TEzBaseLayer;
  Ent: TEzPolyline;
  Pts: array of TEzPoint;
  J: Integer;
  X, Y: Double;
begin
  for I := 0 to FTempProject.Lines.Count - 1 do
  begin
    Line := FTempProject.Lines[I];
    Layer := EzGIS1.Layers.LayerByName(Line.Layer.Name);
    if Assigned(Layer) then
    begin
      SetLength(Pts, Line.Points.Count);
      for J := 0 to Line.Points.Count - 1 do
      begin
        if FTempProject.CK36 then
        begin
//          uCK36.ToVRN(Line.Points[J].X, Line.Points[J].Y, X, Y);
          uCK36.ToVRN(Line.Points[J].X, Line.Points[J].Y, Y, X);
          Pts[J].x := X;
          Pts[J].y := Y;
        end
        else
        begin
          Pts[J].x := Line.Points[J].Y;
          Pts[J].y := Line.Points[J].X;
        end;
      end;
      //
      Ent := TEzPolyLine.CreateEntity(Pts, False);
      try
        if Assigned(Line.Layer.NetType) then
          Ent.PenTool.Color := Line.Layer.NetType.GetColor();
        Line.EntityId := Layer.AddEntity(Ent);
      finally
        FreeAndNil(Ent);
      end;
    end;
  end;
end;

procedure TmstEditProjectDialog.ListBoxLinesClick(Sender: TObject);
begin
  SaveSelectedLine();
  ChangeSelectedLine();
end;

procedure TmstEditProjectDialog.ListBoxLinesDblClick(Sender: TObject);
var
  L: TmstProjectLine;
  Layer: TEzBaseLayer;
begin
  if ListBoxLines.ItemIndex >= 0 then
  begin
    L := ListBoxLines.Items.Objects[ListBoxLines.ItemIndex] as TmstProjectLine;
    if L.EntityId > 0 then
    begin
      Layer := EzGIS1.Layers.LayerByName(L.Layer.Name);
      if Assigned(Layer) then
      begin
        EzDrawBox1.Selection.Clear;
        Layer.Recno := L.EntityId;
        EzDrawBox1.Selection.Add(Layer, L.EntityId);
        EzDrawBox1.ZoomToSelection;
      end;
    end;
  end;
end;

procedure TmstEditProjectDialog.LoadLayerList;
var
  I: Integer;
begin
  cbLayers.Items.Clear;
  for I := 0 to FTempProject.Layers.Count - 1 do
  begin
    cbLayers.AddItem(FTempProject.Layers[I].Name, FTempProject.Layers[I]);
  end;
end;

procedure TmstEditProjectDialog.LoadLineInfo(Line: TmstProjectLine);
begin
  if Line = nil then
  begin
    edDiam.Text := '';
    edDiam.Enabled := False;
    edDiam.ParentColor := True;
    //
    edVoltage.Text := '';
    edVoltage.Enabled := False;
    edVoltage.ParentColor := True;
    //
    mInfo.Text := '';
    mInfo.Enabled := False;
    mInfo.ParentColor := True;
  end
  else
  begin
    edDiam.Text := Line.Diameter;
    edDiam.Enabled := True;
    edDiam.ParentColor := False;
    edDiam.Color := clWindow;
    //
    edVoltage.Text := Line.Voltage;
    edVoltage.Enabled := True;
    edVoltage.ParentColor := False;
    edVoltage.Color := clWindow;
    //
    mInfo.Text := Line.Info;
    mInfo.Enabled := True;
    mInfo.ParentColor := False;
    mInfo.Color := clWindow;
  end;
  ShowZDelta();
end;

procedure TmstEditProjectDialog.LoadLinesToListBox(Layer: TmstProjectLayer);
var
  I: Integer;
begin
  ListBoxLines.Clear;
  SaveSelectedLine();
  ChangeSelectedLine();
  //
  if Assigned(Layer) then
  begin
    for I := 0 to FTempProject.Lines.Count - 1 do
      if FTempProject.Lines[I].Layer.DatabaseId = Layer.DatabaseId then
      begin
        ListBoxLines.AddItem(IntToStr(ListBoxLines.Items.Count + 1), FTempProject.Lines[I]);
      end;
    //
    ListBoxLines.ItemIndex := 0;
    SaveSelectedLine();
    ChangeSelectedLine();
  end;
end;

procedure TmstEditProjectDialog.LoadLineToGrid(Line: TmstProjectLine);
var
  I: Integer;
begin
  if Line = nil then
  begin
    dsCoords.Active := False;
    grdCoords.Enabled := False;
    grdCoords.ParentColor := True;
  end
  else
  begin
    grdCoords.Enabled := True;
    grdCoords.ParentColor := False;
    grdCoords.Color := clWindow;
    //
    dsCoords.DisableControls;
    try
      dsCoords.Active := True;
      while not dsCoords.Eof do
        dsCoords.Delete;
      for I := 0 to Line.Points.Count - 1 do
      begin
        FCanAddCoords := True;
        try
          dsCoords.Append;
          dsCoords.FieldByName('X').AsFloat := Line.Points[I].X;
          dsCoords.FieldByName('Y').AsFloat := Line.Points[I].Y;
          dsCoords.FieldByName('Z').AsFloat := Line.Points[I].Z;
          dsCoords.Post;
        finally
          FCanAddCoords := False;
        end;
      end;
    finally
      dsCoords.EnableControls;
      dsCoords.First;
    end;
  end;
end;

procedure TmstEditProjectDialog.LoadProject;
begin
  edAddress.Text := FTempProject.Address;
  edDocNum.Text := FTempProject.DocNumber;
  if FTempProject.DocDate = 0 then
    edDate.Text := DateToStr(Now)
  else
    edDate.Text := DateToStr(FTempProject.DocDate);
  if FTempProject.ConfirmDate = 0 then
    edConfirmDate.Text := ''
  else
    edConfirmDate.Text := DateToStr(FTempProject.ConfirmDate);
  chbConfirmed.Checked := FTempProject.Confirmed;
  chbCK36.Checked := FTempProject.CK36;
  edCustomer.Text := GetOrgName(FTempProject.CustomerOrgId);
  edExecutor.Text := GetOrgName(FTempProject.ExecutorOrgId);
  // готовим ГИС
  PrepareGIS();
  // загружаем список слоёв
  LoadLayerList();
  // открываем первый слой
  FindFirstLineLayer();
end;

procedure TmstEditProjectDialog.PlacesToGIS;
var
  I: Integer;
  Place: TmstProjectPlace;
  Layer: TEzBaseLayer;
  Ent: TEzEntity;
  EntClass: TEzEntityClass;
  EntityID: TEzEntityID;
begin
  for I := 0 to FTempProject.Places.Count - 1 do
  begin
    Place := FTempProject.Places[I];
    Layer := EzGIS1.Layers.LayerByName(Place.Layer.Name);
    EntityID := TEzEntityID(Place.EzId);
    EntClass := GetClassFromID(EntityID);
    Ent := EntClass.Create(0, True);
    try
      Place.EzData.Position := 0;
      Ent.LoadFromStream(Place.EzData);
      Place.EntityId := Layer.AddEntity(Ent);
    finally
      FreeAndNil(Ent);
    end;
  end;
end;

procedure TmstEditProjectDialog.PrepareGIS;
var
  Path: string;
  I: Integer;
begin
  // создаём новую папку
  // заполняем поля гис
  // сохраняем в новый файл в этой папке
  Path := TPath.Combine(mstClientAppModule.SessionDir, GetUniqueString());
  ForceDirectories(Path);
  EzGIS1.LayersSubdir := Path;
  EzGIS1.CreateNew(TPath.Finish(Path, 'import.ezm'));
  // добавляем слои
  for I := 0 to FTempProject.Layers.Count - 1 do
  begin
    EzGIS1.CreateLayer(FTempProject.Layers[I].Name, ltMemory);
  end;
  EzGIS1.Active := True;
  //
  BlocksToGIS();
  LinesToGIS();
  PlacesToGIS();
  //
  EzDrawBox1.GIS.QuickUpdateExtension;
  EzDrawBox1.ZoomToExtension;
end;

procedure TmstEditProjectDialog.ReadProject;
begin
  FTempProject.Address := edAddress.Text;
  FTempProject.DocNumber := edDocNum.Text;
  if Trim(edDate.Text) = '' then
    FTempProject.DocDate := 0
  else
    FTempProject.DocDate := StrToDate(Trim(edDate.Text));
  FTempProject.Confirmed := chbConfirmed.Checked;
  if Trim(edConfirmDate.Text) = '' then
    FTempProject.ConfirmDate := 0
  else
    FTempProject.ConfirmDate := StrToDate(edConfirmDate.Text);
  FTempProject.CK36 := chbCK36.Checked;
end;

procedure TmstEditProjectDialog.dsCoordsAfterPost(DataSet: TDataSet);
var
  Recno: Integer;
  L: TmstProjectLine;
begin
  if FCanAddCoords then
    Exit;
  Recno := dsCoords.RecNo;
  if ListBoxLines.ItemIndex >= 0 then
  begin
    L := ListBoxLines.Items.Objects[ListBoxLines.ItemIndex] as TmstProjectLine;
    L.Points[Recno - 1].Z := dsCoords.FieldByName('Z').AsFloat;
  end;
  ShowZDelta();
end;

procedure TmstEditProjectDialog.dsCoordsAfterScroll(DataSet: TDataSet);
begin
  ShowZDelta();
end;

procedure TmstEditProjectDialog.dsCoordsBeforeInsert(DataSet: TDataSet);
begin
  if not FCanAddCoords then
    Abort;
end;

procedure TmstEditProjectDialog.dsCoordsDeltaGetText(Sender: TField; var Text: string; DisplayText: Boolean);
begin
  DisplayText := Assigned(FSelectedLine);
  if DisplayText then
  begin
    Text := FormatFloat('#0.00', FSelectedLine.Points.GetZDelta(Sender.DataSet.RecNo - 1));
  end;
end;

procedure TmstEditProjectDialog.edCustomerKeyPress(Sender: TObject; var Key: Char);
begin
  if Key = #13 then
    btnCustomer.Click;
end;

procedure TmstEditProjectDialog.edExecutorKeyPress(Sender: TObject; var Key: Char);
begin
  if Key = #13 then
    btnExecutor.Click;
end;

procedure TmstEditProjectDialog.SaveSelectedLine;
begin
  if not Assigned(FSelectedLine) then
    Exit;
  FSelectedLine.Diameter := edDiam.Text;
  FSelectedLine.Voltage := edVoltage.Text;
  FSelectedLine.Info := mInfo.Text;
end;

function TmstEditProjectDialog.SelectOrg(var Id: Integer; out OrgName: string): Boolean;
begin
  Result := mstClientAppModule.MapMngr.SelectOrg(Id, OrgName);
end;

procedure TmstEditProjectDialog.SetCanSave(const Value: Boolean);
begin
  btnOK.Visible := Value;
end;

procedure TmstEditProjectDialog.ShowZDelta;
var
  dH: Double;
begin
  if Assigned(FSelectedLine) then
  begin
    dH := FSelectedLine.GetZDelta();
    lHDiff.Caption := 'Уклон: ' + FormatFloat('#####0.00', dH);
    lHDiff.Visible := True;
  end
  else
    lHDiff.Visible := False;
end;

procedure TmstEditProjectDialog.SpeedButton1Click(Sender: TObject);
begin
  EzCmdLine1.Clear;
end;

procedure TmstEditProjectDialog.ZoomAllClick(Sender: TObject);
var
  L: TmstProjectLayer;
  EzLayer: TEzBaseLayer;
begin
  if cbLayers.ItemIndex < 0 then
  begin
    EzLayer := nil;
  end
  else
  begin
    L := cbLayers.Items.Objects[cbLayers.ItemIndex] as TmstProjectLayer;
    EzLayer := EzGIS1.Layers.LayerByName(L.Name);
  end;
  if Assigned(EzLayer) then
    EzDrawBox1.ZoomToLayerRef(EzLayer.Name)
  else
    EzDrawBox1.ZoomToExtension;
end;

procedure TmstEditProjectDialog.ZoomInClick(Sender: TObject);
begin
  EzCmdLine1.Clear;
  EzCmdLine1.DoCommand('ZOOMIN','');
end;

procedure TmstEditProjectDialog.ZoomOutClick(Sender: TObject);
begin
  EzCmdLine1.Clear;
  EzCmdLine1.DoCommand('ZOOMOUT','');
end;

procedure TmstEditProjectDialog.ZoomWBtnClick(Sender: TObject);
begin
  EzCmdLine1.Clear;
  EzCmdLine1.DoCommand('ZOOMWIN','');
end;

end.
