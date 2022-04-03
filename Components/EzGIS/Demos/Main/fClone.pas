unit fClone;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  EzBaseGIS, EzBasicCtrls, Menus, Buttons, ExtCtrls;

type
  TfrmClone = class(TForm)
    DrawBox1: TEzDrawBox;
    Panel1: TPanel;
    ZoomAll: TSpeedButton;
    PriorViewBtn: TSpeedButton;
    BtnRefresh: TSpeedButton;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure ZoomAllClick(Sender: TObject);
    procedure PriorViewBtnClick(Sender: TObject);
    procedure BtnRefreshClick(Sender: TObject);
  private
    { Private declarations }
    FOldWidth: Integer;
    FOldHeight: Integer;
    procedure WMEnterSizeMove( Var m: TMessage ); Message WM_ENTERSIZEMOVE;
    procedure WMExitSizeMove( Var m: TMessage ); Message WM_EXITSIZEMOVE;
  public
    { Public declarations }
    procedure CreateParams(var Params: TCreateParams); override;
  end;

implementation

uses
  fmain;

{$R *.DFM}

{ TfrmClone }

procedure TfrmClone.CreateParams(var Params: TCreateParams);
begin
  Inherited CreateParams( Params );
  With Params Do
  Begin
    Style := Style Or ws_Overlapped;
    WndParent := fMain.Form1.Handle;
  end;
end;

procedure TfrmClone.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  fMain.Form1.ClonedViews[Self.Tag]:= Nil;
  with fMain.Form1 do
    case Self.Tag of
      0:BtnView1.Down:=false;
      1:BtnView2.Down:=false;
      2:BtnView3.Down:=false;
      3:BtnView4.Down:=false;
      4:BtnView5.Down:=false;
      5:BtnView6.Down:=false;
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

end.
