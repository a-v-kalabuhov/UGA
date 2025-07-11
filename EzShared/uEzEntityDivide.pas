unit uEzEntityDivide;

interface

uses
  SysUtils,
  EzBase, EzLib, EzBaseGIS, EzEntities,
  uEzGeometry;

type
  TEzEntityDivider = class
  private
    FEntity: TEzEntity;
    FResult1: TEzEntity;
    FResult2: TEzEntity;
    FDelta: Double;
    FDistance: Double;
  public
    constructor Create(aEntity: TEzEntity);
    destructor Destroy; override;
    //
    procedure Divide(const DivPoint: TEzPoint; const aDelta: Double = FiveMm);
    //
    property Result1: TEzEntity read FResult1;
    property Result2: TEzEntity read FResult2;
    property Distance: Double read FDistance;
  end;

implementation

{ TEzEntityDivider }

constructor TEzEntityDivider.Create(aEntity: TEzEntity);
begin
  if not (aEntity.EntityID in [idPolyline, idPolygon]) then
    raise Exception.Create('TEzEntityDivider.Create');
  FEntity := aEntity;
end;

destructor TEzEntityDivider.Destroy;
begin
  FreeAndNil(FResult1);
  FreeAndNil(FResult2);
  inherited;
end;

procedure TEzEntityDivider.Divide(const DivPoint: TEzPoint; const aDelta: Double);
var
  Tmp: TEzVector;
  R1: TEzVector;
  R2: TEzVector;
  I: Integer;
  Closed: Boolean;
  I1: Integer;
  I2: Integer;
  A, B: TEzPoint;
  D: Double;
begin
  FreeAndNil(FResult1);
  FreeAndNil(FResult2);
  //
  FDistance := MaxInt;
  FDelta := aDelta;
  Tmp := TEzVector.Create(0);
  R1 := TEzVector.Create(0);
  R2 := TEzVector.Create(0);
  try
    Closed := EqualPoint2D(FEntity.Points[0], FEntity.Points[FEntity.Points.Count - 1]);
    for I := 0 to FEntity.Points.Count - 1 do
      Tmp.Add(FEntity.Points[I]);
    if (FEntity.EntityID = idPolygon) and not Closed then
    begin
      Tmp.Add(FEntity.Points[0]);
    end;
    // считаем расстояние до объекта
    I2 := 1;
    for I1 := 0 to Tmp.Count - 2 do
    begin
      A := Tmp[I1];
      B := Tmp[I2];
      Inc(I2);
      TGeometry.DistanceLinePoint(DivPoint, A, B, FDelta, D);
      if D < FDistance then
        FDistance := D;
    end;
    //
    I2 := 1;
    for I1 := 0 to Tmp.Count - 2 do
    begin
      // строим отрезок
      A := Tmp[I1];
      B := Tmp[I2];
      R1.Add(A);
      // проверяем куда падает точка деления:
      // падает на конец отрезка
      // -- добавляем отрезок полностью в R1, R2 начнётся с конца отрезка
      // падает на середину отрезка
      // -- добавляем точку пересечения в R1 и с неё начнётчся R2, в R2 все точки с конца отрезка
      if TGeometry.IsPointsEqual(B, DivPoint, FDelta) then
      begin
        R1.Add(B);
        Break;
      end
      else
      if TGeometry.IsPointOnLine(DivPoint, A, B, FDelta) then
      begin
        R1.Add(DivPoint);
        R2.Add(DivPoint);
        Break;
      end;
      Inc(I2);
    end;
    for I := I2 to Tmp.Count - 1 do
       R2.Add(Tmp[I]);
    //
    if (R2.Count = 0) or (R1.Count = 0) then
    begin

    end
    else
    begin
      FResult1 := TEzPolyLine.Create(0, True);
      FResult1.Points.AddVector(R1);
      FResult2 := TEzPolyLine.Create(0, True);
      FResult2.Points.AddVector(R2);
    end;
  finally
    R2.Free;
    R1.Free;
    Tmp.Free;
  end;
end;

end.
