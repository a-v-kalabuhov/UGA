unit uKisAccontForm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  StdCtrls,
  uCommonUtils,
  uKisEntityEditor, Dialogs, JvBaseDlg, JvDesktopAlert;

type
  TKisAccountForm = class(TKisEntityEditor)
    GroupBox1: TGroupBox;
    Label1: TLabel;
    edBIK: TEdit;
    btnFind: TButton;
    mBank: TMemo;
    GroupBox2: TGroupBox;
    Label2: TLabel;
    cbType: TComboBox;
    Label3: TLabel;
    edNumber: TEdit;
    cbDefault: TCheckBox;
    btnSelect: TButton;
    procedure edNumberKeyPress(Sender: TObject; var Key: Char);
    procedure edBIKKeyUp(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure edBIKChange(Sender: TObject);
    procedure FormKeyUp(Sender: TObject; var Key: Word;
      Shift: TShiftState);
  end;

implementation

{$R *.dfm}

procedure TKisAccountForm.edNumberKeyPress(Sender: TObject; var Key: Char);
begin
  if not (Key in [#8, #13, #22, '0'..'9']) then
  begin
    Key := #0;
    Beep;
  end;
end;

procedure TKisAccountForm.edBIKKeyUp(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  inherited;
  if (Key = 13) and (ssCtrl in Shift) then
    btnFind.Click;
end;

procedure TKisAccountForm.edBIKChange(Sender: TObject);
begin
  inherited;
  btnFind.Enabled := ((Length(edBIK.Text)) = 9) and (StrIsNumber(edBIK.Text));
end;

procedure TKisAccountForm.FormKeyUp(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  inherited;
  if Key = VK_ESCAPE then
    ModalResult := mrCancel;
end;

end.
