{*******************************************************}
{                                                       }
{       "ИС МП УГА"                                     }
{       Менеджер улиц                                   }
{                                                       }
{       Copyright (c) 2004, МП УГА                      }
{                                                       }
{       Автор: Калабухов А.В.                           }
{                                                       }
{*******************************************************}

{ Описание: реализует работу со справочником улиц
  Имя модуля: Streets
  Версия: 0.01
  Дата последнего изменения: 24.11.2004
  Цель: модуль содержит реализации классов менеджера улиц и улицы
  Используется: AppModule
  Использует: Kernel Classes
  Исключения: нет }

unit uKisStreets;

interface

{$I KisFlags.pas}

uses
  Windows, Messages, SysUtils, Variants, Classes, Controls, DB, ImgList,
  ActnList, Forms, IBQuery, Grids,
  // Project
  uKisClasses, uKisSQLClasses, uKisConsts, uKisStreetSelectorForm,
  uKisAppModule, uKisEntityEditor;

type
  TKisStreet = class(TKisVisualEntity)
  private
    FCreateDocId: Integer;
    FRegionsId: Integer;
    FRegistryNumber: Integer;
    FKillDocId: Integer;
    FPostIndex: Integer;
    FStreetMarkingId: Integer;
    FVillagesId: Integer;
    FStreetMarkingName: String;
    FNameLater: String;
    FAbout: String;
    FName: String;
    procedure SetAbout(const Value: String);
    procedure SetCreateDocId(const Value: Integer);
    procedure SetKillDocId(const Value: Integer);
    procedure SetName(const Value: String);
    procedure SetNameLater(const Value: String);
    procedure SetPostIndex(const Value: Integer);
    procedure SetRegionsId(const Value: Integer);
    procedure SetRegistryNumber(const Value: Integer);
    procedure SetStreetMarkingId(const Value: Integer);
    procedure SetStreetMarkingName(const Value: String);
    procedure SetVillagesId(const Value: Integer);
  public
    class function EntityName: String; override;
    procedure Copy(Source: TKisEntity); override;
    function IsEmpty: Boolean; override; 
    function Equals(Entity: TKisEntity): Boolean; override;
    procedure Load(DataSet: TDataSet); override;

    property RegionsId: Integer read FRegionsId write SetRegionsId;
    property VillagesId: Integer read FVillagesId write SetVillagesId;
    property Name: String read FName write SetName;
    property NameLater: String read FNameLater write SetNameLater;
    property CreateDocId: Integer read FCreateDocId write SetCreateDocId;
    property KillDocId: Integer read FKillDocId write SetKillDocId;
    property About: String read FAbout write SetAbout;
    property StreetMarkingId: Integer read FStreetMarkingId write SetStreetMarkingId;
    property StreetMarkingName: String read FStreetMarkingName write SetStreetMarkingName;
    property PostIndex: Integer read FPostIndex write SetPostIndex;
    property RegistryNumber: Integer read FRegistryNumber write SetRegistryNumber;
  end;

  TKisStreetMngr = class(TKisSQLMngr)
  public
    function CreateNewEntity(EntityKind: TKisEntities = keDefault): TKisEntity; override;
    function IsEntityInUse(Entity: TKisEntity): Boolean; override;
    function GetEntity(EntityID: Integer; EntityKind: TKisEntities = keDefault): TKisEntity; override;
  end;

  TKisStreetSelector = class
  private
    FDataSet: TIBQuery;
    FForm: TKisStreetSelectorForm;
    procedure SetFormSize(Control: TControl);
    function GetActive: Boolean;
  public
    constructor Create;
    destructor Destroy; override;
    // Возвращает форму для поиска улицы
    function GetSelectorForm(TargetControl: TControl): TKisStreetSelectorForm;
    function CloseForm(const CanSelect: Boolean): String;
    procedure Find(const theText: String);
    procedure Next; virtual; abstract;
    procedure Prior; virtual; abstract;
    property Active: Boolean read GetActive;
  end;

  TMyInplaceEdit = class(TInplaceEdit)
  private
//    FGrid: TCustomGrid;
    FOnBoundsChanged: TNotifyEvent;
    procedure SetOnBoundsChanged(const Value: TNotifyEvent);
  protected
    procedure KeyDown(var Key: Word; Shift: TShiftState); override;
    procedure KeyPress(var Key: Char); override;
    procedure KeyUp(var Key: Word; Shift: TShiftState); override;
    procedure BoundsChanged; override;
    procedure WndProc(var Message: TMessage); override;
  public
    property OnBoundsChanged: TNotifyEvent read FOnBoundsChanged write SetOnBoundsChanged;
    property OnKeyDown;
    property OnKeyPress;
    property OnKeyUp;
  end;



implementation

{$R *.dfm}

uses
  // System
  TypInfo,
  // Common
  uIBXUtils
  ;

function GetPropName(const FieldName: String): String;
var
  I: Integer;
begin
  Result := FieldName[1];
  for I := 2 to Length(FieldName) do
    if AnsiUpperCase(FieldName[I]) = FieldName[I] then
      Result := Result + '_' + FieldName[I]
    else
      Result := Result + FieldName[I];
  Result := AnsiUpperCase(Result);
end;

{ TKisStreet }

procedure TKisStreet.Copy(Source: TKisEntity);
begin
  inherited;
  with Source as TKisStreet do
  begin
    // копируем параметры письма
    Self.FCreateDocId := CreateDocId;
    Self.FRegionsId := RegionsId;
    Self.FRegistryNumber := RegistryNumber;
    Self.FKillDocId := KillDocId;
    Self.FPostIndex := PostIndex;
    Self.FStreetMarkingId := StreetMarkingId;
    Self.FStreetMarkingName := StreetMarkingName;
    Self.FVillagesId := VillagesId;
    Self.FNameLater := NameLater;
    Self.FName := Name;
    Self.FAbout := About;
    Modified := True;
  end;
end;

class function TKisStreet.EntityName: String;
begin
  Result := 'Улица';
end;

function TKisStreet.Equals(Entity: TKisEntity): Boolean;
begin
  with Entity as TKisStreet do
    Result := (Self.FCreateDocId = FCreateDocId)
      and (Self.FRegionsId = FRegionsId)
      and (Self.FRegistryNumber = FRegistryNumber)
      and (Self.FKillDocId = FKillDocId)
      and (Self.FPostIndex = FPostIndex)
      and (Self.FStreetMarkingId = FStreetMarkingId)
      and (Self.FStreetMarkingName = FStreetMarkingName)
      and (Self.FVillagesId = FVillagesId)
      and (Self.FNameLater = FNameLater)
      and (Self.FName = FName)
      and (Self.FAbout = FAbout);
end;

function TKisStreet.IsEmpty: Boolean;
begin
  Result := (Self.FCreateDocId = 0)
    and (Self.FRegionsId = 0)
    and (Self.FRegistryNumber = 0)
    and (Self.FKillDocId = 0)
    and ((Self.FPostIndex = 0) or (Self.FPostIndex = ID_DEFAULT_INDEX))
    and (Self.FStreetMarkingId = 0)
    and (Self.FStreetMarkingName = '')
    and (Self.FVillagesId = 0)
    and (Self.FNameLater = '')
    and (Self.FName = '')
    and (Self.FAbout = '');
end;

procedure TKisStreet.Load(DataSet: TDataSet);
var
  I: Integer;
begin
  inherited;
  for I := 0 to Pred(DataSet.FieldCount) do
    TypInfo.SetPropValue(Self, GetPropName(DataSet.Fields[I].FieldName), DataSet.Fields[I].Value);
end;

procedure TKisStreet.SetAbout(const Value: String);
begin
  if FAbout <> Value then
  begin
    FAbout := Value;
    Modified := True;
  end;
end;

procedure TKisStreet.SetCreateDocId(const Value: Integer);
begin
  if FCreateDocId <> Value then
  begin
    FCreateDocId := Value;
    Modified := True;
  end;
end;

procedure TKisStreet.SetKillDocId(const Value: Integer);
begin
  if FKillDocId <> Value then
  begin
    FKillDocId := Value;
    Modified := True;
  end;
end;

procedure TKisStreet.SetName(const Value: String);
begin
  if FName <> Value then
  begin
    FName := Value;
    Modified := True;
  end;
end;

procedure TKisStreet.SetNameLater(const Value: String);
begin
  if FNameLater <> Value then
  begin
    FNameLater := Value;
    Modified := True;
  end;
end;

procedure TKisStreet.SetPostIndex(const Value: Integer);
begin
  if FPostIndex <> Value then
  begin
    FPostIndex := Value;
    Modified := True;
  end;
end;

procedure TKisStreet.SetRegionsId(const Value: Integer);
begin
  if FRegionsId <> Value then
  begin
    FRegionsId := Value;
    Modified := True;
  end;
end;

procedure TKisStreet.SetRegistryNumber(const Value: Integer);
begin
  if FRegistryNumber <> Value then
  begin
    FRegistryNumber := Value;
    Modified := True;
  end;
end;

procedure TKisStreet.SetStreetMarkingId(const Value: Integer);
begin
  if FStreetMarkingId <> Value then
  begin
    FStreetMarkingId := Value;
    Modified := True;
  end;
end;

procedure TKisStreet.SetStreetMarkingName(const Value: String);
begin
  if FStreetMarkingName <> Value then
  begin
    FStreetMarkingName := Value;
    Modified := True;
  end;
end;

procedure TKisStreet.SetVillagesId(const Value: Integer);
begin
  if FVillagesId <> Value then
  begin
    FVillagesId := Value;
    Modified := True;
  end;
end;

{ TKisStreetMngr }

function TKisStreetMngr.CreateNewEntity(
  EntityKind: TKisEntities): TKisEntity;
begin
  Result := nil;
end;

function TKisStreetMngr.GetEntity(EntityID: Integer;
  EntityKind: TKisEntities): TKisEntity;
begin
  Assert(True, 'TKisStreetMngr.GetEntity is''nt released!');
  Result := nil;
end;

function TKisStreetMngr.IsEntityInUse(Entity: TKisEntity): Boolean;
begin
  Result := True; 
end;

{ TKisStreetSelector }

function TKisStreetSelector.CloseForm(const CanSelect: Boolean): String;
begin
  Result := '';
  if Assigned(FForm) then
  begin
    FForm.Close;
    if CanSelect then
      Result := FDataSet.Fields[0].AsString + ' ' + FDataSet.Fields[1].AsString;
  end;
end;

constructor TKisStreetSelector.Create;
begin
  FDataSet := TIBQuery.Create(nil);
  FDataSet.Transaction := AppModule.Pool.Get;
  FDataSet.Transaction.Init(ilReadCommited, amReadOnly);
  FDataSet.Transaction.StartTransaction;
  FDataSet.SQL.Text := 'SELECT NAME, STREET_MARKING_NAME FROM STREETS ORDER BY NAME';
end;

destructor TKisStreetSelector.Destroy;
begin
  FDataSet.Transaction.Commit;
  FDataSet.Free;
  if Assigned(FForm) then
    FForm.Free;
  inherited;
end;

procedure TKisStreetSelector.Find(const theText: String);
begin
  FDataSet.Locate('STREET_NAME', theText, [loCaseInsensitive, loPartialKey]);
end;

function TKisStreetSelector.GetActive: Boolean;
begin
  if Assigned(FForm) then
    Result := FForm.Visible
  else
    Result := False;
end;

function TKisStreetSelector.GetSelectorForm(
  TargetControl: TControl): TKisStreetSelectorForm;
begin
  FDataSet.Active := True;
  FDataSet.First;
  FForm := TKisStreetSelectorForm.Create(nil);
  FForm.DataSource1.DataSet := FDataSet;
  SetFormSize(TargetControl);
  Result := FForm;
  ShowWindow(Result.Handle, SW_SHOWNA);
end;

procedure TKisStreetSelector.SetFormSize(Control: TControl);
var
  aPoint: TPoint;
begin
  if Assigned(FForm) and Assigned(Control) then
  begin
    aPoint := Point(0, Control.Height + 2);
    aPoint := Control.ClientToScreen(aPoint);
    FForm.Top  := aPoint.Y;
    FForm.Left := aPoint.X;
    FForm.Width := Control.Width;
  end;
end;

{ TMyInplaceEdit }

procedure TMyInplaceEdit.BoundsChanged;
begin
  inherited;
  if Assigned(FOnBoundsChanged) then
    FOnBoundsChanged(Self);
end;

procedure TMyInplaceEdit.KeyDown(var Key: Word; Shift: TShiftState);
begin
  if Assigned(OnKeyDown) then
    OnKeyDown(Self, Key, Shift);
  inherited;
end;

procedure TMyInplaceEdit.KeyPress(var Key: Char);
begin
  if Assigned(OnKeyPress) then
    OnKeyPress(Self, Key);
  inherited;
end;

procedure TMyInplaceEdit.KeyUp(var Key: Word; Shift: TShiftState);
begin
  if Assigned(OnKeyUp) then
    OnKeyUp(Self, Key, Shift);
  inherited;
end;

procedure TMyInplaceEdit.SetOnBoundsChanged(const Value: TNotifyEvent);
begin
  FOnBoundsChanged := Value;
end;

procedure TMyInplaceEdit.WndProc(var Message: TMessage);
begin
  inherited;

end;

end.
