unit fServer;

{$I EZ_FLAG.PAS}
{$DEFINE TRANSPORT_COMPRESSED}  // client and server must have this synchronized
interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ComCtrls, StdCtrls, CheckLst, IdBaseComponent, IdComponent,
  IdTCPServer, IdResourceStrings, IdStack, IdGlobal, IdSocketHandle,
  IdThreadMgr, IdThreadMgrPool, GISDataU, EzBaseGis;

type
  TfrmMain = class(TForm)
    Label1: TLabel;
    pgeMain: TPageControl;
    tabProcesses: TTabSheet;
    tabMain: TTabSheet;
    Label2: TLabel;
    lbIPs: TCheckListBox;
    Label3: TLabel;
    IdTCPServer: TIdTCPServer;
    cboPorts: TComboBox;
    Label4: TLabel;
    edtPort: TEdit;
    btnStartServer: TButton;
    btnStopServer: TButton;
    btnExit: TButton;
    lbProcesses: TListBox;
    StatusBar: TStatusBar;
    btnClearMessages: TButton;
    IdThreadMgrPool1: TIdThreadMgrPool;
    procedure FormCreate(Sender: TObject);
    procedure cboPortsChange(Sender: TObject);
    procedure btnStartServerClick(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure btnStopServerClick(Sender: TObject);
    procedure btnClearMessagesClick(Sender: TObject);
    procedure IdTCPServerConnect(AThread: TIdPeerThread);
    procedure btnExitClick(Sender: TObject);
    procedure IdTCPServerchOPENCommand(ASender: TIdCommand);
    procedure IdTCPServerDisconnect(AThread: TIdPeerThread);
    procedure IdTCPServerchCLOSECommand(ASender: TIdCommand);
    procedure IdTCPServerchDBT_GETRECNOCommand(ASender: TIdCommand);
    procedure IdTCPServerchDBT_SETRECNOCommand(ASender: TIdCommand);
    procedure IdTCPServerchDBT_BOFCommand(ASender: TIdCommand);
    procedure IdTCPServerchDBT_EOFCommand(ASender: TIdCommand);
    procedure IdTCPServerchDBT_DATEGETCommand(ASender: TIdCommand);
    procedure IdTCPServerchDBT_DATEGETNCommand(ASender: TIdCommand);
    procedure IdTCPServerchDELETEDCommand(ASender: TIdCommand);
    procedure IdTCPServerchDBT_FIELDCommand(ASender: TIdCommand);
    procedure IdTCPServerchDBT_FIELDCOUNTCommand(ASender: TIdCommand);
    procedure IdTCPServerchDBT_FIELDDECCommand(ASender: TIdCommand);
    procedure IdTCPServerchDBT_FIELDGETCommand(ASender: TIdCommand);
    procedure IdTCPServerchDBT_FIELDGETNCommand(ASender: TIdCommand);
    procedure IdTCPServerchDBT_FIELDLENCommand(ASender: TIdCommand);
    procedure IdTCPServerchDBT_FIELDNOCommand(ASender: TIdCommand);
    procedure IdTCPServerchDBT_FIELDTYPECommand(ASender: TIdCommand);
    procedure IdTCPServerchDBT_FINDCommand(ASender: TIdCommand);
    procedure IdTCPServerchDBT_FLOATGETCommand(ASender: TIdCommand);
    procedure IdTCPServerchDBT_FLOATGETNCommand(ASender: TIdCommand);
    procedure IdTCPServerCHDBT_INDEXCOUNTCommand(ASender: TIdCommand);
    procedure IdTCPServerchDBT_GETACTIVECommand(ASender: TIdCommand);
    procedure IdTCPServerchDBT_SETACTIVECommand(ASender: TIdCommand);
    procedure IdTCPServerchDBT_INDEXASCENDINGCommand(ASender: TIdCommand);
    procedure IdTCPServerchDBT_INDEXCommand(ASender: TIdCommand);
    procedure IdTCPServerchDBT_INDEXCURRENTCommand(ASender: TIdCommand);
    procedure IdTCPServerchDBT_INDEXUNIQUECommand(ASender: TIdCommand);
    procedure IdTCPServerchDBT_INDEXUEXPRESSIONCommand(
      ASender: TIdCommand);
    procedure IdTCPServerchDBT_INDEXTAGNAMECommand(ASender: TIdCommand);
    procedure IdTCPServerchDBT_INDEXFILTERCommand(ASender: TIdCommand);
    procedure IdTCPServerchDBT_INTEGERGETCommand(ASender: TIdCommand);
    procedure IdTCPServerchDBT_INTEGERGETNCommand(ASender: TIdCommand);
    procedure IdTCPServerchDBT_LOGICGETCommand(ASender: TIdCommand);
    procedure IdTCPServerchDBT_LOGICGETNCommand(ASender: TIdCommand);
    procedure IdTCPServerchDBT_MEMOSAVECommand(ASender: TIdCommand);
    procedure IdTCPServerchDBT_MEMOSAVENCommand(ASender: TIdCommand);
    procedure IdTCPServerchDBT_MEMOSIZECommand(ASender: TIdCommand);
    procedure IdTCPServerchDBT_MEMOSIZENCommand(ASender: TIdCommand);
    procedure IdTCPServerchDBT_RECORDCOUNTCommand(ASender: TIdCommand);
    procedure IdTCPServerchDBT_STRINGGETCommand(ASender: TIdCommand);
    procedure IdTCPServerchDBT_STRINGGETNCommand(ASender: TIdCommand);
    procedure IdTCPServerchDBT_DATEPUTCommand(ASender: TIdCommand);
    procedure IdTCPServerchDBT_DATEPUTNCommand(ASender: TIdCommand);
    procedure IdTCPServerchDBT_DELETECommand(ASender: TIdCommand);
    procedure IdTCPServerchDBT_EDITCommand(ASender: TIdCommand);
    procedure IdTCPServerchDBT_FIELDPUTCommand(ASender: TIdCommand);
    procedure IdTCPServerchDBT_FIELDPUTNCommand(ASender: TIdCommand);
    procedure IdTCPServerchDBT_FIRSTCommand(ASender: TIdCommand);
    procedure IdTCPServerchDBT_FLOATPUTCommand(ASender: TIdCommand);
    procedure IdTCPServerchDBT_FLOATPUTNCommand(ASender: TIdCommand);
    procedure IdTCPServerchDBT_FLUSHDBCommand(ASender: TIdCommand);
    procedure IdTCPServerchDBT_GOCommand(ASender: TIdCommand);
    procedure IdTCPServerchDBT_INDEXONCommand(ASender: TIdCommand);
    procedure IdTCPServerchDBT_INTEGERPUTCommand(ASender: TIdCommand);
    procedure IdTCPServerchDBT_INTEGERPUTNCommand(ASender: TIdCommand);
    procedure IdTCPServerchDBT_LASTCommand(ASender: TIdCommand);
    procedure IdTCPServerchDBT_LOGICPUTCommand(ASender: TIdCommand);
    procedure IdTCPServerchDBT_LOGICPUTNCommand(ASender: TIdCommand);
    procedure IdTCPServerchDBT_MEMOLOADCommand(ASender: TIdCommand);
    procedure IdTCPServerchDBT_MEMOLOADNCommand(ASender: TIdCommand);
    procedure IdTCPServerchDBT_NEXTCommand(ASender: TIdCommand);
    procedure IdTCPServerchDBT_PACKCommand(ASender: TIdCommand);
    procedure IdTCPServerchDBT_POSTCommand(ASender: TIdCommand);
    procedure IdTCPServerchDBT_PRIORCommand(ASender: TIdCommand);
    procedure IdTCPServerchDBT_RECALLCommand(ASender: TIdCommand);
    procedure IdTCPServerchDBT_REFRESHCommand(ASender: TIdCommand);
    procedure IdTCPServerchDBT_REINDEXCommand(ASender: TIdCommand);
    procedure IdTCPServerchDBT_SETTAGTOCommand(ASender: TIdCommand);
    procedure IdTCPServerchDBT_SETUSEDELETEDCommand(ASender: TIdCommand);
    procedure IdTCPServerchDBT_STRINGPUTCommand(ASender: TIdCommand);
    procedure IdTCPServerchDBT_STRINGPUTNCommand(ASender: TIdCommand);
    procedure IdTCPServerchDBT_ZAPCommand(ASender: TIdCommand);
    procedure IdTCPServerchDBT_BEGINTRANSCommand(ASender: TIdCommand);
    procedure IdTCPServerchDBT_ENDTRANSCommand(ASender: TIdCommand);
    procedure IdTCPServerchDBT_ROLLBACKTRANSCommand(ASender: TIdCommand);
    procedure IdTCPServerchLI_GETVISIBLECommand(ASender: TIdCommand);
    procedure IdTCPServerchLI_SETVISIBLECommand(ASender: TIdCommand);
    procedure IdTCPServerchLI_GETSELECTABLECommand(ASender: TIdCommand);
    procedure IdTCPServerchLI_SETSELECTABLECommand(ASender: TIdCommand);
    procedure IdTCPServerchLI_GETEXTENSIONCommand(ASender: TIdCommand);
    procedure IdTCPServerchLI_SETEXTENSIONCommand(ASender: TIdCommand);
    procedure IdTCPServerchLI_GETISCOSMETHICCommand(ASender: TIdCommand);
    procedure IdTCPServerchLI_SETISCOSMETHICCommand(ASender: TIdCommand);
    procedure IdTCPServerchLI_GETIDCOUNTERCommand(ASender: TIdCommand);
    procedure IdTCPServerchLI_SETIDCOUNTERCommand(ASender: TIdCommand);
    procedure IdTCPServerchLI_GETISANIMATIONCommand(ASender: TIdCommand);
    procedure IdTCPServerchLI_SETISANIMATIONCommand(ASender: TIdCommand);
    procedure IdTCPServerchLI_GETISINDEXEDCommand(ASender: TIdCommand);
    procedure IdTCPServerchLI_SETISINDEXEDCommand(ASender: TIdCommand);
    procedure IdTCPServerchLI_GETCOORDSUNITSCommand(ASender: TIdCommand);
    procedure IdTCPServerchLI_SETCOORDSUNITSCommand(ASender: TIdCommand);
    procedure IdTCPServerchLI_GETUSEATTACHEDDBCommand(ASender: TIdCommand);
    procedure IdTCPServerchLI_SETUSEATTACHEDDBCommand(ASender: TIdCommand);
    procedure IdTCPServerchLI_GETOVERLAPPEDTEXTACTIONCommand(
      ASender: TIdCommand);
    procedure IdTCPServerchLI_SETOVERLAPPEDTEXTACTIONCommand(
      ASender: TIdCommand);
    procedure IdTCPServerchLI_SETOVERLAPPEDTEXTCOLORCommand(
      ASender: TIdCommand);
    procedure IdTCPServerchLI_GETOVERLAPPEDTEXTCOLORCommand(
      ASender: TIdCommand);
    procedure IdTCPServerchLI_GETTEXTFIXEDSIZECommand(ASender: TIdCommand);
    procedure IdTCPServerchLI_SETTEXTFIXEDSIZECommand(ASender: TIdCommand);
    procedure IdTCPServerchLI_GETTEXTHASSHADOWCommand(ASender: TIdCommand);
    procedure IdTCPServerchLI_SETTEXTHASSHADOWCommand(ASender: TIdCommand);
    procedure IdTCPServerchLAY_ISCLIENTSERVERCommand(ASender: TIdCommand);
    procedure IdTCPServerchLAY_STARTBATCHINSERTCommand(
      ASender: TIdCommand);
    procedure IdTCPServerchLAY_FINISHBATCHINSERTCommand(
      ASender: TIdCommand);
    procedure IdTCPServerchLAY_DEFINESCOPECommand(ASender: TIdCommand);
    procedure IdTCPServerchLAY_DEFINEPOLYGONSCOPECommand(
      ASender: TIdCommand);
    procedure IdTCPServerchLAY_ZAPCommand(ASender: TIdCommand);
    procedure IdTCPServerchLAY_GETFIELDLISTCommand(ASender: TIdCommand);
    procedure IdTCPServerchLAY_GETRECNOCommand(ASender: TIdCommand);
    procedure IdTCPServerchLAY_SETRECNOCommand(ASender: TIdCommand);
    procedure IdTCPServerchLAY_SETGRAPHICFILTERCommand(
      ASender: TIdCommand);
    procedure IdTCPServerchLAY_CANCELFILTERCommand(ASender: TIdCommand);
    procedure IdTCPServerchLAY_EOFCommand(ASender: TIdCommand);
    procedure IdTCPServerchLAY_FIRSTCommand(ASender: TIdCommand);
    procedure IdTCPServerchLAY_NEXTCommand(ASender: TIdCommand);
    procedure IdTCPServerchLAY_LASTCommand(ASender: TIdCommand);
    procedure IdTCPServerchLAY_STARTBUFFERINGCommand(ASender: TIdCommand);
    procedure IdTCPServerchLAY_ENDBUFFERINGCommand(ASender: TIdCommand);
    procedure IdTCPServerchLAY_ASSIGNCommand(ASender: TIdCommand);
    procedure IdTCPServerchLAY_GETEXTENSIONFORRECORDSCommand(
      ASender: TIdCommand);
    procedure IdTCPServerchLAY_REBUILDTREECommand(ASender: TIdCommand);
    procedure IdTCPServerchLAY_OPENCommand(ASender: TIdCommand);
    procedure IdTCPServerchLAY_CLOSECommand(ASender: TIdCommand);
    procedure IdTCPServerchLAY_FORCEOPENEDCommand(ASender: TIdCommand);
    procedure IdTCPServerchLAY_WRITEHEADERSCommand(ASender: TIdCommand);
    procedure IdTCPServerchLAY_ADDENTITYCommand(ASender: TIdCommand);
    procedure IdTCPServerchLAY_UNDELETEENTITYCommand(ASender: TIdCommand);
    procedure IdTCPServerchLAY_DELETEENTITYCommand(ASender: TIdCommand);
    procedure IdTCPServerchLAY_QUICKUPDATEEXTENSIONCommand(
      ASender: TIdCommand);
    procedure IdTCPServerchLAY_UPDATEEXTENSIONCommand(ASender: TIdCommand);
    procedure IdTCPServerchLAY_LOADENTITYWITHRECNOCommand(
      ASender: TIdCommand);
    procedure IdTCPServerchLAY_UPDATEENTITYCommand(ASender: TIdCommand);
    procedure IdTCPServerchLAY_PACKCommand(ASender: TIdCommand);
    procedure IdTCPServerchLAY_RECEXTENSIONCommand(ASender: TIdCommand);
    procedure IdTCPServerchLAY_RECLOADENTITYCommand(ASender: TIdCommand);
    procedure IdTCPServerchLAY_RECLOADENTITY2Command(ASender: TIdCommand);
    procedure IdTCPServerchLAY_RECENTITYIDCommand(ASender: TIdCommand);
    procedure IdTCPServerchLAY_RECISDELETEDCommand(ASender: TIdCommand);
    procedure IdTCPServerchLAY_COPYRECORDCommand(ASender: TIdCommand);
    procedure IdTCPServerchLAY_CONTAINSDELETEDCommand(ASender: TIdCommand);
    procedure IdTCPServerchLAY_RECALLCommand(ASender: TIdCommand);
    procedure IdTCPServerchLAY_GETRECORDCOUNTCommand(ASender: TIdCommand);
    procedure IdTCPServerchLAY_BRINGTOFRONTCommand(ASender: TIdCommand);
    procedure IdTCPServerchLAY_SENDTOBACKCommand(ASender: TIdCommand);
    procedure IdTCPServerchLAY_DELETELAYERFILESCommand(
      ASender: TIdCommand);
    procedure IdTCPServerchLAY_GETACTIVECommand(ASender: TIdCommand);
    procedure IdTCPServerchLAY_SETACTIVECommand(ASender: TIdCommand);
    procedure IdTCPServerchLAY_SYNCHRONIZECommand(ASender: TIdCommand);
    procedure IdTCPServerchMI_INITIALIZECommand(ASender: TIdCommand);
    procedure IdTCPServerchMI_ISVALIDCommand(ASender: TIdCommand);
    procedure IdTCPServerchMI_GETNUMLAYERSCommand(ASender: TIdCommand);
    procedure IdTCPServerchMI_SETNUMLAYERSCommand(ASender: TIdCommand);
    procedure IdTCPServerchMI_GETEXTENSIONCommand(ASender: TIdCommand);
    procedure IdTCPServerchMI_SETEXTENSIONCommand(ASender: TIdCommand);
    procedure IdTCPServerchMI_GETCURRENTLAYERCommand(ASender: TIdCommand);
    procedure IdTCPServerchMI_SETCURRENTLAYERCommand(ASender: TIdCommand);
    procedure IdTCPServerchMI_GETAERIALVIEWLAYERCommand(
      ASender: TIdCommand);
    procedure IdTCPServerchMI_SETAERIALVIEWLAYERCommand(
      ASender: TIdCommand);
    procedure IdTCPServerchMI_GETLASTVIEWCommand(ASender: TIdCommand);
    procedure IdTCPServerchMI_SETLASTVIEWCommand(ASender: TIdCommand);
    procedure IdTCPServerchMI_GETCOORDSYSCommand(ASender: TIdCommand);
    procedure IdTCPServerchMI_SETCOORDSYSCommand(ASender: TIdCommand);
    procedure IdTCPServerchMI_SETCOORDSUNITSCommand(ASender: TIdCommand);
    procedure IdTCPServerchMI_GETCOORDSUNITSCommand(ASender: TIdCommand);
    procedure IdTCPServerchMI_GETISAREACLIPPEDCommand(ASender: TIdCommand);
    procedure IdTCPServerchMI_SETISAREACLIPPEDCommand(ASender: TIdCommand);
    procedure IdTCPServerchMI_GETAREACLIPPEDCommand(ASender: TIdCommand);
    procedure IdTCPServerchMI_SETAREACLIPPEDCommand(ASender: TIdCommand);
    procedure IdTCPServerchMI_GETCLIPAREAKINDCommand(ASender: TIdCommand);
    procedure IdTCPServerchMI_SETCLIPAREAKINDCommand(ASender: TIdCommand);
    procedure IdTCPServerchGIS_ADDGEOREFCommand(ASender: TIdCommand);
    procedure IdTCPServerchGIS_CLOSECommand(ASender: TIdCommand);
    procedure IdTCPServerchGIS_CREATENEWCommand(ASender: TIdCommand);
    procedure IdTCPServerchGIS_ISCLIENTSERVERCommand(ASender: TIdCommand);
    procedure IdTCPServerchGIS_SAVEASCommand(ASender: TIdCommand);
    procedure IdTCPServerchLAY_GETBOOKMARKCommand(ASender: TIdCommand);
    procedure IdTCPServerchLAY_GOTOBOOKMARKCommand(ASender: TIdCommand);
    procedure IdTCPServerchLAY_FREEBOOKMARKCommand(ASender: TIdCommand);
    procedure IdTCPServerchDBT_APPENDCommand(ASender: TIdCommand);
    procedure IdTCPServerchGIS_GETPROJPARAMSCommand(ASender: TIdCommand);
    procedure IdTCPServerchGIS_GETHGUIDELINESCommand(ASender: TIdCommand);
    procedure IdTCPServerchGIS_GETVGUIDELINESCommand(ASender: TIdCommand);
    procedure IdTCPServerchGIS_GETPOLYCLIPAREACommand(ASender: TIdCommand);
    procedure IdTCPServerchGIS_GETLAYERLISTCommand(ASender: TIdCommand);
    procedure IdTCPServerchLAY_GETNEXTBUFFERCommand(ASender: TIdCommand);
    procedure IdTCPServerchDBT_DBCREATETABLECommand(ASender: TIdCommand);
    procedure IdTCPServerchDBT_DBTABLEEXITSCommand(ASender: TIdCommand);
    procedure IdTCPServerchDBT_DBDROPTABLECommand(ASender: TIdCommand);
    procedure IdTCPServerchDBT_DBDROPINDEXCommand(ASender: TIdCommand);
    procedure IdTCPServerchDBT_DBRENAMETABLECommand(ASender: TIdCommand);
    procedure IdTCPServerchLI_GETCOORDSYSTEMCommand(ASender: TIdCommand);
    procedure IdTCPServerchLI_SETCOORDSYSTEMCommand(ASender: TIdCommand);
    procedure IdTCPServerchGS_LOADSYMBOLSCommand(ASender: TIdCommand);
    procedure IdTCPServerchGS_LOADLINETYPESCommand(ASender: TIdCommand);
    procedure IdTCPServerchGS_LOADVECTFONTSCommand(ASender: TIdCommand);
    procedure IdTCPServerchGLB_GETIMAGECommand(ASender: TIdCommand);
  private
    { Private declarations }
    function FindModule(connection: TIdTCPServerConnection): TGISData;
    Function GetLayer(ASender: TIdCommand): TEzBaseLayer;
    Function GetGIS(ASender: TIdCommand): TEzBaseGIS;
  public
    { Public declarations }
    fErrors : TStringList;
    fServerRunning : boolean;
    procedure PopulateIPAddresses;
    function PortDescription(const PortNumber: integer): string;
    function StartServer:Boolean;
    function StopServer:Boolean;
  end;

var
  frmMain: TfrmMain;

implementation

{$R *.dfm}

uses
  EzSystem, EzBasicCtrls, EzRTree, ezbase, EzLib, EzCtrls, EzEntities
{$IFDEF TRANSPORT_COMPRESSED}
  , EzZLibUtil
{$ENDIF}
  ;

{ TfrmMain }

function TfrmMain.FindModule(connection: TIdTCPServerConnection): TGISData;
var
  i:integer;
begin
  Result:=nil;
  for i:=0 to Connection.ComponentCount-1 do
     if Connection.Components[i] is TGISData then
      Result:=(Connection.Components[i] as TGISData);
end;

procedure TfrmMain.PopulateIPAddresses;
var
    i : integer;
begin
with lbIPs do
    begin
    Clear;
    Items := GStack.LocalAddresses;
    Items.Insert(0, '127.0.0.1');
    Checked[0]:= true;
    end;
try
  cboPorts.Items.Add(RSBindingAny);
  cboPorts.Items.BeginUpdate;
  for i := 0 to IdPorts.Count - 1 do
    cboPorts.Items.Add(PortDescription(Integer(IdPorts[i])));
finally
  cboPorts.Items.EndUpdate;
end;
end;

function TfrmMain.PortDescription(const PortNumber: integer): string;
begin
  with GStack.WSGetServByPort(PortNumber) do try
    Result := '';
    if Count > 0 then begin
      Result := Format('%d: %s', [PortNumber, CommaText]);    {Do not Localize}
    end;
  finally
    Free;
  end;
end;

procedure TfrmMain.cboPortsChange(Sender: TObject);
    function GetPort(AString:String):String;
    begin
    Result := AString;
    if pos(':',AString) > 0 then
        Result := copy(AString,1,pos(':',AString)-1);
    end;
begin
edtPort.Text :=
    GetPort(cboPorts.Items.Strings[cboPorts.ItemIndex])
end;


function TfrmMain.StartServer: Boolean;
var
    Binding : TIdSocketHandle;
    i : integer;
    SL : TStringList;
begin
SL := TStringList.Create;

if not StopServer then
    begin
    fErrors.Append('Error stopping server');
    Result := false;
    SL.Free;
    exit;
    end;

IdTCPServer.Bindings.Clear; // bindings cannot be cleared until TidTCPServer is inactive
try
try

for i := 0 to lbIPs.Count-1 do
    if lbIPs.Checked[i] then
        begin
        Binding := IdTCPServer.Bindings.Add;
        Binding.IP := lbIPs.Items.Strings[i];
        Binding.Port := StrToInt(edtPort.Text);
        SL.append('Server bound to IP ' + Binding.IP + ' on port ' + edtPort.Text);
        end;

IdTCPServer.Active := true;
result := IdTCPServer.Active;
fServerRunning := result;
lbProcesses.Items.AddStrings(SL);
lbProcesses.Items.Append('Server started');

if result then
    StatusBar.SimpleText := 'Server running'
else StatusBar.SimpleText := 'Server stopped';

except
on E : Exception do
    begin
    lbProcesses.Items.Append('Server not started');
    fErrors.append(E.Message);
    Result := false;
    fServerRunning := result;
    end;
end;
finally
FreeAndNil(SL);
end;
end;


function TfrmMain.StopServer: Boolean;
begin
IdTCPServer.Active := false;
IdTCPServer.Bindings.Clear;
Result := not IdTCPServer.Active;
fServerRunning := result;
if result then
    begin
    StatusBar.SimpleText := 'Server stopped';
    lbProcesses.Items.Append('Server stopped');
    end
else
    begin
    StatusBar.SimpleText := 'Server running';
    lbProcesses.Items.Append('Server not stopped');
    end;
end;

procedure TfrmMain.btnStopServerClick(Sender: TObject);
begin
fErrors.Clear;
if not fServerRunning then
    begin
    ShowMessage('Server it not running - no need to stop !');
    Exit;
    end;
if not StopServer then
    ShowMessage('Error stopping server ' + #13 + #13 + fErrors.Text)
else
    ShowMessage('Server stopped successfully');
end;

procedure TfrmMain.btnStartServerClick(Sender: TObject);
var
    x,i : integer;
begin
x:=0;
for i := 0 to lbIPs.Count-1 do
    if lbIPs.Checked[i] then
      inc(x);

if x < 1 then
    begin
    ShowMessage('Cannot proceed until you select at least one IP to bind!');
    exit;
    end;

fErrors.Clear;
if not StartServer then
    ShowMessage('Error starting server' + #13 + #13 + fErrors.text)
else ShowMessage('Server started successfully!');
end;

procedure TfrmMain.FormDestroy(Sender: TObject);
begin
FreeAndNil(fErrors);
end;

procedure TfrmMain.FormCreate(Sender: TObject);
var
  Path: string;
begin
  fErrors := TStringList.Create;
  PopulateIPAddresses;

  { initialize for map data }
  Path:= AddSlash(ExtractFilePath(ExpandFilename('..\..\data\txt.fnt')));
  if not FileExists(Path+'txt.fnt') then
  begin
    lbProcesses.Items.Add('No font files found !');
  end;
  Ez_VectorFonts.AddFontFile(Path+'complex.fnt');
  Ez_VectorFonts.AddFontFile(Path+'txt.fnt');

  { ALWAYS load the symbols after the vectorial fonts
    because the symbols can include vectorial fonts entities and
    if the vector font is not found, then the entity will be configured
    with another font }
  if FileExists(Path + 'symbols.ezs') then
  begin
    Ez_Symbols.FileName:= Path + 'symbols.ezs';
    Ez_Symbols.Open;
  end;

  // load line types
  if FileExists(Path + 'Linetypes.ezl') then
  begin
    Ez_LineTypes.FileName:=Path + 'Linetypes.ezl';
    Ez_LineTypes.Open;
  end;

  Ez_Preferences.CommonSubDir:= Path;

end;

procedure TfrmMain.btnClearMessagesClick(Sender: TObject);
begin
lbProcesses.Clear;
end;


procedure TfrmMain.IdTCPServerConnect(AThread: TIdPeerThread);
begin
  AThread.Connection.WriteLn('Welcome to the EzGIS TCP client/server demo');
  lbProcesses.Items.Add(Format('Connected %s',[AThread.Connection.LocalName]));
end;

procedure TfrmMain.btnExitClick(Sender: TObject);
begin
if fServerRunning then
    if StopServer then
        application.terminate
    else
        MessageDlg('Cannot exit - unable to stop server.', mtWarning, [mbOK], 0);
end;

procedure TfrmMain.IdTCPServerchOPENCommand(ASender: TIdCommand);
var
  ClientDM: TGISData;
  Path: string;                 
begin
  try
    { syntax: OPEN login password filename }
    if ASender.Params.Count<2 then
    Begin
      //ASender.Thread.Connection.WriteLn('Wrong no. of params! Good bye!');
      ASender.Thread.Connection.Disconnect;
      Exit;
    End;
    { LOGIN and PASSWORD is passed in parameters }
    ClientDM:= TGISData.Create(ASender.Thread.Connection);
    Path:= AddSlash(ExtractFilePath(ExpandFilename('..\..\data\txt.fnt')));
    If ASender.Params.Count < 3 then
      // open a default map
      ClientDM.GIS1.FileName:= {'c:\ezgis1\samples\pruebas\prueba.ezm'//Path +} 'C:\EZGIS1\DEMOS\DATA\SampleMap.Ezm'
    Else
      ClientDM.GIS1.FileName:= ASender.Params[2];

    { open the map - every thread will open the map }
    ClientDM.GIS1.Open;
  except
    ASender.Thread.Connection.Disconnect;
  end;

end;

procedure TfrmMain.IdTCPServerDisconnect(AThread: TIdPeerThread);
var
  AData: TGISData;
begin
  AData:=FindModule(AThread.Connection);
  if AData<> nil then
     AData.Free;
  lbProcesses.Items.Add(Format('DisConnected %s',[AThread.Connection.LocalName]));
end;

Function TfrmMain.GetLayer(ASender: TIdCommand): TEzBaseLayer;
var
  AData: TGISData;
Begin
  Result:= Nil;
  AData:=FindModule(ASender.Thread.Connection);
  if AData=nil then Exit;
  Result:= AData.GIS1.Layers.LayerByName(ASender.Thread.Connection.ReadLn);
End;

Function TfrmMain.GetGIS(ASender: TIdCommand): TEzBaseGIS;
var
  AData: TGISData;
Begin
  Result:= Nil;
  AData:=FindModule(ASender.Thread.Connection);
  if AData=nil then Exit;
  Result:= AData.GIS1;
End;

procedure TfrmMain.IdTCPServerchCLOSECommand(ASender: TIdCommand);
begin
  ASender.Thread.Connection.Disconnect;
end;

procedure TfrmMain.IdTCPServerchDBT_GETRECNOCommand(ASender: TIdCommand);
var
  Layer: TEzBaseLayer;
begin
  Layer:= GetLayer(ASender);
  If Layer = Nil then
  begin
    Asender.Thread.Connection.Disconnect;
    Exit;
  end;
  ASender.Thread.Connection.WriteInteger(Layer.DBTable.Recno);
end;

procedure TfrmMain.IdTCPServerchDBT_SETRECNOCommand(ASender: TIdCommand);
var
  Layer: TEzBaseLayer;
begin
  Layer:= GetLayer(ASender);
  If Layer = Nil then
  begin
    Asender.Thread.Connection.Disconnect;
    Exit;
  end;
  Layer.DBTable.Recno:= Asender.Thread.Connection.ReadInteger;
end;

procedure TfrmMain.IdTCPServerchDBT_BOFCommand(ASender: TIdCommand);
var
  Layer: TEzBaseLayer;
begin
  Layer:= GetLayer(ASender);
  If Layer = Nil then
  begin
    Asender.Thread.Connection.Disconnect;
    Exit;
  end;
  ASender.Thread.Connection.WriteSmallInt(Ord(Layer.DBTable.BOF));
end;

procedure TfrmMain.IdTCPServerchDBT_EOFCommand(ASender: TIdCommand);
var
  Layer: TEzBaseLayer;
begin
  Layer:= GetLayer(ASender);
  If Layer = Nil then
  begin
    Asender.Thread.Connection.Disconnect;
    Exit;
  end;
  ASender.Thread.Connection.WriteSmallInt(Ord(Layer.DBTable.EOF));
end;

procedure TfrmMain.IdTCPServerchDBT_DATEGETCommand(ASender: TIdCommand);
var
  Value: Double;
  Layer: TEzBaseLayer;
begin
  Layer:= GetLayer(ASender);
  If Layer = Nil then
  begin
    Asender.Thread.Connection.Disconnect;
    Exit;
  end;
  Value:= Layer.DBTable.DateGet(ASender.Thread.Connection.ReadLn);
  ASender.Thread.Connection.WriteBuffer(Value,SizeOf(Value));
end;

procedure TfrmMain.IdTCPServerchDBT_DATEGETNCommand(ASender: TIdCommand);
var
  Value: Double;
  Layer: TEzBaseLayer;
begin
  Layer:= GetLayer(ASender);
  If Layer = Nil then
  begin
    Asender.Thread.Connection.Disconnect;
    Exit;
  end;
  Value:= Layer.DBTable.DateGetN(ASender.Thread.Connection.ReadInteger);
  ASender.Thread.Connection.WriteBuffer(Value,SizeOf(Value));
end;

procedure TfrmMain.IdTCPServerchDELETEDCommand(ASender: TIdCommand);
var
  Layer: TEzBaseLayer;
begin
  Layer:= GetLayer(ASender);
  If Layer = Nil then
  begin
    Asender.Thread.Connection.Disconnect;
    Exit;
  end;
  ASender.Thread.Connection.WriteSmallInt(Ord(Layer.DBTable.Deleted));
end;

procedure TfrmMain.IdTCPServerchDBT_FIELDCommand(ASender: TIdCommand);
var
  Layer: TEzBaseLayer;
begin
  Layer:= GetLayer(ASender);
  If Layer = Nil then
  begin
    Asender.Thread.Connection.Disconnect;
    Exit;
  end;
  ASender.Thread.Connection.WriteLn(Layer.DBTable.Field(ASender.Thread.Connection.ReadInteger));
end;

procedure TfrmMain.IdTCPServerchDBT_FIELDCOUNTCommand(ASender: TIdCommand);
var
  Layer: TEzBaseLayer;
begin
  Layer:= GetLayer(ASender);
  If Layer = Nil then
  begin
    Asender.Thread.Connection.Disconnect;
    Exit;
  end;
  ASender.Thread.Connection.WriteInteger(Layer.DBTable.FieldCount);
end;

procedure TfrmMain.IdTCPServerchDBT_FIELDDECCommand(ASender: TIdCommand);
var
  Layer: TEzBaseLayer;
begin
  Layer:= GetLayer(ASender);
  If Layer = Nil then
  begin
    Asender.Thread.Connection.Disconnect;
    Exit;
  end;
  ASender.Thread.Connection.WriteInteger(Layer.DBTable.FieldDec(ASender.Thread.Connection.ReadInteger));
end;

procedure TfrmMain.IdTCPServerchDBT_FIELDGETCommand(ASender: TIdCommand);
var
  Layer: TEzBaseLayer;
begin
  Layer:= GetLayer(ASender);
  If Layer = Nil then
  begin
    Asender.Thread.Connection.Disconnect;
    Exit;
  end;
  ASender.Thread.Connection.WriteLn(Layer.DBTable.FieldGet(ASender.Thread.Connection.ReadLn));
end;

procedure TfrmMain.IdTCPServerchDBT_FIELDGETNCommand(ASender: TIdCommand);
var
  Layer: TEzBaseLayer;
begin
  Layer:= GetLayer(ASender);
  If Layer = Nil then
  begin
    Asender.Thread.Connection.Disconnect;
    Exit;
  end;
  ASender.Thread.Connection.WriteLn(Layer.DBTable.FieldGetN(ASender.Thread.Connection.ReadInteger));
end;

procedure TfrmMain.IdTCPServerchDBT_FIELDLENCommand(ASender: TIdCommand);
var
  Layer: TEzBaseLayer;
begin
  Layer:= GetLayer(ASender);
  If Layer = Nil then
  begin
    Asender.Thread.Connection.Disconnect;
    Exit;
  end;
  ASender.Thread.Connection.WriteInteger(Layer.DBTable.FieldLen(ASender.Thread.Connection.ReadInteger));
end;

procedure TfrmMain.IdTCPServerchDBT_FIELDNOCommand(ASender: TIdCommand);
var
  Layer: TEzBaseLayer;
begin
  Layer:= GetLayer(ASender);
  If Layer = Nil then
  begin
    Asender.Thread.Connection.Disconnect;
    Exit;
  end;
  ASender.Thread.Connection.WriteInteger(Layer.DBTable.FieldNo(ASender.Thread.Connection.ReadLn));
end;

procedure TfrmMain.IdTCPServerchDBT_FIELDTYPECommand(ASender: TIdCommand);
var
  Layer: TEzBaseLayer;
begin
  Layer:= GetLayer(ASender);
  If Layer = Nil then
  begin
    Asender.Thread.Connection.Disconnect;
    Exit;
  end;
  ASender.Thread.Connection.WriteSmallInt(Ord(Layer.DBTable.FieldType(ASender.Thread.Connection.ReadInteger)));
end;

procedure TfrmMain.IdTCPServerchDBT_FINDCommand(ASender: TIdCommand);
var
  ss: string;
  IsExact, IsNear: boolean;
  Layer: TEzBaseLayer;
begin
  Layer:= GetLayer(ASender);
  If Layer = Nil then
  begin
    Asender.Thread.Connection.Disconnect;
    Exit;
  end;
  ss:= ASender.Thread.Connection.ReadLn;
  IsExact:= ASender.Thread.Connection.ReadSmallInt <> 0;
  IsNear:= ASender.Thread.Connection.ReadSmallInt <> 0;
  ASender.Thread.Connection.WriteSmallInt(Ord(Layer.DBTable.Find(ss,IsExact,IsNear)));
end;

procedure TfrmMain.IdTCPServerchDBT_FLOATGETCommand(ASender: TIdCommand);
var
  value:double;
  Layer: TEzBaseLayer;
begin
  Layer:= GetLayer(ASender);
  If Layer = Nil then
  begin
    Asender.Thread.Connection.Disconnect;
    Exit;
  end;
  value:= Layer.DBTable.FloatGet(ASender.Thread.Connection.ReadLn);
  ASender.Thread.Connection.WriteBuffer(value,sizeof(value));
end;

procedure TfrmMain.IdTCPServerchDBT_FLOATGETNCommand(ASender: TIdCommand);
var
  value:double;
  Layer: TEzBaseLayer;
begin
  Layer:= GetLayer(ASender);
  If Layer = Nil then
  begin
    Asender.Thread.Connection.Disconnect;
    Exit;
  end;
  value:= Layer.DBTable.FloatGetN(ASender.Thread.Connection.ReadInteger);
  ASender.Thread.Connection.WriteBuffer(value,sizeof(value));
end;

procedure TfrmMain.IdTCPServerCHDBT_INDEXCOUNTCommand(ASender: TIdCommand);
var
  Layer: TEzBaseLayer;
begin
  Layer:= GetLayer(ASender);
  If Layer = Nil then
  begin
    Asender.Thread.Connection.Disconnect;
    Exit;
  end;
  ASender.Thread.Connection.WriteInteger(Layer.DBTable.IndexCount);
end;

procedure TfrmMain.IdTCPServerchDBT_GETACTIVECommand(ASender: TIdCommand);
var
  Layer: TEzBaseLayer;
begin
  Layer:= GetLayer(ASender);
  If Layer = Nil then
  begin
    Asender.Thread.Connection.Disconnect;
    Exit;
  end;
  ASender.Thread.Connection.WriteSmallInt(Ord(Layer.DBTable.Active));
end;

procedure TfrmMain.IdTCPServerchDBT_SETACTIVECommand(ASender: TIdCommand);
var
  Value: SmallInt;
  Layer: TEzBaseLayer;
begin
  Layer:= GetLayer(ASender);
  If Layer = Nil then
  begin
    Asender.Thread.Connection.Disconnect;
    Exit;
  end;
  value:= ASender.Thread.Connection.ReadSmallInt;
  Layer.DBTable.Active:= Value <> 0;
end;

procedure TfrmMain.IdTCPServerchDBT_INDEXASCENDINGCommand(
  ASender: TIdCommand);
var
  Layer: TEzBaseLayer;
begin
  Layer:= GetLayer(ASender);
  If Layer = Nil then
  begin
    Asender.Thread.Connection.Disconnect;
    Exit;
  end;
  ASender.Thread.Connection.WriteSmallInt(Ord(Layer.DBTable.IndexAscending(ASender.Thread.Connection.ReadInteger)));
end;

procedure TfrmMain.IdTCPServerchDBT_INDEXCommand(ASender: TIdCommand);
var
  INames, ITag: string;
  Layer: TEzBaseLayer;
begin
  Layer:= GetLayer(ASender);
  If Layer = Nil then
  begin
    Asender.Thread.Connection.Disconnect;
    Exit;
  end;
  INames:= ASender.Thread.Connection.ReadLn;
  ITag:= ASender.Thread.Connection.ReadLn;
  ASender.Thread.Connection.WriteInteger(Layer.DBTable.Index( INames, ITag ));
end;

procedure TfrmMain.IdTCPServerchDBT_INDEXCURRENTCommand(
  ASender: TIdCommand);
var
  Layer: TEzBaseLayer;
begin
  Layer:= GetLayer(ASender);
  If Layer = Nil then
  begin
    Asender.Thread.Connection.Disconnect;
    Exit;
  end;
  ASender.Thread.Connection.WriteLn(Layer.DBTable.IndexCurrent);
end;

procedure TfrmMain.IdTCPServerchDBT_INDEXUNIQUECommand(
  ASender: TIdCommand);
var
  Layer: TEzBaseLayer;
begin
  Layer:= GetLayer(ASender);
  If Layer = Nil then
  begin
    Asender.Thread.Connection.Disconnect;
    Exit;
  end;
  ASender.Thread.Connection.WriteSmallInt(Ord(Layer.DBTable.IndexUnique(ASender.Thread.Connection.ReadInteger)));
end;

procedure TfrmMain.IdTCPServerchDBT_INDEXUEXPRESSIONCommand(
  ASender: TIdCommand);
var
  Layer: TEzBaseLayer;
begin
  Layer:= GetLayer(ASender);
  If Layer = Nil then
  begin
    Asender.Thread.Connection.Disconnect;
    Exit;
  end;
  ASender.Thread.Connection.WriteLn(Layer.DBTable.IndexExpression(ASender.Thread.Connection.ReadInteger));
end;

procedure TfrmMain.IdTCPServerchDBT_INDEXTAGNAMECommand(
  ASender: TIdCommand);
var
  Layer: TEzBaseLayer;
begin
  Layer:= GetLayer(ASender);
  If Layer = Nil then
  begin
    Asender.Thread.Connection.Disconnect;
    Exit;
  end;
  ASender.Thread.Connection.WriteLn(Layer.DBTable.IndexTagName(ASender.Thread.Connection.ReadInteger));
end;


procedure TfrmMain.IdTCPServerchDBT_INDEXFILTERCommand(
  ASender: TIdCommand);
var
  Layer: TEzBaseLayer;
begin
  Layer:= GetLayer(ASender);
  If Layer = Nil then
  begin
    Asender.Thread.Connection.Disconnect;
    Exit;
  end;
  ASender.Thread.Connection.WriteLn(Layer.DBTable.IndexFilter(ASender.Thread.Connection.ReadInteger));
end;

procedure TfrmMain.IdTCPServerchDBT_INTEGERGETCommand(ASender: TIdCommand);
var
  Layer: TEzBaseLayer;
begin
  Layer:= GetLayer(ASender);
  If Layer = Nil then
  begin
    Asender.Thread.Connection.Disconnect;
    Exit;
  end;
  ASender.Thread.Connection.WriteInteger(Layer.DBTable.IntegerGet(ASender.Thread.Connection.ReadLn));
end;

procedure TfrmMain.IdTCPServerchDBT_INTEGERGETNCommand(
  ASender: TIdCommand);
var
  Layer: TEzBaseLayer;
begin
  Layer:= GetLayer(ASender);
  If Layer = Nil then
  begin
    Asender.Thread.Connection.Disconnect;
    Exit;
  end;
  ASender.Thread.Connection.WriteInteger(Layer.DBTable.IntegerGetN(ASender.Thread.Connection.ReadInteger));
end;

procedure TfrmMain.IdTCPServerchDBT_LOGICGETCommand(ASender: TIdCommand);
var
  Layer: TEzBaseLayer;
begin
  Layer:= GetLayer(ASender);
  If Layer = Nil then
  begin
    Asender.Thread.Connection.Disconnect;
    Exit;
  end;
  ASender.Thread.Connection.WriteSmallInt(Ord(Layer.DBTable.LogicGet(ASender.Thread.Connection.ReadLn)));
end;

procedure TfrmMain.IdTCPServerchDBT_LOGICGETNCommand(ASender: TIdCommand);
var
  Layer: TEzBaseLayer;
begin
  Layer:= GetLayer(ASender);
  If Layer = Nil then
  begin
    Asender.Thread.Connection.Disconnect;
    Exit;
  end;
  ASender.Thread.Connection.WriteSmallInt(Ord(Layer.DBTable.LogicGetN(ASender.Thread.Connection.ReadInteger)));
end;

procedure TfrmMain.IdTCPServerchDBT_MEMOSAVECommand(ASender: TIdCommand);
var
  FieldName: string;
  Stream: TStream;
var
  Layer: TEzBaseLayer;
begin
  Layer:= GetLayer(ASender);
  If Layer = Nil then
  begin
    Asender.Thread.Connection.Disconnect;
    Exit;
  end;
  FieldName:= ASender.Thread.Connection.ReadLn;
  Stream:= TMemoryStream.create;
  try
    ASender.Thread.Connection.ReadStream(Stream,-1,False);
{$IFDEF TRANSPORT_COMPRESSED}
    Stream.Position:= 0;
    DeCompressMemStream(TMemoryStream(Stream));
{$ENDIF}
    Stream.Position:= 0;
    Layer.DBTable.MemoSave( FieldName, Stream );
  finally
    Stream.free;
  end;
end;

procedure TfrmMain.IdTCPServerchDBT_MEMOSAVENCommand(ASender: TIdCommand);
var
  FieldNo: integer;
  Stream: TStream;
var
  Layer: TEzBaseLayer;
begin
  Layer:= GetLayer(ASender);
  If Layer = Nil then
  begin
    Asender.Thread.Connection.Disconnect;
    Exit;
  end;
  FieldNo:= ASender.Thread.Connection.ReadInteger;
  Stream:= TMemoryStream.create;
  try
    ASender.Thread.Connection.ReadStream(Stream,-1,False);
{$IFDEF TRANSPORT_COMPRESSED}
    Stream.Position:= 0;
    DeCompressMemStream(TMemoryStream(Stream));
{$ENDIF}
    Stream.Position:= 0;
    Layer.DBTable.MemoSaveN( FieldNo, Stream );
  finally
    Stream.free;
  end;
end;

procedure TfrmMain.IdTCPServerchDBT_MEMOSIZECommand(ASender: TIdCommand);
var
  Layer: TEzBaseLayer;
begin
  Layer:= GetLayer(ASender);
  If Layer = Nil then
  begin
    Asender.Thread.Connection.Disconnect;
    Exit;
  end;
  ASender.Thread.Connection.WriteInteger(Layer.DBTable.MemoSize(ASender.Thread.Connection.ReadLn));
end;

procedure TfrmMain.IdTCPServerchDBT_MEMOSIZENCommand(ASender: TIdCommand);
var
  Layer: TEzBaseLayer;
begin
  Layer:= GetLayer(ASender);
  If Layer = Nil then
  begin
    Asender.Thread.Connection.Disconnect;
    Exit;
  end;
  ASender.Thread.Connection.WriteInteger(Layer.DBTable.MemoSizeN(ASender.Thread.Connection.ReadInteger));
end;

procedure TfrmMain.IdTCPServerchDBT_RECORDCOUNTCommand(
  ASender: TIdCommand);
var
  Layer: TEzBaseLayer;
begin
  Layer:= GetLayer(ASender);
  If Layer = Nil then
  begin
    Asender.Thread.Connection.Disconnect;
    Exit;
  end;
  ASender.Thread.Connection.WriteInteger(Layer.DBTable.RecordCount);
end;

procedure TfrmMain.IdTCPServerchDBT_STRINGGETCommand(ASender: TIdCommand);
var
  Layer: TEzBaseLayer;
begin
  Layer:= GetLayer(ASender);
  If Layer = Nil then
  begin
    Asender.Thread.Connection.Disconnect;
    Exit;
  end;
  ASender.Thread.Connection.WriteLn(Layer.DBTable.StringGet(ASender.Thread.Connection.ReadLn));
end;

procedure TfrmMain.IdTCPServerchDBT_STRINGGETNCommand(ASender: TIdCommand);
var
  Layer: TEzBaseLayer;
begin
  Layer:= GetLayer(ASender);
  If Layer = Nil then
  begin
    Asender.Thread.Connection.Disconnect;
    Exit;
  end;
  ASender.Thread.Connection.WriteLn(Layer.DBTable.StringGetN(ASender.Thread.Connection.ReadInteger));
end;

procedure TfrmMain.IdTCPServerchDBT_DATEPUTCommand(ASender: TIdCommand);
var
  FieldName:string;
  Value: TDateTime;
var
  Layer: TEzBaseLayer;
begin
  Layer:= GetLayer(ASender);
  If Layer = Nil then
  begin
    Asender.Thread.Connection.Disconnect;
    Exit;
  end;
  FieldName:=ASender.Thread.Connection.ReadLn;
  ASender.Thread.Connection.ReadBuffer(value,sizeof(value));
  Layer.DBTable.DatePut(FieldName,value);
end;

procedure TfrmMain.IdTCPServerchDBT_DATEPUTNCommand(ASender: TIdCommand);
var
  FieldNo:integer;
  Value: TDateTime;
var
  Layer: TEzBaseLayer;
begin
  Layer:= GetLayer(ASender);
  If Layer = Nil then
  begin
    Asender.Thread.Connection.Disconnect;
    Exit;
  end;
  FieldNo:=ASender.Thread.Connection.ReadInteger;
  ASender.Thread.Connection.ReadBuffer(value,sizeof(value));
  Layer.DBTable.DatePutN(FieldNo,value);
end;

procedure TfrmMain.IdTCPServerchDBT_DELETECommand(ASender: TIdCommand);
var
  Layer: TEzBaseLayer;
begin
  Layer:= GetLayer(ASender);
  If Layer = Nil then
  begin
    Asender.Thread.Connection.Disconnect;
    Exit;
  end;
  Layer.DBTable.Delete;
end;

procedure TfrmMain.IdTCPServerchDBT_EDITCommand(ASender: TIdCommand);
var
  Layer: TEzBaseLayer;
begin
  Layer:= GetLayer(ASender);
  If Layer = Nil then
  begin
    Asender.Thread.Connection.Disconnect;
    Exit;
  end;
  Layer.DBTable.Edit;
end;

procedure TfrmMain.IdTCPServerchDBT_FIELDPUTCommand(ASender: TIdCommand);
var
  Fieldname,value:string;
var
  Layer: TEzBaseLayer;
begin
  Layer:= GetLayer(ASender);
  If Layer = Nil then
  begin
    Asender.Thread.Connection.Disconnect;
    Exit;
  end;
  FieldName:=ASender.Thread.Connection.ReadLn;
  Value:=ASender.Thread.Connection.ReadLn;
  Layer.DBTable.FieldPut(Fieldname,value);
end;

procedure TfrmMain.IdTCPServerchDBT_FIELDPUTNCommand(ASender: TIdCommand);
var
  FieldNo: integer;
  value:string;
var
  Layer: TEzBaseLayer;
begin
  Layer:= GetLayer(ASender);
  If Layer = Nil then
  begin
    Asender.Thread.Connection.Disconnect;
    Exit;
  end;
  FieldNo:=ASender.Thread.Connection.ReadInteger;
  Value:=ASender.Thread.Connection.ReadLn;
  Layer.DBTable.FieldPutN(FieldNo,value);
end;

procedure TfrmMain.IdTCPServerchDBT_FIRSTCommand(ASender: TIdCommand);
var
  Layer: TEzBaseLayer;
begin
  Layer:= GetLayer(ASender);
  If Layer = Nil then
  begin
    Asender.Thread.Connection.Disconnect;
    Exit;
  end;
  Layer.DBTable.First;
end;

procedure TfrmMain.IdTCPServerchDBT_FLOATPUTCommand(ASender: TIdCommand);
var
  FieldName:string;
  value:double;
var
  Layer: TEzBaseLayer;
begin
  Layer:= GetLayer(ASender);
  If Layer = Nil then
  begin
    Asender.Thread.Connection.Disconnect;
    Exit;
  end;
  FieldName:=ASender.Thread.Connection.ReadLn;
  ASender.Thread.Connection.ReadBuffer(value,sizeof(value));
  Layer.DBTable.FloatPut(Fieldname,value);
end;

procedure TfrmMain.IdTCPServerchDBT_FLOATPUTNCommand(ASender: TIdCommand);
var
  FieldNo:integer;
  value:double;
var
  Layer: TEzBaseLayer;
begin
  Layer:= GetLayer(ASender);
  If Layer = Nil then
  begin
    Asender.Thread.Connection.Disconnect;
    Exit;
  end;
  FieldNo:=ASender.Thread.Connection.ReadInteger;
  ASender.Thread.Connection.ReadBuffer(value,sizeof(value));
  Layer.DBTable.FloatPutN(FieldNo,value);
end;

procedure TfrmMain.IdTCPServerchDBT_FLUSHDBCommand(ASender: TIdCommand);
var
  Layer: TEzBaseLayer;
begin
  Layer:= GetLayer(ASender);
  If Layer = Nil then
  begin
    Asender.Thread.Connection.Disconnect;
    Exit;
  end;
  Layer.DBTable.FlushDB;
end;

procedure TfrmMain.IdTCPServerchDBT_GOCommand(ASender: TIdCommand);
var
  Layer: TEzBaseLayer;
begin
  Layer:= GetLayer(ASender);
  If Layer = Nil then
  begin
    Asender.Thread.Connection.Disconnect;
    Exit;
  end;
  Layer.DBTable.Go(ASender.Thread.Connection.Readinteger);
end;

procedure TfrmMain.IdTCPServerchDBT_INDEXONCommand(ASender: TIdCommand);
var
  IName, tag, keyexp, forexp: String;
  uniq: TEzIndexUnique;
  ascnd: TEzSortStatus;
var
  Layer: TEzBaseLayer;
begin
  Layer:= GetLayer(ASender);
  If Layer = Nil then
  begin
    Asender.Thread.Connection.Disconnect;
    Exit;
  end;
  IName:=ASender.Thread.Connection.ReadLn;
  tag:=ASender.Thread.Connection.ReadLn;
  keyexp:=ASender.Thread.Connection.ReadLn;
  forexp:=ASender.Thread.Connection.ReadLn;
  uniq:=TEzIndexUnique(ASender.Thread.Connection.ReadSmallInt);
  ascnd:=TEzSortStatus(ASender.Thread.Connection.ReadSmallInt);
  Layer.DBTable.IndexOn(IName,tag,keyexp,forexp,uniq,ascnd);
end;

procedure TfrmMain.IdTCPServerchDBT_INTEGERPUTCommand(ASender: TIdCommand);
var
  Fieldname:string;
  value:integer;
var
  Layer: TEzBaseLayer;
begin
  Layer:= GetLayer(ASender);
  If Layer = Nil then
  begin
    Asender.Thread.Connection.Disconnect;
    Exit;
  end;
  Fieldname:=ASender.Thread.Connection.ReadLn;
  value:=ASender.Thread.Connection.ReadInteger;
  Layer.DBTable.IntegerPut(Fieldname,value);
end;

procedure TfrmMain.IdTCPServerchDBT_INTEGERPUTNCommand(
  ASender: TIdCommand);
var
  FieldNO: integer;
  value:integer;
var
  Layer: TEzBaseLayer;
begin
  Layer:= GetLayer(ASender);
  If Layer = Nil then
  begin
    Asender.Thread.Connection.Disconnect;
    Exit;
  end;
  FieldNO:=ASender.Thread.Connection.ReadInteger;
  value:=ASender.Thread.Connection.ReadInteger;
  Layer.DBTable.IntegerPutN(FieldNO,value);
end;

procedure TfrmMain.IdTCPServerchDBT_LASTCommand(ASender: TIdCommand);
var
  Layer: TEzBaseLayer;
begin
  Layer:= GetLayer(ASender);
  If Layer = Nil then
  begin
    Asender.Thread.Connection.Disconnect;
    Exit;
  end;
  Layer.DBTable.Last;
end;

procedure TfrmMain.IdTCPServerchDBT_LOGICPUTCommand(ASender: TIdCommand);
var
  FieldName: string;
  value:boolean;
var
  Layer: TEzBaseLayer;
begin
  Layer:= GetLayer(ASender);
  If Layer = Nil then
  begin
    Asender.Thread.Connection.Disconnect;
    Exit;
  end;
  Fieldname:=ASender.Thread.Connection.ReadLn;
  value:=ASender.Thread.Connection.ReadSmallInt<>0;
  Layer.DBTable.LogicPut(Fieldname,value);
end;

procedure TfrmMain.IdTCPServerchDBT_LOGICPUTNCommand(ASender: TIdCommand);
var
  FieldNo: integer;
  value:boolean;
var
  Layer: TEzBaseLayer;
begin
  Layer:= GetLayer(ASender);
  If Layer = Nil then
  begin
    Asender.Thread.Connection.Disconnect;
    Exit;
  end;
  Fieldno:=ASender.Thread.Connection.Readinteger;
  value:=ASender.Thread.Connection.ReadSmallInt<>0;
  Layer.DBTable.LogicPutN(Fieldno,value);
end;

procedure TfrmMain.IdTCPServerchDBT_MEMOLOADCommand(ASender: TIdCommand);
var
  FieldName: string;
  stream: TStream;
var
  Layer: TEzBaseLayer;
begin
  Layer:= GetLayer(ASender);
  If Layer = Nil then
  begin
    Asender.Thread.Connection.Disconnect;
    Exit;
  end;
  FieldName:=ASender.Thread.Connection.ReadLn;
  Stream:= TMemoryStream.create;
  try
    Layer.DBTable.MemoLoad( FieldName, Stream );
    Stream.Position:= 0;
{$IFDEF TRANSPORT_COMPRESSED}
    CompressmemStream(TMemoryStream(Stream), 1);
    Stream.Position:= 0;
{$ENDIF}
    ASender.Thread.Connection.OpenWriteBuffer;
    ASender.Thread.Connection.WriteStream(Stream,true,true);
    ASender.Thread.Connection.CloseWriteBuffer;
  finally
    Stream.free;
  end;
end;

procedure TfrmMain.IdTCPServerchDBT_MEMOLOADNCommand(ASender: TIdCommand);
var
  FieldNo: integer;
  stream: TStream;
var
  Layer: TEzBaseLayer;
begin
  Layer:= GetLayer(ASender);
  If Layer = Nil then
  begin
    Asender.Thread.Connection.Disconnect;
    Exit;
  end;
  FieldNo:=ASender.Thread.Connection.ReadInteger;
  Stream:= TMemoryStream.create;
  try
    Layer.DBTable.MemoLoadN( FieldNo, Stream );
    Stream.Position:= 0;
{$IFDEF TRANSPORT_COMPRESSED}
    CompressmemStream(TMemoryStream(Stream), 1);
    Stream.Position:= 0;
{$ENDIF}
    ASender.Thread.Connection.OpenWriteBuffer;
    ASender.Thread.Connection.WriteStream(Stream,true,true);
    ASender.Thread.Connection.CloseWriteBuffer;
  finally
    Stream.free;
  end;
end;

procedure TfrmMain.IdTCPServerchDBT_NEXTCommand(ASender: TIdCommand);
var
  Layer: TEzBaseLayer;
begin
  Layer:= GetLayer(ASender);
  If Layer = Nil then
  begin
    Asender.Thread.Connection.Disconnect;
    Exit;
  end;
  Layer.DBTable.Next;
end;

procedure TfrmMain.IdTCPServerchDBT_PACKCommand(ASender: TIdCommand);
var
  Layer: TEzBaseLayer;
begin
  Layer:= GetLayer(ASender);
  If Layer = Nil then
  begin
    Asender.Thread.Connection.Disconnect;
    Exit;
  end;
  Layer.DBTable.Pack;
end;

procedure TfrmMain.IdTCPServerchDBT_POSTCommand(ASender: TIdCommand);
var
  Layer: TEzBaseLayer;
begin
  Layer:= GetLayer(ASender);
  If Layer = Nil then
  begin
    Asender.Thread.Connection.Disconnect;
    Exit;
  end;
  Layer.DBTable.Post;
end;

procedure TfrmMain.IdTCPServerchDBT_PRIORCommand(ASender: TIdCommand);
var
  Layer: TEzBaseLayer;
begin
  Layer:= GetLayer(ASender);
  If Layer = Nil then
  begin
    Asender.Thread.Connection.Disconnect;
    Exit;
  end;
  Layer.DBTable.Prior;
end;

procedure TfrmMain.IdTCPServerchDBT_RECALLCommand(ASender: TIdCommand);
var
  Layer: TEzBaseLayer;
begin
  Layer:= GetLayer(ASender);
  If Layer = Nil then
  begin
    Asender.Thread.Connection.Disconnect;
    Exit;
  end;
  Layer.DBTable.Recall;
end;

procedure TfrmMain.IdTCPServerchDBT_REFRESHCommand(ASender: TIdCommand);
var
  Layer: TEzBaseLayer;
begin
  Layer:= GetLayer(ASender);
  If Layer = Nil then
  begin
    Asender.Thread.Connection.Disconnect;
    Exit;
  end;
  Layer.DBTable.Refresh;
end;

procedure TfrmMain.IdTCPServerchDBT_REINDEXCommand(ASender: TIdCommand);
var
  Layer: TEzBaseLayer;
begin
  Layer:= GetLayer(ASender);
  If Layer = Nil then
  begin
    Asender.Thread.Connection.Disconnect;
    Exit;
  end;
  Layer.DBTable.ReIndex;
end;

procedure TfrmMain.IdTCPServerchDBT_SETTAGTOCommand(ASender: TIdCommand);
var
  Layer: TEzBaseLayer;
begin
  Layer:= GetLayer(ASender);
  If Layer = Nil then
  begin
    Asender.Thread.Connection.Disconnect;
    Exit;
  end;
  Layer.DBTable.SetTagTo(ASender.Thread.Connection.ReadLn);
end;

procedure TfrmMain.IdTCPServerchDBT_SETUSEDELETEDCommand(
  ASender: TIdCommand);
var
  Layer: TEzBaseLayer;
begin
  Layer:= GetLayer(ASender);
  If Layer = Nil then
  begin
    Asender.Thread.Connection.Disconnect;
    Exit;
  end;
  Layer.DBTable.SetUseDeleted(ASender.Thread.Connection.ReadSmallInt<>0);
end;

procedure TfrmMain.IdTCPServerchDBT_STRINGPUTCommand(ASender: TIdCommand);
var
  Fieldname,value:string;
var
  Layer: TEzBaseLayer;
begin
  Layer:= GetLayer(ASender);
  If Layer = Nil then
  begin
    Asender.Thread.Connection.Disconnect;
    Exit;
  end;
  Fieldname:=ASender.Thread.Connection.ReadLn;
  value:=ASender.Thread.Connection.ReadLn;
  Layer.DBTable.StringPut(Fieldname,value);
end;

procedure TfrmMain.IdTCPServerchDBT_STRINGPUTNCommand(ASender: TIdCommand);
var
  Fieldno:integer;
  value:string;
var
  Layer: TEzBaseLayer;
begin
  Layer:= GetLayer(ASender);
  If Layer = Nil then
  begin
    Asender.Thread.Connection.Disconnect;
    Exit;
  end;
  Fieldno:=ASender.Thread.Connection.ReadInteger;
  value:=ASender.Thread.Connection.ReadLn;
  Layer.DBTable.StringPutN(Fieldno,value);
end;

procedure TfrmMain.IdTCPServerchDBT_ZAPCommand(ASender: TIdCommand);
var
  Layer: TEzBaseLayer;
begin
  Layer:= GetLayer(ASender);
  If Layer = Nil then
  begin
    Asender.Thread.Connection.Disconnect;
    Exit;
  end;
  Layer.DBTable.Zap;
end;

procedure TfrmMain.IdTCPServerchDBT_BEGINTRANSCommand(ASender: TIdCommand);
var
  Layer: TEzBaseLayer;
begin
  Layer:= GetLayer(ASender);
  If Layer = Nil then
  begin
    Asender.Thread.Connection.Disconnect;
    Exit;
  end;
  Layer.DBTable.BeginTrans;
end;

procedure TfrmMain.IdTCPServerchDBT_ENDTRANSCommand(ASender: TIdCommand);
var
  Layer: TEzBaseLayer;
begin
  Layer:= GetLayer(ASender);
  If Layer = Nil then
  begin
    Asender.Thread.Connection.Disconnect;
    Exit;
  end;
  Layer.DBTable.EndTrans;
end;

procedure TfrmMain.IdTCPServerchDBT_ROLLBACKTRANSCommand(
  ASender: TIdCommand);
var
  Layer: TEzBaseLayer;
begin
  Layer:= GetLayer(ASender);
  If Layer = Nil then
  begin
    Asender.Thread.Connection.Disconnect;
    Exit;
  end;
  Layer.DBTable.RollBackTrans;
end;

procedure TfrmMain.IdTCPServerchLI_GETVISIBLECommand(ASender: TIdCommand);
var
  Layer: TEzBaseLayer;
begin
  Layer:= GetLayer(ASender);
  If Layer = Nil then
  begin
    Asender.Thread.Connection.Disconnect;
    Exit;
  end;
  Asender.Thread.Connection.WriteSmallInt(Ord(Layer.LayerInfo.Visible));
end;

procedure TfrmMain.IdTCPServerchLI_SETVISIBLECommand(ASender: TIdCommand);
var
  Layer: TEzBaseLayer;
begin
  Layer:= GetLayer(ASender);
  If Layer = Nil then
  begin
    Asender.Thread.Connection.Disconnect;
    Exit;
  end;
  Layer.LayerInfo.Visible:= Asender.Thread.Connection.ReadSmallInt<>0;
end;

procedure TfrmMain.IdTCPServerchLI_GETSELECTABLECommand(
  ASender: TIdCommand);
var
  Layer: TEzBaseLayer;
begin
  Layer:= GetLayer(ASender);
  If Layer = Nil then
  begin
    Asender.Thread.Connection.Disconnect;
    Exit;
  end;
  Asender.Thread.Connection.WriteSmallInt(Ord(Layer.LayerInfo.Selectable));
end;

procedure TfrmMain.IdTCPServerchLI_SETSELECTABLECommand(
  ASender: TIdCommand);
var
  Layer: TEzBaseLayer;
begin
  Layer:= GetLayer(ASender);
  If Layer = Nil then
  begin
    Asender.Thread.Connection.Disconnect;
    Exit;
  end;
  Layer.LayerInfo.Selectable:=Asender.Thread.Connection.ReadSmallint<>0;
end;

procedure TfrmMain.IdTCPServerchLI_GETEXTENSIONCommand(ASender: TIdCommand);
var
  Layer:TEzBaseLayer;
  Box:TEzRect;
begin
  Layer:= GetLayer(ASender);
  If Layer = Nil then
  begin
    Asender.Thread.Connection.Disconnect;
    Exit;
  end;
  Box:=Layer.LayerInfo.Extension;
  with Asender.Thread.Connection do
  begin
    WriteBuffer(Box.X1,sizeof(double));
    WriteBuffer(Box.Y1,sizeof(double));
    WriteBuffer(Box.X2,sizeof(double));
    WriteBuffer(Box.Y2,sizeof(double));
  end;
end;

procedure TfrmMain.IdTCPServerchLI_SETEXTENSIONCommand(ASender: TIdCommand);
var
  Layer:TEzBaseLayer;
  Box:TEzRect;
begin
  Layer:= GetLayer(ASender);
  If Layer = Nil then
  begin
    Asender.Thread.Connection.Disconnect;
    Exit;
  end;
  with Asender.Thread.Connection do
  begin
    ReadBuffer(Box.X1,sizeof(double));
    ReadBuffer(Box.Y1,sizeof(double));
    ReadBuffer(Box.X2,sizeof(double));
    ReadBuffer(Box.Y2,sizeof(double));
  end;
  Layer.LayerInfo.Extension:=box;
end;

procedure TfrmMain.IdTCPServerchLI_GETISCOSMETHICCommand(ASender: TIdCommand);
var
  Layer:TEzBaseLayer;
begin
  Layer:= GetLayer(ASender);
  If Layer = Nil then
  begin
    Asender.Thread.Connection.Disconnect;
    Exit;
  end;
  Asender.Thread.Connection.WriteSmallInt(Ord(Layer.LayerInfo.IsCosmethic));
end;

procedure TfrmMain.IdTCPServerchLI_SETISCOSMETHICCommand(
  ASender: TIdCommand);
var
  Layer:TEzBaseLayer;
begin
  Layer:= GetLayer(ASender);
  If Layer = Nil then
  begin
    Asender.Thread.Connection.Disconnect;
    Exit;
  end;
  Layer.LayerInfo.IsCosmethic:= Asender.Thread.Connection.ReadSmallInt<>0;
end;

procedure TfrmMain.IdTCPServerchLI_GETIDCOUNTERCommand(
  ASender: TIdCommand);
var
  Layer:TEzBaseLayer;
begin
  Layer:= GetLayer(ASender);
  If Layer = Nil then
  begin
    Asender.Thread.Connection.Disconnect;
    Exit;
  end;
  Asender.Thread.Connection.WriteInteger(Layer.LayerInfo.IDCounter);
end;

procedure TfrmMain.IdTCPServerchLI_SETIDCOUNTERCommand(
  ASender: TIdCommand);
var
  Layer:TEzBaseLayer;
begin
  Layer:= GetLayer(ASender);
  If Layer = Nil then
  begin
    Asender.Thread.Connection.Disconnect;
    Exit;
  end;
  Layer.LayerInfo.IDCounter:= Asender.Thread.Connection.ReadInteger;
end;

procedure TfrmMain.IdTCPServerchLI_GETISANIMATIONCommand(
  ASender: TIdCommand);
var
  Layer:TEzBaseLayer;
begin
  Layer:= GetLayer(ASender);
  If Layer = Nil then
  begin
    Asender.Thread.Connection.Disconnect;
    Exit;
  end;
  Asender.Thread.Connection.WriteSmallInt(ord(Layer.LayerInfo.IsAnimationLayer));
end;

procedure TfrmMain.IdTCPServerchLI_SETISANIMATIONCommand(
  ASender: TIdCommand);
var
  Layer:TEzBaseLayer;
begin
  Layer:= GetLayer(ASender);
  If Layer = Nil then
  begin
    Asender.Thread.Connection.Disconnect;
    Exit;
  end;
  Layer.LayerInfo.IsAnimationLayer:=Asender.Thread.Connection.ReadSmallInt<>0;
end;

procedure TfrmMain.IdTCPServerchLI_GETISINDEXEDCommand(
  ASender: TIdCommand);
var
  Layer:TEzBaseLayer;
begin
  Layer:= GetLayer(ASender);
  If Layer = Nil then
  begin
    Asender.Thread.Connection.Disconnect;
    Exit;
  end;
  Asender.Thread.Connection.WriteSmallInt(Ord(Layer.LayerInfo.IsIndexed));
end;

procedure TfrmMain.IdTCPServerchLI_SETISINDEXEDCommand(
  ASender: TIdCommand);
var
  Layer:TEzBaseLayer;
begin
  Layer:= GetLayer(ASender);
  If Layer = Nil then
  begin
    Asender.Thread.Connection.Disconnect;
    Exit;
  end;
  Layer.LayerInfo.IsIndexed:=Asender.Thread.Connection.ReadSmallInt<>0;
end;

procedure TfrmMain.IdTCPServerchLI_GETCOORDSUNITSCommand(
  ASender: TIdCommand);
var
  Layer:TEzBaseLayer;
begin
  Layer:= GetLayer(ASender);
  If Layer = Nil then
  begin
    Asender.Thread.Connection.Disconnect;
    Exit;
  end;
  Asender.Thread.Connection.WriteSmallInt(Ord(Layer.LayerInfo.CoordsUnits));
end;

procedure TfrmMain.IdTCPServerchLI_SETCOORDSUNITSCommand(ASender: TIdCommand);
var
  Layer:TEzBaseLayer;
begin
  Layer:= GetLayer(ASender);
  If Layer = Nil then
  begin
    Asender.Thread.Connection.Disconnect;
    Exit;
  end;
  Layer.LayerInfo.CoordsUnits:= TEzCoordsUnits(Asender.Thread.Connection.ReadSmallInt);
end;

procedure TfrmMain.IdTCPServerchLI_GETUSEATTACHEDDBCommand(
  ASender: TIdCommand);
var
  Layer:TEzBaseLayer;
begin
  Layer:= GetLayer(ASender);
  If Layer = Nil then
  begin
    Asender.Thread.Connection.Disconnect;
    Exit;
  end;
  Asender.Thread.Connection.WriteSmallInt(ord(Layer.LayerInfo.UseAttachedDB));
end;

procedure TfrmMain.IdTCPServerchLI_SETUSEATTACHEDDBCommand(
  ASender: TIdCommand);
var
  Layer:TEzBaseLayer;
begin
  Layer:= GetLayer(ASender);
  If Layer = Nil then
  begin
    Asender.Thread.Connection.Disconnect;
    Exit;
  end;
  Layer.LayerInfo.UseAttachedDB:=Asender.Thread.Connection.ReadSmallInt<>0;
end;

procedure TfrmMain.IdTCPServerchLI_GETOVERLAPPEDTEXTACTIONCommand(
  ASender: TIdCommand);
var
  Layer:TEzBaseLayer;
begin
  Layer:= GetLayer(ASender);
  If Layer = Nil then
  begin
    Asender.Thread.Connection.Disconnect;
    Exit;
  end;
  Asender.Thread.Connection.WriteSmallInt(ord(Layer.LayerInfo.OverlappedTextAction));
end;

procedure TfrmMain.IdTCPServerchLI_SETOVERLAPPEDTEXTACTIONCommand(
  ASender: TIdCommand);
var
  Layer:TEzBaseLayer;
begin
  Layer:= GetLayer(ASender);
  If Layer = Nil then
  begin
    Asender.Thread.Connection.Disconnect;
    Exit;
  end;
  Layer.LayerInfo.OverlappedTextAction:= TEzOverlappedtextaction(Asender.Thread.Connection.ReadSmallInt);
end;

procedure TfrmMain.IdTCPServerchLI_SETOVERLAPPEDTEXTCOLORCommand(
  ASender: TIdCommand);
var
  Layer:TEzBaseLayer;
begin
  Layer:= GetLayer(ASender);
  If Layer = Nil then
  begin
    Asender.Thread.Connection.Disconnect;
    Exit;
  end;
  Layer.LayerInfo.OverlappedTextColor:= TColor(Asender.Thread.Connection.ReadInteger);
end;

procedure TfrmMain.IdTCPServerchLI_GETOVERLAPPEDTEXTCOLORCommand(
  ASender: TIdCommand);
var
  Layer:TEzBaseLayer;
begin
  Layer:= GetLayer(ASender);
  If Layer = Nil then
  begin
    Asender.Thread.Connection.Disconnect;
    Exit;
  end;
  Asender.Thread.Connection.WriteInteger(Layer.LayerInfo.OverlappedTextColor);
end;

procedure TfrmMain.IdTCPServerchLI_GETTEXTFIXEDSIZECommand(
  ASender: TIdCommand);
var
  Layer:TEzBaseLayer;
begin
  Layer:= GetLayer(ASender);
  If Layer = Nil then
  begin
    Asender.Thread.Connection.Disconnect;
    Exit;
  end;
  Asender.Thread.Connection.WriteInteger(Layer.LayerInfo.TextFixedSize);
end;

procedure TfrmMain.IdTCPServerchLI_SETTEXTFIXEDSIZECommand(
  ASender: TIdCommand);
var
  Layer:TEzBaseLayer;
begin
  Layer:= GetLayer(ASender);
  If Layer = Nil then
  begin
    Asender.Thread.Connection.Disconnect;
    Exit;
  end;
  Layer.LayerInfo.TextFixedSize:=Asender.Thread.Connection.ReadInteger;
end;

procedure TfrmMain.IdTCPServerchLI_GETTEXTHASSHADOWCommand(
  ASender: TIdCommand);
var
  Layer:TEzBaseLayer;
begin
  Layer:= GetLayer(ASender);
  If Layer = Nil then
  begin
    Asender.Thread.Connection.Disconnect;
    Exit;
  end;
  Asender.Thread.Connection.WriteSmallInt(ord(Layer.LayerInfo.TextHasShadow));
end;

procedure TfrmMain.IdTCPServerchLI_SETTEXTHASSHADOWCommand(
  ASender: TIdCommand);
var
  Layer:TEzBaseLayer;
begin
  Layer:= GetLayer(ASender);
  If Layer = Nil then
  begin
    Asender.Thread.Connection.Disconnect;
    Exit;
  end;
  Layer.LayerInfo.TextHasShadow:= Asender.Thread.Connection.ReadSmallInt<>0;
end;

procedure TfrmMain.IdTCPServerchLAY_ISCLIENTSERVERCommand(
  ASender: TIdCommand);
var
  Layer:TEzBaseLayer;
begin
  Layer:= GetLayer(ASender);
  If Layer = Nil then
  begin
    Asender.Thread.Connection.Disconnect;
    Exit;
  end;
  Asender.Thread.Connection.WriteSmallInt(ord(Layer.IsClientServer));
end;

procedure TfrmMain.IdTCPServerchLAY_STARTBATCHINSERTCommand(
  ASender: TIdCommand);
var
  Layer:TEzBaseLayer;
begin
  Layer:= GetLayer(ASender);
  If Layer = Nil then
  begin
    Asender.Thread.Connection.Disconnect;
    Exit;
  end;
  Layer.StartBatchInsert;
end;

procedure TfrmMain.IdTCPServerchLAY_FINISHBATCHINSERTCommand(
  ASender: TIdCommand);
var
  Layer:TEzBaseLayer;
begin
  Layer:= GetLayer(ASender);
  If Layer = Nil then
  begin
    Asender.Thread.Connection.Disconnect;
    Exit;
  end;
  Layer.FinishBatchInsert;
end;

procedure TfrmMain.IdTCPServerchLAY_DEFINESCOPECommand(
  ASender: TIdCommand);
var
  Layer:TEzBaseLayer;
  value:boolean;
begin
  Layer:= GetLayer(ASender);
  If Layer = Nil then
  begin
    Asender.Thread.Connection.Disconnect;
    Exit;
  end;
  value:= Layer.DefineScope(Asender.Thread.Connection.ReadLn);
  Asender.Thread.Connection.WriteSmallInt(ord(value));
end;

procedure TfrmMain.IdTCPServerchLAY_DEFINEPOLYGONSCOPECommand(
  ASender: TIdCommand);
var
  Layer:TEzBaseLayer;
  value:boolean;
  Stream: TStream;
  ID: TEzEntityID;
  TmpClass: TEzEntityClass;
  Entity: TEzEntity;
  Scope:string;
  Operator: TEzGraphicOperator;
begin
  Layer:= GetLayer(ASender);
  If Layer = Nil then
  begin
    Asender.Thread.Connection.Disconnect;
    Exit;
  end;
  ID:= TEzEntityID(Asender.Thread.Connection.ReadSmallInt);
  TmpClass := GetClassFromID( ID );
  Entity:= TmpClass.Create( 1 );
  Stream:= TMemoryStream.create;
  Try
    ASender.Thread.Connection.ReadStream(Stream,-1,False);
{$IFDEF TRANSPORT_COMPRESSED}
    Stream.Position:= 0;
    DeCompressMemStream(TMemoryStream(Stream));
{$ENDIF}
    Stream.Position:= 0;
    Entity.LoadFromStream( Stream );
    Scope:= ASender.Thread.Connection.ReadLn;
    Operator:=TEzGraphicOperator(ASender.Thread.Connection.ReadSmallInt);
    // define polygon scope
    value:=Layer.DefinePolygonScope(Entity,Scope,Operator);
    Asender.Thread.Connection.WriteSmallInt(ord(value));
  Finally
    Entity.Free;
    Stream.free;
  End;
end;

procedure TfrmMain.IdTCPServerchLAY_ZAPCommand(ASender: TIdCommand);
var
  Layer:TEzBaseLayer;
begin
  Layer:= GetLayer(ASender);
  If Layer = Nil then
  begin
    Asender.Thread.Connection.Disconnect;
    Exit;
  end;
  Layer.Zap;
end;

procedure TfrmMain.IdTCPServerchLAY_GETFIELDLISTCommand(
  ASender: TIdCommand);
var
  Layer:TEzBaseLayer;
  Strings: TStrings;
begin
  Layer:= GetLayer(ASender);
  If Layer = Nil then
  begin
    Asender.Thread.Connection.Disconnect;
    Exit;
  end;
  Strings:= TStringList.create;
  try
    Layer.GetFieldList(Strings);
    Asender.Thread.Connection.WriteStrings(Strings,true);
  finally
    strings.free;
  end;
end;

procedure TfrmMain.IdTCPServerchLAY_GETRECNOCommand(ASender: TIdCommand);
var
  Layer:TEzBaseLayer;
begin
  Layer:= GetLayer(ASender);
  If Layer = Nil then
  begin
    Asender.Thread.Connection.Disconnect;
    Exit;
  end;
  Asender.Thread.Connection.WriteInteger(Layer.Recno);
end;

procedure TfrmMain.IdTCPServerchLAY_SETRECNOCommand(ASender: TIdCommand);
var
  Layer:TEzBaseLayer;
begin
  Layer:= GetLayer(ASender);
  If Layer = Nil then
  begin
    Asender.Thread.Connection.Disconnect;
    Exit;
  end;
  Layer.Recno:= Asender.Thread.Connection.ReadInteger;
end;

procedure TfrmMain.IdTCPServerchLAY_SETGRAPHICFILTERCommand(ASender: TIdCommand);
var
  Layer:TEzBaseLayer;
  s: EzRTree.TSearchType;
  VisualWindow: TEzRect;
begin
  Layer:= GetLayer(ASender);
  If Layer = Nil then
  begin
    Asender.Thread.Connection.Disconnect;
    Exit;
  end;
  with Asender.Thread.Connection do
  begin
    s:= TSearchType(ReadSmallInt);
    ReadBuffer(VisualWindow.X1,sizeof(double));
    ReadBuffer(VisualWindow.Y1,sizeof(double));
    ReadBuffer(VisualWindow.X2,sizeof(double));
    ReadBuffer(VisualWindow.Y2,sizeof(double));
  end;
  Layer.SetGraphicFilter(s, VisualWindow);
end;

procedure TfrmMain.IdTCPServerchLAY_CANCELFILTERCommand(ASender: TIdCommand);
var
  Layer:TEzBaseLayer;
begin
  Layer:= GetLayer(ASender);
  If Layer = Nil then
  begin
    Asender.Thread.Connection.Disconnect;
    Exit;
  end;
  Layer.CancelFilter;
end;

procedure TfrmMain.IdTCPServerchLAY_EOFCommand(ASender: TIdCommand);
var
  Layer:TEzBaseLayer;
begin
  Layer:= GetLayer(ASender);
  If Layer = Nil then
  begin
    Asender.Thread.Connection.Disconnect;
    Exit;
  end;
  Asender.Thread.Connection.WriteSmallInt(Ord(Layer.Eof));
end;

procedure TfrmMain.IdTCPServerchLAY_FIRSTCommand(ASender: TIdCommand);
var
  Layer:TEzBaseLayer;
begin
  Layer:= GetLayer(ASender);
  If Layer = Nil then
  begin
    Asender.Thread.Connection.Disconnect;
    Exit;
  end;
  Layer.First;
end;

procedure TfrmMain.IdTCPServerchLAY_NEXTCommand(ASender: TIdCommand);
var
  Layer:TEzBaseLayer;
begin
  Layer:= GetLayer(ASender);
  If Layer = Nil then
  begin
    Asender.Thread.Connection.Disconnect;
    Exit;
  end;
  Layer.Next;
end;

procedure TfrmMain.IdTCPServerchLAY_LASTCommand(ASender: TIdCommand);
var
  Layer:TEzBaseLayer;
begin
  Layer:= GetLayer(ASender);
  If Layer = Nil then
  begin
    Asender.Thread.Connection.Disconnect;
    Exit;
  end;
  Layer.Last;
end;

procedure TfrmMain.IdTCPServerchLAY_STARTBUFFERINGCommand(
  ASender: TIdCommand);
var
  Layer:TEzBaseLayer;
begin
  Layer:= GetLayer(ASender);
  If Layer = Nil then
  begin
    Asender.Thread.Connection.Disconnect;
    Exit;
  end;
  Layer.StartBuffering;
end;

procedure TfrmMain.IdTCPServerchLAY_ENDBUFFERINGCommand(
  ASender: TIdCommand);
var
  Layer:TEzBaseLayer;
begin
  Layer:= GetLayer(ASender);
  If Layer = Nil then
  begin
    Asender.Thread.Connection.Disconnect;
    Exit;
  end;
  Layer.EndBuffering;
end;

procedure TfrmMain.IdTCPServerchLAY_ASSIGNCommand(ASender: TIdCommand);
var
  Layer, Source:TEzBaseLayer;
  AData: TGISData;
begin
  Layer:= GetLayer(ASender);
  If Layer = Nil then
  begin
    Asender.Thread.Connection.Disconnect;
    Exit;
  end;
  AData:=FindModule(ASender.Thread.Connection);
  Source:= AData.GIS1.Layers.LayerByName(ASender.Thread.Connection.ReadLn);
  Layer.Assign( Source );
end;

procedure TfrmMain.IdTCPServerchLAY_GETEXTENSIONFORRECORDSCommand(
  ASender: TIdCommand);
var
  Layer:TEzBaseLayer;
  Box: TEzRect;
  I,n: Integer;
  List: TIntegerList;
begin
  Layer:= GetLayer(ASender);
  If Layer = Nil then
  begin
    Asender.Thread.Connection.Disconnect;
    Exit;
  end;
  List:= TIntegerList.create;
  try
    with Asender.Thread.Connection do
    begin
      n:= ReadInteger;
      for I:= 1 to n do
        List.Add( ReadInteger );

      Box:= Layer.GetExtensionForRecords(List);
      WriteBuffer(Box.X1,sizeof(double));
      WriteBuffer(Box.Y1,sizeof(double));
      WriteBuffer(Box.X2,sizeof(double));
      WriteBuffer(Box.Y2,sizeof(double));
    end;
  finally
    List.free;
  end;
end;

procedure TfrmMain.IdTCPServerchLAY_REBUILDTREECommand(
  ASender: TIdCommand);
var
  Layer:TEzBaseLayer;
begin
  Layer:= GetLayer(ASender);
  If Layer = Nil then
  begin
    Asender.Thread.Connection.Disconnect;
    Exit;
  end;
  Layer.RebuildTree;
end;

procedure TfrmMain.IdTCPServerchLAY_OPENCommand(ASender: TIdCommand);
var
  Layer:TEzBaseLayer;
begin
  Layer:= GetLayer(ASender);
  If Layer = Nil then
  begin
    Asender.Thread.Connection.Disconnect;
    Exit;
  end;
  Layer.Open;
end;

procedure TfrmMain.IdTCPServerchLAY_CLOSECommand(ASender: TIdCommand);
var
  Layer:TEzBaseLayer;
begin
  Layer:= GetLayer(ASender);
  If Layer = Nil then
  begin
    Asender.Thread.Connection.Disconnect;
    Exit;
  end;
  Layer.Close;
end;

procedure TfrmMain.IdTCPServerchLAY_FORCEOPENEDCommand(
  ASender: TIdCommand);
var
  Layer:TEzBaseLayer;
begin
  Layer:= GetLayer(ASender);
  If Layer = Nil then
  begin
    Asender.Thread.Connection.Disconnect;
    Exit;
  end;
  Layer.ForceOpened;
end;

procedure TfrmMain.IdTCPServerchLAY_WRITEHEADERSCommand(
  ASender: TIdCommand);
var
  Layer:TEzBaseLayer;
  FLushFiles:boolean;
begin
  Layer:= GetLayer(ASender);
  If Layer = Nil then
  begin
    Asender.Thread.Connection.Disconnect;
    Exit;
  end;
  FlushFiles:=Asender.Thread.Connection.ReadSmallInt<>0;
  Layer.WriteHeaders(FlushFIles);
end;

procedure TfrmMain.IdTCPServerchLAY_ADDENTITYCommand(ASender: TIdCommand);
var
  Layer:TEzBaseLayer;
  ID: TEzEntityID;
  Entity: TEzEntity;
  Value: Integer;
  TmpClass: TEzEntityClass;
  Stream: TStream;
begin
  Layer:= GetLayer(ASender);
  If Layer = Nil then
  begin
    Asender.Thread.Connection.Disconnect;
    Exit;
  end;
  ID:= TEzEntityID( ASender.Thread.Connection.ReadSmallInt );
  TmpClass := GetClassFromID( ID );
  Entity:= TmpClass.Create( 1 );
  Stream:= TMemoryStream.create;
  try
    ASender.Thread.Connection.ReadStream(Stream,-1,False);
{$IFDEF TRANSPORT_COMPRESSED}
    Stream.Position:= 0;
    DeCompressMemStream(TMemoryStream(Stream));
{$ENDIF}
    Stream.Position:= 0;
    Entity.LoadFromStream( Stream );
    Value:= Layer.AddEntity(Entity);
    ASender.Thread.Connection.WriteInteger(Value);
  finally
    Stream.Free;
    Entity.Free;
  end;
end;

procedure TfrmMain.IdTCPServerchLAY_UNDELETEENTITYCommand(
  ASender: TIdCommand);
var
  Layer:TEzBaseLayer;
begin
  Layer:= GetLayer(ASender);
  If Layer = Nil then
  begin
    Asender.Thread.Connection.Disconnect;
    Exit;
  end;
  Layer.UndeleteEntity(Asender.Thread.Connection.ReadInteger);
end;

procedure TfrmMain.IdTCPServerchLAY_DELETEENTITYCommand(
  ASender: TIdCommand);
var
  Layer:TEzBaseLayer;
begin
  Layer:= GetLayer(ASender);
  If Layer = Nil then
  begin
    Asender.Thread.Connection.Disconnect;
    Exit;
  end;
  Layer.DeleteEntity(Asender.Thread.Connection.ReadInteger);
end;

procedure TfrmMain.IdTCPServerchLAY_QUICKUPDATEEXTENSIONCommand(
  ASender: TIdCommand);
var
  Layer:TEzBaseLayer;
  Box: TEzRect;
begin
  Layer:= GetLayer(ASender);
  If Layer = Nil then
  begin
    Asender.Thread.Connection.Disconnect;
    Exit;
  end;
  Box:= Layer.QuickUpdateExtension;
  with Asender.Thread.Connection do
  begin
    WriteBuffer(Box.x1,sizeof(double));
    WriteBuffer(Box.y1,sizeof(double));
    WriteBuffer(Box.x2,sizeof(double));
    WriteBuffer(Box.y2,sizeof(double));
  end;
end;

procedure TfrmMain.IdTCPServerchLAY_UPDATEEXTENSIONCommand(
  ASender: TIdCommand);
var
  Layer:TEzBaseLayer;
  Box: TEzRect;
begin
  Layer:= GetLayer(ASender);
  If Layer = Nil then
  begin
    Asender.Thread.Connection.Disconnect;
    Exit;
  end;
  Box:= Layer.UpdateExtension;
  with Asender.Thread.Connection do
  begin
    WriteBuffer(Box.x1,sizeof(double));
    WriteBuffer(Box.y1,sizeof(double));
    WriteBuffer(Box.x2,sizeof(double));
    WriteBuffer(Box.y2,sizeof(double));
  end;
end;

procedure TfrmMain.IdTCPServerchLAY_LOADENTITYWITHRECNOCommand(
  ASender: TIdCommand);
var
  Layer:TEzBaseLayer;
  Entity: TEzEntity;
  stream: TStream;
begin
  Layer:= GetLayer(ASender);
  If Layer = Nil then
  begin
    Asender.Thread.Connection.Disconnect;
    Exit;
  end;
  Entity:= Layer.LoadEntityWithRecno(Asender.Thread.Connection.ReadInteger);
  If Entity= Nil then
  begin
    Asender.Thread.Connection.Disconnect;
    Exit;
  end;
  stream:= TMemoryStream.create;
  try
    with Asender.Thread.Connection do
    begin
      WriteSmallInt(Ord(Entity.EntityID));
      Entity.SaveToStream( Stream );
      Stream.Position:= 0;
{$IFDEF TRANSPORT_COMPRESSED}
      CompressmemStream(TMemoryStream(Stream), 1);
      Stream.Position:= 0;
{$ENDIF}
      OpenWriteBuffer;
      WriteStream(Stream,true,true);
      CloseWriteBuffer;
    end;
  Finally
    Entity.Free;
    stream.free;
  End;
end;

procedure TfrmMain.IdTCPServerchLAY_UPDATEENTITYCommand(ASender: TIdCommand);
var
  Layer:TEzBaseLayer;
  ID: TEzEntityID;
  Entity: TEzEntity;
  TmpClass: TEzEntityClass;
  Recno:integer;
  Stream: TStream;
begin
  Layer:= GetLayer(ASender);
  If Layer = Nil then
  begin
    Asender.Thread.Connection.Disconnect;
    Exit;
  end;
  with Asender.Thread.Connection do
  begin
    Recno:= ReadInteger;
    ID:= TEzEntityID( ReadSmallInt );
    TmpClass := GetClassFromID( ID );
    Entity:= TmpClass.Create( 1 );
    Stream:= TMemoryStream.create;
    try
      ReadStream(Stream,-1,False);
{$IFDEF TRANSPORT_COMPRESSED}
      Stream.Position:= 0;
      DeCompressMemStream(TMemoryStream(Stream));
{$ENDIF}
      Stream.Position:= 0;
      Entity.LoadFromStream( Stream );
      Layer.UpdateEntity(Recno,Entity);
    finally
      Stream.Free;
    end;
  end;
end;

procedure TfrmMain.IdTCPServerchLAY_PACKCommand(ASender: TIdCommand);
var
  Layer:TEzBaseLayer;
  ShowMessage:boolean;
begin
  Layer:= GetLayer(ASender);
  If Layer = Nil then
  begin
    Asender.Thread.Connection.Disconnect;
    Exit;
  end;
  ShowMessage:=Asender.Thread.Connection.ReadSmallInt<>0;
  Layer.Pack(False);
end;

procedure TfrmMain.IdTCPServerchLAY_RECEXTENSIONCommand(
  ASender: TIdCommand);
var
  Layer:TEzBaseLayer;
  Box: TEzRect;
begin
  Layer:= GetLayer(ASender);
  If Layer = Nil then
  begin
    Asender.Thread.Connection.Disconnect;
    Exit;
  end;
  with Asender.Thread.Connection do
  begin
    Box:= Layer.RecExtension;
    WriteBuffer(Box.x1,sizeof(double));
    WriteBuffer(Box.y1,sizeof(double));
    WriteBuffer(Box.x2,sizeof(double));
    WriteBuffer(Box.y2,sizeof(double));
  end;
end;

procedure TfrmMain.IdTCPServerchLAY_RECLOADENTITYCommand(
  ASender: TIdCommand);
var
  Layer:TEzBaseLayer;
  Entity: TEzEntity;
  stream: TStream;
begin
  Layer:= GetLayer(ASender);
  If Layer = Nil then
  begin
    Asender.Thread.Connection.Disconnect;
    Exit;
  end;
  Entity:= Layer.RecLoadEntity;
  stream:= TMemoryStream.create;
  try
    with Asender.Thread.Connection do
    begin
      WriteSmallInt(Ord(Entity.EntityID));
      Entity.SaveToStream( Stream );
      Stream.Position:= 0;
{$IFDEF TRANSPORT_COMPRESSED}
      CompressmemStream(TMemoryStream(Stream), 1);
      Stream.Position:= 0;
{$ENDIF}
      OpenWriteBuffer;
      WriteStream(Stream,true,true);
      CloseWriteBuffer;
    end;
  Finally
    Entity.Free;
    stream.free;
  End;
end;

procedure TfrmMain.IdTCPServerchLAY_RECLOADENTITY2Command(
  ASender: TIdCommand);
var
  Layer:TEzBaseLayer;
  ID: TEzEntityID;
  TmpClass: TEzEntityClass;
  Entity: TEzEntity;
  stream: TStream;
begin
  Layer:= GetLayer(ASender);
  If Layer = Nil then
  begin
    Asender.Thread.Connection.Disconnect;
    Exit;
  end;
  ID:= TEzEntityID(Asender.Thread.Connection.ReadSmallInt);
  TmpClass := GetClassFromID( ID );
  Entity:= TmpClass.Create( 1 );
  stream:= TMemoryStream.create;
  try
    Layer.RecLoadEntity2(Entity);
    with Asender.Thread.Connection do
    begin
      Entity.SaveToStream( Stream );
      Stream.Position:= 0;
{$IFDEF TRANSPORT_COMPRESSED}
      CompressmemStream(TMemoryStream(Stream), 1);
      Stream.Position:= 0;
{$ENDIF}
      OpenWriteBuffer;
      WriteStream(Stream,true,true);
      CloseWriteBuffer;
    end;
  Finally
    Entity.Free;
    stream.free;
  End;
end;

procedure TfrmMain.IdTCPServerchLAY_RECENTITYIDCommand(
  ASender: TIdCommand);
var
  Layer:TEzBaseLayer;
begin
  Layer:= GetLayer(ASender);
  If Layer = Nil then
  begin
    Asender.Thread.Connection.Disconnect;
    Exit;
  end;
  Asender.Thread.Connection.WriteSmallInt(Ord(Layer.RecEntityID));
end;

procedure TfrmMain.IdTCPServerchLAY_RECISDELETEDCommand(
  ASender: TIdCommand);
var
  Layer:TEzBaseLayer;
begin
  Layer:= GetLayer(ASender);
  If Layer = Nil then
  begin
    Asender.Thread.Connection.Disconnect;
    Exit;
  end;
  Asender.Thread.Connection.WriteSmallInt(Ord(Layer.RecIsDeleted));
end;

procedure TfrmMain.IdTCPServerchLAY_COPYRECORDCommand(ASender: TIdCommand);
var
  Layer:TEzBaseLayer;
  SourceRecno,DestRecno:integer;
begin
  Layer:= GetLayer(ASender);
  If Layer = Nil then
  begin
    Asender.Thread.Connection.Disconnect;
    Exit;
  end;
  SourceRecno:= Asender.Thread.Connection.ReadInteger;
  DestRecno:= Asender.Thread.Connection.ReadInteger;
  Layer.CopyRecord(SourceRecno,DestRecno);
end;

procedure TfrmMain.IdTCPServerchLAY_CONTAINSDELETEDCommand(
  ASender: TIdCommand);
var
  Layer:TEzBaseLayer;
begin
  Layer:= GetLayer(ASender);
  If Layer = Nil then
  begin
    Asender.Thread.Connection.Disconnect;
    Exit;
  end;
  Asender.Thread.Connection.WriteSmallInt(Ord(Layer.ContainsDeleted));
end;

procedure TfrmMain.IdTCPServerchLAY_RECALLCommand(ASender: TIdCommand);
var
  Layer:TEzBaseLayer;
begin
  Layer:= GetLayer(ASender);
  If Layer = Nil then
  begin
    Asender.Thread.Connection.Disconnect;
    Exit;
  end;
  Layer.Recall;
end;

procedure TfrmMain.IdTCPServerchLAY_GETRECORDCOUNTCommand(
  ASender: TIdCommand);
var
  Layer:TEzBaseLayer;
begin
  Layer:= GetLayer(ASender);
  If Layer = Nil then
  begin
    Asender.Thread.Connection.Disconnect;
    Exit;
  end;
  Asender.Thread.Connection.WriteInteger(Layer.RecordCount);
end;

procedure TfrmMain.IdTCPServerchLAY_BRINGTOFRONTCommand(
  ASender: TIdCommand);
var
  Layer:TEzBaseLayer;
  Value: integer;
begin
  Layer:= GetLayer(ASender);
  If Layer = Nil then
  begin
    Asender.Thread.Connection.Disconnect;
    Exit;
  end;
  value:= Layer.BringEntityToFront(Asender.Thread.Connection.ReadInteger);
  Asender.Thread.Connection.WriteInteger(value);
end;

procedure TfrmMain.IdTCPServerchLAY_SENDTOBACKCommand(ASender: TIdCommand);
var
  Layer:TEzBaseLayer;
  value:integer;
begin
  Layer:= GetLayer(ASender);
  If Layer = Nil then
  begin
    Asender.Thread.Connection.Disconnect;
    Exit;
  end;
  value:=Layer.SendEntityToBack(Asender.Thread.Connection.ReadInteger);
  Asender.Thread.Connection.WriteInteger(value);
end;

procedure TfrmMain.IdTCPServerchLAY_DELETELAYERFILESCommand(
  ASender: TIdCommand);
var
  Layer:TEzBaseLayer;
begin
  Layer:= GetLayer(ASender);
  If Layer = Nil then
  begin
    Asender.Thread.Connection.Disconnect;
    Exit;
  end;
  Asender.Thread.Connection.WriteSmallInt(Ord(Layer.DeleteLayerFiles));
end;

procedure TfrmMain.IdTCPServerchLAY_GETACTIVECommand(ASender: TIdCommand);
var
  Layer:TEzBaseLayer;
begin
  Layer:= GetLayer(ASender);
  If Layer = Nil then
  begin
    Asender.Thread.Connection.Disconnect;
    Exit;
  end;
  Asender.Thread.Connection.WriteSmallInt(Ord(Layer.Active));
end;

procedure TfrmMain.IdTCPServerchLAY_SETACTIVECommand(ASender: TIdCommand);
var
  Layer:TEzBaseLayer;
begin
  Layer:= GetLayer(ASender);
  If Layer = Nil then
  begin
    Asender.Thread.Connection.Disconnect;
    Exit;
  end;
  Layer.Active:= Asender.Thread.Connection.ReadSmallInt<>0;
end;

procedure TfrmMain.IdTCPServerchLAY_SYNCHRONIZECommand(
  ASender: TIdCommand);
var
  Layer:TEzBaseLayer;
begin
  Layer:= GetLayer(ASender);
  If Layer = Nil then
  begin
    Asender.Thread.Connection.Disconnect;
    Exit;
  end;
  Layer.Synchronize;
end;

procedure TfrmMain.IdTCPServerchMI_INITIALIZECommand(ASender: TIdCommand);
var
  GIS: TEzBaseGIS;
begin
  GIS:= GetGIS(ASender);
  If GIS = Nil then
  begin
    Asender.Thread.Connection.Disconnect;
    Exit;
  end;
  GIS.MapInfo.Initialize;
end;

procedure TfrmMain.IdTCPServerchMI_ISVALIDCommand(ASender: TIdCommand);
var
  GIS: TEzBaseGIS;
begin
  GIS:= GetGIS(ASender);
  If GIS = Nil then
  begin
    Asender.Thread.Connection.Disconnect;
    Exit;
  end;
  Asender.Thread.Connection.WriteSmallInt(ord(GIS.MapInfo.IsValid));
end;

procedure TfrmMain.IdTCPServerchMI_GETNUMLAYERSCommand(
  ASender: TIdCommand);
var
  GIS: TEzBaseGIS;
begin
  GIS:= GetGIS(ASender);
  If GIS = Nil then
  begin
    Asender.Thread.Connection.Disconnect;
    Exit;
  end;
  Asender.Thread.Connection.WriteInteger(GIS.MapInfo.NumLayers);
end;

procedure TfrmMain.IdTCPServerchMI_SETNUMLAYERSCommand(
  ASender: TIdCommand);
var
  GIS: TEzBaseGIS;
begin
  GIS:= GetGIS(ASender);
  If GIS = Nil then
  begin
    Asender.Thread.Connection.Disconnect;
    Exit;
  end;
  GIS.MapInfo.NumLayers:=Asender.Thread.Connection.ReadInteger;
end;

procedure TfrmMain.IdTCPServerchMI_GETEXTENSIONCommand(
  ASender: TIdCommand);
var
  GIS: TEzBaseGIS;
  box: TEzRect;
begin
  GIS:= GetGIS(ASender);
  If GIS = Nil then
  begin
    Asender.Thread.Connection.Disconnect;
    Exit;
  end;
  with Asender.Thread.Connection do
  begin
    box:= Gis.MapInfo.Extension;
    WriteBuffer(box.x1,sizeof(double));
    WriteBuffer(box.y1,sizeof(double));
    WriteBuffer(box.x2,sizeof(double));
    WriteBuffer(box.y2,sizeof(double));
  end;
end;

procedure TfrmMain.IdTCPServerchMI_SETEXTENSIONCommand(
  ASender: TIdCommand);
var
  GIS: TEzBaseGIS;
  box: TEzRect;
begin
  GIS:= GetGIS(ASender);
  If GIS = Nil then
  begin
    Asender.Thread.Connection.Disconnect;
    Exit;
  end;
  with Asender.Thread.Connection do
  begin
    ReadBuffer(box.x1,sizeof(double));
    ReadBuffer(box.y1,sizeof(double));
    ReadBuffer(box.x2,sizeof(double));
    ReadBuffer(box.y2,sizeof(double));
  end;
  GIS.MapInfo.Extension:=box;
end;

procedure TfrmMain.IdTCPServerchMI_GETCURRENTLAYERCommand(
  ASender: TIdCommand);
var
  GIS: TEzBaseGIS;
begin
  GIS:= GetGIS(ASender);
  If GIS = Nil then
  begin
    Asender.Thread.Connection.Disconnect;
    Exit;
  end;
  Asender.Thread.Connection.WriteLn(GIS.MapInfo.CurrentLayer);
end;

procedure TfrmMain.IdTCPServerchMI_SETCURRENTLAYERCommand(
  ASender: TIdCommand);
var
  GIS: TEzBaseGIS;
begin
  GIS:= GetGIS(ASender);
  If GIS = Nil then
  begin
    Asender.Thread.Connection.Disconnect;
    Exit;
  end;
  GIS.MapInfo.CurrentLayer:= Asender.Thread.Connection.ReadLn;
end;

procedure TfrmMain.IdTCPServerchMI_GETAERIALVIEWLAYERCommand(
  ASender: TIdCommand);
var
  GIS: TEzBaseGIS;
begin
  GIS:= GetGIS(ASender);
  If GIS = Nil then
  begin
    Asender.Thread.Connection.Disconnect;
    Exit;
  end;
  Asender.Thread.Connection.WriteLn(GIS.MapInfo.AerialviewLayer);
end;

procedure TfrmMain.IdTCPServerchMI_SETAERIALVIEWLAYERCommand(
  ASender: TIdCommand);
var
  GIS: TEzBaseGIS;
begin
  GIS:= GetGIS(ASender);
  If GIS = Nil then
  begin
    Asender.Thread.Connection.Disconnect;
    Exit;
  end;
  GIS.MapInfo.AerialviewLayer:= Asender.Thread.Connection.ReadLn;
end;

procedure TfrmMain.IdTCPServerchMI_GETLASTVIEWCommand(ASender: TIdCommand);
var
  GIS: TEzBaseGIS;
  box:TEzRect;
begin
  GIS:= GetGIS(ASender);
  If GIS = Nil then
  begin
    Asender.Thread.Connection.Disconnect;
    Exit;
  end;
  box:=GIS.MapInfo.LastView;
  with Asender.Thread.Connection do
  begin
    WriteBuffer(box.x1,sizeof(double));
    WriteBuffer(box.y1,sizeof(double));
    WriteBuffer(box.x2,sizeof(double));
    WriteBuffer(box.y2,sizeof(double));
  end;
end;

procedure TfrmMain.IdTCPServerchMI_SETLASTVIEWCommand(ASender: TIdCommand);
var
  GIS: TEzBaseGIS;
  box:TEzRect;
begin
  GIS:= GetGIS(ASender);
  If GIS = Nil then
  begin
    Asender.Thread.Connection.Disconnect;
    Exit;
  end;
  with Asender.Thread.Connection do
  begin
    ReadBuffer(box.x1,sizeof(double));
    ReadBuffer(box.y1,sizeof(double));
    ReadBuffer(box.x2,sizeof(double));
    ReadBuffer(box.y2,sizeof(double));
  end;
  GIS.MapInfo.LastView:=box;
end;

procedure TfrmMain.IdTCPServerchMI_GETCOORDSYSCommand(ASender: TIdCommand);
var
  GIS: TEzBaseGIS;
begin
  GIS:= GetGIS(ASender);
  If GIS = Nil then
  begin
    Asender.Thread.Connection.Disconnect;
    Exit;
  end;
  Asender.Thread.Connection.WriteSmallInt(Ord(GIS.MapInfo.CoordSystem));
end;

procedure TfrmMain.IdTCPServerchMI_SETCOORDSYSCommand(ASender: TIdCommand);
var
  GIS: TEzBaseGIS;
begin
  GIS:= GetGIS(ASender);
  If GIS = Nil then
  begin
    Asender.Thread.Connection.Disconnect;
    Exit;
  end;
  GIS.MapInfo.CoordSystem:= TEzCoordSystem(Asender.Thread.Connection.ReadSmallInt);
end;

procedure TfrmMain.IdTCPServerchMI_SETCOORDSUNITSCommand(ASender: TIdCommand);
var
  GIS: TEzBaseGIS;
begin
  GIS:= GetGIS(ASender);
  If GIS = Nil then
  begin
    Asender.Thread.Connection.Disconnect;
    Exit;
  end;
  GIS.MapInfo.CoordsUnits:= TEzCoordsUnits(Asender.Thread.Connection.ReadSmallInt);
end;

procedure TfrmMain.IdTCPServerchMI_GETCOORDSUNITSCommand(ASender: TIdCommand);
var
  GIS: TEzBaseGIS;
begin
  GIS:= GetGIS(ASender);
  If GIS = Nil then
  begin
    Asender.Thread.Connection.Disconnect;
    Exit;
  end;
  Asender.Thread.Connection.WriteSmallInt(ord(GIS.MapInfo.CoordsUnits));
end;

procedure TfrmMain.IdTCPServerchMI_GETISAREACLIPPEDCommand(ASender: TIdCommand);
var
  GIS: TEzBaseGIS;
begin
  GIS:= GetGIS(ASender);
  If GIS = Nil then
  begin
    Asender.Thread.Connection.Disconnect;
    Exit;
  end;
  Asender.Thread.Connection.WriteSmallInt(ord(GIS.MapInfo.IsAreaClipped));
end;

procedure TfrmMain.IdTCPServerchMI_SETISAREACLIPPEDCommand(ASender: TIdCommand);
var
  GIS: TEzBaseGIS;
begin
  GIS:= GetGIS(ASender);
  If GIS = Nil then
  begin
    Asender.Thread.Connection.Disconnect;
    Exit;
  end;
  GIS.MapInfo.IsAreaClipped:= Asender.Thread.Connection.ReadSmallInt<>0;
end;

procedure TfrmMain.IdTCPServerchMI_GETAREACLIPPEDCommand(ASender: TIdCommand);
var
  GIS: TEzBaseGIS;
  box:TEzRect;
begin
  GIS:= GetGIS(ASender);
  If GIS = Nil then
  begin
    Asender.Thread.Connection.Disconnect;
    Exit;
  end;
  box:= GIS.MapInfo.AreaClipped;
  with Asender.Thread.Connection do
  begin
    WriteBuffer(box.x1,sizeof(double));
    WriteBuffer(box.y1,sizeof(double));
    WriteBuffer(box.x2,sizeof(double));
    WriteBuffer(box.y2,sizeof(double));
  end;
end;

procedure TfrmMain.IdTCPServerchMI_SETAREACLIPPEDCommand(ASender: TIdCommand);
var
  GIS: TEzBaseGIS;
  box:TEzRect;
begin
  GIS:= GetGIS(ASender);
  If GIS = Nil then
  begin
    Asender.Thread.Connection.Disconnect;
    Exit;
  end;
  with Asender.Thread.Connection do
  begin
    ReadBuffer(box.x1,sizeof(double));
    ReadBuffer(box.y1,sizeof(double));
    ReadBuffer(box.x2,sizeof(double));
    ReadBuffer(box.y2,sizeof(double));
  end;
  GIS.MapInfo.AreaClipped:=box;
end;

procedure TfrmMain.IdTCPServerchMI_GETCLIPAREAKINDCommand(ASender: TIdCommand);
var
  GIS: TEzBaseGIS;
begin
  GIS:= GetGIS(ASender);
  If GIS = Nil then
  begin
    Asender.Thread.Connection.Disconnect;
    Exit;
  end;
  Asender.Thread.Connection.WriteSmallInt(ord(GIS.MapInfo.ClipAreaKind));
end;

procedure TfrmMain.IdTCPServerchMI_SETCLIPAREAKINDCommand(ASender: TIdCommand);
var
  GIS: TEzBaseGIS;
begin
  GIS:= GetGIS(ASender);
  If GIS = Nil then
  begin
    Asender.Thread.Connection.Disconnect;
    Exit;
  end;
  GIS.MapInfo.ClipAreaKind:= TEzClipAreaKind(Asender.Thread.Connection.ReadSmallInt);
end;

procedure TfrmMain.IdTCPServerchGIS_ADDGEOREFCommand(ASender: TIdCommand);
var
  GIS: TEzBaseGIS;
  FileName,LayerName:string;
begin
  GIS:= GetGIS(ASender);
  If GIS = Nil then
  begin
    Asender.Thread.Connection.Disconnect;
    Exit;
  end;
  LayerName:=Asender.Thread.Connection.ReadLn;
  FileName:=Asender.Thread.Connection.ReadLn;
  GIS.AddGeoRef(LayerName,Filename);
end;

procedure TfrmMain.IdTCPServerchGIS_CLOSECommand(ASender: TIdCommand);
var
  GIS: TEzBaseGIS;
begin
  GIS:= GetGIS(ASender);
  If GIS = Nil then
  begin
    Asender.Thread.Connection.Disconnect;
    Exit;
  end;
  GIS.Close;
end;

procedure TfrmMain.IdTCPServerchGIS_CREATENEWCommand(ASender: TIdCommand);
var
  GIS: TEzBaseGIS;
begin
  GIS:= GetGIS(ASender);
  If GIS = Nil then
  begin
    Asender.Thread.Connection.Disconnect;
    Exit;
  end;
  GIS.CreateNew(Asender.Thread.Connection.ReadLn);
end;

procedure TfrmMain.IdTCPServerchGIS_ISCLIENTSERVERCommand( ASender: TIdCommand);
var
  GIS: TEzBaseGIS;
begin
  GIS:= GetGIS(ASender);
  If GIS = Nil then
  begin
    Asender.Thread.Connection.Disconnect;
    Exit;
  end;
  Asender.Thread.Connection.WriteSmallInt(Ord(GIS.IsClientServer));
end;

procedure TfrmMain.IdTCPServerchGIS_SAVEASCommand(ASender: TIdCommand);
var
  GIS: TEzBaseGIS;
begin
  GIS:= GetGIS(ASender);
  If GIS = Nil then
  begin
    Asender.Thread.Connection.Disconnect;
    Exit;
  end;
  GIS.Save;
end;

procedure TfrmMain.IdTCPServerchLAY_GETBOOKMARKCommand( ASender: TIdCommand);
var
  Layer:TEzBaseLayer;
begin
  Layer:= GetLayer(ASender);
  If Layer = Nil then
  begin
    Asender.Thread.Connection.Disconnect;
    Exit;
  end;
  Asender.Thread.Connection.WriteInteger(Integer(Layer.GetBookmark));
end;

procedure TfrmMain.IdTCPServerchLAY_GOTOBOOKMARKCommand(ASender: TIdCommand);
var
  Layer:TEzBaseLayer;
begin
  Layer:= GetLayer(ASender);
  If Layer = Nil then
  begin
    Asender.Thread.Connection.Disconnect;
    Exit;
  end;
  Layer.GotoBookmark(Pointer(Asender.Thread.Connection.ReadInteger));
end;

procedure TfrmMain.IdTCPServerchLAY_FREEBOOKMARKCommand(ASender: TIdCommand);
var
  Layer:TEzBaseLayer;
begin
  Layer:= GetLayer(ASender);
  If Layer = Nil then
  begin
    Asender.Thread.Connection.Disconnect;
    Exit;
  end;
  Layer.FreeBookmark(Pointer(Asender.Thread.Connection.ReadInteger));
end;

procedure TfrmMain.IdTCPServerchDBT_APPENDCommand(ASender: TIdCommand);
var
  Layer:TEzBaseLayer;
begin
  Layer:= GetLayer(ASender);
  If Layer = Nil then
  begin
    Asender.Thread.Connection.Disconnect;
    Exit;
  end;
  Layer.DBTable.Append(Asender.Thread.Connection.ReadInteger);
end;

procedure TfrmMain.IdTCPServerchGIS_GETPROJPARAMSCommand(ASender: TIdCommand);
var
  GIS: TEzBaseGIS;
begin
  GIS:= GetGIS(ASender);
  If GIS = Nil then
  begin
    Asender.Thread.Connection.Disconnect;
    Exit;
  end;
  Asender.Thread.Connection.WriteStrings(GIS.ProjectionParams,true);
end;

procedure TfrmMain.IdTCPServerchGIS_GETHGUIDELINESCommand(ASender: TIdCommand);
var
  GIS: TEzBaseGIS;
  I: integer;
  value:double;
begin
  GIS:= GetGIS(ASender);
  If GIS = Nil then
  begin
    Asender.Thread.Connection.Disconnect;
    Exit;
  end;
  with Asender.Thread.Connection do
  begin
    WriteInteger(GIS.HGuidelines.Count);
    for I:= 0 to GIS.HGuidelines.Count-1 do
    begin
      value:=GIS.HGuidelines[I];
      WriteBuffer(value,sizeof(double));
    end;
  end;
end;

procedure TfrmMain.IdTCPServerchGIS_GETVGUIDELINESCommand(ASender: TIdCommand);
var
  GIS: TEzBaseGIS;
  I: integer;
  value:double;
begin
  GIS:= GetGIS(ASender);
  If GIS = Nil then
  begin
    Asender.Thread.Connection.Disconnect;
    Exit;
  end;
  with Asender.Thread.Connection do
  begin
    WriteInteger(GIS.VGuidelines.Count);
    for I:= 0 to GIS.VGuidelines.Count-1 do
    begin
      value:=GIS.VGuidelines[I];
      WriteBuffer(value,sizeof(double));
    end;
  end;
end;

procedure TfrmMain.IdTCPServerchGIS_GETPOLYCLIPAREACommand(ASender: TIdCommand);
var
  GIS: TEzBaseGIS;
  Stream: TStream;
begin
  GIS:= GetGIS(ASender);
  If GIS = Nil then
  begin
    Asender.Thread.Connection.Disconnect;
    Exit;
  end;
  Stream:= TMemoryStream.create;
  try
    GIS.ClipPolygonalArea.SaveToStream(stream);
    Stream.Position:= 0;
{$IFDEF TRANSPORT_COMPRESSED}
    CompressmemStream(TMemoryStream(Stream), 1);
    Stream.Position:= 0;
{$ENDIF}
    Asender.Thread.Connection.WriteStream(stream,true,true);
  finally
    stream.free;
  end;
end;

procedure TfrmMain.IdTCPServerchGIS_GETLAYERLISTCommand(ASender: TIdCommand);
var
  GIS: TEzBaseGIS;
  Strings: TStrings;
  I:Integer;
begin
  GIS:= GetGIS(ASender);
  If GIS = Nil then
  begin
    Asender.Thread.Connection.Disconnect;
    Exit;
  end;
  Strings:= TStringList.create;
  try
    for I:= 0 to GIS.Layers.Count-1 do
      Strings.Add(GIS.Layers[I].Name);
    Asender.Thread.Connection.WriteStrings(Strings,true);
  finally
    Strings.free;
  end;
end;

procedure TfrmMain.IdTCPServerchLAY_GETNEXTBUFFERCommand(ASender: TIdCommand);
var
  Layer:TEzBaseLayer;
  TransportBufferSize: Integer;
  I: Integer;
  Entity: TEzEntity;
  Stream: TStream;
  value:integer;
  valuesi: smallint;
begin
  Layer:= GetLayer(ASender);
  If Layer = Nil then
  begin
    Asender.Thread.Connection.Disconnect;
    Exit;
  end;
  with Asender.Thread.Connection do
  begin
    TransportBufferSize:= ReadInteger;
    Stream:= TMemoryStream.Create;
    Try
      I:= 0;
      While (Not Layer.Eof) And (I < TransportBufferSize) do
      begin
        If Layer.RecIsDeleted Then
        begin
          Layer.Next;
          Continue;
        end;
        Entity:= Layer.RecLoadEntity;
        If Entity=Nil then Continue;
        Try
          value:=Layer.Recno;
          Stream.Write(value,sizeof(Integer));
          valuesi:= Ord(Entity.EntityID);
          Stream.Write(valuesi,sizeof(SmallInt));
          Entity.SaveToStream(Stream);
        Finally
          Entity.Free;
        end;
        Inc(I);
        Layer.Next;
      end;
      Stream.Position:= 0;
{$IFDEF TRANSPORT_COMPRESSED}
      CompressmemStream(TMemoryStream(Stream), 1);
      Stream.Position:= 0;
{$ENDIF}
      OpenWriteBuffer;
      WriteStream(Stream,true,true);
      CloseWriteBuffer;
    Finally
      Stream.Free;
    End;
  end;
end;

procedure TfrmMain.IdTCPServerchDBT_DBCREATETABLECommand(ASender: TIdCommand);
var
  Layer: TEzBaseLayer;
  fname: string;
  TempStrings: TStrings;
begin
  Layer:= GetLayer(ASender);
  If Layer = Nil then
  begin
    Asender.Thread.Connection.Disconnect;
    Exit;
  end;
  fname:= Asender.Thread.Connection.ReadLn;
  TempStrings:= TStringList.Create;
  try
    Asender.Thread.Connection.ReadStrings(TempStrings);
    Layer.DBTable.DBCreateTable(fname,TStringList(TempStrings));
  finally
    TempStrings.Free;
  end;
end;

procedure TfrmMain.IdTCPServerchDBT_DBTABLEEXITSCommand(ASender: TIdCommand);
var
  Layer: TEzBaseLayer;
  TableName: string;
begin
  Layer:= GetLayer(ASender);
  If Layer = Nil then
  begin
    Asender.Thread.Connection.Disconnect;
    Exit;
  end;
  TableName:= Asender.Thread.Connection.ReadLn;
  Asender.Thread.Connection.WriteSmallInt(Ord(Layer.DBTable.DBTableExists(TableName)));
end;

procedure TfrmMain.IdTCPServerchDBT_DBDROPTABLECommand(ASender: TIdCommand);
var
  Layer: TEzBaseLayer;
  TableName:string;
begin
  Layer:= GetLayer(ASender);
  If Layer = Nil then
  begin
    Asender.Thread.Connection.Disconnect;
    Exit;
  end;
  TableName:=Asender.Thread.Connection.ReadLn;
  Asender.Thread.Connection.WriteSmallInt(Ord(Layer.DBTable.DBDropTable(TableName)));
end;

procedure TfrmMain.IdTCPServerchDBT_DBDROPINDEXCommand(
  ASender: TIdCommand);
var
  Layer: TEzBaseLayer;
  TableName:string;
begin
  Layer:= GetLayer(ASender);
  If Layer = Nil then
  begin
    Asender.Thread.Connection.Disconnect;
    Exit;
  end;
  TableName:=Asender.Thread.Connection.ReadLn;
  Asender.Thread.Connection.WriteSmallInt(Ord(Layer.DBTable.DBDropIndex(TableName)));
end;

procedure TfrmMain.IdTCPServerchDBT_DBRENAMETABLECommand(
  ASender: TIdCommand);
var
  Layer: TEzBaseLayer;
  Source,Target:string;
begin
  Layer:= GetLayer(ASender);
  If Layer = Nil then
  begin
    Asender.Thread.Connection.Disconnect;
    Exit;
  end;
  with Asender.Thread.Connection do
  begin
    Source:=ReadLn;
    Target:=ReadLn;
    WriteSmallInt(Ord(Layer.DBTable.DBRenameTable(Source,Target)));
  end;
end;

procedure TfrmMain.IdTCPServerchLI_GETCOORDSYSTEMCommand(ASender: TIdCommand);
var
  Layer:TEzBaseLayer;
begin
  Layer:= GetLayer(ASender);
  If Layer = Nil then
  begin
    Asender.Thread.Connection.Disconnect;
    Exit;
  end;
  Asender.Thread.Connection.WriteSmallInt(Ord(Layer.LayerInfo.CoordSystem));
end;

procedure TfrmMain.IdTCPServerchLI_SETCOORDSYSTEMCommand(
  ASender: TIdCommand);
var
  Layer:TEzBaseLayer;
begin
  Layer:= GetLayer(ASender);
  If Layer = Nil then
  begin
    Asender.Thread.Connection.Disconnect;
    Exit;
  end;
  Layer.LayerInfo.CoordSystem:= TEzCoordSystem(Asender.Thread.Connection.ReadSmallInt);
end;

procedure TfrmMain.IdTCPServerchGS_LOADSYMBOLSCommand(ASender: TIdCommand);
var
  Stream: TStream;
begin
  Stream:= TMemoryStream.create;
  Try
    Ez_Symbols.SaveToStream(Stream);
    Stream.Position:= 0;
{$IFDEF TRANSPORT_COMPRESSED}
    CompressmemStream(TMemoryStream(Stream), 1);
    Stream.Position:= 0;
{$ENDIF}
    with ASender.Thread.Connection do
    begin
      OpenWriteBuffer;
      WriteStream(Stream,true,true);
      CloseWriteBuffer;
    end;
  Finally
    Stream.free;
  End;
end;

procedure TfrmMain.IdTCPServerchGS_LOADLINETYPESCommand(ASender: TIdCommand);
var
  Stream: TStream;
begin
  Stream:= TMemoryStream.create;
  Try
    Ez_LineTypes.SaveToStream(Stream);
    Stream.Position:= 0;
{$IFDEF TRANSPORT_COMPRESSED}
    CompressmemStream(TMemoryStream(Stream), 1);
    Stream.Position:= 0;
{$ENDIF}
    with ASender.Thread.Connection do
    begin
      OpenWriteBuffer;
      WriteStream(Stream,true,true);
      CloseWriteBuffer;
    end;
  Finally
    Stream.free;
  End;
end;

procedure TfrmMain.IdTCPServerchGS_LOADVECTFONTSCommand( ASender: TIdCommand);
var
  Stream: TStream;
  I: Integer;
begin
  ASender.Thread.Connection.WriteInteger(Ez_VectorFonts.Count);
  Stream:= TMemoryStream.create;
  Try
    For I:= 0 to Ez_VectorFonts.Count-1 do
    begin
      Ez_VectorFonts.Items[I].SaveToStream(Stream);
    End;
    Stream.Position:= 0;
{$IFDEF TRANSPORT_COMPRESSED}
    CompressmemStream(TMemoryStream(Stream), 1);
    Stream.Position:= 0;
{$ENDIF}
    with ASender.Thread.Connection do
    begin
      OpenWriteBuffer;
      WriteStream(Stream,true,true);
      CloseWriteBuffer;
    end;
  Finally
    Stream.free;
  End;
end;

procedure TfrmMain.IdTCPServerchGLB_GETIMAGECommand(ASender: TIdCommand);
var
  Stream, ImageStream: TStream;
  FileName,AName: string;
begin
  { read image name }
  with ASender.Thread.Connection do
  begin
    AName:= ReadLn;
    Stream:= TMemoryStream.create;
    Try
      FileName:= AddSlash( Ez_Preferences.CommonSubdir ) + AName;
      If FileExists( Filename ) Then
      begin
        ImageStream:= TFileStream.Create(FileName, fmOpenRead or fmShareDenyNone);
        Try
          Stream.CopyFrom(ImageStream, ImageStream.Size);
          Stream.Position:= 0;
{$IFDEF TRANSPORT_COMPRESSED}
          CompressmemStream(TMemoryStream(Stream), 1);
          Stream.Position:= 0;
{$ENDIF}
          with ASender.Thread.Connection do
          begin
            OpenWriteBuffer;
            WriteStream(Stream,true,true);
            CloseWriteBuffer;
          end;
        finally
          ImageStream.Free;
        end;
      end else
      begin
        with ASender.Thread.Connection do
        begin
          OpenWriteBuffer;
          WriteStream(Stream,true,true);
          CloseWriteBuffer;
        end;
      end;
    Finally
      Stream.free;
    End;
  end;
end;

end.
