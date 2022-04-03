unit uGraphics;

interface

uses
  SysUtils, Windows, Classes, Graphics, jpeg, Math;

type
  TBitmapExt = class helper for TBitmap
  public
    class function CreateFromFile(const aFileName: String): TBitmap;
    class function CreateFromStream(Stream: TStream): TBitmap; overload;
    class function CreateFromStream(Stream: TStream; FileExt: String): TBitmap; overload;
    class function FileIsBottomUp(const BitmapFile: String): Boolean;
    class function FileGetInfo(const BitmapFile: String): TBitmapInfo;

    procedure CopyFrom(Source: TBitmap; DoDraw: Boolean);
    function GetInfoHeader: TBitmapInfoHeader;
    function IsBottomUp: Boolean;
    procedure ReplaceColor(OldColor, NewColor: TColor);
    procedure SaveToFileEx(const FileName: string; XRes, YRes: Longint);
    procedure SaveToJpeg(const FileName: string);
  end;

  TCanvasExt = class helper for TCanvas
  public
    procedure DrawCrosses(const Height, Width: Integer);
    procedure BeginClipping(const aRect: TRect);
    procedure EndClipping();
  end;

implementation

uses
  GraphicEx;

var
  RegionTCanvasExt: HRGN;

class function TBitmapExt.FileIsBottomUp(const BitmapFile: String): Boolean;
var
  BitmapInfo: PBitmapInfo;
  HeaderSize: Integer;
  Stream: TStream;
  Bmf: TBitmapFileHeader;
begin
  Stream := TFileStream.Create(BitmapFile, fmOpenRead);
  try
    Stream.ReadBuffer(Bmf, sizeof(Bmf));
    Stream.Read(HeaderSize, sizeof(HeaderSize));
    GetMem(BitmapInfo, HeaderSize + 12 + 256 * sizeof(TRGBQuad));
    Stream.Read(Pointer(Longint(BitmapInfo) + sizeof(HeaderSize))^,
      HeaderSize - sizeof(HeaderSize));
    Result := BitmapInfo.bmiHeader.biHeight >= 0;
  finally
    FreeAndNil(Stream);
  end;
end;

function TBitmapExt.GetInfoHeader: TBitmapInfoHeader;
var
  DS: TDIBSection;
  Bytes: Integer;
  bError: Boolean;
begin
  DS.dsbmih.biSize := 0;
  Bytes := GetObject(Self.Handle, SizeOf(DS), @DS);
  bError := Bytes = 0;
  if not bError then
    if (Bytes >= (sizeof(DS.dsbm) + sizeof(DS.dsbmih)))
       and
       (DS.dsbmih.biSize >= DWORD(sizeof(DS.dsbmih)))
    then
      Result := DS.dsbmih
    else
      bError := True;
  if bError then
    raise Exception.Create('Invalid bitmap');
end;

procedure TBitmapExt.CopyFrom;
var
  Stream: TMemoryStream;
begin
  if DoDraw then
  begin
    PixelFormat := Source.PixelFormat;
    SetSize(Source.Width, Source.Height);
    Canvas.Draw(0, 0, Source);
  end
  else
  begin
    Stream := TMemoryStream.Create;
    try
      Source.SaveToStream(Stream);
      Stream.Position := 0;
      LoadFromStream(Stream);
    finally
      FreeAndNil(Stream);
    end;
  end;
end;

class function TBitmapExt.CreateFromFile(const aFileName: String): TBitmap;
var
  JPG: TJPEGImage;
  PNG: TPNGGraphic;
  TIFF: TTIFFGraphic;
  FileExt: string;
begin
  FileExt := AnsiUpperCase(ExtractFileExt(aFileName));
  if (FileExt = '.JPG') or (FileExt = '.JPEG') or (FileExt = '.JPE') then
  begin
    Result := TBitmap.Create;
    Result.PixelFormat := pf24bit;
    JPG := TJPEGImage.Create;
    try
      JPG.LoadFromFile(aFileName);
      Result.Assign(JPG);
    finally
      FreeAndNil(JPG);
    end;
  end
  else
  if (FileExt = '.TIFF') then
  begin
    Result := TBitmap.Create;
    Result.PixelFormat := pf24bit;
    TIFF := TTIFFGraphic.Create;
    try
      TIFF.LoadFromFile(aFileName);
      Result.Assign(TIFF);
    finally
      FreeAndNil(TIFF);
    end;
  end
  else
  if (FileExt = '.PNG') then
  begin
    Result := TBitmap.Create;
    Result.PixelFormat := pf24bit;
    PNG := TPNGGraphic.Create;
    try
      PNG.LoadFromFile(aFileName);
      Result.Assign(PNG);
    finally
      FreeAndNil(PNG);
    end;
  end
  else
//  if (FileExt = '.BMP') then
  begin
    Result := TBitmap.Create;
    Result.PixelFormat := pf24bit;
    Result.LoadFromFile(aFileName);
  end
end;

class function TBitmapExt.CreateFromStream(Stream: TStream;
  FileExt: String): TBitmap;
var
  JPG: TJPEGImage;
  PNG: TPNGGraphic;
  TIFF: TTIFFGraphic;
begin
  FileExt := AnsiUpperCase(FileExt);
  if (FileExt = '.BMP') then
  begin
    Result := TBitmap.Create;
    Result.LoadFromStream(Stream);
  end
  else
  if (FileExt = '.JPG') or (FileExt = '.JPEG') or (FileExt = '.JPE') then
  begin
    Result := TBitmap.Create;
    Result.PixelFormat := pf24bit;
    JPG := TJPEGImage.Create;
    try
      JPG.LoadFromStream(Stream);
      Result.Assign(JPG);
    finally
      FreeAndNil(JPG);
    end;
  end
  else
  if (FileExt = '.TIFF') then
  begin
    Result := TBitmap.Create;
    Result.PixelFormat := pf24bit;
    TIFF := TTIFFGraphic.Create;
    try
      TIFF.LoadFromStream(Stream);
      Result.Assign(TIFF);
    finally
      FreeAndNil(TIFF);
    end;
  end
  else
  if (FileExt = '.PNG') then
  begin
    Result := TBitmap.Create;
    Result.PixelFormat := pf24bit;
    PNG := TPNGGraphic.Create;
    try
      PNG.LoadFromStream(Stream);
      Result.Assign(PNG);
    finally
      FreeAndNil(PNG);
    end;
  end
  else
    Result := nil;
end;

class function TBitmapExt.CreateFromStream(Stream: TStream): TBitmap;
begin
  Result := TBitmap.Create;
  Result.LoadFromStream(Stream);
end;

class function TBitmapExt.FileGetInfo(const BitmapFile: String): TBitmapInfo;
var
  BitmapInfo: PBitmapInfo;
  HeaderSize: Integer;
  Stream: TStream;
  Bmf: TBitmapFileHeader;
begin
  FillChar(Result, SizeOf(Result), 0);
  BitmapInfo := @Result;
  Stream := TFileStream.Create(BitmapFile, fmOpenRead);
  try
    Stream.ReadBuffer(Bmf, sizeof(Bmf));
    Stream.Read(HeaderSize, sizeof(HeaderSize));
    Stream.Read(Pointer(Longint(BitmapInfo) + sizeof(HeaderSize))^,
      HeaderSize - sizeof(HeaderSize));
  finally
    FreeAndNil(Stream);
  end;
end;

function TBitmapExt.IsBottomUp: Boolean;
begin
  Result := GetInfoHeader.biHeight >= 0;
end;

procedure TBitmapExt.ReplaceColor(OldColor, NewColor: TColor);
var
  I: Integer;
  J: Integer;
begin
  for I := 0 to Width - 1 do
  for J := 0 to Height - 1 do
    if Canvas.Pixels[I, J] = OldColor then
      Canvas.Pixels[I, J] := NewColor;
end;

procedure TBitmapExt.SaveToFileEx(const FileName: string; XRes, YRes: Integer);
var
  Stream: TStream;
  FileHeader: TBitmapFileHeader;
  InfoHeader: TBitmapInfoHeader;
  I: Int64;
begin
  Stream := TFileStream.Create(Filename, fmCreate);
  try
    SaveToStream(Stream);
    Stream.Position := 0;
    Stream.Read(FileHeader, SizeOf(FileHeader));
    I := Stream.Position;
    Stream.Read(InfoHeader, SizeOf(InfoHeader));
    InfoHeader.biXPelsPerMeter := XRes;
    InfoHeader.biYPelsPerMeter := YRes;
    Stream.Position := I;
    Stream.Write(InfoHeader, SizeOf(InfoHeader));
  finally
    Stream.Free;
  end;
end;

procedure TBitmapExt.SaveToJpeg(const FileName: string);
var
  Jpg: TJPEGImage;
begin
  Jpg := TJPEGImage.Create;
  try
    Jpg.Assign(Self);
    Jpg.SaveToFile(FileName);
  finally
    Jpg.Free;
  end;
end;

{ TCanvasExt }

procedure TCanvasExt.BeginClipping(const aRect: TRect);
begin
  EndClipping();
  RegionTCanvasExt := CreateRectRgn(aRect.Left, aRect.Top, aRect.Right, aRect.Bottom);
  SelectClipRgn(Self.Handle, RegionTCanvasExt);
end;

procedure TCanvasExt.DrawCrosses;
var
  I: Integer;
  J: Integer;
  X, Y: Integer;
  Sz, Sz2: Integer;
  Dx: Integer;
begin
  Sz := Round(Max(Height, Width) / 50);
  Sz2 := Sz div 2;
  Dx := Round(Max(Height, Width) / 5);
  if Sz < 5 then
    Sz := 5;
  for I := 0 to 5 do
  begin
    X := I * Dx;
    for J := 0 to 5 do
    begin
      Y := J * Dx;
      MoveTo(X - Sz2, Y);
      LineTo(X - Sz2 + Sz, Y);
      MoveTo(X, Y - Sz2);
      LineTo(X, Y - Sz2 + Sz);
    end;
  end;
  //
  X := Width - 1;
  for J := 0 to 5 do
  begin
    Y := J * Dx;
    MoveTo(X - Sz2, Y);
    LineTo(X - Sz2 + Sz, Y);
    MoveTo(X, Y - Sz2);
    LineTo(X, Y - Sz2 + Sz);
  end;
  //
  Y := Height - 1;
  for I := 0 to 5 do
  begin
    X := I * Dx;
    MoveTo(X - Sz2, Y);
    LineTo(X - Sz2 + Sz, Y);
    MoveTo(X, Y - Sz2);
    LineTo(X, Y - Sz2 + Sz);
  end;
  //
  X := Width - 1;
  MoveTo(X - Sz2, Y);
  LineTo(X - Sz2 + Sz, Y);
  MoveTo(X, Y - Sz2);
  LineTo(X, Y - Sz2 + Sz);
end;

procedure TCanvasExt.EndClipping;
begin
  SelectClipRgn(Self.Handle, HRGN(nil));
  DeleteObject(RegionTCanvasExt);
end;

end.
