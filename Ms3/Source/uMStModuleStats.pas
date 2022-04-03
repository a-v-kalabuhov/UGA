unit uMStModuleStats;

interface

uses
  SysUtils, Classes, DB, IBCustomDataSet, IBQuery, IBDatabase,
  uMStKernelInterfaces;

type
  TmstStatDataModule = class(TDataModule, IStats)
    ibqPeople: TIBQuery;
    ibqOffices: TIBQuery;
    ibqStats: TIBQuery;
    trKis: TIBTransaction;
    trGeo: TIBTransaction;
  private
    procedure SetParam(const ParamName: string; Value: Variant);
  private
    procedure Close;
    function DataSet: TDataSet;
    procedure PrepareDataSet(const OfficeId, PeopleId: Integer; const D1, D2: TDateTime; UseD1, UseD2: Boolean);
    function GetOffices(): TStrings;
    function GetPeople(const OfficeId: Integer): TStrings;
  end;

implementation

{$R *.dfm}

{ TmstStatDataModule }

procedure TmstStatDataModule.Close;
begin
  if trKis.Active then
    trKis.Commit;
  if trGeo.Active then
    trGeo.Commit;
end;

function TmstStatDataModule.DataSet: TDataSet;
begin
  Result := ibqStats;
end;

function TmstStatDataModule.GetOffices: TStrings;
var
  I: Integer;
begin
  Result := TStringList.Create;
  ibqOffices.First;
  while not ibqOffices.Eof do
  begin
    I := ibqOffices.FieldByName('ID').AsInteger;
    Result.AddObject(ibqOffices.FieldByName('NAME').AsString, Pointer(I));
    ibqOffices.Next;
  end;
end;

function TmstStatDataModule.GetPeople(const OfficeId: Integer): TStrings;
var
  Id: Integer;
begin
  Result := TStringList.Create;
  if OfficeId < 1 then
    ibqPeople.Filtered := False
  else
  begin
    ibqPeople.Filtered := True;
    ibqPeople.Filter := 'OFFICES_ID=' + IntToStr(OfficeId);
  end;
  //
  ibqPeople.First;
  while not ibqPeople.Eof do
  begin
    Id := ibqPeople.FieldByName('ID').AsInteger;
    Result.AddObject(
      ibqPeople.FieldByName('FULL_NAME').AsString,
      Pointer(Id)
    );
    ibqPeople.Next;
  end;
end;

procedure TmstStatDataModule.PrepareDataSet(const OfficeId, PeopleId: Integer;
  const D1, D2: TDateTime; UseD1, UseD2: Boolean);
var
  Query, Where: String;
begin
  Query :=
      'SELECT ACCOUNT_NAME, NOMENCLATURE, USER_NAME, PRINT_DATE '
    + 'FROM PRINTED_MAPS ';
  Where := '';
  if UseD2 then
    Where := ' (PRINT_DATE >= :D1 AND PRINT_DATE <= :D2) '
  else
    Where := ' (PRINT_DATE=:D1) ';
  //
  if OfficeId > 0 then
  begin
    if Where <> '' then
      Where := Where + ' AND ';
    Where := Where + '(OFFICES_ID=:OFFICES_ID)';
  end;
  //
  if PeopleId > 0 then
  begin
    if Where <> '' then
      Where := Where + ' AND ';
    Where := Where + '(PEOPLE_ID=:PEOPLE_ID)';
  end;
  //
  ibqStats.SQL.Text := Query + ' WHERE ' + Where + ' ORDER BY ACCOUNT_NAME, PRINT_DATE, NOMENCLATURE';
  //
  SetParam('PEOPLE_ID', PeopleId);
  SetParam('OFFICES_ID', OfficeId);
  SetParam('D1', D1);
  SetParam('D2', D2);
  //
  ibqStats.Open;
end;

procedure TmstStatDataModule.SetParam(const ParamName: string; Value: Variant);
var
  Param: TParam;
begin
  Param := ibqStats.Params.FindParam(ParamName);
  if Assigned(Param) then
    Param.Value := Value;
end;

end.
