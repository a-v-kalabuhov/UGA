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
    property Arragement: TSegmentsArrangement read FArragement;
    property Point1: TEzPoint read FPoint1;
    property Point2: TEzPoint read FPoint2;
    property IsPoint: Boolean read FIsPoint;
  end;

  TEzIntersectionList = class
  private
    FList: TObjectList;
    function GetItems(Index: Integer): TEzIntersection;
  public
    constructor Create;
    destructor Destroy; override;
    //
    procedure Add(aItem: TEzIntersection);
    procedure Append(aList: TEzIntersectionList);
    procedure Clear;
    function Count: Integer;
    property Items[Index: Integer]: TEzIntersection read GetItems;
  end;

  IEzFindIntersections = interface
    ['{3FBB0952-4C77-4415-A6DC-E3C7E6E6E129}']
    function FindPolyIntersect(Poly1, Poly2: TEzOpenedEntity): TEzIntersectionList;
  end;

  TEzFindIntersections = class(TInterfacedObject, IEzFindIntersections)
  private
    FDelta: Double;
    function GetSegmentIntersect(const Pt1, Pt2, PolyPt1, PolyPt2: TEzPoint): TEzIntersection;
    function GetIntersections(const Pt1, Pt2: TEzPoint; aPoly: TEzOpenedEntity): TEzIntersectionList;
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

{ TEzFindIntersections }

constructor TEzFindIntersections.Create;
begin
  FDelta := aDelta;
end;

function TEzFindIntersections.GetIntersections(const Pt1, Pt2: TEzPoint; aPoly: TEzOpenedEntity): TEzIntersectionList;
var
  P1, P2: Integer;
  PolyPt1, PolyPt2: TEzPoint;
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
    PolyPt1 := aPoly.Points[P1];
    PolyPt2 := aPoly.Points[P2];
    Intersect := GetSegmentIntersect(Pt1, Pt2, PolyPt1, PolyPt2);
    if Intersect <> nil then
      Result.Add(Intersect);
    P1 := P2;
  end;
end;

function TEzFindIntersections.FindPolyIntersect(Poly1, Poly2: TEzOpenedEntity): TEzIntersectionList;
var
  P1, P2: Integer;
  Pt1, Pt2: TEzPoint;
  Intersects: TEzIntersectionList;
begin
  Result := TEzIntersectionList.Create;
  //
  P1 := 0;
  for P2 := 1 to Poly1.Points.Count - 1 do
  begin
    Pt1 := Poly1.Points[P1];
    Pt2 := Poly1.Points[P2];
    Intersects := GetIntersections(Pt1, Pt2, Poly2);
    if Intersects <> nil then
    try
      Result.Append(Intersects);
    finally
      Intersects.Free;
    end;
    P1 := P2;
  end;
end;

function TEzFindIntersections.GetSegmentIntersect(const Pt1, Pt2, PolyPt1, PolyPt2: TEzPoint): TEzIntersection;
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
  SegGeo.Process(Pt1, Pt2, PolyPt1, PolyPt2);
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
        // у отрезков есть совпадающая часть, но они не одинаковые
        Result := TEzIntersection.Create(Pt1, Pt2, SegGeo.Arrangement);
      end;
    saIntersection, saTouch, saConnect:
      begin
        // у отрезков есть пересечение, прикосновение или они соединяются
        Result := TEzIntersection.Create(SegGeo.CommonPt1, SegGeo.Arrangement);
      end;
  end;
end;

end.
