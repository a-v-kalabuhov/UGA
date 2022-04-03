{*******************************************************}
{                                                       }
{       "ИС МП УГА"                                     }
{       Редактор контрагента-физлица                    }
{                                                       }
{       Copyright (c) 2003, МП УГА                      }
{                                                       }
{       Автор: Калабухов А.В.                           }
{                                                       }
{*******************************************************}

{ Описание: визуальный редактор свойств контрагента-физлица
  Имя модуля: Contragent-Person Editor
  Версия: 1.0
  Дата последнего изменения: 27.06.2004
  Цель: содержит класс - редактор контрагента-физлица.
  Используется:
  Использует:   Contragent Editor
  Исключения:   }

unit uKisContragentPersonEditor;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  StdCtrls, ComCtrls,
  // Project
  uKisContragentEditor, Dialogs, JvBaseDlg, JvDesktopAlert;

type
  TKisContragentPersonEditor = class(TKisContragentEditor)
    gbPersonDoc: TGroupBox;
    Label10: TLabel;
    cbDocType: TComboBox;
    Label11: TLabel;
    edDocNumber: TEdit;
    Label12: TLabel;
    edDocSerie: TEdit;
    Label13: TLabel;
    dtpDocDate: TDateTimePicker;
    Label14: TLabel;
    cbDocOwner: TComboBox;
    procedure edNameChange(Sender: TObject);
    procedure btnOkClick(Sender: TObject);
  end;

implementation

{$R *.dfm}

procedure TKisContragentPersonEditor.btnOkClick(Sender: TObject);
begin
  inherited;
  ;
end;

procedure TKisContragentPersonEditor.edNameChange(Sender: TObject);
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
