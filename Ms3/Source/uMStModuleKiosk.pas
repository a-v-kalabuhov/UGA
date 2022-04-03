unit uMStModuleKiosk;

interface

uses
  SysUtils, Classes, DB, IBCustomDataSet, IBDatabase, IBTable, IBSQL, IBQuery,
  uMStKioskDataSet, uMStKernelClasses, IBUpdateSQL;

type
  TmstKioskModule = class(TDataModule)
  private
    FDataSet: TmstKioskDataSet;
  public
    function GetDataSet: TDataSet;
    //
    procedure DeleteKiosk(DbId: Integer);
  end;

var
  mstKioskModule: TmstKioskModule;

implementation

{$R *.dfm}

uses
  Variants,
  EzBaseGIS, EzEntities,
  uKisConsts, uMStModuleApp, uMStKernelConsts, uMStKernelGISUtils;

{ TmstKioskModule }

procedure TmstKioskModule.DeleteKiosk(DbId: Integer);
begin
  if Assigned(FDataSet) then
    FDataSet.DeleteKiosk(IntToHex(DbId, 10));
  mstClientAppModule.DeleteKiosk(DbId);
end;

function TmstKioskModule.GetDataSet: TDataSet;
begin
  if not Assigned(FDataSet) then
    FDataSet := TmstKioskDataSet.Create(Self);
  Result := FDataSet;
  TmstKioskDataSet(Result).LoadData(mstClientAppModule.Kiosk);
end;

end.
