program NewMain;

uses
  Forms,
  fmain in 'fmain.pas' {Form1},
  fLayerOpts in 'fLayerOpts.pas' {frmLayerOptions},
  fAccuSnapSetts in 'fAccuSnapSetts.pas' {frmAccuSnapSetts},
  fAccuSnap in 'fAccuSnap.pas' {frmAccuSnap};

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
