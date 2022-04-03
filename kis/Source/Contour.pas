unit Contour;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, 
  StdCtrls, ExtCtrls, ComCtrls,
  uKisAllotmentClasses, JvExStdCtrls, JvCombobox, JvColorCombo;

type
  TContourForm = class(TForm)
    btnOk: TButton;
    btnCancel: TButton;
    Label1: TLabel;
    edtNumber: TEdit;
    udNumber: TUpDown;
    rgPositive: TRadioGroup;
    cbEnabled: TCheckBox;
    chbClosed: TCheckBox;
    Label2: TLabel;
    Edit1: TEdit;
    ColorList1: TJvColorComboBox;
    Label3: TLabel;
  public
    class function EditContourParams(Contour: TContour; MaxNum: Integer): Boolean;
  end;

implementation

{$R *.DFM}

class function TContourForm.EditContourParams(Contour: TContour; MaxNum: Integer): Boolean;
begin
  with TContourForm.Create(Application) do
  try
    udNumber.Min := 1;
    udNumber.Max := 999;
    udNumber.Position := Contour.Id;
    cbEnabled.Checked := Contour.Enabled;
    chbClosed.Checked := Contour.Closed;
    Edit1.Text := Contour.Name;
    rgPositive.ItemIndex := Integer(Contour.Positive);
    ColorList1.ColorValue := Contour.Color;
    Result := ShowModal = mrOk;
    if Result then
    begin
      Contour.Id := udNumber.Position;
      Contour.Name := Edit1.Text;
      if Trim(Contour.Name) = '' then
        Contour.Name := IntToStr(Contour.Id);
      Contour.Enabled := cbEnabled.Checked;
      Contour.Closed := chbClosed.Checked;
      Contour.Positive := Boolean(rgPositive.ItemIndex);
      Contour.Color := ColorList1.ColorValue;
    end;
  finally
    Free;
  end;
end;

end.
