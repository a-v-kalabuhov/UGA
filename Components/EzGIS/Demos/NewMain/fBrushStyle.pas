unit fBrushStyle;

{$I EZ_FLAG.PAS}
interface

uses Windows, SysUtils, Classes, Graphics, Forms, Controls, StdCtrls, 
  Buttons, ExtCtrls, Dialogs, ezbasegis, ezbase, Mask, EzMiscelCtrls,
  EzColorPicker;

type
  TfrmBrushStyle = class(TForm)
    OKBtn: TButton;
    CancelBtn: TButton;
    Label1: TLabel;
    Paintbox1: TPaintBox;
    cboBackColor: TEzColorBox;
    cboForeColor: TEzColorBox;
    brushlist1: TEzBrushPatternListBox;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure OKBtnClick(Sender: TObject);
    procedure FormPaint(Sender: TObject);
    procedure cboForeColorChange(Sender: TObject);
    procedure cboBackColorChange(Sender: TObject);
    procedure brushlist1Click(Sender: TObject);
  private
    { Private declarations }
    FDrawBox: TEzBaseDrawBox;
    FBrushtool: TEzBrushTool;
    fSavedColor: TColor;
  public
    { Public declarations }
    function Enter(DrawBox: TEzBaseDrawBox): Word;
  end;

implementation

{$R *.DFM}

uses ezgraphics, fLineType, ezsystem, fMain;

function TfrmBrushStyle.Enter(DrawBox: TEzBaseDrawBox): Word;
var
  SelLayer:TEzSelectionLayer;
  Entity:TEzEntity;

  procedure InitGlobally;
  begin
    FBrushtool.Assign(Ez_Preferences.DefBrushStyle);
  end;

begin
  FBrushtool:= TEzBrushtool.Create;

  FDrawBox:= DrawBox;
  with DrawBox do
  begin
    if Selection.NumSelected = 1 then
    begin
      SelLayer:= Selection[0];
      Entity:= SelLayer.Layer.LoadEntityWithRecno(SelLayer.SelList[0]);
      try
        if Entity is TEzClosedEntity then
          FBrushtool.Assign(TEzClosedEntity(Entity).Brushtool);
      finally
        Entity.Free;
      end;
    end else
    begin
      InitGlobally;
    end;
  end;
  brushlist1.ItemIndex:= FBrushtool.Pattern;
  cboForeColor.Selected:= FBrushtool.ForeColor;
  cboBackColor.Selected:= FBrushtool.BackColor;

  FSavedColor := FBrushtool.BackColor;

  result:= ShowModal;
end;

procedure TfrmBrushStyle.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  FBrushtool.free;
end;

procedure TfrmBrushStyle.OKBtnClick(Sender: TObject);
var
  SelLayer:TEzSelectionLayer;
  Entity:TEzEntity;
  i,j:Integer;

begin
  FBrushTool.BackColor:= cboBackColor.Selected;
  with FDrawBox do
  begin
    if Selection.Count>0 then
    begin
      for I:=0 to Selection.Count-1 do
      begin
        SelLayer:= Selection[I];
        for J:=0 to SelLayer.SelList.Count-1 do
        begin
          Entity:= SelLayer.Layer.LoadEntityWithRecno(SelLayer.SelList[J]);
          try
            if Entity is TEzClosedEntity then
            begin
              TEzClosedEntity(Entity).Brushtool.Assign(FBrushtool);
              SelLayer.Layer.UpdateEntity(SelLayer.SelList[J],Entity);
            end;
          finally
            Entity.Free;
          end;
        end;
      end;
    end else
      Ez_Preferences.DefBrushStyle.Assign(FBrushtool);
  end;
end;

procedure TfrmBrushStyle.FormPaint(Sender: TObject);
var
  tmpRect: TRect;
  Poly: array[0..5] of TPoint;
  Parts: array[0..0] of Integer;
  Resname: string;
  BmpRes: HBitmap;
  Bmp: TBitmap;
  Boundsr: TRect;
begin

  if brushlist1.ItemIndex <0 then exit;
  { Calcula el poligono }
  TmpRect:= Paintbox1.BoundsRect;
  InflateRect(TmpRect,-10,-10);
  with TmpRect do
  begin
     Poly[0]:= Point(Left,Top);
     Poly[1]:= Point(Left,Bottom);
     Poly[2]:= Point(Right,Bottom);
     Poly[3]:= Point(Right,Top);
     Poly[4]:= Point((Left+Right) div 2,(Top+Bottom) div 4);
     Poly[5]:= Poly[0];
  end;
  with self.Canvas do
  begin
     Boundsr:= Paintbox1.BoundsRect;
     DrawEdge(Handle,Boundsr,EDGE_RAISED,BF_RECT {or BF_MIDDLE or BF_FLAT});
     Pen.Color:= clBlack;
     case FBrushtool.Pattern of
        0:
          begin
          Brush.Style := bsClear;
          self.Canvas.Polygon(Poly);
          end;
        1:
          begin
            Brush.Style := bsSolid;
            Brush.Color := FBrushtool.ForeColor;
            self.Canvas.Polygon(Poly);
          end;
        2..89:
          begin
            Brush.Style:= bsClear;
            Resname:= '#'+IntToStr(98+FBrushTool.Pattern);
            BmpRes:= LoadBitmap(HInstance, PChar(Resname));
            if BmpRes<>0 then
            begin
              Bmp:= TBitmap.Create;
              try
                Bmp.Handle:= Bmpres;
                Parts[0]:= 6;
                EzGraphics.PolygonScreenFill8X8Bitmap(
                  self.Canvas,
                  nil,
                  Poly,
                  Parts,
                  1,
                  Bmp,
                  FBrushTool.ForeColor,
                  FBrushTool.BackColor );
              finally
                DeleteObject(Bmp.Handle);
                Bmp.free;
              end;
            end;
            self.Canvas.Polygon(Poly);
          end;
     end;
  end;
end;

procedure TfrmBrushStyle.cboForeColorChange(Sender: TObject);
begin
  FBrushtool.Forecolor:= cboForeColor.Selected;
  self.refresh;
end;

procedure TfrmBrushStyle.cboBackColorChange(Sender: TObject);
begin
  FBrushtool.Backcolor:= cboBackColor.Selected;
  self.refresh;
end;

procedure TfrmBrushStyle.brushlist1Click(Sender: TObject);
begin
  FBrushtool.Pattern:= brushlist1.ItemIndex;
  Self.Refresh;
end;

end.
