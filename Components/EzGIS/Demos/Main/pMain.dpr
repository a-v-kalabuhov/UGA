program pMain;

uses
  Forms,
  fMain in 'fmain.pas' {Form1},
  fSymbEd in 'fSymbEd.pas' {frmSymbols};

{$R *.res}

{.$DEFINE MEMORY_CHECK}
begin
{$IFDEF MEMORY_CHECK}
  MemChk;
{$ENDIF}
  Application.Initialize;
  Application.Title := 'EzGIS Main demo';
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.
