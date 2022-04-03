unit uKisSearchClasses;

interface

uses
  SysUtils, DB, Classes, Controls;

type
  TKisTable = class;

  TKisFieldParam = (fpSort, fpSearch, fpQuickSearch, fpFilter);
  TKisFieldParams = set of TKisFieldParam;

  /// <summary>
  ///    ласс - поле в SQL-запросе или таблице Ѕƒ,
  /// которое используетс€ в поиске и дл€ сортировки значений на экране
  /// </summary>
  TKisField = class
  public
    Table: TKisTable; // ссылка на таблицу или другой источник, к которому относитс€ это поле
    DataType: TFieldType; // тип данных
    FieldName: String; // »м€ пол€
    FieldLabel: String; // ћетка дл€ визуального представлени€ пользователю
    DataSize: Integer; // dummy
    Params: TKisFieldParams; // параметры пол€ - можно ли по нему вести поиск и сортировку
    FLookUp: Boolean;
    FLookUpTable: String;
    FLookUpKey: String;
    FLookUpValue: String;
    //
    FIsForeign: Boolean;
    FForeignTableName: String;
    function FullName: String;
    function GetTableName: String;
    class function GetDataSize(AFieldType: TFieldType): Integer;
  end;
  
  /// <summary>
  ///   “аблица или другой истоник данных (view, процедура) в SQL-запросе
  /// </summary>
  TKisTable = class
  private
    FFields: TList;
    FName: String;
    FLabel: String;
    FSelField: String;
    function GetFields(Index: Integer): TKisField;
  protected
    function AddField(const AName, ALabel: String; AFieldType: TFieldType;
      DataSize: Integer; AParams: TKisFieldParams): Integer;
  public
    constructor Create;
    destructor Destroy; override;
    /// <summary>
    ///   ƒобавление BLOB пол€, содержащего текст
    /// </summary>
    function AddBlobField(const AName, ALabel: String;
      Len: Integer; AParams: TKisFieldParams): Integer;
    /// <summary>
    ///   ƒобавление lookup пол€. ≈го значени€ выбираютс€ из списка досупных значений
    /// </summary>
    function AddLookupField(const AName, ALabel, LookUpTable, LookUpKey,
      LookUpValue: String): Integer;
    /// <summary>
    /// ƒобавление пол€ "простого" типа - целого, булевского, даты и т.п.
    /// </summary>
    function AddSimpleField(const AName, ALabel: String;
      AFieldType: TFieldType; AParams: TKisFieldParams): Integer;
    /// <summary>
    ///   добавление пол€ строкового типа
    /// </summary>
    function AddStringField(const AName, ALabel: String;
      Len: Integer; AParams: TKisFieldParams): Integer;
    /// <summary>
    ///   ”даление пол€
    /// </summary>
    procedure Delete(const AName: String);
    /// <summary>
    ///   ¬ставка нового пол€
    /// </summary>
    procedure Insert(Position: Integer; const AName, ALabel: String);
    function FieldCount: Integer;
    function SortFieldCount: Integer;
    function SearchFieldCount: Integer;
    function FieldByName(const FieldName: String): TKisField;
    property Fields[Index: Integer]: TKisField read GetFields;
    property TableName: String read FName write FName;
    property TableLabel: String read FLabel write FLabel;
    property SelectedField: String read FSelField write FSelField;
  end;

  TKisLinkedTable = class(TKisTable)
  private
    FMasterField: TKisField;
    FDetailField: TKisField;
  public
    property MasterField: TKisField read FMasterField write FMasterField;
    property DetailField: TKisField read FDetailField write FDetailField;
  end;

implementation

uses
  uKisConsts;

{ TKisField }

function TKisField.FullName: String;
begin
  Result := FieldName;
  if FIsForeign then
    Result := FForeignTableName + '.' + Result
  else
  if Assigned(Table) then
  begin
    Result := Table.TableName + '.' + Result;
  end; 
end;

class function TKisField.GetDataSize(AFieldType: TFieldType): Integer;
begin
  case AFieldType of
  ftString, ftMemo, ftFmtMemo, ftFixedChar, ftWideString :
    Result := 255;
  ftInteger :
    Result := SizeOf(Integer);
  ftSmallInt :
    Result := SizeOf(SmallInt);
  ftWord :
    Result := SizeOf(Word);
  ftFloat :
    Result := SizeOf(Double);
  ftDate :
    Result := SizeOf(TDate);
  ftDateTime:
    Result := SizeOf(TDateTime);
  ftBoolean :
    Result := SizeOf(Boolean);
  else
    raise EAbort.Create(S_UNSUPPORTED_FIELD_TYPE);
  end;
end;

function TKisField.GetTableName: String;
begin
  if FLookUp then
    Result := FLookUpTable
  else
    Result := Table.TableName;
end;

{ TKisTable }

function TKisTable.AddSimpleField(const AName, ALabel: String;
  AFieldType: TFieldType; AParams: TKisFieldParams): Integer;
begin
  Result := AddField(AName, ALabel, AFieldType, TKisField.GetDataSize(AFieldType), AParams);
end;

function TKisTable.AddField(const AName, ALabel: String;
  AFieldType: TFieldType; DataSize: Integer; AParams: TKisFieldParams): Integer;
var
  TmpF: TKisField;
begin
  TmpF := TKisField.Create;
  Result := FFields.Add(TmpF);
  TmpF.Table := Self;
  TmpF.FieldName := AName;
  TmpF.FieldLabel := ALabel;
  TmpF.DataType := AFieldType;
  TmpF.DataSize := DataSize;
  TmpF.Params := AParams;
end;

function TKisTable.AddLookupField(const AName, ALabel, LookUpTable, LookUpKey,
  LookUpValue: String): Integer;
begin
  Result := AddField(AName, ALabel, ftInteger, 0, [fpSearch]);
  with Fields[Result] do
  begin
    FLookUp := True;
    FLookUpTable := LookUpTable;
    FLookUpKey := LookUpKey;
    FLookUpValue := LookUpValue;
  end;
end;

function TKisTable.AddStringField(const AName, ALabel: String;
  Len: Integer; AParams: TKisFieldParams): Integer;
begin
  Result := AddField(AName, ALabel, ftString, Len, AParams);
end;

constructor TKisTable.Create;
begin
  FFields := TList.Create;
  FSelField := '';
end;

procedure TKisTable.Delete(const AName: String);
var
  I: Integer;
begin
  for I := 0 to Pred(FFields.Count) do
    if TKisField(FFields[I]).FieldName = AName then
    begin
      TObject(FFields[I]).Free;
      FFields.Delete(I);
      Exit;
    end;
  raise EAbort.CreateFmt(S_FIELD_NOT_FOUND, [AName, Self.FLabel]);
end;

destructor TKisTable.Destroy;
begin
  FFields.Free;
  inherited;
end;

function TKisTable.FieldCount: Integer;
begin
  Result := FFields.Count;
end;

function TKisTable.GetFields(Index: Integer): TKisField;
begin
  Result := FFields[Index];// as TKisField;
end;

procedure TKisTable.Insert(Position: Integer; const AName, ALabel: String);
var
  TmpF: TKisField;
begin
  TmpF := TKisField.Create;
  TmpF.Table := Self;
  TmpF.FieldName := AName;
  TmpF.FieldLabel := ALabel;
  try
    FFields.Insert(Position, TmpF);
  except
    TmpF.Free;
    raise;
  end;
end;

function TKisTable.AddBlobField(const AName, ALabel: String; Len: Integer;
  AParams: TKisFieldParams): Integer;
begin
  Result := AddField(AName, ALabel, ftBlob, Len, AParams);
end;

function TKisTable.FieldByName(const FieldName: String): TKisField;
var
  I: Integer;
begin
  Result := nil;
  for I := 0 to Pred(FieldCount) do
  begin
    if Fields[I].FieldName = FieldName then
    begin
      Result := Fields[I];
      Exit;
    end;
  end
end;

function TKisTable.SortFieldCount: Integer;
var
  I: Integer;
begin
  Result := 0;
  for I := 0 to Pred(FFields.Count) do
  if fpSort in Fields[I].Params then
    Inc(Result);
end;

function TKisTable.SearchFieldCount: Integer;
var
  I: Integer;
begin
  Result := 0;
  for I := 0 to Pred(FFields.Count) do
  if fpSearch in Fields[I].Params then
    Inc(Result);
end;

end.
