{*******************************************************}
{                                                       }
{       "ИС МП УГА"                                     }
{       Редактор движения письма                        }
{                                                       }
{       Copyright (c) 2004, МП УГА                      }
{                                                       }
{       Автор: Калабухов А.В.                           }
{                                                       }
{*******************************************************}

{ Описание:
  Имя модуля: LetterPassing Editor
  Версия: 1.0
  Дата последнего изменения: 12.09.2004
  Цель:
  Используется: 
  Использует: 
  Исключения: нет }

unit uKisLetterPassingEditor;

interface

{$I KisFlags.pas}

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms, Dialogs, StdCtrls,
  uCommonUtils,
  uKisEntityEditor, JvBaseDlg, JvDesktopAlert;

type
  TKisLetterPassingEditor = class(TKisEntityEditor)
    edDocDate: TEdit;
    Label1: TLabel;
    edContent: TEdit;
    Label4: TLabel;
    cbOffices: TComboBox;
    Label2: TLabel;
    Label3: TLabel;
    cbPeople: TComboBox;
    chbExecuted: TCheckBox;
    procedure edDocDateKeyPress(Sender: TObject; var Key: Char);
  end;

implementation

{$R *.dfm}

procedure TKisLetterPassingEditor.edDocDateKeyPress(Sender: TObject;
  var Key: Char);
begin
  inherited;
  if not (Key in (NumberChars + [#8, '.'])) then
    Key := #0;
end;

end.
