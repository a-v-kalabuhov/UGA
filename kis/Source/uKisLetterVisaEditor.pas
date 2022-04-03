{*******************************************************}
{                                                       }
{       "ИС МП УГА"                                     }
{       Редактор визы письма                            }
{                                                       }
{       Copyright (c) 2004, МП УГА                      }
{                                                       }
{       Автор: Калабухов А.В.                           }
{                                                       }
{*******************************************************}

{ Описание:
  Имя модуля: LetterVisa Editor
  Версия: 1.0
  Дата последнего изменения: 11.09.2004
  Цель:
  Используется: 
  Использует: 
  Исключения: нет }

unit uKisLetterVisaEditor;

interface

{$I KisFlags.pas}

uses
  // System
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms, Dialogs, StdCtrls,
  JvBaseDlg, JvDesktopAlert,
  uCommonUtils,
  // Project
  uKisEntityEditor;

type
  TKisLetterVisaEditor = class(TKisEntityEditor)
    edDocDate: TEdit;
    Label1: TLabel;
    edContent: TEdit;
    edControlDate: TEdit;
    Label2: TLabel;
    cbSignature: TComboBox;
    Label3: TLabel;
    Label4: TLabel;
    procedure edDocDateKeyPress(Sender: TObject; var Key: Char);
    procedure edControlDateKeyPress(Sender: TObject; var Key: Char);
  end;

implementation

{$R *.dfm}

procedure TKisLetterVisaEditor.edDocDateKeyPress(Sender: TObject;
  var Key: Char);
begin
  inherited;
  if not (Key in (NumberChars + [#8, '.'])) then
    Key := #0;
end;

procedure TKisLetterVisaEditor.edControlDateKeyPress(Sender: TObject;
  var Key: Char);
begin
  inherited;
  if not (Key in (NumberChars + [#8, '.'])) then
    Key := #0;
end;

end.
