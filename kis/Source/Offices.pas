unit Offices;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, 
  IBCHILD, JvFormPlacement, Db, IBCustomDataSet, IBQuery, IBUpdateSQL, IBDatabase,
  Menus, ActnList, ImgList, Grids, DBGrids, ComCtrls, ToolWin, IBSQL,
  uDBGrid, uLegend, JvComponentBase;

type
  TOfficesForm = class(TIBChildForm)
    QueryID: TIntegerField;
    QueryNAME: TIBStringField;
    QuerySHORT_NAME: TIBStringField;
    QueryPHONES: TIBStringField;
    QueryDIRECTOR: TIBStringField;
    QueryROLE_NAME: TIBStringField;
    QueryORG_NAME: TIBStringField;
    QueryORGS_ID: TIntegerField;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure QueryAfterInsert(DataSet: TDataSet);
    procedure FormCreate(Sender: TObject);
    procedure actShowExecute(Sender: TObject);
  private
    procedure ModifyRecord(New: Boolean);
  end;

var
  OfficesForm: TOfficesForm;

implementation

{$R *.DFM}

uses
  Office, uKisAppModule, uKisConsts;

procedure TOfficesForm.FormCreate(Sender: TObject);
begin
  inherited;
  Transaction.DefaultDatabase := AppModule.Database;
  AutoCommitAfterPost := False;
end;

procedure TOfficesForm.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  inherited;
  OfficesForm := nil;
end;

procedure TOfficesForm.QueryAfterInsert(DataSet: TDataSet);
begin
  inherited;
  ModifyRecord(True);
end;

procedure TOfficesForm.ModifyRecord(New: Boolean);
begin
  if ShowOffice then
    Transaction.CommitRetaining
  else 
    Transaction.RollbackRetaining;
end;

procedure TOfficesForm.actShowExecute(Sender: TObject);
begin
  inherited;
  ModifyRecord(False);
end;

end.
