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
  public
    constructor Create;
    destructor Destroy; override;
    //
    procedure AddIntersect(aIntersectObjId: Integer; IntersectEnt: TEzEntity; IntList: TEzIntersectionList);
    function Count: Integer;
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
