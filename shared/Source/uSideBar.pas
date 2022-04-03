unit uSideBar;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Buttons, ExtCtrls;

type
  TSideBar = class(TFrame)
    BarControlButton: TSpeedButton;
    BarPanel: TPanel;
    procedure FrameResize(Sender: TObject);
    procedure BarControlButtonClick(Sender: TObject);
  private
    PanelWidth: Integer;
    PanelHeight: Integer;
    bmp1, bmp2, bmp3, bmp4: TBitmap;
    cur_glyph: String;
    Loaded: Boolean;
    FBarControlSize: Integer;
    FBarShowingHint: String;
    FBarHiddenHint: String;
    FOnMinimize: TNotifyEvent;
    FOnMaximize: TNotifyEvent;
    procedure ButtonPaint;
    procedure LoadRes;
    procedure ReAlignControls;
    procedure SetBarControlSize(const Value: Integer);
    procedure SetBarShowingHint(const Value: String);
    procedure SetBarHiddenHint(const Value: String);
    function GetMinimized: Boolean;
  published
    property BarControlSize: Integer read FBarControlSize write SetBarControlSize default 7;
    property BarShowingHint: String read FBarShowingHint write SetBarShowingHint;
    property BarHiddenHint: String read FBarHiddenHint write SetBarHiddenHint;
    property Minimized: Boolean read GetMinimized;
    property OnMinimize: TNotifyEvent read FOnMinimize write FOnMinimize;
    property OnMaximize: TNotifyEvent read FOnMaximize write FOnMaximize;
  end;

implementation

{$R *.dfm}
{$R gt1.RES}

procedure TSideBar.ButtonPaint;
var
  bmp: TBitmap;
  new_glyph: String;
begin
    case BarControlButton.Align of
    alLeft :
      if BarPanel.Visible then
      begin
        bmp := bmp1;
        new_glyph := 'BMPRIGHT';
      end
      else
      begin
        bmp := bmp2;
        new_glyph := 'BMPLEFT';
      end;
    alright :
      if BarPanel.Visible then
      begin
        bmp := bmp2;
        new_glyph := 'BMPLEFT';
      end
      else
      begin
        bmp := bmp1;
        new_glyph := 'BMPRIGHT';
      end;
    alTop :
      if BarPanel.Visible then
      begin
        bmp := bmp3;
        new_glyph := 'BMPDOWN';
      end
      else
      begin
        bmp := bmp4;
        new_glyph := 'BMPUP';
      end;
    alBottom :
      if BarPanel.Visible then
      begin
        bmp := bmp4;
        new_glyph := 'BMPUP';
      end
      else
      begin
        bmp := bmp3;
        new_glyph := 'BMPDOWN';
      end;
    else
      exit;
    end;
    if new_glyph <> cur_glyph then
    begin
      BarControlButton.Glyph := bmp;
      cur_glyph := new_glyph;
    end;
//    ShowMessage(IntToStr(Button1.Glyph.Width));
end;

procedure TSideBar.LoadRes;
begin
  FBarControlSize := 7;
  bmp1 := TBitmap.Create;
  bmp1.LoadFromResourceName(HInstance, 'BMPRIGHT');
  bmp2 := TBitmap.Create;
  bmp2.LoadFromResourceName(HInstance, 'BMPLEFT');
  bmp3 := TBitmap.Create;
  bmp3.LoadFromResourceName(HInstance, 'BMPDOWN');
  bmp4 := TBitmap.Create;
  bmp4.LoadFromResourceName(HInstance, 'BMPUP');
end;

procedure TSideBar.FrameResize(Sender: TObject);
begin
  if BarPanel.Visible then
    BarControlButton.Hint := FBarShowingHint
  else
    BarControlButton.Hint := FBarHiddenHint;
  PanelWidth := BarPanel.Width;
  PanelHeight := BarPanel.Height;
  if not Loaded then LoadRes;
  BarPanel.Align := alNone;
  ReAlignControls;
  ButtonPaint;
  BarPanel.Align := alClient;
end;

procedure TSideBar.ReAlignControls;
begin
  case ALign of
  alLeft:
    begin
      BarControlButton.Align := alRight;
      BarControlButton.Width := FBarControlSize;
    end;
  alRight:
    begin
      BarControlButton.Align := alLeft;
      BarControlButton.Width := FBarControlSize;
    end;
  alTop:
    begin
      BarControlButton.Align := alBottom;
      BarControlButton.Height := FBarControlSize;
    end;
  alBottom:
    begin
      BarControlButton.Align := alTop;
      BarControlButton.Height := FBarControlSize;
    end;
  else
    BarControlButton.Align := alLeft;
  end;
end;

procedure TSideBar.BarControlButtonClick(Sender: TObject);
begin
  BarPanel.Visible := not BarPanel.Visible;
  if BarPanel.Visible then
  begin
    if Assigned(FOnMaximize) then FOnMaximize(Sender);
    case BarControlButton.Align of
    alLeft, alRight:
      begin
        Width := BarControlButton.Width + PanelWidth;
      end;
    alTop, alBottom:
      begin
        Height := BarControlButton.Height + PanelHeight;
      end;
    end
  end
  else
  begin
    if Assigned(FOnMinimize) then FOnMinimize(Sender);
    case BarControlButton.Align of
    alLeft, alRight:
      begin
        Width := BarControlButton.Width;
      end;
    alTop, alBottom:
      begin
        Height := BarControlButton.Height;
      end;
    end;
  end;
end;

procedure TSideBar.SetBarControlSize(const Value: Integer);
begin
  FBarControlSize := Value;
  FrameResize(nil);
end;

procedure TSideBar.SetBarShowingHint(const Value: String);
begin
  FBarShowingHint := Value;
end;

procedure TSideBar.SetBarHiddenHint(const Value: String);
begin
  FBarHiddenHint := Value;
end;

function TSideBar.GetMinimized: Boolean;
begin
  Result := not BarPanel.Visible;
end;

end.

