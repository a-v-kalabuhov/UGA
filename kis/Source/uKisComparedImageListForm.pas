unit uKisComparedImageListForm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, CheckLst, ToolWin, ComCtrls, ActnList, ImgList, Contnrs,
  ExtCtrls, Math,
  JvDotNetControls, JvExCheckLst, JvCheckListBox, JvExStdCtrls, JvCombobox,
  JvColorCombo,
  ATImageBox,
  uImageCompare, uKisFileReport, uMapScanFiles, uKisTakeBackFiles, uTasks,
  uImageHistogram, uKisIntf, uKisMapScanIntf, uDisableWindowGhosting, uGraphics;

type
  TScanBitmaps = class
  private
    FDiff: TBitmap;
    FDB: TBitmap;
    FUpload: TBitmap;
  public
    constructor Create;
    destructor Destroy; override;
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

  TKisComparedImageListForm = class(TForm, IKisImageCompareViewer)
    ToolBar1: TToolBar;
    ActionList1: TActionList;
    ToolButton1: TToolButton;
    acConfirm: TAction;
    ImageList1: TImageList;
    Splitter1: TSplitter;
    Panel1: TPanel;
    pnlInfo: TPanel;
    Label1: TLabel;
    LabelScale: TLabel;
    lArea: TLabel;
    lRank: TLabel;
    TrackBar1: TTrackBar;
    chkFit: TCheckBox;
    Box: TATImageBox;
    chbOriginal: TCheckBox;
    chbNewVersion: TCheckBox;
    chbDiff: TCheckBox;
    Bevel1: TBevel;
    clbMaps: TJvDotNetCheckListBox;
    ToolButton2: TToolButton;
    pnlPictureType: TPanel;
    Label2: TLabel;
    cbFileType: TComboBox;
    cbColor: TJvColorComboBox;
    lColor: TLabel;
    btnAddColor: TButton;
    ColorDialog1: TColorDialog;
    procedure acConfirmUpdate(Sender: TObject);
    procedure chkFitClick(Sender: TObject);
    procedure TrackBar1Change(Sender: TObject);
    procedure clbMapsClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure acConfirmExecute(Sender: TObject);
    procedure chbOriginalClick(Sender: TObject);
    procedure ToolButton2Click(Sender: TObject);
    procedure cbFileTypeChange(Sender: TObject);
    procedure cbColorChange(Sender: TObject);
    procedure btnAddColorClick(Sender: TObject);
  private
    FCurrentImage, FTempImage: TBitmap;
    FCurrentMapIndex: Integer;
    FImages: TCompareImageList;
    FUpdatingSelfOptions: Boolean;
    //
    function CanShowDiffAreaAndRank: Boolean;
    function GetBitmap(const aFilename: String): TBitmap;
    function GetRank(Value: Integer): string;
    procedure LoadMapList(Files: TStrings);
    procedure MixImages(Layers: TList; Target: TBitmap);
    function PrepareDiffBitmap(var Scan: TMapScanFile;
      Bitmaps: TScanBitmaps): TBitmap;
    procedure ShowSelectedImages(Rebuild: Boolean);
    procedure UpdateCurrentImage(Bmps: TScanBitmaps);
    procedure UpdateImageScaleOptions;
    procedure UpdateSelfOptions;
    procedure UpdateSelfScaleOptions;
  private type
    TExecuteMode = (emList, emOneFile, emChangedZone);
    TCompareImageLayer = (layOriginal, layNewVersion, layDifference);
    TCompareImageLayers = set of TCompareImageLayer;
  private
    FCurrentImageLayers: TCompareImageLayers;
    FFile: TTakeBackFileInfo;
    FHistogram: TImageHistogram;
    FMergedFile: string;
    FMode: TExecuteMode;
    FTick1, FTick2: Cardinal;
    FShowed: Boolean;
    FCustomColors: array of TColor;
    function GetSelectedColor: TColor;
    procedure MergeImages(var Scan: TMapScanFile; Bitmaps: TScanBitmaps;
      TransparentColor: TColor);
    function PrepareHistogram(Bitmap: TBitmap): Boolean;
    procedure PrepareMergedFileName;
    procedure SetMode(Value: TExecuteMode);
    procedure UpdateColorInfo(Idx: Integer);
    procedure UpdateColorList;
  private
    { IKisImageViewer }
    procedure CompareFiles(const MapScan: TMapScanFile);
    function CompareScanFiles(aFileList: TStrings; var Scans: TMapScanArray): Boolean;
    function CompareTakeBackFile(const aFile: TTakeBackFileInfo): Boolean;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
  end;

  TDrawTransparent = class
  private type
    TDrawTranspTask = class(TTask)
    private
      FTarget, FSource: TBitmap;
      FG, FB, FR: Byte;
      FStart, FEnd: Integer;
    protected
      procedure Execute; override;
    public
      constructor Create(Target, Source: TBitmap; Rt, Gt, Bt: Byte;
        StartLine, EndLine: Integer);
      destructor Destroy; override;
      //
      property Start: Integer read FStart;
      property Result: TBitmap read FTarget;
    end;
  private
    class procedure IntDraw(Target, Source: TBitmap; Rt, Gt, Bt: Byte);
  public
    class procedure Draw(Target, Source: TBitmap; TransparentClr: TColor);
  end;

implementation

{$R *.dfm}

uses
  uFileUtils, uGC, uKisAppModule, uDebug, uKisExceptions;

procedure TKisComparedImageListForm.acConfirmExecute(Sender: TObject);
begin
  ModalResult := mrOK;
end;

procedure TKisComparedImageListForm.acConfirmUpdate(Sender: TObject);
var
  I, C: Integer;
begin
  C := 0;
  for I := 0 to clbMaps.Items.Count - 1 do
    if clbMaps.Checked[I] then
      Inc(C);
  //
  acConfirm.Enabled :=
    ((C > 0) and (C = clbMaps.Items.Count))
    or
    ((FMode = emChangedZone) and (clbMaps.Items.Count = 1));
end;

function HexToTColor(const sColor: string): TColor;
begin
  Result :=
    RGB(
        StrToInt('$'+Copy(sColor, 1, 2)),
        StrToInt('$'+Copy(sColor, 3, 2)),
        StrToInt('$'+Copy(sColor, 5, 2))
    ) ;
end;

procedure TKisComparedImageListForm.btnAddColorClick(Sender: TObject);
var
  I: Integer;
  A: Char;
  S: string;
begin
  ColorDialog1.CustomColors.Clear;
  A := 'A';
  for I := 0 to Length(FCustomColors) - 1 do
  begin
    S := IntToHex(FCustomColors[I], 6);
    ColorDialog1.CustomColors.Add('Color' + A + '=' + S);
    Inc(A);
  end;
  if ColorDialog1.Execute(Handle) then
  begin
    SetLength(FCustomColors, ColorDialog1.CustomColors.Count);
    for I := 0 to ColorDialog1.CustomColors.Count - 1 do
    begin
      S := ColorDialog1.CustomColors.ValueFromIndex[I];
      FCustomColors[I] := HexToTColor(S);
    end;
    UpdateColorList;
  end;
end;

function TKisComparedImageListForm.CanShowDiffAreaAndRank: Boolean;
begin
  Result := (FMode <> emChangedZone) or (cbFileType.Visible and (cbFileType.ItemIndex = 1));
end;

procedure TKisComparedImageListForm.cbColorChange(Sender: TObject);
var
  Scan: TMapScanFile;
  Imgs: TScanBitmaps;
begin
  if FCurrentMapIndex >= 0 then
  begin
    Scan := FImages.Scans[FCurrentMapIndex];
    // готовим картинку по настройкам "слоёв"
    Imgs := FImages.Bitmaps[FCurrentMapIndex];
    MergeImages(Scan, Imgs, GetSelectedColor);
    ShowSelectedImages(False);
  end;
end;

procedure TKisComparedImageListForm.cbFileTypeChange(Sender: TObject);
begin
  UpdateColorInfo(cbFileType.ItemIndex);
  ShowSelectedImages(True);
end;

procedure TKisComparedImageListForm.chbOriginalClick(Sender: TObject);
begin
  if (FCurrentMapIndex >= 0) and (FCurrentMapIndex < FImages.Count) then
  begin
    UpdateCurrentImage(FImages.Bitmaps[FCurrentMapIndex]);
  end;
end;

procedure TKisComparedImageListForm.chkFitClick(Sender: TObject);
begin
  Box.ImageFitToWindow := chkFit.Checked;
  UpdateSelfScaleOptions;
end;

procedure TKisComparedImageListForm.clbMapsClick(Sender: TObject);
begin
  if FCurrentMapIndex <> clbMaps.ItemIndex then
  begin
    FCurrentMapIndex := clbMaps.ItemIndex;
    ShowSelectedImages(False);
  end;
end;

procedure TKisComparedImageListForm.CompareFiles;
var
  Files: TStringList;
begin
  FMergedFile := '';
  try
    SetMode(emOneFile);
    Caption := MapScan.Nomenclature;
    Files := TStringList.Create;
    Files.Forget;
    Files.Add(MapScan.Nomenclature);
    LoadMapList(Files);
    FImages.Scans[0] := MapScan;
    clbMaps.Selected[0] := True;
    FCurrentMapIndex := 0;
    ShowSelectedImages(False);
    ShowModal;
  finally
    TFileUtils.DeleteFile(FImages.Scans[0].ComparedFileName);
    TFileUtils.DeleteFile(FMergedFile);
  end;
end;

function TKisComparedImageListForm.CompareScanFiles(aFileList: TStrings;
  var Scans: TMapScanArray): Boolean;
var
  I: Integer;
begin
  FMergedFile := '';
  try
    SetMode(emList);
    LoadMapList(aFileList);
    Result := ShowModal = mrOk;
    if Result then
    begin
      SetLength(Scans, FImages.Count);
      for I := 0 to FImages.Count - 1 do
        Scans[I] := FImages.Scans[I];
    end;
  finally

  end;
end;

constructor TKisComparedImageListForm.Create(AOwner: TComponent);
begin
  inherited;
  FImages := TCompareImageList.Create;
  FHistogram := TImageHistogram.Create;
  //
  FCurrentImage := TBitmap.Create;
  {$IFDEF GRAPHICS_16_BIT}
  FCurrentImage.PixelFormat := pf16bit;
  {$ELSE}
  FCurrentImage.PixelFormat := pf24bit;
  {$ENDIF}
  FCurrentImage.SetSize(5906, 5906);
  //
  FTempImage := TBitmap.Create;
  {$IFDEF GRAPHICS_16_BIT}
  FTempImage.PixelFormat := pf16bit;
  {$ELSE}
  FTempImage.PixelFormat := pf24bit;
  {$ENDIF}
  FTempImage.SetSize(5906, 5906);
  //
  SetLength(FCustomColors, 1);
//  FCustomColors[0] := $7F007F;//$A349A4;
  FCustomColors[0] := $7F007F;//$A349A4;
end;

destructor TKisComparedImageListForm.Destroy;
begin
  FreeAndNil(FHistogram);
  FreeAndNil(FTempImage);
  FreeAndNil(FCurrentImage);
  FreeAndNil(FImages);
  inherited;
end;

function TKisComparedImageListForm.CompareTakeBackFile(const aFile: TTakeBackFileInfo): Boolean;
var
  Files: TStringList;
  aScan: TMapScanFile;
  Bmp: TBitmap;
begin
  FTick1 := GetTickCount;
  FShowed := False;
  Caption := 'Приём планшета ' + aFile.Nomenclature;
  FFile := aFile;
  FMergedFile := '';
  SetMode(emChangedZone);
  // поготовить файлы
  // - оригинал
  // - сшивка
  // - изменения
  Files := TStringList.Create;
  Files.Forget;
  Files.Add(aFile.Nomenclature);
  LoadMapList(Files);
  //
  aScan := FImages.Scans[0];
  aScan.ComparedFileName := aFile.FileName;
  aScan.FullFileName := aFile.MergedFile;
  FImages.Scans[0] := aScan;
  //
  Bmp := GetBitmap(aFile.FileName);
  FreeAndNil(FHistogram);
  FHistogram := TImageHistogram.Create;
  PrepareHistogram(Bmp);

  UpdateColorList;
  cbColor.ColorValue := $7F007F;
  if aFile.Kind = tbZones then
  begin
    FImages.Bitmaps[0].Diff := Bmp;
    cbFileType.ItemIndex := 1;
    UpdateColorInfo(1);
  end
  else
  //    if aFile.Kind = tbEntireMap then
  begin
    FImages.Bitmaps[0].Upload := Bmp;
    cbFileType.ItemIndex := 0;
    UpdateColorInfo(0);
  end;
  //
  FCurrentMapIndex := 0;
  ShowSelectedImages(False);
  //
  Result := ShowModal = mrOK;
  if Result then
  begin
  //    if FImages.Bitmaps[0].DiffArea = 0 then
  //      aFile.Kind := tbNoChanges
  //    else
    if cbFileType.ItemIndex = 0 then
      aFile.Kind := tbEntireMap
    else
    if cbFileType.ItemIndex = 1 then
    begin
      aFile.Kind := tbZones;
      aFile.MergedFile := FMergedFile;
    end;
    aFile.Confirmed := True;
  end
  else
    TFileUtils.DeleteFile(FMergedFile);
  FMergedFile := '';
end;

procedure TKisComparedImageListForm.FormShow(Sender: TObject);
begin
  Box.ImageFitToWindow := chkFit.Checked;
  Box.ImageCenter := True;
  Box.Image.Resample := False;
  Box.Image.ResampleDelay := 200;
  Box.ImageLabel.Visible := False;
  Box.ImageDrag := True;
  Box.ImageKeepPosition := True;
//  chkFit.Checked := True;
  //
  if FMode = emChangedZone then
  begin
    FTick2 := GetTickCount;
    Caption := Caption + '... (' + IntToStr(Round((FTick2 - FTick1) / 1000)) + ' сек.)';
  end;
end;

function TKisComparedImageListForm.GetBitmap(const aFilename: String): TBitmap;
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

function TKisComparedImageListForm.GetRank(Value: Integer): string;
begin
  if Value = 0 then
    Result := 'изменений нет'
  else
  if Value < 15 then
    Result := 'незначительно'
  else
  if Value < 30 then
    Result := 'слабо'
  else
  if Value < 50 then
    Result := 'средне'
  else
  if Value < 60 then
    Result := 'сильно'
  else
    Result := 'очень сильно';
end;

function TKisComparedImageListForm.GetSelectedColor: TColor;
begin
  if cbColor.ItemIndex < 0 then
    Result := clBlack
  else
    Result := cbColor.ColorValue;
end;

procedure TKisComparedImageListForm.LoadMapList(Files: TStrings);
var
  I: Integer;
begin
  FImages.LoadMapList(AppModule, Files);
  //
  clbMaps.Clear;
  for I := 0 to FImages.Count - 1 do
    clbMaps.Items.Add(FImages.Scans[I].Nomenclature);
  if (FMode = emList) and (clbMaps.Items.Count = 1) then
  begin
    FCurrentMapIndex := 0;
    clbMaps.Selected[0] := True;
  end
  else
    FCurrentMapIndex := -1;
  ShowSelectedImages(False);
end;

procedure TKisComparedImageListForm.MergeImages;
begin
  if not Assigned(Bitmaps.Upload) then
    Bitmaps.Upload := TBitmap.Create;
  Bitmaps.Upload.CopyFrom(Bitmaps.DB, True);
//  Bitmaps.Upload.Assign(Bitmaps.DB);
  //
  if TransparentColor < 0 then
    TransparentColor := $FF00FF;
  
  TDrawTransparent.Draw(Bitmaps.Upload, Bitmaps.Diff, TransparentColor);
  //
  Bitmaps.Upload.SaveToFileEx(Scan.FullFileName, 11812, 11812);
end;

procedure TKisComparedImageListForm.MixImages(Layers: TList; Target: TBitmap);
var
  Bmp: TBitmap;
  I: Integer;
  Blend: TBlendFunction;
begin
  if Layers.Count > 0 then
  begin
    for I := 0 to Layers.Count - 1 do
    begin
      Bmp := Layers[I];
      if Assigned(Bmp) then
      begin
        FTempImage.Canvas.CopyRect(
            Rect(0, 0, FTempImage.Width, FTempImage.Height),
            Bmp.Canvas,
            Rect(0, 0, Bmp.Width, Bmp.Height));
        //
        FillChar(Blend, SizeOf(Blend), 0);
        Blend.BlendOp := AC_SRC_OVER;
        Blend.BlendFlags := 0;
        Blend.AlphaFormat := 0;
        Blend.SourceConstantAlpha := 255 - Layers.Count * 30;
        if Windows.AlphaBlend(Target.Canvas.Handle, 0, 0, Target.Width, Target.Height,
            FTempImage.Canvas.Handle, 0, 0, FTempImage.Width, FTempImage.Height, Blend)
        then
        else
          RaiseLastOSError;
      end;
    end;
  end;
end;

function TKisComparedImageListForm.PrepareDiffBitmap(var Scan: TMapScanFile; Bitmaps: TScanBitmaps): TBitmap;
var
  Comparer: IImageCompare;
  BmpFile: string;
begin
  Result := nil;
  Scan.ComparedFileName := TFileUtils.CreateTempFile(AppModule.AppTempPath);
  BmpFile := ChangeFileExt(Scan.ComparedFileName, '.bmp');
  if RenameFile(Scan.ComparedFileName, BmpFile) then
    Scan.ComparedFileName := BmpFile;
  Comparer := TImageCompareFactory.CreateImageCompare(icaKalabuhov);
//    Comparer := TImageCompareFactory.CreateImageCompare(icaCompareExe);
//  Comparer.Compare2(Scan.DBFileName, Scan.FullFileName, Result, Bitmaps.DiffArea, Bitmaps.DiffStrength);
  Comparer.Compare3(Scan.DBFileName, Scan.FullFileName, Bitmaps.DB, Bitmaps.Upload,
    Result, Bitmaps.DiffArea, Bitmaps.DiffStrength);
end;

function TKisComparedImageListForm.PrepareHistogram(Bitmap: TBitmap): Boolean;
//var
//  I1, I2: Cardinal;
begin
  Result := False;
  if FHistogram.Prepared then
    Exit;
//  I1 := GetTickCount;
  FHistogram.LoadFromBitmap(Bitmap, True, AppModule.ThreadCount);
//  I2 := GetTickCount;
//  ShowMessage(IntToStr(I2 - I1));
  Result := True;
end;

procedure TKisComparedImageListForm.PrepareMergedFileName;
var
  Tmp: string;
begin
  if not FileExists(FMergedFile) then
  begin
    if FMergedFile = '' then
    begin
      FMergedFile := TFileUtils.CreateTempFile(AppModule.AppTempPath);
      Tmp := ChangeFileExt(FMergedFile, '.bmp');
      if TFileUtils.RenameFile(FMergedFile, Tmp) then
        FMergedFile := Tmp;
    end;
  end;
end;

procedure TKisComparedImageListForm.SetMode(Value: TExecuteMode);
begin
  FMode := Value;
  case FMode of
  emList :
      begin
        pnlPictureType.Visible := False;
        ToolBar1.Visible := True;
        clbMaps.Visible := True;
        Splitter1.Visible := True;
        lArea.Visible := True;
        lRank.Visible := True;
      end;
  emOneFile :
      begin
        pnlPictureType.Visible := False;
        ToolBar1.Visible := False;
        clbMaps.Visible := False;
        Splitter1.Visible := False;
        lArea.Visible := False;
        lRank.Visible := False;
      end;
  emChangedZone :
      begin
        pnlPictureType.Visible := True;
        clbMaps.Visible := False;
        Bevel1.Visible := True;
        ToolBar1.Visible := True;
        clbMaps.Visible := False;
        Splitter1.Visible := False;
        lArea.Visible := False;
        lRank.Visible := False;
      end;
  end;
end;

procedure TKisComparedImageListForm.ShowSelectedImages;
var
  Imgs: TScanBitmaps;
  Scan: TMapScanFile;
  P: Double;
  PStr: string;
begin
  pnlInfo.Visible := FCurrentMapIndex >= 0;
  Box.Visible := FCurrentMapIndex >= 0;
  if FCurrentMapIndex >= 0 then
  begin
    Scan := FImages.Scans[FCurrentMapIndex];
    // готовим картинку по настройкам "слоёв"
    Imgs := FImages.Bitmaps[FCurrentMapIndex];
    if not Assigned(Imgs.DB) then
    begin
      Imgs.DB := Scan.PrepareBitmap(True, True);
      {$IFDEF GRAPHICS_16_BIT}
      Imgs.DB.PixelFormat := pf16bit;
      {$ENDIF}
      if not Assigned(Imgs.DB) then
        raise EKisExtException.Create(
          'Невозможно открыть планшет ' + Scan.Nomenclature + ' !' +
          sLineBreak + 'Обратитесь к администратору!',
          Scan.AsText(True));
    end;
    if FMode <> emChangedZone then
    begin
      if not Assigned(Imgs.Upload) then
      begin
        Imgs.Upload := Scan.PrepareBitmap(False, True);
        {$IFDEF GRAPHICS_16_BIT}
        Imgs.Upload.PixelFormat := pf16bit;
        {$ENDIF}
      end;
      if not Assigned(Imgs.Diff) then
      begin
        Imgs.Diff := PrepareDiffBitmap(Scan, Imgs);
        {$IFDEF GRAPHICS_16_BIT}
        Imgs.Diff.PixelFormat := pf16bit;
        {$ENDIF}
      end;
    end
    else
    if cbFileType.ItemIndex = 0 then
    begin
      PrepareMergedFileName;
      Scan.FullFileName := FFile.FileName;
      Scan.ComparedFileName := FMergedFile;
      if Rebuild and Assigned(Imgs.Upload) then
      begin
        Imgs.Upload.Free;
        Imgs.Upload := nil;
      end;
      if Rebuild or not Assigned(Imgs.Upload) then
      begin
        Imgs.Upload := Scan.PrepareBitmap(False, True);
        {$IFDEF GRAPHICS_16_BIT}
        Imgs.Upload.PixelFormat := pf16bit;
        {$ENDIF}
      end;
      if Rebuild and Assigned(Imgs.Diff) then
      begin
        Imgs.Diff.Free;
        Imgs.Diff := nil;
      end;
      if Rebuild or not Assigned(Imgs.Diff) then
      begin
        Imgs.Diff := PrepareDiffBitmap(Scan, Imgs);
        {$IFDEF GRAPHICS_16_BIT}
        Imgs.Diff.PixelFormat := pf16bit;
        {$ENDIF}
      end;
    end
    else
    begin
      PrepareMergedFileName;
      Scan.FullFileName := FMergedFile;
      Scan.ComparedFileName := FFile.FileName;
      if Rebuild and Assigned(Imgs.Diff) then
      begin
        Imgs.Diff.Free;
        Imgs.Diff := nil;
      end;
      if Rebuild or not Assigned(Imgs.Diff) then
      begin
        Imgs.Diff := GetBitmap(Scan.ComparedFileName);
        {$IFDEF GRAPHICS_16_BIT}
        Imgs.Diff.PixelFormat := pf16bit;
        {$ENDIF}
      end;
      if Rebuild and Assigned(Imgs.Upload) then
      begin
        Imgs.Upload.Free;
        Imgs.Upload := nil;
      end;
      if Rebuild or not Assigned(Imgs.Upload) then
        MergeImages(Scan, Imgs, GetSelectedColor);
    end;
    FImages.Scans[FCurrentMapIndex] := Scan;
    //
    if Imgs.DiffArea < 0 then
      lArea.Visible := False
    else
    begin
      P := 0;
      lArea.Visible := True;//CanShowDiffAreaAndRank;
      if Imgs.DiffArea = 0 then
      begin
        PStr := '0'
      end
      else
      begin
        P := Imgs.DiffArea / (Imgs.Diff.Width * Imgs.Diff.Height);
        if P > 1 then
          PStr := FloatToStr(P)
        else
          PStr := 'менее 1';
      end;
      try
        lArea.Caption := 'Изменения на ' + PStr + '% площади ('
        + IntToStr(Round(P * 62500)) + ' кв.м.)';
      except
        lArea.Caption := 'Ошибка расчёта';
      end;
    end;
    if Imgs.DiffStrength < 0 then
      lRank.Visible := False
    else
    begin
      lRank.Visible := True;//CanShowDiffAreaAndRank;
      lRank.Caption := 'Степень изменения: ' + GetRank(Imgs.DiffStrength) + '.';
    end;
    // показываем её в боксе
    UpdateCurrentImage(Imgs);
  end;
end;

procedure TKisComparedImageListForm.ToolButton2Click(Sender: TObject);
begin
  ModalResult := mrCancel;
end;

procedure TKisComparedImageListForm.TrackBar1Change(Sender: TObject);
begin
  UpdateImageScaleOptions;
  UpdateSelfOptions;
end;

procedure TKisComparedImageListForm.UpdateColorInfo;
begin
  if Idx = 1 then // область изменений
  begin
    lColor.Visible := True;
    cbColor.Visible := True;
  end
  else
  begin
    lColor.Visible := False;
    cbColor.Visible := False;
  end;
end;

procedure TKisComparedImageListForm.UpdateColorList;
var
  Clr: TColor;
  I: Integer;
begin
  Clr := GetSelectedColor;
  if FHistogram.Count = 0 then
    cbColor.AddColor(clBlack, '')
  else
  begin
    cbColor.Clear;
    for I := 0 to Min(Pred(FHistogram.Count), 9) do
      if (I = 0) or ((FHistogram.Colors[I].Count / FHistogram.TotalCount) > 0.001) then
        cbColor.AddColor(FHistogram.Colors[I].Color, '');
  end;
  //
  for I := 0 to Length(FCustomColors) - 1 do
    if cbColor.FindColor(FCustomColors[I]) < 0 then
      cbColor.AddColor(FCustomColors[I], '');
  //
  if cbColor.FindColor(Clr) >= 0 then
    cbColor.ColorValue := Clr
  else
    cbColor.ColorValue := cbColor.Colors[0];
end;

procedure TKisComparedImageListForm.UpdateCurrentImage;
var
  Layers: TList;
begin
  with FCurrentImage.Canvas do
  begin
    Brush.Style := bsSolid;
    Brush.Color := clWhite;
    Pen.Style := psSolid;
    Pen.Color := clWhite;
    Windows.Rectangle(Handle, 0, 0, FCurrentImage.Width, FCurrentImage.Height);
//    Rectangle(0, 0, FCurrentImage.Width, FCurrentImage.Height);
  end;
  FCurrentImageLayers := [];
  if not (chbOriginal.Checked or chbNewVersion.Checked or chbDiff.Checked) then
  begin
  end
  else
  begin
    Layers := TList.Create;
    try
      if chbOriginal.Checked then
      begin
        Include(FCurrentImageLayers, layOriginal);
        Layers.Add(Bmps.DB);
      end;
      if chbNewVersion.Checked then
      begin
        Include(FCurrentImageLayers, layNewVersion);
        Layers.Add(Bmps.Upload);
      end;
      if chbDiff.Checked then
      begin
        Include(FCurrentImageLayers, layDifference);
        Layers.Add(Bmps.Diff);
      end;
      MixImages(Layers, FCurrentImage);
    finally
      FreeAndNil(Layers);
    end;
  end;
  //
  Box.ImageKeepPosition := FShowed;
  try
    Box.Image.Picture.Bitmap := FCurrentImage;
  finally
    Box.ImageKeepPosition := True;
    Box.UpdateImageInfo;
    if not FShowed then
      Box.ImageScale := 50;
    FShowed := True;
    UpdateSelfScaleOptions;
  end;
end;

procedure TKisComparedImageListForm.UpdateImageScaleOptions;
begin
  if not FUpdatingSelfOptions then
  begin
    Box.ImageScale := TrackBar1.Position;
  end;
end;

procedure TKisComparedImageListForm.UpdateSelfOptions;
begin
  FUpdatingSelfOptions := True;

  chkFit.Checked := Box.ImageFitToWindow;
  UpdateSelfScaleOptions;

  FUpdatingSelfOptions := False;
end;

procedure TKisComparedImageListForm.UpdateSelfScaleOptions;
var
  Scale, Screen50Cm: Double;
  VisibleWidth: Double;
begin
  FUpdatingSelfOptions := True;

  Screen50Cm := Screen.PixelsPerInch * 50 / 2.54;
  VisibleWidth := Box.ImageWidth * Box.ImageScale / 100;
  if VisibleWidth <> 0 then
  begin
    Scale := 500 / VisibleWidth * Screen50Cm;
    LabelScale.Caption := Format('1:%d', [Round(Scale)]);
  end
  else
    LabelScale.Caption := '1:---';

  TrackBar1.Position := Box.ImageScale;
//  LabelScale.Caption := Format('%d%%', [Box.ImageScale]);

  FUpdatingSelfOptions := False;
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

{ TScanBitmaps }

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

{ TDrawTransparent }

class procedure TDrawTransparent.Draw(Target, Source: TBitmap; TransparentClr: TColor);
var
  Cnt, I, N, Y1, Y2: Integer;
  Bmp: TBitmap;
  Box: IBox;
  Exec: TTaskExecutor;
  aTask: TDrawTranspTask;
  Tasks: TObjectList;
  Rt, Bt, Gt: Byte;
//  Ba1, Ba2: Boolean;
begin
  if (Target.Width = 0) or (Target.Height = 0) or (Source.Width = 0) or (Source.Height = 0) then
    Exit;
//  Ba1 := Target.IsBottomUp;
//  Ba2 := Source.IsBottomUp;
  if (Target.Width <> Source.Width) or (Target.Height <> Source.Height) then
  begin
    Bmp := TBitmap.Create;
    Box := Bmp.Forget;
    Bmp.PixelFormat := pf24bit;
    Bmp.SetSize(Target.Width, Target.Height);
    Bmp.Canvas.StretchDraw(Rect(0, 0, Bmp.Width, Bmp.Height), Source);
//    if Bmp.IsBottomUp <> Ba1 then
//      Beep;
  end
  else
    Bmp := Source;
  //
  Rt := GetRValue(TransparentClr);
  Gt := GetGValue(TransparentClr);
  Bt := GetBValue(TransparentClr);
  //
  Cnt := AppModule.ThreadCount;
  if Cnt < 1 then
    Cnt := 1;
  if Cnt > 0 then // чисто для тестов
//  if Cnt < 2 then
    IntDraw(Target, Bmp, Rt, Gt, Bt)
  else
  begin
    Exec := TTaskExecutor.Create;
    Exec.Forget;
    Tasks := TObjectList.Create;
    Tasks.Forget;
    //
    N := Target.Height div Cnt;
    Y1 := 0;
    for I := 1 to Cnt do
    begin
      if I = Cnt then
        Y2 := Target.Height - 1
      else
        Y2 := Y1 + N - 1;
      aTask := TDrawTranspTask.Create(Target, Bmp, Rt, Gt, Bt, Y1, Y2);
      Exec.AddTask(aTask);
      Tasks.Add(aTask);
      Y1 := Y2 + 1;
    end;
    Exec.Execute('Прозрачная прорисовка', 600000);
    //
    for I := 0 to Tasks.Count - 1 do
    begin
      aTask := Tasks[I] as TDrawTranspTask;
      Target.Canvas.Draw(0, aTask.Start, aTask.Result);
    end;
  end;
end;

class procedure TDrawTransparent.IntDraw(Target, Source: TBitmap; Rt, Gt, Bt: Byte);
var
  X, Y, Idx: Integer;
  ScanLine1, ScanLine2: PByteArray;
  R2, G2, B2: Byte;
begin
  for Y := 0 to Target.Height - 1 do
  begin
    ScanLine1 := Target.ScanLine[Y];
    ScanLine2 := Source.ScanLine[Y];
    //
    Idx := 0;
    for X := 0 to Target.Width - 1 do
    begin
      R2 := ScanLine2[Idx];
      G2 := ScanLine2[Idx + 1];
      B2 := ScanLine2[Idx + 2];
      if (R2 <> Rt) or (B2 <> Bt) or (G2 <> Gt) then
      begin
        ScanLine1[Idx] := R2;
        ScanLine1[Idx + 1] := G2;
        ScanLine1[Idx + 2] := B2;
      end;
      Idx := Idx + 3;
    end;
  end;
end;

{ TDrawTransparent.TDrawTranspTask }

constructor TDrawTransparent.TDrawTranspTask.Create(Target, Source: TBitmap; Rt,
  Gt, Bt: Byte; StartLine, EndLine: Integer);
begin
  inherited Create;
  FTarget := TBitmap.Create;
  FTarget.PixelFormat := pf24bit;
  FTarget.SetSize(Target.Width, EndLine - StartLine + 1);
  FTarget.Canvas.CopyRect(Rect(0, 0, FTarget.Width, FTarget.Height),
    Target.Canvas, Rect(0, StartLine, Target.Width, EndLine));
  FSource := Source;
  FG := Gt;
  FB := Bt;
  FR := Rt;
  FStart := StartLine;
  FEnd := EndLine;
end;

destructor TDrawTransparent.TDrawTranspTask.Destroy;
begin
  FreeAndNil(FTarget);
  inherited;
end;

procedure TDrawTransparent.TDrawTranspTask.Execute;
var
  X, Y, Idx: Integer;
  ScanLine1, ScanLine2: PByteArray;
  R, G, B: Byte;
begin
  for Y := FStart to FEnd do
  begin
    ScanLine1 := FTarget.ScanLine[Y - FStart];
    ScanLine2 := FSource.ScanLine[Y];
    //
    Idx := 0;
    for X := 0 to FTarget.Width - 1 do
    begin
      R := ScanLine2[Idx];
      G := ScanLine2[Idx + 1];
      B := ScanLine2[Idx + 2];
      if (R <> FR) or (B <> FB) or (G <> FG) then
      begin
        ScanLine1[Idx] := R;
        ScanLine1[Idx + 1] := G;
        ScanLine1[Idx + 2] := B;
      end;
      Idx := Idx + 3;
    end;
  end;
end;

end.
