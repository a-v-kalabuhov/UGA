unit uMStClassesMPIntf;

interface

uses
  Classes, DB, Graphics,
  EzBaseGIS, EzLib,
  uMStKernelClasses, uMStKernelIBX, uMStKernelAppSettings,
  uMStClassesMPClassif, uMStClassesProjectsMP, uMStClassesProjectsMPIntersect;

type
  TmstImportSource = (srcDXF, srcExcel);

  ImstMPModule = interface
    ['{9950B1D8-F72C-409E-BEE9-A06839D82445}']
    function Classifier: TmstMPClassifier;
    procedure DisplayNavigator(aDrawBox: TEzBaseDrawBox);
    procedure ImportFile(Source: TmstImportSource; const aObjState: TmstMPObjectState);
    procedure SetAppSettingsEvent(aEvent: TGetAppSettingsEvent);
    procedure SetDbEvent(aDbEvent: TGetDbEvent);
    procedure SetDrawBox(aDrawBox: TEzBaseDrawBox);
    procedure LoadFromDb();
    procedure NavigatorClosed();
    //
    function GetObjByDbId(const ObjId: Integer; LoadEzData: Boolean): TmstMPObject;
    procedure DeleteObj(const ObjId: Integer);
    procedure DeleteProject(const ObjId: Integer);
    procedure DivideObj(const ObjId: Integer);
    function EditNewObject(const Obj: TmstMPObject): Boolean;
    function EditObjProperties(const ObjId: Integer): Boolean;
//    function EditObjectProps(const Obj: TmstMPObject): Boolean;
    function CanFindIntersections(const ObjId: Integer): Boolean;
    function FindIntersects(const ObjId: Integer): TmpIntersectionInfo;
    procedure IntersectDialog(Found: TmpIntersectionInfo);
    procedure IntersectionsDialogClosed(Dlg: TObject);
    function IsObjectVisible(const ObjId: Integer; var aLineColor: TColor): Boolean;
    procedure SetObjCheckState(const ObjId: Integer; CheckState: TmstMPObjectCheckState);
    procedure UpdateLayersVisibility(aLayers: TmstLayerList);
    //
    function HasLoaded(): Boolean;
    function IsLoaded(const ObjId: Integer): Boolean;
    procedure LoadAllToGIS();
    procedure LoadToGis(const ObjId: Integer; const Display: Boolean; const ZoomIfVisible: Boolean);
    procedure LoadProjectToGis(const ObjId: Integer; const Display: Boolean; const ZoomIfVisible: Boolean);
    procedure UnloadAllFromGis();
    function UnloadFromGis(const ObjId: Integer): Boolean;
    function UnloadProjectFromGis(const ObjId: Integer): Boolean;
    //
    procedure CopyToDrawn(const ObjId: Integer);
    procedure GiveOutCertif(const ObjId: Integer; CertifNumber: string; CertifDate: TDateTime);
    //
    procedure ExportToMif(const aMifFileName: string);
    procedure LoadMPObjects(const aGeoLeft, aGeoTop, aGeoRight, aGeoBottom: Double);
    //
    procedure FillClassIDinProjectLayers();
    //
    function PickObjects(const X, Y: Double): TList;
  end;

  TRowOperation = (rowInsert, rowUpdate, rowDelete);

  ImstMPObjEventSubscriber = interface
    ['{0B49BDED-2078-4D92-8140-21EBF3F65809}']
    procedure Notify(const ObjId: Integer; Op: TRowOperation);
  end;

  ImstMPBrowser = interface
    ['{FF25E26F-1B7D-43D7-BF45-332C9841AABC}']
    procedure Browse();
    procedure RedrawGUI;
    procedure LocateObj(const ObjId: Integer);
  end;

  ImstMPModuleObjList = interface
    ['{353E66CC-A116-430A-A842-4DF7B91ADE5F}']
    function Browser: ImstMPBrowser;
    function BrowserDataSet(): TDataSet;
    procedure RefreshBrowseDataSetRow(const ObjId: Integer; TargetDataSet: TDataSet);
    procedure Subscribe(Subscriber: ImstMPObjEventSubscriber);
    procedure UnSubscribe(Subscriber: ImstMPObjEventSubscriber);
    function CanDivide(const ObjId: Integer): Boolean;
  end;

  ImstMPObjectSaver = interface
    ['{37CC5354-D092-4A5E-9E28-D361C9C8921C}']
    function SaveMPObject(aDb: IDb; MPObject: TmstMPObject): Boolean;
  end;

  ImstMPExcelImport = interface
    ['{32113B54-A166-4FDC-907F-AC83EF6DB3A1}']
    function  DoImport(MP: ImstMPModule): Boolean;
    function GetMPObjectCount: Integer;
    function GetMPObjects(Index: Integer): TmstMPObject;
    function GetProject(const aObjState: TmstMPObjectState): TmstProjectMP;
  end;

implementation

end.
