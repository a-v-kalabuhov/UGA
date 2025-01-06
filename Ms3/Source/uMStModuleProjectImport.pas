unit uMStModuleProjectImport;

interface

uses
  SysUtils, Classes, EzBaseGIS, EzCtrls, Dialogs, Forms, Controls, ComObj, DB,
  JvComponentBase, 
  EzDxfImport, EzLib, EzEntities, EzSystem,
  uFileUtils, uCommonUtils, uGC, uCK36, uAutoCAD,
  uMStConsts, uMStKernelTypes, uMStKernelIBX, uMStKernelGISUtils,
  uMStClassesProjects, uMStClassesProjectsEz, 
  uMStModuleApp,
  uMStDialogDxfImport;

type
  TGetImportLayerEvent = procedure (Sender: TObject; out ImportLayer: TEzBaseLayer) of object;
  TOnImportExecuted = procedure (Sender: TObject; Cancelled: Boolean; aProject: TmstProject) of object;

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
    function LoadDXF2(const aFileName: string): Boolean;
    function ReadFile2(aFileName: string): Boolean;
    procedure ReadLayerList();
    procedure ReadProject2();
    procedure OnImportXYChanged(Sender: TObject; Value: Boolean);
    procedure OnImportMSK36Changed(Sender: TObject; Value: Boolean);
  private
    FOnGetImportLayer: TGetImportLayerEvent;
    procedure DoGetImportLayer(out ImportLayer: TEzBaseLayer);
  private
    FOnImportExecuted: TOnImportExecuted;
    procedure DoImportExecuted(Cancelled: Boolean);
  private
    FCreateProjectFunc: TCreateProjectFunc;
    FGetProjectReaderFunc: TGetProjectReaderFunc;
  private
    FDxfImport: TEzDxfImport;
    FCK36: Boolean;
    // Меняем местами X и Y
    FExchangeXY: Boolean;
    FMissingLayers: TStrings;
    FRecordCount: Integer;
    FRecordToImport: Integer;
    FLinesCount: Integer;
    FAllLayers: TmstProjectLayers;
    FProjectName: string;
    FImportFileName: string;
    function GetProjectLayers(): TmstProjectLayers;
    procedure ReadProjectLayers(aLayers: TmstProjectLayers);
    procedure ChangeBlockNames();
    procedure SetExchangeXY(const Value: Boolean);
  public
    function BeginImport(aDrawBox: TEzBaseDrawBox; OnGetImportLayer: TGetImportLayerEvent;
      OnImportExecuted: TOnImportExecuted; OnCreateProject: TCreateProjectFunc;
      OnGetProjectReader: TGetProjectReaderFunc): Boolean;
    procedure DisplayImportDialog();
    procedure EndImport(Cancel: Boolean);
    //
    property DxfImport: TEzDxfImport read FDxfImport;
    property CK36: Boolean read FCK36;
    property ExchangeXY: Boolean read FExchangeXY write SetExchangeXY;
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
//    property ExchangeXY: Boolean read FExchangeXY;
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
    // Получаем слой
    //
    DoGetImportLayer(ImportLayer);
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

function TmstProjectImportModule.BeginImport(aDrawBox: TEzBaseDrawBox;
  OnGetImportLayer: TGetImportLayerEvent; OnImportExecuted: TOnImportExecuted;
  OnCreateProject: TCreateProjectFunc; OnGetProjectReader: TGetProjectReaderFunc): Boolean;
begin
  Result := False;
  FDrawBox := nil;
  if not OpenDialog2.Execute() then
    Exit;
  FreeAndNil(FProject);
  // читаем файл
  FImportFileName := OpenDialog2.Files[0];
  FProjectName := ChangeFileExt(ExtractFileName(OpenDialog2.Files[0]), '');
  FDrawBox := aDrawBox;
  FOnGetImportLayer := OnGetImportLayer;
  FOnImportExecuted := OnImportExecuted;
  FCreateProjectFunc := OnCreateProject;
  FGetProjectReaderFunc := OnGetProjectReader;
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
  FExchangeXY := False;
  FCK36 := False;
  // ищем по всем объектам в каде хотя бы одну точку с координатами больше 1000000
  // если есть такая, то смотрим вторую координату
  // если она больше 400000, то она будет X  предыдущая будет Y
  for I := 0 to FDxfImport.Cad.Layers.Count - 1 do
  begin
    L := FDxfImport.Cad.Layers[I];
    if L.LayerInfo.Extension.X2 > 1000000 then
    begin
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
        FExchangeXY := True;
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
  Result := TAutoCADUtils.ConvertDWGtoDXF({mstClientAppModule.SessionDir, }aFileName);
end;

procedure TmstProjectImportModule.ConvertEntityCoords(Ent: TEzEntity);
var
  I: Integer;
  PtGeo: TEzPoint;
  PtEz: TEzPoint;
begin
  for I := 0 to Ent.Points.Count - 1 do
  begin
    PtEz := Ent.Points[I];
    if FExchangeXY then
      PtGeo := PtEz
    else
    begin
      PtGeo.x := PtEz.y;
      PtGeo.y := PtEz.x;
    end;
    if FCK36 then
      uCK36.ToVRN(PtGeo.X, PtGeo.Y, PtEz.y, PtEz.x);
    Ent.Points[I] := PtEz;//Point2D(PtGeo.Y, PtGeo.X);
  end;
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

procedure TmstProjectImportModule.DoGetImportLayer(out ImportLayer: TEzBaseLayer);
begin
  ImportLayer := nil;
  if Assigned(FOnGetImportLayer) then
    FOnGetImportLayer(Self, ImportLayer);
end;

procedure TmstProjectImportModule.DoImportExecuted(Cancelled: Boolean);
begin
  if Assigned(FOnImportExecuted) then
    FOnImportExecuted(Self, Cancelled, FProject);
end;

procedure TmstProjectImportModule.EndImport(Cancel: Boolean);
begin
  try
    FProject := nil;
    if not Cancel then
    begin
      // прочитать проект из слоя
      ReadProject2();
      // открыть окно редактирования
      FProject.Caption := ExtractFileName(FImportFileName) + ' - ' + ExtractFilePath(FImportFileName);
      Cancel := not FProject.Edit(True);
    end;
    DoImportExecuted(Cancel);
  finally
    FreeAndNil(FDxfImport);
  end;
end;

function TmstProjectImportModule.GetProjectLayers: TmstProjectLayers;
var
  aDb: IDb;
  Loader: TmstProjectLayerListLoader;
begin
  Result := TmstProjectLayers.Create;
  //
  Loader := TmstProjectLayerListLoader.Create;
  try
    aDb :=  mstClientAppModule.MapMngr as IDb;
    Loader.Load(aDb, Result);
  finally
    Loader.Free;
  end;
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
  FExchangeXY := Value;
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
var
  TmpLayers: TmstProjectLayers;
  PrjReader: IEzProjectReader;
begin
  FProject := FCreateProjectFunc(); //TmstProject.Create();
  FProject.CK36 := FCK36;
  FProject.Address := FProjectName;
  //
  TmpLayers := GetProjectLayers();
  try
    ReadProjectLayers(TmpLayers);
  finally
    TmpLayers.Free;
  end;
  //
  PrjReader := FGetProjectReaderFunc();
  PrjReader.SetExchangeXY(FExchangeXY);
  PrjReader.Read(FProject, TmpLayers, FDxfImport.CAD);
end;

procedure TmstProjectImportModule.ReadProjectLayers;
var
  EzLayer: TEzBaseLayer;
  I: Integer;
begin
  for I := 0 to aLayers.Count - 1 do
  begin
    EzLayer := FDxfImport.CAD.Layers.LayerByName(aLayers[I].Name);
    if Assigned(EzLayer) and (EzLayer.RecordCount > 0) then
      FProject.Layers.Add(aLayers[I]);
  end;
end;

procedure TmstProjectImportModule.SetExchangeXY(const Value: Boolean);
begin
  FExchangeXY := Value;
end;

end.
