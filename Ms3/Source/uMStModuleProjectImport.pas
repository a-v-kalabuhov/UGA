unit uMStModuleProjectImport;

interface

uses
  SysUtils, Classes, EzBaseGIS, EzCtrls, Dialogs, Forms, Controls, ComObj, DB,
  JvComponentBase, JvCreateProcess,
  EzDxfImport, EzLib, EzEntities, EzSystem,
  uFileUtils, uCommonUtils, uGC, uCK36, uAutoCAD,
  uMStConsts, uMStKernelTypes, uMStKernelIBX, uMStKernelGISUtils,
  uMStClassesProjects,
  uMStModuleApp,
  uMStDialogDxfImport;

type
  TmstProjectImportModule = class(TDataModule)
    OpenDialog2: TOpenDialog;
    procedure DataModuleDestroy(Sender: TObject);
    procedure DataModuleCreate(Sender: TObject);
  private
    FProject: TmstProject;
    FDrawBox: TEzBaseDrawBox;
    function ConvertDWGtoDXF(const aFileName: string): string;
    //
    function AddImportToGIS(): Boolean;
    procedure CheckImportCoordinates();
    procedure CheckMissingLayers();
    procedure ConvertEntityCoords(Ent: TEzEntity);
    procedure CopyProjectToLayer();
    function LoadDXF2(const aFileName: string): Boolean;
    function ReadFile2(aFileName: string): Boolean;
    procedure ReadLayerList();
    procedure ReadProject2();
    procedure OnImportXYChanged(Sender: TObject; Value: Boolean);
    procedure OnImportMSK36Changed(Sender: TObject; Value: Boolean);
  private
    FDxfImport: TEzDxfImport;
    FCK36: Boolean;
    // True - первая координата X - направлена вверх, False - направлена в сторону
    FXY: Boolean;
    FMissingLayers: TStrings;
    FRecordCount: Integer;
    FRecordToImport: Integer;
    FLinesCount: Integer;
    FAllLayers: TmstProjectLayers;
    FProjectName: string;
    procedure ReadProjectLayers();
    procedure ReadProjectLines();
    procedure ReadProjectPlaces();
    procedure LoadLinesFromLayer(Layer: TmstProjectLayer; EzLayer: TEzBaseLayer);
    procedure LoadPlacesFromLayer(Layer: TmstProjectLayer; EzLayer: TEzBaseLayer);
    procedure ChangeBlockNames();
  public
    function BeginImport(aDrawBox: TEzBaseDrawBox): Boolean;
    procedure DisplayImportDialog();
    procedure EndImport(Cancel: Boolean);
    //
    property DxfImport: TEzDxfImport read FDxfImport;
    property CK36: Boolean read FCK36;
    property Layers: TmstProjectLayers read FAllLayers;
    property MissingLayers: TStrings read FMissingLayers;
    /// <summary>
    ///   Всего объектов в импортируемом файле
    /// </summary>
    property RecordCount: Integer read FRecordCount;
    /// <summary>
    ///   Объектов, которые будут импортированы
    /// </summary>
    property RecordToImport: Integer read FRecordToImport;
    /// <summary>
    ///   Колинчство осевых линий
    /// </summary>
    property LinesCount: Integer read FLinesCount;
    property XY: Boolean read FXY;
    //
    property Project: TmstProject read FProject;
  end;

var
  mstProjectImportModule: TmstProjectImportModule;

implementation

uses
  uMStDialogDxfImportOptions;

{$R *.dfm}

{ TmstProjectImportModule }

function TmstProjectImportModule.AddImportToGIS: Boolean;
var
  Fields: TStringList;
  L, ImportLayer: TEzBaseLayer;
  I, Rn, Rc, LayerId: Integer;
  Ent: TEzEntity;
  PrjLayer: TmstProjectLayer;
begin
  Rc := 0;
  for I := 0 to FDxfImport.Cad.Layers.Count - 1 do
    Rc := Rc + FDxfImport.Cad.Layers[I].RecordCount;
  Result := Rc > 0;
  if Result then
  begin
    // Добавляем слой
    Fields := TStringList.Create;
    Fields.Forget();
    Fields.Add('UID;N;11;0');
    Fields.Add('LAYER_ID;N;11;0');
    ImportLayer := FDrawBox.GIS.Layers.CreateNew(SL_PROJECT_IMPORT, Fields);
    //
    // в этот слой скидываем объекты
    // для каждого объекта должно быть ID слоя проекта в таблице
    for I := 0 to FDxfImport.Cad.Layers.Count - 1 do
    begin
      L := FDxfImport.Cad.Layers[I];
      PrjLayer := FAllLayers.ByName(L.Name);
      if Assigned(PrjLayer) then
        LayerId := PrjLayer.DatabaseId
      else
        LayerId := 0;
      L.First;
      while not L.Eof do
      begin
        Ent := L.RecLoadEntity();
        ConvertEntityCoords(Ent);
        if Assigned(PrjLayer) and Assigned(PrjLayer.NetType) then
        begin
          if Ent is TEzOpenedEntity then
          begin
            TEzOpenedEntity(Ent).PenTool.Color := PrjLayer.NetType.GetColor();
          end;
        end;
        Rn := ImportLayer.AddEntity(Ent);
        ImportLayer.RecNo := Rn;
        ImportLayer.DBTable.Edit;
        try
          ImportLayer.DBTable.IntegerPut('LAYER_ID', LayerId);
        finally
          ImportLayer.DBTable.Post;
        end;
        L.Next;
      end;
    end;
    FDrawBox.ZoomToLayerRef(SL_PROJECT_IMPORT);
  end;
end;

function TmstProjectImportModule.BeginImport(aDrawBox: TEzBaseDrawBox): Boolean;
begin
  Result := False;
  FDrawBox := nil;
  if not OpenDialog2.Execute() then
    Exit;
  FreeAndNil(FProject);
  // читаем файл
  FProjectName := ChangeFileExt(ExtractFileName(OpenDialog2.Files[0]), '');
  FDrawBox := aDrawBox;
  Result := ReadFile2(OpenDialog2.Files[0]);
end;

procedure TmstProjectImportModule.ChangeBlockNames;
var
  I: Integer;
begin
  for I := 0 to FProject.Blocks.Count - 1 do
    FProject.Blocks[I].Name := GetUniqueString();
end;

procedure TmstProjectImportModule.CheckImportCoordinates();
var
  I: Integer;
  L: TEzBaseLayer;
begin
  FXY := True;
  FCK36 := False;
  // ищем по всем объектам в каде хотя бы одну точку с координатами больше 1000000
  // если есть такая, то смотрим вторую координату
  // если она больше 400000, то она будет X  предыдущая будет Y
  for I := 0 to FDxfImport.Cad.Layers.Count - 1 do
  begin
    L := FDxfImport.Cad.Layers[I];
    if L.LayerInfo.Extension.X2 > 1000000 then
    begin
      FXY := False;
      if L.LayerInfo.Extension.Y2 > 400000 then
      begin
        FCK36 := True;
        Exit;
      end;
    end
    else
    if L.LayerInfo.Extension.Y2 > 1000000 then
    begin
      if L.LayerInfo.Extension.X2 > 400000 then
      begin
        FCK36 := True;
        Exit;
      end;
    end;
  end;
end;

procedure TmstProjectImportModule.CheckMissingLayers;
var
  I: Integer;
  Layer: TEzBaseLayer;
  Ent: TEzEntity;
begin
  FRecordCount := 0;
  for I := 0 to FDxfImport.CAD.Layers.Count - 1 do
  begin
    Layer := FDxfImport.CAD.Layers[I];
    FRecordCount := FRecordCount + Layer.RecordCount;
  end;
  //
  FRecordToImport := 0;
  FLinesCount := 0;
  for I := 0 to FAllLayers.Count - 1 do
  begin
    Layer := FDxfImport.CAD.Layers.LayerByName(FAllLayers[I].Name);
    if FAllLayers[I].Required then
    begin
      if Layer = nil then
        FMissingLayers.Add(FAllLayers[I].Name);
    end;
    if Assigned(Layer) then
    begin
      FRecordToImport := FRecordToImport + Layer.RecordCount;
      if FAllLayers[I].Required and FAllLayers[I].IsLineLayer then
      begin
        Layer.First;
        while not Layer.Eof do
        begin
          Ent := Layer.RecLoadEntity;
          try
            if Ent is TEzOpenedEntity then
              Inc(FLinesCount);
          finally
            Ent.Free;
          end;
          Layer.Next;
        end;
      end;
    end;
  end;
end;

function TmstProjectImportModule.ConvertDWGtoDXF(const aFileName: string): string;
begin
  TAutoCADUtils.ConvertDWGtoDXF({mstClientAppModule.SessionDir, }aFileName);
end;

procedure TmstProjectImportModule.ConvertEntityCoords(Ent: TEzEntity);
var
  I: Integer;
  Pt: TEzPoint;
  X, Y: Double;
begin
  for I := 0 to Ent.Points.Count - 1 do
  begin
    if FXY then
    begin
      X := Ent.Points[I].x;
      Y := Ent.Points[I].y;
    end
    else
    begin
      X := Ent.Points[I].y;
      Y := Ent.Points[I].x;
    end;
    if FCK36 then
      uCK36.ToVRN(X, Y, Pt.y, Pt.x)
    else
      Pt := Point2D(X, Y);
    Ent.Points[I] := Pt;
  end;
end;

procedure TmstProjectImportModule.CopyProjectToLayer;
begin
  TProjectUtils.AddProjectToGIS(FProject);
end;

procedure TmstProjectImportModule.DataModuleCreate(Sender: TObject);
begin
  FAllLayers := TmstProjectLayers.Create;
  FMissingLayers := TStringList.Create;
end;

procedure TmstProjectImportModule.DataModuleDestroy(Sender: TObject);
begin
  FMissingLayers.Free;
  FAllLayers.Free;
end;

procedure TmstProjectImportModule.DisplayImportDialog;
begin
  if mstDxfImportOptionsDialog = nil then
    mstDxfImportOptionsDialog := TmstDxfImportOptionsDialog.Create(Application);
  mstDxfImportOptionsDialog.DisplayDialog(Self);
  mstDxfImportOptionsDialog.OnCK36Changed := Self.OnImportMSK36Changed;
  mstDxfImportOptionsDialog.OnXYChanged := Self.OnImportXYChanged;
end;

procedure TmstProjectImportModule.EndImport(Cancel: Boolean);
var
  View: TEzRect;
begin
  if not Cancel then
  begin
    // прочитать проект из слоя
    ReadProject2();
    // открыть окно редактирования
    if FProject.Edit() then
    begin
      // если сохранили, то сохранеям в БД и показываем в слое проектов
      FProject.Save(mstClientAppModule.MapMngr as IDb);
      CopyProjectToLayer();
      mstClientAppModule.AddLoadedProject(FProject.DatabaseId);
      //
      View := Rect2D(FProject.MinX, FProject.MinY, FProject.MaxX, FProject.MaxY);
      if FProject.CK36 then
        Rect2DToVrn(View, False);
      FDrawBox.SetViewTo(View.ymin, View.xmin, View.ymax, View.xmax);
    end;
  end;
  FreeAndNil(FDxfImport);
  FDrawBox.GIS.Layers.Delete(SL_PROJECT_IMPORT, True);
  FDrawBox.RegenDrawing;
end;

procedure TmstProjectImportModule.OnImportMSK36Changed(Sender: TObject; Value: Boolean);
var
  L: TEzBaseLayer;
  Ent: TEzEntity;
  I: Integer;
  Pt, NewPt: TEzPoint;
begin
  L := FDrawBox.GIS.Layers.LayerByName(SL_PROJECT_IMPORT);
  if Assigned(L) then
  begin
    L.First;
    while not L.Eof do
    begin
      Ent := L.RecLoadEntity();
      try
        for I := 0 to Ent.Points.Count - 1 do
        begin
          Pt := Ent.Points[I];
          if Value then
          begin
            uCK36.ToVRN(Pt.y, Pt.x, NewPt.y, NewPt.x);
          end
          else
          begin
            uCK36.ToCK36(Pt.y, Pt.x, NewPt.y, NewPt.x);
          end;
          Ent.Points[I] := NewPt;
        end;
        L.UpdateEntity(L.Recno, Ent);
      finally
        Ent.Free;
      end;
      L.Next;
    end;
    L.UpdateExtension;
    FDrawBox.ZoomToLayerRef(L.Name);
  end;
end;

procedure TmstProjectImportModule.OnImportXYChanged(Sender: TObject; Value: Boolean);
var
  L: TEzBaseLayer;
  Ent: TEzEntity;
  I: Integer;
  Pt: TEzPoint;
begin
  L := FDrawBox.GIS.Layers.LayerByName(SL_PROJECT_IMPORT);
  if Assigned(L) then
  begin
    L.First;
    while not L.Eof do
    begin
      Ent := L.RecLoadEntity();
      try
        for I := 0 to Ent.Points.Count - 1 do
        begin
          Pt.x := Ent.Points[I].y;
          Pt.y := Ent.Points[I].x;
          Ent.Points[I] := Pt;
        end;
        L.UpdateEntity(L.Recno, Ent);
      finally
        Ent.Free;
      end;
      L.Next;
    end;
    L.UpdateExtension;
    FDrawBox.ZoomToLayerRef(L.Name);
  end;
end;

function TmstProjectImportModule.LoadDXF2(const aFileName: string): Boolean;
begin
  FreeAndNil(FDxfImport);
  FDxfImport := TEzDxfImport.Create(Self);
  FDxfImport.ExplodeBlocks := True;
  FDxfImport.ImportBlocks := True;
  FDxfImport.UseTrueType := True;
  FDxfImport.GenerateMultiLayers := True;
  FDxfImport.ConfirmProjectionSystem := False;
  //
  FDxfImport.DrawBox := Self.FDrawBox;
  FDxfImport.OnFileProgress := nil;
  FDxfImport.FileName := aFileName;
  //
  FDxfImport.ReadDxf();
  //
  ReadLayerList();
  CheckMissingLayers();
  //
  CheckImportCoordinates();
  //
  Result := AddImportToGIS();
end;

procedure TmstProjectImportModule.LoadLinesFromLayer(Layer: TmstProjectLayer; EzLayer: TEzBaseLayer);
var
  Ent: TEzEntity;
  Line: TmstProjectLine;
  I: Integer;
  Pt: TEzPoint;
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
        Line.Points.Add(Pt.y, Pt.x);
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
        Line.Points.Add(Pt.y, Pt.x);
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

procedure TmstProjectImportModule.LoadPlacesFromLayer(Layer: TmstprojectLayer; EzLayer: TEzBaseLayer);
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

function TmstProjectImportModule.ReadFile2(aFileName: string): Boolean;
var
  Ext: string;
  DxfFileName: string;
begin
  Result := False;
  Ext := AnsiUpperCase(ExtractFileExt(aFileName));
  if Ext = '.DWG' then
  begin
    DxfFileName := ConvertDWGtoDXF(aFileName);
    if DxfFileName <> '' then
    begin
      if not FileExists(DxfFileName) then
      begin
        raise Exception.Create('Не удалось сконвертировать файл в формат DXF!' + sLineBreak +
                               aFileName + sLineBreak +
                               DxfFileName);
      end;
      aFileName := DxfFileName;
      Ext := '.DXF';
    end;
  end;
  if Ext = '.DXF' then
    Result := LoadDXF2(aFileName);
end;

procedure TmstProjectImportModule.ReadLayerList;
var
  aDb: IDb;
  Loader: TmstProjectLayerListLoader;
begin
  FAllLayers.Clear;
  aDb := mstClientAppModule.MapMngr as IDb;
  Loader := TmstProjectLayerListLoader.Create;
  try
    Loader.Load(aDb, FAllLayers);
  finally
    Loader.Free;
  end;
end;

procedure TmstProjectImportModule.ReadProject2;
begin
  FProject := TmstProject.Create();
  FProject.CK36 := FCK36;
  FProject.Address := FProjectName;
  ReadProjectLayers();
  ReadProjectLines();
  ReadProjectPlaces();
  ChangeBlockNames();
end;

procedure TmstProjectImportModule.ReadProjectLayers;
var
  aDb: IDb;
  EzLayer: TEzBaseLayer;
  Loader: TmstProjectLayerListLoader;
  TmpLayers: TmstProjectLayers;
  I: Integer;
begin
  aDb :=  mstClientAppModule.MapMngr as IDb;
  TmpLayers := TmstProjectLayers.Create;
  TmpLayers.Forget;
  Loader := TmstProjectLayerListLoader.Create;
  try
    Loader.Load(aDb, TmpLayers);
  finally
    Loader.Free;
  end;
  //
  for I := 0 to TmpLayers.Count - 1 do
  begin
    EzLayer := FDxfImport.CAD.Layers.LayerByName(TmpLayers[I].Name);
    if Assigned(EzLayer) and (EzLayer.RecordCount > 0) then
      FProject.Layers.Add(TmpLayers[I]);
  end;
end;

procedure TmstProjectImportModule.ReadProjectLines;
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
      EzLayer := FDxfImport.CAD.Layers.LayerByName(L.Name);
      if Assigned(EzLayer) then
      begin
        LoadLinesFromLayer(L, EzLayer);
      end;
    end;
  end;
end;

procedure TmstProjectImportModule.ReadProjectPlaces;
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
      EzLayer := FDxfImport.CAD.Layers.LayerByName(L.Name);
      if Assigned(EzLayer) then
      begin
        LoadPlacesFromLayer(L, EzLayer);
      end;
    end;
  end;
end;

end.
