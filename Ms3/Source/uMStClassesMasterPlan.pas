unit uMStClassesMasterPlan;

interface

uses
  SysUtils, Classes, Contnrs,
  uMStKernelClasses,
  uMStClassesProjects;

type
  TmstMPClass = class
  private
    FLayerName: string;
    FId: Integer;
    FLayerId: Integer;
    procedure SetId(const Value: Integer);
    procedure SetLayerId(const Value: Integer);
    procedure SetLayerName(const Value: string);
  public
    constructor Create(aId, aLayerId: Integer; aLayerName: string);
    //
    property Id: Integer read FId write SetId;
    property LayerName: string read FLayerName write SetLayerName;
    property LayerId: Integer read FLayerId write SetLayerId;
  end;

  TmstMPClasses = class
  private
    FList: TObjectList;
    function GetItems(Index: Integer): TmstMPClass;
    procedure PrepareList();
  public
    constructor Create;
    destructor Destroy; override;
    //
    property Items[Index: Integer]: TmstMPClass read GetItems;
    function Count: Integer;
  end;

  TmstMPStatus = (
    mpsPlanned = 1,
    mpsPlannedConfirmed = 2,
    mpsDrawn = 3);

  TmstMPOrganisation = class
  private
    FName: string;
    FId: Integer;
    procedure SetId(const Value: Integer);
    procedure SetName(const Value: string);
  public
    property Name: string read FName write SetName;
    property Id: Integer read FId write SetId;
  end;

  TmstMasterPlanSemantic = class
  private
    FArchived: Boolean;
    FMPClass: TmstMPClass;
    FStatus: TmstMPStatus;
    FMPClassId: Integer;
    FDismantled: Boolean;
    FConfirmed: Boolean;
    FMaterial: string;
    FVoltage: Integer;
    FProjectName: string;
    FOwner: string;
    FUnderground: Boolean;
    FRotation: Integer;
    FCustomer: TmstMPOrganisation;
    FExecutor: TmstMPOrganisation;
    FDrawDate: TDateTime;
    FPipeCount: Integer;
    FDrawer: TmstMPOrganisation;
    FFloor: string;
    FBottom: string;
    FDiameter: Integer;
    FRequestNumber: string;
    FProjectNumber: string;
    FAddress: string;
    FTop: string;
    procedure SetArchived(const Value: Boolean);
    procedure SetDismantled(const Value: Boolean);
    procedure SetMPClass(const Value: TmstMPClass);
    procedure SetMPClassId(const Value: Integer);
    procedure SetStatus(const Value: TmstMPStatus);
    procedure SetConfirmed(const Value: Boolean);
    procedure SetAddress(const Value: string);
    procedure SetBottom(const Value: string);
    procedure SetCustomer(const Value: TmstMPOrganisation);
    procedure SetDiameter(const Value: Integer);
    procedure SetDrawDate(const Value: TDateTime);
    procedure SetDrawer(const Value: TmstMPOrganisation);
    procedure SetExecutor(const Value: TmstMPOrganisation);
    procedure SetFloor(const Value: string);
    procedure SetMaterial(const Value: string);
    procedure SetOwner(const Value: string);
    procedure SetPipeCount(const Value: Integer);
    procedure SetProjectName(const Value: string);
    procedure SetProjectNumber(const Value: string);
    procedure SetRequestNumber(const Value: string);
    procedure SetRotation(const Value: Integer);
    procedure SetTop(const Value: string);
    procedure SetUnderground(const Value: Boolean);
    procedure SetVoltage(const Value: Integer);
  public
    // тип по классификатору (classid):
    property MPClassId: Integer read FMPClassId write SetMPClassId;
	  // расшифровка по классификатору:
		property MPClass: TmstMPClass read FMPClass write SetMPClass;
    //	- состояние сети:
//		1 – проектные;
//		2 – проектные (выдана справка);
//		3 – нанесенные (принятые от геодезистов);
    property Status: TmstMPStatus read FStatus write SetStatus;
    //	- демонтированная:
    property Dismantled: Boolean read FDismantled write SetDismantled;
    //- архивная:
    property Archived: Boolean read FArchived write SetArchived;
    //- согласованна:
    property Confirmed: Boolean read FConfirmed write SetConfirmed;
//	- адрес:
    property Address: string read FAddress write SetAddress;
//	- номер проекта;
    property ProjectNumber: string read FProjectNumber write SetProjectNumber;
//	- название проекта;
    property ProjectName: string read FProjectName write SetProjectName;
//	- номер заявки:
    property RequestNumber: string read FRequestNumber write SetRequestNumber;
//	- угол поворота объекта (в градусах + по часовой):
    property Rotation: Integer read FRotation write SetRotation;
//- Характеристики
//	- подземные:
    property Underground: Boolean read FUnderground write SetUnderground;
//	- диаметр:
    property Diameter: Integer read FDiameter write SetDiameter;
//	- количество проводов/труб:
    property PipeCount: Integer read FPipeCount write SetPipeCount;
//	- напряжение:
    property Voltage: Integer read FVoltage write SetVoltage;
//	- материал:
    property Material: string read FMaterial write SetMaterial;
//	- верх (труб, каналов, коллекторов, пакетов(блоков) при кабельной канализации, бесколодезных прокладок):
    property Top: string read FTop write SetTop;
//	- низ (каналов, коллекторов, пакетов(блоков) при кабельной канализации, бесколодезных прокладок):
    property Bottom: string read FBottom write SetBottom;
//	- дна колодцев, лотков в самотечных сетях;
    property Floor: string read FFloor write SetFloor;
//	- заказчик:
    property Customer: TmstMPOrganisation read FCustomer write SetCustomer;
//	- заказчик проектная организация:
    property Executor: TmstMPOrganisation read FExecutor write SetExecutor;
//	- организация которая нанесла:
    property Drawer: TmstMPOrganisation read FDrawer write SetDrawer;
//	- дата нанесения:
    property DrawDate: TDateTime read FDrawDate write SetDrawDate;
//	- балансодержатель;
    property Owner: string read FOwner write SetOwner;
  end;

  TmstMPObjectKind = (
    objLne = 0,
    objPlace = 1
  );

  TmstMasterPlanObject = class(TmstObject)
  private
    FSemantic: TmstMasterPlanSemantic;
    FKind: TmstMPObjectKind;
    FEzData: TStream;
    function GetSemantic: TmstMasterPlanSemantic;
    procedure SetEzData(const Value: TStream);
  public
    constructor Create; override;
    destructor Destroy; override;
    //
    property Semantic: TmstMasterPlanSemantic read GetSemantic;
    property Kind: TmstMPObjectKind read FKind;
    property EzData: TStream read FEzData write SetEzData;
  end;

  TmstMasterPlan = class(TmstObject)
  private
    FItems: TObjectList;
    FProjectName: string;
    FCustomer: TmstMPOrganisation;
    FExecutor: TmstMPOrganisation;
    FRequestNumber: string;
    FProjectNumber: string;
    FAddress: string;
    function GetItem(Index: Integer): TmstMasterPlanObject;
    procedure SetAddress(const Value: string);
    procedure SetCustomer(const Value: TmstMPOrganisation);
    procedure SetExecutor(const Value: TmstMPOrganisation);
    procedure SetProjectName(const Value: string);
    procedure SetProjectNumber(const Value: string);
    procedure SetRequestNumber(const Value: string);
  public
    constructor Create; override;
    destructor Destroy; override;
    //
    property Items[Index: Integer]: TmstMasterPlanObject read GetItem;
    //	- заказчик:
    property Customer: TmstMPOrganisation read FCustomer write SetCustomer;
    //	- заказчик проектная организация:
    property Executor: TmstMPOrganisation read FExecutor write SetExecutor;
//	- адрес:
    property Address: string read FAddress write SetAddress;
//	- номер проекта;
    property ProjectNumber: string read FProjectNumber write SetProjectNumber;
//	- название проекта;
    property ProjectName: string read FProjectName write SetProjectName;
//	- номер заявки:
    property RequestNumber: string read FRequestNumber write SetRequestNumber;
  end;

  TmstMasterPlanList = class
  private
    FList: TObjectList;
    function GetCount: Integer;
  public
    constructor Create;
    destructor Destroy; override;
    //
    property Count: Integer read GetCount;
    procedure Add(aItem: TmstMasterPlan); virtual; abstract; 
  end;

  TmstMPOrgs = class
  private
    FList: TObjectList;
  public
    constructor Create;
    destructor Destroy; override;
    //
    procedure Add(aId: Integer; aName: string);
    function GetById(aId: Integer): TmstMPOrganisation;
  end;

implementation

{ TmstMPClasses }

function TmstMPClasses.Count: Integer;
begin
  Result := FList.Count;
end;

constructor TmstMPClasses.Create;
begin
  FList := TObjectList.Create(True);
  PrepareList();
end;

destructor TmstMPClasses.Destroy;
begin
  FList.Free;
  inherited;
end;

function TmstMPClasses.GetItems(Index: Integer): TmstMPClass;
begin
  Result := TmstMPClass(FList[Index]);
end;

procedure TmstMPClasses.PrepareList;
begin

end;

{ TmstMasterPlanSemantic }

procedure TmstMasterPlanSemantic.SetAddress(const Value: string);
begin
  FAddress := Value;
end;

procedure TmstMasterPlanSemantic.SetArchived(const Value: Boolean);
begin
  FArchived := Value;
end;

procedure TmstMasterPlanSemantic.SetBottom(const Value: string);
begin
  FBottom := Value;
end;

procedure TmstMasterPlanSemantic.SetConfirmed(const Value: Boolean);
begin
  FConfirmed := Value;
end;

procedure TmstMasterPlanSemantic.SetCustomer(const Value: TmstMPOrganisation);
begin
  FCustomer := Value;
end;

procedure TmstMasterPlanSemantic.SetDiameter(const Value: Integer);
begin
  FDiameter := Value;
end;

procedure TmstMasterPlanSemantic.SetDismantled(const Value: Boolean);
begin
  FDismantled := Value;
end;

procedure TmstMasterPlanSemantic.SetDrawDate(const Value: TDateTime);
begin
  FDrawDate := Value;
end;

procedure TmstMasterPlanSemantic.SetDrawer(const Value: TmstMPOrganisation);
begin
  FDrawer := Value;
end;

procedure TmstMasterPlanSemantic.SetExecutor(const Value: TmstMPOrganisation);
begin
  FExecutor := Value;
end;

procedure TmstMasterPlanSemantic.SetFloor(const Value: string);
begin
  FFloor := Value;
end;

procedure TmstMasterPlanSemantic.SetMaterial(const Value: string);
begin
  FMaterial := Value;
end;

procedure TmstMasterPlanSemantic.SetMPClass(const Value: TmstMPClass);
begin
  FMPClass := Value;
end;

procedure TmstMasterPlanSemantic.SetMPClassId(const Value: Integer);
begin
  FMPClassId := Value;
end;

procedure TmstMasterPlanSemantic.SetOwner(const Value: string);
begin
  FOwner := Value;
end;

procedure TmstMasterPlanSemantic.SetPipeCount(const Value: Integer);
begin
  FPipeCount := Value;
end;

procedure TmstMasterPlanSemantic.SetProjectName(const Value: string);
begin
  FProjectName := Value;
end;

procedure TmstMasterPlanSemantic.SetProjectNumber(const Value: string);
begin
  FProjectNumber := Value;
end;

procedure TmstMasterPlanSemantic.SetRequestNumber(const Value: string);
begin
  FRequestNumber := Value;
end;

procedure TmstMasterPlanSemantic.SetRotation(const Value: Integer);
begin
  FRotation := Value;
end;

procedure TmstMasterPlanSemantic.SetStatus(const Value: TmstMPStatus);
begin
  FStatus := Value;
end;

procedure TmstMasterPlanSemantic.SetTop(const Value: string);
begin
  FTop := Value;
end;

procedure TmstMasterPlanSemantic.SetUnderground(const Value: Boolean);
begin
  FUnderground := Value;
end;

procedure TmstMasterPlanSemantic.SetVoltage(const Value: Integer);
begin
  FVoltage := Value;
end;

{ TmstMPOrganisation }

procedure TmstMPOrganisation.SetId(const Value: Integer);
begin
  FId := Value;
end;

procedure TmstMPOrganisation.SetName(const Value: string);
begin
  FName := Value;
end;

{ TmstMasterPlanObject }

constructor TmstMasterPlanObject.Create;
begin
  inherited Create;

end;

destructor TmstMasterPlanObject.Destroy;
begin
  FreeAndNil(FEzData);
  FreeAndNil(FSemantic);
  inherited;
end;

function TmstMasterPlanObject.GetSemantic: TmstMasterPlanSemantic;
begin
  if not Assigned(FSemantic) then
    FSemantic := TmstMasterPlanSemantic.Create;
  Result := FSemantic;
end;

procedure TmstMasterPlanObject.SetEzData(const Value: TStream);
begin
  FreeAndNil(FEzData);
  if Value <> nil then
  begin
    FEzData := TMemoryStream.Create;
    Value.Position := 0;
    FEzData.CopyFrom(Value, Value.Size);
  end;
end;

{ TmstMasterPlan }

constructor TmstMasterPlan.Create;
begin
  FItems := TObjectList.Create;
end;

destructor TmstMasterPlan.Destroy;
begin
  FItems.Free;
  inherited;
end;

function TmstMasterPlan.GetItem(Index: Integer): TmstMasterPlanObject;
begin
  Result := TmstMasterPlanObject(FItems[Index]);
end;

procedure TmstMasterPlan.SetAddress(const Value: string);
begin
  FAddress := Value;
end;

procedure TmstMasterPlan.SetCustomer(const Value: TmstMPOrganisation);
begin
  FCustomer := Value;
end;

procedure TmstMasterPlan.SetExecutor(const Value: TmstMPOrganisation);
begin
  FExecutor := Value;
end;

procedure TmstMasterPlan.SetProjectName(const Value: string);
begin
  FProjectName := Value;
end;

procedure TmstMasterPlan.SetProjectNumber(const Value: string);
begin
  FProjectNumber := Value;
end;

procedure TmstMasterPlan.SetRequestNumber(const Value: string);
begin
  FRequestNumber := Value;
end;

{ TmstMPClass }

constructor TmstMPClass.Create(aId, aLayerId: Integer; aLayerName: string);
begin
  FLayerName := aLayerName;
  FId := aId;
  FLayerId := aLayerId;
end;

procedure TmstMPClass.SetId(const Value: Integer);
begin
  FId := Value;
end;

procedure TmstMPClass.SetLayerId(const Value: Integer);
begin
  FLayerId := Value;
end;

procedure TmstMPClass.SetLayerName(const Value: string);
begin
  FLayerName := Value;
end;

{ TmstMasterPlanList }

constructor TmstMasterPlanList.Create;
begin
  FList := TObjectList.Create;
end;

destructor TmstMasterPlanList.Destroy;
begin
  FList.Free;
  inherited;
end;

function TmstMasterPlanList.GetCount: Integer;
begin
  Result := FList.Count;
end;

{ TmstMPOrgs }

procedure TmstMPOrgs.Add(aId: Integer; aName: string);
begin

end;

constructor TmstMPOrgs.Create;
begin
  FList := TObjectList.Create;
end;

destructor TmstMPOrgs.Destroy;
begin
  FList.Free;
  inherited;
end;

function TmstMPOrgs.GetById(aId: Integer): TmstMPOrganisation;
begin

end;

end.
