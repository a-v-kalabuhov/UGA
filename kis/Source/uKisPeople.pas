unit uKisPeople;

interface

uses
  // System
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms, DB,
  //Common
  uDataSet,
  // Project
  uKisClasses;

type
  TKisPeopleMngr = class(TKisMngr)
    procedure DataModuleCreate(Sender: TObject);
  private
    FCtrlr: TKisEntityController;
    FDataSet: TCustomDataSet;
    function GetDataSet: TDataSet;
  protected
    function GetIdent: TKisMngrs; override;
  public
    function GetEntity(EntityID: Integer; EntityKind: TKisEntities = keDefault): TKisEntity; override;
    function CreateEntity(EntityKind: TKisEntities = keDefault): TKisEntity; override;
    function CreateNewEntity(EntityKind: TKisEntities = keDefault): TKisEntity; override;
    function IsEntityInUse(Entity: TKisEntity): Boolean; override;
    property DataSet: TDataSet read GetDataSet;
  end;

  TKisWorker = class(TKisEntity)
  private
    FOfficeLink: TKisEntity;
    function GetFirstName: String;
    function GetFullName: String;
    function GetInitialName: String;
    procedure SetFirstName(const Value: String);
    function GetMiddleName: String;
    procedure SetMiddleName(const Value: String);
    function GetOfficesId: Integer;
    procedure SetOfficesId(const Value: Integer);
    function GetLastName: String;
    procedure SetLastName(const Value: String);
    procedure SetFullName(const Value: String);
    procedure SetInitialName(const Value: String);
    function GetCategoryName: String;
    procedure SetCategoryName(const Value: String);
    function GetTypeId: Integer;
    procedure SetTypeId(const Value: Integer);
    function getOrgsId: Integer;
    procedure SetOrgsId(const Value: Integer);
  protected
    function GetText: String; override;
    procedure InitParams; override;
  public
//    procedure Copy(Source: TKisEntity); override;
    class function EntityName: String; override;
    procedure Load(DataSet: TDataSet); override;
    property FullName: String read GetFullName write SetFullName;
    property InitialName: String read GetInitialName write SetInitialName;
    property FirstName: String read GetFirstName write SetFirstName;
    property MiddleName: String read GetMiddleName write SetMiddleName;
    property LastName: String read GetLastName write SetLastName;
    property Category: String read GetCategoryName write SetCategoryName;
    property OfficesId: Integer read GetOfficesId write SetOfficesId;
    property PeopleTypesId: Integer read GetTypeId write SetTypeId;
    property OrgsId: Integer read getOrgsId write SetOrgsId;
  end;

  TPeopleController = class(TKisEntityController)
  public
    procedure FillFieldDefs(FieldDefsRef: TFieldDefs); override;
    function GetFieldData(Index: Integer; Field: TField; out Data): Boolean; override;
    procedure SetFieldData(Index:integer; Field: TField; var Data); override;
  end;

implementation

{$R *.dfm}

uses
  // System
  IBQuery,
  // Common
  uGC, uIBXUtils,
  // Project
  uKisAppModule, uKisConsts, uKisIntf;

const
  SQ_GET_PEOPLE = 'SELECT * FROM PEOPLE ORDER BY ID';

{ TKisPeopleMngr }

function TKisPeopleMngr.CreateEntity(EntityKind: TKisEntities): TKisEntity;
begin
  case EntityKind of
  keDefault, keWorker :
    Result := TKisWorker.Create(Self);
  else
    Result := nil;
  end;
end;

function TKisPeopleMngr.CreateNewEntity(EntityKind: TKisEntities): TKisEntity;
begin
  Result := nil;
end;

procedure TKisPeopleMngr.DataModuleCreate(Sender: TObject);
var
  Tmp: TKisEntity;
  DS: TIBQuery;
begin
  inherited;
  FDataSet := TCustomDataSet.Create(Self);
  FCtrlr := TPeopleController.Create(Self);
  FDataSet.Controller := FCtrlr;
  FDataSet.Open;
  DS := TIBQuery.Create(nil);
  DS.Forget;
  with DS do
  try
    BufferChunks := 100;
    Transaction := AppModule.Pool.Get;
    Transaction.Init(ilReadCommited, amReadOnly);
    Transaction.StartTransaction;
    SQL.Text := SQ_GET_PEOPLE;
    Open;
    FetchAll;
    while not Eof do
    begin
      Tmp := Self.CreateEntity;
      Tmp.Load(DS);
      FCtrlr.DirectAppend(Tmp);
      Next;
    end;
    Close;
  finally
    Transaction.Commit;
    AppModule.Pool.Back(Transaction);
  end;
end;

function TKisPeopleMngr.GetDataSet: TDataSet;
begin
  Result := FDataSet;
end;

function TKisPeopleMngr.GetEntity(EntityID: Integer;
  EntityKind: TKisEntities): TKisEntity;
var
  I: Integer;
begin
  for I := 1 to DataSet.RecordCount do
    if FCtrlr.Elements[I].ID = EntityID then
    begin
      Result := FCtrlr.Elements[I];
      Exit;
    end;
  Result := nil;
end;

function TKisPeopleMngr.GetIdent: TKisMngrs;
begin
  Result := kmPeople;
end;

function TKisPeopleMngr.IsEntityInUse(Entity: TKisEntity): Boolean;
begin
  Result := True;
end;

{ TKisWorker }

function TKisWorker.getFirstName: String;
begin
  Result := DataParams[SF_FIRST_NAME].AsString;
end;

function TKisWorker.GetFullName: String;
begin

end;

function TKisWorker.GetLastName: String;
begin
  Result := DataParams[SF_LAST_NAME].AsString;
end;

function TKisWorker.getMiddleName: String;
begin
  Result := DataParams[SF_MIDDLE_NAME].AsString;
end;

function TKisWorker.GetOfficesId: Integer;
begin
  if Assigned(FOfficeLink) then
    Result := FOfficeLink.ID
  else
    Result := 0;
end;

function TKisWorker.GetInitialName: String;
begin
  Result := DataParams[SF_INITIAL_NAME].AsString;
end;

function TKisWorker.GetText: String;
begin

end;

procedure TKisWorker.InitParams;
begin
  AddParam(SF_FIRST_NAME);
  AddParam(SF_MIDDLE_NAME);
  AddParam(SF_LAST_NAME);
  AddParam(SF_POST);
  AddParam(SF_CATEGORY);
  AddParam(SF_PEOPLE_TYPES_ID);
  AddParam(SF_INITIAL_NAME);
  AddParam(SF_FULL_NAME);
end;

procedure TKisWorker.Load(DataSet: TDataSet);
begin
  with DataSet do
  begin
    Self.ID := FieldByName(SF_ID).AsInteger;
    Self.FirstName := FieldByName(SF_FIRST_NAME).AsString;
    Self.MiddleName := FieldByName(SF_MIDDLE_NAME).AsString;
    Self.LastName := FieldByName(SF_LAST_NAME).AsString;
    Self.FullName := FieldByName(SF_FULL_NAME).AsString;
    Self.InitialName := FieldByName(SF_INITIAL_NAME).AsString;
    Self.Category := FieldByName(SF_CATEGORY).AsString;
    Self.OfficesId := FieldByName(SF_OFFICES_ID).AsInteger;
  end;
end;

procedure TKisWorker.SetFirstName(const Value: String);
begin
  DataParams[SF_FIRST_NAME].Value := Value;
end;

procedure TKisWorker.SetLastName(const Value: String);
begin
  DataParams[SF_LAST_NAME].Value := Value;
end;

procedure TKisWorker.SetMiddleName(const Value: String);
begin
  DataParams[SF_MIDDLE_NAME].Value := Value;
end;

procedure TKisWorker.SetOfficesId(const Value: Integer);
begin
  if OfficesId <> Value then
  begin
    if Assigned(FOfficeLink) then
      FOfficeLink.Free;
    FOfficeLink := AppModule.Mngrs[kmOffices].GetEntity(Value);
  end;
end;

procedure TKisWorker.SetFullName(const Value: String);
begin
  DataParams[SF_FULL_NAME].Value := Value;
end;

procedure TKisWorker.SetInitialName(const Value: String);
begin
  DataParams[SF_INITIAL_NAME].Value := Value;
end;

function TKisWorker.GetCategoryName: String;
begin
  Result := DataParams[SF_CATEGORY].AsString;
end;

procedure TKisWorker.SetCategoryName(const Value: String);
begin
  DataParams[SF_CATEGORY].Value := Value;
end;

function TKisWorker.GetTypeId: Integer;
begin
  Result := DataParams[SF_PEOPLE_TYPES_ID].AsInteger;
end;

procedure TKisWorker.SetTypeId(const Value: Integer);
begin
  DataParams[SF_PEOPLE_TYPES_ID].Value := Value;
end;

function TKisWorker.getOrgsId: Integer;
begin
  Result := DataParams[SF_ORGS_ID].AsInteger;
end;

procedure TKisWorker.SetOrgsId(const Value: Integer);
begin
  DataParams[SF_ORGS_ID].Value := Value;
end;

class function TKisWorker.EntityName: String;
begin
  Result := SEN_WORKER;
end;

{ TPeopleController }

procedure TPeopleController.FillFieldDefs(FieldDefsRef: TFieldDefs);
begin
{ ID
  FIRST_NAME
  MIDDLE_NAME
  LAST_NAME
  POST
  OFFICES_ID
  USER_NAME
  ROLE_NAME
  INSERT_NAME
  INSERT_TIME
  UPDATE_NAME
  UPDATE_TIME
  DOC_ORDER
  CATEGORY
  ENABLED
  FULL_NAME
  INITIAL_NAME
  PEOPLE_TYPES_ID
  ORGS_ID }
  FieldDefsRef.Clear;
  with FieldDefsRef.AddFieldDef do
  begin
    DataType := ftInteger;
    FieldNo := 1;
    Name := SF_ID;
  end;
  with FieldDefsRef.AddFieldDef do
  begin
    DataType := ftString;
    FieldNo := 2;
    Name := SF_FIRST_NAME;
    Size := 25;
  end;
  with FieldDefsRef.AddFieldDef do
  begin
    DataType := ftString;
    FieldNo := 3;
    Name := SF_MIDDLE_NAME;
    Size := 25;
  end;
  with FieldDefsRef.AddFieldDef do
  begin
    DataType := ftString;
    FieldNo := 4;
    Name := SF_LAST_NAME;
    Size := 25;
  end;
  with FieldDefsRef.AddFieldDef do
  begin
    DataType := ftInteger;
    FieldNo := 5;
    Name := SF_OFFICES_ID;
  end;
  with FieldDefsRef.AddFieldDef do
  begin
    DataType := ftString;
    FieldNo := 6;
    Name := SF_CATEGORY;
    Size := 50;
  end;
  with FieldDefsRef.AddFieldDef do
  begin
    DataType := ftString;
    FieldNo := 7;
    Name := SF_FULL_NAME;
    Size := 77;
  end;
  with FieldDefsRef.AddFieldDef do
  begin
    DataType := ftString;
    FieldNo := 8;
    Name := SF_INITIAL_NAME;
    Size := 50;
  end;
  with FieldDefsRef.AddFieldDef do
  begin
    DataType := ftInteger;
    FieldNo := 9;
    Name := SF_PEOPLE_TYPES_ID;
  end;
  with FieldDefsRef.AddFieldDef do
  begin
    DataType := ftInteger;
    FieldNo := 10;
    Name := SF_ORGS_ID;
  end;
end;

function TPeopleController.GetFieldData(Index: Integer; Field: TField;
  out Data): Boolean;
begin
  try
    with Elements[Index] as TKisWorker do
    case Field.FieldNo of
      1 :
        begin
          GetInteger(ID, Data);
        end;
      2 :
        begin
          GetString(FirstName, Data);
        end;
      3 :
        begin
          GetString(MiddleName, Data);
        end;
      4 :
        begin
          GetString(LastName, Data);
        end;
      5 :
        begin
          GetInteger(OfficesId, Data);
        end;
      6 :
        begin
          GetString(Category, Data);
        end;
      7 :
        begin
          GetString(FullName, Data);
        end;
      8 :
        begin
          GetString(InitialName, Data);
        end;
      9 :
        begin
          GetInteger(PeopleTypesId, Data);
        end;
      10 :
        begin
          GetInteger(OrgsId, Data);
        end;
      else
        raise EDatabaseError.CreateFmt(S_FIELD_NOT_FOUND, [Field.FieldName]);
    end;
    Result := True;
  except
    Result := False;
  end;
end;

procedure TPeopleController.SetFieldData(Index: integer; Field: TField;
  var Data);
begin
  inherited;

end;

end.
