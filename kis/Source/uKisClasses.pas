{*******************************************************}
{                                                       }
{       "ИС МП УГА"                                     }
{       Базовые классы системы                          }
{                                                       }
{       Copyright (c) 2003 - 2005, МП УГА               }
{                                                       }
{       Автор: Калабухов А.В.                           }
{                                                       }
{*******************************************************}

{ Описание:
  Имя модуля: Kernel Classes
  Версия: 1.05
  Дата последнего изменения: 
  Цель: содержит классы - ядро системы.
  Используется:
  Использует:   Custom DataSet
  Исключения:   }
{
  1.06    18.08.2005
     - в контроллере добавлена поддержка удаленных объектов

  1.05    01.06.2005
     - контроллеру сущностей добавлено посвойство TempEntity
       оно дает доступ к временной сущности, которая создается в момент
       редактирования или добавления записи

  1.04    22.11.2004
     - классу менеджера добален новый метод IsEntityStored
     - изменен алгоритм генерации нового номера документа отдела в классе TKisUser
}

unit uKisClasses;

interface

{$I KisFlags.pas}

uses
  // System
  SysUtils, Classes, DB, Contnrs, Variants, Controls, TypInfo,
  // Common
  uDataSet, uGC, 
  // Project
  uKisConsts, uKisExceptions;

type
  // Перечисление всех менеджеров в системе
  TKisMngrs = (
      kmBanks,
      kmContragents,
      kmContrAddresses,
      kmContrDocs,
      kmContrCertificates,
      kmOrders,
      kmLetters,
      kmOffices,
      kmOrgs,
      kmPeople,
      kmDocTypes,
      kmFirms,
      kmOfficeDocs,
      kmOutcomingLetters,
      kmStreets,
      kmGeoPunkts,
      kmDecreeProjects,
      kmArchivalDocs,
      kmLicensedOrgs,
      kmMapCases500,
      kmAccounts,
      kmMapTracings,
      kmMapScans,
      kmScanOrders,
      kmMapScanViewGiveOuts,
      kmProjectsJournal
  );

var
  // Имена менеджеров. Нужно для показа сообщений пользователю.
  KisMngrNames: array [TKisMngrs] of String = (
      'Банки',
      'Контрагенты',
      'Адреса контрагентов',
      'Документы контрагентов',
      'Сертификаты контрагентов',
      'Заказы',
      'Письма',
      'Отделы',
      'Организации',
      'Сотрудники',
      'Типы документов',
      'Организации/заказчики',
      'Документы отделов',
      'Исходящее письмо',
      'Улицы',
      'Геодезические знаки',
      'Проекты постановлений',
      'Архивные документы',
      'Лицензированные организации',
      'Планшеты 1:500',
      'Банковские счета клиентов',
      'Кальки планшетов',
      'Сканы планшетов',
      'Заявки на выдачу сканов',
      'Выдача сканов планшетов для просмотра',
      'Журнал проектов'
  );

type
  // Перечисление всех сущностей в системе
  TKisEntities = (
      keDefault,
      keBank,
      keContragent,
      keContrPerson,
      keContrOrg,
      keContrPrivate,
      keContrCertif,
      keContrAddress,
      keContrDoc,
      keOrder,
      keOrderPosition,
      keOrderMap,
      keLetter,
      keLetterObjAddress,
      keLetterVisa,
      keLetterPassing,
      keLetterOfficeDoc,
      keOffice,
      keOrg,
      keWorker,
      keDocType,
      keFirm,
      keOfficeDoc,
      keOfficeDocLetter,
      keOfficeDocExecutor,
      keOfficeDocPhase,
      keOutcomingLetter,
      keLetterSupplement,
      keLettersLink,
      keGeoPunkts,
      keDecreeProject,
      keTemporaryDecreeProject,
      keDecreeAddress,
      keDecreeVisa,
      keLicensedOrg,
      keLicensedOrgSROPeriod,
      keArchivalDoc,
      keArchDocMove,
      keMap500,
      keGivenMap,
      keMap500HistoryElement,
      keScanning,
      keMap500HistoryFigure,
      keContragentAccount,
      keMapTracing,
      keMapTracingGiving,
      kePoint1,
      keKiosk,
      keMapScan,
      keMapScanGiveOut,
      keScanOrder,
      keScanOrderMap,
      keMapScanViewGiveOut,
      keMapScanHistoryElement,
      keMapScanHistoryFigure,
      keMapScanState
  );

  //
  TkisFiguresState = (fsView, fsNewLine, fsNewArea);

  ECannotCopyEntity = class(Exception);
  ECannotCompareEntityWithNil = class(Exception);
  ECannotCompareEntities = class(Exception);
  ECannotDeleteEntity = class(Exception);
  EKisManagerNotFound = class(Exception);

  TKisMngr = class;

  // Параметр - "ячейка" для хранения произвольных данных.
  // Нужно для отрыва от конкретных свойств в классах сущностей, т.к.
  // с помощью свойства TKisEntity.DataParams можно обратиться к значению
  // нужного свойства. 
  TEntityParam = class(TPersistent)
  private
    FValue: Variant;
  protected
    procedure AssignTo(Dest: TPersistent); override;
  public
    property Value: Variant read FValue write FValue;
    function AsString: String;
    function AsBoolean: Boolean;
    function AsDateTime: TDateTime;
    function AsFloat: Double;
    function AsInteger: Longint;
    procedure Clear;
  end;

  {
    Базовый класс для всех сущностей, хранимых в БД.
  }
  TKisEntity = class(TPersistent)
  private
    FMngr: TKisMngr;
    FModified: Boolean;
    FBkm: Pointer;
    FHead: TKisEntity;
    FParams: TStringList;
    function GetHeadId: Integer;
    function GetMe: TKisEntity;
    procedure SetModified(const Value: Boolean);
  protected
    FID: Integer;
    procedure SetID(const Value: Integer); virtual;
    function GetText: String; virtual;
    function GetParam(ParamName: String): TEntityParam;
    procedure AddParam(const ParamName: String);
    {$IFDEF ENTPARAMS}
    procedure InitParams; virtual;
    {$ENDIF}
  public
    constructor Create(Mngr: TKisMngr); virtual;
    destructor Destroy; override;
    procedure Assign(Source: TPersistent); override;
    class function EntityName: String; virtual; abstract;
    // Копирует значения полей Source за исключением ID и Head
    // в отличие от Assign, который копирует и их
    procedure Copy(Source: TKisEntity); virtual;
    { Показывает окно - редактор свойств сущности }
    function IsEmpty: Boolean; virtual;
    function Equals(Entity: TKisEntity): Boolean; virtual;
    procedure Load(DataSet: TDataSet); virtual;
    property Manager: TKisMngr read FMngr;
    property ID: Integer read FID write SetID;
    property Modified: Boolean read FModified write SetModified;
    property AsText: String read GetText;
    property Bkm: Pointer read FBkm write FBkm;
    property Head: TKisEntity read FHead write FHead;
    property HeadId: Integer read GetHeadId;
    {$IFDEF ENTPARAMS}
    property DataParams[ParamName: String]: TEntityParam read GetParam; default;
    {$ENDIF}
    property Me: TKisEntity read GetMe;
  end;

  TKisEntityClass = class of TKisEntity;

  {
    Контроллер для TCustomDataSet, заточенный для работы с TKisEntity
  }
  TKisEntityController = class(TDataSetController)
  private
    FHeadEntity: TKisEntity;
    FElementType: TKisEntities;
    FMngr: TKisMngr;
    procedure SetHeadEntity(const Value: TKisEntity);
    function GetElements(Index: Integer): TKisEntity;
    function GetTempElement: TKisEntity;
    function GetDeletedElements(Index: Integer): TKisEntity;
    function GetDeletedCount: Integer;
  protected
    FDeletedList: TObjectList;
    FList: TObjectList;
    function Mngr: TKisMngr;
    function CreateElement: TKisEntity; virtual;
    procedure GetInteger(Value: Integer; var Data);
    procedure GetSmallInt(Value: SmallInt; var Data);
    procedure GetString(const Value: String; var Data);
    procedure GetDateTime(Value: TDateTime; var Data);
    procedure GetDate(Value: TDateTime; var Data);
    procedure GetTime(Value: TDateTime; var Data);
    procedure GetDouble(Value: Double; var Data);
    procedure GetBoolean(Value: Boolean; var Data);
    function SetInteger(const Data): Integer;
    function SetSmallInt(const Data): SmallInt;
    function SetString(const Data): String;
    function SetDateTime(const Data): TDateTime;
    function SetDate(const Data): TDateTime;
    function SetTime(const Data): TDateTime;
    function SetDouble(const Data): Double;
    function SetBoolean(const Data): Boolean;
  public
    constructor Create(AOwner: TComponent); overload; override;
    constructor CreateController(AOwner: TComponent; AMngr: TKisMngr;
      AElementType: TKisEntities); overload;
    destructor Destroy; override;
    procedure ClearFields(Index: Integer); override;
    function CreateFloatingRecord(SourceIndex: Integer): Integer; override;
    procedure DefloatRecord(FlIndex, DestIndex: Integer;
            DefloatMode: TDefloatMode); override;
    procedure DeleteRecord(Index: Integer); override;
    procedure FreeFloatingRecord(Index: Integer); override;
    function FindBookmark(Bookmark: TBookmarkStr): Integer; override;
    function GetBookmark(Index: Integer): TBookmarkStr; override;
    function GetBookmarkSize: Integer; override;
    function GetCanModify: Boolean; override;
    function GetRecordCount: Integer; override;
    function GetDeleteQueryText: String; virtual; abstract;
    procedure SetBookmark(Index: Integer; NewBookmark: TBookmarkStr); override;
    procedure DirectClear;
    procedure DirectAppend(AEnt: TKisEntity);
    procedure DirectReplace(Index: Integer; AEnt: TKisEntity);
    procedure ClearDeleted;
    function EqualsTo(aController: TKisEntityController): Boolean;
    //
    property Elements[Index: Integer]: TKisEntity read GetElements;
    property Count: Integer read GetRecordCount;
    property DeletedElements[Index: Integer]: TKisEntity read GetDeletedElements;
    property DeletedCount: Integer read GetDeletedCount;
    property TempElement: TKisEntity read GetTempElement;
    property HeadEntity: TKisEntity read FHeadEntity write SetHeadEntity;
    property ElementType: TKisEntities read FElementType write FElementType;
  end;

  {
    Базовый класс менеждера сущностей
  }
  TKisMngr = class(TDataModule)
  protected
    function GetIdent: TKisMngrs; virtual; abstract;
    function IsSupported(Entity: TKisEntity): Boolean; virtual;
    { Генерирует новое значение ID }
    function GenEntityID(EntityKind: TKisEntities = keDefault): Integer; virtual; abstract;
  public
    constructor Create(AOwner: TComponent); override;
    function CreateEntity(EntityKind: TKisEntities = keDefault): TKisEntity; virtual; abstract;
    { Создание нового экземпляра сущности }
    function CreateNewEntity(EntityKind: TKisEntities = keDefault): TKisEntity; virtual; abstract;
    function GetEntity(EntityID: Integer; EntityKind: TKisEntities = keDefault): TKisEntity; virtual; abstract;
    function EditEntity(Entity: TKisEntity): TKisEntity; virtual; abstract;
    { Сохраняет экземпляр сущности в БД }
    procedure SaveEntity(Entity: TKisEntity); virtual; abstract;
    { Удаление экземпляра сущности из БД }
    function DeleteEntity(Entity: TKisEntity): Boolean; virtual;
    { Проверяет используется ли экземпляр в БД }
    function IsEntityInUse(Entity: TKisEntity): Boolean; virtual; abstract;
    { Проверяет есть ли сущность в БД }
    function IsEntityStored(Entity: TKisEntity): Boolean; virtual; abstract;
    function DuplicateEntity(Entity: TKisEntity): TKisEntity; virtual; abstract;
    property Ident: TKisMngrs read GetIdent;
  end;

  TKisMngrClass = class of TKisMngr;

  ELoadEntity = class(EKisExtException)
  public
    constructor Create(const EntityId: Integer; const EntityType: TKisEntities; Msg: String = '');
  end;

  EUnsupportedEntity = class(EAbort)
  public
    constructor Create(MngrClass: TKisMngrClass; EntityClass: TClass);
  end;

  function IsEntitiesEquals(Ent1, Ent2: TKisEntity): Boolean;

var
  MngrList: TList;

implementation

{$R *.dfm}

function IsEntitiesEquals(Ent1, Ent2: TKisEntity): Boolean;
begin
  Result := False;
  if Assigned(Ent1) and Assigned(Ent2) then
    Result := Ent1.Equals(Ent2);
end;

{ TKisEntity }

procedure TKisEntity.AddParam(const ParamName: String);
begin
  FParams.AddObject(ParamName, TEntityParam.Create);
end;

procedure TKisEntity.Assign(Source: TPersistent);
begin
  if Assigned(Source) and (Source is Self.ClassType) then
    with Source as TKisEntity do
    begin
      Self.FID := ID;
      Self.FHead := Head;
      Self.Copy(TKisEntity(Source));
    end
    else
      inherited;
end;

procedure TKisEntity.Copy(Source: TKisEntity);
var
  I: Integer;
begin
  if Assigned(Source) then
  begin
    if not (Source is Self.ClassType) then
      raise ECannotCopyEntity.CreateFmt(S_CANNOT_COPY_ENTITY,
        [Source.ClassName, Self.ClassName])
  end
  else
    raise ECannotCopyEntity.CreateFmt(S_CANNOT_COPY_ENTITY,
      [S_NULL, Self.ClassName]);
  {$IFDEF ENTPARAMS}
  for I := 0 to Pred(FParams.Count) do
  begin
    DataParams[Self.FParams[I]].Value := Source[Self.FParams[I]].Value;
  end;
  {$ENDIF}
end;

constructor TKisEntity.Create(Mngr: TKisMngr);
begin
  FParams := TStringList.Create;
  FMngr := Mngr;
  FModified := False;
  FBkm := Self;
  {$IFDEF ENTPARAMS}
  InitParams;
  {$ENDIF}
end;

destructor TKisEntity.Destroy;
begin
  while FParams.Count <> 0 do
  begin
    if Assigned(FParams.Objects[Pred(FParams.Count)]) then
      FParams.Objects[Pred(FParams.Count)].Free;
    FParams.Delete(Pred(FParams.Count));
  end;
  FParams.Free;
  inherited;
end;

function TKisEntity.Equals(Entity: TKisEntity): Boolean;
var
  I: Integer;
begin
  if not Assigned(Entity) then
    raise ECannotCompareEntityWithNil.CreateFmt(S_CANNOT_COMPARE_ENTITY_WITH_NIL,
      [Self.ClassName])
  else
    if not (Entity is Self.ClassType) then
      raise ECannotCompareEntities.CreateFmt(S_CANNOT_COMPARE_ENTITES,
        [Self.ClassName, Entity.ClassName]);

  Result := True;
  {$IFDEF ENTPARAMS}
  for I := 0 to Pred(FParams.Count) do
    if Self[FParams[I]].Value <> Entity[FParams[I]].Value then
    begin
      Result := False;
      Exit;
    end;
  {$ENDIF}
end;

function TKisEntity.GetHeadId: Integer;
begin
  if Assigned(FHead) then
    Result := FHead.ID
  else
    Result := 0;
end;

function TKisEntity.GetMe: TKisEntity;
begin
  Result := Self;
end;

function TKisEntity.GetParam(ParamName: String): TEntityParam;
var
  I: Integer;
begin
  I := FParams.IndexOf(ParamName);
  if I >= 0 then
    Result := TEntityParam(FParams.Objects[I])
  else
    raise Exception.CreateFmt('Параметр %s не найден в классе %s!', [ParamName, Self.ClassName]);
end;

function TKisEntity.GetText: String;
begin
  Result := '';
end;

{$IFDEF ENTPARAMS}
procedure TKisEntity.InitParams;
begin

end;
{$ENDIF}

function TKisEntity.IsEmpty: Boolean;
var
  I: Integer;
begin
  Result := True;
  {$IFDEF ENTPARAMS}
  for I := 0 to Pred(FParams.Count) do
    if DataParams[FParams[I]].AsString <> '' then
    begin
      Result := False;
      Exit;
    end;
  {$ENDIF}
end;

procedure TKisEntity.Load(DataSet: TDataSet);
begin

end;

procedure TKisEntity.SetID(const Value: Integer);
begin
  if FID <> Value then
    FID := Value;
end;

procedure TKisEntity.SetModified(const Value: Boolean);
begin
  FModified := Value;
  if FModified then
  begin
    if Assigned(Head) then
      Head.Modified := FModified;
  end;
end;

{ TKisEntityController }

procedure TKisEntityController.ClearFields(Index: Integer);
begin
  inherited;
  FList.Delete(0);
  FList.Insert(0, CreateElement);
end;

constructor TKisEntityController.CreateController(AOwner: TComponent;
  AMngr: TKisMngr; AElementType: TKisEntities);
begin
  Create(AOwner);
  FMngr := AMngr;
  FElementType := AElementType;
  FList.Add(CreateElement);
end;

constructor TKisEntityController.Create(AOwner: TComponent);
begin
  inherited;
  FList := TObjectList.Create;
  FDeletedList := TObjectList.Create;
  FHeadEntity := nil;
  FMngr := nil;
end;

function TKisEntityController.CreateElement: TKisEntity;
begin
  Result := Mngr.CreateEntity(FElementType);
  Result.Head := HeadEntity;
end;

function TKisEntityController.CreateFloatingRecord(
  SourceIndex: Integer): Integer;
begin
  Result := 0;
  if SourceIndex <> 0 then
  begin
    TKisEntity(FList[0]).Assign(TKisEntity(FList[SourceIndex]));
  end;
end;

procedure TKisEntityController.DefloatRecord(FlIndex, DestIndex: Integer;
  DefloatMode: TDefloatMode);
var
  Ent: TKisEntity;
begin
  if DefloatMode = dmInsert then
  begin
    Ent := CreateElement; //Автоматически ставится новый Bookmark
    Ent.Assign(TKisEntity(FList[0]));
    if TKisEntity(FList[0]).Modified then
      Ent.Modified := True;
    FList.Insert(DestIndex, Ent);
  end
  else
  with TKisEntity(FList[DestIndex]) do
  begin
    Copy(TKisEntity(FList[0]));
  end;
end;

procedure TKisEntityController.DeleteRecord(Index: Integer);
begin
  inherited;
  FDeletedList.Add(FList.Extract(FList[Index]));
  if Assigned(FheadEntity) then
    FHeadEntity.Modified := True;
end;

destructor TKisEntityController.Destroy;
begin
  FDeletedList.Free;
  FList.Free;
  inherited;
end;

procedure TKisEntityController.DirectAppend(AEnt: TKisEntity);
begin
  FList.Add(AEnt);
  AEnt.Head := FHeadEntity;
end;

function TKisEntityController.FindBookmark(
  Bookmark: TBookmarkStr): Integer;
var
  I: Integer;
  P: Pointer;
begin
  P := Pointer(StrToInt(PChar(Bookmark)));
  Result := -1;
  for I := 1 to Pred(FList.Count) do
    if TKisEntity(FList[I]).Bkm = P then
    begin
      Result := I;
      Break;
    end;
end;

procedure TKisEntityController.FreeFloatingRecord(Index: Integer);
begin
  inherited;

end;

function TKisEntityController.GetBookmark(Index: Integer): TBookmarkStr;
begin
  Result := '$' + IntToHex(Cardinal(TKisEntity(FList[Index]).Bkm), 8);
end;

function TKisEntityController.GetBookmarkSize: Integer;
begin
  Result:= 10;
end;

function TKisEntityController.GetCanModify: Boolean;
begin
  Result := True;
end;

procedure TKisEntityController.GetDateTime(Value: TDateTime; var Data);
begin
  TDateTimeRec(Data).DateTime := TimeStampToMSecs(DateTimeToTimeStamp(Value));
end;

procedure TKisEntityController.GetDouble(Value: Double; var Data);
var
  P: PDouble;
begin
  P := @Data;
  P^ := Value;
end;

procedure TKisEntityController.GetInteger(Value: Integer; var Data);
var
  P: PInteger;
begin
  P := @Data;
  P^ := Value;
end;

function TKisEntityController.GetRecordCount: Integer;
begin
  Result := Pred(FList.Count);
end;

procedure TKisEntityController.GetSmallInt(Value: SmallInt; var Data);
var
  P: PSmallInt;
begin
  P := @Data;
  P^ := Value;
end;

procedure TKisEntityController.GetString(const Value: String; var Data);
var
  P: PChar;
begin
  if @Data = nil then Exit;
  P := PChar(Value);
  StrLCopy(@Data, P, Length(Value));
end;

procedure TKisEntityController.SetBookmark(Index: Integer;
  NewBookmark: TBookmarkStr);
begin
  inherited;
  TKisEntity(FList[Index]).Bkm := Pointer(StrToInt(NewBookmark));
end;

procedure TKisEntityController.SetHeadEntity(const Value: TKisEntity);
var
  I: Integer;
begin
  FHeadEntity := Value;
  for I := 0 to Pred(FList.Count) do
  with FList[I] as TKisEntity do
    Head := Self.FHeadEntity;
end;

function TKisEntityController.Mngr: TKisMngr;
begin
  if Assigned(FMngr) then
    Result := FMngr
  else
    if Assigned(HeadEntity) then
      Result := HeadEntity.Manager
    else
      Result := FMngr;
end;

function TKisEntityController.SetDateTime(const Data): TDateTime;
var
  Tmp: TDateTimeRec;
begin
  Tmp := TDateTimeRec(Data);
  Result := Tmp.DateTime;
end;

function TKisEntityController.SetDouble(const Data): Double;
begin
  Result := Double(Data);
end;

function TKisEntityController.SetInteger(const Data): Integer;
begin
  Result := Integer(Data);
end;

function TKisEntityController.SetSmallInt(const Data): SmallInt;
begin
  Result := SmallInt(Data);
end;

function TKisEntityController.SetString(const Data): String;
begin
  Result := StrPas(@Data);
end;

function TKisEntityController.GetElements(Index: Integer): TKisEntity;
begin
  Result := TKisEntity(FList[Index]);
end;

procedure TKisEntityController.DirectClear;
begin
  FList.Clear;
  FList.Add(CreateElement);
end;

procedure TKisEntityController.GetDate(Value: TDateTime; var Data);
begin
  TDateTimeRec(Data).Date := DateTimeToTimeStamp(Value).Date;
end;

procedure TKisEntityController.GetTime(Value: TDateTime; var Data);
begin
  TDateTimeRec(Data).Time := DateTimeToTimeStamp(Value).Time;
end;

function TKisEntityController.SetDate(const Data): TDateTime;
var
  TimeStamp: TTimeStamp;
begin
  TimeStamp.Time := 0;
  TimeStamp.Date := TDateTimeRec(Data).Date;
  Result := TimeStampToDateTime(TimeStamp);
end;

function TKisEntityController.SetTime(const Data): TDateTime;
var
  TimeStamp: TTimeStamp;
begin
  TimeStamp.Date := 0;
  TimeStamp.Time := TDateTimeRec(Data).Time;
  Result := TimeStampToDateTime(TimeStamp);
end;

{ EUnsupportedEntityClass }

constructor EUnsupportedEntity.Create(MngrClass: TKisMngrClass;
  EntityClass: TClass);
var
  S: String;
begin
  if Assigned(EntityClass) then
    S := EntityClass.ClassName
  else
    S := S_NULL;
  inherited CreateFmt(S_UNSUPPORTED_ENTITY_CLASS, [MngrClass.ClassName, S]);
end;

procedure TKisEntityController.GetBoolean(Value: Boolean; var Data);
var
  P: PWordBool;
begin
  P := @Data;
  P^ := Value;
end;

function TKisEntityController.SetBoolean(const Data): Boolean;
begin
  Result := Boolean(Data);
end;

function TKisEntityController.GetTempElement: TKisEntity;
begin
  Result := TKisEntity(FList[0]);
end;

procedure TKisEntityController.DirectReplace(Index: Integer;
  AEnt: TKisEntity);
begin
  FList.Items[Index] := AEnt;
  AEnt.Head := FHeadEntity;
end;

function TKisEntityController.EqualsTo(aController: TKisEntityController): Boolean;
var
  I: Integer;
begin
  Result := Count = aController.Count;
  if Result then
  begin
    for I := 1 to Count do
    begin
      Result := Elements[I].Equals(aController.Elements[I]);
      if not Result then
        Exit;
    end;
  end;

end;

function TKisEntityController.GetDeletedElements(Index: Integer): TKisEntity;
begin
  Result := FDeletedList[Index] as TKisEntity; 
end;

function TKisEntityController.GetDeletedCount: Integer;
begin
  Result := FDeletedList.Count; 
end;

procedure TKisEntityController.ClearDeleted;
begin
  FDeletedList.Clear;
end;

{ TEntityParam }

function TEntityParam.AsBoolean: Boolean;
begin
  if VarType(FValue) in [varEmpty, varBoolean] then
    Result := FValue
  else
    raise Exception.CreateFmt(S_CANT_CONVERT,
      [VarTypeAsText(VarType(FValue)), VarTypeAsText(varBoolean)]);
end;

function TEntityParam.AsDateTime: TDateTime;
begin
  if VarType(FValue) in [varEmpty, varDate] then
    Result := FValue
  else
    raise Exception.CreateFmt(S_CANT_CONVERT,
      [VarTypeAsText(VarType(FValue)), VarTypeAsText(varDate)]);
end;

function TEntityParam.AsFloat: Double;
begin
  if VarType(FValue) in [varEmpty, varSingle, varDouble] then
    Result := FValue
  else
    raise Exception.CreateFmt(S_CANT_CONVERT,
      [VarTypeAsText(VarType(FValue)), VarTypeAsText(varDouble)]);
end;

function TEntityParam.AsInteger: Longint;
begin
  if VarType(FValue) in [varEmpty, varByte, varInteger, varSmallInt, varShortInt, varWord, varLongWord, varInt64] then
    Result := FValue
  else
  if VarIsNull(FValue) then
    Result := 0
  else
    raise Exception.CreateFmt(S_CANT_CONVERT,
      [VarTypeAsText(VarType(FValue)), VarTypeAsText(varInteger)]);
end;

procedure TEntityParam.AssignTo(Dest: TPersistent);
begin
  if Dest is TEntityParam then
    TEntityParam(Dest).FValue := Self.FValue
  else
    inherited;
end;

function TEntityParam.AsString: String;
begin
  Result := VarToStr(FValue)
end;

procedure TEntityParam.Clear;
begin
  Value := Unassigned;
end;

{ TKisMngr }

constructor TKisMngr.Create(AOwner: TComponent);
begin
  inherited;
  ;
  if Assigned(MngrList) then
    MngrList.Add(Self);
end;

function TKisMngr.DeleteEntity(Entity: TKisEntity): Boolean;
begin
  raise ECannotDeleteEntity.CreateFmt(S_CANNOT_DELETE_ENTITY, [Entity.EntityName]);
end;

function TKisMngr.IsSupported(Entity: TKisEntity): Boolean;
begin
  if Assigned(Entity) then
    raise EUnsupportedEntity.Create(TKisMngrClass(Self.ClassType), Entity.ClassType)
  else
    raise EUnsupportedEntity.Create(TKisMngrClass(Self.ClassType), nil);
end;

{ ELoadEntity }

constructor ELoadEntity.Create(const EntityId: Integer;
  const EntityType: TKisEntities; Msg: String = '');
begin
  if Msg = '' then
    Msg := S_LOAD_ENTITY_ERROR;
  inherited Create(Msg,
    'ID: ' + IntToStr(EntityID) + #13#10 +
    'TypeID: ' + GetEnumName(TypeInfo(TKisEntities), Ord(EntityType)));
end;

end.
