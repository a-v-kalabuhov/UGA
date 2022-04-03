unit EzMiscelCtrls;

{$I EZ_FLAG.PAS}
interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ExtCtrls, Grids, Menus, buttons, ezbasegis, ezlib,
  EzEntities, EzBase
{$IFDEF LEVEL6}
  , Variants
{$ENDIF}
  ;

const
  DefEditBtnWidth = 21;

type

  TEzFlatComboBox=class(TCustomComboBox)
  protected
    MouseInControl: Boolean;
    procedure RedrawBorder (const Clip: HRGN);
    procedure NewAdjustHeight;
    procedure CMEnabledChanged (var Message: TMessage); message CM_ENABLEDCHANGED;
    procedure CMFontChanged (var Message: TMessage); message CM_FONTCHANGED;
    procedure CMMouseEnter (var Message: TMessage); message CM_MOUSEENTER;
    procedure CMMouseLeave (var Message: TMessage); message CM_MOUSELEAVE;
    procedure WMSetFocus (var Message: TWMSetFocus); message WM_SETFOCUS;
    procedure WMKillFocus (var Message: TWMKillFocus); message WM_KILLFOCUS;
    procedure WMNCPaint (var Message: TMessage); message WM_NCPAINT;
    procedure WMPaint(var Message: TMessage); message WM_PAINT;
    procedure CMExit(var Message: TCMExit); message CM_EXIT;
  protected
    procedure Loaded; override;
    procedure DblClick; override;
  public
    constructor Create (AOwner: TComponent); override;
  published

    property Style; {Must be published before Items}
    property Anchors;
    property BiDiMode;
    property Color;
    property Constraints;
    property Ctl3D;
    property DragCursor;
    property DragKind;
    property DragMode;
    property DropDownCount;
    property Enabled;
    property Font;
    property ImeMode;
    property ImeName;
    property ItemHeight;
    property MaxLength;
    property ParentBiDiMode;
    property ParentColor;
    property ParentCtl3D;
    property ParentFont;
    property ParentShowHint;
    property PopupMenu;
    property ShowHint;
    property Sorted;
    property TabOrder;
    property TabStop;
    property Text;
    property Visible;
    property OnChange;
    property OnClick;
{$IFDEF LEVEL5}
    property OnContextPopup;
{$ENDIF}
    property OnDblClick;
    property OnDragDrop;
    property OnDragOver;
    property OnDrawItem;
    property OnDropDown;
    property OnEndDock;
    property OnEndDrag;
    property OnEnter;
    property OnExit;
    property OnKeyDown;
    property OnKeyPress;
    property OnKeyUp;
    property OnMeasureItem;
    property OnStartDock;
    property OnStartDrag;
    property Items; { Must be published after OnMeasureItem }
    property ItemIndex;
  end;

  TEzCheckBitmap = ( obVisible,
                     obInvisible,
                     obSelectable,
                     obUnSelectable,
                     obCurrent,
                     obNocurrent );

  TEzCheckBitmapArray = array[TEzCheckBitmap] of TBitmap;

  { TEzLayerGridBox }

  TEzLayerGridBox = class(TEzFlatComboBox)
  Private
    FGIS: TEzBaseGis;
    FFullPath: Boolean;
    FPictures: TEzCheckBitmapArray;
    FCurrentTextColor: TColor;
    FLockedTextColor: TColor;
    procedure SetGis(const Value: TEzBaseGis);
    procedure SetFullPath(const Value: Boolean);
{$IFDEF BCB} (*_*)
    function GetCurrentTextColor: TColor;
    function GetFullPath: Boolean;
    function GetGis: TEzBaseGis;
    function GetLockedTextColor: TColor;
    procedure SetCurrentTextColor(const Value: TColor);
    procedure SetLockedTextColor(const Value: TColor);
{$ENDIF}
  Protected
    Procedure Notification( AComponent: TComponent; Operation: TOperation ); Override;
    procedure DrawItem(Index: Integer; Rect: TRect; State: TOwnerDrawState); override;
    procedure Change; override;
  Public
    Constructor Create(AOwner: TComponent); Override;
    destructor Destroy; Override;

  Published
    property GIS: TEzBaseGis read {$IFDEF BCB} GetGis {$ELSE} FGIS {$ENDIF} write SetGis; (*_*)
    Property FullPath: Boolean read {$IFDEF BCB} GetFullPath  {$ELSE} FFullPath {$ENDIF} write SetFullPath; (*_*)
    Property CurrentTextColor: TColor read {$IFDEF BCB} GetCurrentTextColor {$ELSE} FCurrentTextColor {$ENDIF}
      write {$IFDEF BCB} SetCurrentTextColor {$ELSE} FCurrentTextColor {$ENDIF} default clBlack; (*_*)
    Property LockedTextColor: TColor read {$IFDEF BCB} GetLockedTextColor {$ELSE} FLockedTextColor {$ENDIF}
      write {$IFDEF BCB} SetLockedTextColor {$ELSE} FLockedTextColor {$ENDIF} default clRed; (*_*)

  End;


  TEzFocusChangeEvent = procedure(const ASender: TObject;
    const AFocusControl: TWinControl) of object;

  TEzCustomDropDownForm = class(TCustomForm)
  private
    FEntering: Boolean;
    FCloseOnLeave: Boolean;
    FLeaving: Boolean;
    FPanel: TPanel;

    FOnLoseFocus: TEzFocusChangeEvent;
    FOnGetFocus: TEzFocusChangeEvent;

    procedure WMKillFocus(var AMessage: TMessage); message WM_KILLFOCUS;
    procedure WMSetFocus(var AMessage: TMessage); message WM_SETFOCUS;
  protected
    function GetEdit: TCustomControl;

    function Entering: Boolean;
    function Leaving: Boolean;

    procedure GetFocus(const APreviousControl: TWinControl);dynamic;
    procedure LoseFocus(const AFocusControl: TWinControl); dynamic;

    procedure DoClose(var AAction: TCloseAction); override;
    procedure DoShow; override;
    procedure CreateParams(var AParams: TCreateParams); override;

    property Edit: TCustomControl read GetEdit;
  public
    constructor Create(AOwner: TComponent); override;

    property CloseOnLeave: Boolean read FCloseOnLeave write FCloseOnLeave;

    property OnGetFocus: TEzFocusChangeEvent read FOnGetFocus write FOnGetFocus;
    property OnLoseFocus: TEzFocusChangeEvent read FOnLoseFocus write FOnLoseFocus;
  end;

  { TEzCustomListBox }
  TEzCustomListBox = Class( TCustomListBox )
  private
    FShowIndex: Boolean;
    FEdged: Boolean;
    FShowHexa: Boolean;
    FGrapher: TEzGrapher;
    FAreaColor: TColor;
    procedure SetShowIndex(Value: Boolean);
  protected
    procedure Populate; dynamic; abstract;
    procedure Loaded; override;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
  published
    Property ShowIndex: Boolean read FShowIndex write SetShowIndex default True;
    Property Edged: Boolean read FEdged write FEdged default True;
    Property ShowHexa: Boolean read FShowHexa write FShowHexa default False;
    Property AreaColor: TColor read FAreaColor write FAreaColor default clWindow;

    property Columns;
    property ExtendedSelect;
    property Align;
    property Anchors;
    property BevelEdges;
    property BevelInner;
    property BevelKind default bkNone;
    property BevelOuter;
    property BiDiMode;
    property BorderStyle;
    property Color;
    property Constraints;
    property Ctl3D;
    property DragCursor;
    property DragKind;
    property DragMode;
    property Enabled;
    property Font;
    property ImeMode;
    property ImeName;
    property IntegralHeight;
    property ItemHeight;
    property MultiSelect;
    property ParentBiDiMode;
    property ParentColor;
    property ParentCtl3D;
    property ParentFont;
    property ParentShowHint;
    property PopupMenu;
{$IFDEF LEVEL6}
    property ScrollWidth;
{$ENDIF}
    property ShowHint;
    property TabOrder;
    property TabStop;
    property Visible;
    property OnClick;
{$IFDEF LEVEL5}
    property OnContextPopup;
{$ENDIF}
    property OnDblClick;
    property OnDragDrop;
    property OnDragOver;
    property OnEndDock;
    property OnEndDrag;
    property OnEnter;
    property OnExit;
    property OnKeyDown;
    property OnKeyPress;
    property OnKeyUp;
    property OnMouseDown;
    property OnMouseMove;
    property OnMouseUp;
    property OnStartDock;
    property OnStartDrag;
  end;

  { A drop down form with an embedded TCustomListBox }
  TEzDropDownList = class(TEzCustomDropDownForm)
  private
    FList: TEzCustomListBox;

    FOnClick: TNotifyEvent;
    FOnCancel: TNotifyEvent;
    procedure SLClick(Sender: TObject);
    procedure SLKeyPress(Sender: TObject; var Key: Char);
    procedure SLLoseFocus(const ASender: TObject; const AFocusControl: TWinControl);
    function GetItemIndex: Integer;
    procedure SetItemIndex(Value: Integer);
    function GetColumns: Integer;
    procedure SetColumns(const Value: Integer);
  protected
    procedure DoCancel;
    procedure DoClick;
    procedure Loaded; override;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    Function CreateListBox: TEzCustomListBox; Dynamic; Abstract;

    procedure SetFocus; override;

    property ItemIndex: Integer read GetItemIndex write SetItemIndex;
    property Columns: Integer read GetColumns write SetColumns;

    property OnCancel: TNotifyEvent read FOnCancel write FOnCancel;
    property OnClick: TNotifyEvent read FOnClick write FOnClick;
  end;

  TEzCustomGridBox = class(TCustomControl)
  private
    FButton: TSpeedButton;
    FDropForm: TEzDropDownList;
    FDropDownCols: Integer;
    FItemIndex: Integer;
    FItemHeight: Integer;
    FEntering: Boolean;
    FLeaving: Boolean;
    FBorderStyle: TBorderStyle;
    FShowIndex: Boolean;
    FEditAreaShowIndex: Boolean;
    FShowHexa: Boolean;
    FEdged: Boolean;
    FDropDownWidth: Integer;
    FDropDownHeight: Integer;
    FAutoSize: Boolean;
    FAreaColor: TColor;

    FOnGetFocus: TEzFocusChangeEvent;
    FOnLoseFocus: TEzFocusChangeEvent;
    FOnChange: TNotifyEvent;
    procedure ButtonClick(Sender: TObject);
    procedure SLClick(Sender: TObject);
    procedure SLDestroy(Sender: TObject);
    procedure CloseUp;
    procedure SetItemIndex(Value: Integer);
    function GetDroppedDown: Boolean;
    procedure CMCtl3DChanged(var AMessage: TMessage); message CM_CTL3DCHANGED;
    procedure CMEnabledChanged(var AMessage: TMessage); message CM_ENABLEDCHANGED;
    procedure WMKillFocus(var AMessage: TMessage); message WM_KILLFOCUS;
    procedure WMSetFocus(var AMessage: TMessage); message WM_SETFOCUS;
    procedure CMColorChanged(var AMessage: TMessage); message CM_COLORCHANGED;
    procedure CMParentColorChanged(var AMessage: TMessage); message CM_PARENTCOLORCHANGED;
    procedure LoseFocus(const AFocusControl: TWinControl);
    procedure GetFocus(const APreviousControl: TWinControl);
    procedure SetBorderStyle(const Value: TBorderStyle);
  protected
    procedure CreateParams(var Params: TCreateParams); override;
    procedure DropDown;
    procedure Paint; override;
    procedure KeyDown(var AKey: Word; AShift: TShiftState); override;
    procedure MouseDown(Button: TMouseButton; Shift: TShiftState; X, Y: Integer); override;
    procedure Resize; override;

    Function CreateDropDownList: TEzDropDownList; dynamic; abstract;
    Procedure PaintClientArea( Grapher: TEzGrapher; Canvas: TCanvas; Index: Integer;
      Rect: TRect; State: TOwnerDrawState; FillColor: TColor;
      ShowIndex, ShowHexa: Boolean; Clear: Boolean; Edged: Boolean ); dynamic; abstract;

  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;

    function Entering: Boolean;
    function Leaving: Boolean;
    procedure Change;

    property ItemIndex: Integer read FItemIndex write SetItemIndex;
    property DroppedDown: Boolean read GetDroppedDown;

    property OnGetFocus: TEzFocusChangeEvent read FOnGetFocus write FOnGetFocus;
    property OnLoseFocus: TEzFocusChangeEvent read FOnLoseFocus write FOnLoseFocus;
  published
    Property ShowIndex: Boolean read FShowIndex write FShowIndex Default True;
    Property EditAreaShowIndex: Boolean read FEditAreaShowIndex write FEditAreaShowIndex Default True;
    Property Edged: Boolean read FEdged write FEdged default True;
    Property ShowHexa: Boolean read FShowHexa write FShowHexa default False;
    Property ItemHeight: Integer read FItemHeight write FItemHeight default 24;
    Property DropDownCols: Integer read FDropDownCols write FDropDownCols default 3;
    Property BorderStyle: TBorderStyle read FBorderStyle write SetBorderStyle default bsSingle;
    Property DropDownWidth: Integer read FDropDownWidth write FDropDownWidth default 320;
    Property DropDownHeight: Integer read FDropDownHeight write FDropDownHeight default 240;
    Property AutoSize: Boolean read FAutoSize write FAutoSize default False;
    Property AreaColor: TColor read FAreaColor write FAreaColor default clWindow;

    property OnChange: TNotifyEvent read FOnChange write FOnChange;

    property Color;
    property TabOrder;
    property TabStop;
    property Ctl3D;
    property ImeMode;
    property ImeName;
    property ParentCtl3D;
    property ParentColor;
    property UseDockManager;

    property OnClick;
    property OnDockDrop;
    property OnDockOver;
    property OnEnter;
    property OnExit;
    property OnKeyDown;
    property OnKeyPress;
    property OnKeyUp;
    property OnUnDock;
  end;

  { TEzSymbolsListBox }

  TEzSymbolsListBox = Class( TEzCustomListBox )
  protected
    procedure DrawItem(Index: Integer; Rect: TRect;
      State: TOwnerDrawState); override;
  Public
    procedure Populate; override;
  End;

  { TEzSymbolsGridBox }

  TEzSymbolsGridBox = class(TEzCustomGridBox)
  protected
    Function CreateDropDownList: TEzDropDownList; override;
    Procedure PaintClientArea( Grapher: TEzGrapher; Canvas: TCanvas; Index: Integer;
      Rect: TRect; State: TOwnerDrawState; FillColor: TColor;
      ShowIndex, ShowHexa: Boolean; Clear: Boolean; Edged: Boolean ); override;
  end;

  { TEzLinetypeListBox }

  TEzLinetypeListBox = Class( TEzCustomListBox )
  Private
    FScale: Double;
    FRepit: Integer;
    FShowFirstDefaultLineTypes: Integer;
    function GetRepit: Integer;
    function GetScale: Double;
    procedure SetRepit(const Value: Integer);
    procedure SetScale(const Value: Double);
    procedure SetShowFirstDefaultLineTypes(const Value: Integer);
  protected
    procedure DrawItem(Index: Integer; Rect: TRect;
      State: TOwnerDrawState); override;
  Public
    constructor Create(AOwner: TComponent); Override;
    procedure Populate; override;
  Published
    Property Repit: Integer read GetRepit write SetRepit;
    Property Scale: Double read GetScale write SetScale;
    Property ShowFirstDefaultLineTypes: Integer read FShowFirstDefaultLineTypes write SetShowFirstDefaultLineTypes;
  End;

  { TEzLineTypeGridBox }
  TEzLineTypeGridBox = Class( TEzCustomGridBox )
  private
    FScale: Double;
    FRepit: Integer;
    function GetRepit: Integer;
    function GetScale: Double;
    procedure SetRepit(const Value: Integer);
    procedure SetScale(const Value: Double);
  protected
    Function CreateDropDownList: TEzDropDownList; override;
    Procedure PaintClientArea( Grapher: TEzGrapher; Canvas: TCanvas; Index: Integer;
      Rect: TRect; State: TOwnerDrawState; FillColor: TColor;
      ShowIndex, ShowHexa: Boolean; Clear: Boolean; Edged: Boolean ); override;
  Published
    Property Scale: Double read GetScale write SetScale;
    Property Repit: Integer read GetRepit write SetRepit;
  end;

  { TEzBrushPatternGridBox }

  TEzBrushPatternGridBox = Class( TEzCustomGridBox )
  protected
    Function CreateDropDownList: TEzDropDownList; override;
    Procedure PaintClientArea( Grapher: TEzGrapher; Canvas: TCanvas; Index: Integer;
      Rect: TRect; State: TOwnerDrawState; FillColor: TColor;
      ShowIndex, ShowHexa: Boolean; Clear: Boolean; Edged: Boolean ); override;
  end;

  { TEzBrushPatternListBox }

  TEzBrushPatternListBox = Class( TEzCustomListBox )
  Private
    FForeColor: TColor;
    FBackColor: TColor;
    function GetBackColor: TColor;
    function GetForeColor: TColor;
    procedure SetBackColor(const Value: TColor);
    procedure SetForeColor(const Value: TColor);
  protected
    procedure DrawItem(Index: Integer; Rect: TRect;
      State: TOwnerDrawState); override;
  Public
    constructor Create(AOwner: TComponent); Override;
    procedure Populate; override;
  Published
    Property ForeColor: TColor read GetForeColor write SetForeColor default clBlack;
    Property BackColor: TColor read GetBackColor write SetBackColor default clWhite;
  End;

  { TEzBlocksGridBox }

  TEzBlocksGridBox = Class( TEzCustomGridBox )
  private
    FBlockList: TStrings;
  protected
    Function CreateDropDownList: TEzDropDownList; override;
    Procedure PaintClientArea( Grapher: TEzGrapher; Canvas: TCanvas; Index: Integer;
      Rect: TRect; State: TOwnerDrawState; FillColor: TColor;
      ShowIndex, ShowHexa: Boolean; Clear: Boolean; Edged: Boolean ); override;
  public
    Constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure Populate;

    property BlockList: TStrings read FBlockList;
  end;

  { TEzBlocksListBox }

  TEzBlocksListBox = Class( TEzCustomListBox )
  protected
    procedure DrawItem(Index: Integer; Rect: TRect;
      State: TOwnerDrawState); override;
  Public
    procedure Populate; override;
  End;

  TEzColumnData = (cdLayerName, cdLayerFullPath, cdCurrent, cdVisible,
    cdSelectable, cdMaxScale, cdMinScale );

  TEzLayerListBox = class;
  TEzLayerBoxColumn = class;

  { TEzLayerColumnTitle }
  TEzLayerColumnTitle = Class(TPersistent)
  Private
    FColumn: TEzLayerBoxColumn;
    FCaption: string;
    FFont: TFont;
    FColor: TColor;
    FAlignment: TAlignment;
    procedure SetAlignment(const Value: TAlignment);
    procedure SetCaption(const Value: string);
    procedure SetColor(const Value: TColor);
    procedure SetFont(const Value: TFont);
  public
    constructor Create(Column: TEzLayerBoxColumn);
    destructor Destroy; override;
  published
    property Alignment: TAlignment read FAlignment write SetAlignment default taCenter;
    property Caption: string read FCaption write SetCaption;
    property Color: TColor read FColor write SetColor default clWindow;
    property Font: TFont read FFont write SetFont;
  end;

  { TEzLayerBoxColumn }

  TEzLayerBoxColumn = Class( TCollectionItem )
  Private
    FColumnData: TEzColumnData;
    FWidth: Integer;
    FAlignment: TAlignment;
    FColor: TColor;
    FReadOnly: Boolean;
    FFont: TFont;
    FTitle: TEzLayerColumnTitle;
    FBitmapEnabled: TBitmap;
    FBitmapDisabled: TBitmap;
    procedure SetBitmapEnabled(const Value: TBitmap);
    procedure SetBitmapDisabled(const Value: TBitmap);
    procedure SetColor(const Value: TColor);
    procedure SetFont(const Value: TFont);
    procedure SetReadOnly(const Value: Boolean);
    procedure SetTitle(const Value: TEzLayerColumnTitle);
    procedure SetColumnData(const Value: TEzColumnData);
    procedure RefreshLayout;
    procedure ChangeLayout;
    function GetListBox: TEzLayerListBox;
    procedure SetAlignment(const Value: TAlignment);
    procedure SetWidth(const Value: Integer);
  Protected
    Function GetDisplayName: String; Override;
  Public
    constructor Create(Collection: TCollection); override;
    destructor Destroy; Override;
    Procedure Assign( Source: TPersistent ); Override;
  Published
    Property ColumnData: TEzColumnData read FColumnData write SetColumnData;
    Property Alignment: TAlignment read FAlignment write SetAlignment;
    Property Color: TColor Read FColor Write SetColor;
    Property ReadOnly: Boolean read FReadOnly write SetReadOnly;
    Property Font: TFont read FFont write SetFont;
    Property Title: TEzLayerColumnTitle read FTitle write SetTitle;
    Property BitmapEnabled: TBitmap read FBitmapEnabled write SetBitmapEnabled;
    Property BitmapDisabled: TBitmap read FBitmapDisabled write SetBitmapDisabled;
    Property Width: Integer read FWidth write SetWidth default 48;
  End;

  TEzColumnClass = class of TEzLayerBoxColumn;

  { TEzLayerBoxColumns}
  TEzLayerBoxColumns = Class( TOwnedCollection )
  Private
    FListBox: TEzLayerListBox;
    Function GetColumn( Index: Integer ): TEzLayerBoxColumn;
    Procedure SetColumn( Index: Integer; Value: TEzLayerBoxColumn );
  Protected
    function GetOwner: TPersistent; override;
    procedure Update(Item: TCollectionItem); Override;
  Public
    constructor Create(ListBox: TEzLayerListBox; ColumnClass: TEzColumnClass);
    Function Add: TEzLayerBoxColumn;

    Property Items[Index: Integer]: TEzLayerBoxColumn Read GetColumn Write SetColumn; Default;
  End;

  { TEzLayerListBox }

  TEzLayerListBox = class(TDrawGrid)
  private
    FGIS: TEzBaseGis;
    FColumns: TEzLayerBoxColumns;
    FInLayout: Boolean;
    FCurrentTextColor: TColor;
    FLockedTextColor: TColor;
    procedure SetGis(Value: TEzBaseGis);
    procedure SetColumns(const Value: TEzLayerBoxColumns);
    procedure SetCurrentTextColor(const Value: TColor);
    procedure SetLockedTextColor(const Value: TColor);
  protected
    Procedure Notification( AComponent: TComponent; Operation: TOperation ); Override;
    procedure DrawCell(ACol, ARow: Longint; ARect: TRect;
      AState: TGridDrawState); override;
    procedure MouseDown(Button: TMouseButton; Shift: TShiftState;
      X, Y: Integer); override;
    procedure Loaded; Override;
  public
    constructor Create(AOwner: TComponent); Override;
    destructor Destroy; Override;
    procedure BeginLayout;
    procedure EndLayout;
    procedure LayoutChanged;
    Function Selected: string;
    function SelectedLayer: TEzBaseLayer;
  published
    property GIS: TEzBaseGis read FGIS write SetGis;
    property Columns: TEzLayerBoxColumns read FColumns write SetColumns;
    Property CurrentTextColor: TColor read FCurrentTextColor write SetCurrentTextColor default clBlack;
    Property LockedTextColor: TColor read FLockedTextColor write SetLockedTextColor default clRed;

    property Align;
    property Anchors;
    property BiDiMode;
    property BorderStyle;
    property Color;
    property Constraints;
    property Ctl3D;
    property DragCursor;
    property DragKind;
    property DragMode;
    property Enabled;
    property Font;
    property ImeMode;
    property ImeName;
    property ParentBiDiMode;
    property ParentColor;
    property ParentCtl3D;
    property ParentFont;
    property ParentShowHint;
    property PopupMenu;
    property ShowHint;
    property TabOrder;
    property TabStop;
    property Visible;
    property OnClick;
{$IFDEF LEVEL5}
    property OnContextPopup;
{$ENDIF}
    property OnDblClick;
    property OnDragDrop;
    property OnDragOver;
    property OnEndDock;
    property OnEndDrag;
    property OnEnter;
    property OnExit;
    property OnKeyDown;
    property OnKeyPress;
    property OnKeyUp;
    property OnMouseDown;
    property OnMouseMove;
    property OnMouseUp;
    property OnStartDock;
    property OnStartDrag;
  end;

  Procedure DrawPattern( Canvas: TCanvas; Index: Integer;
    ForeColor, BackColor, FillColor: TColor; Rect: TRect;
    ShowIndex: Boolean ; State: TOwnerDrawState; ShowHexa: Boolean;
    Clear: Boolean = true; Edged: Boolean = False);

  Procedure DrawSymbol( Grapher: TEzGrapher; Canvas: TCanvas; Index: Integer;
    Rect: TRect; State: TOwnerDrawState; FillColor: TColor;
    ShowIndex, ShowHexa: Boolean; Clear: Boolean = true; Edged: Boolean=False );

  Procedure DrawLineType(Grapher: TEzGrapher; Canvas: TCanvas; Index: Integer;
    Rect: TRect; State: TOwnerDrawState; LineColor, FillColor: TColor;
    ShowIndex: Boolean; const Scale: Double; Repit: Integer;
    ShowHexa: Boolean; Clear: Boolean = true; Edged: Boolean=False );

  procedure DrawBlock(Grapher: TEzGrapher; Canvas: TCanvas;
    Rect: TRect; State: TOwnerDrawState; FillColor: TColor; Block: TEzSymbol;
    Clear: Boolean = true; Edged: Boolean = False );

implementation

uses
  EzConsts, ezsystem, EzLineDraw, EzGraphics;


function IsChildOf(const AChild, AParent: HWND): Boolean;
var
  lParent: HWND;
begin
 {determines whether one control is the child (or grand^x-child) of another}
  lParent := AChild;
  repeat
    lParent := GetParent(lParent);
  until(lParent = AParent) or(lParent = 0);
  result := lParent = AParent;
end;

Procedure DrawSymbol( Grapher: TEzGrapher; Canvas: TCanvas; Index: Integer;
  Rect: TRect; State: TOwnerDrawState; FillColor: TColor;
  ShowIndex, ShowHexa: Boolean; Clear: Boolean = true; Edged: Boolean=False );
var
  Boundsr:TRect;
  Symbol: TEzSymbol;
  Rgn: HRgn;
  TmpMarginX, TmpMarginY: Double;
  ARect: TRect;
  TmpHeight: Integer;
  sTmp: string;
  aedge: word;
begin
  if ( Index < 0 ) Or (Index > EzSystem.Ez_Symbols.Count-1) then Exit;
  Grapher.Clear;
  with Canvas do
  begin
    Brush.Color:= FillColor;
    ARect:= Rect;

    If Clear And Not ( odSelected in State ) then
      FillRect( Rect );

    If Edged then
    begin
      InflateRect( ARect, -1, -1 );
      aedge:= EDGE_BUMP;
      DrawEdge(Canvas.Handle, ARect, aedge, BF_RECT OR BF_ADJUST);
      InflateRect( ARect, -2, -2 );
    end;

    Boundsr:= ARect;
    if ShowIndex then
    begin
      SetBkMode(Handle, TRANSPARENT);
      if odSelected in State then
        Canvas.Font.Color:= clHighlightText
      else
        Canvas.Font.Color:= clBtnShadow;
      if Ez_Symbols.Count > 255 then
      begin
        If ShowHexa then
          sTmp:= IntToHex( Index, 3 )
        else
          sTmp:= Inttostr( Index );
      end else
      begin
        if ShowHexa then
          sTmp:= IntToHex( Index, 2 )
        else
          sTmp:= Inttostr( Index );
      end;
      TextOut(Boundsr.Left + 1, Boundsr.Top + 1, sTmp);
      TmpHeight:= TextHeight(sTmp) div 2;
      Boundsr.Top:= Boundsr.Top + TmpHeight;
      Boundsr.Left := Boundsr.Left + TmpHeight;
      Boundsr.Right := Boundsr.Right - TmpHeight;
    end;

    Symbol:= Ez_Symbols[Index];
    if (Symbol.Count=0) or EqualRect2D(Symbol.Extension, INVALID_EXTENSION) then Exit;
    with Boundsr do
      Grapher.SetViewport(Left, Top, Right, Bottom);
    with Symbol.Extension do
    begin
      TmpMarginX:= (Emax.X - Emin.X) / 20;
      TmpMarginY:= (Emax.Y - Emin.Y) / 20;
      Grapher.SetWindow(Emin.X - TmpMarginX, Emax.X + TmpMarginX, Emin.Y - TmpMarginY, Emax.Y + TmpMarginY);
    end;
    with Canvas do
    begin
      with Boundsr do
        Rgn:= CreateRectRgn(Left, Top, Right, Bottom);
      SelectClipRgn(Handle, Rgn);
      try
        Symbol.Draw(Grapher, Canvas,
          Grapher.CurrentParams.VisualWindow, IDENTITY_MATRIX2D, dmNormal);
      finally
        SelectClipRgn(Handle, 0);
        DeleteObject(Rgn);
      end;
    end;
  end;
End;

Procedure DrawLineType(Grapher: TEzGrapher; Canvas: TCanvas; Index: Integer;
  Rect: TRect; State: TOwnerDrawState; LineColor, FillColor: TColor;
  ShowIndex: Boolean; const Scale: Double; Repit: Integer;
  ShowHexa: Boolean; Clear: Boolean = true; Edged: Boolean=False );
var
  PenWidth:integer;
  Boundsr:TRect;
  Symbol: TEzSymbol;
  Rgn: HRgn;
  temp,tempx,tempy,tmpMarginX, tmpMarginY: Double;
  linetype: Integer;
  e:TEzRect;
  dist,FourthPI:Double;
  V:TEzVector;
  PenStyle: TEzPenStyle;
  PenScale: Double;
  PtArr: Array[0..5] of TPoint;
  I: Integer;
  Parts: Array[0..0] of Integer;
  S: string;
  aedge: Word;
  ALineColor: TColor;
begin
  if Index < 0 then
    Exit;
  Grapher.Clear;
  with Canvas do
  begin
     Boundsr := Rect;
     Brush.Color := FillColor;
     //
     If Clear And Not ( odSelected in State ) then
       FillRect( Boundsr );
     //
     If Edged then
     begin
       InflateRect( Boundsr, -1, -1 );
       aedge:= EDGE_BUMP;
       DrawEdge(Canvas.Handle, Boundsr, aedge, BF_RECT OR BF_ADJUST);
       InflateRect( Boundsr, -2, -2 );
     end;

     if ShowIndex then
     begin
       SetBkMode(Canvas.Handle, TRANSPARENT);
       if odSelected in State then
         Canvas.Font.Color:= clHighlightText
       else
         Canvas.Font.Color:= clBtnShadow;
       If ShowHexa then
        S:= IntToHex( Index, 2 )
       else
        S:= IntToStr( Index );
       Canvas.TextOut(Boundsr.Left + 1, Boundsr.Top + 1, S);
     end;
     if Index = 0 then
     begin
       //DrawEdge(Handle,Boundsr,EDGE_SUNKEN, BF_RECT {or BF_MIDDLE or BF_FLAT});
       S := 'None';
       DrawText(Canvas.Handle, PChar(S), Length(s), Boundsr,
         DT_CENTER or DT_SINGLELINE or DT_VCENTER);
       Exit;
     end;
     Pen.Style := psSolid;
     if odSelected in State then
       ALineColor:= clHighlightText
     else
       ALineColor:= LineColor;
     Pen.Color := ALineColor;
     PenWidth := Trunc(Scale);
     linetype := Index-2;

     { DRAW THE LINE TYPE }
     Symbol := Nil;
     if linetype >= MAX_LINETYPES then
     begin
       if (linetype-MAX_LINETYPES) < Ez_Linetypes.Count then
         Symbol:= Ez_Linetypes[linetype-MAX_LINETYPES]
       else
         Exit;
       if EqualRect2D(Symbol.Extension, INVALID_EXTENSION) then
         Exit;
     end;
     with Boundsr do
       Grapher.SetViewport(Left, Top, Right, Bottom);
     dist:=0;
     if linetype>=MAX_LINETYPES then
     begin
       e:= Symbol.Extension;
       dist:=(e.Emax.X - e.Emin.X);
     end;
     V:=TEzVector.Create(2);
     try
       V.Add(Point2d(0, 0));

       temp:= Dist2d(Point2d(0,100),Point2d(125,0)) / 3;
       FourthPI:=System.PI/4;
       tempx:= Cos(FourthPI)*temp;
       tempy:= Sin(FourthPI)*temp;
       V.Add(Point2d(tempx, 100-tempy));

       tempx:= Cos(FourthPI)*temp*2;
       tempy:= Sin(FourthPI)*temp*2;
       V.Add(Point2d(tempx, 100-tempy));

       V.Add(Point2d(125, 100));
       e:=V.Extension;
       with e do
       begin
         TmpMarginX:= (Emax.X - Emin.X) / 20;
         TmpMarginY:= (Emax.Y - Emin.Y) / 20;
         Grapher.SetWindow( Emin.X - TmpMarginX,
                            Emax.X + TmpMarginX,
                            Emin.Y - TmpMarginY,
                            Emax.Y + TmpMarginY );
       end;
       with Canvas do
       begin
         with Boundsr do
           Rgn:= CreateRectRgn(Left, Top, Right, Bottom);
         SelectClipRgn(Handle, Rgn);
         try
           if linetype>=MAX_LINETYPES then
           begin
             PenStyle.Style:=1;
             If dist * Repit <> 0 then
               PenScale := Dist2d(V[0],V[1])/(dist*Repit)  // the scale factor
             else
               PenScale := 0;
             PenStyle.Color:=clRed;//ALineColor;
             Symbol.DrawVector( V,
                                PenStyle,
                                PenScale,
                                Grapher,
                                Canvas,
                                Grapher.CurrentParams.VisualWindow,
                                IDENTITY_MATRIX2D,
                                dmNormal );
           end
           else if ( linetype >=0 ) and ( linetype <= Pred(MAX_LINETYPES) ) then
           begin
             for I:= 0 to V.Count-1 do
              PtArr[I]:= Grapher.RealToPoint(V[I]);
              Parts[0]:= V.Count;
              PolyDDA( PtArr,
                       Parts,
                       1,
                       Canvas,
                       Grapher,
                       linetype+1,
                       ALineColor, 1 );
           end
           else
           begin
             PenStyle.Style:=1;
             Penstyle.Width:=Grapher.PointsToDistY(PenWidth);
             Penstyle.Color:=ALineColor;
             V.DrawOpened( Canvas,
                           Grapher.CurrentParams.VisualWindow,
                           V.Extension,
                           Grapher,
                           PenStyle,
                           0, // no scale
                           IDENTITY_MATRIX2D,
                           dmNormal );
           end;
         finally
           SelectClipRgn(Handle, 0);
           DeleteObject(Rgn);
         end;
       end;
     finally
       V.free;
     end;
  end;
end;

Procedure DrawPattern( Canvas: TCanvas; Index: Integer;
  ForeColor, BackColor, FillColor: TColor; Rect: TRect;
  ShowIndex: Boolean ; State: TOwnerDrawState; ShowHexa: Boolean;
  Clear: Boolean = true; Edged: Boolean = False);
var
  Poly: array[0..4] of TPoint;
  Resname, sTmp: string;
  BmpRes: HBitmap;
  Bmp: TBitmap;
  pattern: Integer;
  Parts: array[0..0] of Integer;
  Boundsr: TRect;
  aedge:word;
begin
  Pattern:= Index;
  Boundsr:= Rect;
  with Canvas do
  begin
     Brush.Color:= FillColor;
     If Clear And Not ( odSelected in State ) then
      FillRect( Boundsr );

     InflateRect(Boundsr,-2,-2);

     If Edged then
     begin
       InflateRect( Boundsr, -1, -1 );
       aedge:= EDGE_BUMP;
       DrawEdge(Canvas.Handle, Boundsr, aedge, BF_RECT OR BF_ADJUST);
       InflateRect( Boundsr, -2, -2 );
     end;
  end;
  if ShowIndex then
  begin
    SetBkMode(Canvas.Handle, TRANSPARENT);
    //Canvas.Font:= Self.Font;
    If odSelected in State then
      Canvas.Font.Color:= clHighlightText
    else
      Canvas.Font.Color:= clBtnShadow;
    if ShowHexa then
      sTmp:= IntToHex( Index, 2 )
    else
      sTmp:= Inttostr( Index );
    Canvas.TextOut(Boundsr.Left + 1, Boundsr.Top + 1, sTmp);
    Boundsr.Left:= Boundsr.Left + Canvas.TextWidth('99') + 2;
  end;
  with Boundsr do
  begin
     Poly[0]:= Point(Left,Top);
     Poly[1]:= Point(Left,Bottom);
     Poly[2]:= Point(Right,Bottom);
     Poly[3]:= Point(Right,Top);
     Poly[4]:= Point(Left,Top);
  end;
  with Canvas do
  begin
     Pen.Color:= clBtnShadow;
     Brush.Style:= bsClear;
     case Index of
        1: begin
           Brush.Color := ForeColor;
           Brush.Style := bsSolid;
           end;
        2..89:
          begin
            Resname:= '#'+IntToStr(98+Pattern);
            BmpRes:= LoadBitmap(HInstance, PChar(Resname));
            if BmpRes<>0 then
            begin
              Bmp:= TBitmap.Create;
              try
                Bmp.Handle:= Bmpres;
                Parts[0]:= 5;
                EzGraphics.PolygonScreenFill8X8Bitmap(
                  Canvas,
                  nil,
                  Poly,
                  Parts,
                  1,
                  Bmp,
                  ForeColor,
                  BackColor );
              finally
                DeleteObject(Bmp.Handle);
                Bmp.free;
              end;
            end;
          end;
     end;
     Polygon(Poly);
  end;
end;

procedure DrawBlock(Grapher: TEzGrapher; Canvas: TCanvas;
  Rect: TRect; State: TOwnerDrawState; FillColor: TColor; Block: TEzSymbol;
  Clear: Boolean = true; Edged: Boolean = False );
var
  Boundsr:TRect;
  Rgn: HRgn;
  TmpMarginX, TmpMarginY: Double;
  aedge:word;
begin
  if (Block.Count=0) or EqualRect2D(Block.Extension, INVALID_EXTENSION) then Exit;

  Grapher.Clear;
  with Canvas do
  begin
    Brush.Color:= FillColor;
    Boundsr:= Rect;
    If Clear And Not ( odSelected in State ) then FillRect( Boundsr );

    If Edged then
    begin
      InflateRect( Boundsr, -1, -1 );
      aedge:= EDGE_BUMP;
      DrawEdge(Canvas.Handle, Boundsr, aedge, BF_RECT OR BF_ADJUST);
      InflateRect( Boundsr, -2, -2 );
    end;

    with Boundsr do
      Grapher.SetViewport(Left, Top, Right, Bottom);
    with Block.Extension do
    begin
      TmpMarginX:= (Emax.X - Emin.X) / 20;
      TmpMarginY:= (Emax.Y - Emin.Y) / 20;
      Grapher.SetWindow(Emin.X - TmpMarginX, Emax.X + TmpMarginX,
        Emin.Y - TmpMarginY, Emax.Y + TmpMarginY);
    end;
    with Canvas do
    begin
      with Boundsr do
        Rgn:= CreateRectRgn(Left, Top, Right, Bottom);
      SelectClipRgn(Handle, Rgn);
      try
        Block.Draw(Grapher, Canvas,
          Grapher.CurrentParams.VisualWindow, IDENTITY_MATRIX2D, dmNormal);
      finally
        SelectClipRgn(Handle, 0);
        DeleteObject(Rgn);
      end;
    end;
  end;
end;


type
  TCustomEditHack = class(TCustomEdit);

constructor TEzCustomDropDownForm.Create(AOwner: TComponent);
begin
  inherited CreateNew(AOwner);

  BorderIcons := [];
  BorderStyle := bsNone;
  Font := TCustomEditHack(AOwner).Font;

  FEntering := True;
  FLeaving := False;
  FCloseOnLeave := True;

  with TWinControl(AOwner) do
  begin
    Self.Left := ClientOrigin.X;
    Self.Top := ClientOrigin.Y + Height;
  end;
  FPanel:= TPanel.Create(Self);
  with FPanel do
  begin
    Parent:= Self;
    Align:= alClient;
    ParentFont := True;
    BevelInner:= bvLowered;
    BevelOuter:= bvRaised;
    BevelWidth:= 1;
    BorderWidth:= 2;
  end;
end;

procedure TEzCustomDropDownForm.CreateParams(var AParams: TCreateParams);
begin
  inherited;
  AParams.Style := AParams.Style or WS_BORDER;
end;

procedure TEzCustomDropDownForm.DoClose(var AAction: TCloseAction);
begin
  AAction := caFree;
  inherited;
end;

procedure TEzCustomDropDownForm.DoShow;
var
  lScreenRect: TRect;
begin
  inherited;

  if (not SystemParametersInfo(SPI_GETWORKAREA, 0, @lScreenRect, 0)) then
    lScreenRect := Rect(0, 0, Screen.Width, Screen.Height);

  if (Left + Width > lScreenRect.Right) then
    Left := lScreenRect.Right - Width;

  if (Top + Height > lScreenRect.Bottom) then
    Top := Self.Edit.ClientOrigin.y - Height;
end;

function TEzCustomDropDownForm.GetEdit: TCustomControl;
begin
  result := TCustomControl(Owner);
end;

function TEzCustomDropDownForm.Leaving: Boolean;
begin
  result := FLeaving;
end;

procedure TEzCustomDropDownForm.LoseFocus(const AFocusControl: TWinControl);
begin
  if (Assigned(OnLoseFocus)) then
    OnLoseFocus(Self, AFocusControl);

  if CloseOnLeave then
    Close;
end;

procedure TEzCustomDropDownForm.WMKillFocus(var AMessage: TMessage);
begin
  if IsChildOf(AMessage.WParam, Self.Handle) then
    inherited
  else
  begin
    FLeaving := True;
    try
      inherited;
      LoseFocus(FindControl(AMessage.WParam));
    finally
      FLeaving := False;
    end;
  end;
end;

procedure TEzCustomDropDownForm.WMSetFocus(var AMessage: TMessage);
begin
  if IsChildOf(AMessage.WParam, Self.Handle) then
    inherited
  else
  begin
    FEntering := True;
    try
      inherited;
      GetFocus(FindControl(AMessage.WParam));
    finally
      FEntering := False;
    end;
  end;
end;

function TEzCustomDropDownForm.Entering: Boolean;
begin
  result := FEntering;
end;

procedure TEzCustomDropDownForm.GetFocus(const APreviousControl: TWinControl);
begin
  if (Assigned(OnGetFocus)) then
    OnGetFocus(Self, APreviousControl);
end;


{ TEzLayerGridBox }

const
  Images: array[TEzCheckBitmap] of PChar = (  'VISIBLE',
                                              'INVISIBLE',
                                              'SELECT',
                                              'UNSELECT',
                                              'CURRENT',
                                              'NOCURRENT'  );
  BitmapWidth = 14;
  BitmapHeight = 14;


{ TEzLayerListBox }

constructor TEzLayerListBox.Create(AOwner: TComponent);
begin
  inherited Create(Aowner);
  FLockedTextColor:= clRed;
  RowCount:= 2;
  FixedCols:= 0;
  FixedRows:= 1;
  Options:= [goFixedVertLine,goFixedHorzLine,goVertLine,goHorzLine,goColSizing,goRowSelect];
  { create default columns }
  FColumns := TEzLayerBoxColumns.Create( Self, TEzLayerBoxColumn );
  BeginLayout;
  with FColumns.Add do
  begin
    ColumnData := cdCurrent;
    Alignment  := taCenter;
    Width := 48;
    BitmapEnabled.Handle:= LoadBitmap(HInstance, Images[obCurrent]);
    BitmapDisabled.Handle:= LoadBitmap(HInstance, Images[obNoCurrent]);
    Title.Alignment:= taCenter;
    Title.Caption:= SLLBCurrent;
  end;
  with FColumns.Add do
  begin
    ColumnData := cdVisible;
    Alignment  := taCenter;
    Width := 48;
    BitmapEnabled.Handle:= LoadBitmap(HInstance, Images[obVisible]);
    BitmapDisabled.Handle:= LoadBitmap(HInstance, Images[obInVisible]);
    Title.Alignment:= taCenter;
    Title.Caption:= SLLBVisible;
  end;
  with FColumns.Add do
  begin
    ColumnData := cdSelectable;
    Alignment  := taCenter;
    Width := 48;
    BitmapEnabled.Handle:= LoadBitmap(HInstance, Images[obSelectable]);
    BitmapDisabled.Handle:= LoadBitmap(HInstance, Images[obUnSelectable]);
    Title.Alignment:= taCenter;
    Title.Caption:= SLLBSelectable;
  end;
  with FColumns.Add do
  begin
    ColumnData := cdLayerName;
    Alignment  := taLeftJustify;
    Width := 128;
    Title.Alignment:= taCenter;
    Title.Caption:= SLLBLayerName;
  end;
  EndLayout;
end;

destructor TEzLayerListBox.Destroy;
begin
  FColumns.Free;
  inherited Destroy;
end;

procedure TEzLayerListBox.Loaded;
begin
  inherited Loaded;
  if not(csDesigning in ComponentState) then
    LayoutChanged;
end;

procedure TEzLayerListBox.Notification(AComponent: TComponent; Operation: TOperation);
begin
  Inherited Notification( AComponent, Operation );
  If ( Operation = opRemove ) And ( AComponent = FGIS ) Then
  begin
    FGIS := Nil;
    { clear the draw grid }
    RowCount:= 2;
    FixedRows:= 1;
    Invalidate;
  end;
end;

procedure TEzLayerListBox.SetColumns(const Value: TEzLayerBoxColumns);
begin
  FColumns.Assign(Value);
  LayoutChanged;
end;

procedure TEzLayerListBox.SetCurrentTextColor(const Value: TColor);
begin
  if FCurrentTextColor = Value then Exit;
  FCurrentTextColor := Value;
  Invalidate;
end;

procedure TEzLayerListBox.SetLockedTextColor(const Value: TColor);
begin
  if FLockedTextColor = Value then Exit;
  FLockedTextColor := Value;
  Invalidate;
end;

procedure TEzLayerListBox.MouseDown(Button: TMouseButton; Shift: TShiftState;
  X, Y: Integer);
  // обработка клика мыша
var
  ACol,ARow, AIndex: Integer;
begin
  inherited MouseDown(Button, Shift, X, Y);
  MouseToCell(X,Y,ACol,ARow);
  AIndex := GIS.Layers.Count - ARow;
  if (AIndex < 0) Or (ARow < 1 ) or ( AIndex > FGIS.Layers.Count - 1 ) or
     (ACol < 0) or ( ACol > FColumns.Count - 1 ) then Exit;
  with FColumns[ACol] do
  begin
    if ReadOnly then Exit;
    case ColumnData of
      cdCurrent:
        begin
        FGIS.CurrentLayerName:= FGIS.Layers[AIndex].Name;
        Invalidate;
        end;
      cdVisible:
        begin
          if Not FGIS.Layers[AIndex].IsCurrent Or (FGIS.Layers.Count = 1) then
            FGIS.Layers[AIndex].LayerInfo.Visible:= Not FGIS.Layers[AIndex].LayerInfo.Visible;
          Invalidate;
        end;
      cdSelectable:
        begin
          FGIS.Layers[AIndex].LayerInfo.Selectable:= Not FGIS.Layers[AIndex].LayerInfo.Selectable;
          Invalidate;
        end;
      cdLayerName:
      // обработка поля имени слоя
        begin
          //ShowMessage('имя слоя');
          FGIS.Layers[AIndex].Name := '333333333';
        end;
    end;
  end;
end;

procedure TEzLayerListBox.DrawCell(ACol, ARow: Longint; ARect: TRect;
  AState: TGridDrawState);
var
  DrawMode: Word;
  S: String;
  AIndex: Integer;
  ABitmap: TBitmap;
  AX, AY: Integer;
  ACellWidth, ACellHeight: Integer;
  Boundsr: TRect;

begin
  if ( csDesigning in ComponentState ) or (FixedRows <> 1) or
     ( ACol > FColumns.Count - 1 ) or ( FGIS = Nil ) then Exit;

  with Canvas do
  begin
    Boundsr:= ARect;
    if ARow = Self.Row then
    begin
      DrawEdge ( Handle, ARect, EDGE_BUMP, BF_RECT or BF_ADJUST );
      InflateRect( Boundsr, -2, -2 );
    end;
    if ARow = 0 then
    begin
      { The titles }
      // if not (gdFixed in AState) then
      begin
        Brush.Style:= bsSolid;
        Brush.Color := FColumns[ACol].Title.Color;
        FillRect(Boundsr);
        Font.Assign( FColumns[ACol].Title.Font );
      end;
      SetBkMode(Handle, TRANSPARENT);
      case FColumns[ACol].Title.Alignment of
        taLeftJustify:
          DrawMode:= DT_LEFT;
        taRightJustify:
          DrawMode:= DT_RIGHT;
        taCenter:
          DrawMode:= DT_CENTER;
      else
        DrawMode:= DT_LEFT;
      end;
      DrawText(Canvas.Handle, PChar(FColumns[ACol].Title.Caption), -1, Boundsr,
        DrawMode or DT_SINGLELINE or DT_VCENTER);
    end else
    begin
      //if not (gdFixed in AState) then
      begin
        Brush.Style:= bsSolid;
        Brush.Color := FColumns[ACol].Color;
        FillRect(Boundsr);
      end;
      AIndex := FGIS.Layers.Count - ARow;
      if AIndex < 0 then Exit;
      if FColumns[ACol].ColumnData in [cdLayerName, cdLayerFullPath] then
      begin
        SetBkMode(Handle, TRANSPARENT);
        case FColumns[ACol].Alignment of
          taLeftJustify:
            DrawMode:= DT_LEFT;
          taRightJustify:
            DrawMode:= DT_RIGHT;
          taCenter:
            DrawMode:= DT_CENTER;
        Else
          DrawMode:= DT_LEFT;
        end;
        if FColumns[ACol].ColumnData = cdLayerName then
          S:= FGIS.Layers[AIndex].Name
        else
          S:= FGIS.Layers[AIndex].FileName;
        Font.Assign( FColumns[ACol].Font );
        if FGIS.Layers[AIndex].IsCurrent then
          Font.Color:= Self.FCurrentTextColor
        else if FGIS.Layers[AIndex].LayerInfo.Locked then
          Font.Color:= Self.FLockedTextColor;
        DrawText(Canvas.Handle, PChar(S), -1, Boundsr,
          DrawMode or DT_SINGLELINE or DT_VCENTER);
      end
      else
      if FColumns[ACol].ColumnData in [cdMaxScale, cdMinScale] then
      begin
        SetBkMode(Handle, TRANSPARENT);
        case FColumns[ACol].Alignment of
          taLeftJustify:
            DrawMode:= DT_LEFT;
          taRightJustify:
            DrawMode:= DT_RIGHT;
          taCenter:
            DrawMode:= DT_CENTER;
        Else
          DrawMode:= DT_LEFT;
        end;
        if FColumns[ACol].ColumnData = cdMaxScale then
          S:= Format('%8.2f', [FGIS.Layers[AIndex].MaxScale])
        else
          S:= Format('%8.2f', [FGIS.Layers[AIndex].MinScale]);
        Font.Assign( FColumns[ACol].Font );
        if FGIS.Layers[AIndex].IsCurrent then
          Font.Color:= Self.FCurrentTextColor
        else if FGIS.Layers[AIndex].LayerInfo.Locked then
          Font.Color:= Self.FLockedTextColor;
        DrawText(Canvas.Handle, PChar(S), -1, Boundsr,
          DrawMode or DT_SINGLELINE or DT_VCENTER);
      end
      else
      begin
        ABitmap:= Nil;
        case FColumns[ACol].ColumnData of
          cdCurrent:
            if FGIS.Layers[AIndex].IsCurrent then
              ABitmap := FColumns[ACol].BitmapEnabled
            else
              ABitmap := FColumns[ACol].BitmapDisabled;
          cdVisible:
            if FGIS.Layers[AIndex].LayerInfo.Visible then
              ABitmap := FColumns[ACol].BitmapEnabled
            else
              ABitmap := FColumns[ACol].BitmapDisabled;
          cdSelectable:
            if FGIS.Layers[AIndex].LayerInfo.Selectable then
              ABitmap := FColumns[ACol].BitmapEnabled
            else
              ABitmap := FColumns[ACol].BitmapDisabled;
        end;
        if ABitmap = Nil then Exit;
        ACellWidth:= Boundsr.Right - Boundsr.Left;
        ACellHeight:= Boundsr.Bottom - Boundsr.Top;
        AX:= 0;
        AY:= 0;
        case FColumns[ACol].Alignment of
          taLeftJustify:
            begin
              AX:= Boundsr.Left;
              AY:= Boundsr.Top + (ACellHeight - ABitmap.Height) div 2;
            end;
          taRightJustify:
            begin
              AX:= Boundsr.Right - ABitmap.Width;
              AY:= Boundsr.Top + (ACellHeight - ABitmap.Height) div 2;
            end;
          taCenter:
            begin
              AX:= Boundsr.Left + (ACellWidth - ABitmap.Width) div 2;
              AY:= Boundsr.Top + (ACellHeight - ABitmap.Height) div 2;
            end;
        end;
        Draw(AX, AY, ABitmap);
      end;
    end;
  end;
  //inherited DrawCell( ACol, ARow, ARect, AState );
end;

procedure TEzLayerListBox.LayoutChanged;
var
  I: Integer;
begin
  { recreate the draw grid }
  if FInLayout then Exit;
  ColCount:= FColumns.Count;
  if FGIS= nil then
  begin
    RowCount:= 2;
    FixedRows:= 1;
    Exit;
  end;
  If FGIS.Layers.Count=0 then
    RowCount:= 2
  else
    RowCount:= FGIS.Layers.Count + 1;
  FixedRows:= 1;
  for I:= 0 to FColumns.Count-1 do
    ColWidths[I] := FColumns[I].Width;
end;

procedure TEzLayerListBox.SetGis(Value: TEzBaseGis);
begin
{$IFDEF LEVEL5}
  if Assigned( FGIS ) then FGIS.RemoveFreeNotification( Self );
{$ENDIF}
  FGIS := Value;
  if Value <> nil then
    Value.FreeNotification(Self);
  if (csDesigning in ComponentState) then Exit;
  LayoutChanged;
end;

procedure TEzLayerListBox.BeginLayout;
begin
  FInLayout:= true;
end;

procedure TEzLayerListBox.EndLayout;
begin
  FInLayout:= false;
  LayoutChanged;
end;

function TEzLayerListBox.Selected: string;
begin
  if (FGIS = Nil) Or (Row < 1) then Exit;
  Result:= FGIS.Layers[Row-1].Name;
end;

function TEzLayerListBox.SelectedLayer: TEzBaseLayer;
begin
  Result:= Nil;
  if (FGIS = Nil) Or (Row < 1) then Exit;
  Result:= FGIS.Layers[Row-1];
end;

{ TEzLayerBoxColumn }

constructor TEzLayerBoxColumn.Create(Collection: TCollection);
var
  ListBox: TEzLayerListBox;
begin
  ListBox := nil;
  if Assigned(Collection) and (Collection is TEzLayerBoxColumns) then
    ListBox := TEzLayerBoxColumns(Collection).FListBox;
  if Assigned(ListBox) then ListBox.BeginLayout;
  try
    inherited Create(Collection);
    FWidth:= 24;
    FColor:= clWindow;
    FFont:= TFont.Create;
    FFont.Assign(ListBox.Font);
    FTitle:= TEzLayerColumnTitle.Create(Self);
    FTitle.Font.Assign(FFont);
    FBitmapEnabled:= TBitmap.Create;
      FBitmapEnabled.Transparent:= true;
      FBitmapEnabled.TransparentMode:= tmAuto;
    FBitmapDisabled:= TBitmap.Create;
      FBitmapDisabled.Transparent:= true;
      FBitmapDisabled.TransparentMode:= tmAuto;
  finally
    if Assigned(ListBox) then ListBox.EndLayout;
  end;
end;

destructor TEzLayerBoxColumn.Destroy;
begin
  FFont.Free;
  FTitle.Free;
  FBitmapEnabled.Free;
  FBitmapDisabled.Free;
  inherited destroy;
end;

procedure TEzLayerBoxColumn.Assign(Source: TPersistent);
begin
  if Source is TEzLayerBoxColumn then
  begin
    if Assigned(Collection) then Collection.BeginUpdate;
    try
      ColumnData := TEzLayerBoxColumn(Source).ColumnData;
      Color := TEzLayerBoxColumn(Source).Color;
      ReadOnly:= TEzLayerBoxColumn(Source).ReadOnly;
      Font.Assign(TEzLayerBoxColumn(Source).Font);
      Title.Assign(TEzLayerBoxColumn(Source).Title);
      BitmapEnabled.Assign(TEzLayerBoxColumn(Source).BitmapEnabled);
      BitmapDisabled.Assign(TEzLayerBoxColumn(Source).BitmapDisabled);
    finally
      if Assigned(Collection) then Collection.EndUpdate;
    end;
  end else
    inherited Assign(Source);;
end;

function TEzLayerBoxColumn.GetDisplayName: String;
begin
  Result:= Inherited GetDisplayName;
end;

function TEzLayerBoxColumn.GetListBox: TEzLayerListBox;
begin
  if Assigned(Collection) and (Collection is TEzLayerBoxColumns) then
    Result:= TEzLayerBoxColumns(Collection).FListBox
  else
    Result:= Nil;
end;

procedure TEzLayerBoxColumn.RefreshLayout;
begin
  if GetListBox = Nil then Exit;
  with GetListBox do
  begin
    if csDesigning in ComponentState then Exit;
    if not FInLayout then Refresh;
  end;
end;

procedure TEzLayerBoxColumn.ChangeLayout;
begin
  if GetListBox = Nil then Exit;
  with GetListBox do
  begin
    if csDesigning in ComponentState then Exit;
    if not FInLayout then LayoutChanged;
  end;
end;

procedure TEzLayerBoxColumn.SetBitmapEnabled(const Value: TBitmap);
begin
  FBitmapEnabled.Assign(Value);
  RefreshLayout;
end;

procedure TEzLayerBoxColumn.SetBitmapDisabled(const Value: TBitmap);
begin
  FBitmapDisabled.Assign(Value);
  RefreshLayout;
end;

procedure TEzLayerBoxColumn.SetColor(const Value: TColor);
begin
  if FColor = Value then Exit;
  FColor := Value;
  RefreshLayout;
end;

procedure TEzLayerBoxColumn.SetColumnData(const Value: TEzColumnData);
begin
  FColumnData := Value;
  RefreshLayout;
end;

procedure TEzLayerBoxColumn.SetFont(const Value: TFont);
begin
  FFont.Assign(Value);
  RefreshLayout;
end;

procedure TEzLayerBoxColumn.SetReadOnly(const Value: Boolean);
begin
  FReadOnly := Value;
end;

procedure TEzLayerBoxColumn.SetTitle(const Value: TEzLayerColumnTitle);
begin
  FTitle.Assign(Value);
  ChangeLayout;
end;

procedure TEzLayerBoxColumn.SetAlignment(const Value: TAlignment);
begin
  if FAlignment = Value then Exit;
  FAlignment := Value;
  RefreshLayout;
end;

procedure TEzLayerBoxColumn.SetWidth(const Value: Integer);
begin
  if FWidth = Value then Exit;
  FWidth := Value;
  ChangeLayout;
end;

{ TEzLayerBoxColumns }

constructor TEzLayerBoxColumns.Create(ListBox: TEzLayerListBox; ColumnClass: TEzColumnClass);
begin
  inherited Create(ListBox, ColumnClass);
  FListBox:= ListBox;
end;

function TEzLayerBoxColumns.Add: TEzLayerBoxColumn;
begin
  Result := TEzLayerBoxColumn(inherited Add);
end;

function TEzLayerBoxColumns.GetColumn(Index: Integer): TEzLayerBoxColumn;
begin
  Result := TEzLayerBoxColumn(inherited Items[Index]);
end;

procedure TEzLayerBoxColumns.SetColumn(Index: Integer; Value: TEzLayerBoxColumn);
begin
  Items[Index].Assign(Value);
end;

function TEzLayerBoxColumns.GetOwner: TPersistent;
begin
  Result:= FListBox;
end;

procedure TEzLayerBoxColumns.Update(Item: TCollectionItem);
var
  Raw: Integer;
begin
  if (FListBox = nil) or (csLoading in FListBox.ComponentState) then Exit;
  if Item = nil then
  begin
    FListBox.LayoutChanged;
  end else
  begin
    Raw := Item.Index;
    FListBox.InvalidateCol(Raw);
    FListBox.ColWidths[Raw] := TEzLayerBoxColumn(Item).Width;
  end;
end;

{ TEzLayerColumnTitle }

constructor TEzLayerColumnTitle.Create(Column: TEzLayerBoxColumn);
begin
  inherited Create;
  FColumn:= Column;
  FFont:= TFont.Create;
  FColor:= clBtnFace;
  FAlignment:= taCenter;
end;

destructor TEzLayerColumnTitle.Destroy;
begin
  FFont.Free;
  inherited Destroy;
end;

procedure TEzLayerColumnTitle.SetAlignment(const Value: TAlignment);
begin
  if FAlignment = Value then Exit;
  FAlignment := Value;
  FColumn.RefreshLayout;
end;

procedure TEzLayerColumnTitle.SetCaption(const Value: string);
begin
  if FCaption = Value then Exit;
  FCaption := Value;
  FColumn.RefreshLayout;
end;

procedure TEzLayerColumnTitle.SetColor(const Value: TColor);
begin
  if FColor = Value then Exit;
  FColor := Value;
  FColumn.RefreshLayout;
end;

procedure TEzLayerColumnTitle.SetFont(const Value: TFont);
begin
  FFont.Assign(Value);
  FColumn.RefreshLayout;
end;

{ TEzSymbolsListBox }

procedure TEzSymbolsListBox.DrawItem(Index: Integer; Rect: TRect;
  State: TOwnerDrawState);
begin
  If odSelected in State then
    Canvas.FillRect( Rect );
  Canvas.Font.Assign( Self.Font );
  DrawSymbol( FGrapher, Self.Canvas, Index, Rect, State, Self.AreaColor,
    FShowIndex, FShowHexa, true, FEdged);
end;

procedure TEzSymbolsListBox.Populate;
var
  I: Integer;
begin
  If not HasParent then Exit;
  Items.Clear;
  For I:= 0 to Ez_Symbols.Count-1 do
    Items.Add( '' );
end;

{ TEzLinetypeListBox }

constructor TEzLinetypeListBox.Create(AOwner: TComponent);
begin
  inherited Create(Aowner);
  FScale:= 0;
  FRepit:= 2;
  FShowFirstDefaultLineTypes := MAX_LINETYPES;
end;

procedure TEzLinetypeListBox.DrawItem(Index: Integer; Rect: TRect;
  State: TOwnerDrawState);
begin
  If odSelected in State then
    Canvas.FillRect( Rect );
  Canvas.Font.Assign( Self.Font );
  if (Index > FShowFirstDefaultLineTypes) then
    Index := Index - FShowFirstDefaultLineTypes + MAX_LINETYPES + 1;
  DrawLinetype(FGrapher, Canvas, Index, Rect, State, clBlack, Self.AreaColor,
    FShowIndex, FScale, FRepit, FShowHexa, true, FEdged );
end;

function TEzLinetypeListBox.GetRepit: Integer;
begin
  Result:= FRepit;
end;

function TEzLinetypeListBox.GetScale: Double;
begin
  Result:=FScale;
end;

procedure TEzLinetypeListBox.Populate;
var
  I: Integer;
begin
  If Not HasParent then Exit;
  Items.Clear;
  with Items do
  begin
    Clear;
    Add('None');
    Add('Continuous');
    for I:= 2 to FShowFirstDefaultLineTypes do
      Add('');
    for I:= 0 to Ez_Linetypes.Count-1 do
      Add('');
  end;
end;

procedure TEzLinetypeListBox.SetRepit(const Value: Integer);
begin
  FRepit:=value;
end;

procedure TEzLinetypeListBox.SetScale(const Value: Double);
begin
  FScale:=value;
end;

procedure TEzLinetypeListBox.SetShowFirstDefaultLineTypes(const Value: Integer);
begin
  if FShowFirstDefaultLineTypes <> Value then
  begin
    FShowFirstDefaultLineTypes := Value;
    if FShowFirstDefaultLineTypes > MAX_LINETYPES then
      FShowFirstDefaultLineTypes := MAX_LINETYPES;
    if Items.Count > 0 then
      Populate;
  end;
end;

{ TEzBrushPatternListBox }

constructor TEzBrushPatternListBox.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FForeColor:= clBlack;
  FBackColor:=clWhite;
end;

procedure TEzBrushPatternListBox.DrawItem(Index: Integer; Rect: TRect;
  State: TOwnerDrawState);
begin
  If odSelected in State then
    Canvas.FillRect( Rect );
  Canvas.Font.Assign( Self.Font );
  DrawPattern( Canvas, Index, clBlack, clWhite, Self.AreaColor, Rect,
    FShowIndex, State, FShowHexa, True, FEdged  );
end;

function TEzBrushPatternListBox.GetBackColor: TColor;
begin
  Result:=FBackColor
end;

function TEzBrushPatternListBox.GetForeColor: TColor;
begin
  Result:=FForecolor;
end;

procedure TEzBrushPatternListBox.Populate;
var
  I: Integer;
begin
  If not HasParent then Exit;
  Items.Clear;
  Items.Add('None');
  Items.Add('Solid');
  for I:=2 to 89 do
    Items.Add('');
end;

procedure TEzBrushPatternListBox.SetBackColor(const Value: TColor);
begin
  FBackcolor:=value;
end;

procedure TEzBrushPatternListBox.SetForeColor(const Value: TColor);
begin
  FForeColor:=value;
end;

{ TEzBlocksListBox }

procedure TEzBlocksListBox.DrawItem(Index: Integer; Rect: TRect;
  State: TOwnerDrawState);
var
  Block: TEzSymbol;
  BlockIndex: Integer;
  Temp: Boolean;
  Stream: TFileStream;
begin
  If odSelected in State then
    Canvas.FillRect( Rect );
  Canvas.Font.Assign( Self.Font );
  Temp:= false;
  Block:= Nil;
  if Items.Objects[Index] <> nil then
  begin
    // retrieve the block from the list of preloaded blocks
    BlockIndex:= Longint(Items.Objects[Index]);
    Block:= TEzSymbol(Ez_Preferences.PreloadedBlocks.Objects[BlockIndex]);
  end else if FileExists( Items[Index] ) then
  begin
    // load the block from disk
    Temp:= true;
    Block:= TEzSymbol.Create(Nil);
    Stream:= TFileStream.Create(Items[Index], fmOpenRead or fmShareDenyNone);
    Try
      Block.LoadFromStream(Stream);
    Except
      Block.Free;
      Raise;
    End;
  end ;
  If Assigned( Block ) then
  begin
    DrawBlock(FGrapher, Canvas, Rect, State, Self.AreaColor, Block, true, FEdged );
    If Temp then Block.Free;
  end;
end;

procedure TEzBlocksListBox.Populate;
var
  I: Integer;
  SR: TSearchRec;
  Found: Integer;
  Source: string;
begin
  If not HasParent then Exit;
  Items.Clear;
  Source := AddSlash(Ez_Preferences.CommonSubDir);
  Found:= FindFirst(Source + '*.edb', faAnyFile, SR );
  try
    While Found = 0 Do
    Begin
      If ( SR.Name <> '.' ) And ( SR.Name <> '..' ) Then
      Begin
        Items.Add(Source + Sr.Name);
      End;
      Found := FindNext( SR );
    End;
  finally
    SysUtils.FindClose(SR);
  end;
  for I:= 0 to Ez_Preferences.PreloadedBlocks.Count-1 do
    Items.AddObject('', Pointer(I));
end;


{ TEzFlatComboBox}

constructor TEzFlatComboBox.Create (AOwner: TComponent);
begin
  inherited;
  AutoSize := False;
  Ctl3D := False;
//  BorderStyle := bsNone;
  Height := 25;
//  RedrawBorder (0);
end;

procedure TEzFlatComboBox.CMMouseEnter (var Message: TMessage);
begin
  inherited;
  if not Focused then
  begin
    MouseInControl:=true;
    RedrawBorder (0);
  end;
end;

procedure TEzFlatComboBox.CMMouseLeave (var Message: TMessage);
begin
  inherited;
  if not Focused then
  begin
    MouseInControl:=false;
    RedrawBorder (0);
  end;
end;

procedure TEzFlatComboBox.NewAdjustHeight;
var
  DC: HDC;
  SaveFont: HFONT;
  Metrics: TTextMetric;
begin
  DC := GetDC(0);
  SaveFont := SelectObject(DC, Font.Handle);
  GetTextMetrics (DC, Metrics);
  SelectObject (DC, SaveFont);
  ReleaseDC (0, DC);
  Height := Metrics.tmHeight + 6;
end;

procedure TEzFlatComboBox.Loaded;
begin
  inherited;
  if not(csDesigning in ComponentState) then
  begin
    NewAdjustHeight;
  end;
end;

procedure TEzFlatComboBox.CMEnabledChanged (var Message: TMessage);
const
  EnableColors: array[Boolean] of TColor = (clBtnFace, clWindow);
begin
  inherited;
  Color := EnableColors[Enabled];
end;

procedure TEzFlatComboBox.CMFontChanged (var Message: TMessage);
begin
  inherited;
  if not((csDesigning in ComponentState) and (csLoading in ComponentState)) then
    NewAdjustHeight;
end;

procedure TEzFlatComboBox.WMSetFocus (var Message: TWMSetFocus);
begin
  inherited;
  if not(csDesigning in ComponentState) then
    RedrawBorder (0);
end;

procedure TEzFlatComboBox.WMKillFocus (var Message: TWMKillFocus);
begin
  inherited;
  if not(csDesigning in ComponentState) then
    RedrawBorder (0);
end;

procedure TEzFlatComboBox.WMNCPaint (var Message: TMessage);
begin
  inherited;
  RedrawBorder (Message.WParam);
end;

procedure TEzFlatComboBox.RedrawBorder (const Clip: HRGN);
var
  DC: HDC;
  R: TRect;
  BtnFaceBrush, WindowBrush: HBRUSH;
  NewClipRgn:HRGN;
begin
  DC := GetWindowDC(Handle);
  try
    { Use update region }
    if (Clip <> 0) and (Clip <> 1) then begin
      GetWindowRect (Handle, R);
      if SelectClipRgn(DC, Clip) = ERROR then begin
        NewClipRgn := CreateRectRgnIndirect(R);
        SelectClipRgn (DC, NewClipRgn);
        DeleteObject (NewClipRgn);
      end;
      OffsetClipRgn (DC, -R.Left, -R.Top);
    end;
    GetWindowRect (Handle, R);
    OffsetRect (R, -R.Left, -R.Top);
    BtnFaceBrush := GetSysColorBrush(COLOR_BTNFACE);
    WindowBrush := GetSysColorBrush(COLOR_WINDOW);
    if ((csDesigning in ComponentState) and Enabled) or
       (not(csDesigning in ComponentState) and
        (Focused or (MouseInControl))) then begin
      DrawEdge (DC, R,BDR_SUNKENOUTER, BF_RECT or BF_ADJUST);
      with R do begin
        FillRect (DC, Rect(Left, Top, Left+1, Bottom-1), BtnFaceBrush);
        FillRect (DC, Rect(Left, Top, Right-1, Top+1), BtnFaceBrush);
      end;
      DrawEdge (DC, R, BDR_SUNKENINNER, BF_BOTTOMRIGHT);
      InflateRect (R, -1, -1);
      FrameRect (DC, R, WindowBrush);
    end
    else begin
      FrameRect (DC, R, BtnFaceBrush);
      InflateRect (R, -1, -1);
      FrameRect (DC, R, BtnFaceBrush);
      InflateRect (R, -1, -1);
      FrameRect (DC, R, WindowBrush);
    end;
  finally
    ReleaseDC (Handle, DC);
  end;
end;

procedure TEzFlatComboBox.WMPaint(var Message: TMessage);
begin
  inherited;
  RedrawBorder(0);
end;

procedure TEzFlatComboBox.CMExit(var Message: TCMExit);
begin
  MouseInControl:=false;
  RedrawBorder(0);
end;

procedure TEzFlatComboBox.DblClick;
begin
  inherited DblClick;
  If Items.Count = 0 then Exit;
  If ItemIndex < Items.Count-1 then
    Itemindex:= ItemIndex + 1
  Else
    ItemIndex:= 0;
end;

type
  TCustomListBoxHack = class(TCustomListBox);

{ TEzDropDownList }
constructor TEzDropDownList.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FList:= CreateListBox;
  with FList do
  begin
    Parent := Self.FPanel;
    ParentFont := True;
    OnClick := SLClick;
    OnLoseFocus := SLLoseFocus;
    OnKeyPress := SLKeyPress;
    Visible := True;
    Align := alClient;
    BorderStyle:= bsNone;
  end;
  FList.Populate;
end;

destructor TEzDropDownList.Destroy;
begin
  if Assigned(FList) then
    with FList do
    begin
      OnClick := NIL;
      OnKeyPress := NIL;
    end;
  inherited;
end;

procedure TEzDropDownList.DoCancel;
begin
  if Assigned(OnCancel) then
    OnCancel(Self)
  else
    Release;
end;

procedure TEzDropDownList.DoClick;
begin
  if Assigned(OnClick) then
    OnClick(Self);
  Release;
end;

function TEzDropDownList.GetColumns: Integer;
begin
  Result:= TCustomListBoxHack(FList).Columns;
end;

function TEzDropDownList.GetItemIndex: Integer;
begin
  Result:= FList.ItemIndex;
end;

procedure TEzDropDownList.Loaded;
begin
  inherited;
  If FList.Items.Count = 0 then FList.Populate;
end;

procedure TEzDropDownList.SetColumns(const Value: Integer);
begin
  TCustomListBoxHack(FList).Columns:= Value;
end;

procedure TEzDropDownList.SetFocus;
begin
  if FList.CanFocus then
    FList.SetFocus
  else
    inherited;
end;

procedure TEzDropDownList.SetItemIndex(Value: Integer);
begin
  FList.ItemIndex:= Value;
end;

procedure TEzDropDownList.SLClick(Sender: TObject);
begin
  DoClick;
end;

procedure TEzDropDownList.SLKeyPress(Sender: TObject; var Key: Char);
begin
  //MessageBeep( 0);
  case Key of
    #13: DoClick;
    #27: DoCancel;
  else
    DoClick;
  end;
end;

procedure TEzDropDownList.SLLoseFocus(const ASender: TObject;
  const AFocusControl: TWinControl);
begin
  Self.LoseFocus(AFocusControl);
end;

{ TEzCustomGridBox }

constructor TEzCustomGridBox.Create(AOwner: TComponent);
begin
  inherited Create(Aowner);
  ControlStyle := ControlStyle + [csOpaque, csCaptureMouse, csClickEvents,
    csDoubleClicks, csReflector, csAcceptsControls];
  FItemIndex:= -1;
  FShowIndex:= True;
  FEditAreaShowIndex:= True;
  FEdged:= True;
  FShowHexa:= False;
  FDropDownHeight:= 240;
  FDropDownWidth:= 320;
  FItemHeight:= 24;
  FDropDownCols:= 3;
  FBorderStyle:= bsSingle;
  FAreaColor:= clWindow;

  Color:= clWindow;

  FDropForm:= nil;
  FButton := TSpeedButton.Create(Self);
  with FButton do
  begin
    Parent := Self;
    Align := alRight;
    Cursor := crArrow;
    Flat := True;
    Width := GetSystemMetrics(SM_CXVSCROLL) + 1;
    Glyph.Handle := LoadBitmap(0,PChar(OBM_COMBO)); // 	 PChar(32738));
    OnClick := ButtonClick;
    Visible := True;
  end;
end;

destructor TEzCustomGridBox.Destroy;
begin
  CloseUp;
  FButton.OnClick := Nil;
  If Assigned(FDropForm) then
    FreeAndNil(FDropForm);
  inherited;
end;

procedure TEzCustomGridBox.SLClick(Sender: TObject);
begin
  ItemIndex:= FDropForm.FList.ItemIndex;
end;

procedure TEzCustomGridBox.Change;
begin
  If Assigned(FOnChange) then
    FOnChange(Self);
end;

procedure TEzCustomGridBox.SLDestroy(Sender: TObject);
begin
  CloseUp;
  FDropForm := NIL;
end;

procedure TEzCustomGridBox.SetItemIndex(Value: Integer);
begin
  If FItemIndex = Value then Exit;
  FItemIndex:= Value;
  Invalidate;
  Change;
end;

procedure TEzCustomGridBox.CloseUp;
begin
  if DroppedDown then
  begin
    ItemIndex:= FDropForm.ItemIndex;
    FreeAndNil(FDropForm);
  end;
  if not ((Leaving) or (csDestroying in ComponentState)) then
    SetFocus;
end;

function TEzCustomGridBox.GetDroppedDown: Boolean;
begin
  Result := Assigned(FDropForm) and not (csDestroying in FDropForm.ComponentState);
end;

procedure TEzCustomGridBox.DropDown;
begin
  if not DroppedDown then
  begin
    FDropForm:= CreateDropDownList;
    with FDropForm do
    begin
      Width:= DropDownWidth;
      with FList do
      begin
        Color:= Self.Color;
        AreaColor:= Self.AreaColor;
        FShowIndex:= Self.FShowIndex;
        FEdged:= Self.FEdged;
        FShowHexa:= Self.FShowHexa;
        Columns:= Self.DropDownCols;
        if FAutoSize then
        begin
          //FList.Height:= Self.DropDownCols * FList.ItemHeight;
          ItemHeight:= ClientHeight div Columns;
        end else
        begin
          ItemHeight:= Self.ItemHeight;
        end;

        ItemIndex:= Self.FItemIndex;
      end;
      OnClick := Self.SLClick;
      OnDestroy := Self.SLDestroy;
      Show;
      SetFocus;
    end;
  end;
end;

procedure TEzCustomGridBox.ButtonClick(Sender: TObject);
begin
  if DroppedDown then
    CloseUp
  else
    DropDown;
end;

procedure TEzCustomGridBox.Paint;
var
  Grapher: TEzGrapher;
  State: TOwnerDrawState;
  R: TRect;
begin
  inherited;
  Canvas.Brush.Style:= bsSolid;
  Canvas.Brush.Color:= Self.Color;
  Canvas.FillRect(ClientRect);
  If FItemIndex < 0 then Exit;
  Canvas.Font.Assign( Self.Font );
  Grapher:= TEzGrapher.Create(5,adScreen);
  Try
    State:= [];
    If Focused then
      State:= [odFocused];
    R:= ClientRect;
    R.Right:= R.Right - FButton.Width;
    If FEditAreaShowIndex Then
      Canvas.Font.Assign(Self.Font);
    PaintClientArea(Grapher, Canvas, FItemIndex, R, State, Self.Color,
      FEditAreaShowIndex, FShowHexa, True, False );
  Finally
    Grapher.Free;
  End;
end;

procedure TEzCustomGridBox.KeyDown(var AKey: Word; AShift: TShiftState);
begin
  case AKey of
    27 :
    begin    // ESC
      CloseUp;
    end;
    VK_DOWN:
      if AShift = [ssAlt] then
        DropDown;
  end;
  inherited;
end;

procedure TEzCustomGridBox.MouseDown(Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  inherited MouseDown(Button, Shift, X, Y);
  ButtonClick(Self);
end;

procedure TEzCustomGridBox.Resize;
begin
  inherited;
  Invalidate;
end;

procedure TEzCustomGridBox.LoseFocus(const AFocusControl: TWinControl);
begin
  if (AFocusControl <> NIL) and (AFocusControl <> FDropForm) and
     (AFocusControl.Owner <> FDropForm) then
  begin
    CloseUp;
    //inherited LoseFocus(AFocusControl);
  end;
end;

procedure TEzCustomGridBox.CMCtl3DChanged(var AMessage: TMessage);
begin
  inherited;
  FButton.Flat := not Self.Ctl3d;
end;

procedure TEzCustomGridBox.CMEnabledChanged(var AMessage: TMessage);
begin
  inherited;
  if not (Self.Enabled) and DroppedDown then
    CloseUp;
  FButton.Enabled:= Self.Enabled;
end;

procedure TEzCustomGridBox.WMKillFocus(var AMessage: TMessage);
begin
  FLeaving := True;
  try
    inherited;
    LoseFocus(FindControl(AMessage.WParam));
  finally
    FLeaving := False;
  end;
end;

function TEzCustomGridBox.Leaving: Boolean;
begin
  Result := FLeaving;
end;

procedure TEzCustomGridBox.WMSetFocus(var AMessage: TMessage);
begin
  FEntering := True;
  try
    inherited;
    GetFocus(FindControl(AMessage.WParam));
  finally
    FEntering := False;
  end;
end;

procedure TEzCustomGridBox.CMColorChanged(var AMessage: TMessage);
begin
  inherited;
  Refresh;
end;

procedure TEzCustomGridBox.CMParentColorChanged(var AMessage: TMessage);
begin
  inherited;
  Refresh;
end;

function TEzCustomGridBox.Entering: Boolean;
begin
  Result := FEntering;
end;

procedure TEzCustomGridBox.GetFocus(const APreviousControl: TWinControl);
begin
  if Assigned(OnGetFocus) then
    OnGetFocus(Self, APreviousControl)
end;

procedure TEzCustomGridBox.CreateParams(var Params: TCreateParams);
begin
  inherited CreateParams(Params);
  with Params do
  begin
    Style := Style or WS_TABSTOP;
    WindowClass.Style := CS_DBLCLKS;
    if FBorderStyle = bsSingle then
      if NewStyleControls and Ctl3D then
      begin
        Style := Style and not WS_BORDER;
        ExStyle := ExStyle or WS_EX_CLIENTEDGE;
      end
      else
        Style := Style or WS_BORDER;
  end;
end;

procedure TEzCustomGridBox.SetBorderStyle(const Value: TBorderStyle);
begin
  If FBorderStyle = Value then Exit;
  FBorderStyle := Value;
  RecreateWnd;
end;


type

  TEzDropSymbolsList = class(TEzDropDownList)
  public
    Function CreateListBox: TEzCustomListBox; override;
  end;

  TUnfocusingSymbolsList = class(TEzSymbolsListBox)
  private
    FOnLoseFocus: TEzFocusChangeEvent;
    procedure WMKillFocus(var AMessage: TMessage); message WM_KILLFOCUS;
  protected
    procedure LoseFocus(const AFocusControl: TWinControl); dynamic;
    property OnLoseFocus: TEzFocusChangeEvent read FOnLoseFocus write FOnLoseFocus;
  end;

{ TEzDropSymbolsList }

function TEzDropSymbolsList.CreateListBox: TEzCustomListBox;
begin
  Result:= TUnfocusingSymbolsList.Create(Self);
end;

{ TUnfocusingSymbolsList }
procedure TUnfocusingSymbolsList.WMKillFocus(var AMessage: TMessage);
begin
  inherited;
  if (not IsChildOf(AMessage.WParam, Self.Handle)) then
    LoseFocus(FindControl(AMessage.WParam));
end;

procedure TUnfocusingSymbolsList.LoseFocus(const AFocusControl: TWinControl);
begin
  if(Assigned(OnLoseFocus)) then
    OnLoseFocus(Self, AFocusControl);
end;

{ TEzSymbolsGridBox }

function TEzSymbolsGridBox.CreateDropDownList: TEzDropDownList;
begin
  Result:= TEzDropSymbolsList.Create(Self);
end;

procedure TEzSymbolsGridBox.PaintClientArea(Grapher: TEzGrapher;
  Canvas: TCanvas; Index: Integer; Rect: TRect; State: TOwnerDrawState;
  FillColor: TColor; ShowIndex, ShowHexa, Clear, Edged: Boolean);
begin
  DrawSymbol( Grapher, Canvas, Index, Rect, State, FillColor, ShowIndex,
    ShowHexa, Clear, Edged);
end;


{ TEzLineTypeGridBoz }

type

  TEzDropLineTypeList = class(TEzDropDownList)
  public
    Function CreateListBox: TEzCustomListBox; override;
  end;

  TUnfocusingLineTypeList = class(TEzLineTypeListBox)
  private
    FOnLoseFocus: TEzFocusChangeEvent;
    procedure WMKillFocus(var AMessage: TMessage); message WM_KILLFOCUS;
  protected
    procedure LoseFocus(const AFocusControl: TWinControl); dynamic;
    property OnLoseFocus: TEzFocusChangeEvent read FOnLoseFocus write FOnLoseFocus;
  end;

{ TEzDropSymbolsList }

function TEzDropLineTypeList.CreateListBox: TEzCustomListBox;
begin
  Result:= TUnfocusingLineTypeList.Create(Self);
end;

{ TUnfocusingSymbolsList }
procedure TUnfocusingLineTypeList.WMKillFocus(var AMessage: TMessage);
begin
  inherited;
  if (not IsChildOf(AMessage.WParam, Self.Handle)) then
    LoseFocus(FindControl(AMessage.WParam));
end;

procedure TUnfocusingLineTypeList.LoseFocus(const AFocusControl: TWinControl);
begin
  if(Assigned(OnLoseFocus)) then
    OnLoseFocus(Self, AFocusControl);
end;

{ TEzLineTypeGridBox }

function TEzLineTypeGridBox.CreateDropDownList: TEzDropDownList;
begin
  Result:= TEzDropLineTypeList.Create(Self);
end;

function TEzLineTypeGridBox.GetRepit: Integer;
begin
  Result:= FRepit;
end;

function TEzLineTypeGridBox.GetScale: Double;
begin
  Result:=FScale;
end;

procedure TEzLineTypeGridBox.PaintClientArea(Grapher: TEzGrapher;
  Canvas: TCanvas; Index: Integer; Rect: TRect; State: TOwnerDrawState;
  FillColor: TColor; ShowIndex, ShowHexa, Clear, Edged: Boolean);
begin
  DrawLinetype(Grapher, Canvas, Index, Rect, State, clBlack, FillColor,
    ShowIndex, FScale, FRepit, ShowHexa, Clear, Edged );
end;

procedure TEzLineTypeGridBox.SetRepit(const Value: Integer);
begin
  FRepit:= Value;
  Invalidate;
end;

procedure TEzLineTypeGridBox.SetScale(const Value: Double);
begin
  FScale:= Value;
  Invalidate;
end;

{ TEzBrushPatternGridBox }

type

  TEzDropPatternList = class(TEzDropDownList)
  public
    Function CreateListBox: TEzCustomListBox; override;
  end;

  TUnfocusingPatternList = class(TEzBrushPatternListBox)
  private
    FOnLoseFocus: TEzFocusChangeEvent;
    procedure WMKillFocus(var AMessage: TMessage); message WM_KILLFOCUS;
  protected
    procedure LoseFocus(const AFocusControl: TWinControl); dynamic;
    property OnLoseFocus: TEzFocusChangeEvent read FOnLoseFocus write FOnLoseFocus;
  end;

{ TEzDropPatternList }

function TEzDropPatternList.CreateListBox: TEzCustomListBox;
begin
  Result:= TUnfocusingPatternList.Create(Self);
end;

{ TUnfocusingPatternList }
procedure TUnfocusingPatternList.WMKillFocus(var AMessage: TMessage);
begin
  inherited;
  if (not IsChildOf(AMessage.WParam, Self.Handle)) then
    LoseFocus(FindControl(AMessage.WParam));
end;

procedure TUnfocusingPatternList.LoseFocus(const AFocusControl: TWinControl);
begin
  if(Assigned(OnLoseFocus)) then
    OnLoseFocus(Self, AFocusControl);
end;

{ TEzBrushPatternGridBox }

function TEzBrushPatternGridBox.CreateDropDownList: TEzDropDownList;
begin
  Result:= TEzDropPatternList.Create(Self);
end;

procedure TEzBrushPatternGridBox.PaintClientArea(Grapher: TEzGrapher;
  Canvas: TCanvas; Index: Integer; Rect: TRect; State: TOwnerDrawState;
  FillColor: TColor; ShowIndex, ShowHexa, Clear, Edged: Boolean);
begin
  DrawPattern( Canvas, Index, clBlack, clWhite, FillColor, Rect,
    ShowIndex, State, ShowHexa, Clear, Edged );
end;


{ TEzBlocksGridBox }

type

  TEzDropBlocksList = class(TEzDropDownList)
  public
    Function CreateListBox: TEzCustomListBox; override;
  end;

  TUnfocusingBlocksList = class(TEzBlocksListBox)
  private
    FOnLoseFocus: TEzFocusChangeEvent;
    procedure WMKillFocus(var AMessage: TMessage); message WM_KILLFOCUS;
  protected
    procedure LoseFocus(const AFocusControl: TWinControl); dynamic;
    property OnLoseFocus: TEzFocusChangeEvent read FOnLoseFocus write FOnLoseFocus;
  end;

{ TEzDropBlocksList }

function TEzDropBlocksList.CreateListBox: TEzCustomListBox;
begin
  Result:= TUnfocusingBlocksList.Create(Self);
end;

{ TUnfocusingBlocksList }
procedure TUnfocusingBlocksList.WMKillFocus(var AMessage: TMessage);
begin
  inherited;
  if (not IsChildOf(AMessage.WParam, Self.Handle)) then
    LoseFocus(FindControl(AMessage.WParam));
end;

procedure TUnfocusingBlocksList.LoseFocus(const AFocusControl: TWinControl);
begin
  if(Assigned(OnLoseFocus)) then
    OnLoseFocus(Self, AFocusControl);
end;

{ TEzBlocksGridBox }

Constructor TEzBlocksGridBox.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FBlockList:= TStringList.Create;
  if not (csDesigning in ComponentState) then
    Populate;
end;

destructor TEzBlocksGridBox.Destroy;
begin
  FBlockList.Free;
  inherited;
end;

procedure TEzBlocksGridBox.Populate;
var
  I: Integer;
  SR: TSearchRec;
  Found: Integer;
  Source: string;
begin
  If not HasParent then Exit;
  FBlockList.Clear;
  Source := AddSlash(Ez_Preferences.CommonSubDir);
  Found:= FindFirst(Source + '*.edb', faAnyFile, SR );
  try
    While Found = 0 Do
    Begin
      If ( SR.Name <> '.' ) And ( SR.Name <> '..' ) Then
      Begin
        FBlockList.Add(Source + Sr.Name);
      End;
      Found := FindNext( SR );
    End;
  finally
    SysUtils.FindClose(SR);
  end;
  for I:= 0 to Ez_Preferences.PreloadedBlocks.Count-1 do
    FBlockList.AddObject('', Pointer(I));
end;

function TEzBlocksGridBox.CreateDropDownList: TEzDropDownList;
begin
  Result:= TEzDropBlocksList.Create(Self);
end;

procedure TEzBlocksGridBox.PaintClientArea(Grapher: TEzGrapher;
  Canvas: TCanvas; Index: Integer; Rect: TRect; State: TOwnerDrawState;
  FillColor: TColor; ShowIndex, ShowHexa, Clear, Edged: Boolean);
var
  Block: TEzSymbol;
  BlockIndex: Integer;
  Temp: Boolean;
  Stream: TFileStream;
begin
  Temp:= false;
  Block:= Nil;
  if FBlockList.Objects[Index] <> nil then
  begin
    // retrieve the block from the list of preloaded blocks
    BlockIndex:= Longint(FBlockList.Objects[Index]);
    Block:= TEzSymbol(Ez_Preferences.PreloadedBlocks.Objects[BlockIndex]);
  end else if FileExists( FBlockList[Index] ) then
  begin
    // load the block from disk
    Temp:= true;
    Block:= TEzSymbol.Create(Nil);
    Stream:= TFileStream.Create(FBlockList[Index], fmOpenRead or fmShareDenyNone);
    Try
      Block.LoadFromStream(Stream);
    Except
      Block.Free;
      Raise;
    End;
  end ;
  If Assigned( Block ) Then
  Begin
    DrawBlock(Grapher, Canvas, Rect, State, FillColor, Block, Clear, Edged );
    If Temp then
      Block.Free;
  End;
end;


{ TEzCustomListBox }

constructor TEzCustomListBox.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FGrapher:= TEzGrapher.Create(10,adScreen);
  Style:= lbOwnerDrawFixed;
  FEdged:= True;
  FShowIndex:= true;
  ItemHeight:= 35;
  FAreaColor:= clWindow;
end;

destructor TEzCustomListBox.Destroy;
begin
  FGrapher.Free;
  inherited;
end;

procedure TEzCustomListBox.Loaded;
begin
  inherited;
  if not (csDesigning in ComponentState) then Populate;
end;

procedure TEzCustomListBox.SetShowIndex(Value: Boolean);
begin
  FShowIndex:= Value;
  Invalidate;
end;


constructor TEzLayerGridBox.Create(AOwner: TComponent);
var
  I: TEzCheckBitmap;
begin
  inherited Create(AOwner);
  { layer name, visible, editable }
  DropDownCount := 5;
  Style := csOwnerDrawFixed;

  for I:= Low(TEzCheckBitmap) to High(TEzCheckBitmap) do
  begin
    FPictures[I]:= TBitmap.Create;
    FPictures[I].Handle:= LoadBitmap(HInstance, Images[I]);
    FPictures[I].Transparent:= True;
    FPictures[I].TransparentMode:= tmAuto;
  end;

  FCurrentTextColor:= clBlack;
  FLockedTextColor:= clRed;

end;

destructor TEzLayerGridBox.Destroy;
var
  I: TEzCheckBitmap;
begin
  for I:= Low(TEzCheckBitmap) to High(TEzCheckBitmap) do
    FPictures[I].Free;
  inherited Destroy;
end;

procedure TEzLayerGridBox.DrawItem(Index: Integer; Rect: TRect; State: TOwnerDrawState);
var
  Layer: TEzBaseLayer;
  Boundsr: TRect;
  TopOffset: Integer;
  S: string;
  Value: TBitmap;
  w: Integer;
  ColOffset: array[0..3] of Integer;
  Col: Integer;
begin
  if (csDesigning in ComponentState) or (FGIS = nil) or
    (Index < 0) or (Index > FGIS.Layers.Count - 1) then Exit;
  ColOffset[3] := Rect.Right-2;
  ColOffset[2] := ColOffset[3] - BitmapWidth - 4;
  ColOffset[1] :=ColOffset[2] - BitmapWidth - 4;
  ColOffset[0] := 2;
  Layer := FGIS.Layers[Index];
  with Canvas do
  begin
    Brush.Style:= bsSolid;
    Brush.Color:= Self.Color;
    Font.Assign(Self.Font);
    if odSelected in State then
    begin
       Brush.Color := clHighlight;
       Font.Color := clHighlightText;
    end else
       Brush.Color := Color;
    FillRect( Rect );

    //DrawEdge(Handle,Boundsr,{EDGE_RAISED} EDGE_SUNKEN, BF_RECT {or BF_MIDDLE or BF_FLAT});
    For Col:= 0 to 2 do
    begin
      BoundsR:= Rect;
      BoundsR.Left:= ColOffset[Col];
      w:= (ColOffset[Col+1]-ColOffset[Col]);
      BoundsR.Right:= BoundsR.Left + w;
      if Col > 0 then
      begin
        TopOffset:= Rect.Top + ezlib.IMax(0, ((Rect.Bottom - Rect.Top) - BitmapHeight) div 2);
        BoundsR.Left:= BoundsR.Left + Trunc(w / 2) - trunc(BitmapWidth / 2);
        BoundsR.Right:= BoundsR.Right + trunc(w / 2) - trunc(BitmapWidth / 2) + w - 1;
        BoundsR.Top:= TopOffset;
        InflateRect(BoundsR, -1, -1);
      end;
      case Col of
        0:begin

          if FFullPath then
            S:= Layer.FileName
          else
            S:= Layer.Name;
          Boundsr.Top:= Boundsr.Top + 1;
          Boundsr.Bottom:= Boundsr.Bottom - 1;

          if Not(odSelected in State) then
          begin
            if Layer.IsCurrent then
              Font.Color:= Self.FCurrentTextColor
            else if Layer.LayerInfo.Locked then
              Font.Color:= Self.FLockedTextColor;
            //Font.Color:= clblack;
          end;

          Brush.Style:= bsClear;
          DrawText(Handle, PChar(s), Length(s), Boundsr,
            DT_LEFT or DT_SINGLELINE or DT_VCENTER);
          end;
        1:begin   // visible
          if Layer.LayerInfo.Visible then
            Value:= FPictures[obVisible]
          else
            Value:= FPictures[obInvisible];
          Canvas.Draw( Boundsr.Left, Boundsr.Top, Value );
          end;
        2:begin   // selectable
          if Layer.LayerInfo.Selectable then
            Value:= FPictures[obSelectable]
          else
            Value:= FPictures[obUnselectable];
          Canvas.Draw( Boundsr.Left, Boundsr.Top, Value );
          end;
      end;
    end;
  end;
end;

procedure TEzLayerGridBox.Change;
var
  Layer: TEzBaseLayer;
begin
  inherited Change;
  If (ItemIndex < 0) or (FGIS = Nil) then Exit;
  Layer:= FGIS.Layers[ItemIndex];
  FGIS.CurrentLayerName:= Layer.Name;
end;

procedure TEzLayerGridBox.Notification(AComponent: TComponent; Operation: TOperation);
begin
  Inherited Notification( AComponent, Operation );
  If ( Operation = opRemove ) And ( AComponent = FGIS ) Then
  begin
    FGIS := Nil;
    { clear the grid box }
    Items.Clear;
    Invalidate;
  end;
end;

procedure TEzLayerGridBox.SetFullPath(const Value: Boolean);
begin
  if FFullPath = Value then Exit;
  FFullPath := Value;
  Invalidate;
end;

procedure TEzLayerGridBox.SetGis(const Value: TEzBaseGis);
var
  I: Integer;
  Layer: TEzBaseLayer;
begin
{$IFDEF LEVEL5}
  if Assigned(FGIS) then FGIS.RemoveFreeNotification( Self );
{$ENDIF}
  FGIS := Value;
  if Value <> nil then
    Value.FreeNotification(Self);
  if csDesigning in ComponentState then Exit;
  Items.Clear;
  if (Value = Nil) Or Not Value.MapInfo.IsValid then Exit;
  { populate the list }
  for I:= 0 to FGIS.Layers.Count - 1 do
  begin
    Layer:= FGIS.Layers[I];
    Items.Add( Layer.Name );
  end;
  ItemIndex := FGIS.Layers.IndexOfName(FGIS.MapInfo.CurrentLayer);
end;

{$IFDEF BCB}
function TEzLayerGridBox.GetCurrentTextColor: TColor;
begin
  Result := FCurrentTextColor;
end;

function TEzLayerGridBox.GetFullPath: Boolean;
begin
  Result := FFullPath;
end;

function TEzLayerGridBox.GetGis: TEzBaseGis;
begin
  Result := FGIS;
end;

function TEzLayerGridBox.GetLockedTextColor: TColor;
begin
  Result := FLockedTextColor;
end;

procedure TEzLayerGridBox.SetCurrentTextColor(const Value: TColor);
begin
  FCurrentTextColor := Value;
end;

procedure TEzLayerGridBox.SetLockedTextColor(const Value: TColor);
begin
  FLockedTextColor := Value;
end;
{$ENDIF}


end.
