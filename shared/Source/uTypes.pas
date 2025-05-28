unit uTypes;

interface

uses
  Variants;

  function TryVarToStr(const V: Variant; var Str: string): Boolean;

implementation

function TryVarToStr(const V: Variant; var Str: string): Boolean;
begin
  try
    Str := VarToStrDef(V, '');
    Result := True;
  except
    Result := False;
    Str := '';
  end;
end;

end.
