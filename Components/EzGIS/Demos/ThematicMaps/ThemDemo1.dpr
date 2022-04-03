program ThemDemo1;

uses
  Forms,
  ThemDemoU1 in 'ThemDemoU1.pas' {Form1};

{$R *.RES}

begin
  Application.Initialize;
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.
