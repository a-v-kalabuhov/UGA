unit APrinter6;

interface

uses Windows, Printers, Classes, SysUtils, WinSpool, AProc6;

type
  TPageScale=(psAll, psWidth, ps100);
  TPaperSizes=array of TPoint;

  TPrinterUnits=record
    PixPerMM, PageWidthMM, PageHeightMM: Double;
  end;

var
  PrnPixPerMMH, PrnPixPerMMV, PageWidthMM, PageHeightMM: Double;

procedure GetPrinterUnits;
procedure GetPrinters(var Printers: TStrings);
function GetPrinterCapabilities(Capability: Word): Integer;
procedure GetPrinterPaperNames(PaperNames: TStrings);
procedure GetPrinterPaperSizes(var Sizes: TPaperSizes);

implementation

procedure GetPrinterUnits;
begin
  if Printer.Printers.Count=0 then
    Windows.MessageBox(0,'Принтер не установлен','Ошибка',MB_ICONSTOP);
  try
    PrnPixPerMMH:=GetDeviceCaps(Printer.Handle,HORZRES)/GetDeviceCaps(Printer.Handle,HORZSIZE);
    PrnPixPerMMV:=GetDeviceCaps(Printer.Handle,VERTRES)/GetDeviceCaps(Printer.Handle,VERTSIZE);
    PageWidthMM:=GetDeviceCaps(Printer.Handle,HORZSIZE);
    PageHeightMM:=GetDeviceCaps(Printer.Handle,VERTSIZE);
  except
    Windows.MessageBox(0, 'Произошел сбой! Возможно принтер не доступен.', 'Ошибка', MB_ICONSTOP);
  end;
end;

procedure GetPrinters(var Printers: TStrings);
var
  Flags, Count, NumInfo: Cardinal;
  Level: Byte;
  Buffer, PrinterInfo: PChar;
  I: Integer;
begin
  Printers.Clear;
  if Win32Platform=VER_PLATFORM_WIN32_NT then begin
    Flags:=PRINTER_ENUM_CONNECTIONS or PRINTER_ENUM_LOCAL;
    Level:=4;
  end
  else
  begin
    Flags:=PRINTER_ENUM_LOCAL;
    Level:=5;
  end;
  EnumPrinters(Flags,nil,Level,nil,0,Count,NumInfo);
  if Count=0 then Exit;
  GetMem(Buffer,Count);
  try
    if not EnumPrinters(Flags, nil, Level, PByte(Buffer), Count, Count, NumInfo) then
      Exit;
    PrinterInfo:=Buffer;
    for I:=0 to NumInfo-1 do begin
      if Level=4 then with PPrinterInfo4(PrinterInfo)^ do begin
        Printers.Add(pPrinterName);
        Inc(PrinterInfo, sizeof(TPrinterInfo4));
      end
      else with PPrinterInfo5(PrinterInfo)^ do begin
        Printers.Add(pPrinterName);
        Inc(PrinterInfo, sizeof(TPrinterInfo5));
      end;
    end;
  finally
    FreeMem(Buffer,Count);
  end;
end;

function GetPrinterCapabilities(Capability: Word): Integer;
// Capability: DC_COPIES, DC_DRIVER, DC_DUPLEX
begin
  Result:=DeviceCapabilities(PChar(Printer.Printers[Printer.PrinterIndex]),
    nil,Capability,nil,nil);
end;

procedure GetPrinterPaperNames(PaperNames: TStrings);
type
  //Размеры бумаги
  TPName=array[0..63] of Char;
  TPNames=array[0..0] of TPName;
var
  I, Count: Integer;
  Names: Pointer;
begin
  PaperNames.Clear;
  Count:=DeviceCapabilities(PChar(Printer.Printers[Printer.PrinterIndex]),
    nil,DC_PAPERNAMES,nil,nil);
  if Count=0 then Exit;
  GetMem(Names,Count*64);
  try
    if DeviceCapabilities(PChar(Printer.Printers[Printer.PrinterIndex]),
      nil,DC_PAPERNAMES,Names,nil)=-1 then Abort;
    for I:=0 to Count-1 do
      PaperNames.Add(TPNames(Names^)[I]);
  finally
    FreeMem(Names,Count*64);
  end;
end;

procedure GetPrinterPaperSizes(var Sizes: TPaperSizes);
type
  TPoints=array[0..0] of TPoint;
var
  I, Count: Integer;
  S: Pointer;
begin
  Count:=DeviceCapabilities(PChar(Printer.Printers[Printer.PrinterIndex]),
    nil,DC_PAPERSIZE,nil,nil);
  if Count=0 then Exit;
  SetLength(Sizes,Count);
  GetMem(S,Count*SizeOf(TPoint));
  try
    if DeviceCapabilities(PChar(Printer.Printers[Printer.PrinterIndex]),
      nil,DC_PAPERSIZE,S,nil)=-1 then Abort;
    for I:=0 to Count-1 do begin
      Sizes[I]:=(TPoints(S^)[I]);
      Sizes[I].X:=Round(Sizes[I].X/10);
      Sizes[I].Y:=Round(Sizes[I].Y/10);
    end;
  finally
    FreeMem(S,Count*SizeOf(TPoint));
  end;
end;

initialization
  GetPrinterUnits;
end.
