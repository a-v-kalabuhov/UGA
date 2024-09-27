program DemoCadDllExport;

uses
  Forms,
  Unit1 in 'Unit1.pas' {fmMetafileToCADExport};

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TfmMetafileToCADExport, fmMetafileToCADExport);
  Application.Run;
end.
