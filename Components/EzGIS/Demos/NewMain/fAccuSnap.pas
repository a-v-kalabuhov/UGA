unit fAccuSnap;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms,
  Dialogs, Buttons, ExtCtrls, StdCtrls, EzCmdLine;

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
    procedure BtnNearestClick(Sender: TObject);
    procedure PaintBox1Paint(Sender: TObject);
  private
    { Private declarations }
    FCmdLine: TEzCmdLine;
    FBtnActive: TSpeedButton;
    FOnThisClose: TNotifyEvent;
  public
    { Public declarations }
    procedure Enter( CmdLine: TEzCmdLine );
    procedure CreateParams(var Params: TCreateParams); override;
    procedure Reset;
    procedure ResetToDefault;

    property OnThisClose: TNotifyEvent read FOnThisClose write FOnThisClose;
  end;

Var
  AccuSnapParent: THandle;

implementation

{$R *.dfm}

uses
  EzBase;

procedure TfrmAccuSnap.Enter(CmdLine: TEzCmdLine);
begin
  FCmdLine:= CmdLine;

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

  Show;
end;

procedure TfrmAccuSnap.ResetToDefault;
var
  I: Integer;
begin
  { repaint the current default snap }
  Paintbox1.Invalidate;
  { configure the speed buttons on the form }
  For I:= 0 to ComponentCount-1 do
  begin
    If (Components[I] is TSpeedButton) And
      (TSpeedButton(Components[I]).Tag <> 0) then
    begin
      { set the button up }
      TSpeedButton(Components[I]).Down:=false;
      { if the button correspond with the default override setting, then put it down }
      If FCmdLine.AccuSnap.OverrideOsnap And
        (TEzOsnapSetting( TSpeedButton(Components[I]).Tag ) = FCmdLine.AccuSnap.OverrideOsnapSetting) Then
        TSpeedButton(Components[I]).Down:= True;
    end;
  end;
end;

procedure TfrmAccuSnap.CreateParams(var Params: TCreateParams);
begin
  Inherited CreateParams( Params );
  With Params Do
  Begin
    Style := Style Or ws_Overlapped;
    WndParent := AccuSnapParent;
  end;
end;

procedure TfrmAccuSnap.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  If Assigned(FOnThisClose) then
    FOnThisClose(Self);
  Action:=caFree;
end;

procedure TfrmAccuSnap.BtnToggleClick(Sender: TObject);
begin
  FCmdLine.AccuSnap.Enabled:= BtnToggle.Down;
end;

procedure TfrmAccuSnap.Reset;
begin
  BtnToggle.Down:= FCmdLine.AccuSnap.Enabled;
  If BtnToggle.Down Then
  begin
    FBtnActive:= Nil;
    case FCmdLine.AccuSnap.OsnapSetting of
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
  FCmdLine.AccuSnap.OverrideOsnapSetting:= TEzOsnapSetting(TSpeedButton(Sender).Tag);
  FCmdLine.AccuSnap.OverrideOsnap:= TSpeedButton(Sender).Down;
end;

procedure TfrmAccuSnap.PaintBox1Paint(Sender: TObject);
begin
  If FBtnActive = Nil then exit;
  PaintBox1.Canvas.BrushCopy( Paintbox1.ClientRect, FBtnActive.Glyph,
    Rect(0,0,FBtnActive.Glyph.Width,FBtnActive.Glyph.Height),clOlive );
end;

end.
