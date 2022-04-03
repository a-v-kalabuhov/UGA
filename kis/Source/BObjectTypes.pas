unit BObjectTypes;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, 
  IBCHILD, JvFormPlacement, Db, IBCustomDataSet, IBQuery, IBUpdateSQL, IBDatabase,
  Menus, ActnList, ImgList, Grids, DBGrids, ComCtrls, ToolWin, IBSQL,
  uDBGrid, uLegend, JvComponentBase;

type
  TBObjectTypesForm = class(TIBChildForm)
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  BObjectTypesForm: TBObjectTypesForm;

implementation

uses
  uKisMainView;

{$R *.DFM}

procedure TBObjectTypesForm.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  inherited;
  BObjectTypesForm := nil;
end;

end.
