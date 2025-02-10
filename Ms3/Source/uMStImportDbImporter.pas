unit uMStImportDbImporter;

interface

uses
  Classes, DB,
  //
  uCommonClasses,
  //
  uMStKernelIBX, uMStKernelSemantic, uMStImport, uMStModuleApp, uMStConsts;

type
  TmstDbImporter = class
  private
    FSettings: ImstImportSettings;
    FEntityRecNo: Integer;
    procedure SetEntityRecNo(const Value: Integer);
  private
    FConn: IIBXConnection;
    FLayersId: Integer;
    FObjectId: string;
    FQuery: TDataSet;
    function GenNewId(): Integer;
    function PrepareSQL(Fld: TmstLayerField; IsString: Boolean): string;
    procedure SetLayersId(const Value: Integer);
    procedure SetObjectId(const Value: string);
  public
    constructor Create(Settings: ImstImportSettings);
    destructor Destroy; override;
    //
    procedure Start();
    procedure DoImport(FieldValues: TStrings);
    procedure Stop();
    //
    property EntityRecNo: Integer read FEntityRecNo write SetEntityRecNo;
    property LayersId: Integer read FLayersId write SetLayersId;
    property ObjectId: string read FObjectId write SetObjectId;
  end;

implementation

{ TmstDbImporter }

constructor TmstDbImporter.Create(Settings: ImstImportSettings);
begin
  FSettings := Settings;
end;

destructor TmstDbImporter.Destroy;
begin
  FSettings := nil;
  inherited;
end;

procedure TmstDbImporter.DoImport(FieldValues: TStrings);
var
  FldValue, Sql: string;
  I, NewId: Integer;
  Fld: TmstLayerField;
  TypedVal: Variant;
  IsString: Boolean;
begin
  for I := 0 to FieldValues.Count - 1 do
  begin
    // вытаскиваем значение поля из списка
    FldValue := FieldValues[I];
    // берём по индексу поле из настроек
    if I < FSettings.Fields.Count - 1 then
    begin
      Fld := FSettings.Fields[I];
      // смотрим тип этого поля
      // пытаемся преобразовать значение к нужному типу
      // если не удалось, то считаем строкой
      IsString := not Fld.TryParse(FldValue, TypedVal);
      // формируем запрос
      if not Assigned(FQuery) then
      begin
        Sql := PrepareSQL(Fld, IsString);
        // выполняем запрос
        FQuery := FConn.GetDataSet(Sql);
      end;
      NewId := GenNewId();
      FConn.SetParam(FQuery, 'ID', NewId);
      FConn.SetParam(FQuery, 'LAYERS_ID', FLayersId);
      FConn.SetParam(FQuery, 'OBJECT_ID', FObjectId);
      FConn.SetParam(FQuery, 'FIELD_NAME', Fld.Caption);
      FConn.SetParam(FQuery, 'FIELD_TYPE', Fld.DataTypeName);
      FConn.SetParam(FQuery, 'FIELD_VALUE', TypedVal);
      FConn.ExecDataSet(FQuery);
    end;
  end;
  FConn.Commit();
end;

function TmstDbImporter.GenNewId: Integer;
begin
  Result := FConn.GenNextValue(SG_LAYERS_SEMANTIC);
end;

function TmstDbImporter.PrepareSQL(Fld: TmstLayerField; IsString: Boolean): string;
begin
  Result := 'INSERT INTO LAYERS_SEMANTIC ' +
            '(ID,LAYERS_ID,OBJECT_ID,FIELD_NAME,FIELD_TYPE,FIELD_VALUE) ' +
            'VALUES ' +
            '(:ID,:LAYERS_ID,:OBJECT_ID,:FIELD_NAME,:FIELD_TYPE,:FIELD_VALUE)';
end;

procedure TmstDbImporter.SetEntityRecNo(const Value: Integer);
begin
  FEntityRecNo := Value;
end;

procedure TmstDbImporter.SetLayersId(const Value: Integer);
begin
  FLayersId := Value;
end;

procedure TmstDbImporter.SetObjectId(const Value: string);
begin
  FObjectId := Value;
end;

procedure TmstDbImporter.Start;
var
  aDb: IDb;
begin
  aDb := mstClientAppModule.MapMngr as IDb;
  // запускаем транзакцию
  FConn := aDb.GetConnection(cmReadWrite, dmGeo);
end;

procedure TmstDbImporter.Stop;
begin
  // подтверждаем транзакцию
  FConn := nil;
end;

end.
