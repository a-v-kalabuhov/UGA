unit fRepeat;

interface

uses Windows, SysUtils, Classes, Graphics, Forms, Controls, StdCtrls, 
  Buttons, ExtCtrls, EzNumEd;

type
  TfrmRepeat = class(TForm)
    OKBtn: TButton;
    CancelBtn: TButton;
    Bevel1: TBevel;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    EzNumEd1: TEzNumEd;
    EzNumEd2: TEzNumEd;
    EzNumEd3: TEzNumEd;
    EzNumEd4: TEzNumEd;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

implementation

{$R *.DFM}

end.
