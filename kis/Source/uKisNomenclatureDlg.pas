unit uKisNomenclatureDlg;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms, Dialogs, StdCtrls,
  // shared
  uGeoUtils, uCommonUtils;

type
  TKisNomenclatureDlg = class(TForm)
    ComboBox1: TComboBox;
    ComboBox5: TComboBox;
    Button1: TButton;
    Button2: TButton;
    ComboBox2: TComboBox;
    ComboBox3: TComboBox;
    ComboBox4: TComboBox;
  private
    function IntExecute(var Nomenclature: String): Boolean;
  public
    class function Execute(var Nomenclature: String): Boolean;
  end;

implementation

{$R *.dfm}

var
  Dlg: TKisNomenclatureDlg;

{ TKisNomenclatureDlg }

class function TKisNomenclatureDlg.Execute(var Nomenclature: String): Boolean;
begin
  if Dlg = nil then
    Application.CreateForm(TKisNomenclatureDlg, Dlg);
  Result := Dlg.IntExecute(Nomenclature);
end;

function TKisNomenclatureDlg.IntExecute(var Nomenclature: String): Boolean;
var
  L: TStringList;
  I, J: Integer;
  Part: String;
begin
  L := TStringList.Create;
  try
    ComboBox1.ItemIndex := 0;
    ComboBox2.ItemIndex := 0;
    ComboBox3.ItemIndex := 0;
    ComboBox4.ItemIndex := 0;
    ComboBox5.ItemIndex := 0;
    TGeoUtils.GetNomenclatureParts(Nomenclature, L);
    for I := 0 to Pred(L.Count) do
    begin
      Part := L[I];
      case I of
      0 :
          begin
            if Part <> '' then
            begin
              if Part[1] = '0' then
              begin
                ComboBox1.ItemIndex := 1;
                Delete(Part, 1, 1);
              end;
            end;
            if Part <> '' then
            begin
              J := ComboBox2.Items.IndexOf(Part);
              if J >= 0 then
                ComboBox2.ItemIndex := J;
            end;
          end;
      1 :
          begin
            if Part <> '' then
            begin
              if Part[1] = '0' then
              begin
                ComboBox3.ItemIndex := 1;
                Delete(Part, 1, 1);
              end;
            end;
            if Part <> '' then
            begin
              J := ComboBox4.Items.IndexOf(Part);
              if J >= 0 then
                ComboBox4.ItemIndex := J;
            end;
          end;
      2 :
          begin
            if Part <> '' then
            begin
              J := ComboBox5.Items.IndexOf(Part);
              if J >= 0 then
                ComboBox5.ItemIndex := J;
            end;
          end;
      end;
    end;
  finally
    FreeAndNil(L);
  end;
  //
  Result := ShowModal = mrOK;
  //
  if Result then
  begin
    Nomenclature := Trim(ComboBox1.Text) + Trim(ComboBox2.Text) + '-' +
      Trim(ComboBox3.Text) + Trim(ComboBox4.Text) + '-' + Trim(ComboBox5.Text);
  end;
end;

end.
