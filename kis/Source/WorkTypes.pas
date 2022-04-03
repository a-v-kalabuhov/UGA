unit WorkTypes;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, 
  StdCtrls, Db, IBCustomDataSet, IBQuery, Grids, DBGrids;

type
  TWorkTypesForm = class(TForm)
    Query: TIBQuery;
    btnOk: TButton;
    btnCancel: TButton;
    DataSource: TDataSource;
    QueryID: TSmallintField;
    QueryPRICE: TFloatField;
    Grid: TDBGrid;
    QueryARGUMENT: TIBStringField;
    QueryCODE: TIBStringField;
    QuerySHORT_NAME: TIBStringField;
    QueryNAME: TIBStringField;
    procedure GridDblClick(Sender: TObject);
  end;

function ShowWorkTypes(var WorkId: Integer; var WorkName, WorkArgument,
  WorkCode: String; var WorkPrice: Double): Boolean;

implementation

{$R *.DFM}

uses
  Accounts, uKisConsts, uKisAppModule, uIBXUtils;

function ShowWorkTypes(var WorkId: Integer; var WorkName, WorkArgument, WorkCode: String;
  var WorkPrice: Double): Boolean;
begin
  with TWorkTypesForm.Create(Application) do
  try
    if Assigned(AccountsForm) then
    begin
      Query.Transaction := AccountsForm.Transaction;
      Query.ParamByName(SF_OFFICES_ID).AsInteger := AccountsForm.Query.FieldByName(SF_OFFICES_ID).AsInteger;
    end
    else
    begin
      Query.Transaction := AppModule.Pool.Get;
      Query.Transaction.Init();
      Query.ParamByName(SF_OFFICES_ID).AsInteger := AppModule.User.OfficeId;
    end;
    Query.Open;
    Query.FetchAll;
    Query.Locate(SF_ID,WorkId,[]);
    Result := ShowModal = mrOk;
    if Result then
    begin
      WorkId := Query.FieldByName(SF_ID).AsInteger;
      WorkName := Query.FieldByName(SF_NAME).AsString;
      WorkArgument := Query.FieldByName(SF_ARGUMENT).AsString;
      WorkPrice := Query.FieldByName(SF_PRICE).AsFloat;
      WorkCode := Query.FieldByName('CODE').AsString;
    end;
  finally
    if not Assigned(AccountsForm) then
      AppModule.Pool.Back(Query.Transaction);
    Free;
  end;
end;

procedure TWorkTypesForm.GridDblClick(Sender: TObject);
begin
  ModalResult := mrOk;
end;

end.
