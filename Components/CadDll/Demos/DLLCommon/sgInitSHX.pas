unit sgInitSHX;

interface

uses
  SysUtils, Forms, sgConsts, Windows;

type
  TCADSetSHX = function(SearchSHXPaths, DefaultSHXPath, DefaultSHXFont: PChar;
    UseSHXFonts, UseACADPaths: BOOL): Integer; stdcall;

procedure InitSHX(AFn: TCADSetSHX);

implementation

procedure InitSHX(AFn: TCADSetSHX);
var
  vPath: string;
begin
  vPath := ExtractFilePath(Application.ExeName) + '..\..\..\SHX\';
  AFn(PChar(vPath), PChar(vPath),
    PChar('simplex.shx'), True, False);
end;

end.
