unit uKisContragentsComparison;

interface

{$I KisFlags.pas}

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Grids, ValEdit, StdCtrls;

type
  TFmContragentsComparison = class(TForm)
    gbNewContragent: TGroupBox;
    gbOldContragent: TGroupBox;
    btnSaveNew: TButton;
    btnBackToOld: TButton;
    ValueListEditorNew: TValueListEditor;
    ValueListEditorOld: TValueListEditor;
    procedure ValueListEditorNewDrawCell(Sender: TObject; ACol,
      ARow: Integer; Rect: TRect; State: TGridDrawState);
    procedure FormCreate(Sender: TObject);
    procedure ValueListEditorOldDrawCell(Sender: TObject; ACol,
      ARow: Integer; Rect: TRect; State: TGridDrawState);
  private
    procedure SetGridSize(Grid: TValueListEditor);
    procedure BreakString(Grid: TValueListEditor; ACol, ARow: Integer; Rect: TRect; State: TGridDrawState);
  end;


implementation

{$R *.dfm}

procedure TFmContragentsComparison.ValueListEditorNewDrawCell(
  Sender: TObject; ACol, ARow: Integer; Rect: TRect;
  State: TGridDrawState);
begin
  BreakString(ValueListEditorNew, ACol, ARow, Rect, State);
end;

procedure TFmContragentsComparison.FormCreate(Sender: TObject);
begin
  SetGridSize(ValueListEditorNew);
  SetGridSize(ValueListEditorOld);
end;

procedure TFmContragentsComparison.SetGridSize(Grid: TValueListEditor);
begin
  Grid.ColWidths[0] := 100;
  Grid.ColWidths[1] := 210;
end;

procedure TFmContragentsComparison.BreakString(Grid: TValueListEditor; ACol, ARow: Integer; Rect: TRect; State: TGridDrawState);
var
  S: String;
  H: Integer;
begin
  Grid.Canvas.FillRect(Rect);
  S := Grid.Cells[ACol,ARow];
  Inc(Rect.Top,1);
  Inc(Rect.Left,3);
  Dec(Rect.Right,3);
  H := DrawText(Grid.Canvas.Handle,PChar(s),length(s),Rect,DT_WORDBREAK);
  Inc(H, 2);
  if H > Grid.RowHeights[ARow] then
     Grid.RowHeights[ARow] := H;
end;

procedure TFmContragentsComparison.ValueListEditorOldDrawCell(
  Sender: TObject; ACol, ARow: Integer; Rect: TRect;
  State: TGridDrawState);
begin
  BreakString(ValueListEditorOld, ACol, ARow, Rect, State);
end;

end.
