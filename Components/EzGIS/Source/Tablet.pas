unit Tablet;

{*******************************************}
{  This unit is part of TTablet component   }
{  Copyright © 2001 Mattias Andersson       }
{  See license.txt for license information  }
{*******************************************}
// $Id: Tablet.pas,v 1.1 2001/12/30 01:51:37 Mattias Exp $

interface

uses
  Windows, SysUtils, Messages, Classes, Forms, WintabConsts;

type
  HCtx = type Integer;
  TFixed = type Integer;

  TAxis = record
  	Min: Integer;
    Max: Integer;
  	Units: Cardinal;
  	Resolution: TFixed;
  end;

  TLogContext = record
    Name: string[39];
    Options: Integer;
    Status: Integer;
    Locks: Integer;
    MsgBase: Integer;
    Device: Integer;
    PktRate: Integer;
    PktData: Integer;
    PktMode: Integer;
    MoveMask: Integer;
    BtnDnMask: Integer;
    BtnUpMask: Integer;
    InOrgX: Integer;
    InOrgY: Integer;
    InOrgZ: Integer;
    InExtX: Integer;
    InExtY: Integer;
    InExtZ: Integer;
    OutOrgX: Integer;
    OutOrgY: Integer;
    OutOrgZ: Integer;
    OutExtX: Integer;
    OutExtY: Integer;
    OutExtZ: Integer;
    SensX: TFixed;
    SensY: TFixed;
    SensZ: TFixed;
    SysMode: Boolean;
    SysOrgX: Integer;
    SysOrgY: Integer;
    SysExtX: Integer;
    SysExtY: Integer;
    SysSensX: TFixed;
    SysSensY: TFixed;
  end;

  TString = array[0..100] of char;
  TPacketEvent = procedure(Sender: TObject; PacketNumber, ContextHandle: HCtx;
    pPacket: Pointer) of object;
  TProximityEvent = procedure(Sender: TObject; ContextHandle: HCtx;
    Entering: Boolean) of object;
  TInfoChangedEvent = procedure(Sender: TObject; Manager: THandle;
    Category, Index: Word) of object;
  TContextEvent =  procedure(Sender: TObject; ContextHandle, StatusFlags: Integer) of object;

  TTablet = class(TComponent)
  private
    FOnPacket: TPacketEvent;
    FOnCursorChanged: TPacketEvent;
    FOnProximity: TProximityEvent;
    FOnInfoChanged: TInfoChangedEvent;
    FOnOpenContext: TContextEvent;
    FOnCloseContext: TContextEvent;
    FOnOverlapContext: TContextEvent;
    FOnUpdateContext: TContextEvent;
    FOldWindowProc: Pointer;
    FNewWindowProc: Pointer;
    FDeviceName: string;
    FPacketSize: Byte;
    FPresent: Boolean;
    FEnabled: Boolean;
    FPPacket: Pointer;
    FContextHandle: HCtx;
    FContext: TLogContext;
    WTHandle: THandle;
    procedure NewWindowProc(var Msg: TMessage);
    procedure SetEnabled(Value: Boolean);
    procedure SetPacketSize(Size: Byte);
  protected
    procedure Loaded; override;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure Initialize;
    procedure Open;
    procedure Close;
    function GetContext: Boolean;
    function SetContext: Boolean;
    property Context: TLogContext read FContext write FContext;
    property ContextHandle: HCtx read FContextHandle write FContextHandle;
    property Present: Boolean read FPresent;
    property DeviceName: string read FDeviceName;
    property PacketSize: Byte read FPacketSize write SetPacketSize;
  published
    property Enabled: Boolean read FEnabled write SetEnabled;
    property OnContextClose: TContextEvent read FOnCloseContext write FOnCloseContext;
    property OnContextOpen: TContextEvent read FOnOpenContext write FOnOpenContext;
    property OnContextOverlap: TContextEvent read FOnOverlapContext write FOnOverlapContext;
    property OnContextUpdate: TContextEvent read FOnUpdateContext write FOnUpdateContext;
    property OnCursorChanged: TPacketEvent read FOnCursorChanged write FOnCursorChanged;
    property OnInfoChanged: TInfoChangedEvent read FOnInfoChanged write FOnInfoChanged;
    property OnPacket: TPacketEvent read FOnPacket write FOnPacket;
    property OnProximity: TProximityEvent read FOnProximity write FOnProximity;
  end;

{ Aliased functions (Can change these to unicode by changing the A to W in Alias name) }
    tWTInfo = function (wCategory: Cardinal; nIndex: Cardinal; lpOutput: Pointer): Cardinal; stdcall;
    { Used to read dispidious pieces of information about the tablet. }

    tWTOpen = function (hWnd: HWnd; var LPLogContext: TLogContext; fEnable: Boolean): Integer; stdcall;
    { Used to begin accessing the Tablet. }

    tWTGet = function (hCtx: HCtx; var LPLogContext: TLogContext): Boolean; stdcall;
    { Fills the supplied structure with the current context attributes for the passed handle. }

    tWTSet = function (hCtx: HCtx; var LPLogContext: TLogContext): Boolean; stdcall;
    { Allows some of the context's attributes to be changed on the fly. }

{ Basic functions }

    tWTClose = function (hCtx: HCtx): Boolean; stdcall;
    { Used to end accessing the Tablet. }

    tWTPacketsGet = function (hCtx: HCtx; cMaxPackets: Integer; lpPkts: Pointer): Integer; stdcall;
    { Used to poll the Tablet for input. }

    tWTPacket = function (hCtx: HCtx; wSerial: Cardinal; lpPkts: Pointer): Boolean; stdcall;
    { Similar to WTPacketsGet but is used in a window function. }

{ Visibility functions }
    tWTEnable = function (hCtx: HCtx; fEnable: Boolean): Integer; stdcall;
    { Enables and Disables a Tablet Context; temporarily turning on or off the processing of packets. }

    tWTOverlap = function (hCtx: HCtx; fToTop: Boolean): Integer; stdcall;
    { Sends a tablet context to the top or bottom of the order of overlapping tablet contexts. }

{ Context Editing functions }
    tWTConfig = function (hCtx: HCtx; hWnd: HWnd): Integer; stdcall;
    { Used to call a requestor which aids in configuring the Tablet }

    tWTExtGet = function (hCtx: HCtx; wExt: Cardinal; lpData: Pointer): Integer; stdcall;
    tWTExtSet = function (hCtx: HCtx; wExt: Cardinal; lpData: Pointer): Integer; stdcall;

    tWTSave = function (hCtx: HCtx; lpSaveInfo: Pointer): Integer; stdcall;
    { Fills the supplied buffer with binary save information that can be used to restore the equivalent context in a subsequent Windows session. }

    tWTRestore = function (hWnd: HWnd; lpSaveInfo: Pointer; fEnable: Integer): Integer; stdcall;
    { Creates a tablet context from the save information returned from the WTSave function. }

{ Advanced Packet and Queue functions }
    tWTPacketsPeek = function (hCtx: HCtx; cMaxPackets: Integer; lpPkts: Pointer): Integer; stdcall;
    tWTDataGet = function (hCtx: HCtx; wBegin: Cardinal; wEnding: Cardinal;
      cMaxPackets: Integer; lpPkts: Pointer; lpNPkts: Pointer): Integer; stdcall;
    tWTDataPeek = function (hCtx: HCtx; wBegin: Cardinal; wEnding: Cardinal;
      cMaxPackets: Integer; lpPkts: Pointer; lpNPkts: Pointer): Integer; stdcall;
    tWTQueuePacketsEx = function (hCtx: HCtx; var lpOld: Pointer; var lpNew: Pointer): Integer; stdcall;
    { Returns the serial numbers of the oldest and newest packets currently in the queue. }

    tWTQueueSizeGet = function (hCtx: Integer): Integer; stdcall;
    tWTQueueSizeSet = function (hCtx: Integer; nPkts: Integer): Integer; stdcall;

{ Manager functions }

    { Manager Handle functions }
        tWTMgrOpen = function (HWnd: Integer; wMsgBase: Cardinal): Integer; stdcall;
        tWTMgrClose = function (hMgr: Integer): Boolean; stdcall;

    { Manager Context functions }
        tWTMgrContextEnum = function (hMgr: Integer; lpEnumFunc: Pointer; lParam: Pointer): Integer; stdcall;
        tWTMgrContextOwner = function (hMgr: Integer; hCtx: HCtx): Integer; stdcall;
        tWTMgrDefContext = function (hMgr: Integer; fSystem: Boolean): Integer; stdcall;
        tWTMgrDefContextEx = function (hMgr: Integer; wDevice: Cardinal; fSystem: Boolean): Integer; stdcall;

    { Manager Configuration functions }
        tWTMgrDeviceConfig = function (hMgr: Integer; var wDevice: Cardinal; HWnd: Integer): Cardinal; stdcall;
        tWTMgrConfigReplaceExA = function (hMgr: Integer; fInstall: Boolean; lpszModule: Pointer; lpszCfgProc: Pointer): Integer; stdcall;
        tWTMgrConfigReplaceExW = function (hMgr: Integer; fInstall: Boolean; lpszModule: Pointer; lpszCfgProc: Pointer): Integer; stdcall;

    { Manager Packet Hook functions }
        tWTMgrPacketHookExA = function (hMgr: Integer; nType: Integer; lpszModule: Pointer; lpszHookProc: Pointer): Integer; stdcall;
        tWTMgrPacketHookExW = function (hMgr: Integer; nType: Integer; lpszModule: Pointer; lpszHookProc: Pointer): Integer; stdcall;
        tWTMgrPacketUnHook = function (hHook: Integer): Integer; stdcall;
        tWTMgrPacketHookNext = function (hHook: Integer; nCode: Integer; wParam: Pointer; var lParam: Pointer): Integer; stdcall;

    { Manager Preference Data functions }
        tWTMgrExt = function (hMgr: Integer; wExt: Cardinal; lpData: Pointer): Boolean; stdcall;
        tWTMgrCsrEnable = function (hMgr: Integer; wCursor: Cardinal; fEnable: Boolean): Integer; stdcall;
        tWTMgrCsrButtonMap = function (hMgr: Integer; wCursor: Cardinal; lpLogBtns: Pointer; lpSysBtns: Pointer): Integer; stdcall;
        tWTMgrCsrPressureBtnMarksEx = function (hMgr: Integer; wCursor: Cardinal; lpNMarks: Pointer; lpTMarks: Pointer): Integer; stdcall;
        tWTMgrCsrPressureResponse = function (hMgr: Integer; wCursor: Cardinal; lpNResp: Pointer; lpTResp: Pointer): Integer; stdcall;
        tWTMgrCsrExt = function (hMgr: Integer; wCursor: Cardinal; wExt: Cardinal; var lpData: Pointer): Integer; stdcall;

  //procedure Register;

{ Procedural Variable Definitions }

var
  WTInfo: tWTInfo;
  WTOpen: tWTOpen;
  WTGet: tWTGet;
  WTSet: tWTSet;
  WTClose: tWTClose;
  WTPacketsGet: tWTPacketsGet;
  WTPacket: tWTPacket;
  WTEnable: tWTEnable;
  WTOverlap: tWTOverlap;
  WTConfig: tWTConfig;
  WTExtGet: tWTExtGet;
  WTExtSet: tWTExtSet;
  WTSave: tWTSave;
  WTRestore: tWTRestore;
  WTPacketsPeek: tWTPacketsPeek;
  WTDataGet: tWTDataGet;
  WTDataPeek: tWTDataPeek;
  WTQueuePacketsEx: tWTQueuePacketsEx;
  WTQueueSizeGet: tWTQueueSizeGet;
  WTQueueSizeSet: tWTQueueSizeSet;

  WTMgrOpen: tWTMgrOpen;
  WTMgrClose: tWTMgrClose;

  WTMgrContextEnum: tWTMgrContextEnum;
  WTMgrContextOwner: tWTMgrContextOwner;
  WTMgrDefContext: tWTMgrDefContext;
  WTMgrDefContextEx: tWTMgrDefContextEx;

  WTMgrDeviceConfig: tWTMgrDeviceConfig;
  WTMgrConfigReplaceExA: tWTMgrConfigReplaceExA;
  WTMgrConfigReplaceExW: tWTMgrConfigReplaceExW;

  WTMgrPacketHookExA: tWTMgrPacketHookExA;
  WTMgrPacketHookExW: tWTMgrPacketHookExW;
  WTMgrPacketUnHook: tWTMgrPacketUnHook;
  WTMgrPacketHookNext: tWTMgrPacketHookNext;

  WTMgrExt: tWTMgrExt;
  WTMgrCsrEnable: tWTMgrCsrEnable;
  WTMgrCsrButtonMap: tWTMgrCsrButtonMap;
  WTMgrCsrPressureBtnMarksEx: tWTMgrCsrPressureBtnMarksEx;
  WTMgrCsrPressureResponse: tWTMgrCsrPressureResponse;
  WTMgrCsrExt: tWTMgrCsrExt;

implementation

{procedure Register;
begin
  RegisterComponents('System', [TTablet]);
end; }

procedure TTablet.NewWindowProc(var Msg: TMessage);
begin
  with Msg do
  begin
    case Msg of
      WT_CTXCLOSE: 
        if Assigned(FOnCloseContext) then
          FOnCloseContext(Self, WParam, LParam);
      WT_CTXOPEN: 
        if Assigned(FOnOpenContext) then
          FOnOpenContext(Self, WParam, LParam);
      WT_CTXOVERLAP: 
        if Assigned(FOnOverlapContext) then
          FOnOverlapContext(Self, WParam, LParam);
      WT_CTXUPDATE: 
        if Assigned(FOnUpdateContext) then
          FOnUpdateContext(Self, WParam, LParam);
      WT_CSRCHANGE: 
        if Assigned(FOnCursorChanged) then
          if WTPacket(LParam, WParam, FPPacket) then
            FOnCursorChanged(Self, WParam, LParam, FPPacket);
      WT_INFOCHANGE: 
        if Assigned(FOnInfoChanged) then
          FOnInfoChanged(Self, WParam, LParamLo, LParamHi);
      WT_PACKET: 
        if Assigned(FOnPacket)  then
          if WTPacket(LParam, WParam, FPPacket) then
            FOnPacket(Self, WParam, LParam, FPPacket);
      WT_PROXIMITY: 
        if Assigned(FOnProximity) then
          FOnProximity(Self, WParam, LParamLo <> 0);
    else

    { Call the old Window procedure to }
    { allow processing of the message. }
      Result := CallWindowProc(FOldWindowProc, Application.Handle, Msg,wParam,lParam);
    end;
  end;
end;

constructor TTablet.Create(AOwner: TComponent);
var
  CharArray: TString;

  procedure SetProcAddr(var ProcPtr: Pointer; const ProcName: string);
  begin
    ProcPtr := GetProcAddress(wtHandle, PChar(ProcName));
    if ProcPtr = nil then FPresent := False;
  end;

begin
  inherited Create(AOwner);
  FPresent := True;
  wtHandle := LoadLibrary('wintab32.dll');
  if wtHandle = 0 then
    FPresent := False
  else
  begin
    SetProcAddr(@WTInfo,                     'WTInfoA');
    SetProcAddr(@WTOpen,                     'WTOpenA');
    SetProcAddr(@WTGet,                      'WTGetA');
    SetProcAddr(@WTSet,                      'WTSetA');
    SetProcAddr(@WTClose,                    'WTClose');
    SetProcAddr(@WTPacketsGet,               'WTPacketsGet');
    SetProcAddr(@WTPacket,                   'WTPacket');
    SetProcAddr(@WTEnable,                   'WTEnable');
    SetProcAddr(@WTOverlap,                  'WTOverlap');
    SetProcAddr(@WTConfig,                   'WTConfig');
    SetProcAddr(@WTExtGet,                   'WTExtGet');
    SetProcAddr(@WTExtSet,                   'WTExtSet');
    SetProcAddr(@WTSave,                     'WTSave');
    SetProcAddr(@WTRestore,                  'WTRestore');
    SetProcAddr(@WTPacketsPeek,              'WTPacketsPeek');
    SetProcAddr(@WTDataGet,                  'WTDataGet');
    SetProcAddr(@WTDataPeek,                 'WTDataPeek');
    SetProcAddr(@WTQueuePacketsEx,           'WTQueuePacketsEx');
    SetProcAddr(@WTQueueSizeGet,             'WTQueueSizeGet');
    SetProcAddr(@WTQueueSizeSet,             'WTQueueSizeSet');
    SetProcAddr(@WTMgrOpen,                  'WTMgrOpen');
    SetProcAddr(@WTMgrClose,                 'WTMgrClose');
    SetProcAddr(@WTMgrContextEnum,           'WTMgrContextEnum');
    SetProcAddr(@WTMgrContextOwner,          'WTMgrContextOwner');
    SetProcAddr(@WTMgrDefContext,            'WTMgrDefContext');
    SetProcAddr(@WTMgrDefContextEx,          'WTMgrDefContextEx');
    SetProcAddr(@WTMgrDeviceConfig,          'WTMgrDeviceConfig');
    SetProcAddr(@WTMgrConfigReplaceExA,      'WTMgrConfigReplaceExA');
    SetProcAddr(@WTMgrConfigReplaceExW,      'WTMgrConfigReplaceExW');
    SetProcAddr(@WTMgrPacketHookExA,         'WTMgrPacketHookExA');
    SetProcAddr(@WTMgrPacketHookExW,         'WTMgrPacketHookExW');
    SetProcAddr(@WTMgrPacketUnhook,          'WTMgrPacketUnhook');
    SetProcAddr(@WTMgrPacketHookNext,        'WTMgrPacketHookNext');
    SetProcAddr(@WTMgrExt,                   'WTMgrExt');
    SetProcAddr(@WTMgrCsrEnable,             'WTMgrCsrEnable');
    SetProcAddr(@WTMgrCsrButtonMap,          'WTMgrCsrButtonMap');
    SetProcAddr(@WTMgrCsrPressureBtnMarksEx, 'WTMgrCsrPressureBtnMarksEx');
    SetProcAddr(@WTMgrCsrPressureResponse,   'WTMgrCsrPressureResponse');
    SetProcAddr(@WTMgrCsrExt,                'WTMgrCsrExt');
    if FPresent then
    begin
      FPresent := WTInfo(0, 0, nil) <> 0;
      if FPresent then
      begin
        WTInfo(WTI_DEVICES, DVC_NAME, @CharArray);
        FDeviceName := CharArray;
      end
    end;
  end;
end;

procedure TTablet.Loaded;
begin
  inherited;
  FNewWindowProc := MakeObjectInstance(NewWindowProc);
  FOldWindowProc := Pointer(SetWindowLong(Application.Handle, GWL_WndProc, longint(FNewWindowProc)));
end;

destructor TTablet.Destroy;
begin
  SetWindowLong(Application.Handle, GWL_WndProc, longint(FOldWindowProc));
  FreeObjectInstance(FNewWindowProc);
  FreeMem(FPPacket, FPacketSize + 1);
  inherited;
end;

procedure TTablet.Initialize;
{ Establish contact and fill context with defaults }
begin
  WTInfo(WTI_DEFCONTEXT, 0, @Context);
end;

function TTablet.SetContext: Boolean;
begin
  Result := WTSet(FContextHandle, FContext);
end;

function TTablet.GetContext: Boolean;
begin
  Result := WTGet(FContextHandle, FContext);
end;

procedure TTablet.SetEnabled(Value: Boolean);
begin
  if not FPresent then Exit;
  FEnabled := Value;
  if Value then WTEnable(FContextHandle, True)
  else WTEnable(FContextHandle, False);
end;

procedure TTablet.SetPacketSize(Size: Byte);
begin
  FPacketSize := Size;
  ReallocMem(FPPacket, Size + 1);
end;

procedure TTablet.Open;
begin
  FContextHandle := WTOpen(Application.Handle, FContext, True);
  if FContextHandle = 0 then
    raise Exception.Create('Tablet context failed to open.');
end;

procedure TTablet.Close;
begin
  WTClose(FContextHandle);
end;

end.
