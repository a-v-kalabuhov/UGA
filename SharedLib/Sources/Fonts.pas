unit Fonts;

{$IFDEF readmeplease}
  **************************************************
  * Разворачивает шрифт на заданное число градусов *
  * Очень простая фигня, но если не ясно:          *
  * -= frzkb@fastiv.kiev.ua =-                     *
  * Проверено для Win2k (если не пашет на Win9x,   *
  * то разкомментить указанную строку!)            * 
  **************************************************
{$ENDIF}


{Проверено для Win2k}

interface

uses
  Graphics, Windows;

procedure RotateFont (var Fnt: TFont; Gradus: Integer);

implementation

//
// Разворачивает шрифт на заданное число градусов
// Можно использовать ТОЛЬКО для векторных 
// (TrueType,Outline,PostScript) шрифтов 
// не битмэпных (.fon)
//

procedure RotateFont (var Fnt: TFont; Gradus: Integer);
var lfnt: TLogFont;
begin
  GetObject(Fnt.Handle, SizeOf(LFNT), @LFNT);
  lfnt.lfEscapement := Gradus * 10;

  {
  Проверьте для Win9x > если не пойдет добавить:
  lfnt.lfRotate := Gradus*10;
  }

  Fnt.Handle := CreateFontIndirect (lfnt);
end;


end.
 