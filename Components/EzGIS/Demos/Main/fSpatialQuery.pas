unit fSpatialQuery;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, Buttons, ComCtrls, EzBaseGIS, EzBase, EzLib,
  fVectorialExpr, fExpressBuilder, EzCmdLine;

type
  TfrmSpatialQuery = class(TForm)
    Panel1: TPanel;
    Panel2: TPanel;
    Panel3: TPanel;
    Panel4: TPanel;
    Label1: TLabel;
    Memo1: TMemo;
    SpeedButton1: TSpeedButton;
    Panel6: TPanel;
    Label2: TLabel;
    cboOrder1: TComboBox;
    SpeedButton2: TSpeedButton;
    Label3: TLabel;
    Label4: TLabel;
    cboOrder2: TComboBox;
    SpeedButton3: TSpeedButton;
    Label5: TLabel;
    cboOrder3: TComboBox;
    SpeedButton4: TSpeedButton;
    chkDesc1: TCheckBox;
    chkDesc2: TCheckBox;
    chkDesc3: TCheckBox;
    Panel5: TPanel;
    Splitter1: TSplitter;
    Panel7: TPanel;
    cboOp1: TComboBox;
    Memo2: TMemo;
    Panel8: TPanel;
    Splitter2: TSplitter;
    Panel9: TPanel;
    LBJoin: TListBox;
    Button2: TButton;
    Button3: TButton;
    Label8: TLabel;
    Memo3: TMemo;
    Panel11: TPanel;
    PageControl1: TPageControl;
    TabSheet1: TTabSheet;
    SpeedButton5: TSpeedButton;
    TabSheet2: TTabSheet;
    Button1: TSpeedButton;
    MemoStd: TMemo;
    MemoVect: TMemo;
    procedure cboOp1Change(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure SpeedButton5Click(Sender: TObject);
    procedure SpeedButton1Click(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure Button2Click(Sender: TObject);
    procedure Memo1Change(Sender: TObject);
    procedure SpeedButton2Click(Sender: TObject);
    procedure SpeedButton3Click(Sender: TObject);
    procedure SpeedButton4Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
  private
    { Private declarations }
    FDrawBox: TEzBaseDrawBox;
    FCmdLine: TEzCmdLine;
    FLayer: TEzBaseLayer;
    FOwnerForm: TCustomForm;
    FfrmExprBuilder: TfrmExprBuilder;
    FfrmVectorialExpr: TfrmVectorialExpr;
    procedure CalcExpression;
  public
    { Public declarations }
    procedure Enter(OwnerForm: TCustomForm; DrawBox: TEzBaseDrawBox; CmdLine: TEzCmdLine; Layer: TEzBaseLayer);
    procedure CreateParams(var Params: TCreateParams); override;

    property frmExprBuilder: TfrmExprBuilder read FfrmExprBuilder write FfrmExprBuilder;
    property frmVectorialExpr: TfrmVectorialExpr read FfrmVectorialExpr write FfrmVectorialExpr;
  end;

implementation

uses
  fMain, fExpress, fSelec, EzSystem;

{$R *.dfm}

{ TfrmSpatialQuery }

procedure  TfrmSpatialQuery.Enter(OwnerForm: TCustomForm; DrawBox: TEzBaseDrawBox;
  CmdLine: TEzCmdLine; Layer: TEzBaseLayer);
var
  i: Integer;
  Accept:boolean;
  Identifier,Layername: string;
begin
  FOwnerForm:= OwnerForm;
  FDrawBox:= DrawBox;
  FCmdLine:= CmdLine;
  FLayer:= Layer;
  for I:= 0 to FDrawBox.GIS.Layers.Count-1 do
    If AnsiCompareText( FDrawBox.GIS.Layers[i].Name, FLayer.Name) <> 0 then
      LBJoin.Items.Add(FDrawBox.GIS.Layers[i].Name);

  Panel3.Caption:= Panel3.Caption + Layer.Name;

  Caption:= Caption + ' - ' + Layer.Name;

  cboOp1.ItemIndex:= 0;

  { populate combos with fields }
  Layer.PopulateFieldList(cboOrder1.Items, False);
  with Layer.Layers do
    if Assigned( Gis.OnStartExternalPopulate ) And
       Assigned( Gis.OnExternalPopulate ) then
    begin
      Accept:= True;
      Gis.OnStartExternalPopulate( Gis, Layer.Name, Accept );
      if Accept then
      begin
        Identifier := '';
        Gis.OnExternalPopulate( Gis, Layer.Name, Identifier );
        LayerName:= Layer.Name;
        if AnsiPos( #32, LayerName ) > 0 then
          Identifier:= '[' + LayerName + ']';
        While Length( Identifier ) > 0 do
        begin
          if AnsiPos( #32, Identifier ) > 0 then
            Identifier:= '[' + Identifier + ']';
          cboOrder1.Items.AddObject( LayerName + '.' + Identifier, Pointer(1) );
          Identifier := '';
          Gis.OnExternalPopulate( Gis, Layer.Name, Identifier );
        end;
        if Assigned( Gis.OnEndExternalPopulate ) then
          Gis.OnEndExternalPopulate( Gis, Layer.Name );
      End;
    end;
  cboOrder2.Items.Assign(cboOrder1.Items);
  cboOrder3.Items.Assign(cboOrder1.Items);

  FOwnerForm.Hide;

  Show;
end;

procedure TfrmSpatialQuery.CreateParams(var Params: TCreateParams);
begin
  Inherited CreateParams( Params );
  With Params Do
  Begin
    Style := Style Or ws_Overlapped;
    WndParent := fMain.Form1.Handle;
  end;
end;

procedure TfrmSpatialQuery.cboOp1Change(Sender: TObject);
begin
  If cboOp1.ItemIndex < 0 then exit;
  case TEzGraphicOperator(cboOp1.ItemIndex) of
    goWithin:
      begin
        Memo2.Text:= 'Entity A is Within Entity B ( partially or fully inside )';
      end;
    goEntirelyWithin:
      begin
        Memo2.Text:= 'Entity A is Entirely Within Entity B if A''s boundary is entirely within B''s boundary' ;
      end;
    goContains:
      begin
        Memo2.Text:='Entity A Contains Entity B if B''s boundary is anywhere within A''s boundary ';
      end;
    goContainsEntire:
      begin
        Memo2.Text:='Entity A Contains Entire Entity B if B''s boundary is entirely within A''s boundary ';
      end;
    goIntersects:
      begin
        Memo2.Text:='Entity A Intersects Entity B if they have at least one point in common or if one of them is entirely within the other.';
      end;
    goEntirelyWithinNoEdgeTouched:
      begin
        Memo2.Text:='Entity A is Entirely Within Entity B if A''s boundary is entirely within B''s boundary. Additionally Entity A does not touch boundaries of entity B';
      end;
    goContainsEntireNoEdgeTouched:
      begin
        Memo2.Text:='Entity A Contains Entire Entity B if B''s boundary is entirely within A''s boundary. Additionaly, Entity B does not touch boundaries of entity A.';
      end;
    goExtentOverlaps:
      begin
        Memo2.Text:='The extents of entity A overlaps the extents of entity B';
      end;
    goShareCommonPoint:
      begin
        Memo2.Text:='Entity A share at least one identical common point with Entity B';
      end;
    goShareCommonLine:
      begin
        Memo2.Text:='Entity A have at least one line segment identical to Entity B';
      end;
    goLineCross:
      begin
        Memo2.Text:='Entity A intersects to Entity B. The difference with operator INTERSECTS is that this last considere intersection also if Entity A is fully inside Entity B or viceversa';
      end;
    goCommonPointOrLineCross:
      begin
        Memo2.Text:='Both SHARE COMMON POINT and SHARE COMMON LINE combined';
      end;
    goEdgeTouch:
      begin
        Memo2.Text:='Entity A touches entity B or Entity B touches entity A without both having common area';
      end;
    goEdgeTouchOrIntersect:
      begin
        Memo2.Text:='Entity A touches entity B or Entity B touches entity A or both having common area ';
      end;
    goPointInPolygon:
      begin
        Memo2.Text:='First Point of Entity A is inside Polygon B';
      end;
    goCentroidInPolygon:
      begin
        Memo2.Text:='Centroid of Entity A is inside Polygon B';
      end;
    goIdentical:
      begin
        Memo2.Text:='Entity A is identical to Entity B in the point coordinates, not in the features (fill color, line color, etc.).';
      end;
  end;
  CalcExpression;
end;

procedure TfrmSpatialQuery.Button1Click(Sender: TObject);
var
  JoinLayer: TEzBaseLayer;
begin
  If LBJoin.ItemIndex<0 then exit;
  JoinLayer:= FDrawBox.GIS.Layers.LayerByname(LBJoin.Items[LBJoin.ItemIndex]);
  If FfrmVectorialExpr = Nil Then
    FfrmVectorialExpr:=TfrmVectorialExpr.create(nil);
  FfrmVectorialExpr.Enter(Self, Self.FDrawBox, Self.FCmdLine, JoinLayer);
end;

procedure TfrmSpatialQuery.SpeedButton5Click(Sender: TObject);
var
  JoinLayer: TEzBaseLayer;
begin
  If LBJoin.ItemIndex < 0 then exit;
  JoinLayer:= FDrawBox.GIS.Layers.LayerByname(LBJoin.Items[LBJoin.ItemIndex]);
  with TfrmExprBuilder.create(nil) do
    try
      If Enter(JoinLayer) = mrOk then
        self.MemoStd.Text:= Edit1.Text;
    finally
      free;
    end;
end;

procedure TfrmSpatialQuery.SpeedButton1Click(Sender: TObject);
begin
  with TfrmExprBuilder.create(nil) do
    try
      If Enter(FLayer) = mrOk then
        self.Memo1.Text:= Edit1.Text;
    finally
      free;
    end;
end;

procedure TfrmSpatialQuery.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  If FfrmVectorialExpr <> Nil then FreeAndNil( FfrmVectorialExpr );
  TfrmSelectDlg(FOwnerForm).frmSpatialQuery:= Nil;
  FOwnerForm.Show;

  Action:= caFree;
end;

procedure TfrmSpatialQuery.CalcExpression;
var
  temp,sort,vect: string;
begin
  If LBJoin.ItemIndex < 0 then exit;
  temp:= FLayer.Name;
  if AnsiPos(#32,temp)>0 then
    temp:= '[' + temp + ']';
  temp:= temp + '.ENT ' + cboOp1.Text + #32;

  temp := temp + LBJoin.Items[LBJoin.ItemIndex] + '.ENT SCOPE (';
  vect:='';
  vect:= trim(MemoVect.Text);

  temp := temp + vect;

  If Length(MemoStd.Text) > 0 then
  begin
    if length(vect)>0 then
      temp := temp + ' AND ' + MemoStd.Text
    else
      temp := temp + MemoStd.Text
  end;

  temp := temp + ')';

  If Length( Trim(Memo1.Text) ) > 0 then
    temp:= temp + ' AND ' + Memo1.Text;

  If (Length(cboOrder1.Text)>0) or (Length(cboOrder2.Text)>0) or
    (Length(cboOrder3.Text)>0) then
  begin
    sort:= 'ORDER BY ';
    if (Length(cboOrder1.Text)>0) then
    begin
      sort:= sort + cboOrder1.Text;
      if chkDesc1.Checked then
        sort:= sort + ' DESC,';
    end;
    if (Length(cboOrder2.Text)>0) then
    begin
      sort:= sort + cboOrder2.Text;
      if chkDesc2.Checked then
        sort:= sort + ' DESC,';
    end;
    if (Length(cboOrder3.Text)>0) then
    begin
      sort:= sort + cboOrder3.Text;
      if chkDesc3.Checked then
        sort:= sort + ' DESC,';
    end;
    sort:= copy(sort,1,length(sort)-1);
    temp:= temp + sort;
  end;

  Memo3.Text:= temp;
end;

procedure TfrmSpatialQuery.Button2Click(Sender: TObject);
begin
  TfrmSelectDlg(FOwnerForm).Memowhere.Text:= Memo3.text;
  Close;
end;

procedure TfrmSpatialQuery.Memo1Change(Sender: TObject);
begin
  CalcExpression;
end;

procedure TfrmSpatialQuery.SpeedButton2Click(Sender: TObject);
begin
  with TfrmExprBuilder.create(nil) do
    try
      If Enter(FLayer) = mrOk then
        self.cboOrder1.Text:= Edit1.Text;
    finally
      free;
    end;
end;

procedure TfrmSpatialQuery.SpeedButton3Click(Sender: TObject);
begin
  with TfrmExprBuilder.create(nil) do
    try
      If Enter(FLayer) = mrOk then
        self.cboOrder2.Text:= Edit1.Text;
    finally
      free;
    end;
end;

procedure TfrmSpatialQuery.SpeedButton4Click(Sender: TObject);
begin
  with TfrmExprBuilder.create(nil) do
    try
      If Enter(FLayer) = mrOk then
        self.cboOrder3.Text:= Edit1.Text;
    finally
      free;
    end;
end;

procedure TfrmSpatialQuery.Button3Click(Sender: TObject);
begin
  Close;
end;

end.
