unit uLayerControl;

interface

uses 
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, 
  StdCtrls, Buttons, EzBaseGIS;

type
  TLayerControlFrame = class(TFrame)
    lName: TLabel;
    Button: TSpeedButton;
    procedure ButtonClick(Sender: TObject);
    procedure lNameClick(Sender: TObject);
    procedure FrameResize(Sender: TObject);
  private
    FParentBar: TFrame;
    FSelected: Boolean;
    FGlyphVisible: TBitmap;
    FGlyphInVisible: TBitmap;
    FLayerName, FVisibleName: String;
    FGIS: TEzBaseGIS;
    FOnNameClick: TNotifyEvent;
    procedure SetSelected(const Value: Boolean);
    procedure SetGlyphVisible(const Value: TBitmap);
    procedure SetGlyphInVisible(const Value: TBitmap);
  public
    index: Integer;
    property Selected: Boolean read FSelected write SetSelected;
    property OnNameClick: TNotifyEvent read FOnNameClick write FOnNameClick;
    property GlyphVisible: TBitmap read FGlyphVisible write SetGlyphVisible;
    property GlyphInVisible: TBitmap read FGlyphInVisible write SetGlyphInVisible;
    property LayerName: String read FLayerName;
    procedure Initialize(ParentBar: TFrame; GIS: TEzBaseGIS; LayerName, VisibleName: String);
    procedure UpdateControlState;
  end;

implementation

{$R *.dfm}

uses
  uLtConsts, uLayerSideBar;

procedure TLayerControlFrame.ButtonClick(Sender: TObject);
var
  Layer: TEzBaseLayer;
begin
  Layer := FGIS.Layers.LayerByName(FLayerName);
  if Layer <> nil then
  begin
    Layer.LayerInfo.Visible := not Layer.LayerInfo.Visible;
    UpdateControlState;
    FGIS.RepaintViewports;
  end;
end;

procedure TLayerControlFrame.Initialize(ParentBar: TFrame; GIS: TEzBaseGIS; LayerName, VisibleName: String);
begin
  FParentBar := ParentBar;
  FGIS := GIS;
  FLayerName := LayerName;
  FVisibleName := VisibleName;
  lName.Caption := FVisibleName;
  lName.Hint := FVisibleName;
  if FGIS.CurrentLayerName = FLayerName then Selected := True;
  UpdateControlState;
end;

procedure TLayerControlFrame.lNameClick(Sender: TObject);
begin
  Selected := true;
  with FParentBar as TLayerSideBar do Current := LayerName;
  if Assigned(FOnNameClick) then FOnNameClick(Sender);
end;

procedure TLayerControlFrame.SetGlyphInVisible(const Value: TBitmap);
begin
  if FGlyphInVisible = nil then FGlyphInVisible := TBitmap.Create;
  FGlyphInVisible.Assign(Value);
  UpdateControlState;
end;

procedure TLayerControlFrame.SetGlyphVisible(const Value: TBitmap);
begin
  if FGlyphVisible = nil then FGlyphVisible := TBitmap.Create;
  FGlyphVisible.Assign(Value);
  UpdateControlState;
end;

procedure TLayerControlFrame.SetSelected(const Value: Boolean);
begin
  if FSelected = Value then exit;
  FSelected := Value;
  if FSelected then
  begin
    lName.Font.Color := clRed;
    lName.Font.Style := lName.Font.Style + [fsBold];
    FGIS.CurrentLayerName := FLayerName;
  end
  else
  begin
    lName.Font.Color := clBlack;
    lName.Font.Style := lName.Font.Style - [fsBold];
  end;
end;

procedure TLayerControlFrame.FrameResize(Sender: TObject);
var
  TextWidth: Integer;
begin
  Button.Left := Width - 4 - Button.Width;
  lName.Left := 4;
  lName.Width := Button.Left - 8;
  TextWidth := lName.Canvas.TextWidth(lName.Caption);
  lName.ShowHint := TextWidth > lName.Width;
end;

procedure TLayerControlFrame.UpdateControlState;
var
  Layer: TEzBaseLayer;
begin
  Layer := FGIS.Layers.LayerByName(FLayerName);
  if Layer <> nil then
  if Layer.LayerInfo.Visible then
  begin
    Button.Glyph := FGlyphVisible;
    Button.Hint := S_SHOW_LAYER;
  end
  else
  begin
    Button.Glyph := FGlyphInVisible;
    Button.Hint := S_HIDE_LAYER;
  end;
end;

end.
