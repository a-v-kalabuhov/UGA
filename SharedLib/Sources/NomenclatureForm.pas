unit NomenclatureForm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, NomenclatureFrame;

type
  TfrmNomenclature = class(TForm)
    frNomenclature1: TfrNomenclature;
    Button1: TButton;
    Button2: TButton;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

  function ShowNomenclature(var nomen: String): Boolean;

implementation

{$R *.dfm}

function ShowNomenclature(var nomen: String): Boolean;
begin
  with TfrmNomenclature.Create(nil) do
  begin
    frNomenclature1.Init();
    result := ShowModal = mrOK;
    nomen := frNomenclature1.Nomenclature;
    Release;
  end;
end;

end.
