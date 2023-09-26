{*******************************************************}
{                                                       }
{       "ИС МП УГА"                                     }
{       Менеджер адресов контрагентов                   }
{                                                       }
{       Copyright (c) 2003-2005, МП УГА                 }
{                                                       }
{       Автор: Калабухов А.В.                           }
{                                                       }
{*******************************************************}

{ Описание: реализует операции над адресами контрагентов
  Имя модуля: Contragent Addresses
  Версия: 1.01
  Дата последнего изменения: 18.05.2005
  Цель: содержит классы - менеджер адресов контрагентов, адрес контрагента.
  Используется:
  Использует:   Kernel Classes
  Исключения:   }

{
  1.01           18.05.2005
    - использованы классы TKisConnection и пр.

  1.00           27.06.2004
    - начальная версия
}

unit uKisContragentAddresses;

interface

{$I KisFlags.pas}

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms, DB,
  ImgList, ActnList, IBDatabase, IBQuery, IBSQL, StrUtils, StdCtrls,
  // Common
  uIBXUtils, uGC, uCommonUtils,
   // Project
  uKisClasses, uKisEntityEditor, uKisSQLClasses, Streets,
  uKisAddressEditor, uKisAppModule, uKisConsts, uKisUtils, uKisIntf;

type
  TKisContragentAddress = class(TKisSQLEntity)
  private
    FPostIndex: Integer;
    FCountryId: Integer;
    FStateId: Integer;
    FVillageId: Integer;
    FStreetId: Integer;
    FRegionName: String;
    FTownKind: String;
    FTownName: String;
    FStreetMark: String;
    FVillageName: String;
    FStateName: String;
    FVillageKind: String;
    FStreetName: String;
    FBuildingMark: String;
    FBuilding: String;
    FCorpus: String;
    FRoom: String;
    FbtnStreetEnabled: Boolean;
    FInUpdate: Boolean;
    procedure SetPostIndex(const Value: Integer);
    procedure SetCountryId(const Value: Integer);
    procedure SetStateId(const Value: Integer);
    procedure SetVillageId(const Value: Integer);
    procedure SetStreetId(const Value: Integer);
    procedure SetRegionName(const Value: String);
    procedure SetTownKind(const Value: String);
    procedure SetVillageKind(const Value: String);
    procedure SetVillageName(const Value: String);
    procedure SetStateName(const Value: String);
    procedure SetTownName(const Value: String);
    procedure SetStreetMark(const Value: String);
    procedure SetStreetName(const Value: String);
    procedure SetBuildingMark(const Value: String);
    procedure SetBuilding(const Value: String);
    procedure SetCorpus(const Value: String);
    procedure SetRoom(const Value: String);
    procedure SetbtnStreetEnabled(const Value: Boolean);
    procedure SelectCountry(Sender: TObject);
    procedure SelectTown(Sender: TObject);
    procedure SelectStreet(Sender: TObject);
    procedure SelectState(Sender: TObject);
    function IsDefaultFilled: Boolean;
    procedure UpdateEditor;
    procedure LoadRussianStatesToEditor;
  protected
    function CheckEditor(Editor: TKisEntityEditor): Boolean; override;
    function CreateEditor: TKisEntityEditor; override;
    procedure PrepareEditor(Editor: TKisEntityEditor); override;
    procedure LoadDataIntoEditor(Editor: TKisEntityEditor); override;
    procedure ReadDataFromEditor(Editor: TKisEntityEditor); override;
    procedure UpdateStreet;
    function GetText: String; override;
  public
    constructor Create(Mngr: TKisMngr); override;
    class function EntityName: String; override;
    procedure Copy(Source: TKisEntity); override;
    function IsEmpty: Boolean; override;
    function Equals(Entity: TKisEntity): Boolean; override;
    property PostIndex: Integer read FPostIndex write SetPostIndex;
    property CountryId: Integer read FCountryId write SetCountryId;
    property StateId: Integer read FStateId write SetStateId;
    property VillageId: Integer read FVillageId write SetVillageId;
    property VillageName: String read FVillageName write SetVillageName;
    property StateName: String read FStateName write SetStateName;
    property RegionName: String read FRegionName write SetRegionName;
    property TownKind: String read FTownKind write SetTownKind;
    property VillageKind: String read FVillageKind write SetVillageKind;
    property TownName: String read FTownName write SetTownName;
    property StreetMark: String read FStreetmark write SetStreetMark;
    property StreetName: String read FStreetName write SetStreetName;
    property StreetId: Integer read FStreetId write SetStreetId;
    property BuildingMark: String read FBuildingMark write SetBuildingMark;
    property Building: String read FBuilding write SetBuilding;
    property Corpus: String read FCorpus write SetCorpus;
    property Room: String read FRoom write SetRoom;
    property btnStreetEnabled : Boolean read FbtnStreetEnabled write SetbtnStreetEnabled;
  end;

  TKisContragentAddressMngr = class(TKisSQLMngr)
  protected
    function GenEntityID(EntityKind: TKisEntities = keDefault): Integer; override;
    function IsSupported(Entity: TKisEntity): Boolean; override;
    function GetIdent: TKisMngrs; override;
    function GetMainSQLText: String; override;
    function GetRefreshSQLText: String; override;
    function GetMainDataSet: TDataSet; override;
  public
    function GetEntity(EntityID: Integer; EntityKind: TKisEntities = keDefault): TKisEntity; override;
    function CreateNewEntity(EntityKind: TKisEntities = keDefault): TKisEntity; override;
    procedure SaveEntity(Entity: TKisEntity); override;
    function IsEntityInUse(Entity: TKisEntity): Boolean; override;
    function DeleteEntity(Entity: TKisEntity): Boolean; override;
    function CreateEntity(EntityKind: TKisEntities): TKisEntity; override;
  end;

  TKisContragentAddressSaver = class(TKisEntitySaver)
  protected
    procedure PrepareParams(DataSet: TDataSet); override;
    function GetSQL: String; override;
  end;

implementation

{$R *.dfm}

resourcestring
  S_ADDRESS = 'Адрес';
  // Generators
  SG_CONTR_ADDRESSES = 'CONTR_ADDRESSES';
  // Queries
  SQ_SELECT_CONTR_ADDRESS = 'SELECT * FROM CONTR_ADDRESSES WHERE ID=%d';
  SQ_DELETE_ADDRESS = 'DELETE FROM CONTR_ADDRESSES WHERE ID=%d';
  SQ_ADDRESS_IN_USE = 'SELECT COUNT(*) FROM CONTRAGENTS WHERE ADDRESS_1_ID=%d OR ADDRESS_2_ID=%d';
  SQ_SAVE_ADDRESS = 'EXECUTE PROCEDURE SAVE_CONTR_ADDRESS(:ID, :POST_INDEX, :COUNTRY_ID, :STATE_ID, :VILLAGE_ID, :STREET_ID, :VILLAGE_NAME, :STATE_NAME, :REGION_NAME, :TOWN_KIND, :VILLAGE_KIND, :TOWN_NAME, :STREET_NAME, :STREET_MARK, :BUILDING, :BUILDING_MARK, :CORPUS, :ROOM)';

{ TKisContragentAdressMngr }

function TKisContragentAddressMngr.CreateEntity(
  EntityKind: TKisEntities): TKisEntity;
begin
  Result := TKisContragentAddress.Create(Self);
end;

function TKisContragentAddressMngr.CreateNewEntity(EntityKind: TKisEntities = keDefault): TKisEntity;
begin
  Result := TKisContragentAddress.Create(Self);
  Result.ID := GenEntityID(EntityKind);
end;

function TKisContragentAddressMngr.DeleteEntity(Entity: TKisEntity): Boolean;
var
  Conn: IKisConnection;
begin
  if not IsSupported(Entity) then
    inherited DeleteEntity(Entity);
  Conn := GetConnection(True, True);
  try
    if IsEntityInUse(Entity) then
    begin
      Result := False;
      inherited DeleteEntity(Entity);
    end
    else
    begin
      Conn.GetDataSet(Format(SQ_DELETE_ADDRESS, [Entity.ID])).Open;
      Result := True;
    end;
    FreeConnection(Conn, True);
  except
    FreeConnection(Conn, False);
    raise;
  end;
end;

class function TKisContragentAddress.EntityName: String;
begin
  Result := SEN_ADDRESS;
end;

function TKisContragentAddressMngr.GenEntityID(EntityKind: TKisEntities = keDefault): Integer;
begin
  Result := AppModule.GetID(SG_CONTR_ADDRESSES, Self.DefaultTransaction);
end;

function TKisContragentAddressMngr.GetEntity(EntityID: Integer;
  EntityKind: TKisEntities = keDefault): TKisEntity;
var
  Conn: IKisConnection;
  DataSet: TDataSet;
begin
  Conn := GetConnection(True, False);
  try
    DataSet := Conn.GetDataSet(Format(SQ_SELECT_CONTR_ADDRESS, [EntityID]));
    DataSet.Open;
    if not DataSet.IsEmpty then
    begin
      Result := CreateEntity(EntityKind);
      with Result as TKisContragentAddress do
      begin
        ID := EntityID;
        PostIndex := DataSet.FieldByName(SF_POST_INDEX).AsInteger;
        CountryId := DataSet.FieldByName(SF_COUNTRY_ID).AsInteger;
        StateId := DataSet.FieldByName(SF_STATE_ID).AsInteger;
        VillageId := DataSet.FieldByName(SF_VILLAGE_ID).AsInteger;
        StreetId := DataSet.FieldByName(SF_STREET_ID).AsInteger;
        VillageName := DataSet.FieldByName(SF_VILLAGE_NAME).AsString;
        StateName := DataSet.FieldByName(SF_STATE_NAME).AsString;
        RegionName := DataSet.FieldByName(SF_REGION_NAME).AsString;
        TownKind := DataSet.FieldByName(SF_TOWN_KIND).AsString;
        VillageKind := DataSet.FieldByName(SF_VILLAGE_KIND).AsString;
        TownName := DataSet.FieldByName(SF_TOWN_NAME).AsString;
        StreetMark := DataSet.FieldByName(SF_STREET_MARK).AsString;
        StreetName := DataSet.FieldByName(SF_STREET_NAME).AsString;
        BuildingMark := DataSet.FieldByName(SF_BUILDING_MARK).AsString;
        Building := DataSet.FieldByName(SF_BUILDING).AsString;
        Corpus := DataSet.FieldByName(SF_CORPUS).AsString;
        Room := DataSet.FieldByName(SF_ROOM).AsString;
      end;
    end
    else
      Result := nil;
  finally
    FreeConnection(Conn, True);
  end;
end;

function TKisContragentAddressMngr.GetIdent: TKisMngrs;
begin
  Result := kmContrAddresses;
end;

function TKisContragentAddressMngr.GetMainDataSet: TDataSet;
begin
  Result := nil;
end;

function TKisContragentAddressMngr.GetMainSQLText: String;
begin
  Result := '';
end;

function TKisContragentAddressMngr.GetRefreshSQLText: String;
begin
  Result := '';
end;

function TKisContragentAddressMngr.IsEntityInUse(Entity: TKisEntity): Boolean;
var
  Conn: IKisConnection;
begin
  Conn := GetConnection(True, False);
  try
    with Conn.GetDataSet(Format(SQ_ADDRESS_IN_USE, [Entity.ID, Entity.ID])) do
    begin
      Open;
      Result := Fields[0].Asinteger > 0;
      Close;
    end;
  finally
    FreeConnection(Conn, True);
  end;
end;

function TKisContragentAddressMngr.IsSupported(Entity: TKisEntity): Boolean;
begin
  Result := Assigned(Entity) and (Entity is TKisContragentAddress);
  if not Result then
    Result := inherited IsSupported(Entity);
end;

procedure TKisContragentAddressMngr.SaveEntity(Entity: TKisEntity);
var
  Conn: IKisConnection;
begin
  Conn := GetConnection(True, True);
  try
    // Проверка ID
    while IsEntityInUse(Entity) do
      Entity.ID := GenEntityId();
    // Сохранение
    with TKisContragentAddressSaver.Create(Conn) do
    try
      Save(Entity);
    finally
      Free;
    end;
    FreeConnection(Conn, True);
  except
    FreeConnection(Conn, False);
    raise;
  end;
end;

{ TKisContragentAddress }

procedure TKisContragentAddress.Copy(Source: TKisEntity);
begin
  inherited;
  with Source as TKisContragentAddress do
  begin
      Self.FPostIndex := FPostIndex;
      Self.FCountryId := FCountryId;
      Self.FStateId := FStateId;
      Self.FVillageId := FVillageId;
      Self.FStreetId := FStreetId;
      Self.FVillageName := FVillageName;
      Self.FStateName := FStateName;
      Self.FRegionName := FRegionName;
      Self.FTownKind := FTownKind;
      Self.FVillageKind := FVillageKind;
      Self.FTownName := FTownName;
      Self.FStreetmark := FStreetMark;
      Self.FStreetName := FStreetname;
      Self.FBuildingMark := FBuildingMark;
      Self.FBuilding := FBuilding;
      Self.FCorpus := FCorpus;
      Self.FRoom := FRoom;
  end;
end;

function TKisContragentAddress.CheckEditor(Editor: TKisEntityEditor): Boolean;
begin
  Result := False;
  if Editor is TKisAddressEditor then
  with Editor as TKisAddressEditor do
  begin
    if (Length(edIndex.Text) <> 6) or not StrIsNumber(edIndex.Text)
       or (edIndex.Text = DupeString('0', 6)) then
    begin
      MessageBox(Handle, PChar(S_CHECK_INDEX), PChar(S_WARN), MB_OK + MB_ICONWARNING);
      edIndex.SetFocus;
      Exit;
    end;
    if cbCountry.ItemIndex < 0 then
    begin
      MessageBox(Handle, PChar(S_CHECK_COUNTRY), PChar(S_WARN), MB_OK + MB_ICONWARNING);
      cbCountry.SetFocus;
      Exit;
    end;
    if (Length(Trim(cbTownName.Text)) = 0) or StrIsNumber(Trim(cbTownName.Text))
      or BadName(Trim(cbTownName.Text)) then
    begin
      MessageBox(Handle, PChar(S_CHECK_TOWN), PChar(S_WARN), MB_OK + MB_ICONWARNING);
      cbTownName.SetFocus;
      Exit;
    end;
    if (Length(Trim(edStreetName.Text)) = 0) or StrIsNumber(Trim(edStreetName.Text))
      or BadName(Trim(edStreetName.Text)) then
    begin
      MessageBox(Handle, PChar(S_CHECK_STREET), PChar(S_WARN), MB_OK + MB_ICONWARNING);
      edStreetName.SetFocus;
      Exit;
    end;
  end;
  Result := True;
end;

constructor TKisContragentAddress.Create(Mngr: TKisMngr);
begin
  inherited;
  FCountryId := ID_RUSSIA_ID;
  FPostIndex := ID_DEFAULT_INDEX;
  FTownName := S_DEFAULT_CITY;
end;

function TKisContragentAddress.Equals(Entity: TKisEntity): Boolean;
begin
  inherited Equals(Entity);
  with Entity as TKisContragentAddress do
  begin
    Result := (Self.FPostIndex = FPostIndex) and (Self.FCountryId = CountryId)
      and (Self.FStateId = StateId) and (Self.FStateName = StateName)
      and (Self.FVillageId = VillageId) and (Self.FVillageName = VillageName)
      and (Self.FRegionName = RegionName) and (Self.FVillageKind = VillageKind)
      and (Self.FTownKind = TownKind) and (Self.FTownName = TownName)
      and (Self.FStreetMark = Streetmark) and (Self.FStreetName = StreetName)
      and (Self.FStreetId = StreetId)
      and (Self.FBuildingMark = BuildingMark) and (Self.FBuilding = Building)
      and (Self.FCorpus = Corpus) and (Self.FRoom = Room);
  end;
end;

function TKisContragentAddress.GetText: String;
var
  I: Integer;

  function AddDel(const S: String): String;
  begin
    if Length(S) > N_ZERO then
      Result := S + ', ';
  end;

begin
  Result := '';
  if IsDefaultFilled then Exit;
  if PostIndex > N_ZERO then
    Result := IntToStr(PostIndex);
  if CountryId > N_ZERO then
  begin
    with IObject(AppModule.Lists[klCountries]).AObject as TStrings do
    begin
      I := IndexOfObject(Pointer(CountryId));
      if I >= N_ZERO then
        Result := AddDel(Result) + Strings[I];
    end;
  end;
  if StateId > N_ZERO then
  begin
    with IObject(AppModule.Lists[klStates]).AObject as TStrings do
    begin
      I := IndexOfObject(Pointer(StateId));
      if I >= N_ZERO then
        Result := AddDel(Result) + Strings[I];
    end;
  end
  else
    if StateName <> '' then
      Result := AddDel(Result) + StateName;
  if RegionName <> '' then
    Result := AddDel(Result) + RegionName;
  if (TownName <> '') then
    Result := AddDel(Result) + TownKind + TownName;
  if (VillageName <> '')
     and ((VillageName <> S_DEFAULT_VILLAGE) and (VillageKind <> '')) then
  begin
     Result := AddDel(Result) + VillageKind + ' ' + VillageName;
  end;
  if StreetName <> '' then
    Result := AddDel(Result) + StreetMark + StreetName;
  if Building <> '' then
    Result := AddDel(Result) + 'д.' + Building;
  if Corpus <> '' then
    Result := AddDel(Result) + 'корп.' + Corpus;
  if Room <> '' then
    Result := AddDel(Result) + 'кв.' + Room;
end;

function TKisContragentAddress.IsEmpty: Boolean;
begin
  Result := ((FPostIndex = ID_DEFAULT_INDEX) or (FPostIndex = 0))
    and ((FCountryId = N_ZERO) or (FCountryId = ID_DEFAULT_STATE))
    and (FStateId = N_ZERO)
    and (FVillageId = N_ZERO) and (FVillageKind = '')
    and (FRegionName = '') and (FTownKind = '')
    and ((FTownName = '') or (FTownName = S_DEFAULT_CITY))
    and (FStreetMark = '')
    and (FStreetName = '') and (FBuildingMark = EmptyStr)
    and (FBuilding = '') and (FCorpus = '') and (FRoom = '');
end;

procedure TKisContragentAddress.PrepareEditor(Editor: TKisEntityEditor);
begin
  inherited;
  with Editor as TKisAddressEditor do
  begin
    with IObject(AppModule.Lists[klCountries]) do
    begin
      cbCountry.Items.Assign(AObject as TStringList);
    end;
    with IObject(AppModule.Lists[klTownKind]) do
    begin
      cbTownKind.Items.Assign(AObject as TStringList);
      cbVillageKind.Items.Assign(AObject as TStringList);
    end;
    with IObject(AppModule.Lists[klStreetMark]) do
    begin
      cbStreetMark.Items.Assign(AObject as TStringList);
    end;
    cbCountry.OnSelect := SelectCountry;
    cbTownName.OnChange := SelectTown;
    cbState.OnSelect := SelectState;
    btnStreet.OnClick := SelectStreet;
  end;
end;

procedure TKisContragentAddress.LoadDataIntoEditor(
  Editor: TKisEntityEditor);
begin
  with Editor as TKisAddressEditor do
  begin
    if PostIndex = N_ZERO then
      edIndex.Clear
    else
      edIndex.Text := IntToStr(Self.PostIndex);
    ComboLocate(cbCountry, CountryId);

    cbState.Text := StateName;
    
    edRegionOfState.Text := RegionName;
    if TownKind <> '' then
      cbTownKind.ItemIndex := cbTownKind.Items.IndexOf(TownKind)
    else
      cbTownKind.ItemIndex := cbTownKind.Items.IndexOf('г.');
    if TownName <> '' then
      cbTownName.Text := TownName
    else
      cbTownName.ItemIndex := cbTownName.Items.IndexOf('Воронеж');
    UpdateEditor;
    if not ComboLocate(cbVillageName, VillageId) then
      cbVillageName.Text := VillageName;
    if VillageKind <> '' then
      cbVillageKind.ItemIndex := cbVillageKind.Items.IndexOf(VillageKind);
    if StreetMark <> '' then
      cbStreetMark.ItemIndex := cbStreetMark.Items.IndexOf(StreetMark);
//    SelectTown(cbTownName);
    if StreetMark <> '' then
      cbStreetMark.ItemIndex := cbStreetMark.Items.IndexOf(StreetMark)
    else
      cbStreetMark.ItemIndex := cbStreetMark.Items.IndexOf('ул.');
    edStreetName.Text := StreetName;
    edBuilding.Text := Building;
    edCorpus.Text := Corpus;
    edRoom.Text := Room;
  end;
end;

procedure TKisContragentAddress.ReadDataFromEditor(
  Editor: TKisEntityEditor);
begin
  inherited;
  with Editor as TKisAddressEditor do
  begin
    PostIndex := StrToInt(edIndex.Text);
    //CountryId := RUSSIA_ID;
    if cbState.ItemIndex < N_ZERO then
      StateId := N_ZERO
    else
      StateId := Integer(cbState.Items.Objects[cbState.ItemIndex]);
    if cbCountry.ItemIndex < N_ZERO then
      CountryId := N_ZERO
    else
      CountryId := Integer(cbCountry.Items.Objects[cbCountry.ItemIndex]);
    if cbVillageName.ItemIndex < N_ZERO then
      VillageId := N_ZERO
    else
      VillageId := Integer(cbVillageName.Items.Objects[cbVillageName.ItemIndex]);
    VillageName := cbVillageName.Text;
    StateName := cbState.Text;
    RegionName := edRegionOfState.Text;
    TownKind := cbTownKind.Text;
    VillageKind := cbVillageKind.Text;
    TownName := cbTownName.Text;
    StreetName := edStreetName.Text;
    StreetMark := cbStreetMark.Text;
    BuildingMark := EmptyStr;
    Building := edBuilding.Text;
    Corpus := edCorpus.Text;
    Room := edRoom.Text;
  end;
end;

procedure TKisContragentAddress.UpdateStreet;
begin
  if Assigned(EntityEditor) then
  begin
    TKisAddressEditor(EntityEditor).edStreetName.Text := FStreetName;
    TKisAddressEditor(EntityEditor).cbStreetMark.Text := FStreetMark;
  end;
end;


procedure TKisContragentAddress.SetBuilding(const Value: String);
begin
  if FBuilding <> Value then
  begin
    FBuilding := Value;
    Modified := True;
  end;
end;

procedure TKisContragentAddress.SetBuildingMark(const Value: String);
begin
  if FBuildingMark <> Value then
  begin
    FBuildingMark := Value;
    Modified := True;
  end;
end;

procedure TKisContragentAddress.SetCorpus(const Value: String);
begin
  if FCorpus <> Value then
  begin
    FCorpus := Value;
    Modified := True;
  end;
end;

procedure TKisContragentAddress.SetCOuntryId(const Value: Integer);
begin
  if FCountryId <> Value then
  begin
    FCountryId := Value;
    Modified := True;
  end;
end;

procedure TKisContragentAddress.SetPostIndex(const Value: Integer);
begin
  if FPostIndex <> Value then
  begin
    FPostIndex := Value;
    Modified := True;
  end;
end;

procedure TKisContragentAddress.SetRegionName(const Value: String);
begin
  if FRegionName <> Value then
  begin
    FRegionName := Value;
    Modified := True;
  end;
end;

procedure TKisContragentAddress.SetRoom(const Value: String);
begin
  if FRoom <> Value then
  begin
    FRoom := Value;
    Modified := True;
  end;
end;

procedure TKisContragentAddress.SetStateId(const Value: Integer);
begin
  if FStateId <> Value then
  begin
    FStateId := Value;
    Modified := True;
  end;
end;

procedure TKisContragentAddress.SetVillageId(const Value: Integer);
begin
  if FVillageId <> Value then
  begin
    FVillageId := Value;
    Modified := True;
  end;
end;

procedure TKisContragentAddress.SetVillageName(const Value: String);
begin
  if FVillageName <> Value then
  begin
    FVillageName := Value;
    Modified := True;
  end;
end;

procedure TKisContragentAddress.SetStateName(const Value: String);
begin
  if FStateName <> Value then
  begin
    FStateName := Value;
    Modified := True;
  end;
end;

procedure TKisContragentAddress.SetStreetMark(const Value: String);
begin
  if FStreetmark <> Value then
  begin
    FStreetmark := Value;
    Modified := True;
  end;
end;

procedure TKisContragentAddress.SetStreetName(const Value: String);
begin
  if FStreetName <> Value then
  begin
    FStreetName := Value;
    Modified := True;
  end;
end;

procedure TKisContragentAddress.SetStreetId(const Value: Integer);
begin
  if FStreetId <> Value then
  begin
    FStreetId := Value;
    Modified := True;
  end;
end;

procedure TKisContragentAddress.SetTownKind(const Value: String);
begin
  if FTownKind <> Value then
  begin
    FTownKind := Value;
    Modified := True;
  end;
end;

procedure TKisContragentAddress.SetVillageKind(const Value: String);
begin
  if FVillageKind <> Value then
  begin
    FVillageKind := Value;
    Modified := True;
  end;
end;

procedure TKisContragentAddress.SetTownName(const Value: String);
begin
  if FTownName <> Value then
  begin
    FTownName := Value;
    Modified := True;
  end;
end;

procedure TKisContragentAddress.SetbtnStreetEnabled(const Value: Boolean);
begin
  FbtnStreetEnabled := Value;
  with EntityEditor as TKisAddressEditor do
     btnStreet.Enabled := FbtnStreetEnabled;
end;

function TKisContragentAddress.CreateEditor: TKisEntityEditor;
begin
  Result := TKisAddressEditor.Create(Application);
end;

procedure TKisContragentAddress.SelectCountry(Sender: TObject);
var
  Tmp: TKisContragentAddress;
begin
  with EntityEditor as TKisAddressEditor do
  begin
    Tmp := IObject(SQLMngr.CreateEntity(keContrAddress)).AObject as TKisContragentAddress;
    Tmp.ReadDataFromEditor(EntityEditor);
    if not Tmp.IsDefaultFilled then
    begin
      if MessageBox(EntityEditor.Handle,PChar('Очистить остальные данные в адресе?'), PChar('Внимание'),
         MB_OKCANCEL + MB_ICONQUESTION) = IDOK then
      begin
        cbState.Text := '';
        edRegionOfState.Text := '';
        cbTownKind.Text := '';
        cbVillageKind.Text := '';
        cbTownName.Text := '';
        cbVillageName.Text := '';
        cbStreetMark.Text := '';
        edStreetName.Text := '';
        edBuilding.Text := '';
        edCorpus.Text := '';
        edRoom.Text := '';
        with Sender as TComboBox do
        if ItemIndex = Items.IndexOf(S_DEFAULT_COUNTRY) then
          with EntityEditor as TKisAddressEditor do
          begin
            cbTownName.ItemIndex := cbTownName.Items.IndexOf(S_DEFAULT_CITY);
            cbTownKind.Text := 'г.';
          end;
      end;
    end;
  end;
  UpdateEditor;
end;

procedure TKisContragentAddress.SelectTown(Sender: TObject);
begin
  UpdateEditor;
end;

procedure TKisContragentAddress.SelectStreet(Sender: TObject);
var
  V: Variant;
begin
  if Streets.SelectStreet(FStreetID) then
  begin
    if AppModule.GetFieldValue(nil, ST_STREETS, SF_ID, SF_NAME, FStreetID, V) then
      StreetName := V
    else
      StreetName := '';
    if AppModule.GetFieldValue(nil, ST_STREETS, SF_ID, SF_STREET_MARKING_NAME, FStreetID, V) then
      StreetMark := V
    else
      StreetMark := '';
      UpdateStreet;
  end;
end;

function TKisContragentAddress.IsDefaultFilled: Boolean;
begin
  Result := (
     (CountryId = ID_RUSSIA_ID) and
     (StateId = N_ZERO) and
     (RegionName = '') and
     ((TownName = S_DEFAULT_CITY) or (TownName = '')) and
     ((VillageId = N_ZERO) or ((VillageName = S_DEFAULT_VILLAGE) and (VillageKind = ''))) and
     (StreetName = '') and
     (Building = '') and
     (Corpus = '') and
     (Room = '')
  );
end;

procedure TKisContragentAddress.UpdateEditor;
var
  S: String;
begin
  if FInUpdate then
    Exit;
  FInUpdate := True;
  try
    with EntityEditor as TKisAddressEditor do
    begin
      if cbCountry.Text <> S_DEFAULT_COUNTRY then
      begin
        cbState.Items.Clear;
        cbState.Style := csDropDown;
      end
      else
        LoadRussianStatesToEditor;
      // Проверка города
      if cbTownName.Text <> S_DEFAULT_CITY then
      begin
        cbVillageName.Items.Clear;
        cbVillageName.Style := csDropDown;
      end
      else
        if (cbCountry.Text = S_DEFAULT_COUNTRY)
           and (
                 (cbState.Text = '') or
                 (Integer(cbState.Items.Objects[cbState.ItemIndex]) = ID_DEFAULT_STATE)
               ) then
        begin
          with IObject(AppModule.Lists[klVillages]) do
          begin
            S := cbVillageName.Text;
            cbVillageName.Items.Assign(AObject as TStringList);
            cbVillageName.Style := csDropDownList;
            if S <> '' then
               cbVillageName.ItemIndex := cbVillageName.Items.IndexOf(S);
          end;
        end
        else
        begin
          cbVillageName.Items.Clear;
          cbVillageName.Style := csDropDown;
        end;
      btnStreetEnabled := (
        (cbCountry.Text = S_DEFAULT_COUNTRY)
        and
        (cbTownName.Text = S_DEFAULT_CITY)
        and
        (cbTownKind.Text = 'г.')
        and (
             (cbState.Text = S_DEFAULT_STATE)
             or
             (cbState.Text = '')
            )
        and
        (Trim(edRegionOfState.Text) = '')
      );
    end;
  finally
    FInUpdate := False;
  end;
end;

procedure TKisContragentAddress.SelectState(Sender: TObject);
begin
  UpdateEditor;
end;

{ TKisContragetAddressSaver }

function TKisContragentAddressSaver.GetSQL: String;
begin
  Result := SQ_SAVE_ADDRESS;
end;

procedure TKisContragentAddressSaver.PrepareParams(DataSet: TDataSet);
var
  S: String;
begin
  with TKisContragentAddress(FEntity) do
  begin
    FConnection.SetParam(DataSet,SF_ID , ID);
    if PostIndex = 0 then
      S := ''
    else
      S := IntToStr(PostIndex);
    FConnection.SetParam(DataSet, SF_POST_INDEX, S);
    FConnection.SetParam(DataSet, SF_COUNTRY_ID, CountryId);
    FConnection.SetParam(DataSet, SF_STATE_ID, StateId);
    FConnection.SetParam(DataSet, SF_VILLAGE_ID, VillageId);
    FConnection.SetParam(DataSet, SF_STREET_ID, StreetId);
    FConnection.SetParam(DataSet, SF_VILLAGE_NAME, VillageName);
    FConnection.SetParam(DataSet, SF_STATE_NAME, StateName);
    FConnection.SetParam(DataSet, SF_REGION_NAME, RegionName);
    FConnection.SetParam(DataSet, SF_TOWN_KIND, TownKind);
    FConnection.SetParam(DataSet, SF_VILLAGE_KIND, VillageKind);
    FConnection.SetParam(DataSet, SF_TOWN_NAME, TownName);
    FConnection.SetParam(DataSet, SF_STREET_NAME, StreetName);
    FConnection.SetParam(DataSet, SF_STREET_MARK, StreetMark);
    FConnection.SetParam(DataSet, SF_BUILDING, Building);
    FConnection.SetParam(DataSet, SF_BUILDING_MARK, BuildingMark);
    FConnection.SetParam(DataSet, SF_CORPUS, Corpus);
    FConnection.SetParam(DataSet, SF_ROOM, Room);
  end;
end;

procedure TKisContragentAddress.LoadRussianStatesToEditor;
var
  OldText: String;
  Lst: TStringList;
begin
  with EntityEditor as TKisAddressEditor do
  begin
    Lst := AppModule.Lists[klStates];
    Lst.Forget;
    OldText := cbState.Text;
    cbState.Items.Assign(Lst);
    cbState.Items.InsertObject(0, '', nil);
    cbState.Style := csDropDownList;
    if OldText <> '' then
      cbState.ItemIndex := cbState.Items.IndexOf(OldText);
  end;
end;

end.

