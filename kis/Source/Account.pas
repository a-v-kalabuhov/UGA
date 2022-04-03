unit Account;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Variants, ComCtrls, ExtCtrls,
  StdCtrls, DBCtrls, Mask, DB, Grids, DBGrids, Buttons, IBCustomDataSet, IBQuery, IBSQL, IBUpdateSQL,
  // jedi
  JvFormPlacement, JvComponentBase,
  // shared
  uDB, uGC;

type
  TAccountForm = class(TForm)
    btnOk: TButton;
    btnCancel: TButton;
    PageControl: TPageControl;
    tshCommon: TTabSheet;
    tshWorks: TTabSheet;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label10: TLabel;
    dbeDocNumber: TDBEdit;
    dbeDocDate: TDBEdit;
    dbeOrderNumber: TDBEdit;
    dbeOrderDate: TDBEdit;
    dblcbOfficesName: TDBLookupComboBox;
    gbFirmName: TGroupBox;
    btnFirmClear: TButton;
    btnFirmDetail: TButton;
    btnFirmSelect: TButton;
    dbeFirmName: TDBEdit;
    dbgWorks: TDBGrid;
    btnWorkAdd: TSpeedButton;
    btnWorkDel: TSpeedButton;
    btnWorkEdit: TSpeedButton;
    dbeNDS: TDBEdit;
    Label5: TLabel;
    dbcbChecked: TDBCheckBox;
    ibsGetNSP: TIBSQL;
    Label17: TLabel;
    dbeExecutor: TDBEdit;
    Label16: TLabel;
    dbeTicket: TDBEdit;
    Label18: TLabel;
    dbePayDate: TDBEdit;
    dbmWorkTypesName: TDBMemo;
    Label6: TLabel;
    dbeAddress: TDBEdit;
    Label9: TLabel;
    dbmProperties: TDBMemo;
    Label7: TLabel;
    dbePhones: TDBEdit;
    Label8: TLabel;
    dbeINN: TDBEdit;
    Label19: TLabel;
    dbeActDate: TDBEdit;
    Label20: TLabel;
    dbeContractNumber: TDBEdit;
    pnlSum: TPanel;
    Label11: TLabel;
    Label12: TLabel;
    Label14: TLabel;
    dbtSumNds: TDBText;
    dbtSumma: TDBText;
    dbtSumAllNds: TDBText;
    Label21: TLabel;
    dbeObjectAddress: TDBEdit;
    Label22: TLabel;
    dbeCustomer: TDBEdit;
    Label24: TLabel;
    dbeValPeriod: TDBEdit;
    Label25: TLabel;
    Label26: TLabel;
    dbeArgument: TDBEdit;
    Label27: TLabel;
    dbeInformation: TDBEdit;
    dbcbMarkExecutor: TDBCheckBox;
    dbeSumBase: TDBEdit;
    Label28: TLabel;
    DBCheckBox1: TDBCheckBox;
    FormStorage1: TJvFormStorage;
    btnPrint: TButton;
    ibqPeople: TIBQuery;
    dsPeople: TDataSource;
    dblcbExecutor: TDBLookupComboBox;
    Label29: TLabel;
    dbeKPP: TDBEdit;
    Label13: TLabel;
    dbtSumNsp: TDBText;
    Label15: TLabel;
    procedure btnOkClick(Sender: TObject);
    procedure btnFirmClearClick(Sender: TObject);
    procedure btnFirmDetailClick(Sender: TObject);
    procedure btnFirmSelectClick(Sender: TObject);
    procedure btnWorkAddClick(Sender: TObject);
    procedure btnWorkDelClick(Sender: TObject);
    procedure btnWorkEditClick(Sender: TObject);
    procedure dbeNDSExit(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure btnPrintClick(Sender: TObject);
    procedure ibqPeopleAfterOpen(DataSet: TDataSet);
  private
    Query, QueryDet: TDataSet;
    Fnew: Boolean;
    procedure SetControls;
    procedure InitIBX;
  public
    procedure ModifyRecord;
  end;

var
  AccountForm: TAccountForm;

function ShowAccount(New: Boolean): Boolean;

implementation

uses
  // FastReport 2
  FR_Class, FR_IBXQuery,
  // Project
  Accounts, WorkTypes, uKisConsts, uKisMainView, AProc6, uKisIntf,
  uKisPrintModule, uKisAppModule, uKisClasses, uKisSQLClasses, uKisFirms,
  uKisEntityEditor;

{$R *.DFM}

function ShowAccount(New: Boolean): Boolean;
var
  Old: Boolean;
begin
  AccountForm := TAccountForm.Create(Application);
  with AccountForm do
  try
    FNew := New;
    PageControl.ActivePageIndex := 0;
    Query := dblcbOfficesName.DataSource.DataSet;
    Query.SoftEdit();
    QueryDet := AccountsForm.QueryDet;
    dblcbOfficesName.Enabled := AppModule.User.IsAdministrator;
    SetControls;
    ibqPeople.Open;
    ibqPeople.FetchAll;
    if not Fnew then
    begin
      Old := Query.FieldByName(SF_DOC_DATE).AsDateTime < EncodeDate(2004, 1, 1);
      Label15.Visible := Old;
      if Old then
        Label15.Caption := 'НСП ' + Query.FieldByName(SF_NSP).AsString + '%';
      Label13.Visible := Old;
      dbtSumNsp.Visible := Old;
      if Old then
        Label14.Caption := 'Всего с НДС и НСП'
      else
        Label14.Caption := 'Всего с НДС';
    end;
    Result := ShowModal = mrOk;
  finally
    FreeAndNil(AccountForm);
  end;
end;

procedure TAccountForm.btnOkClick(Sender: TObject);
begin
  try
    if dblcbExecutor.Visible then
    begin
      if Query.FieldByName(SF_PEOPLE_ID).IsNull then
      begin
        MessageBox(Handle, PChar(S_PLEASE_FILL_FIELD + ' "Исполнитель"!'), PChar(S_Warn), MB_ICONWARNING);
        dblcbExecutor.SetFocus;
        exit;
      end;
      Query.SoftEdit();
      Query.FieldByName(SF_EXECUTOR).AsString := dblcbExecutor.Text;
    end;
    ibqPeople.Close;
  finally
  end;
  Query.SoftPost();
  QueryDet.SoftPost();
  ModalResult := mrOk;
end;

procedure TAccountForm.SetControls;
var
  s: String;
  b: Boolean;
begin
  dbeFirmName.ReadOnly := not Query.FieldByName(SF_FIRMS_ID).IsNull;
  s := AppModule.User.RoleName;
  btnPrint.Enabled := False;
  b := (not FNew);
  if b then
    b := Query.FieldByName(SF_PEOPLE_ID).IsNull;
  dbeExecutor.Visible := b;
  dblcbExecutor.Visible := not dbeExecutor.Visible;
end;

procedure TAccountForm.btnFirmClearClick(Sender: TObject);
begin
  Query.SoftEdit();
  Query.FieldByName(SF_FIRMS_ID).Clear;
  Query.FieldByName(SF_FIRM_NAME).Clear;
  SetControls;
end;

procedure TAccountForm.btnFirmDetailClick(Sender: TObject);
var
  aId: Integer;
  Ent: TKisEntity;
begin
  aId := Query.FieldByName(SF_FIRMS_ID).AsInteger;
  Ent := AppModule[kmFirms].GetEntity(aId);
  if Assigned(Ent) then
  with TKisVisualEntity(Ent) do
  begin
    Forget();
    ReadOnly := True;
    Edit;
  end;
end;

procedure TAccountForm.btnFirmSelectClick(Sender: TObject);
var
  Firm: TKisFirm;
  aId: Integer;
begin
  aId := Query.FieldByName(SF_FIRMS_ID).AsInteger;
  Firm := AppModule.SQLMngrs[kmFirms].SelectEntity(True, nil, False, aId) as TKisFirm;
  if Assigned(Firm) then
  begin
    Firm.Forget();
    if not (Query.State in [dsEdit, dsInsert]) then
      Query.Edit;
    Query.FieldByName(SF_FIRMS_ID).AsInteger := Firm.ID;
    Query.FieldByName(SF_FIRM_NAME).AsString := Firm.Name;
    Query.FieldByName(SF_INN).AsString := Firm.INN;
    Query.FieldByName(SF_KPP).AsString := Firm.KPP;
    Query.FieldByName(SF_PHONES).AsString := Firm.Phones;
    Query.FieldByName(SF_ADDRESS).AsString := Firm.Address;
    Query.FieldByName(SF_PROPERTIES).AsString := Firm.Bank;
  end;
  SetControls;
end;

procedure TAccountForm.ModifyRecord;
var
  WorkId: Integer;
  WorkName, WorkArgument, WorkCode, ObjectAddress: String;
  WorkPrice: Double;
  q: TIBQuery;
begin
  if QueryDet.Bof and QueryDet.Eof then Exit;
  WorkId := QueryDet.FieldByName(SF_WORK_TYPES_ID).AsInteger;
  ObjectAddress := Trim(Query.FieldByName(SF_OBJECT_ADDRESS).AsString);
  if ObjectAddress<>'' then ObjectAddress := ' ' + ObjectAddress;
  if ShowWorkTypes(WorkId, WorkName, WorkArgument, WorkCode, WorkPrice) then
  begin
    QueryDet.SoftEdit();
    //
    q := TIBQuery.Create(Self);
    q.Forget();
    q.Database := AppModule.Database;
    q.Transaction := AccountsForm.Transaction;
    q.BufferChunks := 50;
    q.SQL.Add('SELECT WORK_TYPES_ID from ACCOUNTS_DET');
    q.SQL.Add('WHERE ACCOUNTS_ID=:ID1 and WORK_TYPES_ID=:ID2');
    q.Params[N_ZERO].AsInteger := AccountsForm.Query.FieldByName(SF_ID).AsInteger;
    q.Params[N_ONE].AsInteger := WorkId;
    q.Open;
    if not q.IsEmpty then
    begin
      MessageBox(Handle, PChar(S_WORKTYPE_ALREADY_EXISTS), PChar(S_Warn), MB_ICONSTOP);
      QueryDet.SoftCancel();
    end
    else
    begin
      QueryDet.FieldByName(SF_WORK_TYPES_ID).AsInteger:=WorkId;
      QueryDet.FieldByName(SF_WORK_TYPE_CODE).AsString:=WorkCode;
      QueryDet.FieldByName(SF_WORK_TYPES_NAME).AsString:=WorkName+ObjectAddress;
      QueryDet.FieldByName(SF_ARGUMENT).AsString:=WorkArgument;
      if WorkPrice > N_ZERO then QueryDet.FieldByName(SF_PRICE).AsFloat:=WorkPrice;
    end;
    q.Close;
  end
  else
    QueryDet.SoftCancel();
end;

procedure TAccountForm.btnWorkAddClick(Sender: TObject);
begin
  QueryDet.Append;
end;

procedure TAccountForm.btnWorkDelClick(Sender: TObject);
begin
  if not(QueryDet.Bof and QueryDet.Eof) then QueryDet.Delete;
end;

procedure TAccountForm.btnWorkEditClick(Sender: TObject);
begin
  ModifyRecord;
end;

procedure TAccountForm.dbeNDSExit(Sender: TObject);
begin
  Query.Refresh;
end;

procedure TAccountForm.InitIBX;
begin
  ibsGetNSP.Transaction := AccountsForm.Transaction;
  ibqPeople.Transaction := AccountsForm.Transaction;
end;

procedure TAccountForm.FormCreate(Sender: TObject);
begin
  InitIBX;
end;

procedure TAccountForm.btnPrintClick(Sender: TObject);
var
  Phone: String;
  V: Variant;
begin
  with PrintModule(True) do
  begin
    ReportTitle := 'Запрос в кадастровую палату';
    ReportFile := AppModule.ReportsPath + 'Письмо_КП.frf';
    SetParamValue('ObjectAddress',
      QuotedStr(Query.FieldByName(SF_OBJECT_ADDRESS).AsString));
    SetParamValue('PeopleName',
      QuotedStr(Query.FieldByName(SF_EXECUTOR).AsString));
     if AppModule.GetFieldValue(ibqPeople.Transaction, SF_OFFICES, SF_ID, SF_PHONES, Query.FieldByName(SF_OFFICES_ID).AsVariant, v) then
      Phone := V
    else
      Phone := '_____'; 
    SetParamValue('Phone', QuotedStr(Phone));
    SetParamValue('OrderNumber', Query.FieldByName(SF_ORDER_NUMBER).AsString);
    SetParamValue('OrderDate', Query.FieldByName(SF_ORDER_DATE).AsString);
    SetParamValue('AccountNumber', Query.FieldByName(SF_DOC_NUMBER).AsString);
    SetParamValue('AccountDate', Query.FieldByName(SF_DOC_DATE).AsString);
    PrintReport;
  end;
end;

procedure TAccountForm.ibqPeopleAfterOpen(DataSet: TDataSet);
begin
  ibqPeople.ParamByName(SF_PEOPLE_ID).Value := Query.FieldByName(SF_PEOPLE_ID).Value;
end;

end.


