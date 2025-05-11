unit uMStDialogMPBrowserFilter;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ComCtrls, StdCtrls,
  //
  uMStClassesProjectsBrowserMP;

type
  TmstMPBrowserFilterDialog = class(TForm)
    Label1: TLabel;
    edAddress: TEdit;
    btnOK: TButton;
    btnCancel: TButton;
    gbDateProject: TGroupBox;
    Label4: TLabel;
    Label5: TLabel;
    dtpDateProject1: TDateTimePicker;
    dtpDateProject2: TDateTimePicker;
    Label9: TLabel;
    edDocNumber: TEdit;
    chbArchived: TLabel;
    chbConfirmed: TLabel;
    chbDismantled: TLabel;
    chbUndergroud: TLabel;
    ComboBox1: TComboBox;
    ComboBox2: TComboBox;
    ComboBox3: TComboBox;
    ComboBox4: TComboBox;
    Label2: TLabel;
    ComboBox5: TComboBox;
  private
    FFilter: TmstProjectsBrowserFilterMP;
    procedure DisplayFilter();
    procedure UpdateFilter();
  public
    function Execute(aFilter: TmstProjectsBrowserFilterMP): Boolean;
  end;

var
  mstMPBrowserFilterDialog: TmstMPBrowserFilterDialog;

implementation

{$R *.dfm}

{ TmstMPBrowserFilterDialog }

procedure TmstMPBrowserFilterDialog.DisplayFilter;
begin
  edAddress.Text := FFilter.Address;
  edDocNumber.Text := FFilter.DocNumber;
  dtpDateProject1.DateTime := FFilter.DocDateStart;
  dtpDateProject2.DateTime := FFilter.DocDateEnd;
  ComboBox1.ItemIndex := Integer(FFilter.Archived);
  ComboBox2.ItemIndex := Integer(FFilter.Confirmed);
  ComboBox3.ItemIndex := Integer(FFilter.Dismantled);
  ComboBox4.ItemIndex := Integer(FFilter.Underground);
  ComboBox5.ItemIndex := Integer(FFilter.NeedCheck);
end;

function TmstMPBrowserFilterDialog.Execute(aFilter: TmstProjectsBrowserFilterMP): Boolean;
begin
  FFilter := aFilter;
  DisplayFilter();
  Result := ShowModal = mrOK;
  if Result then
  begin
    UpdateFilter();
  end;
end;

procedure TmstMPBrowserFilterDialog.UpdateFilter;
begin
  FFilter.Address := edAddress.Text;
  FFilter.DocNumber := edDocNumber.Text;
  FFilter.DocDateStart := dtpDateProject1.DateTime;
  FFilter.DocDateEnd := dtpDateProject2.DateTime;
  FFilter.Archived := TBoolValue(ComboBox1.ItemIndex);
  FFilter.Confirmed := TBoolValue(ComboBox2.ItemIndex);
  FFilter.Dismantled := TBoolValue(ComboBox3.ItemIndex);
  FFilter.Underground := TBoolValue(ComboBox4.ItemIndex);
  FFilter.NeedCheck := TBoolValue(ComboBox5.ItemIndex);
//  FFilter.Customer := edCustomer.Text;
//  FFilter.Executor := edExecutor.Text;
//  FFilter.Diameter := edDiameter.Text;
//  FFilter.Voltage := edVoltage.Text;
//  FFilter.Info := edInfo.Text;
//  FFilter.ConfirmDateStart := dtpDateConfirm1.DateTime;
//  FFilter.ConfirmDateEnd := dtpDateConfirm2.DateTime;
//  FFilter.UseConfirmed := cbStatus.ItemIndex <> 2;
end;

end.
