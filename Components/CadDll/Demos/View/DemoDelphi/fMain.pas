unit fMain;

interface

//{$DEFINE MEMCHK}

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs, Math,
  ExtCtrls, ComCtrls, StdCtrls, csErrorCodes, Buttons, fLayers, fShowPoint,
  sgConsts, sgcadimage, Printers, Menus, ImgList, XMLIntf, XMLDoc, ToolWin, Tabs,
  sgInitSHX, sgDrawRect
  {$IFDEF MEMCHK}
  ,MemCheck
  {$ENDIF};

type
  ECADDLLException = class(Exception);

  TCADDrawRect = class(TDrawRect)
  private
    FUpdateCount: Integer;
    function GetDrawRect: TFRect;
    procedure SetDrawRect(const Value: TFRect);
  protected
    procedure DoChanged; override;
    procedure DoScale; override;
    procedure DoMove; override;
  public
    procedure BeginUpdate;
    procedure EndUpdate;
    property Rect: TFRect read GetDrawRect write SetDrawRect;
  end;

  TfmMain = class(TForm)
    cbNearest: TCheckBox;
    cbProcessMessages: TCheckBox;
    clbBar: TControlBar;
    ColorDialog: TColorDialog;
    edtFile: TEdit;
    imLarge: TImageList;
    mmiAbout: TMenuItem;
    mmiBackgroundColor: TMenuItem;
    mmiClose: TMenuItem;
    mmiDefaultColor: TMenuItem;
    mmiDoubleBuffered: TMenuItem;
    mmiExit: TMenuItem;
    mmiFile: TMenuItem;
    mmiFit: TMenuItem;
    mmiImage: TMenuItem;
    mmiLayers: TMenuItem;
    mmiOpen: TMenuItem;
    mmiPrint: TMenuItem;
    mmiProcessMessages: TMenuItem;
    mmiSaveAs: TMenuItem;
    mmiSeparator1: TMenuItem;
    mmiSeparator2: TMenuItem;
    mmiShowHalf: TMenuItem;
    mmiShowPoint: TMenuItem;
    mmMenu: TMainMenu;
    mmiVew: TMenuItem;
    N1: TMenuItem;
    OpenDialog: TOpenDialog;
    pmLayouts: TPopupMenu;
    pnlCoords: TPanel;
    pnlNearestEnt: TPanel;
    pnlStatus: TPanel;
    prbProgress: TProgressBar;
    PrintDialog: TPrintDialog;
    SaveDialog: TSaveDialog;
    tbColored: TToolButton;
    tbFit: TToolButton;
    tbHalf: TToolButton;
    tbLayers: TToolButton;
    tbOpen: TToolButton;
    tbPrint: TToolButton;
    tbrBar: TToolBar;
    tbSave: TToolButton;
    tbsLayouts: TTabSet;
    tbStopLoading: TToolButton;
    ToolBar1: TToolBar;
    ToolButton1: TToolButton;
    ToolButton2: TToolButton;
    ToolButton4: TToolButton;
    cbDrawMode: TComboBox;
    N2: TMenuItem;
    mmiAutoRegen: TMenuItem;
    mmiHighQualityRegen: TMenuItem;
    Export1: TMenuItem;
    LineWidth1: TMenuItem;
    procedure cbNearestClick(Sender: TObject);
    procedure cbProcessMessagesClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure FormMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure FormMouseMove(Sender: TObject; Shift: TShiftState; X, Y: Integer);
    procedure FormMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure FormMouseWheelDown(Sender: TObject; Shift: TShiftState;
      MousePos: TPoint; var Handled: Boolean);
    procedure FormMouseWheelUp(Sender: TObject; Shift: TShiftState;
      MousePos: TPoint; var Handled: Boolean);
    procedure FormPaint(Sender: TObject);
    procedure FormResize(Sender: TObject);
    procedure mmiAboutClick(Sender: TObject);
    procedure mmiBackgroundColorClick(Sender: TObject);
    procedure mmiCloseClick(Sender: TObject);
    procedure mmiDefaultColorClick(Sender: TObject);
    procedure mmiDoubleBufferedClick(Sender: TObject);
    procedure mmiExitClick(Sender: TObject);
    procedure mmiProcessMessagesClick(Sender: TObject);
    procedure mmiSaveAsClick(Sender: TObject);
    procedure mmiShowPointClick(Sender: TObject);
    procedure tbColoredClick(Sender: TObject);
    procedure tbFitClick(Sender: TObject);
    procedure tbHalfClick(Sender: TObject);
    procedure tbLayersClick(Sender: TObject);
    procedure tbOpenClick(Sender: TObject);
    procedure tbPrintClick(Sender: TObject);
    procedure tbsLayoutsChange(Sender: TObject; NewTab: Integer; var AllowChange: Boolean);
    procedure tbStopLoadingClick(Sender: TObject);
    procedure cbDrawModeChange(Sender: TObject);
    procedure mmiUpdateRegenMode(Sender: TObject);
    procedure Export1Click(Sender: TObject);
    procedure LineWidth1Click(Sender: TObject);
  private
    FAbsHeight: Double;
    FAbsWidth: Double;
    FBackgroundColor: TColor;
    FBlackWhite: Integer;
    FCADFile: THandle;
    FCADPoint: TFPoint;
    FColored: Boolean;
    FDefaultColor: TColor;
    FDown: Boolean;
    FDownPos: TPoint;
    FHWRatio: Double;
    FIsDrawingBox: Boolean;
    FLoading: Boolean;
    FNearestRectVisible: Boolean;
    FOldNearestRect: TRect;
    FProcessMessages: Boolean;
    FRectExtentsCAD: TFRect;
    FScaleRect: TFPoint;
    FShowFndPntMarker: Boolean;
    FShowNearest: Boolean;
    FDrawRect: TCADDrawRect;
    procedure CloseImage;
    procedure DoFit;
    function GetPoint(const ACADPoint: TFPoint): TPoint;
    function GetViewportRect: TRect;
    procedure IdleEvent(Sender: TObject; var Done: Boolean);
    function Is3D: Boolean;
    procedure LayoutMenuItemClick(Sender: TObject);
    procedure ResetImageParams;
    procedure ZoomingCADImage(const AScale: Double; const APosition: TPoint;
       var Handled: Boolean);
    procedure UpdateImageBounds;
    procedure UpdateImagesColor(Index: Integer; AColor: TColor);
    procedure DrawRectChanged(Sender: TObject);
    function GetFitEnabled: Boolean;
    procedure SetFitEnabled(const Value: Boolean);
    procedure DrawMarker(const APoint: TFPoint);
    property FitEnabled: Boolean read GetFitEnabled write SetFitEnabled;
  protected
    { use with CreateCADEx }
    //procedure WindowProc(var Message: TMessage); message CAD_PROGRESS;
    function OpenFile(const AFileName: string): Boolean;
    procedure CreateParams(var Params: TCreateParams); override;
  end;

var
  fmMain: TfmMain;
  ErrorCode: DWORD;
  bStopLoading: Boolean = False;

implementation

uses
  sgAboutDlg;

{$R *.DFM}

const
  MarkerSize = 10;

type
  TWinControlAccess = class(TWinControl);

function _str(P: PWideChar): string;
begin
  Result := string(WideString(P));
end;

procedure Error;
var Buf: array[Byte] of WideChar;
begin
  GetLastErrorCAD(Buf, 256);
  raise ECADDLLException.Create(_str(@Buf[0]));
end;

function OnProgress(PercentDone: Byte): Integer; stdcall;
begin
  Result := 0;
  if bStopLoading then
  begin
    StopLoading;
    fmMain.prbProgress.Visible := False;
    Result := 1;
  end
  else
  begin
    fmMain.edtFile.Text := 'Load file... ' + IntToStr(PercentDone) + '%';
    fmMain.edtFile.Repaint;
    fmMain.prbProgress.Position := PercentDone;
  end;
end;

function ConvPoint(const APoint: TPoint): TFPoint;
begin
  Result := MakeFPoint(APoint.X, APoint.Y);
end;

procedure DrawNearestRect(ACanvas: TCanvas; NewRect: TRect; PredRect: PRect; var AVisible: Boolean);
var
  vPenStg: TRecall;
  vBrushStg: TRecall;
begin
  vPenStg := TRecall.Create(TPen.Create, ACanvas.Pen);
  try
    ACanvas.Pen.Color := clYellow;
    ACanvas.Pen.Mode := pmXor;
    vBrushStg := TRecall.Create(TBrush.Create, ACanvas.Brush);
    try
      ACanvas.Brush.Color := not ACanvas.Pen.Color and $00FFFFFF;
      ACanvas.Brush.Style := bsSolid;
      if AVisible and Assigned(PredRect) then
        ACanvas.Rectangle(PredRect^.Left, PredRect^.Top, PredRect^.Right, PredRect^.Bottom);
      ACanvas.Rectangle(NewRect.Left, NewRect.Top, NewRect.Right, NewRect.Bottom);
      AVisible := True;
      if Assigned(PredRect) then
        PredRect^ := NewRect;
    finally
      vBrushStg.Free;
    end;
  finally
    vPenStg.Free;
  end;
end;

function GenerateXMLParams(const AFileName, AFileExt: string;
  const AAbsWidth, AAbsHeight: Single;
  const ADefaultColor, ABackground: TColor;
  const ATTFMode: Byte = 0): string;
var
  vGraphicsParams, vCADParametrs, vDrawRect: IXMLNode;
  vXMLExportParams: IXMLDocument;
  vStream: TMemoryStream;
  vBytesSize: Integer;
{$IFDEF UNICODE}
  vBytes: TBytes;
{$ENDIF}
begin
  Result := '';
  vXMLExportParams := TXMLDocument.Create(nil);
  try
    vXMLExportParams.Active := false;
    vXMLExportParams.XML.Text := '<ExportParams version="1.0"/>';
    vXMLExportParams.Active := True;
    vXMLExportParams.DocumentElement.AddChild('Filename').Text := AFileName;
    vXMLExportParams.DocumentElement.AddChild('Ext').Text := AFileExt;

    vGraphicsParams := vXMLExportParams.DocumentElement.AddChild('GraphicParametrs');
    vGraphicsParams.AddChild('PixelFormat').Text := IntToStr(Integer(pf24bit));
    vGraphicsParams.AddChild('Width').Text := FloatToStr(AAbsWidth);
    vGraphicsParams.AddChild('Height').Text := FloatToStr(AAbsHeight);
    vGraphicsParams.AddChild('DrawMode').Text := '0';
    vDrawRect := vGraphicsParams.AddChild('DrawRect');
    vDrawRect.Attributes['Left'] := '0';
    vDrawRect.Attributes['Top'] := '0';
    vDrawRect.Attributes['Right'] := IntToStr(Round(AAbsWidth));
    vDrawRect.Attributes['Bottom'] := IntToStr(Round(AAbsHeight));

    vCADParametrs := vXMLExportParams.DocumentElement.AddChild('CADParametrs');
    vCADParametrs.AddChild('XScale').Text := '1';
    vCADParametrs.AddChild('BackgroundColor').Text := IntToStr(ABackground);
    vCADParametrs.AddChild('DefaultColor').Text := IntToStr(ADefaultColor);
    vCADParametrs.AddChild('TTFMode').Text := IntToStr(ATTFMode);

    vStream := TMemoryStream.Create;
    try
      vXMLExportParams.Encoding := 'utf-8';
      vXMLExportParams.Encoding := 'windows-1251';
      vXMLExportParams.SaveToStream(vStream);
      vStream.Position := 0;
      vBytesSize := vStream.Size;
{$IFDEF UNICODE}
      try
        SetLength(vBytes, vBytesSize);
        vStream.Read(vBytes[0], vBytesSize);
        Result := TEncoding.UTF8.GetString(vBytes);
      finally
        SetLength(vBytes, 0);
      end;
{$ELSE}
      SetLength(Result, vBytesSize);
      vStream.Read(Result[1], vBytesSize);
{$ENDIF}
    finally
      vStream.Free;
    end;
  finally
    vXMLExportParams := nil;
  end;
end;

{ TfmMain }

procedure TfmMain.FormPaint(Sender: TObject);
var
  vCadDraw: TCADDraw;
  vViewportRect: TRect;
  vFRect: TFRect;
begin
  Canvas.Brush.Style := bsSolid;
  Canvas.Brush.Color := FBackgroundColor;
  vViewportRect := GetViewportRect;
  Canvas.FillRect(vViewportRect);
  if (FCADFile <> 0) and (FAbsHeight <> -1) then
  begin
    vFRect := FDrawRect.Rect;
    vCadDraw.R := FDrawRect.RoundRect;
    if not IsEqual(vFRect.Left, vFRect.Right) and not IsEqual(vFRect.Top, vFRect.Bottom) then
    begin
      FScaleRect.X := FAbsWidth / (vFRect.Right - vFRect.Left);
      FScaleRect.Y := FAbsHeight / (vFRect.Bottom - vFRect.Top);
      vCadDraw.Size := SizeOf(TCADDraw);
      vCadDraw.DC := Canvas.Handle;
      vCadDraw.DrawMode := cbDrawMode.ItemIndex;
      DrawCADEx(FCADFile, vCadDraw);
      if FShowNearest then
        DrawNearestRect(Canvas, FOldNearestRect, nil, FNearestRectVisible);
      if FShowFndPntMarker then
        DrawMarker(FCADPoint);
    end;
  end;
end;

procedure TfmMain.DrawMarker(const APoint: TFPoint);
var
  R: TRect;
begin
  R.TopLeft := GetPoint(APoint);
  R.BottomRight := R.TopLeft;
  InflateRect(R, 5, 5);
  Canvas.Rectangle(R.Left, R.Top,
    R.Right, R.Bottom);
end;

procedure TfmMain.FormResize(Sender: TObject);
begin
  if not (csDestroying in ComponentState) then
    edtFile.Width := pnlStatus.Width div 2;
  FitEnabled := True;
end;

function TfmMain.GetViewportRect: TRect;
begin
  Result := ClientRect;
  Result.Top := Result.Top + clbBar.BoundsRect.Bottom;
  Result.Bottom := tbsLayouts.BoundsRect.Top;
end;

procedure TfmMain.ResetImageParams;
begin
  UpdateImageBounds;
  DoFit;
end;

procedure TfmMain.SetFitEnabled(const Value: Boolean);
begin
  if not (csDestroying in tbFit.ComponentState) then
    tbFit.Enabled := Value;
  if not (csDestroying in mmiFit.ComponentState) then
    mmiFit.Enabled := Value;
end;

procedure TfmMain.ZoomingCADImage(const AScale: Double; const APosition: TPoint;
  var Handled: Boolean);
begin
  if FCADFile <> 0 then
    Handled := FDrawRect.Scale(AScale, ScreenToClient(APosition));
end;

procedure TfmMain.tbsLayoutsChange(Sender: TObject; NewTab: Integer;
  var AllowChange: Boolean);
begin
  FShowFndPntMarker := False;
  if NewTab <> -1 then
  begin
    CurrentLayoutCAD(FCADFile, NewTab, True);
    ResetImageParams;
    tbsLayouts.Hint := tbsLayouts.Tabs[NewTab];
    pmLayouts.Items[NewTab].Checked := True;
  end;
end;

procedure TfmMain.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  CloseImage;
end;

procedure TfmMain.FormMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  if (ssDouble in Shift) and (Button = mbMiddle) then
    DoFit
  else
    if Button in [mbRight, mbMiddle] then
    begin
      FDown := True;
      FDownPos := Point(X, Y);
      Cursor := crHandPoint;
    end
    else
      if Button = mbLeft then
        FormMouseMove(nil, Shift, X, Y);
end;

procedure TfmMain.FormMouseMove(Sender: TObject; Shift: TShiftState; X,
  Y: Integer);
var
  newmousePt: TFPoint;
  vRect, R: TRect;
  sX, sY: Single;
  P: TPoint;
  Buf: array[Byte] of WideChar;
begin
  if FDown then
  begin
    if Shift * [ssRight, ssMiddle] = [] then
    begin
      FDown := False;
      FDownPos := Point(X, Y);
    end
    else
    begin
      FDrawRect.Offset(X - FDownPos.X, Y - FDownPos.Y);
      FDownPos := Point(X, Y);
      Invalidate;
    end;
  end
  else
  begin
    if FCADFile <> 0 then
    begin
      if Is3D then
        pnlCoords.Caption := '3D drawing'
      else
      begin
        vRect := FDrawRect.RoundRect;
        if FShowNearest then
        begin
          P := Point(X - vRect.Left, Y - vRect.Top);
          OffsetRect(vRect, -vRect.Left, -vRect.Top);
          GetNearestEntity(FCADFile, @Buf[0], 256, vRect, P);
          R.TopLeft := P;
          R.BottomRight := P;
          InflateRect(R, MarkerSize div 2, MarkerSize div 2);
          DrawNearestRect(Canvas, R, @FOldNearestRect, FNearestRectVisible);
          pnlNearestEnt.Caption := _str(@Buf[0]);
        end;
        sX := (X - FDrawRect.Left) * FScaleRect.X / FAbsWidth;
        sY := 1 - (Y - FDrawRect.Top) * FScaleRect.Y / FAbsHeight;
        GetCADCoords(FCADFile, sX, sY, newmousePt);
        pnlCoords.Caption := Format('(%6.6f, %6.6f)', [newmousePt.X, newmousePt.Y]);
      end;
    end;
  end;
end;

procedure TfmMain.FormMouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  if FDown and (Button in [mbRight, mbMiddle]) then
  begin
    FDown := False;
    FDownPos := Point(X, Y);
    Cursor := crDefault;
  end;
end;

procedure TfmMain.FormCreate(Sender: TObject);
var
  vBmp: TBitmap;
  I: Integer;
begin
  FDrawRect := TCADDrawRect.Create;
  FDrawRect.OnChanged := DrawRectChanged;
  FDrawRect.OnScaled := DrawRectChanged;
  FDrawRect.OnMoved := DrawRectChanged;
  FBackgroundColor := clWhite;
  FDefaultColor := clBlack;
  vBmp := TBitmap.Create;
  vBmp.Width := imLarge.Width;
  vBmp.Height := imLarge.Height;
  mmiDefaultColor.ImageIndex := imLarge.Add(vBmp, nil);
  mmiBackgroundColor.ImageIndex := imLarge.Add(vBmp, nil);
  vBmp.Free;
  UpdateImagesColor(mmiDefaultColor.ImageIndex, FDefaultColor);
  UpdateImagesColor(mmiBackgroundColor.ImageIndex, FBackgroundColor);
  fmLayers := TfmLayers.Create(Self);
  pnlCoords.Caption := Format('(%6.6f, %6.6f)', [0.0, 0.0]);
  FIsDrawingBox := False;
  FColored := True;
  FLoading := False;
  FProcessMessages := True;
  tbSave.Hint := mmiSaveAs.Caption;
  FShowFndPntMarker := false;
  ErrorCode := 0;
{$IFNDEF CS_STATIC_DLL}
  if CADImageInst = 0 then
    MessageBox(Handle, PChar('Cannot load ' + cnstCADImageLibName), nil, MB_ICONERROR)
  else
{$ENDIF}
  SetProgressProc(OnProgress);
  //DoubleBuffered := True;
  if ParamCount > 0 then
    OpenFile(ParamStr(1));
  Application.OnIdle := IdleEvent;
  InitSHX(CADSetSHXOptions);
  if Assigned(CADSetAutoRegenMode) then
  begin
    mmiAutoRegen.Enabled := True;
    mmiHighQualityRegen.Enabled := True;
  end
  else
  begin
    mmiAutoRegen.Enabled := False;
    mmiHighQualityRegen.Enabled := False;
  end;
  for I := 0 to ControlCount - 1 do
    Controls[I].ControlStyle := Controls[I].ControlStyle - [csParentBackground];
end;

procedure TfmMain.FormDestroy(Sender: TObject);
begin
  CloseImage;
  Application.OnIdle := nil;
end;

procedure TfmMain.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  case Key of
    VK_NEXT: tbsLayouts.FirstIndex := tbsLayouts.FirstIndex + 10;
    VK_PRIOR:
      if tbsLayouts.FirstIndex > 10 then
        tbsLayouts.FirstIndex := tbsLayouts.FirstIndex - 10
      else
        tbsLayouts.FirstIndex := 0;
    VK_HOME: tbsLayouts.FirstIndex := 0;
    VK_END: tbsLayouts.FirstIndex := tbsLayouts.Tabs.Count - 1;
  end;
end;

function TfmMain.OpenFile(const AFileName: string): Boolean;
var
  Cnt,I: Integer;
  Layer: THandle;
  Layout: THandle;
  vName: array[Byte] of WideChar;
  //ErrorCode: DWORD;
  //Buf: PChar;
  //C: Cardinal;
  vData: TcadData;
  S: string;
  Item: TMenuItem;
  vRegenMode: Integer;
begin
  Result := False;
  try
  if CADImageInst = 0 then Exit;
  CloseImage;
  bStopLoading := False;
  FShowFndPntMarker := False;
  FLoading := True;
  try
    prbProgress.Position := 0;
    prbProgress.Visible := True;
    tbStopLoading.Enabled := FLoading;
    Application.ProcessMessages;
    FCADFile := CreateCAD(Handle, PWideChar(WideString(AFileName)));
  finally
    FLoading := False;
  end;
  {
  FCADFile := CreateCADEx(
    Handle,
    PChar(OpenDialog.FileName),
    PChar(IntToStr(CAD_PROGRESS)));
  }

  //ErrorCode := GetLastErrorCAD(Buf,256);
  {if ErrorCode = ERROR_CAD_UNSUPFORMAT_FILE then
  begin
    sbStatusBar.Panels[0].Text := 'No file loaded';
    StartedTimer := False;
    Error;
  end;}
  if FCADFile = 0 then
    Error
  else
    Result := True;
  SetCADBorderType(FCADFile, 0);
  SetCADBorderSize(FCADFile, 0);
  SetDefaultColor(FCADFile, FDefaultColor);
  SetBlackWhite(FCADFile, FBlackWhite);

//CADSetNumberOfParts(FCADFile, 48, 48);// if need change quality

  edtFile.Font.Color := clWindowText;
  edtFile.Text := AFileName;

  fmLayers.clbLayers.Items.BeginUpdate;
  try
    fmLayers.clbLayers.Clear;
    Cnt := CADLayerCount(FCADFile);
    for I := 0 to Cnt-1 do
    begin
      Layer := CADLayer(FCADFile, I, @vData);
      //C := Data.Color;
      //if Data.Flags and 1 <> 0 then C := C or $80000000;
      fmLayers.clbLayers.Items.AddObject(_str(vData.Text), TObject(Layer));
      fmLayers.clbLayers.Checked[I] := vData.Flags and 1 <> 0;
    end;
  finally
    fmLayers.clbLayers.Items.EndUpdate;
  end;
  tbsLayouts.Tabs.BeginUpdate;
  try
    pmLayouts.Items.Clear;
    tbsLayouts.Tabs.Clear;
    Cnt := CADLayoutsCount(FCADFile);
    for I := 0 to Cnt-1 do
    begin
      CADLayoutName(FCADFile, I, @vName[0], 256);
      Layout := CADLayout(FCADFile, I);
      S := _str(@vName[0]);
      tbsLayouts.Tabs.AddObject(S, TObject(Layout));
      Item := pmLayouts.CreateMenuItem;
      Item.Caption := S;
      Item.RadioItem := True;
      Item.GroupIndex := 0;
      Item.AutoCheck := True;
      Item.OnClick := LayoutMenuItemClick;
      pmLayouts.Items.Add(Item);
    end;
    tbsLayouts.TabIndex := DefaultLayoutIndex(FCADFile);
    pmLayouts.Items[tbsLayouts.TabIndex].Checked := True;
    tbsLayouts.Visible := True;
    vRegenMode := CADGetAutoRegenMode(FCADFile);
    mmiAutoRegen.Checked := Boolean(vRegenMode and $1);
    mmiHighQualityRegen.Checked := Boolean((vRegenMode and $2) shr 1);
  finally
    tbsLayouts.Tabs.EndUpdate;
    SetFocus;
  end;
  except
    on E: ECADDLLException do
    begin
      edtFile.Font.Color := clRed;
      edtFile.Text := E.Message;
      MessageBox(Handle, PChar(E.Message), PChar(Caption), MB_ICONERROR);
    end;
  end;
end;

function TfmMain.GetFitEnabled: Boolean;
begin
  Result := tbFit.Enabled;
end;

function TfmMain.GetPoint(const ACADPoint: TFPoint): TPoint;
var
  vDrawRect: TFRect;
begin
  vDrawRect := FDrawRect.Rect;
  Result.X := Round(vDrawRect.Left + (vDrawRect.Right - vDrawRect.Left) * (ACADPoint.X - FRectExtentsCAD.Left) / FAbsWidth);
  Result.Y := Round(vDrawRect.Top - (vDrawRect.Bottom - vDrawRect.Top) * (ACADPoint.Y - FRectExtentsCAD.Top) / FAbsHeight);
end;

procedure TfmMain.IdleEvent(Sender: TObject; var Done: Boolean);
var
  vCAD: Boolean;
begin
  vCAD := FCADFile <> 0;
  tbColored.Enabled := vCAD;
  tbHalf.Enabled := vCAD;
  tbLayers.Enabled := vCAD;
  tbOpen.Enabled := True;
  tbPrint.Enabled := vCAD;
  tbsLayouts.Enabled := vCAD;
  tbStopLoading.Enabled := FLoading;
  tbSave.Enabled := vCAD;
  mmiAbout.Enabled := True;
  mmiClose.Enabled := vCAD;
  mmiBackgroundColor.Enabled := True;
  mmiDefaultColor.Enabled := True;
  mmiExit.Enabled := True;
  mmiFile.Enabled := True;
  mmiImage.Enabled := True;
  mmiLayers.Enabled := vCAD;
  mmiOpen.Enabled := True;
  mmiPrint.Enabled := vCAD;
  mmiProcessMessages.Enabled := True;
  mmiSaveAs.Enabled := vCAD;
  mmiShowHalf.Enabled := vCAD;
  mmiShowPoint.Enabled := vCAD;
  mmiProcessMessages.Checked := FProcessMessages;
  cbProcessMessages.Checked := FProcessMessages;
  cbNearest.Checked := FShowNearest;
  tbColored.Down := FBlackWhite = 0;
  if FBlackWhite = 0 then
    tbColored.ImageIndex := 22
  else
    tbColored.ImageIndex := 23;
  prbProgress.Visible := FLoading;
  mmiDoubleBuffered.Checked := DoubleBuffered;
end;

function TfmMain.Is3D: Boolean;
var
  vIs3D: Integer;
begin
  Result := False;
  if FCADFile = 0 then Exit;
  GetIs3dCAD(FCADFile, vIs3D);
  Result := vIs3D = 1;
end;

procedure TfmMain.LayoutMenuItemClick(Sender: TObject);
begin
  tbsLayouts.TabIndex := TMenuItem(Sender).MenuIndex;
end;

procedure TfmMain.LineWidth1Click(Sender: TObject);
var
  I: Integer;
begin
  I := Integer(LineWidth1.Checked);
  if SetShowLineWeightCAD(FCADFile, I) = 0 then
    Error;
end;

procedure TfmMain.cbDrawModeChange(Sender: TObject);
begin
  Invalidate;
end;

procedure TfmMain.cbNearestClick(Sender: TObject);
begin
  FShowNearest := not FShowNearest;
  Invalidate;
  pnlNearestEnt.Caption := '';
end;

procedure TfmMain.cbProcessMessagesClick(Sender: TObject);
begin
  mmiProcessMessagesClick(nil);
end;

procedure TfmMain.CloseImage;
var
  vCADFile: THandle;
begin
  if FCADFile <> 0 then
  begin
    vCADFile := FCADFile;
    FCADFile := 0;
    CloseCAD(vCADFile);
    FOldNearestRect := Rect(-MarkerSize, -MarkerSize, 0, 0);
    Invalidate;
  end;
end;

procedure TfmMain.CreateParams(var Params: TCreateParams);
begin
  inherited CreateParams(Params);
  Params.Style := Params.Style or (WS_CLIPSIBLINGS or WS_CLIPCHILDREN);
end;

procedure TfmMain.DoFit;
begin
  FDrawRect.FitTo(GetViewportRect, FHWRatio);
  FitEnabled := False;
end;

procedure TfmMain.DrawRectChanged(Sender: TObject);
var
  R: TRect;
begin
  //Invalidate;
  R := GetViewportRect;
  InvalidateRect(WindowHandle, @R, not (csOpaque in ControlStyle));
  FitEnabled := True;
end;

procedure TfmMain.Export1Click(Sender: TObject);
const
  cnstBufSize = 1024;
var
  vFileName: string;
  vMsg: array[1..cnstBufSize] of WideChar;
  S: string;
  Ws: WideString;
  Bmp: TBitmap;
  Sz: Integer;
begin
  if (FCADFile = 0) or not SaveDialog.Execute then Exit;
  vFileName := SaveDialog.FileName;
  vFileName := ChangeFileExt(vFileName, '.bmp');
  Bmp := TBitmap.Create;
  try
    Bmp.PixelFormat := pf24bit;
    Sz := 590;
    Sz := 5906;
    Bmp.SetSize(Sz, Sz);
    if DrawCAD(FCADFile, Bmp.Canvas.Handle, Rect(0, 0, Sz - 1, Sz - 1)) = 0 then
    begin
      GetLastErrorCAD(@vMsg[1], cnstBufSize);
      Ws := PWideChar(@vMsg[1]);
      S := string(Ws);
      Application.MessageBox(PChar(S), '', MB_OK);
    end;
    Bmp.SaveToFile(vFileName);
  finally
    Bmp.Free;
  end;

end;

procedure TfmMain.mmiExitClick(Sender: TObject);
begin
  Close;
end;

procedure TfmMain.mmiProcessMessagesClick(Sender: TObject);
begin
  if FCADFile = 0 then Exit;
  FProcessMessages := not FProcessMessages;
  SetProcessMessagesCAD(FCADFile, Ord(FProcessMessages));
end;

procedure TfmMain.mmiBackgroundColorClick(Sender: TObject);
begin
  ColorDialog.Color := FBackgroundColor;
  if ColorDialog.Execute then
  begin
    FBackgroundColor := ColorDialog.Color;
    if (FBackgroundColor = clBlack) and (FDefaultColor = clBlack) then
    begin
      FDefaultColor := clWhite;
      UpdateImagesColor(mmiDefaultColor.ImageIndex, FDefaultColor);
    end
    else
      if (FBackgroundColor = clWhite) and (FDefaultColor = clWhite) then
      begin
        FDefaultColor := clBlack;
        UpdateImagesColor(mmiDefaultColor.ImageIndex, FDefaultColor);
      end;
    if FCADFile <> 0 then
      SetDefaultColor(FCADFile, FDefaultColor);
    UpdateImagesColor(TMenuItem(Sender).ImageIndex, FBackgroundColor);
    Invalidate;
  end;
end;

procedure TfmMain.mmiDefaultColorClick(Sender: TObject);
begin
  ColorDialog.Color := FDefaultColor;
  if ColorDialog.Execute then
  begin
    FDefaultColor := ColorDialog.Color;
    if FCADFile <> 0 then
      SetDefaultColor(FCADFile, FDefaultColor);
    UpdateImagesColor(TMenuItem(Sender).ImageIndex, FDefaultColor);
    Invalidate;
  end;
end;

procedure TfmMain.mmiDoubleBufferedClick(Sender: TObject);
begin
  DoubleBuffered := not DoubleBuffered;
  Invalidate;
end;

procedure TfmMain.mmiCloseClick(Sender: TObject);
begin
  CloseImage;
  tbsLayouts.Tabs.Clear;
  tbsLayouts.PopupMenu.Items.Clear;
  fLayers.fmLayers.clbLayers.Clear;
  edtFile.Text := 'Demo';
  pnlCoords.Caption := '';
  pnlNearestEnt.Caption := '';
end;

procedure TfmMain.mmiAboutClick(Sender: TObject);
begin
  ShowAboutDlg('About CAD DLL');
end;

procedure TfmMain.mmiUpdateRegenMode(Sender: TObject);
var
  vMenuItem: TMenuItem absolute Sender;
  vMode: Integer;
begin
  if not(Sender is TMenuItem) then
    Exit;
  vMenuItem.Checked := not vMenuItem.Checked;
  vMode := Integer(mmiAutoRegen.Checked) or (Integer(mmiHighQualityRegen.Checked) shl 1);
  CADSetAutoRegenMode(FCADFile, vMode);
  Invalidate;
end;

procedure TfmMain.FormMouseWheelDown(Sender: TObject; Shift: TShiftState;
  MousePos: TPoint; var Handled: Boolean);
begin
  ZoomingCADImage(4/5, MousePos, Handled);
end;

procedure TfmMain.FormMouseWheelUp(Sender: TObject; Shift: TShiftState;
  MousePos: TPoint; var Handled: Boolean);
begin
  ZoomingCADImage(5/4, MousePos, Handled);
end;

procedure TfmMain.tbOpenClick(Sender: TObject);
begin
  if OpenDialog.Execute then
    OpenFile(OpenDialog.FileName);
end;

procedure TfmMain.tbPrintClick(Sender: TObject);
var
  R: TFRect;
begin
  if (FCADFile <> 0) and (FAbsHeight <> -1) then
  begin
    if FAbsHeight > FAbsWidth then
      Printer.Orientation := poPortrait
    else
      Printer.Orientation := poLandscape;
    if PrintDialog.Execute then
    begin
      FDrawRect.BeginUpdate;
      try
        R := FDrawRect.Rect;
        try
          FDrawRect.FitTo(Rect(0, 0, Printer.PageWidth, Printer.PageHeight), FHWRatio);
          Printer.Title := cnstCADImageLibName + ' - [Demo Delphi]';
          Printer.BeginDoc;
          try
            DrawCAD(FCADFile, Printer.Canvas.Handle, FDrawRect.RoundRect);
          finally
            Printer.EndDoc;
          end;
        finally
          FDrawRect.Rect := R;
        end;
      finally
        FDrawRect.EndUpdate;
      end;
    end;
  end;
end;

procedure TfmMain.tbFitClick(Sender: TObject);
begin
  DoFit;
end;

procedure TfmMain.tbLayersClick(Sender: TObject);
begin
  fmLayers.ShowModal;
end;

procedure TfmMain.tbHalfClick(Sender: TObject);
var
  NewDrawingBox: TFRect;
begin
  if FCADFile <> 0 then
  begin
    if not FIsDrawingBox then
    begin
      NewDrawingBox := FRectExtentsCAD;
      NewDrawingBox.Left :=  FRectExtentsCAD.Left + FAbsWidth / 2;
      SetDrawingBoxCAD(FCADFile, NewDrawingBox);
    end
    else
      ResetDrawingBoxCAD(FCADFile);
    FIsDrawingBox := not FIsDrawingBox;
    UpdateImageBounds;
    DoFit;
  end;
end;

procedure TfmMain.tbColoredClick(Sender: TObject);
begin
  if FCADFile = 0 then Exit;
  FBlackWhite := FBlackWhite xor 1;
  SetBlackWhite(FCADFile, FBlackWhite);
  Invalidate;
end;

procedure TfmMain.tbStopLoadingClick(Sender: TObject);
begin
  bStopLoading := True;
end;

procedure TfmMain.UpdateImageBounds;
begin
  if FCADFile <> 0 then
    GetExtentsCAD(FCADFile, FRectExtentsCAD)
  else
    FRectExtentsCAD := MakeFRect(0, 1, 0, 1, 0, 0);
  FAbsHeight := FRectExtentsCAD.Top - FRectExtentsCAD.Bottom;
  FAbsWidth  := FRectExtentsCAD.Right - FRectExtentsCAD.Left;
  if FAbsWidth <> 0 then
    FHWRatio := FAbsHeight / FAbsWidth
  else
    FHWRatio := 1.0;
end;

procedure TfmMain.UpdateImagesColor(Index: Integer; AColor: TColor);
var
  vBitmap: TBitmap;
begin
  vBitmap := TBitmap.Create;
  try
    vBitmap.Width := imLarge.Width;
    vBitmap.Height := imLarge.Height;
    vBitmap.Canvas.Brush.Color := AColor;
    vBitmap.Canvas.Pen.Color := not AColor and $00FFFFFF;
    vBitmap.Canvas.Rectangle(vBitmap.Canvas.ClipRect);
    imLarge.Replace(Index, vBitmap, nil);
  finally
    vBitmap.Free;
  end;
end;

{ use with CreateCADEx 
procedure TfmMain.WindowProc(var Message: TMessage);
var
  vCADProgress: PCADProgress;
begin
  inherited;
  if Message.Msg = CAD_PROGRESS then
  begin
    vCADProgress := PCADProgress(Message.LParam);
    prbProgress.Position := vCADProgress.PercentDone;
    case vCADProgress.Stage of
    0:pnlFile.Caption := 'The operation is about to begin';
    1:
      begin
        pnlFile.Caption := string(vCADProgress.Msg);
        pnlFile.Caption := pnlFile.Caption + ' ' + IntToStr(vCADProgress.PercentDone) + '% done';
      end;
    2:pnlFile.Caption := 'The operation has just completed';
    end;

  end;
end;
}

procedure TfmMain.mmiSaveAsClick(Sender: TObject);
const
  cnstBufSize = 1024;
var
  vFileName, vExt, vExportParams: string;
  vFileExts: TStringList;
  vKoef: Double;
  vMsg: array[1..cnstBufSize] of WideChar;
  vTTFMode: Integer;
  S: string;

  function SetImageParam(APixelFormat: TPixelFormat = pf24bit; AWidth: Integer = 0;
    AHeigth: Integer = 0): PsgImageParam;
  begin
    New(Result);
    Result^.Heigth := AHeigth;
    Result^.Width := AWidth;
    Result^.PixelFormat := APixelFormat;
  end;

begin
  if (FCADFile = 0) or not SaveDialog.Execute then Exit;
  vTTFMode := 0;
  vFileName := SaveDialog.FileName;
  vExt := ExtractFileExt(vFileName);
  if vExt = '' then
  begin
    vFileExts := TStringList.Create;
    try
      vFileExts.Text := StringReplace(SaveDialog.Filter, '|', #13#10, [rfReplaceAll]);
      vExt := vFileExts[SaveDialog.FilterIndex * 2 - 1];
      Delete(vExt, 1, 1);
      vFileName := vFileName + vExt;
    finally
      vFileExts.Free;
    end;
  end;

  if GetExportFormat(vExt) in [efBitmap..efPng] then
    vKoef := Min(800/FAbsWidth, 600/FAbsHeight)
  else
    vKoef := 1;
  vKoef := 1;

  if GetExportFormat(vExt) in [efSvg] then
    vTTFMode := 1;//export text

  vExportParams := GenerateXMLParams(vFileName, vExt,
    Trunc(vKoef * FAbsWidth), Trunc(vKoef * FAbsHeight), clBlack, clWhite, vTTFMode);

  if Length(vExportParams) > 0 then
    if SaveCADtoFileWithXMLParams(FCADFile, PWideChar(WideString(vExportParams)), nil) = 0 then
    begin
      GetLastErrorCAD(@vMsg[1], cnstBufSize);
      S := PWideChar(@vMsg[1]);
      Application.MessageBox(PChar(S), '', MB_OK);
    end;
end;

procedure TfmMain.mmiShowPointClick(Sender: TObject);
var
  vScale: Double;
  R: TRect;
  vCenter: TFPoint;
  vDefRect: TFRect;
  P: TPoint;
begin
  vDefRect := FDrawRect.Rect;
  vScale := (vDefRect.Right - vDefRect.Left) / FAbsWidth;
  if GetPointParams(FRectExtentsCAD, vScale, FCADPoint, FShowFndPntMarker) = 1 then
  begin
    R := GetViewportRect;
    vCenter.X := (R.Right + R.Left) / 2.0;
    vCenter.Y := (R.Bottom + R.Top) / 2.0;
    FDrawRect.BeginUpdate;
    try
      FDrawRect.SetRect(FRectExtentsCAD.Left, FRectExtentsCAD.Bottom,
        FRectExtentsCAD.Right, FRectExtentsCAD.Top);//100%
      P := GetPoint(FCADPoint);
      FDrawRect.Offset(vCenter.X - P.X, vCenter.Y - P.Y);
      FDrawRect.Scale(vScale, vCenter.X, vCenter.Y);
    finally
      FDrawRect.EndUpdate;
    end;
  end;
end;

{ TCADDrawRect }

procedure TCADDrawRect.BeginUpdate;
begin
  Inc(FUpdateCount);
end;

procedure TCADDrawRect.DoChanged;
begin
  if FUpdateCount = 0 then
    inherited DoChanged;
end;

procedure TCADDrawRect.DoMove;
begin
  if FUpdateCount = 0 then
    inherited DoMove;
end;

procedure TCADDrawRect.DoScale;
begin
  if FUpdateCount = 0 then
    inherited DoScale;
end;

procedure TCADDrawRect.EndUpdate;
begin
  Dec(FUpdateCount);
  DoChanged;
end;

function TCADDrawRect.GetDrawRect: TFRect;
begin
  Result := MakeFRect(Left, Top, 0, Left + Width, Top + Height, 0);
end;

procedure TCADDrawRect.SetDrawRect(const Value: TFRect);
begin
  SetRect(Value.Left, Value.Top, Value.Right, Value.Bottom);
end;

initialization

  {$IFDEF MEMCHK}
  MemChk;
  {$ENDIF}

end.
