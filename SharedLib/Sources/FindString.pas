unit FindString;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls;

type
  TfrmFindString = class(TForm)
    LabeledEdit1: TLabeledEdit;
    Button1: TButton;
    Button2: TButton;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

  function GetStringToFind(fCaption: String; var resString: String): Boolean;

implementation

{$R *.dfm}

function GetStringToFind(fCaption: String; var resString: String): Boolean;
begin
  with TfrmFindString.Create(Application) do
  begin
    LabeledEdit1.EditLabel.Caption := fCaption;
    LabeledEdit1.Text := '';
    result := ShowModal = mrOK;
    resString := LabeledEdit1.Text;
    Release;
  end;
end;

end.
