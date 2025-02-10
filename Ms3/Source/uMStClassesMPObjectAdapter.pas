unit uMStClassesMPObjectAdapter;

interface

uses
  Classes, DB, Math,
  EzBase, EzBaseGIS,
  uMStConsts;

type
  TmstMPObjectEzAdapter = class
  private
    FEzDataSet: TDataSet;
    function GetLoaded: Boolean;
    function GetEzData: TStream;
    function GetEzRecno: Integer;
    procedure SetEzRecno(const Value: Integer);
    procedure SetLoaded(const Value: Boolean);
  private
    procedure SaveValue(const FieldName: string; const Value: Variant);
    function GetEzEntityId: TEzEntityID;
    function GetId: Integer;
  public
    constructor Create(EzDataSet: TDataSet);
    //
    function GetEntity: TEzEntity;
    //
    property Id: Integer read GetId;
    property Loaded: Boolean read GetLoaded write SetLoaded;
    property EzEntityId: TEzEntityID read GetEzEntityId;
    property EzData: TStream read GetEzData;
    property EzRecno: Integer read GetEzRecno write SetEzRecno;
  end;

  TmstMPObjectAdapter = class
  private
    FDataSet: TDataSet;
    function GetId: Integer;
    function GetMpClassId: Integer;
    function GetStatus: Integer;
    function GetTableVersion: Integer;
  public
    constructor Create(DataSet: TDataSet);
    //
    property Id: Integer read GetId;
    property MpClassId: Integer read GetMpClassId;
    property Status: Integer read GetStatus;
    property TableVersion: Integer read GetTableVersion;
  end;

implementation

{ TmstMPObjectEzAdapter }

constructor TmstMPObjectEzAdapter.Create(EzDataSet: TDataSet);
begin
  inherited Create;
  FEzDataSet := EzDataSet;
end;

function TmstMPObjectEzAdapter.GetEntity: TEzEntity;
var
  EntClass: TEzEntityClass;
  EntityID: TEzEntityID;
  EzData: TStream;
  EzDataFld: TField;
begin
  EntityID := Self.EzEntityId;
  EntClass := GetClassFromID(EntityID);
  Result := EntClass.Create(0, True);
  EzData := Self.EzData;
  try
    EzData.Position := 0;
    Result.LoadFromStream(EzData);
  finally
    EzData.Free;
  end;
  Result.ExtID := Self.Id;
end;

function TmstMPObjectEzAdapter.GetEzData: TStream;
var
  EzDataFld: TField;
begin
  EzDataFld := FEzDataSet.FieldByName(SF_EZDATA);
  Result := FEzDataSet.CreateBlobStream(EzDataFld, bmRead);
end;

function TmstMPObjectEzAdapter.GetEzEntityId: TEzEntityID;
begin
  Result := TEzEntityID(FEzDataSet.FieldByName(SF_EZ_ID).AsInteger);
end;

function TmstMPObjectEzAdapter.GetEzRecno: Integer;
begin
  Result := FEzDataSet.FieldByName(SF_EZ_RECNO).AsInteger;
end;

function TmstMPObjectEzAdapter.GetId: Integer;
begin
  Result := FEzDataSet.FieldByName(SF_ID).AsInteger;
end;

function TmstMPObjectEzAdapter.GetLoaded: Boolean;
begin
  Result := FEzDataSet.FieldByName(SF_LOADED).AsInteger = 1;
end;

procedure TmstMPObjectEzAdapter.SaveValue(const FieldName: string; const Value: Variant);
var
  NeedPost: Boolean;
begin
  NeedPost := dsEdit <> FEzDataSet.State;
  if NeedPost then
    FEzDataSet.Edit;
  FEzDataSet.FieldByName(FieldName).Value := Value;
  if NeedPost then
    FEzDataSet.Post;
end;

procedure TmstMPObjectEzAdapter.SetEzRecno(const Value: Integer);
begin
  SaveValue(SF_EZ_RECNO, Value);
end;

procedure TmstMPObjectEzAdapter.SetLoaded(const Value: Boolean);
begin
  SaveValue(SF_LOADED, IfThen(Value, 1, 0));
end;

{ TmstMPObjectAdapter }

constructor TmstMPObjectAdapter.Create(DataSet: TDataSet);
begin
  inherited Create;
  FDataSet := DataSet;
end;

function TmstMPObjectAdapter.GetMpClassId: Integer;
begin
  Result := FDataSet.FieldByName(SF_MASTER_PLAN_CLASS_ID).AsInteger;
end;

function TmstMPObjectAdapter.GetId: Integer;
begin
  Result := FDataSet.FieldByName(SF_ID).AsInteger;
end;

function TmstMPObjectAdapter.GetStatus: Integer;
begin
  Result := FDataSet.FieldByName(SF_STATUS).AsInteger;
end;

function TmstMPObjectAdapter.GetTableVersion: Integer;
begin
  Result := FDataSet.FieldByName(SF_TABLE_VERSION).AsInteger;
end;

end.
