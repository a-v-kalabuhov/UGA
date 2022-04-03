unit fDGNExport;

interface

uses Windows, SysUtils, Classes, Graphics, Forms, Controls, StdCtrls, 
  Buttons, ExtCtrls, Dialogs, EzNumEd;

type
  TfrmDGNExport = class(TForm)
    OKBtn: TButton;
    CancelBtn: TButton;
    Label1: TLabel;
    ListBox1: TListBox;
    GroupBox1: TGroupBox;
    Label2: TLabel;
    Label3: TLabel;
    Edit1: TEdit;
    Label4: TLabel;
    Label5: TLabel;
    Edit2: TEdit;
    Label6: TLabel;
    Label7: TLabel;
    Edit3: TEdit;
    SpeedButton1: TSpeedButton;
    OpenDialog1: TOpenDialog;
    NumEd1: TEzNumEd;
    NumEd2: TEzNumEd;
    chkExplode: TCheckBox;
    procedure SpeedButton1Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

implementation

{$R *.dfm}

procedure TfrmDGNExport.SpeedButton1Click(Sender: TObject);
begin
  Opendialog1.filename:= Edit3.Text;
  if not Opendialog1.execute then exit;
  Edit3.text:= Opendialog1.filename;
end;

end.
