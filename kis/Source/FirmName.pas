unit FirmName;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, 
  Db, IBCustomDataSet, IBQuery, StdCtrls, Mask, DBCtrls,
  // shared
  uDB;

type
  TFirmNameForm = class(TForm)
    dbeName: TDBEdit;
    btnSelect: TButton;
    btnClear: TButton;
    btnDetail: TButton;
    btnOk: TButton;
    btnCancel: TButton;
    dbeType: TDBLookupComboBox;
    Label1: TLabel;
    Label2: TLabel;
    procedure btnOkClick(Sender: TObject);
    procedure btnClearClick(Sender: TObject);
    procedure btnDetailClick(Sender: TObject);
    procedure btnSelectClick(Sender: TObject);
  private
    Query: TIBQuery;
    procedure SetControls;
  end;

function ShowFirmName: Boolean;

implementation

{$R *.DFM}

uses
  // Project
  uKisConsts, uKisClasses, uKisSQLClasses, uKisAppModule, uKisIntf,
  uKisEntityEditor;

function ShowFirmName: Boolean;
begin
  with TFirmNameForm.Create(Application) do
  try
    Query := TIBQuery(dbeName.DataSource.DataSet);
    SetControls;
    Result:=(ShowModal=mrOk);
    if Result then
      Query.SoftPost()
    else
      Query.SoftCancel();
  finally
    Free;
  end;
end;

procedure TFirmNameForm.btnOkClick(Sender: TObject);
begin
  Query.SoftPost();
  ModalResult:=mrOk;
end;

procedure TFirmNameForm.btnClearClick(Sender: TObject);
begin
  Query.SoftEdit();
  Query.FieldByName(SF_FIRMS_ID).Clear;
  Query.FieldByName(SF_NAME).Clear;
  SetControls;
end;

procedure TFirmNameForm.btnDetailClick(Sender: TObject);
var
  FirmId: Integer;
begin
  FirmId := Query.FieldByName(SF_FIRMS_ID).AsInteger;
  with KisObject(AppModule[kmFirms].GetEntity(FirmId)).AEntity as TKisVisualEntity do
  begin
    ReadOnly := True;
    Edit;
  end;
end;

procedure TFirmNameForm.SetControls;
begin
  btnDetail.Enabled := not Query.FieldByName(SF_FIRMS_ID).IsNull;
end;

procedure TFirmNameForm.btnSelectClick(Sender: TObject);
begin
  with KisObject(AppModule.SQLMngrs[kmFirms].SelectEntity(True, nil, True, Query.FieldByName(SF_FIRMS_ID).AsInteger)) do
    if Assigned(AEntity) then
    begin
      if not(Query.State in [dsEdit, dsInsert]) then
        Query.Edit;
      Query.FieldByName(SF_FIRMS_ID).AsInteger := AEntity.ID;
      Query.FieldByName(SF_NAME).AsString := AEntity[SF_SHORT_NAME].AsString;
    end;
  SetControls;
end;

end.
