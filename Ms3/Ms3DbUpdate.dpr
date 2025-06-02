// JCL_DEBUG_EXPERT_GENERATEJDBG OFF
// JCL_DEBUG_EXPERT_INSERTJDBG OFF
program Ms3DbUpdate;

uses
  Forms,
  uMsDbMain in 'Source\Ms3DBUpdate\uMsDbMain.pas' {Form4},
  uMsDbClasses in 'Source\Ms3DBUpdate\uMsDbClasses.pas',
  uMsDbUpdateModule in 'Source\Ms3DBUpdate\uMsDbUpdateModule.pas' {MsDbUpdateModule: TDataModule};

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TForm4, Form4);
  Application.CreateForm(TMsDbUpdateModule, MsDbUpdateModule);
  Application.Run;
end.
