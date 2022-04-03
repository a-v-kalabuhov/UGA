{*******************************************************}
{                                                       }
{       "ИС МП УГА"                                     }
{       Редактор контрагента                            }
{                                                       }
{       Copyright (c) 2003, МП УГА                      }
{                                                       }
{       Автор: Калабухов А.В.                           }
{                                                       }
{*******************************************************}

{ Описание: визуальный редактор свойств контрагента
  Имя модуля: Contragent Editor
  Версия: 1.0
  Дата последнего изменения: 27.06.2004
  Цель: содержит класс - редактор контрагента, базовый для редакторов
        контрагентов конкретных типов.
  Используется:
  Использует:   KIS Consts, Entity Editor
  Исключения:   }

unit uKisContragentEditor;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  StdCtrls, Dialogs,
  JvBaseDlg, JvDesktopAlert,
  uCommonUtils,
  // Project
  uKisEntityEditor;

type
  TKisContragentEditor = class(TKisEntityEditor)
    gbCommon: TGroupBox;
    edName: TEdit;
    lName: TLabel;
    lShortName: TLabel;
    edNameShort: TEdit;
    lAddress1: TLabel;
    edAddr1: TEdit;
    lAddress2: TLabel;
    edAddr2: TEdit;
    btnAddress1: TButton;
    btnAddress2: TButton;
    lINN: TLabel;
    edINN: TEdit;
    lPhones: TLabel;
    edPhones: TEdit;
    IDLabel: TLabel;
    mComment: TMemo;
    lComment: TLabel;
    gbBank: TGroupBox;
    lBank: TLabel;
    lAccountType: TLabel;
    cbKindAccount: TComboBox;
    edBank: TEdit;
    lAccount: TLabel;
    edBankAccount: TEdit;
    btnBank: TButton;
    procedure edAddr1KeyUp(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure edAddr2KeyUp(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure edBankKeyUp(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure btnCancelClick(Sender: TObject);
  published
    procedure EditNumberField(Sender: TObject; var Key: Char);
  end;

implementation

{$R *.dfm}

procedure TKisContragentEditor.btnCancelClick(Sender: TObject);
begin
  inherited;
  ;
end;

procedure TKisContragentEditor.edAddr1KeyUp(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  inherited;
  if (ssCtrl in Shift) and (Key = VK_RETURN) then
    btnAddress1.OnClick(Self);
end;

procedure TKisContragentEditor.edAddr2KeyUp(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  inherited;
  if (ssCtrl in Shift) and (Key = VK_RETURN) then
    btnAddress2.OnClick(Self);
end;

procedure TKisContragentEditor.edBankKeyUp(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  inherited;
  if (ssCtrl in Shift) and (Key = VK_RETURN) then
    btnBank.OnClick(Self);
end;

procedure TKisContragentEditor.EditNumberField(Sender: TObject;
  var Key: Char);
begin
  if not (Key in (NumberChars + [#8])) then
    Key := #0;
end;

end.
 
