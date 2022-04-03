unit AddressForm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls;

type
  TfrmAddress = class(TForm)
    Label1: TLabel;
    Label2: TLabel;
    Edit1: TEdit;
    Edit2: TEdit;
    Button1: TButton;
    Button2: TButton;
    procedure Edit1KeyPress(Sender: TObject; var Key: Char);
    procedure Edit2KeyPress(Sender: TObject; var Key: Char);
    procedure Button1Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmAddress: TfrmAddress;

  function ShowAddress(var Street: String; var Building: String): Boolean;

implementation

{$R *.dfm}

function ShowAddress(var Street, Building: String): Boolean;
begin
  if frmAddress = nil then frmAddress := TfrmAddress.Create(Application);
  with frmAddress do
  begin
    result := ShowModal = mrOK;
    Street := Edit1.Text;
    Building := Edit2.Text;
  end;
end;

procedure TfrmAddress.Edit1KeyPress(Sender: TObject; var Key: Char);
begin
  if Key = #13 then Edit2.SetFocus;
end;

procedure TfrmAddress.Edit2KeyPress(Sender: TObject; var Key: Char);
begin
  if Key = #13 then Button1Click(nil);
end;

procedure TfrmAddress.Button1Click(Sender: TObject);
begin
  ModalResult := mrOK;
end;

end.
