unit EzColorPicker;

{$WARN SYMBOL_DEPRECATED OFF} 

// This unit contains a special speed button which can be used to let the user select
// a specific color. The control does not use the standard Windows color dialog, but
// a popup window very similar to the one in Office97, which has been improved a lot
// to support the task of picking one color out of millions. Included is also the
// ability to pick one of the predefined system colors (e.g. clBtnFace).
// Note: The layout is somewhat optimized to look pretty with the predefined box size
//       of 18 pixels (the size of one little button in the predefined color area) and
//       the number of color comb levels. It is easily possible to change this, but
//       if you want to do so then you have probably to make some additional
//       changes to the overall layout.
//
// (BCB check by Josue Andrade Gomes gomesj@bsi.com.br)
//
// (c) 1999, written by Dipl. Ing. Mike Lischke (public@lischke-online.de)
// All rights reserved. 
// Portions copyright by Borland. The implementation of the speed button has been
// taken from Delphi sources.
//
// 22-JUN-99 ml: a few improvements for the overall layout (mainly indicator rectangle
//               does now draw in four different styles and considers the layout
//               property of the button (changed to version 1.2, BCB compliance is
//               now proved by Josue Andrade Gomes)
// 18-JUN-99 ml: message redirection bug removed (caused an AV under some circumstances)
//               and accelerator key handling bug removed (wrong flag for EndSelection)
//               (changed to version 1.1)
// 16-JUN-99 ml: initial release
//
// Notes from EzSoft Engineering: Named changed to TEzColorBox to avoid incompatibility
// issues with previous version of EzGIS/EzCAD
// Changed the behaviour to adapt to support Transparent definition for
// a color and a TColorDialog is used in order to support wide range/standard of color selection

{$I EZ_FLAG.PAS}
interface

uses Windows, Messages, SysUtils, Classes, Controls, Forms, Graphics, StdCtrls,
     ExtCtrls, CommCtrl, Dialogs, EzBase;

const // constants used in OnHint and internally to indicate a specific cell
      NoneColorCell = -3;
      CustomCell = -2;
      NoCell = -1;

type
  TButtonLayout = (blGlyphLeft, blGlyphRight, blGlyphTop, blGlyphBottom);
  TButtonState = (bsUp, bsDisabled, bsDown, bsExclusive);
  TButtonStyle = (bsAutoDetect, bsWin31, bsNew);
  TNumGlyphs = 1..4;

  TIndicatorBorder = (ibNone, ibFlat, ibSunken, ibRaised);

  THintEvent = procedure(Sender: TObject; Cell: Integer; var Hint: String) of object;
  TDropChangingEvent = procedure(Sender: TObject; var Allowed: Boolean) of object;

  { name changed for avoid compatibility problems }
  TEzColorBox = class(TCustomControl)
  private
    FGroupIndex: Integer;
    FGlyph: Pointer;
    FDown: Boolean;
    FDragging: Boolean;
    FAllowAllUp: Boolean;
    FLayout: TButtonLayout;
    FSpacing: Integer;
    FMargin: Integer;
    FFlat: Boolean;
    FMouseInControl: Boolean;
    FTransparent: Boolean;
    FIndicatorBorder: TIndicatorBorder;

    FDropDownArrowColor: TColor;
    FDropDownWidth: Integer;
    FDropDownZone: Boolean;
    FDroppedDown: Boolean;
    FSelectionColor: TColor;
    FState: TButtonState;
    FColorPopup: TWinControl;
    FPopupWnd: HWND;

    FOnChange,
    FOnNoneColorSelect,
    FOnDropChanged: TNotifyEvent;
    FOnDropChanging: TDropChangingEvent;
    FOnHint: THintEvent;
    procedure GlyphChanged(Sender: TObject);
    procedure UpdateExclusive;
    function GetGlyph: TBitmap;
    procedure SetDropDownArrowColor(Value: TColor);
    procedure SetDropDownWidth(Value: integer);
    procedure SetGlyph(Value: TBitmap);
    function GetNumGlyphs: TNumGlyphs;
    procedure SetNumGlyphs(Value: TNumGlyphs);
    procedure SetDown(Value: Boolean);
    procedure SetFlat(Value: Boolean);
    procedure SetAllowAllUp(Value: Boolean);
    procedure SetGroupIndex(Value: Integer);
    procedure SetLayout(Value: TButtonLayout);
    procedure SetSpacing(Value: Integer);
    procedure SetMargin(Value: Integer);
    procedure UpdateTracking;
    procedure CMEnabledChanged(var Message: TMessage); message CM_ENABLEDCHANGED;
    procedure CMButtonPressed(var Message: TMessage); message CM_BUTTONPRESSED;
    procedure CMDialogChar(var Message: TCMDialogChar); message CM_DIALOGCHAR;
    procedure CMFontChanged(var Message: TMessage); message CM_FONTCHANGED;
    procedure CMTextChanged(var Message: TMessage); message CM_TEXTCHANGED;
    procedure CMSysColorChange(var Message: TMessage); message CM_SYSCOLORCHANGE;
    procedure CMMouseEnter(var Message: TMessage); message CM_MOUSEENTER;
    procedure CMMouseLeave(var Message: TMessage); message CM_MOUSELEAVE;
    procedure WMLButtonDblClk(var Message: TWMLButtonDown); message WM_LBUTTONDBLCLK;
    procedure CMEnter(var Message: TCMEnter); message CM_ENTER;
    procedure CMExit(var Message: TCMExit); message CM_EXIT;

    procedure DrawButtonSeperatorUp(Canvas: TCanvas);
    procedure DrawButtonSeperatorDown(Canvas: TCanvas);
    procedure DrawTriangle(Canvas: TCanvas; Top, Left, Width: Integer);
    procedure SetDroppedDown(const Value: Boolean);
    procedure SetSelectionColor(const Value: TColor);
    procedure PopupWndProc(var Msg: TMessage);
    function GetCustomText: String;
    procedure SetCustomText(const Value: String);
    function GetNoneColorText: String;
    procedure SetNoneColorText(const Value: String);
    procedure SetShowSystemColors(const Value: Boolean);
    function GetShowSystemColors: Boolean;
    procedure SetTransparent(const Value: Boolean);
    procedure SetIndicatorBorder(const Value: TIndicatorBorder);
    function GetPopupSpacing: Integer;
    procedure SetPopupSpacing(const Value: Integer);
  protected
    procedure DoNoneColorEvent; virtual;
    function GetPalette: HPALETTE; override;
    procedure Loaded; override;
    procedure MouseDown(Button: TMouseButton; Shift: TShiftState; X, Y: Integer); override;
    procedure MouseMove(Shift: TShiftState; X, Y: Integer); override;
    procedure MouseUp(Button: TMouseButton; Shift: TShiftState; X, Y: Integer); override;
    procedure Paint; override;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;

    procedure Click; override;

    property DroppedDown: Boolean read FDroppedDown write SetDroppedDown;
    { only for compatibility with TEzColorBox}
    property Selected: TColor read FSelectionColor write SetSelectionColor;
  published

    property TabOrder;
    property TabStop;
    property Action;
    property AllowAllUp: Boolean read FAllowAllUp write SetAllowAllUp default False;
    property Anchors;
    property BiDiMode;
    property Caption;
    property Constraints;
    property CustomText: String read GetCustomText write SetCustomText;
    property NoneColorText: String read GetNoneColorText write SetNoneColorText;
    property Down: Boolean read FDown write SetDown default False;
    property DropDownArrowColor: TColor read FDropDownArrowColor write SetDropDownArrowColor default clBlack;
    property DropDownWidth: integer read FDropDownWidth write SetDropDownWidth default 15;
    property Enabled;
    property Flat: Boolean read FFlat write SetFlat default False;
    property Font;
    property Glyph: TBitmap read GetGlyph write SetGlyph;
    property GroupIndex: Integer read FGroupIndex write SetGroupIndex default 0;
    property IndicatorBorder: TIndicatorBorder read FIndicatorBorder write SetIndicatorBorder default ibFlat;
    property Layout: TButtonLayout read FLayout write SetLayout default blGlyphLeft;
    property Margin: Integer read FMargin write SetMargin default -1;
    property NumGlyphs: TNumGlyphs read GetNumGlyphs write SetNumGlyphs default 1;
    property ParentBiDiMode;
    property ParentFont;
    property ParentShowHint;
    property PopupSpacing: Integer read GetPopupSpacing write SetPopupSpacing;
    property SelectionColor: TColor read FSelectionColor write SetSelectionColor default clBlack;
    property ShowHint;
    property ShowSystemColors: Boolean read GetShowSystemColors write SetShowSystemColors;
    property Spacing: Integer read FSpacing write SetSpacing default 4;
    property Transparent: Boolean read FTransparent write SetTransparent default True;
    property Visible;

    property OnChange: TNotifyEvent read FOnChange write FOnChange;
    property OnClick;
    property OnDblClick;
    property OnNoneColorSelect: TNotifyEvent read FOnNoneColorSelect write FOnNoneColorSelect;
    property OnDropChanged: TNotifyEvent read FOnDropChanged write FOnDropChanged;
    property OnDropChanging: TDropChangingEvent read FOnDropChanging write FOnDropChanging;
    property OnHint: THintEvent read FOnHint write FOnHint;
    property OnMouseDown;
    property OnMouseMove;
    property OnMouseUp;
    property OnEnter;
    Property OnExit;
  end;

//procedure Register;

//-----------------------------------------------------------------------------

implementation

uses
  ImgList, EzConsts;

const DRAW_BUTTON_UP = 8208;
      DRAW_BUTTON_DOWN = 8720;

type TColorEntry = record
       Name: PChar;
       case Boolean of
         True: (R, G, B, reserved: Byte);
         False: (Color: COLORREF);
     end;

const DefaultColorCount = 40;
      // these colors are the same as used in Office 97/2000
      DefaultColors : array[0..DefaultColorCount - 1] of TColorEntry = (
        (Name: 'Black'; Color: $000000),
        (Name: 'Brown'; Color: $003399),
        (Name: 'Olive Green'; Color: $003333),
        (Name: 'Dark Green'; Color: $003300),
        (Name: 'Dark Teal'; Color: $663300),
        (Name: 'Dark blue'; Color: $800000),
        (Name: 'Indigo'; Color: $993333),
        (Name: 'Gray-80%'; Color: $333333),

        (Name: 'Dark Red'; Color: $000080),
        (Name: 'Orange'; Color: $0066FF),
        (Name: 'Dark Yellow'; Color: $008080),
        (Name: 'Green'; Color: $008000),
        (Name: 'Teal'; Color: $808000),
        (Name: 'Blue'; Color: $FF0000),
        (Name: 'Blue-Gray'; Color: $996666),
        (Name: 'Gray-50%'; Color: $808080),

        (Name: 'Red'; Color: $0000FF),
        (Name: 'Light Orange'; Color: $0099FF),
        (Name: 'Lime'; Color: $00CC99),
        (Name: 'Sea Green'; Color: $669933),
        (Name: 'Aqua'; Color: $CCCC33),
        (Name: 'Light Blue'; Color: $FF6633),
        (Name: 'Violet'; Color: $800080),
        (Name: 'Grey-40%'; Color: $969696),

        (Name: 'Pink'; Color: $FF00FF),
        (Name: 'Gold'; Color: $00CCFF),
        (Name: 'Yellow'; Color: $00FFFF),
        (Name: 'Bright Green'; Color: $00FF00),
        (Name: 'Turquoise'; Color: $FFFF00),
        (Name: 'Sky Blue'; Color: $FFCC00),
        (Name: 'Plum'; Color: $663399),
        (Name: 'Gray-25%'; Color: $C0C0C0),

        (Name: 'Rose'; Color: $CC99FF),
        (Name: 'Tan'; Color: $99CCFF),
        (Name: 'Light Yellow'; Color: $99FFFF),
        (Name: 'Light Green'; Color: $CCFFCC),
        (Name: 'Light Turquoise'; Color: $FFFFCC),
        (Name: 'Pale Blue'; Color: $FFCC99),
        (Name: 'Lavender'; Color: $FF99CC),
        (Name: 'White'; Color: $FFFFFF)
      );

      SysColorCount = 25;
      SysColors : array[0..SysColorCount - 1] of TColorEntry = (
        (Name: 'Scroll bar'; Color: COLORREF(clScrollBar)),
        (Name: 'Background'; Color: COLORREF(clBackground)),
        (Name: 'Active caption'; Color: COLORREF(clActiveCaption)),
        (Name: 'Inactive caption'; Color: COLORREF(clInactiveCaption)),
        (Name: 'Menu'; Color: COLORREF(clMenu)),
        (Name: 'Window'; Color: COLORREF(clWindow)),
        (Name: 'Window frame'; Color: COLORREF(clWindowFrame)),
        (Name: 'Menu text'; Color: COLORREF(clMenuText)),
        (Name: 'Window text'; Color: COLORREF(clWindowText)),
        (Name: 'Caption text'; Color: COLORREF(clCaptionText)),
        (Name: 'Active border'; Color: COLORREF(clActiveBorder)),
        (Name: 'Inactive border'; Color: COLORREF(clInactiveBorder)),
        (Name: 'Application workspace'; Color: COLORREF(clAppWorkSpace)),
        (Name: 'Highlight'; Color: COLORREF(clHighlight)),
        (Name: 'Highlight text'; Color: COLORREF(clHighlightText)),
        (Name: 'Button face'; Color: COLORREF(clBtnFace)),
        (Name: 'Button shadow'; Color: COLORREF(clBtnShadow)),
        (Name: 'Gray text'; Color: COLORREF(clGrayText)),
        (Name: 'Button text'; Color: COLORREF(clBtnText)),
        (Name: 'Inactive caption text'; Color: COLORREF(clInactiveCaptionText)),
        (Name: 'Button highlight'; Color: COLORREF(clBtnHighlight)),
        (Name: '3D dark shadow'; Color: COLORREF(cl3DDkShadow)),
        (Name: '3D light'; Color: COLORREF(cl3DLight)),
        (Name: 'Info text'; Color: COLORREF(clInfoText)),
        (Name: 'Info background'; Color: COLORREF(clInfoBk))
      );

type
  TGlyphList = class(TImageList)
  private
    FUsed: TBits;
    FCount: Integer;
    function AllocateIndex: Integer;
  public
    constructor CreateSize(AWidth, AHeight: Integer);
    destructor Destroy; override;

    function AddMasked(Image: TBitmap; MaskColor: TColor): Integer;
    procedure Delete(Index: Integer);
    property Count: Integer read FCount;
  end;

  TGlyphCache = class
  private
    FGlyphLists: TList;
  public
    constructor Create;
    destructor Destroy; override;

    function GetList(AWidth, AHeight: Integer): TGlyphList;
    procedure ReturnList(List: TGlyphList);
    function Empty: Boolean;
  end;

  TButtonGlyph = class
  private
    FOriginal: TBitmap;
    FGlyphList: TGlyphList;
    FIndexes: array[TButtonState] of Integer;
    FTransparentColor: TColor;
    FNumGlyphs: TNumGlyphs;
    FOnChange: TNotifyEvent;
    procedure GlyphChanged(Sender: TObject);
    procedure SetGlyph(Value: TBitmap);
    procedure SetNumGlyphs(Value: TNumGlyphs);
    procedure Invalidate;
    function CreateButtonGlyph(State: TButtonState): Integer;
    procedure DrawButtonGlyph(Canvas: TCanvas; const GlyphPos: TPoint;
      State: TButtonState; Transparent: Boolean);
    procedure DrawButtonText(Canvas: TCanvas; const Caption: string;
      TextBounds: TRect; State: TButtonState; BiDiFlags: Longint);
    procedure CalcButtonLayout(Canvas: TCanvas; const Client: TRect;
      const Offset: TPoint; const Caption: string; Layout: TButtonLayout;
      Margin, Spacing: Integer; var GlyphPos: TPoint; var TextBounds: TRect;
      const DropDownWidth: Integer; BiDiFlags: Longint);
  public
    constructor Create;
    destructor Destroy; override;

    function Draw(Canvas: TCanvas; const Client: TRect; const Offset: TPoint;
      const Caption: string; Layout: TButtonLayout; Margin, Spacing: Integer;
      State: TButtonState; Transparent: Boolean;
      const DropDownWidth: Integer; BiDiFlags: Longint): TRect;

    property Glyph: TBitmap read FOriginal write SetGlyph;
    property NumGlyphs: TNumGlyphs read FNumGlyphs write SetNumGlyphs;
    property OnChange: TNotifyEvent read FOnChange write FOnChange;
  end;

  TFloatPoint = record
    X, Y: Extended;
  end;

  TRGB = record
    Red, Green, Blue: Single;
  end;

  TSelectionMode = (smNone, smColor, smBW, smRamp);
  
  TColorPopup = class(TWinControl)
  private
    FNoneColorText,
    FCustomText: String;
    FCurrentColor: TCOlor;
    FCanvas: TCanvas;
    FMargin,
    FSpacing,
    FColumnCount,
    FRowCount,
    FSysRowCount,
    FBoxSize: Integer;
    FSelectedIndex,
    FHoverIndex: Integer;
    FWindowRect,
    FCustomTextRect,
    FNoneColorTextRect,
    FCustomColorRect: TRect;
    FShowSysColors: Boolean;

    // custom color picking
    FCustomColor: TColor;
    procedure SelectColor(Color: TColor);
    procedure ChangeHoverSelection(Index: Integer);
    procedure DrawCell(Index: Integer);
    procedure InvalidateCell(Index: Integer);
    procedure EndSelection(Cancel: Boolean);
    function GetCellRect(Index: Integer; var Rect: TRect): Boolean;
    function GetColumn(Index: Integer): Integer;
    function GetIndex(Row, Col: Integer): Integer;
    function GetRow(Index: Integer): Integer;
    procedure Initialise;
    procedure AdjustWindow;
    procedure SetSpacing(Value: Integer);
    procedure SetSelectedColor(const Value: TColor);
    procedure CMHintShow(var Message: TMessage); message CM_HINTSHOW;
    procedure CNKeyDown(var Message: TWMKeyDown); message CN_KEYDOWN;
    procedure CNSysKeyDown(var Message: TWMChar); message CN_SYSKEYDOWN;
    procedure WMActivateApp(var Message: TWMActivateApp); message WM_ACTIVATEAPP;
    procedure WMLButtonDown(var Message: TWMLButtonDown); message WM_LBUTTONDOWN;
    procedure WMKillFocus(var Message: TWMKillFocus); message WM_KILLFOCUS;
    procedure WMLButtonUp(var Message: TWMLButtonUp); message WM_LBUTTONUP;
    procedure WMMouseMove(var Message: TWMMouseMove); message WM_MOUSEMOVE;
    procedure WMPaint(var Message: TWMPaint); message WM_PAINT;
    function SelectionFromPoint(P: TPoint): Integer;
    function GetHint(Cell: Integer): String;
    procedure DrawSeparator(Left, Top, Right: Integer);
    procedure ChangeSelection(NewSelection: Integer);
  protected
    procedure CreateParams(var Params: TCreateParams); override;
    procedure CreateWnd; override;
    procedure ShowPopupAligned;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;

    property SelectedColor: TColor read FCurrentColor write SetSelectedColor;
    property Spacing: Integer read FSpacing write SetSpacing;
  end;

var GlyphCache: TGlyphCache;

//----------------- TGlyphList ------------------------------------------------

constructor TGlyphList.CreateSize(AWidth, AHeight: Integer);

begin
  inherited CreateSize(AWidth, AHeight);
  FUsed := TBits.Create;
end;

//-----------------------------------------------------------------------------

destructor TGlyphList.Destroy;

begin
  FUsed.Free;
  inherited Destroy;
end;

//-----------------------------------------------------------------------------

function TGlyphList.AllocateIndex: Integer;

begin
  Result := FUsed.OpenBit;
  if Result >= FUsed.Size then
  begin
    Result := inherited Add(nil, nil);
    FUsed.Size := Result + 1;
  end;
  FUsed[Result] := True;
end;

//-----------------------------------------------------------------------------

function TGlyphList.AddMasked(Image: TBitmap; MaskColor: TColor): Integer;

begin
  Result := AllocateIndex;
  ReplaceMasked(Result, Image, MaskColor);
  Inc(FCount);
end;

//-----------------------------------------------------------------------------

procedure TGlyphList.Delete(Index: Integer);

begin
  if FUsed[Index] then
  begin
    Dec(FCount);
    FUsed[Index] := False;
  end;
end;

//----------------- TGlyphCache -----------------------------------------------

constructor TGlyphCache.Create;

begin
  inherited Create;
  FGlyphLists := TList.Create;
end;

//-----------------------------------------------------------------------------

destructor TGlyphCache.Destroy;

begin
  FGlyphLists.Free;
  inherited Destroy;
end;

//-----------------------------------------------------------------------------

function TGlyphCache.GetList(AWidth, AHeight: Integer): TGlyphList;

var I: Integer;

begin
  for I := FGlyphLists.Count - 1 downto 0 do
  begin
    Result := FGlyphLists[I];
    with Result do
      if (AWidth = Width) and (AHeight = Height) then Exit;
  end;
  Result := TGlyphList.CreateSize(AWidth, AHeight);
  FGlyphLists.Add(Result);
end;

//-----------------------------------------------------------------------------

procedure TGlyphCache.ReturnList(List: TGlyphList);

begin
  if List = nil then Exit;
  if List.Count = 0 then
  begin
    FGlyphLists.Remove(List);
    List.Free;
  end;
end;

//-----------------------------------------------------------------------------

function TGlyphCache.Empty: Boolean;

begin
  Result := FGlyphLists.Count = 0;
end;

//----------------- TButtonGlyph ----------------------------------------------

constructor TButtonGlyph.Create;

var I: TButtonState;

begin
  inherited Create;
  FOriginal := TBitmap.Create;
  FOriginal.OnChange := GlyphChanged;
  FTransparentColor := clOlive;
  FNumGlyphs := 1;
  for I := Low(I) to High(I) do FIndexes[I] := -1;
  if GlyphCache = nil then GlyphCache := TGlyphCache.Create;
end;

//-----------------------------------------------------------------------------

destructor TButtonGlyph.Destroy;

begin
  FOriginal.Free;
  Invalidate;
  if Assigned(GlyphCache) and GlyphCache.Empty then
  begin
    GlyphCache.Free;
    GlyphCache := nil;
  end;
  inherited Destroy;
end;

//-----------------------------------------------------------------------------

procedure TButtonGlyph.Invalidate;

var I: TButtonState;

begin
  for I := Low(I) to High(I) do
  begin
    if FIndexes[I] <> -1 then FGlyphList.Delete(FIndexes[I]);
    FIndexes[I] := -1;
  end;
  GlyphCache.ReturnList(FGlyphList);
  FGlyphList := nil;
end;

//-----------------------------------------------------------------------------

procedure TButtonGlyph.GlyphChanged(Sender: TObject);

begin
  if Sender = FOriginal then
  begin
    FTransparentColor := FOriginal.TransparentColor;
    Invalidate;
    if Assigned(FOnChange) then FOnChange(Self);
  end;
end;

//-----------------------------------------------------------------------------

procedure TButtonGlyph.SetGlyph(Value: TBitmap);

var Glyphs: Integer;

begin
  Invalidate;
  FOriginal.Assign(Value);
  if (Value <> nil) and (Value.Height > 0) then
  begin
    FTransparentColor := Value.TransparentColor;
    if Value.Width mod Value.Height = 0 then
    begin
      Glyphs := Value.Width div Value.Height;
      if Glyphs > 4 then Glyphs := 1;
      SetNumGlyphs(Glyphs);
    end;
  end;
end;

//-----------------------------------------------------------------------------

procedure TButtonGlyph.SetNumGlyphs(Value: TNumGlyphs);

begin
  if (Value <> FNumGlyphs) and (Value > 0) then
  begin
    Invalidate;
    FNumGlyphs := Value;
    GlyphChanged(Glyph);
  end;
end;

//-----------------------------------------------------------------------------

function TButtonGlyph.CreateButtonGlyph(State: TButtonState): Integer;

const ROP_DSPDxax = $00E20746;

var TmpImage, DDB, MonoBmp: TBitmap;
    IWidth, IHeight: Integer;
    IRect, ORect: TRect;
    I: TButtonState;
    DestDC: HDC;

begin
  if (State = bsDown) and (NumGlyphs < 3) then State := bsUp;
  Result := FIndexes[State];
  if Result <> -1 then Exit;
  if (FOriginal.Width or FOriginal.Height) = 0 then Exit;

  IWidth := FOriginal.Width div FNumGlyphs;
  IHeight := FOriginal.Height;
  if FGlyphList = nil then
  begin
    if GlyphCache = nil then GlyphCache := TGlyphCache.Create;
    FGlyphList := GlyphCache.GetList(IWidth, IHeight);
  end;
  TmpImage := TBitmap.Create;
  try
    TmpImage.Width := IWidth;
    TmpImage.Height := IHeight;
    IRect := Rect(0, 0, IWidth, IHeight);
    TmpImage.Canvas.Brush.Color := clBtnFace;
    TmpImage.Palette := CopyPalette(FOriginal.Palette);
    I := State;
    if Ord(I) >= NumGlyphs then I := bsUp;
    ORect := Rect(Ord(I) * IWidth, 0, (Ord(I) + 1) * IWidth, IHeight);
    case State of
      bsUp, bsDown,
      bsExclusive:
        begin
          TmpImage.Canvas.CopyRect(IRect, FOriginal.Canvas, ORect);
          if FOriginal.TransparentMode = tmFixed then
            FIndexes[State] := FGlyphList.AddMasked(TmpImage, FTransparentColor)
          else
            FIndexes[State] := FGlyphList.AddMasked(TmpImage, clDefault);
        end;
      bsDisabled:
        begin
          MonoBmp := nil;
          DDB := nil;
          try
            MonoBmp := TBitmap.Create;
            DDB := TBitmap.Create;
            DDB.Assign(FOriginal);
            DDB.HandleType := bmDDB;
            if NumGlyphs > 1 then
            with TmpImage.Canvas do
            begin
              // Change white & gray to clBtnHighlight and clBtnShadow
              CopyRect(IRect, DDB.Canvas, ORect);
              MonoBmp.Monochrome := True;
              MonoBmp.Width := IWidth;
              MonoBmp.Height := IHeight;

              // Convert white to clBtnHighlight
              DDB.Canvas.Brush.Color := clWhite;
              MonoBmp.Canvas.CopyRect(IRect, DDB.Canvas, ORect);
              Brush.Color := clBtnHighlight;
              DestDC := Handle;
              SetTextColor(DestDC, clBlack);
              SetBkColor(DestDC, clWhite);
              BitBlt(DestDC, 0, 0, IWidth, IHeight, MonoBmp.Canvas.Handle, 0, 0, ROP_DSPDxax);

              // Convert gray to clBtnShadow
              DDB.Canvas.Brush.Color := clGray;
              MonoBmp.Canvas.CopyRect(IRect, DDB.Canvas, ORect);
              Brush.Color := clBtnShadow;
              DestDC := Handle;
              SetTextColor(DestDC, clBlack);
              SetBkColor(DestDC, clWhite);
              BitBlt(DestDC, 0, 0, IWidth, IHeight, MonoBmp.Canvas.Handle, 0, 0, ROP_DSPDxax);

              // Convert transparent color to clBtnFace
              DDB.Canvas.Brush.Color := ColorToRGB(FTransparentColor);
              MonoBmp.Canvas.CopyRect(IRect, DDB.Canvas, ORect);
              Brush.Color := clBtnFace;
              DestDC := Handle;
              SetTextColor(DestDC, clBlack);
              SetBkColor(DestDC, clWhite);
              BitBlt(DestDC, 0, 0, IWidth, IHeight, MonoBmp.Canvas.Handle, 0, 0, ROP_DSPDxax);
            end
            else
            begin
              // Create a disabled version
              with MonoBmp do
              begin
                Assign(FOriginal);
                HandleType := bmDDB;
                Canvas.Brush.Color := clBlack;
                Width := IWidth;
                if Monochrome then
                begin
                  Canvas.Font.Color := clWhite;
                  Monochrome := False;
                  Canvas.Brush.Color := clWhite;
                end;
                Monochrome := True;
              end;

              with TmpImage.Canvas do
              begin
                Brush.Color := clBtnFace;
                FillRect(IRect);
                Brush.Color := clBtnHighlight;
                SetTextColor(Handle, clBlack);
                SetBkColor(Handle, clWhite);
                BitBlt(Handle, 1, 1, IWidth, IHeight, MonoBmp.Canvas.Handle, 0, 0, ROP_DSPDxax);
                Brush.Color := clBtnShadow;
                SetTextColor(Handle, clBlack);
                SetBkColor(Handle, clWhite);
                BitBlt(Handle, 0, 0, IWidth, IHeight, MonoBmp.Canvas.Handle, 0, 0, ROP_DSPDxax);
              end;
            end;
          finally
            DDB.Free;
            MonoBmp.Free;
          end;
          FIndexes[State] := FGlyphList.AddMasked(TmpImage, clDefault);
        end;
    end;
  finally
    TmpImage.Free;
  end;
  Result := FIndexes[State];
  FOriginal.Dormant;
end;

//-----------------------------------------------------------------------------

procedure TButtonGlyph.DrawButtonGlyph(Canvas: TCanvas; const GlyphPos: TPoint;
                                       State: TButtonState; Transparent: Boolean);

var Index: Integer;

begin
  if Assigned(FOriginal) then
  begin
    if (FOriginal.Width = 0) or (FOriginal.Height = 0) then Exit;

    Index := CreateButtonGlyph(State);

    with GlyphPos do
      if Transparent or (State = bsExclusive) then
        ImageList_DrawEx(FGlyphList.Handle, Index, Canvas.Handle, X, Y, 0, 0, clNone, clNone, ILD_Transparent)
      else
        ImageList_DrawEx(FGlyphList.Handle, Index, Canvas.Handle, X, Y, 0, 0, ColorToRGB(clBtnFace), clNone, ILD_Normal);
  end;
end;

//-----------------------------------------------------------------------------

procedure TButtonGlyph.DrawButtonText(Canvas: TCanvas; const Caption: string;
                                      TextBounds: TRect; State: TButtonState;
                                      BiDiFlags: Longint);

begin
  with Canvas do
  begin
    Brush.Style := bsClear;
    if State = bsDisabled then
    begin
      OffsetRect(TextBounds, 1, 1);
      Font.Color := clBtnHighlight;
      DrawText(Handle, PChar(Caption), Length(Caption), TextBounds, DT_CENTER or DT_VCENTER or BiDiFlags);
      OffsetRect(TextBounds, -1, -1);
      Font.Color := clBtnShadow;
      DrawText(Handle, PChar(Caption), Length(Caption), TextBounds, DT_CENTER or DT_VCENTER or BiDiFlags);
    end
    else
      DrawText(Handle, PChar(Caption), Length(Caption), TextBounds, DT_CENTER or DT_VCENTER or BiDiFlags);
  end;
end;

//-----------------------------------------------------------------------------

procedure TButtonGlyph.CalcButtonLayout(Canvas: TCanvas; const Client: TRect;
            const Offset: TPoint; const Caption: string; Layout: TButtonLayout; Margin,
            Spacing: Integer; var GlyphPos: TPoint; var TextBounds: TRect;
            const DropDownWidth: Integer; BiDiFlags: Longint);

var TextPos: TPoint;
    ClientSize,
    GlyphSize,
    TextSize: TPoint;
    TotalSize: TPoint;

begin
  if (BiDiFlags and DT_RIGHT) = DT_RIGHT then
    if Layout = blGlyphLeft then Layout := blGlyphRight
                            else
      if Layout = blGlyphRight then Layout := blGlyphLeft;
      
  // calculate the item sizes
  ClientSize := Point(Client.Right - Client.Left - DropDownWidth, Client.Bottom - Client.Top);

  if FOriginal <> nil then GlyphSize := Point(FOriginal.Width div FNumGlyphs, FOriginal.Height)
                      else GlyphSize := Point(0, 0);

  if Length(Caption) > 0 then
  begin
    TextBounds := Rect(0, 0, Client.Right - Client.Left, 0);
    DrawText(Canvas.Handle, PChar(Caption), Length(Caption), TextBounds, DT_CALCRECT or BiDiFlags);
    TextSize := Point(TextBounds.Right - TextBounds.Left, TextBounds.Bottom - TextBounds.Top);
  end
  else
  begin
    TextBounds := Rect(0, 0, 0, 0);
    TextSize := Point(0,0);
  end;

  // If the layout has the glyph on the right or the left, then both the
  // text and the glyph are centered vertically.  If the glyph is on the top
  // or the bottom, then both the text and the glyph are centered horizontally.
  if Layout in [blGlyphLeft, blGlyphRight] then
  begin
    GlyphPos.Y := (ClientSize.Y - GlyphSize.Y + 1) div 2;
    TextPos.Y := (ClientSize.Y - TextSize.Y + 1) div 2;
  end
  else
  begin
    GlyphPos.X := (ClientSize.X - GlyphSize.X + 1) div 2;
    TextPos.X := (ClientSize.X - TextSize.X + 1) div 2;
  end;

  // if there is no text or no bitmap, then Spacing is irrelevant
  if (TextSize.X = 0) or (GlyphSize.X = 0) then Spacing := 0;

  // adjust Margin and Spacing
  if Margin = -1 then
  begin
    if Spacing = -1 then
    begin
      TotalSize := Point(GlyphSize.X + TextSize.X, GlyphSize.Y + TextSize.Y);
      if Layout in [blGlyphLeft, blGlyphRight] then Margin := (ClientSize.X - TotalSize.X) div 3
                                               else Margin := (ClientSize.Y - TotalSize.Y) div 3;
      Spacing := Margin;
    end
    else
    begin
      TotalSize := Point(GlyphSize.X + Spacing + TextSize.X, GlyphSize.Y + Spacing + TextSize.Y);
      if Layout in [blGlyphLeft, blGlyphRight] then Margin := (ClientSize.X - TotalSize.X + 1) div 2
                                               else Margin := (ClientSize.Y - TotalSize.Y + 1) div 2;
    end;
  end
  else
  begin
    if Spacing = -1 then
    begin
      TotalSize := Point(ClientSize.X - (Margin + GlyphSize.X), ClientSize.Y - (Margin + GlyphSize.Y));
      if Layout in [blGlyphLeft, blGlyphRight] then Spacing := (TotalSize.X - TextSize.X) div 2
                                               else Spacing := (TotalSize.Y - TextSize.Y) div 2;
    end;
  end;

  case Layout of
    blGlyphLeft:
      begin
        GlyphPos.X := Margin;
        TextPos.X := GlyphPos.X + GlyphSize.X + Spacing;
      end;
    blGlyphRight:
      begin
        GlyphPos.X := ClientSize.X - Margin - GlyphSize.X;
        TextPos.X := GlyphPos.X - Spacing - TextSize.X;
      end;
    blGlyphTop:
      begin
        GlyphPos.Y := Margin;
        TextPos.Y := GlyphPos.Y + GlyphSize.Y + Spacing;
      end;
    blGlyphBottom:
      begin
        GlyphPos.Y := ClientSize.Y - Margin - GlyphSize.Y;
        TextPos.Y := GlyphPos.Y - Spacing - TextSize.Y;
      end;
  end;

  // fixup the result variables
  with GlyphPos do
  begin
    Inc(X, Client.Left + Offset.X);
    Inc(Y, Client.Top + Offset.Y);
  end;
  OffsetRect(TextBounds, TextPos.X + Client.Left + Offset.X, TextPos.Y + Client.Top + Offset.X);
end;

//-----------------------------------------------------------------------------

function TButtonGlyph.Draw(Canvas: TCanvas; const Client: TRect;
           const Offset: TPoint; const Caption: string; Layout: TButtonLayout;
           Margin, Spacing: Integer; State: TButtonState; Transparent: Boolean;
           const DropDownWidth: Integer; BiDiFlags: Longint): TRect;

var GlyphPos: TPoint;
    R: TRect;

begin
  CalcButtonLayout(Canvas, Client, Offset, Caption, Layout, Margin, Spacing, GlyphPos, R, DropDownWidth, BidiFlags);
  DrawButtonGlyph(Canvas, GlyphPos, State, Transparent);
  DrawButtonText(Canvas, Caption, R, State, BiDiFlags);

  // return a rectangle wherein the color indicator can be drawn
  if Caption = '' then
  begin
    Result := Client;
    Dec(Result.Right, DropDownWidth + 2);
    InflateRect(Result, -2, -2);

    // consider glyph if no text is to be painted (else it is already taken into account)
    if Assigned(FOriginal) and (FOriginal.Width > 0) and (FOriginal.Height > 0) then
      case Layout of
        blGlyphLeft:
          begin
            Result.Left := GlyphPos.X + FOriginal.Width + 4;
            Result.Top := GlyphPos.Y;
            Result.Bottom := GlyphPos.Y + FOriginal.Height;
          end;
        blGlyphRight:
          begin
            Result.Right := GlyphPos.X - 4;
            Result.Top := GlyphPos.Y;
            Result.Bottom := GlyphPos.Y + FOriginal.Height;
          end;
        blGlyphTop:
            Result.Top := GlyphPos.Y + FOriginal.Height + 4;
        blGlyphBottom:
            Result.Bottom := GlyphPos.Y - 4;
      end;
  end
  else
  begin
    // consider caption
    Result := Rect(R.Left, R.Bottom, R.Right, R.Bottom + 6);
    if (Result.Bottom + 2) > Client.Bottom then Result.Bottom := Client.Bottom - 2;
  end;
end;

//----------------- TColorPopup ------------------------------------------------

constructor TColorPopup.Create(AOwner: TComponent);

begin
  inherited;
  ControlStyle := ControlStyle + [csNoDesignVisible, csOpaque] - [csAcceptsControls];
  Visible:= False;
  FCanvas := TCanvas.Create;
  Color := clBtnFace;
  ShowHint := True;

  Initialise;
end;

//------------------------------------------------------------------------------

procedure TColorPopup.Initialise;
begin
  FBoxSize := 20;
  FMargin := GetSystemMetrics(SM_CXEDGE);
  FSpacing := 8;
  FHoverIndex := NoCell;
  FSelectedIndex := NoCell;

end;

//------------------------------------------------------------------------------

destructor TColorPopup.Destroy;

begin
  FCanvas.Free;
  inherited;
end;

//------------------------------------------------------------------------------

procedure TColorPopup.CNSysKeyDown(var Message: TWMKeyDown);

// handles accelerator keys

begin
  with Message do
  begin
    if (Length(FNoneColorText) > 0) and IsAccel(CharCode, FNoneColorText) then
    begin
      ChangeSelection(NoneColorCell);
      EndSelection(False);
      Result := 1;
    end
    else
      if (FSelectedIndex <> CustomCell) and
         (Length(FCustomText) > 0) and
         IsAccel(CharCode, FCustomText) then
      begin
        ChangeSelection(CustomCell);
        Result := 1;
      end
      else inherited;
    end;
end;

//------------------------------------------------------------------------------

procedure TColorPopup.CNKeyDown(var Message: TWMKeyDown);

// if an arrow key is pressed, then move the selection

var Row,
    MaxRow,
    Column: Integer;

begin
  inherited;

  if FHoverIndex <> NoCell then
  begin
    Row := GetRow(FHoverIndex);
    Column := GetColumn(FHoverIndex);
  end
  else
  begin
    Row := GetRow(FSelectedIndex);
    Column := GetColumn(FSelectedIndex);
  end;

  if FShowSysColors then MaxRow := DefaultColorCount + SysColorCount - 1
                    else MaxRow := DefaultColorCount - 1;

  case Message.CharCode of
    VK_DOWN:
      begin
        if Row = NoneColorCell then
        begin
          Row := 0;
          Column := 0;
        end
        else
          if Row = CustomCell then
          begin
            if Length(FNoneColorText) > 0 then
            begin
              Row := NoneColorCell;
              Column := Row;
            end
            else
            begin
              Row := 0;
              Column := 0;
            end;
          end
          else
          begin
            Inc(Row);
            if GetIndex(Row, Column) < 0 then
            begin
              if Length(FCustomText) > 0 then
              begin
                Row := CustomCell;
                Column := Row;
              end
              else
              begin
                if Length(FNoneColorText) > 0 then
                begin
                  Row := NoneColorCell;
                  Column := Row;
                end
                else
                begin
                  Row := 0;
                  Column := 0;
                end;
              end;
            end;
          end;
        ChangeHoverSelection(GetIndex(Row, Column));
        Message.Result := 1;
      end;

    VK_UP:
      begin
        if Row = NoneColorCell then
        begin
          if Length(FCustomText) > 0 then
          begin
            Row := CustomCell;
            Column := Row;
          end
          else
          begin
            Row := GetRow(MaxRow);
            Column := GetColumn(MaxRow);
          end
        end
        else
          if Row = CustomCell then
          begin
            Row := GetRow(MaxRow);
            Column := GetColumn(MaxRow);
          end
          else
            if Row > 0 then Dec(Row)
                       else
            begin
              if Length(FNoneColorText) > 0 then
              begin
                Row := NoneColorCell;
                Column := Row;
              end
              else
                if Length(FCustomText) > 0 then
                begin
                  Row := CustomCell;
                  Column := Row;
                end
                else
                begin
                  Row := GetRow(MaxRow);
                  Column := GetColumn(MaxRow);
                end;
            end;
        ChangeHoverSelection(GetIndex(Row, Column));
        Message.Result := 1;
      end;

    VK_RIGHT:
      begin
        if Row = NoneColorCell then
        begin
          Row := 0;
          Column := 0;
        end
        else
          if Row = CustomCell then
          begin
            if Length(FNoneColorText) > 0 then
            begin
              Row := NoneColorCell;
              Column := Row;
            end
            else
            begin
              Row := 0;
              Column := 0;
            end;
          end
          else
            if Column < FColumnCount - 1 then Inc(Column)
                                            else
            begin
              Column := 0;
              Inc(Row);
            end;

          if GetIndex(Row, Column) = NoCell then
          begin
            if Length(FCustomText) > 0 then
            begin
              Row := CustomCell;
              Column := Row;
            end
            else
              if Length(FNoneColorText) > 0 then
              begin
                Row := NoneColorCell;
                Column := Row;
              end
              else
              begin
                Row := 0;
                Column := 0;
              end;
          end;
        ChangeHoverSelection(GetIndex(row, Column));
        Message.Result := 1;
      end;

    VK_LEFT:
      begin
        if Row = NoneColorCell then
        begin
          if Length(FCustomText) > 0 then
          begin
            Row := CustomCell;
            Column := Row;
          end
          else
          begin
            Row := GetRow(MaxRow);
            Column := GetColumn(MaxRow);
          end;
        end
        else
          if Row = CustomCell then
          begin
            Row := GetRow(MaxRow);
            Column := GetColumn(MaxRow);
          end
          else
            if Column > 0 then Dec(Column)
                          else
            begin
              if Row > 0 then
              begin
                Dec(Row);
                Column := FColumnCount - 1;
              end
              else
              begin
                if Length(FNoneColorText) > 0 then
                begin
                  Row := NoneColorCell;
                  Column := Row;
                end
                else
                  if Length(FCustomText) > 0 then
                  begin
                    Row := CustomCell;
                    Column := Row;
                  end
                  else
                  begin
                    Row := GetRow(MaxRow);
                    Column := GetColumn(MaxRow);
                  end;
              end;
            end;
        ChangeHoverSelection(GetIndex(Row, Column));
        Message.Result := 1;
      end;

    VK_ESCAPE:
      begin
        EndSelection(True);
        Message.Result := 1;
      end;

    VK_RETURN,
    VK_SPACE:
      begin
        // this case can only occur if there was no click on the window
        // hence the hover index is the new color
        FSelectedIndex := FHoverIndex;
        EndSelection(False);
        Message.Result := 1;
      end;
  end;
end;

//------------------------------------------------------------------------------

procedure TColorPopup.DrawSeparator(Left, Top, Right: Integer);

var R: TRect;

begin
  R := Rect(Left, Top, Right, Top);
  DrawEdge(FCanvas.Handle, R, EDGE_ETCHED, BF_TOP);
end;

//------------------------------------------------------------------------------

procedure TColorPopup.DrawCell(Index: Integer);

var R, MarkRect: TRect;
    CellColor: TColor;

begin
  // for the custom text area
  if (Length(FCustomText) > 0) and (Index = CustomCell) then
  begin
    // the extent of the actual text button
    R := FCustomTextRect;

    // fill background
    FCanvas.Brush.Color := clBtnFace;
    FCanvas.FillRect(R);

    with FCustomTextRect do DrawSeparator(Left, Top - 2 * FMargin, Right);

    InflateRect(R, -1, 0);

    // fill background
    if (FSelectedIndex = Index) and (FHoverIndex <> Index) then FCanvas.Brush.Color := clBtnHighlight
                                                           else FCanvas.Brush.Color := clBtnFace;

    FCanvas.FillRect(R);
    // draw button
    if (FSelectedIndex = Index) or
       ((FHoverIndex = Index) and (csLButtonDown in ControlState)) then DrawEdge(FCanvas.Handle, R, BDR_SUNKENOUTER, BF_RECT)
                                                                   else
      if FHoverIndex = Index then DrawEdge(FCanvas.Handle, R, BDR_RAISEDINNER, BF_RECT);

    // draw custom text
    SetBkMode(FCanvas.Handle, TRANSPARENT);
    DrawText(FCanvas.Handle, PChar(FCustomText), Length(FCustomText), R, DT_CENTER or DT_VCENTER or DT_SINGLELINE);

    // draw preview color rectangle
    If FSelectedIndex= CustomCell then
    begin
      FCanvas.Pen.Color := clGray;
      FCanvas.Brush.Color := FCustomColor;
      with FCustomColorRect do
        FCanvas.Rectangle(Left, Top, Right, Bottom);
    end else
    begin
      FCanvas.Brush.Color := clBtnShadow;
      FCanvas.FrameRect(FCustomColorRect);
    end;
  end
  else
    // for the default text area
    if (Length(FNoneColorText) > 0) and (Index = NoneColorCell) then
    begin
      R := FNoneColorTextRect;

      // Fill background
      FCanvas.Brush.Color := clBtnFace;
      FCanvas.FillRect(R);

      InflateRect(R, -1, -1);

      // fill background
      if (FSelectedIndex = Index) and (FHoverIndex <> Index) then FCanvas.Brush.Color := clBtnHighlight
                                                             else FCanvas.Brush.Color := clBtnFace;

      FCanvas.FillRect(R);
      // draw button
      if (FSelectedIndex = Index) or
         ((FHoverIndex = Index) and (csLButtonDown in ControlState)) then
        DrawEdge(FCanvas.Handle, R, BDR_SUNKENOUTER, BF_RECT)
      else if FHoverIndex = Index then
        DrawEdge(FCanvas.Handle, R, BDR_RAISEDINNER, BF_RECT);

      // draw small rectangle
      with MarkRect do
      begin
        MarkRect := R;
        InflateRect(MarkRect, -FMargin - 1, -FMargin - 1);
        FCanvas.Brush.Color := clBtnShadow;
        FCanvas.FrameRect(MarkRect);
      end;

      // draw default text
      SetBkMode(FCanvas.Handle, TRANSPARENT);
      DrawText(FCanvas.Handle, PChar(FNoneColorText), Length(FNoneColorText), R, DT_CENTER or DT_VCENTER or DT_SINGLELINE);
    end
    else
    begin
      if GetCellRect(Index, R) then
      begin
        if Index < DefaultColorCount then CellColor := TColor(DefaultColors[Index].Color)
                                     else CellColor := TColor(SysColors[Index - DefaultColorCount].Color);
        FCanvas.Pen.Color := clGray;
        // fill background
        if (FSelectedIndex = Index) and (FHoverIndex <> Index) then FCanvas.Brush.Color := clBtnHighlight
                                                               else FCanvas.Brush.Color := clBtnFace;
        FCanvas.FillRect(R);

        // draw button
        if (FSelectedIndex = Index) or
           ((FHoverIndex = Index) and (csLButtonDown in ControlState)) then DrawEdge(FCanvas.Handle, R, BDR_SUNKENOUTER, BF_RECT)
                                                                       else
          if FHoverIndex = Index then DrawEdge(FCanvas.Handle, R, BDR_RAISEDINNER, BF_RECT);

        FCanvas.Brush.Color := CellColor;

        // draw the cell colour
        InflateRect(R, -(FMargin + 1), -(FMargin + 1));
        FCanvas.Rectangle(R.Left, R.Top, R.Right, R.Bottom);
      end;
    end;
end;

//------------------------------------------------------------------------------

procedure TColorPopup.WMPaint(var Message: TWMPaint);

var PS: TPaintStruct;
    I: Cardinal;
    R: TRect;
    SeparatorTop: Integer;

begin
  if Message.DC = 0 then FCanvas.Handle := BeginPaint(Handle, PS)
                    else FCanvas.Handle := Message.DC;
  try
    // use system default font for popup text
    FCanvas.Font.Handle := GetStockObject(DEFAULT_GUI_FONT);

    // default area text
    if Length(FNoneColorText) > 0 then DrawCell(NoneColorCell);

    // Draw colour cells
    for I := 0 to DefaultColorCount - 1 do DrawCell(I);

    if FShowSysColors then
    begin
      SeparatorTop := FRowCount * FBoxSize + FMargin;
      if Length(FNoneColorText) > 0 then Inc(SeparatorTop, FNoneColorTextRect.Bottom);
      with FCustomTextRect do DrawSeparator(FMargin + FSpacing, SeparatorTop, Width - FMargin - FSpacing);

      for I := 0 to SysColorCount - 1 do DrawCell(I + DefaultColorCount);
    end;

    // Draw custom text
    if Length(FCustomText) > 0 then DrawCell(CustomCell);

    // draw raised window edge (ex-window style WS_EX_WINDOWEDGE is supposed to do this,
    // but for some reason doesn't paint it)
    R := ClientRect;
    DrawEdge(FCanvas.Handle, R, EDGE_RAISED, BF_RECT);
  finally
    FCanvas.Font.Handle := 0; // a stock object never needs to be freed
    FCanvas.Handle := 0;
    if Message.DC = 0 then EndPaint(Handle, PS);
  end;
end;

//------------------------------------------------------------------------------

function TColorPopup.SelectionFromPoint(P: TPoint): Integer;

// determines the button at the given position

begin
  Result := NoCell;

  // first check we aren't in text box
  if (Length(FCustomText) > 0) and PtInRect(FCustomTextRect, P) then Result := CustomCell
                                                                else
    if (Length(FNoneColorText) > 0) and PtInRect(FNoneColorTextRect, P) then Result := NoneColorCell
                                                                    else
    begin
      // take into account text box
      if Length(FNoneColorText) > 0 then Dec(P.Y, FNoneColorTextRect.Bottom - FNoneColorTextRect.Top);

      // Get the row and column
      if P.X > FSpacing then
      begin
        Dec(P.X, FSpacing);
        // take the margin into account, 2 * FMargin is too small while 3 * FMargin
        // is correct, but looks a bit strange (the arrow corner is so small, it isn't
        // really recognized by the eye) hence I took 2.5 * FMargin
        Dec(P.Y, 5 * FMargin div 2);
        if (P.X >= 0) and (P.Y >= 0) then
        begin
          // consider system colors
          if FShowSysColors and ((P.Y div FBoxSize) >= FRowCount) then
          begin
            // here we know the point is out of the default color area, so
            // take the separator line between default and system colors into account
            Dec(P.Y, 3 * FMargin);
            // if we now are back in the default area then the point was originally
            // between both areas and we have therefore to reject a hit
            if (P.Y div FBoxSize) < FRowCount then Exit;
          end;
          Result := GetIndex(P.Y div FBoxSize, P.X div FBoxSize);
        end;
      end;
  end;
end;

//------------------------------------------------------------------------------

procedure TColorPopup.WMMouseMove(var Message: TWMMouseMove);

var NewSelection: Integer;

begin
  inherited;
  // determine new hover index
  NewSelection := SelectionFromPoint(Point(Message.XPos, Message.YPos));

  if NewSelection <> FHoverIndex then ChangeHoverSelection(NewSelection);
end;

//------------------------------------------------------------------------------

procedure TColorPopup.WMLButtonDown(var Message: TWMLButtonDown);
var
  AParent: TEzColorBox;
begin
  inherited;

  if PtInRect(ClientRect, Point(Message.XPos, Message.YPos)) then
  begin

    if FHoverIndex <> NoCell then
    begin
      InvalidateCell(FHoverIndex);
      UpdateWindow(Handle);
    end;

    if FHoverIndex = -3 then
    begin
      AParent:= TEzColorBox(Owner);
      AParent.SelectionColor:= clNone;
    end;

    if FHoverIndex = -2 then
    begin
      AParent:= TEzColorBox(Owner);
      AParent.DroppedDown:=False;
      with TColorDialog.Create(Nil) do
        try
          Options:= [cdFullOpen];
          Color:= AParent.SelectionColor;
          if Execute then
            AParent.SelectionColor:= Color;
        finally
          free;
        end;
    end;

    //if FHoverIndex = -1 then HandleCustomColors(Message);
  end
  else EndSelection(True); // hide popup window if the user has clicked elsewhere
end;

//------------------------------------------------------------------------------

procedure TColorPopup.ShowPopupAligned;

var Pt: TPoint;
    Parent: TEzColorBox;
    ParentTop: Integer;
    R: TRect;
    H: Integer;

begin
  HandleNeeded;
  // hide the custem color picking area
  R := Rect(FWindowRect.Left, FWindowRect.Bottom - 3, FWindowRect.Right, FWindowRect.Bottom);
  H := FWindowRect.Bottom;
  // to ensure the window frame is drawn correctly we invalidate the lower bound explicitely
  InvalidateRect(Handle, @R, True);

  // Make sure the window is still entirely visible and aligned.
  // There's no VCL parent window as this popup is a child of the desktop,
  // but we have the owner and get the parent from this.
  Parent := TEzColorBox(Owner);
  Pt := Parent.Parent.ClientToScreen(Point(Parent.Left - 1, Parent.Top + Parent.Height));
  if (Pt.y + H) > Screen.Height then Pt.y := Screen.Height - H;
  ParentTop := Parent.Parent.ClientToScreen(Point(Parent.Left, Parent.Top)).y;
  if Pt.y  <  ParentTop then Pt.y := ParentTop - H;
  if (Pt.x + Width) > Screen.Width then Pt.x := Screen.Width - Width;
  if Pt.x < 0 then Pt.x := 0;
  SetWindowPos(Handle, HWND_TOPMOST, Pt.X, Pt.Y, FWindowRect.Right, H, SWP_SHOWWINDOW);
end;

//------------------------------------------------------------------------------

procedure TColorPopup.ChangeSelection(NewSelection: Integer);

begin
  if NewSelection <> NoCell then
  begin
    if FSelectedIndex <> NoCell then InvalidateCell(FSelectedIndex);
    FSelectedIndex := NewSelection;
    if FSelectedIndex <> NoCell then InvalidateCell(FSelectedIndex);

    if FSelectedIndex = CustomCell then ShowPopupAligned;
  end;
end;

//------------------------------------------------------------------------------

procedure TColorPopup.WMLButtonUp(var Message: TWMLButtonUp);

var NewSelection: Integer;

begin
  inherited;
  // determine new selection index
  NewSelection := SelectionFromPoint(Point(Message.XPos, Message.YPos));
  if NewSelection <> NoCell then
  begin
    ChangeSelection(NewSelection);
    if (FSelectedIndex <> NoCell) and
       (FSelectedIndex <> CustomCell) then EndSelection(False)
                                      else SetCapture(TEzColorBox(Owner).FPopupWnd);
  end
  else
    // we need to restore the mouse capturing, else the utility window will loose it
    // (safety feature of Windows?)
    SetCapture(TEzColorBox(Owner).FPopupWnd);
end;

//------------------------------------------------------------------------------

function TColorPopup.GetIndex(Row, Col: Integer): Integer;

begin
  Result := NoCell;
  if ((Row = CustomCell) or (Col = CustomCell)) and
     (Length(FCustomText) > 0) then Result := CustomCell
                                else
    if ((Row = NoneColorCell) or (Col = NoneColorCell)) and
        (Length(FNoneColorText) > 0) then Result := NoneColorCell
                                   else
      if (Col in [0..FColumnCount - 1]) and (Row >= 0) then
      begin

        if Row < FRowCount then
        begin
          Result := Row * FColumnCount + Col;
          // consider not fully filled last row
          if Result >= DefaultColorCount then Result := NoCell;
        end
        else
          if FShowSysColors then
          begin
            Dec(Row, FRowCount);
            if Row < FSysRowCount then
            begin
              Result := Row * FColumnCount + Col;
              // consider not fully filled last row
              if Result >= SysColorCount then Result := NoCell
                                         else Inc(Result, DefaultColorCount);
            end;
          end;
      end;
end;

//------------------------------------------------------------------------------

function TColorPopup.GetRow(Index: Integer): Integer;

begin
  if (Index = CustomCell) and (Length(FCustomText) > 0) then Result := CustomCell
                                                        else
    if (Index = NoneColorCell) and (Length(FNoneColorText) > 0 ) then Result := NoneColorCell
                                                             else Result := Index div FColumnCount;
end;

//------------------------------------------------------------------------------

function TColorPopup.GetColumn(Index: Integer): Integer;

begin
  if (Index = CustomCell) and (Length(FCustomText) > 0) then Result := CustomCell
                                                        else
    if (Index = NoneColorCell) and (Length(FNoneColorText) > 0 ) then Result := NoneColorCell
                                                             else Result := Index mod FColumnCount;
end;

//------------------------------------------------------------------------------

procedure TColorPopup.SelectColor(Color: TColor);

// looks up the given color in our lists and sets the proper indices

var I: Integer;
    C: COLORREF;
    found: Boolean;

begin
  found := False;

  // handle special colors first
    if Color = clNone then FSelectedIndex := NoneColorCell
                         else
    begin
      // if the incoming color is one of the predefined colors (clBtnFace etc.) and
      // system colors are active then start looking in the system color list
      if FShowSysColors and (Color < 0) then
      begin
        for I := 0 to SysColorCount - 1 do
          if TColor(SysColors[I].Color) = Color then
          begin
            FSelectedIndex := I + DefaultColorCount;
            found := True;
            Break;
          end;
      end;

      if not found then
      begin
        C := ColorToRGB(Color);
        for I := 0 to DefaultColorCount - 1 do
          // only Borland knows why the result of ColorToRGB is Longint not COLORREF,
          // in order to make the compiler quiet I need a Longint cast here
          if ColorToRGB(DefaultColors[I].Color) = Longint(C) then
          begin
            FSelectedIndex := I;
            found := True;
            Break;
          end;

        // look in the system colors if not already done yet
        if not found and FShowSysColors and (Color >= 0) then
        begin
          for I := 0 to SysColorCount - 1 do
          begin
            if ColorToRGB(TColor(SysColors[I].Color)) = Longint(C) then
            begin
              FSelectedIndex := I + DefaultColorCount;
              found := True;
              Break;
            end;
          end;
        end;

        if not found then
        begin
          FSelectedIndex := CustomCell;
          FCustomColor:= Color;
        end;
      end;
    end;
end;

//------------------------------------------------------------------------------

function TColorPopup.GetCellRect(Index: Integer; var Rect: TRect): Boolean;

// gets the dimensions of the colour cell given by Index

begin
  Result := False;
  if Index = CustomCell then
  begin
    Rect := FCustomTextRect;
    Result := True;
  end
  else
    if Index = NoneColorCell then
    begin
      Rect := FNoneColorTextRect;
      Result := True;
    end
    else
      if Index >= 0 then
      begin
        Rect.Left := GetColumn(Index) * FBoxSize + FMargin + FSpacing;
        Rect.Top := GetRow(Index) * FBoxSize + 2 * FMargin;

        // move everything down if we are displaying a default text area
        if Length(FNoneColorText) > 0 then Inc(Rect.Top, FNoneColorTextRect.Bottom - 2 * FMargin);

        // move everything further down if we consider syscolors
        if Index >= DefaultColorCount then Inc(Rect.Top, 3 * FMargin);

        Rect.Right := Rect.Left + FBoxSize;
        Rect.Bottom := Rect.Top + FBoxSize;

        Result := True;
      end;
end;

//------------------------------------------------------------------------------

procedure TColorPopup.AdjustWindow;

// works out an appropriate size and position of this window

var TextSize,
    DefaultSize: TSize;
    DC: HDC;
    WHeight: Integer;

begin
  // If we are showing a custom or default text area, get the font and text size.
  if (Length(FCustomText) > 0) or (Length(FNoneColorText) > 0) then
  begin
    DC := GetDC(Handle);
    FCanvas.Handle := DC;
    FCanvas.Font.Handle := GetStockObject(DEFAULT_GUI_FONT);
    try
      // Get the size of the custom text (if there IS custom text)
      TextSize.cx := 0;
      TextSize.cy := 0;
      if Length(FCustomText) > 0 then TextSize := FCanvas.TextExtent(FCustomText);

      // Get the size of the default text (if there IS default text)
      if Length(FNoneColorText) > 0 then
      begin
        DefaultSize := FCanvas.TextExtent(FNoneColorText);
        if DefaultSize.cx > TextSize.cx then TextSize.cx := DefaultSize.cx;
        if DefaultSize.cy > TextSize.cy then TextSize.cy := DefaultSize.cy;
      end;

      Inc(TextSize.cx, 2 * FMargin);
      Inc(TextSize.cy, 4 * FMargin + 2);

    finally
      FCanvas.Font.Handle := 0;
      FCanvas.Handle := 0;
      ReleaseDC(Handle, DC);
    end;
  end;

  // Get the number of columns and rows
  FColumnCount := 8;
  FRowCount := DefaultColorCount div FColumnCount;
  if (DefaultColorCount mod FColumnCount) <> 0 then Inc(FRowCount);

  FWindowRect := Rect(0, 0,
                      FColumnCount * FBoxSize + 2 * FMargin + 2 * FSpacing,
                      FRowCount * FBoxSize + 4 * FMargin);

  // if default text, then expand window if necessary, and set text width as
  // window width
  if Length(FNoneColorText) > 0 then
  begin
    if TextSize.cx > (FWindowRect.Right - FWindowRect.Left) then FWindowRect.Right := FWindowRect.Left + TextSize.cx;
    TextSize.cx := FWindowRect.Right - FWindowRect.Left - 2 * FMargin;

    // work out the text area
    FNoneColorTextRect := Rect(FMargin + FSpacing, 2 * FMargin, FMargin -FSpacing + TextSize.cx, 2 * FMargin + TextSize.cy);
    Inc(FWindowRect.Bottom, FNoneColorTextRect.Bottom - FNoneColorTextRect.Top + 2 * FMargin);
  end;

  if FShowSysColors then
  begin
    FSysRowCount := SysColorCount div FColumnCount;
    if (SysColorCount mod FColumnCount) <> 0 then Inc(FSysRowCount);
    Inc(FWindowRect.Bottom, FSysRowCount * FBoxSize + 2 * FMargin);
  end;

  // if custom text, then expand window if necessary, and set text width as
  // window width
  if Length(FCustomText) > 0 then
  begin
    if TextSize.cx > (FWindowRect.Right - FWindowRect.Left) then FWindowRect.Right := FWindowRect.Left + TextSize.cx;
    TextSize.cx := FWindowRect.Right - FWindowRect.Left - 2 * FMargin;

    // work out the text area
    WHeight := FWindowRect.Bottom - FWindowRect.Top;
    FCustomTextRect := Rect(FMargin + FSpacing,
                            WHeight,
                            FMargin - FSpacing + TextSize.cx,
                            WHeight + TextSize.cy);
    // precalculate also the small preview box for custom color selection for fast updates
    FCustomColorRect := Rect(0, 0, FBoxSize, FBoxSize);
    InflateRect(FCustomColorRect, -(FMargin + 1), -(FMargin + 1));
    OffsetRect(FCustomColorRect,
               FCustomTextRect.Right - FBoxSize - FMargin,
               FCustomTextRect.Top + (FCustomTextRect.Bottom - FCustomTextRect.Top - FCustomColorRect.Bottom - FMargin - 1) div 2);

    Inc(FWindowRect.Bottom, FCustomTextRect.Bottom - FCustomTextRect.Top + 2 * FMargin);
  end;

  // set the window size
  with FWindowRect do SetBounds(Left, Top, Right - Left, Bottom - Top);
end;

//------------------------------------------------------------------------------

procedure TColorPopup.ChangeHoverSelection(Index: Integer);

begin
  if not FShowSysColors and (Index >= DefaultColorCount) or
     (Index >= (DefaultColorCount + SysColorCount)) then Index := NoCell;

  // remove old hover selection
  InvalidateCell(FHoverIndex);

  FHoverIndex := Index;
  InvalidateCell(FHoverIndex);
  UpdateWindow(Handle);
end;

//------------------------------------------------------------------------------

procedure TColorPopup.EndSelection(Cancel: Boolean);

begin
  with Owner as TEzColorBox do
  begin
    if not Cancel then
    begin
      if FSelectedIndex > -1 then
        if FSelectedIndex < DefaultColorCount then SelectionColor := TColor(DefaultColors[FSelectedIndex].Color)
                                              else SelectionColor := TColor(SysColors[FSelectedIndex - DefaultColorCount].Color)
                             else
        if FSelectedIndex = CustomCell then
        begin
          SelectionColor:= FCustomColor;
        end
        else DoNoneColorEvent;
    end;
    DroppedDown := False;
  end;
end;

//------------------------------------------------------------------------------

procedure TColorPopup.WMKillFocus(var Message: TWMKillFocus);

begin
  inherited;
  (Owner as TEzColorBox).DroppedDown := False;
end;

//-----------------------------------------------------------------------------

procedure TColorPopup.CreateParams(var Params: TCreateParams);

begin
  inherited CreateParams(Params);
  with Params do
  begin
    WndParent := GetDesktopWindow;
    Style := WS_CLIPSIBLINGS or WS_CHILD;
    ExStyle := WS_EX_TOPMOST or WS_EX_TOOLWINDOW;
    WindowClass.Style := CS_DBLCLKS or CS_SAVEBITS;
  end;
end;

//------------------------------------------------------------------------------

procedure TColorPopup.CreateWnd;

begin
  inherited;
  AdjustWindow;
end;

//------------------------------------------------------------------------------

procedure TColorPopup.SetSpacing(Value: Integer);

begin
  if Value < 0 then Value := 0;
  if FSpacing <> Value then
  begin
    FSpacing := Value;
    Invalidate;
  end;
end;

//------------------------------------------------------------------------------

procedure TColorPopup.InvalidateCell(Index: Integer);

var R: TRect;

begin
  if GetCellRect(Index, R) then InvalidateRect(Handle, @R, False);
end;

//------------------------------------------------------------------------------

function TColorPopup.GetHint(Cell: Integer): String;

begin
  Result := '';
  if Assigned(TEzColorBox(Owner).FOnHint) then TEzColorBox(Owner).FOnHint(Owner, Cell, Result);
end;

//------------------------------------------------------------------------------

procedure TColorPopup.CMHintShow(var Message: TMessage);

// determine hint message (tooltip) and out-of-hint rect
begin
  with TCMHintShow(Message) do
  begin
    if not TEzColorBox(Owner).ShowHint then Message.Result := 1
                                              else
    begin
      with HintInfo^ do
      begin
        // show that we want a hint
        Result := 0;
        // predefined colors always get their names as tooltip
        if FHoverIndex >= 0 then
        begin
          GetCellRect(FHoverIndex, CursorRect);
          if FHoverIndex < DefaultColorCount then HintStr := DefaultColors[FHoverIndex].Name
                                             else HintStr := SysColors[FHoverIndex - DefaultColorCount].Name;
        end
        else
          // both special cells get their hint either from the application by
          // means of the OnHint event or the hint string of the owner control
          if (FHoverIndex = NoneColorCell) or
             (FHoverIndex = CustomCell) then
          begin
            HintStr := GetHint(FHoverIndex);
            if HintStr = '' then HintStr := TEzColorBox(Owner).Hint
                            else
            begin
              // if the application supplied a hint by event then deflate the cursor rect
              // to the belonging button
              if FHoverIndex = NoneColorCell then CursorRect := FNoneColorTextRect
                                           else CursorRect := FCustomTextRect;
            end;
          end;
      end;
    end;
  end;
end;

//------------------------------------------------------------------------------

procedure TColorPopup.SetSelectedColor(const Value: TColor);

begin
  FCurrentColor := Value;
  SelectColor(Value);
end;

//----------------- TEzColorBox ------------------------------------------

constructor TEzColorBox.Create(AOwner: TComponent);

begin
  inherited Create(AOwner);
  FSelectionColor := clBlack;
  FColorPopup := TColorPopup.Create(Self);
  // park the window somewhere it can't be seen
  //FColorPopup.Visible := -1000;
  FPopupWnd := {$IFDEF LEVEL6}Classes.{$ENDIF}AllocateHWnd(PopupWndProc);

  FGlyph := TButtonGlyph.Create;
  TButtonGlyph(FGlyph).OnChange := GlyphChanged;
  SetBounds(0, 0, 45, 22);
  FDropDownWidth := 15;
  ControlStyle := [csCaptureMouse, csDoubleClicks];
  ParentFont := True;
  Color := clBtnFace;
  FSpacing := 4;
  FMargin := -1;
  FLayout := blGlyphLeft;
  FTransparent := True;
  FIndicatorBorder := ibFlat;
  TabStop:= True;

end;

//-----------------------------------------------------------------------------

destructor TEzColorBox.Destroy;

begin
  {$IFDEF LEVEL6}Classes.{$ENDIF}DeallocateHWnd(FPopupWnd);
  // the color popup window will automatically be freed since the button is the owner
  // of the popup
  TButtonGlyph(FGlyph).Free;
  inherited Destroy;
end;

procedure TEzColorBox.CMEnter(var Message: TCMGotFocus);
begin
  inherited;
  Paint;
end;

procedure TEzColorBox.CMExit(var Message: TCMExit);
begin
  inherited;
  Paint;
end;

//-----------------------------------------------------------------------------

procedure TEzColorBox.PopupWndProc(var Msg: TMessage);

var P: TPoint;

begin
  case Msg.Msg of
    WM_MOUSEFIRST..WM_MOUSELAST:
      begin
        with TWMMouse(Msg) do
        begin
          P := SmallPointToPoint(Pos);
          MapWindowPoints(FPopupWnd, FColorPopup.Handle, P, 1);
          Pos := PointToSmallPoint(P);
        end;
        FColorPopup.WindowProc(Msg);
      end;
    CN_KEYDOWN,
    CN_SYSKEYDOWN:
      FColorPopup.WindowProc(Msg);
  else
    with Msg do
      Result := DefWindowProc(FPopupWnd, Msg, wParam, lParam);
  end;
end;

//-----------------------------------------------------------------------------

procedure TEzColorBox.SetDropDownArrowColor(Value: TColor);

begin
  if not (FDropDownArrowColor = Value) then;
  begin
    FDropDownArrowColor := Value;
    Invalidate;
  end;
end;

//-----------------------------------------------------------------------------

procedure TEzColorBox.SetDropDownWidth(Value: integer);

begin
  if not (FDropDownWidth = Value) then;
  begin
    FDropDownWidth := Value;
    Invalidate;
  end;
end;

//-----------------------------------------------------------------------------

procedure TEzColorBox.Paint;

const MAX_WIDTH = 5;
      DownStyles: array[Boolean] of Integer = (BDR_RAISEDINNER, BDR_SUNKENOUTER);
      FillStyles: array[Boolean] of Integer = (BF_MIDDLE, 0);

var PaintRect: TRect;
    ExtraRect: TRect;
    DrawFlags: Integer;
    Offset: TPoint;
    LeftPos: Integer;

begin
  if not Enabled then
  begin
    FState := bsDisabled;
    FDragging := False;
  end
  else
    if (FState = bsDisabled) then
    begin
      if FDown and (GroupIndex <> 0) then FState := bsExclusive
                                     else FState := bsUp;
    end;

  Canvas.Font := Self.Font;

  // Creates a rectangle that represent the button and the drop down area,
  // determines also the position to draw the arrow...
  PaintRect := Rect(0, 0, Width, Height);
  ExtraRect := Rect(Width - FDropDownWidth, 0, Width, Height);
  LeftPos := (Width - FDropDownWidth) + ((FDropDownWidth + MAX_WIDTH) div 2) - MAX_WIDTH - 1;

  // Determines if the button is a flat or normal button... each uses
  // different painting methods
  if not FFlat then
  begin
    DrawFlags := DFCS_BUTTONPUSH or DFCS_ADJUSTRECT;

    if FState in [bsDown, bsExclusive] then DrawFlags := DrawFlags or DFCS_PUSHED;

    // Check if the mouse is in the drop down zone. If it is we then check
    // the state of the button to determine the drawing sequence
    if FDropDownZone then
    begin
      if FDroppedDown then
      begin
        // paint pressed Drop Down Button
        DrawFrameControl(Canvas.Handle, PaintRect, DFC_BUTTON, DRAW_BUTTON_UP);
        DrawFrameControl(Canvas.Handle, ExtraRect, DFC_BUTTON, DRAW_BUTTON_DOWN);
      end
      else
      begin
        // paint depressed Drop Down Button
        DrawFrameControl(Canvas.Handle, PaintRect, DFC_BUTTON, DRAW_BUTTON_UP);
        DrawFrameControl(Canvas.Handle, ExtraRect, DFC_BUTTON, DRAW_BUTTON_UP);
        DrawButtonSeperatorUp(Canvas);
      end;
    end
    else
    begin
      DrawFrameControl(Canvas.Handle, PaintRect, DFC_BUTTON, DrawFlags);

      // Determine the type of drop down seperator...
      if (FState in [bsDown, bsExclusive]) then DrawButtonSeperatorDown(Canvas)
                                           else DrawButtonSeperatorUp(Canvas);
    end;
  end
  else
  begin
    if (FState in [bsDown, bsExclusive]) or
       (FMouseInControl and (FState <> bsDisabled)) or
       (csDesigning in ComponentState) then
    begin
      // Check if the mouse is in the drop down zone. If it is we then check
      // the state of the button to determine the drawing sequence
      if FDropDownZone then
      begin
        if FDroppedDown then
        begin
          // Paint pressed Drop Down Button
          DrawEdge(Canvas.Handle, PaintRect, DownStyles[False], FillStyles[FTransparent] or BF_RECT);
          DrawEdge(Canvas.Handle, ExtraRect, DownStyles[True], FillStyles[FTransparent] or BF_RECT);
        end
        else
        begin
          // Paint depressed Drop Down Button
          DrawEdge(Canvas.Handle, PaintRect, DownStyles[False], FillStyles[FTransparent] or BF_RECT);
          DrawEdge(Canvas.Handle, ExtraRect, DownStyles[False], FillStyles[FTransparent] or BF_RECT);
          DrawButtonSeperatorUp(Canvas);
        end;
      end
      else
      begin
        DrawEdge(Canvas.Handle, PaintRect, DownStyles[FState in [bsDown, bsExclusive]], FillStyles[FTransparent] or BF_RECT);

        if (FState in [bsDown, bsExclusive]) then DrawButtonSeperatorDown(Canvas)
                                             else DrawButtonSeperatorUp(Canvas);
      end;
    end
    else
      if not FTransparent then
      begin
        Canvas.Brush.Style := bsSolid;
        Canvas.Brush.Color := Color;
        Canvas.FillRect(PaintRect);
      end;
    InflateRect(PaintRect, -1, -1);
  end;


  if (FState in [bsDown, bsExclusive]) and not (FDropDownZone) then
  begin
    if (FState = bsExclusive) and (not FFlat or not FMouseInControl) then
    begin
      Canvas.Brush.Bitmap := AllocPatternBitmap(clBtnFace, clBtnHighlight);
      Canvas.FillRect(PaintRect);
    end;
    Offset.X := 1;
    Offset.Y := 1;
  end
  else
  begin
    Offset.X := 0;
    Offset.Y := 0;
  end;

  PaintRect := TButtonGlyph(FGlyph).Draw(Canvas, PaintRect, Offset, Caption, FLayout, FMargin,
                                         FSpacing, FState, FTransparent, FDropDownWidth, DrawTextBiDiModeFlags(0));

  // draw color indicator
  If FSelectionColor =clNone then // the transparent color
  begin
    Canvas.Brush.Style := bsClear;
    Canvas.Pen.Color := clBtnShadow;
    If Length( Caption ) = 0 then
    begin
      DrawText( Canvas.Handle, PChar(NoneColorText), -1, PaintRect,
        DT_CENTER or DT_SINGLELINE or DT_VCENTER );
    end;
    with PaintRect do
      Canvas.Rectangle(Left, Top, Right, Bottom);
  end else
  begin
    Canvas.Brush.Style := bsSolid;
    Canvas.Brush.Color := FSelectionColor;
    Canvas.Pen.Color := clBtnShadow;
    case FIndicatorBorder of
      ibNone:
        Canvas.FillRect(PaintRect);
      ibFlat:
        with PaintRect do
          Canvas.Rectangle(Left, Top, Right, Bottom);
    else
      if FIndicatorBorder = ibSunken then DrawEdge(Canvas.Handle, PaintRect, BDR_SUNKENOUTER, BF_RECT)
                                     else DrawEdge(Canvas.Handle, PaintRect, BDR_RAISEDINNER, BF_RECT);
      InflateRect(PaintRect, -1, -1);
      Canvas.FillRect(PaintRect);
    end;
  end;

  // Draws the arrow for the correct state
  if FState = bsDisabled then
  begin
    Canvas.Pen.Style := psClear;
    Canvas.Brush.Color := clBtnShadow;
  end
  else
  begin
    Canvas.Pen.Color := FDropDownArrowColor;
    Canvas.Brush.Color := FDropDownArrowColor;
  end;

  if FDropDownZone and FDroppedDown or (FState = bsDown) and not (FDropDownZone) then
    DrawTriangle(Canvas, (Height div 2) + 1, LeftPos + 1, MAX_WIDTH)
  else
    DrawTriangle(Canvas, (Height div 2), LeftPos, MAX_WIDTH);

  If Focused then
  begin
    PaintRect := Rect( 0, 0, Width, Height );
    InflateRect( PaintRect, -1, -1 );
    DrawFocusRect( Canvas.Handle, PaintRect );
  end;

end;


//-----------------------------------------------------------------------------

procedure TEzColorBox.UpdateTracking;

var P: TPoint;

begin
  if FFlat then
  begin
    if Enabled then
    begin
      GetCursorPos(P);
      FMouseInControl := not (FindDragTarget(P, True) = Self);
      if FMouseInControl then Perform(CM_MOUSELEAVE, 0, 0)
                         else Perform(CM_MOUSEENTER, 0, 0);
    end;
  end;
end;

//-----------------------------------------------------------------------------

procedure TEzColorBox.Loaded;

var State: TButtonState;

begin
  inherited Loaded;
  if Enabled then State := bsUp
             else State := bsDisabled;
  TButtonGlyph(FGlyph).CreateButtonGlyph(State);
end;

//-----------------------------------------------------------------------------

procedure TEzColorBox.MouseDown(Button: TMouseButton; Shift: TShiftState; X, Y: Integer);

begin
  inherited MouseDown(Button, Shift, X, Y);

  if (Button = mbLeft) and Enabled then
  begin

    If Not (csDesigning in ComponentState) And not Focused then
    begin
      Windows.SetFocus( Self.Handle );
    end;

    // Determine if mouse is currently in the drop down section...
    //FDropDownZone := (X > Width - FDropDownWidth);
    FDropDownZone:= True;

    // If so display the button in the proper state and display the menu
    if FDropDownZone then
    begin
      if not FDroppedDown then
      begin
        Update;
        DroppedDown := True;
      end;

      // Setting this flag to false is very important, we want the dsUp state to
      // be used to display the button properly the next time the mouse moves in
      FDragging := False;
    end
    else
    begin
      if not FDown then
      begin
        FState := bsDown;
        Invalidate;
      end;

      FDragging := True;
    end;
  end;
end;

//-----------------------------------------------------------------------------

procedure TEzColorBox.MouseMove(Shift: TShiftState; X, Y: Integer);

var NewState: TButtonState;

begin
  inherited MouseMove(Shift, X, Y);
  if FDragging then
  begin
    if not FDown then NewState := bsUp
                 else NewState := bsExclusive;
    if (X >= 0) and (X < ClientWidth) and (Y >= 0) and (Y <= ClientHeight) then
      if FDown then NewState := bsExclusive
               else NewState := bsDown;
    if NewState <> FState then
    begin
      FState := NewState;
      Invalidate;
    end;
  end;
end;

//-----------------------------------------------------------------------------

procedure TEzColorBox.MouseUp(Button: TMouseButton; Shift: TShiftState; X, Y: Integer);

var DoClick: Boolean;

begin
  inherited MouseUp(Button, Shift, X, Y);
  if FDragging then
  begin
    FDragging := False;
    DoClick := (X >= 0) and (X < ClientWidth) and (Y >= 0) and (Y <= ClientHeight);
    if FGroupIndex = 0 then
    begin
      // Redraw face in case mouse is captured
      FState := bsUp;
      FMouseInControl := False;
      if DoClick and not (FState in [bsExclusive, bsDown]) then Invalidate;
    end
    else
      if DoClick then
      begin
        SetDown(not FDown);
        if FDown then Repaint;
      end
      else
      begin
        if FDown then FState := bsExclusive;
        Repaint;
      end;
    if DoClick then Click;
    UpdateTracking;
  end;
end;

//-----------------------------------------------------------------------------

procedure TEzColorBox.Click;

begin
  inherited Click;
end;

//-----------------------------------------------------------------------------

procedure TEzColorBox.DoNoneColorEvent;

begin
  if Assigned(FOnNoneColorSelect) then FOnNoneColorSelect(Self);
end;

//-----------------------------------------------------------------------------

function TEzColorBox.GetPalette: HPALETTE;

begin
  Result := Glyph.Palette;
end;

//-----------------------------------------------------------------------------

function TEzColorBox.GetGlyph: TBitmap;

begin
  Result := TButtonGlyph(FGlyph).Glyph;
end;

//-----------------------------------------------------------------------------

procedure TEzColorBox.SetGlyph(Value: TBitmap);

begin
  TButtonGlyph(FGlyph).Glyph := Value;
  Invalidate;
end;

//-----------------------------------------------------------------------------

function TEzColorBox.GetNumGlyphs: TNumGlyphs;

begin
  Result := TButtonGlyph(FGlyph).NumGlyphs;
end;

//-----------------------------------------------------------------------------

procedure TEzColorBox.DrawButtonSeperatorUp(Canvas: TCanvas);

begin
  with Canvas do
  begin
    Pen.Style := psSolid;
    Brush.Style := bsClear;
    Pen.Color := clBtnHighlight;
    Rectangle(Width - DropDownWidth, 1, Width - DropDownWidth + 1, Height - 1);
    Pen.Color := clBtnShadow;
    Rectangle(Width - DropDownWidth - 1, 1, Width - DropDownWidth, Height - 1);
  end;
end;

//-----------------------------------------------------------------------------

procedure TEzColorBox.DrawButtonSeperatorDown(Canvas: TCanvas);

begin
  with Canvas do
  begin
    Pen.Style := psSolid;
    Brush.Style := bsClear;
    Pen.Color := clBtnHighlight;
    Rectangle(Width - DropDownWidth + 1, 2, Width - DropDownWidth + 2, Height - 2);
    Pen.Color := clBtnShadow;
    Rectangle(Width - DropDownWidth, 2, Width - DropDownWidth + 1, Height - 2);
  end;
end;

//-----------------------------------------------------------------------------

procedure TEzColorBox.DrawTriangle(Canvas: TCanvas; Top, Left, Width: Integer);

begin
  if Odd(Width) then Inc(Width);
  Canvas.Polygon([Point(Left, Top),
                  Point(Left + Width, Top),
                  Point(Left + Width div 2, Top + Width div 2)]);
end;

//-----------------------------------------------------------------------------

procedure TEzColorBox.SetNumGlyphs(Value: TNumGlyphs);

begin
  if Value < 0 then Value := 1
               else
    if Value > 4 then Value := 4;

  if Value <> TButtonGlyph(FGlyph).NumGlyphs then
  begin
    TButtonGlyph(FGlyph).NumGlyphs := Value;
    Invalidate;
  end;
end;

//-----------------------------------------------------------------------------

procedure TEzColorBox.GlyphChanged(Sender: TObject);

begin
  Invalidate;
end;

//-----------------------------------------------------------------------------

procedure TEzColorBox.UpdateExclusive;

var Msg: TMessage;

begin
  if (FGroupIndex <> 0) and (Parent <> nil) then
  begin
    Msg.Msg := CM_BUTTONPRESSED;
    Msg.WParam := FGroupIndex;
    Msg.LParam := Longint(Self);
    Msg.Result := 0;
    Parent.Broadcast(Msg);
  end;
end;

//-----------------------------------------------------------------------------

procedure TEzColorBox.SetDown(Value: Boolean);

begin
  if FGroupIndex = 0 then Value := False;
  if Value <> FDown then
  begin
    if FDown and (not FAllowAllUp) then Exit;
    FDown := Value;
    if Value then
    begin
      if FState = bsUp then Invalidate;
      FState := bsExclusive;
    end
    else
    begin
      FState := bsUp;
      Repaint;
    end;
    if Value then UpdateExclusive;
  end;
end;

//-----------------------------------------------------------------------------

procedure TEzColorBox.SetFlat(Value: Boolean);

begin
  if Value <> FFlat then
  begin
    FFlat := Value;
    if Value then ControlStyle := ControlStyle - [csOpaque]
             else ControlStyle := ControlStyle + [csOpaque];
    Invalidate;
  end;
end;

//-----------------------------------------------------------------------------

procedure TEzColorBox.SetGroupIndex(Value: Integer);

begin
  if FGroupIndex <> Value then
  begin
    FGroupIndex := Value;
    UpdateExclusive;
  end;
end;

//-----------------------------------------------------------------------------

procedure TEzColorBox.SetLayout(Value: TButtonLayout);

begin
  if FLayout <> Value then
  begin
    FLayout := Value;
    Invalidate;
  end;
end;

//-----------------------------------------------------------------------------

procedure TEzColorBox.SetMargin(Value: Integer);

begin
  if (Value <> FMargin) and (Value >= -1) then
  begin
    FMargin := Value;
    Invalidate;
  end;
end;

//-----------------------------------------------------------------------------

procedure TEzColorBox.SetSpacing(Value: Integer);

begin
  if Value <> FSpacing then
  begin
    FSpacing := Value;
    Invalidate;
  end;
end;

//-----------------------------------------------------------------------------

procedure TEzColorBox.SetAllowAllUp(Value: Boolean);

begin
  if FAllowAllUp <> Value then
  begin
    FAllowAllUp := Value;
    UpdateExclusive;
  end;
end;

//-----------------------------------------------------------------------------

procedure TColorPopup.WMActivateApp(var Message: TWMActivateApp);

begin
  inherited;
  if not Message.Active then EndSelection(True);
end;

//-----------------------------------------------------------------------------

procedure TEzColorBox.WMLButtonDblClk(var Message: TWMLButtonDown);

begin
  inherited;
  if FDown then DblClick;
end;

//-----------------------------------------------------------------------------

procedure TEzColorBox.CMEnabledChanged(var Message: TMessage);

const NewState: array[Boolean] of TButtonState = (bsDisabled, bsUp);

begin
  TButtonGlyph(FGlyph).CreateButtonGlyph(NewState[Enabled]);
  UpdateTracking;
  Repaint;
end;

procedure TEzColorBox.CMButtonPressed(var Message: TMessage);
var
  Sender: TEzColorBox;
begin
  if Message.WParam = FGroupIndex then
  begin
    Sender := TEzColorBox(Message.LParam);
    if Sender <> Self then
    begin
      if Sender.Down and FDown then
      begin
        FDown := False;
        FState := bsUp;
        Invalidate;
      end;
      FAllowAllUp := Sender.AllowAllUp;
    end;
  end;
end;

procedure TEzColorBox.CMDialogChar(var Message: TCMDialogChar);
begin
  with Message do
    if IsAccel(CharCode, Caption) and
       Enabled and
       Visible and
      Assigned(Parent) and
      Parent.Showing then
    begin
      Click;
      Result := 1;
    end
    else inherited;
end;

procedure TEzColorBox.CMFontChanged(var Message: TMessage);
begin
  Invalidate;
end;

procedure TEzColorBox.CMTextChanged(var Message: TMessage);
begin
  Invalidate;
end;

procedure TEzColorBox.CMSysColorChange(var Message: TMessage);
begin
  with TButtonGlyph(FGlyph) do
  begin
    Invalidate;
    CreateButtonGlyph(FState);
  end;
end;

procedure TEzColorBox.CMMouseEnter(var Message: TMessage);
begin
  inherited;
  if FFlat and not FMouseInControl and Enabled then
  begin
    FMouseInControl := True;
    Repaint;
  end;
end;

procedure TEzColorBox.CMMouseLeave(var Message: TMessage);
begin
  inherited;
  if FFlat and FMouseInControl and Enabled and not FDragging then
  begin
    FMouseInControl := False;
    Invalidate;
  end;
end;

procedure TEzColorBox.SetDroppedDown(const Value: Boolean);
var
  Allowed: Boolean;
begin
  if FDroppedDown <> Value then
  begin
    Allowed:= True;
    if Assigned(FOnDropChanging) then FOnDropChanging(Self, Allowed);
    if Allowed then
    begin
      FDroppedDown := Value;
      if FDroppedDown then
      begin
        FState := bsDown;
        TColorPopup(FColorPopup).Visible:=True;
        TColorPopup(FColorPopup).SelectedColor := FSelectionColor;
        TColorPopup(FColorPopup).ShowPopupAligned;
        SetCapture(FPopupWnd);
      end
      else
      begin
        FState := bsUp;
        ReleaseCapture;
        ShowWindow(FColorPopup.Handle, SW_HIDE);
      end;
      if Assigned(FOnDropChanged) then FOnDropChanged(Self);
      Invalidate;
    end;
  end;
end;

procedure TEzColorBox.SetSelectionColor(const Value: TColor);
begin
  if FSelectionColor <> Value then
  begin
    FSelectionColor := Value;
    Invalidate;
    if FDroppedDown then TColorPopup(FColorPopup).SelectColor(Value);
    if Assigned(FOnChange) then FOnChange(Self);
  end;
end;

function TEzColorBox.GetCustomText: String;
begin
  Result := TColorPopup(FColorPopup).FCustomText;
end;

procedure TEzColorBox.SetCustomText(const Value: String);
begin
  with TColorPopup(FColorPopup) do
  begin
    if FCustomText <> Value then
    begin
      FCustomText := Value;
      if (FCustomText = '') and (FSelectedIndex = CustomCell) then FSelectedIndex := NoCell;
      AdjustWindow;
      if FDroppedDown then
      begin
        Invalidate;
        ShowPopupAligned;
      end;
    end;
  end;
end;

function TEzColorBox.GetNoneColorText: String;
begin
  Result := TColorPopup(FColorPopup).FNoneColorText;
end;

procedure TEzColorBox.SetNoneColorText(const Value: String);
begin
  if TColorPopup(FColorPopup).FNoneColorText <> Value then
  begin
    with TColorPopup(FColorPopup) do
    begin
      FNoneColorText := Value;
      AdjustWindow;
      if FDroppedDown then
      begin
        Invalidate;
        ShowPopupAligned;
      end;
    end;
  end;
end;

procedure TEzColorBox.SetShowSystemColors(const Value: Boolean);
begin
  with TColorPopup(FColorPopup) do
  begin
    if FShowSysColors <> Value then
    begin
      FShowSysColors := Value;
      AdjustWindow;
      if FDroppedDown then
      begin
        Invalidate;
        ShowPopupAligned;
      end;
    end;
  end;
end;

function TEzColorBox.GetShowSystemColors: Boolean;
begin
  Result := TColorPopup(FColorPopup).FShowSysColors;
end;

procedure TEzColorBox.SetTransparent(const Value: Boolean);
begin
  if Value <> FTransparent then
  begin
    FTransparent := Value;
    if Value then ControlStyle := ControlStyle - [csOpaque]
             else ControlStyle := ControlStyle + [csOpaque];
    Invalidate;
  end;
end;

procedure TEzColorBox.SetIndicatorBorder(const Value: TIndicatorBorder);
begin
  if FIndicatorBorder <> Value then
  begin
    FIndicatorBorder := Value;
    Invalidate;
  end;
end;

function TEzColorBox.GetPopupSpacing: Integer;
begin
  Result := TColorPopup(FColorPopup).Spacing;
end;

procedure TEzColorBox.SetPopupSpacing(const Value: Integer);
begin
  TColorPopup(FColorPopup).Spacing := Value;
end;

end.

