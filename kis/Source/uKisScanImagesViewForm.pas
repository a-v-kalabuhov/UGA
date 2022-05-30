unit uKisScanImagesViewForm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, CheckLst, ToolWin, ComCtrls, ActnList, ImgList, Contnrs,
  ExtCtrls, Math,
  //
  JvDotNetControls, JvExCheckLst, JvCheckListBox, JvExStdCtrls, JvCombobox, JvColorCombo,
  //
  EzBaseGIS, EzBasicCtrls, EzCtrls, EzCmdLine, EzEntities, EzLib, EzBase, EzActions, EzConsts,
  //
  uGraphics, uGC, uFileUtils, uDebug, uDisableWindowGhosting, uGeoUtils, uAutoCAD, uMapScanFiles,
  //
  uKisIntf, uKisExceptions, uKisEzActions;

type
  TImage1 = class
  private
    FLayerName: string;
    FLayerTitle: string;
    FRect: TRect;
    FFileName: string;
    FBitmap: TBitmap;
    FRecno: Integer;
    procedure SetLayerName(const Value: string);
    procedure SetLayerTitle(const Value: string);
    procedure SetRect(const Value: TRect);
    procedure SetFileName(const Value: string);
    procedure SetBitmap(const Value: TBitmap);
    procedure SetRecno(const Value: Integer);
  public
    destructor Destroy; override;
    //
    property Bitmap: TBitmap read FBitmap write SetBitmap;
    property FileName: string read FFileName write SetFileName;
    property LayerName: string read FLayerName write SetLayerName;
    property LayerTitle: string read FLayerTitle write SetLayerTitle;
    property Recno: Integer read FRecno write SetRecno;
    property Rect: TRect read FRect write SetRect;
  end;
  
  TImages = class
  private
    FList: TObjectList;
    function GetItems(Index: Integer): TImage1;
  public
    constructor Create;
    destructor Destroy; override;
    //
    procedure Add(const aFileName, aLayerName, aLayerTitle: string; const aImageRect: TRect);
    function Count: Integer;
    function GetBitmap(const LayerName: string; const Recno: Integer): TBitmap;
    //
    property Items[Index: Integer]: TImage1 read GetItems;
  end;

  TKisScanImagesViewForm = class(TForm)
    ToolBar1: TToolBar;
    ActionList1: TActionList;
    ToolButton1: TToolButton;
    acConfirm: TAction;
    ImageList1: TImageList;
    Panel1: TPanel;
    pnlInfo: TPanel;
    Label1: TLabel;
    LabelScale: TLabel;
    lArea: TLabel;
    lRank: TLabel;
    TrackBar1: TTrackBar;
    Bevel1: TBevel;
    ColorDialog1: TColorDialog;
    GIS1: TEzMemoryGIS;
    EzDrawBox1: TEzDrawBox;
    EzCmdLine1: TEzCmdLine;
    Button1: TButton;
    pnlPictureType: TPanel;
    Label2: TLabel;
    cbFileType: TComboBox;
    chbCrosses: TCheckBox;
    ToolButton2: TToolButton;
    ToolBar2: TToolBar;
    ToolButton3: TToolButton;
    procedure TrackBar1Change(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure acConfirmExecute(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure EzDrawBox1ZoomChange(Sender: TObject; const Scale: Double);
    procedure EzDrawBox1MouseWheel(Sender: TObject; Shift: TShiftState; WheelDelta: Integer; MousePos: TPoint;
      var Handled: Boolean);
    procedure pnlPictureTypeResize(Sender: TObject);
    procedure FormMouseWheel(Sender: TObject; Shift: TShiftState; WheelDelta: Integer; MousePos: TPoint;
      var Handled: Boolean);
    procedure FormResize(Sender: TObject);
    procedure GIS1AfterPaintEntity(Sender: TObject; Layer: TEzBaseLayer; Recno: Integer; Entity: TEzEntity;
      Grapher: TEzGrapher; Canvas: TCanvas; const Clip: TEzRect; DrawMode: TEzDrawMode);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure chbCrossesClick(Sender: TObject);
    procedure ToolButton2Click(Sender: TObject);
    procedure EzDrawBox1MouseDown2D(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer; const WX,
      WY: Double);
    procedure EzDrawBox1MouseLeave(Sender: TObject);
    procedure EzDrawBox1BeforeSelect(Sender: TObject; Layer: TEzBaseLayer; Recno: Integer; var CanSelect: Boolean);
    procedure ToolButton3Click(Sender: TObject);
  private
    const WM_SHOW_MAP = WM_USER + 1394;
    procedure WMShowMap(var Msg: TMessage); message WM_SHOW_MAP;
  private
    FImages: TImages;
    FNomenclatures: TStringList;
    FScaleUpdateCount: Integer;
    FScaleInitializad: Boolean;
    FZoomInitialized: Boolean;
    procedure BeginScaleUpdate;
    procedure EndScaleUpdate;
    function IsScaleUpdating: Boolean; 
    //
    function GetRank(Value: Integer): string;
    procedure UpdateScale;
    procedure AddNomenclatureLayer();
    function AddPicture2(Img: TImage1; const Alpha: Byte): Integer;
  private
    FGisPrepared: Boolean;
    procedure PrepareGis();
  private
    FLayerControls: TList;
    FLayers: TStringList;
    procedure FillLayerList();
    procedure ClickLayerCheckBox(Sender: TObject);
  private
    FShowed: Boolean;
    FFolders: IKisFolders;
    procedure PrepareUI();
  private
    { IKisImagesView }
    procedure AddImage(const aFileName, aLayerName, aLayerTitle: string; const aImageRect: TRect);
    procedure AddNomenclature(const aNomenclature: string);
    function CheckJoin(Folders: IKisFolders; const aTitle: string): Boolean;
    procedure EnableCrosses();
    procedure Execute(Folders: IKisFolders; const aTitle: string; const aFileType: Integer);
  private
    procedure ShowEntireMap;
    procedure SetScale(aScale: Integer; aPoint: TPoint; Force: Boolean);
    procedure DisplayScaleValue(Value: Integer);
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
  end;

  TKisImagesViewEzGIS = class(TInterfacedObject, IKisImagesView)
  private
    FForm: TKisScanImagesViewForm;
    function GetForm(): TKisScanImagesViewForm;
  private
    procedure AddImage(const aFileName, aLayerName, aLayerTitle: string; const aImageRect: TRect);
    procedure AddNomenclature(const aNomenclature: string);
    procedure EnableCrosses();
    // инструмент для просмотра картинок на карте
    procedure Execute(Folders: IKisFolders; const aTitle: string; const aFileType: Integer);
    // инструмент для проверки стыковки планшетов
    function CheckJoin(Folders: IKisFolders; const aTitle: string): Boolean;
  public
    destructor Destroy; override; 
  end;

implementation

{$R *.dfm}

procedure TKisScanImagesViewForm.acConfirmExecute(Sender: TObject);
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

procedure TKisScanImagesViewForm.Button1Click(Sender: TObject);
begin
  ShowEntireMap();
  UpdateScale;
end;

procedure TKisScanImagesViewForm.chbCrossesClick(Sender: TObject);
begin
  EzDrawBox1.ScreenGrid.Show := not EzDrawBox1.ScreenGrid.Show;
  EzDrawBox1.RegenDrawing(); 
end;

procedure TKisScanImagesViewForm.ShowEntireMap();
begin
  EzDrawBox1.ZoomToExtension();
  EzDrawBox1.RegenDrawing(); 
end;

function TKisScanImagesViewForm.CheckJoin(Folders: IKisFolders; const aTitle: string): Boolean;
begin
  FShowed := False;
  FFolders := Folders;
  Caption := aTitle;
  pnlPictureType.Visible := False;
  PrepareUI();
  //
  Result := ShowModal = mrOK;
end;

procedure TKisScanImagesViewForm.ClickLayerCheckBox(Sender: TObject);
var
  I: Integer;
  LayerName: string;
  Layer: TEzBaseLayer;
begin
  if Sender is TCheckBox then
  begin
    for I := 0 to FLayers.Count - 1 do
    begin
      if FLayers.ValueFromIndex[I] = TCheckBox(Sender).Caption then
      begin
        LayerName := FLayers.Names[I];
        if FGisPrepared {and Gis1.Active} then
        begin
          Layer := Gis1.Layers.LayerByName(LayerName);
          if Assigned(Layer) then
          begin
            Layer.LayerInfo.Visible := TCheckBox(Sender).Checked;
            EzDrawBox1.RegenDrawing;
          end;
        end;
        Exit;
      end;
    end;
  end;
end;

constructor TKisScanImagesViewForm.Create(AOwner: TComponent);
begin
  inherited;
  //
  FImages := TImages.Create;
  FLayerControls := TList.Create;
  FLayers := TStringList.Create;
  FNomenclatures := TStringList.Create;
end;

destructor TKisScanImagesViewForm.Destroy;
begin
  FreeAndNil(FNomenclatures);
  FreeAndNil(FLayers);
  FreeAndNil(FLayerControls);
  FreeAndNil(FImages);
  inherited;
end;

procedure TKisScanImagesViewForm.EnableCrosses;
begin
  EzDrawBox1.ScreenGrid.Show := True;
end;

procedure TKisScanImagesViewForm.EndScaleUpdate;
begin
  if FScaleUpdateCount > 0 then
    Dec(FScaleUpdateCount);
end;

procedure TKisScanImagesViewForm.Execute(Folders: IKisFolders; const aTitle: string; const aFileType: Integer);
begin
  FShowed := False;
  FFolders := Folders;
  Caption := aTitle;
  cbFileType.ItemIndex := aFileType;
  ToolButton2.Visible := False;
  PrepareUI();
  //
  ShowModal;
end;

procedure TKisScanImagesViewForm.EzDrawBox1BeforeSelect(Sender: TObject; Layer: TEzBaseLayer; Recno: Integer;
  var CanSelect: Boolean);
begin
  CanSelect := False;
end;

procedure TKisScanImagesViewForm.EzDrawBox1MouseDown2D(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X,
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

procedure TKisScanImagesViewForm.EzDrawBox1MouseLeave(Sender: TObject);
var
  S, S1: String;
begin
  S := EzCmdLine1.CurrentAction.ClassName;
  S1 := EzCmdLine1.CurrentAction.ActionID;
  if (S = 'THandScrollAction') and (S1 = 'AutoScroll') then
  begin
    if EzCmdLine1.CurrentAction is TAutoHandScrollAction then
      TAutoHandScrollAction(EzCmdLine1.CurrentAction).Finish();
    EzCmdLine1.Clear;
    EzDrawBox1.RegenDrawing;
  end;
end;

procedure TKisScanImagesViewForm.EzDrawBox1MouseWheel(Sender: TObject; Shift: TShiftState; WheelDelta: Integer;
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

procedure TKisScanImagesViewForm.EzDrawBox1ZoomChange(Sender: TObject; const Scale: Double);
begin
  UpdateScale;
end;

procedure TKisScanImagesViewForm.FillLayerList;
var
  I, J: Integer;
  Img: TImage1;
  Check: TCheckBox;
begin
  for I := 0 to FImages.Count - 1 do
  begin
    Img := FImages.Items[I];
    J := FLayers.IndexOfName(Img.LayerName);
    if J < 0 then
      FLayers.Add(Img.LayerName + '=' + Img.LayerTitle);
  end;
  for I := 0 to FLayers.Count - 1 do
  begin
    Check := TCheckBox.Create(pnlInfo);
    Check.Caption := FLayers.ValueFromIndex[I];
    Check.Checked := True;
    Check.Width := 145;
    Check.OnClick := ClickLayerCheckBox;
    FLayerControls.Add(Check);
    //
    pnlInfo.InsertControl(Check);
    Check.Top := pnlInfo.ClientHeight div 2 + (pnlInfo.ClientHeight div 2 - Check.Height) div 2;
    Check.Left := 5 + I * Check.Width;
  end;
end;

procedure TKisScanImagesViewForm.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  if FGisPrepared then
  begin
    GIS1.Close;
    TFileUtils.ClearDirectory(Gis1.LayersSubdir);
  end;
  EzCmdLine1.Clear();
end;

procedure TKisScanImagesViewForm.FormMouseWheel(Sender: TObject; Shift: TShiftState; WheelDelta: Integer;
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

procedure TKisScanImagesViewForm.FormResize(Sender: TObject);
begin
  SendMessage(Handle, WM_SHOW_MAP, 0, 0);
end;

procedure TKisScanImagesViewForm.FormShow(Sender: TObject);
begin
  EzDrawBox1.SetFocus;
end;

function TKisScanImagesViewForm.GetRank(Value: Integer): string;
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

procedure TKisScanImagesViewForm.GIS1AfterPaintEntity(Sender: TObject; Layer: TEzBaseLayer; Recno: Integer;
  Entity: TEzEntity; Grapher: TEzGrapher; Canvas: TCanvas; const Clip: TEzRect; DrawMode: TEzDrawMode);
begin
  if Entity.EntityID = idBitmapRef then
  begin
    TEzBitmapRef(Entity).Image := FImages.GetBitmap(Layer.Name, Recno);
  end;
end;

function TKisScanImagesViewForm.IsScaleUpdating: Boolean;
begin
  Result := FScaleUpdateCount > 0;
end;

procedure TKisScanImagesViewForm.pnlPictureTypeResize(Sender: TObject);
begin
  Panel1.Margins.Top := pnlPictureType.Height + 1;
end;

procedure TKisScanImagesViewForm.PrepareGis;
var
  I: Integer;
  Alpha: Byte;
  Img: TImage1;
begin
  if FGisPrepared then
    Exit;
  GIS1.Close;
  GIS1.LayersSubdir := TPath.Combine(FFolders.AppTempPath, 'TKisImageListForm2');
  //
  for I := 0 to FImages.Count - 1 do
  begin
    Img := FImages.Items[I];
    if I = 0 then
      Alpha := 0
    else
      Alpha := 128;
    Img.Recno := AddPicture2(Img, Alpha);
  end;
  //
  if FNomenclatures.Count > 0 then
  begin
    AddNomenclatureLayer();
  end;
  //
  GIS1.Open;
  //
  FGisPrepared := True;
end;

procedure TKisScanImagesViewForm.PrepareUI();
begin
  Bevel1.Visible := True;
  ToolBar1.Visible := True;
  lArea.Visible := False;
  lRank.Visible := False;
  //
  pnlInfo.Visible := True;
  EzDrawBox1.Visible := True;
  PrepareGis();
  //
  FillLayerList();
  //
  EzDrawBox1.RegenDrawing;
end;

procedure TKisScanImagesViewForm.ToolButton2Click(Sender: TObject);
begin
  ModalResult := mrCancel;
end;

procedure TKisScanImagesViewForm.ToolButton3Click(Sender: TObject);
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

procedure TKisScanImagesViewForm.TrackBar1Change(Sender: TObject);
begin
  SetScale(TrackBar1.Position, Point(-1, -1), True);
end;

procedure TKisScanImagesViewForm.AddImage(const aFileName, aLayerName, aLayerTitle: string; const aImageRect: TRect);
begin
  FImages.Add(aFileName, aLayerName, aLayerTitle, aImageRect);
end;

procedure TKisScanImagesViewForm.AddNomenclature(const aNomenclature: string);
begin
  FNomenclatures.Add(aNomenclature);
end;

procedure TKisScanImagesViewForm.AddNomenclatureLayer;
var
  Layer1: TEzBaseLayer;
  Map: TEzMap500Entity;
  I: Integer;
  S: string;
begin
  S := 'NOMEN' + IntToStr(GIS1.Layers.Count);
  Layer1 := GIS1.CreateLayer(S, ltMemory);
  for I := 0 to FNomenclatures.Count - 1 do
  begin
    Map := TEzMap500Entity.CreateEntity(FNomenclatures[I]);
    Map.Forget();
    Layer1.AddEntity(Map);
  end;
  Layer1.UpdateExtension;
  FLayers.Add(S + '=' + 'Номенклатура');
end;

function TKisScanImagesViewForm.AddPicture2(Img: TImage1; const Alpha: Byte): Integer;
var
  Layer1: TEzBaseLayer;
  BmpRef: TEzBitmapRef;
  I: Integer;
  P1, P2: TEzPoint;
begin
  I := Gis1.Layers.IndexOfName(Img.LayerName);
  if I < 0 then
    Layer1 := GIS1.CreateLayer(Img.LayerName, ltMemory)
  else
    Layer1 := Gis1.Layers[I];
  P1 := Point2D(Img.Rect.Left, Img.Rect.Top);
  P2 := Point2D(Img.Rect.Right, Img.Rect.Bottom);
  BmpRef := TEzBitmapRef.CreateEntity(P1, P2, nil);
  BmpRef.Forget();
  BmpRef.AlphaChannel := Alpha;
  Result := Layer1.AddEntity(BmpRef);
  Layer1.UpdateExtension;
end;

procedure TKisScanImagesViewForm.BeginScaleUpdate;
begin
  Inc(FScaleUpdateCount);
end;

procedure TKisScanImagesViewForm.SetScale(aScale: Integer; aPoint: TPoint; Force: Boolean);
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
    if aScale = 1 then
    begin
      HcmMap := Hcm * aScale / 10;
      WcmMap := Wcm * aScale / 10;
    end
    else
    begin
      HcmMap := Hcm * Pred(aScale) / 5;
      WcmMap := Wcm * Pred(aScale) / 5;
    end;
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

procedure TKisScanImagesViewForm.UpdateScale;
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

procedure TKisScanImagesViewForm.WMShowMap(var Msg: TMessage);
begin
//  EzDrawBox1.Resize;
//  ShowEntireMap();
  if not FZoomInitialized then
  begin
    FZoomInitialized := True;
    ShowEntireMap();
  end;
end;

procedure TKisScanImagesViewForm.DisplayScaleValue(Value: Integer);
begin
  if Value < 1 then
    Value := 1
  else
    if Value > TrackBar1.Max then
      Value := TrackBar1.Max;
  TrackBar1.Position := Value;
end;

{ TImage1 }

destructor TImage1.Destroy;
begin
  FreeAndNil(FBitmap);
  inherited;
end;

procedure TImage1.SetBitmap(const Value: TBitmap);
begin
  FBitmap := Value;
end;

procedure TImage1.SetFileName(const Value: string);
begin
  FFileName := Value;
end;

procedure TImage1.SetLayerName(const Value: string);
begin
  FLayerName := Value;
end;

procedure TImage1.SetLayerTitle(const Value: string);
begin
  FLayerTitle := Value;
end;

procedure TImage1.SetRecno(const Value: Integer);
begin
  FRecno := Value;
end;

procedure TImage1.SetRect(const Value: TRect);
begin
  FRect := Value;
end;

{ TImages }

procedure TImages.Add(const aFileName, aLayerName, aLayerTitle: string; const aImageRect: TRect);
var
  Img: TImage1;
begin
  Img := TImage1.Create;
  Img.FileName := aFileName;
  Img.LayerName := aLayerName;
  Img.LayerTitle := aLayerTitle;
  Img.Rect := aImageRect;
  Img.Recno := -1;
  FList.Add(Img);
end;

function TImages.Count: Integer;
begin
  Result := FList.Count;
end;

constructor TImages.Create;
begin
  FList := TObjectList.Create;
end;

destructor TImages.Destroy;
begin
  FreeAndNil(FList);
  inherited;
end;

function TImages.GetBitmap(const LayerName: string; const Recno: Integer): TBitmap;
var
  I: Integer;
  Img, Found: TImage1;
  Bmp: TBitmap;
begin
  Result := nil;
  Found := nil;
  Img := nil;
  for I := 0 to FList.Count - 1 do
  begin
    Img := TImage1(FList[I]);
    if Img.LayerName = LayerName then
    if Img.Recno = Recno then
    begin
      Found := Img;
      Break;
    end;
  end;
  if Assigned(Found) and (Found.Bitmap = nil) then
  begin
    if FileExists(Found.FileName) then
    begin
      if theMapScansStorage.FileIsVector(Found.FileName) then
      begin
        try
          Bmp := TAutoCADUtils.ExportToBitmap(Found.FileName, SZ_MAP_PX, SZ_MAP_PX);
          Img.Bitmap := Bmp;
        except
        end;
      end
      else
      begin
        try
          Bmp := TBitmap.CreateFromFile(Found.FileName);
          Img.Bitmap := Bmp;
        except
        end;
      end;
    end;
  end;
  if Assigned(Found) then
    Result :=  Found.Bitmap;
end;

function TImages.GetItems(Index: Integer): TImage1;
begin
  Result := TImage1(FList[Index]);
end;

{ TKisImagesViewEzGIS }

procedure TKisImagesViewEzGIS.AddImage(const aFileName, aLayerName, aLayerTitle: string; const aImageRect: TRect);
begin
  GetForm.AddImage(aFileName, aLayerName, aLayerTitle, aImageRect);
end;

procedure TKisImagesViewEzGIS.AddNomenclature(const aNomenclature: string);
begin
  GetForm.AddNomenclature(aNomenclature);
end;

function TKisImagesViewEzGIS.CheckJoin(Folders: IKisFolders; const aTitle: string): Boolean;
begin
  Result := GetForm.CheckJoin(Folders, aTitle);
end;

destructor TKisImagesViewEzGIS.Destroy;
begin
  FreeAndNil(FForm);
  inherited;
end;

procedure TKisImagesViewEzGIS.EnableCrosses;
begin
  GetForm.EnableCrosses();
end;

procedure TKisImagesViewEzGIS.Execute(Folders: IKisFolders; const aTitle: string; const aFileType: Integer);
begin
  GetForm.Execute(Folders, aTitle, aFileType);
end;

function TKisImagesViewEzGIS.GetForm: TKisScanImagesViewForm;
begin
  if FForm = nil then
    FForm := TKisScanImagesViewForm.Create(Application);
  Result := FForm;
end;

end.

// TODO -cИС - Окно сравнения планшета : Динамически менять прозрачность в зависимости от количества видимых слоёв
// DONE -cИС - Окно сравнения планшета : Не отображаются картинки для режима Планшет целиком
// TODO -cИС - Окно сравнения планшета : Перетаскивание карты мышкой
// TODO -cИС - Окно сравнения планшета : Добавить инструмент - Линейка
// TODO -cИС - Окно сравнения планшета : Добавить инструмент - Толщина линии
// TODO -cИС - Окно сравнения планшета : При изменении типа файла создаётся пустой файл, который потом не удаляется
// TODO -cИС - Окно сравнения планшета : Для зоны изменения надо тоже показывать площадь и процент области

