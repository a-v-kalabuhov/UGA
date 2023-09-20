unit uMStKernelGISUtils;

interface

{$WARN UNSAFE_CODE OFF}
{$WARN UNSAFE_TYPE OFF}
{$WARN UNSAFE_CAST OFF}

uses
  // System
  SysUtils, Classes, Windows, Graphics, Printers, Types, Math, jpeg,
  // EzGIS
  EzBaseGIS, EzLib, EzEntities, EzBase,
  // Common
  uGC, uGeoUtils, uCK36,
  // Project
  uMstKernelClasses, uMStKernelTypes,
  uMStClassesLots;

type
  IAutoEntity = interface(IAutoObject)
    function GetEntity: TEzEntity;
    property Entity: TEzEntity read GetEntity;
  end;

  TAutoEntity = class(TAutoObject, IAutoEntity)
  protected
    function GetEntity: TEzEntity;
  end;

  TRectRelation = (
      rrIntersects,   // прямоугольники пересекаются
      rrNotIntersects, // прямоугольники не пересекаются
      rrEquals, // прямоугольники не пересекаются
      rrIsInside        // один прямоугольник внутри другого
  );

  TPointArray2D = array of TEzPoint;

  function IEntity(Entity: TEzEntity): IAutoEntity;

  function DecartToCityPoint(const DecartPoint: TEzPoint): TEzPoint;
  function CityToDecartPoint(const CityPoint: TEzPoint): TEzPoint;

  function GetMap500Entity(const Nomenclature: String; Color: Integer): TEzEntity;
  function GetMap500Rect(const Nomenclature: String): TEzRect;
  function GetMapImageEntity(const Nomenclature, FileName: String; ImgExt: TmstImageExt): TEzEntity;

  function ContourToEntity(aContour: TmstLotContour): TEzEntity;

  function ExportLot(ALot: TmstLot): TEzEntity;
  function GetLotPolygon(aLot: TmstLot): TEzPolygon;
  procedure GetLotPolygons(aLot: TmstLot; EntList: TEzEntityList);

  function IsTempEntity(Entity: TEzEntity; DrawBox: TEzBaseDrawBox): Boolean;
  procedure AddContourMarkers(EntList: TEzEntityList; aContour: TmstLotContour; Scale: Double);
  procedure AddPointsLabels(EntList: TEzEntityList; aContour: TmstLotContour; const TextHeight: Double);
  procedure AddPointsToLot(EntList: TEzEntityList; aContour: TmstLotContour; const PointSize: Double);
  procedure AddLotMarkers(EntList: TEzEntityList; aLot: TmstLot; Scale: Double);
  function ContourRect(aLotContour: TmstLotContour): TEzRect;
  procedure MoveRect2D(var Rect: TEzRect; const dX, dY: Double);
  // in pixels
  function GetPageRectWithoutMargins: TEzRect;
  // in mms
  function GetPageRectWithoutMargins2: TEzRect;
  //
  function FindLayerEntities(Layer: TEzBaseLayer; const Rect: TezRect): TIntegerList;
  procedure PointsToVector(aPoints: TmstLotPoints; aVector: TEzVector);
  function GetRect2DRelation(const Rect1, Rect2: TEzRect): TRectRelation;
  function GetDrawBoxRect(DrawBox: TEzBaseDrawBox): TEzRect;
  function Rect2DHeight(const aRect: TEzRect): Double;
  function Rect2DWidth(const aRect: TEzRect): Double;
  function PickSingleEntity(aLayer: TEzBaseLayer; aDrawBox: TEzBaseDrawBox; const WorldPt: TEzPoint; AppertureSizeInPixels: Byte): Integer;

  /// <summary>
  ///   XY = True - Х направлен вверх
  ///   XY = False - Х направлен вправо, а Y вверх
  /// </summary>
  procedure Point2DToCK36(var aPoint: TEzPoint; XY: Boolean = True);
  procedure Point2DToVrn(var aPoint: TEzPoint; XY: Boolean = True);
  procedure Rect2DToCK36(var aRect: TEzRect; XY: Boolean = True);
  procedure Rect2DToVrn(var aRect: TEzRect; XY: Boolean = True);

type
  TEzRectList = class
  private
    FList: TList;
    function GetItems(const Index: Integer): TEzRect;
  public
    constructor Create;
    destructor Destroy; override;
    //
    procedure Add(const aRect: TEzRect);
    function Count: Integer;
    //
    property Items[const Index: Integer]: TEzRect read GetItems; default;
  end;

implementation

uses
  // Libs
  EzERMapper,
  // Common
  uCommonUtils;

const
  NumberChars = ['0', '1', '2', '3', '4', '5', '6', '7', '8', '9'];
  LatinNumberChars = ['I', 'V', 'X', 'M'];

procedure Point2DToCK36(var aPoint: TEzPoint; XY: Boolean = True);
var
  Xmest, Ymest, Xck36, Yck36: Double;
begin
  if XY then
  begin
    Xmest := aPoint.y;
    Ymest := aPoint.x;
  end
  else
  begin
    Xmest := aPoint.x;
    Ymest := aPoint.y;
  end;
  uCK36.ToCK36(Xmest, Ymest, Xck36, Yck36);
  if XY then
  begin
    aPoint.x := Yck36;
    aPoint.y := Xck36;
  end
  else
  begin
    aPoint.x := Xck36;
    aPoint.y := Yck36;
  end;
end;

procedure Point2DToVrn(var aPoint: TEzPoint; XY: Boolean = True);
var
  Xmest, Ymest, Xck36, Yck36: Double;
begin
  if XY then
  begin
    Xck36 := aPoint.y;
    Yck36 := aPoint.x;
  end
  else
  begin
    Xck36 := aPoint.x;
    Yck36 := aPoint.y;
  end;
  uCK36.ToVRN(Xck36, Yck36, Xmest, Ymest);
  if XY then
  begin
    aPoint.x := Ymest;
    aPoint.y := Xmest;
  end
  else
  begin
    aPoint.x := Xmest;
    aPoint.y := Ymest;
  end;
end;

procedure Rect2DToCK36(var aRect: TEzRect; XY: Boolean = True);
begin
  Point2DToCK36(aRect.Emin, XY);
  Point2DToCK36(aRect.Emax, XY);
end;

procedure Rect2DToVrn(var aRect: TEzRect; XY: Boolean = True);
begin
  Point2DToVrn(aRect.Emin, XY);
  Point2DToVrn(aRect.Emax, XY);
end;

function IEntity(Entity: TEzEntity): IAutoEntity;
begin
  Result := TAutoEntity.Create(Entity);
end;

function DecartToCityPoint(const DecartPoint: TEzPoint): TEzPoint;
begin
  Result.X := DecartPoint.Y;
  Result.Y := DecartPoint.X;
end;

function CityToDecartPoint(const CityPoint: TEzPoint): TEzPoint;
begin
  Result.X := CityPoint.Y;
  Result.Y := CityPoint.X;
end;

function GetMap500Entity(const Nomenclature: String; Color: Integer): TEzEntity;
begin
  Result := TEzMap500Entity.CreateEntity(Nomenclature);
  TEzMap500Entity(Result).FontTool.Color := Color;
  TEzMap500Entity(Result).PenTool.Color := Color;
end;

function GetMap500Rect(const Nomenclature: String): TEzRect;
var
  X, Y: Integer;
begin
  TGeoUtils.MapTopLeft(Nomenclature, X, Y);
  Result.Emin := Point2D(Y, X);
  Result.Emax := Point2D(Y + 250, X - 250);
  Result := ReorderRect2D(Result);
end;

function GetMapImageEntity(const Nomenclature, FileName: String; ImgExt: TmstImageExt): TEzEntity;
var
  X, Y: Integer;
  Bmp: TBitmap;
  JPG: TJPEGImage;
begin
  TGeoUtils.MapTopLeft(Nomenclature, X, Y);
  case ImgExt of
    imgGFA:
      Result := TEzERMapper.CreateEntity(
                      Point2D(Y, X),
                      Point2D(Y + 250, X - 250),
                      FileName
      );
    imgBMP:
      begin
        Bmp := TBitmap.Create;
        try
          Bmp.PixelFormat := pf24bit;
          Bmp.LoadFromFile(FileName);
          Result := TEzPictureRef.CreateEntity(
                          Point2D(Y, X),
                          Point2D(Y + 250, X - 250),
                          ''
          );
          TEzPictureRef(Result).Stream := TMemoryStream.Create;
          Bmp.SaveToStream(TEzPictureRef(Result).Stream);
        finally
          Bmp.Free;
        end;
        //TEzBitmapRef(Result).OwnImage := True;
      end;
    imgJPEG:
      begin
        Bmp := TBitmap.Create;
        try
          Bmp.PixelFormat := pf24bit;
          JPG := TJPEGImage.Create;
          try
            JPG.LoadFromFile(FileName);
            Bmp.Assign(JPG);
          finally
            FreeAndNil(JPG);
          end;
          Result := TEzPictureRef.CreateEntity(
                          Point2D(Y, X),
                          Point2D(Y + 250, X - 250),
                          ''
          );
          TEzPictureRef(Result).Stream := TMemoryStream.Create;
          Bmp.SaveToStream(TEzPictureRef(Result).Stream);
        finally
          Bmp.Free;
        end;
      end;
  end;
end;

procedure GetLotPoints(ALot: TmstLot; var Points: array of TEzPoint);
var
  I, J, K, C: Integer;
begin
  K := 0;
  for J := 0 to Pred(ALot.Contours.Count) do
    if ALot.Contours[J].Enabled and (ALot.Contours[J].Points.Count > 2) then
    begin
      C := Pred(ALot.Contours[J].Points.Count);
      for I := 0 to C do
      begin
        Points[K] := CityToDecartPoint(Point2D(ALot.Contours[J].Points[I].X, ALot.Contours[J].Points[I].Y));
        Inc(K);
      end;
      Points[K] := CityToDecartPoint(Point2D(ALot.Contours[J].Points[0].X, ALot.Contours[J].Points[0].Y));
      Inc(K);
    end;
end;

function GetLotContourPoints(aContour: TmstLotContour): TPointArray2D;
var
  I, C: Integer;
begin
  C := aContour.Points.Count;
  SetLength(Result, C);
  for I := 0 to C - 1 do
  begin
    Result[I] := CityToDecartPoint(Point2D(aContour.Points[I].X, aContour.Points[I].Y));
  end;
  if C > 0 then
  if aContour.Closed then
    if not EqualPoint2D(Result[0], Result[C - 1]) then
    begin
      SetLength(Result, C + 1);
      Result[C] := Result[0];
    end;
end;

function GetLotPolygon(aLot: TmstLot): TEzPolygon;
var
  Ent: TEzEntity;
  I, C, J: Integer;
begin
  Result := nil;
  // Считаем количество контуров с точками и количество доступных точек
  for I := 0 to Pred(aLot.Contours.Count) do
    if aLot.Contours[I].Enabled then
      if aLot.Contours[I].Points.Count > 1 then
      begin
        Ent := ContourToEntity(aLot.Contours[I]);
        Ent.Forget();
        if aLot.Contours[I].Closed then
        begin
          C := Ent.Points.Count - 1;
          if not EqualPoint2D(Ent.Points[0], Ent.Points[C]) then
            Ent.Points.Add(Ent.Points[0]);
        end;
        if not Assigned(Result) then
          Result := TEzPolygon.CreateEntity([], True);
        Result.Points.Parts.Add(Result.Points.Count);
        for J := 0 to Pred(Ent.Points.Count) do
          Result.Points.Add(Ent.Points[J]);
      end;
end;

procedure GetLotPolygons(aLot: TmstLot; EntList: TEzEntityList);
var
  Ent: TEzEntity;
  I: Integer;
begin
  for I := 0 to Pred(ALot.Contours.Count) do
    if ALot.Contours[I].Enabled then
    begin
      Ent := ContourToEntity(ALot.Contours[I]);
      if Assigned(Ent) then
        EntList.Add(Ent);
    end;
end;

function ExportLot(ALot: TmstLot): TEzEntity;
begin
  Result := GetLotPolygon(aLot);
end;

procedure PointsToVector(aPoints: TmstLotPoints; aVector: TEzVector);
var
  I: Integer;
begin
  if Assigned(aPoints) and Assigned(aVector) then
  begin
    aVector.Clear;
    for I := 0 to Pred(aPoints.Count) do
      aVector.AddPoint(aPoints[I].Y, aPoints[I].X);
  end;
end;

function ContourToEntity(aContour: TmstLotContour): TEzEntity;
begin
  Result := nil;
  if Assigned(aContour) then
  begin
    case aContour.Points.Count of
    0, 1 : Result := nil;
    2 :
      begin
        Result := TEzPolyline.CreateEntity([]);
        PointsToVector(aContour.Points, Result.Points);
        if aContour.HasColor then
          TEzPolyline(Result).PenTool.Color := aContour.Color;
      end;
    else
      begin
        if aContour.Closed then
        begin
          Result := TEzPolygon.CreateEntity([]);
          PointsToVector(aContour.Points, Result.Points);
          Result.Points.AddPoint(aContour.Points[0].Y, aContour.Points[0].X);
          if aContour.HasColor then
            TEzPolygon(Result).PenTool.Color := aContour.Color;
        end
        else
        begin
          Result := TEzPolyline.CreateEntity([]);
          PointsToVector(aContour.Points, Result.Points);
          if aContour.HasColor then
            TEzPolyline(Result).PenTool.Color := aContour.Color;
        end;
      end;
    end;
  end;
end;

function IsTempEntity(Entity: TEzEntity; DrawBox: TEzBaseDrawBox): Boolean;
begin
  Result := False;
  if Assigned(DrawBox) then
    if Assigned(Entity) then
      Result := DrawBox.TempEntities.IndexOf(Entity) >= 0;
end;

procedure AddContourMarkers(EntList: TEzEntityList; aContour: TmstLotContour; Scale: Double);
var
  Marker: TEzRectangle;
  aText: TezTrueTypeText;
  I: Integer;
  P1, P2: TEzPoint;
  H1, H2: Double;
begin
  if not Assigned(EntList) or not Assigned(aContour) then
    Exit;
  H1 := Scale{ / 20};
  H2 := H1 * 2;
  for I := 0 to Pred(aContour.Points.Count) do
  begin
    P1 := Point2D(aContour.Points[I].Y, aContour.Points[I].X);
    P1.x := P1.x - H1;
    P1.y := P1.y + H1;
    P2.x := P1.x + H2;
    P2.y := P1.y - H2;
    Marker := TEzRectangle.CreateEntity(P1, P2);
    Marker.PenTool.Color := clRed;
    EntList.Add(Marker);
    aText := TEzTrueTypeText.CreateEntity(
      Marker.FBox.Emin,
      aContour.Points[I].Name,
      H2 * 1.5,
      0);
    aText.FontTool.Color := clPurple;
    EntList.Add(aText);
  end;
end;

procedure AddPointsLabels(EntList: TEzEntityList; aContour: TmstLotContour;
 const TextHeight: Double);
var
  aText: TezTrueTypeText;
  I: Integer;
begin
  if not Assigned(EntList) or not Assigned(aContour) then
    Exit;
  for I := 0 to Pred(aContour.Points.Count) do
  begin
    aText := TEzTrueTypeText.CreateEntity(
      Point2D(aContour.Points[I].Y, aContour.Points[I].X),
      aContour.Points[I].Name,
      TextHeight,
      0);
    EntList.Add(aText);
  end;
end;

procedure AddPointsToLot(EntList: TEzEntityList; aContour: TmstLotContour;
  const PointSize: Double);
var
  aPoint: TEzEllipse;
  I: Integer;
begin
  if not Assigned(EntList) or not Assigned(aContour) then
    Exit;
  for I := 0 to Pred(aContour.Points.Count) do
  begin
    aPoint := TEzEllipse.CreateEntity(
      Point2D(aContour.Points[I].Y - PointSize / 2, aContour.Points[I].X + PointSize / 2),
      Point2D(aContour.Points[I].Y + PointSize / 2, aContour.Points[I].X - PointSize / 2)
    );
    EntList.Add(aPoint);
  end;
end;

procedure AddLotMarkers(EntList: TEzEntityList; aLot: TmstLot; Scale: Double);
var
  Marker: TEzRectangle;
  I, J: Integer;
  P1, P2: TEzPoint;
  H: Double;
begin
  if not Assigned(EntList) or not Assigned(aLot) then
    Exit;
  for I := 0 to Pred(aLot.Contours.Count) do
    if aLot.Contours[I].Enabled then
      for J := 0 to Pred(aLot.Contours[I].Points.Count) do
      begin
        P1 := Point2D(aLot.Contours[I].Points[J].Y, aLot.Contours[I].Points[J].X);
        H := Scale{ / 20};
        P1.x := P1.x - H;
        P1.y := P1.y + H;
        P2.x := P1.x + 2 * H;
        P2.y := P1.y - 2 * H;
        Marker := TEzRectangle.CreateEntity(P1, P2);
        Marker.PenTool.Color := clRed;
        EntList.Add(Marker);
      end;
end;

function ContourRect(aLotContour: TmstLotContour): TEzRect;
var
  I: Integer;
begin
  if (not Assigned(aLotContour)) or (aLotContour.Points.Count = 0) then
    Exit;
  with aLotContour.Points do
  begin
    Result.xmin := Items[0].Y;
    Result.xmax := Items[0].Y;
    Result.ymin := Items[0].X;
    Result.ymax := Items[0].X;
    for I := 1 to Pred(Count) do
    begin
      if Result.xmin > Items[I].Y then
        Result.xmin := Items[I].Y;
      if Result.xmax < Items[I].Y then
        Result.xmax := Items[I].Y;
      if Result.ymin > Items[I].X then
        Result.ymin := Items[I].X;
      if Result.ymax < Items[I].X then
        Result.ymax := Items[I].X;
    end;
  end;
end;

procedure MoveRect2D(var Rect: TEzRect; const dX, dY: Double);
begin
  Rect.xmin := Rect.xmin + dX;
  Rect.xmax := Rect.xmax + dX;
  Rect.ymin := Rect.ymin + dY;
  Rect.ymax := Rect.ymax + dY;
end;

function GetPageRectWithoutMargins: TEzRect;
var
  PixelsPerInch: TPoint;
  PhysPageSize: TPoint;
  OffsetStart: TPoint;
  PageRes: TPoint;
begin
  PixelsPerInch.y := GetDeviceCaps(Printer.Handle, LOGPIXELSY);
  PixelsPerInch.x := GetDeviceCaps(Printer.Handle, LOGPIXELSX);
  Escape(Printer.Handle, GETPHYSPAGESIZE, 0, nil, @PhysPageSize);
  Escape(Printer.Handle, GETPRINTINGOFFSET, 0, nil, @OffsetStart);
  PageRes.y := GetDeviceCaps(Printer.Handle, VERTRES);
  PageRes.x := GetDeviceCaps(Printer.Handle, HORZRES);
  // Top Margin
  Result.ymin := OffsetStart.y;
  // Left Margin
  Result.xmin := OffsetStart.x;
  // Bottom Margin
  Result.ymax := PageRes.y - Result.ymin;
  // Right Margin
  Result.xmax := PageRes.x - Result.xmin;
end;

function GetPageRectWithoutMargins2: TEzRect;
var
  PixelsPerInch: TPoint;
  OffsetStart: TPoint;
  PageRes: TPoint;
begin
  PixelsPerInch.y := GetDeviceCaps(Printer.Handle, LOGPIXELSY);
  PixelsPerInch.x := GetDeviceCaps(Printer.Handle, LOGPIXELSX);
  Escape(Printer.Handle, GETPRINTINGOFFSET, 0, nil, @OffsetStart);
  PageRes.y := GetDeviceCaps(Printer.Handle, VERTRES);
  PageRes.x := GetDeviceCaps(Printer.Handle, HORZRES);
  // Top Margin
  Result.ymin := OffsetStart.y / PixelsPerInch.y * 25.4;
  // Left Margin
  Result.xmin := OffsetStart.x / PixelsPerInch.x * 25.4;
  // Bottom Margin
  Result.ymax := (PageRes.y / PixelsPerInch.y * 25.4) - Result.ymin;
  // Right Margin
  Result.xmax := - Result.xmin + (PageRes.x / PixelsPerInch.x * 25.4);
end;

function FindLayerEntities(Layer: TEzBaseLayer; const Rect: TezRect): TIntegerList;
var
  Tmp: TEzEntity;
  Rn: Integer;
begin
  Result := TIntegerList.Create;
  if not Assigned(Layer) then
    Exit;
  Rn := Layer.Recno;
  Layer.First;
  while not Layer.Eof do
  begin
    if not Layer.RecIsDeleted then
    begin
      Tmp := IEntity(Layer.RecLoadEntity).Entity;
      if Tmp.IsVisible(Rect) then
        Result.Add(Layer.RecNo);
    end;
    Layer.Next;
  end;
  Layer.Recno := Rn;
end;

function GetRect2DRelation(const Rect1, Rect2: TEzRect): TRectRelation;
var
  R1, R2: TEzRect;
begin
  R1 := ReorderRect2D(Rect1);
  R2 := ReorderRect2D(Rect2);
  if R1.xmax < R2.xmin then
  begin
    Result := rrNotIntersects; // R1 слева от R2
    Exit;
  end;
  if R2.xmax < R1.xmin then
  begin
    Result := rrNotIntersects; // R1 справа от R2
    Exit;
  end;
  if R1.ymax < R2.ymin then
  begin
    Result := rrNotIntersects; // R1 ниже R2
    Exit;
  end;
  if R2.ymax < R1.ymin then
  begin
    Result := rrNotIntersects; // R1 выше R2
    Exit;
  end;
  if EqualRect2D(R1, R2) then
  begin
    Result := rrEquals;
    Exit;
  end;
  if (R1.xmin >= R2.xmin)
     and
     (R1.xmax <= R2.xmax)
     and
     (R1.ymax <= R2.ymax)
     and
     (R1.ymin >= R2.ymin)
  then
  begin
    Result := rrIsInside;
    Exit;
  end;
  if (R2.xmin >= R1.xmin)
     and
     (R2.xmax <= R1.xmax)
     and
     (R2.ymax <= R1.ymax)
     and
     (R2.ymin >= R1.ymin)
  then
  begin
    Result := rrIsInside;
    Exit;
  end;
  //
  Result := rrIntersects;
end;

function GetDrawBoxRect(DrawBox: TEzBaseDrawBox): TEzRect;
begin
  DrawBox.CurrentExtents(Result.xmin, Result.ymin, Result.xmax, Result.ymax);
end;

function Rect2DHeight(const aRect: TEzRect): Double;
begin
  Result := aRect.ymax - aRect.ymin;
end;

function Rect2DWidth(const aRect: TEzRect): Double;
begin
  Result := aRect.xmax - aRect.xmin;
end;

function PickSingleEntity(aLayer: TEzBaseLayer; aDrawBox: TEzBaseDrawBox; const WorldPt: TEzPoint; AppertureSizeInPixels: Byte): Integer;
var
  I, Pcode: Integer;
  FoundRecs: TIntegerList;
  Rw, Rh: Double;
  R2d: TEzRect;
  MaxDist, Dist: Double;
  Tmp: TezEntity;
  App: Double;
  PickInside: Boolean;
begin
  Result := -1;
  R2d := GetDrawBoxRect(aDrawBox);
  Rw := (Rect2DWidth(R2d) / aDrawBox.ClientWidth) * 5;
  Rh := (Rect2DHeight(R2d) / aDrawBox.ClientHeight) * 5;
  R2d := Rect2D(WorldPt.x - Rw, WorldPt.y - Rh, WorldPt.x + Rw, WorldPt.y + Rh);
  FoundRecs := FindLayerEntities(aLayer, R2d);
  FoundRecs.Forget();
  MaxDist := 1000000;
  App := Max(Rw, Rh) * 2;
  for I := 0 to FoundRecs.Count - 1 do
  begin
    aLayer.Recno := FoundRecs[I];
    Tmp := aLayer.RecLoadEntity();
    try
      PickInside := Tmp is TEzClosedEntity;
      Dist := 1000000;
      Pcode := Tmp.PointCode(WorldPt, App, Dist, PickInside);
  //  PICKED_NONE = -3; { no point or interior picked }
  //  PICKED_INTERIOR = -2; { picked inside entity (only closed entities) }
  //  PICKED_POINT = -1; { picked on a line segment }
    { PICKED_NONE     - not on entity
      PICKED_INTERIOR - point inside entity
      PICKED_POINT    - point on any segment
      > = 0           - point on that entity point }
      if Pcode <> PICKED_NONE then
      begin
        if Dist < MaxDist then
          Result := FoundRecs[I]
      end;
    finally
      FreeAndNil(Tmp);
    end;
  end;
end;

{ TAutoEntity }

function TAutoEntity.GetEntity: TEzEntity;
begin
  Result := TEzEntity(inherited GetObject);
end;

{ TEzRectList }

procedure TEzRectList.Add(const aRect: TEzRect);
var
  P: Pointer;
begin
  GetMem(P, SizeOf(TEzRect));
  CopyMemory(P, @aRect, SizeOf(TEzRect));
  FList.Add(P);
end;

function TEzRectList.Count: Integer;
begin
  Result := FList.Count;
end;

constructor TEzRectList.Create;
begin
  inherited;
  FList := TList.Create;
end;

destructor TEzRectList.Destroy;
var
  I: Integer;
  P: Pointer;
begin
  for I := 0 to FList.Count - 1 do
  begin
    P := FList[I];
    FreeMem(P, SizeOf(TEzRect));
  end;
  FList.Free;
  inherited;
end;

function TEzRectList.GetItems(const Index: Integer): TEzRect;
begin
  CopyMemory(@Result, FList[Index], SizeOf(TEzRect));
end;

initialization
  TEzMap500Entity.NomenclatureFunc := GetNomenclatureCoords500;

end.
