unit uMStModuleGlobalParameters;

interface

uses
  SysUtils, Classes, DB, IBCustomDataSet, IBQuery, IBDatabase,
  uMStKernelInterfaces;

type
  TmstParametersModule = class(TDataModule, IParameters)
    trKis: TIBTransaction;
    ibqParameters: TIBQuery;
    ibqWatermark: TIBQuery;
  private
    procedure Open;
    procedure Close;
    function GetParameter(const ParamName: string): Variant;
    function GetWatermarkParameter(const ParamName: string): Variant;
  public
  end;

implementation

{$R *.dfm}

{ TDataModule2 }

procedure TmstParametersModule.Open;
begin
  if not trKis.Active then
    trKis.StartTransaction;
end;

procedure TmstParametersModule.Close;
begin
  if trKis.Active then
    trKis.Commit;
end;

function TmstParametersModule.GetParameter(const ParamName: string): Variant;
begin
  if not trKis.Active then
    Open;
  if not ibqParameters.Active then
    ibqParameters.Open;
  Result := ibqParameters.FieldValues[ParamName];
end;

function TmstParametersModule.GetWatermarkParameter(
  const ParamName: string): Variant;
begin
  if not trKis.Active then
    Open;
  if not ibqWatermark.Active then
    ibqWatermark.Open;
  Result := ibqWatermark.FieldValues[ParamName];
end;

end.
