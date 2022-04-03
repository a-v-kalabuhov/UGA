unit uIBXPlanSpy;

interface

uses
  Classes, DB, Contnrs;

type
  TDataSetItem = class
  private
    FDataSet: TDataSet;
    FAfterOpenHandler: TDataSetNotifyEvent;
  public
    constructor Create(ADataSet: TDataSet);
    destructor Destroy; override;
    property DataSet: TDataSet read FDataSet write FDataSet;
    property AfterOpenHandler: TDataSetNotifyEvent read FAfterOpenHandler write FAfterOpenHandler;
  end;

  TDataSetList = class(TObjectList)
  protected
    function GetItem(Index: Integer): TDataSetItem;
    procedure SetItem(Index: Integer; DataSetItem: TDataSetItem);
  public
    function IndexOfDataSet(DataSet: TDataSet): Integer;
    function Add: TDataSetItem;
    property Items[Index: Integer]: TDataSetItem read GetItem write SetItem; default;
  end;

  TQueryExecuteInfo = class
  private
    FFetchesFromCache: Integer;
    FReadsFromDisk: Integer;
    FWritesToDisk: Integer;
    FPlan: String;
    procedure SetFetchesFromCache(const Value: Integer);
    procedure SetReadsFromDisk(const Value: Integer);
    procedure SetWritesToDisk(const Value: Integer);
    procedure SetPlan(const Value: String);
  public
    function AsStrings: TStrings;
    property Plan: String read FPlan write SetPlan;
    property FetchesFromCache: Integer read FFetchesFromCache write SetFetchesFromCache;
    property ReadsFromDisk: Integer read FReadsFromDisk write SetReadsFromDisk;
    property WritesToDisk: Integer read FWritesToDisk write SetWritesToDisk;
  end;

  TExportPlanEvent = procedure (DataSet: TDataSet; Info: TQueryExecuteInfo) of object;

  TIBXPlanSpy = class(TComponent)
  private
    FRegistry: TDataSetList;
    FOnExportPlan: TExportPlanEvent;
    procedure AddQuery(Component: TComponent);
    procedure QueryAfterOpen(DataSet: TDataSet);
    function GetInfo(DataSet: TDataSet): TQueryExecuteInfo;
  protected
    procedure DoExportPlan(DataSet: TDataSet; const Plan: String);
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure RegisterQueries(Component: TComponent);

    property OnExportPlan: TExportPlanEvent read FOnExportPlan write FOnExportPlan;
  end;

implementation

uses
  SysUtils, Forms, IBCustomDataSet, IBDatabaseInfo;

{ TIBXPlanSpy }

procedure TIBXPlanSpy.AddQuery(Component: TComponent);
begin
  with FRegistry.Add do
  begin
    DataSet := TDataSet(Component);
    AfterOpenHandler := DataSet.AfterOpen;
    DataSet.AfterOpen := QueryAfterOpen;
  end;
end;

constructor TIBXPlanSpy.Create;
begin
  inherited;
  FRegistry := TDataSetList.Create(True);
end;

destructor TIBXPlanSpy.Destroy;
begin
  FreeAndNil(FRegistry);
  inherited;
end;

procedure TIBXPlanSpy.DoExportPlan(DataSet: TDataSet; const Plan: String);
begin
  if Assigned(FOnExportPlan) then
  begin
    FOnExportPlan(DataSet, GetInfo(DataSet));
  end;
end;

function TIBXPlanSpy.GetInfo(DataSet: TDataSet): TQueryExecuteInfo;
var
  I: Integer;
begin
  Result := TQueryExecuteInfo.Create;
  I := FRegistry.IndexOfDataSet(DataSet);
  if I >=0 then
  begin
    Result.Plan := TIBCustomDataSet(DataSet).Plan;
    with TIBDatabaseInfo.Create(Self) do
    try
      Database := TIBCustomDataSet(DataSet).Database;
      Result.FetchesFromCache := Fetches;
      Result.ReadsFromDisk := Reads;
      Result.WritesToDisk := Writes;
    finally
      Free;
    end;
  end
  else
    Result := nil;
end;

procedure TIBXPlanSpy.QueryAfterOpen(DataSet: TDataSet);
var
  I: Integer;
begin
  I := FRegistry.IndexOfDataSet(DataSet);
  if I >= 0 then
  with FRegistry.Items[I] do
  begin
    if Assigned(AfterOpenHandler) then
      AfterOpenHandler(DataSet);
    DoExportPlan(DataSet, TIbCustomDataSet(DataSet).Plan);
  end;
end;

procedure TIBXPlanSpy.RegisterQueries(Component: TComponent);
var
  I: Integer;
begin
  if Assigned(Component) then
    if Component is TIBCustomDataSet then
      AddQuery(Component)
    else
      for I := 0 to Pred(Component.ComponentCount) do
        RegisterQueries(Component.Components[I]);
end;

{ TKisDataSet }

constructor TDataSetItem.Create(ADataSet: TDataSet);
begin
  FDataSet := ADataSet;
end;

destructor TDataSetItem.Destroy;
begin
  if Assigned(DataSet) then
    DataSet.AfterOpen := AfterOpenHandler;
  inherited;
end;

{ TDataSetList }

function TDataSetList.Add: TDataSetItem;
begin
  Result := TDataSetItem.Create(nil);
  inherited Add(Result);
end;

function TDataSetList.GetItem(Index: Integer): TDataSetItem;
begin
  Result := TDataSetItem(inherited GetItem(Index));
end;

function TDataSetList.IndexOfDataSet(DataSet: TDataSet): Integer;
var
  I: Integer;
begin
  for I := 0 to Pred(Count) do
    if Items[I].DataSet = DataSet then
    begin
      Result := I;
      Exit;
    end;
  Result := -1;
end;

procedure TDataSetList.SetItem(Index: Integer; DataSetItem: TDataSetItem);
begin
  inherited SetItem(Index, DataSetItem);
end;

{ TQueryExecuteInfo }

function TQueryExecuteInfo.AsStrings: TStrings;
const
  S_Plan = 'PLAN';
  S_Reads = 'Reads from disk to cache: %d';
  S_Writes = 'Writes to disk from cache: %d';
  S_Fetches = 'Fetches from cache: %d';
var
  S: String;
  I: Integer;
begin
  Result := TStringList.Create;
  I := 20 + Length(S_Plan);
  SetLength(S, I);
  FillChar(S[1], I, '=');
  Result.Add(S);
  Result.Add(Plan);
  Result.Add(S);
  Result.Add(Format(S_Reads, [ReadsFromDisk]));
  Result.Add(Format(S_Writes, [WritesToDisk]));
  Result.Add(Format(S_Fetches, [FetchesFromCache]));
end;

procedure TQueryExecuteInfo.SetFetchesFromCache(const Value: Integer);
begin
  FFetchesFromCache := Value;
end;

procedure TQueryExecuteInfo.SetPlan(const Value: String);
begin
  FPlan := Value;
end;

procedure TQueryExecuteInfo.SetReadsFromDisk(const Value: Integer);
begin
  FReadsFromDisk := Value;
end;

procedure TQueryExecuteInfo.SetWritesToDisk(const Value: Integer);
begin
  FWritesToDisk := Value;
end;

end.
 