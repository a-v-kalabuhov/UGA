unit uKisDwgTakeBackViewForm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, CheckLst, ToolWin, ComCtrls, ActnList, ImgList, Contnrs,
  ExtCtrls, Math,
  //
  JvDotNetControls, JvExCheckLst, JvCheckListBox, JvExStdCtrls, JvCombobox,
  JvColorCombo,
  //
  EzBaseGIS, EzBasicCtrls, EzCtrls, EzCmdLine, EzEntities, EzLib, EzBase, EzActions, EzConsts,
  //
  uDisableWindowGhosting, uGraphics, uGC, uImageCompare, uImageHistogram, uFileUtils, uDebug,
  uDrawTransparent,
  //
  uKisFileReport, uMapScanFiles, uKisTakeBackFiles, uKisEzActions, uKisAppModule,
  uKisIntf, uKisMapScanIntf, uKisTakeBackFileProcessor, uKisExceptions;

type
  TKisDwgTakeBackViewForm = class(TForm)
    ToolBar1: TToolBar;
    ActionList1: TActionList;
    ToolButton1: TToolButton;
    acConfirm: TAction;
    ImageList1: TImageList;
    ToolButton2: TToolButton;
    GIS1: TEzMemoryGIS;
    pnlPictureType: TPanel;
    Label2: TLabel;
    cbFileType: TComboBox;
    ToolBar2: TToolBar;
    ToolButton3: TToolButton;
    PageControl1: TPageControl;
    tsCompare: TTabSheet;
    Panel1: TPanel;
    pnlInfo: TPanel;
    Label1: TLabel;
    LabelScale: TLabel;
    lArea: TLabel;
    lRank: TLabel;
    Bevel1: TBevel;
    TrackBar1: TTrackBar;
    chbOriginal: TCheckBox;
    chbNewVersion: TCheckBox;
    chbZone: TCheckBox;
    Button1: TButton;
    chbCrosses: TCheckBox;
    cbOriginalAlpha: TComboBox;
    cbNewVersionAlpha: TComboBox;
    cbZoneAlpha: TComboBox;
    EzDrawBox1: TEzDrawBox;
    EzCmdLine1: TEzCmdLine;
    tsLines: TTabSheet;
    procedure TrackBar1Change(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure acConfirmExecute(Sender: TObject);
    procedure chbOriginalClick(Sender: TObject);
    procedure ToolButton2Click(Sender: TObject);
    procedure cbFileTypeChange(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure chbNewVersionClick(Sender: TObject);
    procedure chbZoneClick(Sender: TObject);
    procedure EzDrawBox1ZoomChange(Sender: TObject; const Scale: Double);
    procedure EzDrawBox1MouseWheel(Sender: TObject; Shift: TShiftState; WheelDelta: Integer; MousePos: TPoint;
      var Handled: Boolean);
    procedure pnlPictureTypeResize(Sender: TObject);
    procedure FormMouseWheel(Sender: TObject; Shift: TShiftState; WheelDelta: Integer; MousePos: TPoint;
      var Handled: Boolean);
    procedure FormResize(Sender: TObject);
    procedure ToolButton3Click(Sender: TObject);
    procedure EzDrawBox1BeforeSelect(Sender: TObject; Layer: TEzBaseLayer; Recno: Integer; var CanSelect: Boolean);
    procedure EzDrawBox1MouseDown2D(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer; const WX,
      WY: Double);
    procedure EzDrawBox1MouseLeave(Sender: TObject);
    procedure chbCrossesClick(Sender: TObject);
    procedure cbOriginalAlphaChange(Sender: TObject);
    procedure cbNewVersionAlphaChange(Sender: TObject);
    procedure cbZoneAlphaChange(Sender: TObject);
    procedure GIS1BeforePaintEntity(Sender: TObject; Layer: TEzBaseLayer; Recno: Integer; Entity: TEzEntity;
      Grapher: TEzGrapher; Canvas: TCanvas; const Clip: TEzRect; DrawMode: TEzDrawMode; var CanShow: Boolean;
      var EntList: TEzEntityList; var AutoFree: Boolean);
  private
    const WM_SHOW_MAP = WM_USER + 1394;
    procedure WMShowMap(var Msg: TMessage); message WM_SHOW_MAP;
  private
    FStartup: Boolean;
    FProcessor: TTakeBackFileProcessor;
    FScaleUpdateCount: Integer;
    FScaleInitializad: Boolean;
    FZoomInitialized: Boolean;
    procedure BeginScaleUpdate;
    procedure EndScaleUpdate;
    function IsScaleUpdating: Boolean; 
    //
    function GetRank(Value: Integer): string;
    procedure ShowSelectedImages(Rebuild: Boolean);
    procedure UpdateScale;
    procedure AddPicture2(const aLayerName: string; aBitmap: TBitmap; const AlphaIndex: Integer);
    function GetAlpha(Index: Integer): Byte;
    procedure SetImageAlpha(const aLayerName: string; ItemIndex: Integer);
  private
    FGisPrepared: Boolean;
    procedure PrepareGis;
  private
    FFile: TTakeBackFileInfo;
    FTick1, FTick2: Cardinal;
    FShowed: Boolean;
    FFolders: IKisFolders;
    FAlphaOriginal: Integer;
    FAlphaNewVersion: Integer;
    FAlphaDiff: Integer;
    FImage: TBitmap;
    procedure PrepareImage();
    procedure PrepareUI();
  private
    { IKisTakeBackFileCompareEditor }
    procedure ShowEntireMap;
    procedure SetScale(aScale: Integer; aPoint: TPoint; Force: Boolean);
    procedure DisplayScaleValue(Value: Integer);
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    //
    function Execute(Folders: IKisFolders; var aFile: TTakeBackFileInfo): Boolean;
    //
    procedure SetFolders(Value: IKisFolders);
  end;

implementation

const
  SL_ZONE = 'ZONE';
  SL_OLD = 'OLD';
  SL_NEW = 'NEW';
  SL_IMAGE = 'IMAGE';
  S_SettingsSection = 'DwgTakeBackForm';

{$R *.dfm}

procedure TKisDwgTakeBackViewForm.acConfirmExecute(Sender: TObject);
begin
  ModalResult := mrOK;
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

procedure TKisDwgTakeBackViewForm.Button1Click(Sender: TObject);
begin
  ShowEntireMap();
  UpdateScale;
end;

procedure TKisDwgTakeBackViewForm.cbZoneAlphaChange(Sender: TObject);
begin
  SetImageAlpha(SL_ZONE, cbZoneAlpha.ItemIndex);
end;

procedure TKisDwgTakeBackViewForm.cbFileTypeChange(Sender: TObject);
begin
  ShowSelectedImages(True);
end;

procedure TKisDwgTakeBackViewForm.cbNewVersionAlphaChange(Sender: TObject);
begin
  SetImageAlpha(SL_NEW, cbNewVersionAlpha.ItemIndex);
end;

procedure TKisDwgTakeBackViewForm.cbOriginalAlphaChange(Sender: TObject);
begin
  SetImageAlpha(SL_OLD, cbOriginalAlpha.ItemIndex);
end;

procedure TKisDwgTakeBackViewForm.chbCrossesClick(Sender: TObject);
begin
  EzDrawBox1.ScreenGrid.Show := not EzDrawBox1.ScreenGrid.Show;
  EzDrawBox1.RegenDrawing();
end;

procedure TKisDwgTakeBackViewForm.chbZoneClick(Sender: TObject);
var
  Layer: TEzBaseLayer;
begin
  PrepareImage();
  EzDrawBox1.RegenDrawing;
  Exit;
  //
  Layer := Gis1.Layers.LayerByName(SL_ZONE);
  if Assigned(Layer) then
  begin
    Layer.LayerInfo.Visible := chbZone.Checked;
    EzDrawBox1.RegenDrawing;
  end;
end;

procedure TKisDwgTakeBackViewForm.chbNewVersionClick(Sender: TObject);
var
  Layer: TEzBaseLayer;
begin
  PrepareImage();
  EzDrawBox1.RegenDrawing;
  Exit;
  //
  Layer := Gis1.Layers.LayerByName(SL_NEW);
  if Assigned(Layer) then
  begin
    Layer.LayerInfo.Visible := chbNewVersion.Checked;
    EzDrawBox1.RegenDrawing;
  end;
end;

procedure TKisDwgTakeBackViewForm.chbOriginalClick(Sender: TObject);
var
  Layer: TEzBaseLayer;
begin
  PrepareImage();
  EzDrawBox1.RegenDrawing;
  Exit;
  //
  Layer := Gis1.Layers.LayerByName(SL_OLD);
  if Assigned(Layer) then
  begin
    Layer.LayerInfo.Visible := chbOriginal.Checked;
    EzDrawBox1.RegenDrawing;
  end;
end;

procedure TKisDwgTakeBackViewForm.ShowEntireMap();
begin
  EzDrawBox1.ZoomToExtension();
end;

constructor TKisDwgTakeBackViewForm.Create(AOwner: TComponent);
begin
  inherited;
  FProcessor := TTakeBackFileProcessor.Create();
end;

destructor TKisDwgTakeBackViewForm.Destroy;
begin
  FreeAndNil(FImage);
  FreeAndNil(FProcessor);
  inherited;
end;

procedure TKisDwgTakeBackViewForm.EndScaleUpdate;
begin
  if FScaleUpdateCount > 0 then
    Dec(FScaleUpdateCount);
end;

function TKisDwgTakeBackViewForm.Execute(Folders: IKisFolders; var aFile: TTakeBackFileInfo): Boolean;
begin
  FTick1 := GetTickCount;
  //
  //непрозрачный
  //10%
  //25%
  //50%
  //75%
  //90%
//  FAlphaOriginal := AppModule.ReadAppParamDef(S_SettingsSection, 'AlphaOld', varInteger, 0);
//  cbOriginalAlpha.ItemIndex := IfThen(FAlphaOriginal < 0, 0, FAlphaOriginal);
//  FAlphaNewVersion := AppModule.ReadAppParamDef(S_SettingsSection, 'AlphaNew', varInteger, 2);
//  cbNewVersionAlpha.ItemIndex := IfThen(FAlphaNewVersion < 0, 0, FAlphaNewVersion);
//  FAlphaDiff := AppModule.ReadAppParamDef(S_SettingsSection, 'AlphaZone', varInteger, 3);
//  cbZoneAlpha.ItemIndex := IfThen(FAlphaDiff < 0, 0, FAlphaDiff);
  //
  FShowed := False;
  FFolders := Folders;
  Caption := 'Приём планшета ' + aFile.Nomenclature;
  FFile := aFile;
  PrepareUI();
  // поготовить файлы
  // - оригинал
  // - сшивка
  // - изменения
  FStartup := True;
  try
    // заполняем VBitmaps
    FProcessor.PrepareVector(Folders, aFile);
    if aFile.Kind = tbZones then
    begin
      cbFileType.ItemIndex := 1;
    end
    else
    //    if aFile.Kind = tbEntireMap then
    begin
      cbFileType.ItemIndex := 0;
    end;
  finally
    FStartup := False;
  end;
  //
  ShowSelectedImages(False);
  //
  Result := ShowModal = mrOK;
  if Result then
  begin
  //    if FImages.Bitmaps[0].DiffArea = 0 then
  //      aFile.Kind := tbNoChanges
  //    else
    aFile := FFile;
    if cbFileType.ItemIndex = 0 then
      aFile.Kind := tbEntireMap
    else
    if cbFileType.ItemIndex = 1 then
    begin
      aFile.Kind := tbZones;
      aFile.MergedFile := FProcessor.MergedFileName;
    end;
    aFile.Confirmed := True;
  end
  else
    FProcessor.Clear();
  //
//  AppModule.SaveAppParam(S_SettingsSection, 'AlphaOld', cbOriginalAlpha.ItemIndex);
//  AppModule.SaveAppParam(S_SettingsSection, 'AlphaNew', cbNewVersionAlpha.ItemIndex);
//  AppModule.SaveAppParam(S_SettingsSection, 'AlphaZone', cbZoneAlpha.ItemIndex);
end;

procedure TKisDwgTakeBackViewForm.EzDrawBox1BeforeSelect(Sender: TObject; Layer: TEzBaseLayer; Recno: Integer;
  var CanSelect: Boolean);
begin
  CanSelect := False;
end;

procedure TKisDwgTakeBackViewForm.EzDrawBox1MouseDown2D(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X,
  Y: Integer; const WX, WY: Double);
var
  S: ShortString;
  ScrollAction: TAutoHandScrollAction;
begin
  with EzCmdLine1 do
  begin
//    if (CurrentAction is TLtMeasureAction) then
//      Exit;
    S := CurrentAction.ClassName;
    case Button of
    mbRight :
      begin
        if (S <> 'THandScrollAction') and
           (S <> 'TZoomWindowAction') and
           (S <> 'TPanningAction') and
           (S <> 'TAutoHandScrollAction') and
           (S <> 'TMeasuresAction')
        then
        begin
          ScrollAction := TAutoHandScrollAction.CreateAction(EzCmdLine1);
          ScrollAction.OnMouseDown(Self, mbLeft, Shift, X, Y, WX, WY);
          EzCmdLine1.Push(ScrollAction, False, SCmdHandScroll, 'AutoScroll');
        end;
      end;
    end; // of case
  end;
end;

procedure TKisDwgTakeBackViewForm.EzDrawBox1MouseLeave(Sender: TObject);
var
  S, S1: String;
begin
  S := EzCmdLine1.CurrentAction.ClassName;
  S1 := EzCmdLine1.CurrentAction.ActionID;
  if (S = 'TAutoHandScrollAction') and (S1 = 'AutoScroll') then
  begin
    if EzCmdLine1.CurrentAction is TAutoHandScrollAction then
    begin
      TAutoHandScrollAction(EzCmdLine1.CurrentAction).Finish();
    end;
    EzCmdLine1.Clear;
    EzDrawBox1.RegenDrawing;
  end;
end;

procedure TKisDwgTakeBackViewForm.EzDrawBox1MouseWheel(Sender: TObject; Shift: TShiftState; WheelDelta: Integer;
  MousePos: TPoint; var Handled: Boolean);
var
  Pt: TPoint;
begin
  Pt := Mouse.CursorPos;
  Pt := EzDrawBox1.ScreenToClient(Pt);
  if PtInRect(EzDrawBox1.ClientRect, Pt) then
  begin
    if WheelDelta > 0 then
      SetScale(TrackBar1.Position + 1, MousePos, False)
    else
    if WheelDelta < 0 then
      SetScale(TrackBar1.Position - 1, MousePos, False);
    Handled := True;
  end;
end;

procedure TKisDwgTakeBackViewForm.EzDrawBox1ZoomChange(Sender: TObject; const Scale: Double);
begin
  UpdateScale;
end;

procedure TKisDwgTakeBackViewForm.FormMouseWheel(Sender: TObject; Shift: TShiftState; WheelDelta: Integer;
  MousePos: TPoint; var Handled: Boolean);
var
  Pt, ClPt: TPoint;
begin
  Pt := Mouse.CursorPos;
  ClPt := TrackBar1.ScreenToClient(Pt);
  if PtInRect(TrackBar1.ClientRect, ClPt) then
  begin
    if WheelDelta > 0 then
      SetScale(TrackBar1.Position + 1, Point(-1,-1), False)
    else
    if WheelDelta < 0 then
      SetScale(TrackBar1.Position - 1, Point(-1,-1), False);
    Handled := True;
  end
  else
  begin
    ClPt := EzDrawBox1.ScreenToClient(Pt);
    if PtInRect(EzDrawBox1.ClientRect, ClPt) then
    begin
      if Assigned(EzDrawBox1.OnMouseWheel) then
        if not EzDrawBox1.Focused then
          EzDrawBox1.OnMouseWheel(EzDrawBox1, Shift, WheelDelta, ClPt, Handled);
    end;
  end;
end;

procedure TKisDwgTakeBackViewForm.FormResize(Sender: TObject);
begin
  SendMessage(Handle, WM_SHOW_MAP, 0, 0);
end;

procedure TKisDwgTakeBackViewForm.FormShow(Sender: TObject);
begin
//  ShowEntireMap();
  FTick2 := GetTickCount;
  Caption := Caption + '... (' + IntToStr(Round((FTick2 - FTick1) / 1000)) + ' сек.)';
  EzDrawBox1.SetFocus;
end;

function TKisDwgTakeBackViewForm.GetAlpha(Index: Integer): Byte;
begin
  Result := 0;
  Exit;
  //непрозрачный
  //10%
  //25%
  //50%
  //75%
  //90%
  case Index of
  1 : Result := 26;
  2 : Result := 64;
  3 : Result := 128;
  4 : Result := 192;
  5 : Result := 240;
  else
      Result := 0;
  end;
end;

function TKisDwgTakeBackViewForm.GetRank(Value: Integer): string;
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

procedure TKisDwgTakeBackViewForm.GIS1BeforePaintEntity(Sender: TObject; Layer: TEzBaseLayer; Recno: Integer;
  Entity: TEzEntity; Grapher: TEzGrapher; Canvas: TCanvas; const Clip: TEzRect; DrawMode: TEzDrawMode;
  var CanShow: Boolean; var EntList: TEzEntityList; var AutoFree: Boolean);
begin
  if Entity.EntityID = idBitmapRef then
  begin
    if (Layer.Name = SL_ZONE) then
    begin
      if Assigned(FProcessor.VBitmaps.Zone) then
        TEzBitmapRef(Entity).Image := FProcessor.VBitmaps.Zone
    end
    else
    if Layer.Name = SL_OLD then
      TEzBitmapRef(Entity).Image := FProcessor.VBitmaps.OldVector
    else
    if Layer.Name = SL_NEW then
      TEzBitmapRef(Entity).Image := FProcessor.VBitmaps.NewVector
    else
    if Layer.Name = SL_IMAGE then
      TEzBitmapRef(Entity).Image := FImage;
  end;
end;

function TKisDwgTakeBackViewForm.IsScaleUpdating: Boolean;
begin
  Result := FScaleUpdateCount > 0;
end;

procedure TKisDwgTakeBackViewForm.pnlPictureTypeResize(Sender: TObject);
begin
  Panel1.Margins.Top := pnlPictureType.Height + 1;
end;

procedure TKisDwgTakeBackViewForm.PrepareGis;
begin
  if FGisPrepared then
    Exit;
  GIS1.Close;
  //
  PrepareImage();
//  AddPicture2(SL_ZONE, FProcessor.VBitmaps.Zone, FAlphaDiff);
//  AddPicture2(SL_OLD, FProcessor.VBitmaps.OldVector, FAlphaOriginal);
//  AddPicture2(SL_NEW, FProcessor.VBitmaps.NewVector, FAlphaNewVersion);
  AddPicture2(SL_IMAGE, FImage, FAlphaNewVersion);
  //
  GIS1.Open;
  //
  FGisPrepared := True;
end;

procedure TKisDwgTakeBackViewForm.PrepareImage;
var
  Drawer: IDrawTransparent;
  Kind: TDrawTransparentKind;
  I: Integer;
  Filled: Boolean;
begin
  Filled := False;
  if FImage = nil then
  begin
    FImage := TMapImage.CreateMapImage(CL_MAP_SCAN_BACK);
    Filled := True;
  end;
  Kind := drawThreaded;
  Drawer := TDrawTransparentFactory.GetDraw(FFolders, Kind);
  if chbZone.Checked and Assigned(FProcessor.VBitmaps.Zone) then
    FImage.Canvas.Draw(0, 0, FProcessor.VBitmaps.Zone)
  else
  if not Filled then
    FImage.FillBackground(CL_MAP_SCAN_BACK);
  if chbOriginal.Checked then
    Drawer.Draw(FImage, FProcessor.VBitmaps.OldVector, clWhite);
//    FImage.Canvas.Draw(0, 0, FProcessor.VBitmaps.OldVector);
  if chbNewVersion.Checked then
    Drawer.Draw(FImage, FProcessor.VBitmaps.NewVector, clWhite);
//    FImage.Canvas.Draw(0, 0, FProcessor.VBitmaps.NewVector);
end;

procedure TKisDwgTakeBackViewForm.PrepareUI();
begin
  pnlPictureType.Visible := True;
  Bevel1.Visible := True;
  ToolBar1.Visible := True;
  lArea.Visible := False;
  lRank.Visible := False;
end;

procedure TKisDwgTakeBackViewForm.ShowSelectedImages;
var
  P: Double;
  PStr: string;
  PArea: String;
begin
  pnlInfo.Visible := True;
  EzDrawBox1.Visible := True;
  // готовим картинку по настройкам "слоёв"
  if not Assigned(FProcessor.VBitmaps.OldVector) then
  begin
    raise EKisExtException.Create(
      'Невозможно открыть планшет ' + FProcessor.Scan.Nomenclature + ' !' +
      sLineBreak + 'Обратитесь к администратору!',
      FProcessor.Scan.AsText(True)
    );
  end;
//  FProcessor.PrepareImages(FFolders, Rebuild, cbFileType.ItemIndex = 0, FFile.FileName, GetSelectedColor);
  //
  if FProcessor.VBitmaps.DiffArea < 0 then
    lArea.Visible := False
  else
  begin
    lArea.Visible := True;
    PArea := '';
    if FProcessor.VBitmaps.DiffArea = 0 then
    begin
      PStr := '0'
    end
    else
    begin
      P := FProcessor.VBitmaps.DiffArea / (FProcessor.VBitmaps.OldVector.Width * FProcessor.VBitmaps.OldVector.Height);
      if P > 1 then
        PStr := FloatToStr(P)
      else
        PStr := 'менее 1';
      PArea := ' (' + IntToStr(Round(P * 62500)) + ' кв.м.)';
    end;
    lArea.Caption := 'Изменения на ' + PStr + '% площади' + PArea
  end;
  if FProcessor.VBitmaps.DiffStrength < 0 then
    lRank.Visible := False
  else
  begin
    lRank.Visible := True;
    lRank.Caption := 'Степень изменения: ' + GetRank(FProcessor.VBitmaps.DiffStrength) + '.';
  end;
  //
  PrepareGis();
  //
  EzDrawBox1.RegenDrawing;
end;

procedure TKisDwgTakeBackViewForm.ToolButton2Click(Sender: TObject);
begin
  ModalResult := mrCancel;
end;

procedure TKisDwgTakeBackViewForm.ToolButton3Click(Sender: TObject);
var
  Act: TKisMapMeasureAction;
begin
  if EzCmdLine1.CurrentAction is TKisMapMeasureAction then
    EzCmdLine1.Clear()
  else
  begin
    Act := TKisMapMeasureAction.CreateAction(EzCmdLine1);
    EzCmdLine1.Push(Act, True, 'CALC_MAP', '');
  end;
end;

procedure TKisDwgTakeBackViewForm.TrackBar1Change(Sender: TObject);
begin
  SetScale(TrackBar1.Position, Point(-1, -1), True);
end;

procedure TKisDwgTakeBackViewForm.SetFolders(Value: IKisFolders);
begin
  FFolders := Value;
end;

procedure TKisDwgTakeBackViewForm.SetImageAlpha;
var
  Layer: TEzBaseLayer;
  Ent: TEzEntity;
begin
  Exit;
  if not FGisPrepared then
    Exit;
  Layer := Gis1.Layers.LayerByName(aLayerName);
  if Assigned(Layer) then
  if Layer.RecordCount > 0 then
  begin
    Layer.Last;
    Ent := Layer.RecLoadEntity();
    Ent.Forget();
    if Ent is TEzBitmapRef then
    begin
      TEzBitmapRef(Ent).AlphaChannel := GetAlpha(ItemIndex);
      Layer.UpdateEntity(Layer.Recno, Ent);
      EzDrawBox1.RegenDrawing;
    end;
  end;
end;

procedure TKisDwgTakeBackViewForm.AddPicture2(const aLayerName: string; aBitmap: TBitmap; const AlphaIndex: Integer);
var
  Layer1: TEzBaseLayer;
  BmpRef: TEzBitmapRef;
begin
  Layer1 := GIS1.CreateLayer(aLayerName, ltMemory);
  if not Assigned(aBitmap) then
    Exit;
  BmpRef := TEzBitmapRef.CreateEntity(Point2D(0, 0), Point2D(250, 250), aBitmap);
  BmpRef.Forget();
  BmpRef.AlphaChannel := GetAlpha(AlphaIndex);
  Layer1.AddEntity(BmpRef);
  Layer1.UpdateExtension;
end;

procedure TKisDwgTakeBackViewForm.BeginScaleUpdate;
begin
  Inc(FScaleUpdateCount);
end;

procedure TKisDwgTakeBackViewForm.SetScale(aScale: Integer; aPoint: TPoint; Force: Boolean);
var
  ZoomRect: TEzRect; // видимая область в мировых координатах
  X1, X2, Y1, Y2, Xc, Yc: Double;
  Hcm, Wcm: Double;
  HcmMap, WcmMap: Double;
  HcmWorld, WcmWorld: Double;
  HmWorld, WmWorld: Double;
  Kx, Ky: Double;
begin
  if IsScaleUpdating then
    Exit;
  BeginScaleUpdate;
  try
    if aScale < 1 then
      aScale := 1;
    if aScale > TrackBar1.Max then
      aScale := TrackBar1.Max;
    Force := Force or not FScaleInitializad;
    if (aScale = TrackBar1.Position) and not Force then
      Exit;
    FScaleInitializad := True;
    //  3. Назначаю зум по центру.
    EzDrawBox1.CurrentExtents(X1, Y1, X2, Y2);
    if (aPoint.X < 0) or (aPoint.Y < 0) then
    begin
      aPoint.X := EzDrawBox1.ClientWidth div 2;
      aPoint.Y := EzDrawBox1.ClientHeight div 2;
    end;
    EzDrawBox1.DrawBoxToWorld(aPoint.X, aPoint.Y, Xc, Yc);
    // При масштабе 1 в 1 см экрана умещается 0,2 см планшета
    // При масштабе 2 в 1 см экрана умещается 0,4 см планшета
    // При масштабе 5 в 1 см экрана умещается 1 см планшета
    // Находим рамер экрана
    // Переводим его в сантиметры
    // Считаем сколько сантиметров планшета получится в этой области при заданном масштабе
    Hcm := EzDrawBox1.ClientHeight / Screen.PixelsPerInch * 2.54;
    Wcm := EzDrawBox1.ClientWidth / Screen.PixelsPerInch * 2.54;
    HcmMap := Hcm * aScale / 5;
    WcmMap := Wcm * aScale / 5;
    // В одном сантиметре планшета у нас 500 сантиметров на местности
    // Значит размер прямоугольника экрана в мировых координатах будет таким
    HcmWorld := HcmMap * 500;
    WcmWorld := WcmMap * 500;
    HmWorld := HcmWorld / 100;
    WmWorld := WcmWorld / 100;
    // Теперь зная размеры области в мировых координатах
    // Нужно просто установить эту новую облсть в правильное место
    Kx := aPoint.X / EzDrawBox1.ClientWidth;
    Ky := (EzDrawBox1.ClientHeight + 1 - aPoint.Y) / (EzDrawBox1.ClientHeight + 1);
    ZoomRect.xmin := Xc - WmWorld * Kx;
    ZoomRect.xmax := ZoomRect.xmin + WmWorld;
    ZoomRect.ymin := Yc - HmWorld * Ky;
    ZoomRect.ymax := ZoomRect.ymin + HmWorld;
    //
    EzDrawBox1.ZoomWindow(ZoomRect);
    EzDrawBox1.DrawBoxToWorld(aPoint.X, aPoint.Y, Kx, Ky);

    ZoomRect.xmin := ZoomRect.xmin - (Kx - Xc);
    ZoomRect.xmax := ZoomRect.xmax - (Kx - Xc);
    ZoomRect.ymin := ZoomRect.ymin - (Ky - Yc);
    ZoomRect.ymax := ZoomRect.ymax - (Ky - Yc);
//    EzDrawBox1.ZoomWindow(ZoomRect);

    //
    DisplayScaleValue(aScale);
  finally
    EndScaleUpdate;
  end;
end;

procedure TKisDwgTakeBackViewForm.UpdateScale;
var
  Scale, Screen50Cm: Double;
  VisibleWidth: Double;
  Layer: TEzBaseLayer;
  Pic: TEzEntity;
  Wx1, Wx2, Wy1, Wy2: Integer;
  ScaleTrackIndex: Integer;
begin
  BeginScaleUpdate;
  try
    Scale := -1;
    Screen50Cm := Screen.PixelsPerInch * 50 / 2.54; // пикселей в сантиметрах
    Layer := GIS1.CurrentLayer;
    if Assigned(Layer) then
    begin
      Pic := Layer.EntityWithRecno(1);
      if Assigned(Pic) then
      begin
        EzDrawBox1.WorldToDrawBox(Pic.FBox.X1, Pic.FBox.Y1, Wx1, Wy1);
        EzDrawBox1.WorldToDrawBox(Pic.FBox.X2, Pic.FBox.Y2, Wx2, Wy2);
        VisibleWidth := Abs(Wx2 - Wx1); // ширина картинки в пикселях на экране
        Scale := 100 * Screen50Cm / VisibleWidth;
      end;
    end;
    if Scale > 0 then
    begin
      Scale := Round(Scale) * 5;
      LabelScale.Caption := Format('1:%d', [Round(Scale)]);
      ScaleTrackIndex := Round(Scale / 100);
      DisplayScaleValue(ScaleTrackIndex);
    end
    else
      LabelScale.Caption := '1:---';
  finally
    EndScaleUpdate;
  end;
end;

procedure TKisDwgTakeBackViewForm.WMShowMap(var Msg: TMessage);
begin
//  EzDrawBox1.Resize;
//  ShowEntireMap();
  if not FZoomInitialized then
  begin
    FZoomInitialized := True;
    ShowEntireMap();
  end;
end;

procedure TKisDwgTakeBackViewForm.DisplayScaleValue(Value: Integer);
begin
  if Value < 1 then
    Value := 1
  else
    if Value > TrackBar1.Max then
      Value := TrackBar1.Max;
  TrackBar1.Position := Value;
end;

end.
