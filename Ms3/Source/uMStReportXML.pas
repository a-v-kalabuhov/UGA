unit uMStReportXML;

interface

uses
  Classes,
  Contnrs,
  Graphics,
  XMLIntf,
  EzBase,
  EzLib,
  EzBaseGIS;

type
  TReportPage = class
  private
    FX2: Double;
    FY2: Double;
    FX1: Double;
    FY1: Double;
    FShowNumber: Boolean;
    FVisible: Boolean;
    FNumber: Integer;
    procedure SetNumber(const Value: Integer);
    procedure SetShowNumber(const Value: Boolean);
    procedure SetVisible(const Value: Boolean);
    procedure SetX1(const Value: Double);
    procedure SetX2(const Value: Double);
    procedure SetY1(const Value: Double);
    procedure SetY2(const Value: Double);
  public
    property Number: Integer read FNumber write SetNumber;
    property ShowNumber: Boolean read FShowNumber write SetShowNumber;
    property Visible: Boolean read FVisible write SetVisible;
    property X1: Double read FX1 write SetX1;
    property X2: Double read FX2 write SetX2;
    property Y1: Double read FY1 write SetY1;
    property Y2: Double read FY2 write SetY2;
  end;

  TReportLine = class
  private
    FName: string;
    FWidth: Integer;
    FColor: TCOlor;
    procedure SetColor(const Value: TCOlor);
    procedure SetName(const Value: string);
    procedure SetWidth(const Value: Integer);
  public
    property Name: string read FName write SetName;
    property Width: Integer read FWidth write SetWidth;
    property Color: TCOlor read FColor write SetColor;
  end;

  TReportTableSetting = class
  private
    FName: string; // nTabSet.NodeName;
    FColor: TColor; // nTabSet.Attributes['color'];
    FFont: string; // nTabSet.Attributes['name'];
    FHeight: Integer; // nTabSet.Attributes['height'];
    FBold: Boolean; // nTabSet.Attributes['bold'];
    FItalic: Boolean; // nTabSet.Attributes['italic'];
    FUnderline: Boolean; // nTabSet.Attributes['underline'];
    FStrikedOut: Boolean;
    procedure SetBold(const Value: Boolean);
    procedure SetColor(const Value: TColor);
    procedure SetFont(const Value: string);
    procedure SetHeight(const Value: Integer);
    procedure SetItalic(const Value: Boolean);
    procedure SetName(const Value: string);
    procedure SetStrikedOut(const Value: Boolean);
    procedure SetUnderline(const Value: Boolean); // nTabSet.Attributes['strikedout'];
  public
    property Name: string read FName write SetName;
    property Color: TColor read FColor write SetColor;
    property Font: string read FFont write SetFont;
    property Height: Integer read FHeight write SetHeight;
    property Bold: Boolean read FBold write SetBold;
    property Italic: Boolean read FItalic write SetItalic;
    property Underline: Boolean read FUnderline write SetUnderline;
    property StrikedOut: Boolean read FStrikedOut write SetStrikedOut;
  end;

  IReportEntity = interface
    ['{0DE7F352-C3B3-42C1-9377-4390BEAA3C60}']
    function Stream: TStream;
    function EntityId: TEzEntityId;
    function GetEntity: TEzEntity;
  end;

  TReportEntity = class(TInterfacedObject, IReportEntity)
  private
    FEntityId: Integer;
    FStream: TStream;
    function Stream: TStream;
    function EntityId: TEzEntityId;
    function GetEntity: TEzEntity;
  public
    constructor Create(aEntityId: Integer; aStream: TStream);
    destructor Destroy; override;
  end;

  TXMLReport = class
  strict private
    FPages: TObjectList;
    FPoints: TInterfaceList;
    FTexts: TInterfaceList;
    FUserTexts: TInterfaceList;
    FTableWidth: TList;
    FReportLines: TObjectList;
    FTableSettings: TObjectList;
    //
    FDoc: IXMLDocument;
    //
    FLotId: Integer;
    FReportScale: Integer;
    FPrintArea: TEzRect;
    FShowPageNumbers: Boolean;
    FPointSize: Integer;
    FSelectedPage: Integer;
    FTableCK36: Boolean;
    //
    FPrinterName: string;
    FPrinterPort: string;
    FPrinterOrientation: SmallInt;
    FPrinterPaperSize: SmallInt;
    FPrinterPaperLength: SmallInt;
    FPrinterPaperWidth: SmallInt;
    FPrinterScale: SmallInt;
    FPrinterDefaultSource: SmallInt;
    FPrinterQuality: SmallInt;
    FPrinterColor: SmallInt;
    FPrinterDuplex: SmallInt;
    FPrinterYres: SmallInt;
    FPrinterTTOption: SmallInt;
    //
    FFontName: string;
    FFontHeight: Integer;
    FFontColor: TColor;
    FFontBold: Boolean;
    FFontItalic: Boolean;
    FFontUnderline: Boolean;
    FFontSrikedOut: Boolean;
    //
    FTable: IReportEntity;
    FHeader: IReportEntity;
    FFooter: IReportEntity;
    FPz: IReportEntity;
  private
    function ReadBytes(aNode: IXMLNode; AsCData: Boolean): TStream;
    procedure SetFontBold(const Value: Boolean);
    procedure SetFontColor(const Value: TColor);
    procedure SetFontHeight(const Value: Integer);
    procedure SetFontItalic(const Value: Boolean);
    procedure SetFontName(const Value: string);
    procedure SetFontSrikedOut(const Value: Boolean);
    procedure SetFontUnderline(const Value: Boolean);
    procedure SetPrinterColor(const Value: SmallInt);
    procedure SetPrinterDefaultSource(const Value: SmallInt);
    procedure SetPrinterDuplex(const Value: SmallInt);
    procedure SetPrinterName(const Value: string);
    procedure SetPrinterOrientation(const Value: SmallInt);
    procedure SetPrinterPaperLength(const Value: SmallInt);
    procedure SetPrinterPaperSize(const Value: SmallInt);
    procedure SetPrinterPaperWidth(const Value: SmallInt);
    procedure SetPrinterPort(const Value: string);
    procedure SetPrinterQuality(const Value: SmallInt);
    procedure SetPrinterScale(const Value: SmallInt);
    procedure SetPrinterTTOption(const Value: SmallInt);
    procedure SetPrinterYres(const Value: SmallInt);
    procedure SetLotId(const Value: Integer);
    procedure SetPointSize(const Value: Integer);
    procedure SetPrintArea(const Value: TEzRect);
    procedure SetReportScale(const Value: Integer);
    procedure SetSelectedPage(const Value: Integer);
    procedure SetShowPageNumbers(const Value: Boolean);
    procedure SetTableCK36(const Value: Boolean);
    function GetPages(Index: Integer): TReportPage;
    function GetPoints(Index: Integer): IReportEntity;
    function GetReportLines(const aName: string): TReportLine;
    function GetTableSettings(const aName: string): TReportTableSetting;
    function GetTableWidth(Index: Integer): Integer;
    function GetTexts(Index: Integer): IReportEntity;
    function GetUserTexts(Index: Integer): IReportEntity;
  public
    constructor Create();
    destructor Destroy; override;
    //
    procedure Load(XML: IXMLDocument);
    {$REGION 'Свойства'}
    property PrinterName: string read FPrinterName write SetPrinterName;
    property PrinterPort: string read FPrinterPort write SetPrinterPort;
    property PrinterOrientation: SmallInt read FPrinterOrientation write SetPrinterOrientation;
    property PrinterPaperSize: SmallInt read FPrinterPaperSize write SetPrinterPaperSize;
    property PrinterPaperLength: SmallInt read FPrinterPaperLength write SetPrinterPaperLength;
    property PrinterPaperWidth: SmallInt read FPrinterPaperWidth write SetPrinterPaperWidth;
    property PrinterScale: SmallInt read FPrinterScale write SetPrinterScale;
    property PrinterDefaultSource: SmallInt read FPrinterDefaultSource write SetPrinterDefaultSource;
    property PrinterQuality: SmallInt read FPrinterQuality write SetPrinterQuality;
    property PrinterColor: SmallInt read FPrinterColor write SetPrinterColor;
    property PrinterDuplex: SmallInt read FPrinterDuplex write SetPrinterDuplex;
    property PrinterYres: SmallInt read FPrinterYres write SetPrinterYres;
    property PrinterTTOption: SmallInt read FPrinterTTOption write SetPrinterTTOption;
    //
    property FontName: string read FFontName write SetFontName;
    property FontHeight: Integer read FFontHeight write SetFontHeight;
    property FontColor: TColor read FFontColor write SetFontColor;
    property FontBold: Boolean read FFontBold write SetFontBold;
    property FontItalic: Boolean read FFontItalic write SetFontItalic;
    property FontUnderline: Boolean read FFontUnderline write SetFontUnderline;
    property FontSrikedOut: Boolean read FFontSrikedOut write SetFontSrikedOut;
    //
    property Table: IReportEntity read FTable;
    property Header: IReportEntity read FHeader;
    property Footer: IReportEntity read FFooter;
    property Pz: IReportEntity read FPz;
    //
    property LotId: Integer read FLotId write SetLotId;
    property ReportScale: Integer read FReportScale write SetReportScale;
    property PrintArea: TEzRect read FPrintArea write SetPrintArea;
    property ShowPageNumbers: Boolean read FShowPageNumbers write SetShowPageNumbers;
    property PointSize: Integer read FPointSize write SetPointSize;
    property SelectedPage: Integer read FSelectedPage write SetSelectedPage;
    property TableCK36: Boolean read FTableCK36 write SetTableCK36;
    {$ENDREGION}
    property Pages[Index: Integer]: TReportPage read GetPages;
    function PageCount: Integer;
    property Points[Index: Integer]: IReportEntity read GetPoints;
    function PointCount: Integer;
    property Texts[Index: Integer]: IReportEntity read GetTexts;
    function TextCount: Integer;
    property UserTexts[Index: Integer]: IReportEntity read GetUserTexts;
    function UserTextCount: Integer;
    property TableWidth[Index: Integer]: Integer read GetTableWidth;
    function TableWidthCount: Integer;
    property ReportLines[const aName: string]: TReportLine read GetReportLines;
    property TableSettings[const aName: string]: TReportTableSetting read GetTableSettings;
  end;

implementation

uses
  ClassesHelpers;

{ TXMLReport }

constructor TXMLReport.Create;
begin
  FPages := TObjectList.Create;
  FPoints := TInterfaceList.Create;
  FTexts := TInterfaceList.Create;
  FUserTexts := TInterfaceList.Create;
  FTableWidth := TList.Create;
  FReportLines := TObjectList.Create;
  FTableSettings := TObjectList.Create;
end;

destructor TXMLReport.Destroy;
begin
  FTableSettings.Free;
  FReportLines.Free;
  FTableWidth.Free;
  FUserTexts.Free;
  FTexts.Free;
  FPoints.Free;
  FPages.Free;
  inherited;
end;

function TXMLReport.GetPages(Index: Integer): TReportPage;
begin
  Result := FPages[Index] as TReportPage;
end;

function TXMLReport.GetPoints(Index: Integer): IReportEntity;
begin
  Result := FPoints[Index] as IReportEntity;
end;

function TXMLReport.GetReportLines(const aName: string): TReportLine;
var
  I: Integer;
  RL: TReportLine;
begin
  for I := 0 to FReportLines.Count - 1 do
  begin
    RL := TReportLine(FReportLines[I]);
    if RL.Name = aName then
    begin
      Result := RL;
      Exit;
    end;
  end;
  Result := nil;  
end;

function TXMLReport.GetTableSettings(const aName: string): TReportTableSetting;
var
  I: Integer;
  TS: TReportTableSetting;
begin
  for I := 0 to FTableSettings.Count - 1 do
  begin
    TS := TReportTableSetting(FTableSettings[I]);
    if TS.Name = aName then
    begin
      Result := TS;
      Exit;
    end;
  end;
  Result := nil;  
end;

function TXMLReport.GetTableWidth(Index: Integer): Integer;
begin
  Result := Integer(FTableWidth[Index]);
end;

function TXMLReport.GetTexts(Index: Integer): IReportEntity;
begin
  Result := FTexts[Index] as IReportEntity;
end;

function TXMLReport.GetUserTexts(Index: Integer): IReportEntity;
begin
  Result := FUserTexts[Index] as IReportEntity;
end;

procedure TXMLReport.Load(XML: IXMLDocument);
var
  Node: IXMLNode;
  nPrinter: IXMLNode;
  nPages: IXMLNode;
  nPage: IXMLNode;
  nTexts: IXMLNode;
  nPoints: IXMLNode;
  nPoint: IXMLNode;
  nUserTexts: IXMLNode;
  nFont: IXMLNode;
  nTableWidth: IXMLNode;
  nTable: IXMLNode;
  nReportLines: IXMLNode;
  nTableSettings: IXMLNode;
  nTabSetStyle: IXMLNode;
  nHeader: IXMLNode;
  nFooter: IXMLNode;
  nPz: IXMLNode;
  nText: IXMLNode;
  nTabSet: IXMLNode;
  I, J: Integer;
  aPage: TReportPage;
  aLine: TReportLine;
  aTabSet: TReportTableSetting;
  TempStream: TStream;
  EntId: Integer;
  Ent: IReportEntity;
begin
  FDoc := XML;
  Node := FDoc.DocumentElement;
  FLotId := Node.Attributes['lot_id'];
  FPrintArea.X1 := Node.Attributes['print_area_x1'];
  FPrintArea.X2 := Node.Attributes['print_area_x2'];
  FPrintArea.Y1 := Node.Attributes['print_area_y1'];
  FPrintArea.Y2 := Node.Attributes['print_area_y2'];
  FShowPageNumbers := Node.Attributes['show_page_numbers'];
  FPointSize := Node.Attributes['point_size'];
  FSelectedPage := Node.Attributes['selected_page'];
  FReportScale := Node.Attributes['report_scale'];
  //
  nPrinter := Node.ChildNodes.FindNode('printer');
  if Assigned(nPrinter) then
  begin
    FPrinterName := nPrinter.Attributes['name'];
    FPrinterPort := nPrinter.Attributes['port'];
    FPrinterOrientation := nPrinter.Attributes['orientation'];
    FPrinterPaperSize := nPrinter.Attributes['papersize'];
    FPrinterPaperLength := nPrinter.Attributes['paperlength'];
    FPrinterPaperWidth := nPrinter.Attributes['paperwidth'];
    FPrinterScale := nPrinter.Attributes['scale'];
    FPrinterDefaultSource := nPrinter.Attributes['defaultsource'];
    FPrinterQuality := nPrinter.Attributes['quality'];
    FPrinterColor := nPrinter.Attributes['color'];
    FPrinterDuplex := nPrinter.Attributes['duplex'];
    FPrinterYres := nPrinter.Attributes['yres'];
    FPrinterTTOption := nPrinter.Attributes['ttoption'];
  end;
  //
  FPages.Clear;
  nPages := Node.ChildNodes.FindNode('pages');
  if Assigned(nPages) then
  begin
    for I := 0 to nPages.ChildNodes.Count - 1 do
    begin
      nPage := nPages.ChildNodes[I];
      aPage := TReportPage.Create();
      FPages.Add(aPage);
      aPage.Number := nPage.Attributes['number'];
      aPage.ShowNumber := nPage.Attributes['show_number'];
      aPage.Visible := nPage.Attributes['visible'];
      aPage.X1 := nPage.Attributes['x1'];
      aPage.X2 := nPage.Attributes['x2'];
      aPage.Y1 := nPage.Attributes['y1'];
      aPage.Y2 := nPage.Attributes['y2'];
    end;
  end;
  //
  FTexts.Clear;
  nTexts := Node.ChildNodes.FindNode('texts');
  if Assigned(nTexts) then
  begin
    for I := 0 to nTexts.ChildNodes.Count - 1 do
    begin
      nText := nTexts.ChildNodes[I];
      TempStream := ReadBytes(nText, nText.HasAttribute('version'));
      EntId := nText.Attributes['entity_id'];
      Ent := TReportEntity.Create(EntId, TempStream);
      FTexts.Add(Ent);
    end;
  end;
  //
  FPoints.Clear;
  nPoints := Node.ChildNodes.FindNode('points');
  if Assigned(nPoints) then
  begin
//    <points>
//        <point entity_id="7">
//            <byte>87</byte>
//        </point>
//    </points>
    for I := 0 to nPoints.ChildNodes.Count - 1 do
    begin
      nPoint := nPoints.ChildNodes[I];
      TempStream := ReadBytes(nPoint, nPoint.HasAttribute('version'));
      EntId := nPoint.Attributes['entity_id'];
      Ent := TReportEntity.Create(EntId, TempStream);
      FPoints.Add(Ent);
    end;
  end;
  //
  FUserTexts.Clear;
  nUserTexts := Node.ChildNodes.FindNode('user_texts');
  if Assigned(nUserTexts) then
  begin
//    <user_texts/>
    for I := 0 to nUserTexts.ChildNodes.Count - 1 do
    begin
      nText := nUserTexts.ChildNodes[I];
      TempStream := ReadBytes(nText, nText.HasAttribute('version'));
      EntId := nText.Attributes['entity_id'];
      Ent := TReportEntity.Create(EntId, TempStream);
      FUserTexts.Add(Ent);
    end;
  end;
  //
  nFont := Node.ChildNodes.FindNode('font');
  if Assigned(nFont) then
  begin
//    <font   name="Times New Roman"
//            height="-19"
//            color="-16777208"
//            bold="false"
//            italic="false"
//            underline="false"
//            strikedout="false"/>
      FFontName := nFont.Attributes['name'];
      FFontHeight := nFont.Attributes['height'];
      FFontColor := nFont.Attributes['color'];
      FFontBold := nFont.Attributes['bold'];
      FFontItalic := nFont.Attributes['italic'];
      FFontUnderline := nFont.Attributes['underline'];
      FFontSrikedOut := nFont.Attributes['strikedout'];
  end;
  //
  FTableWidth.Clear;
  nTableWidth := Node.ChildNodes.FindNode('table_width');
  if Assigned(nTableWidth) then
  begin
    for I := 0 to nTableWidth.ChildNodes.Count - 1 do
    begin
      nText := nTableWidth.ChildNodes[I];
      J := nText.NodeValue;
      FTableWidth.Add(Pointer(J));
    end;
//    <table_width>
//        <tw>70</tw>
//        <tw>65</tw>
//        <tw>65</tw>
//        <tw>72</tw>
//        <tw>76</tw>
//        <tw>72</tw>
//    </table_width>
  end;
  //
  FReportLines.Clear;
  nReportLines := Node.ChildNodes.FindNode('report_lines');
  if Assigned(nReportLines) then
  begin
    for I := 0 to nReportLines.ChildNodes.Count - 1 do
    begin
      nText := nReportLines.ChildNodes[I];
      aLine := TReportLine.Create;
      FReportLines.Add(aLine);
      aLine.Name := nText.NodeName;
      aLine.Width := nText.Attributes['width'];
      aLine.Color := nText.Attributes['color'];
    end;
//    <report_lines>
//        <actual width="1" color="16711680"/>
//        <annulled width="1" color="16711935"/>
//        <selected width="1" color="255"/>
//        <lotline width="1" color="32768"/>
//    </report_lines>
  end;
  //
  FTableSettings.Clear;
  nTableSettings := Node.ChildNodes.FindNode('table_settings');
  if Assigned(nTableSettings) then
  begin
    for I := 0 to nTableSettings.ChildNodes.Count - 1 do
    begin
      nTabSet := nTableSettings.ChildNodes[I];
      if nTabSet.NodeName = 'ck36' then
        FTableCK36 := nTabSet.NodeValue
      else
      begin
        aTabSet := TReportTableSetting.Create();
        FTableSettings.Add(aTabSet);
        aTabSet.Name := nTabSet.NodeName;
        aTabSet.Color := nTabSet.Attributes['color'];
        aTabSet.Font := nTabSet.Attributes['name'];
        aTabSet.Height := nTabSet.Attributes['height'];
        //
        nTabSetStyle := nTabSet.ChildNodes.FindNode('style');
        if Assigned(nTabSetStyle) then
        begin
          aTabSet.Bold := nTabSetStyle.Attributes['bold'];
          aTabSet.Italic := nTabSetStyle.Attributes['italic'];
          aTabSet.Underline := nTabSetStyle.Attributes['underline'];
          aTabSet.StrikedOut := nTabSetStyle.Attributes['strikedout'];
        end;
      end;
    end;
//    <table_settings>
//        <caption color="-16777208" name="Times New Roman" height="-19">
//            <style bold="false" italic="false" underline="false" strikedout="false"/>
//        </caption>
//        <cell color="-16777208" name="Times New Roman" height="-19">
//            <style bold="false" italic="false" underline="false" strikedout="false"/>
//        </cell>
//        <contour color="-16777208" name="Times New Roman" height="-19">
//            <style bold="false" italic="false" underline="false" strikedout="false"/>
//        </contour>
//        <ck36>false</ck36>
//    </table_settings>
  end;
  //
  FTable := nil;
  nTable := Node.ChildNodes.FindNode('table');
  if Assigned(nTable) then
  begin
    EntId := nTable.Attributes['entity_id'];
    TempStream := ReadBytes(nTable, nTable.HasAttribute('version'));
    FTable := TReportEntity.Create(EntId, TempStream) as IReportEntity;
//    <table entity_id="13">
//        <byte>59</byte>
//    </table>
  end;
  //
  FHeader := nil;
  nHeader := Node.ChildNodes.FindNode('header');
  if Assigned(nHeader) then
  begin
    EntId := nHeader.Attributes['entity_id'];
    TempStream := ReadBytes(nHeader, nHeader.HasAttribute('version'));
    FHeader := TReportEntity.Create(EntId, TempStream) as IReportEntity;
//    <header entity_id="35">
//        <byte>56</byte>
//    </header>
  end;
  //
  FFooter := nil;
  nFooter := Node.ChildNodes.FindNode('footer');
  if Assigned(nFooter) then
  begin
    EntId := nFooter.Attributes['entity_id'];
    TempStream := ReadBytes(nFooter, nFooter.HasAttribute('version'));
    FFooter := TReportEntity.Create(EntId, TempStream) as IReportEntity;
//    <footer entity_id="35">
//        <byte>57</byte>
//    </footer>
  end;
  //
  FPz := nil;
  nPz := Node.ChildNodes.FindNode('pz');
  if Assigned(nPz) then
  begin
    EntId := nPz.Attributes['entity_id'];
    TempStream := ReadBytes(nPz, nPz.HasAttribute('version'));
    FPz := TReportEntity.Create(EntId, TempStream) as IReportEntity;
//    <pz entity_id="35">
//        <byte>58</byte>
//        <byte>0</byte>
//        <byte>0</byte>
//    </pz>
  end;
end;

function TXMLReport.PageCount: Integer;
begin
  Result := FPages.Count;
end;

function TXMLReport.PointCount: Integer;
begin
  Result := FPoints.Count;
end;

function TXMLReport.ReadBytes(aNode: IXMLNode; AsCData: Boolean): TStream;
var
  I: Integer;
  B: Byte;
  S: string;
begin
  Result := TMemoryStream.Create;
  if AsCData then
  begin
    if aNode.ChildNodes.Count > 0 then
      if aNode.ChildNodes[0].NodeType = ntCData then
      begin
        S := aNode.ChildNodes[0].Text;
        Result.WriteHex(S);
      end;
  end
  else
  begin
//    TMemoryStream(Result).SetSize(aNode.ChildNodes.Count);
    for I := 0 to aNode.ChildNodes.Count - 1 do
    begin
      B := aNode.ChildNodes[I].NodeValue;
      Result.Write(B, SizeOf(B));
    end;
  end;
end;

procedure TXMLReport.SetFontBold(const Value: Boolean);
begin
  FFontBold := Value;
end;

procedure TXMLReport.SetFontColor(const Value: TColor);
begin
  FFontColor := Value;
end;

procedure TXMLReport.SetFontHeight(const Value: Integer);
begin
  FFontHeight := Value;
end;

procedure TXMLReport.SetFontItalic(const Value: Boolean);
begin
  FFontItalic := Value;
end;

procedure TXMLReport.SetFontName(const Value: string);
begin
  FFontName := Value;
end;

procedure TXMLReport.SetFontSrikedOut(const Value: Boolean);
begin
  FFontSrikedOut := Value;
end;

procedure TXMLReport.SetFontUnderline(const Value: Boolean);
begin
  FFontUnderline := Value;
end;

procedure TXMLReport.SetLotId(const Value: Integer);
begin
  FLotId := Value;
end;

procedure TXMLReport.SetPointSize(const Value: Integer);
begin
  FPointSize := Value;
end;

procedure TXMLReport.SetPrintArea(const Value: TEzRect);
begin
  FPrintArea := Value;
end;

procedure TXMLReport.SetPrinterColor(const Value: SmallInt);
begin
  FPrinterColor := Value;
end;

procedure TXMLReport.SetPrinterDefaultSource(const Value: SmallInt);
begin
  FPrinterDefaultSource := Value;
end;

procedure TXMLReport.SetPrinterDuplex(const Value: SmallInt);
begin
  FPrinterDuplex := Value;
end;

procedure TXMLReport.SetPrinterName(const Value: string);
begin
  FPrinterName := Value;
end;

procedure TXMLReport.SetPrinterOrientation(const Value: SmallInt);
begin
  FPrinterOrientation := Value;
end;

procedure TXMLReport.SetPrinterPaperLength(const Value: SmallInt);
begin
  FPrinterPaperLength := Value;
end;

procedure TXMLReport.SetPrinterPaperSize(const Value: SmallInt);
begin
  FPrinterPaperSize := Value;
end;

procedure TXMLReport.SetPrinterPaperWidth(const Value: SmallInt);
begin
  FPrinterPaperWidth := Value;
end;

procedure TXMLReport.SetPrinterPort(const Value: string);
begin
  FPrinterPort := Value;
end;

procedure TXMLReport.SetPrinterQuality(const Value: SmallInt);
begin
  FPrinterQuality := Value;
end;

procedure TXMLReport.SetPrinterScale(const Value: SmallInt);
begin
  FPrinterScale := Value;
end;

procedure TXMLReport.SetPrinterTTOption(const Value: SmallInt);
begin
  FPrinterTTOption := Value;
end;

procedure TXMLReport.SetPrinterYres(const Value: SmallInt);
begin
  FPrinterYres := Value;
end;

procedure TXMLReport.SetReportScale(const Value: Integer);
begin
  FReportScale := Value;
end;

procedure TXMLReport.SetSelectedPage(const Value: Integer);
begin
  FSelectedPage := Value;
end;

procedure TXMLReport.SetShowPageNumbers(const Value: Boolean);
begin
  FShowPageNumbers := Value;
end;

procedure TXMLReport.SetTableCK36(const Value: Boolean);
begin
  FTableCK36 := Value;
end;

function TXMLReport.TableWidthCount: Integer;
begin
  Result := FTableWidth.Count;
end;

function TXMLReport.TextCount: Integer;
begin
  Result := FTexts.Count;
end;

function TXMLReport.UserTextCount: Integer;
begin
  Result := FUserTexts.Count;
end;

{ TReportPage }

procedure TReportPage.SetNumber(const Value: Integer);
begin
  FNumber := Value;
end;

procedure TReportPage.SetShowNumber(const Value: Boolean);
begin
  FShowNumber := Value;
end;

procedure TReportPage.SetVisible(const Value: Boolean);
begin
  FVisible := Value;
end;

procedure TReportPage.SetX1(const Value: Double);
begin
  FX1 := Value;
end;

procedure TReportPage.SetX2(const Value: Double);
begin
  FX2 := Value;
end;

procedure TReportPage.SetY1(const Value: Double);
begin
  FY1 := Value;
end;

procedure TReportPage.SetY2(const Value: Double);
begin
  FY2 := Value;
end;

{ TReportLine }

procedure TReportLine.SetColor(const Value: TCOlor);
begin
  FColor := Value;
end;

procedure TReportLine.SetName(const Value: string);
begin
  FName := Value;
end;

procedure TReportLine.SetWidth(const Value: Integer);
begin
  FWidth := Value;
end;

{ TReportTableSetting }

procedure TReportTableSetting.SetBold(const Value: Boolean);
begin
  FBold := Value;
end;

procedure TReportTableSetting.SetColor(const Value: TColor);
begin
  FColor := Value;
end;

procedure TReportTableSetting.SetFont(const Value: string);
begin
  FFont := Value;
end;

procedure TReportTableSetting.SetHeight(const Value: Integer);
begin
  FHeight := Value;
end;

procedure TReportTableSetting.SetItalic(const Value: Boolean);
begin
  FItalic := Value;
end;

procedure TReportTableSetting.SetName(const Value: string);
begin
  FName := Value;
end;

procedure TReportTableSetting.SetStrikedOut(const Value: Boolean);
begin
  FStrikedOut := Value;
end;

procedure TReportTableSetting.SetUnderline(const Value: Boolean);
begin
  FUnderline := Value;
end;

{ TReportEntity }

constructor TReportEntity.Create(aEntityId: Integer; aStream: TStream);
begin
  FEntityId := aEntityId;
  FStream := aStream;
end;

destructor TReportEntity.Destroy;
begin
  FStream.Free;
  inherited;
end;

function TReportEntity.EntityId: TEzEntityId;
begin
  Result := TEzEntityID(FEntityId);
end;

function TReportEntity.GetEntity: TEzEntity;
var
  EntClass: TEzEntityClass;
begin
  Result := nil;
  EntClass := GetClassFromID(EntityId);
  if Assigned(EntClass) then
    if Assigned(FStream) and (FStream.Size > 0) then
      try
        Result := EntClass.Create(1);
        FStream.Position := 0;
        Result.LoadFromStream(FStream);
      except
        Result := nil;
      end;
end;

function TReportEntity.Stream: TStream;
begin
  Result := FStream;
end;

end.
