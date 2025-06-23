unit uDateTimeUtils;

interface

uses
  SysUtils;

type
  TDateTimeUtils = class
  public
    class function DateEquals(const aDate1, aDate2: TDateTime): Boolean;
    class function DateLOE(const aDate1, aDate2: TDateTime): Boolean;
    class function ReplaceSeparators(const aDateText: string): string;
  end;

const
  DateSeparators = [',', '/', '\', '-'];
  DefaultDateSeparator = '.';

implementation

{ TDateTimeUtils }

class function TDateTimeUtils.DateEquals(const aDate1, aDate2: TDateTime): Boolean;
var
  D1, D2, M1, M2, Y1, Y2: Word;
begin
  DecodeDate(aDate1, Y1, M1, D1);
  DecodeDate(aDate2, Y2, M2, D2);
  Result := (D1 = D2) and (M1 = M2) and (Y1 = Y2);
end;

/// <summary>
/// Less or equals.
/// </summary>
class function TDateTimeUtils.DateLOE(const aDate1, aDate2: TDateTime): Boolean;
var
  D1, D2, M1, M2, Y1, Y2: Word;
begin
  DecodeDate(aDate1, Y1, M1, D1);
  DecodeDate(aDate2, Y2, M2, D2);
  Result := (Y1 < Y2) or ((Y1 = Y2) and ((M1 < M2) or ((M1 = M2) and (D1 <= D2))));
end;

class function TDateTimeUtils.ReplaceSeparators(const aDateText: string): string;
var
  I: Integer;
begin
  Result := aDateText;
  for I := 1 to Length(Result) do
  begin
    if Result[I] in DateSeparators then
      Result[I] := DefaultDateSeparator;
  end;
end;

end.
