unit Draw;

interface

uses
  Graphics, Windows, Classes, Math, SysUtils,
  AGraph6, AString6, APrinter6, StrUtils, AProc6, uGC,
  uCommonUtils, uKisConsts,
  uKisAllotmentClasses;

type
  TAllotmentPointKind = (apkPoint, apkCross);

  TAllotmentPoint=record
    Id: LongInt;
    Name: string[10];
    X: Double;
    Y: Double;
    Length: Double;
    Azimuth: Double;
    Contour: Byte;
    Point: TPoint;
  end;
  //размер 55 байт, максимальное число точек отвода - 144

  TAllotmentPoints=array of TAllotmentPoint;
  TBooleans = array of Boolean;

procedure PrintRegion(Contours: TContours; Canvas: TCanvas; var Rect: TRect;
  PixPerMM: Double; LatinNames: Boolean; Scale: Double=0; Divisor: Integer=1;
  Corner: Double=0; Connect: Boolean=True; CrossSize: Integer = 0;
  LabelPoints: Boolean = False);
  
type
  TPrintRegion1Params = record
    Points: TContours;
    Canvas: TCanvas;
    Rect: TRect;
    PixPerMMH: Double;
    PixPerMMV: Double;
    LatinNames: Boolean;
    LineWidth: Integer;
    Scale: Double;
    Divisor: Integer;
    Corner: Double;
    Connect: Boolean;
    CrossSize: Integer;
    LabelPoints: Boolean;
    LineLabels: Boolean;
    LabelsFont: TFont;
    Cs: TCoordSystem;
  end;

procedure PrintRegion1(var Params: TPrintRegion1Params);

procedure PrintCoord(Contours: TContours;  Cs: TCoordSystem; Canvas: TCanvas;
  var Rect: TRect; Scale: Double; Font: TFont; MaxRows: Integer;
  LatinNumber: Boolean=True; ShowLength: Boolean=True; ShowAzimuth: Boolean=False;
  ShowOnPoint: Boolean=False; ShowInfo: Boolean=False; ShowNeigh: Boolean=False;
  Information: string=''; Neighbours: string = '');
procedure PrintCoord2(Contours: TContours; Cs: TCoordSystem; Canvas: TCanvas; var Rect: TRect;
  Scale: Double; Font: TFont; MaxRows: Integer; LatinNumber: Boolean=True;
  ShowLength: Boolean=True; ShowAzimuth: Boolean=False;
  ShowOnPoint: Boolean=False; ShowInfo: Boolean=False; ShowNeigh: Boolean=False; Information: string=''; Neighbours: string = '');
function GetPointName(const Name: string; Latin: Boolean=True): string;
procedure PrintCompass(Canvas: TCanvas; var Rect: TRect; Corner: Double;
  Scale: Double);
procedure PrintScale(Canvas: TCanvas; var Rect: TRect; Scale: Real;
  Divisor: Integer);
procedure LoadText(const FileName: string; Canvas: TCanvas; PixPerMM: Double;
  Scale: Double; Params: TStrings);
function ExtractMacros(var SourceSt: string): string;

implementation

procedure PrintRegion(Contours: TContours; Canvas: TCanvas; var Rect: TRect;
  PixPerMM: Double; LatinNames: Boolean; Scale: Double = 0; Divisor: Integer = 1;
  Corner: Double = 0; Connect: Boolean = True; CrossSize: Integer = 0;
  LabelPoints: Boolean = False);
//Scale=Pix/M
{Points: динамический массив точек
Contours: динамический массив контуров
Canvas: холст, на котором надо рисовать
Rect: область, в которой будем рисовать;
  если Scale=0 то рисунок будет подгоняться под нее
PixPerMM: число пикселей на мм для устройства вывода
Scale: коэффициент, показвающий, на сколько уменьшить изображение по
  сравнению со 100%; применяется, например, для того, чтобы уместить лист на экране
Divisor: масштаб карты
Corner: угол повората в радианах}
var
  I, J, Ic, i1: Integer;
  LeftX,RightX,TopY,BottomY: Integer;
  LenX,LenY: Double;
  PixPerM: Extended;
  //CanvasPoints: array of TPoint;
  PenColor, BrushColor, Color: TColor;
  CrossPoint: TKisPoint;
  CrossPoints: TContour;

  function CalcPoint(P: TKisPoint; YMin, XMin: Double): TPoint;
  begin
    Result.X:=Round(PixPerM*(P.Y - YMin));
    Result.Y:=Round(PixPerM*(LenX - P.X + XMin));
  end;

  procedure DrawPoint(Pt: TKisPoint);
  const
    Radius = 0.3; //радиус точки в мм
    Step: Integer = 1; //отступ названия точки от точки в мм
  var
    R: Integer;
  begin
    R := Round(Radius * PixPerMM);
    with Canvas do
    begin
      if Connect then
        LineTo(Pt.ScreenPt.X, Pt.ScreenPt.Y)
      else
        MoveTo(Pt.ScreenPt.X, Pt.ScreenPt.Y);
      Ellipse(Pt.ScreenPt.X - R, Pt.ScreenPt.Y - R, Pt.ScreenPt.X + R + 1, Pt.ScreenPt.Y + R + 1);
      if LabelPoints then
      begin
        Brush.Style := bsClear;
        TextOut(Pt.ScreenPt.X + Step, Pt.ScreenPt.Y, GetPointName(Pt.Name, LatinNames));
      end;
      MoveTo(Pt.ScreenPt.X, Pt.ScreenPt.Y);
    end;
  end;

  procedure GetCrosses(Center: TKisPoint; Contour: TContour);
  var
    X, Y: Double;
  begin
    Contour.Clear;
    X := Int(center.X / Divisor * 10) * Divisor / 10;
    Y := Int(center.Y / Divisor * 10) * Divisor / 10;
    Contour.AddPoint(X, Y);
    X := Contour[0].X + IfThen(Center.X >= 0, 1, -1) * Divisor / 10;
    Y := Contour[0].Y + IfThen(Center.Y >= 0, 1, -1) * Divisor / 10;
    Contour.AddPoint(X, Y);
    X := Contour[0].X + IfThen(Center.X >= 0, 1, -1) * Divisor / 10;
    Y := Contour[0].Y;
    Contour.AddPoint(X, Y);
    X := Contour[0].X;
    Y := Contour[0].Y + IfThen(Center.Y >= 0, 1, -1) * Divisor / 10;
    Contour.AddPoint(X, Y);
  end;

var
  Cnt: TContour;
  ExtAll, ExtCnt: TKisExtent;
  B: Boolean;
begin
  CrossPoints := nil;
  //находим минимум и максимум координат
  ExtAll := nil;
  for I := 0 to Pred(Contours.Count) do
  begin
    Cnt := Contours[I];
    if Cnt.Enabled and (Cnt.Count > 0) then
    begin
      if ExtAll = nil then
        ExtAll := Cnt.GetExtent
      else
      begin
        ExtCnt := Cnt.GetExtent;
        ExtAll.Join(ExtCnt);
      end;
    end;
  end;
  ///
  if not Assigned(ExtAll) then
    Exit;
  // Находим узлы сетки
  CrossPoints := TContour.Create;
  try
    CrossPoint := TKisPoint.Create(0, 0);
    try
      if CrossSize > 0 then
      begin
        CrossPoint.X := ExtAll.FXmin + (ExtAll.FXmax - ExtAll.FXmin) / 2;
        CrossPoint.Y := ExtAll.FYmin + (ExtAll.FYmax - ExtAll.FYmin) / 2;
        GetCrosses(CrossPoint, CrossPoints);
        for I := 0 to 3 do
        begin
          ExtAll.FXmin := Min(ExtAll.FXmin, CrossPoints[I].X);
          ExtAll.FYmin := Min(ExtAll.FYmin, CrossPoints[I].Y);
          ExtAll.FXmax := Max(ExtAll.FXmax, CrossPoints[I].X);
          ExtAll.FYmax := Max(ExtAll.FYmax, CrossPoints[I].Y);
        end;
      end;
    finally
      FreeAndNil(CrossPoint);
    end;
    ///
    LenX := ExtAll.FXmax - ExtAll.FXmin;
    LenY := ExtAll.FYmax - ExtAll.FYmin;
    ///
    if (LenX = 0) or (LenY = 0) then
      Exit;
    //если надо, находим масштаб
    if Scale = 0 then
    begin
      PixPerM := Min((Rect.Right - Rect.Left - 1) / LenY, (Rect.Bottom - Rect.Top - 1) / LenX);
      Scale := 1.5;
    end
    else
      PixPerM := 1000 * PixPerMM * Scale / Divisor;
    //Рисуем участок
    with Canvas do
    begin
      Font.Name := S_FONT1;
      Font.Size := Round(8 / Scale);
      //находим приблизительные размеры изображения (без учета поворота)
      Rect.Right := Rect.Left + Round(PixPerM * LenY);
      Rect.Bottom := Rect.Top + Round(PixPerM * LenX);
      LeftX := 0;
      TopY := 0;
      RightX := 0;
      BottomY := 0;
      //поворачиваем точки
      B := False;
      for I := 0 to Pred(Contours.Count) do
      begin
        Cnt := Contours[I];
        if Cnt.Enabled then
          for J := 0 to Cnt.Count - 1 do
          begin
            Cnt[J].ScreenPt := CalcPoint(Cnt[J], ExtAll.FYmin, ExtAll.FXmin);
            Cnt[J].ScreenPt := RotatePoint(Point((Rect.Right - Rect.Left) div 2,
              (Rect.Bottom - Rect.Top) div 2), Cnt[J].ScreenPt, Corner);
            if B then
            begin
              LeftX := Min(LeftX, Cnt[J].ScreenPt.X);
              RightX := Max(RightX, Cnt[J].ScreenPt.X);
              TopY := Min(TopY, Cnt[J].ScreenPt.Y);
              BottomY := Max(BottomY, Cnt[J].ScreenPt.Y);
            end
            else
            begin
              LeftX := Cnt[J].ScreenPt.X;
              RightX := Cnt[J].ScreenPt.X;
              TopY := Cnt[J].ScreenPt.Y;
              BottomY := Cnt[J].ScreenPt.Y;
              B := True;
            end;
          end;
      end;

      // пересчитываем узлы сетки
      if CrossSize > 0 then
      begin
        for Ic := 0 to 3 do
        begin
          CrossPoints[Ic].ScreenPt := CalcPoint(CrossPoints[Ic], ExtAll.FYmin, ExtAll.FXmin);
          CrossPoints[Ic].ScreenPt := RotatePoint(Point((Rect.Right - Rect.Left) div 2,
              (Rect.Bottom - Rect.Top) div 2), CrossPoints[Ic].ScreenPt, Corner);
          for i1 := -1 to 1 do
          begin
            LeftX := Min(LeftX, CrossPoints[Ic].ScreenPt.X + i1 * 25);
            RightX := Max(RightX, CrossPoints[Ic].ScreenPt.X + i1 * 25);
            TopY := Min(TopY, CrossPoints[Ic].ScreenPt.Y + i1 * 25);
            BottomY := Max(BottomY, CrossPoints[Ic].ScreenPt.Y + i1 * 25);
          end;
        end;
      end;

      // рисуем кресты
      if CrossSize > 0 then
      begin
        for Ic := 0 to 3 do
        begin
          CrossPoints[Ic].ScreenPt := Point(
            Rect.Left + CrossPoints[Ic].ScreenPt.X - LeftX,
            Rect.Top + CrossPoints[Ic].ScreenPt.Y - TopY);
          Canvas.MoveTo(CrossPoints[Ic].ScreenPt.X - CrossSize, CrossPoints[Ic].ScreenPt.Y);
          Canvas.LineTo(CrossPoints[Ic].ScreenPt.X + CrossSize, CrossPoints[Ic].ScreenPt.Y);
          Canvas.MoveTo(CrossPoints[Ic].ScreenPt.X, CrossPoints[Ic].ScreenPt.Y - CrossSize);
          Canvas.LineTo(CrossPoints[Ic].ScreenPt.X, CrossPoints[Ic].ScreenPt.Y + CrossSize);
        end;
      end;
      //рисуем точки
      PenColor := Canvas.Pen.Color;
      BrushColor := Canvas.Brush.Color;
      for I := 0 to Pred(Contours.Count) do
      begin
        Cnt := Contours[I];
        if Cnt.Enabled then
        begin
          Color := Cnt.GetDrawColor();
          Canvas.Pen.Color := Color;
          Canvas.Brush.Color := Color;
          ///
          for J := 0 to Cnt.Count - 1 do
          begin
            Cnt[J].ScreenPt := Point(
              Rect.Left + Cnt[J].ScreenPt.X - LeftX,
              Rect.Top + Cnt[J].ScreenPt.Y - TopY);
            if J = 0 then
            begin
              Canvas.MoveTo(Cnt[J].ScreenPt.X, Cnt[J].ScreenPt.Y);
              DrawPoint(Cnt[J]);
            end
            else
              DrawPoint(Cnt[J]);
          end;
          if (Cnt.Count > 2) and Cnt.Closed then
              DrawPoint(Cnt[0]);
        end;
      end;
      Canvas.Pen.Color := PenColor;
      Canvas.Brush.Color := BrushColor;
      Rect.Right := Rect.Left + RightX - LeftX;
      Rect.Bottom := Rect.Top + BottomY - TopY;
    end;
  finally
    FreeAndNil(CrossPoints);
  end;
end;

procedure PrintCoord(Contours: TContours; Cs: TCoordSystem;
  Canvas: TCanvas; var Rect: TRect;
  Scale: Double; Font: TFont; MaxRows: Integer; LatinNumber: Boolean=True;
  ShowLength: Boolean=True; ShowAzimuth: Boolean=False;
  ShowOnPoint: Boolean=False; ShowInfo: Boolean=False; ShowNeigh: Boolean=False; Information: string=''; Neighbours: string = '');
const
  Width1=10; Width2=12; Width3=12; Width4=8; Width5=8; Width6=12;//ширина колонок в символах
  Field=2; // отступ рамки от текста в пикселах
var
  I, J, K, PointsCount,Row,Col,Y,X1,X2,X3,X4,X5,X6,ColWidth, TitleHeight: Integer;
  St, Info: string;
  MultiKontur: Boolean;
  R: TRect;
  S: TSize;

  procedure ResetX;
  begin
    X1:=Rect.Left+Field+(Col-1)*ColWidth;
    X2:=X1+Canvas.TextWidth(StringOfChar('9',Width1));
    X3:=X2+Canvas.TextWidth(StringOfChar('9',Width2));
    X4:=X3+Canvas.TextWidth(StringOfChar('9',Width3));
    X5:=X4+IfThen(ShowLength,Canvas.TextWidth(StringOfChar('9',Width4)),0);
    X6:=X5+IfThen(ShowAzimuth,Canvas.TextWidth(StringOfChar('9',Width5)),0);
  end;

  procedure DrawTitle;
  begin
    with Canvas do begin
      TextOut(X1,Rect.Top, '№');
      TextOut(X2,Rect.Top, SF_X);
      TextOut(X3,Rect.Top, SF_Y);
      if ShowLength then TextOut(X4,Rect.Top,'Длина');
      if ShowAzimuth then TextOut(X5,Rect.Top,'Азимут');
      if ShowOnPoint then TextOut(X6,Rect.Top,'На точку');
      MoveTo(X1,Rect.Top + Round(Abs(Font.Height) * 1.25));
      LineTo(X1+ColWidth, Rect.Top+Round(Abs(Font.Height) * 1.25));
    end;
  end;

var
  Cnt: TContour;
  Xpt, Ypt: Double;
begin
  Canvas.Font.Assign(Font);
  MultiKontur := Contours.EnabledCount > 1;
  with Canvas do
  begin
    PointsCount:=0;
    Row:=0; Col:=1;
    Font.Size:=Round(Font.Size*Scale);
    TextOut(0,0,' '); //нужно для инициализации
    I:=Width1+Width2+Width3+IfThen(ShowLength,Width4,0)+IfThen(ShowAzimuth,Width5,0)+
      IfThen(ShowOnPoint,Width6,0);
    ColWidth:=TextWidth(StringOfChar('9',I));
    ResetX;
    TitleHeight:=Round(Abs(1.5*Font.Height));
    DrawTitle;
    for I := 0 to Pred(Contours.Count) do
    begin
      Cnt := Contours[I];
      if not Cnt.Enabled then
        Continue;

      Inc(Row);
      if Row > MaxRows then
      begin
        Row := 1;
        Inc(Col);
        ResetX;
        DrawTitle;
        MoveTo(X1-Field,Rect.Top+Field);
        LineTo(X1-Field,Rect.Top+MaxRows*Abs(Font.Height)+Field+TitleHeight);
      end;

      for J := 0 to Cnt.Count - 1 do
      begin
        Inc(Row);
        Inc(PointsCount);
        Y:=Rect.Top+TitleHeight+Field+(Row-1)*Abs(Font.Height);

        TextOut(X1,Y,IfThen(MultiKontur, Cnt.Name + '/', '') +
          GetPointName(Cnt[J].Name, LatinNumber));

        if Cs = csVrn then
        begin
          Xpt := Cnt[J].X;
          Ypt := Cnt[J].Y;
        end
        else
        begin
          Xpt := Cnt[J].X36;
          Ypt := Cnt[J].Y36;
        end;
        Str(Xpt :Width2 :2, St);
        TextOut(X2,Y,Trim(St));
        Str(Ypt :Width3 :2, St);
        TextOut(X3,Y,Trim(St));
        if ShowLength then
        begin
//          Str(Cnt.Length(J, Params.Cs) :Width4 :2,St);
          Str(Cnt.GetLength(J, Cs) :Width4 :2,St);
          TextOut(X4,Y,Trim(St));
        end;
        if ShowAzimuth then
          TextOut(X5,Y,Trim(GetDegreeCorner(Cnt.Azimuth(J, Cs))));
        if ShowOnPoint then
        begin
          if J = Pred(Cnt.Count) then
            K := 0
          else
            K := J + 1;
          TextOut(X6,Y,IfThen(MultiKontur, Cnt.Name + '/','')+
            GetPointName(Cnt[K].Name, LatinNumber));
        end;
      end;
    end;
    if PointsCount>0 then
    begin
      Rect.Right:=Rect.Left+Col*ColWidth;
      Rect.Bottom:=Rect.Top+IfThen(Col=1,Row,MaxRows)*Abs(Font.Height)+
        2*Field+TitleHeight;
    end;
    //печатаем информацию
    I:=TextWidth('88');
    if ShowInfo and (Information<>'') then
    begin
      Info := Information;
    end;
    if ShowNeigh and (Neighbours <> '') then
    begin
      if Info <> '' then Info := Info + #13;
      Info := Info + Neighbours;
    end;
    if Info <> '' then
    begin
      GetTextSize(Canvas, Info, S);
      R:=Classes.Rect(Rect.Right+I,Rect.Top,Rect.Right+S.cx+I,Rect.Top+S.cy);
      DrawText(Handle, PChar(Info), -1, R, 0);
      Rect.Right:=R.Right;
      Rect.Bottom:=Max(Rect.Bottom,R.Bottom);
    end;
  end;
end;

procedure PrintCoord2(Contours: TContours; Cs: TCoordSystem;
  Canvas: TCanvas; var Rect: TRect;
  Scale: Double; Font: TFont; MaxRows: Integer; LatinNumber: Boolean=True;
  ShowLength: Boolean=True; ShowAzimuth: Boolean=False;
  ShowOnPoint: Boolean=False; ShowInfo: Boolean=False; ShowNeigh: Boolean=False; Information: string=''; Neighbours: string = '');
const
  Width1=10; Width2=12; Width3=12; Width4=8; Width5=8; Width6=12;  Width7=10;//ширина колонок в символах
  Field=2; // отступ рамки от текста в пикселах
var
  I,J,K,PointsCount,Row,Col,Y,X1,X2,X3,X4,X5,X6,X7,ColWidth,
    TitleHeight: Integer;
  St: string;
  MultiKontur: Boolean;
  D: Double;
  R: TRect;
  S: TSize;

  procedure Line(X1,Y1,X2,Y2: Integer);
  begin
    Canvas.MoveTo(X1,Y1);
    Canvas.LineTo(X2,Y2);
  end;
  procedure ResetX;
  begin
    X1:=Rect.Left+(Col-1)*ColWidth;
    X2:=X1+Canvas.TextWidth(StringOfChar('9',Width1));
    X3:=X2+Canvas.TextWidth(StringOfChar('9',Width2));
    X4:=X3+Canvas.TextWidth(StringOfChar('9',Width3));
    X5:=X4+IfThen(ShowAzimuth,Canvas.TextWidth(StringOfChar('9',Width4)),0);
    X6:=X5+IfThen(ShowAzimuth,Canvas.TextWidth(StringOfChar('9',Width5)),0);
    X7:=X6+IfThen(ShowLength,Canvas.TextWidth(StringOfChar('9',Width6)),0);
  end;

  procedure DrawTitle;
  begin
    with Canvas do begin
      Line(X1,Rect.Top,X1+ColWidth,Rect.Top);
      Line(X1,Rect.Top+TitleHeight,X1+ColWidth,Rect.Top+TitleHeight);
      Line(X1,Rect.Top,X1,Rect.Top+TitleHeight);
      Line(X2,Rect.Top,X2,Rect.Top+TitleHeight);
      Line(X3,Rect.Top+TitleHeight div 2,X3,Rect.Top+TitleHeight);
      Line(X4,Rect.Top,X4,Rect.Top+TitleHeight);
      Line(X2,Rect.Top+TitleHeight div 2,X4,Rect.Top+TitleHeight div 2);
      if ShowAzimuth then begin
        Line(X6,Rect.Top,X6,Rect.Top+TitleHeight);
        Line(X5,Rect.Top+TitleHeight div 2,X5,Rect.Top+TitleHeight);
        Line(X4,Rect.Top+TitleHeight div 2,X6,Rect.Top+TitleHeight div 2);
      end;
      if ShowLength then Line(X7,Rect.Top,X7,Rect.Top+TitleHeight);
      if ShowOnPoint then Line(X1+ColWidth,Rect.Top,X1+ColWidth,Rect.Top+TitleHeight);

      TextOutAlign(Canvas,X1,Rect.Top+Field,X2-X1,'№ точ.',taCenter);
      TextOutAlign(Canvas,X1,Rect.Top+Field+TitleHeight div 2,X2-X1,'п/п',taCenter);
      TextOutAlign(Canvas,X2,Rect.Top+Field,X4-X2,'Координаты',taCenter);
      TextOutAlign(Canvas,X2,Rect.Top+Field+TitleHeight div 2,X3-X2,SF_X,taCenter);
      TextOutAlign(Canvas,X3,Rect.Top+Field+TitleHeight div 2,X4-X3,SF_Y,taCenter);
      if ShowAzimuth then begin
        TextOutAlign(Canvas,X4,Rect.Top+Field,X6-X4,'Дирекц. угол',taCenter);
        TextOutAlign(Canvas,X4,Rect.Top+Field+TitleHeight div 2,X5-X4,'град.',taCenter);
        TextOutAlign(Canvas,X5,Rect.Top+Field+TitleHeight div 2,X6-X5,'мин.',taCenter);
      end;
      if ShowLength then begin
        TextOutAlign(Canvas,X6,Rect.Top+Field,X7-X6,'Меры',taCenter);
        TextOutAlign(Canvas,X6,Rect.Top+Field+TitleHeight div 2,X7-X6,'линий (м)',taCenter);
      end;
      if ShowOnPoint then
      begin
        TextOutAlign(Canvas,X7,Rect.Top+Field,X1+ColWidth-X7,'На',taCenter);
        TextOutAlign(Canvas,X7,Rect.Top+Field+TitleHeight div 2,X1+ColWidth-X7,'точку',taCenter);
      end;
    end;
  end;

var
  Cnt: TContour;
  Xpt, Ypt: Double;
begin
  Canvas.Font.Assign(Font);
  MultiKontur := Contours.EnabledCount > 1;
  with Canvas do
  begin
    PointsCount:=0;
    Row:=0; Col:=1;
    Font.Size:=Round(Font.Size*Scale);
    TextOut(0, 0, ' '); //нужно для инициализации
    I := Width1 + Width2 + Width3 + IfThen(ShowAzimuth,Width4+Width5,0)
      + IfThen(ShowLength,Width6,0) + IfThen(ShowOnPoint,Width7,0);
    ColWidth:=TextWidth(StringOfChar('9',I));
    TitleHeight:=Round(Abs(3*Font.Height));
    ResetX;
    DrawTitle;
    for I:=0 to Pred(Contours.Count) do
    begin
      Cnt := Contours[I];
      if not Cnt.Enabled then
        Continue;

      Inc(Row);
      if Row>MaxRows then
      begin
        Row:=1;
        Inc(Col);
        ResetX;
        DrawTitle;
        MoveTo(X1-Field,Rect.Top+Field);
        LineTo(X1-Field,Rect.Top+MaxRows*Abs(Font.Height)+Field+TitleHeight);
      end;

      for J := 0 to Cnt.Count - 1 do
      begin
        Inc(Row);
        Inc(PointsCount);
        Y:=Rect.Top+TitleHeight+Field+(Row-1)*Abs(Font.Height);
        TextOutAlign(Canvas,X1,Y,X2-X1,IfThen(MultiKontur, Cnt.Name+'/','')+
          GetPointName(Cnt[J].Name, LatinNumber),taCenter);
        if Cs = csVrn then
        begin
          Xpt := Cnt[J].X;
          Ypt := Cnt[J].Y;
        end
        else
        begin
          Xpt := Cnt[J].X36;
          Ypt := Cnt[J].Y36;
        end;
        Str(Xpt :Width2 :2,St);
        TextOutAlign(Canvas,X2,Y,X3-X2,Trim(St),taCenter);
        Str(Ypt :Width3 :2,St);
        TextOutAlign(Canvas,X3,Y,X4-X3,Trim(St),taCenter);
        if ShowAzimuth then
        begin
          D:=RadToDeg(Cnt.Azimuth(J, Cs));
          TextOutAlign(Canvas,X4,Y,X5-X4,IntToStr(Trunc(D)),taCenter);
          TextOutAlign(Canvas,X5,Y,X6-X5,Format('%0.1f',[(D-Trunc(D))*60]),taCenter);
        end;
        if ShowLength then
        begin
          Str(Cnt.GetLength(J, Cs) :Width4 :2,St);
          TextOutAlign(Canvas,X6,Y,X7-X6,Trim(St),taCenter);
        end;
        if ShowOnPoint then
        begin
          if J = Pred(Cnt.Count) then
            K := 0
          else
            K := J + 1;
          TextOutAlign(Canvas,X7,Y,X1+ColWidth-X7,IfThen(MultiKontur,Cnt.Name+'/','')
            + GetPointName(Cnt[K].Name, LatinNumber),taCenter);
        end;
      end;
    end;
    if PointsCount>0 then
    begin
      Rect.Right:=Rect.Left+Col*ColWidth;
      Rect.Bottom:=Rect.Top+IfThen(Col=1,Row,MaxRows)*Abs(Font.Height)+TitleHeight+
        2*Field;
    end;
    //печатаем информацию
    I:=TextWidth('88');
    if ShowInfo and (Information<>'') and (Neighbours <> '') then
    begin
      GetTextSize(Canvas, Information + #13 + Neighbours,S);
      R:=Classes.Rect(Rect.Right+I,Rect.Top,Rect.Right+S.cx+I,Rect.Top+S.cy);
      DrawText(Handle, PChar(Information + #13 + Neighbours), -1, R, 0);
      Rect.Right:=R.Right;
      Rect.Bottom:=Max(Rect.Bottom,R.Bottom);
    end;
  end;
end;

function GetPointName(const Name: string; Latin: Boolean = True): string;
var
  I, Code: Integer;
begin
  Result:=Name;
  if Latin then
  begin
    Val(Result,I,Code);
    if Code=0 then
      Result:=ArabianToLatin(I);
  end;
end;

procedure PrintCompass(Canvas: TCanvas; var Rect: TRect; Corner: Double;
  Scale: Double);
const
  ArrowLength=30; //длина стрелки (мм)
  DashLength=5; //длина засечек (мм)
  DashCorner=30; //угол наклона засечек (градусы)
var
  APoint: Array [1..6] of TPoint;
  Center: TPoint;
  MinX,MaxX,MinY,MaxY,I: Integer;
begin
  with Canvas do
  begin
    //заполняем массив точек
    APoint[1].X:=0;
    APoint[1].Y:=Round(DashLength*Cos(DegToRad(DashCorner))*Scale);
    APoint[2].X:=Round(DashLength*Sin(DegToRad(DashCorner))*Scale);
    APoint[2].Y:=0;
    APoint[3].X:=Round(2*DashLength*Sin(DegToRad(DashCorner))*Scale);
    APoint[3].Y:=Round(DashLength*Cos(DegToRad(DashCorner))*Scale);
    APoint[4].X:=0;
    APoint[4].Y:=Round(ArrowLength*Scale);
    APoint[5].X:=Round(DashLength*Sin(DegToRad(DashCorner))*Scale);
    APoint[5].Y:=Round((ArrowLength-DashLength*Cos(DegToRad(DashCorner)))*Scale);
    APoint[6].X:=Round(2*DashLength*Sin(DegToRad(DashCorner))*Scale);
    APoint[6].Y:=Round(ArrowLength*Scale);

    //поворачиваем точки на указанный угол и находим размеры повернутой фигуры
    Center:=Point(Round(DashLength*Sin(DegToRad(DashCorner))*Scale),
      Round(ArrowLength/2*Scale));
    MinX:=0; MinY:=0; MaxX:=0; MaxY:=0;
    for I:=1 to 6 do begin
      APoint[I]:=RotatePoint(Center,APoint[I],Corner);
      if I=1 then begin
        MinX:=APoint[I].X; MaxX:=APoint[I].X;
        MinY:=APoint[I].Y; MaxY:=APoint[I].Y; end
      else begin
        MinX:=Min(MinX,APoint[I].X); MaxX:=Max(MaxX,APoint[I].X);
        MinY:=Min(MinY,APoint[I].Y); MaxY:=Max(MaxY,APoint[I].Y);
      end;
    end;

    //сдвигаем точки по отношению к левому верхнему углу Rect
    for I:=1 to 6 do begin
      APoint[I].X:=Rect.Left+APoint[I].X-MinX;
      APoint[I].Y:=Rect.Top+APoint[I].Y-MinY;
    end;

    //рисуем по точкам
    MoveTo(APoint[1].X,APoint[1].Y);
    LineTo(APoint[2].X,APoint[2].Y);
    LineTo(APoint[3].X,APoint[3].Y);

    MoveTo(APoint[2].X,APoint[2].Y);
    LineTo(APoint[5].X,APoint[5].Y);

    MoveTo(APoint[4].X,APoint[4].Y);
    LineTo(APoint[5].X,APoint[5].Y);
    LineTo(APoint[6].X,APoint[6].Y);

    //изменяем Rect в соответствии с размером изображения
    Rect.Right:=Rect.Left+MaxX-MinX;
    Rect.Bottom:=Rect.Top+MaxY-MinY;
  end;
end;

procedure PrintScale(Canvas: TCanvas; var Rect: TRect; Scale: Real;
  Divisor: Integer);
const
  FontSize=14;
var
  St: String;
begin
  St:='Масштаб=1:'+IntToStr(Divisor);
  with Canvas do begin
    Font.Name:='Times New Roman';
    Font.Charset:=RUSSIAN_CHARSET;
    Font.Size:=Round(FontSize*Scale);
    Rect.Right:=Rect.Left+TextWidth(St);
    Rect.Bottom:=Rect.Top+TextHeight(St);
    TextOut(Rect.Left,Rect.Top,St);
  end;
end;

procedure LoadText(const FileName: string; Canvas: TCanvas; PixPerMM: Double;
  Scale: Double; Params: TStrings);
//PixPerMM - разрешение устройства вывода
//Scale - уменьшение размера изображения
var
  F: TextFile;
  St: String;
  NumSt,Left,Top: Integer;
  R: Real;

  procedure SetDefaultFont;
  begin
    with Canvas.Font do
    begin
      Name:='Times New Roman';
      Style:=[];
      Charset := RUSSIAN_CHARSET;
      Size := 10;
    end;
  end;

  procedure SetDefaultPen;
  begin
    with Canvas.Pen do begin
      Width:=Round(0.1*PixPerMM/Scale);
      Style:=psSolid;
    end;
  end;

  procedure ReadMacros;
  var
    Macros: String;
    DPos,X1,Y1,X2,Y2: Integer;
  label
    EndPro;
  begin
    Macros:=ExtractMacros(St);
    if (Macros='')and(St='') then exit;
    if Macros<>'' then begin
      //интерпретируем макрос
      //координаты строки
      if Macros[1] in NumberChars then
      begin
        DPos:=Pos(',',Macros);
        Left:=StrToInt(Copy(Macros,1,DPos-1));
        Top:=StrToInt(Copy(Macros,DPos+1,255));
        //переводим позицию вывода из мм в пиксели и изменяем ее в соответствии с масштабом
        Left:=Round(Left*PixPerMM/Scale);
        Top:=Round(Top*PixPerMM/Scale);
        goto EndPro;
      end;
      //шрифт
      if Pos('ШРИФТ',Macros)=1 then with Canvas.Font do begin
        DPos:=Pos('=',Macros);
        Macros:=Trim(Copy(Macros,DPos+1,255));
        if Macros='' then SetDefaultFont else begin
          //Выделяем название
          DPos:=Pos(',',Macros);
          if DPos=0 then DPos:=255;
          Name:=Trim(Copy(Macros,1,DPos-1));
          Macros:=Trim(Copy(Macros,DPos+1,255));
          //выделяем размер
          if Macros<>'' then begin
            DPos:=Pos(',',Macros);
            if DPos=0 then DPos:=255;
            Size:=StrToInt(Trim(Copy(Macros,1,DPos-1)));
            //изменяем размер шрифта в соответствии с масштабом
            Size:=Trunc(Size/Scale);
            Macros:=Trim(Copy(Macros,DPos+1,255));
            //выделяем стиль
            if Macros<>'' then begin
              Style:=[];
              if Pos('ЖИРНЫЙ',Macros)>0 then Style:=Style+[fsBold];
              if Pos('НАКЛОННЫЙ',Macros)>0 then Style:=Style+[fsItalic];
              if Pos('ПОДЧЕРКНУТЫЙ',Macros)>0 then Style:=Style+[fsUnderline];
              if Pos('ЗАЧЕРКНУТЫЙ',Macros)>0 then Style:=Style+[fsStrikeout];
            end;
          end;
        end;
        goto EndPro;
      end;
      //тип линии
      if Pos('ВИД_ЛИНИИ',Macros)=1 then with Canvas.Pen do begin
        DPos:=Pos('=',Macros);
        Macros:=Trim(Copy(Macros,DPos+1,255));
        if Macros='' then SetDefaultPen else begin
          //Выделяем ширину
          DPos:=Pos(',',Macros);
          if DPos=0 then DPos:=255;
          Val(Trim(Copy(Macros,1,DPos-1)),R,X1);
          if X1 = 0 then
            Width := Round(R*PixPerMM/Scale)
          else
            MessageBox(0, PChar('Строка:'+IntToStr(NumSt) + #13 + 'Неверная ширина линии'),
              PChar(S_Error), MB_ICONSTOP);
          Macros := Trim(Copy(Macros,DPos+1,255));
          //выделяем тип
          if Macros<>'' then
            if Pos('ПУНКТИР_ТОЧКА_ТОЧКА',Macros)>0 then Style:=psDashDotDot else
            if Pos('ПУНКТИР_ТОЧКА',Macros)>0 then Style:=psDashDot else
            if Pos('ТОЧКИ',Macros)>0 then Style:=psDot else
            if Pos('ПУНКТИР',Macros)>0 then Style:=psDash else
            if Pos('СПЛОШНАЯ',Macros)>0 then Style:=psSolid;
        end;
        goto EndPro;
      end;
      //вывод линии
      if Pos('ЛИНИЯ',Macros)=1 then begin
        DPos:=Pos('=',Macros);
        Macros:=Trim(Copy(Macros,DPos+1,255));
        DPos:=Pos(',',Macros);
        X1:=Round(StrToInt(Copy(Macros,1,DPos-1))*PixPerMM/Scale);
        Macros:=Trim(Copy(Macros,DPos+1,255));
        DPos:=Pos(',',Macros);
        Y1:=Round(StrToInt(Copy(Macros,1,DPos-1))*PixPerMM/Scale);
        Macros:=Trim(Copy(Macros,DPos+1,255));
        DPos:=Pos(',',Macros);
        X2:=Round(StrToInt(Copy(Macros,1,DPos-1))*PixPerMM/Scale);
        Macros:=Trim(Copy(Macros,DPos+1,255));
        Y2:=Round(StrToInt(Macros)*PixPerMM/Scale);
        Canvas.MoveTo(X1,Y1);
        Canvas.LineTo(X2,Y2);
        goto EndPro;
      end;
      //неизвестный макрос - сравниваем с параметрами в Params
      St:=Params.Values[Macros];
      EndPro: ReadMacros;
    end;
  end;

  procedure multilineCanvasText(canvas: TCanvas; text: String; left, top: Integer);
  var
    textSize: TSize;
    lines: TStringList;
    i: Integer;
  begin
    lines := TStringList.Create;
    lines.Text := text;

    for i := 0 to lines.Count - 1 do
    begin
      textSize := canvas.TextExtent(lines[i]);
      canvas.TextOut(left, (top + (textSize.cy * i)), lines[i]);
    end;
  end;
  
begin
  AssignFile(F,FileName);
  Reset(F);
  NumSt:=0;
  Left:=0; Top:=0;
  SetDefaultFont;
  SetDefaultPen;
  while not Eof(F) do begin
    //читаем строку
    Readln(F,St);
    NumSt:=NumSt+1;
    //вычленяем и интерпретируем макрос
    ReadMacros;
    //печатаем строку (переделать для печати многстрочного текста)
    if St<>'' then
    begin
      if Pos(#13#10, St) = 0 then
        Canvas.TextOut(Left,Top,St)
      else
        multilineCanvasText(Canvas, St, Left, Top);
    end;
  end;
  CloseFile(F);
end;

function ExtractMacros(var SourceSt: string): string;
var
  Eom: Integer;
begin
  SourceSt:=Trim(SourceSt);
  Result:='';
  if Pos('*',SourceSt)=1 then
    SourceSt:=''
  else
    if Pos('{',SourceSt)=1 then begin
      //выделяем из сторки макрос
      Eom:=Pos('}',SourceSt);
      if Eom=0 then Eom:=255;
      Result:=AnsiUpperCase(Trim(Copy(SourceSt,2,Eom-2)));
      SourceSt:=Trim(Copy(SourceSt,Eom+1,255));
    end;
end;

{procedure DrawRegion(var Points: TGeoPoints; Contours: TGeoContours;
  Canvas: TCanvas; var Rect: TRect; PixPerMM: Double; Scale: Double=0;
  Divisor: Integer=1; Corner: Double=0);}
//Scale=Pix/M
{Points: динамический массив точек
Contours: динамический массив контуров
Canvas: холст, на котором надо рисовать
Rect: область, в которой будем рисовать;
  если Scale=0 то рисунок будет подгоняться под нее
PixPerMM: число пикселей на мм для устройства вывода
Scale: коэффициент, показвающий, на сколько уменьшить изображение по
  сравнению со 100%; применяется, например, для того, чтобы уместить лист на экране
Divisor: масштаб карты
Corner: угол повората в радианах}
{var
  I, Contour, StartPoint: Integer;
  LeftX,RightX,TopY,BottomY: Integer;
  MinX,MaxX,MinY,MaxY,LenX,LenY: Double;
  PixPerM: Extended;
  //CanvasPoints: array of TPoint;
  PenColor, BrushColor, Color: TColor;
  FirstFounded: Boolean;

  function CalcPoint(P: TAllotmentPoint): TPoint;
  begin
    Result.X:=Round(PixPerM*(P.Y-MinY));
    Result.Y:=Round(PixPerM*(LenX-P.X+MinX));
  end;

  procedure DrawPoint(I: Integer);
  const
    Radius=0.3; //радиус точки в мм
    Step=1; //отступ названия точки от точки в мм
  var
    R: Integer;
    //LogFont: TLogFont;
    //Hfnt, OldHfnt: HFont;
  begin
    R:=Round(Radius*PixPerMM);
    //S:=Round(Step*PixPerMM/Scale);
    //LogFont.lfEscapement:=450;
    //Hfnt:=CreateFontIndirect(LogFont);
    //OldHfnt:=SelectObject(Canvas.Handle,Hfnt);
    //Canvas.TextOut(X,Y,'8');
    //SelectObject(Canvas.Handle,OldHfnt);
    //DeleteObject(Hfnt);
    with Canvas,Points[I] do begin
      //Brush.Color:=clBlack;
      LineTo(Point.X,Point.Y);
      //Brush.Style:=bsSolid;
      Ellipse(Point.X-R,Point.Y-R,Point.X+R+1,Point.Y+R+1);
      //Brush.Style:=bsClear;
      //TextOut(P.X+S,P.Y,GetPointName(Name,NT));
      MoveTo(Point.X,Point.Y);
    end;
  end;
begin
  if Length(Points)<3 then Exit;
  //находим минимум и максимум координат
  MinX:=MaxInt; MaxX:=MinInt; MinY:=MaxInt; MaxY:=MinInt;
  for I:=0 to High(Points) do
    if Contours[Points[I].Contour].Visible then begin
      if Points[I].X<MinX then MinX:=Points[I].X;
      if Points[I].X>MaxX then MaxX:=Points[I].X;
      if Points[I].Y<MinY then MinY:=Points[I].Y;
      if Points[I].Y>MaxY then MaxY:=Points[I].Y;
    end;
  LenX:=MaxX-MinX; LenY:=MaxY-MinY;
  if (LenX=0)or(LenY=0) then Exit;
  //SetLength(CanvasPoints,Length(Points));
  //если надо, находим масштаб
  if Scale=0 then begin
    PixPerM:=Min((Rect.Right-Rect.Left-1)/LenY,(Rect.Bottom-Rect.Top-1)/LenX);
    Scale:=1.5;
  end
  else
    PixPerM:=1000*PixPerMM*Scale/Divisor;
  //Рисуем участок
  with Canvas do begin
    Font.Name:='Times New Roman';
    Font.Size:=Round(8/Scale);
    //находим приблизительные размеры изображения (без учета поворота)
    Rect.Right:=Rect.Left+Round(PixPerM*LenY);
    Rect.Bottom:=Rect.Top+Round(PixPerM*LenX);
    LeftX:=0; TopY:=0; RightX:=0; BottomY:=0;
    //поворачиваем точки
    for I:=0 to High(Points) do begin
      if not Contours[Points[I].Contour].Visible then Continue;
      Points[I].Point:=CalcPoint(Points[I]);
      Points[I].Point:=RotatePoint(Point((Rect.Right-Rect.Left) div 2,
        (Rect.Bottom-Rect.Top) div 2),Points[I].Point,Corner);
      if I=0 then begin
        LeftX:=Points[I].Point.X; RightX:=Points[I].Point.X;
        TopY:=Points[I].Point.Y; BottomY:=Points[I].Point.Y;
      end
      else begin
        LeftX:=Min(LeftX,Points[I].Point.X); RightX:=Max(RightX,Points[I].Point.X);
        TopY:=Min(TopY,Points[I].Point.Y); BottomY:=Max(BottomY,Points[I].Point.Y);
      end;
    end;
    //рисуем точки
    StartPoint:=0;
    Contour:=0;
    PenColor:=Canvas.Pen.Color;
    BrushColor:=Canvas.Brush.Color;
    for I:=0 to High(Points) do begin
      if not ContoursEnabled[Points[I].Contour] then Continue;
      Points[I].Point.X:=Rect.Left+Points[I].Point.X-LeftX;
      Points[I].Point.Y:=Rect.Top+Points[I].Point.Y-TopY;
      if Points[I].Contour<>Contour then begin
        if Contour>0 then
          DrawPoint(StartPoint);
        StartPoint:=I;
        Contour:=Points[StartPoint].Contour;
        case Contour of
          1: Color:=clBlack;
          2: Color:=clMaroon;
          3: Color:=clGreen;
          4: Color:=clOlive;
          5: Color:=clNavy;
          6: Color:=clPurple;
          7: Color:=clTeal;
          8: Color:=clGray;
          9: Color:=clSilver;
          10: Color:=clRed;
          11: Color:=clLime;
          12: Color:=clYellow;
          13: Color:=clBlue;
          14: Color:=clFuchsia;
        else
          Color:=clAqua;
        end;
        Canvas.Pen.Color:=Color;
        Canvas.Brush.Color:=Color;
        MoveTo(Points[I].Point.X,Points[I].Point.Y);
        Continue;
      end;
      DrawPoint(I);
    end;
    DrawPoint(StartPoint);
    Canvas.Pen.Color:=PenColor;
    Canvas.Brush.Color:=BrushColor;
    Rect.Right:=Rect.Left+RightX-LeftX;
    Rect.Bottom:=Rect.Top+BottomY-TopY;
  end;
end;}
procedure PrintRegion1(var Params: TPrintRegion1Params);
{  var Points: TAllotmentPoints;
  ContoursEnabled: TBooleans;
  Canvas: TCanvas;
  var Rect: TRect;
  PixPerMMH: Double;
  PixPerMMV: Double;
  LatinNames: Boolean;
  LineWidth: Integer;
  Scale: Double = 0;
  Divisor: Integer = 1;
  Corner: Double = 0;
  Connect: Boolean = True;
  CrossSize: Integer = 0;
  LabelPoints: Boolean = False;
  LineLabels: Boolean = False;
  LabelsFont: TFont = nil);  }
//Scale=Pix/M
{Points: динамический массив точек
Contours: динамический массив контуров
Canvas: холст, на котором надо рисовать
Rect: область, в которой будем рисовать;
  если Scale=0 то рисунок будет подгоняться под нее
PixPerMM: число пикселей на мм для устройства вывода
Scale: коэффициент, показвающий, на сколько уменьшить изображение по
  сравнению со 100%; применяется, например, для того, чтобы уместить лист на экране
Divisor: масштаб карты
Corner: угол повората в радианах}
var
  I, J, Ic, i1: Integer;
  LeftX,RightX,TopY,BottomY: Integer;
  LenX, LenY: Double;
  PixPerMH: Extended;
  PixPerMV: Extended;
  //CanvasPoints: array of TPoint;
  PenColor, BrushColor, Color: TColor;
  CrossPoint: TAllotmentPoint;
  CrossPoints: TAllotmentPoints;
var
  E: TKisExtent;
  Cnt: TContour;
  B: Boolean;

  function CalcPoint(const X, Y: Double): TPoint;
  begin
    Result.X := Round(PixPerMV * (Y - E.FYmin));
    Result.Y := Round(PixPerMH * (LenX - X + E.FXmin));
  end;

  procedure DrawPoint(const P: TKisPoint);
  const
    Radius = 0.3; //радиус точки в мм
    Step = 1; //отступ названия точки от точки в мм
  var
    R: Integer;
    oldFont: TFont;
  begin
    R := Round(Radius * Params.PixPerMMH);
    oldFont := nil;
    with Params.Canvas do
    begin
      if Params.Connect then
      begin
        Pen.Width := Params.LineWidth;
        LineTo(P.ScreenPt.X, P.ScreenPt.Y);
      end
      else
        MoveTo(P.ScreenPt.X, P.ScreenPt.Y);
      Ellipse(P.ScreenPt.X - R, P.ScreenPt.Y - R, P.ScreenPt.X + R + 1, P.ScreenPt.Y + R + 1);
      if Params.LabelPoints then
      begin
        if Assigned(Params.LabelsFont) then
        begin
          oldFont := IObject(TFont.Create).AObject as TFont;
          oldFont.Assign(Font);
          Font.Assign(Params.LabelsFont);
        end;
        Brush.Style := bsClear;
        TextOut(P.ScreenPt.X + Step, P.ScreenPt.Y, GetPointName(P.Name, Params.LatinNames));
        if Assigned(oldFont) then
          Font.Assign(oldFont);
      end;
      MoveTo(P.ScreenPt.X, P.ScreenPt.Y);
    end;
  end;

  function GetCrosses(const Center: TAllotmentPoint): TAllotmentPoints;
  begin
    SetLength(Result, 4);
    Result[0].X := Int(Center.X / Params.Divisor * 10) * Params.Divisor / 10;
    Result[0].Y := Int(Center.Y / Params.Divisor * 10) * Params.Divisor / 10;

    Result[1].X := Result[0].X + IfThen(Center.X >= 0, 1, -1) * Params.Divisor / 10;
    Result[1].Y := Result[0].Y + IfThen(Center.Y >= 0, 1, -1) * Params.Divisor / 10;

    Result[2].X := Result[0].X + IfThen(Center.X >= 0, 1, -1) * Params.Divisor / 10;
    Result[2].Y := Result[0].Y;

    Result[3].X := Result[0].X;
    Result[3].Y := Result[0].Y + IfThen(Center.Y >= 0, 1, -1) * Params.Divisor / 10;
  end;

  procedure DrawLengths;        //  собственно рисовалка текста линий и мер
  var
    i1, k1, k2: Integer;
    x, y: Integer;
    oldFont: TFont;
    ContoursEnabledLength: Integer;
    Cnt: TContour;
    Pt1, Pt2: TKisPoint;
  begin
    ContoursEnabledLength := Params.Points.Count;
    if Assigned(Params.LabelsFont) then
    begin
      oldFont := IObject(TFont.Create).AObject as TFont;
      oldFont.Assign(Params.Canvas.Font);
      Params.Canvas.Font.Assign(Params.LabelsFont);
    end
    else
      oldFont := nil;
    Params.Canvas.Brush.Style := bsClear;
    if Assigned(oldFont) then
      Params.Canvas.Font.Assign(oldFont);
    //перебираем все контура отвода
    for i1 := 0 to Pred(ContoursEnabledLength) do
    // если контур видим - рисуем меры линий
    if Params.Points[i1].Enabled then
    begin
    /// вопрос - за каким х.. еще раз запускать цикл перебора кунтуров?
    /// да еще и не использовать переменную цикла в контуре??
      //for j1 := 0 to Params.Points.Count - 1 do
      //begin
        Cnt := Params.Points[i1];
        k1 := Cnt.Count - 1;
          for k2 := 0 to Cnt.Count - 1 do
          begin
            Pt1 := Cnt[k1];
            Pt2 := Cnt[k2];
            x := abs(Pt2.ScreenPt.X - Pt1.ScreenPt.X) div 2;
            y := abs(Pt2.ScreenPt.y - Pt1.ScreenPt.y) div 2;
              if Pt2.ScreenPt.X > Pt1.ScreenPt.X then
                x := x + Pt1.ScreenPt.X
              else
                x := x + Pt2.ScreenPt.X;
              if Pt2.ScreenPt.y > Pt1.ScreenPt.y then
                y := y + Pt1.ScreenPt.y
              else
            y := y + Pt2.ScreenPt.y;
            Params.Canvas.TextOut(x, y, Format('%2f', [Cnt.GetLength(k1, Params.Cs)]));
            k1 := k2;
          end;
      //end;
    end;

    if Assigned(oldFont) then
      Params.Canvas.Font.Assign(oldFont);
  end;

var
  TmpP: TAllotmentPoint;
begin
  SetLength(CrossPoints, 0);      //начало DRAW
  //находим минимум и максимум координат
  E := nil;
  for I := 0 to Pred(Params.Points.Count) do
    if Params.Points[I].Enabled then
    begin
      if not Assigned(E) then
        E := Params.Points[I].GetExtent
      else
        E.Join(Params.Points[I].GetExtent);
    end;

  if not Assigned(E) then
    Exit;
    
  LenX := E.FXmax - E.FXmin;
  LenY := E.FYmax - E.FYmin;

  // Находим узлы сетки
  if Params.CrossSize > 0 then
  begin
    CrossPoint.X := E.FXmin + (E.FXmax - E.FXmin) / 2;
    CrossPoint.Y := E.FYmin + (E.FYmax - E.FYmin) / 2;
    CrossPoints := GetCrosses(CrossPoint);
    for I := 0 to 3 do
    begin
      E.FXmin := Min(E.FXmin, CrossPoints[I].X);
      E.FYmin := Min(E.FYmin, CrossPoints[I].Y);
      E.FXmax := Max(E.FXmax, CrossPoints[I].X);
      E.FYmax := Max(E.FYmax, CrossPoints[I].Y);
    end;
    LenX := E.FXmax - E.FXmin;
    LenY := E.FYmax - E.FYmin;
  end;

  if (LenX = 0) or (LenY = 0) then
    Exit;

  //если надо, находим масштаб
  if Params.Scale = 0 then
  begin
    PixPerMH := (Params.Rect.Right - Params.Rect.Left - 1) / LenY;
    PixPerMV := (Params.Rect.Bottom - Params.Rect.Top - 1) / LenX;
    Params.Scale := 1.5;
  end
  else
  begin
    PixPerMH := 1000 * Params.PixPerMMH * Params.Scale / Params.Divisor;
    PixPerMV := 1000 * Params.PixPerMMV * Params.Scale / Params.Divisor;
  end;

  //Рисуем участок
  with Params.Canvas do
  begin
    Font.Name := 'Times New Roman';
    Font.Size := Round(8 / Params.Scale);
    //находим приблизительные размеры изображения (без учета поворота)
    Params.Rect.Right := Params.Rect.Left + Round(PixPerMH * LenY);
    Params.Rect.Bottom := Params.Rect.Top + Round(PixPerMV * LenX);
    LeftX := 0;
    TopY := 0;
    RightX := 0;
    BottomY := 0;
    B := False;
    //поворачиваем точки
    for I := 0 to Pred(Params.Points.Count) do
    begin
      Cnt := Params.Points[I];
      if not Cnt.Enabled then
        Continue;
      for J := 0 to Cnt.Count - 1 do
      begin
        Cnt[J].ScreenPt := CalcPoint(Cnt[J].X, Cnt[J].Y);
        Cnt[J].ScreenPt := RotatePoint(Point((Params.Rect.Right - Params.Rect.Left) div 2,
          (Params.Rect.Bottom - Params.Rect.Top) div 2), Cnt[J].ScreenPt, Params.Corner);
        if not B then
        begin
          LeftX := Cnt[J].ScreenPt.X;
          RightX := Cnt[J].ScreenPt.X;
          TopY := Cnt[J].ScreenPt.Y;
          BottomY := Cnt[J].ScreenPt.Y;
          B := True;
        end
        else
        begin
          LeftX := Min(LeftX, Cnt[J].ScreenPt.X);
          RightX := Max(RightX, Cnt[J].ScreenPt.X);
          TopY := Min(TopY, Cnt[J].ScreenPt.Y);
          BottomY := Max(BottomY, Cnt[J].ScreenPt.Y);
        end;
      end;
    end;

    // пересчитываем узлы сетки
    if Params.CrossSize > 0 then
    begin
      for Ic := 0 to 3 do
      begin
        CrossPoints[Ic].Point := CalcPoint(CrossPoints[Ic].X, CrossPoints[Ic].Y);
        CrossPoints[Ic].Point := RotatePoint(Point((Params.Rect.Right - Params.Rect.Left) div 2,
            (Params.Rect.Bottom - Params.Rect.Top) div 2), CrossPoints[Ic].Point, Params.Corner);
        for i1 := -1 to 1 do
        begin
          LeftX := Min(LeftX, CrossPoints[Ic].Point.X + i1 * 25);
          RightX := Max(RightX, CrossPoints[Ic].Point.X + i1 * 25);
          TopY := Min(TopY, CrossPoints[Ic].Point.Y + i1 * 25);
          BottomY := Max(BottomY, CrossPoints[Ic].Point.Y + i1 * 25);
        end;
      end;
    end;

    // рисуем кресты
    if Params.CrossSize > 0 then
    begin
      for Ic := 0 to 3 do
      begin
        CrossPoints[Ic].Point.X := Params.Rect.Left + CrossPoints[Ic].Point.X - LeftX;
        CrossPoints[Ic].Point.Y := Params.Rect.Top + CrossPoints[Ic].Point.Y - TopY;
        Params.Canvas.MoveTo(CrossPoints[Ic].Point.X - Params.CrossSize, CrossPoints[Ic].Point.Y);
        Params.Canvas.LineTo(CrossPoints[Ic].Point.X + Params.CrossSize, CrossPoints[Ic].Point.Y);
        Params.Canvas.MoveTo(CrossPoints[Ic].Point.X, CrossPoints[Ic].Point.Y - Params.CrossSize);
        Params.Canvas.LineTo(CrossPoints[Ic].Point.X, CrossPoints[Ic].Point.Y + Params.CrossSize);
      end;
    end;
    //рисуем точки
    PenColor := Params.Canvas.Pen.Color;
    BrushColor := Params.Canvas.Brush.Color;
    for I := 0 to Pred(Params.Points.Count) do
    begin
      Cnt := Params.Points[I];
      if not Cnt.Enabled then
        Continue;
      for J := 0 to Cnt.Count - 1 do
      begin
        Cnt[J].ScreenPt := Point(
          Params.Rect.Left + Cnt[J].ScreenPt.X - LeftX,
          Params.Rect.Top + Cnt[J].ScreenPt.Y - TopY);
        if J = 0 then
        begin
          //DrawPoint(Cnt[0]);
          case Cnt.Id of
            1: Color := clBlack;
            2: Color := clMaroon;
            3: Color := clGreen;
            4: Color := clOlive;
            5: Color := clNavy;
            6: Color := clPurple;
            7: Color := clTeal;
            8: Color := clGray;
            9: Color := clSilver;
            10: Color := clRed;
            11: Color := clLime;
            12: Color := clYellow;
            13: Color := clBlue;
            14: Color := clFuchsia;
          else
            Color := clAqua;
          end;
          Params.Canvas.Pen.Color := Color;
          Params.Canvas.Brush.Color := Color;
          MoveTo(Cnt[J].ScreenPt.X, Cnt[J].ScreenPt.Y);
          //Continue;
        end;
        DrawPoint(Cnt[J]);
      end;
      if Cnt.Count > 2 then
        DrawPoint(Cnt[0]);
    end;

    if Params.LineLabels then
      DrawLengths;   // отрисовка мер  линий
      Params.Canvas.Pen.Color := PenColor;
      Params.Canvas.Brush.Color := BrushColor;
      Params.Rect.Right := Params.Rect.Left + RightX - LeftX;
      Params.Rect.Bottom := Params.Rect.Top + BottomY - TopY;
    end;
end;

end.
