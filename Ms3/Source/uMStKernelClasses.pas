unit uMStKernelClasses;

interface

{$WARN UNSAFE_TYPE OFF}
{$I uMStFlags.pas }

uses
  // System
  SysUtils, Windows, Classes, Contnrs, Controls, CheckLst, StrUtils, 
  // Common
  uCommonUtils,  
  //
  uMStConsts, uMStKernelTypes, uMStKernelSemantic, uMStKernelStackConsts,
  VirtualTrees;

const
  ID_NONE = 0;
  ID_MAP = 1;
  ID_STREET = 2;
  ID_ADDRESS = 3;
  ID_LOT = 4;
  ID_ANNULED_LOT1 = 5;
  ID_ACTUAL_LOT1 = 6;
  ID_LOT_CATEGORIZED = 7;
  ID_PROJECT = 8;
  ID_PROJECT_MP = 9;
  S_GUEST = 'GUEST';

type
  TmstUser = class
  private
    FIsAdministrator: Boolean;
    FUserName: String;
    FId: Integer;
    FOfficeId: Integer;
    FInitialName: String;
    FCanPrint: Boolean;
    FMapReportErrorMode: TmstMapReportErrorMode;
    FPassword: string;
    FCanManageProjects: Boolean;
    procedure SetIsAdministrtor(const Value: Boolean);
    procedure SetUserName(const Value: String);
    procedure SetId(const Value: Integer);
    procedure SetOfficeId(const Value: Integer);
    procedure SetCanPrint(const Value: Boolean);
    procedure SetMapReportErrorMode(const Value: TmstMapReportErrorMode);
    procedure SetPassword(const Value: string);
    procedure SetInitialName(const Value: String);
    procedure SetCanManageProjects(const Value: Boolean);
  public
    constructor Create;
    //
    property CanManageProjects: Boolean read FCanManageProjects write SetCanManageProjects;
    property CanPrint: Boolean read FCanPrint write SetCanPrint;
    property IsAdministrator: Boolean read FIsAdministrator write SetIsAdministrtor;
    property Id: Integer read FId write SetId;
    property InitialName: String read FInitialName write SetInitialName;
    property OfficeId: Integer read FOfficeId write SetOfficeId;
    property Password: string read FPassword write SetPassword;
    property UserName: String read FUserName write SetUserName;
    property MapReportErrorMode: TmstMapReportErrorMode read FMapReportErrorMode write SetMapReportErrorMode;
  end;

  TmstObject = class(TPersistent)
  private
    FDatabaseId: Integer;
  protected
    function GetObjectId: Integer; virtual;
    function GetText: String; virtual;
    procedure AssignTo(Source: TPersistent); override;
  public
    constructor Create; virtual;
    // ID в базе данных
    property DatabaseId: Integer read FDatabaseId write FDatabaseId;
    property ObjectId: Integer read GetObjectId;
    property AsText: String read GetText;
  end;

  TmstUpdateObjectEvent = procedure (Sender: TObject; AObject: TmstObject) of object;

  TIndexRec = record
    ID: Integer;    // значение поля для поиска
    Index: Integer; // положение в индексируемом в списке
  end;

  TmstObjectInfo = record
    ObjectType: Integer;
    DatabaseId: Integer;
  end;

  TmstObjectList = class(TObjectList)
  private
    FOnUpdateObject: TmstUpdateObjectEvent;
  protected
    function GetItem(Index: Integer): TmstObject;
    procedure SetItem(Index: Integer; AObject: TmstObject);
  public
    function IndexOfDatabaseId(const DatabaseID: Integer): Integer;
    function GetByDatabaseId(const DatabaseID: Integer): TmstObject;
    property Items[Index: Integer]: TmstObject read GetItem write SetItem; default;
    property OnUpdateObject: TmstUpdateObjectEvent read FOnUpdateObject write FOnUpdateObject;
  end;

  // Не использовать пока!!!
  TmstGroupList = class(TObjectList)
  private
    FGroups: TObjectList;
    function GetGroups(Index: Integer): TmstObjectList;
    procedure GroupObjects;
  public
    constructor Create;
    // Группы объектов по ObjectId
    property Groups[Index: Integer]: TmstObjectList read GetGroups;
    function AddObject(AObject: TmstObject): Boolean;
  end;

  TmstObjectClass = class of TmstObject;
  TmstObjectListClass = class of TmstObjectList;

  TmstRegistry = class
  private
    FClasses: array of TmstObjectClass;
    FListClasses: array of TmstObjectListClass;
    FIDs: array of Integer;
    FNames: array of String;
    function GetIndexByID(const ID: Integer): Integer;
    procedure CheckIndex(const Index: Integer);
    function GetClasses(Index: Integer): TmstObjectClass;
    function GetListClasses(Index: Integer): TmstObjectListClass;
  public
    procedure RegisterObjectClass(AClass: TmstObjectClass;
      AListCLass: TmstObjectListClass; const ObjectId: Integer; const AName: String);
    function GetById(const ID: Integer): TmstObjectClass;
    function GetNameById(const ID: Integer): String;
    function GetListById(const ID: Integer): TmstObjectListClass;
    property Classes[Index: Integer]: TmstObjectClass read GetClasses;
    property ListClasses[Index: Integer]: TmstObjectListClass read GetListClasses;
    function Count: Integer;
  end;

  TmstLayer = class
  private
    FName: String;
    FCaption: String;
    FPosition: SmallInt;
    FLayerType: SmallInt;
    FVisible: Boolean;
    FHidden: Boolean;
    FId: Integer;
    FParent: TmstLayer;
    FChildLayers: TObjectList; 
    procedure SetName(const Value: String);
    procedure SetCaption(const Value: String);
    procedure SetPosition(const Value: SmallInt);
    procedure SetLayerType(const Value: SmallInt);
    procedure SetVisible(const Value: Boolean);
    procedure SetHidden(const Value: Boolean);
    procedure SetId(const Value: Integer);
    procedure SetParent(const Value: TmstLayer);
    function GetChild(Index: Integer): TmstLayer;
    function GetChildCount: Integer;
  public
    constructor Create;
    destructor Destroy; override;
    //
    property Id: Integer read FId write SetId;
    property Name: String read FName write SetName;
    property Caption: String read FCaption write SetCaption;
    // позиция в списке 0 - самый верхний
    property Position: SmallInt read FPosition write SetPosition;
    // 3 - слой импортирован
    // 2 - слой заполняется автоматически
    // 1 - слой заполняется автоматически
    // 0 - слой заполянется из файла
    property LayerType: SmallInt read FLayerType write SetLayerType;
    property Visible: Boolean read FVisible write SetVisible;
    property Hidden: Boolean read FHidden write SetHidden;
    property Parent: TmstLayer read FParent write SetParent;
    property ChildCount: Integer read GetChildCount;
    property Child[Index: Integer]: TmstLayer read GetChild;
    function AddChild(): TmstLayer;
    procedure AppendChild(aLayer: TmstLayer);
  end;

  TmstLayerEvent = procedure (Sender: TObject; Layer: TmstLayer) of object;

  TmstLayerList = class(TObjectList)
  private
    FReading: Boolean;
    FLayerControl: TControl;
    FOnLayerChanged: TmstLayerEvent;
    FOnDeleteLayer: TmstLayerEvent;
    FOnSelectLayer: TmstLayerEvent;
    FUpdateCount: Integer;
    procedure SetLayerControl(const Value: TControl);
    // Обновляет внешний вид контрола при изменении состояния слоев
    // Назначает обработчики событий для контрола
    procedure CaptureControl;
    procedure FreeControl;
    procedure UpdateControl;
    //
    procedure CaptureVST;
    procedure FreeVST;
    procedure UpdateVST;
    procedure VSTAddLayer(VST: TVirtualStringTree; aLayer: TmstLayer);
    function VSTFindNode(VST: TVirtualStringTree; aLayer: TmstLayer; Node: PVirtualNode): PVirtualNode;
    procedure VSTGetText(Sender: TBaseVirtualTree; Node: PVirtualNode; Column: TColumnIndex;
      TextType: TVSTTextType; var CellText: UnicodeString);
    procedure VStChecked(Sender: TBaseVirtualTree; Node: PVirtualNode);
    procedure VSTAddToSelection(Sender: TBaseVirtualTree; Node: PVirtualNode);
    procedure ReadStateFromVST;
    procedure ReadLayerStateFromVST(VST: TVirtualStringTree; aLayer: TmstLayer);
    //
    procedure CaptureCheckListBox;
    procedure FreeCheckListBox;
    procedure UpdateCheckListBox;
    procedure LayerControlClick(Sender: TObject);
    procedure LayerClick(Sender: TObject);
    procedure ReadStateFromCheckBox;
    //
    procedure BeginUpdate();
    procedure EndUpdate();
    function InUpdate(): Boolean;
  protected
    function GetItem(Index: Integer): TmstLayer;
    procedure SetItem(Index: Integer; ALayer: TmstLayer);
    procedure Notify(Ptr: Pointer; Action: TListNotification); override;
  public
    destructor Destroy; override;
    function AddLayer: TmstLayer;
    function GetById(const aId: Integer): TmstLayer;
    function GetByName(const AName: String; CaseSensetive: Boolean): TmstLayer;
    function IndexOfName(const aName: String): Integer;
    function FirstByPosition: TmstLayer;
    function LastByPosition: TmstLayer;
    function NextByPosition(FromLayer: TmstLayer): TmstLayer;
    function GetMaxPosition(): Integer;
    function FindLayerByName(const aLayerName: string): TmstLayer;
    procedure Connect(aLayer: TmstLayer; ParentLayerId: Integer);

    property Items[Index: Integer]: TmstLayer read GetItem write SetItem; default;
    property LayerControl: TControl read FLayerControl write SetLayerControl;
    property OnLayerChanged: TmstLayerEvent read FOnLayerChanged write FOnLayerChanged;
    property OnDeleteLayer: TmstLayerEvent read FOnDeleteLayer write FOnDeleteLayer;
    property OnSelectLayer: TmstLayerEvent read FOnSelectLayer write FOnSelectLayer;
  end;

  TmstMapList = class;

  TmstMap = class(TmstObject)
  private
    FList: TmstMapList;
    FMapName: String;
    FFileName: String;
    FImageLoaded: Boolean;
    FMapEntityId: Integer;
    FMapImageId: Integer;
    FImageExt: TmstImageExt;
    procedure SetMapName(const Value: String);
    procedure SetFileName(const Value: String);
    procedure SetImageLoaded(const Value: Boolean);
    procedure SetMapEntityId(const Value: Integer);
    procedure SetMapImageId(const Value: Integer);
    procedure Init;
    procedure SetImageExt(const Value: TmstImageExt);
  protected
    function GetObjectId: Integer; override;
    function GetText: String; override;
  public
    constructor Create; override;
    // Номенклатура
    property MapName: String read FMapName write SetMapName;
    property ImageExt: TmstImageExt read FImageExt write SetImageExt;
    // Полный путь к файлу картинки
    property FileName: String read FFileName write SetFileName;
    // Загружена картинка или нет
    property ImageLoaded: Boolean read FImageLoaded write SetImageLoaded;
    // ID в слое MAPS
    property MapEntityId: Integer read FMapEntityId write SetMapEntityId;
    // ID в слое MAP_IMAGES
    property MapImageId: Integer read FMapImageId write SetMapImageId;
  end;

  TmstMapList = class(TmstObjectList)
  private
    FImageCounter: Cardinal;
  protected
    function GetItem(Index: Integer): TmstMap;
    procedure SetItem(Index: Integer; AMap: TmstMap);
  public
    constructor Create(OwnItems: Boolean = True);
    function GetByDatabaseId(const DatabaseID: Integer): TmstMap;
    function GetByMapEntityId(const MapEntityId: Integer): TmstMap;
    function GetByMapImageId(const MapImageId: Integer): TmstMap;
    function GetByNomenclature(const aNomenclature: String; const CaseSensitive: Boolean): TmstMap;
    function AddMap: TmstMap;
    procedure IncCounter;
    property ImageCounter: Cardinal read FImageCounter;
    property Items[Index: Integer]: TmstMap read GetItem write SetItem; default;
  end;

  TmstStreet = class(TmstObject)
  private
    FName: String;
    FEntityId: Integer;
    FMark: String;
    procedure SetName(const Value: String);
    procedure SetEntityId(const Value: Integer);
    procedure SetMark(const Value: String);
  protected
    function GetObjectId: Integer; override;
    function GetText: String; override;
  public
    // Название улицы
    property Name: String read FName write SetName;
    // Сокращение типа улицы
    property Mark: String read FMark write SetMark;
    property EntityId: Integer read FEntityId write SetEntityId;
  end;

  TmstStreetList = class(TmstObjectList)
  protected
    function GetItem(Index: Integer): TmstStreet;
    procedure SetItem(Index: Integer; AStreet: TmstStreet);
  public
    property Items[Index: Integer]: TmstStreet read GetItem write SetItem; default;
    function GetByDatabaseId(const DatabaseID: Integer): TmstStreet;
    function AddStreet: TmstStreet;
  end;

  TmstLotCategory = class
  private
    FName: String;
    FId: Integer;
    procedure SetId(const Value: Integer);
    procedure SetName(const Value: String);
  public
    function GetLayerName(): string;
    function GetLayerCaption(): string;
    function GetNodeType(): Integer;
    function GetNodeImageIndex(): Integer;
    function GetRootNodeType(): Integer;
    function GetRootNodeImageIndex(): Integer;
    //
    property Id: Integer read FId write SetId;
    property Name: String read FName write SetName;
  end;

  TmstMPLayer = class
  private
    FName: String;
    FGroupId: Integer;
    FId: Integer;
    FIsGroup: Integer;
    procedure SetGroupId(const Value: Integer);
    procedure SetId(const Value: Integer);
    procedure SetIsGroup(const Value: Integer);
    procedure SetName(const Value: String);
  public
    property Id: Integer read FId write SetId;
    property Name: String read FName write SetName;
    property IsGroup: Integer read FIsGroup write SetIsGroup;
    property GroupId: Integer read FGroupId write SetGroupId;
  end;

  TmstAddress = class(TmstObject)
  private
    FStreetDatabaseId: Integer;
    FName: String;
    FColor: Integer;
    FEntityID: Integer;
    FX: Double;
    FY: Double;
    FHeight: Double;
    FAngle: Double;
    procedure SetStreetDatabaseId(const Value: Integer);
    procedure SetName(const Value: String);
    procedure SetColor(const Value: Integer);
    procedure SetEntityID(const Value: Integer);
  protected
    function GetObjectId: Integer; override;
    function GetText: String; override;
  public
    property StreetDatabaseId: Integer read FStreetDatabaseId write SetStreetDatabaseId;
    property Name: String read FName write SetName;
    property Color: Integer read FColor write SetColor;
    property EntityID: Integer read FEntityID write SetEntityID;
    property X: Double read FX write FX;
    property Y: Double read FY write FY;
    property Height: Double read FHeight write FHeight;
    property Angle: Double read FAngle write FAngle;
  end;

  TmstAddressList = class(TmstObjectList)
  protected
    function GetItem(Index: Integer): TmstAddress;
    procedure SetItem(Index: Integer; AAddress: TmstAddress);
  public
    property Items[Index: Integer]: TmstAddress read GetItem write SetItem; default;
    function GetByDatabaseId(const DatabaseID: Integer): TmstAddress;
    function AddAddress: TmstAddress;
  end;

  ImstLotCategories = interface
    ['{D472FD37-E05A-4513-A383-4480FFDC18E2}']
    function CategoryById(CategoryId: Integer): TmstLotCategory;
  end;

  TmstObjectSemantic = class
  private
    FFields: TmstLayerFields;
    FFieldValues: TmstObjectFieldValues;
    procedure SetFields(const Value: TmstLayerFields);
    procedure SetFieldValues(const Value: TmstObjectFieldValues);
  public
    constructor Create;
    destructor Destroy; override;
    //
    procedure LoadFieldCaptions(aStrings: TStrings);
    //
    property Fields: TmstLayerFields read FFields write SetFields;
    property FieldValues: TmstObjectFieldValues read FFieldValues write SetFieldValues;
  end;

const
  BAD_ENTITY_ID = 0;

var
  mstRegistry: TmstRegistry;

implementation

uses
  // Common
  uGC, uVCLUtils,
  // Project
  uMStKernelConsts, uMStKernelClassesPropertiesViewers,
  uMStClassesProjects;

type
  PVSTLayer = ^TVSTLayer;
  TVSTLayer = record
    Layer: TmstLayer;
  end;

{ TmstMap }

constructor TmstMap.Create;
begin
  inherited;
  Init;
end;

function TmstMap.GetObjectId: Integer;
begin
  Result := ID_MAP;
end;

function TmstMap.GetText: String;
begin
  Result := 'Планшет ' + MapName;
end;

procedure TmstMap.Init;
begin
  FList := nil;
  FDatabaseId := -1;
  FMapName := '';
  FImageLoaded := False;
  FFileName := '';
  FMapEntityId := -1;
  FMapImageId := -1;
end;

procedure TmstMap.SetFileName(const Value: String);
begin
  FFileName := Value;
end;

procedure TmstMap.SetImageExt(const Value: TmstImageExt);
begin
  FImageExt := Value;
end;

procedure TmstMap.SetImageLoaded(const Value: Boolean);
begin
  FImageLoaded := Value;
//  if Assigned(FList) then
//    Inc(FList.FImageCounter);
end;

procedure TmstMap.SetMapEntityId(const Value: Integer);
begin
  FMapEntityId := Value;
end;

procedure TmstMap.SetMapImageId(const Value: Integer);
begin
  FMapImageId := Value;
end;

procedure TmstMap.SetMapName(const Value: String);
begin
  FMapName := Value;
end;

{ TmstMapList }

function TmstMapList.AddMap: TmstMap;
begin
  Result := TmstMap.Create;
  Self.Add(Result);
  Result.FList := Self;
end;

constructor TmstMapList.Create(OwnItems: Boolean);
begin
  inherited Create(OwnItems);
  FImageCounter := 0;
end;

function TmstMapList.GetByDatabaseId(const DatabaseID: Integer): TmstMap;
begin
  Result := TmstMap(inherited GetByDatabaseId(DatabaseID));
end;

function TmstMapList.GetByMapEntityId(const MapEntityId: Integer): TmstMap;
var
  I: Integer;
begin
  for I := 0 to Pred(Count) do
    if Items[I].MapEntityId = MapEntityId then
    begin
      Result := Items[I];
      Exit;
    end;
  Result := nil;
end;

function TmstMapList.GetByMapImageId(const MapImageId: Integer): TmstMap;
var
  I: Integer;
begin
  for I := 0 to Pred(Count) do
    if Items[I].MapImageId = MapImageId then
    begin
      Result := Items[I];
      Exit;
    end;
  Result := nil;
end;

function TmstMapList.GetByNomenclature(const aNomenclature: String;
  const CaseSensitive: Boolean): TmstMap;
var
  I: Integer;
  CmpNomenclature: string;
  CmpMapNameUp: string;
begin
  CmpNomenclature := IfThen(CaseSensitive, aNomenclature, AnsiUpperCase(aNomenclature));
  for I := 0 to Pred(Count) do
  begin
    CmpMapNameUp := IfThen(CaseSensitive, Items[I].MapName, AnsiUpperCase(Items[I].MapName));
    if CmpMapNameUp = CmpNomenclature then
    begin
      Result := Items[I];
      Exit;
    end;
  end;
  Result := nil;
end;

function TmstMapList.GetItem(Index: Integer): TmstMap;
begin
  Result := TmstMap(inherited Items[Index]);
end;

procedure TmstMapList.IncCounter;
begin
  Inc(FImageCounter);
end;

procedure TmstMapList.SetItem(Index: Integer; AMap: TmstMap);
begin
  inherited Items[Index] := AMap;
  AMap.FList := Self;
end;

{ TmstLayer }

function TmstLayer.AddChild: TmstLayer;
begin
  Result := TmstLayer.Create;
  Result.Parent := Self;
  FChildLayers.Add(Result);
end;

procedure TmstLayer.AppendChild(aLayer: TmstLayer);
begin
  aLayer.Parent := Self;
  FChildLayers.Add(aLayer);
end;

constructor TmstLayer.Create;
begin
  inherited;
  FChildLayers := TObjectList.Create;
end;

destructor TmstLayer.Destroy;
begin
  FChildLayers.Free;
  inherited;
end;

function TmstLayer.GetChild(Index: Integer): TmstLayer;
begin
  Result := TmstLayer(FChildLayers[Index]);
end;

function TmstLayer.GetChildCount: Integer;
begin
  Result := FChildLayers.Count;
end;

procedure TmstLayer.SetCaption(const Value: String);
begin
  FCaption := Value;
end;

procedure TmstLayer.SetHidden(const Value: Boolean);
begin
  FHidden := Value;
end;

procedure TmstLayer.SetId(const Value: Integer);
begin
  FId := Value;
end;

procedure TmstLayer.SetLayerType(const Value: SmallInt);
begin
  FLayerType := Value;
end;

procedure TmstLayer.SetName(const Value: String);
begin
  FName := Value;
end;

procedure TmstLayer.SetParent(const Value: TmstLayer);
begin
  FParent := Value;
end;

procedure TmstLayer.SetPosition(const Value: SmallInt);
begin
  FPosition := Value;
end;

procedure TmstLayer.SetVisible(const Value: Boolean);
begin
  FVisible := Value;
end;

{ TmstLayerList }

function TmstLayerList.AddLayer: TmstLayer;
begin
  Result := TmstLayer.Create;
  Self.Add(Result); 
end;

procedure TmstLayerList.BeginUpdate;
begin
  Inc(FUpdateCount);
end;

procedure TmstLayerList.CaptureCheckListBox;
begin
  TCheckListBox(FLayerControl).OnClickCheck := Self.LayerControlClick;
  TCheckListBox(FLayerControl).OnClick := Self.LayerClick;
end;

procedure TmstLayerList.CaptureControl;
begin
  if FLayerControl is TCheckListBox then
  begin
    CaptureCheckListBox();
  end
  else
  if FLayerControl is TVirtualStringTree then
  begin
    CaptureVST();
  end;
end;

procedure TmstLayerList.CaptureVST;
var
  VST: TVirtualStringTree;
begin
  VST := TVirtualStringTree(FLayerControl);
  VST.NodeDataSize := SizeOf(TVSTLayer);
  VST.OnGetText := VSTGetText;
  VST.OnChecked := VSTChecked;
  VST.OnAddToSelection := VSTAddToSelection;
end;

procedure TmstLayerList.Connect(aLayer: TmstLayer; ParentLayerId: Integer);
var
  aParent: TmstLayer;
  OldOwnObjects: Boolean;
begin
  aParent := GetById(ParentLayerId);
  if Assigned(aParent) and (aParent <> aLayer) then
  begin
    OldOwnObjects := Self.OwnsObjects;
    try
      Self.OwnsObjects := False;
      //
      Self.Extract(aLayer);
      aParent.AppendChild(aLayer);
    finally
      Self.OwnsObjects := OldOwnObjects;
    end;
  end; 
end;

destructor TmstLayerList.Destroy;
begin
  if Assigned(FLayerControl) then
    FreeControl;
  inherited;
end;

procedure TmstLayerList.EndUpdate;
begin
  Dec(FUpdateCount);
  if FUpdateCount < 0 then
    FUpdateCount := 0;
end;

function TmstLayerList.FindLayerByName(const aLayerName: string): TmstLayer;
var
  I: Integer;
begin
  for I := 0 to Count - 1 do
  begin
    if Items[I].Name = aLayerName then
    begin
      Result := Items[I];
      Exit;
    end;
  end;
  Result := nil;
end;

function TmstLayerList.FirstByPosition: TmstLayer;
var
  I, Pos, LayerIndex: Integer;
begin
  Pos := MaxInt;
  LayerIndex := -1;
  for I := 0 to Pred(Count) do
  if Items[I].Position < Pos then
  begin
    Pos := Items[I].Position;
    LayerIndex := I;
  end;
  Result := Items[LayerIndex];
end;

procedure TmstLayerList.FreeCheckListBox;
begin
  TCheckListBox(FLayerControl).OnClickCheck := nil;
end;

procedure TmstLayerList.FreeControl;
begin
  if FLayerControl is TCheckListBox then
    FreeCheckListBox()
  else
  if FLayerControl is TVirtualStringTree then
    FreeVST();
  FLayerControl := nil;
end;

procedure TmstLayerList.FreeVST;
var
  VST: TVirtualStringTree;
begin
  VST := TVirtualStringTree(FLayerControl);
  VST.OnGetText := nil;
  VST.OnChecked := nil;
  VST.OnAddToSelection := nil;
end;

function TmstLayerList.GetById(const aId: Integer): TmstLayer;
var
  I: Integer;
begin
  for I := 0 to Count - 1 do
    if aId = Items[I].Id then
    begin
      Result := Items[I];
      Exit;
    end;
  Result := nil;
end;

function TmstLayerList.GetByName(const AName: String; CaseSensetive: Boolean): TmstLayer;
var
  I: Integer;
begin
  if CaseSensetive then
  begin
    I := IndexOfName(aName);
    if I >= 0 then
      Result := Items[I]
    else
      Result := nil;
  end
  else
  begin
    for I := 0 to Count - 1 do
    begin
      if AnsiUpperCase(Items[I].Name) = AnsiUpperCase(AName) then
      begin
        Result := Items[I];
        Exit;
      end;
    end;
    Result := nil;
  end;
end;

function TmstLayerList.GetItem(Index: Integer): TmstLayer;
begin
  Result := TmstLayer(inherited Items[Index]);
end;

function TmstLayerList.GetMaxPosition: Integer;
var
  I: Integer;
begin
  Result := 0;
  for I := 0 to Count - 1 do
    if Items[I].Position > Result then
      Result := Items[I].Position;
end;

function TmstLayerList.IndexOfName(const aName: String): Integer;
var
  I: Integer;
begin
  for I := 0 to Pred(Count) do
    if Items[I].Name = AName then
    begin
      Result := I;
      Exit;
    end;
  Result := -1;
end;

function TmstLayerList.InUpdate: Boolean;
begin
  Result := FUpdateCount > 0;
end;

function TmstLayerList.LastByPosition: TmstLayer;
var
  I, Pos, LayerIndex: Integer;
begin
  Pos := -MaxInt;
  LayerIndex := -1;
  for I := 0 to Pred(Count) do
  if Items[I].Position > Pos then
  begin
    Pos := Items[I].Position;
    LayerIndex := I;
  end;
  Result := Items[LayerIndex];
end;

procedure TmstLayerList.LayerClick(Sender: TObject);
begin
  if Assigned(FLayerControl) then
  begin
    if FLayerControl is TCheckListBox then
      ReadStateFromCheckBox()
    else
    if FLayerControl is TVirtualStringTree then
      ReadStateFromVST();
  end;
end;

procedure TmstLayerList.LayerControlClick(Sender: TObject);
begin
  if Assigned(FLayerControl) then
  begin
    if FLayerControl is TCheckListBox then
      ReadStateFromCheckBox()
    else
    if FLayerControl is TVirtualStringTree then
      ReadStateFromVST();
  end;
end;

function TmstLayerList.NextByPosition(FromLayer: TmstLayer): TmstLayer;
var
  I, Pos: Integer;
begin
  Pos := MaxInt;
  Result := nil;
  for I := 0 to Pred(Count) do
  if (Items[I].Position > FromLayer.Position) and (Items[I].Position < Pos) then
  begin
    Pos := Items[I].Position;
    Result := Items[I];
  end;
end;

procedure TmstLayerList.Notify(Ptr: Pointer; Action: TListNotification);
begin
  if Action = lnDeleted then
    if Assigned(FOnDeleteLayer) then
      FOnDeleteLayer(Self, Ptr);
  inherited Notify(Ptr, Action);
  UpdateControl;
end;

procedure TmstLayerList.ReadLayerStateFromVST(VST: TVirtualStringTree; aLayer: TmstLayer);
var
  N: PVirtualNode;
  NodeChecked: Boolean;
  NodeSelected: Boolean;
begin
  // ищем слой в дереве
  N := VSTFindNode(VST, aLayer, nil);
  if Assigned(N) then
  begin
    NodeChecked := VST.CheckState[N] = csCheckedNormal;
    if aLayer.Visible <> NodeChecked then
    begin
      aLayer.Visible := NodeChecked;
      if Assigned(FOnLayerChanged) then
        FOnLayerChanged(Self, aLayer);
    end;
    NodeSelected := VST.Selected[N];
    if NodeSelected then
      if Assigned(FOnSelectLayer) then
        FOnSelectLayer(Self, aLayer);
  end;
end;

procedure TmstLayerList.ReadStateFromCheckBox;
var
  I, J: Integer;
begin
  FReading := True;
  try
    for I := 0 to Pred(Self.Count) do
    begin
      J := TCheckListBox(FLayerControl).Items.IndexOf(Self[I].Caption);
      if J >= 0 then
      begin
        if Self[I].Visible <> TCheckListBox(FLayerControl).Checked[J] then
        begin
          Self[I].Visible := TCheckListBox(FLayerControl).Checked[J];
          if Assigned(FOnLayerChanged) then
            FOnLayerChanged(Self, Self[I]);
        end;
        if TCheckListBox(FLayerControl).ItemIndex = J then
          if Assigned(FOnSelectLayer) then
            FOnSelectLayer(Self, Self[I]);
      end;
    end;
  finally
    FReading := False; 
  end;
end;

procedure TmstLayerList.ReadStateFromVST;
var
  I, J: Integer;
  VST: TVirtualStringTree;
  Layer: TmstLayer;
begin
  FReading := True;
  try
    VST := TVirtualStringTree(FLayerControl);
    for I := 0 to Pred(Self.Count) do
    begin
      Layer := Self[I];
      ReadLayerStateFromVST(VST, Layer);
      for J := 0 to Layer.ChildCount - 1 do
        ReadLayerStateFromVST(VST, Layer.Child[J]);
    end;
  finally
    FReading := False; 
  end;
end;

procedure TmstLayerList.SetItem(Index: Integer; ALayer: TmstLayer);
begin
  inherited Items[Index] := ALayer;
  if not FReading then
    UpdateControl;
end;

procedure TmstLayerList.SetLayerControl(const Value: TControl);
begin
  FreeControl;
  FLayerControl := Value;
  CaptureControl;
  UpdateControl;
end;

procedure TmstLayerList.UpdateCheckListBox;
var
//  TmpLayer, LastLayer: TmstLayer;
  AControl: TCheckListBox;
  I, J: Integer;
begin
  AControl := FLayerControl as TCheckListBox;
  begin
    AControl.Items.Clear;
    if Self.Count > 0 then
//    begin
      for I := 0 to Pred(Self.Count) do
        if not Self[I].Hidden then
        begin
          J := AControl.Items.Add(Self[I].Caption);
          AControl.Checked[J] := Self[I].Visible;
        end;
{      TmpLayer := Self.FirstByPosition;
      LastLayer := Self.LastByPosition;
      repeat
        I := AControl.Items.Add(TmpLayer.Caption);
        AControl.Checked[I] := TmpLayer.Visible;
        TmpLayer := Self.NextByPosition(TmpLayer);
      until (TmpLayer = LastLayer);
    end;  }
  end;
end;

procedure TmstLayerList.UpdateControl;
begin
  if Assigned(FLayerControl) then
  begin
    if FLayerControl is TCheckListBox then
      UpdateCheckListBox()
    else
    if FLayerControl is TVirtualStringTree then
      UpdateVST();
  end;
end;

procedure TmstLayerList.UpdateVST;
var
  Layer: TmstLayer;
  VST: TVirtualStringTree;
  I: Integer;
begin
  VST := FLayerControl as TVirtualStringTree;
  BeginUpdate;
  try
    VST.Clear();
    if Self.Count > 0 then
      for I := 0 to Pred(Self.Count) do
      begin
        Layer := Self[I];
        VSTAddLayer(VST, Layer);
      end;
  finally
    EndUpdate;
  end;
end;

procedure TmstLayerList.VSTAddLayer(VST: TVirtualStringTree; aLayer: TmstLayer);
var
  I: Integer;
//  SubLayer: TmstLayer;
  N: PVirtualNode;
  ParentN: PVirtualNode;
  P: PVSTLayer;
begin
  ParentN := nil;//VST.RootNode;
  if aLayer.Parent <> nil then
  begin
    ParentN := VSTFindNode(VST, aLayer.Parent, nil);
//    if ParentN = nil then
//      ParentN := VST.RootNode;
  end;
  //
  VST.BeginUpdate;
  try
    N := VST.AddChild(ParentN);
    P := VST.GetNodeData(N);
    P.Layer := aLayer;
    N.CheckType := ctCheckBox;
    if aLayer.Visible then
      VST.CheckState[N] := csCheckedNormal
    else
      VST.CheckState[N] := csUncheckedNormal;
    //
    for I := 0 to aLayer.ChildCount - 1 do
    begin
      VSTAddLayer(VST, aLayer.Child[I]);
    end;
  finally
    VST.EndUpdate;
  end;
end;

procedure TmstLayerList.VSTAddToSelection(Sender: TBaseVirtualTree; Node: PVirtualNode);
var
  P: PVSTLayer;
begin
  if InUpdate then
    Exit;
  P := Sender.GetNodeData(Node);
  if Assigned(FOnSelectLayer) then
    FOnSelectLayer(Self, P.Layer);
end;

procedure TmstLayerList.VStChecked(Sender: TBaseVirtualTree; Node: PVirtualNode);
var
  P: PVSTLayer;
  L: TmstLayer;
begin
  if InUpdate then
    Exit;
  P := Sender.GetNodeData(Node);
  L := P.Layer;
  L.Visible := Sender.CheckState[Node] = csCheckedNormal;
  if Assigned(FOnLayerChanged) then
    FOnLayerChanged(Self, L);
end;

function TmstLayerList.VSTFindNode(VST: TVirtualStringTree; aLayer: TmstLayer; Node: PVirtualNode): PVirtualNode;
var
  N: PVirtualNode;
  P: PVSTLayer;
//  R: TVSTLayer;
begin
  Result := nil;
  if Node = nil then
    Node := VST.RootNode;
  N := Node.FirstChild;
  while Assigned(N) do
  begin
    P := VST.GetNodeData(N);
    if P.Layer = aLayer then
    begin
      Result := N;
      Exit;
    end;
    //
    if N.ChildCount > 0 then
    begin
      Result := VSTFindNode(VST, aLayer, N);
      if Result <> nil then
        Exit;
    end;
    N := N.NextSibling;
  end;
end;

procedure TmstLayerList.VSTGetText(Sender: TBaseVirtualTree; Node: PVirtualNode; Column: TColumnIndex;
  TextType: TVSTTextType; var CellText: UnicodeString);
var
  P: PVSTLayer;
  L: TmstLayer;
begin
  try
    P := Sender.GetNodeData(Node);
    L := P.Layer;
    CellText := L.Caption;
  except
    CellText := 'Слой не найден!';
  end;
end;

{ TmstStreet }

function TmstStreet.GetObjectId: Integer;
begin
  Result := ID_STREET;
end;

function TmstStreet.GetText: String;
begin
  Result := Mark + ' ' + Name;
end;

procedure TmstStreet.SetEntityId(const Value: Integer);
begin
  FEntityId := Value;
end;

procedure TmstStreet.SetMark(const Value: String);
begin
  FMark := Value;
end;

procedure TmstStreet.SetName(const Value: String);
begin
  FName := Value;
end;

{ TmasStreetList }

function TmstStreetList.AddStreet: TmstStreet;
begin
  Result := TmstStreet.Create;
  Self.Add(Result);
end;

function TmstStreetList.GetByDatabaseId(
  const DatabaseID: Integer): TmstStreet;
begin
  Result := TmstStreet(inherited GetByDatabaseId(DatabaseID));
end;

function TmstStreetList.GetItem(Index: Integer): TmstStreet;
begin
  Result := TmstStreet(inherited Items[Index]);
end;

procedure TmstStreetList.SetItem(Index: Integer; AStreet: TmstStreet);
begin
  inherited Items[Index] := AStreet;
end;

{ TmstObject }

procedure TmstObject.AssignTo(Source: TPersistent);
begin
  inherited;

end;

constructor TmstObject.Create;
begin
  FDatabaseId := -1;
end;

function TmstObject.GetObjectId: Integer;
begin
  Result := ID_NONE;
end;

function TmstObject.GetText: String;
begin
  Result := 'Путой объект';
end;

{ TmstObjects }

function TmstObjectList.GetByDatabaseId(const DatabaseID: Integer): TmstObject;
var
  I: Integer;
begin
  I := IndexOfDatabaseId(DatabaseID);
  if I >= 0 then
    Result := TmstObject(Items[I])
  else
    Result := nil;
end;

{ TmstRegistry }

procedure TmstRegistry.CheckIndex(const Index: Integer);
begin
  if (Index < 0) or (Index > High(FIDs)) then
    raise Exception.Create('Invalid index value!');
end;

function TmstRegistry.Count: Integer;
begin
  Result := Length(FIDs);
end;

function TmstRegistry.GetById(const ID: Integer): TmstObjectClass;
var
  I: Integer;
begin
  I := GetIndexByID(ID);
  if I >= 0 then
    Result := FClasses[I]
  else
    Result := nil;
end;

function TmstRegistry.GetClasses(Index: Integer): TmstObjectClass;
begin
  CheckIndex(Index);
  Result := FClasses[Index];
end;

function TmstRegistry.GetIndexByID(const ID: Integer): Integer;
var
  I: Integer;
begin
  for I := 0 to Pred(Length(FIDs)) do
    if FIDs[I] = ID then
    begin
      Result := I;
      Exit;
    end;
  Result := -1;
end;

function TmstRegistry.GetListById(const ID: Integer): TmstObjectListClass;
var
  I: Integer;
begin
  I := GetIndexByID(ID);
  if I < 0 then
    Result := nil
  else
    Result := FListClasses[I];
end;

function TmstRegistry.GetListClasses(Index: Integer): TmstObjectListClass;
begin
  CheckIndex(Index);
  Result := FListCLasses[Index];
end;

function TmstRegistry.GetNamebyId(const ID: Integer): String;
var
  I: Integer;
begin
  I := GetIndexByID(ID);
  if I >= 0 then
    Result := FNames[I]
  else
    Result := '';
end;

procedure TmstRegistry.RegisterObjectClass(AClass: TmstObjectClass; AListClass: TmstObjectListClass;
  const ObjectId: Integer; const AName: String);
var
  I: Integer;
begin
  I := GetIndexByID(ObjectId);
  if I < 0 then
  begin
    SetLength(FClasses, Length(FClasses) + 1);
    SetLength(FListClasses, Length(FClasses));
    SetLength(FIDs, Length(FClasses));
    SetLength(FNames, Length(FClasses));
    FClasses[High(FCLasses)] := AClass;
    FIDs[High(FIDs)] := ObjectId;
    FListClasses[High(FListClasses)] := AListClass;
    FNames[High(FNames)] := AName;
  end
  else
    raise Exception.CreateFmt('Object class %s already registered!', [AClass.ClassName]);
end;

function TmstGroupList.AddObject(AObject: TmstObject): Boolean;
begin
  raise Exception.Create('TmstGroupList.AddObject not implemented!');
end;

constructor TmstGroupList.Create;
begin
  raise Exception.Create('TmstGroupList не продуман!');
  inherited Create(False);
  GroupObjects;
end;

function TmstGroupList.GetGroups(Index: Integer): TmstObjectList;
begin
  raise Exception.Create('TmstGroupList.GetGroups not implemented!');
  Result := TmstObjectList(FGroups[Index]);
end;

procedure TmstGroupList.GroupObjects;
begin
  raise Exception.Create('TmstGroupList.GroupObjects not implemented!');
end;

{ TmstAddress }

function TmstAddress.GetObjectId: Integer;
begin
  Result := ID_ADDRESS;
end;

function TmstAddress.GetText: String;
begin
  Result := Name;
end;

procedure TmstAddress.SetColor(const Value: Integer);
begin
  FColor := Value;
end;

procedure TmstAddress.SetEntityID(const Value: Integer);
begin
  FEntityID := Value;
end;

procedure TmstAddress.SetName(const Value: String);
begin
  FName := Value;
end;

procedure TmstAddress.SetStreetDatabaseId(const Value: Integer);
begin
  FStreetDatabaseId := Value;
end;

{ TmstAddressList }

function TmstAddressList.AddAddress: TmstAddress;
begin
  Result := TmstAddress.Create;
  Self.Add(Result);
end;

function TmstAddressList.GetByDatabaseId(
  const DatabaseID: Integer): TmstAddress;
begin
  Result := TmstAddress(inherited GetByDatabaseId(DatabaseId));
end;

function TmstAddressList.GetItem(Index: Integer): TmstAddress;
begin
  Result := TmstAddress(inherited GetItem(Index));
end;

procedure TmstAddressList.SetItem(Index: Integer; AAddress: TmstAddress);
begin
  inherited SetItem(Index, AAddress);
end;

function TmstObjectList.GetItem(Index: Integer): TmstObject;
begin
  Result := TmstObject(inherited GetItem(Index));
end;

function TmstObjectList.IndexOfDatabaseId(const DatabaseID: Integer): Integer;
var
  I: Integer;
begin
  for I := 0 to Pred(Count) do
    if TmstObject(Items[I]).DatabaseId = DatabaseID then
    begin
      Result := I;
      Exit;
    end;
  Result := -1;
end;

procedure TmstObjectList.SetItem(Index: Integer; AObject: TmstObject);
begin
  inherited SetItem(Index, AObject);
end;

{ TmstUser }

procedure TmstUser.SetIsAdministrtor(const Value: Boolean);
begin
  FIsAdministrator := Value;
end;

procedure TmstUser.SetMapReportErrorMode(const Value: TmstMapReportErrorMode);
begin
  FMapReportErrorMode := Value;
end;

constructor TmstUser.Create;
begin
  FUserName := S_GUEST;
  FPassword := AnsiLowerCase(S_GUEST);
end;

procedure TmstUser.SetCanManageProjects(const Value: Boolean);
begin
  FCanManageProjects := Value;
end;

procedure TmstUser.SetCanPrint(const Value: Boolean);
begin
  FCanPrint := Value;
end;

procedure TmstUser.SetId(const Value: Integer);
begin
  FId := Value;
end;

procedure TmstUser.SetInitialName(const Value: String);
begin
  FInitialName := Value;
end;

procedure TmstUser.SetOfficeId(const Value: Integer);
begin
  FOfficeId := Value;
end;

procedure TmstUser.SetPassword(const Value: string);
begin
  FPassword := Value;
end;

procedure TmstUser.SetUserName(const Value: String);
begin
  FUserName := Value;
end;

{ TmstLotCategory }

function TmstLotCategory.GetLayerCaption: string;
begin
  case Id of
  -3 : Result := 'Отводы';
  -2 : Result := 'Отводы аннулированные';
  -1 : Result := 'Отводы архивные';
  else
       Result := 'Отводы - ' + Name;
  end;
end;

function TmstLotCategory.GetLayerName: string;
begin
  case Id of
  -3 : Result := SL_LOTS;
  -2 : Result := SL_ANNULLED_LOTS;
  -1 : Result := SL_ACTUAL_LOTS;
  else
       Result := SL_LOTS + '_' + IntToStr(Id);
  end;
end;

function TmstLotCategory.GetNodeImageIndex: Integer;
begin
  case Id of
  -3 : Result := IMAGE_LOT;
  -2 : Result := IMAGE_ANNULED_LOT;
  -1 : Result := IMAGE_ACTUAL_LOT;
   0 : Result := IMAGE_LOT_TRASH;
  else
       Result := IMAGE_LOT_CATEGORIZED;
  end;
end;

function TmstLotCategory.GetNodeType: Integer;
begin
  case Id of
  -2 : Result := ID_NODETYPE_LOT_ANNULED;
  -1 : Result := ID_NODETYPE_LOT_ACTUAL;
  -3 : Result := ID_NODETYPE_LOT;
  else
       Result := ID_NODETYPE_LOT_CATEGORIZED;
  end;
end;

function TmstLotCategory.GetRootNodeImageIndex: Integer;
begin
  case Id of
  -2 : Result := IMAGE_ANNULLED_LOTS_ROOT;
  -1 : Result := IMAGE_ACTUAL_LOTS_ROOT;
  -3 : Result := IMAGE_LOTS_ROOT;
  else
       Result := IMAGE_LOTS_ROOT;
  end;
end;

function TmstLotCategory.GetRootNodeType(): Integer;
begin
  case Id of
  -2 : Result := ID_NODETYPE_LOT_ANNULED_ROOT;
  -1 : Result := ID_NODETYPE_LOT_ACTUAL_ROOT;
  -3 : Result := ID_NODETYPE_LOT_ROOT;
  else
       Result := ID_NODETYPE_LOT_CATEGORIZED_ROOT;
  end;
end;

procedure TmstLotCategory.SetId(const Value: Integer);
begin
  FId := Value;
end;

procedure TmstLotCategory.SetName(const Value: String);
begin
  FName := Value;
end;

{ TmstObjectSemantic }

constructor TmstObjectSemantic.Create;
begin
  FFields := TmstLayerFields.Create;
  FFieldValues := TmstObjectFieldValues.Create;
end;

destructor TmstObjectSemantic.Destroy;
begin
  FFieldValues.Free;
  FFields.Free;
  inherited;
end;

procedure TmstObjectSemantic.LoadFieldCaptions(aStrings: TStrings);
var
  I, J: Integer;
  FldName, FldCap: string;
  Fld: TmstLayerField;
begin
  I := 0;
  J := Succ(I);
  while J < aStrings.Count do
  begin
    FldName := aStrings[I];
    FldCap := aStrings[J];
    Fld := FFields.Find(FldName);
    if Assigned(Fld) then
      Fld.Caption := FldCap;
    I := J + 1;
    J := Succ(I);
  end; 
end;

procedure TmstObjectSemantic.SetFields(const Value: TmstLayerFields);
begin
  FFields := Value;
end;

procedure TmstObjectSemantic.SetFieldValues(const Value: TmstObjectFieldValues);
begin
  FFieldValues := Value;
end;

{ TmstMPLayer }

procedure TmstMPLayer.SetGroupId(const Value: Integer);
begin
  FGroupId := Value;
end;

procedure TmstMPLayer.SetId(const Value: Integer);
begin
  FId := Value;
end;

procedure TmstMPLayer.SetIsGroup(const Value: Integer);
begin
  FIsGroup := Value;
end;

procedure TmstMPLayer.SetName(const Value: String);
begin
  FName := Value;
end;

initialization
  mstRegistry := TmstRegistry.Create;
  // TODO : Что это???
//  mstRegistry.RegisterObjectClass(TmstLot, TmstLotList, 'Отводы');
//  mstRegistry.RegisterObjectClass(TmstAnnuledLot, TmstLotList, 'Отводы аннулированные');
//  mstRegistry.RegisterObjectClass(TmstActualLot, TmstLotList, 'Отводы архивные');
  mstRegistry.RegisterObjectClass(TmstMap, TmstMapList, ID_MAP, 'Планшеты');
  mstRegistry.RegisterObjectClass(TmstStreet, TmstStreetList, ID_STREET, 'Улицы');
  mstRegistry.RegisterObjectClass(TmstAddress, TmstAddressList, ID_ADDRESS, 'Адреса');
  mstRegistry.RegisterObjectClass(TmstProject, TmstObjectList, ID_PROJECT, 'Проекты');
  mstRegistry.RegisterObjectClass(TmstProject, TmstObjectList, ID_PROJECT_MP, 'Сводный план');

finalization
  FreeAndNil(mstRegistry);

end.
