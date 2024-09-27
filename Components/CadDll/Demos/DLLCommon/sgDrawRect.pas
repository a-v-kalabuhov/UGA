{************************************************************}
{                   Delphi VCL Extensions                    }
{                                                            }
{   Lite implementation for control graphic draw rectangle   }
{                                                            }
{      Copyright (c) 2002-2017 SoftGold software company     }
{                                                            }
{************************************************************}
unit sgDrawRect;

interface

uses
  {$IFDEF FPC}LCLIntf{$ELSE}Windows{$ENDIF}, Classes;

type
  TDrawRect = class(TPersistent)
  private
    FLeft: Double;
    FTop: Double;
    FWidth: Double;
    FHeight: Double;
    FOnChanged: TNotifyEvent;
    FOnMoved: TNotifyEvent;
    FOnScaled: TNotifyEvent;
    function GetRoundRect: TRect;
    function GetCenter: TPoint;
  protected
    procedure DoChanged; dynamic;
    procedure DoScale; dynamic;
    procedure DoMove; dynamic;
    function CheckBounds(const ALeft, ATop, AWidth, AHeight: Double): Boolean; virtual;
    procedure UpdateBounds(ALeft, ATop, AWidth, AHeight: Double);
  public
    procedure GetCenter2D(var X, Y: Double);
    function SetRect(const ARect: TRect): Boolean; overload;
    function SetRect(const ALeft, ATop, ARight, ABottom: Double): Boolean; overload;
    function SetBounds(ALeft, ATop, AWidth, AHeight: Double): Boolean; virtual;
    function Scale(const AScale: Double; const APosX, APosY: Double): Boolean; overload; virtual;
    function Scale(const AScale: Double; const APos: TPoint): Boolean; overload;
    function FitTo(const AClientRect: TRect; AHWRatio: Double): Boolean; virtual;
    function Offset(ADX, ADY: Double): Boolean; virtual;
    function Zoom(AViewport, ARect: TRect): Boolean; virtual;
    function ZoomInEnabled: Boolean; virtual;
    function ZoomOutEnabled: Boolean; virtual;
    function Empty: Boolean;
    property RoundRect: TRect read GetRoundRect;
    property OnChanged: TNotifyEvent read FOnChanged write FOnChanged;
    property OnScaled: TNotifyEvent read FOnScaled write FOnScaled;
    property OnMoved: TNotifyEvent read FOnMoved write FOnMoved;
    property Center: TPoint read GetCenter;
    property Left: Double read FLeft;
    property Top: Double read FTop;
    property Width: Double read FWidth;
    property Height: Double read FHeight;
  end;

implementation

function SwapInts(var A, B: Integer): Integer;
begin
  Result := A;
  A := B;
  B := Result;
end;

procedure NormalRect(var R: TRect);
begin
  if R.Left > R.Right then SwapInts(R.Left, R.Right);
  if R.Top > R.Bottom then SwapInts(R.Top, R.Bottom);
end;

function IsZoomInEnabled(AWidth, AHeight: Double): Boolean;
const
  cnstMaxSize: Double = (2.0 * MaxInt) / 3.0;
begin
  Result := (AWidth < cnstMaxSize) and (AHeight < cnstMaxSize);
end;

{ TDrawRect }

function TDrawRect.CheckBounds(const ALeft, ATop, AWidth,
  AHeight: Double): Boolean;
begin
  Result := (AWidth > 1) and (AHeight > 1) and IsZoomInEnabled(AWidth, AHeight);
end;

procedure TDrawRect.DoChanged;
begin
  if Assigned(FOnChanged) then
    FOnChanged(Self);
end;

procedure TDrawRect.DoMove;
begin
  if Assigned(FOnMoved) then
    FOnMoved(Self);
end;

procedure TDrawRect.DoScale;
begin
  if Assigned(FOnScaled) then
    FOnScaled(Self);
end;

function TDrawRect.Empty: Boolean;
begin
  Result := IsRectEmpty(RoundRect);
end;

function TDrawRect.FitTo(const AClientRect: TRect; AHWRatio: Double): Boolean;
var
  vHeightByWidth, vNewWidth, vNewHeight: Double;
begin
  vNewWidth := AClientRect.Right - AClientRect.Left;
  vNewHeight := AClientRect.Bottom - AClientRect.Top;
  vHeightByWidth := vNewWidth * AHWRatio;
  if vHeightByWidth > vNewHeight then
    vNewWidth := vNewHeight / AHWRatio
  else
    vNewHeight := vHeightByWidth;
  Result := SetBounds(0.5 * (AClientRect.Left + AClientRect.Right - vNewWidth),
    0.5 * (AClientRect.Top + AClientRect.Bottom - vNewHeight), vNewWidth, vNewHeight);
end;

procedure TDrawRect.GetCenter2D(var X, Y: Double);
begin
  X := FLeft + 0.5 * FWidth;
  Y := FTop + 0.5 * FHeight;
end;

function TDrawRect.GetCenter: TPoint;
var
  X, Y: Double;
begin
  GetCenter2D(X, Y);
  Result.X := Round(X);
  Result.Y := Round(Y);
end;

function TDrawRect.GetRoundRect: TRect;
begin
  Result.Left := Round(Int(FLeft));
  Result.Top := Round(Int(FTop));
  Result.Right := Result.Left + Round(FWidth);
  Result.Bottom := Result.Top + Round(FHeight);
end;

function TDrawRect.Offset(ADX, ADY: Double): Boolean;
begin
  Result := False;
  if (ADX <> 0) or (ADY <> 0) then
    Result := SetBounds(FLeft + ADX, FTop + ADY, FWidth, FHeight);
end;

function TDrawRect.Scale(const AScale, APosX, APosY: Double): Boolean;
begin
  Result := SetBounds((FLeft - APosX) * AScale + APosX,
    (FTop - APosY) * AScale + APosY, FWidth * AScale, FHeight * AScale);
end;

function TDrawRect.Scale(const AScale: Double; const APos: TPoint): Boolean;
begin
  Result := Scale(AScale, APos.X, APos.Y);
end;

function TDrawRect.SetBounds(ALeft, ATop, AWidth, AHeight: Double): Boolean;
var
  vMoved, vScaled: Boolean;
begin
  Result := False;
  if CheckBounds(ALeft, ATop, AWidth, AHeight) then
  begin
    vMoved := (FLeft <> ALeft) or (FTop <> ATop);
    vScaled := (FWidth <> AWidth) or (FHeight <> AHeight);
    UpdateBounds(ALeft, ATop, AWidth, AHeight);
    if vScaled then
      DoScale
    else
      if vMoved then
        DoMove
      else
        DoChanged;
    Result := True;
  end;
end;

function TDrawRect.SetRect(const ALeft, ATop, ARight, ABottom: Double): Boolean;
begin
  Result := SetBounds(ALeft, ATop, ARight - ALeft, ABottom - ATop);
end;

procedure TDrawRect.UpdateBounds(ALeft, ATop, AWidth, AHeight: Double);
begin
  FLeft := ALeft;
  FTop := ATop;
  FWidth := AWidth;
  FHeight := AHeight;
end;

function TDrawRect.SetRect(const ARect: TRect): Boolean;
begin
  Result := SetBounds(ARect.Left, ARect.Top, ARect.Right - ARect.Left, ARect.Bottom - ARect.Top);
end;

function TDrawRect.ZoomInEnabled: Boolean;
begin
  Result := IsZoomInEnabled(FWidth, FHeight);
end;

function TDrawRect.ZoomOutEnabled: Boolean;
begin
  Result := (FWidth > 1) and (FHeight > 1);
end;

function TDrawRect.Zoom(AViewport, ARect: TRect): Boolean;
var
  vRectCenter, vViewportCenter: TPoint;
  vRectW, vRectH, vViewportW, vViewportH: Integer;
  vScaleW, vScaleH, vScale: Double;
  vNewLeft, vNewTop: Double;
begin
  Result := False;
  NormalRect(ARect);
  NormalRect(AViewport);
  vRectCenter.X := (ARect.Right + ARect.Left) div 2;
  vRectCenter.Y := (ARect.Bottom + ARect.Top) div 2;
  vRectW := ARect.Right - ARect.Left;
  vRectH := ARect.Bottom - ARect.Top;

  if (vRectW > 0) and (vRectH > 0) then
  begin
    vViewportCenter.X := (AViewport.Right + AViewport.Left) div 2;
    vViewportCenter.Y := (AViewport.Bottom + AViewport.Top) div 2;
    vViewportW := AViewport.Right - AViewport.Left;
    vViewportH := AViewport.Bottom - AViewport.Top;

    vScaleW := vViewportW / vRectW;
    vScaleH := vViewportH / vRectH;
    if vScaleW * vRectH > vViewportH then
      vScale := vScaleH
    else
      vScale := vScaleW;
    vNewLeft := (FLeft - vRectCenter.X) * vScale + vViewportCenter.X;
    vNewTop := (FTop - vRectCenter.Y) * vScale + vViewportCenter.Y;
    Result := SetBounds(vNewLeft, vNewTop, FWidth * vScale, FHeight * vScale);
  end;
end;

end.
