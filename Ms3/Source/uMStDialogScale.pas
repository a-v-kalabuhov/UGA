unit uMStDialogScale;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls;

type
  TmstScaleDialogForm = class(TForm)
    Label1: TLabel;
    ComboBox1: TComboBox;
    btnOK: TButton;
    btnCancel: TButton;
  end;

  function SelectScale(var pScale: Double): Boolean;

implementation

{$R *.dfm}

function SelectScale(var pScale: Double): Boolean;
var
  s: String;
begin
  with TmstScaleDialogForm.Create(Application) do
  begin
    ComboBox1.Text := Format('%.2f', [pScale]);
    result := ShowModal = mrOK;
    if result then
    begin
      s := StringReplace(ComboBox1.Text, ',', '.', [rfReplaceAll]);
      pScale := StrToFloat(s);
    end;
    Release;
  end;
end;

end.
