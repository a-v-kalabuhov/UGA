unit uMStWatermarkDraw;

interface

uses
  Types,
  Graphics,
  GdipApi,
  GdipClass;

procedure Draw_GDIText_2(
    aCanvas: TCanvas;
    OffsetX, OffsetY: Integer;
    vDString: string;
    vDFntName: string;
    vDFntSize: single;
    vDBrdSize: single;
    vDBorderCol: TGPColor;
    vDInnerCol: TGPColor;
    vDCQ: CompositingQuality;
    vDSM: SmoothingMode;
    vDFonCol: TGPColor
);


implementation

procedure DrawWatermark(
    aCanvas: TCanvas;
    aRect: TRect;
    vDString: string;
    vDFntName: string;
    vDFntSize: single;
    vDBrdSize: single;
    vDBorderCol: TGPColor;
    vDInnerCol: TGPColor;
    vDCQ: CompositingQuality;
    vDSM: SmoothingMode;
    vDFonCol: TGPColor
);
var
  ic, ir: integer;
  DPen: TGPPen;
  Layout: TGPRect;
  Drawer: TGPGraphics;
  DBrush: TGPSolidBrush;
  DFntFam: TGPFontFamily;
  DPath: TGPGraphicsPath;
  DFntFmt: TGPStringFormat;
  image: TGPImage;
begin
  try
    Drawer := TGPGraphics.Create(aCanvas.Handle);
    Drawer.SetCompositingQuality(vDCQ);
    Drawer.SetSmoothingMode(vdSM);

    DPath := TGPGraphicsPath.Create;
    DPen := TGPPen.Create(vDBorderCol, vDBrdSize);
    DBrush := TGPSolidBrush.Create(vDInnerCol);

    DFntFam := TGPFontFamily.Create(vDFntName);

    DFntFmt := TGPStringFormat.Create;
    DFntFmt.SetAlignment(StringAlignmentCenter);
    DFntFmt.SetLineAlignment(StringAlignmentCenter);

    DPath.Reset;
    Layout.X := aRect.Left;
    Layout.Y := aRect.Top;
    Layout.Width := aRect.Right - aRect.Left;
    Layout.Height := aRect.Bottom - aRect.Top;
    DPath.AddString(vDString, Length(vDString), DFntFam, FontStyleRegular, vDFntSize, Layout, DFntFmt);

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

end.
