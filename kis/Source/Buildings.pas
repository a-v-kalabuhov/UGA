unit Buildings;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, 
  Db, IBCustomDataSet, IBQuery, Ibdatabase, StdCtrls, Grids, DBGrids,
  IBUpdateSQL, Buttons, ComCtrls, IBSQL,
  //
  uGC;

type
  TBuildingsForm = class(TForm)
    Query: TIBQuery;
    DataSource: TDataSource;
    edtFind: TEdit;
    btnOk: TButton;
    btnCancel: TButton;
    Grid: TDBGrid;
    UpdateSQL: TIBUpdateSQL;
    btnAdd: TSpeedButton;
    btnDelete: TSpeedButton;
    Label1: TLabel;
    StatusBar1: TStatusBar;
    btnSave: TButton;
    btnDontAdd: TButton;
    QuerySTREETS_ID: TIntegerField;
    QueryMARKING_ID: TIntegerField;
    ibqMarking: TIBQuery;
    QueryMARKING_NAME: TStringField;
    ibqMarkingID: TIntegerField;
    ibqMarkingSHORT_NAME: TIBStringField;
    ibqMarkingNAME: TIBStringField;
    QuerySHORT_NAME: TIBStringField;
    Transaction: TIBTransaction;
    QueryID: TIntegerField;
    QueryNAME: TIBStringField;
    procedure btnAddClick(Sender: TObject);
    procedure btnDeleteClick(Sender: TObject);
    procedure QueryBeforeDelete(DataSet: TDataSet);
    procedure edtFindChange(Sender: TObject);
    procedure QueryAfterInsert(DataSet: TDataSet);
    procedure GridKeyPress(Sender: TObject; var Key: Char);
    procedure QueryAfterPost(DataSet: TDataSet);
    procedure btnDontAddClick(Sender: TObject);
    procedure QueryBeforeInsert(DataSet: TDataSet);
    procedure FormShow(Sender: TObject);
    procedure btnSaveClick(Sender: TObject);
  private
    StreetsId: Integer;
    procedure SetControls(Dop: Boolean);
  public
    { Public declarations }
  end;

function ShowBuildings(StreetId: Integer; var BuildingId: Integer;
  var BuildingName, MarkName: String; Select: Boolean = False): Boolean;

implementation

{$R *.DFM}

uses
  uKisConsts;

function ShowBuildings(StreetId: Integer; var BuildingId: Integer;
  var BuildingName, MarkName: String; Select: Boolean = False): Boolean;
var
  S: String;
begin
  with TBuildingsForm.Create(Application) do
  try
    StreetsId := StreetId;
    btnOk.Visible := Select;
    btnCancel.Visible := Select;
    btnAdd.Enabled := Select;
    btnDelete.Enabled := Select;
    Transaction.StartTransaction;
    with Query do
    begin
      ParamByName(SF_STREETS_ID).AsInteger := StreetId;
      Open;
    end;
    ibqMarking.Open;
    S := Trim(BuildingName);
    if Length(S) > 0 then
    if not Query.Locate(SF_NAME, S, [loCaseInsensitive]) then
      MessageBox(0, PChar(S_BUILDING_NOT_FOUND + S), PChar(S_Error), MB_ICONSTOP);
    Result := ShowModal = mrOk;
    if Result then
    begin
      BuildingId := Query.FieldByName(SF_ID).AsInteger;
      BuildingName := Query.FieldByName(SF_NAME).AsString;
      MarkName := Query.FieldByName(SF_SHORT_NAME).AsString;
      if Transaction.Active then Transaction.Commit;
    end;
  finally
    if Transaction.Active then Transaction.Rollback;
    Free;
  end;
end;

procedure TBuildingsForm.btnAddClick(Sender: TObject);
begin
  Query.Append;
  Grid.SetFocus;
  edtFind.Enabled := False;
  Grid.Options := Grid.Options + [dgEditing];
end;

procedure TBuildingsForm.btnDeleteClick(Sender: TObject);
begin
  Query.Delete;
  Grid.SetFocus;
end;

procedure TBuildingsForm.QueryBeforeDelete(DataSet: TDataSet);
begin
  if MessageBox(0, PChar(S_CONFIRM_DELETE_RECORD), PChar(S_CONFIRM), MB_ICONQUESTION+MB_OKCANCEL)<>IDOK then Abort;
end;

procedure TBuildingsForm.edtFindChange(Sender: TObject);
begin
  Query.Locate(SF_NAME,edtFind.Text,[loCaseInsensitive, loPartialKey]);
end;

procedure TBuildingsForm.QueryAfterInsert(DataSet: TDataSet);
begin
  Query.FieldByName(SF_STREETS_ID).AsInteger := StreetsId;
end;

procedure TBuildingsForm.GridKeyPress(Sender: TObject; var Key: Char);
begin
  case Key of
  #13 : begin
          if btnSave.Enabled then
          if Query.FieldByName(SF_MARKING_ID).IsNull then
            Grid.SelectedIndex := 1
          else
          if Query.FieldByName(SF_NAME).IsNull then
            Grid.SelectedIndex := 0
          else
            Query.Post;
        end;
  end;
end;

procedure TBuildingsForm.SetControls(Dop: Boolean);
begin
  btnAdd.Enabled := not Dop;
  btnDelete.Enabled := not Dop;
  btnOK.Enabled := not Dop;
  btnCancel.Enabled := not Dop;
  btnSave.Enabled := Dop;
  btnDontAdd.Enabled := Dop;
end;

procedure TBuildingsForm.QueryAfterPost(DataSet: TDataSet);
begin
  SetControls(False);
  StatusBar1.SimpleText := '';
end;

procedure TBuildingsForm.btnDontAddClick(Sender: TObject);
begin
  Query.Cancel;
end;

procedure TBuildingsForm.QueryBeforeInsert(DataSet: TDataSet);
begin
  SetControls(True);
  StatusBar1.SimpleText := S_SAVE_ENTER_KEY;
end;

procedure TBuildingsForm.FormShow(Sender: TObject);
var
  q: TIBQuery;
begin
  SetControls(False);

  StatusBar1.SimpleText := '';
  q := TIBQuery.Create(Self);
  q.Forget();
  q.Transaction := Query.Transaction;
  q.BufferChunks := 10;
  q.SQL.Add('SELECT A.NAME, B.SHORT_NAME FROM STREETS A, STREET_MARKING B');
  q.SQL.Add('WHERE A.STREET_MARKING_ID=B.ID AND A.ID=:ID');
  q.Params[0].AsInteger := Query.Params[0].AsInteger;
  q.Open;
  StatusBar1.SimpleText := q.Fields[1].AsString + ' ' + q.Fields[0].AsString;
  q.Active := False;
end;

procedure TBuildingsForm.btnSaveClick(Sender: TObject);
begin
  try
    if QueryMARKING_ID.AsString = '' then
    begin
      MessageBox(Handle, PChar('Укажите тип строения!'), PChar(S_WARN), MB_OK + MB_ICONWARNING);
      Grid.SetFocus;
      Exit;
    end;
    Query.Post;
    Transaction.CommitRetaining;
  finally
    edtFind.Enabled := True;
    Grid.Options := Grid.Options - [dgEditing];
  end;
end;

end.
