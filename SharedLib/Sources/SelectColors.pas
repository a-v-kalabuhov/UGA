unit SelectColors;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, Buttons;

type
  TfrmSelectColors = class(TForm)
    Shape1: TShape;
    Shape2: TShape;
    StaticText1: TStaticText;
    StaticText2: TStaticText;
    BitBtn1: TBitBtn;
    BitBtn2: TBitBtn;
    BitBtn3: TBitBtn;
    ColorDialog: TColorDialog;
    procedure BitBtn1Click(Sender: TObject);
    procedure BitBtn2Click(Sender: TObject);
  private
    C1, C2: Integer;
  public
    { Public declarations }
  end;

  function SetColors(BrushEnabled: Boolean; var Color1, Color2: Integer): Boolean;

implementation

{$R *.dfm}

function SetColors(BrushEnabled: Boolean; var Color1, Color2: Integer): Boolean;
begin
  with TfrmSelectColors.Create(Application) do
  begin
    C1 := Color1;
    C2 := Color2;
    Shape1.Brush.Color := C1;
    Shape2.Brush.Color := C2;
    BitBtn2.Enabled := BrushEnabled;
    result := ShowModal = mrOK;
    if result then
    begin
      Color1 := C1;
      Color2 := C2;
    end;
    Release;
  end;
end;

procedure TfrmSelectColors.BitBtn1Click(Sender: TObject);
begin
  with ColorDialog do
  begin
    Color := C1;
    if Execute then
    begin
      C1 := Color;
      Shape1.Brush.Color := C1;
    end;
  end;
end;

procedure TfrmSelectColors.BitBtn2Click(Sender: TObject);
begin
  with ColorDialog do
  begin
    Color := C2;
    if Execute then
    begin
      C2 := Color;
      Shape2.Brush.Color := C2;
    end;
  end;
end;

end.
