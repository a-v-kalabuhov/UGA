unit uMStProjectLoaders;

interface

uses
  SysUtils, DB,
  EzLib,
  uCK36,
  uMStKernelTypes, uMStKernelIBX, uMStKernelClasses, uMStConsts,
  uMStModuleApp,
  uMStImportEzClasses, uMStClassesProjects;

type
  TMStProjectRectLoader = class(TInterfacedObject, IEzProjectLoader)
  private
    FList: TmstObjectList;
    FRect: TEzRect;
    FRectCK36: TEzRect;
    FDb: IDb;
    FSqlSource: ISqlSource;
    FConnection: IIBXConnection;
    procedure PrepareDataSet(DataSet: TDataSet; MSK36: Boolean); 
  private
    procedure SetDb(Value: IDb);
    procedure SetList(Value: TmstObjectList);
    procedure SetRect(Value: TEzRect);
    procedure SetSqlSource(Value: ISqlSource);
    procedure Execute(CallBack: TProgressEvent2);
  end;

  TMStMPRectLoader = class(TInterfacedObject, IEzProjectLoader)
  private
    FList: TmstObjectList;
    FRect: TEzRect;
    FRectCK36: TEzRect;
    FDb: IDb;
    FSqlSource: ISqlSource;
    FConnection: IIBXConnection;
    procedure PrepareDataSet(DataSet: TDataSet; MSK36: Boolean); 
  private
    procedure SetDb(Value: IDb);
    procedure SetList(Value: TmstObjectList);
    procedure SetRect(Value: TEzRect);
    procedure SetSqlSource(Value: ISqlSource);
    procedure Execute(CallBack: TProgressEvent2);
  end;

implementation

uses
  uMStClassesProjectsUtils;

const
  SQL_GET_PROJECTS_COUNT = 'SQL_GET_PROJECTS_COUNT';
  SQL_GET_PROJECTS = 'SQL_GET_PROJECTS';

{ TMStProjectRectLoader }

procedure TMStProjectRectLoader.Execute(CallBack: TProgressEvent2);
var
  dsPrjs, dsCount: TDataSet;
  DbId, ListIndex: Integer;
  Prj: TmstProject;
  Count, Current: Integer;
  Title: string;
  Sql: string;
//  Added: Boolean;
begin
  inherited;
  Title := 'Проекты';
//  Added := False;
  // Выбираем отводы из БД KIS
  FConnection := FDb.GetConnection(cmReadOnly, dmKis);
  Sql := FSqlSource.GetSqlTextOrCrash(FConnection, SQL_GET_PROJECTS_COUNT);
  dsCount := FConnection.GetDataSet(Sql);
  PrepareDataSet(dsCount, True);
  dsCount.Open;
  try
    Count := dsCount.Fields[0].AsInteger;
  finally
    dsCount.Close;
  end;
  PrepareDataSet(dsCount, False);
  dsCount.Open;
  try
    Count := Count + dsCount.Fields[0].AsInteger;
  finally
    dsCount.Close;
  end;
  //
  if Assigned(CallBack) then
    CallBack(Self, Title, 0, Count);
  if Count > 0 then
  begin
    Sql := FSqlSource.GetSqlTextOrCrash(FConnection, SQL_GET_PROJECTS);
    dsPrjs := FConnection.GetDataSet(Sql);
    PrepareDataSet(dsPrjs, False);
    //
    if Assigned(CallBack) then
      CallBack(Self, Title, 0, Count);
    dsPrjs.Open;
    // По одному перебираем отводы, вставляем их в слой и в список
    // если такой отвод уже есть и его версия меньше чем из БД, то заменяем
    Current := 0;
    while not dsPrjs.Eof do
    begin
      Inc(Current);
      if Assigned(CallBack) then
        CallBack(Self, Title, Current, Count);
      DbId := dsPrjs.FieldByName(SF_ID).AsInteger;
      try
        ListIndex := FList.IndexOfDatabaseId(DbId);
        if ListIndex >= 0 then
          Prj := FList.Items[ListIndex] as TmstProject
        else
        begin
//          Prj := mstClientAppModule.GetProject(DbId);
          Prj := TmstProject.Create;
          fList.Add(Prj);
          Prj.DatabaseId := DbId;
        end;
        Prj.Load(FDb);
        if ListIndex < 0 then
        begin
          TProjectUtils.AddProjectToGIS(Prj);
          mstClientAppModule.AddLoadedProject(Prj.DatabaseId);
//          Added := True;
        end;
      except
        on E: Exception do
          mstClientAppModule.LogError(E, 'ProjectId = ' + IntToStr(DbId));
      end;
      dsPrjs.Next;
    end;
    dsPrjs.Close;
    //
    PrepareDataSet(dsPrjs, True);
    //
    if Assigned(CallBack) then
      CallBack(Self, Title, Current, Count);
    dsPrjs.Open;
    while not dsPrjs.Eof do
    begin
      Inc(Current);
      if Assigned(CallBack) then
        CallBack(Self, Title, Current, Count);
      DbId := dsPrjs.FieldByName(SF_ID).AsInteger;
      try
        ListIndex := FList.IndexOfDatabaseId(DbId);
        if ListIndex >= 0 then
          Prj := FList.Items[ListIndex] as TmstProject
        else
        begin
          Prj := TmstProject.Create;
          fList.Add(Prj);
          Prj.DatabaseId := DbId;
        end;
        Prj.Load(FDb);
        if ListIndex < 0 then
        begin
          TProjectUtils.AddProjectToGIS(Prj);
          mstClientAppModule.AddLoadedProject(Prj.DatabaseId);
//          Added := True;
        end;
      except
        on E: Exception do
          mstClientAppModule.LogError(E, 'ProjectId = ' + IntToStr(DbId));
      end;
      dsPrjs.Next;
    end;
    dsPrjs.Close;
  end;
end;

procedure TMStProjectRectLoader.PrepareDataSet(DataSet: TDataSet; MSK36: Boolean);
var
  R: TEzRect;
begin
  if MSK36 then
    R := FRectCK36
  else
    R := FRect;
  FConnection.SetParam(DataSet, SF_MINX, R.xmin);
  FConnection.SetParam(DataSet, SF_MAXX, R.xmax);
  FConnection.SetParam(DataSet, SF_MINY, R.ymin);
  FConnection.SetParam(DataSet, SF_MAXY, R.ymax);
end;

procedure TMStProjectRectLoader.SetDb(Value: IDb);
begin
  FDb := Value;
end;

procedure TMStProjectRectLoader.SetList(Value: TmstObjectList);
begin
  FList := Value;
end;

procedure TMStProjectRectLoader.SetRect(Value: TEzRect);
begin
  FRect := Value;
  uCK36.ToCK36(FRect.X1, FRect.Y1, FRectCK36.X1, FRectCK36.Y1);
  uCK36.ToCK36(FRect.X2, FRect.Y2, FRectCK36.X2, FRectCK36.Y2);
end;

procedure TMStProjectRectLoader.SetSqlSource(Value: ISqlSource);
begin
  FSqlSource := Value;
end;

{ TMStMPRectLoader }

procedure TMStMPRectLoader.Execute(CallBack: TProgressEvent2);
var
  dsPrjs, dsCount: TDataSet;
  DbId, ListIndex: Integer;
  Prj: TmstProject;
  Count, Current: Integer;
  Title: string;
  Sql: string;
//  Added: Boolean;
begin
  raise Exception.Create('MasterPlan');
  inherited;
  Title := 'Проекты';
//  Added := False;
  // Выбираем отводы из БД KIS
  FConnection := FDb.GetConnection(cmReadOnly, dmKis);
  Sql := FSqlSource.GetSqlTextOrCrash(FConnection, SQL_GET_PROJECTS_COUNT);
  dsCount := FConnection.GetDataSet(Sql);
  PrepareDataSet(dsCount, True);
  dsCount.Open;
  try
    Count := dsCount.Fields[0].AsInteger;
  finally
    dsCount.Close;
  end;
  PrepareDataSet(dsCount, False);
  dsCount.Open;
  try
    Count := Count + dsCount.Fields[0].AsInteger;
  finally
    dsCount.Close;
  end;
  //
  if Assigned(CallBack) then
    CallBack(Self, Title, 0, Count);
  if Count > 0 then
  begin
    Sql := FSqlSource.GetSqlTextOrCrash(FConnection, SQL_GET_PROJECTS);
    dsPrjs := FConnection.GetDataSet(Sql);
    PrepareDataSet(dsPrjs, False);
    //
    if Assigned(CallBack) then
      CallBack(Self, Title, 0, Count);
    dsPrjs.Open;
    // По одному перебираем отводы, вставляем их в слой и в список
    // если такой отвод уже есть и его версия меньше чем из БД, то заменяем
    Current := 0;
    while not dsPrjs.Eof do
    begin
      Inc(Current);
      if Assigned(CallBack) then
        CallBack(Self, Title, Current, Count);
      DbId := dsPrjs.FieldByName(SF_ID).AsInteger;
      try
        ListIndex := FList.IndexOfDatabaseId(DbId);
        if ListIndex >= 0 then
          Prj := FList.Items[ListIndex] as TmstProject
        else
        begin
//          Prj := mstClientAppModule.GetProject(DbId);
          Prj := TmstProject.Create;
          fList.Add(Prj);
          Prj.DatabaseId := DbId;
        end;
        Prj.Load(FDb);
        if ListIndex < 0 then
        begin
          TProjectUtils.AddProjectToGIS(Prj);
          mstClientAppModule.AddLoadedProject(Prj.DatabaseId);
//          Added := True;
        end;
      except
        on E: Exception do
          mstClientAppModule.LogError(E, 'ProjectId = ' + IntToStr(DbId));
      end;
      dsPrjs.Next;
    end;
    dsPrjs.Close;
    //
    PrepareDataSet(dsPrjs, True);
    //
    if Assigned(CallBack) then
      CallBack(Self, Title, Current, Count);
    dsPrjs.Open;
    while not dsPrjs.Eof do
    begin
      Inc(Current);
      if Assigned(CallBack) then
        CallBack(Self, Title, Current, Count);
      DbId := dsPrjs.FieldByName(SF_ID).AsInteger;
      try
        ListIndex := FList.IndexOfDatabaseId(DbId);
        if ListIndex >= 0 then
          Prj := FList.Items[ListIndex] as TmstProject
        else
        begin
          Prj := TmstProject.Create;
          fList.Add(Prj);
          Prj.DatabaseId := DbId;
        end;
        Prj.Load(FDb);
        if ListIndex < 0 then
        begin
          TProjectUtils.AddProjectToGIS(Prj);
          mstClientAppModule.AddLoadedProject(Prj.DatabaseId);
//          Added := True;
        end;
      except
        on E: Exception do
          mstClientAppModule.LogError(E, 'ProjectId = ' + IntToStr(DbId));
      end;
      dsPrjs.Next;
    end;
    dsPrjs.Close;
  end;
end;

procedure TMStMPRectLoader.PrepareDataSet(DataSet: TDataSet; MSK36: Boolean);
var
  R: TEzRect;
begin
  if MSK36 then
    R := FRectCK36
  else
    R := FRect;
  FConnection.SetParam(DataSet, SF_MINX, R.xmin);
  FConnection.SetParam(DataSet, SF_MAXX, R.xmax);
  FConnection.SetParam(DataSet, SF_MINY, R.ymin);
  FConnection.SetParam(DataSet, SF_MAXY, R.ymax);
end;

procedure TMStMPRectLoader.SetDb(Value: IDb);
begin
  FDb := Value;
end;

procedure TMStMPRectLoader.SetList(Value: TmstObjectList);
begin
  FList := Value;
end;

procedure TMStMPRectLoader.SetRect(Value: TEzRect);
begin
  FRect := Value;
  uCK36.ToCK36(FRect.X1, FRect.Y1, FRectCK36.X1, FRectCK36.Y1);
  uCK36.ToCK36(FRect.X2, FRect.Y2, FRectCK36.X2, FRectCK36.Y2);
end;

procedure TMStMPRectLoader.SetSqlSource(Value: ISqlSource);
begin
  FSqlSource := Value;
end;

end.
