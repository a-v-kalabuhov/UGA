{*******************************************************}
{                                                       }
{       "ИС МП УГА"                                     }
{       Менеджер документов контрагента                 }
{                                                       }
{       Copyright (c) 2003-2005, МП УГА                 }
{                                                       }
{       Автор: Калабухов А.В.                           }
{                                                       }
{*******************************************************}

{ Описание: реализует операции над документами контрагентов
  Имя модуля: Contragent Docs
  Версия: 1.0
  Дата последнего изменения: 27.06.2004
  Цель: содержит классы - менеджер документов контрагентов, документ контрагента.
  Используется:
  Использует:   Kernel Classes
  Исключения:   }

unit uKisContragentDocuments;

{$I KisFlags.pas}

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  DB, ImgList, ActnList, IBDatabase, IBQuery,
  // Project
  uKisClasses, uKisSQLCLasses;

type
  TKisContragentDocument = class(TKisEntity)
  private
    FDocKind: Integer;
    FNumber: String;
    FSeries: String;
    FGivenBy: String;
    FDocDate: TDate;
    procedure SetDocKind(const Value: Integer);
    procedure SetNumber(const Value: String);
    procedure SetSeries(const Value: String);
    procedure SetGivenBy(const Value: String);
    procedure SetDocDate(const Value: TDate);
  protected
    function GetText: String; override;
  public
    constructor Create(Mngr: TKisMngr); override;
    class function EntityName: String; override;
    procedure Copy(Source: TKisEntity); override;
    function IsEmpty: Boolean; override;
    function Equals(Entity: TKisEntity): Boolean; override;
    property DocKind: Integer read FDocKind write SetDocKind;
    property Number: String read FNumber write SetNumber;
    property Series: String read FSeries write SetSeries;
    property GivenBy: String read FGivenBy write SetGivenBy;
    property DocDate: TDate read FDocDate write SetDocDate;
  end;

  TKisContragentDocumentMngr = class(TKisSQLMngr)
  protected
    function GenEntityID(EntityKind: TKisEntities = keDefault): Integer; override;
    function IsSupported(Entity: TKisEntity): Boolean; override;
    function GetIdent: TkisMngrs; override;
    function GetMainSQLText: String; override;
    function GetRefreshSQLText: String; override;
    function GetMainDataSet: TDataSet; override;
  public
    function GetEntity(EntityID: Integer; EntityKind: TKisEntities = keDefault): TKisEntity; override;
    function CreateNewEntity(EntityKind: TKisEntities = keDefault): TKisEntity; override;
    procedure SaveEntity(Entity: TKisEntity); override;
    function IsEntityInUse(Entity: TKisEntity): Boolean; override;
    procedure DeleteEntity(Entity: TKisEntity); override;
    function CreateEntity(EntityKind: TKisEntities): TKisEntity; override;
  end;

implementation

{$R *.dfm}

uses
  IBSQL,
  // Common
  uIBXUtils, uGC,
  // Project
  uKisAppModule, uKisUtils, uKisConsts, uKisIntf;

resourcestring
  // Genertors
  SG_CONTR_PERSONS_DOCS = 'CONTR_PERSONS_DOCS';
  // Queries
  SQ_SELECT_DOC = 'SELECT * FROM CONTR_PERSONS_DOCS WHERE ID=%d';
  SQ_DOC_IN_USE = 'SELECT COUNT(*) FROM CONTR_PERSONS WHERE DOC_ID=%d';
  SQ_DELETE_DOC = 'DELETE FROM CONTR_PERSONS_DOCS WHERE ID=%d';
  SQ_SAVE_DOC = 'EXECUTE PROCEDURE SAVE_CONTR_PERSONS_DOCS(%d, %d, ''%s'', ''%s'', ''%s'', ''%s'')';

{ TKisContragentDocument }

procedure TKisContragentDocument.Copy(Source: TKisEntity);
begin
  inherited;
  with Source as TKisContragentDocument do
  begin
    Self.FDocKind := DocKind;
    Self.FNumber := Number;
    Self.FSeries := Series;
    Self.FGivenBy := GivenBy;
    Self.FDocDate := Docdate;
  end;
end;

constructor TKisContragentDocument.Create(Mngr: TKisMngr);
begin
  inherited;
  FDocDate := Date;
end;

class function TKisContragentDocument.EntityName: String;
begin
  Result := S_PERSON_DOC;
end;

function TKisContragentDocument.Equals(Entity: TKisEntity): Boolean;
begin
  inherited Equals(Entity);
  with Entity as TKisContragentDocument do
  begin
    Result := (Self.FDocKind = DocKind) and (Self.FNumber = Number)
      and (Self.FSeries = Series) and (Self.FGivenBy = GivenBy)
      and (Self.FDocDate = DocDate);  
  end;
end;

function TKisContragentDocument.GetText: String;
begin
  if IsEmpty then
    Result := ''
  else
  begin
    case FDocKind of
    1 : Result := 'паспорт';
    2 : Result := 'военный билет';
    end;
    Result := Result + ' №' + Self.Number + ' от '
      + FormatDateTime('dd.mm.yyyyг.', Self.DocDate) + ' выдан ' + Self.GivenBy;
  end;
end;

function TKisContragentDocument.IsEmpty: Boolean;
begin
  Result := (FDocDate = Date) and (FDocKind = N_ZERO) and (FNumber = '')
    and (FGivenBy = '') and (FSeries = '');
end;

procedure TKisContragentDocument.SetDocDate(const Value: TDate);
begin
  //if FDocDate <> Value then
  if DateToStr(FDocDate) <> DateToStr(Value) then
  begin
    FDocDate := Value;
    Modified := True;
  end;
end;

procedure TKisContragentDocument.SetDocKind(const Value: Integer);
begin
  if FDocKind <> Value then
  begin
    FDocKind := Value;
    Modified := True;
  end;
end;

procedure TKisContragentDocument.SetNumber(const Value: String);
begin
  if FNumber <> Value then
  begin
    FNumber := Value;
    Modified := True;
  end;
end;

procedure TKisContragentDocument.SetGivenBy(const Value: String);
begin
  if FGivenBy <> Value then
  begin
    FGivenBy := Value;
    Modified := True;
  end;
end;

procedure TKisContragentDocument.SetSeries(const Value: String);
begin
  if FSeries <> Value then
  begin
    FSeries := Value;
    Modified := True;
  end;
end;

{ TKisContragentDocuments }

function TKisContragentDocumentMngr.CreateEntity(
  EntityKind: TKisEntities): TKisEntity;
begin
  Result := TKisContragentDocument.Create(Self);
end;

function TKisContragentDocumentMngr.CreateNewEntity(EntityKind: TKisEntities = keDefault): TKisEntity;
begin
  Result := TKisContragentDocument.Create(Self);
  Result.ID := GenEntityID();
end;

procedure TKisContragentDocumentMngr.DeleteEntity(Entity: TKisEntity);
var
  Conn: IKisConnection;
begin
  Conn := GetConnection(True, True);
  if not IsEntityInUse(Entity) then
  try
    Conn.GetDataSet(Format(SQ_DELETE_DOC, [Entity.ID])).Open;
    FreeConnection(Conn, True);
  except
    FreeConnection(Conn, False);
    raise;
  end
  else
    inherited;
end;

function TKisContragentDocumentMngr.GenEntityID(EntityKind: TKisEntities = keDefault): Integer;
begin
  Result := AppModule.GetID(SG_CONTR_PERSONS_DOCS, Self.DefaultTransaction);
end;

function TKisContragentDocumentMngr.GetEntity(EntityID: Integer;
  EntityKind: TKisEntities = keDefault): TKisEntity;
var
  Conn: IKisConnection;
begin
  Conn := GetConnection(True, False);
  with Conn.GetDataSet(Format(SQ_SELECT_DOC, [EntityID])) do
  try
    Open;
    if not IsEmpty then
    begin
      Result := TKisContragentDocument.Create(Self);
      with Result as TKisContragentDocument do
      begin
        ID := EntityID;
        DocKind := FieldByName(SF_DOC_KIND).AsInteger;
        Number := FieldByName(SF_NUMBER).AsString;
        Series := FieldByName(SF_SERIES).AsString;
        GivenBy := FieldByName(SF_OWNER).AsString;
        DocDate := FieldByName(SF_DOC_DATE).AsDateTime;
      end;
    end
    else
      Result := nil;
  finally
    FreeConnection(Conn, True);
  end;
end;

function TKisContragentDocumentMngr.GetIdent: TkisMngrs;
begin
  Result := kmContrDocs;
end;

function TKisContragentDocumentMngr.GetMainDataSet: TDataSet;
begin
  Result := nil;
end;

function TKisContragentDocumentMngr.GetMainSQLText: String;
begin
  Result := '';
end;

function TKisContragentDocumentMngr.GetRefreshSQLText: String;
begin
  Result := '';
end;

function TKisContragentDocumentMngr.IsEntityInUse(Entity: TKisEntity): Boolean;
var
  Conn: IKisConnection;
begin
  Conn := GetConnection(True, False);
  try
    with Conn.GetDataSet(Format(SQ_DOC_IN_USE, [Entity.ID])) do
    begin
      Open;
      Result := Fields[N_ZERO].AsInteger > N_ZERO;
      Close;
    end;
  finally
    FreeConnection(COnn, True);
  end;
end;

function TKisContragentDocumentMngr.IsSupported(
  Entity: TKisEntity): Boolean;
begin
  Result := Entity is TKisContragentDocument;
end;

procedure TKisContragentDocumentMngr.SaveEntity(Entity: TKisEntity);
var
  Conn: IKisConnection;
begin
  Conn := GetConnection(True, True);
  while (Entity.ID = N_ZERO) or IsEntityInUse(Entity) do
    Entity.ID := GenEntityId();
  try
    with TKisContragentDocument(Entity) do
      Conn.GetDataSet(
          Format(SQ_SAVE_DOC,
                 [ID, DocKind, Number, Series, GivenBy,
                  FormatDateTime(S_DATESTR_FORMAT, DocDate)])).Open;
    FreeConnection(Conn, True);
  except
    FreeConnection(Conn, False);
    raise;
  end;
end;

end.
