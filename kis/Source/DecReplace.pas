unit DecReplace;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, 
  StdCtrls;

type
  TDecReplaceForm = class(TForm)
    Label1: TLabel;
    Label2: TLabel;
    memOld: TMemo;
    memNew: TMemo;
    btnReplace: TButton;
    btnSkip: TButton;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

function ShowDecReplace(OldText, NewText: TStrings): Boolean;

implementation

{$R *.DFM}

function ShowDecReplace(OldText, NewText: TStrings): Boolean;
begin
  with TDecReplaceForm.Create(Application) do try
    memOld.Lines.Assign(OldText);
    memNew.Lines.Assign(NewText);
    Result:=ShowModal=mrOk;
  finally
    Free;
  end;
end;

end.
