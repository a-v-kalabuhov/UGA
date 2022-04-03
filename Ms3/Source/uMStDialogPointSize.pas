unit uMStDialogPointSize;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls;

type
  TmstDialogPointSize = class(TForm)
    edSize: TEdit;
    Label1: TLabel;
    btnOK: TButton;
    btnCancel: TButton;
    procedure btnOKClick(Sender: TObject);
    procedure edSizeChange(Sender: TObject);
  end;

var
  mstDialogPointSize: TmstDialogPointSize;

implementation

{$R *.dfm}

procedure TmstDialogPointSize.btnOKClick(Sender: TObject);
begin
  ModalResult := mrOK;
end;

procedure TmstDialogPointSize.edSizeChange(Sender: TObject);
var
  Sz: Double;
begin
  btnOK.Enabled := TryStrToFloat(edSize.Text, Sz);
  if btnOK.Enabled then
    edSize.Color := clWindow
  else
    edSize.Color := $9999FF;
end;

end.
