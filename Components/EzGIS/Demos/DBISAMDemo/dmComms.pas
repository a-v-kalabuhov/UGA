unit dmComms;

interface

uses
  SysUtils, Classes, ffdb, ffdbbase, ffllbase, ffllcomp, fflleng, ffsrintm,
  ffsreng, ffsqlbas, ffsqleng;

type
  TDataModule1 = class(TDataModule)
    ffServerEngine1: TffServerEngine;
    ffClient1: TffClient;
    ffSession1: TffSession;
    ffDatabase1: TffDatabase;
    ffSqlEngine1: TffSqlEngine;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  DataModule1: TDataModule1;

implementation

{$R *.dfm}

end.
