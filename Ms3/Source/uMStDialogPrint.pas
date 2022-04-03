unit uMStDialogPrint;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ComCtrls, StdCtrls, ExtCtrls;

type
  TmstDialogPrint = class(TForm)
    Label1: TLabel;
    edCopies: TEdit;
    UpDown1: TUpDown;
    Label2: TLabel;
    Button1: TButton;
    Button2: TButton;
    Label3: TLabel;
    Label4: TLabel;
    Image: TImage;
  end;

  function ShowPrintDialog(var Copies: SmallInt; pPrinterName: String): Boolean;

implementation

{$R *.dfm}

function ShowPrintDialog(var Copies: SmallInt; pPrinterName: String): Boolean;
begin
  with TmstDialogPrint.Create(Application) do
  try
    UpDown1.Position := copies;
    Label4.Caption := pPrinterName;
    Result := ShowModal = mrOK;
    if Result then
      Copies := UpDown1.Position;
  finally
    Release;
  end;
end;

end.
