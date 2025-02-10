unit uMStKernelClassesQueryIndex;

interface

uses
  Classes,
  uCommonUtils,
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
    FUseBinarySearch: Boolean;
    function GetEntry(const Id: Integer): TIndexEntry;
    procedure SetUseBinarySearch(const Value: Boolean);
  private
    FBinSearchId: Integer;
    function CheckEntry(aItem: Pointer): Boolean;
    function CompareEntry(aItem: Pointer): Integer;
  public
    constructor Create;
    destructor Destroy; override;
    //
    procedure Add(const Id, Value: Integer);
    procedure Clear();
    function Delete(const Id: Integer): Boolean;
    procedure DeleteValue(const Id, Value: Integer);
    function Contains(const Id: Integer): Boolean;
    function Get(const Id: Integer): TIntegerList;
    function GetFirstRow(const Id: Integer): Integer;
    procedure Sort(WithEntries: Boolean);
    //
    property UseBinarySearch: Boolean read FUseBinarySearch write SetUseBinarySearch;
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

function TQueryRowIndex.CheckEntry(aItem: Pointer): Boolean;
begin
  Result := TIndexEntry(aItem).FId = FBinSearchId;
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

function TQueryRowIndex.CompareEntry(aItem: Pointer): Integer;
begin
  Result := TIndexEntry(aItem).FId - FBinSearchId;
end;

function TQueryRowIndex.Contains(const Id: Integer): Boolean;
var
  Tmp: TIntegerList;
begin
  Tmp := Get(Id);
  if Assigned(Tmp) and (Tmp.Count > 0) then
    Result := True
  else
    Result := False;
end;

constructor TQueryRowIndex.Create;
begin
  FIndex := TList.Create;
end;

function TQueryRowIndex.Delete(const Id: Integer): Boolean;
var
  I, J, K: Integer;
  Recno: Integer;
  Entry: TIndexEntry;
  Tmp: TIndexEntry;
begin
  Result := False;
  J := -1;
  for I := 0 to FIndex.Count - 1 do
  begin
    Entry := TIndexEntry(FIndex[I]);
    if Entry.Id = Id then
    begin
      J := I;
      Break;
    end;
  end;
  //
  if J >= 0 then
  begin
    FIndex.Delete(I);
    for I := 0 to FIndex.Count - 1 do
    begin
      Tmp := TIndexEntry(FIndex[I]);
      for J := 0 to Tmp.FItems.Count - 1 do
      begin
        Recno := Tmp.FItems[J];
        for K := 0 to Entry.FItems.Count - 1 do
        begin
          if Entry.FItems[K] < Recno then
            Dec(Recno);
        end;
        Tmp.FItems[J] := Recno;
      end;
    end;
    Result := True;
    Entry.Free;
  end;
end;

procedure TQueryRowIndex.DeleteValue(const Id, Value: Integer);
var
  I, J, Recno: Integer;
  Entry: TIndexEntry;
  Tmp: TIndexEntry;
begin
  Entry := GetEntry(Id);
  if Assigned(Entry) and (Entry.Items.Count > 0) then
  begin
    I := Entry.Items.IndexOfValue(Value);
    if I >= 0 then
    begin
      Entry.Items.Delete(I);
      for I := 0 to FIndex.Count - 1 do
      begin
        Tmp := TIndexEntry(FIndex[I]);
        for J := 0 to Tmp.FItems.Count - 1 do
        begin
          Recno := Tmp.FItems[J];
          if Value < Recno then
              Dec(Recno);
          Tmp.FItems[J] := Recno;
        end;
      end;
    end;
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
  Result := nil;
  if FUseBinarySearch then
  begin
    FBinSearchId := Id;
    I := DoBinarySearch(FIndex, CheckEntry, CompareEntry);
    if I >= 0 then
      Result := TIndexEntry(FIndex[I]);
  end
  else
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
  end;
end;

function TQueryRowIndex.GetFirstRow(const Id: Integer): Integer;
var
  Entry: TIndexEntry;
begin
  Result := -1;
  Entry := GetEntry(Id);
  if (Entry <> nil) and (Entry.Items.Count > 0) then
  begin
    Entry.Sort();
    Result := Entry.Items[0];
    Exit;
  end;
end;

function CompareEntries(Item1, Item2: Pointer): Integer;
var
  Entry1, Entry2: TIndexEntry;
begin
  Entry1 := TIndexEntry(Item1);
  Entry2 := TIndexEntry(Item2);
  Result := Entry1.Id - Entry2.Id;
end;

procedure TQueryRowIndex.SetUseBinarySearch(const Value: Boolean);
begin
  FUseBinarySearch := Value;
end;

procedure TQueryRowIndex.Sort;
var
  I: Integer;
  Entry: TIndexEntry;
begin
  FIndex.Sort(CompareEntries);
  if WithEntries then
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
