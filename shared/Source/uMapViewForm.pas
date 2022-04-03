{*******************************************************}
{                                                       }
{       "Нужные окна" v 1.1                             }
{       MapView Form Unit                               }
{                                                       }
{       Copyright (c) 2003, Калабухов А.В.              }
{                                                       }
{       Автор: Калабухов А.В.                           }
{                                                       }
{*******************************************************}

{ Описание:
  Имя модуля: MapView Form
  Версия: 1.0
  Дата последнего изменения: 16.08.2003
  Цель: содержит класс окна c базовыми возможностями просмотра карты.
  Используется:
  Использует:   Application Form
  Исключения:   
  Вывод в БД:
  Вывод:
  До вызова:
  После вызова:   }
  
unit uMapViewForm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  uAppForm, Menus, ImgList, ActnList, EzBaseGIS, EzBasicCtrls,
  EzCmdLine, ComCtrls, ToolWin, ExtCtrls;

type
  TkaMapViewForm = class(TkaAppForm)
    CmdLine: TEzCmdLine;
    MapView: TEzDrawBox;
    MapActionList: TActionList;
    acZoomIn: TAction;
    acZoomOut: TAction;
    acZoomRect: TAction;
    acZoomAll: TAction;
    acZoomPrev: TAction;
    acAerialView: TAction;
    acDefaultMode: TAction;
    acScrollMode: TAction;
    acClose: TAction;
    MapPopupMenu: TPopupMenu;
    ButtonsImageList: TImageList;
    MainMenu1: TMainMenu;
    N1: TMenuItem;
    N2: TMenuItem;
    acZoomIn1: TMenuItem;
    acZoomOut1: TMenuItem;
    acZoomPrev1: TMenuItem;
    acZoomAll1: TMenuItem;
    acZoomPrev2: TMenuItem;
    acAerialView1: TMenuItem;
    N3: TMenuItem;
    acDefaultMode1: TMenuItem;
    acScrollMode1: TMenuItem;
    ControlBar2: TControlBar;
    ModeToolBar: TToolBar;
    ToolButton7: TToolButton;
    ToolButton8: TToolButton;
    ZoomToolBar: TToolBar;
    ToolButton1: TToolButton;
    ToolButton2: TToolButton;
    ToolButton3: TToolButton;
    ToolButton4: TToolButton;
    ToolButton5: TToolButton;
    ToolButton6: TToolButton;
    procedure acAerialViewExecute(Sender: TObject);
    procedure acCloseExecute(Sender: TObject);
    procedure acDefaultModeExecute(Sender: TObject);
    procedure acScrollModeExecute(Sender: TObject);
    procedure acZoomAllExecute(Sender: TObject);
    procedure acZoomInExecute(Sender: TObject);
    procedure acZoomOutExecute(Sender: TObject);
    procedure acZoomPrevExecute(Sender: TObject);
    procedure acZoomRectExecute(Sender: TObject);
  private
    FAerialView: TkaAerialViewForm;
  public
    { Public declarations }
  end;

implementation

{$R *.dfm}

procedure TkaMapViewForm.acZoomInExecute(Sender: TObject);
begin
  CmdLine.Clear;
  CmdLine.DoCommand('ZOOMIN', '');
end;

procedure TkaMapViewForm.acZoomOutExecute(Sender: TObject);
begin
  CmdLine.Clear;
  CmdLine.DoCommand('ZOOMOUT', '');
end;

procedure TkaMapViewForm.acZoomRectExecute(Sender: TObject);
begin
  CmdLine.Clear;
  CmdLine.DoCommand('ZOOMWIN', '');
end;

procedure TkaMapViewForm.acZoomAllExecute(Sender: TObject);
begin
  MapView.ZoomToExtension;
end;

procedure TkaMapViewForm.acZoomPrevExecute(Sender: TObject);
begin
  MapView.ZoomPrevious;
end;

procedure TkaMapViewForm.acScrollModeExecute(Sender: TObject);
begin
  CmdLine.Clear;
  CmdLine.DoCommand('SCROLL', '');
end;

procedure TkaMapViewForm.acDefaultModeExecute(Sender: TObject);
begin
  CmdLine.Clear;
end;

procedure TkaMapViewForm.acCloseExecute(Sender: TObject);
begin
  Close;
end;

procedure TkaMapViewForm.acAerialViewExecute(Sender: TObject);
begin
  if FAerialView = nil then
  begin
    uAerialViewForm.ParentHWND := Self.handle;
    FAerialView := TkaAerialViewForm.Create(nil);
    FAerialView.View.ParentView := Self.MapView;
  end;
  if FAerialView.Visible then
    FAerialView.Hide
  else
    FAerialView.Show;
end;

end.
