unit AddressWorks;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, 
  IBCHILD, JvFormPlacement, Db, IBCustomDataSet, IBQuery, IBUpdateSQL, IBDatabase,
  Menus, ActnList, ImgList, Grids, DBGrids, ComCtrls, ToolWin, uDBGrid,
  uLegend, JvComponentBase;

type
  TAddressWorksForm = class(TIBChildForm)
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  AddressWorksForm: TAddressWorksForm;

implementation

{$R *.DFM}

procedure TAddressWorksForm.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  inherited;
  AddressWorksForm:=nil;
end;

end.
