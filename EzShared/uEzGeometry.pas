unit uEzGeometry;

interface

uses
  Math,
  EzLib;

type
  TSegmentsArrangement = (
    saCollinear,     // отрезки коллинеарны
    saCommonPart,    // есть общая часть
    saEqual,         // отрезки эквивалентны
    saIntersection,  // есть точка пересечения
    saTouch,         // один конец отрезка А лежит на отрезке B
    saConnect        // отрезки соединяются одним из концов
  );
const
  SegmentsArrangementNames : array[TSegmentsArrangement] of string = (
    'нет пересечения',
    'есть общая часть',
    'отрезки эквивалентны',
    'точка пересечения',
    'точка лежит на другом объекте',
    'объекты соединяются'
  );

type
  TGeometry = class
  public
    class function BetweenOrEqual(aValue, aMin, aMax: Integer): Boolean; overload;
    class function BetweenOrEqual(aValue, aMin, aMax: Double): Boolean; overload;
    class function BuildSegmentPoint(const StartPt: TEzPoint; const Angle, Length: Double): TEzPoint; overload;
    class function BuildSegmentPoint(const StartPt, EntPt: TEzPoint; const Length: Double): TEzPoint; overload;
    class function Distance(const FromPoint, ToPoint: TEzPoint): Double;
    class function DistanceLinePoint(const P, P1, P2: TEzPoint; const aDelta: Double; var D: Double): Boolean;
    class function IsLinesIntersects(const A1, B1, A2, B2: TEzPoint; var IntersectPoint: TEzPoint; const aDelta: Double): Boolean;
    class function IsPointsEqual(const A, B: TEzPoint; const aDelta: Double): Boolean;
    class function IsPointOnLine(const Pt, LinePt1, LinePt2: TEzPoint; const aDelta: Double): Boolean;
    class procedure Nearest(const A, B: TEzPoint; out P1, P2: TEzPoint);
    class function ProjectPointToLine(
      const aPoint, LineA, LineB: TEzPoint;
      const aDelta: Double;
      var PtOnLine: TEzPoint): Boolean;
    class function RotatePoint(const aPoint: TEzPoint; const RotationAngle: Double): TEzPoint;
    class function VectorLen(const aPoint: TEzPoint): Double;
  end;

  TEzRectGeometry = class
  public
    class function IsRectsIntersect(const R1, R2: TEzRect): Boolean;
  end;

  IFourPoints = interface
    ['{FEB40234-ADFB-4202-9CA2-F965BA4EDB88}']
    procedure SortByVectorLen();
    function IsLine(const aDelta: Double): Boolean;
    function GetPoints(Index: Integer): TEzPoint;
    property Points[Index: Integer]: TEzPoint read GetPoints;
  end;

  TFourPoints = class(TInterfacedObject, IFourPoints)
  private
    FPoints: array [0..3] of TEzPoint;
    FLen: array [0..3] of Double;
    function GetMinIdx(L1: Integer): Integer;
    procedure MoveMin(FromIdx, ToIdx: Integer);
  protected
    procedure SortByVectorLen();
    function IsLine(const aDelta: Double): Boolean;
    function GetPoints(Index: Integer): TEzPoint;
  public
    constructor Create(const A1, A2, B1, B2: TEzPoint);
  end;

  TSegmentPoint = record
    X, Y: Double;
    IsEnd: Boolean;
    constructor Create(const aPoint: TEzPoint; const aIsEnd: Boolean);
    function Pt2D(): TEzPoint;
  end;

  // проверка взаимного расположения двух отрезков
  ISegmentGeometry = interface
    ['{3872815A-EB89-464D-9F62-D89DC7C9F747}']
    procedure Process(
      const AA1: TSegmentPoint;
      const AA2: TSegmentPoint;
      const BB1: TSegmentPoint;
      const BB2: TSegmentPoint);
    function GetCommonPt1: TEzPoint;
    function GetCommonPt2: TEzPoint;
    function GetArrangement: TSegmentsArrangement;
    property CommonPt1: TEzPoint read GetCommonPt1;
    property CommonPt2: TEzPoint read GetCommonPt2;
    property Arrangement: TSegmentsArrangement read GetArrangement;
  end;

  TSegmentGeometry = class(TInterfacedObject, ISegmentGeometry)
  private
    FB1: TSegmentPoint;
    FB2: TSegmentPoint;
    FA2: TSegmentPoint;
    FA1: TSegmentPoint;
    FBoxA, FBoxB: TEzRect;
    FCommonPt2: TEzPoint;
    FCommonPt1: TEzPoint;
    FArrangement: TSegmentsArrangement;
    FDelta: Double;
    function AreEqualOrConnecting(): Boolean;
    function AreEqualOrConnecting2(const PtStart1, PtEnd1, PtStart2, PtEnd2: TSegmentPoint): Boolean;
    function FindIntersection(): Boolean;
    function FindCommonPart(): Boolean;
    function FindTouch(): Boolean;
    procedure SetDelta(const Value: Double);
  protected
    procedure Process(
      const AA1: TSegmentPoint;
      const AA2: TSegmentPoint;
      const BB1: TSegmentPoint;
      const BB2: TSegmentPoint);
    function GetCommonPt1: TEzPoint;
    function GetCommonPt2: TEzPoint;
    function GetArrangement: TSegmentsArrangement;
    //
    property A1: TSegmentPoint read FA1;
    property A2: TSegmentPoint read FA2;
    property B1: TSegmentPoint read FB1;
    property B2: TSegmentPoint read FB2;
    property Delta: Double read FDelta write SetDelta;
  public
    constructor Create(const aDelta: Double);
  end;

type
  IAngle = interface
    ['{16B499EB-01BD-4AC6-9861-2438D22401E3}']
    // Возвращает значение между 0 и 2Pi.
    function Normalize: Double;
    // Возвращает значение между -Pi и Pi.
    function Normalize2(): Double;
  end;
  TAngle = class(TInterfacedObject, IAngle)
  private
    fValue: Double;
    procedure CheckZero(var C: Double);
  protected
    function Normalize: Double;
    function Normalize2(): Double;
  public
    constructor Create(const aValue: Double); overload;
    constructor Create(const A, B: TEzPoint; const VertHorzEpsilon: Double); overload;
  end;

const
  AngleDelta = Pi / 360;
  Circle = 2 * Pi;
  DoubleEpsilon: Double = 0.00001;
  FiveMm = 0.005;

implementation

{ TAngle }

procedure TAngle.CheckZero(var C: Double);
begin
  if Abs(C) < AngleDelta then
    C := 0
  else
    if Abs(C - Circle) < AngleDelta then
      C := 0;
end;

constructor TAngle.Create(const aValue: Double);
begin
  fValue := aValue;
end;

constructor TAngle.Create(const A, B: TEzPoint; const VertHorzEpsilon: Double);
var
  dX, dY: Double;
  ConstX, ConstY: Boolean;
begin
  dX := B.X - A.X;
  dY := B.Y - A.Y;
  fValue := 0;
  ConstX := Abs(dX) < VertHorzEpsilon;
  ConstY := Abs(dY) < VertHorzEpsilon;
  if ConstX and ConstY then
    Exit;
  if ConstX and (dY > 0) then
    fValue := pi / 2
  else
    if ConstX and (dY < 0) then
      fValue := -pi / 2
    else
      if ConstY and (dX > 0) then
        fValue := 0
      else
        if ConstY and (dX < 0) then
          fValue := pi
        else
          fValue := ArcTan2(dY, dX);
end;

function TAngle.Normalize: Double;
begin
  Result := fValue;
  CheckZero(Result);
  while Result < 0 do
  begin
    Result := Result + 2 * pi;
    CheckZero(Result);
  end;
  while Result > Circle do
  begin
    Result := Result - 2 * pi;
    CheckZero(Result);
  end;
end;

function TAngle.Normalize2(): Double;
begin
  Result := Normalize;
  if Abs(Result - pi) < AngleDelta then
    Result := pi
  else
    if Abs(pi - Result) < AngleDelta then
      Result := -pi
    else
      if Result > pi then
        Result := Result - 2 * pi
      else
        if Result < -pi then
          Result := Result + 2 * pi
end;

{ TSegmentGeometry }

function TSegmentGeometry.AreEqualOrConnecting: Boolean;
begin
  Result := AreEqualOrConnecting2(FA1, FA2, FB1, FB2);
  if not Result then
    Result := AreEqualOrConnecting2(FA2, FA1, FB1, FB2);
end;

function TSegmentGeometry.AreEqualOrConnecting2(const PtStart1, PtEnd1, PtStart2, PtEnd2: TSegmentPoint): Boolean;
var
  DA1B1, DA2B2: Double;
  DA1B2, DA2B1: Double;
begin
  Result := False;
  DA1B1 := Dist2D(PtStart1.Pt2D, PtStart2.Pt2D);
  DA2B2 := Dist2D(PtEnd1.Pt2D, PtEnd2.Pt2D);
  if DA1B1 < FDelta then
  begin
    // одна точка совпала
    FCommonPt1 := PtStart1.Pt2D;
    // дальше:
    // если совпадает вторая точка, то отрезки совпадают
    if DA2B2 < FDelta then
    begin
      // вторая точка совпала
      FCommonPt2 := PtEnd1.Pt2D;
      FArrangement := saEqual;
      Result := True;
      Exit;
    end;
    // если вторая точка не совпадает,
    // то отрезки как-то соединяются
    if PtStart1.IsEnd then
    begin
      // если отрезки соединяются и точка является концом,
      // то получаем соединение или касание
      if PtStart2.IsEnd then
      begin
        FArrangement := saConnect;
        Result := True;
        Exit;
      end
      else
      begin
        FArrangement := saTouch;
        Result := True;
        Exit;
      end;
    end
    else
    begin
      // если отрезки соединяются и точка не является концом,
      // то получаем пересечение
      FArrangement := saIntersection;
      Result := True;
      Exit;
    end;
  end;
end;

constructor TSegmentGeometry.Create(const aDelta: Double);
begin
  inherited Create;
  FDelta := aDelta;
end;

function TSegmentGeometry.FindCommonPart: Boolean;
var
  Angle1, Angle2: IAngle;
  A1Val, A2Val: Double;
  Pt1a, Pt2a: TEzPoint;
  Pt1b, Pt2b: TEzPoint;
  D: Double;
  FourPoints: IFourPoints;
begin
  Result := False;
  TGeometry.Nearest(A1.Pt2D, A2.Pt2D, Pt1a, Pt2a);
  Angle1 := TAngle.Create(Pt1a, Pt2a, FDelta);
  TGeometry.Nearest(B1.Pt2D, B2.Pt2D, Pt1b, Pt2b);
  // 1. проверить угол он должен быть близким
  //    - если нет, то нет и общего отезка
  Angle2 := TAngle.Create(Pt1b, Pt2b, FDelta);
  A1Val := Angle1.Normalize();
  A2Val := Angle2.Normalize();
  D := Abs(A1Val - A2Val);
  if D >= AngleDelta then
    Exit;
  // 2. точки сортируем по расстоянию от начала координат
  FourPoints := TFourPoints.Create(A1.Pt2D, A2.Pt2D, B1.Pt2D, B2.Pt2D);
  if not FourPoints.IsLine(FDelta) then
    Exit;
  if not (
      TGeometry.IsPointOnLine(A1.Pt2D, B1.Pt2D, B2.Pt2D, FDelta) or
      TGeometry.IsPointOnLine(A2.Pt2D, B1.Pt2D, B2.Pt2D, FDelta) or
      TGeometry.IsPointOnLine(B1.Pt2D, A1.Pt2D, A2.Pt2D, FDelta) or
      TGeometry.IsPointOnLine(B2.Pt2D, A1.Pt2D, A2.Pt2D, FDelta))
  then
    Exit;
  //
  FourPoints.SortByVectorLen();
  // 3. найти внутреннюю область - это и есть общий отрезок
  FCommonPt1 := FourPoints.Points[2];
  FCommonPt2 := FourPoints.Points[3];
  FArrangement := saCommonPart;
  Result := True;
end;

function TSegmentGeometry.FindIntersection: Boolean;
var
  FoundPt: TEzPoint;
begin
  Result := False;
  if TGeometry.IsLinesIntersects(A1.Pt2D, B1.Pt2D, A2.Pt2D, B2.Pt2D, FoundPt, FDelta) then
  begin
    Result := IsPointOnMe(FoundPt, A1.Pt2D, B1.Pt2D) and IsPointOnMe(FoundPt, A2.Pt2D, B2.Pt2D);
    if Result then
      FCommonPt1 := FoundPt;
  end;
end;

function TSegmentGeometry.FindTouch: Boolean;
begin
  Result := False;
  if FArrangement = saIntersection then
  begin
    // общая точка - это конец одного отрезка
    // и она лежит на втором отрезке,
    // но не на его концах
    if TGeometry.IsPointsEqual(FCommonPt1, A1.Pt2D, FDelta) then
    begin
      if IsPointOnMe(FCommonPt1, B1.Pt2D, B2.Pt2D) then
      begin
        FArrangement := saTouch;
        Result := True;
        Exit;
      end;
    end;
    if TGeometry.IsPointsEqual(FCommonPt1, A2.Pt2D, FDelta) then
    begin
      if IsPointOnMe(FCommonPt1, B1.Pt2D, B2.Pt2D) then
      begin
        FArrangement := saTouch;
        Result := True;
        Exit;
      end;
    end;
    if TGeometry.IsPointsEqual(FCommonPt1, B1.Pt2D, FDelta) then
    begin
      if IsPointOnMe(FCommonPt1, A1.Pt2D, A2.Pt2D) then
      begin
        FArrangement := saTouch;
        Result := True;
        Exit;
      end;
    end;
    if TGeometry.IsPointsEqual(FCommonPt1, B2.Pt2D, FDelta) then
    begin
      if IsPointOnMe(FCommonPt1, A1.Pt2D, A2.Pt2D) then
      begin
        FArrangement := saTouch;
        Result := True;
        Exit;
      end;
    end;
  end;
////
//    if TGeometry.IsPointsEqual(FCommonPt1, A1.Pt2D, FDelta)
//       or
//       TGeometry.IsPointsEqual(FCommonPt1, B1.Pt2D, FDelta)
//    then
//    begin
//      if IsPointOnMe(FCommonPt1, A2.Pt2D, B2.Pt2D) then
//      begin
//        FArrangement := saTouch;
//        Result := True;
//        Exit;
//      end;  
//    end;
//    if TGeometry.IsPointsEqual(FCommonPt1, A2.Pt2D, FDelta)
//       or
//       TGeometry.IsPointsEqual(FCommonPt1, B2.Pt2D, FDelta)
//    then
//    begin
//      if IsPointOnMe(FCommonPt1, A1.Pt2D, B1.Pt2D) then
//      begin
//        FArrangement := saTouch;
//        Result := True;
//        Exit;
//      end;  
//    end;
//  end;
end;

function TSegmentGeometry.GetArrangement: TSegmentsArrangement;
begin
  Result := FArrangement;
end;

function TSegmentGeometry.GetCommonPt1: TEzPoint;
begin
  Result := FCommonPt1;
end;

function TSegmentGeometry.GetCommonPt2: TEzPoint;
begin
  Result := FCommonPt2;
end;

procedure TSegmentGeometry.Process(
  const AA1: TSegmentPoint;
  const AA2: TSegmentPoint;
  const BB1: TSegmentPoint;
  const BB2: TSegmentPoint);
begin
  FArrangement := saCollinear;
  //
  FA1 := AA1;
  FA2 := AA2;
  FB1 := BB1;
  FB2 := BB2;
  FBoxA := Rect2D(AA1.X, AA1.Y, AA2.X, AA2.Y);
  FBoxA := ReorderRect2D(FBoxA);
  FBoxB := Rect2D(BB1.X, BB1.Y, BB2.X, BB2.Y);
  FBoxB := ReorderRect2D(FBoxB);
  //
  // как они вообще могут соотноситься?
  // 1. обе точки могут лежать на одном сегменте полигона
  //    1а. могут полностью совпадать с сегментом либо совпадать одной точкой
  // 2. две точки образуют линию, которая может пересекаться с сегментом полигона
  // 3. сегмент может полностью либо частично лежать на линии.
  //
  if not TEzRectGeometry.IsRectsIntersect(FBoxA, FBoxB) then
    Exit;
  // есть ли пересечение отрезков?
  // пересечение по крайним точкам или в середине линии?
  // отрезки идентичны? может быть соединены одним концом?
  if AreEqualOrConnecting() then
    Exit;
  // есть ли общая часть, если отрезки лежат на одной прямой?
  if FindCommonPart() then
    Exit;
  if FindIntersection() then
  begin
    // нашли, что два отрезка пересекаются, но как?
    // точка пересечения может быть концом нашего отрезка
    // тогда это будет касание
    if FindTouch() then
      FArrangement := saTouch
    else
      FArrangement := saIntersection;
  end;
end;

procedure TSegmentGeometry.SetDelta(const Value: Double);
begin
  FDelta := Value;
end;

{ TGeometry }

class function TGeometry.BuildSegmentPoint(const StartPt: TEzPoint; const Angle, Length: Double): TEzPoint;
var
  A: IAngle;
  Ang, Cs, Sn: Double;
begin
  A := TAngle.Create(Angle);
  Ang := A.Normalize;
  Sn := sin(Ang);
  if Ang > pi then
    if Sn > 0 then
      Sn := -Sn;
  if Ang < pi then
    if Sn < 0 then
      Sn := -Sn;
  //
  Ang := A.Normalize2;
  Cs := cos(Ang);
  if Abs(Ang) > (pi / 2) then
    if Cs > 0 then
      Cs := -Cs;
  if Abs(Ang) < (pi / 2) then
    if Cs < 0 then
      Cs := -Cs;
  //
  Result := StartPt;
  Result.x := Result.X + Length * Cs;
  Result.y :=  Result.Y + Length * Sn;
end;

class function TGeometry.BetweenOrEqual(aValue, aMin, aMax: Integer): Boolean;
var
  D: Integer;
begin
  if aMin > aMax then
  begin
    D := aMin;
    aMin := aMax;
    aMax := D;
  end;
  Result := (aMin <= aValue) and (aValue <= aMax);
end;

class function TGeometry.BetweenOrEqual(aValue, aMin, aMax: Double): Boolean;
var
  D: Double;
begin
  if aMin > aMax then
  begin
    D := aMin;
    aMin := aMax;
    aMax := D;
  end;
  Result := (aMin <= aValue) and (aValue <= aMax);

end;

class function TGeometry.BuildSegmentPoint(const StartPt, EntPt: TEzPoint; const Length: Double): TEzPoint;
var
  A: IAngle;
begin
  A := TAngle.Create(StartPt, EntPt, DoubleEpsilon);
  Result := BuildSegmentPoint(StartPt, A.Normalize, Length);
end;

class function TGeometry.Distance(const FromPoint, ToPoint: TEzPoint): Double;
var
  X, Y: Extended;
begin
  X := ToPoint.x - FromPoint.X;
  Y := ToPoint.Y - FromPoint.Y;
  Result := Sqrt(X * X + Y * Y);
end;

class function TGeometry.DistanceLinePoint(const P, P1, P2: TEzPoint; const aDelta: Double; var D: Double): Boolean;
var
  R, L, dX, dY: Double;
  Pt: TEzPoint;
begin
  dX := P2.x - P1.x;
  dY := P2.y - P1.y;
  L := Sqrt(dX * dX + dY * dY);
  if L <> 0 then
  begin
    R := ((P1.y - P.y) * (-dY) - (P1.x - P.x) * dX) / (L * L);
    D := Abs(((P1.y - P.y) * dX - (P1.x - P.x) * dY) / L);
    if Abs(R) < 0.00001 then
      R := 0.00001;
    Result := (R >= 0) and (R <= 1);
  end
  else
  begin
    Result := TGeometry.ProjectPointToLine(P, P1, P2, aDelta, Pt);
    if Result then
      D := TGeometry.Distance(P, Pt);
  end;
end;

class function TGeometry.IsLinesIntersects(const A1, B1, A2, B2: TEzPoint; var IntersectPoint: TEzPoint;
  const aDelta: Double): Boolean;
var
  Dt, Ds, T, S: Double;
  D: Double;
begin
  Result := False;
  // Отрезок А1В1 вертикальный
  if Abs(A1.x - B1.x) < aDelta then
  begin
    // Отрезок А2В2 горизонтальный
    if Abs(A2.y - B2.y) < aDelta then
    begin
      Result := BetweenOrEqual(A2.y, A1.y, B1.y) and BetweenOrEqual(A1.x, A2.x, B2.x);
      if Result then
      begin
        IntersectPoint.x := A1.x;
        IntersectPoint.y := A2.y;
        Exit;
      end;
    end;
  end;
  // Отрезок А1В1 горизонтальный
  if Abs(A1.y - B1.y) < aDelta then
  begin
    // Отрезок А2В2 вертикальный
    if Abs(A2.x - B2.x) < aDelta then
    begin
      Result := BetweenOrEqual(A2.x, A1.x, B1.x) and BetweenOrEqual(A1.y, A2.y, B2.y);
      if Result then
      begin
        IntersectPoint.x := A2.x;
        IntersectPoint.y := A1.y;
        Exit;
      end;
    end;
  end;
  //
  if not Result then
  begin
    if TGeometry.IsPointsEqual(A1, A2, aDelta) then
    begin
      Result := True;
      IntersectPoint := A1;
    end
    else
      if TGeometry.IsPointsEqual(A1, B2, aDelta) then
      begin
        Result := True;
        IntersectPoint := A1;
      end
      else
        if TGeometry.IsPointsEqual(B1, A2, aDelta) then
        begin
          Result := True;
          IntersectPoint := B1;
        end
        else
          if TGeometry.IsPointsEqual(B1, B2, aDelta) then
          begin
            Result := True;
            IntersectPoint := B1;
          end
          else
          begin
            D := (B2.y - A2.y) * (B1.x - A1.x) - (B2.x - A1.x) *
              (B1.y - A1.y);
            if D <> 0 then
            begin
              Ds := (B2.x - A2.x) * (A1.y - A2.y) - (B2.y - A2.y) *
                (A1.x - A2.x);
              S := Ds / D;
              if (0 <= S) and (S <= 1) then
              begin
                Dt := (B1.x - A1.x) * (A1.y - A2.y) - (B1.y - A1.y) *
                  (A1.x - A2.x);
                T := Dt / D;
                if (0 <= T) and (T <= 1) then
                begin
                  IntersectPoint.x := A1.x + S * (B1.x - A1.x);
                  IntersectPoint.y := A1.y + S * (B1.y - A1.y);
                  if IsPointOnLine(IntersectPoint, A1, B1, aDelta) then
                    if IsPointOnLine(IntersectPoint, A2, B2, aDelta) then
                      Result := True;
                end;
              end;
            end;
          end;
  end;
end;

class function TGeometry.IsPointOnLine(const Pt, LinePt1, LinePt2: TEzPoint; const aDelta: Double): Boolean;
var
  D: Double;
begin
  Result := TGeometry.DistanceLinePoint(Pt, LinePt1, LinePt2, aDelta, D) and (D <= aDelta);
end;

class function TGeometry.IsPointsEqual(const A, B: TEzPoint; const aDelta: Double): Boolean;
begin
  Result := (Abs(A.x - B.x) < aDelta) and (Abs(A.y - B.y) < aDelta);
end;

class procedure TGeometry.Nearest(const A, B: TEzPoint; out P1, P2: TEzPoint);
var
  D1, D2: Double;
begin
  D1 := Abs(A.x) + Abs(A.Y);
  D2 := Abs(B.x) + Abs(B.Y);
  if D1 > D2 then
  begin
    P1 := A;
    P2 := B;
  end
  else
  begin
    P1 := B;
    P2 := A;
  end;
end;

class function TGeometry.ProjectPointToLine(const APoint, LineA, LineB: TEzPoint;
  const aDelta: Double;
  var PtOnLine: TEzPoint): Boolean;
var
  C, L: Double;
  A1, A2: IAngle;
begin
  if IsPointsEqual(LineA, LineB, aDelta) then
  begin
    Result := False;
    Exit;
  end;
  Result := True;
  A1 := TAngle.Create(LineA, APoint, aDelta);
  A2 := TAngle.Create(LineA, LineB, aDelta);
  C := A1.Normalize - A2.Normalize;
  L := TGeometry.Distance(APoint, LineA);
  PtOnLine := BuildSegmentPoint(LineA, LineB, L * cos(C));
  if Abs(PtOnLine.X) < aDelta then
    PtOnLine.X := 0;
  if Abs(PtOnLine.Y) < aDelta then
    PtOnLine.Y := 0;
end;

class function TGeometry.RotatePoint(const aPoint: TEzPoint; const RotationAngle: Double): TEzPoint;
var
  C, S: Double;
begin
  C := Cos(RotationAngle);
  S := Sin(RotationAngle);
  Result.x := aPoint.x * C - aPoint.y * S;
  Result.y := aPoint.x * S + aPoint.y * C;
end;

class function TGeometry.VectorLen(const aPoint: TEzPoint): Double;
begin
  Result := aPoint.X * aPoint.X + aPoint.Y + aPoint.Y;
end;

{ TFourPoints }

constructor TFourPoints.Create(const A1, A2, B1, B2: TEzPoint);
var
  I: Integer;
begin
  inherited Create;
  FPoints[0] := A1;
  FPoints[1] := A2;
  FPoints[2] := B1;
  FPoints[3] := B2;
  for I := 0 to High(FPoints) do
    FLen[I] := TGeometry.VectorLen(FPoints[I]);
end;

function TFourPoints.GetMinIdx(L1: Integer): Integer;
var
  I: Integer;
  L: Double;
begin
  Result := -1;
  L := MaxInt;
  for I := L1 to 3 do
  begin
    if FLen[I] < L then
    begin
      L := FLen[I];
      Result := I;
    end;
  end;
end;

function TFourPoints.GetPoints(Index: Integer): TEzPoint;
begin
  Result := FPoints[Index];
end;

function TFourPoints.IsLine(const aDelta: Double): Boolean;
var
  D: Double;
begin
  Result := False;
  TGeometry.DistanceLinePoint(FPoints[2], FPoints[0], FPoints[1], aDelta, D);
  if D < aDelta then
  begin
    TGeometry.DistanceLinePoint(FPoints[2], FPoints[0], FPoints[1], aDelta, D);
    Result := D < aDelta;
  end;
end;

procedure TFourPoints.MoveMin(FromIdx, ToIdx: Integer);
var
  L: Double;
  Pt: TEzPoint;
  I: Integer;
begin
  if FromIdx = ToIdx then
    Exit;
  L := FLen[FromIdx];
  Pt := FPoints[FromIdx];
  for I := FromIdx downto ToIdx + 1 do 
  begin
    FLen[I] := FLen[I - 1];
    FPoints[I] := FPoints[I - 1];
  end;
  FLen[ToIdx] := L;
  FPoints[ToIdx] := Pt;
end;

procedure TFourPoints.SortByVectorLen;
var
  J: Integer;
begin
  J := GetMinIdx(0);
  MoveMin(J, 0);
  J := GetMinIdx(1);
  MoveMin(J, 1);
  J := GetMinIdx(2);
  MoveMin(J, 2);
end;

{ TEzRectGeometry }

class function TEzRectGeometry.IsRectsIntersect(const R1, R2: TEzRect): Boolean;
begin
  Result := False;
  if R1.xmax < R2.xmin then
    Exit;
  if R1.ymax < R2.ymin then
    Exit;
  if R1.xmin > R2.xmax then
    Exit;
  if R1.ymin > R2.ymax then
    Exit;
  Result := True;
end;

{ TSegmentPoint }

constructor TSegmentPoint.Create(const aPoint: TEzPoint; const aIsEnd: Boolean);
begin
  X := aPoint.X;
  Y := aPoint.Y;
  IsEnd := aIsEnd;
end;

function TSegmentPoint.Pt2D: TEzPoint;
begin
  Result.x := X;
  Result.y := Y;
end;

end.
