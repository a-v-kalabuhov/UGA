unit uMStKernelIBX;

interface

uses
  Classes, DB;

type
  TConnectionMode = (cmReadOnly, cmReadWrite, cmWriteOnly);
  TDbMode = (dmGeo, dmKis);

  IIBXConnection = interface
    ['{68A09629-23B1-4386-AE7D-CAC313576E88}']
    procedure ExecDataSet(DataSet: TDataSet);
    function  GetDataSet(const SQL: String): TDataSet;
    function  GetRecordCount(const SQL: String; const Fetch: Boolean): Integer;
    procedure SetParam(DataSet: TDataSet; const ParamName: String; const ParamValue: Variant);
    procedure SetBlobParam(DataSet: TDataSet; const ParamName: String; Stream: TStream);
    procedure Commit();
  end;

  ISqlSource = interface
    ['{76910B36-F0AC-473A-AF56-BB2678BFDE11}']
    function GetSqlText(Conn: IIBXConnection; const aQueryName: string): string;
    function GetSqlTextOrCrash(Conn: IIBXConnection; const aQueryName: string): string;
  end;

  IDb = interface
    ['{9F471ABF-6CD9-41A6-9E40-72182BFDEFDD}']
    function  GetConnection(Mode: TConnectionMode; DbMode: TDbMode): IIBXConnection;
  end;

implementation

end.
