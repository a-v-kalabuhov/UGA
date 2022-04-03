unit uDebug;

interface

uses
  Classes;

type
  TDebugLog = class
  private
    class var FStrings: TStrings;
  public
    class procedure Add(const Message: string);
    class procedure Clear;
    class function Strings: TStrings;
  end;

implementation

{ TDebugLog }

class procedure TDebugLog.Add(const Message: string);
begin
  if not Assigned(FStrings) then
    FStrings := TStringList.Create;
  FStrings.Add(Message);
end;

class procedure TDebugLog.Clear;
begin
  if Assigned(FStrings) then
    FStrings.Clear;
end;

class function TDebugLog.Strings: TStrings;
begin
  Result := FStrings;
end;

end.
