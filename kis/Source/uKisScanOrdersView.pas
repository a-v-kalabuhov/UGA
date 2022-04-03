unit uKisScanOrdersView;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, uKisMngrView, uLegend, Menus, StdCtrls, ComCtrls, ToolWin, Grids,
  DBGrids, uDBGrid, ExtCtrls;

type
  TKisScanOrdersView = class(TKisMngrView)
    tbFilters: TToolBar;
    ToolButton2: TToolButton;
    Label4: TLabel;
    cbDateFilter: TComboBox;
    ToolButton1: TToolButton;
    ToolButton3: TToolButton;
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  KisScanOrdersView: TKisScanOrdersView;

implementation

{$R *.dfm}

procedure TKisScanOrdersView.FormCreate(Sender: TObject);
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
