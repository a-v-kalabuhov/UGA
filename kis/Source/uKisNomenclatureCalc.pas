unit uKisNomenclatureCalc;

interface

{$I KisFlags.pas}

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, 
  StdCtrls, ExtCtrls;

type
  TKisNomenclatureCalc = class(TForm)
    edtNomen: TEdit;
    Label3: TLabel;
    GroupBox1: TGroupBox;
    Label1: TLabel;
    edtX: TEdit;
    edtY: TEdit;
    Label2: TLabel;
    btnShowPoint: TButton;
    GroupBox2: TGroupBox;
    Label5: TLabel;
    Edit1: TEdit;
    Edit2: TEdit;
    Edit3: TEdit;
    Edit4: TEdit;
    btnShowCase: TButton;
    Edit5: TEdit;
    Edit6: TEdit;
    Edit7: TEdit;
    Edit8: TEdit;
    Label4: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    Label8: TLabel;
    Label9: TLabel;
    Shape1: TShape;
    Label10: TLabel;
    Label11: TLabel;
    Label12: TLabel;
    Label13: TLabel;
    Shape2: TShape;
    Shape3: TShape;
    Shape4: TShape;
    Shape5: TShape;
    CheckBox1: TCheckBox;
    procedure btnShowPointClick(Sender: TObject);
    procedure btnShowCaseClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

  procedure ShowNomenclatureCalculator;

implementation

{$R *.DFM}

uses
  uKisConsts, uGeoUtils, uGeoTypes;

procedure ShowNomenclatureCalculator;
begin
  with TKisNomenclatureCalc.Create(Application) do
  try
    ShowModal;
  finally
    Release;
  end;
end;

procedure TKisNomenclatureCalc.btnShowPointClick(Sender: TObject);
begin
  edtNomen.Text := TGeoUtils.GetNomenclature500(StrToFloat(edtX.Text), StrToFloat(edtY.Text));
end;

procedure TKisNomenclatureCalc.btnShowCaseClick(Sender: TObject);
var
  x1, x2, x3, x4, y1, y2, y3, y4: Integer;
  Map500: TNomenclature;
begin
  Map500.Init(edtNomen.Text, False);
  if Map500.Valid then
  begin
    x1 := Map500.Top500;
    y1 := Map500.Left500;
    x2 := x1;
    y2 := y1 + 250;
    x3 := x1 - 250;
    y3 := y2;
    x4 := x3;
    y4 := y1;
    Edit1.Text := FloatToStr(x1);
    Edit2.Text := FloatToStr(y1);
    Edit3.Text := FloatToStr(x2);
    Edit4.Text := FloatToStr(y2);
    Edit5.Text := FloatToStr(x3);
    Edit6.Text := FloatToStr(y3);
    Edit7.Text := FloatToStr(x4);
    Edit8.Text := FloatToStr(y4);
  end
  else
  begin
    Edit1.Text := S___;
    Edit2.Text := S___;
    Edit3.Text := S___;
    Edit4.Text := S___;
    Edit5.Text := S___;
    Edit6.Text := S___;
    Edit7.Text := S___;
    Edit8.Text := S___;
  end;
end;

end.
