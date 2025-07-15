unit uMStFormLayers;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms, Buttons, ActnList, ImgList,
  Dialogs, StdCtrls, ComCtrls, Contnrs,
  EzBaseGIS,
  uGC, uFileUtils, uCommonUtils, SciZipFile,
  uMStKernelClasses, uMStKernelConsts, uMStImport, uMstImportFactory, uMstDialogFactory, uMStFormImportProgress,
  uMStModuleApp, uMStImportDbImporter, uMStKernelSemantic;

type

  TMStFormLayers = class(TForm)
    lvLayers: TListView;
    btnImportMif: TButton;
    btnClose: TButton;
    btnDelete: TButton;
    btnSaveZip: TButton;
    btnLayerUp: TBitBtn;
    btnLayerDown: TBitBtn;
    ActionList1: TActionList;
    ImageList1: TImageList;
    acLayerUp: TAction;
    acLayerDown: TAction;
    acDelete: TAction;
    MidMifDialog: TOpenDialog;
    SaveDialogZip: TSaveDialog;
    procedure btnCloseClick(Sender: TObject);
    procedure acLayerUpUpdate(Sender: TObject);
    procedure acLayerDownUpdate(Sender: TObject);
    procedure acDeleteUpdate(Sender: TObject);
    procedure acDeleteExecute(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure acLayerUpExecute(Sender: TObject);
    procedure acLayerDownExecute(Sender: TObject);
    procedure btnImportMifClick(Sender: TObject);
    procedure btnSaveZipClick(Sender: TObject);
  private
    FErrors: Integer;
    FImported: Integer;
    FDbImporter: TmstDbImporter;
    FProgressForm: TMStImportProgressForm;
    FImportEzLayer: TEzBaseLayer;
    FImportLayer: TmstLayer;
    FImportedLayers: TList;
    FDeletedLayers: TStringList;
    procedure DeleteLayer();
    function GetLayer(): TmstLayer;
    procedure LoadLayers();
    function LayerToListView(aLayer: TmstLayer): TListItem;
    procedure SetLayer(Itm: TListItem; mstLayer: TmstLayer);
    function ImportMifFile(const aFileName: string): Boolean;
    procedure CreateNewLayer(aSettings: ImstImportSettings);
    function PrepareLayerFileName(aSettings: ImstImportSettings): string;
    procedure CopyLayerFiles(LayerName, SourceFolder, FilesFolder: string);
    procedure DeleteLayerFiles(LayerName, FilesFolder: string);
    function GenNewLayerId(): Integer;
    procedure CreateImportLayerFieldsFile(aSettings: ImstImportSettings);
  private
    procedure OnImportEntity(Sender: ImstImportLayer; const EntityNo, FileLineNo: Integer; aEntity: TEzEntity);
    procedure OnImportError(Sender: ImstImportLayer; const EntityNo, FileLineNo: Integer; aException: Exception);
    procedure OnImportData(Sender: ImstImportLayer; const EntityNo: Integer; FldValues: TStrings);
  public
    procedure Execute();
  end;

implementation

{$R *.dfm}

function CompareLayers(Item1, Item2: Pointer): Integer;
begin
  Result := TmstLayer(Item1).Position - TmstLayer(Item2).Position;
end;

procedure TMStFormLayers.acDeleteExecute(Sender: TObject);
var
  A: Integer;
  L: TmstLayer;
begin
  L := GetLayer();
  if not Assigned(L) then
    Exit;
  A := MessageBox(Handle,
    PChar('Удаление слоя "' + L.Caption + '" невозможно отменить.' + sLineBreak + 'Всё равно удалить?'),
    PChar('Внимание!'),
    MB_YESNO + MB_ICONQUESTION
  );
  if A = ID_YES then
    DeleteLayer();
end;

procedure TMStFormLayers.acDeleteUpdate(Sender: TObject);
var
  mstLayer: TmstLayer;
begin
  mstLayer := GetLayer();
  acDelete.Enabled := Assigned(mstLayer) and (mstLayer.LayerType = ID_LT_IMPORTED);
end;

procedure TMStFormLayers.acLayerDownExecute(Sender: TObject);
var
  Sel: TListItem;
  I1, I2: Integer;
  Itm: TListItem;
  L: TmstLayer;
begin
  Sel := lvLayers.Selected;
  if Assigned(Sel) then
  begin
    lvLayers.Items.BeginUpdate;
    try
      L := GetLayer();
      I1 := Sel.Index;
      I2 := I1 + 1;
      Itm := lvLayers.Items.Insert(I2);
      SetLayer(Itm, L);
      lvLayers.DeleteSelected;
      Itm.Selected := True;
    finally
      lvLayers.Items.EndUpdate;
    end;
  end;
end;

procedure TMStFormLayers.acLayerDownUpdate(Sender: TObject);
var
  I, Pos: Integer;
  Itm2: TListItem;
begin
  Pos := -1;
  for I := 0 to lvLayers.Items.Count - 1 do
  begin
    Itm2 := lvLayers.Items[I];
    if Itm2.Index > Pos then
      Pos := Itm2.Index;
  end;
  acLayerDown.Enabled := (lvLayers.ItemIndex >= 0) and (lvLayers.ItemIndex < Pos);
end;

procedure TMStFormLayers.acLayerUpExecute(Sender: TObject);
var
  Sel: TListItem;
  I1, I2: Integer;
  Itm: TListItem;
begin
  Sel := lvLayers.Selected;
  if Assigned(Sel) then
  begin
    lvLayers.Items.BeginUpdate;
    try
      I1 := Sel.Index;
      I2 := I1 - 1;
      Itm := lvLayers.Items.Insert(I2);
      SetLayer(Itm, GetLayer());
      lvLayers.DeleteSelected;
      Itm.Selected := True;
    finally
      lvLayers.Items.EndUpdate;
    end;
  end;
end;

procedure TMStFormLayers.acLayerUpUpdate(Sender: TObject);
var
  mstLayer: TmstLayer;
begin
  mstLayer := GetLayer();
  acLayerUp.Enabled := Assigned(mstLayer) and (mstLayer.Position > 1); 
end;

procedure TMStFormLayers.btnCloseClick(Sender: TObject);
begin
  Close;
end;

procedure TMStFormLayers.btnImportMifClick(Sender: TObject);
begin
  // выбираем файл
  if MidMifDialog.Execute() then
    if ImportMifFile(MidMifDialog.Files[0]) then
      ShowMessage(Format('Ошибок: %d. Импорт: %d. Всего: %d.', [FErrors, FImported, FImported + FErrors]));
end;

procedure TMStFormLayers.btnSaveZipClick(Sender: TObject);
var
  S: string;
  Src, Tgt: string;
  Zip: TZipFile;
  ZipFiles: string;
  I: Integer;
  L: TmstLayer;
begin
  // открываем диалог
  if not SaveDialogZip.Execute() then
    Exit;
  //
  S := mstClientAppModule.AppSettings.SessionDir;
  Src := TPath.Finish(S, 'data.zip');
  if not FileExists(Src) then
  begin
    ShowMessage('Исходный файл найден!' + sLineBreak + Src);
    Exit;
  end;
  // копируем файл
  Tgt := TPath.Finish(S, 'geodata.zip');
  if FileExists(Tgt) then
    DeleteFile(Tgt);
  if not TFileUtils.CopyFile(Src, Tgt, True) then
  begin
    ShowMessage('Ошибка копирования файла!' + sLineBreak + Src + sLineBreak + Tgt);
    Exit;
  end;
  // распаковываем во временную папку
  Zip := TZipFile.Create;
  try
    Zip.LoadFromFile(Tgt, True);
    ZipFiles := TPath.Combine(S, 'geodata_new');
    if DirectoryExists(ZipFiles) then
      TFileUtils.DeleteDirectory(ZipFiles);
    if not ForceDirectories(ZipFiles) then
    begin
      ShowMessage('Ошибка при создании папки!' + sLineBreak + ZipFiles);
      Exit;
    end;
    Zip.UnzipToDir(ZipFiles);
  finally
    Zip.Free;
  end;
  // удаляем из него лишние слои
  for I := 0 to FDeletedLayers.Count - 1 do
  begin
    DeleteLayerFiles(FDeletedLayers[I], ZipFiles);
  end;
  // добавляем файлы новых слоёв
  for I := 0 to FImportedLayers.Count - 1 do
  begin
    L := FImportedLayers[I];
    CopyLayerFiles(L.Name, S, ZipFiles);
  end;
  // копируем упакованный файл куда надо
  TFileUtils.DeleteFile(Tgt);
  // пакуем файл
  TFileUtils.PackDirectory(SaveDialogZip.Files[0], ZipFiles, True);//False);
end;

procedure TMStFormLayers.CopyLayerFiles(LayerName, SourceFolder, FilesFolder: string);
var
  S: string;
  Src, Tgt: string;
  Files: TStringList;
  I: Integer;
begin
  S := TPath.Finish(SourceFolder, LayerName);
  Files := TStringList.Create;
  Files.Forget();
  TFileUtils.FindFiles(S + '.*', Files);
  for I := 0 to Files.Count - 1 do
  begin
    Src := TPath.Finish(SourceFolder, Files[I]);
    Tgt := FilesFolder + ExtractFileName(Files[I]);
    TFileUtils.CopyFile(Src, Tgt, True, False);
  end;
end;

procedure TMStFormLayers.CreateImportLayerFieldsFile(aSettings: ImstImportSettings);
var
  I: Integer;
  Fld: TmstLayerField;
  FileText: TStringList;
  S: string;
begin
  if aSettings.Fields.Count = 0 then
    Exit;
  FileText := TStringList.Create;
  FileText.Forget();
  //
  for I := 0 to aSettings.Fields.Count - 1 do
  begin
    Fld := aSettings.Fields[I];
    FileText.Add(Fld.Name);
    FileText.Add(Fld.Caption);
  end;
  //
  S := TPath.Finish(mstClientAppModule.GIS.LayersSubdir, FImportEzLayer.Name + '.flds');
  FileText.SaveToFile(S);
end;

procedure TMStFormLayers.CreateNewLayer(aSettings: ImstImportSettings);
var
  S: string;
  FldList: TStringList;
  I: Integer;
begin
  S := PrepareLayerFileName(aSettings);
  FldList := TStringList.Create;
  FldList.Forget();
  FldList.Add('UID;N;');
  FldList.Add('OBJECT_ID;C;36;');
  FImportEzLayer := mstClientAppModule.GIS.Layers.CreateNew(S, FldList);
  FImportLayer := TmstLayer.Create;//mstClientAppModule.Layers.AddLayer();
  FImportLayer.Caption := aSettings.LayerCaption;
  FImportLayer.Name := FImportEzLayer.Name;
  FImportLayer.Visible := False;
  FImportLayer.LayerType := ID_LT_IMPORTED;
  FImportLayer.Hidden := False;
  I := mstClientAppModule.Layers.GetMaxPosition();
  FImportLayer.Position := I + 1;
end;

procedure TMStFormLayers.DeleteLayer;
var
  L: TmstLayer;
begin
  L := GetLayer();
  if Assigned(L) then
  begin
    if FImportedLayers.IndexOf(L) > 0 then
      FImportedLayers.Remove(L)
    else
      FDeletedLayers.Add(L.Name);
    mstClientAppModule.MapMngr.DeleteLayer(L);
    mstClientAppModule.Layers.Remove(L);
    lvLayers.DeleteSelected;
  end;
end;

procedure TMStFormLayers.DeleteLayerFiles(LayerName, FilesFolder: string);
begin
  TFileUtils.ClearDirectory(FilesFolder, LayerName + '.*', False);
end;

procedure TMStFormLayers.Execute;
begin
  // загружаем список слоёв
  LoadLayers();
  //
  ShowModal;
end;

procedure TMStFormLayers.FormCreate(Sender: TObject);
begin
  FImportedLayers := TList.Create;
  FDeletedLayers := TStringList.Create;
end;

procedure TMStFormLayers.FormDestroy(Sender: TObject);
begin
  FImportedLayers.Free;
  FDeletedLayers.Free;
  //
  if Assigned(FDbImporter) then
    FDbImporter.Free;
end;

function TMStFormLayers.GenNewLayerId: Integer;
begin
  Result := mstClientAppModule.MapMngr.GenId('LAYERS');
end;

function TMStFormLayers.GetLayer: TmstLayer;
var
  Itm: TListItem;
  Tmp: TObject;
begin
  Result := nil;
  Itm := lvLayers.Selected;
  if Assigned(Itm) and (Itm.Data <> nil) then
  begin
    Tmp := Itm.Data;
    try
      if (Tmp is TmstLayer) then
        Result := Itm.Data;
    except
    end;
  end;
end;

function TMStFormLayers.ImportMifFile(const aFileName: string): Boolean;
var
  Import: ImstImportLayer;
  Dialog: ImstImportLayerDialog;
  DlgSettings: ImstImportSettings;
  Itm: TListItem;
begin
  // создаём объект для импорта
  Import := TmstImportFactory.NewLayerImport(importMifMid);
  // читаем заголовок
  Import.ReadHeader(aFileName, nil);
  // показываем информацию
  Dialog := TmstDialogFactory.NewImportLayerDialog();
  Result := Dialog.Execute(Import);
  if Result then
  begin
    FErrors := 0;
    FImported := 0;
    //
    DlgSettings := Dialog.Settings;
    CreateNewLayer(DlgSettings);
    mstClientAppModule.MapMngr.SaveLayer(FImportLayer);
    FDbImporter := TmstDbImporter.Create(DlgSettings);
    try
      if not Assigned(FProgressForm) then
        FProgressForm := TMStImportProgressForm.Create(Self);
      try
        FDbImporter.LayersId := FImportLayer.Id;
        FDbImporter.Start();
        if Assigned(FProgressForm) then
          FProgressForm.Start(aFileName, Import.RecordCount);
        //
        Import.OnImport := OnImportEntity;
        Import.OnImportError := OnImportError;
        Import.OnImportData := OnImportData;
        // импортируем, если всё ОК
        Import.DoImport(DlgSettings);
        //
        FImportedLayers.Add(FImportLayer);
        mstClientAppModule.Layers.Add(FImportLayer);
        //
        FImportEzLayer.Close;
        FImportEzLayer.Open;
        //
        CreateImportLayerFieldsFile(DlgSettings);
        //
        Itm := LayerToListView(FImportLayer);
        Itm.Selected := True;
        Itm.MakeVisible(False);
      finally
        // скрыть прогресс
        if Assigned(FProgressForm) then
          FProgressForm.Stop();
        if Assigned(FDbImporter) then
          FDbImporter.Stop();
      end;
    finally
      FreeAndNil(FDbImporter);
    end;
  end;
end;

function TMStFormLayers.LayerToListView(aLayer: TmstLayer): TListItem;
begin
  Result := nil;
  if aLayer.IsMP then
    Exit;
  if aLayer.IsLotCategory then
    Exit;
  Result := lvLayers.Items.Add;
  Result.Caption := aLayer.Caption;
  Result.Data := aLayer;
  if aLayer.LayerType = ID_LT_IMPORTED then
    Result.SubItems.Add('импортированный')
  else
    Result.SubItems.Add('фиксированный');
end;

procedure TMStFormLayers.LoadLayers;
var
  I: Integer;
//  mstLayer: TmstLayer;
//  S: string;
  LayerList: TList;
begin
  LayerList := mstClientAppModule.Layers.GetPlainList();
  LayerList.Forget();
  //
  LayerList.Sort(CompareLayers);
  //
  lvLayers.Items.BeginUpdate;
  try
    for I := 0 to LayerList.Count - 1 do
    begin
      LayerToListView(LayerList[I]);
    end;
  finally
    lvLayers.Items.EndUpdate;
  end;
end;

procedure TMStFormLayers.OnImportData(Sender: ImstImportLayer; const EntityNo: Integer; FldValues: TStrings);
begin
  if FldValues.Count = 0 then
    Exit;
  FDbImporter.DoImport(FldValues);
end;

procedure TMStFormLayers.OnImportEntity(Sender: ImstImportLayer; const EntityNo, FileLineNo: Integer;  aEntity: TEzEntity);
var
  Rn: Integer;
  ObjId: string;
begin
  Inc(FImported);
  if Assigned(FProgressForm) then
  begin
    FProgressForm.Visible := True;
    FProgressForm.UpdateProgress(FImported, FErrors);
  end;
  //
  if Assigned(FImportEzLayer) then
  begin
    Rn := FImportEzLayer.AddEntity(aEntity);
    FDbImporter.EntityRecNo := Rn;
    FDbImporter.LayersId := FImportLayer.Id;
    FImportEzLayer.DBTable.Edit;
    try
      ObjId := GetUniqueString(False, True);
      FImportEzLayer.DBTable.FieldPutN(2, ObjId);
    finally
      FImportEzLayer.DBTable.Post;
    end;
    FDbImporter.ObjectId := ObjId;
  end;
end;

procedure TMStFormLayers.OnImportError(Sender: ImstImportLayer; const EntityNo, FileLineNo: Integer; aException: Exception);
begin
  Inc(FErrors);
  if Assigned(FProgressForm) then
  begin
    FProgressForm.Visible := True;
    FProgressForm.UpdateProgress(FImported, FErrors);
  end;
end;

function TMStFormLayers.PrepareLayerFileName(aSettings: ImstImportSettings): string;
var
  S: string;
  Dir: string;
  LayerFile: string;
  Ext: string;
  CleanFileName: string;
  Num: Integer;
  B: Boolean;
begin
  S := aSettings.MifFileName;
  CleanFileName := ExtractFileName(ChangeFileExt(aSettings.MifFileName, ''));
  Ext := '.ezd';
  Num := 0;
  Dir := mstClientAppModule.GIS.LayersSubdir;
  repeat
    if Num = 0 then
      S := CleanFileName + Ext
    else
      S := CleanFileName + IntToStr(Num) + Ext;
    LayerFile := TPath.Finish(Dir, S);
    if FileExists(LayerFile) then
    begin
      B := False;
      Inc(Num);
    end
    else
    begin
      B := True;
      Result := ChangeFileExt(S, '');
    end;
  until B;
end;

procedure TMStFormLayers.SetLayer;
begin
  Itm.Caption := mstLayer.Caption;
  Itm.Data := mstLayer;
  if mstLayer.LayerType = ID_LT_IMPORTED then
    Itm.SubItems.Add('импортированный')
  else
    Itm.SubItems.Add('');
end;

end.
