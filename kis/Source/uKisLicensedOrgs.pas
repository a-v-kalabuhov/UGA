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
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, DB, ImgList, ActnList, IBCustomDataSet, IBQuery,
  uKisSQLClasses, uKisClasses, uKisEntityEditor, uKisAppModule;

type
  TKisLicensedOrg = class(TKisVisualEntity)
  private
    FName: String;
    FStartDate: String;
    FEndDate: String;
    FAddress: String;
    FMapperFio: String;
    procedure SetName(const Value: String);
    procedure SetStartDate(const Value: String);
    procedure SetEndDate(const Value: String);
    procedure SetAddress(const Value: String);
    procedure SetMapperFio(const Value: String);
  protected
    function GetText: String; override;
    function CreateEditor: TKisEntityEditor; override;
    procedure LoadDataIntoEditor(AEditor: TKisEntityEditor); override;
    procedure ReadDataFromEditor(AEditor: TKisEntityEditor); override;
    function CheckEditor(AEditor: TKisEntityEditor): Boolean; override;
  public
    class function EntityName: String; override;
    procedure Copy(Source: TKisEntity); override;
    procedure Load(DataSet: TDataSet); override;
    function IsEmpty: Boolean; override;
    function Equals(Entity: TKisEntity): Boolean; override;
    property Name: String read FName write SetName;
    property Address: String read FAddress write SetAddress;
    property StartDate: String read FStartDate write SetStartDate;
    property EndDate: String read FEndDate write SetEndDate;
    property MapperFio: String read FMapperFio write SetMapperFio;
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
    procedure SaveEntity(Entity: TKisEntity); override;
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
  uKisLicensedOrgEditor, uKisUtils, uKisConsts, uKisIntf, uKisSearchClasses;

const
  SQ_MAIN_BASE = //'SELECT LO.* FROM LICENSED_ORGS LO ';
    'SELECT LO.ID, LO.NAME, LO.ADDRESS, LO.START_DATE, LO.END_DATE, LO.MAPPER_FIO '
  + 'FROM LICENSED_ORGS LO ';
  SQ_MAIN = SQ_MAIN_BASE + ' WHERE (LO.ID > 0)';
  SQ_SELECT_LICENSED_ORG = SQ_MAIN_BASE + ' WHERE (LO.ID=%d)';
  SQ_SAVE_LICENSED_ORG = 'EXECUTE PROCEDURE SAVE_LICENSED_ORG('
   // :ID, :NAME, :ADDRESS, :START_DATE, :END_DATE, :MAPPER_FIO)
    + '%d, ''%s'', ''%s'', ''%s'', ''%s'', ''%s'')';
  SQ_DELETE_LICENSED_ORG = 'DELETE FROM LICENSED_ORGS WHERE ID=%d';

  SG_LICENSED_ORGS = 'LICENSED_ORGS';


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
  end;
end;

function TKisLicensedOrg.CreateEditor: TKisEntityEditor;
begin
  Result := TKisLicensedOrgEditor.Create(Application);
end;

class function TKisLicensedOrg.EntityName: String;
begin
  Result := 'Лицензированная организация';
end;

function TKisLicensedOrg.Equals(Entity: TKisEntity): Boolean;
begin
  Result := inherited Equals(Entity);
  if Result then
  with TKisLicensedOrg(Entity) do
    Result := (StartDate = Self.StartDate) and (EndDate = Self.EndDate)
      and (Name = Self.Name) and (Self.Address = Address);
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
end;

procedure TKisLicensedOrg.LoadDataIntoEditor(AEditor: TKisEntityEditor);
begin
  inherited;
  with TKisLicensedOrgEditor(AEditor) do
  begin
    edName.Text := Self.Name;
    edAddress.Text := Self.Address;
    edStartDate.Text := Self.StartDate;
    edEndDate.Text := Self.EndDate;
    edMapperFIo.Text := Self.MapperFio;
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

function TKisLicensedOrgMngr.GenEntityID(
  EntityKind: TKisEntities): Integer;
var
  Conn: IKisConnection;
begin
  Conn := GetConnection(True, False);
  try
    Result := AppModule.GetID(SG_LICENSED_ORGS, Conn.Transaction);
  finally
    FreeConnection(Conn, True);
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
  Result := Assigned(Entity) and (Entity is TKisLicensedOrg);
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

function TKisLicensedOrgMngr.GetEntity(EntityID: Integer;
  EntityKind: TKisEntities): TKisEntity;
var
  Q: TIBDataSet;
  Conn: IKisConnection;
begin
  Result := nil;
  Conn := GetConnection(True, False);
  Q := IObject(TIBDataSet.Create(Self)).AObject as TIBDataSet;
  with Q do
  try
    Transaction := Conn.Transaction;
    SelectSQL.Text := Format(SQ_SELECT_LICENSED_ORG, [EntityID]);
    Open;
    if not IsEmpty then
    begin
      Result := CreateEntity(EntityKind);
      Result.Load(Q);
    end;
    Close;
  finally
    FreeConnection(Conn, True);
  end;
end;

function TKisLicensedOrgMngr.CreateEntity(
  EntityKind: TKisEntities): TKisEntity;
begin
  Result := TKisLicensedOrg.Create(Self);
end;

function TKisLicensedOrgMngr.CreateNewEntity(
  EntityKind: TKisEntities): TKisEntity;
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

procedure TKisLicensedOrgMngr.SaveEntity(Entity: TKisEntity);
var
  Conn: IKisConnection;
  DS: TDataSet;
  LO: TKisLicensedOrg;
begin
  Conn := GetConnection(True, True);
  try
    LO := Entity as TKisLicensedOrg;
    DS := Conn.GetDataSet(Format(SQ_SAVE_LICENSED_ORG,
    // :ID, :NAME, :ADDRESS, :START_DATE, :END_DATE, :MAPPER_FIO
      [Entity.ID, LO.Name, LO.Address, LO.StartDate, LO.EndDate, LO.MapperFio]));
    DS.Open;
    FreeConnection(Conn, True);
  except
    FreeConnection(Conn, False);
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

end.


