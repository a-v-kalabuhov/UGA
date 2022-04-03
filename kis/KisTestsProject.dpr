// JCL_DEBUG_EXPERT_GENERATEJDBG OFF
// JCL_DEBUG_EXPERT_INSERTJDBG OFF
// JCL_DEBUG_EXPERT_DELETEMAPFILE OFF
program KisTestsProject;

uses
  Forms,
  KistTestsMain in 'KisTests\KistTestsMain.pas' {Form1},
  uKisScanImagesViewForm in 'Source\uKisScanImagesViewForm.pas' {KisScanImagesViewForm},
  uMstDialogFactory in '..\Ms3\Source\uMstDialogFactory.pas',
  uMstImportFactory in '..\Ms3\Source\uMstImportFactory.pas',
  uMstImportMifBase in '..\Ms3\Source\uMstImportMifBase.pas',
  uMStImportMifEntityLoaders in '..\Ms3\Source\uMStImportMifEntityLoaders.pas',
  uMstImportMidMif in '..\Ms3\Source\uMstImportMidMif.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.
