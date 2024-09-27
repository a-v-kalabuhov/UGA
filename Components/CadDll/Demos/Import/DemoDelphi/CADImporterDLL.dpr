// JCL_DEBUG_EXPERT_GENERATEJDBG OFF
// JCL_DEBUG_EXPERT_INSERTJDBG OFF
program CADImporterDLL;
{.$DEFINE UseFastMMLeaks}
uses
  Forms,
  Main in 'Main.pas' {fmCADDLLdemo},
  CADIntf in 'CADIntf.pas',
  SHXDlg in 'SHXDlg.pas' {FontSettingsDlg},
  sgcadimage in '..\..\..\..\..\shared\Source\CadDll\sgcadimage.pas';

{$IFNDEF UNICODE}
{$MESSAGE 'This demo works in Delphi 2009 (?) and higher. Older versions without unicode support do not work with CAD IMporter DLL unicode version. 'Write to info@cadsofttools.com to request a CAD importer dll for older Delphi versions.'}
{$ENDIF}

{$R *.RES}

begin
{$IFDEF UseFastMMLeaks}
    // expected leaks
  RegisterExpectedMemoryLeak(TIdThreadSafeInteger, 1);
  RegisterExpectedMemoryLeak(TIdCriticalSection, 2);
{$ENDIF}
  Application.Initialize;
  Application.Title := 'CAD Importer DLL';
  Application.CreateForm(TfmCADDLLdemo, fmCADDLLdemo);
  Application.CreateForm(TFontSettingsDlg, FontSettingsDlg);
  Application.Run;
end.
