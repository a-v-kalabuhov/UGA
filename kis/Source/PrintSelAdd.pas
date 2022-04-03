unit PrintSelAdd;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, 
  StdCtrls, Dialogs;

type
  TPrintSelAddForm = class(TForm)
    edNameDoc: TEdit;
    Label1: TLabel;
    edNameFile: TEdit;
    Label2: TLabel;
    Button1: TButton;
    Button2: TButton;
    Button3: TButton;
    OpenDialog: TOpenDialog;
    procedure Button2Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure Button1Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  PrintSelAddForm: TPrintSelAddForm;
  function GetPrintSelAddParams(var NameDoc, NameFile: String; ActivePath: Boolean=true): boolean;

implementation

{$R *.DFM}

uses PrintSel;

function GetPrintSelAddParams(var NameDoc, NameFile: string; ActivePath: Boolean=true): boolean;
begin
  with TPrintSelAddForm.Create(Application) do
  try
    edNameDoc.text := NameDoc;
    edNameFile.text := NameFile;

    if not ActivePath then
    begin
      edNameFile.Enabled := false;
      Button3.Enabled := false;
    end;

    Result := (ShowModal = mrOK);
    if Result then
    begin
      NameDoc := edNameDoc.text;
      NameFile := edNameFile.text;
    end;
  finally
    Free;
  end;
end;


procedure TPrintSelAddForm.Button2Click(Sender: TObject);
begin
  ModalResult:=mrOk;
end;

procedure TPrintSelAddForm.Button3Click(Sender: TObject);
begin
  if OpenDialog.Execute then
  edNameFile.text:=OpenDialog.FileName;
end;

procedure TPrintSelAddForm.Button1Click(Sender: TObject);
begin
  ModalResult:=mrCancel;
end;

end.
