unit uMStClassesProjectsMP;

interface

uses
  SysUtils, Classes, Contnrs, Forms, DB, Math, Graphics, Dialogs,
  EzLib, EzBaseGIS, EzEntities, EzBase,
  uCommonUtils, uCK36, uGC, uEzEntityCSConvert,
  uEzBufferZone,
  uMStKernelClasses, uMStKernelIBX, uMStConsts, uMStClassesProjects;

type
  TmstProjectMP = class;

  TmstMPObjectState = (
    mstProjected, // проектируемые объекты
    mstDrawn      // нанесённые
  );

  TmstMPObjectCheckState = (
    ocsNone = 0, // неизвестно
    ocsChecked = 1, // проверен
    ocsImported = 2, // нужно проверить после импорта
    ocsEdited = 3 // нужно проверить после редактирования
  );

  TmstMPObject = class(TmstObject)
  private
    FClassId: Integer;
    FArchived: Boolean;
    FDocNumber: string;
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
    FEzLayerRecno: Integer;
    FGuid: string;
    FEzLayerName: string;
    FObjState: TmstMPObjectState;
    FCheckState: TmstMPObjectCheckState;
    FCK36: Boolean;
    FExchangeXY: Boolean;
    FMPLayerId: Integer;
    FProjectName: string;
    FDrawOrgId: Integer;
    FCustomerOrgId: Integer;
    FExecutorOrgId: Integer;
    FOwnerOrgId: Integer;
    FDrawn: Boolean;
    FProjected: Boolean;
    FCertifNumber: string;
    FCertifDate: TDateTime;
    FHasCertif: Boolean;
    FMPObjectGuid: string;
    FLinkedObjectGuid: string;
    FClassGuid: string;
    FMpClassName: string;
    FDrawOrg: string;
    FCustomerOrg: string;
    FExecutorOrg: string;
    FTempPoints: TEzVector;
    FTempLayer: string;
    FTempLayerId: Integer;
    FTempCategoryId: Integer;
    FTempСaеtegory: string;
    procedure SetClassId(const Value: Integer);
    procedure SetAddress(const Value: string);
    procedure SetArchived(const Value: Boolean);
    procedure SetConfirmed(const Value: Boolean);
    procedure SetDismantled(const Value: Boolean);
    procedure SetDocNumber(const Value: string);
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
    procedure SetEzLayerRecno(const Value: Integer);
    procedure SetEzLayerName(const Value: string);
    procedure SetObjState(const Value: TmstMPObjectState);
    procedure SetCheckState(const Value: TmstMPObjectCheckState);
    procedure SetCK36(const Value: Boolean);
    procedure SetExchangeXY(const Value: Boolean);
    procedure SetMPLayerId(const Value: Integer);
    procedure SetProjectName(const Value: string);
    procedure SetCustomerOrgId(const Value: Integer);
    procedure SetDrawOrgId(const Value: Integer);
    procedure SetExecutorOrgId(const Value: Integer);
    procedure SetOwnerOrgId(const Value: Integer);
    procedure SetDrawn(const Value: Boolean);
    procedure SetProjected(const Value: Boolean);
    procedure SetCertifDate(const Value: TDateTime);
    procedure SetCertifNumber(const Value: string);
    procedure SetHasCertif(const Value: Boolean);
    procedure SetMPObjectGuid(const Value: string);
    procedure SetLinkedObjectGuid(const Value: string);
    procedure SetClassGuid(const Value: string);
    procedure SetCustomerOrg(const Value: string);
    procedure SetDrawOrg(const Value: string);
    procedure SetExecutorOrg(const Value: string);
    procedure SetMpClassName(const Value: string);
    procedure SetTempLayer(const Value: string);
    procedure SetTempLayerId(const Value: Integer);
    procedure SetTempCategoryId(const Value: Integer);
    procedure SetTempСaеtegory(const Value: string);
  protected
    function GetObjectId: Integer; override;
    function GetText: String; override;
    procedure AssignTo(Target: TPersistent); override;
  public
    constructor Create; override;
    destructor Destroy; override;
    //
    function Status(): Integer;
    procedure UpdateObjState();
    //
    property InstanceGuid: string read FGuid;
    // это униальный ID объекта, который можно использовать при привязке нанесённых к проектируемым 
    property MPObjectGuid: string read FMPObjectGuid write SetMPObjectGuid;
    // ID объекта, который привязан к текущему  
    property LinkedObjectGuid: string read FLinkedObjectGuid write SetLinkedObjectGuid;
    //
    property Address: string read FAddress write SetAddress;
    property Archived: Boolean read FArchived write SetArchived;
    property Bottom: string read FBottom write SetBottom;
    property MpClassId: Integer read FClassId write SetClassId;
    // для экспорта
    property MpClassGuid: string read FClassGuid write SetClassGuid;
    // для экспорта
    property MpClassName: string read FMpClassName write SetMpClassName;
    //
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
    property Top: string read FTop write SetTop;
    property Underground: Boolean read FUnderground write SetUnderground;
    property Voltage: Integer read FVoltage write SetVoltage;
    // импорт
    property ProjectName: string read FProjectName write SetProjectName;
    property CK36: Boolean read FCK36 write SetCK36;
    property ExchangeXY: Boolean read FExchangeXY write SetExchangeXY;
    property MPLayerId: Integer read FMPLayerId write SetMPLayerId;
    property CustomerOrgId: Integer read FCustomerOrgId write SetCustomerOrgId;
    // для экспорта
    property CustomerOrg: string read FCustomerOrg write SetCustomerOrg;
    property ExecutorOrgId: Integer read FExecutorOrgId write SetExecutorOrgId;
    // для экспорта
    property ExecutorOrg: string read FExecutorOrg write SetExecutorOrg;
    property OwnerOrgId: Integer read FOwnerOrgId write SetOwnerOrgId;
    property DrawOrgId: Integer read FDrawOrgId write SetDrawOrgId;
    // для экспорта
    property DrawOrg: string read FDrawOrg write SetDrawOrg;
    // используются местная СК: Х - вверх, Y - вправо (геодезические кооринаты)
    property MinX: Double read FMinX write SetMinX;
    // используются местная СК: Х - вверх, Y - вправо (геодезические кооринаты)
    property MinY: Double read FMinY write SetMinY;
    // используются местная СК: Х - вверх, Y - вправо (геодезические кооринаты)
    property MaxX: Double read FMaxX write SetMaxX;
    // используются местная СК: Х - вверх, Y - вправо (геодезические кооринаты)
    property MaxY: Double read FMaxY write SetMaxY;
    //
    property CheckState: TmstMPObjectCheckState read FCheckState write SetCheckState;
    property ObjState: TmstMPObjectState read FObjState write SetObjState;
    // нанесён
    property Drawn: Boolean read FDrawn write SetDrawn;
    // проектируемый
    property Projected: Boolean read FProjected write SetProjected;
    // справка выдана
    property HasCertif: Boolean read FHasCertif write SetHasCertif;
    // номер справки
    property CertifNumber: string read FCertifNumber write SetCertifNumber;
    // дата справки
    property CertifDate: TDateTime read FCertifDate write SetCertifDate;
    //
    property EzData: TStream read FEzData;
    property EzId: Integer read FEzId write SetEzId;
    property EzLayerRecno: Integer read FEzLayerRecno write SetEzLayerRecno;
    property EzLayerName: string read FEzLayerName write SetEzLayerName;
    //
    property TempPoints: TEzVector read FTempPoints;
    property TempСategory: string read FTempСaеtegory write SetTempСaеtegory;
  end;

  TmstProjectObjects = class(TObjectList)
  private
    FOwner: TmstProjectMP;
    function GetItems(Index: Integer): TmstMPObject;
    procedure SetItems(Index: Integer; const Value: TmstMPObject);
  public
    constructor Create(aOwner: TmstProjectMP);
    function Add(): TmstMPObject;
    procedure CopyFrom(Source: TmstProjectObjects);
    procedure DeleteObj(const DbId: Integer);
    function GetByGuid(const aGuid: string): TmstMPObject;
    function GetByDbId(const aId: Integer): TmstMPObject;
    //
    property Items[Index: Integer]: TmstMPObject read GetItems write SetItems; default;
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
    FObjState: TmstMPObjectState;
    FCheckState: TmstMPObjectCheckState;
    FRequestDate: TDateTime;
    procedure SetDrawOrgId(const Value: Integer);
    procedure SetDrawDate(const Value: TDateTime);
    procedure SetName(const Value: string);
    procedure SetRequestNumber(const Value: string);
    procedure SetStatus(const Value: Integer);
    procedure SetObjects(const Value: TmstProjectObjects);
    procedure SetOwnerOrgId(const Value: Integer);
    procedure SetObjState(const Value: TmstMPObjectState);
    procedure SetCheckState(const Value: TmstMPObjectCheckState);
    procedure SetRequestDate(const Value: TDateTime);
  protected
    procedure AssignTo(Target: TPersistent); override;
    function GetObjectId: Integer; override;
    function GetText: String; override;
    procedure RefreshExchangeXY(); override;
  public
    constructor Create; override;
    destructor Destroy; override;
    //
    function Edit(const aCanSave: Boolean): Boolean; override;
    procedure CalcExtent(); override;
    function IsMP(): Boolean; override;
    //
    property DrawDate: TDateTime read FDrawDate write SetDrawDate;
    property DrawOrgId: Integer read FDrawOrgId write SetDrawOrgId;
    property OwnerOrgId: Integer read FOwnerOrgId write SetOwnerOrgId;
    property Name: string read FName write SetName;
    property RequestNumber: string read FRequestNumber write SetRequestNumber;
    property RequestDate: TDateTime read FRequestDate write SetRequestDate;
    property Status: Integer read FStatus write SetStatus;
    //
    property CheckState: TmstMPObjectCheckState read FCheckState write SetCheckState;
    property ObjState: TmstMPObjectState read FObjState write SetObjState;
    //
    property Objects: TmstProjectObjects read FObjects write SetObjects;
  end;

  TmstMPProjectSaver = class(TInterfacedObject, IProjectSaver)
  private
    FTableVersion: Integer;
    function GetEntityStream(aObj: TmstMPObject; CK36: Boolean): TStream;
    procedure SaveObj(Conn: IIBXConnection; aObj: TmstMPObject; var aState: TSaveLineState);
  protected
    procedure Save(aDb: IDb; aProject: TmstProject);
  end;

  TmstMPObjectSaver = class(TInterfacedObject, ImstObjectSaver)
  private
    FTableVersion: Integer;
    procedure SaveObj(Conn: IIBXConnection; aObj: TmstMPObject);
    function GetEntityStream(aObj: TmstMPObject; CK36: Boolean): TStream;
  protected
    procedure Save(aDb: IDb; MPObject: TmstObject);
  end;

implementation

uses
  uMStDialogEditProjectMP,
  uMStModuleApp;

const
  SQL_CHECK_MP_OBJECT_EXISTS = 'SELECT ID FROM MASTER_PLAN_OBJECTS WHERE ID=:ID';
  SQL_INSERT_MP_OBJECT =
      'INSERT INTO MASTER_PLAN_OBJECTS (' +
      '  ID,              OBJ_ID,         MASTER_PLAN_CLASS_ID, ' +
      '  LINKED_OBJ_ID, ' +
      '  STATUS,     DISMANTLED, ' +
      '  ARCHIVED,        CONFIRMED,      ADDRESS,              DOC_NUMBER, DOC_DATE, ' +
      '  REQUEST_NUMBER,  REQUEST_DATE,   UNDERGROUND,          DIAMETER,   PIPE_COUNT, ' +
      '  VOLTAGE,         MATERIAL,       TOP,                  BOTTOM,     FLOOR, ' +
      '  PROJECTED,       CHECK_STATE,    LOADED,               PROJECT_NAME, ' +
      '  OWNER,           DRAW_DATE,      IS_LINE,              ROTATION,   EZDATA, ' +
      '  CUSTOMER_ORGS_ID, ' +
      '  EXECUTOR_ORGS_ID, ' +
      '  OWNER_ORG_ID,    DRAW_ORGS_ID,   DELETED,              TABLE_VERSION, ' +
      '  DRAWN,           HAS_CERTIF,     CERTIF_NUMBER,        CERTIF_DATE, ' +
      '  EZ_ID,           MINX,           MINY,                 MAXX,       MAXY) ' +
      'VALUES (' +
      ' :ID,             :OBJ_ID,        :MASTER_PLAN_CLASS_ID, ' +
      ' :LINKED_OBJ_ID, ' +
      ' :STATUS,    :DISMANTLED, ' +
      ' :ARCHIVED,       :CONFIRMED,     :ADDRESS,             :DOC_NUMBER,:DOC_DATE, ' +
      ' :REQUEST_NUMBER, :REQUEST_DATE,  :UNDERGROUND,         :DIAMETER,  :PIPE_COUNT, ' +
      ' :VOLTAGE,        :MATERIAL,      :TOP,                 :BOTTOM,    :FLOOR, ' +
      ' :PROJECTED,      :CHECK_STATE,   :LOADED,              :PROJECT_NAME, ' +
      ' :OWNER,          :DRAW_DATE,     :IS_LINE,             :ROTATION,  :EZDATA, ' +
      ' :CUSTOMER_ORGS_ID, ' +
      ' :EXECUTOR_ORGS_ID, ' +
      ' :OWNER_ORG_ID,   :DRAW_ORGS_ID,   0,                   :TABLE_VERSION, ' +
      ' :DRAWN,          :HAS_CERTIF,    :CERTIF_NUMBER,       :CERTIF_DATE, ' +
      ' :EZ_ID,          :MINX,          :MINY,                :MAXX,      :MAXY)';
  SQL_UPDATE_MP_OBJECT =
      'UPDATE MASTER_PLAN_OBJECTS ' +
      'SET ' +
      '   OBJ_ID = :OBJ_ID, ' +
      '   MASTER_PLAN_CLASS_ID = :MASTER_PLAN_CLASS_ID, ' +
      '   LINKED_OBJ_ID = :LINKED_OBJ_ID, ' +
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
      '   PROJECTED = :PROJECTED, ' +
      '   CHECK_STATE = :CHECK_STATE, ' +
      '   OWNER = :OWNER, ' +
      '   DRAW_DATE = :DRAW_DATE, ' +
      '   IS_LINE = :IS_LINE, ' +
      '   ROTATION = :ROTATION, ' +
      '   EZDATA = :EZDATA, ' +
      '   EZ_ID = :EZ_ID, ' +
      '   MINX = :MINX, ' +
      '   MINY = :MINY, ' +
      '   MAXX = :MAXX, ' +
      '   MAXY = :MAXY, ' +
      '   CUSTOMER_ORGS_ID = :CUSTOMER_ORGS_ID, ' +
      '   EXECUTOR_ORGS_ID = :EXECUTOR_ORGS_ID, ' +
      '   OWNER_ORG_ID = :OWNER_ORG_ID, ' +
      '   DRAW_ORGS_ID = :DRAW_ORGS_ID, ' +
      '   DELETED = 0, ' +
      '   TABLE_VERSION = :TABLE_VERSION, ' +
      '   DRAWN = :DRAWN, ' +
      '   PROJECT_NAME = :PROJECT_NAME, ' +
      '   LOADED = :LOADED, ' +
      '   HAS_CERTIF = :HAS_CERTIF, ' +
      '   CERTIF_NUMBER = :CERTIF_NUMBER, ' +
      '   CERTIF_DATE = :CERTIF_DATE ' +
      'WHERE (ID = :ID)';

{ TmstMPProjectSaver }

function TmstMPProjectSaver.GetEntityStream(aObj: TmstMPObject; CK36: Boolean): TStream;
var
  EntClass: TEzEntityClass;
  EntityID: TEzEntityID;
  Ent: TEzEntity;
begin
  Result := nil;
  EntityID := TEzEntityID(aObj.EzId);
  EntClass := GetClassFromID(EntityID);
  Ent := EntClass.Create(0, True);
  try
    aObj.EzData.Position := 0;
    Ent.LoadFromStream(aObj.EzData);
    if CK36 then
      TEzCSConverter.EntityToVrn(Ent, True);
//      TEzCSConverter.EntityToVrn(Ent, not aObj.ExchangeXY);
//    if aObj.ExchangeXY then
//      TEzCSConverter.ExchangeXY(Ent);
    //
    Result := TMemoryStream.Create;
    Ent.SaveToStream(Result);
    Result.Position := 0;
  except
    FreeAndNil(Ent);
  end;
end;

procedure TmstMPProjectSaver.Save(aDb: IDb; aProject: TmstProject);
var
  Conn: IIBXConnection;
  I: Integer;
  SaveObjState: TSaveLineState;
  Obj: TmstMPObject;
  Prj: TmstProjectMP;
begin
  Prj := aProject as TmstProjectMP;
  // создаём соединение
  Conn := aDb.GetConnection(cmReadWrite, dmKis);
  try
    FTableVersion := Conn.GetGenValue(SG_MP_OBJECTS_TABLE_VERSION);
    //
    SaveObjState.Ds2 := nil;
    SaveObjState.DsMain1 := nil;
    SaveObjState.DsMain2 := nil;
    SaveObjState.PtDs2 := nil;
    SaveObjState.PtDsMain1 := nil;
    SaveObjState.PtDsMain2 := nil;
    for I := 0 to Prj.Objects.Count - 1 do
    begin
      Obj := Prj.Objects[I];
      Obj.ProjectName := Prj.Name;
      Obj.Address := Prj.Address;
      Obj.CK36 := Prj.CK36;
      Obj.ExchangeXY := Prj.ExchangeXY;
      Obj.CustomerOrgId := Prj.CustomerOrgId;
      Obj.ExecutorOrgId := Prj.ExecutorOrgId;
      Obj.OwnerOrgId := Prj.OwnerOrgId;
      Obj.DrawOrgId := Prj.DrawOrgId;
      Obj.RequestNumber := Prj.RequestNumber;
      Obj.RequestDate := Prj.RequestDate;
      Obj.DrawDate := Prj.DrawDate;
      SaveObj(Conn, Obj, SaveObjState);
    end;
    //
    Conn.Commit();
  except
    Conn.Rollback();
    raise;
  end;
end;

procedure TmstMPProjectSaver.SaveObj(Conn: IIBXConnection; aObj: TmstMPObject;
  var aState: TSaveLineState);
var
  B2: Boolean;
  //Ds1,
  Ds2, DsMain: TDataSet;
  Xmin, Xmax, Ymin, Ymax: Double;
  EzStream: TStream;
begin
  if aObj.DatabaseId < 1 then
  begin
    aObj.DatabaseId := Conn.GenNextValue(SG_MP_OBJECTS);
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
  //ID,
  Conn.SetParam(DsMain, SF_ID, aObj.DatabaseId);
  //OBJ_ID,
  Conn.SetParam(DsMain, SF_OBJ_ID, aObj.MPObjectGuid);
  //MASTER_PLAN_CLASS_ID,
  Conn.SetNullableParam(DsMain, SF_MASTER_PLAN_CLASS_ID, aObj.MpClassId, 0);
  //STATUS,
  Conn.SetParam(DsMain, SF_STATUS, aObj.Status);
  //DISMANTLED,
  Conn.SetParam(DsMain, SF_DISMANTLED, IfThen(aObj.Dismantled, 1, 0));
  //ARCHIVED,
  Conn.SetParam(DsMain, SF_ARCHIVED, IfThen(aObj.Archived, 1, 0));
  //CONFIRMED,
  Conn.SetParam(DsMain, SF_CONFIRMED, IfThen(aObj.Confirmed, 1, 0));
  //ADDRESS,
  Conn.SetParam(DsMain, SF_ADDRESS, aObj.Address);
  //DOC_NUMBER,
  Conn.SetParam(DsMain, SF_DOC_NUMBER, aObj.DocNumber);
  //DOC_DATE,
  Conn.SetNullableParam(DsMain, SF_DOC_DATE, aObj.DocDate, 0);
  //REQUEST_NUMBER,
  Conn.SetParam(DsMain, SF_REQUEST_NUMBER, aObj.RequestNumber);
  //REQUEST_DATE,
  Conn.SetNullableParam(DsMain, SF_REQUEST_DATE, aObj.RequestDate, 0);
  //UNDERGROUND,
  Conn.SetParam(DsMain, SF_UNDERGROUND, IfThen(aObj.Underground, 1, 0));
  //DIAMETER,
  Conn.SetParam(DsMain, SF_DIAMETER, aObj.Diameter);
  //PIPE_COUNT,
  Conn.SetParam(DsMain, SF_PIPE_COUNT, aObj.PipeCount);
  //VOLTAGE,
  Conn.SetParam(DsMain, SF_VOLTAGE, aObj.Voltage);
  //MATERIAL,
  Conn.SetParam(DsMain, SF_MATERIAL, aObj.Material);
  //TOP,
  Conn.SetParam(DsMain, SF_TOP, aObj.Top);
  //BOTTOM,
  Conn.SetParam(DsMain, SF_BOTTOM, aObj.Bottom);
  //FLOOR,
  Conn.SetParam(DsMain, SF_FLOOR, aObj.Floor);
  //OWNER,
  Conn.SetParam(DsMain, SF_OWNER, aObj.Owner);
  //DRAW_DATE,
  Conn.SetNullableParam(DsMain, SF_DRAW_DATE, aObj.DrawDate, 0);
  //IS_LINE,
  Conn.SetParam(DsMain, SF_IS_LINE, IfThen(aObj.IsLine, 1, 0));
  //ROTATION,
  Conn.SetParam(DsMain, SF_ROTATION, aObj.Rotation);
  //EZDATA,
  EzStream := GetEntityStream(aObj, aObj.CK36);
  try
    Conn.SetBlobParam(DsMain, SF_EZDATA, EzStream);
  finally
    EzStream.Free;
  end;
  //EZ_ID,
  Conn.SetParam(DsMain, SF_EZ_ID, aObj.EzId);
  //LOADED,
  Conn.SetParam(DsMain, SF_LOADED, 0);
  //PROJECT_NAME,
  Conn.SetParam(DsMain, SF_PROJECT_NAME, aObj.ProjectName);
  //CUSTOMER_ORGS_ID,
  Conn.SetNullableParam(DsMain, SF_CUSTOMER_ORGS_ID, aObj.CustomerOrgId, 0); // :CUSTOMER_ORGS_ID
  //EXECUTOR_ORGS_ID,
  Conn.SetNullableParam(DsMain, SF_EXECUTOR_ORGS_ID, aObj.ExecutorOrgId, 0); // :EXECUTOR_ORGS_ID
  //OWNER_ORG_ID,
  Conn.SetNullableParam(DsMain, SF_OWNER_ORG_ID, aObj.OwnerOrgId, 0); // :OWNER_ORG_ID
  //DRAW_ORGS_ID,
  Conn.SetNullableParam(DsMain, SF_DRAW_ORGS_ID, aObj.DrawOrgId, 0); // :DRAW_ORGS_ID
  //TABLE_VERSION
  Conn.SetParam(DsMain, SF_TABLE_VERSION, FTableVersion);
  //DRAWN,
  Conn.SetParam(DsMain, SF_DRAWN, IfThen(aObj.Drawn, 1, 0));
  //PROJECTED,
  Conn.SetParam(DsMain, SF_PROJECTED, IfThen(aObj.Projected, 1, 0));
  //CERTIF_DATE,
  Conn.SetNullableParam(DsMain, SF_CERTIF_DATE, aObj.CertifDate, 0);
  //CERTIF_NUMBER,
  Conn.SetParam(DsMain, SF_CERTIF_NUMBER, aObj.CertifNumber);
  //HAS_CERTIF,
  Conn.SetParam(DsMain, SF_HAS_CERTIF, IfThen(aObj.HasCertif, 1, 0));
  //CHECK_STATS
  Conn.SetParam(DsMain, SF_CHECK_STATE, Integer(aObj.CheckState));
  //
  XMin := aObj.MinX;
  YMin := aObj.MinY;
  XMax := aObj.MaxX;
  YMax := aObj.MaxY;
  if aObj.CK36 then
  begin
    TEzCSConverter.XY2DToVrn(Xmin, Ymin, False);
    TEzCSConverter.XY2DToVrn(Xmax, Ymax, False);
  end;
  //
  //MINX,
  Conn.SetParam(DsMain, SF_MINX, Xmin);
  //MINY,
  Conn.SetParam(DsMain, SF_MINY, Ymin);
  //MAXX,
  Conn.SetParam(DsMain, SF_MAXX, Xmax);
  //MAXY,
  Conn.SetParam(DsMain, SF_MAXY, Ymax);
  //
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
    Tgt.FObjState := Self.FObjState;
    Tgt.FCheckState := Self.FCheckState;
    Tgt.FRequestDate := Self.FRequestDate;
    //
    Tgt.FObjects.CopyFrom(Self.Objects);
  end;
end;

procedure TmstProjectMP.CalcExtent;
var
  I: Integer;
  Obj: TmstMPObject;
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

function TmstProjectMP.IsMP: Boolean;
begin
  Result := True;
end;

procedure TmstProjectMP.RefreshExchangeXY;
var
  I: Integer;
begin
  inherited;
  for I := 0 to Objects.Count - 1 do
  begin
    Objects[I].ExchangeXY := Self.ExchangeXY;
    Objects[I].CK36 := Self.CK36;
  end;
end;

procedure TmstProjectMP.SetCheckState(const Value: TmstMPObjectCheckState);
begin
  FCheckState := Value;
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

procedure TmstProjectMP.SetObjState(const Value: TmstMPObjectState);
begin
  FObjState := Value;
end;

procedure TmstProjectMP.SetOwnerOrgId(const Value: Integer);
begin
  FOwnerOrgId := Value;
end;

procedure TmstProjectMP.SetRequestDate(const Value: TDateTime);
begin
  FRequestDate := Value;
end;

procedure TmstProjectMP.SetRequestNumber(const Value: string);
begin
  FRequestNumber := Value;
end;

procedure TmstProjectMP.SetStatus(const Value: Integer);
begin
  FStatus := Value;
end;

{ TmstMPObject }

procedure TmstMPObject.AssignTo(Target: TPersistent);
var
  Tgt: TmstMPObject;
begin
  if not (Target is TmstMPObject) then
    inherited;
  if Target is TmstMPObject then
  begin
    Tgt := TmstMPObject(Target);
    //
    Tgt.FMPObjectGuid := FMPObjectGuid;
    Tgt.FLinkedObjectGuid := FLinkedObjectGuid;
    Tgt.FClassId := FClassId;
    Tgt.FArchived := FArchived;
    Tgt.FDocNumber := FDocNumber;
    Tgt.FConfirmed := FConfirmed;
    Tgt.FDismantled := FDismantled;
    Tgt.FAddress := FAddress;
    Tgt.FDocDate := FDocDate;
    Tgt.FRequestNumber := FRequestNumber;
    Tgt.FRequestDate := FRequestDate;
    Tgt.FMaterial := FMaterial;
    Tgt.FVoltage := FVoltage;
    Tgt.FUnderground := FUnderground;
    Tgt.FPipeCount := FPipeCount;
    Tgt.FFloor := FFloor;
    Tgt.FDiameter := FDiameter;
    Tgt.FBottom := FBottom;
    Tgt.FTop := FTop;
    Tgt.FOwner := FOwner;
    Tgt.FDrawDate := FDrawDate;
    Tgt.FIsLine := FIsLine;
    Tgt.FRotation := FRotation;
    Tgt.FMaxX := FMaxX;
    Tgt.FMaxY := FMaxY;
    Tgt.FMinX := FMinX;
    Tgt.FMinY := FMinY;
    Tgt.FEzLayerRecno := Self.FEzLayerRecno;
    Tgt.FEzLayerName := FEzLayerName;
    Tgt.FObjState := FObjState;
    Tgt.FCheckState := FCheckState;
    Tgt.FClassId := FClassId;
    Tgt.FDrawOrgId := FDrawOrgId;
    Tgt.FCustomerOrgId := FCustomerOrgId;
    Tgt.FExecutorOrgId := FExecutorOrgId;
    Tgt.FOwnerOrgId := FOwnerOrgId;
    Tgt.FDrawn := FDrawn;
    Tgt.FProjected := FProjected;
    Tgt.FCertifNumber := FCertifNumber;
    Tgt.FCertifDate := FCertifDate;
    Tgt.FHasCertif := FHasCertif;
    //
    Tgt.FCK36 := FCK36;
    Tgt.FExchangeXY := FExchangeXY;
    Tgt.FMPLayerId := FMPLayerId;
    Tgt.ProjectName := FProjectName;
    //
    Tgt.FEzData.Size := 0;
    Self.FEzData.Position := 0;
    Tgt.FEzData.CopyFrom(Self.FEzData, Self.FEzData.Size);
    Tgt.FEzData.Position := 0;
    Self.FEzData.Position := 0;
    Tgt.FEzId := Self.FEzId;
    //
    Tgt.FMpClassName := FMpClassName;
    Tgt.FDrawOrg := FDrawOrg;
    Tgt.FCustomerOrg := FCustomerOrg;
    Tgt.FExecutorOrg := FExecutorOrg;
    //
    Tgt.DatabaseId := Self.DatabaseId;
  end;
end;

constructor TmstMPObject.Create;
begin
  inherited;
  FTempPoints := TEzVector.Create(1);
  FTempPoints.CanGrow := True;
  FEzData := TMemoryStream.Create;
  FEzId := -1;
  FGuid := GetUniqueString(False, True);
  // при создании можно взять любой ГУИД,
  // если будет загрузка из Бд, то он изменится
  FMpObjectGuid := FGuid;
end;

destructor TmstMPObject.Destroy;
begin
  FreeAndNil(FEzData);
  FreeAndNil(FTempPoints);
  inherited;
end;

function TmstMPObject.GetObjectId: Integer;
begin
  Result := inherited GetObjectId();
end;

function TmstMPObject.GetText: String;
begin
  Result := '';
end;

procedure TmstMPObject.SetAddress(const Value: string);
begin
  FAddress := Value;
end;

procedure TmstMPObject.SetArchived(const Value: Boolean);
begin
  FArchived := Value;
end;

procedure TmstMPObject.SetBottom(const Value: string);
begin
  FBottom := Value;
end;

procedure TmstMPObject.SetCertifDate(const Value: TDateTime);
begin
  FCertifDate := Value;
end;

procedure TmstMPObject.SetCertifNumber(const Value: string);
begin
  FCertifNumber := Value;
end;

procedure TmstMPObject.SetCheckState(const Value: TmstMPObjectCheckState);
begin
  FCheckState := Value;
end;

procedure TmstMPObject.SetCK36(const Value: Boolean);
begin
  FCK36 := Value;
end;

procedure TmstMPObject.SetClassGuid(const Value: string);
begin
  FClassGuid := Value;
end;

procedure TmstMPObject.SetClassId(const Value: Integer);
begin
  FClassId := Value;
end;

procedure TmstMPObject.SetConfirmed(const Value: Boolean);
begin
  FConfirmed := Value;
end;

procedure TmstMPObject.SetCustomerOrg(const Value: string);
begin
  FCustomerOrg := Value;
end;

procedure TmstMPObject.SetCustomerOrgId(const Value: Integer);
begin
  FCustomerOrgId := Value;
end;

procedure TmstMPObject.SetDiameter(const Value: Integer);
begin
  FDiameter := Value;
end;

procedure TmstMPObject.SetDismantled(const Value: Boolean);
begin
  FDismantled := Value;
end;

procedure TmstMPObject.SetDocDate(const Value: TDateTime);
begin
  FDocDate := Value;
end;

procedure TmstMPObject.SetDocNumber(const Value: string);
begin
  FDocNumber := Value;
end;

procedure TmstMPObject.SetDrawDate(const Value: TDateTime);
begin
  FDrawDate := Value;
end;

procedure TmstMPObject.SetDrawn(const Value: Boolean);
begin
  FDrawn := Value;
end;

procedure TmstMPObject.SetDrawOrg(const Value: string);
begin
  FDrawOrg := Value;
end;

procedure TmstMPObject.SetDrawOrgId(const Value: Integer);
begin
  FDrawOrgId := Value;
end;

procedure TmstMPObject.SetEzLayerRecno(const Value: Integer);
begin
  FEzLayerRecno := Value;
end;

procedure TmstMPObject.SetExchangeXY(const Value: Boolean);
begin
  FExchangeXY := Value;
end;

procedure TmstMPObject.SetExecutorOrg(const Value: string);
begin
  FExecutorOrg := Value;
end;

procedure TmstMPObject.SetExecutorOrgId(const Value: Integer);
begin
  FExecutorOrgId := Value;
end;

procedure TmstMPObject.SetEzId(const Value: Integer);
begin
  FEzId := Value;
end;

procedure TmstMPObject.SetFloor(const Value: string);
begin
  FFloor := Value;
end;

procedure TmstMPObject.SetHasCertif(const Value: Boolean);
begin
  FHasCertif := Value;
end;

procedure TmstMPObject.SetIsLine(const Value: Boolean);
begin
  FIsLine := Value;
end;

procedure TmstMPObject.SetLinkedObjectGuid(const Value: string);
begin
  FLinkedObjectGuid := Value;
end;

procedure TmstMPObject.SetEzLayerName(const Value: string);
begin
  FEzLayerName := Value;
end;

procedure TmstMPObject.SetMaterial(const Value: string);
begin
  FMaterial := Value;
end;

procedure TmstMPObject.SetMaxX(const Value: Double);
begin
  FMaxX := Value;
end;

procedure TmstMPObject.SetMaxY(const Value: Double);
begin
  FMaxY := Value;
end;

procedure TmstMPObject.SetMinX(const Value: Double);
begin
  FMinX := Value;
end;

procedure TmstMPObject.SetMinY(const Value: Double);
begin
  FMinY := Value;
end;

procedure TmstMPObject.SetMpClassName(const Value: string);
begin
  FMpClassName := Value;
end;

procedure TmstMPObject.SetMPLayerId(const Value: Integer);
begin
  FMPLayerId := Value;
end;

procedure TmstMPObject.SetMPObjectGuid(const Value: string);
begin
  FMPObjectGuid := Value;
end;

procedure TmstMPObject.SetObjState(const Value: TmstMPObjectState);
begin
  FObjState := Value;
end;

procedure TmstMPObject.SetOwner(const Value: string);
begin
  FOwner := Value;
end;

procedure TmstMPObject.SetOwnerOrgId(const Value: Integer);
begin
  FOwnerOrgId := Value;
end;

procedure TmstMPObject.SetPipeCount(const Value: Integer);
begin
  FPipeCount := Value;
end;

procedure TmstMPObject.SetProjected(const Value: Boolean);
begin
  FProjected := Value;
end;

procedure TmstMPObject.SetProjectName(const Value: string);
begin
  FProjectName := Value;
end;

procedure TmstMPObject.SetRequestDate(const Value: TDateTime);
begin
  FRequestDate := Value;
end;

procedure TmstMPObject.SetRequestNumber(const Value: string);
begin
  FRequestNumber := Value;
end;

procedure TmstMPObject.SetRotation(const Value: Integer);
begin
  FRotation := Value;
end;

procedure TmstMPObject.SetTempCategoryId(const Value: Integer);
begin
  FTempCategoryId := Value;
end;

procedure TmstMPObject.SetTempLayer(const Value: string);
begin
  FTempLayer := Value;
end;

procedure TmstMPObject.SetTempLayerId(const Value: Integer);
begin
  FTempLayerId := Value;
end;

procedure TmstMPObject.SetTempСaеtegory(const Value: string);
begin
  FTempСaеtegory := Value;
end;

procedure TmstMPObject.SetTop(const Value: string);
begin
  FTop := Value;
end;

procedure TmstMPObject.SetUnderground(const Value: Boolean);
begin
  FUnderground := Value;
end;

procedure TmstMPObject.SetVoltage(const Value: Integer);
begin
  FVoltage := Value;
end;

function TmstMPObject.Status: Integer;
begin
  if Drawn then
    Result := 4
  else
    if Dismantled then
      Result := 3
    else
    if HasCertif then
      Result := 2
    else
      Result := 1;
end;

procedure TmstMPObject.UpdateObjState;
begin
  if Drawn then
    ObjState := mstDrawn
  else
    ObjState := mstProjected;
end;

{ TmstProjectObjects }

function TmstProjectObjects.Add: TmstMPObject;
begin
  Result := TmstMPObject.Create;
  inherited Add(Result);
  Result.FObjState := FOwner.ObjState;
  case Result.FObjState of
  mstProjected:
    begin
      Result.FDrawn := False;
      Result.FProjected := True;
    end;
  mstDrawn :
    begin
      Result.FDrawn := True;
      Result.FProjected := False;
    end;
  end;
  Result.FCheckState := FOwner.CheckState;
end;

procedure TmstProjectObjects.CopyFrom(Source: TmstProjectObjects);
var
  Src, Tgt: TmstMPObject;
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

function TmstProjectObjects.GetByDbId(const aId: Integer): TmstMPObject;
var
  I: Integer;
begin
  for I := 0 to Count - 1 do
    if Items[I].DatabaseId = aId then
    begin
      Result := Items[I];
      Exit;
    end;
  Result := nil;
end;

function TmstProjectObjects.GetByGuid(const aGuid: string): TmstMPObject;
var
  I: Integer;
begin
  for I := 0 to Count - 1 do
    if Items[I].MPObjectGuid = aGuid then
    begin
      Result := Items[i];
      Exit;
    end;
  Result := nil;
end;

function TmstProjectObjects.GetItems(Index: Integer): TmstMPObject;
begin
  Result := TmstMPObject(inherited Items[Index]);
end;

procedure TmstProjectObjects.SetItems(Index: Integer; const Value: TmstMPObject);
begin
  inherited Items[Index] := Value;
end;

{ TmstMPObjectSaver }

function TmstMPObjectSaver.GetEntityStream(aObj: TmstMPObject; CK36: Boolean): TStream;
var
  EntClass: TEzEntityClass;
  EntityID: TEzEntityID;
  Ent: TEzEntity;
begin
  Result := nil;
  EntityID := TEzEntityID(aObj.EzId);
  EntClass := GetClassFromID(EntityID);
  Ent := EntClass.Create(0, True);
  try
    aObj.EzData.Position := 0;
    Ent.LoadFromStream(aObj.EzData);
    if CK36 then
      TEzCSConverter.EntityToVrn(Ent, True);
//      TEzCSConverter.EntityToVrn(Ent, not aObj.ExchangeXY);
//    if aObj.ExchangeXY then
//      TEzCSConverter.ExchangeXY(Ent);
    //
    Result := TMemoryStream.Create;
    Ent.SaveToStream(Result);
    Result.Position := 0;
  except
    FreeAndNil(Ent);
  end;
end;

procedure TmstMPObjectSaver.Save(aDb: IDb; MPObject: TmstObject);
var
  Conn: IIBXConnection;
  Obj: TmstMPObject;
begin
  Obj := MPObject as TmstMPObject;
  // создаём соединение
  Conn := aDb.GetConnection(cmReadWrite, dmKis);
  try
    FTableVersion := Conn.GenNextValue(SG_MP_OBJECTS_TABLE_VERSION);
    //
    SaveObj(Conn, Obj);
    //
    Conn.Commit();
  except
    Conn.Rollback();
    raise;
  end;
end;

procedure TmstMPObjectSaver.SaveObj(Conn: IIBXConnection; aObj: TmstMPObject);
var
  NewObject: Boolean;
  DsCheck, DsMain: TDataSet;
  Xmin, Xmax, Ymin, Ymax: Double;
  EzStream: TStream;
  Sql: string;
begin
  if aObj.DatabaseId < 1 then
  begin
    aObj.DatabaseId := Conn.GenNextValue(SG_MP_OBJECTS);
    NewObject := True;
  end
  else
  begin
    DsCheck := Conn.GetDataSet(SQL_CHECK_MP_OBJECT_EXISTS);
    Conn.SetParam(DsCheck, SF_ID, aObj.DatabaseId);
    DsCheck.Open;
    NewObject := DsCheck.Fields[0].AsInteger = 0;
    DsCheck.Close;
  end;
  //
  if NewObject then
    Sql := SQL_INSERT_MP_OBJECT
  else
    Sql := SQL_UPDATE_MP_OBJECT;
  DsMain := Conn.GetDataSet(Sql);
  //
  //ID,
  Conn.SetParam(DsMain, SF_ID, aObj.DatabaseId);
  //TABLE_VERSION
  Conn.SetParam(DsMain, SF_TABLE_VERSION, FTableVersion);
  //OBJ_ID,
  Conn.SetParam(DsMain, SF_OBJ_ID, aObj.MPObjectGuid);
  //LINKED_OBJ_ID,
  Conn.SetParam(DsMain, SF_LINKED_OBJ_ID, aObj.LinkedObjectGuid);
  //MASTER_PLAN_CLASS_ID,
  Conn.SetNullableParam(DsMain, SF_MASTER_PLAN_CLASS_ID, aObj.MpClassId, 0);
  //STATUS,
  Conn.SetParam(DsMain, SF_STATUS, aObj.Status);
  //DISMANTLED,
  Conn.SetParam(DsMain, SF_DISMANTLED, IfThen(aObj.Dismantled, 1, 0));
  //ARCHIVED,
  Conn.SetParam(DsMain, SF_ARCHIVED, IfThen(aObj.Archived, 1, 0));
  //CONFIRMED,
  Conn.SetParam(DsMain, SF_CONFIRMED, IfThen(aObj.Confirmed, 1, 0));
  //ADDRESS,
  Conn.SetParam(DsMain, SF_ADDRESS, aObj.Address);
  //DOC_NUMBER,
  Conn.SetParam(DsMain, SF_DOC_NUMBER, aObj.DocNumber);
  //DOC_DATE,
  Conn.SetNullableParam(DsMain, SF_DOC_DATE, aObj.DocDate, 0);
  //REQUEST_NUMBER,
  Conn.SetParam(DsMain, SF_REQUEST_NUMBER, aObj.RequestNumber);
  //REQUEST_DATE,
  Conn.SetNullableParam(DsMain, SF_REQUEST_DATE, aObj.RequestDate, 0);
  //UNDERGROUND,
  Conn.SetParam(DsMain, SF_UNDERGROUND, IfThen(aObj.Underground, 1, 0));
  //DIAMETER,
  Conn.SetParam(DsMain, SF_DIAMETER, aObj.Diameter);
  //PIPE_COUNT,
  Conn.SetParam(DsMain, SF_PIPE_COUNT, aObj.PipeCount);
  //VOLTAGE,
  Conn.SetParam(DsMain, SF_VOLTAGE, aObj.Voltage);
  //MATERIAL,
  Conn.SetParam(DsMain, SF_MATERIAL, aObj.Material);
  //TOP,
  Conn.SetParam(DsMain, SF_TOP, aObj.Top);
  //BOTTOM,
  Conn.SetParam(DsMain, SF_BOTTOM, aObj.Bottom);
  //FLOOR,
  Conn.SetParam(DsMain, SF_FLOOR, aObj.Floor);
  //OWNER,
  Conn.SetParam(DsMain, SF_OWNER, aObj.Owner);
  //DRAW_DATE,
  Conn.SetNullableParam(DsMain, SF_DRAW_DATE, aObj.DrawDate, 0);
  //IS_LINE,
  Conn.SetParam(DsMain, SF_IS_LINE, IfThen(aObj.IsLine, 1, 0));
  //ROTATION,
  Conn.SetParam(DsMain, SF_ROTATION, aObj.Rotation);
  //EZDATA,
  EzStream := GetEntityStream(aObj, aObj.CK36);
  try
    Conn.SetBlobParam(DsMain, SF_EZDATA, EzStream);
  finally
    EzStream.Free;
  end;
  //EZ_ID,
  Conn.SetParam(DsMain, SF_EZ_ID, aObj.EzId);
  //LOADED,
  Conn.SetParam(DsMain, SF_LOADED, 0);
  //PROJECT_NAME,
  Conn.SetParam(DsMain, SF_PROJECT_NAME, aObj.ProjectName);
  //CUSTOMER_ORGS_ID,
  Conn.SetNullableParam(DsMain, SF_CUSTOMER_ORGS_ID, aObj.CustomerOrgId, 0); // :CUSTOMER_ORGS_ID
  //EXECUTOR_ORGS_ID,
  Conn.SetNullableParam(DsMain, SF_EXECUTOR_ORGS_ID, aObj.ExecutorOrgId, 0); // :EXECUTOR_ORGS_ID
  //OWNER_ORG_ID,
  Conn.SetNullableParam(DsMain, SF_OWNER_ORG_ID, aObj.OwnerOrgId, 0); // :OWNER_ORG_ID
  //DRAW_ORGS_ID,
  Conn.SetNullableParam(DsMain, SF_DRAW_ORGS_ID, aObj.DrawOrgId, 0); // :DRAW_ORGS_ID
  //DRAWN,
  Conn.SetParam(DsMain, SF_DRAWN, IfThen(aObj.Drawn, 1, 0));
  //PROJECTED,
  Conn.SetParam(DsMain, SF_PROJECTED, IfThen(aObj.Projected, 1, 0));
  //CERTIF_DATE,
  Conn.SetNullableParam(DsMain, SF_CERTIF_DATE, aObj.CertifDate, 0);
  //CERTIF_NUMBER,
  Conn.SetParam(DsMain, SF_CERTIF_NUMBER, aObj.CertifNumber);
  //HAS_CERTIF,
  Conn.SetParam(DsMain, SF_HAS_CERTIF, IfThen(aObj.HasCertif, 1, 0));
  //CHECK_STATS
  Conn.SetParam(DsMain, SF_CHECK_STATE, Integer(aObj.CheckState));
  //
  XMin := aObj.MinX;
  YMin := aObj.MinY;
  XMax := aObj.MaxX;
  YMax := aObj.MaxY;
  if aObj.CK36 then
  begin
    TEzCSConverter.XY2DToVrn(Xmin, Ymin, False);
    TEzCSConverter.XY2DToVrn(Xmax, Ymax, False);
  end;
  //
  //MINX,
  Conn.SetParam(DsMain, SF_MINX, Xmin);
  //MINY,
  Conn.SetParam(DsMain, SF_MINY, Ymin);
  //MAXX,
  Conn.SetParam(DsMain, SF_MAXX, Xmax);
  //MAXY,
  Conn.SetParam(DsMain, SF_MAXY, Ymax);
  //
  Conn.ExecDataSet(DsMain);
end;

initialization
//  TProjectsSettings.PenWidth := 2;

end.
