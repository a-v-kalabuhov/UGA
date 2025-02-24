unit uMStClassesMPIntf;

interface

uses
  DB, Graphics,
  EzBaseGIS,
  uMStKernelClasses, uMStKernelIBX, uMStKernelAppSettings,
  uMStClassesMPClassif, uMStClassesProjectsMP;

type
  ImstMPModule = interface
    ['{9950B1D8-F72C-409E-BEE9-A06839D82445}']
    function Classifier: TmstMPClassifier;
    procedure DisplayNavigator(aDrawBox: TEzBaseDrawBox);
    procedure ImportDXF(const aObjState: TmstMPObjectState);
    procedure SetAppSettingsEvent(aEvent: TGetAppSettingsEvent);
    procedure SetDbEvent(aDbEvent: TGetDbEvent);
    procedure SetDrawBox(aDrawBox: TEzBaseDrawBox);
    procedure LoadFromDb();
    procedure NavigatorClosed();
    //
    function GetObjByDbId(const ObjId: Integer; LoadEzData: Boolean): TmstMPObject;
    procedure DeleteObj(const ObjId: Integer);
    function EditNewObject(const Obj: TmstMPObject): Boolean;
    function EditObjProperties(const ObjId: Integer): Boolean;
//    function EditObjectProps(const Obj: TmstMPObject): Boolean;
    function IsObjectVisible(const ObjId: Integer; var aLineColor: TColor): Boolean;
    procedure UpdateLayersVisibility(aLayers: TmstLayerList);
    //
    function IsLoaded(const ObjId: Integer): Boolean;
    procedure LoadAllToGIS();
    procedure LoadToGis(const ObjId: Integer; const Display: Boolean);
    procedure UnloadAllFromGis();
    function UnloadFromGis(const ObjId: Integer): Boolean;
    //
    procedure CopyToDrawn(const ObjId: Integer);
    procedure GiveOutCertif(const ObjId: Integer; CertifNumber: string; CertifDate: TDateTime);
  end;

  ImstMPModuleObjList = interface
    ['{353E66CC-A116-430A-A842-4DF7B91ADE5F}']
    function BrowserDataSet(): TDataSet;
  end;

  ImstMPObjectSaver = interface
    ['{37CC5354-D092-4A5E-9E28-D361C9C8921C}']
    function SaveMPObject(aDb: IDb; MPObject: TmstMPObject): Boolean;
  end;

implementation

end.
