unit uMStGISEzActionsMeasure;

interface

uses
  // System
  SysUtils, Windows, Classes, Controls, Clipbrd, Graphics, Forms, Messages,
  // EzGIS
  EzCmdLine, EzBaseGIS, EzLib, EzSystem, EzEntities, EzConsts, EzActionLaunch,
  EzActions, EzBase, EzPreview, EzMiscelEntities,
  //
  uMStGISEzActions;

type
  TmstMeasureAction = class(TmstAddEntityAction)
  private
    procedure DoNextPoint(Sender: TObject);
  protected
    procedure MyMouseDown(Sender: TObject; Button: TMouseButton; Shift:
      TShiftState; X, Y: Integer; const WX, WY: Double); override;
    procedure MyMouseMove(Sender: TObject; Shift: TShiftState;
      X, Y: Integer; const WX, WY: Double); override;
    procedure UpdateResult; override;
    procedure UpdateLastPoint;
  public
    constructor CreateAction(CmdLine: TEzCmdLine);
    procedure InsertPoint(const Pt: TEzPoint; Index: Integer); override;
    procedure ReplacePoint(const Pt: TEzPoint; Index: Integer); override;
    procedure RemovePoint(Index: Integer); override;
    procedure ClearPoints; override;
  end;

  TmstAddLotAction = Class(TmstAddEntityAction)
  protected
    procedure MyMouseDown(Sender: TObject; Button: TMouseButton; Shift:
      TShiftState; X, Y: Integer; const WX, WY: Double); override;
    procedure MyMouseMove(Sender: TObject; Shift: TShiftState;
      X, Y: Integer; const WX, WY: Double); override;
    procedure MyKeyPress(Sender: TObject; var Key: Char); override;
  public
    constructor CreateAction(CmdLine: TEzCmdLine);
    procedure InsertPoint(const Pt: TEzPoint; Index: Integer); override;
    procedure ReplacePoint(const Pt: TEzPoint; Index: Integer); override;
    procedure RemovePoint(Index: Integer); override;
    procedure ClearPoints; override;
  end;

implementation

uses
  uMStFormMeasureResult;

constructor TmstMeasureAction.CreateAction(CmdLine: TEzCmdLine);
begin
  inherited CreateAction(CmdLine, TEzPolyline.CreateEntity([{Point2D(0, 0)}]));
end;

procedure TmstMeasureAction.MyMouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer; const WX,
  WY: Double);
begin
  inherited;
  UpdateViews;
  UpdateResult;
end;

procedure TmstMeasureAction.MyMouseMove(Sender: TObject; Shift: TShiftState;
  X, Y: Integer; const WX, WY: Double);
begin
  inherited;
  UpdateResult;
end;

procedure TmstMeasureAction.InsertPoint(const Pt: TEzPoint; Index: Integer);
begin
  if (Index < 0) or (Index > FEntity.Points.Count) then
    raise EAbort.Create('Неверный индекс точки!')
  else
  if Index = Pred(FEntity.Points.Count) then
    FEntity.Points[Pred(FEntity.Points.Count)] := Pt
  else
  begin
    FEntity.Points.Insert(Index, Pt);
    FEntity.Points.Delete(FCurrentIndex + 1);
  end;
  Inc(FCurrentIndex);
  DrawEntityRubberToAll(Nil);
  CmdLine.ActiveDrawBox.Invalidate;
  UpdateViews;
  UpdateResult;
  UpdateLastPoint;
end;

procedure TmstMeasureAction.ClearPoints;
begin
  inherited;
  UpdateViews;
  UpdateResult;
  UpdateLastPoint;
end;

procedure TmstMeasureAction.RemovePoint(Index: Integer);
begin
  inherited;
  if (Index < 0) or (Index >= FEntity.Points.Count) then
    raise EAbort.Create('Неверный индекс точки!')
  else
  begin
    FEntity.Points.Delete(Index);
    Dec(FCurrentIndex);
    FEntity.Points.Count := FCurrentIndex;
    UpdateViews;
    CmdLine.ActiveDrawBox.Invalidate;
  end;
  UpdateLastPoint;
end;

procedure TmstMeasureAction.ReplacePoint(const Pt: TEzPoint; Index: Integer);
begin
  inherited;
  if (Index < 0) or (Index >= FEntity.Points.Count) then
    raise EAbort.Create('Неверный индекс точки!')
  else
  begin
    FEntity.Points.X[Index] := Pt.x;
    FEntity.Points.Y[Index] := Pt.y;
    FEntity.Points.Count := FCurrentIndex;
    UpdateViews;
    UpdateResult;
    CmdLine.ActiveDrawBox.Invalidate;
  end;
  UpdateLastPoint;
end;

procedure TmstMeasureAction.UpdateResult;
var
  Area, Perimeter, LastLength: Double;
  Ent: TEzPolyline;
begin
  if FEntity = nil then
  begin
    Area := -1;
    Perimeter := -1;
    LastLength := -1;
  end
  else
  begin
    Ent := TEzPolyline.CreateEntity([Point2D(0, 0)], True);
    Ent.Assign(FEntity);
    if FCurrentIndex < Ent.Points.Count then
      Ent.Points.Delete(FcurrentIndex);
    Area := Ent.Area;
    Perimeter := Ent.Perimeter;
    with FEntity.Points do
      if (FCurrentIndex < 1) or (Count = (FCurrentIndex)) then LastLength := 0
      else
        LastLength := Sqrt(Sqr(x[FCurrentIndex - 1] - x[FCurrentIndex]) +
                         Sqr(y[FCurrentIndex - 1] - y[FCurrentIndex]));
    FreeAndNil(Ent);
  end;
  uMStFormMeasureResult.ShowMeasureResult(Area, Perimeter, LastLength);
  frmMeasureResult.btnGo.OnClick := DoNextPoint;
  CmdLine.ActiveDrawBox.SetFocus;
end;

procedure TmstAddLotAction.ClearPoints;
begin
  inherited;
  UpdateViews;
  UpdateResult;
end;

constructor TmstAddLotAction.CreateAction(CmdLine: TEzCmdLine);
begin
  Inherited CreateAction( CmdLine, TEzPolygon.CreateEntity([Point2D(0, 0)]));
end;

procedure TmstAddLotAction.InsertPoint(const Pt: TEzPoint; Index: Integer);
var
  lastPt: TEzPoint;
  currPt: TEzPoint;
begin
  if (Index < 0) or (Index > FEntity.Points.Count) then
    raise EAbort.Create('Неверный индекс точки!')
  else
  if Index = FEntity.Points.Count then
  begin
    inherited AddPoint(Pt);
    Self.LastClicked := Pt;
    DrawEntityRubberToAll(Nil);
  end
  else
  begin
    currPt := FEntity.Points[FCurrentIndex];
    lastPt := FEntity.Points[FCurrentIndex - 1];
    FEntity.Points.Insert(Index, Pt);
    FEntity.Points.Delete(FCurrentIndex + 1);
    inherited AddPoint(lastPt);
    UpdateViews;
    UpdateResult;
    DrawEntityRubberToAll(Nil);
  end;
  UpdateViews;
  UpdateResult;
  with CmdLine.ActiveDrawBox do Invalidate;
end;

procedure TmstAddLotAction.MyKeyPress(Sender: TObject; var Key: Char);
begin
  inherited;
  UpdateViews;
  UpdateResult;
end;

procedure TmstAddLotAction.MyMouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer; const WX,
  WY: Double);
begin
  inherited;
  UpdateViews;
  UpdateResult;
end;

procedure TmstAddLotAction.MyMouseMove(Sender: TObject; Shift: TShiftState;
  X, Y: Integer; const WX, WY: Double);
begin
  inherited;
  UpdateResult;
end;

procedure TmstAddLotAction.RemovePoint(Index: Integer);
var
  C: Char;
begin
  inherited;
  if (Index < 0) or (Index >= FEntity.Points.Count) then
    raise EAbort.Create('Неверный индекс точки!')
  else
  begin
    FEntity.Points.Delete(Index);
    C := #27;
    MyKeyPress(nil, C);
  end;
  UpdateViews;
  UpdateResult;
  with CmdLine.ActiveDrawBox do Invalidate;
end;

procedure TmstAddLotAction.ReplacePoint(const Pt: TEzPoint; Index: Integer);
begin
  inherited;
  if (Index < 0) or (Index >= FEntity.Points.Count) then
    raise EAbort.Create('Неверный индекс точки!')
  else
  begin
    FEntity.Points.X[Index] := Pt.x;
    FEntity.Points.Y[Index] := Pt.y;
    UpdateViews;
    UpdateResult;
  end;
  UpdateViews;
  UpdateResult;
  CmdLine.ActiveDrawBox.Invalidate;
end;

procedure TmstMeasureAction.DoNextPoint(Sender: TObject);
const
  OneGrad = pi / 180;
var
  L: Double;
  Grad, Min, Sec: Integer;
  LastPt, NewPt: TEzPoint;
  Corner: Double;
begin
  if FEntity.Points.Count > 1 then
  if Assigned(frmMeasureResult) then
    with frmMeasureResult do
    begin
      L := StrToFloat(edNewLength.Text);
      Grad := StrToInt(edNewGrad.Text);
      Min := StrToInt(edNewMin.Text);
      Sec := StrToInt(edNewSec.Text);
      Corner := (90 - Grad - Min / 60 - Sec / 3600) * OneGrad;
      LastPt := FEntity.Points[FEntity.Points.Count - 2];
      NewPt := Point2D(
        LastPt.x + L * cos(Corner),
        LastPt.y + L * sin(Corner)
      );
      AddPoint(NewPt);
      UpdateViews;
      UpdateResult;
      with CmdLine.ActiveDrawBox do Invalidate;
    end;
  UpdateLastPoint;
end;

procedure TmstMeasureAction.UpdateLastPoint;
begin
//  FEntity.Points.Count:= FCurrentIndex;
  { update the last clicked point (used when snapping to paraller, perpendicular,etc) }
  If FEntity.Points.Count = 0 Then
    Self.LastClicked := INVALID_POINT
  Else
    Self.LastClicked := FEntity.Points[FCurrentIndex - 1];
  SetCurrentPoint(CmdLine.CurrentPoint, CmdLine.UseOrto);
  DrawEntityRubberToAll(Nil);
  If (FEntity.EntityID in [idPolyline,idPolygon,idArc,idSpline,idNodeLink]) then
  begin
    If FCurrentIndex = 1 Then
      CmdLine.AccuDraw.UpdatePosition( FEntity.Points[0], FEntity.Points[0] )
    Else If FCurrentIndex > 0 Then
      CmdLine.AccuDraw.UpdatePosition( FEntity.Points[FCurrentIndex-2], FEntity.Points[FCurrentIndex-1] );
  end;
end;

end.
