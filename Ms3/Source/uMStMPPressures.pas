unit uMStMPPressures;

interface

type
  TmstMPPressures = class
  public
    class function StatusName(const aId: Integer): string;
    class function MinId: Integer;
    class function MaxId: Integer;
  end;

implementation

{ TmstMPStatuses }

class function TmstMPPressures.MaxId: Integer;
begin
  Result := 15;
end;

class function TmstMPPressures.MinId: Integer;
begin
  Result := 0;
end;

class function TmstMPPressures.StatusName(const aId: Integer): string;
begin
  case aId of
  0  : Result := '0,4 кв';
  1  : Result := '6 кв';
  2  : Result := '10 кв';
  3  : Result := '20 кв';
  4  : Result := '35 кв';
  5  : Result := '60 кв';
  6  : Result := '110 кв';
  7  : Result := '220 кв';
  8  : Result := '300 кв';
  9  : Result := '330 кв';
  10 : Result :='400 кв';
  11 : Result := '500 кв';
  12 : Result := '600 кв';
  13 : Result := '750 кв';
  14 : Result := '800 кв';
  15 : Result := '1150 кв';
  else
      Result := '';
  end;
end;

end.
