unit uMStKernelAppModule;

interface

type
  ImstAppModule = interface
    ['{2FDB27C7-6133-4640-A08E-083C09CA1298}']
    procedure HideLot(const aCategoryId, DatabaseId: Integer);
    procedure LocateAddress(const DbId: Integer);
    procedure LocateContour(const aCategoryId, aLotDbId, aContourDbId: Integer);
    procedure LocateLot(const aCategoryId, aDbId: Integer);
    procedure LocateProject(const DbId: Integer; MasterPlan: Boolean);
    procedure RepaintViewports;
    procedure UnHideLot(const aCategoryId, DatabaseId: Integer);
  end;

implementation

end.
