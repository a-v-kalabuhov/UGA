unit AGraph6;

interface

uses Windows, Forms, Graphics, Classes, Math;

var
  ScrPixPerMM: Double;

function RotatePoint(Center, Point: TPoint; Corner: Double=0): TPoint;
function PointIsInsideRect(Point: TPoint; Rect: TRect): Boolean;
function GetValidCorner(Corner: Double): Double;
procedure TextOutAlign(Canvas: TCanvas; X, Y, Width: Integer; S: string;
  Alignment: TAlignment);
procedure GetTextSize(Canvas: TCanvas; Text: string; var Size: TSize);

implementation

uses AProc6;

function RotatePoint(Center, Point: TPoint; Corner: Double=0): TPoint;
begin
  if Corner=0 then
    Result:=Point
  else begin
    Result.X:=Center.X+Round((Point.X-Center.X)*Cos(Corner)-(Point.Y-Center.Y)*Sin(Corner));
    Result.Y:=Center.Y+Round((Point.X-Center.X)*Sin(Corner)+(Point.Y-Center.Y)*Cos(Corner));
  end;
end;

function PointIsInsideRect(Point: TPoint; Rect: TRect): Boolean;
begin
  Result:=(Point.X in [Rect.Left..Rect.Right])and
    (Point.Y in [Rect.Top..Rect.Bottom]);
end;

function GetValidCorner(Corner: Double): Double;
begin
  Result:=Corner/(2*Pi); Result:=Result-Trunc(Result);
  Result:=Result*2*Pi;
end;

procedure TextOutAlign(Canvas: TCanvas; X, Y, Width: Integer; S: string;
  Alignment: TAlignment);
begin
  case Alignment of
    taRightJustify: X:=X+Width-Canvas.TextWidth(S);
    taCenter: X:=X+(Width-Canvas.TextWidth(S)) div 2;
  end;
  Canvas.TextOut(X,Y,S);
end;

procedure GetTextSize(Canvas: TCanvas; Text: string; var Size: TSize);
var
  I, StrCount: Integer;
begin
  if Text='' then begin
    Size.cx:=0; Size.cy:=0;
    Exit;
  end
  else
    StrCount:=1;
  Size.cx:=0;
  Size.cy:=Canvas.TextHeight(Text);
  I:=Pos(#13#10,Text);
  while I>0 do begin
    Size.cx:=Max(Size.cx,Canvas.TextWidth(Copy(Text,1,I-1)));
    Delete(Text,1,I+1);
    Inc(StrCount);
    I:=Pos(#13#10,Text);
  end;
  Size.cx:=Max(Size.cx,Canvas.TextWidth(Text));
  Size.cy:=Size.cy*StrCount;
end;

initialization
  ScrPixPerMM:=Screen.PixelsPerInch/MMPerInch;
end.
