unit uAerialViewForm;

{***********************************************************}
//       EzGIS aerial view form
//      (c) 2002 EzGis
//       All Rights Reserved
{***********************************************************}

interface

uses
  Windows, SysUtils, Messages, Classes, Graphics, Controls, Forms,
  StdCtrls, EzEntities, EzLib, EzBaseGis, EzSystem, Ezbase, EzBasicCtrls,
  Buttons, ExtCtrls, EzCmdLine;

type
  TkaAerialViewForm = class(TForm)
    View: TEzAerialView;
    Panel1: TPanel;
    btnResetZoom: TSpeedButton;
    SpeedButton2: TSpeedButton;
    SpeedButton3: TSpeedButton;
    CmdLineAerial: TEzCmdLine;
    SpeedButton1: TSpeedButton;
    BtnHand: TSpeedButton;
    SpeedButton4: TSpeedButton;
    procedure ViewBeginRepaint(Sender: TObject);
    procedure ViewEndRepaint(Sender: TObject);
    procedure btnResetZoomClick(Sender: TObject);
    procedure SpeedButton2Click(Sender: TObject);
    procedure SpeedButton3lick(Sender: TObject);
    procedure SpeedButton1Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure BtnHandClick(Sender: TObject);
    procedure SpeedButton4Click(Sender: TObject);
  private
    FOldWidth, FOldHeight: Integer;
    FSavedGisTimer: TEzGisTimerEvent;
    procedure WMEnterSizeMove( var m: TMessage ); Message WM_ENTERSIZEMOVE;
    procedure WMExitSizeMove( var m: TMessage ); Message WM_EXITSIZEMOVE;
  public
    procedure CreateParams(var Params: TCreateParams); override;
  end;

var
  ParentHWND: THandle;

implementation

{$R *.DFM}

uses
  EzConsts;

Type

  TAerialDefaultAction = Class( TEzAction )
  Private
    FAerialView: TEzAerialView;
    FFrame: TEzEntity;
    FCurrentIndex: Integer;
    FWasPainted, FMoving: boolean;
    FOriginPt: TEzPoint;
    FOriginBox: TEzRect;
    Procedure MyMouseMove( Sender: TObject; Shift: TShiftState;
      X, Y: Integer; Const WX, WY: Double );
    Procedure MyMouseDown( Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer; Const WX, WY: Double );
    procedure MyMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer; const WX, WY: Double);
    Procedure MyPaint( Sender: TObject );
    Procedure SetCurrentPoint( Pt: TEzPoint );
  Public
    Constructor CreateAction( AerialView: TEzAerialView; CmdLine: TEzCmdLine );
    Destructor Destroy; Override;
  End;


Constructor TAerialDefaultAction.CreateAction( AerialView: TEzAerialView;
  CmdLine: TEzCmdLine );
Begin
  Inherited CreateAction( CmdLine );
  FAerialView:= AerialView;
  FFrame := TEzRectangle.CreateEntity( Point2D( 0, 0 ), Point2D( 0, 0 ) );
  OnMouseDown := MyMouseDown;
  OnMouseMove := MyMouseMove;
  OnMouseUp := MyMouseUp;
  OnPaint:= MyPaint;
End;

destructor TAerialDefaultAction.Destroy;
begin
  inherited;
  FFrame.Free;
end;

Procedure TAerialDefaultAction.SetCurrentPoint( Pt: TEzPoint );
Var
  I: Integer;
Begin
  FFrame.Points[FCurrentIndex] := Pt;
  For I := FCurrentIndex + 1 To FFrame.Points.Count - 1 Do
    FFrame.Points[I] := Pt;
End;

Procedure TAerialDefaultAction.MyMouseDown( Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer; Const WX, WY: Double );
Var
  Box: TEzRect;
  Pt: TEzPoint;
Begin
  If ( FAerialView.ParentView = Nil ) Or ( Button = mbRight ) Then Exit;
  Box := FAerialView.ParentView.Grapher.CurrentParams.VisualWindow;
  Pt := Point2D( WX, WY );
  If ( FCurrentIndex = 0 ) And IsPointInBox2D( Pt, Box ) Then
  Begin
    FMoving := True;
    FOriginPt := Pt;
    FOriginBox := Box;
  End
  Else
  Begin
    SetCurrentPoint( Pt );
    If FCurrentIndex >= 1 Then
    Begin
      FCurrentIndex := 0;
      Box.Emin := FFrame.Points[0];
      Box.Emax := FFrame.Points[1];
      Box:= ReorderRect2d(Box);
      FAerialview.ParentView.ZoomWindow( Box );
      Windows.SetFocus( FAerialview.ParentView.Handle );
      Exit;
    End;
    Inc( FCurrentIndex );
  End;
End;

Procedure TAerialDefaultAction.MyMouseMove( Sender: TObject;
  Shift: TShiftState; X, Y: Integer; Const WX, WY: Double );
Var
  Box: TEzRect;
Begin
  with FAerialview do
  begin
    If ParentView = Nil Then Exit;
    If Not FMoving Then
    Begin
      If FCurrentIndex = 0 Then
      Begin
        Box := ParentView.Grapher.CurrentParams.VisualWindow;
        If IsPointInBox2D( Point2D( WX, WY ), Box ) Then
          Cursor := crHandPoint
        Else
          Cursor := crCross;
        Exit;
      End;
      DrawEntity2DRubberBand( FFrame, False, False );
      SetCurrentPoint( Point2D( WX, WY ) );
      DrawEntity2DRubberBand( FFrame, False, False );
    End
    Else
      Refresh;
  end;
End;

Procedure TAerialDefaultAction.MyMouseUp( Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer; Const WX, WY: Double );
Var
  Box: TEzRect;
  DX, DY: Double;
Begin
  with FAerialview do
  begin
    If ( ParentView = Nil ) Or ( Button = mbRight ) Then Exit;
    If FMoving Then
    Begin
      DX := WX - FOriginPt.X;
      DY := WY - FOriginPt.Y;
      With FOriginBox Do
        Box := Rect2D( Emin.X + DX, Emin.Y + DY, Emax.X + DX, Emax.Y + DY );
      ParentView.ZoomWindow( Box );
    End;
  End;
  FMoving := False;
End;

Procedure TAerialDefaultAction.MyPaint( Sender: TObject );
Var
  TmpR: TRect;
  p: TPoint;
  p1: TEzPoint;
  DX, DY: Double;
  TmpBox: TEzRect;
Begin
  with FAerialview do
  begin
    If ( ParentView = Nil ) Or InRepaint Then Exit;
    If Not FWasPainted Then
    Begin
      FWasPainted := True;
      ZoomToExtension;
    End;
    { draw a rectangle with the current view }
    If FMoving Then
    Begin
      // get current mouse cursor
      GetCursorPos( p );
      p := ScreenToClient( p );
      p1 := Grapher.PointToReal( p );
      DX := p1.X - FOriginPt.X;
      DY := p1.Y - FOriginPt.Y;
      TmpBox := FOriginBox;
      With TmpBox Do
      Begin
        Emin.X := Emin.X + DX;
        Emax.X := Emax.X + DX;
        Emin.Y := Emin.Y + DY;
        Emax.Y := Emax.Y + DY;
      End;
      TmpR := Grapher.RealToRect( TmpBox );
    End
    Else
      TmpR := Grapher.RealToRect( ParentView.Grapher.CurrentParams.VisualWindow );
    Canvas.Brush.Style := bsClear;
    Canvas.Pen.Color := OuterColor;
    Canvas.Pen.Mode := pmCopy;
    If ShowInverted Then
      InvertRect( Canvas.Handle, TmpR );
    InflateRect( TmpR, 1, 1 );
    With TmpR Do
    Begin
      If Left < 0 Then
        Left := 0;
      If Top < 0 Then
        Top := 0;
      If Right > FAerialview.Width Then
        Right := FAerialview.Width;
      If Bottom > FAerialview.Height Then
        Bottom := FAerialview.Height;
      Canvas.Rectangle( Left, Top, Right, Bottom );
      InflateRect( TmpR, -1, -1 );
      Canvas.Pen.Color := InnerColor;
      Canvas.Rectangle( Left, Top, Right, Bottom );
    End;
  End;
End;

{ TfrmAerial}

procedure TkaAerialViewForm.CreateParams(var Params: TCreateParams);
Begin
  Inherited CreateParams( Params );
  With Params Do
  Begin
    Style := Style Or ws_Overlapped;
    WndParent := ParentHWND;
  end;
end;

procedure TkaAerialViewForm.WMEnterSizeMove(var m: TMessage);
begin
  inherited;
  View.BeginUpdate;
  FOldWidth := View.Width;
  FOldHeight:= View.Height;
end;

procedure TkaAerialViewForm.WMExitSizeMove(var m: TMessage);
begin
  inherited;
  if (View.Width = FOldWidth) And (View.Height = FOldHeight) then
    View.CancelUpdate
  else
    View.EndUpdate;
end;

procedure TkaAerialViewForm.ViewBeginRepaint(Sender: TObject);
begin
  FSavedGisTimer := View.Gis.OnGisTimer;
end;

procedure TkaAerialViewForm.ViewEndRepaint(Sender: TObject);
begin
  View.Gis.OnGisTimer := FSavedGisTimer;
end;

procedure TkaAerialViewForm.btnResetZoomClick(Sender: TObject);
begin
  View.ZoomToExtension;
end;

procedure TkaAerialViewForm.SpeedButton2Click(Sender: TObject);
begin
  CmdLineAerial.Clear;
  CmdLineAerial.DoCommand('ZOOMIN', '');
end;

procedure TkaAerialViewForm.SpeedButton3lick(Sender: TObject);
begin
  CmdLineAerial.Clear;
  CmdLineAerial.DoCommand('ZOOMOUT', '');
end;

procedure TkaAerialViewForm.SpeedButton1Click(Sender: TObject);
begin
  CmdLineAerial.Clear;
  CmdLineAerial.DoCommand('ZOOMWIN', '');
end;

procedure TkaAerialViewForm.FormCreate(Sender: TObject);
begin
  CmdLineAerial.TheDefaultAction:=
    TAerialDefaultAction.CreateAction(Self.View, CmdLineAerial);
end;

procedure TkaAerialViewForm.BtnHandClick(Sender: TObject);
begin
  CmdLineAerial.Clear;
  CmdLineAerial.DoCommand('SCROLL', '');
end;

procedure TkaAerialViewForm.SpeedButton4Click(Sender: TObject);
begin
  CmdLineAerial.Clear;
end;

end.
