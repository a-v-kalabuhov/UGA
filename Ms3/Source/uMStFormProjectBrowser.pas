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
  uMStKernelClasses, uMStModuleApp, uMStConsts, uMStKernelSemantic, uMStKernelIBX,
  uMStModuleMapMngrIBX,
  uMStClassesProjects, uMStClassesProjectsBrowser,
  uMStDialogProjectsBrowserFilter, ActnList, IBUpdateSQL, Menus, IBSQL;

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
    btnProperties: TSpeedButton;
    IBUpdateSQL1: TIBUpdateSQL;
    sbtnDeleteProject: TSpeedButton;
    PopupMenuDelete: TPopupMenu;
    N1: TMenuItem;
    N2: TMenuItem;
    IBSQL1: TIBSQL;
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
    procedure btnPropertiesClick(Sender: TObject);
    procedure sbtnDeleteProjectClick(Sender: TObject);
    procedure N1Click(Sender: TObject);
    procedure N2Click(Sender: TObject);
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
    function IntLocate(const PrjId, LineId: Integer; const DisableUI: Boolean): Boolean;
    procedure DeleteProject();
  public
    procedure Browse();
    function Locate(const PrjId, LineId: Integer): Boolean;
    procedure RefreshData(PrjId: Integer = -1; LineId: Integer = -1);
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
    '    LICENSED_ORGS ORGS2 ON (PRJS.CUSTOMER_ORGS_ID = ORGS2.ID) ';

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

procedure TMStProjectBrowserForm.DeleteProject;
var
  S1: string;
  Answer, I, PrjId, Id2: Integer;
  WasLoaded: Boolean;
begin
  S1 := 'ѕроект будет удалЄн без возможности восстановлени€.' + sLineBreak +
        'јдрес проекта: ' + IBQuery1.FieldByName(SF_ADDRESS).AsString + sLineBreak + sLineBreak +
        '”далить проект?';
  Answer := MessageBox(Self.Handle, PChar(S1), '¬нимание!', MB_YESNO + MB_ICONQUESTION);
  if Answer = mrYes then
  begin
    IBQuery1.DisableControls;
    try
      I := IBQuery1.RecNo;
      PrjId := IBQuery1.FieldByName(SF_PROJECT_ID).AsInteger;
      WasLoaded := mstClientAppModule.IsProjectLoaded(PrjId);
      if WasLoaded then
      begin
        TProjectUtils.RemoveProjectFromLayer(PrjId);
        mstClientAppModule.RemoveLoadedProject(PrjId);
        DrawBox.RegenDrawing;
      end;
      //
      IBQuery1.First;
      while not IBQuery1.Eof do
      begin
        try
          Id2 := IBQuery1.FieldByName(SF_PROJECT_ID).AsInteger;
          if Id2 = PrjId then
            IBQuery1.Delete
          else
            IBQuery1.Next;
        finally
        end;
      end;
      IBQuery1.FetchAll;
      if IBQuery1.RecordCount < I then
        IBQuery1.Last
      else
        IBQuery1.RecNo := I;
    finally
      IBQuery1.EnableControls;
    end;
  end;
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

function TMStProjectBrowserForm.IntLocate(const PrjId, LineId: Integer; const DisableUI: Boolean): Boolean;
var
  I: Integer;
begin
  Result := IBQuery1.Active;
  if Result then
  begin
    if DisableUI then
      IBQuery1.DisableControls;
    try
      I := IBQuery1.RecNo;
      IBQuery1.First;
      while not IBQuery1.Eof do
      begin
        if (IBQuery1.FieldByName(SF_PROJECT_ID).AsInteger = PrjId) then
        if (LineId < 0)
           or
           (IBQuery1.FieldByName(SF_LINE_ID).AsInteger = LineId)
        then
        begin
          Result := True;
          Exit;
        end;
        IBQuery1.Next;
      end;
      IBQuery1.RecNo := I;
    finally
      if DisableUI then
        IBQuery1.EnableControls;
    end;
    Result := False;
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
begin
  Result := IntLocate(PrjId, LineId, True);
end;

procedure TMStProjectBrowserForm.N1Click(Sender: TObject);
begin
  DeleteProject();
end;

procedure TMStProjectBrowserForm.N2Click(Sender: TObject);
var
  S1: string;
  Answer, I, PrjId, Id2, LineId: Integer;
  WasLoaded: Boolean;
  Prj: TmstProject;
begin
//  S1 := 'ѕроект будет удалЄн без возможности восстановлени€.' + sLineBreak +
//        'јдрес проекта: ' + IBQuery1.FieldByName(SF_ADDRESS).AsString + sLineBreak + sLineBreak +
//        '”далить проект?';
//  Answer := MessageBox(Self.Handle, PChar(S1), '¬нимание!', MB_YESNO + MB_ICONQUESTION);
//  if Answer = mrYes then
  if IBQuery1.Active then
  begin
    I := IBQuery1.RecNo;
    PrjId := IBQuery1.FieldByName(SF_PROJECT_ID).AsInteger;
    LineId := IBQuery1.FieldByName(SF_LINE_ID).AsInteger;
    Prj := mstClientAppModule.GetProject(PrjId, True);
    if Prj = nil then
      Exit;
    if Prj.Lines.Count = 1 then
    begin
      DeleteProject();
      Exit;
    end;
    // удал€ем линию из проекта
    IBQuery1.Delete;
    Prj.Lines.DeleteLine(LineId);
    Prj.Places.DeletePlace(LineId);
    WasLoaded := mstClientAppModule.IsProjectLoaded(PrjId);
    if WasLoaded then
    begin
      TProjectUtils.RemoveProjectLineFromLayer(PrjId, LineId);
      DrawBox.RegenDrawing;
    end;
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
  Result := Result + ' ORDER BY PRJS.ADDRESS, PRJS.ID, LINES.ID';
end;

procedure TMStProjectBrowserForm.RefreshData;
var
  SelPrjId, SelLineId: Integer;
  B: Boolean;
begin
  // если запрос открыт, то запоминаем ID
  if IBQuery1.Active then
  begin
    SelPrjId := IBQuery1.FieldByName(SF_PROJECT_ID).AsInteger;
    SelLineId := IBQuery1.FieldByName(SF_LINE_ID).AsInteger;
  end
  else
  begin
    SelPrjId := -1;
    SelLineId := -1;
  end;
  //
  IBQuery1.DisableControls;
  try
    ApplyFilter();
    B := (PrjId > 0);
    if B then
    begin
      B := IntLocate(PrjId, LineId, False);
    end;
    if not B then
      IntLocate(SelPrjId, SelLineId, False);
  finally
    IBQuery1.EnableControls;
  end;
end;

procedure TMStProjectBrowserForm.ReleaseDataSet;
begin
  IBQuery1.Active := False;
  if IBTransaction1.Active then
    IBTransaction1.Commit;
end;

procedure TMStProjectBrowserForm.sbtnDeleteProjectClick(Sender: TObject);
var
  Pt: TPoint;
begin
  if not IBQuery1.Active then
    Exit;
    Pt.X := 0;
    Pt.Y := sbtnDeleteProject.Height;
  Pt := sbtnDeleteProject.ClientToScreen(Pt);
  PopupMenuDelete.Popup(Pt.X, Pt.Y);
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
        // текуща€ лини€
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
  // если ID запомнено, то пытаемс€ найти ID
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
        // составл€ем список координат
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
          Coords.Add('ќхранна€ зона ' + FormatFloat('#0.00', Line.ZoneWidth) + 'м');
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

procedure TMStProjectBrowserForm.btnPropertiesClick(Sender: TObject);
var
  PrjId: Integer;
  Prj: TmstProject;
begin
  if not IBQuery1.Active then
    Exit;
  PrjId := IBQuery1.FieldByName(SF_PROJECT_ID).AsInteger;
  Prj := GetProjectAndLoadToGIS(PrjId);
  if not Assigned(Prj) then
  begin
    ShowMessage(
      'Ќе удалось загрузить проект!' + sLineBreak +
      'ќбратитесь к администратору.');
  end
  else
  begin
    if Prj.Edit(True) then
    begin
      Prj.Save(mstClientAppModule.MapMngr as IDb);
      IBQuery1.Refresh;
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
      // текуща€ лини€
      LineId := IBQuery1.FieldByName(SF_LINE_ID).AsInteger;
      Line := Prj.Lines.ByDbId(LineId);
      if Assigned(Line) then
      begin
        W := 2;
        // слой текущей линии
        // дл€ сло€ определ€ем ширину зоны по умолчанию
        if Assigned(Line.Layer) and Assigned(Line.Layer.NetType) then
        begin
          W := Line.Layer.NetType.ZoneWidth;
        end;
        // если есть уже построенна€ зона, то берЄм еЄ ширину
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
