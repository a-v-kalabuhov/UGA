{*******************************************************}
{                                                       }
{       "ИС МП УГА"                                     }
{       Редактор адреса                                 }
{                                                       }
{       Copyright (c) 2003, МП УГА                      }
{                                                       }
{       Автор: Калабухов А.В.                           }
{                                                       }
{*******************************************************}

{ Описание:
  Имя модуля: Address Editor
  Версия: 1.0
  Дата последнего изменения: 27.06.2004
  Цель:
  Используется:
  Использует:   Entity Editor, KIS Consts
  Исключения:   }

unit uKisAddressEditor;

interface

{$I KisFlags.pas}

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  StdCtrls,
  // Project
  uKisEntityEditor, Dialogs, JvBaseDlg, JvDesktopAlert;

type
  TKisAddressEditor = class(TKisEntityEditor)
    Label1: TLabel;
    edIndex: TEdit;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    Label8: TLabel;
    Label9: TLabel;
    cbCountry: TComboBox;
    cbState: TComboBox;
    edRegionOfState: TEdit;
    cbTownKind: TComboBox;
    edStreetName: TEdit;
    cbStreetMark: TComboBox;
    edBuilding: TEdit;
    edCorpus: TEdit;
    edRoom: TEdit;
    Label10: TLabel;
    cbVillageKind: TComboBox;
    cbTownName: TComboBox;
    cbVillageName: TComboBox;
    btnStreet: TButton;
    procedure edIndexKeyUp(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure edStreetNameKeyUp(Sender: TObject; var Key: Word;
      Shift: TShiftState);
  end;

implementation

{$R *.dfm}

uses
  uKisConsts;

procedure TKisAddressEditor.edIndexKeyUp(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if (Key <> VK_DELETE or VK_BACK or VK_INSERT) or
     ((Key < VK_NUMPAD0) and (Key > VK_NUMPAD9)) then
    Key := N_ZERO;
end;

procedure TKisAddressEditor.edStreetNameKeyUp(Sender: TObject;
  var Key: Word; Shift: TShiftState);
begin
  inherited;
  if (ssCtrl in Shift) and (Key = VK_RETURN) then
  if btnStreet.Enabled then
    btnStreet.OnClick(Self);
end;

end.
