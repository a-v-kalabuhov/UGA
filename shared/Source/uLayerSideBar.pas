unit uLayerSideBar;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  uSideBar, ExtCtrls, Buttons, EzBaseGIS;

type
  TLayerName = string;

  TLayerSideBar = class(TSideBar)
    procedure FrameResize(Sender: TObject);
  private
    FGIS: TEzBaseGIS;
    FLayerCtrlCount: Integer;
    FCurrent: TLayerName;
    FOnSelectLayer: TNotifyEvent;
    procedure SetCurrent(const Value: TLayerName);
    procedure SelectLayer(Sender: TObject);
  public
    property OnSelectLayer: TNotifyEvent read FOnSelectLayer write FOnSelectLayer;
    property Current: TLayerName read FCurrent write SetCurrent;
    procedure Initialize(GIS: TEzBaseGIS);
    procedure AddLayer(LayerName, VisibleName: String);
    procedure RemoveLayer(pLayerName: String; IsVisibleName: Boolean = False);
  end;

implementation

{$R *.dfm}

uses
  uLayerControl;

{ TGtLayerSideBar }

procedure TLayerSideBar.AddLayer(LayerName, VisibleName: String);
var
  LayerControl: TLayerControlFrame;
  bmp: TBitmap;
  Layer: TEzBaseLayer;
begin
  Layer := FGIS.Layers.LayerByName(LayerName);
  if Layer = nil then Exit;
  LayerControl := TLayerControlFrame.Create(BarPanel);
//  BarPanel.InsertControl(LayerControl);
  LayerControl.Parent := BarPanel;
  LayerControl.Name := 'LayerControl' + LayerName;
  LayerControl.Initialize(Self, FGIS, LayerName, VisibleName);
  LayerControl.OnNameClick := SelectLayer;
  LayerControl.Width := BarPanel.Width;
  LayerControl.Left := 0;
  LayerControl.Top := FLayerCtrlCount * LayerControl.Height + 2;
  Bmp := TBitmap.Create;
  Bmp.LoadFromResourceName(HInstance, 'LVISIBLE');
  LayerControl.GlyphVisible := Bmp;
  Bmp.LoadFromResourceName(HInstance, 'LINVISIBLE');
  LayerControl.GlyphInVisible := Bmp;
  Bmp.Free;
  Inc(FLayerCtrlCount);
  LayerControl.FrameResize(nil);
end;

procedure TLayerSideBar.Initialize(GIS: TEzBaseGIS);
var
  I: Integer;
begin
  FGIS := GIS;
  FLayerCtrlCount := 0;
  for I := BarPanel.ControlCount - 1 downto 0 do
    if BarPanel.Controls[I] is TLayerControlFrame then
      BarPanel.RemoveControl(Controls[I]);
  FrameResize(nil);
end;

procedure TLayerSideBar.RemoveLayer(pLayerName: String;
  IsVisibleName: Boolean);
var
  I, J, H: Integer;
begin
  H := 0;
  J := 0;
  for i := 0 to BarPanel.ControlCount - 1 do
  if BarPanel.Controls[I] is TLayerControlFrame then
  with BarPanel.Controls[I] as TLayerControlFrame do
    if LayerName = pLayerName then
    begin
      H := Height;
      BarPanel.RemoveControl(Controls[I]);
      J := I;
      BREAK;
    end;
  for I := J to BarPanel.ControlCount - 1 do
  if BarPanel.Controls[I] is TLayerControlFrame then
    BarPanel.Controls[I].Top := BarPanel.Controls[I].Top - H;
end;

procedure TLayerSideBar.FrameResize(Sender: TObject);
var
  I: Integer;
begin
  inherited;
  for I := 0 to BarPanel.ControlCount - 1 do
    if BarPanel.Controls[I] is TLayerControlFrame then
    with BarPanel.Controls[I] as TLayerControlFrame do
    begin
      Width := BarPanel.Width;
      FrameResize(nil);
    end;
end;

procedure TLayerSideBar.SetCurrent(const Value: TLayerName);
var
  I: Integer;
begin
  if Value = FCurrent then exit;
  for I := 0 to BarPanel.ControlCount -1 do
  if BarPanel.Controls[I] is TLayerControlFrame then
  with BarPanel.Controls[I] as TLayerControlFrame do
  begin
    Selected := (LayerName = Value);
  end;   
  FCurrent := Value;
end;

procedure TLayerSideBar.SelectLayer(Sender: TObject);
begin
  if Assigned(FOnSelectLayer) then FOnSelectLayer(Sender);
end;

end.
