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
  TGetSortColumnEvent = function (Sender: TObject; Column: TColumn; var Desc: Boolean): Boolean of object;
  TOnDrawSortIcon = procedure (Sender: TObject; aCanvas: TCanvas; const aRect: TRect) of object;

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
    FOnGetSortColumn: TGetSortColumnEvent;
    FOnDrawSortIcon: TOnDrawSortIcon;
    procedure SetLineCount(const Value: Integer);
    procedure DrawTitleCell(const ARect: TRect; ACol, ARow: Integer;
      Column: TColumn; var AState: TGridDrawState);
    procedure SetOnCreateEditor(const Value: TCreateEditorEvent);
    function GetCurrentCol: TColumn;
    procedure SetOnGetSortColumn(const Value: TGetSortColumnEvent);
    procedure SetOnDrawSortIcon(const Value: TOnDrawSortIcon);
  protected
    function DoMouseWheelDown(Shift: TShiftState; MousePos: TPoint): Boolean; override;
    function DoMouseWheelUp(Shift: TShiftState; MousePos: TPoint): Boolean; override;
    procedure DrawCell(ACol, ARow: Longint; ARect: TRect; AState: TGridDrawState); override;
    procedure DrawColumnCell(const aRect: TRect; DataCol: Integer;
      Column: TColumn; State: TGridDrawState); override;
    procedure MultylineDrawText(const Rect: TRect; const AText: String);
    procedure LayoutChanged; override;
    function  CreateEditor: TInplaceEdit; override;
    function CanEditShow: Boolean; override;
    function DoGetSortColumn(Column: TColumn; var Desc: Boolean): Boolean;
    procedure DrawSortIcon(aCanvas: TCanvas; ARect: TRect; Column: TColumn; Desc: Boolean);
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    property Col;
    property Row;
    property CurrentCol: TColumn read GetCurrentCol;
    property InplaceEditor;
    property VisibleRowCount;
  published
    property Multyline: Boolean read FMultyline write FMultyline default False;
    property CaptionLineCount: Integer read FLineCount write SetLineCount default 1;
    //
    property OnCanShowEdit: TLogicColumnEvent read FOnCanShowEdit write FOnCanShowEdit;
    property OnCellColors: TGetCellColorsEvent read FOnCellColors write FOnCellColors;
    property OnCreateEditor: TCreateEditorEvent read FOnCreateEditor write SetOnCreateEditor;
    property OnEditorChange: TNotifyEvent read FOnEditorChange write FOnEditorChange;
    property OnEditorExit: TNotifyEvent read FOnEditorExit write FOnEditorExit;
    property OnEditorKeyPress: TKeyPressEvent read FOnEditorKeyPress write FOnEditorKeyPress;
    property OnGetLogicalValue: TLogicColumnEvent read FOnGetLogicalValue write FOnGetLogicalValue;
    property OnGetSortColumn: TGetSortColumnEvent read FOnGetSortColumn write SetOnGetSortColumn;
    property OnDrawSortIcon: TOnDrawSortIcon read FOnDrawSortIcon write SetOnDrawSortIcon;
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

function TkaDBGrid.DoGetSortColumn(Column: TColumn; var Desc: Boolean): Boolean;
begin
  if Assigned(FOnGetSortColumn) then
    Result := FOnGetSortColumn(Self, Column, Desc)
  else
    Result := False;
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
  Desc: Boolean;
begin
  if (ACol > 0) and (gdFixed in AState) and (dgTitles in Options) and (ARow = 0) then
  begin
    DrawColumn := Columns[Pred(ACol)];
    if DrawColumn = nil then
      inherited
    else
      if DrawColumn.Showing then
        if gdFixed in AState then
        begin
          Self.DrawTitleCell(ARect, ACol, ARow, DrawColumn, AState);
        end
        else
          inherited;
    Desc := False;
    if DoGetSortColumn(DrawColumn, Desc) then
      DrawSortIcon(Canvas, ARect, DrawColumn, Desc);
  end
  else
    inherited;
end;

procedure TkaDBGrid.DrawColumnCell(const aRect: TRect; DataCol: Integer;
  Column: TColumn; State: TGridDrawState);
var
  OldColor, OldFntColor, BkCol, FontCol: TColor;
  CM: TCopyMode;
  OldFs, Fs: TFontStyles;
  IsLogic, LogicValue: Boolean;
  BtnState: Cardinal;
  CheckBoxRect: TRect;
  DrawFocus: Boolean;
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
        Canvas.FillRect(aRect);
        CheckBoxRect := aRect;
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
        Canvas.FillRect(aRect);
        Canvas.Draw(aRect.Left + (aRect.Right - aRect.Left - FMemoGlyph.Width) div 2,
          aRect.Top + (aRect.Bottom - aRect.Top - FMemoGlyph.Height) div 2, FMemoGlyph);
      end
      else
        DefaultDrawDataCell(aRect, Column.Field, State);
    end;
  finally
    Canvas.Brush.Color := OldColor;
    Canvas.Font.Color := OldFntColor;
    Canvas.Font.Style := OldFs;
    Canvas.CopyMode := CM;
  end;
  if (DataLink <> nil) and DataLink.Active then
  begin
//    if Columns.State = csDefault then
//      DrawDataCell(ARect, DrawColumn.Field, AState);
//    DrawColumnCell(ARect, ACol, DrawColumn, AState);
    if DefaultDrawing and (gdSelected in State)
        and ((dgAlwaysShowSelection in Options) or Focused)
        and not (csDesigning in ComponentState)
        and not (dgRowSelect in Options)
        and (UpdateLock = 0)
//        and (ValidParentForm(Self).ActiveControl = Self)
    then
      //  Windows.DrawFocusRect(Handle, ARect);
      DrawFocus := False
    else
      DrawFocus := True;
    if DrawFocus then
    if (gdSelected in State) or (gdFocused in State) then
      Canvas.DrawFocusRect(aRect);
  end;
  inherited DrawColumnCell(aRect, DataCol, Column, State);
end;

procedure TkaDBGrid.DrawSortIcon(aCanvas: TCanvas; ARect: TRect; Column: TColumn; Desc: Boolean);
var
  PenColor: TColor;
  Pen1: TPenRecall;
  X, Y, H: Integer;
  ArrowWidth: Integer;
  Triangle: Boolean;
  TriangleSize: Integer;
  Icon: Boolean;
begin
  Icon := True;
  Triangle := True;
  PenColor := clBlue;
  ArrowWidth := 7 div 2;
  TriangleSize := 7;
  if Icon then
  begin
    if Assigned(FOnDrawSortIcon) then
      FOnDrawSortIcon(Self, aCanvas, ARect);
  end
  else
  begin
  //  if Assigned(FGetSortIconPenColor) then
  //    FGetSortIconPenColor(Self, );
    H := ARect.Bottom - ARect.Top - 4;
    X := ARect.Right - ArrowWidth - 2;
    Y := ARect.Top + 2;
    //
    Pen1 := TPenRecall.Create(aCanvas.Pen);
    try
      aCanvas.Pen.Color := PenColor;
  //    aCanvas.Pen.Width := 2;
      aCanvas.Pen.Style := psSolid;
      if Triangle then
      begin
        H := ARect.Bottom - ARect.Top;
        if Desc then
        begin
          X := ARect.Right - TriangleSize;
          Y := ARect.Top + (H - TriangleSize) div 2;
          aCanvas.MoveTo(X, Y);
          aCanvas.LineTo(X - TriangleSize, Y);
          aCanvas.LineTo(X - TriangleSize div 2 + 1, Y + TriangleSize);
          aCanvas.LineTo(X + 1, Y);
        end
        else
        begin
          X := ARect.Right - TriangleSize;
          Y := ARect.Top + H - TriangleSize;
          aCanvas.MoveTo(X, Y);
          aCanvas.LineTo(X - TriangleSize, Y);
          aCanvas.LineTo(X - TriangleSize div 2 + 1, Y - TriangleSize);
          aCanvas.LineTo(X + 1, Y + 1);
        end;
      end
      else
      begin
        aCanvas.MoveTo(X, Y);
        aCanvas.LineTo(X, Y + H);
        if Desc then
        begin
          aCanvas.MoveTo(X, Y);
          aCanvas.LineTo(X - ArrowWidth, Y + ArrowWidth);
          aCanvas.MoveTo(X, Y);
          aCanvas.LineTo(X + ArrowWidth, Y + ArrowWidth);
        end
        else
        begin
          aCanvas.LineTo(X - ArrowWidth, Y + H - ArrowWidth);
          aCanvas.MoveTo(X, Y + H);
          aCanvas.LineTo(X + ArrowWidth, Y + H - ArrowWidth);
        end;
      end;
    finally
      Pen1.Free;
    end;
  end;
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
  Desc: Boolean;
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

procedure TkaDBGrid.SetOnDrawSortIcon(const Value: TOnDrawSortIcon);
begin
  FOnDrawSortIcon := Value;
end;

procedure TkaDBGrid.SetOnGetSortColumn(const Value: TGetSortColumnEvent);
begin
  FOnGetSortColumn := Value;
end;

end.

