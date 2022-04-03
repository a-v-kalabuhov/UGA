unit uPrinters;

interface

uses
  Types, Printers, Windows;

type
  TPageMargins = record
    Top, Bottom, Left, Right: Integer;
  end;

  TPageMarginsMM = record
    Top, Bottom, Left, Right: Double;
  end;

  TPagePPI = record
    Horizontal, Vertical: Integer;
  end;

  TPageSize = record
    Width, Height: Integer;
  end;

  TPageSizeMm = record
    Width, Height: Double;
  end;

  TPageOffset = record
    Left, Top: Integer;
  end;

  TPrinterHelper = class helper for TPrinter
  public
    /// <summary>
    /// Возвращает размер физического отступа от края листа до зоны печати принтера.
    /// </summary>
    function GetMargins(): TPageMargins;
    function GetMarginsMM(): TPageMarginsMm;
    function GetPageSize(): TPageSize;
    function GetPageSizeMm(): TPageSizeMm;
    function GetPixelPerInch(): TPagePPI;
    function GetPrintArea(): TPageSize;
    function GetPrintAreaMm(): TPageSizeMm;
    function GetPhysicalOffset(): TPageOffset;
  end;

implementation

{ TPrinterHelper }

function TPrinterHelper.GetMargins: TPageMargins;
var
  Offset: TPageOffset;
  Printable: TPageSize;
  Sz: TPageSize;
begin
  Printable := GetPrintArea();
  Offset := GetPhysicalOffset();
  Sz := GetPageSize();
  // Top Margin
  Result.Top := Offset.Top;
  // Left Margin
  Result.Left := Offset.Left;
  // Bottom Margin
  Result.Bottom := Sz.Height - Offset.Top - Printable.Height;
  // Right Margin
  Result.Bottom := Sz.Width - Offset.Left - Printable.Width;
end;

function TPrinterHelper.GetMarginsMM: TPageMarginsMm;
var
  A: TPageSize;
  Amm: TPageSizeMm;
  Kx, Ky: Double;
  Ppi: TPagePPI;
  Sz: TPageSize;
  Offset: TPageOffset;
begin
  A := GetPrintArea();
  Amm := GetPrintAreaMm();
  Kx := A.Width / Amm.Width;
  Ky := A.Height / Amm.Height;
  Offset := GetPhysicalOffset();
  Ppi := GetPixelPerInch();
  Sz := GetPageSize();
  // Top Margin
  Result.Top := Offset.Top / Ky;
  // Bottom Margin
  Result.Bottom := (Sz.Height - Offset.Top - A.Height) / Ky;
  // Left Margin
  Result.Left := Offset.Left / Kx;
  // Right Margin
  Result.Right := (Sz.Width - Offset.Left - A.Width) / Kx;
end;

function TPrinterHelper.GetPageSize: TPageSize;
begin
  Result.Width := GetDeviceCaps(Self.Handle, PHYSICALWIDTH);
  Result.Height := GetDeviceCaps(Self.Handle, PHYSICALHEIGHT);
end;

function TPrinterHelper.GetPageSizeMm: TPageSizeMm;
var
  A: TPageSize;
  Amm: TPageSizeMm;
  Kx, Ky: Double;
  Sz: TPageSize;
begin
  A := GetPrintArea();
  Amm := GetPrintAreaMm();
  Kx := A.Width / Amm.Width;
  Ky := A.Height / Amm.Height;
  Sz := GetPageSize();
  Result.Width := Sz.Width / Kx;
  Result.Height := Sz.Height / Ky;
end;

function TPrinterHelper.GetPhysicalOffset: TPageOffset;
begin
  Result.Left := GetDeviceCaps(Self.Handle, PHYSICALOFFSETX);
  Result.Top := GetDeviceCaps(Self.Handle, PHYSICALOFFSETY);
end;

function TPrinterHelper.GetPixelPerInch: TPagePPI;
begin
  Result.Horizontal := GetDeviceCaps(Self.Handle, LOGPIXELSY);
  Result.Vertical := GetDeviceCaps(Self.Handle, LOGPIXELSX);
end;

function TPrinterHelper.GetPrintArea: TPageSize;
begin
  Result.Width := GetDeviceCaps(Self.Handle, HORZRES);
  Result.Height := GetDeviceCaps(Self.Handle, VERTRES);
end;

function TPrinterHelper.GetPrintAreaMm: TPageSizeMm;
begin
  Result.Width := GetDeviceCaps(Self.Handle, HORZSIZE);
  Result.Height := GetDeviceCaps(Self.Handle, VERTSIZE);
end;

end.
