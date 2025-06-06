unit uEzIntersection;

interface

uses
  Contnrs, Types, Math,
  EzBaseGIS, EzLib,
  uEzGeometry;

type
  TEzIntersection = class
  private
    FPoint1: TEzPoint;
    FPoint2: TEzPoint;
    FIsPoint: Boolean;
    FArragement: TSegmentsArrangement;
  public
    constructor Create(const aPoint1: TEzPoint; anArragement: TSegmentsArrangement); overload;
    constructor Create(const aPoint1, aPoint2: TEzPoint; anArragement: TSegmentsArrangement); overload;
    //
    function IsEqual(Item: TEzIntersection; const aDelta: Double): Boolean;
    //
    property Arragement: TSegmentsArrangement read FArragement;
    property Point1: TEzPoint read FPoint1;
    property Point2: TEzPoint read FPoint2;
    property IsPoint: Boolean read FIsPoint;
  end;

  TEzIntersectionList = class
  private
    FList: TObjectList;
    function GetItems(Index: Integer): TEzIntersection;
    procedure RemoveDups(Item: TEzIntersection; StartrIdx: Integer; const aDelta: Double);
  public
    constructor Create;
    destructor Destroy; override;
    //
    procedure Add(aItem: TEzIntersection);
    procedure Append(aList: TEzIntersectionList);
    procedure Clear;
    function Count: Integer;
    procedure RemoveDuplicates(const aDelta: Double);
    property Items[Index: Integer]: TEzIntersection read GetItems;
  end;

  // неиспользуется, недописан
  TEzIntersectionListCheck = class
  private
    FList: TEzIntersectionList;
    FDelta: Double;
    procedure RemoveSinglePointDups(Idx: Integer);
    procedure RemoveTwoPointDups(Idx: Integer); virtual; abstract;
  public
    constructor Create(aList: TEzIntersectionList; const aDelta: Double);
    //
    procedure RemoveDuplicatedPoints();
  end;

  IEzFindIntersections = interface
    ['{3FBB0952-4C77-4415-A6DC-E3C7E6E6E129}']
    function FindPolyIntersect(Poly1, Poly2: TEzOpenedEntity): TEzIntersectionList;
  end;

  TEzFindIntersections = class(TInterfacedObject, IEzFindIntersections)
  private
    FDelta: Double;
    FPt1: TSegmentPoint;
    FPt2: TSegmentPoint;
    FPolyPt1, FPolyPt2: TSegmentPoint;
    function GetSegmentIntersect(): TEzIntersection;
    function GetIntersections(aPoly: TEzOpenedEntity): TEzIntersectionList;
  public
    constructor Create(const aDelta: Double);
    //
    function FindPolyIntersect(Poly1, Poly2: TEzOpenedEntity): TEzIntersectionList;
    /// <summary>
    /// Порог расстояния между точками/линиями.
    /// Если расстояние меньше порога, то считаем что точки совпадают.
    /// Значение в метрах.
    /// По умолчанию установлено в 5 миллиметров.
    /// </summary>
    property Delta: Double read FDelta;
  end;

implementation

{ TEzIntersection }

constructor TEzIntersection.Create(const aPoint1: TEzPoint; anArragement: TSegmentsArrangement);
begin
  FPoint1 := aPoint1;
  FIsPoint := True;
  FArragement := anArragement;
end;

constructor TEzIntersection.Create(const aPoint1, aPoint2: TEzPoint; anArragement: TSegmentsArrangement);
begin
  FPoint1 := aPoint1;
  FPoint2 := aPoint2;
  FIsPoint := False;
  FArragement := anArragement;
end;

function TEzIntersection.IsEqual(Item: TEzIntersection; const aDelta: Double): Boolean;
begin
  Result := FIsPoint and Item.FIsPoint;
  if Result then
  begin
    Result := FArragement = Item.FArragement;
    if Result then
    begin
      Result := TGeometry.IsPointsEqual(FPoint1, Item.FPoint1, aDelta);
      if Result and FIsPoint then
        Result := TGeometry.IsPointsEqual(FPoint2, Item.FPoint2, aDelta);
    end;
  end;
end;

{ TEzIntersectionList }

procedure TEzIntersectionList.Add(aItem: TEzIntersection);
begin
  FList.Add(aItem);
end;

procedure TEzIntersectionList.Append(aList: TEzIntersectionList);
var
  Itm: TEzIntersection;
begin
  while aList.Count > 0 do
  begin
    Itm := aList.Items[0];
    aList.FList.Extract(Itm);
    Self.Add(Itm);
  end;
end;

procedure TEzIntersectionList.Clear;
begin
  FList.Clear;
end;

function TEzIntersectionList.Count: Integer;
begin
  Result := FList.Count;
end;

constructor TEzIntersectionList.Create;
begin
  FList := TObjectList.Create;
end;

destructor TEzIntersectionList.Destroy;
begin
  FList.Free;
  inherited;
end;

function TEzIntersectionList.GetItems(Index: Integer): TEzIntersection;
begin
  Result := TEzIntersection(FList[Index]);
end;

procedure TEzIntersectionList.RemoveDuplicates;
var
  I: Integer;
begin
  I := 0;
  while I < FList.Count do
  begin
    RemoveDups(Items[I], I + 1, aDelta);
    Inc(I);
  end;
end;

procedure TEzIntersectionList.RemoveDups(Item: TEzIntersection; StartrIdx: Integer; const aDelta: Double);
var
  I: Integer;
begin
  I := StartrIdx;
  while I < FList.Count do
  begin
    if Items[I].IsEqual(Item, aDelta) then
      FList.Delete(I)
    else
      Inc(I);
  end;
end;

{ TEzFindIntersections }

constructor TEzFindIntersections.Create;
begin
  FDelta := aDelta;
end;

function TEzFindIntersections.GetIntersections(aPoly: TEzOpenedEntity): TEzIntersectionList;
var
  P1, P2: Integer;
  Intersect: TEzIntersection;
begin
  //
  // здесь мы должны найти как две точки соотносятся с полигоном
  // как они вообще могут соотноситься?
  // 1. обе точки могут лежать на одном сегменте олигона
  //    1а. могут полностью совпадать с сегментом либо совпадать одной точкой
  // 2. две точки образуют линию, которая может пересекаться с сегментом полигона
  // 3. сегмент может полностью либо частично лежать на линии.

  // пробегаем по всем частям
  Result := TEzIntersectionList.Create;
  //
  P1 := 0;
  for P2 := 1 to aPoly.Points.Count - 1 do
  begin
    FPolyPt1 := TSegmentPoint.Create(aPoly.Points[P1], P1 = 0);
    FPolyPt2 := TSegmentPoint.Create(aPoly.Points[P2], P2 = aPoly.Points.Count - 1);
    Intersect := GetSegmentIntersect();
    if Intersect <> nil then
      Result.Add(Intersect);
    P1 := P2;
  end;
end;

function TEzFindIntersections.FindPolyIntersect(Poly1, Poly2: TEzOpenedEntity): TEzIntersectionList;
var
  P1, P2: Integer;
  Intersects: TEzIntersectionList;
begin
  Result := TEzIntersectionList.Create;
  //
  P1 := 0;
  for P2 := 1 to Poly1.Points.Count - 1 do
  begin
    FPt1 := TSegmentPoint.Create(Poly1.Points[P1], P1 = 0);
    FPt2 := TSegmentPoint.Create(Poly1.Points[P2], P2 = Poly1.Points.Count - 1);
    Intersects := GetIntersections(Poly2);
    if Intersects <> nil then
    try
      Result.Append(Intersects);
    finally
      Intersects.Free;
    end;
    P1 := P2;
  end;
  //
  Result.RemoveDuplicates(FDelta);
end;

function TEzFindIntersections.GetSegmentIntersect(): TEzIntersection;
var
  SegGeo: ISegmentGeometry;
begin
  //
  // как они вообще могут соотноситься?
  // 1. обе точки могут лежать на одном сегменте полигона
  //    1а. могут полностью совпадать с сегментом либо совпадать одной точкой
  // 2. две точки образуют линию, которая может пересекаться с сегментом полигона
  // 3. сегмент может полностью либо частично лежать на линии.
  //
  Result := nil;
  //
  SegGeo := TSegmentGeometry.Create(FDelta);
  SegGeo.Process(FPt1, FPt2, FPolyPt1, FPolyPt2);
  case SegGeo.Arrangement of
    saCollinear:
      // отрезки никак не взаимодействуют
      Exit;
    saCommonPart:
      begin
        // у отрезков есть совпадающая часть, но они не одинаковые
        Result := TEzIntersection.Create(SegGeo.CommonPt1, SegGeo.CommonPt2, SegGeo.Arrangement);
      end;
    saEqual:
      begin
        // отрезки одинаковые
        Result := TEzIntersection.Create(FPt1.Pt2D, FPt2.Pt2D, SegGeo.Arrangement);
      end;
    saIntersection, saTouch, saConnect:
      begin
        // у отрезков есть пересечение, прикосновение или они соединяются
        Result := TEzIntersection.Create(SegGeo.CommonPt1, SegGeo.Arrangement);
      end;
  end;
end;

{ TEzIntersectionListCheck }

constructor TEzIntersectionListCheck.Create;
begin
  FList := aList;
  FDelta := aDelta;
end;

procedure TEzIntersectionListCheck.RemoveDuplicatedPoints;
var
  I: Integer;
begin
  for I := 0 to FList.Count - 1 do
  begin
    if FList.Items[I].Arragement in [saIntersection, saTouch, saConnect] then
      RemoveSinglePointDups(I)
    else
      RemoveTwoPointDups(I);
  end;
end;

procedure TEzIntersectionListCheck.RemoveSinglePointDups(Idx: Integer);
var
  I: Integer;
  D: Double;
begin
  for I := Idx + 1 to FList.Count - 1 do
  begin
    if FList.Items[I].Arragement in [saIntersection, saTouch, saConnect] then
    begin
      // проверяем если точки совпадают и тогда удаляем
      D := TGeometry.Distance(FList.Items[Idx].Point1, FList.Items[I].Point1);
      if D < FDelta then
      begin

      end;
    end;
  end;
end;

end.
