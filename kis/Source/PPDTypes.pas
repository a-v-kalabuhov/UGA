unit PPDTypes;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, 
  IBCHILD, JvFormPlacement, Db, IBCustomDataSet, IBQuery, IBUpdateSQL, IBDatabase,
  Menus, ActnList, ImgList, Grids, DBGrids, ComCtrls, ToolWin, IBSQL,
  uDBGrid, uLegend, JvComponentBase;

type
  TPPDTypesForm = class(TIBChildForm)
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  PPDTypesForm: TPPDTypesForm;

implementation

{$R *.DFM}

procedure TPPDTypesForm.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  inherited;
  PPDTypesForm:=nil;
end;

end.
