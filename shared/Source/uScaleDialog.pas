unit uScaleDialog;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls;

type
  TfrmSetScale = class(TForm)
    Label1: TLabel;
    ComboBox1: TComboBox;
    Button1: TButton;
    Button2: TButton;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

  function SelectScale(var pScale: Double): Boolean;

implementation

{$R *.dfm}

function SelectScale(var pScale: Double): Boolean;
var
  S: String;
begin
  with TfrmSetScale.Create(Application) do
  begin
    ComboBox1.Text := Format('%8.2f', [pScale]);
    Result := ShowModal = mrOK;
    if Result then
    begin
      S := StringReplace(ComboBox1.Text, ',', '.', [rfReplaceAll]);
      pScale := StrTofloat(S);
    end;
    Release;
  end;
end;

end.
