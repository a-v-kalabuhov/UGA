unit uMStImport;

interface

uses
  SysUtils, Classes, Contnrs, DB,
  //
  EzLib, EzBaseGIS,
  //
  uCommonClasses, uGeoTypes,
  //
  uMStKernelSemantic;

type
  TMstImportKind = (importMifMid);

  ImstImportSettings = interface
    ['{B8FDCA6B-78E5-456C-8DD4-9E5ED99C1F24}']
    function GetLayerCaption(): string;
    procedure SetLayerCaption(Value: string);
    property LayerCaption: string read GetLayerCaption write SetLayerCaption;
    //
    function GetMifFileName(): string;
    procedure SetMifFileName(Value: string);
    property MifFileName: string read GetMifFileName write SetMifFileName;
    //
    function GetCoordSystem(): TCoordSystem;
    procedure SetCoordSystem(Value: TCoordSystem);
    property CoordSystem: TCoordSystem read GetCoordSystem write SetCoordSystem;
    //
    function GetFields(): TmstLayerFields;
    procedure SetFields(Value: TmstLayerFields);
    property Fields: TmstLayerFields read GetFields write SetFields;
    //
    function GetExchangeCoords(): Boolean;
    procedure SetExchangeCoords(Value: Boolean);
    property ExchangeCoords: Boolean read GetExchangeCoords write SetExchangeCoords;
  end;

  ImstImportLayer = interface;

  TImportEntityEvent = procedure (Sender: ImstImportLayer; const EntityNo, FileLineNo: Integer; aEntity: TEzEntity) of object;
  TImportErrorEvent = procedure (Sender: ImstImportLayer; const EntityNo, FileLineNo: Integer; aException: Exception) of object;
  TImportEntityFieldEvent = procedure (Sender: ImstImportLayer; const EntityNo: Integer; FldValues: TStrings) of object;

  ImstImportLayer = interface
    ['{BC3C0EC8-5E35-4F26-BEA8-3708D552FB80}']
    procedure DoImport(aSettings: ImstImportSettings);
    procedure ReadHeader(const aFileName: string; aGrapher: TEzGrapher);
    function GetFields: TmstLayerFields;
    property Fields: TmstLayerFields read GetFields;
    function GetFileName: string;
    property FileName: string read GetFileName;
    function GetRecordCount: Integer;
    property RecordCount: Integer read GetRecordCount;
    //
    function GetOnImport: TImportEntityEvent;
    procedure SetOnImport(Value: TImportEntityEvent);
    property OnImport: TImportEntityEvent read GetOnImport write SetOnImport;
    //
    function GetOnImportData: TImportEntityFieldEvent;
    procedure SetOnImportData(Value: TImportEntityFieldEvent);
    property OnImportData: TImportEntityFieldEvent read GetOnImportData write SetOnImportData;
    //
    function GetOnImportError: TImportErrorEvent;
    procedure SetOnImportError(Value: TImportErrorEvent);
    property OnImportError: TImportErrorEvent read GetOnImportError write SetOnImportError;
  end;

  ImstImportLayerDialog = interface
    ['{8D2A20D6-B1DB-4574-A9DF-0668CDE2664D}']
    function GetSettings: ImstImportSettings;
    function Execute(anImport: ImstImportLayer): Boolean;
    property Settings: ImstImportSettings read GetSettings;
  end;

  ImstImportPointsDialog = interface
    ['{201EDDCD-7F9B-42D5-9374-EA592657521F}']
    function Execute(aPointsList: TObject): Boolean;
  end;

implementation

end.
