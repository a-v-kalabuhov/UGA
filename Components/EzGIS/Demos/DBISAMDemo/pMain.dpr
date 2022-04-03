program pMain;

uses
  Forms,
  fMain in 'fMain.pas' {Form1},
  fNewLayer in 'fNewLayer.pas' {frmNewLayer},
  dmComms in 'dmComms.pas' {DataModule1: TDataModule};

{$R *.res}

begin
{$IFDEF MEMORY_CHECK}
  MemChk;
{$ENDIF}
  Application.Initialize;
  Application.CreateForm(TDataModule1, DataModule1);
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.
