unit rtf2emf;

interface

uses
  Graphics;

  function GetMetafileA4(rtf_filename: String; canvas: TCanvas): TMetafile;

implementation

uses
  Forms, ComCtrls, RichEdit, Printers, Windows, Types;

function  GetMetafileA4(rtf_filename: String; canvas: TCanvas): TMetafile;
var
//  canvas: TMetafileCanvas;
  richedit: TRichEdit;
  Range: TFormatRange;
  LastChar, MaxLen, LogX, LogY, OldMap: Integer;
  SaveRect: TRect;
begin
  result := TMetafile.Create;
//  canvas := TMetafileCanvas.Create(result, Printer.Handle);
  richedit := TRichEdit.Create(Application);
  try
    richedit.Visible := False;
    richedit.Parent := Application.MainForm;
    richedit.Lines.LoadFromFile(rtf_filename);
    // Рисуем
    FillChar(Range, SizeOf(TFormatRange), 0);
    with Range do
    begin
      hdc := canvas.Handle;
      hdcTarget := hdc;
      LogX := GetDeviceCaps(Printer.Handle, LOGPIXELSX);
      LogY := GetDeviceCaps(Printer.Handle, LOGPIXELSY);
      if IsRectEmpty(richedit.PageRect) then
      begin
        rc.right := Printer.PageWidth * 1440 div LogX;
        rc.bottom := Printer.PageHeight * 1440 div LogY;
      end
      else begin
        rc.left := richedit.PageRect.Left * 1440 div LogX;
        rc.top := richedit.PageRect.Top * 1440 div LogY;
        rc.right := richedit.PageRect.Right * 1440 div LogX;
        rc.bottom := richedit.PageRect.Bottom * 1440 div LogY;
      end;
    result.Width := Trunc(210 / 25.4 * LogX);
    result.Height := trunc(297 / 25.4 * LogY);
//      rc := Rect(0, 0, result.Width, result.Height);
//      rcPage := rc;
      SaveRect := rc;
      LastChar := 0;
      MaxLen := richedit.GetTextLen;
      chrg.cpMax := -1;
      // ensure printer DC is in text map mode
      OldMap := SetMapMode(hdc, MM_TEXT);
      richedit.Perform(EM_FORMATRANGE, 0, 0);    // flush buffer
      try
        repeat
          rc := SaveRect;
          chrg.cpMin := LastChar;
          LastChar := richedit.Perform(EM_FORMATRANGE, 1, Longint(@Range));
          if (LastChar < MaxLen) and (LastChar <> -1) then
          begin
            rc := Rect(rc.Left, rc.Bottom, rc.Right, rc.Bottom + (rc.Bottom - rc.Top));
            rcPage := rc;
//            result.Height := result.Height + Trunc(297 / 25.4 * LogY);
          end;
        until (LastChar >= MaxLen) or (LastChar = -1);
      finally
        richedit.Perform(EM_FORMATRANGE, 0, 0);  // flush buffer
        SetMapMode(hdc, OldMap);       // restore previous map mode
      end;
    end;
  finally
//    canvas.Free;
    richedit.Free;
  end;
end;

end.
