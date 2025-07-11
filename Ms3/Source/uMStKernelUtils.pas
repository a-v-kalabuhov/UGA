unit uMStKernelUtils;

interface

uses
  SysUtils, Classes, Windows, Clipbrd,
  uStringUtils, uGeoUtils;

type
  TPointUtils = class
  private
    class function IntReadXYFromText(const aText: string; const FieldDelimiter: Char; var X, Y: Double; var MSK36: Boolean): Boolean;
    class function ReadXYFromText(const aText: string; var X, Y: Double; var MSK36: Boolean): Boolean;
  public
    class procedure PointToClipboard(const Xgeo, Ygeo: Double; const MSK36: Boolean);
    class function PointFromClipboard(var Xgeo, Ygeo: Double; var MSK36: Boolean): Boolean;
  end;

implementation

{ TPointUtils }

class function TPointUtils.IntReadXYFromText(const aText: string; const FieldDelimiter: Char; var X, Y: Double;
  var MSK36: Boolean): Boolean;
var
  Tmp: TStringList;
  S: string;
begin
  Result := False;
  Tmp := TStringList.Create;
  try
    Tmp.Delimiter := FieldDelimiter;
    Tmp.StrictDelimiter := True;
    Tmp.DelimitedText := aText;
    // комбинации:
    // 1 - координата, 2 - координата, 3 - СК или отсутствует
    // 1 - номер, 2 - координата, 3 - координата, 4 - СК или отсутствует

    // проверяем вторую конфигурацию
    if Tmp.Count >= 3 then
    begin
      if TStringConverter.StrToFloat(Trim(Tmp[1])) then
      begin
        X := TStringConverter.FloatValue;
        if TStringConverter.StrToFloat(Trim(Tmp[2])) then
        begin
          Y := TStringConverter.FloatValue;
          //
          Result := True;
          //
          if Tmp.Count = 3 then
          begin
            MSK36 := TGeoUtils.IsMCK36(X, Y);
            Exit;
          end
          else
          begin
            S := AnsiUpperCase(Trim(Tmp[3]));
            if S = 'MSK36' then
            begin
              MSK36 := True;
              Result := True;
              Exit;
            end
            else
              if S = 'VRN' then
                MSK36 := False
              else
                MSK36 := TGeoUtils.IsMCK36(X, Y);
          end;
        end;
        Exit;
      end;
    end;
    // проверяем первую конфигурацию
    if TStringConverter.StrToFloat(Trim(Tmp[0])) then
    begin
      X := TStringConverter.FloatValue;
      if TStringConverter.StrToFloat(Trim(Tmp[1])) then
      begin
        Y := TStringConverter.FloatValue;
        //
        Result := True;
        //
        if Tmp.Count = 2 then
        begin
          MSK36 := TGeoUtils.IsMCK36(X, Y);
          Exit;
        end
        else
        begin
          S := AnsiUpperCase(Trim(Tmp[2]));
          if S = 'MSK36' then
          begin
            MSK36 := True;
            Result := True;
            Exit;
          end
          else
            if S = 'VRN' then
              MSK36 := False
            else
              MSK36 := TGeoUtils.IsMCK36(X, Y);
        end;
      end;
      Exit;
    end;
  finally
    Tmp.Free;
  end;
end;

class function TPointUtils.PointFromClipboard(var Xgeo, Ygeo: Double; var MSK36: Boolean): Boolean;
begin
  Result := False;
  Clipboard.Open;
  try
    if Clipboard.HasFormat(CF_TEXT) then
      Result := ReadXYFromText(Clipboard.AsText, Xgeo, Ygeo, MSK36);
  finally
    Clipboard.Close;
  end;
end;

class procedure TPointUtils.PointToClipboard;
var
  S: string;
begin
  S := Format('%0.2f', [Xgeo]) + #9 +
       Format('%0.2f', [Ygeo]) + #9;
//  if FCoordSystem = csMCK36 then
  if MSK36 then
    S := S + 'MSK36'
  else
    S := S + 'VRN';
  S := S + #9;
  Clipboard.AsText := S;
end;

class function TPointUtils.ReadXYFromText(const aText: string; var X, Y: Double; var MSK36: Boolean): Boolean;
begin
  Result := IntReadXYFromText(aText, #9, X, Y, MSK36);
  if not Result then
    Result := IntReadXYFromText(aText, ';', X, Y, MSK36);
end;

end.
