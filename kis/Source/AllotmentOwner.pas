unit AllotmentOwner;

interface

{$I KisFlags.pas}

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, 
  StdCtrls, Mask, DBCtrls, IBQuery, Db, IBCustomDataSet,
  // shared
  uDB, uGC;

type
  TAllotmentOwnerForm = class(TForm)
    Label1: TLabel;
    dbeName: TDBEdit;
    btnSelect: TButton;
    btnClear: TButton;
    btnOk: TButton;
    btnCancel: TButton;
    Label2: TLabel;
    dbePercent: TDBEdit;
    dbePurpose: TDBEdit;
    Label3: TLabel;
    btnDetail: TButton;
    Label6: TLabel;
    dbcPropForm: TDBLookupComboBox;
    Label10: TLabel;
    dbeRentPeriod: TDBEdit;
    procedure btnOkClick(Sender: TObject);
    procedure btnClearClick(Sender: TObject);
    procedure btnDetailClick(Sender: TObject);
    procedure btnSelectClick(Sender: TObject);
  private
    _ReadOnly: Boolean;
    Query: TIBQuery;
    procedure SetControls;
  end;

function ShowOwner(ReadOnly: Boolean=False): Boolean;

implementation

{$R *.DFM}

uses
  Allotment, Allotments, uKisConsts, uKisAppModule, uKisClasses,
  uKisSQLClasses, uKisFirms, uKisIntf, uKisEntityEditor;

function ShowOwner(ReadOnly: Boolean=False): Boolean;
var
  st: TDataSetState;
begin
  with TAllotmentOwnerForm.Create(Application) do
  try
    _ReadOnly:=ReadOnly;
    Query:=TIBQuery(dbeName.DataSource.DataSet);
    SetControls;
    Result:=(ShowModal=mrOk);
    st := Query.State;
    with Query do
      if st in [dsEdit,dsInsert] then
        if Result then
          Post
        else
          Cancel;
  finally
    Free;
  end;
end;

procedure TAllotmentOwnerForm.btnOkClick(Sender: TObject);
begin
  if Trim(dbeName.Text) = '' then
  begin
    MessageBox(Handle, PChar(S_PLEASE_FILL_FIELD + ' "Владелец" !'), PChar(S_WARN), MB_ICONWARNING);
    dbeName.SetFocus;
  end
  else
  if Trim(dbePurpose.Text) = '' then
  begin
    MessageBox(Handle, PChar(S_PLEASE_FILL_FIELD + ' "Назначение" !'), PChar(S_WARN), MB_ICONWARNING);
    dbePurpose.SetFocus;
  end
  else
  begin
    Query.SoftPost();
    ModalResult := mrOk;
  end;
end;

procedure TAllotmentOwnerForm.btnClearClick(Sender: TObject);
begin
  with Query do
  begin
    if not(State in [dsEdit,dsInsert]) then
      Edit;
    FieldByName(SF_FIRMS_ID).Clear;
    FieldByName(SF_NAME).Clear;
  end;
  SetControls;
end;

procedure TAllotmentOwnerForm.btnDetailClick(Sender: TObject);
var
  FirmId: Integer;
begin
  FirmId := Query.FieldByName(SF_FIRMS_ID).AsInteger;
  with AppModule[kmFirms].GetEntity(FirmId) as TKisVisualEntity do
  begin
    Forget();
    ReadOnly := True;
    Edit;
  end;
end;

procedure TAllotmentOwnerForm.SetControls;
begin
  btnCancel.Visible := not _ReadOnly;
  btnSelect.Enabled := not _ReadOnly;
  btnClear.Enabled := not _ReadOnly;
  btnDetail.Enabled := not Query.FieldByName(SF_FIRMS_ID).IsNull;
  dbeName.ReadOnly := not(Query.FieldByName(SF_FIRMS_ID).IsNull) or _ReadOnly;
end;

procedure TAllotmentOwnerForm.btnSelectClick(Sender: TObject);
var
  Firm: TKisEntity;
  aId: Integer;
begin
  aId := Query.FieldByName(SF_FIRMS_ID).AsInteger;
  Firm := KisObject(AppModule.SQLMngrs[kmFirms].SelectEntity(
    True, nil, False, aId)).AEntity;
  if Assigned(Firm) then
  begin
    if not (Query.State in [dsEdit, dsInsert]) then
      Query.Edit;
    Query.FieldByName(SF_FIRMS_ID).AsInteger := Firm.ID;
    Query.FieldByName(SF_NAME).AsString := TKisFirm(Firm).Shortname;
  end;
  SetControls;
end;

end.
