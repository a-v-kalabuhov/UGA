unit uMStKernelClassesQueryIndex;

interface

uses
  Classes,
  EzLib;

type
  TIndexEntry = class
  private
    FId: Integer;
    FItems: TIntegerList;
    procedure SetId(const Value: Integer);
  public
    constructor Create;
    destructor Destroy; override;
    //
    procedure Sort();
    //
    property Id: Integer read FId write SetId;
    property Items: TIntegerList read FItems;
  end;

  TQueryRowIndex = class
  private
    FIndex: TList;
    function GetEntry(const Id: Integer): TIndexEntry;
  public
    constructor Create;
    destructor Destroy; override;
    //
    procedure Add(const Id, Value: Integer);
    procedure Clear();
    function Delete(const Id: Integer): Boolean;
    procedure DeleteValue(const Id, Value: Integer);
    function Get(const Id: Integer): TIntegerList;
    procedure Sort();
  end;

implementation

{ TQueryRowIndex }

procedure TQueryRowIndex.Add(const Id, Value: Integer);
var
  Entry: TIndexEntry;
begin
  Entry := GetEntry(Id);
  if Entry = nil then
  begin
    Entry := TIndexEntry.Create;
    Entry.Id := Id;
    FIndex.Add(Entry);
  end;
  Entry.Items.Add(Value);
end;

procedure TQueryRowIndex.Clear;
var
  I: Integer;
begin
  for I := 0 to FIndex.Count - 1 do
  begin
    TObject(FIndex[I]).Free;
    FIndex[I] := nil;
  end;
end;

constructor TQueryRowIndex.Create;
begin
  FIndex := TList.Create;
end;

function TQueryRowIndex.Delete(const Id: Integer): Boolean;
var
  I: Integer;
  Entry: TIndexEntry;
begin
  Result := False;
  for I := 0 to FIndex.Count - 1 do
  begin
    Entry := TIndexEntry(FIndex[I]);
    if Entry.Id = Id then
    begin
      Result := True;
      FIndex.Delete(I);
      Entry.Free;
      Exit;
    end;
  end;
end;

procedure TQueryRowIndex.DeleteValue(const Id, Value: Integer);
var
  I: Integer;
  Entry: TIndexEntry;
begin
  Entry := GetEntry(Id);
  if Assigned(Entry) and (Entry.Items.Count > 0) then
  begin
    I := Entry.Items.IndexOfValue(Value);
    if I >= 0 then
      Entry.Items.Delete(I);
  end;
end;

destructor TQueryRowIndex.Destroy;
begin
  Clear();
  FIndex.Free;
  inherited;
end;

function TQueryRowIndex.Get(const Id: Integer): TIntegerList;
var
  Entry: TIndexEntry;
begin
  Entry := GetEntry(Id);
  if Entry <> nil then
  begin
    Result := Entry.Items;
    Result.Sort;
    Exit;
  end;
  Result := nil;
end;

function TQueryRowIndex.GetEntry(const Id: Integer): TIndexEntry;
var
  I: Integer;
  Entry: TIndexEntry;
begin
  for I := 0 to FIndex.Count - 1 do
  begin
    Entry := TIndexEntry(FIndex[I]);
    if Entry.Id = Id then
    begin
      Result := Entry;
      Exit;
    end;
  end;
  Result := nil;
end;

function CompareEntries(Item1, Item2: Pointer): Integer;
var
  Entry1, Entry2: TIndexEntry;
begin
  Entry1 := TIndexEntry(Item1);
  Entry2 := TIndexEntry(Item2);
  Result := Entry1.Id - Entry2.Id;
end;

procedure TQueryRowIndex.Sort;
var
  I: Integer;
  Entry: TIndexEntry;
begin
  FIndex.Sort(CompareEntries);
  for I := 0 to FIndex.Count - 1 do
  begin
    Entry := TIndexEntry(FIndex[I]);
    Entry.Sort();
  end;
end;

{ TIndexEntry }

constructor TIndexEntry.Create;
begin
  FItems := TIntegerList.Create;
end;

destructor TIndexEntry.Destroy;
begin
  FItems.Free;
  inherited;
end;

procedure TIndexEntry.SetId(const Value: Integer);
begin
  FId := Value;
end;

procedure TIndexEntry.Sort;
begin
  FItems.Sort();
end;

end.
