unit Address;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, ExtDlgs,
  StdCtrls, DBCtrls, Mask, IBSQL, IBQuery, Db, Addresses, IBCustomDataSet, ComCtrls, ExtCtrls,
  // shared
  uDB,
  // kis
  IBDatabase, IBCHILD;

type
  TAddressForm = class(TForm)
    btnOk: TButton;
    btnCancel: TButton;
    PageControl1: TPageControl;
    TabSheet1: TTabSheet;
    TabSheet2: TTabSheet;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label1: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    Label8: TLabel;
    Label9: TLabel;
    Label10: TLabel;
    Label11: TLabel;
    Label12: TLabel;
    Label13: TLabel;
    dbeOrderDate: TDBEdit;
    dbeOrderNumber: TDBEdit;
    dbeAccount: TDBEdit;
    dbeSale: TDBEdit;
    dbePayment: TDBEdit;
    gbCustomer: TGroupBox;
    dbeCustomerName: TDBEdit;
    btnSelect: TButton;
    btnClear: TButton;
    btnDetail: TButton;
    dbcbWorkName: TDBComboBox;
    dbeActDate: TDBEdit;
    dblcbRegion: TDBLookupComboBox;
    dblcbExecutor: TDBLookupComboBox;
    dbeObject: TDBEdit;
    dbmFoundation: TDBMemo;
    btnStreet: TButton;
    btnBuilding: TButton;
    dbedPurpose: TDBEdit;
    dbedPrintableAddress: TDBEdit;
    ibsAddressWorks: TIBSQL;
    ibsStreetName: TIBSQL;
    ibsVillageInfo: TIBSQL;
    Label14: TLabel;
    dbeActNumber: TDBEdit;
    btnLoadImage: TButton;
    btnClearImage: TButton;
    dbiImage: TDBImage;
    dbcbPuprose: TDBComboBox;
    procedure btnClearClick(Sender: TObject);
    procedure btnDetailClick(Sender: TObject);
    procedure btnSelectClick(Sender: TObject);
    procedure btnOkClick(Sender: TObject);
    procedure btnStreetClick(Sender: TObject);
    procedure btnBuildingClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure btnLoadImageClick(Sender: TObject);
    procedure btnClearImageClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private
    Query: TIBQuery;
    procedure SetControls;
    procedure InitIBX;
    procedure LoadPurposes;
  end;

function ShowAddress: Boolean;

implementation

{$R *.DFM}

uses
  // System
  Variants, Dialogs,
  // Common
  uCommonUtils, uGC,
  // Project
  Streets, Buildings, uKisAppModule, uKisConsts, uKisClasses,
  uKisSQLClasses, uKisEntityEditor,
  {$IFDEF USE_FIRMS_IN_ADDRESSES}
  uKisFirms,
  {$ELSE}
  uKisContragents,
  {$ENDIF}
  uKisIntf;

const
  SQ_SELECT_PURPOSES = 'SELECT NAME FROM ADDRESS_PURPOSE ORDER BY ID';

function ShowAddress: Boolean;
begin
  with TAddressForm.Create(Application) do
  try
    Query := TIBQuery(dbeOrderDate.DataSource.DataSet);
    with ibsAddressWorks do
    begin
      ExecQuery;
      while not Eof do
      begin
        dbcbWorkName.Items.Add(Fields[0].AsString);
        Next;
      end;
    end;
    LoadPurposes;
    SetControls;
    Result := ShowModal = mrOk;
  finally
    Release;
  end;
end;

procedure TAddressForm.btnClearClick(Sender: TObject);
begin
  with Query do
  begin
    Query.SoftEdit();
    FieldByName(SF_FIRMS_ID).Clear;
    FieldByName(SF_CUSTOMER_NAME).Clear;
  end;
  SetControls;
end;

procedure TAddressForm.SetControls;
begin
  btnDetail.Enabled := not Query.FieldByName(SF_FIRMS_ID).IsNull;
end;

procedure TAddressForm.btnDetailClick(Sender: TObject);
begin
  with KisObject(AppModule[kmFirms].GetEntity(Query.FieldByName(SF_FIRMS_ID).AsInteger)).AEntity as TKisVisualEntity do
  begin
    ReadOnly := True;
    Edit;
  end;
end;

procedure TAddressForm.btnSelectClick(Sender: TObject);
var
{$IFDEF USE_FIRMS_IN_ADDRESSES}
  Firm: TKisFirm;
  FirmId: Integer;
{$ELSE}
  Contragent: TKisContragent;
  ContragentId: Integer;
{$ENDIF}
begin
{$IFDEF USE_FIRMS_IN_ADDRESSES}
  with TKisFirmMngr(AppModule[kmFirms]) do
  begin
    Firm := KisObject(SelectEntity(True, -1, Query.FieldByName(SF_FIRMS_ID).AsInteger)).AEntity as TKisFirm;
    if not Assigned(Firm) then
      Exit;
    if not (Query.State in [dsEdit, dsInsert]) then
      Query.Edit;
    Query.FieldByName(SF_FIRMS_ID).AsInteger := Firm.ID;
    Query.FieldByName(SF_CUSTOMER_NAME).AsString := Firm.ShortName;
  end;
{$ELSE}
  ContragentId := Query.FieldByName(SF_FIRMS_ID).AsInteger;
  with AppModule.SQLMngrs[kmContragents] do
    Contragent := TKisContragent(SelectEntity(True, nil, False, ContragentId));
  if Assigned(Contragent) then
  begin
    Contragent.Forget;
    if not (Query.State in [dsEdit, dsInsert]) then
      Query.Edit;
    Query.FieldByName(SF_FIRMS_ID).AsInteger := Contragent.ID;
    Query.FieldByName(SF_CUSTOMER_NAME).AsString := Contragent.Name;
  end;
{$ENDIF}
  SetControls;
end;

procedure TAddressForm.btnOkClick(Sender: TObject);
var
  D: TDateTime;
begin
{  if Query.FieldByName(SF_ORDER_NUMBER).AsString = '' then
  begin
    MessageBox(Handle, PChar(S_PLEASE_FILL_FIELD + ' "Номер заказа"!'), PChar(S_WARN), MB_ICONWARNING);
    dbeOrderNumber.SetFocus;
    Exit;
  end;}
  if not TryStrToDate(dbeActDate.Text, D) then
  begin
    MessageBox(Handle, PChar(S_CHECK_ACT_DATE), PChar(S_WARN), MB_ICONWARNING);
    dbeOrderDate.SetFocus;
    Exit;
  end;
  if not TryStrToDate(dbeOrderDate.Text, D) then
  begin
    MessageBox(Handle, PChar(S_CHECK_ORDER_DATE), PChar(S_WARN), MB_ICONWARNING);
    dbeOrderDate.SetFocus;
    Exit;
  end;
  if Query.FieldByName(SF_PEOPLE_ID).IsNull then
  begin
    MessageBox(Handle, PChar(S_PLEASE_FILL_FIELD + ' "Исполнитель"!'), PChar(S_WARN), MB_ICONWARNING);
    dblcbExecutor.SetFocus;
    Exit;
  end;
  if Query.FieldByName(SF_WORK_NAME).AsString = '' then
  begin
    MessageBox(Handle, PChar(S_PLEASE_FILL_FIELD + ' "Наименование работ"!'), PChar(S_WARN), MB_ICONWARNING);
    dbcbWorkName.SetFocus;
    Exit;
  end;
  if Query.FieldByName(SF_STREETS_ID).IsNull then
  begin
    MessageBox(Handle, PChar(S_PLEASE_FILL_FIELD + ' "Улица"!'), PChar(S_WARN), MB_ICONWARNING);
    Exit;
  end;
  if Query.FieldByName(SF_BUILDINGS_ID).IsNull then
  begin
    MessageBox(Handle, PChar(S_PLEASE_FILL_FIELD + ' "Строение"!'), PChar(S_WARN), MB_ICONWARNING);
    Exit;
  end;
  if Query.FieldByName(SF_REGIONS_ID).IsNull then
  begin
    MessageBox(Handle, PChar(S_PLEASE_FILL_FIELD + ' "Район"!'), PChar(S_WARN), MB_ICONWARNING);
    dblcbRegion.SetFocus;
    Exit;
  end;
  if Query.FieldByName(SF_CUSTOMER_NAME).IsNull then
  begin
    MessageBox(Handle, PChar(S_PLEASE_FILL_FIELD + ' "Заказчик"!'), PChar(S_WARN), MB_ICONWARNING);
    dblcbRegion.SetFocus;
    Exit;
  end;
  if Query.FieldByName(SF_PURPOSE).IsNull then
  begin
    MessageBox(Handle, PChar(S_PLEASE_FILL_FIELD + ' "Назначение"!'), PChar(S_WARN), MB_ICONWARNING);
    dbcbPuprose.SetFocus;
    Exit;
  end;
    if Query.FieldByName(SF_OBJECT_ADDRESS).IsNull then
  begin
    MessageBox(Handle, PChar(S_PLEASE_FILL_FIELD + ' "Адрес присвоен объекту"!'), PChar(S_WARN), MB_ICONWARNING);
    dbeObject.SetFocus;
    Exit;
  end;
  if Query.FieldByName(SF_ORDER_NUMBER).AsString = '' then
    Query.FieldByName(SF_ORDER_NUMBER).AsString := AppModule.User.GenerateNewAddressOrderNumber;
  if Query.State <> dsBrowse then
  begin
    try
      with TIBQuery.Create(nil) do
      begin
        Forget;
        BufferChunks := 10;
        Transaction := AddressesForm.Transaction;
        SQL.Add('SELECT PRINTABLE_TEXT FROM ADDRESS_WORKS');
        SQL.Add('WHERE WORK_NAME=''' + Query.FieldByName(SF_WORK_NAME).AsString + '''');
        Open;
        Query.FieldByName(SF_PRINTABLE_NAME).Value := IfElse(IsEmpty, '', Fields[0].AsString);
        Close;
      end;
    except
    //  MessageBox(Handle, PChar('Проверьте, все ли данные внесены!'), PChar(S_WARN), MB_ICONWARNING);
    end;
    Query.SoftPost();
    ModalResult := mrOK;
  end
  else
    ModalResult := mrOK;
end;

procedure TAddressForm.btnStreetClick(Sender: TObject);
var
  Id: Integer;
  S: String;
begin
  Id := Query.FieldByName(SF_STREETS_ID).AsInteger;
  if SelectStreet(Id) then
  begin
    Query.SoftEdit();
    Query.FieldByName(SF_STREETS_ID).AsInteger := Id;
    Query.FieldByName(SF_BUILDINGS_ID).Clear;
    Query.FieldByName(SF_VILLAGES_ID).Clear;
    Query.FieldByName(SF_VILLAGES_NAME).Clear;
    Query.FieldByName(SF_VILLAGES_MARKING_NAME).Clear;
    Query.FieldByName(SF_BUILDINGS_NAME).Clear;
    Query.FieldByName(SF_BUILDING_MARKING_NAME).Clear;
    ibsStreetName.Params[N_ZERO].AsInteger := Id;
    ibsStreetName.ExecQuery;
    Query.FieldByName(SF_STREET_NAME).AsString := ibsStreetName.Fields[N_ZERO].AsString;
    Query.FieldByName(SF_STREET_MARKING_NAME).AsString := ibsStreetName.Fields[N_ONE].AsString;
    if not ibsStreetName.Fields[N_TWO].IsNull then
      Query.FieldByName(SF_REGIONS_ID).AsInteger := ibsStreetName.Fields[N_TWO].AsInteger;
    ibsStreetName.Close;
    ibsVillageInfo.Params[N_ZERO].AsInteger := Id;
    ibsVillageInfo.ExecQuery;
    if ibsVillageInfo.RecordCount > N_ZERO then
    begin
      S := ibsVillageInfo.Fields[N_ONE].AsString;
      if S = 'нет' then
      begin
        //Query.FieldByName(SF_VILLAGES_ID).Clear;
        //Query.FieldByName(SF_VILLAGES_NAME).AsString := '';
        //Query.FieldByName(SF_VILLAGES_MARKING_NAME).AsString := '';
      end
      else
      begin
        Query.FieldByName(SF_VILLAGES_ID).AsInteger := ibsVillageInfo.Fields[N_ZERO].AsInteger;
        Query.FieldByName(SF_VILLAGES_NAME).AsString := S;
        Query.FieldByName(SF_VILLAGES_MARKING_NAME).AsString := ibsVillageInfo.Fields[N_TWO].AsString;
      end;
    end;
    ibsVillageInfo.Close;
  end;
end;

procedure TAddressForm.btnBuildingClick(Sender: TObject);
var
  BuildingName, MarkName: String;
  BuildingId: Integer;
begin
  if Query.FieldByName(SF_STREETS_ID).IsNull then
    raise Exception.Create(S_STREET_NOT_SELECTED);
  BuildingName := Query.FieldByName(SF_BUILDINGS_NAME).AsString;
  if ShowBuildings(Query.FieldByName(SF_STREETS_ID).AsInteger,
                   BuildingId, BuildingName, MarkName, True)
  then
  begin
    Query.SoftEdit();
    Query.FieldByName(SF_BUILDINGS_ID).AsInteger := BuildingId;
    Query.FieldByName(SF_BUILDINGS_NAME).AsString := BuildingName;
    Query.FieldByName(SF_BUILDING_MARKING_NAME).AsString := MarkName;
  end;
end;

procedure TAddressForm.InitIBX;
begin
  ibsAddressWorks.Transaction := AddressesForm.Transaction;
  ibsStreetName.Transaction := AddressesForm.Transaction;
  ibsVillageInfo.Transaction := AddressesForm.Transaction;
end;

procedure TAddressForm.FormCreate(Sender: TObject);
begin
  InitIBX;
end;

procedure TAddressForm.btnLoadImageClick(Sender: TObject);
begin
  with IObject(TOpenPictureDialog.Create(Self)).AObject as TOpenPictureDialog do
  begin
    Filter := 'Изображения (*.bmp)|*.BMP';//|Векторные изображения (*.emf)|*.EMF';
    if Execute then
    if FileExists(FileName) then
    begin
      Query.SoftEdit();
      if UpperCase(ExtractFileExt(FileName)) = '.EMF' then
      begin
        dbiImage.Picture.Bitmap := nil;
      end
      else
        dbiImage.Picture.Metafile := nil;
{      BStr := IObject(Query.CreateBlobStream(Query.FieldByName(SF_IMAGE), bmWrite)).AObject as TStream;
      FStr := IObject(TFileStream.Create(Filename, fmShareDenyRead)).AObject as TStream;
      BStr.CopyFrom(FStr, FStr.Size);  }
      dbiImage.Picture.LoadFromFile(FileName);
//      dbiImage.Picture;
    end
    else
      raise Exception.Create(S_FILE + ' ' + FileName + ' ' + S_NOT_FOUND + '!');
  end;
end;

procedure TAddressForm.btnClearImageClick(Sender: TObject);
begin
  Query.SoftEdit();
  dbiImage.Field.Value := Null;
  dbiImage.Picture.Bitmap := nil;
  dbiImage.Picture.Metafile := nil;
end;

procedure TAddressForm.FormShow(Sender: TObject);
begin
  PageControl1.ActivePageIndex := 0;
end;

procedure TAddressForm.LoadPurposes;
begin
  with TIBQuery.Create(Self) do
  begin
    Forget;
    BufferChunks := 10;
    Transaction := AddressesForm.Transaction;
    SQL.Text := SQ_SELECT_PURPOSES;
    Open;
    while not Eof do
    begin
      dbcbPuprose.Items.Add(Fields[0].AsString);
      Next;
    end;
    Close;
  end;
end;

end.
