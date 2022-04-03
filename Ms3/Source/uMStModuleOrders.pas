unit uMStModuleOrders;

interface

uses
  SysUtils, Classes, DB, IBCustomDataSet, IBQuery, IBDatabase,
  //
  uIBXUtils,
  //
  uMStKernelInterfaces, uMStKernelConsts;

type
  TmstOrdersDataModule = class(TDataModule, IOrders)
    trKis: TIBTransaction;
    ibqOrders: TIBQuery;
    ibqMaps: TIBQuery;
  private
    function GetOrderByNum(const Num: string): IOrder;
    function GetOpenOrders(const PeopleId: Integer): TInterfaceList;
  end;

implementation

{$R *.dfm}

type
  TOrder = class(TInterfacedObject, IOrder)
  private
    FAddress: string;
    FDate: TDateTime;
    FId: Integer;
    FNumber: string;
    FMaps: TStringList;
  private
    function CompareMaps(Maps: TStrings): TStrings;
    //
    function GetAddress: string;
    function GetDate: TDateTime;
    function GetDateStr: string;
    function GetId: Integer;
    function GetNumber: string;
    function GetMap(const Index: Integer): string;
    function Info: string;
    function MapCount: Integer;
  public
    constructor Create(const Id: Integer; const aDate: TDateTime; const Number, Address: string);
    destructor  Destroy; override;
    //
    property Maps: TStringList read FMaps;
  end;

{ TmstOrdersDataModule }

function TmstOrdersDataModule.GetOpenOrders(
  const PeopleId: Integer): TInterfaceList;
var
  Order: TOrder;
begin
  Result := TInterfaceList.Create;
  //
  trKis.Init(ilReadCommited, amReadOnly);
  trKis.StartTransaction;
  try
    ibqOrders.ParamByName(SF_PEOPLE_ID).AsInteger := PeopleId;
    ibqOrders.Open;
    // загружаем данные из БД
    while not ibqOrders.Eof do
    begin
      // создаём объекты
      Order := TOrder.Create(
        ibqOrders.FieldValues[SF_ID],
        ibqOrders.FieldValues[SF_ORDER_DATE],
        ibqOrders.FieldValues[SF_ORDER_NUMBER],
        ibqOrders.FieldValues[SF_OBJECT_ADDRESS]
      );
      // добавляем их в список
      Result.Add(Order as IOrder);
      // список планшетов
      ibqMaps.ParamByName(SF_ORDERS_ID).AsInteger := Order.FId;
      ibqMaps.Open;
      try
        while not ibqMaps.Eof do
        begin
          Order.Maps.Add(ibqMaps.FieldValues[SF_NOMENCLATURE]);
          ibqMaps.Next;
        end;
      finally
        ibqMaps.Close;
      end;
      //
      ibqOrders.Next;
    end;
    ibqOrders.Close;
  finally
    trKis.Commit;
  end;
end;

function TmstOrdersDataModule.GetOrderByNum(const Num: string): IOrder;
begin
  raise Exception.Create('TmstOrdersDataModule.GetOrderByNum');
end;

{ TOrder }

function TOrder.CompareMaps(Maps: TStrings): TStrings;
var
  I: Integer;
begin
  Result := TStringList.Create;
  FMaps.Sorted := True;
  for I := 0 to Maps.Count - 1 do
  begin
    if FMaps.IndexOf(Maps[I]) < 0 then
      Result.Add(Maps[I]);
  end;
  TStringList(Result).Sort;
end;

constructor TOrder.Create(const Id: Integer; const aDate: TDateTime;
  const Number, Address: string);
begin
  inherited Create;
  FMaps := TStringList.Create;
  FId := Id;
  FDate := Date;
  FNumber := Number;
  FAddress := Address;
end;

destructor TOrder.Destroy;
begin
  FMaps.Free;
  inherited;
end;

function TOrder.GetAddress: string;
begin
  Result := FAddress;
end;

function TOrder.GetDate: TDateTime;
begin
  Result := FDate;
end;

function TOrder.GetDateStr: string;
begin
  Result := DateTimeToStr(FDate);
end;

function TOrder.GetId: Integer;
begin
  Result := FId;
end;

function TOrder.GetMap(const Index: Integer): string;
begin
  Result := FMaps[Index]; 
end;

function TOrder.GetNumber: string;
begin
  Result := FNumber;
end;

function TOrder.Info: string;
begin
  Result :=
    'ID: ' + IntToStr(FId) + sLineBreak +
    '№ ' + FNumber + ' от ' + DateToStr(fDate) + sLineBreak;
end;

function TOrder.MapCount: Integer;
begin
  Result := FMaps.Count;
end;

end.
