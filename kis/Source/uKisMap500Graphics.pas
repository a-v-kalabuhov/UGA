unit uKisMap500Graphics;

{$I KisFlags.pas}

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  uKisEntityEditor, StdCtrls, ExtCtrls, Buttons, Dialogs, ComCtrls, JvBaseDlg,
  JvDesktopAlert;

type
  TKisSelectColorEvent = procedure (Color: TColor) of object;

  TKisMap500Graphics = class(TKisEntityEditor)
    Panel1: TPanel;
    PaintBox: TPaintBox;
    Panel2: TPanel;
    btnDrawLine: TSpeedButton;
    btnDrawArea: TSpeedButton;
    btnDeleteLastPoint: TSpeedButton;
    btnCommit: TSpeedButton;
    btnBlack: TSpeedButton;
    Bevel1: TBevel;
    btnRed: TSpeedButton;
    btnGreen: TSpeedButton;
    btnPurple: TSpeedButton;
    btnBlue: TSpeedButton;
    btnRed2: TSpeedButton;
    btnSelColor: TSpeedButton;
    procedure btnBlackClick(Sender: TObject);
    procedure btnRedClick(Sender: TObject);
    procedure btnGreenClick(Sender: TObject);
    procedure btnPurpleClick(Sender: TObject);
    procedure btnBlueClick(Sender: TObject);
    procedure btnRed2Click(Sender: TObject);
    procedure btnSelColorClick(Sender: TObject);
  private
    FOnSelectColor: TKisSelectColorEvent;
    procedure DoSelectColor(Color: TColor);
  public
    property OnSelectColor: TKisSelectColorEvent read FOnSelectColor
      write FOnSelectColor;
  end;


implementation

{$R *.dfm}

{ TKisMap500Graphics }

procedure TKisMap500Graphics.DoSelectColor(Color: TColor);
begin
  if Assigned(FOnSelectColor) then
    FOnSelectColor(Color);
end;

procedure TKisMap500Graphics.btnBlackClick(Sender: TObject);
begin
  DoSelectColor(clBlack);
  btnBlack.Down := True;
end;

procedure TKisMap500Graphics.btnRedClick(Sender: TObject);
begin
  inherited;
  DoSelectColor(clRed);
  btnRed.Down := True;
end;

procedure TKisMap500Graphics.btnGreenClick(Sender: TObject);
begin
  inherited;
  DoSelectColor(clGreen);
  btnGreen.Down := True;
end;

procedure TKisMap500Graphics.btnPurpleClick(Sender: TObject);
begin
  inherited;
  DoSelectColor(clFuchsia);
  btnPurple.Down := True;
end;

procedure TKisMap500Graphics.btnBlueClick(Sender: TObject);
begin
  inherited;
  DoSelectColor(clBlue);
  btnBlue.Down := True;
end;

procedure TKisMap500Graphics.btnRed2Click(Sender: TObject);
begin
  inherited;
  DoSelectColor(clMaroon);
  btnRed2.Down := True;
end;

procedure TKisMap500Graphics.btnSelColorClick(Sender: TObject);
begin
  inherited;
  with TColorDialog.Create(Self) do
  begin
    if Execute then
      DoSelectColor(Color);
  end;
end;

end.
