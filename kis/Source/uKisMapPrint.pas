unit uKisMapPrint;

interface

uses
  Windows, Graphics, Printers, Types, Forms,
  uPrinters, uGraphics,
  uKisExceptions;

type
  IMapPrintDialog = interface
    ['{DD07089F-6735-42A0-ACAB-E52D2B493E2E}']
    procedure Display(const Nomenclature: string; aBitmap: TBitmap);
  end;

  TMapPrintDialogFactory = class
  public
    class function CreateDialog(): IMapPrintDialog;
  end;

  TKisMapPrint = class
  private
    FBitmap: TBitmap;
    FNomenclature: string; 
  public
    constructor Create(const Nomenclature: string; aMapBitmap: TBitmap);
    //
    procedure Print(aPrinter: TPrinter);
    function GetPreviewImage(aPrinter: TPrinter; PreviewSize: TSize): TBitmap;
  end;

implementation

uses
  uKisMapPrintDialog1;

{ TKisMapPrint }

constructor TKisMapPrint.Create(const Nomenclature: string; aMapBitmap: TBitmap);
begin
  inherited Create;
  FNomenclature := Nomenclature;
  FBitmap := aMapBitmap;
end;

function TKisMapPrint.GetPreviewImage(aPrinter: TPrinter; PreviewSize: TSize): TBitmap;
var
  PrnMargins: TPageMargins;
  PrnSize: TPageSize;
  K, Kx, Ky: Double;
  BmpSize: TPageSize;
  Ppi: TPagePPI;
  PrnCm60x, PrnCm60y: Integer;
  PrnPageRect: TRect;
  BmpPageRect: TRect;
  BmpCm5x, BmpCm5y, BmpCm1y: Integer;
  MapRect: TRect;
  BmpTextWidth: Integer;
  ClipRect: TRect;
begin
  PreviewSize.cx := PreviewSize.cx - 5;
  PreviewSize.cy := PreviewSize.cy - 5;
  Result := TBitmap.Create();
  Result.SetSize(PreviewSize.cx, PreviewSize.cy);
  //
  PrnMargins := aPrinter.GetMargins();
  PrnSize := aPrinter.GetPageSize();
  Kx := Result.Width / PrnSize.Width;
  Ky := Result.Height / PrnSize.Height;
  K := Kx;
  BmpSize.Width := Trunc(PrnSize.Width * K);
  BmpSize.Height := Trunc(PrnSize.Height * K);
  if BmpSize.Width > PreviewSize.cx then
  begin
    K := Ky;
    BmpSize.Width := Trunc(PrnSize.Width * K);
    BmpSize.Height := Trunc(PrnSize.Height * K);
  end;
  // фон
  Result.Canvas.Brush.Style := bsSolid;
  Result.Canvas.Brush.Color := clBackground;
  Result.Canvas.Rectangle(0, 0, Result.Width, Result.Height);
  // страница
  Result.Canvas.Brush.Style := bsSolid;
  Result.Canvas.Brush.Color := clWhite;
  Result.Canvas.Pen.Style := psSolid;
  Result.Canvas.Pen.Width := 1;
  Result.Canvas.Pen.Color := clBlack;
  Result.Canvas.Rectangle(4, 4, Result.Width - 4, Result.Height - 4);
  //
  ClipRect := Rect(5, 5, Result.Width - 5, Result.Height - 5);
  Result.Canvas.BeginClipping(ClipRect);
  try
    // квадрат 60 на 60
    // в нём картинка в квадрате 50 на 50
    // над картинкой текст
    Ppi := aPrinter.GetPixelPerInch();
    PrnCm60x := Trunc(60 / 2.54 * Ppi.Horizontal);
    PrnCm60y := Trunc(60 / 2.54 * Ppi.Vertical);
    PrnPageRect := Rect(0, 0, PrnCm60x, PrnCm60y);
    BmpPageRect := Rect(0, 0, Trunc(PrnCm60x * K), Trunc(PrnCm60y * K));
    // теперь этот прямоугольник надо сместить на величину поля - 5 см
    BmpCm5x := Round(BmpPageRect.Right / 12);
    BmpCm5y := Round(BmpPageRect.Bottom / 12);
    BmpCm1y := Round(BmpPageRect.Bottom / 60);
    MapRect := Rect(BmpCm5x, BmpCm5y, BmpPageRect.Right - BmpCm5x, BmpPageRect.Bottom - BmpCm5y);
    Result.Canvas.StretchDraw(MapRect, FBitmap);
    Result.Canvas.Font.Height := BmpCm1y;
    BmpTextWidth := Result.Canvas.TextWidth(FNomenclature);
    Result.Canvas.TextOut(
      MapRect.Left + (MapRect.Right - MapRect.Left - BmpTextWidth) div 2,
      MapRect.Top - BmpCm1y * 2,
      FNomenclature
    );
  finally
    Result.Canvas.EndClipping();
  end;
end;

procedure TKisMapPrint.Print;
var
  PrnMargins: TPageMargins;
  PrnSize: TPageSize;
  Ppi: TPagePPI;
  PrnCm60x, PrnCm60y: Integer;
  PrnPageRect: TRect;
  PrnCm5x, PrnCm5y, PrnCm1y: Integer;
  MapRect: TRect;
  PrnTextWidth: Integer;
begin
  // получаем параметры принтера
  // вычисляем размер страницы в мм
  // вычисляем размер полей в мм
  // строим картинку
  PrnMargins := aPrinter.GetMargins();
  PrnSize := aPrinter.GetPageSize();
  // квадрат 60 на 60
  // в нём картинка в квадрате 50 на 50
  // над картинкой текст
  Ppi := aPrinter.GetPixelPerInch();
  PrnCm60x := Trunc(60 / 2.54 * Ppi.Horizontal);
  PrnCm60y := Trunc(60 / 2.54 * Ppi.Vertical);
  PrnPageRect := Rect(0, 0, PrnCm60x, PrnCm60y);
  // теперь этот прямоугольник надо сместить на величину поля - 5 см
  PrnCm5x := Round(PrnCm60x / 12);
  PrnCm5y := Round(PrnCm60y / 12);
  PrnCm1y := Round(PrnCm60y / 60);
  MapRect := Rect(PrnCm5x, PrnCm5y, Round(PrnPageRect.Right - PrnCm5x * 0.995), Round(PrnPageRect.Bottom - PrnCm5y * 0.995));
  aPrinter.BeginDoc;
  try
    aPrinter.Title := FNomenclature;
    aPrinter.Canvas.StretchDraw(MapRect, FBitmap);
    aPrinter.Canvas.Font.Height := PrnCm1y;
    PrnTextWidth := aPrinter.Canvas.TextWidth(FNomenclature);
    aPrinter.Canvas.TextOut(
      MapRect.Left + (MapRect.Right - MapRect.Left - PrnTextWidth) div 2,
      MapRect.Top - PrnCm1y * 2,
      FNomenclature
    );
    aPrinter.EndDoc;
  except
    aPrinter.Abort;
  end;
end;

{ TMapPrintDialogFactory }

class function TMapPrintDialogFactory.CreateDialog: IMapPrintDialog;
begin
  Result := TMapPrintDialog1.Create();
end;

end.
