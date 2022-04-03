unit uKisOrgs;

interface

{$I KisFlags.pas}

uses
  // System
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  uKisClasses, DB, ImgList, ActnList, IBDatabase,
  // Common
  uDataSet, uKisSQLClasses;

type
  TKisOrgMngr = class(TKisMngr)
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

  TKisOrg = class(TKisEntity)
  private
    procedure SetName(const Value: String);
    procedure SetShortName(const Value: String);
    function GetName: String;
    function GetShortName: String;
  protected
    function GetText: String; override;
    {$IFDEF ENTPARAMS}
    procedure InitParams; override;
    {$ENDIF}
  public
    class function EntityName: String; override;
    procedure Load(DataSet: TDataSet); override;
    property Name: String read GetName write SetName;
    property ShortName: String read GetShortName write SetShortName;
  end;

  TOrgController = class(TKisEntityController)
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
  SQ_GET_ORGS = 'SELECT * FROM ORGS ORDER BY ID';

function TKisOrgMngr.CreateEntity(EntityKind: TKisEntities): TKisEntity;
begin
  if EntityKind in [keDefault, keOrg] then
    Result := TKisOrg.Create(Self)
  else
    Result := nil;
end;

function TKisOrgMngr.CreateNewEntity(EntityKind: TKisEntities): TKisEntity;
begin
  Result := nil;
end;

procedure TKisOrgMngr.DataModuleCreate(Sender: TObject);
var
  Tmp: TKisEntity;
  DS: TIBQuery;
begin
  inherited;
  FDataSet := TCustomDataSet.Create(Self);
  FCtrlr := TOrgController.Create(Self);
  FDataSet.Controller := FCtrlr;
  FDataSet.Open;
  DS := TIBQuery.Create(nil);
  DS.Forget;
  DS.BufferChunks := 10;
  with DS do
  try
    Transaction := AppModule.Pool.Get;
    Transaction.Init(ilReadCommited, amReadOnly);
    Transaction.StartTransaction;
    SQL.Text := SQ_GET_ORGS;
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

function TKisOrgMngr.GetDataSet: TDataSet;
begin
  Result := FDataSet;
end;

function TKisOrgMngr.GetEntity(EntityID: Integer; EntityKind: TKisEntities): TKisEntity;
var
  I: Integer;
begin
  for I := 1 to DataSet.RecordCount do
    if FCtrlr.Elements[I].ID = EntityID then
    begin
//      Result := Self.CreateEntity();
//      Result.Assign(FCtrlr.Elements[I]);
      Result := FCtrlr.Elements[I];
      Exit;
    end;
  Result := nil;
end;

function TKisOrgMngr.GetIdent: TKisMngrs;
begin
  Result := kmOrgs;
end;

{ TKisOrg }

function TKisOrg.GetText: String;
begin
  Result := ShortName;
end;

procedure TKisOrg.Load(DataSet: TDataSet);
begin
  ID := DataSet.FieldByName(SF_ID).AsInteger;
  Name := DataSet.FieldByName(SF_NAME).AsString;
  ShortName := DataSet.FieldByName('SHORTNAME').AsString;
  Modified := True;
end;

procedure TKisOrg.SetName(const Value: String);
begin
  if Name <> Value then
  begin
    DataParams[SF_NAME].Value := Value;
    Modified := True;
  end;
end;

procedure TKisOrg.SetShortName(const Value: String);
begin
  if ShortName <> Value then
  begin
    DataParams[SF_SHORT_NAME].Value := Value;
    Modified := True;
  end;
end;

{$IFDEF ENTPARAMS}
procedure TKisOrg.InitParams;
begin
  AddParam(SF_NAME);
  AddParam(SF_SHORT_NAME);
end;
{$ENDIF}

{ TOfficeController }

procedure TOrgController.FillFieldDefs(FieldDefsRef: TFieldDefs);
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
    DataType := ftString;
    FieldNo := 2;
    Name := SF_NAME;
    Size := 50;
  end;
  with FieldDefsRef.AddFieldDef do
  begin
    DataType := ftString;
    FieldNo := 3;
    Name := SF_SHORT_NAME;
    Size := 25;
  end;
end;

function TOrgController.GetFieldData(Index: Integer; Field: TField;
  out Data): Boolean;
begin
  try
    with Elements[Index] as TKisOrg do
    case Field.FieldNo of
    1 :
      begin
        GetInteger(ID, Data);
      end;
    2 :
      begin
        GetString(Name, Data);
      end;
    3 :
      begin
        GetString(ShortName, Data);
      end;
    else
      raise EDatabaseError.CreateFmt(S_FIELD_NOT_FOUND, [Field.FieldName]);
    end;
    Result := True;
  except
    Result:= False;
  end;
end;

procedure TOrgController.SetFieldData(Index: integer; Field: TField;
  var Data);
begin
  try
    with TKisOrg(Elements[Index]) do
    case Field.FieldNo of
    1 : ID := SetInteger(Data);
    2 : Name := StrPas(@Data);
    3 : Shortname := StrPas(@Data);
    end;
  except
    Exit;
  end;
end;

function TKisOrg.GetName: String;
begin
  Result := DataParams[SF_NAME].AsString;
end;

function TKisOrg.GetShortName: String;
begin
  Result := DataParams[SF_SHORT_NAME].AsString;
end;

class function TKisOrg.EntityName: String;
begin
  Result := SEN_ORG;
end;

function TKisOrgMngr.IsEntityInUse(Entity: TKisEntity): Boolean;
begin
  Result := True; // Нельзя удалять организации!!!
end;

end.
