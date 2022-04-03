unit PrintOtvod;

interface

uses
  Windows, Messages, SysUtils, Classes, Controls, Forms, StdCtrls, Types, ComObj, Variants,
  ExtCtrls, Buttons, Printers, ToolWin, Menus, Graphics, ExtDlgs, ComCtrls, Math, OleServer, Dialogs,
  // jedi
  JvComponentBase, JvFormPlacement,
  // shared
  uFileUtils, uGC, uClasses,
  // kis
  ImageBox, GrphUtil, Draw, APrinter6, AProc6, AString6, CoordProp, AGraph6,
  // kis
  uKisAllotmentClasses, uKisAppModule, uKisConsts;

type
  TOtvodPrintForm = class(TForm)
    ScrollBox: TScrollBox;
    pnlPage: TPanel;
    PrinterSetupDialog: TPrinterSetupDialog;
    ToolBar: TToolBar;
    ToolButton4: TToolButton;
    ToolButton7: TToolButton;
    Label3: TLabel;
    ScaleCombo: TComboBox;
    ExitBtn: TBitBtn;
    ToolButton2: TToolButton;
    ConfigMenu: TPopupMenu;
    CompassItm: TMenuItem;
    ibPage: TImage;
    OtvodItm: TMenuItem;
    ScaleItm: TMenuItem;
    CoordItm: TMenuItem;
    SaveDialog: TSavePictureDialog;
    CoordMenu: TPopupMenu;
    CoordConfigItm: TMenuItem;
    btnScaleAll: TSpeedButton;
    btnScaleWidth: TSpeedButton;
    btnScale100: TSpeedButton;
    SaveBtn: TSpeedButton;
    PrinterSetupBtn: TSpeedButton;
    PrintBtn: TSpeedButton;
    ShpShadow: TShape;
    FormStorage: TJvFormStorage;
    FontDialog: TFontDialog;
    NetItm: TMenuItem;
    ToolButton3: TToolButton;
    sbVisio: TSpeedButton;
    sbWord: TSpeedButton;
    LabelsItm: TMenuItem;
    LineLabelsItm: TMenuItem;
    miCS: TMenuItem;
    procedure PrinterSetupBtnClick(Sender: TObject);
    procedure PrintBtnClick(Sender: TObject);
    procedure ScaleComboClick(Sender: TObject);
    procedure ScaleComboKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure ExitBtnClick(Sender: TObject);
    procedure CompassItmClick(Sender: TObject);
    procedure ConfigMenuPopup(Sender: TObject);
    procedure SaveBtnClick(Sender: TObject);
    procedure OtvodItmClick(Sender: TObject);
    procedure CoordItmClick(Sender: TObject);
    procedure ScaleItmClick(Sender: TObject);
    procedure CoordConfigItmClick(Sender: TObject);
    procedure btnScaleAllClick(Sender: TObject);
    procedure btnScaleWidthClick(Sender: TObject);
    procedure btnScale100Click(Sender: TObject);
    procedure ScrollBoxResize(Sender: TObject);
    procedure NetItmClick(Sender: TObject);
    procedure tbToWordClick(Sender: TObject);
    procedure sbVisioClick(Sender: TObject);
    procedure LabelsItmClick(Sender: TObject);
    procedure ScaleComboExit(Sender: TObject);
    procedure LineLabelsItmClick(Sender: TObject);
    procedure miCSClick(Sender: TObject);
  private
    ReportName: TFileName;
    Scale: Double;
    OtvodBox,CoordBox,CompassBox,ScaleBox: TImageBox;
    CoordMaxRows: Integer;
    NeedResizeControls: Boolean;
    FPageScale: TPageScale;
    _Params: TStrings;
    _Contours: TContours;
    _Information: string;
    _Neighbours: String;
    LatinNumber, ShowLength, ShowAzimuth, ShowOnPoint, ShowInfo, ShowNeighbours: Boolean;
    CoordView: Integer;
    NetCrossSize1, NetCrossSize2: Integer;
    Word, Visio: Variant;
    FCS: TCoordSystem;
    procedure OtvodBoxPaint(Sender: TObject);
    procedure OtvodBoxRotate(Sender: TObject);
    procedure OtvodBoxResize(Sender: TObject);
    procedure CoordBoxPaint(Sender: TObject);
    procedure CompassBoxPaint(Sender: TObject);
    procedure ScaleBoxPaint(Sender: TObject);
    procedure PrintToPrinter;
    procedure LoadReport(CreateObj: Boolean=True);
    procedure LoadObjects;
    function CreateEndMetafile: TMetaFile;
    procedure ResizeControls;
    procedure SetPageScale(Value: TPageScale);
    procedure GetVarList(var l: TStringList);
    procedure GetObjList(var l: TStringList);
    procedure CloseWord;
    procedure CloseVisio;
    function GetNewFileName(const dir, mask, ext: String): String;
  public
    property CS: TCoordSystem read FCS write FCS;
    property PageScale: TPageScale read FPageScale write SetPageScale default psWidth;
  end;

procedure PrintAReport(const FileName: string; Params: TStrings;
  const Contours: TContours; aCS: TCoordSystem; const Information, NeighBours: string);

implementation

{$R *.DFM}

const
  LineWidth = 1;

procedure PrintAReport(const FileName: string; Params: TStrings;
  const Contours: TContours; aCS: TCoordSystem; const Information, NeighBours: string);
begin
  with TOtvodPrintForm.Create(Application) do
  try
    _Params := Params;
    _Contours := Contours;
    _Information := Information;
    _Neighbours := NeighBours;
    FCS := aCS;
    miCS.Checked := FCS = csMCK36;
    LatinNumber := AppModule.ReadAppParam('OtvodPrintForm', 'LatinNumber', varBoolean);
    ShowLength := AppModule.ReadAppParam('OtvodPrintForm', 'ShowLength', varBoolean);
    ShowAzimuth := AppModule.ReadAppParam('OtvodPrintForm', 'ShowAzimuth', varBoolean);
    ShowOnPoint := AppModule.ReadAppParam('OtvodPrintForm', 'ShowOnPoint', varBoolean);
    ShowInfo := AppModule.ReadAppParam('OtvodPrintForm', 'ShowInfo', varBoolean);
    ShowNeighbours := AppModule.ReadAppParam('OtvodPrintForm', 'ShowNeighbours', varBoolean);
    CoordView := AppModule.ReadAppParam('OtvodPrintForm', 'CoordView', varSmallInt);
    LabelsItm.Checked := AppModule.ReadAppParam('OtvodPrintForm', 'LabelPoints', varBoolean);
    LineLabelsItm.Checked := AppModule.ReadAppParam('OtvodPrintForm', 'LineLabels', varBoolean);
    ReportName := FileName;
    SaveDialog.DefaultExt := GraphicExtension(TMetaFile);
    SaveDialog.Filter := GraphicFilter(TMetaFile);
    GetPrinterUnits;
    PageScale := psWidth;
    LoadReport;
    ScaleCombo.Text := '500';
    ShowModal;
    AppModule.SaveAppParam('OtvodPrintForm', 'LatinNumber', LatinNumber);
    AppModule.SaveAppParam('OtvodPrintForm', 'ShowLength', ShowLength);
    AppModule.SaveAppParam('OtvodPrintForm', 'ShowAzimuth', ShowAzimuth);
    AppModule.SaveAppParam('OtvodPrintForm', 'ShowOnPoint', ShowOnPoint);
    AppModule.SaveAppParam('OtvodPrintForm', 'ShowInfo', ShowInfo);
    AppModule.SaveAppParam('OtvodPrintForm', 'ShowNeighbours', ShowNeighbours);
    AppModule.SaveAppParam('OtvodPrintForm', 'CoordView', CoordView);
    AppModule.SaveAppParam('OtvodPrintForm', 'LabelPoints', LabelsItm.Checked);
    AppModule.SaveAppParam('OtvodPrintForm', 'LineLabels', LineLabelsItm.Checked);
  finally
    CloseWord;
    CloseVisio;
    Free;
  end;
end;

procedure TOtvodPrintForm.SetPageScale(Value: TPageScale);
begin
  if Value <> FPageScale then
  begin
    FPageScale := Value;
    btnScaleAll.Down := False;
    btnScaleWidth.Down := False;
    btnScale100.Down := False;
    case Value of
      psAll: btnScaleAll.Down := True;
      psWidth: btnScaleWidth.Down := True;
      ps100: btnScale100.Down := True;
    end;
    ResizeControls;
  end;
end;

procedure TOtvodPrintForm.ResizeControls;
const
  ShadowShift = 4;
  PageIndent = 16;
var
  OldWidth, Width100: Integer;
begin
  with pnlPage do
  try
    OldWidth := Width;
    NeedResizeControls:=False;
    ScrollBox.HorzScrollBar.Position:=0;
    ScrollBox.VertScrollBar.Position:=0;
    Width100:=Round(PageWidthMM*ScrPixPerMM);
    case PageScale of
      psAll:
        Width:=Min(ScrollBox.Width-2*PageIndent-ShadowShift,
        Trunc((ScrollBox.Height-2*PageIndent-ShadowShift)*Printer.PageWidth/
        Printer.PageHeight));
      psWidth: Width:=ScrollBox.Width-ScrollBox.VertScrollBar.Size-
        2*PageIndent-ShadowShift;
      ps100: Width:=Width100;
    end;
    Scale:=Width/Width100;
    Height:=Trunc(Width*Printer.PageHeight/Printer.PageWidth);
    case PageScale of
      psAll: begin
        Left:=Trunc((ScrollBox.Width-Width-ShadowShift)/2);
        Top:=Trunc((ScrollBox.Height-Height-ShadowShift)/2);
        end
      else begin
        Left:=PageIndent; Top:=PageIndent;
      end;
    end;
    shpShadow.Width:=Width;
    shpShadow.Height:=Height;
    shpShadow.Left:=Left+ShadowShift;
    shpShadow.Top:=Top+ShadowShift;
    if OtvodBox<>nil then begin
      OtvodBox.Left:=Round(OtvodBox.Left*Width/OldWidth);
      OtvodBox.Top:=Round(OtvodBox.Top*Width/OldWidth);
    end;
    if CoordBox<>nil then begin
      CoordBox.Left:=Round(CoordBox.Left*Width/OldWidth);
      CoordBox.Top:=Round(CoordBox.Top*Width/OldWidth);
    end;
    if CompassBox<>nil then begin
      CompassBox.Left:=Round(CompassBox.Left*Width/OldWidth);
      CompassBox.Top:=Round(CompassBox.Top*Width/OldWidth);
    end;
    if ScaleBox<>nil then
    begin
      ScaleBox.Left:=Round(ScaleBox.Left*Width/OldWidth);
      ScaleBox.Top:=Round(ScaleBox.Top*Width/OldWidth);
    end;
  finally
    NeedResizeControls:=True;
  end;
end;

function TOtvodPrintForm.GetNewFileName(const dir, mask, ext: String): String;
var
  SR: TSearchRec;
  found, i: Integer;
  name: String;
begin
  i := 0;
  found := FindFirst(TPath.Finish(dir, mask + '*', ext), faAnyFile, SR);
  while found = 0 do
  begin
    name := SR.Name;
    Delete(name, 1, Length(mask));
    SetLength(name, Length(name) - 4);
    try
      i := StrToInt(name);
    except
      i := 0;
    end;
    found := FindNext(SR);
  end;
  FindClose(SR);
  result := TPath.Finish(dir, mask + IntToStr(i + 1), ext);
end;

procedure TOtvodPrintForm.CloseVisio;
begin
  try
    if not VarIsEmpty(Visio) then
      if not Visio.Visible then
        Visio.Quit;
    VarClear(Visio);
  except
    on E: EOleError do
      Beep;
    on E: EOleSysError do
      Beep;
    on E: EOleException do
      Beep;
  end;
end;

procedure TOtvodPrintForm.CloseWord;
begin
  try
    if not VarIsEmpty(word) then
      if not Word.Visible then
        Word.Quit;
    VarClear(word);
  except
    on E: EOleError do
      Beep;
    on E: EOleSysError do
      Beep;
    on E: EOleException do
      Beep;
  end;
end;

procedure TOtvodPrintForm.GetObjList(var l: TStringList);
begin
  l.Clear;
  if CoordBox <> nil then
  if CoordBox.Visible then l.Add('координаты');
  if OtvodBox <> nil then
  if OtvodBox.Visible then l.Add('отвод');
  if CompassBox <> nil then
  if CompassBox.Visible then l.Add('стрелка');
  if ScaleBox <> nil then
  if ScaleBox.Visible then l.Add('масштаб');
end;

procedure TOtvodPrintForm.GetVarList(var l: TStringList);
begin
  l.Assign(_Params);
end;

procedure TOtvodPrintForm.PrinterSetupBtnClick(Sender: TObject);
begin
  if PrinterSetupDialog.Execute then
  begin
    GetPrinterUnits;
    LoadReport(False);
    ResizeControls;
  end;
end;

procedure TOtvodPrintForm.PrintBtnClick(Sender: TObject);
begin
  PrintToPrinter;
end;

procedure TOtvodPrintForm.OtvodBoxPaint(Sender: TObject);
var
  Params: TPrintRegion1Params;
begin
  if NetItm.Checked then
  begin
    NetCrossSize1 := 15;
    NetCrossSize2 := 25;
  end
  else
  begin
    NetCrossSize1 := 0;
    NetCrossSize2 := 0;
  end;

  with OtvodBox do
  begin
    Params.Points := _Contours;
    Params.Canvas := Canvas;
    Params.Rect := Rect(0, 0, Width, Height);
    Params.PixPerMMH := ScrPixPerMM;
    Params.PixPerMMV := ScrPixPerMM;
    Params.LatinNames := LatinNumber;
    Params.LineWidth := LineWidth;
    Params.Scale := Scale;
    Params.Divisor := StrToIntDef(ScaleCombo.Text, 500);
    Params.Corner := DegToRad(Corner);
    Params.Connect := True;
    Params.CrossSize := NetCrossSize1;
    Params.LabelPoints := LabelsItm.Checked;
    Params.LineLabels := LineLabelsItm.Checked;
    Params.LabelsFont := nil;
    Params.Cs := FCs; //а этого параметра ВАЩЕ НЕБЫЛО!!! (edde) потому меры линий на чертеже не совпадали
    PrintRegion1(Params);    //   в экран
    Width := Params.Rect.Right;
    Height := Params.Rect.Bottom;
  end;
end;

procedure TOtvodPrintForm.OtvodBoxRotate(Sender: TObject);
begin
  if Assigned(CompassBox) then
    CompassBox.Invalidate;
end;

procedure TOtvodPrintForm.OtvodBoxResize(Sender: TObject);
begin
  if Assigned(ScaleBox) then
    ScaleBox.Invalidate;
end;

procedure TOtvodPrintForm.CoordBoxPaint(Sender: TObject);
var
  DrawRect: TRect;
begin
  DrawRect := Rect(0, 0, CoordBox.Width, CoordBox.Height);
  if CoordView=1 then
    PrintCoord(_Contours, FCS, CoordBox.Canvas, DrawRect, Scale, FontDialog.Font,
      CoordMaxRows, LatinNumber, ShowLength, ShowAzimuth, ShowOnPoint, ShowInfo, ShowNeighbours,
      _Information, _Neighbours)
  else
    PrintCoord2(_Contours, FCS, CoordBox.Canvas, DrawRect, Scale, FontDialog.Font,
      CoordMaxRows, LatinNumber, ShowLength, ShowAzimuth, ShowOnPoint, ShowInfo, ShowNeighbours,
      _Information, _Neighbours);
  CoordBox.Width := DrawRect.Right;
  CoordBox.Height := DrawRect.Bottom;
end;

procedure TOtvodPrintForm.CompassBoxPaint(Sender: TObject);
var
  DrawRect: TRect;
begin
  with CompassBox do
  begin
    DrawRect := Rect(0, 0, Width, Height);
    PrintCompass(Canvas, DrawRect, DegToRad(OtvodBox.Corner), ScrPixPerMM * Scale);
    Width := DrawRect.Right;
    Height := DrawRect.Bottom;
  end;
end;

procedure TOtvodPrintForm.ScaleBoxPaint(Sender: TObject);
var
  DrawRect: TRect;
begin
  with ScaleBox do
  begin
    DrawRect:=Rect(0,0,Width,Height);
    Draw.PrintScale(Canvas,DrawRect,Scale,StrToInt(ScaleCombo.Text));
    Width:=DrawRect.Right;
    Height:=DrawRect.Bottom;
  end;
end;

procedure TOtvodPrintForm.LoadReport(CreateObj: Boolean=True);
var
  Canvas: TMetaFileCanvas;
  oldBrStyle: TBrushStyle;
  oldPenStyle: TPenStyle;
  oldBrColor, oldPenColor: TColor;
  R: TRect;
begin
  ibPage.Picture.MetaFile.MMWidth := Round(PageWidthMM * 100);
  ibPage.Picture.MetaFile.MMHeight := Round(PageHeightMM * 100);
  ibPage.Picture.MetaFile.Width := GetDeviceCaps(Printer.Handle, PHYSICALWIDTH);
  ibPage.Picture.MetaFile.Height := GetDeviceCaps(Printer.Handle, PHYSICALHEIGHT);
  Canvas := TMetaFileCanvas.Create(ibPage.Picture.MetaFile, Printer.Handle);
  try
    Canvas.Font.PixelsPerInch := Round(PrnPixPerMMH * MMPerInch);
    oldPenStyle := Canvas.Pen.Style;
    oldPenColor := Canvas.Pen.Color;
    oldBrStyle := Canvas.Brush.Style;
    oldBrColor := Canvas.Brush.Color;
    try
      Canvas.Pen.Style := psSolid;
      Canvas.Pen.Color := clWhite;
      Canvas.Brush.Style := bsSolid;
      Canvas.Brush.Color := clWhite;
      //
      R := Rect(0, 0, ibPage.Picture.MetaFile.Width, ibPage.Picture.MetaFile.Height);
      Canvas.Rectangle(R);
      Canvas.FillRect(R);
    finally
      Canvas.Pen.Style := oldPenStyle;
      Canvas.Pen.Color := oldPenColor;
      Canvas.Brush.Style := oldBrStyle;
      Canvas.Brush.Color := oldBrColor;
    end;
    LoadText(ReportName, Canvas, PrnPixPerMMH, 1, _Params);
    if CreateObj then
      LoadObjects;
    //ibPage.Picture.MetaFile.SaveToFile('c:\2.emf');
  finally
    Canvas.Free;
  end;
end;

procedure TOtvodPrintForm.miCSClick(Sender: TObject);
begin
  if miCS.Checked then
    FCS := csMCK36
  else
    FCS := csVrn;
  if Assigned(CoordBox) then
  if CoordBox.Visible then
  begin
    CoordBox.Visible := False;
    CoordBox.Visible := True;
  end;
  Invalidate;
end;

procedure TOtvodPrintForm.LoadObjects;
var
  F: TextFile;
  St, Macros: String;

  procedure SetObjPosition(Obj: TImageBox);
  begin
    Obj.Parent := pnlPage;
    Obj.Left := Round(StrToIntDef(GetStrValue(GetParamValue(Macros), 1), 0) * ScrPixPerMM * Scale);
    Obj.Top := Round(StrToIntDef(GetStrValue(GetParamValue(Macros), 2), 0) * ScrPixPerMM * Scale);
    Obj.Border := psDot;
  end;

begin
  AssignFile(F, ReportName);
  Reset(F);
  while not Eof(F) do
  begin
    //читаем строку
    Readln(F, St);
    //вычленяем и интерпретируем макрос
    repeat
      Macros := ExtractMacros(St);
      if GetParamName(Macros) = '' then
        Break;
      if GetParamName(Macros) = 'ОТВОД' then
      begin
        OtvodBox := TImageBox.Create(pnlPage);
        SetObjPosition(OtvodBox);
        OtvodBox.OnPaint := OtvodBoxPaint;
        OtvodBox.OnRotate := OtvodBoxRotate;
        OtvodBox.OnResize := OtvodBoxResize;
        OtvodBox.Active := True;
        OtvodBox.TicksEnabled := [tkRotate];
        Continue;
      end;
      if GetParamName(Macros) = 'КООРДИНАТЫ' then
      begin
        CoordBox := TImageBox.Create(pnlPage);
        SetObjPosition(CoordBox);
        CoordMaxRows := StrToIntDef(GetStrValue(GetParamValue(Macros), 3), 50);
        CoordBox.OnPaint := CoordBoxPaint;
        CoordBox.PopupMenu := CoordMenu;
        CoordBox.TicksEnabled := [];
        Continue;
      end;
      if GetParamName(Macros) = 'СТРЕЛКА' then
      begin
        CompassBox := TImageBox.Create(pnlPage);
        SetObjPosition(CompassBox);
        CompassBox.OnPaint := CompassBoxPaint;
        CompassBox.TicksEnabled := [];
        Continue;
      end;
      if GetParamName(Macros) = 'МАСШТАБ' then
      begin
        ScaleBox := TImageBox.Create(pnlPage);
        SetObjPosition(ScaleBox);
        ScaleBox.OnPaint := ScaleBoxPaint;
        ScaleBox.TicksEnabled := [];
        Continue;
      end;
    until Macros = '';
  end;
  CloseFile(F);
end;

function TOtvodPrintForm.CreateEndMetafile: TMetaFile;
var
  MetaCanvas: TMetaFileCanvas;
  DrawRect: TRect;
  Params: TPrintRegion1Params;
begin
  Result := TMetaFile.Create;
  Result.MMWidth := Round(PageWidthMM * 100);
  Result.MMHeight := Round(PageHeightMM * 100);

  MetaCanvas := TMetaFileCanvas.Create(Result, Printer.Handle);
  try
    //наносим текст
    MetaCanvas.Font.PixelsPerInch := Round(PrnPixPerMMH * MMPerInch);
    MetaCanvas.Draw(0, 0, ibPage.Picture.MetaFile);
    //наносим отвод
    if (OtvodBox <> nil) and OtvodBox.Visible then
    begin
      DrawRect := Rect(Round(OtvodBox.Left / Scale / ScrPixPerMM * PrnPixPerMMH),
                       Round(OtvodBox.Top / Scale / ScrPixPerMM * PrnPixPerMMV), 0, 0);

      Params.Points := _Contours;
      Params.Canvas := MetaCanvas;
      Params.Rect := DrawRect;
      Params.PixPerMMH := PrnPixPerMMH;
      Params.PixPerMMV := PrnPixPerMMV;
      Params.LatinNames := LatinNumber;
      Params.LineWidth := LineWidth;
      Params.Scale := 1;
      Params.Divisor := StrToInt(ScaleCombo.Text);
      Params.Corner := DegToRad(OtvodBox.Corner);
      Params.Connect := True;
      Params.CrossSize := NetCrossSize2;
      Params.LabelPoints := LabelsItm.Checked;
      Params.LineLabels := LineLabelsItm.Checked;
      Params.LabelsFont := nil;
      Params.Cs := FCs;  //а этого параметра ВАЩЕ НЕБЫЛО!!!! (edde)  потому меры линий на чертеже не совпадали
      PrintRegion1(Params);  //в метафайл
    end;
    //наносим координаты
    if (CoordBox <> nil) and CoordBox.Visible then
    begin
      DrawRect := Rect(Round(CoordBox.Left / Scale / ScrPixPerMM * PrnPixPerMMH),
                       Round(CoordBox.Top / Scale / ScrPixPerMM * PrnPixPerMMV), 0, 0);
      if CoordView = 1 then
        PrintCoord(_Contours, FCS, MetaCanvas,DrawRect,1,FontDialog.Font,
          CoordMaxRows,LatinNumber,ShowLength,ShowAzimuth,ShowOnPoint,ShowInfo,ShowNeighbours,
          _Information, _Neighbours)
      else
        PrintCoord2(_Contours, FCS, MetaCanvas,DrawRect,1,FontDialog.Font,
          CoordMaxRows,LatinNumber,ShowLength,ShowAzimuth,ShowOnPoint,ShowInfo,ShowNeighbours,
          _Information, _Neighbours);
    end;
    //наносим стрелку
    if (CompassBox<>nil) and CompassBox.Visible then begin
      DrawRect:=Rect(Round(CompassBox.Left/Scale/ScrPixPerMM*PrnPixPerMMH),
        Round(CompassBox.Top/Scale/ScrPixPerMM*PrnPixPerMMV),0,0);
      PrintCompass(MetaCanvas,DrawRect,DegToRad(OtvodBox.Corner),PrnPixPerMMH);
    end;
    //наносим масштаб
    if (ScaleBox<>nil) and ScaleBox.Visible then begin
      DrawRect:=Rect(Round(ScaleBox.Left/Scale/ScrPixPerMM*PrnPixPerMMH),
        Round(ScaleBox.Top/Scale/ScrPixPerMM*PrnPixPerMMV),0,0);
      Draw.PrintScale(MetaCanvas,DrawRect,1,StrToInt(ScaleCombo.Text));
    end;
  finally
    MetaCanvas.Free;
  end;
end;

procedure TOtvodPrintForm.ScaleComboClick(Sender: TObject);
begin
  if Assigned(OtvodBox) then
  begin
    OtvodBox.Visible := False;
    OtvodBox.Visible := True;
  end;
  if Assigned(ScaleBox) then
  begin
    ScaleBox.Visible := False;
    ScaleBox.Visible := True;
  end;
end;

procedure TOtvodPrintForm.ScaleComboKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if (Key = 13) and (Shift = []) then
    ScaleComboClick(Sender);
end;

procedure TOtvodPrintForm.ExitBtnClick(Sender: TObject);
begin
  Close;
end;

procedure TOtvodPrintForm.OtvodItmClick(Sender: TObject);
begin
  OtvodBox.Visible := not OtvodBox.Visible;
end;

procedure TOtvodPrintForm.CoordItmClick(Sender: TObject);
begin
  CoordBox.Visible := not CoordBox.Visible;
end;

procedure TOtvodPrintForm.CompassItmClick(Sender: TObject);
begin
  CompassBox.Visible := not CompassBox.Visible;
end;

procedure TOtvodPrintForm.ScaleItmClick(Sender: TObject);
begin
  ScaleBox.Visible := not ScaleBox.Visible;
end;

procedure TOtvodPrintForm.ConfigMenuPopup(Sender: TObject);
begin
  OtvodItm.Enabled := OtvodBox <> nil;
  OtvodItm.Checked := (OtvodBox <> nil) and OtvodBox.Visible;
  CoordItm.Enabled := CoordBox <> nil;
  CoordItm.Checked := (CoordBox<>nil) and CoordBox.Visible;
  ScaleItm.Enabled := ScaleBox <> nil;
  ScaleItm.Checked := (ScaleBox <> nil) and ScaleBox.Visible;
  CompassItm.Enabled := CompassBox <> nil;
  CompassItm.Checked := (CompassBox <> nil) and CompassBox.Visible;
  NetItm.Enabled := OtvodItm.Enabled and OtvodItm.Checked;
end;

procedure TOtvodPrintForm.SaveBtnClick(Sender: TObject);
begin
  if SaveDialog.Execute then
    with CreateEndMetaFile do
      try
        SaveToFile(SaveDialog.FileName);
      finally
        Free;
      end;
end;

procedure TOtvodPrintForm.CoordConfigItmClick(Sender: TObject);
begin
  if ShowCoordProp(LatinNumber, ShowLength, ShowAzimuth, ShowOnPoint,
                   ShowInfo, ShowNeighbours, FontDialog.Font, CoordView) then
  begin
    if CoordBox <> nil then
    begin
      CoordBox.Visible := False;
      CoordBox.Visible := True;
    end;
    if OtvodBox <> nil then
    begin
      OtvodBox.Visible := False;
      OtvodBox.Visible := True;
    end;
  end;
end;

procedure TOtvodPrintForm.btnScaleAllClick(Sender: TObject);
begin
  PageScale := psAll;
end;

procedure TOtvodPrintForm.btnScaleWidthClick(Sender: TObject);
begin
  PageScale := psWidth;
end;

procedure TOtvodPrintForm.btnScale100Click(Sender: TObject);
begin
  PageScale := ps100;
end;

procedure TOtvodPrintForm.ScrollBoxResize(Sender: TObject);
begin
  ResizeControls;
end;

procedure TOtvodPrintForm.NetItmClick(Sender: TObject);
begin
  NetItm.Checked := not NetItm.Checked;
  OtvodBox.Visible := False;
  OtvodBox.Visible := True;
end;

procedure TOtvodPrintForm.tbToWordClick(Sender: TObject);
var
  DrawRect: TRect;
  list: TStringList;
  i: Integer;
  filename, oldStr, newStr, replace: OleVariant;
  bmp: TBitmap;
  Dir, wordfile, s: String;
  index: Variant;
begin
  Dir := GetCurrentDir;
  wordfile := GetNewFileName(AppModule.AppTempPath, 'word', 'doc');
  if not CopyFile(
           PChar(StringReplace(ReportName, '.rpt', '.doc', [rfIgnoreCase])),
           PChar(wordfile), False)
  then
  begin
    MessageDlg('Не удалось найти шаблон отчета!'#13#10'Сообщите администратору.', mtWarning, [mbOK], 0);
    exit;
  end;
  try
    word := CreateOLEObject('Word.Application');
  except
    on E: EOleError do
    begin
      MessageBox(Handle, PChar(S_DONT_START_WORD), PChar(S_WARN), MB_ICONWARNING);
      Exit;
    end;
    on E: EOleSysError do
    begin
      MessageBox(Handle, PChar(S_DONT_START_WORD), PChar(S_WARN), MB_ICONWARNING);
      Exit;
    end;
    on E: EOleException do
    begin
      MessageBox(Handle, PChar(S_DONT_START_WORD), PChar(S_WARN), MB_ICONWARNING);
      Exit;
    end;
  end;
  try
    list := TStringList.Create;
    filename := OleVariant(wordfile);
    Word.Documents.Open(filename, EmptyParam, EmptyParam, EmptyParam, EmptyParam, EmptyParam, EmptyParam, EmptyParam, EmptyParam, EmptyParam);
    // Заполняем шаблон данными
    GetVarList(list);
    for i := 0 to List.Count - 1 do
    begin
      replace := 1;
      oldStr := '[' + AnsiLowerCase(list.Names[i]) + ']';
      newStr := list.Values[list.Names[i]];
      Word.ActiveDocument.Range.Find.Execute(oldStr, EmptyParam, EmptyParam, EmptyParam,
                                      EmptyParam, EmptyParam, EmptyParam,
                                      EmptyParam, EmptyParam, newStr, replace);
    end;
    GetObjList(list);
    for i := 0 to List.Count - 1 do
    begin
      // Рисуем в ворде координаты
      if List.Strings[i] = 'координаты' then
      begin
        bmp := TBitmap.Create;
        try
          bmp.PixelFormat := pf24bit;
          bmp.SetSize(CoordBox.Height, CoordBox.Width);

          DrawRect := Rect(0, 0, bmp.Width, bmp.Height);
          if CoordView = 1 then
            PrintCoord(_Contours, FCS, bmp.Canvas, DrawRect, 1, FontDialog.Font,
              CoordMaxRows, LatinNumber, ShowLength, ShowAzimuth, ShowOnPoint, ShowInfo, ShowNeighbours,
              _Information, _Neighbours)
          else
            PrintCoord2(_Contours, FCS, bmp.Canvas, DrawRect, 1, FontDialog.Font,
              CoordMaxRows, LatinNumber, ShowLength, ShowAzimuth, ShowOnPoint, ShowInfo, ShowNeighbours,
              _Information, _Neighbours);
          bmp.Width := DrawRect.Right;
          bmp.Height := DrawRect.Bottom;
          s := GetNewFileName(AppModule.AppTempPath, 'coord', 'bmp');
          bmp.SaveToFile(s);
        finally
          FreeAndNil(bmp);
        end;
        //
        filename := s;
        index := Word.ActiveDocument.Shapes.AddPicture(filename, EmptyParam, EmptyParam, EmptyParam);
      end;
      // Рисуем в ворде отвод
      if List.Strings[i] = 'отвод' then
      begin
        if bmp = nil then
        begin
          bmp := TBitmap.Create;
          bmp.PixelFormat := pf24bit;
        end;
        bmp.SetSize(OtvodBox.Width, OtvodBox.Height);

        if NetItm.Checked then
        begin
          NetCrossSize1 := 15;
          NetCrossSize2 := 25;
        end
        else
        begin
          NetCrossSize1 := 0;
          NetCrossSize2 := 0;
        end;
        with bmp do
        begin
          DrawRect := Rect(0, 0, Width, Height);
          PrintRegion(_Contours, Canvas, DrawRect, ScrPixPerMM, LatinNumber, 1,
                      StrToInt(ScaleCombo.Text), DegToRad(OtvodBox.Corner), True, NetCrossSize1);
        end;
        s := GetNewFileName(AppModule.AppTempPath, 'otvod', 'bmp');
        bmp.SaveToFile(s);
        FreeAndNil(bmp);
        filename := s;
        index := Word.ActiveDocument.Shapes.AddPicture(filename, EmptyParam, EmptyParam, EmptyParam);
      end;
      if List.Strings[i] = 'стрелка' then
      begin
        if bmp = nil then
        begin
          bmp := TBitmap.Create;
          bmp.PixelFormat := pf24bit;
        end;
        bmp.SetSize(CompassBox.Width, CompassBox.Height);

        with bmp do
        begin
          DrawRect := Rect(0, 0, Width,Height);
          PrintCompass(Canvas, DrawRect, DegToRad(OtvodBox.Corner), ScrPixPerMM * Scale);
          Width := DrawRect.Right;
          Height := DrawRect.Bottom;
        end;
        s := GetNewFileName(AppModule.AppTempPath, 'compas', 'bmp');
        bmp.SaveToFile(s);
        FreeAndNil(bmp);
        filename := s;
        index := Word.ActiveDocument.Shapes.AddPicture(filename, EmptyParam, EmptyParam, EmptyParam);
      end;
      // Рисуем в ворде масштаб
      if List.Strings[i] = 'масштаб' then
      begin
        if bmp = nil then
        begin
          bmp := TBitmap.Create;
          bmp.PixelFormat := pf24bit;
        end;
        bmp.SetSize(ScaleBox.Width, ScaleBox.Height);

        with bmp do
        begin
          DrawRect:=Rect(0, 0, Width, Height);
          Draw.PrintScale(Canvas, DrawRect, 1, StrToInt(ScaleCombo.Text));
          Width := DrawRect.Right;
          Height := DrawRect.Bottom;
        end;
        s := GetNewFileName(AppModule.AppTempPath, 'scale', 'bmp');
        bmp.SaveToFile(s);
        FreeAndNil(bmp);
        filename := s;
        index := Word.ActiveDocument.Shapes.AddPicture(filename, EmptyParam, EmptyParam, EmptyParam);
      end;
    end;
    Word.Visible := True;
  finally
    list.Free;
    CloseWord;
    SetCurrentDir(Dir);
  end;
end;

procedure TOtvodPrintForm.sbVisioClick(Sender: TObject);
var
  filename, VisioDoc: OleVariant;
  Dir: String;
  S: AnsiString;
  ErrInfo: TStringList;
begin
  ErrInfo := IStringList(TStringList.Create).StringList;
  Dir := GetCurrentDir;
  with CreateEndMetaFile do
    try
      S := GetNewFileName(AppModule.AppTempPath, 'visio', 'emf');
      SaveToFile(S);
    finally
      Free;
    end;
  try
    Visio := CreateOLEObject('Visio.Application');
  except
    on E: Exception  do
    begin
      MessageBox(Handle, PChar(S_DONT_START_VISIO), PChar(S_WARN), MB_ICONWARNING);
      ErrInfo.Add('Ошибка при создании COM-объекта Visio.Application');
      AppModule.LogException(E, ErrInfo.Clone());
      exit;
    end;
  end;
  try
    filename := S;
    try
      Visio.Documents.Open(filename);
    except
      on E: Exception do
      begin
        MessageBox(Handle, PChar(Format(S_CANT_OPEN_FILE, [S])), PChar(S_WARN), MB_ICONWARNING);
        ErrInfo.Add('Ошибка при открытии файла COM-объектом Visio.Documents');
        ErrInfo.Add('Файл: ' + S);
        AppModule.LogException(E, ErrInfo.Clone());
//        exit;
      end;
    end;
    try
      VisioDoc := Visio.ActiveDocument;
      if not VarIsEmpty(VisioDoc) then
        if VisioDoc.Pages.Count > 0 then
          if VisioDoc.Pages[1].Shapes.Count > 0 then
            VisioDoc.Pages[1].Shapes[1].Ungroup;
    except
      on E: Exception do
      begin
        MessageBox(Handle, PChar(Format(S_CANT_CHANGE_FILE, [filename])), PChar(S_WARN), MB_ICONWARNING);
        ErrInfo.Add('Ошибка при обращении к COM-объекту Visio.ActiveDocument.Pages[1].Shapes[1].Ungroup');
        AppModule.LogException(E, ErrInfo.Clone());
        exit;
      end;
    end;
  finally
    CloseVisio;
    SetCurrentDir(Dir);
  end;
end;

procedure TOtvodPrintForm.LabelsItmClick(Sender: TObject);
begin
  LabelsItm.Checked := not LabelsItm.Checked;
  OtvodBox.Visible := False;
  OtvodBox.Visible := True;
end;

procedure TOtvodPrintForm.PrintToPrinter;
var
  PrintFile: TMetaFile;
begin
  PrintFile := CreateEndMetafile;
  with Printer do
    try
      Title := S_LOT;
      BeginDoc;
      Canvas.Draw(0, 0, PrintFile);
    finally
      EndDoc;
      PrintFile.Free;
    end;
end;

procedure TOtvodPrintForm.ScaleComboExit(Sender: TObject);
var
  I: Integer;
begin
  if (Trim(ScaleCombo.Text) = '') or (TryStrToInt(Trim(ScaleCombo.Text), I) and (I = 0)) then
    ScaleCombo.Text := '500';
end;

procedure TOtvodPrintForm.LineLabelsItmClick(Sender: TObject);
begin
  LineLabelsItm.Checked := not LineLabelsItm.Checked;
  OtvodBox.Visible := False;
  OtvodBox.Visible := True;
end;

end.


