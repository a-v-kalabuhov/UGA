unit uMStDialogCertifNumber;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls;

type
  TmstMPCertifDialog = class(TForm)
    Label1: TLabel;
    edNumber: TEdit;
    Label2: TLabel;
    edDate: TEdit;
    btnOK: TButton;
    btnCancel: TButton;
    procedure btnOKClick(Sender: TObject);
  private
    FDate: TDateTime;
    FNumber: string;
  public
    function Execute(var CertifNumber: string; var CertifDate: TDateTime): Boolean;
  end;

implementation

{$R *.dfm}

{ TmstMPCertifDialog }

procedure TmstMPCertifDialog.btnOKClick(Sender: TObject);
var
  S: string;
begin
  FNumber := Trim(edNumber.Text);
  if FNumber = '' then
  begin
    edNumber.SelectAll;
    edNumber.SetFocus;
    ShowMessage('Заполните поле номер!');
    Exit;
  end;
  S := Trim(edDate.Text);
  if S = '' then
    FDate := 0
  else
  if not TryStrToDate(S, FDate) then
  begin
    edDate.SelectAll;
    edDate.SetFocus;
    ShowMessage('Заполните поле дата!');
    Exit;
  end;
  ModalResult := mrOk;
end;

function TmstMPCertifDialog.Execute(var CertifNumber: string; var CertifDate: TDateTime): Boolean;
begin
  edNumber.Text := CertifNumber;
  if CertifDate = 0 then
    edDate.Text := ''
  else
    edDate.Text := DateToStr(CertifDate);
  Result := ShowModal = mrOk;
  if Result then
  begin
    CertifNumber := FNumber;
    CertifDate := FDate;
  end;
end;

end.
