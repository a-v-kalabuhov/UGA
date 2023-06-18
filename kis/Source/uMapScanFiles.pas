unit uMapScanFiles;

interface

uses
  Windows, SysUtils, Classes, Graphics, ComObj, jpeg, StrUtils,
  MD5, 
  uFileUtils, uGC, uCommonUtils, uGraphics, uGeoUtils, uAutoCAD,
  uKisUtils, uKisIntf,
  uKisAppModule,
  uKisExceptions, uKisTakeBackFiles, uKisMapScanGeometry;

type
  TScanFileState = (sfsNamePrepared, sfsHashOld, sfsHashNew, sfsHashDiff, sfsDiffZone);
  TScanFileKind = (sfkDB, sfkUpload, sfkDiff);
  TScanFileStates = set of TScanFileState;
  TMapScanFile = record
//  public
    Nomenclature: String;
    // файл на флешке
    FullFileName: String;
    // файл в базе планшетов
    DBFileName: String;
    // результат сравнения
    DiffFileName: String;
    // хэш файла в базе
    MD5HashOld: String;
    // хэш файла на флешке
    MD5HashNew: String;
    // хэш файла изменений
    MD5HashDiff: String;
    // ID файла для сохранения истории
    FileOpId: string;
    State: TScanFileStates;
    TakeBackKind: TTakeBackKind;
    Log: string;
    //
    procedure Clear;
    function GetNewHash: string;
    function PrepareBitmap(const DBorFull, CalcHash: Boolean): TBitmap;
    /// <summary>
    /// заполняет DBFileName    
    /// </summary>
    procedure PrepareFileName(Folders: IKisFolders; const aFullFileName: String);
    procedure PrepareHash(Kind: TScanFileKind);
    //
    procedure AddLogLine(const aLine: String);
    function AsText(AddLog: Boolean = False): string;
    function GetTBKindName: string;
    function StateAsText: string;
    //
    function SourceFile: string;
    function ResultFile: string;
    function DiffFile: string;
  end;
  TMapScanArray = array of TMapScanFile;

  TScanFileName = (
    sfnRaster,          // скан планшета
    sfnVector,      // векторный планшет
    sfnFormular,    // скан формуляра физического планшета
    sfnArchive,     // архивная копия скана планшета
    sfnArchiveZone, // архивная копия скана планшета
    sfnMiniDiff     // миниатюра области изменений
  );

  TMapScanStorage = class
  strict private
    procedure PrepareMini(var Scan: TMapScanFile; const Scale: Integer; aMiniFileName: String);
  private
    class var FJpegForVectorZones: Boolean;
  public
    const PackZoneFiles = True;
    const VectorExt: array[0..1] of string = ('.DXF', '.DWG');
    class function GetFileKind(Folders: IKisFolders; const Nomenclature: string): TScanFileName;
    class function GetFileName(Folders: IKisFolders; const Nomenclature: string; const Kind: TScanFileName; Param: String = ''): string;
    class function GetMD5Hash(Folders: IKisFolders; const Nomenclature: string; Vector: Boolean): string; overload;
    class function GetMD5Hash(Folders: IKisFolders; const aFileName: string): string; overload;
    class function IsGraphicFile(const FileName: String): Boolean;
    class function IsPacked(const FileName: String): Boolean;
    class function FindFile(Folders: IKisFolders; const Nomenclature: string; const MD5: String): string;
    class function FileIsVector(const aFilename: string): Boolean;
    class function HasVectorFile(Folders: IKisFolders; const Nomenclature: string): Boolean;
    class function GenMapZoneShortFileName(const Nomenclature: string): string;
    function GetVectorZoneFileName(const aVectorFile: string; const aNomenclature: string): string;
    /// <summary>
    /// Создаём картинки и копируем их в указанную папку.
    /// </summary>
    function DownloadMap(Folders: IKisFolders; aGeometry: TKisMapScanGeometry;
      const Nomenclature, TargetDir: string): Boolean;
    /// <summary>
    ///   Используется для загрузки новых версий планшета с изменениями
    /// </summary>
    procedure UploadDBFile(Folders: IKisFolders; var Scan: TMapScanFile);
    /// <summary>
    ///   Используется для загрузки первой версии планшета
    /// </summary>
    procedure UploadFile(Folders: IKisFolders; const Nomenclature, Source, FileOpId: string; SourceHash: string = '');
    /// <summary>
    ///   Используется для загрузки отсканированного формуляра планшета
    /// </summary>
    procedure UploadHistoryFile(Folders: IKisFolders; const Nomenclature, Source: string);
    //
    /// <summary>
    ///   Максимальное количество планшетов в локальном хранилище.
    /// </summary>
//    property LocalMaxCount: Integer read FLocalMaxCount;
    /// <summary>
    ///   Путь к локальному хранилищу.
    /// </summary>
//    property LocalStore: string read FLocalStore;
    class property JpegForVectorZones: Boolean read FJpegForVectorZones write FJpegForVectorZones;
  end;

  TMapFileName = class
  private const
    ArchFileMask = '%s__%s__%s%s';
    DATE_FORMAT = '_yyyy.mm.dd.hh.mm.ss';
    DATE_FORMAT2 = 'yyyy.mm.dd.hh.mm.ss';
  public
    /// <summary>
    ///   Старая схема имён файлов - номенклатура_операция_время_типфайла
    /// </summary>
    class function MakeArchiveMask(const Nomenclature, FileOpId: string): string;
    class function MakeArchiveZoneMask(const Nomenclature, FileOpId: string): string;
    class function MakeDiffZone(Nomenclature, FileOpId, aFileExt: string; aDateTime: TDateTime): string;
    class function MakeUploadDbBackup(Nomenclature, FileOpId, aFileExt: string; aDateTime: TDateTime): string;
    /// <summary>
    ///   Новая схема имён файлов - номенклатура_время_операция_типфайла
    /// </summary>
    class function MakeArchiveMask2(const Nomenclature, FileOpId, FileExt: string): string;
    class function MakeArchiveZoneMask2(const Nomenclature, FileOpId, FileExt: string): string;
    class function MakeUploadDbBackup2(Nomenclature, FileOpId, aFileExt: string; aDateTime: TDateTime): string;
  end;

  TMapImage = class
  public
    class function CreateMapImage(BackColor: TColor = clNone): TBitmap;
  end;

  IMapStorageFileDownloader = interface
    ['{C86AE5FC-FFDF-41D2-8A3D-69BD40CE0DE5}']
    function Download(aGeometry: TKisMapGeometry; const TargetDir: string): Boolean;
  end;

const
  MAP_SCAN_EXT = '.bmp';
  MD5_EXT = '.md5';
  MD5V_EXT = '.md5v';
  MINI_EXT = '.mini';

  CL_MAP_SCAN_BACK = $7F007F;

  SZ_MAP_PX = 5906;
  SZ_MAP_HALF_PX = SZ_MAP_PX div 2;

var
  theMapScansStorage: TMapScanStorage;

implementation

type
  TRasterDownloader = class(TInterfacedObject, IMapStorageFileDownloader)
  private
    FStorage: TMapScanStorage;
    FFolders: IKisFolders;
    FNomenclature: string;
    function Download(MapGeometry: TKisMapGeometry; const TargetDir: string): Boolean;
  public
    constructor Create(aStorage: TMapScanStorage; Folders: IKisFolders; const Nomenclature: string);
  end;

  TVectorDownloader = class(TInterfacedObject, IMapStorageFileDownloader)
  private
    FStorage: TMapScanStorage;
    FFolders: IKisFolders;
    FNomenclature: string;
    //
    function Download(MapGeometry: TKisMapGeometry; const TargetDir: string): Boolean;
  private
    FTargetDir: string;
    FRasterTempFile: string;
    FRasterSourceFile: string;
    FRasterTargetFile: string;
    FVectorTempFile: string;
    FVectorSourceFile: string;
    FVectorTargetFile: string;
    FTempPath: string;
    //
    procedure CreateTempFolder();
    procedure PrepareRasterToTemp(MapGeometry: TKisMapGeometry; out CopiedToTemp: Boolean);
    function CopyTempRasterToTarget(): Boolean;
    function CopyVectorToTemp(): Boolean;
    function AddRasterToTempVector(): Boolean;
    function CopyFilesToTarget(): Boolean;
    procedure DeleteTempRaster();
    procedure DeleteTempVector();
  public
    constructor Create(aStorage: TMapScanStorage; Folders: IKisFolders; const Nomenclature: string);
  end;

{ TMapScanFile }

procedure TMapScanFile.PrepareHash;
var
  HashFile: string;
  Loaded: Boolean;
begin
  case Kind of
  sfkDB :
    begin
      if theMapScansStorage.FileIsVector(DBFileName) then
        HashFile := ChangeFileExt(DBFileName, MD5V_EXT)
      else
        HashFile := ChangeFileExt(DBFileName, MD5_EXT);
      Loaded := FileExists(HashFile);
      if Loaded then
      begin
        MD5HashOld := TFileUtils.ReadFile(HashFile);
        Loaded := MD5HashOld <> '';
      end;
      if not Loaded then
        if FileExists(DBFileName) then
        begin
          MD5HashOld := MD5DigestToStr(MD5File(DBFileName));
          TFileUtils.WriteFile(HashFile, MD5HashOld);
        end
        else
          MD5HashOld := '';
      State := State + [sfsHashOld];
    end;
  sfkUpload :
    begin
      if FileExists(FullFileName) then
        MD5HashNew := MD5DigestToStr(MD5File(FullFileName))
      else
        MD5HashNew := '';
      State := State + [sfsHashNew];
    end;
  sfkDiff :
    begin
      if FileExists(DiffFileName) then
        MD5HashDiff := MD5DigestToStr(MD5File(DiffFileName))
      else
        MD5HashDiff := '';
      State := State + [sfsHashDiff];
    end;
  end;
end;

function TMapScanFile.ResultFile: string;
begin
  if TakeBackKind = tbEntireMap then
    Result := FullFileName
  else
    Result := FullFileName;
end;

function TMapScanFile.SourceFile: string;
begin
  Result := DBFileName;
end;

function TMapScanFile.StateAsText: string;
begin
  Result := '';
  if sfsNamePrepared in State then
    Result := Result + IfThen(Result <> '', ', ', '') + 'sfsNamePrepared';
  if sfsHashOld in State then
    Result := Result + IfThen(Result <> '', ', ', '') + 'sfsHashOld';
  if sfsHashNew in State then
    Result := Result + IfThen(Result <> '', ', ', '') + 'sfsHashNew';
  if sfsHashDiff in State then
    Result := Result + IfThen(Result <> '', ', ', '') + 'sfsHashDiff';
  if sfsDiffZone in State then
    Result := Result + IfThen(Result <> '', ', ', '') + 'sfsDiffZone';
  Result := '[' + Result + ']';
end;

procedure TMapScanFile.AddLogLine(const aLine: String);
begin
  if aLine <> '' then
  begin
    if Log <> '' then
      Log := Log + sLineBreak;
    Log := Log + aLine;
  end;
end;

function TMapScanFile.AsText(AddLog: Boolean): string;
const
  Delim = sLineBreak;//'; ';
begin
  Result :=
    'Номенклатура:                    ' + Nomenclature + Delim +
    'Готовый новый планшет:           ' + FullFileName + Delim +
    'Файл в базе планшетов:           ' + DBFileName + Delim +
    'Область изменений:               ' + DiffFileName + Delim +
    'Хэш файла в базе:                ' + MD5HashOld + Delim +
    'Хэш нового планшета:             ' + MD5HashNew + Delim +
    'Хэш файла изменений:             ' + MD5HashDiff + Delim +
    'ID файла для сохранения истории: ' + FileOpId + Delim +
    'Состояние:                       ' + StateAsText() + Delim +
    'Статус приёма:                   ' + GetTBKindName() + '.';
  if AddLog then
    Result := Result + sLineBreak + 'Лог оперций: ' + sLineBreak + Log; 
end;

procedure TMapScanFile.Clear;
begin
  Nomenclature := '';
  FullFileName := '';
  DBFileName := '';
  DiffFileName := '';
  MD5HashOld := '';
  MD5HashNew := '';
  State := [];
  Log := '';
end;

function TMapScanFile.DiffFile: string;
begin
  Result := DiffFileName;
end;

function TMapScanFile.GetNewHash: string;
begin
  if sfsDiffZone in State then
    Result := MD5HashDiff
  else
    Result := MD5HashNew;
end;

function TMapScanFile.GetTBKindName: string;
begin
  case TakeBackKind of
    tbNone: Result := 'Нет приёма';
    tbNoChanges: Result := 'Планшет принят без изменений';
    tbEntireMap: Result := 'Принят планшет целиком';
    tbZones: Result := 'Принята область изменений';
  end;
end;

function TMapScanFile.PrepareBitmap(const DBorFull, CalcHash: Boolean): TBitmap;
var
  aFile, Hash: String;
  Stream: TStream;
  Tmp: TBitmap;
begin
  if DBorFull then
    aFile := DBFileName
  else
    aFile := FullFileName;
  Result := TBitmap.Create;
  try
    Result.PixelFormat := pf24bit;
    ///
    if not FileExists(aFile) then
      Sleep(500);
    if not FileExists(aFile) then
      Sleep(500);
    if FileExists(aFile) then
    begin
      Stream := TFileStream.Create(aFile, fmOpenRead or fmShareDenyWrite);
      Stream.Forget;
      if CalcHash then
      begin
        try
          Hash := MD5DigestToStr(MD5Stream(Stream));
          if DBorFull then
          begin
            MD5HashOld := Hash;
            State := State + [sfsHashOld];
          end
          else
          begin
            MD5HashNew := Hash;
            State := State + [sfsHashNew];
          end;
        finally

        end;
        Stream.Position := 0;
        if theMapScansStorage.FileIsVector(aFile) then
        begin
          Result := TAutoCADUtils.ExportToBitmap(aFile, SZ_MAP_PX, SZ_MAP_PX);
        end
        else
        begin
          Tmp := nil;
          try
            Tmp := TBitmap.CreateFromStream(Stream, ExtractFileExt(aFile));
            Result.CopyFrom(Tmp, True);
            {$IFDEF GRAPHICS_16_BIT}
            Result.PixelFormat := pf16bit;
            {$ENDIF}
          finally
            FreeAndNil(Tmp);
          end;
        end;
      end;
    end
    else
    begin
      AddLogLine('Файл отсутствует в базе: ' + aFile);
      FreeAndNil(Result);
    end;
  except
    on E: Exception do
    begin
      FreeAndNil(Result);
      AddLogLine(
        IfThen(Log <> '', sLineBreak, '') +
        'TMapScanFile.PrepareBitmap: exception ' + E.ClassName +
        ' with message "' + E.Message + '"' + sLineBreak +
        'File: ' + aFile);
      AppModule.LogException(E, GetDebugInfo());
      raise E;
    end;
  end;
end;

procedure TMapScanFile.PrepareFileName(Folders: IKisFolders; const aFullFileName: String);
var
  aFileName, Ext: string;
  N: TNomenclature;
  FileKind: TScanFileName;
begin
  if aFullFileName <> '' then
    FullFileName := aFullFileName;
  aFileName := ExtractFileName(FullFileName);
  Ext := ExtractFileExt(aFileName);
  if Ext <> '' then
    SetLength(aFileName, Length(aFileName) - Length(Ext));
  //
  N := TGeoUtils.GetNomenclature(aFileName, True);
  if N.Valid then
  begin
    Nomenclature := N.Nomenclature();
    if theMapScansStorage.HasVectorFile(Folders, Nomenclature) then
      FileKind := sfnVector
    else
      FileKind := sfnRaster;
    DBFileName := theMapScansStorage.GetFileName(Folders, Nomenclature, FileKind);
  end
  else
  begin
    Nomenclature := '';
    DBFileName := '';
  end;
  State := State + [sfsNamePrepared];
end;

{ TMapScanStorage }

function TMapScanStorage.DownloadMap(Folders: IKisFolders; aGeometry: TKisMapScanGeometry;
      const Nomenclature, TargetDir: string): Boolean;
var
  MapGeometry: TKisMapGeometry;
  Downloader: IMapStorageFileDownloader;
begin
  Result := False;
  MapGeometry := aGeometry.GetMapGeometry(Nomenclature);
  if MapGeometry.Skip then
    Exit;
  if HasVectorFile(Folders, Nomenclature) then
    Downloader := TVectorDownloader.Create(Self, Folders, Nomenclature)
  else
    Downloader := TRasterDownloader.Create(Self, Folders, Nomenclature);
  Result := Downloader.Download(MapGeometry, TargetDir);
end;

class function TMapScanStorage.FileIsVector(const aFilename: string): Boolean;
var
  FileExt: string;
  I: Integer;
begin
  FileExt := AnsiUpperCase(ExtractFileExt(aFilename));
  for I := 0 to Length(VectorExt) - 1 do
  begin
    if FileExt = VectorExt[I] then
    begin
      Result := True;
      Exit;
    end;
  end;
  Result := False;
end;

class function TMapScanStorage.FindFile(Folders: IKisFolders; const Nomenclature, MD5: String): string;
var
  MapFile: string;
  MapPath, SearchMask: string;
  GraphicMask: string;
  FoundFiles, GraphicFiles: TStringList;
  I, J, K: Integer;
  Md5Value: string;
  FoundFileName: string;
begin
  Result := '';
  MapFile := GetFileName(Folders, Nomenclature, sfnRaster);
  MapPath := ExtractFilePath(MapFile);
  SearchMask := TPath.Finish(MapPath, '*.md5');
  FoundFiles := TStringList.Create;
  FoundFiles.Forget();
  GraphicFiles := TStringList.Create;
  GraphicFiles.Forget();
  TFileUtils.FindFiles(SearchMask, FoundFiles);
  for I := 0 to FoundFiles.Count - 1 do
  begin
    FoundFileName := TPath.Finish(MapPath, FoundFiles[I]);
    Md5Value := TFileUtils.ReadFile(FoundFileName);
    if Md5Value = MD5 then
    begin
      GraphicMask := ChangeFileExt(FoundFileName, '') + '.*';
      GraphicFiles.Clear();
      TFileUtils.FindFiles(GraphicMask, GraphicFiles);
      // 
      K := GraphicFiles.IndexOf(FoundFiles[I]);
      if K >= 0 then
        GraphicFiles.Delete(K);
      K := GraphicFiles.IndexOf(ChangeFileExt(FoundFiles[I], MAP_SCAN_EXT));
      //
      J := 0;
      while (K < 0) and (J < Length(TMapScanStorage.VectorExt)) do
      begin
        K := GraphicFiles.IndexOf(ChangeFileExt(FoundFiles[I], TMapScanStorage.VectorExt[J]));
        Inc(J);
      end;
      if K >= 0 then
      begin
        Result := GraphicFiles[K];
        Exit;
      end;
      if GraphicFiles.Count > 0 then
        Result := GraphicFiles[0];
      Exit;
    end;
  end;
end;

class function TMapScanStorage.GenMapZoneShortFileName(const Nomenclature: string): string;
var
  N: TNomenclature;
begin
  N.Init(Nomenclature, False);
  Result := N.Nomenclature + '_work_zone';
  if JpegForVectorZones then
    Result := Result + '.jpg'
  else
    Result := Result + '.bmp';
end;

class function TMapScanStorage.GetFileKind(Folders: IKisFolders; const Nomenclature: string): TScanFileName;
begin
  if HasVectorFile(Folders, Nomenclature) then
    Result := sfnVector
  else
    Result := sfnRaster;
end;

class function TMapScanStorage.GetFileName(Folders: IKisFolders; const Nomenclature: string;
  const Kind: TScanFileName; Param: String): string;
var
  L: TStrings;
  aPath: IPath;
  aMask, aFile, FoundFile: string;
  I: Integer;
  N: TNomenclature;
  Found: Boolean;
begin
  Result := '';
  //
  N.Init(Nomenclature, True);
  if N.Valid then
  begin
    L := N.AsStrings(PathDelim);
    aPath := TPath.Build(Folders.MapScansPath, L.DelimitedText);
    //
    case Kind of
    sfnRaster :
      begin
        Result := aPath.Finish(N.Nomenclature(), MAP_SCAN_EXT).Path();
        if not FileExists(Result) then
        begin
          L.Clear;
          aMask := ChangeFileExt(Result, '.*');
          TFileUtils.FindFiles(aMask, L);
          if L.Count > 0 then
          begin
            FoundFile := '';
            I := 0;
            while (I < L.Count) and (FoundFile = '') do
            begin
              aFile := aPath.Finish(L[I]).Path();
              if IsGraphicFile(aFile) then
                FoundFile := aFile;
              Inc(I);
            end;
            if FoundFile <> '' then
              Result := FoundFile;
          end;
        end;
      end;
    sfnVector :
      begin
        I := 0;
        Found := False;
        while not Found and (I < Length(VectorExt)) do
        begin
          Result := aPath.Finish(N.Nomenclature(), VectorExt[I]).Path();
          Found := FileExists(Result);
          Inc(I);
        end;
      end;
    sfnFormular :
      begin
        // Param содержит расширение файла
        if Param <> '' then
        begin
          Result := aPath.Finish(N.Nomenclature() + '_formular', Param).Path();
          if not FileExists(Result) then
            Param := '';
        end;
        //
        if Param = '' then
        begin
          Result := '';
          aMask := aPath.Finish(N.Nomenclature() + '_formular.*').Path();
          TFileUtils.FindFile(aMask, Result);
          if Result = '' then
            Result := aPath.Finish(N.Nomenclature() + '_formular', MAP_SCAN_EXT).Path()
          else
            Result := aPath.Finish(Result).Path();
        end;
      end;
    sfnMiniDiff :
      begin
        Result := GetFileName(Folders, Nomenclature, sfnArchiveZone, Param);
        Result := ExtractFilePath(Result) +
                  ChangeFileExt(ExtractFileName(Result), '') + '.mini' +
                  ExtractFileExt(Result);
      end;
    sfnArchive :
      begin
        L.Clear;
        aMask := aPath.Finish(TMapFileName.MakeArchiveMask(Nomenclature, Param)).Path();
        TFileUtils.FindFiles(aMask, L);
        if L.Count > 0 then
        begin
          I := 0;
          while (I < L.Count) and (Result = '') do
          begin
            aFile := aPath.Finish(L[I]).Path();
            if IsGraphicFile(aFile) or IsPacked(aFile) or FileIsVector(aFile) then
            begin
              if not EndsText('mini' + ExtractFileExt(aFile), aFile) then
                Result := aFile;
            end;
            Inc(I);
          end;
        end;
      end;
    sfnArchiveZone :
      begin
        L.Clear;
        //aMask := TPath.Combine(aPath.Path(), Format(ArchFileMask, [Nomenclature + '_zone', Param, '_*', '']));
        aMask := aPath.Finish(TMapFileName.MakeArchiveZoneMask(Nomenclature, Param)).Path();
        TFileUtils.FindFiles(aMask, L);
        if L.Count = 0 then
        begin
          aMask := aPath.Combine(TMapFileName.MakeArchiveZoneMask2(Nomenclature, Param, '.*')).Path();
          TFileUtils.FindFiles(aMask, L);
        end;
        if L.Count > 0 then
        begin
          I := 0;
          while (I < L.Count) and (Result = '') do
          begin
            aFile := aPath.Finish(L[I]).Path();
            if IsGraphicFile(aFile) or IsPacked(aFile) then
            begin
              if not EndsText('mini' + ExtractFileExt(aFile), aFile) then
                Result := aFile;
            end;
            Inc(I);
          end;
        end;
      end;
    end;
  end;
end;

class function TMapScanStorage.GetMD5Hash(Folders: IKisFolders; const aFileName: string): string;
var
  HashFile, Ext: string;
  FileKind: TScanFileName;
begin
  Result := '';
  if FileExists(aFileName) then
  begin
    if FileIsVector(aFileName) then
      HashFile := ChangeFileExt(aFileName, MD5V_EXT)
    else
      HashFile := ChangeFileExt(aFileName, MD5_EXT);
    if FileExists(HashFile) then
      Result := TFileUtils.ReadFile(HashFile)
    else
    begin
      Result := MD5DigestToStr(MD5File(aFileName));
      try
        TFileUtils.WriteFile(HashFile, Result);
      except
      end;
    end;
  end;
end;

class function TMapScanStorage.GetMD5Hash(Folders: IKisFolders; const Nomenclature: string; Vector: Boolean): string;
var
  MapFile, HashFile, Ext: string;
  FileKind: TScanFileName;
begin
  Result := '';
  if Vector then
    FileKind := sfnVector
  else
    FileKind := sfnRaster;
  MapFile := GetFileName(Folders, Nomenclature, FileKind);
  if FileExists(MapFile) then
  begin
    if Vector then
      Ext := MD5V_EXT
    else
      Ext := MD5_EXT;
    HashFile := ChangeFileExt(MapFile, Ext);
    if FileExists(HashFile) then
      Result := TFileUtils.ReadFile(HashFile)
    else
    begin
      Result := MD5DigestToStr(MD5File(MapFile));
      if FileExists(MapFile) then
      try
        TFileUtils.WriteFile(HashFile, Result);
      except
      end;
    end;
  end;
end;

function TMapScanStorage.GetVectorZoneFileName(const aVectorFile, aNomenclature: string): string;
var
  ShortName: string;
begin
  ShortName := GenMapZoneShortFileName(aNomenclature);
  Result := TPath.Finish(ExtractFilePath(aVectorFile), ShortName);
end;

class function TMapScanStorage.HasVectorFile(Folders: IKisFolders; const Nomenclature: string): Boolean;
var
  VectorFileName: string;
begin
  VectorFileName := GetFileName(Folders, Nomenclature, sfnVector);
  Result := FileExists(VectorFileName);
end;

class function TMapScanStorage.IsGraphicFile(const FileName: String): Boolean;
var
  Ext: string;
begin
  Ext := AnsiUpperCase(ExtractFileExt(FileName));
  Result := (Ext = '.BMP') or (Ext = '.JPG') or (Ext = '.JPEG') or (Ext = '.PNG') or (Ext = '.TIFF');
end;

class function TMapScanStorage.IsPacked(const FileName: String): Boolean;
var
  Ext: string;
begin
  Ext := AnsiUpperCase(ExtractFileExt(FileName));
  Result := (Ext = '.ZIP');
end;

procedure TMapScanStorage.PrepareMini(var Scan: TMapScanFile; const Scale: Integer; aMiniFileName: String);
var
  Bmp, MiniBmp: TBitmap;
  MiniJpg: TJPEGImage;
begin
  try
    // грузим файл
    Bmp := TBitmap.CreateFromFile(Scan.DiffFileName);
    Bmp.Forget();
    // создаём приёмник в 2 раза меньше размеров
    MiniBmp := TBitmap.Create;
    MiniBmp.Forget();
    MiniBmp.SetSize(Bmp.Width div Scale, Bmp.Height div Scale);
    // копируем
    MiniBmp.Canvas.StretchDraw(Rect(0, 0, MiniBmp.Width, MiniBmp.Height), Bmp);
    Scan.AddLogLine('Миниатюра подготовлена');
    //
    MiniJpg := TJPEGImage.Create;
    MiniJpg.Forget();
    MiniJpg.Assign(MiniBmp);
    // сохраняем
    aMiniFileName := ChangeFileExt(aMiniFileName, '.jpg');
    MiniJpg.SaveToFile(aMiniFileName);
//    MiniBmp.SaveToFile(aMiniFileName);
    Scan.AddLogLine('Миниатюра сохранена в "' + aMiniFileName + '"');
  except
    on E: Exception do
      Scan.AddLogLine('Ошибка в TMapScanStorage.PrepareMini - ' + E.ClassName + ': ' + E.Message);
  end;
end;

procedure TMapScanStorage.UploadDBFile;
var
  OldFilePath: string;
  OldFile,
  ArchFile, // копируем текущий планшет в архивный файл
  HashFile, ArchHashFile, NewFile: string;
  DiffZoneFile, DiffZoneHashFile: string;
  TmpZoneZipFile: string;
  OverWrit, B: Boolean;
  Msg: string;
  Error1: string;
const
  S_COPY_OK = 'Файл скопирован: из "%s" в "%s"';
  S_COPY_BAD = 'Ошибка копирования файла: из "%s" в "%s"';
  S_CREATE_OK = 'Файл создан: "%s"';
  S_CREATE_BAD = 'Ошибка создания файла: "%s"';
  S_FILES_EQUAL = 'Файл не изменился - копировать в базу нет необходимости!';
  S_FOLDER_OK = 'Папка есть/создана: "%s"';
  S_FOLDER_BAD = 'Не удалсь создать папку: "%s"';
  S_OVERWRITE_OK = 'Файл перезаписан: из "%s" в "%s"';
  S_OVERWRITE_BAD = 'Ошибка перезаписи файла: из "%s" в "%s"';
  S_PACK_OK = 'Файл упакован: из "%s" в "%s"';
  S_PACK_BAD = 'Ошибка упаковки файла: из "%s" в "%s"';
  S_RENAME_OK = 'Файл переименован: из "%s" в "%s"';
  S_RENAME_BAD = 'Ошибка при переименовании файла: из "%s" в "%s"';
  S_WRITE_OK = 'Файл записан: "%s"';
  S_WRITE_BAD = 'Ошибка записи файла: "%s"';
  S_ZONE_NOT_FOUND = 'Файл области изменений не найден: "%s"';
begin
  // перебираем файлы
  try
    if not (sfsHashOld in Scan.State) then
      Scan.PrepareHash(sfkDB);
    if not (sfsHashNew in Scan.State) then
      Scan.PrepareHash(sfkUpload);
    //
    if Scan.TakeBackKind <> tbNoChanges then  // если нет изменений то не копируем файл
//    if (Scan.MD5HashOld <> Scan.MD5HashNew) or (sfsDiffZone in Scan.State) then  // если нет изменений то не копируем файл
    begin
      if not (sfsNamePrepared in Scan.State) then
        Scan.PrepareFileName(Folders, '');
      // пути и имена файлов
      OldFile := Scan.DBFileName;
      OldFilePath := ExtractFilePath(OldFile);
      B := ForceDirectories(OldFilePath);
      Scan.AddLogLine(Format(IfThen(B, S_FOLDER_OK, S_FOLDER_BAD), [OldFilePath]));
      //
//      ArchFile := TPath.Finish(
//          OldFilePath,
//          Format(ArchFileMask,
//                  [Scan.Nomenclature, Scan.FileOpId, FormatDateTime(DATE_FORMAT, Now), ExtractFileExt(OldFile)])
//      );
      ArchFile := TPath.Finish(
          OldFilePath,
          TMapFileName.MakeUploadDbBackup(Scan.Nomenclature, Scan.FileOpId, ExtractFileExt(OldFile), Now)
      );
      if FileIsVector(OldFile) then
      begin
        HashFile := ChangeFileExt(OldFile, MD5V_EXT);
        ArchHashFile := ChangeFileExt(ArchFile, MD5V_EXT);
      end
      else
      begin
        HashFile := ChangeFileExt(OldFile, MD5_EXT);
        ArchHashFile := ChangeFileExt(ArchFile, MD5_EXT);
      end;
      NewFile := Scan.FullFileName;
      // смотрим существует ли старый файл
      if FileExists(OldFile) then
      begin
        // если он есть, то переименовываем его
        B := TFileUtils.RenameFile(OldFile, ArchFile);
        if {B} False then
        begin
          if TFileUtils.PackFile(ArchFile, '', [packConvertFilenamesToOEM]) then
            TFileUtils.DeleteFile(ArchFile);
        end;
        Scan.AddLogLine(Format(IfThen(B, S_RENAME_OK, S_RENAME_BAD), [OldFile, ArchFile]));
        //
        if FileExists(HashFile) then
        begin
          B := TFileUtils.RenameFile(HashFile, ArchHashFile);
          Scan.AddLogLine(Format(IfThen(B, S_RENAME_OK, S_RENAME_BAD), [HashFile, ArchHashFile]));
        end
        else
        begin
          B := TFileUtils.WriteFile(ArchHashFile, Scan.MD5HashOld);
          Scan.AddLogLine(Format(IfThen(B, S_CREATE_OK, S_CREATE_BAD), [ArchHashFile]));
        end;
      end;
      // копируем новый файл на место старого
      OverWrit := FileExists(OldFile);
      B := TFileUtils.CopyFile(NewFile, OldFile, OverWrit, Error1);
      if OverWrit then
        Msg := IfThen(B, S_OVERWRITE_OK, S_OVERWRITE_BAD)
      else
        Msg := IfThen(B, S_COPY_OK, S_COPY_BAD);
      if not B then
        Msg := Msg + sLineBreak + Error1;
      Scan.AddLogLine(Format(Msg, [NewFile, OldFile]));
      //
      OverWrit := FileExists(HashFile);
      B := TFileUtils.WriteFile(HashFile, Scan.MD5HashNew);
      if OverWrit then
        Msg := IfThen(B, S_WRITE_OK, S_WRITE_BAD)
      else
        Msg := IfThen(B, S_CREATE_OK, S_CREATE_BAD);
      Scan.AddLogLine(Format(Msg, [HashFile]));
      // теперь область изменений
      if sfsDiffZone in Scan.State then
      begin
        if not FileExists(Scan.DiffFileName) then
          Scan.AddLogLine(Format(S_ZONE_NOT_FOUND, [Scan.DiffFileName]))
        else
        begin
          DiffZoneFile := TPath.Finish(
              OldFilePath,
              TMapFileName.MakeDiffZone(Scan.Nomenclature, Scan.FileOpId, ExtractFileExt(Scan.DiffFileName), Now)
          );
          DiffZoneHashFile := ChangeFileExt(DiffZoneFile, MD5_EXT);
          if PackZoneFiles = True then
          begin
            DiffZoneFile := ChangeFileExt(DiffZoneFile, '.zip');
            TmpZoneZipFile := TFileUtils.GenerateTempFileName(AppModule.AppTempPath);
            TmpZoneZipFile := ChangeFileExt(TmpZoneZipFile, '.zip');
            B := TFileUtils.PackFile(Scan.DiffFileName, TmpZoneZipFile, [packConvertFilenamesToOEM]);
            Scan.AddLogLine(Format(IfThen(B, S_PACK_OK, S_PACK_BAD), [Scan.DiffFileName, TmpZoneZipFile]));
            if B then
            begin
              B := TFileUtils.CopyFile(TmpZoneZipFile, DiffZoneFile, True, Error1);
              Msg := Format(IfThen(B, S_COPY_OK, S_COPY_BAD), [Scan.DiffFileName, DiffZoneFile]);
              if not B then
                Msg := Msg + sLineBreak + Error1;
              Scan.AddLogLine(Msg);
              TFileUtils.DeleteFile(TmpZoneZipFile);
            end;
          end
          else
          begin
            B := TFileUtils.CopyFile(Scan.DiffFileName, DiffZoneFile, True);
            Scan.AddLogLine(Format(IfThen(B, S_COPY_OK, S_COPY_BAD), [Scan.DiffFileName, DiffZoneFile]));
          end;
          //
          if not (sfsHashDiff in Scan.State) then
            Scan.PrepareHash(sfkDiff);
          B := TFileUtils.WriteFile(DiffZoneHashFile, Scan.MD5HashDiff);
          Scan.AddLogLine(Format(IfThen(B, S_CREATE_OK, S_CREATE_BAD), [DiffZoneHashFile]));
          // делаем миниатюру для истории
          if FileExists(Scan.DiffFileName) then
          begin
            // делаем файл миниатюру
            PrepareMini(Scan, 10, ChangeFileExt(DiffZoneFile, MINI_EXT) + MAP_SCAN_EXT);
          end;
        end
      end
      else
      begin
        // TODO : надо сделать миниатюру планшета, если был принят целиком планшет
      end;
    end
    else
      Scan.AddLogLine(S_FILES_EQUAL + sLineBreak +
        ' DB: [' + Scan.DBFileName + ']' + sLineBreak +
        ' New: [' + Scan.FullFileName + ']' + sLineBreak +
        ' Zone: [' + Scan.DiffFileName + ']');
  except
    raise;
  end;
  // если всё прошло гладко, то отправляем файлы в дополнительную папку 
  if DirectoryExists(Folders.MapScansTempPath) then
  begin
    OldFile := Scan.FullFileName;
    NewFile := TPath.Finish(Folders.MapScansTempPath, Scan.Nomenclature, ExtractFileExt(OldFile));
    TFileUtils.CopyFile(OldFile, NewFile, True, True);
  end;
end;

procedure TMapScanStorage.UploadFile(Folders: IKisFolders; const Nomenclature, Source, FileOpId: string; SourceHash: string = '');
var
  Target, Backup, HashFile, ArchHashFile: String;
begin
  /// [!!!]
//  FileOpId := CreateClassID();
  Target := GetFileName(Folders, Nomenclature, sfnRaster);
  // TODO : ИС Заменить название файлов бекапа планшета.


//      Backup := ExtractFilePath(Target) +
//          Format(ArchFileMask,
//              [Nomenclature,
//              FileOpId, FormatDateTime('_yyyy.mm.dd.hh.mm.ss', Now),
//              ExtractFileExt(Target)]);
  Backup := ExtractFilePath(Target);
  Backup := TPath.Finish(Backup, TMapFileName.MakeUploadDbBackup(Nomenclature, FileOpId, ExtractFileExt(Target), Now));
  HashFile := ChangeFileExt(Target, MD5_EXT);
  ArchHashFile := ChangeFileExt(Backup, MD5_EXT);
  // смотрим существует ли старый файл
  if FileExists(Target) then
  begin
    // если он есть, то переименовываем его
    TFileUtils.RenameFile(Target, Backup);
    TFileUtils.RenameFile(HashFile, ArchHashFile);
  end;
  // копируем новый файл на место старого
  ForceDirectories(ExtractFilePath(Target));
  TFileUtils.CopyFile(Source, Target, True);
  if SourceHash = '' then
    SourceHash := MD5DigestToStr(MD5File(Source));
  TFileUtils.WriteFile(HashFile, SourceHash);
end;

procedure TMapScanStorage.UploadHistoryFile(Folders: IKisFolders; const Nomenclature, Source: string);
var
  Target: String;
begin
  Target := GetFileName(Folders, Nomenclature, sfnFormular);
  Target := ChangeFileExt(Target, ExtractFileExt(Source));
  ForceDirectories(ExtractFilePath(Target));
  TFileUtils.CopyFile(Source, Target, True);
end;

{ TMapFileName }

class function TMapFileName.MakeArchiveMask(const Nomenclature, FileOpId: string): string;
begin
  Result := Format(ArchFileMask, [Nomenclature, FileOpId, '_*', '']);
end;

class function TMapFileName.MakeArchiveMask2(const Nomenclature, FileOpId, FileExt: string): string;
var
  Parts: TStringList;
begin
  Parts := TStringList.Create;
  Parts.Forget();
  Parts.Add(Nomenclature);
  Parts.Add('*');
  Parts.Add(FileOpId);
  Parts.Delimiter := '_';
  Parts.StrictDelimiter := True;
  Result := TPath.Finish('', Parts.DelimitedText, FileExt);
end;

class function TMapFileName.MakeArchiveZoneMask(const Nomenclature, FileOpId: string): string;
begin
  Result := Format(ArchFileMask, [Nomenclature + '_zone', FileOpId, '_*', '']);
end;

class function TMapFileName.MakeArchiveZoneMask2(const Nomenclature, FileOpId, FileExt: string): string;
var
  Parts: TStringList;
begin
  Parts := TStringList.Create;
  Parts.Forget();
  Parts.Add(Nomenclature);
  Parts.Add('*');
  Parts.Add(FileOpId);
  Parts.Add('zone');
  Parts.Delimiter := '_';
  Parts.StrictDelimiter := True;
  Result := TPath.Finish('', Parts.DelimitedText, FileExt);
end;

class function TMapFileName.MakeDiffZone(Nomenclature, FileOpId, aFileExt: string; aDateTime: TDateTime): string;
begin
  Result := Format(ArchFileMask,
             [Nomenclature + '_zone',
              FileOpId,
              FormatDateTime(DATE_FORMAT, aDateTime),
              aFileExt]);
end;

class function TMapFileName.MakeUploadDbBackup(Nomenclature, FileOpId, aFileExt: string; aDateTime: TDateTime): string;
begin
  Result := Format(ArchFileMask,
    [Nomenclature,
     FileOpId,
     FormatDateTime(DATE_FORMAT, aDateTime),
     aFileExt]
  );
end;

class function TMapFileName.MakeUploadDbBackup2(Nomenclature, FileOpId, aFileExt: string; aDateTime: TDateTime): string;
var
  Parts: TStringList;
  DotExt: Boolean;
begin
  Parts := TStringList.Create;
  Parts.Forget();
  Parts.Add(Nomenclature);
  Parts.Add(FormatDateTime(DATE_FORMAT2, aDateTime));
  Parts.Add(FileOpId);
  Parts.Delimiter := '_';
  Parts.StrictDelimiter := True;
  Result := Parts.DelimitedText;
  if Length(aFileExt) > 0 then
  begin
    DotExt := aFileExt[1] = '.';
    if not DotExt then
      Result := Result + '.';
    Result := Result + aFileExt
  end;
end;

{ TRasterDownloader }

constructor TRasterDownloader.Create(aStorage: TMapScanStorage; Folders: IKisFolders; const Nomenclature: string);
begin
  FStorage := aStorage;
  FFolders := Folders;
  FNomenclature := Nomenclature;
end;

function TRasterDownloader.Download(MapGeometry: TKisMapGeometry; const TargetDir: string): Boolean;
var
  Source, Target: string;
  Bmp: TBitmap;
begin
  Result := False;
  if MapGeometry.Skip then
    Exit;
  Source := FStorage.GetFileName(FFolders, FNomenclature, sfnRaster);
  if MapGeometry.Full then
  begin
    Target := TPath.Finish(TargetDir, FNomenclature, ExtractFileExt(Source));
    TFileUtils.CopyFile(Source, Target, True);
  end
  else
  begin
    Bmp := TBitmap.CreateFromFile(Source);
    try
      MapGeometry.ApplyGeometryToBmp(Bmp, CL_MAP_SCAN_BACK);
      Target := TPath.Finish(TargetDir, FNomenclature, ExtractFileExt(Source));
      Bmp.SaveToFile(Target);
    finally
      Bmp.Free;
    end;
  end;
  Result := True;
end;

{ TVectorDownloader }

function TVectorDownloader.AddRasterToTempVector: Boolean;
var
  Map500FileName: string;
begin
  Map500FileName := '.\' + ExtractFileName(FRasterTargetFile);
  TAutoCADUtils.AddMap500Raster(FVectorTempFile, FNomenclature, Map500FileName, FRasterTempFile);
  Result := True;
end;

function TVectorDownloader.CopyTempRasterToTarget(): Boolean;
begin
  Result := TFileUtils.CopyFile(FRasterTempFile, FRasterTargetFile);
end;

function TVectorDownloader.CopyFilesToTarget: Boolean;
begin
  Result := TFileUtils.CopyFile(FVectorTempFile, FVectorTargetFile);
//  Result := TFileUtils.CopyFile(FRasterTempFile, FRasterTargetFile);
end;

function TVectorDownloader.CopyVectorToTemp(): Boolean;
begin
  /// копируем файл вектора во временный файл
  ///  - создаём временный файл
  ///  - переименовываем расширение
  ///  - копируем вектор во временный файл
  FVectorSourceFile := FStorage.GetFileName(FFolders, FNomenclature, sfnVector);
  if not FileExists(FVectorSourceFile) then
    raise Exception.Create('Файл не найден ' + ExtractFileName(FVectorSourceFile));
  FVectorTempFile := TFilePath.ReplacePath(FVectorSourceFile, FTempPath);
  FVectorTargetFile := TPath.Finish(FTargetDir, ExtractFileName(FVectorSourceFile));
  Result := TFileUtils.CopyFile(FVectorSourceFile, FVectorTempFile);
end;

constructor TVectorDownloader.Create(aStorage: TMapScanStorage; Folders: IKisFolders; const Nomenclature: string);
begin
  FStorage := aStorage;
  FFolders := Folders;
  FNomenclature := Nomenclature;
end;

procedure TVectorDownloader.CreateTempFolder;
var
  S: string;
begin
  S := GetUniqueString();
  FTempPath := TPath.Combine(FFolders.AppTempPath, S);
  ForceDirectories(FTempPath);
end;

procedure TVectorDownloader.DeleteTempRaster;
begin
  if FRasterTempFile <> '' then
    try
      TFileUtils.DeleteFile(FRasterTempFile);
    except
    end;
end;

procedure TVectorDownloader.DeleteTempVector;
begin
  if FVectorTempFile <> '' then
    try
      TFileUtils.DeleteFile(FVectorTempFile);
    except
    end;
end;

function TVectorDownloader.Download(MapGeometry: TKisMapGeometry; const TargetDir: string): Boolean;
var
  CopiedToTempFile: Boolean;
  RasterCopied: Boolean;
begin
  Result := False;
  if MapGeometry.Skip then
    Exit;
  RasterCopied := False;
  try
    FTargetDir := TargetDir;
    CreateTempFolder();
    // подготавливаем растр, если он есть, во временный файл
    PrepareRasterToTemp(MapGeometry, CopiedToTempFile);
    // копируем временный файл растра в нужную папку
    if CopiedToTempFile then
      if not CopyTempRasterToTarget() then
        Exit;
    RasterCopied := True;
    // копируем файл вектора во временный файл
    if not CopyVectorToTemp() then
      Exit;
    // открываем его
    // подкладываем растр
    // сохраняем
    AddRasterToTempVector();
    // копируем временный файл и растр в нужную папку
    if not CopyFilesToTarget() then
      Exit;
    Result := True;
  finally
    // удаляем временный файл
    DeleteTempRaster();
    DeleteTempVector();
    RemoveDir(FTempPath);
    if RasterCopied and not Result then
      try
        TFileUtils.DeleteFile(FRasterTargetFile, False);
      except
      end;
  end;
end;

procedure TVectorDownloader.PrepareRasterToTemp;
var
  Bmp: TBitmap;
  HasRaster: Boolean;
begin
  CopiedToTemp := False;
  FRasterTempFile := '';
  //
  FRasterSourceFile := FStorage.GetFileName(FFolders, FNomenclature, sfnRaster);
  FRasterTargetFile := TPath.Finish(FTargetDir, ExtractFileName(FRasterSourceFile));
  FRasterTargetFile := TFilePath.AddPostfix(FRasterTargetFile, '_work_zone');
  if theMapScansStorage.JpegForVectorZones then
    FRasterTargetFile := ChangeFileExt(FRasterTargetFile, '.jpg');
  FRasterTempFile := TFilePath.ReplacePath(FRasterSourceFile, FTempPath);
  HasRaster := FileExists(FRasterSourceFile);
  if MapGeometry.Full then
  begin
    if HasRaster then
    begin
      // TODO : convert to jpeg
      if theMapScansStorage.JpegForVectorZones then
      begin
        if TFilePath.FileIsJPEG(FRasterSourceFile) then
          TFileUtils.CopyFile(FRasterSourceFile, FRasterTempFile, True)
        else
        begin
          Bmp := TBitmap.CreateFromFile(FRasterSourceFile);
          try
            Bmp.SaveToJpeg(FRasterTempFile)
          finally
            Bmp.Free;
          end;
        end;
      end
      else
        TFileUtils.CopyFile(FRasterSourceFile, FRasterTempFile, True);
    end
    else
    begin
      Bmp := TMapImage.CreateMapImage();
      try
        if theMapScansStorage.JpegForVectorZones then
          Bmp.SaveToJpeg(FRasterTempFile)
        else
          Bmp.SaveToFile(FRasterTempFile);
      finally
        Bmp.Free;
      end;
    end;
  end
  else
  begin
    if HasRaster then
      Bmp := TBitmap.CreateFromFile(FRasterSourceFile)
    else
      Bmp := TMapImage.CreateMapImage();
    try
      MapGeometry.ApplyGeometryToBmp(Bmp, CL_MAP_SCAN_BACK);
      if theMapScansStorage.JpegForVectorZones then
        Bmp.SaveToJpeg(FRasterTempFile)
      else
        Bmp.SaveToFile(FRasterTempFile);
    finally
      Bmp.Free;
    end;
  end;
  CopiedToTemp := True;
end;

{ TMapImage }

class function TMapImage.CreateMapImage(BackColor: TColor): TBitmap;
var
  R: TRect;
begin
  Result := TBitmap.Create();
  Result.PixelFormat := pf24bit;
  Result.SetSize(SZ_MAP_PX, SZ_MAP_PX);
  if BackColor <> clNone then
  begin
    R := Result.Bounds();
    Result.Canvas.Pen.Style := psSolid;
    Result.Canvas.Pen.Color := BackColor;
    Result.Canvas.Brush.Style := bsSolid;
    Result.Canvas.Brush.Color := BackColor;
    Result.Canvas.FillRect(R);
    Result.Canvas.FrameRect(R);
  end;
end;

initialization
  theMapScansStorage := TMapScanStorage.Create;

finalization
  FreeAndNil(theMapScansStorage);

end.
