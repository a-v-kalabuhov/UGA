unit uStringUtils;

interface

type
  TStringConverter = class
  public
    class var FloatValue: Double;
    class function StrToFloat(S: string): Boolean;
  end;

implementation

uses
  SysUtils, Classes;

type
  TFormatComparer = class
  private
    FSource: String;
    FFormat: String;
    FFormatParts: TStringList;
    procedure ParseFormat;
    procedure CheckSource;
  public
    function CompareFormat(const Format, Str: String): Boolean;
  end;

function CheckStringFormat(const Format, Str: String): Boolean;
begin
end;



// "%" [index ":"] ["-"] [width] ["." prec] type

// index = integer
// width - integer
// prec - integer
// type in [d, u, e, f, g, n, m, p, s, x]

{ TFormatComparer }

procedure TFormatComparer.CheckSource;
begin

end;

function TFormatComparer.CompareFormat(const Format, Str: String): Boolean;
begin
  FFormat := Format;
  FSource := Str;
  ParseFormat;
  CheckSource;
end;

procedure TFormatComparer.ParseFormat;
var
  I: Integer;
  S: String;
begin
  FFormatParts.Clear;
  S := FFormat;
  I := Pos('%', S);
  while I > 0 do
  begin
    I := Pos('%', FFormat);
  end;
end;

{ TStringConverter }

class function TStringConverter.StrToFloat(S: string): Boolean;
begin
  S := StringReplace(StringReplace(Trim(S), '.', DecimalSeparator, [rfReplaceAll]), ',', DecimalSeparator, [rfReplaceAll]);
  Result := TryStrToFloat(S, FloatValue);
end;

end.
