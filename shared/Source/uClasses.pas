unit uClasses;

interface

uses
  SysUtils, Classes;

type
  TStringsHelper = class helper for TStrings
  private
    function GetNumber(Index: Integer): Integer;
    procedure SetNumber(Index: Integer; const Value: Integer);
    function GetLogical(Index: Integer): Boolean;
    procedure SetLogical(Index: Integer; const Value: Boolean);
  public
    procedure IncNumber(Index: Integer);
    function Pos(Substr: string; var Line, Position: Integer; CaseSensitive: Boolean = True): Boolean;
    procedure ToUpper();
    //
    property Logical[Index: Integer]: Boolean read GetLogical write SetLogical;
    property Number[Index: Integer]: Integer read GetNumber write SetNumber;
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

function TStringsHelper.GetLogical(Index: Integer): Boolean;
begin
  Result := Number[Index] <> 0;
end;

function TStringsHelper.GetNumber(Index: Integer): Integer;
var
  Tmp: TObject;
begin
  Tmp := inherited Objects[Index];
  Result := Integer(Tmp);
end;

procedure TStringsHelper.IncNumber(Index: Integer);
begin
  Number[Index] := Number[Index] + 1; 
end;

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

procedure TStringsHelper.SetLogical(Index: Integer; const Value: Boolean);
begin
  if Logical[Index] <> Value then
    if Value then
      Number[Index] := 1
    else
      Number[Index] := 0; 
end;

procedure TStringsHelper.SetNumber(Index: Integer; const Value: Integer);
begin
  inherited Objects[Index] := TObject(Value); 
end;

procedure TStringsHelper.ToUpper;
var
  I: Integer;
begin
  for I := 0 to Self.Count - 1 do
    Self.Strings[I] := AnsiUpperCase(Self.Strings[I]);
end;

end.
