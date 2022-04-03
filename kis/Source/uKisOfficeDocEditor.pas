unit uKisOfficeDocEditor;

interface

{$I KisFlags.pas}

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, DB, Grids, DBGrids, Buttons,
  ComCtrls,
  JvBaseDlg, JvDesktopAlert,
  // Common
  uDBGrid, uCommonUtils,
  // Project
  uKisEntityEditor, uKisConsts, uKisAppModule;

type
  TKisOfficeDocEditor = class(TKisEntityEditor)
    dsLetters: TDataSource;
    dsExecutors: TDataSource;
    dsVisas: TDataSource;
    dsPhases: TDataSource;
    dsOrders: TDataSource;
    PageControl: TPageControl;
    tsMain: TTabSheet;
    Label9: TLabel;
    Label1: TLabel;
    Label2: TLabel;
    Label11: TLabel;
    Label7: TLabel;
    Label3: TLabel;
    cbDocTypes: TComboBox;
    edDocDate: TEdit;
    edDocNumber: TEdit;
    mInformation: TMemo;
    gbExecutors: TGroupBox;
    btnAddExecutor: TSpeedButton;
    btnDeleteExecutor: TSpeedButton;
    dbgExecutors: TkaDBGrid;
    gbIncoming: TGroupBox;
    btnLetterShow: TSpeedButton;
    btnLetterDel: TSpeedButton;
    btnLetterNew: TSpeedButton;
    dbgLetters: TDBGrid;
    edObjectAddress: TEdit;
    cbStatus: TComboBox;
    cbObjectType: TComboBox;
    tsProgress: TTabSheet;
    dbgPhases: TkaDBGrid;
    btnPhaseAdd: TButton;
    btnPhaseDelete: TButton;
    btnPhaseEdit: TButton;
    tsOrders: TTabSheet;
    dbgOrders: TkaDBGrid;
    btnOrderCreate: TButton;
    btnOrderEdit: TButton;
    btnOrderDelete: TButton;
    tsDecreeProject: TTabSheet;
    Label8: TLabel;
    Label10: TLabel;
    btnDecreeProjectCreate: TBitBtn;
    btnDecreeProjectSelect: TBitBtn;
    btnDecreeProjectClear: TBitBtn;
    edSeqNumber: TEdit;
    mHeader: TMemo;
    GroupBox3: TGroupBox;
    dbgVisas: TkaDBGrid;
    lEndDate: TLabel;
    edEndDate: TEdit;
    btnOrderPrint: TButton;
    procedure btnLetterNewClick(Sender: TObject);
    procedure btnLetterDelClick(Sender: TObject);
    procedure edDocNumberKeyPress(Sender: TObject; var Key: Char);
    procedure edBillDateKeyPress(Sender: TObject; var Key: Char);
    procedure btnAddExecutorClick(Sender: TObject);
    procedure btnDeleteExecutorClick(Sender: TObject);
    procedure dbgExecutorsExit(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormShow(Sender: TObject);
    procedure dbgPhasesExit(Sender: TObject);
    procedure btnPhaseAddClick(Sender: TObject);
    procedure cbStatusChange(Sender: TObject);
    procedure dbgPhasesCellColors(Sender: TObject; Field: TField;
      var Background, FontColor: TColor; State: TGridDrawState;
      var FontStyle: TFontStyles);
    procedure btnOkClick(Sender: TObject);
  private
    FEndDateUpdate: Boolean;
  end;

implementation

{$R *.dfm}

procedure TKisOfficeDocEditor.btnLetterNewClick(Sender: TObject);
begin
  inherited;
  Self.dbgLetters.DataSource.DataSet.Append;
end;

procedure TKisOfficeDocEditor.btnOkClick(Sender: TObject);
begin
  inherited;
;
end;

procedure TKisOfficeDocEditor.btnLetterDelClick(Sender: TObject);
begin
  inherited;
  if not dbgLetters.DataSource.DataSet.IsEmpty then
    dbgLetters.DataSource.DataSet.Delete;
end;

procedure TKisOfficeDocEditor.edDocNumberKeyPress(Sender: TObject;
  var Key: Char);
begin
  inherited;
  if not (Key in (NumberChars + [#8])) then
    Key := #0;
end;

procedure TKisOfficeDocEditor.edBillDateKeyPress(Sender: TObject;
  var Key: Char);
begin
  inherited;
  if not (Key in (NumberChars + [#8, '.'])) then
    Key := #0;
end;

procedure TKisOfficeDocEditor.btnAddExecutorClick(Sender: TObject);
begin
  inherited;
  if Assigned(dsExecutors.DataSet) then
    dsExecutors.DataSet.Append;
end;

procedure TKisOfficeDocEditor.btnDeleteExecutorClick(Sender: TObject);
begin
  inherited;
  if Assigned(dsExecutors.DataSet) and not dsExecutors.DataSet.IsEmpty then
  if Application.MessageBox(PChar(S_CONFIRM_DELETE_EXECUTOR), PChar(S_CONFIRM), MB_YESNO + MB_ICONQUESTION)= ID_YES then
    dsExecutors.DataSet.Delete;
end;

procedure TKisOfficeDocEditor.dbgExecutorsExit(Sender: TObject);
begin
  inherited;
  if Assigned(dbgExecutors.DataSource) then
  if Assigned(dbgExecutors.DataSource.DataSet) then
  if dbgExecutors.DataSource.DataSet.State in [dsInsert, dsEdit] then
    dbgExecutors.DataSource.DataSet.Post;
end;

procedure TKisOfficeDocEditor.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  inherited;
  AppModule.WriteGridProperties(Self, dbgLetters);
  AppModule.WriteGridProperties(Self, dbgExecutors);
  AppModule.WriteGridProperties(Self, dbgVisas);
  AppModule.WriteGridProperties(Self, dbgOrders);
end;

procedure TKisOfficeDocEditor.FormShow(Sender: TObject);
var
  aUserIsAdmin: Boolean;
begin
  inherited;
  AppModule.ReadGridProperties(Self, dbgLetters);
  AppModule.ReadGridProperties(Self, dbgExecutors);
  AppModule.ReadGridProperties(Self, dbgVisas);
  AppModule.ReadGridProperties(Self, dbgOrders);
  PageControl.ActivePageIndex := 0;

  with AppModule.User do
  begin
    aUserIsAdmin := IsAdministrator;
    btnAddExecutor.Enabled := CanSheduleWorks or aUserIsAdmin;
    btnDeleteExecutor.Enabled := CanSheduleWorks or aUserIsAdmin;
    btnOrderCreate.Enabled := CanSheduleWorks or aUserIsAdmin;
    btnOrderDelete.Enabled := CanSheduleWorks or aUserIsAdmin;
    btnLetterNew.Enabled := CanSheduleWorks or aUserIsAdmin;
    btnLetterDel.Enabled := CanSheduleWorks or aUserIsAdmin;
    cbStatus.Enabled := CanSheduleWorks or aUserIsAdmin;
  end;
end;

procedure TKisOfficeDocEditor.dbgPhasesCellColors(Sender: TObject;
  Field: TField; var Background, FontColor: TColor; State: TGridDrawState;
  var FontStyle: TFontStyles);
begin
  inherited;
  if (dsPhases.DataSet.FieldByName(SF_EXECUTOR_ID).AsInteger <> AppModule.User.PeopleId) or
     (dsPhases.DataSet.RecNo <> dsPhases.DataSet.RecordCount)
  then
  begin
    BackGround := clBtnFace;
  end;
end;

procedure TKisOfficeDocEditor.dbgPhasesExit(Sender: TObject);
begin
  inherited;
  if dbgPhases.DataSource.DataSet.State in [dsInsert, dsEdit] then
    dbgPhases.DataSource.DataSet.Post;
end;

procedure TKisOfficeDocEditor.btnPhaseAddClick(Sender: TObject);
begin
  inherited;
  if Assigned(dbgPhases.DataSource) then
  if Assigned(dbgPhases.DataSource.DataSet) then
  if not (dbgPhases.DataSource.DataSet.State in [dsInsert, dsEdit]) then
    dbgPhases.DataSource.DataSet.Append;
end;

procedure TKisOfficeDocEditor.cbStatusChange(Sender: TObject);
begin
  if FEndDateUpdate then
    Exit;
  FEndDateUpdate := True;
  try
  lEndDate.Visible := cbStatus.ItemIndex > 0;
  edEndDate.Visible := cbStatus.ItemIndex > 0;
  if not edEndDate.Visible then
    edEndDate.Clear
  else
    edEndDate.Text := FormatDateTime(S_DATESTR_FORMAT, Date);
  finally
    FEndDateUpdate := False;
  end;
end;

end.
