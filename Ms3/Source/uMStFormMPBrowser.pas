unit uMStFormMPBrowser;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms, Dialogs,
  EzBaseGIS, IBSQL, Menus, IBCustomDataSet, IBUpdateSQL, ActnList, IBDatabase, DB, IBQuery, Grids, DBGrids, uDBGrid,
  ComCtrls, StdCtrls, DBCtrls, Buttons, ExtCtrls,
  //
  EzLib,
  //
  uMStClassesProjectsMP,
  uMStKernelClassesQueryIndex, uMStClassesProjectsUtils, uMStClassesProjectsBrowserMP,
  //
  uMStModuleApp;

type
  TmstMPBrowserForm = class(TForm)
    Panel1: TPanel;
    btnClose: TSpeedButton;
    btnLoadToLayer: TSpeedButton;
    btnLoadAll: TSpeedButton;
    SpeedButton1: TSpeedButton;
    SpeedButton2: TSpeedButton;
    DBNavigator1: TDBNavigator;
    Panel3: TPanel;
    btnCoords: TSpeedButton;
    btnZone: TSpeedButton;
    SpeedButton3: TSpeedButton;
    btnDisplay: TSpeedButton;
    chbTransparency: TCheckBox;
    trackAlpha: TTrackBar;
    PageControl1: TPageControl;
    tabData: TTabSheet;
    Panel2: TPanel;
    btnFilterStart: TSpeedButton;
    btnFilterClear: TSpeedButton;
    btnProperties: TSpeedButton;
    sbtnDeleteProject: TSpeedButton;
    kaDBGrid1: TkaDBGrid;
    DataSource1: TDataSource;
    ibqProjects: TIBQuery;
    IBTransaction1: TIBTransaction;
    ActionList1: TActionList;
    IBUpdateSQL1: TIBUpdateSQL;
    PopupMenuDelete: TPopupMenu;
    N1: TMenuItem;
    N2: TMenuItem;
    IBSQL1: TIBSQL;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure chbTransparencyClick(Sender: TObject);
    procedure trackAlphaChange(Sender: TObject);
    procedure btnDisplayClick(Sender: TObject);
    procedure btnFilterStartClick(Sender: TObject);
    procedure btnFilterClearClick(Sender: TObject);
    procedure btnCloseClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    FDrawBox: TEzBaseDrawBox;
    procedure PrepareDataSet();
    procedure ReleaseDataSet();
    procedure SetDrawBox(const Value: TEzBaseDrawBox);
  private
    FFilter: TmstProjectsBrowserFilterMP;
    FHighlightEnabled: Boolean;
    FRowIndex: TQueryRowIndex;
    procedure ApplyFilter();
    procedure ClearFilter();
    procedure DeleteProject();
    function PrepareSql(): string;
    procedure RebuildIndex();
    procedure ShowFilterDialog();
    function IntLocate(const PrjId, ObjId: Integer; const DisableUI: Boolean): Boolean;
    function GetProjectAndLoadToGIS(PrjId: Integer): TmstProjectMP;
    procedure DisplayObj(Prj: TmstProjectMP; ObjId: Integer);
  public
    procedure Browse();
    function Locate(const PrjId, ObjId: Integer): Boolean;
    //
    property DrawBox: TEzBaseDrawBox read FDrawBox write SetDrawBox;
  end;

var
  mstMPBrowserForm: TmstMPBrowserForm;

implementation

uses
  uMStConsts, uMStDialogMPBrowserFilter;

{$R *.dfm}

const
  SQL_SELECT_MP_OBJECTS =
    'SELECT ';

{ TmstMPBrowserForm }

procedure TmstMPBrowserForm.ApplyFilter;
var
  Sql: string;
  Id: Integer;
begin
  // формируем текст запроса
  Sql := PrepareSql();
  // если запрос открыт, то запоминаем ID
  if ibqProjects.Active then
    Id := ibqProjects.FieldByName(SF_PROJECT_ID).AsInteger
  else
    Id := -1;
  // закрываем запрос
  ibqProjects.Active := False;
  // назначаем текст
  ibqProjects.SQL.Text := Sql;
  // открываем запрос
  ibqProjects.Active := True;
  // если ID запомнено, то пытаемс€ найти ID
  ibqProjects.FetchAll;
  RebuildIndex();
  if Id >= 0 then
    Locate(Id, 0);
//    ibqProjects.Locate(SF_PROJECT_ID, Id, []);
end;

procedure TmstMPBrowserForm.Browse;
begin
  if not Visible then
  begin
    PrepareDataSet();
    Show;
  end;
end;

procedure TmstMPBrowserForm.btnCloseClick(Sender: TObject);
begin
  ReleaseDataSet();
  Close;
end;

procedure TmstMPBrowserForm.btnDisplayClick(Sender: TObject);
var
  PrjId, ObjId: Integer;
  Prj: TmstProjectMP;
begin
  if ibqProjects.Active then
  begin
    PrjId := ibqProjects.FieldByName(SF_PROJECT_ID).AsInteger;
    Prj := GetProjectAndLoadToGIS(PrjId);
    if Assigned(Prj) then
    begin
      ObjId := ibqProjects.FieldByName(SF_OBJ_ID).AsInteger;
      DisplayObj(Prj, ObjId);
      kaDBGrid1.Refresh;
    end;
  end;
end;

procedure TmstMPBrowserForm.btnFilterClearClick(Sender: TObject);
begin
  ClearFilter();
  ApplyFilter();
end;

procedure TmstMPBrowserForm.btnFilterStartClick(Sender: TObject);
begin
  ShowFilterDialog();
end;

procedure TmstMPBrowserForm.chbTransparencyClick(Sender: TObject);
begin
  Self.AlphaBlend := chbTransparency.Checked;
  trackAlpha.Visible := chbTransparency.Checked;
end;

procedure TmstMPBrowserForm.ClearFilter;
begin
  FFilter.Clear();
end;

procedure TmstMPBrowserForm.DeleteProject;
var
  S1: string;
  Answer, I, PrjId, Id2, RowNo: Integer;
  WasLoaded: Boolean;
  Rows: TIntegerList;
begin
  S1 := 'ѕроект будет удалЄн без возможности восстановлени€.' + sLineBreak +
        'Ќаименование: ' + ibqProjects.FieldByName(SF_NAME).AsString + sLineBreak + 
        'јдрес проекта: ' + ibqProjects.FieldByName(SF_ADDRESS).AsString + sLineBreak + sLineBreak +
        '”далить проект?';
  Answer := MessageBox(Self.Handle, PChar(S1), '¬нимание!', MB_YESNO + MB_ICONQUESTION);
  if Answer = mrYes then
  begin
    ibqProjects.DisableControls;
    try
      RowNo := ibqProjects.RecNo;
      PrjId := ibqProjects.FieldByName(SF_PROJECT_ID).AsInteger;
      WasLoaded := mstClientAppModule.IsProjectLoaded(PrjId, True);
      if WasLoaded then
      begin
        TProjectUtils.RemoveProjectFromLayer(PrjId, True);
        mstClientAppModule.RemoveLoadedProject(PrjId, True);
        DrawBox.RegenDrawing;
      end;
      //
      Rows := FRowIndex.Get(PrjId);
      if Rows = nil then
        Exit;
      if Rows.Count = 0 then
        Exit;
      //
      for I := Rows.Count - 1 downto 0 do
      begin
        ibqProjects.RecNo := Rows[I];
        Id2 := ibqProjects.FieldByName(SF_PROJECT_ID).AsInteger;
        if Id2 = PrjId then
          ibqProjects.Delete;
      end;
      FRowIndex.Delete(PrjId);
//
//      ibqProjects.First;
//      while not ibqProjects.Eof do
//      begin
//        try
//          Id2 := ibqProjects.FieldByName(SF_PROJECT_ID).AsInteger;
//          if Id2 = PrjId then
//            ibqProjects.Delete
//          else
//            ibqProjects.Next;
//        finally
//        end;
//      end;
      ibqProjects.FetchAll;
      if ibqProjects.RecordCount < RowNo then
        ibqProjects.Last
      else
        ibqProjects.RecNo := RowNo;
    finally
      ibqProjects.EnableControls;
    end;
  end;
end;

procedure TmstMPBrowserForm.DisplayObj(Prj: TmstProjectMP; ObjId: Integer);
var
  aLayer: TEzBaseLayer;
  aRecNo: Integer;
  MpObj: TmstProjectMPObject;
  LayerName: string;
begin
  MpObj := Prj.Objects.GetByDbId(ObjId);
  if not Assigned(MpObj) then
    Exit;
//  LayerName := TProjectUtils.GetMPLayerName(MpObj.Status, MpObj.Layer.MPLayerId);
  LayerName := MpObj.EzLayerName;
  aLayer := TProjectUtils.GIS.Layers.LayerByName(LayerName);
  if Assigned(aLayer) then
  begin
    aLayer.Recno := MpObj.EzLayerRecno;
    FDrawBox.SetEntityInViewEx(aLayer.Name, aRecno, True);
    FDrawBox.BlinkEntityEx(aLayer.Name, aRecno);
  end;

end;

procedure TmstMPBrowserForm.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  mstMPBrowserForm := nil;
  Action := caFree;
end;

procedure TmstMPBrowserForm.FormCreate(Sender: TObject);
begin
  FFilter := TmstProjectsBrowserFilterMP.Create;
  FRowIndex := TQueryRowIndex.Create;
  FHighlightEnabled := True;
  mstClientAppModule.ReadFormPosition(Application, Self);
  mstClientAppModule.ReadGridProperties(Self, kaDBGrid1);
end;

function TmstMPBrowserForm.GetProjectAndLoadToGIS(PrjId: Integer): TmstProjectMP;
var
  Loaded: Boolean;
begin
  Loaded := mstClientAppModule.IsProjectLoaded(PrjId, True);
  Result := mstClientAppModule.GetProject(PrjId, True, True) as TmstProjectMP;
  if Assigned(Result) and not Loaded then
  begin
    TProjectUtils.AddProjectToGIS(Result);
    mstClientAppModule.AddLoadedProject(PrjId, True);
  end;
end;

function TmstMPBrowserForm.IntLocate(const PrjId, ObjId: Integer; const DisableUI: Boolean): Boolean;
var
  CurrRow: Integer;
  Rows: TIntegerList;
  RowNo: Integer;
  I: Integer;
begin
  Result := ibqProjects.Active;
  if Result then
  begin
    if DisableUI then
      ibqProjects.DisableControls;
    try
      CurrRow := ibqProjects.RecNo;
      Rows := FRowIndex.Get(PrjId);
      if Rows = nil then
      begin
        Result := False;
        ibqProjects.RecNo := CurrRow;
        Exit;
      end;
      if Rows.Count = 0 then
      begin
        Result := False;
        ibqProjects.RecNo := CurrRow;
        Exit;
      end;
      //
      if ObjId < 0 then
      begin
        RowNo := Rows[0];
        ibqProjects.RecNo := RowNo;
        if ibqProjects.RecNo = RowNo then
        begin
          Result := True;
          Exit;
        end
        else
        begin
          Result := False;
          ibqProjects.RecNo := CurrRow;
          Exit;
        end;
      end;
      //
      for I := 0 to Rows.Count - 1 do
      begin
        ibqProjects.RecNo := Rows[I];
        if (ibqProjects.FieldByName(SF_OBJ_ID).AsInteger = ObjId) then
        begin
          Result := True;
          Exit;
        end;
      end;
      //
      Result := False;
      ibqProjects.RecNo := CurrRow;
      Exit;
      //
      ibqProjects.First;
      if ibqProjects.Locate(SF_PROJECT_ID, PrjId, []) then
      begin
        if (ObjId < 0) then
        begin
          Result := True;
          Exit;
        end;
        while not ibqProjects.Eof do
        begin
          if (ibqProjects.FieldByName(SF_PROJECT_ID).AsInteger <> PrjId) then
          begin
            Result := False;
            Exit;
          end;
          if (ibqProjects.FieldByName(SF_OBJ_ID).AsInteger = ObjId) then
          begin
            Result := True;
            Exit;
          end;
          ibqProjects.Next;
        end;
      end;
//      while not ibqProjects.Eof do
//      begin
//        if (ibqProjects.FieldByName(SF_PROJECT_ID).AsInteger = PrjId) then
//        if (LineId < 0)
//           or
//           (ibqProjects.FieldByName(SF_LINE_ID).AsInteger = LineId)
//        then
//        begin
//          Result := True;
//          Exit;
//        end;
//        ibqProjects.Next;
//      end;
      ibqProjects.RecNo := CurrRow;
    finally
      if DisableUI then
        ibqProjects.EnableControls;
    end;
    Result := False;
  end;
end;

function TmstMPBrowserForm.Locate(const PrjId, ObjId: Integer): Boolean;
begin
  Result := IntLocate(PrjId, ObjId, True);
end;

procedure TmstMPBrowserForm.PrepareDataSet;
begin
  if not IBTransaction1.Active then
    IBTransaction1.StartTransaction;
  ApplyFilter();
end;

function TmstMPBrowserForm.PrepareSql: string;
var
  Where: string;
  Added: Boolean;
begin
  Result := SQL_SELECT_MP_OBJECTS;
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

procedure TmstMPBrowserForm.RebuildIndex;
begin

end;

procedure TmstMPBrowserForm.ReleaseDataSet;
begin
  ibqProjects.Active := False;
  if IBTransaction1.Active then
    IBTransaction1.Commit;
end;

procedure TmstMPBrowserForm.SetDrawBox(const Value: TEzBaseDrawBox);
begin
  FDrawBox := Value;
end;

procedure TmstMPBrowserForm.ShowFilterDialog;
var
  Pt: TPoint;
//  Dlg: TmstProjectBrowserFilterMpDialog;
begin
  if mstMPBrowserFilterDialog = nil then
  begin
    mstMPBrowserFilterDialog := TmstMPBrowserFilterDialog.Create(Self);
    Pt.X := 0;
    Pt.Y := btnFilterClear.Height + 1;
    Pt := btnFilterClear.ClientToScreen(Pt);
    mstMPBrowserFilterDialog.Left := Pt.X;
    mstMPBrowserFilterDialog.Top := Pt.Y;
  end;
  if mstMPBrowserFilterDialog.Execute(FFilter) then
  begin
    ApplyFilter();
  end;
end;

procedure TmstMPBrowserForm.trackAlphaChange(Sender: TObject);
begin
  Self.AlphaBlendValue := trackAlpha.Position;
end;

end.
