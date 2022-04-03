unit fClient;

{$I EZ_FLAG.PAS}
interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, StdCtrls, IdBaseComponent, IdComponent,
  IdTCPConnection, IdTCPClient;

type
  TfrmClient = class(TForm)
    Label1: TLabel;
    Label2: TLabel;
    edtHost: TEdit;
    Label3: TLabel;
    edtPort: TEdit;
    btnConnect: TButton;
    btnDisconnect: TButton;
    Bevel1: TBevel;
    btnExit: TButton;
    lbCommunication: TListBox;
    procedure btnExitClick(Sender: TObject);
    procedure btnDisconnectClick(Sender: TObject);
    procedure btnConnectClick(Sender: TObject);
    procedure IdTCPClientDisconnected(Sender: TObject);
    procedure IdTCPClientConnected(Sender: TObject);
  private
    { Private declarations }
    TCPClient: TIdTCPClient;
    procedure LockControls(ALock:Boolean);
  public
    { Public declarations }
    Function Enter(Client: TIdTCPClient): Word;
  end;

implementation

{$R *.dfm}

procedure TfrmClient.btnExitClick(Sender: TObject);
begin
  Close;
end;

procedure TfrmClient.LockControls(ALock: Boolean);
var
    i : integer;
begin
for i := 0 to componentcount-1 do
    if TControl(Components[i]).Tag = 99 then
        TControl(Components[i]).Enabled := ALock;
end;

procedure TfrmClient.btnDisconnectClick(Sender: TObject);
begin
if TCPClient.Connected then
    try
    TCPClient.Disconnect; // we can disconnect from either the server or the client side
    btnConnect.Enabled := true;
    btnDisconnect.Enabled := false;
    except on E : Exception do
        ShowMessage(E.Message);
    end;
end;

procedure TfrmClient.btnConnectClick(Sender: TObject);
begin
lbCommunication.Items.Clear;

with TCPClient do
    begin
    Host := edtHost.Text;
    Port := StrToint(edtPort.Text);
      try
      Connect; // add a timeout here if you wish, eg: Connect(3000) = timeout after 3 seconds.
      lbCommunication.Items.Add(ReadLn);
      btnConnect.Enabled := false;
      btnDisconnect.Enabled := true;

      except
      on E : Exception do
          begin
          LockControls(True);
          ShowMessage(E.Message);
          end;
      end;
    end;

end;

procedure TfrmClient.IdTCPClientDisconnected(Sender: TObject);
begin
lbCommunication.Items.Add('Disconnected from remote server');
LockControls(false);
end;

procedure TfrmClient.IdTCPClientConnected(Sender: TObject);
var
    LString : String;
begin
LString := TCPClient.ReadLn;
lbCommunication.Items.Add('Connected to remote server');
lbCommunication.Items.Add('Server said -> ' + LString);
LockControls(true);
end;

function TfrmClient.Enter(Client: TIdTCPClient): Word;
begin
  TCPClient:= Client;
  Result:= ShowModal;
end;

end.
