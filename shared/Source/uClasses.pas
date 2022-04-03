unit uClasses;

interface

uses
  SysUtils, Classes;

type
  TStringsHelper = class helper for TStrings
  public
    function Pos(Substr: string; var Line, Position: Integer; CaseSensitive: Boolean = True): Boolean;
    procedure ToUpper();
  end;

  TStringListExt = class helper for TStringList
  public
    function Clone(): TStringList;
  end;

implementation

{ TStringListExt }

function TStringListExt.Clone: TStringList;
begin
  Result := TStringList.Create();
  Result.AddStrings(Self);
end;

{ TStringsHelper }

function TStringsHelper.Pos(Substr: string; var Line, Position: Integer; CaseSensitive: Boolean): Boolean;
var
  I, J: Integer;
  St: string;
begin
  if not CaseSensitive then
    Substr := AnsiUpperCase(Substr);
  for I := 0 to Self.Count - 1 do
  begin
    St := Self.Strings[I];
    if not CaseSensitive then
      St := AnsiUpperCase(St);
    J := System.Pos(Substr, St);
    if J > 0 then
    begin
      Line := I;
      Position := J;
      Break;
    end;
  end;
  Result := Position > 0;
end;

procedure TStringsHelper.ToUpper;
var
  I: Integer;
begin
  for I := 0 to Self.Count - 1 do
    Self.Strings[I] := AnsiUpperCase(Self.Strings[I]);
end;

end.
