unit uMStImportEzLotLoaders;

interface

uses
  SysUtils, DB,
  EzLib, EzBaseGIS,
  uGC,
  uMStConsts,
  uMStKernelTypes, uMStKernelConsts, uMStKernelClasses, uMStKernelIBX, uMStKernelGISUtils,
  uMstClassesLots,
  uMStImportEzClasses,
  uMStModuleApp;

type
  TEzBaseLoader = class(TInterfacedObject, IEzLotLoader)
  protected
    FLayer: TEzBaseLayer;
    FList: TmstLotList;
    FRect: TEzRect;
    FCategoryId: Integer;
    FConnection: IIBXConnection;
    FSqlSource: ISqlSource;
    procedure PrepareDataSet(DataSet: TDataSet); virtual; abstract;
    procedure Execute(CallBack: TProgressEvent2); virtual; abstract;
  private
    procedure SetConnection(Value: IIBXConnection);
    procedure SetLayer(Value: TEzBaseLayer);
    procedure SetLotList(Value: TmstLotList);
    procedure SetRect(Value: TEzRect);
    procedure SetSqlSource(Value: ISqlSource);
  public
    constructor Create(aCategoryId: Integer);
  end;

  TEzNoCategoryLoader = class(TEzBaseLoader)
  protected
    procedure PrepareDataSet(DataSet: TDataSet); override;
    procedure Execute(CallBack: TProgressEvent2); override;
  end;

  TEzCategorizedLoader = class(TEzBaseLoader)
  protected
    procedure PrepareDataSet(DataSet: TDataSet); override;
    procedure Execute(CallBack: TProgressEvent2); override;
  end;

implementation

const
  SQL_GET_LOTS_COUNT_NO_CATEGORY = 'GET_LOTS_COUNT_NO_CATEGORY';
  SQL_GET_LOTS_NO_CATEGORY = 'GET_LOTS_NO_CATEGORY';
  SQL_GET_LOTS_COUNT_WITH_CATEGORY = 'GET_LOTS_COUNT_WITH_CATEGORY';
  SQL_GET_LOTS_WITH_CATEGORY = 'GET_LOTS_WITH_CATEGORY';
  SQL_GET_LOT_CONTOURS = 'GET_LOT_CONTOURS';//'SELECT * FROM ALLOTMENT_CONTOURS WHERE ALLOTMENTS_ID=:ID ORDER BY ID';
  SQL_GET_LOT_POINTS = 'GET_LOT_POINTS';//'SELECT * FROM ALLOTMENT_POINTS WHERE ALLOTMENTS_ID=:ID ORDER BY CONTOURS_ID, ID';

//  SQ_GET_ALLOTMENTS = 'SELECT * FROM GET_ALLOTMENTS_BY_RECT(:MINX, :MAXX, :MINY, :MAXY, :CHECKED, :CANCELLED)';
//  SQ_GET_ALLOTMENTS_COUNT = 'SELECT COUNT(*) FROM GET_ALLOTMENTS_BY_RECT(:MINX, :MAXX, :MINY, :MAXY, :CHECKED, :CANCELLED)';
//  SQ_GET_CONTOURS_FOR_ALLOTMENT = 'SELECT * FROM ALLOTMENT_CONTOURS WHERE ALLOTMENTS_ID=:ID ORDER BY ID';
//  SQ_GET_POINTS_FOR_ALLOTMENT = 'SELECT * FROM ALLOTMENT_POINTS WHERE ALLOTMENTS_ID=:ID ORDER BY CONTOURS_ID, ID';

{ TEzNoCategoryLoader }

procedure TEzNoCategoryLoader.Execute(CallBack: TProgressEvent2);
var
  dsLots, dsContours, dsPoints, dsCount: TDataSet;
  Id, ListIndex, LayerIndex: Integer;
  mstLot: TmstLot;
  Entity: TEzEntity;
  Count, Current: Integer;
  Title: string;
  Sql: string;
  LotCat: TmstLotCategory;
begin
  inherited;
  LotCat := mstClientAppModule.MapMngr.CategoryById(FCategoryId);
  Title := LotCat.GetLayerCaption();
  //
  // Выбираем отводы из БД KIS
  Sql := FSqlSource.GetSqlTextOrCrash(FConnection, SQL_GET_LOTS_COUNT_NO_CATEGORY);
  dsCount := FConnection.GetDataSet(Sql);
  PrepareDataSet(dsCount);
  dsCount.Open;
  try
    Count := dsCount.Fields[0].AsInteger;
  finally
    dsCount.Close;
  end;
  if Assigned(CallBack) then
    CallBack(Self, Title, 0, Count);
  if Count > 0 then
  begin
    Sql := FSqlSource.GetSqlTextOrCrash(FConnection, SQL_GET_LOTS_NO_CATEGORY);
    dsLots := FConnection.GetDataSet(Sql);
    PrepareDataSet(dsLots);
    //
    Sql := FSqlSource.GetSqlTextOrCrash(FConnection, SQL_GET_LOT_CONTOURS);
    dsContours := FConnection.GetDataSet(Sql);
    //
    Sql := FSqlSource.GetSqlTextOrCrash(FConnection, SQL_GET_LOT_POINTS);
    dsPoints := FConnection.GetDataSet(Sql);
    //
    if Assigned(CallBack) then
      CallBack(Self, Title, 0, Count);
    dsLots.Open;
    // По одному перебираем отводы, вставляем их в слой и в список
    // если такой отвод уже есть и его версия меньше чем из БД, то заменяем
    Current := 0;
    while not dsLots.Eof do
    begin
      Inc(Current);
      if Assigned(CallBack) then
        CallBack(Self, Title, Current, Count);
      Id := dsLots.FieldByName(SF_ID).AsInteger;
      try
        ListIndex := FList.IndexOfDatabaseId(Id);
        if ListIndex >= 0 then
          mstLot := FList.Items[ListIndex]
        else
          mstLot := FList.AddLot;
        LayerIndex := mstLot.EntityID;
        if mstLot.Version <> dsLots.FieldByName(SF_VRS).AsInteger then
        begin
          // обновляем данные в списке
          mstLot.LoadMainData(dsLots, True);
          mstLot.Categorized := False;
          FConnection.SetParam(dsContours, SF_ID, Id);
          FConnection.SetParam(dsPoints, SF_ID, Id);
          dsContours.Open;
          dsPoints.Open;
          mstLot.LoadCoords(dsContours, dsPoints);
          dsContours.Close;
          dsPoints.Close;
          if mstLot.PointsLoaded then
          begin
          // обновляем данные в слое
            Entity := ExportLot(mstLot);
            if Assigned(Entity) then
            begin
              Entity.Forget();
              if LayerIndex > 0 then
                FLayer.UpdateEntity(LayerIndex, Entity)
              else
                mstLot.EntityID := FLayer.AddEntity(Entity)
            end
            else
              FList.Remove(mstLot);
          end;
        end;
      except
        on E: Exception do
          mstClientAppModule.LogError(E, 'LotId = ' + IntToStr(Id));
      end;
      dsLots.Next;
    end;
    dsLots.Close;
  end;
end;

procedure TEzNoCategoryLoader.PrepareDataSet(DataSet: TDataSet);
var
  LotType: TmstLotType;
begin
  LotType := TmstLot.CatToType(FCategoryId);
  FConnection.SetParam(DataSet, SF_XMIN, FRect.xmin);
  FConnection.SetParam(DataSet, SF_XMAX, FRect.xmax);
  FConnection.SetParam(DataSet, SF_YMIN, FRect.ymin);
  FConnection.SetParam(DataSet, SF_YMAX, FRect.ymax);
  FConnection.SetParam(DataSet, SF_CHECKED, Integer(LotType = ltActual));
  FConnection.SetParam(DataSet, SF_CANCELLED, Integer(LotType = ltAnnuled));
end;

{ TEzCategorizedLoader }

procedure TEzCategorizedLoader.Execute(CallBack: TProgressEvent2);
var
  dsLots, dsContours, dsPoints, dsCount: TDataSet;
  Id, ListIndex, LayerIndex: Integer;
  mstLot: TmstLot;
  Entity: TEzEntity;
  Count, Current: Integer;
//  LotType: TmstLotType;
  Title: string;
  Sql: string;
  LotCat: TmstLotCategory;
begin
  inherited;
  LotCat := mstClientAppModule.MapMngr.CategoryById(FCategoryId);
  Title := LotCat.GetLayerCaption();
  //
  // Выбираем отводы из БД KIS
  Sql := FSqlSource.GetSqlTextOrCrash(FConnection, SQL_GET_LOTS_COUNT_WITH_CATEGORY);
  dsCount := FConnection.GetDataSet(Sql);
  PrepareDataSet(dsCount);
  dsCount.Open;
  try
    Count := dsCount.Fields[0].AsInteger;
  finally
    dsCount.Close;
  end;
  if Assigned(CallBack) then
    CallBack(Self, Title, 0, Count);
  if Count > 0 then
  begin
    Sql := FSqlSource.GetSqlTextOrCrash(FConnection, SQL_GET_LOTS_WITH_CATEGORY);
    dsLots := FConnection.GetDataSet(Sql);
    PrepareDataSet(dsLots);
    //
    Sql := FSqlSource.GetSqlTextOrCrash(FConnection, SQL_GET_LOT_CONTOURS);
    dsContours := FConnection.GetDataSet(Sql);
    //
    Sql := FSqlSource.GetSqlTextOrCrash(FConnection, SQL_GET_LOT_POINTS);
    dsPoints := FConnection.GetDataSet(Sql);
    //
    if Assigned(CallBack) then
      CallBack(Self, Title, 0, Count);
    dsLots.Open;
    // По одному перебираем отводы, вставляем их в слой и в список
    // если такой отвод уже есть и его версия меньше чем из БД, то заменяем
    Current := 0;
    while not dsLots.Eof do
    begin
      Inc(Current);
      if Assigned(CallBack) then
        CallBack(Self, Title, Current, Count);
      Id := dsLots.FieldByName(SF_ID).AsInteger;
      try
        ListIndex := FList.IndexOfDatabaseId(Id);
        if ListIndex >= 0 then
          mstLot := FList.Items[ListIndex]
        else
          mstLot := FList.AddLot;
        LayerIndex := mstLot.EntityID;
        if mstLot.Version <> dsLots.FieldByName(SF_VRS).AsInteger then
        begin
          // обновляем данные в списке
          mstLot.LoadMainData(dsLots, True);
          mstLot.Categorized := True;
          FConnection.SetParam(dsContours, SF_ID, Id);
          FConnection.SetParam(dsPoints, SF_ID, Id);
          dsContours.Open;
          dsPoints.Open;
          mstLot.LoadCoords(dsContours, dsPoints);
          dsContours.Close;
          dsPoints.Close;
          if mstLot.PointsLoaded then
          begin
          // обновляем данные в слое
            Entity := ExportLot(mstLot);
            if Assigned(Entity) then
            begin
              Entity.Forget();
              if LayerIndex > 0 then
                FLayer.UpdateEntity(LayerIndex, Entity)
              else
                mstLot.EntityID := FLayer.AddEntity(Entity)
            end
            else
              FList.Remove(mstLot);
          end;
        end;
      except
        on E: Exception do
          mstClientAppModule.LogError(E, 'LotId = ' + IntToStr(Id));
      end;
      dsLots.Next;
    end;
    dsLots.Close;
  end;
end;

procedure TEzCategorizedLoader.PrepareDataSet(DataSet: TDataSet);
begin
  FConnection.SetParam(DataSet, SF_XMIN, FRect.xmin);
  FConnection.SetParam(DataSet, SF_XMAX, FRect.xmax);
  FConnection.SetParam(DataSet, SF_YMIN, FRect.ymin);
  FConnection.SetParam(DataSet, SF_YMAX, FRect.ymax);
  FConnection.SetParam(DataSet, SF_LOT_KINDS_ID, FCategoryId);
end;

{ TEzBaseLoader }

constructor TEzBaseLoader.Create(aCategoryId: Integer);
begin
  FCategoryId := aCategoryId;
end;

procedure TEzBaseLoader.SetConnection(Value: IIBXConnection);
begin
  FConnection := Value;
end;

procedure TEzBaseLoader.SetLayer(Value: TEzBaseLayer);
begin
  FLayer := Value;
end;

procedure TEzBaseLoader.SetLotList(Value: TmstLotList);
begin
  FList := Value;
end;

procedure TEzBaseLoader.SetRect(Value: TEzRect);
begin
  FRect := Value;
end;

procedure TEzBaseLoader.SetSqlSource(Value: ISqlSource);
begin
  FSqlSource := Value;
end;

end.
