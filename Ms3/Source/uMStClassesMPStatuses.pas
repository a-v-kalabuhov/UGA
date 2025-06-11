unit uMStClassesMPStatuses;

interface

type
  TmstMPStatuses = class
  public
    class function StatusName(const aStatus: Integer): string;
    class function MinId: Integer;
    class function MaxId: Integer;
  public
    const Projected = 1;
    const ProjectedDismantled = 2;
    const ProjectedCertified = 3;
    const Drawn = 4;
    const Archived = 5;
  end;

implementation

{ TmstMPStatuses }

class function TmstMPStatuses.MaxId: Integer;
begin
  Result := Archived;
end;

class function TmstMPStatuses.MinId: Integer;
begin
  Result := Projected;
end;

class function TmstMPStatuses.StatusName(const aStatus: Integer): string;
begin
  case aStatus of
  1 : Result := 'проектные';
  2 : Result := 'проектные демонтируемые объекты';
  3 : Result := 'проектные выдана справка';
  4 : Result := 'нанесенные';
  5 : Result := 'архивные';
  else
      Result := 'ошибка';
  end;
end;

end.
