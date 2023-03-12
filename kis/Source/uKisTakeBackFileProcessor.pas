unit uKisTakeBackFileProcessor;

interface

uses
  SysUtils, Classes, Contnrs, Windows, Graphics, 
  uMapScanFiles, uTasks, uGraphics, uImageHistogram, uImageCompare, uDrawTransparent, uAutoCAD,
  //uKisAppModule,
  uKisTakeBackFiles, uFileUtils, uKisIntf;

type
  TScanBitmaps = class
  private
    FDiff: TBitmap;
    FDB: TBitmap;
    FUpload: TBitmap;
  public
    constructor Create;
    destructor Destroy; override;
    //
    procedure Clear();
    /// <summary>
    ///   Файл, который находится в базе.
    /// </summary>
    property DB: TBitmap read FDB write FDB;
    /// <summary>
    ///   Файл, который хотят залить.
    /// </summary>
    property Upload: TBitmap read FUpload write FUpload;
    /// <summary>
    ///   Файл с разницей между первыми двумя файлами.
    /// </summary>
    property Diff: TBitmap read FDiff write FDiff;
  public
    DiffArea: Integer;
    DiffStrength: Integer;
  end;

  TVectorBitmaps = class
  private
    FZone: TBitmap;
    FDiff: TBitmap;
    FNewVector: TBitmap;
    FOldVector: TBitmap;
  public
    constructor Create;
    destructor Destroy; override;
    //
    procedure Clear();
    //
    property OldVector: TBitmap read FOldVector write FOldVector;
    property NewVector: TBitmap read FNewVector write FNewVector;
    /// <summary>
    ///   Файл с разницей между первыми OldVector и NewVector.
    /// </summary>
    property Diff: TBitmap read FDiff write FDiff;
    /// <summary>
    /// Файл с областью работ. 
    /// </summary>
    property Zone: TBitmap read FZone write FZone;
  public
    DiffArea: Integer;
    DiffStrength: Integer;
  end;

  TCompareImageLayer = (layOriginal, layNewVersion, layDifference);
  TCompareImageLayers = set of TCompareImageLayer;

  TTakeBackFileProcessor = class
  private
    FScan: TMapScanFile;
    FBitmaps: TScanBitmaps;
    FVBitmaps: TVectorBitmaps;
    FHistogram: TImageHistogram;
    FMergedFile: String;
    FMixedFiles: TStringList;
  strict private
    function CreateEmptyFile(Folders: IKisFolders): string;
    /// <summary>
    ///  Загружает файл в битмэп.
    ///  Если это векторный файл, то отрисовывает его на битмэпе.
    /// </summary>
    function GetBitmap(const aFilename: String): TBitmap;
    function PrepareHistogram(Bitmap: TBitmap; const ColorCount: Byte): Boolean;
    procedure PrepareDiffBitmap(Folders: IKisFolders);
    procedure PrepareMergedFileName(Folders: IKisFolders);
    function GetWorkZoneFileName(const aFile: TTakeBackFileInfo): string;
  public
    constructor Create();
    destructor Destroy(); override;
    //
    procedure Clear();
    procedure MergeImages(Folders: IKisFolders; const TransparentColor: TColor);
    /// <summary>
    /// Загружаем файлы, строим гистограмму.
    /// </summary>
    procedure Prepare(Folders: IKisFolders; const aFile: TTakeBackFileInfo);
    /// <summary>
    /// Загружаем файлы, строим гистограмму.
    /// </summary>
    procedure PrepareVector(Folders: IKisFolders; const aFile: TTakeBackFileInfo);
    /// <summary>
    /// Если Rebuild, то заново грузим файлы.
    /// Соединяем зону с исходным планшетом.
    /// </summary>
    procedure PrepareImages(Folders: IKisFolders; const Rebuild, FileType: Boolean; const aFileName: string; const SelectedColor: TColor);
    //
    property Bitmaps: TScanBitmaps read FBitmaps;
    property VBitmaps: TVectorBitmaps read FVBitmaps;
    property Histogram: TImageHistogram read FHistogram;
    property MergedFileName: string read FMergedFile;
    property Scan: TMapScanFile read FScan;
  end;

implementation

uses
  uGC;

type
  TCompareImageList = class
  strict private
    FScans: array of TMapScanFile;
    FBitmaps: TObjectList;
  private
    function GetScans(const Index: Integer): TMapScanFile;
    procedure SetScans(const Index: Integer; const Value: TMapScanFile);
    function GetBitmaps(const Index: Integer): TScanBitmaps;
  public
    constructor Create;
    destructor Destroy; override;
    //
    function Count: Integer;
    procedure LoadMapList(Folders: IKisFolders; Files: TStrings);
    //
    property Bitmaps[const Index: Integer]: TScanBitmaps read GetBitmaps;
    property Scans[const Index: Integer]: TMapScanFile read GetScans write SetScans;
  end;

{ TTakeBackFileProcessor }

procedure TTakeBackFileProcessor.Clear;
begin
  FreeAndNil(FBitmaps);
  FreeAndNil(FVBitmaps);
  FBitmaps := TScanBitmaps.Create;
  FVBitmaps := TVectorBitmaps.Create;
  TFileUtils.DeleteFile(FMergedFile);
  FMergedFile := '';
end;

constructor TTakeBackFileProcessor.Create;
begin
  FBitmaps := TScanBitmaps.Create;
  FVBitmaps := TVectorBitmaps.Create;
  FHistogram := TImageHistogram.Create;
  FMixedFiles := TStringList.Create;
end;

function TTakeBackFileProcessor.CreateEmptyFile(Folders: IKisFolders): string;
var
  Tmp: string;
begin
  Result := TFileUtils.CreateTempFile(Folders.AppTempPath);
  Tmp := ChangeFileExt(Result, '.bmp');
  if TFileUtils.RenameFile(Result, Tmp) then
    Result := Tmp;
end;

destructor TTakeBackFileProcessor.Destroy();
begin
  FreeAndNil(FMixedFiles);
  FreeAndNil(FHistogram);
  FreeAndNil(FBitmaps);
  FreeAndNil(FVBitmaps);
  inherited;
end;

function TTakeBackFileProcessor.GetBitmap(const aFilename: String): TBitmap;
var
  Tmp: TBitmap;
begin
  if theMapScansStorage.FileIsVector(aFilename) then
  begin
    Result := TAutoCADUtils.ExportToBitmap(aFilename, SZ_MAP_PX, SZ_MAP_PX);
  end
  else
  begin
    Result := TBitmap.Create;
    Tmp := TBitmap.CreateFromFile(aFileName);
    Tmp.Forget;
    Result.CopyFrom(Tmp, True);
  end;
  {$IFDEF GRAPHICS_16_BIT}
  Result.PixelFormat := pf16bit;
  {$ENDIF}
end;

function TTakeBackFileProcessor.GetWorkZoneFileName(const aFile: TTakeBackFileInfo): string;
var
  S: string;
begin
  S := theMapScansStorage.GenMapZoneShortFileName(aFile.Nomenclature);
  Result := ExtractFilePath(aFile.FileName) + S;
end;

procedure TTakeBackFileProcessor.MergeImages(Folders: IKisFolders; const TransparentColor: TColor);
var
  Drawer: IDrawTransparent;
  t1, t2: Cardinal;
  Kind: TDrawTransparentKind;
  Target, Source: TBitmap;
begin
  if not Assigned(FBitmaps.Upload) then
    FBitmaps.Upload := TBitmap.Create;
  FBitmaps.Upload.CopyFrom(FBitmaps.DB, True);
//  FBitmaps.Upload.SaveToFileEx(FScan.FullFileName, 11812, 11812);
  //
  Target := FBitmaps.Upload;
  Source := FBitmaps.Diff;
//  Kind := drawBlt;
  Kind := drawThreaded;
  t1 := GetTickCount();
  Drawer := TDrawTransparentFactory.GetDraw(Folders, Kind);
  Drawer.Draw(Target, Source, TransparentColor);
  t2 := GetTickCount();
  OutputDebugString(PChar('DrawTransparent: ' + IntToStr(t2 - t1) + ' тиков.'));
  //
  FBitmaps.Upload.SaveToFileEx(FScan.FullFileName, 11812, 11812);
end;

procedure TTakeBackFileProcessor.Prepare(Folders: IKisFolders; const aFile: TTakeBackFileInfo);
var
  Bmp: TBitmap;
begin
  FScan.PrepareFileName(Folders, aFile.Nomenclature);
  //
  FScan.DiffFileName := aFile.Nomenclature;
  FScan.FullFileName := aFile.MergedFile;
  //
  Bmp := GetBitmap(aFile.FileName);
  FreeAndNil(FHistogram);
  FHistogram := TImageHistogram.Create;
  PrepareHistogram(Bmp, Folders.ThreadCount);
  //
  if aFile.Kind = tbZones then
    Bitmaps.Diff := Bmp
  else
    Bitmaps.Upload := Bmp;
  //
  if not Assigned(Bitmaps.DB) then
    Bitmaps.DB := FScan.PrepareBitmap(True, True);
end;

procedure TTakeBackFileProcessor.PrepareDiffBitmap(Folders: IKisFolders);
var
  Comparer: IImageCompare;
  BmpFile: string;
  aBitmap: TBitmap;
begin
  FScan.DiffFileName := TFileUtils.CreateTempFile(Folders.AppTempPath);
  BmpFile := ChangeFileExt(FScan.DiffFileName, '.bmp');
  if RenameFile(Scan.DiffFileName, BmpFile) then
    FScan.DiffFileName := BmpFile;
  Comparer := TImageCompareFactory.CreateImageCompare(icaKalabuhov);
//    Comparer := TImageCompareFactory.CreateImageCompare(icaCompareExe);
//  Comparer.Compare2(Scan.DBFileName, Scan.FullFileName, Result, Bitmaps.DiffArea, Bitmaps.DiffStrength);
  aBitmap := nil;
  Comparer.Compare3(
    Scan.DBFileName,
    Scan.FullFileName,
    Bitmaps.DB,
    Bitmaps.Upload,
    aBitmap,
    Bitmaps.DiffArea,
    Bitmaps.DiffStrength);
  Bitmaps.Diff := aBitmap;
end;

function TTakeBackFileProcessor.PrepareHistogram(Bitmap: TBitmap; const ColorCount: Byte): Boolean;
begin
  Result := False;
  if FHistogram.Prepared then
    Exit;
  FHistogram.LoadFromBitmap(Bitmap, True, ColorCount);
  Result := True;
end;

procedure TTakeBackFileProcessor.PrepareImages(Folders: IKisFolders; const Rebuild,
  FileType: Boolean; const aFileName: string; const SelectedColor: TColor);
begin
  PrepareMergedFileName(Folders);
  if FileType then
  begin
    FScan.FullFileName := aFileName;
    FScan.DiffFileName := FMergedFile;
    if Rebuild and Assigned(Bitmaps.Upload) then
    begin
      Bitmaps.Upload.Free;
      Bitmaps.Upload := nil;
    end;
    if Rebuild or not Assigned(Bitmaps.Upload) then
    begin
      Bitmaps.Upload := FScan.PrepareBitmap(False, True);
      {$IFDEF GRAPHICS_16_BIT}
      Imgs.Upload.PixelFormat := pf16bit;
      {$ENDIF}
    end;
    if Rebuild and Assigned(Bitmaps.Diff) then
    begin
      Bitmaps.Diff.Free;
      Bitmaps.Diff := nil;
    end;
    if Rebuild or not Assigned(Bitmaps.Diff) then
      PrepareDiffBitmap(Folders);
  end
  else
  begin
    FScan.FullFileName := FMergedFile;
    FScan.DiffFileName := aFileName;
    if Rebuild and Assigned(Bitmaps.Diff) then
    begin
      Bitmaps.Diff.Free;
      Bitmaps.Diff := nil;
    end;
    if Rebuild or not Assigned(Bitmaps.Diff) then
    begin
      Bitmaps.Diff := GetBitmap(FScan.DiffFileName);
      {$IFDEF GRAPHICS_16_BIT}
      Bitmaps.Diff.PixelFormat := pf16bit;
      {$ENDIF}
    end;
    if Rebuild and Assigned(Bitmaps.Upload) then
    begin
      Bitmaps.Upload.Free;
      Bitmaps.Upload := nil;
    end;
    if Rebuild or not Assigned(Bitmaps.Upload) then
      MergeImages(Folders, SelectedColor);
  end;
end;

procedure TTakeBackFileProcessor.PrepareMergedFileName;
var
  Tmp: string;
begin
  if not FileExists(FMergedFile) then
  begin
    if FMergedFile = '' then
    begin
      FMergedFile := TFileUtils.CreateTempFile(Folders.AppTempPath);
      Tmp := ChangeFileExt(FMergedFile, '.bmp');
      if TFileUtils.RenameFile(FMergedFile, Tmp) then
        FMergedFile := Tmp;
    end;
  end;
end;

procedure TTakeBackFileProcessor.PrepareVector(Folders: IKisFolders; const aFile: TTakeBackFileInfo);
var
  WzFilename: string;
begin
  FVBitmaps.Clear();
  //
  FScan.PrepareFileName(Folders, aFile.Nomenclature);
  FScan.DiffFileName := aFile.Nomenclature;
  FScan.FullFileName := aFile.MergedFile;
  //
  FVBitmaps.NewVector := GetBitmap(aFile.FileName);
  FVBitmaps.NewVector.TransparentColor := clWhite;
  FVBitmaps.NewVector.Transparent := True;
  FVBitmaps.OldVector := FScan.PrepareBitmap(True, True);//GetBitmap(aFile.FileName);
  FVBitmaps.OldVector.TransparentColor := clWhite;
  FVBitmaps.OldVector.Transparent := True;
  WzFilename := GetWorkZoneFileName(aFile);
  if FileExists(WzFilename) then
    FVBitmaps.Zone := GetBitmap(WzFileName);
//  FreeAndNil(FHistogram);
//  FHistogram := TImageHistogram.Create;
//  PrepareHistogram(Bmp, Folders.ThreadCount);
  //
//  if aFile.Kind = tbZones then
//    Bitmaps.Diff := Bmp
//  else
//    Bitmaps.Upload := Bmp;
  //
//  if not Assigned(Bitmaps.DB) then
//    Bitmaps.DB := FScan.PrepareBitmap(True, True);
end;

{ TScanBitmaps }

procedure TScanBitmaps.Clear;
begin
  DiffArea := -1;
  DiffStrength := -1;
  FreeAndNil(FDiff);
  FreeAndNil(FUpload);
  FreeAndNil(FDB);
end;

constructor TScanBitmaps.Create;
begin
  DiffArea := -1;
  DiffStrength := -1;
end;

destructor TScanBitmaps.Destroy;
begin
  FreeAndNil(FDiff);
  FreeAndNil(FUpload);
  FreeAndNil(FDB);
  inherited;
end;

{ TCompareImageList }

function TCompareImageList.Count: Integer;
begin
  Result := Length(FScans);
end;

constructor TCompareImageList.Create;
begin
  inherited;
  SetLength(FScans, 0);
  FBitmaps := TObjectList.Create;
end;

destructor TCompareImageList.Destroy;
begin
  FreeAndNil(FBitmaps);
  inherited;
end;

function TCompareImageList.GetBitmaps(const Index: Integer): TScanBitmaps;
begin
  Result := TScanBitmaps(FBitmaps[Index]);
end;

function TCompareImageList.GetScans(const Index: Integer): TMapScanFile;
begin
  Result := FScans[Index];
end;

procedure TCompareImageList.LoadMapList(Folders: IKisFolders; Files: TStrings);
var
  I: Integer;
begin
  SetLength(FScans, Files.Count);
  for I := 0 to Files.Count - 1 do
    FScans[I].PrepareFileName(Folders, Files[I]);
  FBitmaps.Clear;
  for I := 0 to Files.Count - 1 do
    FBitmaps.Add(TScanBitmaps.Create);
end;

procedure TCompareImageList.SetScans(const Index: Integer; const Value: TMapScanFile);
begin
  FScans[Index] := Value;
end;

{ TVectorBitmaps }

procedure TVectorBitmaps.Clear;
begin
  DiffArea := -1;
  DiffStrength := -1;
  FreeAndNil(FDiff);
  FreeAndNil(FZone);
  FreeAndNil(FNewVector);
  FreeAndNil(FOldVector);
end;

constructor TVectorBitmaps.Create;
begin
  DiffArea := -1;
  DiffStrength := -1;
end;

destructor TVectorBitmaps.Destroy;
begin
  Clear();
  inherited;
end;

end.
