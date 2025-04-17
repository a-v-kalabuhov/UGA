unit uEzRectRelation;

interface

uses
  EzLib;

type
  TEzRectRelation = class
  public
    class function RectsNotIntersects(const Rect1, Rect2: TEzRect): Boolean;
  end;

implementation

{ TEzRectRelation }

class function TEzRectRelation.RectsNotIntersects(const Rect1, Rect2: TEzRect): Boolean;
begin
  Result := True;
  if Rect1.xmax < Rect2.xmin then
    Exit;
  if Rect1.xmin > Rect2.xmax then
    Exit;
  if Rect1.ymax < Rect2.ymin then
    Exit;
  if Rect1.ymin > Rect2.ymax then
    Exit;
  Result := False;
end;

end.
