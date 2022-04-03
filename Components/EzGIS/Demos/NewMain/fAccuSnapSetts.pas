unit fAccuSnapSetts;

interface

uses Windows, SysUtils, Classes, Graphics, Forms, Controls, StdCtrls,
  Buttons, ExtCtrls, ComCtrls, EzNumEd, EzCmdLine;

type
  TfrmAccuSnapSetts = class(TForm)
    OKBtn: TButton;
    CancelBtn: TButton;
    Label1: TLabel;
    TrackBar1: TTrackBar;
    Label2: TLabel;
    cboSnap: TComboBox;
    Label3: TLabel;
    NumEd1: TEzNumEd;
    ChkEnabled: TCheckBox;
    procedure OKBtnClick(Sender: TObject);
  private
    { Private declarations }
    FCmdLine: TEzCmdLine;
  public
    { Public declarations }
    function enter(cmdLine: TEzCmdLine): Word;
  end;

implementation

{$R *.dfm}

uses
  ezbase;

{ TfrmAccuSnapSetts }

function TfrmAccuSnapSetts.enter(cmdLine: TEzCmdLine): Word;
begin
  FCmdLine:= CmdLine;
  with cmdLine.AccuSnap do
  begin
    chkEnabled.Checked:= Enabled;
    Trackbar1.Position:= Sensitivity;
    cboSnap.ItemIndex:= Ord(OsnapSetting);
    NumEd1.NumericValue:= SnapDivisor;
  end;
  result:=showmodal;
end;

procedure TfrmAccuSnapSetts.OKBtnClick(Sender: TObject);
begin
  with FcmdLine.AccuSnap do
  begin
    Enabled:= chkEnabled.Checked;
    Sensitivity:= Trackbar1.Position;
    OsnapSetting:= TEzOsnapSetting( cboSnap.ItemIndex );
    SnapDivisor:= trunc( NumEd1.NumericValue );
  end;
end;

end.
