unit fNewPt;

{$I EZ_FLAG.PAS}
interface

uses
  Classes, Forms, Controls, StdCtrls, EzNumEd;

type
  TfrmNewPt = class(TForm)
    OKBtn: TButton;
    CancelBtn: TButton;
    GroupBox1: TGroupBox;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    GroupBox2: TGroupBox;
    Label6: TLabel;
    Label7: TLabel;
    EdX: TEzNumEd;
    EdY: TEzNumEd;
    Edit1: TEzNumEd;
    Edit2: TEzNumEd;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

implementation

{$R *.DFM}

end.
