unit uMStDialogAddress;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  StdCtrls;

type
  TmstAddressForm = class(TForm)
    Label1: TLabel;
    Label2: TLabel;
    edStreet: TEdit;
    edBuilding: TEdit;
    Button1: TButton;
    Button2: TButton;
    procedure edStreetKeyPress(Sender: TObject; var Key: Char);
    procedure edBuildingKeyPress(Sender: TObject; var Key: Char);
    procedure Button1Click(Sender: TObject);
  end;

  function ShowAddress(var Street, Building: String): Boolean;

implementation

{$R *.dfm}

uses
  uMstModuleApp;

function ShowAddress(var Street, Building: String): Boolean;
begin
  with TmstAddressForm.Create(Application) do
  try
    edStreet.Text := Street;
    edBuilding.Text := Building;
    Result := ShowModal = mrOK;
    Street := edStreet.Text;
    Building := edBuilding.Text;
  finally
    Release;
  end;
end;

procedure TmstAddressForm.edStreetKeyPress(Sender: TObject; var Key: Char);
begin
  if Key = #13 then edBuilding.SetFocus;
end;

procedure TmstAddressForm.edBuildingKeyPress(Sender: TObject; var Key: Char);
begin
  if Key = #13 then Button1Click(nil);
end;

procedure TmstAddressForm.Button1Click(Sender: TObject);
begin
  if Trim(edStreet.Text) = '' then
  begin
    mstClientAppModule.Alert('Заполните поле' + #13 + '"Улица"!');
    edStreet.SetFocus;
    Exit;
  end;
{  if Trim(Edit2.Text) = '' then
  begin
    mstClientAppModule.Alert('Заполните поле' + #13 + '"Дом"!');
    edBuilding.SetFocus;
    Exit;
  end; }
  ModalResult := mrOK;
end;

end.
