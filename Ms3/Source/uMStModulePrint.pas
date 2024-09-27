unit uMStModulePrint;

interface

uses
  SysUtils, Classes, Printers, Contnrs, Windows, Graphics, Dialogs, Controls,
  ComCtrls, DB, XMLDoc, XMLIntf, Forms, Math,
  //
  EzBaseGIS, EzLib, EzMiscelEntities,
  //
  uGC,
  //
  uMStKernelClasses, uMStKernelInterfaces,
  uMStDialogLines, uMStDialogPrint,
  uMStClassesLots;

type
  TmstPage = class(TmstObject)
  private
    FVisible: Boolean;
    FEntityID: Integer;
    FNumber: Integer;
    FShowNumber: Boolean;
    procedure SetVisible(const Value: Boolean);
    function GetPageRect: TEzRect;
    procedure SetNumber(const Value: Integer);
    procedure SetShowNumber(const Value: Boolean);
  public
    function CreatePageEntity(const aRect: TEzRect): TEzEntity;
    procedure UpdateEntity;
    property EntityID: Integer read FEntityID write FEntityID;
    property Number: Integer read FNumber write SetNumber;
    property PageRect: TEzRect read GetPageRect;
    property ShowNumber: Boolean read FShowNumber write SetShowNumber;
    property Visible: Boolean read FVisible write SetVisible;
  end;

  TmstReportLine = class
  private
    FColor: Integer;
    FWidth: Double;
    procedure SetColor(const Value: Integer);
    procedure SetWidth(const Value: Double);
    function GetMapWidth(const Scale: Double): Double;
  public
    property Width: Double read FWidth write SetWidth; // in mms
    property Color: Integer read FColor write SetColor;
    property MapWidth[const Scale: Double]: Double read GetMapWidth; // in meters
  end;

  TmstReportLines = class
  private
    FLotLine: TmstReportLine;
    FActualLine: TmstReportLine;
    FAnnulledLine: TmstReportLine;
    FSelectedLine: TmstReportLine;
  public
    constructor Create;
    destructor Destroy; override;
    property ActualLine: TmstReportLine read FActualLine;
    property AnnulledLine: TmstReportLine read FAnnulledLine;
    property LotLine: TmstReportLine read FLotLine;
    property SelectedLine: TmstReportLine read FSelectedLine;
  end;

  TmstCoordTableSettings = class
  private
    FContourFont: TFont;
    FCellFont: TFont;
    FCaptionFont: TFont;
    procedure InitFont(aFont: TFont);
  public
    constructor Create;
    destructor Destroy; override;
    function Edit: Boolean;
    property CaptionFont: TFont read FCaptionFont write FCaptionFont;
    property CellFont: TFont read FCellFont write FCellFont;
    property ContourFont: TFont read FContourFont write FContourFont;
  end;

  TmstPrintModule = class(TDataModule)
    procedure DataModuleCreate(Sender: TObject);
    procedure DataModuleDestroy(Sender: TObject);
  private
    FReportScale: Integer;
    FCurrentPrinter: TPrinter;
    FPrintArea: TEzRect;
    FPages: TObjectList;
    FLotTexts: TList;
    FLotPoints: TList;
    FUserText: TList;
    FLot: TmstLot;
    FPrintAreaId: Integer;
    FShowPageNumbers: Boolean;
    FPointSize: Double;
    FFnt: TFont;
    FReportLines: TmstReportLines;
    FSelectedPage: Integer;
    FTableSettings: TmstCoordTableSettings;
    FTableWidthes: array[0..5] of Integer;
    FTableIndex: Integer;
    FWatermarkText: string;
    procedure SetReportScale(const Value: Integer);
    procedure SetCurrentPrinter(const Value: TPrinter);
    procedure SetPrintArea(const Value: TEzRect);
    procedure PrepareLayers;
    procedure PreparePages;
    procedure DeletePages;
    procedure SetLot(const Value: TmstLot);
    procedure SetPrintAreaId(const Value: Integer);
    procedure PrintPage(Index: Integer; Painter: TEzPainterObject;
      Grapher: TEzGrapher);
    function AddNewPage(const aRect: TEzRect; aNumber: Integer): TmstPage;
    procedure SetShowPageNumbers(const Value: Boolean);
    function GetPagesArea: TEzRect;
    procedure DeleteLotText;
    procedure CreateLotText;
    procedure CreateLotPoints;
    procedure DeleteLotPoints;
    procedure SetPointSize(const Value: Double);
    procedure SetFnt(const Value: TFont);
    procedure RecreateLotText(Index: Integer);
    procedure UpdatePoints;
    procedure SetSelectedPageId(const Value: Integer);
    function GetSelectedPageId: Integer;
    function GetSelectedPageObject: TmstPage;
    procedure AddReportTextObjects;
    procedure ReplaceVariables(Strings: TStrings);
    procedure CreateTable(const X0, Y0: Double; aRows: TStringList);
    procedure CalcTableColumnsWidth(Rows: TStringList);
    procedure FormatTableColumns(Table: TEzTableEntity);
    function CalcTableWidth(aTable: TEzTableEntity): Double;
    function GetRows: TStringList;
    procedure LoadTable(Table: TEzTableEntity; Rows: TStringList);
    procedure UpdateRTFText(oldScale: Integer);
    procedure AddWatermarks(aPage: TmstPage; const aWatermarkText: string);
    procedure AddWatermarkEntities(const aRect: TEzRect; aWatermarkText: string);
    function PrepareMemDataSet(): TDataSet;
    procedure SetWatermarkText(const Value: string);
    function GetPage(Index: Integer): TmstPage;
  public
    procedure DeleteTextObject(Layer: TEzBaseLayer; Recno: Integer);
    procedure DoEditTable;
    procedure DoPrintReport();
    procedure DoPageSetup;
    procedure DoPrinterSetup;
    procedure DoSelectFont(SelectedList: TList);
    procedure DoSelectLines;
    procedure DoSelectTable;
    function GetTextHeight: Double; // in meters
    function GetTextHeight2(FontHeight: Integer): Double; // in meters
    procedure PrepareReport;
    procedure SaveReport(const FileName: String);
    procedure SelectNextPage;
    procedure SelectPrevPage;
    procedure UnprepareReport;
    procedure UpdatePrintArea;
    //
    function HasLot(): Boolean;
    //
    function PageCount: Integer;
    property Pages[Index: Integer]: TmstPage read GetPage;
    //
    property CurrentPrinter: TPrinter read FCurrentPrinter write SetCurrentPrinter;
    property Font: TFont read FFnt write SetFnt;
    property Lot: TmstLot read FLot write SetLot;
    property PagesArea: TEzRect read GetPagesArea;
    property PointSize: Double read FPointSize write SetPointSize; // in mms
    property PrintArea: TEzRect read FPrintArea write SetPrintArea;
    property PrintAreaId: Integer read FPrintAreaId write SetPrintAreaId;
    property ReportLines: TmstReportLines read FReportLines;
    property ReportScale: Integer read FReportScale write SetReportScale;
    property SelectedPage: Integer read FSelectedPage;
    property SelectedPageObject: TmstPage read GetSelectedPageObject;
    property SelectedPageId: Integer read GetSelectedPageId write SetSelectedPageId;
    property ShowPageNumbers: Boolean read FShowPageNumbers write SetShowPageNumbers;
    property WatermarkText: string read FWatermarkText write SetWatermarkText;
  end;

var
  mstPrintModule: TmstPrintModule;

implementation

{$R *.dfm}

uses
  JvMemoryDataset,
  EzBase, EzEntities,
  uCommonUtils, 
  uMStModuleApp, uMStKernelConsts, uMstKernelGISUtils,
  uMStFormMain, uMStFormCoordTableSettingsEditor, uMStFormReportTable;

{ TmstPrintModule }

procedure TmstPrintModule.PrepareReport;
begin
  PrepareLayers;
  FPrintArea := INVALID_EXTENSION;
end;

procedure TmstPrintModule.SetPrintArea(const Value: TEzRect);
var
  NeedAddObj: Boolean;
  PagesLayer: TEzBaseLayer;
begin
  NeedAddObj := EqualRect2D(FPrintArea, INVALID_EXTENSION);
  FPrintArea := Value;
  PreparePages;
  mstClientAppModule.GIS.RepaintViewports;
  if NeedAddObj and Assigned(FLot) then
  begin
    AddReportTextObjects;
    PagesLayer := mstClientAppModule.GIS.Layers.LayerByName(SL_PAGES);
    PagesLayer.Recno := TmstPage(FPages[0]).EntityID;
    with PagesLayer.RecEntity.FBox do
      CreateTable(xmax, ymax, GetRows);
  end;
end;

procedure TmstPrintModule.SetCurrentPrinter(const Value: TPrinter);
begin
  FCurrentPrinter := Value;
end;

procedure TmstPrintModule.SetReportScale(const Value: Integer);
var
  Old: Integer;
begin
  Old := FReportScale;
  FReportScale := Value;
  DeletePages;
  PreparePages;
  DeleteLotText;
  CreateLotText;
  DeleteLotPoints;
  CreateLotPoints;
  UpdateRTFText(Old);
end;

procedure TmstPrintModule.UnprepareReport;
var
  I: Integer;
begin
  FPages.Clear;
  FLotTexts.Clear;
  FLotPoints.Clear;
  with mstClientAppModule do
  begin
    I := Layers.IndexOfName(SL_REPORT);
    if I >= 0 then
      Layers.Delete(I);
    I := Layers.IndexOfName(SL_PAGES);
    if I >= 0 then
      Layers.Delete(I);
    I := Layers.IndexOfName(SL_WATERMARKS);
    if I >= 0 then
      Layers.Delete(I);
  end;
  FPrintAreaId := -1;
  FPrintArea := INVALID_EXTENSION;
  FTableIndex := 0;
end;

procedure TmstPrintModule.DataModuleCreate(Sender: TObject);
begin
  FPages := TObjectList.Create;
  FPrintAreaId := -1;
  FCurrentPrinter := Printer;
  FreportScale := 500;
  FShowPageNumbers := True;
  FLotTexts := TList.Create;
  FLotPoints := TList.Create;
  FUserText := TList.Create;
  FPointSize := 1;
  FFnt := TFont.Create;
  FFnt.Name := 'Times New Roman';
  FFnt.Size := 14;
  fFnt.Charset := RUSSIAN_CHARSET;
  FReportLines := TmstReportLines.Create;
  FSelectedPage := -1;
  FTableSettings := TmstCoordTableSettings.Create;
end;

procedure TmstPrintModule.DataModuleDestroy(Sender: TObject);
begin
  FUserText.Free;
  FTableSettings.Free;
  FLotPoints.Free;
  FLotTexts.Free;
  FPages.Free;
  FFnt.Free;
  FReportLines.Free;
end;

function TmstPrintModule.PageCount: Integer;
begin
  Result := FPages.Count;
end;

procedure TmstPrintModule.PrepareLayers;
var
  Layer: TmstLayer;
begin
  Layer := TmstLayer.Create;
  with Layer do
  begin
    Caption := 'Страницы';
    Name := SL_PAGES;
    LayerType := ID_LT_MEMORY;
    Visible := True;
  end;
  mstClientAppModule.Layers.Add(Layer);
  mstClientAppModule.ConnectLayerToGIS(Layer, True);
  //
  Layer := TmstLayer.Create;
  with Layer do
  begin
    Caption := 'Отчет';
    Name := SL_REPORT;
    LayerType := ID_LT_MEMORY;
    Visible := True;
  end;
  mstClientAppModule.Layers.Add(Layer);
  mstClientAppModule.ConnectLayerToGIS(Layer, True);
  //
  Layer := TmstLayer.Create;
  with Layer do
  begin
    Caption := 'Отметки';
    Name := SL_WATERMARKS;
    LayerType := ID_LT_MEMORY;
    Visible := True;
    Hidden := True;
    Position := 0;
  end;
  mstClientAppModule.Layers.Add(Layer);
  mstClientAppModule.ConnectLayerToGIS(Layer, True);
end;

function TmstPrintModule.PrepareMemDataSet: TDataSet;
var
  M: TJvMemoryData;
  aTable: TEzTableEntity;
  Layer: TEzBaseLayer;
  I, J: Integer;
begin
  M := TJvMemoryData.Create(Self);
  // готовим датасет
  M.FieldDefs.Add('№ точки', ftString, 50);
  M.FieldDefs.Add('X', ftString, 50);
  M.FieldDefs.Add('Y', ftString, 50);
  M.FieldDefs.Add('Длина, м', ftString, 50);
  M.FieldDefs.Add('Азимут', ftString, 50);
  M.FieldDefs.Add('На точку', ftString, 50);
  // грузим в него данные из таблицы
  M.Active := True;
  Layer := mstClientAppModule.GIS.Layers.LayerByName(SL_REPORT);
  aTable := TEzTableEntity(Layer.LoadEntityWithRecNo(FTableIndex));
  try
  for I := 0 to Pred(aTable.RowCount) do
  begin
    M.Append;
    for J := 0 to Pred(aTable.Columns.Count) do
      M.Fields[J].AsString := aTable.Columns[J].Strings[I];
    M.Post;
  end;
  finally
    aTable.Free;
  end;
  //
  Result := M;
end;

procedure TmstPrintModule.PreparePages;
var
  aRect: TEzRect;
  H, W: Double;
  I: Integer;
  aPage: TmstPage;
begin
  FSelectedPage := -1;
  DeletePages;
  // берем физический рамер страницы с принтера
  // переводим его в размер карты
  aRect := GetPageRectWithoutMargins2;
  H := aRect.ymax - aRect.ymin;
  W := aRect.xmax - aRect.xmin;
  H := H / 1000 * Self.ReportScale;
  W := W / 1000 * Self.ReportScale;
  aRect := Rect2D(PrintArea.xmin, PrintArea.ymax - H, PrintArea.xmin + W, PrintArea.ymax);
  // теперь покрываем страницами всю область печати
  I := 0;
  repeat
    repeat
      Inc(I);
      aPage := AddNewPage(aRect, I);
      AddWatermarks(aPage, FWatermarkText);
      MoveRect2D(aRect, W, 0);
    until aRect.xmin > PrintArea.xmax;
    MoveRect2D(aRect, 0, -H);
    aRect.xmin := PrintArea.xmin;
    aRect.xmax := aRect.xmin + W;
  until aRect.ymax < PrintArea.ymin;
end;

procedure TmstPrintModule.SetLot(const Value: TmstLot);
begin
  FLot := Value;
  DeleteLotText;
  CreateLotText;
  DeleteLotPoints;
  CreateLotPoints;
end;

procedure TmstPrintModule.SetPrintAreaId(const Value: Integer);
begin
  FPrintAreaId := Value;
end;

procedure TmstPrintModule.DoPrintReport();
var
  PrnGrapher: TEzGrapher;
  Painter: TEzPainterObject;
  I, PagesPrinted: Integer;
  Copies: SmallInt;
begin
  PagesPrinted := 0;
  Copies := CurrentPrinter.Copies;
  if ShowPrintDialog(Copies, CurrentPrinter.Printers[CurrentPrinter.PrinterIndex]) then
  begin
    CurrentPrinter.Copies := Copies;
    CurrentPrinter.BeginDoc;
    CurrentPrinter.Title := 'Plan from ' + GetIP + ' ';
    CurrentPrinter.Canvas.Font.Charset := RUSSIAN_CHARSET;
    try
      PrnGrapher := TEzGrapher.Create(1, adPrinter);
      Painter := TEzPainterObject.Create(nil);
      try
        for I := 0 to Pred(FPages.Count) do
        if TmstPage(FPages[I]).Visible then
        begin
          if PagesPrinted > 0 then
            CurrentPrinter.NewPage;
          PrintPage(I, Painter, PrnGrapher);
          Inc(PagesPrinted);
        end;
      finally
        Painter.Free;
        PrnGrapher.Free;
      end;
    finally
      CurrentPrinter.EndDoc;
      CurrentPrinter.Copies := 1;
    end;
  end;
end;

procedure TmstPrintModule.CreateTable(const X0, Y0: Double; aRows: TStringList);
var
  Tbl: TEzTableEntity;
  H, W: Double;
  TblGridStyle: TEzTableBorderStyle;
  CaptionHeight, CellHeight: Double;
  layer: TEzBaseLayer;
begin
  {все размеры в мм}
  CaptionHeight := GetTextHeight2(FTableSettings.CaptionFont.Height) + 4;
  CellHeight := GetTextHeight2(FTableSettings.CellFont.Height);
  H := CaptionHeight {высота шапки} + aRows.Count * CellHeight {высота строчки};
  H := H - 1;
  Tbl := IEntity(
         TEzTableEntity.CreateEntity(
           Point2D(X0, Y0),
           Point2D(X0 + H, Y0 - H))
       ).Entity as TEzTableEntity;
  CalcTableColumnsWidth(aRows);
  FormatTableColumns(Tbl);
  W := CalcTableWidth(Tbl);
  Tbl := IEntity(
           TEzTableEntity.CreateEntity(
             Point2D(X0, Y0),
             Point2D(X0 + W, Y0 - H))
         ).Entity as TEzTableEntity;
  Tbl.BrushTool.ForeColor := clRed;
  Tbl.BrushTool.BackColor := clBlack;
  Tbl.BrushTool.Pattern := 1;
  TblGridStyle.Visible := True;
  TblGridStyle.Style := 1;
  TblGridStyle.Color := clBlack;
  TblGridStyle.Width := 0.1;
  FormatTableColumns(Tbl);
  with Tbl do
  begin
    GridStyle := TblGridStyle;
    LoweredColor := clBlack;
    DefaultDrawing := True;
    Options := [ezgoVertLine, ezgoHorzLine];
    RowCount := aRows.Count;
    TitleHeight := CaptionHeight;
    BorderWidth := 0.1;
    RowHeight := CellHeight;
  end;
  LoadTable(Tbl, aRows);
  Layer := mstClientAppModule.GIS.Layers.LayerByName(SL_REPORT);
  FTableIndex := Layer.AddEntity(Tbl);
end;

procedure TmstPrintModule.LoadTable(Table: TEzTableEntity; Rows: TStringList);
var
  I, J: Integer;
  Tmp: TStringList;
  S: String;
begin
  Tmp := IStringList(TStringList.Create).StringList;
  for I := 0 to Pred(Rows.Count) do
  begin
    Tmp.Clear;
    S := Rows[I];
    J := Pos(#9, S);
    while J > 0 do
    begin
      Tmp.Add(Copy(S, 1, Pred(J)));
      Delete(S, 1, J);
      J := Pos(#9, S);
    end;
    Tmp.Add(S);
    for J := 0 to Pred(Tmp.Count) do
     Table.Columns[J].Strings[I] := Tmp[J];
  end;
end;

function TmstPrintModule.CalcTableWidth(aTable: TEzTableEntity): Double;
var
  I: Integer;
begin
  Result := 0;
  for I := 0 to Pred(aTable.Columns.Count) do
    Result := Result + aTable.Columns[I].Width;
end;

procedure TmstPrintModule.FormatTableColumns(Table: TEzTableEntity);
var
  TitleFont, ColumnFont: TEzFontStyle;

  procedure AddColumn(const aCaption: String; const aWidthInMMs: Double);
  begin
    with Table.Columns.Add do
    begin
      with Title do
      begin
        Caption := aCaption;
        Alignment := taCenter;
        Transparent := False;
        Font := TitleFont;
      end;
      Width := aWidthInMMs;
      Alignment := taCenter;
      Transparent := False;
      Font := ColumnFont;
    end;
  end;

var
  K: Double;
begin
  with TitleFont, FTableSettings do
  begin
    Name := CaptionFont.Name;
    Height := GetTextHeight2(CaptionFont.Height);
    Color := CaptionFont.Color;
    Style := CaptionFont.Style;
  end;
  with ColumnFont, FTableSettings do
  begin
    Name := CellFont.Name;
    Height := GettextHeight2(CellFont.Height);
    Color := CellFont.Color;
    Style := CellFont.Style;
  end;
  K := mstClientMainForm.PixelsPerInch / 25.4;
  AddColumn('№ точки', (FTableWidthes[0] / K + 4) / 1000 * ReportScale);
  AddColumn('X', (FTableWidthes[1] / K + 4) / 1000 * ReportScale);
  AddColumn('Y', (FTableWidthes[2] / K + 4) / 1000 * ReportScale);
  AddColumn('Длина, м', (FTableWidthes[3] / K + 4) / 1000 * ReportScale);
  AddColumn('Азимут', (FTableWidthes[4] / K + 4) / 1000 * ReportScale);
  AddColumn('На точку', (FTableWidthes[5] / K + 4) / 1000 * ReportScale);
end;

procedure TmstPrintModule.CalcTableColumnsWidth(Rows: TStringList);
var
  I, W, J: Integer;
  S: String;
  OldFont: TFont;
  Tmp: TStringList;
begin
  OldFont := TFont(IObject(TFont.Create).AObject);
  OldFont.Assign(FFnt);
  try
    with mstClientMainForm.DrawBox.Canvas do
    begin
      Font.Assign(FTableSettings.FCaptionFont);
      FTableWidthes[0] := TextWidth('№ точки');
      FTableWidthes[1] := TextWidth('X');
      FTableWidthes[2] := TextWidth('Y');
      FTableWidthes[3] := TextWidth('Длина, м');
      FTableWidthes[4] := TextWidth('Азимут');
      FTableWidthes[5] := TextWidth('На точку');
      Font.Assign(FTableSettings.FCellFont);
    end;
    Tmp := IStringList(TStringList.Create).StringList;
    for I := 0 to Pred(Rows.Count) do
    begin
      Tmp.Clear;
      S := Rows[I];
      J := Pos(#9, S);
      while J > 0 do
      begin
        Tmp.Add(Copy(S, 1, Pred(J)));
        Delete(S, 1, J);
        J := Pos(#9, S);
      end;
      Tmp.Add(S);
      for J := 0 to Pred(Tmp.Count) do
      begin
        S := Tmp[J];
        if S <> '' then
        begin
          W := mstClientMainForm.DrawBox.Canvas.TextWidth(S);
          FTableWidthes[J] := IMax(W, FTableWidthes[J]);
        end;
      end;
    end;
  finally
    mstClientMainForm.DrawBox.Canvas.Font.Assign(OldFont);
  end;
end;

procedure TmstPrintModule.PrintPage(Index: Integer; Painter: TEzPainterObject; Grapher: TEzGrapher);
var
  PageRect: TEzRect;
begin
  PageRect := TmstPage(FPages[Index]).PageRect;
  with GetPageRectWithoutMargins do
    Grapher.SetViewport(xmin, ymin, xmax, ymax);
  Grapher.SetWindow(PageRect.xmin, PageRect.xmax, PageRect.ymax, PageRect.ymin);
  Painter.DrawEntities(PageRect,
                       mstClientAppModule.GIS,
                       CurrentPrinter.Canvas,
                       Grapher,
                       nil,
                       False,
                       False,
                       pmAll,
                       nil);
end;

function TmstPrintModule.AddNewPage(const aRect: TEzRect;
  aNumber: Integer): TmstPage;
var
  Page: TmstPage;
  Layer: TEzBaseLayer;
  PageEnt: TEzPageEntity;
begin
  Page := TmstPage.Create;
  Page.Visible := True;
  Page.Number := aNumber;
  Page.ShowNumber := Self.ShowPageNumbers;
  Layer := mstClientAppModule.GIS.Layers.LayerByName(SL_PAGES);
  if Assigned(Layer) then
  begin
    PageEnt := TEzPageEntity(Page.CreatePageEntity(aRect));
    PageEnt.ShowNumber := FShowPageNumbers;
    Page.EntityID := Layer.AddEntity(PageEnt);
  end;
  FPages.Add(Page);
  Result := Page;
end;

procedure TmstPrintModule.SetShowPageNumbers(const Value: Boolean);
var
  I: Integer;
begin
  FShowPageNumbers := Value;
  for I := 0 to Pred(FPages.Count) do
  begin
    TmstPage(FPages[I]).UpdateEntity;
  end;
end;

procedure TmstPrintModule.SetWatermarkText(const Value: string);
begin
  FWatermarkText := Value;
end;

procedure TmstPrintModule.DoPrinterSetup;
begin
  // показывам диалог
  with TPrinterSetupDialog.Create(Self) do
  try
    if Execute then
    begin
      // если пользователь подтвердил, то
      FCurrentPrinter := Printer;
      // удаляем все страницы и создаем их заново
      DeletePages;
      PreparePages;
    end;
  finally
    Free;
  end;
  mstClientAppModule.GIS.RepaintViewports;
end;

procedure TmstPrintModule.DoPageSetup;
begin
  // показывам диалог
  with TPageSetupDialog.Create(Self) do
  try
    if Execute then
    begin
      // если пользователь подтвердил, то
      FCurrentPrinter := Printer;
      // удаляем все страницы и создаем их заново
      DeletePages;
      PreparePages;
    end;
  finally
    Free;
  end;
  mstClientAppModule.GIS.RepaintViewports;
end;

procedure TmstPrintModule.DeletePages;
var
  I: Integer;
  Layer: TEzBaselayer;
begin
  Layer := mstClientAppModule.GIS.Layers.LayerByName(SL_PAGES);
  if Assigned(Layer) then
    for I := 0 to Pred(FPages.Count) do
    begin
      if TmstPage(FPages[I]).EntityID > 0 then
        Layer.DeleteEntity(TmstPage(FPages[I]).EntityID);
    end;
  FPages.Clear;
end;

function TmstPrintModule.GetPage(Index: Integer): TmstPage;
begin
  Result := FPages[index] as TmstPage;
end;

function TmstPrintModule.GetPagesArea: TEzRect;
var
  I: Integer;
begin
  Result := INVALID_EXTENSION;
  if FPages.Count = 0 then
    Exit;
  Result := TmstPage(FPages[0]).PageRect;
  for I := 1 to Pred(FPages.Count) do
    Result := UnionRect2D(Result, TmstPage(FPages[I]).PageRect);
end;

procedure TmstPrintModule.CreateLotText;
var
  I, K: Integer;
  H: Double;
  EntList: TEzEntityList;
  Layer: TEzBaseLayer;
begin
  if Assigned(FLot) then
  begin
    Layer := mstClientAppModule.GIS.Layers.LayerByName(SL_REPORT);
    H := GetTextHeight;
    if Assigned(Layer) then
      for I := 0 to Pred(Flot.Contours.Count) do
        if FLot.Contours[I].Enabled and FLot.Contours[I].PointsLoaded then
        begin
          EntList := TEzEntityList.Create;
          try
            AddPointsLabels(EntList, FLot.Contours[I], H);
            for K := 0 to Pred(EntList.Count) do
              FLotTexts.Add(Pointer(Layer.AddEntity(EntList[K])));
          finally
            EntList.Free;
          end;
        end;
  end;
end;

procedure TmstPrintModule.DeleteLotText;
var
  Layer: TEzBaseLayer;
  I, Recno: Integer;
begin
  Layer := mstClientAppModule.GIS.Layers.LayerByName(SL_REPORT);
  if Assigned(Layer) then
  for I := 0 to Pred(FLotTexts.Count) do
  begin
    Recno := Integer(FLotTexts.Items[I]);
    if Recno > 0 then
      Layer.DeleteEntity(Recno);
  end;
  FLotTexts.Clear;
end;

procedure TmstPrintModule.SetPointSize(const Value: Double);
begin
  FPointSize := Value;
  UpdatePoints;
end;

procedure TmstPrintModule.SetFnt(const Value: TFont);
begin
  if FFnt <> Value then
  begin
    if Assigned(FFnt) then
      FFnt.Free;
    FFnt := Value;
  end;
end;

procedure TmstPrintModule.DoSelectFont(SelectedList: TList);
var
  I, J, K: Integer;
begin
  with TFontDialog.Create(Self) do
  try
    if Execute then
    begin
      Self.Font := Font;
      if Assigned(SelectedList) then
        for I := 0 to Pred(SelectedList.Count) do
        begin
          J := Integer(SelectedList[I]);
          K := FLotTexts.IndexOf(Pointer(J));
          if K >= 0 then
            RecreateLotText(K);
        end;
    end;
  finally
    Free;
  end;
end;

procedure TmstPrintModule.RecreateLotText(Index: Integer);
var
  Layer: TEzBaseLayer;
  aText: TEzTrueTypeText;
begin
  Layer := mstClientAppModule.GIS.Layers.LayerByName(SL_REPORT);
  if Assigned(Layer) then
  begin
    Layer.Recno := Integer(FLotTexts[Index]);
    if Layer.RecEntityID = idTrueTypeText then
    begin
      aText := TEzTrueTypeText(Layer.RecEntity);
      aText.FontTool.Height := GetTextHeight;
      aText.UpdateExtension;
    end;
  end;
end;

function TmstPrintModule.GetTextHeight: Double;
begin
  Result := Abs(FFnt.Height) / Ffnt.PixelsPerInch * 25.4 * ReportScale / 1000;
end;

procedure TmstPrintModule.DoSelectLines;
begin
  with TmstDialogLines.Create(Self) do
  try
    // в окно грузим параметры
    edSelectedWidth.Text := Format('%8.2f', [FReportLines.SelectedLine.Width]);
    shSelectedColor.Brush.Color := FReportLines.SelectedLine.Color;
    edLotsWidth.Text := Format('%8.2f', [FReportLines.LotLine.Width]);
    shLotsColor.Brush.Color := FReportLines.LotLine.Color;
    edActualWidth.Text := Format('%8.2f', [FReportLines.ActualLine.Width]);
    shActualColor.Brush.Color := FReportLines.ActualLine.Color;
    edAnnulWidth.Text := Format('%8.2f', [FReportLines.AnnulledLine.Width]);
    shAnnulColor.Brush.Color := FReportLines.AnnulledLine.Color;
    // показываем окно
    if ShowModal = mrOK then
    begin
    // из окна грузим параметры
      FReportLines.SelectedLine.Width := StrToFloat(edSelectedWidth.Text);
      FReportLines.SelectedLine.Color := shSelectedColor.Brush.Color;
      FReportLines.ActualLine.Width := StrToFloat(edActualWidth.Text);
      FReportLines.ActualLine.Color := shActualColor.Brush.Color;
      FReportLines.AnnulledLine.Width := StrToFloat(edAnnulWidth.Text);
      FReportLines.AnnulledLine.Color := shAnnulColor.Brush.Color;
      FReportLines.LotLine.Width := StrToFloat(edLotsWidth.Text);
      FReportLines.LotLine.Color := shLotsColor.Brush.Color;
    end;
  finally
    Free;
  end;
end;

procedure TmstPrintModule.UpdatePoints;
begin
  DeleteLotPoints;
  CreateLotPoints;
end;

procedure TmstPrintModule.CreateLotPoints;
var
  I, K: Integer;
  EntList: TEzEntityList;
  Layer: TEzBaseLayer;
begin
  if Assigned(FLot) then
  begin
    Layer := mstClientAppModule.GIS.Layers.LayerByName(SL_REPORT);
    if Assigned(Layer) then
      for I := 0 to Pred(Flot.Contours.Count) do
        if FLot.Contours[I].Enabled and FLot.Contours[I].PointsLoaded then
        begin
          EntList := TEzEntityList.Create;
          try
            AddPointsToLot(EntList, FLot.Contours[I], FPointSize * FReportScale / 1000);
            for K := 0 to Pred(EntList.Count) do
              FLotPoints.Add(Pointer(Layer.AddEntity(EntList[K])));
          finally
            EntList.Free;
          end;
        end;
  end;
end;

procedure TmstPrintModule.DeleteLotPoints;
var
  Layer: TEzBaseLayer;
  I, Recno: Integer;
begin
  Layer := mstClientAppModule.GIS.Layers.LayerByName(SL_REPORT);
  if Assigned(Layer) then
  for I := 0 to Pred(FLotPoints.Count) do
  begin
    Recno := Integer(FLotPoints.Items[I]);
    if Recno > 0 then
      Layer.DeleteEntity(Recno);
  end;
  FLotPoints.Clear;
end;

procedure TmstPrintModule.UpdatePrintArea;
var
  Layer: TEzBaseLayer;
begin
  if FPrintAreaId > 0 then
  begin
    Layer := mstClientAppModule.GIS.Layers.LayerByName(SL_REPORT);
    if Assigned(Layer) then
    begin
      Layer.Recno := FPrintAreaId;
      Self.PrintArea := Layer.RecExtension;
    end;
  end;
end;

procedure TmstPrintModule.SetSelectedPageId(const Value: Integer);
var
  I: Integer;
begin
  FSelectedPage := -1;
  for I := 0 to Pred(FPages.Count) do
    if TmstPage(FPages[I]).EntityID = Value then
    begin
      FSelectedPage := I;
      Exit;
    end;
end;

procedure TmstPrintModule.SaveReport(const FileName: String);
var
  Doc: IXMLDocument;
begin
  Doc := TXMLDocument.Create(Application);
  try
//    Doc
//    FReportScale: Integer;
//    FCurrentPrinter: TPrinter;
//    FPrintArea: TEzRect;
//    FPages: TObjectList;
//    FLotTexts: TList;
//    FLotPoints: TList;
//    FUserText: TList;
//    FLot: TmstLot;
//    FPrintAreaId: Integer;
//    FShowPageNumbers: Boolean;
//    FPointSize: Double;
//    FFnt: TFont;
//    FReportLines: TmstReportLines;
//    FSelectedPage: Integer;
//    FTableSettings: TmstCoordTableSettings;
//    FTableWidthes: array[0..5] of Integer;
//    FTableIndex: Integer;
  finally
    Doc := nil;
  end;
end;

procedure TmstPrintModule.SelectNextPage;
begin

end;

procedure TmstPrintModule.SelectPrevPage;
begin

end;

function TmstPrintModule.GetSelectedPageId: Integer;
begin
  Result := -1;
  if FSelectedPage < 0 then
    Exit;
  Result := TmstPage(FPages[FSelectedPage]).EntityID;
end;

function TmstPrintModule.GetSelectedPageObject: TmstPage;
begin
  if FSelectedPage >= 0 then
    Result := TmstPage(FPages[FSelectedPage])
  else
    Result := nil;
end;

procedure TmstPrintModule.DeleteTextObject(Layer: TEzBaseLayer; Recno: Integer);
var
  I: Integer;
begin
  if Assigned(Layer) and (Layer.Name = SL_REPORT) then
  begin
    I := FLotTexts.IndexOf(Pointer(Recno));
    if I >= 0 then
      FLotTexts.Delete(I)
    else
    begin
      I := FUserText.IndexOf(Pointer(Recno));
      if I >= 0 then
        FUserText.Delete(I);
    end;
  end;
end;

procedure TmstPrintModule.AddReportTextObjects;
var
  PagesLayer, ReportLayer: TEzBaseLayer;
  RTF: TEzRTFText;
  P1, P2: TEzPoint;
  Text: TStringList;
begin
  if FPages.Count = 0 then
    Exit;
  ReportLayer := mstClientAppModule.GIS.Layers.LayerByName(SL_REPORT);
  PagesLayer := mstClientAppModule.GIS.Layers.LayerByName(SL_PAGES);
  PagesLayer.Recno := TmstPage(FPages[0]).EntityID;
  with PagesLayer.RecEntity.FBox do
    P1 := Point2D(xmin, ymax);
  P2.x := P1.x + 180 / 1000 * ReportScale;
  P2.y := P1.y - 93 / 1000 * ReportScale;
  // грузим в текст данные из файла
  if FileExists(mstClientAppModule.SessionDir + 'header.rtf') then
  begin
    Text := TStringList.Create;
    try
      Text.LoadFromFile(mstClientAppModule.SessionDir + 'header.rtf');
      // заменяем текст
      ReplaceVariables(Text);
      // создаем объект
      RTF := TEzRtfText.CreateEntity(P1, P2, Text);
      // [kiosk]
      //RTF.SizeInMMs := Rect2D(0, 0, 180, 93);
      // добавляем объект в первую страницу
      ReportLayer.AddEntity(RTF);
    finally
      Text.Free;
    end;
  end;
  //
  if FileExists(mstClientAppModule.SessionDir + 'footer.rtf') then
  begin
    Text := TStringList.Create;
    try
      Text.LoadFromFile(mstClientAppModule.SessionDir + 'footer.rtf');
      ReplaceVariables(Text);
      with PagesLayer.RecEntity.FBox do
        P1 := Point2D(xmin, ymin);
      P2.x := P1.x + 180 / 1000 * ReportScale;
      P2.y := P1.y - 93 / 1000 * ReportScale;
      RTF := TEzRtfText.CreateEntity(P1, P2, Text);
      // [kiosk]
      //RTF.SizeInMMs := Rect2D(0, 0, 180, 93);
      ReportLayer.AddEntity(RTF);
    finally
      Text.Free;
    end;
  end;
  //
  if FileExists(mstClientAppModule.SessionDir + 'pz.rtf') then
  begin
    Text := TStringList.Create;
    try
      Text.LoadFromFile(mstClientAppModule.SessionDir + 'pz.rtf');
      ReplaceVariables(Text);
      with PagesLayer.RecEntity.FBox do
        P1 := Point2D(xmin + (xmax - xmin) / 2, ymin + (ymax - ymin) / 2);
      P2.x := P1.x + 130 / 1000 * ReportScale;
      P2.y := P1.y - 50 / 1000 * ReportScale;
      RTF := TEzRtfText.CreateEntity(P1, P2, Text);
      // [kiosk] RTF.SizeInMMs := Rect2D(0, 0, 130, 50);
      ReportLayer.AddEntity(RTF);
    finally
      Text.Free;
    end;
  end;
end;

procedure TmstPrintModule.AddWatermarkEntities(const aRect: TEzRect; aWatermarkText: string);
var
  aText, aText2: TEzAlignedText2;
  H, W, Wr, Hr, Wtxt, Htxt: Double;
  Xmin, Xmax, Ymin, Ymax: Double;
  Layer: TEzBaseLayer;
  X, Y, dX, dY: Double;
//  TextRect: TEzRect;
  B1, B2: Boolean;
begin
  if aWatermarkText = '' then
    aWatermarkText := 'Только для просмотра!';
  // добавляем текстовые объекты
  // страницу делим на 10 частей по максимальному размеру
  H := Abs(aRect.Emax.y - aRect.Emin.y) / 30;
  Wr := H * 3;
  Hr := Wr;
  repeat
    aText := TEzAlignedText2.CreateEntity(Point2D(0, 0), aWatermarkText, H, 0);
    aText.MaxMinExtents(Xmin, Ymin, Xmax, Ymax);
    aText.FontTool.Color := clSilver;
    W := Xmax - Xmin;
    if W > Wr then
    begin
      H := H / 2;
      aText.Free;
      aText := nil;
    end;
    if W < Wr / 2 then
    begin
      H := H + H / 5;
      aText.Free;
      aText := nil;
    end;
  until (W < Wr) and (W > Wr / 2);
  if Assigned(aText) then
  begin
    Layer := mstClientAppModule.GIS.Layers.LayerByName(SL_WATERMARKS);
    if Assigned(Layer) then
    begin
      // далее покрываем её квадратиками этого размера
      dX := Wr * Sign(aRect.Emax.x - aRect.Emin.x);
      dY := Hr * Sign(aRect.Emin.y - aRect.Emax.y);
      Wtxt := aText.FBox.Emax.x - aText.FBox.Emin.x;
      Htxt := aText.FBox.Emax.y - aText.FBox.Emin.y;
      //
      B1 := False;
      X := aRect.Emin.x;
      repeat
        B1 := not B1;
        B2 := B1;
        Y := aRect.Emax.y;
        repeat
          if B2 then
          begin
            aText2 := aText.Clone() as TEzAlignedText2;
            aText2.Transparent := True;
            aText2.BasePoint := Point2D(X + (dX - Wtxt) / 2, Y - (Htxt + dY) / 2);
            Layer.AddEntity(aText2, True);
          end;
          Y := Y + dY;
          B2 := not B2;
        until Y <= aRect.Emin.y;
        X := X + dX;
      until X >= aRect.Emax.x - dX;
    end;
  end;
end;

procedure TmstPrintModule.AddWatermarks(aPage: TmstPage; const aWatermarkText: string);
var
  PageLayer: TezBaseLayer;
  Page: TEzEntity;
  PageRect: TEzRect;
begin
  // добавляем текст по странице в шахматном порядке
  //
  PageLayer := mstClientAppModule.GIS.Layers.LayerByName(SL_PAGES);
  if Assigned(PageLayer) then
  begin
//    PageEnt := TEzPageEntity(Page.CreatePageEntity(aRect));
//    PageEnt.ShowNumber := FShowPageNumbers;
    Page := PageLayer.EntityWithRecno(aPage.EntityID);
    if Assigned(Page) then
    begin
      PageRect := Page.FBox;
      AddWatermarkEntities(PageRect, aWatermarkText);
    end;
  end;
end;

type
  TRichEditHelper =  class helper for TRichEdit
  public
    procedure Replace(const S1, S2: String);
  end;

{ TRichEditHelper }

procedure TRichEditHelper.Replace(const S1, S2: String);
var
  I: Integer;
begin
  I := 1;
  while I >= 0 do
  begin
    I := Self.FindText(S1, 0, Length(Self.Text), []);
    if I >= 0 then
    begin
      Self.SelStart := I;
      Self.SelLength := Length(S1);
      Self.SelText := S2;
    end;
  end;
end;

procedure TmstPrintModule.ReplaceVariables(Strings: TStrings);
var
  oldStr, newStr: String;
  RichEdit: TRichEdit;
  Lots: ILots;
  Stream: TStream;
begin
  RichEdit := TRichEdit.Create(Self);
  try
    RichEdit.Visible := False;
    RichEdit.Parent := mstClientMainForm;
    Stream := TMemoryStream.Create;
    Stream.Forget;
    Strings.SaveToStream(Stream);
    Stream.Position := 0;
    RichEdit.Lines.LoadFromStream(Stream);

    oldStr := '[ADDRESS]';
    newStr := FLot.Address;
    RichEdit.Replace(oldStr, newStr);

    oldStr := '[AREA]';
    newStr := Format('%8.2f', [FLot.Area]);
    RichEdit.Replace(oldStr, newStr);


    Lots := mstClientAppModule.GetLots(FLot);
    try
      oldStr := '[AREA1]';
      newStr := Lots.GetLotData('ACCOMPLISHMENT_AREA');
      RichEdit.Replace(oldStr, newStr);

      oldStr := '[NOMENCLATURE]';
      newStr := Lots.GetLotData('NOMENCLATURA');
      RichEdit.Replace(oldStr, newStr);

      oldStr := '[PZ]';
      newStr := Lots.GetLotData('PZ');
      RichEdit.Replace(oldStr, newStr);

      oldStr := '[NEIGHBOURS]';
      newStr := Lots.GetLotData('NEIGHBOURS');
      RichEdit.Replace(oldStr, newStr);

      oldStr := '[EXECUTOR]';
      newStr := Lots.GetLotData('EXECUTOR');
      RichEdit.Replace(oldStr, newStr);

      oldStr := '[LOT_DATE]';
      newStr := Lots.GetLotData('DOC_DATE');
      RichEdit.Replace(oldStr, newStr);

      oldStr := '[DECREE_PREPARED]';
      newStr := Lots.GetLotData('DECREE_PREPARED');
      RichEdit.Replace(oldStr, newStr);

      oldStr := '[OWNER]';
      newStr := Lots.GetOwnerData('NAME');
      RichEdit.Replace(oldStr, newStr);

      oldStr := '[PROP_FORMS_NAME]';
      newStr := Lots.GetOwnerData('PROP_FORMS_NAME');
      RichEdit.Replace(oldStr, newStr);

      oldStr := '[PERIOD]';
      newStr := Lots.GetOwnerData('RENT_PERIOD');
      RichEdit.Replace(oldStr, newStr);

      oldStr := '[DOC_NAMES]';
      newStr := Lots.GetDocsList();
      RichEdit.Replace(oldStr, newStr);
    finally
      Lots.CloseLots;
    end;
    //
    Stream := TMemoryStream.Create;
    Stream.Forget;
    RichEdit.Lines.SaveToStream(Stream);
    Stream.Position := 0;
    Strings.LoadFromStream(Stream);
  finally
    RichEdit.Free;
  end;
end;

function TmstPrintModule.GetTextHeight2(FontHeight: Integer): Double;
begin
  Result := Abs(FontHeight) / Ffnt.PixelsPerInch * 25.4 * ReportScale / 1000;
end;

function TmstPrintModule.HasLot: Boolean;
begin
  Result := Assigned(FLot); 
end;

function TmstPrintModule.GetRows: TStringList;
var
  EnabledCount, I, J: Integer;
  S, S1: String;
  Point: TmstLotPoint;
begin
  Result := TStringList.Create;
  EnabledCount := FLot.Contours.EnabledCount;
  for I := 0 to Pred(FLot.Contours.Count) do
    if FLot.Contours[I].Enabled then
    begin
      if EnabledCount > 1 then
        Result.Add(FLot.Contours[I].Name);
      for J := 0 to Pred(FLot.Contours[I].Points.Count) do
      begin
        Point := FLot.Contours[I].Points[J];
        S := Point.Name + #9;
        S := S + Format('%8.2f', [Point.X]) + #9;
        S := S + Format('%8.2f', [Point.Y]) + #9;
        S := S + Format('%8.2f', [FLot.Contours[I].Points.Length[J]]) + #9;
        S := S + GetDegreeCorner(FLot.Contours[I].Points.Azimuth[J], True) + #9;
        if J = Pred(FLot.Contours[I].Points.Count) then
          S1 := FLot.Contours[I].Points[0].Name
        else
          S1 := FLot.Contours[I].Points[J + 1].Name;
        S := S + S1;
        Result.Add(S);
      end;
    end;
end;

procedure TmstPrintModule.DoSelectTable;
var
  Layer: TezBaseLayer;
  X0, Y0: Double;
begin
  if FTableSettings.Edit then
  begin
    Layer := mstClientAppModule.GIS.Layers.LayerByName(SL_REPORT);
    Layer.Recno := FTableIndex;
    with Layer.RecExtension do
    begin
      X0 := xmin;
      Y0 := ymax;
    end;
    Layer.DeleteEntity(FTableIndex);
    CreateTable(X0, Y0, GetRows);
  end;
end;

procedure TmstPrintModule.UpdateRTFText(oldScale: Integer);
var
  ReportLayer: TEzBaseLayer;
  oldRTF, newRTF: TEzRTFText;
  P1, P2: TEzPoint;
  aSize: TEzRect;
begin
//  Exit;
  ReportLayer := mstClientAppModule.GIS.Layers.LayerByName(SL_REPORT);
  ReportLayer.First;
  while not ReportLayer.Eof do
  begin
    if not ReportLayer.RecIsDeleted then
      if ReportLayer.RecEntityID = idRTFText then
      begin
        oldRTF := TEzRTFText(ReportLayer.RecEntity);
        // [kiosk] aSize := oldRTF.SizeInMMs;
//        aSize.xmax := aSize.xmin + (aSize.xmax - aSize.xmin) * ReportScale / oldScale;
//        aSize.ymax := aSize.ymin + (aSize.ymax - aSize.ymin) * ReportScale / oldScale;
        with ReportLayer.RecEntity.FBox do
          P1 := Point2D(xmin, ymax);
        P2.x := P1.x + aSize.xmax / 1000 * ReportScale;
        P2.y := P1.y - aSize.ymax / 1000 * ReportScale;
        newRTF := TEzRtfText.CreateEntity(P1, P2, oldRTF.Lines);
        // [kiosk] newRTF.SizeInMMs := aSize;
        ReportLayer.UpdateEntity(ReportLayer.Recno, newRTF);
//        newRTF.Free;
      end;
    ReportLayer.Next;
  end;
end;

procedure TmstPrintModule.DoEditTable;
var
  I: Integer;
  RefreshTable: Boolean;
  MemDataSet: TDataSet;
  Layer: TezBaseLayer;
  X0, Y0: Double;
  aRows: TStringList;
  S: String;
begin
  MemDataSet := PrepareMemDataSet();
  try
    // показываем окно
    with TmstFormReportTable.Create(Self) do
    try
      DataSource.DataSet := MemDataSet;
      RefreshTable := ShowModal = mrOK;
    finally
      Free;
    end;
    // переделываем таблицу
    if RefreshTable then
    begin
      aRows := IStringList(TSTringList.Create).StringList;
      MemDataSet.First;
      while not MemDataSet.Eof do
      begin
        S := MemDataSet.Fields[0].AsString;
        for I := 1 to Pred(MemDataSet.FieldCount) do
          S := S + #9 + MemDataSet.Fields[I].AsString;
        aRows.Add(S);
        MemDataSet.Next;
      end;
      Layer := mstClientAppModule.GIS.Layers.LayerByName(SL_REPORT);
      Layer.Recno := FTableIndex;
      with Layer.RecExtension do
      begin
        X0 := xmin;
        Y0 := ymax;
      end;
      Layer.DeleteEntity(FTableIndex);
      CreateTable(X0, Y0, aRows);
    end;
  finally
    FreeAndNil(MemDataSet);
  end;
end;

{ TmstPage }

function TmstPage.CreatePageEntity(const aRect: TEzRect): TEzEntity;
begin
  Result := TEzPageEntity.CreateEntity(aRect.Emin, aRect.Emax, IntToStr(FNumber));
end;

function TmstPage.GetPageRect: TEzRect;
var
  Layer: TEzBaseLayer;
begin
  Result := INVALID_EXTENSION;
  Layer := mstClientAppModule.GIS.Layers.LayerByName(SL_PAGES);
  if Assigned(Layer) then
    if FEntityId > 0 then
    begin
      Layer.Recno := FEntityId;
      Result := Layer.RecExtension;
    end;
end;

procedure TmstPage.SetNumber(const Value: Integer);
begin
  FNumber := Value;
end;

procedure TmstPage.SetShowNumber(const Value: Boolean);
var
  Layer: TEzBaseLayer;
begin
  FShowNumber := Value;
  if FEntityId > 0 then
  begin
    Layer := mstClientAppModule.GIS.Layers.LayerByName(SL_PAGES);
    if Assigned(Layer) then
    begin
      Layer.Recno := FEntityId;
      TEzPageEntity(Layer.RecEntity).ShowNumber := FShowNumber;
    end;
  end;
end;

procedure TmstPage.SetVisible(const Value: Boolean);
begin
  FVisible := Value;
end;

procedure TmstPage.UpdateEntity;
var
  Layer: TEzBaseLayer;
begin
  if FEntityId > 0 then
  begin
    Layer := mstClientAppModule.GIS.Layers.LayerByName(SL_PAGES);
    if Assigned(Layer) then
    begin
      Layer.Recno := FEntityId;
      TEzPageEntity(Layer.RecEntity).ShowNumber := mstPrintModule.ShowPageNumbers;
      TEzPageEntity(Layer.RecEntity).Visible := Self.Visible;
    end;
  end;
end;

{ TmstReportLine }

function TmstReportLine.GetMapWidth(const Scale: Double): Double;
begin
  Result := FWidth * Scale / 1000;
end;

procedure TmstReportLine.SetColor(const Value: Integer);
begin
  FColor := Value;
end;

procedure TmstReportLine.SetWidth(const Value: Double);
begin
  FWidth := Value;
end;

{ TmstReportLines }

constructor TmstReportLines.Create;
begin
  FLotLine := TmstReportLine.Create;
  FLotLine.Width := 1;
  FLotLine.Color := clGreen;
  FAnnulledLine := TmstReportLine.Create;
  FAnnulledLine.Width := 1;
  FAnnulledLine.Color := clFuchsia;
  FActualLine := TmstReportLine.Create;
  FActualLine.Width := 1;
  FActualLine.Color := clBlue;
  FSelectedLine := TmstReportLine.Create;
  FSelectedLine.Width := 1;
  FSelectedLine.Color := clRed;
end;

destructor TmstReportLines.Destroy;
begin
  FLotLine.Free;
  FAnnulledLine.Free;
  FActualLine.Free;
  FSelectedLine.Free;
  inherited;
end;

{ TmstCoordTableSettings }

constructor TmstCoordTableSettings.Create;
begin
  FCaptionFont := TFont.Create;
  InitFont(FCaptionFont);
  FCellFont := TFont.Create;
  InitFont(FCellFont);
  FContourFont := TFont.Create;
  InitFont(FContourFont);
end;

destructor TmstCoordTableSettings.Destroy;
begin
  FContourFont.Free;
  FCellFont.Free;
  FCaptionFont.Free;
  inherited;
end;

function TmstCoordTableSettings.Edit: Boolean;
begin
  with TmstCoordTableSettingsEditor.Create(nil) do
  try
    Font1 := Self.FCaptionFont;
    Font2 := Self.FContourFont;
    Font3 := Self.FCellFont;
    Result := ShowModal = mrOk;
    if Result then
    begin
      FCaptionFont.Assign(Font1);
      FContourFont.Assign(Font2);
      FCellFont.Assign(Font3);
    end;
  finally
    Free;
  end;
end;

procedure TmstCoordTableSettings.InitFont(aFont: TFont);
begin
  aFont.Size := 14;
  aFont.Name := 'Times New Roman';
  aFont.Charset := RUSSIAN_CHARSET;
end;

end.
