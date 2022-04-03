unit uIBXUpdateSQLW;

interface

uses
   SysUtils, Classes, DB, IB, IBCustomDataSet, IBQuery,IBUpdateSQL, IBDatabase;

type
  TIBUpdateSQLW = class(TIBUpdateSQL)
  private
    FAutoCommit: Boolean;
    FUpdateTransaction: TIBTransaction;
    FQueriesW: array[TUpdateKind] of TIBQuery;
    procedure SetUpdateTransaction(Value:TIBTransaction);
  protected
    function  GetQueryW(UpdateKind: TUpdateKind): TIBQuery;
    procedure SQLChangedW(Sender: TObject);
    procedure SetQueryTransaction(UpdateKind: TUpdateKind);
    procedure Notification( AComponent: TComponent;
      Operation: TOperation); override;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure Apply(UpdateKind: TUpdateKind); override;
    procedure ExecSQLW(UpdateKind: TUpdateKind);
    procedure SetParamsW(UpdateKind: TUpdateKind);
    property QueryW[UpdateKind: TUpdateKind]: TIBQuery read GetQueryW;
  published
    property AutoCommit: Boolean read FAutoCommit write FAutoCommit;
    property UpdateTransaction: TIBTransaction read fUpdateTransaction
      write SetUpdateTransaction;
  end;

  procedure Register;

implementation

uses
  Variants;

procedure Register;
begin
  RegisterComponents('Interbase',  [TIBUpdateSQLW]);
end;

constructor TIBUpdateSQLW.Create(AOwner: TComponent);
var
  UpdateKind: TUpdateKind;
begin
  inherited Create(AOwner);
  FAutoCommit := True;
  for UpdateKind := Low(TUpdateKind) to High(TUpdateKind) do
  begin
    TStringList(SQL[UpdateKind]).OnChange := SQLChangedW;
  end;
end;

destructor TIBUpdateSQLW.Destroy;
var
  UpdateKind: TUpdateKind;
begin
  for UpdateKind := Low(TUpdateKind) to High(TUpdateKind) do
  if Assigned(FQueriesW[UpdateKind]) then
  begin
    FQueriesW[UpdateKind].Free;
    FQueriesW[UpdateKind] := nil;
  end;
  inherited Destroy;
end;


function TIBUpdateSQLW.GetQueryW(UpdateKind: TUpdateKind): TIBQuery;
begin
  if not Assigned(FQueriesW[UpdateKind]) then
  begin
    FQueriesW[UpdateKind] := TIBQuery.Create(Self);
    FQueriesW[UpdateKind].SQL.Assign(SQL[UpdateKind]);
    SetQueryTransaction(UpdateKind);
  end;
  Result := FQueriesW[UpdateKind];
end;

procedure TIBUpdateSQLW.SQLChangedW(Sender: TObject);
var
  UpdateKind: TUpdateKind;
begin
  for UpdateKind := Low(TUpdateKind) to High(TUpdateKind) do
    if Sender = SQL[UpdateKind] then
    begin
      if Assigned(FQueriesW[UpdateKind]) then
      begin
        FQueriesW[UpdateKind].Params.Clear;
        FQueriesW[UpdateKind].SQL.Assign(SQL[UpdateKind]);
      end;
      Break;
    end;
end;

procedure TIBUpdateSQLW.SetParamsW(UpdateKind: TUpdateKind);
var
  I: Integer;
  Old: Boolean;
  Param: TParam;
  PName: String;
  Field: TField;
  Value: Variant;
begin
  if not Assigned(DataSet) then
    Exit;
  with QueryW[UpdateKind] do
    for I := 0 to Pred(Params.Count) do
    begin
      Param := Params[I];
      PName := Param.Name;
      Old := CompareText(Copy(PName, 1, 4), 'OLD_') = 0; {do not localize}
      if Old then
        System.Delete(PName, 1, 4);
      Field := DataSet.FindField(PName);
      if not Assigned(Field) then
        Continue;
      if Old then
        Param.AssignFieldValue(Field, Field.OldValue)
      else
      begin
        Value := Field.NewValue;
        if VarIsEmpty(Value) then
          Value := Field.OldValue;
        Param.AssignFieldValue(Field, Value);
      end;
    end;
end;

procedure TIBUpdateSQLW.Apply(UpdateKind: TUpdateKind);
begin
  SetParamsW(UpdateKind);
  ExecSQLW(UpdateKind);
end;

procedure TIBUpdateSQLW.ExecSQLW(UpdateKind: TUpdateKind);
begin
  with QueryW[UpdateKind] do
  begin
    if Assigned(fUpdateTransaction) and not fUpdateTransaction.InTransaction then
      FUpdateTransaction.StartTransaction;
    try
      Prepare;
      ExecSQL;
      if RowsAffected <> 1 then
        IBError(ibxeUpdateFailed, [nil]);
    finally
      if Assigned(fUpdateTransaction) and FAutoCommit then
      FUpdateTransaction.Commit;
    end;
  end;
end;

procedure TIBUpdateSQLW.SetQueryTransaction(UpdateKind: TUpdateKind);
begin
  if Assigned(FQueriesW[UpdateKind]) then
  begin
    if Assigned(fUpdateTransaction) then
    begin
      FQueriesW[UpdateKind].Database := FUpdateTransaction.FindDefaultDatabase;
      FQueriesW[UpdateKind].Transaction := FUpdateTransaction;
    end
    else
    // inherited
    if (DataSet is TIBCustomDataSet) then
    begin
      FQueriesW[UpdateKind].Database := TIBCustomDataSet(DataSet).DataBase;
      FQueriesW[UpdateKind].Transaction := TIBCustomDataSet(DataSet).Transaction;
    end;
  end;
end;

procedure TIBUpdateSQLW.Notification(AComponent: TComponent; Operation: TOperation);
var
  UpdateKind: TUpdateKind;
begin
  inherited Notification(AComponent, Operation);
  if (Operation = opRemove) then
    if AComponent = FUpdateTransaction then
    begin
      FUpdateTransaction := nil;
      for UpdateKind := Low(TUpdateKind) to High(TUpdateKind) do
        SetQueryTransaction(UpdateKind);
    end;
end;

procedure TIBUpdateSQLW.SetUpdateTransaction(Value:TIBTransaction);
var
  UpdateKind: TUpdateKind;
begin
  FUpdateTransaction := Value;
  for UpdateKind := Low(TUpdateKind) to High(TUpdateKind) do
    SetQueryTransaction(UpdateKind);
end;

end.
