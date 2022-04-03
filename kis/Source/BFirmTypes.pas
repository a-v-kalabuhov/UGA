unit BFirmTypes;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, 
  IBCHILD, JvFormPlacement, Db, IBCustomDataSet, IBQuery, IBUpdateSQL, IBDatabase,
  Menus, ActnList, ImgList, Grids, DBGrids, ComCtrls, ToolWin, IBSQL,
  uDBGrid, uLegend, JvComponentBase;

type
  TBFirmTypesForm = class(TIBChildForm)
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  BFirmTypesForm: TBFirmTypesForm;

implementation

{$R *.DFM}

uses
  uKisCOnsts;

procedure TBFirmTypesForm.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  inherited;
  BFirmTypesForm:=nil;
end;

end.
