unit fSizePo;

{$I EZ_FLAG.PAS}
interface

uses
  Classes, Forms, SysUtils, Controls, StdCtrls, ExtCtrls,
  ezbasegis, ezlib, ezbasicctrls, EzNumEd, EzPreview;

type
  TfrmSizePos = class(TForm)
    OKBtn: TButton;
    CancelBtn: TButton;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    Label8: TLabel;
    Label9: TLabel;
    Label10: TLabel;
    Label11: TLabel;
    Label12: TLabel;
    Label13: TLabel;
    Shape1: TShape;
    Shape2: TShape;
    btnApply: TButton;
    edLeft: TEzNumEd;
    edWidth: TEzNumEd;
    edRight: TEzNumEd;
    edBottom: TEzNumEd;
    edHeight: TEzNumEd;
    edTop: TEzNumEd;
    procedure edLeftChange(Sender: TObject);
    procedure edRightChange(Sender: TObject);
    procedure edTopChange(Sender: TObject);
    procedure edBottomChange(Sender: TObject);
    procedure OKBtnClick(Sender: TObject);
    procedure btnApplyClick(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
  private
    { Private declarations }
    fPreviewBox: TEzPreviewBox;
    fSelectedEnt: TEzEntity;
    fLayer:TEzBaseLayer;
    fRecno:Integer;
    fSuspended: boolean;
    { used to re-calculate values }
    x1,y1,x2,y2,px1,py1,px2,py2,pwidth,pheight: Double;
    PageFrame: TEzEntity;
    procedure Apply;
  public
    { Public declarations }
    function Enter(PreviewBox: TEzPreviewBox): Word;
  end;

implementation

{$R *.DFM}

uses
   ezbase;

function TfrmSizePos.Enter(PreviewBox: TEzPreviewBox): Word;
var
   su: String;
begin
   fPreviewBox:= PreviewBox;
   fSuspended:=true;
   case fPreviewBox.PaperUnits of
      suInches: su:= 'in';
      suMms:    su:= 'mm';
   end;
   Label8.Caption:=su;
   Label9.Caption:=su;
   Label10.Caption:=su;
   Label11.Caption:=su;
   Label12.Caption:=su;
   Label13.Caption:=su;
   PageFrame := fPreviewBox.PaperShp;
   fLayer:= fPreviewBox.Gis.Layers[0];
   fRecno:= fPreviewBox.Selection[0].SelList[0];
   FSelectedEnt:=fLayer.LoadEntityWithRecno(fRecno);
   su:= fSelectedEnt.ClassName;
   su:= Copy(su,4,length(su));
   self.Caption := self.Caption + ' ['+su+']';
   with fSelectedEnt do
   begin
      x1:=dMin(Points[0].X,Points[1].X);
      y1:=dMin(Points[0].Y,Points[1].Y);
      x2:=dMax(Points[0].X,Points[1].X);
      y2:=dMax(Points[0].Y,Points[1].Y);
   end;
   with PageFrame do
   begin
      px1:=dMin(Points[0].X,Points[1].X);
      py1:=dMin(Points[0].Y,Points[1].Y);
      px2:=dMax(Points[0].X,Points[1].X);
      py2:=dMax(Points[0].Y,Points[1].Y);
   end;
   pwidth:= px2-px1;
   pheight:=abs(py2-py1);

   edLeft.numericValue:= x1-px1;
   edRight.numericValue:= px2 -x2;
   edWidth.numericValue:= abs(x2-x1);
   edTop.numericValue:= py2-y2;
   edBottom.numericValue:= y1-py1;
   edHeight.numericValue:= abs(y2-y1);
   fSuspended:=false;
   result := ShowModal;
end;

procedure TfrmSizePos.edLeftChange(Sender: TObject);
begin
   if fSuspended then exit;
   fSuspended:=true;
   edRight.numericValue:= pwidth - edLeft.numericValue - edWidth.numericValue;
   fSuspended:=false;
end;

procedure TfrmSizePos.edRightChange(Sender: TObject);
begin
   if fSuspended then exit;
   fSuspended:=true;
   edLeft.numericValue := pwidth - edRight.numericValue - edWidth.numericValue;
   fSuspended:=false;
end;

procedure TfrmSizePos.edTopChange(Sender: TObject);
begin
   if fSuspended then exit;
   fSuspended:=true;
   edBottom.numericValue := pheight - edTop.numericValue - edHeight.numericValue;
   fSuspended:=false;
end;

procedure TfrmSizePos.edBottomChange(Sender: TObject);
begin
   if fSuspended then exit;
   fSuspended:=true;
   edTop.numericValue := pheight - edBottom.numericValue - edHeight.numericValue;
   fSuspended:=false;
end;

procedure TfrmSizePos.Apply;
var
   TmpR: TEzRect;
begin
   with fSelectedEnt do
   begin
      tmpR.Emin.X := edLeft.numericValue + PageFrame.Points[0].X;
      tmpR.Emax.Y := -edTop.numericValue + PageFrame.Points[0].Y;
      tmpR.Emax.X := tmpR.Emin.X + edWidth.numericValue;
      tmpR.Emin.Y := tmpR.Emax.Y - edHeight.numericValue;
      Points[0] := TmpR.Emin;
      Points[1] := TmpR.Emax;
      UpdateExtension;
   end;
   fLayer.UpdateEntity(fRecno,FSelectedEnt);
end;

procedure TfrmSizePos.OKBtnClick(Sender: TObject);
begin
  Apply;
end;

procedure TfrmSizePos.btnApplyClick(Sender: TObject);
begin
  Apply;
  fPreviewBox.Repaint;
end;

procedure TfrmSizePos.FormDestroy(Sender: TObject);
begin
  if Assigned(FSelectedEnt) then
    FSelectedEnt.Free;
end;

end.
