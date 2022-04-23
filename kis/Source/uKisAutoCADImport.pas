unit uKisAutoCADImport;

interface

uses
  SysUtils, Classes, Dialogs,
  EzBaseGis, EzDXFRead, EzCADCtrls, EzDxfImport,
  uGC, uAutoCAD,
  uKisAppModule;

type
  TKisAutoCADImport = class(TDataModule)
    OpenDialog1: TOpenDialog;
    EzDxfImport1: TEzDxfImport;
    procedure DataModuleDestroy(Sender: TObject);
  private
    { Private declarations }
  public
    function ReadLayerFromFile(aLayerName: string; out aLayer: TEzBaseLayer): Boolean;
  end;

var
  AutoCADImport: TKisAutoCADImport;

implementation

{$R *.dfm}

{ TKisAutoCADImport }

procedure TKisAutoCADImport.DataModuleDestroy(Sender: TObject);
begin
  AutoCADImport := nil;
end;

function TKisAutoCADImport.ReadLayerFromFile(aLayerName: string; out aLayer: TEzBaseLayer): Boolean;
var
  Import: TEzDxfImport;
  I: Integer;
  DxfFileName: string;
begin
  Result := False;
  aLayer := nil;
  if not OpenDialog1.Execute() then
    Exit;
  // конвертируем файл в dxf
  DxfFileName := TAutoCADUtils.ConvertDWGtoDXF(AppModule.AppTempPath, OpenDialog1.Files[0]);
  // из dxf читаем список слоёв
  Import := TEzDxfImport.Create(Self);
  Import.FileName := DxfFileName;
  if not Import.ReadDxf() then
    Exit;
  // ищем нужный слой
  I := Import.Cad.Layers.IndexOfName(aLayerName);
  if I >= 0 then
    aLayer := Import.Cad.Layers[I];
  Result := True;
end;

end.
