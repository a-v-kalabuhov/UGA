unit uEzEntityCSConvert;

interface

uses
  EzBaseGIS, EzLib,
  uCK36, uGeoUtils, uGeoTypes;

type
  TEzCSConverter = class
  public
    class procedure EntityToVrn(Ent: TEzEntity);
    class procedure ExchangeXY(Ent: TEzEntity);
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

class procedure TEzCSConverter.EntityToVrn(Ent: TEzEntity);
var
  Crd: TCoords;
  I: Integer;
begin
  Crd.Geo := True;
  for I := 0 to Ent.Points.Count - 1 do
  begin
    Crd.X := Ent.Points[I].x;
    Crd.Y := Ent.Points[I].y;
    Crd.Convert(csVrn);
    Ent.Points[I] := Point2D(Crd.X, Crd.Y);
  end;
end;

end.
