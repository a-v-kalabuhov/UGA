unit uMStDialogMPObjectSemantics;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms, DB, Dialogs, StdCtrls, Mask,
  JvExMask, JvSpin, JvExControls, JvInspector,
  EzLib,
  uDateTimeUtils,
  uMStConsts, uMStClassesProjectsMP, uMStKernelIBX, uMStClassesMPIntf,
  uMStModuleApp;

type
  TmstEditMPObjectSemanticsDialog = class(TForm)
    GroupBox1: TGroupBox;
    edRequestDate: TEdit;
    edAddress: TEdit;
    edProjectName: TEdit;
    edDocNumber: TEdit;
    edDocDate: TEdit;
    edRequestNumber: TEdit;
    Label10: TLabel;
    Label11: TLabel;
    Label12: TLabel;
    Label7: TLabel;
    Label8: TLabel;
    Label9: TLabel;
    GroupBox2: TGroupBox;
    chbArchived: TCheckBox;
    cbProjected: TComboBox;
    Label1: TLabel;
    chbDismantled: TCheckBox;
    btnOK: TButton;
    btnCancel: TButton;
    edCustomer: TEdit;
    Label2: TLabel;
    btnSelectCustomer: TButton;
    Label3: TLabel;
    edExecutor: TEdit;
    btnSelectExecutor: TButton;
    Label4: TLabel;
    edOwner: TEdit;
    Label5: TLabel;
    cbClass: TComboBox;
    chbUnderground: TCheckBox;
    spinDiameter: TJvSpinEdit;
    spinPipeCount: TJvSpinEdit;
    Label6: TLabel;
    Label13: TLabel;
    Label14: TLabel;
    Label15: TLabel;
    spinVoltage: TJvSpinEdit;
    Label16: TLabel;
    Label17: TLabel;
    edDrawer: TEdit;
    btnSelectDrawer: TButton;
    Label18: TLabel;
    edDrawDate: TEdit;
    Label19: TLabel;
    spinRotation: TJvSpinEdit;
    Label20: TLabel;
    edMaterial: TEdit;
    Label21: TLabel;
    edTop: TEdit;
    Label22: TLabel;
    edBottom: TEdit;
    Label23: TLabel;
    edFloor: TEdit;
    GroupBox3: TGroupBox;
    chbHasCertif: TCheckBox;
    Label24: TLabel;
    edCertifNumber: TEdit;
    Label25: TLabel;
    edCertifDate: TEdit;
    btnClearCustomer: TButton;
    btnClearExecutor: TButton;
    btnClearDrawer: TButton;
    Label26: TLabel;
    edLinkedGuid: TEdit;
    Label27: TLabel;
    edObjGuid: TEdit;
    Label28: TLabel;
    cbCheckState: TComboBox;
    chbChecked: TCheckBox;
    Label29: TLabel;
    edDiamComment: TEdit;
    edVoltComment: TEdit;
    Label32: TLabel;
    mInfo: TMemo;
    lSemInfo: TLabel;
    chbSewer: TCheckBox;
    Label33: TLabel;
    cbVoltage: TComboBox;
    Label31: TLabel;
    cbPressure: TComboBox;
    chbConfirmed: TCheckBox;
    edConfirmDate: TEdit;
    Label30: TLabel;
    procedure btnCancelClick(Sender: TObject);
    procedure btnOKClick(Sender: TObject);
    procedure btnSelectCustomerClick(Sender: TObject);
    procedure btnSelectExecutorClick(Sender: TObject);
    procedure btnSelectDrawerClick(Sender: TObject);
    procedure btnClearCustomerClick(Sender: TObject);
    procedure btnClearExecutorClick(Sender: TObject);
    procedure btnClearDrawerClick(Sender: TObject);
    procedure edDocDateKeyPress(Sender: TObject; var Key: Char);
    procedure edRequestDateKeyPress(Sender: TObject; var Key: Char);
    procedure edConfirmDateKeyPress(Sender: TObject; var Key: Char);
    procedure edDrawDateKeyPress(Sender: TObject; var Key: Char);
    procedure edCertifDateKeyPress(Sender: TObject; var Key: Char);
  private
    FMPModule: ImstMPModule;
    FObject: TmstMPObject;
    FCanChangeStatus: Boolean;
    FCanChangeClass: Boolean;
    function CheckData(): Boolean;
    function CheckDate(aEdit: TEdit): Boolean;
    procedure ReadFromObject();
    procedure WriteToObject();
    function GetOrgName(OrgId: Integer): string;
    function SelectOrg(var Id: Integer; out OrgName: string): Boolean;
    function GetDate(const aText: string): TDateTime;
  public
    function EditObject(AObject: TmstMPObject; aMPModule: ImstMPModule; CanChangeStatus, CanChangeClass: Boolean): Boolean;
  end;

var
  mstEditMPObjectSemanticsDialog: TmstEditMPObjectSemanticsDialog;

implementation

{$R *.dfm}

procedure TmstEditMPObjectSemanticsDialog.btnCancelClick(Sender: TObject);
begin
  ModalResult := mrCancel;
end;

procedure TmstEditMPObjectSemanticsDialog.btnClearCustomerClick(Sender: TObject);
begin
  FObject.CustomerOrgId := 0;
  edCustomer.Clear;
end;

procedure TmstEditMPObjectSemanticsDialog.btnOKClick(Sender: TObject);
begin
  if CheckData() then
    ModalResult := mrOk;
end;

procedure TmstEditMPObjectSemanticsDialog.btnSelectCustomerClick(Sender: TObject);
var
  Id: Integer;
  aName: string;
begin
  Id := FObject.CustomerOrgId;
  if SelectOrg(Id, aName) then
  begin
    FObject.CustomerOrgId := Id;
    edCustomer.Text := aName;
//    if FObject.ExecutorOrgId = 0 then
//    begin
//      FObject.ExecutorOrgId := Id;
//      edExecutor.Text := aName;
//    end;
  end;
end;

procedure TmstEditMPObjectSemanticsDialog.btnSelectDrawerClick(Sender: TObject);
var
  Id: Integer;
  aName: string;
begin
  Id := FObject.DrawOrgId;
  if SelectOrg(Id, aName) then
  begin
    FObject.DrawOrgId := Id;
    edDrawer.Text := aName;
  end;
end;

procedure TmstEditMPObjectSemanticsDialog.btnSelectExecutorClick(Sender: TObject);
var
  Id: Integer;
  aName: string;
begin
  Id := FObject.ExecutorOrgId;
  if SelectOrg(Id, aName) then
  begin
    FObject.ExecutorOrgId := Id;
    edExecutor.Text := aName;
  end;
end;

procedure TmstEditMPObjectSemanticsDialog.btnClearDrawerClick(Sender: TObject);
begin
  FObject.DrawOrgId := 0;
  edDrawer.Clear;
end;

procedure TmstEditMPObjectSemanticsDialog.btnClearExecutorClick(Sender: TObject);
begin
  FObject.ExecutorOrgId := 0;
  edExecutor.Clear;
end;

function TmstEditMPObjectSemanticsDialog.CheckData: Boolean;
begin
  Result := False;
  if not CheckDate(edRequestDate) then
    Exit;
  if not CheckDate(edDocDate) then
    Exit;
  if not CheckDate(edDrawDate) then
    Exit;
  if not CheckDate(edCertifDate) then
    Exit;
  Result := True;
end;

function TmstEditMPObjectSemanticsDialog.CheckDate(aEdit: TEdit): Boolean;
var
  Dummy: TDateTime;
  S: string;
begin
  if Trim(aEdit.Text) = '' then
    Result := True
  else
  begin
    S := TDateTimeUtils.ReplaceSeparators(Trim(aEdit.Text));
    Result := TryStrToDate(S, Dummy);
    if not Result then
    begin
      aEdit.SelectAll;
      aEdit.SetFocus;
      ShowMessage('Неверно введена дата!');
    end;
  end;
end;

procedure TmstEditMPObjectSemanticsDialog.edCertifDateKeyPress(Sender: TObject; var Key: Char);
begin
  if Key in DateSeparators then
    Key := '.';
end;

procedure TmstEditMPObjectSemanticsDialog.edConfirmDateKeyPress(Sender: TObject; var Key: Char);
begin
  if Key in DateSeparators then
    Key := '.';
end;

procedure TmstEditMPObjectSemanticsDialog.edDocDateKeyPress(Sender: TObject; var Key: Char);
begin
  if Key in DateSeparators then
    Key := '.';
end;

procedure TmstEditMPObjectSemanticsDialog.edDrawDateKeyPress(Sender: TObject; var Key: Char);
begin
  if Key in DateSeparators then
    Key := '.';
end;

function TmstEditMPObjectSemanticsDialog.EditObject(AObject: TmstMPObject; aMPModule: ImstMPModule;
  CanChangeStatus, CanChangeClass: Boolean): Boolean;
begin
  FObject := AObject;
  FMPModule := aMPModule;
  FCanChangeStatus := CanChangeStatus;
  FCanChangeClass := CanChangeClass;
  ReadFromObject();
  Result := ShowModal = mrOk;
  if Result then
  begin
    WriteToObject();
  end;
end;

procedure TmstEditMPObjectSemanticsDialog.edRequestDateKeyPress(Sender: TObject; var Key: Char);
begin
  if Key in DateSeparators then
    Key := '.';
end;

function TmstEditMPObjectSemanticsDialog.GetDate(const aText: string): TDateTime;
begin
  Result := 0;
  if Trim(aText) <> '' then
    TryStrToDate(Trim(aText), Result);
end;

function TmstEditMPObjectSemanticsDialog.GetOrgName(OrgId: Integer): string;
var
  aDb: IDb;
  Conn: IIBXConnection;
  Ds: TDataSet;
begin
  aDb := mstClientAppModule.MapMngr as IDb;
  Conn := aDb.GetConnection(cmReadOnly, dmKis);
  Ds := Conn.GetDataSet(SQL_SELECT_LICENSED_ORG_NAME);
  Conn.SetParam(Ds, SF_ID, OrgId);
  Ds.Open;
  if Ds.IsEmpty then
    Result := ''
  else
    Result := Ds.Fields[0].AsString;
  Ds.Close;
end;

procedure TmstEditMPObjectSemanticsDialog.ReadFromObject;
var
  S: string;
  I: Integer;
  ClassIds: TIntegerList;
  ClassId: Integer;
begin
  if FObject.RequestDate = 0 then
    edRequestDate.Text := ''
  else
    edRequestDate.Text := FormatDateTime('dd.mm.yyyy', FObject.RequestDate);
  edAddress.Text := FObject.Address;
  edProjectName.Text := FObject.ProjectName;
  edDocNumber.Text := FObject.DocNumber;
  if FObject.DocDate = 0 then
    edDocDate.Text := ''
  else
    edDocDate.Text := FormatDateTime('dd.mm.yyyy', FObject.DocDate);
  edRequestNumber.Text := FObject.RequestNumber;
  chbArchived.Checked := FObject.Archived;
  if FObject.Projected then
    cbProjected.ItemIndex := 0
  else
    cbProjected.ItemIndex := 1;
  cbProjected.Enabled := FCanChangeStatus;
  cbClass.Enabled := FCanChangeClass;
  chbConfirmed.Checked := FObject.Confirmed;
  if FObject.ConfirmDate = 0 then
    edConfirmDate.Text := ''
  else
    edConfirmDate.Text := FormatDateTime('dd.mm.yyyy', FObject.ConfirmDate);
  chbDismantled.Checked := FObject.Dismantled;
  chbChecked.Checked := FObject.Checked;
  edCustomer.Text := GetOrgName(FObject.CustomerOrgId);
  edExecutor.Text := GetOrgName(FObject.ExecutorOrgId);
  edOwner.Text := FObject.Owner;
  //
  if FCanChangeClass then
  begin
    ClassIds := FMPModule.Classifier.GetClassIdList();
    try
      cbClass.Items.Clear;
      for I := 0 to ClassIds.Count - 1 do
      begin
        ClassId := ClassIds[I];
        S := FMPModule.Classifier.GetClassName(ClassId);
        cbClass.Items.AddObject(S, TObject(ClassId));
      end;
    finally
      ClassIds.Free;
    end;
    cbClass.ItemIndex := 0;
  end
  else
  begin
    S := FMPModule.Classifier.GetClassName(FObject.MpClassId);
    cbClass.Items.Clear;
    cbClass.Items.AddObject(S, TObject(FObject.MpClassId));
    cbClass.ItemIndex := 0;
  end;
  //
  chbUnderground.Checked := FObject.Underground;
  spinDiameter.Value := FObject.Diameter;
  spinPipeCount.Value := FObject.PipeCount;
  spinVoltage.Value := FObject.Voltage;
  edDrawer.Text := GetOrgName(FObject.DrawOrgId);
  if FObject.DrawDate = 0 then
    edDrawDate.Text := ''
  else
    edDrawDate.Text := FormatDateTime('dd.mm.yyyy', FObject.DrawDate);
  spinRotation.Value := FObject.Rotation;
  edMaterial.Text := FObject.Material;
  edTop.Text := FObject.Top;
  edBottom.Text := FObject.Bottom;
  edFloor.Text := FObject.Floor;
  chbHasCertif.Checked := FObject.HasCertif;
  edCertifNumber.Text := FObject.CertifNumber;
  if FObject.CertifDate = 0 then
    edCertifDate.Text := ''
  else
    edCertifDate.Text := FormatDateTime('dd.mm.yyyy', FObject.CertifDate);
  edLinkedGuid.Text := FObject.LinkedObjectGuid;
  edObjGuid.Text := FObject.MPObjectGuid;
  //
  cbCheckState.ItemIndex := Integer(FObject.CheckState);
  //
  edDiamComment.Text := FObject.DiameterComment;
  edVoltComment.Text := FObject.VoltageComment;
  chbSewer.Checked := FObject.Sewer;
  cbPressure.ItemIndex := FObject.PressureIndex;
  cbVoltage.ItemIndex := FObject.VoltageIndex;
  mInfo.Text := FObject.Comment;
end;

function TmstEditMPObjectSemanticsDialog.SelectOrg(var Id: Integer; out OrgName: string): Boolean;
begin
  Result := mstClientAppModule.MapMngr.SelectOrg(Id, OrgName);
end;

procedure TmstEditMPObjectSemanticsDialog.WriteToObject;
begin
  FObject.RequestDate := GetDate(edRequestDate.Text);
  FObject.DocDate := GetDate(edDocDate.Text);
  FObject.DocNumber := edDocNumber.Text;
  FObject.Address := edAddress.Text;
  FObject.ProjectName := edProjectName.Text;
  FObject.RequestNumber := edRequestNumber.Text;
  FObject.Archived := chbArchived.Checked;
  FObject.Confirmed := chbConfirmed.Checked;
  FObject.ConfirmDate := GetDate(edConfirmDate.Text);
  FObject.Dismantled := chbDismantled.Checked;
  FObject.Checked := chbChecked.Checked;
  FObject.Owner := edOwner.Text;
  //
  FObject.Underground := chbUnderground.Checked;
  FObject.Diameter := Round(spinDiameter.Value);
  FObject.PipeCount := Round(spinPipeCount.Value);
  FObject.Voltage := Round(spinVoltage.Value);
  FObject.DrawDate := GetDate(edDrawDate.Text);
  FObject.Rotation := Round(spinRotation.Value);
  FObject.Material := edMaterial.Text;
  FObject.Top := edTop.Text;
  FObject.Bottom := edBottom.Text;
  FObject.Floor := edFloor.Text;
  FObject.HasCertif := chbHasCertif.Checked;
  FObject.CertifNumber := edCertifNumber.Text;
  FObject.CertifDate := GetDate(edCertifDate.Text);
  //
  FObject.DiameterComment := edDiamComment.Text;
  FObject.VoltageComment := edVoltComment.Text;
  FObject.Sewer := chbSewer.Checked;
  FObject.PressureIndex := cbPressure.ItemIndex;
  FObject.VoltageIndex := cbVoltage.ItemIndex;
  FObject.Comment := mInfo.Text;
  //
  if FCanChangeStatus then
  begin
    if cbProjected.ItemIndex = 1 then
    begin
      FObject.Drawn := True;
      FObject.Projected := False;
    end
    else
    begin
      FObject.Drawn := False;
      FObject.Projected := True;
    end;
  end;
  //
  if FCanChangeClass then
  begin
    FObject.MpClassId := Integer(cbClass.Items.Objects[cbClass.ItemIndex]);
  end;
  //
  FObject.CheckState := TmstMPObjectCheckState(cbCheckState.ItemIndex);
end;

end.
