unit EzRichEditForm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ComCtrls;

type
  TfrmRichEdit = class(TForm)
    RichEdit: TRichEdit;
  private
    { Private declarations }
  public
    procedure DrawOn(pCanvas: TCanvas; pTextRect: TRect);
  end;

implementation

uses
  RichEdit;

{$R *.dfm}

procedure TfrmRichEdit.DrawOn(pCanvas: TCanvas; pTextRect: TRect);
var
  Range: TFormatRange;
  intPPI_X, intPPI_Y: Integer;
begin
  with RichEdit, Range do
  begin
    SendMessage(Handle, EM_FORMATRANGE, 0, 0);
    FillChar(Range, SizeOf(TFormatRange), 0);
    hdc := pCanvas.Handle;
    hdcTarget := pCanvas.Handle;
    intPPI_X := GetDeviceCaps(pCanvas.Handle, LOGPIXELSX);
    intPPI_Y := GetDeviceCaps(pCanvas.Handle, LOGPIXELSY);
    with pTextRect do
    rc := Rect(Trunc(Left * 1440 / intPPI_X),
               Trunc(Top * 1440 / intPPI_Y),
               Trunc(Right * 1440 / intPPI_X),
               Trunc(Bottom * 1440 / intPPI_Y));
    rcPage := rc;
    chrg.cpMax := -1;
    Perform(EM_FORMATRANGE, 1, Longint(@Range));
    Perform(EM_FORMATRANGE, 0, 0);
  end;
end;

end.
