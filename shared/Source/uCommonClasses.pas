unit uCommonClasses;

interface

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
    function BinarySearch(Value: Integer): Integer;
    procedure DoSort; virtual;
    function FindNewItemIndex(Item: Integer): Integer;
  public
    function Add(Value: Integer; CheckIfExists: Boolean): Integer;
    procedure IncItem(Index: Integer);
    function IndexOf(Item: Integer): Integer;
    procedure Insert(Index: Integer; Item: Integer; IndexIsSafe: Boolean);
    //
    property Items[Index: Integer]: Integer read GetItem write SetItem; default;
    property Sorted: Boolean read FSorted write SetSorted;
    property Unique: Boolean read FUnique write SetUnique;
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

  IDecimalSeparator = interface
    ['{5D305C22-1A47-4C8C-9693-FCC8465F6B01}']
    procedure Change(const NewSep: Char);
    procedure Restore();
  end;

  TCommonFactory = class
  public
    class function DecSep: IDecimalSeparator;
  end;

implementation

type
  TDecimalSeparator = class(TInterfacedObject, IDecimalSeparator)
  strict private
    FChanged: Boolean;
    FSaved: Char;
  private
    procedure Change(const NewSep: Char);
    procedure Restore();
  public
    constructor Create;
    destructor Destroy; override;
  end;


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

function TIntegerList.Add(Value: Integer; CheckIfExists: Boolean): Integer;
var
  I: Integer;
begin
  if (not FUnique) and (not FSorted) then
    Result := inherited Add(Pointer(Value))
  else
  begin
    Result := -1;
    if CheckIfExists then
      I := IndexOf(Value)
    else
      I := -1;
    if I >= 0 then
    begin
      if not FUnique then
        if FSorted then
        begin
          Result := FindNewItemIndex(Value);
          Insert(Result, Value, True);
        end;
    end
    else
    begin
      if FSorted then
      begin
        Result := FindNewItemIndex(Value);
        Insert(Result, Value, True);
      end
      else
        Result := inherited Add(Pointer(Value));
    end;
  end;
end;

function TIntegerList.BinarySearch(Value: Integer): Integer;
var
  First, Last, Middle: Integer;
begin
  Result := -1;
  First := 0;
  Last := Pred(Count);
  if Last >= 0 then
    if (Value >= Items[First]) and (Value <= Items[Last]) then
    begin
      while (First < Last) do
      begin
        Middle := First + (Last - First) div 2;
        if (Value <= Items[Middle]) then
          Last := Middle
        else
          First := Middle + 1;
      end;
      if Items[Last] = Value then
        Result := Last;
    end;
end;

procedure TIntegerList.DoSort;
var
  Values: array of Integer;
  I, L: Integer;
begin
  if Count > 0 then
  begin
    SetLength(Values, Count);
    L := Pred(Count);
    for I := 0 to L do
      Values[I] := Items[I];
    IntegerQuickSort(Values, 0, L);
    FSorted := False;
    for I := 0 to L do
      Items[I] := Values[I];
  end;
  FSorted := True;
end;

function TIntegerList.FindNewItemIndex(Item: Integer): Integer;
var
  First, Last, Middle: Integer;
begin
  Result := -1;
  if FSorted then
    if Count = 0 then
      Result := 0
    else
    begin
      First := 0;
      Last := Pred(Count);
      if Item < Items[First] then
        Result := 0
      else
      if Item > Items[Last] then
        Result := Count
      else
      if Last = First then
        Result := 0
      else
      begin
        while (First < Last) and (Result < 0) do
        begin
          Middle := First + (Last - First) div 2;
          if Item = Items[Middle] then
            Result := Middle
          else
          if (Item < Items[Middle]) then
            Last := Middle
          else
            First := Middle + 1;
        end;
        Result := Last;
      end;
    end;
end;

function TIntegerList.GetItem(Index: Integer): Integer;
begin
  Result := Integer(inherited Get(Index));
end;

procedure TIntegerList.IncItem(Index: Integer);
begin
  Items[Index] := Succ(Items[Index]);
end;

function TIntegerList.IndexOf(Item: Integer): Integer;
begin
  if FSorted then
    Result := BinarySearch(Item)
  else
    Result := inherited IndexOf(Pointer(Item));
end;

procedure TIntegerList.Insert(Index, Item: Integer; IndexIsSafe: Boolean);
var
  I: Integer;
  FindPlace: Boolean;
begin
  if not IndexIsSafe then
  begin
    if FUnique then
    begin
      I := IndexOf(Item);
      if I > 0 then
        raise Exception.Create(Format('Элемент %d уже содердится в позиции %d!', [Item, I]));
    end;
    FindPlace := False;
    if FSorted then
    begin
      if Count > 0 then
        if Index = 0 then
          FindPlace := Items[0] < Item
        else
        if Index = Count then
          FindPlace := Items[Pred(Count)] > Item
        else
          FindPlace := (Items[Index] < Item) or (Items[Pred(Index)] > Item);
    end;
    if FindPlace then
      Index := FindNewItemIndex(Item);
  end;
  if Index = Count then
    inherited Add(Pointer(Item))
  else
    inherited Insert(Index, Pointer(Item));
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

{ TCommonFactory }

class function TCommonFactory.DecSep: IDecimalSeparator;
begin
  Result := TDecimalSeparator.Create as IDecimalSeparator;
end;

{ TDecimalSeparator }

procedure TDecimalSeparator.Change(const NewSep: Char);
begin
  FSaved := SysUtils.DecimalSeparator;
  FChanged := True;
end;

constructor TDecimalSeparator.Create;
begin
  FSaved := SysUtils.DecimalSeparator;
  FChanged := False;
end;

destructor TDecimalSeparator.Destroy;
begin
  Restore();
  inherited;
end;

procedure TDecimalSeparator.Restore;
begin
  if FChanged then
    SysUtils.DecimalSeparator := FSaved;
end;

end.
