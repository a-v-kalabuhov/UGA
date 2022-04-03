unit Config;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, StdCtrls,
  ComCtrls;

type
  TConfigForm = class(TForm)
    btnOk: TButton;
    btnCancel: TButton;
    Label1: TLabel;
    edtDatabase: TEdit;
    btnBrowse: TButton;
    Label2: TLabel;
    edIniPath: TEdit;
    procedure btnBrowseClick(Sender: TObject);
  end;

//function ShowConfig: Boolean;

implementation

uses AConnect6, uKisAppModule;

{$R *.DFM}
{
function ShowConfig: Boolean;
begin
  with TConfigForm.Create(Application) do
  try
    edtDatabase.Text := AppModule.Database.DatabaseName;
    udLettersNumber.Position := AppModule.ReadAppParam('Letters', 'NumberOrder', 0);
    Result := (ShowModal = mrOk);
    if Result then
    begin
      AppModule.SetDatabaseName(edtDatabase.Text);
      AppModule.SaveAppParam('Letters', 'NumberOrder', udLettersNumber.Position);
    end;
  finally
    Free;
  end;
end;  }

procedure TConfigForm.btnBrowseClick(Sender: TObject);
var
  St: string;
begin
  St := edtDatabase.Text;
  if ShowConnect(St) then edtDatabase.Text := St;
end;

end.
