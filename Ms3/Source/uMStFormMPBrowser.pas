unit uMStFormMPBrowser;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms, Dialogs,
  EzBaseGIS, IBSQL, Menus, IBCustomDataSet, IBUpdateSQL, ActnList, IBDatabase, DB, IBQuery, Grids, DBGrids, uDBGrid,
  ComCtrls, StdCtrls, DBCtrls, Buttons, ExtCtrls, ShellAPI,
  //
  EzLib,
  //
  uGC, uFileUtils,
  uMStKernelIBX,
  uMStClassesProjectsMP, uMStClassesMPIntf, uMStKernelAppSettings,
  uMStKernelClassesQueryIndex, uMStClassesProjectsUtils, uMStClassesProjectsBrowserMP;
  //
//  uMStModuleApp;

type
  TmstMPBrowserForm = class(TForm)
    Panel1: TPanel;
    btnClose: TSpeedButton;
    btnLoadToLayer: TSpeedButton;
    btnLoadAll: TSpeedButton;
    btnRemoveFromMap: TSpeedButton;
    btnRemoveAllFromMap: TSpeedButton;
    DBNavigator1: TDBNavigator;
    Panel3: TPanel;
    btnCoords: TSpeedButton;
    btnZone: TSpeedButton;
    btnRemoveZone: TSpeedButton;
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
    ActionList1: TActionList;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure chbTransparencyClick(Sender: TObject);
    procedure trackAlphaChange(Sender: TObject);
    procedure btnDisplayClick(Sender: TObject);
    procedure btnCloseClick(Sender: TObject);
    procedure btnFilterStartClick(Sender: TObject);
    procedure btnFilterClearClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure kaDBGrid1CellColors(Sender: TObject; Field: TField; var Background, FontColor: TColor;
      State: TGridDrawState; var FontStyle: TFontStyles);
    procedure btnLoadToLayerClick(Sender: TObject);
    procedure btnLoadAllClick(Sender: TObject);
    procedure btnCoordsClick(Sender: TObject);
    procedure btnRemoveAllFromMapClick(Sender: TObject);
    procedure btnRemoveFromMapClick(Sender: TObject);
    procedure ibqObjectsAfterScroll(DataSet: TDataSet);
    procedure ibqObjectsAfterClose(DataSet: TDataSet);
    procedure btnPropertiesClick(Sender: TObject);
    procedure sbtnDeleteProjectClick(Sender: TObject);
    procedure kaDBGrid1GetLogicalValue(Sender: TObject; Column: TColumn; var Value: Boolean);
    procedure kaDBGrid1LogicalColumn(Sender: TObject; Column: TColumn; var Value: Boolean);
  private
    FDrawBox: TEzBaseDrawBox;
    procedure SetDrawBox(const Value: TEzBaseDrawBox);
  private
    FFilter: TmstProjectsBrowserFilterMP;
    FHighlightEnabled: Boolean;
    FMP: ImstMPModule;
    FObjList: ImstMPModuleObjList;
    FAppSettings: ImstAppSettings;
    procedure ApplyFilter();
    procedure ClearFilter();
    procedure ShowFilterDialog();
    procedure LoadAndDisplayCurrentObj();
    procedure SetAppSettings(const Value: ImstAppSettings);
  public
    procedure Browse();
    //
    property AppSettings: ImstAppSettings read FAppSettings write SetAppSettings;
    property DrawBox: TEzBaseDrawBox read FDrawBox write SetDrawBox;
    property MP: ImstMPModule read FMP write FMP;
    property ObjList: ImstMPModuleObjList read FObjList write FObjList;
  end;

var
  mstMPBrowserForm: TmstMPBrowserForm;

implementation

uses
  uMStConsts, uMStClassesProjects,
  uMStDialogMPBrowserFilter;

{$R *.dfm}

{ TmstMPBrowserForm }

procedure TmstMPBrowserForm.ApplyFilter;
var
  Id: Integer;
begin
  // если запрос открыт, то запоминаем ID
  if DataSource1.DataSet.Active then
    Id := DataSource1.DataSet.FieldByName(SF_ID).AsInteger
  else
    Id := -1;
  // Применить параметры фильтра на DataSet
  //Sql := PrepareSql();
  if Id >= 0 then
    DataSource1.DataSet.Locate(SF_ID, Id, []);
end;

procedure TmstMPBrowserForm.Browse;
begin
  if not Visible then
  begin
    DataSource1.DataSet := FObjList.BrowserDataSet();
    FAppSettings.ReadFormPosition(Application, Self);
    FAppSettings.ReadGridProperties(Self, kaDBGrid1);
    ApplyFilter();
    Show;
  end
  else
    BringToFront;
end;

procedure TmstMPBrowserForm.btnCloseClick(Sender: TObject);
begin
  Close;
end;

procedure TmstMPBrowserForm.btnCoordsClick(Sender: TObject);
var
  ObjId: Integer;
  MpObj: TmstMPObject;
  Coords: TStringList;
  I: Integer;
  TmpFile: string;
  CoordsFile: string;
  Ent: TEzEntity;
  Ds: TDataSet;
begin
  Ds := DataSource1.DataSet;
  // получаем текущую линию
  if Ds.Active then
  begin
    ObjId := Ds.FieldByName(SF_ID).AsInteger;
    MpObj := FMP.GetObjByDbId(ObjId, True);
    if Assigned(MpObj) then
    begin
      // составляем список координат
      Coords := TStringList.Create;
      try
        Ent := TProjectUtils.GetMpObjEntity(MpObj);
        try
          for I := 0 to Ent.Points.Count - 1 do
          begin
            Coords.Add(IntToStr(Succ(I)) + ';' +
                       FormatFloat('#0.00', Ent.Points[I].X) + ';' +
                       FormatFloat('#0.00', Ent.Points[I].Y));
          end;
        finally
          FreeAndNil(Ent);
        end;

        // пишем его в файл
        TmpFile := TFileUtils.CreateTempFile(FAppSettings.SessionDir);
        CoordsFile := ChangeFileExt(TmpFile, '.txt');
        TFileUtils.RenameFile(TmpFile, CoordsFile);
        Coords.SaveToFile(CoordsFile);
      finally
        Coords.Free;
      end;
      // открываем файл
      ShellExecute(Handle, 'open', PChar(CoordsFile), nil, nil, SW_SHOWNORMAL);
    end;
  end;
end;

procedure TmstMPBrowserForm.btnDisplayClick(Sender: TObject);
begin
  LoadAndDisplayCurrentObj();
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

procedure TmstMPBrowserForm.btnLoadAllClick(Sender: TObject);
begin
  FMP.LoadAllToGIS();
end;

procedure TmstMPBrowserForm.btnLoadToLayerClick(Sender: TObject);
begin
  LoadAndDisplayCurrentObj();
end;

procedure TmstMPBrowserForm.btnPropertiesClick(Sender: TObject);
var
  ObjId: Integer;
  Ds: TDataSet;
begin
  Ds := DataSource1.DataSet;
  if not Ds.Active then
    Exit;
  ObjId := Ds.FieldByName(SF_ID).AsInteger;
  if FMP.EditObjProperties(ObjId) then
     Ds.Refresh;
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

procedure TmstMPBrowserForm.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  mstMPBrowserForm := nil;
  Action := caFree;
  TMPSettings.SetCurrentMPObj(-1, -1);
  FAppSettings.WriteFormPosition(Application, Self);
  FAppSettings.WriteGridProperties(Self, kaDBGrid1);
  FMP.NavigatorClosed();
end;

procedure TmstMPBrowserForm.FormCreate(Sender: TObject);
begin
  FFilter := TmstProjectsBrowserFilterMP.Create;
  FHighlightEnabled := True;
end;

procedure TmstMPBrowserForm.FormDestroy(Sender: TObject);
begin
  FFilter.Free;
end;

procedure TmstMPBrowserForm.ibqObjectsAfterClose(DataSet: TDataSet);
begin
  TMPSettings.SetCurrentMPObj(-1, -1);
end;

procedure TmstMPBrowserForm.ibqObjectsAfterScroll(DataSet: TDataSet);
var
//  OldPrjId, PrjId: Integer;
  ObjId: Integer;
//  OldLoaded, NewLoaded: Boolean;
  Ds: TDataSet;
begin
  if FHighlightEnabled then
  begin
    Ds := DataSource1.DataSet;
    ObjId := Ds.FieldByName(SF_ID).AsInteger;
    if FMP.IsLoaded(ObjId) then
      FDrawBox.RegenDrawing;
  end;
end;

procedure TmstMPBrowserForm.kaDBGrid1CellColors(Sender: TObject; Field: TField; var Background, FontColor: TColor;
  State: TGridDrawState; var FontStyle: TFontStyles);
var
  ObjId: Integer;
  Loaded: Boolean;
  Ds: TDataSet;
begin
  Ds := DataSource1.DataSet;
  ObjId := Ds.FieldByName(SF_ID).AsInteger;
  Loaded := FMP.IsLoaded(ObjId);
  if Loaded then
  begin
    FontColor := clGreen;
    if State = [] then
      Background := clYellow;
  end;
end;

procedure TmstMPBrowserForm.kaDBGrid1GetLogicalValue(Sender: TObject; Column: TColumn; var Value: Boolean);
begin
//  if (Column.FieldName = SF_DISMANTLED) or
//     (Column.FieldName = SF_ARCHIVED) or
//     (Column.FieldName = SF_UNDERGROUND) or
//     (Column.FieldName = SF_CONFIRMED) or
//     (Column.FieldName = SF_DRAWN) or
//     (Column.FieldName = SF_PROJECTED) or
//     (Column.FieldName = SF_HAS_CERTIF)
//  then
    Value := Column.Field.AsInteger = 1;
end;

procedure TmstMPBrowserForm.kaDBGrid1LogicalColumn(Sender: TObject; Column: TColumn; var Value: Boolean);
begin
  Value := (Column.FieldName = SF_DISMANTLED) or
     (Column.FieldName = SF_ARCHIVED) or
     (Column.FieldName = SF_UNDERGROUND) or
     (Column.FieldName = SF_CONFIRMED) or
     (Column.FieldName = SF_DRAWN) or
     (Column.FieldName = SF_PROJECTED) or
     (Column.FieldName = SF_HAS_CERTIF);
end;

procedure TmstMPBrowserForm.LoadAndDisplayCurrentObj;
var
  ObjId: Integer;
  Ds: TDataSet;
begin
  Ds := DataSource1.DataSet;
  if Ds.Active then
  begin
    ObjId := Ds.FieldByName(SF_ID).AsInteger;
    FMP.LoadToGis(ObjId, True);
    kaDBGrid1.Refresh;
  end;
end;

procedure TmstMPBrowserForm.sbtnDeleteProjectClick(Sender: TObject);
var
  ObjId: Integer;
  Ds: TDataSet;
begin
  Ds := DataSource1.DataSet;
  if Ds.Active and not Ds.IsEmpty then
  begin
    ObjId := Ds.FieldByName(SF_ID).AsInteger;
    FMP.DeleteObj(ObjId);
    // удаляем объект из проекта
    DrawBox.RegenDrawing;
  end;
end;

procedure TmstMPBrowserForm.SetAppSettings(const Value: ImstAppSettings);
begin
  FAppSettings := Value;
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

procedure TmstMPBrowserForm.btnRemoveFromMapClick(Sender: TObject);
var
  ObjId: Integer;
  Ds: TDataSet;
begin
  Ds := DataSource1.DataSet;
  if Ds.Active then
  begin
    ObjId := Ds.FieldByName(SF_ID).AsInteger;
    if FMP.UnloadFromGis(ObjId) then
    begin
      DrawBox.RegenDrawing;
      kaDbGrid1.Refresh;
    end;
  end;
end;

procedure TmstMPBrowserForm.btnRemoveAllFromMapClick(Sender: TObject);
begin
  FMP.UnloadAllFromGis();
//  DrawBox.RegenDrawing;
  kaDbGrid1.Refresh;
end;

procedure TmstMPBrowserForm.trackAlphaChange(Sender: TObject);
begin
  Self.AlphaBlendValue := trackAlpha.Position;
end;

end.
