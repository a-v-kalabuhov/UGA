unit fAlignment;

{$I ez_flag.pas}
interface

uses
  Windows, Messages, Classes, Controls, Forms, Buttons, ezsystem,
  ezbasicctrls, EzPreview ;

type
  TAlignEntities  = (aeNoChange, aeLefts, aeTops, aeCenters, aeRights, aeBottoms,
                     aeSpaceEqually, aeCenterInPage);
type
  TfrmAlignPalette = class(TForm)
    LeftEdges: TSpeedButton;
    VertCenters: TSpeedButton;
    BottomEdges: TSpeedButton;
    RightEdges: TSpeedButton;
    CenterHinPage: TSpeedButton;
    CenterVertinPage: TSpeedButton;
    SpaceEquallyHor: TSpeedButton;
    VSpaceequal: TSpeedButton;
    HorzCenters: TSpeedButton;
    TopEdges: TSpeedButton;
    procedure LeftEdgesClick(Sender: TObject);
    procedure HorzCentersClick(Sender: TObject);
    procedure CenterHinPageClick(Sender: TObject);
    procedure SpaceEquallyHorClick(Sender: TObject);
    procedure RightEdgesClick(Sender: TObject);
    procedure TopEdgesClick(Sender: TObject);
    procedure VertCentersClick(Sender: TObject);
    procedure CenterVertinPageClick(Sender: TObject);
    procedure VSpaceequalClick(Sender: TObject);
    procedure BottomEdgesClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
  private
    fPreviewBox: TEzPreviewBox;
    procedure AlignEntities(Entities, Records : TList; XAlign, YAlign : TAlignEntities);
    procedure AlignSelected(XAlign, YAlign : TAlignEntities);
  protected
    {$IFDEF LEVEL3}
    procedure CreateParams(var Params: TCreateParams); override;
    {$ENDIF}
  public
    function Enter(PreviewBox: TEzPreviewBox): word;
    {$IFDEF LEVEL4}
    procedure CreateParams(var Params: TCreateParams); override;
    {$ENDIF}
  end;

var
  WinHandle: THandle;

implementation
{$R *.DFM}

uses
   ezlib, ezbasegis, ezentities, fMain;

procedure TfrmAlignPalette.AlignEntities(Entities, Records : TList;
  XAlign, YAlign : TAlignEntities);
var
  i,j     : integer;
  xcenter : Double;
  ycenter : Double;
  deltax  : Double;
  deltay  : Double;
  spacex  : Double;
  spacey  : Double;
  start   : Double;
  cpage   : TEzEntity;
  xctrls  : TStringList;
  yctrls  : TStringList;
  delta   : Double;
  tmpx    : Double;
  tmpy    : Double;
  layer   : TEzBaseLayer;

  function mFloatToStr (Num : Double) : string;
  begin
      Str(Num:14:8, Result);
  end;

  function Width(V: TEzVector): Double;
  begin
     with V.Extension do result := abs(X2-X1);
  end;

  function Height(V: TEzVector): Double;
  begin
     with V.Extension do result := abs(Y2-Y1);
  end;

  function Top(V: TEzVector): Double;
  begin
   result := V.Extension.Y2;
  end;

  function Left(V: TEzVector): Double;
  begin
   result := V.Extension.X1;
  end;

begin
  if Entities.Count = 0 then exit;

  deltax  := 0;
  deltay  := 0;
  spacex  := 0;
  spacey  := 0;
  tmpx    := 0;
  tmpy    := 0;

  cpage := fPreviewBox.PaperShp;
  if (XAlign in [aeCenterInPage, aeSpaceEqually]) or
     (YAlign in [aeCenterInPage, aeSpaceEqually]) then
  begin
      xcenter := 0;
      ycenter := 0;

      for i := 0 to Entities.Count - 1 do
        with TEzEntity(Entities[i]) do
        begin
            xcenter:=xcenter+ left(Points) + (width(Points) / 2);
            ycenter:=ycenter+ Top(Points) - (height(Points) / 2);
            spacex:=spacex+ width(Points);
            spacey:=spacey+ height(Points);
        end;
      xcenter := xcenter / Entities.Count;
      ycenter := ycenter / Entities.Count;

      deltax := left(cpage.Points) + (width(cpage.Points) / 2) - xcenter;
      deltay := ycenter - top(cpage.Points) + (height(cpage.Points) / 2);
    end;

  if (XAlign = aeSpaceEqually) or (YAlign = aeSpaceEqually) then
    begin
      xctrls := TStringList.Create;
      yctrls := TStringList.Create;
      for i := 0 to Entities.Count - 1 do
        with TEzEntity(Entities[i]) do
          begin
            xctrls.AddObject(mFloatToStr(Left(Points)), Entities[i]);
            yctrls.AddObject(mFloatToStr(Top(Points)) , Entities[i]);
          end;
      xctrls.Sort;
      yctrls.Sort;

    if Entities.Count > 1 then
      begin
        if XAlign = aeSpaceEqually then
          try
            spacex:=spacex- width(TEzEntity(xctrls.Objects[xctrls.Count - 1]).Points);
            spacex:=spacex- width(TEzEntity(xctrls.Objects[0]).Points);
            deltax := left(TEzEntity(xctrls.Objects[xctrls.Count - 1]).Points) - left(TEzEntity(xctrls.Objects[0]).Points) -
                      width(TEzEntity(xctrls.Objects[0]).Points);
            deltax := (deltax - spacex) / (xctrls.Count - 1);
            start := left(TEzEntity(xctrls.Objects[0]).Points);
            for i := 0 to xctrls.Count - 1 do
              with TEzEntity(xCtrls.Objects[i]) do
                begin
                  { shift all points a left distance }
                  delta := Left(Points)-start;
                  for j:= 0 to Points.Count-1 do
                     Points[j]:=Point2D(Points[j].X-delta,Points[j].Y);
                  //left := start;
                  start:=start+ width(Points) + deltax;
                end;
          finally
            xCtrls.Free;
          end;

        if YAlign = aeSpaceEqually then
          try
            spacey:=spacey- height(TEzEntity(yctrls.Objects[yctrls.Count - 1]).Points) -
                            height(TEzEntity(yctrls.Objects[0]).Points);
            deltay := abs( top(TEzEntity(yctrls.Objects[yctrls.Count - 1]).Points) - top(TEzEntity(yctrls.Objects[0]).Points) ) -
                      height(TEzEntity(yctrls.Objects[0]).Points);
            deltay := (deltay - spacey) / (yctrls.Count - 1);
            start := Top(TEzEntity(yctrls.Objects[0]).Points);
            for i := 0 to yctrls.Count - 1 do
              with TEzEntity(yCtrls.Objects[i]) do
                begin
                  delta := Top(Points)+start;
                  for j:= 0 to Points.Count-1 do
                     Points[j]:=Point2D(Points[j].X,Points[j].Y-delta);
                  //top := start;
                  start:=start+ height(Points) + deltay;
                end;
          finally
            yCtrls.Free;
          end;
        end;
      end;

  for i := 0 to Entities.Count - 1 do
    with TEzEntity(Entities[i]) do
      begin
        case XAlign of
          aeLefts   : tmpx := Left(TEzEntity(Entities[0]).Points);
          aeCenters : tmpx := Left(TEzEntity(Entities[0]).Points) + (width(TEzEntity(Entities[0]).Points) - width(Points)) / 2;
          aeRights  : tmpx := Left(TEzEntity(Entities[0]).Points) + width(TEzEntity(Entities[0]).Points) - width(Points);
          aeCenterInPage :
            begin
            tmpx:=Left(Points);
            tmpx := tmpx + deltax;
            end;
        end;
        if XAlign in [aeLefts,aeCenters,aeRights,aeCenterInpage] then begin
           delta := Left(Points)-tmpx;
           for j:= 0 to Points.Count-1 do
              Points[j]:=Point2D(Points[j].X-delta,Points[j].Y);
        end;

        case YAlign of
          aeTops    : tmpy  := Top(TEzEntity(Entities[0]).Points);
          aeCenters : tmpy  := Top(TEzEntity(Entities[0]).Points)  - (height(TEzEntity(Entities[0]).Points) - height(Points)) / 2;
          aeBottoms : tmpy  := Top(TEzEntity(Entities[0]).Points)  - (height(TEzEntity(Entities[0]).Points) - height(Points));
          aeCenterInPage :
            begin
            tmpy:=Top(Points);
            tmpy := tmpy - deltay;
            end;
        end;
        if YAlign in [aeTops,aeCenters,aeBottoms,aeCenterInPage] then begin
           delta := Top(Points)-tmpy;
           for j:= 0 to Points.Count-1 do
              Points[j]:=Point2D(Points[j].X,Points[j].Y-delta);
        end;
      end;
  { save the entities }
  layer:= fPreviewBox.Gis.Layers[0];
  for i := 0 to Entities.Count - 1 do
    layer.UpdateEntity(Longint(Records[i]), TEzEntity(Entities[i]));
end;

function TfrmAlignPalette.Enter(PreviewBox: TEzPreviewBox): word;
begin
   fPreviewBox:= PreviewBox;
   Show;
end;

procedure TfrmAlignPalette.CreateParams(var Params: TCreateParams);
begin
  inherited CreateParams( Params );
  with Params do begin
    Style := Style or WS_OVERLAPPED;
    WndParent := WinHandle;
  end;
end;

procedure TfrmAlignPalette.AlignSelected(XAlign, YAlign : TAlignEntities);
var
   i        : Integer;
   Entities : TList;
   Records  : TList;
   ent      : TEzEntity;
begin
   Entities:= TList.Create;
   Records := TList.Create;
   try
      with fPreviewBox do
      begin
         if Selection.NumSelected=0 then exit;
         with Selection[0] do
           for i:= 0 to SelList.Count-1 do
             begin
               ent:= Layer.LoadEntityWithRecno(SelList[i]);
               Entities.Add(ent);
               Records.Add(Pointer(SelList[i]));
             end;
      end;
      AlignEntities(Entities,Records,XAlign,YAlign);
      for i:=0 to Entities.Count-1 do
        TEzEntity(Entities[i]).Free;
      fPreviewBox.Repaint;
   finally
      Entities.free;
      Records.Free;
   end;
end;

procedure TfrmAlignPalette.LeftEdgesClick(Sender: TObject);
begin
   AlignSelected(aeLefts,aeNoChange);
end;

procedure TfrmAlignPalette.HorzCentersClick(Sender: TObject);
begin
   AlignSelected(aeCenters,aeNoChange);
end;

procedure TfrmAlignPalette.CenterHinPageClick(Sender: TObject);
begin
   AlignSelected(aeCenterInPage,aeNoChange);
end;

procedure TfrmAlignPalette.SpaceEquallyHorClick(Sender: TObject);
begin
   AlignSelected(aeSpaceEqually,aeNoChange);
end;

procedure TfrmAlignPalette.RightEdgesClick(Sender: TObject);
begin
   AlignSelected(aeRights,aeNoChange);
end;

procedure TfrmAlignPalette.TopEdgesClick(Sender: TObject);
begin
   AlignSelected(aeNoChange,aeTops);
end;

procedure TfrmAlignPalette.VertCentersClick(Sender: TObject);
begin
   AlignSelected(aeNoChange,aeCenters);
end;

procedure TfrmAlignPalette.CenterVertinPageClick(Sender: TObject);
begin
   AlignSelected(aeNoChange,aeCenterInPage);
end;

procedure TfrmAlignPalette.VSpaceequalClick(Sender: TObject);
begin
   AlignSelected(aeNoChange,aeSpaceEqually)
end;

procedure TfrmAlignPalette.BottomEdgesClick(Sender: TObject);
begin
   AlignSelected(aeNoChange,aeBottoms);
end;

procedure TfrmAlignPalette.FormClose(Sender: TObject; var Action: TCloseAction);
begin
   Action:=caFree;
end;

end.

