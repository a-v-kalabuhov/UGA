unit uKisProjectsJournal;

interface

{$I KisFlags.pas}

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, DB, ImgList, ActnList,
  uKisSQLClasses, uKisEntityEditor;

type
  TKisPrjJournalEntry = class(TKisVisualEntity)
  private
    FOfficeId: Integer;
    FRecivedDate: string;
    FCustomer: string;
    FDocNumber: String;
    FMoney: Double;
    FProjectOrg: string;
    FAccountNumber: string;
    FAddress: string;
    FDocDate: string;
    procedure SetAccountNumber(const Value: string);
    procedure SetAddress(const Value: string);
    procedure SetCustomer(const Value: string);
    procedure SetDocDate(const Value: string);
    procedure SetDocNumber(const Value: String);
    procedure SetMoney(const Value: Double);
    procedure SetOfficeId(const Value: Integer);
    procedure SetProjectOrg(const Value: string);
    procedure SetRecivedDate(const Value: string);
  public
    property DocNumber: String read FDocNumber write SetDocNumber;
    property DocDate: string read FDocDate write SetDocDate;
    property RecivedDate: string read FRecivedDate write SetRecivedDate;
    property Address: string read FAddress write SetAddress;
    property Customer: string read FCustomer write SetCustomer;
    property AccountNumber: string read FAccountNumber write SetAccountNumber;
    property ProjectOrg: string read FProjectOrg write SetProjectOrg;
    //
    property Money: Double read FMoney write SetMoney;
    //
//    property LicensedOrgId: Integer read FLicensedOrgId write SetLicensedOrgId;
    property OfficeId: Integer read FOfficeId write SetOfficeId;
  end;

  TKisProjectsJournalMngr = class(TKisSQLMngr)
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  KisProjectsJournalMngr: TKisProjectsJournalMngr;

implementation

{$R *.dfm}

{ TKisPrjJournalEntry }

procedure TKisPrjJournalEntry.SetAccountNumber(const Value: string);
begin
  FAccountNumber := Value;
end;

procedure TKisPrjJournalEntry.SetAddress(const Value: string);
begin
  FAddress := Value;
end;

procedure TKisPrjJournalEntry.SetCustomer(const Value: string);
begin
  FCustomer := Value;
end;

procedure TKisPrjJournalEntry.SetDocDate(const Value: string);
begin
  FDocDate := Value;
end;

procedure TKisPrjJournalEntry.SetDocNumber(const Value: String);
begin
  FDocNumber := Value;
end;

procedure TKisPrjJournalEntry.SetMoney(const Value: Double);
begin
  FMoney := Value;
end;

procedure TKisPrjJournalEntry.SetOfficeId(const Value: Integer);
begin
  FOfficeId := Value;
end;

procedure TKisPrjJournalEntry.SetProjectOrg(const Value: string);
begin
  FProjectOrg := Value;
end;

procedure TKisPrjJournalEntry.SetRecivedDate(const Value: string);
begin
  FRecivedDate := Value;
end;

end.
