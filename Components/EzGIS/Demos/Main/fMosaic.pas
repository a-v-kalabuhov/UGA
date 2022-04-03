unit fMosaic;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  EzBaseGIS, EzBasicCtrls, Buttons, ExtCtrls, Printers, EzCmdLine, EzPreview;

type
  TfrmMosaic = class(TForm)
    Panel4: TPanel;
    btnRefresh: TSpeedButton;
    btnLeft: TSpeedButton;
    btnDown: TSpeedButton;
    btnRight: TSpeedButton;
    btnUp: TSpeedButton;
    MosaicView1: TEzMosaicView;
    btnReset: TSpeedButton;
    BtnPrint: TSpeedButton;
    btnResetZoom: TSpeedButton;
    SpeedButton1: TSpeedButton;
    SpeedButton2: TSpeedButton;
    CmdLine1: TEzCmdLine;
    SpeedButton3: TSpeedButton;
    SpeedButton4: TSpeedButton;
    BtnHand: TSpeedButton;
    procedure btnRefreshClick(Sender: TObject);
    procedure btnLeftClick(Sender: TObject);
    procedure btnRightClick(Sender: TObject);
    procedure btnDownClick(Sender: TObject);
    procedure btnUpClick(Sender: TObject);
    procedure btnResetClick(Sender: TObject);
    procedure BtnPrintClick(Sender: TObject);
    procedure MosaicView1BeginRepaint(Sender: TObject);
    procedure MosaicView1EndRepaint(Sender: TObject);
    procedure btnResetZoomClick(Sender: TObject);
    procedure SpeedButton1Click(Sender: TObject);
    procedure SpeedButton2Click(Sender: TObject);
    procedure SpeedButton3Click(Sender: TObject);
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
  ParentMosaicHWND: THandle;

implementation

{$R *.DFM}

uses fMain, fdemoprevw, EzLib, EzEntities, EzMiscelEntities;

Type

  TMosaicDefaultAction = Class( TEzAction )
  Private
    FMosaicView: TEzMosaicView;
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
    Constructor CreateAction( MosaicView: TEzMosaicView; CmdLine: TEzCmdLine );
    Destructor Destroy; Override;
  End;


Constructor TMosaicDefaultAction.CreateAction( MosaicView: TEzMosaicView;
  CmdLine: TEzCmdLine );
Begin
  Inherited CreateAction( CmdLine );
  FMosaicView:= MosaicView;
  FFrame := TEzRectangle.CreateEntity( Point2D( 0, 0 ), Point2D( 0, 0 ) );
  OnMouseDown := MyMouseDown;
  OnMouseMove := MyMouseMove;
  OnMouseUp := MyMouseUp;
  OnPaint:= MyPaint;
End;

destructor TMosaicDefaultAction.Destroy;
begin
  inherited;
  FFrame.Free;
end;

Procedure TMosaicDefaultAction.MyPaint( Sender: TObject );
Var
  TmpR: TRect;
  I, Index: Integer;
  Ent: TEzEntity;
  Layer: TEzBaseLayer;
  Recno: Integer;
  R: TEzRect;
  p: TPoint;
  p1: TEzPoint;
  DX, DY: Double;
  TmpBox: TEzRect;
Begin
  with FMosaicview do
  begin
    If ( ParentView = Nil ) or (ParentView.Gis = Nil) Or InRepaint Then Exit;
    If Not FWasPainted Then
    Begin
      FWasPainted := True;
      ZoomToExtension;
    End;
    if FMoving then
    begin
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

      Canvas.Brush.Style := bsClear;
      Canvas.Pen.Color := OuterColor;
      Canvas.Pen.Mode := pmCopy;
      //If FShowInverted Then
      //  InvertRect( Canvas.Handle, TmpR );
      InflateRect( TmpR, 1, 1 );
      With TmpR Do
      Begin
        Canvas.Rectangle( Left, Top, Right, Bottom );
        InflateRect( TmpR, -1, -1 );
        Canvas.Pen.Color := InnerColor;
        Canvas.Rectangle( Left, Top, Right, Bottom );
      End;

      Exit;

    end;
    { find the gis }
    //TmpGis:= Nil;
    Ent:= GetPreviewEntity(Layer,Recno);
    if Ent = Nil then Exit;
    try
      Index:= TEzPreviewEntity( Ent ).FileNo;
      if (Index < 0 ) or (Index > ParentView.GisList.Count - 1) then Exit;
      //TmpGis:= FParentView.GisList[Index].Gis;

      { draw a rectangle with the current view }
      TmpR := Grapher.RealToRect( CurrentPrintArea( Ent, padvNone ) );
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
        If Right > FMosaicview.Width Then
          Right := FMosaicview.Width;
        If Bottom > FMosaicview.Height Then
          Bottom := FMosaicview.Height;
        Canvas.Rectangle( Left, Top, Right, Bottom );
        InflateRect( TmpR, -1, -1 );
        Canvas.Pen.Color := InnerColor;
        Canvas.Rectangle( Left, Top, Right, Bottom );
      End;

      for I:= 0 to X1List.Count-1 do
      begin
        R.X1:= X1List[I];
        R.Y1:= Y1List[I];
        R.X2:= X2List[I];
        R.Y2:= Y2List[I];

        TmpR := Grapher.RealToRect( R );
        Canvas.Brush.Style := bsClear;
        Canvas.Pen.Color := PrintedOuterColor;
        Canvas.Pen.Mode := pmCopy;
        //If FShowInverted Then
        //  InvertRect( Canvas.Handle, TmpR );
        InflateRect( TmpR, 1, 1 );
        With TmpR Do
        Begin
          Canvas.Rectangle( Left, Top, Right, Bottom );
          InflateRect( TmpR, -1, -1 );
          Canvas.Pen.Color := PrintedInnerColor;
          Canvas.Rectangle( Left, Top, Right, Bottom );
        End;
      end;
    finally
      Ent.free;
    end;
  End;
End;

procedure TMosaicDefaultAction.MyMouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer; const WX, WY: Double);
Var
  Box: TEzRect;
  Pt: TEzPoint;
  Ent: TEzEntity;
  Layer: TEzBaseLayer;
  Recno, Index: Integer;
  PrevWidth, CurrWidth: double;
Begin
  with FMosaicview do
  begin
    If ( ParentView = Nil ) or (ParentView.Gis = Nil) Or ( Button = mbRight ) Then Exit;
    Ent:= GetPreviewEntity(Layer,Recno);
    if Ent = Nil then Exit;
    try
      Index:= TEzPreviewEntity( Ent ).FileNo;
      if (Index < 0 ) or (Index > ParentView.GisList.Count - 1) then Exit;
      Box := CurrentPrintArea( Ent, padvNone );
    finally
      Ent.free;
    end;
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
        { calculate new area to show of the map/drawing }
        Ent:= GetPreviewEntity(Layer,Recno);
        try
          { proposed print area }
          with TEzPreviewEntity( Ent ).ProposedPrintArea do
            PrevWidth:= Abs( X2 - X1 );
          CurrWidth:= Abs( Box.X2 - Box.X1 );
          with TEzPreviewEntity( Ent ) do
          begin
            DrawingUnits:= DrawingUnits * ( CurrWidth / PrevWidth );
            ProposedPrintArea := Box;
          end;
          { calculate actual area }
          CurrentPrintArea( Ent, padvNone );
          Layer.UpdateEntity( Recno, Ent );
          ParentView.Repaint;
        finally
          Ent.free;
        end;
        Exit;
      End;
      Inc( FCurrentIndex );
    End;
  End;
end;

procedure TMosaicDefaultAction.MyMouseMove(Sender: TObject;
  Shift: TShiftState; X, Y: Integer; const WX, WY: Double);
Var
  Box: TEzRect;
  Ent: TEzEntity;
  Layer: TEzBaseLayer;
  Recno, Index: Integer;
Begin
  with FMosaicview do
  begin
    If ( ParentView = Nil ) or (ParentView.Gis = Nil) Then Exit;
    If Not FMoving Then
    Begin
      If FCurrentIndex = 0 Then
      Begin
        Ent:= GetPreviewEntity(Layer,Recno);
        if Ent = Nil then Exit;
        try
          Index:= TEzPreviewEntity( Ent ).FileNo;
          if (Index < 0 ) or (Index > ParentView.GisList.Count - 1) then Exit;
          Box := CurrentPrintArea( Ent, padvNone );
        finally
          Ent.free;
        end;
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
  End;
end;

procedure TMosaicDefaultAction.MyMouseUp(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer; const WX,
  WY: Double);
Var
  Box: TEzRect;
  DX, DY: Double;
  Ent: TEzEntity;
  Layer: TEzBaseLayer;
  Recno: Integer;
Begin
  with FMosaicview do
  begin
    If ( ParentView = Nil ) or (ParentView.Gis = Nil) Or (Button = mbRight) Then Exit;
    If FMoving Then
    Begin
      DX := WX - FOriginPt.X;
      DY := WY - FOriginPt.Y;
      With FOriginBox Do
        Box := Rect2D( Emin.X + DX, Emin.Y + DY, Emax.X + DX, Emax.Y + DY );
        { calculate new area to show of the map/drawing }
      Ent:= GetPreviewEntity(Layer,Recno);
      if Ent = Nil then Exit;
      try
        { proposed print area}
        TEzPreviewEntity( Ent ).ProposedPrintArea := Box;
        { calculate actual area }
        CurrentPrintArea( Ent, padvNone );
        Layer.UpdateEntity( Recno, Ent );
        ParentView.Repaint;
      finally
        Ent.free;
      end;
    End;
    FMoving := False;
  End;
end;

procedure TMosaicDefaultAction.SetCurrentPoint(Pt: TEzPoint);
Var
  I: Integer;
Begin
  FFrame.Points[FCurrentIndex] := Pt;
  For I := FCurrentIndex + 1 To FFrame.Points.Count - 1 Do
    FFrame.Points[I] := Pt;
end;

{ TfrmMosaic }

procedure TfrmMosaic.MyGisTimer(Sender: TObject; var CancelPainting: Boolean);
Begin
  CancelPainting:= fMain.DetectCancelPaint( MosaicView1 );
End;

procedure TfrmMosaic.CreateParams(var Params: TCreateParams);
begin
  inherited CreateParams( Params );
  with Params do
  begin
    Style := Style or WS_OVERLAPPED;
    WndParent := ParentMosaicHWND;
  end;
end;

procedure TfrmMosaic.btnRefreshClick(Sender: TObject);
begin
  MosaicView1.Refresh;
end;

procedure TfrmMosaic.btnLeftClick(Sender: TObject);
begin
  MosaicView1.GoAdvance( padvLeft );
end;

procedure TfrmMosaic.btnRightClick(Sender: TObject);
begin
  MosaicView1.GoAdvance( padvRight );
end;

procedure TfrmMosaic.btnDownClick(Sender: TObject);
begin
  MosaicView1.GoAdvance( padvUp );
end;

procedure TfrmMosaic.btnUpClick(Sender: TObject);
begin
  MosaicView1.GoAdvance( padvDown );
end;

procedure TfrmMosaic.btnResetClick(Sender: TObject);
begin
  MosaicView1.ClearPrintList;
end;

procedure TfrmMosaic.BtnPrintClick(Sender: TObject);
begin
  if Printer.Printing then Exit;
  MosaicView1.ParentView.Print;
  MosaicView1.AddCurrentToPrintList;
end;

procedure TfrmMosaic.WMEnterSizeMove(var m: TMessage);
begin
  inherited;
  MosaicView1.BeginUpdate;
  FOldWidth:= MosaicView1.Width;
  FOldHeight:= MosaicView1.Height;
end;

procedure TfrmMosaic.WMExitSizeMove(var m: TMessage);
begin
  inherited;
  if (MosaicView1.Width = FOldWidth) And (MosaicView1.Height = FOldHeight) then
    MosaicView1.CancelUpdate
  else
    MosaicView1.EndUpdate;
end;

procedure TfrmMosaic.MosaicView1BeginRepaint(Sender: TObject);
begin
  FSavedGisTimer:= MosaicView1.Gis.OnGisTimer;
  MosaicView1.Gis.OnGisTimer:= MyGisTimer;
end;

procedure TfrmMosaic.MosaicView1EndRepaint(Sender: TObject);
begin
  MosaicView1.Gis.OnGisTimer:= FSavedGisTimer;
end;

procedure TfrmMosaic.btnResetZoomClick(Sender: TObject);
begin
  MosaicView1.ZoomToExtension;
end;

procedure TfrmMosaic.SpeedButton1Click(Sender: TObject);
begin
  CmdLine1.Clear;
  CmdLine1.DoCommand('ZOOMIN','');
end;

procedure TfrmMosaic.SpeedButton2Click(Sender: TObject);
begin
  CmdLine1.Clear;
  CmdLine1.DoCommand('ZOOMOUT','');
end;

procedure TfrmMosaic.SpeedButton3Click(Sender: TObject);
begin
  CmdLine1.Clear;
  CmdLine1.DoCommand('ZOOMWIN','');
end;

procedure TfrmMosaic.SpeedButton4Click(Sender: TObject);
begin
  CmdLine1.Clear;
  CmdLine1.DoCommand('REALTIMEZOOM','');
end;

procedure TfrmMosaic.FormCreate(Sender: TObject);
begin
  CmdLine1.TheDefaultAction:=
    TMosaicDefaultAction.CreateAction(Self.MosaicView1, CmdLine1);
end;

procedure TfrmMosaic.BtnHandClick(Sender: TObject);
begin
  CmdLine1.Clear;
  CmdLine1.DoCommand('SCROLL','');
end;

end.
