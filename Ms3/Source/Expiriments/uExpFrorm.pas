unit uExpFrorm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs;

type
  TForm1 = class(TForm)
    procedure FormPaint(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.dfm}

procedure TForm1.FormPaint(Sender: TObject);
const
 Size = 600; // Общий размер
 Bnd = 200; // Ширина прозрачной границы общей области
 FgColor = clYellow; // Цвет фигуры - может быть любым
var
 FgR, BgR: TRect; // Область фигуры и общая
 Mask, Pic: TBitmap; // Маска и картинка

 function CreateBmp(FgColor, BgColor: TColor): TBitmap;
 begin
   Result := TBitmap.Create;
   with Result do
   try
     Width := Size;
     Height := Size;
     Canvas.Brush.Color := BgColor; // Заливаем общую область
     Result.Canvas.FillRect(BgR);
     Canvas.Brush.Color := FgColor; // Заливаем фигуру
     Result.Canvas.FillRect(FgR)
   except
     Free;
     raise
   end
 end;
var
  Bmp1, Bmp2: TBitmap;
  R: TRect;
begin
// FgR := Rect(Bnd, Bnd, Size - Bnd, Size - Bnd);
// BgR := Rect(0, 0, Size, Size);
// Mask := CreateBmp(clBlue, clGreen); // Готовим маску
// try
//   Pic := CreateBmp(FgColor, clBlack); // Готовим картинку
//   try
//     Canvas.CopyMode := cmSrcAnd; // Рисуем маску
//     Canvas.CopyRect(Bgr, Mask.Canvas, Bgr);
//     Canvas.CopyMode := cmSrcPaint; // Рисуем картинку
//     Canvas.CopyRect(Bgr, Pic.Canvas, Bgr)
//   finally
//     Pic.Free
//   end
// finally
//   Mask.Free
// end
  R := Rect(0, 0, 500, 500);
  Bmp1 := TBitmap.Create;
  Bmp1.SetSize(500, 500);
  Bmp1.Canvas.Brush.Color := clRed;
  Bmp1.Canvas.FillRect(R);
  Bmp1.Canvas.Pen.Color := clGreen;
  Bmp1.Canvas.MoveTo(100, 100);
  Bmp1.Canvas.LineTo(200, 80);
  //
  Bmp2 := TBitmap.Create;
  Bmp2.SetSize(500, 500);
  Bmp2.Canvas.Brush.Color := clWhite; //clRed;
  Bmp2.Canvas.FillRect(R);
  Bmp2.Canvas.Font.Color := clGrayText;
  Bmp2.Canvas.TextOut(100, 100, 'Привет!!!');
  //
  Bmp1.Canvas.CopyMode := cmMergeCopy;
  Bmp1.Canvas.CopyRect(R, Bmp2.Canvas, R);
  //
  Self.Canvas.Draw(0, 0, Bmp1);
  //
  Bmp1.Free;
  Bmp2.Free;
end;

end.
