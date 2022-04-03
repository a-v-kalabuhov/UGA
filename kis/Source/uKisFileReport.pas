unit uKisFileReport;

interface

uses
  Contnrs, Classes;

type
  TFileState = class
  private
    FFileName: string;
    FResult: Boolean;
    FText: string;
    FDebugInfo: string;
  public
    function AsString(AddDebugInfo: Boolean): String;
    property FileName: String read FFileName write FFileName;
    /// <summary>
    /// True - хорошо,
    /// False - ошибка.
    /// </summary>
    property Status: Boolean read FResult write FResult;
    /// <summary>
    /// Описание ошибки.
    /// </summary>
    property Text: String read FText write FText;
    /// <summary>
    /// Дополнительная информация.
    /// </summary>
    property DebugInfo: string read FDebugInfo write FDebugInfo;
  end;

  TImageCompareState = class(TFileState)
  private
    FEquals: Boolean;
    FCompareImage: string;
    FStrength: Integer;
    FExistingImage: string;
    FArea: Integer;
    FOldMD5: string;
    FNewMD5: string;
  public
    property Area: Integer read FArea write FArea;
    property CompareImage: string read FCompareImage write FCompareImage;
    property Equals: Boolean read FEquals write FEquals;
    property ExistingImage: string read FExistingImage write FExistingImage;
    property Strength: Integer read FStrength write FStrength;
    property OldMD5: string read FOldMD5 write FOldMD5;
    property NewMD5: string read FNewMD5 write FNewMD5;
  end;

  TFileReport = class(TObjectList)
  private
    FStrings: TStringList;
    function GetItems(Index: Integer): TFileState;
  public
    function AsStrings(AddDebugInfo: Boolean): TStringList;
    function ContainsError: Boolean;
    property Items[Index: Integer]: TFileState read GetItems; default;
  end;

implementation

uses
  StrUtils;

{ TFileReport }

function TFileReport.AsStrings(AddDebugInfo: Boolean): TStringList;
var
  I: Integer;
begin
  if not Assigned(FStrings) then
    FStrings := TStringList.Create;
  FStrings.Clear;
  for I := 0 to Count - 1 do
    FStrings.Add(Items[I].AsString(AddDebugInfo));
  Result := FStrings;
end;

function TFileReport.ContainsError: Boolean;
var
  I: Integer;
begin
  Result := False;
  for I := 0 to Count - 1 do
    if not Items[I].Status then
    begin
      Result := True;
      Exit;
    end;
end;

function TFileReport.GetItems(Index: Integer): TFileState;
begin
  Result := inherited Items[Index] as TFileState;
end;

{ TFileState }

function TFileState.AsString(AddDebugInfo: Boolean): String;
begin
  Result := IfThen(Status, 'Успех', 'Ошибка') + sLineBreak +
    FileName + sLineBreak + Text +
    IfThen(AddDebugInfo, sLineBreak + DebugInfo, '');
end;

end.
