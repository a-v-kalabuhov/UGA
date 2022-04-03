unit ImageBox;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ExtCtrls, GrphUtil, Math;

type
  TTickKind=(tkTopLeft,tkTop,tkTopRight,tkLeft,tkRight,tkBottomLeft,
    tkBottom,tkBottomRight,tkRotate);

  TSetTicks=Set of TTickKind;

  TTick=class(TGraphicControl)
  private
    FKind: TTickKind;
    FSize: Integer;
    FEnabled: Boolean;
    X0,Y0,DX,DY,LX,LY: Integer;
    LineDC: HDC;
    Dragging: Boolean;
    Corner: Integer;
    property Width;
    property Height;
    procedure SetKind(Value: TTickKind);
    procedure SetSize(Value: Integer);
    procedure SetPosition;
    procedure SetCursor;
    procedure SetColor;
  protected
    property Canvas;
    property Size: Integer read FSize write SetSize default 7;
    procedure Paint; override;
    procedure SetEnabled(Value: Boolean); override;
    procedure MouseDown(Button: TMouseButton; Shift: TShiftState;
      X, Y: Integer); override;
    procedure MouseMove(Shift: TShiftState; X, Y: Integer); override;
    procedure MouseUp(Button: TMouseButton; Shift: TShiftState;
      X, Y: Integer); override;
  public
    property Kind: TTickKind
      read FKind write SetKind default tkTopLeft;
    constructor Create(AOwner: TComponent); override;
  published
    property Color default clBlack;
    property Enabled: Boolean read FEnabled write SetEnabled default True;
    property Visible;
    property OnMouseDown;
    property OnMouseMove;
    property OnMouseUp;
  end;

  TImageBox=class(TCustomControl)
  private
    FOnPaint: TNotifyEvent;
    FTicks: Array[0..8] of TTick;
    FTicksEnabled: TSetTicks;
    FActive: Boolean;
    FOnResize: TNotifyEvent;
    FBorder: TPenStyle;
    FMovable: Boolean;
    FTicksSize: Integer;
    FCorner: Integer;
    FResizeProportional: Boolean;
    FOnMove: TNotifyEvent;
    FOnRotate: TNotifyEvent;
    DrawMode: TDrawMode;
    X0,Y0,DX,DY: Integer;
    LineDC: HDC;
    Dragging: Boolean;
    FMinWidth,FMinHeight: Integer;
//    function GetTicks(Index: Integer): TTick;
    procedure SetActive(Value: Boolean);
    procedure SetTicksEnabled(Value: TSetTicks);
    procedure SetBorder(Value: TPenStyle);
    procedure SetTicksSize(Value: Integer);
    procedure SetCorner(Value: Integer);
    procedure SetResizeProportional(Value: Boolean);
    procedure SetTicksPosition;
  protected
    procedure MouseDown(Button: TMouseButton; Shift: TShiftState;
      X, Y: Integer); override;
    procedure MouseMove(Shift: TShiftState; X, Y: Integer); override;
    procedure MouseUp(Button: TMouseButton; Shift: TShiftState;
      X, Y: Integer); override;
    procedure Paint; override;
    procedure ResizeMsg(var Message: TWMSize); message WM_SIZE;
    procedure Move(var Message: TWMMove); message WM_MOVE;
  public
    Proportion: Real;
    constructor Create(AOwner: TComponent); override;
    function RotatePoint(Point: TPoint): TPoint;
  published
    property Align;
    property Canvas;
    property Color;
    property DragCursor;
    property DragMode;
    property Enabled;
    property ParentColor;
    property ParentShowHint;
    property PopupMenu;
    property ShowHint;
    property Visible;
    property OnClick;
    property OnDblClick;
    property OnDragDrop;
    property OnDragOver;
    property OnEndDrag;
    property OnPaint: TNotifyEvent read FOnPaint write FOnPaint;
    property OnResize: TNotifyEvent read FOnResize write FOnResize;
    property OnStartDrag;

    //property Ticks[Index: Integer]: TTick read GetTicks;
    property TicksSize: Integer read FTicksSize write SetTicksSize default 7;
    property TicksEnabled: TSetTicks read FTicksEnabled write SetTicksEnabled
      default [tkTopLeft,tkTop,tkTopRight,tkLeft,tkRight,tkBottomLeft,tkBottom,
      tkBottomRight,tkRotate];
    property Active: Boolean read FActive write SetActive default False;
    property Border: TPenStyle read FBorder write SetBorder default psSolid;
    property Movable: Boolean read FMovable write FMovable default True;
    property MinWidth: Integer read FMinWidth;
    property MinHeight: Integer read FMinHeight;
    property Corner: Integer read FCorner write SetCorner default 0;
    property ResizeProportional: Boolean read FResizeProportional
      write SetResizeProportional default False;
    property OnMove: TNotifyEvent read FOnMove write FOnMove;
    property OnRotate: TNotifyEvent read FOnRotate write FOnRotate;
  end;

procedure Register;

implementation

uses ComUtil;

procedure Register;
begin
  RegisterComponents('Alex', [TImageBox]);
end;

//Class TImageBox

constructor TImageBox.Create(AOwner: TComponent);
var
  I: Integer;
begin
  inherited Create(AOwner);
  ControlStyle:= [csAcceptsControls, csCaptureMouse, csClickEvents,
    csSetCaption, csOpaque, csDoubleClicks, csReplicatable];
  FMinWidth:=32; FMinHeight:=32;
  Width:=105; Height:=105;
  for I:=Low(FTicks) to High(FTicks) do begin
    FTicks[I]:=TTick.Create(Self);
    FTicks[I].Kind:=TTickKind(I);
  end;
  FTicksEnabled:=[tkTopLeft,tkTop,tkTopRight,tkLeft,tkRight,tkBottomLeft,
    tkBottom,tkBottomRight,tkRotate];
  FBorder:=psSolid;
  FMovable:=True;
  FTicksSize:=7;
  FActive:=False;
  Dragging:=False;
  FResizeProportional:=False;
  Proportion:=Width/Height;
end;

procedure TImageBox.Paint;
begin
  //Canvas.FillRect(ClientRect);
  if Assigned(FOnPaint) then
    FOnPaint(Self);
  //рисуем окантовку
  DrawMode:=GetDrawMode(Canvas);
  with Canvas do
  begin
    Brush.Color:=Color;
    Brush.Style:=bsClear;
    Pen.Mode:=pmCopy;
    if (csDesigning in ComponentState)and(Border=psClear) then
      Pen.Style:=psDash
    else
      Pen.Style:=Border;
    Rectangle(0,0,Width,Height);
  end;
  SetDrawMode(Canvas,DrawMode);
end;

procedure TImageBox.SetTicksPosition;
var
  I: Integer;
begin
  for I:=Low(FTicks) to High(FTicks) do
    FTicks[I].SetPosition;
end;

procedure TImageBox.ResizeMsg;
begin
  SetTicksPosition;
  if not ResizeProportional then
    if Height=0
      then Proportion:=0
      else Proportion:=Width/Height;
  if Assigned(FOnResize)
    then FOnResize(Self);
end;

procedure TImageBox.Move;
begin
  if Assigned(FOnMove) then FOnMove(Self);
end;
     {
function TImageBox.GetTicks(Index: Integer): TTick;
begin
  Result:=FTicks[Index];
end;    }

procedure TImageBox.SetActive(Value: Boolean);
var
  I: Integer;
begin
  FActive:=Value;
  for I:=Low(FTicks) to High(FTicks) do
    FTicks[I].Visible:=FActive and FTicks[I].Enabled;
end;

procedure TImageBox.SetTicksEnabled(Value: TSetTicks);
var
  I: Integer;
begin
  FTicksEnabled:=Value;
  for I:=Low(FTicks) to High(FTicks) do
    FTicks[I].Enabled:=(FTicks[I].Kind in FTicksEnabled);
end;

procedure TImageBox.SetBorder(Value: TPenStyle);
begin
  FBorder:=Value;
  Invalidate;
end;

procedure TImageBox.MouseDown(Button: TMouseButton; Shift: TShiftState;
  X, Y: Integer);
begin
  inherited MouseDown(Button,Shift,X,Y);
  if Button<>mbLeft then exit;
  if not Movable then exit;
  Dragging:=True;
  LineDC:=GetDC(Parent.Handle);
  X0:=Left; Y0:=Top; DX:=X; DY:=Y;
  DrawRect(LineDC,X0,Y0,Width,Height);
end;

procedure TImageBox.MouseMove(Shift: TShiftState; X, Y: Integer);
begin
  inherited MouseMove(Shift,X,Y);
  if Dragging then begin
    DrawRect(LineDC,X0,Y0,Width,Height);
    X0:=Left+X-DX; Y0:=Top+Y-DY;
    DrawRect(LineDC,X0,Y0,Width,Height);
  end;
end;

procedure TImageBox.MouseUp(Button: TMouseButton; Shift: TShiftState;
  X, Y: Integer);
begin
  inherited MouseUp(Button,Shift,X,Y);
  if Dragging then begin
    DrawRect(LineDC,X0,Y0,Width,Height);
    Visible:=False; Left:=X0; Top:=Y0; Visible:=True;
    Dragging:=False;
    DropDC(LineDC,ParentForm(Self).Handle);
  end;
  Active:=True;
end;

procedure TImageBox.SetTicksSize(Value: Integer);
var
  I: Integer;
begin
  FTicksSize:=Value;
  for I:=Low(FTicks) to High(FTicks) do
    FTicks[I].Size:=FTicksSize;
end;

procedure TImageBox.SetCorner(Value: Integer);
begin
  FCorner:=Value;
  SetTicksPosition;
  Invalidate;
  if Assigned(FOnRotate) then FOnRotate(Self);
end;

procedure TImageBox.SetResizeProportional(Value: Boolean);
begin
  FResizeProportional:=Value;
  if FResizeProportional then
    TicksEnabled:=TicksEnabled-[tkTop,tkLeft,tkRight,tkBottom];
end;

function TImageBox.RotatePoint(Point: TPoint): TPoint;
var
  Center: TPoint;
begin
  Center.X:=Width div 2; Center.Y:=Height div 2;
  Result:=GrphUtil.RotatePoint(Center,Point,Corner);
end;

//Class TTick

constructor TTick.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  Parent:=TWinControl(AOwner);
  Size:=7;
  Color:=clBlack;
  Visible:=False;
  Enabled:=True;
  ControlStyle:=[csCaptureMouse,csClickEvents];
  Canvas.Brush.Color:=Color;
  Dragging:=False;
end;

procedure TTick.Paint;
begin
  Canvas.Brush.Color:=Color;
  Canvas.Rectangle(0,0,Width,Height);
  inherited Paint;
end;

procedure TTick.SetPosition;
var
  A: Real;
  Radius: Integer;
begin
  case Kind of
    tkTopLeft: begin Left:=0; Top:=0; end;
    tkTop: begin Left:=(Parent.Width-Width) div 2; Top:=0; end;
    tkTopRight: begin Left:=Parent.Width-Width; Top:=0; end;
    tkLeft: begin Left:=0; Top:=(Parent.Height-Height) div 2; end;
    tkRight: begin Left:=Parent.Width-Width; Top:=(Parent.Height-Height) div 2; end;
    tkBottomLeft: begin Left:=0; Top:=Parent.Height-Height; end;
    tkBottom: begin Left:=(Parent.Width-Width) div 2; Top:=Parent.Height-Height; end;
    tkBottomRight: begin Left:=Parent.Width-Width; Top:=Parent.Height-Height; end;
    tkRotate: begin
      A:=DegToRad(TImageBox(Parent).Corner);
      Radius:=Min(Parent.Width,Parent.Height) div 2-Size-Size div 2;
      Left:=(Parent.Width-Width) div 2+Trunc(Radius*Sin(A));
      Top:=(Parent.Height-Height) div 2-Trunc(Radius*Cos(A)); end;
  end;
end;

procedure TTick.SetCursor;
begin
  case FKind of
    tkTopLeft: Cursor:=crSizeNWSE;
    tkTop: Cursor:=crSizeNS;
    tkTopRight: Cursor:=crSizeNESW;
    tkLeft: Cursor:=crSizeWE;
    tkRight: Cursor:=crSizeWE;
    tkBottomLeft: Cursor:=crSizeNESW;
    tkBottom: Cursor:=crSizeNS;
    tkBottomRight: Cursor:=crSizeNWSE;
    tkRotate: Cursor:=crDefault;
  end;
end;

procedure TTick.SetColor;
begin
  case FKind of
    tkTopLeft: Color:=clBlack;
    tkTop: Color:=clBlack;
    tkTopRight: Color:=clBlack;
    tkLeft: Color:=clBlack;
    tkRight: Color:=clBlack;
    tkBottomLeft: Color:=clBlack;
    tkBottom: Color:=clBlack;
    tkBottomRight: Color:=clBlack;
    tkRotate: Color:=clYellow;
  end;
end;

procedure TTick.SetKind(Value: TTickKind);
begin
  FKind:=Value;
  SetPosition;
  SetCursor;
  SetColor;
end;

procedure TTick.SetSize(Value: Integer);
begin
  FSize:=Value;
  Width:=FSize;
  Height:=FSize;
  SetPosition;
end;

procedure TTick.SetEnabled(Value: Boolean);
begin
  //inherited SetEnabled(Value);
  FEnabled:=Value;
  Visible:=Visible and Enabled;
end;

procedure TTick.MouseDown(Button: TMouseButton; Shift: TShiftState;
  X, Y: Integer);
begin
  inherited MouseDown(Button,Shift,X,Y);
  if Button<>mbLeft then exit;
  LineDC:=GetDC(Parent.Parent.Handle);
  Dragging:=True;
  if Kind=tkRotate then begin
    X0:=Parent.Width div 2; Y0:=Parent.Height div 2;
    DX:=X-Width div 2; DY:=Y-Height div 2;
    LX:=Min(Parent.Width,Parent.Height) div 2-2;
    Corner:=TImageBox(Parent).Corner;
    DrawCompass(TImageBox(Parent).Canvas,X0,Y0,LX,Corner); end
  else begin
    X0:=Parent.Left; Y0:=Parent.Top;
    DX:=X; DY:=Y;
    LX:=Parent.Width; LY:=Parent.Height;
    DrawRect(LineDC,X0,Y0,LX,LY);
  end;
end;

procedure TTick.MouseMove(Shift: TShiftState; X, Y: Integer);
var
  MinWidth,MinHeight,MaxX,MaxY,K1,K2: Integer;
begin
  inherited;
  if not Dragging then exit;
  if Kind=tkRotate then begin
    DrawCompass(TImageBox(Parent).Canvas,X0,Y0,LX,Corner);
    //катеты
    K1:=Left-Parent.Width div 2+X-DX;
    K2:=Parent.Height div 2-Top-Y+DY;
    if K2=0 then
      Corner:=90
    else
      Corner:=Trunc(RadToDeg(ArcTan(K1/K2)));
    if (K1>=0)and(K2>=0) then Corner:=Corner //1-? ????????
    else if (K1>=0)and(K2<0) then Corner:=Corner+180 //2-? ????????
    else if (K1<0)and(K2<=0) then Corner:=Corner+180 //3-? ????????
    else if (K1<0)and(K2>0) then Corner:=Corner+360; //4-? ????????
    DrawCompass(TImageBox(Parent).Canvas,X0,Y0,LX,Corner); end
  else begin
    MinWidth:=TImageBox(Parent).MinWidth;
    MinHeight:=TImageBox(Parent).MinHeight;
    MaxX:=X0+LX-MinWidth;
    MaxY:=Y0+LY-MinHeight;
    DrawRect(LineDC,X0,Y0,LX,LY);
    case Kind of
      tkTopLeft: begin X0:=Parent.Left+(X-DX); Y0:=Parent.Top+(Y-DY);
        LX:=Parent.Width-(X-DX); LY:=Parent.Height-(Y-DY); end;
      tkTop: begin Y0:=Parent.Top+(Y-DY);
        LY:=Parent.Height-(Y-DY); end;
      tkTopRight: begin Y0:=Parent.Top+(Y-DY);
        LX:=Parent.Width+(X-DX); LY:=Parent.Height-(Y-DY); end;
      tkLeft: begin X0:=Parent.Left+(X-DX);
        LX:=Parent.Width-(X-DX); end;
      tkRight: LX:=Parent.Width+(X-DX);
      tkBottomLeft: begin X0:=Parent.Left+(X-DX);
        LX:=Parent.Width-(X-DX); LY:=Parent.Height+(Y-DY); end;
      tkBottom: LY:=Parent.Height+(Y-DY);
      tkBottomRight: begin LX:=Parent.Width+(X-DX); LY:=Parent.Height+(Y-DX); end;
    end;
    X0:=Iif(X0>MaxX,MaxX,X0);
    Y0:=Iif(Y0>MaxY,MaxY,Y0);
    LX:=Iif(LX<MinWidth,MinWidth,LX);
    LY:=Iif(LY<MinHeight,MinHeight,LY);
    if TImageBox(Parent).ResizeProportional then begin
      if Trunc(LY*TImageBox(Parent).Proportion)>LX then
        LX:=Trunc(LY*TImageBox(Parent).Proportion)
      else
        LY:=Trunc(LX/TImageBox(Parent).Proportion);
    end;
    DrawRect(LineDC,X0,Y0,LX,LY);
  end;
end;

procedure TTick.MouseUp(Button: TMouseButton; Shift: TShiftState;
  X, Y: Integer);
begin
  inherited;
  if not Dragging then exit;
  if Kind=tkRotate then begin
    DrawCompass(TImageBox(Parent).Canvas,X0,Y0,LX,Corner);
    TImageBox(Parent).Corner:=Corner; end
  else begin
    DrawRect(LineDC,X0,Y0,LX,LY);
    with Parent do begin
      Visible:=False;
      Width:=LX; Height:=LY; Left:=X0; Top:=Y0;
      Visible:=True;
    end;
  end;
  Dragging:=False;
  DropDC(LineDC,ParentForm(Self).Handle);
end;

end.
