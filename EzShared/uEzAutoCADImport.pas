unit uEzAutoCADImport;

interface

uses
  SysUtils, Classes, Dialogs, Forms,
  EzBaseGis, EzDXFRead, EzCADCtrls, EzDxfImport,
  uGC, uAutoCAD;

type
  TEzAutoCADImport = class(TDataModule)
    OpenDialog1: TOpenDialog;
    EzDxfImport1: TEzDxfImport;
    procedure DataModuleDestroy(Sender: TObject);
  private
    class var FInstance: TEzAutoCADImport;
  private
    FTempPath: string;
    FDxfFileName: string;
    procedure SetTempPath(const Value: string);
    class function GetInstance: TEzAutoCADImport; static;
  public
    function ReadFromFile(): TEzDxfImport;
    function ReadLayerFromFile(aLayerName: string; out Import: TEzDxfImport; out aLayer: TEzBaseLayer): Boolean;
    //
    property FileName: string read FDxfFileName;
    property TempPath: string read FTempPath write SetTempPath;
    //
    class property Instance: TEzAutoCADImport read GetInstance;
  end;

implementation

{$R *.dfm}

{ TKisAutoCADImport }

procedure TEzAutoCADImport.DataModuleDestroy(Sender: TObject);
begin
  FInstance := nil;
end;

class function TEzAutoCADImport.GetInstance: TEzAutoCADImport;
begin
  if FInstance = nil then
    FInstance := TEzAutoCADImport.Create(Application);
  Result := FInstance;
end;

function TEzAutoCADImport.ReadFromFile: TEzDxfImport;
var
  FileExt: string;
begin
  Result := nil;
  if not OpenDialog1.Execute() then
    Exit;
  FileExt := ExtractFileExt(OpenDialog1.Files[0]);
  FileExt := AnsiUpperCase(FileExt);
  if FileExt <> '.DXF' then
    // конвертируем файл в dxf
    FDxfFileName := TAutoCADUtils.ConvertDWGtoDXF(FTempPath, OpenDialog1.Files[0])
  else
    FDxfFilename := OpenDialog1.Files[0];
  // из dxf читаем список слоёв
  Result := TEzDxfImport.Create(Self);
  Result.FileName := FDxfFileName;
  if not Result.ReadDxf() then
  begin
    FreeAndNil(Result);
    Exit;
  end;
end;

function TEzAutoCADImport.ReadLayerFromFile(aLayerName: string; out Import: TEzDxfImport; out aLayer: TEzBaseLayer): Boolean;
var
  I: Integer;
begin
  Result := False;
  Import := nil;
  aLayer := nil;
  if not OpenDialog1.Execute() then
    Exit;
  // конвертируем файл в dxf
  FDxfFileName := TAutoCADUtils.ConvertDWGtoDXF(FTempPath, OpenDialog1.Files[0]);
  // из dxf читаем список слоёв
  Import := TEzDxfImport.Create(Self);
  Import.FileName := FDxfFileName;
  if not Import.ReadDxf() then
    Exit;
  // ищем нужный слой
  I := Import.Cad.Layers.IndexOfName(aLayerName);
  if I >= 0 then
    aLayer := Import.Cad.Layers[I];
  Result := True;
end;

procedure TEzAutoCADImport.SetTempPath(const Value: string);
begin
  FTempPath := Value;
end;

end.
