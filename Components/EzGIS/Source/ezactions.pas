Unit EzActions;

{***********************************************************}
{     EzGIS/CAD Components                                  }
{   (c) 2002 EzSoft Engineering                             }
{         All Rights Reserved                               }
{***********************************************************}

{$I EZ_FLAG.PAS}
Interface

Uses
  SysUtils, Windows, Messages, Classes, Graphics, Controls, ExtCtrls, Dialogs,
  Forms, EzBase, EzBaseGIS, EzLib, EzCmdLine, EzEntities, EzSystem, EzDanHint;

Type

  {----------------------------------------------------------------------------}
  {                  TTheDefaultAction                                         }
  {----------------------------------------------------------------------------}

  TTheDefaultAction = Class( TEzAction )
  Private
    FAperture: Byte;
    FSelectDenied: Boolean;
    { used for stacked select}
    FStackedSelList: TStringList;
    FCanMove: Boolean;
    FMoveStartPoint: TPoint;
    FMoveStartPoint2D: TEzPoint;
    Procedure MyKeyPress( Sender: TObject; Var Key: Char );
    Procedure MyMouseDown( Sender: TObject; Button: TMouseButton;
    Shift: TShiftState; X, Y: Integer; Const WX, WY: Double );
    Procedure MyMouseMove( Sender: TObject; 
    Shift: TShiftState; X, Y: Integer; Const WX, WY: Double );
    Procedure MyMouseUp( Sender: TObject; Button: TMouseButton;
    Shift: TShiftState; X, Y: Integer; Const WX, WY: Double );
    Procedure MyDblClick( Sender: TObject );
  {$IFDEF BCB} (*_*)
    function GetSelectDenied: Boolean;
    procedure SetSelectDenied(const Value: Boolean);
  {$ENDIF}
    function FindStackEntitiesInSelection: Boolean;
  Public
    Constructor CreateAction( CmdLine: TEzCmdLine );
    Destructor Destroy; Override;
    Property SelectDenied: Boolean
      Read {$IFDEF BCB} GetSelectDenied {$ELSE} FSelectDenied {$ENDIF}
      Write {$IFDEF BCB} SetSelectDenied {$ELSE} FSelectDenied {$ENDIF}; (*_*)
  End;

  {----------------------------------------------------------------------------}
  //                  TRotateAccuDrawAction
  {----------------------------------------------------------------------------}

  TRotateAccuDrawAction = Class( TEzAction )
  Private
    Procedure MyMouseUp( Sender: TObject; Button: TMouseButton; Shift:
      TShiftState; X, Y: Integer; Const WX, WY: Double );
    Procedure MyMouseMove( Sender: TObject; Shift: TShiftState; X, Y: Integer;
      Const WX, WY: Double );
    Procedure MyKeyPress( Sender: TObject; Var Key: Char );
  Public
    Constructor CreateAction( CmdLine: TEzCmdLine );
  End;

  {----------------------------------------------------------------------------}
  //                  TZoomWindowAction
  {----------------------------------------------------------------------------}

  TZoomWindowAction = Class( TEzAction )
  Private
    FFrame: TEzRectangle;
    FOuterFrame: TEzRectangle;
    FAuxLine: TEzPolyline;
    FCurrentIndex: Integer;
    FOrigin: TPoint;
    FIsZooming: Boolean;
    FTargetDrawBox: TEzBaseDrawBox;
    Procedure SetCurrentPoint( Const Pt: TEzPoint );
    Procedure DoFinishZooming;
    Procedure MyMouseDown( Sender: TObject; Button: TMouseButton; Shift:
      TShiftState; X, Y: Integer; Const WX, WY: Double );
    Procedure MyMouseUp( Sender: TObject; Button: TMouseButton;
    Shift: TShiftState; X, Y: Integer; Const WX, WY: Double );
    Procedure MyMouseMove( Sender: TObject; Shift: TShiftState; X, Y: Integer;
      Const WX, WY: Double );
    Procedure MyKeyPress( Sender: TObject; Var Key: Char );
    Procedure MyPaint( Sender: TObject );
    Procedure DrawRubbers(Sender: TObject=Nil);
  Public
    Constructor CreateAction( CmdLine: TEzCmdLine );
    Destructor Destroy; Override;
  End;

  {----------------------------------------------------------------------------}
  //                  TPanningAction
  {----------------------------------------------------------------------------}

  TPanningAction = Class( TEzAction )
  Private
    FLine: TEzPolyLine;
    FCurrentIndex: Integer;
    FStopOnClick: Boolean;
    Procedure MyKeyPress( Sender: TObject; Var Key: Char );
    Procedure MyMouseDown( Sender: TObject; Button: TMouseButton; Shift:
      TShiftState; X, Y: Integer; Const WX, WY: Double );
    Procedure MyMouseMove( Sender: TObject; Shift: TShiftState;
      X, Y: Integer; Const WX, WY: Double );
    Procedure MyPaint( Sender: TObject );
  Public
    Constructor CreateAction( CmdLine: TEzCmdLine; StopOnClick: Boolean = True );
    Destructor Destroy; Override;
  End;

  {----------------------------------------------------------------------------}
  //                  TEzTransformSelectionAction
  {----------------------------------------------------------------------------}

  TEzScaleAxxis = ( saBoth, saX, saY );

  TTransformSelectionAction = Class( TEzAction )
  Private
    FLine: TEzPolyLine;
    FCurrentIndex: Integer;
    FTransformType: TEzTransformType;
    FReferenceStart: TEzPoint;
    FReferenceEnd: TEzPoint;
    FReferenceLength: Double;
    FReferenceDefined: Boolean;
    FOffsetCmd: Boolean;
    FScaleAxxis: TEzScaleAxxis;
    FOldHiliteSnapped: Boolean;
    FDrawBoxWithSel: TEzBaseDrawBox;
    procedure DrawRubberLine(Sender: TObject=Nil);
    Procedure DrawSelectionRubberBanding( ApplyTransform: Boolean;
      Sender: TObject=Nil );
    Procedure SetCurrentPoint( Var Pt: TEzPoint; Orto: Boolean );
    Procedure MyActionDoCommand( Sender: TObject );
    Procedure MyMouseDown( Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer; Const WX, WY: Double );
    Procedure MyMouseMove( Sender: TObject; Shift: TShiftState;
      X, Y: Integer; Const WX, WY: Double );
    Procedure MyPaint( Sender: TObject );
    Procedure MyKeyPress( Sender: TObject; Var Key: Char );
    Procedure SuspendOperation( Sender: TObject );
    Procedure ContinueOperation( Sender: TObject );
  Public
    Constructor CreateAction( CmdLine: TEzCmdLine;
      TransformType: TEzTransformType; OffsetCmd: Boolean; ScaleAxxis: TEzScaleAxxis );
    Destructor Destroy; Override;
  End;

  TAutoMoveAction = class(TTransformSelectionAction)
  private
    procedure MyMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer; Const WX, WY: Double);
  public
    constructor CreateAction(CmdLine: TEzCmdLine);
  end;

  {----------------------------------------------------------------------------}
  //                  TSelectAction
  {----------------------------------------------------------------------------}

    { The action for selecting entities }
  TEzSelectionMode = ( smPicking, smWindow );
  { Group mode specifies how the object are picked in a box. }
  TEzGroupMode = ( gmAllInside, gmCrossFrame );

  TSelectAction = Class( TEzAction )
  Private
    fFrame: TEzRectangle;
    FAperture: Integer;
    fCurrentIndex: Integer;
    fSelMode: TEzSelectionMode;
    Procedure SelectInFrame( Frame: TEzRect; Mode: TEzGroupMode );
    Procedure SetCurrentPoint( Grapher: TEzGrapher; Const Pt: TEzPoint );
    Procedure MyMouseDown( Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer; Const WX, WY: Double );
    Procedure MyMouseMove( Sender: TObject; Shift: TShiftState;
      X, Y: Integer; Const WX, WY: Double );
    Procedure MyKeyPress( Sender: TObject; Var Key: Char );
    Procedure MyPaint( Sender: TObject );
  {$IFDEF BCB} (*_*)
    function GetAperture: Integer;
    procedure SetAperture(const Value: Integer);
  {$ENDIF}
  Public
    Constructor CreateAction( CmdLine: TEzCmdLine; Aperture: Integer );
    Destructor Destroy; Override;
    Property Aperture: Integer Read {$IFDEF BCB} GetAperture {$ELSE} FAperture {$ENDIF}
      Write {$IFDEF BCB} SetAperture {$ELSE} FAperture {$ENDIF}; (*_*)
  End;

  {----------------------------------------------------------------------------}
  //                  TInsertVertexAction
  {----------------------------------------------------------------------------}

    { action for Insert vertex in Polylines or Polygons }
  TInsertVertexAction = Class( TEzAction )
  Private
    fEntity: TEzEntity;
    fLayer: TEzBaseLayer;
    fRecno: Integer;
    FModified:Boolean;
    FAperture: Byte;
    Procedure MyKeyPress( Sender: TObject; Var Key: Char );
    Procedure MyMouseDown( Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer; Const WX, WY: Double );
    Procedure MyPaint( Sender: TObject );
  Public
    Constructor CreateAction( CmdLine: TEzCmdLine );
    Destructor Destroy; Override;
  End;

  {----------------------------------------------------------------------------}
  //                  TChangeGridOriginAction
  {----------------------------------------------------------------------------}

  TChangeGridOriginAction = Class( TEzAction )
  Private
    Procedure MyKeyPress( Sender: TObject; Var Key: Char );
    Procedure MyMouseDown( Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer; Const WX, WY: Double );
  Public
    Constructor CreateAction( CmdLine: TEzCmdLine );
  End;

  {----------------------------------------------------------------------------}
  //                  TShowHintAction
  {----------------------------------------------------------------------------}

  { The action for showing hints on layerґs entities }

  TShowHintAction = Class( TEzAction )
  Private
    { for handling the hint window }
    hintW: TNewHint;
    fLayer: TEzBaseLayer;
    //fTimer: TTimer;
    fLastLayer: TEzBaseLayer;
    fLastRecno: Integer;
    fSaveOnDeactivate: TNotifyEvent;
    fSaveOnHint: TNotifyEvent;
    FStackedSelList: TStringList;
    FHighlightClicked: Boolean;
    FTempUsed: Boolean;
    FTempEnt: TEzEntity;
    Procedure HiliteClickedEntity( Layer: TEzBaseLayer; Recno: Integer );
    Procedure DisposeTempUsed;
    Procedure MyDeactivate( Sender: TObject );
    Procedure MyOnHint( Sender: TObject );
    Procedure DisplayHintWindow( Const TmpHint: String; p: TPoint );
    //Procedure MyTimer( Sender: TObject );
    Procedure MyKeyPress( Sender: TObject; Var Key: Char );
    //Procedure SuspendOperation( Sender: TObject );
    //Procedure ContinueOperation( Sender: TObject );
    Procedure MyMouseDown( Sender: TObject; Button: TMouseButton; Shift:
      TShiftState; X, Y: Integer; Const WX, WY: Double );
  Public
    Constructor CreateAction( CmdLine: TEzCmdLine );
    Destructor Destroy; Override;
  End;

  {----------------------------------------------------------------------------}
  //                  TPolygonFromBufferAction
  {----------------------------------------------------------------------------}

  { draw a polygon by using a polyline as a buffer }
  TPolygonFromBufferAction = Class( TEzAction )
  Private
    fLine: TEzPolyLine;
    fPolyline: TEzPolyLine;
    fPolygon: TEzPolygon;
    fCurrentIndex: Integer;
    fDistance: Double;
    fReferenceDefined: Boolean;
    Procedure DrawRubberEntityDotted(Entity: TEzEntity;Sender: TObject=Nil);
    Procedure SetCurrentPoint( Const Pt: TEzPoint );
    Procedure CalcPolygon;
    Procedure MyMouseDown( Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer; Const WX, WY: Double );
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

  {----------------------------------------------------------------------------}
  //                  TRealTimeZoomAction
  {----------------------------------------------------------------------------}

    // action for zooming in real time
  TRealTimeZoomAction = Class( TEzAction )
  Private
    FStartPoint: TPoint;
    FSaveParams: TEzTransformParams;
    FRealTimeZooming: Boolean;
    FSaveShowWaitCursor: Boolean;
    FCursorGIS: TEzBaseGIS;
    FWorkDrawBox: TEzBaseDrawBox;

    FUseThread: Boolean;
    FPaintingThread: TEzPainterThread;

    Procedure MyThreadDone(Sender: TObject);
    procedure MyStopRepaintThread;

    Procedure MyMouseDown( Sender: TObject; Button: TMouseButton; Shift:
      TShiftState; X, Y: Integer; Const WX, WY: Double );
    Procedure MyMouseUp( Sender: TObject; Button: TMouseButton; Shift:
      TShiftState; X, Y: Integer; Const WX, WY: Double );
    Procedure MyMouseMove( Sender: TObject; Shift: TShiftState;
      X, Y: Integer; Const WX, WY: Double );
    Procedure MyKeyPress( Sender: TObject; Var Key: Char );
  Public
    Constructor CreateAction( CmdLine: TEzCmdLine; UseThread: Boolean );
    Destructor Destroy; override;
  End;

  {----------------------------------------------------------------------------}
  //                  TRealTimeZoomActionB
  {----------------------------------------------------------------------------}

  // action for zooming in real time by scaling the current internal buffer bitmap
  TRealTimeZoomActionB = Class( TEzAction )
  Private
    FWorkBmp: TBitmap;
    FStartPoint: TPoint;
    FSaveParams: TEzTransformParams;
    FRealTimeZooming: Boolean;
    FSaveShowWaitCursor: Boolean;
    FCursorGIS: TEzBaseGIS;
    Procedure MyMouseDown( Sender: TObject; Button: TMouseButton; Shift:
      TShiftState; X, Y: Integer; Const WX, WY: Double );
    Procedure MyMouseUp( Sender: TObject; Button: TMouseButton; Shift:
      TShiftState; X, Y: Integer; Const WX, WY: Double );
    Procedure MyMouseMove( Sender: TObject; Shift: TShiftState;
      X, Y: Integer; Const WX, WY: Double );
    Procedure MyKeyPress( Sender: TObject; Var Key: Char );
    Procedure MyPaint( Sender: TObject );
  Public
    Constructor CreateAction( CmdLine: TEzCmdLine );
    destructor Destroy; override;
  End;

  {----------------------------------------------------------------------------}
  //                  TClipPolyAction
  {----------------------------------------------------------------------------}

  // Polygon clipping action
  TClipPolyAction = Class( TEzAction )
  Private
    FEntity: TEzEntity;
    FCurrentIndex: Integer;
    Procedure SetCurrentPoint( Pt: TEzPoint; Orto: Boolean );
    Procedure SetAddActionCaption;
    Procedure MyMouseDown( Sender: TObject; Button: TMouseButton; Shift:
      TShiftState; X, Y: Integer; Const WX, WY: Double );
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

  {----------------------------------------------------------------------------}
  //                  TBreakAction
  {----------------------------------------------------------------------------}

  TBreakAction = Class( TEzAction )
  Private
    FAperture: Integer;
    FCurrent: Integer;
    FBreakPoints: Array[0..1] Of TEzPoint;
    FSegment: Array[0..1] Of Integer;
    FLayer: TEzBaseLayer;
    FRecNo: Integer;
    Procedure MyMouseDown( Sender: TObject; Button: TMouseButton; Shift:
      TShiftState; X, Y: Integer; Const WX, WY: Double );
    Procedure MyKeyPress( Sender: TObject; Var Key: Char );
  Public
    Constructor CreateAction( CmdLine: TEzCmdLine );
  End;

  {----------------------------------------------------------------------------}
  //                  TTrimAction
  {----------------------------------------------------------------------------}

  TTrimAction = Class( TEzAction )
  Private
    FPickFrame: TEzRectangle;
    FAperture: Integer;
    FIsButtonUp: Boolean;
    Procedure SetCurrentPoint( Grapher: TEzGrapher; Const Pt: TEzPoint );
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
    Constructor CreateAction( CmdLine: TEzCmdLine );
    Destructor Destroy; Override;
  End;

  {----------------------------------------------------------------------------}
  //                  TExtendAction
  {----------------------------------------------------------------------------}

  TExtendAction = Class( TEzAction )
  Private
    FPickFrame: TEzRectangle;
    FAperture: Integer;
    FIsButtonUp: Boolean;
    Procedure SetCurrentPoint( Grapher: TEzGrapher; Const Pt: TEzPoint );
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
    Constructor CreateAction( CmdLine: TEzCmdLine );
    Destructor Destroy; Override;
  End;

  {----------------------------------------------------------------------------}
  //                  TFilletAction
  {----------------------------------------------------------------------------}

  TFilletAction = Class( TEzAction )
  Private
    FPickFrame: TEzRectangle;
    FAperture: Integer;
    FCurrent: Integer;
    FFilletPoints: Array[0..1] Of TEzPoint;
    FSegment, FPickedPoints: Array[0..1] Of Integer;
    FLayer: TEzBaseLayer;
    FRecNo: Integer;
    FDefiningCurve: Boolean;
    FArc: TEzArc;
    Procedure SetCurrentPoint( Grapher: TEzGrapher; Const Pt: TEzPoint );
    Procedure MyMouseDown( Sender: TObject; Button: TMouseButton; Shift:
      TShiftState; X, Y: Integer; Const WX, WY: Double );
    Procedure MyMouseMove( Sender: TObject; Shift: TShiftState;
      X, Y: Integer; Const WX, WY: Double );
    Procedure MyKeyPress( Sender: TObject; Var Key: Char );
    Procedure MyPaint( Sender: TObject );
    Procedure SuspendOperation( Sender: TObject );
    Procedure ContinueOperation( Sender: TObject );
  Public
    Constructor CreateAction( CmdLine: TEzCmdLine );
    Destructor Destroy; Override;
  End;

  {----------------------------------------------------------------------------}
  //                  TPolygonSelectAction
  {----------------------------------------------------------------------------}

  { The action for selecting entities that lies inside a polygon}
  TPolygonSelectAction = Class( TEzAction )
  Private
    FPolygon: TEzPolygon;
    FCurrentIndex: Integer;
    Procedure SetCurrentPoint( Const Pt: TEzPoint );
  Protected
    Procedure MyMouseDown( Sender: TObject; Button: TMouseButton; Shift: TShiftState;
      X, Y: Integer; Const WX, WY: Double );
    Procedure MyMouseMove( Sender: TObject; Shift: TShiftState;
      X, Y: Integer; Const WX, WY: Double );
    Procedure MyKeyPress( Sender: TObject; Var Key: Char );
    Procedure MyPaint( Sender: TObject );
  Public
    Constructor CreateAction( CmdLine: TEzCmdLine );
    Destructor Destroy; Override;
  End;

  {----------------------------------------------------------------------------}
  //                  TCircleSelectAction
  {----------------------------------------------------------------------------}

  { The action for selecting inside a circle
    Note: actually I will use a polygon to draw the circle and to
    simplify the selection }
  TCircleSelectAction = Class( TEzAction )
  Private
    FPolygon: TEzPolygon;
    FCenter: TEzPoint;
    FCenterDefined: Boolean;
    Procedure SetCurrentPoint( Const Pt: TEzPoint );
  Protected
    Procedure MyMouseDown( Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer; Const WX, WY: Double );
    Procedure MyMouseMove( Sender: TObject; Shift: TShiftState; X, Y: Integer;
      Const WX, WY: Double );
    Procedure MyKeyPress( Sender: TObject; Var Key: Char );
    Procedure MyPaint( Sender: TObject );
  Public
    Constructor CreateAction( CmdLine: TEzCmdLine );
    Destructor Destroy; Override;
  End;

  {----------------------------------------------------------------------------}
  //                  TMeasuresAction
  {----------------------------------------------------------------------------}

    { The action for measuring areas and perimeters in the drawing }
  TMeasuresAction = Class( TEzAction )
  Private
    FPolyline: TEzEntity;
    FCurrentIndex: Integer;
    {for handling the hint window}
    hintW: THintWindow;
    Procedure SetCurrentPoint( Pt: TEzPoint; Orto: Boolean );
    Procedure ShowAreaAndPerimeter;
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

  {----------------------------------------------------------------------------}
  //                  TZoomInOutAction
  {----------------------------------------------------------------------------}

    { The action for zooming/unzooming by clicking in the drawing }
  TEzZoomAction = ( zaZoomIn, zaZoomOut );

  TZoomInOutAction = Class( TEzAction )
  Private
    FAction: TEzZoomAction;
  Protected
    Procedure MyMouseDown( Sender: TObject; Button: TMouseButton; Shift: TShiftState;
      X, Y: Integer; Const WX, WY: Double );
    Procedure MyKeyPress( Sender: TObject; Var Key: Char );
  Public
    Constructor CreateAction( CmdLine: TEzCmdLine; Action: TEzZoomAction );
  End;

  {----------------------------------------------------------------------------}
  //                  THandScrollAction
  {----------------------------------------------------------------------------}

  { The action for scrolling the drawing with a hand cursor (also known as panning) }
  THandScrollAction = Class( TEzAction )
  Private
    FOrigin: TPoint;
    FDownX, FDownY: Integer;
    FScrolling: Boolean;
    { for scrolling a preview }
    FPickedPreview: Boolean;
    FPreviewLayer: TEzBaseLayer;
    FPreviewRecno: Integer;
    FPreviewRect: TRect;
    FSavedShowWaitCursor: Boolean;
  Protected
    Procedure MyMouseDown( Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer; Const WX, WY: Double );
    Procedure MyMouseUp( Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer; Const WX, WY: Double );
    Procedure MyMouseMove( Sender: TObject; Shift: TShiftState;
      X, Y: Integer; Const WX, WY: Double );
    Procedure MyKeyPress( Sender: TObject; Var Key: Char );
  Public
    Constructor CreateAction( CmdLine: TEzCmdLine );
    destructor Destroy; override;
  End;

  {----------------------------------------------------------------------------}
  //                  TGuideLineAction
  {----------------------------------------------------------------------------}

  { the action for inserting guidelines in the drawing }
  TGuideLineAction = Class( TEzAction )
  Private
    FLine: TEzPolyLine;
    FOrientation: Integer; // 0=horizontal,1=vertical
    Procedure SetCurrentPoint( Const Pt: TEzPoint );
  Protected
    Procedure MyActionDoCommand( Sender: TObject );
    Procedure MyMouseDown( Sender: TObject; Button: TMouseButton; Shift: TShiftState;
      X, Y: Integer; Const WX, WY: Double );
    Procedure MyMouseMove( Sender: TObject; Shift: TShiftState;
      X, Y: Integer; Const WX, WY: Double );
    Procedure MyKeyPress( Sender: TObject; Var Key: Char );
    Procedure MyPaint( Sender: TObject );
    Procedure SuspendOperation( Sender: TObject );
    Procedure ContinueOperation( Sender: TObject );
  Public
    Constructor CreateAction( CmdLine: TEzCmdLine; Orientation: Integer );
    Destructor Destroy; Override;
  End;

  {----------------------------------------------------------------------------}
  //                  TMoveGuideLineAction
  {----------------------------------------------------------------------------}

  TMoveGuideLineAction = Class( TEzAction )
  Private
    FLine: TEzPolyLine;
    FOrientation: Integer;
    FIndex: Integer;
    FDetected: Boolean;
    FMoving: Boolean;
    Procedure SetCurrentPoint( Const Pt: TEzPoint );
    Function IsGuidelineVisible( Orientation: Integer; Index: Integer ): boolean;
  Protected
    Procedure MyMouseDown( Sender: TObject; Button: TMouseButton; Shift: TShiftState;
      X, Y: Integer; Const WX, WY: Double );
    Procedure MyMouseUp( Sender: TObject;
      Button: TMouseButton; Shift: TShiftState; X, Y: Integer; Const WX, WY: Double );
    Procedure MyMouseMove( Sender: TObject; Shift: TShiftState;
      X, Y: Integer; Const WX, WY: Double );
    Procedure MyKeyPress( Sender: TObject; Var Key: Char );
    Procedure MyPaint( Sender: TObject );
    Procedure DoMoveGuideline( Const P: TEzPoint );
    Procedure SuspendOperation( Sender: TObject );
    Procedure ContinueOperation( Sender: TObject );
  Public
    Constructor CreateAction( CmdLine: TEzCmdLine );
    Destructor Destroy; Override;
  End;

  {----------------------------------------------------------------------------}
  //                  TSetClipAreaAction
  {----------------------------------------------------------------------------}

  TSetClipAreaAction = Class( TEzAction )
  Private
    FFrame: TEzRectangle;
    FCurrentIndex: Integer;
    FOrigin: TPoint;
    Procedure SetCurrentPoint( Const Pt: TEzPoint );
    Procedure DoFinishClipArea;
  Protected
    Procedure MyMouseDown( Sender: TObject; Button: TMouseButton; Shift: TShiftState;
      X, Y: Integer; Const WX, WY: Double );
    Procedure MyMouseUp( Sender: TObject; Button: TMouseButton; Shift: TShiftState;
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
  End;

  {----------------------------------------------------------------------------}
  //                  TSetPolygonClipAreaAction
  {----------------------------------------------------------------------------}

  TSetPolygonClipAreaAction = Class( TEzAction )
  Private
    FEntity: TEzEntity;
    FCurrentIndex: Integer;
    Procedure SetCurrentPoint( Pt: TEzPoint; Orto: Boolean );
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

  TRotateTextAction = class(TEzAction)
  private
    FCurrentRecno: Integer; {the selected recno}
    FCurrentLayer: TEzBaseLayer; {the selected layer}
    FText: TEzTrueTypeText;
    procedure DrawText;
  protected
    procedure MyMouseMove( Sender: TObject;
      Shift: TShiftState; X, Y: Integer; Const WX, WY: Double );
    procedure MyMouseDown( Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer; Const WX, WY: Double );
    procedure MyKeyPress( Sender: TObject; Var Key: Char );
    procedure MyPaint( Sender: TObject );
  public
    constructor CreateAction( CmdLine: TEzCmdLine; Aperture: Integer );
    destructor Destroy; override;
  end;

  {----------------------------------------------------------------------------}
  //                  TReshapeEntityAction
  {----------------------------------------------------------------------------}

  TReshapeEntityAction = Class( TEzAction )
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
    FStartPoint: TEzPoint;    // used when moving a segment
    { for reshaping full segments }
    FPickedSegment: Boolean;
    FSegmentIdx1: Integer;
    FSegmentIdx2: Integer;
    { save previous state of TEzCmdLine.AccuSnap.HiliteSnapped }
    FOldHiliteSnapped: Boolean;
    procedure RubberLineTransform(Sender: TObject = Nil);
    Procedure DrawSelectionRubberBanding( ApplyTransform: Boolean;
      Sender: TObject=Nil );
    Function MyOwnPointCode( Ent: TEzEntity;  Const Pt: TEzPoint;
      Const Aperture: Double; Var Distance: Double;
      SelectPickingInside: Boolean ): Integer;
    procedure SetCurrentLayer(const Value: TezBaseLayer);
    procedure SetCurrentRecno(const Value: Integer);
  Protected
    Procedure MyMouseDown( Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer; Const WX, WY: Double );
    Procedure MyMouseMove( Sender: TObject;
      Shift: TShiftState; X, Y: Integer; Const WX, WY: Double );
    Procedure MyMouseUp( Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer; Const WX, WY: Double );
    Procedure MyKeyPress( Sender: TObject; Var Key: Char );
    Procedure MyPaint( Sender: TObject );
    Procedure SuspendOperation( Sender: TObject );
    Procedure ContinueOperation( Sender: TObject );
  Public
    Constructor CreateAction( CmdLine: TEzCmdLine; Aperture: Integer );
    Destructor Destroy; Override;
    property CurrentLayer: TEzBaseLayer read FCurrentLayer write SetCurrentLayer;
    property CurrentRecno: Integer read FCurrentRecno write SetCurrentRecno;
  End;

  {----------------------------------------------------------------------------}
  //                  TDeleteVertexAction
  {----------------------------------------------------------------------------}

  TDeleteVertexAction = Class( TEzAction )
  Private
    FCurrentRecno: Integer; {the selected recno}
    FCurrentLayer: TEzBaseLayer; {the selected layer}
    FCurrentIndex: Integer; {the vertex to delete}
    FCurrentEntity: TEzEntity; {current entity if editing symbols}
    FIsOneSelected: Boolean; {state have one entity selected}
    FAperture: Integer; {the aperture of frame in pixels}
    Procedure DrawSelectionRubberBanding( ApplyTransform: Boolean;
      Sender: TObject=Nil );
  Protected
    Procedure MyMouseDown( Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer; Const WX, WY: Double );
    Procedure MyKeyPress( Sender: TObject; Var Key: Char );
    Procedure MyPaint( Sender: TObject );
  Public
    Constructor CreateAction( CmdLine: TEzCmdLine );
    Destructor Destroy; Override;
  End;

  {----------------------------------------------------------------------------}
  //                  TCustomClickAction
  {----------------------------------------------------------------------------}

  { show coords }
  TCustomClickAction = Class( TEzAction )
  Protected
    Procedure MyKeyPress( Sender: TObject; Var Key: Char );
    Procedure MyMouseDown( Sender: TObject;
                           Button: TMouseButton;
                           Shift: TShiftState;
                           X, Y: Integer;
                           Const WX, WY: Double );
  Public
    Constructor CreateAction( CmdLine: TEzCmdLine );
  End;

  {----------------------------------------------------------------------------}
  //                  TCustomClickAction
  {----------------------------------------------------------------------------}

  { show coords }
  TDropSelectionAction = Class( TEzAction )
  Private
    FSelCentroid, FLastPos: TEzPoint;
    FDrawBoxWithSel: TEzBaseDrawBox;
    Procedure DrawSelectionRubberBanding(Sender: TObject=Nil);
  Protected
    Procedure MyKeyPress( Sender: TObject; Var Key: Char );
    Procedure MyPaint( Sender: TObject );
    Procedure MyMouseMove( Sender: TObject; Shift: TShiftState; X, Y: Integer;
      Const WX, WY: Double );
    Procedure MyMouseDown( Sender: TObject;
                           Button: TMouseButton;
                           Shift: TShiftState;
                           X, Y: Integer;
                           Const WX, WY: Double );
  Public
    Constructor CreateAction( CmdLine: TEzCmdLine );
  End;

  {----------------------------------------------------------------------------}
  //                  TAddMarkerAction
  {----------------------------------------------------------------------------}

    { add marker }
  TAddMarkerAction = Class( TEzAction )
  Private
    FMarker: TEzEntity;
    FNumSymbol: Integer;
    procedure SetCurrentPoint( Const Pt: TEzPoint );
  Protected
    Procedure MyMouseMove( Sender: TObject; Shift: TShiftState;
      X, Y: Integer; Const WX, WY: Double );
    Procedure MyKeyPress( Sender: TObject; Var Key: Char );
    Procedure MyMouseDown( Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer; Const WX, WY: Double );
    Procedure MyMouseUp( Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer; Const WX, WY: Double );
    Procedure MyPaint( Sender: TObject );
    Procedure SuspendOperation( Sender: TObject );
    Procedure ContinueOperation( Sender: TObject );
  Public
    Constructor CreateAction( CmdLine: TEzCmdLine );
    destructor Destroy; override;
  End;

  TAutoHandScrollAction = class(TEzAction)
  private
    FOrigin: TPoint;
    FDownX, FDownY: Integer;
    FScrolling: Boolean;
    FSavedShowWaitCursor: Boolean;
  protected
    procedure MyMouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer; const WX, WY: Double);
    procedure MyMouseUp(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer; const WX, WY: Double);
    procedure MyMouseMove(Sender: TObject; Shift: TShiftState; X, Y: Integer; const WX, WY: Double);
    procedure MyKeyPress(Sender: TObject; var Key: Char);
  public
    constructor CreateAction(CmdLine: TEzCmdLine);
    destructor Destroy; override;
    //
    procedure Finish();
  end;



  // used in trim, break, TEznetwork.CleanUpLayer() etc.
  PDistRec = ^TDistRec;
  TDistRec = Record
    D: Double;
    Index: Integer;
  End;

  TListImageKind = (liBitmaps, liBlocks, liAllImages);

Function SelectCommonElement(const Subdir, IniFilter: string;
  ListImageKind: TListImageKind): string;

  { main procedure used for executing an action on the command line control }
Function ExecCommand( M: TEzCmdLine; Const Cmd, ActionID: String ): Boolean;

{ miscelaneous procedures }
Function GetSnapPt( CmdLine: TEzCmdLine; Aperture: Integer;
  Setting: TEzOSNAPSetting; Const PivotLayerName: string;
  Var ALayer: TEzBaseLayer; Var ARecno: Integer;
  Var SnapPt: TEzPoint; Var IsSnappedPointOnEntity: Boolean;
  Var RefFrom, RefTo: TEzPoint ): Boolean;
Procedure QuickSortDistList( SortList: TList; L, R: Integer );
Function IsPointOnEntity( CmdLine: TEzCmdLine; Aperture: Integer;
  Const APt: TEzPoint; Ent: TEzEntity ): Boolean;
Function ActionAddNewEntity( CmdLine: TEzCmdLine; Var Entity: TEzEntity ) : Integer;
Function DoPolygonSelect( Polygon: TEzPolygon; cmdLine: TEzCmdLine ): Boolean;

Implementation

Uses
  Math, clipbrd, ezdims, EzPolyClip, EzBaseExpr, ezConsts, EzActionLaunch,
  EzRtree, ezbasicctrls, EzGisTiff, EzMiscelEntities, ezgraphics,
  fPictureDef, EzNetwork, EzPreview
{$IFDEF USE_RICHEDIT}
  , fRichEdit
{$ENDIF}
  ;


Function SelectCommonElement(const Subdir, IniFilter: string;
  ListImageKind: TListImageKind): string;
var
  OpenDialog: TOpenDialog;
begin
  Result:= '';
  OpenDialog:= TOpenDialog.Create(Nil);
  try
    if Length(IniFilter)>0 then
    begin
      //OpenDialog.DefaultExt:= DefaultExt;
      OpenDialog.Filter:= IniFilter;
    end else
    begin
    case ListImageKind of
      liBitmaps:
        OpenDialog.Filter:= SBandedImagesFilter;
      liAllImages:
        begin
          OpenDialog.Filter:= SBitmapFilter
{$IFDEF JPEG_SUPPORT}
            + '|' + SJPGFilter
{$ENDIF}
{$IFDEF GIF_SUPPORT}
            + '|' + SGIFFilter
{$ENDIF}
            + '|' + SMetafileFilter
            + '|' + SICOFilter
{$IFDEF USE_GRAPHICEX}
  {$IFDEF TIFFGraphic}
            + '|' + STIFFilter
  {$ENDIF}
  {$IFDEF TargaGraphic}
            + '|' + STargaFilter
  {$ENDIF}
  {$IFDEF PCXGraphic}
            + '|' + SPCXFilter
  {$ENDIF}
  {$IFDEF PCDGraphic}
            + '|' + SPCDFilter
  {$ENDIF}
{$IFNDEF GIF_SUPPORT}
  {$IFDEF GIFGraphic}
            + '|' + SGIFFilter
  {$ENDIF}
{$ENDIF}
  {$IFDEF PhotoshopGraphic}
            + '|' + SPSDFilter
  {$ENDIF}
  {$IFDEF PaintshopProGraphic}
            + '|' + SPSPFilter
  {$ENDIF}
  {$IFDEF PortableNetworkGraphic}
            + '|' + SPNGFilter
  {$ENDIF}

{$ENDIF}
            ;
        end;
        liBlocks:
          OpenDialog.Filter:= SEDBFilter;
      end;
    end;
    OpenDialog.InitialDir:= SubDir;
    OpenDialog.Options:= [ofPathMustExist, ofFileMustExist, ofNoChangeDir];
    repeat
      if not OpenDialog.Execute then exit;
      If AnsiCompareText( AddSlash(ExtractFilePath(OpenDialog.FileName)), SubDir) = 0 then
        Break;
      MessageToUser( SChangeDirNotAllowed, smsgerror, MB_ICONERROR );
    until False;
    Result:= OpenDialog.FileName;
  finally
    OpenDialog.Free;
  end;
end;

{this method is called by TEzCmdLine every time user types something in order
 to found if a command was issued
 Comment commands you don't want your end user can do}

Function ExecCommand( M: TEzCmdLine; Const Cmd, ActionID: String ): Boolean;
Var
  ent: TEzEntity;
  BlockName, s: String;
  ImageDims: TPoint;
  Lines: TStrings;

  Procedure SetPictureFileName( Var Entity: TEzEntity );
  Var
    Subd: String;
    GraphicLink: TEzGraphicLink;
  Begin
    With TfrmPict1.Create( Nil ) Do
    Try
      If Entity.EntityID In [idPictureRef, idBandsBitmap] Then
        Subd := Ez_Preferences.CommonSubDir
      Else
        Subd := '';
      If Not ( Enter( Entity.EntityID, '', Subd ) = mrOk ) Then
      Begin
        FreeAndNil( Entity );
        exit;
      End;
      ImageDims.X := ImageWidth;
      ImageDims.Y := ImageHeight;
      Case Entity.EntityID Of
        idPictureRef:
          Begin
            With TEzPictureRef( Entity ) Do
            Begin
              FileName := ExtractFileName( EditFileName );
            End;
          End;
        idPersistBitmap:
          Begin
            With TEzPersistBitmap( Entity ) Do
            Begin
              GraphicLink := TEzGraphicLink.Create;
              Try
                GraphicLink.ReadGeneric( EditFileName );
                Bitmap.Assign( GraphicLink.Bitmap );
              Finally
                GraphicLink.Free;
              End;
            End;
          End;
        idBandsBitmap:
          Begin
            TEzBandsBitmap( Entity ).FileName := ExtractFileName( EditFileName );
          End;
      End;
    Finally
      Free;
    End;
  End;

var
  I: Integer;
Begin
  result := true;
  Assert( ( M.ActiveDrawBox <> Nil ) And ( M.ActiveDrawBox.GIS <> Nil ) );
  If Cmd = SCmdCircle2P Then
    M.Push( TDrawCircleAction.CreateAction( M, ct2P ), true, Cmd, ActionID )
  Else If Cmd = SCmdArcSE Then
    M.Push( TDrawArcAction.CreateAction( M ), true, Cmd, ActionID )
  Else If Cmd = SCmdArcFCS Then
    M.Push( TDrawArcAction.CreateAction( M, damFCS ), true, Cmd, ActionID )
  Else If Cmd = SCmdCircle2P Then
    M.Push( TDrawCircleAction.CreateAction( M, ct2P ), true, Cmd,ActionID )
  Else If Cmd = SCmdCircle3P Then
    M.Push( TDrawCircleAction.CreateAction( M, ct3P ), true, Cmd,ActionID )
  Else If Cmd = SCmdCircleCR Then
    M.Push( TDrawCircleAction.CreateAction( M, ctCR ), true, Cmd,ActionID )
  Else If Cmd = SCmdRichText Then
  Begin
    { rich text }
    Lines := TStringList.Create;
    Try
      Ent := TEzRtfText.CreateEntity( Point2D(0, 0), Point2D(0, 0), Lines );
{$IFDEF USE_RICHEDIT}
      TfrmRichTextEditor.Enter( Ent );
{$ENDIF}
      M.Push( TAddEntityAction.CreateAction( M, ent, ImageDims ), true, Cmd,ActionID );
    Finally
      Lines.Free;
    End;
  End
  Else If Cmd = SCmdMeasures Then
    { MEASURES - command }
    M.Push( TMeasuresAction.CreateAction( M ), true, Cmd, ActionID )
  Else If Cmd = SCmdDimHoriz Then
  Begin
    { DIMHORZ - command }
    ent := TEzDimHorizontal.CreateEntity( Point2D(0, 0), Point2D(0, 0), 0 );
    M.Push( TDimAction.CreateAction( M, ent ), true, Cmd,ActionID );
  End
  Else If Cmd = SCmdDimVert Then
  Begin
    { DIMHORZ - command }
    ent := TEzDimVertical.CreateEntity( Point2D(0, 0), Point2D(0, 0), 0 );
    M.Push( TDimAction.CreateAction( M, ent ), true, Cmd,ActionID )
  End
  Else If Cmd = SCmdDimParall Then
  Begin
    { DIMPARALL - command }
    ent := TEzDimParallel.CreateEntity( Point2D(0, 0), Point2D(0, 0), 0 );
    M.Push( TDimAction.CreateAction( M, ent ), true, Cmd,ActionID )
  End
  Else If Cmd = SCmdBreak Then
    { BREAK - command }
    M.Push( TBreakAction.CreateAction( M ), true, Cmd,ActionID )
  Else If Cmd = SCmdTrim Then
    { TRIM - command }
    M.Push( TTrimAction.CreateAction( M ), true, Cmd,ActionID )
  Else If Cmd = SCmdExtend Then
    { EXTEND - command }
    M.Push( TExtendAction.CreateAction( M ), true, Cmd,ActionID )
  Else If Cmd = SCmdFillet Then
    { FILLET - command }
    M.Push( TFilletAction.CreateAction( M ), true, Cmd, ActionID )
  Else If Cmd = SCmdDropSelection Then
    { DROPSELECTION - command }
    M.Push( TDropSelectionAction.CreateAction( M ), true, Cmd, ActionID )
  Else If Cmd = SCmdCustomClick Then
    { CUSTOMCLICK - command }
    M.Push( TCustomClickAction.CreateAction( M ), true, Cmd, ActionID )
  Else If Cmd = SCmdAddMarker Then
    { MARKER - command }
    M.Push( TAddMarkerAction.CreateAction( M ), true, Cmd, ActionID )
  Else If Cmd = SCmdRealTimeZoom Then
    { REALTIMEZOOM - command                     True = use thread }
    M.Push( TRealTimeZoomAction.CreateAction( M, False ), false, Cmd, ActionID )
  Else If Cmd = SCmdRealTimeZoomB Then
    { REALTIMEZOOMB - command }
    M.Push( TRealTimeZoomActionB.CreateAction( M ), false, Cmd, ActionID )
  Else If Cmd = SCmdPolygonSelect Then
    { POLYGONSEL - command }
    M.Push( TPolygonSelectAction.CreateAction( M ), false, Cmd, ActionID )
  Else If Cmd = SCmdZoomIn Then
    { ZOOMIN - command }
    M.Push( TZoomInOutAction.CreateAction( M, zaZoomIn ), false, Cmd, ActionID )
  Else If Cmd = SCmdZoomOut Then
    { ZOOMOUT - command }
    M.Push( TZoomInOutAction.CreateAction( M, zaZoomOut ), false, Cmd, ActionID )
  Else If Cmd = SCmdZoomWindow Then
    { ZOOMWIN - command }
    M.Push( TZoomWindowAction.CreateAction( M ), false, Cmd, ActionID )
  Else If Cmd = SCmdHandScroll Then
    { SCROLL - command }
    M.Push( THandScrollAction.CreateAction( M ), false, Cmd, ActionID )
  Else If Cmd = SCmdCircleSelect Then
    { CIRCLESEL - command }
    M.Push( TCircleSelectAction.CreateAction( M ), false, Cmd, ActionID )
  Else If Cmd = SCmdInsertVertex Then
    { INSERTVERTEX - command }
    M.Push( TInsertVertexAction.CreateAction( M ), false, Cmd, ActionID )
  Else If Cmd = SCmdSelPLine Then
    { SELPLINE - command }
    M.Push( TBufferSelectAction.CreateAction( M ), false, Cmd, ActionID )
  Else If Cmd = SCmdGridOrigin Then
    { GRIDORIGIN - command }
    M.Push( TChangeGridOriginAction.CreateAction( M ), false, Cmd, ActionID )
  Else If Cmd = SCmdSelect Then
    { SELECT - command }
    M.Push( TSelectAction.CreateAction( M,
      Ez_Preferences.ApertureWidth ), false, Cmd, ActionID )
  Else If Cmd = SCmdHints Then
    { HINTS - command }
    M.Push( TShowHintAction.CreateAction( M ), false, Cmd, ActionID )
  Else If Cmd = SCmdMirror Then
    { MIRROR - command }
    M.Push( TTransformSelectionAction.CreateAction( M, ttMirror, false, saBoth ), true, Cmd, ActionID )
  Else If Cmd = SCmdOffset Then
    { OFFSET - command }
    M.Push( TTransformSelectionAction.CreateAction( M, ttTranslate, true, saBoth ), true, Cmd, ActionID )
  Else If Cmd = SCmdMove Then
    { MOVE - command }
    M.Push( TTransformSelectionAction.CreateAction( M, ttTranslate, false, saBoth ), true, Cmd, ActionID )
  Else If Cmd = SCmdScale Then
    { SCALE - command }
    M.Push( TTransformSelectionAction.CreateAction( M, ttScale, false, saBoth ), true, Cmd, ActionID )
  Else If Cmd = SCmdScaleX Then
    { SCALE - command }
    M.Push( TTransformSelectionAction.CreateAction( M, ttScale, false, saX ), true, Cmd, ActionID )
  Else If Cmd = SCmdScaleY Then
    { SCALE - command }
    M.Push( TTransformSelectionAction.CreateAction( M, ttScale, false, saY ), true, Cmd, ActionID )
  Else If Cmd = SCmdRotate Then
    { ROTATE - command }
    M.Push( TTransformSelectionAction.CreateAction( M, ttRotate, false, saBoth ), true, Cmd, ActionID )
  Else If Cmd = SCmdReshape Then
    { RESHAPE - command }
    M.Push( TReshapeEntityAction.CreateAction( M, Ez_Preferences.ApertureWidth ), true, Cmd, ActionID )
  Else If Cmd = SCmdRotateText Then
    { RESHAPE - command }
    M.Push( TRotateTextAction.CreateAction( M, Ez_Preferences.ApertureWidth ), true, Cmd, ActionID )
  Else If Cmd = SCmdDragDrop Then
    { DRAG&DROP - command }
    M.Push( TDragDropAction.CreateAction( M, Ez_Preferences.ApertureWidth ), true, Cmd, ActionID )
  Else If Cmd = SCmdDeleteVertex Then
    { DELVERTEX - command }
    M.Push( TDeleteVertexAction.CreateAction( M ), true, Cmd, ActionID )
  Else If Cmd = SCmdPictRef Then
  Begin
    { PICTUREREF - command }
    { ask end-user for the picture }
    ent := TEzPictureRef.CreateEntity( Point2D(0, 0), Point2D(0, 0), '' );
    SetPictureFileName( ent );
    If ent = Nil Then
      Exit;
    { if the position was defined, add to the layer and exit }
    If Not EqualRect2D( NULL_EXTENSION, ent.Points.Extension ) Then
    Begin
      ActionAddNewEntity( M, ent );
      exit;
    End;
    M.Push( TAddEntityAction.CreateAction( M, ent, ImageDims ), true, Cmd, ActionID );
  End
  Else If Cmd = SCmdPersistBitmap Then
  Begin
    { PERSISTBITMAP - command }
    ent := TEzPersistBitmap.CreateEntity( Point2D(0, 0), Point2D(0, 0), '' );
    SetPictureFileName( ent );
    If ent = Nil Then exit;
    { if the position was defined, add to the layer and exit }
    If Not EqualRect2D( NULL_EXTENSION, ent.Points.Extension ) Then
    Begin
      ActionAddNewEntity( M, ent );
      exit;
    End;
    M.Push( TAddEntityAction.CreateAction( M, ent, ImageDims ), true, Cmd, ActionID );
  End
  Else If Cmd = SCmdCustomPicture Then
  Begin
    ent := TEzCustomPicture.CreateEntity( Point2D(0, 0), Point2D(0, 0) );
    M.Push( TAddEntityAction.CreateAction( M, ent, ImageDims ), true, Cmd, ActionID );
  End
  Else If Cmd = SCmdBandsBitmap Then
  Begin
    { BANDSBITMAP - command }
    ent := TEzBandsBitmap.CreateEntity( Point2D(0, 0), Point2D(0, 0), '' );
    SetPictureFileName( ent );
    If ent = Nil Then exit;
    { if the position was defined, add to the layer and exit }
    If Not EqualRect2D( NULL_EXTENSION, ent.Points.Extension ) Then
    Begin
      ActionAddNewEntity( M, ent );
      exit;
    End;
    M.Push( TAddEntityAction.CreateAction( M, ent, ImageDims ), true, Cmd, ActionID );
  End
  Else If Cmd = SCmdInsert Then
  Begin
    { block INSERT - command }
    BlockName:= SelectCommonElement( AddSlash(Ez_Preferences.CommonSubDir),
      '', liBlocks);
    If Length(Blockname)=0 then Exit;
    M.Push( TAddEntityAction.CreateAction( M,
      TEzBlockInsert.CreateEntity( BlockName, Point2D(0, 0), 0.0, 1.0, 1.0 ),
      ImageDims ), true, Cmd, ActionID );
  End Else If Cmd = SCmdNode Then
  Begin
    { NODE - command }
    M.Push( TAddEntityAction.CreateAction( M,
      TEzNode.CreateEntity( Point2D(0, 0) ), ImageDims ), true, Cmd, ActionID )
  End Else If Cmd = SCmdNodeLink Then
  Begin
    { NODELINK - command }
    // 24 = the OsnapSize in pixels
    M.Push( TAddNodeLinkAction.CreateAction( M, 24 ), true, Cmd, ActionID );
  End Else If Cmd = SCmdPoint Then
    { POINT - command }
    M.Push( TAddEntityAction.CreateAction( M,
      TEzPointEntity.CreateEntity( Point2D(0, 0), clblack ), ImageDims ), true, Cmd, ActionID )
  Else If Cmd = SCmdLine Then
  Begin
    { LINE - command }
    ent:= TEzPolyLine.CreateEntity( [Point2D(0, 0), Point2D(0, 0)] );
    ent.Points.CanGrow:= false;
    M.Push( TAddEntityAction.CreateAction( M, ent, ImageDims ), true, Cmd, ActionID );
  End
  Else If Cmd = SCmdPolyline Then
    { PLINE - command }
    M.Push( TAddEntityAction.CreateAction( M,
      TEzPolyLine.CreateEntity( [Point2D(0, 0)] ), ImageDims ), true, Cmd, ActionID )
  Else If Cmd = SCmdSketch Then
    { SKETCH - command }
    M.Push( TSketchAction.CreateAction( M,
      TEzPolyLine.CreateEntity( [Point2D(0, 0)] ) ), true, Cmd, ActionID )
  Else If Cmd = SCmdPolygon Then
    { POLYGON - command }
    M.Push( TAddEntityAction.CreateAction( M,
      TEzPolygon.CreateEntity( [Point2D(0, 0)] ), ImageDims ), true, Cmd, ActionID )
  Else If Cmd = SCmdArc Then
    { ARC - command }
    M.Push( TAddEntityAction.CreateAction( M,
      TEzArc.CreateEntity( Point2D(0, 0), Point2D(0, 0), Point2D(0, 0) ), ImageDims ), true, Cmd, ActionID )
  Else If Cmd = SCmdEllipse Then
    { ELLIPSE - command }
    M.Push( TAddEntityAction.CreateAction( M,
      TEzEllipse.CreateEntity( Point2D(0, 0), Point2D(0, 0) ), ImageDims ), true, Cmd, ActionID )
  Else If Cmd = SCmdSpline Then
    { SPLINE - command }
    M.Push( TAddEntityAction.CreateAction( M,
      TEzSpline.CreateEntity( [Point2D(0, 0)] ), ImageDims ), true, Cmd, ActionID )
  Else If Cmd = SCmdRectangle Then
    { RECTANGLE - command }
    M.Push( TAddEntityAction.CreateAction( M,
      TEzRectangle.CreateEntity( Point2D(0, 0), Point2D(0, 0) ), ImageDims ), true, Cmd, ActionID )
  Else If Cmd = SCmdTable Then
    { TABLE - command }
    M.Push( TAddEntityAction.CreateAction( M,
      TEzTableEntity.CreateEntity( Point2D(0, 0), Point2D(0, 0) ), ImageDims ), true, Cmd, ActionID )
  Else If Cmd = SCmdSymbol Then
    { SYMBOL - command }
    M.Push( TAddEntityAction.CreateAction( M,
      TEzPlace.CreateEntity( Point2D(0, 0) ), ImageDims ), true, Cmd, ActionID )
  Else If Cmd = SCmdTextSymbol Then
  Begin
    { TEXTSYMBOL - command }
    ent := TEzPlace.CreateEntity( Point2D(0, 0) );
    S := InputBox( SSymbolTextCaption, SSymbolText, '' );
    If Length( s ) = 0 Then
    Begin
      FreeAndNil( ent );
      exit;
    End;
    TEzPlace( ent ).Text := S;
    M.Push( TAddEntityAction.CreateAction( M, ent, ImageDims ), true, Cmd, ActionID );
  End
  Else If Cmd = SCmdUndo Then
    { UNDO - command }
    M.CurrentAction.UndoOperation
  Else If Cmd = SCmdPan Then
    { PAN - command }
    M.Push( TPanningAction.CreateAction( M ), false, Cmd, ActionID )
  Else If Cmd = SCmdPolygonBuffer Then
    { POLYGONBUFFER - command }
    M.Push( TPolygonFromBufferAction.CreateAction( M ), True, Cmd, ActionID )
      //else if Cmd = SCmdDIM then
      { DIM - command }
    //  M.Push(TDimAlignedAction.CreateAction(nil,M), True, Cmd, ActionID)
  Else If Cmd = SCmdHorzGLine Then
    { HGLINE - command }
    M.Push( TGuideLineAction.CreateAction( M, 0 ), true, Cmd, ActionID )
  Else If Cmd = SCmdVertGLine Then
    { VGLINE - command }
    M.Push( TGuideLineAction.CreateAction( M, 1 ), true, Cmd, ActionID )
  Else If Cmd = SCmdZoomAll Then
  Begin
    M.ActiveDrawBox.ZoomToExtension;
    M.Clear;
  End
  Else If Cmd = SCmdText Then
    { TRUE TYPE text command }
    M.Push( TAddTextAction.CreateAction( M ), true, Cmd, ActionID )
  Else If Cmd = SCmdJustifText Then
    { JUSTIFTEXT command }
    M.Push( TAddVectorialTextAction.CreateAction( M, Nil, true, tbsNone ), true, Cmd, ActionID )
  Else If Cmd = SCmdFittedText Then
    { FITTEDTEXT command }
    M.Push( TAddVectorialTextAction.CreateAction( M, Nil, false, tbsNone ), true, Cmd, ActionID )
  Else If Cmd = SCmdBannerText Then
    { BANNER command }
    M.Push( TAddVectorialTextAction.CreateAction( M, Nil, false, tbsBanner ), true, Cmd, ActionID )
  Else If Cmd = SCmdCalloutText Then
    { CALLOUT command }
    M.Push( TAddVectorialTextAction.CreateAction( M, Nil, false, tbsCallout ), true, Cmd, ActionID )
  Else If Cmd = SCmdBulletLeader Then
    { BULLETLEADER command }
    M.Push( TAddVectorialTextAction.CreateAction( M, Nil, false, tbsBulletLeader ), true, Cmd, ActionID )
  Else If Cmd = SCmdMoveGLine Then
    { VGLINE - command }
    M.Push( TMoveGuideLineAction.CreateAction( M ), true, Cmd, ActionID )
  Else If Cmd = SCmdClipPoly Then
    { CLIP - command }
    M.Push( TClipPolyAction.CreateAction( M ), true, Cmd, ActionID )
  Else If Cmd = SCmdSetClipArea Then
    { SETCLIPAREA - command }
    M.Push( TSetClipAreaAction.CreateAction( M ), True, Cmd, ActionID )
  Else If Cmd = SCmdSetClipPolyArea Then
    { CLIPPOLYAREA - command }
    M.Push( TSetPolygonClipAreaAction.CreateAction( M ), True, Cmd, ActionID )
  Else if Cmd = 'EDITTEXT' then
  begin
    I := 0;
    TryStrToInt(ActionID, I);
    M.Push( TEditTextAction.CreateAction(M, I), True, Cmd, ActionID );
  end
  Else If Cmd = SCmdText500 Then
  begin
    I := 0;
    TryStrToInt(ActionID, I);
    M.Push( TAddText500Action.CreateAction( M, I ), true, Cmd, ActionID );
  end
  else
    { command not found !!! }
    result := false;
End;

{ Utilities }

Function IsPointOnEntity( CmdLine: TEzCmdLine; Aperture: Integer;
  Const APt: TEzPoint; Ent: TEzEntity ): Boolean;
Var
  MinDist, Distance, NewAperture: Double;
  RealAperture: TEzPoint;
  TmpNPoint: Integer;
Begin
  Aperture := Aperture Div 2;
  With CmdLine.ActiveDrawBox Do
    RealAperture := Point2D( Grapher.DistToRealX( Aperture ), Grapher.DistToRealY( Aperture ) );
  If RealAperture.X > RealAperture.Y Then
    NewAperture := RealAperture.X
  Else
    NewAperture := RealAperture.Y;
  NewAperture := Sqrt( 2 ) * NewAperture;
  MinDist := NewAperture;
  TmpNPoint := Ent.PointCode( APt, MinDist, Distance, True );
  If ( TmpNPoint >= PICKED_INTERIOR ) And ( Distance <= MinDist ) Then
    Result := True
  Else
    Result := False;
End;

Function PointOnLine( Const CX, CY, AX, AY, BX, BY: Double ): TEzPoint;
Var
  r, L: Double;
Begin
  L := Dist2D( Point2D( AX, AY ), Point2D( BX, BY ) );
  If L = 0 Then
    Exit;
  r := ( ( CX - AX ) * ( BX - AX ) + ( CY - AY ) * ( BY - AY ) ) / ( L * L );
  Result.X := AX + r * ( BX - AX );
  Result.Y := AY + r * ( BY - AY );
End;

{ returns true if an entity is found inside Polygon }

Function DoPolygonSelect( Polygon: TEzPolygon; cmdLine: TEzCmdLine ): Boolean;
Var
  EntityID: TEzEntityID;
  TmpClass: TEzEntityClass;
  TmpEntity: TEzEntity;
  I: Integer;
  TmpLayer: TEzBaseLayer;
  SelExtent, Extent, MyVisualWindow: TEzRect;
  SearchType: TSearchType;
  IsAltPressed: Boolean;
  Saved:TCursor;
Begin
  Result := false;
  With cmdLine.ActiveDrawBox Do
  Begin
    MyVisualWindow := Grapher.CurrentParams.VisualWindow;
    With GIS.MapInfo Do
    Begin
      If IsAreaClipped Then
      Begin
        With MyVisualWindow Do
        Begin
          If Emin.X < AreaClipped.Emin.X Then
            Emin.X := AreaClipped.Emin.X;
          If Emin.Y < AreaClipped.Emin.Y Then
            Emin.Y := AreaClipped.Emin.Y;
          If Emax.X > AreaClipped.Emax.X Then
            Emax.X := AreaClipped.Emax.X;
          If Emax.Y > AreaClipped.Emax.Y Then
            Emax.Y := AreaClipped.Emax.Y;
        End;
      End;
    End;
    SelExtent := ezlib.INVALID_EXTENSION;
    IsAltPressed := ( GetAsyncKeyState( VK_menu ) Shr 1 ) <> 0;
    Selection.BeginUpdate;
    Saved:=Screen.Cursor;
    Screen.Cursor:= crHourglass;
    Try
      For I := 0 To GIS.Layers.Count - 1 Do
      Begin
        TmpLayer := GIS.Layers[I];
        With TmpLayer Do
        Begin
          If Not LayerInfo.Visible Then
            Continue;
          If Not LayerInfo.Selectable Then
            Continue;
          With Grapher.CurrentParams Do
          Begin
            If PartialSelect Then
              SearchType := stOverlap
            Else
              SearchType := stEnclosure;

            SetGraphicFilter( Searchtype, Polygon.FBox );

            First;
            StartBuffering;
            Try
              While Not Eof Do
              Begin
                Try
                  Extent := RecExtension;
                  If RecIsDeleted Or
                    Not IsBoxInBox2D( Extent, MyVisualWindow ) Or
                    Not IsBoxInBox2D( Extent, Polygon.FBox ) Then Continue;
                  { Verify if entity extension is inside Polygon extension }
                  EntityID := RecEntityID;
                  If EntityID In NoPickFilter Then Continue;
                  TmpClass := GetClassFromID( EntityID );
                  TmpEntity := TmpClass.Create( 1 );
                  RecLoadEntity2( TmpEntity );
                  Try
                    If TmpEntity.IsInsideEntity( Polygon, Not PartialSelect ) Then
                    Begin
                      If Not IsAltPressed Then
                        Selection.Add( TmpLayer, Recno )
                      Else
                        Selection.Delete( TmpLayer, Recno );
                      MaxBound( SelExtent.Emax, Extent.Emax );
                      MinBound( SelExtent.Emin, Extent.Emin );
                      result := true;
                    End;
                  Finally
                    TmpEntity.Free;
                  End;
                Finally
                  Next;
                End;
              End;
            Finally
              EndBuffering;
              CancelFilter;
            End;
          End;
        End;
      End;
      If Not EqualRect2D( SelExtent, INVALID_EXTENSION ) Then
        cmdLine.All_RepaintRect( SelExtent );
    Finally
      Selection.EndUpdate;
      Screen.Cursor:= Saved;
    End;
  End;
End;

// Add current inserting entity to the map. Returns the recno of the entity added

Function ActionAddNewEntity( CmdLine: TEzCmdLine; Var Entity: TEzEntity ) : Integer;
Var
  Accept: Boolean;
  TmpLayer: TEzBaseLayer;
  Extents: TEzRect;
  MinDim: Double;

Begin

  If Entity.EntityID = idPreview Then
  Begin
    With TEzPreviewEntity( Entity ) Do
    Begin
      CalculateScales( ProposedPrintArea );
    End;
  End;

  With CmdLine.ActiveDrawBox Do
  Begin
    Accept := True;
    TmpLayer := GIS.CurrentLayer;
    If Assigned( OnBeforeInsert ) Then
      OnBeforeInsert( CmdLine.ActiveDrawBox, TmpLayer, Entity, Accept );
    Result := 0;
    If Accept Then
      Result := AddEntity( GIS.CurrentLayerName, Entity );
    { the current layer could be changed on the OnBeforeInsert event}
    TmpLayer := GIS.CurrentLayer;
    If Accept And Assigned( OnAfterInsert ) Then
      OnAfterInsert( CmdLine.ActiveDrawBox, TmpLayer, Result );
    cmdLine.All_Refresh;
    Extents := Entity.FBox;
    FreeAndNil( Entity );
    {Repaint only the affected area}
    MinDim := CmdLine.ActiveDrawBox.Grapher.DistToRealY( 5 );
    InflateRect2D( Extents, MinDim, MinDim );
    cmdLine.All_RepaintRect( Extents );
  End;
End;

{----------------------------------------------------------------------------}
//                  TTheDefaultAction - class implementation
{----------------------------------------------------------------------------}

Constructor TTheDefaultAction.CreateAction( CmdLine: TEzCmdLine );
Begin
  Inherited CreateAction( CmdLine );
  FAperture := 4;
  OnKeyPress := MyKeyPress;
  OnMouseDown := MyMouseDown;
  OnMouseMove := MyMouseMove;
  OnMouseUp := MyMouseUp;
  OnDblClick := MyDblClick;
End;

Destructor TTheDefaultAction.Destroy;
Begin
  If FStackedSelList <> Nil Then
  begin
    FStackedSelList.Free;
  end;
  Inherited Destroy;
End;

function TTheDefaultAction.FindStackEntitiesInSelection: Boolean;
var
  I: Integer;
  Layer: TezBaseLayer;
  Recno: Integer;
begin
  Result := False;
  if Assigned(FStackedSelList) then
    with CmdLine.ActiveDrawBox do
    begin
      for I := 0 to FStackedSelList.Count - 1 do
      begin
        Layer := GIS.Layers.LayerByName(FStackedSelList[I]);
        Recno := Integer(FStackedSelList.Objects[I]);
        if Selection.IsSelected(Layer, Recno) then
        begin
          Result := True;
          Exit;
        end;
      end;
    end;
end;

{$IFDEF BCB}
function TTheDefaultAction.GetSelectDenied: Boolean;
begin
  Result := FSelectDenied;
end;

procedure TTheDefaultAction.SetSelectDenied(const Value: Boolean);
begin
  FSelectDenied := Value;
end;
{$ENDIF}

Procedure TTheDefaultAction.MyMouseDown( Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer; Const WX, WY: Double );
Var
  CurrPoint: TEzPoint;
  TmpLayer, PrevLayer: TEzBaseLayer;
  I, TmpRecNo, PrevRecno, PrevSelCount, N: Integer;
  FPickedPoint: Integer;
  Picked: Boolean;
  OldExtension, IntersRect, NewExtension: TEzRect;
Begin
  If ( Button = mbRight ) Or FSelectDenied Then
    Exit;
  PrevSelCount := 0;
  PrevLayer := Nil;
  PrevRecno := 0;
  With CmdLine.ActiveDrawBox Do
  Begin
    CurrPoint := CmdLine.CurrentPoint;
    If StackedSelect Then
    Begin
      If FStackedSelList = Nil Then
        FStackedSelList := TStringList.Create
      Else
        FStackedSelList.Clear;
      PrevSelCount := Selection.NumSelected;
      If PrevSelCount = 1 Then
      Begin
        PrevLayer := Selection[0].Layer;
        if Assigned(Selection[0]) and Assigned(Selection[0].SelList)
           and (Selection[0].SelList.Count > 0) then
          PrevRecno := Selection[0].SelList[0]
        else
          Exit;
      End;
    End
    Else
    If FStackedSelList <> Nil Then
      FreeAndNil( FStackedSelList );
    Picked := PickEntity( CurrPoint.X, CurrPoint.Y, FAperture, '', TmpLayer,
      TmpRecNo, FPickedPoint, Self.FStackedSelList );
    OldExtension:= NULL_EXTENSION;
    If Not ( ssShift In Shift ) Then
    Begin
      If Selection.Count > 0 Then
      Begin
        if (not Picked) or (not FindStackEntitiesInSelection) then
        begin
          OldExtension := Selection.GetExtension;
          Selection.Clear;
        end
        else
        begin
          if Picked then
          begin
            FCanMove := True;
            FMoveStartPoint := Point(X, Y);
            FMoveStartPoint2D := Point2D(WX, WY);
            Exit;
          end;
        end;
      End;
    End;
    If Picked Then
    Begin
      If ( FStackedSelList <> Nil ) And ( PrevSelCount = 1 ) And ( FStackedSelList.Count > 1 ) Then
      Begin
        For I := 0 To FStackedSelList.Count - 1 Do
        Begin
          If ( PrevLayer = GIS.Layers.LayerByName( FStackedSelList[I] ) ) And
            ( PrevRecno = Longint( FStackedSelList.Objects[I] ) ) Then
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
      If ssShift In Shift Then
      Begin
        If Selection.IsSelected( TmpLayer, TmpRecNo ) Then
        Begin
          NewExtension := Selection.GetExtension;
          Selection.Delete( TmpLayer, TmpRecNo );
        End
        Else
        Begin
          Selection.Add( TmpLayer, TmpRecNo );
          NewExtension:= Selection.GetExtension;
        End;
      End
      Else
      Begin
        Selection.Add( TmpLayer, TmpRecNo );
        NewExtension:= Selection.GetExtension;
      End;
      if ( Selection.Count = 1 ) And (Selection.NumSelected = 1) then
      Begin
        CmdLine.StatusMessage:= Format( SOneSelection, [Selection[0].Layer.Name, Selection[0].SelList[0]] );
      End 
      Else
        CmdLine.StatusMessage:= Format( SMultiSelection, [Selection.NumSelected] );
      If Not IsRectEmpty2D(OldExtension) Then
      Begin
        IntersRect := IntersectRect2d( OldExtension, NewExtension );
        If Not IsRectEmpty2D(IntersRect) Then
        Begin
          { if they intersect, then obtain the union of two boxes }
          RepaintRect( BoxOutBox2d(OldExtension, NewExtension) );
        End 
        Else
        Begin
          RepaintRect( OldExtension );
          RepaintRect( NewExtension );
        End;
      End 
      Else
      Begin
        RepaintRect( NewExtension );
      End;
    End 
    Else If Not IsRectEmpty2D(OldExtension) Then
    Begin
      RepaintRect( OldExtension );
    End ;
  End;
End;

procedure TTheDefaultAction.MyMouseMove(Sender: TObject; Shift: TShiftState;
  X, Y: Integer; const WX, WY: Double);
begin
  if FCanMove and CmdLine.AutoMoveEnabled then
    if not PointsEqual(FMoveStartPoint, Point(X, Y)) then
    begin
      CmdLine.Push(TAutoMoveAction.CreateAction(CmdLine), False, '', '');
      CmdLine.CurrentAction.OnMouseDown(CmdLine.ActiveDrawBox, mbLeft, [], X, Y, WX, WY);
    end;
  FCanMove := False;
end;

procedure TTheDefaultAction.MyMouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer; const WX, WY: Double);
begin
  FCanMove := False;
end;

Procedure TTheDefaultAction.MyDblClick( Sender: TObject );
Var
  Processed: Boolean;
Begin
  With CmdLine.ActiveDrawBox Do
    If Assigned( OnEntityDblClick ) And ( Selection.NumSelected = 1 ) Then
    Begin
      Processed := true;
      OnEntityDblClick( CmdLine.ActiveDrawBox, Selection[0].Layer,
        Selection[0].SelList[0], Processed );
    End;
End;

Procedure TTheDefaultAction.MyKeyPress( Sender: TObject; Var Key: Char );
Var
  CurrExtension: TEzRect;
Begin
  If Key = #27 Then
  Begin
    With CmdLine Do
    Begin
      {Clear all selected entities}
      With ActiveDrawBox Do
        If ( Selection.Count > 0 ) And Not FSelectDenied Then
        Begin
          CurrExtension := Selection.GetExtension;
          Selection.Clear;
          If Not EqualRect2D( CurrExtension, INVALID_EXTENSION ) Then
            RepaintRect( CurrExtension );
        End;
      ActiveDrawBox.Cursor := crDefault;
      StatusMessage:= '';
    End;
  End;
  FCanMove := False;
End;

{----------------------------------------------------------------------------}
//                  TZoomWindowAction
{----------------------------------------------------------------------------}

Constructor TZoomWindowAction.CreateAction( CmdLine: TEzCmdLine );
Begin
  Inherited CreateAction( CmdLine );

  CanBeSuspended := True;

  Self.MouseDrawElements:= [mdCursor, mdFullViewCursor];

  FFrame := TEzRectangle.CreateEntity( Point2D(0, 0), Point2D(0, 0) );
  FOuterFrame := TEzRectangle.CreateEntity( Point2D(0, 0), Point2D(0, 0) );
  FAuxLine:= TEzPolyline.CreateEntity([Point2d(0,0),Point2d(0,0)]);

  OnMouseDown := MyMouseDown;
  OnMouseUp := MyMouseUp;
  OnMouseMove := MyMouseMove;
  OnPaint := MyPaint;
  OnKeyPress := MyKeyPress;

  WaitingMouseClick := True;

  Cursor := crDrawCross;

  Caption := SDefineFirstZoomPoint;
End;

Destructor TZoomWindowAction.Destroy;
Begin
  FFrame.Free;
  FOuterFrame.Free;
  FAuxLine.Free;
  Caption := '';
  Inherited Destroy;
End;

Procedure TZoomWindowAction.DrawRubbers(Sender: TObject=Nil);
var
  TmpWin, TestWin: TEzRect;
Begin
  If FIsZooming Then Exit;
  TmpWin:= ReorderRect2d( FFrame.FBox );
  TestWin:= ReorderRect2d( FOuterFrame.FBox );

  With CmdLine do
  Begin
    If TmpWin.X1 <> TestWin.X1 Then
    Begin
      FAuxLine.Points[0] := TmpWin.Emin;
      FAuxLine.Points[1] := Point2d(TmpWin.X1, TmpWin.Y2);
      If Sender=Nil Then
        All_DrawEntity2DRubberBand( FAuxLine )
      Else
        (Sender As TEzBaseDrawbox).DrawEntity2DRubberBand( FAuxLine )
    End;

    If TmpWin.X2 <> TestWin.X2 Then
    Begin
      FAuxLine.Points[0] := Point2d(TmpWin.X2, TmpWin.Y1);
      FAuxLine.Points[1] := TmpWin.Emax;
      If Sender=Nil Then
        All_DrawEntity2DRubberBand( FAuxLine )
      Else
        (Sender As TEzBaseDrawbox).DrawEntity2DRubberBand( FAuxLine )
    End;
    If Sender=Nil Then
      All_DrawEntity2DRubberBand( FOuterFrame )
    Else
      (Sender As TEzBaseDrawbox).DrawEntity2DRubberBand( FOuterFrame );
  End;
End;

Procedure TZoomWindowAction.SetCurrentPoint( Const Pt: TEzPoint );
Var
  I: Integer;
  f1, f2, Dx, Dy, Hx, Hy, Factor: Double;
  TmpWin, NewWin, CurrWin: TEzRect;
Begin
  FFrame.Points[FCurrentIndex] := Pt;
  For I := FCurrentIndex + 1 To FFrame.Points.Count - 1 Do
    FFrame.Points[I] := Pt;
  If FCurrentIndex > 0 Then
  Begin
    // build the outer frame
    TmpWin:= ReorderRect2d( FFrame.FBox );
    CurrWin:= CmdLine.ActiveDrawBox.Grapher.CurrentParams.VisualWindow;
    Dx := TmpWin.X2 - TmpWin.X1;
    Dy := TmpWin.Y2 - TmpWin.Y1;
    Hx := Abs( CurrWin.Emax.X - CurrWin.Emin.X );
    Hy := Abs( CurrWin.Emax.Y - CurrWin.Emin.Y );
    f1 := Dx / Hx;
    f2 := Dy / Hy;
    If f1 > f2 Then
      Factor := f1
    Else
      Factor := f2;
    NewWin.Emin.X := TmpWin.X1 - ( Hx * Factor - Dx ) / 2;
    NewWin.Emax.Y := TmpWin.Y2;
    NewWin.Emax.X := NewWin.Emin.X + Hx * Factor;
    NewWin.Emin.Y := NewWin.Emax.Y - Hy * Factor;

    FOuterFrame.Points[0]:= NewWin.Emin;
    FOuterFrame.Points[1]:= NewWin.Emax;
  End;
  If FCurrentIndex = 0 Then
    WaitingMouseClick := False;
End;

Procedure TZoomWindowAction.DoFinishZooming;
Var
  TmpRect2D, PreviewArea, MapDrawingArea, NewMapArea: TEzRect;
  Picked: Boolean;
  Layer: TEzBaseLayer;
  Recno1, Recno2: Integer;
  PickedPoint: Integer;
  P1, P2: TEzPoint;
  Ent: TEzEntity;
  factor, factorx, factory, DrawingScale,
  MapAreaWidth, MapAreaHeight,
  PaperAreaWidth, PaperAreaHeight: Double;
Begin
  DrawRubbers;
  TmpRect2D.Emin := FFrame.Points[0];
  TmpRect2D.Emax := FFrame.Points[1];
  TmpRect2D := ReorderRect2D( TmpRect2D );
  If (FTargetDrawBox Is TEzPreviewBox) And ((GetAsyncKeyState(VK_CONTROL) Shr 1) <> 0) Then
  Begin
    { try to zoom in a TEzPreviewEntity }
    P1 := TmpRect2D.Emin;
    Picked := FTargetDrawBox.PickEntity( P1.X, P1.Y,
      Ez_Preferences.ApertureWidth, '', Layer, RecNo1, PickedPoint, Nil );
    If Picked Then
    Begin
      Layer.Recno := Recno1;
      If layer.RecEntityID = idPreview Then
      Begin
        { check if opposite corner also picked TEzPreviewEntity and the same }
        P2 := TmpRect2D.Emax;
        Picked := FTargetDrawBox.PickEntity( P2.X, P2.Y, Ez_Preferences.ApertureWidth,
          '', Layer, RecNo2, PickedPoint, Nil );
        If Picked And ( Recno1 = Recno2 ) Then
        Begin
          Ent := Layer.LoadEntityWithRecno( Recno1 );
          //TEzPreviewEntity(Ent).DrawBox:=CmdLine.ActiveDrawBox;
          Try
            //if TEzPreviewEntity(Ent).GIS<>nil then
            //begin
              { this is the preview area in paper units}
            PreviewArea.Emin := Ent.Points[0];
            PreviewArea.Emax := Ent.Points[1];
            PreviewArea := ReorderRect2D( PreviewArea );
            { first the X axis }
            PaperAreaWidth := Abs( PreviewArea.Emax.X - PreviewArea.Emin.X );
            PaperAreaHeight := Abs( PreviewArea.Emax.y - PreviewArea.Emin.Y );
            MapDrawingArea := ReorderRect2D( TEzPreviewEntity( Ent ).ProposedPrintArea );
            With TEzPreviewEntity( Ent ) Do
              DrawingScale := DrawingUnits / PlottedUnits;
            With MapDrawingArea Do
            Begin
              Emax.X := Emin.X + PaperAreaWidth * DrawingScale;
              Emin.Y := Emax.Y - PaperAreaHeight * DrawingScale;
            End;
            { calculate Emin.X for the map coordinates }
            factor := ( TmpRect2D.Emin.X - PreviewArea.Emin.X ) / PaperAreaWidth;
            MapAreaWidth := ( MapDrawingArea.Emax.X - MapDrawingArea.Emin.X );
            NewMapArea.Emin.X := MapDrawingArea.Emin.X + factor * MapAreaWidth;
            { calculate the width of the map area }
            factorx := ( TmpRect2D.Emax.X - TmpRect2D.Emin.X ) / PaperAreaWidth;
            NewMapArea.Emax.X := NewMapArea.Emin.X + factorx * MapAreaWidth;
            { now the Y axis }

            factor := ( TmpRect2d.Emin.Y - PreviewArea.Emin.Y ) / PaperAreaHeight;
            MapAreaHeight := Abs( MapDrawingArea.Emax.Y - MapDrawingArea.Emin.Y );
            NewMapArea.Emin.Y := MapDrawingArea.Emin.Y + factor * MapAreaHeight;
            { calculate the height of the map area }
            factory := ( TmpRect2d.Emax.Y - TmpRect2d.Emin.Y ) / PaperAreaHeight;
            NewMapArea.Emax.Y := NewMapArea.Emin.Y + factory * MapAreaHeight;

            TEzPreviewEntity( Ent ).ProposedPrintArea := NewMapArea;
            TEzPreviewEntity( Ent ).PlottedUnits :=
              TEzPreviewEntity( Ent ).PlottedUnits / dmax( factorx, factory );
            Layer.UpdateEntity( Recno1, Ent );
            FTargetDrawBox.Repaint;
            Self.Finished := True;
            Exit;
            //end;
          Finally
            Ent.Free;
          End;
        End;
      End;
    End;
  End Else
  Begin
    FTargetDrawBox.ZoomWindow( TmpRect2D );
    Self.Finished := true;
  End;
End;

Procedure TZoomWindowAction.MyMouseDown( Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer; Const WX, WY: Double );
Var
  CurrPoint: TEzPoint;
Begin
  If Button = mbRight Then Exit;
  Self.MouseDrawElements:= [mdCursor];
  If FCurrentIndex = 0 then
    FTargetDrawBox:= CmdLine.ActiveDrawBox;
  With CmdLine.ActiveDrawBox Do
  Begin
    CurrPoint := CmdLine.CurrentPoint;
    SetCurrentPoint( CurrPoint );
    If FCurrentIndex = 0 Then
      FOrigin := Point( X, Y );
    If FCurrentIndex >= 1 Then
    Begin
      FIsZooming:= True;
      Try
        DoFinishZooming;
      Finally
        FIsZooming:= False;
      End;
      Exit;
    End;
    Inc( FCurrentIndex );
    If FCurrentIndex > 0 Then
      Caption := SDefineSecondZoomPoint;
    DrawRubbers;
  End;
End;

Procedure TZoomWindowAction.MyMouseUp( Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer; Const WX, WY: Double );
Var
  Pt: TPoint;
Begin
  Pt := Point( X, Y );
  If ( Abs( Pt.X - FOrigin.X ) > 8 ) And ( Abs( Pt.Y - FOrigin.Y ) > 8 ) Then
  Begin
    DoFinishZooming;
    Exit;
  End;
End;

Procedure TZoomWindowAction.MyMouseMove( Sender: TObject; Shift: TShiftState;
  X, Y: Integer; Const WX, WY: Double );
Var
  CurrPoint: TEzPoint;
Begin
  With FTargetDrawBox Do
  Begin
    DrawRubbers;
    CurrPoint := CmdLine.CurrentPoint;
    SetCurrentPoint( CurrPoint );
    DrawRubbers;
  End;
End;

Procedure TZoomWindowAction.MyPaint( Sender: TObject );
Begin
  If ( FFrame <> Nil ) And( FOuterFrame <> Nil) Then
    DrawRubbers(Sender);
End;

Procedure TZoomWindowAction.MyKeyPress( Sender: TObject; Var Key: Char );
Var
  TmpRect2D: TEzRect;
Begin
  With CmdLine.ActiveDrawBox Do
    If Key = #27 Then
    Begin
      { cancels the zooming }
      DrawRubbers;
      Self.Finished := true;
    End
    Else If Key = #13 Then
    Begin
      DrawRubbers;
      TmpRect2D.Emin := FFrame.Points[0];
      TmpRect2D.Emax := FFrame.Points[1];
      ZoomWindow( TmpRect2D );
      Self.Finished := true;
      Key := #0;
      Exit;
    End;
End;

{----------------------------------------------------------------------------}
//                  TPanningAction
{----------------------------------------------------------------------------}

Constructor TPanningAction.CreateAction( CmdLine: TEzCmdLine; StopOnClick: Boolean = True );
Begin
  Inherited CreateAction( CmdLine );

  CanBeSuspended := false;

  FLine := TEzPolyLine.CreateEntity( [INVALID_POINT, INVALID_POINT] );
  FStopOnClick := StopOnClick;

  OnMouseDown := MyMouseDown;
  OnMouseMove := MyMouseMove;
  OnPaint := MyPaint;
  OnKeyPress := MyKeyPress;

  WaitingMouseClick := True;

  Cursor:= crDrawCross;

  Caption := SDefineFromPoint;
End;

Destructor TPanningAction.Destroy;
Begin
  FLine.Free;
  Caption := '';
  Inherited Destroy;
End;

Procedure TPanningAction.MyMouseDown( Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer; Const WX, WY: Double );
Begin
  If Button = mbRight Then Exit;
  With CmdLine, FLine Do
  Begin
    If FCurrentIndex = 0 Then
    Begin
      Points[0] := CurrentPoint;
      Points[1] := CurrentPoint;
      Inc( FCurrentIndex );
      ActiveDrawBox.DrawEntity2DRubberBand( FLine );
      WaitingMouseClick := False;
      Caption := SDefineToPoint;
    End
    Else If FCurrentIndex = 1 Then
    Begin
      Points[1] := CurrentPoint;
      ActiveDrawBox.DrawEntity2DRubberBand( FLine );
      If ( FBox.X1 <> FBox.X2 ) Or ( FBox.Y1 <> FBox.Y2 ) Then
        ActiveDrawBox.Panning( Points[0].X - Points[1].X, Points[0].Y - Points[1].Y );
      Self.Finished := true;
    End;
  End;
End;

Procedure TPanningAction.MyMouseMove( Sender: TObject; Shift: TShiftState;
  X, Y: Integer; Const WX, WY: Double );
Var
  CurrPoint: TEzPoint;
Begin
  If EqualPoint2d( FLine.Points[0], INVALID_POINT) then Exit;
  With CmdLine.ActiveDrawBox Do
  Begin
    DrawEntity2DRubberBand( FLine );
    CurrPoint := CmdLine.CurrentPoint;
    FLine.Points[FCurrentIndex] := CurrPoint;
    DrawEntity2DRubberBand( FLine );
  End;
End;

Procedure TPanningAction.MyPaint( Sender: TObject );
Begin
  If ( FLine <> Nil ) Then
    CmdLine.ActiveDrawBox.DrawEntity2DRubberBand( FLine );
End;

Procedure TPanningAction.MyKeyPress( Sender: TObject; Var Key: Char );
Begin
  With CmdLine.ActiveDrawBox Do
    If Key = #27 Then
    Begin
      { cancels the zooming }
      DrawEntity2DRubberBand( FLine );
      Self.Finished := true;
    End
End;

{----------------------------------------------------------------------------}
//                  TTransformSelectionAction
{----------------------------------------------------------------------------}

Constructor TTransformSelectionAction.CreateAction( CmdLine: TEzCmdLine;
  TransformType: TEzTransformType; OffsetCmd: Boolean; ScaleAxxis: TEzScaleAxxis );
Begin
  Inherited CreateAction( CmdLine );

  FTransformType := TransformType;
  FScaleAxxis := ScaleAxxis;
  FReferenceLength := 1.0; { for scale }
  FOffsetCmd := OffsetCmd;

  Self.MouseDrawElements:= [mdCursorFrame, mdFullViewCursor];

  CanDoOsnap := True;
  CanDoAccuDraw:= True;
  FOldHiliteSnapped:= CmdLine.AccuSnap.HiliteSnapped;
  CmdLine.AccuSnap.HiliteSnapped:= False;

  { used for showing the offset distance }
  FLine := TEzPolyLine.CreateEntity( [INVALID_POINT, INVALID_POINT] );

  OnMouseDown := MyMouseDown;
  OnMouseMove := MyMouseMove;
  OnPaint := MyPaint;
  OnkeyPress := MyKeyPress;
  OnActionDoCommand := MyActionDoCommand;
  OnSuspendOperation := Self.SuspendOperation;
  OnContinueOperation := Self.ContinueOperation;

  WaitingMouseClick := True;

  If CmdLine.ActiveDrawBox.Selection.Count = 0 Then
  Begin
    MessageToUser( SWarnNoSelection, smsgerror, MB_ICONERROR );
    Self.Finished := True;
  End
  Else
  Begin
    Cursor:= crDrawCross;
    If FTransformType In [ttRotate, ttScale, ttMirror] Then
      Caption := SReferenceFirstPoint
    Else
      Caption := SDefineBasePoint;
  End;
End;

Destructor TTransformSelectionAction.Destroy;
Begin
  FLine.Free;
  Caption := '';
  CmdLine.AccuSnap.HiliteSnapped:= FOldHiliteSnapped;
  Inherited Destroy;
End;

procedure TTransformSelectionAction.DrawRubberLine(Sender: TObject=Nil);
var
  Oldstyle: TPenstyle;
  dbox: TEzBaseDrawBox;
begin
  If EqualPoint2d( FLine.Points[0], INVALID_POINT) Then Exit;
  If Sender=Nil Then
    dbox:= CmdLine.ActiveDrawBox
  else
    dbox:= (Sender As TEzBaseDrawBox);
  with dbox do
  begin
    Oldstyle:= Rubberpen.Style;
    Rubberpen.Style:= psDot;
    If Sender=Nil Then
      cmdLine.All_DrawEntity2DRubberBand( FLine )
    Else
      DrawEntity2DRubberBand( FLine );
    Rubberpen.Style:=Oldstyle;
  end;
end;

procedure TTransformSelectionAction.ContinueOperation(Sender: TObject);
begin
  If Not EqualPoint2d( FLine.Points[0], INVALID_POINT) Then
  begin
    If FTransformType In [ttRotate, ttScale, ttMirror] Then
    Begin
      If FReferenceDefined Then
        Self.DrawSelectionRubberBanding( false )
    End
    Else If FCurrentIndex > 0 Then
      Self.DrawSelectionRubberBanding( false );
    DrawRubberLine;
  end;
end;

procedure TTransformSelectionAction.SuspendOperation(Sender: TObject);
begin
  If Not EqualPoint2d( FLine.Points[0], INVALID_POINT) Then
  begin
    DrawRubberLine;
    If FTransformType In [ttRotate, ttScale, ttMirror] Then
    Begin
      If FReferenceDefined Then
        Self.DrawSelectionRubberBanding( false )
    End
    Else If FCurrentIndex > 0 Then
      Self.DrawSelectionRubberBanding( false );
  end;
end;

Procedure TTransformSelectionAction.MyActionDoCommand( Sender: TObject );
Var
  SavePt, TmpPt: TEzPoint;
Begin
  If UserCommand = itString Then exit; { no strings accepted }
  If UserCommand = itFloatValue then
  begin
    If ( FTransformType = ttRotate ) And ( FCurrentIndex > 0 ) Then
    Begin
      { the rotation angle was specified and in degrees }
      TmpPt.X := FLine.Points[0].X + 1 * Cos( UserValue * System.Pi / 180 );
      TmpPt.Y := FLine.Points[0].Y + 1 * Sin( UserValue * System.Pi / 180 );
    End
    Else
      Exit;
  End;
  SavePt := CmdLine.CurrentPoint;
  CmdLine.CurrentPoint := TmpPt;
  With CmdLine.ActiveDrawBox Do
  Begin
    DrawRubberLine;
    Self.MyMouseDown( Nil, mbLeft, [], 0, 0, 0, 0 );
    If Not Self.Finished Then
    Begin
      DrawRubberLine;
      CmdLine.CurrentPoint := SavePt;
      Self.MyMouseMove( Nil, [], 0, 0, 0, 0 );
    End;
  End;
End;

Procedure TTransformSelectionAction.SetCurrentPoint( Var Pt: TEzPoint; Orto: Boolean );
Var
  cnt: Integer;
Begin
  If Orto And ( FCurrentIndex > 0 ) Then
    Pt := ChangeToOrtogonal( FLine.Points[FCurrentIndex - 1], Pt );
  FLine.Points[FCurrentIndex] := Pt;
  For cnt := FCurrentIndex + 1 To FLine.Points.Count - 1 Do
    FLine.Points[cnt] := Pt;
  //if FCurrentIndex = 0 then WaitingMouseClick:= False;
End;

Procedure TTransformSelectionAction.MyMouseDown( Sender: TObject; Button:
  TMouseButton; Shift: TShiftState; X, Y: Integer; Const WX, WY: Double );
Var
  CurrPoint: TEzPoint;
Begin
  If Button = mbRight Then Exit;
  With CmdLine, FLine Do
  Begin
    CurrPoint := GetSnappedPoint;
    SetCurrentPoint( CurrPoint, UseOrto );
    If FCurrentIndex = 0 Then
    Begin
      FDrawBoxWithSel:= cmdLine.ActiveDrawBox;
      AccuDraw.UpdatePosition(CurrPoint, CurrPoint);

      Points[0] := CurrPoint;
      Points[1] := CurrPoint;
      Inc( FCurrentIndex );
      DrawRubberLine;
      If FTransformType In [ttRotate, ttScale, ttMirror] Then
        Caption := SReferenceSecondPoint
      Else
      Begin
        Self.DrawSelectionRubberBanding( false );
        Caption := SDefineEndPoint;
      End;
      WaitingMouseClick := False;
    End
    Else
    Begin
      Points[1] := CurrPoint;
      DrawRubberLine;
      If ( FTransformType In [ttRotate, ttScale, ttMirror] ) And Not FReferenceDefined Then
      Begin
        If FTransformType = ttScale Then
        Begin
          FReferenceLength := Dist2D( Points[0], Points[1] );
          If FReferenceLength = 0 Then
            FReferenceLength := 1.0;
        End;
        FReferenceStart := Points[0];
        FReferenceEnd := Points[1];
        FReferenceDefined := true;
        If FTransformType = ttRotate Then
          Caption := SRotTransformLastPoint
        Else
          Caption := STransformLastPoint;
      End
      Else
      Begin
        Self.DrawSelectionRubberBanding( true ); {true = apply transform}
        All_Repaint;
        Self.Finished := true;
      End;
    End;
  End;
End;

Procedure TTransformSelectionAction.MyMouseMove( Sender: TObject;
  Shift: TShiftState; X, Y: Integer; Const WX, WY: Double );
Var
  CurrPoint: TEzPoint;
  Dx, Dy, Phi1, Phi2, Sx, Sy, Scale: Double;
Begin
  With CmdLine Do
  Begin
    DrawRubberLine;
    If FTransformType In [ttRotate, ttScale, ttMirror] Then
    Begin
      If FReferenceDefined Then
        Self.DrawSelectionRubberBanding( false )
    End
    Else If FCurrentIndex > 0 Then
      Self.DrawSelectionRubberBanding( false );
    CurrPoint := GetSnappedPoint;
    SetCurrentPoint( CurrPoint, UseOrto );
    DrawRubberLine;
    If FTransformType In [ttRotate, ttScale, ttMirror] Then
    Begin
      If FReferenceDefined Then
        Self.DrawSelectionRubberBanding(False)
    End
    Else If FCurrentIndex > 0 Then
      Self.DrawSelectionRubberBanding( False );

    // now, display info in the status bar
    With FLine Do
      If FTransformType in [ttTranslate, ttMirror] Then
      Begin
        Dx := Points[1].X - Points[0].X;
        Dy := Points[1].Y - Points[0].Y;
        StatusMessage := Format( STranslateFmt, [Dx, Dy,
          RadToDeg( Angle2D( Points[0], Points[1] ) )] );
      End
      Else If FTransformType = ttRotate Then
      Begin
        phi1 := Angle2D( FReferenceStart, FReferenceEnd );
        phi2 := Angle2D( Points[0], Points[1] );
        StatusMessage := Format( SRotateFmt, [RadToDeg( Abs( phi2 - phi1 ) )] );
      End
      Else If ( FTransformType = ttScale ) And FReferenceDefined Then
      Begin
        Sx := Abs( Points[1].X - Points[0].X ) / FReferenceLength;
        Sy := Abs( Points[1].Y - Points[0].Y ) / FReferenceLength;
        Scale := 100;
        If FScaleAxxis = saBoth Then
          Scale := Sqrt( Sqr( Sx ) + Sqr( Sy ) ) * 100
        Else If FScaleAxxis = saX Then
          Scale := Sx * 100
        Else If FScaleAxxis = saY Then
          Scale := Sy * 100;
        StatusMessage := Format( SScaleFmt, [Scale] );
      End;
  End;
End;

Procedure TTransformSelectionAction.MyPaint( Sender: TObject );
Begin
  If FLine <> Nil Then
  Begin
    DrawRubberLine(Sender);
    Self.DrawSelectionRubberBanding( false, Sender );
  End;
End;

Procedure TTransformSelectionAction.DrawSelectionRubberBanding( ApplyTransform: Boolean;
  Sender: TObject=Nil );
Var
  I, J, Recno, NewRecno: Integer;
  Entity: TEzEntity;
  Tx, Ty, phi, phiStart, phiEnd, Scale, Sx, Sy: Double;
  M: TEzMatrix;
  Accept, Undone: Boolean;
Begin
  If FDrawBoxWithSel=Nil then
    FDrawBoxWithSel:= cmdLine.ActiveDrawBox;
  With FDrawBoxWithSel Do
  Begin
    Undone:= false;
    For I := 0 To Selection.Count - 1 Do
    Begin
      With Selection[I] Do { the selected layer }
        For J := 0 To SelList.Count - 1 Do
        Begin
          if Layer.LayerInfo.Locked then Continue;
          Recno := SelList[J];
          Entity := Layer.LoadEntityWithRecno( Recno );
          If Entity = Nil Then Continue;
          Try
            {Apply the transformation}
            If FTransformType = ttMirror Then
            Begin
              { first translate both points to origin and rotate to be
                parallel to X axxis }
              Tx := -FLine.Points[0].X;
              Ty := -FLine.Points[0].Y;
              Sx := 1.0;
              Sy := 1.0;
              phi:= -Angle2d(FLine.Points[0], FLine.Points[1]);
              M:= BuildTransformationMatrix( sx, sy, phi, tx, ty, FLine.Points[0] );
              matrix3x3PreMultiply( MirrorAroundX(), M );
              { now the inverse transformation }
              matrix3x3PreMultiply( Rotate2d( Angle2d(FLine.Points[0], FLine.Points[1]), Point2d(0,0) ), M );
              matrix3x3PreMultiply( Translate2d( FLine.Points[0].X, FLine.Points[0].Y ), M );
              Entity.SetTransformMatrix( M );
            End
            Else
            If FTransformType = ttTranslate Then
            Begin
              Tx := FLine.Points[1].X - FLine.Points[0].X;
              Ty := FLine.Points[1].Y - FLine.Points[0].Y;
              Entity.SetTransformMatrix( Translate2D( Tx, Ty ) );
            End
            Else
            If FTransformType = ttRotate Then
            Begin
              { special entities that cannot be rotated }
              If Not ((Entity.EntityID In ImageEntities) Or (Entity.EntityID in [idPlace, idBlockInsert])) Then
              Begin
                phiStart := Angle2D( FReferenceStart, FReferenceEnd );
                phiEnd := Angle2D( FLine.Points[0], FLine.Points[1] );
                Entity.SetTransformMatrix( Rotate2D( phiEnd - phiStart, FLine.Points[0] ) );
              End
              Else If Entity.EntityID in [idPlace, idBlockInsert] Then
              Begin
                // TEzPlace must be rotated about its center
                phiStart := Angle2D( FReferenceStart, FReferenceEnd );
                phiEnd := Angle2D( FLine.Points[0], FLine.Points[1] );
                case Entity.EntityID of
                  idPlace:
                    with TEzPlace( Entity ).Symboltool do
                      Rotangle := Rotangle + ( phiEnd - phiStart );
                  idBlockInsert:
                    with TEzBlockInsert( Entity ) do
                      Rotangle := Rotangle + ( phiEnd - phiStart );
                end;
              End;
            End
            Else If ( FTransformType = ttScale ) And FReferenceDefined Then
            Begin
              Sx := Abs( FLine.Points[1].X - FLine.Points[0].X ) / FReferenceLength;
              Sy := Abs( FLine.Points[1].Y - FLine.Points[0].Y ) / FReferenceLength;
              If FScaleAxxis = saBoth Then
              Begin
                Scale := Sqrt( Sqr( Sx ) + Sqr( Sy ) );
                Sx := Scale;
                Sy := Scale;
              End Else If FScaleAxxis = saX Then
                Sy := 1.0
              Else If FScaleAxxis = saY Then
                Sx := 1.0;
              if Entity.EntityID in [idPlace, idBlockInsert] then
              begin
                case Entity.EntityID of
                  idPlace:
                    with TEzPlace(Entity).SymbolTool do
                      Height:= Height * Sy;
                  idBlockInsert:
                    with TEzBlockInsert(Entity) do
                    begin
                      BeginUpdate;
                      ScaleX := ScaleX * Sx;
                      ScaleY := ScaleY * Sy;
                      EndUpdate;
                    end;
                end;
              end else
                Entity.SetTransformMatrix( Scale2D( Sx, Sy, FLine.Points[0] ) );
            End;
            If Sender=Nil then
              cmdLine.All_DrawEntity2DRubberBand( Entity )
            Else
              (Sender As TEzBaseDrawBox).DrawEntity2DRubberBand( Entity );
            If ApplyTransform Then
            Begin
              if Assigned(Gis.OnBeforeTransform) then
              begin
                Accept:= True;
                Gis.OnBeforeTransform( Gis, Layer, Recno, Entity, FTransformType, Accept );
                if not Accept then Exit;
              end;
              If Not Undone Then
              begin
                Undo.AddUnTransformFromSelection; // save in the undo object before transform
                Undone:= true;
              end;
              Entity.ApplyTransform;
              If Not FOffsetCmd Then
              Begin
                Layer.UpdateEntity( Recno, Entity );
                { update links }
                If Entity.EntityID = idNode Then
                Begin
                  TEzNode( Entity ).UpdatePosition(Recno, Layer );
                End;
                If Entity.EntityID = idNodeLink Then
                Begin
                  TEzNodeLink( Entity ).UpdatePosition(Recno, Layer );
                End;

              End Else
                With GIS Do
                Begin
                  NewRecno := CurrentLayer.AddEntity( Entity );
                  // copy the DB record also
                  CurrentLayer.CopyRecord( Recno, NewRecno );
                  DrawEntity2D( Entity, False );
                  Invalidate;
                End;
              if Assigned(Gis.OnAfterTransform) then
                Gis.OnAfterTransform( Gis, Layer, Recno );
            End;
          Finally
            FreeAndNil( Entity );
          End;
        End;
    End;
  End
End;

Procedure TTransformSelectionAction.MyKeyPress( Sender: TObject; Var Key: Char );
Begin
  If Key = #27 Then
  Begin
    DrawRubberLine;
    Self.DrawSelectionRubberBanding( false );
    Self.Finished := true;
  End;
End;

{----------------------------------------------------------------------------}
//                  TSelectAction
{----------------------------------------------------------------------------}

Constructor TSelectAction.CreateAction( CmdLine: TEzCmdLine; Aperture: Integer );
Begin
  Inherited CreateAction( CmdLine );

  CanBeSuspended := False;

  FAperture := Aperture;

  Self.MouseDrawElements:= [mdCursor, mdFullViewCursor];

  { This frame is for selecting in a window }
  FFrame := TEzRectangle.CreateEntity( Point2D(0, 0), Point2D(0, 0) );

  OnMouseDown := MyMouseDown;
  OnMouseMove := MyMouseMove;
  OnKeyPress := MyKeyPress;
  OnPaint := MyPaint;

  Caption := SStartSingleSelect;

  Cursor:= crDrawCross;

End;

Destructor TSelectAction.Destroy;
Begin
  if CmdLine.ActiveDrawBox <> nil then
    CmdLine.ActiveDrawBox.RubberPen.Style := psSolid;
  Caption := '';
  FFrame.Free;
  Inherited Destroy;
End;

Procedure TSelectAction.SetCurrentPoint( Grapher: TEzGrapher; Const Pt: TEzPoint );
Var
  I: Integer;
Begin
  If FSelMode = smWindow Then
  Begin
    FFrame.Points[FCurrentIndex] := Pt;
    For I := FCurrentIndex + 1 To FFrame.Points.Count - 1 Do
      FFrame.Points[I] := Pt;
  End;
End;

Procedure TSelectAction.MyMouseDown( Sender: TObject; Button: TMouseButton; Shift:
  TShiftState; X, Y: Integer; Const WX, WY: Double );
Var
  CurrPoint: TEzPoint;
  TmpLayer: TEzBaseLayer;
  TmpRecNo: Integer;
  FPickedPoint: Integer;
  TmpRect2D: TEzRect;
  Picked: Boolean;
  IsShiftPressed: Boolean;
Begin
  If Button = mbRight Then Exit;
  With CmdLine Do
  Begin
    If FSelMode = smWindow Then
      All_DrawEntity2DRubberBand( FFrame );
    If FSelMode = smPicking Then
    Begin
      CurrPoint := CurrentPoint;
      IsShiftPressed := ( GetAsyncKeyState( VK_SHIFT ) Shr 1 ) <> 0;
      Picked:= false;
      If IsShiftPressed Then
      Begin
        Picked := ActiveDrawBox.PickEntity( CurrPoint.X, CurrPoint.Y, FAperture,
          '', TmpLayer, TmpRecNo, FPickedPoint, Nil );
      End;
      If IsShiftPressed And Picked Then
      Begin
        {now add to the selection object}
        ActiveDrawBox.Selection.Add( TmpLayer, TmpRecNo );
        ActiveDrawBox.Selection.RepaintSelectionArea;
      End
      Else
      Begin
        FSelMode := smWindow;
        CurrPoint := CurrentPoint;
        FCurrentIndex := 0;
        SetCurrentPoint( ActiveDrawBox.Grapher, CurrPoint );
        FCurrentIndex := 1;
        Caption := SDefineSecondSelection;
        All_DrawEntity2DRubberBand( FFrame );
        Exit;
      End;
    End
    Else
    Begin
      CurrPoint := CmdLine.CurrentPoint;
      SetCurrentPoint( ActiveDrawBox.Grapher, CurrPoint );
      TmpRect2D.Emin := FFrame.Points[0];
      TmpRect2D.Emax := FFrame.Points[1];
      If FFrame.Points[1].X > FFrame.Points[0].X Then
        SelectInFrame( TmpRect2D, gmAllInside )
      Else
        SelectInFrame( TmpRect2D, gmCrossFrame );
      FSelMode := smPicking;
      ActiveDrawBox.RubberPen.Style := psSolid;
    End;
  End;
End;

Procedure TSelectAction.MyMouseMove( Sender: TObject; Shift: TShiftState;
  X, Y: Integer; Const WX, WY: Double );
Var
  CurrPoint: TEzPoint;
Begin
  With CmdLine Do
  Begin
    If FSelMode = smWindow Then
    Begin
      All_DrawEntity2DRubberBand( FFrame );
      CurrPoint := CmdLine.CurrentPoint;
      SetCurrentPoint( ActiveDrawBox.Grapher, CurrPoint );
      If FFrame.Points[1].X > FFrame.Points[0].X Then
        ActiveDrawBox.RubberPen.Style := psSolid
      Else
        ActiveDrawBox.RubberPen.Style := psDot;
      All_DrawEntity2DRubberBand( FFrame );
    End;
  End;
End;

Procedure TSelectAction.MyKeyPress( Sender: TObject; Var Key: Char );
Begin
  With CmdLine Do
    If Key In [#13, #27] Then
    Begin
      If FSelMode = smWindow Then
        All_DrawEntity2DRubberBand( FFrame );
      Self.Finished := true;
      Key := #0;
    End;
End;

Procedure TSelectAction.MyPaint( Sender: TObject );
Begin
  With CmdLine.ActiveDrawBox Do
    If FSelMode <> smPicking Then
      (Sender As TEzBaseDrawBox).DrawEntity2DRubberBand( FFrame );
End;

Procedure TSelectAction.SelectInFrame( Frame: TEzRect; Mode: TEzGroupMode );
Var
  TmpEntity: TEzEntity;
  TmpEntityID: TEzEntityID;
  I: Integer;
  TmpLayer: TEzBaseLayer;
  Found: Boolean;
  Entities: Array[TEzEntityID] Of TEzEntity;
  Cont: TEzEntityID;
  SavedDrawLimit: Integer;
  TickStart: DWORD;
  Msg: TMsg;
  Canceled: Boolean;
  SearchType: TSearchType;
  ARecno: integer;
  IsAltPressed: Boolean;
  SelExtent, Extent: TEzRect;
  Saved: TCursor;
Begin
  Frame := ReOrderRect2D( Frame );
  Found := false;
  Canceled := False;

  With CmdLine.ActiveDrawBox Do
  Begin
    SelExtent := INVALID_EXTENSION;
    For Cont := Low( TEzEntityID ) To High( TEzEntityID ) Do
      Entities[Cont] := GetClassFromID( Cont ).Create( 4 );
    SavedDrawLimit := Ez_Preferences.MinDrawLimit;
    Ez_Preferences.MinDrawLimit := 0;
    Selection.BeginUpdate;
    Saved:= Screen.Cursor;
    Screen.Cursor:= crHourglass;
    Try
      { detect of CTRL key is pressed }
      IsAltPressed := ( GetAsyncKeyState( VK_menu ) Shr 1 ) <> 0;
      {Scan from topmost layer}
      TickStart := GetTickCount;
      For I := GIS.Layers.Count - 1 Downto 0 Do
      Begin
        TmpLayer := GIS.Layers[I];
        With TmpLayer Do
        Begin
          If Not LayerInfo.Visible Then Continue;
          If Not LayerInfo.Selectable Then Continue;
          Case Mode Of
            gmAllInside:
              If PartialSelect Then
                SearchType := stOverlap
              Else
                SearchType := stEnclosure;
            gmCrossFrame:
              SearchType := stOverlap;
          Else
            SearchType := stOverlap;
          End;
          SetGraphicFilter( SearchType, Frame );

          First;
          StartBuffering;
          Try
            While Not Eof Do
            Begin
              If GetTickCount >= TickStart + 500 Then
              Begin
                // check if specific messages are waiting and if so, cancel internal selecting
                PeekMessage( Msg, Handle, WM_KEYDOWN, WM_KEYDOWN, PM_REMOVE );
                If ( Msg.Message = WM_KEYDOWN ) And ( Msg.WParam = VK_ESCAPE ) Then
                Begin
                  Canceled := True;
                  Break;
                End;

                TickStart := GetTickCount;
              End;
              Try
                With Grapher.CurrentParams Do
                Begin
                  Extent := RecExtension;
                  If RecIsDeleted Then Continue;

                  TmpEntityID := RecEntityID;
                  If TmpEntityID In NoPickFilter Then Continue;
                  If TmpEntityID In [idFittedVectText, idJustifVectText] Then
                  Begin
                    If Not Ez_Preferences.ShowText Then Continue;
                  End;
                  TmpEntity := Entities[TmpEntityID];
                  RecLoadEntity2( TmpEntity );
                  ARecno := TmpLayer.Recno;
                  If Mode = gmAllInside Then
                  Begin
                    If PartialSelect Then
                    Begin
                      If IsBoxInBox2D( TmpEntity.FBox, Frame ) Then
                      Begin
                        If Not IsAltPressed Then
                          Selection.Add( TmpLayer, ARecno )
                        Else
                          Selection.Delete( TmpLayer, ARecno );
                        MaxBound( SelExtent.Emax, Extent.Emax );
                        MinBound( SelExtent.Emin, Extent.Emin );
                        Found := true;
                      End;
                    End
                    Else
                    Begin
                      If IsBoxFullInBox2D( TmpEntity.FBox, Frame ) Then
                      Begin
                        If Not IsAltPressed Then
                          Selection.Add( TmpLayer, ARecno )
                        Else
                          Selection.Delete( TmpLayer, ARecno );
                        MaxBound( SelExtent.Emax, Extent.Emax );
                        MinBound( SelExtent.Emin, Extent.Emin );
                        Found := true;
                      End;
                    End;
                  End
                  Else If TmpEntity.DrawPoints.CrossFrame( Frame, TmpEntity.GetTransformMatrix ) Then
                  Begin
                    If Not IsAltPressed Then
                      Selection.Add( TmpLayer, ARecno )
                    Else
                      Selection.Delete( TmpLayer, ARecno );
                    MaxBound( SelExtent.Emax, Extent.Emax );
                    MinBound( SelExtent.Emin, Extent.Emin );
                    Found := true;
                  End;
                End;
              Finally
                Next;
              End;
            End;
          Finally
            EndBuffering;
            CancelFilter;
          End;
        End;
        If Canceled Then
          Break;
      End;
    Finally
      Selection.EndUpdate;
      For Cont := Low( TEzEntityID ) To High( TEzEntityID ) Do
        Entities[Cont].Free;
      Ez_Preferences.MinDrawLimit := SavedDrawLimit;
      Screen.Cursor:= Saved;
    End;
    If Found And Not EqualRect2D( SelExtent, INVALID_EXTENSION ) Then
      cmdLine.All_RepaintRect( SelExtent );
  End
End;

{$IFDEF BCB}
function TSelectAction.GetAperture: Integer;
begin
  Result := FAperture;
end;

procedure TSelectAction.SetAperture(const Value: Integer);
begin
  FAperture := Value;
end;
{$ENDIF}

{----------------------------------------------------------------------------}
//                  TInsertVertexAction
{----------------------------------------------------------------------------}

Constructor TInsertVertexAction.CreateAction( CmdLine: TEzCmdLine );
Begin
  Inherited CreateAction( CmdLine );

  Self.MouseDrawElements:= [mdCursorFrame, mdFullViewCursor];

  FEntity := ezsystem.LoadSingleSelEntity( CmdLine.ActiveDrawBox, FLayer, FRecno );
  If (FEntity = Nil) Or ( Assigned(FLayer) And FLayer.LayerInfo.Locked) Then
    Raise EInvalidOperation.Create( SVertexSingleEntityError );

  FAperture := Ez_Preferences.ApertureWidth;

  OnKeyPress := MyKeyPress;
  OnMouseDown := MyMouseDown;
  OnPaint := MyPaint;

  Caption := SInsertVertexPoint;

  Cursor:= crDrawCross;

  CmdLine.ActiveDrawBox.DrawControlPointsWithRubber( FEntity );

  If Not ( FEntity.EntityID In [idPolyline, idPolygon, idSpline, idSplineText] ) Then
    Raise EInvalidOperation.Create( SVertexEntityBadError );
End;

Destructor TInsertVertexAction.Destroy;
Begin
  If FModified Then
    FLayer.UpdateEntity( FRecno, FEntity );
  FEntity.Free;
  Inherited Destroy;
End;

Procedure TInsertVertexAction.MyPaint( Sender: TObject );
Begin
  With CmdLine.ActiveDrawBox Do
  Begin
    DrawControlPointsWithRubber( FEntity );
  End;
End;

Procedure TInsertVertexAction.MyMouseDown( Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer; Const WX, WY: Double );
Var
  CurrPoint: TEzPoint;
  cnt: Integer;
  Aperture: integer;
  RealAperture: TEzPoint;
  MinDist, Distance: Double;
  TmpVect: TEzVector;
Begin
  If Button = mbRight Then Exit;
  With CmdLine.ActiveDrawBox Do
  Begin
    CurrPoint := CmdLine.GetSnappedPoint;
    DrawCross( Canvas, Grapher.RealToPoint( CurrPoint ) );
    Aperture := FAperture Div 2;
    RealAperture := Point2D( Grapher.DistToRealX( Aperture ),
      Grapher.DistToRealY( Aperture ) );
    If RealAperture.X > RealAperture.Y Then
      MinDist := RealAperture.X
    Else
      MinDist := RealAperture.Y;
    MinDist := Sqrt( 2 ) * MinDist;
    TmpVect := TEzVector.Create( 2 );
    Try
      For cnt := 0 To FEntity.Points.Count - 2 Do
      Begin
        TmpVect[0] := FEntity.Points[cnt];
        TmpVect[1] := FEntity.Points[cnt + 1];
        If TmpVect.PointOnPolyLine2D( 0, CurrPoint, Distance, MinDist,
             IDENTITY_MATRIX2D, False ) >= PICKED_INTERIOR Then
        Begin
          Undo.AddUnTransform(FLayer, FRecno);
          FEntity.Points.Insert( cnt + 1, CurrPoint );
          FModified := true;
          Exit;
        End;
      End;
    Finally
      TmpVect.Free;
    End;
  End;
End;

Procedure TInsertVertexAction.MyKeyPress( Sender: TObject; Var Key: Char );
Begin
  With CmdLine.ActiveDrawBox Do
    If Key In [#13, #27] Then
    Begin
      CmdLine.ActiveDrawBox.Selection.RepaintSelectionArea;
      Self.Finished := true;
      Key := #0;
    End;
End;

{----------------------------------------------------------------------------}
//                  TChangeGridOriginAction
{----------------------------------------------------------------------------}

Constructor TChangeGridOriginAction.CreateAction( CmdLine: TEzCmdLine );
Begin
  Inherited CreateAction( CmdLine );

  CanDoOsnap:= True;
  CanDoAccuDraw:= True;
  MouseDrawElements:= [mdCursorFrame, mdFullViewCursor];

  OnKeyPress := MyKeyPress;
  OnMouseDown := MyMouseDown;

  Caption := SChangeGridOrigin;

  Cursor:= crDrawCross;

End;

Procedure TChangeGridOriginAction.MyKeyPress( Sender: TObject; Var Key: Char );
Begin
  If Key In [#13, #27] Then
  Begin
    Self.Finished := true;
    Key := #0;
  End;
End;

Procedure TChangeGridOriginAction.MyMouseDown( Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer;
  Const WX, WY: Double );
Var
  CurrPoint: TEzPoint;
Begin
  If Button = mbRight Then
    Exit;
  With CmdLine.ActiveDrawBox Do
  Begin
    CurrPoint := CmdLine.CurrentPoint;
    With GridInfo Do
      GridOffset.FPoint := Point2D( CurrPoint.X - Trunc( CurrPoint.X / Grid.X ) * Grid.X,
        CurrPoint.Y - Trunc( CurrPoint.Y / Grid.Y ) * Grid.Y );
    Repaint;
    Self.Finished := True;
  End;
End;

{----------------------------------------------------------------------------}
//                  TShowHintAction
{----------------------------------------------------------------------------}

Constructor TShowHintAction.CreateAction( CmdLine: TEzCmdLine );
Begin
  Inherited CreateAction( CmdLine );

  MouseDrawElements:= [mdCursor, mdCursorFrame];

  FHighlightClicked:= False;

  OnKeyPress := MyKeyPress;
  OnMouseDown:= MyMouseDown;
  //OnSuspendOperation := Self.SuspendOperation;
  //OnContinueOperation := Self.ContinueOperation;

  hintW := TNewHint.Create( Application );
  With hintW.DanHint Do
  Begin
    HintColor := Ez_Preferences.HintColor;
    HintFont := Ez_Preferences.HintFont;
    HintActive := False;
  End;

  FSaveOnDeactivate := Application.OnDeactivate;
  Application.OnDeactivate := MyDeactivate;
  FSaveOnHint := Application.OnHint;
  Application.OnHint := MyOnHint;

  {FTimer := TTimer.Create( Nil );
  FTimer.OnTimer := MyTimer;
  FTimer.Interval := CmdLine.ActiveDrawBox.DelayShowHint;
  FTimer.Enabled := true;  }

  Cursor:= crHandPoint;

  Caption := SShowHintCaption;
End;

Destructor TShowHintAction.Destroy;
Begin
  DisposeTempUsed;
  Application.OnDeactivate := FSaveOnDeactivate;
  Application.OnHint := FSaveOnHint;
  //FTimer.Free;
  hintW.DanHint.HintActive := False;
  hintW.ReleaseHandle;
  hintW.Free;
  If FStackedSelList <> Nil Then
    FStackedSelList.Free;
  Inherited Destroy;
End;

{Procedure TShowHintAction.SuspendOperation( Sender: TObject );
Begin
  FTimer.Enabled := false;
End;

Procedure TShowHintAction.ContinueOperation( Sender: TObject );
Begin
  FTimer.Enabled := true;
End;  }

Procedure TShowHintAction.DisposeTempUsed;
Begin
  if Not FHighlightClicked then Exit;
  If (CmdLine <> Nil) and (CmdLine.ActiveDrawBox <> nil) Then
    With CmdLine.ActiveDrawBox Do
      If FTempUsed And ( TempEntities.Count > 0 ) And
         ( TempEntities[TempEntities.Count - 1] = FTempEnt ) Then
      Begin
        TempEntities.Delete{WithoutFreeing}( TempEntities.Count - 1 );
        FTempUsed := False;
        FTempEnt := Nil;
      End;
End;

Procedure TShowHintAction.HiliteClickedEntity( Layer: TEzBaseLayer; Recno: Integer );
Var
  Box: TEzRect;
  Entity: TEzEntity;
Begin
  If Not FHighlightClicked then Exit;
  Entity := Layer.LoadEntityWithRecNo( RecNo );
  If Entity = Nil Then
  Begin
    // entity is deleted
    DisposeTempUsed;
    CmdLine.ActiveDrawBox.Refresh;
    Exit;
  End;
  If Entity.EntityID In [idPlace, idNode, idPictureRef, idPersistBitmap,
    idBandsBitmap, idFittedVectText, idTable, idBlockInsert,
    idDimHorizontal, idDimVertical, idDimParallel] Then
  Begin
    Box := Entity.FBox;
    Entity.Free;
    Entity := TEzRectangle.CreateEntity( Box.Emin, Box.Emax );
  End;
  With CmdLine.ActiveDrawBox Do
  Begin
    With Ez_Preferences Do
    Begin
      If Entity Is TEzOpenedEntity Then
        With TEzOpenedEntity( Entity ) Do
        Begin
          Pentool.Assign( SelectionPen );
          Pentool.Width := SelectionPen.Width; //grapher.getrealsize(SelectionPen.width);
        End;
      If Entity Is TEzClosedEntity Then
        TEzClosedEntity( Entity ).Brushtool.Assign( SelectionBrush );
    End;
  End;
  DisposeTempUsed;
  CmdLine.ActiveDrawBox.TempEntities.Add( Entity );
  FTempUsed := True;
  FTempEnt := Entity;
  CmdLine.ActiveDrawBox.Refresh;
End;

Procedure TShowHintAction.MyDeactivate( Sender: TObject );
Begin
  DisplayHintWindow( '', Point( 0, 0 ) );
End;

Procedure TShowHintAction.MyOnHint( Sender: TObject );
Begin
  DisplayHintWindow( '', Point( 0, 0 ) );
  If Assigned( FSaveOnHint ) Then
    FSaveOnHint( Sender );
End;

Procedure TShowHintAction.DisplayHintWindow( Const TmpHint: String; p: TPoint );
Var
  r: Windows.TRect;
Begin
  If Application.Active And ( Length( tmpHint ) > 0 ) Then
  Begin
    hintW.DanHint.HintActive := True;
    r := hintW.CalcHintRect( Screen.Width, TmpHint, Nil );
    InflateRect( r, 2, 2 );
    //tmpH := r.bottom - r.top;
    OffsetRect( r, p.X, p.Y + 32 );
    hintW.ActivateHint( r, TmpHint );
  End
  Else
  Begin
    SetWindowPos( hintW.Handle, HWND_NOTOPMOST, 0, 0, 0, 0, SWP_HIDEWINDOW Or SWP_NOACTIVATE );
    hintW.DanHint.HintActive := FALSE;
  End;
End;

{Procedure TShowHintAction.MyTimer( Sender: TObject );
Var
  I, N, TmpRecNo: Integer;
  fPickedPoint: Integer;
  Accept, Picked: Boolean;
  CurrPoint: TEzPoint;
  p: TPoint;
  AHint: String;
Begin
  FTimer.Enabled := false;
  Try
    //Find an entity if time expired
    GetCursorPos( p );
    With CmdLine.ActiveDrawBox Do
      If Not PtInRect( ClientRect, ScreenToClient( p ) ) Then
      Begin
        DisplayHintWindow( '', p );
        fLastLayer := Nil;
        fLastRecno := 0;
        Exit;
      End;
    If CmdLine.ActiveDrawBox.StackedSelect Then
    Begin
      If FStackedSelList = Nil Then
        FStackedSelList := TStringList.Create
      Else
        FStackedSelList.Clear;
    End
    Else If FStackedSelList <> Nil Then
      FreeAndNil( FStackedSelList );

    CurrPoint := CmdLine.CurrentPoint;
    With CmdLine.ActiveDrawBox Do
    Begin
      Picked := PickEntity( CurrPoint.X, CurrPoint.Y, 4, '', FLayer, TmpRecNo,
        fPickedPoint, Self.FStackedSelList );
      If Picked Then
      Begin
        If ( FStackedSelList <> Nil ) And ( FStackedSelList.Count > 1 ) Then
        Begin
          For I := 0 To FStackedSelList.Count - 1 Do
          Begin
            If ( FLastLayer = GIS.Layers.LayerByName( FStackedSelList[I] ) ) And
               ( FLastRecno = Longint( FStackedSelList.Objects[I] ) ) Then
            Begin
              If I < FStackedSelList.Count - 1 Then
                N := I + 1
              Else
                N := 0;
              FLayer := GIS.Layers.LayerByName( FStackedSelList[N] );
              TmpRecno := Longint( FStackedSelList.Objects[N] );
              Break;
            End;
          End;
        End;
        If ( FLayer = FLastLayer ) And ( TmpRecno = FLastRecno ) Then Exit;
        FLastLayer := FLayer;
        FLastRecno := TmpRecno;
        DisplayHintWindow( '', p );
        If Assigned( OnShowHint ) Then
        Begin
          Accept := False;
          OnShowHint( CmdLine.ActiveDrawBox, FLayer, TmpRecno, AHint, Accept );
          If Accept And ( Length( AHint ) > 0 ) Then
            DisplayHintWindow( AHint, p );
        End;
      End
      Else
      Begin
        DisplayHintWindow( '', p );
        fLastLayer := Nil;
        FLastRecno := 0;
      End;
    End;
  Finally
    FTimer.Enabled := true;
  End;
End; }

Procedure TShowHintAction.MyMouseDown( Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer; Const WX, WY: Double );
Var
  I, N, TmpRecNo: Integer;
  fPickedPoint: Integer;
  Accept, Picked: Boolean;
  CurrPoint: TEzPoint;
  p: TPoint;
  AHint: String;
Begin
  { Find an entity if time expired }
  If CmdLine.ActiveDrawBox.StackedSelect Then
  Begin
    If FStackedSelList = Nil Then
      FStackedSelList := TStringList.Create
    Else
      FStackedSelList.Clear;
  End
  Else If FStackedSelList <> Nil Then
    FreeAndNil( FStackedSelList );

  CurrPoint := CmdLine.CurrentPoint;
  With CmdLine.ActiveDrawBox Do
  Begin
    Picked := PickEntity( CurrPoint.X, CurrPoint.Y, 4, '', FLayer, TmpRecNo,
      fPickedPoint, Self.FStackedSelList );
    If Picked Then
    Begin
      If ( FStackedSelList <> Nil ) And ( FStackedSelList.Count > 1 ) Then
      Begin
        For I := 0 To FStackedSelList.Count - 1 Do
        Begin
          If ( FLastLayer = GIS.Layers.LayerByName( FStackedSelList[I] ) ) And
             ( FLastRecno = Longint( FStackedSelList.Objects[I] ) ) Then
          Begin
            If I < FStackedSelList.Count - 1 Then
              N := I + 1
            Else
              N := 0;
            FLayer := GIS.Layers.LayerByName( FStackedSelList[N] );
            TmpRecno := Longint( FStackedSelList.Objects[N] );
            Break;
          End;
        End;
      End;
      If ( FLayer = FLastLayer ) And ( TmpRecno = FLastRecno ) Then Exit;
      FLastLayer := FLayer;
      FLastRecno := TmpRecno;
      DisplayHintWindow( '', p );
      If Assigned( OnShowHint ) Then
      Begin
        Accept := False;
        OnShowHint( CmdLine.ActiveDrawBox, FLayer, TmpRecno, AHint, Accept );
        If Accept And ( Length( AHint ) > 0 ) Then
        begin
          DisplayHintWindow( AHint, p );
          HiliteClickedEntity( FLayer, TmpRecno );
        End;
      End;
    End
    Else
    Begin
      DisplayHintWindow( '', p );
      fLastLayer := Nil;
      FLastRecno := 0;
    End;
  End;
End;

Procedure TShowHintAction.MyKeyPress( Sender: TObject; Var Key: Char );
Begin
  If Key In [#13, #27] Then
  Begin
    Self.Finished := true;
    Exit;
  End;
End;

{----------------------------------------------------------------------------}
//                  TPolygonFromBufferAction
{----------------------------------------------------------------------------}

Constructor TPolygonFromBufferAction.CreateAction( CmdLine: TEzCmdLine );
VAR
  p: TEzPoint;
Begin
  Inherited CreateAction( CmdLine );

  CanBeSuspended := false;

  CanDoOsnap := True;
  CanDoAccuDraw:= True;

  MouseDrawElements:= [mdCursorFrame, mdFullViewCursor];

  p:= Point2d(0,0);
  FLine := TEzPolyLine.CreateEntity( [p, p] );
  FPolygon := TEzPolygon.CreateEntity( [p] );
  FPolyline := TEzPolyLine.CreateEntity( [p] );

  OnMouseDown := MyMouseDown;
  OnMouseMove := MyMouseMove;
  OnKeyPress := MyKeyPress;
  OnPaint := MyPaint;
  OnSuspendOperation := Self.SuspendOperation;
  OnContinueOperation := Self.ContinueOperation;

  Cursor:= crDrawCross;

  Caption := SReferenceFirstPoint;

End;

Destructor TPolygonFromBufferAction.Destroy;
Begin
  If FPolygon <> Nil Then FPolygon.Free;
  FPolyline.Free;
  FLine.Free;
  Inherited Destroy;
End;

Procedure TPolygonFromBufferAction.DrawRubberEntityDotted(Entity: TEzEntity;
  Sender: TObject=Nil);
var
  Oldstyle: TPenstyle;
  dbox: TEzBaseDrawBox;
begin
  If Sender = Nil Then
    dbox:= CmdLine.ActiveDrawBox
  Else
    dbox:= (Sender As TEzBaseDrawBox);
  with dbox do
  begin
    Oldstyle:= RubberPen.Style;
    RubberPen.Style:=psDot;
    If Sender=Nil then
      cmdLine.All_DrawEntity2DRubberBand( Entity )
    else
      DrawEntity2DRubberBand( Entity );
    RubberPen.Style:= Oldstyle;
  end;
end;

Procedure TPolygonFromBufferAction.SuspendOperation( Sender: TObject );
begin
  If Not FReferenceDefined Then
    DrawRubberEntityDotted(FLine)
  Else
  Begin
    DrawRubberEntityDotted(FPolyLine);
    CmdLine.All_DrawEntity2DRubberBand( FPolygon )
  End;
end;

Procedure TPolygonFromBufferAction.ContinueOperation( Sender: TObject );
begin
  If Not FReferenceDefined Then
    DrawRubberEntityDotted(FLine)
  Else
  Begin
    DrawRubberEntityDotted(FPolyLine);
    cmdLine.All_DrawEntity2DRubberBand( FPolygon )
  End;
end;

Procedure TPolygonFromBufferAction.SetCurrentPoint( Const Pt: TEzPoint );
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

Procedure TPolygonFromBufferAction.MyMouseDown( Sender: TObject; Button: TMouseButton;
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
        All_DrawEntity2DRubberBand( FPolygon );
        Caption := SDefineFromPoint;
      End
      Else
        Caption := SReferenceSecondPoint;
    End Else
    Begin
      AccuDraw.UpdatePosition( FPolyLine.Points[FCurrentIndex-2], CurrPoint );
      Caption := SDefineToPoint;
    End;
  End;
End;

Procedure TPolygonFromBufferAction.MyMouseMove( Sender: TObject; Shift: TShiftState; X,
  Y: Integer; Const WX, WY: Double );
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
    {without snapping the point}
    CurrPoint := GetSnappedPoint;
    SetCurrentPoint( CurrPoint );
    If Not FReferenceDefined Then
      DrawRubberEntityDotted(FLine)
    Else
    Begin
      DrawRubberEntityDotted(FPolyLine);
      All_DrawEntity2DRubberBand( FPolygon );
    End;
  End;
End;

Procedure TPolygonFromBufferAction.MyPaint( Sender: TObject );
Begin
  If Not FReferenceDefined Then
  Begin
    If FLine <> Nil Then
      DrawRubberEntityDotted(FLine, Sender);
  End
  Else If ( FPolygon <> Nil ) And ( FPolyline <> Nil ) Then
  Begin
    DrawRubberEntityDotted(FPolyLine, Sender);
    (Sender As TEzBaseDrawBox).DrawEntity2DRubberBand( FPolygon );
  End;
End;

Procedure TPolygonFromBufferAction.UndoOperation;
Var
  CurrPoint: TEzPoint;
Begin
  If Not FReferenceDefined Then Exit;
  If FCurrentIndex = 0 Then Exit;
  Dec( FCurrentIndex );
  With CmdLine Do
  Begin
    DrawRubberEntityDotted(FPolyLine);
    All_DrawEntity2DRubberBand( FPolygon);
    CurrPoint := CmdLine.GetSnappedPoint;
    SetCurrentPoint( CurrPoint );
    DrawRubberEntityDotted(FPolyLine);
    All_DrawEntity2DRubberBand( FPolygon );
  End;
  If FCurrentIndex = 0 Then
    Caption := SDefineFromPoint
  Else
    Caption := SDefineToPoint;
End;

Procedure TPolygonFromBufferAction.MyKeyPress( Sender: TObject; Var Key: Char );
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
      If ( FCurrentIndex < 2 ) Then
      Begin
        MessageToUser( SNotEnoughData, smsgerror, MB_ICONERROR );
        Exit;
      End;
      DrawRubberEntityDotted(FPolyLine);
      All_DrawEntity2DRubberBand( FPolygon );
      {Last point is not valid because is rubber banding}
      FPolyline.Points.Delete( FCurrentIndex );
      CalcPolygon;
      {add the polygon entity }
      ActionAddNewEntity( CmdLine, TEzEntity( FPolygon ) );
      Self.Finished := true;
      Refresh;
      Key := #0;
      Exit;
    End;
End;

Procedure TPolygonFromBufferAction.CalcPolygon;
Var
  I: integer;
Begin
  {Calc polygon based on Polyline FPolyline}
  If ( FDistance = 0 ) Or ( FCurrentIndex < 1 ) Then
  Begin
    FPolygon.Points.Clear;
    For I := 0 To FPolyline.Points.Count - 1 Do
      FPolygon.Points.Add( FPolyline.Points[I] );
    Exit;
  End;
  FPolygon.free;
  FPolygon := TEzPolygon( CreateBufferFromEntity( TEzEntity( FPolyline ), 40, FDistance, False ) );
End;

{----------------------------------------------------------------------------}
//                  TRealTimeZoomAction
{----------------------------------------------------------------------------}

Constructor TRealTimeZoomAction.CreateAction( CmdLine: TEzCmdLine; UseThread: Boolean );
Begin
  Inherited CreateAction( CmdLine );

  FUseThread:= UseThread;

  OnMouseDown := MyMouseDown;
  OnMouseUp := MyMouseUp;
  OnMouseMove := MyMouseMove;
  OnKeyPress := MyKeyPress;

  Cursor:= crRealTimeZoom;

  Caption := SRealTimeZoom;

  FSaveShowWaitCursor:= CmdLine.ActiveDrawBox.GIS.ShowWaitCursor;
  FCursorGIS:= CmdLine.ActiveDrawBox.GIS;
  FCursorGIS.ShowWaitCursor:= False;
End;

destructor TRealTimeZoomAction.Destroy;
begin
  If FUseThread then
    MyStopRepaintThread;

  If CmdLine.ActiveDrawBox <> Nil then
    FCursorGIS.ShowWaitCursor:= FSaveShowWaitCursor;

  inherited;
end;

procedure TRealTimeZoomAction.MyStopRepaintThread;
begin
  if Assigned(FPaintingThread) then
   try
     FPaintingThread.Terminate;
     // wait for thread to end
     FPaintingThread.WaitFor;
     FPaintingThread.Free;
   finally
     FPaintingThread:= nil;
   end;
end;

Procedure TRealTimeZoomAction.MyThreadDone(Sender: TObject);
begin
  with FWorkDrawBox do
  begin
    CancelUpdate;
    EndRepaint;
    If FPaintingThread.PainterObject.WasUpdated then
    begin
      DoCopyCanvas;
    end;
  end;
end;

Procedure TRealTimeZoomAction.MyMouseDown( Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer; Const WX, WY: Double );
Begin
  If Button = mbRight Then Exit;
  FStartPoint := Point( X, Y );
  FWorkDrawBox:= CmdLine.ActiveDrawBox;
  FSaveParams := FWorkDrawBox.Grapher.CurrentParams;
  with FWorkDrawBox do
  begin
    Canvas.Pen.Mode:= pmCopy;
    If Not FUseThread then
      BeginUpdate;
  end;

  FRealTimeZooming := True;
End;

Procedure TRealTimeZoomAction.MyMouseMove( Sender: TObject; Shift: TShiftState;
  X, Y: Integer; Const WX, WY: Double );
Var
  PercentZoom: Double;
  DY: Integer;
  NewPoint: TPoint;
  TmpGrapher: TEzGrapher;
Begin
  If Not FRealTimeZooming Then Exit;
  NewPoint := Point( X, Y );
  With FWorkDrawBox Do
  Begin
    DY := FStartPoint.Y - NewPoint.Y;
    If (NewPoint.Y < 0) Or (NewPoint.Y > Height) Then Exit;

    PercentZoom := 1 - DY / Height;
    If PercentZoom = 0 then Exit;

    If FUseThread then
    begin
      MyStopRepaintThread;

      Grapher.CurrentParams:= FSaveParams;
      Grapher.Zoom(PercentZoom);
      with ScreenBitmap do
        ClearCanvas( Canvas, Rect(0,0,Width,Height), Color );
      FPaintingThread:= TEzPainterThread.Create( Self.MyThreadDone,
        Grapher.CurrentParams.VisualWindow, FWorkDrawBox, False, pmAll );
      FPaintingThread.Resume;
    end else
    begin
      { TmpGrapher is disposed inside the thread }
      TmpGrapher:= TEzGrapher.Create(10,adScreen);
      try
        TmpGrapher.Assign(Grapher);
        TmpGrapher.CurrentParams:= FSaveParams;
        TmpGrapher.Zoom(PercentZoom);
        ClearCanvas( Canvas, ClientRect, Color );

        With TEzPainterObject.Create(Nil) Do
        Try
          DrawEntities( TmpGrapher.CurrentParams.VisualWindow,
                        GIS,
                        Canvas,
                        TmpGrapher,
                        Selection,
                        False,
                        False,
                        pmAll,
                        ScreenBitmap );
        Finally
          Free;
        End;
      finally
        TmpGrapher.Free;
      end;
    end;
  End;
End;

Procedure TRealTimeZoomAction.MyMouseUp( Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer; Const WX, WY: Double );
Var
  PercentZoom: Double;
  DY: Integer;
  NewPoint: TPoint;
Begin
  FRealTimeZooming := False;
  If FUseThread then Exit;  // thread continues painting until next mouse move
  NewPoint := Point( X, Y );
  With FWorkDrawBox Do
  Begin
    DY := FStartPoint.Y - NewPoint.Y;
    If (NewPoint.Y < 0) Or (NewPoint.Y > Height) Then Exit;

    PercentZoom := 1 - DY / Height;
    If PercentZoom = 0 then Exit;

    Grapher.CurrentParams:= FSaveParams;
    Grapher.Zoom(PercentZoom);
    EndUpdate;
  End;
End;

Procedure TRealTimeZoomAction.MyKeyPress( Sender: TObject; Var Key: Char );
Begin
  With CmdLine.ActiveDrawBox Do
    If Key In [#13, #27] Then
    Begin
      Self.Finished := true;
      Key := #0;
    End;
End;

{----------------------------------------------------------------------------}
//                  TRealTimeZoomActionB
{----------------------------------------------------------------------------}

Constructor TRealTimeZoomActionB.CreateAction( CmdLine: TEzCmdLine );
Begin
  Inherited CreateAction( CmdLine );

  OnMouseDown := MyMouseDown;
  OnMouseUp := MyMouseUp;
  OnMouseMove := MyMouseMove;
  OnKeyPress := MyKeyPress;
  OnPaint:= MyPaint;

  FWorkBmp:= TBitmap.Create;

  Cursor:= crRealTimeZoom;

  Caption := SRealTimeZoom;

  FCursorGIS:= CmdLine.ActiveDrawBox.GIS;
  FSaveShowWaitCursor:= FCursorGIS.ShowWaitCursor;
  FCursorGIS.ShowWaitCursor:= False;
End;

destructor TRealTimeZoomActionB.destroy;
begin
  FWorkBmp.Free;
  FCursorGIS.ShowWaitCursor:= FSaveShowWaitCursor;
  inherited;
end;

Procedure TRealTimeZoomActionB.MyMouseDown( Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer; Const WX, WY: Double );
var
  factor, BmpW, BmpH: integer;
  //RealW, RealH: Double;
  //WRect: TEzRect;
  TmpGrapher: TEzGrapher;

  Procedure BuildRect(const ARect: TEzRect);
  begin
    With CmdLine.ActiveDrawBox, TEzPainterObject.Create(Nil) Do
    Try
      DrawEntities( ARect,
                    GIS,
                    FWorkBmp.Canvas,
                    TmpGrapher,
                    Selection,
                    False,
                    False,
                    pmAll,
                    FWorkBmp );
    Finally
      Free;
    End;
  end;

Begin
  If Button = mbRight Then Exit;
  factor:= 1;
  with CmdLine.ActiveDrawBox.ScreenBitmap do
  begin
    BmpW:= Width;
    BmpH:= Height;
    If FWorkBmp.Width <> BmpW*factor then
      FWorkBmp.Width:= BmpW*factor;
    If FWorkBmp.Height <> BmpH*factor then
      FWorkBmp.Height:= BmpH*factor;
    If FWorkBmp.PixelFormat <> PixelFormat then
      FWorkBmp.PixelFormat:= PixelFormat;
  end;
  FStartPoint := Point( X, Y );
  FSaveParams := CmdLine.ActiveDrawBox.Grapher.CurrentParams;
  FWorkBmp.Canvas.Draw(0,0,CmdLine.ActiveDrawBox.ScreenBitmap);
  FRealTimeZooming := True;
  CmdLine.ActiveDrawBox.BeginUpdate;
End;

Procedure TRealTimeZoomActionB.MyMouseUp( Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer; Const WX, WY: Double );
var
  NewPoint: TPoint;
  //TmpR, NewWindow: TRect;
  //ViewWindow: TEzRect;
Begin
  If FRealTimeZooming Then
  begin
    FRealTimeZooming := False;
    {with CmdLine.ActiveDrawBox do
      ClearCanvas( Canvas, ClientRect, Color ); }
    NewPoint := Point( X, Y );
    With CmdLine.ActiveDrawBox Do
    Begin
      Grapher.CurrentParams:= FSaveParams;
      //ViewWindow:= Grapher.CurrentParams.VisualWindow;
      Grapher.Zoom( 1 - (FStartPoint.Y - NewPoint.Y) / Height );
      {NewWindow:= Grapher.RealToRect(ViewWindow);
      If (NewWindow.Right - NewWindow.Left) < (ClientRect.Right - ClientRect.Left) then
      Begin
        //zoom out
        TmpR:= FWorkBmp.Canvas.ClipRect;
        InflateRect(TmpR,-1,-1);
        ScreenBitmap.Canvas.CopyRect(NewWindow, FWorkBmp.Canvas, TmpR);
        // repintaremos solo la area no cubierta
        TmpR:= Rect(0,0,ClientRect.Right,NewWindow.Top);
        RepaintRect(Grapher.RectToReal(TmpR));

        TmpR:= Rect(NewWindow.Right,NewWindow.Top,ClientRect.Right,ClientRect.Bottom);
        RepaintRect(Grapher.RectToReal(TmpR));

        TmpR:= Rect(0,NewWindow.Bottom,NewWindow.Right,ClientRect.Bottom);
        RepaintRect(Grapher.RectToReal(TmpR));

        TmpR:= Rect(0,NewWindow.Top,NewWindow.Left,NewWindow.Bottom);
        RepaintRect(Grapher.RectToReal(TmpR));
      End Else }
        //Repaint;
        CmdLine.ActiveDrawBox.EndUpdate;
    End;
  End;
End;

Procedure TRealTimeZoomActionB.MyMouseMove( Sender: TObject; Shift: TShiftState;
  X, Y: Integer; Const WX, WY: Double );
Begin
  MyPaint(Nil);
End;

Procedure TRealTimeZoomActionB.MyPaint( Sender: TObject );
Var
  PercentZoom: Double;
  NewPoint: TPoint;
  NewWindow, OldWindow,TmpR: TRect;
  ViewWindow: TEzRect;
  DY: Integer;
begin
  If Not FRealTimeZooming then Exit;
  { now clear the internal bitmap used }
  with CmdLine.ActiveDrawBox do
  begin
    NewPoint := Grapher.RealToPoint(CmdLine.CurrentPoint);
    If (NewPoint.Y < 0) Or (NewPoint.Y > Height) Then Exit;
    DY := FStartPoint.Y - NewPoint.Y;
    PercentZoom := 1 - DY / Height;
    If PercentZoom <= 0 then Exit;

    { restablece parametros al iniciar el zoom dinamico }
    Grapher.CurrentParams:= FSaveParams;

    { calcula la ventana actual }
    ViewWindow:= Grapher.CurrentParams.VisualWindow;
    OldWindow:= Grapher.RealToRect(ViewWindow);

    { ahora aplica el zoom }
    Grapher.Zoom( PercentZoom );

    { calcula la ventana nueva }
    NewWindow:= Grapher.RealToRect(ViewWindow);

    { clear corresponding canvas }
    If PercentZoom > 1 then
    begin
      // zoom in - clear only no update area
      TmpR:= Rect(0,0,ClientRect.Right,NewWindow.Top);
      ClearCanvas( Canvas, TmpR, Color );

      TmpR:= Rect(NewWindow.Right,NewWindow.Top,ClientRect.Right,ClientRect.Bottom);
      ClearCanvas( Canvas, TmpR, Color );

      TmpR:= Rect(0,NewWindow.Bottom,NewWindow.Right,ClientRect.Bottom);
      ClearCanvas( Canvas, TmpR, Color );

      TmpR:= Rect(0,NewWindow.Top,NewWindow.Left,NewWindow.Bottom);
      ClearCanvas( Canvas, TmpR, Color );

      //ClearCanvas( Canvas, ClientRect, Color );

    end;
    //If (NewWindow.Right - NewWindow.Left) < (OldWindow.Right - OldWindow.Left) then
    //begin
      { se hizo zoom out}
      Canvas.CopyRect(NewWindow, FWorkBmp.Canvas, FWorkBmp.Canvas.ClipRect);
    (*end else
    begin
      { se hizo zoom in}
    end; *)
  end;
end;

Procedure TRealTimeZoomActionB.MyKeyPress( Sender: TObject; Var Key: Char );
Begin
  With CmdLine.ActiveDrawBox Do
    If Key In [#13, #27] Then
    Begin
      Self.Finished := true;
      Key := #0;
    End;
End;

{----------------------------------------------------------------------------}
//                  TOSNAPAction
{----------------------------------------------------------------------------}

Function GetSnapPt( CmdLine: TEzCmdLine; Aperture: Integer;
  Setting: TEzOSNAPSetting; Const PivotLayerName: string;
  Var ALayer: TEzBaseLayer; Var ARecno: Integer;
  Var SnapPt: TEzPoint; Var IsSnappedPointOnEntity: Boolean;
  Var RefFrom, RefTo: TEzPoint ): Boolean;
Var
  CurrPoint, Pt1, Pt2, TmpPt: TEzPoint;
  TmpLayer: TEzBaseLayer;
  cnt, I, J, K,n1, n2, Recno, Idx1,Idx2: Integer;
  PickedPoint: Integer;
  TmpEnt: TEzEntity;
  Picked, IsTemp: Boolean;
  StackedList: TStringList;
  EList: TList;
  TmpVect1, TmpVect2, IntVect: TEzVector;
  TmpDist, Distance, Delta, TmpAngle: Double;
  TmpNPoint, Cntr: Integer;
  RealAperture: TEzPoint;
  TestDist, NewAperture, MinDist: Double;
  ASetting: TEzOsnapSetting;
  TempCurvePoints: Integer;
  TmpV: TEzVector;
  OldCanGrow: Boolean;
  d1,d2,x0,y0,X1,Y1,Rad:Double;
  Center,LClicked: TEzPoint;
  M: TEzMatrix;
  TmpEllipse: TEzEntity;
  TestEnt: TEzEntity;
Begin
  ALayer:= Nil;
  ARecno:= 0;
  SnapPt:= Point2d(0,0);
  Result := False;
  IsSnappedPointOnEntity:=false;
  ASetting:= Setting;
  { for very few snap divisor, considere only the end points}
  If (Setting=osKeyPoint) And (CmdLine.AccuSnap.SnapDivisor < 2) Then
    ASetting:=osEndPoint;

  { for parallel and perpend snap, search on nearest vertex }
  If Setting = osParallel Then
    ASetting:= osNearest;

  With CmdLine.ActiveDrawBox Do
  Begin
    CurrPoint := CmdLine.CurrentPoint;
    //List := Nil;
    //If ASetting = osIntersect Then
    StackedList := TStringList.Create;
    Try
      With CmdLine.ActiveDrawBox Do
      Begin
        Picked := PickEntity( CurrPoint.X,
                              CurrPoint.Y,
                              Aperture,
                              PivotLayerName,
                              ALayer,
                              ARecNo,
                              PickedPoint,
                              StackedList );
        { if it is selected then don't use it }
        {If Picked And CmdLine.ActiveDrawBox.Selection.IsSelected( ALayer, ARecNo ) Then
          Picked := False; }
        RealAperture := Point2D( Grapher.DistToRealX( Aperture div 2 ),
                                 Grapher.DistToRealY( Aperture div 2) );
        If RealAperture.X > RealAperture.Y Then
          NewAperture := RealAperture.X
        Else
          NewAperture := RealAperture.Y;
        NewAperture := Sqrt( 2 ) * NewAperture;
        MinDist := NewAperture;

        IsTemp:= False;
        // [!!!] привязки не работают, если под временным объектом есть еще что-нибудь
//        If ( (Not Picked And (ASetting<>osIntersect)) Or (Picked And (ASetting = osIntersect)) ) And
        if (EzSystem.GlobalTempEntity <> nil) And (EzSystem.GlobalTempEntity.Points.Count > 2) And
           (EzSystem.GlobalTempEntity.EntityID<>idArc) then
        begin
          TmpV:= EzSystem.GlobalTempEntity.Points;
          with EzSystem.GlobalTempEntity do
          begin
            OldCanGrow:= Points.CanGrow;
            Points.CanGrow:= True;
            Points.Count:= Points.Count-1;
            TmpNPoint := PointCode( CurrPoint, NewAperture, Distance, Ez_Preferences.SelectPickingInside );
            Points.Count:= Points.Count+1;
            Points.CanGrow:= OldCanGrow;
          end;
          If (TmpNPoint >= PICKED_INTERIOR) And (Distance <= MinDist) Then
          Begin
            Picked := true;
            PickedPoint:= TmpNPoint;

            if ASetting = osIntersect then
              StackedList.AddObject('',Nil);

            IsTemp:= True;
          end;
        end;
      End;
      If Picked Then
      Begin
        Cntr:= 0;
        repeat

          TmpEnt := Nil;

          if IsTemp then
            TmpEnt := EzSystem.GlobalTempEntity
          else
          begin
            If StackedList.Count > 0 then
            begin
              ALayer:= GIS.Layers.LayerByName( StackedList[Cntr] );
              ARecno:= Longint( StackedList.Objects[Cntr] );
              TmpEnt := ALayer.LoadEntityWithRecno( ARecno );
              PickedPoint:= TmpEnt.PointCode( CurrPoint, NewAperture, Distance,
                Ez_Preferences.SelectPickingInside );
            end
            Else
              Break;
          end;
          Try

            If (TmpEnt <> Nil) and ( ((TmpEnt.Points.Count=1) And
               (ASetting in [osEndPoint,osMidpoint,osCenter,osOrigin,osNearest,osKeyPoint]) ) Or
               (TmpEnt.Points.Count > 1) ) Then
            Begin
              Result := True;
              Case ASetting Of
                osBisector:
                  begin
                    If TmpEnt.Points.Count > 1 then
                    begin
                      TmpEnt.DrawPoints.TravelDistance( TmpEnt.Perimeter/2,SnapPt,Idx1,Idx2);
                    end else
                    begin
                      SnapPt:= TmpEnt.Points[0];
                    end;
                  end;
                osKeyPoint:
                  begin
                    If TmpEnt.Points.Count = 1 Then
                    begin
                      SnapPt:= TmpEnt.Points[0];
                    end Else If (TmpEnt.Points.Count > 1) And (TmpEnt.EntityID In [idArc, idEllipse]) Then
                    Begin
                      { split the aperture in equal slices }
                      If TmpEnt.EntityID=idArc Then
                      begin
                        TempCurvePoints:= TEzArc( TmpEnt ).PointsInCurve;
                        TEzArc( TmpEnt ).PointsInCurve:= CmdLine.AccuSnap.SnapDivisor + 1;
                      end Else
                      begin
                        TempCurvePoints:= TEzEllipse( TmpEnt ).PointsInCurve;
                        TEzEllipse( TmpEnt ).PointsInCurve:= CmdLine.AccuSnap.SnapDivisor * 4;
                      end;
                      { calculate now which point is closets to the current point }
                      SnapPt:= TmpEnt.DrawPoints[0];
                      TestDist:= Dist2D( CurrPoint, SnapPt );
                      for Cnt:= 1 to TmpEnt.DrawPoints.Count-1 do
                        If Dist2d( CurrPoint, TmpEnt.DrawPoints[Cnt] ) < TestDist Then
                        Begin
                          SnapPt:= TmpEnt.DrawPoints[Cnt];
                          TestDist:= Dist2d( CurrPoint, SnapPt );
                        End;
                      If TmpEnt.EntityID=idArc Then
                      begin
                        TEzArc( TmpEnt ).PointsInCurve:= TempCurvePoints;
                      end Else
                      begin
                        TEzEllipse( TmpEnt ).PointsInCurve:= TempCurvePoints;
                      end;
                    End Else If TmpEnt.Points.Count > 1 Then
                    Begin
                      { split every segment of the entity in n parts }
                      If ( PickedPoint >= PICKED_POINT ) And ( TmpEnt.Points.Count = 1 ) And
                         ( Ez_Preferences.GNumPoint = 0 ) Then
                      Begin
                        SnapPt := TmpEnt.Points[0];
                      End
                      Else If ( PickedPoint >= PICKED_POINT ) And ( Ez_Preferences.GNumPoint >= 0 ) And
                        ( TmpEnt.DrawPoints.Count > 1 ) Then
                      Begin
                        // Clicked in any line segment
                        If PickedPoint >= 0 Then
                        Begin
                          n1 := PickedPoint;
                          If PickedPoint = TmpEnt.DrawPoints.Count - 1 Then
                            n2 := 0
                          Else
                            n2 := Succ( PickedPoint );
                        End
                        Else {if PickedPoint = PICKED_POINT then}
                        Begin
                          n1 := Ez_Preferences.GNumPoint;
                          If n1 = TmpEnt.DrawPoints.Count - 1 Then
                            n2 := 0
                          Else
                            n2 := Succ( n1 );
                        End;
                        Pt1 := TmpEnt.DrawPoints[n1];
                        Pt2 := TmpEnt.DrawPoints[n2];
                        TmpAngle:= Angle2d(Pt1, Pt2 );
                        Delta:= Dist2d( Pt1, Pt2 ) / CmdLine.AccuSnap.SnapDivisor;

                        SnapPt:= TmpEnt.DrawPoints[n1];
                        TestDist:= Dist2D( CurrPoint, SnapPt );
                        for Cnt:= 1 to CmdLine.AccuSnap.SnapDivisor do
                        begin
                          TmpPt:= Point2d( Pt1.X + Cos(TmpAngle) * (Delta * Cnt),
                                           Pt1.Y + Sin(TmpAngle) * (Delta * Cnt) );
                          If Dist2d( CurrPoint, TmpPt ) < TestDist Then
                          Begin
                            SnapPt:= TmpPt;
                            TestDist:= Dist2d( CurrPoint, SnapPt );
                          End;
                        end;
                      End Else
                        Result:= False;
                    End;
                  end;
                osEndPoint, osMidPoint, osPerpend, osNearest:
                  Begin
                    If ( PickedPoint >= PICKED_POINT ) And ( TmpEnt.Points.Count = 1 ) And
                      ( Ez_Preferences.GNumPoint = 0 ) Then
                    Begin
                      SnapPt := TmpEnt.Points[0];
                      If ASetting in [osPerpend, osParallel] Then
                        Result:= False;
                    End
                    Else If ( PickedPoint >= PICKED_POINT ) And ( Ez_Preferences.GNumPoint >= 0 ) And
                      ( TmpEnt.DrawPoints.Count > 1 ) Then
                    Begin
                      // Clicked in any line segment
                      If PickedPoint >= 0 Then
                      Begin
                        n1 := PickedPoint;
                        If PickedPoint = TmpEnt.DrawPoints.Count - 1 Then
                          n2 := 0
                        Else
                          n2 := Succ( PickedPoint );
                      End
                      Else {if PickedPoint = PICKED_POINT then}
                      Begin
                        n1 := Ez_Preferences.GNumPoint;
                        If n1 = TmpEnt.DrawPoints.Count - 1 Then
                          n2 := 0
                        Else
                          n2 := Succ( n1 );
                      End;
                      Pt1 := TmpEnt.DrawPoints[n1];
                      Pt2 := TmpEnt.DrawPoints[n2];
                      If ASetting = osEndPoint Then
                      Begin
                        (* Now find the closest point to CurrPoint *)
                        If Dist2D( CurrPoint, Pt1 ) < Dist2D( CurrPoint, Pt2 ) Then
                          SnapPt := Pt1
                        Else
                          SnapPt := Pt2;
                      End
                      Else If ASetting = osMidPoint Then
                      Begin
                        If TmpEnt.EntityID in [idArc, idEllipse] Then
                          TmpEnt.Centroid( SnapPt.X, SnapPt.Y )
                        Else
                        begin
                          SnapPt.X := ( Pt1.X + Pt2.X ) / 2;
                          SnapPt.Y := ( Pt1.Y + Pt2.Y ) / 2;
                        end;
                      End
                      Else If ASetting = osPerpend Then
                      Begin
                        If Not EqualPoint2d(CmdLine.CurrentAction.LastClicked, INVALID_POINT) Then
                          TmpPt:= CmdLine.CurrentAction.LastClicked
                        Else
                          TmpPt:= CmdLine.CurrentPoint;

                        SnapPt:= Perpend( TmpPt, Pt1, Pt2 );

                        RefFrom:= Pt1;
                        RefTo:= Pt2;
                      End
                      Else If ASetting = osNearest Then
                      Begin
                        SnapPt := Perpend( CurrPoint, Pt1, Pt2 );
                        If Setting = osParallel then
                        begin
                          RefFrom:= Pt1;
                          RefTo:= Pt2;
                        end;
                      End;
                    End
                    Else If ( ( PickedPoint = PICKED_POINT ) Or ( PickedPoint = PICKED_INTERIOR ) ) And
                      ( TmpEnt.Points.Count = 1 ) Then
                    Begin
                      SnapPt := TmpEnt.Points[0];
                      If Setting in [osPerpend, osParallel] Then
                        Result:= False;
                    End Else
                      Result := false; // not valid
                  End;
                osTangent:
                    { tangent to an ellipse or arc }
                  If (TmpEnt.EntityID in [idArc, idEllipse]) And
                     Not EqualPoint2d(CmdLine.CurrentAction.LastClicked, INVALID_POINT) Then
                  Begin
                     { translate the entity to the origin }
                     //a:= 0;
                     //b:= 0;
                     If TmpEnt.EntityID = idArc Then
                     begin
                       TEzArc(TmpEnt).CalcCenterRadius;
                       Rad:= TEzArc(TmpEnt).Radius;
                       Pt1:= Point2d(TEzArc(TmpEnt).CenterX-Rad,
                                     TEzArc(TmpEnt).CenterY-Rad);
                       Pt2:= Point2d(TEzArc(TmpEnt).CenterX+Rad,
                                     TEzArc(TmpEnt).CenterY+Rad);
                       TmpEllipse:= TEzEllipse.CreateEntity(Pt1,Pt2);
                       TEzEllipse(TmpEllipse).PointsInCurve:= 200;
                       TestEnt:= TmpEllipse;
                     End Else If TmpEnt.EntityID = idEllipse Then
                     Begin
                       TEzEllipse(TmpEnt).PointsInCurve:= 200;
                       Rad:= Abs(TEzEllipse(TmpEnt).Points[1].X-TEzEllipse(TmpEnt).Points[0].X)/2;
                       TestEnt:= TmpEnt;
                     End;
                     If Rad=0 then
                       Result:=false
                     else
                       Try
                         d1:= MAXCOORD;
                         I:= 0;
                         J:= -1;
                         while I < TestEnt.DrawPoints.Count-1 do
                         begin
                          Pt1:= TestEnt.DrawPoints[I];
                          Pt2:= TestEnt.DrawPoints[I+1];
                          TmpPt:= Perpend( CmdLine.CurrentAction.LastClicked, Pt1, Pt2);
                          d2:=Dist2d(CmdLine.CurrentAction.LastClicked,TmpPt);
                          If d2 <= d1 then
                          begin
                            d1:= d2;
                            J:= I;
                          end;
                          Inc(I);
                         end;
                         If J=-1 then
                            Result:= false
                         Else
                         Begin
                           { now find the other point that is not the same as J }
                           d1:= MAXCOORD;
                           I:= 0;
                           K:= -1;
                           while I < TestEnt.DrawPoints.Count-1 do
                           begin
                            Pt1:= TestEnt.DrawPoints[I];
                            Pt2:= TestEnt.DrawPoints[I+1];
                            TmpPt:= Perpend( CmdLine.CurrentAction.LastClicked, Pt1, Pt2);
                            d2:=Dist2d(CmdLine.CurrentAction.LastClicked,TmpPt);
                            If (d2 <= d1) And (I<>J) then
                            begin
                              d1:= d2;
                              K:= I;
                            end;
                            Inc(I);
                           end;
                           { check which point is closest }
                           If Dist2d( CurrPoint, TestEnt.DrawPoints[J] ) <
                              Dist2d( CurrPoint, TestEnt.DrawPoints[K] ) Then
                              I:= J
                           Else
                            I:= K;
                           SnapPt:= Point2d( (TestEnt.DrawPoints[I].X+TestEnt.DrawPoints[I+1].X)/2,
                             (TestEnt.DrawPoints[I].Y+TestEnt.DrawPoints[I+1].Y)/2);
                         End;
                       finally
                         If TmpEnt.EntityID = idArc Then
                           TmpEllipse.Free;
                       end;
                  end Else
                    Result:=False;
                osOrigin:
                  { el primer punto aqui }
                  If TmpEnt.Points.Count > 0 Then
                    SnapPt := TmpEnt.Points[0]
                  Else
                    Result:= False;
                osCenter:
                  Begin
                    If TmpEnt.Points.Count > 1 Then
                    Begin
                      //If Not TmpEnt.IsClosed Then
                      //  Result := false
                      //Else
                      TmpEnt.Centroid( SnapPt.X, SnapPt.Y );
                    End Else
                    Begin
                     { un solo punto aqui }
                     SnapPt := TmpEnt.Points[0];
                    End;
                  End;
                osIntersect:
                  If StackedList.Count > 1 Then
                  Begin
                    (* First, read all entities *)
                    EList := TList.Create;
                    IntVect := TEzVector.Create( 4 ); // 4=average used in entities
                    TmpVect1 := TEzVector.Create( 4 );
                    TmpVect2 := TEzVector.Create( 4 );
                    Try
                      For cnt := 0 To StackedList.Count - 1 Do
                      Begin
                        With CmdLine.ActiveDrawBox Do
                        Begin
                          Recno:= Longint( StackedList.Objects[cnt] );
                          if Recno > 0 then
                          begin
                            TmpLayer := GIS.Layers.LayerByName( StackedList[cnt] );
                            EList.Add( TmpLayer.LoadEntityWithRecno( Recno ) );
                          end else
                            EList.Add( EzSystem.GlobalTempEntity );
                        End
                      End;
                      TmpDist := MAXCOORD;
                      For cnt := 0 To EList.Count - 2 Do
                      Begin
                        With TEzEntity( EList[cnt] ) Do
                        Begin
                          TmpVect1.Assign( DrawPoints );
                          (* if EntityID in [idPolygon] and not
                             IsEqualPoint2D(TmpVect1[0], TmpVect1[TmpVect1.Count-1]) then
                             TmpVect1.Add(TmpVect1[0]); *)
                        End;
                        if TEzEntity( EList[cnt] ) = EzSystem.GlobalTempEntity then
                          TmpVect1.Delete( TmpVect1.Count - 1);
                        With TEzEntity( EList[cnt + 1] ) Do
                        Begin
                          TmpVect2.Assign( DrawPoints );
                          (* if EntityID in [idPolygon] and not
                             IsEqualPoint2D(TmpVect2[0], TmpVect1[TmpVect2.Count-1]) then
                             TmpVect2.Add(TmpVect2[0]); *)
                        End;
                        if TEzEntity( EList[cnt + 1] ) = EzSystem.GlobalTempEntity then
                          TmpVect2.Delete( TmpVect2.Count - 1);
                        If VectIntersect( TmpVect1, TmpVect2, IntVect, true ) Then
                        Begin
                          For J := 0 To IntVect.Count - 1 Do
                          Begin
                            Distance := Dist2D( CurrPoint, IntVect[J] );
                            If Distance < TmpDist Then
                            Begin
                              TmpDist := Distance;
                              SnapPt := IntVect[J];
                            End;
                          End;
                        End;
                      End;
                    Finally
                      For cnt := 0 To EList.Count - 1 Do
                      begin
                        if TEzEntity( EList[cnt] ) <> EzSystem.GlobalTempEntity then
                          TEzEntity( EList[cnt] ).Free;
                      end;
                      EList.Free;
                      IntVect.Free;
                      TmpVect1.Free;
                      TmpVect2.Free;
                    End;
                  End
                  Else
                    Result := false;
              End;
            End ;
            If Result And (TmpEnt <> Nil) Then
            Begin
              IsSnappedPointOnEntity:=
                TmpEnt.PointCode(SnapPt, NewAperture, Distance, False ) <> PICKED_NONE;
            End;
          Finally
            If Not IsTemp And (TmpEnt <> Nil) Then
              FreeAndNil( TmpEnt );
          End;

          If Result Then Break;

          If Not IsTemp Then
          begin
            Inc(Cntr);
            If Cntr > StackedList.Count-1 then Break;
          end Else
            Break;

        until False;
      End;
    Finally
      //If ASetting = osINTERSECT Then
      StackedList.Free;
    End;
  End;
End;

{----------------------------------------------------------------------------}
//                  TClipPolyAction
{----------------------------------------------------------------------------}

Constructor TClipPolyAction.CreateAction( CmdLine: TEzCmdLine );
Begin
  Inherited CreateAction( CmdLine );

  FEntity := TEzPolygon.CreateEntity( [Point2D(0, 0)] );

  CanDoOsnap := True;
  CanDoAccuDraw:= True;
  MouseDrawElements:= [mdCursorFrame, mdFullViewCursor];

  OnMouseDown := MyMouseDown;
  OnMouseMove := MyMouseMove;
  OnKeyPress := MyKeyPress;
  OnPaint := MyPaint;
  OnSuspendOperation := Self.SuspendOperation;
  OnContinueOperation := Self.ContinueOperation;

  Cursor:= crDrawCross;

  SetAddActionCaption;

  If CmdLine.ActiveDrawBox.Selection.Count = 0 Then
    MessageToUser( SWarnNoSelection, smsgerror, MB_ICONERROR );

End;

Destructor TClipPolyAction.Destroy;
Begin
  FEntity.Free;
  Inherited Destroy;
End;

procedure TClipPolyAction.SuspendOperation(Sender: TObject);
begin
  If Assigned( FEntity ) Then
    CmdLine.All_DrawEntity2DRubberBand( FEntity );
end;

procedure TClipPolyAction.ContinueOperation(Sender: TObject);
begin
  If Assigned( FEntity ) Then
    CmdLine.All_DrawEntity2DRubberBand( FEntity );
end;

Procedure TClipPolyAction.SetCurrentPoint( Pt: TEzPoint; Orto: Boolean );
Var
  cnt: Integer;
Begin
  If Orto And ( FCurrentIndex > 0 ) Then
    Pt := ChangeToOrtogonal( FEntity.Points[FCurrentIndex - 1], Pt );
  FEntity.Points[FCurrentIndex] := Pt;
  For cnt := FCurrentIndex + 1 To FEntity.Points.Count - 1 Do
    FEntity.Points[cnt] := Pt;
End;

Procedure TClipPolyAction.MyMouseDown( Sender: TObject; Button: TMouseButton;
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
  CurrPoint := CmdLine.GetSnappedPoint;
  SetCurrentPoint( CurrPoint, CmdLine.UseOrto );
  Inc( FCurrentIndex );
  SetAddActionCaption;
End;

Procedure TClipPolyAction.SetAddActionCaption;
Var
  Text: String;
Begin
  Case FCurrentIndex Of
    0: Text := SFirstPoint;
    1: Text := SSecondPoint;
    2: Text := SThirdPoint;
    3: Text := SFourthPoint;
    4: Text := SFifthPoint;
  Else
    Text := SNextPoint;
  End;
  Caption := SClipPolygon + Text;
End;

Procedure TClipPolyAction.MyMouseMove( Sender: TObject; Shift: TShiftState;
  X, Y: Integer; Const WX, WY: Double );
Var
  CurrPoint: TEzPoint;
Begin
  With CmdLine Do
  Begin
    All_DrawEntity2DRubberBand( FEntity );
    CurrPoint := CmdLine.GetSnappedPoint;
    SetCurrentPoint( CurrPoint, CmdLine.UseOrto );
    All_DrawEntity2DRubberBand( FEntity );
  End;
End;

Procedure TClipPolyAction.MyPaint( Sender: TObject );
Begin
  If FEntity <> Nil Then
    (Sender As TEzBaseDrawBox).DrawEntity2DRubberBand( FEntity );
End;

Procedure TClipPolyAction.UndoOperation;
Var
  CurrPoint: TEzPoint;
Begin
  With CmdLine Do
  Begin
    All_DrawEntity2DRubberBand( FEntity );
    If FCurrentIndex > 0 Then
      Dec( FCurrentIndex );
    CurrPoint := CmdLine.GetSnappedPoint;
    SetCurrentPoint( CurrPoint, CmdLine.UseOrto );
    All_DrawEntity2DRubberBand( FEntity );
    SetAddActionCaption;
  End;
End;

Procedure TClipPolyAction.MyKeyPress( Sender: TObject; Var Key: Char );
Var
  NewRecno: Integer;

  //------------ clip polygons section
  Procedure clipit;
  Var
    TmpEnt: TEzEntity;
    LayerList: TList;
    subject, clipping, result: TEzEntityList;
    I, J, FirstRecno: Integer;
    SourceLayer: TEzBaseLayer;
    tmpOp: TEzPolyClipOp;
    IsSame: Boolean;
  Begin
    FirstRecno := 0;
    With CmdLine.ActiveDrawBox Do
    Begin
      If selection.numselected = 0 Then exit;
      subject := TEzEntityList.create;
      clipping := TEzEntityList.create;
      result := TEzEntityList.create;
      LayerList := TList.Create;
      Try
        SourceLayer := Nil;
        For J := 0 To Selection.Count - 1 Do
          With Selection[J] Do
            For I := 0 To SelList.Count - 1 Do
            Begin
              TmpEnt := Layer.LoadEntityWithRecno( SelList[I] );
              If TmpEnt.IsClosed And
                Not ( TmpEnt.EntityID In [idPlace,
                idFittedVectText,
                  idJustifVectText,
                  idPictureRef,
                  idTable] ) Then
              Begin
                subject.add( TmpEnt );
                LayerList.Add( Layer );
                If SourceLayer = Nil Then
                Begin // used to copy the DB record
                  SourceLayer := Layer;
                  FirstRecno := I;
                End;
              End
              Else
              Begin
                TmpEnt.Free;
                Selection.Delete( Layer, I ); // unselect it
              End;
            End;
        IsSame := True;
        For J := 1 To LayerList.Count - 1 Do // all selected are of same layer ?
          If Not ( TEzBaseLayer( LayerList[J] ) = TEzBaseLayer( LayerList[0] ) ) Then
          Begin
            IsSame := False;
            Break;
          End;
        Clipping.Add( FEntity );
        // do the clipping
        tmpOp := GIS.PolygonClipOperation.Operation;
        If tmpOp = pcSPLIT Then
          tmpOp := pcDIFF;
        PolygonClip( tmpOp, subject, clipping, result, Nil );
        For I := 0 To result.count - 1 Do
        Begin
          TmpEnt := result[I];
          NewRecno := AddEntity( GIS.CurrentLayerName, TmpEnt );
          (* Now, copy the DB record *)
          If IsSame Then
            SourceLayer.CopyRecord( FirstRecno, NewRecno );
        End;
        tmpOp := GIS.PolygonClipOperation.Operation;
        If tmpOp = pcSPLIT Then
        Begin
          FreeAndNil( result );
          result := TEzEntityList.Create;
          tmpOp := pcINT;
          polygonClip( tmpOp, clipping, subject, result, Nil );
          For I := 0 To result.count - 1 Do
          Begin
            TmpEnt := result[I];
            NewRecno := AddEntity( GIS.CurrentLayerName, TmpEnt );
            // Now, copy the record
            If IsSame Then
              SourceLayer.CopyRecord( FirstRecno, NewRecno );
          End;
        End;
        clipping.Extract( 0 );
        If Not GIS.PolygonClipOperation.PreserveOriginals Then
          DeleteSelection;
        Repaint;
      Finally
        subject.free;
        clipping.free;
        result.free;
        LayerList.free;
      End;
    End;
  End;
  //----------------- end of clip polygons section

Begin
  With CmdLine Do
    Case Key Of
      #27:
        Begin
          {cancels the insertion}
          All_DrawEntity2DRubberBand( FEntity );
          Self.Finished := true;
        End;
      #13:
        Begin
          If FCurrentIndex <= 2 Then
          Begin
            MessageToUser( SNotEnoughData, smsgerror, MB_ICONERROR );
            Exit;
          End;
          (* Erase entity from screen and last point*)
          All_DrawEntity2DRubberBand( FEntity );
          FEntity.Points.Delete( FCurrentIndex );
          Try
            (* do the clipping in the polygons *)
            clipit;
          Except
            On E: Exception Do
              MessageToUser( E.Message, smsgerror, MB_ICONERROR );
          End;

          Self.Finished := true;
          Key := #0;
          Exit;
        End;
    End;
End;

{----------------------------------------------------------------------------}
//                  TBreakAction
{----------------------------------------------------------------------------}

Constructor TBreakAction.CreateAction( CmdLine: TEzCmdLine );
Begin
  Inherited CreateAction( CmdLine );

  CanBeSuspended := false;

  FAperture := Ez_Preferences.ApertureWidth;

  CanDoOsnap := True;
  CanDoAccuDraw:= True;
  MouseDrawElements:= [mdCursorFrame, mdFullViewCursor];

  OnMouseDown := MyMouseDown;
  OnKeyPress := MyKeyPress;

  Cursor := crDrawCross;

  Caption := SBreakSelectFirstPoint;
End;

Procedure QuickSortDistList( SortList: TList; L, R: Integer );
Var
  I, J: Integer;
  P, T: TDistRec;
Begin
  If SortList.Count < 2 Then
    exit;
  Repeat
    I := L;
    J := R;
    P := PDistRec( SortList[( L + R ) Shr 1] )^;
    Repeat
      While PDistRec( SortList[I] )^.D < P.D Do
        Inc( I );
      While PDistRec( SortList[J] )^.D > P.D Do
        Dec( J );
      If I <= J Then
      Begin
        T := PDistRec( SortList[I] )^;
        PDistRec( SortList[I] )^ := PDistRec( SortList[J] )^;
        PDistRec( SortList[J] )^ := T;
        Inc( I );
        Dec( J );
      End;
    Until I > J;
    If L < J Then
      QuickSortDistList( SortList, L, J );
    L := I;
  Until I >= R;
End;

Procedure TBreakAction.MyMouseDown( Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer; Const WX, WY: Double );
Var
  Pt1, Pt2, CurrPoint: TEzPoint;
  TmpLayer: TEzBaseLayer;
  NewRecno, TmpRecNo, N: Integer;
  FPickedPoint: Integer;
  Picked: Boolean;
  ClipEntity: TEzEntity;
  TmpEnt: TEzEntity;

  Procedure clippline;
  Var
    PartialEnt: TEzEntity;
    K, cnt, NumClipped: Integer;
    IntVect: TEzVector;
    PtA, PtB, p1, p2, p3, p4: TEzPoint;
    SegmentVect: TEzVector;
    SortList: TList;
    DistRec: PDistRec;
  Begin
    With CmdLine.ActiveDrawBox Do
    Begin
      NumClipped := 0;
      // read entity to clip
      TmpEnt := FLayer.LoadEntityWithRecno( FRecNo );
      Undo.BeginUndo( uaUnTransform );
      Try
        // will analize this entity TmpEnt
        IntVect := TEzVector.Create( 2 );
        SegmentVect := TEzVector.Create( 2 );
        PartialEnt := TEzPolyLine.CreateEntity( [Point2D(0, 0)] );
        Try
          PartialEnt.Points.Clear;
          For K := 0 To TmpEnt.DrawPoints.Count - 2 Do
          Begin
            PtA := TmpEnt.DrawPoints[K];
            PtB := TmpEnt.DrawPoints[K + 1];
            If K = 0 Then
              PartialEnt.Points.Add( PtA );
            SegmentVect.Clear;
            SegmentVect.Add( PtA );
            SegmentVect.Add( PtB );
            IntVect.Clear;
            If FSegment[0] = K Then
              IntVect.Add( ClipEntity.Points[0] );
            If FSegment[1] = K Then
              IntVect.Add( ClipEntity.Points[1] );
            If IntVect.Count > 0 Then
            Begin
              (* create the list and sort it *)
              SortList := TList.Create;
              Try
                For cnt := 0 To IntVect.Count - 1 Do
                Begin
                  New( DistRec );
                  DistRec^.D := Dist2D( PtA, IntVect[cnt] );
                  DistRec^.Index := cnt;
                  SortList.Add( DistRec );
                End;
                If SortList.Count > 1 Then
                  QuickSortDistList( SortList, 0, SortList.Count - 1 );
                For cnt := 0 To SortList.Count - 1 Do
                Begin
                  DistRec := PDistRec( SortList[cnt] );
                  PartialEnt.Points.Add( IntVect[DistRec^.Index] );
                  p1 := PartialEnt.Points[0];
                  p2 := PartialEnt.Points[PartialEnt.Points.Count - 1];
                  p3 := ClipEntity.Points[0];
                  p4 := ClipEntity.Points[1];
                  If Not ( ( EqualPoint2D( p1, p3 ) And EqualPoint2D( p2, p4 ) ) Or
                    ( EqualPoint2D( p1, p4 ) And EqualPoint2D( p2, p3 ) ) ) Then
                  Begin
                    NewRecno := FLayer.AddEntity( PartialEnt );
                    (* Now, copy the DB record *)
                    FLayer.CopyRecord( FRecNo, NewRecno );
                    Undo.AddUndo( FLayer, NewRecno, uaDelete );
                  End;
                  PartialEnt.Points.Clear;
                  PartialEnt.Points.Add( IntVect[DistRec^.Index] );
                End;
              Finally
                For cnt := 0 To SortList.Count - 1 Do
                  Dispose( PDistRec( SortList[cnt] ) );
                SortList.Free;
              End;
            End;
            PartialEnt.Points.Add( PtB );
          End;
          If PartialEnt.Points.Count > 0 Then
          Begin
            NewRecno := FLayer.AddEntity( PartialEnt );
            (* Now, copy the DB record *)
            FLayer.CopyRecord( FRecNo, NewRecno );
            Undo.AddUndo( FLayer, NewRecno, uaDelete );
          End;
          Inc( NumClipped );
        Finally
          IntVect.Free;
          SegmentVect.Free;
          PartialEnt.Free;
        End;
        If NumClipped > 0 Then
        Begin
          Undo.AddUndo( FLayer, FRecNo, uaUnDelete );
          FLayer.DeleteEntity( FRecNo );
          Selection.Clear;
        End;
      Finally
        TmpEnt.Free;
        Undo.EndUndo;
      End;
      Repaint;
    End;
  End;
  //-------------------- end of clip polylines section

Begin
  If Button = mbRight Then Exit;
  With CmdLine.ActiveDrawBox Do
  Begin
    CurrPoint := CmdLine.CurrentPoint;
    Picked := PickEntity( CurrPoint.X, CurrPoint.Y, FAperture, '', TmpLayer,
      TmpRecNo, FPickedPoint, Nil );
    If Picked Then
    Begin
      If FCurrent >= 1 Then
      Begin
        If Not ( ( TmpLayer = FLayer ) And ( TmpRecNo = FRecNo ) ) Then
        Begin
          MessageToUser( SBreakWrongSelection, smsgerror, MB_ICONERROR );
          Self.Finished := True;
          Invalidate;
          Exit;
        End;
        TmpEnt := TmpLayer.LoadEntityWithRecNo( TmpRecNo );
        Try
          If FPickedPoint >= 0 Then
            N := FPickedPoint
          Else If ( FPickedPoint = -1 ) And ( Ez_Preferences.GNumPoint >= 0 ) And
            ( TmpEnt.Points.Count > 1 ) Then
            N := Ez_Preferences.GNumPoint
          Else
          Begin
            CmdLine.StatusMessage := SBreakNotClicked;
            Invalidate;
            Exit; // safely
          End;
          Pt1 := TmpEnt.Points[N];
          If N = TmpEnt.Points.Count - 1 Then
            Pt2 := TmpEnt.Points[0]
          Else
            Pt2 := TmpEnt.Points[Succ( N )];
        Finally
          TmpEnt.Free;
        End;

        FBreakPoints[FCurrent] := PointOnLine( CurrPoint.X, CurrPoint.Y,
          Pt1.X, Pt1.Y, Pt2.X, Pt2.Y );
        FSegment[FCurrent] := N;
        // end of defining clipping points
        ClipEntity := TEzPolyLine.CreateEntity( [FBreakPoints[0],
          FBreakPoints[1]] );
        Try
          clippline;
          Selection.RepaintSelectionArea;
          Self.Finished := True;
        Finally
          ClipEntity.Free;
        End;
      End
      Else
      Begin
        TmpEnt := TmpLayer.LoadEntityWithRecNo( TmpRecNo );
        Try
          If TmpEnt.IsClosed Or ( TmpEnt.Points.Parts.Count > 1 ) Then
          Begin
            CmdLine.StatusMessage := SBreakWrongEntity;
            Invalidate;
            Exit;
          End;
          If FPickedPoint >= 0 Then
            N := FPickedPoint
          Else If ( FPickedPoint = -1 ) And ( Ez_Preferences.GNumPoint >= 0 ) And
            ( TmpEnt.Points.Count > 1 ) Then
            N := Ez_Preferences.GNumPoint
          Else
          Begin
            CmdLine.StatusMessage := SBreakNotClicked;
            Invalidate;
            Exit; // safely
          End;
          Pt1 := TmpEnt.Points[N];
          If N = TmpEnt.Points.Count - 1 Then
            Pt2 := TmpEnt.Points[0]
          Else
            Pt2 := TmpEnt.Points[Succ( N )];
        Finally
          TmpEnt.Free;
        End;

        FBreakPoints[FCurrent] := PointOnLine( CurrPoint.X, CurrPoint.Y,
          Pt1.X, Pt1.Y, Pt2.X, Pt2.Y );
        FSegment[FCurrent] := N; // the point of start of segment containing the break point

        Selection.UnSelectAndRepaint;
        Selection.Add( TmpLayer, TmpRecNo );
        Selection.RepaintSelectionArea;
        Caption := SBreakSelectSecndPoint;
        FLayer := TmpLayer;
        FRecNo := TmpRecNo;
        Inc( FCurrent );
      End;
    End;
  End;
End;

Procedure TBreakAction.MyKeyPress( Sender: TObject; Var Key: Char );
Begin
  With CmdLine.ActiveDrawBox Do
    If Key In [#13, #27] Then
    Begin
      Self.Finished := true;
      Key := #0;
    End;
End;

{----------------------------------------------------------------------------}
//                  TTrimAction
{----------------------------------------------------------------------------}

Constructor TTrimAction.CreateAction( CmdLine: TEzCmdLine );
Begin
  Inherited CreateAction( CmdLine );

  CanBeSuspended := false;

  CanDoOsnap := True;
  MouseDrawElements:= [mdCursorFrame];

  FAperture := Ez_Preferences.ApertureWidth;
  FIsButtonUp := true;

  With CmdLine Do
    FPickFrame := TEzRectangle.CreateEntity( CurrentPoint, CurrentPoint );

  OnMouseDown := MyMouseDown;
  OnMouseMove := MyMouseMove;
  OnMouseUp := MyMouseUp;
  OnPaint := MyPaint;
  OnKeyPress := MyKeyPress;
  OnSuspendOperation := Self.SuspendOperation;
  OnContinueOperation := Self.ContinueOperation;

  Cursor := crDrawCross;

  With CmdLine.ActiveDrawBox Do
  Begin
    If Selection.Count = 0 Then
    Begin
      Self.Finished := True;
      MessageToUser( STrimNoCuttingEdge, smsgerror, MB_ICONERROR );
      Exit;
    End
    Else If Selection.NumSelected > 1 Then
    Begin
      Self.Finished := True;
      MessageToUser( STrimOnlyOneCuttingEdge, smsgerror, MB_ICONERROR );
      Exit;
    End;
  End;

  Caption := STrimSelectEnt
End;

Destructor TTrimAction.Destroy;
Begin
  FPickFrame.Free;
  Inherited Destroy;
End;

procedure TTrimAction.SuspendOperation(Sender: TObject);
begin
  If Assigned( FPickFrame ) Then
    CmdLine.ActiveDrawBox.DrawEntity2DRubberBand( FPickFrame );
end;

procedure TTrimAction.ContinueOperation(Sender: TObject);
begin
  If Assigned( FPickFrame ) Then
    CmdLine.ActiveDrawBox.DrawEntity2DRubberBand( FPickFrame );
end;

Procedure TTrimAction.SetCurrentPoint( Grapher: TEzGrapher; Const Pt: TEzPoint );
Var
  DX, DY: Double;
Begin
  DX := Grapher.DistToRealX( FAperture );
  DY := Grapher.DistToRealY( FAperture );
  FPickFrame.Points[0] := Point2D( Pt.X - DX / 2, Pt.Y - DY / 2 );
  FPickFrame.Points[1] := Point2D( Pt.X + DX / 2, Pt.Y + DY / 2 );
End;

Procedure TTrimAction.MyMouseDown( Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer; Const WX, WY: Double );
Var
  PtA, PtB, CurrPoint: TEzPoint;
  TmpLayer: TEzBaseLayer;
  I, SI, J, K, E, P, N, cnt, TmpRecNo, FPickedPoint, Index, IntIndex,
    WasClicked, NewRecno: Integer;
  Picked: Boolean;
  SelEnt, PartialEnt, TmpEnt, NewEnt: TEzEntity;
  SegmentVect, IntVect: TEzVector;
  SortList, List: TList;
  DistRec: PDistRec;
  OriginalID: Integer;
Begin
  If Button = mbRight Then Exit;
  FIsButtonUp := false;
  With CmdLine.ActiveDrawBox Do
  Begin
    CurrPoint := CmdLine.CurrentPoint;
    Picked := PickEntity( CurrPoint.X, CurrPoint.Y, FAperture, '', TmpLayer,
      TmpRecNo, FPickedPoint, Nil );
    If Picked Then
    Begin
      TmpEnt := TmpLayer.LoadEntityWithRecNo( TmpRecNo ); // the entity picked
      Undo.BeginUndo( uaUnTransform );
      Try
        If TmpEnt.IsClosed Or ( TmpEnt.Points.Parts.Count > 1 ) Then
        Begin
          CmdLine.StatusMessage := STrimWrongEntity;
          Exit;
        End;
        For J := 0 To Selection.Count - 1 Do
          With Selection[J] Do
            For SI := 0 To Selection[J].SelList.Count - 1 Do
            Begin
              If ( AnsiCompareText( TmpLayer.Name, Layer.Name ) = 0 ) And
                ( TmpRecNo = Selection[J].SelList[SI] ) Then
              Begin
                CmdLine.StatusMessage := STrimCuttingEdge;
                Continue;
              End;
              // read cutting edge
              SelEnt := Layer.LoadEntityWithRecno( SelList[SI] );
              (* we'll analize this entity TmpEnt*)
              IntVect := TEzVector.Create( 2 );
              SegmentVect := TEzVector.Create( 2 );
              List := TList.Create; // list of intersected entities
              Try
                If VectIntersect( SelEnt.Points, TmpEnt.Points, IntVect, true ) Then
                Begin
                  PartialEnt := TEzPolyLine.Create( 2 );
                  List.Add( PartialEnt );
                  For K := 0 To TmpEnt.DrawPoints.Count - 2 Do
                  Begin
                    PtA := TmpEnt.DrawPoints[K];
                    PtB := TmpEnt.DrawPoints[K + 1];
                    If K = 0 Then
                      PartialEnt.Points.Add( PtA );
                    SegmentVect.Clear;
                    SegmentVect.Add( PtA );
                    SegmentVect.Add( PtB );
                    If VectIntersect( SegmentVect, SelEnt.Points, IntVect, true ) Then
                    Begin
                      (* create the list and sort it *)
                      SortList := TList.Create;
                      Try
                        For cnt := 0 To IntVect.Count - 1 Do
                        Begin
                          New( DistRec );
                          DistRec^.D := Dist2D( PtA, IntVect[cnt] );
                          DistRec^.Index := cnt;
                          SortList.Add( DistRec );
                        End;
                        If SortList.Count > 1 Then
                          QuickSortDistList( SortList, 0, SortList.Count - 1 );
                        For cnt := 0 To SortList.Count - 1 Do
                        Begin
                          DistRec := PDistRec( SortList[cnt] );
                          PartialEnt.Points.Add( IntVect[DistRec^.Index] );
                          // create new one
                          PartialEnt := TEzPolyLine.Create( 2 );
                          List.Add( PartialEnt );
                          PartialEnt.Points.Add( IntVect[DistRec^.Index] );
                        End;
                      Finally
                        For cnt := 0 To SortList.Count - 1 Do
                          Dispose( PDistRec( SortList[cnt] ) );
                        SortList.Free;
                      End;
                    End;
                    PartialEnt.Points.Add( PtB );
                  End;
                  // now we will find what line segment was clicked
                  WasClicked := -1;
                  For K := 0 To List.Count - 1 Do
                    If IsPointOnEntity( CmdLine, Ez_Preferences.ApertureWidth,
                      CurrPoint, TEzEntity( List[K] ) ) Then
                    Begin
                      WasClicked := K;
                      Break;
                    End;
                  If ( WasClicked >= 0 ) And ( List.Count > 1 ) Then
                  Begin
                    NewEnt := TEzPolyLine.Create( 2 );
                    For K := 0 To List.Count - 1 Do
                      If WasClicked <> K Then
                      Begin
                        With TEzEntity( List[K] ) Do
                          For P := 0 To Points.Count - 1 Do
                            NewEnt.Points.Add( Points[P] );
                      End
                      Else
                      Begin
                        If NewEnt.Points.Count > 0 Then
                        Begin
                          DeleteDuplicatedVertexes( NewEnt );
                          NewRecno := TmpLayer.AddEntity( NewEnt );
                          TmpLayer.CopyRecord( TmpRecNo, NewRecNo );
                          NewEnt.ID:= TmpEnt.ID;
                          TmpLayer.UpdateEntity( NewRecno, NewEnt );
                          Undo.AddUndo( TmpLayer, NewRecno, uaDelete );
                        End;
                        NewEnt.Points.Clear;
                      End;
                    If NewEnt.Points.Count > 0 Then
                    Begin
                      DeleteDuplicatedVertexes( NewEnt );
                      NewRecno := TmpLayer.AddEntity( NewEnt );
                      TmpLayer.CopyRecord( TmpRecNo, NewRecno );
                      NewEnt.ID:= TmpEnt.ID;
                      TmpLayer.UpdateEntity( NewRecno, NewEnt );
                      Undo.AddUndo( TmpLayer, NewRecno, uaDelete );
                    End;
                    NewEnt.Free;
                    // erase original
                    TmpLayer.DeleteEntity( TmpRecNo );
                    Undo.AddUndo( TmpLayer, TmpRecNo, uaUnDelete );
                    DrawEntity2DRubberBand( FPickFrame );
                    Repaint;
                    DrawEntity2DRubberBand( FPickFrame );
                  End;
                End;
              Finally
                IntVect.Free;
                SegmentVect.Free;
                SelEnt.Free;
                For K := 0 To List.Count - 1 Do
                  TEzEntity( List[K] ).Free;
                List.Free;
              End;
            End;
      Finally
        TmpEnt.Free;
        Undo.EndUndo;
      End;
    End;
  End;
End;

Procedure TTrimAction.MyMouseMove( Sender: TObject; Shift: TShiftState;
  X, Y: Integer; Const WX, WY: Double );
Var
  CurrPoint: TEzPoint;
Begin
  If Not FIsButtonUp Then Exit;
  With CmdLine.ActiveDrawBox Do
  Begin
    DrawEntity2DRubberBand( FPickFrame );
    CurrPoint := CmdLine.CurrentPoint;
    SetCurrentPoint( Grapher, CurrPoint );
    DrawEntity2DRubberBand( FPickFrame );
  End;
End;

Procedure TTrimAction.MyKeyPress( Sender: TObject; Var Key: Char );
Begin
  With CmdLine.ActiveDrawBox Do
    If Key In [#13, #27] Then
    Begin
      DrawEntity2DRubberBand( FPickFrame );
      Self.Finished := true;
      Key := #0;
    End;
End;

Procedure TTrimAction.MyPaint( Sender: TObject );
Begin
  If Not FIsButtonUp Then Exit;
  CmdLine.ActiveDrawBox.DrawEntity2DRubberBand( FPickFrame )
End;

Procedure TTrimAction.MyMouseUp( Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer; Const WX, WY: Double );
Begin
  FIsButtonUp := True;
  CmdLine.ActiveDrawBox.Invalidate;
End;

{----------------------------------------------------------------------------}
//                  TExtendAction
{----------------------------------------------------------------------------}

Constructor TExtendAction.CreateAction( CmdLine: TEzCmdLine );
Begin
  Inherited CreateAction( CmdLine );

  CanBeSuspended := false;

  CanDoOsnap := True;
  MouseDrawElements:= [mdCursorFrame];

  FAperture := Ez_Preferences.ApertureWidth;
  FIsButtonUp := true;

  With CmdLine Do
    FPickFrame := TEzRectangle.CreateEntity( CurrentPoint, CurrentPoint );

  OnMouseDown := MyMouseDown;
  OnMouseMove := MyMouseMove;
  OnMouseUp := MyMouseUp;
  OnPaint := MyPaint;
  OnKeyPress := MyKeyPress;
  OnSuspendOperation := Self.SuspendOperation;
  OnContinueOperation := Self.ContinueOperation;

  Cursor := crDrawCross;

  With CmdLine.ActiveDrawBox Do
  Begin
    If Selection.Count = 0 Then
    Begin
      Self.Finished := True;
      MessageToUser( SExtendNoExtendEdge, smsgerror, MB_ICONERROR );
      Exit;
    End
    Else If Selection.NumSelected > 1 Then
    Begin
      Self.Finished := True;
      MessageToUser( SExtendOnlyOneCuttingEdge, smsgerror, MB_ICONERROR );
      Exit;
    End;
  End;

  Caption := SExtendSelectEnt;
End;

Destructor TExtendAction.Destroy;
Begin
  FPickFrame.Free;
  Inherited Destroy;
End;

procedure TExtendAction.SuspendOperation(Sender: TObject);
begin
  If Assigned( FPickFrame ) Then
    CmdLine.ActiveDrawBox.DrawEntity2DRubberBand( FPickFrame );
end;

procedure TExtendAction.ContinueOperation(Sender: TObject);
begin
  If Assigned( FPickFrame ) Then
    CmdLine.ActiveDrawBox.DrawEntity2DRubberBand( FPickFrame );
end;

Procedure TExtendAction.SetCurrentPoint( Grapher: TEzGrapher; Const Pt: TEzPoint );
Var
  DX, DY: Double;
Begin
  DX := Grapher.DistToRealX( FAperture );
  DY := Grapher.DistToRealY( FAperture );
  FPickFrame.Points[0] := Point2D( Pt.X - DX / 2, Pt.Y - DY / 2 );
  FPickFrame.Points[1] := Point2D( Pt.X + DX / 2, Pt.Y + DY / 2 );
End;

Procedure TExtendAction.MyMouseDown( Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer; Const WX, WY: Double );
Var
  TmpLayer: TEzBaseLayer;
  sI, J, cnt1, TmpRecNo, FPickedPoint, ExtendIndex, TmpStart, TmpEnd: Integer;
  Found, Picked: Boolean;
  CurrPoint, IntPt, OrigPt, MinPt: TEzPoint;
  SelEnt, TmpEnt: TEzEntity;
  LineR: TEzLineRelations;
  Distance, MinDist: Double;
Begin
  If Button = mbRight Then Exit;
  FIsButtonUp := false;
  ExtendIndex := 0;
  With CmdLine.ActiveDrawBox Do
  Begin
    CurrPoint := CmdLine.CurrentPoint;
    Picked := PickEntity( CurrPoint.X, CurrPoint.Y, FAperture, '', TmpLayer,
      TmpRecNo, FPickedPoint, Nil );
    If Picked Then
    Begin
      TmpEnt := TmpLayer.LoadEntityWithRecNo( TmpRecNo ); // the entity picked
      Try
        If TmpEnt.IsClosed Or ( TmpEnt.Points.Parts.Count > 1 ) Then
        Begin
          CmdLine.StatusMessage := SExtendWrongEntity;
          Exit;
        End;
        If FPickedPoint >= 0 Then
          ExtendIndex := FPickedPoint
        Else If ( FPickedPoint = PICKED_POINT ) And ( Ez_Preferences.GNumPoint >= 0 ) Then
        Begin
          If TmpEnt.Points.Count = 2 Then
          Begin
            If Dist2D( CurrPoint, TmpEnt.Points[0] ) < Dist2D( CurrPoint, TmpEnt.Points[1] ) Then
              ExtendIndex := 0
            Else
              ExtendIndex := 1
          End
          Else
          Begin
            If Ez_Preferences.GNumPoint = 0 Then
              ExtendIndex := 0
            Else If Ez_Preferences.GNumPoint = TmpEnt.Points.Count - 2 Then
              ExtendIndex := TmpEnt.Points.Count - 1
            Else
              ExtendIndex := Ez_Preferences.GNumPoint;
          End;
        End;
        If ( ExtendIndex > 0 ) And ( ExtendIndex < TmpEnt.Points.Count - 1 ) Then
        Begin
          CmdLine.StatusMessage := SExtendWrongSegment;
          Exit;
        End;
        For J := 0 To Selection.Count - 1 Do
          With Selection[J] Do
            For sI := 0 To Selection[J].SelList.Count - 1 Do
            Begin
              If ( Layer = TmpLayer ) And ( sI = TmpRecNo ) Then
                Continue;
              // read extend edge
              If ExtendIndex = 0 Then
                OrigPt := TmpEnt.Points[0]
              Else
                OrigPt := TmpEnt.Points[ExtendIndex];
              MinDist := MAXCOORD;
              Found := False;
              SelEnt := Layer.LoadEntityWithRecno( Selection[J].SelList[sI] );
              Try
                For cnt1 := 0 To SelEnt.Points.Count - 2 Do
                Begin
                  If ExtendIndex = 0 Then
                  Begin
                    TmpStart := ExtendIndex;
                    TmpEnd := ExtendIndex + 1;
                  End
                  Else
                  Begin
                    TmpStart := ExtendIndex - 1;
                    TmpEnd := ExtendIndex;
                  End;
                  IntPt := Point2D(0, 0);
                  LineR := LineRel( TmpEnt.Points[TmpStart], TmpEnt.Points[TmpEnd],
                    SelEnt.Points[cnt1], SelEnt.Points[cnt1 + 1], IntPt );
                  If ExtendIndex = 0 Then
                  Begin
                    Distance := Dist2D( OrigPt, IntPt );
                    If ( LineR * [lrBetweenDiv, lrOffParStart] =
                      [lrBetweenDiv, lrOffParStart] ) And ( Distance < MinDist ) Then
                    Begin
                      MinPt := IntPt;
                      MinDist := Distance;
                      Found := True;
                    End;
                  End
                  Else
                  Begin
                    Distance := Dist2D( OrigPt, IntPt );
                    If ( LineR * [lrBetweenDiv, lrOffParEnd] = [lrBetweenDiv, lrOffParEnd] ) And
                      ( Distance < MinDist ) Then
                    Begin
                      MinPt := IntPt;
                      MinDist := Distance;
                      Found := True;
                    End;
                  End;
                End;
                If Found Then
                Begin
                  TmpEnt.Points[ExtendIndex] := MinPt;
                  // first, save the undo action
                  Undo.AddUnTransform( TmpLayer, TmpRecNo );
                  TmpLayer.UpdateEntity( TmpRecNo, TmpEnt );
                  DrawEntity2DRubberBand( FPickFrame ); // hide
                  Repaint;
                  DrawEntity2DRubberBand( FPickFrame ); // and show again
                End;
              Finally
                SelEnt.Free;
              End;
            End;
      Finally
        TmpEnt.Free;
      End;
    End;
  End;
End;

Procedure TExtendAction.MyMouseMove( Sender: TObject; Shift: TShiftState;
  X, Y: Integer; Const WX, WY: Double );
Var
  CurrPoint: TEzPoint;
Begin
  If Not FIsButtonUp Then Exit;
  With CmdLine.ActiveDrawBox Do
  Begin
    DrawEntity2DRubberBand( FPickFrame );
    CurrPoint := CmdLine.CurrentPoint;
    SetCurrentPoint( Grapher, CurrPoint );
    DrawEntity2DRubberBand( FPickFrame );
  End;
End;

Procedure TExtendAction.MyKeyPress( Sender: TObject; Var Key: Char );
Begin
  With CmdLine.ActiveDrawBox Do
    If Key In [#13, #27] Then
    Begin
      DrawEntity2DRubberBand( FPickFrame );
      Self.Finished := true;
      Key := #0;
    End;
End;

Procedure TExtendAction.MyPaint( Sender: TObject );
Begin
  If Not FIsButtonUp Then Exit;
  CmdLine.ActiveDrawBox.DrawEntity2DRubberBand( FPickFrame )
End;

Procedure TExtendAction.MyMouseUp( Sender: TObject; Button: TMouseButton; Shift:
  TShiftState; X, Y: Integer; Const WX, WY: Double );
Begin
  FIsButtonUp := True;
  CmdLine.ActiveDrawBox.Invalidate;
End;

{----------------------------------------------------------------------------}
//                  TFilletAction
{----------------------------------------------------------------------------}

Constructor TFilletAction.CreateAction( CmdLine: TEzCmdLine );
Begin
  Inherited CreateAction( CmdLine );

  CanBeSuspended := false;

  CanDoOsnap := True;
  MouseDrawElements:= [mdCursorFrame];

  FAperture := Ez_Preferences.ApertureWidth;

  FArc := TEzArc.Create( 3 );

  With CmdLine Do
    FPickFrame := TEzRectangle.CreateEntity( CurrentPoint, CurrentPoint );

  OnMouseDown := MyMouseDown;
  OnMouseMove := MyMouseMove;
  OnPaint := MyPaint;
  OnKeyPress := MyKeyPress;
  OnSuspendOperation := Self.SuspendOperation;
  OnContinueOperation := Self.ContinueOperation;

  Cursor := crDrawCross;

  Caption := SBreakSelectFirstPoint;
End;

Destructor TFilletAction.Destroy;
Begin
  FPickFrame.Free;
  FArc.Free;
  Inherited Destroy;
End;

procedure TFilletAction.SuspendOperation(Sender: TObject);
begin
  If Assigned( FPickFrame ) Then
    CmdLine.ActiveDrawBox.DrawEntity2DRubberBand( FPickFrame );
end;

procedure TFilletAction.ContinueOperation(Sender: TObject);
begin
  If Assigned( FPickFrame ) Then
    CmdLine.ActiveDrawBox.DrawEntity2DRubberBand( FPickFrame );
end;

Procedure TFilletAction.SetCurrentPoint( Grapher: TEzGrapher; Const Pt: TEzPoint );
Var
  DX, DY: Double;
Begin
  DX := Grapher.DistToRealX( FAperture );
  DY := Grapher.DistToRealY( FAperture );
  FPickFrame.Points[0] := Point2D( Pt.X - DX / 2, Pt.Y - DY / 2 );
  FPickFrame.Points[1] := Point2D( Pt.X + DX / 2, Pt.Y + DY / 2 );
End;

Procedure TFilletAction.MyMouseDown( Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer; Const WX, WY: Double );
Var
  Pt1, Pt2, CurrPoint: TEzPoint;
  TmpLayer: TEzBaseLayer;
  i, TmpRecNo, N, TmpSegm, TmpPicked, PickedPoint, iFrom: Integer;
  Extension: TEzRect;
  Picked: Boolean;
  FilletEnt, TmpEnt: TEzEntity;
  TmpPt: TEzPoint;
Begin
  If Button = mbRight Then Exit;
  With CmdLine.ActiveDrawBox Do
  Begin
    CurrPoint := CmdLine.CurrentPoint;
    If FDefiningCurve Then
    Begin
      Undo.AddUnTransformFromSelection;
      Extension := Selection.GetExtension;
      FArc.Points[1] := CurrPoint;
      FArc.PointsInCurve := 15;
      FArc.MakeCurvePoints;
      TmpEnt := FLayer.LoadEntityWithRecNo( FRecNo );
      // change the entity
      FilletEnt := GetClassFromID( TmpEnt.EntityID ).Create( 2 );
      Try
        FilletEnt.Assign( TmpEnt );
        FilletEnt.Points.Clear;
        For i := 0 To FSegment[0] Do
          FilletEnt.Points.Add( TmpEnt.Points[i] );
        // add the arc
        For i := 0 To FArc.DrawPoints.Count - 1 Do
          FilletEnt.Points.Add( FArc.DrawPoints[i] );
        If FPickedPoints[1] >= 0 Then
          iFrom := FPickedPoints[1]
        Else
          iFrom := FSegment[1];
        For i := iFrom + 1 To TmpEnt.Points.Count - 1 Do
          FilletEnt.Points.Add( TmpEnt.Points[i] );
        TmpEnt.Points.Assign( FilletEnt.Points );
        FLayer.UpdateEntity( FRecNo, TmpEnt );
      Finally
        FilletEnt.Free;
        TmpEnt.Free;
      End;
      RepaintRect( Extension );
      Self.Finished := True;
    End
    Else
    Begin
      Picked := PickEntity( CurrPoint.X, CurrPoint.Y, FAperture, '', TmpLayer,
        TmpRecNo, PickedPoint, Nil );
      If Picked Then
      Begin
        If FCurrent >= 1 Then
        Begin
          If Not ( ( TmpLayer = FLayer ) And ( TmpRecNo = FRecNo ) ) Then
          Begin
            MessageToUser( SBreakWrongSelection, smsgerror, MB_ICONERROR );
            Self.Finished := True;
            Invalidate;
            Exit;
          End;
          TmpEnt := TmpLayer.LoadEntityWithRecNo( TmpRecNo );
          Try
            If PickedPoint >= 0 Then
              N := PickedPoint
            Else If ( PickedPoint = PICKED_POINT ) And ( Ez_Preferences.GNumPoint >= 0 ) And
              ( TmpEnt.Points.Count > 1 ) Then
              N := Ez_Preferences.GNumPoint
            Else
            Begin
              CmdLine.StatusMessage := SBreakNotClicked;
              Invalidate;
              Exit; // safely
            End;
            FPickedPoints[FCurrent] := PickedPoint;
            If PickedPoint = PICKED_POINT Then
            Begin
              Pt1 := TmpEnt.Points[N];
              If N = TmpEnt.Points.Count - 1 Then
                Pt2 := TmpEnt.Points[0]
              Else
                Pt2 := TmpEnt.Points[Succ( N )];
              FFilletPoints[FCurrent] := PointOnLine( CurrPoint.X, CurrPoint.Y,
                Pt1.X, Pt1.Y, Pt2.X, Pt2.Y );
            End
            Else
              FFilletPoints[FCurrent] := TmpEnt.Points[PickedPoint];
            FSegment[FCurrent] := N;

            // sort the points selected
            If FSegment[0] > FSegment[1] Then
            Begin
              TmpPt := FFilletPoints[0];
              TmpSegm := FSegment[0];
              TmpPicked := FPickedPoints[0];
              FFilletPoints[0] := FFilletPoints[1];
              FSegment[0] := FSegment[1];
              FPickedPoints[0] := FSegment[1];
              FFilletPoints[1] := TmpPt;
              FSegment[1] := TmpSegm;
              FPickedPoints[1] := TmpPicked;
            End;
            If FPickedPoints[1] >= 0 Then
              FSegment[1] := FPickedPoints[1] - 1;
            If Not ( Abs( FSegment[0] - FSegment[1] ) In [0, 1] ) Then
            Begin
              CmdLine.StatusMessage := SFilletNotContiguous;
              Invalidate;
              Exit; // safely
            End;
          Finally
            TmpEnt.Free;
          End;
          FDefiningCurve := True;
          FArc.Points[0] := FFilletPoints[0];
          FArc.Points[1] := FFilletPoints[0];
          FArc.Points[2] := FFilletPoints[1];
        End
        Else
        Begin
          TmpEnt := TmpLayer.LoadEntityWithRecNo( TmpRecNo );
          Try
            If ( Not ( TmpEnt.EntityID In [idPolyline, idPolygon] ) ) Or
              ( TmpEnt.Points.Parts.Count > 1 ) Then
            Begin
              CmdLine.StatusMessage := SFilletWrongEntity;
              Invalidate;
              Exit;
            End;
            If PickedPoint >= 0 Then
              N := PickedPoint
            Else If ( PickedPoint = PICKED_POINT ) And ( Ez_Preferences.GNumPoint >= 0 ) And
              ( TmpEnt.Points.Count > 1 ) Then
              N := Ez_Preferences.GNumPoint
            Else
            Begin
              CmdLine.StatusMessage := SBreakNotClicked;
              Invalidate;
              Exit; // safely
            End;
            FPickedPoints[FCurrent] := PickedPoint;
            If PickedPoint = PICKED_POINT Then
            Begin
              Pt1 := TmpEnt.Points[N];
              If N = TmpEnt.Points.Count - 1 Then
                Pt2 := TmpEnt.Points[0]
              Else
                Pt2 := TmpEnt.Points[Succ( N )];

              FFilletPoints[FCurrent] := PointOnLine( CurrPoint.X, CurrPoint.Y,
                Pt1.X, Pt1.Y,
                Pt2.X, Pt2.Y );
            End
            Else
              FFilletPoints[FCurrent] := TmpEnt.Points[PickedPoint];
            FSegment[FCurrent] := N; // the point of start of segment containing the break point

            Selection.UnSelectAndRepaint;
            Selection.Add( TmpLayer, TmpRecNo );
            Selection.RepaintSelectionArea;
            Caption := SBreakSelectSecndPoint;
            FLayer := TmpLayer;
            FRecNo := TmpRecNo;
            Inc( FCurrent );
          Finally
            TmpEnt.Free;
          End;
        End;
      End;
    End;
  End;
End;

Procedure TFilletAction.MyMouseMove( Sender: TObject; Shift: TShiftState;
  X, Y: Integer; Const WX, WY: Double );
Var
  CurrPoint: TEzPoint;
Begin
  With CmdLine.ActiveDrawBox Do
  Begin
    DrawEntity2DRubberBand( FPickFrame );
    CurrPoint := CmdLine.CurrentPoint;
    SetCurrentPoint( Grapher, CurrPoint );
    DrawEntity2DRubberBand( FPickFrame );
    If FDefiningCurve Then
    Begin
      DrawEntity2DRubberBand( FArc );
      FArc.Points[1] := CurrPoint;
      FArc.MakeCurvePoints;
      DrawEntity2DRubberBand( FArc );
    End;
  End;
End;

Procedure TFilletAction.MyKeyPress( Sender: TObject; Var Key: Char );
Begin
  With CmdLine.ActiveDrawBox Do
    If Key In [#13, #27] Then
    Begin
      DrawEntity2DRubberBand( FPickFrame );
      Self.Finished := true;
      Key := #0;
    End;
End;

Procedure TFilletAction.MyPaint( Sender: TObject );
Begin
  With CmdLine.ActiveDrawBox Do
  Begin
    If FDefiningCurve Then
      DrawEntity2DRubberBand( FArc );
    DrawEntity2DRubberBand( FPickFrame );
  End;
End;

{----------------------------------------------------------------------------}
//                  TPolygonSelectAction
{----------------------------------------------------------------------------}

Constructor TPolygonSelectAction.CreateAction( CmdLine: TEzCmdLine );
Begin
  Inherited CreateAction( CmdLine );

  CanBeSuspended := false;
  MouseDrawElements:= [mdCursor, mdFullViewCursor];

  FPolygon := TEzPolygon.CreateEntity( [Point2D(0, 0)] );

  OnMouseDown := MyMouseDown;
  OnMouseMove := MyMouseMove;
  OnKeyPress := MyKeyPress;
  OnPaint := MyPaint;

  Cursor := crDrawCross;
  Caption := SDefineFromPoint;

End;

Destructor TPolygonSelectAction.Destroy;
Begin
  FPolygon.Free;
  Inherited Destroy;
End;

Procedure TPolygonSelectAction.SetCurrentPoint( Const Pt: TEzPoint );
Var
  I: Integer;
Begin
  FPolygon.Points[FCurrentIndex] := Pt;
  For I := FCurrentIndex + 1 To FPolygon.Points.Count - 1 Do
    FPolygon.Points[I] := Pt;
End;

Procedure TPolygonSelectAction.MyMouseDown( Sender: TObject; Button: TMouseButton;
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
  With CmdLine.ActiveDrawBox Do
  Begin
    CurrPoint := CmdLine.CurrentPoint;
    SetCurrentPoint( CurrPoint );
    Inc( FCurrentIndex );
    Caption := SDefineToPoint;
  End;
End;

Procedure TPolygonSelectAction.MyMouseMove( Sender: TObject;
  Shift: TShiftState; X, Y: Integer; Const WX, WY: Double );
Var
  CurrPoint: TEzPoint;
Begin
  With CmdLine Do
  Begin
    All_DrawEntity2DRubberBand( FPolygon );
    {without snapping the point}
    CurrPoint := CmdLine.CurrentPoint;
    SetCurrentPoint( CurrPoint );
    All_DrawEntity2DRubberBand( FPolygon );
  End;
End;

Procedure TPolygonSelectAction.MyPaint( Sender: TObject );
Begin
  If FPolygon <> Nil Then
    (Sender As TEzBaseDrawBox).DrawEntity2DRubberBand( FPolygon );
End;

Procedure TPolygonSelectAction.MyKeyPress( Sender: TObject; Var Key: Char );
Var
  CurrPoint: TEzPoint;
Begin
  With CmdLine Do
    If Key = #27 Then
    Begin
      { Char 27 erase the last point}
      All_DrawEntity2DRubberBand( FPolygon );
      If FCurrentIndex = 0 Then
      Begin
        Self.Finished := true;
        Exit;
      End;
      Dec( FCurrentIndex );
      {without snapping}
      CurrPoint := CmdLine.CurrentPoint;
      SetCurrentPoint( CurrPoint );
      All_DrawEntity2DRubberBand( FPolygon );
    End
    Else If Key = #13 Then
    Begin
      If FCurrentIndex < 2 Then
      Begin
        MessageToUser( SNotEnoughData, smsgerror, MB_ICONERROR );
        Exit;
      End;
      All_DrawEntity2DRubberBand( FPolygon );
      {Last point is not valid because is floating}
      FPolygon.Points.Delete( FCurrentIndex );
      {do the selection in the polygon}
      DoPolygonSelect( FPolygon, CmdLine );
      {continue selecting}
      FPolygon.Points.Clear;
      FPolygon.Points.Add( Point2D(0, 0) );
      FCurrentIndex := 0;
      Caption := SDefineFromPoint;
      Key := #0;
      //Refresh;
      Exit;
    End;
End;

{----------------------------------------------------------------------------}
//                  TCircleSelectAction
{----------------------------------------------------------------------------}

Constructor TCircleSelectAction.CreateAction( CmdLine: TEzCmdLine );
Begin
  Inherited CreateAction( CmdLine );

  CanBeSuspended := false;
  //MouseDrawElements:= [mdCursor]; this is the default

  FPolygon := TEzPolygon.Create( 1 );

  OnMouseDown := MyMouseDown;
  OnMouseMove := MyMouseMove;
  OnKeyPress := MyKeyPress;
  OnPaint := MyPaint;

  Cursor := crHandPoint;
  Caption := SDefineCircleCenter;

End;

Destructor TCircleSelectAction.Destroy;
Begin
  FPolygon.Free;
  Inherited Destroy;
End;

Procedure TCircleSelectAction.SetCurrentPoint( Const Pt: TEzPoint );
Var
  Angle, AngleStep, Radius, Radians: Double;
Begin
  {Create a circle from FCenter to Pt}
  FPolygon.Points.Clear;
  Radius := Dist2D( FCenter, Pt );
  Angle := 0;
  AngleStep := 10;
  While Angle < 360 Do
  Begin
    Radians := Angle * System.Pi / 180.0;
    FPolygon.Points.Add( Point2D( FCenter.X + Radius * Cos( Radians ),
      FCenter.Y + Radius * Sin( Radians ) ) );
    Angle := Angle + AngleStep;
  End;
End;

Procedure TCircleSelectAction.MyMouseDown( Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer; Const WX, WY: Double );
Var
  CurrPoint: TEzPoint;
Begin
  If Button = mbRight Then Exit;
  With CmdLine Do
    If Not FCenterDefined Then
    Begin
      FCenter := CmdLine.CurrentPoint;
      FCenterDefined := true;
      SetCurrentPoint( FCenter );
      All_DrawEntity2DRubberBand( FPolygon );
      Caption := SDefineCircle;
    End
    Else
    Begin
      All_DrawEntity2DRubberBand( FPolygon );
      CurrPoint := CmdLine.CurrentPoint;
      SetCurrentPoint( CurrPoint );
      { Select with the last polygon generated }
      DoPolygonSelect( FPolygon, CmdLine );
      { continue generating until canceled command }
      Caption := SDefineCircleCenter;
      FCenterDefined := false;
      Invalidate;
    End;
End;

Procedure TCircleSelectAction.MyMouseMove( Sender: TObject;
  Shift: TShiftState; X, Y: Integer; Const WX, WY: Double );
Var
  CurrPoint: TEzPoint;
Begin
  If Not FCenterDefined Then Exit;
  With CmdLine Do
  Begin
    All_DrawEntity2DRubberBand( FPolygon );
    {without snapping the point}
    CurrPoint := CmdLine.CurrentPoint;
    SetCurrentPoint( CurrPoint );
    All_DrawEntity2DRubberBand( FPolygon );
  End;
End;

Procedure TCircleSelectAction.MyPaint( Sender: TObject );
Begin
  If FCenterDefined Then
    (Sender As TEzBaseDrawBox).DrawEntity2DRubberBand( FPolygon );
End;

Procedure TCircleSelectAction.MyKeyPress( Sender: TObject; Var Key: Char );
Begin
  With CmdLine Do
    If Key = #27 Then
    Begin
      { Char 27 erase the last point}
      If FCenterDefined Then
        All_DrawEntity2DRubberBand( FPolygon );
      Self.Finished := true;
    End;
End;

{----------------------------------------------------------------------------}
//                  TMeasuresAction
{----------------------------------------------------------------------------}

Constructor TMeasuresAction.CreateAction( CmdLine: TEzCmdLine );
Begin
  Inherited CreateAction( CmdLine );

  FPolyline := TEzPolyLine.Create( 1 );
  EzSystem.GlobalTempEntity:= FPolyline;

  CanDoOsnap := True;
  CanDoAccuDraw:= True;
  MouseDrawElements:= [mdCursorFrame, mdFullViewCursor];

  OnMouseDown := MyMouseDown;
  OnMouseMove := MyMouseMove;
  OnKeyPress := MyKeyPress;
  OnPaint := MyPaint;
  OnSuspendOperation := Self.SuspendOperation;
  OnContinueOperation := Self.ContinueOperation;

  {Create the hint window}
  hintW := THintWindow.Create( Application );
  hintW.Color := Ez_Preferences.HintColor;

  Cursor := crDrawCross;
  Caption := SDefineFromPoint;

End;

Destructor TMeasuresAction.Destroy;
Begin
  EzSystem.GlobalTempEntity:= Nil;
  FPolyline.Free;
  With hintW Do
  Begin
    ReleaseHandle;
    Free;
  End;
  Inherited Destroy;
End;

procedure TMeasuresAction.SuspendOperation(Sender: TObject);
begin
  If Assigned( FPolyline ) Then
    CmdLine.All_DrawEntity2DRubberBand( FPolyline );
end;

procedure TMeasuresAction.ContinueOperation(Sender: TObject);
begin
  If Assigned( FPolyline ) Then
    CmdLine.All_DrawEntity2DRubberBand( FPolyline );
end;

Procedure TMeasuresAction.ShowAreaAndPerimeter;
Var
  TmpPoly: TEzPolyLine;
  cnt, nd: Integer;
  NumPoints: Double;
  p: TPoint;
  s, sLongUnits, sAreaUnits: String;
  r: Windows.TRect;
  Area, Perimeter, Angle: Double;
Begin
  TmpPoly := TEzPolyLine.Create( FPolyline.Points.Count );
  Try
    For cnt := 0 To FCurrentIndex - 1 Do
      TmpPoly.Points.Add( FPolyline.Points[cnt] );
    Angle := 0;
    If TmpPoly.Points.Count > 1 Then
      With TmpPoly Do
        Angle := RadToDeg( Angle2D( Points[Points.Count - 2], Points[Points.Count - 1] ) );
    With CmdLine.ActiveDrawBox Do
    Begin
      Area := TmpPoly.Area( );
      Perimeter := TmpPoly.Perimeter( );
      sLongUnits := GIS.MapInfo.UnitsVerb;
      sAreaUnits := 'sq ' + sLongUnits;
    End;
    //do you want to show number of points (like TEXT points) ?
    With CmdLine.ActiveDrawBox Do
    Begin
      NumPoints := Grapher.DistToPointsY( Perimeter );
      //NumPoints := Grapher.RealToDistX( Perimeter );
    End;
    {show it in the hintwindow}
    If CmdLine.ShowMeasureInfoWindow Then
    Begin
      nd:= CmdLine.ActiveDrawBox.NumDecimals;
      s := Format( SAreaAndPerimeter, [nd, Area, sAreaUnits, nd, Perimeter,
        sLongUnits, Angle, NumPoints] );

      r := hintW.CalcHintRect( Screen.Width, s, Nil );
      //DrawText(hintW.Canvas.Handle,PChar(s),Length(s),r,DT_CALCRECT);
      InflateRect( r, 2, 2 );
      p := CmdLine.ActiveDrawBox.ClientToScreen( Point( 0, 0 ) );
      OffsetRect( r, p.X, p.Y );
      hintW.ActivateHint( r, s );
    End;
    If Assigned( CmdLine.OnMeasureInfo ) Then
      CmdLine.OnMeasureInfo( CmdLine, Area, Perimeter, Angle, NumPoints );
  Finally
    TmpPoly.Free;
  End;
End;

Procedure TMeasuresAction.SetCurrentPoint( Pt: TEzPoint; Orto: Boolean );
Var
  I: Integer;
Begin
  If Orto And ( FCurrentIndex > 0 ) Then
    Pt := ChangeToOrtogonal( FPolyline.Points[FCurrentIndex - 1], Pt );
  FPolyline.Points[FCurrentIndex] := Pt;
  For I := FCurrentIndex + 1 To FPolyline.Points.Count - 1 Do
    FPolyline.Points[I] := Pt;
End;

Procedure TMeasuresAction.MyMouseDown( Sender: TObject; Button: TMouseButton;
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
    SetCurrentPoint( CurrPoint, UseOrto );
    If FCurrentIndex = 0 Then
      AccuDraw.UpdatePosition( CurrPoint, CurrPoint)
    Else
      AccuDraw.UpdatePosition( FPolyline.Points[FCurrentIndex-1], CurrPoint );
    Inc( FCurrentIndex );
    Caption := SDefineToPoint;
    ShowAreaAndPerimeter;
  End;
End;

Procedure TMeasuresAction.MyMouseMove( Sender: TObject; Shift: TShiftState;
  X, Y: Integer; Const WX, WY: Double );
Var
  CurrPoint: TEzPoint;
  P1, P2: TEzPoint;
  Angle, Area, Perimeter, DX, DY: Double;
  nd: Integer;
Begin
  With CmdLine Do
  Begin
    All_DrawEntity2DRubberBand( FPolyline );
    CurrPoint := GetSnappedPoint;
    SetCurrentPoint( CurrPoint, UseOrto );
    All_DrawEntity2DRubberBand( FPolyline );

    // show some info
    If FCurrentIndex > 0 Then
    Begin
      P1 := FPolyline.Points[FCurrentIndex - 1];
      P2 := FPolyline.Points[FCurrentIndex];
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
        Area := FPolyline.Area( );
        Perimeter := FPolyline.Perimeter( );
      End;
      nd:= ActiveDrawBox.NumDecimals;
      StatusMessage := Format( SNewEntityInfo,
        [nd, Angle, nd, DX, nd, DY, nd, Area, nd, Perimeter] );
    End
  End;
End;

Procedure TMeasuresAction.MyPaint( Sender: TObject );
Begin
  If FPolyline <> Nil Then
    (Sender As TEzBaseDrawBox).DrawEntity2DRubberBand( FPolyline );
End;

{erase last defined point}

Procedure TMeasuresAction.UndoOperation;
Var
  CurrPoint: TEzPoint;
Begin
  With CmdLine Do
  Begin
    All_DrawEntity2DRubberBand( FPolyline );
    If FCurrentIndex > 0 Then
      Dec( FCurrentIndex );
    ShowAreaAndPerimeter;
    CurrPoint := CmdLine.GetSnappedPoint;
    SetCurrentPoint( CurrPoint, CmdLine.UseOrto );
    All_DrawEntity2DRubberBand( FPolyline );
    If FCurrentIndex > 0 Then
      Caption := SDefineToPoint
    Else
      Caption := SDefineFromPoint;
  End;
End;

Procedure TMeasuresAction.MyKeyPress( Sender: TObject; Var Key: Char );
Begin
  With CmdLine Do
    If Key In [#13, #27] Then
    Begin
      All_DrawEntity2DRubberBand( FPolyline );
      Self.Finished := true;
      key := #0;
      Exit;
    End;
End;

{----------------------------------------------------------------------------}
//                  TZoomInOutAction
{----------------------------------------------------------------------------}

Constructor TZoomInOutAction.CreateAction( CmdLine: TEzCmdLine; Action: TEzZoomAction );
Begin
  Inherited CreateAction( CmdLine );
  FAction := Action;

  OnMouseDown := MyMouseDown;
  OnKeyPress := MyKeyPress;

  Case FAction Of
    zaZoomIn: Cursor := crZoomIn;
    zaZoomOut: Cursor := crZoomOut;
  End;

  Caption := SZoomUnZoom;
  CanBeSuspended := false;

End;

Procedure TZoomInOutAction.MyMouseDown( Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer; Const WX, WY: Double );
Var
  OldPoint, NewPoint: TEzPoint;
  PreviewArea, MapDrawingArea: TEzRect;
  DrawingScale, PaperAreaWidth, PaperAreaHeight: Double;
  Picked: Boolean;
  Layer: TEzBaseLayer;
  Recno1, PickedPoint: Integer;
  TmpGrapher: TEzGrapher;
  TmpRect: TRect;
  Ent: TEzEntity;
Begin
  If Button = mbRight Then Exit;
  With CmdLine.ActiveDrawBox Do
  Begin
    { checa si es un preview DrawBox y si el usuario tiene presionado la tecla CTRL }
    If ( CmdLine.ActiveDrawBox Is TEzPreviewBox ) And
       ( ( GetAsyncKeyState( VK_CONTROL ) Shr 1 ) <> 0 ) Then
    Begin
      Picked := PickEntity( WX, WY, Ez_Preferences.ApertureWidth, '', Layer, RecNo1, PickedPoint, Nil );
      If Picked Then
      Begin
        Layer.Recno := Recno1;
        If layer.RecEntityID = idPreview Then
        Begin
          Ent := Layer.LoadEntityWithRecno( Recno1 );
          TmpGrapher := TEzGrapher.Create( 10, adScreen );
          Try
            //TEzPreviewEntity(Ent).DrawBox:=CmdLine.ActiveDrawBox;
            //if TEzPreviewEntity(Ent).GIS<>nil then
            //begin
            PreviewArea.Emin := Ent.Points[0];
            PreviewArea.Emax := Ent.Points[1];
            PreviewArea := ReorderRect2D( PreviewArea );
            PaperAreaWidth := Abs( PreviewArea.X2 - PreviewArea.X1 );
            PaperAreaHeight := Abs( PreviewArea.y2 - PreviewArea.Y1 );
            MapDrawingArea := ReorderRect2D( TEzPreviewEntity( Ent ).ProposedPrintArea );
            With TEzPreviewEntity( Ent ) Do
              DrawingScale := DrawingUnits / PlottedUnits;
            With MapDrawingArea Do
            Begin
              Emax.X := Emin.X + PaperAreaWidth * DrawingScale;
              Emin.Y := Emax.Y - PaperAreaHeight * DrawingScale;
            End;
            TmpRect := ReorderRect( Grapher.RealToRect( Ent.Points.Extension ) );
            With TmpRect Do
              TmpGrapher.SetViewport( Left, Top, Right, Bottom );
            With MapDrawingArea Do
              TmpGrapher.SetWindow( X1, X2, Y1, Y2 );
            TmpGrapher.SetViewTo( MapDrawingarea );
            OldPoint := TmpGrapher.PointToReal( Point( X, Y ) );
            Case FAction Of
              zaZoomIn:
                Begin
                  TmpGrapher.Zoom( 0.85 );
                  TEzPreviewEntity( Ent ).PlottedUnits :=
                    TEzPreviewEntity( Ent ).PlottedUnits * ( 1 / 0.85 );
                End;
              zaZoomOut:
                Begin
                  TmpGrapher.Zoom( 1 / 0.85 );
                  TEzPreviewEntity( Ent ).PlottedUnits := TEzPreviewEntity( Ent ).PlottedUnits * 0.85;
                End;
            End;
            NewPoint := TmpGrapher.PointToReal( Point( X, Y ) );
            With TmpGrapher.CurrentParams.MidPoint Do
              TmpGrapher.ReCentre( X + ( OldPoint.X - NewPoint.X ),
                Y + ( OldPoint.Y - NewPoint.Y ) );
            TEzPreviewEntity( Ent ).ProposedPrintArea := TmpGrapher.CurrentParams.VisualWindow;
            Layer.UpdateEntity( Recno1, Ent );
            Repaint;
            exit;
            //end;
          Finally
            Ent.Free;
            TmpGrapher.Free;
          End;
        End;
      End;
    End;
    { In every zoom the point clicked must stay on same mouse coordinates }
    OldPoint := Point2D( WX, WY );
    Grapher.InUpdate := true; { don't generate two history views }
    Case FAction Of
      zaZoomIn: Grapher.Zoom( 0.85 );
      zaZoomOut: Grapher.Zoom( 1 / 0.85 );
    End;
    Grapher.InUpdate := false;
    NewPoint := Grapher.PointToReal( Point( X, Y ) );
    With Grapher.CurrentParams.MidPoint Do
      Grapher.ReCentre( X + ( OldPoint.X - NewPoint.X ), Y + ( OldPoint.Y - NewPoint.Y ) );
    Repaint;
  End;
End;

Procedure TZoomInOutAction.MyKeyPress( Sender: TObject; Var Key: Char );
Begin
  If Key In [#13, #27] Then
  Begin
    Self.Finished := true;
    key := #0;
  End;
End;

{----------------------------------------------------------------------------}
//                  THandScrollAction
{----------------------------------------------------------------------------}

Constructor THandScrollAction.CreateAction( CmdLine: TEzCmdLine );
Begin
  Inherited CreateAction( CmdLine );

  OnMouseDown := MyMouseDown;
  OnMouseUp := MyMouseUp;
  OnMouseMove := MyMouseMove;
  OnKeyPress := MyKeyPress;

  Cursor := crScrollingUp;

  Caption := SScrolling;

  If CmdLine.ActiveDrawBox <> Nil then
    with cmdLine.ActiveDrawBox.GIS do
    begin
      FSavedShowWaitCursor:= ShowWaitCursor;
      ShowWaitCursor:= False;
    end;
  //CanBeSuspended := True;
End;

destructor THandScrollAction.Destroy;
begin
  If CmdLine.ActiveDrawBox <> Nil then
    CmdLine.ActiveDrawBox.GIS.ShowWaitCursor:= FSavedShowWaitCursor;
  inherited;
end;

Procedure THandScrollAction.MyMouseDown( Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer; Const WX, WY: Double );
Var
  PickedPoint, Delta: Integer;
  Ent: TEzEntity;
  Picked: Boolean;
Begin
  If Button = mbRight Then Exit;
  with CmdLine.ActiveDrawBox do
  begin
    Cursor := crScrollingDn;
    Perform( WM_SETCURSOR, Handle, HTCLIENT );
  end;
  FOrigin := Point( X, Y );
  FDownX := X;
  FDownY := Y;
  FScrolling := True;
  FPickedPreview := False;
  with CmdLine.ActiveDrawBox do
  begin
    Canvas.Pen.Mode:= pmCopy;
    BeginUpdate;
  end;
  If ( CmdLine.ActiveDrawBox Is TEzPreviewBox ) And
     ( ( GetAsyncKeyState( VK_CONTROL ) Shr 1 ) <> 0 ) Then
  Begin
    With CmdLine.ActiveDrawBox Do
    Begin
      { detecta si hay un preview }
      Picked := PickEntity( WX, WY, Ez_Preferences.ApertureWidth,
        '', FPreviewLayer, FPreviewRecNo, PickedPoint, Nil );
      If Picked Then
      Begin
        FPreviewLayer.Recno := FPreviewRecNo;
        If FPreviewLayer.RecEntityID = idPreview Then
        Begin
          Ent := FPreviewLayer.LoadEntityWithRecno( FPreviewRecNo );
          Try
            //TEzPreviewEntity(Ent).DrawBox:=CmdLine.ActiveDrawBox;
            //if TEzPreviewEntity(Ent).GIS<>nil then
            //begin
            FPreviewRect := ReorderRect( Grapher.RealToRect( Ent.Points.Extension ) );
            //InflateRect( FPreviewRect, -1, -1 );
            With TEzPreviewEntity( Ent ) Do
              If ( Pentool.Style = 1 ) And ( Pentool.Width > 0 ) Then
              Begin
                Delta := Grapher.RealToDistY( Pentool.Width );
                InflateRect( FPreviewRect, -Delta, -Delta );
              End
              Else
                InflateRect( FPreviewRect, -1, -1 );
            IntersectRect( FPreviewRect, FPreviewRect, ClientRect );
            FPickedPreview := TRUE;
            //end;
          Finally
            Ent.Free;
          End;
        End;
      End;
    End;
  End;
End;

Procedure THandScrollAction.MyMouseMove( Sender: TObject; Shift: TShiftState;
  X, Y: Integer; Const WX, WY: Double );
Var
  R: Windows.TRect;
  Step, Value: Integer;
  DX, DY: Double;
  Rgn: HRgn;
  BrushClr: TColor;
  TmpWin: TEzRect;
  TmpGrapher: TEzGrapher;

  Procedure MyFillRect( X1, Y1, X2, Y2: Integer );
  Begin
    With CmdLine.ActiveDrawBox.Canvas Do
    Begin
      Brush.Style := bsSolid;
      Brush.Color := BrushClr;
      FillRect( Rect( X1, Y1, X2, Y2 ) );
    End;
  End;

  procedure AreaFillRect( X1, Y1, X2, Y2: Integer );
  begin
    MyFillRect( X1, Y1, X2, Y2 );
  end;

  procedure PaintArea( X1, Y1, X2, Y2: Integer );
  begin
    With CmdLine.ActiveDrawBox, TEzPainterObject.Create(Nil) Do
      Try
        DrawEntities( TmpGrapher.RectToReal(Rect(X1,Y1,X2,Y2)),
                      GIS,
                      Canvas,
                      TmpGrapher,
                      Selection,
                      False,
                      False,
                      pmAll,
                      ScreenBitmap );
      Finally
        Free;
      End;
  End;

Begin
  If Not FScrolling Then Exit;
  Step := Screen.PixelsPerInch Div 30;
  If Not ( ( Abs( FDownX - X ) >= Step ) Or ( Abs( FDownY - Y ) >= Step ) ) Then Exit;
  With CmdLine.ActiveDrawBox Do
  Begin
    If FPickedPreview Then
    Begin
      BrushClr := TEzPreviewBox( CmdLine.ActiveDrawBox ).PaperBrush.Color;
      Grapher.SaveCanvas( Canvas );
      Canvas.Brush.Style := bsSolid;
      Canvas.Brush.Color := Color;
      With FPreviewRect Do
      Begin
        Value := Top + ( Y - FOrigin.Y );
        If ( ( Y - FOrigin.Y ) > 0 ) And ( Value < Bottom ) Then // upper rectangle area
          MyFillRect( Left, Top, Right, Value );
        Value := Bottom + ( Y - FOrigin.y );
        If ( ( Y - FOrigin.Y ) < 0 ) And ( Value > Top ) Then // below rectangle area
          MyFillRect( Left, Value, Right, Bottom );
        Value := Left + ( X - FOrigin.X );
        If ( ( x - FOrigin.X ) > 0 ) And ( Value < Right ) Then // left rectangle area
          MyFillRect( Left, Top, Value, Bottom );
        Value := Right + ( X - FOrigin.X );
        If ( ( X - FOrigin.X ) < 0 ) And ( Value > Left ) Then // right rectangle area
          MyFillRect( Value, Top, Right, Bottom );
      End;
      Grapher.RestoreCanvas( Canvas );
      R := FPreviewRect;
      OffsetRect( R, X - FOrigin.X, Y - FOrigin.Y );
      With FPreviewRect Do
        Rgn := CreateRectRgn( Left, Top, Right, Bottom );
      SelectClipRgn( Canvas.Handle, Rgn );
      Canvas.CopyRect( R, ScreenBitmap.Canvas, FPreviewRect );
      SelectClipRgn( Canvas.Handle, 0 );
      DeleteObject( Rgn );
    End
    Else
    Begin
      BrushClr := Color;
      Grapher.SaveCanvas( Canvas );
      Canvas.Brush.Style := bsSolid;
      Canvas.Brush.Color := Color;
      // Erase outside of drawing area. This erase not all screen but outside of area
      If ( Y - FOrigin.Y ) > 0 Then // upper rectangle area
        AreaFillRect( 0, 0, ClientWidth, Y - FOrigin.Y );
      If ( Y - FOrigin.Y ) < 0 Then // below rectangle area
        AreaFillRect( 0, ( Y - FOrigin.y ) + ClientHeight, ClientWidth, ClientHeight );
      If ( x - FOrigin.X ) > 0 Then // left rectangle area
        AreaFillRect( 0, 0, X - FOrigin.X, ClientHeight );
      If ( X - FOrigin.X ) < 0 Then // right rectangle area
        AreaFillRect( ( X - FOrigin.X ) + ClientWidth, 0, ClientWidth, ClientHeight );
      Grapher.RestoreCanvas( Canvas );
      R := ClientRect;
      OffsetRect( R, X - FOrigin.X, Y - FOrigin.Y );
      Canvas.CopyRect( R, ScreenBitmap.Canvas, ClientRect );
      If CmdLine.DynamicUpdate then
      begin
        TmpGrapher:= TEzGrapher.Create(10,adScreen);
        Try
          TmpGrapher.Assign(CmdLine.ActiveDrawBox.Grapher);
          DX := TmpGrapher.DistToRealX( X - FOrigin.X );
          DY := TmpGrapher.DistToRealX( Y - FOrigin.Y );
          TmpWin := TmpGrapher.CurrentParams.VisualWindow;
          With TmpWin Do
          Begin
            Emin.X := Emin.X - DX;
            Emin.Y := Emin.Y + DY;
            Emax.X := Emax.X - DX;
            Emax.Y := Emax.Y + DY;
          End;
          TmpGrapher.SetViewTo( TmpWin );
          { draw the sections not covered }
          If ( Y - FOrigin.Y ) > 0 Then // upper rectangle area
            PaintArea(0,0,ClientWidth,Y-FOrigin.Y);
          If ( Y - FOrigin.Y ) < 0 Then // below rectangle area
            PaintArea(0, ( Y - FOrigin.y ) + ClientHeight, ClientWidth, ClientHeight);
          If ( x - FOrigin.X ) > 0 Then // left rectangle area
            PaintArea( 0, 0, X - FOrigin.X, ClientHeight );
          If ( X - FOrigin.X ) < 0 Then // right rectangle area
            PaintArea( ( X - FOrigin.X ) + ClientWidth, 0, ClientWidth, ClientHeight );
        Finally
          TmpGrapher.Free;
        End;
      End;
    End;
  End;
  FDownX := X;
  FDownY := Y;
End;

Procedure THandScrollAction.MyMouseUp( Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer; Const WX, WY: Double );
Var
  DX, DY: Double;
  TmpWin: TEzRect;
  PreviewArea, MapDrawingArea: TEzRect;
  PaperAreaWidth, PaperAreaHeight, DrawingScale,
    factorx, factory, deltax, deltay: Double;
  Ent: TEzEntity;
Begin
  If Button = mbRight Then Exit;
  with CmdLine.ActiveDrawBox do
  begin
    Cursor := crScrollingUp;
    Perform( WM_SETCURSOR, Handle, HTCLIENT );
  end;

  FScrolling := false;
  With CmdLine.ActiveDrawBox Do
  Begin
    DX := Grapher.DistToRealX( FDownX - FOrigin.X );
    DY := Grapher.DistToRealY( FDownY - FOrigin.Y );
    If FPickedPreview Then
    Begin
      Ent := FPreviewLayer.LoadEntityWithRecno( FPreviewRecno );
      Try
        //TEzPreviewEntity(Ent).DrawBox:= CmdLine.ActiveDrawBox;
        PreviewArea.Emin := Ent.Points[0];
        PreviewArea.Emax := Ent.Points[1];
        PreviewArea := ReorderRect2D( PreviewArea );
        { first the X axis }
        PaperAreaWidth := Abs( PreviewArea.Emax.X - PreviewArea.Emin.X );
        PaperAreaHeight := Abs( PreviewArea.Emax.y - PreviewArea.Emin.Y );
        MapDrawingArea := ReorderRect2D( TEzPreviewEntity( Ent ).ProposedPrintArea );
        With TEzPreviewEntity( Ent ) Do
          DrawingScale := DrawingUnits / PlottedUnits;
        With MapDrawingArea Do
        Begin
          Emax.X := Emin.X + PaperAreaWidth * DrawingScale;
          Emin.Y := Emax.Y - PaperAreaHeight * DrawingScale;
        End;
        factorx := DX / PaperAreaWidth;
        factory := DY / PaperAreaHeight;
        With MapDrawingArea Do
        Begin
          deltax := ( Emax.X - Emin.X ) * factorx;
          deltay := ( Emax.Y - Emin.Y ) * factory;
          Emin.X := Emin.X - deltax;
          Emin.Y := Emin.Y + deltay;
          Emax.X := Emax.X - deltax;
          Emax.Y := Emax.Y + deltay;
        End;
        TEzPreviewEntity( Ent ).ProposedPrintArea := MapDrawingArea;
        FPreviewLayer.UpdateEntity( FPreviewRecno, Ent );
        //Repaint;
      Finally
        Ent.Free;
      End;
    End
    Else
    Begin
      TmpWin := Grapher.CurrentParams.VisualWindow;
      With TmpWin Do
      Begin
        Emin.X := Emin.X - DX;
        Emin.Y := Emin.Y + DY;
        Emax.X := Emax.X - DX;
        Emax.Y := Emax.Y + DY;
      End;
      Grapher.SetViewTo( TmpWin );
    End;
    CmdLine.ActiveDrawBox.EndUpdate;
  End;
End;

Procedure THandScrollAction.MyKeyPress( Sender: TObject; Var Key: Char );
Begin
  If Key In [#27, #13] Then
  begin
    with cmdLine.ActiveDrawBox do
      If InUpdate then
      begin
        CancelUpdate;
      end;
    Self.Finished := true;
  end;
End;

{----------------------------------------------------------------------------}
//                  TGuideLineAction
{----------------------------------------------------------------------------}

Constructor TGuideLineAction.CreateAction( CmdLine: TEzCmdLine; Orientation: Integer );
Begin
  Inherited CreateAction( CmdLine );

  FOrientation := Orientation;
  FLine := TEzPolyLine.CreateEntity( [Point2D(0, 0), Point2D(0, 0)] );

  CanDoOsnap := True;
  CanDoAccuDraw:= True;

  OnMouseDown := MyMouseDown;
  OnMouseMove := MyMouseMove;
  OnPaint := MyPaint;
  OnKeyPress := MyKeyPress;
  OnActionDoCommand := MyActionDoCommand;
  OnSuspendOperation := Self.SuspendOperation;
  OnContinueOperation := Self.ContinueOperation;

  Cursor := crHandPoint;

  Case FOrientation Of
    0: Caption := SInsertYGuideLine;
    1: Caption := SInsertXGuideLine;
  End;

End;

Destructor TGuideLineAction.Destroy;
Begin
  FLine.Free;
  Inherited Destroy;
End;

procedure TGuideLineAction.SuspendOperation(Sender: TObject);
begin
  If Assigned( FLine ) Then
    CmdLine.All_DrawEntity2DRubberBand( FLine );
end;

procedure TGuideLineAction.ContinueOperation(Sender: TObject);
begin
  If Assigned( FLine ) Then
    CmdLine.All_DrawEntity2DRubberBand( FLine );
end;

Procedure TGuideLineAction.MyActionDoCommand( Sender: TObject );
Var
  SavePt, TmpPt: TEzPoint;
  Xc, Yc: Double;
Begin
  If UserCommand <> itFloatValue Then Exit;
  SavePt := CmdLine.CurrentPoint;
  Xc := UserValue;
  Yc := UserValue;
  Case FOrientation Of
    0:
      Begin
        TmpPt.X := 0;
        TmpPt.Y := Yc;
      End;
    1:
      Begin
        TmpPt.X := Xc;
        TmpPt.Y := 0;
      End;
  End;
  CmdLine.CurrentPoint := TmpPt;
  Self.MyMouseDown( Nil, mbLeft, [], 0, 0, 0, 0 );
End;

Procedure TGuideLineAction.MyMouseDown( Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer; Const WX, WY: Double );
Var
  CurrPoint:TEzPoint;
Begin
  If Button = mbRight Then Exit;
  With CmdLine.ActiveDrawBox Do
  Begin
    CurrPoint:= cmdLine.GetSnappedPoint;
    cmdLine.All_DrawEntity2DRubberBand( FLine );
    Case FOrientation Of
      0: GIS.HGuidelines.Add( CurrPoint.Y );
      1: GIS.VGuidelines.Add( CurrPoint.X );
    End;
    GIS.Modified := true;
    cmdLine.All_Invalidate;
    Self.Finished := true;
  End;
End;

Procedure TGuideLineAction.SetCurrentPoint( Const Pt: TEzPoint );
Begin
  With CmdLine.ActiveDrawBox.Grapher.CurrentParams.VisualWindow Do
    Case FOrientation Of
      0:
        Begin
          FLine.Points[0] := Point2D( Emin.X, Pt.Y );
          FLine.Points[1] := Point2D( Emax.X, Pt.Y );
        End;
      1:
        Begin
          FLine.Points[0] := Point2D( Pt.X, Emin.Y );
          FLine.Points[1] := Point2D( Pt.X, Emax.Y );
        End;
    End;
End;

Procedure TGuideLineAction.MyMouseMove( Sender: TObject; Shift: TShiftState; X, Y: Integer; Const WX, WY: Double );
Var
  CurrPoint: TEzPoint;
Begin
  With CmdLine Do
  Begin
    CurrPoint := GetSnappedPoint;
    All_DrawEntity2DRubberBand( FLine );
    SetCurrentPoint( CmdLine.CurrentPoint );
    All_DrawEntity2DRubberBand( Fline );
  End;
End;

Procedure TGuideLineAction.MyKeyPress( Sender: TObject; Var Key: Char );
Begin
  If Key = #27 Then
  Begin
    CmdLine.All_DrawEntity2DRubberBand( FLine );
    Self.Finished := true;
  End;
End;

Procedure TGuideLineAction.MyPaint( Sender: TObject );
Begin
  (Sender As TEzBaseDrawBox).DrawEntity2DRubberBand( FLine );
End;

{----------------------------------------------------------------------------}
//                  TMoveGuideLineAction
{----------------------------------------------------------------------------}

Constructor TMoveGuideLineAction.CreateAction( CmdLine: TEzCmdLine );
Begin
  Inherited CreateAction( CmdLine );

  FLine := TEzPolyLine.CreateEntity( [Point2D(0, 0), Point2D(0, 0)] );

  OnMouseDown := MyMouseDown;
  OnMouseUp := MyMouseUp;
  OnMouseMove := MyMouseMove;
  OnPaint := MyPaint;
  OnKeyPress := MyKeyPress;
  OnSuspendOperation := Self.SuspendOperation;
  OnContinueOperation := Self.ContinueOperation;

  Cursor := crHandPoint;

  Caption := SSelectGline;
End;

Destructor TMoveGuideLineAction.Destroy;
Begin
  FLine.Free;
  Inherited Destroy;
End;

procedure TMoveGuideLineAction.SuspendOperation(Sender: TObject);
begin
  If FMoving And Assigned( FLine ) then
    CmdLine.All_DrawEntity2DRubberBand( FLine );
end;

procedure TMoveGuideLineAction.ContinueOperation(Sender: TObject);
begin
  If FMoving And Assigned( FLine ) Then
    CmdLine.All_DrawEntity2DRubberBand( FLine );
end;

Procedure TMoveGuideLineAction.DoMoveGuideline( Const P: TEzPoint );
Begin
  With CmdLine.ActiveDrawbox Do
  Begin
    cmdLine.All_DrawEntity2DRubberBand( FLine );
    Case FOrientation Of
      0:
        If ( P.Y > Grapher.CurrentParams.VisualWindow.Y2 ) Or
          ( P.Y < Grapher.CurrentParams.VisualWindow.Y1 ) Then
          { delete the guideline }
          GIS.HGuidelines.Delete( FIndex )
        Else
          GIS.HGuidelines[FIndex] := P.Y;
      1:
        If ( P.X > Grapher.CurrentParams.VisualWindow.X2 ) Or
          ( P.X < Grapher.CurrentParams.VisualWindow.X1 ) Then
          GIS.VGuidelines.Delete( FIndex )
        Else
          GIS.VGuidelines[FIndex] := P.X;
    End;
    cmdLine.All_Refresh;
    cmdLine.Caption := SSelectGline;
    FMoving := False;
    FDetected := False;
  End;
End;

Procedure TMoveGuideLineAction.MyKeyPress( Sender: TObject; Var Key: Char );
Begin
  If Key = #27 Then
  Begin
    CmdLine.All_DrawEntity2DRubberBand( FLine );
    Self.Finished := true;
  End;
End;

Procedure TMoveGuideLineAction.MyMouseDown( Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer; Const WX, WY: Double );
Begin
  If Button = mbRight Then Exit;
  If FDetected Then
  Begin
    { start moving }
    FMoving := True;
    FDetected := False;
    cmdLine.Caption := SMoveGLinetoNew;
  End;
End;

Procedure TMoveGuideLineAction.MyMouseUp( Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer; Const WX, WY: Double );
Begin
  If FMoving Then
  Begin
    { finish moving }
    DoMoveGuideline( CmdLine.CurrentPoint );
  End;
End;

Procedure TMoveGuideLineAction.MyMouseMove( Sender: TObject;
  Shift: TShiftState; X, Y: Integer; Const WX, WY: Double );
Var
  I: Integer;
Begin
  With CmdLine.ActiveDrawBox Do
    If FMoving Then
    Begin
      cmdLine.All_DrawEntity2DRubberBand( FLine );
      SetCurrentPoint( CmdLine.CurrentPoint );
      cmdLine.All_DrawEntity2DRubberBand( Fline );
    End
    Else
    Begin
      FDetected := False;
      { test the horizontal guidelines }
      For I := 0 To GIS.HGuidelines.Count - 1 Do
      Begin
        { build shape based on this polyline }
        If Not IsGuidelineVisible( 0, I ) Then Continue;

        With Grapher.CurrentParams.VisualWindow Do
        Begin
          FLine.Points[0] := Point2D( Emin.X, GIS.HGuidelines[I] );
          FLine.Points[1] := Point2D( Emax.X, GIS.HGuidelines[I] );
        End;
        If IsPointOnEntity( CmdLine, Ez_Preferences.ApertureWidth,
          cmdLine.CurrentPoint, FLine ) Then
        Begin
          FDetected := True;
          FOrientation := 0;
          FIndex := I;
          Cursor := crVSplit;
          Exit;
        End;
      End;
      { test the horizontal guidelines }
      For I := 0 To GIS.VGuidelines.Count - 1 Do
      Begin
        { build shape based on this polyline }
        If Not IsGuidelineVisible( 1, I ) Then  Continue;
        With Grapher.CurrentParams.VisualWindow Do
        Begin
          FLine.Points[0] := Point2D( GIS.VGuidelines[I], Emin.Y );
          FLine.Points[1] := Point2D( GIS.VGuidelines[I], Emax.Y );
        End;
        If IsPointOnEntity( CmdLine, Ez_Preferences.ApertureWidth,
          cmdLine.CurrentPoint, FLine ) Then
        Begin
          FDetected := True;
          FOrientation := 1;
          FIndex := I;
          Cursor := crHSplit;
          Exit;
        End;
      End;
      Cursor := crDefault;
    End;
End;

Procedure TMoveGuideLineAction.MyPaint( Sender: TObject );
Begin
  (Sender As TEzBaseDrawBox).DrawEntity2DRubberBand( FLine );
End;

Procedure TMoveGuideLineAction.SetCurrentPoint( Const Pt: TEzPoint );
Begin
  With CmdLine.ActiveDrawBox.Grapher.CurrentParams.VisualWindow Do
    Case FOrientation Of
      0:
        Begin
          FLine.Points[0] := Point2D( Emin.X, Pt.Y );
          FLine.Points[1] := Point2D( Emax.X, Pt.Y );
        End;
      1:
        Begin
          FLine.Points[0] := Point2D( Pt.X, Emin.Y );
          FLine.Points[1] := Point2D( Pt.X, Emax.Y );
        End;
    End;
End;

Function TMoveGuideLineAction.IsGuidelineVisible( Orientation: Integer; Index: Integer ): boolean;
Var
  P: Double;
Begin
  Result := false;
  With CmdLine.ActiveDrawBox Do
    Case Orientation Of
      0: // horizontal
        Begin
          P := GIS.HGuidelines[Index];
          result := Not ( ( P > Grapher.CurrentParams.VisualWindow.Y2 ) Or
            ( P < Grapher.CurrentParams.VisualWindow.Y1 ) );

        End;
      1: // vertical
        Begin
          P := GIS.VGuidelines[Index];
          result := Not ( ( P > Grapher.CurrentParams.VisualWindow.X2 ) Or
            ( P < Grapher.CurrentParams.VisualWindow.X1 ) );
        End;
    End;
End;

{----------------------------------------------------------------------------}
//                  TSetClipAreaAction
{----------------------------------------------------------------------------}

Constructor TSetClipAreaAction.CreateAction( CmdLine: TEzCmdLine );
Begin
  Inherited CreateAction( CmdLine );

  CanBeSuspended := True;

  CanDoOsnap := True;
  CanDoAccuDraw:= True;
  MouseDrawElements:= [mdCursorFrame, mdFullViewCursor];

  FFrame := TEzRectangle.CreateEntity( Point2D(0, 0), Point2D(0, 0) );

  OnMouseDown := MyMouseDown;
  OnMouseUp := MyMouseUp;
  OnMouseMove := MyMouseMove;
  OnPaint := MyPaint;
  OnKeyPress := MyKeyPress;
  OnSuspendOperation := Self.SuspendOperation;
  OnContinueOperation := Self.ContinueOperation;

  WaitingMouseClick := True;

  Cursor := crZoomIn;
  Caption := SDefineFirstZoomPoint;
End;

Destructor TSetClipAreaAction.Destroy;
Begin
  FFrame.Free;
  Caption := '';
  Inherited Destroy;
End;

procedure TSetClipAreaAction.SuspendOperation(Sender: TObject);
begin
  If Assigned( FFrame ) Then
    CmdLine.All_DrawEntity2DRubberBand( FFrame );
end;

procedure TSetClipAreaAction.ContinueOperation(Sender: TObject);
begin
  If Assigned( FFrame ) Then
    CmdLine.All_DrawEntity2DRubberBand( FFrame );
end;

Procedure TSetClipAreaAction.SetCurrentPoint( Const Pt: TEzPoint );
Var
  I: Integer;
Begin
  FFrame.Points[FCurrentIndex] := Pt;
  For I := FCurrentIndex + 1 To FFrame.Points.Count - 1 Do
    FFrame.Points[I] := Pt;
  If FCurrentIndex = 0 Then
    WaitingMouseClick := False;
End;

Procedure TSetClipAreaAction.DoFinishClipArea;
Var
  TmpRect2D: TEzRect;
Begin
  With CmdLine Do
  Begin
    All_DrawEntity2DRubberBand( FFrame );
    TmpRect2D.Emin := FFrame.Points[0];
    TmpRect2D.Emax := FFrame.Points[1];
    TmpRect2D := ReOrderRect2D( TmpRect2D );
    With ActiveDrawBox.GIS.MapInfo Do
    Begin
      IsAreaClipped := True;
      AreaClipped := TmpRect2D;
      ClipAreaKind := cpkRectangular;
    End;
    All_Repaint;
    with ActiveDrawBox do
      If Assigned( GIS.OnClippedAreaChanged ) Then
        GIS.OnClippedAreaChanged( GIS );
    Self.Finished := true;
  End;
End;

Procedure TSetClipAreaAction.MyMouseDown( Sender: TObject; Button: TMouseButton;
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
    CurrPoint := CurrentPoint;
    SetCurrentPoint( CurrPoint );
    If FCurrentIndex = 0 Then
      FOrigin := Point( X, Y );
    If FCurrentIndex >= 1 Then
    Begin
      DoFinishClipArea;
      Exit;
    End;
    Inc( FCurrentIndex );
    If FCurrentIndex > 0 Then
      Caption := SDefineSecondZoomPoint;
    All_DrawEntity2DRubberBand( FFrame );
  End;
End;

Procedure TSetClipAreaAction.MyMouseUp( Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer; Const WX, WY: Double );
Var
  Pt: TPoint;
Begin
  Pt := Point( X, Y );
  If ( Abs( Pt.X - FOrigin.X ) > 5 ) And ( Abs( Pt.Y - FOrigin.Y ) > 5 ) Then
  Begin
    DoFinishClipArea;
    Exit;
  End;
End;

Procedure TSetClipAreaAction.MyMouseMove( Sender: TObject; Shift: TShiftState;
  X, Y: Integer; Const WX, WY: Double );
Var
  CurrPoint: TEzPoint;
Begin
  With CmdLine Do
  Begin
    All_DrawEntity2DRubberBand( FFrame );
    CurrPoint := CurrentPoint;
    SetCurrentPoint( CurrPoint );
    All_DrawEntity2DRubberBand( FFrame );
  End;
End;

Procedure TSetClipAreaAction.MyPaint( Sender: TObject );
Begin
  If FFrame <> Nil Then
    (Sender As TEzBaseDrawBox).DrawEntity2DRubberBand( FFrame );
End;

Procedure TSetClipAreaAction.MyKeyPress( Sender: TObject; Var Key: Char );
Var
  TmpRect2D: TEzRect;
Begin
  With CmdLine Do
    Case Key Of
      #27:
        Begin
          {cancels the zooming}
          All_DrawEntity2DRubberBand( FFrame );
          Self.Finished := true;
        End;
      #13:
        Begin
          All_DrawEntity2DRubberBand( FFrame );
          TmpRect2D.Emin := FFrame.Points[0];
          TmpRect2D.Emax := FFrame.Points[1];
          TmpRect2D := ReOrderRect2D( TmpRect2D );
          With ActiveDrawBox.GIS.MapInfo Do
          Begin
            IsAreaClipped := True;
            AreaClipped := TmpRect2D;
          End;
          Self.Finished := true;
          Key := #0;
          Exit;
        End;
    End;
End;

{----------------------------------------------------------------------------}
//                  TSetPolygonClipAreaAction
{----------------------------------------------------------------------------}

Constructor TSetPolygonClipAreaAction.CreateAction( CmdLine: TEzCmdLine );
Begin
  Inherited CreateAction( CmdLine );

  FEntity := TEzPolygon.CreateEntity( [Point2D(0, 0)] );

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

  Caption := SClipPolygon;

End;

Destructor TSetPolygonClipAreaAction.Destroy;
Begin
  FEntity.Free;
  Inherited Destroy;
End;

procedure TSetPolygonClipAreaAction.SuspendOperation(Sender: TObject);
begin
  If Assigned( FEntity ) Then
    CmdLine.All_DrawEntity2DRubberBand( FEntity );
end;

procedure TSetPolygonClipAreaAction.ContinueOperation(Sender: TObject);
begin
  If Assigned( FEntity ) Then
    CmdLine.All_DrawEntity2DRubberBand( FEntity );
end;

Procedure TSetPolygonClipAreaAction.SetCurrentPoint( Pt: TEzPoint; Orto: Boolean );
Var
  cnt: Integer;
Begin
  If Orto And ( FCurrentIndex > 0 ) Then
    Pt := ChangeToOrtogonal( FEntity.Points[FCurrentIndex - 1], Pt );
  FEntity.Points[FCurrentIndex] := Pt;
  For cnt := FCurrentIndex + 1 To FEntity.Points.Count - 1 Do
    FEntity.Points[cnt] := Pt;
End;

Procedure TSetPolygonClipAreaAction.MyMouseDown( Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer; Const WX, WY: Double );
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
    SetCurrentPoint( CurrPoint, UseOrto );
    Inc( FCurrentIndex );
    Caption := SClipPolygon;
  End;
End;

Procedure TSetPolygonClipAreaAction.MyMouseMove( Sender: TObject;
  Shift: TShiftState; X, Y: Integer; Const WX, WY: Double );
Var
  CurrPoint: TEzPoint;
Begin
  With CmdLine Do
  Begin
    All_DrawEntity2DRubberBand( FEntity );
    CurrPoint := GetSnappedPoint;
    SetCurrentPoint( CurrPoint, UseOrto );
    All_DrawEntity2DRubberBand( FEntity );
  End;
End;

Procedure TSetPolygonClipAreaAction.MyPaint( Sender: TObject );
Begin
  If FEntity <> Nil Then
    (Sender As TEzBaseDrawBox).DrawEntity2DRubberBand( FEntity );
End;

Procedure TSetPolygonClipAreaAction.UndoOperation;
Var
  CurrPoint: TEzPoint;
Begin
  With CmdLine Do
  Begin
    All_DrawEntity2DRubberBand( FEntity );
    If FCurrentIndex > 0 Then
      Dec( FCurrentIndex );
    CurrPoint := GetSnappedPoint;
    SetCurrentPoint( CurrPoint, UseOrto );
    All_DrawEntity2DRubberBand( FEntity );
    Caption := SClipPolygon;
  End;
End;

Procedure TSetPolygonClipAreaAction.MyKeyPress( Sender: TObject; Var Key: Char );
Var
  TmpArea: TEzRect;
Begin
  With CmdLine Do
    Case Key Of
      #27:
        Begin
          {cancels the insertion}
          All_DrawEntity2DRubberBand( FEntity );
          Self.Finished := true;
        End;
      #13:
        Begin
          If ( FCurrentIndex <= 2 ) Then
          Begin
            MessageToUser( SNotEnoughData, smsgerror, MB_ICONERROR );
            Exit;
          End;
          (* Erase entity from screen and last point*)
          All_DrawEntity2DRubberBand( FEntity );
          FEntity.Points.Delete( FCurrentIndex );
          If Not EqualPoint2D( FEntity.Points[0], FEntity.Points[FEntity.Points.Count - 1] ) Then
            FEntity.Points.Add( FEntity.Points[0] );
          Try
            (* set the clipping polygonal area *)
            With ActiveDrawBox Do
            Begin
              GIS.ClipPolygonalArea.Assign( FEntity.Points );
              With GIS.MapInfo Do
              Begin
                IsAreaClipped := True;
                TmpArea.Emin := FEntity.FBox.Emin;
                TmpArea.Emax := FEntity.FBox.Emax;
                AreaClipped := TmpArea;
                ClipAreaKind := cpkPolygonal;
              End;
              Repaint;
              If Assigned( GIS.OnClippedAreaChanged ) Then
                GIS.OnClippedAreaChanged( GIS );
            End;
          Except
            On E: Exception Do
              MessageToUser( E.Message, smsgerror, MB_ICONERROR );
          End;

          Self.Finished := true;
          Key := #0;
          Exit;
        End;
    End;
End;

{----------------------------------------------------------------------------}
//                  TReshapeEntityAction
{----------------------------------------------------------------------------}

Constructor TReshapeEntityAction.CreateAction( CmdLine: TEzCmdLine; Aperture: Integer );
var
  p: TEzPoint;
Begin
  Inherited CreateAction( CmdLine );

  FOldHiliteSnapped:= CmdLine.AccuSnap.HiliteSnapped;

  Ez_Preferences.GRotatePoint:= INVALID_POINT;

  p:= Point2d(0,0);
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

  CanDoOsnap:= True;
  CanDoAccuDraw:= True;
  MouseDrawElements:= [mdCursorFrame, mdFullViewCursor];

  FAperture := Aperture;
  FCurrentIndex := -1;
  FCurrentRecno := -1;

  OnMouseDown := MyMouseDown;
  OnMouseMove := MyMouseMove;
  OnMouseUp := MyMouseUp;
  OnKeyPress := MyKeyPress;
  OnPaint := MyPaint;
  OnSuspendOperation:= SuspendOperation;
  OnContinueOperation:= ContinueOperation;

  Cursor := crDrawCross;
  Caption := SEntityToReshape;
End;

Destructor TReshapeEntityAction.Destroy;
Begin
  FReshaping := false;
  if CmdLine.ActiveDrawBox <> nil then
    CmdLine.ActiveDrawBox.Invalidate;
  If FStackedSelList <> Nil Then
    FStackedSelList.Free;
  FLineTransform.Free;
  CmdLine.AccuSnap.HiliteSnapped:= FOldHiliteSnapped;
  Ez_Preferences.GRotatePoint:= INVALID_POINT;
  Inherited;
End;

Function TReshapeEntityAction.MyOwnPointCode( Ent: TEzEntity;
  Const Pt: TEzPoint; Const Aperture: Double; Var Distance: Double;
  SelectPickingInside: Boolean ): Integer;
Var
  I, J: integer;
  MinDist: Double;
  ControlPts: TEzVector;
  Found: Boolean;
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
      If IsNearPoint2D( Pt,
        TransformPoint2D( ControlPts[I], Ent.GetTransformMatrix ), Aperture, Distance ) And
        ( Distance < MinDist ) Then
      Begin
        Result := I;
        MinDist := Distance;
        Found:= False;
        if Ent.GetControlPointType(I) = cptRotate then
        begin
          { find the cptMove control point and assign it instead of the one found }
          for J:= ControlPts.Count-1 downto 0 do
            if Ent.GetControlPointType(J) = cptMove then
            begin
              FLineTransform.Points[0]:= ControlPts[J];
              FLineTransform.Points[1]:= ControlPts[J];
              Found:= True;
              Break;
            end;
        end;
        if not Found then
        begin
          FLineTransform.Points[0]:= ControlPts[I];
          FLineTransform.Points[1]:= ControlPts[I];
        end;
      End;
  Finally
    If Ent.Points <> ControlPts Then
      ControlPts.Free;
  End;
End;

Procedure TReshapeEntityAction.MyMouseDown( Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer;
  Const WX, WY: Double );
Var
  CurrPoint: TEzPoint;
  TmpLayer: TEzBaseLayer;
  I, N, TmpRecNo, Aperture, PickedPoint: Integer;
  TmpEnt: TEzEntity;
  MinDist, Distance: Double;
  RealAperture: TEzPoint;
  Picked, Found: Boolean;
  dbox: TEzBaseDrawBox;
  SegmentAngle: Double;

  Procedure SetCurrentVertex;
  var
    AEntity: TEzEntity;
    AIndex1, AIndex2: Integer;
    CtrlPointType: TEzControlPointType;
    I: Integer;
    V: TEzVector;
  Begin
    If PickedPoint >= 0 Then
    Begin
      FCurrentIndex := PickedPoint;
      FReshaping := true;
      CanDoOsnap := True;
      CmdLine.AccuSnap.HiliteSnapped:= False;
      Caption := SReshapeToPoint;

      If CmdLine.AccuDraw.Enabled Then
      Begin
        AEntity:= FCurrentLayer.LoadEntityWithRecno( FCurrentRecno );
        If AEntity=Nil Then Exit;
        CtrlPointType:= AEntity.GetControlPointType(FCurrentIndex);
        If CtrlPointType=cptNode then
          V:= AEntity.GetControlPoints(False,CmdLine.ActiveDrawBox.Grapher)
        Else
          V:= AEntity.GetControlPoints(True,CmdLine.ActiveDrawBox.Grapher);
        Try
          If V.Count < 2 Then Exit;
          If CtrlPointType=cptNode then
          begin
            If Not(AEntity.EntityID in [idPolyline,idPolygon,idSplineText,idSpline,idNodeLink]) Then
            begin
              AIndex1:=FCurrentIndex;
              AIndex2:=FCurrentIndex;
            end else
            begin
              with CmdLine.AccuDraw do
                If FCurrentIndex < V.Count-1 then
                begin
                  If ReshapeAdvance And (FCurrentIndex < V.Count-2) then
                  begin
                    AIndex2:= FCurrentIndex + 1;
                    AIndex1:= FCurrentIndex + 2;
                  end else
                  begin
                    AIndex1:= FCurrentIndex;
                    AIndex2:= FCurrentIndex + 1;
                  end;
                End Else
                Begin
                  AIndex1:= FCurrentIndex;
                  AIndex2:= FCurrentIndex - 1;
                End;
            end;
            { accudraw }
            CmdLine.AccuDraw.UpdatePosition( V[AIndex1], V[AIndex2] )
          end Else
          Begin
            { probably a move or rotate control point was clicked. Search for to
              activate an AccuDraw }
            If CtrlPointType = cptMove Then
            begin
              CmdLine.AccuDraw.UpdatePosition( V[FCurrentIndex], V[FCurrentIndex] );
            end else if CtrlPointType = cptRotate Then
            begin
              { find the move control point }
              For I:= V.Count-1 downto 0 do
                If AEntity.GetControlPointType(I)=cptMove then
                begin
                  CmdLine.AccuDraw.UpdatePosition( V[FCurrentIndex], V[I] );
                  break;
                end;
            end;
          End;
        Finally
          AEntity.Free;
          V.Free;
        End;
      End;
    End
    Else If FPickedSegment Then
    Begin
      FCurrentIndex := -1;
      FReshaping := True;
      Caption := SReshapeToPoint;
      CanDoOsnap := True;
      CmdLine.AccuSnap.HiliteSnapped:= False;
      If CmdLine.AccuDraw.Enabled Then
        CmdLine.AccuDraw.ChangeOrigin(CurrPoint, SegmentAngle);
    End Else
    Begin
      FCurrentIndex := -1;
      FReshaping := false;
      FPickedSegment:= False;
      Caption := SVertexToReshape;
      CmdLine.AccuSnap.HiliteSnapped:= FOldHiliteSnapped;
      //CmdLine.AccuDraw.Showing:= False;
    End;
  End;

Begin
  If Button = mbRight Then Exit;
  dbox := CmdLine.ActiveDrawBox;
  With dbox Do
  Begin
    CurrPoint := CmdLine.GetSnappedPoint;
    FNewPoint := CurrPoint;
    If FReshaping Then
    Begin
      DrawSelectionRubberBanding( true );
      Repaint;
      DrawSelectionRubberBanding( false );
      //CmdLine.AccuDraw.Showing:= False;
      FReshaping := false;
      //CanDoOsnap := False;
      Caption := SVertexToReshape;
      If FPickedSegment then
      begin
        FPickedSegment:= False;
        If CmdLine.AccuDraw.Enabled Then
          CmdLine.AccuDraw.ChangeOrigin(CurrPoint);
      end;
    End
    Else
      With CmdLine Do
      Begin
        Picked := False;
        With dbox Do
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
                  FPickedSegment:= False;
                  TmpLayer := FCurrentLayer;
                  TmpRecNo := FCurrentRecno;
                End Else If TmpEnt.Points.Count > 1 Then
                Begin
                  { no point picked. Search for a line segment picked }
                  PickedPoint:= TmpEnt.PointCode( CurrPoint, MinDist, Distance, False, False );
                  If PickedPoint = PICKED_POINT Then
                  Begin
                    { picked on a line segment. The line segment is the following }
                    FSegmentIdx1 := Ez_Preferences.GNumPoint;
                    If FSegmentIdx1 = TmpEnt.DrawPoints.Count - 1 Then
                      FSegmentIdx2 := 0
                    Else
                      FSegmentIdx2 := Succ( FSegmentIdx1 );
                    SegmentAngle:= Angle2d(TmpEnt.Points[FSegmentIdx1],TmpEnt.Points[FSegmentIdx2]);  // used in SetCurrentVertex here
                    FStartPoint:= Perpend(CurrPoint, TmpEnt.Points[FSegmentIdx1], TmpEnt.Points[FSegmentIdx2]);
                    Found := True;
                    Picked := True;
                    FPickedSegment:= True;
                    FLineTransform.Points[0]:= FStartPoint;
                    FLineTransform.Points[1]:= FStartPoint;
                    TmpLayer := FCurrentLayer;
                    TmpRecNo := FCurrentRecno;
                  End;
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
              If dbox.StackedSelect Then
              Begin
                If FStackedSelList = Nil Then
                  FStackedSelList := TStringList.Create
                Else
                  FStackedSelList.Clear;
              End
              Else If FStackedSelList <> Nil Then
                FreeAndNil( FStackedSelList );
            End;
            Picked := PickEntity( CurrPoint.X, CurrPoint.Y, FAperture,
              '', TmpLayer, TmpRecNo, PickedPoint, FStackedSelList );
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
            { is the same or another entity }
            With ActiveDrawBox Do
            Begin
              DrawSelectionRubberBanding( false );    // erase previous
              FCurrentLayer := TmpLayer;
              FCurrentRecno := TmpRecNo;
              { now draw new one }
              SetCurrentVertex;
              DrawSelectionRubberBanding( false );    // draw new one
            End;
          End
          Else
          Begin
            FCurrentLayer := TmpLayer;
            FCurrentRecno := TmpRecNo;
            FIsOneSelected := true;
            CmdLine.AccuSnap.HiliteSnapped:= False;

            FCurrentIndex := -1;
            FReshaping := False;
            Caption := SVertexToReshape;
            DrawSelectionRubberBanding( false );

            { erase the accudraw }
            CmdLine.AccuDraw.ShowUnrotated;
          End;
        End
        Else
        Begin
          If FIsOneSelected Then
            DrawSelectionRubberBanding( false );
          FIsOneSelected := false;
          CmdLine.AccuSnap.HiliteSnapped:= FOldHiliteSnapped;
          FReshaping := false;
          FCurrentEntity := Nil;
          FCurrentLayer := Nil;
          FCurrentRecno := -1;

          { erase the accudraw }
          CmdLine.AccuDraw.ShowUnrotated;
        End;
      End;
  End;
End;

Procedure TReshapeEntityAction.MyMouseMove( Sender: TObject; Shift: TShiftState;
  X, Y: Integer; Const WX, WY: Double );
Var
  CurrPoint: TEzPoint;
Begin
  CurrPoint := CmdLine.GetSnappedPoint;
  If FReshaping Then
  Begin
    {erase previous}
    DrawSelectionRubberBanding( false );
    FNewPoint := CurrPoint;
    DrawSelectionRubberBanding( false );

    RubberLineTransform;
    FLineTransform.Points[1]:= CurrPoint;
    RubberLineTransform;
  End;
End;

Procedure TReshapeEntityAction.MyMouseUp( Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer;
  Const WX, WY: Double );
Begin
  CmdLine.All_Invalidate;
End;

Procedure TReshapeEntityAction.DrawSelectionRubberBanding( ApplyTransform: Boolean;
  Sender: TObject=Nil );
Var
  TmpEntity: TEzEntity;
  ControlPointType: TEzControlPointType;
  Accept, temp: Boolean;
  TransformType: TEzTransformType;
  M: TEzMatrix;
  IsCTRLPressed: boolean;

  Procedure ShowFeatures( AEntity: TEzEntity );
  Var
    P1, P2: TEzPoint;
    Dx, Dy, Angle, Area, Perimeter: Double;
    ControlPts: TEzVector;
    nd: Integer;
  Begin
    { now show the new entity features }
    If Not fReshaping Or ( FCurrentIndex < 1 ) Then Exit;
    ControlPts := AEntity.GetControlPoints(True,CmdLine.ActiveDrawBox.Grapher);
    Try
      P1 := ControlPts[FCurrentIndex - 1];
      P2 := ControlPts[FCurrentIndex];
    Finally
      If ControlPts <> AEntity.Points Then
        ControlPts.Free;
    End;
    DX := Abs( P2.X - P1.X );
    DY := Abs( P2.Y - P1.Y );
    Angle := 0;
    Area := 0;
    Perimeter := 0;
    if AEntity.EntityID in [idPlace, idNode, idBlockInsert] then
    Begin
      Angle := RadToDeg( Angle2D( P1, P2 ) );
    End Else If Not ( Not ( AEntity Is TEzOpenedEntity ) Or ( ( DX = 0 ) And ( DY = 0 ) ) ) Then
    Begin
      Angle := RadToDeg( Angle2D( P1, P2 ) );
      Area := AEntity.Area;
      Perimeter := AEntity.Perimeter;
    End;
    nd:= CmdLine.ActiveDrawBox.NumDecimals;
    CmdLine.StatusMessage :=
      Format( SNewEntityInfo, [ nd, Angle, nd, DX, nd, DY, nd, Area, nd, Perimeter ] );
  End;

Begin
  With CmdLine Do
  Begin
    With FCurrentLayer Do
    Begin
      if FCurrentRecno < 0 then
        Exit;
      TmpEntity := LoadEntityWithRecno( FCurrentRecno );
      Try
        TmpEntity.UpdateExtension;
        //Prev:= TmpEntity.FBox;
        temp:= false;
        IsCTRLPressed:= false;
        If FReshaping Then
        Begin
          If FPickedSegment Then
          Begin
            { update the points in the segment }
            M:= Translate2D( FNewPoint.X - FStartPoint.X, FNewPoint.Y - FStartPoint.Y);
            TmpEntity.Points[FSegmentIdx1]:= TransformPoint2d(TmpEntity.Points[FSegmentIdx1], M);
            TmpEntity.Points[FSegmentIdx2]:= TransformPoint2d(TmpEntity.Points[FSegmentIdx2], M);
          End Else
          Begin
            IsCTRLPressed:= (( GetAsyncKeyState( VK_CONTROL ) Shr 1 ) <> 0) {And
              (TmpEntity.GetControlPointType(FCurrentIndex)=cptMove)};
            If IsCTRLPressed Then  // is CTRL key pressed ?
              Ez_Preferences.GRotatePoint:= FNewPoint
            Else
              TmpEntity.UpdateControlPoint( FCurrentIndex, FNewPoint,CmdLine.ActiveDrawBox.Grapher );
            TmpEntity.SelectedVertex := FCurrentIndex;
          End;
          ShowFeatures( TmpEntity );
          temp:= ActiveDrawBox.HideVertexNumber;
          ActiveDrawBox.HideVertexNumber:= true;
        End;
        TmpEntity.UpdateExtensionFromControlPts;
        If Sender = Nil Then
          All_DrawEntity2DRubberBand( TmpEntity, True, Not FReshaping or IsCTRLPressed )
        Else
          (Sender As TEzBaseDrawBox).DrawEntity2DRubberBand( TmpEntity, True, Not FReshaping or IsCTRLPressed );
        If FReshaping then ActiveDrawBox.HideVertexNumber:= temp;
        If ApplyTransform And Not FCurrentLayer.LayerInfo.Locked Then
        Begin
          if Assigned(ActiveDrawBox.Gis.OnBeforeTransform) then
          begin
            ControlPointType := TmpEntity.GetControlPointType(FCurrentIndex);
            if ControlPointType in [cptMove, cptRotate] then
            begin
              TransformType:= ttTranslate;
              if ControlPointType = cptRotate then
                TransformType:= ttRotate;
              Accept:= True;
              ActiveDrawBox.Gis.OnBeforeTransform( ActiveDrawBox.Gis, FCurrentLayer, FCurrentRecno,
                TmpEntity, TransformType, Accept );
              if not Accept then Exit;
            end;
          end;

          { update links }
          If TmpEntity.EntityID = idNode Then
          Begin
            TEzNode( TmpEntity ).UpdatePosition(FCurrentRecno, FCurrentLayer );
          End;
          If TmpEntity.EntityID = idNodeLink Then
          Begin
            TEzNodeLink( TmpEntity ).UpdatePosition(FCurrentRecno, FCurrentLayer );
            ControlPointType := TmpEntity.GetControlPointType(FCurrentIndex);
            If ControlPointType = cptNode then
            begin
              { if the link is not linked to an existing node, try to link with
                this method }
              TEzNodeLink( TmpEntity ).LinkToNode( FCurrentIndex, FCurrentRecno,
                 FCurrentLayer, CmdLine.ActiveDrawBox );
            end;
          End;

          ActiveDrawBox.Undo.AddUnTransform(FCurrentLayer, FCurrentRecno);
          UpdateEntity( FCurrentRecno, TmpEntity );

          with ActiveDrawBox do
            if ApplyTransform and Assigned(Gis.OnAfterTransform) then
              Gis.OnAfterTransform( Gis, FCurrentLayer, FCurrentRecno );
        End;
      Finally
        FreeAndNil( TmpEntity );
      End;
    End;
  End;
End;

Procedure TReshapeEntityAction.MyKeyPress( Sender: TObject; Var Key: Char );
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
      //CanDoOsnap := False;
    End;
  End;
End;

Procedure TReshapeEntityAction.MyPaint( Sender: TObject );
Begin
  If FIsOneSelected Then
  begin
    DrawSelectionRubberBanding( false, Sender );
    If FReshaping Then
      RubberLineTransform(Sender);
  end;
End;

procedure TReshapeEntityAction.RubberLineTransform(Sender: TObject = Nil);
var
  OldStyle: TPenstyle;
  dbox: TEzBaseDrawBox;
begin
  If Sender= Nil then
    dbox := cmdLine.ActiveDrawBox
  else
    dbox := (Sender As TEzBaseDrawBox);
  with dbox do
  begin
    OldStyle:= RubberPen.Style;
    RubberPen.Style:=psDot;
    If Sender=Nil Then
      cmdLine.All_DrawEntity2DRubberBand( FLineTransform )
    else
      dbox.DrawEntity2DRubberBand( FLineTransform );
    RubberPen.Style:=Oldstyle;
  end;
end;

procedure TReshapeEntityAction.SuspendOperation(Sender: TObject);
begin
  If FIsOneSelected Then
  begin
    If FReshaping Then RubberLineTransform;
    DrawSelectionRubberBanding( false );
  end;
end;

procedure TReshapeEntityAction.ContinueOperation(Sender: TObject);
begin
  { the order of this sequence is important}
  If FIsOneSelected Then
  begin
    DrawSelectionRubberBanding( false );
    If FReshaping Then RubberLineTransform;
  end;
end;

procedure TReshapeEntityAction.SetCurrentLayer(const Value: TezBaseLayer);
begin
  FCurrentLayer := Value;
  FIsOneSelected := True;
  DrawSelectionRubberBanding(False, nil);
end;

procedure TReshapeEntityAction.SetCurrentRecno(const Value: Integer);
begin
  FCurrentRecno := Value;
  FIsOneSelected := True;
  DrawSelectionRubberBanding(False, nil);
end;

{----------------------------------------------------------------------------}
//                  TDeleteVertexAction
{----------------------------------------------------------------------------}

Constructor TDeleteVertexAction.CreateAction( CmdLine: TEzCmdLine );
Begin
  Inherited CreateAction( CmdLine );

  MouseDrawElements:= [mdCursorFrame, mdFullViewCursor];

  {Clear the selection if there is}
  With CmdLine.ActiveDrawBox Do
  Begin
    If Selection.Count > 0 Then
    Begin
      Selection.Clear;
      Repaint;
    End;
  End;

  FAperture := Ez_Preferences.ApertureWidth;
  FCurrentIndex := -1;
  FCurrentRecno := -1;

  OnMouseDown := MyMouseDown;
  OnKeyPress := MyKeyPress;
  OnPaint := MyPaint;

  Cursor := crDrawCross;
  Caption := SEntityToReshape;
End;

Destructor TDeleteVertexAction.Destroy;
Begin
  FCurrentLayer := Nil;
  FCurrentRecno := 0;
  if CmdLine.ActiveDrawBox <> nil then
    CmdLine.All_Invalidate;
  Inherited Destroy;
End;

Procedure TDeleteVertexAction.MyMouseDown( Sender: TObject; Button: TMouseButton; Shift: TShiftState;
  X, Y: Integer; Const WX, WY: Double );
Var
  CurrPoint: TEzPoint;
  TmpLayer: TEzBaseLayer;
  TmpRecNo, Aperture, PickedPoint: Integer;
  Picked: Boolean;
  TmpEnt: TEzEntity;
  MinDist, Distance: Double;
  RealAperture: TEzPoint;
  Found: Boolean;

  Function SetCurrentVertex: Boolean;
  Begin
    If PickedPoint >= 0 Then
    Begin
      FCurrentIndex := PickedPoint;
      Result := true;
    End
    Else
    Begin
      FCurrentIndex := -1;
      Result := false;
    End;
    Caption := SVertexToDelete;
  End;

Begin
  If Button = mbRight Then Exit;
  With CmdLine Do
  Begin
    CurrPoint := CurrentPoint;
    Picked := False;
    With ActiveDrawBox Do
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
            PickedPoint := TmpEnt.PointCode( CurrPoint, MinDist, Distance,
              Ez_Preferences.SelectPickingInside );
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
        Picked := PickEntity( CurrPoint.X, CurrPoint.Y, FAperture, '', TmpLayer,
          TmpRecNo, PickedPoint, Nil );
    End;
    If Picked Then
    Begin
      If FIsOneSelected Then
      Begin
        {is the same or another entity}
        With ActiveDrawBox Do
        Begin
          DrawSelectionRubberBanding( false );
          FCurrentLayer := TmpLayer;
          FCurrentRecno := TmpRecNo;
          {now draw new one}
          DrawSelectionRubberBanding( SetCurrentVertex );
        End;
      End
      Else
      Begin
        With ActiveDrawBox Do
        Begin
          FCurrentLayer := TmpLayer;
          FCurrentRecno := TmpRecNo;
        End;
        FIsOneSelected := true;

        FCurrentIndex := -1;
        Caption := SVertexToDelete;
        DrawSelectionRubberBanding( false );
      End;
    End
    Else
    Begin
      If FIsOneSelected Then
        DrawSelectionRubberBanding( false );
      FIsOneSelected := false;
      FCurrentEntity := Nil;
      FCurrentLayer := Nil;
      FCurrentRecno := -1;
    End;
  End;
End;

Procedure TDeleteVertexAction.DrawSelectionRubberBanding( ApplyTransform: Boolean;
  Sender: TObject=Nil );
Var
  TmpEntity: TEzEntity;
Begin
  With CmdLine Do
  Begin
    With FCurrentLayer Do
    Begin
      TmpEntity := LoadEntityWithRecno( FCurrentRecno );
      //prev := TmpEntity.FBox;
      Try
        If ApplyTransform And TmpEntity.Points.CanGrow And
          ( TmpEntity.Points.Count > 2 ) Then
          TmpEntity.Points.Delete( FCurrentIndex );
        All_DrawEntity2DRubberBand( TmpEntity, true, false );
        If ApplyTransform And Not LayerInfo.Locked Then
        Begin
          ActiveDrawBox.Undo.AddUnTransform(FCurrentLayer, FCurrentRecno);
          TmpEntity.UpdateExtension;
          UpdateEntity( FCurrentRecno, TmpEntity );
        End;
      Finally
        FreeAndNil( TmpEntity );
      End;
    End;
  End;
End;

Procedure TDeleteVertexAction.MyKeyPress( Sender: TObject; Var Key: Char );
Begin
  If Key = #27 Then
  Begin
    If FIsOneSelected Then
      DrawSelectionRubberBanding( false );
    Self.Finished := true;
    FCurrentLayer := Nil;
    FCurrentRecno := 0;
    CmdLine.All_Repaint;
  End;
End;

Procedure TDeleteVertexAction.MyPaint( Sender: TObject );
Begin
  If FIsOneSelected Then
    DrawSelectionRubberBanding( false, Sender );
End;

{----------------------------------------------------------------------------}
//                  TCustomClickAction
{----------------------------------------------------------------------------}

Constructor TCustomClickAction.CreateAction( CmdLine: TEzCmdLine );
Begin
  Inherited CreateAction( CmdLine );

  OnMouseDown := MyMouseDown;
  OnKeyPress := MyKeyPress;

  Cursor := crHandPoint;
  Caption := SClickInterestPoint;
End;

Procedure TCustomClickAction.MyMouseDown( Sender: TObject; Button: TMouseButton; Shift: TShiftState;
  X, Y: Integer; Const WX, WY: Double );
Begin
  If Button = mbRight Then Exit;
  With CmdLine.ActiveDrawBox Do
    If Assigned( OnCustomClick ) Then
      OnCustomClick( CmdLine.ActiveDrawBox, X, Y, WX, WY );
End;

Procedure TCustomClickAction.MyKeyPress( Sender: TObject; Var Key: Char );
Begin
  If Key = #27 Then
  Begin
    Self.Finished := true
  End;
End;

{----------------------------------------------------------------------------}
//                  TDropSelectAction
{----------------------------------------------------------------------------}

Constructor TDropSelectionAction.CreateAction( CmdLine: TEzCmdLine );
var
  I,J,N: Integer;
  Entity: TEzEntity;
  Cx,Cy: Double;
  SelLayer: TEzSelectionLayer;
Begin
  Inherited CreateAction( CmdLine );

  FDrawBoxWithSel:= CmdLine.ActiveDrawBox;
  if FDrawBoxWithSel.Selection.Count=0 then
    Raise EInvalidOperation.Create( SWarnNoSelection );

  { calculate selection centroid }
  FSelCentroid.X:= 0;
  FSelCentroid.Y:= 0;
  N:= 0;
  with CmdLine.ActiveDrawBox do
    for I:= 0 to Selection.Count-1 do
    begin
      SelLayer:= Selection[I];
      for J:= 0 to SelLayer.SelList.Count-1 do
      begin
        Entity:= SelLayer.Layer.LoadEntityWithRecno( SelLayer.SelList[J] );
        Try
          Entity.Centroid( Cx, Cy );
          FSelCentroid.x := FSelCentroid.x + Cx;
          FSelCentroid.y := FSelCentroid.y + Cy;
          Inc( N );
        Finally
          Entity.Free;
        end;
      end;
    end;
  FSelCentroid.X:= FSelCentroid.X/N;
  FSelCentroid.Y:= FSelCentroid.Y/N;

  OnMouseDown := MyMouseDown;
  OnMouseMove := MyMouseMove;
  OnKeyPress := MyKeyPress;
  OnPaint:= MyPaint;

  Cursor := crHandPoint;
  Caption := SClickInterestPoint;
End;

procedure TDropSelectionAction.MyMouseMove(Sender: TObject;
  Shift: TShiftState; X, Y: Integer; const WX, WY: Double);
Begin
  DrawSelectionRubberBanding;
  FLastPos:= Point2d(Wx,Wy);
  DrawSelectionRubberBanding;
end;

Procedure TDropSelectionAction.MyPaint(Sender: TObject);
Begin
  DrawSelectionRubberBanding(Sender);
End;

Procedure TDropSelectionAction.DrawSelectionRubberBanding(Sender: TObject=Nil);
Var
  Tx, Ty: Double;
  I,J,Recno: Integer;
  Entity: TEzEntity;
begin
  With FDrawBoxWithSel Do
  Begin
    if Selection.Count = 0 then Exit;
    Tx:= FLastPos.x - FSelCentroid.X;
    Ty:= FLastPos.y - FSelCentroid.Y;
    For I := 0 To Selection.Count - 1 Do
    Begin
      With Selection[I] Do {the layer selected}
        For J := 0 To SelList.Count - 1 Do
        Begin
          Recno := SelList[J];
          Entity := Layer.LoadEntityWithRecno( Recno );
          Try
            Entity.SetTransformMatrix( Translate2D( Tx, Ty ) );
            cmdLine.All_DrawEntity2DRubberBand( Entity );
          Finally
            Entity.Free;
          End;
        End;
    End;
  End
End;

Procedure TDropSelectionAction.MyMouseDown( Sender: TObject; Button: TMouseButton; Shift: TShiftState;
  X, Y: Integer; Const WX, WY: Double );
Begin
  If Button = mbRight Then Exit;
  With CmdLine Do
  begin
    ActiveDrawbox.DropSelectionAt( Wx, Wy );
    All_Repaint;
    All_Invalidate;
  end;
End;

Procedure TDropSelectionAction.MyKeyPress( Sender: TObject; Var Key: Char );
Begin
  If Key = #27 Then
    Self.Finished := true
End;

{----------------------------------------------------------------------------}
{                  TAddMarkerAction implementation                           }
{----------------------------------------------------------------------------}

Constructor TAddMarkerAction.CreateAction( CmdLine: TEzCmdLine );
Begin
  Inherited CreateAction( CmdLine );

  FNumSymbol:= CmdLine.ActiveDrawBox.SymbolMarker;
  FMarker := TEzPlace.CreateEntity( Point2D(0, 0) );
  With TEzPlace(FMarker).Symboltool.FSymbolStyle Do
  Begin
    If FNumSymbol > Ez_Symbols.Count - 1 Then
      FNumSymbol:= 0;
    Index := FNumSymbol;
    Height := CmdLine.ActiveDrawBox.Grapher.getrealsize( Ez_Preferences.DefSymbolStyle.height );
    FMarker.UpdateExtension;
  End;

  CanDoOsnap := True;

  OnMouseMove := MyMouseMove;
  OnMouseUp := MyMouseUp;
  OnMouseDown := MyMouseDown;
  OnKeyPress := MyKeyPress;
  OnPaint := MyPaint;
  OnSuspendOperation := Self.SuspendOperation;
  OnContinueOperation := Self.ContinueOperation;

  Cursor := crDrawCross;
  Caption := SClickInterestPoint;
End;

destructor TAddMarkerAction.Destroy;
begin
  FMarker.Free;
  inherited;
end;

procedure TAddMarkerAction.SetCurrentPoint( Const Pt: TEzPoint );
Begin
  FMarker.Points[0]:= Pt;
End;

procedure TAddMarkerAction.SuspendOperation(Sender: TObject);
begin
  CmdLine.All_DrawEntity2DRubberBand( FMarker );
end;

procedure TAddMarkerAction.ContinueOperation(Sender: TObject);
begin
  CmdLine.All_DrawEntity2DRubberBand( FMarker );
end;

Procedure TAddMarkerAction.MyMouseMove( Sender: TObject; Shift: TShiftState;
  X, Y: Integer; Const WX, WY: Double );
Begin
  CmdLine.All_DrawEntity2DRubberBand( FMarker );
  SetCurrentPoint( CmdLine.GetSnappedPoint );
  CmdLine.All_DrawEntity2DRubberBand( FMarker );
End;

Procedure TAddMarkerAction.MyMouseDown( Sender: TObject; Button: TMouseButton; Shift: TShiftState;
  X, Y: Integer; Const WX, WY: Double );
Begin
  If Button = mbRight Then Exit;
  EzSystem.AddMarker( CmdLine.ActiveDrawBox, WX, WY, False );
End;

Procedure TAddMarkerAction.MyMouseUp( Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer; Const WX, WY: Double );
Begin
  CmdLine.All_Invalidate;
End;

Procedure TAddMarkerAction.MyKeyPress( Sender: TObject; Var Key: Char );
Begin
  If Key = #27 Then
    Self.Finished := true
End;

Procedure TAddMarkerAction.MyPaint( Sender: TObject );
Begin
  (Sender As TEzBaseDrawBox).DrawEntity2DRubberBand( FMarker );
End;

{ TRotateAccuDrawAction }

constructor TRotateAccuDrawAction.CreateAction(CmdLine: TEzCmdLine);
begin
  Inherited CreateAction(CmdLine);
  CanDoAccuDraw:= true;
  CanDoOsnap:= true;
  OnMouseMove := MyMouseMove;
  OnMouseUp := MyMouseUp;
  OnKeyPress := MyKeyPress;
  cmdLine.PreviousAction.ContinueOperation;
end;

procedure TRotateAccuDrawAction.MyKeyPress(Sender: TObject; var Key: Char);
begin
  If Key=#13 then
    MyMouseUp(Nil,mbLeft,[],0,0,0,0)
  else if Key=#27 then
    Finished:= true;
end;

procedure TRotateAccuDrawAction.MyMouseUp(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer; const WX,
  WY: Double);
var
  CurrPoint: TEzPoint;
begin
  cmdLine.PreviousAction.SuspendOperation;

  CurrPoint := CmdLine.GetSnappedPoint;
  with CmdLine.AccuDraw do
    ChangeOrigin( AccuOrigin, Angle2d(AccuOrigin, CurrPoint) );

  cmdLine.PreviousAction.ContinueOperation;
  Finished:= true;
end;

procedure TRotateAccuDrawAction.MyMouseMove(Sender: TObject;
  Shift: TShiftState; X, Y: Integer; const WX, WY: Double);
var
  CurrPoint: TEzPoint;
begin
  cmdLine.PreviousAction.SuspendOperation;

  CurrPoint := CmdLine.GetSnappedPoint;
  with CmdLine.AccuDraw do
    ChangeOrigin( AccuOrigin, Angle2d(AccuOrigin, CurrPoint) );

  cmdLine.PreviousAction.ContinueOperation;
end;

{ TAutoMoveAction }

constructor TAutoMoveAction.CreateAction(CmdLine: TEzCmdLine);
begin
  inherited CreateAction(CmdLine, ttTranslate, False, saBoth);
  OnMouseUp := MyMouseUp;
end;

procedure TAutoMoveAction.MyMouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer; const WX, WY: Double);
begin
  OnMouseDown(CmdLine.ActiveDrawBox, mbLeft, [], X, Y, WX, WY);
end;

{ TRotateTextAction }

constructor TRotateTextAction.CreateAction(CmdLine: TEzCmdLine;
  Aperture: Integer);
begin
  inherited CReateAction(CmdLine);
  CanDoOsnap := False;
  CanDoAccuDraw := False;

  with CmdLine.ActiveDrawBox do
  begin
    FCurrentRecno := Selection[0].SelList[0];
    FCurrentLayer := Selection[0].Layer;
  end;
  OnMouseDown := MyMouseDown;
  OnMouseMove := MyMouseMove;
  OnKeyPress := MyKeyPress;
  OnPaint := MyPaint;
end;

destructor TRotateTextAction.Destroy;
begin
  FreeAndNil(FText);
  inherited;
end;

procedure TRotateTextAction.DrawText;
begin
  if Assigned(FText) then
    CmdLine.All_DrawEntity2DRubberBand(FText);
end;

procedure TRotateTextAction.MyKeyPress(Sender: TObject; var Key: Char);
begin
  if Key <> #27 then
    FCurrentLayer.UpdateEntity(FCurrentRecno, FText);
  Self.Finished := True;
end;

procedure TRotateTextAction.MyMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer; const WX, WY: Double);
begin
  FCurrentLayer.UpdateEntity(FCurrentRecno, FText);
  Self.Finished := True;
//  CmdLine.Clear;
end;

procedure TRotateTextAction.MyMouseMove(Sender: TObject; Shift: TShiftState; X,
  Y: Integer; const WX, WY: Double);
begin
  if not Assigned(FText) then
    FText := FCurrentLayer.LoadEntityWithRecNo(FCurrentRecno) as TEzTrueTypeText
  else
    DrawText; // стираем нарисованный
  // считаем угол
  FText.FontTool.Angle := Angle2D(FText.BasePoint, Point2D(WX, WY));
  // рисуем текст
  DrawText;
end;

procedure TRotateTextAction.MyPaint(Sender: TObject);
begin
  DrawText;
end;

{ TAutoHandScrollAction }

constructor TAutoHandScrollAction.CreateAction(CmdLine: TEzCmdLine);
begin
  inherited CreateAction(CmdLine);

  OnMouseDown := MyMouseDown;
  OnMouseUp := MyMouseUp;
  OnMouseMove := MyMouseMove;
  OnKeyPress := MyKeyPress;

  Cursor := crArrow;

  Caption := SScrolling;

  if Assigned(CmdLine.ActiveDrawBox) then
    with cmdLine.ActiveDrawBox.GIS do
    begin
      FSavedShowWaitCursor := ShowWaitCursor;
      ShowWaitCursor := False;
    end;
end;

destructor TAutoHandScrollAction.Destroy;
begin
  if CmdLine.ActiveDrawBox <> nil then
    CmdLine.ActiveDrawBox.GIS.ShowWaitCursor := FSavedShowWaitCursor;
  inherited;
end;

procedure TAutoHandScrollAction.Finish;
var
  DX, DY: Double;
  TmpWin: TEzRect;
  TmpChar: Char;
begin
  try
    FScrolling := False;
    with CmdLine.ActiveDrawBox Do
    begin
      DX := Grapher.DistToRealX(FDownX - FOrigin.X);
      DY := Grapher.DistToRealY(FDownY - FOrigin.Y);
      TmpWin := Grapher.CurrentParams.VisualWindow;
      with TmpWin do
      begin
        Emin.X := Emin.X - DX;
        Emin.Y := Emin.Y + DY;
        Emax.X := Emax.X - DX;
        Emax.Y := Emax.Y + DY;
      end;
      Grapher.SetViewTo(TmpWin);
      CmdLine.ActiveDrawBox.EndUpdate;
    end;
    TmpChar := #27;
    MyKeyPress(Self, TmpChar);
  except

  end;
end;

procedure TAutoHandScrollAction.MyKeyPress(Sender: TObject; var Key: Char);
begin
  if Key in [#27, #13] then
  begin
    if cmdLine.ActiveDrawBox.InUpdate then
      cmdLine.ActiveDrawBox.CancelUpdate;
    Self.Finished := True;
  end;
end;

procedure TAutoHandScrollAction.MyMouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer; const WX, WY: Double);
begin
  if Button <> mbRight then
    Exit;
  FOrigin := Point(X, Y);
  FDownX := X;
  FDownY := Y;
  FScrolling := True;
  with CmdLine.ActiveDrawBox do
  begin
    Canvas.Pen.Mode := pmCopy;
    BeginUpdate;
  end;
end;

procedure TAutoHandScrollAction.MyMouseMove(Sender: TObject;
  Shift: TShiftState; X, Y: Integer; const WX, WY: Double);
var
  R: Windows.TRect;
  Step: Integer;
  DX, DY: Double;
  BrushClr: TColor;
  TmpWin: TEzRect;
  TmpGrapher: TEzGrapher;

  procedure MyFillRect(X1, Y1, X2, Y2: Integer);
  begin
    with CmdLine.ActiveDrawBox.Canvas do
    begin
      Brush.Style := bsSolid;
      Brush.Color := BrushClr;
      FillRect(Rect(X1, Y1, X2, Y2));
    end;
  end;

  procedure AreaFillRect(X1, Y1, X2, Y2: Integer);
  begin
    MyFillRect(X1, Y1, X2, Y2);
  end;

  procedure PaintArea(const X1, Y1, X2, Y2: Integer);
  begin
    with CmdLine.ActiveDrawBox, TEzPainterObject.Create(nil) do
    try
      DrawEntities(
        TmpGrapher.RectToReal(Rect(X1,Y1,X2,Y2)),
        GIS,
        Canvas,
        TmpGrapher,
        Selection,
        False,
        False,
        pmAll,
        ScreenBitmap);
    finally
      Free;
    end;
  end;

begin
  if not FScrolling then
    Exit;
  Step := Screen.PixelsPerInch div 30;
  if not ((Abs(FDownX - X) >= Step) or (Abs(FDownY - Y) >= Step)) then
    Exit;
  with CmdLine.ActiveDrawBox do
  begin
    BrushClr := Color;
    Grapher.SaveCanvas(Canvas);
    Canvas.Brush.Style := bsSolid;
    Canvas.Brush.Color := Color;
    // Erase outside of drawing area. This erase not all screen but outside of area
    if (Y - FOrigin.Y) > 0 then // upper rectangle area
      AreaFillRect(0, 0, ClientWidth, Y - FOrigin.Y);
    if (Y - FOrigin.Y) < 0 then // below rectangle area
      AreaFillRect(0, (Y - FOrigin.y) + ClientHeight, ClientWidth, ClientHeight);
    if (x - FOrigin.X) > 0 then // left rectangle area
      AreaFillRect(0, 0, X - FOrigin.X, ClientHeight);
    if (X - FOrigin.X) < 0 then // right rectangle area
      AreaFillRect((X - FOrigin.X) + ClientWidth, 0, ClientWidth, ClientHeight);
    Grapher.RestoreCanvas(Canvas);
    R := ClientRect;
    OffsetRect(R, X - FOrigin.X, Y - FOrigin.Y);
    Canvas.CopyRect(R, ScreenBitmap.Canvas, ClientRect);
    if CmdLine.DynamicUpdate then
    begin
      TmpGrapher:= TEzGrapher.Create(10,adScreen);
      try
        TmpGrapher.Assign(CmdLine.ActiveDrawBox.Grapher);
        DX := TmpGrapher.DistToRealX(X - FOrigin.X);
        DY := TmpGrapher.DistToRealX(Y - FOrigin.Y);
        TmpWin := TmpGrapher.CurrentParams.VisualWindow;
        with TmpWin do
        begin
          Emin.X := Emin.X - DX;
          Emin.Y := Emin.Y + DY;
          Emax.X := Emax.X - DX;
          Emax.Y := Emax.Y + DY;
        end;
        TmpGrapher.SetViewTo(TmpWin);
        { draw the sections not covered }
        if (Y - FOrigin.Y) > 0 then // upper rectangle area
          PaintArea(0,0,ClientWidth,Y-FOrigin.Y);
        if (Y - FOrigin.Y) < 0 then // below rectangle area
          PaintArea(0, (Y - FOrigin.y) + ClientHeight, ClientWidth, ClientHeight);
        if (x - FOrigin.X) > 0 then // left rectangle area
          PaintArea(0, 0, X - FOrigin.X, ClientHeight);
        if (X - FOrigin.X) < 0 then // right rectangle area
          PaintArea((X - FOrigin.X) + ClientWidth, 0, ClientWidth, ClientHeight);
      finally
        TmpGrapher.Free;
      end;
    end;
  end;
  FDownX := X;
  FDownY := Y;
end;

procedure TAutoHandScrollAction.MyMouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer; const WX, WY: Double);
begin
  //  if Button <> mbRight then Exit;
  Finish(); 
end;

End.
