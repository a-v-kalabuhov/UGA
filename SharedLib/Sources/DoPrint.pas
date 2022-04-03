unit DoPrint;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ComCtrls, StdCtrls;

type
  TfrmDoPrint = class(TForm)
    Label1: TLabel;
    Edit1: TEdit;
    UpDown1: TUpDown;
    Label2: TLabel;
    Button1: TButton;
    Button2: TButton;
    Label3: TLabel;
    Label4: TLabel;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

  function ShowDoPrint(var copies: SmallInt; pPrinterName: String): Boolean;

implementation

{$R *.dfm}

function ShowDoPrint(var copies: SmallInt; pPrinterName: String): Boolean;
begin
  with TfrmDoPrint.Create(Application) do
  try
    UpDown1.Position := copies;
    Label4.Caption := pPrinterName;
    result := ShowModal = mrOK;
    if result then copies := UpDown1.Position;
  finally
    Release;
  end;
end;

end.
