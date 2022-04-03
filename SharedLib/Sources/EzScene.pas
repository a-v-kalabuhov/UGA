unit EzScene;

interface

uses
  SysUtils, Classes,
  EzBaseGIS, EzEntities, EzLib;

type
  TEzScene = class;

  TEzBaseScene = class
  public
    procedure Clear(WithEntities: Boolean = False); virtual; abstract;
    function Extent: TEzRect; virtual; abstract;
    function Count: Integer; virtual; abstract;
  end;


  TEzObject = class(TPersistent)
  private
    FID: Integer;
    FLayer: TEzBaseLayer;
    FObject: TEzEntity;
    FContainer: TEzScene;
    FParams: array of Variant;
    procedure Init;
    procedure SetParams(ParamArray: array of const);
  public
    property Layer: TEzBaseLayer read FLayer;
    property ID: Integer read FID;
    property Container: TEzScene read FContainer write FContainer;
    procedure Assign(Source: TEzObject); reintroduce;
    function StoredObject: TEzEntity;
    constructor Create; overload;
    constructor Create(pLayer: TEzBaseLayer; pID: Integer;
      pObj: TEzEntity; pParams: array of const); overload;
    procedure Load(pLayer: TEzBaseLayer; pID: Integer;
      pObj: TEzEntity; pParams: array of const);
    destructor Destroy; override;
  end;

  TBaseEzObjectEvent = procedure(Sender: TObject; ObjIndex: Integer; ObjName: String; var Obj: TEzObject) of object;

  TEzScene = class
  private
    FObjects: TStringList;
    FSelectedIndex: Integer;
    FVisible: Boolean;
    function ValidIndex(Index: Integer): Boolean;
  public
    procedure FindByPoint(Point: TEzPoint; var List: TStringList);
    procedure Clear(WithEntities: Boolean = False);
    function ObjectCount: Integer;
    function AddObject(obj_name: String; new_object: TEzObject): Integer;
    function LoadObject(obj_name: String; obj_ID: Integer;
      obj_layer: TEzBaseLayer; pParams: array of const): Integer;
    procedure DeleteObject(Index: Integer; WithEntity: Boolean = False);
    procedure SaveObject(Index: Integer);
    procedure RefreshObject(Index: Integer);
    procedure Refresh;
    procedure ReplaceObject(Index: Integer; ObjName: String; Obj: TEzObject);
    function IndexOf(pLayerName: String; pID: Integer): Integer; overload;
    function IndexOf(pName: String): Integer; overload;
    function GetObject(Index: Integer): TEzObject;
    function GetObjectPointer(Index: Integer): TEZObject;
    function Names(Index: Integer): String;
    procedure ExportObjects(OnExportObject: TBaseEzObjectEvent);
    function Extent: TEzRect;
    constructor Create;
    destructor Destroy; override;
    
    property SelectedIndex: Integer read FSelectedIndex write FSelectedIndex;
    property Visible: Boolean read FVisible write FVisible;
  end;

  TEzVisualScene = class(TEzScene)
    procedure ShowEditor(Index: Integer);
  end;

  function ObjectInScene(Scene: TEzScene; const LayerName: String;
    UID: Integer; var Index: Integer): Boolean;

implementation

uses
  EzBase, EzMiscelEntities,
  Variants, Math,
  EzTrueTypeTextEd, EzRichTextEd, EzUtils;

const
  sInvalidIndex = 'Неверный индекс объекта!';
  sObjectNotAssigned = 'Нет связанного объекта!';

{ TEzObject }

constructor TEzObject.Create;
begin
  inherited;
  Init;
end;

destructor TEzObject.Destroy;
begin
  SetLength(FParams, 0);
  FreeAndNil(FObject);
  FLayer := nil;
end;

procedure TEzObject.SetParams(ParamArray: array of const);
var
  i: Integer;
begin
  SetLength(FParams, Length(ParamArray));
  for i := 0 to Length(FParams) - 1 do
    case ParamArray[i].VType of
    vtInteger :    FParams[i] := ParamArray[i].VInteger;
    vtBoolean :    FParams[i] := ParamArray[i].VBoolean;
    vtExtended :   FParams[i] := ParamArray[i].VExtended^;
    vtString :     FParams[i] := String(ParamArray[i].VString);
    vtPChar :      FParams[i] := Char(ParamArray[i].VPChar);
    vtChar :       FParams[i] := ParamArray[i].VChar;
    vtWideChar :   FParams[i] := WideChar(ParamArray[i].VWideChar);
    vtPWideChar :  FParams[i] := WideChar(ParamArray[i].VPWideChar);
    vtAnsiString : FParams[i] := String(ParamArray[i].VAnsiString);
    vtCurrency :   FParams[i] := ParamArray[i].VCurrency^;
    vtVariant :    FParams[i] := ParamArray[i].VVariant^;
    vtWideString : FParams[i] := String(ParamArray[i].VWideString);
    vtInt64 :      FParams[i] := ParamArray[i].VInt64^;
    else
      FParams[i] := Unassigned;
    end;
end;

procedure TEzObject.Assign(Source: TEzObject);
var
  Ent: TEzEntity;
  i: Integer;
  NeedAssign: Boolean;
  rect: TEzRect;
  S: String;
begin
  SetLength(FParams, Length(Source.FParams));
  for i := 0 to Length(Source.FParams) - 1 do
    FParams[i] := Source.FParams[i];
  FID := Source.ID;
  FLayer := Source.Layer;
  Ent := Source.StoredObject;
  FreeAndNil(FObject);
  if Assigned(Ent) then
  begin
    NeedAssign := True;
    case Ent.EntityID of
    idTrueTypeText :  FObject := EmptyEzTrueTypeText;
    idRtfText :
      begin
        ent.MaxMinExtents(rect.xmin, rect.ymin, rect.xmax, rect.ymax);
        if Length(Source.FParams) > 0 then S := Source.FParams[0] else S := '';
        FObject := EzRichText(S, rect);
        NeedAssign := False;
      end;
    idPolyline :      FObject := EmptyEzPolyline;
    idPolygon :       FObject := EmptyEzPolygon;
    idRectangle :     FObject := EmptyEzRectangle;
    idEllipse :       FObject := EmptyEzEllipse;
    idGroup :         FObject := EmptyEzGroup;
    end;
    if NeedAssign then FObject.Assign(Ent);
    Ent.Free;
  end;
end;

procedure TEzObject.Load(pLayer: TEzBaseLayer; pID: Integer;
  pObj: TEzEntity; pParams: array of const);
var
  NeedAssign: Boolean;
  rect: TEzRect;
  S: String;
begin
  NeedAssign := True;
  SetParams(pParams);
  case pObj.EntityID of
  idTrueTypeText :  FObject := EmptyEzTrueTypeText;
  idPolyline :      FObject := EmptyEzPolyline;
  idPolygon :       FObject := EmptyEzPolygon;
  idRtfText :
    begin
      pObj.MaxMinExtents(rect.xmin, rect.ymin, rect.xmax, rect.ymax);
      if Length(FParams) > 0 then
      begin
        NeedAssign := False;
        S := FParams[0];
      end
      else
      begin
        NeedAssign := True;
        S := '';
      end;
      FObject := EzRichText(S, rect);
    end;
  idRectangle :   FObject := EmptyEzRectangle;
  idEllipse :     FObject := EmptyEzEllipse;
  idGroup :       FObject := EmptyEzGroup;
  idPreview :     FObject := TEzPreviewEntity.CreateEntity(Point2D(0, 0), Point2D(1, 1), pmAll, 0);
  idTable :       FObject := TEzTableEntity.CreateEntity(Point2D(0, 0), Point2D(1, 1));
  end;
  if NeedAssign then FObject.Assign(pObj);
  FLayer := pLayer;
  FID := pID;
end;

function TEzObject.StoredObject: TEzEntity;
var
  NeedAssign: Boolean;
  ARect: TEzRect;
  S: String;
begin
  NeedAssign := True; 
  if FObject = nil then
    Result := nil
  else
    case FObject.EntityID of
    idTrueTypeText : Result := EmptyEzTrueTypeText;
    idPolyline :     Result := EmptyEzPolyline;
    idPolygon :      Result := EmptyEzPolygon;
    idRtfText :
      begin
        FObject.MaxMinExtents(ARect.xmin, ARect.ymin, ARect.xmax, ARect.ymax);
        if Length(FParams) > 0 then
        begin
          NeedAssign := False;
          S := FParams[0];
        end
        else
        begin
          NeedAssign := True;
          S := '';
        end;
        Result := EzRichText(S , ARect);
      end;
    idRectangle :    result := EmptyEzRectangle;
    idEllipse :      result := EmptyEzEllipse;
    idGroup :        Result := EmptyEzGroup;
    idTable :        Result := TEzTableEntity.CreateEntity(Point2D(0, 0), Point2D(1, 1));
    idPreview :      Result := TEzPreviewEntity.CreateEntity(Point2D(0, 0), Point2D(1, 1), pmAll, 0);
    else
      Result := nil;
    end;
  if NeedAssign then
    if Assigned(Result) then Result.Assign(FObject);
end;

constructor TEzObject.Create(pLayer: TEzBaseLayer; pID: Integer;
  pObj: TEzEntity; pParams: array of const);
var
  NeedAssign: Boolean;
  rect: TEzRect;
begin
  inherited Create;
  Init;
  SetParams(pParams);
  NeedAssign := True;
  case pObj.EntityID of
  idTrueTypeText :  FObject := EmptyEzTrueTypeText;
  idPolyline :      FObject := EmptyEzPolyline;
  idPolygon :       FObject := EmptyEzPolygon;
  idRtfText :
    begin
      pObj.MaxMinExtents(rect.xmin, rect.ymin, rect.xmax, rect.ymax);
      FObject := EzRichText(FParams[0], rect);
      NeedAssign := False;
    end;
  idRectangle :   FObject := EmptyEzRectangle;
  idEllipse :     FObject := EmptyEzEllipse;
  idGroup :       FObject := EmptyEzGroup;
  end;
  if NeedAssign then FObject.Assign(pObj);
  FLayer := pLayer;
  FID := pID;
end;

procedure TEzObject.Init;
begin
  FObject := nil;
  FLayer := nil;
  FID := -1;
  SetLength(FParams, 0);
end;

{ TEzScene }

function TEzScene.AddObject(obj_name: String; new_object: TEzObject): Integer;
begin
  new_object.Container := Self;
  result := FObjects.AddObject(obj_name, new_object);
end;

// Очищает сцену, если WithEntities = True, то объекты удалятся из слоя
procedure TEzScene.Clear(WithEntities: Boolean = False);
var
  i: Integer;
  temp_obj: TEzObject;
begin
  for i := FObjects.Count - 1 downto 0 do
  begin
    temp_obj := TEzObject(FObjects.Objects[i]);
    if Assigned(temp_obj) then
      try
        if WithEntities then
          temp_obj.Layer.DeleteEntity(temp_obj.ID);
      finally
        FreeAndNil(temp_obj);
        FObjects.Delete(i);
      end;
  end;
  FSelectedIndex := -1;
end;

constructor TEzScene.Create;
begin
  inherited Create;
  FObjects := TStringList.Create;
  FSelectedIndex := -1;
end;

// Удаляет объект из сцены и из слоя, если необходимо
procedure TEzScene.DeleteObject(Index: Integer; WithEntity: Boolean = False);
var
  TmpObj: TEzObject;
begin
  if ValidIndex(Index) then
  begin
    TmpObj := TEzObject(FObjects.Objects[Index]);
    if WithEntity then
    try
      TmpObj.Layer.DeleteEntity(TmpObj.ID);
    finally
    end;
    FreeAndNil(TmpObj);
    FObjects.Delete(Index);
    if Index = FSelectedIndex then FSelectedIndex := -1;
  end;
end;

destructor TEzScene.Destroy;
begin
  Clear;
  FObjects.Free;
  inherited;
end;

function TEzScene.GetObject(Index: Integer): TEzObject;
begin
  if ValidIndex(Index) then
  begin
    Result := TEzObject.Create;
    Result.Assign(TEzObject(FObjects.Objects[Index]));
  end
  else
    Result := nil;
end;

function TEzScene.IndexOf(pLayerName: String; pID: Integer): Integer;
var
  i: Integer;
  temp_obj: TEzObject;
begin
  result := -1;
  for i := 0 to FObjects.Count - 1 do
  begin
    temp_obj := TEzObject(FObjects.Objects[i]);
    if temp_obj.ID = pID then
    if temp_obj.Layer.Name = pLayerName then
    begin
      result := i;
      BREAK;
    end;
  end;
end;

function TEzScene.GetObjectPointer(Index: Integer): TEZObject;
begin
  if ValidIndex(Index) then
    Result := TEzObject(FObjects.Objects[Index])
  else
    Result := nil;
end;

function TEzScene.IndexOf(pName: String): Integer;
begin
  result := FObjects.IndexOf(pName);
end;

function TEzScene.Names(Index: Integer): String;
begin
  if ValidIndex(Index) then
    result := FObjects.Strings[Index]
  else
    raise EAbort.Create(sInvalidIndex);
end;

function TEzScene.ObjectCount: Integer;
begin
  Result := FObjects.Count;
end;

// Сохраняет объект из сцены (обычно после изменения)
// в слое, при этом происходит подмена старого объекта измененным
procedure TEzScene.SaveObject(Index: Integer);
var
  temp_obj: TEzObject;
  ent: TEzEntity;
begin
  if ValidIndex(Index) then
  begin
    temp_obj := TEzObject(FObjects.Objects[Index]);
    ent := temp_obj.StoredObject;
    if Assigned(ent) then
    begin
      temp_obj.Layer.UpdateEntity(temp_obj.ID, ent);
      ent.Free;
    end
    else
    begin
      ent.Free;
      raise EAbort.Create(sObjectNotAssigned);
    end;
  end
  else
    raise EAbort.Create(sInvalidIndex);
end;

function TEzScene.ValidIndex(Index: Integer): Boolean;
begin
//  Result := ;
  Result := (Index >= 0) and (Index < ObjectCount);
end;

// Добавляет в сцену объект obj_name из слоя obj_layer
// если такой объект уже содержится в сцене, то замещает его 
function TEzScene.LoadObject(obj_name: String; obj_ID: Integer;
  obj_layer: TEzBaseLayer; pParams: array of const): Integer;
var
  TempObj: TEzObject;
  ent: TEzEntity;
  I: Integer;
begin
  TempObj := TEzObject.Create;
  ent := obj_layer.LoadEntityWithRecNo(obj_ID);
  TempObj.Load(obj_layer, obj_ID, ent, pParams);
  ent.Free;
  TempObj.Container := Self;
  I := IndexOf(TempObj.Layer.Name, TempObj.ID);
  if I < 0 then
    Result := FObjects.AddObject(obj_name, TempObj)
  else
  begin
    FObjects.Objects[I].Free;
    FObjects.Objects[I] := TempObj;
  end;
end;

procedure TEzScene.FindByPoint(Point: TEzPoint; var List: TStringList);
var
  temp_obj: TEzObject;
  ez_obj: TEzEntity;
  i: Integer;
begin
  for i := 0 to ObjectCount - 1 do
  begin
    temp_obj := GetObject(i);
    ez_obj := temp_obj.StoredObject;
    if Assigned(ez_obj) then
    try
      if ez_obj.IsPointInsideMe(Point.x, Point.y) then
        List.AddObject(Names(i), GetObjectPointer(i));
    finally
      FreeAndNil(ez_obj);
      FreeAndNil(temp_obj);
    end;
  end;
end;

procedure TEzScene.RefreshObject(Index: Integer);
var
  temp_obj: TEzObject;
  ent: TEzEntity;
begin
  if ValidIndex(Index) then
  begin
    temp_obj := GetObjectPointer(Index);
    FreeAndNil(temp_obj.FObject);
    ent := temp_obj.FLayer.LoadEntityWithRecNo(temp_obj.FID);
    temp_obj.FObject := ent;
  end
  else
    raise EAbort.Create(sInvalidIndex);
end;

procedure TEzScene.ExportObjects(OnExportObject: TBaseEzObjectEvent);
var
  I: Integer;
  Obj: TEzObject;
begin
  if Assigned(OnExportObject) then
  for I := 0 to Pred(ObjectCount) do
  begin
    Obj := GetObject(I);
    OnExportObject(Self, Succ(I), FObjects.Strings[I], Obj);
    FreeAndNil(Obj);
  end;
end;

procedure TEzScene.ReplaceObject(Index: Integer; ObjName: String; Obj: TEzObject);
begin
  if ValidIndex(Index) then
  begin
    FObjects.Strings[Index] := ObjName;
    if Assigned(FObjects.Objects[Index]) then FObjects.Objects[Index].Free;
    FObjects.Objects[Index] := Obj; 
  end;
end;

procedure TEzScene.Refresh;
var
  I: Integer;
begin
  for I := 0 to ObjectCount - 1 do
    RefreshObject(I); 
end;

function TEzScene.Extent: TEzRect;
var
  I: Integer;
  MinX, MinY, MaxX, MaxY: Double;
begin
  Result := INVALID_EXTENSION;
  if ObjectCount = 0 then Exit;
  MinX := MAXCOORD;
  MinY := MAXCOORD;
  MaxX := MINCOORD;
  MaxY := MINCOORD;
  for I := 0 to ObjectCount - 1 do
  with GetObjectPointer(I).StoredObject do
  begin
    MinX := Min(MinX, FBox.xmin);
    MinY := Min(MinY, FBox.ymin);
    MaxX := Max(MaxX, FBox.xmax);
    MaxY :=Max(MaxY, FBox.ymax);
    Free;
  end;
  Result := Rect2D(MinX, MinY, MaxX, MaxY);
end;

{ TEzVisualScene }

procedure TEzVisualScene.ShowEditor(Index: Integer);
var
  Ent: TEzEntity;
  RTF: TEzRTFText;
  S: String;
begin
  if ValidIndex(Index) then
  begin
    with FObjects.Objects[Index] as TEzObject do
    begin
      Ent := StoredObject;
      if Assigned(Ent) then
        try
          case Ent.EntityID of
          idTrueTypeText :
            if ShowTrueTypeTextEditor(TEzTrueTypeText(ent)) then
              FObject.Assign(ent);
          idRtfText :
            begin
              if Length(FParams) > 0 then S := FParams[0] else S := '';
              RTF := Ent as TEzRTFText;
              if ShowEzRichTextEditor(RTF, S) then
                FObject.Assign(RTF);
            end;
          end;
        finally
          FreeAndNil(Ent);
        end // of try
      else
        raise EAbort.Create(sObjectNotAssigned);
    end;
  end;
end;

function ObjectInScene(Scene: TEzScene; const LayerName: String;
  UID: Integer; var Index: Integer): Boolean;
begin
  Index := Scene.IndexOf(LayerName, UID);
  Result := Index >= 0;
end;

end.
