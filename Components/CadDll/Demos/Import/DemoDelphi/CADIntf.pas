unit CADIntf;

interface

uses Windows, sgConsts;

const
  CADImporter = 'cad.dll';

type
  TProgressProc = function(PercentDone: Byte): Integer; stdcall;

function CADCreate(Window: HWnd; FileName: PWideChar): THandle; stdcall;
function CADClose(Handle: THandle): Integer; stdcall;
function CADGetSection(Handle: THandle; Index: Integer; Data: PcadData): THandle; stdcall;
function CADGetChild(Handle: THandle; Index: Integer; Data: PcadData): THandle; stdcall;
function CADGetData(Handle: THandle; Data: PcadData): Integer; stdcall;
function CADLayerCount(Handle: THandle): Integer; stdcall;
function CADLayer(Handle: THandle; Index: Integer; Data: PcadData): THandle; stdcall;
function CADLayoutCount(Handle: THandle): DWORD; stdcall;
function CADLayoutCurrent(Handle: THandle; var Index: DWORD; DoChange: BOOL): Integer; stdcall;
function CADLayoutName(Handle: THandle; Index: DWORD; Name: PChar; nSize: DWORD): Integer; stdcall;
function CADEnum(Handle: THandle; EnumAll: Integer; Proc: Pointer; var Param): Integer; stdcall;
function CADDraw(Handle: THandle; DC: HDC; const R: TRect): Integer; stdcall;
function CADUnits(Handle: THandle; var Units: Integer): Integer; stdcall;
function CADLTScale(Handle: THandle; var AScale: Double): Integer; stdcall;
function CADVisible(Handle: THandle; LayerName: PChar): Integer; stdcall;
function CADIs3D(Handle: THandle): Integer; stdcall;
function CADGetBox(Handle: THandle; var ALeft, ARight, ATop, ABottom: Double): Integer; stdcall;
function CADGetLastError(Buf: PChar): Integer; stdcall;
function GetLastErrorCAD(ABuf: PChar; ASize: Integer): Integer; stdcall;
function CADProhibitCurvesAsPoly(Handle: THandle; AllArcsAsCurves: Integer): Integer; stdcall;
function CADSetSplinesAccuracy(Accuracy: Integer): Integer; stdcall;
function CADSetSHXOptions(SearchSHXPaths: PChar; DefaultSHXPath: PChar; DefaultSHXFont: PChar;
                          UseSHXFonts: Boolean; UseACADPaths: Boolean): Integer; stdcall;
function SaveCADtoFileWithXMLParams(Handle: THandle; const AParam: PChar; const AProc: TProgressProc): Integer; stdcall;
function CADSetMeshQuality(Handle: THandle; const ANewValue: PDouble;
  const AOldValue: PDouble): Integer; stdcall;

function CADGetNumberOfParts(Handle: THandle;
  ASpline: PInteger; const ACircle: PInteger): Integer; stdcall;
function CADSetNumberOfParts(Handle: THandle;
  ASpline: Integer; const ACircle: Integer): Integer; stdcall;
function CADGetInsUnits(Handle: THandle;
  AInsUnits: PWORD): Integer; stdcall;
function CADGetEntityHandle(Handle: THandle; var EntityHandle: UInt64): Integer; stdcall;

implementation

function CADCreate; external CADImporter name 'CADCreate';
function CADClose; external CADImporter name 'CADClose';
function CADGetSection; external CADImporter name 'CADGetSection';
function CADGetChild; external CADImporter name 'CADGetChild';
function CADGetData; external CADImporter name 'CADGetData';
function CADLayerCount; external CADImporter name 'CADLayerCount';
function CADLayer; external CADImporter name 'CADLayer';
function CADLayoutCount; external CADImporter name 'CADLayoutCount';
function CADLayoutCurrent; external CADImporter name 'CADLayoutCurrent';
function CADLayoutName; external CADImporter name 'CADLayoutName';
function CADEnum; external CADImporter name 'CADEnum';
function CADDraw; external CADImporter name 'CADDraw';
function CADUnits; external CADImporter name 'CADUnits';
function CADLTScale; external CADImporter name 'CADLTScale';
function CADVisible; external CADImporter name 'CADVisible';
function CADIs3D; external CADImporter name 'CADIs3D';
function CADGetBox; external CADImporter name 'CADGetBox';
function CADGetLastError; external CADImporter name 'CADGetLastError';
function GetLastErrorCAD; external CADImporter name 'GetLastErrorCAD';
function CADProhibitCurvesAsPoly; external CADImporter name 'CADProhibitCurvesAsPoly';
function CADSetSplinesAccuracy; external CADImporter name 'CADSetSplinesAccuracy';
function CADSetSHXOptions; external CADImporter name 'CADSetSHXOptions';
function SaveCADtoFileWithXMLParams; external CADImporter name 'SaveCADtoFileWithXMLParams';
function CADSetMeshQuality; external CADImporter name 'CADSetMeshQuality';
function CADGetNumberOfParts; external CADImporter name 'CADGetNumberOfParts';
function CADSetNumberOfParts; external CADImporter name 'CADSetNumberOfParts';
function CADGetInsUnits; external CADImporter name 'CADGetInsUnits';
function CADGetEntityHandle; external CADImporter name 'CADGetEntityHandle';

end.
