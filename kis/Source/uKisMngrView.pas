{*******************************************************}
{                                                       }
{       "ИС МП УГА"                                     }
{       Представление для менеджера                     }
{                                                       }
{       Copyright (c) 2004-2005, МП УГА                 }
{                                                       }
{       Автор: Калабухов А.В.                           }
{                                                       }
{*******************************************************}
{ Описание: стандартное окно для просмотра списка сущностей
  Имя модуля: Manager View
  Версия: 1.11
  Дата последнего изменения: 25.11.2004
  Цель:
  Используется: Kernel Classes
  Использует: KIS Consts
  Исключения: нет }
{
  1.11
     - добавлены средства для быстрой навигации
}
unit uKisMngrView;

interface

uses
  Windows, Messages, SysUtils, Classes, Controls, Forms, Grids, Menus, DBGrids,
  StdCtrls, ExtCtrls, ToolWin, ComCtrls, ActnList, ImgList, Db, ActnMan,
  ActnMenus, ActnCtrls, Graphics,
  // Common
  uDBGrid, uLegend;

type
  TKisSearchEvent = procedure(const SearchStr: String; SearchField: TField) of object;

  TKisMngrView = class(TForm)
    ButtonsPanel: TPanel;
    Button1: TButton;
    Button2: TButton;
    MainMenu: TMainMenu;
    Grid: TkaDBGrid;
    Legend: TkaLegend;
    ToolBar: TToolBar;
    ToolBarNav: TToolBar;
    labNavigator: TLabel;
    edSearch: TEdit;
    LabelSearchField: TLabel;
    NavButtonsPanel: TPanel;
    ToolBarFilter: TToolBar;
    Label2: TLabel;
    edFilter: TEdit;
    Label1: TLabel;
    cbFilterFields: TComboBox;
    ToolButton5: TToolButton;
    cbSetFilter: TCheckBox;
    N1: TMenuItem;
    miBigBtns: TMenuItem;
    procedure ButtonsPanelResize(Sender: TObject);
    procedure GridKeyPress(Sender: TObject; var Key: Char);
    procedure FormShow(Sender: TObject);
    procedure GridKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure edSearchChange(Sender: TObject);
    procedure miBigBtnsClick(Sender: TObject);
  private
    FSearch: TKisSearchEvent;
    FQuickSearchEnabled: Boolean;
    FBigButtons: Boolean;
    procedure DoSearch;
    procedure SetQuickSearchEnabled(const Value: Boolean);
    procedure SetBigButtons(const Value: Boolean);
  public
    constructor Create(AOwner: TComponent); override;
    property OnSearch: TKisSearchEvent read FSearch write FSearch;
    property QuickSearchEnabled: Boolean read FQuickSearchEnabled write SetQuickSearchEnabled;
    property BigButtons: Boolean read FBigButtons write SetBigButtons;
  end;

implementation

{$R *.DFM}

uses
  uKisConsts;

procedure TKisMngrView.ButtonsPanelResize(Sender: TObject);
begin
  Button2.Left := ButtonsPanel.ClientWidth - Button2.Width - 24;
  Button1.Left := ButtonsPanel.ClientWidth - Button2.Left - Button1.Width - 16;
end;

procedure TKisMngrView.GridKeyPress(Sender: TObject; var Key: Char);
begin
  if ButtonsPanel.Visible and (Key = #13) then
    Button1.Click;
end;

procedure TKisMngrView.FormShow(Sender: TObject);
begin
  Grid.SetFocus;
  if Assigned(Grid.OnColEnter) then
     Grid.OnColEnter(Grid);
end;

procedure TKisMngrView.GridKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if Grid.Focused then
  if (ssShift in Shift) then
  case Key of
  VK_LEFT :
    begin
      if Grid.Columns[Grid.SelectedIndex].Width > Grid.Width then
        Grid.Columns[Grid.SelectedIndex].Width := Grid.Width
      else
        if Grid.Columns[Grid.SelectedIndex].Width > 30 then
          Grid.Columns[Grid.SelectedIndex].Width := Grid.Columns[Grid.SelectedIndex].Width - 10;
      Key := 0;
    end;
  VK_RIGHT :
    begin
      if Grid.Columns[Grid.SelectedIndex].Width < Grid.ClientWidth then
        Grid.Columns[Grid.SelectedIndex].Width := Grid.Columns[Grid.SelectedIndex].Width + 10;
      Key := 0;
    end;
  end;
end;

constructor TKisMngrView.Create(AOwner: TComponent);
begin
  inherited;
//  DoubleBuffered := True;
  Grid.DoubleBuffered := True;
end;

procedure TKisMngrView.DoSearch;
begin
  if Assigned(FSearch) then
    FSearch(edSearch.Text, Grid.SelectedField);
end;

procedure TKisMngrView.edSearchChange(Sender: TObject);
begin
  if edSearch.Modified then DoSearch;
end;

procedure TKisMngrView.SetQuickSearchEnabled(const Value: Boolean);
begin
  FQuickSearchEnabled := Value;
  if FQuickSearchEnabled then
     edSearch.Color := clWhite
  else
     edSearch.Color := clBtnFace;
  edSearch.Enabled := FQuickSearchEnabled;
end;

procedure TKisMngrView.SetBigButtons(const Value: Boolean);
begin
  if FBigButtons <> Value then
  begin
    FBigButtons := Value;
    miBigBtns.Checked := FBigButtons;
    ToolBar.ShowCaptions := FBigButtons;
    if not ToolBar.ShowCaptions then
    begin
      ToolBar.ButtonWidth := 23;
      ToolBar.ButtonHeight := 23;
    end;
  end;
end;

procedure TKisMngrView.miBigBtnsClick(Sender: TObject);
begin
  BigButtons := not BigButtons;
end;

end.
