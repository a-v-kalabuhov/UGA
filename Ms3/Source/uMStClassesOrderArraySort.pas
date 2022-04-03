unit uMStClassesOrderArraySort;

interface

uses
  uMStKernelInterfaces;

type
  TOrderCompare = function (Left, Right: IOrder): Integer;
  TOrderCompareEvent = function (Left, Right: IOrder): Integer of object;

  /// <summary>
  /// Класс сортировки массива объектов IOrder.
  /// </summary>
  TOrderArraySort = class
  private
//    FOrders: TOrderArray;
    FCompareFunc: TOrderCompare;
    FCompareEvent: TOrderCompareEvent;
    FEvent: Boolean;
    function DoCompare(Left, Right: IOrder): Integer;
    procedure QuickSort(var Orders: array of IOrder; L, R: Integer);
  public
    procedure Sort(var Orders: array of IOrder; CompareFunc: TOrderCompare); overload;
    procedure Sort(var Orders: array of IOrder; CompareEvent: TOrderCompareEvent); overload;
  end;

implementation

{ TOrderArraySort }

procedure TOrderArraySort.Sort(var Orders: array of IOrder; CompareFunc: TOrderCompare);
begin
//  FOrders := FOrders;
  FCompareFunc := CompareFunc;
  FEvent := False;
  QuickSort(Orders, 0, Length(Orders) - 1);
end;

procedure TOrderArraySort.Sort(var Orders: array of IOrder; CompareEvent: TOrderCompareEvent);
begin
//  FOrders := Orders;
  FCompareEvent := CompareEvent;
  FEvent := True;
  QuickSort(Orders, 0, Length(Orders) - 1);
end;

function TOrderArraySort.DoCompare(Left, Right: IOrder): Integer;
begin
  if FEvent then
    Result := FCompareEvent(Left, Right)
  else
    Result := FCompareFunc(Left, Right);
end;

procedure TOrderArraySort.QuickSort(var Orders: array of IOrder; L, R: Integer);
var
  I, J: Integer;
  P, T: IOrder;
begin
  repeat
    I := L;
    J := R;
    P := Orders[(L + R) shr 1];
    repeat
      while DoCompare(Orders[I], P) < 0 do
        Inc(I);
      while DoCompare(Orders[J], P) > 0 do
        Dec(J);
      if I < J then
      begin
        T := Orders[I];
        Orders[I] := Orders[J];
        Orders[J] := T;
      end;
      if I <= J then
      begin
        Inc(I);
        Dec(J);
      end;
    until I > J;
    if L < J then
      QuickSort(Orders, L, J);
    L := I;
  until I >= R;
end;

end.
