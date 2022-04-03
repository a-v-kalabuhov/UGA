unit fMultiPart;

{$I EZ_FLAG.PAS}
interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ezbasegis, EzLib, EzActionLaunch;

type
  TfrmMultiPart = class(TForm)
    Label1: TLabel;
    cboType: TComboBox;
    BtnNew: TButton;
    Button2: TButton;
    Launcher1: TEzActionLauncher;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure BtnNewClick(Sender: TObject);
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
    procedure Button2Click(Sender: TObject);
  private
    { Private declarations }
    FEntity: TEzEntity;
    FTempEntity: TEzEntity;
    FLastClicked: TEzPoint;
    FCurrentIndex: Integer;
    procedure SetCaption;
    procedure SetCurrentPoint( Pt: TEzPoint; Orto: Boolean );
    Procedure AddEntity;
    procedure AddPoint( const CurrPoint: TEzPoint );
    procedure AddPart;
  public
    { Public declarations }
    procedure CreateParams(var Params: TCreateParams); override;
  end;

implementation

{$R *.dfm}

uses
  Math, fMain, EzSystem, EzEntities;

{ TfrmMultiPart }

procedure TfrmMultiPart.CreateParams(var Params: TCreateParams);
begin
  Inherited CreateParams( Params );
  With Params Do
  Begin
    Style := Style Or ws_Overlapped;
    WndParent := fMain.Form1.Handle;
  end;
end;

procedure TfrmMultiPart.FormCreate(Sender: TObject);
begin
  Launcher1.CmdLine:= fMain.Form1.CmdLine1;
  FLastClicked:= EzLib.INVALID_POINT;
  SetCaption;
  cboType.ItemIndex:= 0;
end;

procedure TfrmMultiPart.SetCaption;
var
  temp: string;
Begin
  Case FCurrentIndex Of
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

procedure TfrmMultiPart.FormDestroy(Sender: TObject);
begin
  EzSystem.GlobalTempEntity:= Nil;
  If FEntity <> Nil then FreeAndNil( FEntity );
  If FTempEntity <> Nil then FreeAndNil( FTempEntity );

  Launcher1.Finish;
  fMain.Form1.frmMultiPart:= Nil;
end;

procedure TfrmMultiPart.BtnNewClick(Sender: TObject);
var
  p: TEzPoint;
begin
  { erase current entity }
  If cboType.Enabled then
  begin
    cboType.Enabled:= False;
    p:= Point2d(0,0);
    If Assigned(FEntity) Then FreeAndNil( FEntity );
    If Assigned(FTempEntity) Then FreeAndNil( FTempEntity );
    If cboType.ItemIndex=0 then
    begin
      FEntity:= TEzPolygon.CreateEntity([p]);
      FTempEntity:= TEzPolygon.CreateEntity([p]);
    end else
    begin
      FEntity:= TEzPolyline.CreateEntity([p]);
      FTempEntity:= TEzPolyline.CreateEntity([p]);
    end;
    FEntity.Points.Clear;
    FTempEntity.Points.Clear;
    EzSystem.GlobalTempEntity:= FTempEntity;
    Launcher1.TrackGenericAction('');
  End Else
  Begin
    AddPart;
    fMain.Form1.CmdLine1.All_Invalidate;
  End;
end;

procedure TfrmMultiPart.AddPart;
var
  I,n: Integer;
Begin
  If ((cboType.ItemIndex = 0) And (FTempEntity.Points.Count > 2) ) Or
     ((cboType.ItemIndex = 1) And (FTempEntity.Points.Count > 1) ) Then
  Begin
    FTempEntity.Points.Count:= FCurrentIndex;
    if cboType.ItemIndex = 0 Then
    begin
      If Not EqualPoint2d( FTempEntity.Points[0], FTempEntity.Points[FTempEntity.Points.Count-1] ) Then
        FTempEntity.Points.Add(FTempEntity.Points[0]);
    end;
    n:= FEntity.Points.Count;
    { add this part to the actual entity }
    For I:= 0 to FTempEntity.Points.Count-1 do
      FEntity.Points.Add( FTempEntity.Points[I] );
    If n = 0 Then
      FEntity.Points.Parts.Add(0)
    Else
      FEntity.Points.Parts.Add(n);
  End;
  FTempEntity.Points.Clear;
  FCurrentIndex:= 0;
End;

procedure TfrmMultiPart.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  Action:= caFree;
end;

procedure TfrmMultiPart.SetCurrentPoint( Pt: TEzPoint; Orto: Boolean );
Var
  I: Integer;
Begin
  If Orto And ( FCurrentIndex > 0 ) Then
    Pt := EzLib.ChangeToOrtogonal( FTempEntity.Points[FCurrentIndex - 1], Pt );

  FTempEntity.Points[FCurrentIndex] := Pt;
  For I := FCurrentIndex + 1 To FTempEntity.Points.Count - 1 Do
    FTempEntity.Points[I] := Pt;
End;

Procedure TfrmMultiPart.AddEntity;
Var
  Accept: Boolean;
  TmpLayer: TEzBaseLayer;
  Extents: TEzRect;
  MinDim: Double;
  TmpEnt: TEzEntity;
  Recno: Integer;
Begin
  With FEntity.Points Do
  Begin
    If Parts.Count < 2 Then
      Parts.Clear;
    If Parts[Parts.Count-1] > Count-1 Then
      Parts.Delete(Parts.Count-1);
  End;

  TmpEnt:= FEntity;

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
End;


procedure TfrmMultiPart.Launcher1KeyPress(Sender: TObject; var Key: Char);
begin
  With fMain.Form1 Do
    Case Key Of
      #27:
        Begin
          { erase last draw entity }
          CmdLine1.All_DrawEntity2DRubberBand( FTempEntity );
          If FCurrentIndex = 0 Then Exit;

          Dec( FCurrentIndex );
          FTempEntity.Points.Count:= FCurrentIndex;

          { update the last clicked point (used when snapping to paraller, perpendicular,etc) }
          If FTempEntity.Points.Count = 0 Then
            Self.FLastClicked:= ezlib.INVALID_POINT
          Else
            Self.FLastClicked:= FTempEntity.Points[FCurrentIndex-1];
          with fMain.Form1.CmdLine1 do
            SetCurrentPoint( CurrentPoint, UseOrto );

          { rubber paint entity }
          CmdLine1.All_DrawEntity2DRubberBand( FTempEntity );

          If FCurrentIndex = 1 Then
            CmdLine1.AccuDraw.UpdatePosition( FTempEntity.Points[0], FTempEntity.Points[0] )
          Else If FCurrentIndex > 0 Then
            CmdLine1.AccuDraw.UpdatePosition( FTempEntity.Points[FCurrentIndex-2], FTempEntity.Points[FCurrentIndex-1] );
        End;
    End;
end;

procedure TfrmMultiPart.Launcher1Finished(Sender: TObject);
begin
  Release;
end;

procedure TfrmMultiPart.AddPoint( const CurrPoint: TEzPoint );
Begin
  with fMain.Form1 do
  begin
    { "mark" the clicked point }
    With CmdLine1.ActiveDrawBox Do
      DrawCross( Canvas, Grapher.RealToPoint( CurrPoint ) );
    SetCurrentPoint( CurrPoint, CmdLine1.UseOrto );

    { set AccuDraw position }
    If FCurrentIndex = 0 Then
      CmdLine1.AccuDraw.UpdatePosition( CurrPoint, CurrPoint )  // this activates AccuDraw
    Else If FCurrentIndex > 0 Then
    Begin
      CmdLine1.AccuDraw.UpdatePosition( FTempEntity.Points[FCurrentIndex-1], CurrPoint );
    End;

    Inc( fCurrentIndex );

    Self.SetCaption;
  end;
End;

procedure TfrmMultiPart.Launcher1MouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer; const WX,
  WY: Double);
Var
  CurrPoint: TEzPoint;
Begin
  { right button accepts the entity }
  If Button = mbRight Then Exit;

  { get a snapped point }
  CurrPoint := fMain.Form1.CmdLine1.GetSnappedPoint;

  Self.FLastClicked:= Point2d(WX,WY);

  AddPoint( CurrPoint );

end;

procedure TfrmMultiPart.Launcher1MouseMove(Sender: TObject;
  Shift: TShiftState; X, Y: Integer; const WX, WY: Double);
Var
  CurrPoint, P1, P2: TEzPoint;
  DX, DY, Area, Perimeter, Angle: Double;
  nd: Integer;
Begin
  With fMain.Form1 Do
  Begin
    if Not EqualPoint2d( Self.FLastClicked, INVALID_POINT) Then
    begin
      CmdLine1.All_DrawEntity2DRubberBand( FTempEntity );
    end;

    CurrPoint := CmdLine1.GetSnappedPoint;
    SetCurrentPoint( CurrPoint, CmdLine1.UseOrto );

    CmdLine1.All_DrawEntity2DRubberBand( FTempEntity );

    // show some info
    If FCurrentIndex > 0 Then
    Begin
      P1 := FTempEntity.Points[FCurrentIndex - 1];
      P2 := FTempEntity.Points[FCurrentIndex];
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
        Area := FTempEntity.Area;
        Perimeter := FTempEntity.Perimeter;
      End;
      nd:= DrawBox1.NumDecimals;
      CmdLine1.StatusMessage := Format( '< %.*n, DX = %.*n, DY = %.*n, Area = %.*n, Dist = %.*n',
        [nd, Angle, nd, DX, nd, DY, nd, Area, nd, Perimeter] );
    End
    Else
      CmdLine1.StatusMessage := '';
  End;
end;

procedure TfrmMultiPart.Launcher1Paint(Sender: TObject);
begin
  with fMain.Form1.CmdLine1 do
  begin
    All_DrawEntity2DRubberBand( FTempEntity );
    If FEntity.Points.Count > 0 Then
      All_DrawEntity2DRubberBand( FEntity );
  end;
end;

procedure TfrmMultiPart.Launcher1SuspendOperation(Sender: TObject);
begin
  If Not EqualPoint2d( Self.FLastClicked, INVALID_POINT) Then
  begin
    fMain.Form1.CmdLine1.All_DrawEntity2DRubberBand( FTempEntity );
  end;
  If FEntity.Points.Count > 0 Then
    fMain.Form1.CmdLine1.All_DrawEntity2DRubberBand( FEntity );
end;

procedure TfrmMultiPart.Launcher1ContinueOperation(Sender: TObject);
begin
  If FEntity.Points.Count > 0 Then
    fMain.Form1.CmdLine1.All_DrawEntity2DRubberBand( FEntity );
  If Not EqualPoint2d( Self.FLastClicked, INVALID_POINT) Then
  begin
    fMain.Form1.CmdLine1.All_DrawEntity2DRubberBand( FTempEntity );
  end;
end;

procedure TfrmMultiPart.Button2Click(Sender: TObject);
begin
  fMain.Form1.CmdLine1.All_DrawEntity2DRubberBand( Self.FTempEntity );
  FTempEntity.Points.Delete( FCurrentIndex );

  AddPart;
  AddEntity;

  Launcher1.Finished := true;
end;

end.
