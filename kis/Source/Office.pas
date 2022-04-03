unit Office;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, ComCtrls,
  StdCtrls, DB, Grids, DBGrids, Mask, DBCtrls, Buttons, IBCustomDataSet, IBQuery, IBUpdateSQL, IBSQL,
  // shaerd
  uDB;

type
  TOfficeForm = class(TForm)
    btnOk: TButton;
    btnCancel: TButton;
    ibqWorkTypes: TIBQuery;
    ibusWorktypes: TIBUpdateSQL;
    dsWorkTypes: TDataSource;
    ibsGetId: TIBSQL;
    ibqWorkTypesOFFICES_ID: TIntegerField;
    ibqWorkTypesID: TSmallintField;
    ibqWorkTypesNAME: TIBStringField;
    ibqWorkTypesPRICE: TFloatField;
    ibqWorkTypesSHORT_NAME: TIBStringField;
    ibqWorkTypesARGUMENT: TIBStringField;
    PageControl: TPageControl;
    tshCommon: TTabSheet;
    tshWorkTypes: TTabSheet;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label6: TLabel;
    dbeName: TDBEdit;
    dbeShortName: TDBEdit;
    dbePhones: TDBEdit;
    dbeDirector: TDBEdit;
    dbeRoleName: TDBEdit;
    dbgWorkTypes: TDBGrid;
    dbmWorkName: TDBMemo;
    btnWorkAdd: TSpeedButton;
    btnWorkDel: TSpeedButton;
    Label7: TLabel;
    Label8: TLabel;
    dbeArgument: TDBEdit;
    ibqWorkTypesCODE: TIBStringField;
    ibqOrgs: TIBQuery;
    dblcbOrgName: TDBLookupComboBox;
    Label9: TLabel;
    dsOrgs: TDataSource;
    procedure btnOkClick(Sender: TObject);
    procedure btnWorkAddClick(Sender: TObject);
    procedure btnWorkDelClick(Sender: TObject);
    procedure ibqWorkTypesBeforeDelete(DataSet: TDataSet);
    procedure ibqWorkTypesAfterInsert(DataSet: TDataSet);
  private
    DataSet: TDataSet;
    MainId: Integer;
  end;

function ShowOffice: Boolean;

implementation

uses
   Offices, AProc6, uKisConsts;

{$R *.DFM}

function ShowOffice: Boolean;
begin
  with TOfficeForm.Create(Application) do
  try
    PageControl.ActivePageIndex := 0;
    DataSet := dbeName.DataSource.DataSet;
    ibqWorkTypes.Transaction := OfficesForm.Transaction;
    ibsGetId.Transaction := OfficesForm.Transaction;
    ibqOrgs.Transaction := OfficesForm.Transaction;
    ibqOrgs.Open;
    ibqOrgs.FetchAll;
    MainId := DataSet.FieldByName(SF_ID).AsInteger;
    with ibqWorkTypes do
    begin
      ParamByName(SF_OFFICES_ID).AsInteger := MainId;
      Open;
      FetchAll;
    end;
    ibsGetId.Params.ByName(SF_OFFICES_ID).AsInteger := MainId;
    Result := ShowModal = mrOk;
  finally
    Release;
  end;
end;

procedure TOfficeForm.btnOkClick(Sender: TObject);
begin
  DataSet.SoftPost();
  ModalResult:=mrOk;
end;

procedure TOfficeForm.btnWorkAddClick(Sender: TObject);
begin
  ibqWorkTypes.Append;
end;

procedure TOfficeForm.btnWorkDelClick(Sender: TObject);
begin
  with ibqWorkTypes do
    if not (Bof and Eof) then
      Delete;
end;

procedure TOfficeForm.ibqWorkTypesBeforeDelete(DataSet: TDataSet);
begin
  if MessageBox(Handle,
                PChar(S_CONFIRM_DELETE_RECORD),
                PChar(S_CONFIRM),
                MB_ICONQUESTION + MB_OKCANCEL) <> IDOK
  then
    Abort;
end;

procedure TOfficeForm.ibqWorkTypesAfterInsert(DataSet: TDataSet);
begin
  ibqWorkTypes.FieldByName(SF_OFFICES_ID).AsInteger := MainId;
  ibsGetId.ExecQuery;
  try
    ibqWorkTypes.FieldByName(SF_ID).AsInteger := Succ(ibsGetId.Fields[0].AsInteger);
  finally
    ibsGetId.Close;
  end;
end;

end.
