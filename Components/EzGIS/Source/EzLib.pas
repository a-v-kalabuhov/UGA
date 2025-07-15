Unit EzLib;

{***********************************************************}
{     EzGIS/CAD Components                                  }
{   (c) 2002 EzSoft Engineering                             }
{         All Rights Reserved                               }
{***********************************************************}

{$I EZ_FLAG.PAS}
Interface

Uses
  SysUtils, Classes, Windows, Graphics, Printers, Forms;

Type

  TEzVector = Class;
  TIntegerList = Class;
  TEzPointList = Class;

  TEzLineRelation = ( lrDivToRight,
                      lrDivToLeft,
                      lrAtDivStart,
                      lrAtDivEnd,
                      lrBetweenDiv,
                      lrOffDivStart,
                      lrOffDivEnd,
                      lrParToRight,
                      lrParToLeft,
                      lrAtParStart,
                      lrAtParEnd,
                      lrBetweenPar,
                      lrOffParStart,
                      lrOffParEnd,
                      lrParallel,
                      lrIntOffDiv,
                      lrIntOffPar );

  TEzLineRelations = Set Of TEzLineRelation;

  TEzDrawMode = ( dmNormal, dmRubberPen, dmSelection );

  TEzClipCodes = Set Of ( ccFirst, ccSecond, ccNotVisible, ccVisible );

  { 2D Point }
  PEzPoint = ^TEzPoint;
  TEzPoint = Packed Record
    x: double; (* Vertex x component                *)
    y: double; (* vertex y component                *)
  End;

  //PEzRect = ^TEzRect;
  TEzRect = Packed Record
    Case Byte Of
      0: ( X1, Y1, X2, Y2: Double ); // (left,bottom)-(right,top) coordinates
      1: ( Emin, Emax: TEzPoint );
      2: ( xmin, ymin, xmax, ymax: Double );
  End;

  TBooleanArray = Array[0..( MaxInt Div SizeOf( Boolean ) ) - 1] Of Boolean;
  PBooleanArray = ^TBooleanArray;

  TByteArray = Array[0..( MaxInt Div SizeOf( Byte ) ) - 1] Of Byte;
  PByteArray = ^TByteArray;

  TIntegerArray = Array[0..( MaxInt Div SizeOf( Integer ) ) - 1] Of Integer;
  PIntegerArray = ^TIntegerArray;

  PDoubleArray = ^TDoubleArray;
  TDoubleArray = Array[0..0] Of Double;

  TPointArray = Array[0..( MaxInt Div SizeOf( TPoint ) ) - 1] Of TPoint;
  PPointArray = ^TPointArray;

  TEzPointArray = Array[0..( MaxInt Div SizeOf( TEzPoint ) ) - 1] Of TEzPoint;
  PEzPointArray = ^TEzPointArray;

  TEzRectArray = Array[0..0] Of TEzRect;
  PEzRectArray = ^TEzRectArray;

  PEzMatrix = ^TEzMatrix;
  TEzMatrix = Packed record
    Matrix: Array[0..2,0..2] of Double;
  end;

  { Symbol style }
  TEzSymbolStyle = Packed Record
    Index: SmallInt;
    Rotangle: Double; // rotation angle in radians
    Height: Double; // <0 is in points, >0 is in real units
  End;

  { Line style record }
  TEzPenStyle = Packed Record
    Style: Byte; {line Style, 0= no draw, 1=solid, etc.}
    Color: TColor; {color of line}
    Width: Double; // <0 is in points, >0 is in real units
{    Case Byte Of
      0: ( Scale: Double );
      1: ( Width: Double ); // <0 is in points, >0 is in real units }
  End;

  { fill style record }
  TEzBrushStyle = Packed Record
    Pattern: Word; { hatch pattern 0= no fill, 1=solid, etc. }
    Case Byte Of
      0: ( Color: TColor;
           Scale: Double;
           Angle: Double );
      1: ( ForeColor: TColor;
           BackColor: TColor );
  End;

  { the font style }
  TEzFontStyle = Packed Record
    Name: String[LF_FACESIZE - 1];
    //CharSet: TFontCharSet;
    Style: TFontStyles;
    Color: TColor;
    Angle: Single;
    Height: Double; // <0 is in points, >0 is in real units
  End;

  PTransformParams = ^TEzTransformParams;
  TEzTransformParams = Packed Record
    VisualWindow: TEzRect;
    MidPoint: TEzPoint;
    XScale, YScale: Double;
  End;

  { TEzCanvasRegionStacker }
  TEzCanvasRegionStacker = Class( TObject )
  Private
    FRegions: Array[1..5] Of HRgn; // 5 = maximum stacked regions depth
    FCanvas: TCanvas; // the canvas that is stacking regions
    FCount: Integer; // current count of stacked regions
  Public
    Procedure Push( Canvas: TCanvas; Rgn: HRgn );
    Procedure Pop( Canvas: TCanvas );
    Procedure PopAll( Canvas: TCanvas );
  End;

  { Graphic Transformer class - used for transforming from
    world coordinate to device coords and viceversa - abreviated TEzGrapher }
  TEzActiveDevice = ( adScreen, adPrinter );

  TEzGrapher = Class( TObject )
  Private
    FViewPortRect: TEzRect;
    FDevice: TEzActiveDevice;
    { To handle the previous views }
    FHistoryList: TList;
    FMaxHistoryCount: Integer;
    FInUpdate: Boolean;

    { To save/restore the canvas attribs }
    FOldPenStyle: TPenStyle;
    FOldPenMode: TPenMode;
    FOldPenWidth: Integer;
    FOldPenColor: TColor;
    FOldBrushStyle: TBrushStyle;
    FOldBrushColor: TColor;
    FCanvasRegionStacker: TEzCanvasRegionStacker;

    { this data is used for optimum performance in drawing entities
      BeginOptimizer...ClearOptimizer...EndOptimizer }
    FVisiblePoints: TEzVector;
    FFirstClipPts: TEzVector;
    FDevicePoints: TEzPointList;
    FParts: TIntegerList;
    FIsFullInside: TBits;
    FInOptimizer: Boolean;

    FOnChange: TNotifyEvent;
    Procedure Delete( Index: Integer );
    Procedure Push;
    Function GetHistoryCount: Integer;
  Public
    {DPI of devices}
    ScreenDpiX, ScreenDpiY: Integer;
    PrinterDpiX, PrinterDpiY: Integer;
    OriginalParams: TEzTransformParams;
    CurrentParams: TEzTransformParams;

    {methods}
    Constructor Create( MaxHistoryCount: Integer; ADevice: TEzActiveDevice );
    Destructor Destroy; Override;
    Procedure Assign( Source: TEzGrapher );
    Procedure Pop;
    Procedure Clear;
    Function CanPop: Boolean;
    Procedure Zoom( Const Factor: Double );
    Procedure SetViewPort( Const ALeft, ATop, ARight, ABottom: Double );
    Procedure Window( Const Xi, Xf, Yi, Yf: Double );
    Procedure SetWindow( Const Xi, Xf, Yi, Yf: Double );
    //procedure ResetWindow(const Xi, Xf, Yi, Yf: Double);
    Procedure SetViewTo( Const ViewWin: TEzRect );
    Procedure ReCentre( Const MX, MY: Double );
    {conversion}
    Function PointToReal( Const P: TPoint ): TEzPoint;
    Function RealToPoint( Const P: TEzPoint ): TPoint;
    Function RectToReal( Const ARect: TRect ): TEzRect;
    Function RealToRect( Const ARect: TEzRect ): TRect;
    Function DistToRealX( DistX: Integer ): Double;
    Function DistToRealY( DistY: Integer ): Double;
    Function RealToDistX( Const DistX: Double ): Integer;
    Function RealToDistY( Const DistY: Double ): Integer;
    Function RDistToRealX( Const DistX: Double ): Double;
    Function RDistToRealY( Const DistY: Double ): Double;
    Function RRealToDistX( Const DistX: Double ): Double;
    Function RRealToDistY( Const DistY: Double ): Double;
    Function PointsToDistX( Const Size: Double ): Double;
    Function PointsToDistY( Const Size: Double ): Double;
    Function DistToPointsX( Const Dist: Double ): Double;
    Function DistToPointsY( Const Dist: Double ): Double;
    Function DpiX: Integer;
    Function DpiY: Integer;
    Procedure SaveCanvas( ACanvas: TCanvas );
    Procedure RestoreCanvas( ACanvas: TCanvas );
    { for internal use }
    Function GetSizeInPoints( Const Value: double ): Double;
    Function GetRealSize( value: double ): double;
    Procedure BeginOptimizer( PointsSize, PartsSize : Integer );
    Procedure ClearOptimizer;
    Procedure EndOptimizer;

    {properties}
    Property Device: TEzActiveDevice Read FDevice Write FDevice;
    Property ViewPortRect: TEzRect Read FViewPortRect;
    Property InUpdate: Boolean Read FInUpdate Write FInUpdate;
    Property MaxHistoryCount: Integer Read FMaxHistoryCount Write FMaxHistoryCount;
    Property HistoryCount: Integer Read GetHistoryCount;
    Property CanvasRegionStacker: TEzCanvasRegionStacker Read FCanvasRegionStacker;
    Property InOptimizer: Boolean read FInOptimizer;

    { events }
    Property OnChange: TNotifyEvent Read FOnChange Write FOnChange;
  End;

  TEzChangeVectorEvent = Procedure Of Object;

  { TIntegerList class }

  TIntegerList = Class
  Private
    FList: TList;
    Function Get( Index: Integer ): Integer;
    Procedure Put( Index: Integer; Value: Integer );
    Function GetCapacity: Integer;
    Procedure SetCapacity( Value: Integer );
    Function GetCount: Integer;
    Procedure SetCount( Value: Integer );
    function GetLast: Integer;
  Public
    Constructor Create;
    Destructor Destroy; Override;
    Procedure Assign( AList: TIntegerList );
    Function Add( Item: Integer ): Integer;
    Procedure Clear;
    Procedure Delete( Index: Integer );
    Procedure Insert( Index: Integer; Value: Integer );
    Function IndexOfValue( Item: Integer ): Integer;
    Procedure Sort;
    Function Find(Value: Integer; var Index: Integer): Boolean;
    procedure LoadFromStream( Stream: TStream );
    Procedure SaveToStream( Stream: TStream );
    Procedure LoadFromFile( const FileName: string );
    Procedure SaveToFile( const FileName: string );
    Procedure Reindex;

    Property Items[Index: Integer]: Integer Read Get Write Put; Default;
    Property Capacity: Integer Read GetCapacity Write SetCapacity;
    Property Count: Integer Read GetCount Write SetCount;
    property Last: Integer read GetLast;
  End;

  {-----------------------------------------------------------------------------}
  //                   TEzDoubleList
  {-----------------------------------------------------------------------------}

  TEzDoubleList = Class
  Private
    FList: TList;
    Function GetCount: Integer;
    Function GetItem( Index: Integer ): Double;
    Procedure SetItem( Index: Integer; Const Value: Double );
  Public
    Constructor Create;
    Destructor Destroy; Override;
    Function Add( Const Value: Double ): Integer;
    Procedure Clear;
    Procedure Delete( Index: Integer );
    Procedure Insert( Index: Integer; Const Value: Double );
    Procedure Sort;
    function IndexOf(const Value: Double): Integer;

    Property Count: Integer Read GetCount;
    Property Items[Index: Integer]: Double Read GetItem Write SetItem; Default;
  End;

  { Vector handling -- class implement }
  TEzVector = Class
  Private
    FPoints: PEzPointArray;
    FParts: TIntegerList;
    FLast, FCount: Integer;
    FCanGrow: Boolean;
    FDisableEvents: Boolean;
    FOnChange: TEzChangeVectorEvent;

    Function GetExtension: TEzRect;
    Function Get( Index: Integer ): TEzPoint;
    Procedure Put( Index: Integer; Const Item: TEzPoint );
    Function GetX( Index: Integer ): Double;
    Function GetY( Index: Integer ): Double;
    Procedure PutX( Index: Integer; Const Value: Double );
    Procedure PutY( Index: Integer; Const Value: Double );
    Procedure SetCapacity( Value: Integer );
    function GetAsString: String;
    procedure SetAsString(const Value: string);
    Procedure SetCount(Value: Integer);
  Public
    Constructor Create( Size: Integer );
    Destructor Destroy; Override;

    Procedure Clear;
    Procedure Add( Const Item: TEzPoint ); overload;
    Procedure Add( Const X, Y: Double ); overload;
    Procedure AddPoints( Const Items: Array Of TEzPoint );
    Procedure AddVector( aVector: TEzVector );
    Procedure AddPart(aVector: TEzVector);
    Procedure Delete( Index: Integer );
    Procedure Insert( Index: Integer; Const Item: TEzPoint );
    Procedure Assign( Source: TEzVector );
    Procedure LoadFromStream( Stream: TStream );
    Procedure SaveToStream( Stream: TStream );
    Procedure DrawClosed( Canvas: TCanvas; Const Clip, Extent: TEzRect;
      Grapher: TEzGrapher; Const PenStyle: TEzPenStyle; const PenScale: Double;
      Const BrushStyle: TEzBrushStyle;
      Const M: TEzMatrix; DrawMode: TEzDrawMode; Bitmap: Graphics.TBitmap );
    Procedure DrawOpened( Canvas: TCanvas; Const Clip, Extent: TEzRect;
      Grapher: TEzGrapher; Const PenStyle: TEzPenStyle; const PenScale: Double; Const M: TEzMatrix;
      DrawMode: TEzDrawMode );
    Procedure DrawWithLineStyle( Canvas: TCanvas; Const Clip: TEzRect;
      Grapher: TEzGrapher; Const PenStyle: TEzPenStyle; const PenScale: Double;
      Const M: TEzMatrix; DrawMode: TEzDrawMode );
    Procedure DrawHatch( Canvas: TCanvas; Const Clip, Extent: TEzRect;
      Grapher: TEzGrapher; Const BrushStyle: TEzBrushStyle; Const M: TEzMatrix;
      DrawMode: TEzDrawMode );
    Function CrossFrame( Const Frm: TEzRect; Const M: TEzMatrix ): Boolean;
    Procedure clipLiangBarsky( Canvas: TCanvas; Const clipArea: TEzRect;
      Grapher: TEzGrapher; Const Matrix: TEzMatrix; ResultVector: TEzVector );
    Function PointOnPolyLine2D( Idx1: Integer; Const P: TEzPoint;
      Var Dist: Double; Const Aperture: Double; Const T: TEzMatrix;
      Const MustClose: Boolean ): Integer;
    Function PointInPolygon2D( Const P: TEzPoint; Var Dist: Double;
      Const Aperture: Double; Const T: TEzMatrix ): Integer;
    Procedure AddPoint( Const AX, AY: Double );
    Procedure RevertDirection;
    Function TravelDistance( Const Distance: Double; Var p: TEzPoint;
      Var Index1, Index2: Integer ): Boolean;
    Function IsEqualTo( Vector: TEzVector ): Boolean;
    procedure SplitEquidistant(const Source: TEzVector; NumSegs: Integer;
      IndexList: TIntegerList; WidthList: TEzDoubleList);

    Property X[Index: Integer]: Double Read GetX Write PutX;
    Property Y[Index: Integer]: Double Read GetY Write PutY;
    Property Count: Integer Read FCount Write SetCount;
    Property Size: Integer Read FLast;
    Property CanGrow: Boolean Read FCanGrow Write FCanGrow;
    Property DisableEvents: Boolean Read FDisableEvents Write FDisableEvents;
    Property Extension: TEzRect Read GetExtension;
    Property Points[Index: Integer]: TEzPoint Read Get Write Put; Default;
    Property Parts: TIntegerList Read FParts;
    Property Capacity: Integer Read FLast Write SetCapacity;
    Property AsString: string read GetAsString write SetAsString;
    Property OnChange: TEzChangeVectorEvent Read FOnChange Write FOnChange;

  End;

  TEzPointList = Class
  Private
    FPoints: PPointArray;
    FLast, FCount: Integer;
    FCanGrow: Boolean;
    Function Get( Index: Integer ): TPoint;
    Procedure Put( Index: Integer; Const Item: TPoint );
    Function GetX( Index: Integer ): Integer;
    Function GetY( Index: Integer ): Integer;
    Procedure PutX( Index: Integer; Value: Integer );
    Procedure PutY( Index: Integer; Value: Integer );
    Procedure SetCapacity( Value: Integer );
    function GetPoints2D(Index: Integer): TEzPoint;
  Public
    Constructor Create( Size: Integer );
    Destructor Destroy; Override;

    Procedure Clear;
    Procedure Add( Const Item: TPoint );
    Procedure Delete( Index: Integer );
    Procedure Insert( Index: Integer; Const Item: TPoint );
    Procedure AddPoint( AX, AY: Integer );
    Function IsEqual(Index1, Index2: Integer): Boolean;

    Property X[Index: Integer]: Integer Read GetX Write PutX;
    Property Y[Index: Integer]: Integer Read GetY Write PutY;
    Property Count: Integer Read FCount;
    Property Size: Integer Read FLast;
    Property CanGrow: Boolean Read FCanGrow Write FCanGrow;
    Property Points[Index: Integer]: TPoint Read Get Write Put; Default;
    property Points2D[Index: Integer]: TEzPoint read GetPoints2D;
    Property Capacity: Integer Read FLast Write SetCapacity;

  End;

  { Useful functions }
Function BuildTransformationMatrix( const sx,sy,phi,tx,ty : double;
  const refPt: TEzPoint ): TEzMatrix;
procedure matrix3x3PreMultiply(const m: TEzMatrix; var t: TEzMatrix);
Function EqualMatrix2D( Const M1, M2: TEzMatrix ): Boolean;
Function EqualRect2D( Const R1, R2: TEzRect ): Boolean;
Function EqualPoint2D( Const P1, P2: TEzPoint ): Boolean;
Function FuzzEqualPoint2D( Const P1, P2: TEzPoint ): Boolean;
Function Point2D( Const AX, AY: Double ): TEzPoint; overload;
Function Point2D( Const APt: TPoint ): TEzPoint; overload;
Function Rect2D( Const AXmin, AYmin, AXmax, AYmax: Double ): TEzRect;
Function ReorderRect2D( Const R: TEzRect ): TEzRect;
Function ReorderRect( Const R: TRect ): TRect;
Function SetRealToPoint( Const P: TEzPoint ): TPoint;
Function SetPointToReal( Const P: TPoint ): TEzPoint;
Function SetRectToReal( Const R: TRect ): TEzRect;
Function SetRealToRect( Const R: TEzRect ): TRect;
Function IsRectEmpty2D( Const R: TEzRect ): Boolean;
Procedure OffsetRect2D( Var R: TEzRect; Const dx, dy: double );
Procedure InflateRect2D( Var R: TEzRect; Const dx, dy: Double );
Procedure MaxBound( Var bounds: TEzPoint; Const pt: TEzPoint );
Procedure MinBound( Var bounds: TEzPoint; Const pt: TEzPoint );

//Matrix functions
Function MultiplyMatrix2D( Const m, t: TEzMatrix ): TEzMatrix;
Function TransformPoint2D( Const P: TEzPoint; Const T: TEzMatrix ): TEzPoint;
Function TransformRect2D( Const R: TEzRect; Const T: TEzMatrix ): TEzRect;
Function Translate2D( Const Tx, Ty: Double ): TEzMatrix;
Function Rotate2D( Const phi: Double; Const refPt: TEzPoint ): TEzMatrix;
Function Scale2D( Const Sx, Sy: Double; Const refPt: TEzPoint ): TEzMatrix;
Function MirrorAroundX: TEzMatrix;

{ Clipping functions }
Function IntersectRect2D( Const r1, r2: TEzRect ): TEzRect;
Function UnionRect2D( Const r1, r2: TEzRect ): TEzRect;
Function UnionRectAndPoint2D( Const R: TEzRect; const Pt: TEzPoint ): TEzRect;
Function ClipLine2D( Const Clip: TEzRect; Var X1, Y1, X2, Y2: Double ): TEzClipCodes;
Function ClipLineLeftRight2D( Const Clip: TEzRect; Var X1, Y1, X2, Y2: Double ): TEzClipCodes;
Function ClipLineUpBottom2D( Const Clip: TEzRect; Var X1, Y1, X2, Y2: Double ): TEzClipCodes;
Function IsNearPoint2D( Const RP, P: TEzPoint; Const Aperture: Double; Var Dist: Double ): Boolean;
Function Dist2D( Const Pt1, Pt2: TEzPoint ): Double; overload;
Function Dist2D( Const X1, Y1, X2, Y2: Double ): Double; overload;
Function Area2D( Vector: TEzVector ): Double;
Function Angle2D( Const P1, P2: TEzPoint ): Double;

Function IsRectVisible( Const ARect, AClip: TEzRect ): Boolean;
Function IsRectVisibleForPlace( Const ARect, AClip: TEzRect ): Boolean;

Function dMax( Const A, B: Double ): Double;
Function dMin( Const A, B: Double ): Double;
Function IMax( A, B: Integer ): Integer;
Function IMin( A, B: Integer ): Integer;
Function IsPointInBox2D( Const Pt: TEzPoint; Const Box: TEzRect ): Boolean;
Function IsBoxInBox2D( Const Box1, Box2: TEzRect ): Boolean;
Function IsBoxFullInBox2D( Const Box1, Box2: TEzRect ): Boolean;
Function BoxOutBox2D( Box1, Box2: TEzRect ): TEzRect;
//Function BoxFilling2D( Const Box1, Box2: TEzRect ): Integer;
Function TransformBoundingBox2D( const Box: TEzRect; Const Matrix: TEzMatrix ): TEzRect;
Function ChangeToOrtogonal( Const Pt1, Pt2: TEzPoint ): TEzPoint;
Function VectIntersect( Vector1, Vector2, IntersectVector: TEzVector;
  StrictlyBetween: Boolean; CheckLimits: Boolean = False ): Boolean;
Procedure FindCG( Vector: TEzVector; Var CG: TEzPoint; ComputeCG: Boolean );
Function IsCounterClockWise( Vector: TEzVector ): Boolean;
Function IsPointOnMe( Const C, A, B: TEzPoint ): Boolean;
Function PrintersInstalled: Boolean;
Function LineRel( Const P1, P2, D1, D2: TEzPoint; Var P: TEzPoint ): TEzLineRelations;
Procedure ClipPolygonToArea( Vector, ClippedVector: TEzVector; Const ClipArea: TEzRect );
// this code was generousely donated by Jens Gruschel
Procedure GetMinimumDistance2D( Poly1, Poly2: TEzVector;
  Var Distance: Double; Var Min1, Min2: TEzPoint );
//Function PointLineDistance2D( Const P, P1, P2: TEzPoint; Var Dist: Double ): Boolean;
{ this function returns the perpendicular projection of point C on
  the lines that goes from A to B }
Function Perpend( Const C, A, B: TEzPoint ): TEzPoint;
Function GDICheck( Value: Integer ): Integer;
Procedure GDIError;

Const
  MAXCOORD = 1.0E+100;
  MINCOORD = -1.0E+100;
  IDENTITY_MATRIX2D: TEzMatrix = ( Matrix:( ( 1, 0, 0 ), ( 0, 1, 0 ), ( 0, 0, 1 ) ) );
  INVALID_EXTENSION: TEzRect = ( X1: MAXCOORD; Y1: MAXCOORD; X2: MINCOORD; Y2: MINCOORD );
  NULL_EXTENSION: TEzRect = ( X1: 0.0; Y1: 0.0; X2: 0.0; Y2: 0.0 );
  DEFAULT_EXTENSION: TEzRect = ( X1: 0.0; Y1: 0.0; X2: 100.0; Y2: 100.0 );
  INVALID_POINT: TEzPoint = (X: MINCOORD; Y: MINCOORD );
  NULL_POINT: TEzPoint = (X:0; Y:0);
  TOL_EPSILON = 1E-8;

var
  PointPresicion: Integer = 2;

Implementation

Uses
  Consts,
  WinSpool, Math, EzConsts, EzSystem, Ezbase, EzGraphics, EzEntities,
  EzLineDraw, EzBaseExpr, EzExprLex, EzExprYacc, EzLexLib, EzYaccLib,
  EzExpressions ;

Const
  Fuzz = 1.0E-6;

Type

  TEzOutCode = Set Of ( left, bottom, right, top, infront, behind );

  PDouble = ^Double;

Function Defuzz( Const x: Double ): Double;
Begin
  If Abs( x ) < Fuzz Then
    Result := 0.0
  Else
    Result := x;
End;

Function PointLineDistance2D( Const P, P1, P2: TEzPoint; Var Dist: Double ):
  Boolean;
Var
  r, L, LQ, DX, DY: Double;
Begin
  Result := False;
  DX := P2.X - P1.X;
  DY := P2.Y - P1.Y;
  L := Sqrt( DX * DX + DY * DY );
  If L = 0 Then
    Exit;
  LQ := L * L;
  r := ( ( P1.Y - P.Y ) * ( -DY ) - ( P1.X - P.X ) * DX ) / LQ;
  Result := ( r >= 0 ) And ( r <= 1 );
  If Not Result Then
    Exit;
  Dist := Abs( ( ( P1.Y - P.Y ) * DX - ( P1.X - P.X ) * DY ) / L );
End;

{ TEzVector class implementation }

Constructor TEzVector.Create( Size: Integer );
Begin
  Inherited Create;
  FCount := 0;
  FLast := Size;
  GetMem( FPoints, Size * SizeOf( TEzPoint ) );
  FDisableEvents := False;
  FCanGrow := True;
  FParts := TIntegerList.Create;
End;

Destructor TEzVector.Destroy;
Begin
  FreeMem( FPoints, FLast * SizeOf( TEzPoint ) );
  FParts.Free;
  Inherited Destroy;
End;

Procedure TEzVector.SetCapacity( Value: Integer );
Begin
  If FLast >= Value Then
    Exit;
  FLast := Value;
  If FPoints = Nil Then
    GetMem( FPoints, FLast * SizeOf( TEzPoint ) )
  Else
    ReAllocMem( FPoints, FLast * SizeOf( TEzPoint ) );
End;

Function TEzVector.Get( Index: Integer ): TEzPoint;
Begin
  If Index < FCount Then
    Result := FPoints^[Index]
  Else
    EzGISError( SVectorOutOfBound );
End;

Function TEzVector.GetExtension: TEzRect;
Var
  I: Integer;
  Item: TEzPoint;
Begin
  Result := INVALID_EXTENSION;
  For I := 0 To fCount - 1 Do
  Begin
    Item := FPoints^[I];
    If Item.X > Result.X2 Then
      Result.X2 := Item.X;
    If Item.X < Result.X1 Then
      Result.X1 := Item.X;
    If Item.Y > Result.Y2 Then
      Result.Y2 := Item.Y;
    If Item.Y < Result.Y1 Then
      Result.Y1 := Item.Y;
  End;
End;

Procedure TEzVector.SetCount(Value: Integer);
Begin
  If (Value < 0) Or ((Value > FCount) and Not FCanGrow) Then
    EzGISError( SVectorOutOfBound );
  FCount := Value;
End;

Procedure TEzVector.Put( Index: Integer; Const Item: TEzPoint );
Begin
  If Index < FLast Then
  Begin
    FPoints^[Index] := Item;
    If Index >= FCount Then
      FCount := Index + 1;
  End
  Else If FCanGrow Then
  Begin
    { Resize the vector }
    ReAllocMem( FPoints, ( Index + 1 ) * SizeOf( TEzPoint ) );
    FPoints^[Index] := Item;
    FCount := Index + 1;
    FLast := FCount;
  End
  Else
    EzGISError( SVectorOutOfBound );
  If Not FDisableEvents And Assigned( FOnChange ) Then
    FOnChange;
End;

Procedure TEzVector.LoadFromStream( Stream: TStream );
Var
  I, tmpw, n: Integer;
  tmpbool: Boolean;
  P: TEzPoint;
Begin
  tmpbool := FDisableEvents;
  FDisableEvents := true;
  Clear;
  { read number of parts }
  Stream.Read( n, SizeOf( n ) );
  If n > 1 Then
  Begin
    FParts.Capacity := n;
    For i := 1 To n Do
    Begin
      Stream.Read( tmpw, SizeOf( tmpw ) );
      FParts.Add( tmpw );
    End;
  End;
  { read the points }
  With Stream Do
  Begin
    Read( n, sizeof( n ) );
    If n > 0 Then
      SetCapacity( n );
    For I := 1 To n Do
    Begin
      Read( P, sizeof( TEzPoint ) );
      Add( P );
    End;
  End;
  FDisableEvents := tmpbool;
End;

Procedure TEzVector.SaveToStream( Stream: TStream );
Var
  i, tmpw, n: Integer;
Begin
  { write the parts }
  n := FParts.Count;
  If n = 1 Then n := 0;
  Stream.Write( n, SizeOf( n ) );
  For i := 0 To n - 1 Do
  Begin
    tmpw := FParts[i];
    Stream.Write( tmpw, SizeOf( tmpw ) );
  End;
  { write the points }
  With Stream Do
  Begin
    n := FCount;
    Write( n, sizeof( n ) );
    For I := 0 To n - 1 Do
      Write( FPoints^[I], sizeof( TEzPoint ) );
  End;
End;

Procedure TEzVector.Add( Const Item: TEzPoint );
Begin
  Put( FCount, Item );
End;

procedure TEzVector.Add(const X, Y: Double);
begin
  Add(Point2D(X, Y));
end;

procedure TEzVector.AddPart(aVector: TEzVector);
var
  Cnt: Integer;
begin
  if aVector.Count = 0 then
    Exit;                                
  if not FCanGrow and (Count + aVector.Count > FLast) then
    EzGISError(SVectorOutOfBound);
  Cnt := FCount;
  AddVector(aVector);
  // если нет частей, то добавляем первую
  if Cnt > 0 then
  begin
    if Parts.Count = 0 then
      Parts.Add(0);
    if Parts.Last <> Cnt then
      Parts.Add(FCount);
  end;
end;

Procedure TEzVector.AddPoint( Const AX, AY: Double );
Begin
  Put( FCount, Point2D( AX, AY ) );
End;

Function TEzVector.GetX( Index: Integer ): Double;
Begin
  Result := 0;
  If Index < FCount Then
    Result := FPoints^[Index].X
  Else
    EzGISError( SVectorOutOfBound );
End;

Function TEzVector.GetY( Index: Integer ): Double;
Begin
  Result := 0;
  If Index < FCount Then
    Result := FPoints^[Index].Y
  Else
    EzGISError( SVectorOutOfBound );
End;

Procedure TEzVector.PutX( Index: Integer; Const Value: Double );
Var
  Item: TEzPoint;
Begin
  Item := Get( Index );
  Item.X := Value;
  Put( Index, Item );
End;

Procedure TEzVector.PutY( Index: Integer; Const Value: Double );
Var
  Item: TEzPoint;
Begin
  Item := Get( Index );
  Item.Y := Value;
  Put( Index, Item );
End;

Procedure TEzVector.Assign( Source: TEzVector );
Var
  cnt: Integer;
  TmpBool: Boolean;
Begin
  If ( Not FCanGrow ) And ( Source.Count > FLast ) Then
    EzGISError( SVectorOutOfBound );
  TmpBool := FDisableEvents;
  FDisableEvents := True;
  Clear;
  Try
    For cnt := 0 To Source.Count - 1 Do
      Put( FCount, Source[cnt] );
    For cnt := 0 To Source.Parts.Count - 1 Do
      FParts.Add( Source.Parts[cnt] );
  Finally
    FDisableEvents := TmpBool;
  End;
  FCanGrow:= Source.CanGrow;
  If Not FDisableEvents And Assigned( FOnChange ) Then
    FOnChange;
End;

Procedure TEzVector.AddPoints( Const Items: Array Of TEzPoint );
Var
  cnt: Integer;
  TmpBool: Boolean;
Begin
  If ( Not FCanGrow ) And ( High( Items ) - Low( Items ) > FLast ) Then
    EzGISError( SVectorOutOfBound );
  TmpBool := FDisableEvents;
  FDisableEvents := True;
  Try
    For cnt := Low( Items ) To High( Items ) Do
      Put( FCount, Items[cnt] );
  Finally
    FDisableEvents := TmpBool;
  End;
  If Not FDisableEvents And Assigned( FOnChange ) Then
    FOnChange;
End;

procedure TEzVector.AddVector(aVector: TEzVector);
var
  cnt: Integer;
  TmpBool: Boolean;
begin
  if not FCanGrow and (aVector.Count > FLast) then
    EzGISError(SVectorOutOfBound);
  TmpBool := FDisableEvents;
  FDisableEvents := True;
  try
    for cnt := 0 To aVector.Count - 1 do
      Put(FCount, aVector.Points[cnt]);
  finally
    FDisableEvents := TmpBool;
  end;
  if not FDisableEvents and Assigned(FOnChange) then
    FOnChange;
end;

Procedure TEzVector.Clear;
Begin
  FCount := 0;
  FParts.Count:= 0;
  If Not FDisableEvents And Assigned( FOnChange ) Then
    FOnChange;
End;

Procedure TEzVector.Delete( Index: Integer );
Var
  i, n, cnt, Idx1, Idx2: Integer;
  TmpList: TIntegerList;
Begin
  If (Index < 0) Or (Index >= FCount) Then
    EzGISError( SVectorOutOfBound );
  If FCount >= 2 Then
    For cnt := Index To FCount - 2 Do
      FPoints^[cnt] := FPoints^[cnt + 1];
  { reindex the parts }
  If FParts.Count > 1 Then
  Begin
    TmpList := TIntegerList.Create;
    Try
      n := 0;
      Idx1 := FParts[n];
      Idx2 := FParts[n + 1] - 1;
      Repeat
        For i := Idx1 To Idx2 Do
          TmpList.Add( n );
        Inc( n );
        If n >= FParts.Count Then Break;

        Idx1 := FParts[n];
        If n < FParts.Count - 1 Then
          Idx2 := FParts[n + 1] - 1
        Else
          Idx2 := FCount - 1;
      Until false;
      TmpList.Delete( Index );

      TmpList.Reindex;

      FParts.Count:= 0;
      If TmpList.Count = 0 Then Exit;

      FParts.Add( 0 );
      n := TmpList[0];
      I := 1;
      While I <= TmpList.Count - 1 Do
      Begin
        If n <> TmpList[I] Then
        Begin
          FParts.Add( I );
          n := TmpList[I];
        End;
        Inc( I );
      End;
      If FParts.Count < 2 Then
        FParts.Clear;
    Finally
      TmpList.Free;
    End;
  End;
  Dec( FCount );
  If Not FDisableEvents And Assigned( FOnChange ) Then
    FOnChange;
End;

Procedure TEzVector.Insert( Index: Integer; Const Item: TEzPoint );
Var
  I, n, Idx1, Idx2: Integer;
  TmpBool: Boolean;
  TmpInt: Integer;
  TmpList: TIntegerList;
Begin
  If ( Index < 0 ) Or ( Index >= FCount ) Then
    EzGISError( SVectorOutOfBound );
  TmpBool := FDisableEvents;
  FDisableEvents := True;
  Try
    { Reindex the parts first }
    If FParts.Count > 1 Then
    Begin
      TmpList := TIntegerList.Create;
      Try
        n := 0;
        Idx1 := FParts[n];
        Idx2 := FParts[n + 1] - 1;
        Repeat
          For i := Idx1 To Idx2 Do
            TmpList.Add( n );
          Inc( n );
          If n >= FParts.Count Then
            Break;
          Idx1 := FParts[n];
          If n < FParts.Count - 1 Then
            Idx2 := FParts[n + 1] - 1
          Else
            Idx2 := FCount - 1;
        Until False;
        { Insert on same part }
        i := Index - 1;
        If i < 0 Then
          i := 0;
        TmpInt := TmpList[i];
        TmpList.Insert( Index, TmpInt );

        TmpList.Reindex;

        FParts.Count:= 0;
        FParts.Add( 0 );
        n := TmpList[0];
        I := 1;
        While I <= TmpList.Count - 1 Do
        Begin
          If n <> TmpList[I] Then
          Begin
            FParts.Add( I );
            n := TmpList[I];
          End;
          Inc( I );
        End;
        If FParts.Count < 2 Then
          FParts.Clear;
      Finally
        TmpList.Free;
      End;
    End;

    { Now, make the space for the new item }
    Add( Item );
    { Insert the item }
    For I := FCount - 1 Downto Index + 1 Do
      FPoints^[I] := FPoints^[I - 1];
    FPoints^[Index] := Item;
  Finally
    FDisableEvents := TmpBool;
  End;
  If Not FDisableEvents And Assigned( FOnChange ) Then
    FOnChange;
End;

procedure OutOfResources;
begin
  raise EOutOfResources.Create(SOutOfResources);
end;

procedure GDIError;
var
  ErrorCode: Integer;
  Buf: array [Byte] of Char;
begin
  ErrorCode := GetLastError;
  if (ErrorCode <> 0) and (FormatMessage(FORMAT_MESSAGE_FROM_SYSTEM, nil,
    ErrorCode, LOCALE_USER_DEFAULT, Buf, sizeof(Buf), nil) <> 0) then
    raise EOutOfResources.Create(Buf)
  else
    OutOfResources;
end;

Function GDICheck( Value: Integer ): Integer;
Begin
  if Value = 0 then GDIError;
  Result := Value;
End;

Procedure TEzVector.DrawWithLineStyle( Canvas: TCanvas;
                                       Const Clip: TEzRect;
                                       Grapher: TEzGrapher;
                                       Const PenStyle: TEzPenStyle;
                                       const PenScale: Double;
                                       Const M: TEzMatrix;
                                       DrawMode: TEzDrawMode );
Var
  TmpPenStyle: TEzPenStyle;
  Style: Integer;
Begin
  If Ez_Linetypes.Count = 0 Then
    Exit;
  Style := PenStyle.Style - MAX_LINETYPES - 2;
  If Style >= Ez_Linetypes.Count - 1 Then
    Style := 0;
  TmpPenStyle := PenStyle;
  TmpPenStyle.Style := 1;
  Ez_Linetypes[Style].DrawVector( Self, TmpPenStyle, PenScale, Grapher, Canvas, Clip, M, DrawMode );
End;

Procedure TEzVector.DrawHatch( Canvas: TCanvas;
  Const Clip, Extent: TEzRect;
  Grapher: TEzGrapher;
  Const BrushStyle: TEzBrushStyle;
  Const M: TEzMatrix;
  DrawMode: TEzDrawMode );
Var
  hatch: Integer;
  Scale, Angle: Double;
  Color: TColor;
Begin
  If ( Ez_Hatches.Count = 0 ) Or Not ( DrawMode In [dmNormal, dmSelection] ) Then
    exit;
  hatch := BrushStyle.Pattern - 2;
  If hatch >= Pred(Ez_Hatches.Count) Then
    hatch := 0;
  If DrawMode = dmNormal Then
    Color := BrushStyle.Color
  Else
    Color := Ez_Preferences.SelectionBrush.Color;
  Scale := BrushStyle.Scale;
  Angle := BrushStyle.Angle;
  Ez_Hatches[hatch].DrawHatchTo( Self, Clip, Extent, Grapher, Canvas, Color, Scale, Angle, M );
End;

Procedure TEzVector.DrawClosed( Canvas: TCanvas;
  Const Clip, Extent: TEzRect; Grapher: TEzGrapher; Const PenStyle: TEzPenStyle;
  const PenScale: Double; Const BrushStyle: TEzBrushStyle; Const M: TEzMatrix;
  DrawMode: TEzDrawMode; Bitmap: TBitmap );
Var
  Idx1, Idx2, cnt, n: Integer;
  TmpPt1, TmpPt2: TEzPoint;
  ClipRes: TEzClipCodes;
  AStyle, APattern: Byte;
  //AScale: Double;
  //ALineColor,
  AForeColor, ABackColor: TColor;
  IsFullInside: Boolean;
  IsIdentMatrix: Boolean;
  DC: THandle;
  UsingTempBitmap: Boolean;
  Resname: String;
  OptimizerWasOn: Boolean;
  pointarr: PPointArray;
Begin
  If FCount < 3 Then
  Begin
    DrawOpened( Canvas, Clip, Extent, Grapher, PenStyle, PenScale, M, DrawMode );
    Exit;
  End;
  IsIdentMatrix := CompareMem( @M, @IDENTITY_MATRIX2D, SizeOf( TEzMatrix ) );
  n := 0;
  If FParts.Count < 2 Then
  Begin
    Idx1 := 0;
    Idx2 := FCount - 1;
  End
  Else
  Begin
    Idx1 := FParts[n];
    Idx2 := FParts[n + 1] - 1;
  End;

  // Get Polygon Memory
  OptimizerWasOn:= Grapher.FInOptimizer;
  If Not OptimizerWasOn then
  Begin
    Grapher.BeginOptimizer( FCount+4, FParts.Count+4 );
  End;
  Grapher.ClearOptimizer;

  Try
    Repeat
      If IsBoxFullInBox2D( Extent, Clip ) Then
      Begin
        If IsIdentMatrix Then
        Begin
          For cnt := Idx1 To Idx2 Do
            Grapher.FVisiblePoints.Add( FPoints^[cnt] );
        End
        Else
        Begin
          For cnt := Idx1 To Idx2 Do
            Grapher.FVisiblePoints.Add( TransformPoint2D( FPoints^[cnt], M ) );
        End;
        IsFullInside := True;
      End
      Else
      Begin
        IsFullInside := False;
        For cnt := Idx1 To Idx2 Do
        Begin
          If IsIdentMatrix Then
            TmpPt1 := FPoints^[cnt]
          Else
            TmpPt1 := TransformPoint2D( FPoints^[cnt], M );
          If cnt < Idx2 Then
          Begin
            If IsIdentMatrix Then
              TmpPt2 := FPoints^[cnt + 1]
            Else
              TmpPt2 := TransformPoint2D( FPoints^[cnt + 1], M )
          End
          Else
          Begin
            If IsIdentMatrix Then
              TmpPt2 := FPoints^[Idx1]
            Else
              TmpPt2 := TransformPoint2D( FPoints^[Idx1], M );
          End;
          ClipRes := ClipLineLeftRight2D( Clip, TmpPt1.X, TmpPt1.Y, TmpPt2.X, TmpPt2.Y );
          If Not ( ccNotVisible In ClipRes ) Then
          Begin
            Grapher.FFirstClipPts.Add( TmpPt1 );
          End;
          If ccSecond In ClipRes Then
          Begin
            Grapher.FFirstClipPts.Add( TmpPt2 );
          End;
        End;
        If Grapher.FFirstClipPts.Count > 0 Then
        Begin
          Grapher.FFirstClipPts.Add( Grapher.FFirstClipPts[0] );
          For cnt := 0 To Grapher.FFirstClipPts.Count - 2 Do
          Begin
            TmpPt1 := Grapher.FFirstClipPts[cnt];
            TmpPt2 := Grapher.FFirstClipPts[cnt + 1];
            ClipRes := ClipLineUpBottom2D( Clip, TmpPt1.X, TmpPt1.Y, TmpPt2.X, TmpPt2.Y );
            If Not ( ccNotVisible In ClipRes ) Then
            Begin
              Grapher.FVisiblePoints.Add( TmpPt1 );
            End;
            If ccSecond In ClipRes Then
            Begin
              Grapher.FVisiblePoints.Add( TmpPt2 );
            End;
          End;
        End;
      End;
      If Grapher.FVisiblePoints.Count > 1 Then
      Begin
        { Convert to device points }
        For cnt := 0 To Grapher.FVisiblePoints.Count - 1 Do
        Begin
          Grapher.FDevicePoints.Add( Grapher.RealToPoint( Grapher.FVisiblePoints[cnt] ) );
        End;
        { Grapher.FParts is used for storeing how many points in
          every part in Grapher.FVisiblePoints are visible }
        Grapher.FParts.Add( Grapher.FVisiblePoints.Count );
        Grapher.FIsFullInside[ Grapher.FParts.Count - 1 ] := IsFullInside;
      End;
      If FParts.Count < 2 Then Break;
      Inc( n );
      If n >= FParts.Count Then Break;

      Idx1 := FParts[n];
      If n < FParts.Count - 1 Then
        Idx2 := FParts[n + 1] - 1
      Else
        Idx2 := FCount - 1;

      Grapher.FVisiblePoints.Clear;
      Grapher.FFirstClipPts.Clear;

    Until False;

    if Grapher.FParts.Count = 0 then Exit;

    { Now draw the results - First the filling }
    AStyle := 1;
    APattern := 1;
    ABackColor:= clBlack;
    AForeColor := clBlack;
    Case DrawMode Of
      dmNormal:
        Begin
          With PenStyle Do
          Begin
            AStyle := Style;
            //ALineColor := Color;
            //AScale := Scale;
          End;
          With BrushStyle Do
          Begin
            APattern := Pattern;
            AForeColor := ForeColor; // it's the same as Color data
            ABackColor := BackColor;
          End;
        End;
      dmSelection:
        With Ez_Preferences Do
        Begin
          With SelectionPen.FPenStyle Do
          Begin
            AStyle := Style;
            //ALineColor := Color;
            //AScale := Scale;
          End;
          With SelectionBrush.FBrushStyle Do
          Begin
            APattern := Pattern;
            AForeColor := ForeColor;
            ABackColor := BackColor;
          End;
        End;
      dmRubberPen:
        Begin
          AStyle := 1;
          APattern := 1;
        End;
    End;

    Case DrawMode Of
      dmSelection, dmNormal:
        Begin
          Canvas.Pen.Style := psClear;
          UsingTempBitmap:= False;
          if ( DrawMode = dmSelection ) and ( Bitmap = nil ) and
             ( ABackColor = clNone ) and ( APattern in [2..89] ) and
             ( Grapher.Device = adScreen ) then
          begin
            Bitmap := TBitmap.Create;
            { load the resource bitmap }
            Resname := '#' + IntToStr( 98 + APattern );
            Bitmap.Handle := LoadBitmap( HInstance, PChar( Resname ) );
            UsingTempBitmap:= True;
          end;
          if ( Bitmap = nil ) and ( APattern = 1 ) and ( ABackColor = clNone ) then
          begin
            { build a temporary bitmap in order to show transparency with
              solid colors }
            Bitmap:= TBitmap.Create;
            Bitmap.Width:= 8;
            Bitmap.Height:= 8;
            Bitmap.PixelFormat:= pf1bit;
            Bitmap.Canvas.Brush.Color:= clBlack;
            Bitmap.Canvas.FillRect(Rect(0,0,8,8));
            UsingTempBitmap:= True;
          end;
          If Bitmap <> Nil Then
          Begin
{$IFDEF FALSE}
            If ( ( Bitmap.Width = 8 ) And
              ( Bitmap.Height = 8 ) And
              ( Bitmap.Monochrome ) And
              ( Grapher.Device = adScreen ) ) Or
              ( Grapher.Device = adPrinter ) Then
            Begin
{$ENDIF}
              //bo:= Grapher.RealToPoint(Self.GetExtension.Emin);
              //SetBrushOrgEx(Canvas.Handle,bo.X,bo.Y,@PrevPt);
              If Grapher.Device = adScreen Then
              Begin
                EzGraphics.PolygonScreenFill8X8Bitmap( Canvas,
                                                       Grapher,
                                                       Grapher.FDevicePoints.FPoints^,
                                                       PIntegerArray(Grapher.FParts.FList.List)^,
                                                       Grapher.FParts.Count,
                                                       Bitmap,
                                                       AForeColor,
                                                       ABackColor );
              End
              Else If PrintersInstalled Then
              Begin
                DC := GetDC( 0 );
                Try

                  EzGraphics.PolygonPrinterFill8X8Bitmap(
                    Canvas,
                    Grapher,
                    Grapher.FDevicePoints.FPoints^,
                    PIntegerArray(Grapher.FParts.FList.List)^,
                    Grapher.FParts.Count,
                    Bitmap,
                    AForeColor,
                    ABackColor,
                    GetDeviceCaps( Printer.Handle, LOGPIXELSX ) / GetDeviceCaps( DC, LOGPIXELSX ),
                    Ez_Preferences.PatternPlotterOptimized );

                Finally
                  ReleaseDC( 0, DC );
                End;
              End;
              //SetBrushOrgEx(Canvas.Handle,PrevPt.X,PrevPt.Y,nil);
              if UsingTempBitmap then
              begin
                Bitmap.Free;
              end;
{$IFDEF FALSE}
            End
            Else If ( DrawMode = dmNormal ) And ( Grapher.Device = adScreen ) Then
            Begin
              bo := Grapher.RealToPoint( Self.GetExtension.Emin );
              SetBrushOrgEx( Canvas.Handle, bo.X, bo.Y, @PrevPt );
              Bitmap.HandleType := bmDDB;
              lb.lbColor := AForeColor;
              lb.lbStyle := BS_PATTERN;
              lb.lbHatch := Longint( Bitmap.Handle );
              Canvas.Brush.Handle := CreateBrushIndirect( lb );
              oldFillMode := Windows.GetPolyFillMode( Canvas.Handle );
              oldBkMode := Windows.GetBkMode( Canvas.Handle );
              Try
                Windows.SetPolyFillMode( Canvas.Handle, Alternate );
                Windows.SetBkMode( Canvas.Handle, TRANSPARENT );

                If Grapher.FParts.Count = 1 Then
                  Polygon( Canvas.Handle, Grapher.FDevicePoints.FPoints^,
                                       Grapher.FParts[0] )
                Else
                Begin
                  if Win32Platform = VER_PLATFORM_WIN32_NT then
                  Begin
                    {WinNT or Win2000}
                    PolyPolygon( Canvas.Handle, Grapher.FDevicePoints.FPoints^,
                       Grapher.FParts.FList.List^, Grapher.FParts.Count );
                  End Else
                    { Win95 or Win98 have problems handling PolyPolygon with a lot of parts }

                  Begin
                  End;
                End;
              Finally
                Windows.SetBkMode( Canvas.Handle, oldBkMode );
                Windows.SetPolyFillMode( Canvas.Handle, oldFillMode );
                SetBrushOrgEx( Canvas.Handle, PrevPt.X, PrevPt.Y, Nil );
              End;
            End;
{$ENDIF}
          End
          Else
          Begin
            { solid fill pattern }
            If APattern = 1 Then
            Begin
              Canvas.Brush.Style := bsSolid;
              Canvas.Brush.Color := AForeColor;
              If Grapher.FParts.Count = 1 Then
                Polygon( Canvas.Handle, Grapher.FDevicePoints.FPoints^, Grapher.FParts[0] )
              Else
              Begin
                SetPolyFillMode( Canvas.Handle, Alternate );
                if Win32Platform = VER_PLATFORM_WIN32_NT then
                begin
                  { WinNT or Win2000 }
                  PolyPolygon( Canvas.Handle, Grapher.FDevicePoints.FPoints^,
                    Grapher.FParts.FList.List^, Grapher.FParts.Count );
                end else
                begin
                  { Win95 or Win98 - these have problems with a lot of entities and parts.
                    We don't know what the limit it is }
                  Idx1:= 0;
                  for cnt:= 0 to Grapher.FParts.Count-1 do
                  begin
                    pointarr := @Grapher.FDevicePoints.FPoints^[Idx1];
                    n := Grapher.FParts[cnt];
                    Polygon( Canvas.Handle, pointarr^, n );
                    Inc(Idx1, n );
                  end;
                end;
              End;
            //End
            //Else If ( APattern >= 2 ) And ( ( APattern - 2 ) <= Ez_Hatches.Count - 1 ) Then
            //Begin
              { a hatch pattern is drawed on .DrawHatch method }
            End;
          End;

          { follows the line drawing section }
          If AStyle = 0 Then
            Exit;
          If ( DrawMode <> dmRubberPen ) And ( AStyle > Succ(MAX_LINETYPES) ) Then
          Begin
            DrawWithLineStyle( Canvas, Clip, Grapher, PenStyle, PenScale, M, DrawMode );
            Exit;
          End;
          DrawOpened( Canvas, Clip, Extent, Grapher, PenStyle, PenScale, M, DrawMode );
{$IFDEF FALSE}
          Canvas.Brush.Style := bsClear;
          Canvas.Pen.Style := psSolid;
          if AStyle = 1 then
          begin
            If AScale = 0 Then
              Canvas.Pen.Width := 1
            Else
              Canvas.Pen.Width := IMax( 1, Grapher.RealToDistY( AScale ) );
            Canvas.Pen.Color := ALineColor;
            IsFullInside := True;
            For cnt := 0 To Grapher.FParts.Count - 1 Do
              If Not Grapher.FIsFullInside[cnt] Then
              Begin
                IsFullInside := False;
                Break;
              End;
            If IsFullInside Or ( Canvas.Pen.Width = 1 ) Then
            Begin
              If Grapher.FParts.Count = 1 Then
                Polygon( Canvas.Handle, Grapher.FDevicePoints.FPoints^, Grapher.FParts[0] )
              Else If Grapher.FParts.Count > 1 Then
              Begin
                if Win32Platform = VER_PLATFORM_WIN32_NT then
                begin
                  { WinXP, Win2000 or WinNT }
                  PolyPolygon( Canvas.Handle, Grapher.FDevicePoints.FPoints^,
                    Grapher.FParts.FList.List^, Grapher.FParts.Count );
                end else
                begin
                  { Win95 or Win98 }
                  Idx1:= 0;
                  for cnt:= 0 to Grapher.FParts.Count-1 do
                  begin
                    pointarr := @Grapher.FDevicePoints.FPoints^[Idx1];
                    n := Grapher.FParts[cnt];
                    Polygon( Canvas.Handle, pointarr^, n );
                    Inc(Idx1, n );
                  end;
                end;
              End;
            End
            Else
              clipLiangBarsky( Canvas, Clip, Grapher, M, Nil );
          end
          else
          if ( AStyle >= 2 ) and ( AStyle <= Succ(MAX_LINETYPES) ) then
          begin
            Canvas.Pen.Width:= 1;
            EzLineDraw.PolyDDA( Grapher.FDevicePoints.FPoints^,
              PIntegerArray(Grapher.FParts.FList.List)^, Grapher.FParts.Count,
              Canvas, Grapher, Pred(AStyle), ALineColor, 1 );
          end;
{$ENDIF}
        End;
      dmRubberPen:
        Begin
          //DrawOpened( Canvas, Clip, Extent, Grapher, PenStyle, M, DrawMode );
{.$IFDEF FALSE}
          If Grapher.FParts.Count = 1 Then
            Polygon( Canvas.Handle, Grapher.FDevicePoints.FPoints^, Grapher.FParts[0] )
          Else
          Begin
            //SetPolyFillMode(Canvas.Handle, Alternate);
            if Win32Platform = VER_PLATFORM_WIN32_NT then
            begin
              { WinNT or Win2000 }
              PolyPolygon( Canvas.Handle, Grapher.FDevicePoints.FPoints^,
                Grapher.FParts.FList.List^, Grapher.FParts.Count );
            end else
            begin
              { Win95 or Win98 }
              Idx1:= 0;
              for cnt:= 0 to Grapher.FParts.Count-1 do
              begin
                pointarr := @Grapher.FDevicePoints.FPoints^[Idx1];
                n := Grapher.FParts[cnt];
                Polygon( Canvas.Handle, pointarr^, n );
                Inc(Idx1, n );
              end;
            end;
          End;
{.$ENDIF}
        End;
    End;
  Finally
    // Free Optimizer memory
    If Not OptimizerWasOn then
    Begin
      Grapher.EndOptimizer;
    End;
  End;
End;

Procedure TEzVector.DrawOpened( Canvas: TCanvas;
                                Const Clip, Extent: TEzRect;
                                Grapher: TEzGrapher;
                                Const PenStyle: TEzPenStyle;
                                const PenScale: Double;
                                Const M: TEzMatrix;
                                DrawMode: TEzDrawMode );
Var
  cnt, n, Idx1, Idx2: Integer;
  TmpPt1, TmpPt2: TEzPoint;
  ClipRes: TEzClipCodes;
  IsIdentMatrix: Boolean;
  AWidth: Integer;
  OptimizerWasOn: Boolean;

  Procedure DrawPolyline;
  Var
    //AScale: Double;
    ALineColor: TColor;
    I: integer;
    Parts: Array[0..0] Of Integer;
  Begin
    If Grapher.FVisiblePoints.Count < 2 Then
    Begin
      Grapher.FVisiblePoints.Clear;
      Grapher.FDevicePoints.Clear;
      Exit;
    End;
    For I := 0 To Grapher.FVisiblePoints.Count - 1 Do
      Grapher.FDevicePoints.Add( Grapher.RealToPoint( Grapher.FVisiblePoints[I] ) );
    Case DrawMode Of
      dmSelection:
        With Ez_Preferences.SelectionPen.FPenStyle Do
        Begin
          ALineColor := Color;
          //AScale:= Scale;//Grapher.getrealsize(Scale);
        End;
      dmNormal:
        With PenStyle Do
        Begin
          ALineColor := Color;
          //AScale:= Scale;
        End;
    Else
      Begin
        ALineColor := clBlack;
        //AScale:= 0;
      End;
    End;
    If Not ( DrawMode = dmRubberPen ) Then
    Begin
      Canvas.Pen.Style := psSolid;
      Canvas.Pen.Color := ALineColor;
    End;
    Case DrawMode Of
      dmRubberPen:
        Begin
          Polyline( Canvas.Handle, Grapher.FDevicePoints.FPoints^, Grapher.FDevicePoints.Count );
        End;
      dmSelection, dmNormal:
        Begin
          if PenStyle.Style = 1 then
          begin
            Canvas.Pen.Width := AWidth;
            Polyline( Canvas.Handle, Grapher.FDevicePoints.FPoints^, Grapher.FDevicePoints.Count );
          end
          else
          if ( PenStyle.Style >= 2 ) and ( PenStyle.Style <= Succ(MAX_LINETYPES) ) then
          begin
            Canvas.Pen.Width:= 1;
            Parts[0]:= Grapher.FDevicePoints.Count;
            PolyDDA( Grapher.FDevicePoints.FPoints^, Parts, 1, Canvas, Grapher,
                     Pred(PenStyle.Style), ALineColor, 1 );

          end;
        End;
    End;
    Grapher.FVisiblePoints.Clear;
    Grapher.FDevicePoints.Clear;
  End;

Begin
  If (FCount < 2) Or ((DrawMode <> dmRubberPen) And (PenStyle.Style <= 0)) Then Exit;

  If (DrawMode <> dmRubberPen ) And (PenStyle.Style > Succ(MAX_LINETYPES)) Then
  Begin
    DrawWithLineStyle(Canvas, Clip, Grapher, PenStyle, PenScale, M, DrawMode);
    Exit;
  End;

  n := 0;
  If FParts.Count < 2 Then
  Begin
    Idx1 := 0;
    Idx2 := FCount - 1;
  End
  Else
  Begin
    Idx1 := FParts[n];
    Idx2 := FParts[n + 1] - 1;
  End;

  OptimizerWasOn:= Grapher.FInOptimizer;
  If Not OptimizerWasOn then
  Begin
    Grapher.BeginOptimizer( FCount+4, FParts.Count+4 );
  End;
  Grapher.ClearOptimizer;

  if PenStyle.Style = 1 then
    if PenStyle.Width < 0 then
      AWidth := IMax( 1, Round( Abs( PenStyle.Width ) ))
    else
      AWidth := IMax( 1, Grapher.RealToDistY( PenStyle.Width ) );

  Try
    IsIdentMatrix := CompareMem( @M, @IDENTITY_MATRIX2D, SizeOf( TEzMatrix ) );
    Repeat
      If IsBoxFullInBox2D( Extent, Clip ) Then
      Begin
        If IsIdentMatrix Then
        Begin
          For cnt := Idx1 To Idx2 Do
            Grapher.FVisiblePoints.Add( FPoints^[cnt] );
        End
        Else
        Begin
          For cnt := Idx1 To Idx2 Do
            Grapher.FVisiblePoints.Add( TransformPoint2D( FPoints^[cnt], M ) );
        End;
      End
      Else
      Begin
        For cnt := Idx1 + 1 To Idx2 Do
        Begin
          If IsIdentMatrix Then
          Begin
            TmpPt1 := FPoints^[cnt - 1];
            TmpPt2 := FPoints^[cnt];
          End
          Else
          Begin
            TmpPt1 := TransformPoint2D( FPoints^[cnt - 1], M );
            TmpPt2 := TransformPoint2D( FPoints^[cnt], M );
          End;
          ClipRes := ClipLine2D( Clip, TmpPt1.X, TmpPt1.Y, TmpPt2.X, TmpPt2.Y );
          If Not ( ccNotVisible In ClipRes ) Then
          Begin
            Grapher.FVisiblePoints.Add( TmpPt1 );
          End;
          If ccSecond In ClipRes Then
          Begin
            Grapher.FVisiblePoints.Add( TmpPt2 );

            DrawPolyline;
          End;
        End;
        If Not ( ccNotVisible In ClipRes ) Then
        Begin
          Grapher.FVisiblePoints.Add( TmpPt2 );
        End;
      End;
      If Grapher.FVisiblePoints.Count > 0 Then
        DrawPolyline;

      If FParts.Count < 2 Then Break;

      Inc( n );
      If n >= FParts.Count Then Break;

      Idx1 := FParts[n];
      If n < FParts.Count - 1 Then
        Idx2 := FParts[n + 1] - 1
      Else
        Idx2 := FCount - 1;

    Until false;
  Finally
    //Free Optimizer Memory
    If Not OptimizerWasOn then
    Begin
      Grapher.EndOptimizer;
    End;
  End;
End;

Procedure TEzVector.clipLiangBarsky( Canvas: TCanvas;
                                     Const clipArea: TEzRect;
                                     Grapher: TEzGrapher;
                                     Const Matrix: TEzMatrix;
                                     ResultVector: TEzVector );
Var
  i, n, Idx1, Idx2: integer;

  Procedure clipLine( p1, p2: TEzPoint );
  Var
    u1, u2, dx, dy: Double;
    dp1, dp2: TPoint;
    visible: boolean;

    Function clipTest( Const p, q: Double; Var u1, u2: Double ): boolean;
    Var
      r: Double;
    Begin
      result := true;
      If p < 0.0 Then
      Begin
        r := q / p;
        If r > u2 Then
          result := false
        Else If r > u1 Then
          u1 := r;
      End
      Else If p > 0.0 Then
      Begin
        r := q / p;
        If r < u1 Then
          result := false
        Else If r < u2 Then
          u2 := r;
      End
      Else If q < 0.0 Then
        result := false;
    End;

  Begin
    u1 := 0.0;
    u2 := 1.0;
    dx := p2.x - p1.x;
    visible := false;
    If clipTest( -dx, p1.x - clipArea.Emin.x, u1, u2 ) Then
      If clipTest( dx, clipArea.Emax.x - p1.x, u1, u2 ) Then
      Begin
        dy := p2.y - p1.y;
        If clipTest( -dy, p1.y - clipArea.Emin.y, u1, u2 ) Then
          If clipTest( dy, clipArea.Emax.y - p1.y, u1, u2 ) Then
          Begin
            If u1 > 0.0 Then
            Begin
              p1.x := p1.x + u1 * dx;
              p1.y := p1.y + u1 * dy;
            End;
            If u2 < 1.0 Then
            Begin
              p2.x := p1.x + u2 * dx;
              p2.y := p1.y + u2 * dy;
            End;
            visible := true;
          End;
      End;
    { if Canvas and Grapher are not nil then draw line from p1 to p2 }
    If visible Then
    Begin
      If ( Canvas <> Nil ) And ( Grapher <> Nil ) Then
      Begin
        dp1 := Grapher.RealToPoint( TransformPoint2D( p1, Matrix ) );
        dp2 := Grapher.RealToPoint( TransformPoint2D( p2, Matrix ) );
        Canvas.MoveTo( dp1.x, dp1.y );
        Canvas.LineTo( dp2.x, dp2.y );
      End;
      If ResultVector <> Nil Then
      Begin
        ResultVector.Parts.Add( ResultVector.Count );
        ResultVector.Add( p1 );
        ResultVector.Add( p2 );
      End;
    End;

  End;
Begin
  n := 0;
  If FParts.Count < 2 Then
  Begin
    Idx1 := 0;
    Idx2 := FCount - 1;
  End
  Else
  Begin
    Idx1 := FParts[n];
    Idx2 := FParts[n + 1] - 1;
  End;
  Repeat
    For i := Idx1 + 1 To Idx2 Do
      clipLine( FPoints^[i - 1], FPoints^[i] );
    If FParts.Count < 2 Then
      Break;
    Inc( n );
    If n >= FParts.Count Then
      Break;
    Idx1 := FParts[n];
    If n < FParts.Count - 1 Then
      Idx2 := FParts[n + 1] - 1
    Else
      Idx2 := FCount - 1;
  Until false;
  {if not EqualPoint2D(FPoints^[FCount - 1], FPoints^[0]) then
     clipLine( FPoints^[FCount - 1], FPoints^[0]); }
End;

Function TEzVector.CrossFrame( Const Frm: TEzRect; Const M: TEzMatrix ): Boolean;
Var
  cnt, n, Idx1, Idx2: Integer;
  TmpPt1, TmpPt2: TEzPoint;
  ClipRes: TEzClipCodes;
Begin
  Result := false;
  If FCount = 0 Then
    Exit;
  If IsBoxFullInBox2D( Self.Extension, Frm ) Then
    Result := true
  Else
  Begin
    n := 0;
    If FParts.Count < 2 Then
    Begin
      Idx1 := 0;
      Idx2 := FCount - 1;
    End
    Else
    Begin
      Idx1 := FParts[n];
      Idx2 := FParts[n + 1] - 1;
    End;
    Repeat
      For cnt := Idx1 + 1 To Idx2 Do
      Begin
        TmpPt1 := TransformPoint2D( FPoints^[cnt - 1], M );
        TmpPt2 := TransformPoint2D( FPoints^[cnt], M );
        ClipRes := ClipLine2D( Frm, TmpPt1.X, TmpPt1.Y, TmpPt2.X, TmpPt2.Y );
        If Not ( ccNotVisible In ClipRes ) Or ( ccSecond In ClipRes ) Then
        Begin
          Result := true;
          Exit;
        End;
      End;
      If FParts.Count < 2 Then
        Break;
      Inc( n );
      If n >= FParts.Count Then
        Break;
      Idx1 := FParts[n];
      If n < FParts.Count - 1 Then
        Idx2 := FParts[n + 1] - 1
      Else
        Idx2 := FCount - 1;
    Until false;
  End;
End;

(* If point P is on a line of Vector.Points a distance <= Aperture return:
   PICKED_NONE if point P is not on the line
   PICKED_POINT if point P is on the line
   Dist is the distance found and must be <= Aperture
   Taken from Graphics programming book*)

Function TEzVector.PointOnPolyLine2D( Idx1: Integer; Const P: TEzPoint; Var
  Dist: Double; Const Aperture: Double; Const T: TEzMatrix; Const MustClose: Boolean ): Integer;
Var
  TmpDist: Double;
  TmpPt1, TmpPt2: TEzPoint;
  I, Max: Integer;
Begin
  Result := PICKED_NONE;
  Ez_Preferences.GNumPoint := PICKED_NONE;
  TmpPt1 := TransformPoint2D( FPoints^[0], T );
  Dist := Aperture { * 2};
  If MustClose Then
    Max := FCount
  Else
    Max := FCount - 1;
  For I := 1 To Max Do
  Begin
    If I = FCount Then
      TmpPt2 := TransformPoint2D( FPoints^[0], T )
    Else
      TmpPt2 := TransformPoint2D( FPoints^[I], T );
    If PointLineDistance2D( P, TmpPt1, TmpPt2, TmpDist ) And ( TmpDist <= Dist ) Then
    Begin
      Result := PICKED_POINT;
      Dist := TmpDist;
      Ez_Preferences.GNumPoint := Idx1 + Pred( I );
    End;
    TmpPt1 := TmpPt2;
  End;
End;

{$IFDEF FALSE}

Function ccw( p0, p1, p2: TEzPoint ): INTEGER;
Var
  dx1, dx2, dy1, dy2: Double;
Begin
  dx1 := p1.x - p0.x;
  dy1 := p1.y - p0.y;
  dx2 := p2.x - p0.x;
  dy2 := p2.y - p0.y;
  If dx1 * dy2 > dy1 * dx2 Then
    Result := 1;
  If dx1 * dy2 < dy1 * dx2 Then
    Result := -1;
  If dx1 * dy2 = dy1 * dx2 Then
  Begin
    If ( dx1 * dx2 < 0 ) Or ( dy1 * dy2 < 0 ) Then
      Result := -1
    Else If ( dx1 * dx1 + dy1 * dy1 ) >= ( dx2 * dx2 + dy2 * dy2 ) Then
      Result := 0
    Else
      Result := 1;
  End
End;

Type
  TLineType = Record
    p1, p2: TEzPoint;
  End;

Function intersect( l1, l2: TLinetype ): BOOLEAN;
Var
  ccw11, ccw12, ccw21, ccw22: INTEGER;
Begin
  ccw11 := ccw( l1.p1, l1.p2, l2.p1 );
  ccw12 := ccw( l1.p1, l1.p2, l2.p2 );
  ccw21 := ccw( l2.p1, l2.p2, l1.p1 );
  ccw22 := ccw( l2.p1, l2.p2, l1.p2 );
  Result := ( ( ccw11 * ccw12 < 0 ) And ( ccw21 * ccw22 < 0 ) ) Or
    ( ccw11 * ccw12 * ccw21 * ccw22 = 0 );
End;
{$ENDIF}

Function TEzVector.PointInPolygon2D( Const P: TEzPoint; Var Dist: Double;
  Const Aperture: Double; Const T: TEzMatrix ): Integer;
Var
  I, J, Idx1, Idx2, n, np: Integer;
  p1_i, p1_j: TEzPoint;
  IsInside: Boolean;
Begin
  Result := PICKED_NONE;
  Dist := Aperture * 2;
  np := FParts.Count;
  n := 0;
  If np < 2 Then
  Begin
    Idx1 := 0;
    Idx2 := FCount - 1;
  End
  Else
  Begin
    Idx1 := FParts[n];
    Idx2 := FParts[n + 1] - 1;
  End;
  Repeat
    IsInside := false;
    J := Idx2;
    For I := Idx1 To Idx2 Do
    Begin
      p1_i := TransformPoint2D( FPoints^[I], T );
      p1_j := TransformPoint2D( FPoints^[J], T );
      If   (
             (
               (p1_i.y <= p.y)
               and
               (p.y < p1_j.y)
             )
             or
             (
               (p1_j.y <= p.y)
               and
               (p.y < p1_i.y)
             )
           )
           and
           (p.x < (p1_j.x - p1_i.x) * (p.y - p1_i.y) / (p1_j.y - p1_i.y) + p1_i.x)
      Then
        IsInside := Not IsInside;
      J := I;
    End;
    { is this part inside ?}
    If ( np < 2 ) Or IsInside Then Break;

    Inc( n );
    If n >= np Then Break;

    Idx1 := FParts[n];
    If n < np - 1 Then
      Idx2 := FParts[n + 1] - 1
    Else
      Idx2 := FCount - 1;
  Until false;
  If IsInside Then
  Begin
    Dist := Aperture;
    Result := PICKED_INTERIOR;
  End;
End;

Procedure TEzVector.RevertDirection;
Var
  K: Integer;
  TmpParts: PIntegerArray;
  TmpPts: PEzPointArray;
  PartSize, TmpSize: Integer;
Begin
  TmpSize := ( FCount + 4 ) * sizeof( TEzPoint );
  PartSize := ( FParts.Count + 2 ) * sizeof( Integer );
  GetMem( TmpPts, TmpSize );
  Getmem( TmpParts, PartSize );
  Try
    For K := 0 To FCount - 1 Do
      TmpPts^[K] := FPoints^[K];
    For K := 0 To FCount - 1 Do
      FPoints^[K] := TmpPts^[FCount - K - 1];
    If FParts.Count > 1 Then
    Begin
      For K := 0 To FParts.Count - 1 Do
        TmpParts[K] := FParts[K];
      For K := 1 To FParts.Count - 1 Do
        FParts[K] := ( FCount - 1 ) - TmpParts[FParts.Count - K];
    End;
  Finally
    FreeMem( TmpPts, TmpSize );
    Freemem( TmpParts, PartSize );
  End;
End;

Function TEzVector.IsEqualTo( Vector: TEzVector ): Boolean;
Var
  I: Integer;
Begin
  Result := False;
  If FParts.Count <> Vector.Parts.Count Then Exit;
  For I := 0 To FParts.Count - 1 Do
    If FParts[I] <> Vector.FParts[I] Then Exit;
  If FCount <> Vector.Count Then Exit;
  For I := 0 To FCount - 1 Do
    If Not EqualPoint2D( FPoints^[I], Vector.FPoints^[I] ) Then Exit;
  Result := True;
End;


{ This method takes a vector as a parameter and split it in n parts
  every parts is the same distance, then populate this vector with the calculus
  - It is specially for splines.
  - Only works for single-part vector (not multi-part)
  - It is supposed only for not closed vector
  - if IndexList <> Nil then in IndexList place the index in the list of the point found
}

procedure TEzVector.SplitEquidistant(const Source: TEzVector; NumSegs: Integer;
  IndexList: TIntegerList; WidthList: TEzDoubleList);
Var
  Traveled, ThisSegmentLen: Double;
  p, p1, p2: TEzPoint;
  Ang: Double;
  PivotIndex, WListIndex: Integer;
  PivotDistance, PartLen, TotalLen: Double;
begin
  TotalLen:= ezsystem.Perimeter( Source, false );
  if (TotalLen = 0) or (NumSegs = 0) or (Source.Count < 2) or
     (Source.Parts.Count > 1) or ( (WidthList <> Nil) and (WidthList.Count = 0) ) then Exit;

  if WidthList = Nil then
    PartLen := TotalLen / NumSegs
  else
    PartLen := WidthList[0];
  if PartLen = 0 then Exit;

  Clear;
  if IndexList <> Nil then
    IndexList.Clear;

  Self.Add( Source.Points[0]);
  if IndexList <> Nil then
    IndexList.Add( 0 );

  PivotDistance := PartLen;
  PivotIndex := 0;
  Traveled := 0;
  WListIndex:= 0;

  ThisSegmentLen := Dist2D( Source.FPoints^[PivotIndex], Source.FPoints^[PivotIndex+1] );

  repeat

    If Traveled + ThisSegmentLen < PivotDistance Then
    begin
      Repeat
        Traveled := Traveled + ThisSegmentLen;
        Inc( PivotIndex );
        if PivotIndex >= Source.Count - 1 then Break;
        ThisSegmentLen := Dist2D( Source.FPoints^[PivotIndex], Source.FPoints^[PivotIndex + 1] );
        if not EqualPoint2d( Source.Points[PivotIndex], FPoints^[FCount-1]) then
          Self.Add( Source.Points[PivotIndex]);
      Until Traveled + ThisSegmentLen >= PivotDistance;
    end;
    if PivotIndex >= Source.Count - 1 then Break;
    p1 := Source.FPoints^[PivotIndex];
    p2 := Source.FPoints^[PivotIndex+1];
    P := p1;
    If p1.X = p2.X Then
    Begin
      // es una linea vertical
      If p1.Y < p2.Y Then
        P.Y := P.Y + ( PivotDistance - Traveled )
      Else
        P.Y := P.Y - ( PivotDistance - Traveled );
    End
    Else If p1.Y = p2.Y Then
    Begin
      // es una linea horizontal
      If p1.X < p2.X Then
        P.X := P.X + ( PivotDistance - Traveled )
      Else
        P.X := P.X - ( PivotDistance - Traveled );
    End
    Else
    Begin
      Ang := Angle2D( P1, P2 );
      P.X := P.X + ( PivotDistance - Traveled ) * Cos( Ang );
      P.Y := P.Y + ( PivotDistance - Traveled ) * Sin( Ang );
    End;

    Self.Add( P );
    if IndexList <> Nil then
      IndexList.Add(Self.FCount-1);

    if WidthList <> Nil then
    begin
      Inc(WListIndex);
      if WListIndex > WidthList.Count-1 then Break;
      PartLen:= WidthList[WListIndex];
    end;

    PivotDistance := PivotDistance + PartLen;

  until PivotDistance >= TotalLen;
  if not EqualPoint2D( FPoints^[FCount-1], Source.FPoints^[Source.FCount-1]) then
    Self.Add( Source.FPoints^[Source.FCount-1] );
end;

{ Determines the points that is apart a given Distance from startpoint
  until the given distance is reached.
  returns in P the point where the distance was found
  and in Index1, Index2 the segment where indices in points array the distance
  was found.
  It is supposed that StartPoint<>FPoints^[FCount-1] }

Function TEzVector.TravelDistance( Const Distance: Double;
                                   Var p: TEzPoint;
                                   Var Index1, Index2: Integer ): Boolean;
Var
  Traveled, D: Double;
  K: Integer;
  p1, p2: TEzPoint;
  Ang: Double;
  Idx1, Idx2, n, np: Integer;
Begin
  { Supports multi-part points }
  Result := FALSE;
  If FCount < 2 Then Exit;
  np := FParts.Count;
  n := 0;
  If np < 2 Then
  Begin
    Idx1 := 0;
    Idx2 := FCount - 1;
  End
  Else
  Begin
    Idx1 := FParts[n];
    Idx2 := FParts[n + 1] - 1;
  End;

  Index1 := Idx1;
  Index2 := Idx1 + 1;
  If Distance = 0 Then
  Begin
    p := FPoints^[Idx1];
    Result := True;
    exit;
  End;

  D := Dist2D( FPoints^[Index1], FPoints^[Index2] );
  Traveled := 0;
  If D > Distance Then
    K := Index1
  Else
    K := Index1 + 1;
  If Traveled + D < Distance Then
    Repeat
      If K >= Idx2 Then
      Begin
        If np < 2 Then
          Break;
        Inc( n );
        If n >= np Then
          Break;
        K := FParts[n];
        If n < np - 1 Then
          Idx2 := FParts[n + 1] - 1
        Else
          Idx2 := FCount - 1;
      End;
      Traveled := Traveled + D;
      D := Dist2D( FPoints^[K], FPoints^[K + 1] );
      If Traveled + D >= Distance Then
        break;
      Inc( K );
    Until false;

  If K >= Idx2 Then
  Begin
    { necesito prolongar la ultima coordenada una dada distancia }
    p1 := FPoints^[Idx2 - 1];
    Index1 := Idx2 - 1;
    p2 := FPoints^[Idx2];
    Index2 := Idx2;
  End
  Else
  Begin
    p1 := FPoints^[K];
    Index1 := K;
    p2 := FPoints^[K + 1];
    Index2 := K + 1;
  End;
  P := p1;
  If p1.X = p2.X Then
  Begin
    // es una linea vertical
    If p1.Y < p2.Y Then
      P.Y := P.Y + ( Distance - Traveled )
    Else
      P.Y := P.Y - ( Distance - Traveled );
  End
  Else If p1.Y = p2.Y Then
  Begin
    // es una linea horizontal
    If p1.X < p2.X Then
      P.X := P.X + ( Distance - Traveled )
    Else
      P.X := P.X - ( Distance - Traveled );
  End
  Else
  Begin
    Ang := Angle2D( P1, P2 );
    P.X := P.X + ( Distance - Traveled ) * Cos( Ang );
    P.Y := P.Y + ( Distance - Traveled ) * Sin( Ang );
  End;
  result := TRUE;
End;

function TEzVector.GetAsString: String;
var
  n, np, Idx1, Idx2, cnt: Integer;
  f1, f2: string;
  TempDecimalSeparator: Char;
begin
  np := FParts.Count;
  n := 0;
  If np < 2 Then
  Begin
    Idx1 := 0;
    Idx2 := FCount - 1;
  End
  Else
  Begin
    Idx1 := FParts[n];
    Idx2 := FParts[n + 1] - 1;
  End;
  TempDecimalSeparator:= DecimalSeparator;
  DecimalSeparator:='.';
  Repeat
    For cnt := Idx1 To Idx2 Do
    Begin
      f1:= FloatToStr(FPoints^[cnt].X);
      f2:= FloatToStr(FPoints^[cnt].Y);
      Result:= Result + Format('( %s, %s )', [f1, f2]);
      if cnt < Idx2 then
         Result:= Result + ' ,' + CrLf;
    End;
    If np < 2 Then Break;
    Inc( n );
    If n >= np Then Break;
    Result:= Result + ' ;' + CrLf + CrLf;
    Idx1 := FParts[n];
    If n < np - 1 Then
      Idx2 := FParts[n + 1] - 1
    Else
      Idx2 := FCount - 1;
  Until False;
  DecimalSeparator:= TempDecimalSeparator;
end;

procedure TEzVector.SetAsString(const Value: string);
var
  lexer: TCustomLexer;
  parser: TCustomParser;
  outputStream: TMemoryStream;
  errorStream: TMemoryStream;
  stream: TMemoryStream;
  ErrLine, ErrCol: Integer;
  s, ErrMsg, Errtxt: String;
  Expression: TExpression;
begin
  if Length(Value) = 0 then Exit;
  s:= Value;
  if AnsiPos('VECTOR', UpperCase(s)) = 0 then
    s:= 'VECTOR ( [ ' + s + ' ] )';
  stream := TMemoryStream.create;
  stream.write( s[1], Length( s ) );
  stream.seek( 0, 0 );
  outputStream := TMemoryStream.create;
  errorStream := TMemoryStream.create;
  lexer := TExprLexer.Create;
  lexer.yyinput := Stream;
  lexer.yyoutput := outputStream;
  lexer.yyerrorfile := errorStream;
  parser := TExprParser.Create( Nil );
  // link to the identifier function
  //TExprParser( parser ).OnIdentifierFunction := IDFunc;
  parser.yyLexer := lexer; // lexer and parser linked
  Try
    If parser.yyparse = 1 Then
    Begin
      ErrLine := lexer.yylineno;
      ErrCol := lexer.yycolno - lexer.yytextLen - 1;
      ErrMsg := parser.yyerrormsg;
      lexer.GetyyText( ErrTxt );
      Raise EExpression.CreateFmt( SExprParserError, [ErrMsg, ErrLine, ErrCol, ErrTxt] );
    End;
    Expression := TExprParser( parser ).GetExpression;
    if ( Expression is TEzVectorExpr ) and
       Not Self.IsEqualTo( TEzVectorExpr( Expression ).Vector ) then
    begin
      Self.Assign( TEzVectorExpr( Expression ).Vector );
    end;
    Expression.Free;
  Finally
    stream.free;
    lexer.free;
    parser.free;
    outputstream.free;
    errorstream.free;
  End;
end;


{ TEzPointList class implementation a list of Windows.TPoint }

Constructor TEzPointList.Create( Size: Integer );
Begin
  Inherited Create;
  FCount := 0;
  FLast := Size;
  GetMem( FPoints, Size * SizeOf( TPoint ) );
  FCanGrow := True;
End;

Destructor TEzPointList.Destroy;
Begin
  FreeMem( FPoints, FLast * SizeOf( TPoint ) );
  Inherited Destroy;
End;

Procedure TEzPointList.SetCapacity( Value: Integer );
Begin
  If FLast >= Value Then Exit;
  FLast := Value;
  If FPoints = Nil Then
    GetMem( FPoints, FLast * SizeOf( TPoint ) )
  Else
    ReAllocMem( FPoints, FLast * SizeOf( TPoint ) );
End;

Function TEzPointList.Get( Index: Integer ): TPoint;
Begin
  If Index < FCount Then
    Result := FPoints^[Index]
  Else
    EzGISError( SVectorOutOfBound );
End;

function TEzPointList.GetPoints2D(Index: Integer): TEzPoint;
begin
  Result.x := Points[Index].X;
  Result.y := Points[Index].Y;
end;

Procedure TEzPointList.Put( Index: Integer; Const Item: TPoint );
Begin
  If Index < FLast Then
  Begin
    FPoints^[Index] := Item;
    If Index >= FCount Then
      FCount := Index + 1;
  End
  Else If FCanGrow Then
  Begin
    { Resize the vector }
    ReAllocMem( FPoints, ( Index + 1 ) * SizeOf( TPoint ) );
    FPoints^[Index] := Item;
    FCount := Index + 1;
    FLast := FCount;
  End
  Else
    EzGISError( SVectorOutOfBound );
End;

Procedure TEzPointList.Add( Const Item: TPoint );
Begin
  Put( FCount, Item );
End;

Procedure TEzPointList.AddPoint( AX, AY: Integer );
Begin
  Put( FCount, Point( AX, AY ) );
End;

Function TEzPointList.GetX( Index: Integer ): Integer;
Begin
  Result := 0;
  If Index < FCount Then
    Result := FPoints^[Index].X
  Else
    EzGISError( SVectorOutOfBound );
End;

Function TEzPointList.IsEqual(Index1, Index2: Integer): Boolean;
begin
  Result:= CompareMem(@FPoints^[Index1], @FPoints^[Index2], SizeOf(TPoint));
end;

Function TEzPointList.GetY( Index: Integer ): Integer;
Begin
  Result := 0;
  If Index < FCount Then
    Result := FPoints^[Index].Y
  Else
    EzGISError( SVectorOutOfBound );
End;

Procedure TEzPointList.PutX( Index: Integer; Value: Integer );
Var
  Item: TPoint;
Begin
  Item := Get( Index );
  Item.X := Value;
  Put( Index, Item );
End;

Procedure TEzPointList.PutY( Index: Integer; Value: Integer );
Var
  Item: TPoint;
Begin
  Item := Get( Index );
  Item.Y := Value;
  Put( Index, Item );
End;

Procedure TEzPointList.Clear;
Begin
  FCount := 0;
End;

Procedure TEzPointList.Delete( Index: Integer );
Var
  cnt: Integer;
Begin
  If Index >= FCount Then
    EzGISError( SVectorOutOfBound );
  If FCount >= 2 Then
    For cnt := Index To FCount - 2 Do
      FPoints^[cnt] := FPoints^[cnt + 1];
  Dec( FCount );
End;

Procedure TEzPointList.Insert( Index: Integer; const Item: TPoint );
Var
  I: Integer;
Begin
  If ( Index < 0 ) Or ( Index >= FCount ) Then
    EzGISError( SVectorOutOfBound );
  { Now, make the space for the new item }
  Add( Item );
  { Insert the item }
  For I := FCount - 1 Downto Index + 1 Do
    FPoints^[I] := FPoints^[I - 1];
  FPoints^[Index] := Item;
End;


{ TEzCanvasRegionStacker }

Procedure TEzCanvasRegionStacker.PopAll( Canvas: TCanvas );
Var
  I: Integer;
Begin
  If FCount > 0 Then
  Begin
    SelectClipRgn( Canvas.Handle, 0 );
    For I := 1 To FCount Do
      DeleteObject( FRegions[I] );
    FCount := 0;
    FCanvas := Nil;
  End;
End;

Procedure TEzCanvasRegionStacker.Pop( Canvas: TCanvas );
Var
  Rgn: HRgn;
Begin
  If FCount <= 0 Then Exit;
  If FCanvas <> Canvas Then
    Raise Exception.Create( 'Pop: Wrong canvas in stacked regions' );
  Rgn := FRegions[FCount];
  FRegions[FCount] := 0;
  Dec( FCount );
  If FCount = 0 Then
  Begin
    SelectClipRgn( Canvas.Handle, 0 );
    DeleteObject( Rgn );
  End
  Else
  Begin
    SelectClipRgn( Canvas.Handle, FRegions[FCount] );
    DeleteObject( Rgn );
  End;
End;

Procedure TEzCanvasRegionStacker.Push( Canvas: TCanvas; Rgn: HRgn );
Begin
  // quitarlo despues esto
  If ( FCount > 0 ) And ( FCanvas <> Canvas ) Then
    Raise Exception.Create( 'Push: Wrong canvas in stacked regions' );
  FCanvas := Canvas;
  Inc( FCount );
  FRegions[FCount] := Rgn;
  SelectClipRgn( Canvas.Handle, Rgn );
End;

{TEzGrapher -- class implementation}

Constructor TEzGrapher.Create( MaxHistoryCount: Integer; ADevice: TEzActiveDevice );
Var
  DC: THandle;
Begin
  Inherited Create;

  FMaxHistoryCount := MaxHistoryCount;
  Device := ADevice;

  DC := GetDC( 0 );
  ScreenDpiX := GetDeviceCaps( DC, LOGPIXELSX );
  ScreenDpiY := GetDeviceCaps( DC, LOGPIXELSY );
  ReleaseDC( 0, DC );
  if ADevice = adPrinter then
  begin
    If PrintersInstalled Then
    Begin
      Try
        PrinterDpiX := GetDeviceCaps( Printer.Handle, LOGPIXELSX );
        PrinterDpiY := GetDeviceCaps( Printer.Handle, LOGPIXELSY );
      Except
        PrinterDpiX := 300;
        PrinterDpiY := 300;
      End;
    End
    else
    begin
      PrinterDpiX := Screen.PixelsPerInch;
      PrinterDpiY := Screen.PixelsPerInch;
    end;
  End;

  FHistoryList := TList.Create;
  FCanvasRegionStacker := TEzCanvasRegionStacker.Create;
End;

Destructor TEzGrapher.Destroy;
Begin
  Clear;
  FHistoryList.Free;
  FCanvasRegionStacker.Free;
  EndOptimizer;
  Inherited Destroy;
End;

Procedure TEzGrapher.Assign( Source: TEzGrapher );
begin
  ScreenDpiX:= Source.ScreenDpiX;
  ScreenDpiY:= Source.ScreenDpiY;
  PrinterDpiX:= Source.PrinterDpiX;
  PrinterDpiY:= Source.PrinterDpiY;
  OriginalParams:= Source.OriginalParams;
  CurrentParams:= Source.CurrentParams;
  FViewPortRect:= Source.FViewPortRect;
  FDevice:= Source.FDevice;
end;

Function TEzGrapher.DpiX: Integer;
Begin
  Case Device Of
    adScreen: result := ScreenDpiX;
    adPrinter: result := PrinterDpiX;
  Else
    result := ScreenDpiX;
  End;
End;

Function TEzGrapher.DpiY: Integer;
Begin
  Case Device Of
    adScreen: result := ScreenDpiY;
    adPrinter: result := PrinterDpiY;
  Else
    result := ScreenDpiY;
  End;
End;

Procedure TEzGrapher.Zoom( Const Factor: Double );
Var
  TmpX, TmpY: Double;
Begin
  If Factor <= 0 Then Exit;
  If Not FInUpdate Then Push; {save current view}
  With CurrentParams, CurrentParams.VisualWindow Do
  Begin
    MidPoint.X := ( Emin.X + Emax.X ) / 2;
    MidPoint.Y := ( Emin.Y + Emax.Y ) / 2;
    TmpX := ( Emax.X - Emin.X ) * XScale;
    TmpY := ( Emax.Y - Emin.Y ) * YScale;
    XScale := XScale / Factor;
    YScale := YScale / Factor;
    Emax.X := MidPoint.X + ( TmpX / XScale ) / 2;
    Emin.X := MidPoint.X - ( TmpX / XScale ) / 2;
    Emax.Y := MidPoint.Y + ( TmpY / YScale ) / 2;
    Emin.Y := MidPoint.Y - ( TmpY / YScale ) / 2;
  End;
  If Assigned( FOnChange ) Then
    FOnChange( Self );
End;

Procedure TEzGrapher.ReCentre( Const MX, MY: Double );
Var
  TmpX, TmpY: Double;
Begin
  If Not FInUpdate Then Push; {save current view}
  With CurrentParams Do
  Begin
    MidPoint.X := MX;
    MidPoint.Y := MY;
    With VisualWindow Do
    Begin
      TmpX := ( Emax.X - Emin.X ) * XScale;
      TmpY := ( Emax.Y - Emin.Y ) * YScale;
      Emin.X := MidPoint.X - ( TmpX / XScale ) / 2;
      Emax.X := MidPoint.X + ( TmpX / XScale ) / 2;
      Emin.Y := MidPoint.Y - ( TmpY / YScale ) / 2;
      Emax.Y := MidPoint.Y + ( TmpY / YScale ) / 2;
    End;
  End;
  If Assigned( FOnChange ) Then
    FOnChange( Self );
End;

Procedure TEzGrapher.SetViewPort( Const ALeft, ATop, ARight, ABottom: Double );
Begin
  With FViewPortRect Do
  Begin
    X1 := ALeft;
    Y2 := ATop;
    X2 := ARight;
    Y1 := ABottom;
  End;
End;

Procedure TEzGrapher.Window( Const Xi, Xf, Yi, Yf: Double );
Var
  TmpW, TmpH: Double;
  TmpParams: TEzTransformParams;
Begin
  TmpParams := OriginalParams;
  Try
    With OriginalParams Do
    Begin
      TmpW := Abs( FViewPortRect.X2 - FViewPortRect.X1 );
      TmpH := Abs( FViewPortRect.Y1 - FViewPortRect.Y2 );
      If ( Xf - Xi ) <> 0 Then
        XScale := TmpW / Abs( Xf - Xi )
      Else
        XScale := 1;
      If ( Yf - Yi ) <> 0 Then
        YScale := TmpH / Abs( Yf - Yi )
      Else
        YScale := 1;
      If XScale < YScale Then
        YScale := XScale
      Else
        XScale := YScale;
      If ( XScale = 0 ) Or ( YScale = 0 ) Then Exit;
      MidPoint.X := ( Xf + Xi ) / 2;
      MidPoint.Y := ( Yf + Yi ) / 2;
      With VisualWindow Do
      Begin
        Emin.X := MidPoint.X - ( TmpW / 2 ) / XScale;
        Emax.X := MidPoint.X + ( TmpW / 2 ) / XScale;
        Emin.Y := MidPoint.Y - ( TmpH / 2 ) / YScale;
        Emax.Y := MidPoint.Y + ( TmpH / 2 ) / YScale;
      End;
    End;
  Except
    OriginalParams := TmpParams;
    Raise;
  End;
  CurrentParams := OriginalParams;
  If Assigned( FOnChange ) Then
    FOnChange( Self );
End;

Procedure TEzGrapher.SetWindow( Const Xi, Xf, Yi, Yf: Double );
Begin
  Window( Xi, Xf, Yi, Yf );
  Clear;
End;

(*procedure TEzGrapher.ResetWindow(const Xi, Xf, Yi, Yf: Double);
begin
  Window(Xi, Xf, Yi, Yf);
end;*)

Procedure TEzGrapher.SetViewTo( Const ViewWin: TEzRect );
Var
  f1, f2, Dx, Dy, Hx, Hy, Factor: Double;
  TmpWin: TEzRect;
  OldWin: TEzRect;
  NewWin: TEzRect;
  NewHx, NewHy: Double;
  NewMidPoint: TEzPoint;
Begin
  TmpWin := ReOrderRect2D( ViewWin );

  If EqualRect2d(TmpWin,NULL_EXTENSION) or EqualRect2d(TmpWin,NULL_EXTENSION) then
    TmpWin:= DEFAULT_EXTENSION;

  If EqualRect2D( TmpWin, CurrentParams.VisualWindow ) Then
  Begin
    If Assigned( FOnChange ) Then
      FOnChange( Self );
    Exit;
  End;

  If Not FInUpdate Then Push;

  Dx := TmpWin.X2 - TmpWin.X1; 
  Dy := TmpWin.Y2 - TmpWin.Y1;
  OldWin := CurrentParams.VisualWindow;
  Hx := Abs( OldWin.Emax.X - OldWin.Emin.X );
  Hy := Abs( OldWin.Emax.Y - OldWin.Emin.Y );
  f1 := Dx / Hx;
  f2 := Dy / Hy;
  If f1 > f2 Then
    Factor := f1
  Else
    Factor := f2;
  NewWin := CurrentParams.VisualWindow;
  NewWin.Emin.X := TmpWin.X1 - ( Hx * Factor - Dx ) / 2;
  NewWin.Emax.Y := TmpWin.Y2;
  NewWin.Emax.Y := TmpWin.Y2 + ( Hy * Factor - Dy ) / 2;
  NewWin.Emax.X := NewWin.Emin.X + Hx * Factor;
  NewWin.Emin.Y := NewWin.Emax.Y - Hy * Factor;
  NewMidPoint.X := ( NewWin.Emin.X + NewWin.Emax.X ) / 2;
  NewMidPoint.Y := ( NewWin.Emin.Y + NewWin.Emax.Y ) / 2;
  //
  NewHx := NewWin.Emax.X - NewWin.Emin.X;
  NewHy := NewWin.Emax.Y - NewWin.Emin.Y;
  //
  CurrentParams.MidPoint := NewMidPoint;
  CurrentParams.VisualWindow := NewWin;
  CurrentParams.Xscale := CurrentParams.Xscale / Factor;
  CurrentParams.Yscale := CurrentParams.Yscale / Factor;
  //
//  With CurrentParams.VisualWindow Do
//  Begin
//    Hx := Abs( Emax.X - Emin.X );
//    Hy := Abs( Emax.Y - Emin.Y );
//    f1 := Dx / Hx;
//    f2 := Dy / Hy;
//    If f1 > f2 Then
//      Factor := f1
//    Else
//      Factor := f2;
//    Emin.X := TmpWin.X1 - ( Hx * Factor - Dx ) / 2;
//    Emax.Y := TmpWin.Y2;
//    Emax.X := Emin.X + Hx * Factor;
//    Emin.Y := Emax.Y - Hy * Factor;
//    With CurrentParams Do
//    Begin
//      MidPoint.X := ( Emin.X + Emax.X ) / 2;
//      MidPoint.Y := ( Emin.Y + Emax.Y ) / 2;
//      Xscale := Xscale / Factor;
//      Yscale := Yscale / Factor;
//    End;
//  End;
  If Assigned( FOnChange ) Then
    FOnChange( Self );
End;

Function TEzGrapher.PointToReal( Const P: TPoint ): TEzPoint;
Begin
  With CurrentParams.VisualWindow Do
  Begin
    Result.X := Emin.X + ( P.X - FViewPortRect.X1 ) / CurrentParams.XScale;
    Result.Y := Emax.Y - ( P.Y - FViewPortRect.Y2 ) / CurrentParams.YScale;
  End;
End;

Function TEzGrapher.RealToPoint( Const P: TEzPoint ): TPoint;
Begin
  With CurrentParams.VisualWindow Do
  Begin
    Result.X := Round( FViewPortRect.X1 + ( P.X - Emin.X ) * CurrentParams.XScale );
    Result.Y := Round( FViewPortRect.Y2 + ( Emax.Y - P.Y ) * CurrentParams.YScale );
  End;
End;

Function TEzGrapher.RectToReal( Const ARect: TRect ): TEzRect;
Begin
  Result.Emin := Self.PointToReal( ARect.TopLeft );
  Result.Emax := Self.PointToReal( ARect.BottomRight );
  Result := ReorderRect2D( Result );
End;

Function TEzGrapher.RealToRect( Const ARect: TEzRect ): TRect;
Var
  TmpPt1, TmpPt2: TPoint;
  Work: TEzRect;
Begin
  Work := ReorderRect2D( ARect );
  TmpPt1 := RealToPoint( Work.Emin );
  TmpPt2 := RealToPoint( Work.Emax );
  Result.Left := TmpPt1.X;
  Result.Top := TmpPt2.Y;
  Result.Right := TmpPt2.X;
  Result.Bottom := TmpPt1.Y;
End;

Function TEzGrapher.DistToRealX( DistX: Integer ): Double;
Begin
  With CurrentParams.VisualWindow Do
    Result := ( ( Emax.X - Emin.X ) / Abs( FViewPortRect.X2 - FViewPortRect.X1 ) ) *
      DistX;
End;

Function TEzGrapher.DistToRealY( DistY: Integer ): Double;
Begin
  With CurrentParams.VisualWindow Do
    Result := ( ( Emax.Y - Emin.Y ) / Abs( FViewPortRect.Y2 - FViewPortRect.Y1 ) ) *
      DistY;
End;

Function TEzGrapher.RealToDistX( Const DistX: Double ): Integer;
Begin
  If DistX = 0 Then
  Begin
    result := 0;
    Exit;
  End;
  With CurrentParams.VisualWindow Do
    Result := Round( DistX / ( Emax.X - Emin.X ) * Abs( FViewPortRect.X2 - FViewPortRect.X1 ) );
End;

Function TEzGrapher.RealToDistY( Const DistY: Double ): Integer;
Begin
  If DistY = 0 Then
  Begin
    result := 0;
    Exit;
  End;
  With CurrentParams.VisualWindow Do
    Result := Round( ( DistY / ( Emax.Y - Emin.Y ) ) * Abs( FViewPortRect.Y2 - FViewPortRect.Y1 ) );
End;

Function TEzGrapher.RDistToRealX( Const DistX: Double ): Double;
Begin
  With CurrentParams.VisualWindow Do
    Result := ( ( Emax.X - Emin.X ) / Abs( FViewPortRect.X2 - FViewPortRect.X1 ) ) *
      DistX;
End;

Function TEzGrapher.RDistToRealY( Const DistY: Double ): Double;
Begin
  With CurrentParams.VisualWindow Do
    Result := ( ( Emax.Y - Emin.Y ) / Abs( FViewPortRect.Y2 - FViewPortRect.Y1 ) ) *
      DistY;
End;

Function TEzGrapher.RRealToDistX( Const DistX: Double ): Double;
Begin
  If DistX = 0 Then
  Begin
    result := 0;
    Exit;
  End;
  With CurrentParams.VisualWindow Do
    Result := DistX / ( Emax.X - Emin.X ) * Abs( FViewPortRect.X2 - FViewPortRect.X1 );
End;

Function TEzGrapher.RRealToDistY( Const DistY: Double ): Double;
Begin
  If DistY = 0 Then
  Begin
    result := 0;
    Exit;
  End;
  With CurrentParams.VisualWindow Do
    Result := ( DistY / ( Emax.Y - Emin.Y ) ) * Abs( FViewPortRect.Y2 - FViewPortRect.Y1 );
End;

Function TEzGrapher.PointsToDistX( Const Size: Double ): Double;
Var
  Dpis: Integer;
Begin
  If Device = adScreen Then
    Dpis := ScreenDpiX
  Else
    Dpis := PrinterDpiX;
  Result := RDistToRealX( Size * Dpis / 72 );
End;

Function TEzGrapher.PointsToDistY( Const Size: Double ): Double;
Var
  Dpis: Integer;
Begin
  If Device = adScreen Then
    Dpis := ScreenDpiX
  Else
    Dpis := PrinterDpiY;
  Result := RDistToRealY( Size * Dpis / 72 );
End;

Function TEzGrapher.DistToPointsX( Const Dist: Double ): Double;
Var
  Dpis: Integer;
Begin
  If Device = adScreen Then
    Dpis := ScreenDpiX
  Else
    Dpis := PrinterDpiX;
  Result := RRealToDistX( Dist ) * 72 / Dpis;
End;

Function TEzGrapher.DistToPointsY( Const Dist: Double ): Double;
Var
  Dpis: Integer;
Begin
  If Device = adScreen Then
    Dpis := ScreenDpiY
  Else
    Dpis := PrinterDpiY;
  Result := RRealToDistY( Dist ) * 72 / Dpis;
End;

Procedure TEzGrapher.Push;
Var
  TmpParams: PTransformParams;
Begin
  If ( FHistoryList.Count > 0 ) And ( FHistoryList.Count >= FMaxHistoryCount ) Then
    Delete( 0 );
  New( TmpParams );
  TmpParams^ := CurrentParams;
  FHistoryList.Add( TmpParams );
End;

Function TEzGrapher.CanPop: Boolean;
Begin
  result := FHistoryList.Count > 0;
End;

Procedure TEzGrapher.Pop;
Begin
  If FHistoryList.Count = 0 Then
    Exit;
  CurrentParams := PTransformParams( FHistoryList[FHistoryList.Count - 1] )^;
  Delete( FHistoryList.Count - 1 );
  FInUpdate := true;
  SetViewTo( CurrentParams.VisualWindow );
  FInUpdate := false;
End;

Function TEzGrapher.GetHistoryCount: Integer;
Begin
  result := FHistoryList.Count;
End;

Procedure TEzGrapher.Clear;
Var
  I: Integer;
Begin
  For I := 0 To FHistoryList.Count - 1 Do
    Delete( 0 );
  FHistoryList.Clear;
End;

Procedure TEzGrapher.Delete( Index: Integer );
Begin
  If ( Index < 0 ) Or ( Index > FHistoryList.Count - 1 ) Then Exit;
  Dispose( PTransformParams( FHistoryList[Index] ) );
  FHistoryList.Delete( Index );
End;

{ utilities }

Procedure TEzGrapher.SaveCanvas( ACanvas: TCanvas );
Begin
  With ACanvas Do
  Begin
    FOldPenStyle := Pen.Style;
    FOldPenMode := Pen.Mode;
    FOldPenWidth := Pen.Width;
    FOldPenColor := Pen.Color;
    FOldBrushStyle := Brush.Style;
    FOldBrushColor := Brush.Color;
  End;
End;

Procedure TEzGrapher.RestoreCanvas( ACanvas: TCanvas );
Begin
  With ACanvas Do
  Begin
    Pen.Mode := FOldPenMode;
    Pen.Style := FOldPenStyle;
    Pen.Width := FOldPenWidth;
    Pen.Color := FOldPenColor;
    Brush.Style := FOldBrushStyle;
    Brush.Color := FOldBrushColor;
  End;
End;

Function TEzGrapher.GetSizeInPoints( Const Value: double ): Double;
Begin
  If Value < 0 Then
    result := Abs( Value )
  Else
    result := DistToPointsY( value );
End;

Function TEzGrapher.GetRealSize( value: double ): double;
Begin
  If value < 0 Then
    result := PointsToDistY( Abs( Value ) )
  Else
    result := value;
End;

{ PointsSize and PartsSize is an estimated of the actual points and
  parts used }
Procedure TEzGrapher.BeginOptimizer( PointsSize, PartsSize : Integer );
Begin
  EndOptimizer;

  FVisiblePoints:= TEzVector.Create( PointsSize );
  FVisiblePoints.DisableEvents:= True;

  FFirstClipPts:= TEzVector.Create( PointsSize );
  FFirstClipPts.DisableEvents:= True;

  FDevicePoints:= TEzPointList.Create( PointsSize );

  FParts:= TIntegerList.Create;
  FParts.Capacity:= PartsSize;

  FIsFullInside:= TBits.Create;
  FIsFullInside.Size:= PartsSize;

  FInOptimizer:= True;
End;

Procedure TEzGrapher.ClearOptimizer;
var
  I: Integer;
Begin
  If Not FInOptimizer then Exit;
  FVisiblePoints.Clear;
  FFirstClipPts.Clear;
  FDevicePoints.Clear;
  FParts.Count:= 0;
  For I:= 0 to FIsFullInside.Size-1 do
    FIsFullInside.Bits[I]:= False;
End;

Procedure TEzGrapher.EndOptimizer;
Begin
  If Not FInOptimizer Then Exit;
  FreeAndNil( FVisiblePoints );
  FreeAndNil( FFirstClipPts );
  FreeAndNil( FDevicePoints );
  FreeAndNil( FParts );
  FreeAndNil( FIsFullInside );
  FInOptimizer:= False;
End;

{graphics routines}

Function Point2D( Const AX, AY: Double ): TEzPoint; overload;
Begin
  With Result Do
  Begin
    X := AX;
    Y := AY;
  End;
End;

Function Point2D( Const APt: TPoint ): TEzPoint; overload;
Begin
  With Result Do
  Begin
    X := APt.X;
    Y := APt.Y;
  End;
End;

Function ReOrderRect2D( Const R: TEzRect ): TEzRect;
Begin
  If R.X1 < R.X2 Then
  Begin
    Result.X1 := R.X1;
    Result.X2 := R.X2;
  End
  Else
  Begin
    Result.X1 := R.X2;
    Result.X2 := R.X1;
  End;
  If R.Y1 < R.Y2 Then
  Begin
    Result.Y1 := R.Y1;
    Result.Y2 := R.Y2;
  End
  Else
  Begin
    Result.Y1 := R.Y2;
    Result.Y2 := R.Y1;
  End;
End;

Function ReorderRect( Const R: TRect ): TRect;
Begin
  If R.Left < R.Right Then
  Begin
    Result.Left := R.Left;
    Result.Right := R.Right;
  End
  Else
  Begin
    Result.Left := R.Right;
    Result.Right := R.Left;
  End;
  If R.Bottom > R.Top Then
  Begin
    Result.Bottom := R.Bottom;
    Result.Top := R.Top;
  End
  Else
  Begin
    Result.Bottom := R.Top;
    Result.Top := R.Bottom;
  End;
End;

Procedure InflateRect2D( Var R: TEzRect; Const dx, dy: Double );
Begin
  R.X1 := R.X1 - dx;
  R.X2 := R.X2 + dx;
  R.Y1 := R.Y1 - dy;
  R.Y2 := R.Y2 + dy;
End;

Function Rect2D( Const AXmin, AYmin, AXmax, AYmax: Double ): TEzRect;
Begin
  With Result Do
  Begin
    xmin := AXmin;
    ymin := AYmin;
    xmax := AXmax;
    ymax := AYmax;
  End;
End;

Function SetRealToPoint( Const P: TEzPoint ): TPoint;
Begin
  Result.X := Round( P.X );
  Result.Y := Round( P.Y );
End;

Function SetPointToReal( Const P: TPoint ): TEzPoint;
Begin
  Result.X := P.X;
  Result.Y := P.Y;
End;

Function SetRectToReal( Const R: TRect ): TEzRect;
Begin
  Result := Rect2D( R.Left, R.Top, R.Right, R.Bottom );
End;

Function SetRealToRect( Const R: TEzRect ): TRect;
Begin
  Result.Left := Round( R.X1 );
  Result.Right := Round( R.X2 );
  If R.Y1 < R.Y2 Then
  Begin
    Result.Top := Round( R.Y1 );
    Result.Bottom := Round( R.Y2 );
  End
  Else
  Begin
    Result.Bottom := Round( R.Y1 );
    Result.Top := Round( R.Y2 );
  End;
End;

Function EqualMatrix2D( Const M1, M2: TEzMatrix ): Boolean;
Begin
  Result := CompareMem( @M1, @M2, SizeOf( TEzMatrix ) );
End;

{function AddMatrix2D(const m, t: TEzMatrix): TEzMatrix;
var
  r,c: integer;
begin
  for r := 1 to 3 do
     for c := 1 to 3 do
        result[r,c] := m[r,c] + t[r,c];
end;}

Function MultiplyMatrix2D( Const m, t: TEzMatrix ): TEzMatrix;
Var
  r, c: integer;
Begin
  If CompareMem( @m, @IDENTITY_MATRIX2D, SizeOf( TEzMatrix ) ) Then
  Begin
    result := t;
    exit;
  End;
  If CompareMem( @t, @IDENTITY_MATRIX2D, SizeOf( TEzMatrix ) ) Then
  Begin
    result := m;
    exit;
  End;
  For r := 0 To 2 Do
    For c := 0 To 2 Do
      result.Matrix[r, c] := m.Matrix[r, 0] * t.Matrix[0, c] +
                             m.Matrix[r, 1] * t.Matrix[1, c] +
                             m.Matrix[r, 2] * t.Matrix[2, c] ;
End;

Function TransformPoint2D( Const P: TEzPoint; Const T: TEzMatrix ): TEzPoint;
Begin
  If CompareMem( @T, @IDENTITY_MATRIX2D, SizeOf( TEzMatrix ) ) Then
  Begin
    { don't waste precious time }
    Result := P;
    Exit;
  End;
  Result.X := T.Matrix[0, 0] * P.X + T.Matrix[0, 1] * P.Y + T.Matrix[0, 2];
  Result.Y := T.Matrix[1, 0] * P.X + T.Matrix[1, 1] * P.Y + T.Matrix[1, 2];
End;

Function MirrorAroundX: TEzMatrix;
begin
  Result := IDENTITY_MATRIX2D;
  Result.Matrix[0,0] := 1;
  Result.Matrix[1,1] := -1;
  Result.Matrix[2,2] := 1;
end;

Function TransformRect2D( Const R: TEzRect; Const T: TEzMatrix ): TEzRect;
Begin
  Result.Emin := TransformPoint2D( R.Emin, T );
  Result.Emax := TransformPoint2D( R.Emax, T );
End;

Function Translate2D( Const Tx, Ty: Double ): TEzMatrix;
Begin
  Result := IDENTITY_MATRIX2D;
  Result.Matrix[0, 2] := Tx;
  Result.Matrix[1, 2] := Ty;
End;

Function Rotate2D( Const phi: Double; Const refPt: TEzPoint ): TEzMatrix;
Begin
  Result := IDENTITY_MATRIX2D;
  Result.Matrix[0, 0] := cos( phi );
  Result.Matrix[0, 1] := -sin( phi );
  Result.Matrix[0, 2] := refPt.X * ( 1 - cos( phi ) ) + refPt.Y * sin( phi );
  Result.Matrix[1, 0] := sin( phi );
  Result.Matrix[1, 1] := cos( phi );
  Result.Matrix[1, 2] := refPt.Y * ( 1 - cos( phi ) ) - refPt.X * sin( phi );
End;

Function Scale2D( Const Sx, Sy: Double; Const refPt: TEzPoint ): TEzMatrix;
Begin
  Result := IDENTITY_MATRIX2D;
  Result.Matrix[0, 0] := Sx;
  Result.Matrix[0, 2] := ( 1 - Sx ) * refPt.X;
  Result.Matrix[1, 1] := Sy;
  Result.Matrix[1, 2] := ( 1 - Sy ) * refPt.Y;
End;

procedure matrix3x3PreMultiply(const m: TEzMatrix; var t: TEzMatrix);
var
  r,c: integer;
  tmp: TEzMatrix;
begin
  for r := 0 to 2 do
    for c := 0 to 2 do
      tmp.Matrix[r,c] := m.Matrix[r,0]*t.Matrix[0,c] +
                         m.Matrix[r,1]*t.Matrix[1,c] +
                         m.Matrix[r,2]*t.Matrix[2,c] ;
  t:= tmp;
end;

Function BuildTransformationMatrix( const sx,sy,phi,tx,ty : double;
  const refPt: TEzPoint ): TEzMatrix;
Begin
  Result := IDENTITY_MATRIX2D;
  if not ( (sx = 1) and (sy = 1) ) then
    matrix3x3PreMultiply( Scale2D( sx, sy, refPt ), Result );
  if phi <> 0 then
    matrix3x3PreMultiply( Rotate2D( phi, refPt ), Result );
  if not ( (tx = 0) and (ty = 0) ) then
    matrix3x3PreMultiply( Translate2D( tx, ty ), Result );
End;

Function Angle2D( Const P1, P2: TEzPoint ): Double;
Var
  Dx, Dy: Double;
Begin
  Dx := P2.x - P1.x;
  Dy := P2.y - P1.y;
  Result := 0;
  If ( Dx = 0 ) And ( Dy = 0 ) Then
    Exit;
  If ( Dx = 0 ) And ( Dy > 0 ) Then
    Result := Pi / 2
  Else If ( Dx = 0 ) And ( Dy < 0 ) Then
    Result := -Pi / 2
  Else
    Result := Math.ArcTan2( Dy, Dx );
End;

Function EqualPoint2D( Const P1, P2: TEzPoint ): Boolean;
Begin
  Result := CompareMem( @P1, @P2, SizeOf( TEzPoint ) );
End;

Function EqualRect2D( Const R1, R2: TEzRect ): Boolean;
Begin
  Result := CompareMem( @R1, @R2, SizeOf( TEzRect ) );
End;

Function FuzzEqualPoint2D( Const P1, P2: TEzPoint ): Boolean;
Begin
  Result := Defuzz( Dist2D( P1, P2 ) ) = 0.0;
End;

Function dMax( Const A, B: Double ): Double;
Begin
  If A > B Then
    Result := A
  Else
    Result := B;
End;

Function dMin( Const A, B: Double ): Double;
Begin
  If A < B Then
    Result := A
  Else
    Result := B;
End;

Function IMax( A, B: Integer ): Integer;
Begin
  If A > B Then
    Result := A
  Else
    Result := B;
End;

Function IMin( A, B: Integer ): Integer;
Begin
  If A < B Then
    Result := A
  Else
    Result := B;
End;

Function BoxFilling2D( Const Box1, Box2: TEzRect ): Integer;
Var
  Tmp1, Tmp2: Integer;
Begin
  Try
    if CompareMem(@Box2.X2, @Box2.X1, sizeof(Double))=false then
      Tmp1 := Round( ( Box1.X2 - Box1.X1 ) / ( Box2.X2 - Box2.X1 ) * 1000 )
    else
      Tmp1 := 0;
    if CompareMem(@Box2.Y2, @Box2.Y1, sizeof(Double))=false then
      Tmp2 := Round( ( Box1.Y2 - Box1.Y1 ) / ( Box2.Y2 - Box2.Y1 ) * 1000 )
    else
      Tmp2 := 0;
    If Tmp1 > Tmp2 Then
      Result := Tmp1
    Else
      Result := Tmp2;
  Except
    //on EInvalidOp do
    Result := 1000;
  End;
End;

Function IsRectVisible( Const ARect, AClip: TEzRect ): Boolean;
Begin
  Result := False;
  With ARect Do
  Begin
    If X1 > AClip.X2 Then
      Exit
    Else If X2 < AClip.X1 Then
      Exit;
    If Y1 > AClip.Y2 Then
      Exit
    Else If Y2 < AClip.Y1 Then
      Exit;
  End;
  If CompareMem( @ARect.Emin, @ARect.Emax, SizeOf( TEzPoint ) ) And
    IsPointInBox2D( ARect.Emin, AClip ) Then
  Begin
    Result := true;
    Exit;
  End;
  Result := BoxFilling2D( ARect, AClip ) >= Ez_Preferences.MinDrawLimit;
End;

Function IsRectVisibleForPlace( Const ARect, AClip: TEzRect ): Boolean;
Begin
  Result := False;
  With ARect Do
  Begin
    If X1 > AClip.X2 Then
      Exit
    Else If X2 < AClip.X1 Then
      Exit;
    If Y1 > AClip.Y2 Then
      Exit
    Else If Y2 < AClip.Y1 Then
      Exit;
  End;
  If CompareMem( @ARect.Emin, @ARect.Emax, SizeOf( TEzPoint ) ) And
    IsPointInBox2D( ARect.Emin, AClip ) Then
  Begin
    Result := true;
    Exit;
  End;
  Result := True;
End;

Function PositionCode2D( Const Clip: TEzRect; Const P: TEzPoint ): TEzOutCode;
Begin
  Result := [];
  If Clip.X1 < Clip.X2 Then
  Begin
    If P.X < Clip.X1 Then
      Result := [left]
    Else If P.X > Clip.X2 Then
      Result := [right];
  End
  Else
  Begin
    If P.X > Clip.X1 Then
      Result := [left]
    Else If P.X < Clip.X2 Then
      Result := [right];
  End;
  If Clip.Y1 < Clip.Y2 Then
  Begin
    If P.Y < Clip.Y1 Then
      Result := Result + [bottom]
    Else If P.Y > Clip.Y2 Then
      Result := Result + [top];
  End
  Else
  Begin
    If P.Y > Clip.Y1 Then
      Result := Result + [bottom]
    Else If P.Y < Clip.Y2 Then
      Result := Result + [top];
  End;
End;

Function ClipPt( Const Denom, Num: Double; Var tE, tL: Double ): Boolean;
Var
  T: Double;
Begin
  Result := False;
  If Denom > 0 Then
  Begin
    T := Num / Denom;
    If T > tL Then
      Exit
    Else If T > tE Then
      tE := T;
  End
  Else If Denom < 0 Then
  Begin
    T := Num / Denom;
    If T < tE Then
      Exit
    Else If T < tL Then
      tL := T;
  End
  Else If Num > 0 Then
    Exit;
  Result := True;
End;

Function ClipLine2D( Const Clip: TEzRect; Var X1, Y1, X2, Y2: Double ): TEzClipCodes;
Var
  DX, DY, tE, tL: Double;
Begin
  DX := X2 - X1;
  DY := Y2 - Y1;
  Result := [ccNotVisible];
  If ( DX = 0 ) And ( DY = 0 ) And IsPointInBox2D( Point2D( X1, Y1 ), Clip ) Then
  Begin
    Result := [ccVisible];
    Exit;
  End;
  tE := 0.0;
  tL := 1.0;
  If ClipPt( DX, Clip.X1 - X1, tE, tL ) Then
    If ClipPt( -DX, X1 - Clip.X2, tE, tL ) Then
      If ClipPt( DY, Clip.Y1 - Y1, tE, tL ) Then
        If ClipPt( -DY, Y1 - Clip.Y2, tE, tL ) Then
        Begin
          Result := [];
          If tL < 1 Then
          Begin
            X2 := X1 + tL * DX;
            Y2 := Y1 + tL * DY;
            Result := [ccSecond];
          End;
          If tE > 0 Then
          Begin
            X1 := X1 + tE * DX;
            Y1 := Y1 + tE * DY;
            Result := Result + [ccFirst];
          End;
          If Result = [] Then
            Result := [ccVisible];
        End;
End;

(* The famous Liang-Barsky algoritm *)

Function ClipLineLeftRight2D( Const Clip: TEzRect; Var X1, Y1, X2, Y2: Double ): TEzClipCodes;
Var
  DX, DY, tE, tL: Double;
Begin
  DX := X2 - X1;
  DY := Y2 - Y1;
  Result := [ccNotVisible];
  If ( DX = 0 ) And ( DY = 0 ) And IsPointInBox2D( Point2D( X1, Y1 ), Clip ) Then
  Begin
    Result := [ccVisible];
    Exit;
  End;
  tE := 0.0;
  tL := 1.0;
  If ClipPt( DX, Clip.X1 - X1, tE, tL ) Then
    If ClipPt( -DX, X1 - Clip.X2, tE, tL ) Then
    Begin
      Result := [];
      If tL < 1 Then
      Begin
        X2 := X1 + tL * DX;
        Y2 := Y1 + tL * DY;
        Result := [ccSecond];
      End;
      If tE > 0 Then
      Begin
        X1 := X1 + tE * DX;
        Y1 := Y1 + tE * DY;
        Result := Result + [ccFirst];
      End;
      If Result = [] Then
        Result := [ccVisible];
    End;
End;

Function ClipLineUpBottom2D( Const Clip: TEzRect; Var X1, Y1, X2, Y2: Double ): TEzClipCodes;
Var
  DX, DY, tE, tL: Double;
Begin
  DX := X2 - X1;
  DY := Y2 - Y1;
  Result := [ccNotVisible];
  If ( DX = 0 ) And ( DY = 0 ) And IsPointInBox2D( Point2D( X1, Y1 ), Clip ) Then
  Begin
    Result := [ccVisible];
    Exit;
  End;
  tE := 0.0;
  tL := 1.0;
  If ClipPt( DY, Clip.Y1 - Y1, tE, tL ) Then
    If ClipPt( -DY, Y1 - Clip.Y2, tE, tL ) Then
    Begin
      Result := [];
      If tL < 1 Then
      Begin
        X2 := X1 + tL * DX;
        Y2 := Y1 + tL * DY;
        Result := [ccSecond];
      End;
      If tE > 0 Then
      Begin
        X1 := X1 + tE * DX;
        Y1 := Y1 + tE * DY;
        Result := Result + [ccFirst];
      End;
      If Result = [] Then
        Result := [ccVisible];
    End;
End;

Function IsBoxInBox2D( Const Box1, Box2: TEzRect ): Boolean;
Var
  FCode, SCode: TEzOutCode;
Begin
  FCode := PositionCode2D( Box2, Box1.Emin );
  SCode := PositionCode2D( Box2, Box1.Emax );
  Result := ( FCode * SCode ) = [];
End;

Function IsPointInBox2D( Const Pt: TEzPoint; Const Box: TEzRect ): Boolean;
Begin
  Result := PositionCode2D( Box, Pt ) = [];
End;

Function IsBoxFullInBox2D( Const Box1, Box2: TEzRect ): Boolean;
Var
  FCode, SCode: TEzOutCode;
Begin
  FCode := PositionCode2D( Box2, Box1.Emin );
  SCode := PositionCode2D( Box2, Box1.Emax );
  Result := ( FCode = [] ) And ( SCode = [] );
End;

Function BoxOutBox2D( Box1, Box2: TEzRect ): TEzRect;
Begin
  Box1 := ReorderRect2D( Box1 );
  Box2 := ReorderRect2D( Box2 );
  Result := Box1;
  If Box2.X1 < Box1.X1 Then
    Result.X1 := Box2.X1;
  If Box2.X2 > Box1.X2 Then
    Result.X2 := Box2.X2;
  If Box2.Y1 < Box1.Y1 Then
    Result.Y1 := Box2.Y1;
  If Box2.Y2 > Box1.Y2 Then
    Result.Y2 := Box2.Y2;
End;

Function IsNearPoint2D( Const RP, P: TEzPoint; Const Aperture: Double;
  Var Dist: Double ): Boolean;
Var
  TmpBox: TEzRect;
Begin
  TmpBox.Emin := Point2D( RP.X - Aperture, RP.Y - Aperture );
  TmpBox.Emax := Point2D( RP.X + Aperture, RP.Y + Aperture );
  Result := PositionCode2D( TmpBox, P ) = [];
  If Result Then
    Dist := Sqrt( Sqr( P.X - RP.X ) + Sqr( P.Y - RP.Y ) );
End;

Function Dist2D( Const Pt1, Pt2: TEzPoint ): Double;
Begin
  Result := Sqrt( Sqr( Pt1.X - Pt2.X ) + Sqr( Pt1.Y - Pt2.Y ) );
End;

Function Dist2D( Const X1, Y1, X2, Y2: Double ): Double;
Begin
  Result := Sqrt( Sqr( X1 - X2 ) + Sqr( Y1 - Y2 ) );
End;

Function Area2D( Vector: TEzVector ): Double;
Var
  cnt, Idx1, Idx2, n, np: Integer;
Begin
  Result := 0;
  If Vector.Count = 0 Then
    Exit;
  np := Vector.Parts.Count;
  n := 0;
  If np < 2 Then
  Begin
    Idx1 := 0;
    Idx2 := Vector.Count - 1;
  End
  Else
  Begin
    Idx1 := Vector.Parts[n];
    Idx2 := Vector.Parts[n + 1] - 1;
  End;
  Repeat
    For cnt := Idx1 To Idx2 Do
    Begin
      Result := Result +
        ( Vector[cnt].X * Vector[( cnt + 1 ) Mod Vector.Count].Y ) -
      ( Vector[cnt].Y * Vector[( cnt + 1 ) Mod Vector.Count].X );
    End;
    If np < 2 Then
      Break;
    Inc( n );
    If n >= np Then
      Break;
    Idx1 := Vector.Parts[n];
    If n < np - 1 Then
      Idx2 := Vector.Parts[n + 1] - 1
    Else
      Idx2 := Vector.Count - 1;
  Until false;
  Result := Abs( Result ) / 2;
End;

Function RightIntersection2D( Const P, P1, P2: TEzPoint ): Boolean;
Var
  R: Double;
Begin
  Result := ( ( P.Y >= P1.Y ) And ( P.Y < P2.Y ) ) Or ( ( P.Y < P1.Y ) And ( P.Y >= P2.Y ) );
  If Not Result Then Exit;
  R := ( P.Y - P1.Y ) * ( P2.X - P1.X ) / ( P2.Y - P1.Y ) + P1.X;
  Result := P.X <= R;
End;

Function TransformBoundingBox2D( const Box: TEzRect; Const Matrix: TEzMatrix ): TEzRect;
Var
  Box1, Box2: TEzRect;
Begin
  Box1 := TransformRect2D( Box, Matrix );
  Box2 := TransformRect2D( Rect2D( Box.X1, Box.Y2, Box.X2, Box.Y1 ), Matrix );
  Result := BoxOutBox2D( Box1, Box2 );
End;

Function ChangeToOrtogonal( Const Pt1, Pt2: TEzPoint ): TEzPoint;
Begin
  Result := Pt2;
  If Abs( Pt2.X - Pt1.X ) > Abs( Pt2.Y - Pt1.Y ) Then
    Result.Y := Pt1.Y
  Else
    Result.X := Pt1.X;
End;

Function EQ( Const a, b: Double ): Boolean;
Begin
  Result := ( abs( a - b ) <= TOL_EPSILON );
End;

{line intersections}

Function LineRel( Const P1, P2, D1, D2: TEzPoint; Var P: TEzPoint ): TEzLineRelations;
(* Returnes a code which indicates the relationship between the
   partition line (going from P1 to P2) and the division line (going
   from D1 to D2).  If the lines are not parallel the point where the
   lines will intersect is returned.  This point is not necessarilly
   within the boundaries of either line, but is the point at which the
   lines will intersect if they were infinitally extended in both
   directions.                                                         *)
Var
  Denominator: Double;
  Numerator: Double;
  Fraction: Double;
  XInt, YInt: Double;
  XPar, YPar: Double;
  XDiv, YDiv: Double;
  dXPar, dYPar: Double;
  dXDiv, dYDiv: Double;
Begin
  (* Compute the delta X and delta Y for both lines, and move all the
   parameters into real types to avoid arithmetic overflow error. *)
  XPar := P1.X;
  YPar := P1.Y;
  XDiv := D1.X;
  YDiv := D1.Y;
  dXPar := P2.X - P1.X;
  dYPar := P2.Y - P1.Y;
  dXDiv := D2.X - D1.X;
  dYDiv := D2.Y - D1.Y;

  Result := [];

  { First we compute the denominator and numerator to find
   the relation of the division line to the partition line.}
  Denominator := ( dYPar * dXDiv ) - ( dXPar * dYDiv );
  Numerator := ( ( XPar - XDiv ) * dYPar ) + ( ( YDiv - YPar ) * dXPar );
  { Find the intersection in relation to the division line. }
  If EQ( Denominator, 0.0 ) Then
  Begin { The two lines are parallel }
    Include( Result, lrParallel );
    { Find which side of the partition line the division line is on. }
    If EQ( Numerator, 0.0 ) Then
    Else If Numerator > 0.0 Then
      Include( Result, lrDivToRight )
    Else If Numerator < 0.0 Then
      Include( Result, lrDivToLeft );
  End
  Else
  Begin { The lines are NOT parallel }
    Fraction := Numerator / Denominator;
    { Compute the intersection point }
    XInt := XDiv + dXDiv * Fraction;
    YInt := YDiv + dYDiv * Fraction;
    P.X := XInt;
    P.Y := YInt;
    (* Check if the intersection point actually falls on the
       start or end of the division line, and reassign fraction
       and numerator to reflect this.                           *)
    If EQ( P.X, D1.X ) And EQ( P.Y, D1.Y ) Then
    Begin
      If Fraction > 0.0 Then
        Numerator := -Numerator;
      Fraction := 0.0;
    End
    Else If EQ( P.X, D2.X ) And EQ( P.Y, D2.Y ) Then
      Fraction := 1.0;

    { Find which side of the partition line the division line is on. }
    If Numerator > 0.0 Then
      Include( Result, lrDivToRight )
    Else If Numerator < 0.0 Then
      Include( Result, lrDivToLeft )
    Else
    Begin
      { If numerator=0 we use denominator to find the side. }
      If Denominator < 0.0 Then
        Include( Result, lrDivToRight )
      Else If Denominator > 0.0 Then
        Include( Result, lrDivToLeft );
    End;

    If Fraction < 0.0 Then
      Include( Result, lrOffDivStart )
        { Intersection is beyond the start of the division line. }
    Else If Fraction = 0.0 Then
      Include( Result, lrAtDivStart )
        { Intersection at the start of the division line. }
    Else If Fraction > 1.0 Then
      Include( Result, lrOffDivEnd )
        { Intersection is beyond the end of the division line. }
    Else If Fraction = 1.0 Then
      Include( Result, lrAtDivEnd )
        { Intersection at the end of the division line. }
    Else
      Include( Result, lrBetweenDiv );
    { Intersection between the start and the end of the division line. }
  End;

  (* Now we compute the denominator and numerator to find
     the relation of the partiton line to the division line. *)
  Denominator := ( dYDiv * dXPar ) - ( dXDiv * dYPar );
  Numerator := ( ( XDiv - XPar ) * dYDiv ) + ( ( YPar - YDiv ) * dXDiv );
  { Find the intersection in relation to the partition line. }
  If EQ( Denominator, 0.0 ) Then
  Begin { The two lines are parallel }
    { Find which side of the division line the partition line is on. }
    If EQ( Numerator, 0.0 ) Then
    Else If Numerator > 0.0 Then
      Include( Result, lrParToRight )
    Else If Numerator < 0.0 Then
      Include( Result, lrParToLeft );
  End
  Else
  Begin { The lines are NOT parallel }
    Fraction := Numerator / Denominator;
    (* Check if the intersection point actually falls on the
       start or end of the partition line, and reassign fraction
       and numerator to reflect this.                            *)
    If EQ( P.X, P1.X ) And EQ( P.Y, P1.Y ) Then
    Begin
      If Fraction > 0.0 Then
        Numerator := -Numerator;
      Fraction := 0.0;
    End
    Else If EQ( P.X, P2.X ) And EQ( P.Y, P2.Y ) Then
      Fraction := 1.0;

    { Find which side of the division line the partition line is on. }
    If Numerator > 0.0 Then
      Include( Result, lrParToRight )
    Else If Numerator < 0.0 Then
      Include( Result, lrParToLeft )
    Else
    Begin
      { If numerator=0 we use denominator to find the side. }
      If Denominator < 0.0 Then
        Include( Result, lrParToRight )
      Else If Denominator > 0.0 Then
        Include( Result, lrParToLeft );
    End;

    If Fraction < 0.0 Then
      Include( Result, lrOffParStart )
        { Intersection is beyond the start of the partition line. }
    Else If Fraction = 0.0 Then
      Include( Result, lrAtParStart )
        { Intersection at the start of the partition line. }
    Else If Fraction > 1.0 Then
      Include( Result, lrOffParEnd )
        { Intersection is beyond the end of the partition line. }
    Else If Fraction = 1.0 Then
      Include( Result, lrAtParEnd )
        { Intersection at the end of the partition line. }
    Else
      Include( Result, lrBetweenPar );
    { Intersection between the start and the end of the partition line. }
  End;
End;

{ This function returns true if Vector1 intersect Vect2 and return
   in IntersectVector the points where the two vectors intersects.
   If strictlyBetween is true, then the intersection must
   occur between the points that builds the line segments
   otherwise, the intersection can occur outside that area. }

Function VectIntersect( Vector1, Vector2, IntersectVector: TEzVector;
  StrictlyBetween: Boolean; CheckLimits: Boolean = False ): Boolean;
Var
  LineR: TEzLineRelations;
  cnt1, cnt2: integer;
  IntPt: TEzPoint;
  Pass: Boolean;

  Function AlreadyInList: Boolean;
  Var
    I: Integer;
  Begin
    Result := False;
    For I := 0 To IntersectVector.Count - 1 Do
      If EqualPoint2D( IntersectVector[I], IntPt ) Then
      Begin
        Result := True;
        Exit;
      End;
  End;

Begin
  IntersectVector.Clear;
  Result := false;
  For cnt1 := 0 To Vector1.Count - 2 Do
    For cnt2 := 0 To Vector2.Count - 2 Do
    Begin
      LineR := LineRel( Vector1[cnt1], Vector1[Succ( cnt1 )],
        Vector2[cnt2], Vector2[Succ( cnt2 )], IntPt );
      If StrictlyBetween Then
      Begin
        If Not CheckLimits Then
        Begin
          Pass := ( LineR * [lrBetweenDiv, lrBetweenPar] = [lrBetweenDiv, lrBetweenPar] );
        End
        Else
        Begin
          Pass := ( LineR * [lrBetweenDiv, lrBetweenPar] = [lrBetweenDiv, lrBetweenPar] )
            Or ( lrAtDivStart In LineR ) Or ( lrAtDivEnd In LineR )
            Or ( lrAtParStart In LineR ) Or ( lrAtParEnd In LineR );
        End;
      End
      Else
        Pass := Not ( lrParallel In LineR );
      If Pass And Not AlreadyInList Then
      Begin
        IntersectVector.Add( IntPt );
        Result := true;
      End;
    End;
End;

(* Computes the centroid (center of gravity) of a polygon
 via weighted sum of signed triangle areas. *)

Procedure FindCG( Vector: TEzVector; Var CG: TEzPoint; ComputeCG: Boolean );
Var
  cnt, N: Integer;
  A2, Areasum2: Double;
  Cent3: TEzPoint;

  Function Area2( Const a, b, c: TEzPoint ): Double;
  Begin
    Result := ( b.X - a.X ) * ( c.Y - a.Y ) - ( c.X - a.X ) * ( b.Y - a.Y );
  End;

  Procedure Centroid3( Const p1, p2, p3: TEzPoint; Var c: TEzPoint );
  Begin
    c.X := p1.X + p2.X + p3.X;
    c.Y := p1.Y + p2.Y + p3.Y;
  End;

  Procedure NormalCentroid;
  Var
    cnt, n: Integer;
  Begin
    n := Vector.Count;
    If n = 0 Then
      Exit;
    For cnt := 0 To n - 1 Do
    Begin
      CG.X := CG.X + Vector[cnt].X;
      CG.Y := CG.Y + Vector[cnt].Y;
    End;
    CG.X := CG.X / n;
    CG.Y := CG.Y / n;
  End;

Begin
  Areasum2 := 0;
  CG.X := 0;
  CG.Y := 0;
  If Not ComputeCG Or ( Vector.Count < 3 ) Then
  Begin
    NormalCentroid;
    Exit;
  End;
  If EqualPoint2d( Vector[0], Vector[Vector.Count - 1] ) Then
    N := Vector.Count - 3
  Else
    N := Vector.Count - 2;
  For cnt := 1 To N Do
  Begin
    Centroid3( Vector[0], Vector[cnt], Vector[cnt + 1], Cent3 );
    A2 := Area2( Vector[0], Vector[cnt], Vector[cnt + 1] );
    CG.X := CG.X + A2 * Cent3.X;
    CG.Y := CG.Y + A2 * Cent3.Y;
    Areasum2 := Areasum2 + A2;
  End;
  If Not ( Areasum2 = 0 ) Then
  Begin
    CG.X := CG.X / ( 3 * Areasum2 );
    CG.Y := CG.Y / ( 3 * Areasum2 );
  End;
End;

(* Determines wheter the vertices are in cw or ccw order. It finds
   the lowest and rightmost vertex, and computes the cross-product
   of the vectors along its incident edges *)

Function IsCounterClockWise( Vector: TEzVector ): Boolean;

// FindLR finds the lowest, rightmost vertex of poly.
  Function FindLR: Integer;
  Var
    cnt: Integer;
    min, tmp: TEzPoint;
  Begin
    min.X := Vector[0].X;
    min.Y := Vector[0].Y;
    Result := 0;
    For cnt := 0 To Vector.Count - 1 Do
    Begin
      tmp := Vector[cnt];
      If ( tmp.Y < min.Y ) Or ( ( tmp.Y = min.Y ) And ( tmp.X > min.X ) ) Then
      Begin
        Result := cnt;
        min.X := tmp.X;
        min.Y := tmp.Y;
      End;
    End;
  End;

  Function Ccw( m: Integer ): Integer;
  Var
    area2: Double;
    m1, n: Integer;
    a, b, c: TEzPoint;
  Begin
    n := Vector.Count;
    m1 := ( m + ( n - 1 ) ) Mod n;
    // assign adjacents points
    a := Vector[m1];
    b := Vector[m];
    c := Vector[( m + 1 ) Mod n];
    area2 := a.X * b.Y - a.Y * b.X + a.Y * c.X - a.X * c.Y + b.X * c.Y - c.X *
      b.Y;
    If area2 > 0 Then
      Result := 1
    Else If area2 < 0 Then
      result := -1
    Else
      result := 0;
  End;

Begin
  Result := ( Ccw( FindLR ) = 1 );
End;

(* Determines if point (CX,CY) is on line that goes from (AX,AY) to
   (BX,BY)
   P is the point of perpendicular projection of C on AB*)

Function IsPointOnMe( Const C, A, B: TEzPoint ): Boolean;
Var
  r, s, L: Double;
  {P: TEzPoint;}
Begin
  Result := False;
  L := Dist2D( Point2D( A.X, A.Y ), Point2D( B.X, B.Y ) );
  If L = 0 Then Exit;

  r := ( ( C.X - A.X ) * ( B.X - A.X ) + ( C.Y - A.Y ) * ( B.Y - A.Y ) ) / ( L * L );
  (* P.X := A.X + r * (B.X - A.X);
  P.Y := A.Y + r * (B.Y - A.Y); *)
  s := ( ( A.Y - C.Y ) * ( B.X - A.X ) - ( A.X - C.X ) * ( B.Y - A.Y ) ) / ( L * L );
  Result := ( r >= 0 ) And ( r <= 1 ) And ( s = 0 );
End;

Function PrintersInstalled: Boolean;
Var
  Flags: Integer;
  Level: Byte;
  Count, NumInfo: DWORD;
Begin
  If Win32Platform = VER_PLATFORM_WIN32_NT Then
  Begin
    Flags := PRINTER_ENUM_CONNECTIONS Or PRINTER_ENUM_LOCAL;
    Level := 4;
  End
  Else
  Begin
    Flags := PRINTER_ENUM_LOCAL;
    Level := 5;
  End;
  Count := 0;
  EnumPrinters( Flags, Nil, Level, Nil, 0, Count, NumInfo );
  Result := Count > 0;
End;

Procedure MaxBound( Var bounds: TEzPoint; Const pt: TEzPoint );
Begin
  If pt.x > bounds.x Then
    bounds.x := pt.x;
  If pt.y > bounds.y Then
    bounds.y := pt.y;
End;

Procedure MinBound( Var bounds: TEzPoint; Const pt: TEzPoint );
Begin
  If pt.x < bounds.x Then
    bounds.x := pt.x;
  If pt.y < bounds.y Then
    bounds.y := pt.y;
End;

{ this routine will clip the vector of points to an area
  and will return the resulting polygon }

Procedure ClipPolygonToArea( Vector, ClippedVector: TEzVector; Const ClipArea: TEzRect );
Var
  VisPoints, VisPoints1, cnt: Integer;
  TmpPt1, TmpPt2: TEzPoint;
  TmpPts, FirstClipPts: PEzPointArray;
  ClipRes: TEzClipCodes;
  TmpSize: Integer;
Begin
  If Vector.Count < 3 Then
    Exit;
  TmpSize := ( Vector.Count + 4 ) * sizeof( TEzPoint );
  GetMem( TmpPts, TmpSize );
  GetMem( FirstClipPts, TmpSize );
  Try
    VisPoints := 0;
    VisPoints1 := 0;
    If IsBoxFullInBox2D( Vector.Extension, ClipArea ) Then
      ClippedVector.Assign( Vector )
    Else
    Begin
      For cnt := 0 To Vector.Count - 1 Do
      Begin
        TmpPt1 := Vector[cnt];
        If cnt < Vector.Count - 1 Then
          TmpPt2 := Vector[cnt + 1]
        Else
          TmpPt2 := Vector[0];
        ClipRes := ClipLineLeftRight2D( ClipArea, TmpPt1.X, TmpPt1.Y, TmpPt2.X,
          TmpPt2.Y );
        If Not ( ccNotVisible In ClipRes ) Then
        Begin
          FirstClipPts[VisPoints1] := TmpPt1;
          Inc( VisPoints1 );
        End;
        If ccSecond In ClipRes Then
        Begin
          FirstClipPts[VisPoints1] := TmpPt2;
          Inc( VisPoints1 );
        End;
      End;
      FirstClipPts[VisPoints1] := FirstClipPts[0];
      Inc( VisPoints1 );
      VisPoints := 0;
      For cnt := 0 To VisPoints1 - 2 Do
      Begin
        TmpPt1 := FirstClipPts[cnt];
        TmpPt2 := FirstClipPts[cnt + 1];
        ClipRes := ClipLineUpBottom2D( ClipArea, TmpPt1.X, TmpPt1.Y, TmpPt2.X,
          TmpPt2.Y );
        If Not ( ccNotVisible In ClipRes ) Then
        Begin
          TmpPts[VisPoints] := TmpPt1;
          Inc( VisPoints );
        End;
        If ccSecond In ClipRes Then
        Begin
          TmpPts[VisPoints] := TmpPt2;
          Inc( VisPoints );
        End;
      End;
    End;
    If VisPoints > 1 Then
      For cnt := 0 To VisPoints - 1 Do
        ClippedVector.Add( TmpPts[cnt] );
  Finally
    FreeMem( TmpPts, TmpSize );
    FreeMem( FirstClipPts, TmpSize );
  End;
End;

////////////////////////////////////////////////////////////////////////////////
// this code was generousely donated by Jens Gruschel
// 2001 by Jens Gruschel (www.pegtop.de)
// vector algebra 2D
////////////////////////////////////////////////////////////////////////////////

Function Add2D( const A, B: TEzPoint ): TEzPoint; // A+B
Begin
  Result.X := A.X + B.X;
  Result.Y := A.Y + B.Y;
End;

Function Sub2D( const A, B: TEzPoint ): TEzPoint; // A-B
Begin
  Result.X := A.X - B.X;
  Result.Y := A.Y - B.Y;
End;

Function Mul2D( const A, B: TEzPoint ): Double; // A*B
Begin
  Result := A.X * B.X + A.Y * B.Y;
End;

Function Ort2D( const A: TEzPoint ): TEzPoint;
Begin
  Result.X := -A.Y;
  Result.Y := A.X;
End;

Function Len2D( const A: TEzPoint ): Double; // length(A)
Begin
  Result := Sqrt( Sqr( A.X ) + Sqr( A.Y ) );
End;

Function DistLinePoint2D( const P, V, X: TEzPoint ): Double;
// distance between X and a line P+rV
// V may not be (0,0) !!!
Var
  N: TEzPoint;
Begin
  N := Ort2D( V );
  Result := Mul2D( Sub2D( X, P ), N ) / Len2D( N );
End;

Function NearestLinePoint2D( const P, V, X: TEzPoint ): Double;
// nearest point of the line P+rV to X in units of V
// V may not be (0,0) !!!
// to gain the corresponding point:
// Result.X := P.X+V.X*Result;
// Result.Y := P.Y+V.Y*Result;
Var
  T: Double;
Begin
  If V.Y = 0 Then
  Begin // V.X may not be 0
    T := V.X + Sqr( V.Y ) / V.X; // T cannot be 0 if V.X is not 0
    Result := ( X.X - P.X - V.Y / V.X * ( P.Y - X.Y ) ) / T;
  End
  Else
  Begin // V.Y may not be 0
    T := V.Y + Sqr( V.X ) / V.Y; // T cannot be 0 if V.Y is not 0
    Result := ( X.Y - P.Y - V.X / V.Y * ( P.X - X.X ) ) / T;
  End;
End;

{ calculates minimum distance }

Procedure GetMinimumDistance2D( Poly1, Poly2: TEzVector;
  Var Distance: Double; Var Min1, Min2: TEzPoint );
Var
  N1, N2, I1, I2: Integer;
  D, R: Double;
  P1, P2, V: TEzPoint;
  Nearest: TEzPoint;
Begin
  N1 := Poly1.Count;
  N2 := Poly2.Count;
  Distance := MAXCOORD; // very large distance
  // check corners of second polygon with lines of first one:
  For I1 := 0 To N1 - 2 Do
  Begin
    P1 := Poly1[I1]; // first corner
    P2 := Poly1[( I1 + 1 ) {Mod N1}]; // second corner
    V := Sub2D( P2, P1 ); // line vector
    if ( V.X = 0 ) And ( V.Y = 0 ) then Continue;
    For I2 := 0 To N2 - 1 Do
    Begin
      R := NearestLinePoint2D( P1, V, Poly2[I2] );
      If R <= 0 Then
      Begin
        Nearest := P1;
      End
      Else If R >= 1 Then
      Begin
        Nearest := P2;
      End
      Else
      Begin
        Nearest.X := P1.X + R * V.X;
        Nearest.Y := P1.Y + R * V.Y;
      End;
      D := Len2D( Sub2D( Poly2[I2], Nearest ) );
      If D < Distance Then
      Begin // smaller distance found
        Distance := D;
        Min1 := Poly2[I2];
        Min2 := Nearest;
      End;
    End;
  End;
  // check corners of first polygon with lines of second one:
  For I2 := 0 To N2 - 2 Do
  Begin
    P1 := Poly2[I2]; // first corner
    P2 := Poly2[( I2 + 1 ) {Mod N2}]; // second corner
    V := Sub2D( P2, P1 ); // line vector
    if ( V.X = 0 ) And ( V.Y = 0 ) then Continue;
    For I1 := 0 To N1 - 1 Do
    Begin
      R := NearestLinePoint2D( P1, V, Poly1[I1] );
      If R <= 0 Then
      Begin
        Nearest := P1;
      End
      Else If R >= 1 Then
      Begin
        Nearest := P2;
      End
      Else
      Begin
        Nearest.X := P1.X + R * V.X;
        Nearest.Y := P1.Y + R * V.Y;
      End;
      D := Len2D( Sub2D( Poly1[I1], Nearest ) );
      If D < Distance Then
      Begin // smaller distance found
        Distance := D;
        Min1 := Poly1[I1];
        Min2 := Nearest;
      End;
    End;
  End;
End;

// Return the intersection rectangle (if any) of this and r

Function IntersectRect2D( Const r1, r2: TEzRect ): TEzRect;
Begin

  result.x1 := dmax( r1.x1, r2.x1 );
  result.y1 := dmax( r1.y1, r2.y1 );
  result.x2 := dmin( r1.x2, r2.x2 );
  result.y2 := dmin( r1.y2, r2.y2 );

  If ( result.x1 > result.x2 ) Or ( result.y1 > result.y2 ) Then
    result := NULL_EXTENSION; // no intersection

End;

Function UnionRect2D( Const r1, r2: TEzRect ): TEzRect;
Begin
  result.x1 := dmin( r1.x1, r2.x1 );
  result.y1 := dmin( r1.y1, r2.y1 );
  result.x2 := dmax( r1.x2, r2.x2 );
  result.y2 := dmax( r1.y2, r2.y2 );
End;

Function UnionRectAndPoint2D( Const R: TEzRect; const Pt: TEzPoint ): TEzRect;
begin
  result.x1 := dmin( R.x1, Pt.x );
  result.y1 := dmin( R.y1, Pt.y );
  result.x2 := dmax( R.x2, Pt.x );
  result.y2 := dmax( R.y2, Pt.y );
end;

Function IsRectEmpty2D( Const R: TEzRect ): Boolean;
Begin
  Result := CompareMem( @NULL_EXTENSION, @R, SizeOf( TEzRect ) );
End;

{function IsRectEmpty2D(const R: TEzRect): Boolean;
begin
  Result:= CompareMem(@R.X1, @R.X2, SizeOf(Double)) and
    CompareMem(@R.Y1, @R.Y2, SizeOf(Double));
end; }

Procedure OffsetRect2D( Var R: TEzRect; Const dx, dy: double );
Begin
  R.X1 := R.X1 + dx;
  R.X2 := R.X2 + dx;
  R.Y1 := R.Y1 + dy;
  R.Y2 := R.Y2 + dy;
End;

{ this function returns the perpendicular projection of point C on
  the lines that goes from A to B }

Function Perpend( Const C, A, B: TEzPoint ): TEzPoint;
Var
  r, L: Double;
Begin
  L := Dist2D( A, B );
  If L = 0 Then
  Begin
    Result := A;
    Exit;
  End;
  r := ( ( C.X - A.X ) * ( B.X - A.X ) + ( C.Y - A.Y ) * ( B.Y - A.Y ) ) / ( L * L );
  Result.X := A.X + r * ( B.X - A.X );
  Result.Y := A.Y + r * ( B.Y - A.Y );
End;


{ TIntegerList }

Constructor TIntegerList.Create;
Begin
  Inherited Create;
  FList := TList.Create;
End;

Destructor TIntegerList.Destroy;
Begin
  FList.Free;
  Inherited;
End;

Procedure TIntegerList.Assign( AList: TIntegerList );
{$IFNDEF LEVEL6}
Var
  I: Integer;
{$ENDIF}
begin
{$IFDEF LEVEL6}
  FList.Assign( AList.FList );
{$ELSE}
  FList.Clear;
  For I:= 0 to AList.Count-1 do
    FList.Add( AList.FList[I] );
{$ENDIF}
end;

Function TIntegerList.Add( Item: Integer ): Integer;
Begin
  result := FList.Add( Pointer( Item ) );
End;

Procedure TIntegerList.Clear;
Begin
  FList.Clear;
End;

Procedure TIntegerList.Delete( Index: Integer );
Begin
  FList.Delete( Index );
End;

Function TIntegerList.GetCount: Integer;
Begin
  result := FList.Count;
End;

function TIntegerList.GetLast: Integer;
begin
  Result := Get(Count - 1);
end;

Procedure TIntegerList.SetCount( Value: Integer );
Begin
  FList.Count := Value;
End;

Function TIntegerList.Get( Index: Integer ): Integer;
Begin
  result := Longint( FList[Index] );
End;

Procedure TIntegerList.Insert( Index, Value: Integer );
Begin
  FList.Insert( Index, Pointer( Value ) );
End;

Procedure TIntegerList.Put( Index, Value: Integer );
Begin
  FList[Index] := Pointer( Value );
End;

Function TIntegerList.IndexofValue( Item: Integer ): Integer;
Begin
  Result := FList.IndexOf( Pointer( item ) );
End;

Function TIntegerList.GetCapacity: Integer;
Begin
  result := FList.Capacity;
End;

Procedure TIntegerList.SetCapacity( Value: Integer );
Begin
  FList.Capacity := Value;
End;

Procedure TIntegerList.Sort;

  Procedure QuickSort( L, R: Integer );
  Var
    I, J: Integer;
    P, T: Integer;
  Begin
    Repeat
      I := L;
      J := R;
      P := Longint( FList[( L + R ) Shr 1] );
      Repeat
        While Longint( FList[I] ) < P Do
          Inc( I );
        While Longint( FList[J] ) > P Do
          Dec( J );
        If I <= J Then
        Begin
          T := Longint( FList[I] );
          FList[I] := Pointer( Longint( FList[J] ) );
          FList[J] := Pointer( T );
          Inc( I );
          Dec( J );
        End;
      Until I > J;
      If L < J Then
        QuickSort( L, J );
      L := I;
    Until I >= R;
  End;

Begin
  If FList.Count > 1 Then
    QuickSort( 0, FList.Count - 1 );
End;

procedure TIntegerList.LoadFromStream( Stream: TStream );
var
  I, N, Value: Integer;
Begin
  FList.Clear;
  with Stream do
  begin
    Read(N,SizeOf(N));
    for I:= 1 to N do
    Begin
      Read( Value, SizeOf(Value));
      FList.Add( Pointer(Value) );
    End;
  end;
End;

Procedure TIntegerList.SaveToStream( Stream: TStream );
var
  I, N, Value: Integer;
Begin
  N:= FList.Count;
  with Stream do
  begin
    Write(N,SizeOf(N));
    for I:= 0 to FList.Count-1 do
    Begin
      Value:= Longint( FList[I] );
      Write( Value, SizeOf(Value));
    End;
  end;
End;

Procedure TIntegerList.LoadFromFile( const FileName: string );
var
  s: TStream;
Begin
  if Not FileExists( FileName ) then Exit;
  s:= TFileStream.Create( FileName, fmOpenRead or fmShareDenyNone );
  Try
    LoadFromStream( s );
  Finally
    s.Free;
  End;
End;

Procedure TIntegerList.SaveToFile( const FileName: string );
var
  s: TStream;
Begin
  s:= TFileStream.Create( FileName, fmCreate );
  Try
    SaveToStream( s );
  Finally
    s.Free;
  End;
End;

function TIntegerList.Find(Value: Integer; var Index: Integer): Boolean;
var
  nLow: Integer;
  nHigh: Integer;
  nCheckPos: Integer;
//  C: Longint;
begin
  if FList.Count = 1 then
  begin
    Result := Longint(FList[0]) = Value;
    if Result then
      Index := 0;
    Exit;
  end;
  //
  nLow := 0;
  nHigh := Pred(FList.Count);
  Index := -1;
  Result := False;
  // keep searching until found or
  // no more items to search
  while nLow <= nHigh do
  begin
     nCheckPos := (nLow + nHigh) div 2;
//     C := Longint(FList[nCheckPos]) - Value;
     if Longint(FList[nCheckPos]) < Value then       // less than
       nLow := Succ(nCheckPos)
     else
     if Longint(FList[nCheckPos]) > Value then  // greater than
       nHigh := Pred(nCheckPos)
     else                                  // equal to
     begin
       Index := nCheckPos;
       Result := true;
       Exit;
     end;
  end;
end;

procedure TIntegerList.Reindex;
Var
  I, n, Last: Integer;
begin
  { this method is only used in conjunction with a TEzVector Parts property }
  If FList.Count = 0 Then Exit;
  { it is needed to reindex with repeated values }
  n := 0;
  Last := Longint( FList.Items[0] );
  I := 0;
  While I <= FList.Count - 1 Do
  Begin
    If Last <> Longint( FList.Items[I] ) Then
    Begin
      Inc( n );
      Last := Longint( FList.Items[I] );
    End;
    FList.Items[I] := Pointer( n );
    Inc( I );
  End;
end;

{-------------------------------------------------------------------------------}
{ TEzDoubleList class implementation                                            }
{-------------------------------------------------------------------------------}

Constructor TEzDoubleList.create;
Begin
  Inherited Create;
  FList := TList.Create;
End;

Destructor TEzDoubleList.destroy;
Begin
  Clear;
  FList.free;
  Inherited destroy;
End;

Function TEzDoubleList.GetCount: Integer;
Begin
  Result := FList.Count;
End;

Function TEzDoubleList.GetItem( Index: Integer ): Double;
Begin
  Result := PDouble( FList.Items[Index] )^;
End;

Procedure TEzDoubleList.SetItem( Index: Integer; Const Value: Double );
Begin
  PDouble( FList.Items[Index] )^ := Value;
End;

function TEzDoubleList.IndexOf(const Value: Double): Integer;
var
  I: Integer;
begin
  Result := -1;
  for I := 0 to Count - 1 do
    if Items[I] = Value then
    begin
      Result := I;
      Exit;
    end;
end;

Procedure TEzDoubleList.Insert( Index: Integer; Const Value: Double );
Var
  P: PDouble;
Begin
  New( P ); { Allocate Memory for Double }
  P^ := Value;
  FList.Insert( Index, P ); { Insert Double onto Internal List }
End;

Function TEzDoubleList.Add( Const Value: Double ): Integer;
Begin
  Result := Count;
  Insert( Count, Value );
End;

Procedure TEzDoubleList.Clear;
Var
  I: Integer;
Begin
  For I := 0 To Pred( FList.Count ) Do
    Dispose( PDouble( FList.Items[I] ) );
  FList.Clear;
End;

Procedure TEzDoubleList.Delete( Index: Integer );
Begin
  Dispose( PDouble( FList.Items[Index] ) );
  FList.Delete( Index );
End;
                                       
Procedure TEzDoubleList.Sort;

  Procedure QuickSort( L, R: Integer );
  Var
    I, J: Integer;
    P, T: Double;
  Begin
    Repeat
      I := L;
      J := R;
      P := PDouble( FList[( L + R ) Shr 1] )^;
      Repeat
        While PDouble( FList[I] )^ < P Do
          Inc( I );
        While PDouble( FList[J] )^ > P Do
          Dec( J );
        If I <= J Then
        Begin
          T := PDouble( FList[I] )^;
          PDouble( FList[I] )^ := PDouble( FList[J] )^;
          PDouble( FList[J] )^ := T;
          Inc( I );
          Dec( J );
        End;
      Until I > J;
      If L < J Then
        QuickSort( L, J );
      L := I;
    Until I >= R;
  End;

Begin
  If FList.Count > 0 Then
    QuickSort( 0, Pred(FList.Count) );
End;

End.
