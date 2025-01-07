unit uMStImportEzClasses;

interface

uses
  SysUtils, Contnrs,
  EzBaseGIS, EzLib,
  uMStKernelTypes, uMStKernelClasses, uMStKernelIBX, uMStClassesLots, uMStClassesProjects;

type
  IEzLotLoader = interface
    ['{214BC0D7-7D58-41CE-A34F-B6AF02D55FCD}']
    procedure SetConnection(Value: IIBXConnection);
    procedure SetLayer(Value: TEzBaseLayer);
    procedure SetLotList(Value: TmstLotList);
    procedure SetRect(Value: TEzRect);
    procedure SetSqlSource(Value: ISqlSource);
    //
    procedure Execute(CallBack: TProgressEvent2);
  end;

  IEzProjectLoader = interface
    ['{214BC0D7-7D58-41CE-A34F-B6AF02D55FCD}']
    procedure SetDb(Value: IDb);
    procedure SetList(Value: TmstObjectList);
    procedure SetRect(Value: TEzRect);
    procedure SetSqlSource(Value: ISqlSource);
    //
    procedure Execute(CallBack: TProgressEvent2);
  end;

  TMStEzLotLoaderFactory = class
  public
    class function CreateLoader(LotCategory: Integer): IEzLotLoader;
  end;

  TMStEzProjectLoaderFactory = class
    class function CreateLoader(MasterPlan: Boolean): IEzProjectLoader;
  end;

  TmstLotListEz = class(TmstLotList)
  private
    FLayer: TEzBaseLayer;
    function GetLotList: TmstLotList;
  public
    constructor Create(aLayer: TEzBaseLayer; aCategoryId: Integer);
    //
    property Layer: TEzBaseLayer read FLayer;
    property LotList: TmstLotList read GetLotList;
  end;

  TmstLotRegistry = class(TObjectList)
  private
    FUpdateObjectHandler: TmstUpdateObjectEvent;
    FBeforeAddLotHandler: TBeforeAddLotEvent;
    function GetItems(Index: Integer): TmstLotListEz;
    procedure SetItems(Index: Integer; const Value: TmstLotListEz);
  public
    function Add(Value: TmstLotListEz): Integer;
    function FindByCategory(CategoryId: Integer): TmstLotListEz;
    procedure SetBeforeAddLotHandler(Value: TBeforeAddLotEvent);
    procedure SetUpdateObjectHandler(Value: TmstUpdateObjectEvent);
    //
    property Items[Index: Integer]: TmstLotListEz read GetItems write SetItems; default;
  end;

implementation

uses
  uMStImportEzLotLoaders, uMStProjectLoaders;

{ TmstLotListEz }

constructor TmstLotListEz.Create;
begin
  inherited Create;
  FLayer := aLayer;
  CategoryId := aCategoryId;
end;

function TmstLotListEz.GetLotList: TmstLotList;
begin
  Result := Self;
end;

{ TmstLotRegistry }

function TmstLotRegistry.Add(Value: TmstLotListEz): Integer;
begin
  Result := inherited Add(Value);
  Value.OnUpdateObject := FUpdateObjectHandler;
  Value.BeforeAddLot := FBeforeAddLotHandler;
end;

function TmstLotRegistry.FindByCategory(CategoryId: Integer): TmstLotListEz;
var
  I: Integer;
begin
  for I := 0 to Count - 1 do
    if Items[I].CategoryId = CategoryId then
    begin
      Result := Items[I];
      Exit;
    end;
  Result := nil;
end;

function TmstLotRegistry.GetItems(Index: Integer): TmstLotListEz;
begin
  Result := TmstLotListEz(inherited Items[Index]);
end;

procedure TmstLotRegistry.SetBeforeAddLotHandler(Value: TBeforeAddLotEvent);
var
  I: Integer;
begin
  FBeforeAddLotHandler := Value;
  for I := 0 to Count - 1 do
    Items[I].BeforeAddLot := Value;
end;

procedure TmstLotRegistry.SetItems(Index: Integer; const Value: TmstLotListEz);
begin
  inherited Items[Index] := Value;
end;

procedure TmstLotRegistry.SetUpdateObjectHandler(Value: TmstUpdateObjectEvent);
var
  I: Integer;
begin
  FUpdateObjectHandler := Value;
  for I := 0 to Count - 1 do
    Items[I].OnUpdateObject := Value;
end;

{ TMStEzLotLoaderFactory }

class function TMStEzLotLoaderFactory.CreateLoader(LotCategory: Integer): IEzLotLoader;
var
  aLotType: TmstLotType;
begin
  aLotType := TmstLot.CatToType(LotCategory);
  if aLotType = ltCategorized then
    Result := TEzCategorizedLoader.Create(LotCategory)
  else
    Result := TEzNoCategoryLoader.Create(LotCategory);
end;

{ TMStEzProjectLoaderFactory }

class function TMStEzProjectLoaderFactory.CreateLoader(MasterPlan: Boolean): IEzProjectLoader;
begin
  if MasterPlan then
    Result := TMStMPRectLoader.Create as IEzProjectLoader
  else
    Result := TMStProjectRectLoader.Create as IEzProjectLoader;
end;

end.
