unit Signatures;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, 
  IBCHILD, JvFormPlacement, Db, IBCustomDataSet, IBQuery, IBUpdateSQL, IBDatabase,
  Menus, ActnList, ImgList, Grids, DBGrids, ComCtrls, ToolWin, uDBGrid,
  uLegend, JvComponentBase;

type
  TSignaturesForm = class(TIBChildForm)
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure QueryAfterInsert(DataSet: TDataSet);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  SignaturesForm: TSignaturesForm;

implementation

{$R *.DFM}

uses
  uKisConsts;

procedure TSignaturesForm.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  inherited;
  SignaturesForm := nil;
end;

procedure TSignaturesForm.QueryAfterInsert(DataSet: TDataSet);
begin
  inherited;
  Query.FieldByName(SF_DOC_ORDER).Value := N_ONE;
end;

end.
