unit uAutoCAD;

interface

uses
  SysUtils, Forms,
  uFileUtils, uCommonUtils;

type
  TAutoCADUtils = class
  public
    class function ConvertDWGtoDXF(const TempPath: string; const aFileName: string): string;
    //
    class function AddMap500Raster(const aVectorFile, aNomenclature, aRasterFile: string): Boolean;
  end;

implementation

{ TAutoCADUtils }

class function TAutoCADUtils.AddMap500Raster(const aVectorFile, aNomenclature, aRasterFile: string): Boolean;
var
  Dwg: IDwgFile;
  N: TNomenclature;
begin
  raise Exception.Create('TAutoCADUtils.AddMap500Raster');
  //
  // создаём COM-объект
  Dwg := CreateDwgFile();
  // открываем файл
  Dwg.Open(aVectorFile);
  // добавляем растр
  N.Init(aNomenclature);
  Dwg.AddRaster(LayerName, aRasterFile, N.Bounds);
  // сохраняем
  Dwg.Save(aVectorFile);
end;

class function TAutoCADUtils.ConvertDWGtoDXF(const TempPath: string; const aFileName: string): string;
var
  ConverterFile: string;
  CmdLine: string;
  TempFile: string;
  Code: Cardinal;
begin
  ConverterFile := 'MStDwgUtils.exe';
  ConverterFile := TPath.Finish(ExtractFilePath(Application.ExeName), ConverterFile);
  //
  TempFile := TFileUtils.CreateTempFile(TempPath, 'report');
  try
    Result := ChangeFileExt(TempFile, '.dxf');
  finally
    TFileUtils.DeleteFile(TempFile);
    TFileUtils.DeleteFile(Result);
  end;
  //
  CmdLine := '"' + ConverterFile + '" "' + aFileName + '" "' + Result + '"'; //+ ' f';
  //
  ExecAndWait(ConverterFile, CmdLine, True, Code);
end;

end.
