unit uMStModuleDefaultActions;

interface

uses
  SysUtils, Classes, ImgList, Controls, ActnList,
  //
  EzCmdLine, EzBasicCtrls, EzBaseGIS, EzActions;

type
  TmstDefaultActionsModule = class(TDataModule)
    ZoomActionList: TActionList;
    acZoomIn: TAction;
    acZoomOut: TAction;
    acZoomRect: TAction;
    acZoomScroll: TAction;
    acZoomAll: TAction;
    acZoomPrev: TAction;
    acZoomSelect: TAction;
    acZoomClearAction: TAction;
    ZoomImageList: TImageList;
    procedure acZoomInExecute(Sender: TObject);
    procedure acZoomPrevExecute(Sender: TObject);
    procedure acZoomOutExecute(Sender: TObject);
    procedure acZoomRectExecute(Sender: TObject);
    procedure acZoomSelectExecute(Sender: TObject);
    procedure acZoomAllExecute(Sender: TObject);
    procedure acZoomClearActionExecute(Sender: TObject);
    procedure acZoomInUpdate(Sender: TObject);
    procedure acZoomOutUpdate(Sender: TObject);
    procedure acZoomRectUpdate(Sender: TObject);
    procedure acZoomScrollExecute(Sender: TObject);
    procedure acZoomScrollUpdate(Sender: TObject);
  private
    FCmdLine: TEzCmdLine;
    FGIS: TEzBaseGIS;
    procedure SetCmdLine(const Value: TEzCmdLine);
    procedure SetGIS(const Value: TEzBaseGIS);
    { Private declarations }
  public
    property CmdLine: TEzCmdLine read FCmdLine write SetCmdLine;
    property GIS: TEzBaseGIS read FGIS write SetGIS;
  end;

var
  mstDefaultActionsModule: TmstDefaultActionsModule;

implementation

{$R *.dfm}

{ TDataModule1 }

procedure TmstDefaultActionsModule.acZoomAllExecute(Sender: TObject);
var
  Xmin, Ymin, Xmax, Ymax: Double;
begin
  GIS.MaxMinExtents(Xmin, Ymin, Xmax, Ymax);
  CmdLine.ActiveDrawBox.SetViewTo(Xmin, Ymin, Xmax, Ymax);
end;

procedure TmstDefaultActionsModule.acZoomClearActionExecute(Sender: TObject);
begin
  CmdLine.Clear;
end;

procedure TmstDefaultActionsModule.acZoomInExecute(Sender: TObject);
begin
  CmdLine.Clear;
  CmdLine.DoCommand('ZOOMIN', '');
end;

procedure TmstDefaultActionsModule.acZoomInUpdate(Sender: TObject);
begin
  acZoomIn.Checked := (CmdLine.CurrentAction is TZoomInOutAction)
                      and
                      (TZoomInOutAction(CmdLine.CurrentAction).ZoomAction = zaZoomIn);
end;

procedure TmstDefaultActionsModule.acZoomOutExecute(Sender: TObject);
begin
  CmdLine.Clear;
  CmdLine.DoCommand('ZOOMOUT', '');
end;

procedure TmstDefaultActionsModule.acZoomOutUpdate(Sender: TObject);
begin
  acZoomOut.Checked := (CmdLine.CurrentAction is TZoomInOutAction)
                      and
                      (TZoomInOutAction(CmdLine.CurrentAction).ZoomAction = zaZoomOut);
end;

procedure TmstDefaultActionsModule.acZoomPrevExecute(Sender: TObject);
begin
  CmdLine.ActiveDrawBox.ZoomPrevious;
end;

procedure TmstDefaultActionsModule.acZoomRectExecute(Sender: TObject);
begin
  CmdLine.Clear;
  CmdLine.DoCommand('ZOOMWIN', '');
end;

procedure TmstDefaultActionsModule.acZoomRectUpdate(Sender: TObject);
begin
  acZoomRect.Checked := CmdLine.CurrentAction is TZoomWindowAction;
end;

procedure TmstDefaultActionsModule.acZoomScrollExecute(Sender: TObject);
begin
  CmdLine.Clear;
  CmdLine.DoCommand('SCROLL', '');
end;

procedure TmstDefaultActionsModule.acZoomScrollUpdate(Sender: TObject);
begin
  acZoomScroll.Checked := CmdLine.CurrentAction is THandScrollAction;
end;

procedure TmstDefaultActionsModule.acZoomSelectExecute(Sender: TObject);
begin
  CmdLine.ActiveDrawBox.ZoomToSelection;
end;

procedure TmstDefaultActionsModule.SetCmdLine(const Value: TEzCmdLine);
begin
  FCmdLine := Value;
end;

procedure TmstDefaultActionsModule.SetGIS(const Value: TEzBaseGIS);
begin
  FGIS := Value;
end;

end.
