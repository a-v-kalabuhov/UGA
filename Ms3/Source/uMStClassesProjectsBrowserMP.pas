unit uMStClassesProjectsBrowserMP;

interface

uses
  SysUtils;

type
  TBoolValue = (
    boolAll = 0,
    boolTrue = 1,
    boolFalse = 2);

  TmstProjectsBrowserFilterMP = class
  private
    FAddress: string;
    FVoltage: string;
    FCustomer: string;
    FExecutor: string;
    FDocNumber: string;
    FConfirmDateStart: TDateTime;
    FDocDateStart: TDateTime;
    FDiameter: string;
    FConfirmed: TBoolValue;
    FConfirmDateEnd: TDateTime;
    FDocDateEnd: TDateTime;
    FInfo: string;
    FArchived: TBoolValue;
    FUnderground: TBoolValue;
    FDismantled: TBoolValue;
    FNeedCheck: TBoolValue;
    procedure SetAddress(const Value: string);
    procedure SetConfirmDateEnd(const Value: TDateTime);
    procedure SetConfirmDateStart(const Value: TDateTime);
    procedure SetConfirmed(const Value: TBoolValue);
    procedure SetCustomer(const Value: string);
    procedure SetDiameter(const Value: string);
    procedure SetDocDateEnd(const Value: TDateTime);
    procedure SetDocDateStart(const Value: TDateTime);
    procedure SetDocNumber(const Value: string);
    procedure SetExecutor(const Value: string);
    procedure SetVoltage(const Value: string);
    procedure SetInfo(const Value: string);
    procedure SetArchived(const Value: TBoolValue);
    procedure SetDismantled(const Value: TBoolValue);
    procedure SetUnderground(const Value: TBoolValue);
    procedure SetNeedCheck(const Value: TBoolValue);
  public
    constructor Create;
    //
    procedure Clear();
    function IsEmpty: Boolean;
    //
    property Address: string read FAddress write SetAddress;
    property DocNumber: string read FDocNumber write SetDocNumber;
    property DocDateStart: TDateTime read FDocDateStart write SetDocDateStart;
    function UseDocDateStart: Boolean;
    property DocDateEnd: TDateTime read FDocDateEnd write SetDocDateEnd;
    function UseDocDateEnd: Boolean;
    property Diameter: string read FDiameter write SetDiameter;
    property Voltage: string read FVoltage write SetVoltage;
    property Customer: string read FCustomer write SetCustomer;
    property Executor: string read FExecutor write SetExecutor;
    property Confirmed: TBoolValue read FConfirmed write SetConfirmed;
    property ConfirmDateStart: TDateTime read FConfirmDateStart write SetConfirmDateStart;
    property ConfirmDateEnd: TDateTime read FConfirmDateEnd write SetConfirmDateEnd;
    property Info: string read FInfo write SetInfo;
    //
    property Archived: TBoolValue read FArchived write SetArchived;
    property Dismantled: TBoolValue read FDismantled write SetDismantled;
    property Underground: TBoolValue read FUnderground write SetUnderground;
    property NeedCheck: TBoolValue read FNeedCheck write SetNeedCheck;
  end;

implementation

{ TmstProjectsBrowserFilterMP }

procedure TmstProjectsBrowserFilterMP.Clear;
begin
  FAddress := '';
  FVoltage := '';
  FCustomer := '';
  FExecutor := '';
  FDocNumber := '';
  FDiameter := '';
  FInfo := '';
  FConfirmed := boolAll;
  FConfirmDateStart := 0; //EncodeDate(2000, 1, 1);
  FConfirmDateEnd := EncodeDate(2100, 1, 1);
  FDocDateStart := 0; //EncodeDate(2000, 1, 1);
  FDocDateEnd := EncodeDate(2100, 1, 1);
  FArchived := boolAll;
  FDismantled := boolAll;
  FUnderground := boolAll;
  FNeedCheck := boolAll;
end;

constructor TmstProjectsBrowserFilterMP.Create;
begin
  Clear;
end;

function TmstProjectsBrowserFilterMP.IsEmpty: Boolean;
begin
  Result :=
    (FAddress = '') and
    (FVoltage = '') and
    (FCustomer = '') and
    (FExecutor = '') and
    (FDocNumber = '') and
    (FDiameter = '') and
    (FInfo = '') and
    (FConfirmed = boolAll) and
//    (FConfirmDateStart = 0) and //EncodeDate(1900, 1, 1)) and
//    (FConfirmDateEnd = EncodeDate(2100, 1, 1)) and
    (FDocDateStart = 0) and
    (FDocDateEnd = EncodeDate(2100, 1, 1)) and
    (FArchived = boolAll) and
    (FDismantled = boolAll) and
    (FUnderground = boolAll) and
    (FNeedCheck = boolAll)
    ;
end;

procedure TmstProjectsBrowserFilterMP.SetAddress(const Value: string);
begin
  FAddress := Value;
end;

procedure TmstProjectsBrowserFilterMP.SetArchived(const Value: TBoolValue);
begin
  FArchived := Value;
end;

procedure TmstProjectsBrowserFilterMP.SetConfirmDateEnd(const Value: TDateTime);
begin
  FConfirmDateEnd := Value;
end;

procedure TmstProjectsBrowserFilterMP.SetConfirmDateStart(const Value: TDateTime);
begin
  FConfirmDateStart := Value;
end;

procedure TmstProjectsBrowserFilterMP.SetConfirmed(const Value: TBoolValue);
begin
  FConfirmed := Value;
end;

procedure TmstProjectsBrowserFilterMP.SetCustomer(const Value: string);
begin
  FCustomer := Value;
end;

procedure TmstProjectsBrowserFilterMP.SetDiameter(const Value: string);
begin
  FDiameter := Value;
end;

procedure TmstProjectsBrowserFilterMP.SetDismantled(const Value: TBoolValue);
begin
  FDismantled := Value;
end;

procedure TmstProjectsBrowserFilterMP.SetDocDateEnd(const Value: TDateTime);
begin
  FDocDateEnd := Value;
end;

procedure TmstProjectsBrowserFilterMP.SetDocDateStart(const Value: TDateTime);
begin
  FDocDateStart := Value;
end;

procedure TmstProjectsBrowserFilterMP.SetDocNumber(const Value: string);
begin
  FDocNumber := Value;
end;

procedure TmstProjectsBrowserFilterMP.SetExecutor(const Value: string);
begin
  FExecutor := Value;
end;

procedure TmstProjectsBrowserFilterMP.SetInfo(const Value: string);
begin
  FInfo := Value;
end;

procedure TmstProjectsBrowserFilterMP.SetNeedCheck(const Value: TBoolValue);
begin
  FNeedCheck := Value;
end;

procedure TmstProjectsBrowserFilterMP.SetUnderground(const Value: TBoolValue);
begin
  FUnderground := Value;
end;

procedure TmstProjectsBrowserFilterMP.SetVoltage(const Value: string);
begin
  FVoltage := Value;
end;

function TmstProjectsBrowserFilterMP.UseDocDateEnd: Boolean;
var
  Y, M, D: Word;
begin
  DecodeDate(FDocDateEnd, Y, M, D);
  Result := (Y <> 2100) or (M <> 1) or (D <> 1);
end;

function TmstProjectsBrowserFilterMP.UseDocDateStart: Boolean;
begin
  Result := FDocDateStart <> 0;
end;

end.
