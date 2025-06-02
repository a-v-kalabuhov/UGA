unit uMStFormMPBrowser;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms, Dialogs, DB,
  EzBaseGIS, IBSQL, Menus, IBCustomDataSet, IBUpdateSQL, ActnList, IBDatabase, IBQuery, Grids, DBGrids,
  ComCtrls, StdCtrls, DBCtrls, Buttons, ExtCtrls, ShellAPI, Clipbrd, ImgList, StrUtils,
  //
  RxMemDS,
  EzLib,
  //
  uDBGrid,
  uGC, uFileUtils, uGeoTypes, uCK36, uTypes,
  uMStKernelIBX,
  uMStClassesProjectsMP, uMStClassesMPIntf, uMStKernelAppSettings,
  uMStKernelClassesQueryIndex, uMStClassesProjectsUtils, uMStClassesProjectsBrowserMP, uMStClassesMPStatuses,
  uMStClassesProjectsMPIntersect;
  //
//  uMStModuleApp;

type
  TmstMPBrowserForm = class(TForm, ImstMPObjEventSubscriber, ImstMPBrowser)
    Panel1: TPanel;
    Panel2: TPanel;
    btnClose: TSpeedButton;
    DBNavigator1: TDBNavigator;
    tabData: TPanel;
    kaDBGrid1: TkaDBGrid;
    DataSource1: TDataSource;
    ActionList1: TActionList;
    acObjGiveOutCertif: TAction;
    acObjLoadToGis: TAction;
    PopupMenu1: TPopupMenu;
    acObjCopyId: TAction;
    ID1: TMenuItem;
    acObjProjectedToDrawn: TAction;
    N1: TMenuItem;
    memBrowser2: TRxMemoryData;
    acListRefresh: TAction;
    N2: TMenuItem;
    N3: TMenuItem;
    ImageList1: TImageList;
    MainMenu1: TMainMenu;
    FF1: TMenuItem;
    N4: TMenuItem;
    N5: TMenuItem;
    N6: TMenuItem;
    N7: TMenuItem;
    N8: TMenuItem;
    acFilterSet: TAction;
    acFilterClear: TAction;
    acObjProperties: TAction;
    N9: TMenuItem;
    N10: TMenuItem;
    N11: TMenuItem;
    N12: TMenuItem;
    N13: TMenuItem;
    acObjRemove: TAction;
    N14: TMenuItem;
    acListLoadToGis: TAction;
    acListLoadToGis1: TMenuItem;
    N15: TMenuItem;
    acObjUnloadFromGis: TAction;
    N16: TMenuItem;
    acListUnloadFromGis: TAction;
    N17: TMenuItem;
    acObjExportCoords: TAction;
    ID2: TMenuItem;
    N18: TMenuItem;
    acObjDisplay: TAction;
    N19: TMenuItem;
    N20: TMenuItem;
    N21: TMenuItem;
    btnDisplay: TSpeedButton;
    trackAlpha: TTrackBar;
    chbTransparency: TCheckBox;
    N22: TMenuItem;
    acViewTransparency: TAction;
    btnZone: TSpeedButton;
    btnRemoveZone: TSpeedButton;
    acTransparency1: TMenuItem;
    N23: TMenuItem;
    N24: TMenuItem;
    N25: TMenuItem;
    N26: TMenuItem;
    N27: TMenuItem;
    N28: TMenuItem;
    acObjCheck: TAction;
    N29: TMenuItem;
    N30: TMenuItem;
    N31: TMenuItem;
    N33: TMenuItem;
    acObjDivideByPoint: TAction;
    N32: TMenuItem;
    N34: TMenuItem;
    SortImageList: TImageList;
    acViewFastSearch: TAction;
    N35: TMenuItem;
    pnlFastSearch: TPanel;
    Label1: TLabel;
    edFastSearchCol: TEdit;
    Label2: TLabel;
    edFastSearch: TEdit;
    SpeedButton1: TSpeedButton;
    acListDoFastSearch: TAction;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure chbTransparencyClick(Sender: TObject);
    procedure trackAlphaChange(Sender: TObject);
    procedure btnCloseClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure kaDBGrid1CellColors(Sender: TObject; Field: TField; var Background, FontColor: TColor;
      State: TGridDrawState; var FontStyle: TFontStyles);
    procedure kaDBGrid1GetLogicalValue(Sender: TObject; Column: TColumn; var Value: Boolean);
    procedure kaDBGrid1LogicalColumn(Sender: TObject; Column: TColumn; var Value: Boolean);
    procedure acObjGiveOutCertifExecute(Sender: TObject);
    procedure acObjGiveOutCertifUpdate(Sender: TObject);
    procedure kaDBGrid1MouseUp(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure acObjCopyIdExecute(Sender: TObject);
    procedure acObjProjectedToDrawnExecute(Sender: TObject);
    procedure acObjProjectedToDrawnUpdate(Sender: TObject);
    procedure acListRefreshExecute(Sender: TObject);
    procedure acFilterSetExecute(Sender: TObject);
    procedure acFilterClearExecute(Sender: TObject);
    procedure acObjPropertiesExecute(Sender: TObject);
    procedure acObjRemoveExecute(Sender: TObject);
    procedure acListLoadToGisExecute(Sender: TObject);
    procedure acObjUnloadFromGisExecute(Sender: TObject);
    procedure acListUnloadFromGisExecute(Sender: TObject);
    procedure acObjExportCoordsExecute(Sender: TObject);
    procedure acObjDisplayExecute(Sender: TObject);
    procedure acViewTransparencyExecute(Sender: TObject);
    procedure acViewTransparencyUpdate(Sender: TObject);
    procedure acObjLoadToGisExecute(Sender: TObject);
    procedure acObjLoadToGisUpdate(Sender: TObject);
    procedure kaDBGrid1DblClick(Sender: TObject);
    procedure acObjCheckExecute(Sender: TObject);
    procedure memBrowser2AfterScroll(DataSet: TDataSet);
    procedure memBrowser2AfterClose(DataSet: TDataSet);
    procedure acObjDivideByPointUpdate(Sender: TObject);
    procedure acObjDivideByPointExecute(Sender: TObject);
    procedure kaDBGrid1TitleClick(Column: TColumn);
    procedure kaDBGrid1DrawColumnCell(Sender: TObject; const Rect: TRect; DataCol: Integer; Column: TColumn;
      State: TGridDrawState);
    function kaDBGrid1GetSortColumn(Sender: TObject; Column: TColumn; var Desc: Boolean): Boolean;
    procedure kaDBGrid1DrawSortIcon(Sender: TObject; aCanvas: TCanvas; const aRect: TRect);
    procedure acViewFastSearchExecute(Sender: TObject);
    procedure acViewFastSearchUpdate(Sender: TObject);
    procedure kaDBGrid1ColEnter(Sender: TObject);
    procedure edFastSearchKeyPress(Sender: TObject; var Key: Char);
    procedure acListDoFastSearchExecute(Sender: TObject);
    procedure acListDoFastSearchUpdate(Sender: TObject);
  private
    FDrawBox: TEzBaseDrawBox;
    procedure SetDrawBox(const Value: TEzBaseDrawBox);
  private
    FSortFieldName: string;
    FSortDesc: Boolean;
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
    procedure LoadFilteredToGis();
    procedure SetAppSettings(const Value: ImstAppSettings);
    procedure FilterRecord(DataSet: TDataSet; var Accept: Boolean);
    procedure RefreshDataSet();
    procedure RefreshCurrentRow();
  private
    FFastSearchColName: string;
    procedure SetFastSearchCol(aCol: TColumn);
  private
    procedure Notify(const ObjId: Integer; Op: TRowOperation);
  private
    procedure LocateObj(const ObjId: Integer);
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
  uMStConsts, uMStClassesProjects, uMStDialogCertifNumber, uMStModuleApp,
  uMStDialogMPBrowserFilter, uMStDialogPoint;

{$R *.dfm}

{ TmstMPBrowserForm }

procedure TmstMPBrowserForm.acObjCheckExecute(Sender: TObject);
var
  Found: TmpIntersectionInfo;
  ObjId: Integer;
  Ds: TDataSet;
begin
  Ds := DataSource1.DataSet;
  ObjId := Ds.FieldByName(SF_ID).AsInteger;
  if not FMP.CanFindIntersections(ObjId) then
  begin
    ShowMessage('Поиск пересечений не доступен для объектов данного типа!');
    Exit;
  end;
  // ищем список объектов
  // - архив не ищем
  // - ищем среди всех, а не только загhуженных
  Found := FMP.FindIntersects(ObjId);
  try
    if Found.Count = 0 then
    begin
      // если не нашли, то показываем сообщение
      ShowMessage('Пересечения не обнаружены!');
      FMP.SetObjCheckState(ObjId, ocsChecked);
      RefreshCurrentRow();
    end
    else
    begin
      // если нашли, то показываем окно
      FMP.IntersectDialog(Found);
    end;
  finally
//    FreeAndNil(Found);
  end;
end;

procedure TmstMPBrowserForm.acObjCopyIdExecute(Sender: TObject);
var
  ObjGuid: string;
begin
  ObjGuid := DataSource1.DataSet.FieldByName(SF_OBJ_ID).AsString;
  Clipboard.AsText := ObjGuid;
end;

procedure TmstMPBrowserForm.acFilterClearExecute(Sender: TObject);
begin
  ClearFilter();
//  ApplyFilter();
end;

procedure TmstMPBrowserForm.acObjDisplayExecute(Sender: TObject);
begin
  LoadAndDisplayCurrentObj();
end;

procedure TmstMPBrowserForm.acObjDivideByPointExecute(Sender: TObject);
var
  ObjId: Integer;
begin
  ObjId := DataSource1.DataSet.FieldByName(SF_ID).AsInteger;
  FMP.DivideObj(ObjId);
end;

procedure TmstMPBrowserForm.acObjDivideByPointUpdate(Sender: TObject);
var
  ObjId: Integer;
begin
  ObjId := DataSource1.DataSet.FieldByName(SF_ID).AsInteger;
  acObjDivideByPoint.Enabled := FObjList.CanDivide(ObjId);
end;

procedure TmstMPBrowserForm.acObjExportCoordsExecute(Sender: TObject);
var
  ObjId: Integer;
  MpObj: TmstMPObject;
  Coords: TStringList;
  I: Integer;
  TmpFile: string;
  CoordsFile: string;
  Ent: TEzEntity;
  Ds: TDataSet;
  X, Y: Double;
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
            X := Ent.Points[I].Y;
            Y := Ent.Points[I].X;
            if mstClientAppModule.ViewCoordSystem = csMCK36 then
              uCK36.ToCK36(X, Y);
            //
            Coords.Add(IntToStr(Succ(I)) + ';' +
                       FormatFloat('#0.00', X) + ';' +
                       FormatFloat('#0.00', Y));
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

procedure TmstMPBrowserForm.acObjGiveOutCertifExecute(Sender: TObject);
var
  Dlg: TmstMPCertifDialog;
  CertifNumber: string;
  CertifDate: TDateTime;
  ObjId: Integer;
begin
  // показывается окно для ввода номера и даты справки,
  Dlg := TmstMPCertifDialog.Create(Self);
  try
    CertifNumber := DataSource1.DataSet.FieldByName(SF_CERTIF_NUMBER).AsString;
    CertifDate := DataSource1.DataSet.FieldByName(SF_CERTIF_DATE).AsDateTime;
    if Dlg.Execute(CertifNumber, CertifDate) then
    begin
      // сеть помечается как "Справка выдана" и переносится в другую группу слоёв.
      ObjId := DataSource1.DataSet.FieldByName(SF_ID).AsInteger;
      FMP.GiveOutCertif(ObjId, CertifNumber, CertifDate);
      DrawBox.RegenDrawing;
    end;
  finally
    Dlg.Free;
  end;
end;

procedure TmstMPBrowserForm.acObjGiveOutCertifUpdate(Sender: TObject);
var
  HasCertif: Boolean;
  Status: Integer;
begin
  HasCertif := DataSource1.DataSet.FieldByName(SF_HAS_CERTIF).AsInteger = 1;
  Status := DataSource1.DataSet.FieldByName(SF_STATUS).AsInteger;
  acObjGiveOutCertif.Enabled := not HasCertif or (Status <> TmstMPStatuses.Drawn);
end;

procedure TmstMPBrowserForm.acObjLoadToGisExecute(Sender: TObject);
var
  ObjId: Integer;
  Ds: TDataSet;
begin
  Ds := DataSource1.DataSet;
  if Ds.Active then
  begin
    ObjId := Ds.FieldByName(SF_ID).AsInteger;
    FMP.LoadToGis(ObjId, False, True);
    kaDBGrid1.Refresh;
  end;
end;

procedure TmstMPBrowserForm.acObjLoadToGisUpdate(Sender: TObject);
var
  ObjLoaded: Boolean;
  ObjId: Integer;
begin
  ObjId := DataSource1.DataSet.FieldByName(SF_ID).AsInteger;
  ObjLoaded := FMP.IsLoaded(ObjId); //DataSource1.DataSet.FieldByName(SF_LOADED).AsInteger = 1;
  acObjLoadToGis.Enabled := not ObjLoaded;
end;

procedure TmstMPBrowserForm.acObjPropertiesExecute(Sender: TObject);
var
  ObjId: Integer;
  Ds: TDataSet;
begin
  Ds := DataSource1.DataSet;
  if not Ds.Active then
    Exit;
  ObjId := Ds.FieldByName(SF_ID).AsInteger;
  FMP.EditObjProperties(ObjId);
end;

procedure TmstMPBrowserForm.acObjRemoveExecute(Sender: TObject);
var
  ObjId: Integer;
  Ds: TDataSet;
begin
  Ds := DataSource1.DataSet;
  if Ds.Active and not Ds.IsEmpty then
  begin
    ObjId := Ds.FieldByName(SF_ID).AsInteger;
    // удаляем объект из проекта
    FMP.DeleteObj(ObjId);
    // --удаляем текущую строку в браузере
    // строка удалистя через увдомление от МР модуля
//    Ds.Delete;
    DrawBox.RegenDrawing;
  end;
end;

procedure TmstMPBrowserForm.acObjUnloadFromGisExecute(Sender: TObject);
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

procedure TmstMPBrowserForm.acViewFastSearchExecute(Sender: TObject);
begin
  pnlFastSearch.Visible := not pnlFastSearch.Visible;
end;

procedure TmstMPBrowserForm.acViewFastSearchUpdate(Sender: TObject);
begin
  acViewFastSearch.Checked := pnlFastSearch.Visible;
end;

procedure TmstMPBrowserForm.acViewTransparencyExecute(Sender: TObject);
begin
  chbTransparency.Checked := not chbTransparency.Checked;
end;

procedure TmstMPBrowserForm.acViewTransparencyUpdate(Sender: TObject);
begin
  acViewTransparency.Checked := chbTransparency.Checked;
end;

procedure TmstMPBrowserForm.acObjProjectedToDrawnExecute(Sender: TObject);
var
  ObjId: Integer;
begin
  ObjId := DataSource1.DataSet.FieldByName(SF_ID).AsInteger;
  FMP.CopyToDrawn(ObjId);
  kaDBGrid1.Refresh;
end;

procedure TmstMPBrowserForm.acObjProjectedToDrawnUpdate(Sender: TObject);
var
  Drawn: Boolean;
begin
  Drawn := DataSource1.DataSet.FieldByName(SF_DRAWN).AsInteger = 1;
  acObjProjectedToDrawn.Enabled := not Drawn;
end;

procedure TmstMPBrowserForm.acListDoFastSearchExecute(Sender: TObject);
var
  Fld: TField;
begin
  if (FFastSearchColName <> '') and (edFastSearch.Text <> '') then
  begin
    Fld := memBrowser2.FieldByName(FFastSearchColName);
    if Assigned(Fld) then
    begin
      memBrowser2.Locate(FFastSearchColName, edFastSearch.Text, [loPartialKey]);
    end;
  end;
end;

procedure TmstMPBrowserForm.acListDoFastSearchUpdate(Sender: TObject);
var
  Fld: TField;
  B: Boolean;
begin
  B := (FFastSearchColName <> '') and (edFastSearch.Text <> '');
  if B then
  begin
    Fld := memBrowser2.FieldByName(FFastSearchColName);
    B := Assigned(Fld);
  end;
  acListDoFastSearch.Enabled := B;
end;

procedure TmstMPBrowserForm.acListLoadToGisExecute(Sender: TObject);
begin
  if FFilter.IsEmpty then
    FMP.LoadAllToGIS()
  else
    LoadFilteredToGis();
  kaDBGrid1.Refresh;
  DrawBox.RegenDrawing;
end;

procedure TmstMPBrowserForm.acListRefreshExecute(Sender: TObject);
begin
  RefreshDataSet();
end;

procedure TmstMPBrowserForm.acListUnloadFromGisExecute(Sender: TObject);
begin
  FMP.UnloadAllFromGis();
  kaDbGrid1.Refresh;
  DrawBox.RegenDrawing;
end;

procedure TmstMPBrowserForm.acFilterSetExecute(Sender: TObject);
begin
  ShowFilterDialog();
end;

procedure TmstMPBrowserForm.ApplyFilter;
var
  Id: Integer;
begin
  if DataSource1.DataSet.Active then
  begin
    if FFilter.IsEmpty() then
    begin
      DataSource1.DataSet.Filtered := False;
      DataSource1.DataSet.Filter := '';
      DataSource1.DataSet.OnFilterRecord := nil;
    end
    else
    begin
      DataSource1.DataSet.Filtered := True;
      DataSource1.DataSet.OnFilterRecord := FilterRecord;
    end;
  end;

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
//var
//  V: Variant;
begin
  if not Visible then
  begin
    memBrowser2.LoadFromDataSet(FObjList.BrowserDataSet(), 0, lmCopy);
//    memBrowser2.CopyStructure(FObjList.BrowserDataSet());
    DataSource1.DataSet := memBrowser2;
    FAppSettings.ReadFormPosition(Application, Self);
    FAppSettings.ReadGridProperties(Self, kaDBGrid1);
    //
    FSortFieldName := mstClientAppModule.GetOption('MPBrowserForm', 'SortField', '');
    FSortDesc := mstClientAppModule.GetOption('MPBrowserForm', 'SortFieldOrder', '0') <> '0';
    //
    ApplyFilter();
    memBrowser2.Active := True;
    //
    FObjList.Subscribe(Self as ImstMPObjEventSubscriber);
    //
    Show;
  end
  else
    BringToFront;
end;

procedure TmstMPBrowserForm.btnCloseClick(Sender: TObject);
begin
  Close;
end;

procedure TmstMPBrowserForm.chbTransparencyClick(Sender: TObject);
begin
  Self.AlphaBlend := chbTransparency.Checked;
  trackAlpha.Visible := chbTransparency.Checked;
end;

procedure TmstMPBrowserForm.ClearFilter;
begin
  FFilter.Clear();
  ApplyFilter();
end;

procedure TmstMPBrowserForm.edFastSearchKeyPress(Sender: TObject; var Key: Char);
begin
  if Key = #13 then
    acListDoFastSearch.Execute();
end;

procedure TmstMPBrowserForm.FilterRecord(DataSet: TDataSet; var Accept: Boolean);
var
  S: string;
  B: Boolean;
  DateVal: TDateTime;
  CheckState: TmstMPObjectCheckState;
begin
  if FFilter.IsEmpty then
    Exit;
//  FFilter.Address := edAddress.Text;
//  FFilter.DocNumber := edDocNumber.Text;
//  FFilter.DocDateStart := dtpDateProject1.DateTime;
//  FFilter.DocDateEnd := dtpDateProject2.DateTime;
//  FFilter.Archived := chbArchived.Checked;
//  FFilter.Confirmed := chbConfirmed.Checked;
//  FFilter.Dismantled := chbDismantled.Checked;
//  FFilter.Underground := chbUndergroud.Checked;
  if FFilter.Archived <> boolAll then
  begin
    B := DataSet.FieldByName(SF_ARCHIVED).AsInteger = 1;
    Accept := ((FFilter.Archived = boolTrue) and B)
              or
              ((FFilter.Archived = boolFalse) and not B);
  end;
  if not Accept then
    Exit;
  //
  if FFilter.Confirmed <> boolAll then
  begin
    B := DataSet.FieldByName(SF_CONFIRMED).AsInteger = 1;
    Accept := ((FFilter.Confirmed = boolTrue) and B)
              or
              ((FFilter.Confirmed = boolFalse) and not B);
  end;
  if not Accept then
    Exit;
  //
  if FFilter.Dismantled <> boolAll then
  begin
    B := DataSet.FieldByName(SF_DISMANTLED).AsInteger = 1;
    Accept := ((FFilter.Dismantled = boolTrue) and B)
              or
              ((FFilter.Dismantled = boolFalse) and not B);
  end;
  if not Accept then
    Exit;
  //
  if FFilter.Underground <> boolAll then
  begin
    B := DataSet.FieldByName(SF_UNDERGROUND).AsInteger = 1;
    Accept := ((FFilter.Underground = boolTrue) and B)
              or
              ((FFilter.Underground = boolFalse) and not B);
  end;
  if not Accept then
    Exit;
  //
  if FFilter.NeedCheck <> boolAll then
  begin
    CheckState := TmstMPObjectCheckState(DataSet.FieldByName(SF_CHECK_STATE).AsInteger);
    Accept := ((FFilter.NeedCheck = boolTrue) and (CheckState in [ocsImported, ocsEdited]))
              or
              ((FFilter.Underground = boolFalse) and (CheckState in [ocsNone, ocsChecked]));
  end;
  if not Accept then
    Exit;
  //
  if FFilter.Address <> '' then
  begin
    S := DataSet.FieldByName(SF_ADDRESS).AsString;
    Accept := Pos(AnsiUpperCase(FFilter.Address), AnsiUpperCase(S)) > 0;
  end;
  if not Accept then
    Exit;
  //
  if FFilter.DocNumber <> '' then
  begin
    S := DataSet.FieldByName(SF_DOC_NUMBER).AsString;
    Accept := Pos(AnsiUpperCase(FFilter.DocNumber), AnsiUpperCase(S)) > 0;
  end;
  if not Accept then
    Exit;
  //
  if FFilter.UseDocDateStart then
  begin
    DateVal := DataSet.FieldByName(SF_DOC_DATE).AsDateTime;
    Accept := FFilter.DocDateStart > DateVal;
  end;
  if not Accept then
    Exit;
  //
  if FFilter.UseDocDateEnd then
  begin
    DateVal := DataSet.FieldByName(SF_DOC_DATE).AsDateTime;
    Accept := FFilter.DocDateEnd < DateVal;
  end;
end;

procedure TmstMPBrowserForm.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  mstMPBrowserForm := nil;
  Action := caFree;
  TMPSettings.SetCurrentMPObj(-1);
  FAppSettings.WriteFormPosition(Application, Self);
  FAppSettings.WriteGridProperties(Self, kaDBGrid1);
  mstClientAppModule.SetOption('MPBrowserForm', 'SortField', FSortFieldName);
  mstClientAppModule.SetOption('MPBrowserForm', 'SortFieldOrder', IfThen(FSortDesc, '1', '0'));
  memBrowser2.Close;
  FObjList.UnSubscribe(Self as ImstMPObjEventSubscriber);
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

procedure TmstMPBrowserForm.kaDBGrid1CellColors(Sender: TObject; Field: TField; var Background, FontColor: TColor;
  State: TGridDrawState; var FontStyle: TFontStyles);
var
  ObjId: Integer;
  Loaded: Boolean;
  Ds: TDataSet;
  NeedCheck: Boolean;
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
  NeedCheck := TmstMPObjectCheckState(Ds.FieldByName(SF_CHECK_STATE).AsInteger) > ocsChecked;
  if NeedCheck then
    FontColor := clRed;
end;

procedure TmstMPBrowserForm.kaDBGrid1ColEnter(Sender: TObject);
begin
  SetFastSearchCol(kaDBGrid1.CurrentCol);
end;

procedure TmstMPBrowserForm.kaDBGrid1DblClick(Sender: TObject);
var
  aRow, aCol: Integer;
  Pt: TPoint;
  ObjId: Integer;
  GridPt: TGridCoord;
begin
  aRow := kaDBGrid1.Row;
  aCol := kaDBGrid1.Col;
  Pt := Mouse.CursorPos;
  Pt := kaDBGrid1.ScreenToClient(Pt);
  GridPt := kaDBGrid1.MouseCoord(Pt.X, Pt.Y);
  if (GridPt.X = aCol) and (GridPt.Y = aRow) then
  begin
    ObjId := DataSource1.DataSet.FieldByName(SF_ID).AsInteger;
    FMP.EditObjProperties(ObjId);
  end;
end;

procedure TmstMPBrowserForm.kaDBGrid1DrawColumnCell(Sender: TObject; const Rect: TRect; DataCol: Integer;
  Column: TColumn; State: TGridDrawState);
begin
  if gdFixed in State then
    if Column.FieldName = FSortFieldName then
    begin
      //DrawSortIcon(Rect, FSortDesc);
    end;
end;

procedure TmstMPBrowserForm.kaDBGrid1DrawSortIcon(Sender: TObject; aCanvas: TCanvas; const aRect: TRect);
var
  idx: Integer;
  Hr: Integer;
  Himg: Integer;
  Wimg: Integer;
  X, Y: Integer;
begin
  if FSortDesc then
    Idx := 1
  else
    Idx := 0;
  Hr := aRect.Bottom - aRect.Top;
  Himg := SortImageList.Height;
  Y := aRect.Top + (Hr - Himg) div 2;
  Wimg := SortImageList.Width;
  X := aRect.Right - Hr + (Hr - Wimg) div 2;
  SortImageList.Draw(aCanvas, X, Y, idx, dsTransparent, itImage);
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

function TmstMPBrowserForm.kaDBGrid1GetSortColumn(Sender: TObject; Column: TColumn; var Desc: Boolean): Boolean;
begin
  Result := Column.FieldName = FSortFieldName;
  Desc := FSortDesc;
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

procedure TmstMPBrowserForm.kaDBGrid1MouseUp(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
var
  aRow, aCol: Integer;
  Pt: TPoint;
begin
  if Button <> mbRight then
    Exit;
  aRow := kaDBGrid1.Row;
  aCol := kaDBGrid1.Col;
  if (aRow > 0) and (aCol > 0) then
  begin
    Pt := Mouse.CursorPos;
    PopupMenu1.Popup(Pt.X, Pt.Y);
  end;
end;

procedure TmstMPBrowserForm.kaDBGrid1TitleClick(Column: TColumn);
begin
  if FSortFieldName = Column.FieldName then
  begin
    FSortDesc := not FSortDesc;
  end
  else
  begin
    FSortFieldName := Column.FieldName;
    FSortDesc := False;
  end;
  kaDBGrid1.Update();
  memBrowser2.SortOnFields(FSortFieldName, True, FSortDesc);
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
    FMP.LoadToGis(ObjId, True, False);
    kaDBGrid1.Refresh;
  end;
end;

procedure TmstMPBrowserForm.LoadFilteredToGis;
var
  Bkm: Pointer;
  ObjId: Integer;
begin
  Bkm := DataSource1.DataSet.GetBookmark;
  try
    DataSource1.DataSet.DisableControls;
    try
      DataSource1.DataSet.First;
      while not DataSource1.DataSet.Eof do
      begin
        ObjId := DataSource1.DataSet.FieldByName(SF_ID).AsInteger;
        FMP.LoadToGis(ObjId, False, False);
        DataSource1.DataSet.Next;
      end;
    finally
      DataSource1.DataSet.EnableControls;
    end;
  finally
    DataSource1.DataSet.GotoBookmark(Bkm);
  end;
end;

procedure TmstMPBrowserForm.LocateObj(const ObjId: Integer);
var
  Bkm: Pointer;
  RowObjId: Integer;
begin
  memBrowser2.DisableControls;
  try
    Bkm := memBrowser2.GetBookmark();
    if not memBrowser2.Locate(SF_ID, ObjId, []) then
      memBrowser2.GotoBookmark(Bkm);
  finally
    memBrowser2.EnableControls;
  end;
  //
  RowObjId := memBrowser2.FieldByName(SF_ID).AsInteger;
  TMPSettings.SetCurrentMPObj(RowObjId);
  DrawBox.Repaint;
end;

procedure TmstMPBrowserForm.memBrowser2AfterClose(DataSet: TDataSet);
begin
  TMPSettings.SetCurrentMPObj(-1);
  DrawBox.Repaint;
end;

procedure TmstMPBrowserForm.memBrowser2AfterScroll(DataSet: TDataSet);
var
  RowObjId: Integer;
begin
  if DataSet.ControlsDisabled then
    Exit;
  if DataSet.RecordCount = 0 then
    Exit;
  RowObjId := memBrowser2.FieldByName(SF_ID).AsInteger;
  TMPSettings.SetCurrentMPObj(RowObjId);
//  DrawBox.Refresh;
  DrawBox.Repaint;
//  DrawBox.RegenDrawing;
end;

procedure TmstMPBrowserForm.Notify(const ObjId: Integer; Op: TRowOperation);
var
  RowObjId: Integer;
begin
  if not memBrowser2.Active then
    Exit;
  //
  RowObjId := memBrowser2.FieldByName(SF_ID).AsInteger;
  if RowObjId <> ObjId then
  begin

  end;
  //
  case Op of
    rowInsert:
      begin
        memBrowser2.Append;
        memBrowser2.FieldByName(SF_ID).AsInteger := ObjId;
        memBrowser2.Post;
        RefreshCurrentRow();
      end;
    rowUpdate: 
      begin
        RefreshCurrentRow();
      end;
    rowDelete:
      begin
        memBrowser2.Delete;
      end;
  end;
end;

procedure TmstMPBrowserForm.RefreshCurrentRow;
var
  ObjId: Integer;
begin
  ObjId := memBrowser2.FieldByName(SF_ID).AsInteger;
  FObjList.RefreshBrowseDataSetRow(ObjId, memBrowser2);
end;

procedure TmstMPBrowserForm.RefreshDataSet;
var
  SaveGUI: Boolean;
  ObjId: Integer;
begin
  ObjId := memBrowser2.FieldByName(SF_ID).AsInteger;
  SaveGUI := memBrowser2.Active;
  if SaveGUI then
    memBrowser2.DisableControls;
  try
    memBrowser2.LoadFromDataSet(FObjList.BrowserDataSet(), 0, lmCopy);
    DataSource1.DataSet := memBrowser2;
    memBrowser2.Active := True;
  finally
    if SaveGUI then
    begin
      if not memBrowser2.Locate(SF_ID, ObjId, []) then
        memBrowser2.First;
      memBrowser2.EnableControls;
    end;
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

procedure TmstMPBrowserForm.SetFastSearchCol(aCol: TColumn);
begin
  FFastSearchColName := aCol.FieldName;
  edFastSearchCol.Text := aCol.Title.Caption;
end;

procedure TmstMPBrowserForm.ShowFilterDialog;
begin
  if mstMPBrowserFilterDialog = nil then
    mstMPBrowserFilterDialog := TmstMPBrowserFilterDialog.Create(Application);
  if mstMPBrowserFilterDialog.Execute(FFilter) then
    ApplyFilter();
end;

procedure TmstMPBrowserForm.trackAlphaChange(Sender: TObject);
begin
  Self.AlphaBlendValue := trackAlpha.Position;
end;

end.
