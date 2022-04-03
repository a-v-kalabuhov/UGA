unit fAccuDraw;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, EzNumEd, Buttons, EzCmdLine;

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
    FCmdLine: TEzCmdLine;
    FInUpdate: Boolean;

    FOnThisClose: TNotifyEvent;
  public
    { Public declarations }
    procedure Enter( CmdLine: TEzCmdLine );
    procedure CreateParams(var Params: TCreateParams); override;
    property InUpdate: Boolean read FInUpdate write FInUpdate;

    property OnThisClose: TNotifyEvent read FOnThisClose write FOnThisClose;
  end;

Var
  AccuDrawParent: THandle;

implementation

{$R *.dfm}

uses
  Math;

{ TfrmAccuDraw }

procedure TfrmAccuDraw.CreateParams(var Params: TCreateParams);
begin
  Inherited CreateParams( Params );
  With Params Do
  Begin
    Style := Style Or ws_Overlapped;
    WndParent := AccuDrawParent;
  end;
end;

procedure TfrmAccuDraw.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  If Assigned(FOnThisClose) then
    FOnThisClose(Self);
  FCmdLine.AccuDraw.Showing:= False;
  Action:= caFree;
end;

procedure TfrmAccuDraw.NumEd1Change(Sender: TObject);
begin
  If FInUpdate Then Exit;
  chkX.Checked:= true;
  FCmdLine.AccuDraw.DeltaX:= NumEd1.NumericValue;
  FCmdLine.AccuDraw.DeltaXLocked:= true;
end;

procedure TfrmAccuDraw.NumEd2Change(Sender: TObject);
begin
  If FInUpdate Then Exit;
  chkY.Checked:= true;
  If BtnRect.Down then    // rectangular
    FCmdLine.AccuDraw.DeltaY:= NumEd2.NumericValue
  else    // polar
    FCmdLine.AccuDraw.DeltaY:= DegToRad( NumEd2.NumericValue );
  FCmdLine.AccuDraw.DeltaYLocked:= true;
end;

procedure TfrmAccuDraw.chkXClick(Sender: TObject);
begin
  If FInUpdate Then Exit;
  FCmdLine.AccuDraw.DeltaX:= NumEd1.NumericValue;
  FCmdLine.AccuDraw.DeltaXLocked:= chkX.Checked;
end;

procedure TfrmAccuDraw.chkYClick(Sender: TObject);
begin
  If FInUpdate Then Exit;
  FCmdLine.AccuDraw.DeltaY:= NumEd2.NumericValue;
  FCmdLine.AccuDraw.DeltaYLocked:= chkY.Checked;
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

  FCmdLine.AccuDraw.FrameStyle:= fsRectangular;
  FCmdLine.ActiveDrawBox.Invalidate;
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
  FCmdLine.AccuDraw.FrameStyle:= fsPolar;
  FCmdLine.ActiveDrawBox.Invalidate;
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

procedure TfrmAccuDraw.Enter(CmdLine: TEzCmdLine);
begin
  FCmdLine:= CmdLine;

  Show;
end;

end.
