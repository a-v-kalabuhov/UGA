unit Streets;

{$I KisFlags.pas}

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms,
  IBCHILD, JvFormPlacement, Db, IBCustomDataSet, IBQuery, IBUpdateSQL, IBDatabase,
  Menus, ActnList, ImgList, Grids, DBGrids, ComCtrls, ToolWin, IBSQL,
  StdCtrls, ExtCtrls, uDBGrid, uLegend, JvComponentBase;

type
  TStreetsForm = class(TIBChildForm)
    pnlOkCancel: TPanel;
    btnOk: TButton;
    btnCancel: TButton;
    QueryID: TIntegerField;
    QueryREGIONS_ID: TIntegerField;
    QueryVILLAGES_ID: TIntegerField;
    QueryNAME: TIBStringField;
    QuerySTREET_MARKING_NAME: TIBStringField;
    QueryNAME_LATER: TIBStringField;
    QueryKILL_STATE: TIBStringField;
    QueryCREATE_DOC_ID: TIntegerField;
    QueryKILL_DOC_ID: TIntegerField;
    QueryNEXT_ID: TIntegerField;
    QueryABOUT: TMemoField;
    QueryERROR: TIBStringField;
    QueryUGA: TSmallintField;
    QuerySTREET_MARKING_ID: TIntegerField;
    QueryFEDERAL_CODE: TIBStringField;
    QueryREGISTRY_NUMBER: TIntegerField;
    QueryPOST_INDEX: TIntegerField;
    QueryREGIONS_NAME: TIBStringField;
    QueryVILLAGES_NAME: TIBStringField;
    QueryCREATE_NUMBER: TIBStringField;
    QueryCREATE_DATE: TDateTimeField;
    QueryCREATE_TYPE: TIBStringField;
    QueryKILL_NUMBER: TIBStringField;
    QueryKILL_DATE: TDateTimeField;
    QueryKILL_TYPE: TIBStringField;
    procedure FormCreate(Sender: TObject);
    procedure QueryAfterInsert(DataSet: TDataSet);
    procedure actShowExecute(Sender: TObject);
    procedure QueryAfterScroll(DataSet: TDataSet);
    procedure QueryBeforePost(DataSet: TDataSet);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure pnlOkCancelResize(Sender: TObject);
  private
    procedure ModifyRecord(New: Boolean);
  end;

var
  StreetsForm: TStreetsForm;

  function SelectStreet(var Id: Integer): Boolean;

implementation

{$R *.DFM}

uses
  // System
  Variants,
  // Project
  Street, uKisAppModule, uKisConsts;

var
  iid: Integer;

function SelectStreet(var Id: Integer): Boolean;
begin
  with TStreetsForm.Create(Application) do
    try
      Transaction.DefaultDatabase := AppModule.Database;
      pnlOkCancel.Visible := True;
      FStartSQL.Assign(Query.SQL);
      Query.Open;
      iid := Query.FieldByName(SF_ID).AsInteger;
      Query.FetchAll;
      if Id > 0 then
      if not Query.Locate(SF_ID, Id, []) then
        MessageBox(0, PChar(S_RECORD_NOT_FOUND), PChar(S_WARN), MB_ICONWARNING);
      Result := (ShowModal = mrOk);
      Id := iid;//Query.FieldByName(SF_ID).AsInteger;
    finally
      Release;
    end;
end;

procedure TStreetsForm.FormCreate(Sender: TObject);
begin
  inherited;
  Transaction.DefaultDatabase := AppModule.Database;
  AutoCommitAfterPost := False;
end;

procedure TStreetsForm.ModifyRecord(New: Boolean);
begin
  if ShowStreet(Transaction) then
    Transaction.CommitRetaining
  else
  begin
    if New then Query.Delete;
    Transaction.RollbackRetaining;
  end;
  Query.Refresh;
end;

procedure TStreetsForm.QueryAfterInsert(DataSet: TDataSet);
begin
  inherited;
  QueryUGA.AsInteger := 1;
  QuerySTREET_MARKING_ID.AsInteger := 0;
  QuerySTREET_MARKING_NAME.AsString := #32;
  QueryNAME.AsString := #32;
  Query.Post;
  Query.Edit;
  ModifyRecord(True);
end;

procedure TStreetsForm.actShowExecute(Sender: TObject);
begin
  inherited;
  ModifyRecord(False);
end;

procedure TStreetsForm.QueryAfterScroll(DataSet: TDataSet);
begin
  inherited;
  iid := Query.FieldByName(SF_ID).AsInteger;
end;

procedure TStreetsForm.QueryBeforePost(DataSet: TDataSet);
begin
  inherited;
{  if QueryVILLAGES_ID.AsInteger = 0 then
    QueryVILLAGES_ID.Value := NULL;      }
end;

procedure TStreetsForm.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  inherited;
  StreetsForm := nil;
end;

procedure TStreetsForm.pnlOkCancelResize(Sender: TObject);
begin
  inherited;
  btnCancel.Left := pnlOkCancel.ClientWidth - btnCancel.Width - 8;
  btnOk.Left := pnlOkCancel.ClientWidth - btnCancel.Left - btnOk.Width - 8;
end;

end.
