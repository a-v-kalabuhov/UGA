Unit fViews;

{$I EZ_FLAG.PAS}
Interface

Uses Windows, Classes, Forms, Controls, Menus, StdCtrls, Buttons, Messages,
  SysUtils, ezcmdline, ezSystem, ezLib, ezentities, ezbasegis, DBGrids, Grids, Db;

Type
  TfrmViews = Class( TForm )
    BtnUp: TSpeedButton;
    BtnDown: TSpeedButton;
    Label1: TLabel;
    List1: TListBox;
    PopupMenu1: TPopupMenu;
    Current2: TMenuItem;
    Define1: TMenuItem;
    SpeedButton1: TSpeedButton;
    SpeedButton2: TSpeedButton;
    SpeedButton3: TSpeedButton;
    SpeedButton4: TSpeedButton;
    Check1: TCheckBox;
    SpeedButton5: TSpeedButton;
    Procedure FormClose( Sender: TObject; Var Action: TCloseAction );
    Procedure BtnUpClick( Sender: TObject );
    Procedure BtnDownClick( Sender: TObject );
    Procedure FormShow( Sender: TObject );
    procedure List1Click(Sender: TObject);
    procedure Current2Click(Sender: TObject);
    procedure Define1Click(Sender: TObject);
    procedure SpeedButton1Click(Sender: TObject);
    procedure SpeedButton3Click(Sender: TObject);
    procedure SpeedButton4Click(Sender: TObject);
    procedure SpeedButton5Click(Sender: TObject);
    procedure Check1Click(Sender: TObject);
    procedure SpeedButton2Click(Sender: TObject);
  Private
    { Private declarations }
    FCmdLine: tEzCmdLine;
    FOldAutoRestore: Boolean;
    FNeedSave: Boolean;
    Procedure InsertView( ViewWin: TEzRect );
    procedure WMExitSizeMove( Var m: TMessage ); Message WM_EXITSIZEMOVE;
  Protected
{$IFDEF LEVEL3}
    Procedure CreateParams( Var Params: TCreateParams ); Override;
{$ENDIF}
  Public
    { Public declarations }
    Procedure Enter( CmdLine: tEzCmdLine );
{$IFDEF LEVEL4}
    Procedure CreateParams( Var Params: TCreateParams ); Override;
{$ENDIF}
  End;

var
  NamedViewParentHWND: THandle;

Implementation

{$R *.DFM}

Uses
  ezbase,fmain, fAerWin, EzConsts, fNewViw ;

Resourcestring
  SDefineFirstView = 'First corner for new view';
  SDefineSecondView = 'Second corner for new view';
  SDeleteViewWarn = 'Are you sure you want to delete this view ?';

type

  {The state for defining a new view window}
  TDefineViewAction = Class( TEzAction )
  Private
    FFrame: TEzRectangle;
    FCurrentIndex: Integer;
    FDraw: Boolean;
    Frm: TfrmViews;
    Procedure SetCurrentPoint( Const Pt: TEzPoint );
  Protected
    Procedure MyMouseDown( Sender: TObject; Button: TMouseButton; Shift: TShiftState;
      X, Y: Integer; Const WX, WY: Double );
    Procedure MyMouseUp( Sender: TObject; Button: TMouseButton; Shift: TShiftState;
      X, Y: Integer; Const WX, WY: Double );
    Procedure MyMouseMove( Sender: TObject; Shift: TShiftState;
      X, Y: Integer; Const WX, WY: Double );
    Procedure MyKeyPress( Sender: TObject; Var Key: Char );
    Procedure MyPaint( Sender: TObject );
  Public
    Constructor CreateAction( CmdLine: TEzCmdLine; ViewFrm: TfrmViews );
    Destructor Destroy; Override;
  End;

{ TDefineViewAction - class implementation }

Constructor TDefineViewAction.CreateAction( CmdLine: TEzCmdLine; ViewFrm: TfrmViews );
Begin
  Inherited CreateAction( CmdLine );

  Frm := ViewFrm;

  CanBeSuspended := false;

  FFrame := TEzRectangle.CreateEntity( Point2D( 0, 0 ), Point2D( 0, 0 ) );

  OnMouseDown := MyMouseDown;
  OnMouseUp := MyMouseUp;
  OnMouseMove := MyMouseMove;
  OnPaint := MyPaint;
  OnKeyPress := MyKeyPress;

  Cursor := crCross;
  Caption := SDefineFirstView;
End;

Destructor TDefineViewAction.Destroy;
Begin
  FFrame.Free;
  Caption := '';
  Inherited Destroy;
End;

Procedure TDefineViewAction.SetCurrentPoint( Const Pt: TEzPoint );
Var
  I: Integer;
Begin
  FFrame.Points[FCurrentIndex] := Pt;
  For I := FCurrentIndex + 1 To FFrame.Points.Count - 1 Do
    FFrame.Points[I] := Pt;
End;

Procedure TDefineViewAction.MyMouseDown( Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer; Const WX, WY: Double );
Var
  CurrPoint: TEzPoint;
  TmpRect: TEzRect;
Begin
  If Button = mbRight Then Exit;
  FDraw := false;
  With CmdLine.ActiveDrawBox Do
  Begin
    CurrPoint := CmdLine.CurrentPoint;
    SetCurrentPoint( CurrPoint );
    If FCurrentIndex >= 1 Then
    Begin
      DrawEntity2DRubberBand( FFrame, false,false );
      FDraw := false;
      TmpRect.Emin := FFrame.Points[0];
      TmpRect.Emax := FFrame.Points[1];
      TmpRect := ReorderRect2D( TmpRect );
      Frm.Show;
      Frm.InsertView( TmpRect );

      Self.Finished := true;
      Exit;
    End;
    Inc( FCurrentIndex );
    If FCurrentIndex > 0 Then
      Caption := SDefineSecondView;
    DrawEntity2DRubberBand( FFrame, false,false );
  End;
End;

Procedure TDefineViewAction.MyMouseUp( Sender: TObject; Button: TMouseButton; Shift: TShiftState;
  X, Y: Integer; Const WX, WY: Double );
Begin
  FDraw := true;
End;

Procedure TDefineViewAction.MyMouseMove( Sender: TObject; Shift: TShiftState;
  X, Y: Integer; Const WX, WY: Double );
Var
  CurrPoint: TEzPoint;
Begin
  If Not fDraw Then Exit;
  CmdLine.ActiveDrawBox.DrawEntity2DRubberBand( FFrame, false,false );
  CurrPoint := CmdLine.CurrentPoint;
  SetCurrentPoint( CurrPoint );
  CmdLine.ActiveDrawBox.DrawEntity2DRubberBand( FFrame, false,false );
End;

Procedure TDefineViewAction.MyPaint( Sender: TObject );
Begin
  If FDraw And ( FFrame <> Nil ) Then
    CmdLine.ActiveDrawBox.DrawEntity2DRubberBand( FFrame, false,false );
End;

Procedure TDefineViewAction.MyKeyPress( Sender: TObject; Var Key: Char );
Begin
  If Key = #27 Then
  Begin {cancel the insertion of new view}
    If FDraw Then
      CmdLine.ActiveDrawBox.DrawEntity2DRubberBand( FFrame, false,false );
    Self.Finished := true;
    Frm.Show;
  End;
End;

{TfrmViews class implementation}

Procedure TfrmViews.Enter( CmdLine: tEzCmdLine );
var
  i: Integer;
Begin
  FCmdline := Cmdline;
  { populate list }
  for I:= 0 to fmain.Form1.NamedViews.Count-1 do
    List1.Items.Add( fmain.Form1.NamedViews[i].Name);
  FOldAutoRestore := fmain.Form1.NamedViews.AutoRestore;
  Check1.Checked := FOldAutoRestore;

  Show;
End;

Procedure TfrmViews.CreateParams( Var Params: TCreateParams );
Begin
  Inherited CreateParams( Params );
  With Params Do
  Begin
    Style := Style Or ws_Overlapped;
    WndParent := NamedViewParentHWND;
  End;
End;

Procedure TfrmViews.FormClose( Sender: TObject; Var Action: TCloseAction );
Begin
  If FOldAutoRestore <> Check1.Checked Then
  Begin
    fmain.Form1.NamedViews.AutoRestore := Check1.Checked;
  End;

  If FNeedSave Then
    SaveFormPlacement( ExtractFilePath(Application.ExeName) + 'formspos.ini', Self, Nil );

  fmain.Form1.frmViews:= nil;
  fmain.Form1.actNamedviews.checked:=false;
  Action := caFree;
End;

Procedure TfrmViews.InsertView( ViewWin: TEzRect );
Begin
  With TfrmDefineNew.Create( Nil ) Do
  Try
    With ViewWin Do
      If Enter( FCmdLine.ActiveDrawBox, Emin.X, Emin.Y, Emax.X, Emax.Y ) = mrOk Then
      Begin
        with fmain.Form1.NamedViews.Add do
        begin
          Name := Edit1.Text;
          X1 := ViewWin.Emin.X;
          Y1 := ViewWin.Emin.Y;
          X2 := ViewWin.Emax.X;
          Y2 := ViewWin.Emax.Y;
          List1.Items.add(Edit1.Text);
        end;
      End;
  Finally
    Free;
  End;
End;

Procedure TfrmViews.BtnUpClick( Sender: TObject );
Var
  Index1, Index2: integer;
Begin
  If List1.ItemIndex < 0 Then Exit;
  Index1 := List1.ItemIndex;
  If Index1 <> 0 Then
  Begin
    Index2 := Index1 - 1;
    fmain.Form1.NamedViews.Exchange( Index1, Index2 );
    List1.Items.Exchange(Index1,Index2);
    List1.ItemIndex := Index1-1;
  End;
End;

Procedure TfrmViews.BtnDownClick( Sender: TObject );
Var
  Index1, Index2: integer;
Begin
  If List1.ItemIndex >= List1.Items.Count-1 Then Exit;
  Index1 := List1.ItemIndex;
  If Index1 <> List1.Items.count-1 Then
  Begin
    Index2 := Index1 + 1;
    fmain.Form1.NamedViews.Exchange( Index1, Index2 );
    List1.Items.Exchange(Index1,Index2);
    List1.ItemIndex := Index1 + 1;
  End;
End;

Procedure TfrmViews.FormShow( Sender: TObject );
Begin
  RestoreFormPlacement(ExtractFilePath(Application.ExeName) + 'formspos.ini',
    Self, False, Nil);
  FNeedSave := False;
End;

procedure TfrmViews.List1Click(Sender: TObject);
begin
  if (list1.itemindex <0) or (List1.itemindex >fmain.Form1.NamedViews.count-1) then exit;
  If Check1.checked Then
  Begin
    fmain.Form1.NamedViews[list1.itemindex].SetInView(FCmdLine.ActiveDrawBox);
  End;
end;

procedure TfrmViews.WMExitSizeMove(var m: TMessage);
begin
  FNeedSave := True;
  Inherited;
end;

procedure TfrmViews.Current2Click(Sender: TObject);
begin
  With TfrmDefineNew.Create( Nil ) Do
  Try
    With FCmdLine.ActiveDrawBox.Grapher.CurrentParams Do
      With VisualWindow Do
        If Enter( FCmdLine.ActiveDrawBox, Emin.X, Emin.Y, Emax.X, Emax.Y ) = mrOk Then
        Begin
          with fmain.Form1.NamedViews.add do
          begin
            name := Edit1.Text;
            x1 := VisualWindow.Emin.X;
            y1 := VisualWindow.Emin.Y;
            x2 := VisualWindow.Emax.X;
            y2 := VisualWindow.Emax.Y;
            List1.Items.add(Edit1.Text);
          end;
        End;
  Finally
    Free;
  End;
end;

procedure TfrmViews.Define1Click(Sender: TObject);
begin
  Self.Hide;
  FCmdLine.Push( TDefineViewAction.CreateAction( FCmdLine, Self ), false, '', '' );
end;

procedure TfrmViews.SpeedButton1Click(Sender: TObject);
begin
  if list1.itemindex<0 then Exit;
  fmain.Form1.NamedViews[list1.itemindex].SetInView(FCmdLine.ActiveDrawBox);
end;

procedure TfrmViews.SpeedButton3Click(Sender: TObject);
begin
  if List1.ItemIndex < 0 then exit;
  If ( Application.MessageBox( pchar( SDeleteViewWarn ), pchar( SMsgConfirm ),
    MB_YESNO Or MB_ICONQUESTION ) <> IDYES ) Then Exit;
  fmain.Form1.NamedViews.Delete(List1.ItemIndex);
  List1.Items.Delete(List1.ItemIndex);
end;

procedure TfrmViews.SpeedButton4Click(Sender: TObject);
begin
  if List1.ItemIndex < 0 then exit;
  With TfrmViewDesc.Create( Nil ) Do
  Try
    With fmain.Form1.NamedViews[List1.ItemIndex] Do
      Enter( FCmdLine, Name, Rect2d(x1,y1,x2,y2) );
  Finally
    Free;
  End;
end;

procedure TfrmViews.SpeedButton5Click(Sender: TObject);
Var
  Gis: TEzBaseGis;
Begin
  if List1.ItemIndex < 0 then exit;
  Gis := FCmdLine.ActiveDrawBox.Gis;
  With Gis.MapInfo  Do
  Begin
    IsAreaClipped := True;
    with fmain.Form1.NamedViews[List1.ItemIndex] do
      AreaClipped := Rect2d(x1,y1,x2,y2);
    ClipAreaKind := cpkRectangular;
    Gis.RepaintViewports;
  End;
end;

procedure TfrmViews.Check1Click(Sender: TObject);
begin
  fmain.Form1.NamedViews.Autorestore:=check1.Checked;
end;

procedure TfrmViews.SpeedButton2Click(Sender: TObject);
var
  p: TPoint;
begin
  GetCursorPos(p);
  p:= ScreenToClient(p);
  PopupMenu1.Popup(p.x,p.y)
end;

End.
