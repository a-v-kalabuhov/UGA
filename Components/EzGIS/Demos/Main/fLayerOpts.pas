unit fLayerOpts;

{$I EZ_FLAG.PAS}
interface                            

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, Buttons, EzBaseGis, ExtCtrls, EzUtils, EzBase, EzNumEd,
  Db, Grids, DBGrids, EzTable, ComCtrls, EzMiscelCtrls, EzColorPicker,
  CheckLst;

type
  TfrmLayerOptions = class(TForm)
    Panel1: TPanel;
    Button1: TButton;
    Button2: TButton;
    dxPageControl1: TPageControl;
    dxTabSheet11: TTabSheet;
    Label25: TLabel;
    Label26: TLabel;
    Label27: TLabel;
    EzColorBox8: TEzColorBox;
    dxCheckEdit19: TCheckBox;
    dxTabSheet1: TTabSheet;
    dxPageControl2: TPageControl;
    dxTabSheet7: TTabSheet;
    dxchkOverridePen: TCheckBox;
    ezPenStyleBox1: TEzLinetypeGridBox;
    ezPenColorBox1: TEzColorBox;
    dxKeepSamePen1: TCheckBox;
    dxTabSheet8: TTabSheet;
    dxCheckEdit2: TCheckBox;
    BrushBox1: TEzBrushPatternGridBox;
    EzForeColor1: TEzColorBox;
    EzBackColor1: TEzColorBox;
    dxTabSheet9: TTabSheet;
    dxchkSymbolOverr: TCheckBox;
    EzSymbolsGridBox1: TEzSymbolsGridBox;
    dxCheckEdit5: TCheckBox;
    dxTabSheet10: TTabSheet;
    dxCheckEdit6: TCheckBox;
    ListBox1: TListBox;
    EzColorGridBox5: TEzColorBox;
    dxCheckEdit7: TCheckBox;
    chkBold: TCheckBox;
    chkItalic: TCheckBox;
    chkUnderline: TCheckBox;
    chkStrikeout: TCheckBox;
    dxTabSheet2: TTabSheet;
    dxPageControl3: TPageControl;
    dxTabSheet12: TTabSheet;
    Label12: TLabel;
    Label14: TLabel;
    dxCheckEdit8: TCheckBox;
    dxTabSheet13: TTabSheet;
    Label15: TLabel;
    Label16: TLabel;
    dxCheckEdit9: TCheckBox;
    dxTabSheet3: TTabSheet;
    Label17: TLabel;
    Label18: TLabel;
    dxCheckEdit10: TCheckBox;
    EzColorGridBox6: TEzColorBox;
    EzColorGridBox7: TEzColorBox;
    GroupBox1: TGroupBox;
    dxCheckEdit11: TCheckBox;
    dxCheckEdit12: TCheckBox;
    dxCheckEdit13: TCheckBox;
    dxTabSheet4: TTabSheet;
    Label19: TLabel;
    SpeedButton1: TSpeedButton;
    Label20: TLabel;
    dxMemo1: TMemo;
    dxCheckEdit14: TCheckBox;
    dxTabSheet5: TTabSheet;
    Label21: TLabel;
    Label22: TLabel;
    SpeedButton2: TSpeedButton;
    dxMemo2: TMemo;
    dxCheckEdit15: TCheckBox;
    dxTabSheet6: TTabSheet;
    Label23: TLabel;
    SpeedButton3: TSpeedButton;
    Label24: TLabel;
    dxMemo3: TMemo;
    dxCheckEdit16: TCheckBox;
    dxTabSheet14: TTabSheet;
    dxCheckEdit1: TCheckBox;
    Label9: TLabel;
    dxMemo4: TMemo;
    SpeedButton4: TSpeedButton;
    dxCheckEdit3: TCheckBox;
    dxCheckEdit4: TCheckBox;
    dxCheckEdit20: TCheckBox;
    GroupBox2: TGroupBox;
    Shape1: TShape;
    sbCenter: TSpeedButton;
    sbCenterUp: TSpeedButton;
    sbUpperRight: TSpeedButton;
    sbCenterRight: TSpeedButton;
    sbLowerRight: TSpeedButton;
    sbCenterDown: TSpeedButton;
    sbLowerLeft: TSpeedButton;
    sbCenterLeft: TSpeedButton;
    sbUpperLeft: TSpeedButton;
    dxCheckEdit21: TCheckBox;
    PageControl1: TPageControl;
    TabSheet1: TTabSheet;
    LstFonts: TListBox;
    TabSheet2: TTabSheet;
    Panel2: TPanel;
    LstTTFonts: TListBox;
    dxCheckEdit22: TCheckBox;
    dxCheckEdit23: TCheckBox;
    dxCheckEdit24: TCheckBox;
    Label28: TLabel;
    EdSize: TEzNumEd;
    Label29: TLabel;
    cboColor: TEzColorBox;
    dxCheckEdit25: TCheckBox;
    dxCheckEdit26: TCheckBox;
    dxSpinEdit4: TEzNumEd;
    dxSpinEdit5: TEzNumEd;
    dxSpinEdit6: TEzNumEd;
    dxSpinEdit7: TEzNumEd;
    dxCheckEdit17: TCheckBox;
    Label30: TLabel;
    GridBox1: TComboBox;
    Label31: TLabel;
    DBGrid2: TDBGrid;
    DataSource1: TDataSource;
    dxCheckEdit18: TCheckBox;
    dxCheckEdit27: TCheckBox;
    dxCheckEdit28: TCheckBox;
    dxCheckEdit29: TCheckBox;
    dxCheckEdit30: TCheckBox;
    dxCheckEdit31: TCheckBox;
    dxCheckEdit32: TCheckBox;
    dxCheckEdit33: TCheckBox;
    dxCheckEdit34: TCheckBox;
    dxCheckEdit35: TCheckBox;
    dxCheckEdit36: TCheckBox;
    dxCheckEdit37: TCheckBox;
    dxSpinEdit8: TEdit;
    UpDown1: TUpDown;
    dxSpinEdit2: TEdit;
    UpDown2: TUpDown;
    dxSpinEdit3: TEdit;
    UpDown3: TUpDown;
    dxSpinPenWidth1: TEdit;
    UpDown4: TUpDown;
    dxPickEdit1: TComboBox;
    CheckListBox1: TCheckListBox;
    Label1: TLabel;
    SpeedButton5: TSpeedButton;
    SpeedButton6: TSpeedButton;
    procedure Button1Click(Sender: TObject);
    procedure SpeedButton1Click(Sender: TObject);
    procedure SpeedButton2Click(Sender: TObject);
    procedure SpeedButton3Click(Sender: TObject);
    procedure sbCenterClick(Sender: TObject);
    procedure SpeedButton4Click(Sender: TObject);
    procedure dxCheckEdit21Change(Sender: TObject);
    procedure GridBox1Change(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure frReport1GetValue(const ParName: String;
      var ParValue: Variant);
    procedure dxchkOverridePenChange(Sender: TObject);
    procedure dxCheckEdit2Change(Sender: TObject);
    procedure dxchkSymbolOverrChange(Sender: TObject);
    procedure dxCheckEdit6Change(Sender: TObject);
  private
    { Private declarations }
    Flo: TEzLayerOptions;
    Fdb: TEzBaseDrawBox;
    FLayer: TEzBaseLayer;
    FCurrentPos: TEzLabelPos;
    FDesignTable: TEzDesignTable;
    procedure ConfigureLayer( const LayerName: string );
  public
    { Public declarations }
    function Enter(const LayerName: string): word;
  end;

implementation

uses
  fMain, fexpress, ezsystem, ezconsts;

{$R *.DFM}

{ TfrmLayerOptions }

procedure TfrmLayerOptions.ConfigureLayer( const LayerName: string );
var
  I,L,D:integer;
  T:Char;
  fname:String;
begin
  FLayer:= FDB.GIS.Layers.LayerByname(LayerName);
  if FLayer=Nil then Exit;

  FDesignTable.Close;
  FDesignTable.Open;
  if FLayer.DBTable <> Nil then
  begin
    for I:= 1 to FLayer.DBTable.FieldCount do
    begin
      fname := FLayer.DBTable.Field( I );
      T := FLayer.DBTable.FieldType( I );
      L := FLayer.DBTable.FieldLen( I );
      D := FLayer.DBTable.FieldDec( I );

      with FDesignTable do
      begin
        Insert;
        FieldByName('FIELDNAME').AsString := fname;
        FieldByName('TYPE').AsString      := T;
        FieldByName('SIZE').AsInteger     := L;
        FieldByName('DEC').AsInteger      := D;
        Post;
      end;

    end;
  end;
  DataSource1.DataSet:= FDesignTable;

  Flo:= fMain.Form1.LayersOptions.LayerByName(FLayer.Name);
  if Flo=nil then
  begin
    Flo:=fMain.Form1.LayersOptions.Add;
    with Flo do
    begin
      LayerName:= FLayer.Name;
    end;
  end;

  { populate controls }
  //pen override

  dxchkOverridePen.checked:=Flo.OverridePen;
  ezPenStyleBox1.ItemIndex:=Flo.PenOverride.style;
  ezPenColorBox1.Selected:=Flo.PenOverride.color;
  if not Flo.KeepSameLineWidth then
    dxSpinPenWidth1.text:=floattostr(Fdb.Grapher.DistToPointsY(Flo.PenOverride.Width))
  else
    dxSpinPenWidth1.text:=floattostr(Flo.PenOverride.Width);
  dxKeepSamePen1.Checked:=Flo.KeepSameLineWidth;
  dxCheckEdit18.checked:=Flo.OverridePen_Style;
  dxCheckEdit27.checked:=Flo.OverridePen_Color;
  dxCheckEdit28.checked:=Flo.OverridePen_Width;

  //brush override

  dxCheckEdit2.checked:=Flo.OverrideBrush;
  BrushBox1.itemindex:=Flo.BrushOverride.pattern;
  EzForeColor1.Selected:=Flo.BrushOverride.forecolor;
  EzBackColor1.Selected:=Flo.BrushOverride.backcolor;
  dxCheckEdit29.checked:=Flo.OverrideBrush_Pattern;
  dxCheckEdit30.checked:=Flo.OverrideBrush_ForeColor;
  dxCheckEdit31.checked:=Flo.OverrideBrush_BackColor;


  //symbol override

  dxchkSymbolOverr.checked:=Flo.OverrideSymbol;
  EzSymbolsGridBox1.ItemIndex:=Flo.SymbolOverride.index;
  if not Flo.KeepSameSymbolSize then
    dxSpinEdit2.text:=floattostr(Fdb.Grapher.DistToPointsY(Flo.SymbolOverride.height))
  else
    dxSpinEdit2.text:=floattostr(Flo.SymbolOverride.height);
  dxCheckEdit5.Checked:=Flo.KeepSameSymbolSize;
  dxCheckEdit32.checked:=Flo.OverrideSymbol_Index;
  //Flo.OverrideSymbol_Rotangle;
  dxCheckEdit33.checked:=Flo.OverrideSymbol_Height;

  //Font override

  dxCheckEdit6.checked:=Flo.OverrideFont;
  ListBox1.Items.Assign( Screen.Fonts );
  ListBox1.itemindex:=ListBox1.Items.IndexOf(Flo.FontOverride.Name);
  chkBold.checked:=fsbold in Flo.FontOverride.style;
  chkItalic.checked:=fsitalic in Flo.FontOverride.style;
  chkUnderline.checked:=fsunderline in Flo.FontOverride.style;
  chkStrikeout.Checked:=fsstrikeout in Flo.FontOverride.style;
  if not Flo.KeepSameFontSize then
    UpDown3.Position:=trunc(Fdb.Grapher.DistToPointsY(Flo.FontOverride.height))
  else
    UpDown3.Position:=trunc(Flo.FontOverride.height);
  EzColorGridBox5.Selected:=Flo.FontOverride.color;
  dxCheckEdit7.Checked:=Flo.KeepSameFontSize;
  dxCheckEdit34.checked:=Flo.OverrideFont_Name    ;
  //.checked:=OverrideFont_Angle   ;
  dxCheckEdit35.checked:=Flo.OverrideFont_Height  ;
  dxCheckEdit36.checked:=Flo.OverrideFont_Color   ;
  dxCheckEdit37.checked:=Flo.OverrideFont_Style   ;

  //zoom range

  dxCheckEdit8.checked:=Flo.ZoomRangeActive;
  dxSpinEdit4.numericvalue:=Flo.MinZoomScale;
  dxSpinEdit5.numericvalue:=Flo.MaxZoomScale;


  //text zoom range

  dxCheckEdit9.checked:=Flo.TextZoomRangeActive;
  dxSpinEdit6.numericvalue:=Flo.MinZoomScaleForText;
  dxSpinEdit7.numericvalue:=Flo.MaxZoomScaleForText;

  //line direction

  dxCheckEdit10.checked:=Flo.ShowLineDirection;
  EzColorGridBox6.Selected:=Flo.DirectionPen.color;
  EzColorGridBox7.Selected:=Flo.DirectionBrush.forecolor;
  dxCheckEdit11.checked:= dpstart in Flo.Directionpos;
  dxCheckEdit12.checked:= dpmiddle in Flo.Directionpos;
  dxCheckEdit13.checked:= dpend in Flo.Directionpos;
  dxCheckEdit17.checked:=Flo.RevertDirection;

  //select filter

  dxMemo1.lines.text:=Flo.SelectFilterText;
  dxCheckEdit14.checked:=Flo.VisibleFilterActive;

  //hint expression

  dxMemo2.lines.text:=Flo.HintText;
  dxCheckEdit15.checked:=Flo.HintActive;

  //visibility expression

  dxMemo3.lines.text:= Flo.VisibleFilterText;
  dxCheckEdit16.checked:=Flo.VisibleFilterActive;

  //general

  dxCheckEdit19.checked:=	FLayer.Layerinfo.TextHasShadow;
  dxSpinEdit8.text:=	floattostr(FLayer.LayerInfo.TextFixedSize);
  dxPickedit1.itemindex:=Ord(FLayer.Layerinfo.OverlappedTextAction);
  EzColorBox8.Selected:=	FLayer.Layerinfo.OverlappedTextColor;


  // labeling

  LstTTFonts.Items.Assign(Screen.Fonts);

  with LstFonts.Items do
    for I:=0 to Ez_VectorFonts.Count-1 do
    Add(Ez_VectorFonts[I].Name);

  dxcheckEdit1.Checked:= Flo.LabelingActive;
  dxCheckEdit3.checked:= Flo.AlignLabels;
  dxCheckEdit4.checked:= Flo.RepeatInSegments;
  dxCheckEdit20.checked:= Flo.SmartShowing;
  dxCheckEdit21.checked:= Flo.TrueType;

  if Flo.TrueType then
  begin
    LstTTFonts.ItemIndex:= LstTTFonts.Items.IndexOf(Flo.LabelsFont.Name);
    PageControl1.ActivePage := TabSheet2;
  end else
  begin
    LstFonts.ItemIndex:= LstFonts.Items.IndexOf(Flo.LabelsFont.Name);
    PageControl1.ActivePage := TabSheet1;
  end;
  cboColor.Selected:= Flo.LabelsFont.Color;
  if Flo.LabelsKeepSameFontSize then
    EdSize.NumericValue:= Flo.LabelsFont.Height
  else
    EdSize.NumericValue:= Round(Fdb.Grapher.DistToPointsY(Flo.LabelsFont.Height)*1000)/1000;

  dxCheckEdit22.Checked:= fsBold in Flo.LabelsFont.Style;
  dxCheckEdit23.Checked:= fsItalic in Flo.LabelsFont.Style;
  dxCheckEdit24.Checked:= fsUnderline in Flo.LabelsFont.Style;
  dxCheckEdit25.Checked:= fsStrikeout in Flo.LabelsFont.Style;

  FCurrentPos:= Flo.LabelPos ;
  case FCurrentPos of
    lpCenter:
      sbCenter.Down:= true;
    lpCenterUp:
      sbCenterUp.Down:= true;
    lpUpperLeft:
      sbUpperLeft.Down:= true;
    lpUpperRight:
      sbUpperRight.Down:= true;
    lpCenterLeft:
      sbCenterLeft.Down:= true;
    lpCenterRight:
      sbCenterRight.Down:= true;
    lpLowerLeft:
      sbLowerLeft.Down:= true;
    lpCenterDown:
      sbCenterDown.Down:= true;
    lpLowerRight:
      sbLowerRight.Down:= true;
  else sbCenter.Down:= true;
  end;

  dxCheckEdit26.checked:=Flo.LabelsKeepSameFontSize;

  dxMemo4.Text:= Flo.LabelingText;

end;

function TfrmLayerOptions.enter(const LayerName: string): word;
var
  AppPath: string;
begin
  FDesignTable:= TEzDesignTable.Create(Self);
  FDesignTable.Name:= 'DesignTable1';

  Fdb:= fMain.Form1.DrawBox1;

  AppPath:= AddSlash( ExtractFilePath( Application.ExeName ) );

  { fill the list of layers }
  fMain.Form1.DrawBox1.Gis.Layers.PopulateList( GridBox1.Items );

  ConfigureLayer( LayerName );

  GridBox1.ItemIndex:= GridBox1.Items.IndexOf( LayerName );

  result:= ShowModal;
end;

procedure TfrmLayerOptions.Button1Click(Sender: TObject);
var
  style: TFontstyles;
  DirectionPos: TEzDirectionPos;
begin
  //pen override

  Flo.OverridePen:= dxchkOverridePen.checked;
  Flo.PenOverride.style:=ezPenStyleBox1.ItemIndex;
  Flo.PenOverride.color:=ezPenColorBox1.Selected;
  Flo.KeepSameLineWidth:=dxKeepSamePen1.Checked;
  if not Flo.KeepSameLineWidth then
    Flo.PenOverride.Width:=Fdb.Grapher.PointsToDistY(strtofloat(dxSpinPenWidth1.text))
  else
    Flo.PenOverride.Width:=strtofloat(dxSpinPenWidth1.text);
  Flo.KeepSameLineWidth:=dxKeepSamePen1.Checked;
  Flo.OverridePen_Style:=dxCheckEdit18.checked;
  Flo.OverridePen_Color:=dxCheckEdit27.checked;
  Flo.OverridePen_Width:=dxCheckEdit28.checked;

  //brush override

  Flo.OverrideBrush:=dxCheckEdit2.checked;
  Flo.BrushOverride.pattern:=BrushBox1.itemindex;
  Flo.BrushOverride.forecolor:=EzForeColor1.Selected;
  Flo.BrushOverride.backcolor:=EzBackColor1.Selected;
  Flo.OverrideBrush_Pattern:=dxCheckEdit29.checked;
  Flo.OverrideBrush_ForeColor:=dxCheckEdit30.checked;
  Flo.OverrideBrush_BackColor:=dxCheckEdit31.checked;


  //symbol override

  Flo.OverrideSymbol:=dxchkSymbolOverr.checked;
  Flo.SymbolOverride.index:=EzSymbolsGridBox1.ItemIndex;
  Flo.KeepSameSymbolSize:=dxCheckEdit5.Checked;
  if not Flo.KeepSameSymbolSize then
    Flo.SymbolOverride.height:=Fdb.Grapher.PointsToDistY(strtofloat(dxSpinEdit2.text))
  else
    Flo.SymbolOverride.height:=strtofloat(dxSpinEdit2.text);
  Flo.KeepSameSymbolSize:=dxCheckEdit5.Checked;
  Flo.OverrideSymbol_Index:=dxCheckEdit32.checked;
  //Flo.OverrideSymbol_Rotangle;
  Flo.OverrideSymbol_Height:=dxCheckEdit33.checked;


  //Font override

  Flo.OverrideFont:=dxCheckEdit6.checked;
  Flo.FontOverride.Name:=ListBox1.Items[ListBox1.itemindex];
  style:=[];
  if chkBold.checked then Include(style,fsbold);
  if chkItalic.checked then Include(style,fsitalic);
  if chkUnderline.checked then Include(style,fsunderline);
  if chkStrikeout.checked then Include(style,fsstrikeout);
  Flo.FontOverride.style:= style;
  Flo.KeepSameFontSize:=dxCheckEdit7.Checked;
  if not Flo.KeepSameFontSize then
    Flo.FontOverride.height:= Fdb.Grapher.PointsToDistY(strtofloat(dxSpinEdit3.text))
  else
    Flo.FontOverride.height:=strtofloat(dxSpinEdit3.text);
  Flo.FontOverride.color:=EzColorGridBox5.Selected;
  Flo.KeepSameFontSize:=dxCheckEdit7.Checked;
  Flo.OverrideFont_Name:=dxCheckEdit34.checked    ;
  //.checked:=OverrideFont_Angle   ;
  Flo.OverrideFont_Height:=dxCheckEdit35.checked  ;
  Flo.OverrideFont_Color:=dxCheckEdit36.checked   ;
  Flo.OverrideFont_Style:=dxCheckEdit37.checked   ;


  //zoom range

  Flo.ZoomRangeActive:=dxCheckEdit8.checked;
  Flo.MinZoomScale:=dxSpinEdit4.numericvalue;
  Flo.MaxZoomScale:=dxSpinEdit5.numericvalue;


  //text zoom range

  Flo.TextZoomRangeActive:=dxCheckEdit9.checked;
  Flo.MinZoomScaleForText:=dxSpinEdit6.numericvalue;
  Flo.MaxZoomScaleForText:=dxSpinEdit7.numericvalue;

  //line direction

  Flo.ShowLineDirection:=dxCheckEdit10.checked;
  Flo.RevertDirection:= dxCheckEdit17.checked;
  Flo.DirectionPen.style:= 1;
  Flo.DirectionPen.color:=EzColorGridBox6.Selected;
  Flo.DirectionBrush.Pattern:=1;
  Flo.DirectionBrush.forecolor:=EzColorGridBox7.Selected;
  DirectionPos:=[];
  if dxCheckEdit11.checked then Include(DirectionPos,dpstart);
  if dxCheckEdit12.checked then Include(DirectionPos,dpmiddle);
  if dxCheckEdit13.checked then Include(DirectionPos,dpend);
  Flo.Directionpos:= Directionpos;

  //select filter

  Flo.SelectFilterText:=dxMemo1.lines.text;
  Flo.VisibleFilterActive:=dxCheckEdit14.checked;

  //hint expression

  Flo.HintText:=dxMemo2.lines.text;
  Flo.HintActive:=dxCheckEdit15.checked;

  //visibility expression

  Flo.VisibleFilterText:=dxMemo3.lines.text;
  Flo.VisibleFilterActive:=dxCheckEdit16.checked;

  //general

  FLayer.Layerinfo.TextHasShadow:=dxCheckEdit19.checked;
  FLayer.LayerInfo.TextFixedSize:=trunc(strtofloat(dxSpinEdit8.text));
  FLayer.Layerinfo.OverlappedTextAction:=TEzOverlappedTextAction(dxPickedit1.itemindex);
  FLayer.Layerinfo.OverlappedTextColor:=EzColorBox8.Selected;

  // labeling

  Flo.LabelingActive:= dxcheckEdit1.Checked;
  Flo.AlignLabels:= dxCheckEdit3.checked;
  Flo.RepeatInSegments:= dxCheckEdit4.checked;
  Flo.SmartShowing:= dxCheckEdit20.checked;
  Flo.TrueType:= dxCheckEdit21.checked;

  if Flo.TrueType then
  begin
    if LstFonts.ItemIndex >= 0 then
    begin
      Flo.LabelsFont.Name:= LstFonts.Items[LstFonts.ItemIndex];
    end else
      Flo.LabelsFont.Name:= 'Arial';
  end else
  begin
    if LstTTFonts.ItemIndex >= 0 then
      Flo.LabelsFont.Name:= LstTTFonts.Items[LstTTFonts.ItemIndex]
    else if Ez_VectorFonts.Count>0 then
      Flo.LabelsFont.Name:= Ez_VectorFonts[0].Name;
  end;
  Flo.LabelsFont.Color:= cboColor.Selected;

  Flo.LabelsKeepSameFontSize:=dxCheckEdit26.checked;

  if not Flo.LabelsKeepSameFontSize then
    Flo.LabelsFont.Height:= Fdb.Grapher.PointsToDistY(EdSize.Numericvalue)
  else
    Flo.LabelsFont.Height:= EdSize.Numericvalue;

  style:=[];
  if dxCheckEdit22.checked then Include(style,fsbold);
  if dxCheckEdit23.checked then Include(style,fsitalic);
  if dxCheckEdit24.checked then Include(style,fsunderline);
  if dxCheckEdit25.checked then Include(style,fsstrikeout);
  Flo.LabelsFont.Style:= style;

  Flo.LabelPos:= FCurrentPos;

  Flo.LabelingText:= dxMemo4.Text;

end;

procedure TfrmLayerOptions.SpeedButton1Click(Sender: TObject);
begin
  With TfrmExprDlg.Create( Application ) Do
    Try
      If Enter( dxMemo1.Text, Fdb.Gis, FLayer ) = mrOk Then
      begin
        dxMemo1.Text := Memo1.Text;
      end;
    Finally
      Free;
    End;
end;

procedure TfrmLayerOptions.SpeedButton2Click(Sender: TObject);
begin
  With TfrmExprDlg.Create( Application ) Do
    Try
      If Enter( dxMemo2.Text, Fdb.Gis, FLayer ) = mrOk Then
      begin
        dxMemo2.Text := Memo1.Text;
      end;
    Finally
      Free;
    End;
end;

procedure TfrmLayerOptions.SpeedButton3Click(Sender: TObject);
begin
  With TfrmExprDlg.Create( Application ) Do
    Try
      If Enter( dxMemo3.Text, Fdb.Gis, FLayer ) = mrOk Then
      begin
        dxMemo3.Text := Memo1.Text;
      end;
    Finally
      Free;
    End;
end;

procedure TfrmLayerOptions.sbCenterClick(Sender: TObject);
begin
  FCurrentPos:= TEzLabelPos(TControl(Sender).Tag);
end;

procedure TfrmLayerOptions.SpeedButton4Click(Sender: TObject);
begin
  With TfrmExprDlg.Create( Application ) Do
    Try
      If Enter( dxMemo4.Text, Fdb.Gis, FLayer ) = mrOk Then
      begin
        dxMemo4.Text := Memo1.Text;
      end;
    Finally
      Free;
    End;
end;

procedure TfrmLayerOptions.dxCheckEdit21Change(Sender: TObject);
begin
  if dxCheckEdit21.checked then
    PageControl1.ActivePage := TabSheet2
  else
    PageControl1.ActivePage := TabSheet1;
end;

procedure TfrmLayerOptions.GridBox1Change(Sender: TObject);
begin
  Button1Click(Nil);
  if GridBox1.ItemIndex < 0 then Exit;
  ConfigureLayer( GridBox1.Items[GridBox1.ItemIndex] );
end;

procedure TfrmLayerOptions.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  FDesignTable.Free;
end;

procedure TfrmLayerOptions.frReport1GetValue(const ParName: String;
  var ParValue: Variant);
begin
  if AnsiCompareText(ParName, 'LayerName')=0 then
  begin
    ParValue:= FLayer.Name;
  end else if AnsiCompareText(ParName, 'RecordCount')=0 then
  begin
    ParValue:= FLayer.DBTable.RecordCount;
  end else if AnsiCompareText(ParName, 'Release')=0 then
  begin
    ParValue:= Copy(ezconsts.SEz_GisVersion,15,length(ezconsts.SEz_GisVersion));
  end;
end;

procedure TfrmLayerOptions.dxchkOverridePenChange(Sender: TObject);
begin
  dxCheckEdit18.checked:=dxchkOverridePen.checked;
  dxCheckEdit27.checked:=dxchkOverridePen.checked;
  dxCheckEdit28.checked:=dxchkOverridePen.checked;
end;

procedure TfrmLayerOptions.dxCheckEdit2Change(Sender: TObject);
begin
  dxCheckEdit29.checked:=dxCheckEdit2.checked;
  dxCheckEdit30.checked:=dxCheckEdit2.checked;
  dxCheckEdit31.checked:=dxCheckEdit2.checked;
end;

procedure TfrmLayerOptions.dxchkSymbolOverrChange(Sender: TObject);
begin
  dxCheckEdit32.checked:=dxchkSymbolOverr.checked;
  dxCheckEdit33.checked:=dxchkSymbolOverr.checked;
end;

procedure TfrmLayerOptions.dxCheckEdit6Change(Sender: TObject);
begin
  dxCheckEdit34.checked:=dxCheckEdit6.checked;
  dxCheckEdit36.checked:=dxCheckEdit6.checked;
  dxCheckEdit37.checked:=dxCheckEdit6.checked;
  dxCheckEdit35.checked:=dxCheckEdit6.checked;
end;

end.
