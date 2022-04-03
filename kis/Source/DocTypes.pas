unit DocTypes;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, 
  IBCHILD, JvFormPlacement, Db, IBCustomDataSet, IBQuery, IBUpdateSQL, IBDatabase,
  Menus, ActnList, ImgList, Grids, DBGrids, ComCtrls, ToolWin, IBSQL,
  uDBGrid, uLegend, JvComponentBase;

type
  TDocTypesForm = class(TIBChildForm)
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  DocTypesForm: TDocTypesForm;

implementation

uses
  uKisMainView, uKisAppModule;

{$R *.DFM}

procedure TDocTypesForm.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  inherited;
  DocTypesForm := nil;
  KisMainView.FillLettersMenu;
end;

procedure TDocTypesForm.FormCreate(Sender: TObject);
begin
  inherited;
  Transaction.DefaultDatabase := AppModule.Database;
end;

end.
