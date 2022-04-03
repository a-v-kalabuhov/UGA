program pMain;

uses
  Forms,
  fMain in 'fMain.pas' {Form1},
  fNewLayer in 'fNewLayer.pas' {frmNewLayer};

{$R *.res}

begin
{$IFDEF MEMORY_CHECK}
  MemChk;
{$ENDIF}
  Application.Initialize;
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.
