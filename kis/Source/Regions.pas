unit Regions;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, 
  IBCHILD, Menus, Db, IBCustomDataSet, IBQuery, JvFormPlacement, ADBActns6,
  DBActns, ActnList, ImgList, Grids, DBGrids, ComCtrls, ToolWin,
  IBDatabase, IBUpdateSQL, IBSQL, uDBGrid, uLegend, JvComponentBase;

type
  TRegionsForm = class(TIBChildForm)
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
  end;

var
  RegionsForm: TRegionsForm;

implementation

{$R *.DFM}

uses
  uKisConsts, uKisAppModule;

procedure TRegionsForm.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  RegionsForm := nil;
end;

end.
