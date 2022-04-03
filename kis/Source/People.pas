unit People;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, 
  IBCHILD, JvFormPlacement, Db, IBCustomDataSet, IBQuery, IBUpdateSQL, IBDatabase,
  Menus, ActnList, ImgList, Grids, DBGrids, ComCtrls, ToolWin, IBSQL, StrUtils,
  // jedi
  JvComponentBase,
  // kis components
  uDBGrid, uLegend,
  // shared
  uDB,
  // kis
  uKisClasses, uKisAppModule, uKisConsts;


type
  TPeopleForm = class(TIBChildForm)
    ibqOffices: TIBQuery;
    dsOffices: TDataSource;
    QueryOFFICES_NAME: TStringField;
    ibqPeopleTypes: TIBQuery;
    dsPeopleTypes: TDataSource;
    ibqOrgs: TIBQuery;
    dsOrgs: TDataSource;
    QueryTYPE_NAME: TIBStringField;
    QueryORG_NAME: TIBStringField;
    QueryENABLED: TIBStringField;
    QueryPEOPLE_TYPES_ID: TIntegerField;
    QueryORGS_ID: TIntegerField;
    QueryID: TIntegerField;
    QueryFIRST_NAME: TIBStringField;
    QueryMIDDLE_NAME: TIBStringField;
    QueryLAST_NAME: TIBStringField;
    QueryPOST: TIBStringField;
    QueryOFFICES_ID: TIntegerField;
    QueryUSER_NAME: TIBStringField;
    QueryROLE_NAME: TIBStringField;
    QueryCAN_SHEDULE_WORKS: TSmallintField;
    QueryCAN_CREATE_ORDERS: TSmallintField;
    QueryCAN_SEE_ALL_OFFICES: TSmallintField;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure QueryAfterInsert(DataSet: TDataSet);
    procedure FormCreate(Sender: TObject);
    procedure QueryBeforePost(DataSet: TDataSet);
    procedure GridKeyPress(Sender: TObject; var Key: Char);
    procedure GridCellClick(Column: TColumn);
    procedure GridCanShowEdit(Sender: TObject; Column: TColumn;
      var Value: Boolean);
    procedure GridGetLogicalValue(Sender: TObject; Column: TColumn;
      var Value: Boolean);
    procedure GridLogicalColumn(Sender: TObject; Column: TColumn;
      var Value: Boolean);
  private
    procedure InitIBX;
  end;

var
  PeopleForm: TPeopleForm;

implementation

{$R *.DFM}

procedure TPeopleForm.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  inherited;
  PeopleForm := nil;
end;

procedure TPeopleForm.QueryAfterInsert(DataSet: TDataSet);
begin
  inherited;
  QueryORGS_ID.AsInteger := 0;
  QueryPEOPLE_TYPES_ID.AsInteger := 0;
end;

procedure TPeopleForm.FormCreate(Sender: TObject);
var
  I: Integer;
begin
  inherited;
  Self.OnReadAppParam := AppModule.ReadAppParam;
  Self.OnWriteAppParam := AppModule.SaveAppParam;
  Self.OnReadGridProps := AppModule.ReadGridProperties;
  Self.OnWriteGridProps := AppModule.WriteGridProperties;
  InitIBX;
  ibqOffices.Open;
  ibqOffices.FetchAll;
  ibqOrgs.Open;
  ibqOrgs.FetchAll;
  ibqPeopleTypes.Open;
  ibqPeopleTypes.FetchAll;
  for I := N_ZERO to Pred(Grid.Columns.Count) do
  if Grid.Columns[I].FieldName = SF_ENABLED then
    Grid.Columns[I].Visible := AppModule.User.IsAdministrator
  else
  if Grid.Columns[I].FieldName = SF_ORGS_ID then
    Grid.Columns[I].DropDownRows := ibqOrgs.RecordCount
  else
  if Grid.Columns[I].FieldName = SF_PEOPLE_TYPES_ID then
    Grid.Columns[I].DropDownRows := ibqPeopleTypes.RecordCount;
end;

procedure TPeopleForm.GridCanShowEdit(Sender: TObject; Column: TColumn;
  var Value: Boolean);
var
  Col: TColumn;
begin
  inherited;
  Col := Grid.CurrentCol;
  Value :=
    (Col.Field <> QueryCAN_SHEDULE_WORKS) and
    (Col.Field <> QueryENABLED) and
    (Col.Field <> QueryCAN_SEE_ALL_OFFICES) and
    (Col.Field <> QueryCAN_CREATE_ORDERS);
end;

procedure TPeopleForm.GridCellClick(Column: TColumn);
var
  Val, B: Boolean;
begin
  inherited;
  Val := False;
  Grid.OnLogicalColumn(Grid, Column, Val);
  if Val then
  begin
    if Grid.EditorMode then
      Grid.EditorMode := False;
    Val := False;
    Grid.OnGetLogicalValue(Grid, Column, Val);
    Val := not Val;
    if (Column.Field = QueryCAN_SHEDULE_WORKS)
       or
       (Column.Field = QueryCAN_SEE_ALL_OFFICES)
       or
       (Column.Field = QueryCAN_CREATE_ORDERS)
    then
    begin
      B := Query.SoftEdit();
      Column.Field.AsInteger := Integer(Val);
      if B then
        Query.SoftPost();
    end
    else
    if Column.Field = QueryENABLED then
    begin
      B := Query.SoftEdit();
      Column.Field.AsString := IfThen(Val, 'T', 'F');
      if B then
        Query.SoftPost();
    end;
  end;
end;

procedure TPeopleForm.GridGetLogicalValue(Sender: TObject; Column: TColumn;
  var Value: Boolean);
begin
  inherited;
  if Column.FieldName = SF_ENABLED then
    Value := QueryENABLED.AsString = 'T'
  else
  if Column.FieldName = SF_CAN_SHEDULE_WORKS then
    Value := Boolean(QueryCAN_SHEDULE_WORKS.AsInteger)
  else
  if Column.FieldName = SF_CAN_SEE_ALL_OFFICES then
    Value := Boolean(QueryCAN_SEE_ALL_OFFICES.AsInteger)
  else
  if Column.FieldName = SF_CAN_CREATE_ORDERS then
    Value := Boolean(QueryCAN_CREATE_ORDERS.AsInteger);
end;

procedure TPeopleForm.GridKeyPress(Sender: TObject; var Key: Char);
var
  aCol: TColumn;
  Val, B: Boolean;
begin
  inherited;
  if Key = #32 then
  begin
    aCol := Grid.Columns[Grid.Col];
    Val := False;
    Grid.OnLogicalColumn(Grid, aCol, Val);
    if Val then
    begin
      if Grid.EditorMode then
        Grid.EditorMode := False;
      Val := False;
      Grid.OnGetLogicalValue(Grid, aCol, Val);
      Val := not Val;
      if (aCol.Field = QueryCAN_SHEDULE_WORKS)
         or
         (aCol.Field = QueryCAN_SEE_ALL_OFFICES)
         or
         (aCol.Field = QueryCAN_CREATE_ORDERS)
      then
      begin
        B := Query.SoftEdit();
        aCol.Field.AsInteger := Integer(Val);
        if B then
          Query.SoftPost();
      end
      else
      if aCol.Field = QueryENABLED then
      begin
        B := Query.SoftEdit();
        aCol.Field.AsString := IfThen(Val, 'T', 'F');
        if B then
          Query.SoftPost();
      end;
    end;
  end;
end;

procedure TPeopleForm.GridLogicalColumn(Sender: TObject; Column: TColumn;
  var Value: Boolean);
begin
  inherited;
  Value := (Column.Field = QueryENABLED) or
           (Column.Field = QueryCAN_SHEDULE_WORKS) or
           (Column.Field = QueryCAN_SEE_ALL_OFFICES) or
           (Column.Field = QueryCAN_CREATE_ORDERS);
end;

procedure TPeopleForm.InitIBX;
begin
  Transaction.DefaultDatabase := AppModule.Database;
  Query.Transaction := Transaction;
  ibqOffices.Transaction := Transaction;
  ibqOrgs.Transaction := Transaction;
  ibqPeopleTypes.Transaction := Transaction;
end;

procedure TPeopleForm.QueryBeforePost(DataSet: TDataSet);
begin
  inherited;
  if Query.FieldByName(SF_ENABLED).IsNull then
  begin
    MessageBox(Self.Handle,
      PChar('Необходимо установить значение поля "Активен"!'),
      PChar(S_WARN),
      MB_OK + MB_ICONWARNING);
    Abort;
  end;
end;

end.
