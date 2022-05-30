{************************************************************}
{                                                            }
{                                                            }
{          CAD Image DLL version  function definitions       }
{                                                            }
{      Copyright (c) 2002-2004 SoftGold software company     }
{                                                            }
{************************************************************}

unit sgcadimage;

interface

uses Windows, SysUtils, Classes, Graphics, sgConsts;

const
  CADImage = cnstCADImageLibName;

type
  TProgressProc = function(PercentDone: Byte): Integer; stdcall;

  PsgCADExportParams = ^TsgCADExportParams;
  TsgCADExportParams = packed record
    XScale: Double;
    Units: Byte; //TsgHPGLUnits;
    ProgressFunc: TProgressProc;
//    BackgroundColor: TColor;
//    DefaultColor: TColor;
  end;

  PCADDraw = ^TCADDraw;
  TCADDraw = packed record
    Size: DWORD;
    DC: HDC;
    R: TRect;
    DrawMode: Byte;
  end;


  PsgImageParam = ^TsgImageParam;
  TsgImageParam = packed record
    Heigth: Integer;
    Width: Integer;
    PixelFormat: TPixelFormat;
  end;  

{ use with CreateCADEx
const
  CAD_BASE = $8001;
  CAD_PROGRESS = CAD_BASE + 0;

type
  PCADProgress = ^TCADProgress;
  TCADProgress = packed record
    CADHandle: THandle;
    Stage: Byte;
    PercentDone: Byte;
    RedrawNow: Boolean;
    R: TRect;
    Msg: PWideChar;
  end;
}

{$IFNDEF CS_STATIC_DLL}
  TCADAddXRef = function (AImage, AXrefImage: THandle; AName: PWideChar;
    const Position, Scale: TFPoint;
    const Rotation: Double; ResultInsert: PHandle): Integer; stdcall;
  TCADLayer = function(Handle: THandle; Index: DWORD;
    Data: PcadData): THandle; stdcall;
  TCADLayerCount = function(Handle: THandle): DWORD; stdcall;
  TCADLayerVisible = function(Handle: THandle; Visible: Integer): Integer; stdcall;
  TCADLayout = function(Handle: THandle; Index: DWORD): THandle; stdcall;
  TCADLayoutName = function(Handle: THandle; Index: DWORD; Name: PWideChar; nSize: DWORD): Integer; stdcall;
  TCADLayoutsCount = function(Handle: THandle): DWORD; stdcall;
  TCADLayoutVisible = function(Handle: THandle; Index: DWORD; DoSetVisible, NewValue: BOOL): BOOL; stdcall;
  TCurrentLayoutCAD = function(Handle: THandle; Index: DWORD; DoChange: BOOL): THandle; stdcall;
  TCADLTScale = function(Handle: THandle; var AScale: Double): Integer; stdcall;
  TCADSetSHXOptions = function(SearchSHXPaths, DefaultSHXPath,
    DefaultSHXFont: PChar; UseSHXFonts, UseACADPaths: BOOL): Integer; stdcall;
  TCADVisible = function(Handle: THandle; LayerName: PWideChar): Integer; stdcall;
  TCloseCAD = function(Handle: THandle): Integer; stdcall;
  TCreateCAD = function(Window: HWnd; FileName: PWideChar): THandle; stdcall;
  TCreateCADEx = function(Window: HWnd; FileName, Param: PWideChar): THandle; stdcall;
  TDefaultLayoutIndex = function(Handle: THandle): Integer; stdcall;
  TDrawCAD = function(Handle: THandle; DC: HDC;
    const R: TRect): Integer; stdcall;
  TDrawCADEx = function(Handle: THandle; const CADDraw: TCADDraw): Integer; stdcall;
  TDrawCADtoBitmap = function(Handle: THandle; const CADDraw: TCADDraw): THandle; stdcall;
  TDrawCADtoDIB = function(Handle: THandle; const R: TRect): THandle; stdcall;
  TDrawCADtoGif = function(Handle: THandle; const CADDraw: TCADDraw): THandle; stdcall;
  TDrawCADtoJpeg = function(Handle: THandle; const CADDraw: TCADDraw): THandle; stdcall;
  TGetBoxCAD = function(Handle: THandle; var AbsWidth, AbsHeight: Single): Integer; stdcall;
  TGetExtentsCAD = function(Handle: THandle; var ARect: TFRect): Integer; stdcall;
  TGetIs3dCAD = function(Handle: THandle; var AIs3D: Integer): Integer; stdcall;
  TGetLastErrorCAD = function(Buf: PWideChar; nSize: DWORD): Integer; stdcall;
  TGetPlugInInfo = function(Version: PAnsiChar; Formats: PAnsiChar): Integer; cdecl;
  TGetCADCoords = function(Handle: THandle; const AXScaled, AYScaled: Single; var Coord: TFPoint): Integer; stdcall;
  TGetNearestEntity = function(Handle: THandle; Buf: PWideChar; nSize: DWORD; const R: TRect; var APoint: TPoint): Integer; stdcall;
  TGetNearestEntityWCS = function(Handle: THandle; Buf: PWideChar; nSize: DWORD; const R: TRect; var APoint2D: TPoint; var APoint3D: TFPoint): Integer; stdcall;
  TGetPointCAD = function(Handle: THandle; var APoint: TFPoint): Integer; stdcall;
  TReadCAD = function(FileName: PWideChar; ErrorText: PWideChar): THandle; cdecl;
  TResetDrawingBoxCAD = function(Handle: THandle): Integer; stdcall;
  TSaveCADtoBitmap = function(Handle: THandle; const CADDraw: TCADDraw; FileName: PWideChar): Integer; stdcall;
  TSaveCADtoCAD = function(Handle: THandle; AParam: PsgCADExportParams; FileName: PWideChar): Integer; stdcall;
  TSaveCADtoJpeg = function(Handle: THandle; const CADDraw: TCADDraw; FileName: PWideChar): Integer; stdcall;
  TSaveCADtoGif = function(Handle: THandle; const CADDraw: TCADDraw; FileName: PWideChar): Integer; stdcall;
  TSaveCADtoPNG = function(Handle: THandle; const CADDraw: TCADDraw; FileName: PWideChar): Integer; stdcall;
  TSaveCADtoFile = function(Handle: THandle; const CADDraw: TCADDraw; FileName: PWideChar; ImageParam: PsgImageParam): Integer; stdcall;
  TSetBlackWhite = function(Handle: THandle; CMode: Integer): DWORD; stdcall;
  TSetBMSize = function(Value: Integer): BOOL; cdecl;
  TSetCADBorderType = function(Handle: THandle; const ABorderType: Integer): Integer; stdcall;
  TSetCADBorderSize = function(Handle: THandle; const ABorderSize: Double): Integer; stdcall;
  TSetDefaultColor = function(Handle: THandle; const ADefaultColor: Integer): Integer; stdcall;
  TSetDrawingBoxCAD = function(Handle: THandle; const ABox: TFRect): Integer; stdcall;
  TSetProcessMessagesCAD = function(Handle: THandle; const AIsProcess: Integer): Integer; stdcall;
  TSetProgressProc = function(AProgressProc: TProgressProc): Integer; stdcall;
  TSetRotateCAD = function(Handle: THandle; const AAngle: Single;
    const AAxis: Integer): Integer; stdcall;
  TStopLoading = function: Integer; stdcall;
  TGetSupportedExts = function (ASupportedExts: PWideChar; ALength: PInteger): Integer; stdcall;
  TStRgW = function(AUser, AEMail, AKey: PWideChar): Integer; stdcall;
  TStRgA = function (AUser, AEMail, AKey: PAnsiChar): Integer; stdcall;
  TStRg = function (AUser, AEMail, AKey: PAnsiChar): Integer; stdcall;
  TSetShowLineWeightCAD = function (hObject: THandle; AIsShow: Integer): Integer; stdcall;
  TSaveCADtoFileWithXMLParams = function(Handle: THandle; const AParam: PWideChar;
    const AProc: TProgressProc): Integer; stdcall;
  TSaveCADWithXMLParametrs = function(Handle: THandle; const AParam: PWideChar): Integer; stdcall;
  TProcessXML = function(AHandle: THandle; const AInputXML: PChar;
    var AOutputXML: Variant): Integer; stdcall;
  TCADSetViewPort = function(Handle: THandle; Left, Top, Width, Height: Integer): Integer; stdcall;
  TCADGetAutoRegenMode = function(Handle: THandle): Integer; stdcall;
  TCADSetAutoRegenMode = function(Handle: THandle; AMode: Integer): Integer; stdcall;
  TCADGetNumberOfParts = function(Handle: THandle; ASpline: PInteger; const ACircle: PInteger): Integer; stdcall;
  TCADSetNumberOfParts = function(Handle: THandle; ASpline: Integer; const ACircle: Integer): Integer; stdcall;

var
  CADImageInst: THandle = 0;
  CADAddXRef: TCADAddXRef = nil;
  CADLayer: TCADLayer = nil;
  CADLayerCount: TCADLayerCount = nil;
  CADLayerVisible: TCADLayerVisible = nil;
  CADLayoutsCount: TCADLayoutsCount = nil;
  CADLayoutName: TCADLayoutName = nil;
  CADLayout: TCADLayout = nil;
  CloseCAD: TCloseCAD = nil;
  CreateCAD: TCreateCAD = nil;
  CurrentLayoutCAD: TCurrentLayoutCAD = nil;
  DefaultLayoutIndex: TDefaultLayoutIndex = nil;
  DrawCAD: TDrawCAD = nil;
  DrawCADEx: TDrawCADEx = nil;
  GetBoxCAD: TGetBoxCAD = nil;
  GetCADCoords: TGetCADCoords = nil;
  GetExtentsCAD: TGetExtentsCAD = nil;
  GetIs3dCAD: TGetIs3dCAD = nil;
  GetLastErrorCAD: TGetLastErrorCAD = nil;
  GetNearestEntity: TGetNearestEntity = nil;
  GetNearestEntityWCS: TGetNearestEntityWCS = nil;
  GetPlugInInfo: TGetPlugInInfo = nil;
  ResetDrawingBoxCAD: TResetDrawingBoxCAD = nil;
  SaveCADtoBitmap: TSaveCADtoBitmap = nil;
  SaveCADtoCAD: TSaveCADtoCAD = nil;
  SaveCADtoGif: TSaveCADtoGif = nil;
  SaveCADtoJpeg: TSaveCADtoJpeg = nil;
  SaveCADtoPNG: TSaveCADtoPNG = nil;
  SaveCadtoFile: TSaveCADtoFile = nil;
  SetBlackWhite: TSetBlackWhite = nil;
  SetCADBorderType: TSetCADBorderType = nil;
  SetCADBorderSize: TSetCADBorderSize = nil;
  SetDefaultColor: TSetDefaultColor = nil;
  SetDrawingBoxCAD: TSetDrawingBoxCAD = nil;
  SetProcessMessagesCAD: TSetProcessMessagesCAD = nil;
  SetProgressProc: TSetProgressProc= nil;
  StopLoading: TStopLoading = nil;
  GetSupportedExts: TGetSupportedExts = nil;
  StRgW: TStRgW = nil;
  StRgA: TStRgA = nil;
  StRg: TStRg = nil;
  SetShowLineWeightCAD: TSetShowLineWeightCAD = nil;
  SaveCADtoFileWithXMLParams: TSaveCADtoFileWithXMLParams = nil;
  SaveCADWithXMLParametrs: TSaveCADWithXMLParametrs = nil;
  ProcessXML: TProcessXML = nil;
  CADSetSHXOptions: TCADSetSHXOptions = nil;
  CADSetViewPort: TCADSetViewPort = nil;
  CADGetAutoRegenMode: TCADGetAutoRegenMode = nil;
  CADSetAutoRegenMode: TCADSetAutoRegenMode = nil;
  CADGetNumberOfParts: TCADGetNumberOfParts = nil;
  CADSetNumberOfParts: TCADSetNumberOfParts = nil;
{$ELSE}
  function CADAddXRef(AImage, AXrefImage: THandle; AName: PWideChar;
    const Position, Scale: TFPoint;
    const Rotation: Double; ResultInsert: PHandle): Integer; stdcall; external CADImage name 'CADAddXRef';
  function CADLayer(Handle: THandle; Index: DWORD;
    Data: PcadData): THandle; stdcall; external CADImage name 'CADLayer';
  function CADLayerCount(Handle: THandle): DWORD; stdcall;
    external CADImage name 'CADLayerCount';
  function CADLayerVisible(Handle: THandle;
    Visible: Integer): Integer; stdcall; external CADImage name 'CADLayerVisible';
  function CADLayout(Handle: THandle; Index: DWORD): THandle; stdcall;
    external CADImage name 'CADLayout';
  function CADLayoutName(Handle: THandle; Index: DWORD; Name: PWideChar; nSize: DWORD): Integer; stdcall;
    external CADImage name 'CADLayoutName';
  function CADLayoutsCount(Handle: THandle): DWORD; stdcall;
    external CADImage name 'CADLayoutsCount';
  function CADLayoutVisible(Handle: THandle; Index: DWORD; DoSetVisible, NewValue: BOOL): BOOL; stdcall;
    external CADImage name 'CADLayoutVisible';
  function CurrentLayoutCAD(Handle: THandle; Index: DWORD; DoChange: BOOL): THandle; stdcall;
    external CADImage name 'CurrentLayoutCAD';
  function CADLTScale(Handle: THandle; var AScale: Double): Integer; stdcall;
    external CADImage name 'CADLTScale';
  function CloseCAD(Handle: THandle): Integer; stdcall;
    external CADImage name 'CloseCAD';
  function CADSetSHXOptions(SearchSHXPaths, DefaultSHXPath, DefaultSHXFont: PChar; UseSHXFonts,
    UseACADPaths: BOOL): Integer; stdcall; external CADImage name 'CADSetSHXOptions';
  function CADVisible(Handle: THandle; LayerName: PWideChar): Integer; stdcall;
    external CADImage name 'CADVisible';
  function CreateCAD(Window: HWnd; FileName: PWideChar): THandle; stdcall;
    external CADImage name 'CreateCAD';
  function CreateCADEx(Window: HWnd; FileName, Param: PWideChar): THandle; stdcall;
    external CADImage name 'CreateCADEx';
  function DefaultLayoutIndex(Handle: THandle): Integer; stdcall;
    external CADImage name 'DefaultLayoutIndex';
  function DrawCAD(Handle: THandle; DC: HDC; const R: TRect): Integer; stdcall;
    external CADImage name 'DrawCAD';
  function DrawCADEx(Handle: THandle; const CADDraw: TCADDraw): Integer; stdcall;
    external CADImage name 'DrawCADEx';
  function DrawCADtoBitmap(Handle: THandle; const CADDraw: TCADDraw): THandle; stdcall;
    external CADImage name 'DrawCADtoBitmap';
  function DrawCADtoDIB(Handle: THandle; const R: TRect): THandle; stdcall;
    external CADImage name 'DrawCADtoDIB';
  function DrawCADtoGif(Handle: THandle; const CADDraw: TCADDraw): THandle; stdcall;
    external CADImage name 'DrawCADtoGif';
  function DrawCADtoJpeg(Handle: THandle; const CADDraw: TCADDraw): THandle; stdcall;
    external CADImage name 'DrawCADtoJpeg';
  function GetBoxCAD(Handle: THandle; var AbsWidth, AbsHeight: Single): Integer; stdcall;
    external CADImage name 'GetBoxCAD';
  function GetCADCoords(Handle: THandle; const AXScaled, AYScaled: Single; var Coord: TFPoint): Integer; stdcall;
    external CADImage name 'GetCADCoords';
  function GetExtentsCAD(Handle: THandle; var ARect: TFRect): Integer; stdcall;
    external CADImage name 'GetExtentsCAD';
  function GetIs3dCAD(Handle: THandle; var AIs3D: Integer): Integer; stdcall;
    external CADImage name 'GetIs3dCAD';
  function GetLastErrorCAD(Buf: PWideChar; nSize: DWORD): Integer; stdcall;
    external CADImage name 'GetLastErrorCAD';
  function GetPlugInInfo(Version: PAnsiChar; Formats: PAnsiChar): Integer; cdecl;
    external CADImage name 'GetPlugInInfo';
  function GetNearestEntity(Handle: THandle; Buf: PWideChar; nSize: DWORD; const R: TRect; var APoint: TPoint): Integer; stdcall;
    external CADImage name 'GetNearestEntity';
  function GetNearestEntityWCS(Handle: THandle; Buf: PWideChar; nSize: DWORD; const R: TRect; var APoint2D: TPoint; var APoint3D: TFPoint): Integer; stdcall;
    external CADImage name 'GetNearestEntityWCS';
  function GetPointCAD(Handle: THandle; var APoint: TFPoint): Integer; stdcall;
    external CADImage name 'GetPointCAD';
  function ReadCAD(FileName: PWideChar; ErrorText: PWideChar): THandle; cdecl;
    external CADImage name 'ReadCAD';
  function ResetDrawingBoxCAD(Handle: THandle): Integer; stdcall;
    external CADImage name 'ResetDrawingBoxCAD';
  function SaveCADtoBitmap(Handle: THandle; const CADDraw: TCADDraw; FileName: PWideChar): Integer; stdcall;
    external CADImage name 'SaveCADtoBitmap';
  function SaveCADtoJpeg(Handle: THandle; const CADDraw: TCADDraw; FileName: PWideChar): Integer; stdcall;
    external CADImage name 'SaveCADtoJpeg';
  function SaveCADtoCAD(Handle: THandle; AParam: PsgCADExportParams; FileName: PWideChar): Integer; stdcall;
    external CADImage name 'SaveCADtoCAD';
  function SaveCADtoGif(Handle: THandle; const CADDraw: TCADDraw; FileName: PWideChar): Integer; stdcall;
    external CADImage name 'SaveCADtoGif';
  function SaveCADtoPNG(Handle: THandle; const CADDraw: TCADDraw; FileName: PWideChar): Integer; stdcall;
    external CADImage name 'SaveCADtoPNG';
  function SaveCADtoFile(Handle: THandle; const CADDraw: TCADDraw; FileName: PWideChar; ImageParam: PsgImageParam): Integer; stdcall;
    external CADImage name 'SaveCADtoFile';
  function SetBMSize(Value: Integer): BOOL; cdecl;
    external CADImage name 'SetBMSize';
  function SetCADBorderType(Handle: THandle; const ABorderType: Integer): Integer; stdcall;
    external CADImage name 'SetCADBorderType';
  function SetCADBorderSize(Handle: THandle; const ABorderSize: Double): Integer; stdcall;
    external CADImage name 'SetCADBorderSize';
  function SetDefaultColor(Handle: THandle; const ADefaultColor: Integer): Integer; stdcall;
    external CADImage name 'SetDefaultColor';
  function SetDrawingBoxCAD(Handle: THandle; const ABox: TFRect): Integer; stdcall;
    external CADImage name 'SetDrawingBoxCAD';
  function SetProcessMessagesCAD(Handle: THandle; const AIsProcess: Integer): Integer; stdcall;
    external CADImage name 'SetProcessMessagesCAD';
  function SetRotateCAD(Handle: THandle; const AAngle: Single; const AAxis: Integer): Integer; stdcall;
    external CADImage name 'SetRotateCAD';
  function SetBlackWhite(Handle: THandle; CMode: Integer): Integer; stdcall;
    external CADImage name 'SetBlackWhite';
  function SetProgressProc(AProgressProc: TProgressProc): Integer; stdcall;
    external CADImage name 'SetProgressProc';
  function StopLoading: Integer; stdcall;
    external CADImage name 'StopLoading';
  function GetSupportedExts(ASupportedExts: PWideChar; ALength: PInteger): Integer; stdcall;
    external CADImage name 'GetSupportedExts';

  function StRgW(AUser, AEMail, AKey: PWideChar): Integer; stdcall;
    external CADImage name 'StRgW';
  function StRgA(AUser, AEMail, AKey: PAnsiChar): Integer; stdcall;
    external CADImage name 'StRgA';
  function StRg(AUser, AEMail, AKey: PAnsiChar): Integer; stdcall;
    external CADImage name 'StRg';

  function SetShowLineWeightCAD(hObject: THandle; AIsShow: Integer): Integer; stdcall; external CADImage name 'SetShowLineWeightCAD';


  function SaveCADtoFileWithXMLParams(Handle: THandle; const AParam: PWideChar; const AProc: TProgressProc): Integer; stdcall;
    external CADImage name 'SaveCADtoFileWithXMLParams';
  function SaveCADWithXMLParametrs(Handle: THandle; const AParam: PWideChar): Integer; stdcall;
    external CADImage name 'SaveCADWithXMLParametrs';

  function ProcessXML(AHandle: THandle; const AInputXML: PChar;
    var AOutputXML: Variant): Integer; stdcall; external CADImage name 'ProcessXML';

  function CADSetViewPort(Handle: THandle; Left, Top, Width, Height: Integer): Integer; stdcall; external CADImage name 'CADSetViewPort';

  function CADGetAutoRegenMode(Handle: THandle): Integer; stdcall; external CADImage name 'CADGetAutoRegenMode';
  function CADSetAutoRegenMode(Handle: THandle; AMode: Integer): Integer; stdcall; external CADImage name 'CADSetAutoRegenMode';

  function CADGetNumberOfParts(Handle: THandle; ASpline: PInteger; const ACircle: PInteger): Integer; stdcall; external CADImage name 'CADGetNumberOfParts';
  function CADSetNumberOfParts(Handle: THandle; ASpline: Integer; const ACircle: Integer): Integer; stdcall; external CADImage name 'CADSetNumberOfParts';
{$ENDIF}

implementation

{$IFNDEF CS_STATIC_DLL}
procedure InitCADImage;
  function GetProcAddr(ProcName: LPCSTR): Pointer;
  begin
    Result := GetProcAddress(CADImageInst, ProcName);
  end;
begin
  CADImageInst := LoadLibrary(cnstCADImageLibName);
  if CADImageInst <> 0 then
  begin
    @CADAddXRef := GetProcAddr('CADAddXRef');
    @CADLayer := GetProcAddr('CADLayer');
    @CADLayerCount := GetProcAddr('CADLayerCount');
    @CADLayerVisible := GetProcAddr('CADLayerVisible');
    @CADLayoutsCount := GetProcAddr('CADLayoutsCount');
    @CADLayoutName := GetProcAddr('CADLayoutName');
    @CADLayout := GetProcAddr('CADLayout');
    @CADSetSHXOptions := GetProcAddr('CADSetSHXOptions');
    @CloseCAD := GetProcAddr('CloseCAD');
    @CreateCAD := GetProcAddr('CreateCAD');
    @CurrentLayoutCAD := GetProcAddr('CurrentLayoutCAD');
    @DefaultLayoutIndex := GetProcAddr('DefaultLayoutIndex');
    @DrawCAD := GetProcAddr('DrawCAD');
    @DrawCADEx := GetProcAddr('DrawCADEx');
    @GetBoxCAD := GetProcAddr('GetBoxCAD');
    @GetCADCoords := GetProcAddr('GetCADCoords');
    @GetExtentsCAD := GetProcAddr('GetExtentsCAD');
    @GetIs3dCAD := GetProcAddr('GetIs3dCAD');
    @GetLastErrorCAD := GetProcAddr('GetLastErrorCAD');
    @GetNearestEntity := GetProcAddr('GetNearestEntity');
    @GetNearestEntityWCS := GetProcAddr('GetNearestEntityWCS');
    @GetPlugInInfo := GetProcAddr('GetPlugInInfo');
    @ResetDrawingBoxCAD := GetProcAddr('ResetDrawingBoxCAD');
    @SaveCADtoFileWithXMLParams := GetProcAddr('SaveCADtoFileWithXMLParams');
    @SaveCADtoBitmap := GetProcAddr('SaveCADtoBitmap');
    @SaveCADtoCAD := GetProcAddr('SaveCADtoCAD');
    @SaveCADtoGif := GetProcAddr('SaveCADtoGif');
    @SaveCADtoJpeg := GetProcAddr('SaveCADtoJpeg');
    @SaveCADtoPNG := GetProcAddr('SaveCADtoPNG');
    @SaveCADtoFile := GetProcAddr('SaveCADtoFile');
    @SetBlackWhite := GetProcAddr('SetBlackWhite');
    @SetCADBorderType := GetProcAddr('SetCADBorderType');
    @SetCADBorderSize := GetProcAddr('SetCADBorderSize');
    @SetDefaultColor := GetProcAddr('SetDefaultColor');
    @SetDrawingBoxCAD := GetProcAddr('SetDrawingBoxCAD');
    @SetProcessMessagesCAD := GetProcAddr('SetProcessMessagesCAD');
    @SetProgressProc := GetProcAddr('SetProgressProc');
    @StopLoading := GetProcAddr('StopLoading');
    @GetSupportedExts := GetProcAddr('GetSupportedExts');
    @StRgW := GetProcAddr('StRgW');
    @StRgA := GetProcAddr('StRgA');
    @StRg := GetProcAddr('StRg');
    @SaveCADtoFileWithXMLParams := GetProcAddr('SaveCADtoFileWithXMLParams');
    @SaveCADWithXMLParametrs := GetProcAddr('SaveCADWithXMLParametrs');
    @ProcessXML := GetProcAddr('ProcessXML');
    @CADSetViewPort := GetProcAddr('CADSetViewPort');
    @CADGetAutoRegenMode := GetProcAddr('CADGetAutoRegenMode');
    @CADSetAutoRegenMode := GetProcAddr('CADSetAutoRegenMode');
    @CADGetNumberOfParts := GetProcAddr('CADGetNumberOfParts');
    @CADSetNumberOfParts := GetProcAddr('CADSetNumberOfParts');
    @SetShowLineWeightCAD:= GetProcAddr('SetShowLineWeightCAD');
  end;
end;

procedure DoneCADImage;
begin
  if CADImageInst <> 0 then
  begin
    @CADLayer := nil;
    @CADLayerCount := nil;
    @CADLayerVisible := nil;
    @CADLayoutsCount := nil;
    @CADLayoutName := nil;
    @CADLayout := nil;
    @CloseCAD := nil;
    @CreateCAD := nil;
    @CurrentLayoutCAD := nil;
    @DefaultLayoutIndex := nil;
    @DrawCAD := nil;
    @DrawCADEx := nil;
    @GetBoxCAD := nil;
    @GetCADCoords := nil;
    @GetExtentsCAD := nil;
    @GetIs3dCAD := nil;
    @GetLastErrorCAD := nil;
    @GetNearestEntity := nil;
    @GetNearestEntityWCS := nil;
    @GetPlugInInfo := nil;
    @ResetDrawingBoxCAD := nil;
    @SaveCADtoFileWithXMLParams := nil;
    @SaveCADtoBitmap := nil;
    @SaveCADtoCAD := nil;
    @SaveCADtoGif := nil;
    @SaveCADtoJpeg := nil;
    @SaveCADtoPNG := nil;
    @SaveCADtoFile := nil;
    @SetBlackWhite := nil;
    @SetCADBorderType := nil;
    @SetCADBorderSize := nil;
    @SetDefaultColor := nil;
    @SetDrawingBoxCAD := nil;
    @SetProcessMessagesCAD := nil;
    @SetProgressProc := nil;
    @StopLoading := nil;
    @StRgW := nil;
    @StRgA := nil;
    @StRg := nil;
    @SaveCADtoFileWithXMLParams := nil;
    @SaveCADWithXMLParametrs := nil;
    @ProcessXML := nil;
    @SetShowLineWeightCAD := nil;
    FreeLibrary(CADImageInst);
    CADImageInst := 0;
  end;
end;
{$ENDIF}

initialization

{$IFNDEF CS_STATIC_DLL}
InitCADImage;
{$ENDIF}

finalization

{$IFNDEF CS_STATIC_DLL}
DoneCADImage;
{$ENDIF}

end.
