unit uKisMapScansView;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Menus, StdCtrls, ComCtrls, ToolWin, Grids, DBGrids, ExtCtrls, DB, StrUtils,
  //
  uDBGrid, uLegend, uSplitter,
  //
  uKisMngrView;

type
  TKisMapScansView = class(TKisMngrView)
    Splitter: TSplitter;
    PageControl1: TPageControl;
    TabSheet1: TTabSheet;
    TabSheet2: TTabSheet;
    tbOrders: TToolBar;
    tbConfirmOrder: TToolButton;
    dbgScanOrders: TDBGrid;
    tbTakeBack: TToolBar;
    tbTakeBackOrder: TToolButton;
    dbgOrdersTakeBack: TDBGrid;
    tbRefreshOrders: TToolButton;
    tbRefrefhTakeBake: TToolButton;
    ToolButton1: TToolButton;
    tbCopyFiles: TToolButton;
    tbSortGiveOuts: TToolButton;
    tbSortTakeBacks: TToolButton;
    ToolBar1: TToolBar;
    Label3: TLabel;
    edLocateOrder: TEdit;
    lLocateOrder: TLabel;
    ToolBar2: TToolBar;
    Label4: TLabel;
    edLocateTakeBack: TEdit;
    lLocateTakeBack: TLabel;
    PopupMenu1: TPopupMenu;
    PopupMenu2: TPopupMenu;
    procedure edLocateOrderChange(Sender: TObject);
    procedure dbgScanOrdersColEnter(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure edLocateTakeBackChange(Sender: TObject);
    procedure dbgOrdersTakeBackColEnter(Sender: TObject);
  private
    procedure LocateOrder(Grid: TDBGrid; const aText: string);
    procedure LocateText(DS: TDataSet; const aField: string; aText: string);
    procedure UpdateLocateLabel(Grid: TDBGrid; aLabel: TLabel);
  end;

var
  KisMapScansView: TKisMapScansView;

implementation

{$R *.dfm}

procedure TKisMapScansView.dbgOrdersTakeBackColEnter(Sender: TObject);
begin
  inherited;
  UpdateLocateLabel(dbgOrdersTakeBack, lLocateTakeBack);
end;

procedure TKisMapScansView.dbgScanOrdersColEnter(Sender: TObject);
begin
  inherited;
  UpdateLocateLabel(dbgScanOrders, lLocateOrder);
end;

procedure TKisMapScansView.edLocateOrderChange(Sender: TObject);
begin
  inherited;
  LocateOrder(dbgScanOrders, edLocateOrder.Text);
end;

procedure TKisMapScansView.edLocateTakeBackChange(Sender: TObject);
begin
  inherited;
  LocateOrder(dbgOrdersTakeBack, edLocateTakeBack.Text);
end;

procedure TKisMapScansView.FormShow(Sender: TObject);
begin
  inherited;
  UpdateLocateLabel(dbgScanOrders, lLocateOrder);
  UpdateLocateLabel(dbgOrdersTakeBack, lLocateTakeBack);
end;

procedure TKisMapScansView.LocateOrder(Grid: TDBGrid; const aText: string);
var
  FldName: string;
begin
  if Assigned(Grid.DataSource) then
  if Assigned(Grid.DataSource.DataSet) then
  if Grid.DataSource.DataSet.Active then
    if aText = '' then
    begin
      Grid.DataSource.DataSet.First;
    end
    else
    begin
      FldName := Grid.SelectedField.FieldName;
      LocateText(Grid.DataSource.DataSet, FldName, aText);
    end;
end;

procedure TKisMapScansView.LocateText(DS: TDataSet; const aField: string;
  aText: string);
var
  Rn: Integer;
  Fld: TField;
  S: string;
  Found: Boolean;
begin
  DS.DisableControls;
  try
    Rn := DS.RecNo;
    Fld := DS.FieldByName(aField);
    DS.First;
    Found := False;
    while not (Found or DS.Eof) do
    begin
      S := Fld.AsString;
      Found := StartsText(aText, S);
      if (not Found) and StartsStr('"', S) then
      begin
        Delete(S, 1, 1);
        Found := StartsText(aText, S);
      end;
      if not Found then
      begin
        S := TrimLeft(S);
        Found := StartsText(aText, S);
      end;
      if not Found then
        DS.Next;
    end;
    if not Found then
      DS.RecNo := Rn;
  finally
    DS.EnableControls;
  end;
end;

procedure TKisMapScansView.UpdateLocateLabel;
begin
  aLabel.Caption := '     ' + Grid.Columns[Grid.SelectedIndex].Title.Caption;
end;

end.
