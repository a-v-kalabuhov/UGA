{*******************************************************}
{                                                       }
{       "PerVerCL"                                      }
{                                                       }
{       DataBase Grid                                   }
{       (c) Kalabukhov Alex, 2004                       }
{                                                       }
{*******************************************************}

unit uDBGrid;

interface

uses
  Windows, SysUtils, Classes, Controls, Grids, DBGrids, Graphics, Types, DB,
  Math, StdCtrls;

type
  TGetCellColorsEvent = procedure (Sender: TObject; Field: TField;
    var Background, FontColor: TColor; State: TGridDrawState; var FontStyle: TFontStyles) of object;
  TCreateEditorEvent = procedure (Sender: TObject; var aEditor: TInplaceEdit; var DefaultEditor: Boolean) of object;
  TLogicColumnEvent = procedure (Sender: TObject; Column: TColumn; var Value: Boolean) of object;

  TkaDBGrid = class(TDBGrid)
  private
    FMemoGlyph: TBitmap;
    FOnCellColors: TGetCellColorsEvent;
    FMultyline: Boolean;
    FLineCount: Integer;
    FOnCreateEditor: TCreateEditorEvent;
    FOnEditorChange: TNotifyEvent;
    FOnEditorExit: TNotifyEvent;
    FOnEditorKeyPress: TKeyPressEvent;
    FOnLogicalColumn: TLogicColumnEvent;
    FOnGetLogicalValue: TLogicColumnEvent;
    FOnCanShowEdit: TLogicColumnEvent;
    procedure SetLineCount(const Value: Integer);
    procedure DrawTitleCell(const ARect: TRect; ACol, ARow: Integer;
      Column: TColumn; var AState: TGridDrawState);
    procedure SetOnCreateEditor(const Value: TCreateEditorEvent);
    function GetCurrentCol: TColumn;
  protected
    function DoMouseWheelDown(Shift: TShiftState; MousePos: TPoint): Boolean; override;
    function DoMouseWheelUp(Shift: TShiftState; MousePos: TPoint): Boolean; override;
    procedure DrawCell(ACol, ARow: Longint; ARect: TRect; AState: TGridDrawState); override;
    procedure DrawColumnCell(const Rect: TRect; DataCol: Integer;
      Column: TColumn; State: TGridDrawState); override;
    procedure MultylineDrawText(const Rect: TRect; const AText: String);
    procedure LayoutChanged; override;
    function  CreateEditor: TInplaceEdit; override;
    function CanEditShow: Boolean; override;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    property Col;
    property CurrentCol: TColumn read GetCurrentCol;
    property InplaceEditor;
  published
    property Multyline: Boolean read FMultyline write FMultyline default False;
    property CaptionLineCount: Integer read FLineCount write SetLineCount default 1;
    //
    property OnCanShowEdit: TLogicColumnEvent read FOnCanShowEdit write FOnCanShowEdit;
    property OnCellColors: TGetCellColorsEvent read FOnCellColors
      write FOnCellColors;
    property OnCreateEditor: TCreateEditorEvent read FOnCreateEditor write SetOnCreateEditor;
    property OnEditorChange: TNotifyEvent read FOnEditorChange write FOnEditorChange;
    property OnEditorExit: TNotifyEvent read FOnEditorExit write FOnEditorExit;
    property OnEditorKeyPress: TKeyPressEvent read FOnEditorKeyPress write FOnEditorKeyPress;
    property OnGetLogicalValue: TLogicColumnEvent read FOnGetLogicalValue write FOnGetLogicalValue;
    /// <summary>
    /// Ёто событие определ€ет, €вл€етс€ ли колонка логической.
    /// ≈сли €вл€етс€, то в €чейках колонки рисуетс€ галка.
    /// </summary>
    property OnLogicalColumn: TLogicColumnEvent read FOnLogicalColumn write FOnLogicalColumn;
    property OnMouseWheel;
  end;

implementation

{$R MyVCLAdd.res}

{ TkaDBGrid }

function TkaDBGrid.CanEditShow: Boolean;
begin
  Result := inherited CanEditShow;
  if Result and Assigned(FOnCanShowEdit) then
    if (Col >= 0) and (Col < Columns.Count) then
      FOnCanShowEdit(Self, Columns[Col], Result)
    else
      Result := False;
end;

constructor TkaDBGrid.Create(AOwner: TComponent);
begin
  inherited;
  FMemoGlyph := TBitmap.Create;
  FMemoGlyph.LoadFromResourceName(HInstance, 'MEMO_GLYPH');
  FMemoGlyph.Transparent := True;
  FMemoGlyph.TransparentColor := FMemoGlyph.Canvas.Pixels[0, 0];
  FMultyline := False;
  FLineCount := 1;
end;

destructor TkaDBGrid.Destroy;
begin
  FMemoGlyph.Free;
  inherited;
end;

function TkaDBGrid.DoMouseWheelDown(Shift: TShiftState;
  MousePos: TPoint): Boolean;
begin
  Result := True;
  if Assigned(Self.DataSource) and Assigned(Self.DataSource.DataSet) then
    Self.DataSource.DataSet.Next;
end;

function TkaDBGrid.DoMouseWheelUp(Shift: TShiftState;
  MousePos: TPoint): Boolean;
begin
  Result := True;
  if Assigned(Self.DataSource) and Assigned(Self.DataSource.DataSet) then
    Self.DataSource.DataSet.Prior;
end;

procedure TkaDBGrid.DrawCell(ACol, ARow: Integer; ARect: TRect;
  AState: TGridDrawState);
var
  DrawColumn: TColumn;
begin
  if (ACol > 0) and (gdFixed in AState) and (dgTitles in Options) and (ARow = 0) then
  begin
    DrawColumn := Columns[Pred(ACol)];
    if DrawColumn = nil then
      inherited
    else
      if DrawColumn.Showing then
        if gdFixed in AState then
          Self.DrawTitleCell(ARect, ACol, ARow, DrawColumn, AState)
        else
          inherited;
  end
  else
    inherited;
end;

procedure TkaDBGrid.DrawColumnCell(const Rect: TRect; DataCol: Integer;
  Column: TColumn; State: TGridDrawState);
var
  OldColor, OldFntColor, BkCol, FontCol: TColor;
  CM: TCopyMode;
  OldFs, Fs: TFontStyles;
  IsLogic, LogicValue: Boolean;
  BtnState: Cardinal;
  CheckBoxRect: TRect;
begin
  OldColor := Canvas.Brush.Color;
  OldFntColor := Canvas.Font.Color;
  OldFs := Canvas.Font.Style;
  CM := Canvas.CopyMode;
  BkCol := OldColor;
  FontCol := OldFntColor;
  Fs := OldFs;
  try
    if Assigned(FOnCellColors) then
      FOnCellColors(Self, Column.Field, BkCol, FontCol, State, Fs);
    Canvas.Brush.Color := BkCol;
    Canvas.Font.Color := FontCol;
    Canvas.Font.Style := Fs;
    Canvas.CopyMode := cmMergeCopy;
    if Assigned(Column.Field) then
    begin
      IsLogic := False;
      LogicValue := False;
      if Assigned(FOnLogicalColumn) and Assigned(FOnGetLogicalValue) then
      begin
        FOnLogicalColumn(Self, Column, IsLogic);
        if IsLogic then
          FOnGetLogicalValue(Self, Column, LogicValue);
      end;
      if IsLogic then
      begin
        Canvas.FillRect(Rect);
        CheckBoxRect := Rect;
        InflateRect(CheckBoxRect, -1, -1);
        OffsetRect(CheckBoxRect, 1, 1);
        BtnState := DFCS_BUTTONCHECK;
        if LogicValue then
          BtnState := BtnState or DFCS_CHECKED;
        DrawFrameControl(Canvas.Handle, CheckBoxRect, DFC_BUTTON, BtnState);
      end
      else
      if (Column.Field.DataType = ftMemo) or (Column.Field.DataType = ftFmtMemo) then
      begin
        Canvas.FillRect(Rect);
        Canvas.Draw(Rect.Left + (Rect.Right - Rect.Left - FMemoGlyph.Width) div 2,
          Rect.Top + (Rect.Bottom - Rect.Top - FMemoGlyph.Height) div 2, FMemoGlyph);
      end
      else
        DefaultDrawDataCell(Rect, Column.Field, State);
    end;
  finally
    Canvas.Brush.Color := OldColor;
    Canvas.Font.Color := OldFntColor;
    Canvas.Font.Style := OldFs;
    Canvas.CopyMode := CM;
  end;
  inherited;
  if (gdSelected in State) or (gdFocused in State) then
    Canvas.DrawFocusRect(Rect);
end;

procedure TkaDBGrid.LayoutChanged;
begin
  inherited;
  if FMultyline then
    RowHeights[0] := DefaultRowHeight * FLineCount;
end;

procedure TkaDBGrid.MultylineDrawText(const Rect: TRect; const AText: String);
var
  Format: Word;
  R: TRect;
begin
  if FLineCount = 1 then
    Format := DT_SINGLELINE or DT_LEFT
  else
    Format := DT_LEFT or DT_WORDBREAK;
  Canvas.FillRect(Rect);
  R := Rect;
  Windows.DrawText(Canvas.Handle, PChar(AText), Length(AText), R, Format);
end;

procedure TkaDBGrid.SetLineCount(const Value: Integer);
begin
  if FLineCount <> Value then
  begin
    FLineCount := Value;
    LayoutChanged;
  end;
end;

procedure TkaDBGrid.DrawTitleCell(const ARect: TRect; ACol, ARow: Integer;
  Column: TColumn; var AState: TGridDrawState);
const
  ScrollArrows: array [Boolean, Boolean] of Integer =
    ((DFCS_SCROLLRIGHT, DFCS_SCROLLLEFT), (DFCS_SCROLLLEFT, DFCS_SCROLLRIGHT));
var
  MasterCol: TColumn;
  TitleRect, TextRect, ButtonRect: TRect;
  I: Integer;
  InBiDiMode: Boolean;
begin
  TitleRect := CalcTitleRect(Column, ARow, MasterCol);

  if MasterCol = nil then
  begin
    Canvas.FillRect(ARect);
    Exit;
  end;

  Canvas.Font := MasterCol.Title.Font;
  Canvas.Brush.Color := MasterCol.Title.Color;
  if [dgRowLines, dgColLines] * Options = [dgRowLines, dgColLines] then
    InflateRect(TitleRect, -1, -1);
  TextRect := TitleRect;
  I := GetSystemMetrics(SM_CXHSCROLL);
  if ((TextRect.Right - TextRect.Left) > I) and MasterCol.Expandable then
  begin
    Dec(TextRect.Right, I);
    ButtonRect := TitleRect;
    ButtonRect.Left := TextRect.Right;
    I := SaveDC(Canvas.Handle);
    try
      Canvas.FillRect(ButtonRect);
      InflateRect(ButtonRect, -1, -1);
      IntersectClipRect(Canvas.Handle, ButtonRect.Left,
        ButtonRect.Top, ButtonRect.Right, ButtonRect.Bottom);
      InflateRect(ButtonRect, 1, 1);
      InBiDiMode := Canvas.CanvasOrientation = coRightToLeft;
      if InBiDiMode then
        Inc(ButtonRect.Right, GetSystemMetrics(SM_CXHSCROLL) + 4);
      DrawFrameControl(Canvas.Handle, ButtonRect, DFC_SCROLL,
        ScrollArrows[InBiDiMode, MasterCol.Expanded] or DFCS_FLAT);
    finally
      RestoreDC(Canvas.Handle, I);
    end;
  end;
  with MasterCol.Title do
    MultylineDrawText(TextRect, Caption);
  if [dgRowLines, dgColLines] * Options = [dgRowLines, dgColLines] then
  begin
    InflateRect(TitleRect, 1, 1);
    DrawEdge(Canvas.Handle, TitleRect, BDR_RAISEDINNER, BF_BOTTOMRIGHT);
    DrawEdge(Canvas.Handle, TitleRect, BDR_RAISEDINNER, BF_TOPLEFT);
  end;
  AState := AState - [gdFixed];
end;

function TkaDBGrid.GetCurrentCol: TColumn;
//var
//  I: Integer;
begin
  Result := Columns[Col-1];
//  Result := nil;
//  for I := 0 to Columns.Count - 1 do
//    if Columns[I].Index = Col then
//    begin
//      Result := Columns[I];
//      Exit;
//    end;
end;

type
  THackCustomEdit = class(TCustomEdit)
  end;

function TkaDBGrid.CreateEditor: TInplaceEdit;
var
  DefaultEditor: Boolean;
begin
  Result := nil;
  DefaultEditor := True;
  if Assigned(FOnCreateEditor) then
    FOnCreateEditor(Self, Result, DefaultEditor);
  if (not Assigned(Result)) and DefaultEditor then
  begin
    Result := inherited CreateEditor;
    THackCustomEdit(Result).OnChange := FOnEditorChange;
    THackCustomEdit(Result).OnExit := FOnEditorExit;
    THackCustomEdit(Result).OnKeyPress := FOnEditorKeyPress;
  end;
end;

procedure TkaDBGrid.SetOnCreateEditor(const Value: TCreateEditorEvent);
begin
  FOnCreateEditor := Value;
end;

end.

