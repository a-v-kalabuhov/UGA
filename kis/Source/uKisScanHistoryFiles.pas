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
    FMD5: string;
    procedure SetFileName(const Value: string);
  public
    function GetSaveImageFileName(): string; virtual; abstract;
    function HasImage(): Boolean; virtual; abstract;
    procedure SaveImage(const aFileName: string); virtual; abstract;
    //
    property Kind: TFileOperationItemKind read FKind;// write SetKind;
    property FileName: string read FFileName;// write SetFileName;
    property MD5: string read FMD5;
  end;

  TFileOpItemSource = class(TFileOperationItem)
  protected
    function GetRealImageFileName(): string;
  public
    function GetSaveImageFileName(): string; override;
    function HasImage(): Boolean; override;
    procedure SaveImage(const aFileName: string); override;
  public
    constructor Create(const aFileName, OpId, aNomenclature, aMD5: string);
  end;

  TFileOpItemResult = class(TFileOpItemSource)
  public
    function GetSaveImageFileName(): string; override;
  public
    constructor Create(const aFileName, OpId, aNomenclature, aMD5: string);
  end;

  TFileOpItemDiffArch = class(TFileOpItemSource)
  public
    function GetSaveImageFileName(): string; override;
  public
    constructor Create(const aFileName, OpId, aNomenclature, aMD5: string);
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
    procedure AddFile(const aFileName, aNomenclature, aMD5: string; const aKind: TFileOperationItemKind);
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
//    procedure Fill2(aScan: TKisMapScan);
    function Operation(const Id: string): TFileOperation;
  end;

  TKisScanHistoryRecord = class
  private
    FPrev, FNext: TKisScanHistoryRecord;
    FIndex: Integer;
    FFiles: array[TFileOperationItemKind] of TFileOperationItem;
    FFileOpId: string;
    FNomenclature: string;
    procedure AddFile(const aFileName, aFileOpId, aMD5: string; const aKind: TFileOperationItemKind);
    procedure AddFiles(aScan: TKisMapScan; Go: TKisMapScanGiveOut; const Recno: Integer);
    procedure AddInitialUpload(Go, GoNext: TKisMapScanGiveOut);
    procedure AddUpload(Go1, Go2: TKisMapScanGiveOut);
    procedure ClearDiffFile();
    procedure ClearResultFile();
    procedure ClearSourceFile();
    procedure CopyPrevResultAsSource();
    procedure CopySourceToResult();
    procedure SetFileOpId(const Value: string);
  public
    constructor Create(const aNomenclature: string);
    destructor Destroy; override;
    //
    procedure AddNext(aRecord: TKisScanHistoryRecord);
    function GetFile(aKind: TFileOperationItemKind): TFileOperationItem;
    function HasDiffZone(): Boolean;
    function HasSource(): Boolean;
    //
    property FileOpId: string read FFileOpId write SetFileOpId;
    property Index: Integer read FIndex;
    property Next: TKisScanHistoryRecord read FNext;
    property Prev: TKisScanHistoryRecord read FPrev;
  end;

  TKisScanHistoryIndex = class
  protected
    FPrepared: Boolean;
    FRecord: TKisScanHistoryRecord;
  public
    destructor Destroy; override;
    //
    procedure Prepare(aScan: TKisMapScan); virtual; abstract;
    function Get(const I: Integer): TKisScanHistoryRecord;
    function FindNextFileOpId(const I: Integer): string;
    function FindRecord(const aFileOpId: string): TKisScanHistoryRecord;
    property Prepared: Boolean read FPrepared;
  end;

  TKisScanHistoryIndex_v1 = class(TKisScanHistoryIndex)
  private
    FNomenclature: string;
    FScan: TKisMapScan;
    procedure FixEmptySourceFiles();
  public
    procedure Prepare(aScan: TKisMapScan); override;
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

procedure TFileOperation.AddFile(const aFileName, aNomenclature, aMD5: string; const aKind: TFileOperationItemKind);
var
  aFile: TFileOperationItem;
begin
  aFile := nil;
  case aKind of
    fileSource:
      begin
        aFile := TFileOpItemSource.Create(aFileName, FId, aNomenclature, aMD5);
      end;
    fileResult:
      begin
        aFile := TFileOpItemResult.Create(aFileName, FId, aNomenclature, aMD5);
      end;
    fileDiffZone:
      begin
        aFile := TFileOpItemDiffArch.Create(aFileName, FId, aNomenclature, aMD5);
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
  Op.AddFile(OriginalFile, FNomenclature, Go.MD5New, fileResult);
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
  MD5Original: string;
  MD5Zone: string;
  MD5Result: string;
begin
  // есть изменения
  // надо прошерстить файлы в хранилище и найти:
  // - оригинал
  // - результат
  // - архив изменений, если он есть
  OriginalFile := TMapScanStorage.GetFileName(AppModule, FNomenclature, sfnArchive, Go1.FileOperationId);
  ZoneFile := TMapScanStorage.GetFileName(AppModule, FNomenclature, sfnArchiveZone, Go1.FileOperationId);
  MD5Original := Go1.MD5Old;
  MD5Result := Go1.MD5New;
  MD5Zone := TMapScanStorage.GetMD5Hash(AppModule, ZoneFile);
  if Go2 = nil then
  begin
    // планшет возвращён, результатом будет актуальный планшет
    ResultFile := TMapScanStorage.GetFileName(AppModule, FNomenclature, TMapScanStorage.GetFileKind(AppModule, FNomenclature));
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
  Op.AddFile(OriginalFile, FNomenclature, MD5Original, fileSource);
  Op.AddFile(ResultFile, FNomenclature, MD5Result, fileResult);
  Op.AddFile(ZoneFile, FNomenclature, MD5Zone, fileDiffZone);
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
//      if not Go.Annulled then
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

constructor TFileOpItemSource.Create(const aFileName, OpId, aNomenclature, aMD5: string);
begin
  inherited Create;
  FKind := fileSource;
  FFileName := aFileName;
  FOpId := OpId;
  FNomenclature := aNomenclature;
  FMD5 := aMD5;
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

constructor TFileOpItemResult.Create(const aFileName, OpId, aNomenclature, aMD5: string);
begin
  inherited Create(aFileName, OpId, aNomenclature, aMD5);
  FKind := fileResult;
end;

function TFileOpItemResult.GetSaveImageFileName: string;
begin
  Result := FNomenclature + '_' + FOpId + '_result' + ExtractFileExt(FFileName);
end;

{ TFileOpItemDiffArch }

constructor TFileOpItemDiffArch.Create(const aFileName, OpId, aNomenclature, aMD5: string);
begin
  inherited Create(aFileName, OpId, aNomenclature, aMD5);
  FKind := fileDiffZone;
end;

function TFileOpItemDiffArch.GetSaveImageFileName: string;
var
  ImgFile: string;
begin
  ImgFile := GetRealImageFileName();
  Result := FNomenclature + '_' + FOpId + '_zone' + ExtractFileExt(ImgFile);
end;

{ TKisScanHistoryIndex_v1 }

procedure TKisScanHistoryIndex_v1.FixEmptySourceFiles;
var
  R, R1, Rlast: TKisScanHistoryRecord;
  aFile: TFileOperationItem;
begin
  Rlast := FRecord.Next;
  R := Rlast;
  while R <> nil do
  begin
    R := R.Next;
    if Assigned(R) then
      Rlast := R;
  end;
  //
  if Assigned(Rlast) then
  begin
    R := Rlast.Prev;
    while R <> nil do
    begin
      R1 := R.Next;
      if (R.FFiles[fileSource] = nil) and (R.FFiles[fileResult] = nil) then
      begin
        aFile := R1.GetFile(fileSource);
        if Assigned(aFile) then
        begin
          R.FFiles[fileResult] := TFileOpItemResult.Create(aFile.FileName, R.FileOpId, aFile.FNomenclature, aFile.MD5);
          R.FFiles[fileSource] := TFileOpItemSource.Create(aFile.FileName, R.FileOpId, aFile.FNomenclature, aFile.MD5);
        end;
      end;
      R := R.Prev;
    end;
  end;
end;

procedure TKisScanHistoryIndex_v1.Prepare;
var
  I, Cnt: Integer;
  Go: TKisMapScanGiveOut;
  R, Last: TKisScanHistoryRecord;
begin
  // пробегаемся по всему списку выдач
  // заполняем
  FNomenclature := aScan.Nomenclature;
  FScan := aScan;
  try
    Cnt := aScan.GiveOuts.RecordCount;
    //
    Last := nil;
    for I := 1 to Cnt do
    begin
      Go := aScan.GetGiveOut(I);
      R := TKisScanHistoryRecord.Create(FNomenclature);
      R.FIndex := I;
      if I = 1 then
        FRecord := R
      else
        Last.AddNext(R);
      R.AddFiles(FScan, Go, I);
      Last := R;
    end;
    //
    FixEmptySourceFiles();
  finally
    FScan := nil;
  end;
  FPrepared := True;
end;

{ TKisScanHistoryIndex }

destructor TKisScanHistoryIndex.Destroy;
var
  R, R1: TKisScanHistoryRecord;
begin
  R := FRecord;
  while Assigned(R) do
  begin
    R1 := R;
    R := R.Next;
    FreeAndNil(R1);
  end;
  inherited;
end;

function TKisScanHistoryIndex.FindNextFileOpId(const I: Integer): string;
var
  R: TKisScanHistoryRecord;
begin
  R := Get(I);
  while Assigned(R) do
  begin
    R := R.Next;
    if R.FileOpId <> '' then
    if (R.FileOpId <> S_FILEOP_NO_CHANGES) OR (R.FileOpId <> S_FILEOP_NO_RETURN) then
    begin
      Result := R.FileOpId;
      Exit;
    end;
  end;
  Result := '';
end;

function TKisScanHistoryIndex.FindRecord(const aFileOpId: string): TKisScanHistoryRecord;
var
  R: TKisScanHistoryRecord;
begin
  R := FRecord;
  while Assigned(R) do
  begin
    if R.FileOpId = aFileOpId then
    begin
      Result := R;
      Exit;
    end;
    R := R.Next;
  end;
  Result := nil;
end;

function TKisScanHistoryIndex.Get(const I: Integer): TKisScanHistoryRecord;
var
  R: TKisScanHistoryRecord;
begin
  R := FRecord;
  while Assigned(R) and (R.Index <> I) do
    R := R.Next;
  if Assigned(R) and (R.Index = I) then
    Result := R
  else
    Result := nil;
end;

{ TKiscanHistoryRecord }

procedure TKisScanHistoryRecord.AddFile(const aFileName, aFileOpId, aMD5: string; const aKind: TFileOperationItemKind);
begin
  FFileOpId := aFileOpId;
  case aKind of
  fileSource:
    FFiles[aKind] := TFileOpItemSource.Create(aFileName, aFileOpId, FNomenclature, aMD5);
  fileResult:
    FFiles[aKind] := TFileOpItemResult.Create(aFileName, aFileOpId, FNomenclature, aMD5);
  fileDiffZone:
    FFiles[aKind] := TFileOpItemDiffArch.Create(aFileName, aFileOpId, FNomenclature, aMD5);
  end;
end;

procedure TKisScanHistoryRecord.AddFiles(aScan: TKisMapScan; Go: TKisMapScanGiveOut; const Recno: Integer);
var
  NextGo: TKisMapScanGiveOut;
  I: Integer;
begin
  // если есть предыдущая запись в истории
  // то источником всегда будет файл результата из неё
  // если нет предыдущей, то это первая запись в истории
  // и источника просто нет
  if Assigned(FPrev) then
    CopyPrevResultAsSource()
  else
    ClearSourceFile();
  //
  if Go.Annulled then
  begin
    ClearDiffFile();
    CopySourceToResult();
    Exit;
  end;
  //
  if (Recno = 1) and (Go.MD5Old = '') then
  begin
    // это первоначальная загрузка планшета в базу
    ClearSourceFile();
    ClearDiffFile();
    if Recno < aScan.GiveOuts.RecordCount then
      NextGo := aScan.GetGiveOut(RecNo + 1)
    else
      NextGo := nil;
    AddInitialUpload(Go, NextGo);
    Exit;
  end;
  //
  if (Recno < aScan.GiveOuts.RecordCount) and (Go.MD5New = '') then
  begin
    // возврата не было в середине списка - скорее всего это ошибка
    // оформим как возврат без изменений
    ClearDiffFile();
    CopySourceToResult();
    Exit;
  end;
  //
  if (not Go.HasChangesInMap()) and (not Go.HasFileOperation()) then
  begin
    // изменений не было
    ClearDiffFile();
    CopySourceToResult();
    Exit;
  end;
  //
  if Recno < aScan.GiveOuts.RecordCount then
  begin
    I := RecNo + 1;
    repeat
      if I > aScan.GiveOuts.RecordCount then
        NextGo := nil
      else
        NextGo := aScan.GetGiveOut(I);
      Inc(I);
    until (NextGo = nil) or (not NextGo.Annulled);
    AddUpload(Go, NextGo);
  end
  else
  begin
    if Go.MD5New = '' then
    begin
      // возврата не было - значит и планшет не изменился
      ClearDiffFile();
      ClearResultFile();
    end
    else
      AddUpload(Go, nil);
  end;
end;

procedure TKisScanHistoryRecord.AddInitialUpload(Go, GoNext: TKisMapScanGiveOut);
var
  ResultFile: string;
begin
  if Assigned(GoNext) then
    ResultFile := TMapScanStorage.GetFileName(AppModule, FNomenclature, sfnArchive, GoNext.FileOperationId)
  else
  begin
    ResultFile := TMapScanStorage.GetFileName(AppModule, FNomenclature, sfnRaster);
    if not FileExists(ResultFile) then
      ResultFile := TMapScanStorage.GetFileName(AppModule, FNomenclature, sfnVector);
  end;
  if not FileExists(ResultFile) then
    ResultFile := TMapScanStorage.FindFile(AppModule, FNomenclature, Go.MD5New);
  FFileOpId := Go.FileOperationId;
  FFiles[fileResult] := TFileOpItemResult.Create(ResultFile, FFileOpId, FNomenclature, TMapScanStorage.GetMD5Hash(AppModule, ResultFile));
end;

procedure TKisScanHistoryRecord.AddNext(aRecord: TKisScanHistoryRecord);
begin
  FNext := aRecord;
  aRecord.FPrev := Self;
end;

procedure TKisScanHistoryRecord.AddUpload(Go1, Go2: TKisMapScanGiveOut);
var
  OriginalFile: string;
  ResultFile: string;
  ZoneFile: string;
  MD5Original: string;
  MD5Zone: string;
  MD5Result: string;
begin
  // есть изменения
  // надо прошерстить файлы в хранилище и найти:
  // - оригинал
  // - результат
  // - архив изменений, если он есть
  OriginalFile := TMapScanStorage.GetFileName(
        AppModule,
        FNomenclature,
        sfnArchive,
        Go1.FileOperationId);
  MD5Original := Go1.MD5Old;
  ZoneFile := TMapScanStorage.GetFileName(
        AppModule,
        FNomenclature,
        sfnArchiveZone,
        Go1.FileOperationId);
  MD5Zone := TMapScanStorage.GetMD5Hash(AppModule, ZoneFile);
  MD5Result := Go1.MD5New;
  if Go2 = nil then
  begin
    // планшет не возвращён, результатом будет актуальный планшет
    ResultFile := TMapScanStorage.GetFileName(AppModule, FNomenclature, TMapScanStorage.GetFileKind(AppModule, FNomenclature));
  end
  else
  begin
//    if not Go2.HasChangesInMap() then
//      ResultFile := OriginalFile
//    else
      // планшет был возвращён и выдан снова, результатом будет бекап планшета во второй заявке
      ResultFile := TMapScanStorage.GetFileName(AppModule, FNomenclature, sfnArchive, Go2.FileOperationId);
  end;
  FFileOpId := Go1.FileOperationId;
  FFiles[fileSource] := TFileOpItemSource.Create(OriginalFile, FFileOpId, FNomenclature, MD5Original);
  FFiles[fileResult] := TFileOpItemResult.Create(ResultFile, FFileOpId, FNomenclature, MD5Result);
  FFiles[fileDiffZone] := TFileOpItemDiffArch.Create(ZoneFile, FFileOpId, FNomenclature, MD5Zone);
end;

procedure TKisScanHistoryRecord.ClearDiffFile;
begin
  FFiles[fileDiffZone] := nil;
end;

procedure TKisScanHistoryRecord.ClearResultFile;
begin
  FFiles[fileResult] := nil;
end;

procedure TKisScanHistoryRecord.ClearSourceFile;
begin
  FFiles[fileSource] := nil;
end;

procedure TKisScanHistoryRecord.CopyPrevResultAsSource;
var
  aFile: TFileOperationItem;
  SourceFile, MD5: string;
begin
  if Assigned(FPrev) then
  begin
    aFile := FPrev.GetFile(fileResult);
    if aFile <> nil then
    begin
      SourceFile := aFile.FileName;
      MD5 := aFile.MD5;
    end
    else
    begin
      SourceFile := '';
      MD5 := '';
    end;
    FFiles[fileSource] := TFileOpItemSource.Create(SourceFile, FFileOpId, FNomenclature, MD5);
  end;
end;

procedure TKisScanHistoryRecord.CopySourceToResult;
var
  aFile: TFileOperationItem;
begin
  aFile := FFiles[fileSource];
  if aFile <> nil then
    FFiles[fileResult] := TFileOpItemResult.Create(aFile.FileName, FFileOpId, FNomenclature, aFile.MD5)
  else
    FFiles[fileResult] := nil;
end;

constructor TKisScanHistoryRecord.Create(const aNomenclature: string);
begin
  inherited Create;
  FNomenclature := aNomenclature;
  FFiles[fileSource] := nil;
  FFiles[fileResult] := nil;
  FFiles[fileDiffZone] := nil;
end;

destructor TKisScanHistoryRecord.Destroy;
var
  Tmp: TObject;
begin
  Tmp := FFiles[fileSource];
  FreeAndNil(Tmp);
  Tmp := FFiles[fileResult];
  FreeAndNil(Tmp);
  Tmp := FFiles[fileDiffZone];
  FreeAndNil(Tmp);
  //
  inherited;
end;

function TKisScanHistoryRecord.GetFile(aKind: TFileOperationItemKind): TFileOperationItem;
begin
  Result := FFiles[aKind];
end;

function TKisScanHistoryRecord.HasDiffZone: Boolean;
begin
  Result := FFiles[fileDiffZone] <> nil;
end;

function TKisScanHistoryRecord.HasSource: Boolean;
begin
  Result := FFiles[fileSource] <> nil;
end;

procedure TKisScanHistoryRecord.SetFileOpId(const Value: string);
begin
  FFileOpId := Value;
end;

end.
