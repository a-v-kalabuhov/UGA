unit uMStKernelStack;

interface

uses
  SysUtils, Classes, Controls, Contnrs, ComCtrls, Menus,
  uGC,
  uMStKernelClasses, uMStKernelTypes, uMStKernelAppModule, uMStKernelStackConsts, uMStKernelConsts, uMStKernelIBX,
  uMStClassesLots, uMStClassesProjects, uMStKernelStackUtils, uMStClassesProjectsMP;

type
(*
  Классы предназначен для работы с объектами, выбранными пользователем.
  Сюда попадают объекты, найденные при поиске и пр.
  Классы позволяет связать эти объекты с визуальным контролом для отображения
  состояния и доступа к доступным пользователю действиям над объектами.
*)
  TmstObjectStack = class;

  TmstStackViewModel = class
  public
    procedure Clear; virtual; abstract;
    procedure Prepare(AStack: TmstObjectStack); virtual; abstract;
    procedure UpdateLotInView(AView: TControl; ALot: TmstLot; const LotInfo: TmstSelectedLotInfo); virtual; abstract;
    procedure UpdateLotState(AView: TControl; ALot: TmstLot); virtual; abstract;
    procedure UpdateView(AView: TControl); virtual; abstract;
  end;

  TmstSelectionEvent = procedure (const OldSelection, NewSelection: TmstSelectedLotInfo) of object;

  TmstTreeNode = class(TTreeNode)
  private
    FNodeType: Integer;
    FDatabaseId: Integer;
    FLotCategoryId: Integer;
    procedure SetLotCategoryId(const Value: Integer);
  public
    property NodeType: Integer read FNodeType write FNodeType;
    property LotCategoryId: Integer read FLotCategoryId write SetLotCategoryId;
    property DatabaseId: Integer read FDatabaseId write FDatabaseId;
  end;

  TmstObjectStack = class
  private
    FAllLots: TObjectList;
    FStreets: TmstObjectList;
    FAddresse_s: TmstObjectList;
    FProjects: TmstObjectList;
    FMPPrjs: TmstObjectList;
    FMpObjects: TmstObjectList;
    FView: TControl;
    FUpdating: Boolean;
    FDetailedView: TControl;
    FObjectView: TControl;
    FSelectedLot: TmstSelectedLotInfo;
    FOnSelectionChange: TmstSelectionEvent;
    FAppModule: ImstAppModule;
    FDb: IDb;
    FLotCategories: ImstLotCategories;
    FLotController: ImstLotController;
    FCommands: TObjectList;
    procedure ClearView;
    function CreateViewModel: TmstStackViewModel;
    procedure ClearObjectView;
    procedure ClearDetailedView;
    procedure UpdateViewWithModel(AModel: TmstStackViewModel);
    procedure UpdateObjectView(aObject: TmstObject);
    procedure UpdateDetailedView;
    // Подготовка меню с действиями
    function ObjectExists(AObject: TmstObject): Boolean;
    function GetObjectByType(ObjectType, DbId: Integer): TmstObject;
    function GetLotByDbId(DbId: Integer): TmstLot;
    function GetLotListByDbId(DbId: Integer): TmstLotList;
    function GetListByLotCategoryId(aCategoryId: Integer): TmstLotList;
    procedure AddDefaultMenuItmes(AMenu: TPopupMenu);
    procedure PrepareRootMenu(const ObjectTypeId: Integer; AMenu: TPopupMenu);
    procedure PrepareContourMenu(AContour: TmstLotContour; AMenu: TPopupMenu);
    procedure PrepareObjectMenu(AObject: TmstObject; AMenu: TPopupMenu);

    procedure RemoveAllObjectsHandler(Sender: TObject);
    procedure HideAllLotsHandler(Sender: TObject);
    procedure ShowAllLotsHandler(Sender: TObject);
    procedure HideExceptCurrentHandler(Sender: TObject);
    procedure RemoveObjectHandler(Sender: TObject);
    procedure ViewBrowserHandler(Sender: TObject);
    procedure ViewPropertiesHandler(Sender: TObject);
    procedure ChangeVisibilityHandler(Sender: TObject);
    procedure LocateHandler(Sender: TObject);
    procedure OnOffAllContourHandler(Sender: TObject);
    procedure OnOffContourHandler(Sender: TObject);
    procedure DoSelectionChange(const OldSelectedInfo, NewSelectedInfo: TmstSelectedLotInfo);
    function GetLotLists(Index: Integer): TmstLotList;
    //
    procedure DoShowBrowser(aNodeType: Integer; aObj: TmstObject);
  public
    constructor Create(AppModule: ImstAppModule; aDb: IDb; aLotCategories: ImstLotCategories; aLotController: ImstLotController);
    destructor Destroy; override;
    //
    procedure Clear;
    procedure BeginUpdate;
    procedure EndUpdate;
    // Обновление контрола
    procedure UpdateView;
    procedure ClearSelection;
    procedure PopupOnObject(const NodeTypeId, DatabaseId, ParentTypeId, ParentDatabaseId: Integer; AMenu: TPopupMenu);
    procedure SelectObject(const ObjectTypeId, DatabaseId, ParentTypeId, ParentDatabaseId: Integer);

    procedure RegisterCommand(aCmdId: string; aSupportedNodeTypes: array of Integer; aCmdCaption: string;
      aImageIndex: Integer;
      ExecuteHandler: TmstObjectEvent; UpdateHandler: TmstObjectPredicate);

    // Добавить в стек
    procedure AddObject(AObject: TmstObject);
    // Выкинуть из стека
    procedure RemoveObject(ObjectId, DatabaseId: Integer);
    procedure RemoveSelected();
    //
    function LotListCount: Integer;
    //
    function GetSelectedObjects(): TList;

    procedure RemoveAllObjects;
    procedure RemoveCurrentObject;
    procedure LocateCurrentObject;
    procedure ViewCorrentObjectProperty;
    procedure OnOffCurrentContour;
    procedure OnOffAllContours;
    // View для всего списка объектов
    property View: TControl read FView write FView;
    // View для свойств объекта
    property ObjectView: TControl read FObjectView write FObjectView;
    // View для свойств части объекта (например, для контура в участке)
    property DetailedView: TControl read FDetailedView write FDetailedView;
    property LotLists[Index: Integer]: TmstLotList read GetLotLists;
    property SelectedLot: TmstSelectedLotInfo read FSelectedLot write FSelectedLot;
    property OnSelectionChange: TmstSelectionEvent read FOnSelectionChange write FOnSelectionChange;
  end;

  TmstTreeViewModel = class(TmstStackViewModel)
  private
    FData: TTreeView;
    FLotCategories: ImstLotCategories;
    function CreateLotNode(ToNode: TTreeNode; Lot: TmstLot): TmstTreeNode;
    procedure AddContoursToNode(Node: TTreeNode; Lot: TmstLot);
    procedure AddLot(ToNode: TTreeNode; LotCategory: TmstLotCategory; Lot: TmstLot);
    procedure AddStreet(ToNode: TTreeNode; Street: TmstStreet);
    procedure AddProject(ToNode: TTreeNode; aProject: TmstProject);
    procedure AddMPObject(ToNode: TTreeNode; aObject: TmstMPObject);
    function FindStreet(ANode: TTreeNode; DatabaseId: Integer): TTreeNode;
    procedure AddAddress(ToNode: TTreeNode; Address: TmstAddress);
    procedure OnCreateNode(Sender: TCustomTreeView; var NodeClass: TTreeNodeClass);
    function CheckNode(RootNode: TTreeNode; const aLotInfo: TmstSelectedLotInfo): TTreeNode;
  public
    constructor Create(ATreeView: TTreeView; aLotCategories: ImstLotCategories);
    destructor Destroy; override;
    procedure Clear; override;
    procedure Prepare(AStack: TmstObjectStack); override;
    procedure UpdateLotInView(AView: TControl; ALot: TmstLot; const LotInfo: TmstSelectedLotInfo); override;
    procedure UpdateLotState(AView: TControl; ALot: TmstLot); override;
    procedure UpdateView(AView: TControl); override;
  end;

implementation

uses
  uMStKernelClassesPropertiesViewers;

type
  TmstObjectStackCmd = class
  private
    FId: string;
    FOwner: TmstObjectStack;
    FNodeTypes: TIntDynArray;
    FImageIndex: Integer;
    FCaption: string;
    FExecuteHandler: TmstObjectEvent;
    FUpdateHandler: TmstObjectPredicate;
    //
    FObject: TmstObject;
  public
    constructor Create(aCmdId: string; aOwner: TmstObjectStack;
      aSupportedNodeTypes: array of Integer; 
      aCmdCaption: string; aImageIndex: Integer;
      ExecuteHandler: TmstObjectEvent; UpdateHandler: TmstObjectPredicate);
    //
    function IsSupported(aNodeType: Integer): Boolean;
    //
    procedure ItemClick(Sender: TObject);
    procedure DoUpdate(var Value: Boolean);
  end;


{ TmstObjectStack }

procedure TmstObjectStack.AddDefaultMenuItmes(AMenu: TPopupMenu);
var
  Item: TMenuItem;
begin
  // Очистить от объектов
  Item := TMenuItem.Create(AMenu);
  Item.Caption := 'Очистить список';
  Item.OnClick := RemoveAllObjectsHandler;
  AMenu.Items.Add(Item);
end;

procedure TmstObjectStack.AddObject(AObject: TmstObject);
var
  NeedUpdate: Boolean;
  aList: TmstLotList;
begin
  if not ObjectExists(AObject) then
  begin
    NeedUpdate := True;
    case AObject.ObjectId of
    ID_LOT, ID_ACTUAL_LOT1, ID_ANNULED_LOT1, ID_LOT_CATEGORIZED :
      begin
        aList := GetListByLotCategoryId(TmstLot(AObject).GetCategoryId);
        if not Assigned(aList) then
        begin
          aList := TmstLotList.Create;
          aList.CategoryId := TmstLot(AObject).GetCategoryId;
          FAllLots.Add(aList);
        end;
        aList.Add(AObject);
      end;
    ID_STREET :
      FStreets.Add(AObject);
    ID_ADDRESS :
      FAddresse_s.Add(AObject);
    ID_PROJECT :
      FProjects.Add(AObject);
    ID_PROJECT_MP :
      FMPPrjs.Add(AObject);
    ID_MP_OBJECT :
      FMpObjects.Add(AObject);
    else
      NeedUpdate := False;
    end;
    if NeedUpdate then
      UpdateView;
  end;
end;

procedure TmstObjectStack.BeginUpdate;
begin
  FUpdating := True;
end;

procedure TmstObjectStack.ClearDetailedView;
begin
  if Assigned(FDetailedView) then
  if FDetailedView is TListView then
  begin
    TListView(FDetailedView).Clear;
  end;
end;

procedure TmstObjectStack.ClearObjectView;
begin

end;

procedure TmstObjectStack.ClearView;
begin
  if FView is TTreeView then
    TTreeView(FView).Items.Clear;
end;

constructor TmstObjectStack.Create;
begin
  FAllLots := TObjectList.Create(False);
  FStreets := TmstObjectList.Create(False);
  FAddresse_s := TmstObjectList.Create(False);
  FProjects := TmstObjectList.Create(False);
  FMPPrjs := TmstObjectList.Create(False);
  FMpObjects := TmstObjectList.Create(False);
  FCommands := TObjectList.Create;
  FView := nil;
  FObjectView := nil;
  FDetailedView := nil;
  FSelectedLot.CategoryId := 0;
  FSelectedLot.ContourId := -1;
  FSelectedLot.DatabaseId := -1;
  FAppModule := AppModule;
  FDB := aDb;
  FLotCategories := aLotCategories;
  FLotController := aLotController;
end;

function TmstObjectStack.CreateViewModel: TmstStackViewModel;
begin
  if FView is TTreeView then
    Result := TmstTreeViewModel.Create(TTreeView(FView), FLotCategories)
  else
    Result := nil;
end;

destructor TmstObjectStack.Destroy;
begin
  FreeAndNil(FCommands);
  FreeAndNil(FMpObjects);
  FreeAndNil(FMPPrjs);
  FreeAndNil(FProjects);
  FreeAndNil(FAddresse_s);
  FreeAndNil(FStreets);
  FreeAndNil(FAllLots);
  inherited;
end;

procedure TmstObjectStack.EndUpdate;
begin
  FUpdating := False;
end;

function TmstObjectStack.GetListByLotCategoryId(aCategoryId: Integer): TmstLotList;
var
  I: Integer;
  aList: TmstLotList;
begin
  for I := 0 to FAllLots.Count - 1 do
  begin
    aList := TmstLotList(FAllLots[I]);
    if aList.CategoryId = aCategoryId then
    begin
      Result := aList;
      Exit;
    end;
  end;
  Result := nil;
end;

function TmstObjectStack.GetLotByDbId(DbId: Integer): TmstLot;
var
  I: Integer;
  aList: TmstLotList;
begin
  for I := 0 to FAllLots.Count - 1 do
  begin
    aList := TmstLotList(FAllLots[I]);
    Result := aList.GetByDatabaseId(DbId);
    if Assigned(Result) then
      Exit;
  end;
  Result := nil;
end;

function TmstObjectStack.GetLotListByDbId(DbId: Integer): TmstLotList;
var
  I: Integer;
  aList: TmstLotList;
  Tmp: TObject;
begin
  for I := 0 to FAllLots.Count - 1 do
  begin
    aList := TmstLotList(FAllLots[I]);
    Tmp := aList.GetByDatabaseId(DbId);
    if Assigned(Tmp) then
    begin
      Result := aList;
      Exit;
    end;
  end;
  Result := nil;
end;

function TmstObjectStack.GetLotLists(Index: Integer): TmstLotList;
begin
  Result := FAllLots[Index] as TmstLotList;
end;

function TmstObjectStack.GetObjectByType(ObjectType, DbId: Integer): TmstObject;
begin
  case ObjectType of
    ID_NODETYPE_LOT,
    ID_NODETYPE_LOT_ACTUAL,
    ID_NODETYPE_LOT_ANNULED,
    ID_NODETYPE_LOT_CATEGORIZED :
      Result := GetLotByDbId(DbId);
    ID_NODETYPE_STREET :
      Result := FStreets.GetByDatabaseId(DbId);
    ID_NODETYPE_ADDRESS :
      Result := FAddresse_s.GetByDatabaseId(DbId);
    ID_NODETYPE_PRJ :
      Result := FProjects.GetByDatabaseId(DbId);
    ID_NODETYPE_MP_PRJ :
      Result := FMPPrjs.GetByDatabaseId(DbId);
    ID_NODETYPE_MP_OBJECT :
      Result := FMpObjects.GetByDatabaseId(DbId);
  else
    Result := nil;
  end;
end;

function TmstObjectStack.GetSelectedObjects: TList;
var
  Tree: TTreeView;
  Node: TmstTreeNode;
  I, C: Integer;
  Lot: TmstLot;
begin
  Result := TList.Create;
  //
  Tree := TTreeView(FView);
  if Assigned(Tree) then
  begin
    if Assigned(Tree.Selected) then
    begin
      C := Pred(Tree.Selected.Count);
      for I := 0 to C do
      begin
        Node := TmstTreeNode(Tree.Selected[I]);
        if Node.NodeType in mstLotNodeTypes then
        begin
          Lot := GetLotByDbId(Node.DatabaseId);
          Result.Add(Lot);
        end;
      end;
    end;
  end;
end;

function TmstObjectStack.ObjectExists(AObject: TmstObject): Boolean;
var
  List: TmstObjectList;
begin
  List := nil;
  case AObject.ObjectId of
  ID_LOT,
  ID_ACTUAL_LOT1,
  ID_ANNULED_LOT1,
  ID_LOT_CATEGORIZED :
    begin
      Result := GetObjectByType(AObject.ObjectId, AObject.DatabaseId) <> nil;
      Exit;
    end;
  ID_STREET :
    List := FStreets;
  ID_ADDRESS :
    List := FAddresse_s;
  ID_PROJECT :
    List := FProjects;
  ID_PROJECT_MP :
    List := FMPPrjs;
  ID_MP_OBJECT :
    List := FMpObjects;
  end;
  Result := Assigned(List) and (List.IndexOfDatabaseId(AObject.DatabaseId) >= 0);
end;

procedure TmstObjectStack.PrepareRootMenu(const ObjectTypeId: Integer; AMenu: TPopupMenu);
var
  Item: TMenuItem;
begin
  if ObjectTypeId in mstRootNodeTypesLots then
  begin
    // Сделать все объекты невидимыми (для отводов)
    Item := TMenuItem.Create(AMenu);
    Item.Caption := 'Скрыть все участки по списку';
    Item.OnClick := HideAllLotsHandler;
    AMenu.Items.Add(Item);
    // Показать все
    Item := TMenuItem.Create(AMenu);
    Item.Caption := 'Показать все участки по списку';
    Item.OnClick := ShowAllLotsHandler;
    AMenu.Items.Add(Item);
  end;
end;

procedure TmstObjectStack.PrepareContourMenu(AContour: TmstLotContour; AMenu: TPopupMenu);
var
  menuItem: TMenuItem;
begin
  PrepareObjectMenu(AContour.Owner, AMenu);
  //
  menuItem := TMenuItem.Create(AMenu);
  menuItem.Caption := '-';
  AMenu.Items.Add(menuItem);
  //
  menuItem := TMenuItem.Create(AMenu);
  menuItem.Caption := 'Включить/выключить контур';
  menuItem.OnClick := OnOffContourHandler;
  AMenu.Items.Add(menuItem);
  //
  menuItem := TMenuItem.Create(AMenu);
  menuItem.Caption := 'Выключить все контуры кроме выбранного';
  menuItem.OnClick := OnOffAllContourHandler;
  AMenu.Items.Add(menuItem);
  //
  menuItem := TMenuItem.Create(AMenu);
  menuItem.Caption := 'Найти контур на карте';
  menuItem.OnClick := LocateHandler;
  AMenu.Items.Add(menuItem);
end;

procedure TmstObjectStack.PrepareObjectMenu(AObject: TmstObject; AMenu: TPopupMenu);
var
  menuItem: TMenuItem;
  IsLot: Boolean;
  IsPrj: Boolean;
  IsMPObj: Boolean;
begin
  AMenu.Items.Clear;
  // Убрать из выбранных
  menuItem := TMenuItem.Create(AMenu);
  menuItem.Caption := 'Убрать объект из списка';
  menuItem.OnClick := RemoveObjectHandler;
  AMenu.Items.Add(menuItem);
  IsLot := aObject is TmstLot;
  IsPrj := aObject is TmstProject;
  IsMPObj := aObject is TmstMPObject;
  if IsLot or IsPrj or IsMPObj then
  begin
    // Посмотреть информацию
    menuItem := TMenuItem.Create(AMenu);
    menuItem.Caption := 'Посмотреть свойства объекта';
    menuItem.OnClick := ViewPropertiesHandler;
    AMenu.Items.Add(menuItem);
  end;
  if IsLot then
  begin
    // Спрятать/показать (для отводов)
    menuItem := TMenuItem.Create(AMenu);
    menuItem.Caption := 'Спрятать/показать объект';
    menuItem.OnClick := ChangeVisibilityHandler;
    AMenu.Items.Add(menuItem);
    // Спрятать все кроме этого (для отводов)
    menuItem := TMenuItem.Create(AMenu);
    menuItem.Caption := 'Спрятать все кроме выбранного';
    menuItem.OnClick := HideExceptCurrentHandler;
    AMenu.Items.Add(menuItem);
  end;
  if IsMPObj then
  begin
    // Посмотреть информацию
    menuItem := TMenuItem.Create(AMenu);
    menuItem.Caption := 'Показать в списке';
    menuItem.OnClick := ViewBrowserHandler;
    AMenu.Items.Add(menuItem);
  end;
  // Показать
  menuItem := TMenuItem.Create(AMenu);
  menuItem.Caption := 'Найти объект на карте';
  menuItem.OnClick := LocateHandler;
  AMenu.Items.Add(menuItem);
end;

procedure TmstObjectStack.PopupOnObject(const NodeTypeId, DatabaseId,
  ParentTypeId, ParentDatabaseId: Integer; AMenu: TPopupMenu);
var
  Tmp: TmstObject;
  Itm: TMenuItem;
  I: Integer;
  Cmd: TmstObjectStackCmd;
  B: Boolean;
begin
  AMenu.Items.Clear;
  AddDefaultMenuItmes(AMenu);
  //
//  if NodeTypeId = ID_NODETYPE_LOT_CONTOUR then
//  begin
//    Tmp := GetObjectByType(ParentTypeId, ParentDatabaseId);
//    if Assigned(Tmp) then
//    begin
//      Tmp := TmstLot(Tmp).Contours.GetByDatabaseId(DatabaseId);
//      PrepareContourMenu(TmstLotContour(Tmp), AMenu);
//    end;
//  end
//  else
//  begin
//    Tmp := GetObjectByType(NodeTypeId, DatabaseId);
//    if Assigned(Tmp) then
//      PrepareObjectMenu(Tmp, AMenu);
//  end;
  //
  Itm := TMenuItem.Create(AMenu);
  Itm.Caption := '-';
  AMenu.Items.Add(Itm);
  for I := 0 to FCommands.Count - 1 do
  begin
    Tmp := GetObjectByType(NodeTypeId, DatabaseId);
    Cmd := TmstObjectStackCmd(FCommands[I]);
    if Cmd.IsSupported(NodeTypeId) then
    begin
      Cmd.FObject := Tmp;
      Itm := TMenuItem.Create(AMenu);
      Itm.Caption := Cmd.FCaption;
      Itm.ImageIndex := Cmd.FImageIndex;
      Itm.OnClick := Cmd.ItemClick;
      B := True;
      Cmd.DoUpdate(B);
      Itm.Enabled := B;
      AMenu.Items.Add(Itm);
    end;
  end;
end;

procedure TmstObjectStack.RemoveObject(ObjectId, DatabaseId: Integer);
var
  List: TmstObjectList;
  I: Integer;
  aList: TmstLotList;
  Tmp: TObject;
begin
  List := nil;
  case ObjectId of
  ID_LOT,
  ID_ACTUAL_LOT1,
  ID_ANNULED_LOT1,
  ID_LOT_CATEGORIZED :
    begin
      for I := 0 to FAllLots.Count - 1 do
      begin
        aList := TmstLotList(FAllLots[I]);
        Tmp := aList.GetByDatabaseId(DatabaseId);
        if Assigned(Tmp) then
        begin
          aList.Remove(Tmp);
          Exit;
        end;
      end;
    end;
  ID_STREET :
    List := FStreets;
  ID_ADDRESS :
    List := FAddresse_s;
  ID_PROJECT :
    List := FProjects;
  ID_PROJECT_MP :
    List := FMPPrjs;
  ID_MP_OBJECT :
    List := FMpObjects;
  end;
  if Assigned(List) then
  begin
    I := List.IndexOfDatabaseId(DatabaseId);
    if I >= 0 then
    begin
      List.Delete(I);
      UpdateView;
    end;
  end;
end;

procedure TmstObjectStack.RemoveObjectHandler(Sender: TObject);
begin

end;

procedure TmstObjectStack.SelectObject(const ObjectTypeId,
  DatabaseId, ParentTypeId, ParentDatabaseId: Integer);
var
  Tmp: TmstObject;
  OldSelected: TmstSelectedLotInfo;
begin
  if ObjectTypeId in mstRootNodeTypes then
  begin
    ClearObjectView;
    ClearDetailedView;
    OldSelected := FSelectedLot;
    FSelectedLot.Id := -1;
    FSelectedLot.CategoryId := 0;
    FSelectedLot.ContourId := -1;
    FSelectedLot.DatabaseId := -1;
    DoSelectionChange(OldSelected, FSelectedLot);
  end
  else
    if ObjectTypeId in mstLotNodeTypes then
    begin
      ClearDetailedView;
      Tmp := GetObjectByType(ObjectTypeId, DatabaseId);
      OldSelected := FSelectedLot;
      FSelectedLot.Id := TmstLot(Tmp).EntityID;
      FSelectedLot.CategoryId := TmstLot(Tmp).GetCategoryId;
      FSelectedLot.DatabaseId := Tmp.DatabaseId;
      FSelectedLot.ContourId := -1;
      DoSelectionChange(OldSelected, FSelectedLot);
      UpdateObjectView(Tmp);
    end
    else
      case ObjectTypeId of
      ID_NODETYPE_STREET,
      ID_NODETYPE_ADDRESS :
        begin
          ClearObjectView;
          ClearDetailedView;
        end;
      ID_NODETYPE_LOT_CONTOUR :
        begin
          Tmp := GetObjectByType(ParentTypeId, ParentDatabaseId);
          if Assigned(Tmp) then
          begin
            OldSelected := FSelectedLot;
            FSelectedLot.Id := TmstLot(Tmp).EntityID;
            FSelectedLot.CategoryId := TmstLot(Tmp).ObjectId;
            FSelectedLot.DatabaseId := ParentDatabaseId;
            Tmp := TmstLot(Tmp).Contours.GetByDatabaseId(DatabaseId);
            FSelectedLot.ContourId := Tmp.DatabaseId;
            DoSelectionChange(OldSelected, FSelectedLot);
          end;
          UpdateObjectView(Tmp);
        end;
      ID_NODETYPE_PRJ :
        begin
          ClearObjectView;
          ClearDetailedView;
          OldSelected := FSelectedLot;
          FSelectedLot.Id := -1;
          FSelectedLot.CategoryId := 0;
          FSelectedLot.ContourId := -1;
          FSelectedLot.DatabaseId := -1;
          DoSelectionChange(OldSelected, FSelectedLot);
          //
          Tmp := GetObjectByType(ObjectTypeId, DatabaseId);
          UpdateObjectView(Tmp);
        end;
      ID_NODETYPE_MP_PRJ :
        begin
          ClearObjectView;
          ClearDetailedView;
          OldSelected := FSelectedLot;
          FSelectedLot.Id := -1;
          FSelectedLot.CategoryId := 0;
          FSelectedLot.ContourId := -1;
          FSelectedLot.DatabaseId := -1;
          DoSelectionChange(OldSelected, FSelectedLot);
          //
          Tmp := GetObjectByType(ObjectTypeId, DatabaseId);
          UpdateObjectView(Tmp);
        end;
      ID_NODETYPE_MP_OBJECT :
        begin
          ClearObjectView;
          ClearDetailedView;
          OldSelected := FSelectedLot;
          FSelectedLot.Id := -1;
          FSelectedLot.CategoryId := 0;
          FSelectedLot.ContourId := -1;
          FSelectedLot.DatabaseId := -1;
          DoSelectionChange(OldSelected, FSelectedLot);
          //
          Tmp := GetObjectByType(ObjectTypeId, DatabaseId);
          UpdateObjectView(Tmp);
        end;
      else
        raise Exception.Create('Тип отвода неопределен! [' + IntToStr(ObjectTypeId) + ']');
      end;
end;

procedure TmstObjectStack.UpdateDetailedView;
begin
  if Assigned(FDetailedView) then
  if FDetailedView is TListView then
  begin
    if FSelectedLot.ContourId >= 0 then
    if FSelectedLot.DatabaseId > 0 then
    begin

    end
    else
      ClearDetailedView;  //
  end;
end;

procedure TmstObjectStack.UpdateObjectView(aObject: TmstObject);
var
  ListView: TListView;
begin
  if Assigned(FObjectView) then
  if FObjectView is TListView then
  begin
    ListView := TListView(FObjectView);
    if Assigned(aObject) then
    begin
      if aObject is TmstLot then
      begin
        ContoursToListView(ListView, TmstLot(aObject).Contours);
      end
      else
      if aObject is TmstLotContour then
      begin
        PointsToListView(ListView, TmstLotContour(aObject).Points);
      end
      else
      if aObject is TmstProject then
      begin
        ProjectToListView(ListView, TmstProject(aObject));
      end
      else
      if aObject is TmstMPObject then
      begin
        MPObjectToListView(ListView, TmstMPObject(aObject));
      end;
    end
    else
      ClearObjectView;
  end;
end;

procedure TmstObjectStack.UpdateView;
var
  Model: TmstStackViewModel;
begin
  if FUpdating then
    Exit;
  if Assigned(FView) then
  begin
    Model := CreateViewModel() as TmstStackViewModel;
    Model.Forget;
    Model.Prepare(Self);
    UpdateViewWithModel(Model);
  end;
end;

procedure TmstObjectStack.UpdateViewWithModel(AModel: TmstStackViewModel);
begin
  AModel.UpdateView(FView);
end;

procedure TmstObjectStack.Clear;
begin
  FAllLots.Clear;
  FStreets.Clear;
  FAddresse_s.Clear;
  FProjects.Clear;
  FMPPrjs.Clear;
  FMpObjects.Clear;
end;

procedure TmstObjectStack.LocateHandler(Sender: TObject);
var
  TreeView: TTreeView;
  Node, Parent: TmstTreeNode;
  DbId: Integer;
begin
  // Определяем с каким объектом работаем
  TreeView := TTreeView(Self.View);
  Node := TmstTreeNode(TreeView.Selected);
  if Assigned(Node) then
  begin
    DbId := Node.DatabaseId;
    if Node.NodeType in mstLotNodeTypes then
    begin
      // Выполняем его поиск и перемещение экрана
      FAppModule.LocateLot(Node.LotCategoryId, DbId);
    end
    else
    if Node.NodeType = ID_NODETYPE_LOT_CONTOUR then
    begin
      Parent := TmstTreeNode(Node.Parent);
      if Assigned(Parent) then
        if Parent.NodeType in mstLotNodeTypes then
          FAppModule.LocateContour(Parent.LotCategoryId, Parent.DatabaseId, Node.DatabaseId);
    end
    else
    if Node.NodeType = ID_NODETYPE_ADDRESS then
      FAppModule.LocateAddress(DbId)
    else
    if Node.NodeType in [ID_NODETYPE_PRJ, ID_NODETYPE_MP_PRJ] then
      FAppModule.LocateProject(DbId);
  end;
end;

function TmstObjectStack.LotListCount: Integer;
begin
  Result := FAllLots.Count;
end;

procedure TmstObjectStack.ClearSelection;
begin
  FSelectedLot.Id := -1;
end;

procedure TmstObjectStack.DoSelectionChange(const OldSelectedInfo,
  NewSelectedInfo: TmstSelectedLotInfo);
begin
  if Assigned(FOnSelectionChange) then
    FOnSelectionChange(OldSelectedInfo, NewSelectedInfo);
end;

procedure TmstObjectStack.DoShowBrowser(aNodeType: Integer; aObj: TmstObject);
begin
  raise Exception.Create('TmstObjectStack.DoShowBrowser');
//  if Assigned(FOnShowBrowser) then
  begin
  
  end; 
end;

procedure TmstObjectStack.HideAllLotsHandler(Sender: TObject);
var
  Tree: TTreeView;
  Node: TmstTreeNode;
  I, C: Integer;
begin
  Tree := TTreeView(FView);
  if Assigned(Tree) then
  begin
    if Assigned(Tree.Selected) then
    begin
      C := Pred(Tree.Selected.Count);
      for I := 0 to C do
      begin
        Node := TmstTreeNode(Tree.Selected[I]);
        if Node.NodeType in mstLotNodeTypes then
          FAppModule.HideLot(Node.LotCategoryId, Node.DatabaseId);
      end;
      UpdateView;
      FAppModule.RepaintViewports;
    end;
  end;
end;

procedure TmstObjectStack.HideExceptCurrentHandler(Sender: TObject);
var
  Tree: TTreeView;
  Node, Node1, Node2: TmstTreeNode;
  I, C: Integer;
  aLot, TmpLot: TmstLot;
  aLotList: TmstLotList;
  TmpModel: TmstStackViewModel;
begin
  Tree := TTreeView(FView);
  if Assigned(Tree) then
  begin
    if Assigned(Tree.Selected) then
    begin
      aLot := nil;
      Node := TmstTreeNode(Tree.Selected);
      if Node.NodeType in mstLotNodeTypes then
        aLot := FLotController.GetSelectedLot;
      if aLot = nil then
        Exit;
      //
      aLotList := FLotController.GetLotList(aLot.GetCategoryId);
      if Assigned(aLotList) then
      begin
        for I := 0 to aLotList.Count - 1 do
        begin
          if aLotList[I].DatabaseId <> aLot.DatabaseId then
            FAppModule.HideLot(aLotList[I].GetCategoryId, aLotList[I].DatabaseId);
        end;
      end;
      C := Pred(Tree.Selected.Count);
      for I := 0 to C do
      begin
        Node1 := TmstTreeNode(Tree.Selected[I]);
        if Node1.DatabaseId <> aLot.DatabaseId then
          if Node1.NodeType in mstLotNodeTypes then
            FAppModule.HideLot(Node1.LotCategoryId, Node1.DatabaseId);
      end;
      //
      TmpModel := CreateViewModel();
      TmpModel.Forget();
      for I := 0 to Pred(Tree.Items.Count) do
      begin
        Node2 := TmstTreeNode(Tree.Items[I]);
        if Node2.NodeType in mstLotNodeTypes then
        if (Node2 <> Node) and (Node2.Parent = Node.Parent) then
        begin
          TmpLot := GetLotByDbId(Node2.DatabaseId);
          if Assigned(TmpLot) then
            TmpModel.UpdateLotState(FView, TmpLot);
          Node2.Collapse(False);
        end;
      end;
      //UpdateView;
      FAppModule.RepaintViewports;
    end;
  end;
end;

procedure TmstObjectStack.RemoveAllObjectsHandler(Sender: TObject);
begin
  ClearView;
  Self.Clear;
end;

procedure TmstObjectStack.ShowAllLotsHandler(Sender: TObject);
var
  Tree: TTreeView;
  Node: TmstTreeNode;
  I, C: Integer;
begin
  Tree := TTreeView(FView);
  if Assigned(Tree) then
  begin
    if Assigned(Tree.Selected) then
    begin
      C := Pred(Tree.Selected.Count);
      for I := 0 to C do
      begin
        Node := TmstTreeNode(Tree.Selected[I]);
        if Node.NodeType in mstLotNodeTypes then
          FAppModule.UnHideLot(Node.LotCategoryId, Node.DatabaseId);
      end;
      UpdateView;
      FAppModule.RepaintViewports;
    end;
  end;
end;

procedure TmstObjectStack.OnOffAllContourHandler(Sender: TObject);
var
  aLot: TmstLot;
  aContour: TmstLotContour;
  aObjTypeId, aDbId, aParentTypeId, aParentDbId: Integer;
  I: Integer;
begin
  if FSelectedLot.ContourId >= 0 then
  begin
    aLot := GetLotByDbId(FSelectedLot.DatabaseId);
    if Assigned(aLot) then
    begin
      aContour := aLot.Contours.GetByDatabaseId(FSelectedLot.ContourId);
      if Assigned(aContour) then
      begin
        for I := 0 to aLot.Contours.Count - 1 do
        begin
          aContour := aLot.Contours[I];
          if aContour.DatabaseId <> FSelectedLot.ContourId then
            aContour.Enabled := False;
        end;
        FLotController.UpdateLotEntity(Self, aLot);
        //
        aObjTypeId  := -1;
        aDbId := -1;
        aParentTypeId := -1;
        aParentDbId := -1;
        if Assigned(TTreeView(FView).Selected) then
        begin
          with TmstTreeNode(TTreeView(FView).Selected) do
          begin
            aObjTypeId := NodeType;
            aDbId := DatabaseId;
            if Assigned(TTreeView(FView).Selected.Parent) then
            with TmstTreeNode(TTreeView(FView).Selected.Parent) do
            begin
              aParentTypeId := NodeType;
              aParentDbId := DatabaseId;
            end;
          end;
        end;
        with CreateViewModel do
        try
          UpdateLotInView(FView, aLot, FSelectedLot);
        finally
          Free;
        end;
        SelectObject(aObjTypeId, aDbId, aParentTypeId, aParentDbId);
      end;
    end;
  end;
end;

procedure TmstObjectStack.OnOffAllContours;
begin
  OnOffAllContourHandler(nil);
end;

procedure TmstObjectStack.OnOffContourHandler(Sender: TObject);
var
  aLot: TmstLot;
  aContour: TmstLotContour;
  aObjTypeId, aDbId, aParentTypeId, aParentDbId: Integer;
begin
  if FSelectedLot.ContourId >= 0 then
  begin
    aLot := GetLotByDbId(FSelectedLot.DatabaseId);
    if Assigned(aLot) then
    begin
      aContour := aLot.Contours.GetByDatabaseId(FSelectedLot.ContourId);
      if Assigned(aContour) then
      begin
        aContour.Enabled := not aContour.Enabled;
        FLotController.UpdateLotEntity(Self, aLot);
        aObjTypeId  := -1;
        aDbId := -1;
        aParentTypeId := -1;
        aParentDbId := -1;
        if Assigned(TTreeView(FView).Selected) then
        begin
          with TmstTreeNode(TTreeView(FView).Selected) do
          begin
            aObjTypeId := NodeType;
            aDbId := DatabaseId;
            if Assigned(TTreeView(FView).Selected.Parent) then
            with TmstTreeNode(TTreeView(FView).Selected.Parent) do
            begin
              aParentTypeId := NodeType;
              aParentDbId := DatabaseId;
            end;
          end;
        end;
        with CreateViewModel do
        try
          UpdateLotInView(FView, aLot, FSelectedLot);
        finally
          Free;
        end;
        SelectObject(aObjTypeId, aDbId, aParentTypeId, aParentDbId);
      end;
    end;
  end;
end;

procedure TmstObjectStack.RemoveSelected;
var
  Node: TmstTreeNode;
  DbId: Integer;
  OldSelected: TmstSelectedLotInfo;
  aList: TmstLotList;
  Tmp: TObject;
begin
  with TTreeView(FView) do
  begin
    // Определяем с каким объектом работаем
    Node := TmstTreeNode(TTreeView(Self.View).Selected);
    if Assigned(Node) then
    begin
      DbId := Node.DatabaseId;
      if Node.NodeType in mstLotNodeTypes then
      begin
        aList := GetLotListByDbId(DbId);
        if Assigned(aList) then
        begin
          Tmp := aList.GetByDatabaseId(DbId);
          aList.Remove(Tmp);
        end;
      end;
    end;
    if Assigned(Selected) then
    begin
      Items.Delete(Selected);
      OldSelected := FSelectedLot;
      FSelectedLot.Id := -1;
      FSelectedLot.CategoryId := 0;
      FSelectedLot.ContourId := -1;
      FSelectedLot.DatabaseId := -1;
      DoSelectionChange(OldSelected, FSelectedLot);
    end;
  end;
end;

procedure TmstObjectStack.ChangeVisibilityHandler(Sender: TObject);
var
  Tree: TTreeView;
  Node: TmstTreeNode;
  aLot: TmstLot;
begin
  Tree := TTreeView(FView);
  if Assigned(Tree) then
  begin
    if Assigned(Tree.Selected) then
    begin
      Node := TmstTreeNode(Tree.Selected);
      if Node.NodeType in mstLotNodeTypes then
      begin
        aLot := FLotController.GetSelectedLot;
        if Assigned(aLot) then
          if aLot.Visible then
            FAppModule.HideLot(Node.LotCategoryId, Node.DatabaseId)
          else
            FAppModule.UnHideLot(Node.LotCategoryId, Node.DatabaseId);
      end;
    end;
    UpdateView;
    FAppModule.RepaintViewports;
  end;
end;

procedure TmstObjectStack.ViewPropertiesHandler(Sender: TObject);
var
  TreeView: TTreeView;
  Node: TmstTreeNode;
  aLot: TmstLot;
  Prj: TmstProject;
begin
  TreeView := TTreeView(FView);
  Node := TmstTreeNode(TreeView.Selected);
  if Node = nil then
    Exit;
  if Node.NodeType in mstLotNodeTypes then
  begin
    aLot := TmstLot(GetObjectByType(Node.NodeType, Node.DatabaseId));
    if Assigned(aLot) then
    begin
      with TmstLotPropertiesView.Create do
      try
        ShowView(aLot);
      finally
        Free;
      end;
    end;
  end
  else
  if Node.NodeType in [ID_NODETYPE_PRJ, ID_NODETYPE_MP_PRJ] then
  begin
    Prj := TmstProject(GetObjectByType(Node.NodeType, Node.DatabaseId));
    if Assigned(Prj) then
    begin
      if Prj.Edit(True) then
        Prj.Save(FDb);
    end;
  end;
end;

procedure TmstObjectStack.LocateCurrentObject;
begin
  LocateHandler(nil);
end;

procedure TmstObjectStack.RegisterCommand;
var
  Cmd: TmstObjectStackCmd;
begin
  Cmd := TmstObjectStackCmd.Create(aCmdId, Self, aSupportedNodeTypes, aCmdCaption, aImageIndex,
    ExecuteHandler, UpdateHandler);
  FCommands.Add(Cmd);
end;

procedure TmstObjectStack.RemoveAllObjects;
begin
  RemoveAllObjectsHandler(nil);
end;

procedure TmstObjectStack.RemoveCurrentObject;
begin
  RemoveObjectHandler(nil);
end;

procedure TmstObjectStack.ViewBrowserHandler(Sender: TObject);
var
  TreeView: TTreeView;
  Node: TmstTreeNode;
  aLot: TmstLot;
  Prj: TmstProject;
begin
  TreeView := TTreeView(FView);
  Node := TmstTreeNode(TreeView.Selected);
  if Node = nil then
    Exit;
  if Node.NodeType in [ID_NODETYPE_MP_OBJECT] then
  begin
    DoShowBrowser(Node.NodeType, GetObjectByType(Node.NodeType, Node.DatabaseId));
  end;
end;

procedure TmstObjectStack.ViewCorrentObjectProperty;
begin
  ViewPropertiesHandler(nil);
end;

procedure TmstObjectStack.OnOffCurrentContour;
begin
  OnOffContourHandler(nil);
end;

{ TmstTreeViewModel }

procedure TmstTreeViewModel.AddAddress(ToNode: TTreeNode; Address: TmstAddress);
begin
  with TmstTreeNode(FData.Items.AddChild(ToNode, Address.AsText)) do
  begin
    DatabaseId := Address.DatabaseId;
    NodeType := ID_NODETYPE_ADDRESS;
    ImageIndex := IMAGE_ADDRESS;
    SelectedIndex := ImageIndex;
  end;
end;

procedure TmstTreeViewModel.AddLot(ToNode: TTreeNode; LotCategory: TmstLotCategory; Lot: TmstLot);
begin
  with CreateLotNode(ToNode, Lot) do
  begin
    NodeType := LotCategory.GetNodeType();// ID_NODETYPE_LOT;
    if not Lot.Visible then
      ImageIndex := IMAGE_INVISIBLELOT
    else
      ImageIndex := LotCategory.GetNodeImageIndex();// IMAGE_LOT;
    SelectedIndex := ImageIndex;
  end;
end;

procedure TmstTreeViewModel.AddMPObject(ToNode: TTreeNode; aObject: TmstMPObject);
begin
  with TmstTreeNode(FData.Items.AddChild(ToNode, aObject.AsText)) do
  begin
    DatabaseId := aObject.DatabaseId;
    NodeType := ID_NODETYPE_MP_OBJECT;
    ImageIndex := IMAGE_PROJECT;
    SelectedIndex := ImageIndex;
  end;
end;

procedure TmstTreeViewModel.AddProject(ToNode: TTreeNode; aProject: TmstProject);
begin
  with TmstTreeNode(FData.Items.AddChild(ToNode, aProject.AsText)) do
  begin
    DatabaseId := aProject.DatabaseId;
    if aProject.IsMP() then
      NodeType := ID_NODETYPE_MP_PRJ
    else
      NodeType := ID_NODETYPE_PRJ;
    ImageIndex := IMAGE_PROJECT;
    SelectedIndex := ImageIndex;
  end;
end;

procedure TmstTreeViewModel.AddStreet(ToNode: TTreeNode; Street: TmstStreet);
begin
  with TmstTreeNode(FData.Items.AddChild(ToNode, Street.AsText)) do
  begin
    DatabaseId := Street.DatabaseId;
    NodeType := ID_NODETYPE_STREET;
    ImageIndex := IMAGE_STREET;
    SelectedIndex := ImageIndex;
  end;
end;

procedure TmstTreeViewModel.Clear;
begin
  FData.Items.Clear;
end;

constructor TmstTreeViewModel.Create;
begin
  FData := ATreeView;
  FData.OnCreateNodeClass := Self.OnCreateNode;
  FLotCategories := aLotCategories;
end;

destructor TmstTreeViewModel.Destroy;
begin
  FData.OnCreateNodeClass := nil;
  FData := nil;
  inherited;
end;

procedure TmstTreeViewModel.Prepare(AStack: TmstObjectStack);
var
  I, J: Integer;
  LotsNode, Streets, AStreet, PrjRoot: TTreeNode;
  aLotList: TmstLotList;
  NodeCap: string;
  LotCat: TmstLotCategory;
begin
  FData.Items.BeginUpdate;
  try
    FData.Items.Clear;
    for I := 0 to AStack.LotListCount - 1 do
    begin
      aLotList := AStack.LotLists[I];
      if aLotList.Count > 0 then
      begin
        LotCat := FLotCategories.CategoryById(aLotList.CategoryId);
        NodeCap := LotCat.GetLayerCaption();
        LotsNode := FData.Items.AddChild(nil, NodeCap);
        TmstTreeNode(LotsNode).NodeType := LotCat.GetRootNodeType();
        LotsNode.ImageIndex := LotCat.GetRootNodeImageIndex();
        LotsNode.SelectedIndex := LotCat.GetRootNodeImageIndex();
        for J := 0 to Pred(aLotList.Count) do
          AddLot(LotsNode, LotCat, TmstLot(aLotList[J]));
      end;
    end;
    if AStack.FStreets.Count > 0 then
    begin
      Streets := FData.Items.AddChildObject(nil, mstRegistry.GetNameById(ID_STREET), Pointer(ID_STREET));
      TmstTreeNode(Streets).NodeType := ID_NODETYPE_STREET_ROOT;
      for I := 0 to Pred(AStack.FStreets.Count) do
        AddStreet(Streets, TmstStreet(AStack.FStreets[I]));
      if AStack.FAddresse_s.Count > 0 then
        for I := 0 to Pred(AStack.FAddresse_s.Count) do
        begin
          AStreet := FindStreet(Streets, TmstAddress(AStack.FAddresse_s[I]).StreetDatabaseId);
          if Assigned(AStreet) then
            AddAddress(AStreet, TmstAddress(AStack.FAddresse_s[I]));
        end;
    end;
    if AStack.FProjects.Count > 0 then
    begin
      PrjRoot := FData.Items.AddChildObject(nil, mstRegistry.GetNameById(ID_PROJECT), Pointer(ID_PROJECT));
      TmstTreeNode(PrjRoot).NodeType := ID_NODETYPE_PRJ_ROOT;
      for I := 0 to Pred(AStack.FProjects.Count) do
        AddProject(PrjRoot, TmstProject(AStack.FProjects[I]));
    end;
    if AStack.FMPPrjs.Count > 0 then
    begin
      PrjRoot := FData.Items.AddChildObject(nil, mstRegistry.GetNameById(ID_PROJECT_MP), Pointer(ID_PROJECT_MP));
      TmstTreeNode(PrjRoot).NodeType := ID_NODETYPE_MP_ROOT;
      for I := 0 to Pred(AStack.FMPPrjs.Count) do
        AddProject(PrjRoot, TmstProject(AStack.FMPPrjs[I]));
    end;
    if AStack.FMpObjects.Count > 0 then
    begin
      PrjRoot := FData.Items.AddChildObject(nil, mstRegistry.GetNameById(ID_MP_OBJECT), Pointer(ID_MP_OBJECT));
      TmstTreeNode(PrjRoot).NodeType := ID_NODETYPE_MP_ROOT;
      for I := 0 to Pred(AStack.FMpObjects.Count) do
        AddMPObject(PrjRoot, TmstMPObject(AStack.FMpObjects[I]));
    end;
  finally
    FData.Items.EndUpdate;
  end;
end;

function TmstTreeViewModel.CreateLotNode(ToNode: TTreeNode; Lot: TmstLot): TmstTreeNode;
var
  I: Integer;
begin
  Result := TmstTreeNode(FData.Items.AddChild(ToNode, Lot.AsText));
  Result.DatabaseId := Lot.DatabaseId;
  Result.LotCategoryId := Lot.GetCategoryId();
  for I := 0 to Pred(Lot.Contours.Count) do
    with Lot.Contours[I] do
      with TmstTreeNode(FData.Items.AddChild(Result, AsText)) do
      begin
        DatabaseId := Lot.Contours[I].DatabaseId;
        NodeType := ID_NODETYPE_LOT_CONTOUR;
        if Enabled then
          ImageIndex := IMAGE_VISIBLECONTOUR
        else
          ImageIndex := IMAGE_INVISIBLECOUNTOUR;
        SelectedIndex := ImageIndex;
      end;
end;

function TmstTreeViewModel.FindStreet(ANode: TTreeNode; DatabaseId: Integer): TTreeNode;
var
  I: Integer;
begin
  Result := nil;
  for I := 0 to Pred(ANode.Count) do
    if TmstTreeNode(ANode.Item[I]).DatabaseId = DatabaseId then
    begin
      Result := ANode.Item[I];
      Break;
    end;
end;

procedure TmstTreeViewModel.UpdateView(AView: TControl);
begin
  inherited;
  FData.Update;
  FData.FullExpand;
  FData.ShowRoot := True;
end;

procedure TmstTreeViewModel.OnCreateNode(Sender: TCustomTreeView; var NodeClass: TTreeNodeClass);
begin
  NodeClass := TmstTreeNode;
end;

procedure TmstTreeViewModel.UpdateLotInView(AView: TControl; ALot: TmstLot; const LotInfo: TmstSelectedLotInfo);
var
  TreeView: TTreeView;
  I, J: Integer;
  Node: TTreeNode;
begin
  inherited;
  TreeView := TTreeView(AView);
  for I := 0 to Pred(TreeView.Items.Count) do
  begin
    Node := CheckNode(TreeView.Items[I], LotInfo);
    if Assigned(Node) then
    begin
      Node.DeleteChildren;
      AddContoursToNode(Node, ALot);
      if LotInfo.ContourId > 0 then
      begin
        for J := 0 to Pred(Node.Count) do
          if TmstTreeNode(Node.Item[J]).DatabaseId = LotInfo.ContourId then
            TreeView.Selected := Node.Item[J];
      end
      else
        TreeView.Selected := Node;
      Exit;
    end;
  end;
end;

procedure TmstTreeViewModel.UpdateLotState;
var
  TreeView: TTreeView;
  I: Integer;
  Node: TTreeNode;
  LotCat: TmstLotCategory;
begin
  inherited;
  LotCat := FLotCategories.CategoryById(aLot.GetCategoryId);
  TreeView := TTreeView(AView);
  for I := 0 to Pred(TreeView.Items.Count) do
  begin
    Node := TreeView.Items[I];
    if TmstTreeNode(Node).NodeType in mstLotNodeTypes then
    if TmstTreeNode(Node).DatabaseId = aLot.DatabaseId then
    begin
      if not aLot.Visible then
        Node.ImageIndex := IMAGE_INVISIBLELOT
      else
        Node.ImageIndex := LotCat.GetNodeImageIndex();// IMAGE_LOT;
      Node.SelectedIndex := Node.ImageIndex;
    end;
  end;
end;

function TmstTreeViewModel.CheckNode(RootNode: TTreeNode; const aLotInfo: TmstSelectedLotInfo): TTreeNode;
var
  I: Integer;
begin
  Result := nil;
  for I := 0 to Pred(RootNode.Count) do
  begin
    if TmstTreeNode(RootNode[I]).DatabaseId = aLotInfo.DatabaseId then
      Result := RootNode[I]
    else
      Result := CheckNode(RootNode[I], aLotInfo);
    if Assigned(Result) then
      Exit;
  end;
end;

procedure TmstTreeViewModel.AddContoursToNode(Node: TTreeNode;
  Lot: TmstLot);
var
  I: Integer;
begin
  for I := 0 to Pred(Lot.Contours.Count) do
  with Lot.Contours[I] do
    with TmstTreeNode(FData.Items.AddChild(Node, AsText)) do
    begin
      DatabaseId := Lot.Contours[I].DatabaseId;
      NodeType := ID_NODETYPE_LOT_CONTOUR;
      if Enabled then
        ImageIndex := IMAGE_VISIBLECONTOUR
      else
        ImageIndex := IMAGE_INVISIBLECOUNTOUR;
      SelectedIndex := ImageIndex;
    end;
end;

{ TmstTreeNode }

procedure TmstTreeNode.SetLotCategoryId(const Value: Integer);
begin
  FLotCategoryId := Value;
end;

{ TmstObjectStackCmd }

constructor TmstObjectStackCmd.Create(aCmdId: string; aOwner: TmstObjectStack;
  aSupportedNodeTypes: array of Integer; 
  aCmdCaption: string; aImageIndex: Integer;
  ExecuteHandler: TmstObjectEvent; UpdateHandler: TmstObjectPredicate);
var
  I: Integer;
begin
  FId := aCmdId;
  SetLength(FNodeTypes, Length(aSupportedNodeTypes));
  for I := 0 to Length(aSupportedNodeTypes) - 1 do
    FNodeTypes[I] := aSupportedNodeTypes[I];
  FOwner := aOwner;
  FCaption := aCmdCaption;
  FImageIndex := aImageIndex;
  FExecuteHandler := ExecuteHandler;
  FUpdateHandler := UpdateHandler;
end;

procedure TmstObjectStackCmd.DoUpdate(var Value: Boolean);
begin
  Value := Assigned(FExecuteHandler);
  if Value then
    if Assigned(FUpdateHandler) then
    begin
      FUpdateHandler(FOwner, FObject, Value);
    end;
end;

function TmstObjectStackCmd.IsSupported(aNodeType: Integer): Boolean;
var
  I: Integer;
begin
  for I := 0 to Length(FNodeTypes) - 1 do
  begin
    if FNodeTypes[I] = aNodeType then
    begin
      Result := True;
      Exit;
    end;
  end;
  Result := False;
end;

procedure TmstObjectStackCmd.ItemClick(Sender: TObject);
begin
  if Assigned(FExecuteHandler) then
    FExecuteHandler(FOwner, FObject);
end;

end.
