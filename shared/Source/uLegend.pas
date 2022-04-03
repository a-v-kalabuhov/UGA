unit uLegend;

interface

uses
  Classes, Controls, Types, Forms, StdCtrls, Windows, Graphics;

type
  TkaLegendItem = class(TCollectionItem)
  private
    FColor: TColor;
    FCaption: ShortString;
  published
    property Color: TColor read FColor write FColor;
    property Caption: ShortString read FCaption write FCaption;
  end;

  TkaLegendCollection = class(TOwnedCollection)
  private
    function GetItem(Index: Integer): TkaLegendItem;
    procedure SetItem(Index: Integer; const Value: TkaLegendItem);
  public
    constructor Create(AOwner: TPersistent);
    function Add: TkaLegendItem;
    property Items[Index: Integer]: TkaLegendItem read GetItem write SetItem; default;
  end;

  TkaLegend = class(TComponent)
  private
    FLegend: TForm;
    FItems: TkaLegendCollection;
    FItemOffset: Integer;
    FFont: TFont;
    FCaption: String;
    procedure SetItemOffset(const Value: Integer);
    function GetItemHeight: Integer;
    function GetItemText(Index: Integer): ShortString;
    procedure SetItemText(Index: Integer; const Value: ShortString);
    function GetItemColor(Index: Integer): TColor;
    procedure SetItemColor(Index: Integer; const Value: TColor);
    procedure SetFont(const Value: TFont);
    procedure SetCaption(const Value: String);
    procedure ReadItems(Reader: TReader);
    procedure WriteItems(Writer: TWriter);
    procedure SetItems(const Value: TkaLegendCollection);
  protected
    procedure DefineProperties(Filer: TFiler); override;
    procedure CreateLegend; virtual;
    procedure LegendPaint(Sender: TObject); virtual;
    procedure Changed; virtual;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure ShowLegend(ATop, ALeft: Integer);
    function ItemCount: Integer;
    function Visible: Boolean;
    function FormWidth: Integer;
    function FormHeight: Integer;
    property ItemText[Index: Integer]: ShortString read GetItemText write SetItemText;
    property ItemColor[Index: Integer]: TColor read GetItemColor write SetItemColor;
  published
    property ItemOffset: Integer read FItemOffset write SetItemOffset;
    property Font: TFont read FFont write SetFont;
    property Caption: String read FCaption write SetCaption;
    property Items: TkaLegendCollection read FItems write SetItems;
  end;

implementation

uses
  uGC;

{ TkaLegend }

procedure TkaLegend.Changed;
begin
  if Assigned(FLegend) and FLegend.Visible then
  begin
  end;
end;

constructor TkaLegend.Create(AOwner: TComponent);
begin
  inherited;
  FFont := TFont.Create; 
  FItems := TkaLegendCollection.Create(Self);
  FLegend := nil;
end;

procedure TkaLegend.CreateLegend;
var
  ItemWidth: Integer;
  I: Integer;
begin
  if Assigned(FLegend) and not (csDestroying in FLegend.ComponentState) then
    Exit;
  FLegend := TForm.Create(Application);
  with FLegend do
  begin
    Caption := FCaption;
    FormStyle := fsStayOnTop;
    BorderStyle := bsToolWindow;
    Font.Assign(Self.Font);
    ClientHeight := FormHeight;
    ItemWidth := 0;
    for I := 0 to Pred(ItemCount) do
      if ItemWidth < Canvas.TextWidth(ItemText[I]) then
        ItemWidth := Canvas.TextWidth(ItemText[I]);
    ClientWidth := ItemWidth + 3 * ItemOffset + GetItemHeight;
    for I := 0 to Pred(ItemCount) do
    begin
      with TLabel.Create(FLegend) do
      begin
        Parent := FLegend;
        Caption := ItemText[I];
        Layout := tlTop;
        Top := ItemOffset + I * (GetItemHeight + ItemOffset);
        Left := 2 * ItemOffset + GetItemHeight;
      end;
    end;
    FLegend.OnPaint := LegendPaint;
  end;
end;

procedure TkaLegend.DefineProperties(Filer: TFiler);
begin
  inherited DefineProperties(Filer);
  Filer.DefineProperty('Items', ReadItems, WriteItems, True);
end;

destructor TkaLegend.Destroy;
begin
  if Assigned(FLegend) and not (csDestroying in FLegend.ComponentState) then
    FLegend.Release;
  FLegend := nil;
  FItems.Free;
  FFont.Free;
  inherited;
end;

function TkaLegend.FormHeight: Integer;
begin
  Result := ItemCount * (ItemOffset + GetItemHeight) + ItemOffset;
end;

function TkaLegend.FormWidth: Integer;
var
  FromLegend: Boolean;
  ItemWidth, I: Integer;
  ACanvas: TCanvas;
begin
  FromLegend := Assigned(FLegend) and not (csDestroying in ComponentState);
  if not FromLegend then
  begin
    with IObject(TBitmap.Create).AObject as TBitmap do
      ACanvas := Canvas;
    ACanvas.Font := Self.FFont;
  end
  else
    ACanvas := FLegend.Canvas;
  ItemWidth := 0;
  for I := 0 to Pred(ItemCount) do
    if ItemWidth < ACanvas.TextWidth(ItemText[I]) then
      ItemWidth := ACanvas.TextWidth(ItemText[I]);
  Result := ItemWidth + 3 * ItemOffset + GetItemHeight;
end;

function TkaLegend.GetItemColor(Index: Integer): TColor;
begin
  Result := TkaLegendItem(FItems.Items[Index]).Color;
end;

function TkaLegend.GetItemHeight: Integer;
begin
  if Assigned(FLegend) and not (csDestroying in FLegend.ComponentState) then
    Result := FLegend.Canvas.TextHeight('A')
  else
    Result := Abs(FFont.Height);
end;

function TkaLegend.GetItemText(Index: Integer): ShortString;
begin
  Result := TkaLegendItem(FItems.Items[Index]).Caption;
end;

function TkaLegend.ItemCount: Integer;
begin
  Result := FItems.Count;
end;

procedure TkaLegend.LegendPaint(Sender: TObject);
var
  I: Integer;
  R: TRect;
begin
  for I := 0 to Pred(FItems.Count) do
  begin
    FLegend.Canvas.Brush.Color := TkaLegendItem(FItems.Items[I]).Color;
    R := Rect(ItemOffset, I * (GetItemHeight + ItemOffset) + ItemOffset ,
      GetItemHeight + ItemOffset, I * (GetItemHeight + ItemOffset) + ItemOffset + GetItemHeight);
    FLegend.Canvas.Rectangle(R);
  end;
end;

procedure TkaLegend.ReadItems(Reader: TReader);
begin
  try
    Reader.ReadCollection(FItems);
  except
    FItems.Clear;
    raise;
  end;
end;

procedure TkaLegend.SetCaption(const Value: String);
begin
  if FCaption <> Value then
  begin
    FCaption := Value;
    Changed;
  end;
end;

procedure TkaLegend.SetFont(const Value: TFont);
begin
  FFont.Assign(Value);
  Changed;
end;

procedure TkaLegend.SetItemColor(Index: Integer; const Value: TColor);
begin
  if TkaLegendItem(FItems.Items[Index]).Color <> Value then
  begin
    TkaLegendItem(FItems.Items[Index]).Color := Value;
    Changed;
  end;
end;

procedure TkaLegend.SetItemOffset(const Value: Integer);
begin
  if FItemOffset <> Value then
  begin
    FItemOffset := Value;
    Changed;
  end;
end;

procedure TkaLegend.SetItems(const Value: TkaLegendCollection);
begin
  FItems.Assign(Value);
end;

procedure TkaLegend.SetItemText(Index: Integer; const Value: ShortString);
begin
  if TkaLegendItem(FItems.Items[Index]).Caption <> Value then
  begin
    TkaLegendItem(FItems.Items[Index]).Caption := Value;
    Changed;
  end;
end;

procedure TkaLegend.ShowLegend;
begin
  CreateLegend;
  FLegend.Top := ATop;
  FLegend.Left := ALeft;
  FLegend.Show;
end;

function TkaLegend.Visible: Boolean;
begin
  Result := Assigned(FLegend) and FLegend.Visible;
end;

procedure TkaLegend.WriteItems(Writer: TWriter);
begin
  Writer.WriteCollection(FItems);
end;

{ TkaLegendCollection }

function TkaLegendCollection.Add: TkaLegendItem;
begin
  Result := TkaLegendItem(inherited Add);
  Result.Color := clWhite;
  Result.Caption := '';
end;

constructor TkaLegendCollection.Create(AOwner: TPersistent);
begin
  inherited Create(AOwner, TkaLegendItem);
end;

function TkaLegendCollection.GetItem(Index: Integer): TkaLegendItem;
begin
  Result := inherited GetItem(Index) as TkaLegendItem;
end;

procedure TkaLegendCollection.SetItem(Index: Integer;
  const Value: TkaLegendItem);
begin
  inherited SetItem(Index, Value);
end;

end.
