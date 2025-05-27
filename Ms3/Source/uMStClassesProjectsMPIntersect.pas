unit uMStClassesProjectsMPIntersect;

interface

uses           
  Contnrs,
  EzBaseGIS, EzLib,
  uEzIntersection;

type
  TmpIntersectionInfo = class
  private
    FOriginalEnt: TEzOpenedEntity;
    FMpClassId: Integer;
    FObjId: Integer;
    FObjIds: TIntegerList;
    FEnts: TObjectList;
    FLists: TObjectList;
    procedure SetMpClassId(const Value: Integer);
    procedure SetObjId(const Value: Integer);
    procedure SetOriginalEnt(const Value: TEzOpenedEntity);
    function GetEntities(const Idx: Integer): TEzEntity;
    function GetIntersectLists(const Idx: Integer): TEzIntersectionList;
    function GetObjectIds(const Idx: Integer): Integer;
  public
    constructor Create;
    destructor Destroy; override;
    //
    procedure AddIntersect(aIntersectObjId: Integer; IntersectEnt: TEzEntity; IntList: TEzIntersectionList);
    function Count: Integer;
    function IndexOfObjectId(const ObjId: Integer): Integer;
    //
    property Entities[const Idx: Integer]: TEzEntity read GetEntities;
    property IntersectLists[const Idx: Integer]: TEzIntersectionList read GetIntersectLists;
    property ObjectIds[const Idx: Integer]: Integer read GetObjectIds;
    //
    property ObjId: Integer read FObjId write SetObjId;
    property OriginalEnt: TEzOpenedEntity read FOriginalEnt write SetOriginalEnt;
    property MpClassId: Integer read FMpClassId write SetMpClassId;
  end;

implementation

{ TmpIntersectionInfo }

procedure TmpIntersectionInfo.AddIntersect(aIntersectObjId: Integer; IntersectEnt: TEzEntity;
  IntList: TEzIntersectionList);
begin
  FObjIds.Add(aIntersectObjId);
  FEnts.Add(IntersectEnt);
  FLists.Add(IntList);
end;

function TmpIntersectionInfo.Count: Integer;
begin
  Result := FEnts.Count;
end;

constructor TmpIntersectionInfo.Create;
begin
  FObjIds := TIntegerList.Create;
  FEnts := TObjectList.Create;
  FLists := TObjectList.Create;
end;

destructor TmpIntersectionInfo.Destroy;
begin
  FLists.Free;
  FEnts.Free;
  FObjIds.Free;
  inherited;
end;

function TmpIntersectionInfo.GetEntities(const Idx: Integer): TEzEntity;
begin
  Result := TEzEntity(FEnts[Idx]);
end;

function TmpIntersectionInfo.GetIntersectLists(const Idx: Integer): TEzIntersectionList;
begin
  Result := TEzIntersectionList(FLists[Idx]);
end;

function TmpIntersectionInfo.GetObjectIds(const Idx: Integer): Integer;
begin
  Result := FObjIds[Idx];
end;

function TmpIntersectionInfo.IndexOfObjectId(const ObjId: Integer): Integer;
begin
  Result := FObjIds.IndexOfValue(ObjId);
end;

procedure TmpIntersectionInfo.SetMpClassId(const Value: Integer);
begin
  FMpClassId := Value;
end;

procedure TmpIntersectionInfo.SetObjId(const Value: Integer);
begin
  FObjId := Value;
end;

procedure TmpIntersectionInfo.SetOriginalEnt(const Value: TEzOpenedEntity);
begin
  FOriginalEnt := Value;
end;

end.
