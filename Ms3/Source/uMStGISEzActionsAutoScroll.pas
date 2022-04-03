unit uMStGISEzActionsAutoScroll;

interface

uses
  // System
  SysUtils, Windows, Classes, Controls, Clipbrd, Graphics, Forms, Messages,
  // EzGIS
  EzCmdLine, EzBaseGIS, EzLib, EzSystem, EzEntities, EzConsts, EzActionLaunch,
  EzActions, EzBase, EzPreview, EzMiscelEntities;

type
  TmstAutoHandScrollAction = class(TEzAction)
  private
    FOrigin: TPoint;
    FDownX, FDownY: Integer;
    FScrolling: Boolean;
    FSavedShowWaitCursor: Boolean;
  protected
    procedure MyMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer; const WX, WY: Double);
    procedure MyMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer; const WX, WY: Double);
    procedure MyMouseMove(Sender: TObject; Shift: TShiftState;
      X, Y: Integer; const WX, WY: Double);
    procedure MyKeyPress(Sender: TObject; var Key: Char);
  public
    constructor CreateAction(CmdLine: TEzCmdLine);
    destructor Destroy; override;
  end;

implementation

{ TmstAutoHandScrollAction }

constructor TmstAutoHandScrollAction.CreateAction(CmdLine: TEzCmdLine);
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

destructor TmstAutoHandScrollAction.Destroy;
begin
  if CmdLine.ActiveDrawBox <> nil then
    CmdLine.ActiveDrawBox.GIS.ShowWaitCursor := FSavedShowWaitCursor;
  inherited;
end;

procedure TmstAutoHandScrollAction.MyKeyPress(Sender: TObject;
  var Key: Char);
begin
  if Key in [#27, #13] then
  begin
    with cmdLine.ActiveDrawBox do
      if InUpdate then
      begin
        CancelUpdate;
      end;
    Self.Finished := True;
  end;
end;

procedure TmstAutoHandScrollAction.MyMouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer; const WX,
  WY: Double);
begin
  if Button <> mbLeft then Exit;
  FOrigin := Point(X, Y);
  FDownX := X;
  FDownY := Y;
  FScrolling := True;
  with CmdLine.ActiveDrawBox do
  begin
    Cursor := crScrollingDn;
    Perform(WM_SETCURSOR, Handle, HTCLIENT);
    Canvas.Pen.Mode := pmCopy;
    BeginUpdate;
  end;
end;

procedure TmstAutoHandScrollAction.MyMouseMove(Sender: TObject;
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
  if not FScrolling then Exit;
  Step := Screen.PixelsPerInch div 30;
  if not ((Abs(FDownX - X) >= Step) or
         (Abs(FDownY - Y) >= Step))
  then
    Exit;
  with CmdLine.ActiveDrawBox do
  begin
    BrushClr := Color;
    Grapher.SaveCanvas( Canvas );
    Canvas.Brush.Style := bsSolid;
    Canvas.Brush.Color := Color;
    // Erase outside of drawing area. This erase not all screen but outside of area
    If ( Y - FOrigin.Y ) > 0 Then // upper rectangle area
      AreaFillRect( 0, 0, ClientWidth, Y - FOrigin.Y );
    if ( Y - FOrigin.Y ) < 0 then // below rectangle area
      AreaFillRect( 0, ( Y - FOrigin.y ) + ClientHeight, ClientWidth, ClientHeight );
    if ( x - FOrigin.X ) > 0 then // left rectangle area
      AreaFillRect( 0, 0, X - FOrigin.X, ClientHeight );
    if ( X - FOrigin.X ) < 0 then // right rectangle area
      AreaFillRect( ( X - FOrigin.X ) + ClientWidth, 0, ClientWidth, ClientHeight );
    Grapher.RestoreCanvas( Canvas );
    R := ClientRect;
    OffsetRect( R, X - FOrigin.X, Y - FOrigin.Y );
    Canvas.CopyRect( R, ScreenBitmap.Canvas, ClientRect );
    If CmdLine.DynamicUpdate then
    begin
      TmpGrapher:= TEzGrapher.Create(10,adScreen);
      try
        TmpGrapher.Assign(CmdLine.ActiveDrawBox.Grapher);
        DX := TmpGrapher.DistToRealX( X - FOrigin.X );
        DY := TmpGrapher.DistToRealX( Y - FOrigin.Y );
        TmpWin := TmpGrapher.CurrentParams.VisualWindow;
        with TmpWin do
        begin
          Emin.X := Emin.X - DX;
          Emin.Y := Emin.Y + DY;
          Emax.X := Emax.X - DX;
          Emax.Y := Emax.Y + DY;
        end;
        TmpGrapher.SetViewTo( TmpWin );
        { draw the sections not covered }
        if ( Y - FOrigin.Y ) > 0 then // upper rectangle area
          PaintArea(0,0,ClientWidth,Y-FOrigin.Y);
        if ( Y - FOrigin.Y ) < 0 then // below rectangle area
          PaintArea(0, ( Y - FOrigin.y ) + ClientHeight, ClientWidth, ClientHeight);
        if ( x - FOrigin.X ) > 0 then // left rectangle area
          PaintArea( 0, 0, X - FOrigin.X, ClientHeight );
        if ( X - FOrigin.X ) < 0 then // right rectangle area
          PaintArea( ( X - FOrigin.X ) + ClientWidth, 0, ClientWidth, ClientHeight );
      finally
        TmpGrapher.Free;
      end;
    end;
  end;
  FDownX := X;
  FDownY := Y;
end;

procedure TmstAutoHandScrollAction.MyMouseUp(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer; const WX,
  WY: Double);
var
  DX, DY: Double;
  TmpWin: TEzRect;
  TmpChar: Char;
begin
//  If Button <> mbRight Then Exit;
  FScrolling := False;
  with CmdLine.ActiveDrawBox Do
  begin
    Cursor := crScrollingUp;
    Perform( WM_SETCURSOR, Handle, HTCLIENT );
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
end;

end.
