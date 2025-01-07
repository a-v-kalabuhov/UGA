unit uEzEntityCSConvert;

interface

uses
  EzBaseGIS, EzLib,
  uCK36, uGeoUtils, uGeoTypes;

type
  TEzCSConverter = class
  public
    class procedure EntityToVrn(Ent: TEzEntity; EntIsDecart: Boolean = False);
    class procedure ExchangeXY(Ent: TEzEntity);
    /// <summary>
    ///   XY = True - Х направлен вверх, входные данные в Декартовой системе кооринат 
    ///   XY = False - Х направлен вправо, а Y вверх - (входные данные в геодезических координатах
    /// </summary>
    class procedure Point2DToCK36(var aPoint: TEzPoint; XY: Boolean = True);
    class procedure Point2DToVrn(var aPoint: TEzPoint; XY: Boolean = True);
    class procedure Rect2DToCK36(var aRect: TEzRect; XY: Boolean = True);
    class procedure Rect2DToVrn(var aRect: TEzRect; XY: Boolean = True);
    class procedure XY2DToCK36(var aX, aY: Double; XY: Boolean = True);
    class procedure XY2DToVrn(var aX, aY: Double; XY: Boolean = True);
  end;

implementation

{ TEzCSConverter }

class procedure TEzCSConverter.ExchangeXY(Ent: TEzEntity);
var
  I: Integer;
begin
  for I := 0 to Ent.Points.Count - 1 do
    Ent.Points[I] := Point2D(Ent.Points[I].y, Ent.Points[I].x);
  Ent.UpdateExtension;
end;

class procedure TEzCSConverter.EntityToVrn(Ent: TEzEntity; EntIsDecart: Boolean);
var
  Crd: TCoords;
  I: Integer;
begin
  Crd.Geo := not EntIsDecart;
  for I := 0 to Ent.Points.Count - 1 do
  begin
    Crd.X := Ent.Points[I].x;
    Crd.Y := Ent.Points[I].y;
    Crd.Convert(csVrn);
    Ent.Points[I] := Point2D(Crd.X, Crd.Y);
  end;
end;

class procedure TEzCSConverter.Point2DToCK36(var aPoint: TEzPoint; XY: Boolean = True);
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

class procedure TEzCSConverter.Point2DToVrn(var aPoint: TEzPoint; XY: Boolean = True);
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

class procedure TEzCSConverter.Rect2DToCK36(var aRect: TEzRect; XY: Boolean = True);
begin
  Point2DToCK36(aRect.Emin, XY);
  Point2DToCK36(aRect.Emax, XY);
end;

class procedure TEzCSConverter.Rect2DToVrn(var aRect: TEzRect; XY: Boolean = True);
begin
  Point2DToVrn(aRect.Emin, XY);
  Point2DToVrn(aRect.Emax, XY);
end;

class procedure TEzCSConverter.XY2DToCK36(var aX, aY: Double; XY: Boolean);
var
  Xmest, Ymest, Xck36, Yck36: Double;
begin
  if XY then
  begin
    Xmest := aY;
    Ymest := aX;
  end
  else
  begin
    Xmest := aX;
    Ymest := aY;
  end;
  uCK36.ToCK36(Xmest, Ymest, Xck36, Yck36);
  if XY then
  begin
    aX := Yck36;
    aY := Xck36;
  end
  else
  begin
    aX := Xck36;
    aY := Yck36;
  end;
end;

class procedure TEzCSConverter.XY2DToVrn(var aX, aY: Double; XY: Boolean);
var
  Xmest, Ymest, Xck36, Yck36: Double;
begin
  if XY then
  begin
    Xck36 := aY;
    Yck36 := aX;
  end
  else
  begin
    Xck36 := aX;
    Yck36 := aY;
  end;
  uCK36.ToVRN(Xck36, Yck36, Xmest, Ymest);
  if XY then
  begin
    aX := Ymest;
    aY := Xmest;
  end
  else
  begin
    aX := Xmest;
    aY := Ymest;
  end;
end;

end.
