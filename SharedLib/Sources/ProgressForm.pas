unit ProgressForm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ComCtrls, StdCtrls, ExtCtrls;

const
  WM_PROGRESS_CALLBACK = WM_USER + 1000;

type
  TTinyProgressForm = class(TForm)
    Label1: TLabel;
    ProgressBar1: TProgressBar;
    Timer1: TTimer;
    procedure Timer1Timer(Sender: TObject);
  private
    { Private declarations }
  public
    procedure ProgressCallBack(var AMessage : TMessage); message WM_PROGRESS_CALLBACK;
  end;

  procedure ShowProgress(current, max: Integer; Text: String; WithTimer: Boolean = False);
  procedure HideProgress;

implementation

{$R *.dfm}

var
  TinyProgressForm: TTinyProgressForm;
  
procedure ShowProgress(current, max: Integer; Text: String; WithTimer: Boolean = False);
begin
  if TinyProgressForm = nil then
    TinyProgressForm := TTinyProgressForm.Create(Application);
  TinyProgressForm.Timer1.Enabled := WithTimer;
  TinyProgressForm.Label1.Caption := Text;
  TinyProgressForm.ProgressBar1.Max := max;
  TinyProgressForm.ProgressBar1.Position := current;
  TinyProgressForm.Visible := True;
  Application.ProcessMessages;
end;

procedure HideProgress;
begin
  if TinyProgressForm <> nil then
  begin
    TinyProgressForm.Visible := False;
    TinyProgressForm.Timer1.Enabled := False;
    Application.ProcessMessages;
  end;
end;

procedure TTinyProgressForm.Timer1Timer(Sender: TObject);
begin
  ProgressBar1.Position := ProgressBar1.Position + 1;
  Application.ProcessMessages;
end;

procedure TTinyProgressForm.ProgressCallBack;
begin
  ProgressBar1.Position := ProgressBar1.Position + AMessage.LParam;
  Application.ProcessMessages;
end;

end.
