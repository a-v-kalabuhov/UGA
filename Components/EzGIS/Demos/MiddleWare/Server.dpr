program Server;

uses
  Forms,
  fServer in 'fServer.pas' {frmMain},
  GISDataU in 'GISDataU.pas' {GISData: TDataModule};

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TfrmMain, frmMain);
  Application.Run;
end.
