unit uKisDlgSelectAreaLayer;

interface

uses Windows, SysUtils, Classes, Graphics, Forms, Controls, StdCtrls,
  Buttons, ExtCtrls;

type
  TKisSelectAleaLayerDialog = class(TForm)
    OKBtn: TButton;
    CancelBtn: TButton;
    RadioGroup1: TRadioGroup;
  private
    { Private declarations }
  public
    class function ShowDlg(Layers: TStrings; out SelIndex: Integer): Boolean;
  end;

implementation

{$R *.dfm}

{ TKisSelectAleaLayerDialog }

class function TKisSelectAleaLayerDialog.ShowDlg(Layers: TStrings; out SelIndex: Integer): Boolean;
var
  Dlg: TKisSelectAleaLayerDialog;
begin
//  raise Exception.Create('TKisSelectAleaLayerDialog.ShowDlg');
  //
  SelIndex := 0;
  Dlg := TKisSelectAleaLayerDialog.Create(Application);
  try
    Dlg.RadioGroup1.Items.AddStrings(Layers);
    Dlg.RadioGroup1.ItemIndex := 0;
    Result := Dlg.ShowModal = mrOk;
    if Result then
      SelIndex := Dlg.RadioGroup1.ItemIndex;
  finally
    Dlg.Free;
  end;
end;

end.
