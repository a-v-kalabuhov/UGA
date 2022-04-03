unit uMStClassesWatermarkDraw;

interface

uses
  Types,
  Graphics,
  GdipApi,
  GdipClass;

type
  TWatermark = record
  private
    const WtText = 'Не является документом';
    const WtTextWidth = 500;
    const WtTextHeight = 50;
    const WtFontName = 'Arial';
    const WtFontSize = 42;
    const WtBorderSz = 0;
    const WtBorderAlpha = 100;
    const WtBorderRed = 50;
    const WtBorderGreen = 50;
    const WtBorderBlue = 150;
    const WtInnerAlpha = 50;
    const WtInnerRed = 170;
    const WtInnerGreen = 170;
    const WtInnerBlue = 180;
    const WtFontRed = 200;
    const WtFontGreen = 255;
    const WtFontBlue = 255;
  public
    Text: string;
    TextRect: TRect;
    FontName: string;
    FontSize: single;
    BorderSize: single;
    CQ: CompositingQuality;
    SM: SmoothingMode;
    TextWidth: Integer;
    TextHeight: Integer;
    BorderColorA: Byte;
    BorderColorR: Byte;
    BorderColorG: Byte;
    BorderColorB: Byte;
    InnerColorA: Byte;
    InnerColorR: Byte;
    InnerColorG: Byte;
    InnerColorB: Byte;
    FontColorA: Byte;
    FontColorR: Byte;
    FontColorG: Byte;
    FontColorB: Byte;
    function Default: TWatermark;
    function BorderColor: TGPColor;
    function InnerColor: TGPColor;
    function FontColor: TGPColor;
    function RectH: Integer;
    function RectW: Integer;
  end;

  TWatermarkDrawer = class
  private
    class procedure DrawWatermark(aCanvas: TCanvas; const aWatermark: TWatermark);
  public
    class procedure Draw(aBitmap: TBitmap; const aText: string); overload;
    class procedure Draw(aBitmap: TBitmap; const aWatermark: TWatermark); overload;
  end;


implementation

{ TWatermarkDrawer }

class procedure TWatermarkDrawer.Draw(aBitmap: TBitmap; const aText: string);
var
  Wtm: TWatermark;
begin
  Wtm := Wtm.Default();
  if aText <> '' then
     Wtm.Text := aText;
  Draw(aBitmap, Wtm);
end;

class procedure TWatermarkDrawer.Draw(aBitmap: TBitmap; const aWatermark: TWatermark);
var
  X, Y: Integer;
  B1, B2: Boolean;
  R: TRect;
  Wtm: TWatermark;
begin
  Wtm := aWatermark;
  if Wtm.TextHeight < 10 then
    Exit;
  if Wtm.TextWidth < 10 then
    Exit;
  B1 := True;
  X := 5;
  repeat
    B2 := B1;
    R.Left := X;
    Y := 5;
    repeat
      R.Top := Y;
      Y := Y + Wtm.TextHeight * 2;
      R.Bottom := Y;
      Wtm.TextRect := R;
      if B2 then
        DrawWatermark(aBitmap.Canvas, Wtm);
      B2 := not B2;
    until Y > aBitmap.Height;
    X := X + Wtm.TextWidth;
    R.Right := X;
    B1 := not B1;
  until X > aBitmap.Width;
end;

class procedure TWatermarkDrawer.DrawWatermark(aCanvas: TCanvas; const aWatermark: TWatermark);
var
//  ic, ir: integer;
  DPen: TGPPen;
  Layout: TGPRect;
  Drawer: TGPGraphics;
  DBrush: TGPSolidBrush;
  DFntFam: TGPFontFamily;
  DPath: TGPGraphicsPath;
  DFntFmt: TGPStringFormat;
//  image: TGPImage;
begin
  DFntFmt := nil;
  DFntFam := nil;
  DBrush := nil;
  DPen := nil;
  DPath := nil;
  Drawer := nil;
  try
    Drawer := TGPGraphics.Create(aCanvas.Handle);
    Drawer.SetCompositingQuality(aWatermark.CQ);
    Drawer.SetSmoothingMode(aWatermark.SM);

    DPath := TGPGraphicsPath.Create;
    DPen := TGPPen.Create(aWatermark.BorderColor, aWatermark.BorderSize);
    DBrush := TGPSolidBrush.Create(aWatermark.InnerColor);

    DFntFam := TGPFontFamily.Create(aWatermark.FontName);

    DFntFmt := TGPStringFormat.Create;
    DFntFmt.SetAlignment(StringAlignmentNear);
    DFntFmt.SetLineAlignment(StringAlignmentCenter);

    DPath.Reset;
    Layout.X := aWatermark.TextRect.Left;
    Layout.Y := aWatermark.TextRect.Top;
    Layout.Width := aWatermark.RectW;
    Layout.Height := aWatermark.RectH;
    DPath.AddString(aWatermark.Text, Length(aWatermark.Text), DFntFam,
      FontStyleRegular, aWatermark.FontSize, Layout, DFntFmt);
    //
    Drawer.DrawPath(DPen, DPath);
    Drawer.FillPath(DBrush, DPath);
  finally
    DFntFmt.Free;
    DFntFam.Free;
    DBrush.Free;
    DPen.Free;
    DPath.Free;
    Drawer.Free;
  end;
end;

{ TWatermark }

function TWatermark.BorderColor: TGPColor;
begin
  Result := ARGBMake(BorderColorA, BorderColorR, BorderColorG, BorderColorB);
end;

function TWatermark.Default: TWatermark;
begin
  Result.Text := WtText;
  Result.FontName := WtFontName;
  Result.FontSize := WtFontSize;
  Result.BorderSize := WtBorderSz;
  Result.CQ := CompositingQualityHighSpeed;
  Result.SM := SmoothingModeAntiAlias;
  Result.TextWidth := WtTextWidth;
  Result.TextHeight := WtTextHeight;
  Result.BorderColorA := WtBorderAlpha;
  Result.BorderColorR := WtBorderRed;
  Result.BorderColorG := WtBorderGreen;
  Result.BorderColorB := WtBorderBlue;
  Result.InnerColorA := WtInnerAlpha;
  Result.InnerColorR := WtInnerRed;
  Result.InnerColorG := WtInnerGreen;
  Result.InnerColorB := WtInnerBlue;
  Result.FontColorA := 255;
  Result.FontColorR := WtFontRed;
  Result.FontColorG := WtFontGreen;
  Result.FontColorB := WtFontBlue;
end;

function TWatermark.FontColor: TGPColor;
begin
  Result := ARGBMake(FontColorA, FontColorR, FontColorG, FontColorB);
end;

function TWatermark.InnerColor: TGPColor;
begin
  Result := ARGBMake(InnerColorA, InnerColorR, InnerColorG, InnerColorB);
end;

function TWatermark.RectH: Integer;
begin
  Result := TextRect.Top - TextRect.Bottom;
end;

function TWatermark.RectW: Integer;
begin
  Result := TextRect.Right - TextRect.Left;
end;

end.
