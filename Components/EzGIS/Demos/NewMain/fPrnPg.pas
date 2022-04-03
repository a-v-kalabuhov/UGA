unit fPrnPg;

{$I EZ_FLAG.PAS}
interface

uses
  Classes, Controls, Forms, StdCtrls, ComCtrls, ExtCtrls;

type
  TfrmPrintProgress = class(TForm)
    btnCancel: TButton;
    pnlInfo: TPanel;
    lblPrinter: TLabel;
    lblFileName: TLabel;
    Bar1: TProgressBar;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

implementation

{$R *.DFM}


end.
