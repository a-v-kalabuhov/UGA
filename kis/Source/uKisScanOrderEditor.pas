unit uKisScanOrderEditor;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Grids, DBGrids, DB,
  JvBaseDlg, JvDesktopAlert,
  uDBGrid, uGeoUtils,
  uKisClasses, uKisScanOrders, uKisEntityEditor;

type
  TKisScanOrderEditor = class(TKisEntityEditor)
    gbSender: TGroupBox;
    edOrgname: TEdit;
    RadBtnOrgs: TRadioButton;
    RadBtnMP: TRadioButton;
    btnSelectOrg: TButton;
    cbOffices: TComboBox;
    GroupBox1: TGroupBox;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    edAddress: TEdit;
    edDate: TEdit;
    edNumber: TEdit;
    Label4: TLabel;
    cbWorkType: TComboBox;
    GroupBox2: TGroupBox;
    DBGrid1: TkaDBGrid;
    Label5: TLabel;
    edNomenclature: TEdit;
    btnAdd: TButton;
    btnDelete: TButton;
    DataSource1: TDataSource;
    chbAnnulled: TCheckBox;
    procedure cbOfficesChange(Sender: TObject);
    procedure RadBtnOrgsClick(Sender: TObject);
    procedure RadBtnMPClick(Sender: TObject);
    procedure btnSelectOrgClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure btnAddClick(Sender: TObject);
    procedure btnDeleteClick(Sender: TObject);
    procedure edNomenclatureChange(Sender: TObject);
    procedure edNomenclatureKeyPress(Sender: TObject; var Key: Char);
    procedure edOrgnameKeyPress(Sender: TObject; var Key: Char);
    procedure btnOkClick(Sender: TObject);
    procedure DBGrid1GetLogicalValue(Sender: TObject; Column: TColumn;
      var Value: Boolean);
    procedure DBGrid1LogicalColumn(Sender: TObject; Column: TColumn;
      var Value: Boolean);
  private
    FOfficeId: Integer;
    FLicensedOrgId: Integer;
    FMyManager: TKisScanOrdersMngr;
    FMyEntity: TKisScanOrder;
    procedure AddMap;
    function CanAdd: Boolean;
    function CanEdit: Boolean;
    function CanDelete: Boolean;
    /// <summary>
    ///  Проверяет, есть ли планшет в редактируемой заявке или нет.
    ///  Необходимо во избежание дублирования планшетов в заявке.
    /// </summary>
    function FindMap(const Nomenclature: String): Boolean;
    /// <summary>
    ///   Проверяет находится ли планшет в базе данных (True) или у заказчика (False).
    /// </summary>
    function IsMapInStore(const Nomenclature: string): Boolean;
    procedure ShowOrgInfo(TheOrg: TKisEntity; const OrgId: Integer);
    procedure UpdateCustomerControls;
    procedure UpdateMapControls;
  public
    property MyEntity: TKisScanOrder read FMyEntity write FMyEntity;
    property MyManager: TKisScanOrdersMngr read FMyManager write FMyManager;
    //
    property LicensedOrgId: Integer read FLicensedOrgId write FLicensedOrgId;
    property OfficeId: Integer read FOfficeId write FOfficeId;
  end;

implementation

{$R *.dfm}

uses
  uGC, uCommonUtils,
  uKisAppModule, uKisUtils, uKisIntf, uKisConsts, uKisMapScans,
  uKisLicensedOrgs;

procedure TKisScanOrderEditor.btnAddClick(Sender: TObject);
begin
  inherited;
  AddMap;
end;

procedure TKisScanOrderEditor.btnDeleteClick(Sender: TObject);
begin
  inherited;
  if btnDelete.Enabled and CanDelete()  then
  begin
    DataSource1.DataSet.Delete;
    UpdateMapControls;
  end;
end;

procedure TKisScanOrderEditor.btnOkClick(Sender: TObject);
var
  I: Integer;
begin
  if chbAnnulled.Checked then
  begin
    I := MessageBox(Handle,
           'Вы аннулировали заявку.' + sLineBreak +
           'После сохранения аннулирование будет невозможно отменить!'
            + sLineBreak + 'Продолжить?',
           S_CONFIRM,
           MB_YESNO + MB_ICONQUESTION);
    if I <> ID_YES then
      Exit;
  end;
  inherited;
end;

procedure TKisScanOrderEditor.btnSelectOrgClick(Sender: TObject);
var
  Org: TKisLicensedOrg;
begin
  with AppModule.SQLMngrs[kmLicensedOrgs] do
  begin
    Org := SelectEntity as TKisLicensedOrg;
    if Assigned(Org) then
    begin
      Org.Forget;
      ShowOrgInfo(Org, Org.ID);
      FLicensedOrgId := Org.ID;
    end;
  end;
end;

function TKisScanOrderEditor.CanAdd: Boolean;
begin
  Result := (not MyEntity.ReadOnly) and (not MyEntity.Annulled); // and (not MyEntity.Returned)
end;

function TKisScanOrderEditor.CanDelete: Boolean;
begin
  Result := (not MyEntity.ReadOnly) and (not MyEntity.Returned) and (not MyEntity.Annulled);
end;

function TKisScanOrderEditor.CanEdit: Boolean;
begin
  Result := (not MyEntity.ReadOnly) and (not MyEntity.GivedOut)
    and (not MyEntity.Returned) and (not MyEntity.Annulled);
end;

procedure TKisScanOrderEditor.cbOfficesChange(Sender: TObject);
begin
  if cbOffices.ItemIndex < 0 then
    FOfficeId := -1
  else
    FOfficeId := Integer(cbOffices.Items.Objects[cbOffices.ItemIndex]);
end;

procedure TKisScanOrderEditor.DBGrid1GetLogicalValue(Sender: TObject;
  Column: TColumn; var Value: Boolean);
begin
  inherited;
  Value := not Column.Field.AsBoolean;
end;

procedure TKisScanOrderEditor.DBGrid1LogicalColumn(Sender: TObject;
  Column: TColumn; var Value: Boolean);
begin
  inherited;
  Value := Column.Field is TBooleanField;
end;

procedure TKisScanOrderEditor.edNomenclatureChange(Sender: TObject);
begin
  inherited;
  UpdateMapControls;
end;

procedure TKisScanOrderEditor.edNomenclatureKeyPress(Sender: TObject; var Key: Char);
begin
  inherited;
  if Key = #13 then
    AddMap;
end;

procedure TKisScanOrderEditor.edOrgnameKeyPress(Sender: TObject; var Key: Char);
begin
  inherited;
  if Key = #13 then
    btnSelectOrg.Click;
end;

function TKisScanOrderEditor.FindMap(const Nomenclature: String): Boolean;
var
  R: Integer;
begin
  with DataSource1.DataSet do
  begin
    DisableControls;
    try
      R := RecNo;
      First;
      Result := Locate(SF_NOMENCLATURE, Nomenclature, []);
      if not Result then
        RecNo := R;
    finally
      EnableControls;
    end;
  end;
end;

procedure TKisScanOrderEditor.FormShow(Sender: TObject);
var
  Nomen: string;
begin
  inherited;
  if FLicensedOrgId > 0 then
    RadBtnOrgs.Checked := True
  else
  if FOfficeId > 0 then
    RadBtnMP.Checked := True;
  UpdateCustomerControls;
  btnDelete.Enabled := (DataSource1.DataSet.RecordCount > 0) and CanDelete();
  //
  chbAnnulled.Enabled := chbAnnulled.Enabled and CanEdit();
  //
  DataSource1.DataSet.Last;
  DataSource1.DataSet.First;
  while not DataSource1.DataSet.Eof do
  begin
    Nomen := DataSource1.DataSet.FieldByName(SF_NOMENCLATURE).AsString;
    DataSource1.DataSet.Edit;
    DataSource1.DataSet.FieldByName(SF_GIVE_STATUS).AsBoolean := IsMapInStore(Nomen);
    DataSource1.DataSet.Post;
    DataSource1.DataSet.Next;
  end;
  DataSource1.DataSet.First;
end;

function TKisScanOrderEditor.IsMapInStore(const Nomenclature: string): Boolean;
var
  Value: Variant;
  ScanId: Integer;
  Ent: TKisEntity;
begin
  Result := False;
  if AppModule.GetFieldValue(nil, ST_MAP_SCANS, SF_NOMENCLATURE, SF_ID, Nomenclature, Value) then
  begin
    ScanId := Value;
    Ent := AppModule[kmMapScans].GetEntity(ScanId, keMapScanState);
    if Assigned(Ent) then
      Result := not TKisMapScanState(Ent).GivedOut;
  end;
end;

procedure TKisScanOrderEditor.RadBtnMPClick(Sender: TObject);
begin
  UpdateCustomerControls;
end;

procedure TKisScanOrderEditor.RadBtnOrgsClick(Sender: TObject);
begin
  inherited;
  UpdateCustomerControls;
end;

procedure TKisScanOrderEditor.ShowOrgInfo(TheOrg: TKisEntity; const OrgId: Integer);
begin
  if not Assigned(TheOrg) then
    TheOrg := AppModule[kmLicensedOrgs].GetEntity(OrgId);
  if Assigned(TheOrg) then
    edOrgname.Text := TKisLicensedOrg(TheOrg).Name
  else
    edOrgname.Clear;
end;

procedure TKisScanOrderEditor.UpdateCustomerControls;
begin
  edOrgname.Visible := RadBtnOrgs.Checked;
  btnSelectOrg.Visible := RadBtnOrgs.Checked;
  cbOffices.Visible := RadBtnMP.Checked;
  if RadBtnMP.Checked then
  begin
    //грузим отделы и исполнителей
    cbOffices.Items := IStringList(AppModule.Lists[klOffices]).StringList;
    //
    if not ComboLocate(cbOffices, FOfficeId) then
      cbOffices.ItemIndex := -1;
  end
  else
  if RadBtnOrgs.Checked then
    ShowOrgInfo(nil, FLicensedOrgId);
  //
  btnSelectOrg.Enabled := CanEdit;
end;

procedure TKisScanOrderEditor.UpdateMapControls;
var
  S: String;
  V: Variant;
  B: Boolean;
  N: TNomenclature;
begin
  inherited;
  CloseControlAlert;
  B := CanAdd;//CanEdit;
  if B then
  begin
    N.Init(edNomenclature.Text, False);
    B := N.Valid;
    if B then
    begin
      S := N.Nomenclature();
      if not AppModule.GetFieldValue(nil, ST_MAP_SCANS, SF_NOMENCLATURE, SF_ID, AnsiUpperCase(S), V) then
      begin
        ControlAlert(edNomenclature, 'Планшет не отсканирован!');
        B := False;
      end
      else
      begin
        CloseControlAlert;
        B := not FindMap(S);
      end;
    end;
  end;
  btnAdd.Enabled := B;
  //
  btnDelete.Enabled := CanEdit and (DataSource1.DataSet.RecordCount > 0);
end;

procedure TKisScanOrderEditor.AddMap;
var
  V: Variant;
  Nomen: string;
  N: TNomenclature;
begin
  if btnAdd.Enabled and CanAdd then
  begin
    Nomen := '';
    N.Init(edNomenclature.Text, False);
    if not N.Valid then
    begin
      ControlAlert(edNomenclature, 'Неверная номенклатура!');
      edNomenclature.SetFocus;
    end
    else
    begin
      Nomen := N.Nomenclature();
      if not AppModule.GetFieldValue(nil, ST_MAP_SCANS, SF_NOMENCLATURE, SF_ID, AnsiUpperCase(Nomen), V) then
      begin
        ControlAlert(edNomenclature, 'Планшет не отсканирован!');
        edNomenclature.SetFocus;
      end
      else
  //    if MapIsInUse(Nomen, OrderNum, OrderDate) then
  //    begin
  //      ControlAlert(edNomenclature,
  //        Format('Планшет используется в заявке %s от %s!', [OrderNum, OrderDate]));
  //      edNomenclature.SetFocus;
  //    end
  //    else
      begin
        with DataSource1.DataSet do
          try
            DisableControls;
            if RecNo = RecordCount then
              Append
            else
            begin
              Next;
              Insert;
            end;
            FieldByName(SF_NOMENCLATURE).AsString := Nomen;
            FieldByName(SF_GIVE_STATUS).AsBoolean := IsMapInStore(Nomen);
            Post;
          finally
            EnableControls;
          end;
        UpdateMapControls;
      end;
    end;
  end;
end;

end.
