unit uMStClassesProjectsUtils;

interface

uses
  SysUtils, Graphics,
  EzBase, EzBaseGIS, EzLib, EzEntities,
  uCK36,
  uEzLayerUtils,
  uMStConsts,
  uMStClassesProjects, uMStClassesProjectsMP;

type
  TProjectUtils = class
  private
    class procedure AddLineToLayer(aLayer: TEzBaseLayer; aLine: TmstProjectLine);
    class procedure AddPlaceToLayer(aLayer: TEzBaseLayer; aPlace: TmstProjectPlace);
    class function PointTo2D(aPrj: TmstProject; aPt: TmstProjectPoint): TEzPoint;
    class procedure ClearLayer(const aLayerName: string; aPredicate: TLayerRecNoPredicate);
    //
    class procedure AddMPProjectToGIS(aPrj: TmstProjectMP);
  public
    class procedure AddProjectToGIS(aPrj: TmstProject); 
    class procedure FindProjectInGIS(Prj: TmstProject; LineId: Integer; out Layer: TEzBaseLayer; out RecNo: Integer);
    class function ProjectLayerName(aPrj: TmstProject): string;
    class function Window(aPrj: TmstProject): TEzRect;
    //
    class function LineToEntity(aPrj: TmstProject; aProjLine: TmstProjectLine; Poly: Boolean): TEzOpenedEntity;
    class procedure ShowProjectLayer(aPrj: TmstProject);
    //
    class procedure ClearProjectLayers();
    class procedure RemoveProjectFromLayer(const ProjectId: Integer);
    class procedure RemoveProjectLineFromLayer(const ProjectId, LineId: Integer);
    //
    class function AddLineZoneToGIS(aLine: TmstProjectLine; aZoneWidth: Double): Boolean;
    class function RemoveLineZone(aLine: TmstProjectLine): Boolean;
    //
    class function GetMPLayerCode(StatusId, MPLayerId: Integer): Integer;
    class function GetMPLayerName(StatusId, MPLayerId: Integer): String;
    //
    class procedure AddMpObjToLayer(aLayer: TEzBaseLayer; aMpObj: TmstMPObject);
    class function GetMpObjEntity(aMpObj: TmstMPObject): TEzEntity;
  public
    class var GIS: TEzBaseGIS;
    class var AllLayers: TmstProjectLayers;
  end;


implementation

uses
  uEzEntityCSConvert;

{ TProjectUtils }

class procedure TProjectUtils.AddLineToLayer(aLayer: TEzBaseLayer; aLine: TmstProjectLine);
var
  Poly: TEzPolyLine;
  Pts: array of TEzPoint;
  I: Integer;
  PolyColor: TColor;
  ZonePoly: TEzOpenedEntity;
  NetId: Integer;
begin
  SetLength(Pts, aLine.Points.Count);
  //
  for I := 0 to aLine.Points.Count - 1 do
  begin
    Pts[I] := PointTo2D(aLine.Owner, aLine.Points[I]);
  end;
  //
  Poly := TEzPolyLine.CreateEntity(Pts, False);
  try
    Poly.PenTool.Width := TProjectsSettings.PenWidth;//-2;
    if aLine.Layer.Destroyed then
      Poly.PenTool.Color := clRed
    else
    begin
      if Assigned(aLine.Layer) and Assigned(aLine.Layer.NetType) then
        Poly.PenTool.Color := aLine.Layer.NetType.GetColor()
      else
        Poly.PenTool.Color := clBlue;
    end;
    PolyColor := Poly.PenTool.Color;
    I := aLayer.AddEntity(Poly);
    aLine.EntityId := I;
    aLayer.Recno := I;
    aLayer.DBTable.Edit;
    aLayer.DBTable.IntegerPut(SLF_PROJECT_ID, aLine.Owner.DatabaseId);
    aLayer.DBTable.IntegerPut(SLF_LINE_ID, aLine.DatabaseId);
    aLayer.DBTable.IntegerPut(SLF_LAYER_ID, aLine.Layer.DatabaseId);
    NetId := -1;
    if Assigned(aLine.Layer) then
      if Assigned(aLine.Layer.NetType) then
        NetId := aLine.Layer.NetType.DatabaseId;
    aLayer.DBTable.IntegerPut(SLF_NET_ID, NetId);
    aLayer.DBTable.Post;
  finally
    Poly.Free;
  end;
  //
  if Assigned(aLine.ZoneLine) then
  begin
    if not Assigned(aLine.Zone) then
    begin
      ZonePoly := TProjectUtils.LineToEntity(aLine.Owner, aLine.ZoneLine, True);
      aLine.Zone := ZonePoly;
      ZonePoly.PenTool.Color := PolyColor;
      ZonePoly.PenTool.Style := 4;
      Poly.PenTool.Width := TProjectsSettings.PenWidth;//-2;
    end;
    I := aLayer.AddEntity(aLine.Zone);
    aLine.ZoneLine.EntityId := I;
    aLayer.DBTable.RecNo := aLine.ZoneLine.EntityId;
    aLayer.DBTable.Edit;
    aLayer.DBTable.IntegerPut(SF_PROJECT_ID, aLine.Owner.DatabaseId);
    aLayer.DBTable.IntegerPut(SLF_LAYER_ID, aLine.Layer.DatabaseId);
    aLayer.DBTable.IntegerPut(SLF_NET_ID, NetId);
    aLayer.DBTable.Post;
  end
  else
  begin
    aLine.Zone := nil;
  end;
end;

class function TProjectUtils.AddLineZoneToGIS(aLine: TmstProjectLine; aZoneWidth: Double): Boolean;
var
  EzLayer: TEzBaseLayer;
  LineRecNo, ZoneRecNo: Integer;
  LineEnt: TEzEntity;
  ZoneEnt: TEzOpenedEntity;
  Updated: Boolean;
begin
  Result := False;
  TProjectUtils.FindProjectInGIS(aLine.Owner, aLine.DatabaseId, EzLayer, LineRecNo);
  if EzLayer = nil then
    Exit;
  if Assigned(aLine.ZoneLine) and Assigned(aLine.Zone) and (aLine.ZoneLine.EntityId > 0) then
    ZoneRecNo := aLine.ZoneLine.EntityId
  else
    ZoneRecNo := 0;
  // строим зону
  aLine.BuildZone(aZoneWidth);
  // создаём объект для карты
  LineEnt := EzLayer.LoadEntityWithRecNo(LineRecNo);
  if Assigned(aLine.ZoneLine) then
  begin
    ZoneEnt := TProjectUtils.LineToEntity(aLine.Owner, aLine.ZoneLine, True);
    aLine.Zone := ZoneEnt;
  end
  else
  begin
    ZoneEnt := nil;
    aLine.Zone := nil;
    if ZoneRecNo > 0 then
      EzLayer.DeleteEntity(ZoneRecNo);
  end;
  if Assigned(ZoneEnt) then
  begin
    if Assigned(LineEnt) and (LineEnt is TEzOpenedEntity) then
      ZoneEnt.PenTool.Color := TEzOpenedEntity(LineEnt).PenTool.Color
    else
      ZoneEnt.PenTool.Color := clBlue;
    ZoneEnt.PenTool.Style := 4;
    // если уже есть зона, то обновляем её
    // если нет, то добавляем
    Updated := False;
    if ZoneRecNo > 0 then
    begin
      EzLayer.Recno := ZoneRecNo;
      if not EzLayer.RecIsDeleted then
      begin
        EzLayer.UpdateEntity(ZoneRecNo, ZoneEnt);
        Updated := True;
        Result := True;
      end;
    end;
    if not Updated then
    begin
      aLine.ZoneLine.EntityId := EzLayer.AddEntity(ZoneEnt);
      EzLayer.DBTable.RecNo := aLine.ZoneLine.EntityId;
      EzLayer.DBTable.Edit;
      EzLayer.DBTable.IntegerPut(SF_PROJECT_ID, aLine.Owner.DatabaseId);
      EzLayer.DBTable.Post;
      Result := True;
    end;
  end;
end;

class procedure TProjectUtils.AddMpObjToLayer(aLayer: TEzBaseLayer; aMpObj: TmstMPObject);
var
  Ent: TEzEntity;
  EntClass: TEzEntityClass;
  EntityID: TEzEntityID;
begin
  if Assigned(aLayer) then
  begin
    EntityID := TEzEntityID(aMpObj.EzId);
    EntClass := GetClassFromID(EntityID);
    Ent := EntClass.Create(0, True);
    try
      aMPObj.EzData.Position := 0;
      Ent.LoadFromStream(aMPObj.EzData);
      if aMpObj.CK36 then
        TEzCSConverter.EntityToVrn(Ent, not aMPObj.ExchangeXY);
      if aMpObj.ExchangeXY then
        TEzCSConverter.ExchangeXY(Ent);
      aMPObj.EzLayerName := aLayer.Name;
      aMPObj.EzLayerRecno := aLayer.AddEntity(Ent);
    finally
      FreeAndNil(Ent);
    end;
  end;
end;

class procedure TProjectUtils.AddMPProjectToGIS(aPrj: TmstProjectMP);
var
  I: Integer;
  MpObj: TmstMPObject;
  ObjLayerName: string;
  EzLayer: TEzBaseLayer;
begin
//  raise Exception.Create('  ');
  for I := 0 to aPrj.Objects.Count - 1 do
  begin
    MpObj := aPrj.Objects[I];
    ObjLayerName := GetMPLayerName(MpObj.Status, MpObj.MPLayerId);
    EzLayer := Self.GIS.Layers.LayerByName(ObjLayerName);
    if EzLayer <> nil then
    begin
      AddMpObjToLayer(EzLayer, MpObj);
      //
      if not EzLayer.LayerInfo.Visible then
        EzLayer.LayerInfo.Visible := True;
    end;
    ;
  end;
end;

class procedure TProjectUtils.AddPlaceToLayer(aLayer: TEzBaseLayer; aPlace: TmstProjectPlace);
var
  I: Integer;
  EntId: TEzEntityID;
  EntClass: TEzEntityClass;
  Ent: TEzEntity;
begin
  if aPlace.EzId >= 0 then
  begin
    EntID := TEzEntityID(aPlace.EzId);
    EntClass := GetClassFromID(EntID);
    Ent := EntClass.Create(1, True);
    try
      aPlace.EzData.Position := 0;
      Ent.LoadFromStream(aPlace.EzData);
      I := aLayer.AddEntity(Ent);
      aPlace.EntityId := I;
      aLayer.Recno := I;
      aLayer.DBTable.Edit;
      aLayer.DBTable.FieldPut(SLF_PROJECT_ID, IntToStr(aPlace.Owner.DatabaseId));
      //aLayer.DBTable.FieldPut(SLF_LINE_ID, IntToStr(aPlace.DatabaseId));
      aLayer.DBTable.FieldPut(SLF_LAYER_ID, IntToStr(aPlace.Layer.DatabaseId));
      aLayer.DBTable.Post;
    finally
      FreeAndNil(Ent);
    end;
  end;
end;

class procedure TProjectUtils.AddProjectToGIS(aPrj: TmstProject);
var
  S1, S2: string;
  OldLayer: TEzBaseLayer;
  NewLayer: TEzBaseLayer;
  I: Integer;
  MyId, PrjId: string;
  Found: Boolean;
begin
  if aPrj is TmstProjectMP then
  begin
    AddMPProjectToGIS(TmstProjectMP(aPrj));
    Exit;
  end;
  // если проект открытый, то ищем его в закрытом слое
  // иначе ищем в открытом слое
  if aPrj.Confirmed then
  begin
    S1 := SL_PROJECT_OPEN;
    S2 := SL_PROJECT_CLOSED;
  end
  else
  begin
    S1 := SL_PROJECT_CLOSED;
    S2 := SL_PROJECT_OPEN;
  end;
  OldLayer := GIS.Layers.LayerByName(S1);
  NewLayer := GIS.Layers.LayerByName(S2);
  if Assigned(OldLayer) then
  begin
    MyId := IntToStr(aPrj.DatabaseId);
    OldLayer.First;
    while not OldLayer.Eof do
    begin
      if not OldLayer.RecIsDeleted then
      begin
        PrjId := OldLayer.DBTable.FieldGet(SLF_PROJECT_ID);
        if PrjId = MyId then
        begin
          OldLayer.DeleteEntity(OldLayer.Recno);
        end;
      end;
      OldLayer.Next;
    end;
  end;
  //
  if Assigned(NewLayer) then
  begin
    Found := False;
    NewLayer.First;
    while not NewLayer.Eof do
    begin
      if not NewLayer.RecIsDeleted then
      begin
        PrjId := NewLayer.DBTable.FieldGet(SLF_PROJECT_ID);
        if PrjId = MyId then
        begin
          Found := True;
          Break;
        end;
      end;
      NewLayer.Next;
    end;
    if not Found then
    begin
      // проект не был загружен
      // загружаем
      for I := 0 to aPrj.Lines.Count - 1 do
        AddLineToLayer(NewLayer, aPrj.Lines[I]);
      for I := 0 to aPrj.Places.Count - 1 do
        AddPlaceToLayer(NewLayer, aPrj.Places[I]);
    end;
    if not NewLayer.LayerInfo.Visible then
      NewLayer.LayerInfo.Visible := True;
  end;
end;

class procedure TProjectUtils.ClearLayer(const aLayerName: string; aPredicate: TLayerRecNoPredicate);
begin
  if Assigned(GIS) then
    TEzlayerUtils.ClearLayer(GIS, aLayerName, aPredicate);
end;

class procedure TProjectUtils.ClearProjectLayers;
begin
  ClearLayer(SL_PROJECT_CLOSED, nil);
  ClearLayer(SL_PROJECT_OPEN, nil);
end;

class procedure TProjectUtils.FindProjectInGIS(Prj: TmstProject; LineId: Integer; out Layer: TEzBaseLayer; out RecNo: Integer);
var
  S2: string;
  NewLayer: TEzBaseLayer;
  MyId: Integer;
  PrjId, MyLineId: string;
begin
  Layer := nil;
  RecNo := 0;
  if not Assigned(Prj) then
    Exit;
  // если проект открытый, то ищем его в закрытом слое
  // иначе ищем в открытом слое
  if Prj.Confirmed then
    S2 := SL_PROJECT_CLOSED
  else
    S2 := SL_PROJECT_OPEN;
  NewLayer := GIS.Layers.LayerByName(S2);
  if Assigned(NewLayer) then
  begin
    NewLayer.First;
    while not NewLayer.Eof do
    begin
      if not NewLayer.RecIsDeleted then
      begin
        NewLayer.DBTable.RecNo := NewLayer.RecNo;
        PrjId := NewLayer.DBTable.FieldGet(SLF_PROJECT_ID);
        if TryStrToInt(PrjId, MyId) then
        begin
          if Prj.DatabaseId = MyId then
          begin
            MyLineId := NewLayer.DBTable.FieldGet(SLF_LINE_ID);
            if TryStrToInt(MyLineId, MyId) then
            begin
              if MyId = LineId then
              begin
                Layer := NewLayer;
                RecNo := NewLayer.Recno;
                Exit;
              end;
            end;
          end;
        end;
      end;
      NewLayer.Next;
    end;
  end;
end;

class function TProjectUtils.GetMPLayerCode(StatusId, MPLayerId: Integer): Integer;
var
  BaseLayerId: Integer;
begin
  BaseLayerId := 50000000;
  Result := BaseLayerId + 100000 * StatusId + MPLayerId;
end;

class function TProjectUtils.GetMPLayerName(StatusId, MPLayerId: Integer): String;
begin
  Result := 'ProjectPlanSub' + IntToStr(GetMPLayerCode(StatusId, MPLayerId));
end;

class function TProjectUtils.GetMpObjEntity(aMpObj: TmstMPObject): TEzEntity;
var
  EntClass: TEzEntityClass;
  EntityID: TEzEntityID;
begin
  EntityID := TEzEntityID(aMpObj.EzId);
  EntClass := GetClassFromID(EntityID);
  Result := EntClass.Create(0, True);
  try
    aMPObj.EzData.Position := 0;
    Result.LoadFromStream(aMPObj.EzData);
    if aMpObj.CK36 then
      TEzCSConverter.EntityToVrn(Result, not aMPObj.ExchangeXY);
    if aMpObj.ExchangeXY then
      TEzCSConverter.ExchangeXY(Result);
  except
    FreeAndNil(Result);
    raise;
  end;
end;

class function TProjectUtils.LineToEntity(aPrj: TmstProject; aProjLine: TmstProjectLine; Poly: Boolean): TEzOpenedEntity;
var
  Polygon: TEzPolygon;
  Polyline: TEzPolyLine;
  I: Integer;
begin
  if Poly then
  begin
    Polygon := TEzPolygon.CreateEntity([Point2D(0, 0)], True);
    Result := Polygon;
    Polygon.Points.Clear;
    for I := 0 to aProjLine.Points.Count - 1 do
      Polygon.Points.Add(PointTo2D(aPrj, aProjLine.Points[I]));
  end
  else
  begin
    Polyline := TEzPolyLine.CreateEntity([Point2D(0, 0)], True);
    Result := Polyline;
    Polyline.Points.Clear;
    for I := 0 to aProjLine.Points.Count - 1 do
      Polyline.Points.Add(PointTo2D(aPrj, aProjLine.Points[I]));
  end;
end;

class function TProjectUtils.PointTo2D(aPrj: TmstProject; aPt: TmstProjectPoint): TEzPoint;
begin
  if aPrj.CK36 then
  begin
//    uCK36.ToVRN(aPt.X, aPt.Y, Result.y, Result.x);
    uCK36.ToVRN(aPt.X, aPt.Y, Result.Y, Result.X);
  end
  else
  begin
    Result.x := aPt.Y;
    Result.y := aPt.X;
  end;
end;

class function TProjectUtils.ProjectLayerName(aPrj: TmstProject): string;
begin
  if aPrj.Confirmed then
    Result := SL_PROJECT_CLOSED
  else
    Result := SL_PROJECT_OPEN;
end;

var
  RemoveProjectFromLayerProjectId: Integer = -1;
  RemoveProjectLineFromLayerProjectId: Integer = -1;
  ProjectIdFieldNo: Integer = -1;
  ProjectLineIdFieldNo: Integer = -1;

function CheckProjectId(Layer: TEzBaseLayer; const Recno: Integer): Boolean;
var
  PrjId, LineId: Integer;
  DoDelete: Boolean;
begin
  Result := False;
  try
    if RemoveProjectFromLayerProjectId > 0 then
    begin
      Layer.DBTable.RecNo := Recno;
      if Layer.RecIsDeleted then
        Exit;
      //
      if ProjectIdFieldNo < 0 then
        ProjectIdFieldNo := Layer.DBTable.FieldNo(SLF_PROJECT_ID);
      DoDelete := ProjectIdFieldNo > 0;
      if DoDelete then
      begin
        if ProjectLineIdFieldNo > 0 then
        begin
          if ProjectLineIdFieldNo < 0 then
            ProjectLineIdFieldNo := Layer.DBTable.FieldNo(SLF_LINE_ID);
        end;
        PrjId := Layer.DBTable.IntegerGetN(ProjectIdFieldNo);
        Result := PrjId = RemoveProjectFromLayerProjectId;
        if Result then
          if RemoveProjectLineFromLayerProjectId > 0 then
          if ProjectLineIdFieldNo > 0 then
          begin
            LineId := Layer.DBTable.IntegerGetN(ProjectLineIdFieldNo);
            Result := LineId = RemoveProjectLineFromLayerProjectId;
          end;
      end;
    end;
  except
    Result := False;
  end;
end;

class function TProjectUtils.RemoveLineZone(aLine: TmstProjectLine): Boolean;
var
  LayerName: string;
  EzLayer: TEzBaseLayer;
begin
  Result := False;
  LayerName := ProjectLayerName(aLine.Owner);
  EzLayer := GIS.Layers.LayerByName(LayerName);
  if EzLayer = nil then
    Exit;
  try
    if Assigned(aLine.ZoneLine) and Assigned(aLine.Zone) and (aLine.ZoneLine.EntityId > 0) then
      EzLayer.DeleteEntity(aLine.ZoneLine.EntityId);
  finally
    aLine.ZoneLine := nil;
    aLine.Zone := nil;
  end;
end;

class procedure TProjectUtils.RemoveProjectFromLayer(const ProjectId: Integer);
begin
  RemoveProjectFromLayerProjectId := ProjectId;
  RemoveProjectLineFromLayerProjectId := -1;
  try
    ProjectIdFieldNo := -1;
    ProjectLineIdFieldNo := -1;
    try
      ClearLayer(SL_PROJECT_CLOSED, CheckProjectId);
    finally
      ProjectIdFieldNo := -1;
      ProjectLineIdFieldNo := -1;
    end;
    try
      ClearLayer(SL_PROJECT_OPEN, CheckProjectId);
    finally
      ProjectIdFieldNo := -1;
      ProjectLineIdFieldNo := -1;
    end;
  finally
    RemoveProjectFromLayerProjectId := -1;
    RemoveProjectLineFromLayerProjectId := -1;
  end;
end;

class procedure TProjectUtils.RemoveProjectLineFromLayer(const ProjectId, LineId: Integer);
begin
  RemoveProjectFromLayerProjectId := ProjectId;
  RemoveProjectLineFromLayerProjectId := LineId;
  try
    ProjectIdFieldNo := -1;
    ProjectLineIdFieldNo := -1;
    try
      ClearLayer(SL_PROJECT_CLOSED, CheckProjectId);
    finally
      ProjectIdFieldNo := -1;
      ProjectLineIdFieldNo := -1;
    end;
    try
      ClearLayer(SL_PROJECT_OPEN, CheckProjectId);
    finally
      ProjectIdFieldNo := -1;
      ProjectLineIdFieldNo := -1;
    end;
  finally
    RemoveProjectFromLayerProjectId := -1;
    RemoveProjectLineFromLayerProjectId := -1;
  end;
end;

class procedure TProjectUtils.ShowProjectLayer(aPrj: TmstProject);
var
  LayerName: string;
  EzLayer: TEzBaseLayer;
begin
  LayerName := TProjectUtils.ProjectLayerName(aPrj);
  EzLayer := GIS.Layers.LayerByName(LayerName);
  if Assigned(EzLayer) then
    EzLayer.LayerInfo.Visible := True;
end;

class function TProjectUtils.Window(aPrj: TmstProject): TEzRect;
begin
  if aPrj.CK36 then
  begin
    uCK36.ToVRN(aPrj.MinX, aPrj.MinY, Result.Y1, Result.X1);
    uCK36.ToVRN(aPrj.MaxX, aPrj.MaxY, Result.Y2, Result.X2);
  end
  else
  begin
    Result.X1 := aPrj.MinY;
    Result.X2 := aPrj.MaxY;
    Result.Y1 := aPrj.MinX;
    Result.Y2 := aPrj.MaxX;
  end;
end;

end.
