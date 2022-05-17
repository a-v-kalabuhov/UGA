program EzShared_make;

{$APPTYPE CONSOLE}

uses
  SysUtils,
  uEzActionsAutoScroll in 'uEzActionsAutoScroll.pas',
  uEzEntityCSConvert in 'uEzEntityCSConvert.pas',
  uEzAutoCADImport in 'uEzAutoCADImport.pas' {EzAutoCADImport: TDataModule},
  uEzBufferZone in 'uEzBufferZone.pas';

begin
  try
    { TODO -oUser -cConsole Main : Insert code here }
  except
    on E:Exception do
      Writeln(E.Classname, ': ', E.Message);
  end;
end.
