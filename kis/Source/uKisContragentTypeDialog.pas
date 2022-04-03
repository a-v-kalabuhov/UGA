{*******************************************************}
{                                                       }
{       "ИС МП УГА"                                     }
{       Диалог выбора типа контрагента                  }
{                                                       }
{       Copyright (c) 2003, МП УГА                      }
{                                                       }
{       Автор: Калабухов А.В.                           }
{                                                       }
{*******************************************************}

{ Описание:
  Имя модуля: COntragent Type Dialog
  Версия: 1.0
  Дата последнего изменения: 27.06.2004
  Цель: 
  Используется:
  Использует:   только системные юниты.
  Исключения:   }

unit uKisContragentTypeDialog;

interface

{$I KisFlags.pas}

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  StdCtrls, ExtCtrls;

type
  TKisContragentTypeDialog = class(TForm)
    Button1: TButton;
    Button2: TButton;
    RadioGroup1: TRadioGroup;
  end;

implementation

{$R *.dfm}

end.
