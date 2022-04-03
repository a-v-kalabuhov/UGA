unit PrintSel;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, 
  Buttons, StdCtrls, Db, IBCustomDataSet, IBQuery, IBSQL, IBDatabase,
  ExtCtrls;

type
  TPrintSelForm = class(TForm)
    btnOk: TButton;
    btnCancel: TButton;
    lbReports: TListBox;
    Label1: TLabel;
    cbAllOwners: TCheckBox;
    btnAddItem: TButton;
    btnDelItem: TButton;
    btnRedactItem: TButton;
    ibReportsList: TIBQuery;
    ibGetId: TIBQuery;
    ibqMaxId: TIBQuery;
    ibsAdd: TIBSQL;
    ibsDel: TIBSQL;
    ibsUpd: TIBSQL;
    ibtListReports: TIBTransaction;
    rgReportType: TRadioGroup;
    procedure lbReportsDblClick(Sender: TObject);
    procedure btnAddItemClick(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure btnDelItemClick(Sender: TObject);
    procedure btnRedactItemClick(Sender: TObject);
    procedure DeleteRecord;
    procedure RefreshAndSetItem(RIndex: integer; Sender: TObject);
    procedure rgReportTypeClick(Sender: TObject);
  private
    procedure LoadReports;
  public
  end;

function ShowPrintSel(var ReportIndex: Integer; var AllOwners: Boolean): Boolean;


implementation

uses
  PrintSelAdd, Allotments, uKisClasses, uKisAppModule, uKisConsts;

{$R *.DFM}

function ShowPrintSel(var ReportIndex: Integer; var AllOwners: Boolean): Boolean;
Var
  i: integer;
begin
  with TPrintSelForm.Create(Application) do
   try
    lbReports.ItemIndex := ReportIndex;
    cbAllOwners.Checked := AllOwners;
    Result:=(ShowModal=mrOk);
    if Result then begin
       i:=lbReports.ItemIndex;
       ibGetId.ParamByName(SF_NAME).AsString := lbReports.Items.Strings[i];
       ibGetId.Open;
       ReportIndex := ibGetId.FieldByName(SF_ID).AsInteger;
       ibGetId.Close;
       AllOwners := cbAllOwners.Checked;
    end;
  finally
    Release;
  end;
end;

procedure TPrintSelForm.lbReportsDblClick(Sender: TObject);
begin
  if lbReports.ItemIndex >= 0 then ModalResult := mrOk;
end;


procedure TPrintSelForm.btnAddItemClick(Sender: TObject);
var
  NameDoc: string;
  NameFile: string;
  k, id: integer;
  st : string;
  flag: boolean;
  fl: boolean;
begin
  NameDoc := '';
  NameFile := '';
  flag := False;

  repeat
    fl := GetPrintSelAddParams(NameDoc, NameFile);
    if fl then
    begin
      st := UpperCase(NameFile);
      flag := (Pos('REPORTS', st) > 0) and (Pos('.FRF', st) > 0);
      if (not flag) then MessageBox(0, PChar(S_Bad_FastReport_File), PChar(S_Error), MB_ICONSTOP);
    end;
  until (flag) or (not fl);

  if flag then
  begin
    if not ibtListReports.Active then ibtListReports.StartTransaction;
    k := POS('REPORTS', st);
    NameFile := Copy(NameFile, k, Length(st) - k + 1);
    ibqMaxId.Open;
    Id := Succ(ibqMaxId.FieldByName(SF_MAX_ID).AsInteger);
    ibqMaxId.Close;

    with ibsAdd do
    begin
      Params.ByName(SF_ID).AsInteger := ID;
      Params.ByName(SF_NAME).AsString := NameDoc;
      Params.ByName(SF_KIND).AsString := 'FReport';
      Params.ByName(SF_FILEPATH).AsString := NameFile;
      Params.ByName(SF_REPORT_TYPE).AsInteger := rgReportType.ItemIndex;
      ExecQuery;
    end;
    ibtListReports.Commit;
    RefreshAndSetItem(id, Sender);
  end;
end;

procedure TPrintSelForm.FormActivate(Sender: TObject);
begin
  //Заполнение Списка  документов
  LoadReports;
  btnRedactItem.Enabled := AppModule.User.IsAdministrator;
  btnDelItem.Enabled := AppModule.User.IsAdministrator;
  BtnAddItem.Enabled := AppModule.User.IsAdministrator;
end;

procedure TPrintSelForm.DeleteRecord;
begin
  if not ibtListReports.Active then ibtListReports.StartTransaction;
  with ibsDel do
    begin
     Params[0].AsString := lbReports.Items[lbReports.ItemIndex];
     ExecQuery;
    end;
  ibtListReports.Commit;
end;

procedure TPrintSelForm.btnDelItemClick(Sender: TObject);
begin
  if MessageBox(Handle, PChar(S_DELETE_DOC), PChar(S_Confirm), MB_ICONQUESTION + MB_OKCANCEL) = IDOK then
    DeleteRecord;
  RefreshAndSetItem(0, Sender);
end;

procedure TPrintSelForm.btnRedactItemClick(Sender: TObject);
Var
  id, i, k: Integer;
  NameDoc, NameFile, KIND: string;
  flag, fl : boolean;
  ActivePath: boolean;
  st: string;
begin
  rgReportType.Enabled := False;
  i := lbReports.ItemIndex;
  ibGetId.ParamByName(SF_NAME).AsString := lbReports.Items.Strings[i];
  ibGetId.Open;
  id := ibGetId.FieldByName(SF_ID).AsInteger;
  Kind := ibGetId.FieldByName(SF_KIND).AsString;
  NameDoc := ibGetId.FieldByName(SF_NAME).AsString;
  NameFile := ibGetId.FieldByName(SF_FILEPATH).AsString;
  ibGetId.Close;
  ActivePath := (Kind = 'FReport');
  flag := false;
  repeat
    fl := GetPrintSelAddParams(NameDoc, NameFile, ActivePath);
    if fl then
    begin
      st := UpperCase(NameFile);
      flag := (Pos('REPORTS', st) > 0);
      if ActivePath then
         flag := (flag and (Pos('.FRF', st) > 0));
      if not flag then
        MessageBox(Handle, PChar(S_BAD_FASTREPORT_FILE), PChar(S_WARN), MB_ICONWARNING);
    end;
  until (flag) or (not fl);
  if flag then
  begin
    ibtListReports.StartTransaction;
    k := POS('REPORTS', st);
    NameFile := Copy(NameFile, k, length(st) - k + 1);
    with ibsUpd do
    begin
      Params.ByName(SF_ID).AsInteger := ID;
      Params.ByName(SF_NAME).AsString := NameDoc;
      Params.ByName(SF_KIND).AsString := KIND;
      Params.ByName(SF_FILEPATH).AsString := NameFile;
      ExecQuery;
    end;
    ibtListReports.Commit;
    RefreshAndSetItem(id, Sender);
  end;
  rgReportType.Enabled := True;
end;

procedure  TPrintSelForm.RefreshAndSetItem(RIndex: integer; Sender: TObject);
begin
  FormActivate(Sender);
  lbReports.ItemIndex := RIndex;
end;

procedure TPrintSelForm.LoadReports;
begin
  with ibReportsList do
  begin
    Params[0].AsInteger := rgReportType.ItemIndex;
    Open;
    lbReports.Clear;
    while not Eof do
    begin
      lbReports.Items.Add(FieldByName(SF_NAME).AsString);
      Next;
    end;
    Close;
  end;
  lbReports.ItemIndex := 0;
end;

procedure TPrintSelForm.rgReportTypeClick(Sender: TObject);
begin
  LoadReports;
end;

end.
