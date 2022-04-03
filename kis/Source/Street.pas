unit Street;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, StrUtils,
  StdCtrls, Mask, DBCtrls, DB, IBCustomDataSet, IBQuery, IBDatabase,
  // shaerd
  uDB, AProc6, uGC,
  // kis
  uKisConsts, uKisIntf;

type
  TStreetForm = class(TForm)
    btnOk: TButton;
    btnCancel: TButton;
    dbeName: TDBEdit;
    dbeNameOld: TDBEdit;
    dbeRegionsName: TDBLookupComboBox;
    dbeVillagesName: TDBLookupComboBox;
    dbeKillState: TDBEdit;
    dbmAbout: TDBMemo;
    dbeError: TDBEdit;
    dbcbUga: TDBCheckBox;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    gbCreateDoc: TGroupBox;
    edtCreateDoc: TEdit;
    btnCreateSelect: TButton;
    btnCreateDetail: TButton;
    btnCreateClear: TButton;
    gbKillDoc: TGroupBox;
    edtKillDoc: TEdit;
    btnKillSelect: TButton;
    btnKillClear: TButton;
    btnKillDetail: TButton;
    ibqDecrees: TIBQuery;
    btnBuildings: TButton;
    Label8: TLabel;
    dbeMarking: TDBLookupComboBox;
    ibqMarking: TIBQuery;
    ibqVillages: TIBQuery;
    ibqRegions: TIBQuery;
    dsRegions: TDataSource;
    dsVillages: TDataSource;
    dsMarking: TDataSource;
    procedure btnOkClick(Sender: TObject);
    procedure btnCreateClearClick(Sender: TObject);
    procedure btnKillClearClick(Sender: TObject);
    procedure btnCreateDetailClick(Sender: TObject);
    procedure btnKillDetailClick(Sender: TObject);
    procedure btnCreateSelectClick(Sender: TObject);
    procedure btnKillSelectClick(Sender: TObject);
    procedure btnBuildingsClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
  private
    Query: TIBQuery;
    procedure SetDocs;
  end;

function ShowStreet(Transaction: TIBTransaction): Boolean;

implementation

{$R *.DFM}

uses
  Streets, Decree, Decrees, Buildings;

function ShowStreet(Transaction: TIBTransaction): Boolean;
begin
  with TStreetForm.Create(Application) do
  try
    Query := TIBQuery(dbeName.DataSource.DataSet);
    ibqDecrees.Transaction := Transaction;
    SetDocs;
    Result := ShowModal = mrOk;
  finally
    Release;
  end;
end;

procedure TStreetForm.btnOkClick(Sender: TObject);
begin
  if Trim(Query.FieldByName(SF_NAME).AsString) = '' then
  begin
    MessageBox(Handle, PChar(S_PLEASE_FILL_FIELD + ' "Наименование" !'), PChar(S_WARN), MB_ICONWARNING);
    dbeName.SetFocus;
  end
  else
  if Query.FieldByName(SF_STREET_MARKING_ID).AsInteger = 0 then
  begin
    MessageBox(Handle, PChar(S_PLEASE_FILL_FIELD + ' "Тип" !'), PChar(S_WARN), MB_ICONWARNING);
    dbeMarking.SetFocus;
  end
  else
  begin
    Query.SoftPost();
    ModalResult := mrOk;
  end;
end;

procedure TStreetForm.btnCreateClearClick(Sender: TObject);
begin
  Query.SoftEdit();
  Query.FieldByName(SF_CREATE_DOC_ID).Clear;
  SetDocs;
end;

procedure TStreetForm.btnKillClearClick(Sender: TObject);
begin
  Query.SoftEdit();
  Query.FieldByName(SF_KILL_DOC_ID).Clear;
  SetDocs;
end;

procedure TStreetForm.SetDocs;
begin
  with Query do
  begin
    btnCreateDetail.Enabled := not FieldByName(SF_CREATE_DOC_ID).IsNull;
    btnKillDetail.Enabled := not FieldByName(SF_KILL_DOC_ID).IsNull;
    btnCreateClear.Enabled := not FieldByName(SF_CREATE_DOC_ID).IsNull;
    btnKillClear.Enabled := not FieldByName(SF_KILL_DOC_ID).IsNull;
    edtCreateDoc.Text := IfThen(FieldByName(SF_CREATE_DOC_ID).IsNull,'',
      Query.FieldByName(SF_CREATE_TYPE).AsString + ' №'
      + Query.FieldByName(SF_CREATE_NUMBER).AsString
      + ' от ' + Query.FieldByName(SF_CREATE_DATE).AsString);
    edtKillDoc.Text := IfThen(FieldByName(SF_KILL_DOC_ID).IsNull, '',
      Query.FieldByName(SF_KILL_TYPE).AsString + ' №'
      + Query.FieldByName(SF_KILL_NUMBER).AsString
      + ' от ' + Query.FieldByName(SF_KILL_DATE).AsString);
  end;
end;

procedure TStreetForm.btnCreateDetailClick(Sender: TObject);
begin
  ibqDecrees.ParamByName(SF_ID).Value:=Query.FieldByName(SF_CREATE_DOC_ID).Value;
  ibqDecrees.Open;
  try
    ShowDecree(ibqDecrees,True);
  finally
    ibqDecrees.Close;
  end;
end;

procedure TStreetForm.btnKillDetailClick(Sender: TObject);
begin
  ibqDecrees.ParamByName(SF_ID).Value:=Query.FieldByName(SF_KILL_DOC_ID).Value;
  ibqDecrees.Open;
  try
    ShowDecree(ibqDecrees,True);
  finally
    ibqDecrees.Close;
  end;
end;

procedure TStreetForm.btnCreateSelectClick(Sender: TObject);
var
  DecreeId: Integer;
begin
  with Query do
  begin
    DecreeId := FieldByName(SF_CREATE_DOC_ID).AsInteger;
    if SelectDecree(DecreeId) then
    begin
      SoftEdit();
      FieldByName(SF_CREATE_DOC_ID).AsInteger := DecreeId;
      Refresh;
      SetDocs;
    end;
  end;
end;

procedure TStreetForm.btnKillSelectClick(Sender: TObject);
var
  DecreeId: Integer;
begin
  with Query do
  begin
    DecreeId := FieldByName(SF_KILL_DOC_ID).AsInteger;
    if SelectDecree(DecreeId) then
    begin
      SoftEdit();
      FieldByName(SF_KILL_DOC_ID).AsInteger := DecreeId;
      Refresh;
      SetDocs;
    end;
  end;
end;

procedure TStreetForm.btnBuildingsClick(Sender: TObject);
var
  Name1, Name2: String;
  Id: Integer;
begin
  ShowBuildings(Query.FieldByName(SF_ID).AsInteger, Id, Name1, Name2, True);
end;

procedure TStreetForm.FormCreate(Sender: TObject);
begin
  ibqRegions.Open;
  ibqRegions.FetchAll;
  ibqVillages.Open;
  ibqVillages.FetchAll;
  ibqMarking.Open;
  ibqMarking.FetchAll;
end;

procedure TStreetForm.FormClose(Sender: TObject; var Action: TCloseAction);
var
  aQuery: TIBQuery;
begin
  Query.SoftEdit();
  aQuery := TIBQuery.Create(nil);
  aQuery.Forget;
  with aQuery do
  begin
    Transaction := Query.Transaction;
    BufferChunks := 10;
    SQL.Text := 'SELECT SHORT_NAME FROM STREET_MARKING WHERE ID='
      + Query.FieldByNAme(SF_STREET_MARKING_ID).AsString;
    Open;
    Query.FieldByName(SF_STREET_MARKING_NAME).AsString := Fields[0].AsString;
    Close;
  end;
end;

end.
