{*******************************************************}
{                                                       }
{       "ИС МП УГА"                                     }
{       Оргинизации, лицензированные для работ
{       с катрматериалом                                }
{                                                       }
{       Copyright (c) 2005, МП УГА                      }
{                                                       }
{       Автор: Калабухов А.В.                           }
{                                                       }
{*******************************************************}

{ Описание:
  Имя модуля: Kernel Classes
  Версия: 1.00
  Дата последнего изменения: 03.05.2005
  Цель: содержит классы организации и менеджера
  Используется:
  Использует:
  Исключения:   }
{
  1.00          03.05.2005
     - начальная версия
}

unit uKisLicensedOrgs;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms, Contnrs,
  Dialogs, DB, ImgList, ActnList, IBCustomDataSet, IBQuery, DateUtils,
  uKisSQLClasses, uKisClasses, uKisEntityEditor, uKisAppModule, uDateTimeUtils, uDataSet;

type
  TKisLicensedOrgSRO = class(TKisVisualEntity)
  private
    FStartDate: String;
    FEndDate: String;
    FSROName: string;
    procedure SetSROName(const Value: string);
    procedure SetStartDate(const Value: String);
    procedure SetEndDate(const Value: String);
  protected
    function GetText: String; override;
    //
    function CreateEditor: TKisEntityEditor; override;
    procedure LoadDataIntoEditor(AEditor: TKisEntityEditor); override;
    procedure ReadDataFromEditor(AEditor: TKisEntityEditor); override;
    function CheckEditor(AEditor: TKisEntityEditor): Boolean; override;
    procedure PrepareEditor(Editor: TKisEntityEditor); override;
    procedure UnprepareEditor(Editor: TKisEntityEditor); override;
  public
    class function EntityName: String; override;
    procedure Load(DataSet: TDataSet); override;
    function IsEmpty: Boolean; override;
    procedure Copy(Source: TKisEntity); override;
    function Equals(Entity: TKisEntity): Boolean; override;
    //
    property SROName: string read FSROName write SetSROName;
    property StartDate: String read FStartDate write SetStartDate;
    property EndDate: String read FEndDate write SetEndDate;
    //
    function GetStartDate(out aDate: TDateTime): Boolean;
    function GetEndDate(out aDate: TDateTime): Boolean;
  end;

  TKisLicensedOrgSROController = class(TKisEntityController)
  public
    procedure FillFieldDefs(FieldDefsRef: TFieldDefs); override;
    function GetFieldData(Index: Integer; Field: TField; out Data): Boolean; override;
    procedure SetFieldData(Index:integer; Field: TField; var Data); override;
    function GetDeleteQueryText: String; override;
  end;

  TKisLicensedOrg = class(TKisVisualEntity)
  private
    FName: String;
    FStartDate: String;
    FEndDate: String;
    FAddress: String;
    FMapperFio: String;
    FSROPeriods: TCustomDataSet;
    FSROPeriodsCtrlr: TKisLicensedOrgSROController;
    procedure SetName(const Value: String);
    procedure SetStartDate(const Value: String);
    procedure SetEndDate(const Value: String);
    procedure SetAddress(const Value: String);
    procedure SetMapperFio(const Value: String);
    function GetSROPeriods: TDataSet;
  private
    procedure SROPeriodsInsert(DataSet: TDataSet);
    procedure SROPeriodsEdit(DataSet: TDataSet);
    procedure SROPeriodsBeforeDelete(DataSet: TDataSet);
    procedure CreateSROPeriods(anOrg: TKisLicensedOrg);
  protected
    function GetText: String; override;
    function CreateEditor: TKisEntityEditor; override;
    procedure LoadDataIntoEditor(AEditor: TKisEntityEditor); override;
    procedure ReadDataFromEditor(AEditor: TKisEntityEditor); override;
    function CheckEditor(AEditor: TKisEntityEditor): Boolean; override;
    procedure PrepareEditor(Editor: TKisEntityEditor); override;
    procedure UnprepareEditor(Editor: TKisEntityEditor); override;
  public
    class function EntityName: String; override;
    constructor Create(Mngr: TKisMngr); override;
    destructor Destroy; override;
    //
    procedure Copy(Source: TKisEntity); override;
    procedure Load(DataSet: TDataSet); override;
    function IsEmpty: Boolean; override;
    function Equals(Entity: TKisEntity): Boolean; override;
    //
    property Name: String read FName write SetName;
    property Address: String read FAddress write SetAddress;
    property StartDate: String read FStartDate write SetStartDate;
    property EndDate: String read FEndDate write SetEndDate;
    property MapperFio: String read FMapperFio write SetMapperFio;
    //
    property SROPeriods: TDataSet read GetSROPeriods;
    //
    /// <summary>
    /// Ищет СРО на указанную дату.    
    /// </summary>
    function FindSROPeriod(const aDate: TDateTime): TKisLicensedOrgSRO;
  end;

  TKisLicensedOrgTempList = class
  private
    FList: TObjectList;
  public
    constructor Create;
    destructor Destroy; override;
    //
    function Add(aOrg: TKisLicensedOrg): Integer;
    function Find(aOrgId: Integer): TKisLicensedOrg;
  end;

  TKisLicensedOrgMngr = class(TKisSQLMngr)
    dsLicensedOrgs: TIBDataSet;
    dsLicensedOrgsNAME: TStringField;
    dsLicensedOrgsADDRESS: TStringField;
    dsLicensedOrgsSTART_DATE: TDateField;
    dsLicensedOrgsEND_DATE: TDateField;
    dsLicensedOrgsID: TIntegerField;
    acExport: TAction;
    dsLicensedOrgsMAPPER_FIO: TStringField;
    procedure dsLicensedOrgsBeforeOpen(DataSet: TDataSet);
    procedure acExportExecute(Sender: TObject);
  private
    procedure LoadSROToOrg(aOrg: TKisLicensedOrg);
    procedure SaveLicensedOrg(aEntity: TKisLicensedOrg);
    procedure SaveSRO(Entity: TKisLicensedOrgSRO);
  protected
    procedure CreateView; override;
    function GetIdent: TKisMngrs; override;
    function GetMainDataSet: TDataSet; override;
    function GetMainSQLText: String; override;
    function GetRefreshSQLText: String; override;
    function GenEntityID(EntityKind: TKisEntities = keDefault): Integer; override;
    procedure Activate; override;
    procedure Deactivate; override;
    function IsSupported(Entity: TKisEntity): Boolean; override;
    procedure PrepareSQLHelper; override;
  public
    function CreateEntity(EntityKind: TKisEntities): TKisEntity; override;
    function CreateNewEntity(EntityKind: TKisEntities = keDefault): TKisEntity; override;
    function GetEntity(EntityID: Integer; EntityKind: TKisEntities = keDefault): TKisEntity; override;
    procedure SaveEntity(aEntity: TKisEntity); override;
    function DeleteEntity(Entity: TKisEntity): Boolean; override;
    function IsEntityInUse(Entity: TKisEntity): Boolean; override;
    function CurrentEntity: TKisEntity; override;
    procedure Locate(AId: Integer; LocateFail: Boolean = False); override;
  end;

implementation

{$R *.dfm}

uses
  // Common
  uGC, uIBXUtils,
  // Project
  uKisLicensedOrgEditor, uKisUtils, uKisConsts, uKisIntf, uKisSearchClasses,
  uKisLicnsedOrgSROPeriodEditor;

const
  SG_LICENSED_ORGS = 'LICENSED_ORGS';
  SG_LICENSED_ORG_SRO_PERIODS = 'LICENSED_ORG_SRO_PERIODS';

  SQ_MAIN_BASE = //'SELECT LO.* FROM LICENSED_ORGS LO ';
    'SELECT LO.ID, LO.NAME, LO.ADDRESS, LO.START_DATE, LO.END_DATE, LO.MAPPER_FIO '
  + 'FROM LICENSED_ORGS LO ';
  SQ_MAIN = SQ_MAIN_BASE + ' WHERE (LO.ID > 0)';
  SQ_SELECT_LICENSED_ORG = SQ_MAIN_BASE + ' WHERE (LO.ID=%d)';
  SQ_SAVE_LICENSED_ORG = 'EXECUTE PROCEDURE SAVE_LICENSED_ORG('
   // :ID, :NAME, :ADDRESS, :START_DATE, :END_DATE, :MAPPER_FIO)
    + '%d, ''%s'', ''%s'', ''%s'', ''%s'', ''%s'')';
  SQ_DELETE_LICENSED_ORG = 'DELETE FROM LICENSED_ORGS WHERE ID=%d';
  SQ_SELECT_SRO_PERIOD =
    'SELECT LOSP.ID, LOSP.SRO_NAME, LOSP.START_DATE, LOSP.END_DATE ' +
    'FROM LICENSED_ORG_SRO_PERIODS LOSP ';
  SQ_GET_SRO_LIST_ID =
    'SELECT ID FROM LICENSED_ORG_SRO_PERIODS WHERE LICENSED_ORGS_ID=%d ORDER BY START_DATE';
  SQ_SAVE_LICENSED_ORG_SRO_PERIOD =
    'EXECUTE PROCEDURE SAVE_LICENSED_ORG_SRO('
   // :ID, :LICENSED_ORGS_ID, :SRO_NAME, :START_DATE, :END_DATE)
    + '%d, %d, ''%s'', ''%s'', ''%s'')';
  SQ_FIND_LICENSED_ORG_SRO_PERIOD =
    'SELECT ID FROM LICENSED_ORG_SRO_PERIODS WHERE ID=:ID';
  SQ_INSERT_LICENSED_ORG_SRO_PERIOD =
    'INSERT INTO LICENSED_ORG_SRO_PERIODS (ID, LICENSED_ORGS_ID, SRO_NAME, START_DATE, END_DATE) '
  + 'VALUES(:ID, :LICENSED_ORGS_ID, :SRO_NAME, :START_DATE, :END_DATE)';//(%d, %d, ''%s'', ''%s'', ''%s'')';
  SQ_UPDATE_LICENSED_ORG_SRO_PERIOD =
    'UPDATE LICENSED_ORG_SRO_PERIODS SET '
  + 'LICENSED_ORGS_ID=:LICENSED_ORGS_ID, '
  + 'SRO_NAME=:SRO_NAME, '
  + 'START_DATE=:START_DATE, '
  + 'END_DATE=:END_DATE '
  + 'WHERE ID=:ID';

type
  TBatchExporter = class
  private
    FFile: TStrings;
    FIndex: Integer;
    function GetStringPart(PartNumber: Integer): String;
    function GetAddress: String;
    function GetName: String;
    procedure GetParams(const ParamName: String; var ParamValue: Variant);
  public
    procedure ExportFromFile(const FileName: String; Connection: IKisConnection);
  end;

{ TKisLicensedOrg }

function TKisLicensedOrg.CheckEditor(AEditor: TKisEntityEditor): Boolean;
var
//  D1, D2: TDateTime;
  I, J: Integer;
begin
  Result := False;
  with TKisLicensedOrgEditor(AEditor) do
  begin
    if (Trim(edName.Text) = '') or BadFirmName(edName.Text, I, J) then
    begin
      edName.SelStart := I;
      edName.SelLength := J - I;
      Application.MessageBox(
        PChar(S_CHECK_NAME),
        PChar(S_WARN), MB_OK + MB_ICONWARNING);
      edName.SetFocus;
      Exit;
    end;
    if (Trim(edAddress.Text) = '') then
    begin
      Application.MessageBox(
        PChar(S_CHECK_ADDRESS),
        PChar(S_WARN), MB_OK + MB_ICONWARNING);
      edAddress.SetFocus;
      Exit;
    end;
    edStartDate.Text := '01.01.2000';  //ed
    {if (Trim(edStartDate.Text) = '') or not TryStrToDate(edStartDate.Text, D1) then
    begin
      Application.MessageBox(
        PChar(S_CHECK_LICENSE_START_DATE),
        PChar(S_WARN), MB_OK + MB_ICONWARNING);
      edStartDate.SetFocus;
      Exit;
    end; }
    edEndDate.Text := '01.01.2099';
    {if (Trim(edEndDate.Text) = '') or not TryStrToDate(edEndDate.Text, D2)
      or (D2 <= D1) then
    begin
      Application.MessageBox(
        PChar(S_CHECK_LICENSE_END_DATE),
        PChar(S_WARN), MB_OK + MB_ICONWARNING);
      edEndDate.SetFocus;
      Exit;
    end;}
  end;
  Result := True;
end;

procedure TKisLicensedOrg.Copy(Source: TKisEntity);
begin
  inherited;
  with TKisLicensedOrg(Source) do
  begin
    Self.FName := Name;
    Self.FStartDate := StartDate;
    Self.FEndDate := EndDate;
    Self.FAddress := Address;
    Self.FMapperFio := MapperFio;
    Self.FSROPeriodsCtrlr.DirectClear;
    CopyDataSet(SROPeriods, Self.SROPeriods);
  end;
end;

constructor TKisLicensedOrg.Create(Mngr: TKisMngr);
begin
  inherited;
  CreateSROPeriods(Self);
end;

function TKisLicensedOrg.CreateEditor: TKisEntityEditor;
begin
  Result := TKisLicensedOrgEditor.Create(Application);
end;

procedure TKisLicensedOrg.CreateSROPeriods(anOrg: TKisLicensedOrg);
begin
  anOrg.FSROPeriodsCtrlr := TKisLicensedOrgSROController.CreateController(anOrg.Manager, anOrg.Manager, keLicensedOrgSROPeriod);
  anOrg.FSROPeriodsCtrlr.HeadEntity := anOrg;
  anOrg.FSROPeriods := TCustomDataSet.Create(anOrg.Manager);
  anOrg.FSROPeriods.Controller := anOrg.FSROPeriodsCtrlr;
  anOrg.FSROPeriods.Open;
  anOrg.FSROPeriods.First;
end;

destructor TKisLicensedOrg.Destroy;
begin
  FSROPeriods.Close;
  FSROPeriods.Free;
  FSROPeriodsCtrlr.Free;
  inherited;
end;

class function TKisLicensedOrg.EntityName: String;
begin
  Result := 'Лицензированная организация';
end;

function TKisLicensedOrg.Equals(Entity: TKisEntity): Boolean;
var
  Org: TKisLicensedOrg;
begin
  Result := inherited Equals(Entity);
  if Result then
  begin
    Org := TKisLicensedOrg(Entity);
    Result := (Org.StartDate = Self.StartDate) and (Org.EndDate = Self.EndDate)
        and (Org.Name = Self.Name) and (Self.Address = Org.Address);
    if Result then
      Result := Result and Org.FSROPeriodsCtrlr.EqualsTo(FSROPeriodsCtrlr);
  end;
end;

function TKisLicensedOrg.FindSROPeriod(const aDate: TDateTime): TKisLicensedOrgSRO;
var
  I: Integer;
  Per: TKisLicensedOrgSRO;
  Date1: TDateTime;
  Date2: TDateTime;
begin
  Result := nil;
  for I := 1 to FSROPeriodsCtrlr.Count do
  begin
    Per := FSROPeriodsCtrlr.Elements[I] as TKisLicensedOrgSRO;
    if Per.GetStartDate(Date1) then
    begin
      if TDateTimeUtils.DateLOE(Date1, aDate) then
      begin
        if Trim(Per.EndDate) = '' then
        begin
          Result := Per;
          Exit;
        end;
        if Per.GetEndDate(Date2) then
          if TDateTimeUtils.DateLOE(aDate, Date2) then
          begin
            Result := Per;
            Exit;
          end;
      end;
    end;
  end;
end;

function TKisLicensedOrg.GetSROPeriods: TDataSet;
begin
  Result := FSROPeriods;
end;

function TKisLicensedOrg.GetText: String;
begin
  if not IsEmpty then
    Result := FName
  else
    Result := '';
end;

function TKisLicensedOrg.IsEmpty: Boolean;
begin
  Result := (FName = '') and (FStartDate = '') and (FEndDate = '')
    and (FAddress = '') and (FMapperFio = '');
end;

procedure TKisLicensedOrg.Load(DataSet: TDataSet);
begin
  inherited;
  with DataSet do
  begin
    Self.ID := FieldByName(SF_ID).AsInteger;
    Self.FName := FieldByName(SF_NAME).AsString;
    Self.FStartDate := FieldByName(SF_START_DATE).AsString;
    Self.FEndDate := FieldByName(SF_END_DATE).AsString;
    Self.FAddress := FieldByName(SF_ADDRESS).AsString;
    Self.FMapperFio := FieldByName(SF_MAPPER_FIO).AsString;
  end;
  TKisLicensedOrgMngr(Manager).LoadSROToOrg(Self);
end;

procedure TKisLicensedOrg.LoadDataIntoEditor(AEditor: TKisEntityEditor);
begin
  with TKisLicensedOrgEditor(AEditor) do
  begin
    edName.Text := Self.Name;
    edAddress.Text := Self.Address;
    edStartDate.Text := Self.StartDate;
    edEndDate.Text := Self.EndDate;
    edMapperFIo.Text := Self.MapperFio;
  end;
end;

procedure TKisLicensedOrg.PrepareEditor(Editor: TKisEntityEditor);
begin
  inherited;
  with TKisLicensedOrgEditor(Editor) do
  begin
    dsSROPeriods.DataSet := FSROPeriods;
    FSROPeriods.AfterInsert := SROPeriodsInsert;
    FSROPeriods.BeforeDelete := SROPeriodsBeforeDelete;
    FSROPeriods.AfterEdit := SROPeriodsEdit;
    FSROPeriods.Refresh;
  end;
end;

procedure TKisLicensedOrg.ReadDataFromEditor(AEditor: TKisEntityEditor);
begin
  inherited;
  with TKisLicensedOrgEditor(AEditor) do
  begin
    Self.Name := Trim(edName.Text);
    Self.Address :=  Trim(edAddress.Text);
    Self.StartDate := edStartDate.Text;
    Self.EndDate := edEndDate.Text;
    Self.MapperFio := Trim(edMapperFIo.Text);
  end;
end;

procedure TKisLicensedOrg.SetAddress(const Value: String);
begin
  if FAddress <> Value then
  begin
    FAddress := Value;
    Modified := True;
  end;
end;

procedure TKisLicensedOrg.SetEndDate(const Value: String);
begin
  if FEndDate <> Value then
  begin
    FEndDate := Value;
    Modified := True;
  end;
end;

procedure TKisLicensedOrg.SetMapperFio(const Value: String);
begin
  if FMapperFio <> Value then
  begin
    FMapperFio := Value;
    Modified := True;
  end;
end;

procedure TKisLicensedOrg.SetName(const Value: String);
begin
  if FName <> Value then
  begin
    FName := Value;
    Modified := True;
  end;
end;

procedure TKisLicensedOrg.SetStartDate(const Value: String);
begin
  if FStartDate <> Value then
  begin
    FStartDate := Value;
    Modified := True;
  end;
end;

procedure TKisLicensedOrg.SROPeriodsBeforeDelete(DataSet: TDataSet);
begin
  if DataSet.IsEmpty then
    Abort;
  if MessageBox(EntityEditor.Handle,
        PChar(S_CONFIRM_DELETE_SRO_PERIOD),
        PChar(S_CONFIRM),
        MB_YESNO + MB_ICONQUESTION) <> ID_YES
  then
    Abort;

end;

procedure TKisLicensedOrg.SROPeriodsEdit(DataSet: TDataSet);
begin
  // Здесь показвыаем редактор списания
  TKisVisualEntity(FSROPeriodsCtrlr.Elements[0]).ReadOnly := Self.ReadOnly;
  if not TKisVisualEntity(FSROPeriodsCtrlr.Elements[0]).Edit then
    DataSet.Cancel
  else
  begin
    DataSet.Post;
  end;
end;

procedure TKisLicensedOrg.SROPeriodsInsert(DataSet: TDataSet);
begin
  // Здесь показвыаем редактор списания
  TKisLicensedOrgSRO(FSROPeriodsCtrlr.Elements[0]).StartDate := FormatDateTime(S_DATESTR_FORMAT, Date);
  TKisLicensedOrgSRO(FSROPeriodsCtrlr.Elements[0]).EndDate := FormatDateTime(S_DATESTR_FORMAT, IncYear(Date, 1));
  TKisLicensedOrgSRO(FSROPeriodsCtrlr.Elements[0]).SROName := 'СРО';
  if not TKisVisualEntity(FSROPeriodsCtrlr.Elements[0]).Edit then
    DataSet.Cancel
  else
  begin
    DataSet.Post;
  end;
end;

procedure TKisLicensedOrg.UnprepareEditor(Editor: TKisEntityEditor);
begin
  with TKisLicensedOrgEditor(Editor) do
  begin
    dsSROPeriods.DataSet := nil;
    FSROPeriods.AfterInsert := nil;
    FSROPeriods.BeforeDelete := nil;
  end;
end;

procedure TKisLicensedOrgMngr.Activate;
begin
  dsLicensedOrgs.Transaction := AppModule.Pool.Get;
  dsLicensedOrgs.Transaction.Init(ilReadCommited, amReadWrite);
  if not dsLicensedOrgs.Transaction.Active then
    dsLicensedOrgs.Transaction.StartTransaction;
  Reopen;
end;

procedure TKisLicensedOrgMngr.CreateView;
begin
  inherited;
  FView.Caption := 'Лицензированные организации';
end;

procedure TKisLicensedOrgMngr.Deactivate;
begin
  if Assigned(dsLicensedOrgs.Transaction) then
  begin
    if dsLicensedOrgs.Transaction.Active then
      dsLicensedOrgs.Transaction.Commit;
    AppModule.Pool.Back(dsLicensedOrgs.Transaction);
    dsLicensedOrgs.Transaction := nil;
  end;
end;

function TKisLicensedOrgMngr.GenEntityID(EntityKind: TKisEntities): Integer;
var
  Conn: IKisConnection;
  S: string;
begin
  case EntityKind of
  keDefault, keLicensedOrg :
    Result := AppModule.GetID(SG_LICENSED_ORGS, Self.DefaultTransaction);
  keLicensedOrgSROPeriod :
    Result := AppModule.GetID(SG_LICENSED_ORG_SRO_PERIODS, Self.DefaultTransaction);
  else
    raise Exception.CreateFmt(S_GEN_ID_ERROR, [KisMngrNames[Self.Ident]]);
  end;
end;

function TKisLicensedOrgMngr.GetIdent: TKisMngrs;
begin
  Result := kmLicensedOrgs;
end;

function TKisLicensedOrgMngr.GetMainSQLText: String;
begin
  Result := SQ_MAIN;
end;

function TKisLicensedOrgMngr.IsSupported(Entity: TKisEntity): Boolean;
begin
  Result := Assigned(Entity) and ((Entity is TKisLicensedOrg) or (Entity is TKisLicensedOrgSRO));
end;

procedure TKisLicensedOrgMngr.LoadSROToOrg(aOrg: TKisLicensedOrg);
var
  Tmp: TKisEntity;
  Conn: IKisConnection;
begin
  // [!!!] Переписать! Убрать GetEntity! Заменить одним запросом + CreateEntity + Load
  Conn := GetConnection(True, False);
  try
    with Conn.GetDataSet(Format(SQ_GET_SRO_LIST_ID, [aOrg.Id])) do
    begin
      Open;
      while not Eof do
      begin
        Tmp := GetEntity(FieldByName(SF_ID).AsInteger, keLicensedOrgSROPeriod);
        if Assigned(Tmp) then
          aOrg.FSROPeriodsCtrlr.DirectAppend(Tmp);
        Next;
      end;
      Close;
    end;
  finally
    FreeConnection(Conn, True);
  end;
end;

procedure TKisLicensedOrgMngr.Locate(AId: Integer; LocateFail: Boolean);
var
  Bkm: Pointer;
begin
  inherited;
  if dsLicensedOrgs.Active and not dsLicensedOrgs.IsEmpty then
  begin
    dsLicensedOrgs.DisableControls;
    try
      Bkm := dsLicensedOrgs.GetBookmark;
      try
        if not dsLicensedOrgs.LocateNext(SF_ID, AId, []) then
          dsLicensedOrgs.GotoBookmark(Bkm);
      finally
        dsLicensedOrgs.FreeBookmark(Bkm);
      end;
    finally
      dsLicensedOrgs.EnableControls;
    end;
  end;
end;

procedure TKisLicensedOrgMngr.dsLicensedOrgsBeforeOpen(DataSet: TDataSet);
begin
  inherited;
  dsLicensedOrgs.SelectSQL.Text := FSQLHelper.Parser.Text;
  dsLicensedOrgs.RefreshSQL.Text := GetMainSQLtext + ' WHERE LICENSED_ORGS.ID=:ID';
end;

procedure TKisLicensedOrgMngr.PrepareSQLHelper;
begin
  inherited;
  with FSQLHelper.AddTable do
  begin
    TableName := ST_LICENSED_ORGS;
    TableLabel := 'Основная (организации)';
    AddStringField(SF_NAME, SFL_NAME, 300, [fpSearch, fpSort, fpQuickSearch]);
    AddStringField(SF_ADDRESS, SFL_ADDRESS, 255, [fpSearch, fpSort, fpQuickSearch]);
  end;
end;

function TKisLicensedOrgMngr.GetMainDataSet: TDataSet;
begin
  Result := dsLicensedOrgs;
end;

function TKisLicensedOrgMngr.GetRefreshSQLText: String;
begin
  Result := SQ_MAIN_BASE + ' WHERE LO.ID=:OLD_ID';
end;

function TKisLicensedOrgMngr.GetEntity(EntityID: Integer; EntityKind: TKisEntities): TKisEntity;
var
  Conn: IKisConnection;
  S: String;
  DataSet: TDataSet;
begin
  Result := nil;
  Conn := GetConnection(True, False);
  try
    case EntityKind of
    keDefault, keLicensedOrg :
      S := Format(SQ_SELECT_LICENSED_ORG, [EntityID]);
    keLicensedOrgSROPeriod :
      S := Format(SQ_SELECT_SRO_PERIOD, [EntityID]);
    else
      raise ELoadEntity.Create(EntityID, EntityKind);
    end;
    DataSet := Conn.GetDataSet(S);
    with DataSet do
    begin
      Open;
      if not IsEmpty then
      begin
        Result := CreateEntity(EntityKind);
        Result.Load(DataSet);
      end;
      Close;
    end;
  finally
    FreeConnection(Conn, True);
  end;
end;

function TKisLicensedOrgMngr.CreateEntity(EntityKind: TKisEntities): TKisEntity;
begin
  case EntityKind of
  keDefault, keLicensedOrg :
    begin
      Result := TKisLicensedOrg.Create(Self);
    end;
  keLicensedOrgSROPeriod :
    begin
      Result := TKisLicensedOrgSRO.Create(Self);
    end;
  else
    Result := nil;
  end;
end;

function TKisLicensedOrgMngr.CreateNewEntity(EntityKind: TKisEntities): TKisEntity;
begin
  Result := CreateEntity(EntityKind);
  if Assigned(Result) then
    Result.ID := GenEntityID(EntityKind);
end;

function TKisLicensedOrgMngr.DeleteEntity(Entity: TKisEntity): Boolean;
var
  Conn: IKisConnection;
  CanDelete: Boolean;
begin
  Conn := nil;
//  if IsEntityInUse(Entity) then
//    inherited
//  else
//  try
//    Conn := GetConnection(True, True);
//    Conn.GetDataSet(Format(SQ_DELETE_LICENSED_ORG, [Entity.ID])).Open;
//    FreeConnection(Conn, True);
//  except
//    FreeConnection(Conn, False);
//    raise;
//  end;
  Conn := GetConnection(True, True);
  try
    try
      Conn.GetDataSet(Format(SQ_DELETE_LICENSED_ORG, [Entity.ID])).Open;
      CanDelete := True;
    except
      CanDelete := False;
    end;
  finally
    FreeConnection(Conn, False);
  end;
  //
  if not CanDelete {or IsEntityInUse(Entity)} then
  begin
    Result := False;
    inherited DeleteEntity(Entity);
  end
  else
  try
    Conn := GetConnection(True, True);
    Conn.GetDataSet(Format(SQ_DELETE_LICENSED_ORG, [Entity.ID])).Open;
    FreeConnection(Conn, True);
    Result := True;
  except
    FreeConnection(Conn, False);
    raise;
  end;
end;

procedure TKisLicensedOrgMngr.SaveLicensedOrg(aEntity: TKisLicensedOrg);
var
  Conn: IKisConnection;
  DS: TDataSet;
  I: Integer;
begin
  Conn := GetConnection(True, True);
  try
    DS := Conn.GetDataSet(Format(SQ_SAVE_LICENSED_ORG,
    // :ID, :NAME, :ADDRESS, :START_DATE, :END_DATE, :MAPPER_FIO
      [aEntity.ID, aEntity.Name, aEntity.Address, aEntity.StartDate, aEntity.EndDate, aEntity.MapperFio]));
    DS.Open;
    // Сохраняем список СРО
    with aEntity.FSROPeriodsCtrlr do
    begin
      for I := 1 to Count do
        if Elements[I].Modified then
          Self.SaveEntity(Elements[I]);
      for I := 0 to Pred(DeletedCount) do
        Self.DeleteEntity(DeletedElements[I]);
    end;
    FreeConnection(Conn, True);
  except
    FreeConnection(Conn, False);
    raise;
  end;
end;

procedure TKisLicensedOrgMngr.SaveSRO(Entity: TKisLicensedOrgSRO);
var
  Conn: IKisConnection;
  DS, Ds2: TDataSet;
  Date1Str, Date2Str: string;
  D1, D2: TDateTime;
  DoInsert: Boolean;
begin
  Conn := GetConnection(True, True);
  try
    DS := Conn.GetDataSet(SQ_FIND_LICENSED_ORG_SRO_PERIOD);
    try
      Conn.SetParam(DS, SF_ID, Entity.ID);
      Ds.Open;
      DoInsert := DS.IsEmpty;
    finally
      DS.Close;
    end;
    //
    if Entity.ID < 1 then
      Entity.ID := GenEntityID(keLicensedOrgSROPeriod);
    //
    if DoInsert then
      DS2 := Conn.GetDataSet(SQ_INSERT_LICENSED_ORG_SRO_PERIOD)
    else
      DS2 := Conn.GetDataSet(SQ_UPDATE_LICENSED_ORG_SRO_PERIOD);
    //
    Conn.SetParam(DS2, SF_ID, Entity.ID);
    Conn.SetParam(DS2, SF_LICENSED_ORGS_ID, Entity.HeadId);
    Conn.SetParam(DS2, SF_SRO_NAME, Entity.SROName);
    Date1Str := Trim(Entity.StartDate);
    if TryStrToDate(Date1Str, D1) then
      Conn.SetParam(DS2, SF_START_DATE, D1)
    else
      Conn.SetParam(DS2, SF_START_DATE, Null);
    Date2Str := Trim(Entity.EndDate);
    if TryStrToDate(Date2Str, D2) then
      Conn.SetParam(DS2, SF_END_DATE, D2)
    else
      Conn.SetParam(DS2, SF_END_DATE, Null);
    DS2.Open;
    //
    FreeConnection(Conn, True);
  except
    FreeConnection(Conn, False);
    raise;
  end;
end;

procedure TKisLicensedOrgMngr.SaveEntity(aEntity: TKisEntity);
begin
  inherited;
  try
    if Assigned(aEntity) then
    if IsSupported(aEntity) then
    if (aEntity is TKisLicensedOrg) then
      SaveLicensedOrg(aEntity as TKisLicensedOrg)
    else
      if (aEntity is TKisLicensedOrgSRO) then
        SaveSRO(aEntity as TKisLicensedOrgSRO);
  except
    //on E: EKisLetterError do
      //HandleKisLetterError(E, Entity);
    raise;
  end;
end;

function TKisLicensedOrgMngr.IsEntityInUse(Entity: TKisEntity): Boolean;
begin
  Result := True;
end;

function TKisLicensedOrgMngr.CurrentEntity: TKisEntity;
begin
  if dsLicensedOrgs.Active then
    Result := GetEntity(dsLicensedOrgsID.AsInteger)
  else
    Result := nil;
end;

procedure TKisLicensedOrgMngr.acExportExecute(Sender: TObject);
var
  Conn: IKisConnection;
begin
  inherited;
  with TOpenDialog.Create(Self) do
  begin
    Filter := 'Текстовые файлы|*.txt';
    if Execute then
      if FileExists(FileName) then
      begin
        Conn := GetConnection(True, True);
        try
          with IObject(TBatchExporter.Create).AObject as TBatchExporter do
            ExportFromFile(FileName, Conn);
          FreeConnection(Conn, True);
        except
          FreeConnection(Conn, False);
        end;
        if Self.Active then
          Self.Reopen;
      end;
  end;
end;

{ TBatchExporter }

procedure TBatchExporter.ExportFromFile(const FileName: String;
  Connection: IKisConnection);
var
  DataSet: TDataSet;
  I: Integer;
begin
  if not Assigned(FFile) then
    FFile := TStringList.Create;
  FFile.LoadFromFile(FileName);
  DataSet := Connection.GetDataSet('INSERT INTO LICENSED_ORGS (ID, NAME, ADDRESS) VALUES (GEN_ID(LICENSED_ORGS_GEN, 1), :NAME, :ADDRESS)');
  Connection.OnNeedParam[DataSet] := GetParams;
  for I := 0 to Pred(FFile.Count) do
  begin
    FIndex := I;
    DataSet.Open;
    DataSet.Active:= False;
  end;
end;

function TBatchExporter.GetAddress: String;
begin
  Result := GetStringPart(2);
end;

function TBatchExporter.GetName: String;
begin
  Result := GetStringPart(1);
end;

procedure TBatchExporter.GetParams(const ParamName: String;
  var ParamValue: Variant);
begin
  if ParamName = SF_NAME then
    ParamValue := GetName
  else
  if ParamName = SF_ADDRESS then
    ParamValue := GetAddress
  else
    ParamValue := NULL;
end;

function TBatchExporter.GetStringPart(PartNumber: Integer): String;
var
  S: String;
  I, Count: Integer;
begin
  S := FFile[FIndex];
  I := Pos(#9, S);
  Count := 0;
  while (I > 0) and (Count < PartNumber) do
  begin
    Inc(Count);
    Delete(S, 1, I);
    I := Pos(#9, S);
  end;
  if I < 1 then
    I := Length(S);
  Result := Copy(S, 1, I);
end;

{ TKisLicensedOrgSRO }

function TKisLicensedOrgSRO.CheckEditor(AEditor: TKisEntityEditor): Boolean;
var
  D1, D2: TDateTime;
  I, J: Integer;
  Ed: TKisLicensedOrgSROPeriodEditor;
begin
  Result := False;
  Ed := TKisLicensedOrgSROPeriodEditor(AEditor);
  if (Trim(Ed.edSROName.Text) = '') or BadFirmName(Ed.edSROName.Text, I, J) then
  begin
    Ed.edSROName.SelStart := I;
    Ed.edSROName.SelLength := J - I;
    Application.MessageBox(
      PChar(S_CHECK_NAME),
      PChar(S_WARN), MB_OK + MB_ICONWARNING);
    Ed.edSROName.SetFocus;
    Exit;
  end;
//  if (Trim(Ed.edAddress.Text) = '') then
//  begin
//    Application.MessageBox(
//      PChar(S_CHECK_ADDRESS),
//      PChar(S_WARN), MB_OK + MB_ICONWARNING);
//    edAddress.SetFocus;
//    Exit;
//  end;
  if (Trim(Ed.edPeriodStartDate.Text) = '') or not TryStrToDate(Ed.edPeriodStartDate.Text, D1) then
  begin
    Application.MessageBox(
      PChar(S_CHECK_SRO_START_DATE),
      PChar(S_WARN), MB_OK + MB_ICONWARNING);
    Ed.edPeriodStartDate.SetFocus;
    Exit;
  end;
  if Trim(Ed.edPeriodEndDate.Text) <> '' then
  begin
    if not TryStrToDate(Ed.edPeriodEndDate.Text, D2)
      or (D2 <= D1)
    then
    begin
      Application.MessageBox(
        PChar(S_CHECK_SRO_END_DATE),
        PChar(S_WARN), MB_OK + MB_ICONWARNING);
      Ed.edPeriodEndDate.SetFocus;
      Exit;
    end;
  end;
  Result := True;
end;

procedure TKisLicensedOrgSRO.Copy(Source: TKisEntity);
begin
  inherited;
  Self.FStartDate := TKisLicensedOrgSRO(Source).StartDate;
  Self.FEndDate := TKisLicensedOrgSRO(Source).EndDate;
  Self.FSROName := TKisLicensedOrgSRO(Source).SROName;
end;

function TKisLicensedOrgSRO.CreateEditor: TKisEntityEditor;
begin
  Result := TKisLicensedOrgSROPeriodEditor.Create(Manager);
end;

class function TKisLicensedOrgSRO.EntityName: String;
begin
  Result := 'Период в составе СРО';
end;

function TKisLicensedOrgSRO.Equals(Entity: TKisEntity): Boolean;
var
  Org: TKisLicensedOrgSRO;
begin
  Org := TKisLicensedOrgSRO(Entity);
  Result := (Entity <> nil) and
            (Entity.ClassName = Self.ClassName) and
            (Org.SROName = Self.SROName) and
            (Org.StartDate = Self.StartDate) and
            (Org.EndDate = Self.EndDate);
end;

function TKisLicensedOrgSRO.GetEndDate(out aDate: TDateTime): Boolean;
begin
  Result := TryStrToDate(FEndDate, aDate);
end;

function TKisLicensedOrgSRO.GetStartDate(out aDate: TDateTime): Boolean;
begin
  Result := TryStrToDate(FStartDate, aDate);
end;

function TKisLicensedOrgSRO.GetText: String;
begin
  Result := FSROName + ' с ' + FStartDate;
  if FEndDate <> '' then
    Result := Result + ' по ' + FEndDate;
end;

function TKisLicensedOrgSRO.IsEmpty: Boolean;
begin
  Result := (FSROName = '') and (FStartDate = '') and (FEndDate = '');
end;

procedure TKisLicensedOrgSRO.Load(DataSet: TDataSet);
begin
  inherited;
  ID := DataSet.FieldByName(SF_ID).AsInteger;
  SROName := DataSet.FieldByName(SF_SRO_NAME).AsString;
  StartDate := DataSet.FieldByName(SF_START_DATE).AsString;
  EndDate := DataSet.FieldByName(SF_END_DATE).AsString;
  Self.Modified := True;
end;

procedure TKisLicensedOrgSRO.LoadDataIntoEditor(AEditor: TKisEntityEditor);
begin
  inherited;
  with TKisLicensedOrgSROPeriodEditor(AEditor) do
  begin
    edSROName.Text := Self.SROName;
    edPeriodStartDate.Text := Self.StartDate;
    edPeriodEndDate.Text := Self.EndDate;
  end;
end;

procedure TKisLicensedOrgSRO.PrepareEditor(Editor: TKisEntityEditor);
begin
  inherited;
  ;
end;

procedure TKisLicensedOrgSRO.ReadDataFromEditor(AEditor: TKisEntityEditor);
begin
  inherited;
  with TKisLicensedOrgSROPeriodEditor(AEditor) do
  begin
    Self.SROName := edSROName.Text;
    Self.StartDate := edPeriodStartDate.Text;
    Self.EndDate := edPeriodEndDate.Text;
  end;
end;

procedure TKisLicensedOrgSRO.SetEndDate(const Value: String);
begin
  if FEndDate <> Value then
  begin
    FEndDate := Value;
    Modified := True;
  end;
end;

procedure TKisLicensedOrgSRO.SetSROName(const Value: string);
begin
  if FSROName <> Value then
  begin
    FSROName := Value;
    Modified := True;
  end;
end;

procedure TKisLicensedOrgSRO.SetStartDate(const Value: String);
begin
  if FStartDate <> Value then
  begin
    FStartDate := Value;
    Modified := True;
  end;
end;

procedure TKisLicensedOrgSRO.UnprepareEditor(Editor: TKisEntityEditor);
begin
  inherited;
  ;
end;

{ TKisLicensedOrgSROController }

procedure TKisLicensedOrgSROController.FillFieldDefs(FieldDefsRef: TFieldDefs);
begin
  inherited;
{   LETTERS_ID  INTEGER NOT NULL,
    ID          SMALLINT NOT NULL,
    DOC_DATE    TIMESTAMP NOT NULL,
    CONTENT     VARCHAR(150) COLLATE PXW_CYRL,
    OFFICES_ID  SMALLINT NOT NULL,
    PEOPLE_ID   INTEGER NOT NULL,
    ORGS_ID     INTEGER}
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
    Name := SF_LICENSED_ORGS_ID;
  end;
  with FieldDefsRef.AddFieldDef do
  begin
    DataType := ftString;
    FieldNo := 3;
    Size := 10;
    Name := SF_START_DATE;
  end;
  with FieldDefsRef.AddFieldDef do
  begin
    DataType := ftString;
    FieldNo := 4;
    Size := 10;
    Name := SF_END_DATE;
  end;
  with FieldDefsRef.AddFieldDef do
  begin
    DataType := ftString;
    FieldNo := 5;
    Size := 255;
    Name := SF_SRO_NAME;
  end;
end;

function TKisLicensedOrgSROController.GetDeleteQueryText: String;
var
  IDList: String;
  I: Integer;
begin
  Result := 'DELETE FROM LICENSED_ORG_SRO_PERIODS WHERE ID IN (%s)';
  IDList := '';
  for I := 0 to Pred(DeletedCount) do
  begin
    if I > 0 then
      IDList := IDList + ',';
    IDList := IDList + IntToStr(DeletedElements[I].ID);
  end;
  Result := Format(Result, [IDList]);
end;

function TKisLicensedOrgSROController.GetFieldData(Index: Integer; Field: TField; out Data): Boolean;
var
  Ent: TKisLicensedOrgSRO;
begin
  try
    Ent := TKisLicensedOrgSRO(Elements[Index]);
    case Field.FieldNo of
    1 : GetInteger(Ent.ID, Data);
    2 : GetInteger(Ent.HeadId, Data);
    3 : GetString(Ent.StartDate, Data);
    4 : GetString(Ent.EndDate, Data);
    5 : GetString(Ent.SROName, Data);
    else
      raise EDatabaseError.CreateFmt(S_FIELD_NOT_FOUND, [Field.FieldName]);
    end;
    Result := True;
  except
    Result := False;
  end;
end;

procedure TKisLicensedOrgSROController.SetFieldData(Index: integer; Field: TField; var Data);
var
  Ent: TKisLicensedOrgSRO;
begin
  try
    Ent := TKisLicensedOrgSRO(Elements[Index]);
    case Field.FieldNo of
    1 : Ent.ID := SetInteger(Data);
    2 : ;//Ent.HeadId := SetInteger(Data);
    3 : Ent.StartDate := SetString(Data);
    4 : Ent.EndDate := SetString(Data);
    5 : Ent.SROName := SetString(Data);
    end;
  except
  end;
end;

{ TKisLicensedOrgTempList }

function TKisLicensedOrgTempList.Add(aOrg: TKisLicensedOrg): Integer;
begin
  Result := FList.Add(aOrg);
end;

constructor TKisLicensedOrgTempList.Create;
begin
  FList := TObjectList.Create(True);
end;

destructor TKisLicensedOrgTempList.Destroy;
begin
  FList.Free;
  inherited;
end;

function TKisLicensedOrgTempList.Find(aOrgId: Integer): TKisLicensedOrg;
var
  I: Integer;
begin
  for I := 0 to FList.Count - 1 do
    if TKisLicensedOrg(FList[I]).ID = aOrgId then
    begin
      Result := TKisLicensedOrg(FList[I]);
      Exit;
    end;
  Result := nil;
end;

end.


