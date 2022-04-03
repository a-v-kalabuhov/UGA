unit maps32_TLB;

// ************************************************************************ //
// WARNING                                                                    
// -------                                                                    
// The types declared in this file were generated from data read from a       
// Type Library. If this type library is explicitly or indirectly (via        
// another type library referring to this type library) re-imported, or the   
// 'Refresh' command of the Type Library Editor activated while editing the   
// Type Library, the contents of this file will be regenerated and all        
// manual modifications will be lost.                                         
// ************************************************************************ //

// PASTLWTR : 1.2
// File generated on 14.02.2006 14:43:44 from Type Library described below.

// ************************************************************************  //
// Type Lib: C:\cmps\Mapsx\maps32.exe (1)
// LIBID: {DB7557B1-CFE8-11D3-BFC3-008048E6F41A}
// LCID: 0
// Helpfile: 
// HelpString: maps32 Library
// DepndLst: 
//   (1) v2.0 stdole, (C:\WINNT\System32\stdole2.tlb)
// ************************************************************************ //
// *************************************************************************//
// NOTE:                                                                      
// Items guarded by $IFDEF_LIVE_SERVER_AT_DESIGN_TIME are used by properties  
// which return objects that may need to be explicitly created via a function 
// call prior to any access via the property. These items have been disabled  
// in order to prevent accidental use from within the object inspector. You   
// may enable them by defining LIVE_SERVER_AT_DESIGN_TIME or by selectively   
// removing them from the $IFDEF blocks. However, such items must still be    
// programmatically created via a method of the appropriate CoClass before    
// they can be used.                                                          
{$TYPEDADDRESS OFF} // Unit must be compiled without type-checked pointers. 
{$WARN SYMBOL_PLATFORM OFF}
{$WRITEABLECONST ON}
{$VARPROPSETTER ON}
interface

uses Windows, ActiveX, Classes, Graphics, OleServer, StdVCL, Variants;
  

// *********************************************************************//
// GUIDS declared in the TypeLibrary. Following prefixes are used:        
//   Type Libraries     : LIBID_xxxx                                      
//   CoClasses          : CLASS_xxxx                                      
//   DISPInterfaces     : DIID_xxxx                                       
//   Non-DISP interfaces: IID_xxxx                                        
// *********************************************************************//
const
  // TypeLibrary Major and minor versions
  maps32MajorVersion = 1;
  maps32MinorVersion = 0;

  LIBID_maps32: TGUID = '{DB7557B1-CFE8-11D3-BFC3-008048E6F41A}';

  IID_IPoint: TGUID = '{8386B4FE-2719-11D4-8031-008048E6F41A}';
  IID_IRect: TGUID = '{6D4CD35F-2E3B-11D4-8039-008048E6F41A}';
  IID_IPoints: TGUID = '{09B3D1F2-27D1-11D4-8031-008048E6F41A}';
  IID_ISymbol: TGUID = '{84BFEA03-2BD1-11D4-8038-008048E6F41A}';
  IID_IErrors: TGUID = '{BD3DCF8A-2EFD-11D4-8039-008048E6F41A}';
  IID_ISymbols: TGUID = '{84BFEA01-2BD1-11D4-8038-008048E6F41A}';
  IID_IShape: TGUID = '{09B3D1EE-27D1-11D4-8031-008048E6F41A}';
  IID_IShapePoint: TGUID = '{71F5ECF0-2985-11D4-8033-008048E6F41A}';
  IID_IShapeEllipse: TGUID = '{71F5ECF2-2985-11D4-8033-008048E6F41A}';
  IID_IShapeRectangle: TGUID = '{71F5ECF4-2985-11D4-8033-008048E6F41A}';
  IID_IShapeText: TGUID = '{71F5ECF6-2985-11D4-8033-008048E6F41A}';
  IID_IShapeLine: TGUID = '{71F5ECF8-2985-11D4-8033-008048E6F41A}';
  IID_IShapeTopoLine: TGUID = '{71F5ECFA-2985-11D4-8033-008048E6F41A}';
  IID_IShapeTopoNode: TGUID = '{71F5ECFC-2985-11D4-8033-008048E6F41A}';
  IID_IShapeTopoPoly: TGUID = '{71F5ECFE-2985-11D4-8033-008048E6F41A}';
  IID_IShapeCombine: TGUID = '{71F5ED00-2985-11D4-8033-008048E6F41A}';
  IID_ISelects: TGUID = '{E2DCAC63-2A2E-11D4-8034-008048E6F41A}';
  IID_IShapes: TGUID = '{09B3D1F0-27D1-11D4-8031-008048E6F41A}';
  IID_ILayer: TGUID = '{17634091-264F-11D4-802F-008048E6F41A}';
  IID_ILayers: TGUID = '{176340B9-264F-11D4-802F-008048E6F41A}';
  IID_ITopologySettings: TGUID = '{9F930B0A-2BE8-11D4-8038-008048E6F41A}';
  IID_IMap: TGUID = '{176340CF-264F-11D4-802F-008048E6F41A}';
  IID_IMaps: TGUID = '{176340D1-264F-11D4-802F-008048E6F41A}';
  IID_IApplication: TGUID = '{DB7557B2-CFE8-11D3-BFC3-008048E6F41A}';
  CLASS_MapApp: TGUID = '{DB7557B6-CFE8-11D3-BFC3-008048E6F41A}';
  IID_ILibrary: TGUID = '{B9D4F0C1-2FCD-11D4-8039-008048E6F41A}';
  IID_IField: TGUID = '{9E9ED25E-45EE-11D4-8054-008048E6F41A}';
  IID_IFields: TGUID = '{9E9ED260-45EE-11D4-8054-008048E6F41A}';
  IID_IApplicationEvents: TGUID = '{1E828BE4-87D8-11D4-80AD-008048E6F41A}';
  IID_ICustomTool: TGUID = '{0B276FF0-B15F-11D4-80DB-008048E6F41A}';
  IID_ITabs: TGUID = '{BAEDD071-BBB3-11D4-80ED-008048E6F41A}';
  IID_ITab: TGUID = '{BD7EB5BD-BBC9-11D4-80ED-008048E6F41A}';
  IID_ITopology: TGUID = '{068FB311-BEE1-11D4-80F2-008048E6F41A}';
  IID_ICustomTool2: TGUID = '{09028DAE-F373-11D4-811D-008048E6F41A}';

// *********************************************************************//
// Declaration of Enumerations defined in Type Library                    
// *********************************************************************//
// Constants for enum T_SymbolType
type
  T_SymbolType = TOleEnum;
const
  otAny = $00000000;
  otPoint = $00000001;
  otSRect = $00000002;
  otLine = $00000003;
  otPoly = $00000004;
  otText = $00000005;
  otGroup = $00000006;

// Constants for enum T_MapState
type
  T_MapState = TOleEnum;
const
  msNone = $00000000;
  msLoad = $00000001;
  msStore = $00000002;
  msCreate = $00000003;
  msDestroy = $00000004;
  msActive = $00000005;
  msProp = $00000006;
  msStop = $00000007;

// Constants for enum T_Align
type
  T_Align = TOleEnum;
const
  LT = $00000000;
  CT = $00000001;
  RT = $00000002;
  LC = $00000003;
  CC = $00000004;
  RC = $00000005;
  LB = $00000006;
  CB = $00000007;
  RB = $00000008;
  Unknown = $00000009;

// Constants for enum T_Aligment
type
  T_Aligment = TOleEnum;
const
  taLeft = $00000000;
  taCentr = $00000001;
  taRight = $00000002;

// Constants for enum ShapeFlags
type
  ShapeFlags = TOleEnum;
const
  fsSelected = $00000001;
  fsLock = $00000002;
  fsEditing = $00000004;
  fsInvalidate = $00000008;
  fsDestroy = $00000010;
  fsSystem = $0000001F;
  fsNoVisible = $00000020;
  fsTarget = $00000040;
  fsNoStored = $00000080;

type

// *********************************************************************//
// Forward declaration of types defined in TypeLibrary                    
// *********************************************************************//
  IPoint = interface;
  IRect = interface;
  IPoints = interface;
  ISymbol = interface;
  IErrors = interface;
  ISymbols = interface;
  IShape = interface;
  IShapePoint = interface;
  IShapeEllipse = interface;
  IShapeRectangle = interface;
  IShapeText = interface;
  IShapeLine = interface;
  IShapeTopoLine = interface;
  IShapeTopoNode = interface;
  IShapeTopoPoly = interface;
  IShapeCombine = interface;
  ISelects = interface;
  IShapes = interface;
  ILayer = interface;
  ILayers = interface;
  ITopologySettings = interface;
  IMap = interface;
  IMaps = interface;
  IApplication = interface;
  IApplicationDisp = dispinterface;
  ILibrary = interface;
  IField = interface;
  IFields = interface;
  IApplicationEvents = interface;
  IApplicationEventsDisp = dispinterface;
  ICustomTool = interface;
  ITabs = interface;
  ITab = interface;
  ITopology = interface;
  ICustomTool2 = interface;

// *********************************************************************//
// Declaration of CoClasses defined in Type Library                       
// (NOTE: Here we map each CoClass to its Default Interface)              
// *********************************************************************//
  MapApp = IApplication;


// *********************************************************************//
// Interface: IPoint
// Flags:     (256) OleAutomation
// GUID:      {8386B4FE-2719-11D4-8031-008048E6F41A}
// *********************************************************************//
  IPoint = interface(IUnknown)
    ['{8386B4FE-2719-11D4-8031-008048E6F41A}']
    function SetPoint(X: Double; Y: Double): HResult; stdcall;
    function Eq(const Value: IPoint; out Value1: WordBool): HResult; stdcall;
    function Get_X(out Value: Double): HResult; stdcall;
    function Set_X(Value: Double): HResult; stdcall;
    function Get_Y(out Value: Double): HResult; stdcall;
    function Set_Y(Value: Double): HResult; stdcall;
    function Dist(const Value: IPoint; out Value1: Double): HResult; stdcall;
  end;

// *********************************************************************//
// Interface: IRect
// Flags:     (256) OleAutomation
// GUID:      {6D4CD35F-2E3B-11D4-8039-008048E6F41A}
// *********************************************************************//
  IRect = interface(IUnknown)
    ['{6D4CD35F-2E3B-11D4-8039-008048E6F41A}']
    function Get_AX(out Value: Double): HResult; stdcall;
    function Set_AX(Value: Double): HResult; stdcall;
    function Get_AY(out Value: Double): HResult; stdcall;
    function Set_AY(Value: Double): HResult; stdcall;
    function Get_BX(out Value: Double): HResult; stdcall;
    function Set_BX(Value: Double): HResult; stdcall;
    function Get_BY(out Value: Double): HResult; stdcall;
    function Set_BY(Value: Double): HResult; stdcall;
    function SetRect(AX: Double; AY: Double; BX: Double; BY: Double; out Value: IRect): HResult; stdcall;
    function Union(const Value: IRect): HResult; stdcall;
  end;

// *********************************************************************//
// Interface: IPoints
// Flags:     (256) OleAutomation
// GUID:      {09B3D1F2-27D1-11D4-8031-008048E6F41A}
// *********************************************************************//
  IPoints = interface(IUnknown)
    ['{09B3D1F2-27D1-11D4-8031-008048E6F41A}']
    function Get_Count(out Value: Integer): HResult; stdcall;
    function SeedEquals: HResult; stdcall;
    function SeedTabs: HResult; stdcall;
    function SeedAngle(Value: Double): HResult; stdcall;
    function SeedDist(Value: Double): HResult; stdcall;
    function SeedHorda(Value: Double): HResult; stdcall;
    function Move(X: Double; Y: Double): HResult; stdcall;
    function Area(out Value: Double): HResult; stdcall;
    function Perimetr(out Value: Double): HResult; stdcall;
    function Revert: HResult; stdcall;
    function Add(X: Double; Y: Double; out Value: Integer): HResult; stdcall;
    function Insert(Index: Integer; X: Double; Y: Double; out Value: Integer): HResult; stdcall;
    function Get_Changed(out Value: WordBool): HResult; stdcall;
    function Set_Changed(Value: WordBool): HResult; stdcall;
    function Delete(Index: Integer): HResult; stdcall;
    function AllCount(out Value: Integer): HResult; stdcall;
    function Get_Segments(Index: Integer; out Value: Integer): HResult; stdcall;
    function Set_Segments(Index: Integer; Value: Integer): HResult; stdcall;
    function Disconnect: HResult; stdcall;
    function Get_DistToNext(Index: Integer; out Value: Double): HResult; stdcall;
    function Set_DistToNext(Index: Integer; Value: Double): HResult; stdcall;
    function Get_AngleToNext(Index: Integer; out Value: Double): HResult; stdcall;
    function Set_AngleToNext(Index: Integer; Value: Double): HResult; stdcall;
    function Get_AngleBetween(Index: Integer; out Value: Double): HResult; stdcall;
    function Set_AngleBetween(Index: Integer; Value: Double): HResult; stdcall;
    function SetXY(Index: Integer; X: Double; Y: Double): HResult; stdcall;
    function AddSegment(const Item: IPoints; out Value: Integer): HResult; stdcall;
    function RemoveSegment(Index: Integer; out Value: IPoints): HResult; stdcall;
    function Get_SegmentCount(out Value: Integer): HResult; stdcall;
    function Set_SegmentCount(Value: Integer): HResult; stdcall;
    function Get_Segment(out Value: Integer): HResult; stdcall;
    function Set_Segment(Value: Integer): HResult; stdcall;
    function Contains(X: Double; Y: Double; Delta: Double; out Value: WordBool): HResult; stdcall;
    function IntersectRectR(AX: Double; AY: Double; BX: Double; BY: Double; out Value: WordBool): HResult; stdcall;
    function Get_IsArea(out Value: WordBool): HResult; stdcall;
    function Set_IsArea(Value: WordBool): HResult; stdcall;
    function SetData(HPoints: Integer; HSegments: Integer): HResult; stdcall;
    function GetData(var HPoints: Integer; var HSegments: Integer): HResult; stdcall;
    function GetNearestVertex(X: Double; Y: Double; var PX: Double; var PY: Double; 
                              var Segment: Integer; var Index: Integer): HResult; stdcall;
    function GetNearestPoint(X: Double; Y: Double; var PX: Double; var PY: Double; 
                             var Segment: Integer; var Index: Integer): HResult; stdcall;
    function GetBufferZone(Value: Double; out Value1: IPoints): HResult; stdcall;
    function AreaUnion(const P: IPoints; out Value: IPoints): HResult; stdcall;
    function AreaIntersect(const P: IPoints; out Value: IPoints): HResult; stdcall;
    function AreaSubtract(const P: IPoints; out Value: IPoints): HResult; stdcall;
    function AreaXor(const P: IPoints; out Value: IPoints): HResult; stdcall;
    function IsIntersect(const P: IPoints; out Value: WordBool): HResult; stdcall;
    function IsContain(const P: IPoints; out Value: WordBool): HResult; stdcall;
    function Extent(out Value: IRect): HResult; stdcall;
    function Clear: HResult; stdcall;
    function Handle(out Value: Integer): HResult; stdcall;
    function Separate(const A: IPoints; out Value: WordBool): HResult; stdcall;
    function IsEq(const A: IPoints; out Value: WordBool): HResult; stdcall;
    function Copy(out Value: IPoints): HResult; stdcall;
    function AddNewSegment(PointCount: Integer; out Value: Integer): HResult; stdcall;
    function Get_AsString(out Value: WideString): HResult; stdcall;
    function Set_AsString(const Value: WideString): HResult; stdcall;
    function Pack: HResult; stdcall;
    function StoreToStr(out Value: WideString): HResult; stdcall;
    function LineOffset(Dist: Double; AngleType: Integer; out Value: IPoints): HResult; stdcall;
    function LoadFromStr(const aStr: WideString): HResult; stdcall;
    function SetDataZN(HPoints: Integer; HSegments: Integer): HResult; stdcall;
    function GetDataZN(var HPoints: Integer; var HSegments: Integer): HResult; stdcall;
    function SetClosed(Value: WordBool): HResult; stdcall;
    function Get_Names(Index: Integer; out Value: WideString): HResult; stdcall;
    function Set_Names(Index: Integer; const Value: WideString): HResult; stdcall;
    function Get_X(Index: Integer; out Value: Double): HResult; stdcall;
    function Set_X(Index: Integer; Value: Double): HResult; stdcall;
    function Get_Y(Index: Integer; out Value: Double): HResult; stdcall;
    function Set_Y(Index: Integer; Value: Double): HResult; stdcall;
    function Get_Z(Index: Integer; out Value: Double): HResult; stdcall;
    function Set_Z(Index: Integer; Value: Double): HResult; stdcall;
    function HasNames(out Value: WordBool): HResult; stdcall;
    function HasZ(out Value: WordBool): HResult; stdcall;
  end;

// *********************************************************************//
// Interface: ISymbol
// Flags:     (256) OleAutomation
// GUID:      {84BFEA03-2BD1-11D4-8038-008048E6F41A}
// *********************************************************************//
  ISymbol = interface(IUnknown)
    ['{84BFEA03-2BD1-11D4-8038-008048E6F41A}']
    function Get_ID(out Value: Integer): HResult; stdcall;
    function Set_ID(Value: Integer): HResult; stdcall;
    function Get_Name(out Value: WideString): HResult; stdcall;
    function Set_Name(const Value: WideString): HResult; stdcall;
    function Get_SymbolType(out Value: T_SymbolType): HResult; stdcall;
    function Set_SymbolType(Value: T_SymbolType): HResult; stdcall;
    function Get_ParentID(out Value: Integer): HResult; stdcall;
    function Set_ParentID(Value: Integer): HResult; stdcall;
    function Get_LabelID(out Value: Integer): HResult; stdcall;
    function Set_LabelID(Value: Integer): HResult; stdcall;
    function Get_MinScale(out Value: Double): HResult; stdcall;
    function Set_MinScale(Value: Double): HResult; stdcall;
    function Get_MaxScale(out Value: Double): HResult; stdcall;
    function Set_MaxScale(Value: Double): HResult; stdcall;
    function Get_Visible(out Value: WordBool): HResult; stdcall;
    function Set_Visible(Value: WordBool): HResult; stdcall;
    function Get_Expanded(out Value: WordBool): HResult; stdcall;
    function Set_Expanded(Value: WordBool): HResult; stdcall;
    function Get_ResourceName(out Value: WideString): HResult; stdcall;
    function Set_ResourceName(const Value: WideString): HResult; stdcall;
    function ShowDlg(out Value: WordBool): HResult; stdcall;
    function Layer(out Value: ILayer): HResult; stdcall;
    function Get_AsString(out Value: WideString): HResult; stdcall;
    function Set_AsString(const Value: WideString): HResult; stdcall;
    function ShowPalette(out Value: WordBool): HResult; stdcall;
    function Get_PenWidth(out Value: Double): HResult; stdcall;
    function Set_PenWidth(Value: Double): HResult; stdcall;
    function Get_PenStyle(out Value: Integer): HResult; stdcall;
    function Set_PenStyle(Value: Integer): HResult; stdcall;
    function Get_PenColor(out Value: Integer): HResult; stdcall;
    function Set_PenColor(Value: Integer): HResult; stdcall;
    function Get_BrushColor(out Value: Integer): HResult; stdcall;
    function Set_BrushColor(Value: Integer): HResult; stdcall;
    function Get_BrushStyle(out Value: Integer): HResult; stdcall;
    function Set_BrushStyle(Value: Integer): HResult; stdcall;
    function Showing(out Value: WordBool): HResult; stdcall;
    function Get_BkColor(out Value: Integer): HResult; stdcall;
    function Set_BkColor(Value: Integer): HResult; stdcall;
    function Copy(out Value: ISymbol): HResult; stdcall;
    function DrawSample(DC: Integer; AX: Integer; AY: Integer; BX: Integer; BY: Integer): HResult; stdcall;
    function Get_FontName(out Value: WideString): HResult; stdcall;
    function Set_FontName(const Value: WideString): HResult; stdcall;
    function Get_FontStyle(out Value: WideString): HResult; stdcall;
    function Set_FontStyle(const Value: WideString): HResult; stdcall;
    function Get_FontCharH(out Value: Double): HResult; stdcall;
    function Set_FontCharH(Value: Double): HResult; stdcall;
    function Get_FontCharW(out Value: Double): HResult; stdcall;
    function Set_FontCharW(Value: Double): HResult; stdcall;
    function Get_SignKX(out Value: Double): HResult; stdcall;
    function Set_SignKX(Value: Double): HResult; stdcall;
    function Get_SignKY(out Value: Double): HResult; stdcall;
    function Set_SignKY(Value: Double): HResult; stdcall;
    function Get_SignAngle(out Value: Double): HResult; stdcall;
    function Set_SignAngle(Value: Double): HResult; stdcall;
    function Get_SignProp(out Value: WordBool): HResult; stdcall;
    function Set_SignProp(Value: WordBool): HResult; stdcall;
    function Get_SignName(out Value: WideString): HResult; stdcall;
    function Set_SignName(const Value: WideString): HResult; stdcall;
    function Invalidate: HResult; stdcall;
    function Get_Selected(out Value: WordBool): HResult; stdcall;
    function Set_Selected(Value: WordBool): HResult; stdcall;
    function EqualValues(const Valu: ISymbol; out Value: WordBool): HResult; stdcall;
    function FillFromShape: HResult; stdcall;
    function Get_TextColor(out Value: Integer): HResult; stdcall;
    function Set_TextColor(Value: Integer): HResult; stdcall;
    function Get_Empty(out Value: WordBool): HResult; stdcall;
    function Set_Empty(Value: WordBool): HResult; stdcall;
    function Get_UsePattern(out Value: WordBool): HResult; stdcall;
    function Set_UsePattern(Value: WordBool): HResult; stdcall;
    function Next(out Value: ISymbol): HResult; stdcall;
    function Prev(out Value: ISymbol): HResult; stdcall;
    function Parent(out Value: ISymbol): HResult; stdcall;
    function FirstChild(out Value: ISymbol): HResult; stdcall;
  end;

// *********************************************************************//
// Interface: IErrors
// Flags:     (256) OleAutomation
// GUID:      {BD3DCF8A-2EFD-11D4-8039-008048E6F41A}
// *********************************************************************//
  IErrors = interface(IUnknown)
    ['{BD3DCF8A-2EFD-11D4-8039-008048E6F41A}']
    function Get_Items(Index: Integer; out Value: WideString): HResult; stdcall;
    function Get_Count(out Value: Integer): HResult; stdcall;
    function Clear: HResult; stdcall;
    function Add(const Value: WideString): HResult; stdcall;
  end;

// *********************************************************************//
// Interface: ISymbols
// Flags:     (256) OleAutomation
// GUID:      {84BFEA01-2BD1-11D4-8038-008048E6F41A}
// *********************************************************************//
  ISymbols = interface(IUnknown)
    ['{84BFEA01-2BD1-11D4-8038-008048E6F41A}']
    function Get_Items(Index: Integer; out Value: ISymbol): HResult; stdcall;
    function Get_Count(out Value: Integer): HResult; stdcall;
    function ByName(const aName: WideString; out Value: ISymbol): HResult; stdcall;
    function ByID(aID: Integer; out Value: ISymbol): HResult; stdcall;
    function Get_Overlaping(out Value: WordBool): HResult; stdcall;
    function Set_Overlaping(Value: WordBool): HResult; stdcall;
    function Add(out Value: ISymbol): HResult; stdcall;
    function Remove(Index: Integer): HResult; stdcall;
    function IndexOf(const Value: ISymbol; out Value1: Integer): HResult; stdcall;
    function First(out Value: ISymbol): HResult; stdcall;
    function MoveTo(FromIdx: Integer; ToIdx: Integer): HResult; stdcall;
  end;

// *********************************************************************//
// Interface: IShape
// Flags:     (256) OleAutomation
// GUID:      {09B3D1EE-27D1-11D4-8031-008048E6F41A}
// *********************************************************************//
  IShape = interface(IUnknown)
    ['{09B3D1EE-27D1-11D4-8031-008048E6F41A}']
    function Get_ID(out Value: Integer): HResult; stdcall;
    function Set_ID(Value: Integer): HResult; stdcall;
    function Get_UserID(out Value: Integer): HResult; stdcall;
    function Set_UserID(Value: Integer): HResult; stdcall;
    function Get_Title(out Value: WideString): HResult; stdcall;
    function Set_Title(const Value: WideString): HResult; stdcall;
    function Get_SymbolID(out Value: Integer): HResult; stdcall;
    function Set_SymbolID(Value: Integer): HResult; stdcall;
    function Get_Extent(out Value: IRect): HResult; stdcall;
    function Set_Extent(const Value: IRect): HResult; stdcall;
    function Get_OriginX(out Value: Double): HResult; stdcall;
    function Set_OriginX(Value: Double): HResult; stdcall;
    function Get_OriginY(out Value: Double): HResult; stdcall;
    function Set_OriginY(Value: Double): HResult; stdcall;
    function Editing(out Value: WordBool): HResult; stdcall;
    function Edit: HResult; stdcall;
    function Post: HResult; stdcall;
    function Cancel: HResult; stdcall;
    function GetAngle(out Value: Double): HResult; stdcall;
    function Rotate(X: Double; Y: Double; aAngle: Double): HResult; stdcall;
    function DrawExample(aHandle: Integer; AX: Integer; AY: Integer; BX: Integer; BY: Integer): HResult; stdcall;
    function ShowDlg(out Value: WordBool): HResult; stdcall;
    function Get_Layer(out Value: ILayer): HResult; stdcall;
    function Get_Map(out Value: IMap): HResult; stdcall;
    function GetInfo(Flags: Integer; out Value: WideString): HResult; stdcall;
    function Get_Fields(out Value: IFields): HResult; stdcall;
    function LabelFieldValues(out Value: WideString): HResult; stdcall;
    function Get_Points(out Value: IPoints): HResult; stdcall;
    function Set_Points(const Value: IPoints): HResult; stdcall;
    function Get_Symbol(out Value: ISymbol): HResult; stdcall;
    function Set_Symbol(const Value: ISymbol): HResult; stdcall;
    function Get_IO_String(out Value: WideString): HResult; stdcall;
    function Set_IO_String(const Value: WideString): HResult; stdcall;
    function Get_dbLink(out Value: WordBool): HResult; stdcall;
    function Set_dbLink(Value: WordBool): HResult; stdcall;
    function Get_Flags(out Value: Word): HResult; stdcall;
    function Set_Flags(Value: Word): HResult; stdcall;
    function Get_Selected(out Value: WordBool): HResult; stdcall;
    function Set_Selected(Value: WordBool): HResult; stdcall;
    function ContainsXY(X: Double; Y: Double; out Value: WordBool): HResult; stdcall;
    function Get_CenterX(out Value: Double): HResult; stdcall;
    function Set_CenterX(Value: Double): HResult; stdcall;
    function Get_CenterY(out Value: Double): HResult; stdcall;
    function Set_CenterY(Value: Double): HResult; stdcall;
    function hasCenter(out Value: WordBool): HResult; stdcall;
    function Get_IsArea(out Value: WordBool): HResult; stdcall;
    function Set_IsArea(Value: WordBool): HResult; stdcall;
    function ShowPalette(out Value: WordBool): HResult; stdcall;
    function Saved(out Value: WordBool): HResult; stdcall;
  end;

// *********************************************************************//
// Interface: IShapePoint
// Flags:     (256) OleAutomation
// GUID:      {71F5ECF0-2985-11D4-8033-008048E6F41A}
// *********************************************************************//
  IShapePoint = interface(IShape)
    ['{71F5ECF0-2985-11D4-8033-008048E6F41A}']
    function Get_KX(out Value: Double): HResult; stdcall;
    function Set_KX(Value: Double): HResult; stdcall;
    function Get_KY(out Value: Double): HResult; stdcall;
    function Set_KY(Value: Double): HResult; stdcall;
    function Get_Angle(out Value: Double): HResult; stdcall;
    function Set_Angle(Value: Double): HResult; stdcall;
    function Get_SignName(out Value: WideString): HResult; stdcall;
    function Set_SignName(const Value: WideString): HResult; stdcall;
    function IsImage(out Value: WordBool): HResult; stdcall;
    function Get_Align(out Value: T_Align): HResult; stdcall;
    function Set_Align(Value: T_Align): HResult; stdcall;
  end;

// *********************************************************************//
// Interface: IShapeEllipse
// Flags:     (256) OleAutomation
// GUID:      {71F5ECF2-2985-11D4-8033-008048E6F41A}
// *********************************************************************//
  IShapeEllipse = interface(IShape)
    ['{71F5ECF2-2985-11D4-8033-008048E6F41A}']
    function Get_Sec1(out Value: Double): HResult; stdcall;
    function Set_Sec1(Value: Double): HResult; stdcall;
    function Get_Sec2(out Value: Double): HResult; stdcall;
    function Set_Sec2(Value: Double): HResult; stdcall;
    function Get_RadiusX(out Value: Double): HResult; stdcall;
    function Set_RadiusX(Value: Double): HResult; stdcall;
    function Get_RadiusY(out Value: Double): HResult; stdcall;
    function Set_RadiusY(Value: Double): HResult; stdcall;
  end;

// *********************************************************************//
// Interface: IShapeRectangle
// Flags:     (256) OleAutomation
// GUID:      {71F5ECF4-2985-11D4-8033-008048E6F41A}
// *********************************************************************//
  IShapeRectangle = interface(IShape)
    ['{71F5ECF4-2985-11D4-8033-008048E6F41A}']
  end;

// *********************************************************************//
// Interface: IShapeText
// Flags:     (256) OleAutomation
// GUID:      {71F5ECF6-2985-11D4-8033-008048E6F41A}
// *********************************************************************//
  IShapeText = interface(IShape)
    ['{71F5ECF6-2985-11D4-8033-008048E6F41A}']
    function Get_Angle(out Value: Double): HResult; stdcall;
    function Set_Angle(Value: Double): HResult; stdcall;
    function Get_Align(out Value: T_Align): HResult; stdcall;
    function Set_Align(Value: T_Align): HResult; stdcall;
    function Get_Aligment(out Value: T_Aligment): HResult; stdcall;
    function Set_Aligment(Value: T_Aligment): HResult; stdcall;
    function TextWidth(out Value: Double): HResult; stdcall;
  end;

// *********************************************************************//
// Interface: IShapeLine
// Flags:     (256) OleAutomation
// GUID:      {71F5ECF8-2985-11D4-8033-008048E6F41A}
// *********************************************************************//
  IShapeLine = interface(IShape)
    ['{71F5ECF8-2985-11D4-8033-008048E6F41A}']
  end;

// *********************************************************************//
// Interface: IShapeTopoLine
// Flags:     (256) OleAutomation
// GUID:      {71F5ECFA-2985-11D4-8033-008048E6F41A}
// *********************************************************************//
  IShapeTopoLine = interface(IShapeLine)
    ['{71F5ECFA-2985-11D4-8033-008048E6F41A}']
    function Get_IdA(out Value: Integer): HResult; stdcall;
    function Get_IdB(out Value: Integer): HResult; stdcall;
  end;

// *********************************************************************//
// Interface: IShapeTopoNode
// Flags:     (256) OleAutomation
// GUID:      {71F5ECFC-2985-11D4-8033-008048E6F41A}
// *********************************************************************//
  IShapeTopoNode = interface(IShapePoint)
    ['{71F5ECFC-2985-11D4-8033-008048E6F41A}']
    function cLines(out Value: Integer): HResult; stdcall;
    function Get_Items(Index: Integer; out Value: Integer): HResult; stdcall;
  end;

// *********************************************************************//
// Interface: IShapeTopoPoly
// Flags:     (256) OleAutomation
// GUID:      {71F5ECFE-2985-11D4-8033-008048E6F41A}
// *********************************************************************//
  IShapeTopoPoly = interface(IShape)
    ['{71F5ECFE-2985-11D4-8033-008048E6F41A}']
  end;

// *********************************************************************//
// Interface: IShapeCombine
// Flags:     (256) OleAutomation
// GUID:      {71F5ED00-2985-11D4-8033-008048E6F41A}
// *********************************************************************//
  IShapeCombine = interface(IShape)
    ['{71F5ED00-2985-11D4-8033-008048E6F41A}']
    function AddById(Value: Integer): HResult; stdcall;
  end;

// *********************************************************************//
// Interface: ISelects
// Flags:     (256) OleAutomation
// GUID:      {E2DCAC63-2A2E-11D4-8034-008048E6F41A}
// *********************************************************************//
  ISelects = interface(IUnknown)
    ['{E2DCAC63-2A2E-11D4-8034-008048E6F41A}']
    function Get_Count(out Value: Integer): HResult; stdcall;
    function Get_Items(Index: Integer; out Value: IShape): HResult; stdcall;
    function Get_Extent(out Value: IRect): HResult; stdcall;
    function Get_Area(out Value: Double): HResult; stdcall;
    function Get_Length(out Value: Double): HResult; stdcall;
    function Layer(out Value: ILayer): HResult; stdcall;
    function Clear: HResult; stdcall;
  end;

// *********************************************************************//
// Interface: IShapes
// Flags:     (256) OleAutomation
// GUID:      {09B3D1F0-27D1-11D4-8031-008048E6F41A}
// *********************************************************************//
  IShapes = interface(IUnknown)
    ['{09B3D1F0-27D1-11D4-8031-008048E6F41A}']
    function Get_Items(Index: Integer; out Value: IShape): HResult; stdcall;
    function Get_Count(out Value: Integer): HResult; stdcall;
    function ByXY(X: Double; Y: Double; out Value: IShape): HResult; stdcall;
    function RangeByRect(AX: Double; AY: Double; BX: Double; BY: Double; out Value: IShapes): HResult; stdcall;
    function RangeBySymbols(out Value: IShapes): HResult; stdcall;
    function ByID(I: Integer; out Value: IShape): HResult; stdcall;
    function CreatePoint(bInsert: WordBool; out Value: IShapePoint): HResult; stdcall;
    function CreateLine(bInsert: WordBool; Fill: WordBool; out Value: IShapeLine): HResult; stdcall;
    function CreateText(bInsert: WordBool; out Value: IShapeText): HResult; stdcall;
    function CreateRectangle(bInsert: WordBool; Fill: WordBool; out Value: IShapeRectangle): HResult; stdcall;
    function CreateEllipse(bInsert: WordBool; Fill: WordBool; out Value: IShapeEllipse): HResult; stdcall;
    function CreateCombine(bInsert: WordBool; out Value: IShapeCombine): HResult; stdcall;
    function FreeByID(Value: Integer): HResult; stdcall;
    function LoadAll: HResult; stdcall;
  end;

// *********************************************************************//
// Interface: ILayer
// Flags:     (256) OleAutomation
// GUID:      {17634091-264F-11D4-802F-008048E6F41A}
// *********************************************************************//
  ILayer = interface(IUnknown)
    ['{17634091-264F-11D4-802F-008048E6F41A}']
    function Get_Name(out Value: WideString): HResult; stdcall;
    function Set_Name(const Value: WideString): HResult; stdcall;
    function Get_Visible(out Value: WordBool): HResult; stdcall;
    function Set_Visible(Value: WordBool): HResult; stdcall;
    function Get_Selected(out Value: WordBool): HResult; stdcall;
    function Set_Selected(Value: WordBool): HResult; stdcall;
    function Get_Locate(out Value: WideString): HResult; stdcall;
    function Set_Locate(const Value: WideString): HResult; stdcall;
    function Get_MultyMap(out Value: WordBool): HResult; stdcall;
    function Get_MinScale(out Value: Double): HResult; stdcall;
    function Set_MinScale(Value: Double): HResult; stdcall;
    function Get_MaxScale(out Value: Double): HResult; stdcall;
    function Set_MaxScale(Value: Double): HResult; stdcall;
    function Get_FileName(out Value: WideString): HResult; stdcall;
    function Set_FileName(const Value: WideString): HResult; stdcall;
    function Get_isCosmetic(out Value: WordBool): HResult; stdcall;
    function Set_isCosmetic(Value: WordBool): HResult; stdcall;
    function Get_MapName(out Value: WideString): HResult; stdcall;
    function Set_MapName(const Value: WideString): HResult; stdcall;
    function Get_MapScale(out Value: Integer): HResult; stdcall;
    function Set_MapScale(Value: Integer): HResult; stdcall;
    function Get_TableName(out Value: WideString): HResult; stdcall;
    function Get_LabelFieldNames(out Value: WideString): HResult; stdcall;
    function Set_LabelFieldNames(const Value: WideString): HResult; stdcall;
    function Get_HotLinkApp(out Value: WideString): HResult; stdcall;
    function Set_HotLinkApp(const Value: WideString): HResult; stdcall;
    function Get_HotLinkParams(out Value: WideString): HResult; stdcall;
    function Set_HotLinkParams(const Value: WideString): HResult; stdcall;
    function Get_RefreshApp(out Value: WideString): HResult; stdcall;
    function Set_RefreshApp(const Value: WideString): HResult; stdcall;
    function Get_RefreshParams(out Value: WideString): HResult; stdcall;
    function Set_RefreshParams(const Value: WideString): HResult; stdcall;
    function Get_LibraryFile(out Value: WideString): HResult; stdcall;
    function Set_LibraryFile(const Value: WideString): HResult; stdcall;
    function Get_LinesFile(out Value: WideString): HResult; stdcall;
    function Set_LinesFile(const Value: WideString): HResult; stdcall;
    function Get_Symbols(out Value: ISymbols): HResult; stdcall;
    function Save: HResult; stdcall;
    function SaveAs(const Value: WideString): HResult; stdcall;
    function Get_ObjType(out Value: T_SymbolType): HResult; stdcall;
    function Set_ObjType(Value: T_SymbolType): HResult; stdcall;
    function Get_Errors(out Value: IErrors): HResult; stdcall;
    function Get_Map(out Value: IMap): HResult; stdcall;
    function Get_Shapes(out Value: IShapes): HResult; stdcall;
    function Get_Extent(out Value: IRect): HResult; stdcall;
    function Get_Fields(out Value: IFields): HResult; stdcall;
    function Get_edPointSymbol(out Value: ISymbol): HResult; stdcall;
    function Set_edPointSymbol(const Value: ISymbol): HResult; stdcall;
    function Get_edTextSymbol(out Value: ISymbol): HResult; stdcall;
    function Set_edTextSymbol(const Value: ISymbol): HResult; stdcall;
    function Get_edLineSymbol(out Value: ISymbol): HResult; stdcall;
    function Set_edLineSymbol(const Value: ISymbol): HResult; stdcall;
    function Get_edPolySymbol(out Value: ISymbol): HResult; stdcall;
    function Set_edPolySymbol(const Value: ISymbol): HResult; stdcall;
    function Get_LayerType(out Value: Integer): HResult; stdcall;
    function Set_LayerType(Value: Integer): HResult; stdcall;
    function ShowDlg(out Value: WordBool): HResult; stdcall;
    function Get_ID(out Value: Integer): HResult; stdcall;
    function Get_Editing(out Value: WordBool): HResult; stdcall;
    function Set_Editing(Value: WordBool): HResult; stdcall;
    function Get_Expanded(out Value: WordBool): HResult; stdcall;
    function Set_Expanded(Value: WordBool): HResult; stdcall;
    function WriteData: HResult; stdcall;
    function Get_Selects(out Value: ISelects): HResult; stdcall;
    function ArcStart(const aName: WideString): HResult; stdcall;
    function ArcCommit: HResult; stdcall;
    function ArcRollback: HResult; stdcall;
    function Get_Topology(out Value: ITopology): HResult; stdcall;
    function Get_IsRaster(out Value: WordBool): HResult; stdcall;
    function Get_GrayColor(out Value: Integer): HResult; stdcall;
    function Set_GrayColor(Value: Integer): HResult; stdcall;
    function Get_Table(out Value: ITab): HResult; stdcall;
    function Get_CheckLinkColor(out Value: Integer): HResult; stdcall;
    function Set_CheckLinkColor(Value: Integer): HResult; stdcall;
    function Get_IsDrawSimple(out Value: WordBool): HResult; stdcall;
    function Set_IsDrawSimple(Value: WordBool): HResult; stdcall;
    function Get_ClassFieldNames(out Value: WideString): HResult; stdcall;
    function Set_ClassFieldNames(const Value: WideString): HResult; stdcall;
    function Get_LibraryKGrow(out Value: Double): HResult; stdcall;
    function Set_LibraryKGrow(Value: Double): HResult; stdcall;
    function Get_UseIndex(out Value: WordBool): HResult; stdcall;
    function Set_UseIndex(Value: WordBool): HResult; stdcall;
    function Get_UseLinesLib(out Value: WordBool): HResult; stdcall;
    function Set_UseLinesLib(Value: WordBool): HResult; stdcall;
    function Get_PropChanged(out Value: WordBool): HResult; stdcall;
    function Set_PropChanged(Value: WordBool): HResult; stdcall;
    function TableExists(out Value: WordBool): HResult; stdcall;
    function Refresh: HResult; stdcall;
    function CanRefresh(out Value: WordBool): HResult; stdcall;
    function Get_CheckIndex(out Value: WordBool): HResult; stdcall;
    function Set_CheckIndex(Value: WordBool): HResult; stdcall;
    function Get_UseArcLog(out Value: WordBool): HResult; stdcall;
    function Set_UseArcLog(Value: WordBool): HResult; stdcall;
    function Get_UseReservCopy(out Value: WordBool): HResult; stdcall;
    function Set_UseReservCopy(Value: WordBool): HResult; stdcall;
    function Get_ReservCopyExt(out Value: WideString): HResult; stdcall;
    function Set_ReservCopyExt(const Value: WideString): HResult; stdcall;
    function Get_ReservCopyPath(out Value: WideString): HResult; stdcall;
    function Set_ReservCopyPath(const Value: WideString): HResult; stdcall;
    function Get_Duplicates(out Value: Integer): HResult; stdcall;
    function Set_Duplicates(Value: Integer): HResult; stdcall;
  end;

// *********************************************************************//
// Interface: ILayers
// Flags:     (256) OleAutomation
// GUID:      {176340B9-264F-11D4-802F-008048E6F41A}
// *********************************************************************//
  ILayers = interface(IUnknown)
    ['{176340B9-264F-11D4-802F-008048E6F41A}']
    function Get_Items(Index: Integer; out Value: ILayer): HResult; stdcall;
    function Get_Count(out Value: Integer): HResult; stdcall;
    function Add(out Value: ILayer): HResult; stdcall;
    function Move(FromIdx: Integer; ToIdx: Integer): HResult; stdcall;
    function Remove(Index: Integer): HResult; stdcall;
    function FirstSelected(out Value: ILayer): HResult; stdcall;
    function Editing(out Value: ILayer): HResult; stdcall;
    function ByName(const Value: WideString; out Value1: ILayer): HResult; stdcall;
    function Cosmetic(out Value: ILayer): HResult; stdcall;
  end;

// *********************************************************************//
// Interface: ITopologySettings
// Flags:     (256) OleAutomation
// GUID:      {9F930B0A-2BE8-11D4-8038-008048E6F41A}
// *********************************************************************//
  ITopologySettings = interface(IUnknown)
    ['{9F930B0A-2BE8-11D4-8038-008048E6F41A}']
    function Get_ShowEmptyNodes(out Value: WordBool): HResult; stdcall;
    function Set_ShowEmptyNodes(Value: WordBool): HResult; stdcall;
    function Get_ShowNormalNodes(out Value: WordBool): HResult; stdcall;
    function Set_ShowNormalNodes(Value: WordBool): HResult; stdcall;
    function Get_ShowPendentNodes(out Value: WordBool): HResult; stdcall;
    function Set_ShowPendentNodes(Value: WordBool): HResult; stdcall;
    function Get_ShowFictiveNodes(out Value: WordBool): HResult; stdcall;
    function Set_ShowFictiveNodes(Value: WordBool): HResult; stdcall;
    function Get_clEmptyNodes(out Value: Integer): HResult; stdcall;
    function Set_clEmptyNodes(Value: Integer): HResult; stdcall;
    function Get_clNormalNodes(out Value: Integer): HResult; stdcall;
    function Set_clNormalNodes(Value: Integer): HResult; stdcall;
    function Get_clPendentNodes(out Value: Integer): HResult; stdcall;
    function Set_clPendentNodes(Value: Integer): HResult; stdcall;
    function Get_clFictiveNodes(out Value: Integer): HResult; stdcall;
    function Set_clFictiveNodes(Value: Integer): HResult; stdcall;
    function Get_NodeLimit(out Value: Double): HResult; stdcall;
    function Set_NodeLimit(Value: Double): HResult; stdcall;
    function Get_NodeShowSize(out Value: Double): HResult; stdcall;
    function Set_NodeShowSize(Value: Double): HResult; stdcall;
  end;

// *********************************************************************//
// Interface: IMap
// Flags:     (256) OleAutomation
// GUID:      {176340CF-264F-11D4-802F-008048E6F41A}
// *********************************************************************//
  IMap = interface(IUnknown)
    ['{176340CF-264F-11D4-802F-008048E6F41A}']
    function Get_MarkerOn(out Value: WordBool): HResult; stdcall;
    function Set_MarkerOn(Value: WordBool): HResult; stdcall;
    function Get_MarkerName(out Value: WideString): HResult; stdcall;
    function Set_MarkerName(const Value: WideString): HResult; stdcall;
    function Get_AddressFile(out Value: WideString): HResult; stdcall;
    function Set_AddressFile(const Value: WideString): HResult; stdcall;
    function Get_FindScale(out Value: Double): HResult; stdcall;
    function Set_FindScale(Value: Double): HResult; stdcall;
    function Get_XYFormat(out Value: WideString): HResult; stdcall;
    function Set_XYFormat(const Value: WideString): HResult; stdcall;
    function GetMapExt(Num: Integer; Scale: Integer; out AX: Double; out AY: Double; 
                       out BX: Double; out BY: Double): HResult; stdcall;
    function GetMapNum(X: Double; Y: Double; Scale: Integer; out Num: Integer): HResult; stdcall;
    function GetMapTitle(Num: Integer; Scale: Integer; out Title: WideString): HResult; stdcall;
    function GetScaleAndNum(const Title: WideString; out Scale: Integer; out Num: Integer): HResult; stdcall;
    function Get_Extent(out Value: IRect): HResult; stdcall;
    function Set_Extent(const Value: IRect): HResult; stdcall;
    function Get_ViewPort(out Value: IRect): HResult; stdcall;
    function Set_ViewPort(const Value: IRect): HResult; stdcall;
    function Get_UseLinesLib(out Value: WordBool): HResult; stdcall;
    function Set_UseLinesLib(Value: WordBool): HResult; stdcall;
    function Get_TopologySettings(out Value: ITopologySettings): HResult; stdcall;
    function Get_Title(out Value: WideString): HResult; stdcall;
    function Set_Title(const Value: WideString): HResult; stdcall;
    function AngleToStr(Value: Double; out Value1: WideString): HResult; stdcall;
    function MarkerShape(const aShapeName: WideString; out Value: IShape): HResult; stdcall;
    function Get_Layers(out Value: ILayers): HResult; stdcall;
    function AllExtent(out Value: IRect): HResult; stdcall;
    function Application(out Value: IApplication): HResult; stdcall;
    function ShowDlg(out Value: WordBool): HResult; stdcall;
    function Get_ID(out Value: Integer): HResult; stdcall;
    function Get_Active(out Value: WordBool): HResult; stdcall;
    function Set_Active(Value: WordBool): HResult; stdcall;
    function Get_MiniMapLayers(out Value: WideString): HResult; stdcall;
    function Set_MiniMapLayers(const Value: WideString): HResult; stdcall;
    function SetCustomTool(const Value: ICustomTool): HResult; stdcall;
    function Repaint: HResult; stdcall;
    function RepaintTool: HResult; stdcall;
    function RepaintRect(AX: Double; AY: Double; BX: Double; BY: Double): HResult; stdcall;
    function Get_Errors(out Value: IErrors): HResult; stdcall;
    function Get_FileName(out Value: WideString): HResult; stdcall;
    function Get_MinScale(out Value: Double): HResult; stdcall;
    function Set_MinScale(Value: Double): HResult; stdcall;
    function Get_LibraryFile(out Value: WideString): HResult; stdcall;
    function Set_LibraryFile(const Value: WideString): HResult; stdcall;
    function Get_MaxScale(out Value: Double): HResult; stdcall;
    function Set_MaxScale(Value: Double): HResult; stdcall;
    function Get_Scale(out Value: Double): HResult; stdcall;
    function Set_Scale(Value: Double): HResult; stdcall;
  end;

// *********************************************************************//
// Interface: IMaps
// Flags:     (256) OleAutomation
// GUID:      {176340D1-264F-11D4-802F-008048E6F41A}
// *********************************************************************//
  IMaps = interface(IUnknown)
    ['{176340D1-264F-11D4-802F-008048E6F41A}']
    function Get_Items(Index: Integer; out Value: IMap): HResult; stdcall;
    function ItemCount(out Value: Integer): HResult; stdcall;
  end;

// *********************************************************************//
// Interface: IApplication
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {DB7557B2-CFE8-11D3-BFC3-008048E6F41A}
// *********************************************************************//
  IApplication = interface(IDispatch)
    ['{DB7557B2-CFE8-11D3-BFC3-008048E6F41A}']
    function ExecCommand(const Value: WideString): WideString; safecall;
    function Get_Maps: IMaps; safecall;
    function CreateLayer: ILayer; safecall;
    procedure DoChangeMap(const Obj: IMap; Rebuild: WordBool); safecall;
    procedure DoChangeLayer(const Obj: ILayer; Rebuild: WordBool); safecall;
    procedure DoChangeSymbol(const Obj: ISymbol; Rebuild: WordBool); safecall;
    function Get_ActiveMap: IMap; safecall;
    procedure Set_ActiveMap(const Value: IMap); safecall;
    function Get_Tabs: ITabs; safecall;
    function CreatePoint: IPoint; safecall;
    function CreateRect: IRect; safecall;
    function CreatePoints: IPoints; safecall;
    procedure InfoWindowClear; safecall;
    procedure InfoWindowAdd(const Value: IShape); safecall;
    procedure ShowMessage(Index: Integer; const Value: WideString); safecall;
    property Maps: IMaps read Get_Maps;
    property ActiveMap: IMap read Get_ActiveMap write Set_ActiveMap;
    property Tabs: ITabs read Get_Tabs;
  end;

// *********************************************************************//
// DispIntf:  IApplicationDisp
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {DB7557B2-CFE8-11D3-BFC3-008048E6F41A}
// *********************************************************************//
  IApplicationDisp = dispinterface
    ['{DB7557B2-CFE8-11D3-BFC3-008048E6F41A}']
    function ExecCommand(const Value: WideString): WideString; dispid 1;
    property Maps: IMaps readonly dispid 3;
    function CreateLayer: ILayer; dispid 6;
    procedure DoChangeMap(const Obj: IMap; Rebuild: WordBool); dispid 13;
    procedure DoChangeLayer(const Obj: ILayer; Rebuild: WordBool); dispid 14;
    procedure DoChangeSymbol(const Obj: ISymbol; Rebuild: WordBool); dispid 15;
    property ActiveMap: IMap dispid 2;
    property Tabs: ITabs readonly dispid 16;
    function CreatePoint: IPoint; dispid 4;
    function CreateRect: IRect; dispid 5;
    function CreatePoints: IPoints; dispid 17;
    procedure InfoWindowClear; dispid 7;
    procedure InfoWindowAdd(const Value: IShape); dispid 8;
    procedure ShowMessage(Index: Integer; const Value: WideString); dispid 9;
  end;

// *********************************************************************//
// Interface: ILibrary
// Flags:     (256) OleAutomation
// GUID:      {B9D4F0C1-2FCD-11D4-8039-008048E6F41A}
// *********************************************************************//
  ILibrary = interface(IUnknown)
    ['{B9D4F0C1-2FCD-11D4-8039-008048E6F41A}']
    function Get_FileName(out Value: WideString): HResult; stdcall;
    function Set_FileName(const Value: WideString): HResult; stdcall;
    function Get_Count(out Value: Integer): HResult; stdcall;
    function Get_Shapes(Index: Integer; out Value: IShape): HResult; stdcall;
    function Get_Names(Index: Integer; out Value: WideString): HResult; stdcall;
    function IndexOf(const Value: WideString; out Value1: Integer): HResult; stdcall;
    function Save: HResult; stdcall;
    function Get_ExtentX(out Value: Double): HResult; stdcall;
    function Set_ExtentX(Value: Double): HResult; stdcall;
    function Get_ExtentY(out Value: Double): HResult; stdcall;
    function Set_ExtentY(Value: Double): HResult; stdcall;
  end;

// *********************************************************************//
// Interface: IField
// Flags:     (256) OleAutomation
// GUID:      {9E9ED25E-45EE-11D4-8054-008048E6F41A}
// *********************************************************************//
  IField = interface(IUnknown)
    ['{9E9ED25E-45EE-11D4-8054-008048E6F41A}']
    function Get_Name(out Value: WideString): HResult; stdcall;
    function Get_Value(out Value: OleVariant): HResult; stdcall;
    function Set_Value(Value: OleVariant): HResult; stdcall;
    function Get_Labeled(out Value: WordBool): HResult; stdcall;
    function Set_Labeled(Value: WordBool): HResult; stdcall;
    function Get_Visible(out Value: WordBool): HResult; stdcall;
    function Set_Visible(Value: WordBool): HResult; stdcall;
    function Get_AsString(out Value: WideString): HResult; stdcall;
    function Set_AsString(const Value: WideString): HResult; stdcall;
    function Get_DataType(out Value: Integer): HResult; stdcall;
    function Set_DataType(Value: Integer): HResult; stdcall;
  end;

// *********************************************************************//
// Interface: IFields
// Flags:     (256) OleAutomation
// GUID:      {9E9ED260-45EE-11D4-8054-008048E6F41A}
// *********************************************************************//
  IFields = interface(IUnknown)
    ['{9E9ED260-45EE-11D4-8054-008048E6F41A}']
    function Get_Items(Index: Integer; out Value: IField): HResult; stdcall;
    function Get_Count(out Value: Integer): HResult; stdcall;
    function UpdateValues: HResult; stdcall;
    function Get_AsString(out Value: WideString): HResult; stdcall;
    function Set_AsString(const Value: WideString): HResult; stdcall;
    function ByName(const Value: WideString; out Value1: IField): HResult; stdcall;
    function Get_Assigned(out Value: WordBool): HResult; stdcall;
    function Get_Delimiter(out Value: Integer): HResult; stdcall;
    function Set_Delimiter(Value: Integer): HResult; stdcall;
    function SelectFieldsDlg(var aFields: WideString; Delimiter: Byte; out Value: WordBool): HResult; stdcall;
  end;

// *********************************************************************//
// Interface: IApplicationEvents
// Flags:     (320) Dual OleAutomation
// GUID:      {1E828BE4-87D8-11D4-80AD-008048E6F41A}
// *********************************************************************//
  IApplicationEvents = interface(IUnknown)
    ['{1E828BE4-87D8-11D4-80AD-008048E6F41A}']
    function OnClose: HResult; safecall;
    procedure OnChangeMap(const Obj: IMap; Rebuild: WordBool); safecall;
    procedure OnChangeLayer(const Obj: ILayer; Rebuild: WordBool); safecall;
    procedure OnChangeSymbol(const Obj: ISymbol; Rebuild: WordBool); safecall;
  end;

// *********************************************************************//
// DispIntf:  IApplicationEventsDisp
// Flags:     (320) Dual OleAutomation
// GUID:      {1E828BE4-87D8-11D4-80AD-008048E6F41A}
// *********************************************************************//
  IApplicationEventsDisp = dispinterface
    ['{1E828BE4-87D8-11D4-80AD-008048E6F41A}']
    function OnClose: HResult; dispid 1;
    procedure OnChangeMap(const Obj: IMap; Rebuild: WordBool); dispid 2;
    procedure OnChangeLayer(const Obj: ILayer; Rebuild: WordBool); dispid 3;
    procedure OnChangeSymbol(const Obj: ISymbol; Rebuild: WordBool); dispid 4;
  end;

// *********************************************************************//
// Interface: ICustomTool
// Flags:     (256) OleAutomation
// GUID:      {0B276FF0-B15F-11D4-80DB-008048E6F41A}
// *********************************************************************//
  ICustomTool = interface(IUnknown)
    ['{0B276FF0-B15F-11D4-80DB-008048E6F41A}']
    function MouseDown(X: Double; Y: Double; Shift: Word): HResult; stdcall;
    function MouseMove(X: Double; Y: Double; Shift: Word): HResult; stdcall;
    function MouseUp: HResult; stdcall;
    function Name(out Value: WideString): HResult; stdcall;
    function GetHint(X: Double; Y: Double; out Value: WideString): HResult; stdcall;
    function ShowHint(out Value: WordBool): HResult; stdcall;
  end;

// *********************************************************************//
// Interface: ITabs
// Flags:     (256) OleAutomation
// GUID:      {BAEDD071-BBB3-11D4-80ED-008048E6F41A}
// *********************************************************************//
  ITabs = interface(IUnknown)
    ['{BAEDD071-BBB3-11D4-80ED-008048E6F41A}']
    function Get_Items(Index: Integer; out Value: ITab): HResult; stdcall;
    function ItemCount(out Value: Integer): HResult; stdcall;
  end;

// *********************************************************************//
// Interface: ITab
// Flags:     (256) OleAutomation
// GUID:      {BD7EB5BD-BBC9-11D4-80ED-008048E6F41A}
// *********************************************************************//
  ITab = interface(IUnknown)
    ['{BD7EB5BD-BBC9-11D4-80ED-008048E6F41A}']
    function Get_TableName(out Value: WideString): HResult; stdcall;
    function Get_Fields(out Value: IFields): HResult; stdcall;
    function FindKey(Value: Integer; out Value1: WordBool): HResult; stdcall;
    function Lock: HResult; stdcall;
    function UnLock: HResult; stdcall;
    function Get_Active(out Value: WordBool): HResult; stdcall;
    function Set_Active(Value: WordBool): HResult; stdcall;
    function Get_Caption(out Value: WideString): HResult; stdcall;
  end;

// *********************************************************************//
// Interface: ITopology
// Flags:     (256) OleAutomation
// GUID:      {068FB311-BEE1-11D4-80F2-008048E6F41A}
// *********************************************************************//
  ITopology = interface(IUnknown)
    ['{068FB311-BEE1-11D4-80F2-008048E6F41A}']
    function NearestNode(X: Double; Y: Double; out Value: IShapeTopoNode): HResult; stdcall;
    function CreatePoints(Nodes: OleVariant; out Value: IPoints): HResult; stdcall;
  end;

// *********************************************************************//
// Interface: ICustomTool2
// Flags:     (256) OleAutomation
// GUID:      {09028DAE-F373-11D4-811D-008048E6F41A}
// *********************************************************************//
  ICustomTool2 = interface(ICustomTool)
    ['{09028DAE-F373-11D4-811D-008048E6F41A}']
    function Get_InverseShape(out Value: IShape): HResult; stdcall;
    function Get_SolidShape(out Value: IShape): HResult; stdcall;
  end;

// *********************************************************************//
// The Class CoMapApp provides a Create and CreateRemote method to          
// create instances of the default interface IApplication exposed by              
// the CoClass MapApp. The functions are intended to be used by             
// clients wishing to automate the CoClass objects exposed by the         
// server of this typelibrary.                                            
// *********************************************************************//
  CoMapApp = class
    class function Create: IApplication;
    class function CreateRemote(const MachineName: string): IApplication;
  end;


// *********************************************************************//
// OLE Server Proxy class declaration
// Server Object    : TMapApp
// Help String      : MapAuto Object
// Default Interface: IApplication
// Def. Intf. DISP? : No
// Event   Interface: 
// TypeFlags        : (2) CanCreate
// *********************************************************************//
{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
  TMapAppProperties= class;
{$ENDIF}
  TMapApp = class(TOleServer)
  private
    FIntf:        IApplication;
{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
    FProps:       TMapAppProperties;
    function      GetServerProperties: TMapAppProperties;
{$ENDIF}
    function      GetDefaultInterface: IApplication;
  protected
    procedure InitServerData; override;
    function Get_Maps: IMaps;
    function Get_ActiveMap: IMap;
    procedure Set_ActiveMap(const Value: IMap);
    function Get_Tabs: ITabs;
  public
    constructor Create(AOwner: TComponent); override;
    destructor  Destroy; override;
    procedure Connect; override;
    procedure ConnectTo(svrIntf: IApplication);
    procedure Disconnect; override;
    function ExecCommand(const Value: WideString): WideString;
    function CreateLayer: ILayer;
    procedure DoChangeMap(const Obj: IMap; Rebuild: WordBool);
    procedure DoChangeLayer(const Obj: ILayer; Rebuild: WordBool);
    procedure DoChangeSymbol(const Obj: ISymbol; Rebuild: WordBool);
    function CreatePoint: IPoint;
    function CreateRect: IRect;
    function CreatePoints: IPoints;
    procedure InfoWindowClear;
    procedure InfoWindowAdd(const Value: IShape);
    procedure ShowMessage(Index: Integer; const Value: WideString);
    property DefaultInterface: IApplication read GetDefaultInterface;
    property Maps: IMaps read Get_Maps;
    property Tabs: ITabs read Get_Tabs;
    property ActiveMap: IMap read Get_ActiveMap write Set_ActiveMap;
  published
{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
    property Server: TMapAppProperties read GetServerProperties;
{$ENDIF}
  end;

{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
// *********************************************************************//
// OLE Server Properties Proxy Class
// Server Object    : TMapApp
// (This object is used by the IDE's Property Inspector to allow editing
//  of the properties of this server)
// *********************************************************************//
 TMapAppProperties = class(TPersistent)
  private
    FServer:    TMapApp;
    function    GetDefaultInterface: IApplication;
    constructor Create(AServer: TMapApp);
  protected
    function Get_Maps: IMaps;
    function Get_ActiveMap: IMap;
    procedure Set_ActiveMap(const Value: IMap);
    function Get_Tabs: ITabs;
  public
    property DefaultInterface: IApplication read GetDefaultInterface;
  published
    property ActiveMap: IMap read Get_ActiveMap write Set_ActiveMap;
  end;
{$ENDIF}


procedure Register;

resourcestring
  dtlServerPage = 'ActiveX';

  dtlOcxPage = 'ActiveX';

implementation

uses ComObj;

class function CoMapApp.Create: IApplication;
begin
  Result := CreateComObject(CLASS_MapApp) as IApplication;
end;

class function CoMapApp.CreateRemote(const MachineName: string): IApplication;
begin
  Result := CreateRemoteComObject(MachineName, CLASS_MapApp) as IApplication;
end;

procedure TMapApp.InitServerData;
const
  CServerData: TServerData = (
    ClassID:   '{DB7557B6-CFE8-11D3-BFC3-008048E6F41A}';
    IntfIID:   '{DB7557B2-CFE8-11D3-BFC3-008048E6F41A}';
    EventIID:  '';
    LicenseKey: nil;
    Version: 500);
begin
  ServerData := @CServerData;
end;

procedure TMapApp.Connect;
var
  punk: IUnknown;
begin
  if FIntf = nil then
  begin
    punk := GetServer;
    Fintf:= punk as IApplication;
  end;
end;

procedure TMapApp.ConnectTo(svrIntf: IApplication);
begin
  Disconnect;
  FIntf := svrIntf;
end;

procedure TMapApp.DisConnect;
begin
  if Fintf <> nil then
  begin
    FIntf := nil;
  end;
end;

function TMapApp.GetDefaultInterface: IApplication;
begin
  if FIntf = nil then
    Connect;
  Assert(FIntf <> nil, 'DefaultInterface is NULL. Component is not connected to Server. You must call ''Connect'' or ''ConnectTo'' before this operation');
  Result := FIntf;
end;

constructor TMapApp.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
  FProps := TMapAppProperties.Create(Self);
{$ENDIF}
end;

destructor TMapApp.Destroy;
begin
{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
  FProps.Free;
{$ENDIF}
  inherited Destroy;
end;

{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
function TMapApp.GetServerProperties: TMapAppProperties;
begin
  Result := FProps;
end;
{$ENDIF}

function TMapApp.Get_Maps: IMaps;
begin
    Result := DefaultInterface.Maps;
end;

function TMapApp.Get_ActiveMap: IMap;
begin
    Result := DefaultInterface.ActiveMap;
end;

procedure TMapApp.Set_ActiveMap(const Value: IMap);
begin
  DefaultInterface.Set_ActiveMap(Value);
end;

function TMapApp.Get_Tabs: ITabs;
begin
    Result := DefaultInterface.Tabs;
end;

function TMapApp.ExecCommand(const Value: WideString): WideString;
begin
  Result := DefaultInterface.ExecCommand(Value);
end;

function TMapApp.CreateLayer: ILayer;
begin
  Result := DefaultInterface.CreateLayer;
end;

procedure TMapApp.DoChangeMap(const Obj: IMap; Rebuild: WordBool);
begin
  DefaultInterface.DoChangeMap(Obj, Rebuild);
end;

procedure TMapApp.DoChangeLayer(const Obj: ILayer; Rebuild: WordBool);
begin
  DefaultInterface.DoChangeLayer(Obj, Rebuild);
end;

procedure TMapApp.DoChangeSymbol(const Obj: ISymbol; Rebuild: WordBool);
begin
  DefaultInterface.DoChangeSymbol(Obj, Rebuild);
end;

function TMapApp.CreatePoint: IPoint;
begin
  Result := DefaultInterface.CreatePoint;
end;

function TMapApp.CreateRect: IRect;
begin
  Result := DefaultInterface.CreateRect;
end;

function TMapApp.CreatePoints: IPoints;
begin
  Result := DefaultInterface.CreatePoints;
end;

procedure TMapApp.InfoWindowClear;
begin
  DefaultInterface.InfoWindowClear;
end;

procedure TMapApp.InfoWindowAdd(const Value: IShape);
begin
  DefaultInterface.InfoWindowAdd(Value);
end;

procedure TMapApp.ShowMessage(Index: Integer; const Value: WideString);
begin
  DefaultInterface.ShowMessage(Index, Value);
end;

{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
constructor TMapAppProperties.Create(AServer: TMapApp);
begin
  inherited Create;
  FServer := AServer;
end;

function TMapAppProperties.GetDefaultInterface: IApplication;
begin
  Result := FServer.DefaultInterface;
end;

function TMapAppProperties.Get_Maps: IMaps;
begin
    Result := DefaultInterface.Maps;
end;

function TMapAppProperties.Get_ActiveMap: IMap;
begin
    Result := DefaultInterface.ActiveMap;
end;

procedure TMapAppProperties.Set_ActiveMap(const Value: IMap);
begin
  DefaultInterface.Set_ActiveMap(Value);
end;

function TMapAppProperties.Get_Tabs: ITabs;
begin
    Result := DefaultInterface.Tabs;
end;

{$ENDIF}

procedure Register;
begin
  RegisterComponents(dtlServerPage, [TMapApp]);
end;

end.
