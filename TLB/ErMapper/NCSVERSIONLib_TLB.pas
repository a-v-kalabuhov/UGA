unit NCSVERSIONLib_TLB;

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

// PASTLWTR : $Revision:   1.130.1.0.1.0.1.6  $
// File generated on 17.02.2003 11:42:19 from Type Library described below.

// ************************************************************************  //
// Type Lib: C:\Program Files\Earth Resource Mapping\Image Web Server\Client\NCSVer.dll (1)
// LIBID: {76A2A0AB-38B7-46DB-8E47-F10CDE4D7920}
// LCID: 0
// Helpfile: 
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
  NCSVERSIONLibMajorVersion = 1;
  NCSVERSIONLibMinorVersion = 5;

  LIBID_NCSVERSIONLib: TGUID = '{76A2A0AB-38B7-46DB-8E47-F10CDE4D7920}';

  IID_INCSVersion: TGUID = '{EFE7654F-79A7-45C8-8083-2E86FE0A25B8}';
  CLASS_NCSVersion: TGUID = '{DCE3340D-3568-4883-8B15-F6E296BC9445}';
type

// *********************************************************************//
// Forward declaration of types defined in TypeLibrary                    
// *********************************************************************//
  INCSVersion = interface;
  INCSVersionDisp = dispinterface;

// *********************************************************************//
// Declaration of CoClasses defined in Type Library                       
// (NOTE: Here we map each CoClass to its Default Interface)              
// *********************************************************************//
  NCSVersion = INCSVersion;


// *********************************************************************//
// Interface: INCSVersion
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {EFE7654F-79A7-45C8-8083-2E86FE0A25B8}
// *********************************************************************//
  INCSVersion = interface(IDispatch)
    ['{EFE7654F-79A7-45C8-8083-2E86FE0A25B8}']
    function GetVersionString(const pControlName: WideString): WideString; safecall;
  end;

// *********************************************************************//
// DispIntf:  INCSVersionDisp
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {EFE7654F-79A7-45C8-8083-2E86FE0A25B8}
// *********************************************************************//
  INCSVersionDisp = dispinterface
    ['{EFE7654F-79A7-45C8-8083-2E86FE0A25B8}']
    function GetVersionString(const pControlName: WideString): WideString; dispid 1;
  end;


// *********************************************************************//
// OLE Control Proxy class declaration
// Control Name     : TNCSVersion
// Help String      : NCSVersion Class
// Default Interface: INCSVersion
// Def. Intf. DISP? : No
// Event   Interface: 
// TypeFlags        : (2) CanCreate
// *********************************************************************//
  TNCSVersion = class(TOleControl)
  private
    FIntf: INCSVersion;
    function  GetControlInterface: INCSVersion;
  protected
    procedure CreateControl;
    procedure InitControlData; override;
  public
    function GetVersionString(const pControlName: WideString): WideString;
    property  ControlInterface: INCSVersion read GetControlInterface;
    property  DefaultInterface: INCSVersion read GetControlInterface;
  published
    property  TabStop;
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
  end;

procedure Register;

resourcestring
  dtlServerPage = 'ActiveX';

implementation

uses ComObj;

procedure TNCSVersion.InitControlData;
const
  CControlData: TControlData2 = (
    ClassID: '{DCE3340D-3568-4883-8B15-F6E296BC9445}';
    EventIID: '';
    EventCount: 0;
    EventDispIDs: nil;
    LicenseKey: nil (*HR:$80004002*);
    Flags: $00000000;
    Version: 401);
begin
  ControlData := @CControlData;
end;

procedure TNCSVersion.CreateControl;

  procedure DoCreate;
  begin
    FIntf := IUnknown(OleObject) as INCSVersion;
  end;

begin
  if FIntf = nil then DoCreate;
end;

function TNCSVersion.GetControlInterface: INCSVersion;
begin
  CreateControl;
  Result := FIntf;
end;

function TNCSVersion.GetVersionString(const pControlName: WideString): WideString;
begin
  Result := DefaultInterface.GetVersionString(pControlName);
end;

procedure Register;
begin
  RegisterComponents('ActiveX',[TNCSVersion]);
end;

end.
