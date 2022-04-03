unit fClone;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  EzBaseGIS, EzBasicCtrls, Menus, Buttons, ExtCtrls, StdCtrls;

type
  TfrmClone = class(TForm)
    DrawBox1: TEzDrawBox;
    Panel1: TPanel;
    ZoomAll: TSpeedButton;
    PriorViewBtn: TSpeedButton;
    BtnRefresh: TSpeedButton;
    ScaleBar1: TEzScaleBar;
    LblScale: TLabel;
    LblCoord: TLabel;
    Label1: TLabel;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure ZoomAllClick(Sender: TObject);
    procedure PriorViewBtnClick(Sender: TObject);
    procedure BtnRefreshClick(Sender: TObject);
    procedure DrawBox1MouseMove2D(Sender: TObject; Shift: TShiftState; X,
      Y: Integer; const WX, WY: Double);
    procedure DrawBox1ZoomChange(Sender: TObject; const Scale: Double);
    procedure FormPaint(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure DrawBox1BeginRepaint(Sender: TObject);
    procedure DrawBox1ShowHint(Sender: TObject; Layer: TEzBaseLayer;
      Recno: Integer; var Hint: String; var ShowHint: Boolean);
  private
    { Private declarations }
    FOldWidth: Integer;
    FOldHeight: Integer;
    procedure WMEnterSizeMove( Var m: TMessage ); Message WM_ENTERSIZEMOVE;
    procedure WMExitSizeMove( Var m: TMessage ); Message WM_EXITSIZEMOVE;
  public
    { Public declarations }
    //procedure CreateParams(var Params: TCreateParams); override;
  end;

implementation

uses
  fmain, EzUtils;

{$R *.DFM}

{ TfrmClone }

{procedure TfrmClone.CreateParams(var Params: TCreateParams);
begin
  Inherited CreateParams( Params );
  With Params Do
  Begin
    Style := Style Or ws_Overlapped;
    WndParent := fMain.Form1.Handle;
  end;
end; }

procedure TfrmClone.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  fMain.Form1.ClonedViews[Self.Tag]:= Nil;
  with fMain.Form1 do
    case Self.Tag of
      0:ActView1.Checked:=false;
      1:ActView2.Checked:=false;
      2:ActView3.Checked:=false;
      3:ActView4.Checked:=false;
      4:ActView5.Checked:=false;
    end;
  Action:= caFree;
end;

procedure TfrmClone.WMEnterSizeMove(var m: TMessage);
begin
  inherited;
  DrawBox1.BeginUpdate;
  FOldWidth:= DrawBox1.Width;
  FOldHeight:= DrawBox1.Height;
end;

procedure TfrmClone.WMExitSizeMove(var m: TMessage);
begin
  inherited;
  if (DrawBox1.Width = FOldWidth) And (DrawBox1.Height = FOldHeight) then
    DrawBox1.CancelUpdate
  else
  begin
    DrawBox1.EndUpdate;
    ScaleBar1.Reposition;
  end;
end;

procedure TfrmClone.ZoomAllClick(Sender: TObject);
begin
  DrawBox1.ZoomToExtension;
end;

procedure TfrmClone.PriorViewBtnClick(Sender: TObject);
begin
  DrawBox1.ZoomPrevious;
end;

procedure TfrmClone.BtnRefreshClick(Sender: TObject);
begin
  DrawBox1.Repaint;
end;

procedure TfrmClone.DrawBox1MouseMove2D(Sender: TObject;
  Shift: TShiftState; X, Y: Integer; const WX, WY: Double);
begin
  LblCoord.Caption := #32+DrawBox1.CoordsToDisplayText(WX,WY)+#32;
end;

procedure TfrmClone.DrawBox1ZoomChange(Sender: TObject;
  const Scale: Double);
begin
  LblScale.Caption:= #32+Format('1: %.4f', [DrawBox1.CurrentScale])+#32;
  with Parent.Parent as TForm1 do
  begin
    if (Gis.Layers.Count=0) or (frmAerial=nil) then exit;
    frmAerial.AerialView1.Refresh;
  end;
end;

procedure TfrmClone.FormPaint(Sender: TObject);
begin
  { check for the scale bar invisibility condition }
  If ScaleBar1.Visible And
     ( (ScaleBar1.Left > DrawBox1.ClientWidth) Or
       ((ScaleBar1.Left + ScaleBar1.Width) < 0 ) Or
       (ScaleBar1.Top > DrawBox1.Clientheight) Or
       ((ScaleBar1.Top + ScaleBar1.Height ) < 0) ) Then
  Begin
    If ScaleBar1.ResizePosition=rpNone then
    begin
      ScaleBar1.ResizePosition:= rpLowerRight;
      ScaleBar1.Reposition;
      ScaleBar1.ResizePosition:= rpNone;
    end else
      ScaleBar1.Reposition;
  End;
end;

procedure TfrmClone.FormShow(Sender: TObject);
begin
  ScaleBar1.Reposition;
end;

procedure TfrmClone.DrawBox1BeginRepaint(Sender: TObject);
begin
  fMain.Form1.LayersOptions.Prepare(fMain.Form1.GIS);
end;

procedure TfrmClone.DrawBox1ShowHint(Sender: TObject; Layer: TEzBaseLayer;
  Recno: Integer; var Hint: String; var ShowHint: Boolean);
var
  lo: TEzLayerOptions;
begin
  lo:= fMain.Form1.LayersOptions.LayerByName( Layer.Name );
  if (lo = nil) or not lo.HintActive or not Assigned(lo.HintExpr) then Exit;
  Layer.Recno:= Recno;
  Layer.Synchronize;
  Hint:= lo.HintExpr.Expression.AsString;
  ShowHint:= true;
end;

end.
