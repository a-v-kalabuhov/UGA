unit ReNum;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, 
  StdCtrls, ComCtrls;

type
  TRenumForm = class(TForm)
    Label1: TLabel;
    edtDelta: TEdit;
    udDelta: TUpDown;
    btnOk: TButton;
    btnCancel: TButton;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

function ShowRenum(var Num: Integer): Boolean;

implementation

{$R *.DFM}

function ShowRenum(var Num: Integer): Boolean;
begin
  with TRenumForm.Create(Application) do try
    Result:=(ShowModal=mrOk);
    if Result then Num:=udDelta.Position;
  finally
    Free;
  end;
end;

end.
