unit FindDlg;

interface

uses
  SysUtils, WinTypes, WinProcs, Messages, Classes, Graphics, Controls,
  StdCtrls, ExtCtrls, Forms, Buttons, DBGrids, Db, IBQuery, IBCustomDataSet, IBDatabase, IBSQL,
  // jedi
  JvComponentBase, JvFormPlacement,
  //
  uIBXUtils, uSQL, uGC,
  //
  uKisAppModule;

type
  TFindForm = class(TForm)
    cbColumns: TComboBox;
    Label1: TLabel;
    edtExample: TEdit;
    Label2: TLabel;
    OkBtn: TButton;
    CancelBtn: TButton;
    FStorage: TJvFormStorage;
    cbIdentical: TCheckBox;
    cbCaseSensitive: TCheckBox;
    Label3: TLabel;
    cbTable: TComboBox;
    Transaction: TIBTransaction;
    ibqFields: TIBQuery;
    ibqTables: TIBQuery;
    ibsSelect: TIBSQL;
    procedure OkBtnClick(Sender: TObject);
    procedure cbTableClick(Sender: TObject);
    procedure cbColumnsClick(Sender: TObject);
  private
    CurGrid: TDBGrid;
    FieldType: TFieldType;
    procedure SetControls;
    procedure LoadFields;
  end;

function ShowFindDlg(Grid: TDBGrid): boolean;

implementation

{$R *.DFM}

uses
  AProc6, uKisConsts;

//для поиска по связанному полю необходимо, чтобы запрос возвращал поле с тем же
//именем, например, если вычисляемое поле "REGIONS_NAME", то в запросе должно быть
//"B.REGIONS_NAME"
function ShowFindDlg(Grid: TDBGrid): boolean;
var
  Query: TIBQuery;
  FindOptions: TFindOptions;
  NewSQL: TStrings;
  aSql: ISql;
  WhereCond: string;
begin
  if not Assigned(Grid) then
    raise Exception.Create(S_NO_ACTIVE_TABLE);
  with TFindForm.Create(Application) do
  try
    CurGrid := Grid;
    Query := TIBQuery(Grid.DataSource.DataSet);
    //получаем список дочерних таблиц
    with ibqTables do
    begin
      ParamByName(SF_PARENT).AsString := Query.AsSQL.GetPrimaryTable();
      Open;
      while not Eof do
      begin
        cbTable.Items.Add(FieldByName(SF_DESCRIPTION).AsString);
        Next;
      end;
    end;
    cbTable.ItemIndex := 0;
    LoadFields;
    Result := ShowModal = mrOk;
    if Result and (Grid.DataSource.DataSet is TIBQuery) then
    begin
      Query := TIBQuery(Grid.DataSource.DataSet);
      FindOptions := [];
      if cbIdentical.Checked then
        FindOptions := FindOptions + [foIdentical];
      if cbCaseSensitive.Checked then
        FindOptions := FindOptions + [foCaseSensitive];
      NewSQL := TStringList.Create;
      NewSQL.Forget();
      aSql := TSQLFactory.CreateNew(NewSQL);
      NewSQL.Assign(Query.SQL);
      if cbTable.ItemIndex = 0 then
        aSQL.AddWhereByField(Grid.Columns[cbColumns.ItemIndex].Field, edtExample.Text, FindOptions)
      else
      begin
        aSQL.WriteClause(scFrom, aSQL.ReadClause(scFrom) + ', ' + ibqTables.FieldByName(SF_CHILD).AsString);
        with ibsSelect do
        begin
          SQL.Clear;
          SQL.Add(
              'SELECT * FROM GET_RELATION(' +
              QuotedStr(aSQL.GetPrimaryTable()) +
              ',' +
              QuotedStr(ibqTables.FieldByName(SF_CHILD).AsString)+')'
          );
          ExecQuery;
          try
            aSQL.AddWhereCondition(Fields[0].AsString);
            WhereCond := aSQL.GetStringCondition(
              ibqTables.FieldByName(SF_CHILD).AsString + '.' +
              ibqFields.FieldByName(SF_FIELD_NAME).AsString, edtExample.Text,
              FieldType,
              FindOptions);
            aSQL.AddWhereCondition(WhereCond);
          finally
            Close;
          end;
        end;
      end;
      Query.Reset(NewSQL, AppModule.SQLErrorHandler);
    end;
  finally
    Free;
  end;
end;

procedure TFindForm.SetControls;
var
  S: String;
begin
  if cbTable.ItemIndex = 0 then
  begin
    if Assigned(CurGrid)
       and
       (cbColumns.ItemIndex > 0)
       and
       (CurGrid.Columns.Count > cbColumns.ItemIndex)
       and
       Assigned(CurGrid.Columns[cbColumns.ItemIndex].Field)
    then
      FieldType := CurGrid.Columns[cbColumns.ItemIndex].Field.DataType
    else
      FieldType := ftString;
  end
  else
  begin
    ibqFields.RecNo := Succ(cbColumns.ItemIndex);
    S := UpperCase(Trim(ibqFields.FieldByName(SF_FIELD_TYPE).AsString));
    if S = 'SHORT' then
      FieldType := ftSmallint
    else
    if S = 'LONG' then
      FieldType := ftInteger
    else
    if S = 'FLOAT' then
      FieldType := ftFloat
    else
    if S = 'DOUBLE' then
      FieldType := ftFloat
    else
    if S = 'TIMESTAMP' then
      FieldType := ftDateTime
    else
    if S = 'DATE' then
      FieldType := ftDate
    else
    if S = 'TIME' then
      FieldType := ftTime
  else
    if S = 'VARYING' then
      FieldType := ftString
  else
    if S = 'TEXT' then
      FieldType := ftString
  else
    if S = 'BLOB' then
      FieldType := ftBlob
    else
      FieldType := ftUnknown;
  end;

  cbIdentical.Checked := False;
  cbIdentical.Enabled := (FieldType in [ftString, ftWideString,ftBlob,ftMemo,ftFmtMemo]);

  cbCaseSensitive.Checked := (FieldType in [ftBlob,ftMemo,ftFmtMemo]);
  cbCaseSensitive.Enabled := (FieldType in [ftString, ftWideString]);
end;

procedure TFindForm.OkBtnClick(Sender: TObject);
var
  aFieldType: TFieldType;
  D: TDateTime;
  I: Integer;
  F: Double;
  S: String;
begin
  if (cbTable.ItemIndex = 0) and
    not (CurGrid.Columns[cbColumns.ItemIndex].Field.FieldKind in [fkData,fkLookup,fkInternalCalc]) then
    raise Exception.Create(S_CANT_FIND_BY_FIELD);
  aFieldType := CurGrid.Columns[cbColumns.ItemIndex].Field.DataType;
  if aFieldType in [ftDate, ftDateTime] then
    if not TryStrToDate(edtExample.Text, D) then
    begin
      MessageBox(0, PChar(Format('Строка [%s] не является датой!', [edtExample.Text])),
        PChar(S_WARN), MB_OK + MB_ICONWARNING);
      edtExample.SetFocus;
      Exit;
    end;
  if aFieldType in [ftSmallInt, ftInteger] then
    if not TryStrToInt(edtExample.Text, I) then
    begin
      MessageBox(0, PChar(Format('Строка [%s] не является числом!', [edtExample.Text])),
        PChar(S_WARN), MB_OK + MB_ICONWARNING);
      edtExample.SetFocus;
      Exit;
    end;
  if aFieldType = ftFloat then
  begin
    S := StringReplace(edtExample.Text, ',', '.', [rfReplaceAll]);
    if not TryStrToFloat(edtExample.Text, F) then
    begin
      MessageBox(0, PChar(Format('Строка [%s] не является числом!', [edtExample.Text])),
        PChar(S_WARN), MB_OK + MB_ICONWARNING);
      edtExample.SetFocus;
      Exit;
    end
    else
      edtExample.Text := S;
  end;
  ModalResult := mrOk;
end;

procedure TFindForm.LoadFields;
var
  I: Integer;
  tab_name: String;
begin
  cbColumns.Items.Clear;
  if cbTable.ItemIndex = 0 then
  begin
    for I:=0 to Pred(CurGrid.Columns.Count) do
      cbColumns.Items.Add(CurGrid.Columns.Items[I].Title.Caption);
    cbColumns.ItemIndex:=CurGrid.SelectedIndex;
  end
  else begin
    ibqTables.RecNo:=cbTable.ItemIndex;
    with ibqFields do begin
      Close;
      tab_name := ibqTables.FieldByName(SF_CHILD).AsString;
      SetLength(tab_name, 30);
      ParamByName(SF_TABLE_NAME).AsString := tab_name;
      Open;
      while not Eof do begin
        cbColumns.Items.Add(FieldByName(SF_FIELD_DESCRIPTION).AsString);
        Next;
      end;
    end;
    cbColumns.ItemIndex := 0;
  end;
  SetControls;
end;

procedure TFindForm.cbTableClick(Sender: TObject);
begin
  LoadFields;
end;

procedure TFindForm.cbColumnsClick(Sender: TObject);
begin
  SetControls;
end;

end.
