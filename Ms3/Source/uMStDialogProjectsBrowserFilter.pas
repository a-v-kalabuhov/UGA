unit uMStDialogProjectsBrowserFilter;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ComCtrls,
  uMStClassesProjectsBrowser;

type
  TmstProjectBrowserFilterDialog = class(TForm)
    Label1: TLabel;
    edAddress: TEdit;
    btnOK: TButton;
    btnCancel: TButton;
    Label2: TLabel;
    edCustomer: TEdit;
    Label3: TLabel;
    edExecutor: TEdit;
    Label7: TLabel;
    edDiameter: TEdit;
    Label8: TLabel;
    edVoltage: TEdit;
    Label9: TLabel;
    cbStatus: TComboBox;
    gbDateConfirm: TGroupBox;
    dtpDateConfirm1: TDateTimePicker;
    dtpDateConfirm2: TDateTimePicker;
    Label10: TLabel;
    Label11: TLabel;
    gbDateProject: TGroupBox;
    Label4: TLabel;
    Label5: TLabel;
    dtpDateProject1: TDateTimePicker;
    dtpDateProject2: TDateTimePicker;
    Label6: TLabel;
    edInfo: TEdit;
    procedure cbStatusChange(Sender: TObject);
  private
    FFilter: TmstProjectsBrowserFilter;
    procedure DisplayFilter();
    procedure UpdateFilter();
  public
    function Execute(aFilter: TmstProjectsBrowserFilter): Boolean;
  end;

var
  mstProjectBrowserFilterDialog: TmstProjectBrowserFilterDialog;

implementation

{$R *.dfm}

procedure TmstProjectBrowserFilterDialog.cbStatusChange(Sender: TObject);
begin
  gbDateConfirm.Enabled := cbStatus.ItemIndex = 0;
  if gbDateConfirm.Enabled then
  begin
    dtpDateConfirm1.ParentColor := False;
    dtpDateConfirm2.ParentColor := False;
    dtpDateConfirm1.Color := clWindow;
    dtpDateConfirm2.Color := clWindow;
  end
  else
  begin
    dtpDateConfirm1.ParentColor := True;
    dtpDateConfirm2.ParentColor := True;
  end;
end;

procedure TmstProjectBrowserFilterDialog.DisplayFilter;
begin
  edAddress.Text := FFilter.Address;
  edCustomer.Text := FFilter.Customer;
  edExecutor.Text := FFilter.Executor;
  edDiameter.Text := FFilter.Diameter;
  edVoltage.Text := FFilter.Voltage;
  edInfo.Text := FFilter.Info;
  dtpDateProject1.DateTime := FFilter.DocDateStart;
  dtpDateProject2.DateTime := FFilter.DocDateEnd;
  dtpDateConfirm1.DateTime := FFilter.ConfirmDateStart;
  dtpDateConfirm2.DateTime := FFilter.ConfirmDateEnd;
  if FFilter.UseConfirmed then
  begin
    if FFilter.Confirmed then
      cbStatus.ItemIndex := 0
    else
      cbStatus.ItemIndex := 1;
  end
  else
    cbStatus.ItemIndex := 2;
end;

function TmstProjectBrowserFilterDialog.Execute(aFilter: TmstProjectsBrowserFilter): Boolean;
begin
  FFilter := aFilter;
  DisplayFilter();
  Result := ShowModal = mrOK;
  if Result then
  begin
    UpdateFilter();
  end;
end;

procedure TmstProjectBrowserFilterDialog.UpdateFilter;
begin
  FFilter.Address := edAddress.Text;
  FFilter.Customer := edCustomer.Text;
  FFilter.Executor := edExecutor.Text;
  FFilter.Diameter := edDiameter.Text;
  FFilter.Voltage := edVoltage.Text;
  FFilter.Info := edInfo.Text;
  FFilter.DocDateStart := dtpDateProject1.DateTime;
  FFilter.DocDateEnd := dtpDateProject2.DateTime;
  FFilter.ConfirmDateStart := dtpDateConfirm1.DateTime;
  FFilter.ConfirmDateEnd := dtpDateConfirm2.DateTime;
  FFilter.UseConfirmed := cbStatus.ItemIndex <> 2;
  FFilter.Confirmed := cbStatus.ItemIndex = 0;
end;

end.
