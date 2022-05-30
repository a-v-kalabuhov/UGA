unit uKisScanAreaFile;

interface

uses
  SysUtils, Classes, Forms,
  EzBaseGIS, EzEntities, EzDxfImport, EzBase, EzLib,
  uGC, uClasses, uGeoUtils,
  uEzEntityCSConvert, uEzAutoCADImport,
  uKisAppModule,
  uKisDlgSelectAreaLayer;

type
  TKisScanAreaFile = class
  protected
    class function RecEntityIsArea(Layer: TEzBaseLayer): Boolean;
    class function RecMakePoly(Layer: TEzBaseLayer): TEzPolygon;
  public
    function ReadPoly(): TEzPolygon; virtual; abstract;
  end;

  TKisScanAreaFileSingleLayer = class(TKisScanAreaFile)
  private
    FLayerName: string;
    FCheckLayer: Boolean;
    procedure SetLayerName(const Value: string);
    procedure SetCheckLayer(const Value: Boolean);
  public
    function ReadPoly(): TEzPolygon; override;
    //
    property CheckLayer: Boolean read FCheckLayer write SetCheckLayer;
    property LayerName: string read FLayerName write SetLayerName;
  end;

  TKisScanAreaFileMultipleLayers = class(TKisScanAreaFile)
  public
    function ReadPoly(): TEzPolygon; override;
  end;

implementation

{ TKisScanAreaFile }

class function TKisScanAreaFile.RecMakePoly(Layer: TEzBaseLayer): TEzPolygon;
var
  Ent: TEzEntity;
  I: Integer;
  IsCK36: Boolean;
begin
  Result := nil;
  Ent := Layer.RecEntity;
  if Ent is TEzPolygon then
  begin
    Result := TEzPolygon.CreateEntity([]);
    Result.Assign(Ent);
  end
  else
  begin
    if Ent is TEzPolyline then
    begin
      Result := TEzPolygon.CreateEntity([]);
      for I := 0 to Ent.Points.Count - 2 do
        Result.Points.Add(Ent.Points[I]);
      if not EqualPoint2D(Ent.Points[0], Ent.Points[Ent.Points.Count - 1]) then
        Result.Points.Add(Ent.Points[Ent.Points.Count - 1]);
    end;
  end;
  if Assigned(Result) then
  begin
    IsCK36 := False;
    for I := 0 to Result.Points.Count - 1 do
    begin
      if TGeoUtils.IsMCK36(Result.Points[I].x, Result.Points[I].y) then
      begin
        IsCK36 := True;
        Break;
      end;
    end;
    if IsCK36 then
      TEzCSConverter.EntityToVrn(Result);
    TEzCSConverter.ExchangeXY(Result);
  end;
end;

class function TKisScanAreaFile.RecEntityIsArea(Layer: TEzBaseLayer): Boolean;
var
  Poly: TEzOpenedEntity;
begin
  Result := False;
  if Layer.RecEntityID = idPolygon then
  begin
    Poly := Layer.RecEntity as TEzPolygon;
    Result := Poly.Points.Parts.Count < 2;
  end
  else
  if Layer.RecEntityID = idPolyline then
  begin
    Poly := Layer.RecEntity as TEzPolyline;
    Result := Poly.Points.Parts.Count < 2;
    if Result then
      Result := Poly.Points.Count > 2;
  end;
end;

{ TKisScanAreaFile }

function TKisScanAreaFileSingleLayer.ReadPoly: TEzPolygon;
var
  Layer: TEzBaseLayer;
  Import: TEzDxfImport;
  B: Boolean;
begin
  Result := nil;
  // загружаем область из файла
  TEzAutoCADImport.Instance.TempPath := AppModule.AppTempPath;
  B := TEzAutoCADImport.Instance.ReadLayerFromFile(FLayerName, Import, Layer);
  try
    try
      if B then
      begin
        if FCheckLayer then
        begin
          if Layer = nil then
            raise Exception.Create('В файле нет слоя "' + FLayerName + '"!');
          if Layer.RecordCount = 0 then
            raise Exception.Create('В слое "' + FLayerName + '" нет объектов!');
          if Layer.RecordCount > 1 then
            raise Exception.Create('В слое "' + FLayerName + '" больше одного объекта!');
        end;
        Layer.First;
        if not (Layer.RecEntityID in [idPolyline, idPolygon]) then
          raise Exception.Create('Объект в слое "' + FLayerName + '" не является полигоном!');
        Result := RecMakePoly(Layer);
      end;
    finally
      DeleteFile(Import.FileName);
      FreeAndNil(Import);
    end;
  finally

  end;
end;

procedure TKisScanAreaFileSingleLayer.SetCheckLayer(const Value: Boolean);
begin
  FCheckLayer := Value;
end;

procedure TKisScanAreaFileSingleLayer.SetLayerName(const Value: string);
begin
  FLayerName := Value;
end;

{ TKisScanAreaFileMultipleLayers }

function TKisScanAreaFileMultipleLayers.ReadPoly: TEzPolygon;
var
  Layer: TEzBaseLayer;
  I: Integer;
  Import: TEzDxfImport;
  Layers: TStringList;
  LayerIdx: Integer;
  SelLayerIdx: Integer;
begin
  // открываем файл
  // просматривем слои
  // для каждого слоя считаем количество объектов типа полигон или полилиния в слое
  // если их больше 0, то добавляем в список
  // по этому списку смотрим
  // если много слоёв в списке, то показываем диалог выбора слоя
  // если всего один слой, и в нём много объектов то ругаемся
  // если всего один слой и в нём один объекто, то возвращаем его без показа диалога
  Result := nil;
  // загружаем область из файла
  TEzAutoCADImport.Instance.TempPath := AppModule.AppTempPath;
  Import := TEzAutoCADImport.Instance.ReadFromFile();
  if Import <> nil then
  try
    Layers := TStringList.Create;
    Layers.Forget;
    for I := 0 to Pred(Import.Cad.Layers.Count) do
    begin
      Layer := Import.Cad.Layers[I];
      if Layer.RecordCount > 0 then
      begin
        LayerIdx := -1;
        Layer.First;
        while not Layer.Eof do
        begin
          if RecEntityIsArea(Layer) then
          begin
            if LayerIdx < 0 then
            begin
              LayerIdx := Layers.Add(Layer.Name);
              Layers.Number[LayerIdx] := 1;
            end
            else
              Layers.IncNumber(LayerIdx);
          end
          else
            Layer.DeleteEntity(Layer.Recno);
          Layer.Next;
        end;
      end;
    end;
    //
    for I := Layers.Count - 1 downto 0 do
    begin
      if Layers.Number[I] > 1 then
        Layers.Delete(I);
    end;
    //
    Layer := nil;
    case Layers.Count of
    0:
        begin
            raise Exception.Create(
                    'В файле "' + Import.FileName + '" нет подходящих слоёв!' +
                    sLineBreak +
                    'Чтобы задать область производства работ нужен слой с одной замкнутой линией!');
        end;
    1 :
        begin
          if Layers.Number[0] = 1 then
            Layer := Import.Cad.Layers.LayerByName(Layers[0])
          else
          begin
            raise Exception.Create(
                    'В слое "' + Layers[0] + '" слошком много объектов!' +
                    sLineBreak +
                    'Нужно чтобы в слое была одна замкнутая линия!');
          end;
        end
    else
        begin
          // диалог
          if TKisSelectAleaLayerDialog.ShowDlg(Layers, SelLayerIdx) then
            Layer := Import.Cad.Layers.LayerByName(Layers[SelLayerIdx]);
        end;
    end;
    // импортируем объект
    if Layer <> nil then
    begin
      Layer.First;
      while not Layer.Eof do
      begin
        if not Layer.RecIsDeleted then
        begin
          Result := RecMakePoly(Layer);
          Break;
        end;
        Layer.Next;
      end;
    end;
  finally
    DeleteFile(Import.FileName);
    FreeAndNil(Import);
  end;
end;

end.
