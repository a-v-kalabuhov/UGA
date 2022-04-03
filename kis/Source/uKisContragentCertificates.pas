{*******************************************************}
{                                                       }
{       "ИС МП УГА"                                     }
{       Менеджер сертификатов контрагента               }
{                                                       }
{       Copyright (c) 2003, МП УГА                      }
{                                                       }
{       Автор: Калабухов А.В.                           }
{                                                       }
{*******************************************************}

{ Описание: реализует операции над сертификатами контрагентов
  Имя модуля: Contragent Certificates
  Версия: 1.0
  Дата последнего изменения: 27.06.2004
  Цель: содержит классы - менеджер сертификатов контрагентов, сертификат контрагента.
  Используется:
  Использует:   Kernel Classes
  Исключения:   }

unit uKisContragentCertificates;

interface

{$I KisFlags.pas}

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  DB, ImgList, ActnList, IBDatabase,
  // Project
  uKisClasses, uKisEntityEditor, uKisSQLClasses;

type
  TKisContragentCertificate = class(TKisEntity)
  private
    FNumber: String;
    FCertDate: TDate;
    FGivenBy: String;
    FBusiness: String;
    procedure SetNumber(const Value: String);
    procedure SetCertDate(const Value: TDate);
    procedure SetGivenBy(const Value: String);
    procedure SetBusiness(const Value: String);
  protected
    function GetText: String; override;
  public
    constructor Create(Mngr: TKisMngr); override;
    class function EntityName: String; override;
    procedure Copy(Source: TKisEntity); override;
    function IsEmpty: Boolean; override;
    function Equals(Entity: TKisEntity): Boolean; override;
    procedure Load(DataSet: TDataSet); override;
    property Number: String read FNumber write SetNumber;
    property CertDate: TDate read FCertDate write SetCertDate;
    property GivenBy: String read FGivenBy write SetGivenBy;
    property Business: String read FBusiness write SetBusiness;
  end;

  TKisContragentCertificateMngr = class(TKisSQLMngr)
  protected
    function GenEntityID(EntityKind: TKisEntities = keDefault): Integer; override;
    function GetIdent: TKisMngrs; override;
    function IsSupported(Entity: TKisEntity): Boolean; override;
    function GetMainSQLText: String; override;
    function GetRefreshSQLText: String; override;
    function GetMainDataSet: TDataSet; override;
  public
    function GetEntity(EntityID: Integer; EntityKind: TKisEntities = keDefault): TKisEntity; override;
    function IsEntityInUse(Entity: TKisEntity): Boolean; override;
    function CreateNewEntity(EntityKind: TKisEntities = keDefault): TKisEntity; override;
    function CreateEntity(EntityKind: TKisEntities): TKisEntity; override;
    procedure SaveEntity(Entity: TKisEntity); override;
  end;

implementation

{$R *.dfm}

uses
  IBQuery,
  // Common
  uIBXUtils, uGC,
  // Project
  uKisAppModule, uKisConsts, uKisIntf;

const
  SG_CERTIF = 'CONTR_PRIVATES_CERTIFICATES';

  SQ_SELECT_CERTIFICATE = 'SELECT * FROM CONTR_PRIVATES_CERTIFICATES WHERE ID=%d';
  SQ_SAVE_CERTIFICATE = 'EXECUTE PROCEDURE SAVE_CONTR_CERTIFICATE(%d, '
    + '''%s'', ''%s'', ''%s'', ''%s'')';
  SQ_CERTIFICATE_IN_USE = 'SELECT COUNT(*) FROM CONTR_PRIVATES WHERE CERTIF_ID=%d';

{ TKisContragectCertificate }

procedure TKisContragentCertificate.Copy(Source: TKisEntity);
begin
  inherited;
  with Source as TKisContragentCertificate do
  begin
    Self.Number := Number;
    Self.CertDate := CertDate;
    Self.GivenBy := GivenBy;
    Self.Business := Business;
  end;
end;

constructor TKisContragentCertificate.Create(Mngr: TKisMngr);
begin
  inherited;
  FCertDate := Date;
end;

class function TKisContragentCertificate.EntityName: String;
begin
  Result := 'Сертификат';
end;

function TKisContragentCertificate.Equals(Entity: TKisEntity): Boolean;
begin
  inherited Equals(Entity);
  with Entity as TKisContragentCertificate do
    Result := (Self.FNumber = Number) and (Self.FCertDate = CertDate) and
      (Self.FGivenBy = GivenBy) and (Self.FBusiness = Business);
end;

function TKisContragentCertificate.GetText: String;
begin
  if IsEmpty then
    Result := ''
  else
    Result := '№' + Self.FNumber + ', ' + Self.FBusiness;
end;

function TKisContragentCertificate.IsEmpty: Boolean;
begin
  Result := (FGivenBy = '') and (FNumber = '') and (FBusiness = '') and
    (FCertDate = Date);
end;

procedure TKisContragentCertificate.Load(DataSet: TDataSet);
begin
  inherited;
  with DataSet do
  begin
    ID := FieldByName(SF_ID).AsInteger;
    Number := FieldByName(SF_NUMBER).AsString;
    GivenBy := FieldByName(SF_OWNER).AsString;
    Business := FieldByName(SF_BUSINNES).AsString;
    CertDate := FieldByName(SF_CERT_DATE).AsDateTime;
  end;
end;

procedure TKisContragentCertificate.SetBusiness(const Value: String);
begin
  if FBusiness <> Value then
  begin
    FBusiness := Value;
    Modified := True;
  end;
end;

procedure TKisContragentCertificate.SetCertDate(const Value: TDate);
begin
  //if FCertDate <> Value then
  if DateToStr(FCertDate) <> DateToStr(Value) then
  begin
    FCertDate := Value;
    Modified := True;
  end;
end;

procedure TKisContragentCertificate.SetNumber(const Value: String);
begin
  if FNumber <> Value then
  begin
    FNumber := Value;
    Modified := True;
  end;
end;

procedure TKisContragentCertificate.SetGivenBy(const Value: String);
begin
  if FGivenBy <> Value then
  begin
    FGivenBy := Value;
    Modified := True;
  end;
end;

{ TKisContragentCertificates }

function TKisContragentCertificateMngr.CreateEntity(
  EntityKind: TKisEntities): TKisEntity;
begin
  Result := TKisContragentCertificate.Create(Self);
end;

function TKisContragentCertificateMngr.CreateNewEntity(EntityKind: TKisEntities = keDefault): TKisEntity;
begin
  Result := TKisContragentCertificate.Create(Self);
  Result.ID := GenEntityID();
end;

function TKisContragentCertificateMngr.GenEntityID(EntityKind: TKisEntities = keDefault): Integer;
begin
  Result := AppModule.GetID(SG_CERTIF, Self.DefaultTransaction);
end;

function TKisContragentCertificateMngr.GetEntity(EntityID: Integer;
  EntityKind: TKisEntities = keDefault): TKisEntity;
var
  Conn: IKisConnection;
  DataSet: TDataSet;
begin
  Conn := GetConnection(True, False);
  DataSet := Conn.GetDataSet(Format(SQ_SELECT_CERTIFICATE, [EntityID]));
  try
    DataSet.Open;
    if DataSet.IsEmpty then
      Result := nil
    else
    begin
      Result := TKisContragentCertificate.Create(Self);
      Result.Load(DataSet);
    end;
  finally
    FreeConnection(Conn, True);
  end;
end;

function TKisContragentCertificateMngr.GetIdent: TKisMngrs;
begin
  Result := kmContrCertificates;
end;

function TKisContragentCertificateMngr.GetMainDataSet: TDataSet;
begin
  Result := nil;
end;

function TKisContragentCertificateMngr.GetMainSQLText: String;
begin
  Result := '';
end;

function TKisContragentCertificateMngr.GetRefreshSQLText: String;
begin
  Result := '';
end;

function TKisContragentCertificateMngr.IsEntityInUse(Entity: TKisEntity): Boolean;
var
  Conn: IKisConnection;
begin
  Conn := GetConnection(True, False);
  try
    with Conn.GetDataSet(Format(SQ_CERTIFICATE_IN_USE, [Entity.ID])) do
    begin
      Open;
      Result := Fields[N_ZERO].AsInteger > N_ZERO;
      Close;
    end;
  finally
    FreeConnection(Conn, True);
  end;
end;

function TKisContragentCertificateMngr.IsSupported(
  Entity: TKisEntity): Boolean;
begin
  Result := Entity is TKisContragentCertificate;
  if not Result then
    Result := inherited IsSupported(Entity);
end;

procedure TKisContragentCertificateMngr.SaveEntity(Entity: TKisEntity);
var
  Conn: IKisConnection;
  Sql: string;
begin
  if not IsSupported(Entity) then
    Exit;
  Conn := GetConnection(True, True);
  try
    while (Entity.ID = N_ZERO) or IsEntityInUse(Entity) do
      Entity.ID := GenEntityId();
    with TKisContragentCertificate(Entity) do
    begin
      Sql := Format(SQ_SAVE_CERTIFICATE,[ID, Number, FormatDateTime(S_DATESTR_FORMAT, CertDate), GivenBy, Business]);
      Conn.GetDataSet(Sql).Open;
    end;
    FreeConnection(Conn, True);
  except
    FreeConnection(Conn, False);
    raise;
  end;
end;

end.
