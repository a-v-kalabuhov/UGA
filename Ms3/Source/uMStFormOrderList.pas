unit uMStFormOrderList;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms, Dialogs, Grids, StdCtrls, DateUtils,
  //
  JvgStringGrid,
  //
  uMStKernelInterfaces, uMStClassesOrderArraySort;

type
  TmstOrderListForm = class(TForm)
    grdOrders: TJvgStringGrid;
    lblOrders: TLabel;
    grdMaps: TJvgStringGrid;
    btnOK: TButton;
    btnCancel: TButton;
    lWarn: TLabel;
    procedure grdOrdersSelectCell(Sender: TObject; ACol, ARow: Integer; var CanSelect: Boolean);
    procedure grdMapsGetCellStyle(Sender: TObject; ACol, ARow: Integer;
      var Style: TglGridCellStyle);
    procedure btnOKClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
  private
    FOrders: array of IOrder;
    FMaps: TStringList;
    FGridsPrepared: Boolean;
    FSelRow: Integer;
    FMissedRows: Integer;
  private
    function CompareOrders(L, R: IOrder): Integer;
    procedure LoadOrders(OrderList: TInterfaceList);
    procedure PrepareGrids();
    function SelectedOrder: IOrder;
    procedure ShowOrders();
    procedure SortOrders();
  public
    class function Execute(OrderList: TInterfaceList; Maps: TStrings): IOrder;
  end;

implementation

{$R *.dfm}

{ TmstOrderListForm }

// DONE : надо показывать список планшетов

procedure TmstOrderListForm.btnOKClick(Sender: TObject);
begin
  if FMissedRows > 0 then
  begin
    MessageDlg(
      'В заказе не хватает планшетов для печати отчёта.' + sLineBreak +
      'Продолжить?',
      mtConfirmation,
      [mbYes, mbNo],
      -1,
      mbYes
    );
  end;
  ModalResult := mrOk;
end;

function TmstOrderListForm.CompareOrders(L, R: IOrder): Integer;
begin
  Result := CompareDateTime(L.Date, R.Date);
  if Result = 0 then
  begin
    Result := CompareStr(L.Number, R.Number);
    if Result = 0 then
      Result := CompareStr(L.Address, R.Address);
  end;
end;

class function TmstOrderListForm.Execute(OrderList: TInterfaceList; Maps: TStrings): IOrder;
var
  Frm: TmstOrderListForm;
begin
  Result := nil;
  Frm := TmstOrderListForm.Create(Application);
  try
    Frm.FMaps.Assign(Maps);
    Frm.LoadOrders(OrderList);
    Frm.ShowOrders();
    if Frm.ShowModal = mrOk then
      Result := Frm.SelectedOrder;
  finally
    FreeAndNil(Frm);
  end;
end;

procedure TmstOrderListForm.FormCreate(Sender: TObject);
begin
  FMaps := TStringList.Create;
  grdMaps.HotCursor := crArrow;
  grdOrders.HotCursor := crArrow;
end;

procedure TmstOrderListForm.FormDestroy(Sender: TObject);
begin
  FMaps.Free;
end;

procedure TmstOrderListForm.grdMapsGetCellStyle(Sender: TObject; ACol,
  ARow: Integer; var Style: TglGridCellStyle);
begin
  if ARow >= grdMaps.FixedRows then
  if ARow <= FMissedRows then
  begin
    Style.FontStyle := Style.FontStyle + [fsBold];
    Style.FontColor := clRed; 
  end;
end;

procedure TmstOrderListForm.grdOrdersSelectCell(Sender: TObject; ACol,
  ARow: Integer; var CanSelect: Boolean);
var
  Order: IOrder;
  I, J, Rc: Integer;
  MissedMaps: TStrings;
begin
  if Length(FOrders) > 0 then  
  if ARow <> FSelRow then
  begin
    FSelRow := ARow;
    Order := FOrders[FSelRow - 1];
    MissedMaps := Order.CompareMaps(FMaps);
    try
      FMissedRows := MissedMaps.Count;
      Rc := Order.MapCount + MissedMaps.Count + grdMaps.FixedRows;
      if Rc = 1 then
      begin
        Rc := grdMaps.FixedRows + 1;
        grdMaps.RowCount := Rc;
        grdMaps.Cells[0, 1] := '';
      end
      else
      begin
        grdMaps.RowCount := Rc;
        J := grdMaps.FixedRows;
        for I := 0 to MissedMaps.Count - 1 do
        begin
          grdMaps.Cells[0, J] := MissedMaps[I];
          Inc(J);
        end;
        for I := 0 to Order.MapCount - 1 do
        begin
          grdMaps.Cells[0, J] := Order.Maps[I];
          Inc(J);
        end;
      end;
    finally
      MissedMaps.Free;
    end;
  end;
  //
  lWarn.Visible := FMissedRows > 0;
end;

procedure TmstOrderListForm.LoadOrders(OrderList: TInterfaceList);
var
  I: Integer;
  Order: IOrder;
begin
  SetLength(FOrders, 0);
  if OrderList.Count > 0 then
  begin
    SetLength(FOrders, OrderList.Count);
    for I := 0 to OrderList.Count - 1 do
    begin
      Order := OrderList[I] as IOrder;
      FOrders[I] := Order;
    end;
    SortOrders();
  end;
end;

procedure TmstOrderListForm.PrepareGrids;
begin
  grdOrders.FixedCols := 0;
  grdOrders.FixedRows := 1;
  grdOrders.ColCount := 3;
  grdOrders.Cells[0, 0] := 'Дата';
  grdOrders.ColWidths[0] := 100;
  grdOrders.Cells[1, 0] := 'Номер';
  grdOrders.ColWidths[1] := 100;
  grdOrders.Cells[2, 0] := 'Адрес';
  grdOrders.ColWidths[2] := 200;
  grdMaps.FixedCols := 0;
  grdMaps.FixedRows := 1;
  grdMaps.ColCount := 1;
  grdMaps.Cells[0, 0] := 'Планшет';
end;

function TmstOrderListForm.SelectedOrder: IOrder;
begin
  if Length(FOrders) = 0 then
    Result := nil
  else
    Result := FOrders[grdOrders.Row - 1];
end;

procedure TmstOrderListForm.ShowOrders;
var
  I: Integer;
  Order: IOrder;
begin
  if not FGridsPrepared then
    PrepareGrids();
  if Length(FOrders) = 0 then
    grdOrders.RowCount := 2
  else
  begin
    grdOrders.RowCount := grdOrders.FixedRows + Length(FOrders);
    for I := 1 to Length(FOrders) do
    begin
      Order := FOrders[I - 1];
      grdOrders.Cells[0, I] := Order.DateStr;
      grdOrders.Cells[1, I] := Order.Number;
      grdOrders.Cells[2, I] := Order.Address;
    end;
  end;
  //
  grdOrders.Row := 1;
  grdOrders.Col := 1;
end;

procedure TmstOrderListForm.SortOrders;
var
  OrderSort: TOrderArraySort;
begin
  OrderSort := TOrderArraySort.Create;
  try
    OrderSort.Sort(FOrders, CompareOrders);
  finally
    OrderSort.Free;
  end;
end;

end.
