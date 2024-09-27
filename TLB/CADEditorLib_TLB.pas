unit CADEditorLib_TLB;

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

// $Rev: 8291 $
// File generated on 24.05.2022 16:19:00 from Type Library described below.

// ************************************************************************  //
// Type Lib: C:\Program Files\CADSoftTools\CADEditorX 14\CADEditorLib.ocx (1)
// LIBID: {87E1D10D-44DD-4B1B-A72F-9219D83D8BF3}
// LCID: 0
// Helpfile: 
// HelpString: CADEditorX Library
// DepndLst: 
//   (1) v2.0 stdole, (C:\Windows\system32\stdole2.tlb)
// Errors:
//   Error creating palette bitmap of (TSgCADEditor) : Error reading control bitmap
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

uses Windows, ActiveX, Classes, Graphics, OleCtrls, OleServer, StdVCL, Variants;
  


// *********************************************************************//
// GUIDS declared in the TypeLibrary. Following prefixes are used:        
//   Type Libraries     : LIBID_xxxx                                      
//   CoClasses          : CLASS_xxxx                                      
//   DISPInterfaces     : DIID_xxxx                                       
//   Non-DISP interfaces: IID_xxxx                                        
// *********************************************************************//
const
  // TypeLibrary Major and minor versions
  CADEditorLibMajorVersion = 1;
  CADEditorLibMinorVersion = 0;

  LIBID_CADEditorLib: TGUID = '{87E1D10D-44DD-4B1B-A72F-9219D83D8BF3}';

  IID_ISgCADEditor: TGUID = '{71CC3B83-5821-4476-A8B6-A1C55B0A0B1C}';
  DIID_ISgCADEditorEvents: TGUID = '{1E79ED66-1F5E-444F-90F0-6AD076AD3E77}';
  CLASS_SgCADEditor: TGUID = '{7117DFC1-AD2A-46C9-80E0-1105FF21F19B}';
  IID_IsgStringConverter: TGUID = '{E521A72D-9E45-459B-9F75-915D377BCCDB}';
type

// *********************************************************************//
// Forward declaration of types defined in TypeLibrary                    
// *********************************************************************//
  ISgCADEditor = interface;
  ISgCADEditorDisp = dispinterface;
  ISgCADEditorEvents = dispinterface;
  IsgStringConverter = interface;

// *********************************************************************//
// Declaration of CoClasses defined in Type Library                       
// (NOTE: Here we map each CoClass to its Default Interface)              
// *********************************************************************//
  SgCADEditor = ISgCADEditor;


// *********************************************************************//
// Interface: ISgCADEditor
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {71CC3B83-5821-4476-A8B6-A1C55B0A0B1C}
// *********************************************************************//
  ISgCADEditor = interface(IDispatch)
    ['{71CC3B83-5821-4476-A8B6-A1C55B0A0B1C}']
    function ProcessXML(const AInput: WideString): WideString; safecall;
    function Converter: IsgStringConverter; safecall;
  end;

// *********************************************************************//
// DispIntf:  ISgCADEditorDisp
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {71CC3B83-5821-4476-A8B6-A1C55B0A0B1C}
// *********************************************************************//
  ISgCADEditorDisp = dispinterface
    ['{71CC3B83-5821-4476-A8B6-A1C55B0A0B1C}']
    function ProcessXML(const AInput: WideString): WideString; dispid 201;
    function Converter: IsgStringConverter; dispid 202;
  end;

// *********************************************************************//
// DispIntf:  ISgCADEditorEvents
// Flags:     (4096) Dispatchable
// GUID:      {1E79ED66-1F5E-444F-90F0-6AD076AD3E77}
// *********************************************************************//
  ISgCADEditorEvents = dispinterface
    ['{1E79ED66-1F5E-444F-90F0-6AD076AD3E77}']
    procedure OnProcess(const AXML: WideString); dispid 224;
  end;

// *********************************************************************//
// Interface: IsgStringConverter
// Flags:     (4352) OleAutomation Dispatchable
// GUID:      {E521A72D-9E45-459B-9F75-915D377BCCDB}
// *********************************************************************//
  IsgStringConverter = interface(IDispatch)
    ['{E521A72D-9E45-459B-9F75-915D377BCCDB}']
    function StrToDouble(const AStr: WideString; out ADbl: Double): HResult; stdcall;
    function StrToFPoint(const AStr: WideString; out AX: Double; out AY: Double; out AZ: Double): HResult; stdcall;
    function DoubleToStr(ADbl: Double; out AStr: WideString): HResult; stdcall;
    function FPointToStr(AX: Double; AY: Double; AZ: Double; out AStr: WideString): HResult; stdcall;
    function StrToColorCAD(const AStr: WideString; out ClrType: Shortint; out ClrValue: Integer): HResult; stdcall;
    function ColorCADToStr(ClrType: Shortint; ClrValue: Integer; out AStr: WideString): HResult; stdcall;
    function StrToHandle(const AStr: WideString; out AHandle: Largeuint): HResult; stdcall;
    function HandleToStr(AHandle: Largeuint; out AStr: WideString): HResult; stdcall;
    function StrToBool(const AStr: WideString; out ABool: Shortint): HResult; stdcall;
    function BoolToStr(ABool: Shortint; out AStr: WideString): HResult; stdcall;
    function StrToInt32(const AStr: WideString; out AInt: SYSINT): HResult; stdcall;
    function Int32ToStr(AInt: SYSINT; out AStr: WideString): HResult; stdcall;
    function StrToFRect(const AStr: WideString; out ALeft: Double; out ATop: Double; 
                        out AZ1: Double; out ARight: Double; out ABottom: Double; out AZ2: Double): HResult; stdcall;
    function FRectToStr(ALeft: Double; ATop: Double; AZ1: Double; ARight: Double; ABottom: Double; 
                        AZ2: Double; out AStr: WideString): HResult; stdcall;
    function StrToF2DRect(const AStr: WideString; out ALeft: Double; out ATop: Double; 
                          out ARight: Double; out ABottom: Double): HResult; stdcall;
    function F2DRectToStr(ALeft: Double; ATop: Double; ARight: Double; ABottom: Double; 
                          out AStr: WideString): HResult; stdcall;
    function StrToDoubleList(const AStr: WideString; out AList: OleVariant): HResult; stdcall;
    function DoubleListToStr(AList: OleVariant; out AStr: WideString): HResult; stdcall;
  end;


// *********************************************************************//
// OLE Control Proxy class declaration
// Control Name     : TSgCADEditor
// Help String      : SgCADEditor Object
// Default Interface: ISgCADEditor
// Def. Intf. DISP? : No
// Event   Interface: ISgCADEditorEvents
// TypeFlags        : (34) CanCreate Control
// *********************************************************************//
  TSgCADEditorOnProcess = procedure(ASender: TObject; const AXML: WideString) of object;

  TSgCADEditor = class(TOleControl)
  private
    FOnProcess: TSgCADEditorOnProcess;
    FIntf: ISgCADEditor;
    function  GetControlInterface: ISgCADEditor;
  protected
    procedure CreateControl;
    procedure InitControlData; override;
  public
    function ProcessXML(const AInput: WideString): WideString;
    function Converter: IsgStringConverter;
    property  ControlInterface: ISgCADEditor read GetControlInterface;
    property  DefaultInterface: ISgCADEditor read GetControlInterface;
  published
    property Anchors;
    property  Align;
    property  DragCursor;
    property  DragMode;
    property  ParentShowHint;
    property  PopupMenu;
    property  ShowHint;
    property  TabOrder;
    property  Visible;
    property  OnDragDrop;
    property  OnDragOver;
    property  OnEndDrag;
    property  OnEnter;
    property  OnExit;
    property  OnStartDrag;
    property OnProcess: TSgCADEditorOnProcess read FOnProcess write FOnProcess;
  end;

procedure Register;

resourcestring
  dtlServerPage = '(none)';

  dtlOcxPage = '(none)';

implementation

uses ComObj;

procedure TSgCADEditor.InitControlData;
const
  CEventDispIDs: array [0..0] of DWORD = (
    $000000E0);
  CControlData: TControlData2 = (
    ClassID: '{7117DFC1-AD2A-46C9-80E0-1105FF21F19B}';
    EventIID: '{1E79ED66-1F5E-444F-90F0-6AD076AD3E77}';
    EventCount: 1;
    EventDispIDs: @CEventDispIDs;
    LicenseKey: nil (*HR:$00000000*);
    Flags: $00000000;
    Version: 401);
begin
  ControlData := @CControlData;
  TControlData2(CControlData).FirstEventOfs := Cardinal(@@FOnProcess) - Cardinal(Self);
end;

procedure TSgCADEditor.CreateControl;

  procedure DoCreate;
  begin
    FIntf := IUnknown(OleObject) as ISgCADEditor;
  end;

begin
  if FIntf = nil then DoCreate;
end;

function TSgCADEditor.GetControlInterface: ISgCADEditor;
begin
  CreateControl;
  Result := FIntf;
end;

function TSgCADEditor.ProcessXML(const AInput: WideString): WideString;
begin
  Result := DefaultInterface.ProcessXML(AInput);
end;

function TSgCADEditor.Converter: IsgStringConverter;
begin
  Result := DefaultInterface.Converter;
end;

procedure Register;
begin
  RegisterComponents(dtlOcxPage, [TSgCADEditor]);
end;

end.
