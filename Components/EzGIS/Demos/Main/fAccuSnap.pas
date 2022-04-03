unit fAccuSnap;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms,
  Dialogs, Buttons, ExtCtrls, StdCtrls;

type
  TfrmAccuSnap = class(TForm)
    BtnToggle: TSpeedButton;        
    BtnNearest: TSpeedButton;
    BtnKeyPoint: TSpeedButton;
    BtnMidPoint: TSpeedButton;
    BtnCenter: TSpeedButton;
    BtnOrigin: TSpeedButton;
    BtnBisector: TSpeedButton;
    BtnIntersect: TSpeedButton;
    BtnTangent: TSpeedButton;
    BtnPerpend: TSpeedButton;
    BtnParallel: TSpeedButton;
    BtnEndPoint: TSpeedButton;
    PaintBox1: TPaintBox;
    Label1: TLabel;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure BtnToggleClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure BtnNearestClick(Sender: TObject);
    procedure PaintBox1Paint(Sender: TObject);
  private
    { Private declarations }
    FBtnActive: TSpeedButton;
  public
    { Public declarations }
    procedure CreateParams(var Params: TCreateParams); override;
    procedure Reset;
  end;

implementation

{$R *.dfm}

uses
  fMain, EzBase, EzCmdLine;

procedure TfrmAccuSnap.CreateParams(var Params: TCreateParams);
begin
  Inherited CreateParams( Params );
  With Params Do
  Begin
    Style := Style Or ws_Overlapped;
    WndParent := fMain.Form1.Handle;
  end;
end;

procedure TfrmAccuSnap.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  fMain.Form1.frmAccuSnap:= Nil;
  fMain.Form1.ShowAccuSnap1.Checked:= False;
  Action:=caFree;
end;

procedure TfrmAccuSnap.BtnToggleClick(Sender: TObject);
begin
  fMain.Form1.CmdLine1.AccuSnap.Enabled:= BtnToggle.Down;
end;

procedure TfrmAccuSnap.FormCreate(Sender: TObject);
begin
  BtnKeyPoint.Tag:= Ord(osKeyPoint);
  BtnMidPoint.Tag:= Ord(osMidpoint);
  BtnCenter.Tag:= Ord(osCenter);
  BtnOrigin.Tag:= Ord(osOrigin);
  BtnNearest.Tag:= Ord(osNearest);
  BtnEndPoint.Tag:= Ord(osEndpoint);
  BtnBisector.Tag:= Ord(osBisector);
  BtnIntersect.Tag:= Ord(osIntersect);
  BtnTangent.Tag:= Ord(osTangent);
  BtnPerpend.Tag:= Ord(osPerpend);
  BtnParallel.Tag:= Ord(osParallel);

  Reset;
end;

procedure TfrmAccuSnap.Reset;
begin
  BtnToggle.Down:= fMain.Form1.CmdLine1.AccuSnap.Enabled;
  If BtnToggle.Down Then
  begin
    FBtnActive:= Nil;
    case fMain.Form1.CmdLine1.AccuSnap.OsnapSetting of
      osEndPoint:
        FBtnActive:= BtnEndPoint;
      osMidPoint:
        FBtnActive:= BtnMidPoint;
      osCenter:
        FBtnActive:= BtnCenter;
      osIntersect:
        FBtnActive:= BtnIntersect;
      osPerpend:
        FBtnActive:= BtnPerpend;
      osTangent:
        FBtnActive:= BtnTangent;
      osNearest:
        FBtnActive:= BtnNearest;
      osOrigin:
        FBtnActive:= BtnOrigin;
      osParallel:
        FBtnActive:= BtnParallel;
      osKeyPoint:
        FBtnActive:= BtnKeyPoint;
      osBisector:
        FBtnActive:= BtnBisector;
    end;
    If FBtnActive <> Nil then
    begin
      //Image1.Picture.Assign( FBtnActive.Glyph );
    end;
  end;
  Paintbox1.Invalidate;
end;

procedure TfrmAccuSnap.BtnNearestClick(Sender: TObject);
begin
  fMain.Form1.CmdLine1.AccuSnap.OverrideOsnapSetting:= TEzOsnapSetting(TSpeedButton(Sender).Tag);
  fMain.Form1.CmdLine1.AccuSnap.OverrideOsnap:= TSpeedButton(Sender).Down;
end;

procedure TfrmAccuSnap.PaintBox1Paint(Sender: TObject);
begin
  If FBtnActive = Nil then exit;
  PaintBox1.Canvas.BrushCopy( Paintbox1.ClientRect, FBtnActive.Glyph,
    Rect(0,0,FBtnActive.Glyph.Width,FBtnActive.Glyph.Height),clOlive );
end;

end.
