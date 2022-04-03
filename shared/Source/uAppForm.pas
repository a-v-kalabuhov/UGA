{*******************************************************}
{                                                       }
{       "Нужные окна" v 1.1                             }
{       Application Form Unit                           }
{                                                       }
{       Copyright (c) 2003, Калабухов А.В.              }
{                                                       }
{       Автор: Калабухов А.В.                           }
{                                                       }
{*******************************************************}

{ Описание:
  Имя модуля: Application Form
  Версия: 1.0
  Дата последнего изменения: 16.08.2003
  Цель: содержит класс окна, которое может монимизировать все приложение.
  Используется: MapView Form
  Использует:
  Исключения:   
  Вывод в БД:
  Вывод:
  До вызова:
  После вызова:   }
  
unit uAppForm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms;

type
  TkaAppForm = class(TForm)
  private
    FMinimizeApp: Boolean;
    procedure OnMinimize(var Message: TWMSysCommand); message WM_SYSCOMMAND;
  published
    property MinimizeApp: Boolean read FMinimizeApp write FMinimizeApp;
  end;

  TkaAppFormClass = class of TkaAppForm;

implementation

{$R *.dfm}

{ TkaMainForm }

procedure TkaAppForm.OnMinimize(var Message: TWMSysCommand);
begin
  if FMinimizeApp and (Message.CmdType = (SC_MINIMIZE or SC_ICON)) then
    Application.Minimize
  else
    DefaultHandler(Message);
end;

end.
