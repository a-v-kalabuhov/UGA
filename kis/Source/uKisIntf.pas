unit uKisIntf;

interface

uses
  // System
  Classes, Types,
  // Project
  uKisClasses, uKisSQLClasses;

type
  IKisImageViewer = interface
    ['{B218F6C6-C824-46A4-8C91-439CD277F4A8}']
    function GetAllowPrint: Boolean;
    procedure SetAllowPrint(Value: Boolean);
    function GetAllowSave: Boolean;
    procedure SetAllowSave(Value: Boolean);
    function ConfirmImage(const Caption, FileName: String): Boolean;
    procedure ShowImage(const Caption, FileName: String);
    property AllowPrint: Boolean read GetAllowPrint write SetAllowPrint;
    property AllowSave: Boolean read GetAllowSave write SetAllowSave;
  end;

  IKisFolders = interface
    ['{AE40C3A4-CC2F-417D-B3FF-43F146A6B683}']
    function AppTempPath(): string;
    function MapScansPath(): string;
    function MapScansTempPath(): string;
    function ReportsPath(): string;
    function SQLLogPath(): string;
    function ThreadCount(): Byte;
  end;

  IKisImagesView = interface
    ['{AF62A466-421A-428C-9982-C090EB2D66AC}']
    procedure AddImage(const aFileName, aLayerName, aLayerTitle: string; const aImageRect: TRect);
    procedure AddNomenclature(const aNomenclature: string);
    procedure EnableCrosses();
    // инструмент для просмотра картинок на карте
    procedure Execute(Folders: IKisFolders; const aTitle: string; const aFileType: Integer);
    // инструмент для проверки стыковки планшетов
    function CheckJoin(Folders: IKisFolders; const aTitle: string): Boolean;
  end;

  IKisAutoObject = interface
    function AEntity: TKisEntity;
  end;

  function KisObject(Entity: TKisEntity): IKisAutoObject;

implementation

type
  TKisAutoObject = class(TInterfacedObject, IKisAutoObject)
  private
    FObj: TKisEntity;
  public
    constructor Create(Entity: TKisEntity);
    destructor Destroy; override;
    function AEntity: TKisEntity;
  end;

{ TKisAutoObject }

constructor TKisAutoObject.Create(Entity: TKisEntity);
begin
  FObj := Entity;
end;

destructor TKisAutoObject.Destroy;
begin
  if Assigned(FObj) then
    FObj.Free;
  inherited;
end;

function TKisAutoObject.AEntity: TKisEntity;
begin
  Result := FObj;
end;

function KisObject(Entity: TKisEntity): IKisAutoObject;
begin
  Result := TKisAutoObject.Create(Entity);
end;

end.
