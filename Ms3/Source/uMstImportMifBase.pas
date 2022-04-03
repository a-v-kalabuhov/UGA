unit uMstImportMifBase;

interface

uses
  SysUtils, Classes, Contnrs;

type
  TLineSplitter = record
  private
    procedure AddPart(Target: TStrings; const aPart: string);
  public
    Line: string;
    Separator: string;
    AllowEmptyStrings: Boolean;
    procedure Split(Target: TStrings); overload;
    function Split(aLine: string; aSep: string = ' '): TStrings; overload;
    procedure Split(Target: TStrings; aLine: string; aSep: string = ' '); overload;
  end;

  TParamHandler = record
    Value: string;
    procedure RemoveDelimiters(); overload;
    function RemoveDelimiters(const aValue: string): string; overload;
  end;

  TMIDColumn = class
  public
    FName: string;
    FDataType: string;
  public
    function StringLength: Integer;
  end;

  TMIFInfo = class
  private
    function GetColumns(Index: Integer): TMIDColumn;
  public
    FRecordCount: integer;
    FProjectionType: String;
    FProjectionUnit: String;
    FProjectionParam: Array[0..3] Of String;
    FBounds: record X1, Y1, X2, Y2: Double; end;
    FVersion: Integer;
    FCharset: string;
    FDelimiter: Char;
    FColumns: TObjectList;
  public
    constructor Create;
    destructor Destroy(); override;
    //
    function ColumnCount: Integer;
    property Columns[Index: Integer]: TMIDColumn read GetColumns;
  end;

implementation

{ TLineSplitter }

procedure TLineSplitter.Split(Target: TStrings);
var
  I: Integer;
  L: Integer;
  LSep: Integer;
  S: string;
  QuoteOpen: Boolean;
  Part: string;
begin
  Target.Clear();
  if Line = '' then
    Exit;
  QuoteOpen := False;
  L := Length(Line);
  LSep := Length(Separator);
  I := 1;
  Part := '';
  while I <= L - LSep + 1 do
  begin
    if QuoteOpen then
    begin
      if (Line[I] = '"') then // закрываем кавычки
      begin
        QuoteOpen := False;
        Inc(I);
      end
      else
      begin
        Part := Part + Line[I];
        Inc(I);
      end;
    end
    else
    if (Line[I] = '"') then // открываем кавычки
    begin
      if Part = '' then
      begin
        QuoteOpen := True;
        Inc(I);
      end
      else
      begin
        Part := Part + Line[I];
        Inc(I);
      end;
    end
    else
    begin
      S := Copy(Line, I, LSep);
      if (S = Separator) and not QuoteOpen then
      begin
        AddPart(Target, Part);
        Part := '';
        I := I + LSep;
      end
      else
      begin
        Part := Part + Line[I];
        Inc(I);
      end;
    end;
  end;
  if Part <> '' then
  begin
    AddPart(Target, Part);
  end;
end;

function TLineSplitter.Split(aLine, aSep: string): TStrings;
begin
  Result := TStringList.Create;
  Line := aLine;
  Separator := aSep;
  Split(Result);
end;

procedure TLineSplitter.AddPart(Target: TStrings; const aPart: string);
begin
  if AllowEmptyStrings or (aPart <> '') then
    Target.Add(aPart);
end;

procedure TLineSplitter.Split(Target: TStrings; aLine, aSep: string);
begin
  Line := aLine;
  Separator := aSep;
  Split(Target);
end;

{ TParamHandler }

procedure TParamHandler.RemoveDelimiters;
var
  I: Integer;
  S: string;
begin
  S := '';
  if Trim(Value) = '' then
    Exit;
  for I := 1 to Length(Value) do
    if not (Value[I] in ['"', ',', '(', ')']) then
      S := S + Value[I];
  Value := S;
end;

function TParamHandler.RemoveDelimiters(const aValue: string): string;
begin
  Value := aValue;
  RemoveDelimiters();
  Result := Value;
end;

{ TMIDColumn }

function TMIDColumn.StringLength: Integer;
var
  S: string;
  Param: TParamHandler;
begin
  Result := -1;
  if Pos('Char', FDataType) = 1 then
  begin
    S := Copy(FDataType, 5, Length(FDataType) - 4);
    S := Param.RemoveDelimiters(S);
    if not TryStrToInt(S, Result) then
      Result := -1;
  end;
end;

{ TMIFInfo }

function TMIFInfo.ColumnCount: Integer;
begin
  Result := FColumns.Count;
end;

constructor TMIFInfo.Create;
begin
  FColumns := TObjectList.Create;
end;

destructor TMIFInfo.Destroy;
begin
  FColumns.Free;
  inherited;
end;

function TMIFInfo.GetColumns(Index: Integer): TMIDColumn;
begin
  Result := TMIDColumn(FColumns[Index]);
end;

end.
