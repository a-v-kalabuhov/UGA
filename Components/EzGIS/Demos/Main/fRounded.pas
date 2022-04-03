unit fRounded;

{$I EZ_FLAG.PAS}
interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, EzNumEd, EzActionLaunch, EzBaseGis, EzLib;

type
  TfrmRounded = class(TForm)
    Label1: TLabel;
    NumEd1: TEzNumEd;
    Button1: TButton;
    chkClosed: TCheckBox;
    Launcher1: TEzActionLauncher;
    cboStyle: TComboBox;
    Label2: TLabel;
    chkColinear: TCheckBox;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure Launcher1KeyPress(Sender: TObject; var Key: Char);
    procedure Launcher1Finished(Sender: TObject);
    procedure Launcher1MouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer; const WX, WY: Double);
    procedure Launcher1MouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer; const WX, WY: Double);
    procedure Launcher1Paint(Sender: TObject);
    procedure Launcher1SuspendOperation(Sender: TObject);
    procedure Launcher1ContinueOperation(Sender: TObject);
    procedure cboStyleChange(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure NumEd1Change(Sender: TObject);
  private
    { Private declarations }
    { the entity that is adding }
    FEntity: TEzEntity;
    { auxiliary arc entity for rounding corners }
    FArc: TEzEntity;
    { the current vertext adding }
    FCurrentIndex: Integer;
    { last clicked button }
    FLastClicked: TEzPoint;
    { the radius for every corner. If 0, no radius was proportioned }
    FRadiuses: TEzDoubleList;
    Procedure AddEntity;
    Procedure SetCurrentPoint( Pt: TEzPoint; Orto: Boolean );
    procedure AddPoint( const CurrPoint: TEzPoint );
    procedure SetCaption;
    procedure DrawRubberArcs(Sender: TObject = Nil);
    function ConfigureArc( Index: Integer; Radius: Double): TEzEntity;
    Function GetRadius(Index: Integer): Double;
  public
    { Public declarations }
    procedure CreateParams(var Params: TCreateParams); override;
  end;

implementation

{$R *.dfm}

uses
  Math, fMain, EzSystem, EzEntities;

{ TfrmRounded }

procedure TfrmRounded.CreateParams(var Params: TCreateParams);
begin
  Inherited CreateParams( Params );
  With Params Do
  Begin
    Style := Style Or ws_Overlapped;
    WndParent := fMain.Form1.Handle;
  end;
end;

Function TfrmRounded.GetRadius(Index: Integer): Double;
Begin
  Result:= 0.0;
  If (Index<0) Or (Index>FRadiuses.Count-1) then exit;
  Result:=FRadiuses[Index];
End;

procedure TfrmRounded.FormCreate(Sender: TObject);
var
  p: TEzPoint;
begin
  FRadiuses:= TEzDoubleList.Create;

  { the entity to draw }
  FEntity:= TEzPolyline.Create( 100 );
  { set default pen style }
  TEzPolyline(FEntity).PenTool.Assign( Ez_Preferences.DefPenStyle );
  { this is a trick for snapping to this entity also, because this entity
    is not yet saved to the database }
  EzSystem.GlobalTempEntity:= FEntity;

  { an arc used for showing the roundness }
  p:= Point2d(0,0);
  FArc:= TEzArc.CreateEntity( p,p,p);
  TEzArc(FArc).PointsInCurve:= 15;

  Launcher1.CmdLine:= fMain.Form1.CmdLine1;
  Launcher1.Cursor:= crDrawCross;
  Launcher1.TrackGenericAction( '' );

  FLastClicked:= EzLib.INVALID_POINT;

  SetCaption;

  { by default, 1/2 half of an inch, the rounding }
  with fMain.Form1.CmdLine1.ActiveDrawbox do
    Numed1.NumericValue:= Grapher.DistToRealX( Grapher.DpiX div 4 );

  cboStyle.ItemIndex:= 0;
  cboStyle.OnChange(Nil);

end;

procedure TfrmRounded.FormDestroy(Sender: TObject);
begin
  { for not osnapping to this same entity }
  EzSystem.GlobalTempEntity:= Nil;

  FEntity.Free;
  FArc.Free;

  { if you move this to the FormClose event, it will causes an AV when you
    explicitly close the form with the system button }
  Launcher1.Finish;
  fMain.Form1.frmRounded:= Nil;

  FRadiuses.Free;
end;

function TfrmRounded.ConfigureArc( Index: Integer; Radius: Double): TEzEntity;
var
  Angle1,Angle2:Double;
  AngleDiff, MidAngle, L, TmpL, MinX, MaxX: Double;
  p1,p2,p3, RotP2,RotP3, Center, ArcP1, ArcP2, ArcP3, ArcRotP1, ArcRotP3: TEzPoint;
  M: TEzMatrix;
  PreviousArc: TEzEntity;
  PreviousL, PreviousRadius: Double;
begin
  Result:= Nil;
  If (Index > FEntity.Points.Count-1) Then Exit;
  If Index = FEntity.Points.Count-1 Then
  Begin
    { if it is the first and last point, then considere as closed }
    If Not EqualPoint2d( FEntity.Points[0], FEntity.Points[FEntity.Points.Count-1] ) Or
      (FEntity.Points.Count < 2) Then Exit;
    { p1 is the intersection point}
    p1:= FEntity.Points[Index];
    { p2 is one extreme line }
    p2:= FEntity.Points[1];
    { p3 is the other extreme line }
    p3:= FEntity.Points[Index-1];
  End Else
  Begin
    { p1 is the intersection point}
    p1:= FEntity.Points[Index];
    { p2 is one extreme line }
    p2:= FEntity.Points[Index-1];
    { p3 is the other extreme line }
    p3:= FEntity.Points[Index+1];
  End;
  If EqualPoint2d( P1, p2 ) Or EqualPoint2d( p1, p3) Then Exit;

  Angle1:= Angle2D(p1,p2);
  Angle2:= Angle2d(p1,p3);

  AngleDiff:= Abs(Angle2-Angle1);
  If AngleDiff=0 then Exit;
  MidAngle:= (Angle1 + Angle2)/2;
  If AngleDiff > System.PI Then
  begin
    AngleDiff:= EzEntities.TwoPI - AngleDiff;
    Midangle:= MidAngle + System.PI;
    If MidAngle > EzEntities.TwoPI Then
      MidAngle:= MidAngle - EzEntities.TwoPI;
  end;
  { length of line from center of circle to p1 }
  L:= Radius / Sin(AngleDiff/2);
  { the center of the circle }
  Center:= Point2d( p1.x + L * Cos(MidAngle), p1.y + L * Sin(MidAngle) );
  { calculate the midpoint of the arc }
  ArcP2:= Point2d( p1.x + (L-Radius) * Cos(MidAngle), p1.y + (L-Radius)*Sin(Midangle));
  { the "left" point of the arc }
  TmpL:= L * Cos(AngleDiff/2);
  ArcP1:= Point2d( p1.x + TmpL * Cos(Angle1), p1.y + TmpL * Sin(Angle1));
  ArcP3:= Point2d( p1.x + TmpL * Cos(Angle2), p1.y + TmpL * Sin(Angle2));

  { check if the points lies on the line segments
    For detecting we will rotate to horizontal the line segments and later compare
    if the arc point is in the X range of line segment }
  M:= Rotate2d( -Angle1, p1 );
  RotP2:= TransformPoint2d( p2, M );
  ArcRotP1:= TransformPoint2d( ArcP1, M );
  MinX:= EzLib.dMin( p1.X, RotP2.X);
  MaxX:= EzLib.dMax( p1.X, RotP2.X);
  If (ArcRotP1.X < MinX) Or (ArcRotP1.X > MaxX) Then Exit;

  { compare against second point }
  M:= Rotate2d( -Angle2, p1 );
  RotP3:= TransformPoint2d( p3, M );
  ArcRotP3:= TransformPoint2d( ArcP3, M );
  MinX:= EzLib.dMin( p1.X, RotP3.X);
  MaxX:= EzLib.dMax( p1.X, RotP3.X);
  If (ArcRotP3.X < MinX) Or (ArcRotP3.X > MaxX) Then Exit;

  { check if the length of this arc is bigger than previous arc }
  If Index > 1 then
  begin
    PreviousRadius:= GetRadius(Index-1);
    If PreviousRadius > 0 Then
    begin
      PreviousArc:= ConfigureArc( Index-1, PreviousRadius);
      If PreviousArc <> Nil Then
      Begin
        PreviousL:= Dist2d( FEntity.Points[Index-1], PreviousArc.Points[0]);
        If (PreviousL + Dist2d(P1,ArcP1)) > Dist2D(P1,P2) Then Exit;
      End;
    end;
  end;

  { 5 degrees considered as colinear. You can change this consideration }
  If chkColinear.Checked And (Abs(Angle2d( p2,p1 ) - Angle2d(p1,p3)) < DegToRad(5)) Then
  Begin
    ArcP1:= Point2d(p1.x + Cos(Angle1)*Radius, p1.y + Sin(Angle1)*Radius);
    ArcP2:= Point2d(p1.x + Cos(Angle1-System.PI/2)*Radius, p1.y + Sin(Angle1-System.PI/2)*Radius);
    ArcP3:= Point2d(p1.x + Cos(Angle2)*Radius, p1.y + Sin(Angle2)*Radius);
  End;

  { now you can build the arc }
  FArc.BeginUpdate;
  FArc.Points[0]:= ArcP1;
  FArc.Points[1]:= ArcP2;
  FArc.Points[2]:= ArcP3;
  FArc.EndUpdate;

  Result:= FArc;
end;

procedure TfrmRounded.DrawRubberArcs(Sender: TObject = Nil);
var
  I: Integer;
  Radius: Double;
  Arc: TEzEntity;
Begin
  If FCurrentIndex < 2 then Exit;
  { calculate all arcs and draw them }
  For I:= 1 to FCurrentIndex do
  begin
    Radius:= GetRadius(I);
    If Radius = 0 then Continue;
    Arc:= ConfigureArc( I, Radius );
    If Arc = Nil then Continue;
    If Sender = Nil Then
      fMain.Form1.CmdLine1.All_DrawEntity2dRubberBand( Arc )
    Else
      (Sender as TEzBaseDrawBox).DrawEntity2dRubberBand( Arc );
  end;
End;

procedure TfrmRounded.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  Action:= caFree;
end;

procedure TfrmRounded.SetCurrentPoint( Pt: TEzPoint; Orto: Boolean );
Var
  I: Integer;
Begin
  If Orto And ( FCurrentIndex > 0 ) Then
    Pt := EzLib.ChangeToOrtogonal( FEntity.Points[FCurrentIndex - 1], Pt );

  FEntity.Points[FCurrentIndex] := Pt;
  For I := FCurrentIndex + 1 To FEntity.Points.Count - 1 Do
    FEntity.Points[I] := Pt;
End;

Procedure TfrmRounded.AddEntity;
Var
  Accept: Boolean;
  TmpLayer: TEzBaseLayer;
  Extents: TEzRect;
  MinDim: Double;
  TmpEnt: TEzEntity;
  TmpV: TEzVector;
  Radius: Double;
  Arc: TEzEntity;
  I,J,Recno: Integer;
  LastArc: TEzEntity;
Begin
  { first, build the entity }
  If (Not chkClosed.Checked And (FEntity.Points.Count < 2)) Or
     (chkClosed.Checked And (FEntity.Points.Count < 3)) Then Exit;

  TmpEnt:= FEntity;
  TmpV:= TEzVector.Create(TmpEnt.Points.Count);
  Try

    If chkClosed.Checked then
    begin
      { convert to a polygon instead of a polyline }
      TmpEnt:= TEzPolygon.Create(FEntity.Points.Count+1);
      TmpEnt.Points.Assign( FEntity.Points );
      TEzPolygon(TmpEnt).PenTool.Assign( Ez_Preferences.DefPenStyle );
      TEzPolygon(TmpEnt).BrushTool.Assign( Ez_Preferences.DefBrushStyle );
      If Not EqualPoint2d(TmpEnt.Points[0], TmpEnt.Points[TmpEnt.Points.Count-1] ) Then
        TmpEnt.Points.Add(TmpEnt.Points[0]);
    end;

    LastArc:= Nil;
    If EqualPoint2d( TmpEnt.Points[0], TmpEnt.Points[TmpEnt.Points.Count-1]) Then
    Begin
      Radius:= GetRadius(TmpEnt.Points.Count-1);
      If Radius <> 0 Then
      Begin
        LastArc:= ConfigureArc( TmpEnt.Points.Count-1, Radius );
        If LastArc <> Nil then
        Begin
          { if the entity is closed and the last arc is valid adjust points of entity to add }

          For I:= LastArc.DrawPoints.Count-2 downto 0 do
            TmpV.Add( LastArc.DrawPoints[I] );

        End Else
          TmpV.Add( TmpEnt.Points[0] );
      End Else
        TmpV.Add( TmpEnt.Points[0] );
    End Else
      TmpV.Add( TmpEnt.Points[0] );

    For I:= 1 to TmpEnt.Points.Count-2 do
    begin
      Radius:= GetRadius(I);
      If Radius = 0 then
      Begin
        TmpV.Add( TmpEnt.Points[I] );
        Continue;
      End;
      Arc:= ConfigureArc( I, Radius );
      If Arc = Nil then
      Begin
        TmpV.Add( TmpEnt.Points[I] );
        Continue;
      End;
      For J:= 0 to Arc.DrawPoints.Count-1 do
        TmpV.Add( Arc.DrawPoints[J] );
    end;
    If LastArc = Nil Then
      TmpV.Add( TmpEnt.Points[TmpEnt.Points.Count-1] )
    Else
      TmpV.Add( LastArc.DrawPoints[LastArc.DrawPoints.Count - 1] );
    TmpEnt.Points.Assign( TmpV );
  Finally
    TmpV.Free;
  End;
  With fMain.Form1 Do
  Begin
    Accept := True;
    TmpLayer := GIS.CurrentLayer;
    If Assigned( DrawBox1.OnBeforeInsert ) Then
      DrawBox1.OnBeforeInsert( DrawBox1, TmpLayer, TmpEnt, Accept );
    Recno := 0;
    If Accept Then
      Recno:= DrawBox1.AddEntity( GIS.CurrentLayerName, TmpEnt );
    { the current layer could be changed on the OnBeforeInsert event}
    TmpLayer := GIS.CurrentLayer;
    If Accept And Assigned( DrawBox1.OnAfterInsert ) Then
      DrawBox1.OnAfterInsert( DrawBox1, TmpLayer, Recno );
    // symbols modified
    CmdLine1.All_Refresh;
    Extents := TmpEnt.FBox;
    {Repaint only the affected area, and with a small margin }
    MinDim := CmdLine1.ActiveDrawBox.Grapher.DistToRealY( 5 );
    InflateRect2D( Extents, MinDim, MinDim );
    CmdLine1.All_RepaintRect( Extents );
  End;
  If TmpEnt <> FEntity Then TmpEnt.Free;
End;

procedure TfrmRounded.Launcher1KeyPress(Sender: TObject; var Key: Char);
begin
  With fMain.Form1.CmdLine1 Do
    Case Key Of
      #13:
        Begin
          If FCurrentIndex < 2 Then
          Begin
            ShowMessage('Not enough points');
            Exit;
          End;
          (* Erase entity from screen and last point *)
          All_DrawEntity2DRubberBand( Self.FEntity );
          DrawRubberArcs;
          FEntity.Points.Delete( FCurrentIndex );
          Self.AddEntity;
          Self.Launcher1.Finished := true;  // this causes to finish the action
          Key := #0;
          Exit;
        End;
      #27:
        Begin
          { erase last draw entity }
          All_DrawEntity2DRubberBand( FEntity );
          DrawRubberArcs;
          If FCurrentIndex = 0 Then
          Begin
            FreeAndNil( FEntity );
            Self.Launcher1.Finished := true;
            Exit;
          End;
          Dec( FCurrentIndex );
          FEntity.Points.Count:= FCurrentIndex;

          { update the last clicked point (used when snapping to paraller, perpendicular,etc) }
          If FEntity.Points.Count = 0 Then
            Self.FLastClicked:= ezlib.INVALID_POINT
          Else
            Self.FLastClicked:= FEntity.Points[FCurrentIndex-1];
          SetCurrentPoint( CurrentPoint, UseOrto );

          { rubber paint entity }
          DrawRubberArcs;
          All_DrawEntity2DRubberBand( FEntity );

          If FCurrentIndex = 1 Then
            AccuDraw.UpdatePosition( FEntity.Points[0], FEntity.Points[0] )
          Else If FCurrentIndex > 0 Then
            AccuDraw.UpdatePosition( FEntity.Points[FCurrentIndex-2], FEntity.Points[FCurrentIndex-1] );
        End;
    End;
end;

procedure TfrmRounded.Launcher1Finished(Sender: TObject);
begin
  Release;  // if the action is finished some way, close this form
end;

procedure TfrmRounded.AddPoint( const CurrPoint: TEzPoint );
Begin
  with fMain.Form1.CmdLine1 do
  begin
    { "mark" the clicked point }
    with ActiveDrawBox do
      DrawCross( Canvas, Grapher.RealToPoint( CurrPoint ) );
    SetCurrentPoint( CurrPoint, UseOrto );

    { set AccuDraw position }
    If FCurrentIndex = 0 Then
      AccuDraw.UpdatePosition( CurrPoint, CurrPoint )  // this activates AccuDraw
    Else If FCurrentIndex > 0 Then
    Begin
      AccuDraw.UpdatePosition( FEntity.Points[FCurrentIndex-1], CurrPoint );
    End;

    Inc( fCurrentIndex );
    cboStyle.OnChange(Nil);

    Self.SetCaption;
  end;
End;

procedure TfrmRounded.SetCaption;
var
  temp: string;
Begin
  Case fCurrentIndex Of
    0: temp:= 'First';
    1: temp:= 'Second';
    2: temp:= 'Third';
    3: temp:= 'Fourth';
    4: temp:= 'Fifth';
  Else
    temp := 'Next';
  End;
  Launcher1.Caption:= temp + #32 + 'point of entity';
End;

procedure TfrmRounded.Launcher1MouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer; const WX,
  WY: Double);
Var
  Key: Char;
  CurrPoint: TEzPoint;
Begin
  { right button accepts the entity }
  If Button = mbRight Then
  begin
    Key:= #13 ;
    Launcher1KeyPress(Nil, Key);
    Exit;
  end;

  { get a snapped point }
  CurrPoint := fMain.Form1.CmdLine1.GetSnappedPoint;

  Self.FLastClicked:= Point2d(WX,WY);

  AddPoint( CurrPoint );

  { check if closed }
  If chkClosed.Checked And (FEntity.Points.Count > 2) And
    EqualPoint2d( FEntity.Points[0], FEntity.Points[FEntity.Points.COunt-1]) Then
  Begin
    Key:=#13;
    FEntity.Points.Add( CurrPoint );
    Launcher1KeyPress(Nil,Key);
  End;
end;

procedure TfrmRounded.Launcher1MouseMove(Sender: TObject;
  Shift: TShiftState; X, Y: Integer; const WX, WY: Double);
Var
  CurrPoint, P1, P2: TEzPoint;
  DX, DY, Area, Perimeter, Angle: Double;
  nd: Integer;
Begin
  With fMain.Form1.CmdLine1 Do
  Begin
    if Not EqualPoint2d( Self.FLastClicked, INVALID_POINT) Then
    begin
      All_DrawEntity2DRubberBand( FEntity );
      DrawRubberArcs;
    end;

    CurrPoint := GetSnappedPoint;
    SetCurrentPoint( CurrPoint, UseOrto );

    DrawRubberArcs;
    All_DrawEntity2DRubberBand( FEntity );

    // show some info
    If FCurrentIndex > 0 Then
    Begin
      With ActiveDrawBox Do
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
          With ActiveDrawBox Do
          Begin
            Area := FEntity.Area;
            Perimeter := FEntity.Perimeter;
          End;
        End;
        nd:= NumDecimals;
        StatusMessage := Format( '< %.*n, DX = %.*n, DY = %.*n, Area = %.*n, Dist = %.*n',
          [nd, Angle, nd, DX, nd, DY, nd, Area, nd, Perimeter] );
      End
    End
    Else
      StatusMessage := '';
  End;
end;

procedure TfrmRounded.Launcher1Paint(Sender: TObject);
begin
  DrawRubberArcs(Sender);
  (Sender As TEzBaseDrawBox).DrawEntity2DRubberBand( FEntity );
end;

procedure TfrmRounded.Launcher1SuspendOperation(Sender: TObject);
begin
  If Not EqualPoint2d( Self.FLastClicked, INVALID_POINT) Then
  begin
    fMain.Form1.CmdLine1.All_DrawEntity2DRubberBand( FEntity );
    DrawRubberArcs;
  end;
end;

procedure TfrmRounded.Launcher1ContinueOperation(Sender: TObject);
begin
  If Not EqualPoint2d( Self.FLastClicked, INVALID_POINT) Then
  begin
    DrawRubberArcs;
    fMain.Form1.CmdLine1.All_DrawEntity2DRubberBand( FEntity );
  end;
end;

procedure TfrmRounded.cboStyleChange(Sender: TObject);
var
  I: Integer;
begin
  DrawRubberArcs;
  fMain.Form1.CmdLine1.All_DrawEntity2DRubberBand( FEntity );
  Try
    NumEd1.Enabled:= (cboStyle.ItemIndex = 1);
    If FCurrentIndex < 2 then Exit;
    If FRadiuses.Count < FEntity.Points.Count then
      for I:= 0 to FEntity.Points.Count do
        FRadiuses.Add(0);
    If cboStyle.ItemIndex = 0 then
      FRadiuses[FCurrentIndex-1]:= 0
    else
      FRadiuses[FCurrentIndex-1]:= NumEd1.NumericValue;
    If FCurrentIndex >= FRadiuses.Count Then
      FRadiuses.Add(0.0);
    FRadiuses[FCurrentIndex]:= FRadiuses[FCurrentIndex-1];
  Finally
    fMain.Form1.CmdLine1.All_DrawEntity2DRubberBand( FEntity );
    DrawRubberArcs;
  End;
end;

procedure TfrmRounded.Button1Click(Sender: TObject);
begin
  Close;
end;

procedure TfrmRounded.NumEd1Change(Sender: TObject);
begin
  cboStyle.OnChange(Nil);
end;

end.
