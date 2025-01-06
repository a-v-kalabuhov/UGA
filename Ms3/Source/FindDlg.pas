unit FindDlg;

interface

uses
  SysUtils, WinTypes, WinProcs, Messages, Classes, Graphics, Controls,
  StdCtrls, ExtCtrls, Forms, Buttons, DBGrids, IBQuery, Db, IBCustomDataSet, IBDatabase, IBSQL,
  // shared
  uDB, uSQL, uGC;

type
  TFindForm = class(TForm)
    cbColumns: TComboBox;
    Label1: TLabel;
    edtExample: TEdit;
    Label2: TLabel;
    OkBtn: TButton;
    CancelBtn: TButton;
    cbIdentical: TCheckBox;
    cbCaseSensitive: TCheckBox;
    Transaction: TIBTransaction;
    ibqFields: TIBQuery;
    ibqTables: TIBQuery;
    ibsSelect: TIBSQL;
    procedure OkBtnClick(Sender: TObject);
    procedure cbColumnsClick(Sender: TObject);
  private
    CurGrid: TDBGrid;
    FieldType: TFieldType;
    procedure SetControls;
    function  SelectedField: TField;
  public
  end;

function ShowFindDlg(Grid: TDBGrid): boolean;

implementation

{$R *.DFM}

uses
  AProc6,
  uMStConsts;

procedure ResetQuery(Query: TIBQuery; NewSQL: TStrings; SavePosition: Boolean=False);
var
  CurActive: Boolean;
  OldSQL: TStrings;
  CurId: Integer;
begin
  CurId:=0;
  with Query do
  begin
    if SavePosition then
      CurId := Query.GetId();
    CurActive := Active;
    DisableControls;
    Active := False;
    OldSQL := TStringList.Create;
    try
      try
        OldSQL.Assign(SQL);
        SQL.Assign(NewSQL);
        Active := CurActive;
      except
        on E: Exception do
        begin
          SQL.Assign(OldSQL);
          Active := CurActive;
          raise;
        end;
      end;
      Query.LocateId(CurId);
    finally
      OldSQL.Free;
      EnableControls;
    end;
  end;
end;

function ShowFindDlg(Grid: TDBGrid): Boolean;
var
  Query: TIBQuery;
  FindOptions: TFindOptions;
  NewSQL: TStrings;
  Fld: TField;
  I: Integer;
  TheSql: ISQL;
begin
  Result := False;
  if not Assigned(Grid) then
    Exit;
  with TFindForm.Create(Application) do
  try
    CurGrid := Grid;
    //
    for I := 0 to Grid.Columns.Count - 1 do
      cbColumns.AddItem(Grid.Columns[I].Title.Caption, Grid.Columns[I].Field);
    cbColumns.ItemIndex := 0;
    SetControls;
    //
    Result := ShowModal = mrOk;
    //
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
      TheSQL := TSQLFactory.CreateNew(NewSQL);
      NewSQL.Assign(Query.SQL);
      Fld := TField(cbColumns.Items.Objects[cbColumns.ItemIndex]);
      TheSQL.AddWhereByField(Fld, edtExample.Text, FindOptions);
      ResetQuery(Query, NewSQL);
    end;
  finally
    Free;
  end;
end;

function TFindForm.SelectedField: TField;
begin
  Result := TField(cbColumns.Items.Objects[cbColumns.ItemIndex]);
end;

procedure TFindForm.SetControls;
begin
  FieldType := CurGrid.Columns[cbColumns.ItemIndex].Field.DataType;
//  cbIdentical.Checked := False;
//  cbIdentical.Enabled := (FieldType in StringTypes + MemoTypes);
//  cbCaseSensitive.Checked := (FieldType in MemoTypes);
//  cbCaseSensitive.Enabled := (FieldType in StringTypes);
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
  Fld: TField;
begin
  Fld := SelectedField;
  if not (Fld.FieldKind in [fkData, fkLookup, fkInternalCalc]) then
    raise Exception.Create('');
  aFieldType := Fld.DataType;
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

procedure TFindForm.cbColumnsClick(Sender: TObject);
begin
  SetControls;
end;

end.
