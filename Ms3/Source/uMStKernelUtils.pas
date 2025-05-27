unit uMStKernelUtils;

interface

uses
  SysUtils, Classes, Windows, Clipbrd,
  uStringUtils;

type
  TPointUtils = class
  private
    class function ReadXYFromText(const aText: string; var X, Y: Double; var MSK36: Boolean): Boolean;
  public
    class procedure PointToClipboard(const Xgeo, Ygeo: Double; const MSK36: Boolean);
    class function PointFromClipboard(var Xgeo, Ygeo: Double; var MSK36: Boolean): Boolean;
  end;

implementation

{ TPointUtils }

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
var
  Tmp: TStringList;
  S: string;
begin
  Result := False;
  Tmp := TStringList.Create;
  try
    Tmp.Delimiter := #9;
    Tmp.StrictDelimiter := True;
    Tmp.DelimitedText := aText;
    if Tmp.Count < 3 then
      Exit;
    if TStringConverter.StrToFloat(Trim(Tmp[0])) then
    begin
      X := TStringConverter.FloatValue;
      if TStringConverter.StrToFloat(Trim(Tmp[1])) then
      begin
        Y := TStringConverter.FloatValue;
        S := AnsiUpperCase(Trim(Tmp[2]));
        if S = 'MSK36' then
          MSK36 := True
        else
          if S = 'VRN' then
            MSK36 := False
          else
            Result := False;
        
      end;
    end;
  finally
    Tmp.Free;
  end;
end;

end.
