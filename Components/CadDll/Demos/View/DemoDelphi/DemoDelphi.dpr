// JCL_DEBUG_EXPERT_GENERATEJDBG OFF
// JCL_DEBUG_EXPERT_INSERTJDBG OFF
program DemoDelphi;

uses
  Forms,
  sgcadimage,
  fMain in 'fMain.pas' {fmMain};

{$R *.RES}

var
  User, EMail, Key: String;
begin
  Application.Initialize;
  Application.Title := 'CAD DLL demo';
  Application.CreateForm(TfmMain, fmMain);
  User := 'Александр Калабухов';
  EMail := 'a.v.kalabuhov@gmail.com';
  Key := '2LHF2U-PHEQP1-587O9K-2IOU2O-4F4R81-QR3KAN';
  StRg(PChar(User), PChar(Email), PChar(Key));
  Application.Run;
end.
