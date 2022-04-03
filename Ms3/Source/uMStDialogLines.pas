unit uMStDialogLines;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, ComCtrls, Buttons;

type
  TmstDialogLines = class(TForm)
    shSelectedColor: TShape;
    Label1: TLabel;
    Label2: TLabel;
    shLotsColor: TShape;
    Label3: TLabel;
    shActualColor: TShape;
    Label4: TLabel;
    shAnnulColor: TShape;
    edSelectedWidth: TEdit;
    edLotsWidth: TEdit;
    edActualWidth: TEdit;
    edAnnulWidth: TEdit;
    btnOK: TButton;
    Button2: TButton;
    SpeedButton1: TSpeedButton;
    SpeedButton2: TSpeedButton;
    SpeedButton3: TSpeedButton;
    SpeedButton4: TSpeedButton;
    ColorDialog: TColorDialog;
    procedure SpeedButton1Click(Sender: TObject);
    procedure SpeedButton2Click(Sender: TObject);
    procedure SpeedButton3Click(Sender: TObject);
    procedure SpeedButton4Click(Sender: TObject);
    procedure edSelectedWidthChange(Sender: TObject);
    procedure edLotsWidthChange(Sender: TObject);
    procedure edActualWidthChange(Sender: TObject);
    procedure edAnnulWidthChange(Sender: TObject);
  private
    procedure CheckTexts;
  end;

implementation

{$R *.dfm}

procedure TmstDialogLines.SpeedButton1Click(Sender: TObject);
begin
  ColorDialog.Color := shSelectedColor.Brush.Color;
  if ColorDialog.Execute then
    shSelectedColor.Brush.Color := ColorDialog.Color;
end;

procedure TmstDialogLines.SpeedButton2Click(Sender: TObject);
begin
  ColorDialog.Color := shLotsColor.Brush.Color;
  if ColorDialog.Execute then
    shLotsColor.Brush.Color := ColorDialog.Color;
end;

procedure TmstDialogLines.SpeedButton3Click(Sender: TObject);
begin
  ColorDialog.Color := shActualColor.Brush.Color;
  if ColorDialog.Execute then
    shActualColor.Brush.Color := ColorDialog.Color;
end;

procedure TmstDialogLines.SpeedButton4Click(Sender: TObject);
begin
  ColorDialog.Color := shAnnulColor.Brush.Color;
  if ColorDialog.Execute then
    shAnnulColor.Brush.Color := ColorDialog.Color;
end;

procedure TmstDialogLines.edSelectedWidthChange(Sender: TObject);
begin
  CheckTexts;
end;

procedure TmstDialogLines.CheckTexts;
var
  F: Double;
  B: Boolean;
begin
  B := TryStrToFloat(edSelectedWidth.Text, F);
  if B then
    B := TryStrToFloat(edLotsWidth.Text, F);
  if B then
    B := TryStrToFloat(edActualWidth.Text, F);
  if B then
    B := TryStrToFloat(edAnnulWidth.Text, F);
  btnOK.Enabled := B;
end;

procedure TmstDialogLines.edLotsWidthChange(Sender: TObject);
begin
  CheckTexts;
end;

procedure TmstDialogLines.edActualWidthChange(Sender: TObject);
begin
  CheckTexts;
end;

procedure TmstDialogLines.edAnnulWidthChange(Sender: TObject);
begin
  CheckTexts;
end;

end.
