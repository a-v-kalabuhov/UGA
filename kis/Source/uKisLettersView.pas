unit uKisLettersView;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Menus, Grids, DBGrids, ToolWin, ComCtrls, StdCtrls, ExtCtrls,
  //
  uLegend, uDBGrid, uSplitter,
  //
  uKisMngrView;

type
  TKisLettersView = class(TKisMngrView)
    Splitter: TSplitter;
    dbgCandidates: TDBGrid;
    dbgOrders: TkaDBGrid;
    Splitter1: TSplitter;
    tbOffices: TToolBar;
    Label3: TLabel;
    ToolButton6: TToolButton;
    Label5: TLabel;
    cbOffice: TComboBox;
    tbFilters: TToolBar;
    ToolButton2: TToolButton;
    Label4: TLabel;
    cbDateFilter: TComboBox;
    procedure FormCreate(Sender: TObject);
  end;

implementation

{$R *.dfm}

procedure TKisLettersView.FormCreate(Sender: TObject);
var
   Y, M, D: Word;
begin
  inherited;
  //
  cbDateFilter.Clear;
  cbDateFilter.Items.Add('за всё время');
  //
  DecodeDate(Date, Y, M, D);
  Y:= Y - 1;
  if (M = 2) and (D = 29) then
    D := 28;
  cbDateFilter.Items.Add('за год (с ' + DateToStr(EncodeDate(Y, M, D)) + ')');
  cbDateFilter.ItemIndex := 1;
end;

end.
