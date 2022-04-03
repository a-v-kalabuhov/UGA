unit Decrees;

interface

{$I KisFlags.pas}

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, ImgList, Grids, DBGrids, ComCtrls, ToolWin,
  IBCHILD, Db, IBCustomDataSet, IBQuery, IBUpdateSQL, IBDatabase, StdCtrls, DBCtrls, ExtCtrls, IBSQL, Dialogs,
  Menus, DBActns, ActnList,
  // jedi
  JvComponentBase, JvFormPlacement,
  // kis components
  uDBGrid, uLegend, uSplitter,
  // shared
  uDB;

type
  TDecreesForm = class(TIBChildForm)
    Splitter: TSplitter;
    dbmHeader: TDBMemo;
    ibqDecreeTypes: TIBQuery;
    SaveDialog: TSaveDialog;
    QueryID: TIntegerField;
    QueryDOC_NUMBER: TIBStringField;
    QueryDOC_DATE: TDateTimeField;
    QueryINT_NUMBER: TIBStringField;
    QueryINT_DATE: TDateTimeField;
    QueryHEADER: TIBStringField;
    QueryCHECKED: TSmallintField;
    QueryCONTENT: TMemoField;
    QueryYEAR_NUMBER: TIBStringField;
    ToolButton1: TToolButton;
    ToolButton2: TToolButton;
    ToolButton3: TToolButton;
    pnlOkCancel: TPanel;
    btnOk: TButton;
    btnCancel: TButton;
    QueryDECREE_TYPES_ID: TIntegerField;
    QueryDECREE_TYPES_NAME: TStringField;
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure GridDrawColumnCell(Sender: TObject; const Rect: TRect;
      DataCol: Integer; Column: TColumn; State: TGridDrawState);
    procedure actShowExecute(Sender: TObject);
    procedure QueryAfterInsert(DataSet: TDataSet);
    procedure actImportExecute(Sender: TObject);
    procedure actExportExecute(Sender: TObject);
    procedure QueryAfterScroll(DataSet: TDataSet);
    procedure actFindExecute(Sender: TObject);
  private
    procedure ModifyRecord;
  end;

var
  DecreesForm: TDecreesForm;
  Decree_ID: Integer;

function SelectDecree(var Id: Integer): Boolean;

implementation

uses
  Decree, DecImprt, AProc6, uKisAppModule, uKisConsts, uKisClasses;

{$R *.DFM}

function SelectDecree(var Id: Integer): Boolean;
begin
  with TDecreesForm.Create(Application) do
  try
    pnlOkCancel.Visible := True;
    FStartSQL.Assign(Query.SQL);
    Query.Open;
    Query.FetchAll;
    if Id > 0 then
    if not Query.Locate(SF_ID, Id, []) then
      MessageBox(0, PChar(S_RECORD_NOT_FOUND), PChar(S_WARN), MB_ICONWARNING);
    Result := (ShowModal = mrOk);
    if Result then
      Id := Decree_ID;
  finally
    Free;
  end;
end;

procedure TDecreesForm.FormCreate(Sender: TObject);
begin
  inherited;
  Transaction.DefaultDatabase := AppModule.Database;
  AutoCommitAfterPost := False;
  ibqDecreeTypes.Open;
  ibqDecreeTypes.FetchAll;
end;

procedure TDecreesForm.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  inherited;
  DecreesForm:=nil;
end;

procedure TDecreesForm.GridDrawColumnCell(Sender: TObject;
  const Rect: TRect; DataCol: Integer; Column: TColumn; State: TGridDrawState);
var
  Selected: Boolean;
begin
  inherited;
  Selected:=(gdSelected in State);
  if not Selected and (Query.FieldByName(SF_CHECKED).AsInteger=0) then
    Grid.Canvas.Brush.Color:=clInfoBk;
  Grid.DefaultDrawColumnCell(Rect,DataCol,Column,State);
  if Selected then
    Grid.Canvas.DrawFocusRect(Rect);
end;

procedure TDecreesForm.actShowExecute(Sender: TObject);
begin
  inherited;
  ModifyRecord;
end;

procedure TDecreesForm.QueryAfterInsert(DataSet: TDataSet);
begin
  inherited;
  Query.FieldByName(SF_CHECKED).Value:=0;
  ModifyRecord;
end;

procedure TDecreesForm.ModifyRecord;
begin
  if ShowDecree(Query) then
  begin
    Query.SoftPost();
    Transaction.CommitRetaining;
  end
  else
  begin
    Query.SoftCancel();
    Transaction.RollbackRetaining;
  end;
end;

procedure TDecreesForm.actImportExecute(Sender: TObject);
begin
 	DecreeImportShow(Query);
end;

procedure TDecreesForm.actExportExecute(Sender: TObject);
begin
	if SaveDialog.Execute then
	  try
		  SetHgCursor;
 			Query.FieldByName(SF_CONTENT).AsBlob.SaveToFile(SaveDialog.FileName);
	  finally
		  SetNormCursor;
	  end;
end;

procedure TDecreesForm.QueryAfterScroll(DataSet: TDataSet);
begin
  inherited;
  Decree_ID := Query.FieldByName(SF_ID).AsInteger;
end;

procedure TDecreesForm.actFindExecute(Sender: TObject);
{var
  I: Integer;}
begin
{  with SearchHelper do
  begin
    ClearTables;
    with AddTable do
    begin
      TableName := ST_DECREES;
      TableLabel := 'Основная (Постановления)';
      I := AddStringField(SF_DOC_NUMBER, 'Номер', 10);
      if SF_DOC_NUMBER = Grid.SelectedField.FieldName then
        SelectedField := I;
      I := AddSimpleField(SF_DOC_DATE, 'Дата', ftDatetime);
      if SF_DOC_DATE = Grid.SelectedField.FieldName then
        SelectedField := I;
      I := AddStringField(SF_INT_NUMBER, 'Вх. номер', 10);
      if SF_INT_NUMBER = Grid.SelectedField.FieldName then
        SelectedField := I;
      I := AddSimpleField(SF_INT_DATE, 'Вх. дата', ftDateTime);
      if SF_INT_DATE = Grid.SelectedField.FieldName then
        SelectedField := I;
      I := AddStringField(SF_HEADER, 'Заголовок', 150);
      if SF_HEADER = Grid.SelectedField.FieldName then
        SelectedField := I;
      I := AddStringField(SF_CONTENT, 'Содержание', 250);
      if SF_CONTENT = Grid.SelectedField.FieldName then
        SelectedField := I;
      I := AddSimpleField(SF_CHECKED, 'Проверено', ftBoolean);
      if SF_CONTENT = Grid.SelectedField.FieldName then
        SelectedField := I;
      I := AddStringField(SF_YEAR_NUMBER, 'Год и номер', 17);
      if SF_CONTENT = Grid.SelectedField.FieldName then
        SelectedField := I;
    end;
    with AddTable do
    begin
      TableName := ST_DECREE_TYPES;
      TableLabel := 'Типы нормативных актов';
      AddStringField(SF_NAME, 'Наименование', 30);
    end;
    Query.SQL.Delimiter := #32;
    SQL := Query.SQL.DelimitedText;
  end;
  if SearchHelper.SearchDialog then
  begin
    InSearch := True;
    I := Query.FieldByName(SF_ID).AsInteger;
    Query.Active := False;
    Query.SQL.DelimitedText := SearchHelper.SQL;
    Query.Open;
    Query.Locate(SF_ID, I, []);
  end;
  SearchHelper.ClearTables;  }
  inherited;
end;

end.
