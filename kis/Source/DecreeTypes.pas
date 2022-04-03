unit DecreeTypes;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, 
  IBCHILD, JvFormPlacement, Db, IBCustomDataSet, IBQuery, IBUpdateSQL, IBDatabase,
  Menus, DBActns, ActnList, ImgList, Grids, DBGrids, ComCtrls, ToolWin,
  IBSQL, uDBGrid, uLegend, JvComponentBase;

type
  TDecreeTypesForm = class(TIBChildForm)
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  DecreeTypesForm: TDecreeTypesForm;

implementation

{$R *.DFM}

procedure TDecreeTypesForm.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  inherited;
  DecreeTypesForm:=nil;
end;

end.
