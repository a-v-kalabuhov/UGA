unit uMStFormMeasureResult;

interface

uses
  // System
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  StdCtrls, ExtCtrls, Buttons;

type
  TfrmMeasureResult = class(TForm)
    Label3: TLabel;
    edArea: TEdit;
    Label4: TLabel;
    edLength: TEdit;
    Label1: TLabel;
    edLastLength: TEdit;
    Bevel1: TBevel;
    edNewLength: TEdit;
    edNewGrad: TEdit;
    Label2: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    edNewMin: TEdit;
    Label8: TLabel;
    edNewSec: TEdit;
    Label9: TLabel;
    btnGo: TSpeedButton;
    procedure edNewLengthChange(Sender: TObject);
    procedure edNewGradChange(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private
    function GetbtnGoEnabled: Boolean;
  end;

  procedure ShowMeasureResult(const Area: Double = -1;
                              const Perimeter: Double = -1;
                              const LastLength: Double = -1;
                              const Angle: Double = -1;
                              const NumPoints: Double = -1);

  procedure CloseMeasureResult;

var
  frmMeasureResult: TfrmMeasureResult;

implementation

{$R *.dfm}

procedure ShowMeasureResult(const Area: Double = -1;
                            const Perimeter: Double = -1;
                            const LastLength: Double = -1;
                            const Angle: Double = -1;
                            const NumPoints: Double = -1);
begin
  if not Assigned(frmMeasureResult) then
    frmMeasureResult := TfrmMeasureResult.Create(Application);
  with frmMeasureResult do
  begin
    if Area >= 0 then
      edArea.Text := Format('%0.2f', [Area]);
    if Perimeter >= 0 then
      edLength.Text := Format('%0.2f', [Perimeter]);
    if LastLength >= 0 then
      edLastLength.Text := Format('%0.2f', [LastLength]);
    if not Visible then
    begin
      Show;
    end
    else
      Update;
  end;
end;

procedure CloseMeasureResult;
begin
  if Assigned(frmMeasureResult) then
    frmMeasureResult.Close;
end;

procedure TfrmMeasureResult.edNewLengthChange(Sender: TObject);
var
  f: Double;
begin
  with edNewLength do
  if TryStrToFloat(Text, f) then
    Color := clWindow
  else
    Color := $00A0A0FF;
  btnGo.Enabled := GetbtnGoEnabled;
end;

function TfrmMeasureResult.GetbtnGoEnabled: Boolean;
var
  f: Double;
  I: Integer;
begin
  Result := TryStrToFloat(edNewLength.Text, f) and
            TryStrToInt(edNewGrad.Text, I) and
            TryStrToInt(edNewMin.Text, I) and
            TryStrToInt(edNewSec.Text, I);
end;

procedure TfrmMeasureResult.edNewGradChange(Sender: TObject);
var
  I: Integer;
begin
  if Sender is TEdit then
  with TEdit(Sender) do
    if TryStrToInt(Text, I) then
      Color := clWindow
    else
      Color := $00A0A0FF;
  btnGo.Enabled := GetbtnGoEnabled;
end;

procedure TfrmMeasureResult.FormShow(Sender: TObject);
begin
  btnGo.Enabled := GetbtnGoEnabled;
end;

end.
