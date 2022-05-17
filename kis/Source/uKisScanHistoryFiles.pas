unit uKisScanHistoryFiles;

interface

uses
  SysUtils, Classes, Contnrs,
  uFileUtils, uGC,
  uKisMapScans, uMapScanFiles, uKisAppModule;

type
  TFileOperationItemKind = (fileSource, fileResult, fileDiffZone);

  TFileOperationItem = class
  private
    FKind: TFileOperationItemKind;
    procedure SetKind(const Value: TFileOperationItemKind);
  protected
    FFileName: string;
    FOpId: string;
    FNomenclature: string;
    procedure SetFileName(const Value: string);
  public
    function GetSaveImageFileName(): string; virtual; abstract;
    function HasImage(): Boolean; virtual; abstract;
    procedure SaveImage(const aFileName: string); virtual; abstract;
    //
    property Kind: TFileOperationItemKind read FKind;// write SetKind;
    property FileName: string read FFileName;// write SetFileName;
  end;

  TFileOpItemSource = class(TFileOperationItem)
  protected
    function GetRealImageFileName(): string;
  public
    function GetSaveImageFileName(): string; override;
    function HasImage(): Boolean; override;
    procedure SaveImage(const aFileName: string); override;
  public
    constructor Create(const aFileName, OpId, aNomenclature: string);
  end;

  TFileOpItemResult = class(TFileOpItemSource)
  public
    function GetSaveImageFileName(): string; override;
  public
    constructor Create(const aFileName, OpId, aNomenclature: string);
  end;

  TFileOpItemDiffArch = class(TFileOpItemSource)
  public
    function GetSaveImageFileName(): string; override;
  public
    constructor Create(const aFileName, OpId, aNomenclature: string);
  end;

  TFileOperationKind = (fileopInitialUpload, fileopUpload);

  TFileOperation = class
  private
    FList: TObjectList;
    FId: string;
    FKind: TFileOperationKind;
    procedure SetId(const Value: string);
    procedure SetKind(const Value: TFileOperationKind);
  public
    constructor Create;
    destructor Destroy; override;
    //
    procedure AddFile(const aFileName, aNomenclature: string; const aKind: TFileOperationItemKind);
    function GetFile(const ItemKind: TFileOperationItemKind): TFileOperationItem;
    //
    property Id: string read FId write SetId;
    property Kind: TFileOperationKind read FKind write SetKind;
  end;

  TKisScanHistoryFiles = class
  private
    FList: TObjectList;
    FNomenclature: string;
    FScan: TKisMapScan;
    procedure AddOperation(Go: TKisMapScanGiveOut; const Recno: Integer);
    procedure AddInitialUpload(Go: TKisMapScanGiveOut);
    procedure AddUpload(Go1, Go2: TKisMapScanGiveOut);
  public
    constructor Create;
    destructor Destroy; override;
    //
    procedure Fill(aScan: TKisMapScan);
    function Operation(const Id: string): TFileOperation;
  end;

implementation

{ TFileOperationItem }

procedure TFileOperationItem.SetFileName(const Value: string);
begin
  FFileName := Value;
end;

procedure TFileOperationItem.SetKind(const Value: TFileOperationItemKind);
begin
  FKind := Value;
end;

{ TFileOperation }

procedure TFileOperation.AddFile(const aFileName, aNomenclature: string; const aKind: TFileOperationItemKind);
var
  aFile: TFileOperationItem;
begin
  aFile := nil;
  case aKind of
    fileSource:
      begin
        aFile := TFileOpItemSource.Create(aFileName, FId, aNomenclature);
      end;
    fileResult:
      begin
        aFile := TFileOpItemResult.Create(aFileName, FId, aNomenclature);
      end;
    fileDiffZone:
      begin
        aFile := TFileOpItemDiffArch.Create(aFileName, FId, aNomenclature);
      end;
  end;
  if Assigned(aFile) then
    FList.Add(aFile);
end;

constructor TFileOperation.Create;
begin
  FList := TObjectList.Create;
end;

destructor TFileOperation.Destroy;
begin
  FList.Free;
  inherited;
end;

function TFileOperation.GetFile(const ItemKind: TFileOperationItemKind): TFileOperationItem;
var
  I: Integer;
begin
  for I := 0 to FList.Count - 1 do
    if TFileOperationItem(FList[I]).Kind = ItemKind then
    begin
      Result := TFileOperationItem(FList[I]);
      Exit;
    end;
  Result := nil;
end;

procedure TFileOperation.SetId(const Value: string);
begin
  FId := Value;
end;

procedure TFileOperation.SetKind(const Value: TFileOperationKind);
begin
  FKind := Value;
end;

{ TKisScanHistoryFiles }

procedure TKisScanHistoryFiles.AddInitialUpload(Go: TKisMapScanGiveOut);
var
  Op: TFileOperation;
  OriginalFile: string;
begin
  OriginalFile := TMapScanStorage.GetFileName(AppModule, FNomenclature, sfnArchive, Go.FileOperationId);
  Op := TFileOperation.Create;
  Op.Id := Go.FileOperationId;
  Op.Kind := fileopInitialUpload;
  FList.Add(Op);
  Op.AddFile(OriginalFile, FNomenclature, fileResult);
end;

procedure TKisScanHistoryFiles.AddOperation(Go: TKisMapScanGiveOut; const Recno: Integer);
var
  NextGo: TKisMapScanGiveOut;
  I, Cnt: Integer;
begin
  if Go.MD5New = '' then
  begin
    // возврата не было - значит и планшет не изменился
    Exit;
  end;
  if Recno = 1 then
  begin
    if Go.MD5Old = '' then
    begin
      // это первоначальная загрузка планшета в базу
      AddInitialUpload(Go);
      Exit;
    end;
  end;
  if not Go.HasChangesInMap() then
  begin
    // изменений не было - не добавляем
    Exit;
  end;
  //
  NextGo := nil;
  Cnt := FScan.GiveOuts.RecordCount;
  for I := RecNo + 1 to Cnt do
  begin
    NextGo := FScan.GetGiveOut(I);
    if not NextGo.HasChangesInMap() then
      NextGo := nil
    else
      Break;
  end;
  AddUpload(Go, NextGo);
end;

procedure TKisScanHistoryFiles.AddUpload(Go1, Go2: TKisMapScanGiveOut);
var
  OriginalFile: string;
  ResultFile: string;
  ZoneFile: string;
  Op: TFileOperation;
begin
  // есть изменения
  // надо прошерстить файлы в хранилище и найти:
  // - оригинал
  // - результат
  // - архив изменений, если он есть
  OriginalFile := TMapScanStorage.GetFileName(AppModule, FNomenclature, sfnArchive, Go1.FileOperationId);
  ZoneFile := TMapScanStorage.GetFileName(AppModule, FNomenclature, sfnArchiveZone, Go1.FileOperationId);
  if Go2 = nil then
  begin
    // планшет возвращён, результатом будет актуальный планшет
    ResultFile := TMapScanStorage.GetFileName(AppModule, FNomenclature, sfnRaster);
  end
  else
  begin
    // планшет был возвращён и выдан снова, результатом будет бекап планшета во второй заявке
    ResultFile := TMapScanStorage.GetFileName(AppModule, FNomenclature, sfnArchive, Go2.FileOperationId);
  end;
  Op := TFileOperation.Create;
  Op.Id := Go1.FileOperationId;
  Op.Kind := fileopUpload;
  FList.Add(Op);
  Op.AddFile(OriginalFile, FNomenclature, fileSource);
  Op.AddFile(ResultFile, FNomenclature, fileResult);
  Op.AddFile(ZoneFile, FNomenclature, fileDiffZone);
end;

constructor TKisScanHistoryFiles.Create;
begin
  inherited;
  FList := TObjectList.Create;
end;

destructor TKisScanHistoryFiles.Destroy;
begin
  FList.Free;
  inherited;
end;

procedure TKisScanHistoryFiles.Fill(aScan: TKisMapScan);
var
  I, Cnt: Integer;
  Go: TKisMapScanGiveOut;
begin
  FNomenclature := aScan.Nomenclature;
  FScan := aScan;
  try
    Cnt := aScan.GiveOuts.RecordCount;
    for I := 1 to Cnt do
    begin
      // Как заполнить список файлов
      // Для каждой выдачи смотрим ID операции
      // Если выдача не была возвращена, то её учитывать не надо
      // Для первой выдачи
      Go := aScan.GetGiveOut(I);
      if not Go.Annulled then
        AddOperation(Go, I);
    end;
  finally
    FScan := nil;
  end;
end;

function TKisScanHistoryFiles.Operation(const Id: string): TFileOperation;
var
  I: Integer;
begin
  for I := 0 to FList.Count - 1 do
  begin
    if TFileOperation(FList[I]).Id = Id then
    begin
      Result := TFileOperation(FList[I]);
      Exit;
    end;
  end;
  Result := nil;
end;

{ TFileOpItemSource }

constructor TFileOpItemSource.Create(const aFileName, OpId, aNomenclature: string);
begin
  inherited Create;
  FKind := fileSource;
  FFileName := aFileName;
  FOpId := OpId;
  FNomenclature := aNomenclature;
end;

function TFileOpItemSource.GetRealImageFileName: string;
var
  PackedFiles: TStringList;
  I: Integer;
begin
  Result := FFileName;
  if not TMapScanStorage.IsGraphicFile(FFileName) then
  begin
    if TMapScanStorage.IsPacked(FFileName) then
    begin
      PackedFiles := TStringList.Create;
      PackedFiles.Forget();
      if TFileUtils.UnpackGetFileList(FFileName, PackedFiles, True) then
      begin
        for I := 0 to PackedFiles.Count - 1 do
        begin
          if TMapScanStorage.IsGraphicFile(PackedFiles[I]) then
          begin
            Result := PackedFiles[I];
            Exit;
          end;
        end;
      end;
    end;
  end;
end;

function TFileOpItemSource.GetSaveImageFileName: string;
begin
  Result := FNomenclature + '_' + FOpId + '_original' + ExtractFileExt(FFileName);
end;

function TFileOpItemSource.HasImage: Boolean;
begin
  Result := FileExists(FFileName);
  if Result then
  begin
    Result := TMapScanStorage.IsGraphicFile(FFileName);
    if not Result then
      Result := GetRealImageFileName() <> '';
  end;
end;

procedure TFileOpItemSource.SaveImage(const aFileName: string);
var
  ImgFile: string;
begin
  ImgFile := GetRealImageFileName();
  if ImgFile = FFileName then
    TFileUtils.CopyFile(ImgFile, aFileName, True)
  else
    TFileUtils.UnpackSpecificFile(FFileName, ImgFile, aFileName, TRue);
end;

{ TFileOpItemResult }

constructor TFileOpItemResult.Create(const aFileName, OpId, aNomenclature: string);
begin
  inherited Create(aFileName, OpId, aNomenclature);
  FKind := fileResult;
end;

function TFileOpItemResult.GetSaveImageFileName: string;
begin
  Result := FNomenclature + '_' + FOpId + '_result' + ExtractFileExt(FFileName);
end;

{ TFileOpItemDiffArch }

constructor TFileOpItemDiffArch.Create(const aFileName, OpId, aNomenclature: string);
begin
  inherited Create(aFileName, OpId, aNomenclature);
  FKind := fileDiffZone;
end;

function TFileOpItemDiffArch.GetSaveImageFileName: string;
var
  ImgFile: string;
begin
  ImgFile := GetRealImageFileName();
  Result := FNomenclature + '_' + FOpId + '_zone' + ExtractFileExt(ImgFile);
end;

end.
