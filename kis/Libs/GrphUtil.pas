unit GrphUtil;

interface

uses Graphics, Windows, Math;

type
  TDrawMode=Record
    PenMode: TPenMode;
    PenStyle: TPenStyle;
    PenColor: TColor;
    PenWidth: Integer;
    BrushStyle: TBrushStyle;
    BrushColor: TColor;
  end;

  function GetDrawMode(Canvas: TCanvas): TDrawMode;
  procedure SetDrawMode(Canvas: TCanvas; const DrawMode: TDrawMode);
  function GetDC(WND: HWND): HDC;
  procedure DropDC(DC: HDC; WND: HWND);
  procedure DrawRect(DC: HDC; X,Y,Width,Height: Integer);
  procedure DrawCompass(Canvas: TCanvas; X,Y,Radius,Corner: Integer);
  function RotatePoint(Center, Point: TPoint; Corner: Integer): TPoint;

implementation

function GetDrawMode(Canvas: TCanvas): TDrawMode;
begin
  with Canvas do begin
    Result.PenMode:=Pen.Mode;
    Result.PenStyle:=Pen.Style;
    Result.PenColor:=Pen.Color;
    Result.PenWidth:=Pen.Width;
    Result.BrushStyle:=Brush.Style;
    Result.BrushColor:=Brush.Color;
  end;
end;

procedure SetDrawMode(Canvas: TCanvas; const DrawMode: TDrawMode);
begin
  with Canvas do begin
    Pen.Mode:=DrawMode.PenMode;
    Pen.Style:=DrawMode.PenStyle;
    Pen.Color:=DrawMode.PenColor;
    Pen.Width:=DrawMode.PenWidth;
    Brush.Style:=DrawMode.BrushStyle;
    Brush.Color:=DrawMode.BrushColor;
  end;
end;

procedure SetInvertMode(Canvas: TCanvas);
begin
  with Canvas do begin
    Pen.Mode:=pmNotXor;
    Pen.Style:=psSolid;
    Pen.Color:=clBlack;
    Pen.Width:=2;
    Brush.Style:=bsClear;
  end;
end;

function GetDC(WND: HWND): HDC;
begin
  Result:=GetDCEx(WND,0,DCX_CACHE or DCX_CLIPSIBLINGS or
    DCX_LOCKWINDOWUPDATE);
end;

procedure DropDC(DC: HDC; WND: HWND);
begin
  ReleaseDC(WND,DC);
end;

procedure DrawRect(DC: HDC; X,Y,Width,Height: Integer);
const
  LineWidth=2;
begin
  PatBlt(DC,X,Y,Width,LineWidth,DSTINVERT);
  PatBlt(DC,X+Width-LineWidth,Y+LineWidth,LineWidth,Height-2*LineWidth,DSTINVERT);
  PatBlt(DC,X,Y+Height-LineWidth,Width,LineWidth,DSTINVERT);
  PatBlt(DC,X,Y+LineWidth,LineWidth,Height-2*LineWidth,DSTINVERT);
end;

procedure DrawCompass(Canvas: TCanvas; X,Y,Radius,Corner: Integer);
var
  DrawMode: TDrawMode;
  A: Real;
begin
  DrawMode:=GetDrawMode(Canvas);
  SetInvertMode(Canvas);
  A:=DegToRad(Corner);
  with Canvas do begin
    MoveTo(X+Trunc(Radius*Sin(A)),Y-Trunc(Radius*Cos(A)));
    LineTo(X-Trunc(Radius*Sin(A)),Y+Trunc(Radius*Cos(A)));
    MoveTo(X-Trunc(Radius*Cos(A)),Y-Trunc(Radius*Sin(A)));
    LineTo(X+Trunc(Radius*Cos(A)),Y+Trunc(Radius*Sin(A)));
  end;
  SetDrawMode(Canvas,DrawMode);
end;

function RotatePoint(Center, Point: TPoint; Corner: Integer): TPoint;
var
  A: Real;
begin
  A:=DegToRad(Corner);
  Result.X:=Center.X+Round((Point.X-Center.X)*Cos(A)-(Point.Y-Center.Y)*Sin(A));
  Result.Y:=Center.Y+Round((Point.X-Center.X)*Sin(A)+(Point.Y-Center.Y)*Cos(A));
end;

end.
