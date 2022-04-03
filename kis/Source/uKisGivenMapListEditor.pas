unit uKisGivenMapListEditor;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, uKisEntityEditor, StdCtrls, ExtCtrls, JvBaseDlg, JvDesktopAlert;

type
  TKisGivenMapListEditor = class(TKisEntityEditor)
    gbSender: TGroupBox;
    Label4: TLabel;
    edOrgname: TEdit;
    Label5: TLabel;
    cbPeople: TComboBox;
    RadBtnOrgs: TRadioButton;
    RadBtnMP: TRadioButton;
    gbBack: TGroupBox;
    Label6: TLabel;
    edDateOfBack: TEdit;
    gbGive: TGroupBox;
    Label1: TLabel;
    edDateOfGive: TEdit;
    cbPersonWhoGive: TComboBox;
    edTermOfGive: TEdit;
    Label3: TLabel;
    Label10: TLabel;
    Label9: TLabel;
    edAddress: TEdit;
    Label7: TLabel;
    edDefinitionNumber: TEdit;
    Label8: TLabel;
    edOrderNumber: TEdit;
    edContacter: TEdit;
    btnSelectOrg: TButton;
    cbOffices: TComboBox;
    procedure FormShow(Sender: TObject);
  end;

implementation

{$R *.dfm}

procedure TKisGivenMapListEditor.FormShow(Sender: TObject);
begin
  inherited;
  if Trim(edOrderNumber.Text) = '' then
    edOrderNumber.Text := 'нет';
end;

end.

