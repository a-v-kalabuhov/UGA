unit fdemoprevw;

{$I EZ_FLAG.PAS}
interface

uses Windows, SysUtils, Classes, Graphics, Forms, Controls, StdCtrls,
  Buttons, ExtCtrls, EzBaseGIS, EzbasicCtrls, Ezlib, EzCmdLine, Messages,
  ComCtrls, Printers, EzEntities, Ezbase, Menus, dialogs, fMosaic,
  EzPreview, fAccuDrawPrev;

type
  TfrmDemoPreview = class(TForm)
    Panel1: TPanel;
    CmdLine1: TEzCmdLine;
    Panel3: TPanel;
    btnZoomW: TSpeedButton;
    btnZoomPrevious: TSpeedButton;
    SpeedButton1: TSpeedButton;
    SpeedButton2: TSpeedButton;
    btnScroll: TSpeedButton;
    btnMeas: TSpeedButton;
    btnReshape: TSpeedButton;
    btnRotate: TSpeedButton;
    btnScale: TSpeedButton;
    btnMove: TSpeedButton;
    BtnPrint: TSpeedButton;
    StatusBar1: TStatusBar;
    btnFullPage: TSpeedButton;
    Bevel2: TBevel;
    Bevel1: TBevel;
    Bevel3: TBevel;
    BtnFitPage: TSpeedButton;
    BtnRectSelect: TSpeedButton;
    Bevel5: TBevel;
    btnRect: TSpeedButton;
    btnArc: TSpeedButton;
    btnEllipse: TSpeedButton;
    btnPolygon: TSpeedButton;
    btnPLine: TSpeedButton;
    btnLine: TSpeedButton;
    btnBitmap: TSpeedButton;
    Bevel6: TBevel;
    btntext: TSpeedButton;
    btnMap: TSpeedButton;
    Label1: TLabel;
    Panel2: TPanel;
    EzVRuler1: TEzVRuler;
    PreviewBox1: TEzPreviewBox;
    EzHRuler1: TEzHRuler;
    btnExit: TSpeedButton;
    PopupMenu1: TPopupMenu;
    Alignment1: TMenuItem;
    BtnOptions: TSpeedButton;
    Bevel4: TBevel;
    SizeandPosition1: TMenuItem;
    btnHints: TSpeedButton;
    BtnCircle3P: TSpeedButton;
    BtnCircleCR: TSpeedButton;
    MainMenu1: TMainMenu;
    File1: TMenuItem;
    Print1: TMenuItem;
    N1: TMenuItem;
    Exit1: TMenuItem;
    Edit1: TMenuItem;
    Cut1: TMenuItem;
    Copy1: TMenuItem;
    Paste1: TMenuItem;
    Delete1: TMenuItem;
    Tools1: TMenuItem;
    Linestyle1: TMenuItem;
    Fillstyle1: TMenuItem;
    Symbolstyle1: TMenuItem;
    Textstyle1: TMenuItem;
    BtnGraphInfo: TSpeedButton;
    Bevel7: TBevel;
    SpeedButton3: TSpeedButton;
    btnFittedText: TSpeedButton;
    btnJustText: TSpeedButton;
    SpeedButton4: TSpeedButton;
    AccuDraw1: TMenuItem;
    Show1: TMenuItem;
    Configure1: TMenuItem;
    UnRotate1: TMenuItem;
    ChangeOrigin1: TMenuItem;
    Rotate1: TMenuItem;
    N2: TMenuItem;
    CopyToWindows1: TMenuItem;
    PastefromWindowsClipboard1: TMenuItem;
    Undo1: TMenuItem;
    N3: TMenuItem;
    procedure BtnPrintClick(Sender: TObject);
    procedure btnZoomInClick(Sender: TObject);
    procedure btnZoomOutClick(Sender: TObject);
    procedure btnZoomWClick(Sender: TObject);
    procedure btnZoomPreviousClick(Sender: TObject);
    procedure btnScrollClick(Sender: TObject);
    procedure btnMoveClick(Sender: TObject);
    procedure btnScaleClick(Sender: TObject);
    procedure btnRotateClick(Sender: TObject);
    procedure btnReshapeClick(Sender: TObject);
    procedure btnMeasClick(Sender: TObject);
    procedure PreviewBox1MouseMove2D(Sender: TObject; Shift: TShiftState; X,
      Y: Integer; const WX, WY: Double);
    procedure PreviewBox1GridError(Sender: TObject);
    procedure CmdLine1StatusMessage(Sender: TObject;
      const Message: String);
    procedure PreviewBox1ZoomChange(Sender: TObject; const Scale: Double);
    procedure PreviewBox1BeginRepaint(Sender: TObject);
    procedure btnFullPageClick(Sender: TObject);
    procedure BtnFitPageClick(Sender: TObject);
    procedure btntextClick(Sender: TObject);
    procedure BtnRectSelectClick(Sender: TObject);
    procedure btnBitmapClick(Sender: TObject);
    procedure btnLineClick(Sender: TObject);
    procedure btnPLineClick(Sender: TObject);
    procedure btnPolygonClick(Sender: TObject);
    procedure btnRectClick(Sender: TObject);
    procedure btnArcClick(Sender: TObject);
    procedure btnEllipseClick(Sender: TObject);
    procedure btnMapClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure btnExitClick(Sender: TObject);
    procedure Alignment1Click(Sender: TObject);
    procedure BtnOptionsClick(Sender: TObject);
    procedure SizeandPosition1Click(Sender: TObject);
    procedure PreviewBox1ShowHint(Sender: TObject; Layer: TEzBaseLayer;
      Recno: Integer; var Hint: String; var ShowHint: Boolean);
    procedure btnHintsClick(Sender: TObject);
    procedure BtnCircle3PClick(Sender: TObject);
    procedure BtnCircleCRClick(Sender: TObject);
    procedure PreviewBox1EntityDblClick(Sender: TObject;
      Layer: TEzBaseLayer; RecNo: Integer; var Processed: Boolean);
    procedure Print1Click(Sender: TObject);
    procedure Exit1Click(Sender: TObject);
    procedure Cut1Click(Sender: TObject);
    procedure Copy1Click(Sender: TObject);
    procedure Paste1Click(Sender: TObject);
    procedure Delete1Click(Sender: TObject);
    procedure Linestyle1Click(Sender: TObject);
    procedure Fillstyle1Click(Sender: TObject);
    procedure Symbolstyle1Click(Sender: TObject);
    procedure Textstyle1Click(Sender: TObject);
    procedure BtnGraphInfoClick(Sender: TObject);
    procedure SpeedButton3Click(Sender: TObject);
    procedure btnFittedTextClick(Sender: TObject);
    procedure btnJustTextClick(Sender: TObject);
    procedure SpeedButton4Click(Sender: TObject);
    procedure FormPaint(Sender: TObject);
    procedure Show1Click(Sender: TObject);
    procedure Configure1Click(Sender: TObject);
    procedure UnRotate1Click(Sender: TObject);
    procedure ChangeOrigin1Click(Sender: TObject);
    procedure CmdLine1AccuDrawChange(Sender: TObject);
    procedure CmdLine1AccuDrawActivate(Sender: TObject);
    procedure Rotate1Click(Sender: TObject);
    procedure CopyToWindows1Click(Sender: TObject);
    procedure PastefromWindowsClipboard1Click(Sender: TObject);
    procedure Undo1Click(Sender: TObject);
  private
    { Private declarations }
    FDrawBox: TEzBaseDrawBox;
    { here we will save the identifier for the owner draw table }
    FTableOwnerDrawID: Integer;
    FTileBitmap: TBitmap;
    frmMosaic: TfrmMosaic;
    FOldWidth:integer;
    FOldheight:integer;
    FFirstTime: Boolean;
    { accudraw }
    FfrmAccuDraw: TfrmAccuDrawPreview;
    procedure AddSampleEntities;
    procedure TableDrawCell(Sender: TObject; ACol, ARow: Longint;
      Cnv: TCanvas; Grapher: TEzGrapher; Rect: TRect);
    procedure MyPaintEntity( Sender: TObject; Layer: TEzBaseLayer;
      Recno: Integer; Entity: TEzEntity; Grapher: TEzGrapher; Canvas: TCanvas;
      const Clip: TEzRect; DrawMode: TEzDrawMode; var CanShow: Boolean;
      Var EntList: TEzEntityList; Var AutoFree: Boolean );
    procedure WMEnterSizeMove( Var m: TMessage ); Message WM_ENTERSIZEMOVE;
    procedure WMExitSizeMove( Var m: TMessage ); Message WM_EXITSIZEMOVE;
    procedure PreviewBox1GisTimer(Sender: TObject; var CancelPainting: Boolean);
  public
    { Public declarations }
    function Enter( DrawBox: TEzBaseDrawBox ): Word;

    property frmAccuDraw: TfrmAccuDrawPreview read FfrmAccuDraw write FfrmAccuDraw;
  end;

Var
  frmDemoPreview: TfrmDemoPreview;

implementation

{$R *.DFM}

uses
  Math, Grids, Clipbrd, fSizePo, fAlignment, ezconsts, EzActions, EzSystem, fRichEdit,
  fLineType, fBrushStyle, fFontStyle, EzMiscelEntities, fInspector,
  EzActionLaunch, fAccuDrawSetts, fMain
{$IFDEF GIS_CONTROLS}
  , fLegend, EzThematics
{$ENDIF}
  ;

{ NOTE: There is plenty of room for features to add to this demo }

function TfrmDemoPreview.Enter(DrawBox: TEzBaseDrawBox): Word;
begin
  { save the viewport }
  FDrawBox:= DrawBox;
  { fill the collection of TActivemap list with the map passed in
    parameter viewport. Any of this map can be placed on the paper }
  with PreviewBox1.GISList.Add do
    GIS:= DrawBox.GIS;
  { enable selecting preview entities on the viewport }
  PreviewBox1.NoPickFilter:= PreviewBox1.NoPickFilter - [idPreview];
  { don't show the grid }
  PreviewBox1.GridInfo.ShowGrid:= False;
  { this example assume inches }
  PreviewBox1.PaperUnits:= suInches;
  { by default will use the current selected printer paper configuration }
  PreviewBox1.PaperSize:= psPrinter;
  { prepare for showing entities }
  PreviewBox1.ConfigurePaperShapes;
  PreviewBox1.CreateNewEditor;
  { link to a timer }
  PreviewBox1.Gis.OnGisTimer:= PreviewBox1GisTimer;
  { add sample entities to the preview }
  AddSampleEntities;
  { zoom to paper limits }
  //PreviewBox1.ZoomToPaper;
  //PreviewBox1.Grapher.Clear;
  { don't show full view cursor }
  //CmdLine1.UseFullViewCursor:= FALSE;

  result:= ShowModal;
end;

procedure TfrmDemoPreview.BtnPrintClick(Sender: TObject);
begin
  if Printer.Printing then Exit;
  PreviewBox1.Print;
  if frmMosaic <> Nil then
    frmMosaic.MosaicView1.AddCurrentToPrintList;
end;

procedure TfrmDemoPreview.btnZoomInClick(Sender: TObject);
begin
  CmdLine1.Clear;
  CmdLine1.DoCommand(SCmdZoomIn,'');
end;

procedure TfrmDemoPreview.btnZoomOutClick(Sender: TObject);
begin
  CmdLine1.Clear;
  CmdLine1.DoCommand(SCmdZoomOut,'');
end;

procedure TfrmDemoPreview.AddSampleEntities;
var
  //R: TRect2D;
  xmin,ymin,xmax,ymax, dx, dy: Double;
  fs: TEzFontStyle;
  tbl: TEzTableEntity;
  PlottedUnits: Double;
  DrawingUnits: Double;
  gs:TEzTableBorderStyle;
  TempDecimalSeparator: Char;
  {
  TFontStyle2D = packed record
    Name: string[LF_FACESIZE - 1];
    Style: TFontStyles;
    Color: TColor;
    Angle: Double;
    Height: Double; // in real units
  end;
  dl: TEzBorderStyle;
  }
  //mt: TEzTableEntity;
  {
  TBorderStyle = packed record
    Visible: Boolean;
    Style: Byte;
    Color: TColor;
    Width: Double;
  end;
  }
  temp: Double;
  temps: string;
  TempR: TEzRect;
  tempFont: TEzFontStyle;
  I: Integer;
  GStyle: TEzTableBorderStyle;
  LegendEntity: TEzTableEntity;
{$IFDEF GIS_CONTROLS}
  Legend: TEzLegend;
{$ENDIF}
begin
  { use the current extents on the drawing for setting the map view area }
  FDrawBox.CurrentExtents(Xmin,Ymin,Xmax,Ymax);
  with PreviewBox1 do
  begin
    { print a map }
    Ez_Preferences.DefPenStyle.Style:=1;
    Ez_Preferences.DefPenStyle.Color:= clBlack;
    Ez_Preferences.DefPenStyle.Scale:= 0.01;
    Ez_Preferences.DefBrushStyle.Pattern:=1;
    Ez_Preferences.DefBrushStyle.Color:=clWhite;
    { we will calculate an scale, but you can set it to whatever you want }
    dx := Abs(xmax-xmin);
    dy := abs(ymax-ymin);
    DrawingUnits := dMax(dx, dy);                             { for every n inches on the paper...}
    PlottedUnits := dMin(PreviewBox1.PaperWidth, PreviewBox1.PaperHeight);    { ...will correspond to x units on the map }
    AddMap(0, 0.32, -1.24, 7.36, 6.3, PlottedUnits,
      DrawingUnits, (xmin+xmax)/2, (ymin+ymax)/2, True);

    { print a rectangle around the map }
    Ez_Preferences.DefPenStyle.Style:=1;
    Ez_Preferences.DefPenStyle.Color:=clBlack;
    Ez_Preferences.DefPenStyle.Scale:=0;
    Ez_Preferences.DefBrushStyle.Pattern:= 0; // no fill

    TempDecimalSeparator:= DecimalSeparator;
    DecimalSeparator:= '.';
    AddEntityFromText('',
      Format('RECTANGLE (%f, %f), (%f, %f), 0.0',[0.32,-1.24,0.32+7.36,-(1.24+6.3)]) );
    DecimalSeparator:= TempDecimalSeparator;

    { The Header}
    { FontStyle.Name:='Verdana';
    FontStyle.Styles:=[];
    FontStyle.Angle:=0;
    FontStyle.Height:=0.10;
    FontStyle.Color:=$00663300;
    DrawText(FDrawBox.Activemap.FileName,
      Rect2D(MarginLeft,MarginTop+0.30,PageWidth,MarginTop+0.80), DT_SINGLELINE or DT_VCENTER
        or DT_CENTER); }
    //TextOut(2.65,0.44,FDrawBox.Activemap.FileName);

    { The footer }
    {FontStyle.Name:='Arial';
    FontStyle.Styles:=[];
    FontStyle.Angle:=0;
    FontStyle.Height:=0.08;
    FontStyle.Color:=clBlue;
    AddDrawText('Printed By Activemap. See us at www.sigmap.com',
      Rect2D(MarginLeft,Pageheight-MarginBottom-0.60,PageWidth,PageHeight-MarginBottom), DT_SINGLELINE or DT_VCENTER
        or DT_CENTER); }

    { how to print a table (a text grid) }
    { you can populate a table from a dataset or any other source }
    tbl:= TEzTableEntity.CreateEntity(Point2D(3.5,-7.68), Point2D(8,-9.5));
    try
      with tbl do
      begin
        Options := [ezgoVertLine, ezgoHorzLine];
        RowCount:= 6;
        TitleHeight:= 1.8;
        Pentool.Scale:= 0.02;
        Pentool.Style:= 1;
        Pentool.Color:= clNavy;
        Brushtool.Pattern:= 1;
        Brushtool.Color:= clBtnFace;
        { a border }
        BorderWidth:= 0.02;
        LoweredColor:= clSilver;
        //RowHeight:= 0.50;
        with Columns.Add do
        begin
          Title.Caption:= 'CustNo';
          Title.Alignment:= taCenter;
          Title.Color:= clSilver;
          Title.Transparent:= false;
            fs.Name:= 'Verdana';
            fs.Height:= 0.15;
            fs.Color:= clBlack;
            fs.Style:= [fsBold];
          Title.Font:= fs;
          Width:= 0.6;
          Alignment:= taRightJustify;
          Color:= clSilver;
          Transparent:= false;
            fs.Name:= 'Arial';
            fs.Height:= 0.12;
            fs.Color:= clBlack;
            fs.Style:= [];
          Font:= fs;
        end;
        with Columns.Add do
        begin
          Title.Caption:= 'Company';
          Title.Alignment:= taCenter;
          Title.Color:= clBlue;
          Title.Transparent:= true;
            fs.Name:= 'Verdana';
            fs.Height:= 0.15;
            fs.Color:= clBlack;
            fs.Style:= [fsBold];
          Title.Font:= fs;
          Width:= 1.6;
          Alignment:= taLeftJustify;
          Color:= clSilver;
          Transparent:= True;
            fs.Name:= 'Arial';
            fs.Height:= 0.12;
            fs.Color:= clBlack;
            fs.Style:= [fsBold];
          Font:= fs;
        end;
        with Columns.Add do
        begin
          Title.Caption:= 'Addr1';
          Title.Alignment:= taCenter;
          Title.Color:= clBlue;
          Title.Transparent:= true;
            fs.Name:= 'Verdana';
            fs.Height:= 0.15;
            fs.Color:= clBlack;
            fs.Style:= [fsBold];
          Title.Font:= fs;
          Width:= 1.1;
          Alignment:= taLeftJustify;
          Color:= clSilver;
          Transparent:= True;
            fs.Name:= 'Arial';
            fs.Height:= 0.12;
            fs.Color:= clBlack;
            fs.Style:= [fsBold];
          Font:= fs;
        end;
        with Columns.Add do
        begin
          Title.Caption:= 'City';
          Title.Alignment:= taCenter;
          Title.Color:= clBlue;
          Title.Transparent:= true;
            fs.Name:= 'Verdana';
            fs.Height:= 0.15;
            fs.Color:= clBlack;
            fs.Style:= [fsBold];
          Title.Font:= fs;
          Width:= 0.8;
          Alignment:= taLeftJustify;
          Color:= clSilver;
          Transparent:= True;
            fs.Name:= 'Arial';
            fs.Height:= 0.12;
            fs.Color:= clBlack;
            fs.Style:= [fsBold];
          Font:= fs;
        end;
        with Columns.Add do
        begin
          Title.Caption:= 'State';
          Title.Alignment:= taCenter;
          Title.Color:= clBlue;
          Title.Transparent:= true;
            fs.Name:= 'Verdana';
            fs.Height:= 0.15;
            fs.Color:= clBlack;
            fs.Style:= [fsBold];
          Title.Font:= fs;
          Width:= 0.5;
          Alignment:= taLeftJustify;
          Color:= clSilver;
          Transparent:= True;
            fs.Name:= 'Arial';
            fs.Height:= 0.12;
            fs.Color:= clBlack;
            fs.Style:= [fsBold];
          Font:= fs;
        end;
        { now the row strings Strings.Cells[Col,Row]
         where Col,Row are 0 based. Row=0 for first row }
        Columns[0].Strings[0]:= '1645';
        Columns[0].Strings[1]:= '3158';
        Columns[0].Strings[2]:= '1984';
        Columns[0].Strings[3]:= '3053';
        Columns[0].Strings[4]:= '6312';
        Columns[0].Strings[5]:= '3984';

        Columns[1].Strings[0]:= 'Action Club';
        Columns[1].Strings[1]:= 'Action Diver supply';
        Columns[1].Strings[2]:= 'Adventure Undersea';
        Columns[1].Strings[3]:= 'American SCUBA Supply';
        Columns[1].Strings[4]:= 'Aquatic Drama';
        Columns[1].Strings[5]:= 'Blue Glass Happiness';

        Columns[2].Strings[0]:= 'PO Box 5451-F';
        Columns[2].Strings[1]:= 'Blue Spar Box #3';
        Columns[2].Strings[2]:= 'PO Box 744';
        Columns[2].Strings[3]:= '1739 Atlantic Avenue';
        Columns[2].Strings[4]:= '921 Everglades Way';
        Columns[2].Strings[5]:= '6345 W. Shore Lane';

        Columns[3].Strings[0]:= 'Sarasota';
        Columns[3].Strings[1]:= 'St. Thomas';
        Columns[3].Strings[2]:= 'Belize City';
        Columns[3].Strings[3]:= 'Lomita';
        Columns[3].Strings[4]:= 'Tampa';
        Columns[3].Strings[5]:= 'Santa Monica';

        Columns[4].Strings[0]:= 'FLA';
        Columns[4].Strings[1]:= '';
        Columns[4].Strings[2]:= '';
        Columns[4].Strings[3]:= 'CA';
        Columns[4].Strings[4]:= 'FL';
        Columns[4].Strings[5]:= 'CA';
      end;
      { you can populate from a dataset with something like
      mt:= TMapTable.Create(nil);
      try
        mt.Viewport:= FDrawBox;
        mt.LayerName:= FDrawBox.Activemap.Layers[0].Name;
        mt.Open;
        tbl.PopulateFromDataset(mt);
      finally
        mt.Free;
      end; }
      AddEntity('',tbl);
    finally
      tbl.free;
    end;


    { *************** create the legend entity (based on a TEzTableEntity }
{$IFDEF GIS_CONTROLS}
    Legend:= Nil;
    For I:= 0 to Screen.FormCount-1 do
      If Screen.Forms[I] Is TfrmLegend Then
      Begin
        Legend:= TfrmLegend(Screen.Forms[I]).Legend1;
        break;
      End;
    If (Legend <> Nil) And Legend.Visible Then
    Begin
      LegendEntity:= TEzTableEntity.CreateEntity(Point2D(PreviewBox1.MarginLeft,-7.68),
        Point2D(PreviewBox1.MarginLeft+2.5,-9.5));
      with LegendEntity Do
      Begin
        Pentool.Assign( Legend.Pentool );
        Pentool.Width:= 0.02;//PreviewBox1.Grapher.DistToRealY(trunc(Legend.Pentool.Width));
        Brushtool.Assign( Legend.Brushtool );
        If goVertLine In Legend.Options Then
          Options:= Options + [ezgoVertLine]
        Else
          Options:= Options - [ezgoVertLine];
        If goHorzLine In Legend.Options Then
          Options:= Options + [ezgoHorzLine]
        Else
          Options:= Options - [ezgoHorzLine];

        GStyle.Visible:= True;
        GStyle.Style:= 1;
        GStyle.Color:=clSilver;
        GStyle.Width:= 0;//PreviewBox1.Grapher.DistToRealY(Legend.GridLineWidth);
        GridStyle:= GStyle;
        BorderWidth:= 0.02; //PreviewBox1.Grapher.DistToRealY(Legend.BorderWidth);
        LoweredColor:= Legend.LoweredColor;

        RowCount:= Legend.LegendRanges.Count;

        TempR.Emin:= Points[0];
        TempR.Emax:= Points[1];
        TempR:= ReorderRect2d(TempR);
        temp:= (TempR.Emax.Y - TempR.Emin.Y) / Succ(RowCount);

        For I:= Columns.Count to 2 do
          Columns.Add;
        { configure the table columns accordingly to the Ranges }
        With Columns[0] Do
        Begin
          Title.Caption:= Legend.Title0;
          If Length(Legend.Title0)>0 Then
            Width:= 0.50 //PreviewBox1.Grapher.DistToRealY(PreviewBox1.Canvas.TextWidth(Legend.Title0) + 4)
          Else
            Width:= temp * 1.5;

          tempFont.Name:= Legend.TitleFont.Name;
          tempFont.Style:= Legend.TitleFont.Style;
          tempFont.Height:= PreviewBox1.Grapher.PointsToDistY(Legend.TitleFont.Height);
          tempFont.Color:= Legend.TitleFont.Color;
          Title.Font:= TempFont;
          Title.Transparent:= Legend.TitleTransparent;
          Title.Color:= Legend.FixedColor;
          Title.Alignment:= Legend.TitleAlignment;

          Transparent:= Legend.Transparent;
          ColumnType:= Legend.LegendStyle;
          tempFont.Name:= Legend.Font.Name;
          tempFont.Style:= Legend.Font.Style;
          tempFont.Color:= Legend.Font.Color;
          tempFont.Height:= PreviewBox1.Grapher.PointsToDistY(Legend.Font.Size);
          Font:= TempFont;
          Color:= Legend.Color;
          For I:= 0 to RowCount-1 do
          Begin
            Case Legend.LegendStyle Of
              ctLabel:
                begin
                // presumably column 0 never will be this type
                end;
              ctColor:
                Strings[I]:= IntToStr(Legend.LegendRanges[I].BrushStyle.ForeColor);
              ctLineStyle:
                Strings[I]:= IntToStr(Legend.LegendRanges[I].PenStyle.Style);
              ctBrushStyle:
                Strings[I]:= IntToStr(Legend.LegendRanges[I].BrushStyle.Pattern);
              ctSymbolStyle:
                Strings[I]:= IntToStr(Legend.LegendRanges[I].SymbolStyle.Index);
              ctBitmap:
                Strings[I]:= IntToStr(Legend.LegendRanges[I].ImageIndex);
            End;
          End;
        End;
        { first third column in order to calculate second column width}
        With Columns[2] Do
        Begin
          Title.Caption:= Legend.Title2;
          Width:= 0.60;  //PreviewBox1.Grapher.DistToRealY(Legend.Canvas.TextWidth('99999999'));

          tempFont.Name:= Legend.TitleFont.Name;
          tempFont.Style:= Legend.TitleFont.Style;
          tempFont.Height:= PreviewBox1.Grapher.PointsToDistY(Legend.TitleFont.Size);
          tempFont.Color:= Legend.TitleFont.Color;
          Title.Font:= TempFont;
          Title.Transparent:= Legend.TitleTransparent;
          Title.Color:= Legend.FixedColor;
          Title.Alignment:= Legend.TitleAlignment;

          Transparent:= Legend.Transparent;

          ColumnType:= ctLabel;
          Color:= Legend.Color;
          tempFont.Name:= Legend.Font.Name;
          tempFont.Style:= Legend.Font.Style;
          tempFont.Color:= Legend.Font.Color;
          tempFont.Height:= PreviewBox1.Grapher.DistToRealY(Legend.Font.Height);
          Font:= TempFont;
          For I:= 0 to RowCount-1 do
          begin
            Strings[I]:= IntToStr( Legend.LegendRanges[I].Frequency );
          end;
          Alignment:= taRightJustify;
        End;
        With Columns[1] Do
        Begin
          Title.Caption:= Legend.Title1;
          Width:= (tempR.Emax.X - tempR.Emin.X) - (Columns[0].Width + Columns[2].Width) - 0.01;

          tempFont.Name:= Legend.TitleFont.Name;
          tempFont.Style:= Legend.TitleFont.Style;
          tempFont.Height:= PreviewBox1.Grapher.PointsToDistY(Legend.TitleFont.Size);
          tempFont.Color:= Legend.TitleFont.Color;
          Title.Font:= TempFont;
          Title.Transparent:= Legend.TitleTransparent;
          Title.Color:= Legend.FixedColor;
          Title.Alignment:= Legend.TitleAlignment;

          Transparent:= False;//Legend.Transparent;

          ColumnType:= ctLabel;
          Color:= Legend.Color;
          tempFont.Name:= Legend.Font.Name;
          tempFont.Style:= Legend.Font.Style;
          tempFont.Color:= Legend.Font.Color;
          tempFont.Height:= PreviewBox1.Grapher.PointsToDistY(Legend.Font.Size);
          Font:= TempFont;
          For I:= 0 to RowCount-1 do
          begin
            if Length(Legend.LegendRanges[I].SubLegend)>0 then
              temps:= Legend.LegendRanges[I].Legend + #10#13 + Legend.LegendRanges[I].SubLegend
            else
              temps:= Legend.LegendRanges[I].Legend;
            Strings[I]:= temps;
          end;
          Alignment:= taLeftJustify;
        End;
      End;
      AddEntity('',LegendEntity);
      LegendEntity.Free;
    End;

    { *************** end of legend }
{$ENDIF}

    { print the scale in a table }
    tbl:= TEzTableEntity.CreateEntity(Point2D(3.5,-9.6), Point2D(4.2,-9.9));
    try
      with tbl do
      begin
        Pentool.Style:= 0;     { no outer border }
        Options := [ezgoVertLine, ezgoHorzLine];
        RowCount:= 1;
        TitleHeight:= 1.8;
        //RowHeight:= 0.50;
        with Columns.Add do
        begin
          Title.Caption:= 'Scale';
          Title.Alignment:= taCenter;
          Title.Color:= clSilver;
          Title.Transparent:= false;
          fs.Name:= 'Verdana';
          fs.Height:= 0.15;
          fs.Color:= clBlack;
          fs.Style:= [fsBold];
          Title.Font:= fs;
          Width:= 0.6;
          Alignment:= taCenter;
          Color:= clSilver;
          Transparent:= false;
          fs.Name:= 'Arial';
          fs.Height:= 0.12;
          fs.Color:= clBlack;
          fs.Style:= [];
          Font:= fs;
        end;
        LoweredColor:= GridStyle.Color;
        Columns[0].Strings[0]:= Format('%d:%.4f', [1,DrawingUnits/PlottedUnits]);
      end;
      AddEntity('',tbl);
    finally
      tbl.free;
    end;

    { create an owner draw table.}
    tbl:= TEzTableEntity.CreateEntity(Point2D(4.3,-9.6), Point2D(8,-10.3));
    try
      with tbl do
      begin
        Pentool.Scale:= 0.02;
        Pentool.Style:= 1;
        Pentool.Color:= clNavy;
        Brushtool.Pattern:= 1;
        Brushtool.Color:= clBtnFace;
        BorderWidth:= 0.02;
        gs.Style:= 1;
        gs.visible:=true;
        gs.Color:=clBlack;
        gs.Width:= 0.01;
        GridStyle:= gs;
        LoweredColor:= clSilver;
        OwnerDraw:= True;   // this is an owner draw table ^^
        { the OnDrawCell event will be set in the OnPaintEntity Event of PreviewBox1.Activemap }
        PreviewBox1.GIS.OnBeforePaintEntity:= Self.MyPaintEntity;
        //OnDrawCell:= Self.TableDrawCell;   // link to event handler
        Options := [ezgoVertLine, ezgoHorzLine];  // draw horz, and vert lines
        RowCount:= 2;     // number of rows (not including header)
        { add two columns }
        with Columns.Add do    // first column added
        begin
          Width:= 1.1;
          Title.Color:= clBtnFace;
          Title.Transparent:= false;
          Color:= clBtnFace;
          Transparent:= FALSE;
        end;
        with Columns.Add do    // second column added
        begin
          Width:= 1.1;
          Title.Color:= clBtnFace;
          Title.Transparent:= false;
          Color:= clBtnFace;
          Transparent:= FALSE;
        end;
        with Columns.Add do    // Third column added
        begin
          Width:= 0.8;
          Title.Color:= clBtnFace;
          Title.Transparent:= false;
          Color:= clBtnFace;
          Transparent:= FALSE;
        end;
      end;
      AddEntity('',tbl);
      { save the identifier for the owner draw table that will be used in event
        OnPaintEntity }
      FTableOwnerDrawID:= tbl.ID;
    finally
      tbl.free;
    end;

    { print a rectangle }
    {Pentool.Style:=1;
    Pentool.Color:=clBlack;
    Pentool.Width:=0;
    Brushtool.Pattern:= 0; // no fill
    Rectangle(0.34,4.87,7.70,9.88);

    (* print an image *)
    R:=Rect2D(0.34,4.87,7.70,9.88);
    InflateRect2D(R,-0.2,-0.2);
    with R do
      PrintImage('..\..\Data\Globe.bmp',X1,Y1,X2,Y2);  }
  end;
end;

procedure TfrmDemoPreview.MyPaintEntity( Sender: TObject;
                                         Layer: TEzBaseLayer;
                                         Recno: Integer;
                                         Entity: TEzEntity;
                                         Grapher: TEzGrapher;
                                         Canvas: TCanvas;
                                         const Clip: TEzRect;
                                         DrawMode: TEzDrawMode;
                                         var CanShow: Boolean;
                                         Var EntList: TEzEntityList;
                                         Var AutoFree: Boolean );
begin
  if Entity.ID = FTableOwnerDrawID then
  begin
  //if (Entity is TTable2D) and (TTable2D(Entity).OwnerDraw=True) then
    TEzTableEntity(Entity).OwnerDraw:= True;
    TEzTableEntity(Entity).DefaultDrawing:= true; { causes to draw the background }
    TEzTableEntity(Entity).OnDrawCell:= Self.TableDrawCell;   // link to event handler
  end;
end;

procedure TfrmDemoPreview.TableDrawCell(Sender: TObject; ACol, ARow: Longint;
  Cnv: TCanvas; Grapher: TEzGrapher; Rect: TRect);
var
  R: TEzRect;
  Text: string;
  { vars used for printing a bitmap }
{$IFDEF FALSE}    // uncomment if you want to use this
  GraphicLink: ezbase.TEzGraphicLink;
{$ENDIF}
  hBMP: HBitmap;
  bmp: TBitmap;
  { vars used for printing a symbol }
  Symbol: TEzSymbol;  // a pointer to the symbol obtained from a TSymbols component
  Index: Integer;     // the symbol to print
  TmpGrapher: TEzGrapher;
  MarginX, MarginY: double;

  procedure BitmapToPrinter(Canvas: TCanvas; DestRect: TRect;
    ABitmap: TBitmap; L, T, W, H: Integer);
  var
    Info: PBitmapInfo;
    Image: Pointer;
    Tc: Integer;
    InfoSize, ImageSize: DWORD;
  begin
    GetDIBSizes(ABitmap.Handle, InfoSize, ImageSize);
    Info := AllocMem(InfoSize);
    Image := GlobalAllocPtr(HeapAllocFlags, ImageSize);
    try
      with ABitmap do
        GetDIB(Handle, Palette, Info^, Image^);
      Tc := T;
      if Info^.bmiHeader.biHeight > 0 then
        Tc := Info^.bmiHeader.biHeight - H - T;
      with DestRect do
        StretchDIBits(Canvas.Handle, Left, Top, (Right - Left), (Bottom - Top),
          L, Tc, W, H, Image, Info^, DIB_RGB_COLORS, SRCCOPY);
    finally
      if InfoSize < 65535 then
        FreeMem(Info,InfoSize)
      else
        GlobalFreePtr(Info);
      GlobalFreePtr(Image);
    end;
  end;

  procedure MyPrintBitmap(abmp: TBitmap);
  var
    hPaintPal, hOldPal: HPalette;                  {Used for realizing the palette}
    R: TRect;
  begin
    R:= Rect;
    InflateRect(R,-1,-1);
    hPaintPal:= abmp.Palette;
    hOldPal:= SelectPalette(Cnv.Handle, hPaintPal, False);
    try
      RealizePalette(Cnv.Handle);
      SetStretchBltMode(Cnv.Handle, STRETCH_DELETESCANS);
      if Grapher.Device = adScreen then    // this goes to the screen
      begin
        StretchBlt(Cnv.Handle, Rect.Left, Rect.Top,
          (Rect.Right - Rect.Left), (Rect.Bottom - Rect.Top),
          abmp.Canvas.Handle, 0, 0, abmp.Width, abmp.Height, SRCCOPY);
      end else    // this goes to the printer
      begin
          BitmapToPrinter(Cnv,Rect,abmp,0,0,abmp.Width,abmp.Height);
      end;
    finally
      if hOldPal <> 0 then
        SelectPalette(Cnv.Handle, hOldPal, False);
    end;
  end;


begin
  { U can draw here anything you want }

  { calculate real world coordinates. Not used in this example }
  R:= Grapher.RectToReal(Rect);

  { draw to the cell }
  if ARow=0 then   // the titles
  begin
    Cnv.Font.Name:= 'Verdana';
    Cnv.Font.Style:=[fsBold];
    Cnv.Font.Size:= round(Grapher.DistToPointsY(0.08));    // 0.08 of an inch the text height
    Cnv.Font.Color:= clBlue;
    // Cnv can be a screen canvas (if it is a preview) or Printer canvas if you are printing
    Text:= Format('Owner Draw Col. # %d',[ACol]);
    SetBkMode(Cnv.Handle, TRANSPARENT);
    Windows.DrawText(Cnv.Handle, PChar(Text), -1, Rect, DT_CENTER or DT_SINGLELINE or DT_VCENTER);
  end else    // the cells
  begin
    if (ARow=1) and (ACol=0) then
    begin
      { here we will draw a bitmap as an example }
      // this method will use activemap classes for loading a bitmap from disk
      {$IFDEF FALSE}    // uncomment if you want to use this
      GraphicLink:= EzBase.GraphicLinkClass.Create(nil);
      try
        GraphicLink.readBMP('..\..\..\Demos\Data\globe.bmp', Cnv);
        MyPrintBitmap(GraphicLink.Bitmap);
      finally
        GraphicLink.Free;
      end;
      {$ENDIF}
      {.$IFDEF FALSE}    // uncomment if you want to use this
      { Here we will use a resource bitmap that we already know that exists in the .exe file}
      hBMP := LoadBitmap(HInstance, PChar('BBOK'));
      bmp:= TBitmap.Create;
      bmp.Handle := hBMP;
      try
        MyPrintBitmap(bmp);
      finally
        DeleteObject(bmp.Handle);
        bmp.free;
      end;
      {.$ENDIF}
    end else if (ARow=2) and (ACol=0) then    // how to print a symbol
    begin
      Index:= 1;    // change here to the symbol you want to print
      Symbol:= Ez_Symbols[Index];
      TmpGrapher:= TEzGrapher.Create(10,Grapher.Device);
      try
        with Rect do
          { define the viewport }
          TmpGrapher.SetViewport(Left, Top, Right, Bottom);
        with Symbol.Extension do
        begin
          MarginX:= (Emax.X - Emin.X) / 20;
          MarginY:= (Emax.Y - Emin.Y) / 20;
          { define the window viewport }
          TmpGrapher.SetWindow(Emin.X - MarginX, EMax.X + MarginX,
            Emin.Y - MarginY, Emax.Y + MarginY);
        end;
        { now draw the symbol }
        Symbol.Draw(TmpGrapher, Cnv,
          TmpGrapher.CurrentParams.VisualWindow, IDENTITY_MATRIX2D, dmNormal);
        { these are the parameters for drawing a symbol (extracted from unit Entity2d.pas :
            procedure TSymbol2D.Draw(P: TMapPreferences; Grapher: TGrapher2D; Cnv: TCanvas;
              const Clip: TRect2D; const Matrix: TMatrix2D; ReplaceColor: TColor;
              DrawMode: TDrawMode; const ScaleTextHeight, Rotangle: Double); }
      finally
        TmpGrapher.Free;
      end;
    end else
    begin
      Cnv.Font.Name:= 'Arial';
      Cnv.Font.Style:=[];
      Cnv.Font.Size:= round(Grapher.DistToPointsY(0.085));    // 0.07 inch text height
      Cnv.Font.Color:= clTeal;
      Text:= Format('Row %d, Col %d', [ARow, ACol]);
      SetBkMode(Cnv.Handle, TRANSPARENT);
      Windows.DrawText(Cnv.Handle, PChar(Text), -1, Rect, DT_LEFT or DT_SINGLELINE or DT_VCENTER);
    end;
  end;
end;

procedure TfrmDemoPreview.btnZoomWClick(Sender: TObject);
begin
  CmdLine1.DoCommand('ZOOMWIN','');
end;

procedure TfrmDemoPreview.btnZoomPreviousClick(Sender: TObject);
begin
  PreviewBox1.ZoomPrevious;
end;

procedure TfrmDemoPreview.btnScrollClick(Sender: TObject);
begin
   CmdLine1.DoCommand('SCROLL','');
end;

procedure TfrmDemoPreview.btnMoveClick(Sender: TObject);
begin
  CmdLine1.DoCommand('MOVE','');
end;

procedure TfrmDemoPreview.btnScaleClick(Sender: TObject);
begin
  CmdLine1.DoCommand('SCALE','');
end;

procedure TfrmDemoPreview.btnRotateClick(Sender: TObject);
begin
  CmdLine1.DoCommand('ROTATE','');
end;

procedure TfrmDemoPreview.btnReshapeClick(Sender: TObject);
begin
  CmdLine1.DoCommand('RESHAPE','');
end;

procedure TfrmDemoPreview.btnMeasClick(Sender: TObject);
begin
  CmdLine1.DoCommand('MEASURES','');
end;

procedure TfrmDemoPreview.PreviewBox1MouseMove2D(Sender: TObject;
  Shift: TShiftState; X, Y: Integer; const WX, WY: Double);
begin
  StatusBar1.Panels[1].Text := PreviewBox1.CoordsToDisplayText(WX,-WY);
end;

procedure TfrmDemoPreview.PreviewBox1GridError(Sender: TObject);
begin
  StatusBar1.Panels[0].Text := 'Grid too dense to display';
end;

procedure TfrmDemoPreview.CmdLine1StatusMessage(Sender: TObject;
  const Message: String);
begin
  StatusBar1.Panels[0].Text := Message;
end;

procedure TfrmDemoPreview.PreviewBox1ZoomChange(Sender: TObject;
  const Scale: Double);
begin
   StatusBar1.Panels[2].Text := '1:'+Format('%.2n',[Scale]);
end;

procedure TfrmDemoPreview.PreviewBox1BeginRepaint(Sender: TObject);
begin
  StatusBar1.Panels[0].Text := '';
  if frmMosaic <> Nil then frmMosaic.MosaicView1.Invalidate;
end;

procedure TfrmDemoPreview.btnFullPageClick(Sender: TObject);
begin
  PreviewBox1.ZoomToPaper;
end;

procedure TfrmDemoPreview.BtnFitPageClick(Sender: TObject);
var
  w,x1,y1,x2,margin:Double;
begin
  with PreviewBox1 do
  begin
    x1:=PaperShp.Points[0].X;
    x2:=PaperShp.Points[1].X;
    y1:=PaperShp.Points[0].Y;
    w:=abs(x2-x1);
    margin:= w/40;
    SetViewTo(x1-margin,y1+margin,(x1+w)+margin,y1-1);
  end;
end;

procedure TfrmDemoPreview.btntextClick(Sender: TObject);
begin
  CmdLine1.DoCommand('TEXT','');
end;

procedure TfrmDemoPreview.BtnRectSelectClick(Sender: TObject);
begin
  CmdLine1.DoCommand('SELECT','');
end;

procedure TfrmDemoPreview.btnBitmapClick(Sender: TObject);
begin
  CmdLine1.DoCommand('PICTUREREF','');
end;

procedure TfrmDemoPreview.btnLineClick(Sender: TObject);
begin
  CmdLine1.DoCommand('LINE','');
end;

procedure TfrmDemoPreview.btnPLineClick(Sender: TObject);
begin
  CmdLine1.DoCommand('PLINE','');
end;

procedure TfrmDemoPreview.btnPolygonClick(Sender: TObject);
begin
  CmdLine1.DoCommand('POLYGON','');
end;

procedure TfrmDemoPreview.btnRectClick(Sender: TObject);
begin
  CmdLine1.DoCommand('RECTANGLE','');
end;

procedure TfrmDemoPreview.btnArcClick(Sender: TObject);
begin
  CmdLine1.DoCommand('ARC','');
end;

procedure TfrmDemoPreview.btnEllipseClick(Sender: TObject);
begin
  CmdLine1.DoCommand('ELLIPSE','');
end;

procedure TfrmDemoPreview.btnMapClick(Sender: TObject);
var
  Preview:TEzPreviewEntity ;
  FileNo: Integer;
begin
  if PreviewBox1.GISList.Count=0 then
    raise Exception.Create('No maps to place on the paper');
  FileNo:= 0;
  Preview:= TEzPreviewEntity.CreateEntity(Point2D(0,0),Point2D(0,0), pmAll, FileNo);
  { define an original proposed print area }
  Preview.ProposedPrintArea:= PreviewBox1.GISList[FileNo].GIS.MapInfo.LastView;
  Preview.PaperUnits := PreviewBox1.PaperUnits;
  CmdLine1.Push(TAddEntityAction.CreateAction(CmdLine1, Preview,Point(0,0)), true, '', '');
end;

procedure TfrmDemoPreview.FormCreate(Sender: TObject);
var
  Path: string;
begin
  PreviewBox1.BeginUpdate;
  FFirstTime:= true;
  Path:= AddSlash(ExtractFilePath(ExpandFilename('..\..\data\*.*')));
  //FTileBitmap:= TBitmap.create;
  //FTileBitmap.LoadFromFile(Path + 'yellow_stucco.bmp');

  //PreviewBox1.TileBitmap:= FTileBitmap;
end;

procedure TfrmDemoPreview.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  FTileBitmap.free;
  if frmMosaic <> Nil then FreeAndNil( frmMosaic) ;
  If FfrmAccuDraw <> Nil then FreeAndNil( FfrmAccuDraw );
end;

procedure TfrmDemoPreview.btnExitClick(Sender: TObject);
begin
  CmdLine1.Clear;
  Close;
end;

procedure TfrmDemoPreview.Alignment1Click(Sender: TObject);
begin
  fAlignment.WinHandle:= Self.Handle;
  TfrmAlignPalette.Create(Application).Enter(Self.PreviewBox1);
end;

procedure TfrmDemoPreview.BtnOptionsClick(Sender: TObject);
var
  TmpPt: TPoint;
begin
  TmpPt := Self.ClientToScreen(Point(BtnOptions.Left,BtnOptions.Top + BtnOptions.Height));
  Popupmenu1.Popup( TmpPt.x, TmpPt.y );
end;

procedure TfrmDemoPreview.SizeandPosition1Click(Sender: TObject);
begin
  if PreviewBox1.Selection.NumSelected = 0 then
  begin
    showmessage('No entities selected !');
    exit;
  end;
  with TfrmSizePos.create(Nil) do
    try
      enter(Self.PreviewBox1);
    finally
      free;
    end;
end;

procedure TfrmDemoPreview.PreviewBox1ShowHint(Sender: TObject;
  Layer: TEzBaseLayer; Recno: Integer; var Hint: String;
  var ShowHint: Boolean);
var
  Ent: TEzEntity;
  SUnits: string;
begin
  Ent:= Layer.LoadEntityWithRecno(Recno);
  try
    ShowHint:= true;
    Hint:= Ent.ClassName;
    if Ent.EntityID = idPreview then
    begin
      with TEzPreviewEntity(Ent) do
      begin
        if PaperUnits=suInches then
          SUnits:= 'Inch'
        else
          SUnits:= 'Mm';
        Hint := Hint + #13#10 +
                Format('Scale 1 %s -> %f drawing units',[SUnits, DrawingUnits/PlottedUnits]);
      end;
    end;
  finally
    Ent.free;
  end;
end;

procedure TfrmDemoPreview.btnHintsClick(Sender: TObject);
begin
  CmdLine1.DoCommand('HINTS','');
end;

procedure TfrmDemoPreview.BtnCircle3PClick(Sender: TObject);
begin
  CmdLine1.DoCommand('CIRCLECR','');
end;

procedure TfrmDemoPreview.BtnCircleCRClick(Sender: TObject);
begin
  CmdLine1.DoCommand('CIRCLE3P','');
end;

procedure TfrmDemoPreview.PreviewBox1EntityDblClick(Sender: TObject;
  Layer: TEzBaseLayer; RecNo: Integer; var Processed: Boolean);
var
  Ent: TEzEntity;
begin
  Ent:= Layer.LoadEntityWithRecno(Recno);
  try
    if Ent.EntityID = idRtfText then
    begin
      if TfrmRichTextEditor.Enter(Ent) = mrOk then
        Layer.UpdateEntity(Recno, Ent);
    end;
  finally
    Ent.Free;
  end;
end;

procedure TfrmDemoPreview.Print1Click(Sender: TObject);
begin
  if Printer.Printing then Exit;
  PreviewBox1.Print;
end;

procedure TfrmDemoPreview.Exit1Click(Sender: TObject);
begin
  Close;
end;

procedure TfrmDemoPreview.Cut1Click(Sender: TObject);
begin
  PreviewBox1.Undo.CopyToClipboardFromSelection;
  PreviewBox1.DeleteSelection;
  PreviewBox1.Repaint;
end;

procedure TfrmDemoPreview.Copy1Click(Sender: TObject);
begin
  PreviewBox1.Undo.CopyToClipboardFromSelection;
end;

procedure TfrmDemoPreview.Paste1Click(Sender: TObject);
begin
  PreviewBox1.Undo.PasteFromClipboardTo();
end;

procedure TfrmDemoPreview.Delete1Click(Sender: TObject);
begin
  PreviewBox1.DeleteSelection;
end;

procedure TfrmDemoPreview.Linestyle1Click(Sender: TObject);
begin
  with TfrmLineType.create(Nil) do
    try
      Enter(self.PreviewBox1);
    finally
      free;
    end;
end;

procedure TfrmDemoPreview.Fillstyle1Click(Sender: TObject);
begin
  with TfrmBrushStyle.create(Nil) do
    try
      Enter(PreviewBox1);
    finally
      free;
    end;
end;

procedure TfrmDemoPreview.Symbolstyle1Click(Sender: TObject);
begin
  with TfrmBrushStyle.create(Nil) do
    try
      Enter(PreviewBox1);
    finally
      free;
    end;
end;

procedure TfrmDemoPreview.Textstyle1Click(Sender: TObject);
begin
  with TfrmFontStyle.create(Nil) do
    try
      Enter(self.PreviewBox1);
    finally
      free;
    end;
end;

procedure TfrmDemoPreview.BtnGraphInfoClick(Sender: TObject);
begin
  { defines the parent of the inspector form }
  InspParentHWND:= Self.Handle;

  TfrmInspector.Create(Nil).Enter(CmdLine1);

  { start the action for the inspector }
  {CmdLine1.Clear;
  CmdLine1.Push(TEditGraphicPropsAction.CreateAction(CmdLine1), True, '', '');}
end;

procedure TfrmDemoPreview.SpeedButton3Click(Sender: TObject);
begin
 CmdLine1.Clear;
 CmdLine1.DoCommand('TABLE','');
end;

procedure TfrmDemoPreview.btnFittedTextClick(Sender: TObject);
begin
  CmdLine1.DoCommand('FITTEDTEXT','');
end;

procedure TfrmDemoPreview.btnJustTextClick(Sender: TObject);
begin
  CmdLine1.DoCommand('JUSTIFTEXT','');
end;

procedure TfrmDemoPreview.SpeedButton4Click(Sender: TObject);
begin
  if frmMosaic = Nil then
  begin
    ParentMosaicHWND:= Self.Handle;
    frmMosaic:= TfrmMosaic.Create(Application);
    frmMosaic.MosaicView1.ParentView:= Self.PreviewBox1;
  end;
  frmMosaic.Show;
end;

procedure TfrmDemoPreview.WMEnterSizeMove(var m: TMessage);
begin
  inherited;
  PreviewBox1.BeginUpdate;
  FOldWidth:= Previewbox1.width;
  FOldheight:=Previewbox1.Height;
end;

procedure TfrmDemoPreview.WMExitSizeMove(var m: TMessage);
begin
  inherited;
  if (PreviewBox1.Width = FOldWidth) And (PreviewBox1.Height = FOldHeight) then
    PreviewBox1.CancelUpdate
  else
    PreviewBox1.EndUpdate;
end;

procedure TfrmDemoPreview.PreviewBox1GisTimer(Sender: TObject;
  var CancelPainting: Boolean);
var
  Msg: TMsg;
begin
  Previewbox1.Refresh;
  // is a message waiting on the message pool ?
  if PeekMessage(Msg, Handle, WM_KEYDOWN, WM_KEYDOWN, PM_REMOVE) and
     {(Msg.Message = WM_KEYDOWN) and} (Msg.WParam = VK_ESCAPE) then
  begin
    CancelPainting:= true;
    exit;
  end;
  if PeekMessage(Msg, Handle, WM_LBUTTONDOWN, WM_LBUTTONDOWN, PM_NOREMOVE) then
    //Msg.Message >= WM_LBUTTONDOWN then
  begin
    CancelPainting:= true;
    exit;
  end;
  if PeekMessage(Msg, Handle, WM_LBUTTONDBLCLK, WM_LBUTTONDBLCLK, PM_NOREMOVE) then
    //Msg.Message >= WM_LBUTTONDBLCLK then
  begin
    CancelPainting:= true;
    exit;
  end;
  if PeekMessage(Msg, Handle, WM_RBUTTONDOWN, WM_RBUTTONDOWN, PM_NOREMOVE) then
    //Msg.Message >= WM_RBUTTONDOWN then
  begin
    CancelPainting:= true;
    exit;
  end;
  if PeekMessage(Msg, Handle, WM_HSCROLL, WM_VSCROLL, PM_NOREMOVE) and
    (Msg.Message = WM_HSCROLL) or (Msg.Message = WM_VSCROLL) then
  begin
    CancelPainting:= true;
    exit;
  end;
  if PeekMessage(Msg, Handle, WM_MBUTTONDOWN, WM_MBUTTONDOWN, PM_NOREMOVE) then
    //Msg.Message >= WM_MBUTTONDOWN then
  begin
    CancelPainting:= true;
    exit;
  end;
  if PeekMessage(Msg, Handle, WM_MBUTTONDBLCLK, WM_MBUTTONDBLCLK, PM_NOREMOVE) then
    //Msg.Message >= WM_MBUTTONDBLCLK then
  begin
    CancelPainting:= true;
    exit;
  end;
end;


procedure TfrmDemoPreview.FormPaint(Sender: TObject);
begin
  if FFirstTime then
  begin
    FFirstTime:=false;
    PreviewBox1.ZoomToPaper;
    PreviewBox1.Grapher.Clear;
    PreviewBox1.EndUpdate;
  end;
end;

procedure TfrmDemoPreview.Show1Click(Sender: TObject);
begin
  Show1.Checked:=not AccuDraw1.Checked;
  if Show1.Checked then
  begin
    { create the aerial view }
    if FfrmAccuDraw=nil then
      FfrmAccuDraw:= TfrmAccuDrawPreview.Create(Nil);
    FfrmAccuDraw.Show;
    ActiveControl:= PreviewBox1;
  end else if Assigned( FfrmAccuDraw ) then
    FreeAndNil( FfrmAccuDraw );
end;

procedure TfrmDemoPreview.Configure1Click(Sender: TObject);
begin
  with TfrmAccuDrawSetts.create(nil) do
    try
      if (Enter(Self.CmdLine1)=mrOk) and Self.CmdLine1.AccuDraw.Enabled then
        PreviewBox1.Refresh;
    finally
      free;
    end;
end;

procedure TfrmDemoPreview.UnRotate1Click(Sender: TObject);
begin
  CmdLine1.AccuDraw.ShowUnrotated;
end;

procedure TfrmDemoPreview.ChangeOrigin1Click(Sender: TObject);
begin
  { the AccuDraw origin will be defined to the last position on the draw box
    ( If AccuDraw is not visible, the command will be ignored )
  }
  CmdLine1.AccuDraw.ChangeOrigin( CmdLine1.GetSnappedPoint );
  { you also can define like this in order to preserve AccuDraw current rotation angle
    (Angle is an optional parameter with default value 0 ) }
  //CmdLine1.AccuDraw.ChangeOrigin( CmdLine1.CurrentSnappedPoint, CmdLine1.AccuDraw.Rotangle );
end;

procedure TfrmDemoPreview.CmdLine1AccuDrawChange(Sender: TObject);
var
  DX,DY: Double;
begin
  If FfrmAccuDraw=Nil Then Exit;
  FfrmAccuDraw.InUpdate:= True;
  try
    with FfrmAccuDraw, CmdLine1.AccuDraw do
    begin
      If FrameStyle = fsPolar then
      begin
        Label1.Caption:= 'Delta X: ';
        Label2.Caption:= 'Delta Y: ';
      end else
      begin
        Label1.Caption:= 'Distance: ';
        Label2.Caption:= 'Angle   : ';
      end;

      CmdLine1.AccuDraw.CurrentDimensions( DX, DY );
      NumEd1.NumericValue:= DX;   // delta x or distance
      If FrameStyle = fsRectangular Then  // delta y or angle
        NumEd2.NumericValue:= DY
      else
        NumEd2.NumericValue:= RadToDeg( DY );
      ChkX.Checked:= DeltaXLocked;
      ChkY.Checked:= DeltaYLocked;
    end;
  finally
    FfrmAccuDraw.InUpdate:= False;
  end;
end;

procedure TfrmDemoPreview.CmdLine1AccuDrawActivate(Sender: TObject);
begin
  If CmdLine1.AccuDraw.Enabled then
  begin
    If FfrmAccuDraw = Nil then
    begin
      FfrmAccuDraw := TfrmAccuDrawPreview.Create(Nil);
      FfrmAccuDraw.Left:= Previewbox1.Left;
      FfrmAccuDraw.Top:= Previewbox1.Top;
    end;

    If CmdLine1.AccuDraw.FrameStyle=fsPolar then
      FfrmAccuDraw.BtnPolar.Down:= true
    else If CmdLine1.AccuDraw.FrameStyle=fsRectangular then
      FfrmAccuDraw.BtnRect.Down:= true;
    with FfrmAccuDraw do
    begin
      NumEd1.NumericValue:= 0;
      NumEd2.NumericValue:= 0;
      chkX.Checked:= false;
      chkY.Checked:= false;
    end;
    FfrmAccuDraw.Show;
    Windows.SetFocus( Self.Handle );
  end;
end;

procedure TfrmDemoPreview.Rotate1Click(Sender: TObject);
var
  Code: Integer;
  S: string;
  Rot:Double;
begin
  S:= InputBox( 'Rotate AccuDraw', 'Rotation angle', FloatToStr( RadToDeg(CmdLine1.AccuDraw.Rotangle) ));
  If S='' then Exit;
  Val(S, Rot, Code);
  If Code<>0 then Exit;
  CmdLine1.AccuDraw.ChangeOrigin( CmdLine1.AccuDraw.AccuOrigin, DegToRad(Rot) );
end;

procedure TfrmDemoPreview.CopyToWindows1Click(Sender: TObject);
var
  I,J: Integer;
  SelLayer: TEzSelectionLayer;
  temp: string;
  Ent: TEzEntity;
  TempDecSep: Char;
begin
  if PreviewBox1.Selection.Count=0 then exit;
  TempDecSep:= DecimalSeparator;
  DecimalSeparator:= '.'; // numbers always must be with this decimal separator
  temp:= '';
  Screen.Cursor:=crHourglass;
  for I:= 0 to PreviewBox1.Selection.Count-1 do
  begin
    SelLayer:= PreviewBox1.Selection[I];
    for J:= 0 to SelLayer.SelList.Count-1 do
    begin
      ent:= SelLayer.Layer.LoadEntityWithRecno(SelLayer.SelList[J]);
      if ent=nil then continue;
      try
        { set the attached table to same record in order to retrieve correct db info }
        //activate next two lines and deactivate third line if you want to copy data info also
        //SelLayer.Layer.DbTable.Recno:= SelLayer.SelList[J];
        //temp:= temp + ent.AsString(True,True,SelLayer.Layer.DbTable); // atributes and data
        temp:= temp + ent.AsString(True,False,Nil); // atributes and basic data only
      finally
        ent.free;
      end;
    end;
  end;
  Screen.Cursor:=crDefault;
  DecimalSeparator:= TempDecSep;
  Clipboard.AsText:= temp;
end;

procedure TfrmDemoPreview.PastefromWindowsClipboard1Click(Sender: TObject);
begin
  CmdLine1.DoCommand( Clipboard.AsText, '' );
end;

procedure TfrmDemoPreview.Undo1Click(Sender: TObject);
begin
  If Not PreviewBox1.Undo.CanUndo Then Exit;
  Screen.Cursor:= crHourglass;
  PreviewBox1.Selection.Clear;
  PreviewBox1.Undo.Undo;
  PreviewBox1.Repaint;
  Screen.Cursor:= crDefault;
end;

end.
