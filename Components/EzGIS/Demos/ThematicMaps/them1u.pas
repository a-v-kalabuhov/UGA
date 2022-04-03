unit them1u;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ezbasegis, ExtCtrls, StdCtrls, ezbase,
  ComCtrls, ezlib, Buttons, EzCtrls, EzBasicCtrls;

type
  TForm1 = class(TForm)
    Gis1: TEzGis;
    Drawbox1: TEzDrawBox;
    Splitter1: TSplitter;
    Panel2: TPanel;
    MemoInfo: TMemo;
    Label5: TLabel;
    Label6: TLabel;
    Label9: TLabel;
    Panel1: TPanel;
    Panel3: TPanel;
    Panel4: TPanel;
    Panel5: TPanel;
    ZoomIn: TSpeedButton;
    ZoomOut: TSpeedButton;
    ZoomAll: TSpeedButton;
    PriorViewBtn: TSpeedButton;
    Panel6: TPanel;
    Panel7: TPanel;
    Panel8: TPanel;
    Panel9: TPanel;
    Panel10: TPanel;
    Panel11: TPanel;
    PaintBox3: TPaintBox;
    PaintBox4: TPaintBox;
    PaintBox5: TPaintBox;
    PaintBox6: TPaintBox;
    PaintBox1: TPaintBox;
    PaintBox2: TPaintBox;
    symbed1: TComboBox;
    symbed2: TComboBox;
    symbed3: TComboBox;
    ColorDialog1: TColorDialog;
    procedure FormCreate(Sender: TObject);
    procedure ZoomAllClick(Sender: TObject);
    procedure ZoomInClick(Sender: TObject);
    procedure ZoomOutClick(Sender: TObject);
    procedure PriorViewBtnClick(Sender: TObject);
    procedure PaintBox3Paint(Sender: TObject);
    procedure symbed1DrawItem(Control: TWinControl; Index: Integer;
      Rect: TRect; State: TOwnerDrawState);
    procedure symbed1Change(Sender: TObject);
    procedure PaintBox3Click(Sender: TObject);
    procedure Gis1BeforeBrushPaint(Sender: TObject; Layer: TEzBaseLayer;
      Recno: Integer; Grapher: TEzGrapher; Canvas: TCanvas;
      const Clip: TEzRect; Style: TEzBrushTool);
    procedure Gis1BeforePenPaint(Sender: TObject; Layer: TEzBaseLayer;
      Recno: Integer; Grapher: TEzGrapher; Canvas: TCanvas;
      const Clip: TEzRect; Style: TEzPenTool);
    procedure Gis1BeforeSymbolPaint(Sender: TObject; Layer: TEzBaseLayer;
      Recno: Integer; Grapher: TEzGrapher; Canvas: TCanvas;
      const Clip: TEzRect; Style: TEzSymbolTool);
  private
    { Private declarations }
    selectedColor: array[1..6] of TColor;
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.DFM}

uses
  ezsystem, ezentities;

procedure TForm1.FormCreate(Sender: TObject);
var
  Path: string;
  I:Integer;
begin
  Path:= AddSlash(ExtractFilePath(ExpandFilename('..\..\data\txt.fnt')));
  if not FileExists(Path+'txt.fnt') then
  begin
    ShowMessage('No font files found !');
  end;
  Ez_VectorFonts.AddFontFile(Path+'complex.fnt');
  Ez_VectorFonts.AddFontFile(Path+'txt.fnt');
  //Ez_VectorFonts.AddFontFile(Path+'romanc.fnt');
  //Ez_VectorFonts.AddFontFile(Path+'arial.fnt');

  { ALWAYS load the symbols after the vectorial fonts
    because the symbols can include vectorial fonts entities and
    if the vector font is not found, then the entity will be configured
    with another font }
  if FileExists(Path + 'symbols.ezs') then
  begin
    Ez_Symbols.FileName:= Path + 'symbols.ezs';
    Ez_Symbols.Open;
  end;

  // load line types
  if FileExists(Path + 'Linetypes.ezl') then
  begin
    Ez_LineTypes.FileName:=Path + 'Linetypes.ezl';
    Ez_LineTypes.Open;
  end;

  Ez_Preferences.CommonSubDir:= Path;

  Gis1.FileName:= Path + 'SampleMap.Ezm';
  Gis1.Open;
  Drawbox1.ZoomToExtension;

  symbed1.Items.Clear;
  for I:= 0 to Ez_Symbols.Count-1 do
    symbed1.Items.Add(Ez_Symbols.Items[I].Name);
  symbed1.ItemIndex:=1;

  symbed2.Items.Clear;
  for I:= 0 to Ez_Symbols.Count-1 do
    symbed2.Items.Add(Ez_Symbols.Items[I].Name);
  symbed2.ItemIndex:=2;

  symbed3.Items.Clear;
  for I:= 0 to Ez_Symbols.Count-1 do
    symbed3.Items.Add(Ez_Symbols.Items[I].Name);
  symbed3.ItemIndex:=3;

  selectedColor[3]:= clPurple;
  selectedColor[4]:= clGreen;
  selectedColor[5]:= clBlue;
  selectedColor[6]:= clMaroon;

  selectedColor[1]:= clLime;
  selectedColor[2]:= clAqua;
end;

procedure TForm1.ZoomAllClick(Sender: TObject);
begin
  Drawbox1.ZoomToExtension;
end;

procedure TForm1.ZoomInClick(Sender: TObject);
begin
  Drawbox1.ZoomIn(85);
end;

procedure TForm1.ZoomOutClick(Sender: TObject);
begin
  Drawbox1.ZoomOut(85);
end;

procedure TForm1.PriorViewBtnClick(Sender: TObject);
begin
  Drawbox1.ZoomPrevious;
end;

procedure TForm1.PaintBox3Paint(Sender: TObject);
var Boundsr:TRect;
begin
  with (sender as TPaintBox) do
  begin
    Boundsr:= ClientRect;
    InflateRect(Boundsr,-1,-1);
    DrawEdge(Canvas.Handle,Boundsr,EDGE_RAISED, BF_RECT {or BF_MIDDLE or BF_FLAT});
    InflateRect(Boundsr,-3,-3);
    Canvas.Brush.Color:= selectedColor[Tag];
    Canvas.FillRect(Boundsr);
  end;
end;

procedure TForm1.symbed1DrawItem(Control: TWinControl; Index: Integer;
  Rect: TRect; State: TOwnerDrawState);
var
  Boundsr:TRect;
  Grapher: TEzGrapher;
  Symbol: TEzSymbol;
  Rgn: HRgn;
  tmpMarginX, tmpMarginY: Double;
begin
  with Control as TComboBox do
  begin
    if odSelected in State then
      Canvas.Brush.Color:= clHighLight;
    Canvas.FillRect(Rect);
    Boundsr:= Rect;
    InflateRect(Boundsr,-1,-1);
    DrawEdge(Canvas.Handle,Boundsr,EDGE_RAISED, BF_RECT {or BF_MIDDLE or BF_FLAT});
    InflateRect(Boundsr,-2,-2);
    Canvas.Font.Color:=clBlue;

    { DRAW THE SYMBOL }
    Boundsr.Left := Boundsr.Right - (Boundsr.Bottom-Boundsr.Top);

    Symbol:= Ez_Symbols[index];
    if EqualRect2D(Symbol.Extension, INVALID_EXTENSION) then Exit;
    Grapher:= TEzGrapher.Create(10,adScreen);
    try
      Canvas.Brush.Style:= bsSolid;
      Canvas.Brush.Color:= Self.Color;
      Canvas.FillRect(Boundsr);
      with Boundsr do
        Grapher.SetViewport(Left, Top, Right, Bottom);
      with Symbol.Extension do
      begin
        TmpMarginX:= (Emax.X - Emin.X) / 20;
        TmpMarginY:= (Emax.Y - Emin.Y) / 20;
        Grapher.SetWindow(Emin.X - TmpMarginX, Emax.X + TmpMarginX, Emin.Y - TmpMarginY, Emax.Y + TmpMarginY);
      end;
      with Canvas do
      begin
        with Boundsr do
          Rgn:= CreateRectRgn(Left, Top, Right, Bottom);
        SelectClipRgn(Canvas.Handle, Rgn);
        try
          Symbol.Draw(Grapher, Canvas,
            Grapher.CurrentParams.VisualWindow, IDENTITY_MATRIX2D, dmNormal);
        finally
          SelectClipRgn(Canvas.Handle, 0);
          DeleteObject(Rgn);
        end;
      end;
    finally
      Grapher.Free;
    end;
  end;
end;

procedure TForm1.symbed1Change(Sender: TObject);
begin
  Drawbox1.repaint;
end;

procedure TForm1.PaintBox3Click(Sender: TObject);
var
  index:integer;
begin
  index:= (Sender as TControl).Tag;
  colordialog1.color:= selectedcolor[index];
  if not colordialog1.execute then exit;
  selectedcolor[index]:=colordialog1.color;
  (Sender as TPaintBox).refresh;
  Drawbox1.repaint;
end;

procedure TForm1.Gis1BeforeBrushPaint(Sender: TObject; Layer: TEzBaseLayer;
  Recno: Integer; Grapher: TEzGrapher; Canvas: TCanvas;
  const Clip: TEzRect; Style: TEzBrushTool);
var
  Population: Integer;
begin
  if AnsiComparetext(Layer.Name, 'states_') = 0 then
  begin
    { set position of the DBtable }
    Layer.DBTable.Recno:= Recno;
    { define the fill color depending on the range }
    Population:= Layer.DBTable.IntegerGet('POP1990');
    if (Population >= 0) and  (Population <= 1000000) then
      { define the brush }
      Style.ForeColor:= SelectedColor[3]
    else if (Population > 1000000) and (Population <= 2000000) then
      Style.ForeColor:= SelectedColor[4]
    else if (Population > 2000000) and (Population <= 3000000) then
      Style.ForeColor:= SelectedColor[5]
    else if Population > 3000000 then
      Style.ForeColor:= SelectedColor[6]
  end;
  Style.Pattern:= 1;
end;

procedure TForm1.Gis1BeforePenPaint(Sender: TObject; Layer: TEzBaseLayer;
  Recno: Integer; Grapher: TEzGrapher; Canvas: TCanvas;
  const Clip: TEzRect; Style: TEzPenTool);
var
  s: string;
begin
  if AnsiComparetext(Layer.Name, 'roads_') = 0 then
  begin
    Layer.DBTable.Recno:= Recno;
    s:= Layer.DBTable.StringGet('TYPE');
    if AnsiCompareText(s, 'Paved Divided') = 0 then
      Style.Color:= SelectedColor[1]
    else if AnsiCompareText(s, 'Paved Undivided') = 0 then
      Style.Color:= SelectedColor[2];
  end
end;

procedure TForm1.Gis1BeforeSymbolPaint(Sender: TObject;
  Layer: TEzBaseLayer; Recno: Integer; Grapher: TEzGrapher;
  Canvas: TCanvas; const Clip: TEzRect; Style: TEzSymbolTool);
var
  Population: Integer;
begin
  Exit;
  if AnsiComparetext(Layer.Name, 'cities_') = 0 then
  begin
    Layer.DBTable.Recno:= Recno;
    Population:= Layer.DBTable.IntegerGet('POP1990'); // disabled because this field does not exists on demo
    if (Population>=0) and (Population<=500000) then
      Style.Index:= symbed1.itemindex
    else if (Population>500000) and (Population<=1000000) then
      Style.Index:= symbed2.itemindex
    else if Population>1000000 then
    begin
      Style.Index:= symbed3.itemindex;
      Style.Height:= 1.07;
    end;
  end;
end;

end.
