program IWProject;
{PUBDIST}

uses
  IWMain,
  ServerController in 'ServerController.pas' {IWServerController: TDataModule},
  IWUnit1 in 'IWUnit1.pas' {formMain: TIWAppForm};

{$R *.res}

begin
  IWRun(TFormMain, TIWServerController);
end.
