unit fLineType;

{$I EZ_FLAG.PAS}
interface

uses Windows, SysUtils, Classes, Graphics, Forms, Controls, StdCtrls,
  Buttons, ExtCtrls, Dialogs, ezbase, ezbasegis, Mask, EzNumEd,
  EzMiscelCtrls, EzColorPicker;

type
  TfrmLineType = class(TForm)
    OKBtn: TButton;
    CancelBtn: TButton;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    PBox1: TPaintBox;
    Label4: TLabel;
    btnCalc: TButton;
    EdScale: TEzNumEd;
    Edit1: TEzNumEd;
    Label5: TLabel;
    cboColor: TEzColorBox;
    ltlist1: TEzLinetypeListBox;
    procedure EdScaleChange(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure OKBtnClick(Sender: TObject);
    procedure PBox1Paint(Sender: TObject);
    procedure btnCalcClick(Sender: TObject);
    procedure cboColorChange(Sender: TObject);
    procedure FormPaint(Sender: TObject);
    procedure ltlist1Click(Sender: TObject);
  private
    { Private declarations }
    FDrawBox: TEzBaseDrawBox;
    FStyleTouched:Boolean;
    FColorTouched:Boolean;
    FScaleTouched:Boolean;
    FPentool:TEzPentool;
    FMultiSelect:Boolean;
  public
    { Public declarations }
    function Enter(DrawBox: TEzBaseDrawBox):Word;
  end;

implementation

{$R *.dfm}

uses
  ezsystem, ezlib, EzLineDraw, fMain, EzEntities;

function TfrmLineType.Enter(DrawBox: TEzBaseDrawBox):Word;
var
  SelLayer:TEzSelectionLayer;
  Entity:TEzEntity;

  procedure InitGlobally;
  begin
    FPentool.Assign(Ez_Preferences.DefPenStyle);
  end;

begin
  FDrawBox:=DrawBox;
  FPentool:=TEzPentool.Create;
  LtList1.Populate;

  with DrawBox do
  begin
    if Selection.NumSelected = 1 then
    begin
      SelLayer:= Selection[0];
      Entity:= SelLayer.Layer.LoadEntityWithRecno(SelLayer.SelList[0]);
      try
        if Entity is TEzOpenedEntity then
          FPentool.Assign(TEzOpenedEntity(Entity).Pentool);
      finally
        Entity.Free;
      end;
    end else
    begin
      InitGlobally;
      fMultiSelect:=true;
    end;
  end;
  LtList1.ItemIndex:= FPentool.Style;
  cboColor.Selected:= FPentool.Color;
  EdScale.NumericValue:= FPentool.Scale;

  result:=ShowModal;
end;

procedure TfrmLineType.EdScaleChange(Sender: TObject);
begin
  if fMultiSelect then
    FScaleTouched:=true;
  PBox1.Invalidate;
end;

procedure TfrmLineType.FormDestroy(Sender: TObject);
begin
  FPentool.Free;
end;

procedure TfrmLineType.OKBtnClick(Sender: TObject);
var
  SelLayer:TEzSelectionLayer;
  Entity:TEzEntity;
  i,j:Integer;

  procedure SetLineStyle(Tool:TEzPentool);
  begin
    if fMultiSelect then
    begin
      if fStyleTouched then
        Tool.Style:= FPentool.Style;
      if fColorTouched then
        Tool.Color:= FPentool.Color;
      if fScaleTouched then
        Tool.Scale:= FPentool.Scale;
    end else
      Tool.Assign(FPentool);
  end;

begin
  if fMultiSelect and not fStyleTouched and not fColorTouched and not fScaleTouched then exit;
  FPentool.Style:= LtList1.ItemIndex;
  FPentool.Scale:= EdScale.NumericValue;
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
            if Entity is TEzOpenedEntity then
            begin
              SetLinestyle(TEzOpenedEntity(Entity).Pentool);
              SelLayer.Layer.UpdateEntity(SelLayer.SelList[J],Entity);
            end;
          finally
            Entity.Free;
          end;
        end;
      end;
    end else
      SetLinestyle(Ez_Preferences.DefPenStyle);
  end;
end;

procedure TfrmLineType.PBox1Paint(Sender: TObject);
var
  PenWidth:integer;
  tmpRect: TRect;
  Boundsr:TRect;
  Grapher: TEzGrapher;
  Symbol: TEzSymbol;
  Rgn: HRgn;
  tmpMarginX, tmpMarginY: Double;
  linetype: Integer;
  e:TEzRect;
  dist:Double;
  V:TEzVector;
  PenStyle: TEzPenStyle;
  Repit:Integer;
  PtArr: Array[0..5] of TPoint;
  I: Integer;
  Parts: Array[0..0] of Integer;
  ALineColor: TColor;
begin
  Repit:= ezlib.IMax(1,trunc(edScale.NumericValue));
  with PBox1.Canvas do
  begin
     tmpRect:=PBox1.ClientRect;
     Boundsr:= PBox1.ClientRect;
     InflateRect(Boundsr,-1,-1);
     DrawEdge(Handle,Boundsr,EDGE_RAISED, BF_RECT {or BF_MIDDLE or BF_FLAT});
     if LtList1.ItemIndex <= 0 then Exit;
     Pen.Style := psSolid;
     ALineColor:= cboColor.Selected;
     Pen.Color := ALineColor;
     PenWidth := trunc(edScale.NumericValue);
     linetype:= LtList1.ItemIndex-2;
     InflateRect(Boundsr,-2,-2);
     Brush.Style:= bsSolid;
     Brush.Color:= Self.Color;
     FillRect(Boundsr);

     { DRAW THE LINE TYPE }
     Symbol:= nil;
     if linetype>=MAX_LINETYPES then
     begin
       Symbol:= Ez_Linetypes[linetype-MAX_LINETYPES];
       if EqualRect2D(Symbol.Extension, INVALID_EXTENSION) then Exit;
     end;
     Grapher:= TEzGrapher.Create(10,adScreen);
     try
       with Boundsr do
         Grapher.SetViewport(Left, Top, Right, Bottom);
       dist:=0;
       if linetype>=MAX_LINETYPES then
       begin
         e:= Symbol.Extension;
         dist:=(e.Emax.X - e.Emin.X);
       end;
       V:=TEzVector.Create(2);
       try
         V.Add(Point2d(79.5962, -183.5197));
         V.Add(Point2d(115.3312, -118.4707));
         V.Add(Point2d(132.3612, -167.3272));
         V.Add(Point2d(180.1011, -119.8666));
         V.Add(Point2d(180.1011, -183.5197));
         V.Add(Point2d(79.5962, -183.5197));
         e:=V.Extension;
         with e do
         begin
           TmpMarginX:= (Emax.X - Emin.X) / 20;
           TmpMarginY:= (Emax.Y - Emin.Y) / 20;
           Grapher.SetWindow( Emin.X - TmpMarginX,
                              Emax.X + TmpMarginX,
                              Emin.Y - TmpMarginY,
                              Emax.Y + TmpMarginY );
         end;
         with Canvas do
         begin
           with Boundsr do
             Rgn:= CreateRectRgn(Left, Top, Right, Bottom);
           SelectClipRgn(Handle, Rgn);
           try
             if linetype>=MAX_LINETYPES then
             begin
               PenStyle.Style:=1;
               PenStyle.Style:=1;
//               Penstyle.Width:=Dist2d(V[0],V[1])/(dist*Repit);  // the scale factor
               Penstyle.Color:=ALineColor;
               Symbol.DrawVector( V,
                                  Penstyle,Dist2d(V[0],V[1])/(dist*Repit),
                                  Grapher,
                                  PBox1.Canvas,
                                  Grapher.CurrentParams.VisualWindow,
                                  IDENTITY_MATRIX2D,
                                  dmNormal );
             end else if ( linetype >=0 ) and ( linetype <= Pred(MAX_LINETYPES) ) then
             begin
               for I:= 0 to V.Count-1 do
                PtArr[I]:= Grapher.RealToPoint(V[I]);
                Parts[0]:= V.Count;
                PolyDDA( PtArr,
                         Parts,
                         1,
                         PBox1.Canvas,
                         Grapher,
                         linetype+1,
                         ALineColor, 1 );
             end else
             begin
               PenStyle.Style:=1;
               //Penstyle.Scale:=Grapher.PointsToDistY(PenWidth);
               Penstyle.Color:=ALineColor;
               V.DrawOpened( PBox1.Canvas,
                             Grapher.CurrentParams.VisualWindow,
                             V.Extension,
                             Grapher,
                             PenStyle,
                             Grapher.PointsToDistY(PenWidth),
                             IDENTITY_MATRIX2D,
                             dmNormal );
             end;
           finally
             SelectClipRgn(Handle, 0);
             DeleteObject(Rgn);
           end;
         end;
       finally
         V.free;
       end;
     finally
       Grapher.Free;
     end;
  end;
end;

procedure TfrmLineType.btnCalcClick(Sender: TObject);
var
  ent:TEzEntity;
  p1,p2:TEzPoint;
  symbol:TEzSymbol;
  e:TEzRect;
  d:Double;
begin
  if (LtList1.ItemIndex<2) or (Edit1.NumericValue<1) then exit;
  symbol:=Ez_Linetypes[LtList1.ItemIndex-2];
  e:=Symbol.Extension;
  d:=abs(e.x2-e.x1);
  if FDrawBox.Selection.NumSelected>0 then
  begin
    with FDrawBox.Selection[0] do
      ent:=Layer.LoadEntityWithRecno(SelList[0]);
    if ent=nil then exit;
    try
      if (ent.EntityID in [idPolyline,idPolygon,idSpline,idRectangle]) and
        (ent.DrawPoints.Count>1) then
      begin
        p1:=ent.DrawPoints[0];
        p2:=ent.DrawPoints[1];
        EdScale.NumericValue:=(Dist2d(p1,p2)*0.99)/(d*Edit1.NumericValue);
      end;
    finally
      ent.free;
    end;
  end;
end;

procedure TfrmLineType.cboColorChange(Sender: TObject);
begin
  FPentool.Color:= cboColor.Selected;
  if fMultiSelect then FColorTouched:=true;
  PBox1.Refresh;
end;

procedure TfrmLineType.FormPaint(Sender: TObject);
//var
  //i: Integer;
begin
  //for i := 0 to Self.ControlCount - 1 do
  //  ShadeIt(Self, Self.Controls[i], 3, clGray);
end;

procedure TfrmLineType.ltlist1Click(Sender: TObject);
begin
  if fMultiSelect then fStyleTouched := true;
  PBox1.Invalidate;
  if LtList1.ItemIndex < 2 then
    label3.caption:= 'Width'
  else if ( LtList1.ItemIndex > 1 ) and ( LtList1.ItemIndex <= Succ(MAX_LINETYPES) ) then
    label3.caption:= 'Width'
  else if LtList1.ItemIndex > Succ(MAX_LINETYPES) then
    label3.caption:= 'Scale';
  label3.enabled:= ( LtList1.ItemIndex = 1 ) or ( LtList1.ItemIndex > Succ(MAX_LINETYPES) );
  EdScale.Enabled:= label3.enabled;
end;


end.
