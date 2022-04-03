unit LoginForm;

interface

uses Windows, SysUtils, Classes, Graphics, Forms, Controls, StdCtrls, 
  Buttons, ExtCtrls;

type
  TPasswordDlg = class(TForm)
    Label1: TLabel;
    edtPassword: TEdit;
    OKBtn: TButton;
    CancelBtn: TButton;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    procedure FormShow(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

  function PasswordDialog(username, login: String; var password: String): Boolean;

implementation

function PasswordDialog(username, login: String; var password: String): Boolean;
begin
  with TPasswordDlg.Create(Application) do
  begin
    Label5.Caption := username;
    Label4.Caption := login;
    result := ShowModal = mrOK;
    if result then password := edtPassword.Text;
    Release;
  end;
end;

{$R *.dfm}

procedure TPasswordDlg.FormShow(Sender: TObject);
begin
   SetForegroundWindow(Handle);
end;

end.
 
