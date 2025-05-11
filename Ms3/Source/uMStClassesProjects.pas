unit uMStClassesProjects;

interface

uses
  SysUtils, Classes, Contnrs, Forms, DB, Math, Graphics, Dialogs,
  EzLib, EzBaseGIS, EzEntities, EzBase,
  uCommonUtils, uCK36, uGC,
  uEzBufferZone,
  uMStKernelClasses, uMStKernelIBX, uMStConsts;

const
  NT_WATER = 1;
  NT_SEWERAGE = 2;
  NT_STORM_DRAIN = 3;
  NT_HEAT_PIPELINE = 4;
  NT_ELECTRIC_LINE = 5;
  NT_COMMUNICTION_LINE = 6;

  mstProjectNetTypes: set of Byte = [
    NT_WATER,
    NT_SEWERAGE,
    NT_STORM_DRAIN,
    NT_HEAT_PIPELINE,
    NT_ELECTRIC_LINE,
    NT_COMMUNICTION_LINE
  ];

  PRJ_LAYER_LINES = 0;
  PRJ_LAYER_POINTS = 1;
  PRJ_LAYER_OTHER = 2;

type
  TmstProject = class;

  TmstProjectNetType = class(TmstObject)
  private
    FName: string;
    FZoneWidth: Double;
    FColor: string;
    FVisible: Boolean;
    procedure SetName(const Value: string);
    procedure SetZoneWidth(const Value: Double);
    procedure SetColor(const Value: string);
    procedure SetVisible(const Value: Boolean);
  protected
    procedure AssignTo(Target: TPersistent); override;
  public
    constructor Create; override;

    function GetColor(): TColor;
    property Color: string read FColor write SetColor;
    property Name: string read FName write SetName;
    property ZoneWidth: Double read FZoneWidth write SetZoneWidth;
    //
    property Visible: Boolean read FVisible write SetVisible;
  end;

  TmstProjectLayer = class(TmstObject)
  private
    FName: string;
    FRequired: Boolean;
    FDestroyed: Boolean;
    FLineType: Boolean;
    FNetType: TmstProjectNetType;
    FActive: Boolean;
    FMPLayerId: Integer;
    procedure SetName(const Value: string);
    procedure SetRequired(const Value: Boolean);
    procedure SetDestroyed(const Value: Boolean);
    procedure SetLineType(const Value: Boolean);
    procedure SetNetType(const Value: TmstProjectNetType);
    procedure SetActive(const Value: Boolean);
    procedure SetMPLayerId(const Value: Integer);
  protected
    procedure AssignTo(Target: TPersistent); override;
  public
    constructor Create; override;
    destructor Destroy; override;
    //
    property Active: Boolean read FActive write SetActive;
    property Destroyed: Boolean read FDestroyed write SetDestroyed;
    property IsLineLayer: Boolean read FLineType write SetLineType;
    property Name: string read FName write SetName;
    property NetType: TmstProjectNetType read FNetType write SetNetType;
    property Required: Boolean read FRequired write SetRequired;
    //
    property MPLayerId: Integer read FMPLayerId write SetMPLayerId;
  end;

  TmstProjectPoint = class(TmstObject)
  private
    FX: Double;
    FY: Double;
    FName: string;
    FZ: Double;
    procedure SetX(const Value: Double);
    procedure SetY(const Value: Double);
    procedure SetName(const Value: string);
    procedure SetZ(const Value: Double);
  public
    property Name: string read FName write SetName;
    property X: Double read FX write SetX;
    property Y: Double read FY write SetY;
    property Z: Double read FZ write SetZ;
  end;

  TmstProjectLinePoints = class(TObjectList)
  private
    function GetItems(Index: Integer): TmstProjectPoint;
    procedure SetItems(Index: Integer; const Value: TmstProjectPoint);
  public
    function Add(const X, Y: Double): TmstProjectPoint;
    function First: TmstProjectPoint;
    function GetZDelta(I: Integer): Double;
    function Last: TmstProjectPoint;
    procedure CopyFrom(Source: TmstProjectLinePoints);
    property Items[Index: Integer]: TmstProjectPoint read GetItems write SetItems; default;
  end;

  TmstProjectLine = class(TmstObject)
  private
    FNetType: Integer;
    FVoltage: string;
    FDiameter: string;
    FInfo: string;
    FPoints: TmstProjectLinePoints;
    FLayer: TmstProjectLayer;
    FEntityId: Integer;
    FOwner: TmstProject;
    FZone: TEzEntity;
    FZoneWidth: Double;
    FZoneLine: TmstProjectLine;
    procedure SetDiameter(const Value: string);
    procedure SetInfo(const Value: string);
    procedure SetNetType(const Value: Integer);
    procedure SetVoltage(const Value: string);
    procedure SetLayer(const Value: TmstProjectLayer);
    procedure SetEntityId(const Value: Integer);
    procedure SetOwner(const Value: TmstProject);
    procedure SetZone(const Value: TEzEntity);
    procedure SetZoneWidth(const Value: Double);
    procedure SetZoneLine(const Value: TmstProjectLine);
  protected
    procedure AssignTo(Target: TPersistent); override;
  public
    constructor Create; override;
    destructor Destroy; override;
    //
    procedure BuildZone(aZoneWidth: Double);
    function GetLength: Double;
    function GetZDelta: Double;
    //
    property Layer: TmstProjectLayer read FLayer write SetLayer;
    property Points: TmstProjectLinePoints read FPoints;
    //
    property Diameter: string read FDiameter write SetDiameter;
    property Info: string read FInfo write SetInfo;
    property NetType: Integer read FNetType write SetNetType;
    property Voltage: string read FVoltage write SetVoltage;
    //
    property Owner: TmstProject read FOwner write SetOwner;
    property EntityId: Integer read FEntityId write SetEntityId;
    //
    property Zone: TEzEntity read FZone write SetZone;
    property ZoneLine: TmstProjectLine read FZoneLine write SetZoneLine;
    property ZoneWidth: Double read FZoneWidth write SetZoneWidth;
  end;

  TmstProjectLines = class(TObjectList)
  private
    FOwner: TmstProject;
    function GetItems(Index: Integer): TmstProjectLine;
    procedure SetItems(Index: Integer; const Value: TmstProjectLine);
  public
    constructor Create(aOwner: TmstProject);
    function Add(): TmstProjectLine;
    function ByDbId(const DbId: Integer): TmstProjectLine;
    procedure CopyFrom(Source: TmstProjectLines);
    procedure DeleteLine(const DbId: Integer);
    property Items[Index: Integer]: TmstProjectLine read GetItems write SetItems; default;
  end;

  TmstProjectLayers = class(TObjectList)
  private
    function GetItems(Index: Integer): TmstProjectLayer;
    procedure SetItems(Index: Integer; const Value: TmstProjectLayer);
  public
    function Add(const aName: string; aDestroyed, aRequired, aLineType: Boolean): TmstProjectLayer; overload;
    function Add(const Source: TmstProjectLayer): TmstProjectLayer; overload;
    function ByDbId(DbId: Integer): TmstProjectLayer;
    function ByName(aName: String): TmstProjectLayer;
    procedure CopyFrom(Source: TmstProjectLayers);
    property Items[Index: Integer]: TmstProjectLayer read GetItems write SetItems; default;
  end;

  TmstProjectBlock = class(TmstObject)
  private
    FName: string;
    FEzData: TStream;
    FSymbolId: Integer;
    procedure SetName(const Value: string);
    procedure SetSymbolId(const Value: Integer);
  protected
    procedure AssignTo(Target: TPersistent); override;
  public
    constructor Create; override;
    destructor Destroy; override;
    //
    property Name: string read FName write SetName;
    property EzData: TStream read FEzData;
    //
    property SymbolId: Integer read FSymbolId write SetSymbolId;
  end;

  TmstProjectBlocks = class(TObjectList)
  private
    function GetItems(Index: Integer): TmstProjectBlock;
    procedure SetItems(Index: Integer; const Value: TmstProjectBlock);
  public
    procedure CopyFrom(Source: TmstProjectBlocks);
    function ByName(const BlockName: string): TmstProjectBlock;
    property Items[Index: Integer]: TmstProjectBlock read GetItems write SetItems; default;
  end;

  TmstProjectPlace = class(TmstObject)
  private
    FData: TStream;
    FLayer: TmstProjectLayer;
    FEntityId: Integer;
    FOwner: TmstProject;
    FEzId: Integer;
    procedure SetLayer(const Value: TmstProjectLayer);
    procedure SetEntityId(const Value: Integer);
    procedure SetOwner(const Value: TmstProject);
    procedure SetEzId(const Value: Integer);
  protected
    procedure AssignTo(Target: TPersistent); override;
  public
    constructor Create; override;
    destructor Destroy; override;
    //
    property Layer: TmstProjectLayer read FLayer write SetLayer;
    property EzData: TStream read FData;
    property EzId: Integer read FEzId write SetEzId;
    //
    property Owner: TmstProject read FOwner write SetOwner;
    property EntityId: Integer read FEntityId write SetEntityId;
  end;

  TmstProjectPlaces = class(TObjectList)
  private
    FOwner: TmstProject;
    function GetItems(Index: Integer): TmstProjectPlace;
    procedure SetItems(Index: Integer; const Value: TmstProjectPlace);
  public
    constructor Create(aOwner: TmstProject);
    function Add(): TmstProjectPlace;
    procedure CopyFrom(Source: TmstProjectPlaces);
    procedure DeletePlace(const DbId: Integer);
    property Items[Index: Integer]: TmstProjectPlace read GetItems write SetItems; default;
  end;

  TSaveLineState = record
    //Ds1,
    Ds2, DsMain1, DsMain2: TDataSet;
    //PtDs1,
    PtDs2, PtDsMain1, PtDsMain2: TDataSet;
  end;

  TmstProject = class(TmstObject)
  private
    FAddress: string;
    FCustomerOrgId: Integer;
    FExecutorOrgId: Integer;
    FDocNumber: string;
    FConfirmed: Boolean;
    FDocDate: TDateTime;
    FLayers: TmstProjectLayers;
    FLines: TmstProjectLines;
    FBlocks: TmstProjectBlocks;
    FCK36: Boolean;
    FPlaces: TmstProjectPlaces;
    FConfirmDate: TDateTime;
    FMaxX: Double;
    FMaxY: Double;
    FMinX: Double;
    FMinY: Double;
    FCaption: string;
    FExchangeXY: Boolean;
    procedure SetAddress(const Value: string);
    procedure SetConfirmed(const Value: Boolean);
    procedure SetCustomerOrgId(const Value: Integer);
    procedure SetDocDate(const Value: TDateTime);
    procedure SetDocNumber(const Value: string);
    procedure SetExecutorOrgId(const Value: Integer);
    procedure SetLayers(const Value: TmstProjectLayers);
    procedure SetLines(const Value: TmstProjectLines);
    procedure SetBlocks(const Value: TmstProjectBlocks);
    procedure SetCK36(const Value: Boolean);
    procedure SetPlaces(const Value: TmstProjectPlaces);
    procedure SetConfirmDate(const Value: TDateTime);
    procedure SetMaxX(const Value: Double);
    procedure SetMaxY(const Value: Double);
    procedure SetMinX(const Value: Double);
    procedure SetMinY(const Value: Double);
    procedure LoadMainData(DataSet: TDataSet);
    procedure SetCaption(const Value: string);
    procedure SetExchangeXY(const Value: Boolean);
  protected
    procedure AssignTo(Target: TPersistent); override;
    function GetObjectId: Integer; override;
    function GetText: String; override;
    procedure RefreshExchangeXY(); virtual;
    //
    procedure LoadLines(DataSet: TDataSet);
    procedure SaveLine(Conn: IIBXConnection; aLine: TmstProjectLine; var aState: TSaveLineState);
    procedure SaveLinePoint(Conn: IIBXConnection; aLine: TmstProjectLine; aPt: TmstProjectPoint; var aState: TSaveLineState);
    procedure LoadPlaces(DataSet: TDataSet);
    procedure SavePlace(Conn: IIBXConnection; aPlace: TmstProjectPlace; var aState: TSaveLineState);
  public
    constructor Create; override;
    destructor Destroy; override;
    //
    function Edit(const aCanSave: Boolean): Boolean; virtual;
    function Load(aDb: IDb): Boolean;
    function Save(aDb: IDb): Boolean;
    //
    procedure CalcExtent(); virtual;
    function IsMP(): Boolean; virtual;
    //
    property Blocks: TmstProjectBlocks read FBlocks write SetBlocks;
    property Layers: TmstProjectLayers read FLayers write SetLayers;
    property Lines: TmstProjectLines read FLines write SetLines;
    property Places: TmstProjectPlaces read FPlaces write SetPlaces;
    //
    property Address: string read FAddress write SetAddress;
    property DocNumber: string read FDocNumber write SetDocNumber;
    property DocDate: TDateTime read FDocDate write SetDocDate;
    property CustomerOrgId: Integer read FCustomerOrgId write SetCustomerOrgId;
    property ExecutorOrgId: Integer read FExecutorOrgId write SetExecutorOrgId;
    property Confirmed: Boolean read FConfirmed write SetConfirmed;
    property ConfirmDate: TDateTime read FConfirmDate write SetConfirmDate;
    property CK36: Boolean read FCK36 write SetCK36;
    property ExchangeXY: Boolean read FExchangeXY write SetExchangeXY;
    //
    property MinX: Double read FMinX write SetMinX;
    property MinY: Double read FMinY write SetMinY;
    property MaxX: Double read FMaxX write SetMaxX;
    property MaxY: Double read FMaxY write SetMaxY;
    //
    property Caption: string read FCaption write SetCaption;
  end;

  TmstProjectLayerListLoader = class
  private
    FList: TmstProjectLayers;
    FProjectId: Integer;
    procedure LoadLayers(DataSet, DataSetNetTypes: TDataSet);
  public
    procedure Load(aDb: IDb; aList: TmstProjectLayers; const aProjectId: Integer = 0); virtual;
  end;

  TmstProjectNetTypes = class
  private
    FList: TObjectList;
    function Get(Index: Integer): TmstProjectNetType;
  public
    constructor Create;
    destructor Destroy; override;
    //
    procedure Load(aDb: IDb);
    //
    function ById(const aId: Integer): TmstProjectNetType;
    function Count: Integer;
    property Items[Index: Integer]: TmstProjectNetType read Get;
  end;

  TmstProjectList = class(TmstObjectList)
  private
    function GetItems(Index: Integer): TmstProject;
    procedure SetItems(Index: Integer; const Value: TmstProject);
  public
    property Items[Index: Integer]: TmstProject read GetItems write SetItems; default;
  end;

  TProjectsSettings = class
  public
    class var FProjectId: Integer;
    class var FLineId: Integer;
  public
    class var PenWidth: Double;
    class function EntityIsCurrent(const Layer: TEzBaseLayer; const Recno: Integer): Boolean;
    class procedure SetCurrentProjectLine(aProjectId, aLineId: Integer);
  end;

  TMPSettings = class
  public
    class var FObjId: Integer;
  public
    class var PenWidth: Double;
    class procedure SetCurrentMPObj(const aObjId: Integer);
    class function IsCurrentObj(const aObjId: Integer): Boolean;
  end;

  IProjectSaver = interface
    ['{F3F9E055-E791-4370-A5B1-724ABF56EB54}']
    procedure Save(aDb: IDb; aProject: TmstProject);
  end;

  ImstObjectSaver = interface
    ['{00148F43-A979-42DD-A911-E595A519A912}']
    procedure Save(aDb: IDb; aObject: TmstObject);
  end;

  TGetProjectSaver = procedure (Sender: TObject; out aSaver: IProjectSaver) of object;
  TCreateProjectFunc = function (): TmstProject of object;

implementation

uses
  uMStDialogEditProject,
  uMStModuleApp;

const
  SQL_CHECK_PROJECT_EXISTS = 'SELECT ID FROM PROJECTS WHERE ID=:ID';
  SQL_INSERT_PROJECT =
      'insert into PROJECTS ' +
      '(ID, ADDRESS, DOC_NUMBER, DOC_DATE, CUSTOMER_ORGS_ID, CONFIRMED, EXECUTOR_ORGS_ID, CONFIRM_DATE, ' +
      ' MINX, MINY, MAXX, MAXY, CK36) ' +
      'values ' +
      '(:ID, :ADDRESS, :DOC_NUMBER, :DOC_DATE, :CUSTOMER_ORGS_ID, :CONFIRMED, :EXECUTOR_ORGS_ID, :CONFIRM_DATE, ' +
      ' :MINX, :MINY, :MAXX, :MAXY, :CK36)';
  SQL_UPDATE_PROJECT =
      'update PROJECTS ' +
      'set ADDRESS = :ADDRESS, ' +
      '    DOC_NUMBER = :DOC_NUMBER, ' +
      '    DOC_DATE = :DOC_DATE, ' +
      '    CUSTOMER_ORGS_ID = :CUSTOMER_ORGS_ID, ' +
      '    CONFIRMED = :CONFIRMED, ' +
      '    EXECUTOR_ORGS_ID = :EXECUTOR_ORGS_ID, ' +
      '    CONFIRM_DATE = :CONFIRM_DATE, ' +
      '    MINX = :MINX, ' +
      '    MINY = :MINY, ' +
      '    MAXX = :MAXX, ' +
      '    MAXY = :MAXY, ' +
      '    CK36 = :CK36 ' +
      'where (ID = :ID)';
  SQL_CHECK_LINE_EXISTS = 'SELECT ID FROM PROJECT_LINES WHERE ID=:ID';
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
  SQL_CHECK_PRJ_PLACE_EXISTS = 'SELECT ID FROM PROJECT_PLACES WHERE ID=:ID';
  SQL_INSERT_PRJ_PLACE =
      'insert into PROJECT_PLACES (ID, PROJECTS_ID, PROJECT_LAYERS_ID, EZDATA, EZ_ID) ' +
      'values (:ID, :PROJECTS_ID, :PROJECT_LAYERS_ID, :EZDATA, :EZ_ID)';
  SQL_UPDATE_PRJ_PLACE =
      'update PROJECT_PLACES ' +
      'set PROJECTS_ID = :PROJECTS_ID, ' +
      '    PROJECT_LAYERS_ID = :PROJECT_LAYERS_ID, ' +
      '    EZDATA = :EZDATA, ' +
      '    EZ_ID = :EZ_ID ' +
      'where (ID = :ID)';
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

{ TmstProject }

procedure TmstProject.AssignTo(Target: TPersistent);
var
  Tgt: TmstProject;
begin
  if not (Target is TmstProject) then
    inherited;
  Tgt := TmstProject(Target);
  Tgt.FBlocks.CopyFrom(Self.FBlocks);
  //
  Tgt.FLayers.CopyFrom(Self.Layers);
  //
  Tgt.FLines.CopyFrom(Self.Lines);
  //
  Tgt.FPlaces.CopyFrom(Self.Places);
  //
  Tgt.FAddress := Self.FAddress;
  Tgt.FCustomerOrgId := Self.FCustomerOrgId;
  Tgt.FExecutorOrgId := Self.FExecutorOrgId;
  Tgt.FDocNumber := Self.FDocNumber;
  Tgt.FDocDate := Self.FDocDate;
  Tgt.FConfirmed := Self.FConfirmed;
  Tgt.FConfirmDate := Self.FConfirmDate;
  Tgt.FCK36 := Self.FCK36;
  Tgt.FExchangeXY := Self.FExchangeXY;
  //
  Tgt.FMaxX := FMaxX;
  Tgt.FMaxY := FMaxY;
  Tgt.FMinX := FMinX;
  Tgt.FMinY := FMinY;
  //
  Tgt.FCaption := FCaption;
end;

procedure TmstProject.CalcExtent;
var
  I: Integer;
  J: Integer;
  Pt: TmstProjectPoint;
begin
  MinX := MaxInt;
  MinY := MaxInt;
  MaxX := 1 - MaxInt;
  MaxY := 1 - MaxInt;
  for I := 0 to Lines.Count - 1 do
  begin
    for J := 0 to Lines[I].Points.Count - 1 do
    begin
      Pt := Lines[I].Points[J];
      if MaxX < Pt.X then
       MaxX := Pt.X;
      if MinX > Pt.X then
       MinX := Pt.X;
      if MaxY < Pt.Y then
       MaxY := Pt.Y;
      if MinY > Pt.Y then
       MinY := Pt.Y;
    end;
  end;
  if (MinX = MaxInt) or (MinY = MaxInt) or (MaxX = 1 - MaxInt) or (MaxY = 1 - MaxInt) then
  begin
    MinX := 0;
    MaxX := 0;
    MinY := 0;
    MaxY := 0;
  end;
end;

constructor TmstProject.Create;
begin
  inherited;
  FBlocks := TmstProjectBlocks.Create;
  FLayers := TmstProjectLayers.Create;
  FLines := TmstProjectLines.Create(Self);
  FPlaces := TmstProjectPlaces.Create(Self);
end;

destructor TmstProject.Destroy;
begin
  FPlaces.Free;
  FLines.Free;
  FLayers.Free;
  FBlocks.Free;
  inherited;
end;

function TmstProject.Edit(const aCanSave: Boolean): Boolean;
var
  Frm: TmstEditProjectDialog;
begin
  Frm := TmstEditProjectDialog.Create(Application);
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

function TmstProject.GetObjectId: Integer;
begin
  Result := ID_PROJECT;
end;

function TmstProject.GetText: String;
begin
  Result := 'Проект';
  if DocNumber <> '' then
    Result := Result + ' №' + DocNumber;
  if DocDate > 0 then
    Result := Result + ' от ' + DateToStr(DocDate);
  Result := Result + ' ; ' + Address;
end;

function TmstProject.IsMP: Boolean;
begin
  Result := False;
end;

function TmstProject.Load(aDb: IDb): Boolean;
var
  Conn: IIBXConnection;
  DataSet: TDataSet;
  Loader: TmstProjectLayerListLoader;
begin
  Result := False;
  Conn := aDb.GetConnection(cmReadOnly, dmKis);
  DataSet := Conn.GetDataSet(SQL_LOAD_PROJECT);
  Conn.SetParam(DataSet, SF_ID, DatabaseId);
  DataSet.Open;
  if DataSet.IsEmpty then
    Exit;
  LoadMainData(DataSet);
  DataSet.Close;
  //
  Loader := TmstProjectLayerListLoader.Create;
  try
    Loader.Load(aDb, Self.Layers, Self.DatabaseId);
  finally
    Loader.Free;
  end;
  //
  DataSet := Conn.GetDataSet(SQL_LOAD_LINES);
  Conn.SetParam(DataSet, SF_ID, DatabaseId);
  DataSet.Open;
  if DataSet.IsEmpty then
    Exit;
  LoadLines(DataSet);
  DataSet.Close;
  //
  DataSet := Conn.GetDataSet(SQL_LOAD_PLACES);
  Conn.SetParam(DataSet, SF_ID, DatabaseId);
  DataSet.Open;
  if not DataSet.IsEmpty then
  begin
    LoadPlaces(DataSet);
    DataSet.Close;
  end;
  Result := True;
end;

procedure TmstProject.LoadLines(DataSet: TDataSet);
var
  L: TmstProjectLine;
  LineId: Integer;
  LayerId: Integer;
begin
  L := nil;
  while not DataSet.Eof do
  begin
    LineId := DataSet.FieldByName(SF_PROJECT_LINES_ID).AsInteger;
    if (L = nil) or (LineId <> L.DatabaseId) then
    begin
      L := Lines.Add;
      L.DatabaseId := LineId;
      L.FVoltage := DataSet.FieldByName(SF_VOLTAGE).AsString;
      L.FDiameter := DataSet.FieldByName(SF_DIAMETER).AsString;
      L.FInfo := DataSet.FieldByName(SF_INFO).AsString;
      LayerId := DataSet.FieldByName(SF_PROJECT_LAYERS_ID).AsInteger;
      L.Layer := Layers.ByDbId(LayerId);
    end;
    with L.Points.Add(DataSet.FieldByName(SF_X).AsFloat, DataSet.FieldByName(SF_Y).AsFloat) do
    begin
      Z := DataSet.FieldByName(SF_Z).AsFloat;
      DatabaseId := DataSet.FieldByName(SF_ID).AsInteger;
    end;
    DataSet.Next;
  end;
end;

procedure TmstProject.LoadMainData(DataSet: TDataSet);
begin
  FAddress := DataSet.FieldByName(SF_ADDRESS).AsString;
  FCustomerOrgId := DataSet.FieldByName(SF_CUSTOMER_ORGS_ID).AsInteger;
  FExecutorOrgId := DataSet.FieldByName(SF_EXECUTOR_ORGS_ID).AsInteger;
  FDocNumber := DataSet.FieldByName(SF_DOC_NUMBER).AsString;
  FDocDate := DataSet.FieldByName(SF_DOC_DATE).AsDateTime;
  FConfirmed := DataSet.FieldByName(SF_CONFIRMED).AsInteger = 1;
  FConfirmDate := DataSet.FieldByName(SF_CONFIRM_DATE).AsDateTime;
  FCK36 := DataSet.FieldByName(SF_CK36).AsInteger = 1;
  FMaxX := DataSet.FieldByName(SF_MAXX).AsFloat;
  FMaxY := DataSet.FieldByName(SF_MAXY).AsFloat;
  FMinX := DataSet.FieldByName(SF_MINX).AsFloat;
  FMinY := DataSet.FieldByName(SF_MINY).AsFloat;
end;

procedure TmstProject.LoadPlaces(DataSet: TDataSet);
var
  Pl: TmstProjectPlace;
  PlId: Integer;
  LayerId: Integer;
  Fld: TField;
begin
  while not DataSet.Eof do
  begin
    PlId := DataSet.FieldByName(SF_ID).AsInteger;
    Pl := Places.Add;
    Pl.DatabaseId := PlId;
    Pl.EzId := DataSet.FieldByName(SF_EZ_ID).AsInteger;
    Fld := DataSet.FieldByName(SF_EZDATA);
    if Fld is TBlobField then
      TBlobField(Fld).SaveToStream(Pl.EzData);
    LayerId := DataSet.FieldByName(SF_PROJECT_LAYERS_ID).AsInteger;
    Pl.Layer := Layers.ByDbId(LayerId);
    DataSet.Next;
  end;
end;

procedure TmstProject.RefreshExchangeXY;
begin

end;

function TmstProject.Save(aDb: IDb): Boolean;
var
  Conn: IIBXConnection;
  Ds2, DsMain: TDataSet;
  B1, B2: Boolean;
  Sql: string;
  I: Integer;
  L: TmstProjectLine;
  SaveLineState, SavePlaceState: TSaveLineState;
  Pl: TmstProjectPlace;
begin
  // создаём соединение
  Conn := aDb.GetConnection(cmReadWrite, dmKis);
  try
    B1 := DatabaseId < 1;
    if B1 then
    begin
      DatabaseId := Conn.GenNextValue(SG_PROJECTS);
      B2 := True;
    end
    else
    begin
      Ds2 := Conn.GetDataSet(SQL_CHECK_PROJECT_EXISTS);
      Conn.SetParam(Ds2, SF_ID, DatabaseId);
      Ds2.Open;
      B2 := Ds2.IsEmpty;
      Ds2.Close;
    end;
    if B2 then
      Sql := SQL_INSERT_PROJECT
    else
      Sql := SQL_UPDATE_PROJECT;
    DsMain := Conn.GetDataSet(Sql);
    Conn.SetParam(DsMain, SF_ID, DatabaseId);
    Conn.SetParam(DsMain, SF_ADDRESS, Address);
    Conn.SetParam(DsMain, SF_DOC_NUMBER, DocNumber);
    if DocDate <> 0 then
      Conn.SetParam(DsMain, SF_DOC_DATE, DocDate);
    Conn.SetParam(DsMain, SF_CUSTOMER_ORGS_ID, CustomerOrgId);
    Conn.SetParam(DsMain, SF_EXECUTOR_ORGS_ID, ExecutorOrgId);
    Conn.SetParam(DsMain, SF_CONFIRMED, IfThen(Confirmed, 1, 0));
    if ConfirmDate <> 0 then
      Conn.SetParam(DsMain, SF_CONFIRM_DATE, ConfirmDate);
    Conn.SetParam(DsMain, SF_CK36, IfThen(Ck36, 1, 0));
    Self.CalcExtent();
    Conn.SetParam(DsMain, SF_MINX, MinX);
    Conn.SetParam(DsMain, SF_MINY, MinY);
    Conn.SetParam(DsMain, SF_MAXX, MaxX);
    Conn.SetParam(DsMain, SF_MAXY, MaxY);
    Conn.ExecDataSet(DsMain);
    //
    //SaveLineState.Ds1 := nil;
    SaveLineState.Ds2 := nil;
    SaveLineState.DsMain1 := nil;
    SaveLineState.DsMain2 := nil;
    //SaveLineState.PtDs1 := nil;
    SaveLineState.PtDs2 := nil;
    SaveLineState.PtDsMain1 := nil;
    SaveLineState.PtDsMain2 := nil;
    for I := 0 to Lines.Count - 1 do
    begin
      L := Lines[I];
      SaveLine(Conn, L, SaveLineState);
    end;
    //
//    ShowMessage('SavePlace: ' + sLineBreak +
//              '  Total=' + IntToStr(Places.Count));
    //SavePlaceState.Ds1 := nil;
    SavePlaceState.Ds2 := nil;
    SavePlaceState.DsMain1 := nil;
    SavePlaceState.DsMain2 := nil;
    for I := 0 to Places.Count - 1 do
    begin
      Pl := Places[I];
      SavePlace(Conn, Pl, SavePlaceState);
    end;
  finally
//    Conn.Commit;
  end;
  Result := True;
end;

procedure TmstProject.SaveLine;
var
  B2: Boolean;
  //Ds1,
  Ds2, DsMain: TDataSet;
  I: Integer;
  Pt: TmstProjectPoint;
begin
  if aLine.DatabaseId < 1 then
  begin
    aLine.DatabaseId := Conn.GenNextValue(SG_PROJECT_LINES);
    B2 := True;
  end
  else
  begin
    if aState.Ds2 = nil then
      aState.Ds2 := Conn.GetDataSet(SQL_CHECK_LINE_EXISTS);
    Ds2 := aState.Ds2;
    Conn.SetParam(Ds2, SF_ID, aLine.DatabaseId);
    Ds2.Open;
    B2 := Ds2.Fields[0].AsInteger = 0;
    Ds2.Close;
  end;
  if B2 then
  begin
    if aState.DsMain1 = nil then
      aState.DsMain1 := Conn.GetDataSet(SQL_INSERT_LINE);
    DsMain := aState.DsMain1;
  end
  else
  begin
    if aState.DsMain2 = nil then
      aState.DsMain2 := Conn.GetDataSet(SQL_UPDATE_LINE);
    DsMain := aState.DsMain2;
  end;
  Conn.SetParam(DsMain, SF_ID, aLine.DatabaseId);
  Conn.SetParam(DsMain, SF_PROJECTS_ID, DatabaseId);
  Conn.SetParam(DsMain, SF_INFO, aLine.Info);
  Conn.SetParam(DsMain, SF_DIAMETER, aLine.Diameter);
  Conn.SetParam(DsMain, SF_VOLTAGE, aLine.Voltage);
  Conn.SetParam(DsMain, SF_PROJECT_LAYERS_ID, aLine.Layer.DatabaseId);
  Conn.ExecDataSet(DsMain);
  //
  for I := 0 to aLine.Points.Count - 1 do
  begin
    Pt := aLine.Points[I];
    SaveLinePoint(Conn, aLine, Pt, aState);
  end;
end;

procedure TmstProject.SaveLinePoint;
var
  B2: Boolean;
  //Ds1,
  Ds2, DsMain: TDataSet;
begin
 if aPt.DatabaseId < 1 then
  begin
    aPt.DatabaseId := Conn.GenNextValue(SG_PROJECT_LINE_POINTS);
    B2 := True;
  end
  else
  begin
    if aState.PtDs2 = nil then
      aState.PtDs2 := Conn.GetDataSet(SQL_CHECK_LINE_POINT_EXISTS);
    Ds2 := aState.PtDs2;
    Conn.SetParam(Ds2, SF_ID, aPt.DatabaseId);
    Ds2.Open;
    B2 := Ds2.Fields[0].AsInteger = 0;
    Ds2.Close;
  end;
  if B2 then
  begin
    if aState.PtDsMain1 = nil then
      aState.PtDsMain1 := Conn.GetDataSet(SQL_INSERT_LINE_POINT);
    DsMain := aState.PtDsMain1;
  end
  else
  begin
    if aState.PtDsMain2 = nil then
      aState.PtDsMain2 := Conn.GetDataSet(SQL_UPDATE_LINE_POINT);
    DsMain := aState.PtDsMain2;
  end;
  Conn.SetParam(DsMain, SF_ID, aPt.DatabaseId);
//  Conn.SetParam(DsMain, SF_NAME, aPt.Name);
  Conn.SetParam(DsMain, SF_X, aPt.X);
  Conn.SetParam(DsMain, SF_Y, aPt.Y);
  Conn.SetParam(DsMain, SF_Z, aPt.Z);
  Conn.SetParam(DsMain, SF_PROJECT_LINES_ID, aLine.DatabaseId);
  Conn.ExecDataSet(DsMain);
end;

procedure TmstProject.SavePlace(Conn: IIBXConnection; aPlace: TmstProjectPlace; var aState: TSaveLineState);
var
  B2: Boolean;
  //Ds1,
  Ds2, DsMain: TDataSet;
  LayerId: Integer;
//  Id1, Id2: Integer;
begin
//  ShowMessage('SavePlace: ' + sLineBreak +
//              'Start' + sLineBreak +
//              '  ID=' + IntToStr(Id1) + sLineBreak +
//              '  EzId=' + IntToStr(aPlace.EzId));
//  B2 := False;
//  Id1 := aPlace.DatabaseId;
  if aPlace.DatabaseId < 1 then
  begin
    aPlace.DatabaseId := Conn.GenNextValue(SG_PROJECT_PLACES_GEN);
    B2 := True;
  end
  else
  begin
    if aState.Ds2 = nil then
      aState.Ds2 := Conn.GetDataSet(SQL_CHECK_PRJ_PLACE_EXISTS);
    Ds2 := aState.Ds2;
    Conn.SetParam(Ds2, SF_ID, aPlace.DatabaseId);
    Ds2.Open;
    B2 := Ds2.Fields[0].AsInteger = 0;
    Ds2.Close;
  end;
//  Id2 := aPlace.DatabaseId;
//  ShowMessage('Place: ' + sLineBreak +
//              '  ID=' + IntToStr(Id1) + sLineBreak +
//              '  NewId=' + IntToStr(Id2) + sLineBreak +
//              '  EzId=' + IntToStr(aPlace.EzId));
  if B2 then
  begin
    if aState.DsMain1 = nil then
      aState.DsMain1 := Conn.GetDataSet(SQL_INSERT_PRJ_PLACE);
    DsMain := aState.DsMain1;
  end
  else
  begin
    if aState.DsMain2 = nil then
      aState.DsMain2 := Conn.GetDataSet(SQL_UPDATE_PRJ_PLACE);
    DsMain := aState.DsMain2;
  end;
  Conn.SetParam(DsMain, SF_ID, aPlace.DatabaseId);
  Conn.SetParam(DsMain, SF_PROJECTS_ID, DatabaseId);
  Conn.SetParam(DsMain, SF_EZ_ID, aPlace.EzId);
  Conn.SetBlobParam(DsMain, SF_EZDATA, aPlace.EzData);
  if Assigned(aPlace.Layer) then
    LayerId := aPlace.Layer.DatabaseId
  else
    LayerId := -1;
  Conn.SetParam(DsMain, SF_PROJECT_LAYERS_ID, LayerId);
  Conn.ExecDataSet(DsMain);
end;

procedure TmstProject.SetAddress(const Value: string);
begin
  FAddress := Value;
end;

procedure TmstProject.SetBlocks(const Value: TmstProjectBlocks);
begin
  FBlocks := Value;
end;

procedure TmstProject.SetCaption(const Value: string);
begin
  FCaption := Value;
end;

procedure TmstProject.SetCK36(const Value: Boolean);
begin
  FCK36 := Value;
  RefreshExchangeXY();
end;

procedure TmstProject.SetConfirmDate(const Value: TDateTime);
begin
  FConfirmDate := Value;
end;

procedure TmstProject.SetConfirmed(const Value: Boolean);
begin
  FConfirmed := Value;
end;

procedure TmstProject.SetCustomerOrgId(const Value: Integer);
begin
  FCustomerOrgId := Value;
end;

procedure TmstProject.SetDocDate(const Value: TDateTime);
begin
  FDocDate := Value;
end;

procedure TmstProject.SetDocNumber(const Value: string);
begin
  FDocNumber := Value;
end;

procedure TmstProject.SetExchangeXY(const Value: Boolean);
begin
  FExchangeXY := Value;
  RefreshExchangeXY();
end;

procedure TmstProject.SetExecutorOrgId(const Value: Integer);
begin
  FExecutorOrgId := Value;
end;

procedure TmstProject.SetLayers(const Value: TmstProjectLayers);
begin
  FLayers := Value;
end;

procedure TmstProject.SetLines(const Value: TmstProjectLines);
begin
  FLines := Value;
end;

procedure TmstProject.SetMaxX(const Value: Double);
begin
  FMaxX := Value;
end;

procedure TmstProject.SetMaxY(const Value: Double);
begin
  FMaxY := Value;
end;

procedure TmstProject.SetMinX(const Value: Double);
begin
  FMinX := Value;
end;

procedure TmstProject.SetMinY(const Value: Double);
begin
  FMinY := Value;
end;

procedure TmstProject.SetPlaces(const Value: TmstProjectPlaces);
begin
  FPlaces := Value;
end;

{ TmstProjectLine }

procedure TmstProjectLine.AssignTo(Target: TPersistent);
var
  Tgt: TmstProjectLine;
begin
  if not (Target is TmstProjectLine) then
    inherited;
  Tgt := TmstProjectLine(Target);
  Tgt.FNetType := Self.FNetType;
  Tgt.FVoltage := Self.FVoltage;
  Tgt.FDiameter := Self.FDiameter;
  Tgt.FInfo := Self.FInfo;
  Tgt.FPoints.CopyFrom(Self.Points);
  if Assigned(Self.Layer) then
    Tgt.FLayer := Tgt.Owner.Layers.ByDbId(Self.Layer.DatabaseId)
  else
    Tgt.FLayer := nil;
  Tgt.FEntityId := Self.FEntityId;
  Tgt.DatabaseId := Self.DatabaseId;
end;

procedure TmstProjectLine.BuildZone(aZoneWidth: Double);
var
  Bldr: TBufferZoneBuilderPoly2;
  Points: TEzVector;
  I: Integer;
begin
  FreeAndNil(FZoneLine);
  FZoneWidth := aZoneWidth;
  //
  Points := TEzVector.Create(1);
  Points.CanGrow := True;
  Points.Forget();
  for I := 0 to Self.Points.Count - 1 do
  begin
    Points.AddPoint(Self.Points[I].X, Self.Points[I].Y);
  end;
  //
  Bldr := TBufferZoneBuilderPoly2.Create;
  Bldr.Forget();
  Bldr.Width := aZoneWidth;
  Bldr.Build(Points);
  if Bldr.Buffer.Count > 1 then
  begin
    FZoneLine := TmstProjectLine.Create;
    for I := 0 to Bldr.Buffer.Count - 1 do
    begin
      FZoneLine.Points.Add(Bldr.Buffer[I].X, Bldr.Buffer[I].Y);
    end;
  end;
end;

constructor TmstProjectLine.Create;
begin
  inherited;
  FPoints := TmstProjectLinePoints.Create;
end;

destructor TmstProjectLine.Destroy;
begin
  FPoints.Free;
  FreeAndNil(FZoneLine);
  FreeAndNil(FZone);
  inherited;
end;

function TmstProjectLine.GetLength: Double;
var
  L: Double;
  dX, dY: Double;
  Pt1, Pt2: TmstProjectPoint;
  I, J: Integer;
begin
  Result := 0;
  if Points.Count > 1 then
  begin
    J := 0;
    for I := 1 to Points.Count - 1 do
    begin
      Pt1 := Points[J];
      Pt2 := Points[I];
      dX := Abs(Pt1.X - Pt2.X);
      dY := Abs(Pt1.Y - Pt2.Y);
      L := Sqrt(dX * dX + dY + dY);
      Result := Result + L;
    end;
  end;
end;

function TmstProjectLine.GetZDelta: Double;
var
  L: Double;
  Pt1, Pt2: TmstProjectPoint;
begin
  Result := 0;
  if Points.Count > 1 then
  begin
    Pt1 := Points.First;
    Pt2 := Points.Last;
    L := GetLength();
    if L >= 0.01 then
      Result := Abs(Pt1.Z - Pt2.Z) / L;
  end;
end;

procedure TmstProjectLine.SetDiameter(const Value: string);
begin
  FDiameter := Value;
end;

procedure TmstProjectLine.SetEntityId(const Value: Integer);
begin
  FEntityId := Value;
end;

procedure TmstProjectLine.SetInfo(const Value: string);
begin
  FInfo := Value;
end;

procedure TmstProjectLine.SetLayer(const Value: TmstProjectLayer);
begin
  FLayer := Value;
end;

procedure TmstProjectLine.SetNetType(const Value: Integer);
begin
  FNetType := Value;
end;

procedure TmstProjectLine.SetOwner(const Value: TmstProject);
begin
  FOwner := Value;
end;

procedure TmstProjectLine.SetVoltage(const Value: string);
begin
  FVoltage := Value;
end;

procedure TmstProjectLine.SetZone(const Value: TEzEntity);
begin
  if FZone <> Value then
  begin
    FreeAndNil(FZone);
    FZone := Value;
  end;
end;

procedure TmstProjectLine.SetZoneLine(const Value: TmstProjectLine);
begin
  if FZoneLine <> Value then
  begin
    FreeAndNil(FZoneLine);
    FZoneLine := Value;
  end;
end;

procedure TmstProjectLine.SetZoneWidth(const Value: Double);
begin
  FZoneWidth := Value;
end;

{ TmstProjectPoint }

procedure TmstProjectPoint.SetName(const Value: string);
begin
  FName := Value;
end;

procedure TmstProjectPoint.SetX(const Value: Double);
begin
  FX := Value;
end;

procedure TmstProjectPoint.SetY(const Value: Double);
begin
  FY := Value;
end;

procedure TmstProjectPoint.SetZ(const Value: Double);
begin
  FZ := Value;
end;

{ TmstProjectLinePoints }

function TmstProjectLinePoints.Add(const X, Y: Double): TmstProjectPoint;
begin
  Result := TmstProjectPoint.Create;
  inherited Add(Result);
  Result.X := X;
  Result.Y := Y;
end;

procedure TmstProjectLinePoints.CopyFrom(Source: TmstProjectLinePoints);
var
  I: Integer;
  Pt: TmstProjectPoint;
begin
  Clear();
  for I := 0 to Source.Count - 1 do
  begin
    Pt := Source[I];
    with Add(Pt.X, Pt.Y) do
    begin
      Z := Pt.Z;
      Name := Pt.Name;
      DatabaseId := Pt.DatabaseId;
    end;
  end;
end;

function TmstProjectLinePoints.First: TmstProjectPoint;
begin
  Result := TmstProjectPoint(inherited First);
end;

function TmstProjectLinePoints.GetItems(Index: Integer): TmstProjectPoint;
begin
  Result := TmstProjectPoint(inherited Items[Index]);
end;

function TmstProjectLinePoints.GetZDelta(I: Integer): Double;
var
  L: Double;
  dX, dY: Double;
begin
  Result := 0;
  if I > 0 then
    if I < Count then
    begin
      dX := Abs(Items[I].X - Items[I - 1].X);
      dY := Abs(Items[I].Y - Items[I - 1].Y);
      L := Sqrt(dX * dX + dY + dY);
      if L >= 0.01 then
        Result := Abs(Items[I].Z - Items[I - 1].Z) / L;
    end;
end;

function TmstProjectLinePoints.Last: TmstProjectPoint;
begin
  Result := TmstProjectPoint(inherited Last);
end;

procedure TmstProjectLinePoints.SetItems(Index: Integer; const Value: TmstProjectPoint);
begin
  inherited Items[Index] := Value;
end;

{ TmstProjectLayer }

procedure TmstProjectLayer.AssignTo(Target: TPersistent);
var
  Tgt: TmstProjectLayer;
begin
  if not (Target is TmstProjectLayer) then
    inherited;
  Tgt := TmstProjectLayer(Target);
  Tgt.FName := Self.FName;
  Tgt.FActive := Self.Active;
  Tgt.FRequired := Self.FRequired;
  Tgt.FDestroyed := Self.FDestroyed;
  Tgt.FLineType := Self.FLineType;
  Tgt.DatabaseId := Self.DatabaseId;
  Tgt.FMPLayerId := Self.FMPLayerId;
  Self.NetType.AssignTo(Tgt.NetType);
end;

constructor TmstProjectLayer.Create;
begin
  inherited;
  FNetType := TmstProjectNetType.Create;
end;

destructor TmstProjectLayer.Destroy;
begin
  FreeAndNil(FNetType);
  inherited;
end;

procedure TmstProjectLayer.SetActive(const Value: Boolean);
begin
  FActive := Value;
end;

procedure TmstProjectLayer.SetDestroyed(const Value: Boolean);
begin
  FDestroyed := Value;
end;

procedure TmstProjectLayer.SetLineType(const Value: Boolean);
begin
  FLineType := Value;
end;

procedure TmstProjectLayer.SetMPLayerId(const Value: Integer);
begin
  FMPLayerId := Value;
end;

procedure TmstProjectLayer.SetName(const Value: string);
begin
  FName := Value;
end;

procedure TmstProjectLayer.SetNetType(const Value: TmstProjectNetType);
begin
  FNetType := Value;
end;

procedure TmstProjectLayer.SetRequired(const Value: Boolean);
begin
  FRequired := Value;
end;

{ TmstProjectLayers }

function TmstProjectLayers.Add(const aName: string; aDestroyed, aRequired, aLineType: Boolean): TmstProjectLayer;
begin
  Result := TmstProjectLayer.Create();
  inherited Add(Result);
  Result.FName := aName;
  Result.FRequired := aRequired;
  Result.FDestroyed := aDestroyed;
  Result.FLineType := aLineType;  
end;

function TmstProjectLayers.Add(const Source: TmstProjectLayer): TmstProjectLayer;
begin
  Result := TmstProjectLayer.Create();
  inherited Add(Result);
  Result.Assign(Source);
end;

function TmstProjectLayers.ByDbId(DbId: Integer): TmstProjectLayer;
var
  I: Integer;
begin
  for I := 0 to Count - 1 do
    if Items[I].DatabaseId = DbId then
    begin
      Result := Items[I];
      Exit;
    end;
  Result := nil;
end;

function TmstProjectLayers.ByName(aName: String): TmstProjectLayer;
var
  I: Integer;
begin
  for I := 0 to Count - 1 do
    if Items[I].Name = aName then
    begin
      Result := Items[I];
      Exit;
    end;
  Result := nil;
end;

procedure TmstProjectLayers.CopyFrom(Source: TmstProjectLayers);
var
  I: Integer;
  Src, Tgt: TmstProjectLayer;
begin
  Clear();
  for I := 0 to Source.Count - 1 do
  begin
    Src := Source[I];
    Tgt := TmstProjectLayer.Create;
    inherited Add(Tgt);
    Tgt.Assign(Src);
  end;
end;

function TmstProjectLayers.GetItems(Index: Integer): TmstProjectLayer;
begin
  Result := TmstProjectLayer(inherited Items[Index]);
end;

procedure TmstProjectLayers.SetItems(Index: Integer; const Value: TmstProjectLayer);
begin
  inherited Items[Index] := Value;
end;

{ TmstProjectBlock }

procedure TmstProjectBlock.AssignTo(Target: TPersistent);
var
  Tgt: TmstProjectBlock;
begin
  if not (Target is TmstProjectBlock) then
    inherited;
  Tgt := TmstProjectBlock(Target);
  Tgt.FName := Self.FName;
  Tgt.FSymbolId := Self.FSymbolId;
  Tgt.FEzData.Size := 0;
  Self.FEzData.Position := 0;
  Tgt.FEzData.CopyFrom(Self.FEzData, Self.FEzData.Size);
  Tgt.FEzData.Position := 0;
  Self.FEzData.Position := 0;
  Tgt.DatabaseId := Self.DatabaseId;
end;

constructor TmstProjectBlock.Create;
begin
  inherited;
  FEzData := TMemoryStream.Create;
end;

destructor TmstProjectBlock.Destroy;
begin
  FEzData.Free;
  inherited;
end;

procedure TmstProjectBlock.SetName(const Value: string);
begin
  FName := Value;
end;

procedure TmstProjectBlock.SetSymbolId(const Value: Integer);
begin
  FSymbolId := Value;
end;

{ TmstProjectBlocks }

function TmstProjectBlocks.ByName(const BlockName: string): TmstProjectBlock;
var
  I: Integer;
begin
  for I := 0 to Count - 1 do
    if Items[I].Name = BlockName then
    begin
      Result := Items[I];
      Exit;
    end;
  Result := nil;
end;

procedure TmstProjectBlocks.CopyFrom(Source: TmstProjectBlocks);
var
  Src, Tgt: TmstProjectBlock;
  I: Integer;
begin
  Clear();
  for I := 0 to Source.Count - 1 do
  begin
    Src := Source[I];
    Tgt := TmstProjectBlock.Create;
    Self.Add(Tgt);
    Tgt.Assign(Src);
  end;
end;

function TmstProjectBlocks.GetItems(Index: Integer): TmstProjectBlock;
begin
  Result := TmstProjectBlock(inherited Items[Index]);
end;

procedure TmstProjectBlocks.SetItems(Index: Integer; const Value: TmstProjectBlock);
begin
  inherited Items[Index] := Value;
end;

{ TmstProjectPlace }

procedure TmstProjectPlace.AssignTo(Target: TPersistent);
var
  Tgt: TmstProjectPlace;
begin
  if not (Target is TmstProjectPlace) then
    inherited;
  Tgt := TmstProjectPlace(Target);
  //
  Tgt.FEntityId := Self.FEntityId;
  //
  Tgt.FData.Size := 0;
  Self.FData.Position := 0;
  Tgt.FData.CopyFrom(Self.FData, Self.FData.Size);
  Tgt.FData.Position := 0;
  Self.FData.Position := 0;
  Tgt.FEzId := Self.FEzId;
  //
  if Assigned(Self.FLayer) then
    Tgt.FLayer := Tgt.Owner.Layers.ByDbId(Self.Layer.DatabaseId)
  else
    Tgt.FLayer := nil;
  //
  Tgt.DatabaseId := Self.DatabaseId;
end;

constructor TmstProjectPlace.Create;
begin
  inherited;
  FData := TMemoryStream.Create;
  FEzId := -1;
end;

destructor TmstProjectPlace.Destroy;
begin
  FData.Free;
  inherited;
end;

procedure TmstProjectPlace.SetEntityId(const Value: Integer);
begin
  FEntityId := Value;
end;

procedure TmstProjectPlace.SetEzId(const Value: Integer);
begin
  FEzId := Value;
end;

procedure TmstProjectPlace.SetLayer(const Value: TmstProjectLayer);
begin
  FLayer := Value;
end;

procedure TmstProjectPlace.SetOwner(const Value: TmstProject);
begin
  FOwner := Value;
end;

{ TmstProjectPlaces }

function TmstProjectPlaces.Add: TmstProjectPlace;
begin
  Result := TmstProjectPlace.Create;
  inherited Add(Result);
  Result.Owner := FOwner;
end;

procedure TmstProjectPlaces.CopyFrom(Source: TmstProjectPlaces);
var
  Src, Tgt: TmstProjectPlace;
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

constructor TmstProjectPlaces.Create(aOwner: TmstProject);
begin
  inherited Create;
  FOwner := aOwner;
end;

procedure TmstProjectPlaces.DeletePlace(const DbId: Integer);
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

function TmstProjectPlaces.GetItems(Index: Integer): TmstProjectPlace;
begin
  Result := TmstProjectPlace(inherited Items[Index]);
end;

procedure TmstProjectPlaces.SetItems(Index: Integer; const Value: TmstProjectPlace);
begin
  inherited Items[Index] := Value;
end;

{ TmstProjectLines }

function TmstProjectLines.Add: TmstProjectLine;
begin
  Result := TmstProjectLine.Create;
  inherited Add(Result);
  Result.Owner := FOwner;
end;

function TmstProjectLines.ByDbId(const DbId: Integer): TmstProjectLine;
var
  I: Integer;
begin
  for I := 0 to Count - 1 do
    if Items[I].DatabaseId = DbId then
    begin
      Result := Items[I];
      Exit;
    end;
  Result := nil;
end;

procedure TmstProjectLines.CopyFrom;
var
  Src, Tgt: TmstProjectLine;
  I: Integer;
begin
  Clear();
  for I := 0 to Source.Count - 1 do
  begin
    Src := Source[I];
    Tgt := Self.Add;
    Tgt.Assign(Src);
  end;
end;

constructor TmstProjectLines.Create(aOwner: TmstProject);
begin
  inherited Create;
  FOwner := aOwner;
end;

procedure TmstProjectLines.DeleteLine(const DbId: Integer);
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

function TmstProjectLines.GetItems(Index: Integer): TmstProjectLine;
begin
  Result := TmstProjectLine(inherited Items[Index]);
end;

procedure TmstProjectLines.SetItems(Index: Integer; const Value: TmstProjectLine);
begin
  inherited Items[Index] := Value;
end;

{ TmstProjectNetType }

procedure TmstProjectNetType.AssignTo(Target: TPersistent);
var
  Tgt: TmstProjectNetType;
begin
  Tgt := TmstProjectNetType(Target);
  Tgt.DatabaseId := DatabaseId;
  Tgt.Name := Name;
  Tgt.Color := Color;
  Tgt.ZoneWidth := ZoneWidth;
  Tgt.Visible := Visible;
end;

constructor TmstProjectNetType.Create;
begin
  inherited;
  FVisible := True;
end;

function TmstProjectNetType.GetColor: TColor;
begin
  Result := clBlack;
  if Color <> '' then
  begin
    try
      Result := StrToInt(Color);
    except
      Result := clBlack;
    end;
  end;
end;

procedure TmstProjectNetType.SetColor(const Value: string);
begin
  FColor := Value;
end;

procedure TmstProjectNetType.SetName(const Value: string);
begin
  FName := Value;
end;

procedure TmstProjectNetType.SetVisible(const Value: Boolean);
begin
  FVisible := Value;
end;

procedure TmstProjectNetType.SetZoneWidth(const Value: Double);
begin
  FZoneWidth := Value;
end;

{ TmstProjectLayerListLoader }

procedure TmstProjectLayerListLoader.Load(aDb: IDb; aList: TmstProjectLayers; const aProjectId: Integer);
var
  Conn: IIBXConnection;
  DataSet: TDataSet;
  DataSetNetTypes: TDataSet;
begin
  FList := aList;
  FProjectId := aProjectId;
  Conn := aDb.GetConnection(cmReadOnly, dmKis);
  if aProjectId > 0 then
  begin
    DataSet := Conn.GetDataSet(SQL_LOAD_LAYERS_FOR_LINES);
    Conn.SetParam(DataSet, SF_ID, aProjectId);
    DataSet.Open;
    DataSetNetTypes := Conn.GetDataSet(SQL_LOAD_PROJECT_NET_TYPES);
    try
      if not DataSet.IsEmpty then
      begin
        DataSetNetTypes.Open;
        LoadLayers(DataSet, DataSetNetTypes);
        DataSet.Close;
      end;
      //
      DataSet := Conn.GetDataSet(SQL_LOAD_LAYERS_FOR_PLACES);
      Conn.SetParam(DataSet, SF_ID, aProjectId);
      DataSet.Open;
      if DataSet.IsEmpty then
        Exit;
      DataSetNetTypes.Active := True;
      LoadLayers(DataSet, DataSetNetTypes);
      DataSet.Close;
    finally
      DataSetNetTypes.Active := False;
    end;
  end
  else
  begin
    DataSet := Conn.GetDataSet(SQL_PROJECT_LAYERS_ALL);
    DataSet.Open;
    if DataSet.IsEmpty then
      Exit;
    DataSetNetTypes := Conn.GetDataSet(SQL_LOAD_PROJECT_NET_TYPES);
    DataSetNetTypes.Open;
    LoadLayers(DataSet, DataSetNetTypes);
    DataSetNetTypes.Close;
    DataSet.Close;
  end;
end;

procedure TmstProjectLayerListLoader.LoadLayers(DataSet, DataSetNetTypes: TDataSet);
var
  L: TmstProjectLayer;
  NetTypeId, DbId: Integer;
begin
  while not DataSet.Eof do
  begin
    DbId := DataSet.FieldByName(SF_ID).AsInteger;
    if FList.ByDbId(DbId) = nil then
    begin
      L := FList.Add(DataSet.FieldByName(SF_NAME).AsString,
                     DataSet.FieldByName(SF_DESTROYED).AsInteger = 1,
                     DataSet.FieldByName(SF_REQUIRED).AsInteger = 1,
                     DataSet.FieldByName(SF_OBJECT_TYPE).AsInteger = 0);
      L.Active := DataSet.FieldByName(SF_ACTUAL).AsInteger = 1;
      L.DatabaseId := DbId;
      L.MPLayerId := DataSet.FieldByName(SF_MP_NET_TYPES_ID).AsInteger;
      NetTypeId := DataSet.FieldByName(SF_NET_TYPES_ID).AsInteger;
      if NetTypeId > 0 then
      begin
        DataSetNetTypes.First;
        if DataSetNetTypes.Locate(SF_ID, NetTypeId, []) then
        begin
          L.NetType.DatabaseId := DataSetNetTypes.FieldByName(SF_ID).AsInteger;
          L.NetType.Name := DataSetNetTypes.FieldByName(SF_NAME).AsString;
          L.NetType.Color := DataSetNetTypes.FieldByName(SF_COLOR).AsString;
          L.NetType.ZoneWidth := DataSetNetTypes.FieldByName(SF_ZONE_WIDTH).AsFloat;
        end;
      end;
    end;
    DataSet.Next;
  end;
end;

{ TmstProjectList }

function TmstProjectList.GetItems(Index: Integer): TmstProject;
begin
  Result := TmstProject(inherited Items[Index]);
end;

procedure TmstProjectList.SetItems(Index: Integer; const Value: TmstProject);
begin
  inherited Items[Index] := Value;
end;

{ TmstProjectNetTypes }

function TmstProjectNetTypes.ById(const aId: Integer): TmstProjectNetType;
var
  I: Integer;
begin
  for I := 0 to FList.Count - 1 do
    if Items[I].DatabaseId = aId then
    begin
      Result := Items[I];
      Exit;
    end;
  Result := nil;
end;

function TmstProjectNetTypes.Count: Integer;
begin
  Result := FList.Count;
end;

constructor TmstProjectNetTypes.Create;
begin
  FList := TObjectList.Create;
end;

destructor TmstProjectNetTypes.Destroy;
begin
  FList.Free;
  inherited;
end;

function TmstProjectNetTypes.Get(Index: Integer): TmstProjectNetType;
begin
  Result := TmstProjectNetType(FList[Index]);
end;

procedure TmstProjectNetTypes.Load(aDb: IDb);
var
  Conn: IIBXConnection;
  DataSet: TDataSet;
  NetType: TmstProjectNetType;
begin
  FList.Clear;
  Conn := aDb.GetConnection(cmReadOnly, dmKis);
  DataSet := Conn.GetDataSet(SQL_LOAD_PROJECT_NET_TYPES);
  DataSet.Open;
  if DataSet.IsEmpty then
    Exit;
  while not DataSet.Eof do
  begin
    NetType := TmstProjectNetType.Create;
    FList.Add(NetType);
    NetType.DatabaseId := DataSet.FieldByName(SF_ID).AsInteger;
    NetType.Name := DataSet.FieldByName(SF_NAME).AsString;
    NetType.Color := DataSet.FieldByName(SF_COLOR).AsString;
    NetType.ZoneWidth := DataSet.FieldByName(SF_ZONE_WIDTH).AsFloat;
    DataSet.Next;
  end;
  DataSet.Close;
end;

{ TProjectsSettings }

class function TProjectsSettings.EntityIsCurrent(const Layer: TEzBaseLayer; const Recno: Integer): Boolean;
var
  Idx1, Idx2: Integer;
  PrjId, LineId: Integer;
begin
  Result := False;
  if FProjectId < 0 then
    Exit;
  if FLineId < 0 then
    Exit;
  if Assigned(Layer.DBTable) then
  begin
    Idx1 := Layer.DBTable.FieldNo(SF_PROJECT_ID);
    if Idx1 > 0 then
    begin
      PrjId := Layer.DBTable.IntegerGet(SF_PROJECT_ID);
      if PrjId = FProjectId then
      begin
        Idx2 := Layer.DBTable.FieldNo(SF_LINE_ID);
        if Idx2 > 0 then
        begin
          LineId := Layer.DBTable.IntegerGet(SF_LINE_ID);
          Result := LineId = FLineId;
        end;
      end;
    end;
  end;
end;

class procedure TProjectsSettings.SetCurrentProjectLine(aProjectId, aLineId: Integer);
begin
  FProjectId := aProjectId;
  FLineId := aLineId;
end;

{ TMPSettings }

class function TMPSettings.IsCurrentObj(const aObjId: Integer): Boolean;
begin
  Result := FObjId = aObjId;
end;

class procedure TMPSettings.SetCurrentMPObj(const aObjId: Integer);
begin
  FObjId := aObjId;
end;

initialization
  TProjectsSettings.PenWidth := 2;
  TMPSettings.PenWidth := 2;

end.
