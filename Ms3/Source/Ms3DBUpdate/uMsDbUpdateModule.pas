unit uMsDbUpdateModule;

interface

uses
  SysUtils, Classes, DB, IBDatabase;

type
  TMsDbUpdateModule = class(TDataModule)
    dbKis: TIBDatabase;
    dbGeo: TIBDatabase;
    trKis: TIBTransaction;
    trGeo: TIBTransaction;
  private
    { Private declarations }
  public
    procedure Open;
    procedure Close;
    procedure ExecScript(const ScriptText: string);
  end;

var
  MsDbUpdateModule: TMsDbUpdateModule;

implementation

{$R *.dfm}

{ TMsDbUpdateModule }

procedure TMsDbUpdateModule.Close;
begin
  ;
end;

procedure TMsDbUpdateModule.ExecScript(const ScriptText: string);
begin
  
end;

procedure TMsDbUpdateModule.Open;
begin
  ;
end;

end.
