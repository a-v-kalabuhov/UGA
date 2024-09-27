{************************************************************}
{           CAD Importer SDK DLL Version demo          }
{                                                            }
{      Copyright (c) 2002-2015 SoftGold software company     }
{                                                            }
{************************************************************}
//{$DEFINE DRAWSPLINE}

unit Main;

interface

{$DEFINE SG_CADIMPORTERDLLDEMO}

{.$DEFINE TEST_HOOK_UP_DECORATOR}
//{$DEFINE MEMCHK}

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, Menus, Buttons, xmldom, XMLIntf, msxmldom, XMLDoc,
  sgAboutDlg, CADGraphic, ExtCtrls, ComCtrls, Math, sgInitSHX, sgDrawRect
{$IFDEF MEMCHK}, MemCheck{$ENDIF}
  ;

type
  TfmCADDLLdemo = class(TForm)
    pnlOptions: TPanel;
    OpenDialog1: TOpenDialog;
    MainMenu1: TMainMenu;
    mmiHome: TMenuItem;
    Exit1: TMenuItem;
    N1: TMenuItem;
    mmiOpen: TMenuItem;
    mmiFitToWindow: TMenuItem;                 
    cbSplitArcs: TCheckBox;
    pmiAbout: TMenuItem;
    pmiShowAbout: TMenuItem;
    cbUseWinLine: TCheckBox;
    cbHideDimensions: TCheckBox;
    cbAllLayers: TCheckBox;
    cbProhibitArcsAsCurves: TCheckBox;
    btnFitToWindow: TSpeedButton;
    cbTextAsCurves: TCheckBox;
    cbSplitSplines: TCheckBox;
    cb3dFaceforACIS: TCheckBox;
    N2: TMenuItem;
    mmiFontSettings: TMenuItem;
    N3: TMenuItem;
    mmiSaveAs: TMenuItem;
    SaveDialog: TSaveDialog;
    mmiView: TMenuItem;
    mmiDoubleBuffered: TMenuItem;
    StatusBar: TStatusBar;
    cbLayouts: TComboBox;
    cbLayers: TComboBox;
    mmiClose: TMenuItem;
    procedure cb3DFaceForACISClick(Sender: TObject);
    procedure cbAllLayersClick(Sender: TObject);
    procedure cbHideDimensionsClick(Sender: TObject);
    procedure cbLayersDrawItem(Control: TWinControl; Index: Integer;
      Rect: TRect; State: TOwnerDrawState);
    procedure cbLayoutsChange(Sender: TObject);
    procedure cbProhibitArcsAsCurvesClick(Sender: TObject);
    procedure cbSplitArcsClick(Sender: TObject);
    procedure cbSplitSplinesClick(Sender: TObject);
    procedure cbTextAsCurvesClick(Sender: TObject);
    procedure cbUseWinLineClick(Sender: TObject);
    procedure Exit1Click(Sender: TObject);
    procedure FitToWindowClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
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
    procedure mmiDoubleBufferedClick(Sender: TObject);
    procedure mmiFontSettingsClick(Sender: TObject);
    procedure mmiOpenClick(Sender: TObject);
    procedure mmiSaveAsClick(Sender: TObject);
    procedure pmiShowAboutClick(Sender: TObject);
    procedure mmiCloseClick(Sender: TObject);
  private
    FCurrentDir: string;
    FLeftDown: Boolean;
    FMove: TPoint;
    FDown: Boolean;
    FDownPos: TPoint;
    FDrawRect: TDrawRect;
    FPicture: TPicture;
    FCADGraphic: TCADGraphic;
    procedure SizeChanged;
    function GetViewport: TRect;
    procedure DoFit;
    function DoScale(const AScale: Double; ScreenPos: TPoint): Boolean;
    procedure PictureChanged(Sender: TObject);
    procedure DrawRectChanged(Sender: TObject);
    procedure DrawZoomRect(X, Y: Integer; AHide: Boolean);
  protected
    property DrawRect: TDrawRect read FDrawRect;
    property Viewport: TRect read GetViewport;
  end;

var
  fmCADDLLdemo: TfmCADDLLdemo;

implementation

uses sgConsts, CADIntf, SHXDlg;

{$R *.DFM}

const
  cnstCaption = 'CAD Importer DLL [Delphi Demo]';

{$IFDEF TEST_HOOK_UP_DECORATOR}
var
  BaseCADPainterClass: TCADPainterClass;

type
  TMyCADEntityDecorator = class(TCustomCADPainter)
  private
    FOwner: TCustomCADPainter;
  protected
    function GetContext: TCanvas; override;
    procedure SetContext(const Value: TCanvas); override;
  public
    constructor Create(const ATransformation: TCustomTransformation); override;
    destructor Destroy; override;
    function DoInvoke(const AData: TcadData): Integer; override;
    procedure InitializeCADDrawOptions(AOptions: PCADDrawOptions); override;
  end;
{$ENDIF}

procedure NormalRect(var R: TRect);
begin
  if R.Left > R.Right then SwapInts(R.Left, R.Right);
  if R.Top > R.Bottom then SwapInts(R.Top, R.Bottom);
end;

{ TfmCADDLLdemo }

procedure TfmCADDLLdemo.FormPaint(Sender: TObject);
var
  R: TRect;
begin
  R := Viewport;
  IntersectClipRect(Canvas.Handle, R.Left, R.Top, R.Right, R.Bottom);
  Canvas.Brush.Color := Color;
  Canvas.FillRect(R);
  Canvas.StretchDraw(FDrawRect.RoundRect, FPicture.Graphic);
  if FLeftDown then
    DrawZoomRect(FMove.X, FMove.Y, True);
end;

function TfmCADDLLdemo.GetViewport: TRect;
begin
  Result := ClientRect;
  Result.Top := pnlOptions.BoundsRect.Bottom;
  Result.Bottom := StatusBar.Top - 1;
  Dec(Result.Right);
end;

procedure TfmCADDLLdemo.FormMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  if Button = mbLeft then
  begin
    FLeftDown := True;
    FDownPos := Point(X, Y);
    FMove := FDownPos;
  end;
  if Button in [mbRight, mbMiddle] then
  begin
    FDown := True;
    FDownPos := Point(X, Y);
    Cursor := crDrag;
    Perform(WM_SETCURSOR, Handle, HTCLIENT);
  end;
  if [ssDouble, ssMiddle] * Shift = [ssDouble, ssMiddle] then
    DoFit;
end;

procedure TfmCADDLLdemo.FormMouseMove(Sender: TObject; Shift: TShiftState; X,
  Y: Integer);
begin
  if FLeftDown and (ssLeft in Shift) then
  begin
    DrawZoomRect(X, Y, False);
  end;
  if FDown and ([ssRight, ssMiddle] * Shift <> []) then
    if FDrawRect.Offset(X - FDownPos.X, Y - FDownPos.Y) then
      FDownPos := Point(X, Y);
end;

procedure TfmCADDLLdemo.FormMouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  if FLeftDown and (Button = mbLeft) then
  begin
    FLeftDown := False;
    DrawZoomRect(X, Y, True);
    FDrawRect.Zoom(Viewport, Rect(FDownPos.X, FDownPos.Y, X, Y));
  end;
  if FDown and (Button in [mbRight, mbMiddle]) then
  begin
    FDown := False;
    Cursor := crCross;
  end;
end;

procedure TfmCADDLLdemo.FormMouseWheelDown(Sender: TObject; Shift: TShiftState;
  MousePos: TPoint; var Handled: Boolean);
begin
  Handled := DoScale(4/5, MousePos);
end;

procedure TfmCADDLLdemo.FormMouseWheelUp(Sender: TObject; Shift: TShiftState;
  MousePos: TPoint; var Handled: Boolean);
begin
  Handled := DoScale(5/4, MousePos);
end;

procedure TfmCADDLLdemo.cbSplitSplinesClick(Sender: TObject);
begin
  if Assigned(FCADGraphic) then FCADGraphic.SplittedSplines := cbSplitSplines.Checked;
end;

procedure TfmCADDLLdemo.cbHideDimensionsClick(Sender: TObject);
begin
  if Assigned(FCADGraphic) then FCADGraphic.HideDimensions := cbHideDimensions.Checked;
end;

procedure TfmCADDLLdemo.cbLayersDrawItem(Control: TWinControl; Index: Integer;
  Rect: TRect; State: TOwnerDrawState);
var
  C: Integer;
begin
  with cbLayers.Canvas do
  begin
    C := Integer(cbLayers.Items.Objects[Index]);
    Brush.Color := clWindow;
    FillRect(Rect);
    // invisible
    if (C and $80000000) <> 0 then
      Font.Color := clGrayText
    else
      Font.Color := clWindowText;
    TextRect(Rect, Rect.Left+16, Rect.Top, cbLayers.Items[Index]);
    Brush.Color := ColorToRGB(C and $7FFFFFFF);
    Rectangle(Rect.Left+2, Rect.Top+2, Rect.Left+12, Rect.Top+12);
  end;
end;

procedure TfmCADDLLdemo.FormCreate(Sender: TObject);
begin
  FPicture := TPicture.Create;
  FPicture.OnChange := PictureChanged;
  FDrawRect := TDrawRect.Create;
  FDrawRect.SetBounds(0, 0, 1, 1);
  FDrawRect.OnChanged := DrawRectChanged;
  FDrawRect.OnScaled := DrawRectChanged;
  FDrawRect.OnMoved := DrawRectChanged;
  OpenDialog1.Filter := GraphicFilter(TGraphic);
  InitSHX(Pointer(@CADSetSHXOptions));
end;

procedure TfmCADDLLdemo.FormDestroy(Sender: TObject);
begin
  FreeAndNil(FPicture);
  FreeAndNil(FDrawRect);
end;

procedure TfmCADDLLdemo.mmiCloseClick(Sender: TObject);
begin
  FPicture.Graphic := nil;
end;

procedure TfmCADDLLdemo.mmiDoubleBufferedClick(Sender: TObject);
begin
  DoubleBuffered := mmiDoubleBuffered.Checked;
  Invalidate;
end;

procedure TfmCADDLLdemo.mmiFontSettingsClick(Sender: TObject);
begin
  FontSettingsDlg.Visible := True;
end;

procedure TfmCADDLLdemo.mmiOpenClick(Sender: TObject);
var
  I, vCnt: Integer;
  vBuff: array[Byte] of Char;
  vData: TcadData;
  vFileName: string;
begin
  try
    if mmiOpen.Checked then
      Exit;
    OpenDialog1.InitialDir := FCurrentDir;
    if not OpenDialog1.Execute then
      Exit;
    mmiOpen.Checked := True;
    vFileName := OpenDialog1.FileName;
    if Length(vFileName) > 1 then
      FCurrentDir := ExtractFilePath(vFileName);
    FPicture.LoadFromFile(vFileName);
    StatusBar.Panels[0].Text := ExtractFileName(vFileName);
    // apply draw params
    if Assigned(FCADGraphic) then
    begin
      FCADGraphic.TextByCurves := cbTextAsCurves.Checked;
      FCADGraphic.SplittedSplines := cbSplitSplines.Checked;
      FCADGraphic.SplitArcs := cbSplitArcs.Checked;
      FCADGraphic.ProhibitArcsAsCurves := cbProhibitArcsAsCurves.Checked;
      FCADGraphic.HideDimensions := cbHideDimensions.Checked;
      FCADGraphic.UseWinLine := cbUseWinLine.Checked;
      FCADGraphic.AllLayers := cbAllLayers.Checked;
      FCADGraphic.Is3DFaceForAcis := cb3dFaceforACIS.Checked;
      vCnt := CADLayerCount(FCADGraphic.Handle);
      for I := 0 to vCnt - 1 do
      begin
        FillChar(vData, SizeOf(TcadData), 0);
        CADLayer(FCADGraphic.Handle, I, @vData);
        if (vData.Flags and 1 = 0) or (vData.Flags and 2 <> 0) then
          vData.Color := vData.Color or Integer($80000000);
        cbLayers.Items.AddObject(string(String(vData.Text)), TObject(vData.Color));
      end;
      vCnt := CADLayoutCount(FCADGraphic.Handle);
      for I := 0 to vCnt - 1 do
      begin
        FillChar(vBuff, SizeOf(vBuff), 0);
        CADLayoutName(FCADGraphic.Handle, I, PChar(@vBuff[0]), Length(vBuff));
        cbLayouts.Items.Add(string(PChar(@vBuff[0])));
      end;
      cbLayouts.ItemIndex := FCADGraphic.CurrentLayoutIndex;
    end;
    SizeChanged;
    DoFit;
    btnFitToWindow.Enabled := True;
    mmiOpen.Checked := False;
    Caption := cnstCaption + ' - [' + ExtractFileName(vFileName) + ']';
  except
    StatusBar.Panels[0].Text := '';
    Caption := cnstCaption;
    mmiOpen.Checked := False;
  end;
end;

procedure TfmCADDLLdemo.FitToWindowClick(Sender: TObject);
begin
  DoFit;
end;

procedure TfmCADDLLdemo.Exit1Click(Sender: TObject);
begin
  Close;
end;

procedure TfmCADDLLdemo.cbSplitArcsClick(Sender: TObject);
begin
  if Assigned(FCADGraphic) then FCADGraphic.SplitArcs := cbSplitArcs.Checked;
end;

procedure TfmCADDLLdemo.cbTextAsCurvesClick(Sender: TObject);
begin
  if Assigned(FCADGraphic) then FCADGraphic.TextByCurves := cbTextAsCurves.Checked;
end;

procedure TfmCADDLLdemo.PictureChanged(Sender: TObject);
var
  G: TGraphic;

  procedure ClearControls;
  begin
    mmiSaveAs.Enabled := False;
    cbLayers.Clear;
    cbLayouts.Clear;
    StatusBar.Panels[0].Text := '';
    StatusBar.Panels[1].Text := '';
    StatusBar.Panels[2].Text := '';
  end;

begin
  G := FPicture.Graphic;
  if G = nil then
  begin
    ClearControls;
    FCADGraphic := nil;
  end
  else
    if G.ClassType <> TCADGraphic then
    begin
      if FCADGraphic <> nil then
        ClearControls;
      FCADGraphic := nil;
    end
    else
    begin
      if FCADGraphic <> G then
        ClearControls;
      FCADGraphic := TCADGraphic(G);
      mmiSaveAs.Enabled := not FCADGraphic.Empty;
    end;
  Invalidate;
end;

procedure TfmCADDLLdemo.cb3DFaceForACISClick(Sender: TObject);
begin
  if Assigned(FCADGraphic) then FCADGraphic.Is3DFaceForAcis := cb3dFaceforACIS.Checked;
end;

procedure TfmCADDLLdemo.cbUseWinLineClick(Sender: TObject);
begin
  if Assigned(FCADGraphic) then FCADGraphic.UseWinLine := cbUseWinLine.Checked;
end;

procedure TfmCADDLLdemo.DoFit;
begin
  if FPicture.Width <> 0 then
    FDrawRect.FitTo(Viewport, FPicture.Height / FPicture.Width);
end;

function TfmCADDLLdemo.DoScale(const AScale: Double; ScreenPos: TPoint): Boolean;
begin
  Result := False;
  if not (cbLayers.DroppedDown or cbLayouts.DroppedDown) then
  begin
    ScreenPos := ScreenToClient(ScreenPos);
    Result := FDrawRect.Scale(AScale, ScreenPos.X, ScreenPos.Y);
    ActiveControl := nil;
  end;
end;

procedure TfmCADDLLdemo.DrawRectChanged(Sender: TObject);
var
  R: TRect;
begin
  //Invalidate;
  R := Viewport;
  InvalidateRect(WindowHandle, @R, not (csOpaque in ControlStyle));
end;

procedure TfmCADDLLdemo.DrawZoomRect(X, Y: Integer; AHide: Boolean);
begin
  with TRecall.Create(TPen.Create, Canvas.Pen) do
  try
    Canvas.Pen.Mode := pmNotXor;
    Canvas.Pen.Style := psDot;
    Canvas.Pen.Color := clBlack;
    Canvas.Brush.Style := bsClear;
    Canvas.Rectangle(FDownPos.X, FDownPos.Y, FMove.X, FMove.Y);
    FMove := Point(X, Y);
    if not AHide then
      Canvas.Rectangle(FDownPos.X, FDownPos.Y, FMove.X, FMove.Y);
  finally
    Free;
  end;
end;

procedure TfmCADDLLdemo.cbProhibitArcsAsCurvesClick(Sender: TObject);
begin
  // "False" permit conversion of arcs to polyline
  if Assigned(FCADGraphic) then FCADGraphic.ProhibitArcsAsCurves := cbProhibitArcsAsCurves.Checked;
end;

procedure TfmCADDLLdemo.pmiShowAboutClick(Sender: TObject);
begin
  ShowAboutDlg('About CAD DLL');
end;

procedure TfmCADDLLdemo.SizeChanged;
const
  cnstMeasure: array[0 .. 2] of string = ('Inches', 'Millimeters', 'Pixels');
var
  vUnits: Integer;
  vSize: TF2DPoint;
  S: string;
begin
  if Assigned(FCADGraphic) then
  begin
    vSize := MakeF2DPoint(FCADGraphic.AbsWidth, FCADGraphic.AbsHeight);
    vUnits := FCADGraphic.Units;
  end
  else
    if FPicture.Graphic is TMetafile then
    begin
      vSize := MakeF2DPoint(FPicture.Metafile.MMWidth / 100.0,
        FPicture.Metafile.MMHeight / 100.0);
      vUnits := 1;
    end
    else
    begin
      vSize := MakeF2DPoint(FPicture.Width, FPicture.Height);
      vUnits := 2;
    end;
  S := Format('%f x %f', [vSize.X, vSize.Y]);
  StatusBar.Canvas.Font := StatusBar.Font;
  StatusBar.Panels[1].Width := StatusBar.Canvas.TextWidth(S) + 8;
  StatusBar.Panels[1].Text := S;
  StatusBar.Panels[2].Text := cnstMeasure[vUnits];// Drawing units (inches or millimeters)
end;

procedure TfmCADDLLdemo.cbAllLayersClick(Sender: TObject);
begin
  if Assigned(FCADGraphic) then FCADGraphic.AllLayers := cbAllLayers.Checked;
end;

procedure TfmCADDLLdemo.cbLayoutsChange(Sender: TObject);
begin
  if Assigned(FCADGraphic) then
  begin
    FCADGraphic.CurrentLayoutIndex := cbLayouts.ItemIndex;
    DoFit;
    SizeChanged;
  end;
end;

function GenerateXMLParams(const AFileName, AFileExt: string;
  const AAbsWidth, AAbsHeight: Single;
  const ADefaultColor, ABackground: TColor): string;
var
  vGraphicsParams, vCADParametrs, vDrawRect: IXMLNode;
  vXMLExportParams: IXMLDocument;
  vStream: TMemoryStream;
  vBytesSize: Integer;
  vExt: string;
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
    vGraphicsParams.AddChild('Width').Text := IntToStr(Round(AAbsWidth));
    vGraphicsParams.AddChild('Height').Text := IntToStr(Round(AAbsHeight));

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

    vExt := AnsiLowerCase(AFileExt);
    if (vExt = '.cgm') or (vExt = '.svg') then
    begin
      vXMLExportParams.DocumentElement.AddChild('LayoutExportMode').Text := '4';//current layout;
    end;

    vStream := TMemoryStream.Create;
    try
      vXMLExportParams.Encoding := 'utf-8';
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

procedure TfmCADDLLdemo.mmiSaveAsClick(Sender: TObject);
const
  cnstBufSize = 1024;
var
  vFileName, vExt: string;
  vFileExts: TStringList;
  vExportParams: String;
  vKoef: Double;
  vMsg: array[1..cnstBufSize] of Char;
begin
  if not Assigned(FCADGraphic) then Exit;
  if FCADGraphic.Empty or not SaveDialog.Execute then Exit;
  vFileName := SaveDialog.FileName;
  vExt := ExtractFileExt(vFileName);
  if vExt = '' then
  begin
    vFileExts := TStringList.Create;
    try
      vFileExts.LineBreak := '|';
      vFileExts.Text := SaveDialog.Filter;
      vExt := vFileExts[SaveDialog.FilterIndex * 2 - 1];
      Delete(vExt, 1, 1);
      vFileName := vFileName + vExt;
    finally
      vFileExts.Free;
    end;
  end;

  if GetExportFormat(vExt) in [efBitmap..efPng] then
    vKoef := Min(800/FCADGraphic.AbsWidth, 600/FCADGraphic.AbsHeight)
  else
    vKoef := 1;

  vExportParams := String(GenerateXMLParams(vFileName, vExt,
    vKoef*FCADGraphic.AbsWidth, vKoef*FCADGraphic.AbsHeight,
    clBlack, clWhite));
  if Length(vExportParams) > 0 then
    if SaveCADtoFileWithXMLParams(FCADGraphic.Handle, PChar(vExportParams), nil) <> 0 then
      Application.MessageBox(PChar('File saved as: ' + vFileName), '', MB_OK)
    else
    begin
      GetLastErrorCAD(@vMsg[1], cnstBufSize);
      Application.MessageBox(PChar(@vMsg[1]), 'CAD DLL Error', MB_OK);
    end;
end;
{$IFDEF TEST_HOOK_UP_DECORATOR}
{ TMyCADEntityDecorator }

function TMyCADEntityDecorator.DoInvoke(const AData: TcadData): Integer;
begin
  { TODO: decorate any entity (Sender == Self) }
  // before draw
  Result := FOwner.DoInvoke(AData);
  // after draw
end;

function TMyCADEntityDecorator.GetContext: TCanvas;
begin
  if Assigned(FOwner) then
    Result := FOwner.Context
  else
    Result := nil;
end;

procedure TMyCADEntityDecorator.InitializeCADDrawOptions(AOptions: PCADDrawOptions);
begin
  if Assigned(FOwner) then FOwner.InitializeCADDrawOptions(AOptions);
end;

procedure TMyCADEntityDecorator.SetContext(const Value: TCanvas);
begin
  if Assigned(FOwner) then FOwner.Context := Value;
end;

constructor TMyCADEntityDecorator.Create(const ATransformation: TCustomTransformation);
begin
  inherited Create(ATransformation);
  FOwner := BaseCADPainterClass.Create(ATransformation);
end;

destructor TMyCADEntityDecorator.Destroy;
begin
  FreeAndNil(FOwner);
  inherited Destroy;
end;
{$ENDIF}

initialization
{$IFDEF TEST_HOOK_UP_DECORATOR}
  BaseCADPainterClass := CADPainterClass;
  CADPainterClass := TMyCADEntityDecorator;
{$ENDIF}

{$IFDEF MEMCHK}
  MemChk
{$ENDIF}

finalization
{$IFDEF TEST_HOOK_UP_DECORATOR}
  CADPainterClass := BaseCADPainterClass;
{$ENDIF}
end.
