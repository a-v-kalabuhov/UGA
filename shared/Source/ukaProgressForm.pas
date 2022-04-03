unit ukaProgressForm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ComCtrls;

type
  TkaProgressForm = class(TForm)
    Text: TLabel;
    ProgressBar: TProgressBar;
  end;

implementation

{$R *.dfm}

end.
