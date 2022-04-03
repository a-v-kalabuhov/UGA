unit fAccuDrawSetts;

interface

uses Windows, SysUtils, Classes, Graphics, Forms, Controls, StdCtrls, 
  Buttons, ExtCtrls, EzColorPicker, ComCtrls, EzNumEd, EzCmdLine;

type
  TfrmAccuDrawSetts = class(TForm)
    OKBtn: TButton;
    CancelBtn: TButton;
    PageControl1: TPageControl;
    TabSheet1: TTabSheet;
    TabSheet2: TTabSheet;
    ColorBox1: TEzColorBox;
    Label1: TLabel;
    Label2: TLabel;
    ColorBox2: TEzColorBox;
    Label3: TLabel;
    ColorBox3: TEzColorBox;
    Label4: TLabel;
    ColorBox4: TEzColorBox;
    CheckBox1: TCheckBox;
    CheckBox2: TCheckBox;
    CheckBox3: TCheckBox;
    Label5: TLabel;
    NumEd1: TEzNumEd;
    Label6: TLabel;
    NumEd2: TEzNumEd;
    chkSkip: TCheckBox;
    CheckBox4: TCheckBox;
    Label7: TLabel;
    ColorBox5: TEzColorBox;
    ChkSameDist: TCheckBox;
    procedure OKBtnClick(Sender: TObject);
  private
    { Private declarations }
    FCmdLine: TEzCmdLine;
  public
    { Public declarations }
    function Enter( CmdLine: TEzCmdLine ): Word;
  end;

implementation

{$R *.dfm}

function TfrmAccuDrawSetts.Enter( CmdLine: TEzCmdLine ): Word;
begin
  FCmdline:= Cmdline;
  with FCmdline.AccuDraw do
  begin
    ColorBox1.SelectionColor:= XAxisColor;
    ColorBox2.SelectionColor:= YAxisColor;
    ColorBox3.SelectionColor:= HiliteColor;
    ColorBox4.SelectionColor:= FrameColor;
    ColorBox5.SelectionColor:= SnapColor;

    Checkbox1.Checked:= Enabled;
    Checkbox2.Checked:= SnapToAxis;
    Checkbox3.Checked:= SnapUnRotated;
    ChkSameDist.Checked:= SnapSameDistance;
    Checkbox4.Checked:= RotateToSegments;
    NumEd1.NumericValue := Width;
    NumEd2.NumericValue := Tolerance;
    ChkSkip.Checked:= ReshapeAdvance;
  end;

  result:=showmodal;
end;

procedure TfrmAccuDrawSetts.OKBtnClick(Sender: TObject);
begin
  with FCmdline.AccuDraw do
  begin
    XAxisColor:= ColorBox1.SelectionColor;
    YAxisColor:= ColorBox2.SelectionColor;
    HiliteColor:= ColorBox3.SelectionColor;
    FrameColor:= ColorBox4.SelectionColor;
    SnapColor:= ColorBox5.SelectionColor;

    Enabled:= Checkbox1.Checked;
    SnapToAxis:= Checkbox2.Checked;
    SnapUnRotated:= Checkbox3.Checked;
    SnapSameDistance:= ChkSameDist.Checked;
    RotateToSegments:= Checkbox4.Checked;
    Width:= trunc(NumEd1.NumericValue);
    Tolerance:= trunc(NumEd2.NumericValue);
    ReshapeAdvance:= ChkSkip.Checked ;
  end;
end;

end.
