unit uMStClassesProjectsBrowserMP;

interface

uses
  SysUtils;

type
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
    FConfirmed: Boolean;
    FUseConfirmed: Boolean;
    FConfirmDateEnd: TDateTime;
    FDocDateEnd: TDateTime;
    FInfo: string;
    procedure SetAddress(const Value: string);
    procedure SetConfirmDateEnd(const Value: TDateTime);
    procedure SetConfirmDateStart(const Value: TDateTime);
    procedure SetConfirmed(const Value: Boolean);
    procedure SetCustomer(const Value: string);
    procedure SetDiameter(const Value: string);
    procedure SetDocDateEnd(const Value: TDateTime);
    procedure SetDocDateStart(const Value: TDateTime);
    procedure SetDocNumber(const Value: string);
    procedure SetExecutor(const Value: string);
    procedure SetUseConfirmed(const Value: Boolean);
    procedure SetVoltage(const Value: string);
    procedure SetInfo(const Value: string);
  public
    constructor Create;
    //
    procedure Clear();
    function IsEmpty: Boolean;
    //
    property Address: string read FAddress write SetAddress;
    property DocNumber: string read FDocNumber write SetDocNumber;
    property DocDateStart: TDateTime read FDocDateStart write SetDocDateStart;
//    property UseDocDateStart: Boolean;
    property DocDateEnd: TDateTime read FDocDateEnd write SetDocDateEnd;
//    property UseDocDateEnd: Boolean;
    property Diameter: string read FDiameter write SetDiameter;
    property Voltage: string read FVoltage write SetVoltage;
    property Customer: string read FCustomer write SetCustomer;
    property Executor: string read FExecutor write SetExecutor;
    property Confirmed: Boolean read FConfirmed write SetConfirmed;
    property UseConfirmed: Boolean read FUseConfirmed write SetUseConfirmed;
    property ConfirmDateStart: TDateTime read FConfirmDateStart write SetConfirmDateStart;
//    property UseConfirmDateStart: Boolean;
    property ConfirmDateEnd: TDateTime read FConfirmDateEnd write SetConfirmDateEnd;
//    property UseConfirmDateEnd: Boolean;
    property Info: string read FInfo write SetInfo;
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
  FConfirmed := False;
  FUseConfirmed := False;
  FConfirmDateStart := EncodeDate(2000, 1, 1);
  FConfirmDateEnd := EncodeDate(2100, 1, 1);
  FDocDateStart := EncodeDate(2000, 1, 1);
  FDocDateEnd := EncodeDate(2100, 1, 1);
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
    (FConfirmed = False) and
    (FUseConfirmed = False) and
    (FConfirmDateStart = EncodeDate(2000, 1, 1)) and
    (FConfirmDateEnd = EncodeDate(2100, 1, 1)) and
    (FDocDateStart = EncodeDate(2000, 1, 1)) and
    (FDocDateEnd = EncodeDate(2100, 1, 1));
end;

procedure TmstProjectsBrowserFilterMP.SetAddress(const Value: string);
begin
  FAddress := Value;
end;

procedure TmstProjectsBrowserFilterMP.SetConfirmDateEnd(const Value: TDateTime);
begin
  FConfirmDateEnd := Value;
end;

procedure TmstProjectsBrowserFilterMP.SetConfirmDateStart(const Value: TDateTime);
begin
  FConfirmDateStart := Value;
end;

procedure TmstProjectsBrowserFilterMP.SetConfirmed(const Value: Boolean);
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

procedure TmstProjectsBrowserFilterMP.SetUseConfirmed(const Value: Boolean);
begin
  FUseConfirmed := Value;
end;

procedure TmstProjectsBrowserFilterMP.SetVoltage(const Value: string);
begin
  FVoltage := Value;
end;

end.
