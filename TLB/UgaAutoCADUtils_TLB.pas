unit UgaAutoCADUtils_TLB;

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
// File generated on 24.05.2022 16:00:29 from Type Library described below.

// ************************************************************************  //
// Type Lib: c:\Projects\kis\kis\Exe\UgaAutoCADUtils.tlb (1)
// LIBID: {D4A6FDFE-7AE5-40CB-AE4D-CC27C7A08201}
// LCID: 0
// Helpfile: 
// HelpString: 
// DepndLst: 
//   (1) v2.0 stdole, (C:\Windows\system32\stdole2.tlb)
//   (2) v2.0 mscorlib, (C:\Windows\Microsoft.NET\Framework\v2.0.50727\mscorlib.tlb)
// Errors:
//   Error creating palette bitmap of (TDwgFile) : Server mscoree.dll contains no icons
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

uses Windows, ActiveX, Classes, Graphics, mscorlib_TLB, OleServer, StdVCL, Variants;
  


// *********************************************************************//
// GUIDS declared in the TypeLibrary. Following prefixes are used:        
//   Type Libraries     : LIBID_xxxx                                      
//   CoClasses          : CLASS_xxxx                                      
//   DISPInterfaces     : DIID_xxxx                                       
//   Non-DISP interfaces: IID_xxxx                                        
// *********************************************************************//
const
  // TypeLibrary Major and minor versions
  UgaAutoCADUtilsMajorVersion = 1;
  UgaAutoCADUtilsMinorVersion = 2;

  LIBID_UgaAutoCADUtils: TGUID = '{D4A6FDFE-7AE5-40CB-AE4D-CC27C7A08201}';

  IID_IDwgFile: TGUID = '{556ED5A2-66EB-40F7-A5CE-D44F6E287713}';
  CLASS_DwgFile: TGUID = '{5F89F794-64D7-49A0-B895-6057390B2149}';
type

// *********************************************************************//
// Forward declaration of types defined in TypeLibrary                    
// *********************************************************************//
  IDwgFile = interface;
  IDwgFileDisp = dispinterface;

// *********************************************************************//
// Declaration of CoClasses defined in Type Library                       
// (NOTE: Here we map each CoClass to its Default Interface)              
// *********************************************************************//
  DwgFile = IDwgFile;


// *********************************************************************//
// Interface: IDwgFile
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {556ED5A2-66EB-40F7-A5CE-D44F6E287713}
// *********************************************************************//
  IDwgFile = interface(IDispatch)
    ['{556ED5A2-66EB-40F7-A5CE-D44F6E287713}']
    procedure Open(const fileName: WideString); safecall;
    procedure Save(const fileName: WideString); safecall;
    procedure AddMap(const layerName: WideString; const nomenclature: WideString; x: Integer; 
                     y: Integer); safecall;
    procedure AddRaster(const rasterFileName: WideString; x: Integer; y: Integer; 
                        checkExists: WordBool); safecall;
    function RegisterLicense: WideString; safecall;
  end;

// *********************************************************************//
// DispIntf:  IDwgFileDisp
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {556ED5A2-66EB-40F7-A5CE-D44F6E287713}
// *********************************************************************//
  IDwgFileDisp = dispinterface
    ['{556ED5A2-66EB-40F7-A5CE-D44F6E287713}']
    procedure Open(const fileName: WideString); dispid 1610743808;
    procedure Save(const fileName: WideString); dispid 1610743809;
    procedure AddMap(const layerName: WideString; const nomenclature: WideString; x: Integer; 
                     y: Integer); dispid 1610743810;
    procedure AddRaster(const rasterFileName: WideString; x: Integer; y: Integer; 
                        checkExists: WordBool); dispid 1610743811;
    function RegisterLicense: WideString; dispid 1610743812;
  end;

// *********************************************************************//
// The Class CoDwgFile provides a Create and CreateRemote method to          
// create instances of the default interface IDwgFile exposed by              
// the CoClass DwgFile. The functions are intended to be used by             
// clients wishing to automate the CoClass objects exposed by the         
// server of this typelibrary.                                            
// *********************************************************************//
  CoDwgFile = class
    class function Create: IDwgFile;
    class function CreateRemote(const MachineName: string): IDwgFile;
  end;


// *********************************************************************//
// OLE Server Proxy class declaration
// Server Object    : TDwgFile
// Help String      : 
// Default Interface: IDwgFile
// Def. Intf. DISP? : No
// Event   Interface: 
// TypeFlags        : (2) CanCreate
// *********************************************************************//
{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
  TDwgFileProperties= class;
{$ENDIF}
  TDwgFile = class(TOleServer)
  private
    FIntf: IDwgFile;
{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
    FProps: TDwgFileProperties;
    function GetServerProperties: TDwgFileProperties;
{$ENDIF}
    function GetDefaultInterface: IDwgFile;
  protected
    procedure InitServerData; override;
  public
    constructor Create(AOwner: TComponent); override;
    destructor  Destroy; override;
    procedure Connect; override;
    procedure ConnectTo(svrIntf: IDwgFile);
    procedure Disconnect; override;
    procedure Open(const fileName: WideString);
    procedure Save(const fileName: WideString);
    procedure AddMap(const layerName: WideString; const nomenclature: WideString; x: Integer; 
                     y: Integer);
    procedure AddRaster(const rasterFileName: WideString; x: Integer; y: Integer; 
                        checkExists: WordBool);
    function RegisterLicense: WideString;
    property DefaultInterface: IDwgFile read GetDefaultInterface;
  published
{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
    property Server: TDwgFileProperties read GetServerProperties;
{$ENDIF}
  end;

{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
// *********************************************************************//
// OLE Server Properties Proxy Class
// Server Object    : TDwgFile
// (This object is used by the IDE's Property Inspector to allow editing
//  of the properties of this server)
// *********************************************************************//
 TDwgFileProperties = class(TPersistent)
  private
    FServer:    TDwgFile;
    function    GetDefaultInterface: IDwgFile;
    constructor Create(AServer: TDwgFile);
  protected
  public
    property DefaultInterface: IDwgFile read GetDefaultInterface;
  published
  end;
{$ENDIF}


procedure Register;

resourcestring
  dtlServerPage = '(none)';

  dtlOcxPage = '(none)';

implementation

uses ComObj;

class function CoDwgFile.Create: IDwgFile;
begin
  Result := CreateComObject(CLASS_DwgFile) as IDwgFile;
end;

class function CoDwgFile.CreateRemote(const MachineName: string): IDwgFile;
begin
  Result := CreateRemoteComObject(MachineName, CLASS_DwgFile) as IDwgFile;
end;

procedure TDwgFile.InitServerData;
const
  CServerData: TServerData = (
    ClassID:   '{5F89F794-64D7-49A0-B895-6057390B2149}';
    IntfIID:   '{556ED5A2-66EB-40F7-A5CE-D44F6E287713}';
    EventIID:  '';
    LicenseKey: nil;
    Version: 500);
begin
  ServerData := @CServerData;
end;

procedure TDwgFile.Connect;
var
  punk: IUnknown;
begin
  if FIntf = nil then
  begin
    punk := GetServer;
    Fintf:= punk as IDwgFile;
  end;
end;

procedure TDwgFile.ConnectTo(svrIntf: IDwgFile);
begin
  Disconnect;
  FIntf := svrIntf;
end;

procedure TDwgFile.DisConnect;
begin
  if Fintf <> nil then
  begin
    FIntf := nil;
  end;
end;

function TDwgFile.GetDefaultInterface: IDwgFile;
begin
  if FIntf = nil then
    Connect;
  Assert(FIntf <> nil, 'DefaultInterface is NULL. Component is not connected to Server. You must call "Connect" or "ConnectTo" before this operation');
  Result := FIntf;
end;

constructor TDwgFile.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
  FProps := TDwgFileProperties.Create(Self);
{$ENDIF}
end;

destructor TDwgFile.Destroy;
begin
{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
  FProps.Free;
{$ENDIF}
  inherited Destroy;
end;

{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
function TDwgFile.GetServerProperties: TDwgFileProperties;
begin
  Result := FProps;
end;
{$ENDIF}

procedure TDwgFile.Open(const fileName: WideString);
begin
  DefaultInterface.Open(fileName);
end;

procedure TDwgFile.Save(const fileName: WideString);
begin
  DefaultInterface.Save(fileName);
end;

procedure TDwgFile.AddMap(const layerName: WideString; const nomenclature: WideString; x: Integer; 
                          y: Integer);
begin
  DefaultInterface.AddMap(layerName, nomenclature, x, y);
end;

procedure TDwgFile.AddRaster(const rasterFileName: WideString; x: Integer; y: Integer; 
                             checkExists: WordBool);
begin
  DefaultInterface.AddRaster(rasterFileName, x, y, checkExists);
end;

function TDwgFile.RegisterLicense: WideString;
begin
  Result := DefaultInterface.RegisterLicense;
end;

{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
constructor TDwgFileProperties.Create(AServer: TDwgFile);
begin
  inherited Create;
  FServer := AServer;
end;

function TDwgFileProperties.GetDefaultInterface: IDwgFile;
begin
  Result := FServer.DefaultInterface;
end;

{$ENDIF}

procedure Register;
begin
  RegisterComponents(dtlServerPage, [TDwgFile]);
end;

end.
