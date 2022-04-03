unit fFontStyle;

{$I EZ_FLAG.PAS}
interface

uses Windows, SysUtils, Classes, Graphics, Forms, Controls, StdCtrls,
  Buttons, ExtCtrls, EzBase, EzBaseGis, Dialogs, ComCtrls, Mask,
  EzNumEd, EzMiscelCtrls, EzColorPicker;

type
  TfrmFontStyle = class(TForm)
    OKBtn: TButton;
    CancelBtn: TButton;
    Label1: TLabel;
    Label4: TLabel;
    PaintBox1: TPaintBox;
    Label2: TLabel;
    Label3: TLabel;
    Label5: TLabel;
    Button1: TButton;
    PageControl1: TPageControl;
    TabSheet1: TTabSheet;
    TabSheet2: TTabSheet;
    LstFonts: TListBox;
    Panel1: TPanel;
    LstTTFonts: TListBox;
    ChkBold: TCheckBox;
    ChkItalic: TCheckBox;
    ChkUnderline: TCheckBox;
    CboSize: TEzNumEd;
    cboColor: TEzColorBox;
    Edit1: TEdit;
    procedure FormDestroy(Sender: TObject);
    procedure PaintBox1Paint(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure OKBtnClick(Sender: TObject);
    procedure LstFontsClick(Sender: TObject);
    procedure PageControl1Change(Sender: TObject);
    procedure cboColorItemIndexChanged(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    FDrawBox: TEzBaseDrawBox;
    FFontTool: TEzFontTool;
    FTTFontTool: TEzFontTool;
    function Enter(DrawBox: TEzBaseDrawBox): Word;
  end;

implementation

{$R *.dfm}

uses
  fLineType, EzSystem, EzEntities, EzLib, fMain;

{ TfrmFontStyle }

function TfrmFontStyle.Enter(DrawBox: TEzBaseDrawBox): Word;
var
  I:Integer;
  SelLayer:TEzSelectionLayer;
  Entity:TEzEntity;
  IsVectorial:Boolean;

  procedure InitGlobally;
  begin
    FFonttool.Assign(Ez_Preferences.DefFontStyle);
    FTTFonttool.Assign(Ez_Preferences.DefTTFontStyle);
  end;

begin
  FDrawBox:= DrawBox;
  { populate windows fonts }
{$IFDEF LEVEL5}
  Screen.ResetFonts;
{$ENDIF}
  LstTTFonts.Items.Assign(Screen.Fonts);
  with LstFonts.Items do
    for I:=0 to Ez_VectorFonts.Count-1 do
    Add(Ez_VectorFonts[I].Name);

  FFontTool:= TEzFontTool.create;
  FTTFontTool:= TEzFontTool.create;

  IsVectorial:=false;
  with DrawBox do
  begin
    if Selection.NumSelected = 1 then
    begin
      SelLayer:= Selection[0];
      Entity:= SelLayer.Layer.LoadEntityWithRecno(SelLayer.SelList[0]);
      try
        InitGlobally;
        if Entity.EntityID = idJustifVectText then
        begin
          with TEzJustifVectorText(Entity) do
          begin
            FFonttool.Name:= FontName;
            FFonttool.Height:= Height;
            FFonttool.Color:= FontColor;
          end;
          IsVectorial:=true;
        end else if Entity.EntityID = idFittedVectText then
        begin
          with TEzFittedVectorText(Entity) do
          begin
            FFonttool.Name:= FontName;
            FFonttool.Height:= Height;
            FFonttool.Color:= FontColor;
          end;
          IsVectorial:=true;
        end else if Entity.EntityID = idTrueTypeText then
        begin
          with TEzTrueTypeText(Entity) do
          begin
            Self.FTTFonttool.Assign(FontTool);
          end;
          PageControl1.ActivePage:= TabSheet2;
        end;
      finally
        Entity.Free;
      end;
    end else
    begin
      InitGlobally;
    end;
  end;

  LstFonts.ItemIndex:= LstFonts.Items.IndexOf(FFonttool.Name);
  cboColor.Selected:= FFonttool.Color;
  cboSize.NumericValue:= Round(FDrawBox.Grapher.DistToPointsY(FFonttool.Height)*1000)/1000;

  LstTTFonts.ItemIndex:= LstTTFonts.Items.IndexOf(FTTFonttool.Name);
  chkBold.Checked:= fsBold in FTTFonttool.Style;
  chkItalic.Checked:= fsItalic in FTTFonttool.Style;
  chkUnderline.Checked:= fsUnderline in FTTFonttool.Style;
  if (FDrawBox.Selection.NumSelected=1) and not IsVectorial then
  begin
    cboColor.Selected:= FTTFonttool.Color;
    cboSize.Numericvalue:= Round(FDrawBox.Grapher.DistToPointsY(FTTFonttool.Height)*1000)/1000;
    chkBold.Checked:= fsbold in FTTFontTool.Style;
    chkItalic.Checked:= fsitalic in FTTFontTool.Style;
    chkUnderline.Checked:= fsunderline in FTTFontTool.Style;
  end;

  result:= ShowModal;
end;

procedure TfrmFontStyle.FormDestroy(Sender: TObject);
begin
  FFontTool.free;
  FTTFontTool.free;
end;

procedure TfrmFontStyle.PaintBox1Paint(Sender: TObject);
var
  Grapher: TEzGrapher;
  Text: TEzFittedVectorText;
  TmpExt:TEzRect;
  R, Boundsr:TRect;
  FontHeight:Double;
  VectorFont: TEzVectorFont;
  AText: string;
begin
  if (Length(Edit1.Text)=0) or (Ez_VectorFonts.Count=0) or
    (LstFonts.ItemIndex<0) then exit;
  with PaintBox1.Canvas do
  begin
     R:= PaintBox1.ClientRect;
     Brush.Style:= bsSolid;
     Brush.Color:= clBtnFace;
     FillRect(R);

     Boundsr:= R;
     InflateRect(Boundsr,-1,-1);
     DrawEdge(Handle,Boundsr,EDGE_SUNKEN, BF_RECT {or BF_MIDDLE or BF_FLAT});
     InflateRect(Boundsr,-2,-2);

     Brush.Style:= bsClear;
     if PageControl1.ActivePage = TabSheet1 then
     begin
       VectorFont:= Ez_VectorFonts.FontByName(LstFonts.Items[LstFonts.ItemIndex]);
       if VectorFont=nil then exit;
       TmpExt:= VectorFont.GetFittedTextExtension(Edit1.Text,0.10);
       Grapher:= TEzGrapher.Create(10,adScreen);
       AText:= #32 + Trim(Edit1.Text) + #32;
       try
         Grapher.SetViewport(Boundsr.Left, Boundsr.Top, Boundsr.Right-Boundsr.Left, Boundsr.Bottom-Boundsr.Top);
         Grapher.SetWindow(TmpExt.X1, TmpExt.X2, TmpExt.Y1, TmpExt.Y2);
         FontHeight:= Grapher.RDistToRealY(cboSize.Numericvalue);
         Text:= TEzFittedVectorText.CreateEntity( Point2d(TmpExt.X1,TmpExt.Y2),
                                                    AText,
                                                    FontHeight,
                                                    (TmpExt.X2-TmpExt.X1), 0 );
         try
           text.BeginUpdate;
           TEzFittedVectorText(text).FontColor:= cboColor.Selected;
           TEzFittedVectorText(text).FontName:=
             LstFonts.Items[LstFonts.ItemIndex];
           text.EndUpdate;
           Text.Draw( Grapher,
                      PaintBox1.Canvas,
                      Grapher.RectToReal(PaintBox1.ClientRect),
                      dmNormal );
         finally
           Text.free;
         end;
       finally
         Grapher.free;
       end;
     end else if PageControl1.ActivePage = TabSheet2 then
     begin
       if LstTTFonts.ItemIndex < 0 then exit;
       Font.Name:= LstTTFonts.Items[LstTTFonts.ItemIndex];
       Font.Size:= trunc(cboSize.Numericvalue);
       Font.Color:= cboColor.Selected;
       Font.Style:= [];
       if chkBold.Checked then
         Font.Style:=Font.Style+[fsBold];
       if chkItalic.Checked then
         Font.Style:=Font.Style+[fsItalic];
       if chkUnderline.Checked then
         Font.Style:=Font.Style+[fsUnderline];
       SetBkMode(Handle,TRANSPARENT);
       AText:= #32 + Trim(Edit1.Text) + #32;
       Drawtext(Handle, PChar(AText), Length(AText), BoundsR,
         DT_SINGLELINE or DT_VCENTER or DT_CENTER);
     end;
  end;
end;

procedure TfrmFontStyle.Button1Click(Sender: TObject);
begin
  Paintbox1.Refresh;
end;

procedure TfrmFontStyle.OKBtnClick(Sender: TObject);
var
  SelLayer:TEzSelectionLayer;
  Entity:TEzEntity;
  I,J:Integer;
  AOldBounds,ANewBounds:TEzRect;

  procedure UpdateGlobally;
  begin
    Ez_Preferences.DefFontStyle.Assign(FFontTool);
    Ez_Preferences.DefTTFontStyle.Assign(FTTFontTool);
  end;

begin
  FFonttool.Name:= LstFonts.Items[LstFonts.ItemIndex];
  FFonttool.Height:= FDrawBox.Grapher.PointsToDistY(cboSize.Numericvalue);
  FTTFonttool.Name:= LstTTFonts.Items[LstTTFonts.ItemIndex];
  FTTFonttool.Height:= FDrawBox.Grapher.PointsToDistY(cboSize.Numericvalue);
  FTTFonttool.Style:= [];
  if ChkBold.Checked then
    FTTFonttool.Style:= FTTFonttool.Style + [fsbold];
  if ChkItalic.Checked then
    FTTFonttool.Style:= FTTFonttool.Style + [fsitalic];
  if ChkUnderline.Checked then
    FTTFonttool.Style:= FTTFonttool.Style + [fsUnderline];
  AOldBounds:= FDrawBox.Selection.GetExtension;
  with FDrawBox do
  begin
    if Selection.Count > 0 then
    begin
      for I:=0 to Selection.Count-1 do
      begin
        SelLayer:= Selection[I];
        for J:=0 to SelLayer.SelList.Count-1 do
        begin
          Entity:= SelLayer.Layer.LoadEntityWithRecno(SelLayer.SelList[J]);
          try
            if not (Entity.EntityID in [idTrueTypeText, idFittedVectText, idJustifVectText]) then Continue;
            if Entity is TEzFittedVectorText then
            begin
              with TEzFittedVectorText(Entity) do
              begin
                BeginUpdate;
                FontName:= FFonttool.Name;
                Height:= FFonttool.Height;
                FontColor:= FFonttool.Color;
                EndUpdate;
              end;
              SelLayer.Layer.UpdateEntity(SelLayer.SelList[J],Entity);
            end else if Entity is TEzJustifVectorText then
            begin
              with TEzJustifVectorText(Entity) do
              begin
                BeginUpdate;
                FontName:= FFonttool.Name;
                Height:= FFonttool.Height;
                FontColor:= FFonttool.Color;
                EndUpdate;
              end;
              SelLayer.Layer.UpdateEntity(SelLayer.SelList[J],Entity);
            end else if Entity is TEzTrueTypeText then
            begin
              with TEzTrueTypeText(Entity) do
              begin
                BeginUpdate;
                FontTool.Assign(FTTFonttool);
                EndUpdate;
              end;
              SelLayer.Layer.UpdateEntity(SelLayer.SelList[J],Entity);
            end;
          finally
            Entity.Free;
          end;
        end;
      end;
    end else
      UpdateGlobally;
  end;
  ANewBounds:= FDrawBox.Selection.GetExtension;
  MaxBound(ANewBounds.Emax,AOldBounds.Emax);
  MinBound(ANewBounds.Emin,AOldBounds.Emin);
  if FDrawBox.Selection.NumSelected > 1 then
    FDrawBox.RepaintRect(ANewBounds);
end;

procedure TfrmFontStyle.LstFontsClick(Sender: TObject);
begin
  PaintBox1.Refresh;
end;

procedure TfrmFontStyle.PageControl1Change(Sender: TObject);
begin
  Paintbox1.Refresh;
end;

procedure TfrmFontStyle.cboColorItemIndexChanged(Sender: TObject);
begin
  FFonttool.Color:=cboColor.Selected;
  FTTFonttool.Color:=cboColor.Selected;
  Paintbox1.refresh;
end;

end.
