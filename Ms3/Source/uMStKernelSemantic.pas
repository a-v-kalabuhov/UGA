unit uMStKernelSemantic;

interface

uses
  SysUtils, Contnrs, Variants,
  //
  uCommonClasses;

type
  TmstLayerDataType = (mstDataUnknown, mstDataChar, mstDataInteger, mstDataFloat, mstDataLogical);

  TmstLayerField = class
  private
    FLength: Integer;
    FName: string;
    FDataTypeName: string;
    FCaption: string;
    procedure SetDataTypeName(const Value: string);
    procedure SetLength(const Value: Integer);
    procedure SetName(const Value: string);
    procedure SetCaption(const Value: string);
    function GetDataType: TmstLayerDataType;
  public
    function GetFullDataTypeName: string;
    function TryParse(const FldValue: string; out TypedVal: Variant): Boolean;

    property Caption: string read FCaption write SetCaption;
    property Name: string read FName write SetName;
    property DataTypeName: string read FDataTypeName write SetDataTypeName;
    property Length: Integer read FLength write SetLength;
    property DataType: TmstLayerDataType read GetDataType;
  end;

  TmstLayerFields = class
  private
    FList: TObjectList;
    function GetCount: Integer;
    function GetItems(Index: Integer): TmstLayerField;
  public
    constructor Create;
    destructor Destroy; override;
    //
    function AddNew(): TmstLayerField;
    procedure Clear();
    function Find(aFieldname: string): TmstLayerField;
    property Count: Integer read GetCount;
    property Items[Index: Integer]: TmstLayerField read GetItems; default;
  end;

  TmstLayerFieldValue = class
  private
    FFieldName: string;
    FValue: string;
    procedure SetFieldName(const Value: string);
    procedure SetValue(const Value: string);
  public
    property FieldName: string read FFieldName write SetFieldName;
    property Value: string read FValue write SetValue;
  end;

  TmstObjectFieldValues = class
  private
    FList: TObjectList;
    function GetValue(FieldName: string): string;
    procedure SetValue(FieldName: string; const Value: string);
    function GetFieldName(Idx: Integer): string;
    function GetValueByIdx(Idx: Integer): TmstLayerFieldValue;
  public
    constructor Create;
    destructor Destroy; override;
    //
    function Count: Integer;
    property FieldName[Idx: Integer]: string read GetFieldName;
    property Value[FieldName: string]: string read GetValue write SetValue;
    property ValueByIdx[Idx: Integer]: TmstLayerFieldValue read GetValueByIdx;
  end;

implementation

{ TmstLayerField }

function TmstLayerField.GetDataType: TmstLayerDataType;
var
  S: string;
begin
  S := AnsiUpperCase(FDataTypeName);
  if (S = 'INTEGER') or (S = 'SMALLINT') then
    Result := mstDataInteger
  else
  if (S = 'CHAR') then
    Result := mstDataChar
  else
  if (S = 'DECIMAL') or (S = 'FLOAT') then
    Result := mstDataFloat
  else
  if (S = 'LOGICAL') then
    Result := mstDataLogical
  else
    Result := mstDataUnknown;
end;

function TmstLayerField.GetFullDataTypeName: string;
begin
  Result := FDataTypeName;
  if DataType = mstDataChar then  
    if FLength > 0 then
      Result := Result + '(' + IntToStr(FLength) + ')';
end;

procedure TmstLayerField.SetCaption(const Value: string);
begin
  FCaption := Value;
end;

procedure TmstLayerField.SetDataTypeName(const Value: string);
begin
  FDataTypeName := Value;
end;

procedure TmstLayerField.SetLength(const Value: Integer);
begin
  FLength := Value;
end;

procedure TmstLayerField.SetName(const Value: string);
begin
  FName := Value;
end;

function TmstLayerField.TryParse(const FldValue: string; out TypedVal: Variant): Boolean;
begin
  Result := False;
  if FldValue = '' then
  begin
    TypedVal := NULL;
    Exit;
  end;
  try
    case DataType of
      mstDataUnknown:
          begin
            TypedVal := FldValue;
            Result := False;
          end;
      mstDataChar:
          begin
            TypedVal := FldValue;
            Result := True;
          end;
      mstDataInteger:
          begin
            TypedVal := FldValue;
            Result := True;
          end;
      mstDataFloat:
          begin
            TCommonFactory.DecSep.Change('.');
            TypedVal := FldValue;
            Result := True;
          end;
      mstDataLogical:
          begin
            TypedVal := FldValue;
            Result := True;
          end;
    end;
  except
    TypedVal := FldValue;
  end;
end;

{ TmstLayerFields }

function TmstLayerFields.AddNew: TmstLayerField;
begin
  Result := TmstLayerField.Create;
  FList.Add(Result);
end;

procedure TmstLayerFields.Clear;
begin
  FList.Clear;
end;

constructor TmstLayerFields.Create;
begin
  FList := TObjectList.Create;
end;

destructor TmstLayerFields.Destroy;
begin
  FList.Free;
  inherited;
end;

function TmstLayerFields.Find(aFieldName: string): TmstLayerField;
var
  I: Integer;
begin
  for I := 0 to FList.Count - 1 do
    if Items[I].Name = aFieldName then
    begin
      Result := Items[I];
      Exit;
    end;
  Result := nil;
end;

function TmstLayerFields.GetCount: Integer;
begin
  Result := FList.Count;
end;

function TmstLayerFields.GetItems(Index: Integer): TmstLayerField;
begin
  Result := TmstLayerField(FList[Index]);
end;

{ TmstObjectFieldValues }

function TmstObjectFieldValues.Count: Integer;
begin
  Result := FList.Count;
end;

constructor TmstObjectFieldValues.Create;
begin
  FList := TObjectList.Create;
end;

destructor TmstObjectFieldValues.Destroy;
begin
  FList.Free;
  inherited;
end;

function TmstObjectFieldValues.GetFieldName(Idx: Integer): string;
begin
  Result := TmstLayerFieldValue(FList[Idx]).FieldName;
end;

function TmstObjectFieldValues.GetValue(FieldName: string): string;
var
  I: Integer;
  Vl: TmstLayerFieldValue;
begin
  for I := 0 to FList.Count - 1 do
  begin
    Vl := TmstLayerFieldValue(FList[I]);
    if Vl.FieldName = FieldName then
    begin
      Result := Vl.Value;
      Exit;
    end;
  end;
  Result := '';
end;

function TmstObjectFieldValues.GetValueByIdx(Idx: Integer): TmstLayerFieldValue;
begin
  Result := TmstLayerFieldValue(FList[Idx]);
end;

procedure TmstObjectFieldValues.SetValue(FieldName: string; const Value: string);
var
  I: Integer;
  Vl: TmstLayerFieldValue;
begin
  for I := 0 to FList.Count - 1 do
  begin
    Vl := TmstLayerFieldValue(FList[I]);
    if Vl.FieldName = FieldName then
    begin
      Vl.Value := Value;
      Exit;
    end;
  end;
  Vl := TmstLayerFieldValue.Create;
  FList.Add(Vl);
  Vl.FieldName := FieldName;
  Vl.Value := Value;
end;

{ TmstLayerFieldValue }

procedure TmstLayerFieldValue.SetFieldName(const Value: string);
begin
  FFieldName := Value;
end;

procedure TmstLayerFieldValue.SetValue(const Value: string);
begin
  FValue := Value;
end;

end.
