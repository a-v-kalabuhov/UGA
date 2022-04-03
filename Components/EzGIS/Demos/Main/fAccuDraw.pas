unit fAccuDraw;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, EzNumEd, Buttons;

type
  TfrmAccuDraw = class(TForm)
    NumEd1: TEzNumEd;
    NumEd2: TEzNumEd;
    chkX: TCheckBox;
    chkY: TCheckBox;
    BtnRect: TSpeedButton;
    BtnPolar: TSpeedButton;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure NumEd1Change(Sender: TObject);
    procedure NumEd2Change(Sender: TObject);
    procedure chkXClick(Sender: TObject);
    procedure chkYClick(Sender: TObject);
    procedure BtnRectClick(Sender: TObject);
    procedure BtnPolarClick(Sender: TObject);
    procedure FormKeyPress(Sender: TObject; var Key: Char);
  private
    { Private declarations }
    FInUpdate: Boolean;
  public
    { Public declarations }
    procedure CreateParams(var Params: TCreateParams); override;
    property InUpdate: Boolean read FInUpdate write FInUpdate;
  end;

Var
  AccuDrawParent: THandle;

implementation

{$R *.dfm}

uses
  Math, fMain, EzCmdLine;

{ TfrmAccuDraw }

procedure TfrmAccuDraw.CreateParams(var Params: TCreateParams);
begin
  Inherited CreateParams( Params );
  With Params Do
  Begin
    Style := Style Or ws_Overlapped;
    WndParent := fMain.Form1.Handle;
  end;
end;

procedure TfrmAccuDraw.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  fMain.Form1.frmAccuDraw:= Nil;
  fMain.Form1.AccuDraw1.Checked:= False;
  fMain.Form1.CmdLine1.AccuDraw.Showing:= False;
  Action:= caFree;
end;

procedure TfrmAccuDraw.NumEd1Change(Sender: TObject);
begin
  If FInUpdate Then Exit;
  chkX.Checked:= true;
  fMain.Form1.CmdLine1.AccuDraw.DeltaX:= NumEd1.NumericValue;
  fMain.Form1.CmdLine1.AccuDraw.DeltaXLocked:= true;
end;

procedure TfrmAccuDraw.NumEd2Change(Sender: TObject);
begin
  If FInUpdate Then Exit;
  chkY.Checked:= true;
  If BtnRect.Down then    // rectangular
    fMain.Form1.CmdLine1.AccuDraw.DeltaY:= NumEd2.NumericValue
  else    // polar
    fMain.Form1.CmdLine1.AccuDraw.DeltaY:= DegToRad( NumEd2.NumericValue );
  fMain.Form1.CmdLine1.AccuDraw.DeltaYLocked:= true;
end;

procedure TfrmAccuDraw.chkXClick(Sender: TObject);
begin
  If FInUpdate Then Exit;
  fMain.Form1.CmdLine1.AccuDraw.DeltaX:= NumEd1.NumericValue;
  fMain.Form1.CmdLine1.AccuDraw.DeltaXLocked:= chkX.Checked;
end;

procedure TfrmAccuDraw.chkYClick(Sender: TObject);
begin
  If FInUpdate Then Exit;
  fMain.Form1.CmdLine1.AccuDraw.DeltaY:= NumEd2.NumericValue;
  fMain.Form1.CmdLine1.AccuDraw.DeltaYLocked:= chkY.Checked;
end;

procedure TfrmAccuDraw.BtnRectClick(Sender: TObject);
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

  fMain.Form1.CmdLine1.AccuDraw.FrameStyle:= fsRectangular;
  fMain.Form1.DrawBox1.Invalidate;
end;

procedure TfrmAccuDraw.BtnPolarClick(Sender: TObject);
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
  fMain.Form1.CmdLine1.AccuDraw.FrameStyle:= fsPolar;
  fMain.Form1.DrawBox1.Invalidate;
end;

procedure TfrmAccuDraw.FormKeyPress(Sender: TObject; var Key: Char);
begin
  If Key  in ['x','X','d','D'] then
  begin
    chkX.Checked:= true;
    chkXClick(Nil);
  end;
  If Key  in ['y','Y','a','A'] then
  begin
    chkY.Checked:= true;
    chkYClick(Nil);
  end;
end;

end.
