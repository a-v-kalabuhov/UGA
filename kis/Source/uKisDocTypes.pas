{
  Юнит не используется
}
unit uKisDocTypes;

interface

{$I KisFlags.pas}

uses
  // System
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms, DB,
  // Common
  uDataSet,
  // Project
  uKisClasses;

type
  TKisDocTypeMngr = class(TKisMngr)
    procedure DataModuleCreate(Sender: TObject);
  private
    FCtrlr: TKisEntityController;
    FDataSet: TCustomDataSet;
    function GetDataSet: TDataSet;
  protected
    function GetIdent: TKisMngrs; override;
  public
    function GetEntity(EntityID: Integer; EntityKind: TKisEntities = keDefault): TKisEntity; override;
    function CreateEntity(EntityKind: TKisEntities = keDefault): TKisEntity; override;
    property DataSet: TDataSet read GetDataSet;
  end;

implementation

{$R *.dfm}

uses
  // System
  IBQuery,
  // Common
  uGc, uIBXUtils,
  // Project
  uKisAppModule, uKisIntf;

const
  SQ_GET_DOC_TYPES = 'SELECT * FROM DOC_TYPES';

{ TKisDocTypeMngr }

function TKisDocTypeMngr.CreateEntity(EntityKind: TKisEntities): TKisEntity;
begin
  Result := nil;
end;

procedure TKisDocTypeMngr.DataModuleCreate(Sender: TObject);
var
  Tmp: TKisEntity;
  DS: TIBQuery;
begin
  inherited;
  FDataSet := TCustomDataSet.Create(Self);
  FCtrlr := nil;
  DS := TIBQuery.Create(nil);
  DS.Forget;
  with DS do
  try
    BufferChunks := 50;
    Transaction := AppModule.Pool.Get;
    Transaction.Init(ilReadCommited, amReadOnly);
    Transaction.StartTransaction;
    SQL.Text := SQ_GET_DOC_TYPES;
    Open;
    FetchAll;
    while not Eof do
    begin
      Tmp := Self.CreateEntity;
      Tmp.Load(DS);
      FCtrlr.DirectAppend(Tmp);
      Next;
    end;
    Close;
  finally
    Transaction.Commit;
    AppModule.Pool.Back(Transaction);
  end;
end;

function TKisDocTypeMngr.GetDataSet: TDataSet;
begin
  Result := nil;
end;

function TKisDocTypeMngr.GetEntity(EntityID: Integer;
  EntityKind: TKisEntities): TKisEntity;
begin
  Result := nil;
end;

function TKisDocTypeMngr.GetIdent: TKisMngrs;
begin
  Result := kmDocTypes;
end;

end.
