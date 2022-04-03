unit uIndexedDataSet;

interface

uses
  SysUtils, Classes,
  uDataSet;

type
  TIndexedDataSet = class(TCustomDataSet)
  private
    procedure CreateController;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
  end;

  TFieldValue = class
  private
    FValue: Variant;
    procedure SetValue(const Value: Variant);
  public
    property Value: Variant read FValue write SetValue;
  end;

  TRow = class
  private
    FValues: TList;
    function GetFieldValues(const Index: Integer): Variant;
    procedure SetFieldValues(const Index: Integer; const Value: Variant);
  public
    constructor Create;
    property FieldValues[const Index: Integer]: Variant read GetFieldValues write SetFieldValues;
  end;

  TIndexedController = class(TDataSetController)
  public
  end;

implementation

{ TIndexedDataSet }

constructor TIndexedDataSet.Create(AOwner: TComponent);
begin
  inherited;
  CreateController;
end;

procedure TIndexedDataSet.CreateController;
begin
  Controller := TIndexedController.Create(Self);
end;

destructor TIndexedDataSet.Destroy;
var
  Tmp: TObject;
begin
  Tmp := Controller;
  Controller := nil;
  FreeAndNil(Tmp);
  inherited;
end;

{ TRow }

constructor TRow.Create;
begin
  FValues := TList.Create;
end;

function TRow.GetFieldValues(const Index: Integer): Variant;
begin
  Result := TFieldValue(FValues[Index]).Value;
end;

procedure TRow.SetFieldValues(const Index: Integer; const Value: Variant);
begin
  TFieldValue(FValues[Index]).Value := Value;
end;

{ TFieldValue }

procedure TFieldValue.SetValue(const Value: Variant);
begin
  FValue := Value;
end;

end.
