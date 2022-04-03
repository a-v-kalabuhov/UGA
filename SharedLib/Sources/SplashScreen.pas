unit SplashScreen;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, jpeg;

type
  TSplashScreenForm = class(TForm)
    Timer: TTimer;
    Image: TImage;
    procedure TimerTimer(Sender: TObject);
  private
    MainForm: TForm;
  public
    { Public declarations }
  end;

  procedure ShowSplashScreen(pMainForm: TForm);

implementation

{$R *.dfm}

var
  SplashScreenForm: TSplashScreenForm;

procedure ShowSplashScreen(pMainForm: TForm);
begin
  if not Assigned(SplashScreenForm) then
    SplashScreenForm := TSplashScreenForm.Create(Application);
  with SplashScreenForm do
  begin
    MainForm := pMainForm;
    Timer.Enabled := True;
    Show;
    Application.ProcessMessages;
  end;
end;

procedure TSplashScreenForm.TimerTimer(Sender: TObject);
begin
  if MainForm <> nil then
  if MainForm.Visible then
  begin
    Close;
  end;
  Application.ProcessMessages;
end;

end.
