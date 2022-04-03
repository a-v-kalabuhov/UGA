unit Situations;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, 
  IBCHILD, JvFormPlacement, Db, IBCustomDataSet, IBQuery, IBUpdateSQL, IBDatabase,
  Menus, ActnList, ImgList, Grids, DBGrids, ComCtrls, ToolWin, IBSQL,
  uDBGrid, uLegend;

type
  TSituationsForm = class(TIBChildForm)
    QueryID: TIntegerField;
    QueryDOC_NUMBER: TSmallintField;
    QueryDOC_DATE: TDateTimeField;
    QueryCUSTOMER: TIBStringField;
    QueryADDRESS: TIBStringField;
    QueryX: TFloatField;
    QueryY: TFloatField;
    QueryAZIMUTH: TFloatField;
    ibsMaxNumber: TIBSQL;
    QueryYEAR_NUMBER: TIBStringField;
    QueryEXECUTOR: TIBStringField;
    QueryX_ORIENTIR: TFloatField;
    QueryY_ORIENTIR: TFloatField;
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure QueryAfterInsert(DataSet: TDataSet);
    procedure actShowExecute(Sender: TObject);
  private
    procedure ModifyRecord(New: Boolean=False);
  public
    { Public declarations }
  end;

var
  SituationsForm: TSituationsForm;

implementation

uses
  Situation, AIB6, uKisAppModule, uKisConsts;

{$R *.DFM}

procedure TSituationsForm.FormCreate(Sender: TObject);
begin
  inherited;
  Transaction.DefaultDatabase := AppModule.Database;
  AutoCommitAfterPost := False;
end;

procedure TSituationsForm.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  inherited;
  SituationsForm := nil;
end;

procedure TSituationsForm.ModifyRecord(New: Boolean=False);
begin
  if ShowTSituation then
    Transaction.CommitRetaining
  else
  begin
    if New then Query.Delete;
    Transaction.RollbackRetaining;
  end;
end;

procedure TSituationsForm.QueryAfterInsert(DataSet: TDataSet);
begin
  inherited;
  with ibsMaxNumber do
  begin
    ExecQuery;
    try
      Query.FieldByName(SF_DOC_NUMBER).AsInteger := Succ(Fields[0].AsInteger);
    finally
      Close;
    end;
  end;
  Query.Post;
  Query.Edit;
  ModifyRecord(True);
end;

procedure TSituationsForm.actShowExecute(Sender: TObject);
begin
  inherited;
  ModifyRecord(False);
end;

end.
