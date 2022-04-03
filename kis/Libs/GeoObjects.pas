unit GeoObjects;

interface

uses Classes, Windows, Graphics, AGraph6, APrinter6, Math, AProc6;

type
  {точка имеет географичекие координаты, ссылку на контур, надпись и
  может дополнительно хранить одно целое число}
  TGeoPoint=record
    Contour: Byte;
    X, Y: Integer; //координаты в сантиметрах
    Caption1: string;
    //Caption2: string;
    Tag: Integer;
  end;
  TGeoPoints=array of TGeoPoint;

  {контур имеет цвет, размер точки, может быть соединен линиями или нет,
  может быть виден или нет и может дополнительно хранить одно целое число}
  TGeoContour=record
    //Caption: string;
    Color: TColor;
    Connected: Boolean;
    PointSize: Double;  //диаметр точки в миллиметрах
    //Font: TFont;
    Visible: Boolean;
    Tag: Integer;
  end;
  TGeoContours=array of TGeoContour;

  TOutputDevice=(odScreen, odPrinter);

  TSDirection = 0..7;

  {
  Объект отвечает за прорисовку совокупности точек, объединенных в контуры на заданном холсте

  Свойства и поля:
    GeoPoints: географические точки
    GeoContours: контуры
    Points: экранные координаты, соответствующие географическим
    Scale: масштаб, например, Scale=500 соответствует М1:500
    Factor: множитель, на который умножается размер рисунка;
      нужен для масштабирования листа при просмотре
    Corner: угол поворота рисунка
    Rect: ограничительный прямоугольник; если Stretch=True, то рисунок будет
      помещен в заданный прямоугольник, иначе - прямоугольник примет размеры рисунка
    Stretch: определяет, будет ли рисунок подогнан пропорционально под Rect
    Device: устройство вывода; исходя из этого определяется разрешение изображения
    Canvas: холст, на который будет нанесен рисунок

    Методы:
      Draw: рисует изображение на заданном холсте
      SetParams: устанавливает значения Scale, Factor, Corner, Rect, Stretch и
        вызывает метод Draw;
  }
  TGeoStructure = class
  private
    FScale: Integer;
    FFactor: Double;
    FCorner: Double;
    FRect: TRect;
    FStretch: Boolean;
    FDevice: TOutputDevice;
    FCanvas: TCanvas;

    PixPerMMH, PixPerMMV: Double;

    procedure SetScale(Value: Integer);
    procedure SetFactor(Value: Double);
    procedure SetCorner(Value: Double);
    procedure SetRect(Value: TRect);
    procedure SetStretch(Value: Boolean);
    procedure SetDevice(Value: TOutputDevice);
  public
    GeoPoints: TGeoPoints;
    GeoContours: TGeoContours;
    Points: array of TPoint;
    property Scale: Integer read FScale write SetScale default 1;
    property Factor: Double read FFactor write SetFactor;
    property Corner: Double read FCorner write SetCorner;
    property Rect: TRect read FRect write SetRect;
    property Stretch: Boolean read FStretch write SetStretch default False;
    property Device: TOutputDevice read FDevice write SetDevice  default odScreen;
    property Canvas: TCanvas read FCanvas write FCanvas;

    constructor Create;
    procedure SetParams(Scale: Integer; Factor, Corner: Double;
      Rect: TRect; Stretch: Boolean; SmartCaptions: Integer = 0);
    procedure Draw(const NetStep: Integer = 5000; const SmartCaptions: Integer = 0);
  end;

implementation

//uses SDraw;

{$R ADD.RES}

{TGeoStructure}

constructor TGeoStructure.Create;
begin
  inherited Create;
  FScale:=1;
  FFactor:=1;
  FCorner:=0;
  FStretch:=False;
  Device:=odScreen;
end;

procedure TGeoStructure.SetScale(Value: Integer);
begin
  if FScale<>Value then begin
    FScale:=Value;
    Draw;
  end;
end;

procedure TGeoStructure.SetFactor(Value: Double);
begin
  if FFactor<>Value then begin
    FFactor:=Value;
    Draw;
  end;
end;

procedure TGeoStructure.SetCorner(Value: Double);
begin
  if FCorner<>Value then begin
    FCorner:=Value;
    Draw;
  end;
end;

procedure TGeoStructure.SetRect(Value: TRect);
begin
  FRect:=Value;
  Draw;
end;

procedure TGeoStructure.SetStretch(Value: Boolean);
begin
  if FStretch<>Value then begin
    FStretch:=Value;
    Draw;
  end;
end;

procedure TGeoStructure.SetDevice(Value: TOutputDevice);
begin
  FDevice:=Value;
  case FDevice of
    odScreen:   begin
                  PixPerMMH := AGraph6.ScrPixPerMM;
                  PixPerMMV := AGraph6.ScrPixPerMM;
                end;
    odPrinter:  begin
                  GetPrinterUnits;
                  PixPerMMH:=PrnPixPerMMH;
                  PixPerMMV:=PrnPixPerMMV;
                end;
  end;
end;

procedure TGeoStructure.SetParams(Scale: Integer; Factor, Corner: Double;
  Rect: TRect; Stretch: Boolean; SmartCaptions: Integer = 0);
begin
  FScale:=Scale;
  FFactor:=Factor;
  FCorner:=Corner;
  FRect:=Rect;
  FStretch:=Stretch;
  Draw(10 * Scale, SmartCaptions);
end;

procedure TGeoStructure.Draw(const NetStep: Integer = 5000; const SmartCaptions: Integer = 0);
const
  prim_drtn = 0;
var
  I, X, X0, Y, Contour, StartPoint, Caption1Indent, CrossSize: Integer;
  LeftX,RightX,TopY,BottomY: Integer;
  MinX,MaxX,MinY,MaxY,LenX,LenY: Integer;
  PixPerSMH, PixPerSMV: Extended;
  NewPoint: TPoint;
  OldRect: TRect;
//  bad_zone: array [0..7] of Boolean;
//  IsClear: Boolean;
//  cur_drtn: TSDirection;
  SecondBMP: TBitmap;

  procedure DrawPoint(I: Integer);
  var
    R: Integer;
    SZ: Integer;
  begin
    R:=Round(GeoContours[GeoPoints[I].Contour].PointSize/2*PixPerMMH);
    with Canvas,Points[I] do begin
      if GeoContours[GeoPoints[I].Contour].Connected then
        LineTo(X,Y)
      else
        MoveTo(X,Y);
      Pen.Color:=GeoContours[GeoPoints[I].Contour].Color;
      Brush.Color:=GeoContours[GeoPoints[I].Contour].Color;
      Brush.Style:=bsSolid;
      Ellipse(X-R,Y-R,X+R+1,Y+R+1);
      Brush.Style:=bsClear;
      sz := Font.Size;
      Font.Size := 7;
      case SmartCaptions of
      0 : TextOut(X+Caption1Indent,Y,GeoPoints[I].Caption1);
      end;
      Font.Size := sz;
      MoveTo(X,Y);
    end;
  end;

  function GetCaptionWidth: Integer;
  var
    I: Integer;
  begin
    Result:=0;
    for I:=Low(GeoPoints) to High(GeoPoints) do
      if GeoContours[GeoPoints[I].Contour].Visible then
        Result:=Max(Result,Canvas.TextWidth(GeoPoints[I].Caption1));
  end;

  function GetCaptionHeight: Integer;
  var
    I: Integer;
    CaptionsEmpty: Boolean;
  begin
    CaptionsEmpty:=True;
    for I:=Low(GeoPoints) to High(GeoPoints) do
      if GeoContours[GeoPoints[I].Contour].Visible and
        (GeoPoints[I].Caption1<>'') then begin
        CaptionsEmpty:=False;
        Break;
      end;
    if CaptionsEmpty then Result:=0 else Result:=Abs(Canvas.Font.Height);
  end;

  function CalcPoint(X, Y: Integer): TPoint;
  begin
    Result.X:=Round(PixPerSMH*(Y-MinY));
    Result.Y:=Round(PixPerSMV*(MaxX-X));
  end;

  procedure SmartWriter(FontSize: Integer; PrimDrtn: TSDirection; Step: Integer);
  var
    TextBmp1: TBitmap;
    h, w, ii, jj, TopSm, BottomSm, LeftSm, RightSm, i1, rr, alpha,
    xx0, yy0, xx1, yy1: Integer;
    IsClear: Boolean;
    al_rad: Double;
  begin
      Canvas.Font.Size := FontSize;
      Canvas.Font.Name := 'Arial';//'Times New Roman';
      Canvas.Font.Charset := RUSSIAN_CHARSET;
      SecondBMP := TBitmap.Create;
      TextBmp1 := TBitmap.Create;
      try
        // Инициализация и заполнение белым вторичной канвы
        SecondBMP.SetSize(
          Max(OldRect.Right - OldRect.Left, Rect.Right - Rect.Left),
          Max(OldRect.Bottom - OldRect.Top, Rect.Bottom - Rect.Top));
        SecondBMP.Canvas.Brush.Color := clWhite;
        SecondBMP.Canvas.Pen.Color := clWhite;
        SecondBMP.Canvas.FillRect(Classes.Rect(-1, -1, SecondBMP.Width, SecondBMP.Height));
        // Рисуем точки
        SecondBMP.Canvas.Brush.Color := clBlack;
        SecondBMP.Canvas.Brush.Style:=bsSolid;
        SecondBMP.Canvas.Pen.Color := clBlack;
        for i1 := Low(GeoPoints) to High(GeoPoints) do
        begin
          if not GeoContours[GeoPoints[i1].Contour].Visible then Continue;
          rr := Round(GeoContours[GeoPoints[i1].Contour].PointSize / 2 * PixPerMMH);
          SecondBMP.Canvas.Ellipse(Points[i1].X - rr - Rect.Left,
                                   Points[i1].Y - rr - Rect.Top,
                                   Points[i1].X + rr - Rect.Left,
                                   Points[i1].Y + rr - Rect.Top);
        end;
        // Прорисовываем заголовки
        SecondBMP.Canvas.Brush.Style := bsClear;
        for i1 := Low(GeoPoints) to High(GeoPoints) do
        begin
          if not GeoContours[GeoPoints[i1].Contour].Visible then Continue;
          xx0 := Points[i1].X - Rect.Left;
          yy0 := Points[i1].Y - Rect.Top;
          // Обрезаем текст
          h := Canvas.TextHeight(GeoPoints[i1].Caption1);
          w := Canvas.TextWidth(GeoPoints[i1].Caption1);
          TextBmp1.SetSize(w, h);
          TextBmp1.Canvas.FillRect(Classes.Rect(-1, -1, h, w));
          TextBmp1.Canvas.TextOut(0, 0, GeoPoints[i1].Caption1);
          TopSm := 0;
          BottomSm := 0;
          LeftSm := 0;
          RightSm := 0;
          rr := 2;
          for ii := 0 to w - 1 do
          for jj := 0 to h - 1 do
          begin
            if TextBmp1.Canvas.Pixels[ii, jj] = clBlack then
            begin
              TopSm := Min(TopSm, JJ);
              BottomSm := Max(BottomSm, JJ);
              LeftSm := Min(LeftSm, II);
              RightSm := Max(RightSm, II);
            end;
          end;
          h := BottomSm - TopSm;
          w := RightSm - LeftSm;
          // Теперь вращаем надпись по кругу
          alpha := 0;
          while alpha < 360 do
          begin
            al_rad := alpha * pi / 180;
            if alpha = 0 then
            begin
              xx1 := xx0 - w div 2;
              yy1 := yy0 - rr - h;
            end
            else
            if alpha < 90 then
            begin
              xx1 := xx0 + Round(rr * sin(al_rad));
              yy1 := yy0 - Round(rr * cos(al_rad)) - h;
            end
            else
            if alpha = 90 then
            begin
              xx1 := xx0 + rr;
              yy1 := yy0 - h div 2;
            end
            else
            if alpha < 180 then
            begin
              xx1 := xx0 - Round(rr * sin(al_rad));
              yy1 := yy0 + Round(rr * cos(al_rad));
            end
            else
            if alpha = 180 then
            begin
              xx1 := xx0 - w div 2;
              yy1 := yy0 + rr;
            end
            else
            if alpha < 270 then
            begin
              xx1 := xx0 + Round(rr * sin(al_rad));
              yy1 := yy0 - Round(rr * cos(al_rad));
            end
            else
            if alpha = 270 then
            begin
              xx1 := xx0 - rr;
              yy1 := yy0 - rr div 2;
            end
            else
            begin
              xx1 := xx0 - Round(rr * sin(al_rad));
              yy1 := yy0 + Round(rr * cos(al_rad));
            end;
            // Сканируем
            IsClear := True;
            for ii := xx1 - 1 to xx1 + w + 1  do
            begin
              if not IsClear then BREAK;
              for jj := yy1 - 1 to yy1 + h + 1 do
                if SecondBMP.Canvas.Pixels[ii, jj] <> clWhite then
                begin
                  IsClear := False;
                  BREAK;
                end;
            end;
            if IsClear then
            begin
              Canvas.Font.Color := GeoContours[GeoPoints[i1].Contour].Color;
              Canvas.TextOut(xx1 - LeftSm + Rect.Left, yy1 - TopSm + Rect.Top,
                             GeoPoints[i1].Caption1);
              SecondBMP.Canvas.TextOut(xx1, yy1, GeoPoints[i1].Caption1);
              BREAK;
            end;
            alpha := alpha + Step;
          end;
        end;

      finally
        SecondBMP.Free;
        TextBmp1.Free;
      end;
{
      try
        SecondBMP.Height := Max(OldRect.Bottom - OldRect.Top, Rect.Bottom - Rect.Top);
        SecondBMP.Width := Max(OldRect.Right - OldRect.Left, Rect.Right - Rect.Left);
        SecondBMP.Canvas.Brush.Color := clWhite;
        SecondBMP.Canvas.Pen.Color := clWhite;
        SecondBMP.Canvas.FillRect(Classes.Rect(-1, -1, SecondBMP.Width, SecondBMP.Height));
        SecondBMP.Canvas.Brush.Color := clBlack;
        SecondBMP.Canvas.Brush.Style:=bsSolid;
        SecondBMP.Canvas.Pen.Color := clBlack;
        for I:=Low(GeoPoints) to High(GeoPoints) do
        begin
          if not GeoContours[GeoPoints[I].Contour].Visible then Continue;
          rr := Round(GeoContours[GeoPoints[I].Contour].PointSize / 2 * PixPerMMH);
          SecondBMP.Canvas.Ellipse(Points[i].X - rr - Rect.Left, Points[i].Y - rr - Rect.Top,
                                   Points[i].X + rr - Rect.Left, Points[i].Y + rr - Rect.Top);
        end;
        SecondBMP.Canvas.Brush.Style := bsClear;
        for I:=Low(GeoPoints) to High(GeoPoints) do
        begin
          if not GeoContours[GeoPoints[I].Contour].Visible then Continue;
          cur_drtn := prim_drtn;
          for ii := 0 to 7 do bad_zone[ii] := False;
          repeat
            xx0 := Points[I].X + DeltaX(cur_drtn) * (Caption1Indent +
                  Round(GeoContours[GeoPoints[I].Contour].PointSize/2*PixPerMMH)) -
                  Rect.Left;
            yy0 := Points[I].Y + DeltaY(cur_drtn) * (Caption1Indent +
                  Round(GeoContours[GeoPoints[I].Contour].PointSize/2*PixPerMMH)) -
                  Rect.Top;
            h := SecondBMP.Canvas.TextHeight(GeoPoints[I].Caption1) - 3;
            w := SecondBMP.Canvas.TextWidth(GeoPoints[I].Caption1) - 1;
            case cur_drtn of
            5, 6: xx0 := xx0 - w;
            0, 1: yy0 := yy0 - h;
            7   : begin
                   xx0 := xx0 - w;
                   yy0 := yy0 - h;
                  end;
            end;
            xx1 := xx0 + w;
            yy1 := yy0 + h;
            IsClear := True;
            for jj := xx0 to xx1 - 1 do
            begin
              if not IsClear then BREAK;
              for kk := yy0 to yy1 - 1 do
              begin
                if (SecondBMP.Canvas.Pixels[jj, kk] <> clWhite) then
//                if (SecondBMP.Canvas.Pixels[jj, kk] <> (-1)) then
                begin
                  IsClear := False;
                  BREAK;
                end;
              end;
            end;
            if IsClear then
            begin
              cur_drtn := prim_drtn;
              Canvas.Font.Color := GeoContours[GeoPoints[I].Contour].Color;
              TextOut(xx0 + Rect.Left, yy0 + Rect.Top, GeoPoints[I].Caption1);
              SecondBMP.Canvas.Font.Color := GeoContours[GeoPoints[I].Contour].Color;
              SecondBMP.Canvas.TextOut(xx0, yy0, GeoPoints[I].Caption1);
//              Rectangle(Classes.Rect(xx0 + Rect.Left - 1, yy0 + Rect.Top - 1,
//                             xx0 + Rect.Left + W, yy0 + Rect.Top + H));
            end
            else
            begin
              bad_zone[cur_drtn] := True;
              if bad_zone[OpposedDirection(cur_drtn)] then
                for jj := 0 to 7 do
                begin
                  cur_drtn := NextDirection(cur_drtn);
                  if not bad_zone[cur_drtn] then BREAK;
                end
              else
                cur_drtn := OpposedDirection(cur_drtn);
              if bad_zone[0] and bad_zone[1] and bad_zone[2] and bad_zone[3]
                 and bad_zone[4] and bad_zone[5] and bad_zone[6] and bad_zone[7] then
              begin
                cur_drtn := prim_drtn;
              end
              else
              begin
                repeat
                  cur_drtn := NextDirection(cur_drtn);
                until not bad_zone[cur_drtn];
              end;
            end;
          until cur_drtn = prim_drtn;
        end;
      finally
        SecondBMP.Free;
//        SecondBMP := nil;
      end;     }
  end;

begin
  if Length(GeoPoints)=0 then Exit;
  OldRect:=Rect;
  Caption1Indent:=Round(1*PixPerMMH*Factor); //отступ Caption1 от точки в пикселах
  SetLength(Points, Length(GeoPoints));
  //находим минимум и максимум координат
  MinX:=High(Integer);
  MaxX:=Low(Integer);
  MinY:=High(Integer);
  MaxY:=Low(Integer);
  for I:=Low(GeoPoints) to High(GeoPoints) do
    if GeoContours[GeoPoints[I].Contour].Visible then
    begin
      MinX:=Min(MinX,GeoPoints[I].X);
      MaxX:=Max(MaxX,GeoPoints[I].X);
      MinY:=Min(MinY,GeoPoints[I].Y);
      MaxY:=Max(MaxY,GeoPoints[I].Y);
    end;
  LenX:=MaxX-MinX;
  LenY:=MaxY-MinY;
  if Stretch then begin
    if LenX=0 then
      if LenY=0 then
        Exit
      else
        PixPerSmH:=(Rect.Right-Rect.Left-1-GetCaptionWidth-Caption1Indent)/LenY
    else
      if LenY=0 then
        PixPerSmH:=(Rect.Bottom-Rect.Top-1-GetCaptionHeight)/LenX
      else
        PixPerSmH:=Min((Rect.Right-Rect.Left-1-GetCaptionWidth-Caption1Indent)/LenY,
          (Rect.Bottom-Rect.Top-1-GetCaptionHeight)/LenX);
    //Scale:=1.5;
    PixPerSmV:=PixPerSmH;
  end
  else begin
    PixPerSMH:=10*PixPerMMH*Factor/Scale;
    PixPerSMV:=10*PixPerMMV*Factor/Scale;
  end;
  //Рисуем участок
  with Canvas do begin
    Font.Size:=Round(8*Factor);
    //находим приблизительные размеры изображения (без учета поворота)
    //для того, чтобы повернуть вокруг центра
    if not Stretch then FRect:=Classes.Rect(Rect.Left,Rect.Top,
      Rect.Left+Round(PixPerSMH*LenY),Rect.Top+Round(PixPerSMV*LenX));
    //поворачиваем точки
    LeftX:=MaxInt; RightX:=0; TopY:=MaxInt; BottomY:=0;
    for I:=Low(GeoPoints) to High(GeoPoints) do begin
      if GeoContours[GeoPoints[I].Contour].Visible then begin
        Points[I]:=CalcPoint(GeoPoints[I].X,GeoPoints[I].Y);
        Points[I]:=RotatePoint(Point((Rect.Right-Rect.Left) div 2,
          (Rect.Bottom-Rect.Top) div 2),Points[I],Corner);
        LeftX:=Min(LeftX,Points[I].X); RightX:=Max(RightX,Points[I].X);
        TopY:=Min(TopY,Points[I].Y); BottomY:=Max(BottomY,Points[I].Y);
      end;
    end;
    //устанавливаем окончательные размеры изображения
    if not Stretch then FRect:=Classes.Rect(Rect.Left,Rect.Top,
      Rect.Left+RightX-LeftX,Rect.Top+BottomY-TopY);
    //рисуем точки
    StartPoint:=-1;
    Contour:=-1;
    for I:=Low(GeoPoints) to High(GeoPoints) do begin
      if not GeoContours[GeoPoints[I].Contour].Visible then Continue;
      Points[I].X:=Rect.Left+Points[I].X-LeftX;
      Points[I].Y:=Rect.Top+Points[I].Y-TopY;
      if Contour<>GeoPoints[I].Contour then begin
        if StartPoint>=0 then DrawPoint(StartPoint);
        StartPoint:=I;
        Contour:=GeoPoints[I].Contour;
        MoveTo(Points[I].X,Points[I].Y);
        Continue;
      end;
      DrawPoint(I);
    end;
    DrawPoint(StartPoint);
    //рисуем узлы сетки
    CrossSize:=Round(PixPerMMH);
    //Canvas.Pen.Color:=clBlack;
    Canvas.Pen.Width:=1;
    X0:=GetNextMultiple(MaxX,NetStep,False); X:=X0;
    Y:=GetNextMultiple(MinY,NetStep);
    NewPoint:=CalcPoint(X,Y);
    while NewPoint.X<=OldRect.Right do begin
      while NewPoint.Y<=OldRect.Bottom do begin
        //рисуем узел
        Canvas.MoveTo(NewPoint.X-CrossSize,NewPoint.Y);
        Canvas.LineTo(NewPoint.X+CrossSize,NewPoint.Y);
        Canvas.MoveTo(NewPoint.X,NewPoint.Y-CrossSize);
        Canvas.LineTo(NewPoint.X,NewPoint.Y+CrossSize);
        Dec(X,NetStep);
        NewPoint:=CalcPoint(X,Y);
      end;
      Inc(Y,NetStep);
      X:=X0;
      NewPoint:=CalcPoint(X,Y);
    end;

    // приписываем надписи к точкам "по-умному"
    if SmartCaptions = 1 then
    begin
      SmartWriter(7, 0, 15);
    end
    else
    begin
    end;

  end;
end;

end.
