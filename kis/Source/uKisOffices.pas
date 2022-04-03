unit uKisOffices;

interface

{$I KisFlags.pas}

uses
  // System
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  DB, ImgList, ActnList, IBDatabase,
  // Common
  uDataSet,
  // Project
  uKisClasses, uKisSQLClasses;

type
  TKisOfficeMngr = class(TKisMngr)
    procedure DataModuleCreate(Sender: TObject);
  private
    FCtrlr: TKisEntityController;
    FDataSet: TCustomDataSet;
    function GetDataSet: TDataSet;
  protected
    function GetIdent: TKisMngrs; override;
    function GetRefreshSQLText: String;
    function GetMainDataSet: TDataSet; 
  public
    function GetEntity(EntityID: Integer; EntityKind: TKisEntities = keDefault): TKisEntity; override;
    function CreateEntity(EntityKind: TKisEntities = keDefault): TKisEntity; override;
    function CreateNewEntity(EntityKind: TKisEntities = keDefault): TKisEntity; override;
    function IsEntityInUse(Entity: TKisEntity): Boolean; override;
    property DataSet: TDataSet read GetDataSet;
  end;

  TKisOffice = class(TKisEntity)
  private
    FOrgLink: TKisEntity;
    procedure SetName(const Value: String);
    procedure SetPhones(const Value: String);
    procedure SetShortName(const Value: String);
    procedure SetDirector(const Value: String);
    function GetShortName: String;
    function GetName: String;
    function GetPhones: String;
    function GetDirector: String;
    function GetOrgId: Integer;
    procedure SetOrgId(const Value: Integer);
  protected
    {$IFDEF ENTPARAMS}
    procedure InitParams; override;
    {$ENDIF}
  public
    class function EntityName: String; override;
    procedure Load(DataSet: TDataSet); override;
    property Name: String read GetName write SetName;
    property ShortName: String read GetShortName write SetShortName;
    property Phones: String read GetPhones write SetPhones;
    property Director: String read GetDirector write SetDirector;
    property OrgId: Integer read GetOrgId write SetOrgId;
  end;

  TOfficeController = class(TKisEntityController)
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
  SQ_GET_OFFICES = 'SELECT * FROM OFFICES';

{ TKisOfficeMngr }

function TKisOfficeMngr.GetDataSet: TDataSet;
begin
  Result := FDataSet;
end;

procedure TKisOfficeMngr.DataModuleCreate(Sender: TObject);
var
  Tmp: TKisEntity;
  DS: TIBQuery;
begin
  inherited;
  FDataSet := TCustomDataSet.Create(Self);
  FCtrlr := TOfficeController.Create(Self);
  FDataSet.Controller := FCtrlr;
  FDataSet.Open;
  DS := TIBQuery.Create(nil);
  DS.Forget;
  DS.BufferChunks := 100;
  with DS do
  try
    Transaction := AppModule.Pool.Get;
    Transaction.Init(ilReadCommited, amReadOnly);
    Transaction.StartTransaction;
    SQL.Text := SQ_GET_OFFICES;
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

function TKisOfficeMngr.GetEntity(EntityID: Integer;
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

function TKisOfficeMngr.CreateEntity(EntityKind: TKisEntities): TKisEntity;
begin
  if EntityKind in [keDefault, keOffice] then
    Result := TKisOffice.Create(Self)
  else
    Result := nil;
end;

function TKisOfficeMngr.GetIdent: TKisMngrs;
begin
  Result := kmOffices;
end;

function TKisOfficeMngr.GetMainDataSet: TDataSet;
begin
  Result := nil;
end;

function TKisOfficeMngr.GetRefreshSQLText: String;
begin
  Result := '';
end;

function TKisOfficeMngr.CreateNewEntity(
  EntityKind: TKisEntities): TKisEntity;
begin
  Result := nil;
end;

function TKisOfficeMngr.IsEntityInUse(Entity: TKisEntity): Boolean;
begin
  Result := True;
end;

{ TKisOffice }

class function TKisOffice.EntityName: String;
begin
  Result := SEN_OFFICE;
end;

function TKisOffice.GetDirector: String;
begin
  Result := DataParams[SF_DIRECTOR].AsString;
end;

function TKisOffice.GetName: String;
begin
  Result := DataParams[SF_NAME].AsString;
end;

function TKisOffice.GetOrgId: Integer;
begin
  if Assigned(FOrgLink) then
    Result := FOrgLink.ID
  else
    Result := 0;
end;

function TKisOffice.getPhones: String;
begin
  Result := DataParams[SF_PHONES].AsString;
end;

function TKisOffice.GetShortName: String;
begin
  Result := DataParams[SF_SHORT_NAME].AsString;
end;

{$IFDEF ENTPARAMS}
procedure TKisOffice.InitParams;
begin
  inherited;
  AddParam(SF_NAME);
  AddParam(SF_SHORT_NAME);
  AddParam(SF_PHONES);
  AddParam(SF_DIRECTOR);
  AddParam(SF_ORGS_ID);
  DataParams[SF_ORGS_ID].Value := 0;
end;
{$ENDIF}

procedure TKisOffice.Load(DataSet: TDataSet);
begin
  with DataSet do
  begin
    Self.ID := FieldByName(SF_ID).AsInteger;
    Self.Name := FieldByName(SF_NAME).AsString;
    Self.ShortName := FieldByName(SF_SHORT_NAME).AsString;
    Self.Phones := FieldByName(SF_PHONES).AsString;
    Self.Director := FieldByName(SF_DIRECTOR).AsString;
    Self.OrgId := FieldbyName(SF_ORGS_ID).AsInteger;
  end;
end;

procedure TKisOffice.SetDirector(const Value: String);
begin
  if Director <> Value then
  begin
    DataParams[SF_DIRECTOR].Value := Value;
    Modified := True;
  end;
end;

procedure TKisOffice.SetName(const Value: String);
begin
  if Name <> Value then
  begin
    DataParams[SF_NAME].Value := Value;
    Modified := True;
  end;
end;

procedure TKisOffice.SetOrgId(const Value: Integer);
begin
  if OrgId <> Value then
  begin
    FOrgLink := AppModule.Mngrs[kmOrgs].GetEntity(Value);
    DataParams[SF_ORGS_ID].Value := Value;
  end;
end;

procedure TKisOffice.SetPhones(const Value: String);
begin
  if Phones <> Value then
  begin
    DataParams[SF_PHONES].Value := Value;
    Modified := True;
  end;
end;

procedure TKisOffice.SetShortName(const Value: String);
begin
  if ShortName <> Value then
  begin
    DataParams[SF_SHORT_NAME].Value := Value;
    Modified := True;
  end;
end;

{ TOfficeController }

procedure TOfficeController.FillFieldDefs(FieldDefsRef: TFieldDefs);
begin
  FieldDefsRef.Clear;
  with FieldDefsRef.AddFieldDef do
  begin
    DataType := ftInteger;
    FieldNo := 1;
    Name := SF_ID;
  end;
  with FieldDefsRef.AddFieldDef do
  begin
    DataType := ftInteger;
    FieldNo := 2;
    Name := SF_ORGS_ID;
  end;
  with FieldDefsRef.AddFieldDef do
  begin
    DataType := ftString;
    FieldNo := 3;
    Name := SF_NAME;
    Size := 80;
  end;
  with FieldDefsRef.AddFieldDef do
  begin
    DataType := ftString;
    FieldNo := 4;
    Name := SF_SHORT_NAME;
    Size := 10;
  end;
  with FieldDefsRef.AddFieldDef do
  begin
    DataType := ftString;
    FieldNo := 5;
    Name := SF_PHONES;
    Size := 30;
  end;
  with FieldDefsRef.AddFieldDef do
  begin
    DataType := ftString;
    FieldNo := 6;
    Name := SF_DIRECTOR;
    Size := 50;
  end;
end;

function TOfficeController.GetFieldData(Index: Integer; Field: TField;
  out Data): Boolean;
begin
  try
    with Elements[Index] as TKisOffice do
    case Field.FieldNo of
      1 :
        begin
          GetInteger(ID, Data);
        end;
      2 :
        begin
          GetInteger(HeadId, Data);
        end;
      3 :
        begin
          GetString(Name, Data);
        end;
      4 :
        begin
          GetString(ShortName, Data);
        end;
      5 :
        begin
          GetString(Phones, Data);
        end;
      6 :
        begin
          GetString(Director, Data);
        end;
      else
        raise EDatabaseError.CreateFmt(S_FIELD_NOT_FOUND, [Field.FieldName]);
    end;
    Result := True;
  except
    Result := False;
  end;
end;

procedure TOfficeController.SetFieldData(Index: integer; Field: TField;
  var Data);
begin
  try
    with TKisOffice(Elements[Index]) do
    case Field.FieldNo of
    1 : ID := SetInteger(Data);
    2 : ;//HeadId := SetInteger(Data);
    3 : Name := StrPas(@Data);
    4 : ShortName := StrPas(@Data);
    5 : Phones := StrPas(@Data);
    6 : Director := StrPas(@Data);
    end;
  except
    Exit;
  end;
end;

end.
