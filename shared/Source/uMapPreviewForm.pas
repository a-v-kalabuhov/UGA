unit uMapPreviewForm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  EzBaseGIS, EzPreview, uAppForm, EzCtrls, ImgList, ActnList,
  ToolWin, ComCtrls, Menus, EzCmdLine, ExtCtrls;

type
  TkaActionEnabledEvent = procedure(ActionID: Integer; var Enabled: Boolean)
    of object;
  TkaActionExecuteEvent = procedure(ActionID: Integer; var NeedUpdate: Boolean)
    of object;

  TkaMapPreviewForm = class(TkaAppForm)
    PreviewBox: TEzPreviewBox;
    ActionList: TActionList;
    ToolBar: TToolBar;
    MainMenu: TMainMenu;
    CmdLine: TEzCmdLine;
    Panel1: TPanel;
    EzHRuler1: TEzHRuler;
    Panel2: TPanel;
    EzVRuler1: TEzVRuler;
  private
    FOnActionEnabled: TkaActionEnabledEvent;
    FOnActionExecute: TkaActionExecuteEvent;
    FOnUpdatePreview: TNotifyEvent;
    FMapScale: Double;
  protected
    function GetCustomActionsMenuItem: TMenuItem; virtual;
    procedure SetMapScale(const Value: Double); virtual;
    procedure DoActionEnabled(ActionID: Integer; var Enabled: Boolean);
    procedure DoActionExecute(ActionID: Integer; var NeedUpdate: Boolean);
    procedure DoUpdatePreview(Sender: TObject);
  public
    property CustomActionsMenuItem: TMenuItem read GetCustomActionsMenuItem;
    procedure DefaultActionExecute(Sender: TObject);
  published
    property MapScale: Double read FMapScale write SetMapScale;
    property OnActionEnabled: TkaActionEnabledEvent read FOnActionEnabled
      write FOnActionEnabled;
    property OnActionExecute: TkaActionExecuteEvent read FOnActionExecute
      write FOnActionExecute;
    property OnUpdatePreview: TNotifyEvent read FOnUpdatePreview
      write FOnUpdatePreview;
  end;

implementation

{$R *.dfm}

{ TkaMapPreviewForm }

procedure TkaMapPreviewForm.DefaultActionExecute(Sender: TObject);
var
  NeedUpdate: Boolean;
begin
  if Sender is TAction then
  with Sender as TAction do
  begin
    DoActionExecute(Tag, NeedUpdate);
    if NeedUpdate then
      DoUpdatePreview(Self);
  end;
end;

procedure TkaMapPreviewForm.DoActionEnabled(ActionID: Integer;
  var Enabled: Boolean);
begin
  if Assigned(FOnActionEnabled) then
    FOnActionEnabled(ActionID, Enabled)
  else
    Enabled := False;
end;

procedure TkaMapPreviewForm.DoActionExecute(ActionID: Integer;
  var NeedUpdate: Boolean);
begin
  if Assigned(FOnActionExecute) then
    FOnActionExecute(ActionID, NeedUpdate)
  else
    NeedUpdate := False;
end;

procedure TkaMapPreviewForm.DoUpdatePreview(Sender: TObject);
begin
  if Assigned(FOnUpdatePreview) then
    FOnUpdatePreview(Sender);
end;

function TkaMapPreviewForm.GetCustomActionsMenuItem: TMenuItem;
begin

end;

procedure TkaMapPreviewForm.SetMapScale(const Value: Double);
begin
  FMapScale := Value;
end;

end.
