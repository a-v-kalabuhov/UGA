unit uKisMapScanGeometry;

interface

uses
  SysUtils, Classes, Types, Contnrs, Graphics;

type
  TMapSquare = 1..25;
  TKisMapGeometry = class
  private
    fSquares: TBits;
    FNomenclature: string;
    FFull: Boolean;
    FBmpSize: TSize;
    procedure SetNomenclature(const Value: string);
    procedure SetFull(const Value: Boolean);
    function GetSquares(Idx: TMapSquare): Boolean;
    procedure SetSquares(Idx: TMapSquare; const Value: Boolean);
  private
    function GetSquareRect(const SquareIdx: TMapSquare): TRect;
  public
    constructor Create;
    destructor Destroy; override;
    //
    procedure ApplyGeometry(aBitmap: TBitmap; const EmptyColor: TColor);
    //
    property Full: Boolean read FFull write SetFull;
    property Nomenclature: string read FNomenclature write SetNomenclature;
    property Squares[Idx: TMapSquare]: Boolean read GetSquares write SetSquares;
  end;

  TKisMapScanGeometry = class
  private
    fList: TObjectList;
  public
    constructor Create;
    destructor Destroy; override;
    //
    function AddMap(const aNomenclature: string; Full: Boolean): TKisMapGeometry;
    function GetMapGeometry(const aNomenclature: string): TKisMapGeometry;
  end;

  TRectList = class
  private
    fCount: Integer;
    fRects: array[0..24] of TRect;
    function GetItems(Index: Integer): TRect;
  public
    constructor Create;
    destructor Destroy; override;
    //
    procedure Add(const aRect: TRect);
    property Count: Integer read fCount;
    property Items[Index: Integer]: TRect read GetItems;
  end;

implementation

{ TKisMapGeometry }

procedure TKisMapGeometry.ApplyGeometry(aBitmap: TBitmap; const EmptyColor: TColor);
var
  I: Integer;
  Rects: TRectList;
  R: TRect;
  NewBmp: TBitmap;
begin
  if Full then
    Exit;
  Rects := TRectList.Create;
  try
    FBmpSize.cx := aBitmap.Width;
    FBmpSize.cy := aBitmap.Height;
    for I := 0 to Pred(fSquares.Size) do
    begin
      if fSquares[I] then
      begin
        R := GetSquareRect(I + 1);
        Rects.Add(R);
      end;
    end;
    NewBmp := TBitmap.Create;
    try
      NewBmp.PixelFormat := aBitmap.PixelFormat;
      NewBmp.SetSize(aBitmap.Width, aBitmap.Height);
      NewBmp.Canvas.Brush.Color := EmptyColor;
      NewBmp.Canvas.Brush.Style := bsSolid;
      NewBmp.Canvas.FillRect(Rect(0, 0, aBitmap.Width, aBitmap.Height));
      //
      NewBmp.Canvas.CopyMode := cmSrcCopy;
      for I := 0 to Rects.Count - 1 do
      begin
        R := Rects.Items[I];
        NewBmp.Canvas.CopyRect(R, aBitmap.Canvas, R);
      end;
      //
      aBitmap.Assign(NewBmp);
    finally
      FreeAndNil(NewBmp);
    end;
  finally
    Rects.Free;
  end;
end;

constructor TKisMapGeometry.Create;
begin
  fSquares := TBits.Create;
end;

destructor TKisMapGeometry.Destroy;
begin
  fSquares.Free;
  inherited;
end;

function TKisMapGeometry.GetSquareRect(const SquareIdx: TMapSquare): TRect;
var
  IdxTop, IdxLeft: Integer;
  W, H: Double;
  I: Integer;
  Xmarks: array[0..5] of Integer;
  Ymarks: array[0..5] of Integer;
begin
  IdxTop := Pred(SquareIdx) div 5;
  IdxLeft := Pred(SquareIdx) - IdxTop * 5;
  W := FBmpSize.cx / 5;
  H := FBmpSize.cy / 5;
  XMarks[0] := 0;
  XMarks[5] := FBmpSize.cx;
  for I := 1 to 4 do
    XMarks[I] := Round(W * I);
  YMarks[0] := 0;
  YMarks[5] := FBmpSize.cy;
  for I := 1 to 4 do
    YMarks[I] := Round(H * I);
  Result.Left := XMarks[IdxLeft];
  Result.Right := XMarks[IdxLeft + 1];
  Result.Top := YMarks[IdxTop];
  Result.Bottom := YMarks[IdxTop + 1];
end;

function TKisMapGeometry.GetSquares(Idx: TMapSquare): Boolean;
begin
  Result := fSquares[Idx - 1];
end;

procedure TKisMapGeometry.SetFull(const Value: Boolean);
begin
  FFull := Value;
end;

procedure TKisMapGeometry.SetNomenclature(const Value: string);
begin
  FNomenclature := Value;
end;

procedure TKisMapGeometry.SetSquares(Idx: TMapSquare; const Value: Boolean);
begin
  fSquares[Idx - 1] := Value;
end;

{ TKisMapScanGeometry }

function TKisMapScanGeometry.AddMap(const aNomenclature: string; Full: Boolean): TKisMapGeometry;
var
  Map: TKisMapGeometry;
begin
  Map := TKisMapGeometry.Create;
  fList.Add(Map);
  Map.Nomenclature := aNomenclature;
  Map.Full := Full;
  Result := Map;
end;

constructor TKisMapScanGeometry.Create;
begin
  fList := TObjectList.Create;
end;

destructor TKisMapScanGeometry.Destroy;
begin
  fList.Free;
  inherited;
end;

function TKisMapScanGeometry.GetMapGeometry(const aNomenclature: string): TKisMapGeometry;
var
  I: Integer;
begin
  for I := 0 to fList.Count - 1 do
    if TKisMapGeometry(fList[I]).Nomenclature = aNomenclature then
    begin
      Result := TKisMapGeometry(fList[I]);
      Exit;
    end;
  Result := nil;
end;

{ TRectList }

procedure TRectList.Add(const aRect: TRect);
begin
  if fCount > 24 then
    raise Exception.Create('Превышен размер списка квадратов!');
  fRects[fCount] := aRect;
  Inc(fCount);
end;

constructor TRectList.Create;
begin
  fCount := 0;
end;

destructor TRectList.Destroy;
begin

  inherited;
end;

function TRectList.GetItems(Index: Integer): TRect;
begin
  Result := fRects[Index];
end;

end.
