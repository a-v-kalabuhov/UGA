program pMain;

uses
  Forms,
  fMain in 'fMain.pas' {Form1},
  fNewLayer in 'fNewLayer.pas' {frmNewLayer},
  fClient in 'fClient.pas' {frmClient};

{$R *.res}

begin
{$IFDEF MEMORY_CHECK}
  MemChk;
{$ENDIF}
  Application.Initialize;
  Application.Title := 'EzGIS components main demo';
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.
