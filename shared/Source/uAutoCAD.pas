unit uAutoCAD;

interface

uses
  SysUtils, Forms,
  uFileUtils, uCommonUtils;

type
  TAutoCADUtils = class
  public
    class function ConvertDWGtoDXF(const TempPath: string; const aFileName: string): string;
  end;

implementation

{ TAutoCADUtils }

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
