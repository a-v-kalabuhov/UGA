unit uKisScanningListEditor;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, uKisEntityEditor, StdCtrls, JvBaseDlg, JvDesktopAlert;

type
  TKisScanningListEditor = class(TKisEntityEditor)
    Label1: TLabel;
    edDateOfScan: TEdit;
    Label2: TLabel;
    edOrderNumber: TEdit;
    Label3: TLabel;
    cbOffice: TComboBox;
    Label4: TLabel;
    cbExecutor: TComboBox;
    Label5: TLabel;
    edWorkType: TEdit;
    procedure FormShow(Sender: TObject);
  end;


implementation

{$R *.dfm}

procedure TKisScanningListEditor.FormShow(Sender: TObject);
begin
  inherited;
  if edDateOfScan.Text = '' then
    edDateOfScan.Text := DateToStr(Date);
end;

end.
