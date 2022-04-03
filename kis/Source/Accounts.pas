unit Accounts;

interface

{$I KisFlags.pas}

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Db,
  IBCustomDataSet, IBQuery, IBUpdateSQL, IBDatabase, Menus, ActnList, ImgList,
  Grids, DBGrids, ComCtrls, ToolWin, IBSQL, ExtCtrls, StdCtrls, ShDocVw, Variants,
  // jedi
  JvFormPlacement, JvComponentBase,
  // Common
  uDBGrid, uLegend,
  // shared
  uDB, uIBXUtils, uSQL,
  // Project
  IBCHILD, uKisClasses, uKisSQLClasses;

type
  TAccountsForm = class(TIBChildForm)
    ibqOffices: TIBQuery;
    QueryOFFICES_NAME: TStringField;
    QuerySUMMA_PROPIS: TIBStringField;
    QuerySUM_ALL_PROPIS: TIBStringField;
    QueryOFFICES_SHORT_NAME: TIBStringField;
    QueryOFFICES_PHONES: TIBStringField;
    QueryOFFICES_DIRECTOR: TIBStringField;
    QueryID: TIntegerField;
    QueryDOC_NUMBER: TIBStringField;
    QueryDOC_DATE: TDateField;
    QueryORDER_NUMBER: TIBStringField;
    QueryORDER_DATE: TDateField;
    QueryACT_DATE: TDateField;
    QueryCONTRACT_NUMBER: TIBStringField;
    QueryEXECUTOR: TIBStringField;
    QueryMARK_EXECUTOR: TSmallintField;
    QueryFIRMS_ID: TIntegerField;
    QueryFIRM_NAME: TIBStringField;
    QueryCUSTOMER: TIBStringField;
    QueryADDRESS: TIBStringField;
    QueryOBJECT_ADDRESS: TIBStringField;
    QueryPHONES: TIBStringField;
    QueryINN: TIBStringField;
    QueryPROPERTIES: TIBStringField;
    QueryBANK: TIBStringField;
    QueryVAL_PERIOD: TSmallintField;
    QueryOFFICES_ID: TIntegerField;
    QueryINFORMATION: TIBStringField;
    QueryNDS: TIBBCDField;
    QueryNSP: TIBBCDField;
    QueryCANCELLED: TSmallintField;
    QueryCHECKED: TSmallintField;
    QueryTICKET: TIBStringField;
    QueryPAY_DATE: TDateField;
    QuerySUMMA: TIBBCDField;
    QuerySUM_NDS: TIBBCDField;
    QuerySUM_NSP: TIBBCDField;
    QuerySUM_ALL_NDS: TIBBCDField;
    QuerySUM_ALL: TIBBCDField;
    QuerySUM_BASE: TIBBCDField;
    QueryPEOPLE_ID: TIntegerField;
    QueryKPP: TIBStringField;
    QueryIS_OLD: TSmallintField;
    QueryR_ACCOUNT: TIBStringField;
    QueryT_ACCOUNT: TStringField;
    QueryPAYER_ID: TIntegerField;
    QueryPAYER_NAME: TStringField;
    QueryPAYER_PHONE: TStringField;
    QueryPAYER_INN: TStringField;
    QueryPAYER_PROPERTIES: TStringField;
    QueryPAYER_CUSTOMER: TStringField;
    QueryPAYER_BANK: TStringField;
    QueryPAYER_KPP: TStringField;
    QueryPAYER_ADDRESS: TStringField;
    QueryPAYER_T_ACCOUNT: TStringField;
    QueryPAYER_R_ACCOUNT: TStringField;
    QueryOFFICES_DIRECTOR_L: TIBStringField;
    QueryOFFICES_DIRECTOR_R: TIBStringField;
    QueryCUSTOMER_BASE: TStringField;
    ToolButton1: TToolButton;
    BtnPrint: TToolButton;
    QueryDet: TIBQuery;
    ibusAccountsDet: TIBUpdateSQL;
    dsAccountsDet: TDataSource;
    mnuPrint: TPopupMenu;
    ibsOrderNumber: TIBSQL;
    ibsAccountsDetGetId: TIBSQL;
    itmReportsConfig: TMenuItem;
    ToolButton2: TToolButton;
    btnCopy: TToolButton;
    ibsWorkTypeCode: TIBSQL;
    pnlOkCancel: TPanel;
    btnOk: TButton;
    btnCancel: TButton;
    QueryPRINT_WORKS_VALUE: TSmallintField;
    ToolBar1: TToolBar;
    Label1: TLabel;
    cbDateFilter: TComboBox;
    QueryPrintedWorks: TIBQuery;
    ToolButton4: TToolButton;
    ToolButton6: TToolButton;
    QueryCLOSED: TSmallintField;
    tbOffice: TToolBar;
    Label5: TLabel;
    cbOffice: TComboBox;
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormDestroy(Sender: TObject);
    procedure actShowExecute(Sender: TObject);
    procedure QueryAfterInsert(DataSet: TDataSet);
    procedure QueryDetAfterInsert(DataSet: TDataSet);
    procedure QueryDetBeforeDelete(DataSet: TDataSet);
    procedure QueryDetAfterPost(DataSet: TDataSet);
    procedure QueryDetAfterDelete(DataSet: TDataSet);
    procedure btnCopyClick(Sender: TObject);
    procedure QueryDetBeforePost(DataSet: TDataSet);
    procedure QueryDetWORK_TYPES_IDChange(Sender: TField);
    procedure QueryDOC_DATEChange(Sender: TField);
    procedure QueryDetBeforeOpen(DataSet: TDataSet);
    procedure QueryAfterScroll(DataSet: TDataSet);
    procedure actDeleteExecute(Sender: TObject);
    procedure QuerySUM_ALL_PROPISGetText(Sender: TField; var Text: String;
      DisplayText: Boolean);
    procedure actInsertExecute(Sender: TObject);
    procedure cbDateFilterChange(Sender: TObject);
    procedure QueryAfterRefresh(DataSet: TDataSet);
    procedure pnlOkCancelResize(Sender: TObject);
    procedure btnOkClick(Sender: TObject);
    procedure ToolButton6Click(Sender: TObject);
    procedure actInsertUpdate(Sender: TObject);
    procedure GridDrawColumnCell(Sender: TObject; const Rect: TRect;
      DataCol: Integer; Column: TColumn; State: TGridDrawState);
    procedure QueryCLOSEDGetText(Sender: TField; var Text: string;
      DisplayText: Boolean);
    procedure GridCellColors(Sender: TObject; Field: TField; var Background,
      FontColor: TColor; State: TGridDrawState; var FontStyle: TFontStyles);
    procedure cbOfficeChange(Sender: TObject);
    procedure actFindExecute(Sender: TObject);
    procedure actUnFindExecute(Sender: TObject);
    private const
      SQ_GET_REPORTS = 'SELECT NAME, PATH||FILENAME FROM ALL_REPORTS WHERE REPORT_TYPES_ID=%d ORDER BY 1';
      SQ_COPY_ORDER = 'SELECT * FROM ACCOUNTS WHERE ID=%d';
      SQ_COPY_ORDER_POSITIONS = 'SELECT * FROM ACCOUNTS_DET WHERE ACCOUNTS_ID=%d';
      SQ_MAIN_SQL =
        'SELECT A.ID, '
      + 'A.DOC_NUMBER, '
      + 'A.DOC_DATE, '
      + 'A.ORDER_NUMBER, ' 
      + 'A.ORDER_DATE, ' 
      + 'A.ACT_DATE, ' 
      + 'A.CONTRACT_NUMBER, ' 
      + 'A.EXECUTOR, ' 
      + 'A.MARK_EXECUTOR, ' 
      + 'A.FIRMS_ID, ' 
      + 'A.FIRM_NAME, ' 
      + 'A.CUSTOMER, ' 
      + 'A.ADDRESS, ' 
      + 'A.OBJECT_ADDRESS, ' 
      + 'A.PHONES, ' 
      + 'A.INN, ' 
      + 'A.PROPERTIES, ' 
      + 'A.BANK, '
      + 'A.VAL_PERIOD, ' 
      + 'A.OFFICES_ID, ' 
      + 'A.INFORMATION, ' 
      + 'A.NDS, ' 
      + 'A.NSP, ' 
      + 'A.CANCELLED, ' 
      + 'A.CHECKED, ' 
      + 'A.TICKET, ' 
      + 'A.PAY_DATE, ' 
      + 'A.SUMMA, ' 
      + 'A.SUM_NDS, ' 
      + 'A.SUM_NSP, '
      + 'A.SUM_ALL_NDS, ' 
      + 'A.SUM_ALL, ' 
      + 'A.SUM_BASE, ' 
      + 'A.PEOPLE_ID, ' 
      + 'A.KPP, '
      + 'A.IS_OLD, '
      + 'A.R_ACCOUNT, '
      + 'A.T_ACCOUNT, '
      + 'A.PAYER_ID, '
      + 'A.PAYER_NAME, '
      + 'A.PAYER_PHONE, '
      + 'A.PAYER_INN, '
      + 'A.PAYER_PROPERTIES, '
      + 'A.PAYER_CUSTOMER, '
      + 'A.PAYER_BANK, '
      + 'A.PAYER_KPP, '
      + 'A.PAYER_ADDRESS, '
      + 'A.PAYER_R_ACCOUNT, ' 
      + 'A.PAYER_T_ACCOUNT, '
      + 'A.SUM_PROPIS AS SUMMA_PROPIS, '
      + 'A.SUM_ALL_PROPIS, '
      + 'B.NAME AS OFFICES_NAME, '
      + 'B.SHORT_NAME AS OFFICES_SHORT_NAME, '
      + 'B.PHONES AS OFFICES_PHONES, '
      + 'B.DIRECTOR AS OFFICES_DIRECTOR, '
      + 'B.DIRECTOR_L AS OFFICES_DIRECTOR_L, '
      + 'B.DIRECTOR_R AS OFFICES_DIRECTOR_R, '
      + 'A.CUSTOMER_BASE, '
      + 'A.PRINT_WORKS_VALUE, '
      + 'A.CLOSED '
      + 'FROM ORDERS_ALL A LEFT JOIN OFFICES B ON A.OFFICES_ID=B.ID';
  private
    FOfficeId, FOldOfficeId: Integer;
    FReports: TStrings;
    FEditAfterInsert: Boolean;
    FCurrentId: Integer;
    FNeedUpdateReports: Boolean;
    FSQLHelper: TKisSQLHelper;
    procedure CopyFromOldAccount(Entity: TKisEntity);
    procedure ModifyRecord(New: Boolean);
    procedure PrepareQueryDet;
    procedure PrepareSQLHelper;
    procedure PrintFastReport(const AReportName: String);
    procedure PrintMenuReport(Sender: TObject);
    procedure ReadReportMenu;
    procedure UpdateOfficeCombo;
    procedure UpdateReports;
  protected
    procedure ApplySQLFilters; override;
  public
    class function SelectAccount(var Id: Integer): Boolean;
    class procedure SelectAccountForPrint(var Id: Integer; ReportName: String);
  end;

var
  AccountsForm: TAccountsForm;

implementation

{$R *.dfm}

uses
  // Common
  AProc6, AString6, uGC,
  // Project
  uKisMainView, Account, uKisPrintModule, uKisAppModule, uKisConsts, uKisIntf,
  uKisOrders, uKisContragents, uKisUtils, uKisOffices,
  uKisSearchClasses;

class function TAccountsForm.SelectAccount(var Id: Integer): Boolean;
begin
  with TAccountsForm.Create(Application) do
    try
      Transaction.DefaultDatabase := AppModule.Database;
      pnlOkCancel.Visible := True;
      FStartSQL.Assign(Query.SQL);
      Query.Open;
      if Id > 0 then
        Query.Locate(SF_ID, Id, []);
      Result := (ShowModal = mrOk);
      Id := FCurrentId;
    finally
      Release;
    end;
end;

class procedure TAccountsForm.SelectAccountForPrint(var Id: Integer; ReportName: String);
var
  FView: TAccountsForm;
begin
  FView := TAccountsForm.Create(Application);
  with FView do
  begin
    btnDel.Enabled := False;
    btnShow.Enabled := False;
    btnCopy.Enabled := False;
    btnShow.Visible := False;
    ToolBar1.Visible := False;
    MainMenu.Items.Clear;
    try
      Transaction.DefaultDatabase := AppModule.Database;
      pnlOkCancel.Visible := True;
      FStartSQL.Assign(Query.SQL);
//      Query.Close;
      Query.Open;
      if Id > 0 then
        if Query.Locate(SF_ID, Id, []) then
          PrintFastReport(ReportName)
        else
          Application.MessageBox('Заказ не найден!', PChar(S_WARN), MB_OK + MB_ICONWARNING);
//      Result := (ShowModal = mrOk);
//      Id := FCurrentId;
    finally
      Release;
    end;
  end;
end;

procedure TAccountsForm.FormCreate(Sender: TObject);
var
  Y, M, D: Word;
begin
  inherited;
  FNeedUpdateReports := True;
  Transaction.DefaultDatabase := AppModule.Database;
  FReports := TStringList.Create;
  //
  FSQLHelper := TKisSQLHelper.Create(Self);
  PrepareSQLHelper;
  //
  AutocommitAfterPost := False;
  FEditAfterInsert := True;
  FOldOfficeId := -1;
  FOfficeId := AppModule.User.OfficeId;
  ibqOffices.Open;
  ibqOffices.FetchAll;
  ibsOrderNumber.Params.ByName(SF_OFFICES_ID).AsInteger := AppModule.User.OfficeId;
  ReadReportMenu;
  //
  cbDateFilter.Clear;
  cbDateFilter.Items.Add('Все заказы');
  //
  Decodedate(date, Y, M, D);
  Y:= Y - 1;
  if (M = 2) and (D = 29) then
    D := 28;
  cbDateFilter.Items.Add('Заказы за год (с ' + DateToStr(EncodeDate(Y, M, D)) + ')');
  cbDateFilter.ItemIndex := 1;
  //
  UpdateOfficeCombo;
  cbOffice.Enabled := AppModule.User.CanSeeAllOffices or AppModule.User.IsAdministrator;
end;

procedure TAccountsForm.FormDestroy(Sender: TObject);
begin
  FreeAndNil(FReports);
  inherited;
end;

procedure TAccountsForm.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  inherited;
  AccountsForm := nil;
end;

procedure TAccountsForm.ModifyRecord(New: Boolean);
var
  Order: TKisEntity;
  M: TKisSQLMngr;
  Ent2: TKisEntity;
//  Id, TopId, I: Integer;
begin
  if QueryIS_OLD.AsInteger = 1 then
  begin
    QueryDet.Close;
    QueryDet.Open;
    if ShowAccount(New) then
    begin
      Query.SoftPost();
      Transaction.CommitRetaining;
      Query.Refresh;
    end
    else
    begin
      Query.SoftCancel();
      Transaction.RollBackRetaining;
    end;
  end
  else
  begin
    M := AppModule.SQLMngrs[kmOrders];
    if New then
    begin
      M.DefaultTransaction := Self.Transaction;
      Order := M.CreateNewEntity;
      Order.Forget();
      TKisOrder(Order).PrintWorksValue := AppModule.User.PrintWorksValue;
      Ent2 := M.EditEntity(Order);
      if Assigned(Ent2) and Ent2.Modified then
      begin
        Ent2.Forget();
        try
          QueryID.AsInteger := Ent2.ID;
          QueryIS_OLD.AsInteger := 0;
          Query.Post;
          M.SaveEntity(Ent2);
          Self.Transaction.CommitRetaining;
          Query.Refresh;
        except
          Query.SoftCancel();
          if QueryID.AsInteger = Ent2.ID then
            Query.Delete;
          Self.Transaction.RollbackRetaining;
          raise;
        end;
      end
      else
      begin
        Query.Cancel;
        Self.Transaction.RollbackRetaining;
      end;
      M.DefaultTransaction := nil;
    end
    else
    begin
      M.DefaultTransaction := Self.Transaction;
      Order := M.GetEntity(QueryID.AsInteger);
      if Assigned(Order) then
      begin
        Order.Forget();
        TKisOrder(Order).ReadOnly := (AppModule.User.OfficeId <> TKisOrder(Order).OfficeId)
          and not AppModule.User.IsAdministrator;
        Ent2 := M.EditEntity(Order);
        if Assigned(Ent2) and Ent2.Modified then
        begin
          Ent2.Forget();
          M.SaveEntity(Ent2);
          Self.Transaction.CommitRetaining;
          Query.Refresh;
        end
        else
        begin
          Query.Cancel;
          Self.Transaction.RollbackRetaining;
        end;
      end;
      M.DefaultTransaction := nil;
    end;
    // Обновление данных
    Query.Refresh;
  end;
end;

procedure TAccountsForm.actShowExecute(Sender: TObject);
begin
  inherited;
  ModifyRecord(False);
end;

procedure TAccountsForm.actUnFindExecute(Sender: TObject);
var
  S: String;
begin
  if Assigned(FSQLHelper) then
  begin
    FSQLHelper.SQL := Query.SQL.Text;
    S := FSQLHelper.OrderByStr;
    FSQLHelper.SQL := SQ_MAIN_SQL;
    FSQLHelper.OrderByStr := S;
    InSearch := False;
    Query.DisableControls;
    try
      Query.SQL.Text := FSQLHelper.SQL;
      Query.Open;
    finally
      Query.EnableControls;
    end;
  end
  else
    inherited;
end;

procedure TAccountsForm.QueryAfterInsert(DataSet: TDataSet);
begin
  inherited;
  Query.FieldByName(SF_OFFICES_ID).AsInteger := AppModule.User.OfficeId;
  if FEditAfterInsert then
    ModifyRecord(True);
end;

procedure TAccountsForm.QueryDetAfterInsert(DataSet: TDataSet);
begin
  inherited;
  QueryDet.FieldByName(SF_ACCOUNTS_ID).AsInteger := Query.FieldByName(SF_ID).AsInteger;
  ibsAccountsDetGetId.Params.ByName(SF_ACCOUNTS_ID).AsInteger := Query.FieldByName(SF_ID).AsInteger;
  ibsAccountsDetGetId.ExecQuery;
  try
    QueryDet.FieldByName(SF_ID).AsInteger:= Succ(ibsAccountsDetGetId.Fields[N_ZERO].AsInteger);
  finally
    ibsAccountsDetGetId.Close;
  end;
  QueryDet.FieldByName(SF_UNIT).AsString := 'заказ';
  QueryDet.FieldByName(SF_QUANTITY).AsInteger := N_ONE;
  if AccountForm <> nil then AccountForm.ModifyRecord;
end;

procedure TAccountsForm.QueryDetBeforeDelete(DataSet: TDataSet);
begin
  inherited;
  if Application.MessageBox(PChar(S_CONFIRM_DELETE_RECORD), PChar(S_CONFIRM),
       MB_ICONQUESTION or MB_OKCANCEL) <> IDOK
  then
    Abort;
end;

procedure TAccountsForm.QueryDetAfterPost(DataSet: TDataSet);
begin
  inherited;
  Query.Refresh;
end;

procedure TAccountsForm.QueryDetAfterDelete(DataSet: TDataSet);
begin
  inherited;
  Query.Refresh;
end;

procedure TAccountsForm.PrintFastReport(const AReportName: String);
var
  Phone, RepName, S, S1: String;
  V: Variant;
  OfficeEnt: TKisEntity;
begin
  FNeedUpdateReports := False;
  try
    RepName := AppModule.ReportsPath + AReportName;
    if not FileExists(RepName) then
      raise Exception.Create(S_FILE + S_NOT_FOUND + #13 + RepName);
    QueryDet.Close;
    QueryDet.Open;

    QueryPrintedWorks.Params[0].AsInteger := Query.FieldByName(SF_ID).AsInteger;
    QueryPrintedWorks.Close;
    QueryPrintedWorks.Open;

    with PrintModule(True) do
    begin
      ReportFile := RepName;
      SetMasterDataSet(QueryDet, 'MasterData');
      SetAdditionalDataSet(Query, 'MainData');
      SetReportTransaction(Transaction);
      //присваиваем переменные
      SetParamValue('OfficeId', FOfficeId);//AppModule.User.OfficeId);
      OfficeEnt := AppModule.Mngrs[kmOffices].GetEntity(FOfficeId);
      if Assigned(OfficeEnt) then
        SetParamValue('OfficeName', QuotedStr(TKisOffice(OfficeEnt).Name))
      else
        SetParamValue('OfficeName', QuotedStr(AppModule.User.OfficeName));
      SetParamValue('PeopleId', AppModule.User.PeopleId);
      SetParamValue('ObjectAddress', QuotedStr(QueryOBJECT_ADDRESS.AsString));
      //SetParamValue('PeopleName', QuotedStr(AppModule.User.ShortName));
      SetParamValue('PeopleName', QuotedStr(QueryEXECUTOR.AsString));
      SetParamValue('IsOrganisation', False);
      SetParamValue('IS_SUBDIVISION', False);
      V := Null;
      if AppModule.GetFieldValue(Self.Transaction, SF_OFFICES, SF_ID, SF_PHONES,
              QueryOFFICES_ID.AsVariant, V) and not VarIsNull(V)
      then
        Phone := V
      else
        Phone := '_____';
      SetParamValue('Phone', QuotedStr(Phone));
      SetParamValue('OrderNumber', QuotedStr(QueryORDER_NUMBER.AsString));
      SetParamValue('OrderDate', QuotedStr(QueryORDER_DATE.AsString));
      SetParamValue('AccountNumber', QuotedStr(QueryDOC_NUMBER.AsString));
      SetParamValue('AccountDate', QuotedStr(QueryDOC_DATE.AsString));
      if Boolean(QueryIS_OLD.AsInteger) then // старый
      begin
        SetParamValue('PROPS', QuotedStr(QueryPROPERTIES.AsString));
        SetParamValue('CERTIFICATE', '');
      end
      else
      begin // новый :)
        with IObject(TIBSQL.Create(Self)).AObject as TIBSQL do
        begin
          Transaction := Self.Transaction;
          SQL.Text := Format('SELECT TYPE_ID FROM CONTRAGENTS WHERE ID=%d', [QueryFIRMS_ID.AsInteger]);
          ExecQuery;
          if RecordCount > 0 then
          begin
            case Fields[0].AsInteger of
            CT_ORG :
              begin
                S := '';
                S1 := '';
                SetParamValue('IsOrganisation', True);
                Close;
                SQL.Text := 'SELECT ADDR_TEXT FROM CONTR_ADDRESSES WHERE ID=(SELECT ADDRESS_2_ID FROM CONTRAGENTS WHERE ID=' + QueryPAYER_ID.AsString + ')';
                ExecQuery;
                SetParamValue('SUB_FACT_ADDRESS', Fields[0].AsString);
                Close;
                SQL.Text := 'SELECT HEAD_ORG_ID FROM CONTR_ORGS WHERE ID=' + QueryPAYER_ID.AsString;
                ExecQuery;
                SetParamValue('IS_SUBDIVISION', Fields[0].AsInteger = QueryFIRMS_ID.AsInteger);
              end;
            CT_PERSON :
              begin
                S := QuotedStr(QueryPROPERTIES.AsString);
                S1 := '';
                SetParamValue('IsOrganisation', False);
                SetParamValue('IS_SUBDIVISION', False);
              end;
            CT_PRIVATE :
              begin
                SetParamValue('IsOrganisation', False);
                SetParamValue('IS_SUBDIVISION', False);
                S := QuotedStr(QueryPROPERTIES.AsString);
                with IObject(TIBSQL.Create(Self)).AObject as TIBSQL do
                begin
                  Transaction := Self.Transaction;
                  SQL.Text := Format('SELECT DOC FROM GET_CONTR_DOC(%d)', [QueryFIRMS_ID.AsInteger]);
                  ExecQuery;
                  S := QuotedStr(Fields[0].AsString);
                  Close;
                  SQL.Text := Format('SELECT CERTIFICATE FROM GET_CERTIFICATE(%d)', [QueryFIRMS_ID.AsInteger]);
                  ExecQuery;
                  S1 := QuotedStr(#13 + 'сертификат №' + Fields[0].AsString);
                  Close;
                end;
              end;
            end;
          end
          else
          begin
            S := '';
            S1 := '';
          end;
          Close;
          SQl.Text := 'SELECT ADDR_TEXT FROM CONTR_ADDRESSES WHERE ID=(SELECT ADDRESS_2_ID FROM CONTRAGENTS WHERE ID=:ID)';
          Params[0].AsInteger := QueryFIRMS_ID.AsInteger;
          ExecQuery;
          SetParamValue('FACT_ADDRESS', QuotedStr(Fields[0].AsString));
          Close;
        end;
        SetParamValue('PROPS', S);
        SetParamValue('CERTIFICATE', S1);
      end;
     //выводим отчет
      PrintReport;
    end;
  finally
    FNeedUpdateReports := True;
  end;
end;

procedure TAccountsForm.PrintMenuReport(Sender: TObject);
begin
  if Sender is TMenuItem then
    PrintFastReport(FReports.Values[TMenuItem(Sender).Caption]);
end;

procedure TAccountsForm.ReadReportMenu;
var
  I: Integer;
  NewItem: TMenuItem;
begin
  with TIBQuery.Create(nil) do
  try
    Forget;
    BufferChunks := 10;
    Transaction := AppModule.Pool.Get;
    Transaction.StartTransaction;
    SQL.Text := Format(SQ_GET_REPORTS, [RT_ACCOUNTS]);
    Open;
    FetchAll;
    while not Eof do
    begin
      FReports.Add(Fields[0].AsString + '=' + Fields[1].AsString);
      Next;
    end;
    Close;
  finally
    Transaction.Commit;
    AppModule.Pool.Back(Transaction);
  end;
  //удаляем обновляемые пункты меню
  for I := Pred(mnuPrint.Items.Count) downto 0 do
    if mnuPrint.Items.Items[I].Tag = 0 then
      mnuPrint.Items.Delete(I);
  //добавляем разделитель
  if mnuPrint.Items.Count > 0 then
  begin
    NewItem := TMenuItem.Create(mnuPrint.Items);
    NewItem.Caption := '-';
    mnuPrint.Items.Add(NewItem);
  end;
  //добавляем пункты меню
  for I := 0 to Pred(FReports.Count) do
  begin
    NewItem := TMenuItem.Create(mnuPrint.Items);
    NewItem.Caption := FReports.Names[I];
    NewItem.OnClick := PrintMenuReport;
    mnuPrint.Items.Add(NewItem);
  end;
end;

procedure TAccountsForm.btnCopyClick(Sender: TObject);
var
  Ent: TKisEntity;
  OldFlag: Boolean;
  M: TKisSQLMngr;
begin
  M := AppModule.SQLMngrs[kmOrders];
  M.DefaultTransaction := Self.Transaction;
  try
    if Boolean(QueryIS_OLD.AsInteger) then
    begin
      Ent := M.CreateNewEntity;
      Ent.Forget();
      CopyFromOldAccount(Ent);
      Ent := M.EditEntity(Ent);
      Ent.Forget();
      if Ent.Modified then
      begin
        M.SaveEntity(Ent);
        Self.Transaction.CommitRetaining;
        Query.Close;
        Query.Open;
        Query.Locate(SF_ID, Ent.ID, []);
      end;
    end
    else
    begin
      Ent := M.GetEntity(QueryID.AsInteger);
      ENt.Forget();
      Ent := M.DuplicateEntity(Ent);
      Ent.Forget();
      Ent := M.EditEntity(Ent);
      Ent.Forget();
      if Ent.Modified then
      begin
        OldFlag := FEditAfterInsert;
        FEditAfterInsert := False;
        Query.Insert;
        Query.FieldByName(SF_ID).AsInteger := Ent.ID;
        Query.FieldByName(SF_IS_OLD).AsInteger := Integer(False);
        Query.Post;
        M.SaveEntity(Ent);
        Self.Transaction.CommitRetaining;
        Query.Refresh;
        FEditAfterInsert := OldFlag;
      end;
    end;
  except
    Self.Transaction.RollbackRetaining;
    MessageBox(Handle, PChar(S_CANT_SAVE_ORDER), PChar(S_ERROR), MB_OK + MB_ICONSTOP);
  end;
  M.DefaultTransaction := nil;
end;

procedure TAccountsForm.QueryDetBeforePost(DataSet: TDataSet);
begin
  inherited;
  if (not QueryDet.FieldByName(SF_QUANTITY).IsNull)
    and (not QueryDet.FieldByName(SF_PRICE).IsNull)
  then
    QueryDet.FieldByName(SF_SUMMA).AsFloat := QueryDet.FieldByName(SF_QUANTITY).AsFloat * QueryDet.FieldByName(SF_PRICE).AsFloat
  else
    Abort;
end;

procedure TAccountsForm.QueryDetWORK_TYPES_IDChange(Sender: TField);
begin
  inherited;
  if not QueryDet.FieldByName(SF_WORK_TYPES_ID).IsNull then
  begin
    ibsWorkTypeCode.Params[0].AsInteger := QueryOFFICES_ID.AsInteger;
    ibsWorkTypeCode.Params[1].AsInteger := QueryDet.FieldByName(SF_WORK_TYPES_ID).AsInteger;
    ibsWorkTypeCode.ExecQuery;
    if ibsWorkTypeCode.RecordCount > 0 then
      try
        QueryDet.FieldByName(SF_WORK_TYPE_CODE).AsString := ibsWorkTypeCode.Fields[0].AsString;
      finally
      end;
    ibsWorkTypeCode.Close;
  end;
end;

procedure TAccountsForm.QueryDOC_DATEChange(Sender: TField);
begin
  inherited;
  if Query.FieldByName(SF_DOC_DATE).AsDateTime > EncodeDate(2003, 12, 31) then
  begin
    Query.FieldByName(SF_NSP).AsFloat := 0;
    Query.FieldByName(SF_NDS).AsFloat := 18;
  end;
end;

procedure TAccountsForm.QueryDetBeforeOpen(DataSet: TDataSet);
begin
  inherited;
  PrepareQueryDet;
end;

procedure TAccountsForm.PrepareQueryDet;
begin
  if QueryIS_OLD.AsInteger = 0 then
    QueryDet.SQL.Text := 'SELECT O.*, (SELECT SUM(SUMMA) FROM ORDER_POSITIONS WHERE ID=O.ID or CONNECTED_TO=O.ID) AS SUMMA_FULL FROM ORDER_POSITIONS O WHERE ORDERS_ID=:ID'
  else
    QueryDet.SQL.Text := 'SELECT O.*, O.SUMMA AS SUMMA_FULL FROM ACCOUNTS_DET O WHERE ACCOUNTS_ID=:ID';
  QueryDet.ParamByName(SF_ID).AsInteger := Query.FieldByName(SF_ID).AsInteger;
end;

procedure TAccountsForm.PrepareSQLHelper;
begin
  with FSQLHelper do
  begin
    SQL := SQ_MAIN_SQL;
    ClearTables;
    with AddTable do
    begin
      TableName := 'ORDERS_ALL';
      TableLabel := 'Основная (заказы)';
      AddStringField(SF_ORDER_NUMBER, 'Номер заказа', 12, [fpSearch, fpSort]);
      AddSimpleField(SF_ORDER_DATE, 'Дата заказа', ftDate, [fpSearch, fpSort]);
      AddStringField(SF_DOC_NUMBER, 'Номер счета', 12, [fpSearch, fpSort]);
      AddSimpleField(SF_DOC_DATE, 'Дата счета', ftDate, [fpSearch, fpSort]);
      AddStringField(SF_CONTRACT_NUMBER, 'Номер дог.', 12, [fpSearch, fpSort]);
      AddSimpleField(SF_ACT_DATE, 'Дата акта', ftDate, [fpSearch, fpSort]);
      AddStringField(SF_OBJECT_ADDRESS, 'Адрес объекта', 120, [fpSearch, fpSort]);
      AddStringField(SF_FIRM_NAME, 'Заказчик', 300, [fpSearch, fpSort]);
      AddStringField(SF_CUSTOMER, 'Представитель заказчика', 100, [fpSearch, fpSort]);
      AddStringField(SF_ADDRESS, 'Адрес', 100, [fpSearch, fpSort]);
      AddStringField(SF_INN, 'ИНН', 12, [fpSearch, fpSort]);
      AddStringField(SF_PROPERTIES, 'Реквизиты', 100, [fpSearch]);
      AddSimpleField(SF_VAL_PERIOD, 'Срок договора', ftInteger, [fpSearch, fpSort]);
      AddSimpleField(SF_SUMMA, 'Сумма', ftFloat, [fpSearch, fpSort]);
      AddSimpleField(SF_SUM_ALL, 'Сумма всего', ftFloat, [fpSearch, fpSort]);
      AddSimpleField(SF_SUM_BASE, 'Баз. сумма', ftFloat, [fpSearch, fpSort]);
      AddSimpleField(SF_CANCELLED, 'Аннулирован', ftBoolean, [fpSearch, fpSort]);
      AddSimpleField(SF_CHECKED, 'Оплачен', ftBoolean, [fpSearch, fpSort]);
      AddStringField(SF_TICKET, 'Плат. док.', 10, [fpSearch, fpSort]);
      AddSimpleField(SF_PAY_DATE, 'Дата оплаты', ftDate, [fpSearch, fpSort]);
      AddStringField(SF_EXECUTOR, 'Исполнитель', 50, [fpSearch, fpSort]);
      AddStringField(SF_INFORMATION, 'Доп. инф.', 50, [fpSearch, fpSort]);
      AddSimpleField(SF_CLOSED, 'Акт закрыт', ftBoolean, [fpSearch, fpSort]);
//      I := AddSimpleField(SF_ID, SFL_INSERT_ORDER, ftInteger, [fpSort]);
    end;
  end;
end;

procedure TAccountsForm.QueryAfterScroll(DataSet: TDataSet);
begin
  inherited;
  UpdateReports;
end;

procedure TAccountsForm.QueryCLOSEDGetText(Sender: TField; var Text: string;
  DisplayText: Boolean);
begin
  inherited;
  if DisplayText then
    Text := '';
end;

procedure TAccountsForm.actDeleteExecute(Sender: TObject);
var
  IsNew: Boolean;
  Ent: TKisENtity;
  ID: Integer;
begin
  if MessageBox(Self.Handle, PChar(S_CONFIRM_DELETE_RECORD), PChar(S_WARN), MB_YESNO + MB_ICONQUESTION) <> ID_YES then
    Exit;
  IsNew := QueryIS_OLD.AsInteger = 0;
  if IsNew then
  with AppModule.SQLMngrs[kmOrders] do
  begin
    try
      DefaultTransaction := Self.Transaction;
      ID := QueryID.AsInteger;
      Query.Delete;
      Ent := IObject(GetEntity(ID)).AObject as TKisEntity;
      DeleteEntity(Ent);
      DefaultTransaction := nil;
    except
      DefaultTransaction := nil;
      Self.Transaction.RollbackRetaining;
      raise;
    end;
    // Все прошло нормально - удаляем запись из таблицы ORDERS_ALL
    Self.Transaction.CommitRetaining;
  end
  else
  begin
    try
      with IObject(TIBSQL.Create(Self)).AObject as TIBSQL do
      begin
        Transaction := Self.Transaction;
        SQL.Text := Format('DELETE FROM ACCOUNTS WHERE ID=%d', [QueryID.AsInteger]);
        ExecQuery;
      end;
    except
      Transaction.RollbackRetaining;
      raise;
    end;
    Query.Delete;
    Transaction.CommitRetaining;
  end;
end;

procedure TAccountsForm.GridCellColors(Sender: TObject; Field: TField;
  var Background, FontColor: TColor; State: TGridDrawState;
  var FontStyle: TFontStyles);
begin
  inherited;
  if not (gdSelected in State) then
  begin
    if QueryCANCELLED.AsInteger <> 0 then
      BackGround := $CCCCFF
    else
    if QueryCHECKED.AsInteger = 0 then
      BackGround := clWindow
    else
      if QueryACT_DATE.AsString <> '' then
        BackGround := $FFCFC0
      else
      Background := $99FFFF;
    if (Field = QueryEXECUTOR) and (QueryMARK_EXECUTOR.AsInteger <> 0) then
      Background := clLime;
  end;
end;

procedure TAccountsForm.GridDrawColumnCell(Sender: TObject; const Rect: TRect;
  DataCol: Integer; Column: TColumn; State: TGridDrawState);
var
  CheckState: Cardinal;
  R: TRect;
begin
  inherited;
  if Column.Field.FieldName = SF_CLOSED then
  begin
    CheckState := DFCS_BUTTONCHECK + DFCS_FLAT;
    if Column.Field.AsInteger = 1 then
      CheckState := CheckSTate + DFCS_CHECKED;
    R := Rect;
    Inc(R.Top, 2);
    Dec(R.Bottom, 2);
    DrawFrameControl(Grid.Canvas.Handle, R, DFC_BUTTON, CheckState);
  end;
end;

procedure TAccountsForm.CopyFromOldAccount(Entity: TKisEntity);
var
  Pos: TKisOrderPosition;
begin
  with Entity as TKisOrder do
  begin
    //  Копируем параметры заказа
    PeopleId := QueryPEOPLE_ID.AsInteger;
    DocNumber := QueryDOC_NUMBER.AsString;
    DocDate := QueryDOC_DATE.AsString;
    OrderNumber := QueryORDER_NUMBER.AsString;
    OrderDate := QueryORDER_DATE.AsString;
    ContractNumber := QueryCONTRACT_NUMBER.AsString;
    ValPeriod := QueryVAL_PERIOD.AsInteger;
    SumBase := QuerySUM_BASE.AsFloat;
    PayDate := QueryPAY_DATE.AsString;
    Executor := QueryEXECUTOR.AsString;
    ActDate := QueryACT_DATE.AsString;
    Customer := '';
    ObjectAddress := QueryOBJECT_ADDRESS.AsString;
    Ticket := QueryTICKET.AsString;
    Information := QueryINFORMATION.AsString;
    Mark := Boolean(QueryMARK_EXECUTOR.AsInteger);
    Checked := Boolean(QueryCHECKED.AsInteger);
    Cancelled := Boolean(QueryCANCELLED.AsInteger);
    PayerId := QueryPayer_Id.AsInteger;
    PayerCustomer := '';
    PrintWorksValue := Boolean(QueryPRINT_WORKS_VALUE.AsInteger);
    // Копируем позиции заказа
    with TIBQuery.Create(nil) do
    begin
      Forget;
      BufferChunks := 30;
      Transaction := Self.Transaction;
      SQL.Text := Format(SQ_COPY_ORDER_POSITIONS, [QueryID.AsInteger]);
      Open;
      while not Eof do
      begin
        Pos := TKisOrderPosition.Create(AppModule.Mngrs[kmOrders]);
        Pos.Head := Entity;
        Pos.WorktypeId := FieldByName(SF_WORK_TYPES_ID).AsInteger;
        Pos.WorkTypeName := FieldByName(SF_WORK_TYPES_NAME).AsString;
        Pos.WorkTypeCode := FieldByName(SF_WORK_TYPE_CODE).AsString;
        Pos.Price := FieldByName(SF_PRICE).AsFloat;
        Pos.Quantity := FieldByName(SF_QUANTITY).AsFloat;
        Pos.ObjectsAmount := FieldByName(SF_OBJECTS_AMOUNT).AsFloat;
        Pos.Argument := FieldByName(SF_ARGUMENT).AsString;
        Pos.AUnit := FieldByName(SF_UNIT).AsString;
        AddPosition(Pos);
        Next;
      end;
      Close;
    end;
  end;
end;

procedure TAccountsForm.QuerySUM_ALL_PROPISGetText(Sender: TField;
  var Text: String; DisplayText: Boolean);
begin
  inherited;
  Text := QuerySUM_ALL_PROPIS.AsString;
  if Text <> '' then
    Text := AnsiUpperCase(Text[1]) + Copy(Text, 2, Pred(Length(Text))); 
end;

procedure TAccountsForm.actFindExecute(Sender: TObject);
begin
  if Assigned(FSQLHelper) then
  begin
    if FSQLHelper.TableCount > 0 then
      FSQLHelper.Tables[0].SelectedField := Grid.SelectedField.FieldName;
    FSQLHelper.SQL := Query.SQL.Text;
    if FSQLHelper.SearchDialog then
    begin
      InSearch := True;
      Query.DisableControls;
      try
        Query.SQL.Text := FSQLHelper.SQL;
        Query.Open;
      finally
        Query.EnableControls;
      end;
    end;
  end
  else
    inherited;
end;

procedure TAccountsForm.actInsertExecute(Sender: TObject);
begin
  inherited;
  ;
end;

procedure TAccountsForm.ApplySQLFilters;
var
  Filter1, S, Where: String;
  I: Integer;
  Y, M, D: Word;
  aSql: ISQL;
begin
  aSql := Query.AsSQL;
  aSql.Normalize();
  // уделям старый фильтр отдела
  if FOldOfficeId > 0 then
  begin
    S := Format('A.OFFICES_ID=%d', [FOldOfficeId]);//[AppModule.User.OfficeId]);
    if aSql.CheckCondition(S) then
    begin
      Where := aSql.ReadClause(scWhere);
      aSql.DeleteCondition(Where, S);
      aSql.WriteClause(scWhere, Where);
    end;
  end;
  // добавляем новый
  if FOfficeId > 0 then
  begin
    // добавляем новый
    S := Format('A.OFFICES_ID=%d', [FOfficeId]);//[AppModule.User.OfficeId]);
    if not aSQL.CheckCondition(S) then
      aSQL.AddWhereCondition(S);
  end;
  DecodeDate(Date, Y, M, D);
  Dec(Y);
  if (M = 2) and (D = 29) then
    D := 28;
  //
  Filter1 := 'A.ORDER_DATE>=' + QuotedStr(DateToStr(EncodeDate(Y, M, D)));
  I := Pos(Filter1, Query.SQL.DelimitedText);
  if cbDateFilter.ItemIndex = 1 then
  begin
    if I = 0 then
      aSQL.AddWhereCondition(Filter1);
  end
  else
    if I > 0 then
    begin
      S := aSQL.ReadClause(scWhere);
      aSQL.DeleteCondition(S, Filter1);
      aSQL.WriteClause(scWhere, S);
    end;
end;

procedure TAccountsForm.cbDateFilterChange(Sender: TObject);
var
  ID: Integer;
begin
  inherited;
  if not Query.IsEmpty then
    ID := QueryID.AsInteger
  else
    ID := -1;
  Query.Close;
  Query.Open;
  if ID > 0 then
    Query.Locate(SF_ID, ID, []);
  Grid.SetFocus;
end;

procedure TAccountsForm.cbOfficeChange(Sender: TObject);
var
  aId: Integer;
begin
  inherited;
  if cbOffice.ItemIndex >= 0 then
  begin
    aId := Integer(cbOffice.Items.Objects[cbOffice.ItemIndex]);
    if aId <> FOfficeId then
    begin
      FOldOfficeId := FOfficeId;
      FOfficeId := aId;
      Query.Close;
      Query.Open;
    end;
  end;
end;

procedure TAccountsForm.UpdateOfficeCombo;
begin
  cbOffice.Items.Assign(IStrings(AppModule.OfficesList(AppModule.User.OrgId)).Strings);
  if AppModule.User.AllowAllOffices(kmOrders) then
    cbOffice.Items.InsertObject(0, 'Все отделы', nil);
  ComboLocate(cbOffice, FOfficeId);
end;

procedure TAccountsForm.UpdateReports;
var
  IsPerson, IsOld: Boolean;
  I: Integer;
begin
  if not FNeedUpdateReports then
    Exit;
  IsOld := QueryIS_OLD.AsInteger = 1;
  IsPerson := False;
  if not IsOld then
  begin
    with TIBQuery.Create(nil) do
    begin
      Forget;
      BufferChunks := 10;
      Transaction := Self.Transaction;
      SQL.Text := Format('SELECT TYPE_ID FROM CONTRAGENTS WHERE ID=%d', [QueryFIRMS_ID.AsInteger]);
      Open;
      IsPerson := not IsEmpty and (Fields[0].AsInteger = CT_PERSON);
      Close;
    end;
  end;
  for I := 0 to Pred(mnuPrint.Items.Count) do
  with mnuPrint.Items[I] do
  begin
    if Caption = 'Счет-договор' then
      Enabled := IsPerson and (not IsOld) and (FOfficeId <> ID_OFFICE_PRIVATE_BUILDING)
    else
    if Pos('Счет-договор ИЗ', Caption) > 0 then
      Enabled := IsPerson and (not IsOld) and (FOfficeId = ID_OFFICE_PRIVATE_BUILDING)
    else
    if (Pos('ДОГОВОР', AnsiUpperCase(Caption)) > 0)
       or (Pos('СЧЕТ', AnsiUpperCase(Caption)) > 0)
    then
      Enabled := not IsPerson or IsOld;
  end;
end;

procedure TAccountsForm.QueryAfterRefresh(DataSet: TDataSet);
begin
  inherited;
  UpdateReports;
end;

procedure TAccountsForm.pnlOkCancelResize(Sender: TObject);
begin
  inherited;
  btnCancel.Left := pnlOkCancel.ClientWidth - btnCancel.Width - 8;
  btnOk.Left := pnlOkCancel.ClientWidth - btnCancel.Left - btnOk.Width - 8;
end;

procedure TAccountsForm.btnOkClick(Sender: TObject);
begin
  inherited;
  FCurrentID := QueryID.AsInteger;
  ModalResult := mrOK;
end;

procedure TAccountsForm.ToolButton6Click(Sender: TObject);
begin
  inherited;
  Legend.ShowLegend(ClientHeight - Legend.FormHeight,
                    ClientWidth - Legend.FormWidth - 10);
end;

procedure TAccountsForm.actInsertUpdate(Sender: TObject);
begin
  actInsert.Enabled := AppModule.User.CanDoAction(maInsert, keOrder);
end;

end.
