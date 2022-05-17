unit uKisEzActions;

interface

uses
  SysUtils, Classes, Controls, Forms, Types, Windows,
  uGeoUtils,
  EzLib, EzCmdLine, EzBaseGis, EzEntities, EzBase, EzSystem, EzCOnsts;

type
  TKisMapMeasureAction = class(TEzAction)
  private
    FPolyline: TEzEntity;
    FCurrentIndex: Integer;
    fHintWindow: THintWindow;
    procedure SetCurrentPoint(Pt: TEzPoint; Orto: Boolean);
    procedure ShowAreaAndPerimeter;
  protected
    procedure MyMouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer; const WX, WY: Double);
    procedure MyMouseMove(Sender: TObject; Shift: TShiftState; X, Y: Integer; const WX, WY: Double);
    procedure MyKeyPress(Sender: TObject; var Key: Char);
    procedure MyPaint(Sender: TObject);
    procedure SuspendOperation(Sender: TObject);
    procedure ContinueOperation(Sender: TObject);
  public
    constructor CreateAction(CmdLine: TEzCmdLine);
    destructor Destroy; override;
    //
    procedure UndoOperation; override;
  end;

implementation

{ TKisMapMeasureAction }

constructor TKisMapMeasureAction.CreateAction(CmdLine: TEzCmdLine);
begin
  inherited CreateAction( CmdLine );

  FPolyline := TEzPolyLine.Create( 1 );
  EzSystem.GlobalTempEntity := FPolyline;

  CanDoOsnap := True;
  CanDoAccuDraw := True;
  MouseDrawElements:= [mdCursorFrame, mdFullViewCursor];

  OnMouseDown := MyMouseDown;
  OnMouseMove := MyMouseMove;
  OnKeyPress := MyKeyPress;
  OnPaint := MyPaint;
  OnSuspendOperation := Self.SuspendOperation;
  OnContinueOperation := Self.ContinueOperation;

  fHintWindow := THintWindow.Create(Application);
  fHintWindow.Color := Ez_Preferences.HintColor;

  Cursor := crDrawCross;
  Caption := SDefineFromPoint;
end;

Destructor TKisMapMeasureAction.Destroy;
Begin
  EzSystem.GlobalTempEntity := Nil;
  FPolyline.Free;
  With fHintWindow Do
  Begin
    ReleaseHandle;
    Free;
  End;
  Inherited Destroy;
End;

procedure TKisMapMeasureAction.SuspendOperation(Sender: TObject);
begin
  If Assigned( FPolyline ) Then
    CmdLine.All_DrawEntity2DRubberBand( FPolyline );
end;

procedure TKisMapMeasureAction.ContinueOperation(Sender: TObject);
begin
  If Assigned( FPolyline ) Then
    CmdLine.All_DrawEntity2DRubberBand( FPolyline );
end;

Procedure TKisMapMeasureAction.ShowAreaAndPerimeter;
Var
  TmpPoly: TEzPolyLine;
  cnt: Integer;
  s: String;
  r: Windows.TRect;
  Perimeter: Double;
  p: TPoint;
Begin
  TmpPoly := TEzPolyLine.Create( FPolyline.Points.Count );
  Try
    For cnt := 0 To FCurrentIndex - 1 Do
      TmpPoly.Points.Add( FPolyline.Points[cnt] );
    Perimeter := TmpPoly.Perimeter( );
    If CmdLine.ShowMeasureInfoWindow Then
    Begin
      // есть длина в юнитах карты - в метрах
      // надо перевести в
      s := Format(
            'На местности: %.1f м' + sLineBreak + 'На бумаге: %.2f мм',
            [Perimeter, Perimeter * 2]
      );

      r := fHintWindow.CalcHintRect(Screen.Width, s, Nil);
      InflateRect( r, 2, 2 );
      p := CmdLine.ActiveDrawBox.ClientToScreen( Point( 0, 0 ) );
      //p := Mouse.CursorPos;
      //p.X := p.X + 5;
      OffsetRect( r, p.X, p.Y );
      fHintWindow.ActivateHint( r, s );
    End;
  Finally
    TmpPoly.Free;
  End;
End;

Procedure TKisMapMeasureAction.SetCurrentPoint( Pt: TEzPoint; Orto: Boolean );
Var
  I: Integer;
Begin
  If Orto And ( FCurrentIndex > 0 ) Then
    Pt := ChangeToOrtogonal( FPolyline.Points[FCurrentIndex - 1], Pt );
  FPolyline.Points[FCurrentIndex] := Pt;
  For I := FCurrentIndex + 1 To FPolyline.Points.Count - 1 Do
    FPolyline.Points[I] := Pt;
End;

Procedure TKisMapMeasureAction.MyMouseDown( Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer; Const WX, WY: Double );
Var
  CurrPoint: TEzPoint;
  Key: Char;
Begin
  If Button = mbRight Then
  begin
    Key:= #13 ;
    MyKeyPress( Nil, Key );
    Exit;
  end;
  With CmdLine Do
  Begin
    CurrPoint := GetSnappedPoint;
    SetCurrentPoint( CurrPoint, UseOrto );
    If FCurrentIndex = 0 Then
      AccuDraw.UpdatePosition( CurrPoint, CurrPoint)
    Else
      AccuDraw.UpdatePosition( FPolyline.Points[FCurrentIndex-1], CurrPoint );
    Inc( FCurrentIndex );
    Caption := SDefineToPoint;
    ShowAreaAndPerimeter;
  End;
End;

Procedure TKisMapMeasureAction.MyMouseMove( Sender: TObject; Shift: TShiftState;
  X, Y: Integer; Const WX, WY: Double );
Var
  CurrPoint: TEzPoint;
//  P1, P2: TEzPoint;
//  Angle, Area, Perimeter, DX, DY: Double;
//  nd: Integer;
Begin
  With CmdLine Do
  Begin
    All_DrawEntity2DRubberBand( FPolyline );
    CurrPoint := GetSnappedPoint;
    SetCurrentPoint( CurrPoint, UseOrto );
    All_DrawEntity2DRubberBand( FPolyline );

    // show some info
    If FCurrentIndex > 0 Then
    Begin
//      P1 := FPolyline.Points[FCurrentIndex - 1];
//      P2 := FPolyline.Points[FCurrentIndex];
//      DX := Abs( P2.X - P1.X );
//      DY := Abs( P2.Y - P1.Y );
//      If ( DX = 0 ) And ( DY = 0 ) Then
//      Begin
//        Angle := 0;
//        Area := 0;
//        Perimeter := 0;
//      End
//      Else
//      Begin
//        Angle := RadToDeg( Angle2D( P1, P2 ) );
//        Area := FPolyline.Area( );
//        Perimeter := FPolyline.Perimeter( );
//      End;
//      nd:= ActiveDrawBox.NumDecimals;
//      StatusMessage := Format( SNewEntityInfo,
//        [nd, Angle, nd, DX, nd, DY, nd, Area, nd, Perimeter] );
    End
  End;
End;

Procedure TKisMapMeasureAction.MyPaint( Sender: TObject );
Begin
  If FPolyline <> Nil Then
    (Sender As TEzBaseDrawBox).DrawEntity2DRubberBand( FPolyline );
End;

Procedure TKisMapMeasureAction.UndoOperation;
Var
  CurrPoint: TEzPoint;
Begin
{erase last defined point}
  With CmdLine Do
  Begin
    All_DrawEntity2DRubberBand( FPolyline );
    If FCurrentIndex > 0 Then
      Dec( FCurrentIndex );
    ShowAreaAndPerimeter;
    CurrPoint := CmdLine.GetSnappedPoint;
    SetCurrentPoint( CurrPoint, CmdLine.UseOrto );
    All_DrawEntity2DRubberBand( FPolyline );
    If FCurrentIndex > 0 Then
      Caption := SDefineToPoint
    Else
      Caption := SDefineFromPoint;
  End;
End;

procedure TKisMapMeasureAction.MyKeyPress(Sender: TObject; var Key: Char);
begin
  with CmdLine do
    if Key In [#13, #27] then
    begin
      All_DrawEntity2DRubberBand( FPolyline );
      Self.Finished := true;
      key := #0;
      Exit;
    end;
end;

initialization
  TEzMap500Entity.NomenclatureFunc := GetNomenclatureCoords500;

end.
