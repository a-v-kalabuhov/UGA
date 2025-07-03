Unit EzCmdLine;

{***********************************************************}
{     EzGIS/CAD Components                                  }
{   (c) 2002 EzSoft Engineering                             }
{         All Rights Reserved                               }
{***********************************************************}

{$I EZ_FLAG.PAS}
Interface

Uses
  SysUtils, Windows, Messages, Classes, Graphics, Controls, Forms,
  StdCtrls, EzLib, EzEntities, EzBaseGIS, EzSystem, EzBase ;

Type

  TEzCmdLine = Class;

  { This enumerated list the possible inputs from the user on the command line }
  TEzInputType = ( itNone,          { user typed nothing valid }
                   itFloatValue,    { user typed a single float value, like when positioning guidelines}
                   itString );      { user typed a string, ex: "Rob Brown" (double quotes included) }

  TEzStatusMessageEvent = Procedure( Sender: TObject; Const AMessage: String ) Of Object;

  TEzMeasureInfoEvent = Procedure( Sender: TObject; Const Area, Perimeter, Angle, NumPoints: Double ) Of Object;

  TEzBeforeCommandEvent = Procedure( Sender: TObject; Const Command, ActionID: String;
    Var ErrorMessage: String; Var Accept: Boolean ) Of Object;

  TEzAfterCommandEvent = Procedure( Sender: TObject; Const Command, ActionID: String ) Of Object;

  TEzShortCutEvent = Procedure( Sender: TObject; Var Command: String ) Of Object;

  { this is for executing commands with an event }
  TEzUnknownCommandEvent = Procedure( Sender: TObject; Const Command, ActionID: String;
    Var Processed: Boolean ) Of Object;

  TEzGetCursorEvent = Procedure( Sender: TObject; const Command, ActionID: String;
    var Cursor: TCursor ) Of Object;

  {-------------------------------------------------------------------------------}
  {                  Define TEzAction                                              }
  {-------------------------------------------------------------------------------}

  TEzAction = Class;

  TEzActionClass = Class Of TEzAction;

  TEzMouseDrawElements = Set Of ( mdCursor, mdCursorFrame, mdFullViewCursor );

  TEzAction = Class(TObject)
  Private
    FCmdLine: TEzCmdLine;
    FCursor: TCursor; // the cursor used in the DrawBox by the Action
    FFinished: Boolean;
    FCaption: String;
    FOldCaption: String;
    FActionID: String;
    FCanBeSuspended: Boolean;
    FWaitingMouseClick: Boolean;
    FInfoForPrevious: String;
    FCanDoOSNAP: Boolean;
    FCanDoAccuDraw: Boolean;
    { The following data is updated when the command line is parsed }
    FUserCommand: TEzInputType;
    FUserString: String;
    FUserValue: Double;
    { entity used for drawing the cursor }
    FFullViewCursor: TEzPolyLine;
    FCursorFrame: TEzRectangle;
    FMouseDrawElements: TEzMouseDrawElements;
    { After finish executing this one, start executing this }
    FChainedTo: TEzAction;
    FLauncher: TComponent; { defined when launched from TEzActionLauncher }
    FLastClicked: TEzPoint;

    FOnMouseDown: TEzMouseEvent;
    FOnMouseMove: TEzMouseMoveEvent;
    FOnMouseUp: TEzMouseEvent;
    FOnPaint: TNotifyEvent;
    FOnClick: TNotifyEvent;
    FOnDblClick: TNotifyEvent;
    FOnKeyDown: TKeyEvent;
    FOnKeyPress: TKeyPressEvent;
    FOnKeyUp: TKeyEvent;
    FOnActionDoCommand: TNotifyEvent;
    FOnSuspendOperation: TNotifyEvent;
    FOnContinueOperation: TNotifyEvent;
    FOnUndo: TNotifyEvent;
    FOnInitialize: TNotifyEvent;
    FCancelled: Boolean;

    Procedure SetFullViewCursorPos(Const Pt: TEzPoint);
    Procedure DrawFullViewCursor(Sender: TObject = Nil);
    Procedure EraseFullViewCursor;
    Procedure SetCaption( Const Value: String );
    { this is used in order to cancel a command if a DrawBox is not
      of the expected type }
    Function AcceptDrawBox: Boolean;
    procedure SetCancelled(const Value: Boolean); {Dynamic;}
  Public
    { methods }
    Constructor CreateAction( CmdLine: TEzCmdLine );
    Destructor Destroy; Override;
    Procedure UndoOperation; Dynamic;
    Procedure ParseUserCommand( Const Cmd: String );
    Procedure SuspendOperation;
    Procedure ContinueOperation;

    { When this property is assigned, it will be linked to the Action that is
      pointing to }
    Property Finished: Boolean Read FFinished Write FFinished;
    Property WaitingMouseClick: Boolean Read FWaitingMouseClick Write FWaitingMouseClick;
    Property InfoForPrevious: String Read FInfoForPrevious Write FInfoForPrevious;
    Property UserCommand: TEzInputType Read FUserCommand Write FUserCommand;
    Property UserString: String Read FUserString Write FUserString;
    Property UserValue: Double Read FUserValue Write FUserValue;
    Property MouseDrawElements: TEzMouseDrawElements read FMouseDrawElements write FMouseDrawElements;
    Property LastClicked: TEzPoint read FLastClicked write FLastClicked;

    { previous version these properties was in the published section }
    property Cancelled: Boolean read FCancelled write SetCancelled;
    Property ChainedTo: TEzAction Read FChainedTo Write FChainedTo;
    Property CanDoOSNAP: Boolean Read FCanDoOSNAP Write FCanDoOSNAP;
    Property CanDoAccuDraw: Boolean Read FCanDoAccuDraw Write FCanDoAccuDraw;
    Property ActionID: String Read FActionID Write FActionID;
    Property CanBeSuspended: Boolean Read FCanBeSuspended Write FCanBeSuspended;
    Property Caption: String Read FCaption Write SetCaption;
    Property Cursor: TCursor Read FCursor Write FCursor;
    Property CmdLine: TEzCmdLine Read FCmdLine Write FCmdLine;
    Property Launcher: TComponent read FLauncher write FLauncher;

    { events }
    Property OnMouseDown: TEzMouseEvent Read FOnMouseDown Write FOnMouseDown;
    Property OnMouseMove: TEzMouseMoveEvent Read FOnMouseMove Write FOnMouseMove;
    Property OnMouseUp: TEzMouseEvent Read FOnMouseUp Write FOnMouseUp;
    Property OnPaint: TNotifyEvent Read FOnPaint Write FOnPaint;
    Property OnClick: TNotifyEvent Read FOnClick Write FOnClick;
    Property OnDblClick: TNotifyEvent Read FOnDblClick Write FOnDblClick;
    Property OnKeyDown: TKeyEvent Read FOnKeyDown Write FOnKeyDown;
    Property OnKeyPress: TKeyPressEvent Read FOnKeyPress Write FOnKeyPress;
    Property OnKeyUp: TKeyEvent Read FOnKeyUp Write FOnKeyUp;
    Property OnActionDoCommand: TNotifyEvent Read FOnActionDoCommand Write FOnActionDoCommand;
    Property OnSuspendOperation: TNotifyEvent Read FOnSuspendOperation Write FOnSuspendOperation;
    Property OnContinueOperation: TNotifyEvent Read FOnContinueOperation Write FOnContinueOperation;
    Property OnUndo: TNotifyEvent Read FOnUndo Write FOnUndo;
    Property OnInitialize: TNotifyEvent Read FOnInitialize Write FOnInitialize;
  End;

  {-------------------------------------------------------------------------------}
  {                  Define TEzCmdLine class                                        }
  {-------------------------------------------------------------------------------}

  TEzCmdLineEdit = Class( TEdit )
  Protected
    Procedure KeyPress( Var Key: Char ); Override;
  End;

  TEzFrameStyle = ( fsRectangular, fsPolar );

  TEzAccuDraw = Class( TPersistent )
  Private
    FOwner: TEzCmdLine;
    FEnabled: Boolean;
    FShowing: Boolean;
    FSnapUnRotated: Boolean;
    FRotateToSegments: Boolean;
    { means that AccuDraw can be snapped to the axis marks. True by default }
    FSnapToAxis: Boolean;
    { Can be snapped to a distance }
    FSnapSameDistance: Boolean;
    { It's a frame, polar or absolute coordinates ?}
    FFrameStyle: TEzFrameStyle;
    FDeltaX: Double;
    FDeltaY: Double;
    { is any distance currently locked ?}
    FDeltaXLocked: Boolean;
    FDeltaYLocked: Boolean;
    { the colors for every axis and frame }
    FXAxisColor: TColor;
    FYAxisColor: TColor;
    FHiliteColor: TColor;
    FFrameColor: TColor;
    FSnapColor: TColor;
    { width of frame in pixels default 80 }
    FWidth: Integer;
    { is the tolerance, in pixels that allows to AccuDraw to snap to the axxis }
    FTolerance: Byte;
    { switch to one beyond on reshaping entities (used for aligning perpend
      to other line segment ) }
    FReshapeAdvance: Boolean;
    FCtrlAltSuspend: Boolean;

    { Local variables }

    FAccuOrigin: TEzPoint;  // origin of accudraw
    FRotangle: Double;      // rotation angle

    FLastDistance: Double;  // last used distance
    { The following is the list of entities used for showing rubber banding
      for the accudraw snapped points (locked to axis, snapped by using accusanp, etc.)
    }
    FRubberList: TEzEntityList;

    { this flag is set when the current point is snapped to an axis (rotated or not) }
    FIsSnappedToAxis: Boolean;
    { this flag is set when the current point is snapped to the last distance }
    FIsSnappedToDistance: Boolean;
    { used to flag that a perpend point was found from one point that is
      snapped to the AccuSnap, a guideline or the grid.
      This is flagged from TEzCmdLine}
    FPerpendFound: Boolean;
    { the perpendicular point }
    FPerpendFrom: TEzPoint;

    procedure SetFrameColor(const Value: TColor);
    procedure SetHiliteColor(const Value: TColor);
    procedure SetWidth(Value: Integer);
    procedure SetXAxisColor(const Value: TColor);
    procedure SetYAxisColor(const Value: TColor);
    procedure SetDeltaX(const Value: Double);
    procedure SetDeltaY(const Value: Double);
    procedure SetShowing(const Value: Boolean);
    procedure SetFrameStyle(const Value: TEzFrameStyle);
    procedure SetTolerance(const Value: Byte);
    procedure SetEnabled(const Value: Boolean);
    { semi-public procedures }
    procedure Reset;
    procedure DrawSnaps(Reversed: Boolean = False);
    procedure DrawAuxLines;
    procedure EraseAuxLines;
    Function GetSnappedPoint: TEzPoint;
    Procedure Draw;
    procedure SetRotangle(const Value: Double);
  Public
    Constructor Create( AOwner: TEzCmdLine );
    Destructor Destroy; Override;
    Procedure UpdatePosition( const FromPt, ToPt: TEzPoint; Reversed: Boolean = False );
    Procedure ChangeOrigin( Origin: TEzPoint; const Angle: Double = 0 );
    Procedure ShowUnRotated;
    procedure CurrentDimensions( Var DX, DY: Double );
    procedure Change;

    Property Showing: Boolean read FShowing write SetShowing;
    { displacement of current point (FAccuOrigin) }
    Property DeltaX: Double read FDeltaX write FDeltaX;
    Property DeltaY: Double read FDeltaY write FDeltaY;
    { same as above but for polar }
    Property Dist: Double read FDeltaX write SetDeltaX;
    Property Angle: Double read FDeltaY write SetDeltaY;

    { current origin of AccuDraw object on screen (FAccuOrigin) }
    Property AccuOrigin: TEzPoint read FAccuOrigin write FAccuOrigin;
    Property Rotangle: Double read FRotangle write SetRotangle;

    Property DeltaXLocked: Boolean read FDeltaXLocked write FDeltaXLocked;
    Property DeltaYLocked: Boolean read FDeltaYLocked write FDeltaYLocked;
    { same as above but for polar }
    Property DistLocked: Boolean read FDeltaXLocked write FDeltaXLocked;
    Property AngleLocked: Boolean read FDeltaYLocked write FDeltaYLocked;

    Property FrameStyle: TEzFrameStyle read FFrameStyle write SetFrameStyle default fsRectangular;
    property LastDistance: Double read FLastDistance write FLastDistance;
  Published
    { published properties }
    Property ReshapeAdvance: Boolean read FReshapeAdvance write FReshapeAdvance;
    Property SnapUnRotated: Boolean read FSnapUnRotated write FSnapUnRotated default true;
    Property Enabled: Boolean read FEnabled write SetEnabled default true;
    Property Width: Integer read FWidth write SetWidth default 80;
    Property XAxisColor: TColor read FXAxisColor write SetXAxisColor default clRed;
    Property YAxisColor: TColor read FYAxisColor write SetYAxisColor default clLime;
    Property HiliteColor: TColor read FHiliteColor write SetHiliteColor default clBlack;
    Property FrameColor: TColor read FFrameColor write SetFrameColor default clBlue;
    Property SnapColor: TColor read FSnapColor write FSnapColor default clBlack;
    Property SnapToAxis: Boolean read FSnapToAxis write FSnapToAxis default True;
    Property Tolerance: Byte read FTolerance write SetTolerance default 10;
    Property RotateToSegments: Boolean read FRotateToSegments write FRotateToSegments default true;
    Property SnapSameDistance: Boolean read FSnapSameDistance write FSnapSameDistance default true;
    Property CtrlAltSuspend: Boolean read FCtrlAltSuspend write FCtrlAltSuspend default true;
  End;

  { the info for the current snapped point }
  TEzAccuSnapInfo = Record
    { position on the viewport in pixels }
    Pos: TPoint;
    { the current bitmap visible on screen }
    Picture: TBitmap;
    { the current snap setting }
    SnapSetting: TEzOSNAPSetting;
    { the current snapped point }
    SnapPoint: TEzPoint;
    { the entity that was accusnapped}
    Layer: TEzBaseLayer;
    Recno: Integer;
    { is currently showing on screen ?}
    Showing: Boolean;
    { used when SnapSetting = osPerpend, osParallel }
    RefFrom: TEzPoint;
    RefTo: TEzPoint;
    IsNextParallel: Boolean;
  End;

  { TEzAccuSnap }
  TEzAccuSnap = class(TPersistent)
  private
    FOwner: TEzCmdLine;
    FEnabled: Boolean;
    // value between 0 and 100 that indicates the sensitivity of the snapping
    FSensitivity: Byte;
    FOsnapSetting: TEzOSNAPSetting;
    FOverrideOsnapSetting: TEzOSNAPSetting;
    FOverrideOsnap: Boolean;
    FSnapDivisor: Byte;
    FCtrlShiftSuspend: Boolean;
    FHiliteSnapped: Boolean;

    { temporary used }
    FCurrentSnapInfo: TEzAccuSnapInfo;
    FSnapLayerName: string;
    FInSearch: Boolean;
    Procedure EraseFromScreen;
    Procedure UpdateAccuSnapEntity;
    Procedure DrawAccuSnap( Draw: Boolean );
    procedure SetEnabled(const Value: Boolean);
    procedure SetOverrideOsnapSetting(const Value: TEzOSNAPSetting);
    procedure SetOsnapSetting(const Value: TEzOSNAPSetting);
    procedure SetOverrideOsnap(const Value: Boolean);
  public
    { set to some layer name for snapping only to that layer }
    Constructor Create(AOwner: TEzCmdLine);
    Destructor Destroy; Override;
    Function GetCurrentOsnapSetting: TEzOsnapSetting;
    procedure Change;

    Property SnapLayerName: string read FSnapLayerName write FSnapLayerName;
    Property OverrideOsnapSetting: TEzOSNAPSetting read FOverrideOsnapSetting write SetOverrideOsnapSetting;
    Property OverrideOsnap: Boolean read FOverrideOsnap write SetOverrideOsnap;
    Property HiliteSnapped: Boolean read FHiliteSnapped Write FHiliteSnapped;
  published
    Property Sensitivity: Byte read FSensitivity write FSensitivity default 100;
    Property OsnapSetting: TEzOSNAPSetting read FOsnapSetting write SetOsnapSetting default osKeyPoint;
    Property SnapDivisor: Byte read FSnapDivisor write FSnapDivisor default 2;
    Property Enabled: Boolean read FEnabled write SetEnabled default true;
    Property CtrlShiftSuspend: Boolean read FCtrlShiftSuspend write FCtrlShiftSuspend default True;
  end;


  { Follows the list of draw box that can be connected to the same TEzCmdLine }

  {---------------------------------------------------------------------------}
  {                  Define TEzDrawBoxItem                                    }
  {---------------------------------------------------------------------------}

  TEzDrawBoxItem = Class( TCollectionItem )
  Private
    FDrawBox: TEzBaseDrawBox;
    FCurrent: Boolean;
    { Events hooks for the drawbox }
    FSavedMouseDown: TEzMouseEvent;
    FSavedMouseMove: TEzMouseMoveEvent;
    FSavedMouseUp: TEzMouseEvent;
    FSavedClick: TNotifyEvent;
    FSavedDblClick: TNotifyEvent;
    FSavedKeyPress: TKeyPressEvent;
    FSavedKeyDown: TKeyEvent;
    FSavedPaint: TNotifyEvent;
    FSavedMouseEnter: TNotifyEvent;
    FSavedMouseLeave: TNotifyEvent;
    //FSavedMouseLeave: TNotifyEvent;
    Procedure SetDrawBox( Value: TEzBaseDrawBox );
    Procedure SetCurrent( Value: Boolean );
  Protected
    Function GetDisplayName: String; Override;
  Public
    Destructor Destroy; Override;
    Procedure Assign( Source: TPersistent ); Override;
  Published
    Property DrawBox: TEzBaseDrawbox Read FDrawBox Write SetDrawBox;
    Property Current: Boolean Read FCurrent Write SetCurrent;
  End;

  {---------------------------------------------------------------------------}
  {                  Define TEzDrawBoxCollection                              }
  {---------------------------------------------------------------------------}

  TEzDrawBoxCollection = Class( TOwnedCollection )
  Private
    FCmdLine: TEzCmdLine;
    Function GetItem( Index: Integer ): TEzDrawBoxItem;
    Procedure SetItem( Index: Integer; Value: TEzDrawBoxItem );
  Public
    Constructor Create( AOwner: TPersistent );
    Function Add: TEzDrawBoxItem;
    Function FindCurrent: TEzDrawBoxItem;
    Function FindItem(Sender: TObject): TEzDrawBoxItem;
    Procedure SetCurrent( Value: TObject );
    Property Items[Index: Integer]: TEzDrawBoxItem Read GetItem Write SetItem; Default;
  End;

  { TEzCmdLine }
  TEzCmdLine = Class( TWinControl )
  Private
    FDrawBoxList: TEzDrawBoxCollection;
    FEdit: TEzCmdLineEdit;
    FLabel: TLabel;
    FActionList: TList;
    FTheDefaultAction: TEzAction;
    FUseOrto: Boolean;
    FRepaintRect: TEzRect;
    FCurrentPoint: TEzPoint;
    FShortCuts, FDisabledCommands: TStrings;
    FGLSnapAperture: TPoint;
    { for AccuSnap }
    FAccuSnap: TEzAccuSnap;
    //FWasSnapped: Boolean;
    { if <> '', then only that layer name will be used for snapping }
    FIsMouseDown: Boolean;
    { AccuDraw }
    FAccuDraw: TEzAccuDraw;

    // Command line processing
    FLastCommand: String;
    FLastActionID: String;
    FDeletingActionID: string;
    FBorderStyle: TBorderStyle; {border style to use}
    FUseFullViewCursor: Boolean;
    FClearing: Boolean;
    FShowMeasureInfoWindow: Boolean;
    FDynamicUpdate: Boolean;

    { event handlers }
    FOnActionChange: TNotifyEvent;
    FOnStatusMessage: TEzStatusMessageEvent;
    FOnMeasureInfo: TEzMeasureInfoEvent;
    FOnBeforeCommand: TEzBeforeCommandEvent;
    FOnAfterCommand: TEzAfterCommandEvent;
    FOnShortCut: TEzShortCutEvent;
    FOnUnknownCommand: TEzUnKnownCommandEvent;
    FOnGetCursor: TEzGetCursorEvent;
    FOnAccuDrawActivate: TNotifyEvent;
    FOnAccuDrawChange: TNotifyEvent;
    FOnAccuSnapChange: TNotifyEvent;
    FAutoMoveEnabled: Boolean;

    Function GetActiveDrawBox: TEzBaseDrawBox;
    Procedure InternalDoCommand( Const Cmd, ActionID: String; IsParam: Boolean );
    Procedure SetTheDefaultAction( Value: TEzAction );
    // command line processing
    Procedure SetShortCuts( Value: TStrings );
    Procedure SetDisabledCommands( Value: TStrings );
    Procedure SetStatusMessage( Const Value: String );

    procedure DoMouseEnter(Sender: TObject);
    procedure DoMouseLeave(Sender: TObject);
    Procedure DoMouseDown( Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer; Const WX, WY: Double );
    Procedure DoMouseMove( Sender: TObject; Shift: TShiftState; X, Y: Integer; Const WX, WY: Double );
    Procedure DoMouseUp( Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer; Const WX, WY: Double );
    Procedure DoKeyPress( Sender: TObject; Var Key: Char );
    Procedure DoPaint( Sender: TObject );
    Procedure DoClick( Sender: TObject );
    Procedure DoDblClick( Sender: TObject );

    Procedure SetBorderStyle( Const Value: forms.TBorderStyle );
    Procedure CMColorChanged( Var Message: TMessage ); Message CM_COLORCHANGED;
    Function GetText: String;
    Procedure SetText( Const Value: String );
    Function GetCaption: String;
    Procedure SetCaption( Const Value: String );
    Procedure CMFontChanged( Var Message: TMessage ); Message CM_FONTCHANGED;
    procedure SetDrawBoxList(const Value: TEzDrawBoxCollection);
    procedure SetAutoMoveEnabled(const Value: Boolean);
  Protected
    Procedure Notification( AComponent: TComponent; Operation: TOperation ); Override;
  Public
    FLastClicked: TEzPoint;
    { methods }
    Constructor Create( AOwner: TComponent ); Override;
    Destructor Destroy; Override;
    Procedure CreateParams( Var Params: TCreateParams ); Override;
    Function CurrentAction: TEzAction;
    Function PreviousAction: TEzAction;
    Procedure KillAction( var Action: TEzAction );
    Procedure Clear;
    Procedure Push( Action: TEzAction; ClearBefore: Boolean; Const Cmd, ActionID: String );
    Procedure Pop;
    // command line processing
    Procedure DoCommand( Const Cmd, ActionID: String );
    Procedure CurrentActionDoCommand( Const Cmd: String );
    Function IsBusy: Boolean;
    Procedure CaptionChange( Const Value: String );
    Function IsSnapped: Boolean;
    Function CurrentActionID: String;
    Function GetSnappedPoint(Remove: Boolean = False): TEzPoint;
    Procedure AddPointToCurrentAction( const P: TEzPoint );
    Procedure AddRelativePointToCurrentAction( const P: TEzPoint );
    Procedure AddRelativeAngleToCurrentAction( const Dist, Angle: Double );
    Procedure AddPointListToCurrentAction( const P: TEzVector );

    { follows the methods and properties that will affect to all drawboxes }
    Procedure All_Cursor(Value: TCursor);
    Procedure All_DrawEntity2DRubberBand( Entity: TEzEntity; CtrlPts:
      Boolean = False; TransfPts: Boolean=False );
    Procedure All_Invalidate;
    Procedure All_Refresh;
    Procedure All_Repaint;
    Procedure All_RepaintRect(const Value: TEzRect);

    { properties }
    Property ActiveDrawBox: TEzBaseDrawBox Read GetActiveDrawBox;
    Property CurrentPoint: TEzPoint Read FCurrentPoint Write FCurrentPoint;
    Property RepaintRect: TEzRect Read FRepaintRect Write FRepaintRect;
    //Property ActionList: TList Read FActionList;
    Property LastCommand: String Read FLastCommand Write FLastCommand;
    Property LastActionID: String Read FLastActionID Write FLastActionID;
    // command line processing
    Property Caption: String Read GetCaption Write SetCaption;
    Property UserInput: String Read GetText Write SetText;
    Property StatusMessage: String Write SetStatusMessage;
    Property UseOrto: Boolean Read FUseOrto Write FUseOrto;
    Property TheDefaultAction: TEzAction Read FTheDefaultAction Write SetTheDefaultAction;
    Property DeletingActionID: string read FDeletingActionID;
    property AutoMoveEnabled: Boolean read FAutoMoveEnabled write SetAutoMoveEnabled;
  Published

    Property DrawBoxList: TEzDrawBoxCollection read FDrawBoxList write SetDrawBoxList;
    Property AccuDraw: TEzAccuDraw read FAccuDraw;
    Property AccuSnap: TEzAccuSnap read FAccuSnap;
    Property ShortCuts: TStrings Read FShortCuts Write SetShortCuts;
    Property DisabledCommands: TStrings Read FDisabledCommands Write SetDisabledCommands;
    Property ShowMeasureInfoWindow: Boolean Read FShowMeasureInfoWindow Write FShowMeasureInfoWindow Default True;
    Property BorderStyle: TBorderStyle Read FBorderStyle Write SetBorderStyle Default bsSingle;
    Property UseFullViewCursor: Boolean Read FUseFullViewCursor Write FUseFullViewCursor Default True;
    { this causes to scroll and to realtime zooming dynamically, although this
      consumes more memory }
    Property DynamicUpdate: Boolean read FDynamicUpdate write FDynamicUpdate;

    {inherited properties}
    Property Font;
    Property Color;
    Property Align;
    Property Ctl3D;
    Property Enabled;
    Property ParentShowHint;
    Property ShowHint;
    Property TabOrder;
    Property TabStop Default True;
    Property Visible;

    Property OnEnter;
    Property OnExit;

    // events
    Property OnAccuDrawActivate: TNotifyEvent read FOnAccuDrawActivate write FOnAccuDrawActivate;
    Property OnAccuDrawChange: TNotifyEvent read FOnAccuDrawChange write FOnAccuDrawChange;
    Property OnAccuSnapChange: TNotifyEvent read FOnAccuSnapChange write FOnAccuSnapChange;
    Property OnGetCursor: TEzGetCursorEvent read FOnGetCursor write FOnGetCursor;
    Property OnActionChange: TNotifyEvent Read FOnActionChange Write FOnActionChange;
    Property OnStatusMessage: TEzStatusMessageEvent Read FOnStatusMessage Write FOnStatusMessage;
    Property OnMeasureInfo: TEzMeasureInfoEvent Read FOnMeasureInfo Write FOnMeasureInfo;
    Property OnBeforeCommand: TEzBeforeCommandEvent Read FOnBeforeCommand Write FOnBeforeCommand;
    Property OnAfterCommand: TEzAfterCommandEvent Read FOnAfterCommand Write FOnAfterCommand;
    Property OnShortCut: TEzShortCutEvent Read FOnShortCut Write FOnShortCut;
    Property OnUnknownCommand: TEzUnknownCommandEvent Read FOnUnknownCommand Write FOnUnknownCommand;
  End;

Implementation

Uses
  Math, ezconsts, ezscrlex, ezscryacc, ezactions, EzActionLaunch;

{-------------------------------------------------------------------------------}
{                  Define TEzAction                                              }
{-------------------------------------------------------------------------------}

Constructor TEzAction.CreateAction( CmdLine: TEzCmdLine );
Var
  p: TEzPoint;
Begin
  Inherited Create;

  FLastClicked:= INVALID_POINT;

  FCmdLine := CmdLine;
  FCanBeSuspended := true;
  { for drawing a full view cursor}
  p := Point2D( 0, 0 );
  FFullViewCursor := TEzPolyLine.CreateEntity( [p, p, p, p] );
  With FFullViewCursor.Points Do
  Begin
    Parts.Add( 0 );
    Parts.Add( 2 );
  End;
  FCursorFrame := TEzRectangle.CreateEntity( Point2D( 0, 0 ), Point2D( 0, 0 ) );
  FCursorFrame.ID:= -2;    // flag for not drawing interior axis when rubber banding

  FMouseDrawElements:= [mdCursor];

  FCursor := crDefault;

End;

Destructor TEzAction.Destroy;
Begin
  With FCmdLine Do
    If Assigned( FCmdLine ) And ( FCmdLine.TheDefaultAction <> Self )
       And Assigned( OnAfterCommand ) Then
      OnAfterCommand( Self, LastCommand, LastActionID );
  FFullViewCursor.Free;
  FCursorFrame.Free;
  If Assigned( FLauncher ) then
    TEzActionLauncher( FLauncher ).CurrentAction := Nil;
  Inherited Destroy;
End;

Procedure TEzAction.DrawFullViewCursor(Sender: TObject = Nil);
Var
  DrawBox: TEzBaseDrawBox;
Begin
  If Sender= Nil Then
    DrawBox:= FCmdLine.ActiveDrawBox
  Else
    DrawBox:= Sender as TEzBaseDrawbox;
  With DrawBox Do
  Begin
    RubberPen.Style:= psSolid;
    If FCmdLine.UseFullViewCursor And (mdFullViewCursor In FMouseDrawElements) Then
      DrawEntityRubberBand( FFullViewCursor );
    If mdCursorFrame In FMouseDrawElements Then // Or (Self.CanDoOsnap And FCmdLine.FAccuSnap.FEnabled) Then
      DrawEntityRubberBand( Self.FCursorFrame );
  End;
End;

{ draw in reverse order in order to erase }
Procedure TEzAction.EraseFullViewCursor;
Begin
  With FCmdLine.ActiveDrawBox Do
  Begin
    RubberPen.Style:= psSolid;
    If mdCursorFrame In FMouseDrawElements Then
      DrawEntityRubberBand( Self.FCursorFrame );
    If FCmdLine.UseFullViewCursor And (mdFullViewCursor In FMouseDrawElements) Then
      DrawEntityRubberBand( FFullViewCursor );
  End;
End;

Procedure TEzAction.SetFullViewCursorPos(Const Pt: TEzPoint);
Var
  DX, DY: Double;
Begin
  { draw old position }
  with FCmdLine.ActiveDrawBox.Grapher do
  begin
    If FCmdLine.UseFullViewCursor And (mdFullViewCursor In FMouseDrawElements) Then
      With FFullViewCursor, CurrentParams.VisualWindow Do
      Begin
        Points[0] := Point2D( Pt.X, Emin.Y );
        Points[1] := Point2D( Pt.X, Emax.Y );
        Points[2] := Point2D( Emin.X, Pt.Y );
        Points[3] := Point2D( Emax.X, Pt.Y );
      End;
    If mdCursorFrame In FMouseDrawElements Then
    Begin
      DX:= DistToRealX( Ez_Preferences.ApertureWidth );
      DY:= DistToRealY( Ez_Preferences.ApertureWidth );
      FCursorFrame.BeginUpdate;
      FCursorFrame.Points[0] := Point2D( Pt.X - DX / 2, Pt.Y - DY / 2 );
      FCursorFrame.Points[1] := Point2D( Pt.X + DX / 2, Pt.Y + DY / 2 );
      FCursorFrame.EndUpdate;
    End;
  end;
End;

procedure TEzAction.SetCancelled(const Value: Boolean);
begin
  FCancelled := Value;
end;

Procedure TEzAction.SetCaption( Const Value: String );
Begin
  FCaption := Value;
  FCmdLine.CaptionChange( Value );
End;

Procedure TEzAction.SuspendOperation;
Begin
  { erase full view cursor }
  EraseFullViewCursor;
  FOldCaption := FCaption;
  If Assigned( FOnSuspendOperation ) Then
    FOnSuspendOperation( Self );
End;

Procedure TEzAction.ContinueOperation;
Begin
  Caption := fOldCaption;
  CmdLine.StatusMessage := '';
  If Assigned( FOnContinueOperation ) Then
    FOnContinueOperation( Self );
  { re-draw full view cursor }
  DrawFullViewCursor;
End;

Procedure TEzAction.UndoOperation;
Begin
  { Clear the caption by default }
  Caption := '';
  If Assigned( FOnUndo ) Then
    FOnUndo( Self );
End;

Function TEzAction.AcceptDrawBox: Boolean;
Begin
  Result := True;
End;

Procedure TEzAction.ParseUserCommand( Const Cmd: String );
Var
  lexer: TEzScrLexer;
  parser: TEzScrParser;
  outputStream: TMemoryStream;
  errorStream: TMemoryStream;
  Stream: TStream;
Begin
  If Length( Cmd ) = 0 Then Exit;
  outputStream := TMemoryStream.create;
  errorStream := TMemoryStream.create;
  Stream := TMemoryStream.Create;
  Stream.Write( Cmd[1], Length( Cmd ) );
  Stream.Seek( 0, 0 );

  lexer := TEzScrLexer.Create;
  lexer.yyinput := Stream;
  lexer.yyoutput := outputStream;
  lexer.yyerrorfile := errorStream;

  parser := TEzScrParser.Create;
  parser.DrawBox := CmdLine.ActiveDrawBox;
  parser.CmdLine := CmdLine;
  parser.checksyntax := False;
  parser.yyLexer := lexer; // lexer and parser linked
  Try
    FUserCommand := itNone;
    If parser.yyparse = 1 Then
    Begin
      // if it is a syntax error, we will consider it a simple string
      FUserCommand := itString;
      FUserString := Cmd;
    End;
  Finally
    parser.free;
    lexer.free;
    outputStream.free;
    errorStream.free;
    Stream.Free;
  End;
End;


{-------------------------------------------------------------------------------}
//                  Implements TEzDrawBoxItem
{-------------------------------------------------------------------------------}

Destructor TEzDrawBoxItem.Destroy;
Begin
  SetDrawBox( Nil );
  Inherited Destroy;
End;

Procedure TEzDrawBoxItem.Assign( Source: TPersistent );
Begin
  If Source Is TEzDrawBoxItem Then
    SetDrawBox( TEzDrawBoxItem(Source).FDrawBox )
  Else
    Inherited Assign( Source );
End;

Function TEzDrawBoxItem.GetDisplayName: String;
Begin
  If FDrawBox <> Nil Then
    result := FDrawBox.Name
  Else
    Result := Inherited GetDisplayName;
End;

Procedure TEzDrawBoxItem.SetDrawBox( Value: TEzBaseDrawBox );
var
  cmdLine: TEzCmdLine;
Begin
  If FDrawBox = Value Then Exit;

  { check if this is pointing to the same TEzBaseGIS component }
  with Collection do
    If (Value <> Nil) And (Count > 0) And
      (TEzDrawBoxItem(Items[0]).FDrawBox <> Nil) And
      (TEzDrawBoxItem(Items[0]).FDrawBox.GIS <> Value.GIS) Then
      raise Exception.Create( sDrawBoxCollectionNotSame );

  cmdLine:= TEzDrawBoxCollection( Collection ).FCmdLine;

  { remove free notification }
{$IFDEF LEVEL5}
  If Assigned( Self.FDrawBox ) Then
    Self.FDrawBox.RemoveFreeNotification( CmdLine );
{$ENDIF}

  { define free notification}
  If Assigned( Value ) Then
    Value.FreeNotification( CmdLine );

  { remove old hooked event handlers }
  If Not (csDesigning In cmdLine.ComponentState) And Assigned(Self.FDrawBox) Then
  Begin
    with Self.FDrawBox do
    begin
      OnMouseDown2D := FSavedMouseDown;
      OnMouseMove2D := FSavedMouseMove;
      OnMouseUp2D := FSavedMouseUp;
      OnClick := FSavedClick;
      OnDblClick := FSavedDblClick;
      OnKeyPress := FSavedKeyPress;
      OnKeyDown := FSavedKeyDown;
      OnPaint := FSavedPaint;
      OnMouseEnter:= FSavedMouseEnter;
      OnMouseLeave:= FSavedMouseLeave;
    end;
  End;

  { hook the event handlers }
  If Not (csDesigning In cmdLine.ComponentState) And Assigned(Value) Then
  Begin
    with Value do
    begin
      { save the pointers to event handlers }
      FSavedMouseDown := OnMouseDown2D;
      FSavedMouseMove := OnMouseMove2D;
      FSavedMouseUp := OnMouseUp2D;
      FSavedClick := OnClick;
      FSavedDblClick := OnDblClick;
      FSavedKeyPress := OnKeyPress;
      FSavedKeyDown := OnKeyDown;
      FSavedPaint := OnPaint;
      FSavedMouseEnter:= OnMouseEnter;
      FSavedMouseLeave:= OnMouseLeave;

      { set the event handlers pointing to methods on this class }
      OnMouseDown2D := cmdLine.DoMouseDown;
      OnMouseMove2D := cmdLine.DoMouseMove;
      OnMouseUp2D := cmdLine.DoMouseUp;
      OnClick := cmdLine.DoClick;
      OnDblClick := cmdLine.DoDblClick;
      OnKeyPress := cmdLine.DoKeyPress;
      OnPaint := cmdLine.DoPaint;
      OnMouseEnter:= cmdLine.DoMouseEnter;
      OnMouseLeave:= cmdLine.DoMouseLeave;
    end;
  End;

  FDrawBox:= Value;

End;

Procedure TEzDrawBoxItem.SetCurrent( Value: Boolean );
Var
  OldCurrent: Boolean;
  I: Integer;
Begin
  OldCurrent:= FCurrent;
  // set all to false
  For I:= 0 to Collection.Count-1 do
    TEzDrawBoxItem(Collection.Items[I]).FCurrent:= False;
  If OldCurrent And Not Value Then
  Begin
    { if set to false, check that at least one is active }
    TEzDrawBoxItem(Collection.Items[0]).FCurrent:= True;
    If Index <> 0 Then
      FCurrent:= Value;
  End Else
    FCurrent:= Value;
End;

{-------------------------------------------------------------------------------}
//                  Implements TEzDrawBoxCollection
{-------------------------------------------------------------------------------}

Constructor TEzDrawBoxCollection.Create( AOwner: TPersistent );
Begin
  Inherited Create( AOwner, TEzDrawBoxItem );
  FCmdLine:= AOwner As TEzCmdLine;
End;

Function TEzDrawBoxCollection.GetItem( Index: Integer ): TEzDrawBoxItem;
Begin
  Result := TEzDrawBoxItem( Inherited GetItem( Index ) );
End;

Procedure TEzDrawBoxCollection.SetItem( Index: Integer; Value: TEzDrawBoxItem );
Begin
  Inherited SetItem( Index, Value );
End;

Function TEzDrawBoxCollection.Add: TEzDrawBoxItem;
Begin
  Result := TEzDrawBoxItem( Inherited Add );
End;

Function TEzDrawBoxCollection.FindCurrent: TEzDrawBoxItem;
var
  I: Integer;
Begin
  Result:= Nil;
  For I:= 0 to Count-1 do
    If TEzDrawBoxItem( Items[I] ).FCurrent Then
    Begin
      Result:= Items[I];
      Break;
    End;
  If (Result=Nil) And (Count > 0) Then
  Begin
    TEzDrawBoxItem( Items[0] ).FCurrent:= True;
    Result:= Items[0];
  End;
End;

Function TEzDrawBoxCollection.FindItem(Sender: TObject): TEzDrawBoxItem;
var
  I: Integer;
Begin
  Result:= Nil;
  For I:= 0 to Count-1 do
    If TEzDrawBoxItem( Items[I] ).FDrawBox = Sender Then
    Begin
      Result:= Items[I];
      Break;
    End;
  If (Result=Nil) And (Count > 0) Then
  Begin
    Result:= Items[0];
  End;
End;

Procedure TEzDrawBoxCollection.SetCurrent( Value: TObject );
Var
  I: Integer;
Begin
  For I:= 0 to Count-1 do
    If TEzDrawBoxItem(Items[I]).FDrawBox = Value Then
    Begin
      TEzDrawBoxItem(Items[I]).Current:= True;
      Exit;
    End;
End;

{-------------------------------------------------------------------------------}
//                  TEzCmdLineEdit
{-------------------------------------------------------------------------------}

Procedure TEzCmdLineEdit.KeyPress( Var Key: Char );
Var
  Item: TEzDrawBoxItem;
Begin
  With (Parent As TEzCmdLine) Do
  Begin
    If ( FActionList = Nil ) Or ( ActiveDrawBox = Nil ) Then Exit;
    Item:= FDrawBoxList.FindCurrent;
    If Assigned( Item.FSavedKeyPress ) Then
      Item.FSavedKeyPress( Item.FDrawBox, Key );
    Try
      If Assigned( CurrentAction.OnKeyPress ) And ( Length( Self.Text ) = 0 ) Then
      Begin
        CurrentAction.OnKeyPress( Parent, Key );
        If CurrentAction.Finished Then Pop;
      End;
    Except
      Clear;
      Raise;
    End;
    If Key = #0 Then Exit;
    If ( Key = #13 ) And ( Length( Self.Text ) = 0 ) And
      CurrentAction.WaitingMouseClick And Not EqualPoint2d( FLastClicked, INVALID_POINT ) Then
    Begin
      Self.Text := FloatToStr( FLastClicked.X ) + ',' + FloatToStr( FLastClicked.Y );
      //Pass:= False;
    End;
    If ( Key = #13 ) {Or ( Key = #32 )} Then
    Begin
      { possibly it is a direct command: POLYLINE, POLYGON, etc.}
      InternalDoCommand( Self.Text, CurrentAction.FActionID, FActionList.Count > 0 );
      If ActiveDrawBox.Visible And ActiveDrawBox.Enabled Then
        Windows.SetFocus(ActiveDrawBox.Handle);
      Self.Text := '';
    End;
    If Key = #27 Then
    Begin
      Self.Text := '';
      If ActiveDrawBox.Visible And ActiveDrawBox.Enabled Then
        Windows.SetFocus(ActiveDrawBox.Handle);
    End
    Else If ( Key In [#33..#255] ) And Not Self.Focused Then
    Begin
      If ( self.visible And self.enabled ) And ( visible And enabled ) Then
        Windows.SetFocus(Self.Handle);
      If Key In [#33..#255] Then
        Self.Text := Self.Text + Key;
      Self.SelStart := Length( Self.Text );
    End;
  End;
  Inherited KeyPress( Key );
End;

{-------------------------------------------------------------------------------}
//                  TEzCmdLine
{-------------------------------------------------------------------------------}

Var
  FAccuSnapPictures: Array[TEzOsnapSetting] Of TBitmap;
  FAccuSnapPicFocused: TBitmap;
  FAccuSnapPicUnFocused: TBitmap;

const
  ImageNames: array[TEzOsnapSetting] of PChar = (  'SNAP_ENDPOINT',
                                                   'SNAP_MIDPOINT',
                                                   'SNAP_CENTER',
                                                   'SNAP_INTERSECT',
                                                   'SNAP_PERPEND',
                                                   'SNAP_TANGENT',
                                                   'SNAP_NEAREST',
                                                   'SNAP_ORIGIN',
                                                   'SNAP_PARALLEL',
                                                   'SNAP_KEYPOINT',
                                                   'SNAP_BISECTOR'
                                                    );

Constructor TEzCmdLine.Create( AOwner: TComponent );
Var
  DC: THandle;
  ScreenDpiX, ScreenDpiY: Integer;
Begin
  Inherited Create( AOwner );
  FLabel := TLabel.Create( Self );
  FLabel.Parent := Self;
  FLabel.Align := alLeft;
  FLabel.Caption := SCommand;
  FEdit := TEzCmdLineEdit.Create( Self );
  FEdit.Parent := Self;
  FEdit.Align := alClient;
  FEdit.BorderStyle := bsNone;
  FBorderStyle := bsSingle;
  FActionList := TList.Create;
  FTheDefaultAction := TTheDefaultAction.CreateAction( Self );
  FShortCuts := TStringList.Create;
  FDisabledCommands := TStringList.Create;
  FShowMeasureInfoWindow := True;
  DC := GetDC( 0 );
  ScreenDpiX := GetDeviceCaps( DC, LOGPIXELSX );
  ScreenDpiY := GetDeviceCaps( DC, LOGPIXELSY );
  ReleaseDC( 0, DC );
  { By default, 1/8 of an inch to snap to a guideline }
  FGLSnapAperture := Point( ScreenDpiX Div 8, ScreenDpiY Div 8 );
  // command line processing
  TabStop := False;
  Font.Handle:= EzSystem.DefaultFontHandle;
  Height := 24;
  Align := alBottom;
  Color := clWhite;
  FLastClicked := INVALID_POINT;
  FUseFullViewCursor := True;
  FAccuSnap := TEzAccuSnap.Create( Self );
  FAccuDraw := TEzAccuDraw.Create( Self );
  FDrawBoxList:= TEzDrawBoxCollection.Create(Self);
End;

Destructor TEzCmdLine.Destroy;
begin
  Clear;
  FActionList.Free;
  FTheDefaultAction.Free;
  FShortCuts.Free;
  FDisabledCommands.Free;
  FAccuSnap.Free;
  FAccuDraw.Free;
  FreeAndNil( FDrawBoxList );
  Inherited Destroy;
End;

procedure TEzCmdLine.SetDrawBoxList(const Value: TEzDrawBoxCollection);
begin
  FDrawBoxList.Assign( Value );
end;

Procedure TEzCmdLine.CreateParams( Var Params: TCreateParams );
Begin
  Inherited CreateParams( Params );
  With Params Do
  Begin
    Style := Style Or WS_TABSTOP;
    WindowClass.style := CS_DBLCLKS;
    If fBorderStyle = bsSingle Then
      If NewStyleControls And Ctl3D Then
      Begin
        Style := Style And Not WS_BORDER;
        ExStyle := ExStyle Or WS_EX_CLIENTEDGE;
      End
      Else
        Style := Style Or WS_BORDER;
  End;
End;

procedure TEzCmdLine.SetAutoMoveEnabled(const Value: Boolean);
begin
  FAutoMoveEnabled := Value;
end;

Procedure TEzCmdLine.SetBorderStyle( Const Value: forms.TBorderStyle );
Begin
  If FBorderStyle <> Value Then
  Begin
    FBorderStyle := Value;
    RecreateWnd;
  End;
End;

Procedure TEzCmdLine.SetShortCuts( Value: TStrings );
Begin
  FShortCuts.Assign( Value );
End;

Procedure TEzCmdLine.SetDisabledCommands( Value: TStrings );
Begin
  FDisabledCommands.Assign( Value );
End;

Procedure TEzCmdLine.InternalDoCommand( Const Cmd, ActionID: String; IsParam: Boolean );
Var
  TmpCmd, ShortCut, ErrorMessage: String;
  Accept, Processed: Boolean;

  Function ParseScript( Const PCmd: String ): Boolean;
  Var
    lexer: TEzScrLexer;
    parser: TEzScrParser;
    outputStream: TMemoryStream;
    errorStream: TMemoryStream;
    Stream: TStream;
  Begin
    result := False;
    If Length( PCmd ) = 0 Then Exit;
    outputStream := TMemoryStream.create;
    errorStream := TMemoryStream.create;
    Stream := TMemoryStream.Create;
    Stream.Write( PCmd[1], Length( PCmd ) );
    Stream.Seek( 0, 0 );

    lexer := TEzScrLexer.Create;
    lexer.yyinput := Stream;
    lexer.yyoutput := outputStream;
    lexer.yyerrorfile := errorStream;

    parser := TEzScrParser.Create;
    parser.DrawBox := Self.ActiveDrawBox;
    parser.MustRepaint := True;
    { this indicates that the checking is not done for parameters for the
      current Action, but for a full script command, like
      LINE (0,0), (10,10) }
    parser.CmdLine := Nil;
    parser.checksyntax := False;
    parser.yyLexer := lexer; // lexer and parser linked
    Try
      result := Not ( parser.yyparse = 1 );
    Finally
      parser.free;
      lexer.free;
      outputStream.free;
      errorStream.free;
      Stream.Free;
    End;
  End;

Begin
  Assert( ActiveDrawBox <> Nil );
  TmpCmd := Cmd;
  If Length( TmpCmd ) = 0 Then
    TmpCmd := FLastCommand;
  If Length( TmpCmd ) = 0 Then Exit;
  If ActiveDrawBox.GIS.Layers.Count = 0 Then
  Begin
    MessageToUser( SThereAreNoLayers, smsgerror, MB_ICONERROR );
    Exit;
  End;
  Try
    // First, replace with a shortcut if it is found
    ErrorMessage := sUnrecognizedCommand;
    If IsParam And IsBusy Then
    Begin
      { send what user typed to the current Action
       that is not the default Action }
      CurrentActionDoCommand( TmpCmd );
    End
    Else
    Begin
      Processed := True;

      If FShortCuts.Count > 0 Then
      Begin
        ShortCut := FShortCuts.Values[TmpCmd];
        If Length( ShortCut ) > 0 Then
          TmpCmd := ShortCut;
      End;
      If FDisabledCommands.IndexOf( TmpCmd ) >= 0 Then
        TmpCmd := '';

      { check if the command is accepted }
      If Assigned( FOnBeforeCommand ) Then
      Begin
        Accept := True;
        FOnBeforeCommand( Self, TmpCmd, ActionID, ErrorMessage, Accept );
        If Not Accept Then
        Begin
          Text := '';
          If Length( ErrorMessage ) > 0 Then
            MessageToUser( ErrorMessage, smsgerror, MB_ICONERROR );
          Exit;
        End;
      End;
      { check if there is a shortcut for this command }
      If Assigned( FOnShortCut ) Then
        FOnShortCut( Self, TmpCmd );

      { process the internal implemented Actions}
      If Not ExecCommand( Self, AnsiUpperCase(TmpCmd), ActionID ) Then
      Begin
        Processed := false;
        If Assigned( FOnUnknownCommand ) Then
          FOnUnknownCommand( Self, TmpCmd, ActionID, Processed );
        If Not Processed Then
        Begin
          { check if it is a direct command and can be parsed without syntax errors }
          Processed := ParseScript( TmpCmd );
          If Not Processed Then
            MessageToUser( ErrorMessage, smsgerror, MB_ICONERROR );
        End;
      End;
      If Not(Processed And ( Length( TmpCmd ) > 0 )) Then Text := '';
    End;
  Except
    On E: Exception Do
    Begin
      MessageToUser( E.Message, smsgerror, MB_ICONERROR );
      Clear;
    End;
  End;
End;

// command line processing

Procedure TEzCmdLine.DoCommand( Const Cmd, ActionID: String );
Begin
  InternalDoCommand( Cmd, ActionId, False );
End;

Procedure TEzCmdLine.CaptionChange( Const Value: String );
Begin
  If Length(Value) = 0 Then
    FLabel.Caption:= SCommand
  Else
    FLabel.Caption:= Value;
  Text := '';
End;

Function TEzCmdLine.IsBusy: Boolean;
Begin
  Result := CurrentAction <> TheDefaultAction;
End;

Function TEzCmdLine.GetActiveDrawBox: TEzBaseDrawBox;
var
  Item: TEzDrawBoxItem;
Begin
  Result:= Nil;
  If (FDrawBoxList = Nil) Or (FDrawBoxList.Count=0) Then Exit;
  Item:= FDrawBoxList.FindCurrent;
  If Item <> Nil Then
    Result:= Item.FDrawBox
  Else
  Begin
    FDrawBoxList[0].FCurrent:= True;
    Result:= FDrawBoxList.Items[0].DrawBox;
  End;
End;

Procedure TEzCmdLine.Clear;
Var
  I: Integer;
  Action: TEzAction;
Begin
  If FClearing Then Exit;
  FClearing := true;
  Try
    FAccuDraw.Showing:= False;
    For I := 0 To FActionList.Count - 1 Do
    begin
      Action := TEzAction( FActionList[I] );
      Action.Cancelled := True;
      KillAction( Action );
    End;
    FActionList.Clear;

    FLabel.Caption := SCommand;
    FEdit.Text := '';
    All_Cursor( FTheDefaultAction.Cursor );
  Finally
    FClearing := false;
  End;
End;

Procedure TEzCmdLine.SetTheDefaultAction( Value: TEzAction );
Begin
  If ( csDesigning In ComponentState ) then Exit;
  { TEzCmdLine is responsible for freeing FTheDefaultAction
    so, assigns will be something like:
    CmdLine.DefaultAction := TScrollingAction.Create(nil) }
  //if not(FTheDefaultAction is TMapActionHook) then
  FTheDefaultAction.Free;
  if Value = Nil then  // if tried to set to nil, then set the default action
    FTheDefaultAction := TTheDefaultAction.CreateAction( Self )
  else
    FTheDefaultAction := Value;
  FTheDefaultAction.FCmdLine := Self; { ensure valid TEzCmdLine in Action }
End;

Function TEzCmdLine.CurrentAction: TEzAction;
Begin
  Result := FTheDefaultAction;
  If ( FActionList = Nil ) Or ( FActionList.Count = 0 ) Then Exit;
  Result := TEzAction( FActionList[FActionList.Count - 1] );
End;

Function TEzCmdLine.PreviousAction: TEzAction;
Begin
  Result := FTheDefaultAction;
  If ( FActionList = Nil ) Or ( FActionList.Count < 2 ) Then Exit;
  Result := TEzAction( FActionList[FActionList.Count - 2] );
End;

Procedure TEzCmdLine.KillAction( var Action: TEzAction );
begin
  FDeletingActionID := Action.FActionID ;
  { fires event OnFinished }
  if ( Action.FLauncher <> Nil ) And Assigned( TEzActionLauncher( Action.FLauncher ).OnFinished ) then
  begin
    TEzActionLauncher( Action.FLauncher ).OnFinished( Action.FLauncher );
  end;
  FreeAndNil( Action );
  FDeletingActionID := '' ;
end;

Procedure TEzCmdLine.Push( Action: TEzAction; ClearBefore: Boolean;
  Const Cmd, ActionID: String );
var
  TmpCursor: TCursor;
Begin

  { can this Action be pushed to the top of the list ? }
  If ( ActiveDrawBox = Nil ) Or Not ( CurrentAction.CanBeSuspended ) Or Not ( Action.AcceptDrawBox ) Then
  Begin
    KillAction( Action );
    If ActiveDrawBox <> Nil Then
      All_Cursor( CurrentAction.Cursor );
    CaptionChange( CurrentAction.Caption );
    Exit;
  End;

  FAccuDraw.Showing:= False;

  If EqualPoint2d( FAccuDraw.FAccuOrigin, INVALID_POINT ) Then
    { move the accudraw at the center of the screen if it is undefined }
    FAccuDraw.ChangeOrigin(ActiveDrawBox.Grapher.CurrentParams.MidPoint);

  { must clear all stacked Actions ? }
  If ClearBefore Then
    Clear
  Else
    CurrentAction.SuspendOperation;

  { retrieve a custom cursor for this action with the event }
  if Assigned(OnGetCursor) then
  begin
    TmpCursor:= Action.Cursor;
    OnGetCursor(Self, Cmd, ActionID, TmpCursor );
    if Action.Cursor <> TmpCursor then
      Action.Cursor:= TmpCursor;
  end;

  { set the cursor for this Action }
  If (mdCursor in Action.FMouseDrawElements) Or Not FUseFullViewCursor Then
    All_Cursor( Action.Cursor )
  Else
    All_Cursor( crHidden );

  { add to the list of Actions }
  FActionList.Add( Action );

  { update the identifier }
  Action.FActionID := ActionID;
  FLastActionID := ActionID;
  if Length(Cmd) > 0 then FLastCommand := Cmd;

  { defines an initial caption for the command line }
  FLabel.Caption := Action.Caption;
  FEdit.Text := '';

  If Action.CanDoAccuDraw Then
  Begin
    FAccuDraw.Reset;
    FAccuDraw.Showing:= True;
  End;

  All_Invalidate;

  { notify to TEzCmdLine of the change on Action }
  If Assigned( FOnActionChange ) Then
    FOnActionChange( Self );
End;

Procedure TEzCmdLine.Pop;
Var
  Index: Integer;
  Info: String;
  FinishedAction: TEzAction;
  ChainedTo: TEzAction;
Begin
  Assert( ActiveDrawBox <> Nil );

  Index := FActionList.Count - 1;
  If Index < 0 Then Exit;

  FAccuSnap.EraseFromScreen;
  FAccuSnap.OverrideOsnap:= False;

  { get the finished Action }
  FinishedAction := TEzAction( FActionList[Index] );

  { is there some info for next Action ?}
  Info := FinishedAction.FInfoForPrevious;

  FAccuDraw.Showing:= False;

  ChainedTo := FinishedAction.FChainedTo;
  If ChainedTo <> Nil Then
  Begin
    If Assigned( ChainedTo.OnInitialize ) Then
      ChainedTo.OnInitialize( Self );
    ChainedTo.FActionID := FinishedAction.FActionID;
    FActionList.Add( ChainedTo );
  End;

  FActionList.Delete( Index );

  { free the finished Action }
  KillAction( FinishedAction );

  { set the cursor for the current Action }
  If mdCursor in CurrentAction.FMouseDrawElements Then
    All_Cursor( CurrentAction.Cursor )
  Else
    All_Cursor( crHidden );

  { pass the infor from the previous to the new one }
  If Length( Info ) > 0 Then
    CurrentActionDoCommand( Info );

  { allow current Action to continue }
  CurrentAction.ContinueOperation;

  { update the command line caption }
  If FActionList.Count = 0 Then
  Begin
    FEdit.Text := '';
    FLabel.Caption := SCommand;
  End;

  { Don't do OSNAP if the current state cannot do it }
  If ( FAccuSnap.FCurrentSnapInfo.Picture <> Nil ) And Not CurrentAction.CanDoOSNAP Then
    FAccuSnap.EraseFromScreen;

  FAccuDraw.Showing:= CurrentAction.CanDoAccuDraw;

  All_Invalidate();

  { notify of Action change to the TEzCmdLine event handler }
  If Assigned( FOnActionChange ) Then
    FOnActionChange( Self );
End;

Procedure TEzCmdLine.AddPointToCurrentAction( const P: TEzPoint );
Begin
  { in most cases 0,0 will work because if I try to change P to device coords, it
    can cause AV errors for very large pixels }
  DoMouseMove( Self, [], 0, 0, P.X, P.Y );
  DoMouseDown( Self, mbLeft, [], 0, 0, P.X, P.Y );
  DoMouseUp( Self, mbLeft, [], 0, 0, P.X, P.Y );
End;

Procedure TEzCmdLine.AddPointListToCurrentAction( const P: TEzVector );
var
  I: Integer;
Begin
  For I:= 0 to P.Count-1 do
    AddPointToCurrentAction( P[I] );
End;

Procedure TEzCmdLine.AddRelativePointToCurrentAction( const P: TEzPoint );
Begin
  If Not EqualPoint2d(CurrentAction.FLastClicked,INVALID_POINT) then
  Begin
     AddPointToCurrentAction( Point2d( CurrentAction.FLastClicked.X + P.X, CurrentAction.FLastClicked.Y + P.Y) );
  End;
End;

{ angle is in degrees }
Procedure TEzCmdLine.AddRelativeAngleToCurrentAction( const Dist, Angle: Double );
var
  DeltaX,DeltaY,AngRad:Double;
Begin
  If Not EqualPoint2d(CurrentAction.FLastClicked,INVALID_POINT) then
  begin
    AngRad:= DegToRad( Angle );
    DeltaX:= Dist * Cos(AngRad);
    DeltaY:= Dist * Cos(AngRad);
    AddPointToCurrentAction( Point2d( CurrentAction.FLastClicked.X + DeltaX, CurrentAction.FLastClicked.Y + DeltaY) );
  end;
End;

Procedure TEzCmdLine.DoMouseDown( Sender: TObject; Button: TMouseButton; Shift:
  TShiftState; X, Y: Integer; Const WX, WY: Double );
var
  TmpPt: TEzPoint;
  Item: TEzDrawBoxItem;
Begin
  FIsMouseDown := True;

  { define the active drawbox }
  Item := FDrawBoxList.FindCurrent;

  If Assigned( Item.FSavedMouseDown ) Then
    Item.FSavedMouseDown( Sender, Button, Shift, X, Y, WX, WY );

  If Button = mbLeft Then
    FCurrentPoint := Point2D( WX, WY );

  with FAccuSnap.FCurrentSnapInfo do
  begin
    If (Button = mbLeft) And FAccuSnap.Enabled And FAccuDraw.Enabled //And Showing
       And (Picture = FAccuSnapPicFocused) And
       (FAccuSnap.GetCurrentOsnapSetting = osParallel) then
    begin
      If Not EqualPoint2d(CurrentAction.FLastClicked,INVALID_POINT) then
      begin
        CurrentAction.EraseFullViewCursor;
        If Assigned(CurrentAction.OnSuspendOperation) Then
          CurrentAction.OnSuspendOperation( Self );
        FAccuDraw.ChangeOrigin( FAccuDraw.FAccuOrigin, Angle2d(RefFrom,RefTo));
        FAccuDraw.DeltaY:= 0;
        FAccuDraw.DeltaYLocked:= True;
        If Assigned(CurrentAction.OnContinueOperation) Then
          CurrentAction.OnContinueOperation( Self );
        CurrentAction.DrawFullViewCursor;
      end else
      begin
        IsNextParallel:= True;
      end;
      Exit;
    end;
  end;

  Try

    { erase from screen our full view cursor or frame cursor in case changed something }
    CurrentAction.EraseFullViewCursor;

    If Assigned( CurrentAction.OnMouseDown ) Then
      CurrentAction.OnMouseDown( Sender, Button, Shift, X, Y, WX, WY );

    { restore the full view cursor or frame cursor }
    CurrentAction.DrawFullViewCursor;

    If CurrentAction.Finished Then
      Self.Pop
    else If Button = mbLeft Then
      with FAccuSnap.FCurrentSnapInfo do
      begin
        { check for parallel snap }
        If FAccuSnap.Enabled And FAccuDraw.Enabled And IsNextParallel then
        begin
          CurrentAction.EraseFullViewCursor;
          If Assigned(CurrentAction.OnSuspendOperation) Then
            CurrentAction.OnSuspendOperation( Self );
          FAccuDraw.ChangeOrigin( FAccuDraw.FAccuOrigin, Angle2d(RefFrom,RefTo));
          If Assigned(CurrentAction.OnContinueOperation) Then
            CurrentAction.OnContinueOperation( Self );
          CurrentAction.DrawFullViewCursor;
        end;
        IsNextParallel:= False;

        { check for perpendicular }
        If FAccuSnap.Enabled And FAccuDraw.Enabled And Showing And
          (Picture = FAccuSnapPicFocused) And
          (FAccuSnap.GetCurrentOsnapSetting = osPerpend) then
        begin
          CurrentAction.EraseFullViewCursor;
          If Assigned(CurrentAction.OnSuspendOperation) Then
            CurrentAction.OnSuspendOperation( Self );
          TmpPt:= Perpend( Point2d(WX,WY), RefFrom,RefTo);
          FAccuDraw.ChangeOrigin( TmpPt, Angle2d(RefFrom,RefTo));
          FAccuDraw.DeltaX:= 0;
          FAccuDraw.DeltaXLocked:= True;
          If Assigned(CurrentAction.OnContinueOperation) Then
            CurrentAction.OnContinueOperation( Self );
          CurrentAction.DrawFullViewCursor;
        end;
      end;

    If Button = mbLeft Then
    Begin
      FLastClicked := Point2D( WX, WY );
      CurrentAction.FLastClicked:= Point2D( WX, WY );
    End;

    { this fires event OnAccuSnapChange }
    FAccuSnap.OverrideOsnap:= False;
  Except
    { Cancel all Actions if exception }
    Clear;

    Raise;
  End;
End;

Procedure TEzCmdLine.DoMouseMove( Sender: TObject; Shift: TShiftState;
  X, Y: Integer; Const WX, WY: Double );
Var
  Item: TEzDrawBoxItem;
Begin
  { define the active drawbox }
  Item := FDrawBoxList.FindCurrent;

  If Assigned( Item.FSavedMouseMove ) Then
    Item.FSavedMouseMove( Sender, Shift, X, Y, WX, WY );

  { accudraw auxiliary snap lines }
  If Not FIsMouseDown Then
  Begin
    { erase accudraw previous auxiliary snap lines }
    If FAccuDraw.Showing Then
      FAccuDraw.EraseAuxLines;
  End;

  FCurrentPoint := Point2D( WX, WY );

  If Not FIsMouseDown Then
  Begin

    { update the accusnap entity }
    FAccuSnap.UpdateAccuSnapEntity;

    { accudraw draw new position auxiliary snap lines }
    If FAccuDraw.Showing Then
    Begin
      FAccuDraw.DrawAuxLines;

      FAccuDraw.Change;
    End;

  End;

  Try

    { erase full view cursor and frame cursor }
    CurrentAction.EraseFullViewCursor;

    If Assigned( CurrentAction.OnMouseMove ) Then
      CurrentAction.OnMouseMove( Sender, Shift, X, Y, WX, WY );

    If CurrentAction.Finished Then
      Self.Pop
    Else
    Begin
      { set new position of cursor and draw again }
      CurrentAction.SetFullViewCursorPos(Point2D(WX, WY));
      CurrentAction.DrawFullViewCursor;
    End;
  Except
    Clear;
    Raise;
  End;
End;

Procedure TEzCmdLine.DoMouseUp( Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer; Const WX, WY: Double );
Var
  Item: TEzDrawBoxItem;
Begin
  FIsMouseDown := False;

  { define the active drawbox }
  Item := FDrawBoxList.FindCurrent;

  If Assigned( Item.FSavedMouseUp ) Then
    Item.FSavedMouseUp( Sender, Button, Shift, X, Y, WX, WY );

  FCurrentPoint := Point2D( WX, WY );
  Try
    If Assigned( CurrentAction.OnMouseUp ) Then
      CurrentAction.OnMouseUp( Sender, Button, Shift, X, Y, WX, WY );
    If CurrentAction.Finished Then
      Self.Pop;
  Except
    Clear;
    Raise;
  End;
End;

Procedure TEzCmdLine.DoKeyPress( Sender: TObject; Var Key: Char );
Begin
  FEdit.KeyPress( Key );
End;

Procedure TEzCmdLine.DoPaint( Sender: TObject );
var
  Item: TEzDrawBoxItem;
Begin
  { define the active drawbox }
  Item := FDrawBoxList.FindItem( Sender );

  if FAccuSnap.FCurrentSnapInfo.Picture <> Nil then
  begin
    FAccuSnap.FCurrentSnapInfo.Showing:= False;
    FAccuSnap.DrawAccuSnap( True );
  end;

  { draw the accudraw object }
  If FAccuDraw.FShowing Then
  Begin
    FAccuDraw.FRubberList.Clear;
    FAccuDraw.Draw;
    FAccuDraw.DrawAuxLines;
  End;

  If Assigned( Item.FSavedPaint ) Then
    Item.FSavedPaint( Sender );

  Try
    If Assigned( CurrentAction.OnPaint ) Then
      CurrentAction.OnPaint( Sender );

    { draw the full view cursor }
    If Item.Current Then
      CurrentAction.DrawFullViewCursor(Sender);

  Except
    Clear;
    Raise;
  End;

End;

Procedure TEzCmdLine.DoClick( Sender: TObject );
Var
  Item: TEzDrawBoxItem;
Begin
  { define the active drawbox }
  Item := FDrawBoxList.FindCurrent;

  If Assigned( Item.FSavedClick ) Then
    Item.FSavedClick( Sender );
  Try
    If Assigned( CurrentAction.OnClick ) Then
      CurrentAction.OnClick( Sender );
    If CurrentAction.Finished Then
      Self.Pop;
  Except
    Clear;
    Raise;
  End;
End;

Procedure TEzCmdLine.DoDblClick( Sender: TObject );
Var
  CurrAction: TEzAction;
  Item: TEzDrawBoxItem;
Begin
  { define the active drawbox }
  Item := FDrawBoxList.FindCurrent;

  If Assigned( Item.FSavedDblClick ) Then
    Item.FSavedDblClick( Sender );
  Try
    CurrAction := CurrentAction;
    If ( CurrAction <> Nil ) And Assigned( CurrAction.OnDblClick ) Then
      CurrAction.OnDblClick( Sender );
    If CurrAction.Finished Then
      Self.Pop;
  Except
    Clear;
    Raise;
  End;
End;

Procedure TEzCmdLine.CurrentActionDoCommand( Const Cmd: String );
Var
  CurrAction: TEzAction;
Begin
  CurrAction := CurrentAction;
  If CurrAction = Nil Then Exit;
  Try
    CurrAction.ParseUserCommand( cmd );
    If (CurrAction.UserCommand <> itNone) And Assigned( CurrAction.OnActionDoCommand ) Then
    Begin
      CurrAction.OnActionDoCommand( Self );
      If CurrAction.Finished Then
        Self.Pop;
    End
    Else
      CurrAction.Caption := '';
  Except
    Clear;
    Raise;
  End;
End;

Function TEzCmdLine.GetSnappedPoint(Remove: Boolean = False): TEzPoint;
Var
  TmpX, TmpY, Delta, TmpAngle: Double;
  cnt: Integer;
  TmpPt: TEzPoint;
  TmpBox: TEzRect;
  AffectedX, AffectedY: boolean;
  CurrAperture: TEzPoint;
  p1,p2: TEzPoint;
  M: TEzMatrix;
Begin
  //Assert( ActiveDrawBox <> Nil );

  FAccuDraw.FPerpendFound:= False;

  If FAccuDraw.FShowing And FAccuDraw.FDeltaXLocked And FAccuDraw.FDeltaYLocked Then
  Begin
    Result:= FAccuDraw.GetSnappedPoint;
    Exit;
  End;

  Result := FCurrentPoint;

  { first check in AccuSnap }
  If (FAccuSnap.FCurrentSnapInfo.Picture <> Nil) And
     (FAccuSnap.FCurrentSnapInfo.Picture = FAccuSnapPicFocused) Then
  Begin
    Result:= FAccuSnap.FCurrentSnapInfo.SnapPoint
  End Else
  Begin

    { now check in the guidelines }
    AffectedX := false;
    AffectedY := false;
    If ActiveDrawBox.SnapToGuideLines Then
      With ActiveDrawBox Do
      Begin
        With Grapher Do
          CurrAperture := Point2D( DistToRealX( FGLSnapAperture.X ), DistToRealY( FGLSnapAperture.Y ) );
        {search on vertical lines}
        For cnt := 0 To GIS.VGuideLines.Count - 1 Do
          With Grapher.CurrentParams.VisualWindow Do
          Begin
            TmpX := GIS.VGuideLines[cnt];
            If ( TmpX < Emin.X ) Or ( TmpX > Emax.X ) Then
              Continue;
            TmpPt := Point2D( TmpX, FCurrentPoint.Y );
            TmpBox := Rect2D( TmpPt.X - CurrAperture.X, TmpPt.Y - CurrAperture.Y,
              TmpPt.X + CurrAperture.X, TmpPt.Y + CurrAperture.Y );
            If IsPointInBox2D( FCurrentPoint, TmpBox ) Then
            Begin
              Result.X := TmpX;
              AffectedX := true;
              Break;
            End;
          End;
        { now the horizontal guidelines }
        For cnt := 0 To GIS.HGuideLines.Count - 1 Do
          With Grapher.CurrentParams.VisualWindow Do
          Begin
            TmpY := GIS.HGuideLines[cnt];
            If ( TmpY < Emin.Y ) Or ( TmpY > Emax.Y ) Then
              Continue;
            TmpPt := Point2D( FCurrentPoint.X, TmpY );
            TmpBox := Rect2D( TmpPt.X - CurrAperture.X, TmpPt.Y - CurrAperture.Y,
              TmpPt.X + CurrAperture.X, TmpPt.Y + CurrAperture.Y );
            If IsPointInBox2D( FCurrentPoint, TmpBox ) Then
            Begin
              Result.Y := TmpY;
              AffectedY := true;
              Break;
            End;
          End;
      End;

    { check if snapped to the grid }
    If ActiveDrawBox.GridInfo.SnapToGrid Then
      With FCurrentPoint, ActiveDrawBox.GridInfo Do
      Begin
        If Not AffectedX Then
          Result.X := Round( X / GridSnap.X ) * GridSnap.X + GridOffset.X;
        If Not AffectedY Then
          Result.Y := Round( Y / GridSnap.Y ) * GridSnap.Y + GridOffset.Y;
      End;
  End;

  { if it is not locked to an AccuSnap point, the guidelines or the grid and
   one of the axis is locked, then obtain the perpendicular projection from the
   snapped point to the axis }
  If FAccuDraw.FShowing Then
  Begin
    { si el punto de snap no es igual al punto actual, y esta locked a uno de
      los ejes. Tiene preferencia sobre este un punto de AccuSnap, lineas guia
      o el grid }
    If Not EqualPoint2d( Result, FCurrentPoint ) And
       ( FAccuDraw.FDeltaXLocked Or FAccuDraw.FDeltaYLocked) Then
    Begin
      p1:= FAccuDraw.FAccuOrigin;
      If FAccuDraw.FFrameStyle = fsRectangular then
      begin
        If FAccuDraw.FDeltaXLocked Then
        Begin
          p1.X := p1.X + FAccuDraw.FDeltaX;
          p2:= p1;
          p2.y := p2.Y + ActiveDrawBox.Grapher.DistToRealY( FAccuDraw.FWidth );
        End Else
        Begin
          p1.y := p1.y + FAccuDraw.FDeltaY;
          p2:= p1;
          p2.x := p2.x + ActiveDrawBox.Grapher.DistToRealX( FAccuDraw.FWidth );
        End;
        { rotate the points }
        M:= Rotate2d( FAccuDraw.FRotangle, FAccuDraw.FAccuOrigin );
        p1:= TransformPoint2D( p1, M );
        p2:= TransformPoint2D( p2, M );
        { flag it. Please don't move from here. This is used for showing the AuxLines
          as dotted lines  }
        FAccuDraw.FPerpendFound:= True;
        FAccuDraw.FPerpendFrom:= Result;
        { find perpendicular projection of snapped point on the previous line }
        Result:= Perpend( Result, p1, p2 );
      end else with FAccuDraw do
      begin
        If DistLocked Then
        begin
          { calcular el punto para la distancia fija }
          FPerpendFound:= True;
          FPerpendFrom:= Result;
          TmpAngle:= Angle2d( FAccuOrigin, Result);
          Result:= Point2d( FAccuOrigin.X + Cos( TmpAngle ) * Dist,
                            FAccuOrigin.Y + Sin( TmpAngle ) * Dist );
        end else if AngleLocked Then
        begin
          FPerpendFound:= True;
          FPerpendFrom:= Result;
          { find a tentative point and with the angle fixed }
          Delta:= ActiveDrawBox.Grapher.DistToRealY( FAccuDraw.FWidth );
          TmpAngle:= FAccuDraw.FRotangle + Angle;
          p1:= FAccuOrigin;
          p2:= Point2d( FAccuOrigin.X + Delta * Cos(TmpAngle), FAccuOrigin.Y + Delta * Sin(TmpAngle));
          Result:= Perpend( Result, p1, p2 );
        end;
      end;
    End Else If EqualPoint2d( Result, FCurrentPoint ) And FAccuDraw.FSnapToAxis Then
    Begin
      { Return an AccuDraw snapped point }
      Result := FAccuDraw.GetSnappedPoint;
    End;
  End;
End;

Procedure TEzCmdLine.Notification( AComponent: TComponent; Operation: TOperation );
Var
  I: Integer;
  Item: TEzDrawBoxItem;
Begin
  Inherited Notification( AComponent, Operation );
  If ( Operation = opRemove ) And Assigned( FDrawBoxList ) Then
  Begin
    For I := FDrawBoxList.Count - 1 DownTo 0 Do
    Begin
      Item := FDrawBoxList[I];
      If AComponent = Item.FDrawBox Then
      Begin
        Item.Free;
      End;
    End;
    If FDrawBoxList.Count = 0 Then
      Self.Clear;
  End;
End;

Function TEzCmdLine.IsSnapped: Boolean;
Begin
  //Assert( ActiveDrawBox <> Nil );
  Result := ActiveDrawBox.SnapToGuideLines Or ActiveDrawBox.GridInfo.SnapToGrid Or
            (FAccuSnap.FCurrentSnapInfo.Picture<>Nil) Or
            ( FAccuDraw.FShowing And
              ( FAccuDraw.FSnapToAxis Or FAccuDraw.FSnapUnrotated Or
                FAccuDraw.FDeltaXLocked Or FAccuDraw.FDeltaYLocked ) );
End;

Function TEzCmdLine.CurrentActionID: String;
Begin
  Result := CurrentAction.FActionID;
End;

Procedure TEzCmdLine.SetStatusMessage( Const Value: String );
Begin
  If Assigned( FOnStatusMessage ) Then
    FOnStatusMessage( Self, Value );
End;

Procedure TEzCmdLine.CMColorChanged( Var Message: TMessage );
Begin
  Inherited;
  FEdit.Color := Color;
  FLabel.Color := Color;
End;

Function TEzCmdLine.GetText: String;
Begin
  result := FEdit.Text;
End;

Procedure TEzCmdLine.SetText( Const Value: String );
Begin
  FEdit.Text := Value;
End;

Function TEzCmdLine.GetCaption: String;
Begin
  result := FLabel.Caption;
End;

Procedure TEzCmdLine.SetCaption( Const Value: String );
Begin
  FLabel.Caption := Value;
End;

Procedure TEzCmdLine.CMFontChanged( Var Message: TMessage );
Begin
  Inherited;
  If Assigned( FEdit.Font ) Then
    FEdit.Font.Assign( Font );
  If Assigned( FLabel.Font ) Then
    FLabel.Font.Assign( Font );
End;

procedure TEzCmdLine.DoMouseEnter(Sender: TObject);
var
  Pt: TPoint;
  Item: TEzDrawBoxItem;
Begin
  FAccuDraw.Showing:= False;
  FAccuSnap.EraseFromScreen;
  CurrentAction.EraseFullViewCursor;

  { set the current drawbox }
  FDrawBoxList.SetCurrent(Sender);
  GetCursorPos( Pt );
  Pt.X:= Pt.X - ClientOrigin.X;
  Pt.Y:= Pt.Y - ClientOrigin.Y;
  CurrentAction.SetFullViewCursorPos( (Sender As TEzBaseDrawBox).Grapher.PointToReal(Pt) );
  CurrentAction.DrawFullViewCursor;

  { we must turn on the accudraw and the accusnap }
  FAccuDraw.Showing:= CurrentAction.CanDoAccuDraw;
  //
  Item := FDrawBoxList.FindCurrent;
  if Assigned(Item) then
    with Item do
      if Assigned(FSavedMouseEnter) then
        FSavedMouseEnter(Item.DrawBox);
End;

procedure TEzCmdLine.DoMouseLeave(Sender: TObject);
var
  Item: TEzDrawBoxItem;
Begin
  // we must turn off the accudraw and the accusnap
  FAccuSnap.EraseFromScreen;
  FAccuDraw.Showing:= False;
  Item := FDrawBoxList.FindCurrent;
  if Assigned(Item) then
    with Item do
      if Assigned(FSavedMouseLeave) then
        FSavedMouseLeave(Item.DrawBox);
End;

{ methods that affects to al drawbox connected }
procedure TEzCmdLine.All_Cursor(Value: TCursor);
var
  I: Integer;
begin
  For I:= 0 to FDrawBoxList.Count-1 do
    if Assigned(FDrawBoxList[I].FDrawBox) then
    FDrawBoxList[I].FDrawBox.Cursor:= Value;
end;

Procedure TEzCmdLine.All_DrawEntity2DRubberBand( Entity: TEzEntity; CtrlPts:
  Boolean = False; TransfPts: Boolean=False );
var
  I: Integer;
  DefaultStyle, OldStyle: TPenStyle;
begin
  DefaultStyle:= ActiveDrawBox.RubberPen.Style;
  For I:= 0 to FDrawBoxList.Count-1 do
  Begin
    with FDrawBoxList[I].FDrawBox do
    begin
      OldStyle:= RubberPen.Style;
      RubberPen.Style:= DefaultStyle;
      DrawEntity2DRubberBand( Entity, CtrlPts, TransfPts );
      RubberPen.Style:= OldStyle;
    end;
  End;
End;

Procedure TEzCmdLine.All_Invalidate;
var
  I: Integer;
begin
  For I:= 0 to FDrawBoxList.Count-1 do
    FDrawBoxList[I].FDrawBox.Invalidate;
End;

Procedure TEzCmdLine.All_Refresh;
var
  I: Integer;
begin
  For I:= 0 to FDrawBoxList.Count-1 do
    FDrawBoxList[I].FDrawBox.Refresh;
End;

Procedure TEzCmdLine.All_Repaint;
var
  I: Integer;
begin
  For I:= 0 to FDrawBoxList.Count-1 do
    FDrawBoxList[I].FDrawBox.Repaint;
End;

Procedure TEzCmdLine.All_RepaintRect(const Value: TEzRect);
var
  I: Integer;
begin
  For I:= 0 to FDrawBoxList.Count-1 do
    FDrawBoxList[I].FDrawBox.RepaintRect(Value);
End;

{ TEzAccuDraw }

constructor TEzAccuDraw.Create( AOwner: TEzCmdLine );
begin
  inherited Create;
  FOwner:= AOwner;

  FEnabled:= True;
  FSnapUnRotated:= True;
  FRotateToSegments:= True;
  FSnapSameDistance:= True;
  FCtrlAltSuspend:= True;

  FXAxisColor:= clRed;
  FYAxisColor:= clLime;
  FHiliteColor:= clBlack;
  FFrameColor:= clBlue;
  FSnapColor:= clBlack;

  FWidth:= 80;
  FSnapToAxis:= True;
  FTolerance:= 10;

  FRubberList:= TEzEntityList.Create;

  FAccuOrigin:= INVALID_POINT;

end;

destructor TEzAccuDraw.Destroy;
begin
  FRubberList.Free;
  inherited;
end;

{ retrieve the current dimensions (DeltaX,DeltaY or Distance,Angle }
procedure TEzAccuDraw.CurrentDimensions( Var DX, DY: Double );
var
  p: TEzPoint;
  M: TEzMatrix;
Begin
  If EqualPoint2d( INVALID_POINT, FAccuOrigin) Then
  Begin
    DX:= 0;
    DY:= 0;
    Exit;
  End;
  p:= FOwner.GetSnappedPoint;
  If FFrameStyle= fsRectangular Then
  Begin
    M:= Rotate2d( -FRotangle, FAccuOrigin );
    p:= TransformPoint2d( p, M );
    DX:= p.X - FAccuOrigin.X;
    DY:= p.Y - FAccuOrigin.Y;
  End Else
  Begin
    DX:= Dist2d( FAccuOrigin, p );
    DY:= Angle2d( FAccuOrigin, p ) - FRotangle;
  End;
End;

procedure TEzAccuDraw.DrawSnaps( Reversed: Boolean = False );
var
  I: Integer;
  TmpPen: TPen;

  Procedure DrawOne(Ele: Integer);
  var
    E: TEzEntity;
  Begin
    E:= FRubberList[Ele];
    with FOwner.ActiveDrawBox do
    begin
      If E.ID = 2 Then
      begin
        RubberPen.Style:= psSolid;    // this is the main rubber banding
        RubberPen.Width:= 2;
      end
      Else
      begin
        RubberPen.Style:= psDot;    // all other rubber banding entities drawn on psDot
        RubberPen.Width:= 1;
      end;
      RubberPen.Color:= FSnapColor;
      DrawEntity2DRubberBand( E, false, false );
    end;
  End;

begin
  Assert( FOwner.ActiveDrawBox <> Nil );
  
  TmpPen:= TPen.Create;
  TmpPen.Assign( FOwner.ActiveDrawBox.RubberPen );
  Try
    with FOwner.ActiveDrawBox do
    begin
      If Reversed Then
      begin
        For I:= FRubberList.Count-1 downto 0 do
        begin
          DrawOne( I );
        end;
      end else
      begin
        For I:= 0 to FRubberList.Count-1 do
        begin
          DrawOne( I );
        end;
      end;
    end;
  Finally
    FOwner.ActiveDrawBox.RubberPen.Assign( TmpPen );
    TmpPen.Free;
  end;
end;

procedure TEzAccuDraw.EraseAuxLines;
begin
  If FRubberList.Count = 0 Then Exit;
  { draw the rubber banding in order to erase from screen }
  DrawSnaps(True);             // erase and clear the list
  FRubberList.Clear;
end;

procedure TEzAccuDraw.DrawAuxLines;
var
  TheSnappedPoint, MySnappedPoint, p1,p2,p3,p1Up,p2Up,p1Dn,p2Dn: TEzPoint;
  Entity: TEzEntity;
  Angle, Delta: Double;
  M: TEzMatrix;
begin
  If EqualPoint2d( INVALID_POINT, FAccuOrigin) Then Exit;

  { calculate new ones...and draw it }

  { If the snapped point is not equal to the current point... }
  TheSnappedPoint:= FOwner.GetSnappedPoint;
  MySnappedPoint:= Self.GetSnappedPoint;

  { FPerpendFound is flagged in FOwner.GetSnappedPoint and means that a perpendicular
    AccuSnap point was found }
  If FPerpendFound Then
  Begin
    p1:= TheSnappedPoint;
    p2:= FPerpendFrom;
    Entity:= TEzPolyline.CreateEntity( [p1, p2]);
    FRubberList.Add( Entity );
  End Else If FIsSnappedToAxis And
    Not EqualPoint2d(FOwner.FAccuSnap.FCurrentSnapInfo.SnapPoint, TheSnappedPoint) Then
  Begin
    { It is snapped only to the accudraw axis.
      FIsSnappedToAxis is flagged in Self.GetSnappedPoint }
    p1:= FAccuOrigin;
    p2:= MySnappedPoint;
    Delta:= FOwner.ActiveDrawBox.Grapher.DistToRealY( 1 );
    Angle:= Angle2d( FAccuOrigin, MySnappedPoint );
    If Angle <> 0 Then
    begin
      M:= Rotate2d( -Angle, p1 );
      p2:= TransformPoint2D( p2, M );
    end;
    p1Up:= p1;
    p1Dn:= p1;
    p2Up:= p2;
    p2Dn:= p2;
    p1Up.y:= p1.y + Delta;
    p2Up.y:= p1.y + Delta;
    p1Dn.y:= p1.y - Delta;
    p2Dn.Y:= p1.y - Delta;

    Entity:= TEzPolyline.CreateEntity( [p1Up,p2Up,p1Dn,p2Dn]);
    Entity.Points.Parts.Add( 0 );
    Entity.Points.Parts.Add( 2 );
    If Angle <> 0 Then
    Begin
      M:= Rotate2d( Angle, p1 );
      Entity.SetTransformMatrix(M);
      Entity.ApplyTransform;
    End;

    Entity.ID:= 2;
    FRubberList.Add( Entity );
  End;

  If FIsSnappedToDistance Then
  Begin
    p1:= MySnappedPoint;
    Angle:= Angle2d(p1, FAccuOrigin);
    { semi-width of the marker }
    with FOwner.ActiveDrawBox.Grapher do
      Delta:= DistToRealX(Round((1/8)*DpiX));  // = of an inch the semi-width of the equi-distant marker
    p2:= Point2d(p1.x+Cos(Angle)*Delta, p1.y+Sin(Angle)*Delta);
    p3:= p2;
    { rotate the point clockwise }
    M:= Rotate2d( -(System.PI/2), p1 );
    p2:= TransformPoint2D( p2, M );

    { now rotate counterclockwise}
    M:= Rotate2d( (System.PI/2), p1 );
    p3:= TransformPoint2D( p3, M );
    Entity:= TEzPolyline.CreateEntity( [p2,p3] );
    Entity.ID:= 2;    //2=code for drawing on solid and with 2 width pixels
    FRubberList.Add( Entity );
  End;

  If (FFrameStyle=fsRectangular) And (FDeltaXLocked Or FDeltaYLocked) Then
  Begin
    { not snapped to one of the axis but with a locked distance}
    If FDeltaXLocked Then
    Begin
      p1:= FAccuOrigin;
      p1.x := p1.X + FDeltaX;
      If FRotAngle <> 0 Then
      Begin
        M:= Rotate2d( FRotAngle, FAccuOrigin );
        p1:= TransformPoint2D( p1, M );
      End;
      If FPerpendFound Then
      Begin
        Entity:= TEzPolyline.CreateEntity( [p1, TheSnappedPoint]);
        FRubberList.Add( Entity );
      End Else If Not EqualPoint2d( p1, MySnappedPoint ) Then
      begin
        Entity:= TEzPolyline.CreateEntity( [p1, MySnappedPoint]);
        FRubberList.Add( Entity );
      end;
    End;
    If FDeltaYLocked Then
    Begin
      p1:= FAccuOrigin;
      p1.Y := p1.Y + FDeltaY;
      If FRotAngle <> 0 Then
      Begin
        M:= Rotate2d( FRotAngle, FAccuOrigin );
        p1:= TransformPoint2D( p1, M );
      End;
      If FPerpendFound Then
      Begin
        Entity:= TEzPolyline.CreateEntity( [p1, TheSnappedPoint]);
        FRubberList.Add( Entity );
      End Else If Not EqualPoint2d( p1, MySnappedPoint ) Then
      begin
        Entity:= TEzPolyline.CreateEntity( [p1, MySnappedPoint]);
        FRubberList.Add( Entity );
      end;
    End;
  End;

  DrawSnaps;
end;

Procedure TEzAccuDraw.ShowUnRotated;
Begin
  ChangeOrigin( FAccuOrigin, 0 );
End;

procedure TEzAccuDraw.ChangeOrigin(Origin: TEzPoint; const Angle: Double = 0);
begin
  If FShowing then
  Begin
    EraseAuxLines;  // erase auxiliary snap lines
    Draw;           // erase previous AccuDraw
    FShowing:= False;
  End;
  FAccuOrigin:= Origin;
  FRotangle:= Angle;
  Showing:= True;
end;

{ update position of AccuDraw }
procedure TEzAccuDraw.UpdatePosition( const FromPt, ToPt: TEzPoint; Reversed: Boolean = False );
Begin
  If FShowing Then
  Begin
    EraseAuxLines;
    Draw; { erase previous AccuDraw }
    FShowing:= False;
  End;

  If FRotateToSegments Then
  Begin
    FRotangle:= Angle2d( FromPt, ToPt );
  End Else
    FRotangle:= 0.0;

  FLastDistance:= Dist2d( Frompt, ToPt );

  If Reversed Then
    FAccuOrigin:= FromPt
  Else
    FAccuOrigin:= ToPt;

  Showing:= True;     // causes to redraw the AccuDraw object
End;

procedure TEzAccuDraw.SetFrameColor(const Value: TColor);
begin
  If FFrameColor = Value then exit;
  FFrameColor := Value;
end;

procedure TEzAccuDraw.SetHiliteColor(const Value: TColor);
begin
  If FHiliteColor = Value then exit;
  FHiliteColor := Value;
end;

procedure TEzAccuDraw.SetWidth(Value: Integer);
begin
  If FWidth = Value then exit;
  FWidth := Value;
end;

procedure TEzAccuDraw.SetXAxisColor(const Value: TColor);
begin
  If FXAxisColor = Value then exit;
  FXAxisColor := Value;
end;

procedure TEzAccuDraw.SetYAxisColor(const Value: TColor);
begin
  If FYAxisColor = Value then exit;
  FYAxisColor := Value;
end;

procedure TEzAccuDraw.SetDeltaX(const Value: Double);
begin
  { DeltaX or Distance}
  If FFrameStyle = fsPolar Then
    FDeltaX := Abs( Value )
  Else
    FDeltaX := Value;
end;

procedure TEzAccuDraw.SetDeltaY(const Value: Double);
begin
  { DeltaY or Angle }
  FDeltaY := Value;
end;

procedure TEzAccuDraw.SetShowing(const Value: Boolean);
begin
  If FShowing = Value Then Exit;

  If FShowing Then
  begin
    EraseAuxLines;
    Draw;  // erase previous
  end;

  FShowing:= Value And FEnabled;
  Reset;
  If FShowing And Not EqualPoint2d( FAccuOrigin, INVALID_POINT) Then
  begin
    Draw;
    DrawAuxLines;
  end;

  If Assigned(FOwner.OnAccuDrawActivate) then
    FOwner.OnAccuDrawActivate(FOwner);
end;

procedure TEzAccuDraw.Reset;
Begin
  FDeltaXLocked:= False;
  FDeltaYLocked:= False;
  FDeltaX:= 0.0;
  FDeltaY:= 0.0;
End;

procedure TEzAccuDraw.Change;
Begin
  If Assigned( FOwner.FOnAccuDrawChange ) Then
    FOwner.FOnAccuDrawChange( FOwner );
End;

procedure TEzAccuDraw.SetFrameStyle(const Value: TEzFrameStyle);
begin
  If FFrameStyle = Value Then Exit;
  If FShowing Then
  Begin
    EraseAuxLines;
    Draw; { erase previous AccuDraw }
  End;
  FFrameStyle:= Value;
  Reset;
  Change;
  If FShowing Then
  Begin
    Draw;
    DrawAuxLines;
  End;
end;

procedure TEzAccuDraw.SetRotangle(const Value: Double);
begin
  If FRotangle=Value then Exit;
  { now rotate the accudraw }
  If FShowing Then
  Begin
    EraseAuxLines;
    Draw; { erase previous AccuDraw }
    FRotangle := Value;

    Showing:= True; // causes to redraw the accudraw
  End;
end;

procedure TEzAccuDraw.SetTolerance(const Value: Byte);
begin
  If FTolerance = Value Then Exit;
  FTolerance := Value;
end;

procedure TEzAccuDraw.SetEnabled(const Value: Boolean);
begin
  If FEnabled = Value then exit;
  FEnabled := Value;
end;

{ calculate the snapped point (FSnappedPoint) based on coordinates WX,WY }
Function TEzAccuDraw.GetSnappedPoint: TEzPoint;
Var
  TmpAngle, DX, DY, TmpDist: Double;
  TmpPt, p1, p2, p3, p4, UnrotatedPt: TEzPoint;
  Found, Rotate: Boolean;
  M: TEzMatrix;
  framewx, framewy: Double;
  C: TEzPoint;
  TolDistX, TolDistY, DeltaX, DeltaY: Double;
  fx,fy,Cntr: Integer;
  Box: TEzRect;
  TestDistance, TolDist: Double;

  Function GetSnappedToY: TEzPoint;
  Begin
    { snap to Y axis }
    If (FFrameStyle=fsRectangular) Or (Not FDeltaXLocked And Not FDeltaYLocked) then
      Result:= Point2d( C.X, UnrotatedPt.Y )
    else    // polar mode
    begin
      If FDeltaXLocked then   // distance locked
      begin
        Result:= Point2d( C.X, C.Y + Self.Dist*fy );
      end else if FDeltaYLocked then  // angle locked
      begin
        TmpDist:= FOwner.ActiveDrawBox.Grapher.DistToRealX( FWidth div 2 );
        DX:= Cos( Self.Angle ) * TmpDist;
        DY:= Sin( Self.Angle ) * TmpDist;
        p1:= C;
        p2:= Point2d( C.X + DX, C.y + DY );
        Result:= Perpend( UnrotatedPt, p1, p2 );
      end;
    end;
  End;

  Function GetSnappedToX: TEzPoint;
  begin
    { snap to X axis }
    If (FFrameStyle=fsRectangular) Or (Not FDeltaXLocked And Not FDeltaYLocked) then
      Result:= Point2d( UnrotatedPt.X, C.Y )
    else    // polar mode
    begin
      If FDeltaXLocked then   // distance locked
      begin
        Result:= Point2d( C.X + Self.Dist * fx, C.Y );
      end else if FDeltaYLocked then  // angle locked
      begin
        TmpDist:= FOwner.ActiveDrawBox.Grapher.DistToRealX( FWidth div 2 );
        DX:= Cos( Self.Angle ) * TmpDist;
        DY:= Sin( Self.Angle ) * TmpDist;
        p1:= C;
        p2:= Point2d( C.X + DX, C.y + DY );
        Result:= Perpend( UnrotatedPt, p1, p2 );
      end;
    end;
  end;

Begin
  Assert( FOwner. ActiveDrawBox <> Nil );

  FIsSnappedToAxis:= False;
  FIsSnappedToDistance:= False;
  Result:= FOwner.FCurrentPoint;

  If EqualPoint2d( INVALID_POINT, FAccuOrigin) Or Not FShowing Or
    Not ( FSnapToAxis Or FSnapUnrotated Or FDeltaXLocked Or FDeltaYLocked ) Or
    (FCtrlAltSuspend And (( GetAsyncKeyState( VK_CONTROL) Shr 1 ) <> 0) And
     (( GetAsyncKeyState( VK_MENU ) Shr 1 ) <> 0)) Then Exit;

  { First, check if it is snaped to the Center of AccuDraw }
  with FOwner.ActiveDrawBox do
  begin
    DeltaX:= Grapher.DistToRealX( FTolerance div 2 );
    DeltaY:= Grapher.DistToRealY( FTolerance div 2 );
    Box.Emin:= Point2d( FAccuOrigin.X - DeltaX, FAccuOrigin.Y - DeltaY );
    Box.Emax:= Point2d( FAccuOrigin.X + DeltaX, FAccuOrigin.Y + DeltaY );
    If IsPointInBox2D( FOwner.FCurrentPoint, Box ) Then
    Begin
      Result:= FAccuOrigin;
      Exit;
    End;
  end;


  Rotate:= FRotangle <> 0;
  If Rotate then
    M:= Rotate2d( FRotangle, FAccuOrigin );

  With FOwner.ActiveDrawBox do
    If FFrameStyle=fsRectangular Then
    Begin
      If FDeltaXLocked And Not FDeltaYLocked Then
      Begin
        { case: delta x is locked; delta y not locked
          find perpendicular projection of point WX, WY onto the line that goes
          parallel to Y axis and from FDeltaX distance }
        p1:= Point2d( FAccuOrigin.X + FDeltaX, FAccuOrigin.Y );

        p2:= Point2d( FAccuOrigin.X + FDeltaX,
                      FAccuOrigin.Y + Grapher.DistToRealX( FWidth div 2 ) );

        { rotate the two points }
        If Rotate then
        begin
          p1:= TransformPoint2d( p1, M );
          p2:= TransformPoint2d( p2, M );
        end;
        { find the projection of current point against the previous line }
        Result:= Perpend( Result, p1, p2 );

      End Else If Not FDeltaXLocked And FDeltaYLocked Then
      Begin
        p1:= Point2d( FAccuOrigin.X, FAccuOrigin.Y + FDeltaY );

        p2:= Point2d( FAccuOrigin.X + Grapher.DistToRealX( FWidth div 2 ),
                      FAccuOrigin.Y + FDeltaY );

        If Rotate then
        begin
          p1:= TransformPoint2d( p1, M );
          p2:= TransformPoint2d( p2, M );
        end;
        Result:= Perpend( Result, p1, p2 );

      End Else If FDeltaXLocked And FDeltaYLocked Then
      Begin
        Result:= Point2d( FAccuOrigin.X + FDeltaX, FAccuOrigin.Y + FDeltaY );
        If Rotate then
          Result:= TransformPoint2d( Result, M );
      End;
    End Else
    Begin
      { polar AccuDraw compass }
      If DistLocked And Not AngleLocked Then
      Begin
        p1:= FAccuOrigin;
        p2 := Result;
        { now extend the p2 point in order to have a distance }
        TmpAngle:= Angle2d(p1,p2);
        DX:= Cos( TmpAngle ) * Self.Dist;
        DY:= Sin( TmpAngle ) * Self.Dist;
        Result:= Point2d( p1.X + DX, p1.y + DY );
      End Else If Not DistLocked And AngleLocked Then
      Begin
        TmpDist:= Grapher.DistToRealX( FWidth div 2 );
        p1:= FAccuOrigin;
        { calculate an imaginary point with a distance igual to AccuDraw semi-width }
        TmpAngle:= Self.Angle + Self.FRotangle;
        DX:= Cos( TmpAngle ) * TmpDist;
        DY:= Sin( TmpAngle ) * TmpDist;
        p2:= Point2d( p1.X + DX, p1.y + DY );
        { now the perpendicular proyection of current point }
        Result:= Perpend( Result, p1, p2 );
      End Else If DistLocked And AngleLocked Then
      Begin
        p1:= FAccuOrigin;
        TmpAngle:= Self.Angle + Self.FRotangle;
        DX:= Cos( TmpAngle ) * Self.Dist;
        DY:= Sin( TmpAngle ) * Self.Dist;
        Result:= Point2d( p1.X + DX, p1.y + DY );
      End;
    End;

  { now detect if it is snapped to one of the axis }
  If ( (FFrameStyle = fsRectangular) And (FDeltaXLocked And FDeltaYLocked) ) Or
     ( (FFrameStyle = fsPolar) And (AngleLocked) ) Or
    Not (FSnapToAxis And FSnapSameDistance) Then Exit;

  { now check against all axis }
  If FSnapToAxis Then
  Begin

    { calculate the current point as if it was not rotated in order to easily the
      calculation }
    UnrotatedPt:= FOwner.FCurrentPoint;
    If Rotate then
      UnrotatedPt:= TransformPoint2D( UnrotatedPt, Rotate2d( -FRotangle, FAccuOrigin ) );

    Cntr:= 0;
    repeat

      with FOwner.ActiveDrawBox do
      begin

        { calcula distancia de la tolerancia }
        TolDistX:= Grapher.DistToRealX( FTolerance );
        TolDistY:= Grapher.DistToRealY( FTolerance );

        framewx:= Grapher.DistToRealX( FWidth div 2 );
        framewy:= Grapher.DistToRealY( FWidth div 2 );

        C:= FAccuOrigin;

        P1:= Point2d( C.X - framewx, C.Y - framewy );
        P2:= Point2d( C.X + framewx, C.Y - framewy );
        P3:= Point2d( C.X + framewx, C.Y + framewy );
        P4:= Point2d( C.X - framewx, C.Y + framewy );

        If FFrameStyle=fsRectangular then
        begin

          If FDeltaXLocked Then
            UnrotatedPt.X:= C.X + FDeltaX;

          If FDeltaYLocked Then
            UnrotatedPt.Y:= C.Y + FDeltaY;

        end;

        { obtener los delta con respecto al centro }
        DX := UnRotatedPt.X - C.X;
        DY := UnRotatedPt.Y - C.Y;

        If FFrameStyle=fsPolar then
        begin
          if DX < 0 then fx := -1 else fx := 1;
          if DY < 0 then fy := -1 else fy := 1;
        end;

        Found:= False;

        { esta dentro de las areas de snap ?}
        If ( Abs( DX ) <= TolDistX ) And ( Abs( DY ) <= TolDistY ) Then
        begin
          { esta dentro del area de tolerancia }
          If Abs( DX ) < Abs( DY ) Then
            TmpPt:= GetSnappedToY
          Else
            TmpPt:= GetSnappedToX;
          Found:= True;
          Self.FIsSnappedToAxis:= True;
        end else If Abs( DX ) <= TolDistX Then
        Begin
          { snap al eje Y }
          TmpPt:= GetSnappedToY;
          Found:= True;
          Self.FisSnappedToAxis:= True;
        End Else If Abs( DY ) <= TolDistY Then
        Begin
          { snap al eje X }
          TmpPt:= GetSnappedToX;
          Found:= True;
          Self.FIsSnappedToAxis:= True;
        End;
      End;
      If Found And ( ( (Cntr = 0) And Not FSnapToAxis    ) Or
                     ( (Cntr = 1) And Not FSnapUnRotated ) ) Then
        Found:= False;

      If Found Then Break;

      If ( Cntr = 0) And Not Found And Not( (FFrameStyle=fsRectangular) And
                                            (FDeltaXLocked Or FDeltaYLocked) ) And
        FSnapUnRotated And (Rotangle <> 0) then
      begin
        { snapped to unrotated axis ? }
        UnrotatedPt:= FOwner.FCurrentPoint;
        Rotate:= False;
      end;

      Inc( Cntr );
    until Cntr > 1;

    If Found Then
    Begin
      Result := TmpPt;
      If Rotate Then
        Result := TransformPoint2D( Result, M );
    End;
  End;

  If FSnapSameDistance And (FLastDistance>0) Then
  Begin
    { calculate distance from current snapped point to the center of accudras }
    TestDistance:= Dist2d( Result, FAccuOrigin );
    TolDist:= FOwner.ActiveDrawBox.Grapher.DistToRealX( FTolerance );
    If (TestDistance >= (FLastDistance - TolDist) ) And
       (TestDistance <= (FLastDistance + TolDist) ) Then
    Begin
      TmpAngle:= Angle2d( FAccuOrigin, Result );
      Result:= Point2d( FAccuOrigin.X + Cos(TmpAngle) * FLastDistance,
                        FAccuOrigin.Y + Sin(TmpAngle) * FLastDistance );
      FIsSnappedToDistance:= True;
    End;
  End;

End;

{ draw the AccuDraw object on screen viewport }
procedure TEzAccuDraw.Draw;
var
  TmpEntity: TEzEntity;
  P1, P2, C: TEzPoint;
  TmpPen: TPen;
  DeltaX, DeltaY, framewx, framewy, axiswx, axiswy: Double;
  M: TEzMatrix;
  Rotate: Boolean;
  CenterEnt: TEzEntity;
begin

  If EqualPoint2d( FAccuOrigin, INVALID_POINT) Or (FOwner.ActiveDrawBox=Nil) Or
    ( ( FOwner <> Nil ) And (csDesigning in FOwner.ComponentState ) ) then Exit;

  with FOwner.ActiveDrawBox do
  begin
    TmpPen:= TPen.Create;
    Try
      TmpPen.Assign( RubberPen );

      framewx:= Grapher.DistToRealX( FWidth div 2 );
      framewy:= Grapher.DistToRealY( FWidth div 2 );

      C:= FAccuOrigin;

      P1:= Point2d( C.X - framewx, C.Y - framewy );
      P2:= Point2d( C.X + framewx, C.Y + framewy );

      { Calculate rotation matrix }
      Rotate:= FRotangle <> 0;
      If Rotate Then
      Begin
        M:= Rotate2d( FRotangle, C );
      End;

      { draw the frame }
      If FFrameStyle=fsPolar Then
      Begin
        TmpEntity:= TEzEllipse.CreateEntity( p1, p2 );
        TmpEntity.ID:= -2;  // -2= don't draw interior axis
      End Else
        TmpEntity:= TEzRectangle.CreateEntity( p1, p2 );

      Try
        If Rotate Then
          TEzRectangle( TmpEntity ).Rotangle:= Rotangle;

        RubberPen.Color:= FFrameColor;
        RubberPen.Width:= 1;
        RubberPen.Style:= psDot;
        DrawEntity2DRubberBand( TmpEntity, False, False );
        RubberPen.Style:= psSolid;
      Finally
        TmpEntity.Free;
      End;

      { the X axis }

      axiswx := Grapher.DistToRealX( Trunc( FWidth * 0.20 ) );
      axiswy := Grapher.DistToRealX( Trunc( FWidth * 0.20 ) );

      P1 := Point2d(C.X + framewx-(axiswx/2), C.Y );
      P2 := Point2d(C.X + framewx+(axiswx/2), C.Y );

      TmpEntity:= TEzPolyline.CreateEntity( [p1, p2] );
      Try
        If Rotate Then
        Begin
          TmpEntity.SetTransformMatrix( M );
          TmpEntity.ApplyTransform;
        End;
        RubberPen.Color:= FXAxisColor;
        RubberPen.Width:= 4;
        DrawEntity2DRubberBand( TmpEntity, False, False );

        { the y axxis }
        TmpEntity.Points[0] := Point2d(C.X, C.Y + framewy-(axiswy/2) );
        TmpEntity.Points[1] := Point2d(C.X, C.Y + framewy+(axiswy/2) );

        If Rotate Then
        Begin
          TmpEntity.SetTransformMatrix( M );
          TmpEntity.ApplyTransform;
        End;
        RubberPen.Color:= FYAxisColor;
        DrawEntity2DRubberBand( TmpEntity, False, False );
        RubberPen.Width:= 1;


        { The hilite on the X axis }
        TmpEntity.Points[0] := Point2d(C.X - framewx + (axiswx/2), C.Y );
        TmpEntity.Points[1] := Point2d(C.X - framewx - (axiswx/2), C.Y );
        If Rotate Then
        Begin
          TmpEntity.SetTransformMatrix( M );
          TmpEntity.ApplyTransform;
        End;
        RubberPen.Color:= FHiliteColor;
        DrawEntity2DRubberBand( TmpEntity, False, False );


        { The hilite on the Y axis }
        TmpEntity.Points[0] := Point2d(C.X, C.Y - framewy + (axiswy/2) );
        TmpEntity.Points[1] := Point2d(C.X, C.Y - framewy - (axiswy/2) );
        If Rotate Then
        Begin
          TmpEntity.SetTransformMatrix( M );
          TmpEntity.ApplyTransform;
        End;
        RubberPen.Color:= FHiliteColor;
        DrawEntity2DRubberBand( TmpEntity, False, False );


        { now draw the center }
        DeltaX:= Grapher.DistToRealX( FTolerance div 2 );
        DeltaY:= Grapher.DistToRealY( FTolerance div 2 );
        p1:= Point2d( C.X - DeltaX, C.Y - DeltaY );
        p2:= Point2d( C.X + DeltaX, C.Y + DeltaY );
        CenterEnt:= TEzRectangle.CreateEntity( p1, p2 );
        try
          TEzRectangle(CenterEnt).Rotangle:= FRotangle;
          RubberPen.Color:= FFrameColor;
          DrawEntity2DRubberBand( CenterEnt, False, False );
        finally
          CenterEnt.Free;
        end;

      Finally
        TmpEntity.Free;
      End;

    Finally
      RubberPen.Assign( TmpPen );
      TmpPen.Free;
    End;
  End;
End;


{ TEzAccuSnap }

constructor TEzAccuSnap.Create(AOwner: TEzCmdLine);
begin
  inherited Create;
  FEnabled:= True;
  FOwner:= AOwner;
  FSensitivity:= 100;
  FSnapDivisor:= 2;
  FCtrlShiftSuspend:= True;
  FHiliteSnapped:= True;
end;

destructor TEzAccuSnap.Destroy;
begin
  if Assigned(FCurrentSnapInfo.Picture) then
    FCurrentSnapInfo.Picture:= Nil;
  inherited Destroy;
end;

Procedure TEzAccuSnap.EraseFromScreen;
Begin
  If FCurrentSnapInfo.Picture <> Nil Then
  Begin
    { erase snap entity }
    DrawAccuSnap( false );
    FCurrentSnapInfo.Picture:= Nil;
  End;
  FCurrentSnapInfo.Layer:= Nil;
End;

Procedure TEzAccuSnap.DrawAccuSnap( Draw: Boolean );

  Procedure HiliteEntity;
  Var
    TmpEntity: TEzEntity;
    IsMemLayer: Boolean;
  Begin
    If Not Self.FHiliteSnapped Then Exit;
    IsMemLayer:= FCurrentSnapInfo.Layer.LayerInfo.IsCosmethic;
    If IsMemLayer then
    begin
      FCurrentSnapInfo.Layer.Recno:= FCurrentSnapInfo.Recno;
      TmpEntity:= FCurrentSnapInfo.Layer.RecEntity;
    end else
      TmpEntity:= FCurrentSnapInfo.Layer.LoadEntityWithRecno( FCurrentSnapInfo.Recno );
    If TmpEntity <> Nil then
    begin
      Try
        If (TmpEntity Is TEzOpenedEntity) Then
        Begin
          // erase full view cursor
          FOwner.CurrentAction.EraseFullViewCursor;
          // draw the accusnap entity
          FOwner.ActiveDrawBox.DrawEntity2DRubberBand(TmpEntity, false, false);
          // repaint the full view cursor
          FOwner.CurrentAction.DrawFullViewCursor;
        End;
      Finally
        If Not IsMemLayer then
          TmpEntity.Free;
      End;
    end;
  End;

var
  TmpR: TRect;
Begin
  Assert( FOwner.ActiveDrawBox <> Nil );

  if Not FEnabled Or (FCurrentSnapInfo.Picture = Nil) then Exit;
  with FCurrentSnapInfo do
  begin
    If Draw Then
    Begin
      FOwner.CurrentAction.SuspendOperation;
      With FOwner.ActiveDrawBox.Canvas do
      begin
        Draw( Pos.X, Pos.Y, Picture );
        Draw( Pos.X + Picture.Width,
              Pos.Y - FAccuSnapPictures[SnapSetting].Height,
              FAccuSnapPictures[SnapSetting] );
      end;

      If ( Picture = FAccuSnapPicFocused ) And ( Layer <> Nil ) And Not Showing Then
      Begin
        HiliteEntity;
        Showing:= true;
      End;
      FOwner.CurrentAction.ContinueOperation;
    End else
    begin
      If ( Layer <> Nil ) And Showing Then
      Begin
        HiliteEntity;
        Showing:= false;
      End;

      { erase accudraw }
      If FOwner.FAccuDraw.FEnabled Then
        FOwner.FAccuDraw.Draw;

      { call the action to do its cleaning job  }
      FOwner.CurrentAction.SuspendOperation;

      { borra el bitmap exhibido}
      TmpR:= Rect( Pos.X, Pos.Y, Pos.X + Picture.Width, Pos.Y + Picture.Height );
      FOwner.ActiveDrawBox.Canvas.CopyRect( TmpR, FOwner.ActiveDrawBox.ScreenBitmap.Canvas, TmpR );
      { borra el bitmap actual}
      TmpR:= Rect( Pos.X + Picture.Width, Pos.Y - FAccuSnapPictures[SnapSetting].Height,
                   Pos.X + Picture.Width + FAccuSnapPictures[SnapSetting].Width, Pos.Y );
      FOwner.ActiveDrawBox.Canvas.CopyRect( TmpR, FOwner.ActiveDrawBox.ScreenBitmap.Canvas, TmpR );

      { restore cleaning job }
      FOwner.CurrentAction.ContinueOperation;

      { restore accudraw }
      If FOwner.FAccuDraw.FEnabled Then
        FOwner.FAccuDraw.Draw;
    end;
  End;
End;

Procedure TEzAccuSnap.UpdateAccuSnapEntity;
Var
  Setting: TEzOsnapSetting;
  SnapPt, TmpPt: TEzPoint;
  Found: Boolean;
  Distance: Double;
  TmpLayer: TEzBaseLayer;
  TmpRecno: Integer;
  Aperture: Integer;
  RealAperture: TEzPoint;
  NewAperture: Double;
  TmpP: TPoint;
  r1,r2: TRect;
  IsOverlapped, IsSnappedPointOnEntity: Boolean;
  TmpPic: TBitmap;
  RefFrom, RefTo: TEzPoint;
Begin
  If FOwner.ActiveDrawBox = Nil Then Exit;

  { Search the next snap entity and point }
  If FInSearch Or Not FOwner.CurrentAction.CanDoOsnap Or Not FEnabled Or
    (FCtrlShiftSuspend And (( GetAsyncKeyState( VK_SHIFT   ) Shr 1 ) <> 0) And
                           (( GetAsyncKeyState( VK_CONTROL ) Shr 1 ) <> 0)) Then
  Begin
    EraseFromScreen;
    Exit;
  End;

  FInSearch:= True;

  Found := False;

  If FOverrideOsnap Then
    Setting := FOverrideOsnapSetting
  Else
    Setting := FOsnapSetting;

  TmpPt := FOwner.FCurrentPoint;
  If EzActions.GetSnapPt( FOwner, Ez_Preferences.ApertureWidth, Setting, FSnapLayerName,
                          TmpLayer, TmpRecno, TmpPt, IsSnappedPointOnEntity, RefFrom, RefTo) Then
  Begin
    SnapPt := TmpPt;
    Found := True;
  End;

  TmpPic:= Nil;
  If Found Then
  Begin
    { it is close enough ? }
    If FCurrentSnapInfo.Picture <> Nil Then // is one bitmap currently visible ?
    Begin
      { aplica la sensitividad }
      Aperture := EzLib.IMax(2,MulDiv( Ez_Preferences.ApertureWidth, FSensitivity, 100 ));
      With FOwner.ActiveDrawBox.Grapher do
        RealAperture := Point2D( DistToRealX( Aperture div 2 ),
                                 DistToRealY( Aperture div 2) );
      If RealAperture.X > RealAperture.Y Then
        NewAperture := RealAperture.X
      Else
        NewAperture := RealAperture.Y;
      NewAperture := Sqrt( 2 ) * NewAperture;

      with FCurrentSnapInfo do
        r1 := Rect( Pos.X, Pos.Y,
                    Pos.X + Picture.Width, Pos.Y + Picture.Height );

      TmpP:= FOwner.ActiveDrawBox.Grapher.RealToPoint( FOwner.FCurrentPoint );
      Aperture:= Aperture div 2;
      r2:= Rect( TmpP.X - Aperture, TmpP.Y - Aperture,
                 TmpP.X + Aperture, TmpP.Y + Aperture );
      { find if this bitmap overlaps to the current snap bitmap }
      IsOverlapped:= Windows.IntersectRect(r1,r1,r2);
      If IsOverlapped Or EzLib.IsNearPoint2D( FOwner.FCurrentPoint,
                                              FCurrentSnapInfo.SnapPoint,
                                              NewAperture, Distance ) Then
      begin
        { switch to a focused snap }
        TmpPic:= FAccuSnapPicFocused;
      end else
      begin
        If Not IsSnappedPointOnEntity Then
        begin
          TmpPic:= FAccuSnapPicFocused;
        end Else
        begin
          TmpPic:= FAccuSnapPicUnFocused;
        end;
      end;
    End Else
    begin
      { display unfocused snap by default on first display of accusnap point }
      TmpPic:= FAccuSnapPicUnFocused;
    end;
  End;

  If Found And
    Not ( ( FCurrentSnapInfo.Picture <> Nil ) And EqualPoint2D( FCurrentSnapInfo.SnapPoint, SnapPt ) And
          ( FCurrentSnapInfo.Picture = TmpPic ) And
          ( FCurrentSnapInfo.SnapSetting = Setting ) ) Then
  Begin
    { erase previous AccuSnap point }
    EraseFromScreen;

    { create the AccuSnapInfo }
    FCurrentSnapInfo.Picture := TmpPic;
    TmpP:= FOwner.ActiveDrawBox.Grapher.RealToPoint( SnapPt );
    with FCurrentSnapInfo.Picture do
      FCurrentSnapInfo.Pos:= Point( TmpP.X - (Width div 2), TmpP.Y - (Height div 2) );
    FCurrentSnapInfo.Layer:= TmpLayer;
    FCurrentSnapInfo.Recno:= TmpRecno;
    If Setting in [osPerpend, osParallel] then
    begin
      FCurrentSnapInfo.RefFrom:= RefFrom;
      FCurrentSnapInfo.RefTo:= RefTo;
    end;
    FCurrentSnapInfo.SnapSetting:= Setting;

    { update the current snapped point }
    FCurrentSnapInfo.SnapPoint := SnapPt;
    { draw new accusnap point }
    DrawAccuSnap( True );
  End Else If Not Found Then
    EraseFromScreen;

  FInSearch:= False;
end;

procedure TEzAccuSnap.SetEnabled(const Value: Boolean);
begin
  If (FEnabled=Value) Or (FOwner.ActiveDrawBox=Nil) then exit;
  FOwner.CurrentAction.EraseFullViewCursor;
  If not Value Then EraseFromScreen;;
  FEnabled := Value;
  if Not (csDesigning in FOwner.ComponentState) Then
  Begin
    UpdateAccuSnapEntity;
    FOwner.CurrentAction.DrawFullViewCursor;
  End;
  Change;
end;

procedure TEzAccuSnap.Change;
begin
  If Assigned( FOwner.FOnAccuSnapChange ) Then
    FOwner.FOnAccuSnapChange( FOwner );
end;

procedure TEzAccuSnap.SetOverrideOsnapSetting(const Value: TEzOSNAPSetting);
begin
  If FOverrideOsnapSetting = Value Then Exit;
  FOverrideOsnapSetting := Value;
  FOverrideOsnap:= True;
  Change;
end;

procedure TEzAccuSnap.SetOsnapSetting(const Value: TEzOSNAPSetting);
begin
  If FOsnapSetting=Value then Exit;
  FOsnapSetting := Value;
  Change;
end;

procedure TEzAccuSnap.SetOverrideOsnap(const Value: Boolean);
begin
  If FOverrideOsnap = Value Then Exit;
  FOverrideOsnap := Value;
  Change;
end;

function TEzAccuSnap.GetCurrentOsnapSetting: TEzOsnapSetting;
begin
  If FOverrideOsnap then
    Result:= OverrideOsnapSetting
  Else
    Result:= OsnapSetting;
end;

procedure LoadAccuSnapPictures;
Var
  OSCntr: TEzOSNAPSetting;
Begin
  FAccuSnapPicFocused:= TBitmap.Create;
  with FAccuSnapPicFocused do
  begin
    Handle:= LoadBitmap( HInstance, 'SNAP_FOCUSED' );
    Transparent:= True;
    TransparentMode:= tmAuto;
  end;

  FAccuSnapPicUnFocused:= TBitmap.Create;
  with FAccuSnapPicUnFocused do
  begin
    Handle:= LoadBitmap( HInstance, 'SNAP_UNFOCUSED' );
    Transparent:= True;
    TransparentMode:= tmAuto;
  end;

  for OSCntr:= Low(TEzOSNAPSetting) to High(TEzOSNAPSetting) do
  begin
    FAccuSnapPictures[OSCntr]:= TBitmap.Create;
    with FAccuSnapPictures[OSCntr] do
    begin
      Handle:= LoadBitmap( HInstance, ImageNames[OSCntr] );
      Transparent:= True;
      TransparentMode:= tmAuto;
    end;
  end;
End;

Procedure FreeAccuSnapPictures;
Var
  OSCntr: TEzOSNAPSetting;
Begin
  FAccuSnapPicFocused.Free;
  FAccuSnapPicUnFocused.Free;
  for OSCntr:= Low(TEzOSNAPSetting) to High(TEzOSNAPSetting) do
    FAccuSnapPictures[OSCntr].Free;
End;

Initialization
  LoadAccuSnapPictures;

Finalization
  FreeAccuSnapPictures;

End.
