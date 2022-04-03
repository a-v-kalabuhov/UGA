{                                                       }
{       "ИС МП УГА"                                     }
{       Редактор исходящей документации                 }
{                                                       }
{       Copyright (c) 2005, МП УГА                      }
{                                                       }
{       Автор: Сирота Е.А.                              }
{                                                       }
{*******************************************************}

{ Описание:
  Имя модуля: Address Editor
  Версия: 1.01
  Дата последнего изменения: 13.05.2005
  Цель:
  Используется:
  Использует:   Entity Editor, KIS Consts
  Исключения:   }

{
  1.01          13.05.2005
    - увеличина длина edFirm
}

unit uKisOutcomingLetterEditor;

interface

{$I KisFlags.pas}

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, Grids, DBGrids, ComCtrls, DB,
  JvBaseDlg, JvDesktopAlert,
  uCommonUtils,
  // Project
  uKisEntityEditor, uKisAppModule;

type
  TKisOutcomingLetterEditor = class(TKisEntityEditor)
    PageControl1: TPageControl;
    TabSheet1: TTabSheet;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    Label8: TLabel;
    cbKind: TComboBox;
    edNumber: TEdit;
    edDateReg: TEdit;
    mContent: TMemo;
    cbNotification: TCheckBox;
    cbDelivered: TCheckBox;
    edDeliveredDate: TEdit;
    cbOffice: TComboBox;
    cbPeople: TComboBox;
    edFirm: TEdit;
    btnSelectFirm: TButton;
    btnFirmClear: TButton;
    TabSheet2: TTabSheet;
    dbgLetterSupplement: TDBGrid;
    btnSupplemCreate: TButton;
    btnSupplemDelete: TButton;
    btnSupplemEdit: TButton;
    TabSheet3: TTabSheet;
    dbgLettersLink: TDBGrid;
    dsLetterSupplement: TDataSource;
    btnLinkSelect: TButton;
    btnLinkDelete: TButton;
    dsLettersLink: TDataSource;
    btnLinkDetail: TButton;
    Label9: TLabel;
    edSeqNumber: TEdit;
    edAddress: TEdit;
    Label10: TLabel;
    procedure edDateRegKeyPress(Sender: TObject; var Key: Char);
    procedure edDeliveredDateKeyPress(Sender: TObject; var Key: Char);
    procedure btnSupplemCreateClick(Sender: TObject);
    procedure btnSupplemDeleteClick(Sender: TObject);
    procedure btnSupplemEditClick(Sender: TObject);
    procedure dbgLetterSupplementExit(Sender: TObject);
    procedure btnLinkSelectClick(Sender: TObject);
    procedure btnLinkDeleteClick(Sender: TObject);
    procedure btnLinkEditClick(Sender: TObject);
    procedure dbgLettersLinkExit(Sender: TObject);
    procedure edFirmKeyUp(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure FormShow(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
  end;


implementation

{$R *.dfm}

procedure TKisOutcomingLetterEditor.edDateRegKeyPress(Sender: TObject;
  var Key: Char);
begin
  inherited;
  if not (Key in (NumberChars + [#8, '.'])) then
    Key := #0;
end;

procedure TKisOutcomingLetterEditor.edDeliveredDateKeyPress(
  Sender: TObject; var Key: Char);
begin
  inherited;
  if not (Key in (NumberChars + [#8, '.'])) then
    Key := #0;
end;

procedure TKisOutcomingLetterEditor.btnSupplemCreateClick(Sender: TObject);
begin
  inherited;
  dbgLetterSupplement.DataSource.DataSet.Append;
end;

procedure TKisOutcomingLetterEditor.btnSupplemDeleteClick(Sender: TObject);
begin
  inherited;
  if not dbgLetterSupplement.DataSource.DataSet.IsEmpty then
  //if MessageBox(Handle, PChar(S_DELETE_RECORD), PChar(S_WARN), MB_YESNO + MB_ICONQUESTION) = ID_YES then
     dbgLetterSupplement.DataSource.DataSet.Delete;
end;

procedure TKisOutcomingLetterEditor.btnSupplemEditClick(Sender: TObject);
begin
  inherited;
  if not dbgLetterSupplement.DataSource.DataSet.IsEmpty then
    dbgLetterSupplement.DataSource.DataSet.Edit;
end;


procedure TKisOutcomingLetterEditor.dbgLetterSupplementExit(
  Sender: TObject);
begin
  if dbgLetterSupplement.DataSource.DataSet.State in [dsEdit, dsInsert] then
    dbgLetterSupplement.DataSource.DataSet.Post;
end;

procedure TKisOutcomingLetterEditor.btnLinkSelectClick(Sender: TObject);
begin
  //inherited;
  //dbgLettersLink.DataSource.DataSet.Insert;
end;

procedure TKisOutcomingLetterEditor.btnLinkDeleteClick(Sender: TObject);
begin
  inherited;
  if not dbgLettersLink.DataSource.DataSet.IsEmpty then
  //if MessageBox(Handle, PChar(S_DELETE_RECORD), PChar(S_WARN), MB_YESNO + MB_ICONQUESTION) = ID_YES then
    dbgLettersLink.DataSource.DataSet.Delete;
end;

procedure TKisOutcomingLetterEditor.btnLinkEditClick(Sender: TObject);
begin
  inherited;
  if not dbgLettersLink.DataSource.DataSet.IsEmpty then
    dbgLettersLink.DataSource.DataSet.Edit;
end;

procedure TKisOutcomingLetterEditor.dbgLettersLinkExit(Sender: TObject);
begin
  if dbgLettersLink.DataSource.DataSet.State in [dsEdit, dsInsert] then
     dbgLettersLink.DataSource.DataSet.Post;
end;

procedure TKisOutcomingLetterEditor.edFirmKeyUp(Sender: TObject;
  var Key: Word; Shift: TShiftState);
begin
  inherited;
  if (ssCtrl in Shift) and (Key = VK_RETURN) then
  if btnSelectFirm.Enabled then
    btnSelectFirm.OnClick(Self);
end;

procedure TKisOutcomingLetterEditor.FormShow(Sender: TObject);
begin
  inherited;
  AppModule.ReadGridProperties(Self, dbgLetterSupplement);
  AppModule.ReadGridProperties(Self, dbgLettersLink);
end;

procedure TKisOutcomingLetterEditor.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  inherited;
  AppModule.WriteGridProperties(Self, dbgLetterSupplement);
  AppModule.WriteGridProperties(Self, dbgLettersLink);
end;

end.
