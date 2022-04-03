{*******************************************************}
{                                                       }
{       "ИС МП УГА"                                     }
{       Редактор контрагента-ЧП                         }
{                                                       }
{       Copyright (c) 2003, МП УГА                      }
{                                                       }
{       Автор: Калабухов А.В.                           }
{                                                       }
{*******************************************************}

{ Описание: визуальный редактор свойств контрагента-ЧП
  Имя модуля: Contragent-Private Editor
  Версия: 1.0
  Дата последнего изменения: 27.06.2004
  Цель: содержит класс - редактор контрагента-ЧП.
  Используется:
  Использует:   Contragent-Person Editor
  Исключения:   }

unit uKisContragentPrivateEditor;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  ComCtrls, StdCtrls,
  // Project
  uKisContragentPersonEditor, Dialogs, JvBaseDlg, JvDesktopAlert;

type
  TKisContragentPrivateEditor = class(TKisContragentPersonEditor)
    GroupBox1: TGroupBox;
    dtpCertDate: TDateTimePicker;
    edCertNumber: TEdit;
    Label15: TLabel;
    Label16: TLabel;
    edBusiness: TEdit;
    Label17: TLabel;
    Label18: TLabel;
    edCertOwner: TComboBox;
    procedure FormShow(Sender: TObject);
    procedure edNameChange(Sender: TObject);
    procedure edNameShortChange(Sender: TObject);
  end;

implementation

uses uKisContragentEditor;

{$R *.dfm}

procedure TKisContragentPrivateEditor.FormShow(Sender: TObject);
begin
  inherited;
  if Trim(edName.Text) = '' then
    edName.Text := 'ИП ';
end;

procedure TKisContragentPrivateEditor.edNameChange(Sender: TObject);
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

procedure TKisContragentPrivateEditor.edNameShortChange(Sender: TObject);
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

end.
