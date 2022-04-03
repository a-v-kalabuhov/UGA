unit uKisFilters;

interface

uses
  Classes, Variants, SysUtils;

type
  IKisNamedObject = interface
    ['{112FB846-06B1-4E58-9843-802333454650}']
{$REGION 'property access'}
    function GetName: String;
    procedure SetName(const Value: String);
{$ENDREGION}
    property Name: String read GetName write SetName;
  end;

  IKisValue = interface
    ['{6EABBBB7-E86D-4AD7-B6B6-0139168AF08B}']
{$REGION 'property access'}
    function GetOldValue: Variant;
    function GetValue: Variant;
    procedure SetValue(const Value: Variant);
{$ENDREGION}
    function Changed: Boolean;
    property OldValue: Variant read GetOldValue;
    property Value: Variant read GetValue write SetValue;
  end;

  TSQLRelation = (frNone, frEqual, frLess, frLessOrEqual, frGreater, frGreaterOrEqual);

  IKisFilter = interface(IKisValue)
    ['{55CE9A53-057B-49AD-903A-061A93514281}']
    {$REGION 'property access'}
    function GetRelation: TSQLRelation;
    procedure SetRelation(const Value: TSQLRelation);
    {$ENDREGION}
    procedure Assign(Source: IKisFilter);
    property Relation: TSQLRelation read GetRelation write SetRelation;
  end;

  IKisFilters = interface
    ['{2C5D1AB3-551E-4C4F-AC3C-464338DAD855}']
{$REGION 'property access'}
    function Get(Index: Integer): IKisFilter;
    procedure Put(Index: Integer; Value: IKisFilter);
{$ENDREGION}
    function Add(Value: IKisFilter): Integer;
    procedure Clear;
    function Count: Integer;
    function Find(const FilterName: String): IKisFilter;
    procedure Remove(aFilter: IKisFilter);
    function Update(Source: IKisFilters): Boolean;
    property Items[Index: Integer]: IKisFilter read Get write Put; default;
  end;

  TFilterFactory = class
  strict private type
{$REGION 'имплементация интерфейсов'}
    TKisFilter = class(TInterfacedObject, IKisFilter, IKisNamedObject)
    private
      FName: String;
      FValue: Variant;
      FOldValue: Variant;
      FChanged: Boolean;
      FRelation: TSQLRelation;
  {$REGION 'IKisNamedObject'}
      function GetName: String;
      procedure SetName(const aValue: String);
  {$ENDREGION}
  {$REGION 'IKisFilter'}
      procedure Assign(Source: IKisFilter);
      function Changed: Boolean;
      function GetOldValue: Variant;
      function GetValue: Variant;
      procedure SetValue(const aValue: Variant);
      function GetRelation: TSQLRelation;
      procedure SetRelation(const Value: TSQLRelation);
  {$ENDREGION}
    public
      constructor Create; overload;
      constructor Create(const aName: String; const aValue: Variant;
        const aRelation: TSQLRelation); overload;
    end;
    TKisFilterList = class(TInterfacedObject, IKisFilters)
    private
      FList: TInterfaceList;
{$REGION 'IKisFilters'}
      function Get(Index: Integer): IKisFilter;
      procedure Put(Index: Integer; Value: IKisFilter);
      function Add(Value: IKisFilter): Integer;
      procedure Clear;
      function Count: Integer;
      function Find(const FilterName: String): IKisFilter;
      procedure Remove(aFilter: IKisFilter);
      function Update(Source: IKisFilters): Boolean;
{$ENDREGION}
    public
      constructor Create;
      destructor Destroy; override;
    end;
{$ENDREGION}
  public
    class function CreateFilter: IKisFilter; overload;
    class function CreateFilter(const aName: String; const aValue: Variant;
      const aRelation: TSQLRelation = frEqual): IKisFilter; overload;
    class function CreateList(aFilter: IKisFilter = nil): IKisFilters;
  end;

implementation

{ TFilterFactory }

class function TFilterFactory.CreateFilter(const aName: String;
  const aValue: Variant; const aRelation: TSQLRelation): IKisFilter;
begin
  Result := TKisFilter.Create(aName, aValue, aRelation);
end;

class function TFilterFactory.CreateFilter: IKisFilter;
begin
  Result := TKisFilter.Create;
end;

class function TFilterFactory.CreateList(aFilter: IKisFilter): IKisFilters;
begin
  Result := TKisFilterList.Create;
  if Assigned(aFilter) then
    Result.Add(aFilter);
end;

{ TFilterFactory.TKisFilter }

procedure TFilterFactory.TKisFilter.Assign(Source: IKisFilter);
begin
  FName := (Source as IKisNamedObject).Name;
  FValue := Source.Value;
  FOldValue := Source.OldValue;
  FChanged := Source.Changed;
  FRelation := Source.Relation;
end;

function TFilterFactory.TKisFilter.Changed: Boolean;
begin
  Result := FChanged;
end;

constructor TFilterFactory.TKisFilter.Create(const aName: String;
  const aValue: Variant; const aRelation: TSQLRelation);
begin
  inherited Create;
  FName := aName;
  FOldValue := Null;
  FValue := aValue;
  FRelation := aRelation;
end;

constructor TFilterFactory.TKisFilter.Create;
begin
  inherited Create;
  FOldValue := Null;
  FValue := Null;
end;

function TFilterFactory.TKisFilter.GetName: String;
begin
  Result := FName;
end;

function TFilterFactory.TKisFilter.GetOldValue: Variant;
begin
  Result := FOldValue;
end;

function TFilterFactory.TKisFilter.GetRelation: TSQLRelation;
begin
  Result := FRelation;
end;

function TFilterFactory.TKisFilter.GetValue: Variant;
begin
  Result := FValue;
end;

procedure TFilterFactory.TKisFilter.SetName(const aValue: String);
begin
  FName := aValue;
end;

procedure TFilterFactory.TKisFilter.SetRelation(const Value: TSQLRelation);
begin
  FRelation := Value;
end;

procedure TFilterFactory.TKisFilter.SetValue(const aValue: Variant);
begin
  FOldValue := FValue;
  FValue := aValue;
  if VarIsNull(FOldValue) then
    FChanged := not VarIsNull(FValue)
  else
    FChanged := FOldValue <> FValue;
end;

{ TFilterFactory.TKisFilterList }

function TFilterFactory.TKisFilterList.Add(Value: IKisFilter): Integer;
begin
  Result := FList.Add(Value);
end;

procedure TFilterFactory.TKisFilterList.Clear;
begin
  FList.Clear;
end;

function TFilterFactory.TKisFilterList.Count: Integer;
begin
  Result := FList.Count;
end;

constructor TFilterFactory.TKisFilterList.Create;
begin
  inherited Create;
  FList := TInterfaceList.Create;
end;

destructor TFilterFactory.TKisFilterList.Destroy;
begin
  FreeAndNil(FList);
  inherited;
end;

function TFilterFactory.TKisFilterList.Find(
  const FilterName: String): IKisFilter;
var
  I: Integer;
  Fltr: IKisFilter;
begin
  Result := nil;
  for I := 0 to Count - 1 do
  begin
    Fltr := Get(I);
    if (Fltr as IKisNamedObject).Name = FilterName then
    begin
      Result := Fltr;
      Break;
    end;
  end;
end;

function TFilterFactory.TKisFilterList.Get(Index: Integer): IKisFilter;
begin
  Result := FList[Index] as IKisFilter;
end;

procedure TFilterFactory.TKisFilterList.Put(Index: Integer; Value: IKisFilter);
begin
  FList[Index] := Value;
end;

procedure TFilterFactory.TKisFilterList.Remove(aFilter: IKisFilter);
begin
  FList.Remove(aFilter);
end;

function TFilterFactory.TKisFilterList.Update(Source: IKisFilters): Boolean;
var
  I: Integer;
  ScrFilter, Filter: IKisFilter;
  Named: IKisNamedObject;
begin
  Result := False;
  if Assigned(Source) then
  begin
    for I := 0 to Source.Count - 1 do
    begin
      ScrFilter := Source[I];
      Named := ScrFilter as IKisNamedObject;
      Filter := Find(Named.Name);
      if Assigned(Filter) then
      begin
        Filter.Value := ScrFilter.Value;
        Filter.Relation := ScrFilter.Relation;
        Result := Result or Filter.Changed;
      end
      else
      begin
        Filter := TFilterFactory.CreateFilter(Named.Name, ScrFilter.Value, ScrFilter.Relation);
        Add(Filter);
        Result := True;
      end;
    end;
  end;

end;

end.
