unit KistTestsMain;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms, Printers, ComObj,
  Dialogs, StdCtrls,
  MStDwgLib_TLB,
  EzBaseGIS,
  uGC, uCommonUtils,
  uMStImport, uMstImportFactory, uMstDialogFactory;

type
  TForm1 = class(TForm)
    Button3: TButton;
    MidMifDialog: TOpenDialog;
    Button1: TButton;
    procedure Button3Click(Sender: TObject);
    procedure Button1Click(Sender: TObject);
  private
    FImported, FErrors, FDataImported: Integer;
    procedure OnImportEntity(Sender: ImstImportLayer; const EntityNo, FileLineNo: Integer; aEntity: TEzEntity);
    procedure OnImportError(Sender: ImstImportLayer; const EntityNo, FileLineNo: Integer; aException: Exception);
    procedure OnImportData(Sender: ImstImportLayer; const EntityNo: Integer; FldValues: TStrings);
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.dfm}

const
  DRIVERVERSION = 0;
  TECHNOLOGY = 2; {Смотри windows.h для значения маски}
  HORZSIZE = 4;
  VERTSIZE = 6;
  HORZRES = 8;
  VERTRES = 10;
  BITSPIXEL = 12;
  PLANES = 14;
  NUMBRUSHES = 16;
  NUMPENS = 18;
  NUMMARKERS = 20;
  NUMFONTS = 22;
  NUMCOLORS = 24;
  PDEVICESIZE = 26;
  CURVECAPS = 28; {Смотри windows.h для значения маски}
  LINECAPS = 30; {Смотри windows.h для значения маски}
  POLYGONALCAPS = 32; {Смотри windows.h для значения маски}
  TEXTCAPS = 34; {Смотри windows.h для значения маски}
  CLIPCAPS = 36; {Смотри windows.h для значения маски}
  RASTERCAPS = 38; {Смотри windows.h для значения маски}
  ASPECTX = 40;
  ASPECTY = 42;
  ASPECTXY = 44;

  LOGPIXELSX = 88;
  LOGPIXELSY = 90;

  SIZEPALETTE = 104;
  NUMRESERVED = 106;
  COLORRES = 108;

  PHYSICALWIDTH = 110; {Смотри определение в windows.h}
  PHYSICALHEIGHT = 111; {Смотри определение в windows.h}
  PHYSICALOFFSETX = 112; {Смотри определение в windows.h}
  PHYSICALOFFSETY = 113; {Смотри определение в windows.h}
  SCALINGFACTORX = 114; {Смотри определение в windows.h}
  SCALINGFACTORY = 115; {Смотри определение в windows.h}

  DeviceCapsString: array[1..34] of string =
  ('DRIVERVERSION', 'TECHNOLOGY', 'HORZSIZE',
    'VERTSIZE', 'HORZRES', 'VERTRES',
    'BITSPIXEL', 'PLANES', 'NUMBRUSHES',
    'NUMPENS', 'NUMMARKERS', 'NUMFONTS',
    'NUMCOLORS', 'PDEVICESIZE', 'CURVECAPS',
    'LINECAPS', 'POLYGONALCAPS', 'TEXTCAPS',
    'CLIPCAPS', 'RASTERCAPS', 'ASPECTX',
    'ASPECTY', 'ASPECTXY', 'LOGPIXELSX',
    'LOGPIXELSY', 'SIZEPALETTE', 'NUMRESERVED',
    'COLORRES', 'PHYSICALWIDTH', 'PHYSICALHEIGHT',
    'PHYSICALOFFSETX', 'PHYSICALOFFSETY', 'SCALINGFACTORX',
    'SCALINGFACTORY');

  DeviceCapsIndex: array[1..34] of INTEGER =
  (0, 2, 4, 6, 8, 10, 12, 14, 16, 18,
    20, 22, 24, 26, 28, 30, 32, 34, 36, 38,
    40, 42, 44, 88, 90, 104, 106, 108, 110, 111,
    112, 113, 114, 115);

//type
//  TFakeFolders = class(TInterfacedObject, IKisFolders)
//  private
//    function MapScansPath(): string;
//    function MapScansTempPath(): string;
//    function ReportsPath(): string;
//    function SQLLogPath(): string;
//    function AppTempPath(): string;
//    function ThreadCount: Byte;
//  end;

{ TFakeFolders }

//function TFakeFolders.AppTempPath: string;
//begin
//  Result := 'c:\Projects\kis\kis\Data\In\DB\temp\';
//end;
//
//function TFakeFolders.MapScansPath: string;
//begin
//  Result := 'c:\Projects\kis\kis\Data\In\DB\';
//end;
//
//function TFakeFolders.MapScansTempPath: string;
//begin
//  raise Exception.Create('TFakeFolders.MapScansTempPath');
//end;
//
//function TFakeFolders.ReportsPath: string;
//begin
//  raise Exception.Create('TFakeFolders.ReportsPath');
//end;
//
//function TFakeFolders.SQLLogPath: string;
//begin
//  raise Exception.Create('TFakeFolders.SQLLogPath');
//end;
//
//function TFakeFolders.ThreadCount: Byte;
//begin
//  Result := 4; 
//end;

function jPosition(const j: INTEGER): INTEGER;
begin
  RESULT := Integer(j * LongInt(Printer.PageHeight) div 1000)
end;

procedure TForm1.Button1Click(Sender: TObject);
var
  Convert: IDwgConvert;
  I: Cardinal;
begin
  //Convert := CoDwgConvert.Create;
  //Convert.SaveToDXF('c:\temp\in\DWG\948-ГП_v1.dwg', 'c:\temp\in\DWG\948-ГП_v1.dxf');
  ExecAndWait('MStDwgUtils.exe', 'MStDwgUtils.exe c:\temp\in\DWG\948-ГП_v1.dwg c:\temp\in\DWG\948-ГП_v1.dxf', I);
end;

procedure TForm1.Button3Click(Sender: TObject);
var
  Import: ImstImportLayer;
  Dialog: ImstImportLayerDialog;
begin
  // выбираем файл
  if not MidMifDialog.Execute() then
    Exit;
  // создаём объект для импорта
  Import := TmstImportFactory.NewLayerImport(importMifMid);
  // читаем заголовок
  Import.ReadHeader(MidMifDialog.Files[0], nil);
  // показываем информацию
  Dialog := TmstDialogFactory.NewImportLayerDialog();
  if Dialog.Execute(Import) then
  begin
    FErrors := 0;
    FImported := 0;
    Import.OnImport := OnImportEntity;
    Import.OnImportError := OnImportError;
    Import.OnImportData := OnImportData;
    // импортируем, если всё ОК
    Import.DoImport(Dialog.Settings);
    ShowMessage(Format('Ошибок: %d. Импорт: %d. Всего: %d.', [FErrors, FImported, FImported + FErrors]));
  end;
end;

procedure TForm1.OnImportData(Sender: ImstImportLayer; const EntityNo: Integer; FldValues: TStrings);
begin
  Inc(FDataImported);
end;

procedure TForm1.OnImportEntity(Sender: ImstImportLayer; const EntityNo, FileLineNo: Integer; aEntity: TEzEntity);
begin
  Inc(FImported);
end;

procedure TForm1.OnImportError(Sender: ImstImportLayer; const EntityNo, FileLineNo: Integer; aException: Exception);
begin
  Inc(FErrors);
end;

end.
