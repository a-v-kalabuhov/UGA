unit uKisComparedImageForm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms, Buttons,
  Dialogs, ComCtrls, StdCtrls, ToolWin, ExtCtrls, ActnList, ImgList, OleCtrls, Jpeg,
  ATImageBox, ATPrintPreview, ATxPrintProc,
  uFileUtils, uAutoCAD,
  uKisFileReport, uKisIntf, uMapScanFiles, uKisAppModule;

type
  TKisComparedImageForm = class(TForm, IKisImageViewer)
    Button1: TButton;
    Button2: TButton;
    ActionList1: TActionList;
    ImageList1: TImageList;
    acZoomIn: TAction;
    acZoomOut: TAction;
    acZoomAll: TAction;
    acZoom100: TAction;
    Box: TATImageBox;
    Panel1: TPanel;
    Label1: TLabel;
    LabelScale: TLabel;
    TrackBar1: TTrackBar;
    chkFit: TCheckBox;
    lArea: TLabel;
    lRank: TLabel;
    btnSaveImage: TBitBtn;
    SaveDialog2: TSaveDialog;
    btnPrint: TBitBtn;
    procedure TrackBar1Change(Sender: TObject);
    procedure chkFitClick(Sender: TObject);
    procedure btnSaveImageClick(Sender: TObject);
    procedure btnPrintClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
  private
    FFileState: TImageCompareState;
    FUpdatingSelfOptions: Boolean;
    function GetRank(Value: Integer): string;
    procedure UpdateImageScaleOptions;
    procedure UpdateSelfOptions;
    procedure UpdateSelfScaleOptions;
  private
    function ConfirmImage(const aCaption, aFileName: string): Boolean;
    procedure ShowImage(const aCaption, aFileName: string);
    function GetAllowPrint: Boolean;
    procedure SetAllowPrint(Value: Boolean);
    function GetAllowSave: Boolean;
    procedure SetAllowSave(Value: Boolean);
    procedure PrepareTempFile(const aFileName: string);
  private
    FOptPrepared: Boolean;
    FOpt: TATPrintOptions;
    FTempFile: string;
  public
    function Execute(aFileState: TImageCompareState): Boolean;
  end;

implementation

{$R *.dfm}

uses
  uKisExceptions;

{ TKisComparedImageForm }

procedure TKisComparedImageForm.btnPrintClick(Sender: TObject);
begin
  if not FOptPrepared then
  begin
    FillChar(FOpt, SizeOf(FOpt), 0);
    with FOpt do
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
        FontSize := 20;//FIni.ReadInteger('Opt', 'FontSize', 9);
        FontStyle := [];//TFontStyles(byte(FIni.ReadInteger('Opt', 'FontStyle', 0)));
        FontColor := clBlack;//FIni.ReadInteger('Opt', 'FontColor', clBlack);
        FontCharset := DEFAULT_CHARSET; //FIni.ReadInteger('Opt', 'FontCharset', DEFAULT_CHARSET);
      end;

//      PixelsPerInch := 300;
      PixelsPerInch := Screen.PixelsPerInch;
      JobCaption := Self.Caption;
      FailOnErrors := True;
      OptUnit := pUnitCm;
      OptFooter.Caption := Self.Caption;
    end;
    FOptPrepared := True;
  end;
  PicturePrint(Box.Image.Picture, FOpt);
end;

procedure TKisComparedImageForm.btnSaveImageClick(Sender: TObject);
var
  Jpg: TJPEGImage;
begin
  SaveDialog2.DefaultExt := '.jpg';
  SaveDialog2.Filter := 'Файлы JPEG (.jpg)|*.jpg';
  SaveDialog2.FilterIndex := 0;
  if SaveDialog2.Execute(Self.Handle) then
  begin
    Jpg := TJPEGImage.Create;
    Jpg.Assign(Box.Image.Picture.Graphic);
    Jpg.SaveToFile(SaveDialog2.Files[0]);
  end;
end;

procedure TKisComparedImageForm.chkFitClick(Sender: TObject);
begin
  Box.ImageFitToWindow := chkFit.Checked;
end;

function TKisComparedImageForm.ConfirmImage(const aCaption, aFileName: string): Boolean;
var
  FileToView: string;
begin
  FFileState := nil;
  lArea.Visible := False;
  lRank.Visible := False;
  Button2.Visible := True;
  //
  chkFit.Checked := True;
  //
  Box.ImageFitToWindow := chkFit.Checked;
  Box.ImageCenter := True;
  Box.Image.Resample := True;
  Box.Image.ResampleDelay := 200;
  Box.ImageLabel.Visible := False;
  Box.ImageDrag := True;
  Box.ImageKeepPosition := True;
  //
  PrepareTempFile(aFileName);
  if FTempFile <> '' then
    FileToView := FTempFile
  else
    FileToView := aFileName;
  try
    Box.Image.Picture.LoadFromFile(FileToView);
  finally
    Box.UpdateImageInfo;
    UpdateSelfScaleOptions;
    if FileExists(FTempFile) then
      DeleteFile(FTempFile);
  end;
  Result := ShowModal = mrOK;
end;

function TKisComparedImageForm.Execute(aFileState: TImageCompareState): Boolean;
var
  FileToView: string;
begin
  Button2.Visible := True;
  FFileState := aFileState;
  if FFileState.Area < 0 then
    lArea.Visible := False
  else
    lArea.Caption := 'Изменения на ' + FloatToStr(FFileState.Area / 10)
    + '% площади (' + IntToStr(Round(FFileState.Area / 10 * 625)) + ' кв.м.).';
  if FFileState.Strength < 0 then
    lRank.Visible := False
  else
    lRank.Caption := 'Степень изменения: ' + GetRank(FFileState.Strength) + '.';
  //
  chkFit.Checked := True;
  //
  Box.ImageFitToWindow := chkFit.Checked;
  Box.ImageCenter := True;
  Box.Image.Resample := True;
  Box.Image.ResampleDelay := 200;
  Box.ImageLabel.Visible := False;
  Box.ImageDrag := True;
  Box.ImageKeepPosition := True;
  //
  PrepareTempFile(FFileState.CompareImage);
  if FTempFile <> '' then
    FileToView := FTempFile
  else
    FileToView := FFileState.CompareImage;
  try
    Box.Image.Picture.LoadFromFile(FileToView);
  finally
    Box.UpdateImageInfo;
    UpdateSelfScaleOptions;
    if FileExists(FTempFile) then
      DeleteFile(FTempFile);
  end;
  Result := ShowModal = mrOk;
end;

procedure TKisComparedImageForm.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  Box.Image.Picture.Graphic := nil;
end;

function TKisComparedImageForm.GetAllowPrint: Boolean;
begin
  Result := btnPrint.Visible;
end;

function TKisComparedImageForm.GetAllowSave: Boolean;
begin
  Result := btnSaveImage.Visible;
end;

function TKisComparedImageForm.GetRank(Value: Integer): string;
begin
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

procedure TKisComparedImageForm.PrepareTempFile;
var
  Bmp: TBitmap;
begin
  FTempFile := '';
  if TMapScanStorage.FileIsVector(aFileName) then
  begin
    FTempFile := TFileUtils.GenerateTempFileName(AppModule.AppTempPath());
    FTempFile := ChangeFileExt(FTempFile, '.bmp');
    Bmp := TAutoCADUtils.ExportToBitmap(aFileName, SZ_MAP_PX, SZ_MAP_PX);
    try
      Bmp.SaveToFile(FTempFile);
    finally
      Bmp.Free;
    end;
  end;
end;

procedure TKisComparedImageForm.SetAllowPrint(Value: Boolean);
begin
  btnPrint.Visible := Value;
end;

procedure TKisComparedImageForm.SetAllowSave(Value: Boolean);
begin
  btnSaveImage.Visible := Value;
end;

procedure TKisComparedImageForm.ShowImage;
var
  FileToView: string;
begin
  FFileState := nil;
  Caption := aCaption;
  lArea.Visible := False;
  lRank.Visible := False;
  Button2.Visible := False;
  //
  chkFit.Checked := True;
  //
  Box.ImageFitToWindow := chkFit.Checked;
  Box.ImageCenter := True;
  Box.Image.Resample := True;
  Box.Image.ResampleDelay := 200;
  Box.ImageLabel.Visible := False;
  Box.ImageDrag := True;
  Box.ImageKeepPosition := True;
  //
  PrepareTempFile(aFileName);
  if FTempFile <> '' then
    FileToView := FTempFile
  else
    FileToView := aFileName;
  try
    Box.Image.Picture.LoadFromFile(FileToView);
  finally
    Box.UpdateImageInfo;
    UpdateSelfScaleOptions;
    if FileExists(FTempFile) then
      DeleteFile(FTempFile);
  end;
  ShowModal;
end;

procedure TKisComparedImageForm.TrackBar1Change(Sender: TObject);
begin
  UpdateImageScaleOptions;
  UpdateSelfOptions;
end;

procedure TKisComparedImageForm.UpdateImageScaleOptions;
begin
  if not FUpdatingSelfOptions then
  begin
    Box.ImageScale := TrackBar1.Position;
  end;
end;

procedure TKisComparedImageForm.UpdateSelfOptions;
begin
  FUpdatingSelfOptions := True;

  chkFit.Checked := Box.ImageFitToWindow;
  UpdateSelfScaleOptions;

  FUpdatingSelfOptions := False;
end;

procedure TKisComparedImageForm.UpdateSelfScaleOptions;
begin
  FUpdatingSelfOptions := True;

  TrackBar1.Position := Box.ImageScale;
  LabelScale.Caption := Format('%d%%', [Box.ImageScale]);

  FUpdatingSelfOptions := False;
end;

end.
