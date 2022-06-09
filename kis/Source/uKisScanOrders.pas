unit uKisScanOrders;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, DB, ImgList, ActnList, IBCustomDataSet, IBDatabase, Grids, Math,
  DBGrids, StdCtrls, DateUtils,
  uDataSet, uSQLParsers, uCommonClasses,
  uKisSQLClasses, uKisClasses, uKisEntityEditor, uKisFilters;

type
  TKisScanOrderMap = class(TKisEntity)
  private
    FNomenclature: string;
    FInStore: Boolean;
    procedure SetNomenclature(const Value: string);
    procedure SetInStore(const Value: Boolean);
  public
    class function EntityName: String; override;
    procedure Copy(Source: TKisEntity); override;
    function IsEmpty: Boolean; override;
    function Equals(Entity: TKisEntity): Boolean; override;
    procedure Load(DataSet: TDataSet); override;
    //
    property Nomenclature: string read FNomenclature write SetNomenclature;
    /// <summary>
    ///  Имеется в наличии (True) или выдан на руки (False).
    /// </summary>
    property InStore: Boolean read FInStore write SetInStore;
  end;

  TKisScanOrder = class(TKisSQLEntity)
  strict private type
    TMapsCtrlr = class(TKisEntityController)
    private
      function GetMaps(const Index: Integer): TKisScanOrderMap;
    public
      function GetDeleteQueryText: String; override;
      procedure FillFieldDefs(FieldDefsRef: TFieldDefs); override;
      function GetFieldData(Index: Integer; Field: TField; out Data): Boolean; override;
      procedure SetFieldData(Index: Integer; Field: TField; var Data); override;
      property Maps[const Index: Integer]: TKisScanOrderMap read GetMaps;
    end;
  private
    FMapsCtrlr: TMapsCtrlr;
    FMaps: TCustomDataSet;
    FOrderNumber: String;
    FGivedOut: Boolean;
    FWorkType: string;
    FOrderDate: string;
    FReturned: Boolean;
    FAddress: string;
    FOfficeId: Integer;
    FLicensedOrgId: Integer;
    FAnnulled: Boolean;
    FIsNew: Boolean;
    //
    FDeleteDocInWork: Boolean;
    FDocInWorkNumber: string;
    //
    procedure SetAddress(const Value: string);
    procedure SetGivedOut(const Value: Boolean);
    procedure SetOrderDate(const Value: string);
    procedure SetOrderNumber(const Value: string);
    procedure SetReturned(const Value: Boolean);
    procedure SetWorkType(const Value: string);
    function GetMaps: TDataSet;
    procedure SetLicensedOrgId(const Value: Integer);
    procedure SetOfficeId(const Value: Integer);
    procedure SetAnnulled(const Value: Boolean);
    function GetMapObjects(RecNo: Integer): TKisScanOrderMap;
  protected
    function CreateEditor: TKisEntityEditor; override;
    procedure PrepareEditor(Editor: TKisEntityEditor); override;
    procedure UnprepareEditor(Editor: TKisEntityEditor); override;
    procedure LoadDataIntoEditor(Editor: TKisEntityEditor); override;
    procedure ReadDataFromEditor(Editor: TKisEntityEditor); override;
    function CheckEditor(Editor: TKisEntityEditor): Boolean; override;
  public
    constructor Create(Mngr: TKisMngr); override;
    destructor Destroy; override;
    procedure Copy(Source: TKisEntity); override;
    function Equals(Entity: TKisEntity): Boolean; override;
    class function EntityName: String; override;
    function IsEmpty: Boolean; override;
    procedure Load(DataSet: TDataSet); override;
    //
    function FindMap(const Nomenclature: String): TKisScanOrderMap;
    function IsAllMapsInStore(): Boolean;
    //
    property OrderNumber: String read FOrderNumber write SetOrderNumber;
    property OrderDate: string read FOrderDate write SetOrderDate;
    property Address: string read FAddress write SetAddress;
    property WorkType: string read FWorkType write SetWorkType;
    property GivedOut: Boolean read FGivedOut write SetGivedOut;
    property Returned: Boolean read FReturned write SetReturned;
    property Annulled: Boolean read FAnnulled write SetAnnulled;
    property Maps: TDataSet read GetMaps;
    property MapObjects[RecNo: Integer]: TKisScanOrderMap read GetMapObjects;
    //
    property LicensedOrgId: Integer read FLicensedOrgId write SetLicensedOrgId;
    property OfficeId: Integer read FOfficeId write SetOfficeId;
  end;

  TKisScanOrdersMngr = class(TKisSQLMngr)
    dsScanOrders: TIBDataSet;
    dsScanOrdersID: TIntegerField;
    dsScanOrdersORDER_NUMBER: TStringField;
    dsScanOrdersORDER_DATE: TDateField;
    dsScanOrdersYEAR_NUMBER: TStringField;
    dsScanOrdersADDRESS: TStringField;
    dsScanOrdersWORK_TYPE: TStringField;
    dsScanOrdersGIVEDOUT: TIntegerField;
    dsScanOrdersRETURNED: TIntegerField;
    dsScanOrdersANNULLED: TIntegerField;
    dsScanOrdersLICENSED_ORGS_ID: TIntegerField;
    dsScanOrdersOFFICES_ID: TIntegerField;
    dsScanOrdersEXPIRED: TIntegerField;
    dsScanOrdersCUSTOMER: TStringField;
    acLegend: TAction;
    acRenew: TAction;
    procedure acLegendExecute(Sender: TObject);
    procedure acDeleteUpdate(Sender: TObject);
    procedure acRenewExecute(Sender: TObject);
  private
    FLastFilter: IKisFilter;
    function CreateFilterByView(const FilterIndex: Integer): IKisFilter;
    function CreateDateFilter: IKisFilter;
    function CreateYearFilter(const aYear: Integer): IKisFilter;
    procedure DateFilterChange(Sender: TObject);
    function GetOrderYearList: TIntegerList;
    procedure GridCellColors(Sender: TObject; Field: TField;
      var Background, FontColor: TColor; State: TGridDrawState; var FontStyle:TFontStyles);
    procedure GridLogicalColumn(Sender: TObject; Column: TColumn; var IsLogical: Boolean);
    procedure GridGetLogicalValue(Sender: TObject; Column: TColumn; var Value: Boolean);
    procedure SaveMap(Map: TKisScanOrderMap);
    procedure SaveOrder(Order: TKisScanOrder);
    procedure RenewOrder(Id: Integer);
    procedure FillRenewOrder(Source, Target: TKisScanOrder);
    function GetOrder(Id: Integer; Silent: Boolean = False): TKisScanOrder;
    procedure FindAndDeleteMapGiveOut(Order: TKisScanOrder; const aMap: TKisScanOrderMap);
  protected
    procedure Activate; override;
    procedure CreateView; override;
    procedure Deactivate; override;
    function GenEntityID(EntityKind: TKisEntities = keDefault): Integer; override;
    function GetIdent: TKisMngrs; override;
    function GetRefreshSQLText: String; override;
    function GetMainDataSet: TDataSet; override;
    function GetMainSQLText: String; override;
    procedure Locate(AId: Integer; LocateFail: Boolean = False); override;
    function IsSupported(Entity: TKisEntity): Boolean; override;
    procedure PrepareSQLHelper; override;
    procedure ApplyFilters(aFilters: IKisFilters; ClearExisting: Boolean); override;
    function ProcessSQLFilter(aFilter: IKisFilter;
      TheOperation: TKisFilterOperation; Clause: TWhereClause): Boolean; override;
  public
    function GenNewOrderNumber: String;
    function OrderExists(const Number: String; aYear: Integer): Boolean; overload;
    function OrderExists(aConnection: IKisConnection; const Number: String; aYear: Integer): Boolean; overload;
  public
    function CreateEntity(EntityKind: TKisEntities): TKisEntity; override;
    function CreateNewEntity(EntityKind: TKisEntities = keDefault): TKisEntity; override;
    function CurrentEntity: TKisEntity; override;
    procedure DeleteEntity(Entity: TKisEntity); override;
    function GetEntity(EntityID: Integer; EntityKind: TKisEntities = keDefault): TKisEntity; override;
    function IsEntityInUse(Entity: TKisEntity): Boolean; override;
    procedure SaveEntity(Entity: TKisEntity); override;
    //
    function GetLastOrder(const Nomenclature: String): TKisScanOrder;
  end;

implementation

{$R *.dfm}

uses
  uIBXUtils,
  uDBGrid, uGC,
  uKisAppModule, uKisConsts, uKisSearchClasses, uKisUtils, uKisIntf,
  uKisExceptions,
  uKisScanOrderEditor, uKisScanOrdersView, uKisMapScans;

resourcestring
  SG_SCAN_ORDERS = 'SCAN_ORDERS';
  SG_SCAN_ORDER_MAPS = 'SCAN_ORDER_MAPS';

  SFLTR_ORDER_YEAR = '{3923B610-277C-4669-8158-641C65DBD04E}';

  SQ_MAIN =
    'SELECT '
  + '  SO.ID, SO.ORDER_DATE, SO.ORDER_NUMBER, SO.YEAR_NUMBER, SO.ADDRESS,'
  + '  SO.WORK_TYPE, SO.LICENSED_ORGS_ID,'
  + '  SO.OFFICES_ID, SO.GIVEDOUT, SO.RETURNED, SO.ANNULLED, SO.EXPIRED,'
  + '  SO.CUSTOMER '
  + 'FROM '
  + '  SCAN_ORDERS_ALL_VIEW_2 SO '
  + '  LEFT JOIN '
  + '  OFFICES O '
  + '  ON (SO.OFFICES_ID = O.ID) '
  + '  LEFT JOIN '
  + '  LICENSED_ORGS LO '
  + '  ON (SO.LICENSED_ORGS_ID=LO.ID)';
  SQ_GET_SCAN_ORDER_MAP_LIST_ID =
    'SELECT SOM.ID '
  + 'FROM SCAN_ORDER_MAPS SOM '
  + 'WHERE SOM.SCAN_ORDERS_ID=%d';
//    'SELECT * FROM SCAN_ORDER_MAPS WHERE SCAN_ORDERS_ID=%d';
  SQ_GET_MAX_ORDER_NUMBER_ID =
    'SELECT MAX(ID) FROM SCAN_ORDERS '
  + 'WHERE EXTRACT(YEAR FROM ORDER_DATE) = EXTRACT(YEAR FROM CURRENT_DATE)';
  SQ_ALL_ORDER_NUMBERS_FOR_YEAR =
    'SELECT ORDER_NUMBER FROM SCAN_ORDERS '
  + 'WHERE EXTRACT(YEAR FROM ORDER_DATE) = EXTRACT(YEAR FROM CURRENT_DATE)';
  SQ_SCAN_ORDER_BY_NUMBER_AND_YEAR =
    'SELECT ID FROM SCAN_ORDERS '
  + 'WHERE (ORDER_NUMBER = :ORDER_NUMBER) AND (EXTRACT(YEAR FROM ORDER_DATE) = :AYEAR)';
  SQ_SAVE_SCAN_ORDER =
    'EXECUTE PROCEDURE SAVE_SCAN_ORDER'
  + '(:ID, :ORDER_DATE, :ORDER_NUMBER, :ADDRESS, :WORK_TYPE, :OFFICES_ID, :LICENSED_ORGS_ID, :ANNULLED)';
  SQ_DELETE_SCAN_ORDER =
    'DELETE FROM SCAN_ORDERS WHERE ID=%d';
  SQ_DELETE_SCAN_ORDER_MAP =
    'DELETE FROM SCAN_ORDER_MAPS WHERE ID=%d';
  SQ_SELECT_SCAN_ORDER =
    'SELECT * FROM SCAN_ORDERS_ALL_VIEW_2 WHERE ID=%d';
  SQ_SELECT_SCAN_ORDER_MAP =
    'SELECT SOM.*, MS.GIVE_STATUS '
  + 'FROM SCAN_ORDER_MAPS SOM '
  + '     LEFT JOIN '
  + '     MAP_SCANS MS ON (SOM.NOMENCLATURE = MS.NOMENCLATURE)'
  + 'WHERE SOM.ID=%d';
//    'SELECT * FROM SCAN_ORDER_MAPS WHERE ID=%d';
  SQ_INSERT_SCAN_ORDER_MAP =
    'INSERT INTO SCAN_ORDER_MAPS (ID, SCAN_ORDERS_ID, NOMENCLATURE) '
  + 'VALUES (:ID, :SCAN_ORDERS_ID, :NOMENCLATURE)';
  SQ_GET_LAST_ORDER_ID =
    'SELECT MAX(SCAN_ORDERS_ID) '
  + 'FROM SCAN_ORDER_MAPS '
  + 'WHERE NOMENCLATURE = :NOMENCLATURE';
  SQ_GET_ORDER_YEAR_LIST =
    'SELECT DISTINCT(EXTRACT(YEAR FROM ORDER_DATE)) '
  + 'FROM SCAN_ORDERS_ALL_VIEW '
  + 'ORDER BY 1 DESCENDING';

{ TKisScanOrdersMngr }

procedure TKisScanOrdersMngr.acDeleteUpdate(Sender: TObject);
begin
  inherited;
  acDelete.Enabled := acDelete.Enabled and (dsScanOrdersRETURNED.AsInteger = 0)
    and (dsScanOrdersGIVEDOUT.AsInteger = 0);
end;

procedure TKisScanOrdersMngr.acLegendExecute(Sender: TObject);
begin
  inherited;
  with FView do
    Legend.ShowLegend(ClientHeight - Legend.FormHeight,
                      ClientWidth - Legend.FormWidth - 10);
end;

procedure TKisScanOrdersMngr.acRenewExecute(Sender: TObject);
begin
  inherited;
  RenewOrder(dsScanOrdersID.AsInteger);
end;

procedure TKisScanOrdersMngr.Activate;
begin
  inherited;
  dsScanOrders.Transaction := AppModule.Pool.Get;
  dsScanOrders.Transaction.Init();
  dsScanOrders.Transaction.AutoStopAction := saNone;
  Reopen;
end;

procedure TKisScanOrdersMngr.ApplyFilters(aFilters: IKisFilters;
  ClearExisting: Boolean);
var
  Fltr: IKisFilter;
  Idx: Integer;
begin
  if Assigned(FView) then
  begin
    if not Assigned(aFilters) then
      aFilters := TFilterFactory.CreateList();
    Fltr := aFilters.Find(SF_DOC_DATE);
    Idx := TKisScanOrdersView(FView).cbDateFilter.ItemIndex;
    if Idx >= 1 then
    begin
      if not Assigned(Fltr) then
      begin
        FLastFilter := CreateFilterByView(Idx);
        aFilters.Add(FLastFilter);
      end;
    end;
  end;
  inherited ApplyFilters(aFilters, ClearExisting);
end;

function TKisScanOrdersMngr.CreateDateFilter: IKisFilter;
begin
  Result := TFilterFactory.CreateFilter(SF_DOC_DATE, IncYear(Date, -1), frNone)
end;

function TKisScanOrdersMngr.CreateEntity(EntityKind: TKisEntities): TKisEntity;
begin
  case EntityKind of
  keDefault, keScanOrder :
    begin
      Result := TKisScanOrder.Create(Self);
    end;
  keScanOrderMap :
    begin
      Result := TKisScanOrderMap.Create(Self);
    end;
  else
    Result := nil;
  end;
end;

function TKisScanOrdersMngr.CreateFilterByView(
  const FilterIndex: Integer): IKisFilter;
var
  aYear: Integer;
begin
  if FilterIndex = 1 then
    Result := CreateDateFilter
  else
  if FilterIndex > 1 then
  begin
    aYear := Integer(TKisScanOrdersView(FView).cbDateFilter.Items.Objects[FilterIndex]);
    Result := CreateYearFilter(aYear);
  end
  else
    Result := nil;
end;

function TKisScanOrdersMngr.CreateNewEntity(EntityKind: TKisEntities): TKisEntity;
begin
  Result := CreateEntity(EntityKind);
  if Assigned(Result) then
  begin
    Result.ID := Self.GenEntityID(EntityKind);
    if Result is TKisScanOrder then
      TKisScanOrder(Result).FIsNew := True;
  end
  else
    raise Exception.Create(S_CANT_CREATE_NEW_ENTITY);
end;

procedure TKisScanOrdersMngr.CreateView;
var
  L: TIntegerList;
  I, aYear: Integer;
begin
  if not Assigned(FView) then
  begin
    FView := TKisScanOrdersView.Create(Self);
//    ReadReports;
  end;
  inherited CreateView;
  FView.Caption := 'Заявки на выдачу сканов планшетов 1:500';  //заголовок формы
  FView.Grid.OnCellColors := GridCellColors;
  FView.Grid.OnLogicalColumn := GridLogicalColumn;
  FView.Grid.OnGetLogicalValue := GridGetLogicalValue;
  with FView.Legend do
  begin
    ItemOffset := 8;
    Caption := 'Цвета';
    with Items.Add do
    begin
      Color := clWindow;
      Caption := 'Заявка пока не обработана';
    end;
    with Items.Add do
    begin
      Color := $99FFFF;
      Caption := 'Сканы выданы';
    end;
    with Items.Add do
    begin
      Color := $CCFFCC;
      Caption := 'Сканы возвращены';
    end;
    with Items.Add do
    begin
      Color := $9999FF;
      Caption := 'Заявка просрочена';
    end;
    with Items.Add do
    begin
      Color := clSilver;
      Caption := 'Заявка аннулирована';
    end;
  end;
  //
  FView.ToolBarNav.Visible := True;
  //
  with TKisScanOrdersView(FView) do
  begin
    L := GetOrderYearList;
    try
      for I := 0 to Min(L.Count - 1, 9) do
      begin
        aYear := L[I];
        cbDateFilter.Items.AddObject('за ' + IntToStr(aYear) + ' год', TObject(aYear));
      end;
    finally
      FreeAndNil(L);
    end;
    cbDateFilter.OnChange := DateFilterChange;
  end;
end;

function TKisScanOrdersMngr.CreateYearFilter(const aYear: Integer): IKisFilter;
begin
  Result := TFilterFactory.CreateFilter(SFLTR_ORDER_YEAR, aYear, frEqual);
end;

function TKisScanOrdersMngr.CurrentEntity: TKisEntity;
begin
  Result := GetEntity(dsScanOrdersID.AsInteger);
  if Assigned(Result) then
    Result.Modified := False;
end;

procedure TKisScanOrdersMngr.DateFilterChange(Sender: TObject);
var
  Combo: TComboBox;
  OldCursor: TCursor;
begin
  if Sender is TComboBox then
  begin
    Combo := TComboBox(Sender);
    OldCursor := FView.Cursor;
    FView.Cursor := crSQLWait;
    try
      if Combo.ItemIndex >= 1 then
      begin
        FLastFilter := CreateFilterByView(Combo.ItemIndex);
        ApplyFilters(TFilterFactory.CreateList(FLastFilter), True);
      end
      else
      begin
        if Assigned(FLastFilter) then
          CancelFilters(TFilterFactory.CreateList(FLastFilter));
      end;
    finally
      FView.Cursor := OldCursor;
    end;
  end;
end;

procedure TKisScanOrdersMngr.Deactivate;
begin
  inherited;
  dsScanOrders.Close;
  if not dsScanOrders.Transaction.Active then
    dsScanOrders.Transaction.Commit;
  AppModule.Pool.Back(dsScanOrders.Transaction);
end;

procedure TKisScanOrdersMngr.DeleteEntity(Entity: TKisEntity);
var
  Conn: IKisConnection;
  S: String;
begin
  Conn := GetConnection(True, True);
  if IsEntityInUse(Entity) then
    inherited
  else
    try
      if Entity is TKisScanOrderMap then
        S := SQ_DELETE_SCAN_ORDER_MAP
      else
      if Entity is TKisScanOrder then
        S := SQ_DELETE_SCAN_ORDER;
      //
      Conn.GetDataSet(Format(S, [Entity.ID])).Open;
      FreeConnection(Conn, True);
    except
      FreeConnection(Conn, False);
      raise;
    end;
end;

procedure TKisScanOrdersMngr.FillRenewOrder(Source, Target: TKisScanOrder);
begin
  Target.FMapsCtrlr.DirectClear;
  Target.FMapsCtrlr.ClearDeleted;
  Target.OrderNumber := '';
  Target.GivedOut := False;
  Target.WorkType := Source.WorkType;
  Target.OrderDate := DateToStr(Now);
  Target.Returned := False;
  Target.Address := Source.Address;
  Target.OfficeId := Source.OfficeId;
  Target.LicensedOrgId := Source.LicensedOrgId;
  Target.Annulled := False;
  //
  Source.Maps.First;
  while not Source.Maps.Eof do
  begin
    Target.Maps.Append;
    Target.Maps.FieldByName(SF_NOMENCLATURE).AsString := Source.Maps.FieldByName(SF_NOMENCLATURE).AsString;
    Target.Maps.Post;
    Source.Maps.Next;
  end;
end;

var
  OrderId1, MapScanId1: Integer;
  
function IsMyGiveOut(Gout: TKisMapScanGiveOut): Boolean;
begin
  Result := (Gout.OrdersId = OrderId1) and (Gout.ScanOrderMapId = MapScanId1);
end;

function IsMyGiveOut2(Gout: TKisMapScanGiveOut): Boolean;
begin
  Result := (Gout.OrdersId = 0) and (Gout.ScanOrderMapId = MapScanId1);
end;

procedure TKisScanOrdersMngr.FindAndDeleteMapGiveOut(Order: TKisScanOrder; const aMap: TKisScanOrderMap);
var
  ScanMngr: TKisMapScansMngr;
  Scan: TKisMapScan;
  B: Boolean;
  Value: Variant;
  ScanId: Integer;
  Gout: TKisMapScanGiveOut;
begin
  if aMap.Id = 0 then
    Exit;
  // Надо проверить, есть ли выдача
  // Получаем менеджер
  ScanMngr := AppModule.Mngrs[kmMapScans] as TKisMapScansMngr;
  // Получаем объект - скан
  B := AppModule.GetFieldValue(
          Self.DefaultTransaction,
          ST_MAP_SCANS_GIVEOUTS,
          SF_SCAN_ORDER_MAPS_ID,
          SF_MAP_SCANS_ID,
          aMap.ID,
          Value);
  if B then
  begin
    ScanId := Value;
    Scan := ScanMngr.GetEntity(ScanId) as TKisMapScan;
    Scan.Forget();
    Gout := nil;
    if not Scan.GiveOuts.IsEmpty then
    begin
      // Получаем объект - выдачу
      OrderId1 := Order.ID;
      MapScanId1 := aMap.Id;
      Gout := Scan.FindGiveOut(IsMyGiveOut, True);
      if Gout = nil then
        Gout := Scan.GetGiveOut(Scan.GiveOuts.RecordCount);
      if Gout = nil then
        Gout := Scan.FindGiveOut(IsMyGiveOut2, True);

      if Assigned(Gout) and (Gout.ScanOrderMapId <> aMap.Id) then
        Gout := nil;
    end;
    // Если выдача есть, то её надо удалить
    if (Gout = nil) or (Gout.DateOfBack <> '') then
    begin
      raise EKisException.Create(
        'Для планшета ' + aMap.Nomenclature + ' по заявке ' + Order.OrderNumber + ' от ' + Order.OrderDate + ' не найдена подходящая выдача!'
      );
    end;
    if Gout.Annulled then
    begin
      raise EKisException.Create(
        'Для планшета ' + aMap.Nomenclature + ' по заявке ' + Order.OrderNumber + ' от ' + Order.OrderDate + ' выдача уже аннулирована!'
      );
    end;
    //
    if Assigned(Scan) then
    begin
      Scan.RemoveGiveOut(Gout);
//      Scan.GiveOuts.Last;
//      Scan.GiveOuts.Delete;
      Scan.Modified := True;
      ScanMngr.SaveEntity(Scan);
    end;
  end;
end;

function TKisScanOrdersMngr.GenEntityID(EntityKind: TKisEntities): Integer;
begin
  case EntityKind of
    keDefault, keScanOrder :
      Result := AppModule.GetID(SG_SCAN_ORDERS, Self.DefaultTransaction);
    keScanOrderMap :
      Result := AppModule.GetID(SG_SCAN_ORDER_MAPS, Self.DefaultTransaction);
  else
    Result := -1;
  end;
end;

function TKisScanOrdersMngr.GenNewOrderNumber: String;
var
  Conn: IKisConnection;
  DataSet: TDataSet;
  LastOrderId, I: Integer;
//  PrevNum,
  Num: string;
//  UsedNumbers: TStringList;
begin
  Result := '';
  Conn := GetConnection(True, True);
  try
    DataSet := Conn.GetDataSet(SQ_GET_MAX_ORDER_NUMBER_ID);
    DataSet.Open;
    LastOrderId := DataSet.Fields[0].AsInteger;
    DataSet.Close;
    if LastOrderId > 0 then
    begin
      DataSet := Conn.GetDataSet(Format(SQ_SELECT_SCAN_ORDER, [LastOrderId]));
      DataSet.Open;
      if DataSet.RecordCount > 0 then
        Num := DataSet.FieldByName(SF_ORDER_NUMBER).AsString;
      DataSet.Close;
    end;
    if Num = '' then
      Num := '0';
    I := 0;
    repeat
      Num := GetNextNumber2(Num);
      Inc(I);
      if I > 10000 then
        Break;
    until not OrderExists(Conn, Num, CurrentYear);
    Result := Num;
    // ищем пропущенные
//    PrevNum := GetPrevNumber2(Result);
//    if PrevNum <> Num then
//    begin
//      UsedNumbers := TStringList.Create;
//      try
//        DataSet := Conn.GetDataSet(SQ_ALL_ORDER_NUMBERS_FOR_YEAR);
//        DataSet.Open;
//        while not DataSet.Eof do
//        begin
//          UsedNumbers.Add(DataSet.Fields[0].AsString);
//          DataSet.Next;
//        end;
//        DataSet.Close;
//        //
//        UsedNumbers.Sorted := True;
//        //
//        I := 0;
//        repeat
//          if (UsedNumbers.IndexOf(PrevNum) < 0)
//             and
//             not AppModule.ExistsDocInWork(PrevNum)
//          then
//          begin
//            Result := PrevNum;
//            Break;
//          end
//          else
//          begin
//            Num := PrevNum;
//            PrevNum := GetPrevNumber2(Num);
//          end;
//          // антизацикливание
//          Inc(I);
//          if I > 10000 then
//            Break;
//        until Num = PrevNum;
//      finally
//        FreeAndNil(UsedNumbers);
//      end;
//    end;

    FreeConnection(Conn, True);
  except
    FreeConnection(Conn, False);
    raise;
  end;
end;

function TKisScanOrdersMngr.GetEntity(EntityID: Integer;
  EntityKind: TKisEntities): TKisEntity;
var
  DataSet: TDataSet;
  Conn: IKisConnection;
  SQLText: String;
begin
  Result := nil;
  Conn := GetConnection(True, False);
  try
    case EntityKind of
    keDefault, keScanOrder :
      SQLText := Format(SQ_SELECT_SCAN_ORDER, [EntityID]);
    keScanOrderMap :
      SQLText := Format(SQ_SELECT_SCAN_ORDER_MAP, [EntityID]);
    else
      raise ELoadEntity.Create(EntityID, EntityKind);
    end;
    DataSet := Conn.GetDataSet(SQLText);
    DataSet.Open;
    if not DataSet.IsEmpty then
    begin
      Result := CreateEntity(EntityKind);
      Result.Load(DataSet);
    end
    else
      raise ELoadEntity.Create(EntityID, EntityKind);
  finally
    FreeConnection(Conn, True);
  end;
end;

function TKisScanOrdersMngr.GetIdent: TKisMngrs;
begin
  Result := kmScanOrders;
end;

function TKisScanOrdersMngr.GetLastOrder(
  const Nomenclature: String): TKisScanOrder;
var
  Conn: IKisConnection;
  DataSet: TDataSet;
begin
  Result := nil;
  Conn := GetConnection(True, True);
  try
    DataSet := Conn.GetDataSet(SQ_GET_LAST_ORDER_ID);
    Conn.SetParam(DataSet, SF_NOMENCLATURE, Nomenclature);
    DataSet.Open;
    if DataSet.Fields[0].AsInteger > 0 then
      Result := GetEntity(DataSet.Fields[0].AsInteger) as TKisScanOrder;
    DataSet.Close;

    FreeConnection(Conn, True);
  except
    FreeConnection(Conn, False);
    raise;
  end;
end;

function TKisScanOrdersMngr.GetMainDataSet: TDataSet;
begin
  Result := dsScanOrders;
end;

function TKisScanOrdersMngr.GetMainSQLText: String;
begin
  Result := SQ_MAIN;
end;

function TKisScanOrdersMngr.GetOrder(Id: Integer; Silent: Boolean = False): TKisScanOrder;
var
  Ent: TKisEntity;
begin
  Ent := GetEntity(Id);
  if (Ent = nil) or not (Ent is TKisScanOrder) then
  begin
    if Silent then
      raise EKisException.Create('Заявка с ID ' + IntToStr(Id) + ' не найдена!')
    else
      Result := nil;
  end
  else
    Result := TKisScanOrder(Ent);
end;

function TKisScanOrdersMngr.GetOrderYearList: TIntegerList;
var
  Conn: IKisConnection;
  DataSet: TDataSet;
begin
  Result := TIntegerList.Create;
  Conn := GetConnection(True, True);
  try
    DataSet := Conn.GetDataSet(SQ_GET_ORDER_YEAR_LIST);
    DataSet.Open;
    while not DataSet.Eof do
    begin
      Result.Add(DataSet.Fields[0].AsInteger, False);
      DataSet.Next;
    end;
    DataSet.Close;

    FreeConnection(Conn, True);
  except
    FreeConnection(Conn, False);
    raise;
  end;
end;

function TKisScanOrdersMngr.GetRefreshSQLText: String;
begin
  Result := GetMainSQLText + ' WHERE SO.ID=:ID';
end;

procedure TKisScanOrdersMngr.GridCellColors(Sender: TObject; Field: TField;
  var Background, FontColor: TColor; State: TGridDrawState;
  var FontStyle: TFontStyles);
begin
  if Sender is TkaDBGrid then
    if (gdSelected in State) or (gdFocused in State) then
    begin
      Background := clHighlight;
      FontColor := clWindow;
    end
    else
    begin
      if dsScanOrdersANNULLED.AsInteger = 1 then
      begin
        BackGround := clSilver;
      end
      else
      if dsScanOrdersRETURNED.AsInteger = 1 then
      begin
        BackGround := $CCFFCC;
      end
      else
      if dsScanOrdersEXPIRED.AsInteger = 1 then
      begin
        BackGround := $9999FF;
      end
      else
      if dsScanOrdersGIVEDOUT.AsInteger = 1 then
      begin
        BackGround := $99FFFF;
        FontColor := clNavy;
      end;
    end;
end;

procedure TKisScanOrdersMngr.GridGetLogicalValue(Sender: TObject;
  Column: TColumn; var Value: Boolean);
begin
  Value := Boolean(Column.Field.AsInteger);
end;

procedure TKisScanOrdersMngr.GridLogicalColumn(Sender: TObject; Column: TColumn;
  var IsLogical: Boolean);
begin
  IsLogical := (Column.Field = dsScanOrdersRETURNED) or
    (Column.Field = dsScanOrdersGIVEDOUT) or
    (Column.Field = dsScanOrdersANNULLED) or
    (Column.Field = dsScanOrdersEXPIRED);
end;

function TKisScanOrdersMngr.IsEntityInUse(Entity: TKisEntity): Boolean;
begin
  Result := False;
end;

function TKisScanOrdersMngr.IsSupported(Entity: TKisEntity): Boolean;
begin
  Result := Assigned(Entity) and ((Entity is TKisScanOrder) or (Entity is TKisScanOrderMap));
  if not Result then
    inherited IsSupported(Entity);
end;

procedure TKisScanOrdersMngr.Locate(AId: Integer; LocateFail: Boolean);
var
  R: Integer;
begin
  inherited;
  dsScanOrders.DisableControls;
  try
    R := dsScanOrders.RecNo;
    if not dsScanOrders.Locate(SF_ID, AId, []) then
      dsScanOrders.RecNo := R;
  finally
    dsScanOrders.EnableControls;
  end;
end;

function TKisScanOrdersMngr.OrderExists(const Number: String; aYear: Integer): Boolean;
var
  Conn: IKisConnection;
begin
  Conn := GetConnection(True, False);
  try
    Result := OrderExists(Conn, Number, aYear);
  finally
    FreeConnection(Conn, True);
  end;
end;

function TKisScanOrdersMngr.OrderExists(aConnection: IKisConnection; const Number: String; aYear: Integer): Boolean;
var
  Ds: TDataSet;
begin
  Ds := aConnection.GetDataSet(SQ_SCAN_ORDER_BY_NUMBER_AND_YEAR);
  aConnection.SetParam(Ds, SF_ORDER_NUMBER, Number);
  aConnection.SetParam(Ds, SF_AYEAR, aYear);
  Ds.Open;
  Result := not Ds.IsEmpty;
  Ds.Close;
end;

procedure TKisScanOrdersMngr.PrepareSQLHelper;
var
  I: Integer;
begin
  inherited;
  with FSQLHelper.AddTable do
  begin
    TableName := ST_SCAN_ORDERS_ALL_VIEW_2;
    TableLabel := 'Основная (заявки на сканы)';
    AddStringField(SF_ORDER_NUMBER, 'Номер заявки', 12, [fpSearch, fpSort, fpQuickSearch]);
    AddSimpleField(SF_ORDER_DATE, 'Дата заявки', ftDate, [fpSearch, fpSort]);
    AddStringField(SF_YEAR_NUMBER, SFL_YEAR_NUMBER, 17, [fpSearch, fpSort, fpQuickSearch]);
    AddStringField(SF_CUSTOMER, SFL_CUSTOMER, 1000, [fpSearch, fpSort, fpQuickSearch]);
    AddStringField(SF_ADDRESS, SFL_ADDRESS, 1000, [fpSearch, fpSort, fpQuickSearch]);
    AddStringField(SF_WORK_TYPE, 'Вид работ', 300, [fpSearch, fpSort, fpQuickSearch]);
    AddSimpleField(SF_GIVEDOUT, 'Выдано', ftBoolean, [fpSearch, fpSort]);
    AddSimpleField(SF_RETURNED, 'Принято', ftBoolean, [fpSearch, fpSort]);
    AddSimpleField(SF_ANNULLED, 'Аннулировано', ftBoolean, [fpSearch, fpSort]);
    AddSimpleField(SF_EXPIRED, 'Просрочено', ftBoolean, [fpSearch, fpSort]);
    I := AddSimpleField(SF_ID, SFL_ID, ftInteger, [fpSort]);
  end;
  with FSQLHelper.AddLinkedTable do
  begin
    TableName := ST_SCAN_ORDER_MAPS;
    TableLabel := 'Планшеты';
    MasterField := FSQLHelper.Tables[0].Fields[I];
    AddStringField(SF_NOMENCLATURE, SFL_NOMENCLATURE, 20, [fpSearch]);
    I := AddSimpleField(SF_SCAN_ORDERS_ID, '', ftInteger, []);
    DetailField := Fields[I];
  end;
end;

function TKisScanOrdersMngr.ProcessSQLFilter(aFilter: IKisFilter;
  TheOperation: TKisFilterOperation; Clause: TWhereClause): Boolean;
var
  FltrName: string;
  Condition: TSQLCondition;
begin
  Result := False;
  FltrName := (aFilter as IKisNamedObject).Name;
  if TheOperation = foAddSQL then
  begin
    if (FltrName = SF_DOC_DATE) then
    begin
      Condition := TSQLCondition.Create;
      Condition.Text := 'SO.ORDER_DATE' + '>=''' + VarToStr(aFilter.Value) + '''';
      if Clause.PartCount = 0 then
        Condition.TheOperator := coNone
      else
        Condition.TheOperator := coAnd;
      Condition.Comment := FltrName;
      Clause.AddCondition(Condition);
      Result := True;
    end
    else
    if (FltrName = SFLTR_ORDER_YEAR) then
    begin
      Condition := TSQLCondition.Create;
      Condition.Text := 'EXTRACT(YEAR FROM SO.ORDER_DATE)=' + VarToStr(aFilter.Value);
      if Clause.PartCount = 0 then
        Condition.TheOperator := coNone
      else
        Condition.TheOperator := coAnd;
      Condition.Comment := FltrName;
      Clause.AddCondition(Condition);
      Result := True;
    end;
  end;
  if not Result then
    Result := inherited ProcessSQLFilter(aFilter, TheOperation, Clause);
end;

procedure TKisScanOrdersMngr.RenewOrder;
var
  Ent: TKisEntity;
  Order: TKisScanOrder;
  NewOrder: TKisScanOrder;
  OrderIsActive: Boolean;
begin
  Order := GetOrder(Id);
  // DONE : ИС#14. Открываем текущую заявку. Если она закрыта, то просто создаём такую же и показываем в редакторе. Если польщзователь нажал ОК, то сохраняем и обновляем экран.

  // DONE : ИС#14. Если текущая не закрыта, то аннулируем и создаём копию и редактируем.
  OrderIsActive := Order.Annulled or Order.Returned;
  if OrderIsActive then
  begin
//    Order.Annulled := True;
//    SaveOrder(Order);
//    dsScanOrders.Refresh;
  end;
  //
  Ent := CreateNewEntity(keScanOrder);
  NewOrder := Ent as TKisScanOrder;
  FillRenewOrder(Order, NewOrder);
  if NewOrder.Edit then
  begin
    SaveEntity(NewOrder);
    Reopen;
    Locate(NewOrder.ID);
  end;
  // TODO : ИС#14. После сохранения какого-то нового объекта, надо иметь возможность отправить в открытые окна сигнал о том, что этот объект может там появиться. Например заявка на выдау сканов появляется в окне учеёт сканов
end;

procedure TKisScanOrdersMngr.SaveEntity(Entity: TKisEntity);
begin
  inherited;
  if Assigned(Entity) then
  if IsSupported(Entity) then
  if (Entity is TKisScanOrder) then
       SaveOrder(TKisScanOrder(Entity))
  else
    if (Entity is TKisScanOrderMap) then
       SaveMap(TKisScanOrderMap(Entity));
end;

procedure TKisScanOrdersMngr.SaveMap(Map: TKisScanOrderMap);
var
  Conn: IKisConnection;
  DataSet: TDataSet;
begin
  Conn := GetConnection(True, True);
  try
    DataSet := Conn.GetDataSet(Format(SQ_DELETE_SCAN_ORDER_MAP, [Map.ID]));
    DataSet.Open;
    //
    DataSet := Conn.GetDataSet(SQ_INSERT_SCAN_ORDER_MAP);
    if Map.ID < 1 then
      Map.ID := Self.GenEntityID(keScanOrderMap);
    Conn.SetParam(DataSet, SF_ID, Map.ID);
    Conn.SetParam(DataSet, SF_SCAN_ORDERS_ID, Map.HeadId);
    Conn.SetParam(DataSet, SF_NOMENCLATURE, Map.Nomenclature);
    DataSet.Open;
    //
    FreeConnection(Conn, True);
  except
    FreeConnection(Conn, False);
    raise;
  end;
end;

procedure TKisScanOrdersMngr.SaveOrder(Order: TKisScanOrder);
var
  I: Integer;
  Conn: IKisConnection;
  DataSet: TDataSet;
  V: Variant;
begin
  Conn := GetConnection(True, True);
  try
    DataSet := Conn.GetDataSet(SQ_SAVE_SCAN_ORDER);
    if Order.ID < 1 then
      Order.ID := Self.GenEntityID(keScanOrder);
    Conn.SetParam(DataSet, SF_ID, Order.ID);
    Conn.SetParam(DataSet, SF_ORDER_NUMBER, Order.OrderNumber);
    Conn.SetParam(DataSet, SF_ORDER_DATE, Order.OrderDate);
    Conn.SetParam(DataSet, SF_ADDRESS, Order.Address);
    Conn.SetParam(DataSet, SF_WORK_TYPE, Order.WorkType);
    Conn.SetParam(DataSet, SF_ANNULLED, Integer(Order.Annulled));
    if Order.LicensedOrgId < 1 then
      V := null
    else
      V := Order.LicensedOrgId;
    Conn.SetParam(DataSet, SF_LICENSED_ORGS_ID, V);
    if Order.OfficeId < 1 then
      V := null
    else
      V := Order.OfficeId;
    Conn.SetParam(DataSet, SF_OFFICES_ID, V);
    //SF_IS_SECRET
    DataSet.Open;
    Order.FIsNew := False;
    // Сохраняем список выдачи планшетов
    with Order.FMapsCtrlr do
    begin
      for I := 0 to Pred(DeletedCount) do
      begin
        FindAndDeleteMapGiveOut(Order, TKisScanOrderMap(DeletedElements[I]));
        Self.DeleteEntity(DeletedElements[I]);
      end;
      for I := 1 to Count do
      begin
        if Elements[I].Modified then
          Self.SaveEntity(Elements[I]);
      end;
    end;
    //
    FreeConnection(Conn, True);
  except
    FreeConnection(Conn, False);
    raise;
  end;
end;

{ TKisScanOrder }

function TKisScanOrder.CheckEditor(Editor: TKisEntityEditor): Boolean;
var
  D: TDateTime;
  B: Boolean;
begin
  Result := False;
  if Editor is TKisScanOrderEditor then
    with TKisScanOrderEditor(Editor) do
    begin
       if not StrIsNumberOrLetter(edNumber.Text) then
       begin
         AppModule.Alert('Неверный номер!');
         edNumber.SetFocus;
         Exit;
       end;
       if not TryStrToDate(edDate.Text, D) then
       begin
         AppModule.Alert('Неверная дата!');
         edDate.SetFocus;
         Exit;
       end;
       if Trim(edAddress.Text) = '' then
       begin
         AppModule.Alert('Необходимо указать адрес!');
         edAddress.SetFocus;
         Exit;
       end;
       if Trim(cbWorkType.Text) = '' then
       begin
         AppModule.Alert('Необходимо указать вид работ!');
         cbWorkType.SetFocus;
         Exit;
       end;
       if RadBtnOrgs.Checked and (LicensedOrgId < 1) then
       begin
         AppModule.Alert('Необходимо указать организацию!');
         edOrgname.SetFocus;
         Exit;
       end;
       if RadBtnMP.Checked and (OfficeId < 1) then
       begin
         AppModule.Alert('Необходимо указать отдел!');
         cbOffices.SetFocus;
         Exit;
       end;
       if Maps.RecordCount = 0 then
       begin
         AppModule.Alert('Не указаны планшеты для выдачи!');
         edNomenclature.SetFocus;
         Exit;
       end;
       //
       if FIsNew then
       begin
         B := TKisScanOrdersMngr(Self.Manager).OrderExists(edNumber.Text, YearOf(D));
         if B then
         begin
           AppModule.Alert('Заявка с таким номером уже существует!');
           edNomenclature.SetFocus;
           Exit;
         end;
       end;
       //
       Result := True;
    end;
end;

procedure TKisScanOrder.Copy(Source: TKisEntity);
var
  So: TKisScanOrder;
begin
  inherited;
  So := Source as TKisScanOrder;
  FOrderNumber := So.FOrderNumber;
  FGivedOut := So.FGivedOut;
  FWorkType := So.FWorkType;
  FOrderDate := So.FOrderDate;
  FReturned := So.FReturned;
  FAddress := So.FAddress;
  FAnnulled := So.FAnnulled;
  FLicensedOrgId := So.FLicensedOrgId;
  FOfficeId := So.FOfficeId;
  //
  FMapsCtrlr.DirectClear;
  CopyDataSet(So.Maps, Maps);
end;

constructor TKisScanOrder.Create(Mngr: TKisMngr);
begin
  inherited;
  FMapsCtrlr := TMapsCtrlr.CreateController(Mngr, Mngr, keScanOrderMap);
  FMapsCtrlr.HeadEntity := Self;
  FMaps := TCustomDataSet.Create(Mngr);
  FMaps.Controller := FMapsCtrlr;
  FMaps.Open;
  FMaps.First;
end;

function TKisScanOrder.CreateEditor: TKisEntityEditor;
begin
  Result := TKisScanOrderEditor.Create(Application);
end;

destructor TKisScanOrder.Destroy;
begin
  FMaps.Close;
  FreeAndNil(FMaps);
  FreeAndNil(FMapsCtrlr);
  inherited;
end;

class function TKisScanOrder.EntityName: String;
begin
  Result := SEN_SCAN_ORDER;
end;

function TKisScanOrder.Equals(Entity: TKisEntity): Boolean;
begin
  inherited Equals(Entity);
  with Entity as TKisScanOrder do
  begin
    Result := 
      (Self.FOrderNumber = FOrderNumber)
      and (Self.FOrderDate = FOrderDate)
      and (Self.FGivedOut = FGivedOut)
      and (Self.FWorkType = FWorkType)
      and (Self.FReturned = FReturned)
      and (Self.FAddress = FAddress)
      and (Self.FAnnulled = FAnnulled)
      and (Self.FLicensedOrgId = FLicensedOrgId)
      and (Self.FOfficeId = FOfficeId);
    //
    if Result then
      Result := Result and Self.FMapsCtrlr.EqualsTo(FMapsCtrlr);
  end;
end;

function TKisScanOrder.FindMap(const Nomenclature: String): TKisScanOrderMap;
var
  I: Integer;
begin
  Result := nil;
  for I := 1 to Maps.RecordCount do
    if MapObjects[I].Nomenclature = Nomenclature then
    begin
      Result := MapObjects[I];
      Break;
    end;
end;

function TKisScanOrder.GetMapObjects(RecNo: Integer): TKisScanOrderMap;
begin
  Result := FMapsCtrlr.Maps[RecNo];
end;

function TKisScanOrder.GetMaps: TDataSet;
begin
  Result := FMaps;
end;

function TKisScanOrder.IsAllMapsInStore: Boolean;
begin
  Result := True;
  Maps.First;
  while not Maps.Eof do
  begin
    if not MapObjects[Maps.RecNo].InStore then
    begin
      Result := False;
      Exit;
    end;
    Maps.Next;
  end;
end;

function TKisScanOrder.IsEmpty: Boolean;
begin
  Result :=
    (FOrderNumber = '')
    and (FOrderDate = '')
    and (FAddress = '')
    and (FWorkType = '')
    and (FLicensedOrgId < 1)
    and (FOfficeId < 1)
    and Maps.IsEmpty;
end;

procedure TKisScanOrder.Load(DataSet: TDataSet);
begin
  inherited;
  with DataSet do
  begin
    Self.ID := FieldByName(SF_ID).AsInteger;
    Self.FOrderNumber := FieldByName(SF_ORDER_NUMBER).AsString;
    Self.FOrderDate := FieldByName(SF_ORDER_DATE).AsString;
    Self.FAddress := FieldByName(SF_ADDRESS).AsString;
    Self.FWorkType := FieldByName(SF_WORK_TYPE).AsString;
    Self.FGivedOut := FieldByName(SF_GIVEDOUT).AsInteger = 1;
    Self.FReturned := FieldByName(SF_RETURNED).AsInteger = 1;
    Self.FAnnulled := FieldByName(SF_ANNULLED).AsInteger = 1;
    Self.FLicensedOrgId := FieldByName(SF_LICENSED_ORGS_ID).AsInteger;
    Self.FOfficeId := FieldByName(SF_OFFICES_ID).AsInteger;
  end;
  //грузим список выдачи планшетов
  SQLMngr.LoadController(SQ_GET_SCAN_ORDER_MAP_LIST_ID, Id, keScanOrderMap, FMapsCtrlr);
end;

procedure TKisScanOrder.LoadDataIntoEditor(Editor: TKisEntityEditor);
var
  N, D: string;
  I: Integer;
begin
  inherited;
  if Editor is TKisScanOrderEditor then
    with TKisScanOrderEditor(Editor) do
    begin
      if (OrderNumber = '') and not ReadOnly then
      begin
        N := TKisScanOrdersMngr(Manager).GenNewOrderNumber;
        I := 0;
        while AppModule.ExistsDocInWork(N) do
        begin
          N := GetNextNumber2(N);
          Inc(I);
          if I > 10000 then
            Break;
        end;
        AppModule.AddDocInWork(N);
        FDeleteDocInWork := True;
        FDocInWorkNumber := N;
      end
      else
      begin
        N := OrderNumber;
        FDeleteDocInWork := False;
        FDocInWorkNumber := '';
      end;
      edNumber.Text := N;
      if (OrderDate = '') and not ReadOnly then
        D := DateToStr(Date)
      else
        D := OrderDate;
      edDate.Text := D;
      edAddress.Text := Address;
      cbWorkType.Text := WorkType;
      chbAnnulled.Checked := Annulled;
      //
      RadBtnOrgs.Checked := LicensedOrgId > 0;
      RadBtnMP.Checked := OfficeId > 0;
      RadBtnOrgs.Checked := not RadBtnMP.Checked;
      LicensedOrgId := Self.LicensedOrgId;
      OfficeId := Self.OfficeId;
    end;
end;

procedure TKisScanOrder.PrepareEditor(Editor: TKisEntityEditor);
var
  List: TStringList;
begin
  inherited;
  if Editor is TKisScanOrderEditor then
    with TKisScanOrderEditor(Editor) do
    begin
      MyEntity := Self;
      MyManager := TKisScanOrdersMngr(Manager);
      List := AppModule.FieldValues(ST_SCAN_ORDERS, SF_WORK_TYPE);
      List.Forget;
      List.Sort;
      cbWorkType.Items.Clear;
      cbWorkType.Items.Assign(List);
      DataSource1.DataSet := Maps;
      //
      chbAnnulled.Enabled := not (Self.Annulled or Self.Returned);
    end;  
end;

procedure TKisScanOrder.ReadDataFromEditor(Editor: TKisEntityEditor);
begin
  inherited;
  if Editor is TKisScanOrderEditor then
    with TKisScanOrderEditor(Editor) do
    begin
      OrderNumber := Trim(edNumber.Text);
      OrderDate := edDate.Text;
      Address := edAddress.Text;
      WorkType := cbWorkType.Text;
      Self.LicensedOrgId := LicensedOrgId;
      Self.OfficeId := OfficeId;
      Self.Annulled := chbAnnulled.Checked;
    end;
end;

procedure TKisScanOrder.SetAddress(const Value: string);
begin
  if FAddress <> Value then
  begin
    FAddress := Value;
    Modified := True;
  end;
end;

procedure TKisScanOrder.SetAnnulled(const Value: Boolean);
begin
  if FAnnulled <> Value then
  begin
    FAnnulled := Value;
    Modified := True;
  end;
end;

procedure TKisScanOrder.SetGivedOut(const Value: Boolean);
begin
  if FGivedOut <> Value then
  begin
    FGivedOut := Value;
    Modified := True;
  end;
end;

procedure TKisScanOrder.SetLicensedOrgId(const Value: Integer);
begin
  if FLicensedOrgId <> Value then
  begin
    FLicensedOrgId := Value;
    Modified := True;
  end;
end;

procedure TKisScanOrder.SetOfficeId(const Value: Integer);
begin
  if FOfficeId <> Value then
  begin
    FOfficeId := Value;
    Modified := True;
  end;
end;

procedure TKisScanOrder.SetOrderDate(const Value: string);
begin
  if FOrderDate <> Value then
  begin
    FOrderDate := Value;
    Modified := True;
  end;
end;

procedure TKisScanOrder.SetOrderNumber(const Value: string);
begin
  if FOrderNumber <> Value then
  begin
    FOrderNumber := Value;
    Modified := True;
  end;
end;

procedure TKisScanOrder.SetReturned(const Value: Boolean);
begin
  if FReturned <> Value then
  begin
    FReturned := Value;
    Modified := True;
  end;
end;

procedure TKisScanOrder.SetWorkType(const Value: string);
begin
  if FWorkType <> Value then
  begin
    FWorkType := Value;
    Modified := True;
  end;
end;

procedure TKisScanOrder.UnprepareEditor(Editor: TKisEntityEditor);
begin
  inherited;
//  if Editor is TKisScanOrderEditor then
//    TKisScanOrderEditor(Editor).DataSource1.DataSet := nil;
  if FDeleteDocInWork then
    AppModule.DeleteDocInWork(FDocInWorkNumber);
end;

{ TKisScanOrder.TMapsCtrlr }

procedure TKisScanOrder.TMapsCtrlr.FillFieldDefs(FieldDefsRef: TFieldDefs);
begin
  FieldDefsRef.Clear;
  with FieldDefsRef.AddFieldDef do
  begin
    DataType := ftInteger;
    FieldNo := 1;
    Name := SF_ID;
  end;
  with FieldDefsRef.AddFieldDef do
  begin
    DataType := ftInteger;
    FieldNo := 2;
    Name := SF_SCAN_ORDERS_ID;
  end;
  with FieldDefsRef.AddFieldDef do
  begin
    DataType := ftString;
    FieldNo := 3;
    Size := 20;
    Name := SF_NOMENCLATURE;
  end;
  with FieldDefsRef.AddFieldDef do
  begin
    DataType := ftBoolean;
    FieldNo := 4;
    Name := SF_GIVE_STATUS;
  end;
end;

function TKisScanOrder.TMapsCtrlr.GetDeleteQueryText: String;
begin
  raise EKisException.Create('TKisScanOrder.TMapsCtrlr.GetDeleteQueryText');
end;

function TKisScanOrder.TMapsCtrlr.GetFieldData(Index: Integer; Field: TField;
  out Data): Boolean;
var
  Ent: TKisScanOrderMap;
begin
  try
    Ent := TKisScanOrderMap(Elements[Index]);
    case Field.FieldNo of
    1 : GetInteger(Ent.ID, Data);
    2 : GetInteger(Ent.HeadId, Data);
    3 : if Ent.Nomenclature <> '' then
          GetString(Ent.Nomenclature, Data)
        else
        begin
          Result := False;
          Exit;
        end;
    4 : GetBoolean(Ent.InStore, Data);
    else
      raise EDatabaseError.CreateFmt(S_FIELD_NOT_FOUND, [Field.FieldName]);
    end;
    Result := True;
  except
    Result := False;
  end;
end;

function TKisScanOrder.TMapsCtrlr.GetMaps(
  const Index: Integer): TKisScanOrderMap;
begin
  Result := TKisScanOrderMap(Elements[Index]);
end;

procedure TKisScanOrder.TMapsCtrlr.SetFieldData(Index: Integer; Field: TField;
  var Data);
var
  Ent: TKisScanOrderMap;
begin
  try
    Ent := TKisScanOrderMap(Elements[Index]);
    case Field.FieldNo of
    1 : Ent.ID := SetInteger(Data);
    3 : Ent.Nomenclature := SetString(Data);
    4 : Ent.InStore := SetBoolean(Data);
    end;
  except
  end;
end;

{ TKisScanOrderMap }

procedure TKisScanOrderMap.Copy(Source: TKisEntity);
begin
  inherited;
  FNomenclature := TKisScanOrderMap(Source).FNomenclature;
  FInStore := TKisScanOrderMap(Source).FInStore;
end;

class function TKisScanOrderMap.EntityName: String;
begin
  raise EKisException.Create('TKisScanOrderMap.EntityName');
end;

function TKisScanOrderMap.Equals(Entity: TKisEntity): Boolean;
begin
  Result := FNomenclature = TKisScanOrderMap(Entity).FNomenclature;
end;

function TKisScanOrderMap.IsEmpty: Boolean;
begin
  Result := FNomenclature = '';
end;

procedure TKisScanOrderMap.Load(DataSet: TDataSet);
begin
  inherited;
  ID := DataSet.FieldByName(SF_ID).AsInteger;
  FNomenclature := DataSet.FieldByName(SF_NOMENCLATURE).AsString;
  FInStore := DataSet.FieldByName(SF_GIVE_STATUS).AsInteger = 0;
//  FInStore := Boolean(DataSet.FieldByName(SF_GIVE_STATUS).AsInteger);
end;

procedure TKisScanOrderMap.SetInStore(const Value: Boolean);
begin
  FInStore := Value;
end;

procedure TKisScanOrderMap.SetNomenclature(const Value: string);
begin
  if FNomenclature <> Value then
  begin
    FNomenclature := Value;
    Modified := True;
  end;
end;

end.
