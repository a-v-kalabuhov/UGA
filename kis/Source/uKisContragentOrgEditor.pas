{*******************************************************}
{                                                       }
{       "ИС МП УГА"                                     }
{       Редактор контрагента-организации                }
{                                                       }
{       Copyright (c) 2003-2005, МП УГА                 }
{                                                       }
{       Автор: Калабухов А.В.                           }
{                                                       }
{*******************************************************}

{ Описание: визуальный редактор свойств контрагента-организации
  Имя модуля: Contragent Editor
  Версия: 1.01
  Дата последнего изменения: 25.06.2005
  Цель: содержит класс - редактор контрагента-организации.
  Используется:
  Использует:   Contragent Editor
  Исключения:   }

unit uKisContragentOrgEditor;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  StdCtrls, ComCtrls,  ExtCtrls, Buttons,
  // Project
  uKisContragentEditor, uKisUtils, Dialogs, JvBaseDlg, JvDesktopAlert;

type
  TKisContragentOrgEditor = class(TKisContragentEditor)
    gbHeadOrg: TGroupBox;
    Label23: TLabel;
    cbSubdivisionType: TComboBox;
    Label24: TLabel;
    edHeadOrgName: TEdit;
    edHeadOrgAddress: TEdit;
    btnSelectHeadOrg: TButton;
    btnClearHeadOrg: TButton;
    Label22: TLabel;
    edKPP: TEdit;
    Label19: TLabel;
    edOKPF: TEdit;
    Label20: TLabel;
    edOKPO: TEdit;
    Label21: TLabel;
    edOKONH: TEdit;
    pOfficials: TPanel;
    gbChief: TGroupBox;
    gbContacter: TGroupBox;
    Label25: TLabel;
    edContacterPost: TEdit;
    lContacterPost: TLabel;
    edContacterFIO: TEdit;
    lContacterName: TLabel;
    lChiefPost: TLabel;
    edChiefFio: TEdit;
    edChiefPost: TEdit;
    Label18: TLabel;
    edAccountantFIO: TEdit;
    lContacterPhone: TLabel;
    edContacterPhone: TEdit;
    gbChiefDocs: TGroupBox;
    cbChiefDocType: TComboBox;
    Label261: TLabel;
    edChiefDocNumber: TEdit;
    Label14: TLabel;
    btnAddChiefDoc: TSpeedButton;
    edChiefDocs: TEdit;
    dtpChiefDocDate: TDateTimePicker;
    Label1: TLabel;
    procedure btnAddChiefDocClick(Sender: TObject);
    procedure edNameShortExit(Sender: TObject);
    procedure edNameExit(Sender: TObject);
    procedure edNameShortChange(Sender: TObject);
    procedure edNameChange(Sender: TObject);
  end;

implementation

{$R *.dfm}

uses
  uKisConsts, uKisEntityEditor;

procedure TKisContragentOrgEditor.btnAddChiefDocClick(Sender: TObject);
var
  NewDoc: String;
begin
  // Проверяем правильность ввода
    // Тип документа
    if cbChiefDocType.ItemIndex < 0 then
    begin
      MessageBox(Handle, PChar(S_WARN), PChar(S_CHECK_CHIEF_DOC_TYPE), MB_ICONWARNING + MB_OK);
      cbChiefDocType.SetFocus;
      Exit;
    end;
    // Дату
    if dtpChiefDocDate.Visible then
    if dtpChiefDocDate.Date <= MIN_DOC_DATE then
    begin
      MessageBox(Handle, PChar(S_WARN), PChar(S_CHECK_CHIEF_DOC_DATE), MB_ICONWARNING + MB_OK);
      dtpChiefDocDate.SetFocus;
      Exit;
    end;
  // Формируем строку
  NewDoc := cbChiefDocType.Text;
  if Trim(edChiefDocNumber.Text) <> '' then
    NewDoc := NewDoc + ' №' + edChiefDocNumber.Text;
  if dtpChiefDocDate.Visible then
    NewDoc := NewDoc + ' от ' + FormatDateTime(S_DATESTR_FORMAT, dtpChiefDocDate.Date);
  // Проверяем длину строки и максимальное кол-во символов
  if edChiefDocs.MaxLength > 0 then
  if (Length(NewDoc) + Length(edChiefDocs.Text)) > edChiefDocs.MaxLength then
  begin
    MessageBox(Handle, PChar(S_WARN), PChar('Список документов слишком большой!'), MB_ICONWARNING + MB_OK);
    edChiefDocs.SetFocus;
    Exit;
  end;
  // Добавляем строку в edChiefDocs
  if Trim(edChiefDocs.Text) <> '' then
    NewDoc := ', ' + NewDoc;
  edChiefDocs.Text := edChiefDocs.Text + NewDoc;
end;

procedure TKisContragentOrgEditor.edNameShortExit(Sender: TObject);
var
  S: String;
begin
  inherited;
  if GetOrgShortName(edNameShort.Text, S) then
    edNameShort.Text := S;
end;

procedure TKisContragentOrgEditor.edNameExit(Sender: TObject);
var
  S: String;
begin
  inherited;
  if Trim(edNameShort.Text) = '' then
  begin
    GetOrgShortName(edName.Text, S);
    edNameShort.Text := S;
  end;
end;

procedure TKisContragentOrgEditor.edNameShortChange(Sender: TObject);
begin
  inherited;
  if Length(edNameShort.Text) > edNameShort.MaxLength then
  begin
    btnOk.Enabled := False;
    edNameShort.Color := $3333FF;
  end
  else
  begin
    btnOk.Enabled := True;
    edNameShort.Color := clWindow;
  end;
end;

procedure TKisContragentOrgEditor.edNameChange(Sender: TObject);
begin
  inherited;
  if Length(edName.Text) > edName.MaxLength then
  begin
    btnOk.Enabled := False;
    edName.Color := $3333FF;
  end
  else
  begin
    btnOk.Enabled := True;
    edName.Color := clWindow;
  end;
end;

end.
