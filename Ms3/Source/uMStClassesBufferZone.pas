unit uMStClassesBufferZone;

interface

uses
  SysUtils, Types,
  EzLib, EzEntities, EzBaseGIS,
  Clipper;

type
  TmstBufferZoneBuilderLine = class
  private
    FBuffer: TEzVector;
    FWidth: Double;
    procedure SetWidth(const Value: Double);
  private
    FCenter: TEzPoint;
    FLength: Double;
    FScale: Double;
    procedure Prepare(const Pt1, Pt2: TEzPoint);
  public
    constructor Create;
    destructor Destroy; override;
    //
    procedure Build(const Pt1, Pt2: TEzPoint);
    function BufferPoly: TEzPolygon;
    //
    property Buffer: TEzVector read FBuffer;
    property Width: Double read FWidth write SetWidth;
  end;

  TmstBufferZoneBuilderPoly = class
  private type
    TLine = record
      A, B, C: Double;
      Empty: Boolean;
      P1, P2: TEzPoint;
    public
      procedure Calc(Pt1, Pt2: TEzPoint);
    end;
  private
    FBuffer: TEzVector;
    FPoints: TEzVector;
    procedure SetWidth(const Value: Double);
  strict private
    FIndex: Integer;
    FLine1: TLine;
    FLine2: TLine;
    FEntities: TEzEntityList;
    FBuilder: TmstBufferZoneBuilderLine;
    FWidth: Double;
    procedure CalcRects();
    procedure ConnectRects(R1, R2: TEzEntity);
    procedure JoinRects();
  public
    constructor Create;
    destructor Destroy; override;
    //
    procedure Build(aLine: TEzVector);
    //
    property Buffer: TEzVector read FBuffer;
    property Width: Double read FWidth write SetWidth;
  end;

  TmstBufferZoneBuilderPoly2 = class
  private
    FBuffer: TEzVector;
    FWidth: Double;
    procedure SetWidth(const Value: Double);
  strict private
//    procedure CalcRects();
//    procedure ConnectRects(R1, R2: TEzEntity);
//    procedure JoinRects();
  public
    constructor Create;
    destructor Destroy; override;
    //
    procedure Build(aLine: TEzVector);
    //
    property Buffer: TEzVector read FBuffer;
    property Width: Double read FWidth write SetWidth;
  end;
implementation

{ TmstBufferZoneBuilderLine }

function TmstBufferZoneBuilderLine.BufferPoly: TEzPolygon;
begin
  Result := TEzPolygon.Create(4, False);
  Result.Points.Add(FBuffer[0]);
  Result.Points.Add(FBuffer[1]);
  Result.Points.Add(FBuffer[2]);
  Result.Points.Add(FBuffer[3]);
end;

procedure TmstBufferZoneBuilderLine.Build(const Pt1, Pt2: TEzPoint);
begin
  // центр
  FCenter := Point2D((Pt1.x + Pt2.x) / 2, (Pt1.y + Pt2.y) / 2);
  FLength := Dist2D(FCenter, Pt1);
  if FLength = 0 then
    FLength := Width;
  FScale := 1 + (Width / 2) / FLength;
  Prepare(Pt1, Pt2);
  Prepare(Pt2, Pt1);
end;

constructor TmstBufferZoneBuilderLine.Create;
begin
  FBuffer := TEzVector.Create(0);
  FBuffer.CanGrow := True;
end;

destructor TmstBufferZoneBuilderLine.Destroy;
begin
  FBuffer.Free;
  inherited;
end;

procedure TmstBufferZoneBuilderLine.Prepare(const Pt1, Pt2: TEzPoint);
var
  Matrix: TEzMatrix;
  Pt1B: TEzPoint;
  Pt2B: TEzPoint;
begin
  Matrix := Scale2D(FScale, FScale, Pt1);
  // точка на линии от Pt1 длиной Width
  Pt1B := TransformPoint2D(Pt1, Matrix);
  Pt1B := TransformPoint2D(Pt2, Matrix);
  // эту точку повернём на 90
  Matrix := Rotate2D(System.Pi / 2, Pt1);
  Pt1B := TransformPoint2D(Pt1B, Matrix);
  Pt2B := TransformPoint2D(Pt2B, Matrix);
  FBuffer.Add(Pt1B);
  FBuffer.Add(Pt2B);
end;

procedure TmstBufferZoneBuilderLine.SetWidth(const Value: Double);
begin
  FWidth := Value;
end;

{ TmstBufferZoneBuilderPoly }

procedure TmstBufferZoneBuilderPoly.Build(aLine: TEzVector);
begin
  FBuffer.Clear;
  FLine1.Empty := True;
  FLine2.Empty := True;
  FPoints := aLine;
  if FPoints.Count < 3 then
    raise Exception.Create('Невозможно построить зону!');
  FIndex := 2;
  while FIndex < FPoints.Count do
  begin
    // заполняем список FEntities
    CalcRects();
    Inc(FIndex);
  end;
  // объединяем фигуры из списка FEntities
  JoinRects();
end;

procedure TmstBufferZoneBuilderPoly.CalcRects;
var
  aRect: TEzEntity;
  R1, R2: TEzEntity;
begin
  // три точки
  // из них строим два отрезка
  // для каждого отрезка строим зону - прямоугольник
  // добавляем оба прямоугольника в список фигур
  if FLine1.Empty then
  begin
    FLine1.Calc(FPoints[FIndex - 2], FPoints[FIndex - 1]);
    FBuilder.Build(FLine1.P1, FLine1.P2);
    aRect := FBuilder.BufferPoly();
    FEntities.Add(aRect);
  end;
  FLine2.Calc(FPoints[FIndex - 1], FPoints[FIndex]);
  FBuilder.Build(FLine1.P1, FLine1.P2);
  aRect := FBuilder.BufferPoly();
  FEntities.Add(aRect);
  // теперь надо добавить фигуру, которая заполнит собой разрыв, если он есть
  R1 := FEntities[FEntities.Count - 2];
  R2 := FEntities[FEntities.Count - 1];
  ConnectRects(R1, R2);
  //
  FLine1 := FLine2;
  FLine2.Empty := True;
end;

procedure TmstBufferZoneBuilderPoly.ConnectRects(R1, R2: TEzEntity);
var
  HasBreak: Boolean;
  Break1, Break2: Boolean;
  I, J: Integer;
  D: Double;
  L1, L2: TLine;
  IntersectPt: TEzPoint;
  Rel: TEzLineRelations;
begin
  // как определить есть ли разрыв
  Break1 := False;
  Break2 := False;
  // если одна смежная точка оказывается внутри другого прямоугольника, а её соседка нет, то есть разрыв
  Break1 := R2.IsPointInsideMe(R1.Points[1].x, R1.Points[1].y);
  if not Break1 then
    Break2 := R2.IsPointInsideMe(R1.Points[2].x, R1.Points[2].y);
  // если есть разрыв, то у прямоугольников сравниваем точки смежные
  if Break1 or Break2 then
  begin
    // если расстояние меньше 5 см, то есть считаем что разрыва нет
    //      и меняем у одного из прямоугольников точку на точку его соседа
    if Break1 then
    begin
      I := 1;
      J := 0;
    end
    else
    begin
      I := 2;
      J := 3;
    end;
    D := Dist2D(R1.Points[I], R2.Points[J]);
    if D < 0.05 then
    begin
      R2.Points[J] := R1.Points[I];
      Break1 := False;
      Break2 := False;
    end;
  end;
  // если есть разрыв, то надо найти точку пересечения прямых,
  //      проходящих через стороны прямоугольников, параллельных осевой линии
  // эту точку назначим вместо точек обоих прямоугольников
  // т.е. они перестанут быть прямоугольниками
  if Break1 or Break2 then
  begin
    if Break1 then
    begin
      I := 0;
      J := 1;
    end
    else
    begin
      I := 3;
      J := 2;
    end;
    L1.Calc(R1.Points[I], R1.Points[J]);
    L2.Calc(R2.Points[I], R2.Points[J]);
    Rel := LineRel(L1.P1, L1.P2, L2.P1, L2.P2, IntersectPt);
    if not (lrParallel in Rel) then
    begin
      R1.Points[J] := IntersectPt;
      R2.Points[I] := IntersectPt;
    end;
  end;
end;

constructor TmstBufferZoneBuilderPoly.Create;
begin
  FBuffer := TEzVector.Create(0);
  FBuffer.CanGrow := True;
  FBuilder := TmstBufferZoneBuilderLine.Create;
  FWidth := 2;
  FBuilder.Width := 2;
  FLine1.Empty := True;
  FLine2.Empty := True;
end;

destructor TmstBufferZoneBuilderPoly.Destroy;
begin
  FBuffer.Free;
  FBuilder.Free;
  inherited;
end;

procedure TmstBufferZoneBuilderPoly.JoinRects;
var
  Clp: TClipper;
begin
  Clp := TClipper.Create;
  try
    //Clp.AddPaths();

  finally
    Clp.Free;
  end;
end;

procedure TmstBufferZoneBuilderPoly.SetWidth(const Value: Double);
begin
  FWidth := Value;
  FBuilder.Width := FWidth;
end;

{ TmstBufferZoneBuilderPoly.TLine }

procedure TmstBufferZoneBuilderPoly.TLine.Calc(Pt1, Pt2: TEzPoint);
begin
  P1 := Pt1;
  P2 := Pt2;
  A := Pt1.y - Pt2.y;
  B := Pt1.x - Pt2.x;
  C := Pt2.x * Pt1.y - Pt1.x * Pt2.y;
  EMpty := False;
end;

{ TmstBufferZoneBuilderPoly2 }

procedure TmstBufferZoneBuilderPoly2.Build(aLine: TEzVector);
var
  Subj, Rslt: TPath;
  Sol: TPaths;
  I: Integer;
  ClpOffset: TClipperOffset;
begin
  FBuffer.Clear;
  SetLength(Subj, aLine.Count);
  for I := 0 to aLine.Count - 1 do
    Subj[I] := IntPoint(Round(aLine[I].X * 100), Round(aLine[I].Y * 100));
  ClpOffset := TClipperOffset.Create;
  try
    ClpOffset.AddPath(Subj, jtMiter, etOpenSquare);
    ClpOffset.Execute(Sol, FWidth * 100);
  finally
    ClpOffset.Free;
  end;
  if Length(Sol) = 1 then
  begin
    Rslt := Sol[0];
    for I := 0 to Length(Rslt) - 1 do
      FBuffer.Add(Point2D(Rslt[I].X / 100, Rslt[I].Y / 100));
  end;
end;

constructor TmstBufferZoneBuilderPoly2.Create;
begin
  FBuffer := TEzVector.Create(0);
  FBuffer.CanGrow := True;
end;

destructor TmstBufferZoneBuilderPoly2.Destroy;
begin
  FBuffer.Free;
  inherited;
end;

procedure TmstBufferZoneBuilderPoly2.SetWidth(const Value: Double);
begin
  FWidth := Value;
end;

end.
