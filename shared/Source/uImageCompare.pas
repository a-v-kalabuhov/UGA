{*******************************************************}
{                                                       }
{       "ИС МП УГА"                                     }
{       Сранение картинок                               }
{                                                       }
{       Автор: Калабухов А.В.                           }
{                                                       }
{*******************************************************}
unit uImageCompare;

interface

uses
  SysUtils, Forms, Windows, Graphics, Math, Classes;

type
  IImageCompare = interface
    ['{DA012D43-2EFA-4D1A-9BC8-27E12D608FE5}']
    function Compare(const File1, File2, ResultFile: String; var Area, Strength: Integer): Boolean;
//    function Compare2(const File1, File2: String; var aResult: TBitmap; var Area, Strength: Integer): Boolean;
    function Compare3(const File1, File2: String; const Bmp1, Bmp2: TBitmap;
      var aResult: TBitmap; var Area, Strength: Integer): Boolean;
  end;

  TImageCompareAlgorythm = (icaKalabuhov, icaCompareExe);

  TImageCompareFactory = class
  public
    class function CreateImageCompare(Algorythm: TImageCompareAlgorythm): IImageCompare;
  end;

implementation

uses
  uGC;

type
  TStdCompare = class(TInterfacedObject, IImageCompare)
  private
    function Compare(const File1, File2, ResultFile: String; var Area, Strength: Integer): Boolean;
    function Compare2(const File1, File2: String; var aResult: TBitmap; var Area, Strength: Integer): Boolean;
    function Compare3(const File1, File2: String; const Bmp1, Bmp2: TBitmap; var aResult: TBitmap; var Area, Strength: Integer): Boolean;
  end;

  TImageMagickExeCompare = class(TInterfacedObject, IImageCompare)
  private
    function Compare(const File1, File2, ResultFile: String; var Area, Strength: Integer): Boolean;
    function Compare2(const File1, File2: String; var aResult: TBitmap; var Area, Strength: Integer): Boolean; virtual; abstract;
    function Compare3(const File1, File2: String; const Bmp1, Bmp2: TBitmap; var aResult: TBitmap; var Area, Strength: Integer): Boolean; virtual; abstract;
  end;

{ TImageCompareFactory }

class function TImageCompareFactory.CreateImageCompare(
  Algorythm: TImageCompareAlgorythm): IImageCompare;
begin
  case Algorythm of
    icaKalabuhov:
      begin
        Result := TStdCompare.Create;
      end;
    icaCompareExe:
      begin
        Result := TImageMagickExeCompare.Create;
      end;
    else
      Result := nil;
  end;
end;

{ TImageMagickExeCompare }

function TImageMagickExeCompare.Compare(const File1, File2, ResultFile: String;
  var Area, Strength: Integer): Boolean;
var
  AppToRun: string;
  CommandLine: string;
  StartUpInfo: TStartUpInfo; //параметры будущего процесса
  ProcessInfo: TProcessInformation; //Отслеживание выполнения
  aExitCode: Cardinal;
begin
  Area := -1;
  Strength := -1;
  //
  AppToRun := ExtractFilePath(Application.ExeName) + 'compare.exe';
  CommandLine := '-compose src "' + File1 + '" "' + File2 + '" "' + ResultFile + '"';
  //
  FillChar(StartUpInfo, SizeOf(TStartUpInfo), 0);
  with StartUpInfo do
  begin
    cb := SizeOf(TStartUpInfo);
    dwFlags := STARTF_USESHOWWINDOW;
    wShowWindow := SW_HIDE;//SW_SHOWNORMAL;
  end;
  Result := CreateProcess(PChar(AppToRun), PChar(CommandLine), nil, nil, false,
    NORMAL_PRIORITY_CLASS, nil, nil, StartUpInfo, ProcessInfo);
  if Result then
  begin
    //Ждем завершения инициализации.
    WaitForInputIdle(ProcessInfo.hProcess, INFINITE);
    //Ждем завершения процесса.
    WaitforSingleObject(ProcessInfo.hProcess, INFINITE);
    //Получаем код завершения.
    GetExitCodeProcess(ProcessInfo.hProcess, aExitCode);
    //Закрываем дескриптор процесса.
    CloseHandle(ProcessInfo.hThread);
    //Закрываем дескриптор потока.
    CloseHandle(ProcessInfo.hProcess);
  end;
end;

{ TStdCompare }

function TStdCompare.Compare(const File1, File2, ResultFile: String; var Area,
  Strength: Integer): Boolean;
var
  Bmp1: TBitmap;
begin
  Bmp1 := TBitmap.Create;
  try
    Bmp1.PixelFormat := pf24bit;
    Result := Compare2(File1, File2, Bmp1, Area, Strength);
    Bmp1.SaveToFile(ResultFile);
  finally
    FreeAndNil(Bmp1);
  end;
end;

function TStdCompare.Compare2(const File1, File2: String; var aResult: TBitmap;
  var Area, Strength: Integer): Boolean;
var
  Bmp1, Bmp2: TBitmap;
begin
  Area := -1;
  Strength := -1;
  //
  Bmp1 := TBitmap.Create;
  Bmp2 := TBitmap.Create;
  try
    Bmp1.PixelFormat := pf24bit;
    Bmp2.PixelFormat := pf24bit;
    Result := Compare3(File1, File2, Bmp1, Bmp2, aResult, Area, Strength);
    Result := True;
  finally
    FreeAndNil(Bmp2);
    FreeAndNil(Bmp1);
  end;
end;

function TStdCompare.Compare3(const File1, File2: String;
  const Bmp1, Bmp2: TBitmap; var aResult: TBitmap;
  var Area, Strength: Integer): Boolean;
var
  MaxX, MinX, MaxY, MinY, X, Y, Y1: Integer;
  SValue, SCount: Integer;
  ScanLine1, ScanLine2: PByteArray;
  R1, G1, B1, R2, G2, B2, Clr: Byte;
  Idx, Delta, SizeChange: Integer;
  Bmp1BottomUp, Bmp2BottomUp: Boolean;
begin
  Result := False;
  Area := -1;
  Strength := -1;
  //
  if not Assigned(aResult) then
  begin
    aResult := TBitmap.Create;
    aResult.PixelFormat := pf24bit;
  end;
  //
//  Bmp1BottomUp := BitmapIsBottomUp(File1);
//  Bmp2BottomUp := BitmapIsBottomUp(File2);
  Bmp1BottomUp := False;
  Bmp2BottomUp := False;
  aResult.Assign(Bmp1);
  aResult.PixelFormat := pf24bit;
  Bmp2.PixelFormat := pf24bit;
  //
  MaxX := Max(aResult.Width, Bmp2.Width);
  MinX := Min(aResult.Width, Bmp2.Width);
  MaxY := Max(aResult.Height, Bmp2.Height);
  MinY := Min(aResult.Height, Bmp2.Height);
  //
  SizeChange := Abs(aResult.Width * aResult.Height - Bmp2.Width * Bmp2.Height);
  Area := SizeChange;
  //
  aResult.SetSize(MaxX, MaxY);
  aResult.Canvas.Brush.Style := bsSolid;
  aResult.Canvas.Pen.Style := psSolid;
  aResult.Canvas.Brush.Color := clRed;
  aResult.Canvas.Pen.Color := clRed;
  aResult.Canvas.Rectangle(MinX, 0, MaxX, MaxY);
  aResult.Canvas.Rectangle(0, MinY, MaxX, MaxY);
  //
  Strength := 0;
  SValue := 0;
  SCount := 0;
  for Y := 0 to MinY - 1 do
  begin
    if Bmp1BottomUp then
      Y1 := MinY - 1 - Y
    else
      Y1 := Y;
    ScanLine1 := aResult.ScanLine[Y1];
    if Bmp2BottomUp then
      Y1 := MinY - 1 - Y
    else
      Y1 := Y;
    ScanLine2 := Bmp2.ScanLine[Y1];
    //
    for X := 0 to MinX - 1 do
    begin
      Idx := X * 3;
      R1 := ScanLine1[Idx];
      G1 := ScanLine1[Idx + 1];
      B1 := ScanLine1[Idx + 2];
      R2 := ScanLine2[Idx];
      G2 := ScanLine2[Idx + 1];
      B2 := ScanLine2[Idx + 2];
      //
      if (R1 <> R2) or (B1 <> B2) or (G1 <> G2) then
      begin
        Inc(SCount);
        Delta := Abs(R1 - R2) + Abs(G1 - G2) + Abs(B1 - B2);
        Clr := Trunc(Delta / 3);
        SValue := SValue + Clr;
        Clr := 255 - Clr;
        ScanLine1[Idx] := Clr;
        ScanLine1[Idx + 1] := Clr;
        ScanLine1[Idx + 2] := 255;
      end
      else
      begin
        ScanLine1[Idx] := 255;
        ScanLine1[Idx + 1] := 255;
        ScanLine1[Idx + 2] := 255;
      end;
    end;
  end;
  //
  Area := Area + SCount;
  if SCount = 0 then
    Strength := 0
  else
    Strength := Trunc(SValue / SCount / 255 * 100); // %
  //
  Result := True;
end;

end.
