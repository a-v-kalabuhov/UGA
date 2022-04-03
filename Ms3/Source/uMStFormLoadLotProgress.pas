unit uMStFormLoadLotProgress;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ComCtrls;

type
  TmstLoadLotProgressForm = class(TForm)
    Label1: TLabel;
    ProgressBar1: TProgressBar;
    Label2: TLabel;
  public
    procedure OnProgress(Sender: TObject; Current, Count: Integer);
    procedure OnProgress2(Sender: TObject; const Title: string; Current, Count: Integer);
  end;

implementation

{$R *.dfm}

{ TmstLoadLotProgressForm }

procedure TmstLoadLotProgressForm.OnProgress(Sender: TObject; Current,
  Count: Integer);
begin
  Label2.Visible := False;
  ProgressBar1.Min := 0;
  ProgressBar1.Max := Count;
  ProgressBar1.Position := Current;
  Application.ProcessMessages;
end;

procedure TmstLoadLotProgressForm.OnProgress2(Sender: TObject; const Title: string; Current, Count: Integer);
var
  S: string;
begin
  S := Title;
  if Count > 0 then
    S := S + ' ... ' + IntToStr(Current) + '/' + IntToStr(Count);
  Label2.Caption := S;
  Label2.Visible := True;
  ProgressBar1.Min := 0;
  ProgressBar1.Max := Count;
  ProgressBar1.Position := Current;
  Application.ProcessMessages;
end;

end.
