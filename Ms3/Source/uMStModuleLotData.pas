unit uMStModuleLotData;

interface

uses
  SysUtils, Classes, IBDatabase, DB, IBCustomDataSet, IBQuery,
  Windows,
  uMStKernelInterfaces;

type
  TmstLotDataModule = class(TDataModule, ILots)
    Transaction: TIBTransaction;
    ibqOwners: TIBQuery;
    ibqDocs: TIBQuery;
    ibqLot: TIBQuery;
    procedure DataModuleDestroy(Sender: TObject);
    procedure DataModuleCreate(Sender: TObject);
  private
    procedure CloseLots;
    function GetLotData(const FieldName: string): string;
    function GetOwnerData(const FieldName: string): string;
    function GetDocsList(): string;
    function GetDataSet(Kind: TLotDataSet): TDataSet;
  public
    procedure Activate;
  end;

implementation

{$R *.dfm}

{ TmstLotDataModule }

procedure TmstLotDataModule.Activate;
begin
  Transaction.StartTransaction;
  ibqLot.Open;
  ibqDocs.Open;
  ibqLot.Open;
  ibqOwners.Open;
end;

procedure TmstLotDataModule.CloseLots;
begin
  if Transaction.Active then
    Transaction.Commit;
//  ibqLot.Open;
//  ibqDocs.Open;
//  ibqLot.Open;
//  ibqOwners.Open;
//  Free;
end;

procedure TmstLotDataModule.DataModuleCreate(Sender: TObject);
begin
  OutputDebugString('TmstLotDataModule.DataModuleCreate');
end;

procedure TmstLotDataModule.DataModuleDestroy(Sender: TObject);
begin
  OutputDebugString('TmstLotDataModule.DataModuleDestroy');
end;

function TmstLotDataModule.GetDataSet(Kind: TLotDataSet): TDataSet;
begin
  Result := nil;
  case Kind of
  ldsLot :    Result := ibqLot;
  ldsOwners : Result := ibqOwners;
  ldsDocs :   Result := ibqDocs;
  end;
end;

function TmstLotDataModule.GetDocsList: string;
var
  DocTypeId: Integer;
begin
  Result := '';
  DocTypeId := -1;
  while not ibqDocs.Eof do
  begin
    if ibqDocs.FieldByName('DECREE_TYPES_ID').AsInteger <> DocTypeId then
    begin
      DocTypeId := ibqDocs.FieldByName('DECREE_TYPES_ID').AsInteger;
      if Trim(Result) <> '' then
        Result := Result + ', ';
      Result := Result + ibqDocs.FieldByName('DECREE_TYPES_NAME').AsString + ' ';
    end
    else
      Result := Result + ', ';
    Result := Result + '№' + ibqDocs.FieldByName('DOC_NUMBER').AsString + ' от '
            + ibqDocs.FieldByName('DOC_DATE').AsString;
    ibqDocs.Next;
  end;
end;

function TmstLotDataModule.GetLotData(const FieldName: string): string;
begin
  Result := ibqLot.FieldByName(FieldName).AsString;
end;

function TmstLotDataModule.GetOwnerData(const FieldName: string): string;
begin
  if ibqOwners.IsEmpty then
    Result := ''
  else
    Result := ibqOwners.FieldByName(FieldName).AsString;
end;

end.
