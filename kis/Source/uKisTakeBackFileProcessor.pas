unit uKisTakeBackFileProcessor;

interface

uses
  SysUtils, Classes, Contnrs, Windows, Graphics, 
  uMapScanFiles, uTasks, uGraphics, uImageHistogram, uImageCompare,
  //uKisAppModule,
  uKisTakeBackFiles, uFileUtils, uKisIntf, uDrawTransparent;

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

  TCompareImageLayer = (layOriginal, layNewVersion, layDifference);
  TCompareImageLayers = set of TCompareImageLayer;

  TTakeBackFileProcessor = class
  private
    FScan: TMapScanFile;
    FBitmaps: TScanBitmaps;
    FHistogram: TImageHistogram;
    FMergedFile: String;
    FMixedFiles: TStringList;
  strict private
    function CreateEmptyFile(Folders: IKisFolders): string;
    function GetBitmap(const aFilename: String): TBitmap;
    function PrepareHistogram(Bitmap: TBitmap; const ColorCount: Byte): Boolean;
    procedure PrepareDiffBitmap(Folders: IKisFolders);
    procedure PrepareMergedFileName(Folders: IKisFolders);
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
    /// Если Rebuild, то заново грузим файлы.
    /// Соединяем зону с исходным планшетом.
    /// </summary>
    procedure PrepareImages(Folders: IKisFolders; const Rebuild, FileType: Boolean; const aFileName: string; const SelectedColor: TColor);
    //
    property Bitmaps: TScanBitmaps read FBitmaps;
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
  FBitmaps := TScanBitmaps.Create;
  TFileUtils.DeleteFile(FMergedFile);
  FMergedFile := '';
end;

constructor TTakeBackFileProcessor.Create;
begin
  FBitmaps := TScanBitmaps.Create;
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
  inherited;
end;

function TTakeBackFileProcessor.GetBitmap(const aFilename: String): TBitmap;
var
  Tmp: TBitmap;
begin
  Result := TBitmap.Create;
  Tmp := TBitmap.CreateFromFile(aFileName);
  Tmp.Forget;
  Result.CopyFrom(Tmp, True);
  {$IFDEF GRAPHICS_16_BIT}
  Result.PixelFormat := pf16bit;
  {$ENDIF}
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
  FScan.ComparedFileName := aFile.Nomenclature;
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
  FScan.ComparedFileName := TFileUtils.CreateTempFile(Folders.AppTempPath);
  BmpFile := ChangeFileExt(FScan.ComparedFileName, '.bmp');
  if RenameFile(Scan.ComparedFileName, BmpFile) then
    FScan.ComparedFileName := BmpFile;
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
    FScan.ComparedFileName := FMergedFile;
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
    FScan.ComparedFileName := aFileName;
    if Rebuild and Assigned(Bitmaps.Diff) then
    begin
      Bitmaps.Diff.Free;
      Bitmaps.Diff := nil;
    end;
    if Rebuild or not Assigned(Bitmaps.Diff) then
    begin
      Bitmaps.Diff := GetBitmap(FScan.ComparedFileName);
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

procedure TCompareImageList.SetScans(const Index: Integer;
  const Value: TMapScanFile);
begin
  FScans[Index] := Value;
end;

end.
