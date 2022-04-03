program FontGenerator;

uses
  Forms,
  FontGeneratorU in 'FontGeneratorU.pas' {frmFontGenerator};

{$R *.RES}

begin
  Application.Initialize;
  Application.CreateForm(TfrmFontGenerator, frmFontGenerator);
  Application.Run;
end.
