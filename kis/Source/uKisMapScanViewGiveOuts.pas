{*******************************************************
{
{       "ИС МКП УГА"
{       Менеджер учета выдачи сканов планшетов без возврата
{
{
{
{       Copyright (c) 2015, МКП УГА
{
{       Автор: Калабухов А.В.
{
{*******************************************************}

unit uKisMapScanViewGiveOuts;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, DB, ImgList, ActnList, IBCustomDataSet, IBDatabase, IBQuery,
  uKisClasses, uKisSQLClasses, uKisEntityEditor, uKisConsts;

type
  /// <summary>
  ///   Запись о выдаче скана планшета заказчику.
  /// </summary>
  TKisMapScanGiveOut2 = class(TKisSQLEntity)
  private
    FDateOfGive: String;
    FHolder: Boolean;
    FPeopleId: Integer;
    FLicensedOrgId: Integer;
    FHolderName: String;
    FOrdersId: Integer;
    FAddress: String;
    FPersonWhoGive: String;
    FPersonWhoGiveId: Integer;
    FOfficeId: Integer;
    FPeopleName: String;
    FMD5Old: string;
    FNomenclature: string;
    FMapScanId: Integer;
    procedure SetDateOfGive(const Value: String);
    procedure SetHolder(const Value: Boolean);
    procedure SetPeopleId(const Value: Integer);
    procedure SetLicensedOrgId(const Value: Integer);
    procedure SetHolderName(const Value: String);
    procedure SetOrdersId(const Value: Integer);
    procedure SetAddress(const Value: String);
    procedure SetPersonWhoGiveId(const Value: Integer);
    procedure SetPeopleName(const Value: String);
    procedure SetOfficeId(const Value: Integer);
    procedure SetMD5Old(const Value: String);
    procedure SetPersonWhoGive(const Value: String);
    procedure SetNomenclature(const Value: string);
    procedure SetMapScanId(const Value: Integer);
  protected
    function CreateEditor: TKisEntityEditor; override;
  public
    constructor Create(aMngr: TKisMngr); override;
    //
    class function EntityName: String; override;
    procedure Copy(Source: TKisEntity); override;
    procedure Load(DataSet: TDataSet); override;
    //
    /// <summary>
    ///   Ссылка на скан планшета.
    /// </summary>
    property DateOfGive: String read FDateOfGive write SetDateOfGive;
    property Holder: Boolean read FHolder write SetHolder;
    property PeopleId: Integer read FPeopleId write SetPeopleId;
    property LicensedOrgId: Integer read FLicensedOrgId write SetLicensedOrgId;
    property HolderName: String read FHolderName write SetHolderName;
    property OrdersId: Integer read FOrdersId write SetOrdersId;
    property Address: String read FAddress write SetAddress;
    property PersonWhoGive: String read FPersonWhoGive write SetPersonWhoGive;
    property PersonWhoGiveId: Integer read FPersonWhoGiveId write SetPersonWhoGiveId;
    property OfficeId: Integer read FOfficeId write SetOfficeId;
    property PeopleName: String read FPeopleName write SetPeopleName;
    property MD5Old: String read FMD5Old write SetMD5Old;
    property Nomenclature: string read FNomenclature write SetNomenclature;
    property MapScanId: Integer read FMapScanId write SetMapScanId;
  end;

  TKisMapScanViewGiveOutMngr = class(TKisSQLMngr)
    ibqGiveouts: TIBDataSet;
    ibqGiveoutsID: TIntegerField;
    ibqGiveoutsMAP_SCANS_ID: TIntegerField;
    ibqGiveoutsDATE_OF_GIVE: TDateField;
    ibqGiveoutsNOMENCLATURE: TIBStringField;
    ibqGiveoutsHOLDER: TSmallintField;
    ibqGiveoutsHOLDER_NAME: TIBStringField;
    ibqGiveoutsORDERS_ID: TIntegerField;
    ibqGiveoutsLICENSED_ORGS_ID: TIntegerField;
    ibqGiveoutsPEOPLE_ID: TIntegerField;
    ibqGiveoutsPERSON_WHO_GIVE_ID: TIntegerField;
    ibqGiveoutsADDRESS: TIBStringField;
    ibqGiveoutsOFFICES_ID: TIntegerField;
    ibqGiveoutsPEOPLE_NAME: TIBStringField;
    ibqGiveoutsMD5_OLD: TIBStringField;
    ibqGiveoutsPERSON_WHO_GIVE: TIBStringField;
    ibqGiveoutsTAKER_OFFICE_NAME: TIBStringField;
    ibqGiveoutsORDER_NUMBER: TIBStringField;
    ibqGiveoutsORDER_DATE: TDateField;
  protected
    procedure Activate; override;
    procedure CreateView; override;
    procedure Deactivate; override;
    function GenEntityID(EntityKind: TKisEntities = keDefault): Integer; override;
    function GetIdent: TKisMngrs; override;
    function GetMainDataSet: TDataSet; override;
    function GetMainSQLText: String; override;
    function GetRefreshSQLText: String; override;
    function IsSupported(Entity: TKisEntity): Boolean; override;
    procedure Locate(AId: Integer; LocateFail: Boolean = False); override;
    procedure PrepareSQLHelper; override;
    procedure Reopen; override;
  public
    function CreateEntity(EntityKind: TKisEntities): TKisEntity; override;
    function CreateNewEntity(EntityKind: TKisEntities = keDefault): TKisEntity; override;
    function CurrentEntity: TKisEntity; override;
    procedure DeleteEntity(Entity: TKisEntity); override;
    function GetEntity(EntityID: Integer; EntityKind: TKisEntities = keDefault): TKisEntity; override;
    function IsEntityInUse(Entity: TKisEntity): Boolean; override;
    procedure SaveEntity(Entity: TKisEntity); override;
  end;

implementation

{$R *.dfm}

uses
  uIBXUtils,
  uKisExceptions, uKisAppModule, uKisSearchClasses;

const
  SG_MAP_SCAN_VIEW_GIVEOUTS = 'MAP_SCAN_VIEW_GIVEOUTS';

  SQ_MAIN_GIVEOUTS =
    'SELECT MSVG.ID, MSVG.MAP_SCANS_ID, MSVG.DATE_OF_GIVE, MSVG.NOMENCLATURE, MSVG.HOLDER, MSVG.HOLDER_NAME, MSVG.ORDERS_ID,'
  + '  MSVG.LICENSED_ORGS_ID, MSVG.PEOPLE_ID, MSVG.PERSON_WHO_GIVE_ID, MSVG.ADDRESS, MSVG.OFFICES_ID, MSVG.PEOPLE_NAME,'
  + ' MSVG.MD5_OLD, P2.INITIAL_NAME AS PERSON_WHO_GIVE, O.SHORT_NAME AS TAKER_OFFICE_NAME, SO.ORDER_NUMBER, SO.ORDER_DATE '
  + 'FROM MAP_SCAN_VIEW_GIVEOUTS MSVG'
  + '  LEFT JOIN SCAN_ORDERS SO ON (MSVG.ORDERS_ID = SO.ID)'
  + '  LEFT JOIN LICENSED_ORGS LO ON (MSVG.LICENSED_ORGS_ID = LO.ID)'
  + '  LEFT JOIN PEOPLE P1 ON (MSVG.PEOPLE_ID = P1.ID)'
  + '  LEFT JOIN PEOPLE P2 ON (MSVG.PERSON_WHO_GIVE_ID = P2.ID)'
  + '  LEFT JOIN OFFICES O ON (MSVG.OFFICES_ID = O.ID)';
//  'SELECT '
//  + '  MSVG.ID, MSVG.MAP_SCANS_ID, MSVG.DATE_OF_GIVE, MSVG.NOMENCLATURE, '
//  + '  MSVG.HOLDER, MSVG.HOLDER_NAME, MSVG.ORDERS_ID, MSVG.LICENSED_ORGS_ID, '
//  + '  MSVG.PEOPLE_ID, MSVG.PERSON_WHO_GIVE_ID, MSVG.ADDRESS, MSVG.OFFICES_ID, '
//  + '  MSVG.PEOPLE_NAME, MSVG.MD5_OLD '
//  + 'FROM MAP_SCAN_VIEW_GIVEOUTS MSVG ';

  SQ_SELECT_GIVEOUT =
    SQ_MAIN_GIVEOUTS + ' WHERE MSVG.ID=%d';
//    'SELECT * '
//  + 'FROM MAP_SCAN_VIEW_GIVEOUTS '
//  + 'WHERE ID=%d';

  SQ_SAVE_GIVEOUT =
    'INSERT INTO MAP_SCAN_VIEW_GIVEOUTS '
  + '  (ID, MAP_SCANS_ID, DATE_OF_GIVE, NOMENCLATURE, HOLDER, HOLDER_NAME,'
  + '   ORDERS_ID, LICENSED_ORGS_ID, PEOPLE_ID, PERSON_WHO_GIVE_ID, ADDRESS,'
  + '   OFFICES_ID, PEOPLE_NAME, MD5_OLD) '
  + 'VALUES '
  + '  (:ID, :MAP_SCANS_ID, :DATE_OF_GIVE, :NOMENCLATURE, :HOLDER, :HOLDER_NAME,'
  + '   :ORDERS_ID, :LICENSED_ORGS_ID, :PEOPLE_ID, :PERSON_WHO_GIVE_ID, :ADDRESS,'
  + '   :OFFICES_ID, :PEOPLE_NAME, :MD5_OLD)';

{ TKisMapScanGiveOut2 }

procedure TKisMapScanGiveOut2.Copy(Source: TKisEntity);
begin
  inherited;

end;

constructor TKisMapScanGiveOut2.Create(aMngr: TKisMngr);
begin
  inherited;

end;

function TKisMapScanGiveOut2.CreateEditor: TKisEntityEditor;
begin
  Result := nil;
end;

class function TKisMapScanGiveOut2.EntityName: String;
begin
  Result := 'Выдачи скана планшета без возврата';
end;

procedure TKisMapScanGiveOut2.Load(DataSet: TDataSet);
begin
  inherited;
  
end;

procedure TKisMapScanGiveOut2.SetAddress(const Value: String);
begin
  if FAddress <> Value then
  begin
    FAddress := Value;
    Modified := True;
  end;
end;

procedure TKisMapScanGiveOut2.SetDateOfGive(const Value: String);
begin
  if FDateOfGive <> Value then
  begin
    FDateOfGive := Value;
    Modified := True;
  end;
end;

procedure TKisMapScanGiveOut2.SetHolder(const Value: Boolean);
begin
  if FHolder <> Value then
  begin
    FHolder := Value;
    Modified := True;
  end;
end;

procedure TKisMapScanGiveOut2.SetHolderName(const Value: String);
begin
  if FHolderName <> Value then
  begin
    FHolderName := Value;
    Modified := True;
  end;
end;

procedure TKisMapScanGiveOut2.SetOfficeId(const Value: Integer);
begin
  if FOfficeId <> Value then
  begin
    FOfficeId := Value;
    Modified := True;
  end;
end;

procedure TKisMapScanGiveOut2.SetOrdersId(const Value: Integer);
begin
  if FOrdersId <> Value then
  begin
    FOrdersId := Value;
    Modified := True;
  end;
end;

procedure TKisMapScanGiveOut2.SetLicensedOrgId(const Value: Integer);
begin
  if FLicensedOrgId <> Value then
  begin
    FLicensedOrgId := Value;
    Modified := True;
  end;
end;

procedure TKisMapScanGiveOut2.SetMapScanId(const Value: Integer);
begin
  if FMapScanId <> Value then
  begin
    FMapScanId := Value;
    Modified := True;
  end;
end;

procedure TKisMapScanGiveOut2.SetMD5Old(const Value: String);
begin
  if FMD5Old <> Value then
  begin
    FMD5Old := Value;
    Modified := True;
  end;
end;

procedure TKisMapScanGiveOut2.SetNomenclature(const Value: string);
begin
  if FNomenclature <> Value then
  begin
    FNomenclature := Value;
    Modified := True;
  end;
end;

procedure TKisMapScanGiveOut2.SetPeopleId(const Value: Integer);
begin
  if FPeopleId <> Value then
  begin
    FPeopleId := Value;
    Modified := True;
  end;
end;

procedure TKisMapScanGiveOut2.SetPeopleName(const Value: String);
begin
  if FPeopleName <> Value then
  begin
    FPeopleName := Value;
    Modified := True;
  end;
end;

procedure TKisMapScanGiveOut2.SetPersonWhoGive(const Value: String);
begin
  if FPersonWhoGive <> Value then
  begin
    FPersonWhoGive := Value;
    Modified := True;
  end;
end;

procedure TKisMapScanGiveOut2.SetPersonWhoGiveId(const Value: Integer);
begin
  if FPersonWhoGiveId <> Value then
  begin
    FPersonWhoGiveId := Value;
    Modified := True;
  end;
end;

{ TKisMapScanViewGiveOutMngr }

procedure TKisMapScanViewGiveOutMngr.Activate;
begin
  inherited;
  ibqGiveouts.Transaction := AppModule.Pool.Get;
  ibqGiveouts.Transaction.Init();
  ibqGiveouts.Transaction.AutoStopAction := saNone;
  Reopen;
end;

function TKisMapScanViewGiveOutMngr.CreateEntity(
  EntityKind: TKisEntities): TKisEntity;
begin
  case EntityKind of
  keDefault, keMapScanViewGiveOut :
    Result := TKisMapScanGiveOut2.Create(Self);
  else
    Result := nil;
  end;
end;

function TKisMapScanViewGiveOutMngr.CreateNewEntity(
  EntityKind: TKisEntities): TKisEntity;
begin
  Result := CreateEntity(EntityKind);
  if Assigned(Result) then
    Result.ID := Self.GenEntityID(EntityKind)
  else
    raise Exception.Create(S_CANT_CREATE_NEW_ENTITY);
end;

procedure TKisMapScanViewGiveOutMngr.CreateView;
begin
  inherited;
  FView.Caption := 'Выдача планшетов для просмотра';
end;

function TKisMapScanViewGiveOutMngr.CurrentEntity: TKisEntity;
begin
  Result := GetEntity(ibqGiveouts.FieldByName(SF_ID).AsInteger, keDefault);
  if Assigned(Result) then
    Result.Modified := False;
end;

procedure TKisMapScanViewGiveOutMngr.Deactivate;
begin
  inherited;
  ibqGiveouts.Close;
  if not ibqGiveouts.Transaction.Active then
    ibqGiveouts.Transaction.Commit;
  AppModule.Pool.Back(ibqGiveouts.Transaction);
end;

procedure TKisMapScanViewGiveOutMngr.DeleteEntity(Entity: TKisEntity);
begin
//  inherited;
  // нельзя удалять
end;

function TKisMapScanViewGiveOutMngr.GenEntityID(
  EntityKind: TKisEntities): Integer;
begin
  case EntityKind of
    keDefault, keMapScanViewGiveOut :
      Result := AppModule.GetID(SG_MAP_SCAN_VIEW_GIVEOUTS, Self.DefaultTransaction);
  else
    Result := -1;
  end;
end;

function TKisMapScanViewGiveOutMngr.GetEntity(EntityID: Integer;
  EntityKind: TKisEntities): TKisEntity;
var
  DataSet: TDataSet;
  Conn: IKisConnection;
  SQLText: String;
begin
  Result := nil;
  Conn := GetConnection(True, False);
  try
    case EntityKind of
    keDefault, keMapScanViewGiveOut :
      SQLText := Format(SQ_SELECT_GIVEOUT, [EntityID]);
    else
      raise ELoadEntity.Create(EntityID, EntityKind);
    end;
    DataSet := Conn.GetDataSet(SQLText);
    DataSet.Open;
    if not DataSet.IsEmpty then
    begin
      Result := CreateEntity(EntityKind);
      Result.Load(DataSet);
    end
    else
      raise ELoadEntity.Create(EntityID, EntityKind);
  finally
    FreeConnection(Conn, True);
  end;
end;

function TKisMapScanViewGiveOutMngr.GetIdent: TKisMngrs;
begin
  Result := kmMapScanViewGiveOuts;
end;

function TKisMapScanViewGiveOutMngr.GetMainDataSet: TDataSet;
begin
  Result := ibqGiveouts;
end;

function TKisMapScanViewGiveOutMngr.GetMainSQLText: String;
begin
  Result := SQ_MAIN_GIVEOUTS;
end;

function TKisMapScanViewGiveOutMngr.GetRefreshSQLText: String;
begin
  Result := SQ_MAIN_GIVEOUTS + ' WHERE MSVG.ID=:ID';
end;

function TKisMapScanViewGiveOutMngr.IsEntityInUse(Entity: TKisEntity): Boolean;
begin
  Result := True;
end;

function TKisMapScanViewGiveOutMngr.IsSupported(Entity: TKisEntity): Boolean;
begin
  Result := Assigned(Entity) and (Entity is TKisMapScanGiveOut2);
  if not Result then
    inherited IsSupported(Entity);
end;

procedure TKisMapScanViewGiveOutMngr.Locate(AId: Integer; LocateFail: Boolean);
begin
  inherited;
  with MainDataSet do
  begin
    DisableControls;
    try
      Locate(SF_ID, AId, []);
    finally
      EnableControls;
    end;
  end;
end;

procedure TKisMapScanViewGiveOutMngr.PrepareSQLHelper;
begin
  inherited;
  with FSQLHelper.AddTable do
  begin
    TableName := ST_MAP_SCAN_VIEW_GIVEOUTS;
    TableLabel := 'Основная (выдача)';
    AddStringField(SF_NOMENCLATURE, SFL_NOMENCLATURE, 20, [fpSearch, fpSort, fpQuickSearch]);
    AddStringField(SF_HOLDER_NAME, SFL_HOLDER_NAME, 300, [fpSearch, fpSort, fpQuickSearch]);
    AddSimpleField(SF_DATE_OF_GIVE, SFL_DATE_OF_GIVE, ftDate, [fpSearch, fpSort]);
    AddSimpleField(SF_ID, SFL_ID, ftInteger, [fpSort]);
  end;
end;

procedure TKisMapScanViewGiveOutMngr.Reopen;
begin
  with MainDataSet do
  begin
    DisableControls;
    try
      inherited;
    finally
      EnableControls;
    end;
  end;
end;

procedure TKisMapScanViewGiveOutMngr.SaveEntity(Entity: TKisEntity);
var
  Conn: IKisConnection;
  DataSet: TDataSet;
  Gv2: TKisMapScanGiveOut2;
begin
  inherited;
  if Assigned(Entity) then
  if IsSupported(Entity) then
  if Entity is TKisMapScanGiveOut2 then
  begin
    Conn := GetConnection(True, True);
    DataSet := Conn.GetDataSet(SQ_SAVE_GIVEOUT);
    try
      if Entity.ID < 1 then
        Entity.ID := GenEntityID(keMapScanViewGiveOut);
      //
//  SQ_SAVE_GIVEOUT =
//    'INSERT INTO MAP_SCAN_VIEW_GIVEOUTS '
//  + '  (ID, MAP_SCANS_ID, DATE_OF_GIVE, NOMENCLATURE, HOLDER, HOLDER_NAME,'
//  + '   ORDERS_ID, LICENSED_ORGS_ID, PEOPLE_ID, PERSON_WHO_GIVE_ID, ADDRESS,'
//  + '   OFFICES_ID, PEOPLE_NAME, MD5_OLD) '
//  + 'VALUES '
//  + '  (:ID, :MAP_SCANS_ID, :DATE_OF_GIVE, :NOMENCLATURE, :HOLDER, :HOLDER_NAME,'
//  + '   :ORDERS_ID, :LICENSED_ORGS_ID, :PEOPLE_ID, :PERSON_WHO_GIVE_ID, :ADDRESS,'
//  + '   :OFFICES_ID, :PEOPLE_NAME, :MD5_OLD)';
      Gv2 := TKisMapScanGiveOut2(Entity);
      Conn.SetParam(DataSet, SF_ID, Entity.ID);
      Conn.SetParam(DataSet, SF_MAP_SCANS_ID, Gv2.MapScanId);
      Conn.SetParam(DataSet, SF_DATE_OF_GIVE, Gv2.DateOfGive);
      Conn.SetParam(DataSet, SF_NOMENCLATURE, Gv2.Nomenclature);
      Conn.SetParam(DataSet, SF_HOLDER, Integer(Gv2.Holder));
      Conn.SetParam(DataSet, SF_HOLDER_NAME, Gv2.HolderName);
      Conn.SetParam(DataSet, SF_ORDERS_ID, Gv2.OrdersId);
      Conn.SetParam(DataSet, SF_LICENSED_ORGS_ID, Gv2.LicensedOrgId);
      Conn.SetParam(DataSet, SF_PEOPLE_ID, Gv2.PeopleId);
      Conn.SetParam(DataSet, SF_PERSON_WHO_GIVE_ID, Gv2.PersonWhoGiveId);
      Conn.SetParam(DataSet, SF_ADDRESS, Gv2.Address);
      Conn.SetParam(DataSet, SF_OFFICES_ID, Gv2.OfficeId);
      Conn.SetParam(DataSet, SF_PEOPLE_NAME, Gv2.PeopleName);
      Conn.SetParam(DataSet, SF_MD5_OLD, Gv2.MD5Old);
      //
      DataSet.Active := True;
      //
      FreeConnection(Conn, True);
    except
      FreeConnection(Conn, False);
      raise;
    end;
  end;
end;

end.
