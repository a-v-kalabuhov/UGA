unit uKisAccessRights;

interface

uses
  Contnrs;

type
  TKisAccessKind = (akInsert, akEdit, akDelete, akSpecial);

  TKisAccessRight = class
  private
    FName: String;
    FId: Integer;
    FValue: Boolean;
    FModuleId: Integer;
  public
    property Id: Integer read FId write FId;
    property ModuleId: Integer read FModuleId write FModuleId;
    property Name: String read FName write FName;
    property Value: Boolean read FValue write FValue;
  end;

  TKisModuleAccess = class
  private
    FId: Integer;
    FName: String;
    FEnabled: Boolean;
  public
    property Id: Integer read FId write FId;
    property Name: String read FName write FName;
    property Enabled: Boolean read FEnabled write FEnabled;
  end;

  TKisModuleAccessList = class

  end;

  TKisARList = class(TObjectList)
  private
    function GetItems(Index: Integer): TKisAccessRight;
    procedure SetItems(Index: Integer; const Value: TKisAccessRight);
  public
    function Find(ModuleId: Integer; const Name: String): TKisAccessRight;
    function GetRight(ModuleId: Integer; const Name: String): Boolean;
    //
    property Items[Index: Integer]: TKisAccessRight read GetItems write SetItems; default;
  end;

implementation

{ TKisARList }

function TKisARList.Find(ModuleId: Integer;
  const Name: String): TKisAccessRight;
var
  I: Integer;
  AR: TKisAccessRight;
begin
  for I := 0 to Count - 1 do
  begin
    AR := Items[I];
    if (AR.ModuleId = ModuleId) and (AR.Name = Name) then
    begin
      Result := AR;
      Exit;
    end;
  end;
  Result := nil;
end;

function TKisARList.GetItems(Index: Integer): TKisAccessRight;
begin
  Result := inherited Items[Index] as TKisAccessRight;
end;

function TKisARList.GetRight(ModuleId: Integer; const Name: String): Boolean;
var
  AR: TKisAccessRight;
begin
  AR := Find(ModuleId, Name);
  Result := Assigned(AR) and AR.Value;
end;

procedure TKisARList.SetItems(Index: Integer; const Value: TKisAccessRight);
begin
  inherited Items[Index] := Value;
end;

end.
