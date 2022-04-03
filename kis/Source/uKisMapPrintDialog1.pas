unit uKisMapPrintDialog1;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms, Printers,
  Dialogs, StdCtrls, ExtCtrls,
  uPrinters,
  uKisMapPrint, uKisAppModule;

type
  TMapPrintDialog1 = class(TInterfacedObject, IMapPrintDialog)
  private
    procedure Display(const Nomenclature: string; aBitmap: TBitmap);
  end;

  TKisMapPrintDialogForm = class(TForm)
    imgPreview: TImage;
    btnSetup: TButton;
    cbPrinters: TComboBox;
    PrinterSetupDialog1: TPrinterSetupDialog;
    btnPrint: TButton;
    btnClose: TButton;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormResize(Sender: TObject);
    procedure btnSetupClick(Sender: TObject);
    procedure cbPrintersChange(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure btnPrintClick(Sender: TObject);
  private
    FMapPrint: TKisMapPrint;
    FPreviewBmp: TBitmap;
    FSelPrinter: string;
    function CheckPaperSize(): Boolean;
    procedure FillPrinterList();
    procedure UpdatePreview();
  private
    procedure Display(const Nomenclature: string; aBitmap: TBitmap);
  end;

implementation

{$R *.dfm}

procedure TKisMapPrintDialogForm.btnPrintClick(Sender: TObject);
begin
  if CheckPaperSize() then
    FMapPrint.Print(Printer);
end;

procedure TKisMapPrintDialogForm.btnSetupClick(Sender: TObject);
begin
  PrinterSetupDialog1.Execute(Handle);
  UpdatePreview();
end;

procedure TKisMapPrintDialogForm.cbPrintersChange(Sender: TObject);
begin
  Printer.PrinterIndex := cbPrinters.ItemIndex;
  UpdatePreview();
end;

function TKisMapPrintDialogForm.CheckPaperSize: Boolean;
var
  PrintArea: TPageSizeMm;
  MsgResult: Integer;
begin
  PrintArea := Printer.GetPrintAreaMm();
  Result := (PrintArea.Width >= 600) or (PrintArea.Height >= 600);
  if not Result then
  begin
    MsgResult := MessageBox(
        Handle,
        PChar('Размер бумаги слишком мал для печати планшета целиком!' + sLineBreak + 'Начать печатать?'),
        'Внимание!',
        MB_YESNO + MB_ICONQUESTION);
    Result := MsgResult = ID_YES;
  end;
end;

procedure TKisMapPrintDialogForm.Display(const Nomenclature: string; aBitmap: TBitmap);
begin
  Caption := 'Печать планшета ' + Nomenclature;
  if FMapPrint = nil then
    FMapPrint := TKisMapPrint.Create(Nomenclature, aBitmap);
  FSelPrinter := AppModule.ReadAppParamDef('MapPrint', 'SelPrinter', varString, '');
  FillPrinterList();
  UpdatePreview();
  ShowModal;
end;

procedure TKisMapPrintDialogForm.FillPrinterList();
var
  PrnIndex: Integer;
  I: Integer;
begin
  cbPrinters.Items.Assign(Printer.Printers);
  PrnIndex := Printer.PrinterIndex;
  if FSelPrinter = '' then
  begin
    for I := 0 to Printer.Printers.Count - 1 do
      if Printer.Printers[I] = FSelPrinter then
      begin
        PrnIndex := I;
        Break;
      end;
  end;
  cbPrinters.ItemIndex := PrnIndex;
end;

procedure TKisMapPrintDialogForm.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  AppModule.SaveAppParam('MapPrint', 'SelPrinter', FSelPrinter);
end;

procedure TKisMapPrintDialogForm.FormDestroy(Sender: TObject);
begin
  FreeAndNil(FPreviewBmp);
end;

procedure TKisMapPrintDialogForm.FormResize(Sender: TObject);
begin
  UpdatePreview();
end;

procedure TKisMapPrintDialogForm.UpdatePreview;
var
  Sz: TSize;
begin
  FreeAndNil(FPreviewBmp);
  Sz.cx := imgPreview.ClientWidth;
  Sz.cy := imgPreview.ClientHeight; 
  FPreviewBmp := FMapPrint.GetPreviewImage(Printer, Sz);
  imgPreview.Picture.Bitmap := FPreviewBmp;
end;

{ TMapPrintDialog1 }

procedure TMapPrintDialog1.Display(const Nomenclature: string; aBitmap: TBitmap);
var
  Frm: TKisMapPrintDialogForm;
begin
  Frm := TKisMapPrintDialogForm.Create(Application);
  try
    Frm.Display(Nomenclature, aBitmap);
  finally
    FreeAndNil(Frm);
  end;
end;

end.
