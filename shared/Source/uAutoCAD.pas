unit uAutoCAD;

interface

uses
  SysUtils, Forms, Graphics, uFileUtils, uCommonUtils, uGeoUtils, uDwgFile;

type
  TAutoCADUtils = class
  public
    class procedure AddMap500Raster(const aVectorFile, aNomenclature, aRasterFileName, aGraphicFile: string);
    class function ConvertDWGtoDXF(const aFileName: string): string;
    class function ExportToBitmap(const aFilename: string; BmpWidth, BmpHeight: Integer): TBitmap;
    //
    class var
      TempPath: string;
  end;

const
  SL_MAP_BACKROUND = 'Подоснова';
  SL_MAP_LIMITS = 'Подоснова граница';

implementation

{.$DEFINE SHOW_CMD_LINE}

{ TAutoCADUtils }

class procedure TAutoCADUtils.AddMap500Raster(const aVectorFile, aNomenclature, aRasterFileName, aGraphicFile: string);
var
  N: TNomenclature;
  UtilFile: string;
  CmdLine: string;
  TempFile: string;
  Code: Cardinal;
  XYFile: string;
  XYData: string;
begin
//  raise Exception.Create('TAutoCADUtils.AddMap500Raster');
  //
  // Внимание!!! ФАйл добавляется только если в файле ещё нет подосновы.
  // Также при необходимости создаётся слой "Подоснова".ы
  UtilFile := 'MStDwgUtils.exe';
  UtilFile := TPath.Finish(ExtractFilePath(Application.ExeName), UtilFile);
  // создаём файл с координатами
  TempFile := TFileUtils.GenerateTempFileName(TempPath, aNomenclature);
  XYFile := ChangeFileExt(TempFile, '.mxy');
  TFileUtils.DeleteFile(TempFile);
  TFileUtils.DeleteFile(XYFile);
  //
  N.Init(aNomenclature, False);
  XYData := IntToStr(N.Left500) + sLineBreak + IntToStr(N.Top500);
  TFileUtils.WriteFile(XYFile, XYData);
  try
    //
    // - векторный файл
    // - название растрового файла для ImageDef
    // - растровый файл
    // - файл свойств
    CmdLine := Format('"%s" addmap "%s" "%s" "%s" "%s"', [UtilFile, aVectorFile, aRasterFileName, aGraphicFile, XYFile]);
    //
    {$IFDEF SHOW_CMD_LINE}
    ExecAndWait(UtilFile, CmdLine, False, Code);
    {$ELSE}
    ExecAndWait(UtilFile, CmdLine, True, Code);
    {$ENDIF}
  finally
    TFileUtils.DeleteFile(XYFile);
  end;
end;

class function TAutoCADUtils.ConvertDWGtoDXF(const aFileName: string): string;
var
  ConverterFile: string;
  CmdLine: string;
  TempFile: string;
  Code: Cardinal;
begin
  ConverterFile := 'MStDwgUtils.exe';
  ConverterFile := TPath.Finish(ExtractFilePath(Application.ExeName), ConverterFile);
  //
  TempFile := TFileUtils.CreateTempFile(TempPath, 'dxfconv');
  try
    Result := ChangeFileExt(TempFile, '.dxf');
  finally
    TFileUtils.DeleteFile(TempFile);
    TFileUtils.DeleteFile(Result);
  end;
  //
//  CmdLine := '"' + ConverterFile + '" todxf "' + aFileName + '" "' + Result + '"'; //+ ' f';
  CmdLine := '"' + ConverterFile + '" "' + aFileName + '" "' + Result + '"'; //+ ' f';
  //
  {$IFDEF SHOW_CMD_LINE}
  if not ExecAndWait(ConverterFile, CmdLine, False, Code) then
  {$ELSE}
  if not ExecAndWait(ConverterFile, CmdLine, True, Code) then
    Result := '';
  {$ENDIF}
end;

class function TAutoCADUtils.ExportToBitmap(const aFilename: string; BmpWidth, BmpHeight: Integer): TBitmap;
var
  DwgFile: TDwgFile;
begin
  //raise Exception.Create('TAutoCADUtils.ExportToBitmap');
  //
  Result := nil;
  DwgFile := TDwgFile.Create;
  try
    // открываем файл
    DwgFile.Open(aFilename);
    // выключаем слой растра
    DwgFile.LayerHide(SL_MAP_BACKROUND);
    // включаем слой границ растра
    DwgFile.LayerShow(SL_MAP_LIMITS);
    DwgFile.ShowLineWeights(True);
    // сохраняем в битмап
    Result := TBitmap.Create();
    try
      Result.PixelFormat := pf24bit;
      Result.SetSize(BmpWidth, BmpHeight);
      DwgFile.ExportToBitmap(Result);
    except
      FreeAndNil(Result);
      raise;
    end;
  finally
    DwgFile.Free;
  end;
end;

end.

