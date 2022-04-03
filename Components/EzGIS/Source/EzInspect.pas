unit EzInspect;

{$I EZ_FLAG.PAS}
interface

Uses
  SysUtils, Messages, Classes, Windows, Controls, StdCtrls, Forms, Grids,
  Buttons, Graphics, ComCtrls, EzMiscelCtrls, eznumed, ezcmdline,
  ezbasegis, extdlgs, EzMiscelEntities, EzLib, ShlObj, EzBase, EzColorPicker;

type

  TGoingOffReason = ( goNone, goLeft, goRight, goUp, goDown, goRTab, goLTab,
    goEnter, goEscape, goPgUp, goPgDn, goHome, goEnd );

  TGoingOffEvent = Procedure( Sender: TObject; Reason: TGoingOffReason;
    Var AllowExit: Boolean ) Of Object;

  TEzBaseProperty = class;

  TInplaceComboBox = class(TEzFlatComboBox)
  private
    FBaseProperty: TEzBaseProperty;
    FOnGoingOff: TGoingOffEvent;
    FRequireNotification: Boolean;
    Procedure CNKeydown( Var Message: TWMkeydown ); Message CN_KEYDOWN;
    Procedure CMEnter( Var Message: TCMEnter ); Message CM_ENTER;
    Procedure CMExit( Var Message: TCMExit ); Message CM_EXIT;
    Procedure TriggerGoingOffEvent( Reason: TGoingOffReason;
      Var AllowExit: Boolean );
    procedure DoChange;
  {$IFDEF BCB} (*_*)
    function GetOnGoingOff: TGoingOffEvent;
    procedure SetOnGoingOff(const Value: TGoingOffEvent);
  {$ENDIF}
  protected
    procedure Change; override;
  public
    constructor Create(AOwner: TComponent); Override;
    Procedure GoOff;
    Property OnGoingOff: TGoingOffEvent
      Read {$IFDEF BCB} GetOnGoingOff {$ELSE} FOnGoingOff {$ENDIF}
      Write {$IFDEF BCB} SetOnGoingOff{$ELSE} FOnGoingOff {$ENDIF} ; (*_*)
  end;

  TInplaceDateTimePicker = class(TDateTimePicker)
  private
    FBaseProperty: TEzBaseProperty;
    FOnGoingOff: TGoingOffEvent;
    FRequireNotification: Boolean;
    Procedure CNKeydown( Var Message: TWMkeydown ); Message CN_KEYDOWN;
    Procedure CMEnter( Var Message: TCMEnter ); Message CM_ENTER;
    Procedure CMExit( Var Message: TCMExit ); Message CM_EXIT;
    Procedure TriggerGoingOffEvent( Reason: TGoingOffReason;
      Var AllowExit: Boolean );
    procedure DoChange;
  {$IFDEF BCB} (*_*)
    function GetOnGoingOff: TGoingOffEvent;
    procedure SetOnGoingOff(const Value: TGoingOffEvent);
  {$ENDIF}
  public
    constructor Create(AOwner: TComponent); Override;
    Procedure GoOff;
    Property OnGoingOff: TGoingOffEvent
      Read {$IFDEF BCB} GetOnGoingOff {$ELSE} FOnGoingOff {$ENDIF}
      Write {$IFDEF BCB} SetOnGoingOff{$ELSE} FOnGoingOff {$ENDIF} ; (*_*)
  end;

  TInplaceEdit = class(TEdit)
  private
    FBaseProperty: TEzBaseProperty;
    FOnGoingOff: TGoingOffEvent;
    FRequireNotification: Boolean;
    Procedure CNKeydown( Var Message: TWMkeydown ); Message CN_KEYDOWN;
    Procedure CMEnter( Var Message: TCMEnter ); Message CM_ENTER;
    Procedure CMExit( Var Message: TCMExit ); Message CM_EXIT;
    Procedure TriggerGoingOffEvent( Reason: TGoingOffReason;
      Var AllowExit: Boolean );
    procedure DoChange;
  {$IFDEF BCB} (*_*)
    function GetOnGoingOff: TGoingOffEvent;
    procedure SetOnGoingOff(const Value: TGoingOffEvent);
  {$ENDIF}
  public
    constructor Create(AOwner: TComponent); Override;
    Procedure GoOff;
    Property OnGoingOff: TGoingOffEvent
      Read {$IFDEF BCB} GetOnGoingOff {$ELSE} FOnGoingOff {$ENDIF}
      Write {$IFDEF BCB} SetOnGoingOff{$ELSE} FOnGoingOff {$ENDIF} ; (*_*)
  end;

  TInplaceNumEd = class(TEzNumEd)
  private
    FBaseProperty: TEzBaseProperty;
    FOnGoingOff: TGoingOffEvent;
    FRequireNotification: Boolean;
    Procedure CNKeydown( Var Message: TWMkeydown ); Message CN_KEYDOWN;
    Procedure CMEnter( Var Message: TCMEnter ); Message CM_ENTER;
    Procedure CMExit( Var Message: TCMExit ); Message CM_EXIT;
    Procedure TriggerGoingOffEvent( Reason: TGoingOffReason;
      Var AllowExit: Boolean );
    procedure DoChange;
  {$IFDEF BCB} (*_*)
    function GetOnGoingOff: TGoingOffEvent;
    procedure SetOnGoingOff(const Value: TGoingOffEvent);
  {$ENDIF}
  public
    constructor Create(AOwner: TComponent); Override;
    Procedure GoOff;
    Property OnGoingOff: TGoingOffEvent
      Read {$IFDEF BCB} GetOnGoingOff {$ELSE} FOnGoingOff {$ENDIF}
      Write {$IFDEF BCB} SetOnGoingOff{$ELSE} FOnGoingOff {$ENDIF} ; (*_*)
  end;


  TInplaceSymbolsBox = class(TEzSymbolsGridBox)
  private
    FBaseProperty: TEzBaseProperty;
    FOnGoingOff: TGoingOffEvent;
    FRequireNotification: Boolean;
    Procedure CNKeydown( Var Message: TWMkeydown ); Message CN_KEYDOWN;
    Procedure CMEnter( Var Message: TCMEnter ); Message CM_ENTER;
    Procedure CMExit( Var Message: TCMExit ); Message CM_EXIT;
    Procedure TriggerGoingOffEvent( Reason: TGoingOffReason;
      Var AllowExit: Boolean );
    procedure DoChange;
  {$IFDEF BCB} (*_*)
    function GetOnGoingOff: TGoingOffEvent;
    procedure SetOnGoingOff(const Value: TGoingOffEvent);
  {$ENDIF}
  public
    constructor Create(AOwner: TComponent); Override;
    Procedure GoOff;
    Property OnGoingOff: TGoingOffEvent
      Read {$IFDEF BCB} GetOnGoingOff {$ELSE} FOnGoingOff {$ENDIF}
      Write {$IFDEF BCB} SetOnGoingOff{$ELSE} FOnGoingOff {$ENDIF} ; (*_*)
  end;


  TInplaceBlocksBox = class(TEzBlocksGridBox)
  private
    FBaseProperty: TEzBaseProperty;
    FOnGoingOff: TGoingOffEvent;
    FRequireNotification: Boolean;
    Procedure CNKeydown( Var Message: TWMkeydown ); Message CN_KEYDOWN;
    Procedure CMEnter( Var Message: TCMEnter ); Message CM_ENTER;
    Procedure CMExit( Var Message: TCMExit ); Message CM_EXIT;
    Procedure TriggerGoingOffEvent( Reason: TGoingOffReason;
      Var AllowExit: Boolean );
    procedure DoChange;
  {$IFDEF BCB} (*_*)
    function GetOnGoingOff: TGoingOffEvent;
    procedure SetOnGoingOff(const Value: TGoingOffEvent);
  {$ENDIF}
  public
    constructor Create(AOwner: TComponent); Override;
    Procedure GoOff;
    Property OnGoingOff: TGoingOffEvent
      Read {$IFDEF BCB} GetOnGoingOff {$ELSE} FOnGoingOff {$ENDIF}
      Write {$IFDEF BCB} SetOnGoingOff{$ELSE} FOnGoingOff {$ENDIF} ; (*_*)
  end;

  TInplaceColorBox = class(TEzColorBox)
  private
    FBaseProperty: TEzBaseProperty;
    FOnGoingOff: TGoingOffEvent;
    FRequireNotification: Boolean;
    Procedure CNKeydown( Var Message: TWMkeydown ); Message CN_KEYDOWN;
    Procedure CMEnter( Var Message: TCMEnter ); Message CM_ENTER;
    Procedure CMExit( Var Message: TCMExit ); Message CM_EXIT;
    Procedure TriggerGoingOffEvent( Reason: TGoingOffReason;
      Var AllowExit: Boolean );
    procedure DoChange;
  {$IFDEF BCB} (*_*)
    function GetOnGoingOff: TGoingOffEvent;
    procedure SetOnGoingOff(const Value: TGoingOffEvent);
  {$ENDIF}
  public
    constructor Create(AOwner: TComponent); Override;
    Procedure GoOff;
    Property OnGoingOff: TGoingOffEvent
      Read {$IFDEF BCB} GetOnGoingOff {$ELSE} FOnGoingOff {$ENDIF}
      Write {$IFDEF BCB} SetOnGoingOff{$ELSE} FOnGoingOff {$ENDIF} ; (*_*)
  end;


  TInplaceBrushstyleBox = class(TEzBrushPatternGridBox)
  private
    FBaseProperty: TEzBaseProperty;
    FOnGoingOff: TGoingOffEvent;
    FRequireNotification: Boolean;
    Procedure CNKeydown( Var Message: TWMkeydown ); Message CN_KEYDOWN;
    Procedure CMEnter( Var Message: TCMEnter ); Message CM_ENTER;
    Procedure CMExit( Var Message: TCMExit ); Message CM_EXIT;
    Procedure TriggerGoingOffEvent( Reason: TGoingOffReason;
      Var AllowExit: Boolean );
    procedure DoChange;
  {$IFDEF BCB} (*_*)
    function GetOnGoingOff: TGoingOffEvent;
    procedure SetOnGoingOff(const Value: TGoingOffEvent);
  {$ENDIF}
  public
    constructor Create(AOwner: TComponent); Override;
    Procedure GoOff;
    Property OnGoingOff: TGoingOffEvent
      Read {$IFDEF BCB} GetOnGoingOff {$ELSE} FOnGoingOff {$ENDIF}
      Write {$IFDEF BCB} SetOnGoingOff{$ELSE} FOnGoingOff {$ENDIF} ; (*_*)
  end;


  TInplaceLinetypeBox = class(TEzLinetypeGridBox)
  private
    FBaseProperty: TEzBaseProperty;
    FOnGoingOff: TGoingOffEvent;
    FRequireNotification: Boolean;
    Procedure CNKeydown( Var Message: TWMkeydown ); Message CN_KEYDOWN;
    Procedure CMEnter( Var Message: TCMEnter ); Message CM_ENTER;
    Procedure CMExit( Var Message: TCMExit ); Message CM_EXIT;
    Procedure TriggerGoingOffEvent( Reason: TGoingOffReason;
      Var AllowExit: Boolean );
    procedure DoChange;
  {$IFDEF BCB} (*_*)
    function GetOnGoingOff: TGoingOffEvent;
    procedure SetOnGoingOff(const Value: TGoingOffEvent);
  {$ENDIF}
  public
    constructor Create(AOwner: TComponent); Override;
    Procedure GoOff;
    Property OnGoingOff: TGoingOffEvent
      Read {$IFDEF BCB} GetOnGoingOff {$ELSE} FOnGoingOff {$ENDIF}
      Write {$IFDEF BCB} SetOnGoingOff{$ELSE} FOnGoingOff {$ENDIF} ; (*_*)
  end;

  { TEzPropertyList }

  TEzPropertyList = Class
  Private
    FList: TList;
    Function Get( Index: Integer ): TEzBaseProperty;
    procedure Put(Index: Integer; const Value: TEzBaseProperty);
  Public
    Constructor Create;
    destructor Destroy; Override;
    Function Add( Item: TEzBaseProperty ): Integer;
    Procedure Clear;
    Procedure ReplaceByIndex(Index : Integer; p : TEzBaseProperty);
    Procedure Delete( Index: Integer );
    Procedure Insert( Index: Integer; Value: TEzBaseProperty );
    Function Count: Integer;
    Function Remove( Item: TEzBaseProperty ): Integer;
    Function Indexof( Item: TEzBaseProperty ): Integer;
    Function IndexofName( const Value: string ): Integer;
    procedure Exchange(Index1, Index2: Integer);
    Procedure SortByName;

    Property Items[Index: Integer]: TEzBaseProperty Read Get Write Put; Default;
  End;

  { TEzInspector }

  TEzInspectorProvider = class;

  TEzBeforePropertyEvent = Procedure (Sender: TObject; const PropertyName: string;
    var CanShow, ReadOnly: Boolean ) Of Object;

  TEzPropertyChangeEvent = Procedure (Sender: TObject; const PropertyName: string) Of Object;

  TEzInspector = class(TCustomGrid)
  private
    FInplaceComboBox      : TInplaceComboBox;
    FInplaceEdit          : TInplaceEdit;
    FInplaceNumEd         : TInplaceNumEd;
    FInplaceSymbolsBox    : TInplaceSymbolsBox;
    FInplaceBlocksBox     : TInplaceBlocksBox;
    FInplaceColorBox      : TInplaceColorBox;
    FInplaceBrushstyleBox : TInplaceBrushstyleBox;
    FInplaceLinetypeBox   : TInplaceLinetypeBox;
    FInplaceDateTimePicker: TInplaceDateTimePicker;
    FButton               : TSpeedButton;
    FPropertyList         : TEzPropertyList;
    FTitleCaptions        : TStrings;
    FLastRow              : Integer;
    FFontReadOnly         : TFont;
    FFontModified         : TFont;
    FInColChange          : Boolean;
    FButtonWidth          : Integer;
    FSettingHeight        : Boolean;
    FPlusBitmap           : TBitmap;
    FMinusBitmap          : TBitmap;
    FReadOnlyBackColor    : TColor;

    FOnBeforeProperty     : TEzBeforePropertyEvent;
    FOnPropertyChange     : TEzPropertyChangeEvent;
    FOnPropertyHint       : TEzPropertyChangeEvent;
    procedure InPlaceEditGoingOff(Sender: TObject; Reason: TGoingOffReason;
      var AllowExit: Boolean);
    procedure EllipsisButtonClick(Sender: TObject);
    procedure PropertyChanged(Sender: TObject);
    procedure WMHScroll(var Msg: TWMHScroll); message WM_HSCROLL;
    procedure WMVScroll(var Msg: TWMVScroll); message WM_VSCROLL;
    procedure SetFontModified(const Value: TFont);
    procedure SetFontReadOnly(const Value: TFont);
    Procedure SetButtonWidth( Value: Integer );
    Procedure SetButtonGlyph;
    procedure CMShowingChanged(var Message: TMessage); message CM_SHOWINGCHANGED;
    Function  GetPropertyByRow(ARow : Integer) : TEzBaseProperty;
    Function  GetRowCount : Integer;
    Function  GetPropertyRow(Sender : TObject) : Integer;
    procedure SetReadOnlyBackColor(const Value: TColor);
    procedure SetTitleCaptions(const Value: TStrings);
  protected
    procedure MouseDown(Button: TMouseButton; Shift: TShiftState;
      X, Y: Integer); override;
    procedure KeyDown(var Key: Word; Shift: TShiftState); override;
    procedure DrawCell(ACol, ARow: Longint; ARect: TRect;
      AState: TGridDrawState); override;
    procedure ColWidthsChanged; override;
    procedure RowHeightsChanged; Override;
    procedure TopLeftChanged; override;
    procedure DblClick; Override;
    procedure Loaded; Override;
    procedure Resize; Override;
  public
    constructor Create(AOwner: TComponent); Override;
    destructor Destroy; override;
    procedure ClearPropertyList;
    function SelectCell(ACol, ARow: Longint): Boolean; override;
    Procedure AddProperty( BaseProperty: TEzBaseProperty );
    function GetPropertyByName(const Value: string): TEzBaseProperty;
    procedure ReplaceProperty( const Value: string; p: TEzBaseProperty );
    procedure ReplacePropertyByIndex( Index: Integer; p: TEzBaseProperty );
    procedure SetModifiedStatus(Value: Boolean);
    Procedure TurnOffEditor;
    Function PropertyCount: Integer;
    procedure AdjustColWidths;
    procedure InsertProperty(Index: Integer; BaseProperty: TEzBaseProperty);
    procedure DeletePropertyByIndex(Index: Integer);
    procedure DeletePropertyByName(const Value: String);
    procedure RemoveProperty(p: TEzBaseProperty);
    procedure RemoveFromProvider(pl: TEzInspectorProvider);
    procedure AdjustRows;
    Procedure FullExpand;
    Procedure FullCompact;

    Property PropList: TEzPropertyList read FPropertyList;

    property ColWidths;
    property Row;
    property RowCount;
    property Col;
    property ColCount;
    property RowHeights;
    property LeftCol;
    property TopRow;

  published
    property ButtonWidth: Integer read FButtonWidth write SetButtonWidth;
    property FontReadOnly : TFont read FFontReadOnly write SetFontReadOnly;
    property FontModified : TFont read FFontModified write SetFontModified;
    property TitleCaptions: TStrings read FTitleCaptions write SetTitleCaptions;
    property ReadOnlyBackColor: TColor read FReadOnlyBackColor write SetReadOnlyBackColor default clGray;

    property OnBeforeProperty: TEzBeforePropertyEvent read FOnBeforeProperty Write FOnBeforeProperty;
    property OnPropertyChange: TEzPropertyChangeEvent read FOnPropertyChange write FOnPropertyChange;
    property OnPropertyHint: TEzPropertyChangeEvent read FOnPropertyHint write FOnPropertyHint;

    property Align;
    property Anchors;
    property BiDiMode;
    property BorderStyle;
    property Color;
    property Constraints;
    property Ctl3D;
    property DefaultColWidth;
    property DefaultRowHeight;
    property DragCursor;
    property DragKind;
    property DragMode;
    property Enabled;
    property FixedColor;
    property Font;
    property GridLineWidth;
    property ParentBiDiMode;
    property ParentColor;
    property ParentCtl3D;
    property ParentFont;
    property ParentShowHint;
    property PopupMenu;
    property ScrollBars;
    property ShowHint;
    property TabOrder;
    property TabStop;
    property Visible;
    property VisibleColCount;
    property VisibleRowCount;
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
    property OnMouseWheelDown;
    property OnMouseWheelUp;
    property OnStartDock;
    property OnStartDrag;
  end;

  TEzPropertyType = ( ptString, ptFloat, ptInteger, ptBoolean, ptDate );

  TEzBaseProperty = class(TObject)
  Private
    FParent: TEzBaseProperty;  { who is the parent of this property }
    FPropName: string;
    FPropType: TEzPropertyType;
    FUseEditButton: Boolean;
    FValString: string;
    FValFloat: Double;
    FValInteger: Integer;
    FValBoolean: Boolean;
    FValDateTime: TDateTime;
    FModified: Boolean;
    FReadOnly: Boolean;
    FHint: string;
    FIsPropertyOfList: Boolean;

    FOnChange: TNotifyEvent;
    procedure SetValBoolean(const Value: Boolean);
    procedure SetValFloat(const Value: Double);
    procedure SetValInteger(const Value: Integer);
    procedure SetValString(const Value: string);
    procedure SetValDatetime(const Value: TDateTime);
  Public
    constructor Create( const PropName: string ); virtual;
    { this method is fired when the ellipsis button is clicked }
    Procedure Edit(Inspector: TEzInspector); Dynamic;
    Procedure ShowEditor(Inspector: TEzInspector; ARect: TRect); Dynamic;
    function AsString: string; Dynamic;
    Procedure Draw(Canvas: TCanvas; ARect: TRect; AState: TGridDrawState); Dynamic;
    Procedure Changed;
    Function IndentLevel: Integer;

    Property PropType: TEzPropertyType read FPropType write FPropType;
    Property PropName: string read FPropName write FPropName;
    property UseEditButton: Boolean read FUseEditButton write FUseEditButton;
    property ValString: string read FValString write SetValString;
    property ValFloat: Double read FValFloat write SetValFloat;
    property ValInteger: Integer read FValInteger write SetValInteger;
    property ValBoolean: Boolean read FValBoolean write SetValBoolean;
    property ValDatetime: TDateTime read FValDatetime write SetValDatetime;
    property Modified: Boolean read FModified write FModified;
    property ReadOnly: Boolean read FReadOnly write FReadOnly;
    property Hint: string read FHint write FHint;
    property IsPropertyOfList: Boolean Read FIsPropertyOfList Write FIsPropertyOfList;
    property Parent: TEzBaseProperty read FParent write FParent;

    property OnChange: TNotifyEvent read FOnChange write FOnChange;
  End;

  TEzBasePropertyClass = Class Of TEzBaseProperty;

  TEzTreeViewProperty = Class( TEzBaseProperty )
  Private
    FPropertyList : TEzPropertyList;
    FExpanded : Boolean;
    function GetPropertyList: TEzPropertyList;
    function GetExpanded: Boolean;
    procedure SetExpanded(const Value: Boolean);
    procedure RecurseFullExpand( Value: Boolean );
  Public
    Constructor Create(Const PropName : String); Override;
    Destructor Destroy; Override;
    Procedure AddProperty(BaseProperty : TEzBaseProperty);
    Procedure FullExpand;
    Procedure FullCompact;

    property PropertyList : TEzPropertyList Read GetPropertyList;
    property Expanded : Boolean Read GetExpanded Write SetExpanded;
  End;

  TEzBooleanProperty = class(TEzBaseProperty)
  public
    constructor Create( const PropName: string ); Override;
    //Procedure ShowEditor(Inspector: TEzInspector; ARect: TRect); Override;
    Procedure Draw(Canvas: TCanvas; ARect: TRect; AState: TGridDrawState); override;
  end;

  TEzIntegerProperty = class(TEzBaseProperty)
  private
    FDummyNumEd: TEzNumEd;
    function GetDecimals: Integer;
    function GetDigits: Integer;
    procedure SetDecimals(Value:Integer);
    procedure SetDigits(Value:Integer);
  public
    constructor Create( const PropName: string ); Override;
    destructor Destroy; Override;
    Procedure ShowEditor(Inspector: TEzInspector; ARect: TRect); Override;
    Procedure Draw(Canvas: TCanvas; ARect: TRect; AState: TGridDrawState); Override;

    property Decimals: Integer read GetDecimals write SetDecimals;
    property Digits: Integer read GetDigits write SetDigits;
  end;

  TEzFloatProperty = class(TEzIntegerProperty)
  public
    constructor Create( const PropName: string ); Override;
    Procedure ShowEditor(Inspector: TEzInspector; ARect: TRect); Override;
  end;

  { angle is saved in radians and edited in degrees }
  TEzAngleProperty = class(TEzFloatProperty)
  public
    Procedure ShowEditor(Inspector: TEzInspector; ARect: TRect); Override;
    Procedure Draw(Canvas: TCanvas; ARect: TRect; AState: TGridDrawState); Override;
  end;

  TEzColorProperty = class(TEzBaseProperty)
  private
    FCaption: string;
    FCustomText: string;
    FNoneColorText: string;
    FShowSystemColors: Boolean;
    function GetCaption: string;
    function GetCustomText: string;
    function GetNoneColorText: string;
    procedure SetCaption(const Value: string);
    procedure SetCustomText(const Value: string);
    procedure SetNoneColorText(const Value: string);
    function GetShowSystemColors: Boolean;
    procedure SetShowSystemColors(const Value: Boolean);
  public
    constructor Create( const PropName: string ); Override;
    Procedure ShowEditor(Inspector: TEzInspector; ARect: TRect); Override;
    Procedure Draw(Canvas: TCanvas; ARect: TRect; AState: TGridDrawState); Override;

    Property Caption: string read GetCaption write SetCaption;
    Property CustomText: string read GetCustomText write SetCustomText;
    Property NoneColorText: string read GetNoneColorText write SetNoneColorText;
    Property ShowSystemColors: Boolean read GetShowSystemColors write SetShowSystemColors;
  end;

  TEzStringProperty = class(TEzBaseProperty)
  public
    constructor Create( const PropName: string ); Override;
    Procedure ShowEditor(Inspector: TEzInspector; ARect: TRect); Override;
  end;

  TEzLongTextProperty = class(TEzStringProperty)
  public
    constructor Create( const PropName: string ); Override;
    procedure Edit(Inspector: TEzInspector); Override;
  end;

  TEzSelectFolderProperty= class(TEzStringProperty)
  public
    constructor Create( const PropName: string ); Override;
    Procedure Edit(Inspector: TEzInspector); Override;
  end;

  TEzExpressionProperty= class(TEzStringProperty)
  private
    FGis: TEzBaseGis;
    FLayerName: string;
  {$IFDEF BCB}
    function GetGis: TEzBaseGis;
    function GetLayerName: string;
    procedure SetGis(const Value: TEzBaseGis);
    procedure SetLayerName(const Value: string);
  {$ENDIF}
  public
    constructor Create( const PropName: string ); Override;
    Procedure Edit(Inspector: TEzInspector); Override;

    Property GIS: TEzBaseGis {$IFDEF BCB} read GetGis write SetGis {$ELSE} read FGis write FGis {$ENDIF};
    Property LayerName: string {$IFDEF BCB} read GetLayerName write SetLayerName {$ELSE} read FLayerName write FLayerName {$ENDIF};
  end;

  TEzDateProperty = class(TEzBaseProperty)
  public
    constructor Create( const PropName: string ); Override;
    Procedure ShowEditor(Inspector: TEzInspector; ARect: TRect); Override;
  end;

  TEzTimeProperty = class(TEzBaseProperty)
  public
    constructor Create( const PropName: string ); Override;
    Procedure ShowEditor(Inspector: TEzInspector; ARect: TRect); Override;
  end;

  TEzDummyProperty = class(TEzBaseProperty)
  public
    constructor Create( const PropName: string ); Override;
  end;

  TEzMemoProperty = class(TEzBaseProperty)
  private
    FDBTable: TEzBaseTable;
    FFieldNo: Integer;
  {$IFDEF BCB}
    function GetDBTable: TEzBaseTable;
    function GetFieldNo: Integer;
    procedure SetDBTable(const Value: TEzBaseTable);
    procedure SetFieldNo(const Value: Integer);
  {$ENDIF}
  public
    constructor Create( const PropName: string ); Override;
    function AsString: string; Override;
    procedure Edit(Inspector: TEzInspector); Override;

    property DBTable: TEzBaseTable {$IFDEF BCB} read GetDBTable write SetDBTable {$ELSE} read FDBTable write FDBTable {$ENDIF};
    property FieldNo: Integer {$IFDEF BCB} read GetFieldNo write SetFieldNo {$ELSE} read FFieldNo write FFieldNo {$ENDIF};
  end;

  TEzGraphicProperty = class(TEzBaseProperty)
  private
    FDBTable: TEzBaseTable;
    FFieldNo: Integer;
  {$IFDEF BCB}
    function GetDBTable: TEzBaseTable;
    function GetFieldNo: Integer;
    procedure SetDBTable(const Value: TEzBaseTable);
    procedure SetFieldNo(const Value: Integer);
  {$ENDIF}
  public
    constructor Create( const PropName: string ); Override;
    function AsString: string; Override;
    procedure Edit(Inspector: TEzInspector); Override;

    property DBTable: TEzBaseTable
      {$IFDEF BCB} read GetDBTable write SetDBTable
      {$ELSE} read FDBTable write FDBTable {$ENDIF};
    property FieldNo: Integer
      {$IFDEF BCB} read GetFieldNo write SetFieldNo
      {$ELSE} read FFieldNo write FFieldNo {$ENDIF};
  end;

  TEzSetProperty = class( TEzTreeViewProperty )
  private
    FStrings: TStrings;
    function GetDefined(Index: Integer): boolean;
    procedure SetDefined(Index: Integer; value:boolean);
    procedure StringsChanged( Sender: TObject );
    procedure ThisChanged( Sender: TObject );
  {$IFDEF BCB}
    function GetStrings: TStrings;
  {$ENDIF}
  public
    constructor Create( const PropName: string ); Override;
    destructor Destroy; Override;
    function AsString: string; Override;

    property Strings: TStrings {$IFDEF BCB} read GetStrings {$ELSE} read FStrings {$ENDIF};
    Property Defined[Index: Integer]: Boolean read GetDefined write SetDefined;
  end;

  TEzPointsProperty = class(TEzBaseProperty)
  private
    FVector: TEzVector;
    procedure SetVector(const Value: TEzVector);
  {$IFDEF BCB}
    function GetVector: TEzVector;
  {$ENDIF}
  public
    constructor Create( const PropName: string ); Override;
    destructor Destroy; Override;
    function AsString: string; Override;
    procedure Edit(Inspector: TEzInspector); Override;

    property Vector: TEzVector {$IFDEF BCB}read GetVector {$ELSE} read FVector {$ENDIF} write SetVector;
  end;

  TEzDefineLocalBitmapProperty = class(TEzStringProperty)
  public
    constructor Create( const PropName: string ); Override;
    Procedure Edit(Inspector: TEzInspector); Override;
  end;

  TEzDefineAnyLocalImageProperty = class(TEzStringProperty)
  public
    constructor Create( const PropName: string ); Override;
    Procedure Edit(Inspector: TEzInspector); Override;
  end;

  TEzFontNameProperty = class(TEzBaseProperty)
  private
    FTrueType: Boolean;
  {$IFDEF BCB}
    function GetTrueType: Boolean;
    procedure SetTrueType(const Value: Boolean);
  {$ENDIF}
  public
    constructor Create( const PropName: string ); Override;
    Procedure ShowEditor(Inspector: TEzInspector; ARect: TRect); Override;

    property TrueType: Boolean
      {$IFDEF BCB} read GetTrueType write SetTrueType
      {$ELSE} read FTrueType write FTrueType {$ENDIF};
  end;

  TEzSymbolProperty = class(TEzBaseProperty)
  public
    constructor Create( const PropName: string ); Override;
    Procedure ShowEditor(Inspector: TEzInspector; ARect: TRect); Override;
    Procedure Draw(Canvas: TCanvas; ARect: TRect; AState: TGridDrawState);Override;
  end;

  TEzBlocksProperty = class(TEzBaseProperty)
  public
    constructor Create( const PropName: string ); Override;
    Procedure ShowEditor(Inspector: TEzInspector; ARect: TRect); Override;
    Procedure Draw(Canvas: TCanvas; ARect: TRect; AState: TGridDrawState); Override;
  end;

  TEzBrushstyleProperty = class(TEzBaseProperty)
  public
    constructor Create( const PropName: string ); Override;
    Procedure ShowEditor(Inspector: TEzInspector; ARect: TRect); Override;
    Procedure Draw(Canvas: TCanvas; ARect: TRect; AState: TGridDrawState); Override;
  end;

  TEzLinetypeProperty = class(TEzBaseProperty)
  public
    constructor Create( const PropName: string ); Override;
    Procedure ShowEditor(Inspector: TEzInspector; ARect: TRect); Override;
    Procedure Draw(Canvas: TCanvas; ARect: TRect; AState: TGridDrawState); Override;
  end;

  TEzBitmapProperty = class(TEzBaseProperty)
  private
    FBitmap: TBitmap;
  {$IFDEF BCB}
    function GetBitmap: TBitmap;
  {$ENDIF}
  public
    constructor Create( const PropName: string ); Override;
    destructor Destroy; override;
    Procedure Edit(Inspector: TEzInspector); Override;
    function AsString: string; Override;

     property Bitmap: TBitmap {$IFDEF BCB} read GetBitmap {$ELSE} read FBitmap {$ENDIF};
  end;

  TEzEnumerationProperty = class(TEzBaseProperty)
  private
    FStrings: TStrings;
  {$IFDEF BCB}
    function GetStrings: TStrings;
  {$ENDIF}
  public
    constructor Create( const PropName: string ); Override;
    destructor Destroy; Override;
    Procedure ShowEditor(Inspector: TEzInspector; ARect: TRect); Override;
    function AsString: string; Override;

    property Strings: TStrings {$IFDEF BCB} read GetStrings {$ELSE} read FStrings {$ENDIF};
  end;

  { TBrowseForFolder }

  _exData=record
  Path:PChar;
  Caption:PChar;
  end;

  TBrowseFlag = ( bf_BrowseForComputer, bf_BrowseForPrinter, bf_DontGoBelowDomain,
    bf_statustext, bf_ReturnFSanceStors, bf_ReturnOnlyFSDIRS, bf_EditBox);
  TBrowseFlags = set of TBrowseFlag;

  TBrowseLocation= (bl_STANDART, bl_CUSTOM, bl_DESKTOP, bl_PROGRAMS, bl_CONTROLS,
  bl_PRINTERS, bl_PERSONAL, bl_FAVORITES, bl_STARTUP, bl_RECENT, bl_SENDTO,
  bl_BITBUCKET, bl_STARTMENU, bl_DESKTOPDIRECTORY, bl_DRIVES, bl_NETWORK,
  bl_NETHOOD, bl_FONTS, bl_TEMPLATES, bl_COMMON_STARTMENU, bl_COMMON_PROGRAMS,
  bl_COMMON_STARTUP, bl_COMMON_DESKTOPDIRECTORY, bl_APPDATA, bl_PRINTHOOD);

  TBrowseForFolder = class(TComponent)
  private
    FBrowseInfo:TBrowseInfo;
    FRoot:PItemIDList;
    FDisplayName:String;
    FStatusText:String;
    FFolderName:String;
    FORoot:TBrowseLocation;
    FCaption: String;
    { Private declarations }
    procedure SetFlags( Value :TBrowseFlags );
    function GetFlags :TBrowseFlags;
    function GetOperFlag( F :Cardinal ) :Boolean;
    procedure SetOperFlag( F :Cardinal; V :Boolean );
    procedure SetCaption(const Value: String);
  public
    { Public declarations }
    _inData:_exData;
    constructor Create( anOwner :TComponent ); override;
    function Execute :Boolean;
    procedure SetRoot(Root:PItemIdList);
    procedure SetFunction(tF:TFNBFFCallBack);
    procedure SetLParam(Param:LParam);
  published
    { Published declarations }
    property DisplayName:String read FDisplayName;
    property StatusText:String read FStatusText write FStatusText;
    property FolderName:String read FFolderName write FFolderName;
    property Flags :TBrowseFlags read GetFlags  write SetFlags stored true;
    property Root:TBrowseLocation read FoRoot write FoRoot;
    property Caption:String read FCaption write SetCaption;
  end;

//------------------------------TEzInspectorProvider------------------------

  TPopulateAction = (epaDisplayOnlyThis, epaAdding, epaInsert, epaOverWrite);

  TCreateAction = (caClone, caCreate);

  TEzPropertyTypeC = (eptAngle, eptBitmap, eptBlocks, eptBoolean, eptBrushstyle,
                     eptColor, eptDate, eptDefineAnyLocalImage, eptDefineLocalBitmap,
                     eptDummy, eptEnumeration, eptExpression,
                     eptFloat, eptFontName, eptGraphic, eptInteger, eptLinetype,
                     eptLongText, eptMemo, eptPoints, eptSelectFolder, eptSet, eptString,
                     eptSymbol, eptTime);

  TEzPropertyItem = class;

  TEzBooleanCollectionItem = class(TCollectionItem)
  private
    function GetValue: Boolean;
    procedure SetValue(const Value: Boolean);
    procedure SetString(const Value: String);
    function GetString: String;
  Protected
    Function GetDisplayName : String; Override;
  Public
    Constructor Create(AOwner : TCollection); Override;
    Destructor  Destroy; Override;
    Procedure Assign(Source : TPersistent); Override;
  Published
    Property Defined : Boolean Read GetValue Write SetValue;
    Property Strings : String Read GetString Write SetString;
  End;

  TEzBooleanCollection = class(TOwnedCollection)
  Private
    PropertyItem : TEzPropertyItem;
    function GetItem(Index: Integer): TEzBooleanCollectionItem;
    procedure SetItem(Index: Integer; const Value: TEzBooleanCollectionItem);
  Public
    Constructor Create(AOwner : TPersistent);
    Procedure CheckBounds;
    Property Items[Index : Integer] : TEzBooleanCollectionItem Read GetItem Write SetItem;
  End;

  TEzPropertyItem = class(TCollectionItem)
  private
    FBaseProperty : TEzBaseProperty;
    FSetEnumCollection : TEzBooleanCollection;
    function GetFValBoolean: Boolean;
    function GetFValDateTime: TDateTime;
    function GetFValFloat: Double;
    function GetFValInteger: Integer;
    function GetPropertyName: string;
    function GetPropertyValue: string;
    function GetValString: String;
    function GetPropertyType: TEzPropertyTypeC;
    procedure SetPropertyName(const Value: string);
    procedure SetPropertyType(const Value: TEzPropertyTypeC);
    procedure SetPropertyValue(const Value: string);
    procedure SetValBoolean(const Value: Boolean);
    procedure SetValDateTime(const Value: TDateTime);
    procedure SetValFloat(const Value: Double);
    procedure SetValInteger(const Value: Integer);
    procedure SetValString(const Value: String);
    procedure SetBaseProperty(const Value: TEzBaseProperty);
    function GetTrueType: Boolean;
    procedure SetTrueType(const Value: Boolean);
    function GetStrings: TEzBooleanCollection;
    procedure SetStrings(const Value: TEzBooleanCollection);
    function GetReadOnly: Boolean;
    function GetUseEdit: Boolean;
    procedure SetReadOnly(const Value: Boolean);
    procedure SetUseEdit(const Value: Boolean);
  protected
    Function GetDisplayName: String; Override;
  public
    Constructor Create(Collection : TCollection); Override;
    Destructor  Destroy; Override;
    Procedure UpdateSetEnum;
    Procedure Assign( Source: TPersistent ); Override;

    property ValString : String Read GetValString Write SetValString;
    property ValInteger : Integer Read GetFValInteger Write SetValInteger;
    property ValFloat : Double Read GetFValFloat Write SetValFloat;
    property ValBoolean : Boolean Read GetFValBoolean Write SetValBoolean;
    property ValDateTime : TDateTime Read GetFValDateTime Write SetValDateTime;
    Property BaseProperty : TEzBaseProperty Read FBaseProperty Write SetBaseProperty;
  published
    property PropertyType: TEzPropertyTypeC read GetPropertyType write SetPropertyType Stored True;
    property PropertyName: string read GetPropertyName write SetPropertyName stored True;
    property PropertyValue: string read GetPropertyValue write SetPropertyValue stored True;
    property IsReadOnly : Boolean Read GetReadOnly Write SetReadOnly stored True;
    property UseEditButton : Boolean Read GetUseEdit Write SetUseEdit Stored True;
    property TrueType : Boolean Read GetTrueType Write SetTrueType stored True;
    property Strings : TEzBooleanCollection Read GetStrings Write SetStrings Stored True;
//    property Strings : TStrings Read GetStrings Write SetStrings Stored True;
  end;

  TEzPropertyCollection = class(TOwnedCollection)
  private
    FInspectorProvider: TEzInspectorProvider;
    function GetItem(Index: Integer): TEzPropertyItem;
    procedure SetItem(Index: Integer; const Value: TEzPropertyItem);
    function Add: TEzPropertyItem;
  public
    Constructor Create( AOwner: TPersistent );
    Destructor Destroy; Override;
    Procedure AddProperty(p: TEzBaseProperty);
    Procedure Insert(Index: Integer; p: TEzBaseProperty);
    Procedure ReplaceByIndex(Index: Integer; p: TEzBaseProperty);
    Procedure PopulateTo(Inspector: TEzInspector;
      Action: TPopulateAction; Index : Integer = 0);
    Procedure ExChange(Index1, Index2: Integer);
    Function  IndexOfName(const PropName: String) : Integer;
    Function  IndexOfProperty(p : TEzBaseProperty) : Integer;
    Property Items[Index: Integer]: TEzPropertyItem read GetItem write SetItem; Default;
  end;

  TEzInspectorProvider = class(TComponent)
  private
    FPropertyList: TEzPropertyCollection;
    function GetItem(Index: Integer): TEzBaseProperty;
    procedure SetItem(Index: Integer; const Value: TEzBaseProperty);
    function GetItemsCount: Integer;
    procedure SetPropertyList(const Value: TEzPropertyCollection);
  Public
    Constructor Create(AOwner : TComponent); Override;
    Destructor  Destroy; Override;
    Procedure PopulateTo(Inspector: TEzInspector; Action: TPopulateAction; Index : Integer = 0);
    Procedure Clear;
    Procedure Add(p: TEzBaseProperty);
    Procedure Delete(Index: Integer);
    Procedure Insert(Index : Integer; p : TEzBaseProperty);
    Procedure ReplaceByIndex(Index : Integer; p : TEzBaseProperty);
    Procedure RemoveFrom(Inspector : TEzInspector);
    Procedure ExChange(Index1, Index2: Integer);
    Function  IndexOfName(const PropName: String) : Integer;
    Function  IndexOfProperty(p : TEzBaseProperty) : Integer;
    Property Items[Index : Integer] : TEzBaseProperty Read GetItem Write SetItem;
    Property ItemsCount : Integer Read GetItemsCount;
    Property PropertyList: TEzPropertyCollection read FPropertyList Write SetPropertyList Stored True;
  end;

Function PropertyTypeOf(BaseProperty: TEzBaseProperty): TEzPropertyTypeC;
function BrowseCallbackProc(dhwnd:HWND; uMsg:longint; lParam:longint;
  lpData:longint): Integer; stdcall;

implementation

uses
  Math, ExtCtrls, ezsystem, ezlinedraw, EzGraphics, ezconsts,
  fMemoEditor, fExpress, EzBaseExpr, EzExprLex, EzExprYacc, EzLexLib,
  EzYaccLib, EzEntities, fPictureDef, EzActions;


function BrowseCallbackProc;
var
  sFName:^_exData;
begin
 case uMsg of
 BFFM_INITIALIZED:
    begin
      sFName:=pointer(lpData);
      if Length(sFName.Path)<>0 then
      SendMessage(dhwnd,BFFM_SETSELECTION ,1,integer(sfname.Path));
      if Length(sFName.Caption)<>0 then
       SendMessage(dhwnd,BFFM_SETSTATUSTEXT ,1,integer(sfname.Caption));
    end;
 BFFM_VALIDATEFAILED:
  begin
   result:=1;
   exit;
  end;
 end;
 result:=0;
end;

constructor TBrowseForFolder.Create( anOwner :TComponent );
begin
   inherited Create( anOwner );
   FFolderName:=SBFFFolderName;
   FStatusText:=SBFFSTatusText;
   FCaption:=SBFFCaption;
end;

function TBrowseForFolder.Execute: Boolean;
var
  iGetRoot,Res:PItemIDList;
  sTemp:PChar;
begin
  FBrowseInfo.hwndOwner:=0;
  FBrowseInfo.lpszTitle:=PChar(FCaption);
  case foRoot of
    bl_CUSTOM:iGetRoot:=FRoot;
    bl_DESKTOP:shGetSpecialFolderLocation(0,CSIDL_DESKTOP ,iGetRoot);
    bl_PROGRAMS:shGetSpecialFolderLocation(0,CSIDL_PROGRAMS ,iGetRoot);
    bl_CONTROLS:shGetSpecialFolderLocation(0,CSIDL_CONTROLS ,iGetRoot);
    bl_PRINTERS:shGetSpecialFolderLocation(0,CSIDL_PRINTERS ,iGetRoot);
    bl_PERSONAL:shGetSpecialFolderLocation(0,CSIDL_PERSONAL ,iGetRoot);
    bl_FAVORITES:shGetSpecialFolderLocation(0,CSIDL_FAVORITES ,iGetRoot);
    bl_STARTUP:shGetSpecialFolderLocation(0,CSIDL_STARTUP ,iGetRoot);
    bl_RECENT:shGetSpecialFolderLocation(0,CSIDL_RECENT ,iGetRoot);
    bl_SENDTO:shGetSpecialFolderLocation(0,CSIDL_SENDTO ,iGetRoot);
    bl_BITBUCKET:shGetSpecialFolderLocation(0,CSIDL_BITBUCKET ,iGetRoot);
    bl_STARTMENU:shGetSpecialFolderLocation(0,CSIDL_STARTMENU ,iGetRoot);
    bl_DESKTOPDIRECTORY:shGetSpecialFolderLocation(0,CSIDL_DESKTOPDIRECTORY ,iGetRoot);
    bl_DRIVES:shGetSpecialFolderLocation(0,CSIDL_DRIVES ,iGetRoot);
    bl_NETWORK:shGetSpecialFolderLocation(0,CSIDL_NETWORK ,iGetRoot);
    bl_NETHOOD:shGetSpecialFolderLocation(0,CSIDL_NETHOOD ,iGetRoot);
    bl_FONTS:shGetSpecialFolderLocation(0,CSIDL_FONTS ,iGetRoot);
    bl_TEMPLATES:shGetSpecialFolderLocation(0,CSIDL_TEMPLATES ,iGetRoot);
    bl_COMMON_STARTMENU:shGetSpecialFolderLocation(0,CSIDL_COMMON_STARTMENU ,iGetRoot);
    bl_COMMON_PROGRAMS:shGetSpecialFolderLocation(0,CSIDL_COMMON_PROGRAMS ,iGetRoot);
    bl_COMMON_STARTUP:shGetSpecialFolderLocation(0,CSIDL_COMMON_STARTUP ,iGetRoot);
    bl_COMMON_DESKTOPDIRECTORY:shGetSpecialFolderLocation(0,CSIDL_COMMON_DESKTOPDIRECTORY ,iGetRoot);
    bl_APPDATA:shGetSpecialFolderLocation(0,CSIDL_APPDATA ,iGetRoot);
    bl_PRINTHOOD:shGetSpecialFolderLocation(0,CSIDL_PRINTHOOD ,iGetRoot);
  end;
  if  foRoot<>bl_STANDART then
    FBrowseInfo.pidlRoot:=iGetRoot;
  If Assigned(owner) Then
    FBrowseInfo.hwndOwner:=(owner as TForm).handle;
  FBrowseInfo.lpfn:=@BrowseCallbackProc;
  _inData.Path:=PChar(FFolderName);
  _inData.Caption:=PChar(FStatusText);
  FBrowseInfo.lParam:=integer(@_inData);
  FBrowseInfo.ulFlags:=FBrowseInfo.ulFlags or BIF_VALIDATE;
  GetMem(FBrowseInfo.pszDisplayName,255);
  res:=ShBrowseForFolder(FBrowseInfo);
  if res=nil then
    result:=false
  else
  begin
    result:=true;
    GetMem(sTemp,255);
    SHGetPathFromIDList(Res,sTemp);
    FFolderName:=sTemp;
    freemem(sTemp,255);
    FDisplayName:=FBrowseInfo.pszDisplayName;
  end;
  FreeMem(FBrowseInfo.pszDisplayName,255);
end;

procedure TBrowseForFolder.SetRoot;
begin
  FRoot:=Root;
end;

procedure TBrowseForFolder.SetFunction;
begin
  FBrowseInfo.lpfn:=tf;
end;

procedure TBrowseForFolder.SetLParam;
begin
  FBrowseInfo.lParam:=Param;
end;

procedure TBrowseForFolder.SetFlags( Value :TBrowseFlags );
begin
  SetOperFlag(BIF_BROWSEFORCOMPUTER,bf_BROWSEFORCOMPUTER in Value);
  SetOperFlag(BIF_BROWSEFORPRINTER,bf_BROWSEFORPRINTER in Value);
  SetOperFlag(BIF_DONTGOBELOWDOMAIN,bf_DONTGOBELOWDOMAIN in Value);
  SetOperFlag(BIF_RETURNFSANCESTORS,bf_RETURNFSANCESTORS in Value);
  SetOperFlag(BIF_RETURNONLYFSDIRS,bf_RETURNONLYFSDIRS in Value);
  SetOperFlag(BIF_EDITBOX,bf_Editbox in Value);
  SetOperFlag(BIF_STATUSTEXT,bf_statustext in value);
end;

function TBrowseForFolder.GetFlags;
begin
  result := [];
  if GetOperFlag(BIF_BROWSEFORCOMPUTER) then include( result,bf_BROWSEFORCOMPUTER);
  if GetOperFlag(BIF_BROWSEFORPRINTER) then include( result,bf_BROWSEFORPRINTER);
  if GetOperFlag(BIF_DONTGOBELOWDOMAIN) then include( result,bf_DONTGOBELOWDOMAIN);
  if GetOperFlag(BIF_RETURNFSANCESTORS) then include( result,bf_RETURNFSANCESTORS);
  if GetOperFlag(BIF_RETURNONLYFSDIRS) then include( result,bf_RETURNONLYFSDIRS);
  if GetOperFlag(BIF_EDITBOX) then include( result,bf_Editbox);
  if GetOperFlag(BIF_STATUSTEXT) then include( result,bf_StatusText);
end;

function TBrowseForFolder.GetOperFlag( F :Cardinal ):boolean;
begin
  result := ( FBrowseInfo.ulFlags and F ) <> 0;
end;

procedure TBrowseForFolder.SetOperFlag( F :Cardinal; V :Boolean );
begin
  with FBrowseInfo do
    if V then ulFlags := ulFlags or F else ulFlags := ulFlags and ( not F );
end;
procedure TBrowseForFolder.SetCaption(const Value: String);
begin
  FCaption := Value;
end;

{ FInplaceComboBox }

constructor TInplaceComboBox.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  //If Not ( csDesigning In ComponentState ) Then
  Visible := False;
  //BorderStyle:= bsNone;
end;

procedure TInplaceComboBox.CMEnter(var Message: TCMEnter);
begin
  Inherited;
  FRequireNotification := True;
end;

procedure TInplaceComboBox.CMExit(var Message: TCMExit);
Var
  allowExit: Boolean;
Begin
  Inherited;
  allowExit := True;
  If FRequireNotification = True Then
    TriggerGoingOffEvent( goNone, allowExit );
  If allowExit Then
  Begin
    DoChange;
    FRequireNotification := False;
    Visible := False;
  End
  Else
  Begin
    MessageBeep( $FFFF );
    Windows.SetFocus( Self.Handle );
  End;
end;

procedure TInplaceComboBox.CNKeydown(var Message: TWMkeydown);
Var
  allowExit: Boolean;
  reason: TGoingOffReason;
Begin
  allowExit := False;
  reason := goNone;
  With Message Do
  Begin
    Case CharCode Of
      VK_TAB:
        If ssShift In KeyDataToShiftState( KeyData ) Then
          reason := goLTab
        Else
          reason := goRTab;
      VK_RETURN:
        reason := goEnter;
      VK_ESCAPE:
        reason := goEscape;
      VK_UP:
        if not DroppedDown then
          reason := goUp;
      VK_DOWN:
        if not DroppedDown then
          reason := goDown;
      VK_LEFT:
        //If ssCtrl In KeyDataToShiftState(KeyData) Then
        reason := goLeft;
      VK_RIGHT:
        //If ssCtrl In KeyDataToShiftState(KeyData) Then
        reason := goRight;
      VK_HOME:
        //If ssCtrl In KeyDataToShiftState(KeyData) Then
        reason := goHome;
      VK_END:
        //If ssCtrl In KeyDataToShiftState(KeyData) Then
        reason := goEnd;
      VK_PRIOR:
        reason := goPgUp;
      VK_NEXT:
        reason := goPgDn;
    End;

    If reason <> goNone Then
    Begin
      allowExit := True;
      TriggerGoingOffEvent( reason, allowExit );
    End;
    If allowExit Then
    Begin
      DoChange;
      FRequireNotification := False;
      If reason <> goNone Then
        Message.Result := 1; {to avoid beep on Return }
      If reason = goEscape Then
        MessageBeep( $FFFF );
      Visible := False;
      Windows.SetFocus( Parent.Handle );
    End
    Else
    Begin
      If reason <> goNone Then
        MessageBeep( $FFFF );
      exit;
    End;
  End;
end;

procedure TInplaceComboBox.GoOff;
begin
  FRequireNotification := False;
  Visible := False;
  Windows.SetFocus( Parent.Handle );
end;

procedure TInplaceComboBox.TriggerGoingOffEvent(Reason: TGoingOffReason;
  var AllowExit: Boolean);
begin
  If Assigned( FOnGoingOff ) Then
    FOnGoingOff( Self, Reason, AllowExit );
end;

procedure TInplaceComboBox.DoChange;
begin
  if FBaseProperty.FPropType = ptInteger then
    FBaseProperty.ValInteger:= Self.ItemIndex
  else if FBaseProperty.FPropType = ptString then
  begin
    if Self.ItemIndex >= 0 then
      FBaseProperty.ValString:= Self.Items[Self.ItemIndex];
  end;
end;

procedure TInplaceComboBox.Change;
begin
  inherited;
  DoChange;
end;

{$IFDEF BCB}
function TInplaceComboBox.GetOnGoingOff: TGoingOffEvent;
begin
  Result := FOnGoingOff;
end;

procedure TInplaceComboBox.SetOnGoingOff(const Value: TGoingOffEvent);
begin
  FOnGoingOff := Value;
end;
{$ENDIF}


{ TInplaceSymbolsBox }

constructor TInplaceSymbolsBox.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  //If Not ( csDesigning In ComponentState ) Then
  Visible := False;
  BorderStyle:= bsNone;
  Color:= clBtnFace;
end;

procedure TInplaceSymbolsBox.CMEnter(var Message: TCMEnter);
begin
  Inherited;
  FRequireNotification := True;
end;

procedure TInplaceSymbolsBox.CMExit(var Message: TCMExit);
Var
  allowExit: Boolean;
Begin
  Inherited;
  allowExit := True;
  If FRequireNotification = True Then
    TriggerGoingOffEvent( goNone, allowExit );
  If allowExit Then
  Begin
    DoChange;
    FRequireNotification := False;
    Visible := False;
  End
  Else
  Begin
    MessageBeep( $FFFF );
    Windows.SetFocus( Self.Handle );
  End;
end;

procedure TInplaceSymbolsBox.CNKeydown(var Message: TWMkeydown);
Var
  allowExit: Boolean;
  reason: TGoingOffReason;
Begin
  allowExit := False;
  reason := goNone;
  With Message Do
  Begin
    Case CharCode Of
      VK_TAB:
        If ssShift In KeyDataToShiftState( KeyData ) Then
          reason := goLTab
        Else
          reason := goRTab;
      VK_RETURN:
        reason := goEnter;
      VK_ESCAPE:
        reason := goEscape;
      VK_UP:
        if not DroppedDown then
          reason := goUp;
      VK_DOWN:
        if not DroppedDown then
          reason := goDown;
      VK_LEFT:
        //If ssCtrl In KeyDataToShiftState(KeyData) Then
        reason := goLeft;
      VK_RIGHT:
        //If ssCtrl In KeyDataToShiftState(KeyData) Then
        reason := goRight;
      VK_HOME:
        //If ssCtrl In KeyDataToShiftState(KeyData) Then
        reason := goHome;
      VK_END:
        //If ssCtrl In KeyDataToShiftState(KeyData) Then
        reason := goEnd;
      VK_PRIOR:
        reason := goPgUp;
      VK_NEXT:
        reason := goPgDn;
    End;

    If reason <> goNone Then
    Begin
      allowExit := True;
      TriggerGoingOffEvent( reason, allowExit );
    End;
    If allowExit Then
    Begin
      DoChange;
      FRequireNotification := False;
      If reason <> goNone Then
        Message.Result := 1; {to avoid beep on Return }
      If reason = goEscape Then
        MessageBeep( $FFFF );
      Visible := False;
      Windows.SetFocus( Parent.Handle );
    End
    Else
    Begin
      If reason <> goNone Then
        MessageBeep( $FFFF );
      exit;
    End;
  End;
end;

procedure TInplaceSymbolsBox.GoOff;
begin
  FRequireNotification := False;
  Visible := False;
  Windows.SetFocus( Parent.Handle );
end;

procedure TInplaceSymbolsBox.TriggerGoingOffEvent(Reason: TGoingOffReason;
  var AllowExit: Boolean);
begin
  If Assigned( FOnGoingOff ) Then
    FOnGoingOff( Self, Reason, AllowExit );
end;

procedure TInplaceSymbolsBox.DoChange;
begin
  FBaseProperty.ValInteger:= Self.ItemIndex;
end;

{$IFDEF BCB}
function TInplaceSymbolsBox.GetOnGoingOff: TGoingOffEvent;
begin
  Result := FOnGoingOff;
end;

procedure TInplaceSymbolsBox.SetOnGoingOff(const Value: TGoingOffEvent);
begin
  FOnGoingOff := Value;
end;
{$ENDIF}


{ TInplaceLinetypeBox }

constructor TInplaceLinetypeBox.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  //If Not ( csDesigning In ComponentState ) Then
  Visible := False;
  BorderStyle:= bsNone;
end;

procedure TInplaceLinetypeBox.CMEnter(var Message: TCMEnter);
begin
  Inherited;
  FRequireNotification := True;
end;

procedure TInplaceLinetypeBox.CMExit(var Message: TCMExit);
Var
  allowExit: Boolean;
Begin
  Inherited;
  allowExit := True;
  If FRequireNotification = True Then
    TriggerGoingOffEvent( goNone, allowExit );
  If allowExit Then
  Begin
    DoChange;
    FRequireNotification := False;
    Visible := False;
  End
  Else
  Begin
    MessageBeep( $FFFF );
    Windows.SetFocus( Self.Handle );
  End;
end;

procedure TInplaceLinetypeBox.CNKeydown(var Message: TWMkeydown);
Var
  allowExit: Boolean;
  reason: TGoingOffReason;
Begin
  allowExit := False;
  reason := goNone;
  With Message Do
  Begin
    Case CharCode Of
      VK_TAB:
        If ssShift In KeyDataToShiftState( KeyData ) Then
          reason := goLTab
        Else
          reason := goRTab;
      VK_RETURN:
        reason := goEnter;
      VK_ESCAPE:
        reason := goEscape;      
      VK_UP:
        if not DroppedDown then
          reason := goUp;
      VK_DOWN:
        if not DroppedDown then
          reason := goDown;
      VK_LEFT:
        //If ssCtrl In KeyDataToShiftState(KeyData) Then
        reason := goLeft;
      VK_RIGHT:
        //If ssCtrl In KeyDataToShiftState(KeyData) Then
        reason := goRight;
      VK_HOME:
        //If ssCtrl In KeyDataToShiftState(KeyData) Then
        reason := goHome;
      VK_END:
        //If ssCtrl In KeyDataToShiftState(KeyData) Then
        reason := goEnd;
      VK_PRIOR:
        reason := goPgUp;
      VK_NEXT:
        reason := goPgDn;
    End;

    If reason <> goNone Then
    Begin
      allowExit := True;
      TriggerGoingOffEvent( reason, allowExit );
    End;
    If allowExit Then
    Begin
      DoChange;
      FRequireNotification := False;
      If reason <> goNone Then
        Message.Result := 1; {to avoid beep on Return }
      If reason = goEscape Then
        MessageBeep( $FFFF );
      Visible := False;
      Windows.SetFocus( Parent.Handle );
    End
    Else
    Begin
      If reason <> goNone Then
        MessageBeep( $FFFF );
      exit;
    End;
  End;
end;

procedure TInplaceLinetypeBox.GoOff;
begin
  FRequireNotification := False;
  Visible := False;
  Windows.SetFocus( Parent.Handle );
end;

procedure TInplaceLinetypeBox.TriggerGoingOffEvent(Reason: TGoingOffReason;
  var AllowExit: Boolean);
begin
  If Assigned( FOnGoingOff ) Then
    FOnGoingOff( Self, Reason, AllowExit );
end;

procedure TInplaceLinetypeBox.DoChange;
begin
  FBaseProperty.ValInteger:= Self.ItemIndex;
end;

{$IFDEF BCB}
function TInplaceLinetypeBox.GetOnGoingOff: TGoingOffEvent;
begin
  Result := FOnGoingOff;
end;

procedure TInplaceLinetypeBox.SetOnGoingOff(const Value: TGoingOffEvent);
begin
  FOnGoingOff := Value;
end;
{$ENDIF}


{ TInplaceBrushstyleBox }

constructor TInplaceBrushstyleBox.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  //If Not ( csDesigning In ComponentState ) Then
  Visible := False;
  BorderStyle:= bsNone;
end;

procedure TInplaceBrushstyleBox.CMEnter(var Message: TCMEnter);
begin
  Inherited;
  FRequireNotification := True;
end;

procedure TInplaceBrushstyleBox.CMExit(var Message: TCMExit);
Var
  allowExit: Boolean;
Begin
  Inherited;
  allowExit := True;
  If FRequireNotification = True Then
    TriggerGoingOffEvent( goNone, allowExit );
  If allowExit Then
  Begin
    DoChange;
    FRequireNotification := False;
    Visible := False;
  End
  Else
  Begin
    MessageBeep( $FFFF );
    Windows.SetFocus( Self.Handle );
  End;
end;

procedure TInplaceBrushstyleBox.CNKeydown(var Message: TWMkeydown);
Var
  allowExit: Boolean;
  reason: TGoingOffReason;
Begin
  allowExit := False;
  reason := goNone;
  With Message Do
  Begin
    Case CharCode Of
      VK_TAB:
        If ssShift In KeyDataToShiftState( KeyData ) Then
          reason := goLTab
        Else
          reason := goRTab;
      VK_RETURN:
        reason := goEnter;
      VK_ESCAPE:
        reason := goEscape;
      VK_UP:
        if not DroppedDown then
          reason := goUp;
      VK_DOWN:
        if not DroppedDown then
          reason := goDown;
      VK_LEFT:
        //If ssCtrl In KeyDataToShiftState(KeyData) Then
        reason := goLeft;
      VK_RIGHT:
        //If ssCtrl In KeyDataToShiftState(KeyData) Then
        reason := goRight;
      VK_HOME:
        //If ssCtrl In KeyDataToShiftState(KeyData) Then
        reason := goHome;
      VK_END:
        //If ssCtrl In KeyDataToShiftState(KeyData) Then
        reason := goEnd;
      VK_PRIOR:
        reason := goPgUp;
      VK_NEXT:
        reason := goPgDn;
    End;

    If reason <> goNone Then
    Begin
      allowExit := True;
      TriggerGoingOffEvent( reason, allowExit );
    End;
    If allowExit Then
    Begin
      DoChange;
      FRequireNotification := False;
      If reason <> goNone Then
        Message.Result := 1; {to avoid beep on Return }
      If reason = goEscape Then
        MessageBeep( $FFFF );
      Visible := False;
      Windows.SetFocus( Parent.Handle );
    End
    Else
    Begin
      If reason <> goNone Then
        MessageBeep( $FFFF );
      exit;
    End;
  End;
end;

procedure TInplaceBrushstyleBox.GoOff;
begin
  FRequireNotification := False;
  Visible := False;
  Windows.SetFocus( Parent.Handle );
end;

procedure TInplaceBrushstyleBox.TriggerGoingOffEvent(Reason: TGoingOffReason;
  var AllowExit: Boolean);
begin
  If Assigned( FOnGoingOff ) Then
    FOnGoingOff( Self, Reason, AllowExit );
end;

procedure TInplaceBrushstyleBox.DoChange;
begin
  FBaseProperty.ValInteger:= Self.ItemIndex;
end;

{$IFDEF BCB}
function TInplaceBrushstyleBox.GetOnGoingOff: TGoingOffEvent;
begin
  Result := FOnGoingOff;
end;

procedure TInplaceBrushstyleBox.SetOnGoingOff(const Value: TGoingOffEvent);
begin
  FOnGoingOff := Value;
end;
{$ENDIF}


{ TInplaceColorBox }

constructor TInplaceColorBox.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  //If Not ( csDesigning In ComponentState ) Then
  Visible := False;
  ShowSystemColors:= True;
  NoneColorText:= SNoneColorTextInColorPicker;
  CustomText:= SCustomTextInColorPicker;
  Transparent:= false;
  Flat:= True;
  TabStop:= True;
end;

procedure TInplaceColorBox.CMEnter(var Message: TCMEnter);
begin
  Inherited;
  FRequireNotification := True;
end;

procedure TInplaceColorBox.CMExit(var Message: TCMExit);
Var
  allowExit: Boolean;
Begin
  Inherited;
  allowExit := True;
  If FRequireNotification = True Then
    TriggerGoingOffEvent( goNone, allowExit );
  If allowExit Then
  Begin
    DoChange;
    FRequireNotification := False;
    Visible := False;
  End
  Else
  Begin
    MessageBeep( $FFFF );
    Windows.SetFocus( Self.Handle );
  End;
end;

procedure TInplaceColorBox.CNKeydown(var Message: TWMkeydown);
Var
  allowExit: Boolean;
  reason: TGoingOffReason;
Begin
  allowExit := False;
  reason := goNone;
  With Message Do
  Begin
    Case CharCode Of
      VK_TAB:
        If ssShift In KeyDataToShiftState( KeyData ) Then
          reason := goLTab
        Else
          reason := goRTab;
      VK_RETURN:
        reason := goEnter;
      VK_ESCAPE:
        reason := goEscape;
      VK_UP:
        if not Down{DroppedDown} then
          reason := goUp;
      VK_DOWN:
        if not Down{DroppedDown} then
          reason := goDown;
      VK_LEFT:
        //If ssCtrl In KeyDataToShiftState(KeyData) Then
        reason := goLeft;
      VK_RIGHT:
        //If ssCtrl In KeyDataToShiftState(KeyData) Then
        reason := goRight;
      VK_HOME:
        //If ssCtrl In KeyDataToShiftState(KeyData) Then
        reason := goHome;
      VK_END:
        //If ssCtrl In KeyDataToShiftState(KeyData) Then
        reason := goEnd;
      VK_PRIOR:
        reason := goPgUp;
      VK_NEXT:
        reason := goPgDn;
    End;

    If reason <> goNone Then
    Begin
      allowExit := True;
      TriggerGoingOffEvent( reason, allowExit );
    End;
    If allowExit Then
    Begin
      DoChange;
      FRequireNotification := False;
      If reason <> goNone Then
        Message.Result := 1; {to avoid beep on Return }
      If reason = goEscape Then
        MessageBeep( $FFFF );
      Visible := False;
      Windows.SetFocus( Parent.Handle );
    End
    Else
    Begin
      If reason <> goNone Then
        MessageBeep( $FFFF );
      exit;
    End;
  End;
end;

procedure TInplaceColorBox.GoOff;
begin
  FRequireNotification := False;
  Visible := False;
  Windows.SetFocus( Parent.Handle );
end;

procedure TInplaceColorBox.TriggerGoingOffEvent(Reason: TGoingOffReason;
  var AllowExit: Boolean);
begin
  If Assigned( FOnGoingOff ) Then
    FOnGoingOff( Self, Reason, AllowExit );
end;

procedure TInplaceColorBox.DoChange;
begin
  if FBaseProperty <> Nil then FBaseProperty.ValInteger:= Self.Selected;
end;

{$IFDEF BCB}
function TInplaceColorBox.GetOnGoingOff: TGoingOffEvent;
begin
  Result := FOnGoingOff;
end;

procedure TInplaceColorBox.SetOnGoingOff(const Value: TGoingOffEvent);
begin
  FOnGoingOff := Value;
end;
{$ENDIF}


{ TInplaceBlocksBox }

constructor TInplaceBlocksBox.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  //If Not ( csDesigning In ComponentState ) Then
  Visible := False;
  BorderStyle:= bsNone;
end;

procedure TInplaceBlocksBox.CMEnter(var Message: TCMEnter);
begin
  Inherited;
  FRequireNotification := True;
end;

procedure TInplaceBlocksBox.CMExit(var Message: TCMExit);
Var
  allowExit: Boolean;
Begin
  Inherited;
  allowExit := True;
  If FRequireNotification = True Then
    TriggerGoingOffEvent( goNone, allowExit );
  If allowExit Then
  Begin
    DoChange;
    FRequireNotification := False;
    Visible := False;
  End
  Else
  Begin
    MessageBeep( $FFFF );
    Windows.SetFocus( Self.Handle );
  End;
end;

procedure TInplaceBlocksBox.CNKeydown(var Message: TWMkeydown);
Var
  allowExit: Boolean;
  reason: TGoingOffReason;
Begin
  allowExit := False;
  reason := goNone;
  With Message Do
  Begin
    Case CharCode Of
      VK_TAB:
        If ssShift In KeyDataToShiftState( KeyData ) Then
          reason := goLTab
        Else
          reason := goRTab;
      VK_RETURN:
        reason := goEnter;
      VK_ESCAPE:
        reason := goEscape;
      VK_UP:
        if not DroppedDown then
          reason := goUp;
      VK_DOWN:
        if not DroppedDown then
          reason := goDown;
      VK_LEFT:
        //If ssCtrl In KeyDataToShiftState(KeyData) Then
        reason := goLeft;
      VK_RIGHT:
        //If ssCtrl In KeyDataToShiftState(KeyData) Then
        reason := goRight;
      VK_HOME:
        //If ssCtrl In KeyDataToShiftState(KeyData) Then
        reason := goHome;
      VK_END:
        //If ssCtrl In KeyDataToShiftState(KeyData) Then
        reason := goEnd;
      VK_PRIOR:
        reason := goPgUp;
      VK_NEXT:
        reason := goPgDn;
    End;

    If reason <> goNone Then
    Begin
      allowExit := True;
      TriggerGoingOffEvent( reason, allowExit );
    End;
    If allowExit Then
    Begin
      DoChange;
      FRequireNotification := False;
      If reason <> goNone Then
        Message.Result := 1; {to avoid beep on Return }
      If reason = goEscape Then
        MessageBeep( $FFFF );
      Visible := False;
      Windows.SetFocus( Parent.Handle );
    End
    Else
    Begin
      If reason <> goNone Then
        MessageBeep( $FFFF );
      exit;
    End;
  End;
end;

procedure TInplaceBlocksBox.GoOff;
begin
  FRequireNotification := False;
  Visible := False;
  Windows.SetFocus( Parent.Handle );
end;

procedure TInplaceBlocksBox.TriggerGoingOffEvent(Reason: TGoingOffReason;
  var AllowExit: Boolean);
begin
  If Assigned( FOnGoingOff ) Then
    FOnGoingOff( Self, Reason, AllowExit );
end;

procedure TInplaceBlocksBox.DoChange;
begin
  { the name of the block is returned here }
  FBaseProperty.ValString:= BlockList[ItemIndex];
end;

{$IFDEF BCB}
function TInplaceBlocksBox.GetOnGoingOff: TGoingOffEvent;
begin
  Result := FOnGoingOff;
end;

procedure TInplaceBlocksBox.SetOnGoingOff(const Value: TGoingOffEvent);
begin
  FOnGoingOff := Value;
end;
{$ENDIF}


{ TInplaceEdit }

constructor TInplaceEdit.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  //If Not ( csDesigning In ComponentState ) Then
  Visible := False;
  BorderStyle:= bsNone;
end;

procedure TInplaceEdit.CMEnter(var Message: TCMEnter);
begin
  Inherited;
  FRequireNotification := True;
end;

procedure TInplaceEdit.CMExit(var Message: TCMExit);
Var
  allowExit: Boolean;
Begin
  Inherited;
  allowExit := True;
  If FRequireNotification = True Then
    TriggerGoingOffEvent( goNone, allowExit );
  If allowExit Then
  Begin
    DoChange;
    FRequireNotification := False;
    Visible := False;
  End
  Else
  Begin
    MessageBeep( $FFFF );
    Windows.SetFocus( Self.Handle );
  End;
end;

procedure TInplaceEdit.CNKeydown(var Message: TWMkeydown);
Var
  allowExit: Boolean;
  reason: TGoingOffReason;
Begin
  allowExit := False;
  reason := goNone;
  With Message Do
  Begin
    Case CharCode Of
      VK_TAB:
        If ssShift In KeyDataToShiftState( KeyData ) Then
          reason := goLTab
        Else
          reason := goRTab;
      VK_RETURN:
        begin
          reason := goEnter;
          if FBaseProperty.FPropType = ptString then
            FBaseProperty.ValString:= Self.Text;
        end;
      VK_ESCAPE:
        reason := goEscape;
      VK_UP:
        reason := goUp;
      VK_DOWN:
        reason := goDown;
      //VK_LEFT:
        //If ssCtrl In KeyDataToShiftState(KeyData) Then
        //reason := goLeft;
      //VK_RIGHT:
        //If ssCtrl In KeyDataToShiftState(KeyData) Then
        //reason := goRight;
      //VK_HOME:
        //If ssCtrl In KeyDataToShiftState(KeyData) Then
        //reason := goHome;
      //VK_END:
        //If ssCtrl In KeyDataToShiftState(KeyData) Then
        //reason := goEnd;
      VK_PRIOR:
        reason := goPgUp;
      VK_NEXT:
        reason := goPgDn;
    End;

    If reason <> goNone Then
    Begin
      allowExit := True;
      TriggerGoingOffEvent( reason, allowExit );
    End;
    If allowExit Then
    Begin
      DoChange;
      FRequireNotification := False;
      If reason <> goNone Then
        Message.Result := 1; {to avoid beep on Return }
      If reason = goEscape Then
        MessageBeep( $FFFF );
      Visible := False;
      Windows.SetFocus( Parent.Handle );
    End
    Else
    Begin
      If reason <> goNone Then
        MessageBeep( $FFFF )
      else
      begin
        {if FBaseProperty.FPropType = ptString then
          FBaseProperty.ValString:= Self.Text;}
      end;
      exit;
    End;
  End;
end;

procedure TInplaceEdit.GoOff;
begin
  FRequireNotification := False;
  Visible := False;
  Windows.SetFocus( Parent.Handle );
end;

procedure TInplaceEdit.TriggerGoingOffEvent(Reason: TGoingOffReason;
  var AllowExit: Boolean);
begin
  If Assigned( FOnGoingOff ) Then
    FOnGoingOff( Self, Reason, AllowExit );
end;

procedure TInplaceEdit.DoChange;
begin
  if FBaseProperty.FPropType = ptString then
    FBaseProperty.ValString:= Self.Text;
end;

{$IFDEF BCB}
function TInplaceEdit.GetOnGoingOff: TGoingOffEvent;
begin
  Result := FOnGoingOff;
end;

procedure TInplaceEdit.SetOnGoingOff(const Value: TGoingOffEvent);
begin
  FOnGoingOff := Value;
end;
{$ENDIF}


{ TInplaceNumEd }

constructor TInplaceNumEd.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  //If Not ( csDesigning In ComponentState ) Then
  Visible := False;
  BorderStyle:= ebsFlat;
  WidthPad:= -2;
  NegColor:= Self.Font.Color;
end;

procedure TInplaceNumEd.CMEnter(var Message: TCMEnter);
begin
  Inherited;
  FRequireNotification := True;
end;

procedure TInplaceNumEd.CMExit(var Message: TCMExit);
Var
  allowExit: Boolean;
Begin
  Inherited;
  allowExit := True;
  If FRequireNotification = True Then
    TriggerGoingOffEvent( goNone, allowExit );
  If allowExit Then
  Begin
    DoChange;
    FRequireNotification := False;
    Visible := False;
  End
  Else
  Begin
    MessageBeep( $FFFF );
    Windows.SetFocus( Self.Handle );
  End;
end;

procedure TInplaceNumEd.CNKeydown(var Message: TWMkeydown);
Var
  allowExit: Boolean;
  reason: TGoingOffReason;
Begin
  allowExit := False;
  reason := goNone;
  With Message Do
  Begin
    Case CharCode Of
      VK_TAB:
        If ssShift In KeyDataToShiftState( KeyData ) Then
          reason := goLTab
        Else
          reason := goRTab;
      VK_RETURN:
        begin
          reason := goEnter;
          if FBaseProperty.FPropType = ptFloat then
          begin
            if FBaseProperty is TEzAngleProperty then
              FBaseProperty.ValFloat:= DegToRad(Self.NumericValue)
            else
              FBaseProperty.ValFloat:= Self.NumericValue;
          end else if FBaseProperty.FPropType = ptInteger then
            FBaseProperty.ValInteger:= Round(Self.NumericValue);
        end;
      VK_ESCAPE:
        reason := goEscape;
      VK_UP:
        reason := goUp;
      VK_DOWN:
        reason := goDown;
      VK_LEFT:
        //If ssCtrl In KeyDataToShiftState(KeyData) Then
        reason := goLeft;
      VK_RIGHT:
        //If ssCtrl In KeyDataToShiftState(KeyData) Then
        reason := goRight;
      VK_HOME:
        //If ssCtrl In KeyDataToShiftState(KeyData) Then
        reason := goHome;
      VK_END:
        //If ssCtrl In KeyDataToShiftState(KeyData) Then
        reason := goEnd;
      VK_PRIOR:
        reason := goPgUp;
      VK_NEXT:
        reason := goPgDn;
    End;

    If reason <> goNone Then
    Begin
      allowExit := True;
      TriggerGoingOffEvent( reason, allowExit );
    End;
    If allowExit Then
    Begin
      DoChange;
      FRequireNotification := False;
      If reason <> goNone Then
        Message.Result := 1; {to avoid beep on Return }
      If reason = goEscape Then
        MessageBeep( $FFFF );
      Visible := False;
      Windows.SetFocus( Parent.Handle );
    End
    Else
    Begin
      If reason <> goNone Then
        MessageBeep( $FFFF );
      exit;
    End;
  End;
end;

procedure TInplaceNumEd.GoOff;
begin
  FRequireNotification := False;
  Visible := False;
  Windows.SetFocus( Parent.Handle );
end;

procedure TInplaceNumEd.TriggerGoingOffEvent(Reason: TGoingOffReason;
  var AllowExit: Boolean);
begin
  If Assigned( FOnGoingOff ) Then
    FOnGoingOff( Self, Reason, AllowExit );
end;

procedure TInplaceNumEd.DoChange;
begin
  if FBaseProperty.FPropType = ptFloat then
  begin
    if FBaseProperty is TEzAngleProperty then
      FBaseProperty.ValFloat:= DegToRad(Self.NumericValue)
    else
      FBaseProperty.ValFloat:= Self.NumericValue
  end else if FBaseProperty.FPropType = ptInteger then
    FBaseProperty.ValInteger:= Round(Self.NumericValue);
end;

{$IFDEF BCB}
function TInplaceNumEd.GetOnGoingOff: TGoingOffEvent;
begin
  Result := FOnGoingOff;
end;

procedure TInplaceNumEd.SetOnGoingOff(const Value: TGoingOffEvent);
begin
  FOnGoingOff := Value;
end;
{$ENDIF}


{ TInplaceDateTimePicker }

constructor TInplaceDateTimePicker.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  //If Not ( csDesigning In ComponentState ) Then
  Visible := False;
end;

procedure TInplaceDateTimePicker.DoChange;
begin
  FBaseProperty.ValDateTime:= Self.Date;
end;

procedure TInplaceDateTimePicker.CMEnter(var Message: TCMEnter);
begin
  Inherited;
  FRequireNotification := True;
end;

procedure TInplaceDateTimePicker.CMExit(var Message: TCMExit);
Var
  allowExit: Boolean;
Begin
  Inherited;
  allowExit := True;
  If FRequireNotification = True Then
    TriggerGoingOffEvent( goNone, allowExit );
  If allowExit Then
  Begin
    DoChange;
    FRequireNotification := False;
    Visible := False;
  End
  Else
  Begin
    MessageBeep( $FFFF );
    Windows.SetFocus( Self.Handle );
  End;
end;

procedure TInplaceDateTimePicker.CNKeydown(var Message: TWMkeydown);
Var
  allowExit: Boolean;
  reason: TGoingOffReason;
Begin
  allowExit := False;
  reason := goNone;
  With Message Do
  Begin
    Case CharCode Of
      VK_TAB:
        If ssShift In KeyDataToShiftState( KeyData ) Then
          reason := goLTab
        Else
          reason := goRTab;
      VK_RETURN:
        reason := goEnter;
      VK_ESCAPE:
        reason := goEscape;
      VK_UP:
        reason := goUp;
      VK_DOWN:
        reason := goDown;
      VK_LEFT:
        //If ssCtrl In KeyDataToShiftState(KeyData) Then
        reason := goLeft;
      VK_RIGHT:
        //If ssCtrl In KeyDataToShiftState(KeyData) Then
        reason := goRight;
      VK_HOME:
        //If ssCtrl In KeyDataToShiftState(KeyData) Then
        reason := goHome;
      VK_END:
        //If ssCtrl In KeyDataToShiftState(KeyData) Then
        reason := goEnd;
      VK_PRIOR:
        reason := goPgUp;
      VK_NEXT:
        reason := goPgDn;
    End;

    If reason <> goNone Then
    Begin
      allowExit := True;
      TriggerGoingOffEvent( reason, allowExit );
    End;
    If allowExit Then
    Begin
      DoChange;
      FRequireNotification := False;
      If reason <> goNone Then
        Message.Result := 1; {to avoid beep on Return }
      If reason = goEscape Then
        MessageBeep( $FFFF );
      Visible := False;
      Windows.SetFocus( Parent.Handle );
    End
    Else
    Begin
      If reason <> goNone Then
        MessageBeep( $FFFF );
      exit;
    End;
  End;
end;

procedure TInplaceDateTimePicker.GoOff;
begin
  FRequireNotification := False;
  Visible := False;
  Windows.SetFocus( Parent.Handle );
end;

procedure TInplaceDateTimePicker.TriggerGoingOffEvent(
  Reason: TGoingOffReason; var AllowExit: Boolean);
begin
  If Assigned( FOnGoingOff ) Then
    FOnGoingOff( Self, Reason, AllowExit );
end;

{$IFDEF BCB}
function TInplaceDateTimePicker.GetOnGoingOff: TGoingOffEvent;
begin
  Result := FOnGoingOff;
end;

procedure TInplaceDateTimePicker.SetOnGoingOff(
  const Value: TGoingOffEvent);
begin
  FOnGoingOff := Value;
end;
{$ENDIF}


{ TEzBaseProperty }

function TEzBaseProperty.AsString: string;
begin
  Result:= '';
  case FPropType of
    ptString:
      Result:= ValString;
    ptFloat:
      Result:= FloatToStr(ValFloat);
    ptInteger:
      Result:= IntToStr(ValInteger);
    ptBoolean:
      if FValBoolean then
        Result:= 'True'
      else
        Result:= 'False';
    ptDate:
      Result:= DateTimeToStr(ValDateTime);
  end;
end;

constructor TEzBaseProperty.Create(const PropName: string);
begin
  inherited Create;
  FPropName:= PropName;
end;

procedure TEzBaseProperty.Draw(Canvas: TCanvas; ARect: TRect;
  AState: TGridDrawState);
var
  uFormat: Word;
begin
  uFormat:= DT_LEFT or DT_SINGLELINE or DT_VCENTER;
  if gdSelected in AState then
  begin
    Canvas.Brush.Color := clHighlight;
    Canvas.Font.Color := clHighlightText;
  end;
  DrawText( Canvas.Handle, PChar(AsString), -1, ARect, uFormat );
end;

procedure TEzBaseProperty.Edit(Inspector: TEzInspector);
begin
  // nothing to do here
end;

procedure TEzBaseProperty.SetValBoolean(const Value: Boolean);
begin
  if Value=FValBoolean then Exit;
  FValBoolean := Value;
  if FReadOnly then Exit;
  Self.Changed;
end;

procedure TEzBaseProperty.SetValDatetime(const Value: TDateTime);
begin
  if Value=FValDateTime then Exit;
  FValdateTime := Value;
  if FReadOnly then Exit;
  Self.Changed;
end;

procedure TEzBaseProperty.SetValFloat(const Value: Double);
begin
  if Value=FValFloat then Exit;
  FValFloat := Value;
  if FReadOnly then Exit;
  Self.Changed;
end;

procedure TEzBaseProperty.SetValInteger(const Value: Integer);
begin
  if Value=FValInteger then Exit;
  FValInteger := Value;
  if FReadOnly then Exit;
  Self.Changed;
end;

procedure TEzBaseProperty.SetValString(const Value: string);
begin
  if Value=FValString then Exit;
  FValString := Value;
  if FReadOnly then Exit;
  Self.Changed;
end;

procedure TEzBaseProperty.ShowEditor(Inspector: TEzInspector; ARect: TRect);
begin
  // nothing to do here
end;

procedure TEzBaseProperty.Changed;
{var
  p : TEzBaseProperty; }
begin
  FModified:= True;
  { notify this first }
  if Assigned(FOnChange) then FOnChange(Self);
  { notify to parents }
  {p := FParent ;
  while p <> Nil do
  begin
    if Assigned(p.FOnChange) then
      p.FOnChange(p);

    p:= p.FParent;
  end; }
end;

function TEzBaseProperty.IndentLevel: Integer;
var
  p : TEzBaseProperty;
begin
  Result := 0;
  p := FParent ;
  while p <> Nil do
  begin
    Inc( Result );

    p := p.FParent;
  end;
end;

{ TEzInspector }

constructor TEzInspector.Create(AOwner: TComponent);
var
  bp: TEzBaseProperty;
  Designing: Boolean;
begin
  inherited Create(AOwner);
  FPropertyList:= TEzPropertyList.Create;
  FTitleCaptions:= TStringList.Create;
  FTitleCaptions.Add('Property');
  FTitleCaptions.Add('Value');

  ControlStyle := ControlStyle + [csAcceptsControls];

  Designing := csDesigning in ComponentState;

  { create the editors }
  FInplaceComboBox:= TInplaceComboBox.Create(Self);
  if not Designing then FInplaceComboBox.Parent:= Self;
  FInplaceComboBox.OnGoingOff:= InPlaceEditGoingOff;

  FInplaceEdit:= TInplaceEdit.Create(Self);
  if not Designing then FInplaceEdit.Parent:= Self;
  FInplaceEdit.OnGoingOff:= InPlaceEditGoingOff;
  FInplaceEdit.BorderStyle:= bsNone;

  FInplaceNumEd:= TInplaceNumEd.Create(Self);
  if not Designing then FInplaceNumEd.Parent:= Self;
  FInplaceNumEd.OnGoingOff:= InPlaceEditGoingOff;
  FInplaceNumEd.BorderStyle:= ebsNone;

  FInplaceSymbolsBox:= TInplaceSymbolsBox.Create(Self);
  if not Designing then FInplaceSymbolsBox.Parent:= Self;
  with FInplaceSymbolsBox do
  begin
    OnGoingOff:= InPlaceEditGoingOff;
    EditAreaShowIndex:= False;
    AutoSize:= False;
    ItemHeight:= 48;
    DropDownWidth:= 200;
    DropDownHeight:= 200;
  end;
  //FInplaceSymbolsBox.Populate;

  FInplaceBlocksBox:= TInplaceBlocksBox.Create(Self);
  if not Designing then FInplaceBlocksBox.Parent:= Self;
  with FInplaceBlocksBox do
  begin
    OnGoingOff:= InPlaceEditGoingOff;
    EditAreaShowIndex:= False;
    AutoSize:= False;
    ItemHeight:= 48;
    DropDownWidth:= 200;
    DropDownHeight:= 200;
  end;
  FInplaceBlocksBox.Populate;

  FInplaceColorBox:= TInplaceColorBox.Create(Self);
  if not Designing then FInplaceColorBox.Parent:= Self;
  FInplaceColorBox.OnGoingOff:= InPlaceEditGoingOff;

  FInplaceBrushstyleBox := TInplaceBrushstyleBox.Create(Self);
  if not Designing then FInplaceBrushstyleBox.Parent:= Self;
  with FInplaceBrushstyleBox do
  begin
    OnGoingOff:= InPlaceEditGoingOff;
    EditAreaShowIndex:= False;
    AutoSize:= False;
    ItemHeight:= 48;
    DropDownWidth:= 200;
    DropDownHeight:= 200;
  end;

  FInplaceLinetypeBox:= TInplaceLinetypeBox.Create(Self);
  if not Designing then FInplaceLinetypeBox.Parent:= Self;
  with FInplaceLinetypeBox do
  begin
    OnGoingOff:= InPlaceEditGoingOff;
    EditAreaShowIndex:= False;
    AutoSize:= False;
    ItemHeight:= 48;
    DropDownWidth:= 200;
    DropDownHeight:= 200;
  end;

  FInplaceDateTimePicker:= TInplaceDateTimePicker.Create(Self);
  if not Designing then FInplaceDateTimePicker.Parent:= Self;
  FInplaceDateTimePicker.OnGoingOff:= InPlaceEditGoingOff;

  FixedCols:= 0;
  FixedRows:= 1;
  ColCount:= 2;
  RowCount:= 2;
  {if (AOwner <> Nil) And (AOwner is TControl) then
  begin
    cw:= (TControl(AOwner).ClientWidth - GetSystemMetrics(SM_CXBORDER) * 2 -
      GetSystemMetrics(SM_CXVSCROLL) - GridLineWidth * ColCount - 1) div 2;
    DefaultColWidth:= cw;
  end; }
  Options:= [grids.goFixedVertLine,
             grids.goFixedHorzLine,
             grids.goVertLine,
             grids.goHorzLine,
             grids.goColSizing,
             grids.goDrawFocusSelected,
             grids.goRowSizing];
  Scrollbars:= ssVertical;
  Color:= clBtnFace;

  DefaultDrawing:= True;

  DefaultRowHeight:= Abs(Font.Height)+2;

  Col:= 1;
  FLastRow:= Row;

  FButton:= TSpeedButton.Create(Self);
  FButtonWidth:= EzMiscelCtrls.DefEditBtnWidth;
  FButton.Width:= FButtonWidth;
  if not Designing then
    FButton.Parent:= Self;
  FButton.Visible:= False;
  SetButtonGlyph;
  FButton.OnClick:= EllipsisButtonClick;

  FFontReadOnly := TFont.Create;
  FFontReadOnly.Assign(Self.Font);
  FFontReadOnly.Style:= [fsBold, fsItalic];
  FFontModified := TFont.Create;
  FFontModified.Assign(Self.Font);
  FFontModified.Style:= [fsBold];
  FReadOnlyBackColor := clGray;

  if Designing then
  begin
    bp:= TEzColorProperty.Create('Sample Color');
    bp.ValInteger:= Ord(clRed);
    AddProperty( bp );

    bp:= TEzBooleanProperty.Create('Sample Boolean');
    bp.ValBoolean:= True;
    AddProperty( bp );

    bp:= TEzFloatProperty.Create('Sample Float');
    bp.ValFloat:= System.PI;
    AddProperty( bp );

    bp:= TEzIntegerProperty.Create('Sample Integer');
    bp.ValInteger:= 32768;
    AddProperty( bp );

  end;

  FPlusBitmap:= TBitmap.Create;
  FPlusBitmap.Handle := LoadBitmap( HInstance, 'BMP_PLUS' );
  FMinusBitmap:= TBitmap.Create;
  FMinusBitmap.Handle := LoadBitmap( HInstance, 'BMP_MINUS' );

  //ShowHint:= True;
end;

destructor TEzInspector.Destroy;
begin
  ClearPropertyList;
  FPropertyList.Free;
  FTitleCaptions.Free;
  FPlusBitmap.Free;
  FMinusBitmap.Free;
  inherited destroy;
end;

Procedure TEzInspector.Loaded;
Begin
  inherited;
  if not ( csDesigning in ComponentState ) then
  begin
    if FButtonWidth = 0 then
      FButtonWidth := DefEditBtnWidth;
    FButton.Width:= FButtonWidth;
    //***FInplaceComboBox.ButtonWidth := FButtonWidth;
  end;
End;

Procedure TEzInspector.SetButtonWidth( Value: Integer );
begin
  FButtonWidth:= Value;
  if not ( csDesigning in ComponentState ) then
  begin
    //***FInplaceComboBox.ButtonWidth:= Value;
    FButton.Width:= Value;
  end;
  SetButtonGlyph;
end;

Procedure TEzInspector.SetButtonGlyph;
var
  NewGlyph: TBitmap;

  function CreateEllipsisGlyph: TBitmap;
  var
    W, G, I: Integer;
  begin
    Result := TBitmap.Create;
    with Result do
    try
      Monochrome := True;
      Width := ezlib.IMax(1, FButton.Width - 6);
      Height := 4;
      W := 2;
      G := (Result.Width - 3 * W) div 2;
      if G <= 0 then G := 1;
      if G > 3 then G := 3;
      I := (Width - 3 * W - 2 * G) div 2;
      PatBlt(Canvas.Handle, I, 1, W, W, BLACKNESS);
      PatBlt(Canvas.Handle, I + G + W, 1, W, W, BLACKNESS);
      PatBlt(Canvas.Handle, I + 2 * G + 2 * W, 1, W, W, BLACKNESS);
    except
      Free;
      raise;
    end;
  end;

begin
  NewGlyph := CreateEllipsisGlyph;
  try
    FButton.Glyph.Assign( NewGlyph );
    FButton.NumGlyphs := 1;
  finally
    NewGlyph.Free;
  end;
end;

procedure TEzInspector.EllipsisButtonClick(Sender: TObject);
var
  Baseproperty: TEzBaseproperty;
begin
  if Row > GetRowCount then Exit;
  Baseproperty:= GetPropertyByRow(Row - 1);
  If Baseproperty = Nil then Exit;
  Baseproperty.Edit(Self);
end;

function TEzInspector.SelectCell(ACol, ARow: Longint): Boolean;
var
  Baseproperty: TEzBaseproperty;
  ARect, R: TRect;
Begin
  Result:= False;
  if (csDesigning in ComponentState) or Not(ACol = 1) Or (ARow > GetRowCount) then Exit;
  { configure }
  Baseproperty:= GetPropertyByRow(ARow - 1);
  Result:= Not Baseproperty.ReadOnly;
  if not Result then Exit;

  { fire the hint event }
  If Assigned( FOnPropertyHint ) then
    FOnPropertyHint( Self, Baseproperty.FPropName );

  FButton.Visible:= False;

  // position the editor
  ARect:= CellRect(ACol,ARow);
  if Baseproperty.FUseEditButton then
    Dec(ARect.Right, FButton.Width + 2 );
  R:= ARect;
  InflateRect( R, -1, -1 );
  Baseproperty.ShowEditor( Self, R );

  { now display the ellipsis button }
  if Baseproperty.FUseEditButton then
  begin
    FButton.Left:= ARect.Right+1;
    FButton.Top:= ARect.Top;
    FButton.Height:= DefaultRowHeight;
    FButton.Visible:= True;
  end;
  InvalidateRow(FLastRow);
  InvalidateRow(ARow);
  FLastRow:= ARow;
End;

procedure TEzInspector.InPlaceEditGoingOff(Sender: TObject;
  Reason: TGoingOffReason; var AllowExit: Boolean);
begin
  Case reason Of
    goUp: PostMessage( Handle, WM_KEYDOWN, VK_UP, 0 );
    goLeft: PostMessage( Handle, WM_KEYDOWN, VK_LEFT, 0 );
    goDown: PostMessage( Handle, WM_KEYDOWN, VK_DOWN, 0 );
    goRight: PostMessage( Handle, WM_KEYDOWN, VK_RIGHT, 0 );
    goHome: PostMessage( Handle, WM_KEYDOWN, VK_HOME, 0 );
    goEnd: PostMessage( Handle, WM_KEYDOWN, VK_END, 0 );
    goPgUp: PostMessage( Handle, WM_KEYDOWN, VK_PRIOR, 0 );
    goPgDn: PostMessage( Handle, WM_KEYDOWN, VK_NEXT, 0 );
  End;
  {If reason = goEnter Then
    AllowExit := False
  Else }If ( Row = 1 ) And ( reason In [goUp, goPgUp] ) Then
    AllowExit := False
  Else If ( Row = RowCount - 1 ) And ( reason In [goDown, goPgDn] ) Then
    AllowExit := False;
  if AllowExit then
  Begin
    FButton.Visible:= False;
  End;
end;

procedure TEzInspector.ClearPropertyList;
Begin
  TurnOffEditor;
  FButton.Visible:= False;
  FPropertyList.Clear;
  RowCount:= 2;
  If Assigned( FOnPropertyHint ) then
    FOnPropertyHint( Self, '' );
End;

procedure TEzInspector.DrawCell(ACol, ARow: Integer; ARect: TRect;
  AState: TGridDrawState);
var
  bp: TEzBaseProperty;
  uFormat: Word;
  AText: string;
  tm: TTextMetric;
  YPos: Integer;
begin
  if FPropertyList.Count = 0 then Exit;
  with Canvas do
  begin
    Font.Assign( Self.Font );
    if ARow = 0 then
    begin
      {if ARow = Self.Row then
      begin
        DrawEdge(Handle, ARect, EDGE_SUNKEN, BF_RECT);
      end; }
      Font.Style:= Font.Style + [fsBold];
      { the header}
      uFormat:= DT_CENTER or DT_VCENTER or DT_SINGLELINE;
      if ACol=0 then
      begin
        if FTitleCaptions.Count > 0 then
          AText:= FTitleCaptions[0]
        else
          AText:= 'Property';
      end;
      if ACol=1 then
      begin
        if FTitleCaptions.Count > 1 then
          AText:= FTitleCaptions[1]
        else
          AText:= 'Value';
      end;
      DrawText( Handle, PChar(AText), -1, ARect, uFormat );
    end else
    begin
      { the rows }
      //InflateRect(ARect, -1, -1);
      if ARow = Self.Row then
      begin
        Frame3D( Canvas, ARect, clBtnShadow, clBtnHighlight, 2 );
        //DrawEdge(Handle, ARect, EDGE_SUNKEN, BF_RECT);
      end;
      bp := GetPropertyByRow(ARow - 1);
      if (bp = Nil) Then Exit;
      if bp.ReadOnly then
      begin
        Brush.Color:= ReadOnlyBackColor;
        Brush.Style:= bsSolid;
        FillRect(ARect);
      end;
      if ACol = 0 then
      begin
        Font.Color:= clBlack;
        if bp.ReadOnly then
        begin
          Font.Assign(FFontReadOnly);
        end else if bp.Modified then
        begin
          Font.Assign(FFontModified);
        end else
        begin
          Font.Style:= [];
        end;
        AText:= bp.PropName;
        if bp is TEzTreeViewProperty then
        begin
          GetTextMetrics( Canvas.Handle, tm );
          Inc(ARect.Left, tm.tmAveCharWidth * (2 * (bp.IndentLevel))); // two characters the indentation
          YPos := ARect.Top + ((ARect.Bottom - ARect.Top) - FPlusBitmap.Height ) div 2;
          if TEzTreeViewProperty(bp).FExpanded Then
            Canvas.Draw( ARect.Left+2, YPos, FMinusBitmap )
            //AText := '[-] ' + AText
          Else
            Canvas.Draw( ARect.Left+2, YPos, FPlusBitmap );
            //AText := '[+] ' + AText;
        end
        else if bp.IndentLevel > 0 then
        begin
          GetTextMetrics( Canvas.Handle, tm );
          Inc(ARect.Left, tm.tmAveCharWidth * (2 * bp.IndentLevel)); // two characters the indentation
        end;
        Inc( ARect.Left, FPlusBitmap.Width+4 );
        uFormat:= DT_LEFT or DT_SINGLELINE or DT_VCENTER;
        InflateRect(ARect,-1,-1);
        DrawText( Handle, PChar(AText), -1, ARect, uFormat );
      End else
      begin
        Font.Color:= clNavy;
        bp.Draw(Canvas, ARect, AState);
      end;
    end;
  end;
end;

procedure TEzInspector.AddProperty(BaseProperty: TEzBaseProperty);
var
  CanShow: Boolean;
begin
  if Assigned(FOnBeforeProperty) then
  begin
    CanShow:= True;
    FOnBeforeProperty(Self, BaseProperty.PropName, CanShow, BaseProperty.FReadOnly );
    if not CanShow then
    begin
      BaseProperty.Free;
      Exit;
    end;
  end;
  BaseProperty.FModified:= false;
  BaseProperty.OnChange:= PropertyChanged;
  FPropertyList.Add( BaseProperty );
  RowCount:= FPropertyList.Count + 1;
  if RowCount > 1 then
  begin
    FixedRows:= 1;
    Col:= 1;
    Row:= 1;
    If (FPropertyList.Count = 1) And Assigned( FOnPropertyHint ) then
      FOnPropertyHint( Self, BaseProperty.FPropName );
  end;
end;

procedure TEzInspector.AdjustColWidths;
begin
  if FInColChange Or Not HandleAllocated Or Not Showing Then Exit;
  FInColChange:= true;
  try
    if ColWidths[0] >= MulDiv({ParentForm.}ClientWidth,3,4) then
    begin
      ColWidths[0] := MulDiv({ParentForm.}ClientWidth,3,4);
    end;
    ColWidths[1] := {ParentForm.}ClientWidth - ColWidths[0] -
      GetSystemMetrics(SM_CXBORDER) * 1 - GridLineWidth * ColCount ;
  finally
    FInColChange:= false;
  end;
end;

procedure TEzInspector.ColWidthsChanged;
begin
  TurnOffEditor;
  AdjustColWidths;
  inherited ColWidthsChanged;
end;

Procedure TEzInspector.TurnOffEditor;
begin
  if csDestroying in ComponentState then Exit;

  if FInplaceComboBox.Visible then FInplaceComboBox.GoOff;
  if FInplaceEdit.Visible then FInplaceEdit.GoOff;
  if FInplaceNumEd.Visible then FInplaceNumEd.GoOff;
  if FInplaceSymbolsBox.Visible then FInplaceSymbolsBox.GoOff;
  if FInplaceBlocksBox.Visible then FInplaceBlocksBox.GoOff;
  if FInplaceColorBox.Visible then FInplaceColorBox.GoOff;
  if FInplaceBrushstyleBox.Visible then FInplaceBrushstyleBox.GoOff;
  if FInplaceLinetypeBox.Visible then FInplaceLinetypeBox.GoOff;
  if FInplaceDateTimePicker.Visible then FInplaceDateTimePicker.GoOff;
  if FButton <> Nil then FButton.Visible:= False;

end;

function TEzInspector.GetPropertyByName( const Value: string): TEzBaseProperty;

  Function RecurseGetPropertyByName(Const List : TEzPropertyList) : TEzBaseProperty;
  Var
    I : integer;
  Begin
    Result := Nil;
    For I := 0 To List.Count - 1 Do
      if AnsiCompareText(Value, TEzBaseProperty(List[I]).PropName) = 0 Then Begin
        Result := List[I];
        Exit;
      End Else If List[I] is TEzTreeViewProperty Then Begin
        Result := RecurseGetPropertyByName(TEzTreeViewProperty(List[I]).FPropertyList);
        If Result <> Nil Then Exit;
      End;
  End;
begin
  Result:= RecurseGetPropertyByName(FPropertyList);
end;

procedure TEzInspector.SetModifiedStatus(Value: Boolean);

  Procedure RecurseSetModifiedStatus(const List : TEzPropertyList);
    var
      Index: Integer;
  Begin
     For Index := 0 To List.Count - 1 Do Begin
       If Not List[Index].FReadOnly Then
         List[Index].FModified := Value;
       If List[Index] Is TEzTreeViewProperty Then
         RecurseSetModifiedStatus((List[Index] As TEzTreeViewProperty).FPropertyList);
     End;
  End;
begin
  RecurseSetModifiedStatus(FPropertyList);
end;

procedure TEzInspector.PropertyChanged(Sender: TObject);
var
  Index: Integer;
begin
  Index := GetPropertyRow( Sender );
  If Index = 0 Then Exit;
  InvalidateRow(Index + 1);
  If Assigned(FOnPropertyChange) Then
    FOnPropertyChange(Self, (Sender As TEzBaseProperty).PropName);
end;

procedure TEzInspector.TopLeftChanged;
begin
  inherited;
  TurnOffEditor;
end;

procedure TEzInspector.DblClick;
var
  Pos: TPoint;
  ACol,ARow: Integer;
  Coord: TGridCoord;
  bp: TEzBaseProperty;
begin
  inherited;
  { detect mouse pos }
  Windows.GetCursorPos(Pos);
  Pos:=ScreenToClient(Pos);
  Coord := MouseCoord(Pos.X, Pos.Y);
  ACol := Coord.X;
  ARow := Coord.Y;
  if (ARow=0) and (ACol=0) then
  begin
    { set modified status to false to all properties }
    SetModifiedStatus(False);
    Invalidate;
  end else if (ACol=0) then
  begin
    { set modified status to false to this row only}
    bp := GetPropertyByRow(ARow - 1);
    if bp = Nil Then Exit;
    if bp Is TEzTreeViewProperty Then
    Begin
      With TEzTreeViewProperty( bp ) Do
        FExpanded := Not FExpanded;
      AdjustRows;
      Invalidate;
    End Else
    begin
      with bp do
      if not ReadOnly then
      begin
        Modified:= not Modified ;
        InvalidateRow(ARow);
      end;
    end;
  end else
  begin
    { fire custom editors if clicked on properties that have ellipsis button }
    if ARow-1 < 0 then exit;
    bp:= GetPropertyByRow(ARow-1);
    if bp = Nil Then Exit;
    if bp.FUseEditButton then
      EllipsisButtonClick(Nil);
  end;
end;

procedure TEzInspector.WMHScroll(var Msg: TWMHScroll);
begin
  inherited;
  TurnOffEditor;
end;

procedure TEzInspector.WMVScroll(var Msg: TWMVScroll);
begin
  inherited;
  TurnOffEditor;
end;

procedure TEzInspector.ReplaceProperty(const Value: string; p: TEzBaseProperty);
var
  Index: Integer;
begin
  TurnOffEditor;
  Index:= PropList.IndexOfName( Value );
  if Index < 0 then Exit;
  FPropertyList[Index] := p;
end;

procedure TEzInspector.SetFontModified(const Value: TFont);
begin
  FFontModified.Assign( Value );
end;

procedure TEzInspector.SetFontReadOnly(const Value: TFont);
begin
  FFontReadOnly.Assign( Value );
end;

function TEzInspector.PropertyCount: Integer;
begin
  Result:= FPropertyList.Count;
end;

procedure TEzInspector.InsertProperty(Index: Integer; BaseProperty: TEzBaseProperty);
begin
  TurnOffEditor;
  If (Index < 0) Or (Index > FPropertyList.Count) Then Exit;
  FPropertyList.Insert(Index, BaseProperty);
  AdjustRows;
//  RowCount:= FPropertyList.Count + 1;
end;

procedure TEzInspector.DeletePropertyByIndex(Index: Integer);
begin
  TurnOffEditor;
  If (Index < 0) Or (Index >= FPropertyList.Count) Then Exit;
  FPropertyList.Delete(Index);
  RowCount:= FPropertyList.Count + 1;
  AdjustRows;
end;

procedure TEzInspector.DeletePropertyByName(const Value: String);
Var
  bp : TEzBaseProperty;
begin
  TurnOffEditor;
  bp := GetPropertyByName(Value);
  if bp <> Nil then begin
    FPropertyList.Remove(bp);
    AdjustRows;
  end;
end;

procedure TEzInspector.RemoveProperty(p: TEzBaseProperty);
begin
  FPropertyList.Remove(p);
  RowCount:= FPropertyList.Count + 1;
  AdjustRows;
end;

procedure TEzInspector.RemoveFromProvider(pl: TEzInspectorProvider);
begin
  pl.RemoveFrom(Self);
end;

procedure TEzInspector.AdjustRows;
begin
  RowCount := GetRowCount + 1;
  If RowCount = 1 Then RowCount := 2;
  FixedRows:= 1;
  Col:= 1;
  Row:= 1;
end;

procedure TEzInspector.ReplacePropertyByIndex(Index: Integer;
  p: TEzBaseProperty);
begin
  FPropertyList.ReplaceByIndex(Index, p);
  RowCount:= FPropertyList.Count + 1;
  AdjustRows;
end;

procedure TEzInspector.CMShowingChanged(var Message: TMessage);
begin
  inherited;
  if Showing then
    AdjustColWidths;
end;

procedure TEzInspector.Resize;
begin
  inherited;
  AdjustColWidths;
end;

procedure TEzInspector.MouseDown(Button: TMouseButton; Shift: TShiftState;
  X, Y: Integer);
var
  Coord: TGridCoord;
  {ACol,}test,ACol,ARow: Integer;
  bp: TEzBaseProperty;
  tm: TTextMetric;
begin
  inherited;
  Coord := MouseCoord(X, Y);
  //ACol := Coord.X;
  ARow := Coord.Y;
  if ARow = 0 Then Exit;
  ACol:= Coord.X;
  bp:= GetPropertyByRow(ARow - 1);
  if bp = Nil Then Exit;
  { now activate the cell if not read-only }
  if not bp.ReadOnly then
  begin
    Col:= 1;
    Row:= ARow;
  end;
  if bp is TEzTreeViewProperty then
  begin
    GetTextMetrics( Canvas.Handle, tm );
    test:= tm.tmAveCharWidth * (2 * (bp.IndentLevel));
    If ( X >= (test + 2) ) And ( X <= (test + 2 + FPlusBitmap.Width) ) Then
    Begin
      With TEzTreeViewProperty( bp ) Do
        FExpanded := Not FExpanded;
      AdjustRows;
      Invalidate;
    End;
  end;
  if (bp is TEzBooleanProperty) and not bp.ReadOnly And (ACol=1) then
  begin
    bp.ValBoolean:= not bp.ValBoolean;
    InvalidateRow(ARow);
  end;
end;

procedure TEzInspector.KeyDown(var Key: Word; Shift: TShiftState);
begin
  inherited;
  if ( Key = VK_F2 ) Or ( Key = VK_RETURN ) then
  begin
    { edit }
    SelectCell( Col, Row );
  end;
end;

procedure TEzInspector.RowHeightsChanged;
begin
  inherited;
  if FSettingHeight then Exit;
  FSettingHeight:= True;
  try
    if Assigned( FInplaceComboBox ) And ( DefaultRowHeight < FInplaceComboBox.Height+4 ) then
      DefaultRowHeight:= FInplaceComboBox.Height+4;
    if Assigned( FButton ) And ( DefaultRowHeight < FButton.Height+4 ) then
      DefaultRowHeight:= FButton.Height+4;
  finally
    FSettingHeight:= False;
  end;
end;

Procedure TEzInspector.FullExpand;
var
  I: Integer;
Begin
  TurnOffEditor;
  For I:= 0 to FPropertyList.Count-1 do
    If FPropertyList[I] is TEzTreeViewProperty then
      TEzTreeViewProperty( FPropertyList[I] ).FullExpand;
  AdjustRows;
  Invalidate;
End;

Procedure TEzInspector.FullCompact;
var
  I: Integer;
Begin
  TurnOffEditor;
  For I:= 0 to FPropertyList.Count-1 do
    If FPropertyList[I] is TEzTreeViewProperty then
      TEzTreeViewProperty( FPropertyList[I] ).FullCompact;
  AdjustRows;
  Invalidate;
End;

function TEzInspector.GetPropertyByRow( ARow: Integer ): TEzBaseProperty;
Var
  PropIndex : Integer;
  Function RecurseGetPropertyByRow(Const List : TEzPropertyList) : TEzBaseProperty;
    Var
      I : Integer;
  Begin
    Result := Nil;
    For I := 0 To List.Count - 1 Do
    Begin
      Inc(PropIndex);
      If PropIndex = ARow Then
        Result := List.Items[I]
      Else If (List.Items[I] Is TEzTreeViewProperty) And TEzTreeViewProperty(List.Items[I]).FExpanded Then
        Result := RecurseGetPropertyByRow((List.Items[I] As TEzTreeViewProperty).FPropertyList);
      If Result <> Nil Then Exit;
    End;
  End;
begin
  PropIndex := -1;
  Result := RecurseGetPropertyByRow(FPropertyList);
end;

function TEzInspector.GetPropertyRow(Sender: TObject): Integer;
Var
  PropCount : Integer;

  Function RecurseGetPropertyRow(List: TEzPropertyList) : Boolean;
  Var
    I : Integer;
  Begin
    Result := True;
    For I := 0 To List.Count-1 Do
    Begin
      Inc(PropCount);
      if List[I] = Sender Then Exit
      Else If List[I] Is TEzTreeViewProperty Then
        With List[I] As TEzTreeViewProperty Do
          If FExpanded And RecurseGetPropertyRow(FPropertyList) Then Exit;
    End;
    Result := False;
  End;

begin
  PropCount := -1;
  If RecurseGetPropertyRow(FPropertyList) Then
    Result := PropCount
  Else
    Result := -1;
end;

function TEzInspector.GetRowCount: Integer;
Var
  PropCount : Integer;

  Procedure RecurseGetRowCount(Const List : TEzPRopertyList);
  Var
    I : Integer;
  Begin
    For I := 0 To List.Count - 1 Do
    Begin
      Inc(PropCount);
      If List.Items[I] Is TEzTreeViewProperty Then
        With List.Items[I] As TEzTreeViewProperty Do
          If FExpanded Then
            RecurseGetRowCount(FPropertyList);
    End;
  End;

begin
  PropCount := 0;
  RecurseGetRowCount(FPropertyList);
  Result := PropCount;
end;

procedure TEzInspector.SetReadOnlyBackColor(const Value: TColor);
begin
  FReadOnlyBackColor := Value;
  if HandleAllocated then
    Invalidate;
end;

procedure TEzInspector.SetTitleCaptions(const Value: TStrings);
begin
  FTitleCaptions.Assign( Value );
end;

{ TEzIntegerProperty }

constructor TEzIntegerProperty.Create( const PropName: string );
begin
  inherited Create(PropName);
  FPropType:= ptInteger;
  FDummyNumEd:= TEzNumEd.Create( Nil );
  with FDummyNumEd do
  begin
    Digits:= 9;
    Decimals:= 0;
  end;
end;

destructor TEzIntegerProperty.Destroy;
begin
  FDummyNumEd.Free;
  inherited;
end;

function TEzIntegerProperty.GetDecimals: Integer;
begin
  result:=FDummyNumEd.decimals;
end;

function TEzIntegerProperty.GetDigits: Integer;
begin
  result:=FDummyNumEd.digits
end;

procedure TEzIntegerProperty.SetDecimals(Value:Integer);
begin
  FDummyNumEd.decimals:=value
end;

procedure TEzIntegerProperty.SetDigits(Value:Integer);
begin
  FDummyNumEd.digits:=value
end;

procedure TEzIntegerProperty.Draw(Canvas: TCanvas; ARect: TRect; AState: TGridDrawState);
var
  uFormat: Word;
  AText: string;
begin
  uFormat:= DT_SINGLELINE or DT_RIGHT or DT_VCENTER;
  if FPropType = ptInteger then
  begin
    FDummyNumEd.NumericValue:= FValInteger;
    AText:= FDummyNumEd.AsString;
  end else if FPropType = ptFloat then
  begin
    FDummyNumEd.NumericValue:= FValFloat;
    AText:= FDummyNumEd.AsString;
  end;
  if gdSelected in AState then
  begin
    Canvas.Brush.Color := clHighlight;
    Canvas.Font.Color := clHighlightText;
  end;
  DrawText( Canvas.Handle, PChar(AText), -1, ARect, uFormat )
end;

procedure TEzIntegerProperty.ShowEditor(Inspector: TEzInspector; ARect: TRect);
var
  temp:boolean;
begin
  if ReadOnly then exit;
  temp:=fmodified;
  with Inspector.FInplaceNumEd do
  begin
    FBaseProperty:= Self;
    with ARect do
      SetBounds( Left, Top, Right - Left, Bottom - Top );
    NumericValue:= Self.FValInteger;
    Decimals:= Self.FDummyNumEd.Decimals;
    Digits:= Self.FDummyNumEd.Digits;
    Editformat.RightInfo:= '';
    Visible:= True;
    Hint:= Self.FHint;
    ShowHint:= Inspector.ShowHint;
    Windows.SetFocus( Handle );
    Self.FModified:=temp;
  end;
end;

{ TEzFloatProperty }

constructor TEzFloatProperty.Create( const PropName: string );
begin
  inherited Create(PropName);
  FPropType:= ptFloat;
  with FDummyNumEd do
  begin
    Digits := 10;
    Decimals := 6;
  end;
end;

procedure TEzFloatProperty.ShowEditor(Inspector: TEzInspector; ARect: TRect);
var
  temp:boolean;
begin
  if ReadOnly then exit;
  temp:=fmodified;
  with Inspector.FInplaceNumEd do
  begin
    FBaseProperty:= Self;
    with ARect do
      SetBounds( Left, Top, Right - Left, Bottom - Top );
    NumericValue:= Self.FValFloat;
    Decimals:= Self.FDummyNumEd.Decimals;
    Digits:= Self.FDummyNumEd.Digits;
    Editformat.RightInfo:= '';
    Hint:= Self.FHint;
    ShowHint:= Inspector.ShowHint;
    Visible:= True;
    Windows.SetFocus( Handle );
    Self.FModified:=temp;
  end;
end;

{ TEzAngleProperty }

procedure TEzAngleProperty.Draw(Canvas: TCanvas; ARect: TRect; AState: TGridDrawState);
var
  uFormat: Word;
  AText: string;
begin
  uFormat:= DT_SINGLELINE or DT_RIGHT or DT_VCENTER;
  FDummyNumEd.NumericValue:= RadToDeg(FValFloat);
  AText:= FDummyNumEd.AsString + ' Deg.';
  InflateRect( ARect, -2, 0);
  if gdSelected in AState then
  begin
    Canvas.Brush.Color := clHighlight;
    Canvas.Font.Color := clHighlightText;
  end;
  DrawText( Canvas.Handle, PChar(AText), -1, ARect, uFormat )
end;

procedure TEzAngleProperty.ShowEditor(Inspector: TEzInspector; ARect: TRect);
var
  temp:boolean;
begin
  if ReadOnly then exit;
  temp:=fmodified;
  with Inspector.FInplaceNumEd do
  begin
    FBaseProperty:= Self;
    with ARect do
      SetBounds( Left, Top, Right - Left, Bottom - Top );
    NumericValue:= RadToDeg(FBaseProperty.FValFloat);
    DisplayFormat.assign( Self.FDummyNumEd.DisplayFormat);
    EditFormat.assign( Self.FDummyNumEd.EditFormat);
    EditFormat.RightInfo:= ' Deg.';
    Hint:= Self.FHint;
    ShowHint:= Inspector.ShowHint;
    Visible:= True;
    Windows.SetFocus( Handle );
    Self.FModified:=temp;
  end;
end;

{ TEzColorProperty }

constructor TEzColorProperty.Create( const PropName: string );
begin
  inherited Create(PropName);
  FPropType:= ptInteger;
  FCustomText:= SCustomTextInColorPicker;
end;

procedure TEzColorProperty.ShowEditor(Inspector: TEzInspector; ARect: TRect);
var
  temp:boolean;
begin
  if ReadOnly then exit;
  temp:=fmodified;
  with Inspector.FInplaceColorBox do
  begin
    ShowSystemColors:= Self.FShowSystemColors;
    CustomText:= Self.FCustomText;
    Caption:= Self.FCaption;
    NoneColorText:= Self.FNoneColorText;
    FBaseProperty:= Self;
    with ARect do
      SetBounds( Left, Top, Right - Left, Bottom - Top );
    Selected:= Self.FValInteger;
    Hint:= Self.FHint;
    ShowHint:= Inspector.ShowHint;
    Visible:= True;
    Windows.SetFocus( Handle );
    Self.FModified:=temp;
  end;
end;

procedure TEzColorProperty.Draw(Canvas: TCanvas; ARect: TRect; AState: TGridDrawState);
var
  R: TRect;
begin
  with Canvas do
  begin
    Pen.Width:= 1;
    Pen.Color:= clBtnShadow;
    If ValInteger = clNone then
      Brush.Style:= bsClear
    else
    begin
      Brush.Style:= bsSolid;
      Brush.Color:= ValInteger;
    end;
    R:= ARect;
    Windows.InflateRect(R,-2,-2);
    with R do
      Rectangle(left, top, right, bottom );
    If ValInteger = clNone then
    begin
      DrawText( Canvas.Handle, PChar(SNoneColorTextInColorPicker), -1, R, DT_CENTER or DT_SINGLELINE or DT_VCENTER );
    end;
  end;
end;

function TEzColorProperty.GetCaption: string;
begin
  Result:= FCaption;
end;

function TEzColorProperty.GetCustomText: string;
begin
  Result:= FCustomText;
end;

function TEzColorProperty.GetNoneColorText: string;
begin
  Result:= FNoneColorText;
end;

procedure TEzColorProperty.SetCaption(const Value: string);
begin
  FCaption:=value;
end;

procedure TEzColorProperty.SetCustomText(const Value: string);
begin
  FCustomText:=value;
end;

procedure TEzColorProperty.SetNoneColorText(const Value: string);
begin
  FNoneColorText:=value;
end;

function TEzColorProperty.GetShowSystemColors: Boolean;
begin
  Result:= FShowSystemColors
end;

procedure TEzColorProperty.SetShowSystemColors(const Value: Boolean);
begin
  FShowSystemColors:=value;
end;

{ TEzStringProperty }

constructor TEzStringProperty.Create( const PropName: string );
begin
  inherited Create(PropName);
  FPropType:= ptString;
end;

procedure TEzStringProperty.ShowEditor(Inspector: TEzInspector; ARect: TRect);
var
  temp:boolean;
begin
  if ReadOnly then exit;
  temp:=fmodified;
  with Inspector.FInplaceEdit do
  begin
    FBaseProperty:= Self;
    with ARect do
      SetBounds( Left, Top, Right - Left, Bottom - Top );
    Height:= Inspector.DefaultRowHeight;
    Text:= Self.FValString;
    Hint:= Self.FHint;
    ShowHint:= Inspector.ShowHint;
    Visible:= True;
    Windows.SetFocus( Handle );
    Self.FModified:=temp;
  end;
end;

{ TEzLinetypeProperty }

constructor TEzLinetypeProperty.Create( const PropName: string );
begin
  inherited Create(PropName);
  FPropType:= ptInteger;
end;

procedure TEzLinetypeProperty.Draw(Canvas: TCanvas; ARect: TRect; AState: TGridDrawState);
var
  FGrapher: TEzGrapher;
  DrawState: TOwnerDrawState;
begin
  FGrapher:= TEzGrapher.Create(10,adScreen);
  try
    if ValInteger < 0 then Exit;

    //Canvas.Font.Assign( Self.Font );

    DrawState:= [];
    if (gdSelected in AState) then
      Include( DrawState, odSelected );
    if (gdFocused in AState) then
      Include( DrawState, odFocused );

    EzMiscelCtrls.DrawLineType( FGrapher, Canvas, ValInteger,
      ARect, DrawState, clBlack, clBtnFace, False, 0, 2, False, False, False );

  finally
    FGrapher.free;
  end;
end;

procedure TEzLinetypeProperty.ShowEditor(Inspector: TEzInspector; ARect: TRect);
var
  temp:boolean;
begin
  if ReadOnly then exit;
  temp:=fmodified;
  with Inspector.FInplaceLinetypeBox do
  begin
    //ItemHeight:= 20;
    FBaseProperty:= Self;
    with ARect do
      SetBounds( Left, Top, Right - Left, Bottom - Top );
    ItemIndex:= Self.ValInteger;
    Hint:= Self.FHint;
    ShowHint:= Inspector.ShowHint;
    Visible:= True;
    Windows.SetFocus( Handle );
    Self.FModified:=temp;
  end;
end;

{ TEzBrushstyleProperty }

constructor TEzBrushstyleProperty.Create( const PropName: string );
begin
  inherited Create(PropName);
  FPropType:= ptInteger;
end;

procedure TEzBrushstyleProperty.Draw(Canvas: TCanvas; ARect: TRect; AState: TGridDrawState);
var
  FGrapher: TEzGrapher;
  DrawState: TOwnerDrawState;
begin
  FGrapher:= TEzGrapher.Create(10,adScreen);
  try
    DrawState:= [];
    if (gdSelected in AState) then
      Include( DrawState, odSelected );
    if (gdFocused in AState) then
      Include( DrawState, odFocused );

    EzMiscelCtrls.DrawPattern( Canvas, ValInteger, clBlack, clWhite, clBtnFace,
      ARect, False, DrawState, False, True, False );
  finally
    FGrapher.free;
  end;
end;

procedure TEzBrushstyleProperty.ShowEditor(Inspector: TEzInspector; ARect: TRect);
var
  temp:boolean;
begin
  if ReadOnly then exit;
  temp:=fmodified;
  with Inspector.FInplaceBrushstyleBox do
  begin
    //ItemHeight:= 20;
    FBaseProperty:= Self;
    with ARect do
      SetBounds( Left, Top, Right - Left, Bottom - Top );
    ItemIndex:= Self.ValInteger;
    Hint:= Self.FHint;
    ShowHint:= Inspector.ShowHint;
    Visible:= True;
    Windows.SetFocus( Handle );
    Self.FModified:=temp;
  end;
end;

{ TEzBlocksProperty }

constructor TEzBlocksProperty.Create( const PropName: string );
begin
  inherited Create(PropName);
  FPropType:= ptString;
end;

procedure TEzBlocksProperty.Draw(Canvas: TCanvas; ARect: TRect; AState: TGridDrawState);
var
  Block: TEzSymbol;
  Stream: TStream;
  FGrapher: TEzGrapher;
  temp: string;
  DrawState: TOwnerDrawState;
begin
  FGrapher:= TEzGrapher.Create(10,adScreen);
  // load the block from disk
  Block:= TEzSymbol.Create(Nil);
  if Length(ExtractFilePath(FValString))=0 then
    temp:= AddSlash(Ez_Preferences.CommonSubDir) + FValString
  else
    temp:= FValString;
  Stream:= TFileStream.Create(temp, fmOpenRead or fmShareDenyNone);
  Try
    Block.LoadFromStream(Stream);
  Except
    Block.Free;
    Stream.Free;
    Raise;
  End;
  try
    DrawState:= [];
    if (gdSelected in AState) then
      Include( DrawState, odSelected );
    if (gdFocused in AState) then
      Include( DrawState, odFocused );

    EzMiscelCtrls.DrawBlock(FGrapher, Canvas, ARect, DrawState, clBtnFace,
      Block, True, False );
  finally
    FGrapher.free;
    Block.free;
    Stream.free;
  end;
end;

procedure TEzBlocksProperty.ShowEditor(Inspector: TEzInspector; ARect: TRect);
var
  temp:boolean;
begin
  if ReadOnly then exit;
  temp:=fmodified;
  with Inspector.FInplaceBlocksBox do
  begin
    //ItemHeight:= 35;
    FBaseProperty:= Self;
    with ARect do
      SetBounds( Left, Top, Right - Left, Bottom - Top );
    ItemIndex:= BlockList.IndexOf( Self.FValString );
    Hint:= Self.FHint;
    ShowHint:= Inspector.ShowHint;
    Visible:= True;
    Windows.SetFocus( Handle );
    Self.FModified:=temp;
  end;
end;

{ TEzSymbolProperty }

constructor TEzSymbolProperty.Create( const PropName: string );
begin
  inherited Create(PropName);
  FPropType:= ptInteger;
end;

procedure TEzSymbolProperty.Draw(Canvas: TCanvas; ARect: TRect; AState: TGridDrawState);
var
  FGrapher: TEzGrapher;
  DrawState: TOwnerDrawState;
begin
  FGrapher:= TEzGrapher.Create(10,adScreen);
  try
    DrawState:= [];
    if (gdSelected in AState) then
      Include( DrawState, odSelected );
    if (gdFocused in AState) then
      Include( DrawState, odFocused );

    EzMiscelCtrls.DrawSymbol( FGrapher, Canvas, ValInteger,
      ARect, DrawState, clBtnFace, False, False, True, False );
  finally
    FGrapher.free;
  end;
end;

procedure TEzSymbolProperty.ShowEditor(Inspector: TEzInspector; ARect: TRect);
var
  temp:boolean;
begin
  if ReadOnly then exit;
  temp:=fmodified;
  with Inspector.FInplaceSymbolsBox do
  begin
    FBaseProperty:= Self;
    with ARect do
      SetBounds( Left, Top, Right - Left, Bottom - Top );
    If Self.ValInteger < Ez_Symbols.Count Then
      ItemIndex:= Self.ValInteger
    else If Ez_Symbols.Count > 0 Then
      ItemIndex:= 0;
    Hint:= Self.FHint;
    ShowHint:= Inspector.ShowHint;
    Visible:= True;
    Windows.SetFocus( Handle );
    Self.FModified:=temp;
  end;
end;

{ TEzBooleanProperty }

constructor TEzBooleanProperty.Create(const PropName: string);
begin
  inherited Create(PropName);
  FPropType:= ptBoolean;
end;

Procedure TEzBooleanProperty.Draw(Canvas: TCanvas; ARect: TRect; AState: TGridDrawState);
var
  R: TRect;
begin
  R:= ARect;
  InflateRect(R,-2,-2);
  If FValBoolean then
    DrawFrameControl(Canvas.Handle, R, DFC_BUTTON, DFCS_BUTTONCHECK or DFCS_CHECKED	)
  else
    DrawFrameControl(Canvas.Handle, R, DFC_BUTTON, DFCS_BUTTONCHECK	);
end;

{procedure TEzBooleanProperty.ShowEditor(Inspector: TEzInspector; ARect: TRect);
var
  oldval: boolean;
  temp:boolean;
begin
  if ReadOnly then exit;
  temp:=fmodified;
  with Inspector.FInplaceComboBox do
  begin
    Style:= csDropDownList;//***gsDropDownList;
    FBaseProperty:= Self;
    oldval:= self.FValBoolean;
    Items.Clear;
    Items.Add('False');
    Items.Add('True');
    Self.FValBoolean:=oldval;
    ItemIndex:= Abs(Ord(Self.FValBoolean));
    //***DefaultColWidth:= Width;
    Width:= ARect.Right - ARect.Left;
    Height:= EzLib.IMin( Screen.Height, ItemHeight * (Items.Count+2));  // dummy
    Left:= ARect.Left;
    Top:= ARect.Top;
    Hint:= Self.FHint;
    ShowHint:= Inspector.ShowHint;
    Visible:= True;
    Windows.SetFocus( Handle );
    Self.FModified:=temp;
  end;
end; }


{ TEzBitmapProperty }

constructor TEzBitmapProperty.Create(const PropName: string);
begin
  inherited Create(PropName);
  FPropType:= ptString;
  FUseEditButton:= True;
  FBitmap:= TBitmap.Create;
end;

function TEzBitmapProperty.AsString: string;
begin
  Result:= '(Bitmap)';
end;

procedure TEzBitmapProperty.Edit(Inspector: TEzInspector);
begin
  if ReadOnly then exit;
  with TOpenPictureDialog.Create(Nil) do
    try
      if not Execute then Exit;
      Self.FBitmap.LoadFromFile(FileName);
      Self.Changed;
    finally
      free;
    end;
end;

destructor TEzBitmapProperty.Destroy;
begin
  FBitmap.free;
  inherited destroy;
end;

{$IFDEF BCB}
function TEzBitmapProperty.GetBitmap: TBitmap;
begin
  Result := FBitmap;
end;
{$ENDIF}

{ TEzEnumerationProperty }

constructor TEzEnumerationProperty.Create(const PropName: string);
begin
  inherited create(Propname);
  FPropType:= ptInteger;
  FStrings:= TStringList.Create;
end;

destructor TEzEnumerationProperty.Destroy;
begin
  FStrings.free;
  inherited destroy;
end;

function TEzEnumerationProperty.AsString: string;
begin
  Result:= '';
  if (ValInteger < 0) or (ValInteger > FStrings.Count-1) then Exit;
  Result:= FStrings[ValInteger];
end;

procedure TEzEnumerationProperty.ShowEditor(Inspector: TEzInspector; ARect: TRect);
var
  oldval: Integer;
  Temp:boolean;
begin
  if ReadOnly then exit;
  temp:=fmodified;
  with Inspector.FInplaceComboBox do
  begin
    Style:= csDropDownList;//***gsDropDownList;
    FBaseProperty:= Self;
    oldval:= FValInteger;
    Items.Clear;
    Items.assign(Self.FStrings);
    FValInteger:= oldval;
    if ValInteger < 0 then ValInteger:= 0;
    ItemIndex:= ValInteger;
    //***DefaultColWidth:= Width;
    Width:= ARect.Right - ARect.Left;
    Height:= EzLib.IMin( Screen.Height, ItemHeight * EzLib.IMin(20,Items.Count+2));  // dummy
    Left:= ARect.Left;
    Top:= ARect.Top;
    Hint:= Self.FHint;
    ShowHint:= Inspector.ShowHint;
    Visible:= True;
    Windows.SetFocus( Handle );
    Self.FModified:=temp;
  end;
end;

{$IFDEF BCB}
function TEzEnumerationProperty.GetStrings: TStrings;
begin
  Result := FStrings;
end;
{$ENDIF}

{ TEzDefineLocalBitmapProperty }

constructor TEzDefineLocalBitmapProperty.Create(const PropName: string);
begin
  inherited create(Propname);
  FProptype:= ptString;
  FUseEditButton:= true;
end;

procedure TEzDefineLocalBitmapProperty.Edit(Inspector: TEzInspector);
begin
  if ReadOnly then exit;
  Self.ValString := SelectCommonElement(AddSlash(Ez_Preferences.CommonSubDir), '', liBitmaps);
  Inspector.FInplaceEdit.Text:= Self.ValString;
end;

{ TEzDefineAnyLocalImageProperty }

constructor TEzDefineAnyLocalImageProperty.Create(const PropName: string);
begin
  inherited create(Propname);
  FProptype:= ptString;
  FUseEditButton:= true;
end;

procedure TEzDefineAnyLocalImageProperty.Edit(Inspector: TEzInspector);
begin
  if ReadOnly then exit;
  Self.ValString := SelectCommonElement(AddSlash(Ez_Preferences.CommonSubDir), '', liAllImages);
  Inspector.FInplaceEdit.Text:= Self.ValString;
end;

{ TEzFontNameProperty }

constructor TEzFontNameProperty.Create(const PropName: string);
begin
  inherited Create(PropName);
  FPropType:= ptString;
end;

{$IFDEF BCB}
function TEzFontNameProperty.GetTrueType: Boolean;
begin
  Result := FTrueType;
end;

procedure TEzFontNameProperty.SetTrueType(const Value: Boolean);
begin
  FTrueType := Value;
end;
{$ENDIF}

procedure TEzFontNameProperty.ShowEditor(Inspector: TEzInspector; ARect: TRect);
var
  oldval: string;
  I: Integer;
  temp:boolean;
begin
  if ReadOnly then exit;
  temp:=fmodified;
  with Inspector.FInplaceComboBox do
  begin
    Style:= csDropDownList;//***gsDropDownList;
    FBaseProperty:= Self;
    oldval:= Self.FValString;
    Items.Clear;
    if FTrueType then
    begin
      Items.Assign(Screen.Fonts);
    end else
    begin
      for I:= 0 to Ez_VectorFonts.Count-1 do
        Items.Add(Ez_VectorFonts[I].Name);
    end;
    Self.FValString:=oldval;
    ItemIndex:= Items.IndexOf( Self.FValString );
    //Width:= ARect.Right - ARect.Left;
    //***DefaultColWidth:= Width;
    Width:= ARect.Right - ARect.Left;
    Height:= EzLib.IMin( Screen.Height, ItemHeight * EzLib.IMin(20,Items.Count+2));  // dummy
    Left:= ARect.Left;
    Top:= ARect.Top;
    Hint:= Self.FHint;
    ShowHint:= Inspector.ShowHint;
    Visible:= True;
    Windows.SetFocus( Handle );
    Self.FModified:=temp;
  end;
end;

{ TEzDateProperty }

constructor TEzDateProperty.Create(const PropName: string);
begin
  inherited Create(PropName);
  FPropType:= ptDate;
end;

procedure TEzDateProperty.ShowEditor(Inspector: TEzInspector; ARect: TRect);
var
  temp:boolean;
begin
  if ReadOnly then exit;
  temp:=fmodified;
  with Inspector.FInplaceDateTimePicker do
  begin
    FBaseProperty:= Self;
    with ARect do
      SetBounds( Left, Top, Right - Left, Bottom - Top );
    Height:= Inspector.DefaultRowHeight;

    Date:= Self.FValDateTime;
    Kind:= dtkDate;

    Hint:= Self.FHint;
    ShowHint:= Inspector.ShowHint;
    
    Visible:= True;
    Windows.SetFocus( Handle );
    Self.FModified:=temp;
  end;
end;

{ TEzTimeProperty }

constructor TEzTimeProperty.Create(const PropName: string);
begin
  inherited Create(PropName);
  FPropType:= ptDate;
end;

procedure TEzTimeProperty.ShowEditor(Inspector: TEzInspector; ARect: TRect);
var
  temp:boolean;
begin
  if ReadOnly then exit;
  temp:=fmodified;
  with Inspector.FInplaceDateTimePicker do
  begin
    FBaseProperty:= Self;
    with ARect do
      SetBounds( Left, Top, Right - Left, Bottom - Top );
    Height:= Inspector.DefaultRowHeight;

    Date:= Self.FValDateTime;
    Kind:= dtkTime;

    Hint:= Self.FHint;
    ShowHint:= Inspector.ShowHint;

    Visible:= True;
    Windows.SetFocus( Handle );
    Self.FModified:=temp;
  end;
end;

{ TEzDummyProperty - used for showing info on the property inspector }

constructor TEzDummyProperty.Create(const PropName: string);
begin
  inherited Create(PropName);
  FPropType:= ptString;
end;

{ TEzMemoProperty }

constructor TEzMemoProperty.Create(const PropName: string);
begin
  inherited Create(PropName);
  FPropType:= ptString;
  FUseEditButton:= true;
end;

function TEzMemoProperty.AsString: string;
begin
  Result:= '(Strings)';
end;

procedure TEzMemoProperty.Edit;
var
  stream: TStream;
begin
  if ReadOnly then exit;
  stream:= TMemoryStream.create;
  try
    with TfrmMemoEditor.Create(Nil) do
      try
        FDBTable.MemoLoadN( FFieldNo, stream );
        stream.Position:= 0;
        Memo1.Lines.LoadFromStream( stream );
        if not (ShowModal=mrOk) then Exit;
        TMemoryStream(stream).Clear;
        Memo1.Lines.SaveToStream( stream );
        stream.Position:= 0;
        FDBTable.Edit;
        FDBTable.MemoSaveN( FFieldNo, stream );
        FDBTable.Post;
        Self.Changed;
      finally
        free;
      end;
  finally
    stream.free;
  end;
end;

{$IFDEF BCB}
function TEzMemoProperty.GetDBTable: TEzBaseTable;
begin
  Result := FDBTable;
end;

function TEzMemoProperty.GetFieldNo: Integer;
begin
  Result := FFieldNo;
end;

procedure TEzMemoProperty.SetDBTable(const Value: TEzBaseTable);
begin
  FDBTable := Value;
end;

procedure TEzMemoProperty.SetFieldNo(const Value: Integer);
begin
  FFieldNo := Value;
end;
{$ENDIF}

{ TEzGraphicProperty }

constructor TEzGraphicProperty.Create(const PropName: string);
begin
  inherited Create(PropName);
  FPropType:= ptString;
  FUseEditButton:= true;
end;

function TEzGraphicProperty.AsString: string;
begin
  Result:= '(Graphic)';
end;

procedure TEzGraphicProperty.Edit;
var
  stream: TStream;
  TmpBitmap: TBitmap;
  TmpFileName: string;
begin
  if ReadOnly then exit;
  stream:= TMemoryStream.create;
  TmpBitmap:= TBitmap.Create;
  try
    With TfrmPict1.Create( Application ) Do
      try
        FDBTable.MemoLoadN( FFieldNo, stream );
        if stream.size > 0 then
        begin
          stream.Position:= 0;
          { save to a temporary file }
          TmpBitmap.LoadFromStream( stream );
          TmpFileName:= ChangeFileExt(ezsystem.GetTemporaryFileName( 'bmp' ), '.bmp');
          TmpBitmap.SaveToFile( TmpFileName );
        end else
          TmpFileName:= '';
        If Not ( Enter( idPersistBitmap, TmpFileName, '' ) = mrOk ) Then Exit;
        TmpBitmap.LoadFromFile( EditFileName );
        TMemoryStream(stream).Clear;
        TmpBitmap.SaveToStream( stream );
        stream.Position:= 0;
        FDBTable.Edit;
        FDBTable.MemoSaveN( FFieldNo, stream );
        FDBTable.Post;
        Self.Changed;
      finally
        free;
      end;
  finally
    stream.free;
    TmpBitmap.free;
    if (Length(TmpFileName) > 0) and FileExists(TmpFileName) then
      SysUtils.DeleteFile( TmpFileName );
  end;
end;

{$IFDEF BCB}
function TEzGraphicProperty.GetDBTable: TEzBaseTable;
begin
  Result := FDBTable;
end;

function TEzGraphicProperty.GetFieldNo: Integer;
begin
  Result := FFieldNo;
end;

procedure TEzGraphicProperty.SetDBTable(const Value: TEzBaseTable);
begin
  FDBTable := Value;
end;

procedure TEzGraphicProperty.SetFieldNo(const Value: Integer);
begin
  FFieldNo := Value;
end;
{$ENDIF}

{ TEzSelectFolderProperty }

constructor TEzSelectFolderProperty.Create(const PropName: string);
begin
  inherited Create(PropName);
  FUseEditButton:= true;
end;

procedure TEzSelectFolderProperty.Edit(Inspector: TEzInspector);
begin
  if ReadOnly then exit;
  With TBrowseForFolder.Create( GetParentForm(Inspector) ) Do
  Try
    Flags:= [bf_ReturnOnlyFSDIRS];
    FolderName:= FValString;
    If Execute Then
    begin
      Self.FValString := FolderName;
      Inspector.FInplaceEdit.Text:= Self.ValString;
      Self.Changed;
    end;
  Finally
    Free;
  End;
end;

{ TEzExpressionProperty }

constructor TEzExpressionProperty.Create(const PropName: string);
begin
  inherited Create(PropName);
  FUseEditButton:= true;
end;

procedure TEzExpressionProperty.Edit(Inspector: TEzInspector);
begin
  if ReadOnly or (FGis=Nil) or (FLayerName = '') then exit;
  with TfrmExprDlg.Create(Nil) do
    try
      if Enter(Self.FValString, FGis, FGis.Layers.LayerByName(FLayerName)) = mrOk then
      begin
        FValString:= Memo1.Lines.Text;
        Inspector.FInplaceEdit.Text:= FValString;
        Self.Changed;
      end;
    finally
      free;
    end;
end;

{$IFDEF BCB}
function TEzExpressionProperty.GetGis: TEzBaseGis;
begin
  Result := FGIS;
end;

function TEzExpressionProperty.GetLayerName: string;
begin
  Result := FLayerName;
end;

procedure TEzExpressionProperty.SetGis(const Value: TEzBaseGis);
begin
  FGis := Value;
end;

procedure TEzExpressionProperty.SetLayerName(const Value: string);
begin
  FLayerName := Value;
end;
{$ENDIF}

{ TEzPointsProperty }

constructor TEzPointsProperty.Create(const PropName: string);
begin
  inherited Create(PropName);
  FPropType:= ptString;
  FUseEditButton:= True;
  FVector:= TEzVector.Create(4);
end;

destructor TEzPointsProperty.destroy;
begin
  FVector.free;
  inherited;
end;

function TEzPointsProperty.AsString: string;
begin
  Result:= '(Points)';
end;

procedure TEzPointsProperty.Edit(Inspector: TEzInspector);
begin
  if ReadOnly then Exit;
  if FVector.CanGrow then
  begin
    { use a memo in order to edit this property }
    with TfrmMemoEditor.Create(Nil) do
      try
        { define the vector as text }
        Screen.Cursor:= crHourglass;
        Memo1.Lines.Text:= Crlf + FVector.AsString + Crlf ;
        Screen.Cursor:= crDefault;
        Memo1.Font.Name:= 'Courier New';
        Memo1.Font.Size:= 9;
        if not (ShowModal=mrOk) then Exit;
        { parse the vector by simply assigning }
        if Memo1.Modified then
        begin
          FVector.AsString:= Memo1.Lines.Text;

          Self.Changed;
        end;
      finally
        free;
      end;
  end;
end;

procedure TEzPointsProperty.SetVector(const Value: TEzVector);
begin
  FVector.Assign( Value );
end;

{$IFDEF BCB}
function TEzPointsProperty.GetVector: TEzVector;
begin
  Result := FVector;
end;
{$ENDIF}

{ TEzLongTextProperty }

constructor TEzLongTextProperty.Create(const PropName: string);
begin
  inherited Create(PropName);
  FUseEditButton:= true;
end;

procedure TEzLongTextProperty.Edit(Inspector: TEzInspector);
begin
  if ReadOnly then exit;
  with TfrmMemoEditor.Create(Nil) do
    try
      Memo1.Lines.Text:= Self.FValString;
      if not (ShowModal=mrOk) then Exit;
      Self.FValString:= Memo1.Lines.Text;
      Inspector.FInplaceEdit.Text:= Self.FValString;
      Self.Changed;
    finally
      free;
    end;
end;

{ TEzSetProperty }

constructor TEzSetProperty.Create(const PropName: string);
begin
  inherited Create(PropName);
  FPropType:= ptString;
  FStrings:= TStringList.Create;
  TStringList( FStrings ).OnChange:= StringsChanged;
  FReadOnly:= False;
end;

destructor TEzSetProperty.Destroy;
begin
  FStrings.Free;
  inherited;
end;

procedure TEzSetProperty.ThisChanged( Sender: TObject );
var
  I : Integer;
begin
  { Fired when one of the subproperties changed }
  for I := 0 to FPropertyList.Count - 1 do
    if FPropertyList[I] = Sender then
    begin
      SetDefined( I, FPropertyList[I].ValBoolean );
      Break;
    end;
  Changed;
end;

procedure TEzSetProperty.StringsChanged( Sender: TObject );
var
  p: TEzBaseProperty;
  I: Integer;
Begin
  FPropertyList.Clear;
  { Repopulate the list of subproperties }
  for I := 0 to FStrings.Count-1 do
  begin
    p := TEzBooleanProperty.Create( FStrings[I] );
    Self.AddProperty( p );
    p.ValBoolean := GetDefined( I );
    p.OnChange := ThisChanged;
  end;
End;

function TEzSetProperty.AsString: string;
var
  I: Integer;
  sSetVal: string;
begin
  sSetVal:= '';
  for I:= 0 to FStrings.Count-1 do
    if GetDefined(I) then
    begin
      sSetVal:= sSetVal + FStrings[I] + ',';
    end;
  if Length(sSetVal) > 0 then
    sSetVal:= Copy(sSetVal,1,Length(sSetVal)-1);
  Result := '['+sSetVal+ ']';
end;

function TEzSetProperty.GetDefined(Index: Integer): boolean;
begin
  Result:= False;
  if (Index < 0) Or (Index >FPropertyList.Count-1) then Exit;
  Result:= FPropertyList[Index].ValBoolean;
end;

procedure TEzSetProperty.SetDefined(Index: Integer; value: boolean);
begin
  if (Index < 0) Or (Index >FPropertyList.Count-1) then Exit;
  FPropertyList[Index].ValBoolean:= value;
end;

{$IFDEF BCB}
function TEzSetProperty.GetStrings: TStrings;
begin
  Result := FStrings;
end;
{$ENDIF}

{ TEzPropertyList }
constructor TEzPropertyList.Create;
begin
  inherited;
  FList:= TList.Create;
end;

destructor TEzPropertyList.Destroy;
begin
  Clear;
  FList.Free;
  inherited;
end;

function TEzPropertyList.Add(Item: TEzBaseProperty): Integer;
begin
  Result:= FList.Add( Item );
end;

procedure TEzPropertyList.Clear;
var
  I: Integer;
begin
  for I:= 0 to FList.Count-1 do
    with TEzBaseProperty( FList[I] ) do
      if Not IsPropertyOfList then Free;
  FList.clear;
end;

function TEzPropertyList.Count: Integer;
begin
  Result:= FList.Count;
end;

procedure TEzPropertyList.Delete(Index: Integer);
begin
  if (Index < 0) or (Index > FList.Count-1) then Exit;
  with TEzBaseproperty( FList[Index] ) do
    if Not IsPropertyOfList then Free;
  FList.Delete(Index);
end;

procedure TEzPropertyList.Exchange(Index1, Index2: Integer);
begin
  FList.Exchange(Index1, Index2);
end;

function TEzPropertyList.Get(Index: Integer): TEzBaseProperty;
begin
  Result:= TEzBaseProperty( FList[Index] );
end;

function TEzPropertyList.IndexofName(const Value: string): Integer;
var
  I: Integer;
begin
  Result:= -1;
  for I:= 0 to FList.Count-1 do
    if AnsiCompareText(TEzBaseProperty( FList[I] ).FPropName, Value) = 0 then
    begin
      Result:= I;
      Exit;
    end;
end;

function TEzPropertyList.Indexof(Item: TEzBaseProperty): Integer;
var
  I: Integer;
begin
  Result:= -1;
  for I:= 0 to FList.Count-1 do
    if FList[I] = Item then
    begin
      Result:= I;
      Exit;
    end;
end;

procedure TEzPropertyList.Insert(Index: Integer; Value: TEzBaseProperty);
begin
  FList.Insert(Index, Value);
end;

procedure TEzPropertyList.Put(Index: Integer; const Value: TEzBaseProperty);
begin
  if (Index < 0) or (Index > FList.Count-1) then Exit;
  with TEzBaseProperty( FList[Index] ) do
    if Not IsPropertyOfList then Free;
  FList[Index]:= Value;
end;

procedure TEzPropertyList.SortByName;
var
  sl: TStringList;
  I: Integer;
begin
  sl:= TStringList.create;
  try
    for I:= 0 to FList.Count-1 do
      sl.AddObject( TEzBaseProperty( FList[I] ).FPropName, FList[I]);
    sl.Sort;
    FList.Clear;
    for I:= 0 to sl.Count-1 do begin
      FList.Add( sl.Objects[I] );
      if sl.Objects[I] Is TEzTreeViewProperty Then
        TEzTreeViewProperty(sl.Objects[I]).FPropertyList.SortByName;
    end;
  finally
    sl.free;
  end;
end;

function TEzPropertyList.Remove(Item: TEzBaseProperty): Integer;
  Function RecurseRemove(List :TList) : Integer;
  Var
    I : Integer;
  Begin
    Result := -1;
    For I := 0 To FList.Count - 1 Do Begin
      If Item = List[I] Then Begin
        List.Delete(I);
        Result := I;
        Exit;
      End Else If TEzBaseProperty(List[I]) Is TEzTreeViewProperty Then Begin
        Result := RecurseRemove(TEzTreeViewProperty(List[I]).FPropertyList.FList);
        if Result >= 0 Then Exit;
      End;
    End;
  End;
begin
  Result:= RecurseRemove(FList);
  if Not Item.IsPropertyOfList then Item.Free;
end;


{ TEzPropertyItem }

//--------------------------------------------------------------------------
function CreatePropertyByType(PropType: TEzPropertyTypeC;
  Clone : TEzBaseProperty; const Name : String; Action : TCreateAction): TEzBaseProperty;
Var
  Count : Integer;
begin
  Result := Nil;
  Case Ord(PropType) Of
    0: Result := TEzAngleProperty.Create(Name);
    1: Result := TEzBitmapProperty.Create(Name);
    2: Result := TEzBlocksProperty.Create(Name);
    3: Result := TEzBooleanProperty.Create(Name);
    4: Result := TEzBrushstyleProperty.Create(Name);
    5: Result := TEzColorProperty.Create(Name);
    6: Result := TEzDateProperty.Create(Name);
    7: Result := TEzDefineAnyLocalImageProperty.Create(Name);
    8: Result := TEzDefineLocalBitmapProperty.Create(Name);
   9: Result := TEzDummyProperty.Create(Name);
   10: If Action = caClone Then Begin
         Result := TEzEnumerationProperty.Create(Name);
         For Count := 0 To TEzEnumerationProperty(Clone).Strings.Count - 1 Do
           TEzEnumerationProperty(Result).Strings.Add(TEzEnumerationProperty(Clone).Strings[Count]);
       End Else Result := TEzEnumerationProperty.Create(Name);
   11: Result := TEzExpressionProperty.Create(Name);
   12: Result := TEzFloatProperty.Create(Name);
   13: Result := TEzFontNameProperty.Create(Name);
   14: Result := TEzGraphicProperty.Create(Name);
   15: Result := TEzIntegerProperty.Create(Name);
   16: Result := TEzLinetypeProperty.Create(Name);
   17: Result := TEzLongTextProperty.Create(Name);
   18: Result := TEzMemoProperty.Create(Name);
   19: Result := TEzPointsProperty.Create(Name);
   20: Result := TEzSelectFolderProperty.Create(Name);
   21: If Action = caClone Then Begin
         Result := TEzSetProperty.Create(Name);
         For Count := 0 To TEzSetProperty(Clone).Strings.Count - 1 Do Begin
           TEzSetProperty(Result).Strings.Add(TEzSetProperty(Clone).Strings[Count]);
           TEzSetProperty(Result).Defined[Count] := TEzSetProperty(Clone).Defined[Count];
         End
       End Else Result := TEzSetProperty.Create(Name);
   22: Result := TEzStringProperty.Create(Name);
   23: Result := TEzSymbolProperty.Create(Name);
   24: Result := TEzTimeProperty.Create(Name);
  End
End;


//------------------------------TEzInspectorListProvider--------------------

procedure TEzPropertyItem.Assign(Source: TPersistent);
begin
  If Source Is TEzPropertyItem Then
  Begin
    FBaseProperty := CreatePropertyByType(TEzPropertyItem(Source).PropertyType,
                                          TEzPropertyItem(Source).FBaseProperty,
                                          TEzPropertyItem(Source).FBaseProperty.PropName,
                                          caClone);
    PropertyValue:= TEzPropertyItem(Source).PropertyValue;
  End
  Else
    Inherited Assign( Source );
end;


constructor TEzPropertyItem.Create(Collection : TCollection);
begin
  FBaseProperty := TEzAngleProperty.Create('PropName');
  FSetEnumCollection := TEzBooleanCollection.Create(Self);
  FBaseProperty.IsPropertyOfList := True;
  PropertyValue := '3.1416';
  inherited;
end;

destructor TEzPropertyItem.Destroy;
begin
  inherited;
  If Assigned(FSetEnumCollection) Then
    FSetEnumCollection.Free;
  FBaseProperty.Free;
end;


function TEzPropertyItem.GetDisplayName: String;
begin
  if FBaseProperty.PropName = '' then
    Result:= '(Empty)'
  else
    Result:= FBaseProperty.FPropName;
end;

function TEzPropertyItem.GetFValBoolean: Boolean;
begin
  Result := FBaseProperty.FValBoolean;
end;

function TEzPropertyItem.GetFValDateTime: TDateTime;
begin
  Result := FBaseProperty.FValDateTime;
end;

function TEzPropertyItem.GetFValFloat: Double;
begin
  Result := FBaseProperty.FValFloat;
end;

function TEzPropertyItem.GetFValInteger: Integer;
begin
  Result := FBaseProperty.FValInteger;
end;

function TEzPropertyItem.GetPropertyName: string;
begin
  Result := FBaseProperty.FPropName;
end;

Function PropertyTypeOf(BaseProperty: TEzBaseProperty): TEzPropertyTypeC;
Begin
  Result := TEzPropertyTypeC(0);
       If BaseProperty Is TEzAngleProperty                Then Result := TEzPropertyTypeC(0)
  Else If BaseProperty Is TEzBitmapProperty               Then Result := TEzPropertyTypeC(1)
  Else If BaseProperty Is TEzBlocksProperty               Then Result := TEzPropertyTypeC(2)
  Else If BaseProperty Is TEzBooleanProperty              Then Result := TEzPropertyTypeC(3)
  Else If BaseProperty Is TEzBrushstyleProperty           Then Result := TEzPropertyTypeC(4)
  Else If BaseProperty Is TEzColorProperty                Then Result := TEzPropertyTypeC(5)
  Else If BaseProperty Is TEzDateProperty                 Then Result := TEzPropertyTypeC(6)
  Else If BaseProperty Is TEzDefineAnyLocalImageProperty  Then Result := TEzPropertyTypeC(7)
  Else If BaseProperty Is TEzDefineLocalBitmapProperty    Then Result := TEzPropertyTypeC(8)
  Else If BaseProperty Is TEzDummyProperty                Then Result := TEzPropertyTypeC(9)
  Else If BaseProperty Is TEzEnumerationProperty          Then Result := TEzPropertyTypeC(10)
  Else If BaseProperty Is TEzExpressionProperty           Then Result := TEzPropertyTypeC(11)
  Else If BaseProperty Is TEzFloatProperty                Then Result := TEzPropertyTypeC(12)
  Else If BaseProperty Is TEzFontNameProperty             Then Result := TEzPropertyTypeC(13)
  Else If BaseProperty Is TEzGraphicProperty              Then Result := TEzPropertyTypeC(14)
  Else If BaseProperty Is TEzIntegerProperty              Then Result := TEzPropertyTypeC(15)
  Else If BaseProperty Is TEzLinetypeProperty             Then Result := TEzPropertyTypeC(16)
  Else If BaseProperty Is TEzLongTextProperty             Then Result := TEzPropertyTypeC(17)
  Else If BaseProperty Is TEzMemoProperty                 Then Result := TEzPropertyTypeC(18)
  Else If BaseProperty Is TEzPointsProperty               Then Result := TEzPropertyTypeC(19)
  Else If BaseProperty Is TEzSelectFolderProperty         Then Result := TEzPropertyTypeC(20)
  Else If BaseProperty Is TEzSetProperty                  Then Result := TEzPropertyTypeC(21)
  Else If BaseProperty Is TEzStringProperty               Then Result := TEzPropertyTypeC(22)
  Else If BaseProperty Is TEzSymbolProperty               Then Result := TEzPropertyTypeC(23)
  Else If BaseProperty Is TEzTimeProperty                 Then Result := TEzPropertyTypeC(24);
End;

function TEzPropertyItem.GetPropertyType: TEzPropertyTypeC;
begin
  Result := PropertyTypeOf(FBaseProperty);
end;

function TEzPropertyItem.GetPropertyValue: string;
Var
  OldFormat : String;
  OldSeparator : Char;
//  OldFullYear : Boolean;

begin
//  Result := FBaseProperty.AsString;
  OldFormat := ShortDateFormat;
  OldSeparator := DateSeparator;
//  OldFullYear := DateFullYear;
  dateSeparator := '/';
//  DateFullYear := True;
  ShortDateFormat := 'dd/mm/yyyy';
  Case FBaseProperty.PropType Of
    ptInteger:  Result := IntToStr(FBaseProperty.FValInteger);
    ptFloat:    Result := FloatToStr(FBaseProperty.FValFloat);
    ptBoolean:  If FBaseProperty.FValBoolean Then
                  Result := 'True'
                Else
                  Result := 'False';
    ptDate:     Result := DateTimeToStr(FBaseProperty.FValDateTime);
  Else
    Result := FBaseProperty.FValString;
  End;
   DateSeparator := OldSeparator;
//   DateFullYear := OldFullYear;
   ShortDateFormat := OldFormat;
end;

function TEzPropertyItem.GetReadOnly: Boolean;
begin
  Result := FBaseProperty.FReadOnly;
end;

function TEzPropertyItem.GetStrings: TEzBooleanCollection;
begin
  If FBaseProperty Is TEzSetProperty Then
    Result := FSetEnumCollection
  Else If FBaseProperty Is TEzEnumerationProperty Then
    Result := FSetEnumCollection
  Else Result := Nil;
end;

function TEzPropertyItem.GetTrueType: Boolean;
begin
  If FBaseProperty Is TEzFontNameProperty Then
    Result := (FBaseProperty As TEzFontNameProperty).TrueType
  Else
    Result := False;
end;

function TEzPropertyItem.GetUseEdit: Boolean;
begin
  Result := FBaseProperty.FUseEditButton;
end;

function TEzPropertyItem.GetValString: String;
begin
  Result := FBaseProperty.FValString;
end;

procedure TEzPropertyItem.SetBaseProperty(const Value: TEzBaseProperty);
begin
  FBaseProperty := Value;
  FBaseProperty.IsPropertyOfList := True;
end;

procedure TEzPropertyItem.SetPropertyName(const Value: string);
begin
  FBaseProperty.PropName := Value;
end;

procedure TEzPropertyItem.SetPropertyType(const Value: TEzPropertyTypeC);
Var
  bp : TEzBaseProperty;
begin
  Bp := CreatePropertyByType(Value, Nil, FBaseProperty.PropName, caCreate);
  If Bp = Nil Then Exit;
  FBaseProperty.Free;
  FBaseProperty := Bp;
  FBaseProperty.IsPropertyOfList := True;
  UpdateSetEnum;
end;

procedure TEzPropertyItem.SetPropertyValue(const Value: string);
Var
  OldFormat : String;
  OldSeparator : Char;
//  OldFullYear : Boolean;
begin
  OldFormat := ShortDateFormat;
  OldSeparator := DateSeparator;
//  OldFullYear := DateFullYear;
  dateSeparator := '/';
//  DateFullYear := True;
  ShortDateFormat := 'dd/mm/yyyy';
  Case FBaseProperty.PropType Of
    ptInteger: FBaseProperty.FValInteger := StrToInt(Value);
    ptFloat:   FBaseProperty.FValFloat := StrToFloat(Value);
    ptBoolean: If Value = 'True' Then
                 FBaseProperty.FValBoolean := True
               Else
                 FBaseProperty.FValBoolean := False;
    ptDate:    FBaseProperty.FValDateTime := StrToDateTime(Value);
  Else
    FBaseProperty.FValString := Value;
  End;
   DateSeparator := OldSeparator;
//   DateFullYear := OldFullYear;
   ShortDateFormat := OldFormat;
end;

procedure TEzPropertyItem.SetReadOnly(const Value: Boolean);
begin
  FBaseProperty.FReadOnly := Value;
end;

procedure TEzPropertyItem.SetStrings(const Value: TEzBooleanCollection);
begin
  If FBaseProperty Is TEzSetProperty Then
    FSetEnumCollection := Value
  Else If FBaseProperty Is TEzEnumerationProperty Then
    FSetEnumCollection := Value
end;

procedure TEzPropertyItem.SetTrueType(const Value: Boolean);
begin
  If FBaseProperty Is TEzFontNameProperty Then
    (FBaseProperty As TEzFontNameProperty).TrueType := Value;
end;

procedure TEzPropertyItem.SetUseEdit(const Value: Boolean);
begin
  FBaseProperty.FUseEditButton := Value;
end;

procedure TEzPropertyItem.SetValBoolean(const Value: Boolean);
begin
  FBaseProperty.FValBoolean := Value;
end;

procedure TEzPropertyItem.SetValDateTime(const Value: TDateTime);
begin
  FBaseProperty.FValDateTime:= Value;
end;

procedure TEzPropertyItem.SetValFloat(const Value: Double);
begin
  FBaseProperty.FValFloat:= Value;
end;

procedure TEzPropertyItem.SetValInteger(const Value: Integer);
begin
  FBaseProperty.FValInteger:= Value;
end;

procedure TEzPropertyItem.SetValString(const Value: String);
begin
  FBaseProperty.FValString:= Value;
end;

procedure TEzPropertyItem.UpdateSetEnum;
begin
  FSetEnumCollection.CheckBounds;
end;

procedure TEzPropertyList.ReplaceByIndex(Index: Integer; p: TEzBaseProperty);
begin
  if Index < 0 then Exit;
  If Index < FList.Count Then Begin
    With TEzBaseProperty(FList.Items[Index]) Do
     If Not IsPropertyOfList Then Free;
   FList.Items[Index] := p;
  End Else Flist.Add(p);
end;

{ TEzPropertyCollection }

function TEzPropertyCollection.Add: TEzPropertyItem;
begin
  Result := TEzPropertyItem(Inherited Add);
end;

procedure TEzPropertyCollection.AddProperty(p: TEzBaseProperty);
begin
  (Add As TEzPropertyItem).FBaseProperty := p;
  p.IsPropertyOfList := True;
end;


constructor TEzPropertyCollection.Create(AOwner: TPersistent);
begin
  inherited Create(Aowner, TEzPropertyItem);
  FInspectorProvider:= AOwner as TEzInspectorProvider;
end;

destructor TEzPropertyCollection.Destroy;
begin
  inherited;
end;

procedure TEzPropertyCollection.ExChange(Index1, Index2: Integer);
Var
  Tmp : TEzBaseProperty;
begin
  If (Index1 < 0) Or (Index2 < 0) Then Exit;
  If (Index1 >= Count) Or (Index2 >= Count) Then Exit;
  Tmp := Items[Index1].FBaseProperty;
  Items[Index1].FBaseProperty := Items[Index2].FBaseProperty;
  Items[Index2].FBaseProperty := Tmp;
end;

function TEzPropertyCollection.GetItem(Index: Integer): TEzPropertyItem;
begin
  Result:= TEzPropertyItem(inherited GetItem(Index) );
end;

function TEzPropertyCollection.IndexOfName(
  const PropName: String): Integer;
Var
  I : Integer;
begin
  Result := -1;
  For I := 0 To Count - 1 Do
    If Items[I].FBaseProperty.PropName = PropName Then Begin
      Result := I;
      Exit;
    End;
end;

function TEzPropertyCollection.IndexOfProperty(
  p: TEzBaseProperty): Integer;
Var
  I : Integer;
begin
  Result := -1;
  For I := 0 To Count - 1 Do
    If Items[I].FBaseProperty = p Then Begin
      Result := I;
      Exit;
    End;
end;

procedure TEzPropertyCollection.Insert(Index: Integer; p: TEzBaseProperty);
begin
  ((Inherited Insert(Index)) As TEzPropertyItem).FBaseProperty := p;
  p.IsPropertyOfList := True;
end;

procedure TEzPropertyCollection.PopulateTo(Inspector: TEzInspector;
  Action: TPopulateAction; Index : Integer = 0);
Var
  I : Integer;
begin
  If Count = 0 Then Exit;
  Case Action Of
    epaAdding:
      For I := 0 To Count - 1 Do
        Inspector.AddProperty(Items[I].FBaseProperty);
    epaInsert:
      For I := Count - 1 DownTo 0 Do
        Inspector.InsertProperty(Index, Items[I].FBaseProperty);
    epaOverWrite:
      For I := 0 To Count -1 Do
        Inspector.ReplacePropertyByIndex(Index + I, Items[I].FBaseProperty);
    epaDisplayOnlyThis:
      Begin
        Inspector.ClearPropertyList;
        For I := 0 To Count - 1 Do
         If Items[I].FBaseProperty <> Nil Then
          Inspector.AddProperty(Items[I].FBaseProperty);
      End;
  End;
end;

procedure TEzPropertyCollection.ReplaceByIndex(Index: Integer;
  p: TEzBaseProperty);
begin
  Items[Index].FBaseProperty.Free;
  Items[Index].FBaseProperty := p;
  p.IsPropertyOfList := True;
end;

procedure TEzPropertyCollection.SetItem(Index: Integer; const Value: TEzPropertyItem);
begin
  inherited SetItem( Index, value );
end;

{ TEzInspectorProvider }

//Cuidado si la lista esta siendo mostrada en un TEzInspector,
//Este metodo provocara que se genere una excepcion.
procedure TEzInspectorProvider.Add(p: TEzBaseProperty);
begin
  FPropertyList.AddProperty(p);
end;

procedure TEzInspectorProvider.Clear;
Begin
  FPropertyList.Clear;
end;

constructor TEzInspectorProvider.Create(AOwner: TComponent);
begin
  FPropertyList := TEzPropertyCollection.Create(Self);
  inherited;
end;

procedure TEzInspectorProvider.Delete(Index: Integer);
{$IFDEF LEVEL4}
Var
  Item: TCollectionItem;
{$ENDIF}
begin
{$IFDEF LEVEL4}
  Item:= FpropertyList[Index];
  Item.Free;
{$ENDIF}
{$IFDEF LEVEL5}
  FpropertyList.Delete(Index);
{$ENDIF}
end;

destructor TEzInspectorProvider.Destroy;
begin
  inherited;
  if FPropertyList <> Nil Then
    FPropertyList.Free;
end;

procedure TEzInspectorProvider.ExChange(Index1, Index2: Integer);
begin
  FPropertyList.ExChange(Index1, Index2);
end;

function TEzInspectorProvider.GetItem(Index: Integer): TEzBaseProperty;
begin
  Result := FPropertyList.Items[Index].FBaseProperty;
end;

function TEzInspectorProvider.GetItemsCount: Integer;
begin
  Result := FPropertyList.Count;
end;

function TEzInspectorProvider.IndexOfName( const PropName: String): Integer;
begin
  Result := FPropertyList.IndexOfName(PropName);
end;

function TEzInspectorProvider.IndexOfProperty( p: TEzBaseProperty): Integer;
begin
  Result := FPropertyList.IndexOfProperty(p);
end;

procedure TEzInspectorProvider.Insert(Index: Integer; p: TEzBaseProperty);
begin
  FPropertyList.Insert(Index, p);
end;

procedure TEzInspectorProvider.PopulateTo(Inspector: TEzInspector;
  Action: TPopulateAction; Index: Integer);
begin
  If FPropertyList = Nil Then Exit;
  FPropertyList.PopulateTo(Inspector, Action, Index);
  Inspector.Invalidate;
end;

procedure TEzInspectorProvider.RemoveFrom(Inspector: TEzInspector);
Var
  I : Integer;
begin
  For I := 0 To FPropertyList.Count - 1 Do
    Inspector.RemoveProperty(FPropertyList.Items[I].FBaseProperty);
end;

procedure TEzInspectorProvider.ReplaceByIndex(Index: Integer;
  p: TEzBaseProperty);
begin
   FPropertyList.ReplaceByIndex(Index, p);
end;

procedure TEzInspectorProvider.SetItem(Index: Integer;
  const Value: TEzBaseProperty);
begin
  Value.IsPropertyOfList := True;
  FPropertyList.Items[Index].FBaseProperty.Free;
  FPropertyList.Items[Index].FBaseProperty := Value;
end;


procedure TEzInspectorProvider.SetPropertyList(const Value: TEzPropertyCollection);
begin
  FPropertyList := Value;
end;




{ TEzBooleanCollection }

procedure TEzBooleanCollection.CheckBounds;
Var
  Tmp : TEzBaseProperty;
begin
  Tmp := PropertyItem.FBaseProperty;
  If Tmp Is TEzSetProperty Then
    While Count <> TEzSetProperty(Tmp).Strings.Count Do
      If Count > TEzSetProperty(Tmp).Strings.Count Then
        TEzSetProperty(Tmp).Strings.Add('Empty')
      Else Add
  Else If Tmp Is TEzEnumerationProperty Then
    While Count <> TEzEnumerationProperty(Tmp).Strings.Count Do
      If Count > TEzEnumerationProperty(Tmp).Strings.Count Then
        TEzEnumerationProperty(Tmp).Strings.Add('Empty')
      Else Add;
end;

constructor TEzBooleanCollection.Create(AOwner: TPersistent);
begin
  inherited Create(AOwner, TEzBooleanCollectionItem);
  PropertyItem := TEzPropertyItem(AOwner);
end;



function TEzBooleanCollection.GetItem(Index: Integer): TEzBooleanCollectionItem;
begin
  Result := GetItem(Index);
end;

procedure TEzBooleanCollection.SetItem(Index: Integer;
  const Value: TEzBooleanCollectionItem);
begin
  Inherited SetItem(Index,Value);
end;

{ TEzBooleanCollectionItem }


procedure TEzBooleanCollectionItem.Assign(Source: TPersistent);
begin
  inherited;
  //Probablemente esto no sea necesario!!!!!!!!!!!!!!!!!!!!!!!..............
  TEzBooleanCollectionItem(Source).Defined := Defined;
end;


constructor TEzBooleanCollectionItem.Create(AOwner: TCollection);
{Var
  Tmp : TEzBaseProperty;}
begin
  inherited;
end;

destructor TEzBooleanCollectionItem.Destroy;
var
  Tmp : TEzBaseProperty;
begin
  Tmp := TEzBooleanCollection(Collection).PropertyItem.FBaseProperty;
  If Tmp Is TEzSetProperty Then
    TEzSetProperty(Tmp).Strings.Delete(Index)
  Else If Tmp Is TEzEnumerationProperty Then
    TEzEnumerationProperty(Tmp).Strings.Delete(Index);
  inherited;
end;

function TEzBooleanCollectionItem.GetDisplayName: String;
begin
  Result := Strings;
end;

function TEzBooleanCollectionItem.GetString: String;
Var
  Tmp : TEzBaseProperty;
begin
 TEzBooleanCollection(Collection).CheckBounds;
  Tmp := TEzBooleanCollection(Collection).PropertyItem.FBaseProperty;
  If Tmp Is TEzSetProperty Then Begin
    Result := TEzSetProperty(Tmp).Strings.Strings[Index];
  End Else If Tmp Is TEzEnumerationProperty Then
    Result := TEzEnumerationProperty(Tmp).Strings.Strings[Index];
end;

function TEzBooleanCollectionItem.GetValue: Boolean;
Var
  Tmp : TEzBaseProperty;
begin
 TEzBooleanCollection(Collection).CheckBounds;
 Tmp := TEzBooleanCollection(Collection).PropertyItem.FBaseProperty;
 If Tmp Is TEzSetProperty Then
   Result := TEzSetProperty(Tmp).Defined[Index]
 Else
   Result := False;
end;

procedure TEzBooleanCollectionItem.SetString(const Value: String);
Var
  Tmp : TEzBaseProperty;
begin
 TEzBooleanCollection(Collection).CheckBounds;
  Tmp := TEzBooleanCollection(Collection).PropertyItem.FBaseProperty;
  If Tmp Is TEzSetProperty Then
  Begin
    TEzSetProperty(Tmp).Strings.Strings[Index] := Value;
  End Else If Tmp Is TEzEnumerationProperty Then
    TEzEnumerationProperty(Tmp).Strings.Strings[Index] := Value;
end;


procedure TEzBooleanCollectionItem.SetValue(const Value: Boolean);
Var
  Tmp : TEzBaseProperty;
begin
 TEzBooleanCollection(Collection).CheckBounds;
 Tmp := TEzBooleanCollection(Collection).PropertyItem.FBaseProperty;
 If Tmp Is TEzSetProperty Then
   TEzSetProperty(Tmp).Defined[Index] := Value;
end;
//--------------------------------------------------------------------------

//------------------------------TEzInspectorProvider------------------------


{ TEzExpandedPropery }

constructor TEzTreeViewProperty.Create(Const PropName : String);
begin
  inherited Create(PropName);
  FPropertyList := TEzPropertyList.Create;
  FExpanded := False;
  FReadOnly := True; // by default
end;

destructor TEzTreeViewProperty.Destroy;
begin
  FPropertyList.Free;
  inherited;
end;

procedure TEzTreeViewProperty.AddProperty( BaseProperty: TEzBaseProperty );
begin
  BaseProperty.FParent:= Self;
  BaseProperty.Modified := False;
  BaseProperty.OnChange:= Self.OnChange;

  FPropertyList.Add(BaseProperty);
end;

procedure TEzTreeViewProperty.FullExpand;
Begin
  RecurseFullExpand( true );
End;

procedure TEzTreeViewProperty.FullCompact;
Begin
  RecurseFullExpand( false );
End;

procedure TEzTreeViewProperty.RecurseFullExpand( Value: Boolean );
var
  I: Integer;

  Procedure DoRecurseFullExpand( tv: TEzTreeViewProperty );
  var
    I: Integer;
  begin
    tv.FExpanded:= Value;
    for I:= 0 to tv.FPropertyList.Count-1 do
      if tv.FPropertyList[I] is TEzTreeViewProperty then
        DoRecurseFullExpand( TEzTreeViewProperty( tv.FPropertyList[I] ) );
  end;

begin
  FExpanded:= Value;
  for I:= 0 to FPropertyList.Count-1 do
    if FPropertyList[I] is TEzTreeViewProperty then
      DoRecurseFullExpand( TEzTreeViewProperty( FPropertyList[I] ) );
end;

function TEzTreeViewProperty.GetExpanded: Boolean;
begin
  Result := FExpanded;
end;

function TEzTreeViewProperty.GetPropertyList: TEzPropertyList;
begin
  Result := FPropertyList;
end;

procedure TEzTreeViewProperty.SetExpanded(const Value: Boolean);
begin
  FExpanded := Value;
end;

end.
