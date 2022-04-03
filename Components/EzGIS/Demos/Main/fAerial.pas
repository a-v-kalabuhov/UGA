unit fAerial;

{***********************************************************}
//       EzGIS aerial view form
//      (c) 2002 EzGis
//       All Rights Reserved
{***********************************************************}

{$I EZ_FLAG.PAS}
interface

uses
  Windows, SysUtils, Messages, Classes, Graphics, Controls, Forms,
  StdCtrls, EzEntities, EzLib, EzBaseGis, EzSystem, Ezbase, EzBasicCtrls,
  Buttons, ExtCtrls, EzCmdLine;

type
  TfrmAerial = class(TForm)
    AerialView1: TEzAerialView;
    Panel1: TPanel;
    btnResetZoom: TSpeedButton;
    SpeedButton2: TSpeedButton;
    SpeedButton3: TSpeedButton;
    CmdLine1: TEzCmdLine;
    SpeedButton1: TSpeedButton;
    SpeedButton4: TSpeedButton;
    BtnHand: TSpeedButton;
    procedure AerialView1BeginRepaint(Sender: TObject);
    procedure AerialView1EndRepaint(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure btnResetZoomClick(Sender: TObject);
    procedure SpeedButton2Click(Sender: TObject);
    procedure SpeedButton3lick(Sender: TObject);
    procedure SpeedButton1Click(Sender: TObject);
    procedure SpeedButton4Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure BtnHandClick(Sender: TObject);
  private
    { Private declarations }
    FOldWidth, FOldHeight: Integer;
    FSavedGisTimer: TEzGisTimerEvent;
    procedure WMEnterSizeMove( Var m: TMessage ); Message WM_ENTERSIZEMOVE;
    procedure WMExitSizeMove( Var m: TMessage ); Message WM_EXITSIZEMOVE;
    procedure MyGisTimer(Sender: TObject; var CancelPainting: Boolean);
  public
    { Public declarations }
    procedure CreateParams(var Params: TCreateParams); override;
  end;

var
  ParentHWND: THandle;

implementation

{$R *.DFM}

uses
  EzConsts, fMain;

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

procedure TfrmAerial.MyGisTimer(Sender: TObject; var CancelPainting: Boolean);
Begin
  //pendiente esto CancelPainting:= fMain.DetectCancelPaint( AerialView1 );
End;

procedure TfrmAerial.CreateParams(var Params: TCreateParams);
Begin
  Inherited CreateParams( Params );
  With Params Do
  Begin
    Style := Style Or ws_Overlapped;
    WndParent := ParentHWND;
  end;
end;

procedure TfrmAerial.WMEnterSizeMove(var m: TMessage);
begin
  inherited;
  AerialView1.BeginUpdate;
  FOldWidth:= AerialView1.Width;
  FOldHeight:= AerialView1.Height;
end;

procedure TfrmAerial.WMExitSizeMove(var m: TMessage);
begin
  inherited;
  if (AerialView1.Width = FOldWidth) And (AerialView1.Height = FOldHeight) then
    AerialView1.CancelUpdate
  else
    AerialView1.EndUpdate;
end;

procedure TfrmAerial.AerialView1BeginRepaint(Sender: TObject);
begin
  FSavedGisTimer:= AerialView1.Gis.OnGisTimer;
  AerialView1.Gis.OnGisTimer:= MyGisTimer;
end;

procedure TfrmAerial.AerialView1EndRepaint(Sender: TObject);
begin
  AerialView1.Gis.OnGisTimer:= FSavedGisTimer;
end;

procedure TfrmAerial.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  fMain.Form1.frmAerial:= Nil;
  Action:= caFree;
end;

procedure TfrmAerial.btnResetZoomClick(Sender: TObject);
begin
  AerialView1.ZoomToExtension;
end;

procedure TfrmAerial.SpeedButton2Click(Sender: TObject);
begin
  CmdLine1.Clear;
  CmdLine1.DoCommand('ZOOMIN','');
end;

procedure TfrmAerial.SpeedButton3lick(Sender: TObject);
begin
  CmdLine1.Clear;
  CmdLine1.DoCommand('ZOOMOUT','');
end;

procedure TfrmAerial.SpeedButton1Click(Sender: TObject);
begin
  CmdLine1.Clear;
  CmdLine1.DoCommand('ZOOMWIN','');
end;

procedure TfrmAerial.SpeedButton4Click(Sender: TObject);
begin
  CmdLine1.Clear;
  CmdLine1.DoCommand('REALTIMEZOOM','');
end;

procedure TfrmAerial.FormCreate(Sender: TObject);
begin
  CmdLine1.TheDefaultAction:=
    TAerialDefaultAction.CreateAction(Self.AerialView1, CmdLine1);
end;

procedure TfrmAerial.BtnHandClick(Sender: TObject);
begin
  CmdLine1.Clear;
  CmdLine1.DoCommand('SCROLL','');
end;

end.
