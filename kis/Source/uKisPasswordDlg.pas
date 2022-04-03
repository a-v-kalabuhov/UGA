{*******************************************************}
{                                                       }
{       "ИС МП УГА"                                     }
{       Диалог авторизации пользователя                 }
{                                                       }
{       Copyright (c) 2003-2005, МП УГА                 }
{                                                       }
{       Автор: Калабухов А.В.                           }
{                                                       }
{*******************************************************}

{ Описание:
  Имя модуля: Kernel SQL Classes
  Версия: 1.00
  Дата последнего изменения: 21.06.2005
  Цель:
  Используется:
  Использует:   
  Исключения:   }
{
}

unit uKisPasswordDlg;

interface

uses
	SysUtils, WinTypes, WinProcs, Messages, Classes, Graphics, Forms, StdCtrls,
  Controls, IBSQL, IBDatabase, Db, IBCustomDataSet, IBQuery;

type
  TKisLogonEvent = function (const PeopleId: Integer;
    const UserName, RoleName, Password: String): Boolean of object;
  TKisLastUserEvent = procedure (var OfficeId, UserID: Integer) of object;

	TRegForm = class(TForm)
		Label1: TLabel;
    edtPassword: TEdit;
		Label2: TLabel;
    btnOk: TButton;
    btnCancel: TButton;
    cbOffices: TComboBox;
    Label3: TLabel;
    cbPeople: TComboBox;
    ibqOffices: TIBQuery;
    ibqPeople: TIBQuery;
    procedure edtPasswordChange(Sender: TObject);
    procedure cbPeopleChange(Sender: TObject);
    procedure btnOkClick(Sender: TObject);
    procedure cbOfficesClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
	private
    FOnLogon: TKisLogonEvent;
    FOnReadLasUser: TKisLastUserEvent;
    procedure LoadPeople(PeopleId: Integer);
    procedure SetControls;
    procedure SetCurrentOffice;
    procedure SetCurrentPeople;
    procedure Initialize(OfficeID, PeopleID: Integer);
	public
    function GetCurrentOfficeId: Integer;
    property OnLogon: TKisLogonEvent read FOnLogon write FOnLogon;
    property OnReadLastUser: TKisLastUserEvent read FOnReadLasUser write FOnReadLasUser;
	end;

implementation

{$R *.DFM}

uses
  uKisConsts;

resourcestring
  SQ_USER_PARAMS = 'SELECT ID, FULL_NAME, USER_NAME, ROLE_NAME, OFFICES_ID '
                 + 'FROM PEOPLE '
                 + 'WHERE (ENABLED=''T'') AND (OFFICES_ID=%d) '
                 + 'ORDER BY FULL_NAME';


procedure TRegForm.Initialize(OfficeID, PeopleID: Integer);
var
  I, OffIndex: Integer;
begin
  with ibqOffices do
  begin
    Close;
    Open;
    OffIndex := -1;
    cbOffices.Items.Clear;
    while not Eof do
    begin
      I := cbOffices.Items.Add(FieldByName(SF_NAME).AsString);
      if FieldbyName(SF_ID).AsInteger = OfficeID then
        OffIndex := I;
      Next;
    end;
  end;
  cbOffices.ItemIndex := OffIndex;
  LoadPeople(PeopleID);
  edtPassword.Clear;
  edtPassword.SetFocus;
end;

procedure TRegForm.LoadPeople(PeopleId: Integer);
var
  I, PeopleIndex: Integer;
begin
  PeopleIndex := -1;
  SetCurrentOffice;
  //загружаем пользователей
  with ibqPeople do
  begin
    Close;
    SQL.Clear;
    SQL.Text := Format(SQ_USER_PARAMS, [ibqOffices.FieldByName(SF_ID).AsInteger]);
    Open;
    FetchAll;
    cbPeople.Items.Clear;
    while not Eof do
    begin
      I := cbPeople.Items.Add(FieldByName(SF_FULL_NAME).AsString);
      if FieldByName(SF_ID).AsInteger = PeopleId then
        PeopleIndex := I;
      Next;
    end;
  end;
  cbPeople.ItemIndex := PeopleIndex;
  SetControls;
end;

procedure TRegForm.SetControls;
begin
  btnOk.Enabled := (cbPeople.ItemIndex >= 0) and (edtPassword.Text <> '');
end;

procedure TRegForm.edtPasswordChange(Sender: TObject);
begin
  SetControls;
end;

procedure TRegForm.cbPeopleChange(Sender: TObject);
begin
  SetControls;
end;

//ищет отдел, соответствующий выбранному
procedure TRegForm.SetCurrentOffice;
var
  I: Integer;
begin
  with ibqOffices do
  begin
    Active := True;
    First;
    for I := 1 to cbOffices.ItemIndex do
      Next;
  end;
end;

//ищет пользователя, соответствующего выбранному
procedure TRegForm.SetCurrentPeople;
var
  I: Integer;
begin
  with ibqPeople do
  begin
    Active := True;
    First;
    for I := 1 to cbPeople.ItemIndex do
      Next;     // Почему не локейт?
  end;
end;

procedure TRegForm.btnOkClick(Sender: TObject);
var
  UserName, RoleName: String;
  OfficeID, PeopleID: Integer;
begin
  //ищем пользователя
  SetCurrentPeople;
  UserName := ibqPeople.FieldByName(SF_USER_NAME).AsString;
  PeopleId := ibqPeople.FieldByName(SF_ID).AsInteger;
  if not ibqPeople.FieldByName(SF_ROLE_NAME).IsNull then
    RoleName := ibqPeople.FieldByName(SF_ROLE_NAME).AsString
  else
    RoleName := ibqOffices.FieldByName(SF_ROLE_NAME).AsString;
  OfficeID := ibqOffices.FieldByName(SF_ID).AsInteger;

  if OnLogon(PeopleId, UserName, RoleName, edtPassword.Text) then
    ModalResult := mrOK
  else
    Initialize(OfficeID, PeopleID);
end;

procedure TRegForm.cbOfficesClick(Sender: TObject);
begin
  LoadPeople(0);
end;

procedure TRegForm.FormShow(Sender: TObject);
var
  OfficeID, PeopleID: Integer;
begin
  OnReadLastUser(OfficeID, PeopleID);
  Initialize(OfficeID, PeopleID);
end;

function TRegForm.GetCurrentOfficeId: Integer;
begin
  Result := ibqOffices.FieldByName(SF_ID).AsInteger;
end;

end.
