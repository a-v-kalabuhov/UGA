{*******************************************************}
{                                                       }
{       "ИС МП УГА"                                     }
{       Редактор сущности                               }
{                                                       }
{       Copyright (c) 2003, МП УГА                      }
{                                                       }
{       Автор: Калабухов А.В.                           }
{                                                       }
{*******************************************************}

{ Описание: абстрактный редактор для всех сущностей в системе.
  Имя модуля: Entity Editor
  Версия: 1.0
  Дата последнего изменения: 27.06.2004
  Цель: содержит базовый класс редактора сущностей.
  Используется:
  Использует:   только системные юниты
  Исключения:   }

unit uKisEntityEditor;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  StdCtrls, Dialogs,
  //
  JvBaseDlg, JvDesktopAlert,
  //
  uVCLUtils,
  //
  uKisClasses;

type
  TKisEntityEditor = class;

  {
    Сущность, которая умеет себя редактировать с помощью визуального редактора (обычной формы :))) 
  }
  TKisVisualEntity = class(TKisEntity)
  private
    FReadOnly: Boolean;
    FEditor: TKisEntityEditor;
    FOldDestroyHandler: TNotifyEvent;
    procedure SetEditor(const Value: TKisEntityEditor);
    procedure DestroyEditor(Sender: TObject);
  protected
    function CreateEditor: TKisEntityEditor; virtual; abstract;
    function GetCaption: String; virtual;
    procedure PrepareEditor(AEditor: TKisEntityEditor); virtual;
    procedure UnprepareEditor(AEditor: TKisEntityEditor); virtual;
    procedure LoadDataIntoEditor(AEditor: TKisEntityEditor); virtual; abstract;
    procedure ReadDataFromEditor(AEditor: TKisEntityEditor); virtual; abstract;
    function CheckEditor(AEditor: TKisEntityEditor): Boolean; virtual; abstract;
  public
    procedure Assign(Source: TPersistent); override;
    function Edit: Boolean;
    property EntityEditor: TKisEntityEditor read FEditor write SetEditor;
    property ReadOnly: Boolean read FReadOnly write FReadOnly;
  end;

  TCheckEntityDataProc = function (AEditor: TKisEntityEditor): Boolean of object;

  TKisEntityEditor = class(TForm)
    HintWarnLabel: TLabel;
    btnOk: TButton;
    btnCancel: TButton;
    Alert: TJvDesktopAlert;
    procedure btnOkClick(Sender: TObject);
    procedure btnCancelClick(Sender: TObject);
  private
    FOnCheckEntityData: TCheckEntityDataProc;
  protected
    FEntity: TKisVisualEntity;
    procedure ControlAlert(AControl: TControl; const aText: String);
    procedure CloseControlAlert;
  public
    property Entity: TKisVisualEntity read FEntity;
    property OnCheckEntityData: TCheckEntityDataProc read FOnCheckEntityData write FOnCheckEntityData;
  end;

implementation

{$R *.dfm}

procedure TKisEntityEditor.btnOkClick(Sender: TObject);
begin
  if not Assigned(OnCheckEntityData) then      ///
    ModalResult := mrOK
  else
    if OnCheckEntityData(Self) then
      ModalResult := mrOK;
end;

procedure TKisEntityEditor.CloseControlAlert;
begin
  if Alert.Showing then
    Alert.Close(True);
end;

procedure TKisEntityEditor.ControlAlert(AControl: TControl;
  const aText: String);
begin
  CloseControlAlert;
  Alert.Location.Position := dapCustom;
  with AControl.ClientToScreen(Point(0, AControl.Height)) do
  begin
    Alert.Location.Top := Y + 1;
    Alert.Location.Left := X;
  end;
  Alert.MessageText := aText;
  Alert.Execute;
end;

procedure TKisEntityEditor.btnCancelClick(Sender: TObject);
begin
  ModalResult := mrCancel;
end;

{ TKisVisualEntity }

procedure TKisVisualEntity.Assign(Source: TPersistent);
begin
  inherited;
  FReadOnly := (Source as TKisVisualEntity).ReadOnly;
end;

procedure TKisVisualEntity.DestroyEditor(Sender: TObject);
begin
  if Assigned(FOldDestroyHandler) and Assigned(FEditor) then
  begin
    FOldDestroyHandler(FEditor);
    FOldDestroyHandler := nil;
  end;
  FEditor := nil;
end;

function TKisVisualEntity.Edit: Boolean;
begin
  FEditor := CreateEditor;
  if Assigned(FEditor) then
  begin
    FEditor.FEntity := Self;
    SetControlState(FEditor, ReadOnly);
    FEditor.btnOK.Enabled := not ReadOnly;
    PrepareEditor(FEditor);
    LoadDataIntoEditor(FEditor);
    FEditor.OnCheckEntityData := Self.CheckEditor;
    Result := FEditor.ShowModal = mrOK;
    if Result and not ReadOnly then
    begin
      ReadDataFromEditor(FEditor);
    end;
    UnprepareEditor(FEditor);
  end
  else
    Result := False;
end;

function TKisVisualEntity.GetCaption: String;
begin
  Result := Self.EntityName;
  if Self.ReadOnly then
    Result := Result + ' - только для чтения';
end;

procedure TKisVisualEntity.PrepareEditor(AEditor: TKisEntityEditor);
begin
  AEditor.Caption := GetCaption;
end;

procedure TKisVisualEntity.SetEditor(const Value: TKisEntityEditor);
begin
  FEditor := Value;
  if Assigned(FEditor) then
  begin
    if Assigned(FEditor.OnDestroy) then
      FOldDestroyHandler := FEditor.OnDestroy;
    FEditor.OnDestroy := DestroyEditor;
  end
  else
    FOldDestroyHandler := nil;
end;

procedure TKisVisualEntity.UnprepareEditor(AEditor: TKisEntityEditor);
begin
  AEditor.Free;
end;

end.


