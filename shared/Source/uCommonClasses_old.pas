unit uCommonClasses;

interface

{$WARN UNSAFE_CAST OFF}

uses
  SysUtils, Classes, Contnrs;

type
  TLauncher = class
  public
    procedure DoLaunch; virtual; abstract;
  end;

  TIntegerList = class(TList)
  private
    FSorted: Boolean;
    FUnique: Boolean;
    procedure SetSorted(const Value: Boolean);
    procedure SetUnique(const Value: Boolean);
    procedure RemoveDuplicates;
  protected
    function GetItem(Index: Integer): Integer;
    procedure SetItem(Index: Integer; Value: Integer);
    procedure DoSort; virtual;
  public
    property Items[Index: Integer]: Integer read GetItem write SetItem; default;
    property Sorted: Boolean read FSorted write SetSorted;
    property Unique: Boolean read FUnique write SetUnique;
    function Add(Value: Integer): Integer;
    function IndexOf(Item: Integer): Integer;
    procedure Insert(Index: Integer; Item: Integer);
  end;

  TIndexItem = class
  private
    FValue: Integer;
    FIndex: Integer;
  public
    constructor Create(const AIndex, AValue: Integer);
    property Index: Integer read FIndex;
    property Value: Integer read FValue;
  end;

  TIntegerIndex = class
  private
    FIndex: TObjectList;
    procedure InsertItem(const ToPos, Index, Value: Integer);
    function FindPos(const Value: Integer): Integer;
  public
    constructor Create;
    destructor Destroy; override;
    procedure AddItem(const Index, Value: Integer);
    procedure RemoveItem(const Index, Value: Integer);
    function GetIndex(const Value: Integer): Integer;
    function Count: Integer;
    function AsText: String;
  end;

implementation

procedure IntegerQuickSort(var Values: array of Integer; const Left, Right: Integer);
var
  I, J: Integer;
  W, X: Integer;
begin
  I := Left;
  J := Right;
  X := Values[(Left + Right) div 2];
  repeat
    while Values[I] < X do I := I + 1;
    while X < Values[J] do J := J - 1;
    if I <= J then
      begin
        W := Values[I];
        Values[I] := Values[J];
        Values[J] := W;
        Inc(I);
        Dec(J);
      end;
  until I > J;
  if Left < J
    then IntegerQuickSort(Values, Left, J);
  if I < Right
    then IntegerQuickSort(Values, I, Right);
end;


{ TIntegerList }

function TIntegerList.Add(Value: Integer): Integer;
var
  I, C: Integer;
begin
  Result := -1;
  I := IndexOf(Value);
  if not FUnique or (I < 0) then
  begin
    if FSorted then
    begin
      if I < 0 then
      begin
        C := Pred(Count);
        for I := 0 to C do
          if Items[I] > Value then
          begin
            Insert(I, Value);
            Result := I;
            Exit;
          end;
      end
      else
      begin
        Insert(I, Value);
        Result := I;
      end;
    end
    else
      Result := inherited Add(Pointer(Value));
  end;
end;

procedure TIntegerList.DoSort;
var
  Values: array of Integer;
  I, L: Integer;
begin
  SetLength(Values, Count);
  L := Pred(Count);
  for I := 0 to L do
    Values[I] := Items[I];
  IntegerQuickSort(Values, 0, L);
  FSorted := False;
  for I := 0 to L do
    Items[I] := Values[I];
  FSorted := True;
end;

function TIntegerList.GetItem(Index: Integer): Integer;
begin
  Result := Integer(inherited Get(Index));
end;

function TIntegerList.IndexOf(Item: Integer): Integer;
begin
  Result := inherited IndexOf(Pointer(Item));
end;

procedure TIntegerList.Insert(Index, Item: Integer);
begin
  if FUnique then
end;

procedure TIntegerList.RemoveDuplicates;
var
  Counter: Integer;
begin
  Counter := 1;
  while Counter < Count do
    if Items[Counter] = Items[Pred(Counter)] then
      Delete(Counter)
    else
      Inc(Counter);
end;

procedure TIntegerList.SetItem(Index, Value: Integer);
begin
  if not FUnique and (IndexOf(Value) < 0) then
  begin
    inherited Put(Index, Pointer(Value));
    if Sorted then
      DoSort;
  end;
end;

procedure TIntegerList.SetSorted(const Value: Boolean);
begin
  if FSorted <> Value then
  begin
    FSorted := Value;
    DoSort;
  end;
end;

procedure TIntegerList.SetUnique(const Value: Boolean);
begin
  if FUnique <> Value then
  begin
    FUnique := Value;
    RemoveDuplicates;
  end;
end;

{ TIntegerIndex }

procedure TIntegerIndex.AddItem(const Index, Value: Integer);
var
  I: Integer;
begin
  if Count > 0 then
  begin
    if Value < TIndexItem(FIndex.First).Value then
      I := 0
    else
    begin
      if Value > TIndexItem(FIndex.Last).Value then
        I := Count
      else
        I := FindPos(Value);
    end;
  end
  else
    I := 0;
  InsertItem(I, Index, Value);
end;

function TIntegerIndex.AsText: String;
var
  I: Integer;
begin
  Result := '';
  for I := 0 to Pred(Count) do
    Result := Result + IntToStr(TIndexItem(FIndex[I]).Value) + ' : ' + IntToStr(TIndexItem(FIndex[I]).Index); 
end;

function TIntegerIndex.Count: Integer;
begin
  Result := FIndex.Count;
end;

constructor TIntegerIndex.Create;
begin
  FIndex := TObjectList.Create;
end;

destructor TIntegerIndex.Destroy;
begin
  FreeAndNil(FIndex);
  inherited;
end;

function TIntegerIndex.FindPos(const Value: Integer): Integer;
var
  FromPos, ToPos, I: Integer;
begin
  if Count > 0 then
  begin
    FromPos := 0;
    ToPos := Pred(Count);
    repeat
      I := FromPos + (ToPos - FromPos) div 2;
      if Value < TIndexItem(FIndex[I]).Value then
        ToPos := I
      else
      if Value > TIndexItem(FIndex[I]).Value then
        FromPos := I
      else
        FromPos := ToPos;
    until FromPos = ToPos;
  end
  else
    I := 0;
  Result := I;
end;

function TIntegerIndex.GetIndex(const Value: Integer): Integer;
var
  FromPos, ToPos, I: Integer;
begin
  Result := -1;
  if Count > 0 then
  begin
    FromPos := 0;
    ToPos := Pred(Count);
    repeat
      I := FromPos + (ToPos - FromPos) div 2;
      if Value < TIndexItem(FIndex[I]).Value then
        ToPos := I
      else
      if Value > TIndexItem(FIndex[I]).Value then
        FromPos := I
      else
      begin
        Result := TIndexItem(FIndex[I]).Index;
        Exit;
      end;
    until FromPos = ToPos;
  end
  else
    raise Exception.Create('Не найдено значение индекса!');
end;

procedure TIntegerIndex.InsertItem(const ToPos, Index, Value: Integer);
var
  Tmp: TIndexItem;
begin
  Tmp := TIndexItem.Create(Index, Value);
  if ToPos >= FIndex.Count then
    FIndex.Add(Tmp)
  else
    FIndex.Insert(ToPos, Tmp);
end;

procedure TIntegerIndex.RemoveItem(const Index, Value: Integer);
var
  I: Integer;
begin
  I := GetIndex(Value);
  while (I >= 0) do
  begin
    if (TIndexItem(FIndex[I]).Index = Index) then
      FIndex.Delete(I);
    I := GetIndex(Value);
  end;
end;

{ TIndexItem }

constructor TIndexItem.Create(const AIndex, AValue: Integer);
begin
  FIndex := AIndex;
  FValue := AValue;
end;

end.
