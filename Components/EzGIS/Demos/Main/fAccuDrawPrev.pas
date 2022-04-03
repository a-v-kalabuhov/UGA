unit fAccuDrawPrev;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, EzNumEd, Buttons;

type
  TfrmAccuDrawPreview = class(TForm)
    NumEd1: TEzNumEd;
    NumEd2: TEzNumEd;
    chkX: TCheckBox;
    chkY: TCheckBox;
    BtnRect: TSpeedButton;
    BtnPolar: TSpeedButton;
    Label1: TLabel;
    Label2: TLabel;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure NumEd1Change(Sender: TObject);
    procedure NumEd2Change(Sender: TObject);
    procedure chkXClick(Sender: TObject);
    procedure chkYClick(Sender: TObject);
    procedure BtnRectClick(Sender: TObject);
    procedure BtnPolarClick(Sender: TObject);
  private
    { Private declarations }
    FInUpdate: Boolean;
  public
    { Public declarations }
    procedure CreateParams(var Params: TCreateParams); override;
    property InUpdate: Boolean read FInUpdate write FInUpdate;
  end;

implementation

{$R *.dfm}

uses
  Math, fDemoPrevw, EzCmdLine;

{ TfrmAccuDrawPreview }

procedure TfrmAccuDrawPreview.CreateParams(var Params: TCreateParams);
begin
  Inherited CreateParams( Params );
  With Params Do
  Begin
    Style := Style Or ws_Overlapped;
    WndParent := fDemoPrevw.frmDemoPreview.Handle;
  end;
end;

procedure TfrmAccuDrawPreview.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  fDemoPrevw.frmDemoPreview.frmAccuDraw:= Nil;
  fDemoPrevw.frmDemoPreview.Show1.Checked:= False;
  fDemoPrevw.frmDemoPreview.CmdLine1.AccuDraw.Showing:= False;
  Action:= caFree;
end;

procedure TfrmAccuDrawPreview.NumEd1Change(Sender: TObject);
begin
  If FInUpdate Then Exit;
  chkX.Checked:= true;
  fDemoPrevw.frmDemoPreview.CmdLine1.AccuDraw.DeltaX:= NumEd1.NumericValue;
  fDemoPrevw.frmDemoPreview.CmdLine1.AccuDraw.DeltaXLocked:= true;
end;

procedure TfrmAccuDrawPreview.NumEd2Change(Sender: TObject);
begin
  If FInUpdate Then Exit;
  chkY.Checked:= true;
  If BtnRect.Down then    // rectangular
    fDemoPrevw.frmDemoPreview.CmdLine1.AccuDraw.DeltaY:= NumEd2.NumericValue
  else    // polar
    fDemoPrevw.frmDemoPreview.CmdLine1.AccuDraw.DeltaY:= DegToRad( NumEd2.NumericValue );
  fDemoPrevw.frmDemoPreview.CmdLine1.AccuDraw.DeltaYLocked:= true;
end;

procedure TfrmAccuDrawPreview.chkXClick(Sender: TObject);
begin
  If FInUpdate Then Exit;
  fDemoPrevw.frmDemoPreview.CmdLine1.AccuDraw.DeltaX:= NumEd1.NumericValue;
  fDemoPrevw.frmDemoPreview.CmdLine1.AccuDraw.DeltaXLocked:= chkX.Checked;
end;

procedure TfrmAccuDrawPreview.chkYClick(Sender: TObject);
begin
  If FInUpdate Then Exit;
  fDemoPrevw.frmDemoPreview.CmdLine1.AccuDraw.DeltaY:= NumEd2.NumericValue;
  fDemoPrevw.frmDemoPreview.CmdLine1.AccuDraw.DeltaYLocked:= chkY.Checked;
end;

procedure TfrmAccuDrawPreview.BtnRectClick(Sender: TObject);
begin
  If FInUpdate then Exit;
  Label1.Caption:= 'Delta X : ';
  Label2.Caption:= 'Delta Y : ';

  NumEd1.NumericValue:= 0;
  NumEd2.NumericValue:= 0;
  chkX.Checked:=false;
  chkY.Checked:=false;
  chkX.Enabled:=true;
  chkY.Enabled:=true;

  fDemoPrevw.frmDemoPreview.CmdLine1.AccuDraw.FrameStyle:= fsRectangular;
  fDemoPrevw.frmDemoPreview.PreviewBox1.Invalidate;
end;

procedure TfrmAccuDrawPreview.BtnPolarClick(Sender: TObject);
begin
  If FInUpdate then Exit;
  Label1.Caption:= 'Distance : ';
  Label2.Caption:= 'Angle : ';

  NumEd1.NumericValue:= 0;
  NumEd2.NumericValue:= 0;
  chkX.Checked:=false;
  chkY.Checked:=false;
  chkX.Enabled:=true;
  chkY.Enabled:=true;
  fDemoPrevw.frmDemoPreview.CmdLine1.AccuDraw.FrameStyle:= fsPolar;
  fDemoPrevw.frmDemoPreview.PreviewBox1.Invalidate;
end;

end.
