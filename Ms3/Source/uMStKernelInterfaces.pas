unit uMStKernelInterfaces;

interface

uses
  Classes,
  DB;

type
  IOrder = interface
    ['{D7C5DDC1-6A9E-4CD2-B7D9-FB30F85BF063}']
    function CompareMaps(Maps: TStrings): TStrings;
    function MapCount: Integer;
    //
    function GetAddress: string;
    function GetDate: TDateTime;
    function GetDateStr: string;
    function GetId: Integer;
    function GetNumber: string;
    function GetMap(const Index: Integer): string;
    function Info: string;
    //
    property Id: Integer read GetId;
    property Date: TDateTime read GetDate;
    property DateStr: string read GetDateStr;
    property Number: string read GetNumber;
    property Address: string read GetAddress;
    property Maps[const Index: Integer]: string read GetMap;
  end;

  TOrderArray = array of IOrder;

  IOrders = interface
    ['{1F5FDC37-B82E-47F7-86C8-95BADA088584}']
    function GetOpenOrders(const PeopleId: Integer): TInterfaceList;
    function GetOrderByNum(const Num: string): IOrder;
  end;

  TLotDataSet = (ldsLot, ldsOwners, ldsDocs);

  ILots = interface
    ['{175B6420-88D6-4DE6-80D1-7B73FC6F0BFD}']
    procedure CloseLots;
    function GetLotData(const FieldName: string): string;
    function GetOwnerData(const FieldName: string): string;
    function GetDocsList(): string;
    function GetDataSet(Kind: TLotDataSet): TDataSet;
  end;

  IStats = interface
    ['{FA365F40-9D28-44F9-87F6-822F6E1B1140}']
    procedure Close;
    function DataSet: TDataSet;
    procedure PrepareDataSet(const OfficeId, PeopleId: Integer; const D1, D2: TDateTime; UseD1, UseD2: Boolean);
    function GetOffices(): TStrings;
    function GetPeople(const OfficeNo: Integer): TStrings;
  end;

  IParameters = interface
    ['{30004CB6-D2A0-4FEF-8AE0-7238CEEF76F3}']
    procedure Open;
    procedure Close;
    function GetParameter(const ParamName: string): Variant;
    function GetWatermarkParameter(const ParamName: string): Variant;
  end;

implementation

end.
