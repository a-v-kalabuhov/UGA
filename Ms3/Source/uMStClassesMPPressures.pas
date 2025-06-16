unit uMStClassesMPPressures;

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
  Result := 2;
end;

class function TmstMPPressures.MinId: Integer;
begin
  Result := 0;
end;

class function TmstMPPressures.StatusName(const aId: Integer): string;
begin
  case aId of
  0 : Result := 'Низкое';
  1 : Result := 'Среднее';
  2 : Result := 'Высокое';
  else
      Result := 'ошибка';
  end;
end;

end.
