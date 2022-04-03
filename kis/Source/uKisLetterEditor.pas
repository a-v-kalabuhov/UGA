unit uKisLetterEditor;

interface

{$I KisFlags.pas}

uses
  // System
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  StdCtrls, ComCtrls, Grids, DBGrids, Buttons, DB, ActnList,
  // Common
  uDBGrid,
  // Project
  uKisEntityEditor, Dialogs, JvBaseDlg, JvDesktopAlert;

type
  TKisLetterEditor = class(TKisEntityEditor)
    PageControl: TPageControl;
    tsData: TTabSheet;
    Label6: TLabel;
    Label5: TLabel;
    Label16: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    CustomerGroup2: TGroupBox;
    edFirmName: TEdit;
    btnFirmClear: TButton;
    btnFirmDetail: TButton;
    btnFirmSelect: TButton;
    mContent: TMemo;
    chExecuted: TCheckBox;
    edControlDate: TEdit;
    InGroup: TGroupBox;
    Label1: TLabel;
    Label2: TLabel;
    edDocDate: TEdit;
    edDocNumber: TEdit;
    CustomerGroup: TGroupBox;
    Label8: TLabel;
    Label9: TLabel;
    edOrgNumber: TEdit;
    edOrgDate: TEdit;
    AdmGroup: TGroupBox;
    Label11: TLabel;
    Label12: TLabel;
    edAdmNumber: TEdit;
    edAdmDate: TEdit;
    edExecutedInfo: TEdit;
    cbDocTypesName: TComboBox;
    cbOfficeName: TComboBox;
    GroupBox1: TGroupBox;
    Label10: TLabel;
    Label13: TLabel;
    edMPNumber: TEdit;
    edMPDate: TEdit;
    btnGenerateMPNumber: TButton;
    tsVisa: TTabSheet;
    VisaGroup: TGroupBox;
    dbgVisas: TkaDBGrid;
    tsAddition: TTabSheet;
    dbgOfficeDocs: TkaDBGrid;
    tsAddresses: TTabSheet;
    dbgAddresses: TkaDBGrid;
    btnAddAddress: TButton;
    btnDeleteAddress: TButton;
    btnEditAddress: TButton;
    dsAddresses: TDataSource;
    dsOfficeDocs: TDataSource;
    btnOfficeDocCreate: TButton;
    btnOfficeDocDelete: TButton;
    btnOfficeDocEdit: TButton;
    dsPassings: TDataSource;
    dsVisas: TDataSource;
    btnGenerateKGANumber: TButton;
    GroupBox2: TGroupBox;
    pcPassing: TPageControl;
    tsPassingMain: TTabSheet;
    btnNew: TSpeedButton;
    btnDel: TSpeedButton;
    btnShow: TSpeedButton;
    dbgPassings: TkaDBGrid;
    tsPassingAdditional: TTabSheet;
    dbgParentPassings: TkaDBGrid;
    dsParentPassings: TDataSource;
    Label7: TLabel;
    cbObjectType: TComboBox;
    tsOutcomLetters: TTabSheet;
    dbgOutcomLetters: TkaDBGrid;
    btnSelectOutcomLetter: TButton;
    btnDeleteOutcomLetter: TButton;
    dsOutcomLetters: TDataSource;
    btnEditOutcomLetter: TButton;
    Label14: TLabel;
    Edit1: TEdit;
    CheckBox1: TCheckBox;
    procedure btnNewClick(Sender: TObject);
    procedure btnDelClick(Sender: TObject);
    procedure btnShowClick(Sender: TObject);
    procedure btnOfficeDocCreateClick(Sender: TObject);
    procedure btnOfficeDocDeleteClick(Sender: TObject);
    procedure btnOfficeDocEditClick(Sender: TObject);
    procedure btnAddAddressClick(Sender: TObject);
    procedure btnDeleteAddressClick(Sender: TObject);
    procedure btnEditAddressClick(Sender: TObject);
    procedure tsVisaShow(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure btnDeleteOutcomLetterClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
  end;

implementation

{$R *.dfm}

uses
  uKisConsts, uKisAppModule;

procedure TKisLetterEditor.btnNewClick(Sender: TObject);
begin
  if ActiveControl = dbgPassings then
    dbgPassings.DataSource.DataSet.Append
  else
  if ActiveControl = dbgVisas then
    dbgVisas.DataSource.DataSet.Append;
end;

procedure TKisLetterEditor.btnDelClick(Sender: TObject);
begin
  if ActiveControl = dbgPassings then
  begin
    if not dbgPassings.DataSource.DataSet.IsEmpty then
      dbgPassings.DataSource.DataSet.Delete
  end
  else
  if ActiveControl = dbgVisas then
    if not dbgVisas.DataSource.DataSet.IsEmpty then
      dbgVisas.DataSource.DataSet.Delete;
end;

procedure TKisLetterEditor.btnShowClick(Sender: TObject);
begin
  if ActiveControl = dbgPassings then
  begin
    if not dbgPassings.DataSource.DataSet.IsEmpty then
      dbgPassings.DataSource.DataSet.Edit
  end
  else
  if ActiveControl = dbgVisas then
    if not dbgVisas.DataSource.DataSet.IsEmpty then
      dbgVisas.DataSource.DataSet.Edit;
end;

procedure TKisLetterEditor.btnOfficeDocCreateClick(Sender: TObject);
begin
  inherited;
  dbgOfficeDocs.DataSource.DataSet.Insert;
end;

procedure TKisLetterEditor.btnOfficeDocDeleteClick(Sender: TObject);
begin
  inherited;
  if not dbgOfficeDocs.DataSource.DataSet.IsEmpty then
  if MessageBox(Handle, PChar(S_CONFIRM_DELETE_RECORD), PChar(S_WARN), MB_YESNO + MB_ICONQUESTION) = ID_YES then
    dbgOfficeDocs.DataSource.DataSet.Delete;
end;

procedure TKisLetterEditor.btnOfficeDocEditClick(Sender: TObject);
begin
  inherited;
  if not dbgOfficeDocs.DataSource.DataSet.IsEmpty then
    dbgOfficeDocs.DataSource.DataSet.Edit;
end;

procedure TKisLetterEditor.btnAddAddressClick(Sender: TObject);
begin
  inherited;
  dbgAddresses.DataSource.DataSet.Insert;
end;

procedure TKisLetterEditor.btnDeleteAddressClick(Sender: TObject);
begin
  inherited;
  if not dbgAddresses.DataSource.DataSet.IsEmpty then
  if MessageBox(Handle, PChar(S_CONFIRM_DELETE_RECORD), PChar(S_WARN), MB_YESNO + MB_ICONQUESTION) = ID_YES then
    dbgAddresses.DataSource.DataSet.Delete;
end;

procedure TKisLetterEditor.btnEditAddressClick(Sender: TObject);
begin
  inherited;
  if not dbgAddresses.DataSource.DataSet.IsEmpty then
    dbgAddresses.DataSource.DataSet.Edit;
end;

procedure TKisLetterEditor.tsVisaShow(Sender: TObject);
begin
  inherited;
  dbgVisas.SetFocus;
end;

procedure TKisLetterEditor.FormShow(Sender: TObject);
begin
  inherited;
  pcPassing.ActivePageIndex := 0;
  AppModule.ReadGridProperties(Self, dbgVisas);
  AppModule.ReadGridProperties(Self, dbgOfficeDocs);
  AppModule.ReadGridProperties(Self, dbgAddresses);
  AppModule.ReadGridProperties(Self, dbgPassings);
  AppModule.ReadGridProperties(Self, dbgParentPassings);
  AppModule.ReadGridProperties(Self, dbgOutcomLetters);
end;

procedure TKisLetterEditor.btnDeleteOutcomLetterClick(Sender: TObject);
begin
  inherited;
  if not dbgOutcomLetters.DataSource.DataSet.IsEmpty then
  if MessageBox(Handle, PChar(S_CONFIRM_DELETE_RECORD), PChar(S_WARN), MB_YESNO + MB_ICONQUESTION) = ID_YES then
    dbgOutcomLetters.DataSource.DataSet.Delete;
end;

procedure TKisLetterEditor.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  inherited;
  AppModule.WriteGridProperties(Self, dbgVisas);
  AppModule.WriteGridProperties(Self, dbgOfficeDocs);
  AppModule.WriteGridProperties(Self, dbgAddresses);
  AppModule.WriteGridProperties(Self, dbgPassings);
  AppModule.WriteGridProperties(Self, dbgParentPassings);
  AppModule.WriteGridProperties(Self, dbgOutcomLetters);
end;

end.
