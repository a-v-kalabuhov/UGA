unit uMStKernelClassesOptions;

{$WARN SYMBOL_PLATFORM OFF}

interface

uses
  SysUtils;

type
  TMStOptionMngr = class
  private
    FNoSplash: Boolean;
    FDontUseFTP: Boolean;
  public
    constructor Create;
    property NoSplash: Boolean read FNoSplash;
    property DontUseFTP: Boolean read FDontUseFTP;
  end;

var
  Options: TMStOptionMngr;

const
  S_OPT_NOSPLASH_1 = '/NOSPLASH';
  S_OPT_NOSPLASH_2 = '-NOSPLASH';
  S_DONT_USE_FTP_1 = '/NOFTP';
  S_DONT_USE_FTP_2 = '-NOFTP';

implementation

{ TMStOptionMngr }

constructor TMStOptionMngr.Create;
var
  S: String;
begin
  S := AnsiUpperCase(CmdLine);
  FNoSplash := (Pos(S_OPT_NOSPLASH_1, S) > 0) or (Pos(S_OPT_NOSPLASH_2, S) > 0);
  FDontUseFTP := (Pos(S_DONT_USE_FTP_1, S) > 0) or (Pos(S_DONT_USE_FTP_2, S) > 0);
end;

initialization
  Options := TMStOptionMngr.Create;

finalization
  FreeAndNil(Options);

end.
