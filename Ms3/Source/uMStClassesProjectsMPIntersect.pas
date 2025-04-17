unit uMStClassesProjectsMPIntersect;

interface

uses
  EzBaseGIS,
  uEzIntersection;

type
  TmpIntersectionInfo = class
  private
    FOriginalEnt: TEzOpenedEntity;
    FMpClassId: Integer;
    FObjId: Integer;
    procedure SetMpClassId(const Value: Integer);
    procedure SetObjId(const Value: Integer);
    procedure SetOriginalEnt(const Value: TEzOpenedEntity);
  public
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

end;

function TmpIntersectionInfo.Count: Integer;
begin

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
