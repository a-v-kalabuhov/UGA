unit fAutoLabel;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Buttons, EzActionLaunch, EzColorPicker, EzNumEd,
  ExtCtrls, ComCtrls, EzBaseGis, EzBase, EzLib;

type
  TfrmAutoLabel = class(TForm)
    PageControl1: TPageControl;
    TabSheet1: TTabSheet;
    TabSheet2: TTabSheet;
    Label1: TLabel;
    cboLayer: TComboBox;
    Label2: TLabel;
    cboStore: TComboBox;
    Label3: TLabel;
    Memo1: TMemo;
    BtnAssist: TSpeedButton;
    Launcher1: TEzActionLauncher;
    chkAlign: TCheckBox;
    chkTrueType: TCheckBox;
    PageControl2: TPageControl;
    TabSheet3: TTabSheet;
    LstFonts: TListBox;
    TabSheet4: TTabSheet;
    Panel2: TPanel;
    LstTTFonts: TListBox;
    chkBold: TCheckBox;
    chkItal: TCheckBox;
    chkUnder: TCheckBox;
    chkStrike: TCheckBox;
    Label28: TLabel;
    EdSize: TEzNumEd;
    cboColor: TEzColorBox;
    Label29: TLabel;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure Launcher1Paint(Sender: TObject);
    procedure Launcher1MouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer; const WX, WY: Double);
    procedure Launcher1MouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer; const WX, WY: Double);
    procedure BtnAssistClick(Sender: TObject);
    procedure Launcher1MouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer; const WX, WY: Double);
    procedure Launcher1KeyPress(Sender: TObject; var Key: Char);
    procedure Launcher1SuspendOperation(Sender: TObject);
    procedure Launcher1ContinueOperation(Sender: TObject);
    procedure Launcher1Finished(Sender: TObject);
  private
    { Private declarations }
    FLabelEntity: TEzEntity;
    FIsMouseDown: Boolean;
    FLayer: TEzBaseLayer;
    FRecno: Integer;
    FIAmBusy: Boolean;
  public
    { Public declarations }
    procedure CreateParams(var Params: TCreateParams); override;
  end;

implementation

{$R *.dfm}

uses
  fMain, EzSystem, EzExpressions, EzGraphics, fExpress;

procedure TfrmAutoLabel.CreateParams(var Params: TCreateParams);
begin
  Inherited CreateParams( Params );
  With Params Do
  Begin
    Style := Style Or ws_Overlapped;
    WndParent := fMain.Form1.Handle;
  end;
end;

procedure TfrmAutoLabel.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  Action:= caFree;
end;

procedure TfrmAutoLabel.FormCreate(Sender: TObject);
var
  I: Integer;
begin
  Launcher1.CmdLine:= fMain.Form1.CmdLine1;
  Launcher1.TrackGenericAction( '' );
  Launcher1.Caption:= 'Please click in the entity to auto-label';

  for I:= 0 to fMain.Form1.GIS.Layers.Count-1 do
    cboLayer.Items.Add(fMain.Form1.GIS.Layers[I].Name);
  cboStore.Items.Assign(cboLayer.Items);
  cboLayer.ItemIndex:= cboLayer.Items.IndexOf(fMain.Form1.GIS.CurrentLayerName);
  cboStore.ItemIndex:=cboLayer.ItemIndex;

  with LstFonts.Items do
    for I:=0 to Ez_VectorFonts.Count-1 do
    Add(Ez_VectorFonts[I].Name);
  If LstFonts.Items.Count>0 Then
    LstFonts.ItemIndex:= 0;

  LstTTFonts.Items.Assign(Screen.Fonts);
  LstTTFonts.ItemIndex:= LstTTFonts.Items.IndexOf('Arial');//0;

end;

procedure TfrmAutoLabel.FormDestroy(Sender: TObject);
begin
  If FLabelEntity <> nil Then FreeAndNil( FLabelEntity );

  { if you move this to the FormClose event, it will causes an AV when you
    explicitly close the form with the system button }
  Launcher1.Finish;
  fMain.Form1.frmAutoLabel:= Nil;
end;

procedure TfrmAutoLabel.Launcher1Paint(Sender: TObject);
var
  TmpEntity: TEzEntity;
begin
  with fMain.Form1 do
  begin
    If FLayer <> Nil Then
    Begin
      TmpEntity:= FLayer.LoadEntityWithRecno( FRecno );
      If TmpEntity <> Nil Then
        EzSystem.HiliteEntity( TmpEntity, CmdLine1.ActiveDrawBox );
    End;

    If FLabelEntity <> Nil Then
      cmdLine1.All_DrawEntity2DRubberBand( FLabelEntity );
  end;
end;

procedure TfrmAutoLabel.Launcher1MouseUp(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer; const WX, WY: Double);
begin
  FIsMouseDown:= False;
end;

procedure TfrmAutoLabel.Launcher1MouseMove(Sender: TObject;
  Shift: TShiftState; X, Y: Integer; const WX, WY: Double);
var
  Picked: Boolean;
  Pt1, Pt2, CurrPoint: TEzPoint;
  TmpLayer: TEzBaseLayer;
  TmpRecNo: Integer;
  PickedPoint: Integer;
  TmpEntity, PrevEntity: TEzEntity;
  LabelText: string;
  Angle: Double;
  LabelFont: TEzFontTool;
  Solver: TEzMainExpr;

  Procedure ErasePrevious;
  Begin
    { erase previous highlighted entity }
    If FLayer <> Nil Then
    Begin
       PrevEntity:= FLayer.LoadEntityWithRecno( FRecno );
       If PrevEntity <> Nil Then
       Begin
         Try
           EzSystem.UnHiliteEntity( PrevEntity, fMain.Form1.CmdLine1.ActiveDrawBox );
         Finally
           PrevEntity.Free;
         end;
       End;
    End;
  End;

begin
  If FIAmBusy Or FIsMouseDown Or (Length(Trim(Memo1.Text))=0) Or (cboLayer.ItemIndex<0) Or
    (cboStore.ItemIndex<0) Then
  Begin
    Exit;
  End;

  FIAmBusy:= True;
  Try
    with fMain.Form1.CmdLine1 do
    begin
      If FLabelEntity <> Nil Then
      Begin
        All_DrawEntity2dRubberBand( FLabelEntity );
        FreeAndNil( FLabelEntity );
      End;
      CurrPoint := CurrentPoint;
      Picked := ActiveDrawBox.PickEntity( CurrPoint.X, CurrPoint.Y,
        Ez_Preferences.ApertureWidth, cboLayer.Text, TmpLayer, TmpRecNo, PickedPoint, Nil );
      If Picked Then
      Begin
        TmpEntity := TmpLayer.LoadEntityWithRecno( TmpRecno );
        If TmpEntity = Nil Then exit;
        Try
          If Not((TmpLayer=FLayer) And (TmpRecno=FRecno)) Then
          Begin
            ErasePrevious;
            EzSystem.HiliteEntity( TmpEntity, ActiveDrawBox );
            FLayer:= TmpLayer;
            FRecno:= TmpRecno;
            { highlight this new entity }
          End;

          { create the value of the label }
          LabelFont := TEzFontTool.Create;
          Solver:= TEzMainExpr.Create( ActiveDrawBox.GIS, TmpLayer );
          Try
            Solver.ParseExpression( Memo1.Text );

            { set default values for label }
            LabelFont.Assign( Ez_Preferences.DefFontStyle );
            If chkTrueType.Checked Then
            begin
              LabelFont.Name:=LstTTFonts.Items[LstTTFonts.ItemIndex];
              LabelFont.Style:= [];
              If chkBold.Checked then LabelFont.Style:= LabelFont.Style + [fsBold];
              If chkItal.Checked then LabelFont.Style:= LabelFont.Style + [fsItalic];
              If chkUnder.Checked then LabelFont.Style:= LabelFont.Style + [fsUnderline];
              If chkStrike.Checked then LabelFont.Style:= LabelFont.Style + [fsStrikeout];
            end else
            begin
              LabelFont.Name:=LstFonts.Items[LstFonts.ItemIndex];
            end;
            LabelFont.Color:=cboColor.Selected;
            LabelFont.Height := ActiveDrawBox.Grapher.PointsToDistY(EdSize.NumericValue);

            TmpLayer.Recno:= TmpRecno;
            TmpLayer.Synchronize;
            LabelText:= Solver.Expression.AsString;

            If Length( Trim(LabelText) ) = 0 Then Exit;

            Self.Caption:= 'Auto-Labeling - ' + LabelText;

            Angle := 0;
            Pt1 := CurrPoint;
            Pt2 := CurrPoint;
            (* Was clicked on an entity segment ? *)
            If ( PickedPoint = PICKED_POINT ) And ( Ez_Preferences.GNumPoint >= 0 ) And
              ( TmpEntity.Points.Count > 1 ) And
              ( TmpEntity.EntityID In [idPolygon, idPolyline] ) Then
            Begin
              Pt1 := TmpEntity.Points[Ez_Preferences.GNumPoint];
              If Ez_Preferences.GNumPoint = TmpEntity.Points.Count - 1 Then
                Pt2 := TmpEntity.Points[0]
              Else
                Pt2 := TmpEntity.Points[Succ( Ez_Preferences.GNumPoint )];
              Angle := Angle2D( Pt1, Pt2 ); // in radians
            End;
            FLabelEntity := EzGraphics.CreateText( LabelText, lpCenter, Angle,
              Pt1, Pt2, LabelFont.FFontStyle, chkTrueType.Checked );
            All_DrawEntity2dRubberBand( FLabelEntity );

          Finally

            LabelFont.Free;
            Solver.Free;
          End;
        Finally
          TmpEntity.Free;
        End;
      End Else
      Begin
        ErasePrevious;
        FLayer:= Nil;
        FRecno:= 0;
      End;
    end;
  Finally
    FIAmBusy:= False;
  End;
end;

procedure TfrmAutoLabel.BtnAssistClick(Sender: TObject);
var
  Layer: TEzBaseLayer;
begin
  If cboLayer.Itemindex < 0 then Exit;
  Layer:= fMain.Form1.GIS.Layers.LayerByName(cboLayer.Text);
  If Layer=Nil Then Exit;
  With TfrmExprDlg.Create( Application ) Do
    Try
      If Enter( Self.Memo1.Text, fMain.Form1.Gis, Layer ) = mrOk Then
      begin
        Self.Memo1.Text := Memo1.Text;  // Memo1 also in TfrmExprDlg
      end;
    Finally
      Free;
    End;
end;

procedure TfrmAutoLabel.Launcher1MouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer; const WX, WY: Double);
var
  DestLayer: TEzBaseLayer;
Begin
  (* First, found an entity on the map*)
  If (Button = mbRight) Or (FLabelEntity=Nil) Or (cboStore.ItemIndex<0) Then Exit;
  FIsMouseDown:= True;
  With fMain.Form1.GIS Do
  Begin
    DestLayer := Layers.LayerByName(cboStore.Text);
    DestLayer.AddEntity( FLabelEntity );
    fMain.Form1.CmdLine1.All_RepaintRect( FLabelEntity.FBox );
  End;
end;

procedure TfrmAutoLabel.Launcher1KeyPress(Sender: TObject; var Key: Char);
begin
  With fMain.Form1.DrawBox Do
    If Key = #27 Then
    Begin
      Launcher1.Finished := true;  // this causes to finish the action
      Key := #0;
    End;
end;

procedure TfrmAutoLabel.Launcher1SuspendOperation(Sender: TObject);
begin
  If FLabelEntity <> Nil Then
    fMain.Form1.CmdLine1.All_DrawEntity2DRubberBand( FLabelEntity );
end;

procedure TfrmAutoLabel.Launcher1ContinueOperation(Sender: TObject);
begin
  If FLabelEntity <> Nil Then
    fMain.Form1.CmdLine1.All_DrawEntity2DRubberBand( FLabelEntity );
end;

procedure TfrmAutoLabel.Launcher1Finished(Sender: TObject);
begin
  Release;  // if the action is finished some way, close this form
end;

end.
