unit uKisMapScanGeometry;

interface

uses
  SysUtils, Classes, Types, Contnrs, Windows, Graphics,
  EzLib, EzEntities, EzPolyClip, EzBase, EzBaseGis,
  uGC, uGraphics, uGeoUtils;

type
  TMapSquare = 1..25;

  /// <summary>
  /// √еометри€ одного планшета при выдаче скана.  
  /// </summary>
  TKisMapGeometry = class
  private
    fSquares: TBits;
    FNomenclature: string;
    FFull: Boolean;
    FBmpSize: TSize;
    FBackgroundAlpha: Byte;
    procedure SetNomenclature(const Value: string);
    procedure SetFull(const Value: Boolean);
    function GetSquares(Idx: TMapSquare): Boolean;
    procedure SetSquares(Idx: TMapSquare; const Value: Boolean);
    procedure SetBackgroundAlpha(const Value: Byte);
    procedure SetArea(const Value: TEzVector);
    procedure SetSkip(const Value: Boolean);
  private
    FArea: TEzVector;
    FSkip: Boolean;
    FAreaBmpPoints: TEzPointList;
    FClipRgn: HRGN;
    function GetSquareRect(const SquareIdx: TMapSquare): TRect;
    procedure CalcAreaPoints(Bmp: TBitmap);
    procedure CreateAreaClipRegion(aBitmap: TBitmap);
    procedure DeleteAreaClipRegion(aBitmap: TBitmap);
  public
    constructor Create;
    destructor Destroy; override;
    //
    procedure ApplyGeometryToBmp(aBitmap: TBitmap; const EmptyColor: TColor);
    //
    property Area: TEzVector read FArea write SetArea;
    property BackgroundAlpha: Byte read FBackgroundAlpha write SetBackgroundAlpha;
    property Full: Boolean read FFull write SetFull;
    property Skip: Boolean read FSkip write SetSkip;
    property Nomenclature: string read FNomenclature write SetNomenclature;
    property Squares[Idx: TMapSquare]: Boolean read GetSquares write SetSquares;
  end;

  /// <summary>
  ///   √еометри€ дл€ выдачи сканов.
  /// </summary>
  TKisMapScanGeometry = class
  private
    FBackgroundAlpha: Byte;
    fList: TObjectList;
    FPolygon: TEzVector;
    procedure SetBackgroundAlpha(const Value: Byte);
    procedure SetPolygon(const Value: TEzVector);
    /// <summary>
    /// «аполн€ем область работ, если она есть
    /// </summary>
    procedure ApplyPolygon(MapGeo: TKisMapGeometry);
  public
    constructor Create;
    destructor Destroy; override;
    //
    function AddMap(const aNomenclature: string; Full: Boolean): TKisMapGeometry;
    function GetMapGeometry(const aNomenclature: string): TKisMapGeometry;
    //
    property BackgroundAlpha: Byte read FBackgroundAlpha write SetBackgroundAlpha;
    /// <summary>
    ///  оординаты области работ.
    /// </summary>
    property Polygon: TEzVector read FPolygon write SetPolygon;
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

procedure TKisMapGeometry.ApplyGeometryToBmp(aBitmap: TBitmap; const EmptyColor: TColor);
var
  I: Integer;
  Rects: TRectList;
  R: TRect;
  NewBmp: TBitmap;
  Tmp: TBitmap;
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
    //
    if FBackgroundAlpha = 0 then
    begin
      NewBmp := TBitmap.Create;
      try
        NewBmp.PixelFormat := aBitmap.PixelFormat;
        NewBmp.SetSize(aBitmap.Width, aBitmap.Height);
        NewBmp.Canvas.Brush.Color := EmptyColor;
        NewBmp.Canvas.Brush.Style := bsSolid;
        NewBmp.Canvas.FillRect(Rect(0, 0, aBitmap.Width, aBitmap.Height));
        //
        if Self.Area.Count > 0 then
        begin
          // есть область работ
          // надо перевести еЄ в координаты по пиксел€м
          CalcAreaPoints(NewBmp);
          CreateAreaClipRegion(NewBmp);
          try
            BitBlt(NewBmp.Canvas.Handle, 0, 0, NewBmp.Width, NewBmp.Height, aBitmap.Canvas.Handle, 0, 0, SRCCOPY);
          finally
            DeleteAreaClipRegion(NewBmp);
          end;
        end
        else
        begin
          NewBmp.Canvas.CopyMode := cmSrcCopy;
          for I := 0 to Rects.Count - 1 do
          begin
            R := Rects.Items[I];
            NewBmp.Canvas.CopyRect(R, aBitmap.Canvas, R);
          end;
        end;
        //
        aBitmap.Assign(NewBmp);
      finally
        FreeAndNil(NewBmp);
      end;
    end
    else
    begin
      Tmp := aBitmap.Clone();
      try
        NewBmp := TBitmap.Create;
        try
          NewBmp.PixelFormat := aBitmap.PixelFormat;
          NewBmp.SetSize(aBitmap.Width, aBitmap.Height);
          // заливаем всю картинку чветом фона
          NewBmp.Canvas.Brush.Color := EmptyColor;
          NewBmp.Canvas.Brush.Style := bsSolid;
          NewBmp.Canvas.FillRect(Rect(0, 0, aBitmap.Width, aBitmap.Height));
          // мешаем исходную картинку с фоном
          Tmp.DrawMix(NewBmp, FBackgroundAlpha);
        finally
          FreeAndNil(NewBmp);
        end;
        // переносим на картинку незафоненые куски
        if Self.Area.Count > 0 then
        begin
          // есть область работ
          // надо перевести еЄ в координаты по пиксел€м
          CalcAreaPoints(Tmp);
          CreateAreaClipRegion(Tmp);
          try
            BitBlt(Tmp.Canvas.Handle, 0, 0, Tmp.Width, Tmp.Height, aBitmap.Canvas.Handle, 0, 0, SRCCOPY);
          finally
            DeleteAreaClipRegion(Tmp);
          end;
        end
        else
        begin
          Tmp.Canvas.CopyMode := cmSrcCopy;
          for I := 0 to Rects.Count - 1 do
          begin
            R := Rects.Items[I];
            Tmp.Canvas.CopyRect(R, aBitmap.Canvas, R);
          end;
        end;
        aBitmap.Assign(Tmp);
      finally
        FreeAndNil(Tmp);
      end;
    end;
  finally
    Rects.Free;
  end;
end;

procedure TKisMapGeometry.CalcAreaPoints;
var
  N: TNomenclature;
  R: TRect;
  Xleft: Double;
  Ybottom: Double;
  Xa: Double;
  Ya: Double;
  I: Integer;
  X, Y: Integer;
begin
  FAreaBmpPoints.Clear;
  // получаем координаты планшета
  N.Init(FNomenclature, False);
  R := N.Bounds();
  // переводим координаты области в координаты битмепа
  // R.Top -> 0
  // R.Bottom -> Bmp.Height
  // R.Left -> 0
  // R.Right -> Bmp.Width
  for I := 0 to FArea.Count - 1 do
  begin
    Xa := FArea.Points[I].x;
    Ya := FArea.Points[I].y;
    Y := Round((R.Top - Ya) / 250 * Bmp.Height);
    X := Round((Xa - R.Left) / 250 * Bmp.Width);
    FAreaBmpPoints.Add(Point(X, Y));
  end;
end;

constructor TKisMapGeometry.Create;
begin
  FArea := TEzVector.Create(100);
  fSquares := TBits.Create;
  FAreaBmpPoints := TEzPointList.Create(100);
end;

procedure TKisMapGeometry.CreateAreaClipRegion;
var
  AreaPts: array[0..1000] of TPoint;
  I, C: Integer;
begin
  if FAreaBmpPoints.Count > 1000 then
    C := 1000
  else
    C := FAreaBmpPoints.Count;

  for I := 0 to C - 1 do
  begin
    AreaPts[I] := FAreaBmpPoints[I];
  end;
  FClipRgn := CreatePolygonRgn(AreaPts, C, WINDING);
  SaveDC(aBitmap.Canvas.Handle);
  SelectClipRgn(aBitmap.Canvas.Handle, FClipRgn);
end;

procedure TKisMapGeometry.DeleteAreaClipRegion;
begin
  DeleteObject(FClipRgn);
  RestoreDC(aBitmap.Canvas.Handle, -1);
end;

destructor TKisMapGeometry.Destroy;
begin
  FAreaBmpPoints.Free;
  fSquares.Free;
  FArea.Free;
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

procedure TKisMapGeometry.SetArea(const Value: TEzVector);
begin
  FArea := Value;
end;

procedure TKisMapGeometry.SetBackgroundAlpha(const Value: Byte);
begin
  FBackgroundAlpha := Value;
end;

procedure TKisMapGeometry.SetFull(const Value: Boolean);
begin
  FFull := Value;
end;

procedure TKisMapGeometry.SetNomenclature(const Value: string);
begin
  FNomenclature := Value;
end;

procedure TKisMapGeometry.SetSkip(const Value: Boolean);
begin
  FSkip := Value;
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

procedure TKisMapScanGeometry.ApplyPolygon(MapGeo: TKisMapGeometry);
var
  N: TNomenclature;
  R: TRect;
  Ext: TEzRect;
  I, J: Integer;
  BoundRect: TEzVector;
  E1, E2: TEzPolygon;
  BoundPoints: array of TEzPoint;
  Subject: TEzEntityList;
  Clipping: TEzEntityList;
  ClipResult: TEzEntityList;
begin
  // есть область работ
  if FPolygon.Count > 0 then
  begin
    // надо получить координаты планшета
    N.Init(MapGeo.Nomenclature, False);
    R := N.Bounds();
    // проверить его взаимное расположение с областью работ
    // провер€ем что область работ не пересекаетс€ с планшетом
    Ext := FPolygon.Extension;
    if R.Top <= Ext.ymin then
    begin
      MapGeo.Skip := True;
      Exit;
    end;
    if R.Bottom >= Ext.ymax then
    begin
      MapGeo.Skip := True;
      Exit;
    end;
    if R.Left >= Ext.xmax then
    begin
      MapGeo.Skip := True;
      Exit;
    end;
    if R.Right <= Ext.xmin then
    begin
      MapGeo.Skip := True;
      Exit;
    end;
    // провер€ем что область работ полностью внутри планшета
    if R.Top >= Ext.xmax then
    if R.Bottom <= Ext.xmin then
    if R.Left >= Ext.ymin then
    if R.Right <= Ext.ymax then
    begin
      MapGeo.Skip := False;
      MapGeo.Full := False;
      MapGeo.Area.Clear;
      MapGeo.Area.Assign(FPolygon);
      Exit;
    end;
    //
    // провер€ем что планшет полностью внутри области работ
    E1 := TEzPolygon.CreateEntity([]);
    E1.Forget;
    E1.Points.Assign(FPolygon);
    //
    SetLength(BoundPoints, 4);
    BoundPoints[0] := Point2D(R.Left, R.Top);
    BoundPoints[1] := Point2D(R.Right, R.Top);
    BoundPoints[2] := Point2D(R.Right, R.Bottom);
    BoundPoints[3] := Point2D(R.Left, R.Bottom);
    E2 := TEzPolygon.CreateEntity(BoundPoints);
    E2.Forget;
    //
    if E2.IsInsideEntity(E1, True) then
    begin
      MapGeo.Full := True;
      Exit;
    end;
    //
    // осталс€ последний вариант - планшет частично пересекаетс€ с областью работ
    Subject := TEzEntityList.Create;
    Subject.Forget;
    Subject.OwnEntities := False;
    Subject.Add(E2);
    Clipping := TEzEntityList.Create;
    Clipping.Forget;
    Clipping.OwnEntities := False;
    Clipping.Add(E1);
    ClipResult := TEzEntityList.Create;
    ClipResult.Forget;
    PolygonClip(pcInt, Subject, Clipping, ClipResult, nil);
    // в clipresult должен быть один полигон
    // это и будет искома€ область на планшете
    MapGeo.Area.Clear;
    if ClipResult.Count > 0 then
    begin
      for J := 0 to ClipResult[0].Points.Count - 1 do
        MapGeo.Area.Add(ClipResult[0].Points[J]);
//      for I := 0 to ClipResult.Count - 1 do
//      begin
//        for J := 0 to ClipResult[I].Points.Count - 1 do
//          MapGeo.Area.Add(ClipResult[I].Points[J]);
//      end;
    end
    else
      MapGeo.Skip := True;
  end;
end;

constructor TKisMapScanGeometry.Create;
begin
  fList := TObjectList.Create;
  FPolygon := TEzVector.Create(100);
end;

destructor TKisMapScanGeometry.Destroy;
begin
  FPolygon.Free;
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
      Result.BackgroundAlpha := Self.BackgroundAlpha;
      // «аполн€ем область работ, если она есть
      ApplyPolygon(Result);
      Exit;
    end;
  Result := nil;
end;

procedure TKisMapScanGeometry.SetBackgroundAlpha(const Value: Byte);
begin
  FBackgroundAlpha := Value;
end;

procedure TKisMapScanGeometry.SetPolygon(const Value: TEzVector);
begin
  FPolygon := Value;
end;

{ TRectList }

procedure TRectList.Add(const aRect: TRect);
begin
  if fCount > 24 then
    raise Exception.Create('ѕревышен размер списка квадратов!');
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
