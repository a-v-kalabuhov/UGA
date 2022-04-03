unit EzActionLaunch;

{***********************************************************}
{     EzGIS/CAD Components                                  }
{   (c) 2002 EzSoft Engineering                             }
{         All Rights Reserved                               }
{***********************************************************}

{$I EZ_FLAG.PAS}
Interface

Uses
  SysUtils, Windows, Messages, Classes, Graphics, Controls, ExtCtrls, Forms,
  Dialogs, EzBase, EzBaseGIS, EzLib, EzCmdLine, EzSystem, EzEntities,
  EzMiscelEntities ;

Type

  TEzCircleDrawType = ( ct2P, ct3P, ctCR );

  { if you return TrackedEntity = Nil, then you must dispose the entity passed
    on that parameter }
  TEzTrackedEntityEvent = Procedure(Sender: TObject; const TrackID: string;
    var TrackedEntity: TEzEntity ) Of Object;

  { this is for event OnTrackedEntityClick.
    Important ! If Layer = Nil and Recno = 0, it means that end-user clicked on the map
    but no entity was found, so you must always check and proceed accordingly }
  TEzTrackEntityClickEvent = Procedure( Sender: TObject; const TrackID: string;
    Button: TMouseButton; Shift: TShiftState; X, Y: Integer; Const WX, WY: Double;
    Layer: TEzBaseLayer; Recno: Integer; Var Accept: Boolean ) Of Object;

  { tracks when mouse is moved (not clicked) over and entity. This is checked every
    TEzBaseDrawbox.DelayShowHint elapsed time (in milliseconds )
    Important! If Layer = Nil and Recno = 0 then that means that no entity was
    found under mouse when the time elapsed (We must check in a time delay
    because the search can be time consuming )}
  TEzTrackEntityMouseMoveEvent = Procedure( Sender: TObject; const TrackID: string;
    Layer: TEzBaseLayer; Recno: Integer; Var Accept: Boolean ) Of Object;

  TEzTrackEntityDragDropEvent = Procedure ( Sender: TObject; const TrackID: string;
    Layer: TEzBaseLayer; Recno: Integer; Var TrackedEntity: TEzEntity ) Of Object;

  TEzActionLauncher = Class(TComponent)
  Private
    FCmdLine: TEzCmdLine;       // linked to this CmdLine
    FCursor: TCursor;           // the cursor used for the action
    { following are mainly used in a generic action tracking }
    FFinished: Boolean;
    FCurrentAction: TEzAction;
    FCanDoOsnap: Boolean;
    FCanDoAccuDraw: Boolean;
    FMouseDrawElements: TEzMouseDrawElements;

    { tracking events }
    FOnTrackedEntity: TEzTrackedEntityEvent;
    FOnTrackedEntityClick: TEzTrackEntityClickEvent;
    FOnTrackedEntityMouseMove: TEzTrackEntityMouseMoveEvent;
    FOnTrackedEntityDragDrop: TEzTrackEntityDragDropEvent;

    { generic action events ( TrackGenericAction event }
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
    FOnFinished: TNotifyEvent;
    procedure PushAction( const TrackID: string );
    procedure SetCmdLine(const Value: TEzCmdLine);
    function GetDefaultAction: Boolean;
    procedure SetDefaultAction(const Value: Boolean);
    function GetCurrentTrackID: string;
    function GetCaption: String;
    procedure SetCaption(const Value: String);
    function GetStatusMessage: string;
    procedure SetStatusMessage(const Value: string );
  Protected
    Procedure Notification( AComponent: TComponent; Operation: TOperation ); Override;
  Public
    Constructor Create(AOwner: TComponent); Override;
    { causes to finish immediately.
      please don't call this method inside an event handler of TEzActionLauncher }
    Procedure Finish;

    { track entity given in TrackedEntity parameter. You must prebuilt the
      entity with your choice of attributes.
      This method and TrackXXX (XXX=polygon,polyline,etc) will fire event
      OnTrackedEntity.
      You can define the TrackedEntity variable instance to nil in that event
      in order to avoid this method to dispose internally }
    Procedure TrackEntity( const TrackID: string; TrackedEntity: TEzEntity );

    { track entity defined by name of method. Entity is built
      internally with default attributes.
      For other entities you must use previous method: TrackEntity. In event
      OnTrackedEntity you can define variable instance to nil if you will
      use the entity internally and the instance will not be disposed
      internally }
    Procedure TrackPolygon( const TrackID: string );
    Procedure TrackPolyline( const TrackID: string );
    Procedure TrackSketch( const TrackID: string );
    Procedure TrackRectangle( const TrackID: string;
      ScaledWidth: Integer = 0; ScaledHeight: Integer=0 );
    Procedure TrackPlace( const TrackID: string );
    Procedure TrackArc3P( const TrackID: string );
    Procedure TrackArcSE( const TrackID: string );
    Procedure TrackEllipse( const TrackID: string );
    Procedure TrackSpline( const TrackID: string );
    Procedure TrackPoint( const TrackID: string );
    procedure TrackPictureRef(const TrackID, FileName: string);
    procedure TrackBandsBitmap(const TrackID, FileName: string);
    procedure TrackBlock(const TrackID, BlockName: string;
      const Rotangle, ScaleX, ScaleY: Double );

    { track a circle that can be draw with three methods:
      2 points; 3 points; or Center and Radius. Circle is
      created and disposed internally. This method also will fire event
       OnTrackedEntity }
    Procedure TrackCircle( const TrackID: string; DrawType: TEzCircleDrawType );

    { track a buffer. This fire event OnTrackedEntity }
    Procedure TrackBuffer( const TrackID: string );

    { This method will fire event OnTrackedEntityClick when an entity on the
      map is clicked. You also can use event TEzDrawBox.OnEntityClick }
    Procedure TrackEntityClick( const TrackID: string; Const LayerName: string = '';
      HighlightClicked: Boolean = True );

    { this method will detect which entity is under mouse when you move the
      mouse over entities on the map/drawing. Can be used for showing your own
      hints or other kind of actions. This method will fire method
      OnTrackedEntityMouseMove }
    Procedure TrackEntityMouseMove( const TrackID: string;
      Const LayerName: string = ''; HighlightDetected: Boolean = True );

    { this method will track the moving of an entity on the map/drawing. If the method is
     succesful, then event OnTrackedEntityDragDrop is fired }
    Procedure TrackEntityDragDrop( const TrackID: string );

    { generic track action. You can use the following events in order
      to code specific action;
       OnMouseDown;
       OnMouseMove;
       OnMouseUp;
       OnClick;
       OnDblClick;
       OnKeyDown;
       OnKeyPress;
       OnKeyUp;
       OnActionDoCommand;
       OnSuspendOperation;
       OnContinueOperation;
       OnUndo;
       OnInitialize;
     }
    Procedure TrackGenericAction( const TrackID: string );
    Function IsRunning: Boolean;

    Property DefaultAction: Boolean read GetDefaultAction Write SetDefaultAction;
    Property CurrentTrackID: string read GetCurrentTrackID;
    Property Caption: String Read GetCaption Write SetCaption;
    Property TrackID: string read GetCurrentTrackID;
    Property CurrentAction: TEzAction read FCurrentAction write FCurrentAction;
    Property StatusMessage: string read GetStatusMessage write SetStatusMessage;
    { when true, causes to finish when an event returns. You must set this inside
      an event handler only.
     }
    Property Finished: Boolean read FFinished write FFinished;
  Published
    { properties }
    Property CmdLine: TEzCmdLine read FCmdLine write SetCmdLine;
    Property Cursor: TCursor read FCursor write FCursor default crCross;
    Property CanDoOsnap: Boolean read FCanDoOsnap write FCanDoOsnap;
    Property CanDoAccuDraw: Boolean read FCanDOAccuDraw write FCanDOAccuDraw;
    Property MouseDrawElements: TEzMouseDrawElements read FMouseDrawElements write FMouseDrawElements;

    { events }
    Property OnTrackedEntity: TEzTrackedEntityEvent read FOnTrackedEntity write FOnTrackedEntity;
    Property OnTrackedEntityClick: TEzTrackEntityClickEvent read FOnTrackedEntityClick write FOnTrackedEntityClick;
    Property OnTrackedEntityMouseMove: TEzTrackEntityMouseMoveEvent read FOnTrackedEntityMouseMove write FOnTrackedEntityMouseMove;
    Property OnTrackedEntityDragDrop: TEzTrackEntityDragDropEvent read FOnTrackedEntityDragDrop write FOnTrackedEntityDragDrop;

    { for generic action (TrackGenericAction method ) }
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
    Property OnFinished: TNotifyEvent read FOnFinished write FOnFinished;
  End;


  {-------------------------------------------------------------------------------}
  {                  TAddEntityAction                                             }
  {-------------------------------------------------------------------------------}

  TAddEntityAction = Class(TEzAction)
  protected
    FEntity: TEzEntity;
    FCurrentIndex: Integer;
    FImgDims: TPoint;
    FIsImage: Boolean;
    FDrawImmediately: Boolean;
    Procedure DrawEntityRubberToAll( DrawBox: TEzBaseDrawBox );
    Procedure SetCurrentPoint( Pt: TEzPoint; Orto: Boolean );
    Procedure SetAddActionCaption;
    Procedure MyMouseDown( Sender: TObject; Button: TMouseButton; Shift:
      TShiftState; X, Y: Integer; Const WX, WY: Double ); virtual;
    Procedure MyMouseMove( Sender: TObject; Shift: TShiftState;
      X, Y: Integer; Const WX, WY: Double ); virtual;
    Procedure MyKeyPress( Sender: TObject; Var Key: Char ); virtual;
    Procedure MyPaint( Sender: TObject ); virtual;
    Procedure SuspendOperation( Sender: TObject ); virtual;
    Procedure ContinueOperation( Sender: TObject ); virtual;
    Procedure AddPoint( const CurrPoint: TEzPoint ); virtual;
    function GetEntity: TEzEntity; virtual;
  public
    Constructor CreateAction( CmdLine: TEzCmdLine; Ent: TEzEntity;
      Const ImgDims: TPoint );
    Destructor Destroy; Override;

    property Entity: TEzEntity read GetEntity;
  End;

  {-------------------------------------------------------------------------------}
  {                  TAddEntityAction                                             }
  {-------------------------------------------------------------------------------}

  TSketchAction = Class(TEzAction)
  Private
    FEntity: TEzEntity;
    FCurrentIndex: Integer;
    FIsDrawing: Boolean;
    Procedure SetCurrentPoint( Pt: TEzPoint );
    Procedure MyMouseDown( Sender: TObject; Button: TMouseButton; Shift:
      TShiftState; X, Y: Integer; Const WX, WY: Double );
    Procedure MyMouseMove( Sender: TObject; Shift: TShiftState;
      X, Y: Integer; Const WX, WY: Double );
    Procedure MyKeyPress( Sender: TObject; Var Key: Char );
    Procedure MyPaint( Sender: TObject );
    Procedure SuspendOperation( Sender: TObject );
    Procedure ContinueOperation( Sender: TObject );
    Procedure AddPoint( const CurrPoint: TEzPoint );
    Procedure CleanEntity;
  Public
    Constructor CreateAction( CmdLine: TEzCmdLine; Ent: TEzEntity );
    Destructor Destroy; Override;
  End;

  {-------------------------------------------------------------------------------}
  {                  TDrawCircleAction                                              }
  {-------------------------------------------------------------------------------}

  TDrawCircleAction = Class( TEzAction )
  Private
    FPts: Array[0..2] Of TEzPoint;
    FCircle: TEzEntity;
    FCurrentIndex: Integer;
    FCircleDrawType: TEzCircleDrawType;
    Function IndexLimit: Integer;
    Procedure SetCurrentPoint( Pt: TEzPoint; Orto: Boolean );
    Procedure SetAddActionCaption;
    Procedure MyMouseDown( Sender: TObject; Button: TMouseButton; Shift:
      TShiftState; X, Y: Integer; Const WX, WY: Double );
    Procedure MyMouseMove( Sender: TObject; Shift: TShiftState;
      X, Y: Integer; Const WX, WY: Double );
    Procedure MyKeyPress( Sender: TObject; Var Key: Char );
    Procedure MyPaint( Sender: TObject );
    Procedure CreateCircle;
    Procedure SuspendOperation( Sender: TObject );
    Procedure ContinueOperation( Sender: TObject );
  Public
    Constructor CreateAction(  CmdLine: TEzCmdLine;
      CircleDrawType: TEzCircleDrawType );
    Destructor Destroy; Override;
  End;


  {-------------------------------------------------------------------------------}
  {                  TDrawCircleAction                                              }
  {-------------------------------------------------------------------------------}

  TDrawArcMethod = (damCRS, damFCS);
    //damCRS = (C)enter, (R)adius, (S)weep angle
    //damFCS = (F)irst arc end point, (C)enter, (S)weep angle

  // draw an arc by marking first circle, then start angle, then end angle
  TDrawArcAction = Class( TEzAction )
  Private
    FPts: Array[0..1] Of TEzPoint;
    FCircle: TEzEntity;
    FArc: TEzEntity;
    FDefiningCircle: Boolean;
    FCurrentIndex: Integer;
    FRadiusLines: TEzEntity;
    FIsCounterClockWise: Boolean;
    FMethod: TDrawArcMethod;
    FLastPoint: TEzPoint;
    procedure DrawRubberCircle(Sender: TObject = Nil);
    procedure DrawRubberArc(Sender: TObject = Nil);
    Procedure SetCurrentPoint( Pt: TEzPoint; Orto: Boolean );
    Procedure SetAddActionCaption;
    Procedure MyMouseDown( Sender: TObject; Button: TMouseButton; Shift:
      TShiftState; X, Y: Integer; Const WX, WY: Double );
    Procedure MyMouseMove( Sender: TObject; Shift: TShiftState;
      X, Y: Integer; Const WX, WY: Double );
    Procedure MyKeyPress( Sender: TObject; Var Key: Char );
    Procedure MyPaint( Sender: TObject );
    Procedure CreateCircle;
    Procedure SuspendOperation( Sender: TObject );
    Procedure ContinueOperation( Sender: TObject );
  Public
    Constructor CreateAction( CmdLine: TEzCmdLine; Method: TDrawArcMethod = damCRS );
    Destructor Destroy; Override;
  End;

  {-------------------------------------------------------------------------------}
  //                  TBufferSelectAction
  {-------------------------------------------------------------------------------}

  TBufferSelectAction = Class( TEzAction )
  Private
    FLine: TEzPolyLine;
    FPolyline: TEzPolyLine;
    FPolygon: TEzPolygon;
    FCurrentIndex: Integer;
    FDistance: Double;
    FReferenceDefined: Boolean;
    Procedure SetCurrentPoint( Const Pt: TEzPoint );
    Procedure CalcPolygon;
    Procedure DrawRubberEntityDotted(Entity: TEzEntity; Sender: TObject=Nil);
  Protected
    Procedure MyMouseDown( Sender: TObject; Button: TMouseButton; Shift: TShiftState;
      X, Y: Integer; Const WX, WY: Double );
    Procedure MyMouseMove( Sender: TObject; Shift: TShiftState;
      X, Y: Integer; Const WX, WY: Double );
    Procedure MyKeyPress( Sender: TObject; Var Key: Char );
    Procedure MyPaint( Sender: TObject );
    Procedure SuspendOperation( Sender: TObject );
    Procedure ContinueOperation( Sender: TObject );
  Public
    Constructor CreateAction( CmdLine: TEzCmdLine );
    Destructor Destroy; Override;
    Procedure UndoOperation; Override;
  End;


  {-------------------------------------------------------------------------------}
  //                  TAddVectorialTextAction
  {-------------------------------------------------------------------------------}

  { the add vectorial text action display a dialog box asking for the text
    to add and the justification }
  TAddVectorialTextAction = Class( TEzAction )
  Private
    FFrame: TEzRectangle;
    FCurrentIndex: Integer;
    FOrigin: TPoint;
    FIsJustifiedText: Boolean;
    FTextBorderStyle: TEzTextBorderStyle;
    FVectorialText: TEzEntity;
    Procedure DoAddTheText;
    Procedure SetCurrentPoint( Const Pt: TEzPoint );
    Procedure MyMouseDown( Sender: TObject; Button: TMouseButton; Shift:
      TShiftState; X, Y: Integer; Const WX, WY: Double );
    Procedure MyMouseUp( Sender: TObject; Button: TMouseButton; Shift:
      TShiftState; X, Y: Integer; Const WX, WY: Double );
    Procedure MyMouseMove( Sender: TObject; Shift: TShiftState;
      X, Y: Integer; Const WX, WY: Double );
    Procedure MyKeyPress( Sender: TObject; Var Key: Char );
    Procedure MyPaint( Sender: TObject );
    Procedure SuspendOperation( Sender: TObject );
    Procedure ContinueOperation( Sender: TObject );
  Public
    Constructor CreateAction( CmdLine: TEzCmdLine; VectorialText: TEzEntity;
      IsJustifiedText: Boolean; TextBorderStyle: TEzTextBorderStyle );
    Destructor Destroy; Override;
  End;


  {-------------------------------------------------------------------------------}
  //                  TDimAction
  {-------------------------------------------------------------------------------}

  TEzDimStatus = ( dsDefineLineLocation, dsDefineTextLocation );

  { TDimAction }
  TDimAction = Class( TEzAction )
  Private
    FDimEnt: TEzEntity;
    FAuxLine: TEzPolyLine;
    FDimStatus: TEzDimStatus;
    FCurrentIndex: Integer;
    Procedure MyMouseDown( Sender: TObject; Button: TMouseButton; Shift:
      TShiftState; X, Y: Integer; Const WX, WY: Double );
    Procedure MyMouseMove( Sender: TObject; Shift: TShiftState;
      X, Y: Integer; Const WX, WY: Double );
    Procedure MyKeyPress( Sender: TObject; Var Key: Char );
    Procedure MyPaint( Sender: TObject );
    Procedure SetCurrentPoint( Pt: TEzPoint );
    Procedure DrawEntitiesWithRubber( Const Pt: TEzPoint;
      Calculate: Boolean; Sender: TObject=Nil );
    Procedure SuspendOperation( Sender: TObject );
    Procedure ContinueOperation( Sender: TObject );
  Public
    Constructor CreateAction( CmdLine: TEzCmdLine; DimEnt: TEzEntity );
    Destructor Destroy; Override;
  End;


  {-------------------------------------------------------------------------------}
  //                  TDragDropAction
  {-------------------------------------------------------------------------------}

  TDragDropAction = Class( TEzAction )
  Private
    FCurrentRecno: Integer; {the selected recno}
    FCurrentLayer: TEzBaseLayer; {the selected layer}
    FCurrentIndex: Integer; {the vertex to reshape}
    FCurrentEntity: TEzEntity; {current entity if editing symbols}
    FReshaping: Boolean; {state is reshaping entity}
    FIsOneSelected: Boolean; {state have one entity selected}
    FNewPoint: TEzPoint; {the new point if reshaping}
    FAperture: Integer; {the aperture of frame in pixels}
    FStackedSelList: TStringList;
    FLineTransform: TEzEntity;    { line used to show the rotation angle or the distance moved }
    Procedure DrawSelectionRubberBanding( ApplyTransform: Boolean;
        Sender: TObject=Nil );
    Function MyOwnPointCode( Ent: TEzEntity;
      Const Pt: TEzPoint;
      Const Aperture: Double;
      Var Distance: Double;
      SelectPickingInside: Boolean ): Integer;

    Procedure MyMouseDown( Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer; Const WX, WY: Double );
    Procedure MyMouseMove( Sender: TObject; Shift: TShiftState;
      X, Y: Integer; Const WX, WY: Double );
    Procedure MyKeyPress( Sender: TObject; Var Key: Char );
    Procedure MyPaint( Sender: TObject );
  Public
    Constructor CreateAction( CmdLine: TEzCmdLine; Aperture: Integer );
    Destructor Destroy; Override;
  End;


  {-------------------------------------------------------------------------------}
  //                  TAddTextAction
  {-------------------------------------------------------------------------------}

  TAddTextAction = Class( TEzAction )
  Private
    FText: TEzEntity;
    FFormEditor: TCustomForm;
    FScale: Double;
    Procedure SuspendOperation( Sender: TObject );
    Procedure ContinueOperation( Sender: TObject );
    Procedure MyMouseDown( Sender: TObject; Button: TMouseButton; Shift:
      TShiftState; X, Y: Integer; Const WX, WY: Double );
    Procedure MyMouseMove( Sender: TObject; Shift: TShiftState;
      X, Y: Integer; Const WX, WY: Double );
    Procedure MyKeyPress( Sender: TObject; Var Key: Char );
    Procedure MyPaint( Sender: TObject );
    procedure SetScale(const Value: Double);
  Public
    Constructor CreateAction( CmdLine: TEzCmdLine);
    Destructor Destroy; Override;

    Property FormEditor: TCustomForm read FFormEditor write FFormEditor;
    Property Text: TEzEntity read FText write FText;

    Property Scale: Double read FScale write SetScale;
  End;

  TAddText500Action = Class( TEzAction )
  Private
    FText: TEzEntity;
    FFormEditor: TCustomForm;
    FScale: Double;
    Procedure SuspendOperation( Sender: TObject );
    Procedure ContinueOperation( Sender: TObject );
    Procedure MyMouseDown( Sender: TObject; Button: TMouseButton; Shift:
      TShiftState; X, Y: Integer; Const WX, WY: Double );
    Procedure MyMouseMove( Sender: TObject; Shift: TShiftState;
      X, Y: Integer; Const WX, WY: Double );
    Procedure MyKeyPress( Sender: TObject; Var Key: Char );
    Procedure MyPaint( Sender: TObject );
    procedure SetScale(const Value: Double);
    function  GetTextHeight: Double;
    procedure UpdateText;
  Public
    Constructor CreateAction( CmdLine: TEzCmdLine; aScale: Integer);
    Destructor Destroy; Override;

    Property FormEditor: TCustomForm read FFormEditor write FFormEditor;
    Property Text: TEzEntity read FText write FText;

    Property Scale: Double read FScale write SetScale;
  End;

  TEditTextAction = Class( TEzAction )
  Private
    FText: TEzEntity;
    FFormEditor: TCustomForm;
    FScale: Double;
    Procedure SuspendOperation( Sender: TObject );
    Procedure ContinueOperation( Sender: TObject );
    Procedure MyMouseDown( Sender: TObject; Button: TMouseButton; Shift:
      TShiftState; X, Y: Integer; Const WX, WY: Double );
    Procedure MyMouseMove( Sender: TObject; Shift: TShiftState;
      X, Y: Integer; Const WX, WY: Double );
    Procedure MyKeyPress( Sender: TObject; Var Key: Char );
    Procedure MyPaint( Sender: TObject );
    procedure SetScale(const Value: Double);
    function  GetTextSize: Integer;
    function  GetTextHeight: Double;
    procedure UpdateText(Sender: TObject);
  Public
    Constructor CreateAction(CmdLine: TEzCmdLine; aScale: Integer);
    Destructor Destroy; Override;

    Property FormEditor: TCustomForm read FFormEditor write FFormEditor;
    Property Text: TEzEntity read FText write FText;

    Property Scale: Double read FScale write SetScale;
  End;

implementation

uses
  Math, Clipbrd, EzDims, EzActions, EzGraphics, EzConsts, fVectorialText,
  EzGisTiff, fTextEditor, EzRtree, EzBasicCtrls;

type

  {-------------------------------------------------------------------------------}
  //                  TEntityClickAction
  {-------------------------------------------------------------------------------}

  TEntityClickAction = Class( TEzAction )
  Private
    FLayer: TEzBaseLayer;
    FRecno: Integer;
    { used for stacked select}
    FStackedSelList: TStringList;
    FHighlightClicked: Boolean;
    { if set to '', all layers included }
    FSearchLayerName: string;
    Procedure Mypaint( Sender: TObject );
    Procedure MyKeyPress( Sender: TObject; Var Key: Char );
    Procedure MyMouseDown( Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer; Const WX, WY: Double );
    Procedure SuspendOperation( Sender: TObject );
    Procedure HiliteClickedEntity( Hilite: Boolean );
  Public
    Constructor CreateAction( CmdLine: TEzCmdLine; LayerName: string );
    Destructor Destroy; Override;
  End;

  {-------------------------------------------------------------------------------}
  //                  TMouseMoveAction
  {-------------------------------------------------------------------------------}

  TMouseMoveAction = Class( TEzAction )
  Private
    FLastLayer: TEzBaseLayer;
    FLastRecno: Integer;
    FHighlightDetected: Boolean;
    FInMouseMove: Boolean;
    FSearchLayerName: string;
    Procedure MyMouseMove( Sender: TObject; Shift: TShiftState;
      X, Y: Integer; Const WX, WY: Double );
    Procedure MyKeyPress( Sender: TObject; Var Key: Char );
    Procedure SuspendOperation( Sender: TObject );
    Procedure ContinueOperation( Sender: TObject );
    Procedure MyPaint( Sender: TObject );
    Procedure HiliteDetectedEntity(Hilite: Boolean);
  Public
    Constructor CreateAction( CmdLine: TEzCmdLine; Const LayerName: string );
    Destructor Destroy; Override;
  End;


  {-------------------------------------------------------------------------------}
  //                  TGenericAction
  {-------------------------------------------------------------------------------}

  TGenericAction = Class( TEzAction )
  Private
    Procedure MyMouseDown( Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer; Const WX, WY: Double );
    Procedure MyMouseMove( Sender: TObject; Shift: TShiftState; X, Y: Integer; Const WX, WY: Double );
    Procedure MyMouseUp( Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer; Const WX, WY: Double );
    Procedure MyPaint( Sender: TObject );
    Procedure MyOnClick( Sender: TObject );
    Procedure MyDblClick( Sender: TObject );
    procedure MyOnKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    Procedure MyKeyPress( Sender: TObject; Var Key: Char );
    procedure MyOnKeyUp(Sender: TObject; var Key: Word; Shift: TShiftState);
    Procedure MyActionDoCommand( Sender: TObject );
    Procedure MySuspendOperation( Sender: TObject );
    Procedure MyContinueOperation( Sender: TObject );
    Procedure MyUndo( Sender: TObject );
    Procedure MyInitialize( Sender: TObject );
  Public
    Constructor CreateAction( CmdLine: TEzCmdLine; L: TEzActionLauncher );
  End;


{ TEzActionLauncher }

constructor TEzActionLauncher.Create(AOwner: TComponent);
begin
  inherited Create( Aowner );
  FCursor:= crCross;
  FMouseDrawElements:= [mdCursorFrame, mdFullViewCursor];
end;

procedure TEzActionLauncher.Notification(AComponent: TComponent; Operation: TOperation);
begin
  Inherited Notification( AComponent, Operation );
  If ( Operation = opRemove ) And ( AComponent = FCmdLine ) Then
    FCmdLine := Nil;
end;

procedure TEzActionLauncher.SetCmdLine(const Value: TEzCmdLine);
begin
{$IFDEF LEVEL5}
  if Assigned( FCmdLine ) then FCmdLine.RemoveFreeNotification( Self );
{$ENDIF}
  If Value <> Nil Then
  Begin
    Value.FreeNotification( Self );
  End;
  FCmdLine := Value;
end;

procedure TEzActionLauncher.Finish;
begin
  { please don't call this method inside an event handler of TEzActionLauncher }
  If (FCmdLine = Nil) Or (FCmdLine.TheDefaultAction = FCmdLine.CurrentAction) Or
    (FCmdLine.CurrentAction.Launcher <> Self ) Then Exit;
  FCmdLine.Pop;
end;

procedure TEzActionLauncher.PushAction( const TrackID: string );
begin
  with FCurrentAction do
  begin
    Launcher := Self;
    Cursor:= Self.Cursor;
    CanDoOsnap:= Self.FCanDoOsnap;
    CanDoAccuDraw:= Self.FCanDoAccuDraw;
    MouseDrawElements:= Self.FMouseDrawElements;
  end;
  FCmdLine.Push( FCurrentAction, true, SCmdTracking, TrackID );
end;

procedure TEzActionLauncher.TrackPlace(const TrackID: string);
begin
  Assert( FCmdLine <> Nil );
  FCurrentAction:= TAddEntityAction.CreateAction( FCmdLine,
    TEzPlace.CreateEntity( Point2D( 0, 0 ) ), Point(0,0) );
  PushAction( TrackID );
end;

procedure TEzActionLauncher.TrackPoint(const TrackID: string);
begin
  Assert( FCmdLine <> Nil );
  FCurrentAction:= TAddEntityAction.CreateAction( FCmdLine,
    TEzPointEntity.CreateEntity( Point2D( 0, 0 ), clblack ), Point(0,0));
  PushAction( TrackID );
end;

procedure TEzActionLauncher.TrackPolygon(const TrackID: string);
begin
  Assert( FCmdLine <> Nil );
  FCurrentAction:= TAddEntityAction.CreateAction( FCmdLine,
    TEzPolygon.CreateEntity( [Point2D( 0, 0 )] ), Point(0,0));
  PushAction( TrackID );
end;

procedure TEzActionLauncher.TrackPolyline(const TrackID: string);
begin
  Assert( FCmdLine <> Nil );
  FCurrentAction:= TAddEntityAction.CreateAction( FCmdLine,
    TEzPolyLine.CreateEntity( [Point2D( 0, 0 )] ), Point(0,0) );
  PushAction( TrackID );
end;

procedure TEzActionLauncher.TrackSketch(const TrackID: string);
begin
  Assert( FCmdLine <> Nil );
  FCurrentAction:= TSketchAction.CreateAction( FCmdLine,
    TEzPolyLine.CreateEntity( [Point2D(0, 0)] ) );
  PushAction( TrackID );
end;

procedure TEzActionLauncher.TrackRectangle(const TrackID: string;
  ScaledWidth: Integer = 0; ScaledHeight: Integer=0 );
begin
  Assert( FCmdLine <> Nil );
  FCurrentAction:= TAddEntityAction.CreateAction( FCmdLine,
    TEzRectangle.CreateEntity( Point2D( 0, 0 ), Point2D( 0, 0 ) ), Point(ScaledWidth,ScaledHeight) );
  PushAction( TrackID );
end;

procedure TEzActionLauncher.TrackSpline(const TrackID: string);
begin
  Assert( FCmdLine <> Nil );
  FCurrentAction:= TAddEntityAction.CreateAction( FCmdLine,
    TEzSpline.CreateEntity( [Point2D( 0, 0 )] ), Point(0,0) );
  PushAction( TrackID );
end;

procedure TEzActionLauncher.TrackArc3P(const TrackID: string);
var
  p: TEzPoint;
begin
  Assert( FCmdLine <> Nil );
  p:= Point2d(0,0);
  FCurrentAction:= TAddEntityAction.CreateAction( FCmdLine, TEzArc.CreateEntity( p,p,p ), Point(0,0) );
  PushAction( TrackID );
end;

procedure TEzActionLauncher.TrackArcSE(const TrackID: string);
begin
  Assert( FCmdLine <> Nil );
  FCurrentAction:= TDrawArcAction.CreateAction( FCmdLine );
  PushAction( TrackID );
end;

procedure TEzActionLauncher.TrackEllipse(const TrackID: string);
begin
  Assert( FCmdLine <> Nil );
  FCurrentAction:= TAddEntityAction.CreateAction( FCmdLine,
    TEzEllipse.CreateEntity( Point2D( 0, 0 ), Point2D( 0, 0 ) ), Point(0,0) );
  PushAction( TrackID );
end;

{ FileName must not include path }
procedure TEzActionLauncher.TrackPictureRef(const TrackID, FileName: string);
var
  Entity: TEzEntity;
  Dims: TPoint;
  TheGraphicLink: TEzGraphicLink;
  filnam: string;
begin
  Assert( FCmdLine <> Nil );
  TheGraphicLink := TEzGraphicLink.Create;
  try
    filnam := AddSlash( Ez_Preferences.CommonSubDir ) + FileName;
    If FileExists( filnam ) Then
    begin
      TheGraphicLink.ReadGeneric( filnam );
      Dims.X:= TheGraphicLink.Bitmap.Width;
      Dims.Y:= TheGraphicLink.Bitmap.Height;
    end else
    begin
      Exit;
    end;
  Finally
    TheGraphicLink.Free;
  End;
  Entity:= TEzPictureRef.CreateEntity( Point2D( 0, 0 ), Point2D( 0, 0 ), FileName );
  FCurrentAction:= TAddEntityAction.CreateAction( FCmdLine, Entity, Dims );
  PushAction( TrackID );
end;

{ FileName must not include path }
procedure TEzActionLauncher.TrackBandsBitmap(const TrackID, FileName: string);
var
  Entity: TEzEntity;
  Dims: TPoint;
  IsCompressed: Boolean;
begin
  Assert( FCmdLine <> Nil );
  Entity:= TEzBandsBitmap.CreateEntity( Point2D( 0, 0 ), Point2D( 0, 0 ), FileName );
  case TEzBandsBitmap(Entity).GetFormat of
    ifBitmap:
      GetDIBDimensions( AddSlash(Ez_Preferences.CommonSubdir) + FileName, nil, Dims.X, Dims.Y, IsCompressed);
    ifTiff:
      GetTiffDimensions( AddSlash(Ez_Preferences.CommonSubdir) + FileName, nil, Dims.X, Dims.Y, IsCompressed);
    ifBIL:
      GetBILDimensions( AddSlash(Ez_Preferences.CommonSubdir) + FileName, Dims.X, Dims.Y);
  end;
  FCurrentAction:= TAddEntityAction.CreateAction( FCmdLine, Entity, Dims );
  PushAction( TrackID );
end;

{ BlockName must not include path }
procedure TEzActionLauncher.TrackBlock(const TrackID, BlockName: string;
  const Rotangle, ScaleX, ScaleY: Double );
var
  Entity: TEzEntity;
begin
  Assert( FCmdLine <> Nil );
  Entity:= TEzBlockInsert.CreateEntity( ExtractFileName( BlockName ),
    Point2D( 0.0, 0.0 ), Rotangle, ScaleX, ScaleY );
  FCurrentAction:= TAddEntityAction.CreateAction( FCmdLine, Entity, Point(0,0) );
  PushAction( TrackID );
end;

procedure TEzActionLauncher.TrackBuffer(const TrackID: string);
begin
  Assert( FCmdLine <> Nil );
  FCurrentAction:= TBufferSelectAction.CreateAction( FCmdLine );
  PushAction( TrackID );
end;

procedure TEzActionLauncher.TrackCircle(const TrackID: string; DrawType: TEzCircleDrawType);
begin
  Assert( FCmdLine <> Nil );
  case DrawType of
    ct2P, ct3P, ctCR:
      FCurrentAction:= TDrawCircleAction.CreateAction( FCmdLine, DrawType );
  else
    FCurrentAction:= TDrawCircleAction.CreateAction( FCmdLine, ctCR );
  end;
  PushAction( TrackID );
end;

procedure TEzActionLauncher.TrackEntity(const TrackID: string; TrackedEntity: TEzEntity);
var
  ImageDimensions: TPoint;
  IsCompressed: Boolean;
  FullName: string;
  GL: TEzGraphicLink;
begin
  Assert( (FCmdLine <> Nil) And (TrackedEntity <> Nil) );
  FCurrentAction:= Nil;
  if TrackedEntity.EntityID = idTrueTypeText then
  begin
    FCurrentAction:= TAddTextAction.CreateAction( FCmdLine );
    FCurrentAction.Launcher:= Self;
  end else if TrackedEntity.EntityID = idGroup then
  begin
  end else if TrackedEntity.EntityID = idRtfText then
  begin
    { pendiente de implementar rich text }
  end else if TrackedEntity.EntityID = idJustifVectText then
  begin
    FCurrentAction:= TAddVectorialTextAction.CreateAction( FCmdLine, TrackedEntity,
      true, tbsNone );
    FCurrentAction.Launcher:= Self;
  end else if TrackedEntity.EntityID = idFittedVectText then
  begin
    FCurrentAction:= TAddVectorialTextAction.CreateAction( FCmdLine, TrackedEntity,
      false, TEzFittedVectorText( TrackedEntity ).TextBorderStyle );
    FCurrentAction.Launcher:= Self;
  end else if TrackedEntity.EntityID in [idDimHorizontal, idDimVertical, idDimParallel] then
  begin
    FCurrentAction:= TDimAction.CreateAction( FCmdLine, TrackedEntity );
    FCurrentAction.Launcher := Self;
  end else if TrackedEntity.EntityID = idPictureRef then
  begin
    FullName:= AddSlash( Ez_Preferences.CommonSubdir ) +
      TEzPictureRef( TrackedEntity ).FileName;
    GL:= TEzGraphicLink.Create;
    try
      GL.ReadGeneric(FullName);
      ImageDimensions.X:= GL.Bitmap.Width;
      ImageDimensions.Y:= GL.Bitmap.Height;
      FCurrentAction:= TAddEntityAction.CreateAction( FCmdLine, TrackedEntity, ImageDimensions );
      FCurrentAction.Launcher := Self;
    finally
      Gl.Free;
    end;
  end else if TrackedEntity.EntityID = idBandsBitmap then
  begin
    { Get the bitmap dimensions}
    FullName:= AddSlash( Ez_Preferences.CommonSubdir ) +
      TEzBandsBitmap( TrackedEntity ).FileName;
    case TEzBandsBitmap(TrackedEntity).GetFormat of
      ifBitmap:
        GetDIBDimensions( FullName, nil, ImageDimensions.X, ImageDimensions.Y, IsCompressed);
      ifTiff:
        GetTiffDimensions( FullName, nil, ImageDimensions.X, ImageDimensions.Y, IsCompressed);
      ifBIL:
        GetBILDimensions( FullName, ImageDimensions.X, ImageDimensions.Y);
    end;
    FCurrentAction:= TAddEntityAction.CreateAction( FCmdLine, TrackedEntity, ImageDimensions );
    FCurrentAction.Launcher := Self;
  end else
  begin
    FCurrentAction:= TAddEntityAction.CreateAction( FCmdLine, TrackedEntity, Point(0,0) );
    FCurrentAction.Launcher := Self;
  end;

  if Assigned( FCurrentAction ) then
  begin
    PushAction( TrackID );
  end;

end;

procedure TEzActionLauncher.TrackEntityClick( const TrackID: string;
  Const LayerName: string = ''; HighlightClicked: Boolean = True );
begin
  Assert( FCmdLine <> Nil );
  FCurrentAction:= TEntityClickAction.CreateAction(FCmdLine, LayerName);
  TEntityClickAction( FCurrentAction ).FHighlightClicked := HighlightClicked;
  PushAction( TrackID );
end;

function TEzActionLauncher.GetCaption: String;
begin
  Assert( FCmdLine <> Nil );
  Result:= FCmdLine.Caption;
end;

procedure TEzActionLauncher.SetCaption(const Value: String);
begin
  Assert( FCmdLine <> Nil );
  FCmdLine.Caption:= Value;
end;

function TEzActionLauncher.GetCurrentTrackID: string;
begin
  Assert( FCmdLine <> Nil );
  Result:= FCmdLine.CurrentActionID;
end;

function TEzActionLauncher.IsRunning: Boolean;
begin
  Assert( FCmdLine <> Nil );
  Result:= FCurrentAction <> Nil;
end;

function TEzActionLauncher.GetStatusMessage: string;
begin
  Result:='';
end;

procedure TEzActionLauncher.SetStatusMessage(const Value: string);
begin
  Assert( FCmdLine <> Nil );
  FCmdLine.StatusMessage:= Value;
end;

procedure TEzActionLauncher.TrackEntityDragDrop( const TrackID: string );
begin
  Assert( FCmdLine <> Nil );
  FCurrentAction:= TDragDropAction.CreateAction( FCmdLine, Ez_Preferences.ApertureWidth );
  PushAction( TrackID );
end;

procedure TEzActionLauncher.TrackEntityMouseMove(const TrackID: string;
  Const LayerName: string = ''; HighlightDetected: Boolean = True);
begin
  Assert( FCmdLine <> Nil );
  FCurrentAction:= TMouseMoveAction.CreateAction(FCmdLine, LayerName);
  TMouseMoveAction( FCurrentAction ).FHighlightDetected := HighlightDetected;
  PushAction( TrackID );
end;

procedure TEzActionLauncher.TrackGenericAction(const TrackID: string);
begin
  Assert( FCmdLine <> Nil );
  FFinished:= False;
  FCurrentAction:= TGenericAction.CreateAction( FCmdLine, Self );
  PushAction( TrackID );
end;

function TEzActionLauncher.GetDefaultAction: Boolean;
begin
  Result:= False;  // how to know ?
end;

procedure TEzActionLauncher.SetDefaultAction(const Value: Boolean);
begin
  Assert( FCmdLine <> Nil );
  if Value then
    FCmdLine.TheDefaultAction := TGenericAction.CreateAction( FCmdLine, Self )
  else
    FCmdLine.TheDefaultAction := Nil; // this causes to reset the default action
end;

{-------------------------------------------------------------------------------}
//                  TAddEntityAction - class implementation
{-------------------------------------------------------------------------------}

Constructor TAddEntityAction.CreateAction( CmdLine: TEzCmdLine; Ent: TEzEntity; Const ImgDims: TPoint );
Begin
  Inherited CreateAction( CmdLine );

  FEntity := Ent;
  FImgDims := ImgDims;

  FIsImage := Not((FImgDims.X=0) And (FImgDims.Y=0));

  FDrawImmediately:= Ent.EntityID in [idPlace, idNode, idBlockInsert];

  CanDoOsnap := True;
  CanDoAccuDraw:= True;
  If CmdLine.UseFullViewCursor Then
    MouseDrawElements:= [mdCursorFrame, mdFullViewCursor]
  Else
    MouseDrawElements:= [mdCursor];

  OnMouseDown := MyMouseDown;
  OnMouseMove := MyMouseMove;
  OnKeyPress := MyKeyPress;
  OnPaint := MyPaint;
  OnSuspendOperation := Self.SuspendOperation;
  OnContinueOperation := Self.ContinueOperation;

  // set line width to the default
  If Ent Is TEzOpenedEntity Then
    TEzOpenedEntity( Ent ).Pentool.Width := Ez_Preferences.DefPenStyle.Width;

  If Ent.EntityID In [idPlace, idNode] Then
  Begin
    With TEzPlace( Ent ), CmdLine.ActiveDrawBox Do
    Begin
      Symboltool.Height := Grapher.GetRealSize( Ez_Preferences.DefSymbolStyle.Height );
      If (Grapher.DistToPointsY(Symboltool.Height) < 8 ) Or
         (Grapher.DistToPointsY(Symboltool.Height) > 48 ) Then
      Symboltool.Height := Grapher.PointsToDistY(14);
    End;
  End;

  { this is used for snapping to this entity also because this entity is not yet
    saved to the database }
  EzSystem.GlobalTempEntity:= Ent;

  // define the cursor for this action
  Cursor:= crDrawCross;

  WaitingMouseClick := True;
  SetAddActionCaption;
  CmdLine.All_Invalidate;
End;

Destructor TAddEntityAction.Destroy;
Begin
  { If not nil then the entity was not added to the file/symbol and we must delete it }
  If FEntity <> Nil Then FEntity.Free;
  EzSystem.GlobalTempEntity:= Nil;

  Inherited Destroy;
End;

Procedure TAddEntityAction.SetCurrentPoint( Pt: TEzPoint; Orto: Boolean );
Var
  I: Integer;
  ImgWidth, ImgHeight: Double;
Begin
  If Orto And ( FCurrentIndex > 0 ) And
    ( FEntity.EntityID In [idPolyline, idPolygon] ) Then
    Pt := ChangeToOrtogonal( FEntity.Points[FCurrentIndex - 1], Pt );

  If ( FEntity.EntityID = idSpline ) And ( fCurrentIndex > 0 ) And
    ( ( TEzSpline( FEntity ).PointsInCurve / fCurrentIndex ) < 10 ) Then
    TEzSpline( FEntity ).PointsInCurve := fCurrentIndex * 10 + 100;

  FEntity.Points[FCurrentIndex] := Pt;
  For I := FCurrentIndex + 1 To FEntity.Points.Count - 1 Do
    FEntity.Points[I] := Pt;

  { set the image entity dimension proportional to source image }
  If FIsImage And ( FCurrentIndex = 1 ) Then
  Begin
    { the rectangle must be proportional to the bitmap dimensions }
    ImgWidth := FEntity.Points[1].X - FEntity.Points[0].X;
    ImgHeight := ( Abs( ImgWidth ) / FImgDims.X ) * FImgDims.Y;
    If FEntity.Points[1].Y < FEntity.Points[0].Y Then
      ImgHeight := -ImgHeight;
    FEntity.Points[1] := Point2d( FEntity.Points[0].X + ImgWidth,
      FEntity.Points[0].Y + ImgHeight );
  End;
  If FCurrentIndex = 0 Then
    WaitingMouseClick := False;
End;

Procedure TAddEntityAction.AddPoint( const CurrPoint: TEzPoint );
Var
  I: Integer;
  s: String;
Begin
  with CmdLine.ActiveDrawBox do
  begin
    { "mark" the clicked point }
    DrawCross( Canvas, Grapher.RealToPoint( CurrPoint ) );
    SetCurrentPoint( CurrPoint, CmdLine.UseOrto );

    { set AccuDraw position }
    If FCurrentIndex = 0 Then
      CmdLine.AccuDraw.UpdatePosition( CurrPoint, CurrPoint )  // this activates AccuDraw
    Else If FCurrentIndex > 0 Then
    Begin
      If FEntity.EntityID In [idRtfText,idPictureRef,idPersistBitmap,
            idCustomPicture,idBandsBitmap,idEllipse,idRectangle,idTable] Then
        CmdLine.AccuDraw.UpdatePosition( CurrPoint, CurrPoint )
      Else
        CmdLine.AccuDraw.UpdatePosition( FEntity.Points[FCurrentIndex-1], CurrPoint );
    End;

    If ( Not FEntity.Points.CanGrow ) And ( FCurrentIndex >= FEntity.Points.Count - 1 ) Then
    Begin
      CmdLine.All_DrawEntity2DRubberBand( FEntity );
      if Assigned( Launcher ) then
      begin
        if Assigned( TEzActionLauncher( Launcher ).OnTrackedEntity ) then
          TEzActionLauncher( Launcher ).OnTrackedEntity( Launcher, Self.ActionID, FEntity );
        CmdLine.All_Invalidate;
      End else
        ActionAddNewEntity( CmdLine, FEntity );
      Self.Finished := true;
      Exit;
    End
    Else
      Inc( FCurrentIndex );

    { if end user holds down the ALT key, display an informative dialog form }
    If ( GetAsyncKeyState( VK_menu ) Shr 1 ) <> 0 Then
    Begin
      For I := 0 To FEntity.Points.Count - 1 Do
        s := s + Format( '(%f, %f),' + CrLf, [FEntity.Points[I].X, FEntity.Points[I].Y] );
      Clipboard.SetTextBuf( PChar( s ) );
    End;
    SetAddActionCaption;
  end;
End;

Procedure TAddEntityAction.MyMouseDown( Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer; Const WX, WY: Double );
Var
  Key: Char;
  CurrPoint: TEzPoint;
Begin
  If Button = mbRight Then
  begin
    Key:= #13 ;
    MyKeyPress( Nil, Key );
    Exit;
  end;
  CurrPoint := CmdLine.GetSnappedPoint;

  AddPoint( CurrPoint );

End;

Procedure TAddEntityAction.SetAddActionCaption;
Begin
  Case fCurrentIndex Of
    0: Caption := SFirstPoint;
    1: Caption := SSecondPoint;
    2: Caption := SThirdPoint;
    3: Caption := SFourthPoint;
    4: Caption := SFifthPoint;
  Else
    Caption := SNextPoint;
  End;
End;

Procedure TAddEntityAction.DrawEntityRubberToAll( DrawBox: TEzBaseDrawBox );
//var
//  TempEnt: TEzEntity;
Begin
  {If (FEntity.EntityID In [idPolygon]) And (FEntity.Points.Count > 2) then
  begin
    // Create a clone entity in order to draw closed polygon
    TempEnt:= FEntity.Clone();
    Try
      NormalizePolygon( TempEnt );
      If DrawBox = Nil then
        CmdLine.All_DrawEntity2DRubberBand( TempEnt )
      Else
        DrawBox.DrawEntity2DRubberBand( TempEnt );
    Finally
      TempEnt.Free;
    End;
  end else
  begin }
    If DrawBox = Nil then
      CmdLine.All_DrawEntity2DRubberBand( FEntity )
    Else
      DrawBox.DrawEntity2DRubberBand( FEntity );
  //end;
End;

Procedure TAddEntityAction.MyMouseMove( Sender: TObject; Shift: TShiftState;
  X, Y: Integer; Const WX, WY: Double );
Var
  CurrPoint, P1, P2: TEzPoint;
  DX, DY, Area, Perimeter, Angle: Double;
  nd: Integer;
Begin
  With CmdLine Do
  Begin
    if FDrawImmediately Or Not EqualPoint2d( Self.LastClicked, INVALID_POINT) Then
      DrawEntityRubberToAll(Nil);

    CurrPoint := CmdLine.GetSnappedPoint;
    SetCurrentPoint( CurrPoint, CmdLine.UseOrto );

    DrawEntityRubberToAll(Nil);

    // show some info
    If FCurrentIndex > 0 Then
    Begin
      P1 := FEntity.Points[FCurrentIndex - 1];
      P2 := FEntity.Points[FCurrentIndex];
      DX := Abs( P2.X - P1.X );
      DY := Abs( P2.Y - P1.Y );
      If ( DX = 0 ) And ( DY = 0 ) Then
      Begin
        Angle := 0;
        Area := 0;
        Perimeter := 0;
      End
      Else
      Begin
        Angle := RadToDeg( Angle2D( P1, P2 ) );
        Area := FEntity.Area( );
        Perimeter := FEntity.Perimeter( );
      End;
      nd:= CmdLine.ActiveDrawBox.NumDecimals;
      CmdLine.StatusMessage := Format( SNewEntityInfo,
        [nd, Angle, nd, DX, nd, DY, nd, Area, nd, Perimeter] );
    End
    Else
      CmdLine.StatusMessage := '';
  End;
End;

Procedure TAddEntityAction.MyPaint( Sender: TObject );
Begin
  If FDrawImmediately Or (FEntity <> Nil) Then
    DrawEntityRubberToAll((Sender as TEzBaseDrawBox));
End;

Procedure TAddEntityAction.MyKeyPress( Sender: TObject; Var Key: Char );
Begin
  With CmdLine Do
    Case Key Of
      #13:
        If FEntity.Points.CanGrow Then
        Begin
          If ( FEntity.IsClosed And ( fCurrentIndex < 2 ) ) Or
            ( Not FEntity.IsClosed And ( fCurrentIndex < 2 ) ) Then
          Begin
            MessageToUser( SNotEnoughData, smsgerror, MB_ICONERROR );
            Exit;
          End;
          (* Erase entity from screen and last point *)
          DrawEntityRubberToAll(Nil);
          FEntity.Points.Delete( fCurrentIndex );
          if Assigned( Launcher ) then
          begin
            if Assigned( TEzActionLauncher( Launcher ).OnTrackedEntity ) then
              TEzActionLauncher( Launcher ).OnTrackedEntity( Launcher, Self.ActionID, FEntity );
            All_Refresh;
          end else
            ActionAddNewEntity( CmdLine, FEntity );
          Self.Finished := true;
          Key := #0;
          Exit;
        End;
      #27:
        Begin
          DrawEntityRubberToAll(Nil);
          If FCurrentIndex = 0 Then
          Begin
            FreeAndNil( FEntity );
            Self.Finished := true;
            Exit;
          End;
          Dec( FCurrentIndex );
          FEntity.Points.Count := FCurrentIndex;
          { update the last clicked point (used when snapping to paraller, perpendicular,etc) }
          If FEntity.Points.Count = 0 Then
            Self.LastClicked:= INVALID_POINT
          Else
            Self.LastClicked:= FEntity.Points[FCurrentIndex-1];
          SetCurrentPoint( CurrentPoint, UseOrto );
          DrawEntityRubberToAll(Nil);
          If (FEntity.EntityID in [idPolyline,idPolygon,idArc,idSpline,idNodeLink]) then
          begin
            If FCurrentIndex = 1 Then
              AccuDraw.UpdatePosition( FEntity.Points[0], FEntity.Points[0] )
            Else If FCurrentIndex > 0 Then
              AccuDraw.UpdatePosition( FEntity.Points[FCurrentIndex-2], FEntity.Points[FCurrentIndex-1] );
          end;
        End;
    End;
End;

procedure TAddEntityAction.SuspendOperation(Sender: TObject);
begin
  with CmdLine do
  begin
    If Assigned( FEntity ) And (FDrawImmediately Or
       Not EqualPoint2d( Self.LastClicked, INVALID_POINT)) Then
      DrawEntityRubberToAll(Nil);
  end;
end;

procedure TAddEntityAction.ContinueOperation(Sender: TObject);
begin
  with CmdLine do
  begin
    If Assigned( FEntity ) And (FDrawImmediately Or
       Not EqualPoint2d( Self.LastClicked, INVALID_POINT)) Then
      DrawEntityRubberToAll(Nil);
  end;
end;

{-------------------------------------------------------------------------------}
//                  TSketchAction - class implementation
{-------------------------------------------------------------------------------}

Constructor TSketchAction.CreateAction( CmdLine: TEzCmdLine; Ent: TEzEntity );
Begin
  Inherited CreateAction( CmdLine );

  FEntity := Ent;

  CanDoOsnap := False;
  CanDoAccuDraw:= False;
  If CmdLine.UseFullViewCursor Then
    MouseDrawElements:= [mdCursorFrame, mdFullViewCursor]
  Else
    MouseDrawElements:= [mdCursor];

  OnMouseDown := MyMouseDown;
  OnMouseMove := MyMouseMove;
  OnKeyPress:= MyKeyPress;
  OnPaint := MyPaint;
  OnSuspendOperation := Self.SuspendOperation;
  OnContinueOperation := Self.ContinueOperation;

  // set line width to the default
  If Ent Is TEzOpenedEntity Then
    TEzOpenedEntity(Ent).Pentool.Width := Ez_Preferences.DefPenStyle.Width;

  { This is used for snapping to this entity also because this entity is not yet
    saved to the database }
  EzSystem.GlobalTempEntity:= Ent;

  // define the cursor for this action
  Cursor:= crDrawCross;

  WaitingMouseClick := True;
  Caption := SFirstPoint;
  CmdLine.All_Invalidate;
End;

Destructor TSketchAction.Destroy;
Begin
  { If not nil then the entity was not added to the file/symbol and we must delete it }
  If FEntity <> Nil Then FEntity.Free;
  EzSystem.GlobalTempEntity:= Nil;
  Inherited Destroy;
End;

Procedure TSketchAction.SetCurrentPoint( Pt: TEzPoint);
Var
  I: Integer;
Begin
  FEntity.Points[FCurrentIndex] := Pt;
  For I := FCurrentIndex + 1 To FEntity.Points.Count - 1 Do
    FEntity.Points[I] := Pt;
End;

Procedure TSketchAction.AddPoint( const CurrPoint: TEzPoint );
Begin
  with CmdLine.ActiveDrawBox do
  begin
    SetCurrentPoint(CurrPoint);

    { Set AccuDraw position }
    //If FCurrentIndex = 0 Then
    //  CmdLine.AccuDraw.UpdatePosition( CurrPoint, CurrPoint );  // this activates AccuDraw

    Inc( FCurrentIndex );

  end;
End;

Procedure TSketchAction.CleanEntity;
var
  I: Integer;
  TempV: TEzVector;
  Pivot: TEzPoint;
  OldAngle,Angle: Double;
  found: Boolean;
Begin
  If FEntity.Points.Count < 3 then Exit;
  { erase all repeated points and also points that have the same slope }
  TempV:= TEzVector.Create(FEntity.Points.Count);
  try
    Pivot:= FEntity.Points[0];
    TempV.Add(Pivot);
    OldAngle:= Angle2d( Pivot, FEntity.Points[1] );
    I:= 1;
    while I <= FEntity.Points.Count-1 do
    begin
      Angle:= Angle2d(Pivot, FEntity.Points[I]);
      If Angle <> OldAngle Then
      Begin
        Pivot:= FEntity.Points[I-1];
        TempV.Add(Pivot);
        OldAngle:= Angle2d(Pivot, FEntity.Points[I]);
      End;
      Inc(I);
    end;
    { now delete repeated vertices }
    repeat
      found:= false;
      for I:= 1 to TempV.Count-1 do
        If EqualPoint2d( TempV[I-1], TempV[I]) then
        begin
          TempV.Delete(I);
          found:= true;
          break;
        end;
    until not found;
    FEntity.Points.Assign( TempV );
  finally
    TempV.Free;
  end;
End;

Procedure TSketchAction.MyMouseDown( Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer; Const WX, WY: Double );
Var
  CurrPoint: TEzPoint;
Begin
  If Not FIsDrawing And (Button = mbRight) Then
  begin
    Self.Finished:= True;
    Exit;
  end;
  CurrPoint := CmdLine.CurrentPoint;  //CmdLine.GetSnappedPoint;

  AddPoint( CurrPoint );

  If FIsDrawing Then
  Begin
    If ( FEntity.IsClosed And ( fCurrentIndex < 3 ) ) Or
      ( Not FEntity.IsClosed And ( fCurrentIndex < 2 ) ) Then
    Begin
      Self.Finished:= True;
      Exit;
    End;
    CmdLine.All_DrawEntity2DRubberBand( FEntity);
    CleanEntity;
    if Assigned( Launcher ) then
    begin
      if Assigned( TEzActionLauncher( Launcher ).OnTrackedEntity ) then
        TEzActionLauncher( Launcher ).OnTrackedEntity( Launcher, Self.ActionID, FEntity );
      CmdLine.All_Refresh;
    end else
      ActionAddNewEntity( CmdLine, FEntity );
    Self.Finished:= True;
    Exit;
  End;

  FIsDrawing:= True;

End;

Procedure TSketchAction.MyMouseMove( Sender: TObject; Shift: TShiftState;
  X, Y: Integer; Const WX, WY: Double );
Var
  CurrPoint: TEzPoint;
Begin
  If Not FIsDrawing Then Exit;
  With CmdLine Do
  Begin
    if Not EqualPoint2d( Self.LastClicked, INVALID_POINT) Then
      All_DrawEntity2DRubberBand( FEntity );

    CurrPoint := CmdLine.CurrentPoint;  //CmdLine.GetSnappedPoint;
    SetCurrentPoint(CurrPoint);

    AddPoint( CurrPoint );

    All_DrawEntity2DRubberBand( FEntity );

  End;
End;

Procedure TSketchAction.MyKeyPress( Sender: TObject; Var Key: Char );
Begin
  If Key=#27 then
  begin
    CmdLine.All_DrawEntity2DRubberBand( FEntity);
    FreeAndNil( FEntity );
    Self.Finished:= true
  end;
End;

Procedure TSketchAction.MyPaint( Sender: TObject );
Begin
  If FEntity <> Nil Then
    (Sender as TEzBaseDrawBox).DrawEntity2DRubberBand( FEntity );
End;

procedure TSketchAction.SuspendOperation(Sender: TObject);
begin
  with CmdLine do
  begin
    If Assigned( FEntity ) And Not EqualPoint2d( Self.LastClicked, INVALID_POINT) Then
      All_DrawEntity2DRubberBand( FEntity);
  end;
end;

procedure TSketchAction.ContinueOperation(Sender: TObject);
begin
  with CmdLine do
  begin
    If Assigned( FEntity ) And Not EqualPoint2d( Self.LastClicked, INVALID_POINT) Then
      All_DrawEntity2DRubberBand( FEntity);
  end;
end;

{ TDrawCircleAction }

Constructor TDrawCircleAction.CreateAction( CmdLine: TEzCmdLine;
  CircleDrawType: TEzCircleDrawType );
Var
  p: TEzPoint;
Begin
  Inherited CreateAction( CmdLine );

  FCircleDrawType := CircleDrawType;

  P := Point2d( 0, 0 );
  FCircle := TEzEllipse.CreateEntity( p, p );

  CanDoOsnap := True;
  CanDoAccuDraw:= True;
  MouseDrawElements:= [mdCursorFrame, mdFullViewCursor];

  OnMouseDown := MyMouseDown;
  OnMouseMove := MyMouseMove;
  OnKeyPress := MyKeyPress;
  OnPaint := MyPaint;
  OnSuspendOperation := Self.SuspendOperation;
  OnContinueOperation := Self.ContinueOperation;

  Cursor := crDrawCross;
  WaitingMouseClick := True;
  SetAddActionCaption;
End;

Destructor TDrawCircleAction.Destroy;
Begin
  { If not nil then the entity was not added to the file/symbol
    and we must delete it }
  if Assigned(FCircle) then FreeAndNil( FCircle );
  Inherited Destroy;
End;

Function TDrawCircleAction.IndexLimit: Integer;
Begin
  Case FCircleDrawType Of
    ct2P: result := 1;
    ct3P: result := 2;
    ctCR: result := 1;
  Else
    result := 2;
  End;
End;

Procedure TDrawCircleAction.SetCurrentPoint( Pt: TEzPoint; Orto: Boolean );
Begin
  If Orto And ( FCurrentIndex > 0 ) Then
    Pt := ChangeToOrtogonal( FPts[FCurrentIndex - 1], Pt );
  FPts[FCurrentIndex] := Pt;
  If FCurrentIndex = 0 Then
    WaitingMouseClick := False;
End;

// create the circle through three points

Procedure TDrawCircleAction.CreateCircle;
Var
  MidPt, RotPt, TestPt: TEzPoint;
  V1, V2, IntersV: TEzVector;
  Radius: Double;
  Center: TEzPoint;
Begin
  If FCurrentIndex < IndexLimit Then Exit;
  If ( IndexLimit = 2 ) And EqualPoint2d( FPts[0], Fpts[1] ) Or
    EqualPoint2d( FPts[0], FPts[2] ) Or EqualPoint2d( FPts[1], FPts[2] ) Then Exit;

  If FCircleDrawType = ct2P Then
  Begin
    Center := Point2d( ( FPts[0].X + FPts[1].X ) / 2, ( FPts[0].Y + FPts[1].Y ) / 2 );
    Radius := Dist2d( FPts[0], FPts[1] ) / 2;
    FCircle.BeginUpdate;
    FCircle.Points[0] := Point2d( Center.X - Radius, Center.Y - Radius );
    FCircle.Points[1] := Point2d( Center.X + Radius, Center.Y + Radius );
    FCircle.EndUpdate;
  End
  Else If FCircleDrawType = ctCR Then
  Begin
    Center := FPts[0];
    Radius := Dist2d( FPts[0], FPts[1] );
    FCircle.BeginUpdate;
    FCircle.Points[0] := Point2d( Center.X - Radius, Center.Y - Radius );
    FCircle.Points[1] := Point2d( Center.X + Radius, Center.Y + Radius );
    FCircle.EndUpdate;
  End
  Else If FCircleDrawType = ct3P Then
  Begin
    // check if 3 points are colinear
    TestPt := Perpend( FPts[2], FPts[0], FPts[1] );
    If EqualPoint2d( FPts[2], TestPt ) Then
    Begin
      FCircle.BeginUpdate;
      FCircle.Points[0] := Point2d( 0, 0 );
      FCircle.Points[1] := Point2d( 0, 0 );
      FCircle.EndUpdate;
      exit;
    End;
    V1 := TEzVector.Create( 2 );
    V2 := TEzVector.Create( 2 );
    IntersV := TEzVector.Create( 2 );
    Try
      MidPt := Point2d( ( FPts[0].X + FPts[1].X ) / 2, ( FPts[0].Y + FPts[1].Y ) / 2 );
      RotPt := TransformPoint2d( FPts[0], Rotate2d( System.Pi / 2, MidPt ) );
      V1.Add( MidPt );
      V1.Add( RotPt );

      MidPt := Point2d( ( FPts[1].X + FPts[2].X ) / 2, ( FPts[1].Y + FPts[2].Y ) / 2 );
      RotPt := TransformPoint2d( FPts[1], Rotate2d( System.Pi / 2, MidPt ) );
      V2.Add( MidPt );
      V2.Add( RotPt );

      If Not VectIntersect( V1, V2, IntersV, false ) Then Exit;

      Center := IntersV[0];
      Radius := Dist2d( FPts[0], Center );
      FCircle.BeginUpdate;
      FCircle.Points[0] := Point2d( Center.X - Radius, Center.Y - Radius );
      FCircle.Points[1] := Point2d( Center.X + Radius, Center.Y + Radius );
      FCircle.EndUpdate;
    Finally
      V1.Free;
      V2.Free;
      IntersV.Free;
    End;
  End;
End;

Procedure TDrawCircleAction.MyMouseDown( Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer; Const WX, WY: Double );
Var
  CurrPoint: TEzPoint;
Begin
  If Button = mbRight Then Exit;
  With CmdLine Do
  Begin
    CurrPoint := CmdLine.GetSnappedPoint;
    with ActiveDrawBox do
      DrawCross( Canvas, Grapher.RealToPoint( CurrPoint ) );
    SetCurrentPoint( CurrPoint, UseOrto );

    { ** AccuDraw **}
    If FCurrentIndex = 0 Then
      AccuDraw.UpdatePosition( CurrPoint, CurrPoint )  // this activates AccuDraw
    Else If FCurrentIndex > 0 Then
      AccuDraw.UpdatePosition( FPts[FCurrentIndex], CurrPoint );

    If FCurrentIndex >= IndexLimit Then
    Begin
      All_DrawEntity2DRubberBand( FCircle);
      CreateCircle;
      if Assigned( Launcher ) then
      begin
        if Assigned( TEzActionLauncher( Launcher ).OnTrackedEntity ) then
          TEzActionLauncher( Launcher ).OnTrackedEntity( Launcher, Self.ActionID, FCircle );
        All_Invalidate;
      end else
        ActionAddNewEntity( CmdLine, FCircle );
      Self.Finished := true;
      Exit;
    End
    Else
      Inc( fCurrentIndex );
    SetAddActionCaption;
  End;
End;

Procedure TDrawCircleAction.SetAddActionCaption;
Begin
  Case fCurrentIndex Of
    0: Caption := SFirstPoint;
    1: Caption := SSecondPoint;
    2: Caption := SThirdPoint;
  Else
    Caption := '';
  End;
End;

Procedure TDrawCircleAction.MyMouseMove( Sender: TObject; Shift: TShiftState;
  X, Y: Integer; Const WX, WY: Double );
Var
  CurrPoint: TEzPoint;
  Radiusx: Double;
  nd: Integer;
Begin
  With CmdLine Do
  Begin
    If FCurrentIndex >= IndexLimit Then
      All_DrawEntity2DRubberBand( FCircle );
    CurrPoint := GetSnappedPoint;
    SetCurrentPoint( CurrPoint, UseOrto );
    If FCurrentIndex >= IndexLimit Then
    Begin
      CreateCircle;
      All_DrawEntity2DRubberBand( FCircle );
    End;
    If FCircle.Points.Count >= 2 Then
    Begin
      RadiusX:= Dist2d( FCircle.Points[0], Point2d( FCircle.Points[1].X, FCircle.Points[0].Y) ) / 2;
      //RadiusY:= Dist2d( FCircle.Points[0], Point2d( FCircle.Points[0].X, FCircle.Points[1].Y) ) / 2;
      nd:= ActiveDrawBox.NumDecimals;
      StatusMessage := Format( SCircleInfo, [ nd, RadiusX, nd, FCircle.Area, nd, FCircle.Perimeter ] );
    End;
  End;
End;

Procedure TDrawCircleAction.MyPaint( Sender: TObject );
Begin
  If FCurrentIndex >= IndexLimit Then
    (Sender as TEzBaseDrawBox).DrawEntity2DRubberBand( FCircle );
End;

Procedure TDrawCircleAction.MyKeyPress( Sender: TObject; Var Key: Char );
Begin
  If Key = #27 Then
    Self.FInished := true;
End;

procedure TDrawCircleAction.ContinueOperation(Sender: TObject);
begin
  If Assigned( FCircle ) Then
    CmdLine.All_DrawEntity2DRubberBand( FCircle );
end;

procedure TDrawCircleAction.SuspendOperation(Sender: TObject);
begin
  If Assigned( FCircle ) Then
    CmdLine.All_DrawEntity2DRubberBand( FCircle );
end;

{ TDrawArcAction }

Constructor TDrawArcAction.CreateAction( CmdLine: TEzCmdLine;
  Method: TDrawArcMethod = damCRS );
Var
  p: TEzPoint;
Begin
  Inherited CreateAction( CmdLine );

  FMethod:= Method;

  P := Point2d( 0, 0 );
  FCircle := TEzEllipse.CreateEntity( p, p );
  FArc:= TEzArc.CreateEntity( Point2d(0,0),Point2d(0,0),Point2d(0,0));

  FRadiusLines:= TEzPolyline.CreateEntity( [p,p] );

  FDefiningCircle:= true;
  FLastPoint:= INVALID_POINT;

  CanDoOsnap := True;
  CanDoAccuDraw:= True;
  MouseDrawElements:= [mdCursorFrame, mdFullViewCursor];
  CmdLine.AccuDraw.FrameStyle:= fsPolar;

  OnMouseDown := MyMouseDown;
  OnMouseMove := MyMouseMove;
  OnKeyPress := MyKeyPress;
  OnPaint := MyPaint;
  OnSuspendOperation := Self.SuspendOperation;
  OnContinueOperation := Self.ContinueOperation;

  Cursor := crDrawCross;
  WaitingMouseClick := True;
  SetAddActionCaption;
End;

Destructor TDrawArcAction.Destroy;
Begin
  { If not nil then the entity was not added to the file/symbol
    and we must delete it }
  if Assigned(FCircle) then FreeAndNil( FCircle );
  FreeAndNil( FArc );
  FreeAndNil( FRadiusLines );
  Inherited Destroy;
End;

Procedure TDrawArcAction.SetAddActionCaption;
Begin
  If FMethod = damCRS then
  begin
    Case fCurrentIndex Of
      0: Caption := SCircleCenter;
      1: Caption := SCircleRadius;
    Else
      Caption := '';
    End;
  end else
  begin
    Case fCurrentIndex Of
      0: Caption := SCircleEndPoint;
      1: Caption := SCircleCenter;
    Else
      Caption := '';
    End;
  end;
End;

procedure TDrawArcAction.DrawRubberCircle(Sender: TObject = Nil);
var
  OldPenStyle: TPenStyle;
  dbox: TEzBaseDrawbox;
begin
  If Not Assigned( FCircle ) then Exit;
  If Sender = Nil Then
    dbox:= CmdLine.ActiveDrawBox
  else
    dbox:= (Sender As TEzBaseDrawbox);
  with dbox do
  Begin
    OldPenStyle:= RubberPen.Style;
    RubberPen.Style:= psDot;
    If Sender = Nil then
    begin
      CmdLine.All_DrawEntity2DRubberBand( FCircle );
      CmdLine.All_DrawEntity2DRubberBand( FRadiusLines );
    end else
    begin
      DrawEntity2DRubberBand( FCircle );
      DrawEntity2DRubberBand( FRadiusLines );
    end;
    RubberPen.Style:= OldPenStyle;
  end;
end;

procedure TDrawArcAction.DrawRubberArc(Sender: TObject = Nil);
begin
  If Not Assigned( FArc ) then Exit;
  If Sender = Nil Then
    CmdLine.All_DrawEntity2DRubberBand( FArc )
  Else
    (Sender As TEzBaseDrawbox).DrawEntity2DRubberBand( FArc )
end;

procedure TDrawArcAction.ContinueOperation(Sender: TObject);
begin
  if FDefiningCircle then
    DrawRubberCircle
  else
    DrawRubberArc;
end;

procedure TDrawArcAction.SuspendOperation(Sender: TObject);
begin
  if FDefiningCircle then
    DrawRubberCircle
  else
    DrawRubberArc;
end;

Procedure TDrawArcAction.SetCurrentPoint( Pt: TEzPoint; Orto: Boolean );
Begin
  If Orto And ( FCurrentIndex > 0 ) Then
    Pt := ChangeToOrtogonal( FPts[FCurrentIndex - 1], Pt );
  FPts[FCurrentIndex] := Pt;

  FRadiusLines.Points[0]:= FPts[0];
  FRadiusLines.Points[1]:= Pt;
  If FCurrentIndex = 0 Then
    WaitingMouseClick := False;
End;

// create the circle through three points
Procedure TDrawArcAction.CreateCircle;
Var
  Radius: Double;
  Center: TEzPoint;
Begin
  If FCurrentIndex < 1 Then Exit;

  If FMethod = damCRS then
    Center := FPts[0]
  else
    Center := FPts[1];

  Radius := Dist2d( FPts[0], FPts[1] );

  FCircle.BeginUpdate;
  FCircle.Points[0] := Point2d( Center.X - Radius, Center.Y - Radius );
  FCircle.Points[1] := Point2d( Center.X + Radius, Center.Y + Radius );
  FCircle.EndUpdate;
End;

Procedure TDrawArcAction.MyMouseDown( Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer; Const WX, WY: Double );
Var
  CurrPoint, Center: TEzPoint;
  StartAng, EndAng, NumRads: double;
Begin
  With CmdLine Do
  Begin
    CurrPoint := GetSnappedPoint;
    with ActiveDrawBox do
      DrawCross( Canvas, Grapher.RealToPoint( CurrPoint ) );

    If FCurrentIndex=0 then
      AccuDraw.UpdatePosition(CurrPoint, CurrPoint);  // activate AccuDraw

    If FDefiningCircle then
    Begin
      SetCurrentPoint( CurrPoint, UseOrto );
      If FCurrentIndex >= 1 Then
      Begin
        DrawRubberCircle;
        FPts[1] := CurrPoint;
        If FMethod = damFCS Then
          AccuDraw.UpdatePosition(Fpts[1], FPts[0], True);
        FDefiningCircle := false;
        If FMethod = damCRS then
          Center:= FPts[0]
        Else
          Center:= FPts[1];
        TEzArc( FArc ).SetArc( Center.X, Center.Y, Dist2d( FPts[0], FPts[1] ),
            Angle2d(FPts[0],FPts[1]), 0, true );
        DrawRubberArc;
        Caption:= SArcSweepAngle;
      End
      Else
      begin
        Inc( FCurrentIndex );
        SetAddActionCaption;
      end;
    End Else
    Begin
      If FMethod = damCRS then
      begin
        StartAng:= Angle2d(FPts[0],FPts[1]);
        EndAng:= Angle2d(FPts[0],CurrPoint);
      end else
      begin
        StartAng:= Angle2d(FPts[1],FPts[0]);
        EndAng:= Angle2d(FPts[1],CurrPoint);
      end;

      If FIsCounterClockWise Then
      Begin
        If EndAng > StartAng Then
          NumRads:= EndAng - StartAng
        Else
          NumRads:= TwoPi - ( StartAng - EndAng );
      End Else
      Begin
        If EndAng > StartAng Then
          NumRads:= TwoPi - ( EndAng - StartAng )
        Else
          NumRads:= StartAng - EndAng;
      End;

      If FMethod = damCRS then
        Center:= FPts[0]
      Else
        Center:= FPts[1];
      TEzArc( FArc ).SetArc( Center.X, Center.Y, Dist2d( FPts[0], FPts[1] ),
          StartAng, Abs(NumRads), FIsCounterClockWise );

      DrawRubberArc;
      if Assigned( Launcher ) then
      begin
        if Assigned( TEzActionLauncher( Launcher ).OnTrackedEntity ) then
          TEzActionLauncher( Launcher ).OnTrackedEntity( Launcher, Self.ActionID, FArc );
        All_Invalidate;
      end else
        ActionAddNewEntity( CmdLine, FArc );
      Self.Finished:= true;
    End;
  End;
End;

Procedure TDrawArcAction.MyMouseMove( Sender: TObject; Shift: TShiftState;
  X, Y: Integer; Const WX, WY: Double );
Var
  CurrPoint,Center: TEzPoint;
  Radiusx,StartAng,EndAng,NumRads: Double;
  nd: integer;
Begin
  With CmdLine Do
  Begin
    If FCurrentIndex >= 1 Then
    begin
      if FDefiningCircle then
        DrawRubberCircle
      else
        DrawRubberArc;
    end;
    CurrPoint := GetSnappedPoint;
    If FDefiningCircle then
    begin
      SetCurrentPoint( CurrPoint, UseOrto );
      If FCurrentIndex >= 1 Then
      Begin
        CreateCircle;
        DrawRubberCircle;
      End;
      If FCircle.Points.Count >= 2 Then
      Begin
        RadiusX:= Dist2d( FCircle.Points[0], Point2d( FCircle.Points[1].X, FCircle.Points[0].Y) ) / 2;
        //RadiusY:= Dist2d( FCircle.Points[0], Point2d( FCircle.Points[0].X, FCircle.Points[1].Y) ) / 2;
        nd:= ActiveDrawBox.NumDecimals;
        StatusMessage := Format( SCircleInfo,
          [ nd, RadiusX, nd, FCircle.Area, nd, FCircle.Perimeter ] );
      End;
    End Else
    Begin
      If FMethod = damCRS then
        RadiusX:= Dist2d( FPts[0], Point2d( FPts[1].X, FPts[0].Y) ) / 2
      else
        RadiusX:= Dist2d( FPts[1], Point2d( FPts[0].X, FPts[1].Y) ) / 2;
      nd:= ActiveDrawBox.NumDecimals;
      StatusMessage := Format( SCircleInfo, [ nd, RadiusX, nd, 0.0,  nd, 0.0 ] );

      { calculate angles without snapping }
      If FMethod = damCRS then
      begin
        StartAng:= Angle2d(FPts[0],FPts[1]);
        EndAng:= Angle2d(FPts[0],CmdLine.CurrentPoint);
      end else
      begin
        StartAng:= Angle2d(FPts[1],FPts[0]);
        EndAng:= Angle2d(FPts[1],CmdLine.CurrentPoint);
      end;
      If StartAng < 0 Then StartAng := StartAng + TwoPi;
      If EndAng < 0 Then EndAng:= EndAng + TwoPi;
      NumRads:= EndAng - StartAng;

      If Abs(NumRads) <= DegToRad(10.0) Then
        FIsCounterClockWise := NumRads > 0;

      { recalculate the angle with the current snapped point }
      If FMethod = damCRS then
      begin
        StartAng:= Angle2d(FPts[0],FPts[1]);
        EndAng:= Angle2d(FPts[0],CurrPoint);
      end else
      begin
        StartAng:= Angle2d(FPts[1],FPts[0]);
        EndAng:= Angle2d(FPts[1],CurrPoint);
      end;

      If Abs(NumRads) >= DegToRad(1.0) Then
      begin
        If FIsCounterClockWise Then
        Begin
          If EndAng > StartAng Then
            NumRads:= EndAng - StartAng
          Else
            NumRads:= TwoPi - ( StartAng - EndAng );
        End Else
        Begin
          If EndAng > StartAng Then
            NumRads:= TwoPi - ( EndAng - StartAng )
          Else
            NumRads:= StartAng - EndAng;
        End;
      end;

      If FMethod = damCRS then
        Center:= FPts[0]
      Else
        Center:= FPts[1];
      TEzArc( FArc ).SetArc( Center.X, Center.Y, Dist2d( FPts[0], FPts[1] ),
          StartAng, Abs(NumRads), FIsCounterClockWise );
      DrawRubberArc;
    End;
  End;
End;

Procedure TDrawArcAction.MyPaint( Sender: TObject );
Begin
  If FDefiningCircle then
  begin
    If FCurrentIndex >= 1 Then
      DrawRubberCircle(Sender);
  end else
    DrawRubberArc(Sender);
End;

Procedure TDrawArcAction.MyKeyPress( Sender: TObject; Var Key: Char );
Begin
  If Key = #27 Then
    Self.FInished := true;
End;


{-------------------------------------------------------------------------------}
//                  TBufferSelectAction
{-------------------------------------------------------------------------------}

Constructor TBufferSelectAction.CreateAction( CmdLine: TEzCmdLine );
Begin
  Inherited CreateAction( CmdLine );

  CanBeSuspended := false;

  CanDoOsnap:= true;
  CanDoAccuDraw:= true;
  MouseDrawElements:= [mdCursorFrame, mdFullViewCursor];

  FLine := TEzPolyLine.CreateEntity( [Point2D( 0, 0 ), Point2D( 0, 0 )] );
  FPolygon := TEzPolygon.CreateEntity( [Point2D( 0, 0 )] );
  FPolyline := TEzPolyLine.CreateEntity( [Point2D( 0, 0 )] );

  OnMouseDown := MyMouseDown;
  OnMouseMove := MyMouseMove;
  OnKeyPress := MyKeyPress;
  OnPaint := MyPaint;
  OnSuspendOperation:= SuspendOperation;
  OnContinueOperation:= ContinueOperation;

  Cursor := crDrawCross;
  Caption := SReferenceFirstPoint;

End;

Destructor TBufferSelectAction.Destroy;
Begin
  if Assigned( FPolygon ) then FPolygon.Free;
  FPolyline.Free;
  FLine.Free;
  Inherited Destroy;
End;

Procedure TBufferSelectAction.SetCurrentPoint( Const Pt: TEzPoint );
Var
  I: Integer;
Begin
  If Not FReferenceDefined Then
  Begin
    FLine.Points[FCurrentIndex] := Pt;
    For I := FCurrentIndex + 1 To FLine.Points.Count - 1 Do
      FLine.Points[I] := Pt;
  End
  Else
  Begin
    FPolyline.Points[FCurrentIndex] := Pt;
    For I := FCurrentIndex + 1 To FPolyline.Points.Count - 1 Do
      FPolyline.Points[I] := Pt;
    CalcPolygon;
  End;
End;

Procedure TBufferSelectAction.DrawRubberEntityDotted(Entity: TEzEntity; Sender: TObject=Nil);
var
  Oldstyle: TPenstyle;
Begin
  with CmdLine.ActiveDrawBox do
  begin
    Oldstyle:=RubberPen.style;
    RubberPen.style:=psDot;
    If Sender = Nil Then
      CmdLine.All_DrawEntity2DRubberBand( Entity )
    Else
      (Sender as TEzBaseDrawBox).DrawEntity2DRubberBand( Entity );
    RubberPen.style:=Oldstyle;
  end;
End;

Procedure TBufferSelectAction.SuspendOperation( Sender: TObject );
begin
  If Not FReferenceDefined Then
  Begin
    If Assigned(FLine) Then
      DrawRubberEntityDotted(FLine);
  End Else
  Begin
    If Assigned(FPolyLine) Then
      DrawRubberEntityDotted(FPolyLine);
    If Assigned(FPolygon) And (FCurrentIndex > 1) Then
      CmdLine.All_DrawEntity2DRubberBand( FPolygon);
  End;
end;

Procedure TBufferSelectAction.ContinueOperation( Sender: TObject );
begin
  If Not FReferenceDefined Then
  Begin
    If Assigned(FLine) Then
      DrawRubberEntityDotted(FLine);
  End Else
  Begin
    If Assigned(FPolygon) And (FCurrentIndex > 1) Then
      CmdLine.All_DrawEntity2DRubberBand( FPolygon);
    If Assigned(FPolyLine) Then
      DrawRubberEntityDotted(FPolyLine);
  End;
end;

Procedure TBufferSelectAction.MyMouseDown( Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer; Const WX, WY: Double );
Var
  CurrPoint: TEzPoint;
  Key: Char;
Begin
  If Button = mbRight Then
  begin
    Key:= #13 ;
    MyKeyPress( Nil, Key );
    Exit;
  end;
  With CmdLine Do
  Begin
    CurrPoint := GetSnappedPoint;
    SetCurrentPoint( CurrPoint );
    Inc( FCurrentIndex );
    If Not FReferenceDefined Then
    Begin
      If FCurrentIndex = 0 Then
        AccuDraw.UpdatePosition( CurrPoint, CurrPoint )  // this activates AccuDraw
      Else If FCurrentIndex > 0 Then
      Begin
        AccuDraw.UpdatePosition( FLine.Points[FCurrentIndex-2], CurrPoint );
      End;
      If FCurrentIndex > 1 Then
      Begin
        FReferenceDefined := True;
        DrawRubberEntityDotted(FLine);
        FDistance := Dist2D( FLine.Points[0], FLine.Points[1] ) * 2;
        FPolyline.Points[0] := FLine.Points[0];
        FCurrentIndex := 1;
        SetCurrentPoint( CurrPoint );
        DrawRubberEntityDotted(FPolyLine);
        All_DrawEntity2DRubberBand( FPolygon);

        AccuDraw.UpdatePosition( FLine.Points[0], FLine.Points[0] );
        Caption := SDefineFromPoint;
      End
      Else
        Caption := SReferenceSecondPoint;
    End
    Else
    Begin
      AccuDraw.UpdatePosition( FPolyLine.Points[FCurrentIndex-2], CurrPoint );
      Caption := SDefineToPoint;
    End;
  End;
End;

Procedure TBufferSelectAction.MyMouseMove( Sender: TObject; Shift: TShiftState;
  X, Y: Integer; Const WX, WY: Double );
Var
  CurrPoint: TEzPoint;
Begin
  With CmdLine Do
  Begin
    If Not FReferenceDefined Then
      DrawRubberEntityDotted(FLine)
    Else
    Begin
      DrawRubberEntityDotted(FPolyLine);
      All_DrawEntity2DRubberBand( FPolygon )
    End;
    CurrPoint := GetSnappedPoint;
    SetCurrentPoint( CurrPoint );
    If Not FReferenceDefined Then
    begin
      DrawRubberEntityDotted(FLine);
      StatusMessage := Format( SBufferRefInfo, [ActiveDrawBox.NumDecimals, FLine.Perimeter] );

    End Else
    Begin
      DrawRubberEntityDotted(FPolyLine);
      All_DrawEntity2DRubberBand( FPolygon );
    End;
  End;
End;

Procedure TBufferSelectAction.MyPaint( Sender: TObject );
Begin
  If Not FReferenceDefined Then
  Begin
    If FLine <> Nil Then
      DrawRubberEntityDotted(FLine, Sender);
  End
  Else If ( FPolygon <> Nil ) And ( FPolyline <> Nil ) Then
    With CmdLine Do
    Begin
      DrawRubberEntityDotted(FPolyLine, Sender);
      (Sender As TEzBaseDrawBox).DrawEntity2DRubberBand( FPolygon );
    End;
End;

Procedure TBufferSelectAction.UndoOperation;
Var
  CurrPoint: TEzPoint;
Begin
  If Not FReferenceDefined Then exit;
  If FCurrentIndex = 0 Then exit;
  Dec( FCurrentIndex );
  With CmdLine Do
  Begin
    DrawRubberEntityDotted(FPolyLine);
    All_DrawEntity2DRubberBand( FPolygon );
    CurrPoint := GetSnappedPoint;
    SetCurrentPoint( CurrPoint );
    DrawRubberEntityDotted(FPolyLine);
    All_DrawEntity2DRubberBand( FPolygon );
  End;
  If FCurrentIndex = 0 Then
    Caption := SDefineFromPoint
  Else
    Caption := SDefineToPoint;
End;

Procedure TBufferSelectAction.MyKeyPress( Sender: TObject; Var Key: Char );
Begin
  With CmdLine Do
    If ( Key = #27 ) Then
    Begin
      Self.Finished := true;
      Exit;
    End
    Else If ( Key = #13 ) Then
    Begin
      If Not FReferenceDefined Then
      Begin
        Self.Finished := true;
        Exit;
      End;
      If FCurrentIndex < 2 Then
      Begin
        MessageToUser( SNotEnoughData, smsgerror, MB_ICONERROR );
        Exit;
      End;
      DrawRubberEntityDotted(FPolyLine);
      All_DrawEntity2DRubberBand( FPolygon );
      {Last point is not valid because is rubber banding}
      FPolyline.Points.Delete( FCurrentIndex );
      CalcPolygon;
      if Assigned( Launcher ) then
      begin
        if Assigned( TEzActionLauncher( Launcher ).OnTrackedEntity ) then
          TEzActionLauncher( Launcher ).OnTrackedEntity( Launcher, Self.ActionID, TEzEntity( FPolygon ) );
      end else
        { do the selection in the polygon }
        DoPolygonSelect( FPolygon, CmdLine );
      Self.Finished := true;
      Refresh;
      Key := #0;
      Exit;
    End;
End;

Procedure TBufferSelectAction.CalcPolygon;
Var
  cnt: integer;
Begin
  { Calc polygon based on Polyline FPolyline }

  If ( FDistance = 0 ) Or ( FCurrentIndex < 1 ) Then
  Begin
    FPolygon.Points.Clear;
    For cnt := 0 To FPolyline.Points.Count - 1 Do
      FPolygon.Points.Add( FPolyline.Points[cnt] );
    Exit;
  End;
  FPolygon.Free;
  FPolygon := TEzPolygon( ezsystem.CreateBufferFromEntity( TEzEntity( FPolyline ), 40, FDistance, True ) );

End;




{-------------------------------------------------------------------------------}
//                  TAddVectorialTextAction
{-------------------------------------------------------------------------------}

Constructor TAddVectorialTextAction.CreateAction( CmdLine: TEzCmdLine;
  VectorialText: TEzEntity; IsJustifiedText: Boolean;
  TextBorderStyle: TEzTextBorderStyle );
Begin
  Inherited CreateAction( CmdLine );
  { esto es asignado solo cuando FLauncher <> Nil }
  FVectorialText:= VectorialText;

  FIsJustifiedText := IsJustifiedText;
  FTextBorderStyle := TextBorderStyle;

  CanBeSuspended := True;
  CanDoOsnap := True;
  CanDoAccuDraw:= True;
  MouseDrawElements:= [mdCursorFrame, mdFullViewCursor];

  FFrame := TEzRectangle.CreateEntity( INVALID_POINT, INVALID_POINT );

  OnMouseDown := MyMouseDown;
  OnMouseUp := MyMouseUp;
  OnMouseMove := MyMouseMove;
  OnPaint := MyPaint;
  OnKeyPress := MyKeyPress;
  OnSuspendOperation := Self.SuspendOperation;
  OnContinueOperation := Self.ContinueOperation;

  WaitingMouseClick := True;

  Cursor:= crDrawCross;

  Caption := SVectorialFirstPt;
End;

Destructor TAddVectorialTextAction.Destroy;
Begin
  FFrame.Free;
  Caption := '';
  if Assigned( FVectorialText ) then
    FVectorialText:= Nil;
  Inherited Destroy;
End;

procedure TAddVectorialTextAction.SuspendOperation(Sender: TObject);
begin
  If Assigned( FFrame ) And Not EqualPoint2d(FFrame.Points[0],INVALID_POINT) Then
    CmdLine.All_DrawEntity2DRubberBand( FFrame );
end;

procedure TAddVectorialTextAction.ContinueOperation(Sender: TObject);
begin
  If Assigned( FFrame ) And Not EqualPoint2d(FFrame.Points[0],INVALID_POINT) Then
    CmdLine.All_DrawEntity2DRubberBand( FFrame );
end;

Procedure TAddVectorialTextAction.DoAddTheText;
Var
  Box: TEzRect;
  TextHeight, TextWidth: Double;
  AText: String;
  Ent: TEzEntity;
  InsPoint, PivotPoint: TEzPoint;
Begin
  Box.Emin := FFrame.Points[0];
  Box.Emax := FFrame.Points[1];
  Box := ReorderRect2D( Box );
  InsPoint := Point2D( Box.Emin.X, Box.Emax.Y );
  TextHeight := Dist2D( Box.Emin, InsPoint );
  TextWidth := Dist2D( Box.Emin, Point2D( Box.Emax.X, Box.Emin.Y ) );
  PivotPoint := Point2d( ( Box.Emin.X + Box.Emax.X ) / 2,
                         ( Box.Emin.Y + Box.Emax.Y ) / 2 - TextHeight / 4 );

  if Assigned( Launcher ) then
  begin
    if FVectorialText is TEzFittedVectorText then
    begin
      with TEzFittedVectorText( FVectorialText ) do
      begin
        Height:= TextHeight;
        Width := TextWidth;
        Pivot := PivotPoint;
      end;
    end else if FVectorialText is TEzJustifVectorText then
    begin
      TEzJustifVectorText( FVectorialText ).TextBox:= Box;
    end;
    if Assigned( TEzActionLauncher( Launcher ).OnTrackedEntity ) then
      TEzActionLauncher( Launcher ).OnTrackedEntity( Launcher, Self.ActionID, FVectorialText );
    Finished := True;
    Exit;
  end;

  { edit in a dialog box the parameters }
  With TfrmVectorialText.Create( Nil ) Do
  Try
    If Not FIsJustifiedText Then
    Begin
      rgb1.Enabled := false;
      rgb2.Enabled := false;
      Numed1.Enabled := false;
      Numed3.Enabled := false;
    End
    Else
      With CmdLine.ActiveDrawBox Do
      Begin
        NumEd3.Text := Floattostr( Grapher.GetRealSize( Ez_Preferences.DefFontStyle.Height ) );
      End;
    If Not ( ShowModal = mrOk ) Then Exit;
    { calculate the text height }
    AText := Memo1.Lines.Text;
    If Length( AText ) = 0 Then  exit;
    If Not FIsJustifiedText Then
    Begin
      If Length( AText ) = 0 Then  exit;
      Ent := TEzFittedVectorText.CreateEntity( InsPoint, AText, TextHeight, TextWidth, 0 );
      With TEzFittedVectorText( ent ) Do
      Begin
        InterLineSpacing := Strtofloat( NumEd1.Text );
        InterCharSpacing := Strtofloat( NumEd2.Text );
        TextBorderStyle := self.FTextBorderStyle;
        Pivot := Point2d( ( Points[0].X + Points[2].X ) / 2,
                          ( Points[0].Y + Points[2].Y ) / 2 - TextHeight / 4 );
      End;
    End
    Else
    Begin
      { calculate number of lines }
      TextHeight := Strtofloat( Numed3.Text );
      Ent := TEzJustifVectorText.CreateEntity( Box, TextHeight, AText );
      With TEzJustifVectorText( ent ) Do
      Begin
        InterLineSpacing := Strtofloat( NumEd1.Text );
        InterCharSpacing := Strtofloat( NumEd2.Text );
        HorzAlignment := TEzHorzAlignment( rgb1.ItemIndex );
        VertAlignment := TEzVertAlignment( rgb2.ItemIndex );
      End;
    End;
    ActionAddNewEntity( CmdLine, Ent );
    Finished := True;
  Finally
    free;
  End;
End;

Procedure TAddVectorialTextAction.MyKeyPress( Sender: TObject; Var Key: Char );
Begin
  if EqualPoint2d(FFrame.Points[0],INVALID_POINT) Then
  begin
    If Key In [#13,#27] Then Self.Finished := true;
    exit;
  end;
  With CmdLine Do
    If Key = #27 Then
    Begin
      {cancels the zooming}
      All_DrawEntity2DRubberBand( FFrame );
      Self.Finished := true;
    End
    Else If Key = #13 Then
    Begin
      All_DrawEntity2DRubberBand( FFrame );
      DoAddTheText;
      Self.Finished := true;
      Key := #0;
      Exit;
    End;
End;

Procedure TAddVectorialTextAction.MyMouseDown( Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer; Const WX, WY: Double );
Var
  CurrPoint: TEzPoint;
Begin
  If Button = mbRight Then Exit;
  With CmdLine Do
  Begin
    CurrPoint := GetSnappedPoint;
    SetCurrentPoint( CurrPoint );
    If FCurrentIndex = 0 Then
    begin
      FOrigin := Point( X, Y );
      AccuDraw.UpdatePosition( CurrPoint, CurrPoint );
    end;
    If FCurrentIndex >= 1 Then
    Begin
      DoAddTheText;
      Exit;
    End;
    Inc( FCurrentIndex );
    If FCurrentIndex > 0 Then
      Caption := SVectorialSecondPt;
    All_DrawEntity2DRubberBand( FFrame );
  End;
End;

Procedure TAddVectorialTextAction.MyMouseMove( Sender: TObject;
  Shift: TShiftState; X, Y: Integer; Const WX, WY: Double );
Var
  CurrPoint: TEzPoint;
Begin
  With CmdLine Do
  Begin
    If not EqualPoint2d(FFrame.Points[0],INVALID_POINT) then
      All_DrawEntity2DRubberBand( FFrame );
    CurrPoint := GetSnappedPoint;
    SetCurrentPoint( CurrPoint );
    All_DrawEntity2DRubberBand( FFrame );
  End;
End;

Procedure TAddVectorialTextAction.MyMouseUp( Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer; Const WX, WY: Double );
Var
  Pt: TPoint;
Begin
  Pt := Point( X, Y );
  If ( Abs( Pt.X - FOrigin.X ) > 5 ) And ( Abs( Pt.Y - FOrigin.Y ) > 5 ) Then
  Begin
    DoAddTheText;
    Exit;
  End;
End;

Procedure TAddVectorialTextAction.MyPaint( Sender: TObject );
Begin
  If (FFrame <> Nil) and not EqualPoint2d(FFrame.Points[0],INVALID_POINT) Then
    (Sender As TEzBaseDrawBox).DrawEntity2DRubberBand( FFrame );
End;

Procedure TAddVectorialTextAction.SetCurrentPoint( Const Pt: TEzPoint );
Var
  I: Integer;
Begin
  FFrame.Points[FCurrentIndex] := Pt;
  For I := FCurrentIndex + 1 To FFrame.Points.Count - 1 Do
    FFrame.Points[I] := Pt;
  If FCurrentIndex = 0 Then
    WaitingMouseClick := False;
End;


{ TDimAction }

Constructor TDimAction.CreateAction( CmdLine: TEzCmdLine; DimEnt: TEzEntity );
Var
  p: TEzPoint;
Begin
  Inherited CreateAction( CmdLine );
  p := Point2d( 0, 0 );
  FAuxLine := TEzPolyLine.CreateEntity( [p, p] );

  FDimEnt := DimEnt;

  CanDoOsnap := True;
  MouseDrawElements:= [mdCursorFrame, mdFullViewCursor];

  OnKeyPress := MyKeyPress;
  OnMouseDown := MyMouseDown;
  OnMouseMove := MyMouseMove;
  OnPaint := MyPaint;
  OnSuspendOperation := Self.SuspendOperation;
  OnContinueOperation := Self.ContinueOperation;

  Caption := SFirstExtensionLine;

  Cursor := crDrawCross;
End;

Destructor TDimAction.Destroy;
Begin
  FAuxLine.free;
  if Assigned( FDimEnt) then FDimEnt.free;
  Inherited Destroy;
End;

procedure TDimAction.ContinueOperation(Sender: TObject);
begin
  DrawEntitiesWithRubber( Point2d( 0, 0 ), false );
end;

procedure TDimAction.SuspendOperation(Sender: TObject);
begin
  DrawEntitiesWithRubber( Point2d( 0, 0 ), false );
end;

Procedure TDimAction.MyKeyPress( Sender: TObject; Var Key: Char );
Begin
  With CmdLine.ActiveDrawBox Do
    If Key In [#27] Then
    Begin
      DrawEntitiesWithRubber( Point2d( 0, 0 ), false );
      Self.Finished := true;
      Key := #0;
    End;
End;

Procedure TDimAction.SetCurrentPoint( Pt: TEzPoint );
Begin
  If CmdLine.UseOrto And ( FCurrentIndex > 0 ) Then
    Pt := ChangeToOrtogonal( FAuxLine.Points[FCurrentIndex - 1], Pt );
  FAuxLine.Points[FCurrentIndex] := Pt;
  If FCurrentIndex = 0 Then
    FAuxLine.Points[1] := Pt;
  If FCurrentIndex = 0 Then
    WaitingMouseClick := False;
End;

Procedure TDimAction.MyMouseDown( Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer; Const WX, WY: Double );
Var
  CurrPoint: TEzPoint;
Begin
  If Button = mbRight Then  Exit;
  With CmdLine Do
  Begin
    CurrPoint := GetSnappedPoint;
    with ActiveDrawbox do
      DrawCross( Canvas, Grapher.RealToPoint( CurrPoint ) );
    Case FDimStatus Of
      dsDefineLineLocation:
        Begin
          SetCurrentPoint( CurrPoint );
          Inc( FCurrentIndex );
          If FCurrentIndex > 1 Then
          Begin
            Caption := SDefineTextLocation;
            DrawEntitiesWithRubber( CurrPoint, false );
            FDimStatus := dsDefineTextLocation;
            Invalidate;
          End
          Else
          Begin
            If FCurrentIndex = 0 Then
              Caption := SFirstExtensionLine
            Else
              Caption := SSecondExtensionLine;
          End;
        End;
      dsDefineTextLocation:
        Begin
          // accept it
          DrawEntitiesWithRubber( CurrPoint, true );
          if Assigned( Launcher ) then
          begin
            if Assigned( TEzActionLauncher( Launcher ).OnTrackedEntity ) then
              TEzActionLauncher( Launcher ).OnTrackedEntity( Launcher, Self.ActionID, FDimEnt );
          end else
            { add the dimension entity }
            ActiveDrawBox.AddEntity( ActiveDrawBox.GIS.CurrentLayerName, FDimEnt );
          Finished := true;
          Repaint;
        End;
    End;
  End;
End;

Procedure TDimAction.DrawEntitiesWithRubber( Const Pt: TEzPoint;
  Calculate: Boolean; Sender: TObject=Nil );
Var
  vTextHeight, phi: Double;
  temp, basePt, rotPt: TEzPoint;
Begin
  { draw the text location line }
  If Not Assigned( FAuxLine ) Then Exit;
  If FDimStatus = dsDefineLineLocation Then
  Begin
    If Sender= Nil Then
      CmdLine.All_DrawEntity2DRubberBand( FAuxLine )
    Else
      (Sender As TEzBaseDrawBox).DrawEntity2DRubberBand( FAuxLine )
  End
  Else If FDimStatus = dsDefineTextLocation Then
  Begin
    If Calculate Then
    Begin
      With CmdLine.ActiveDrawBox Do
        vTextHeight := Grapher.GetRealSize( Ez_Preferences.DefFontStyle.Height );

      If FAuxLine.Points[1].X > FAuxLine.Points[0].X Then
      Begin
        FAuxLine.Points.DisableEvents := true;
        temp := FAuxLine.Points[0];
        FAuxLine.Points[0] := FAuxLine.Points[1];
        FAuxLine.Points[1] := temp;
        FAuxLine.Points.DisableEvents := false;
      End;
      FDimEnt.BeginUpdate;
      Try
        If FDimEnt Is TEzDimHorizontal Then
        Begin
          With TEzDimHorizontal( FDimEnt ) Do
          Begin
            BaseLineFrom := FAuxLine.Points[0];
            BaseLineTo := FAuxLine.Points[1];
            TextHeight := vTextHeight;
            TextLineY := Pt.Y;
            TextBasePoint := Point2d( MAXCOORD, MAXCOORD ); // force to calculate
          End;
        End
        Else If FDimEnt Is TEzDimVertical Then
        Begin
          With TEzDimVertical( FDimEnt ) Do
          Begin
            BaseLineFrom := FAuxLine.Points[0];
            BaseLineTo := FAuxLine.Points[1];
            TextHeight := TextHeight;
            TextLineX := Pt.X;
            TextBasePoint := Point2d( MAXCOORD, MAXCOORD ); // force to calculate
          End;
        End
        Else If FDimEnt Is TEzDimParallel Then
        Begin
          With TEzDimParallel( FDimEnt ) Do
          Begin
            BaseLineFrom := FAuxLine.Points[0];
            BaseLineTo := FAuxLine.Points[1];
            TextHeight := TextHeight;
            { is the point Pt above or below FAuxLine ? }
            phi := Angle2d( FAuxLine.Points[0], FAuxLine.Points[1] );
            basePt := FAuxLine.Points[0];
            rotPt := TransformPoint2d( Pt, Rotate2d( -phi, basePt ) );
            TextLineDistanceApart := BaseLineFrom.Y - rotPt.Y;
            TextBasePoint := Point2d( MAXCOORD, MAXCOORD ); // force to calculate
          End;
        End;
      Finally
        FDimEnt.EndUpdate;
      End;
    End;
    If Sender= Nil Then
    Begin
      With CmdLine Do
      Begin
        All_DrawEntity2DRubberBand( FAuxLine );
        All_DrawEntity2DRubberBand( FDimEnt );
      End;
    End Else With (Sender As TEzBaseDrawBox) DO
    Begin
        DrawEntity2DRubberBand( FAuxLine );
        DrawEntity2DRubberBand( FDimEnt );
    End;
  End;
End;

Procedure TDimAction.MyMouseMove( Sender: TObject;
  Shift: TShiftState; X, Y: Integer; Const WX, WY: Double );
Var
  CurrPoint: TEzPoint;
Begin
  DrawEntitiesWithRubber( CurrPoint, false );
  CurrPoint := CmdLine.GetSnappedPoint;
  If FDimStatus = dsDefineLineLocation Then
  Begin
    SetCurrentPoint( CurrPoint );
  End;
  DrawEntitiesWithRubber( CurrPoint, true );
End;

Procedure TDimAction.MyPaint( Sender: TObject );
Begin
  DrawEntitiesWithRubber( CmdLine.CurrentPoint, false, Sender );
End;



{-------------------------------------------------------------------------------}
//                  TEntityClickAction
{-------------------------------------------------------------------------------}

Constructor TEntityClickAction.CreateAction( CmdLine: TEzCmdLine;
  LayerName: string );
Begin
  Inherited CreateAction( CmdLine );

  FSearchLayerName:= LayerName;

  CmdLine.ActiveDrawBox.Selection.Clear;
  MouseDrawElements:= [mdCursor,mdCursorFrame];

  if CmdLine.ActiveDrawBox.Enabled then
    Windows.SetFocus(CmdLine.ActiveDrawBox.Handle);

  OnKeyPress := MyKeyPress;
  OnMouseDown := MyMouseDown;
  OnPaint:= MyPaint;
  OnSuspendOperation := Self.SuspendOperation;
  OnContinueOperation := Self.MyPaint;

  FHighlightClicked:= True;

  Caption := SEntityClickCaption;
  Cursor := crHelp;
End;

Destructor TEntityClickAction.Destroy;
Begin
  HiliteClickedEntity(False);
  If FStackedSelList <> Nil Then
    FStackedSelList.Free;
  //CmdLine.ActiveDrawBox.Invalidate;
  Inherited Destroy;
End;

Procedure TEntityClickAction.SuspendOperation;
Begin
  HiliteClickedEntity(False);
End;

Procedure TEntityClickAction.MyPaint( Sender: TObject);
Begin
  HiliteClickedEntity(True);
End;

Procedure TEntityClickAction.MyKeyPress( Sender: TObject; Var Key: Char );
Begin
  If Key In [#13, #27] Then
  Begin
    Self.Finished := true;
    Key := #0;
  End;
End;

Procedure TEntityClickAction.HiliteClickedEntity(Hilite: Boolean);
Var
  Entity: TEzEntity;
Begin
  If Not FHighlightClicked Or (FLayer=Nil) then Exit;
  Entity := FLayer.LoadEntityWithRecNo( FRecNo );
  If Entity = Nil Then Exit;
  Try
    If Hilite Then
      EzSystem.HiliteEntity(Entity, CmdLine.ActiveDrawBox)
    Else
      EzSystem.UnHiliteEntity(Entity, CmdLine.ActiveDrawBox);
  Finally
    Entity.Free;
  End;
End;

Procedure TEntityClickAction.MyMouseDown( Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer; Const WX, WY: Double );
Var
  CurrPoint: TEzPoint;
  Picked: Boolean;
  PickedPoint, TmpRecno: Integer;
  TmpLayer: TEzBaseLayer;
  FAperture: Byte;
  I, N: Integer;
  Found, Accept: Boolean;
Begin
  HiliteClickedEntity(False);
  With CmdLine.ActiveDrawBox Do
  Begin
    CurrPoint := CmdLine.CurrentPoint;
    FAperture := Ez_Preferences.ApertureWidth;
    If StackedSelect Then
    Begin
      If FStackedSelList = Nil Then
        FStackedSelList := TStringList.Create
      Else
        FStackedSelList.Clear;
    End
    Else
    Begin
      If FStackedSelList <> Nil Then
        FreeAndNil( FStackedSelList );
    End;
    Picked := PickEntity( CurrPoint.X,
                          CurrPoint.Y,
                          FAperture,
                          FSearchLayerName,
                          TmpLayer,
                          TmpRecNo,
                          PickedPoint,
                          FStackedSelList );
    If Picked Then
    Begin
      If ( FStackedSelList <> Nil ) And ( FStackedSelList.Count > 1 ) Then
      Begin
        If FLayer = Nil Then
        Begin
          FLayer := GIS.Layers.LayerByName( FStackedSelList[0] );
          FRecno := Longint( FStackedSelList.Objects[0] );
        End
        Else
        Begin
          Found:= False;
          For I := 0 To FStackedSelList.Count - 1 Do
          Begin
            If ( FLayer = GIS.Layers.LayerByName( FStackedSelList[I] ) ) And
              ( FRecno = Longint( FStackedSelList.Objects[I] ) ) Then
            Begin
              If I < FStackedSelList.Count - 1 Then
                N := I + 1
              Else
                N := 0;
              FLayer := GIS.Layers.LayerByName( FStackedSelList[N] );
              FRecno := Longint( FStackedSelList.Objects[N] );
              Found:= True;
              Break;
            End;
          End;
          if not Found then
          begin
            FLayer:= TmpLayer;
            FRecno:= TmpRecno;
          end;
        End;
      End
      Else
      Begin
        FLayer := TmpLayer;
        FRecno := TmpRecno;
      End;

      FLayer.RecNo := FRecno;

      Accept:= True;

      if Assigned( TEzActionLauncher( Launcher ).OnTrackedEntityClick ) then
        TEzActionLauncher( Launcher ).OnTrackedEntityClick( Launcher, Self.ActionID,
          Button, Shift, X, Y, WX, WY, FLayer, FRecno, Accept );

      If Accept Then
        { highligh on DrawBox the clicked entity }
        HiliteClickedEntity( True )
      Else
        FLayer:= Nil;
    End
    Else
    Begin
      Accept:= False;
      if Assigned( TEzActionLauncher( Launcher ).OnTrackedEntityClick ) then
        TEzActionLauncher( Launcher ).OnTrackedEntityClick( Launcher, Self.ActionID,
          Button, Shift, X, Y, WX, WY, Nil, 0, Accept );
      FLayer:= Nil;
    End;
  End;
End;



{-------------------------------------------------------------------------------}
//                  TMouseMoveAction
{-------------------------------------------------------------------------------}

Constructor TMouseMoveAction.CreateAction( CmdLine: TEzCmdLine;
  Const LayerName: string );
Begin
  Inherited CreateAction( CmdLine );

  FSearchLayerName:= LayerName;

  MouseDrawElements:= [mdCursor, mdCursorFrame];

  OnMouseMove:= MyMouseMove;
  OnKeyPress := MyKeyPress;
  OnPaint:= Self.MyPaint;
  OnSuspendOperation := Self.SuspendOperation;
  OnContinueOperation := Self.ContinueOperation;

  Cursor:= crHandPoint;

  Caption := SShowHintCaption;

End;

Destructor TMouseMoveAction.Destroy;
Begin
  HiliteDetectedEntity(False);
  Inherited Destroy;
End;

Procedure TMouseMoveAction.MyPaint( Sender: TObject );
Begin
  HiliteDetectedEntity(True);
End;

Procedure TMouseMoveAction.SuspendOperation( Sender: TObject );
Begin
  HiliteDetectedEntity(False);
End;

Procedure TMouseMoveAction.ContinueOperation( Sender: TObject );
Begin
  HiliteDetectedEntity(True);
End;

Procedure TMouseMoveAction.HiliteDetectedEntity(Hilite: Boolean);
Var
  Entity: TEzEntity;
Begin
  If Not FHighlightDetected Or (FLastLayer=Nil) then Exit;
  Entity := FLastLayer.LoadEntityWithRecNo( FLastRecNo );
  If Entity = Nil Then Exit;
  Try
    If Hilite Then
      EzSystem.HiliteEntity(Entity, CmdLine.ActiveDrawBox)
    Else
      EzSystem.UnHiliteEntity(Entity, CmdLine.ActiveDrawBox);
  Finally
    Entity.Free;
  End;
End;

Procedure TMouseMoveAction.MyMouseMove( Sender: TObject; Shift: TShiftState;
  X, Y: Integer; Const WX, WY: Double );
Var
  tmpRecNo: Integer;
  fPickedPoint: Integer;
  Picked, Accept: Boolean;
  CurrPoint: TEzPoint;
  Layer: TEzBaseLayer;
Begin
  If FInMouseMove Then Exit;
  FInMouseMove:= True;
  Try
    CurrPoint := CmdLine.CurrentPoint;
    With CmdLine.ActiveDrawBox Do
    Begin
      Picked := PickEntity( CurrPoint.X, CurrPoint.Y, 4, FSearchLayername, Layer,
        tmpRecNo, fPickedPoint, Nil );
      If Picked Then
      Begin
        If ( Layer = fLastLayer ) And ( TmpRecno = FLastRecno ) Then Exit;
        HiliteDetectedEntity(false);
        FLastLayer := Layer;
        FLastRecno := TmpRecno;
        Accept:= True;

        if Assigned( Launcher ) And Assigned( TEzActionLauncher( Launcher ).OnTrackedEntityMouseMove) then
          TEzActionLauncher( Launcher ).OnTrackedEntityMouseMove( Launcher, Self.ActionID,
            FLastLayer, FLastRecno, Accept );

        If Accept Then
          HiliteDetectedEntity(true)
        Else
          FLastLayer := Nil;
      End
      Else
      Begin
        HiliteDetectedEntity(False);
        FLastLayer := Nil;
        FLastRecno := 0;
        Accept:= False;
        if Assigned( Launcher ) And Assigned( TEzActionLauncher( Launcher ).OnTrackedEntityMouseMove) then
          TEzActionLauncher( Launcher ).OnTrackedEntityMouseMove( Launcher, Self.ActionID,
            Nil, 0, Accept );
      End;
    End;
  Finally
    FInMouseMove:= False;
  End;
End;

Procedure TMouseMoveAction.MyKeyPress( Sender: TObject; Var Key: Char );
Begin
  If Key In [#13, #27] Then
  Begin
    Self.Finished := true;
    Exit;
  End;
End;

{ TGenericAction }

constructor TGenericAction.CreateAction(CmdLine: TEzCmdLine; L: TEzActionLauncher);
begin
  inherited CreateAction( CmdLine );
  Launcher:= L;

  OnMouseDown         := MyMouseDown;
  OnMouseMove         := MyMouseMove;
  OnMouseUp           := MyMouseUp;
  OnPaint             := MyPaint;
  OnClick             := MyOnClick;
  OnDblClick          := MyDblClick;
  OnKeyDown           := MyOnKeyDown;
  OnKeyPress          := MyKeyPress;
  OnKeyUp             := MyOnKeyUp;
  OnActionDoCommand   := MyActionDoCommand;
  OnSuspendOperation  := MySuspendOperation;
  OnContinueOperation := MyContinueOperation;
  OnUndo              := MyUndo;
  OnInitialize        := MyInitialize ;

end;

procedure TGenericAction.MyActionDoCommand( Sender: TObject );
begin
  with TEzActionLauncher( Launcher ) do
  begin
    if Assigned( OnActionDoCommand ) then
      OnActionDoCommand( Sender );
    If Finished then
      Self.Finished:=true;
  end;
end;

procedure TGenericAction.MyContinueOperation(Sender: TObject);
begin
  with TEzActionLauncher( Launcher ) do
  begin
    if Assigned( OnContinueOperation ) then
      OnContinueOperation( Sender );
    If Finished then
      Self.Finished:= True;
  end;
end;

procedure TGenericAction.MyDblClick(Sender: TObject);
begin
  with TEzActionLauncher( Launcher ) do
  begin
    if Assigned( OnDblClick ) then
      OnDblClick( Sender );
    If Finished then
      Self.Finished:= True;
  end;
end;

procedure TGenericAction.MyInitialize(Sender: TObject);
begin
  with TEzActionLauncher( Launcher ) do
  begin
    if Assigned( OnInitialize ) then
      OnInitialize( Sender );
    If Finished then
      Self.Finished:= True;
  end;
end;

procedure TGenericAction.MyKeyPress(Sender: TObject; var Key: Char);
begin
  with TEzActionLauncher( Launcher ) do
  begin
    if Assigned( OnKeyPress ) then
      OnKeyPress( Sender, Key );
    If Finished then
      Self.Finished:= True;
  end;
end;

procedure TGenericAction.MyMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer; const WX, WY: Double);
begin
  with TEzActionLauncher( Launcher ) do
  begin
    if Assigned( OnMouseDown ) then
      OnMouseDown( Sender, Button, Shift, X, Y, WX, WY );
    If Finished then
      Self.Finished:= True;
  end;
end;

procedure TGenericAction.MyMouseMove(Sender: TObject; Shift: TShiftState;
  X, Y: Integer; const WX, WY: Double);
begin
  with TEzActionLauncher( Launcher ) do
  begin
    if Assigned( OnMouseMove ) then
      OnMouseMove( Sender, Shift, X, Y, WX, WY );
    If Finished then
      Self.Finished:= True;
  end;
end;

procedure TGenericAction.MyMouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer; const WX, WY: Double);
begin
  with TEzActionLauncher( Launcher ) do
  begin
    if Assigned( OnMouseUp ) then
      OnMouseUp( Sender, Button, Shift, X, Y, WX, WY );
    If Finished then
      Self.Finished:= True;
  end;
end;

procedure TGenericAction.MyOnClick(Sender: TObject);
begin
  with TEzActionLauncher( Launcher ) do
  begin
    if Assigned( OnClick ) then
      OnClick( Sender );
    If Finished then
      Self.Finished:= True;
  end;
end;

procedure TGenericAction.MyOnKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  with TEzActionLauncher( Launcher ) do
  begin
    if Assigned( OnKeyDown ) then
      OnKeyDown( Sender, Key, Shift );
    If Finished then
      Self.Finished:= True;
  end;
end;

procedure TGenericAction.MyOnKeyUp(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  with TEzActionLauncher( Launcher ) do
  begin
    if Assigned( OnKeyUp ) then
      OnKeyUp( Sender, Key, Shift );
    If Finished then
      Self.Finished:= True;
  end;
end;

procedure TGenericAction.MyPaint(Sender: TObject);
begin
  with TEzActionLauncher( Launcher ) do
  begin
    if Assigned( OnPaint ) then
      OnPaint( Sender );
    If Finished then
      Self.Finished:= True;
  end;
end;

procedure TGenericAction.MySuspendOperation(Sender: TObject);
begin
  with TEzActionLauncher( Launcher ) do
  begin
    if Assigned( OnSuspendOperation ) then
      OnSuspendOperation( Sender );
    If Finished then
      Self.Finished:= True;
  end;
end;

procedure TGenericAction.MyUndo(Sender: TObject);
begin
  with TEzActionLauncher( Launcher ) do
  begin
    if Assigned( OnUndo ) then
      OnUndo( Sender );
    If Finished then
      Self.Finished:= True;
  end;
end;


{-------------------------------------------------------------------------------}
//                  TDragDropAction
{-------------------------------------------------------------------------------}

Constructor TDragDropAction.CreateAction( CmdLine: TEzCmdLine; Aperture: Integer );
var
  p: TEzPoint;
Begin
  Inherited CreateAction( CmdLine );

  MouseDrawElements:= [mdCursorFrame, mdFullViewCursor];

  p:= INVALID_POINT;
  FLineTransform:= TEzPolyline.CreateEntity([p,p]);
  {Clear the selection if there is}
  With CmdLine.ActiveDrawBox Do
  Begin
    If Selection.Count > 0 Then
    Begin
      Selection.Clear;
      Repaint;
    End;
  End;

  FAperture := Aperture;
  FCurrentIndex := -1;
  FCurrentRecno := -1;

  OnMouseDown := MyMouseDown;
  OnMouseMove := MyMouseMove;
  OnKeyPress := MyKeyPress;
  OnPaint := MyPaint;

  Cursor := crDrawCross;
  Caption := SEntityToDrag;
End;

Destructor TDragDropAction.Destroy;
Begin
  FReshaping := false;
  if CmdLine.ActiveDrawBox <> nil then
    CmdLine.ActiveDrawBox.Invalidate;
  If FStackedSelList <> Nil Then
    FStackedSelList.Free;
  FLineTransform.Free;
  Inherited Destroy;
End;

Function TDragDropAction.MyOwnPointCode( Ent: TEzEntity;
  Const Pt: TEzPoint; Const Aperture: Double; Var Distance: Double;
  SelectPickingInside: Boolean ): Integer;
Var
  I: integer;
  MinDist: Double;
  ControlPts: TEzVector;
Begin
  { PICKED_NONE     - not on entity
    PICKED_INTERIOR - point inside entity
    PICKED_POINT    - point on any segment
    > = 0           - point on that entity point }
  Result := PICKED_NONE;
  MinDist := Aperture + 1.0;
  ControlPts := Ent.GetControlPoints(True,CmdLine.ActiveDrawBox.Grapher);
  Try
    For I := 0 To ControlPts.Count - 1 Do
    Begin
      If Ent.GetControlPointType( I ) = cptMove Then
      Begin
        If IsNearPoint2D( Pt,
          TransformPoint2D( ControlPts[I], Ent.GetTransformMatrix ),
          Aperture, Distance ) And ( Distance < MinDist ) Then
        Begin
          Result := I;
          FLineTransform.Points[0]:= ControlPts[I];
          FLineTransform.Points[1]:= ControlPts[I];
        End;
        Break;
      End;
    End;
  Finally
    If Ent.Points <> ControlPts Then
      ControlPts.Free;
  End;
End;

Procedure TDragDropAction.MyMouseDown( Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer;
  Const WX, WY: Double );
Var
  CurrPoint: TEzPoint;
  TmpLayer: TEzBaseLayer;
  I, N, TmpRecNo, Aperture, PickedPoint: Integer;
  Picked: Boolean;
  TmpEnt: TEzEntity;
  MinDist, Distance: Double;
  RealAperture: TEzPoint;
  Found: Boolean;
  db: TEzBaseDrawBox;

  Procedure SetCurrentVertex;
  Begin
    If PickedPoint >= 0 Then
    Begin
      FCurrentIndex := PickedPoint;
      FReshaping := true;
      CanDoOsnap := True;
      Caption := SReshapeToPoint;
    End
    Else
    Begin
      FCurrentIndex := -1;
      FReshaping := false;
      Caption := SDragFromCtrlPt;
    End;
  End;

Begin
  If Button = mbRight Then Exit;
  db := CmdLine.ActiveDrawBox;
  With db Do
  Begin
    If FReshaping Then
      CurrPoint := CmdLine.GetSnappedPoint
    Else
      CurrPoint := CmdLine.CurrentPoint;
    FNewPoint := CurrPoint;
    If FReshaping Then
    Begin
      DrawSelectionRubberBanding( true );
      Repaint;
      DrawSelectionRubberBanding( false );
      FReshaping := false;
      CanDoOsnap := False;
      Caption := SDragFromCtrlPt;
    End
    Else
      With CmdLine Do
      Begin
        Picked := False;
        With db Do
        Begin
          Found := False;
          If FIsOneSelected Then
          Begin
            TmpEnt := FCurrentLayer.LoadEntityWithRecNo( FCurrentRecno );
            If TmpEnt <> Nil Then
            Begin
              Aperture := Ez_Preferences.ApertureWidth Div 2;
              RealAperture := Point2D( Grapher.DistToRealX( Aperture ), Grapher.DistToRealY( Aperture ) );
              If RealAperture.X > RealAperture.Y Then
                MinDist := RealAperture.X
              Else
                MinDist := RealAperture.Y;
              MinDist := Sqrt( 2 ) * MinDist;
              Try
                { detect the picked point }
                PickedPoint := Self.MyOwnPointCode( TmpEnt, CurrPoint, MinDist, Distance, true );
                If ( PickedPoint >= 0 ) And ( Distance <= MinDist ) Then
                Begin
                  Found := True;
                  Picked := True;
                  TmpLayer := FCurrentLayer;
                  TmpRecNo := FCurrentRecno;
                End;
              Finally
                TmpEnt.Free;
              End;
            End;
          End;
          If Not Found Then
          Begin
            If FIsOneSelected Then
            Begin
              If db.StackedSelect Then
              Begin
                If FStackedSelList = Nil Then
                  FStackedSelList := TStringList.Create
                Else
                  FStackedSelList.Clear;
              End
              Else If FStackedSelList <> Nil Then
                FreeAndNil( FStackedSelList );
            End;
            Picked := PickEntity( CurrPoint.X, CurrPoint.Y,  FAperture, '',
              TmpLayer, TmpRecNo, PickedPoint, FStackedSelList );
            If Picked And ( FStackedSelList <> Nil ) And ( FStackedSelList.Count > 1 ) Then
            Begin
              For I := 0 To FStackedSelList.Count - 1 Do
              Begin
                If ( FCurrentLayer = GIS.Layers.LayerByName( FStackedSelList[I] ) ) And
                  ( FCurrentRecno = Longint( FStackedSelList.Objects[I] ) ) Then
                Begin
                  If I < FStackedSelList.Count - 1 Then
                    N := I + 1
                  Else
                    N := 0;
                  TmpLayer := GIS.Layers.LayerByName( FStackedSelList[N] );
                  TmpRecno := Longint( FStackedSelList.Objects[N] );
                  Break;
                End;
              End;
            End;
            FIsOneSelected := False;
          End;
        End;
        If Picked Then
        Begin
          If FIsOneSelected Then
          Begin
            { is the same or another entity ? }
            With db Do
            Begin
              DrawSelectionRubberBanding( false );
              FCurrentLayer := TmpLayer;
              FCurrentRecno := TmpRecNo;
              { now draw new one }
              SetCurrentVertex;
              DrawSelectionRubberBanding( false );
            End;
          End
          Else
          Begin
            FCurrentLayer := TmpLayer;
            FCurrentRecno := TmpRecNo;
            FIsOneSelected := true;

            FCurrentIndex := -1;
            FReshaping := false;
            Caption := SDragFromCtrlPt;
            DrawSelectionRubberBanding( false );
          End;
        End
        Else
        Begin
          If FIsOneSelected Then
            DrawSelectionRubberBanding( false );
          FIsOneSelected := false;
          FReshaping := false;
          FCurrentEntity := Nil;
          FCurrentLayer := Nil;
          FCurrentRecno := -1;
        End;
      End;
  End;
End;

Procedure TDragDropAction.MyMouseMove( Sender: TObject;
  Shift: TShiftState; X, Y: Integer; Const WX, WY: Double );
Var
  CurrPoint: TEzPoint;
Begin
  If FReshaping Then
  Begin
    { Erase previous }
    DrawSelectionRubberBanding( false );
    FNewPoint := CurrPoint;
    DrawSelectionRubberBanding( false );

    With CmdLine Do
    Begin
      All_DrawEntity2DRubberBand( FLineTransform );
      FLineTransform.Points[1] := CurrPoint;
      All_DrawEntity2DRubberBand( FLineTransform );
    End;

  End;
End;

Procedure TDragDropAction.DrawSelectionRubberBanding( ApplyTransform: Boolean;
  Sender: TObject=Nil );
Var
  TmpEntity: TEzEntity;
  ControlPointType: TEzControlPointType;
  Accept, temp: Boolean;
Begin
  With CmdLine.ActiveDrawBox Do
  Begin
    With FCurrentLayer Do
    Begin
      TmpEntity := LoadEntityWithRecno( FCurrentRecno );
      Try
        TmpEntity.UpdateExtension;
        //Prev:= TmpEntity.FBox;
        If FReshaping Then
        Begin
          TmpEntity.UpdateControlPoint( FCurrentIndex, FNewPoint, Grapher );
          TmpEntity.SelectedVertex := FCurrentIndex;
        End;
        TmpEntity.UpdateExtensionFromControlPts;
        TmpEntity.ControlPointsToShow:= [cptMove];
        temp:= HideVertexNumber;
        HideVertexNumber:= true;
        If Sender = Nil Then
          CmdLine.All_DrawEntity2DRubberBand( TmpEntity, True, Not FReshaping )
        Else
          (Sender As TEzBaseDrawbox).DrawEntity2DRubberBand( TmpEntity, True, Not FReshaping );
        HideVertexNumber:= temp;
        If ApplyTransform And Not LayerInfo.Locked Then
        Begin
          if Assigned(Gis.OnBeforeDragDrop) then
          begin
            ControlPointType := TmpEntity.GetControlPointType(FCurrentIndex);
            if ControlPointType = cptMove then
            begin
              Accept:= True;
              Gis.OnBeforeDragDrop( Gis, FCurrentLayer, FCurrentRecno, Accept );
              if not Accept then Exit;
            end;
          end;
          if Not Assigned( Launcher ) then
          begin
            Undo.AddUnTransform( FCurrentLayer, FCurrentRecno );
            UpdateEntity( FCurrentRecno, TmpEntity );
          end;
          if Assigned(Gis.OnAfterDragDrop) then
            Gis.OnAfterDragDrop( Gis, FCurrentLayer, FCurrentRecno );
          If Assigned( Launcher ) And Assigned( TEzActionLauncher( Launcher ).OnTrackedEntityDragDrop ) then
            TEzActionLauncher( Launcher ).OnTrackedEntityDragDrop( Launcher,
              Self.ActionID, FCurrentLayer, FCurrentRecno, TmpEntity );
        End;
      Finally
        if Assigned( TmpEntity ) then
          FreeAndNil( TmpEntity );
      End;
    End;
  End;
End;

Procedure TDragDropAction.MyKeyPress( Sender: TObject; Var Key: Char );
Begin
  If Key = #27 Then
  Begin
    If Not FReshaping Then
    Begin
      If FIsOneSelected Then
        DrawSelectionRubberBanding( false );
      Self.Finished := true;
    End
    Else
    Begin
      FReshaping := False;
      CmdLine.All_Refresh;
      CanDoOsnap := False;
    End;
  End;
End;

Procedure TDragDropAction.MyPaint( Sender: TObject );
Begin
  If FIsOneSelected Then
    DrawSelectionRubberBanding( false, Sender );
End;


{-----------------------------------------------------------------------------}
//                  TAddTextAction
{-----------------------------------------------------------------------------}

constructor TAddTextAction.CreateAction(CmdLine: TEzCmdLine);
begin
  Inherited CreateAction(CmdLine);

  fTextEditor.ParentTextEditorHWND:= EzSystem.GetParentFormHWND(CmdLine.ActiveDrawBox);
  FFormEditor:= TfrmTextEditor.Create(Nil);

  CanDoOsnap:= True;
  CanDoAccuDraw:= True;
  MouseDrawElements:= [mdCursorFrame, mdFullViewCursor];

  OnMouseMove := MyMouseMove;
  OnMouseDown := MyMouseDown;
  OnKeyPress := MyKeyPress;
  OnPaint := MyPaint;
  OnSuspendOperation := Self.SuspendOperation;
  OnContinueOperation := Self.ContinueOperation;

  If Not Ez_Preferences.ShowText Then
    CmdLine.StatusMessage := STextIsNotVisible;

  Cursor := crDrawCross;
  Caption := STextRefPtFirst;

  TfrmTextEditor(FFormEditor).Enter( Self );
end;

destructor TAddTextAction.Destroy;
begin
  If Assigned(FText) Then
    CmdLine.All_DrawEntity2DRubberBand( FText );
  If Assigned(FFormEditor) then
    FreeAndNil(FFormEditor);
  If Assigned(FText) Then
    FreeAndNil(FText);
  inherited;
end;

procedure TAddTextAction.MyKeyPress(Sender: TObject; var Key: Char);
begin
  If Key=#27 then
  begin
    Self.Finished:= True;
  end;
end;

procedure TAddTextAction.MyMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer; const WX, WY: Double);
var
  CurrPoint: TEzPoint;
begin
  If Button=mbRight then exit;
  with CmdLine do
  begin
    CurrPoint := GetSnappedPoint;
    FText.BeginUpdate;
    FText.Points[0]:= CurrPoint;
    FText.EndUpdate;

    AccuDraw.UpdatePosition(CurrPoint, CurrPoint);

    if Assigned( Launcher ) then
    begin
      if Assigned( TEzActionLauncher( Launcher ).OnTrackedEntity ) then
        TEzActionLauncher( Launcher ).OnTrackedEntity( Launcher, Self.ActionID, FText );
      { release the instance if the event not did it}
      if Assigned( FText ) then
        FreeAndNil( FText );
      All_Invalidate;
    end else
      ActionAddNewEntity( CmdLine, FText );

    { build other entity and continue drawing }
    TfrmTextEditor(FFormEditor).CreateText;
  end;
end;

procedure TAddTextAction.MyMouseMove(Sender: TObject; Shift: TShiftState;
  X, Y: Integer; const WX, WY: Double);
var
  CurrPoint: TEzPoint;
begin
  { draw previous }
  If Not Assigned(FText) Then Exit;

  With CmdLine Do
  begin
    All_DrawEntity2DRubberBand( FText );
    CurrPoint := GetSnappedPoint;
    FText.BeginUpdate;
    FText.Points[0]:= CurrPoint;
    FText.EndUpdate;
    All_DrawEntity2DRubberBand( FText );

    { show to user the height of the text }
    with TezTrueTypeText(FText) do
      StatusMessage := Format( STextInfo,
        [ActiveDrawBox.Grapher.DistToPointsY( Fonttool.Height ), Fonttool.Height] );
  end;
end;

procedure TAddTextAction.MyPaint(Sender: TObject);
begin
  If Assigned(FText) Then
    (Sender As TEzBaseDrawBox).DrawEntity2DRubberBand( FText );
end;

procedure TAddTextAction.ContinueOperation(Sender: TObject);
begin
  If Assigned(FText) Then
    CmdLine.All_DrawEntity2DRubberBand( FText );
end;

procedure TAddTextAction.SuspendOperation(Sender: TObject);
begin
  If Assigned(FText) Then
    CmdLine.All_DrawEntity2DRubberBand( FText );
end;


function TAddEntityAction.GetEntity: TEzEntity;
begin
  Result := FEntity;
end;

procedure TAddTextAction.SetScale(const Value: Double);
begin
  FScale := Value;
end;

{ TEditTextAction }

procedure TEditTextAction.ContinueOperation(Sender: TObject);
begin
  If Assigned(FText) Then
    CmdLine.All_DrawEntity2DRubberBand( FText );
end;

constructor TEditTextAction.CreateAction(CmdLine: TEzCmdLine; aScale: Integer);
begin
  Inherited CreateAction(CmdLine);

  fTextEditor.ParentTextEditorHWND:= EzSystem.GetParentFormHWND(CmdLine.ActiveDrawBox);
  FFormEditor:= TfrmTextEditor.Create(Nil);
  TfrmTextEditor(FFormEditor).OnTextChanged := UpdateText;

  CanDoOsnap:= False;
  CanDoAccuDraw:= False;
  MouseDrawElements:= [mdCursor];

  OnMouseMove := MyMouseMove;
  OnMouseDown := MyMouseDown;
  OnKeyPress := MyKeyPress;
  OnPaint := MyPaint;
  OnSuspendOperation := Self.SuspendOperation;
  OnContinueOperation := Self.ContinueOperation;

  If Not Ez_Preferences.ShowText Then
    CmdLine.StatusMessage := STextIsNotVisible;

  Cursor := crDefault;

  with CmdLine.ActiveDrawBox.Selection[0] do
  begin
    Layer.Recno := SelList[0];
    FText := Layer.RecEntity;
  end;

  FScale := aScale;

  TfrmTextEditor(FFormEditor).Enter( Self );
  with TfrmTextEditor(FFormEditor) do
  begin
    Memo1.Text := TEzTrueTypeText(Ftext).Text;
    cboFontName.ItemIndex := cboFontName.Items.IndexOf(TEzTrueTypeText(Ftext).FontTool.Name);
    ColorBox1.Selected := TEzTrueTypeText(Ftext).FontTool.Color;
    CboSize.Text := IntToStr(GetTextSize);
  end;

end;

destructor TEditTextAction.Destroy;
begin
  If Assigned(FFormEditor) then
    FreeAndNil(FFormEditor);
  if Assigned(FText) then
    FText.UpdateExtension;
  inherited;
end;

function TEditTextAction.GetTextHeight: Double;
var
  I: Integer;
begin
  I := 8;
  Result := I;
  if Assigned(FFormEditor) then
  begin
    TryStrToInt(TfrmTextEditor(FFormEditor).CboSize.Text, I);
    Result := I / 1000 * Scale * 25.4 / 72;
  end;
end;

function TEditTextAction.GetTextSize: Integer;
begin
  Result := 8;
  if Assigned(Ftext) then
  with TEzTrueTypeText(Ftext) do
  if Scale <= 0 then
    Result := Round(CmdLine.ActiveDrawBox.Grapher.DistToPointsY(Abs(FontTool.Height)))
  else
    Result := Round(FontTool.Height * 72 / 25.4 / Scale * 1000);
end;

procedure TEditTextAction.MyKeyPress(Sender: TObject; var Key: Char);
begin
  If Key=#27 then
  begin
    Self.Finished:= True;
  end;
end;

procedure TEditTextAction.MyMouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer; const WX,
  WY: Double);
begin

end;

procedure TEditTextAction.MyMouseMove(Sender: TObject; Shift: TShiftState;
  X, Y: Integer; const WX, WY: Double);
begin

end;

procedure TEditTextAction.MyPaint(Sender: TObject);
begin
  If Assigned(FText) Then
    (Sender As TEzBaseDrawBox).DrawEntity2DRubberBand( FText );
end;

procedure TEditTextAction.SetScale(const Value: Double);
begin
  FScale := Value;
end;

procedure TEditTextAction.SuspendOperation(Sender: TObject);
begin
  If Assigned(FText) Then
    CmdLine.All_DrawEntity2DRubberBand( FText );
end;

procedure TEditTextAction.UpdateText(Sender: TObject);
begin
  if FText <> nil then
  if Assigned(FFormEditor) then
  begin
    with TEzTrueTypeText(FText).Fonttool do
    begin
      Assign( Ez_Preferences.DefTTFontStyle );
      Name:= TfrmTextEditor(FFormEditor).cboFontname.Text;
      Style:= [];
      If TfrmTextEditor(FFormEditor).BtnBold.Down then Style:= Style + [fsBold];
      If TfrmTextEditor(FFormEditor).BtnItal.Down then Style:= Style + [fsItalic];
      If TfrmTextEditor(FFormEditor).BtnUnder.Down then Style:= Style + [fsUnderline];
      Color:= TfrmTextEditor(FFormEditor).ColorBox1.Selected;
      Height:= GetTextHeight;
    end;
    TEzTrueTypeText(FText).Text := TfrmTextEditor(FFormEditor).Memo1.Lines.Text;
  End;
end;

{ TAddText500Action }

procedure TAddText500Action.ContinueOperation(Sender: TObject);
begin
  If Assigned(FText) Then
    CmdLine.All_DrawEntity2DRubberBand( FText );
end;

constructor TAddText500Action.CreateAction(CmdLine: TEzCmdLine; aScale: Integer);
begin
  Inherited CreateAction(CmdLine);

  fTextEditor.ParentTextEditorHWND:= EzSystem.GetParentFormHWND(CmdLine.ActiveDrawBox);
  FFormEditor:= TfrmTextEditor.Create(Nil);

  CanDoOsnap:= True;
  CanDoAccuDraw:= True;
  MouseDrawElements:= [mdCursorFrame, mdFullViewCursor];

  OnMouseMove := MyMouseMove;
  OnMouseDown := MyMouseDown;
  OnKeyPress := MyKeyPress;
  OnPaint := MyPaint;
  OnSuspendOperation := Self.SuspendOperation;
  OnContinueOperation := Self.ContinueOperation;

  If Not Ez_Preferences.ShowText Then
    CmdLine.StatusMessage := STextIsNotVisible;

  Cursor := crDrawCross;
  Caption := STextRefPtFirst;

  FScale := aScale;
  TfrmTextEditor(FFormEditor).Enter( Self );

  FText:= TEzTrueTypeText.CreateEntity( Point2d(0,0), TfrmTextEditor(FFormEditor).Memo1.Text, GetTextHeight, 0 );
  with TEzTrueTypeText(FText).Fonttool do
  begin
    Assign( Ez_Preferences.DefTTFontStyle );
    Name := TfrmTextEditor(FFormEditor).cboFontname.Text;
    Style:= [];
    If TfrmTextEditor(FFormEditor).BtnBold.Down then Style:= Style + [fsBold];
    If TfrmTextEditor(FFormEditor).BtnItal.Down then Style:= Style + [fsItalic];
    If TfrmTextEditor(FFormEditor).BtnUnder.Down then Style:= Style + [fsUnderline];
    Color:= TfrmTextEditor(FFormEditor).ColorBox1.Selected;
    Height:= GetTextHeight;
  end;
end;

destructor TAddText500Action.Destroy;
begin
  If Assigned(FText) Then
    CmdLine.All_DrawEntity2DRubberBand( FText );
  If Assigned(FFormEditor) then
    FreeAndNil(FFormEditor);
  If Assigned(FText) Then
    FreeAndNil(FText);
  inherited;
end;

function TAddText500Action.GetTextHeight: Double;
var
  I: Integer;
begin
  I := 8;
  Result := I;
  if Assigned(FFormEditor) then
  begin
    TryStrToInt(TfrmTextEditor(FFormEditor).CboSize.Text, I);
    Result := I / 1000 * Scale * 25.4 / 72;
  end;
end;

procedure TAddText500Action.MyKeyPress(Sender: TObject; var Key: Char);
begin
  If Key=#27 then
  begin
    Self.Finished:= True;
  end;
end;

procedure TAddText500Action.MyMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer; const WX, WY: Double);
var
  CurrPoint: TEzPoint;
  TmpHeight: Double;
begin
  If Button = mbRight then
    Exit;
  UpdateText;
  with CmdLine do
  begin
    CurrPoint := GetSnappedPoint;
    FText.BeginUpdate;
    FText.Points[0]:= CurrPoint;
    FText.EndUpdate;

    AccuDraw.UpdatePosition(CurrPoint, CurrPoint);

    if Assigned( Launcher ) then
    begin
      if Assigned( TEzActionLauncher( Launcher ).OnTrackedEntity ) then
        TEzActionLauncher( Launcher ).OnTrackedEntity( Launcher, Self.ActionID, FText );
      { release the instance if the event not did it}
      if Assigned( FText ) then
        FreeAndNil( FText );
      All_Invalidate;
    end
    else
      ActionAddNewEntity( CmdLine, FText );

    { build other entity and continue drawing }
    if FText = nil then
    begin
      TmpHeight := GetTextHeight;
      Text := TEzTrueTypeText.CreateEntity( Point2d(0,0), TfrmTextEditor(FFormEditor).Memo1.Text, TmpHeight, 0 );
      with TEzTrueTypeText(Text).Fonttool do
      begin
        Assign( Ez_Preferences.DefTTFontStyle );
        Name:= TfrmTextEditor(FFormEditor).cboFontname.Text;
        Style:= [];
        If TfrmTextEditor(FFormEditor).BtnBold.Down then Style:= Style + [fsBold];
        If TfrmTextEditor(FFormEditor).BtnItal.Down then Style:= Style + [fsItalic];
        If TfrmTextEditor(FFormEditor).BtnUnder.Down then Style:= Style + [fsUnderline];
        Color:= TfrmTextEditor(FFormEditor).ColorBox1.Selected;
        Height:= TmpHeight;
      end;
    End;
  end;
end;

procedure TAddText500Action.MyMouseMove(Sender: TObject; Shift: TShiftState; X,
  Y: Integer; const WX, WY: Double);
var
  CurrPoint: TEzPoint;
begin
  { draw previous }
  If Not Assigned(FText) Then Exit;
  if not Assigned(FFormEditor) then
  
  With CmdLine Do
  begin
    UpdateText;
    All_DrawEntity2DRubberBand( FText );
    CurrPoint := GetSnappedPoint;
    FText.BeginUpdate;
    FText.Points[0]:= CurrPoint;
    FText.EndUpdate;
    All_DrawEntity2DRubberBand( FText );

    { show to user the height of the text }
    with TezTrueTypeText(FText) do
      StatusMessage := Format( STextInfo,
        [ActiveDrawBox.Grapher.DistToPointsY( Fonttool.Height ), Fonttool.Height] );
  end;
end;

procedure TAddText500Action.MyPaint(Sender: TObject);
begin
  If Assigned(FText) Then
    (Sender As TEzBaseDrawBox).DrawEntity2DRubberBand( FText );
end;

procedure TAddText500Action.SetScale(const Value: Double);
begin
  FScale := Value;
end;

procedure TAddText500Action.SuspendOperation(Sender: TObject);
begin
  If Assigned(FText) Then
    CmdLine.All_DrawEntity2DRubberBand( FText );
end;

procedure TAddText500Action.UpdateText;
begin
  if FText <> nil then
  if Assigned(FFormEditor) then
  begin
    with TEzTrueTypeText(FText).Fonttool do
    begin
      Assign( Ez_Preferences.DefTTFontStyle );
      Name:= TfrmTextEditor(FFormEditor).cboFontname.Text;
      Style:= [];
      If TfrmTextEditor(FFormEditor).BtnBold.Down then Style:= Style + [fsBold];
      If TfrmTextEditor(FFormEditor).BtnItal.Down then Style:= Style + [fsItalic];
      If TfrmTextEditor(FFormEditor).BtnUnder.Down then Style:= Style + [fsUnderline];
      Color:= TfrmTextEditor(FFormEditor).ColorBox1.Selected;
      Height:= GetTextHeight;
    end;
    TEzTrueTypeText(FText).Text := TfrmTextEditor(FFormEditor).Memo1.Lines.Text;
  End;
end;

end.
