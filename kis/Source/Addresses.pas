{  1.01   -30.03.2005
      исправлена длина полей BUILDINGS_NAME и BUILDING_MARKING_NAME
}
unit Addresses;

interface

{$I KisFlags.pas}

uses
  // System
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, StdCtrls,
  Menus, IBSQL, DB, IBCustomDataSet, IBQuery, ComCtrls, ToolWin, Variants,
  IBUpdateSQL, IBDatabase, ActnList, ImgList, Grids, DBGrids,
  // jedi
  JvFormPlacement, JvComponentBase,
  // MyVCL
  uDBGrid, uLegend,
  // shared
  uGC, uDB,
  // Project
  IBCHILD, uKisAppModule, uKisPrintModule, uKisConsts, uKisClasses, uKisIntf;

type
  TAddressesForm = class(TIBChildForm)
    ibsLastOrderNumber: TIBSQL;
    ToolButton1: TToolButton;
    btnPrint: TToolButton;
    ibqRegions: TIBQuery;
    ibqPeople: TIBQuery;
    QueryID: TIntegerField;
    QueryFIRMS_ID: TIntegerField;
    QueryCUSTOMER_NAME: TIBStringField;
    QuerySTREETS_ID: TIntegerField;
    QuerySTREET_NAME: TIBStringField;
    QuerySTREET_MARKING_NAME: TIBStringField;
    QueryBUILDINGS_ID: TIntegerField;
    QueryBUILDINGS_NAME: TIBStringField;
    QueryBUILDING_MARKING_NAME: TIBStringField;
    QueryREGIONS_ID: TIntegerField;
    QueryPEOPLE_ID: TIntegerField;
    QueryPURPOSE: TIBStringField;
    QueryPAYMENT: TIBStringField;
    QueryPRINTABLE_NAME: TIBStringField;
    QueryVILLAGES_ID: TIntegerField;
    QueryVILLAGES_NAME: TIBStringField;
    QueryVILLAGES_MARKING_NAME: TIBStringField;
    QueryPRINTABLE_ADDRESS: TIBStringField;
    QueryREGIONS_NAME: TIBStringField;
    QueryREGIONS_NAME_PREP: TIBStringField;
    QueryFULL_NAME: TIBStringField;
    QueryINITIAL_NAME: TIBStringField;
    QueryCATEGORY: TIBStringField;
    QueryFOUNDATION: TBlobField;
    QuerySALE: TIBBCDField;
    QueryORDER_NUMBER: TIntegerField;
    ToolButton2: TToolButton;
    tbCopyAct: TToolButton;
    QueryORDER_DATE: TDateField;
    QueryACCOUNT_NUMBER: TIBStringField;
    QueryWORK_NAME: TIBStringField;
    QueryOBJECT_ADDRESS: TIBStringField;
    QueryACT_NUMBER: TIBStringField;
    QueryIMAGE: TBlobField;
    QueryACT_DATE: TDateField;
    pmReports: TPopupMenu;
    N18: TMenuItem;
    N19: TMenuItem;
    ToolButton4: TToolButton;
    cbDateFilter: TComboBox;
    Label1: TLabel;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure QueryAfterInsert(DataSet: TDataSet);
    procedure FormCreate(Sender: TObject);
    procedure actShowExecute(Sender: TObject);
    procedure QuerySTREETS_IDChange(Sender: TField);
    procedure tbCopyActClick(Sender: TObject);
    procedure N18Click(Sender: TObject);
    procedure N19Click(Sender: TObject);
    procedure GridCellColors(Sender: TObject; Field: TField; var Background,
      FontColor: TColor; State: TGridDrawState; var FontStyle: TFontStyles);
  private
    Copying: Boolean;
    procedure ModifyRecord;
    function PrintableAddress: String;
    procedure Print(const ReportName: String);
  end;

var
  AddressesForm: TAddressesForm;

implementation

{$R *.DFM}

uses
  Address;

const
  SQ_SELECT_ADDRESS = 'SELECT ACCOUNT_NUMBER, FIRMS_ID, REGIONS_ID, PEOPLE_ID,'
    + 'CUSTOMER_NAME, WORK_NAME, PRINTABLE_NAME, VILLAGES_ID, VILLAGES_NAME,'
    + 'VILLAGES_MARKING_NAME, STREETS_ID, STREET_NAME, STREET_MARKING_NAME,'
    + 'BUILDINGS_ID, BUILDINGS_NAME, BUILDING_MARKING_NAME, PURPOSE, OBJECT_ADDRESS,'
    + 'PAYMENT, PRINTABLE_ADDRESS, FOUNDATION, SALE'
    + ' FROM ADDRESSES WHERE ID=%d';

procedure TAddressesForm.FormCreate(Sender: TObject);
begin
  inherited;
  Transaction.DefaultDatabase := AppModule.Database;
  AutoCommitAfterPost:=False;
  ibqRegions.Open;
  ibqRegions.FetchAll;
  ibqPeople.Open;
  ibqPeople.FetchAll;
  Copying:= False;
end;

procedure TAddressesForm.GridCellColors(Sender: TObject; Field: TField;
  var Background, FontColor: TColor; State: TGridDrawState;
  var FontStyle: TFontStyles);
begin
  inherited;
  if not (gdSelected in State) then
  begin
    if QueryIMAGE.BlobSize = 0 then
      Background := clWhite
    else
      Background := clInfoBk;
    FontColor := clBlack;
 end;
end;

procedure TAddressesForm.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  inherited;
  AddressesForm := nil;
end;

procedure TAddressesForm.ModifyRecord;
begin
  if not Copying then
    if ShowAddress then
    begin
      Query.SoftPost();
      Transaction.CommitRetaining
    end
    else
    begin
      Query.SoftCancel();
      Transaction.RollbackRetaining;
    end;
end;

procedure TAddressesForm.QueryAfterInsert(DataSet: TDataSet);
begin
  inherited;
  QueryACT_NUMBER.AsString := '';
  QueryACT_DATE.AsDateTime := SysUtils.Date;
  QueryORDER_NUMBER.AsString := '';
  QueryORDER_DATE.AsDateTime := SysUtils.Date;
  ///
  ///  ed test
  ///

  QueryACT_NUMBER.AsString := AppModule.User.GenerateNewAddressActNumber;
  QueryACT_DATE.AsDateTime := SysUtils.Date;
  QueryORDER_NUMBER.AsString := AppModule.User.GenerateNewAddressOrderNumber;
  QueryORDER_DATE.AsDateTime := SysUtils.Date;
  ///
  ///
  Query.FieldByName(SF_STREET_NAME).AsString := #32;
  Query.FieldByName(SF_STREET_MARKING_NAME).AsString := #32;
  Query.FieldByName(SF_BUILDINGS_NAME).AsString := #32;
  Query.FieldByName(SF_BUILDING_MARKING_NAME).AsString := #32;
  QueryIMAGE.Clear;
  ModifyRecord;
end;

procedure TAddressesForm.actShowExecute(Sender: TObject);
begin
  inherited;
  ModifyRecord;
end;

procedure TAddressesForm.QuerySTREETS_IDChange(Sender: TField);
begin
  inherited;
  Query.SoftEdit();
  QueryPRINTABLE_ADDRESS.AsString := PrintableAddress;
end;

function TAddressesForm.PrintableAddress: String;
var
  S: String;
begin
  if not Query.FieldByName(SF_REGIONS_ID).IsNull then
  if ibqRegions.Locate(SF_ID, Query.FieldByName(SF_REGIONS_ID).AsInteger, []) then
    S := S + ibqRegions.FieldByName(SF_NAME).AsString + ' район, ';
  if not Query.FieldByName(SF_VILLAGES_ID).IsNull then
    S := S + Query.FieldByName(SF_VILLAGES_MARKING_NAME).AsString + #32 +
      Query.FieldByName(SF_VILLAGES_NAME).AsString + ', ';
  if not Query.FieldByName(SF_STREETS_ID).IsNull then
    S := S + Query.FieldByName(SF_STREET_MARKING_NAME).AsString + #32 +
      Query.FieldByName(SF_STREET_NAME).AsString;
  if not Query.FieldByName(SF_BUILDINGS_ID).IsNull then
    S := S + ', ' + Query.FieldByName(SF_BUILDING_MARKING_NAME).AsString +
    Query.FieldByName(SF_BUILDINGS_NAME).AsString;
  if Trim(S) <> '' then   S := 'г.Воронеж, ' + S;
  Result := S;
end;

procedure TAddressesForm.tbCopyActClick(Sender: TObject);
var
  I: Integer;
begin
  inherited;
  with TIBQuery.Create(nil) do
  begin
    Forget;
    BufferChunks := 10;
    Transaction := Self.Transaction;
    SQL.Text := Format(SQ_SELECT_ADDRESS, [QueryID.AsInteger]);
    Open;
    if IsEmpty then
      raise Exception.Create(S_CANT_COPY_ADDRESS);
    Copying := True;
    try
      Query.Insert;
      for I := 0 to Pred(FieldCount) do
      begin
        Query.FieldValues[Fields[I].FieldName] := Fields[I].Value;
      end;
      //Query.Post;
    finally
      Copying := False;
    end;
    ModifyRecord;
  end;
end;

procedure TAddressesForm.N18Click(Sender: TObject);
begin
//  inherited;
  Print('Акт установления почтового адреса.frf');
end;

procedure TAddressesForm.N19Click(Sender: TObject);
begin
//  inherited;
  Print('План установления почтового адреса.frf');
end;

procedure TAddressesForm.Print(const ReportName: String);
var
  Str: TStream;
  WithImage: Boolean;
begin
  WithImage := False;
  with PrintModule(True) do
  begin
    ReportFile := AppModule.ReportsPath + ReportName;
    if QueryIMAGE.AsBlob.BlobSize > 0 then
    begin
      Str := IObject(Query.CreateBlobStream(QueryIMAGE, bmRead)).AObject as TStream;
      SetPictureFromStream(Str, 'Plan');
      WithImage := True;
    end;
    SetParamValue('WITH_IMAGE', WithImage);
    PrintReport;
  end;
end;

end.
