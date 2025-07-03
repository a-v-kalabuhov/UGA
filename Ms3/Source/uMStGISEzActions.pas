unit uMStGISEzActions;

interface

uses
  // System
  SysUtils, Windows, Classes, Controls, Clipbrd, Graphics, Forms, Messages,
  // EzGIS
  EzCmdLine, EzBaseGIS, EzLib, EzSystem, EzEntities, EzConsts, EzActionLaunch,
  EzActions, EzBase, EzPreview, EzMiscelEntities;

type
  TPointListChange = procedure (PointList: TEzVector) of object;

  TmstAddEntityAction = class(TAddEntityAction)
  private
    FOnPointListChange: TPointListChange;
  protected
    procedure UpdateViews; virtual;
    procedure UpdateResult; virtual; abstract;
    procedure MyKeyPress(Sender: TObject; var Key: Char); override;
  public
    constructor CreateAction( CmdLine: TEzCmdLine; NewEntity: TEzEntity);
    procedure InsertPoint(const Pt: TEzPoint; Index: Integer); virtual; abstract;
    procedure ReplacePoint(const Pt: TEzPoint; Index: Integer); virtual; abstract;
    procedure RemovePoint(Index: Integer); virtual; abstract;
    procedure ClearPoints; virtual; abstract;
    property OnPointListChange: TPointListChange read FOnPointListChange write FOnPointListChange;
    property Entity;
  end;

  TmstMeasureAction = class(TmstAddEntityAction)
  private
    FShowResult: Boolean;
    procedure DoNextPoint(Sender: TObject);
    procedure SetShowResult(const Value: Boolean);
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
    function Extenstion: TEzRect;
    //
    property ShowResult: Boolean read FShowResult write SetShowResult;
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

uses
  uMStFormMeasureResult;

constructor TmstMeasureAction.CreateAction(CmdLine: TEzCmdLine);
begin
  inherited CreateAction(CmdLine, TEzPolyline.CreateEntity([{Point2D(0, 0)}]));
  FShowResult := True;
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

procedure TmstMeasureAction.SetShowResult(const Value: Boolean);
begin
  FShowResult := Value;
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
  if FShowResult then
  begin
    uMStFormMeasureResult.ShowMeasureResult(Area, Perimeter, LastLength);
    frmMeasureResult.btnGo.OnClick := DoNextPoint;
  end;
  CmdLine.ActiveDrawBox.SetFocus;
end;

constructor TmstAddEntityAction.CreateAction(CmdLine: TEzCmdLine;
  NewEntity: TEzEntity);
begin
  inherited CreateAction(CmdLine, NewEntity, Point(0, 0));
end;

procedure TmstAddEntityAction.MyKeyPress(Sender: TObject; var Key: Char);
begin
  // Нажали Esc - удаляем точку
  if (Key = #27) and Assigned(Entity) then
    RemovePoint(Pred(FEntity.Points.Count));
  inherited;
end;

procedure TmstAddEntityAction.UpdateViews;
begin
  if Assigned(FOnPointListChange) then
    if FEntity = nil then
      FOnPointListChange(nil)
    else
      FOnPointListChange(FEntity.Points);
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

{ TLtAutoHandScrollAction }

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
  if FShowResult then
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

function TmstMeasureAction.Extenstion: TEzRect;
var
  Pt: TEzPoint;
  Tmp: TEzEntity;
begin
  Result := NULL_EXTENSION;
  if FEntity.Points.Count > 0 then
  begin
    Pt := FEntity.Points[FEntity.Points.Count - 1];
    if EqualPoint2D(Pt, CmdLine.CurrentPoint) then
    begin
      Tmp := FEntity.Clone;
      try
        Tmp.Points.Delete(Tmp.Points.Count - 1);
        Result := Tmp.FBox;
      finally
        Tmp.Free;
      end;
    end
    else
      Result := FEntity.FBox;
  end;
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
