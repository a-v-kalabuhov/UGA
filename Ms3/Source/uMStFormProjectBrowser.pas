unit uMStFormProjectBrowser;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms, ComCtrls, Dialogs, ExtCtrls,
  Buttons, StdCtrls, Grids, DBGrids, DB, DBCtrls, ValEdit, IBCustomDataSet, IBQuery, IBDatabase, SHellApi,
  //
  EzBaseGIS, EzTable, 
  uDBGrid,
  //
  uFileUtils, uGC,
  //
  uMStKernelClasses, uMStModuleApp, uMStConsts, uMStKernelSemantic, uMStModuleMapMngrIBX,
  uMStClassesProjects, uMStClassesProjectsBrowser,
  uMStDialogProjectsBrowserFilter, ActnList;

type
  TMStProjectBrowserForm = class(TForm)
    Panel1: TPanel;
    DataSource1: TDataSource;
    btnClose: TSpeedButton;
    DBNavigator1: TDBNavigator;
    Panel3: TPanel;
    chbTransparency: TCheckBox;
    trackAlpha: TTrackBar;
    btnCoords: TSpeedButton;
    PageControl1: TPageControl;
    tabData: TTabSheet;
    Panel2: TPanel;
    kaDBGrid1: TkaDBGrid;
    IBQuery1: TIBQuery;
    IBTransaction1: TIBTransaction;
    btnFilterStart: TSpeedButton;
    btnFilterClear: TSpeedButton;
    btnLoadToLayer: TSpeedButton;
    btnLoadAll: TSpeedButton;
    btnZone: TSpeedButton;
    SpeedButton1: TSpeedButton;
    SpeedButton2: TSpeedButton;
    SpeedButton3: TSpeedButton;
    btnDisplay: TSpeedButton;
    ActionList1: TActionList;
    procedure chbTransparencyClick(Sender: TObject);
    procedure trackAlphaChange(Sender: TObject);
    procedure btnDisplayClick(Sender: TObject);
    procedure btnCloseClick(Sender: TObject);
    procedure btnFilterStartClick(Sender: TObject);
    procedure btnFilterClearClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure kaDBGrid1GetLogicalValue(Sender: TObject; Column: TColumn; var Value: Boolean);
    procedure kaDBGrid1CellColors(Sender: TObject; Field: TField; var Background, FontColor: TColor;
      State: TGridDrawState; var FontStyle: TFontStyles);
    procedure kaDBGrid1LogicalColumn(Sender: TObject; Column: TColumn; var Value: Boolean);
    procedure btnLoadToLayerClick(Sender: TObject);
    procedure btnLoadAllClick(Sender: TObject);
    procedure btnCoordsClick(Sender: TObject);
    procedure btnZoneClick(Sender: TObject);
    procedure SpeedButton2Click(Sender: TObject);
    procedure SpeedButton1Click(Sender: TObject);
    procedure SpeedButton3Click(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure IBQuery1AfterScroll(DataSet: TDataSet);
    procedure IBQuery1AfterClose(DataSet: TDataSet);
  private
    FDrawBox: TEzBaseDrawBox;
    FFilter: TmstProjectsBrowserFilter;
    FHighlightEnabled: Boolean;
    procedure SetDrawBox(const Value: TEzBaseDrawBox);
    procedure PrepareDataSet();
    procedure ReleaseDataSet();
    procedure ShowFilterDialog();
    procedure ApplyFilter();
    procedure ClearFilter();
    procedure DisplayLine(Prj: TmstProject; LineId: Integer);
    procedure DisplayPrj(Prj: TmstProject);
    function PrepareSql(): string;
    function GetProjectAndLoadToGIS(PrjId: Integer): TmstProject;
  public
    procedure Browse();
    function Locate(const PrjId, LineId: Integer): Boolean;
    //
    property DrawBox: TEzBaseDrawBox read FDrawBox write SetDrawBox;
  end;

var
  mstProjectBrowserForm: TMStProjectBrowserForm;

implementation

uses uMStDialogBufferZoneWidth;

const
  SQL_SELECT_PROJECT_LINES =
    'SELECT' +
    '       PRJS.ID AS PROJECT_ID, PRJS.ADDRESS, PRJS.DOC_NUMBER, PRJS.DOC_DATE, PRJS.CONFIRMED, PRJS.CONFIRM_DATE,' +
    '       LINES.ID AS LINE_ID, LINES.INFO, LINES.DIAMETER, LINES.VOLTAGE,' +
    '       LAYERS.ID AS LAYER_ID, LAYERS.NAME AS LAYER_NAME,' +
    '       ORGS2.NAME AS CUSTOMER, ORGS1.NAME AS EXECUTOR ' +
    'FROM' +
    '    PROJECT_LINES LINES' +
    '    LEFT JOIN' +
    '    PROJECT_LAYERS LAYERS ON (LINES.PROJECT_LAYERS_ID = LAYERS.ID)' +
    '    LEFT JOIN' +
    '    PROJECTS PRJS ON (LINES.PROJECTS_ID = PROJECTS.ID)' +
    '    LEFT JOIN' +
    '    LICENSED_ORGS ORGS1 ON (PRJS.EXECUTOR_ORGS_ID = ORGS1.ID)' +
    '    LEFT JOIN' +
    '    LICENSED_ORGS ORGS2 ON (PRJS.CUSTOMER_ORGS_ID = ORGS2.ID)';

{$R *.dfm}

{ TMStProjectBrowserForm }

procedure TMStProjectBrowserForm.chbTransparencyClick(Sender: TObject);
begin
  Self.AlphaBlend := chbTransparency.Checked;
  trackAlpha.Visible := chbTransparency.Checked;
end;

procedure TMStProjectBrowserForm.ClearFilter;
begin
  FFilter.Clear();
end;

procedure TMStProjectBrowserForm.DisplayLine;
var
  aLayer: TEzBaseLayer;
  aRecNo: Integer;
begin
  TProjectUtils.ShowProjectLayer(Prj);
  TProjectUtils.FindProjectInGIS(Prj, LineId, aLayer, aRecNo);
  if Assigned(aLayer) then
  begin
    aLayer.Recno := aRecNo;
    FDrawBox.SetEntityInViewEx(aLayer.Name, aRecno, True);
    FDrawBox.BlinkEntityEx(aLayer.Name, aRecno);
  end;
end;

procedure TMStProjectBrowserForm.DisplayPrj(Prj: TmstProject);
begin
  DrawBox.ZoomWindow(TProjectUtils.Window(Prj));
end;

procedure TMStProjectBrowserForm.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  TProjectsSettings.SetCurrentProjectLine(-1, -1);
  mstClientAppModule.WriteFormPosition(Application, Self);
  mstClientAppModule.WriteGridProperties(Self, kaDBGrid1);
end;

procedure TMStProjectBrowserForm.FormCreate(Sender: TObject);
begin
  FFilter := TmstProjectsBrowserFilter.Create;
  FHighlightEnabled := True;
  mstClientAppModule.ReadFormPosition(Application, Self);
  mstClientAppModule.ReadGridProperties(Self, kaDBGrid1);
end;

procedure TMStProjectBrowserForm.FormDestroy(Sender: TObject);
begin
  FFilter.Free;
end;

function TMStProjectBrowserForm.GetProjectAndLoadToGIS(PrjId: Integer): TmstProject;
var
  Loaded: Boolean;
begin
  Loaded := mstClientAppModule.IsProjectLoaded(PrjId);
  Result := mstClientAppModule.GetProject(PrjId, True);
  if Assigned(Result) and not Loaded then
  begin
    TProjectUtils.AddProjectToGIS(Result);
    mstClientAppModule.AddLoadedProject(PrjId);
  end;
end;

procedure TMStProjectBrowserForm.IBQuery1AfterClose(DataSet: TDataSet);
begin
  TProjectsSettings.SetCurrentProjectLine(-1, -1);
end;

procedure TMStProjectBrowserForm.IBQuery1AfterScroll(DataSet: TDataSet);
var
  OldPrjId, PrjId: Integer;
  LineId: Integer;
  OldLoaded, NewLoaded: Boolean;
begin
  if FHighlightEnabled then
  begin
    PrjId := IBQuery1.FieldByName(SF_PROJECT_ID).AsInteger;
    LineId := IBQuery1.FieldByName(SF_LINE_ID).AsInteger;
    OldPrjId := TProjectsSettings.FProjectId;
    TProjectsSettings.SetCurrentProjectLine(PrjId, LineId);
    OldLoaded := mstClientAppModule.IsProjectLoaded(OldPrjId);
    NewLoaded := mstClientAppModule.IsProjectLoaded(PrjId);
    if OldLoaded or NewLoaded then
      FDrawBox.RegenDrawing;
  end;
end;

procedure TMStProjectBrowserForm.kaDBGrid1CellColors(Sender: TObject; Field: TField; var Background, FontColor: TColor;
  State: TGridDrawState; var FontStyle: TFontStyles);
var
  PrjId: Integer;
  Loaded: Boolean;
begin
  PrjId := IBQuery1.FieldByName(SF_PROJECT_ID).AsInteger;
  Loaded := mstClientAppModule.IsProjectLoaded(PrjId);
  if Loaded then
  begin
    FontColor := clGreen;
    if State = [] then
      Background := clYellow;
  end;
end;

procedure TMStProjectBrowserForm.kaDBGrid1GetLogicalValue(Sender: TObject; Column: TColumn; var Value: Boolean);
begin
  if Column.FieldName = SF_CONFIRMED then
    Value := IBQuery1.FieldByName(SF_CONFIRMED).AsInteger = 1;
end;

procedure TMStProjectBrowserForm.kaDBGrid1LogicalColumn(Sender: TObject; Column: TColumn; var Value: Boolean);
begin
  Value := Column.FieldName = SF_CONFIRMED;
end;

function TMStProjectBrowserForm.Locate(const PrjId, LineId: Integer): Boolean;
var
  I: Integer;
begin
  Result := IBQuery1.Active;
  if Result then
  begin
    IBQuery1.DisableControls;
    try
      I := IBQuery1.RecNo;
      IBQuery1.First;
      while not IBQuery1.Eof do
      begin
        if IBQuery1.FieldByName(SF_PROJECT_ID).AsInteger = PrjId then
        if IBQuery1.FieldByName(SF_LINE_ID).AsInteger = LineId then
        begin
          Result := True;
          Exit;
        end;
        IBQuery1.Next;
      end;
      IBQuery1.RecNo := I;
    finally
      IBQuery1.EnableControls;
    end;
    Result := False;
  end;
end;

procedure TMStProjectBrowserForm.PrepareDataSet;
begin
  if not IBTransaction1.Active then
    IBTransaction1.StartTransaction;
  ApplyFilter();
end;

function TMStProjectBrowserForm.PrepareSql: string;
var
  Where: string;
  Added: Boolean;
begin
  Result := SQL_SELECT_PROJECT_LINES;
  if not FFilter.IsEmpty then
  begin
    Where := ' WHERE ';
    Added := False;
    if FFilter.Address <> '' then
    begin
      Where := Where + '(UPPER(PRJS.ADDRESS) LIKE ''%' + AnsiUpperCase(FFilter.Address) + '%'') ';
      Added := True;
    end;
    if FFilter.Diameter <> '' then
    begin
      if Added then
        Where := Where + ' AND ';
      Where := Where + '(UPPER(LINES.DIAMETER) LIKE ''%' + AnsiUpperCase(FFilter.Diameter) + '%'') ';
      Added := True;
    end;
    if FFilter.Voltage <> '' then
    begin
      if Added then
        Where := Where + ' AND ';
      Where := Where + '(UPPER(LINES.VOLTAGE) LIKE ''%' + AnsiUpperCase(FFilter.Voltage) + '%'') ';
      Added := True;
    end;
    if FFilter.Customer <> '' then
    begin
      if Added then
        Where := Where + ' AND ';
      Where := Where + '(UPPER(ORGS2.NAME) LIKE ''%' + AnsiUpperCase(FFilter.Customer) + '%'') ';
      Added := True;
    end;
    if FFilter.Executor <> '' then
    begin
      if Added then
        Where := Where + ' AND ';
      Where := Where + '(UPPER(ORGS1.NAME) LIKE ''%' + AnsiUpperCase(FFilter.Executor) + '%'') ';
      Added := True;
    end;
    if FFilter.Info <> '' then
    begin
      if Added then
        Where := Where + ' AND ';
      Where := Where + '(UPPER(LINES.INFO) LIKE ''%' + AnsiUpperCase(FFilter.Info) + '%'') ';
      Added := True;
    end;
    if FFilter.UseConfirmed then
    begin
      if Added then
        Where := Where + ' AND ';
      Where := Where + '(PRJS.CONFIRMED=';
      if FFilter.Confirmed then
        Where := Where + '1'
      else
        Where := Where + '0';
      Where := Where + ') ';
      if FFilter.Confirmed then
      begin
        Where := Where + ' AND (PRJS.CONFIRM_DATE BETWEEN ' +
                  #39 + FormatDateTime(S_DATESTR_FORMAT, FFilter.ConfirmDateStart) + #39 +
                  ' AND ' +
                  #39  + FormatDateTime(S_DATESTR_FORMAT, FFilter.ConfirmDateEnd) + #39 + ') ';
      end;
    end;
    //
    Where := Where + ' AND (PRJS.DOC_DATE BETWEEN ' +
              #39 + FormatDateTime(S_DATESTR_FORMAT, FFilter.DocDateStart) + #39 +
              ' AND ' +
              #39  + FormatDateTime(S_DATESTR_FORMAT, FFilter.DocDateEnd) + #39 + ') ';
    Result := Result + Where;
  end;
end;

procedure TMStProjectBrowserForm.ReleaseDataSet;
begin
  IBQuery1.Active := False;
  if IBTransaction1.Active then
    IBTransaction1.Commit;
end;

procedure TMStProjectBrowserForm.SetDrawBox(const Value: TEzBaseDrawBox);
begin
  FDrawBox := Value;
end;

procedure TMStProjectBrowserForm.ShowFilterDialog;
var
  Pt: TPoint;
begin
  if mstProjectBrowserFilterDialog = nil then
  begin
    mstProjectBrowserFilterDialog := TmstProjectBrowserFilterDialog.Create(Self);
    Pt.X := 0;
    Pt.Y := btnFilterClear.Height + 1;
    Pt := btnFilterClear.ClientToScreen(Pt);
    mstProjectBrowserFilterDialog.Left := Pt.X;
    mstProjectBrowserFilterDialog.Top := Pt.Y;
  end;
  if mstProjectBrowserFilterDialog.Execute(FFilter) then
  begin
    ApplyFilter();
  end;
end;

procedure TMStProjectBrowserForm.SpeedButton1Click(Sender: TObject);
var
  PrjId: Integer;
begin
  if IBQuery1.Active then
  begin
    PrjId := IBQuery1.FieldByName(SF_PROJECT_ID).AsInteger;
    if mstClientAppModule.IsProjectLoaded(PrjId) then
    begin
      TProjectUtils.RemoveProjectFromLayer(PrjId);
      mstClientAppModule.RemoveLoadedProject(PrjId);
      DrawBox.RegenDrawing;
      kaDbGrid1.Refresh;
    end;
  end;
end;

procedure TMStProjectBrowserForm.SpeedButton2Click(Sender: TObject);
begin
  TProjectUtils.ClearProjectLayers();
  mstClientAppModule.ClearLoadedProjects();
  DrawBox.RegenDrawing;
  kaDbGrid1.Refresh;
end;

procedure TMStProjectBrowserForm.SpeedButton3Click(Sender: TObject);
var
  PrjId, LineId: Integer;
  Prj: TmstProject;
  Line: TmstProjectLine;
begin
  if IBQuery1.Active then
  begin
    // текущий проект
    PrjId := IBQuery1.FieldByName(SF_PROJECT_ID).AsInteger;
    if mstClientAppModule.IsProjectLoaded(PrjId) then
    begin
      Prj := mstClientAppModule.GetProject(PrjId, False);
      if Assigned(Prj) then
      begin
        // текущая линия
        LineId := IBQuery1.FieldByName(SF_LINE_ID).AsInteger;
        Line := Prj.Lines.ByDbId(LineId);
        if Assigned(Line) then
        begin
          TProjectUtils.RemoveLineZone(Line);
          DrawBox.RegenDrawing;
        end;
      end;
    end;
  end;
end;

procedure TMStProjectBrowserForm.btnFilterClearClick(Sender: TObject);
begin
  ClearFilter();
  ApplyFilter();
end;

procedure TMStProjectBrowserForm.ApplyFilter;
var
  Sql: string;
  Id: Integer;
begin
  // формируем текст запроса
  Sql := PrepareSql();
  // если запрос открыт, то запоминаем ID
  if IBQuery1.Active then
    Id := IBQuery1.FieldByName(SF_PROJECT_ID).AsInteger
  else
    Id := -1;
  // закрываем запрос
  IBQuery1.Active := False;
  // назначаем текст
  IBQuery1.SQL.Text := Sql;
  // открываем запрос
  IBQuery1.Active := True;
  // если ID запомнено, то пытаемся найти ID
  if Id >= 0 then
    IBQuery1.Locate(SF_PROJECT_ID, Id, []);
end;

procedure TMStProjectBrowserForm.Browse;
begin
  if not Visible then
  begin
    PrepareDataSet();
    Show;
  end;
end;

procedure TMStProjectBrowserForm.btnCloseClick(Sender: TObject);
begin
  ReleaseDataSet();
  Close;
end;

procedure TMStProjectBrowserForm.btnCoordsClick(Sender: TObject);
var
  PrjId, LineId: Integer;
  Prj: TmstProject;
  Line: TmstProjectLine;
  Coords: TStringList;
  I: Integer;
  TmpFile: string;
  CoordsFile: string;
begin
  // получаем текущую линию
    PrjId := IBQuery1.FieldByName(SF_PROJECT_ID).AsInteger;
    Prj := mstClientAppModule.GetProject(PrjId, True);
    if Assigned(Prj) then
    begin
      LineId := IBQuery1.FieldByName(SF_LINE_ID).AsInteger;
      Line := Prj.Lines.ByDbId(LineId);
      if Assigned(Line) then
      begin
        // составляем список координат
        Coords := TStringList.Create;
        Coords.Forget;
        for I := 0 to Line.Points.Count - 1 do
        begin
          Coords.Add(IntToStr(Succ(I)) + ';' +
                     FormatFloat('#0.00', Line.Points[I].X) + ';' +
                     FormatFloat('#0.00', Line.Points[I].Y));
        end;
        if Assigned(Line.ZoneLine) then
        begin
          Coords.Add('');
          Coords.Add('Охранная зона ' + FormatFloat('#0.00', Line.ZoneWidth) + 'м');
          for I := 0 to Line.ZoneLine.Points.Count - 1 do
          begin
            Coords.Add(IntToStr(Succ(I)) + ';' +
                       FormatFloat('#0.00', Line.ZoneLine.Points[I].X) + ';' +
                       FormatFloat('#0.00', Line.ZoneLine.Points[I].Y));
          end;
        end;
        // пишем его в файл
        TmpFile := TFileUtils.CreateTempFile(mstClientAppModule.SessionDir);
        CoordsFile := ChangeFileExt(TmpFile, '.txt');
        TFileUtils.RenameFile(TmpFile, CoordsFile);
        Coords.SaveToFile(CoordsFile);
        // открываем файл
        ShellExecute(Handle, 'open', PChar(CoordsFile), nil, nil, SW_SHOWNORMAL);
      end;
    end;
end;

procedure TMStProjectBrowserForm.btnDisplayClick(Sender: TObject);
var
  PrjId, LineId: Integer;
  Prj: TmstProject;
begin
  if IBQuery1.Active then
  begin
    PrjId := IBQuery1.FieldByName(SF_PROJECT_ID).AsInteger;
    Prj := GetProjectAndLoadToGIS(PrjId);
    if Assigned(Prj) then
    begin
      LineId := IBQuery1.FieldByName(SF_LINE_ID).AsInteger;
      DisplayLine(Prj, LineId);
      kaDBGrid1.Refresh;
    end;
  end;
end;

procedure TMStProjectBrowserForm.btnFilterStartClick(Sender: TObject);
begin
  ShowFilterDialog();
end;

procedure TMStProjectBrowserForm.btnLoadAllClick(Sender: TObject);
var
  PrjId: Integer;
  L: TEzBaseLayer;
begin
  if IBQuery1.Active then
  begin
    FHighlightEnabled := False;
    try
      IBQuery1.First;
      while not IBQuery1.Eof do
      begin
        PrjId := IBQuery1.FieldByName(SF_PROJECT_ID).AsInteger;
        GetProjectAndLoadToGIS(PrjId);
        IBQuery1.Next;
      end;
      kaDBGrid1.Refresh;
      //
      L := DrawBox.GIS.Layers.LayerByName(SL_PROJECT_OPEN);
      if Assigned(L) then
        L.LayerInfo.Visible := True;
      L := DrawBox.GIS.Layers.LayerByName(SL_PROJECT_CLOSED);
      if Assigned(L) then
        L.LayerInfo.Visible := True;
    finally
      FHighlightEnabled := True;
    end;
    DrawBox.RegenDrawing;
  end;
end;

procedure TMStProjectBrowserForm.btnLoadToLayerClick(Sender: TObject);
var
  PrjId: Integer;
  Prj: TmstProject;
begin
  if IBQuery1.Active then
  begin
    PrjId := IBQuery1.FieldByName(SF_PROJECT_ID).AsInteger;
    Prj := GetProjectAndLoadToGIS(PrjId);
    if Assigned(Prj) then
    begin
      TProjectUtils.ShowProjectLayer(Prj);
      DisplayPrj(Prj);
      kaDBGrid1.Refresh;
    end;
  end;
end;

procedure TMStProjectBrowserForm.btnZoneClick(Sender: TObject);
var
  PrjId, LineId: Integer;
  Prj: TmstProject;
  Line: TmstProjectLine;
  W: Double;
begin
  if IBQuery1.Active then
  begin
    // текущий проект
    PrjId := IBQuery1.FieldByName(SF_PROJECT_ID).AsInteger;
    Prj := GetProjectAndLoadToGIS(PrjId);
    if Assigned(Prj) then
    begin
      // текущая линия
      LineId := IBQuery1.FieldByName(SF_LINE_ID).AsInteger;
      Line := Prj.Lines.ByDbId(LineId);
      if Assigned(Line) then
      begin
        W := 2;
        // слой текущей линии
        // для слоя определяем ширину зоны по умолчанию
        if Assigned(Line.Layer) and Assigned(Line.Layer.NetType) then
        begin
          W := Line.Layer.NetType.ZoneWidth;
        end;
        // если есть уже построенная зона, то берём её ширину
        if Assigned(Line.ZoneLine) then
        begin
          W := Line.ZoneWidth;
        end;
        // открываем диалог с параметрами зоны
        if not Assigned(mstZoneWidthDialog) then
          mstZoneWidthDialog := TmstZoneWidthDialog.Create(Application);
        if mstZoneWidthDialog.Execute(W) then
        begin
          if TProjectUtils.AddLineZoneToGIS(Line, W) then
          begin
            TProjectUtils.ShowProjectLayer(Prj);
            DrawBox.SetEntityInView(Line.Zone, True);
            DrawBox.BlinkEntity(Line.Zone);
          end;
        end;
      end;
    end;
  end;
end;

procedure TMStProjectBrowserForm.trackAlphaChange(Sender: TObject);
begin
  Self.AlphaBlendValue := trackAlpha.Position;
end;

end.
