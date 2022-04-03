unit AConnect6;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, Db, IBDatabase;

type
  TConnectForm = class(TForm)
    btnOk: TButton;
    btnCancel: TButton;
    OpenDialog: TOpenDialog;
    btnTest: TButton;
    rbLocal: TRadioButton;
    rbRemote: TRadioButton;
    Label1: TLabel;
    edtServer: TEdit;
    Label2: TLabel;
    cbProtocol: TComboBox;
    btnBrowse: TButton;
    Label3: TLabel;
    edtDatabase: TEdit;
    IBDatabase: TIBDatabase;
    procedure SetControls(Sender: TObject);
    procedure btnBrowseClick(Sender: TObject);
    procedure btnTestClick(Sender: TObject);
  private
    function GetDatabaseName: String;
  public
    { Public declarations }
  end;

function ShowConnect(var DatabaseName: String): Boolean;

implementation

{$R *.DFM}

uses
  AFile6, uKisConsts, StrUtils;

function ShowConnect(var DatabaseName: String): Boolean;
begin
  with TConnectForm.Create(Application) do
  try
    //заполняем поля
    edtServer.Text:=NetExtractServer(DatabaseName);
    rbLocal.Checked:=(edtServer.Text='');
    rbRemote.Checked:=not rbLocal.Checked;
    cbProtocol.Text:=NetExtractProtocol(DatabaseName);
    edtDatabase.Text:=NetExtractFileName(DatabaseName);
    SetControls(nil);
    Result:=(ShowModal=mrOk);
    if Result then DatabaseName:=GetDatabaseName;
  finally
    Free;
  end;
end;

procedure TConnectForm.SetControls(Sender: TObject);
begin
  edtServer.Enabled:=rbRemote.Checked;
  cbProtocol.Enabled:=rbRemote.Checked;
  btnBrowse.Enabled:=rbLocal.Checked;
end;

procedure TConnectForm.btnBrowseClick(Sender: TObject);
begin
  if OpenDialog.Execute then
    edtDatabase.Text:=OpenDialog.FileName;
end;

procedure TConnectForm.btnTestClick(Sender: TObject);
var
  TestOk: Boolean;
  OldName, Mes: string;
begin
  TestOk:=True;
  with IBDatabase do begin
    OldName:=DatabaseName;
    Connected:=False;
    DatabaseName:=GetDatabaseName;
    try
      Connected:=True;
    except
      on E: Exception do
      begin
        TestOk := False;
        Mes := E.Message;
      end;
    end;
    Connected := False;
    DatabaseName := OldName;
  end;
  if TestOk then
    MessageBox(0, PChar(S_CONNECTED_OK), PChar(S_MESS), MB_ICONINFORMATION)
  else
    MessageBox(0, PChar(S_CONNECTED_FAIL + #13 + Mes), PChar(S_ERROR), MB_ICONSTOP)
end;

function TConnectForm.GetDatabaseName: String;
begin
  Result:=NetGetFileName(IfThen(rbRemote.Checked,cbProtocol.Text, ''),
    edtServer.Text,edtDatabase.Text);
end;

end.
