unit uMStClassesProjectsExportToMP;

interface

uses
  Classes, DB, Contnrs, Graphics,
  EzLib, EzEntities, EzBaseGIS,
  uMStConsts,
  uMStKernelIBX, uMStKernelTypes,
  uMStClassesProjects, uMStClassesProjectsIntf, uMStClassesProjectsMP, uMStClassesProjectsUtils;

type
  TmstProjectExportToMP = class
  private
    FDB: IDb;
    FProjects: ImstProjects;
    FSaveErrors: Integer;
    FOnProgress: TProgressEvent2;
    function GetProjectIdList: TIntegerList;
    procedure SaveProjectToMP(aPrj: TmstProject);
    function GetMPObjectFromLine(aPrj: TmstProject; aLine: TmstProjectLine): TmstMPObject;
    function GetMPObjectFromPlace(aPrj: TmstProject; aPlace: TmstProjectPlace): TmstMPObject;
    procedure SaveMPObjects(aList: TObjectList);
    procedure LoadSemanticsToMP(aMPObj: TmstMPObject; aPrj: TmstProject);
    procedure CheckFields();
    procedure DoProgress(const Text: string; Current, Count: Integer);
  public
    procedure DoExport(aDB: IDb; aProjects: ImstProjects; OnProgress: TProgressEvent2);
  end;

implementation

const
  SQL_GET_ALL_PROJECTS_ID =
    'SELECT ID FROM PROJECTS ORDER BY ID';
  SQL_GET_ALL_FIELDS_FROM_MASTER_PLAN_OBJECTS =
    'SELECT * FROM MASTER_PLAN_OBJECTS WHERE ID = (SELECT MAX(ID) FROM MASTER_PLAN_OBJECTS)';

{ TmstProjectExportToMP }

procedure TmstProjectExportToMP.CheckFields;
var
  Conn: IIBXConnection;
  Ds: TDataSet;
  Fld: TField;
  AddProjectId: Boolean;
  AddProjectLineId: Boolean;
  AddProjectPlaceId: Boolean;
  AddVoltgeComment: Boolean;
  AddDiameterComment: Boolean;
  AddComment: Boolean;
  AddConfirmdate: Boolean;
  Sql: string;
begin
  Exit;
  AddProjectId := False;
  AddProjectLineId := False;
  AddProjectPlaceId := False;
  AddVoltgeComment := False;
  AddDiameterComment := False;
  AddComment := False;
  AddConfirmdate := False;
  // сначала проверяем наличие колонки PROJECT_ID, PROJECT_LINE_ID и PROJECT_PLACE_ID в таблице MP_OBJECTS
  // проверяем наличие колонки COMMENT в таблице MP_OBJECTS
  // проверяем наличие колонки VOLTAGE_COMMENT в таблице MP_OBJECTS
  // проверяем наличие колонки DIAMETER_COMMENT в таблице MP_OBJECTS
  // проверяем наличие колонки CONFIRM_DATE в таблице MP_OBJECTS
  Conn := FDB.GetConnection(cmReadWrite, dmKis);
  try
    Ds := Conn.GetDataSet(SQL_GET_ALL_FIELDS_FROM_MASTER_PLAN_OBJECTS);
    Ds.Open;
    try
      while not Ds.Eof do
      begin
        Fld := Ds.FindField(SF_PROJECTS_ID);
        AddProjectId := Fld = nil;
        Fld := Ds.FindField(SF_PROJECT_LINES_ID);
        AddProjectLineId := Fld = nil;
        Fld := Ds.FindField(SF_PROJECT_PLACES_ID);
        AddProjectPlaceId := Fld = nil;
        Fld := Ds.FindField(SF_VOLTAGE_COMMENT);
        AddVoltgeComment := Fld = nil;
        Fld := Ds.FindField(SF_DIAMETER_COMMENT);
        AddDiameterComment := Fld = nil;
        Fld := Ds.FindField(SF_COMMENT);
        AddComment := Fld = nil;
        Fld := Ds.FindField(SF_CONFIRM_DATE);
        AddConfirmdate := Fld = nil;
        Break;
      end;
    finally
      Ds.Close;
    end;
    //
    if AddProjectId then
    begin
      Sql := 'ALTER TABLE MASTER_PLAN_OBJECTS ADD PROJECTS_ID INTEGER';
      Conn.ExecSQL(Sql);
    end;
    if AddProjectLineId then
    begin
      Sql := 'ALTER TABLE MASTER_PLAN_OBJECTS ADD PROJECT_LINES_ID INTEGER';
      Conn.ExecSQL(Sql);
    end;
    if AddProjectPlaceId then
    begin
      Sql := 'ALTER TABLE MASTER_PLAN_OBJECTS ADD PROJECT_PLACES_ID INTEGER';
      Conn.ExecSQL(Sql);
    end;
    if AddVoltgeComment then
    begin
      Sql := 'ALTER TABLE MASTER_PLAN_OBJECTS ADD VOLTAGE_COMMENT STRING50';
      Conn.ExecSQL(Sql);
    end;
    if AddDiameterComment then
    begin
      Sql := 'ALTER TABLE MASTER_PLAN_OBJECTS ADD DIAMETER_COMMENT STRING50';
      Conn.ExecSQL(Sql);
    end;
    if AddComment then
    begin
      Sql := 'ALTER TABLE MASTER_PLAN_OBJECTS ADD COMMENT BLOB SUB_TYPE 1 SEGMENT SIZE 1024 CHARACTER SET WIN1251';
      Conn.ExecSQL(Sql);
    end;
    if AddConfirmdate then
    begin
      Sql := 'ALTER TABLE MASTER_PLAN_OBJECTS ADD CONFIRM_DATE TIMESTAMP';
      Conn.ExecSQL(Sql);
    end;
  finally
    Conn.Commit;
  end;
end;

procedure TmstProjectExportToMP.DoExport;
var
  PrjList: TList;
  PrjIdList: TIntegerList;
  I: Integer;
  Prj: TmstProject;
  PrjId: Integer;
begin
  FSaveErrors := 0;
  FProjects := aProjects;
  FDb := aDB;
  FOnProgress := OnProgress;
  //
  // сначала проверяем наличие колонки PROJECT_ID, PROJECT_LINE_ID и PROJECT_PLACE_ID в таблице MP_OBJECTS
  // проверяем наличие колонки COMMENT в таблице MP_OBJECTS
  // проверяем наличие колонки VOLTAGE_COMMENT в таблице MP_OBJECTS
  // проверяем наличие колонки DIAMETER_COMMENT в таблице MP_OBJECTS
  // проверяем наличие колонки CONFIRM_DATE в таблице MP_OBJECTS
  CheckFields();
  // далее непосредственно копирование
  // 1. загружаем все проекты в память
  PrjList := TList.Create;
  try
    PrjIdList := GetProjectIdList();
    try
      for I := 0 to PrjIdList.Count - 1 do
      begin
        DoProgress('Загрузка проектов из БД', I, PrjIdList.Count);
        PrjId := PrjIdList[I];
        Prj := aProjects.GetProject(PrjId, True);
        if Assigned(Prj) then
          PrjList.Add(Prj);
      end;
      //
      for I := 0 to PrjList.Count - 1 do
      begin
        DoProgress('Копирование проектов в Сводный план', I, PrjList.Count);
        SaveProjectToMP(PrjList[I]);
      end;
    finally
      PrjIdList.Free;
    end;
  finally
    PrjList.Free;
  end;
end;

procedure TmstProjectExportToMP.DoProgress(const Text: string; Current, Count: Integer);
begin
  if Assigned(FOnProgress) then
    FOnProgress(Self, Text, Current, Count);
end;

function TmstProjectExportToMP.GetMPObjectFromLine(aPrj: TmstProject; aLine: TmstProjectLine): TmstMPObject;
var
  Poly: TEzPolyLine;
  Pts: array of TEzPoint;
  I: Integer;
begin
  Result := TmstMPObject.Create;
  Result.MpClassId := aLine.Layer.DatabaseId;
  Result.MpLayerId := aLine.Layer.MPLayerId;
  //
  LoadSemanticsToMP(Result, aPrj);
  //
  Result.VoltageComment := aLine.Voltage;
  Result.DiameterComment := aLine.Diameter;
  Result.Comment := aLine.Info;
  // сначала проверяем наличие колонки PROJECT_ID, PROJECT_LINE_ID и PROJECT_PLACE_ID в таблице MP_OBJECTS
  Result.OldProjectLineId := aLine.DatabaseId;
  Result.OldProjectPlaceId := 0;
  // LoadEntity();
  SetLength(Pts, aLine.Points.Count);
  for I := 0 to aLine.Points.Count - 1 do
    Pts[I] := TProjectUtils.PointTo2D(aPrj, aLine.Points[I]);
  //
  Poly := TEzPolyLine.CreateEntity(Pts, False);
  try
    Poly.SaveToStream(Result.EzData);
    Result.EzId := Integer(Poly.EntityID);
    Result.IsLine := True;
  finally
    Poly.Free;
  end;
end;

function TmstProjectExportToMP.GetMPObjectFromPlace(aPrj: TmstProject; aPlace: TmstProjectPlace): TmstMPObject;
begin
  Result := TmstMPObject.Create;
  LoadSemanticsToMP(Result, aPrj);
  Result.MpClassId := aPlace.Layer.DatabaseId;
  Result.MpLayerId := aPlace.Layer.MPLayerId;
  // сначала проверяем наличие колонки PROJECT_ID, PROJECT_LINE_ID и PROJECT_PLACE_ID в таблице MP_OBJECTS
  Result.OldProjectLineId := 0;
  Result.OldProjectPlaceId := aPlace.DatabaseId;
  // LoadEntity();
  aPlace.EzData.Position := 0;
  Result.EzData.CopyFrom(aPlace.EzData, 0);
  Result.EzId := aPlace.EzId;
end;

function TmstProjectExportToMP.GetProjectIdList: TIntegerList;
var
  Conn: IIBXConnection;
  Ds: TDataSet;
begin
  Result := TIntegerList.Create;
  Conn := FDB.GetConnection(cmReadOnly, dmKis);
  try
    Ds := Conn.GetDataSet(SQL_GET_ALL_PROJECTS_ID);
    Ds.Open;
    try
      while not Ds.Eof do
      begin
        Result.Add(Ds.Fields[0].AsInteger);
        Ds.Next;
      end;
    finally
      Ds.Close;
    end;
  finally
    Conn.Commit;
  end;
end;

procedure TmstProjectExportToMP.LoadSemanticsToMP(aMPObj: TmstMPObject; aPrj: TmstProject);
begin
  aMPObj.CK36 := aPrj.CK36;
  aMPObj.Address := aPrj.Address;
  aMPObj.DocNumber := aPrj.DocNumber;
  aMPObj.DocDate := aPrj.DocDate;
  aMPObj.CustomerOrgId := aPrj.CustomerOrgId;
  aMPObj.ExecutorOrgId := aPrj.ExecutorOrgId;
  aMPObj.Confirmed := aPrj.Confirmed;
  aMPObj.Archived := aPrj.Confirmed;
  aMPObj.ConfirmDate := aPrj.ConfirmDate;
  aMPObj.ExchangeXY := aPrj.ExchangeXY;
  aMPObj.OldProjectId := aPrj.DatabaseId;
  aMPObj.ProjectName := aPrj.Address;
  aMPObj.UpdateObjState();
end;

procedure TmstProjectExportToMP.SaveMPObjects(aList: TObjectList);
var
  I: Integer;
  MPObj: TmstMPObject;
  Saver: ImstObjectSaver;
begin
  Saver := TmstMPObjectSaver.Create() as ImstObjectSaver;
  for I := 0 to aList.Count - 1 do
  try
    MPObj := TmstMPObject(aList[I]);
    Saver.Save(FDb, MPObj);
  except
    FSaveErrors := FSaveErrors + 1;
  end;
end;

procedure TmstProjectExportToMP.SaveProjectToMP(aPrj: TmstProject);
var
  I: Integer;
  MPObj: TmstMPObject;
  List: TObjectList;
begin
  // 2. по каждому проекту пробегаем по линиям и сохраняем их в сводный план
  List := TObjectList.Create;
  try
    for I := 0 to aPrj.Lines.Count - 1 do
    begin
      MPObj := GetMPObjectFromLine(aPrj, aPrj.Lines[I]);
      List.Add(MPObj);
    end;
    // 3. по каждому проекту пробегаем по точкам и сохраняем их в сводный план
    for I := 0 to aPrj.Places.Count - 1 do
    begin
      MPObj := GetMPObjectFromPlace(aPrj, aPrj.Places[I]);
      List.Add(MPObj);
    end;
    //
    SaveMPObjects(List);
  finally
    List.Free;
  end;
end;

end.
