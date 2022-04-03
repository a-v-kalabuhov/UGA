program Project1;

uses
  Forms,
  ShowHintsU in 'ShowHintsU.pas' {Form1},
  fQueryRes in 'fQueryRes.pas' {frmQueryResults};

{$R *.RES}

begin
  Application.Initialize;
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.
