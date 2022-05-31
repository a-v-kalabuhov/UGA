unit uKisMapScanEditor;

{$I KisFlags.pas}

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms, Buttons, ActnList, Math,
  Dialogs, StdCtrls, Grids, DBGrids, ComCtrls, DB, Menus, Clipbrd, ExtCtrls, ExtDlgs, Word2000, Printers,
  ATImageBox, ATPrintPreview, ATxPrintProc,
  JvBaseDlg, JvDesktopAlert, JvExControls, JvArrowButton,
  FR_Class,
  uDBGrid, uCommonUtils, uGC, uGraphics, uAutoCAD,
  uKisClasses, uKisMapPrint,
  uKisIntf, uKisMapScanIntf, uKisExceptions, uKisEntityEditor, uKisScanHistoryFiles, uKisPrintModule,
  uKisImagesViewFactory;

type
  TKisMapHistoryRecordState = (
    mhNone, // нет истории
    mhInitialUpload, // первоначальная загрузка
    mhChanged, // планшет был принят с областью изменений
    mhNoChanges, // планшет принят без изменений
    mhNoReturn, // планшет выдан без возвраат - заявка сразу закрыта, как без изменений
    mhReplaced // планшет был принят целиком - полностью перезаписан
  );

  TKisMapScanEditor = class(TKisEntityEditor)
    dsGiveOuts: TDataSource;
    Label1: TLabel;
    edNomenclature: TEdit;
    edNom2: TEdit;
    edNom3: TEdit;
    Label2: TLabel;
    edMD5: TEdit;
    PopupMenu1: TPopupMenu;
    miCopyMD5: TMenuItem;
    Label3: TLabel;
    edStartDate: TEdit;
    PageControl1: TPageControl;
    tabHistor: TTabSheet;
    TabSheet2: TTabSheet;
    dbgGivenMapList: TkaDBGrid;
    btnShowChanges: TButton;
    Panel1: TPanel;
    Panel2: TPanel;
    Label4: TLabel;
    LabelScale: TLabel;
    TrackBar1: TTrackBar;
    chkFit: TCheckBox;
    Box: TATImageBox;
    btnLoadHistoryImage: TButton;
    OpenPictureDialog1: TOpenPictureDialog;
    tabHistory: TTabSheet;
    Panel3: TPanel;
    dbgHistoryList: TDBGrid;
    btnAddHistory: TButton;
    btnDeleteHistory: TButton;
    btnEditHistory: TButton;
    Panel4: TPanel;
    pbPreview: TPaintBox;
    dsMapHistory: TDataSource;
    btnPrintHistory: TBitBtn;
    btnAddGiveOutToHistory: TButton;
    btnSaveHistoryFile: TButton;
    SaveDialog1: TSaveDialog;
    btnViewHistoryImage: TBitBtn;
    pmFormularView: TPopupMenu;
    N1: TMenuItem;
    N2: TMenuItem;
    N3: TMenuItem;
    pmSaveImage: TPopupMenu;
    MenuItem1: TMenuItem;
    MenuItem2: TMenuItem;
    MenuItem3: TMenuItem;
    ActionList1: TActionList;
    acSaveDiffZone: TAction;
    acSaveMapNew: TAction;
    acSaveMapOld: TAction;
    SaveDialog2: TSaveDialog;
    btnSaveHistoryImage: TBitBtn;
    acViewMapOld: TAction;
    acViewMapNew: TAction;
    acViewDiffZone: TAction;
    acFormularToWord: TAction;
    N4: TMenuItem;
    Word1: TMenuItem;
    acViewMapHistory: TAction;
    N5: TMenuItem;
    N6: TMenuItem;
    btnPrintMap: TButton;
    procedure btnDeleteGivenMapClick(Sender: TObject);
    procedure btnGiveCalcClick(Sender: TObject);
    procedure dbgGivenMapListExit(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormShow(Sender: TObject);
    procedure edNomenclatureKeyPress(Sender: TObject; var Key: Char);
    procedure edNom2KeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure edNomenclatureKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure edNom2KeyPress(Sender: TObject; var Key: Char);
    procedure edNom3KeyPress(Sender: TObject; var Key: Char);
    procedure edMD5Enter(Sender: TObject);
    procedure miCopyMD5Click(Sender: TObject);
    procedure chkFitClick(Sender: TObject);
    procedure TrackBar1Change(Sender: TObject);
    procedure btnLoadHistoryImageClick(Sender: TObject);
    procedure btnShowChangesClick(Sender: TObject);
    procedure btnAddHistoryClick(Sender: TObject);
    procedure btnDeleteHistoryClick(Sender: TObject);
    procedure dbgHistoryListExit(Sender: TObject);
    procedure dsMapHistoryStateChange(Sender: TObject);
    procedure tabHistoryShow(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure btnAddGiveOutToHistoryClick(Sender: TObject);
    procedure btnSaveHistoryFileClick(Sender: TObject);
    procedure dbgHistoryListDblClick(Sender: TObject);
    procedure dbgGivenMapListCellColors(Sender: TObject; Field: TField;
      var Background, FontColor: TColor; State: TGridDrawState;
      var FontStyle: TFontStyles);
    procedure dbgGivenMapListDblClick(Sender: TObject);
    procedure acSaveDiffZoneExecute(Sender: TObject);
    procedure acSaveDiffZoneUpdate(Sender: TObject);
    procedure acSaveMapNewExecute(Sender: TObject);
    procedure acSaveMapOldExecute(Sender: TObject);
    procedure btnSaveHistoryImageClick(Sender: TObject);
    procedure btnViewHistoryImageClick(Sender: TObject);
    procedure acViewDiffZoneUpdate(Sender: TObject);
    procedure acViewDiffZoneExecute(Sender: TObject);
    procedure acViewMapNewExecute(Sender: TObject);
    procedure acViewMapOldExecute(Sender: TObject);
    procedure btnPrintHistoryClick(Sender: TObject);
    procedure acFormularToWordUpdate(Sender: TObject);
    procedure acFormularToWordExecute(Sender: TObject);
    procedure acViewMapHistoryExecute(Sender: TObject);
    procedure btnPrintMapClick(Sender: TObject);
  private
    FUpdatingSelfOptions: Boolean;
    FHistoryImageChanged: Boolean;
    FHistoryImageLoaded: Boolean;
    FHistoryImageFile: string;
    FScanHistory: TKisScanHistoryFiles;
    FScanHistoryPrepared: Boolean;
    procedure PrepareScanHistory();
    procedure UpdateImageScaleOptions;
    procedure UpdateSelfOptions;
    procedure UpdateSelfScaleOptions;
    function GetHistoryImage: TPicture;
    procedure LoadHistoryImage(const aFileName: string);
    procedure SetHistoryImageFile(const Value: string);
    function FormularGetCurrentFileOpId(): string;
    function GetCurrFormularOperationFile(const ItemKind: TFileOperationItemKind): TFileOperationItem;
    function GetFormularOperationFile(const FileOpId: string; const ItemKind: TFileOperationItemKind): TFileOperationItem;
    procedure SaveOperationItem(OpFile: TFileOperationItem; const aTitle: string);
    function SaveOperationItemToTempFile(OpFile: TFileOperationItem): string;
    procedure ViewOperationItem(OpFile: TFileOperationItem; const aTitle: string);
    function GetHistoryImageForPrint(): TBitmap;
    procedure PrepareFormularWordDoc(ImgFiles: TStrings);
    function SaveImageForWord(MapHistElem: TKisEntity): string;
    procedure ViewCurrentHistoryImages();
    procedure PrintMap(Bmp: TBitmap);
    procedure PrintMap2(Bmp: TBitmap);
  public
    property HistoryImage: TPicture read GetHistoryImage;
    /// <summary>
    /// Загрузили новую картинку формуляра.
    /// </summary>
    property HistoryImageChanged: Boolean read FHistoryImageChanged;
    //
    property HistoryImageFile: string read FHistoryImageFile write SetHistoryImageFile;
  end;

implementation

{$R *.dfm}

uses
  uFileUtils,
  uKisAppModule, uKisConsts, uMapScanFiles, uKisImageViewer, uKisMapScans;

procedure TKisMapScanEditor.btnAddHistoryClick(Sender: TObject);
begin
  inherited;
  dbgHistoryList.DataSource.DataSet.Append;
end;

procedure TKisMapScanEditor.btnDeleteGivenMapClick(Sender: TObject);
begin
  inherited;
  if not dbgGivenMapList.DataSource.DataSet.IsEmpty then
     dbgGivenMapList.DataSource.DataSet.Delete;
end;

procedure TKisMapScanEditor.btnDeleteHistoryClick(Sender: TObject);
begin
  inherited;
  if not dbgHistoryList.DataSource.DataSet.IsEmpty then
     dbgHistoryList.DataSource.DataSet.Delete;
end;

procedure TKisMapScanEditor.btnGiveCalcClick(Sender: TObject);
begin
  inherited;
  if not dbgGivenMapList.DataSource.DataSet.IsEmpty then
    dbgGivenMapList.DataSource.DataSet.Edit;
end;

procedure TKisMapScanEditor.btnLoadHistoryImageClick(Sender: TObject);
begin
  inherited;
  if OpenPictureDialog1.Execute(Handle) then
  begin
    LoadHistoryImage(OpenPictureDialog1.Files[0]);
    FHistoryImageChanged := True;
  end;
end;

procedure TKisMapScanEditor.btnPrintHistoryClick(Sender: TObject);
var
  Scan: TKisMapScan;
  ReportFileName, Cd: string;
  MapPicture: TfrPictureView;
  MapHistElem: TKisMapScanHistoryElement;
  TheMetafile: TMetafile;
  TheImage: TBitmap;
begin
  // Здесь показываем редактор истории планшета
  if dsMapHistory.DataSet.IsEmpty then
    Exit;
  //
  Scan := TKisMapScan(Entity);
  MapHistElem := Scan.GetHistoryElement(dsMapHistory.DataSet.RecNo);

//  ReportFileName := TPath.Build(AppModule.ReportsPath, 'КГО').Finish('Формуляр_скан.frf').Path();
  ReportFileName := TPath.Finish(AppModule.ReportsPath, 'Формуляр_скан2.frf');
  Cd := GetCurrentDir;
  SetCurrentDir(ExtractFilePath(Application.ExeName));
  ReportFileName := ExpandFileName(ReportFileName);
  SetCurrentDir(Cd);
  with PrintModule do
  begin
    frReport.LoadFromFile(ReportFileName);
    //
    MapPicture := frReport.FindObject('MapPicture') as TfrPictureView;
    if Assigned(MapPicture) then
    begin
      TheImage := GetHistoryImageForPrint();
      if Assigned(TheImage) then
      begin
        TheImage.Forget();
        MapPicture.Picture.Graphic := TheImage
      end
      else
      begin
        TheMetafile := MapHistElem.PrepareMetafile(MapPicture.dx, True);
        TheMetafile.Forget;
        MapPicture.Picture.Graphic := TheMetafile;
      end;
    end;
    //
    SetParamValue('NOMENCLATURE', Scan.Nomenclature);
    SetParamValue('REC_NO', dsMapHistory.DataSet.RecNo);
    SetParamValue('ORDER_NUMBER', dsMapHistory.DataSet.FieldByName(SF_ORDER_NUMBER).AsString);
    SetParamValue('ORG_NAME', MapHistElem.Chief);
    SetParamValue('WORK_DATE', MapHistElem.DateOfWorks);
    SetParamValue('ADDRESS', MapHistElem.MensMapping);
    SetParamValue('AREA', MapHistElem.TotalSum);
    SetParamValue('DEFINITION_NUMBER', MapHistElem.OrderNumber);
    SetParamValue('NET_SURVEY', MapHistElem.EnginNetMapping);
    SetParamValue('EXECUTOR', MapHistElem.WorksExecutor);
    //
    frReport.ShowReport;
  end;
  //
  if Assigned(dsMapHistory.DataSet)
     and
     Assigned(dsMapHistory.DataSet.AfterScroll)
  then
    dsMapHistory.DataSet.AfterScroll(dsMapHistory.DataSet);
end;

procedure TKisMapScanEditor.btnPrintMapClick(Sender: TObject);
var
  ImgFile: string;
  TmpFile, ImgTmpFile: string;
  ImgExt: string;
  Bmp: TBitmap;
  Scan: TKisMapScan;
  Vector: Boolean;
begin
  Scan := TKisMapScan(Entity);
  Vector := theMapScansStorage.HasVectorFile(AppModule, Scan.Nomenclature);
  if Vector then
    ImgFile := theMapScansStorage.GetFileName(AppModule, Scan.Nomenclature, sfnVector)
  else
    ImgFile := theMapScansStorage.GetFileName(AppModule, Scan.Nomenclature, sfnRaster);
  //
  if (ImgFile = '') or not FileExists(ImgFile) then
    raise EKisException.Create('Файл планшета ' + Scan.Nomenclature + ' не обнаружен!');
  //
  TmpFile := TFileUtils.CreateTempFile(AppModule.AppTempPath);
  try
    ImgExt := ExtractFileExt(ImgFile);
    ImgTmpFile := ChangeFileExt(TmpFile, ImgExt);
    TFileUtils.RenameFile(TmpFile, ImgTmpFile);
    TFileUtils.CopyFile(ImgFile, ImgTmpFile);
    if Vector then
      Bmp := TAutoCADUtils.ExportToBitmap(ImgTmpFile, SZ_MAP_PX, SZ_MAP_PX)
    else
      Bmp := TBitmap.CreateFromFile(ImgTmpFile);
    Bmp.Forget();
    //PrintMap(Bmp);
    PrintMap2(Bmp);
  finally
    TFileUtils.DeleteFile(ImgTmpFile);
    TFileUtils.DeleteFile(TmpFile);
  end;
end;

procedure TKisMapScanEditor.btnSaveHistoryFileClick(Sender: TObject);
var
  Ext: string;
begin
  inherited;
  if FileExists(FHistoryImageFile) then
  begin
    Ext := ExtractFileExt(FHistoryImageFile);
    SaveDialog1.DefaultExt := Ext;
    SaveDialog1.Filter := 'Файлы изображений (*' + Ext + ')|*' + Ext;
    if SaveDialog1.Execute(Handle) then
      TFileUtils.CopyFile(FHistoryImageFile, SaveDialog1.Files[0], True);
  end;
end;

procedure TKisMapScanEditor.btnShowChangesClick(Sender: TObject);
begin
  inherited;
  if dsGiveOuts.DataSet.IsEmpty then
    Exit;
  if not FScanHistoryPrepared then
    PrepareScanHistory();
  ViewCurrentHistoryImages();
end;

procedure TKisMapScanEditor.acFormularToWordExecute(Sender: TObject);
var
  Scan: TKisMapScan;
  MapHistElem: TKisMapScanHistoryElement;
  I: Integer;
  ImgFile: string;
  ImgFiles: TStringList;
begin
  inherited;
  Scan := TKisMapScan(Entity);
  ImgFiles := TStringList.Create;
  ImgFiles.Forget();
  try
    for I := 1 to dsMapHistory.DataSet.RecordCount do
    begin
      MapHistElem := Scan.GetHistoryElement(I);
      ImgFile := SaveImageForWord(MapHistElem);
      if FileExists(ImgFile) then
        ImgFiles.AddObject(ImgFile, MapHistElem);
    end;
    PrepareFormularWordDoc(ImgFiles);
  finally
    for I := 0 to ImgFiles.Count - 1 do
      TFileUtils.DeleteFile(ImgFiles[I]);
  end;
end;

procedure TKisMapScanEditor.acFormularToWordUpdate(Sender: TObject);
begin
  inherited;
  acFormularToWord.Enabled := dsMapHistory.DataSet.Active and not dsMapHistory.DataSet.IsEmpty;
end;

procedure TKisMapScanEditor.acSaveDiffZoneExecute(Sender: TObject);
var
  OpFile: TFileOperationItem;
begin
  inherited;
  OpFile := GetCurrFormularOperationFile(fileDiffZone);
  if not OpFile.HasImage() then
  begin
    raise EKisException.Create(
      'Изображение области изменений не найдено!' + sLineBreak +
      'Файл: ' + OpFile.FileName
    );
  end;
  SaveOperationItem(OpFile, 'Сохраняем область изменений');
  ShowMessage('Файл сохранён.');
end;

procedure TKisMapScanEditor.acSaveDiffZoneUpdate(Sender: TObject);
var
  FileOpId: string;
  Op: TFileOperation;
  B: Boolean;
begin
  inherited;
  if not FScanHistoryPrepared then
    PrepareScanHistory();
  // получаем данные о файлах в нужной нам операции
  FileOpId := FormularGetCurrentFileOpId();
  Op := FScanHistory.Operation(FileOpId);
  B := Assigned(Op) and (Op.Kind <> fileopInitialUpload);
  acSaveDiffZone.Enabled := B;
  acSaveMapOld.Enabled := B;
  B := Assigned(Op);
  acSaveMapNew.Enabled := B;
end;

function TKisMapScanEditor.GetCurrFormularOperationFile(const ItemKind: TFileOperationItemKind): TFileOperationItem;
var
  FileOpId: string;
begin
  if not FScanHistoryPrepared then
    PrepareScanHistory();
  // получаем данные о файлах в нужной нам операции
  FileOpId := FormularGetCurrentFileOpId();
  Result := GetFormularOperationFile(FileOpId, ItemKind);
end;

function TKisMapScanEditor.GetFormularOperationFile(const FileOpId: string; const ItemKind: TFileOperationItemKind): TFileOperationItem;
var
  Op: TFileOperation;
begin
  if not FScanHistoryPrepared then
    PrepareScanHistory();
  Op := FScanHistory.Operation(FileOpId);
  if not Assigned(Op) then
  begin
    raise EKisException.Create(
      'Пакет файлов для операции с индексом [' + FileOpId + '] не найден!'
    );
  end;
  //
  if (ItemKind = fileDiffZone) and (Op.Kind = fileopInitialUpload) then
  begin
    raise EKisException.Create(
      'Для первой загрузки планшета не может быть области изменений!' + sLineBreak + 'Код: ' + FileOpid
    );
  end;

  Result := Op.GetFile(ItemKind);
end;

procedure TKisMapScanEditor.acSaveMapNewExecute(Sender: TObject);
var
  OpFile: TFileOperationItem;
begin
  inherited;
  OpFile := GetCurrFormularOperationFile(fileResult);
  if not OpFile.HasImage() then
  begin
    raise EKisException.Create(
      'Изображение принятого планшета не найдено!' + sLineBreak +
      'Файл: ' + OpFile.FileName
    );
  end;
  SaveOperationItem(OpFile, 'Сохраняем принятый планшет');
  ShowMessage('Файл сохранён.');
end;

procedure TKisMapScanEditor.acSaveMapOldExecute(Sender: TObject);
var
  OpFile: TFileOperationItem;
begin
  inherited;
  OpFile := GetCurrFormularOperationFile(fileSource);
  if not OpFile.HasImage() then
  begin
    raise EKisException.Create(
      'Изображение исходного планшета не найдено!' + sLineBreak +
      'Файл: ' + OpFile.FileName
    );
  end;
  SaveOperationItem(OpFile, 'Сохраняем исходный планшет');
  ShowMessage('Файл сохранён.');
end;

procedure TKisMapScanEditor.acViewDiffZoneExecute(Sender: TObject);
var
  OpFile: TFileOperationItem;
  aTitle: string;
begin
  inherited;
  OpFile := GetCurrFormularOperationFile(fileDiffZone);
  if not OpFile.HasImage() then
  begin
    raise EKisException.Create(
      'Изображение области изменений не найдено!' + sLineBreak +
      'Файл: ' + OpFile.FileName
    );
  end;
  aTitle := TKisMapScan(Entity).Nomenclature;
  aTitle := aTitle + ': Область изменений от ';
  aTitle := aTitle + dsMapHistory.DataSet.FieldByName(SF_DATE_OF_WORKS).AsString;
  ViewOperationItem(OpFile, aTitle);
end;

procedure TKisMapScanEditor.acViewDiffZoneUpdate(Sender: TObject);
var
  FileOpId: string;
  Op: TFileOperation;
  B: Boolean;
begin
  inherited;
  if not FScanHistoryPrepared then
    PrepareScanHistory();
  // получаем данные о файлах в нужной нам операции
  FileOpId := FormularGetCurrentFileOpId();
  Op := FScanHistory.Operation(FileOpId);
  B := Assigned(Op) and (Op.Kind <> fileopInitialUpload);
  acViewDiffZone.Enabled := B;
  acViewMapOld.Enabled := B;
  B := Assigned(Op);
  acViewMapNew.Enabled := B;
  acViewMapHistory.Enabled := B;
end;

procedure TKisMapScanEditor.acViewMapHistoryExecute(Sender: TObject);
var
  Viewer: IKisImagesView;
  OpFileRes, OpFileSrc, OpFileDiff: TFileOperationItem;
  aTitle: string;
  I: Integer;
  FileOpId: string;
  HasDiff: Boolean;
  aFileName: string;
  Files: TStringList;
begin
  inherited;
  Viewer := TKisImagesViewFactory.CreateViewer();
  I := 0;
  OpFileRes := GetCurrFormularOperationFile(fileResult);
  if Assigned(OpFileRes) and OpFileRes.HasImage() then
    Inc(I);
  OpFileSrc := GetCurrFormularOperationFile(fileSource);
  if Assigned(OpFileSrc) and OpFileSrc.HasImage() then
    Inc(I);
  HasDiff := False;
  OpFileDiff := GetCurrFormularOperationFile(fileDiffZone);
  if Assigned(OpFileDiff) and OpFileDiff.HasImage() then
  begin
    Inc(I);
    HasDiff := True;
  end;
  if I = 0 then
  begin
    FileOpId := FormularGetCurrentFileOpId();
    raise EKisException.Create(
      'Файлы изображений не найдены!' + sLineBreak +
      'Код операции: ' + FileOpId
    );
  end;
  //
  Files := TStringList.Create;
  Files.Forget();
  try
    if Assigned(OpFileSrc) and OpFileSrc.HasImage() then
    begin
      aFileName := SaveOperationItemToTempFile(OpFileSrc);
      Files.Add(aFileName);
      Viewer.AddImage(aFileName, 'Source', 'Оригинальный планшет', Rect(0, 0, 250, 250));
    end;
    if HasDiff then
    begin
      aFileName := SaveOperationItemToTempFile(OpFileDiff);
      Files.Add(aFileName);
      Viewer.AddImage(aFileName, 'Diff', 'Область изменений', Rect(0, 0, 250, 250));
    end;
    if Assigned(OpFileRes) and OpFileRes.HasImage() then
    begin
      aFileName := SaveOperationItemToTempFile(OpFileRes);
      Files.Add(aFileName);
      Viewer.AddImage(aFileName, 'Result', 'Принятый планшет', Rect(0, 0, 250, 250));
    end;
    //
    aTitle := TKisMapScan(Entity).Nomenclature;
    aTitle := aTitle + ': Изменения от ';
    aTitle := aTitle + dsMapHistory.DataSet.FieldByName(SF_DATE_OF_WORKS).AsString;
    Viewer.Execute(AppModule, aTitle, IfThen(HasDiff, 1, 0));
  finally
    for I := 0 to Files.Count - 1 do
      TFileUtils.DeleteFile(FIles[I]);
  end;
end;

procedure TKisMapScanEditor.acViewMapNewExecute(Sender: TObject);
var
  OpFile: TFileOperationItem;
  aTitle: string;
begin
  inherited;
  OpFile := GetCurrFormularOperationFile(fileResult);
  if not OpFile.HasImage() then
  begin
    raise EKisException.Create(
      'Изображение планшета не найдено!' + sLineBreak +
      'Файл: ' + OpFile.FileName
    );
  end;
  aTitle := TKisMapScan(Entity).Nomenclature;
  aTitle := aTitle + ': Принятый планшет от ';
  aTitle := aTitle + dsMapHistory.DataSet.FieldByName(SF_DATE_OF_WORKS).AsString;
  ViewOperationItem(OpFile, aTitle);
end;

procedure TKisMapScanEditor.acViewMapOldExecute(Sender: TObject);
var
  OpFile: TFileOperationItem;
  aTitle: string;
begin
  inherited;
  OpFile := GetCurrFormularOperationFile(fileSource);
  if not OpFile.HasImage() then
  begin
    raise EKisException.Create(
      'Изображение планшета не найдено!' + sLineBreak +
      'Файл: ' + OpFile.FileName
    );
  end;
  aTitle := TKisMapScan(Entity).Nomenclature;
  aTitle := aTitle + ': Выданный планшет от ';
  aTitle := aTitle + dsMapHistory.DataSet.FieldByName(SF_DATE_OF_WORKS).AsString;
  ViewOperationItem(OpFile, aTitle);
end;

procedure TKisMapScanEditor.btnSaveHistoryImageClick(Sender: TObject);
var
  Pt: TPoint;
begin
  inherited;
  if not dsMapHistory.DataSet.Active then
    Exit;
  if dsMapHistory.DataSet.IsEmpty then
    Exit;
  Pt.X := 0;
  Pt.Y := btnSaveHistoryImage.Height;
  Pt := btnSaveHistoryImage.ClientToScreen(Pt);
  pmSaveImage.Popup(Pt.X, Pt.Y);
end;

procedure TKisMapScanEditor.btnAddGiveOutToHistoryClick(Sender: TObject);
begin
  inherited;
  if Assigned(dbgGivenMapList.DataSource.DataSet) then
    if dbgGivenMapList.DataSource.DataSet.Active then
      if not dbgGivenMapList.DataSource.DataSet.IsEmpty then
      begin
        TKisMapScan(Entity).UseGiveOutForMapHistory := True;
        try
          dbgHistoryList.DataSource.DataSet.Append;
        finally
          TKisMapScan(Entity).UseGiveOutForMapHistory := False;
        end;
      end;
end;

procedure TKisMapScanEditor.chkFitClick(Sender: TObject);
begin
  inherited;
  Box.ImageFitToWindow := chkFit.Checked;
end;

procedure TKisMapScanEditor.dbgGivenMapListCellColors(Sender: TObject;
  Field: TField; var Background, FontColor: TColor; State: TGridDrawState;
  var FontStyle: TFontStyles);
var
  Ds: TDataSet;
begin
  inherited;
  if (gdSelected in State) or (gdFocused in State) then
  begin
    Background := clHighlight;
    FontColor := clWindow;
  end
  else
  begin
    Ds := Field.DataSet;
    if Ds.FieldByName(SF_ANNULLED).AsBoolean then
      Background := clSilver
    else
    if Ds.FieldByName(SF_EXPIRED).AsBoolean then
      Background := $9999FF
    else
    if Ds.FieldByName(SF_DATE_OF_BACK).AsString <> '' then
    begin
      if Ds.FieldByName(SF_MD5_NEW).AsString <> Ds.FieldByName(SF_MD5_OLD).AsString then
        Background := $CCFFCC;
    end;
  end;
end;

procedure TKisMapScanEditor.dbgGivenMapListDblClick(Sender: TObject);
var
  Pt: TPoint;
  XY: TGridCoord;
begin
  inherited;
  Pt := Mouse.CursorPos;
  Pt := dbgGivenMapList.ScreenToClient(Pt);
  XY := dbgGivenMapList.MouseCoord(Pt.X, Pt.Y);
  if XY.Y > 0 then
    btnShowChanges.Click();
end;

procedure TKisMapScanEditor.dbgGivenMapListExit(Sender: TObject);
begin
  inherited;
  if dbgGivenMapList.DataSource.DataSet.State in [dsEdit, dsInsert] then
    dbgGivenMapList.DataSource.DataSet.Post;
end;

procedure TKisMapScanEditor.dbgHistoryListDblClick(Sender: TObject);
begin
  inherited;
  if btnEditHistory.Enabled then
    btnEditHistory.Click;
end;

procedure TKisMapScanEditor.dbgHistoryListExit(Sender: TObject);
begin
  inherited;
  if dbgHistoryList.DataSource.DataSet.State in [dsEdit, dsInsert] then
    dbgHistoryList.DataSource.DataSet.Post;
end;

procedure TKisMapScanEditor.dsMapHistoryStateChange(Sender: TObject);
begin
  inherited;
  if Assigned(dsMapHistory.DataSet) then
  if Assigned(dsMapHistory.DataSet.AfterScroll) then
    dsMapHistory.DataSet.AfterScroll(dsMapHistory.DataSet);
end;

procedure TKisMapScanEditor.FormActivate(Sender: TObject);
begin
  inherited;
  if Assigned(dsMapHistory.DataSet)
     and
     Assigned(dsMapHistory.DataSet.AfterScroll)
  then
    dsMapHistory.DataSet.AfterScroll(dsMapHistory.DataSet);
end;

procedure TKisMapScanEditor.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  inherited;
  AppModule.WriteGridProperties(Self, dbgGivenMapList);
  FScanHistoryPrepared := False;
  FreeAndNil(FScanHistory);
end;

procedure TKisMapScanEditor.FormShow(Sender: TObject);
begin
  inherited;
  AppModule.ReadGridProperties(Self, dbgGivenMapList);
  PageControl1.ActivePageIndex := 0;
end;

function TKisMapScanEditor.FormularGetCurrentFileOpId: string;
begin
  Result := TKisMapScan(Entity).MapHistory.FieldByName(SF_FILE_OPERATION_ID).AsString;
end;

function TKisMapScanEditor.GetHistoryImage: TPicture;
begin
  if FHistoryImageLoaded then
    Result := Box.Image.Picture
  else
    Result := nil;
end;

function TKisMapScanEditor.GetHistoryImageForPrint(): TBitmap;
var
  OpFile: TFileOperationItem;
  ImgFile: string;
  ImgExt: string;
  TmpFile: string;
  ImgTmpFile: string;
begin
  inherited;
  Result := nil;
  OpFile := GetCurrFormularOperationFile(fileDiffZone);
  if OpFile.HasImage() then
  begin
    ImgFile := OpFile.GetSaveImageFileName();
    ImgExt := ExtractFileExt(ImgFile);
    TmpFile := TFileUtils.CreateTempFile(AppModule.AppTempPath);
    try
      ImgTmpFile := ChangeFileExt(TmpFile, ImgExt);
      TFileUtils.RenameFile(TmpFile, ImgTmpFile);
      OpFile.SaveImage(ImgTmpFile);
      if TMapScanStorage.FileIsVector(ImgTmpFile) then
        Result := TAutoCADUtils.ExportToBitmap(ImgTmpFile, SZ_MAP_PX, SZ_MAP_PX)
      else
        Result := TBitmap.CreateFromFile(ImgTmpFile);
      Result.Canvas.Pen.Style := psSolid;
      Result.Canvas.Pen.Color := clBlack;
      Result.Canvas.Pen.Width := 10;
      Result.Canvas.DrawCrosses(Result.Height, Result.Width);
    finally
      TFileUtils.DeleteFile(ImgTmpFile);
      TFileUtils.DeleteFile(TmpFile);
    end;
  end;
end;

procedure TKisMapScanEditor.btnViewHistoryImageClick(Sender: TObject);
var
  Pt: TPoint;
begin
  inherited;
  if not dsMapHistory.DataSet.Active then
    Exit;
  if dsMapHistory.DataSet.IsEmpty then
    Exit;
  Pt.X := 0;
  Pt.Y := btnViewHistoryImage.Height;
  Pt := btnViewHistoryImage.ClientToScreen(Pt);
  pmFormularView.Popup(Pt.X, Pt.Y);
end;

procedure TKisMapScanEditor.LoadHistoryImage(const aFileName: string);
begin
  try
    Box.Image.Picture.LoadFromFile(aFileName);
  finally
    Box.UpdateImageInfo;
    UpdateSelfScaleOptions;
  end;
  FHistoryImageFile := aFileName;
  FHistoryImageLoaded := True;
end;

procedure TKisMapScanEditor.miCopyMD5Click(Sender: TObject);
begin
  inherited;
  if edMD5.Text <> '' then
  begin
    Clipboard.Open;
    try
      Clipboard.AsText := edMD5.Text;
    finally
      Clipboard.Close;
    end;
  end;
end;

procedure TKisMapScanEditor.PrepareFormularWordDoc(ImgFiles: TStrings);
var
  WordApp: TWordApplication;

  procedure SetVariable(aName, aValue: string);
  var
    Found: WordBool;
    V1, V2: OleVariant;
  begin
    aName := '[' + aName + ']';
    WordApp.Selection.End_ := 0;
    WordApp.Selection.Start := 0;
    WordApp.Selection.Find.Forward := True;
    WordApp.Selection.Find.Text := aName;
    V1 := aName;
    V2 := True;
    Found := WordApp.Selection.Find.Execute(
        V1, EmptyParam, EmptyParam, EmptyParam,
        EmptyParam, EmptyParam,
        V2, EmptyParam, EmptyParam,
        EmptyParam, EmptyParam,
        EmptyParam, EmptyParam,
        EmptyParam, EmptyParam);
//    while WordApp.Selection.Find.Execute do
    while Found do    
    begin
      if aValue = '' then      
        WordApp.Selection.Delete(EmptyParam, EmptyParam)
      else
        WordApp.Selection.TypeText(aValue);
      WordApp.Selection.End_ := 0;
      WordApp.Selection.Start := 0;
      Found := WordApp.Selection.Find.Execute(
          V1, EmptyParam, EmptyParam, EmptyParam,
          EmptyParam, EmptyParam,
          V2, EmptyParam, EmptyParam,
          EmptyParam, EmptyParam,
          EmptyParam, EmptyParam,
          EmptyParam, EmptyParam);
    end;

//    aRange.Find.ClearFormatting();
//    WordApp.Selection.Find.Execute(
//        Text = aName,
//        ReplaceWith = aValue,
//        Forward_ = True,
//        Wrap = wdFindAsk,
//        Format = False,
//        MatchCase = False,
//        MatchWholeWord = False,
//        MatchWildcards = False,
//        MatchSoundsLike = False,
//        MatchAllWordForms = False
//    );
  end;

  procedure LoadImage(const aVarName, ImgFile: string);
  var
    Found: WordBool;
    V1, V2: OleVariant;
  begin
    WordApp.Selection.End_ := 0;
    WordApp.Selection.Start := 0;
    WordApp.Selection.Find.Forward := True;
    WordApp.Selection.Find.Text := '[' + aVarName + ']';
    V1 := '[' + aVarName + ']';
    V2 := True;
    Found := WordApp.Selection.Find.Execute(
        V1, EmptyParam, EmptyParam, EmptyParam,
        EmptyParam, EmptyParam,
        V2, EmptyParam, EmptyParam,
        EmptyParam, EmptyParam,
        EmptyParam, EmptyParam,
        EmptyParam, EmptyParam);
    if Found then
    begin
      V1 := False;
      V2 := True;
      WordApp.Selection.InlineShapes.AddPicture(ImgFile, V1, V2, EmptyParam);
      WordApp.Selection.End_ := 0;
      WordApp.Selection.Start := 0;
    end;
  end;

var
  TemplateFileName: string;
  V: OleVariant;
  TemplateDoc: WordDocument;
  ReportDoc: WordDocument;
  Scan: TKisMapScan;
  MapHistElem: TKisMapScanHistoryElement;
  I: Integer;
  ImgFile: string;
begin
  if ImgFiles.Count = 0 then
    raise EKisException.Create('Нет изображений для формуляра!');
  // перед началом предлагаем сменить цвет фона с 127, 0, 127 на любой другой
  // полученный цвет запоминаем

  Scan := TKisMapScan(Entity);
  // ищем вордовский файл с шаблоном
  TemplateFileName := TPath.Finish(AppModule.ReportsPath, 'ФОРМУЛЯР ПЛАНШЕТА.doc');
  if not FileExists(TemplateFileName) then
    raise EFile.Create('Файл не найден!', 'ФОРМУЛЯР ПЛАНШЕТА.doc');
  // Открываем его
  WordApp := TWordApplication.Create(Self);
  try
    WordApp.Connect();
    //WordApp.Visible := True;
    WordApp.Visible := False;
    V := TemplateFileName;
    TemplateDoc := WordApp.Documents.Open(
            V,
            EmptyParam, EmptyParam, EmptyParam, EmptyParam, EmptyParam, EmptyParam,
            EmptyParam, EmptyParam, EmptyParam, EmptyParam, EmptyParam);
    WordApp.Selection.WholeStory();
    WordApp.Selection.Copy();
    // Создаём новый вордовский документ
    // В этот документ вставляем всё, что есть в шаблоне
    // Заполняем поля
    // подготавливаем картинку
    // вставляем картинку
    // добавляем новую страницу
    // на новую страницу вставляем всё что было в шаблоне
    // повторяем по кругу
    ReportDoc := WordApp.Documents.Add(EmptyParam, EmptyParam, EmptyParam, EmptyParam);
    ReportDoc.Activate;
    for I := 0 to ImgFiles.Count - 1 do
    begin
      WordApp.Selection.Paste();
      ImgFile := ImgFiles[I];
      MapHistElem := TKisMapScanHistoryElement(ImgFiles.Objects[I]);
      SetVariable('NOMENCLATURE', Scan.Nomenclature);
      SetVariable('ORG_NAME', MapHistElem.Chief);
      SetVariable('WORK_DATE', MapHistElem.DateOfWorks);
      SetVariable('ADDRESS', MapHistElem.MensMapping);
      SetVariable('AREA', MapHistElem.TotalSum);
      SetVariable('DEFINITION_NUMBER', MapHistElem.OrderNumber);
      SetVariable('NET_SURVEY', MapHistElem.EnginNetMapping);
      SetVariable('EXECUTOR', MapHistElem.WorksExecutor);
      LoadImage('IMAGE', ImgFile);
      if (I + 1 < ImgFiles.Count) then
      begin
        WordApp.Selection.WholeStory();
        V := 6;
        WordApp.Selection.EndKey(V, EmptyParam);
        V := wdPageBreak;
        WordApp.Selection.InsertBreak(V);
      end;
    end;
    V := False;
    TemplateDoc.Close(V, EmptyParam, EmptyParam);
    WordApp.Visible := True;
  except
    V := False;
    WordApp.Quit(V);
    WordApp.Free;
  end;
end;

procedure TKisMapScanEditor.PrepareScanHistory;
var
  Scan: TKisMapScan;
begin
  Scan := TKisMapScan(Self.Entity);
  // получаем список файлов по истории скана
  FScanHistory := TKisScanHistoryFiles.Create;
  FScanHistory.Fill(Scan);
  FScanHistoryPrepared := True;
end;

procedure TKisMapScanEditor.PrintMap(Bmp: TBitmap);
var
  Picture: TPicture;
  aOpt: TATPrintOptions;
  Scan: TKisMapScan;
begin
  Scan := TKisMapScan(Entity);
  Picture := TPicture.Create;
  Picture.Forget();
  Picture.Graphic := Bmp;
  //
  FillChar(aOpt, SizeOf(aOpt), 0);
  with aOpt do
  begin
    Copies := 1;
    OptFit := pFitNormal;
    OptPosition := pPosCenter;
    OptUnit := pUnitMm;

    OptMargins.Left := 5;//FIni.ReadFloat('Opt', 'MarginL', 20);
    OptMargins.Top := 5;//FIni.ReadFloat('Opt', 'MarginT', 10);
    OptMargins.Right := 5;//FIni.ReadFloat('Opt', 'MarginR', 10);
    OptMargins.Bottom :=  5;//FIni.ReadFloat('Opt', 'MarginB', 10);

    OptFit := pFitSize;//TATPrintFitMode(FIni.ReadInteger('Opt', 'Fit', 0));
    OptFitSize.x := 50;//FIni.ReadFloat('Opt', 'SizeX', 100);
    OptFitSize.y := 50;//FIni.ReadFloat('Opt', 'SizeY', 100);
    OptGamma := 1;//FIni.ReadFloat('Opt', 'Gamma', 1.0);

    with OptFooter do
    begin
      Enabled := True;
      EnableLine := False;
      AtTop := True;
      FontName := 'Arial';//FIni.ReadString('Opt', 'FontName', 'Arial');
      FontSize := 24;//FIni.ReadInteger('Opt', 'FontSize', 9);
      FontStyle := [];//TFontStyles(byte(FIni.ReadInteger('Opt', 'FontStyle', 0)));
      FontColor := clBlack;//FIni.ReadInteger('Opt', 'FontColor', clBlack);
      FontCharset := DEFAULT_CHARSET; //FIni.ReadInteger('Opt', 'FontCharset', DEFAULT_CHARSET);
    end;
    PixelsPerInch := Screen.PixelsPerInch;
    JobCaption := Self.Caption;
    FailOnErrors := True;
    OptUnit := pUnitCm;
    OptFooter.Caption := Scan.Nomenclature;
  end;
  PicturePrint(Picture, aOpt);
end;

procedure TKisMapScanEditor.PrintMap2(Bmp: TBitmap);
var
  Scan: TKisMapScan;
  PrintDlg: IMapPrintDialog;
begin
  Scan := TKisMapScan(Entity);
  PrintDlg := TMapPrintDialogFactory.CreateDialog();
  PrintDlg.Display(Scan.Nomenclature, Bmp);
end;

function TKisMapScanEditor.SaveImageForWord(MapHistElem: TKisEntity): string;
var
  ScanHist: TKisMapScanHistoryElement;
  Op: TFileOperation;
  OpItem: TFileOperationItem;
  TmpFile, TmpImgFile, TmpJpegFile, TmpMfFile: string;
  Bmp: TBitmap;
  Mf: TMetafile;
begin
  Result := '';
  if MapHistElem is TKisMapScanHistoryElement then
  begin
    ScanHist := TKisMapScanHistoryElement(MapHistElem);
    if ScanHist.FigureCount > 0 then
    begin
      Mf := ScanHist.PrepareMetafile(1000, True);
      Mf.Forget();
      TmpFile := TFileUtils.CreateTempFile(AppModule.AppTempPath);
      TmpMfFile := ChangeFileExt(TmpFile, '.emf');
      try
        Mf.SaveToFile(TmpMfFile);
        Result := TmpMfFile;
      finally
        TFileUtils.DeleteFile(TmpFile)
      end;
    end
    else
    begin
      if not FScanHistoryPrepared then
        PrepareScanHistory();
      Op := FScanHistory.Operation(ScanHist.FileOpId);
      if Assigned(Op) then
      begin
        OpItem := Op.GetFile(fileDiffZone);
        if Assigned(OpItem) and OpItem.HasImage() then
        begin
          TmpFile := TFileUtils.CreateTempFile(AppModule.AppTempPath);
          TmpImgFile := OpItem.GetSaveImageFileName();
          TmpImgFile := ChangeFileExt(TmpFile, ExtractFileExt(TmpImgFile));
          TFileUtils.RenameFile(TmpFile, TmpImgFile);
          TmpJpegFile := ChangeFileExt(TmpFile, '.jpg');
          try
            OpItem.SaveImage(TmpImgFile);
            Bmp := TBitmap.CreateFromFile(TmpImgFile);
            Bmp.Forget();
            Bmp.Canvas.Pen.Style := psSolid;
            Bmp.Canvas.Pen.Color := clBlack;
            Bmp.Canvas.Pen.Width := 10;
            Bmp.Canvas.DrawCrosses(Bmp.Height, Bmp.Width);
            Bmp.SaveToJpeg(TmpJpegFile);
            Result := TmpJpegFile;
          finally
            TFileUtils.DeleteFile(TmpImgFile);
            TFileUtils.DeleteFile(TmpFile);
          end;
        end;
      end;
    end;
  end;
end;

procedure TKisMapScanEditor.SaveOperationItem(OpFile: TFileOperationItem; const aTitle: string);
var
  ImgFile, JpgFile: string;
  TmpFile, ImgTmpFile: string;
  ImgExt, ImgExtUp: string;
  ConvertToJpg: Boolean;
  Bmp: TBitmap;
begin
  JpgFile := '';
  ImgFile := OpFile.GetSaveImageFileName();
  ConvertToJpg := True;
  if ImgFile <> '' then
  begin
    ImgExt := ExtractFileExt(ImgFile);
    ImgExtUp := AnsiUpperCase(ImgExt);
    if (ImgExtUp = '.JPG') or (ImgExtUp = '.JPEG') then
      ConvertToJpg := False;
  end;
  SaveDialog2.Title := aTitle;
//  SaveDialog2.Filename := OpFile.GetSaveImageFileName();
//  SaveDialog2.DefaultExt := ExtractFileExt(SaveDialog2.Filename);
  SaveDialog2.Filename := ChangeFileExt(ImgFile, '.jpg');
  SaveDialog2.DefaultExt := '.jpg';
  SaveDialog2.Filter := 'Файлы JPEG (.jpg)|*.jpg';
  SaveDialog2.FilterIndex := 0;

  if SaveDialog2.Execute(Self.Handle) then
  begin
    if ConvertToJpg then
    begin
      TmpFile := TFileUtils.CreateTempFile(AppModule.AppTempPath);
      try
        ImgTmpFile := ChangeFileExt(TmpFile, ImgExt);
        TFileUtils.RenameFile(TmpFile, ImgTmpFile);
        OpFile.SaveImage(ImgTmpFile);
        Bmp := nil;
        try
          if TMapScanStorage.FileIsVector(ImgTmpFile) then
            Bmp := TAutoCADUtils.ExportToBitmap(ImgTmpFile, SZ_MAP_PX, SZ_MAP_PX)
          else
            Bmp := TBitmap.CreateFromFile(ImgTmpFile);
          Bmp.SaveToJpeg(SaveDialog2.Files[0]);
        finally
          FreeAndNil(Bmp);
        end;
      finally
        TFileUtils.DeleteFile(ImgTmpFile);
        TFileUtils.DeleteFile(TmpFile);
      end;
    end
    else
    begin
      OpFile.SaveImage(SaveDialog2.Files[0]);
    end;
  end;
end;

function TKisMapScanEditor.SaveOperationItemToTempFile(OpFile: TFileOperationItem): string;
var
  ImgFile: string;
  TmpFile, ImgTmpFile: string;
  ImgExt: string;
begin
  Result := '';
  ImgFile := OpFile.GetSaveImageFileName();
  if ImgFile <> '' then
  begin
    ImgExt := ExtractFileExt(ImgFile);
    TmpFile := TFileUtils.CreateTempFile(AppModule.AppTempPath);
    try
      ImgTmpFile := ChangeFileExt(TmpFile, ImgExt);
      TFileUtils.RenameFile(TmpFile, ImgTmpFile);
      OpFile.SaveImage(ImgTmpFile);
      Result := ImgTmpFile;
    finally
      TFileUtils.DeleteFile(TmpFile);
    end;
  end;
end;

procedure TKisMapScanEditor.SetHistoryImageFile(const Value: string);
begin
  FHistoryImageFile := Value;
  if FileExists(FHistoryImageFile) then
    LoadHistoryImage(FHistoryImageFile);
end;

procedure TKisMapScanEditor.tabHistoryShow(Sender: TObject);
begin
  inherited;
  if Assigned(dsMapHistory.DataSet)
     and
     Assigned(dsMapHistory.DataSet.AfterScroll)
  then
    dsMapHistory.DataSet.AfterScroll(dsMapHistory.DataSet);
end;

procedure TKisMapScanEditor.TrackBar1Change(Sender: TObject);
begin
  inherited;
  UpdateImageScaleOptions;
  UpdateSelfOptions;
end;

procedure TKisMapScanEditor.UpdateImageScaleOptions;
begin
  if not FUpdatingSelfOptions then
  begin
    Box.ImageScale := TrackBar1.Position;
  end;
end;

procedure TKisMapScanEditor.UpdateSelfOptions;
begin
  FUpdatingSelfOptions := True;

  chkFit.Checked := Box.ImageFitToWindow;
  UpdateSelfScaleOptions;

  FUpdatingSelfOptions := False;
end;

procedure TKisMapScanEditor.UpdateSelfScaleOptions;
begin
  FUpdatingSelfOptions := True;

  TrackBar1.Position := Box.ImageScale;
  LabelScale.Caption := Format('%d%%', [Box.ImageScale]);

  FUpdatingSelfOptions := False;
end;

procedure TKisMapScanEditor.ViewCurrentHistoryImages;
var
  Viewer: IKisImagesView;
  OpFileRes, OpFileSrc, OpFileDiff: TFileOperationItem;
  aTitle: string;
  I: Integer;
  FileOpId: string;
  HasDiff: Boolean;
  aFileName: string;
  Files: TStringList;
  Scan: TKisMapScan;
  Gout, Gout2: TKisMapScanGiveOut;
  Op: TFileOperation;
  ResTitle: string;
begin
  inherited;
  if not FScanHistoryPrepared then
    PrepareScanHistory();
  //
  Scan := TKisMapScan(Entity);
  Gout := Scan.GetGiveOut(dsGiveOuts.DataSet.RecNo);
  Gout2 := Gout;
  if dsGiveOuts.DataSet.RecordCount = 1 then
  begin
    Viewer := TKisImagesViewFactory.CreateViewer();
    Files := TStringList.Create;
    Files.Forget();
    aFileName := theMapScansStorage.GetFileName(AppModule, Scan.Nomenclature, sfnRaster);
    if FileExists(aFileName) then
    begin
      Files.Add(aFileName);
      Viewer.AddImage(aFileName, 'Source', 'Планшет', Rect(0, 0, 250, 250));
    end
    else
      raise EFile.Create('Файл планшета не найден!', aFileName);
    //
    if Files.Count > 0 then
    begin
      aTitle := TKisMapScan(Entity).Nomenclature;
      aTitle := aTitle + ': Выдан - ' + Gout.DateOfGive;
      if Gout.DateOfBack <> '' then
        aTitle := aTitle + '; Принят - ' + Gout.DateOfBack;
      Viewer.Execute(AppModule, aTitle, 0);
    end;
    Exit;
  end;
  //
  if dsGiveOuts.DataSet.RecNo = 1 then
  begin
    Gout2 := Scan.GetGiveOut(dsGiveOuts.DataSet.RecNo + 1);
    OpFileSrc := nil;
    HasDiff := False;
    OpFileDiff := nil;
    FileOpId := Gout2.FileOperationId;
    Op := FScanHistory.Operation(FileOpId);
    if Assigned(Op) then
      OpFileRes := Op.GetFile(fileSource)
    else
      OpFileRes := nil;
    ResTitle := 'Планшет';
  end
  else
  if Gout.MD5Old = Gout.MD5New then
  begin
    if dsGiveOuts.DataSet.RecNo > 1 then
      Gout2 := Scan.GetGiveOut(dsGiveOuts.DataSet.RecNo - 1)
    else
      Exit;
    OpFileSrc := nil;
    HasDiff := False;
    OpFileDiff := nil;
    FileOpId := Gout2.FileOperationId;
    Op := FScanHistory.Operation(FileOpId);
    OpFileRes := Op.GetFile(fileResult);
    ResTitle := 'Планшет без изменений';
  end
  else
  begin
    FileOpId := Gout2.FileOperationId;
    //
    I := 0;
    Op := FScanHistory.Operation(FileOpId);
    if not Assigned(Op) then
    begin
      raise EKisException.Create(
        'Пакет файлов для операции с индексом [' + FileOpId + '] не найден!'
      );
    end;
    //
    OpFileRes := Op.GetFile(fileResult);
    if Assigned(OpFileRes) and OpFileRes.HasImage() then
      Inc(I);
    OpFileSrc := Op.GetFile(fileSource);
    if Assigned(OpFileSrc) and OpFileSrc.HasImage() then
      Inc(I);
    HasDiff := False;
    OpFileDiff := Op.GetFile(fileDiffZone);
    if Assigned(OpFileDiff) and OpFileDiff.HasImage() then
    begin
      Inc(I);
      HasDiff := True;
    end;
    if I = 0 then
    begin
      raise EKisException.Create(
        'Файлы изображений не найдены!' + sLineBreak +
        'Код операции: ' + FileOpId
      );
    end;
    ResTitle := 'Принятый планшет';
  end;
  //
  Viewer := TKisImagesViewFactory.CreateViewer();
  Files := TStringList.Create;
  Files.Forget();
  try
    if Assigned(OpFileSrc) and OpFileSrc.HasImage() then
    begin
      aFileName := SaveOperationItemToTempFile(OpFileSrc);
      Files.Add(aFileName);
      Viewer.AddImage(aFileName, 'Source', 'Оригинальный планшет', Rect(0, 0, 250, 250));
    end;
    if HasDiff then
    begin
      aFileName := SaveOperationItemToTempFile(OpFileDiff);
      Files.Add(aFileName);
      Viewer.AddImage(aFileName, 'Diff', 'Область изменений', Rect(0, 0, 250, 250));
    end;
    if Assigned(OpFileRes) and OpFileRes.HasImage() then
    begin
      aFileName := SaveOperationItemToTempFile(OpFileRes);
      Files.Add(aFileName);
      Viewer.AddImage(aFileName, 'Result', ResTitle, Rect(0, 0, 250, 250));
    end;
    //
    aTitle := TKisMapScan(Entity).Nomenclature;
    aTitle := aTitle + ': Выдан - ' + Gout.DateOfGive;
    if Gout.DateOfBack <> '' then
      aTitle := aTitle + '; Принят - ' + Gout.DateOfBack;
    Viewer.Execute(AppModule, aTitle, IfThen(HasDiff, 1, 0));
  finally
    for I := 0 to Files.Count - 1 do
      TFileUtils.DeleteFile(FIles[I]);
  end;
end;

procedure TKisMapScanEditor.ViewOperationItem(OpFile: TFileOperationItem; const aTitle: string);
var
  ImgFile: string;
  TmpFile, ImgTmpFile: string;
  ImgExt: string;
  aViewer: IKisImageViewer;
begin
  ImgFile := OpFile.GetSaveImageFileName();
  if ImgFile = '' then
    Exit;
  //
  aViewer := TKisImageViewerFactory.CreateImageViewer();
  TmpFile := TFileUtils.CreateTempFile(AppModule.AppTempPath);
  try
    ImgExt := ExtractFileExt(ImgFile);
    ImgTmpFile := ChangeFileExt(TmpFile, ImgExt);
    TFileUtils.RenameFile(TmpFile, ImgTmpFile);
    OpFile.SaveImage(ImgTmpFile);
    aViewer.AllowSave := True;
    aViewer.ShowImage(aTitle, ImgTmpFile);
  finally
    TFileUtils.DeleteFile(ImgTmpFile);
    TFileUtils.DeleteFile(TmpFile);
  end;
end;

procedure TKisMapScanEditor.edNomenclatureKeyPress(Sender: TObject;
  var Key: Char);
begin
  inherited;
  if Key in [#8, #10] then
    Exit;
  if Key = '0' then
  begin
    if Length(edNomenclature.Text) > 0 then
      if (edNomenclature.Text[1] = '0') or (edNomenclature.SelStart > 0) then
        Key := #0;
  end
  else
    if (Key = '0') or ((Key >= 'А') and (Key <= 'Я'))
       or ((Key >= 'а') and (Key <= 'я'))
    then
      Key := String(UpperCase(Key))[1]
    else
      if not (Key in ['(', ')']) then
        Key := #0;
end;

procedure TKisMapScanEditor.edMD5Enter(Sender: TObject);
begin
  inherited;
  edMD5.SelectAll;
end;

procedure TKisMapScanEditor.edNom2KeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  inherited;
  if Key = VK_RIGHT then
    if edNom2.SelStart = Length(edNom2.Text) then
      edNom3.SetFocus;
end;

procedure TKisMapScanEditor.edNomenclatureKeyDown(Sender: TObject;
  var Key: Word; Shift: TShiftState);
begin
  inherited;
  if Key = VK_RIGHT then
    if edNomenclature.SelStart = Length(edNomenclature.Text) then
      edNom2.SetFocus;
end;

procedure TKisMapScanEditor.edNom2KeyPress(Sender: TObject; var Key: Char);
begin
  inherited;
  if Key in [#8, #10] then
    Exit;
  case Key of
  'X', 'x', '[', '{',   // Lat
  'Х', 'х', 'Ч', 'ч' :  // Rus
    begin
      Key := 'X';
    end;
  '1', 'I', 'i', 'Ш', 'ш', '!', '|':
    begin
      Key := 'I';
    end;
  '5', 'V', 'v', 'М', 'м', '%':
    begin
      Key := 'V';
    end;
  else
    if Key <> '0' then
      Key := #0;
  end;
end;

procedure TKisMapScanEditor.edNom3KeyPress(Sender: TObject; var Key: Char);
begin
  inherited;
  if Key in [#8, #10] then
    Exit;
  if not (Key in NumberChars) then
    Key := #0;
end;

end.

// DONE -сИС#13 : сделать кнопку для просмотра области изменений в хорошем разрешении
// DONE -сИС#13 : сделать кнопку для просмотра данных планшета, как это было при приёме
// TODO -сИС#13 : При просмотре изменений показывать кресты с возможностью отключения
// DONE -сИС#13 : Новый отчёт по формуляру
// DONE -сИС#13 : В формуляре дать возможность сохранить файл планшета на комп пользователя
// DONE -сИС#13 : Для формуляра надо тоже сделать кнопку просмотра изменений
// DONE -сИС#13 : Для печати формуляра надо использовать файл в большом разрешении, а не мини-файл
// DONE -сИС#13 : При просмотре истории - если планшет был только загружен, то показываем только его без изменений
// DONE -сИС#13 : При просмотре истории - если планшет был загружен целиком, то показываем исходный и новый, изменения формируются по желанию пользователя
// DONE -сИС#13 : При просмотре истории - если планшет был только загружен с изменениями, то показываем как при приёме, но нельзя выбрать тип файла

