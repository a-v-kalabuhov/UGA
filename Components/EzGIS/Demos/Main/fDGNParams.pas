unit fDGNParams;

interface

uses Windows, SysUtils, Classes, Graphics, Forms, Controls, StdCtrls, 
  Buttons, ExtCtrls, CheckLst;

type
  TfrmDGNParams = class(TForm)
    OKBtn: TButton;
    CancelBtn: TButton;
    Bevel1: TBevel;
    ChkList1: TCheckListBox;
    Label1: TLabel;
    chkTrueType: TCheckBox;
    chkDefColor: TCheckBox;
    chkMemLoaded: TCheckBox;
    Button1: TButton;
    Button2: TButton;
    procedure FormCreate(Sender: TObject);
    procedure Button1Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmDGNParams: TfrmDGNParams;

implementation

{$R *.DFM}

procedure TfrmDGNParams.FormCreate(Sender: TObject);
var
  I: Integer;
begin
  For I:=0 to 63 do
  begin
    ChkList1.Items.Add( 'Level' + IntToStr(I));
    ChkList1.Checked[I]:= true;
  end;
end;

procedure TfrmDGNParams.Button1Click(Sender: TObject);
var
  I: Integer;
begin
  for I:= 0 to chkList1.Items.Count-1 do
    chkList1.Checked[I] := TButton(Sender).Tag = 1;
end;

end.
