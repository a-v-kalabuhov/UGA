unit uMStClassesProjectsEz;

interface

uses
  EzBaseGIS, EzLib, EzEntities,
  uCommonUtils, uEzEntityCSConvert,
  uMStClassesProjects, uMStClassesProjectsMP;

type
  IEzProjectReader = interface
    procedure Read(aProject: TmstProject; aLayers: TmstProjectLayers; aGIS: TEzBaseGIS);
    procedure SetExchangeXY(const Value: Boolean);
  end;

  TEzProjectReaderFactory = class
  public
    class function NewReader(MP: Boolean): IEzProjectReader;
  end;

  TGetProjectReaderFunc = function (): IEzProjectReader of object;

implementation

type
  TEzProjectReader = class(TInterfacedObject, IEzProjectReader)
  private
    FGIS: TEzBaseGIS;
    FLayers: TmstProjectLayers;
    FProject: TmstProject;
    FExchangeXY: Boolean;
    procedure ReadProjectLines();
    procedure ReadProjectPlaces();
    procedure LoadLinesFromLayer(Layer: TmstProjectLayer; EzLayer: TEzBaseLayer);
    procedure LoadPlacesFromLayer(Layer: TmstProjectLayer; EzLayer: TEzBaseLayer);
    procedure ChangeBlockNames();
  protected
    procedure Read(aProject: TmstProject; aLayers: TmstProjectLayers; aGIS: TEzBaseGIS);
    procedure SetExchangeXY(const Value: Boolean);
  end;

  TEzProjectReaderMP = class(TInterfacedObject, IEzProjectReader)
  private
    FGIS: TEzBaseGIS;
    FLayers: TmstProjectLayers;
    FProject: TmstProject;
    FExchangeXY: Boolean;
    procedure ReadProjectObjects();
    procedure ReadObjectsFromLayer(aLayer: TmstProjectLayer; EzLayer: TEzBaseLayer);
    procedure ChangeBlockNames();
  protected
    procedure Read(aProject: TmstProject; aLayers: TmstProjectLayers; aGIS: TEzBaseGIS);
    procedure SetExchangeXY(const Value: Boolean);
  end;

{ TEzProjectReaderFactory }

class function TEzProjectReaderFactory.NewReader(MP: Boolean): IEzProjectReader;
begin
  if MP then
  begin
    Result := TEzProjectReaderMP.Create// as IEzProjectReader;
  end
  else
  begin
    Result := TEzProjectReader.Create// as IEzProjectReader;
  end;
end;

{ TEzProjectReader }

procedure TEzProjectReader.ChangeBlockNames;
var
  I: Integer;
begin
  for I := 0 to FProject.Blocks.Count - 1 do
    FProject.Blocks[I].Name := GetUniqueString();
end;

procedure TEzProjectReader.LoadLinesFromLayer(Layer: TmstProjectLayer; EzLayer: TEzBaseLayer);
var
  Ent: TEzEntity;
  Line: TmstProjectLine;
  I: Integer;
  Pt, PtGeo: TEzPoint;
begin
  EzLayer.First;
  while not EzLayer.Eof do
  begin
    Ent := EzLayer.RecLoadEntity();
    if (Ent is TEzClosedEntity) then
    begin
      Line := FProject.Lines.Add;
      Line.Layer := Layer;
      for I := 0 to Ent.Points.Count - 1 do
      begin
        Pt := Ent.Points[I];
        if FExchangeXY then
        begin
          PtGeo:= PT;
        end
        else
        begin
          PtGeo.x := Pt.y;
          PtGeo.y := Pt.x;
        end;
        Line.Points.Add(PtGeo.x, PtGeo.y);
      end;
    end
    else
    if (Ent is TEzOpenedEntity) then
    begin
      Line := FProject.Lines.Add;
      Line.Layer := Layer;
      for I := 0 to Ent.Points.Count - 1 do
      begin
        Pt := Ent.Points[I];
        if FExchangeXY then
        begin
          PtGeo:= Pt;
        end
        else
        begin
          PtGeo.x := Pt.y;
          PtGeo.y := Pt.x;
        end;
        Line.Points.Add(PtGeo.x, PtGeo.y);
      end;
    end
    else
    begin
      EzLayer.Recno := EzLayer.Recno - 1;
      EzLayer.Next;
    end;
    EzLayer.Next;
  end;
end;

procedure TEzProjectReader.LoadPlacesFromLayer(Layer: TmstProjectLayer; EzLayer: TEzBaseLayer);
var
  Ent: TEzEntity;
  Place: TmstProjectPlace;
begin
  EzLayer.First;
  while not EzLayer.Eof do
  begin
    Ent := EzLayer.RecLoadEntity();
    if (Ent is TEzPlace) then
    begin
//      Place := FProject.Places.Add();
//      Place.Layer := Layer;
//      Place.X := Ent.Points[0].y;
//      Place.Y := Ent.Points[0].x;
//      I := TEzPlace(Ent).SymbolTool.Index;
//      Symbol := Ez_Symbols.Items[I];
//      Block := FProject.Blocks.ByName(Symbol.Name);
//      if Block = nil then
//      begin
//        Block := AddBlock(Symbol);
//        Place.Block := Block;
//      end;
//      Ent.SaveToStream(Place.EzData);
    end
    else
    begin
      Place := FProject.Places.Add();
      Place.Layer := Layer;
      Ent.SaveToStream(Place.EzData);
      Place.EzId := Integer(Ent.EntityID);
    end;
    EzLayer.Next;
  end;
end;

procedure TEzProjectReader.Read(aProject: TmstProject; aLayers: TmstProjectLayers; aGIS: TEzBaseGIS);
begin
  FProject := aProject;
  fLayers := aLayers;
  FGIS := aGIS;
  //
  ReadProjectLines();
  ReadProjectPlaces();
  ChangeBlockNames();
end;

procedure TEzProjectReader.ReadProjectLines;
var
  I: Integer;
  L: TmstProjectLayer;
  EzLayer: TEzBaseLayer;
begin
  for I := 0 to Pred(FProject.Layers.Count) do
  begin
    L := FProject.Layers[I];
    if L.IsLineLayer then
    begin
      EzLayer := FGIS.Layers.LayerByName(L.Name);
      if Assigned(EzLayer) then
      begin
        LoadLinesFromLayer(L, EzLayer);
      end;
    end;
  end;
end;

procedure TEzProjectReader.ReadProjectPlaces;
var
  I: Integer;
  L: TmstProjectLayer;
  EzLayer: TEzBaseLayer;
begin
  for I := 0 to Pred(FProject.Layers.Count) do
  begin
    L := FProject.Layers[I];
    if not L.IsLineLayer then
    begin
      EzLayer := FGIS.Layers.LayerByName(L.Name);
      if Assigned(EzLayer) then
      begin
        LoadPlacesFromLayer(L, EzLayer);
      end;
    end;
  end;
end;

procedure TEzProjectReader.SetExchangeXY(const Value: Boolean);
begin
  FExchangeXY := Value;
end;

{ TEzProjectReaderMP }

procedure TEzProjectReaderMP.ChangeBlockNames;
begin

end;

procedure TEzProjectReaderMP.Read(aProject: TmstProject; aLayers: TmstProjectLayers; aGIS: TEzBaseGIS);
begin
  FProject := aProject;
  fLayers := aLayers;
  FGIS := aGIS;
  //
  ReadProjectObjects();
  ChangeBlockNames();
end;

procedure TEzProjectReaderMP.ReadObjectsFromLayer(aLayer: TmstProjectLayer; EzLayer: TEzBaseLayer);
var
  Ent: TEzEntity;
  MPPrj: TmstProjectMP;
  MPObj: TmstMPObject;
  Xmin, Xmax, Ymin, Ymax: Double;
begin
  MPPrj := TmstProjectMP(FProject);
  //
  EzLayer.First;
  while not EzLayer.Eof do
  begin
    Ent := EzLayer.RecLoadEntity();
    try
      if FExchangeXY then
        TEzCSConverter.ExchangeXY(Ent);
      MPObj := MPPrj.Objects.Add();
      MPObj.ClassId := aLayer.DatabaseId;
      MPObj.MpLayerId := aLayer.MPLayerId;
      Ent.SaveToStream(MPObj.EzData);
      MPObj.EzId := Integer(Ent.EntityID);
      MPObj.EzLayerName := EzLayer.Name;
      MPObj.EzLayerName := EzLayer.Name;
      MPObj.IsLine := Ent is TEzOpenedEntity;
      // мин и макс в свойствах объекта и проекте должен быть в геодезических координатах 
      YMin := Ent.FBox.ymin;
      XMin := Ent.FBox.xmin;
      YMax := Ent.FBox.ymax;
      XMax := Ent.FBox.xmax;
      MPObj.MinX := Ymin;
      MPObj.MinY := Xmin;
      MPObj.MaxX := Ymax;
      MPObj.MaxY := Xmax;
    finally
      Ent.Free;
    end;
    //
    EzLayer.Next;
  end;
 
//    if (Ent is TEzClosedEntity) then
//    begin
//      Line := FProject.Lines.Add;
//      Line.Layer := Layer;
//      for I := 0 to Ent.Points.Count - 1 do
//      begin
//        Pt := Ent.Points[I];
//        if FExchangeXY then
//        begin
//          PtGeo:= PT;
//        end
//        else
//        begin
//          PtGeo.x := Pt.y;
//          PtGeo.y := Pt.x;
//        end;
//        Line.Points.Add(PtGeo.x, PtGeo.y);
//      end;
//    end
//    else
//    if (Ent is TEzOpenedEntity) then
//    begin
//      Line := FProject.Lines.Add;
//      Line.Layer := Layer;
//      for I := 0 to Ent.Points.Count - 1 do
//      begin
//        Pt := Ent.Points[I];
//        if FExchangeXY then
//        begin
//          PtGeo:= Pt;
//        end
//        else
//        begin
//          PtGeo.x := Pt.y;
//          PtGeo.y := Pt.x;
//        end;
//        Line.Points.Add(PtGeo.x, PtGeo.y);
//      end;
//    end
//    else
//    begin
//      Place := FProject.Places.Add();
//      Place.Layer := Layer;
//      Ent.SaveToStream(Place.EzData);
//      Place.EzId := Integer(Ent.EntityID);
//    end;
//    //////////////
//    begin
//      EzLayer.Recno := EzLayer.Recno - 1;
//      EzLayer.Next;
//    end;
//    EzLayer.Next;
//  end;
end;

procedure TEzProjectReaderMP.ReadProjectObjects;
var
  I: Integer;
  L: TmstProjectLayer;
  EzLayer: TEzBaseLayer;
begin
  for I := 0 to Pred(FProject.Layers.Count) do
  begin
    L := FProject.Layers[I];
    EzLayer := FGIS.Layers.LayerByName(L.Name);
    if Assigned(EzLayer) then
    begin
      ReadObjectsFromLayer(L, EzLayer);
    end;
  end;
end;

procedure TEzProjectReaderMP.SetExchangeXY(const Value: Boolean);
begin
  FExchangeXY := Value;
end;

end.
