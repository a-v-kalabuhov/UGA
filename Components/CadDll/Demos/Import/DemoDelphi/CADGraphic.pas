{************************************************************}
{                   Delphi VCL Extensions                    }
{                                                            }
{       Implementation for CAD DLL Entities import           }
{                                                            }
{      Copyright (c) 2002-2016 SoftGold software company     }
{                                                            }
{************************************************************}
unit CADGraphic;
{$I SGDXF.inc}
interface

uses
  Windows, Classes, Graphics, sgConsts
{$IFDEF SGDEL_XE2}, UITypes{$ENDIF};

type
  PCADDrawOptions = ^TCADDrawOptions;
  TCADDrawOptions = record
    LScale: Double;
    AllLayers: Boolean;
    HideDimensions: Boolean;
    Is3DFaceForAcis: Boolean;
    ProhibitArcsAsCurves: Boolean;
    SplitArcs: Boolean;
    SplittedSplines: Boolean;
    TextByCurves: Boolean;
    UseWinLine: Boolean;
  end;

  TCustomTransformation = class
  protected
    function GetOffset: TFPoint; virtual;
    function GetScale: TFPoint; virtual;
    procedure SetOffset(const Value: TFPoint); virtual;
    procedure SetScale(const Value: TFPoint); virtual;
    function GetCoord(const APoint: TFPoint): TFPoint; virtual; abstract;
  public
    function ToPixel(const ACoord: TFPoint): TPoint; virtual; abstract;
    property Scale: TFPoint read GetScale write SetScale;
    property Offset: TFPoint read GetOffset write SetOffset;
    property Coord[const APoint: TFPoint]: TFPoint read GetCoord; default;
  end;

  TCADPainterClass = class of TCustomCADPainter;

  TInvokeCADData = function(Sender: TObject; const AData: TcadData): Integer of object;

  TCustomCADPainter = class(TPersistent)
  private
    FTransformation: TCustomTransformation;
  protected
    function GetContext: TCanvas; virtual; abstract;
    procedure SetContext(const Value: TCanvas); virtual; abstract;
  public
    constructor Create(const ATransformation: TCustomTransformation); virtual;
    destructor Destroy; override;
    function DoInvoke(const AData: TcadData): Integer; virtual; abstract;
    procedure InitializeCADDrawOptions(AOptions: PCADDrawOptions); virtual; abstract;

    property Transformation: TCustomTransformation read FTransformation;
    property Context: TCanvas read GetContext write SetContext;
  end;

  TCADSharedImage = class(TSharedImage)
  private
    FHandle: THandle;
  protected
    procedure FreeHandle; override;
    property Handle: THandle read FHandle;
  end;

  TCADGraphicClass = class of TCADGraphic;

  TCADGraphic = class(TGraphic)
  private
    FExtLeft: Double;
    FExtTop: Double;
    FAbsWidth: Double;
    FAbsHeight: Double;
    FHWRatio: Double;
    FOptions: TCADDrawOptions;
    FImage: TCADSharedImage;
    FOnInvoke: TInvokeCADData;
    function GetUnits: Integer;
    procedure SetAllLayers(const Value: Boolean);
    procedure SetCurrentLayoutIndex(Value: Integer);
    procedure SetHideDimensions(const Value: Boolean);
    procedure SetIs3DFaceForAcis(const Value: Boolean);
    procedure SetProhibitArcsAsCurves(const Value: Boolean);
    procedure SetSplitArcs(const Value: Boolean);
    procedure SetSplittedSplines(const Value: Boolean);
    procedure SetTextByCurves(const Value: Boolean);
    procedure SetUseWinLine(const Value: Boolean);
    function GetCurrentLayoutIndex: Integer;
    function GetHandle: THandle;
    function GetCADEnumFlags: Integer;
  protected
    procedure Draw(ACanvas: TCanvas; const Rect: TRect); override;
    procedure Enumerate(AHandler: TCustomCADPainter); virtual;
    function GetEmpty: Boolean; override;
    function GetHeight: Integer; override;
    function GetWidth: Integer; override;
    procedure SetHeight(Value: Integer); override;
    procedure SetWidth(Value: Integer); override;
    procedure UpdateExtents; virtual;
    function HandleAllocated: Boolean;
    function DoInvokeCADData(const AData: TcadData): Integer;
    property SharedImage: TCADSharedImage read FImage;
  public
    constructor Create; override;
    destructor Destroy; override;
    procedure Assign(Source: TPersistent); override;
    procedure LoadFromFile(const Filename: string); override;
    procedure LoadFromStream(Stream: TStream); override;
    procedure SaveToStream(Stream: TStream); override;
    procedure LoadFromClipboardFormat(AFormat: Word; AData: THandle;
      APalette: HPALETTE); override;
    procedure SaveToClipboardFormat(var AFormat: Word; var AData: THandle;
      var APalette: HPALETTE); override;

    property Handle: THandle read GetHandle;
    property CurrentLayoutIndex: Integer read GetCurrentLayoutIndex write SetCurrentLayoutIndex;
    property Units: Integer read GetUnits;
    property AbsWidth: Double read FAbsWidth;
    property AbsHeight: Double read FAbsHeight;
    property ExtLeft: Double read FExtLeft;
    property ExtTop: Double read FExtTop;
    property OnInvoke: TInvokeCADData read FOnInvoke write FOnInvoke;

    property SplittedSplines: Boolean read FOptions.SplittedSplines write SetSplittedSplines;
    property TextByCurves: Boolean read FOptions.TextByCurves write SetTextByCurves;
    property Is3DFaceForAcis: Boolean read FOptions.Is3DFaceForAcis write SetIs3DFaceForAcis;
    property UseWinLine: Boolean read FOptions.UseWinLine write SetUseWinLine;
    property HideDimensions: Boolean read FOptions.HideDimensions write SetHideDimensions;
    property SplitArcs: Boolean read FOptions.SplitArcs write SetSplitArcs;
    property AllLayers: Boolean read FOptions.AllLayers write SetAllLayers;
    property ProhibitArcsAsCurves: Boolean read FOptions.ProhibitArcsAsCurves write
      SetProhibitArcsAsCurves;
  end;

var
  CADPainterClass: TCADPainterClass;

implementation

uses
  SysUtils, Math, CADIntf, sgLists, sgLines;

const
  SDXFImage = 'AutoCAD DXF';
  SDWGImage = 'AutoCAD DWG';
  SDWTImage = 'AutoCAD DWT';
  SHPGLImage = 'HPGL/2 image';
  SCGMImage = 'CGM image';
  SSVGImage = 'SVG image';
  SSTLImage = 'STL image';
  SSATImage = 'SAT image';

type
  TPoints3D = class(TFPointList)
  public
    procedure Wrap(AData: Pointer; ACount: Integer);
    procedure Unwrap;
  end;

  TLinesSplitProc = procedure(APoints, ADottedPoints: TFPointList;
    const AClose: Boolean) of object;
  TDrawPoly = function: Integer of object;

  TsgSplitLines = class(TsgLines)
  private
    procedure SplitLine(APoints, ADottedPoints: TFPointList;
      const AClose: Boolean);
  end;

  TContextTransformation = class(TCustomTransformation)
  private
    FScale: TFPoint;
    FOffset: TFPoint;
  protected
    function GetOffset: TFPoint; override;
    function GetScale: TFPoint; override;
    procedure SetOffset(const Value: TFPoint); override;
    procedure SetScale(const Value: TFPoint); override;
    function GetCoord(const ACoord: TFPoint): TFPoint; override;
  public
    constructor Create(const AScale: Double);
    function ToPixel(const ACoord: TFPoint): TPoint; override;
    function GetValue(const AValue: Double): Integer;
  end;

  { TPainterCanvas

    Wrapper for Windows GDI functions }
  TPainterCanvas = class(TCanvas)
  public
    procedure Polylines(const APoints; const ACounts: array of Integer);
    procedure Polygons(const APoints; const ACounts: array of Integer);
    function Save: Integer;
    function Restore(const ASavedDC: Integer = -1): Boolean;
    function GetDP(const ALP: TPoint): TPoint;
    function UpdateClip(ARgn: THandle = 0): THandle;
    procedure SetClip(ARgn: HRGN);
    function SetViewportOrg(P: TPoint): TPoint;
    function Select(const AObject: THandle): THandle;
    function SetTextAlign(ATextAlign: Cardinal): Cardinal;
  end;

  TStackItem = record
    Handle: THandle;
    SaveIndex: Integer;
  end;

  TStack = array of TStackItem;

  TCADPainter = class(TCustomCADPainter)
  private
    FPoints3D: TPoints3D;
    FDotted: TFPointList;
    FPointsLen: Integer;
    FPoints: PPoints;
    FCountsLen: Integer;
    FCounts: PsgIntegerArray;
    FLines: TsgSplitLines;
    FOptions: TCADDrawOptions;
    FOrg: TPoint;
    FPen: TPen;
    FBrush: TBrush;
    FFont: TFont;
    FBrushTmp: TBrush;

    FIsSolid: Boolean;
    FCurrSplit: TLinesSplitProc;
    FCurrRenderCoords: PFPoint;
    FCurrRenderCoordsCount: Integer;
    FDrawPoly: TDrawPoly;
    FStack: TStack;
    FStackIndex: Integer;
    FRgn: THandle;

    function CreateViewportRegion(APoints: PFPoint; ACount: Integer;
      ADrawBounds: Boolean): THandle;
    procedure BeginViewport;
    function CreatePolyPolyPoints(ACoords: PFPoint; APolyPointsCount: Integer): Integer;
    function CreateTransformList(ACoords: PFPoint; ACount: Integer): Integer;
    procedure DrawArcAsPoly(const AP0, AP1, AP2, AP3: TFPoint);
    procedure DrawByLineTo(ACoords: PFPoint; ACount: Integer; IsSolid: Boolean);

    procedure DoLines;
    procedure Draw3DFace;
    procedure DrawArc;
    procedure DrawHatch;
    procedure DrawImageEnt;
    procedure DrawInsert;
    procedure DrawLine;
    procedure DrawPoint;
    procedure DrawPoly;
    procedure DrawSolid;
    procedure DrawSpline;
    procedure DrawText;
    procedure EndViewport;

    function DrawPolyLines: Integer;
    function DrawWinLines: Integer;

    function GetRect(const R: TFRect): TRect;
    procedure GrowPoints(const ALen: Integer);
    procedure GrowCounts(const ALen: Integer);
    procedure FillCounts(ALen, AValue: Integer);
    procedure TransformList(ACoords: PFPoint; ACount: Integer; APoints: PPoint);

    function DoDrawDottedLines(ACount: Integer): Integer;
    function DoDrawPolyLine(ACount: Integer): Integer;
    procedure DoDrawPolyPolygon(const ACounts: array of Integer);
    function DoSplit: Boolean;
    function GetTransformValue(const AValue: Double): Integer;

    procedure Push(ASaveIndex: Integer);
    procedure Pop;
    procedure ApplyContextRegion(ARgn: THandle);
    function SetContextRegion(ARgn: THandle): THandle;
    procedure DoUpdateRegion;
  protected
    Data: PcadData;
    Canvas: TPainterCanvas;
    function DoInvoke(const AData: TcadData): Integer; override;
    procedure InitializeCADDrawOptions(AOptions: PCADDrawOptions); override;
    function GetContext: TCanvas; override;
    procedure SetContext(const Value: TCanvas); override;
  public
    constructor Create(const ATransformation: TCustomTransformation); override;
    destructor Destroy; override;
    property LScale: Double read FOptions.LScale write FOptions.LScale;
    property Lines: TsgSplitLines read FLines;
  end;

  { TMemoryStreamWrapper

    loadfromstream bitmap content.
    do not cahenge size!                }
  TMemoryStreamWrapper = class(TCustomMemoryStream)
  public
    constructor Create(AData: Pointer; ACount: Integer);
    destructor Destroy; override;
    function Write(const Buffer; Count: Longint): Longint; override;
  end;

  PcadPolyPoints = ^TcadPolyPoints;
  TcadPolyPoints = record
    Count: Integer; Padding: array[0 .. SizeOf(TFPoint) - SizeOf(Integer) - 1] of Byte;
    Points: array[0..0{Count - 1}] of TFPoint;
  end;

  PsgPointsPair = ^TsgPointsPair;
  TsgPointsPair = record
    First, Second: TPoint;
  end;
  PsgPointsPairs = ^TsgPointsPairs;
  TsgPointsPairs = array[Byte] of TsgPointsPair;

procedure RegisterCADFileFormat(const AExtensions: array of string;
  const ADescription: string);
var
  I: Integer;
begin
  for I := Low(AExtensions) to High(AExtensions) do
    TPicture.RegisterFileFormat(AExtensions[I], ADescription, TCADGraphic);
end;

procedure DelObj(var AGDIObject: THandle);
begin
  if AGDIObject <> 0 then
  begin
    DeleteObject(AGDIObject);
    AGDIObject := 0;
  end;
end;

{ TCustomCADPainter }

constructor TCustomCADPainter.Create(const ATransformation: TCustomTransformation);
begin
  FTransformation := ATransformation;
end;

destructor TCustomCADPainter.Destroy;
begin
  Context := nil;
  inherited Destroy;
end;

{ TPoints3D }

procedure TPoints3D.Wrap(AData: Pointer; ACount: Integer);
begin
  Attach(AData, ACount);
end;

procedure TPoints3D.Unwrap;
begin
  Attach(nil, 0);
end;

{ TMemoryStreamWrapper }

constructor TMemoryStreamWrapper.Create(AData: Pointer; ACount: Integer);
begin
  inherited Create;
  SetPointer(AData, ACount);
end;

destructor TMemoryStreamWrapper.Destroy;
begin
  SetPointer(nil, 0);
  inherited Destroy;
end;

function TMemoryStreamWrapper.Write(const Buffer; Count: Integer): Longint;
begin
  Result := 0;
end;

procedure DoPainterDraw(Data: PcadData; var Param); stdcall;
begin
  TCustomCADPainter(Pointer(Param)).DoInvoke(Data^);
end;

procedure DoCustomInvoke(Data: PcadData; var Param); stdcall;
begin
  TCADGraphic(Pointer(Param)).DoInvokeCADData(Data^);
end;

procedure CADError;
var Buf: array[Byte] of Char;
begin
  CADGetLastError(Buf);
  raise Exception.Create(Buf);
end;

procedure TsgSplitLines.SplitLine(APoints, ADottedPoints: TFPointList;
  const AClose: Boolean);
begin
  Line(APoints[0], APoints[1], ADottedPoints);
end;

{ PackPoly

  Extract equal sibling points of points array.
  Result - paked points count
  Note: no memory resize  }
function PackPoly(APoints: PPoints; ACount: Integer): Integer;
var
  I: Integer;
  vPacked: PPoints;
begin
  Result := 0;
  if ACount > 0 then
  begin
    if ACount > 1 then
    begin
      vPacked := APoints;
      I := 1;
      repeat
        if (APoints^[I].X <> vPacked^[Result].X) or (APoints^[I].Y <> vPacked^[Result].Y) then
        begin
          Inc(Result);
          vPacked^[Result] := APoints^[I];
        end;
        Inc(I);
      until I >= ACount;
    end;
    Inc(Result);
  end;
end;

{ PackDotted

  Extract equal sibling lines of lines array.
  Result - paked points count.
  Note: no memory resize  }
function PackDotted(APoints: PPoints; ACount: Integer): Integer;
var
  I, vLinesCount: Integer;
  vPairs: PsgPointsPairs;
  vDstPair: PsgPointsPair;
begin
  Result := 0;
  vLinesCount := ACount div 2;
  if vLinesCount > 1 then
  begin
    I := 1;
    vPairs := PsgPointsPairs(APoints);
    vDstPair := @vPairs^[0];
    repeat
      if (vDstPair^.First.X <> vPairs^[I].First.X) or
         (vDstPair^.First.Y <> vPairs^[I].First.Y) or
         (vDstPair^.Second.X <> vPairs^[I].Second.X) or
         (vDstPair^.Second.Y <> vPairs^[I].Second.Y) then
      begin
        Inc(Result);
        Inc(vDstPair);
        vDstPair^ := vPairs^[I];
      end;
      Inc(I);
    until I >= vLinesCount;
    Inc(Result);
  end
  else
    Result := vLinesCount;
  Result := Result shl 1;
end;

{  ExpandEmptyDottedLines

  Linear add pixcel to line, if it is dot }
function LineIsDot(const APair: TsgPointsPair): Boolean;
begin
  Result := (APair.First.X = APair.Second.X) and (APair.First.Y = APair.Second.Y);
end;
procedure ExpandEmptyDottedLines(APoints: PPoints; ACount: Integer);
var
  I, vLinesCount: Integer;
  vPairs: PsgPointsPairs;
  vDelta: TPoint;
begin
  vLinesCount := ACount div 2;
  vPairs := PsgPointsPairs(APoints);
  I := 0;
  vDelta := Point(0, 1);
  while I < vLinesCount - 1 do
  begin
    if LineIsDot(vPairs^[I]) then
    begin
      vDelta := Point(Sign(vPairs^[I+1].First.X - vPairs^[I].Second.X),
        Sign(vPairs^[I+1].First.Y - vPairs^[I].Second.Y));
      Inc(vPairs^[I].Second.X, vDelta.X);
      Inc(vPairs^[I].Second.Y, vDelta.Y);
    end;
    Inc(I);
  end;
  if LineIsDot(vPairs^[I]) then
  begin
    Inc(vPairs^[I].Second.X, vDelta.X);
    Inc(vPairs^[I].Second.Y, vDelta.Y);
  end;
end;

{ TCustomTransformation }

function TCustomTransformation.GetOffset: TFPoint;
begin
  Result := cnstFPointZero;
end;

function TCustomTransformation.GetScale: TFPoint;
begin
  Result := cnstFPointSingle;
end;

procedure TCustomTransformation.SetOffset(const Value: TFPoint);
begin
end;

procedure TCustomTransformation.SetScale(const Value: TFPoint);
begin
end;

{ TContextTransformation }

{ ToPixel

  Converts CADHandle units to pixels. }
function TContextTransformation.ToPixel(const ACoord: TFPoint): TPoint;
begin
  Result.X := Round(FScale.X * ACoord.X);
  Result.Y := -Round(FScale.Y * ACoord.Y);
end;

constructor TContextTransformation.Create(const AScale: Double);
begin
  FScale := MakeFPoint(AScale, AScale, AScale)
end;

function TContextTransformation.GetCoord(const ACoord: TFPoint): TFPoint;
begin
  Result.X := FScale.X * ACoord.X;
  Result.Y := FScale.Y * ACoord.Y;
  Result.Z := FScale.Z * ACoord.Z;
end;

function TContextTransformation.GetOffset: TFPoint;
begin
  Result := FOffset;
end;

function TContextTransformation.GetScale: TFPoint;
begin
  Result := FScale;
end;

function TContextTransformation.GetValue(const AValue: Double): Integer;
begin
  Result := Round(FScale.X * AValue);
end;

procedure TContextTransformation.SetOffset(const Value: TFPoint);
begin
  FOffset := Value;
end;

procedure TContextTransformation.SetScale(const Value: TFPoint);
begin
  FScale := Value
end;

{ TPainterCanvas }

function TPainterCanvas.GetDP(const ALP: TPoint): TPoint;
begin
  Result := ALP;
  LPtoDP(Handle, Result, 1);
end;

procedure TPainterCanvas.Polylines(const APoints;
  const ACounts: array of Integer);
begin
  PolyPolyline(Handle, APoints, ACounts[0], Length(ACounts));
end;

procedure TPainterCanvas.Polygons(const APoints;
  const ACounts: array of Integer);
begin
  PolyPolygon(Handle, PInteger(@APoints)^, PInteger(@ACounts[0])^, Length(ACounts));
end;

function TPainterCanvas.Restore(const ASavedDC: Integer = -1): Boolean;
begin
  Result := RestoreDC(Handle, ASavedDC);
end;

function TPainterCanvas.Save: Integer;
begin
  Result := SaveDC(Handle);
end;

function TPainterCanvas.Select(const AObject: THandle): THandle;
begin
  Result := SelectObject(Handle, AObject);
end;

procedure TPainterCanvas.SetClip(ARgn: HRGN);
begin
  SelectClipRgn(Handle, ARgn);
end;

function TPainterCanvas.SetTextAlign(ATextAlign: Cardinal): Cardinal;
begin
  Result := Windows.SetTextAlign(Handle, ATextAlign);
end;

function TPainterCanvas.SetViewportOrg(P: TPoint): TPoint;
begin
  SetViewportOrgEx(Handle, P.X, P.Y, @Result);
end;

function TPainterCanvas.UpdateClip(ARgn: THandle): THandle;
begin
  if ARgn = 0 then
    ARgn := CreateRectRgn(0, 0, 0, 0);
  if GetClipRgn(Handle, ARgn) <= 0 then
  begin
    DeleteObject(ARgn);
    ARgn := 0;
  end;
  Result := ARgn;
end;

{ TCADPainter }

procedure TCADPainter.InitializeCADDrawOptions(AOptions: PCADDrawOptions);
begin
  // initialize options
  if Assigned(AOptions) then
    FOptions := AOptions^;
  if FOptions.UseWinLine then
    FDrawPoly := DrawWinLines
  else
    FDrawPoly := DrawPolyLines;
end;

function TCADPainter.CreateViewportRegion(APoints: PFPoint; ACount: Integer;
  ADrawBounds: Boolean): THandle;
var
  R: TRect;
  vCount: Integer;
begin
  if ACount = 2 then
  begin
    R := GetRect(PFRect(APoints)^);
    if ADrawBounds then
      Canvas.Rectangle(R.Left, R.Top, R.Right, R.Bottom);
    Result := CreateRectRgnIndirect(R);
  end
  else
  begin
    vCount := CreatePolyPolyPoints(APoints, ACount);
    if ADrawBounds then
      Canvas.Polylines(FPoints^, Slice(FCounts^, ACount));
    Result := CreatePolyPolygonRgn(FPoints^, FCounts^, vCount, ALTERNATE);
  end;
end;

function TCADPainter.SetContextRegion(ARgn: THandle): THandle;
var
  P: TPoint;
begin
  P := Canvas.GetDP(Point(0, 0));
  OffsetRgn(ARgn, P.X, P.Y);
  if FRgn <> 0 then
    CombineRgn(FRgn, FRgn, ARgn, RGN_AND)
  else
    FRgn := ARgn;
  Canvas.SetClip(FRgn);
  if FRgn <> ARgn then
    Result := ARgn
  else
    Result := 0;
end;

procedure TCADPainter.SetContext(const Value: TCanvas);
var
  vNewContextOrigin: TPoint;
begin
  if Canvas <> Value then
  begin
    DelObj(FRgn);
    if Canvas <> nil then
    begin
      // restore context origin
      Canvas.SetViewportOrg(FOrg);
      // restore pen, brush and font
      Canvas.Pen.Assign(FPen);
      Canvas.Brush.Assign(FBrush);
      Canvas.Font.Assign(FFont);
    end;
    Canvas := TPainterCanvas(Value);
    // save pen, brush and font
    if Assigned(Canvas) then
    begin
      vNewContextOrigin.X := Round(FTransformation.Offset.X);
      vNewContextOrigin.Y := Round(FTransformation.Offset.Y);
      FOrg := Canvas.SetViewportOrg(vNewContextOrigin);
      FPen.Assign(Canvas.Pen);
      FBrush.Assign(Canvas.Brush);
      Canvas.Brush.Style := bsClear;
      FFont.Assign(Canvas.Font);
      DoUpdateRegion;
    end;
  end;
end;

constructor TCADPainter.Create(const ATransformation: TCustomTransformation);
begin
  inherited Create(ATransformation);
  FLines := TsgSplitLines.Create;
  FPoints3D := TPoints3D.Create;
  FDotted := TFPointList.Create;
  FPen := TPen.Create;
  FBrush := TBrush.Create;
  FFont := TFont.Create;
  FBrushTmp := TBrush.Create;
  FStackIndex := -1;
  SetLength(FStack, 0);
end;

destructor TCADPainter.Destroy;
begin
  Context := nil;
  // clear cache
  FreeMemAndNil(Pointer(FPoints));
  FPointsLen := 0;
  FreeMemAndNil(Pointer(FCounts));
  FCountsLen := 0;

  FLines.Free;
  FPoints3D.Free;
  FDotted.Free;
  FPen.Free;
  FBrush.Free;
  FFont.Free;
  FBrushTmp.Free;
  DelObj(FRgn);
  inherited Destroy;
end;

function TCADPainter.CreatePolyPolyPoints(ACoords: PFPoint;
  APolyPointsCount: Integer): Integer;
var
  I, C: Integer;
  P: PcadPolyPoints;
begin
  Result := APolyPointsCount;
  if APolyPointsCount > 0 then
  begin
    GrowCounts(APolyPointsCount);
    P := PcadPolyPoints(ACoords);
    C := 0;
    for I := 0 to APolyPointsCount - 1 do
    begin
      FCounts^[I] := P^.Count;
      Inc(C, FCounts^[I]);
      Inc(PFPoint(P), FCounts^[I] + 1);
    end;
    GrowPoints(C);
    P := PcadPolyPoints(ACoords);
    C := 0;
    for I := 0 to APolyPointsCount - 1 do
    begin
      TransformList(@P^.Points[0], FCounts^[I], @FPoints^[C]);
      Inc(C, FCounts^[I]);
      Inc(PFPoint(P), FCounts^[I] + 1);
    end;
  end;
end;

function TCADPainter.GetContext: TCanvas;
begin
  Result := Canvas;
end;

function TCADPainter.GetRect(const R: TFRect): TRect;
begin
  Result.TopLeft := FTransformation.ToPixel(R.TopLeft);
  Result.BottomRight := FTransformation.ToPixel(R.BottomRight);
  if Result.Right < Result.Left then
    SwapInts(Result.Right, Result.Left);
  if Result.Bottom < Result.Top then
    SwapInts(Result.Bottom, Result.Top);
end;

function TCADPainter.GetTransformValue(const AValue: Double): Integer;
begin
  Result := Round(AValue * FTransformation.Scale.X);
end;

procedure TCADPainter.GrowCounts(const ALen: Integer);
begin
  if ALen > FCountsLen then
  begin
    FreeMemAndNil(Pointer(FCounts));
    FCountsLen := ALen;
    GetMem(FCounts, FCountsLen * SizeOf(Integer));
  end;
end;

procedure TCADPainter.GrowPoints(const ALen: Integer);
begin
  if ALen > FPointsLen then
  begin
    FreeMemAndNil(Pointer(FPoints));
    FPointsLen := ALen;
    GetMem(FPoints, FPointsLen * SizeOf(TPoint));
  end;
end;

{ CreateTransformList

  Function converts the PFPoint-list to the PPoint-list
  with converting CADHandle units to pixels. }
function TCADPainter.CreateTransformList(ACoords: PFPoint; ACount: Integer): Integer;
begin
  Result := ACount;
  if Result > 0 then
  begin
    GrowPoints(Result);
    TransformList(ACoords, Result, @FPoints^[0]);
  end;
end;

procedure TCADPainter.TransformList(ACoords: PFPoint; ACount: Integer;
  APoints: PPoint);
var
  I: Integer;
begin
  for I := 0 to ACount - 1 do
    PPoints(APoints)^[I] := FTransformation.ToPixel(PFPointArray(ACoords)^[I]);
end;

function TCADPainter.DoSplit: Boolean;
begin
  Result := False;
  FDotted.Count := 0;
  if Assigned(FCurrSplit) then
  begin
    FPoints3D.Wrap(FCurrRenderCoords, FCurrRenderCoordsCount);
    try
      FCurrSplit(FPoints3D, FDotted, False);
      Result := True;
    finally
      FPoints3D.Unwrap;
    end;
  end;
end;

procedure TCADPainter.DoUpdateRegion;
begin
  FRgn := Canvas.UpdateClip(FRgn);
end;

procedure TCADPainter.DrawPoint;
var
  P: TPoint;
begin
  P := FTransformation.ToPixel(Data^.Point);// Data.Point - point position
  Canvas.Pixels[P.X, P.Y] := Canvas.Pen.Color;
end;

{ DrawByLineTo

  Draws a (poly)line in global coordinates. }
procedure TCADPainter.DrawByLineTo(ACoords: PFPoint; ACount: Integer; IsSolid: Boolean);
var
  I: Integer;
  P1, P2: TPoint;
  vCoords: PFPointArray;
begin
  if ACount > 0 then
  begin
    vCoords := PFPointArray(ACoords);
    if IsSolid then
    begin
      P1 := FTransformation.ToPixel(vCoords^[0]);
      if ACount > 1 then
      begin
        Canvas.MoveTo(P1.X, P1.Y);
        for I := 1 to ACount - 1 do
        begin
          P2 := P1;
          P1 := FTransformation.ToPixel(vCoords^[I]);
          if (P1.X <> P2.X) or (P1.Y <> P2.Y) then
            Canvas.LineTo(P1.X, P1.Y);
        end;
      end
      else
        Canvas.Pixels[P1.X, P1.Y] := Canvas.Pen.Color;
    end
    else
    begin
      I := 0;
      while I < ACount - 1 do
      begin
        P1 := FTransformation.ToPixel(vCoords^[I]);
        Inc(I);
        P2 := FTransformation.ToPixel(vCoords^[I]);
        // For correct drawing and scaling dots
        if (P2.X = P1.X) and (P2.Y = P1.Y) then
          Canvas.Pixels[P2.X, P2.Y] := Canvas.Pen.Color
        else
        begin
          Canvas.MoveTo(P1.X, P1.Y);
          Canvas.LineTo(P2.X, P2.Y);
        end;
        Inc(I);
      end;
    end;
  end;
end;

{ DoDrawDottedLines

  Draws a polyline on points of the prepared array.   }
function TCADPainter.DoDrawDottedLines(ACount: Integer): Integer;
begin
  Result := PackDotted(FPoints, ACount) shr 1;
  ExpandEmptyDottedLines(FPoints, Result shl 1);
  FillCounts(Result, 2);
  Canvas.Polylines(FPoints^, Slice(FCounts^, Result));
end;

{ DoDrawPolyLine

  Draws a only solid polyline on points of the prepared array }
function TCADPainter.DoDrawPolyLine(ACount: Integer): Integer;
begin
  Result := PackPoly(FPoints, ACount);
  if Result > 0 then
  begin
    if Result > 1 then
      Canvas.Polyline(Slice(FPoints^, Result))
    else
      Canvas.Pixels[FPoints^[0].X, FPoints^[0].Y] := Canvas.Pen.Color;
  end;
end;

{ DrawLine

  Draws a line.
  Data.Point - starting point
  Data.Point1 - ending point. }
procedure TCADPainter.DrawLine;
begin
  FCurrRenderCoords := @Data^.Point;
  FCurrRenderCoordsCount := 2;
  FIsSolid := Lines.IsSolid;
  FCurrSplit := Lines.SplitLine;
  if not FOptions.UseWinLine then
  begin
    FIsSolid := Data^.DashDotsCount = 0;
    FCurrSplit := nil;
    if not FIsSolid then
    begin
      FCurrRenderCoords := Data^.DashDots;
      FCurrRenderCoordsCount := Data^.DashDotsCount;
    end;
  end;
  FDrawPoly();
end;

{ DrawSolid

  4 points in Data
  The order in CADHandle file is 0-1-2-3. }
procedure TCADPainter.DrawSolid;
begin
  Canvas.Pen.Width := 0;
  GrowPoints(4);
  TransformList(@Data^.Point, 4, @FPoints^[0]);//Point,Point1,Point2,Point3
  DoDrawPolyPolygon([4]);
end;

procedure TCADPainter.Draw3DFace;
var
  vCount: Integer;
  P: PPoint;

  procedure Edge(const ACoords: array of TFPoint; var APts: PPoint;
    var ACount: Integer);
  begin
    TransformList(@ACoords[0], 2, APts);
    Inc(APts, 2);
    Inc(ACount);
  end;

begin
  vCount := 0;
  GrowPoints(8);
  P := @FPoints^[0];
  if Data^.Flags and 1 = 0 then
    Edge([Data^.Point, Data^.Point1], P, vCount);
  if Data^.Flags and 2 = 0 then
    Edge([Data^.Point1, Data^.Point2], P, vCount);
  if Data^.Flags and 4 = 0 then
    Edge([Data^.Point2, Data^.Point3], P, vCount);
  if Data^.Flags and 8 = 0 then
    Edge([Data^.Point3, Data^.Point], P, vCount);
  if vCount > 0 then
    DoDrawDottedLines(vCount shl 1);
end;

{ DrawPoly

  Draws a (poly)line in global coordinates.
  Data.Count - number of polyline vertices
  Data.Points - pointer to point array.    }
procedure TCADPainter.DrawPoly;
var
  vCount: Integer;
  vArrowPoints: PFPointArray;
begin
  FCurrRenderCoords := Data^.Points;
  FCurrRenderCoordsCount := Data^.Count;
  FIsSolid := Lines.IsSolid;
  FCurrSplit := Lines.Poly;
  if not FOptions.UseWinLine then
  begin
    FIsSolid := (Data^.DashDotsCount = 0) or
      (Assigned(Data^.CADExtendedData) and not Data^.CADExtendedData.IsDotted);
    FCurrSplit := nil;
    if not FIsSolid then
    begin
      FCurrRenderCoords := Data^.DashDots;
      FCurrRenderCoordsCount := Data^.DashDotsCount;
    end;
  end;
  FDrawPoly();
  // draw arrow
  if (Data^.CountPointOfSegments > 0) and (Data^.CountPointOfSegments mod 4 = 0) then
  begin
    vArrowPoints := PFPointArray(Data^.Points);
    Inc(PFPoint(vArrowPoints), Data^.Count);
    Canvas.Pen.Width := 0;
    FillCounts(Data^.CountPointOfSegments div 4, 4);
    vCount := CreateTransformList(@vArrowPoints^[0], Data^.CountPointOfSegments);
    DoDrawPolyPolygon(Slice(FCounts^, vCount div 4));
  end;
end;

function TCADPainter.DrawPolyLines: Integer;
var
  vCount: Integer;
begin
  if FIsSolid then
  begin
    vCount := CreateTransformList(FCurrRenderCoords, FCurrRenderCoordsCount);
    Result := DoDrawPolyLine(vCount);
  end
  else
  begin
    if DoSplit then
    begin
      FCurrRenderCoords := PFPoint(FDotted.List);
      FCurrRenderCoordsCount := FDotted.Count;
    end;
    vCount := CreateTransformList(FCurrRenderCoords, FCurrRenderCoordsCount);
    Result := DoDrawDottedLines(vCount);
  end;
end;

procedure TCADPainter.DoDrawPolyPolygon(const ACounts: array of Integer);
begin
  FBrushTmp.Assign(Canvas.Brush);
  try
    Canvas.Brush.Style := bsSolid;
    Canvas.Brush.Color := Canvas.Pen.Color;
    Canvas.Polygons(FPoints^, ACounts);
  finally
    Canvas.Brush.Assign(FBrushTmp);
  end;
end;

{ GetSpline

  Gets a spline.  }
function GetSpline(ControlPoints, FitPoints: TFPointList; Knots: TsgSingleList;
  ChordLen: Single): TFPointList;

  function Normalize(N, I: Integer; Param: Double): Double;
  var
    V1, D1, V2, D2: Double;
  begin
    if N = 0 then
    begin
      if (Single(Knots[I]) <= Param) and (Param < Single(Knots[I + 1])) then
        Result := 1
      else
        Result := 0;
    end
    else
    begin
      D1 := Single(Knots[I + N]) - Single(Knots[I]);
      V1 := (Param - Single(Knots[I])) * Normalize(N - 1, I, Param);
      if D1 = 0 then
        V1 := 0
      else
        V1 := V1 / D1;
      D2 := Single(Knots[I + N + 1]) - Single(Knots[I + 1]);
      V2 := (Single(Knots[I + N + 1]) - Param) * Normalize(N - 1, I + 1, Param);
      if D2 = 0 then
        V2 := 0
      else
        V2 := V2 / D2;
      Result := V1 + V2;
    end;
  end;

  function GetNURBS(Index: Integer; Param: Double): TFPoint;
  var
    I: Integer;
    Ni: Double;
  begin
    Result.X := 0;
    Result.Y := 0;
    Result.Z := 0;
    for I := Index - 3 to Index do
    begin
      Ni := Normalize(3, I, Param);
      Result.X := Result.X + ControlPoints[I].X * Ni;
      Result.Y := Result.Y + ControlPoints[I].Y * Ni;
      Result.Z := Result.Z + ControlPoints[I].Z * Ni;
    end;
  end;

  procedure AddPt(const Pt: TFPoint);
  begin
    Result.Add(Pt);
  end;

var
  I: Integer;
  P, Prev: TFPoint;
  T: Double;
begin
  Result := TFPointList.Create;
  P := ControlPoints[0];
  AddPt(P);
  Prev := P;
  for I := 3 to ControlPoints.Count - 1 do
  begin
    T := Knots[I];
    while  T < Knots[I + 1] do
    begin
      P := GetNURBS(I, T);
      T := T + 0.1; // the smaller value (for instance 0.01) the higher quality
      if (ChordLen > 0) and (abs(P.X - Prev.X) < ChordLen) and (abs(P.Y - Prev.Y) < ChordLen)
      then Continue;
      AddPt(P);
      Prev := P;
    end;
  end;
  P := ControlPoints[ControlPoints.Count - 1];
  AddPt(P);
end;

{ DrawSpline

  Draws a spline.  }
procedure TCADPainter.DrawSpline;
var
  I, vCnt: Integer;
  Knots: TsgSingleList;
  vPolyPointsParam: PcadPolyPoints;
  SingPoints: TFPointList;
  ControlPoints, FitPoints: TPoints3D;
  vDegree: Byte;
begin
  vDegree := Data^.Flags;
  ControlPoints := TPoints3D.Create;
  FitPoints := TPoints3D.Create;
  Knots := TsgSingleList.Create;
  try
    vCnt := Data^.Count;
    if vCnt > 0 then
      ControlPoints.Wrap(Data^.Points, vCnt);
    vPolyPointsParam := PcadPolyPoints(Data^.Points);
    Inc(PFPoint(vPolyPointsParam), vCnt);
    vCnt := vPolyPointsParam^.Count;
    vPolyPointsParam := @vPolyPointsParam^.Points[0];
    if vCnt > 0 then
      FitPoints.Wrap(vPolyPointsParam, vCnt);
    Inc(PFPoint(vPolyPointsParam), vCnt);
    vCnt := vPolyPointsParam^.Count;
    for I := 0 to vCnt - 1 do
      Knots.Add(vPolyPointsParam^.Points[I].X);

    if FOptions.SplittedSplines or (FitPoints.Count > ControlPoints.Count) or
       (vDegree <> 3) then
    begin
      FIsSolid := Lines.IsSolid;
      FCurrSplit := nil;
      FCurrRenderCoords := Data^.DashDots;
      FCurrRenderCoordsCount := Data^.DashDotsCount;
      FDrawPoly();
    end
    else
    begin
      SingPoints := GetSpline(ControlPoints, FitPoints, Knots, 0);
      try
        FIsSolid := Lines.IsSolid;
        FCurrSplit := Lines.Curve;
        FCurrRenderCoords := PFPoint(SingPoints.List);
        FCurrRenderCoordsCount := SingPoints.Count;
        FDrawPoly();
      finally
        SingPoints.Free;
      end;
    end;
  finally
    // Clearing memory
    ControlPoints.Unwrap;
    ControlPoints.Free;
    FitPoints.Unwrap;
    FitPoints.Free;
    Knots.Free;
  end;
end;

{ DrawText

  Draws a text. }
procedure TCADPainter.DrawText;
var
  P: TPoint;
  S: string;
  vTextDraw: Boolean;

  procedure DoFontFromData;
  var
    I: Integer;
    vLogFont: TLogFont;
    vFontName: string;
  begin
    GetObject(Canvas.Font.Handle, SizeOf(vLogFont), @vLogFont);
    FillChar(vLogFont.lfFaceName, LF_FACESIZE * SizeOf(vLogFont.lfFaceName[0]), 0);
    vFontName := string(WideString(Data^.FontName));
    I := Pos('.', vFontName);
    if I > 0 then SetLength(vFontName, I - 1);
    if vFontName = '' then vFontName := 'Arial';
    // setting real TrueType font
    StrPLCopy(@vLogFont.lfFaceName[0], vFontName, LF_FACESIZE);
    vLogFont.lfHeight := GetTransformValue(fWinTextHeightFactor * Data^.FHeight);
    if vLogFont.lfHeight = 0 then vLogFont.lfHeight := 1;
    vLogFont.lfWidth := Abs(GetTransformValue(0.64 * Data^.FHeight * Data^.FScale));
    if vLogFont.lfWidth = 0 then vLogFont.lfWidth := 1;
    vLogFont.lfEscapement := Round(Data^.Rotation * 10);	// in tenths of degrees
    while vLogFont.lfEscapement < 0 do
      Inc(vLogFont.lfEscapement, 3600);
    vLogFont.lfOrientation := vLogFont.lfEscapement;
    Canvas.Font.Handle := CreateFontIndirect(vLogFont);
  end;

  function DoDrawTextAsPoly: Boolean;
  var
    vCount: Integer;
  begin
    Result := Data^.DashDotsCount > 0;
    if Result then
    begin
      vCount := CreatePolyPolyPoints(Data^.DashDots, Data^.DashDotsCount);
      if Data^.Flags and 1 <> 0 then
        Canvas.Polylines(FPoints^, Slice(FCounts^, vCount)) // SHX text
      else
        DoDrawPolyPolygon(Slice(FCounts^, vCount)); // TTF text
    end;
  end;

begin
  vTextDraw := False;
  if FOptions.TextByCurves or (Data^.DashDotsCount > 0) then
    vTextDraw := DoDrawTextAsPoly;
  if not vTextDraw then
  begin
    if Data^.HAlign in [1,2,4] then
      P := FTransformation.ToPixel(Data^.Point1)
    else
      P := FTransformation.ToPixel(Data^.Point);
    DoFontFromData;
    Canvas.Font.Color := Canvas.Pen.Color;
    Canvas.SetTextAlign(TA_BASELINE);
    Canvas.Brush.Style := bsClear;
    S := string(WideString(Data^.Text));
    Canvas.TextOut(P.X, P.Y, S);
  end;
end;

function TCADPainter.DrawWinLines: Integer;
begin
  if not FIsSolid then
  begin
    if DoSplit then
    begin
      FCurrRenderCoords := PFPoint(FDotted.List);
      FCurrRenderCoordsCount := FDotted.Count;
    end;
  end;
  DrawByLineTo(FCurrRenderCoords, FCurrRenderCoordsCount, FIsSolid);
  Result := FCurrRenderCoordsCount;
end;

{ DrawArcAsPoly

  Draws a arc as poplyline. }
procedure TCADPainter.DrawArcAsPoly(const AP0, AP1, AP2, AP3: TFPoint);
const
  NSegs = 16; // Number of segments for full ellipse
var
  CX,CY,A,B,AStart,AEnd,Delta: Double;
  I: Integer;
  P, vReleaser: PFPoint;
  PX, PY: Extended;

  function Angle(const Pt: TFPoint): Extended;
  begin
    Result := ArcTan2(Pt.Y - CY, Pt.X - CX);
    if Result < 0 then Result := Result + Pi;
    if Pt.Y < CY then Result := Result + Pi;
  end;

begin
  CX := (AP0.X + AP1.X) / 2;      // Center X
  CY := (AP0.Y + AP1.Y) / 2;      // Center Y
  A := (AP1.X - AP0.X) / 2;       // Horizontal radius
  B := (AP0.Y - AP1.Y) / 2;       // Vertical radius
  AStart := Angle(AP2);          // Start angle
  AEnd := Angle(AP3);            // End angle

  if AEnd <= AStart then AEnd := AEnd + 2*Pi;
  FCurrRenderCoordsCount := Round((AEnd-AStart)/Pi*NSegs);   // Real number of segments depends on arc angle
  if FCurrRenderCoordsCount < 4 then FCurrRenderCoordsCount := 4;
  Delta := (AEnd-AStart)/(FCurrRenderCoordsCount-1);

  GetMem(vReleaser, FCurrRenderCoordsCount * SizeOf(TFPoint));
  try
    FCurrRenderCoords := vReleaser;
    P := vReleaser;
    for I := 0 to FCurrRenderCoordsCount - 1 do
    begin
      PY := P^.Y;
      PX := P^.X;
      SinCos(AStart, PY, PX);
      P^.X := CX + PX * A;
      P^.Y := CY + PY * B;
      P^.Z := 0;
      Inc(P);
      AStart := AStart + Delta;           // Next segment
    end;
    FIsSolid := Lines.IsSolid;
    FCurrSplit := Lines.Curve;
    FDrawPoly();
  finally
    if vReleaser <> nil then
      FreeMem(vReleaser);
  end;
end;

{ DrawArc

  Draws a arc.
  Data.Point, Data.Point1 - bounding rectangle
  Data.Point2 - starting point
  Data.Point3 - ending point
  For full ellipse, Point2 = Point3.             }
procedure TCADPainter.DrawArc;
var
  P, P1, P2, P3: TPoint;
  vRect: TRect;
  vRatio, vMajorLength: Single;
begin
  if FOptions.SplitArcs then
  begin
    DrawArcAsPoly(Data^.Point, Data^.Point1, Data^.Point2, Data^.Point3);
    Exit;
  end;
  P := FTransformation.ToPixel(Data^.Point);
  P1 := FTransformation.ToPixel(Data^.Point1);
  P2 := FTransformation.ToPixel(Data^.Point2);
  P3 := FTransformation.ToPixel(Data^.Point3);
  //Windows.SetArcDirection(PCanvas.Handle, AD_COUNTERCLOCKWISE);
  if ((Data^.Point2.X <> Data^.Point3.X)
    or (Data^.Point2.Y <> Data^.Point3.Y)) and (P2.X = P3.X)
    and (P2.Y = P3.Y) then
  begin
    Canvas.Pixels[P2.X, P2.Y] := Canvas.Pen.Color;
    Exit;
  end;
  if FOptions.ProhibitArcsAsCurves and (Data^.EntityType = 1) then
  begin
    vRatio := Data^.Ratio;
    P := FTransformation.ToPixel(Data^.Point);
    P1 := FTransformation.ToPixel(MakeFPoint(Data^.Point.X + Data^.Point1.X,
      Data^.Point.Y + Data^.Point1.Y, 0));
    vMajorLength := Sqrt(Sqr(P1.X - P.X) + Sqr(P1.Y - P.Y));
    vRect.Left := P.X - Round(vMajorLength);
    vRect.Top := P.Y + Round(vMajorLength * vRatio);
    vRect.Right := P.X + Round(vMajorLength);
    vRect.Bottom := P.Y - Round(vMajorLength * vRatio);
    Canvas.Arc(vRect.Left, vRect.Top, vRect.Right, vRect.Bottom, P2.X, P2.Y, P3.X, P3.Y);
  end
  else
    if Data^.StartAngle = Data^.EndAngle then
      Canvas.Pixels[P2.X, P2.Y] := Canvas.Pen.Color
    else
      Canvas.Arc(P.X, P1.Y, P1.X, P.Y, P2.X, P2.Y, P3.X, P3.Y);
end;

{ DrawHatch

  Draws a hatch.
  Data.Count - number of polyline vertices
  Data.Points - pointer to point array }
procedure TCADPainter.DrawHatch;
var
  vCount: Integer;
begin
  if Data^.Flags and 16 <> 0 then             // hatch is SOLID
  begin
    vCount := CreatePolyPolyPoints(Data^.Points, Data^.Count);
    DoDrawPolyPolygon(Slice(FCounts^, vCount));
  end
  else
    DrawByLineTo(Data^.DashDots, Data^.DashDotsCount, False);
end;

{ DrawImageEnt

  Draw a bitmap }
procedure TCADPainter.DrawImageEnt;
var
  vBitmap: TBitmap;
  vStream: TMemoryStreamWrapper;
  R: TRect;
begin
  vBitmap := TBitmap.Create;
  try
    vStream := TMemoryStreamWrapper.Create(Data^.Ticks, Data^.Handle);
    try
      vBitmap.LoadFromStream(vStream);
      R := GetRect(MakeFRect(Data^.Point.X, Data^.Point.Y, 0, Data^.Point3.X, Data^.Point3.Y, 0));
      Canvas.StretchDraw(R, vBitmap);
    finally
      vStream.Free;
    end;
  finally
    vBitmap.Free;
  end;
end;

procedure TCADPainter.DrawInsert;
var
  vCount: Integer;
begin
  if Data^.DashDotsCount > 0 then
  begin
    FCurrRenderCoords := Data^.DashDots;
    FCurrRenderCoordsCount := Data^.DashDotsCount;
    FIsSolid := Lines.IsSolid;
    if FIsSolid then
      FCurrSplit := nil
    else
      FCurrSplit := Lines.Poly;
    if Data.Flags and 1 <> 0 then
      vCount := FDrawPoly()
    else
      vCount := CreateTransformList(FCurrRenderCoords, FCurrRenderCoordsCount);
    if vCount > 2 then
    begin
      FStack[FStackIndex].SaveIndex := Canvas.Save;
      ApplyContextRegion(CreatePolygonRgn(FPoints^, vCount, ALTERNATE));
    end;
  end;
end;

procedure TCADPainter.ApplyContextRegion(ARgn: THandle);
begin
  ARgn := SetContextRegion(ARgn);
  DelObj(ARgn);
end;

{ BeginViewport

  Creates a clipping region according to the VIEWPORT's boundary.
  Makes necessary actions before drawing the VIEWPORT and his "contents".    }

procedure TCADPainter.BeginViewport;
var
  vRgn: THandle;
begin
  Push(Canvas.Save);
  if Data^.Count = 0 then
    vRgn := CreateViewportRegion(@Data^.Point, 2, Data^.Flags and 1 <> 0)
  else
    vRgn := CreateViewportRegion(Data^.Points, Data^.Count, Data^.Flags and 1 <> 0);
  ApplyContextRegion(vRgn);
end;

procedure TCADPainter.Push(ASaveIndex: Integer);
begin
  Inc(FStackIndex);
  if FStackIndex > High(FStack) then
    SetLength(FStack, FStackIndex + 1);
  FStack[FStackIndex].Handle := Data^.Handle;
  FStack[FStackIndex].SaveIndex := ASaveIndex;
end;

procedure TCADPainter.Pop;

  procedure DoRestore;
  begin
    Canvas.Restore(FStack[FStackIndex].SaveIndex);
    FStack[FStackIndex].Handle := 0;
    FStack[FStackIndex].SaveIndex := -1;
    DoUpdateRegion;
  end;

begin
  if FStackIndex >= 0 then
  begin
    case Data^.Tag of
      DXF_END_INSERT:
        if FStack[FStackIndex].SaveIndex <> -1 then
          DoRestore;
    else
      DoRestore
    end;
    Dec(FStackIndex);
  end;
end;

{ EndViewport

  Makes necessary actions after drawing the VIEWPORT and his "contents".    }

procedure TCADPainter.EndViewport;
begin
  Pop;
end;

procedure TCADPainter.FillCounts(ALen, AValue: Integer);
var
  I: Integer;
begin
  GrowCounts(ALen);
  for I := 0 to ALen - 1 do
    FCounts^[I] := AValue;
end;

{ DoLines

  Creates the list of ticks.
  For complex types of lines:
     Data.TicksCount =0 and Data.DashDotsCount <> 0 }
procedure TCADPainter.DoLines;
var
  I: Integer;
  P: PsgSingleArray;
begin
  Lines.Clear;
  Lines.Scale := Data^.Rotation * LScale;
  P := PsgSingleArray(Data^.Ticks);
  for I := 0 to Data^.TickCount - 1 do
    Lines.AddTick(P^[I]);
  Lines.Loaded(nil);
end;

{ TCADPainter.DrawEntity

  Called from CADEnum for each entity in CADHandle file
  Data points to entity data
  Param is user-defined parameter. }
function TCADPainter.DoInvoke(const AData: TcadData): Integer;

  procedure UpdateEntityHandleStack;
  begin
    if FStackIndex >= 0 then
      FStack[FStackIndex].Handle := Data^.Handle;
  end;

begin
  Result := 0;
  Data := @AData;
  if (Data^.Dimension <> 0) and FOptions.HideDimensions then Exit;
  Canvas.Pen.Color := TColor(Data^.Color);      // entity color
  Canvas.Pen.Width := GetTransformValue(Data^.Thickness);
  DoLines;
  case Data^.Tag of
    DXF_LINE:                           DrawLine;
    DXF_SOLID:                          DrawSolid;
    DXF_3DFACE:                         Draw3DFace;
    DXF_CIRCLE,DXF_ARC,DXF_ELLIPSE:     DrawArc;
    DXF_POLYLINE..DXF_LWPOLYLINE:       DrawPoly;
    DXF_SPLINE:                         DrawSpline;
    DXF_TEXT, DXF_ATTDEF, DXF_ATTRIB:   DrawText;
    DXF_POINT:		                      DrawPoint;
    DXF_HATCH:                          DrawHatch;
    DXF_IMAGE_ENT:                      DrawImageEnt;
    DXF_BEGIN_VIEWPORT:                 BeginViewport;
    DXF_END_VIEWPORT:                   EndViewport;
    DXF_BEGIN_INSERT:                   Push(-1);
// ------------------------------------------------------
// ---- patch code to perform insert stack top item -----
// Because Data^.Handle == 0 for Tag == DXF_BEGIN_INSERT.
// Do perform last stack item
    DXF_INSERT:
      begin
        UpdateEntityHandleStack;
        DrawInsert;
      end;
    DXF_MTEXT, DXF_DIMENSION:           UpdateEntityHandleStack;
// ------------------------------------------------------
    DXF_END_INSERT:                     Pop;
  end;
end;

{ TCADSharedImage }

procedure TCADSharedImage.FreeHandle;
begin
  if FHandle <> 0 then
  begin
    CADClose(FHandle);
    FHandle := 0;
  end;
end;

{ TCADGraphic }

procedure TCADGraphic.Assign(Source: TPersistent);
begin
  if (Source is TCADGraphic) and (Source <> Self) then
  begin
    FImage.Release;
    FImage := TCADGraphic(Source).FImage;
    FImage.Reference;
    FOptions := TCADGraphic(Source).FOptions;
    UpdateExtents;
  end
  else
    inherited Assign(Source);
end;

constructor TCADGraphic.Create;
begin
  inherited Create;
  Transparent := True;
  FOptions.SplittedSplines := True;
  FOptions.TextByCurves := True;
  FOptions.SplitArcs := True;
  FOptions.HideDimensions := False;

  FImage := TCADSharedImage.Create;
  FImage.Reference;
end;

destructor TCADGraphic.Destroy;
begin
  FImage.Release;
  inherited Destroy;
end;

function TCADGraphic.DoInvokeCADData(const AData: TcadData): Integer;
begin
  Result := 0;
  if Assigned(FOnInvoke) then
    Result := FOnInvoke(Self, AData);
end;

{ TCADGraphic.Enumerate

  Use bit-coded CADEnum flag =4 for setting a way of cutting a viewport's
  contents to fit a "rectangular" VIEWPORT, without using Windows API REGIONS.
  If you have no possibility to use Windows API REGIONS
  (for example, you use OpenGL or something similar), set this flag.
  Handle with TCADGraphic.OnIvoke event }
procedure TCADGraphic.Enumerate;
begin
  if HandleAllocated then
    CADEnum(Handle, GetCADEnumFlags, @DoCustomInvoke, Self);
end;

procedure TCADGraphic.Draw(ACanvas: TCanvas; const Rect: TRect);
var
  vOffset: TFPoint;
  vTransformation: TContextTransformation;
  vCADPainter: TCustomCADPainter;
begin
  if not Empty then
  begin
    vTransformation := TContextTransformation.Create((Rect.Right - Rect.Left) / AbsWidth);
    try
      // set context offset
      vOffset := vTransformation[MakeFPoint(ExtLeft, ExtTop)];
      vOffset.X := Rect.Left - vOffset.X;
      vOffset.Y := Rect.Top + vOffset.Y;
      vOffset.Z := 0;
      vTransformation.Offset := vOffset;
      vCADPainter := CADPainterClass.Create(vTransformation);
      try
        vCADPainter.Context := ACanvas;
        vCADPainter.InitializeCADDrawOptions(@FOptions);
        CADEnum(Handle, GetCADEnumFlags, @DoPainterDraw, vCADPainter);// use CADEnum for import as a linear "metafile"
      finally
        vCADPainter.Free;
      end;
    finally
      vTransformation.Free;
    end;
  end;
end;

function TCADGraphic.GetCADEnumFlags: Integer;
begin
  Result := Ord(FOptions.AllLayers);
//  Result := Result or 2; // top view
//  Result := Result or Ord(CutViewport) shl 2;
  Result := Result or Ord(FOptions.TextByCurves) shl 3;
  Result := Result or ord(FOptions.Is3DFaceForAcis) shl 4;
end;

function TCADGraphic.GetCurrentLayoutIndex: Integer;
begin
  Result := -1;
  if HandleAllocated then
    if CADLayoutCurrent(Handle, DWORD(Result), False) = 0 then CADError;
end;

function TCADGraphic.GetEmpty: Boolean;
begin
  Result := (Handle = 0) or ((AbsWidth = 0) or (AbsHeight = 0));
end;

function TCADGraphic.GetHandle: THandle;
begin
  Result := FImage.Handle;
end;

function TCADGraphic.GetHeight: Integer;
begin
  if FHWRatio > 1 then
    Result := MaxInt
  else
    Result := Round(FHWRatio * MaxInt);
end;

function TCADGraphic.GetUnits: Integer;
begin
  Result := 0;
  if HandleAllocated then
    if CADUnits(Handle, Result) = 0 then CADError;
end;

function TCADGraphic.GetWidth: Integer;
begin
  if FHWRatio < 1 then
    Result := MaxInt
  else
    Result := Round(MaxInt / FHWRatio);
end;

function TCADGraphic.HandleAllocated: Boolean;
begin
  Result := FImage.Handle <> 0;
end;

procedure TCADGraphic.LoadFromClipboardFormat(AFormat: Word; AData: THandle;
  APalette: HPALETTE);
begin
end;

procedure TCADGraphic.LoadFromFile(const Filename: string);
begin
  FImage.Release;
  FImage := TCADSharedImage.Create;
  FImage.FHandle := CADCreate(0, PWideChar(WideString(Filename)));
  FImage.Reference;
  if not HandleAllocated then CADError;
  if CADLTScale(Handle, FOptions.LScale) = 0 then CADError;
  if CADProhibitCurvesAsPoly(Handle, Ord(not FOptions.ProhibitArcsAsCurves)) = 0 then CADError;
  UpdateExtents;
end;

procedure TCADGraphic.LoadFromStream(Stream: TStream);
begin
end;

procedure TCADGraphic.SaveToClipboardFormat(var AFormat: Word;
  var AData: THandle; var APalette: HPALETTE);
begin
end;

procedure TCADGraphic.SaveToStream(Stream: TStream);
begin
end;

procedure TCADGraphic.SetAllLayers(const Value: Boolean);
begin
  if FOptions.AllLayers <> Value then
  begin
    FOptions.AllLayers := Value;
    Changed(Self);
  end;
end;

procedure TCADGraphic.SetCurrentLayoutIndex(Value: Integer);
begin
  if GetCurrentLayoutIndex <> Value then
  begin
    if HandleAllocated then
    begin
      if CADLayoutCurrent(Handle, DWORD(Value), True) = 0 then CADError;
      UpdateExtents;
    end;
  end;
end;

procedure TCADGraphic.SetHeight(Value: Integer);
begin
end;

procedure TCADGraphic.SetHideDimensions(const Value: Boolean);
begin
  if FOptions.HideDimensions <> Value then
  begin
    FOptions.HideDimensions := Value;
    Changed(Self);
  end;
end;

procedure TCADGraphic.SetIs3DFaceForAcis(const Value: Boolean);
begin
  if FOptions.Is3DFaceForAcis <> Value then
  begin
    FOptions.Is3DFaceForAcis := Value;
    Changed(Self);
  end;
end;

procedure TCADGraphic.SetProhibitArcsAsCurves(const Value: Boolean);
begin
  if FOptions.ProhibitArcsAsCurves <> Value then
  begin
    FOptions.ProhibitArcsAsCurves := Value;
    if HandleAllocated then
      if CADProhibitCurvesAsPoly(Handle, Ord(not FOptions.ProhibitArcsAsCurves)) = 0 then
        CADError;
    Changed(Self);
  end;
end;

procedure TCADGraphic.SetSplitArcs(const Value: Boolean);
begin
  if FOptions.SplitArcs <> Value then
  begin
    FOptions.SplitArcs := Value;
    Changed(Self);
  end;
end;

procedure TCADGraphic.SetSplittedSplines(const Value: Boolean);
begin
  if FOptions.SplittedSplines <> Value then
  begin
    FOptions.SplittedSplines := Value;
    Changed(Self);
  end;
end;

procedure TCADGraphic.SetTextByCurves(const Value: Boolean);
begin
  if FOptions.TextByCurves <> Value then
  begin
    FOptions.TextByCurves := Value;
    Changed(Self);
  end;
end;

procedure TCADGraphic.SetUseWinLine(const Value: Boolean);
begin
  if FOptions.UseWinLine <> Value then
  begin
    FOptions.UseWinLine := Value;
    Changed(Self);
  end;
end;

procedure TCADGraphic.SetWidth(Value: Integer);
begin
end;

procedure TCADGraphic.UpdateExtents;
begin
  if HandleAllocated then
  begin
    CADGetBox(Handle, FExtLeft, FAbsWidth, FExtTop, FAbsHeight);
    FAbsWidth := Abs(FAbsWidth - FExtLeft);
    FAbsHeight := Abs(FExtTop - FAbsHeight);
  end
  else
  begin
    FAbsWidth := 0;
    FAbsHeight := 0;
    FExtLeft := 0;
    FExtTop := 0;
    FHWRatio := 1;
  end;
  if FAbsWidth <> 0 then
    FHWRatio := FAbsHeight / FAbsWidth;
  Changed(Self);
end;

initialization
  CADPainterClass := TCADPainter;
  RegisterCADFileFormat(['brep'], cnstDescrBrep);
  RegisterCADFileFormat(['step','stp'], cnstDescrSTEP);
  RegisterCADFileFormat(['iges','igs'], cnstDescrIGES);
  RegisterCADFileFormat(['sat'], SSATImage);
  RegisterCADFileFormat(['stl'], SSTLImage);
  RegisterCADFileFormat(['svg','svgz'], SSVGImage);
  RegisterCADFileFormat(['cgm'], SCGMImage);
  RegisterCADFileFormat(['pcl','plt','hgl','hg','hpg','plo','hp','hpp','hp1',
    'hp2','hp3','hpgl','hpgl2','gl','gl2','prn','spl','rtl'], SHPGLImage);
  RegisterCADFileFormat(['dwt'], SDWTImage);
  RegisterCADFileFormat(['dwg', 'gp2'], SDWGImage);
  RegisterCADFileFormat(['dxf'], SDXFImage);

finalization

  TPicture.UnRegisterGraphicClass(TCADGraphic);

end.
