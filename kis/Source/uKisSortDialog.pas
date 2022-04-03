{*******************************************************}
{                                                       }
{       "ИС МП УГА"                                     }
{       Диалог сортировки сущностей                     }
{                                                       }
{       Copyright (c) 2004, МП УГА                      }
{                                                       }
{       Автор: Калабухов А.В.                           }
{                                                       }
{*******************************************************}

{ Описание:
  Имя модуля: Search Dialog
  Версия: 1.1
  Дата последнего изменения: 18.08.2004
  Цель: 
  Используется:
  Использует: 
  Исключения: нет }

unit uKisSortDialog;

interface

{$I KisFlags.pas}

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  CheckLst, StdCtrls, Buttons;

type
  TKisSortDialog = class(TForm)
    lbFields: TListBox;
    lbOrder: TCheckListBox;
    btnOK: TButton;
    btnCancel: TButton;
    Label1: TLabel;
    SpeedButton1: TSpeedButton;
    SpeedButton2: TSpeedButton;
    SpeedButton3: TSpeedButton;
    SpeedButton4: TSpeedButton;
    procedure SpeedButton3Click(Sender: TObject);
    procedure SpeedButton4Click(Sender: TObject);
    procedure SpeedButton1Click(Sender: TObject);
    procedure SpeedButton2Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

implementation

{$R *.dfm}

procedure TKisSortDialog.SpeedButton3Click(Sender: TObject);
begin
  if lbOrder.ItemIndex > 0 then
  begin
    lbOrder.Items.Exchange(lbOrder.ItemIndex, Pred(lbOrder.ItemIndex));
  end;
end;

procedure TKisSortDialog.SpeedButton4Click(Sender: TObject);
begin
  if (lbOrder.ItemIndex >= 0) and (lbOrder.ItemIndex < Pred(lbOrder.Items.Count)) then
  begin
    lbOrder.Items.Exchange(Pred(lbOrder.ItemIndex), lbOrder.ItemIndex);
  end;
end;

procedure TKisSortDialog.SpeedButton1Click(Sender: TObject);
begin
  if lbFields.ItemIndex >= 0 then
  begin
    lbOrder.AddItem(lbFields.Items[lbFields.ItemIndex], lbFields.Items.Objects[lbFields.ItemIndex]);
    lbFields.Items.Delete(lbFields.ItemIndex);
  end;
end;

procedure TKisSortDialog.SpeedButton2Click(Sender: TObject);
begin
  if lbOrder.ItemIndex >= 0 then
  begin
    lbFields.AddItem(lbOrder.Items[lbOrder.ItemIndex], lbOrder.Items.Objects[lbOrder.ItemIndex]);
    lbOrder.Items.Delete(lbOrder.ItemIndex);
  end;
end;

end.
