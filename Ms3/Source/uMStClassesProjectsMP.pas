unit uMStClassesProjectsMP;

interface

uses
  SysUtils, Classes, Contnrs, Forms, DB, Math, Graphics, Dialogs,
  EzLib, EzBaseGIS, EzEntities, EzBase,
  uCommonUtils, uCK36, uGC,
  uEzBufferZone,
  uMStKernelClasses, uMStKernelIBX, uMStConsts, uMStClassesProjects;

type
  TmstProjectMP = class;

  TmstProjectMPObject = class(TmstObject)
  private
    FClassId: Integer;
    FArchived: Boolean;
    FDocNumber: string;
    FStatus: Integer;
    FConfirmed: Boolean;
    FDismantled: Boolean;
    FAddress: string;
    FDocDate: TDateTime;
    FRequestDate: TDateTime;
    FMaterial: string;
    FVoltage: Integer;
    FUnderground: Boolean;
    FPipeCount: Integer;
    FFloor: string;
    FDiameter: Integer;
    FBottom: string;
    FRequestNumber: string;
    FTop: string;
    FOwner: string;
    FDrawDate: TDateTime;
    FIsLine: Boolean;
    FRotation: Integer;
    FEzData: TStream;
    FEzId: Integer;
    FMaxX: Double;
    FMaxY: Double;
    FMinX: Double;
    FMinY: Double;
    FProject: TmstProjectMP;
    FEntityId: Integer;
    FLayer: TmstProjectLayer;
    FGuid: string;
    procedure SetClassId(const Value: Integer);
    procedure SetAddress(const Value: string);
    procedure SetArchived(const Value: Boolean);
    procedure SetConfirmed(const Value: Boolean);
    procedure SetDismantled(const Value: Boolean);
    procedure SetDocNumber(const Value: string);
    procedure SetStatus(const Value: Integer);
    procedure SetDocDate(const Value: TDateTime);
    procedure SetBottom(const Value: string);
    procedure SetDiameter(const Value: Integer);
    procedure SetFloor(const Value: string);
    procedure SetMaterial(const Value: string);
    procedure SetPipeCount(const Value: Integer);
    procedure SetRequestDate(const Value: TDateTime);
    procedure SetRequestNumber(const Value: string);
    procedure SetTop(const Value: string);
    procedure SetUnderground(const Value: Boolean);
    procedure SetVoltage(const Value: Integer);
    procedure SetOwner(const Value: string);
    procedure SetDrawDate(const Value: TDateTime);
    procedure SetIsLine(const Value: Boolean);
    procedure SetRotation(const Value: Integer);
    procedure SetEzId(const Value: Integer);
    procedure SetMaxX(const Value: Double);
    procedure SetMaxY(const Value: Double);
    procedure SetMinX(const Value: Double);
    procedure SetMinY(const Value: Double);
    procedure SetEntityId(const Value: Integer);
  protected
    function GetObjectId: Integer; override;
    function GetText: String; override;
    procedure AssignTo(Target: TPersistent); override;
  public
    constructor Create; override;
    destructor Destroy; override;
    //
    property Project: TmstProjectMP read FProject;
    property Layer: TmstProjectLayer read FLayer write FLayer;
    //
    property Guid: string read FGuid;
    property Address: string read FAddress write SetAddress;
    property Archived: Boolean read FArchived write SetArchived;
    property Bottom: string read FBottom write SetBottom;
    property ClassId: Integer read FClassId write SetClassId;
    property Confirmed: Boolean read FConfirmed write SetConfirmed;
    property Diameter: Integer read FDiameter write SetDiameter;
    property Dismantled: Boolean read FDismantled write SetDismantled;
    property DocNumber: string read FDocNumber write SetDocNumber;
    property DocDate: TDateTime read FDocDate write SetDocDate;
    property DrawDate: TDateTime read FDrawDate write SetDrawDate;
    property Floor: string read FFloor write SetFloor;
    property IsLine: Boolean read FIsLine write SetIsLine;
    property Material: string read FMaterial write SetMaterial;
    property Owner: string read FOwner write SetOwner;
    property PipeCount: Integer read FPipeCount write SetPipeCount;
    property RequestNumber: string read FRequestNumber write SetRequestNumber;
    property RequestDate: TDateTime read FRequestDate write SetRequestDate;
    property Rotation: Integer read FRotation write SetRotation;
    property Status: Integer read FStatus write SetStatus;
    property Top: string read FTop write SetTop;
    property Underground: Boolean read FUnderground write SetUnderground;
    property Voltage: Integer read FVoltage write SetVoltage;
    // используются местная СК: Х - вверх, Y - вправо
    property MinX: Double read FMinX write SetMinX;
    property MinY: Double read FMinY write SetMinY;
    property MaxX: Double read FMaxX write SetMaxX;
    property MaxY: Double read FMaxY write SetMaxY;
    //
    property EzData: TStream read FEzData;
    property EzId: Integer read FEzId write SetEzId;
    property EntityId: Integer read FEntityId write SetEntityId;
  end;

  TmstProjectObjects = class(TObjectList)
  private
    FOwner: TmstProjectMP;
    function GetItems(Index: Integer): TmstProjectMPObject;
    procedure SetItems(Index: Integer; const Value: TmstProjectMPObject);
  public
    constructor Create(aOwner: TmstProjectMP);
    function Add(): TmstProjectMPObject;
    procedure CopyFrom(Source: TmstProjectObjects);
    procedure DeleteObj(const DbId: Integer);
    function GetByGuid(const aGuid: string): TmstProjectMPObject;
    //
    property Items[Index: Integer]: TmstProjectMPObject read GetItems write SetItems; default;
    property Owner: TmstProjectMP read FOwner;
  end;

  TmstProjectMP = class(TmstProject)
  private
    FDrawOrgId: Integer;
    FDrawDate: TDateTime;
    FName: string;
    FRequestNumber: string;
    FStatus: Integer;
    FObjects: TmstProjectObjects;
    FOwnerOrgId: Integer;
    procedure SetDrawOrgId(const Value: Integer);
    procedure SetDrawDate(const Value: TDateTime);
    procedure SetName(const Value: string);
    procedure SetRequestNumber(const Value: string);
    procedure SetStatus(const Value: Integer);
    procedure SetObjects(const Value: TmstProjectObjects);
    procedure SetOwnerOrgId(const Value: Integer);
  protected
    procedure AssignTo(Target: TPersistent); override;
    function GetObjectId: Integer; override;
    function GetText: String; override;
  public
    constructor Create; override;
    destructor Destroy; override;
    //
    function Edit(const aCanSave: Boolean): Boolean; override;
    procedure CalcExtent(); override;
    //
    property DrawDate: TDateTime read FDrawDate write SetDrawDate;
    property DrawOrgId: Integer read FDrawOrgId write SetDrawOrgId;
    property OwnerOrgId: Integer read FOwnerOrgId write SetOwnerOrgId;
    property Name: string read FName write SetName;
    property RequestNumber: string read FRequestNumber write SetRequestNumber;
    property Status: Integer read FStatus write SetStatus;
    //
    class function StatusName(const aStatus: Integer): string;
    //
    property Objects: TmstProjectObjects read FObjects write SetObjects;
  end;

  TmstMPProjectSaver = class(TInterfacedObject, IProjectSaver)
  private
    procedure SaveObj(Conn: IIBXConnection; aPrj: TmstProjectMP; aObj: TmstProjectMPObject;
      var aState: TSaveLineState);
  protected
    procedure Save(aDb: IDb; aProject: TmstProject);
  end;

implementation

uses
  uMStDialogEditProjectMP,
  uMStModuleApp;

const
  SQL_GEN_MP_ID = 'SELECT GEN_ID(MASTER_PLAN_GEN, 1) FROM RDB$DATABASE';
  SQL_CHECK_MP_EXISTS = 'SELECT ID FROM MASTER_PLAN WHERE ID=:ID';
  SQL_INSERT_MP =
      'INSERT INTO MASTER_PLAN ' +
      '( ID,  ADDRESS,  DOC_NUMBER,  DOC_DATE,  CUSTOMER_ORGS_ID,  EXECUTOR_ORGS_ID, ' +
      ' DRAW_ORGS_ID, DRAW_DATE, OWNER_ORG_ID, ' +
      ' MINX,  MINY,  MAXX,  MAXY,  CK36, ' +
      ' NAME,  REQUEST_NUMBER,  STATUS) ' +
      'VALUES ' +
      '(:ID, :ADDRESS, :DOC_NUMBER, :DOC_DATE, :CUSTOMER_ORGS_ID, :EXECUTOR_ORGS_ID, ' +
      ':DRAW_ORGS_ID,:DRAW_DATE,:OWNER_ORG_ID, ' +
      ':MINX, :MINY, :MAXX, :MAXY, :CK36, ' +
      ':NAME, :REQUEST_NUMBER, :STATUS) ';
  SQL_UPDATE_MP =
      'UPDATE MASTER_PLAN SET ' +
      '   ADDRESS = :ADDRESS, ' +
      '   DOC_NUMBER = :DOC_NUMBER, ' +
      '   DOC_DATE = :DOC_DATE, ' +
      '   STATUS = :STATUS, ' +
      '   CUSTOMER_ORGS_ID = :CUSTOMER_ORGS_ID, ' +
      '   EXECUTOR_ORGS_ID = :EXECUTOR_ORGS_ID, ' +
      '   DRAW_ORGS_ID = :DRAW_ORGS_ID, ' +
      '   DRAW_DATE = :DRAW_DATE, ' +
      '   OWNER_ORG_ID = :OWNER_ORG_ID, ' +
      '   MINX = :MINX, ' +
      '   MINY = :MINY, ' +
      '   MAXX = :MAXX, ' +
      '   MAXY = :MAXY, ' +
      '   CK36 = :CK36, ' +
      '   NAME = :NAME, ' +
      '   REQUEST_NUMBER = :REQUEST_NUMBER ' +
      'WHERE (ID = :ID)';
  SQL_MP_OBJECTS_GEN_ID = 'SELECT GEN_ID(MP_OBJECTS_GEN, 1) FROM RDB$DATABASE';
  SQL_CHECK_MP_LINE_EXISTS = 'SELECT ID FROM PROJECT_LINES WHERE ID=:ID';
  SQL_LINE_POINTS_GEN_ID = 'SELECT GEN_ID(PROJECT_LINE_POINTS_GEN, 1) FROM RDB$DATABASE';
  SQL_CHECK_LINE_POINT_EXISTS = 'SELECT ID FROM PROJECT_LINE_POINTS WHERE ID=:ID';
  SQL_INSERT_LINE =
      'insert into PROJECT_LINES (ID, PROJECTS_ID, INFO, DIAMETER, VOLTAGE, PROJECT_LAYERS_ID) ' +
      'values (:ID, :PROJECTS_ID, :INFO, :DIAMETER, :VOLTAGE, :PROJECT_LAYERS_ID)';
  SQL_UPDATE_LINE =
      'update PROJECT_LINES ' +
      'set PROJECTS_ID = :PROJECTS_ID, ' +
      '    INFO = :INFO, ' +
      '    DIAMETER = :DIAMETER, ' +
      '    VOLTAGE = :VOLTAGE, ' +
      '    PROJECT_LAYERS_ID = :PROJECT_LAYERS_ID ' +
      'where (ID = :ID)';
  SQL_INSERT_LINE_POINT =
      'insert into PROJECT_LINE_POINTS (ID, PROJECT_LINES_ID, X, Y, Z) ' +
      'values (:ID, :PROJECT_LINES_ID, :X, :Y, :Z)';
  SQL_UPDATE_LINE_POINT =
      'update PROJECT_LINE_POINTS ' +
      'set PROJECT_LINES_ID = :PROJECT_LINES_ID, ' +
      '    X = :X, ' +
      '    Y = :Y, ' +
      '    Z = :Z ' +
      'where (ID = :ID)';
  SQL_PRJ_PLACES_GEN_ID = 'SELECT GEN_ID(PROJECT_PLACES_GEN, 1) FROM RDB$DATABASE';
  SQL_CHECK_MP_OBJECT_EXISTS = 'SELECT ID FROM MASTER_PLAN_OBJECTS WHERE ID=:ID';
  SQL_INSERT_MP_OBJECT =
      'INSERT INTO MASTER_PLAN_OBJECTS (' +
      '  ID,              MASTER_PLAN_ID, MASTER_PLAN_CLASS_ID, STATUS,     DISMANTLED, ' +
      '  ARCHIVED,        CONFIRMED,      ADDRESS,              DOC_NUMBER, DOC_DATE, ' +
      '  REQUEST_NUMBER,  REQUEST_DATE,   UNDERGROUND,          DIAMETER,   PIPE_COUNT, ' +
      '  VOLTAGE,         MATERIAL,       TOP,                  BOTTOM,     FLOOR, ' +
      '  OWNER,           DRAW_DATE,      IS_LINE,              ROTATION,   EZDATA, ' +
      '  EZ_ID,           MINX,           MINY,                 MAXX,       MAXY) ' +
      'VALUES (' +
      ' :ID,             :MASTER_PLAN_ID,:MASTER_PLAN_CLASS_ID,:STATUS,    :DISMANTLED, ' +
      ' :ARCHIVED,       :CONFIRMED,     :ADDRESS,             :DOC_NUMBER,:DOC_DATE, ' +
      ' :REQUEST_NUMBER, :REQUEST_DATE,  :UNDERGROUND,         :DIAMETER,  :PIPE_COUNT, ' +
      ' :VOLTAGE,        :MATERIAL,      :TOP,                 :BOTTOM,    :FLOOR, ' +
      ' :OWNER,          :DRAW_DATE,     :IS_LINE,             :ROTATION,  :EZDATA, ' +
      ' :EZ_ID,          :MINX,          :MINY,                :MAXX,      :MAXY)';
  SQL_UPDATE_MP_OBJECT =
      'UPDATE MASTER_PLAN_OBJECTS ' +
      'SET MASTER_PLAN_ID = :MASTER_PLAN_ID, ' +
      '   MASTER_PLAN_CLASS_ID = :MASTER_PLAN_CLASS_ID, ' +
      '   STATUS = :STATUS, ' +
      '   DISMANTLED = :DISMANTLED, ' +
      '   ARCHIVED = :ARCHIVED, ' +
      '   CONFIRMED = :CONFIRMED, ' +
      '   ADDRESS = :ADDRESS, ' +
      '   DOC_NUMBER = :DOC_NUMBER, ' +
      '   DOC_DATE = :DOC_DATE, ' +
      '   REQUEST_NUMBER = :REQUEST_NUMBER, ' +
      '   REQUEST_DATE = :REQUEST_DATE, ' +
      '   UNDERGROUND = :UNDERGROUND, ' +
      '   DIAMETER = :DIAMETER, ' +
      '   PIPE_COUNT = :PIPE_COUNT, ' +
      '   VOLTAGE = :VOLTAGE, ' +
      '   MATERIAL = :MATERIAL, ' +
      '   TOP = :TOP, ' +
      '   BOTTOM = :BOTTOM, ' +
      '   FLOOR = :FLOOR, ' +
      '   OWNER = :OWNER, ' +
      '   DRAW_DATE = :DRAW_DATE, ' +
      '   IS_LINE = :IS_LINE, ' +
      '   ROTATION = :ROTATION, ' +
      '   EZDATA = :EZDATA, ' +
      '   EZ_ID = :EZ_ID, ' +
      '   MINX = :MINX, ' +
      '   MINY = :MINY, ' +
      '   MAXX = :MAXX, ' +
      '   MAXY = :MAXY ' +
      'WHERE (ID = :ID)';
  SQL_LOAD_PROJECT = 'SELECT * FROM PROJECTS WHERE ID=:ID';
  SQL_LOAD_LAYERS_FOR_LINES =
                    'SELECT DISTINCT(LAYERS.*) ' +
                    'FROM PROJECT_LINES LINES LEFT JOIN PROJECT_LAYERS LAYERS ON (LINES.PROJECT_LAYERS_ID = LAYERS.ID) ' +
                    'WHERE ' +
                    '    LINES.PROJECTS_ID=:ID';
  SQL_LOAD_LAYERS_FOR_PLACES =
                    'SELECT DISTINCT(LAYERS.*) ' +
                    'FROM PROJECT_PLACES PLACES LEFT JOIN PROJECT_LAYERS LAYERS ON (PLACES.PROJECT_LAYERS_ID = LAYERS.ID) ' +
                    'WHERE ' +
                    '    PLACES.PROJECTS_ID=:ID';
  SQL_PROJECT_LAYERS_ALL =
                    'SELECT * FROM PROJECT_LAYERS ORDER BY ID';

  SQL_LOAD_LINES =
                    'SELECT PP.*, PL.INFO, PL.DIAMETER, PL.VOLTAGE, PL.PROJECT_LAYERS_ID ' +
                    'FROM PROJECT_LINE_POINTS PP LEFT JOIN PROJECT_LINES PL ON (PP.PROJECT_LINES_ID = PL.ID) ' +
                    'WHERE PL.PROJECTS_ID=:ID ' +
                    'ORDER BY PP.PROJECT_LINES_ID, PP.ID';
  SQL_LOAD_PROJECT_NET_TYPES =
                    'SELECT * FROM PROJECT_NET_TYPES ORDER BY ID';
  SQL_LOAD_PLACES = 'SELECT * FROM PROJECT_PLACES WHERE PROJECTS_ID=:ID';

{ TmstMPProjectSaver }

procedure TmstMPProjectSaver.Save(aDb: IDb; aProject: TmstProject);
var
  Conn: IIBXConnection;
  Ds1, Ds2, DsMain: TDataSet;
  B1, B2: Boolean;
  Sql: string;
  I: Integer;
  SaveObjState: TSaveLineState;
  Obj: TmstProjectMPObject;
  Prj: TmstProjectMP;
begin
  Prj := aProject as TmstProjectMP;
  // создаём соединение
  Conn := aDb.GetConnection(cmReadWrite, dmKis);
  try
    B1 := Prj.DatabaseId < 1;
    if B1 then
    begin
      Ds1 := Conn.GetDataSet(SQL_GEN_MP_ID);
      Ds1.Open;
      Prj.DatabaseId := Ds1.Fields[0].AsInteger;
      Ds1.Close;
      B2 := True;
    end
    else
    begin
      Ds2 := Conn.GetDataSet(SQL_CHECK_MP_EXISTS);
      Conn.SetParam(Ds2, SF_ID, Prj.DatabaseId);
      Ds2.Open;
      B2 := Ds2.IsEmpty;
      Ds2.Close;
    end;
    if B2 then
      Sql := SQL_INSERT_MP
    else
      Sql := SQL_UPDATE_MP;
    //
    DsMain := Conn.GetDataSet(Sql);
    //  
    Conn.SetParam(DsMain, SF_ID, Prj.DatabaseId); // '(:ID
    Conn.SetParam(DsMain, SF_ADDRESS, Prj.Address); // :ADDRESS
    Conn.SetParam(DsMain, SF_DOC_NUMBER, Prj.DocNumber); // :DOC_NUMBER
    if Prj.DocDate <> 0 then
      Conn.SetParam(DsMain, SF_DOC_DATE, Prj.DocDate); // :DOC_DATE
    Conn.SetNullableParam(DsMain, SF_CUSTOMER_ORGS_ID, Prj.CustomerOrgId, 0); // :CUSTOMER_ORGS_ID
    Conn.SetNullableParam(DsMain, SF_EXECUTOR_ORGS_ID, Prj.ExecutorOrgId, 0); // :EXECUTOR_ORGS_ID
    Conn.SetNullableParam(DsMain, SF_DRAW_ORGS_ID, Prj.DrawOrgId, 0); // :DRAW_ORGS_ID
    Conn.SetNullableParam(DsMain, SF_OWNER_ORG_ID, Prj.OwnerOrgId, 0); // :OWNER_ORG_ID
    if Prj.DrawDate <> 0 then
      Conn.SetParam(DsMain, SF_DRAW_DATE, Prj.DrawDate); // :DRAW_DATE
    aProject.CalcExtent();
    Conn.SetParam(DsMain, SF_MINX, Prj.MinX);
    Conn.SetParam(DsMain, SF_MINY, Prj.MinY);
    Conn.SetParam(DsMain, SF_MAXX, Prj.MaxX);
    Conn.SetParam(DsMain, SF_MAXY, Prj.MaxY);
    Conn.SetParam(DsMain, SF_CK36, IfThen(Prj.Ck36, 1, 0));
    Conn.SetParam(DsMain, SF_NAME, Prj.Name); // :NAME
    Conn.SetParam(DsMain, SF_REQUEST_NUMBER, Prj.RequestNumber); // :REQUEST_NUMBER
    Conn.SetParam(DsMain, SF_STATUS, Prj.Status); // :STATUS
    Conn.ExecDataSet(DsMain);
    //
    SaveObjState.Ds1 := nil;
    SaveObjState.Ds2 := nil;
    SaveObjState.DsMain1 := nil;
    SaveObjState.DsMain2 := nil;
    SaveObjState.PtDs1 := nil;
    SaveObjState.PtDs2 := nil;
    SaveObjState.PtDsMain1 := nil;
    SaveObjState.PtDsMain2 := nil;
    for I := 0 to Prj.Objects.Count - 1 do
    begin
      Obj := Prj.Objects[I];
      SaveObj(Conn, Prj, Obj, SaveObjState);
    end;
    //
    Conn.Commit();
  except
    Conn.Rollback();
    raise;
  end;
end;

procedure TmstMPProjectSaver.SaveObj(Conn: IIBXConnection; aPrj: TmstProjectMP; aObj: TmstProjectMPObject;
  var aState: TSaveLineState);
var
  B2: Boolean;
  Ds1, Ds2, DsMain: TDataSet;
//  LayerId: Integer;
begin
  if aObj.DatabaseId < 1 then
  begin
    if aState.Ds1 = nil then
    begin
      aState.Ds1 := Conn.GetDataSet(SQL_MP_OBJECTS_GEN_ID);
    end;
    Ds1 := aState.Ds1;
    Ds1.Open;
    aObj.DatabaseId := Ds1.Fields[0].AsInteger;
    Ds1.Close;
    B2 := True;
  end
  else
  begin
    if aState.Ds2 = nil then
      aState.Ds2 := Conn.GetDataSet(SQL_CHECK_MP_OBJECT_EXISTS);
    Ds2 := aState.Ds2;
    Conn.SetParam(Ds2, SF_ID, aObj.DatabaseId);
    Ds2.Open;
    B2 := Ds2.Fields[0].AsInteger = 0;
    Ds2.Close;
  end;
  //
  if B2 then
  begin
    if aState.DsMain1 = nil then
      aState.DsMain1 := Conn.GetDataSet(SQL_INSERT_MP_OBJECT);  // !!!
    DsMain := aState.DsMain1;
  end
  else
  begin
    if aState.DsMain2 = nil then
      aState.DsMain2 := Conn.GetDataSet(SQL_UPDATE_MP_OBJECT);  // !!!
    DsMain := aState.DsMain2;
  end;
  // 
  Conn.SetParam(DsMain, SF_ID, aObj.DatabaseId);
  Conn.SetParam(DsMain, SF_MASTER_PLAN_ID, aPrj.DatabaseId);
  Conn.SetParam(DsMain, SF_MASTER_PLAN_CLASS_ID, aObj.ClassId);
  Conn.SetParam(DsMain, SF_STATUS, aObj.Status);
  Conn.SetParam(DsMain, SF_DISMANTLED, IfThen(aObj.Dismantled, 1, 0));
  Conn.SetParam(DsMain, SF_ARCHIVED, IfThen(aObj.Archived, 1, 0));
  Conn.SetParam(DsMain, SF_CONFIRMED, IfThen(aObj.Confirmed, 1, 0));
  Conn.SetParam(DsMain, SF_ADDRESS, aObj.Address);
  Conn.SetParam(DsMain, SF_DOC_NUMBER, aObj.DocNumber);
  Conn.SetParam(DsMain, SF_DOC_DATE, aObj.DocDate);
  Conn.SetParam(DsMain, SF_REQUEST_NUMBER, aObj.RequestNumber);
  Conn.SetParam(DsMain, SF_REQUEST_DATE, aObj.RequestDate);
  Conn.SetParam(DsMain, SF_UNDERGROUND, IfThen(aObj.Underground, 1, 0));
  Conn.SetParam(DsMain, SF_DIAMETER, aObj.Diameter);
  Conn.SetParam(DsMain, SF_PIPE_COUNT, aObj.PipeCount);
  Conn.SetParam(DsMain, SF_VOLTAGE, aObj.Voltage);
  Conn.SetParam(DsMain, SF_MATERIAL, aObj.Material);
  Conn.SetParam(DsMain, SF_TOP, aObj.Top);
  Conn.SetParam(DsMain, SF_BOTTOM, aObj.Bottom);
  Conn.SetParam(DsMain, SF_FLOOR, aObj.Floor);
  Conn.SetParam(DsMain, SF_OWNER, aObj.Owner);
  Conn.SetParam(DsMain, SF_DRAW_DATE, aObj.DrawDate);
  Conn.SetParam(DsMain, SF_IS_LINE, IfThen(aObj.IsLine, 1, 0));
  Conn.SetParam(DsMain, SF_ROTATION, aObj.Rotation);
  Conn.SetBlobParam(DsMain, SF_EZDATA, aObj.EzData);
  Conn.SetParam(DsMain, SF_EZ_ID, aObj.EzId);
  Conn.SetParam(DsMain, SF_MINX, aObj.MinX);
  Conn.SetParam(DsMain, SF_MINY, aObj.MinY);
  Conn.SetParam(DsMain, SF_MAXX, aObj.MaxX);
  Conn.SetParam(DsMain, SF_MAXY, aObj.MaxY);
//  if Assigned(aObj.Layer) then
//    LayerId := aObj.Layer.DatabaseId
//  else
//    LayerId := -1;
//  Conn.SetParam(DsMain, SF_PROJECT_LAYERS_ID, LayerId);
  Conn.ExecDataSet(DsMain);
end;

{ TmstProjectMP }

procedure TmstProjectMP.AssignTo(Target: TPersistent);
var
  Tgt: TmstProjectMP;
begin
  inherited;
  if Target is TmstProjectMP then
  begin
    Tgt := TmstProjectMP(Target);
    //
    Tgt.FOwnerOrgId := Self.FOwnerOrgId;
    Tgt.FDrawOrgId := Self.FDrawOrgId;
    Tgt.FDrawDate := Self.FDrawDate;
    Tgt.FName := Self.FName;
    Tgt.FRequestNumber := Self.FRequestNumber;
    Tgt.FStatus := Self.FStatus;
    //
    Tgt.FObjects.CopyFrom(Self.Objects);
  end;
end;

procedure TmstProjectMP.CalcExtent;
var
  I: Integer;
  Obj: TmstProjectMPObject;
begin
  inherited;
  if (MinX = 0) and (MinY = 0) and (MaxX = 0) and (MaxY = 0) then
  begin
    MinX := MaxInt;
    MinY := MaxInt;
    MaxX := 1 - MaxInt;
    MaxY := 1 - MaxInt;
  end;
  for I := 0 to Self.Objects.Count - 1 do
  begin
    Obj := Self.Objects[I];
    if MaxX < Obj.MaxX then
     MaxX := Obj.MaxX;
    if MinX > Obj.MinX then
     MinX := Obj.MinX;
    if MaxY < Obj.MaxY then
     MaxY := Obj.MaxY;
    if MinY > Obj.MinY then
     MinY := Obj.MinY;
  end;
  if (MinX = MaxInt) or (MinY = MaxInt) or (MaxX = 1 - MaxInt) or (MaxY = 1 - MaxInt) then
  begin
    MinX := 0;
    MaxX := 0;
    MinY := 0;
    MaxY := 0;
  end;
end;

constructor TmstProjectMP.Create;
begin
  inherited;
  FObjects := TmstProjectObjects.Create(Self);
end;

destructor TmstProjectMP.Destroy;
begin
  FObjects.Free;
  inherited;
end;

function TmstProjectMP.Edit(const aCanSave: Boolean): Boolean;
var
  Frm: TmstEditProjectMPDialog;
begin
  Frm := TmstEditProjectMPDialog.Create(Application);
  try
    if Self.Caption <> '' then
      Frm.Caption := Self.Caption
    else
      Frm.Caption := Self.Address;
    Frm.CanSave := aCanSave;
    Result := Frm.Execute(Self);
  finally
    Frm.Free;
  end;
end;

function TmstProjectMP.GetObjectId: Integer;
begin
  Result := ID_PROJECT_MP;
end;

function TmstProjectMP.GetText: String;
begin
  Result := 'Проект';
  if DocNumber <> '' then
    Result := Result + ' №' + DocNumber;
  if DocDate > 0 then
    Result := Result + ' от ' + DateToStr(DocDate);
  Result := Result + ' ; ' + Address;
end;

procedure TmstProjectMP.SetDrawDate(const Value: TDateTime);
begin
  FDrawDate := Value;
end;

procedure TmstProjectMP.SetDrawOrgId(const Value: Integer);
begin
  FDrawOrgId := Value;
end;

procedure TmstProjectMP.SetName(const Value: string);
begin
  FName := Value;
end;

procedure TmstProjectMP.SetObjects(const Value: TmstProjectObjects);
begin
  FObjects := Value;
end;

procedure TmstProjectMP.SetOwnerOrgId(const Value: Integer);
begin
  FOwnerOrgId := Value;
end;

procedure TmstProjectMP.SetRequestNumber(const Value: string);
begin
  FRequestNumber := Value;
end;

procedure TmstProjectMP.SetStatus(const Value: Integer);
begin
  FStatus := Value;
end;

class function TmstProjectMP.StatusName(const aStatus: Integer): string;
begin
  case aStatus of
  1 : Result := 'проектные';
  2 : Result := 'проектные демонтируемые объекты';
  3 : Result := 'проектные выдана справка';
  4 : Result := 'нанесенные';
  else
      Result := 'ошибка';
  end;
end;

{ TmstProjectMPObject }

procedure TmstProjectMPObject.AssignTo(Target: TPersistent);
var
  Tgt: TmstProjectMPObject;
begin
  if not (Target is TmstProjectMPObject) then
    inherited;
  if Target is TmstProjectMPObject then
  begin
    Tgt := TmstProjectMPObject(Target);
    //
    Tgt.FGuid := FGuid;
    Tgt.FClassId := FClassId;
    Tgt.FArchived := FArchived;
    Tgt.FDocNumber := FDocNumber;
    Tgt.FStatus := FStatus;
    Tgt.FConfirmed := FConfirmed;
    Tgt.FDismantled := FDismantled;
    Tgt.FAddress := FAddress;
    Tgt.FDocDate := FDocDate;
    Tgt.FRequestDate := FRequestDate;
    Tgt.FMaterial := FMaterial;
    Tgt.FVoltage := FVoltage;
    Tgt.FUnderground := FUnderground;
    Tgt.FPipeCount := FPipeCount;
    Tgt.FFloor := FFloor;
    Tgt.FDiameter := FDiameter;
    Tgt.FBottom := FBottom;
    Tgt.FRequestNumber := FRequestNumber;
    Tgt.FTop := FTop;
    Tgt.FOwner := FOwner;
    Tgt.FDrawDate := FDrawDate;
    Tgt.FIsLine := FIsLine;
    Tgt.FRotation := FRotation;
    Tgt.FMaxX := FMaxX;
    Tgt.FMaxY := FMaxY;
    Tgt.FMinX := FMinX;
    Tgt.FMinY := FMinY;
    Tgt.FEntityId := Self.FEntityId;
    //
    Tgt.FEzData.Size := 0;
    Self.FEzData.Position := 0;
    Tgt.FEzData.CopyFrom(Self.FEzData, Self.FEzData.Size);
    Tgt.FEzData.Position := 0;
    Self.FEzData.Position := 0;
    Tgt.FEzId := Self.FEzId;
    //
    if Assigned(Self.FLayer) then
      Tgt.FLayer := Tgt.Project.Layers.ByDbId(Self.Layer.DatabaseId)
    else
      Tgt.FLayer := nil;
    //
    Tgt.DatabaseId := Self.DatabaseId;
  end;
end;

constructor TmstProjectMPObject.Create;
begin
  inherited;
  FEzData := TMemoryStream.Create;
  FEzId := -1;
  FGuid := GetUniqueString();
end;

destructor TmstProjectMPObject.Destroy;
begin
  FreeAndNil(FEzData);
  inherited;
end;

function TmstProjectMPObject.GetObjectId: Integer;
begin
  Result := inherited GetObjectId();
end;

function TmstProjectMPObject.GetText: String;
begin
  Result := '';
end;

procedure TmstProjectMPObject.SetAddress(const Value: string);
begin
  FAddress := Value;
end;

procedure TmstProjectMPObject.SetArchived(const Value: Boolean);
begin
  FArchived := Value;
end;

procedure TmstProjectMPObject.SetBottom(const Value: string);
begin
  FBottom := Value;
end;

procedure TmstProjectMPObject.SetClassId(const Value: Integer);
begin
  FClassId := Value;
end;

procedure TmstProjectMPObject.SetConfirmed(const Value: Boolean);
begin
  FConfirmed := Value;
end;

procedure TmstProjectMPObject.SetDiameter(const Value: Integer);
begin
  FDiameter := Value;
end;

procedure TmstProjectMPObject.SetDismantled(const Value: Boolean);
begin
  FDismantled := Value;
end;

procedure TmstProjectMPObject.SetDocDate(const Value: TDateTime);
begin
  FDocDate := Value;
end;

procedure TmstProjectMPObject.SetDocNumber(const Value: string);
begin
  FDocNumber := Value;
end;

procedure TmstProjectMPObject.SetDrawDate(const Value: TDateTime);
begin
  FDrawDate := Value;
end;

procedure TmstProjectMPObject.SetEntityId(const Value: Integer);
begin
  FEntityId := Value;
end;

procedure TmstProjectMPObject.SetEzId(const Value: Integer);
begin
  FEzId := Value;
end;

procedure TmstProjectMPObject.SetFloor(const Value: string);
begin
  FFloor := Value;
end;

procedure TmstProjectMPObject.SetIsLine(const Value: Boolean);
begin
  FIsLine := Value;
end;

procedure TmstProjectMPObject.SetMaterial(const Value: string);
begin
  FMaterial := Value;
end;

procedure TmstProjectMPObject.SetMaxX(const Value: Double);
begin
  FMaxX := Value;
end;

procedure TmstProjectMPObject.SetMaxY(const Value: Double);
begin
  FMaxY := Value;
end;

procedure TmstProjectMPObject.SetMinX(const Value: Double);
begin
  FMinX := Value;
end;

procedure TmstProjectMPObject.SetMinY(const Value: Double);
begin
  FMinY := Value;
end;

procedure TmstProjectMPObject.SetOwner(const Value: string);
begin
  FOwner := Value;
end;

procedure TmstProjectMPObject.SetPipeCount(const Value: Integer);
begin
  FPipeCount := Value;
end;

procedure TmstProjectMPObject.SetRequestDate(const Value: TDateTime);
begin
  FRequestDate := Value;
end;

procedure TmstProjectMPObject.SetRequestNumber(const Value: string);
begin
  FRequestNumber := Value;
end;

procedure TmstProjectMPObject.SetRotation(const Value: Integer);
begin
  FRotation := Value;
end;

procedure TmstProjectMPObject.SetStatus(const Value: Integer);
begin
  FStatus := Value;
end;

procedure TmstProjectMPObject.SetTop(const Value: string);
begin
  FTop := Value;
end;

procedure TmstProjectMPObject.SetUnderground(const Value: Boolean);
begin
  FUnderground := Value;
end;

procedure TmstProjectMPObject.SetVoltage(const Value: Integer);
begin
  FVoltage := Value;
end;

{ TmstProjectObjects }

function TmstProjectObjects.Add: TmstProjectMPObject;
begin
  Result := TmstProjectMPObject.Create;
  inherited Add(Result);
  Result.FProject := FOwner;
end;

procedure TmstProjectObjects.CopyFrom(Source: TmstProjectObjects);
var
  Src, Tgt: TmstProjectMPObject;
  I: Integer;
begin
  Clear();
  for I := 0 to Source.Count - 1 do
  begin
    Src := Source[I];
    Tgt := Self.Add();
    Tgt.Assign(Src);
  end;
end;

constructor TmstProjectObjects.Create(aOwner: TmstProjectMP);
begin
  inherited Create;
  FOwner := aOwner;
end;

procedure TmstProjectObjects.DeleteObj(const DbId: Integer);
var
  I: Integer;
begin
  for I := 0 to Count - 1 do
    if Items[I].DatabaseId = DbId then
    begin
      Delete(I);
      Exit;
    end;
end;

function TmstProjectObjects.GetByGuid(const aGuid: string): TmstProjectMPObject;
var
  I: Integer;
begin
  for I := 0 to Count - 1 do
    if Items[I].Guid = aGuid then
    begin
      Result := Items[i];
      Exit;
    end;
  Result := nil;
end;

function TmstProjectObjects.GetItems(Index: Integer): TmstProjectMPObject;
begin
  Result := TmstProjectMPObject(inherited Items[Index]);
end;

procedure TmstProjectObjects.SetItems(Index: Integer; const Value: TmstProjectMPObject);
begin
  inherited Items[Index] := Value;
end;

initialization
//  TProjectsSettings.PenWidth := 2;

end.
