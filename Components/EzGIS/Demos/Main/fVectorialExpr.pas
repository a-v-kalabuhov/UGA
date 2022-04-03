unit fVectorialExpr;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, Grids, StdCtrls, EzActionLaunch, EzNumEd, ezbase,ezlib,ezbasegis,
  Buttons, ezcmdline;

type
  TfrmVectorialExpr = class(TForm)
    Panel4: TPanel;
    Panel5: TPanel;
    Panel6: TPanel;
    Panel7: TPanel;
    LblW: TLabel;
    NumEd1: TEzNumEd;
    Launcher1: TEzActionLauncher;
    Panel1: TPanel;
    Panel8: TPanel;
    cboOp1: TComboBox;
    Memo1: TMemo;
    Panel9: TPanel;
    Splitter2: TSplitter;
    LBVector: TListBox;
    Button1: TSpeedButton;
    Memo2: TMemo;
    Panel10: TPanel;
    Label1: TLabel;
    MemoResult: TMemo;
    SpeedButton1: TSpeedButton;
    Button2: TButton;
    Button3: TButton;
    procedure cboOp1Change(Sender: TObject);
    procedure LBVectorClick(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure Launcher1Finished(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure Memo2Change(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure SpeedButton1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Launcher1TrackedEntity(Sender: TObject;
      const TrackID: String; var TrackedEntity: TEzEntity);
  private
    { Private declarations }
    FDrawBox: TEzBaseDrawBox;
    FCmdLine: TEzCmdLine;
    FLayer: TEzBaseLayer;
    FOwnerForm: TCustomForm;
    procedure CalcExpression;
  public
    { Public declarations }
    procedure Enter(OwnerForm: TCustomForm; DrawBox: TEzBaseDrawBox; CmdLine: TEzCmdLine;Layer: TEzBaseLayer);
    procedure CreateParams(var Params: TCreateParams); override;
  end;

implementation

uses
  fMain, EzSystem, fSelec, fSpatialQuery;

{$R *.dfm}

{ TfrmVectorialExpr }

procedure TfrmVectorialExpr.Enter(OwnerForm: TCustomForm; DrawBox: TEzBaseDrawBox; CmdLine: TEzCmdLine; Layer: TEzBaseLayer);
begin
  FOwnerForm:= OwnerForm;
  FDrawBox:= DrawBox;
  FCmdLine:= CmdLine;
  FLayer:=Layer;
  NumEd1.NumericValue:= DrawBox.Grapher.PointsToDistY(12);
  LBVector.ItemIndex:= 0;
  cboOp1.ItemIndex:=0;
  cboOp1.OnChange(nil);

  Caption:= Caption + #32 + 'For Layer ' + FLayer.Name;

  FOwnerForm.Hide;

  Show;
end;

procedure TfrmVectorialExpr.cboOp1Change(Sender: TObject);
begin
  If cboOp1.ItemIndex < 0 then exit;
  case TEzGraphicOperator(cboOp1.ItemIndex) of
    goWithin:
      begin
        Memo1.Text:= 'Entity A is Within Entity B ( partially or fully inside )';
      end;
    goEntirelyWithin:
      begin
        Memo1.Text:= 'Entity A is Entirely Within Entity B if A''s boundary is entirely within B''s boundary' ;
      end;
    goContains:
      begin
        Memo1.Text:='Entity A Contains Entity B if B''s boundary is anywhere within A''s boundary ';
      end;
    goContainsEntire:
      begin
        Memo1.Text:='Entity A Contains Entire Entity B if B''s boundary is entirely within A''s boundary ';
      end;
    goIntersects:
      begin
        Memo1.Text:='Entity A Intersects Entity B if they have at least one point in common or if one of them is entirely within the other.';
      end;
    goEntirelyWithinNoEdgeTouched:
      begin
        Memo1.Text:='Entity A is Entirely Within Entity B if A''s boundary is entirely within B''s boundary. Additionally Entity A does not touch boundaries of entity B';
      end;
    goContainsEntireNoEdgeTouched:
      begin
        Memo1.Text:='Entity A Contains Entire Entity B if B''s boundary is entirely within A''s boundary. Additionaly, Entity B does not touch boundaries of entity A.';
      end;
    goExtentOverlaps:
      begin
        Memo1.Text:='The extents of entity A overlaps the extents of entity B';
      end;
    goShareCommonPoint:
      begin
        Memo1.Text:='Entity A share at least one identical common point with Entity B';
      end;
    goShareCommonLine:
      begin
        Memo1.Text:='Entity A have at least one line segment identical to Entity B';
      end;
    goLineCross:
      begin
        Memo1.Text:='Entity A intersects to Entity B. The difference with operator INTERSECTS is that this last considere intersection also if Entity A is fully inside Entity B or viceversa';
      end;
    goCommonPointOrLineCross:
      begin
        Memo1.Text:='Both SHARE COMMON POINT and SHARE COMMON LINE combined';
      end;
    goEdgeTouch:
      begin
        Memo1.Text:='Entity A touches entity B or Entity B touches entity A without both having common area';
      end;
    goEdgeTouchOrIntersect:
      begin
        Memo1.Text:='Entity A touches entity B or Entity B touches entity A or both having common area ';
      end;
    goPointInPolygon:
      begin
        Memo1.Text:='First Point of Entity A is inside Polygon B';
      end;
    goCentroidInPolygon:
      begin
        Memo1.Text:='Centroid of Entity A is inside Polygon B';
      end;
    goIdentical:
      begin
        Memo1.Text:='Entity A is identical to Entity B in the point coordinates, not in the features (fill color, line color, etc.).';
      end;
  end;
  CalcExpression;
end;

procedure TfrmVectorialExpr.CalcExpression;
var
  temp, temp2: string;
begin
  if cboOp1.ItemIndex < 0 then exit;
  temp:= FLayer.Name;
  if AnsiPos(#32,temp)>0 then
    temp:= '[' + temp + ']';
  If LBVector.ItemIndex < 3 then
    temp2:= LBVector.Items[LBVector.ItemIndex]
  else
    temp2:= 'POLYGON';
  temp:= temp + '.ENT' + #32 + cboOp1.Text + #32 + temp2 + #32 ;
  temp:= temp + '([ ' + Memo2.Lines.Text + ' ])';
  If LBVector.ItemIndex=2 then
    temp := temp + ' WIDTH ' + FloatToStr(NumEd1.Numericvalue);

  MemoResult.Text:= temp;
end;

procedure TfrmVectorialExpr.LBVectorClick(Sender: TObject);
begin
  LblW.Enabled:= LBVector.ItemIndex= 2;
  NumEd1.Enabled:= LBVector.ItemIndex= 2;
  CalcExpression;
end;

procedure TfrmVectorialExpr.Button1Click(Sender: TObject);
begin
  Self.Hide;
  Launcher1.CmdLine:= FCmdLine;
  If LBVector.ItemIndex=0 then
    Launcher1.TrackPolygon('')
  else If LBVector.ItemIndex=3 then
    Launcher1.TrackBuffer('')
  else
    Launcher1.TrackPolyline('');
end;

procedure TfrmVectorialExpr.Launcher1Finished(Sender: TObject);
begin
  { finish every action launched when this was active }
  FCmdLine.Clear;
  { Show method is here because you can finish the action by pressing ESC in which case
   OnTrackedEntity is never fired}
  Show;
end;

procedure TfrmVectorialExpr.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  If FOwnerForm Is TfrmSelectDlg Then
    TfrmSelectDlg(FOwnerForm).frmVectorialExpr:= Nil
  Else If FOwnerForm Is TfrmSpatialQuery Then
    TfrmSpatialQuery(FOwnerForm).frmVectorialExpr:= Nil;

  FOwnerForm.Show;
  
  Action:= caFree;
end;

procedure TfrmVectorialExpr.Memo2Change(Sender: TObject);
begin
  CalcExpression;
end;

procedure TfrmVectorialExpr.CreateParams(var Params: TCreateParams);
begin
  Inherited CreateParams( Params );
  With Params Do
  Begin
    Style := Style Or ws_Overlapped;
    WndParent := fMain.Form1.Handle;
  end;
end;

procedure TfrmVectorialExpr.Button3Click(Sender: TObject);
begin
  Close;
end;

procedure TfrmVectorialExpr.SpeedButton1Click(Sender: TObject);
Var
  Ent, BufferEnt: TEzEntity;
Begin
  If Length( Trim( Memo2.Text ) ) = 0 Then exit;
  Ent:= Nil;
  Case LBVector.ItemIndex Of
    0: Ent := FDrawBox.CreateEntity( idPolygon );
    1: Ent := FDrawBox.CreateEntity( idPolyline );
    2: Ent := FDrawBox.CreateEntity( idPolyline );
    3: Ent := FDrawBox.CreateEntity( idPolygon );
  End;
  If Ent=Nil then Exit;
  Try
    Ent.Points.AsString:= Memo2.Text;
    If LBVector.ItemIndex = 2 Then
    Begin
      BufferEnt := ezsystem.CreateBufferFromEntity( ent, 50, NumEd1.NumericValue );
      FDrawBox.BlinkEntity( BufferEnt );
      BufferEnt.Free;
    End
    Else
      FDrawBox.BlinkEntity( Ent );
  Finally
    Ent.Free;
  End;
end;

procedure TfrmVectorialExpr.Button2Click(Sender: TObject);
begin
  If FOwnerForm Is TfrmSelectDlg Then
    TfrmSelectDlg(FOwnerForm).MemoWhere.Text:= MemoResult.Text
  Else If FOwnerForm Is TfrmSpatialQuery Then
    TfrmSpatialQuery(FOwnerForm).MemoVect.Text:=MemoResult.Text;
  Close;
end;

procedure TfrmVectorialExpr.Launcher1TrackedEntity(Sender: TObject;
  const TrackID: String; var TrackedEntity: TEzEntity);
begin
  { force closed polygons }
  If ((LBVector.ItemIndex=0) or (LBVector.ItemIndex=3)) and
     Not EqualPoint2d(TrackedEntity.Points[0], TrackedEntity.Points[TrackedEntity.Points.Count-1]) then
    TrackedEntity.Points.Add(TrackedEntity.Points[0]);

  Memo2.Lines.Text:= TrackedEntity.Points.AsString;
end;

end.

