unit fLayers;

{$I EZ_FLAG.PAS}
interface

uses Windows, SysUtils, Classes, Graphics, Forms, Controls, StdCtrls,
  Buttons, ExtCtrls, ComCtrls, Dialogs, ezbasegis, Grids, EzMiscelCtrls, Menus;

type

  TfrmLayers = class(TForm)
    BitBtn1: TBitBtn;
    Button1: TButton;
    GroupBox1: TGroupBox;
    btnAdd: TButton;
    btnDelete: TButton;
    GroupBox2: TGroupBox;
    BtnUp: TSpeedButton;
    BtnDown: TSpeedButton;
    LayerList1: TEzLayerListBox;
    Button2: TButton;
    PopupMenu1: TPopupMenu;
    Standard1: TMenuItem;
    ArcView1: TMenuItem;
    Micro1: TMenuItem;
    OpenDialog1: TOpenDialog;
    OpenDialog2: TOpenDialog;
    procedure btnDeleteClick(Sender: TObject);
    procedure BtnUpClick(Sender: TObject);
    procedure BtnDownClick(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure FormPaint(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Standard1Click(Sender: TObject);
    procedure btnAddClick(Sender: TObject);
    procedure ArcView1Click(Sender: TObject);
    procedure Micro1Click(Sender: TObject);
  private
    { Private declarations }
    FDrawBox: TEzBaseDrawBox;
  public
    { Public declarations }
    function Enter(DrawBox: TEzBaseDrawBox): Word;
  end;

implementation

{$R *.dfm}

uses
  EzBasicCtrls, ezlib, fNewLayer, ezbase, fMain, fLayerOpts, fDGNParams,
  EzDGNLayer;

function TfrmLayers.Enter(DrawBox: TEzBaseDrawBox): Word;
begin
  FDrawBox:= DrawBox;
  LayerList1.Gis:= DrawBox.GIS;
  Result:= ShowModal;
end;

procedure TfrmLayers.btnDeleteClick(Sender: TObject);
var
  wasActive: boolean;
  Index: Integer;
  Layer: TEzBaseLayer;
begin
  Index:= FDrawBox.Gis.Layers.Count- LayerList1.Row;
  if Index < 0 then Exit;
  if MessageDlg('Are you sure you want to delete this layer ?', mtConfirmation,[mbYes,mbNo],0)<>mrYes then exit;
  Layer:= FDrawBox.GIS.Layers[Index];
  with FDrawBox.GIS do
  begin
    WasActive:= AnsiComparetext(MapInfo.CurrentLayer, Layer.Name)=0;
    Layers.Delete(Layers[Index].Name, False);   // False= don't delete files
    LayerList1.LayoutChanged;
    if WasActive and (Layers.Count > 0) then
      MapInfo.CurrentLayer:= Layers[0].Name;
    if Layers.Count = 0 then
      with MapInfo do
      begin
        Extension:= INVALID_EXTENSION;
        CurrentLayer:= '';
      end;
  end;
  LayerList1.Gis:= Nil;
  LayerList1.Gis:= FDrawBox.GIS;
end;

procedure TfrmLayers.BtnUpClick(Sender: TObject);
var
  Index: Integer;
begin
  Index := FDrawBox.GIS.Layers.Count - LayerList1.Row;
  Index:= FDrawBox.GIS.Layers.LayerDown( Index );
  if Index >= 1 then
    LayerList1.Row := LayerList1.Row - 1;
  LayerList1.Invalidate;
end;

procedure TfrmLayers.BtnDownClick(Sender: TObject);
var
  Index: Integer;
begin
  Index := FDrawBox.GIS.Layers.Count - LayerList1.Row;
  Index:= FDrawBox.GIS.Layers.LayerUp( Index );
  if (Index >= 0) And (Index < LayerList1.RowCount) then
    LayerList1.Row := LayerList1.Row + 1;
  LayerList1.Invalidate;
end;

procedure TfrmLayers.Button1Click(Sender: TObject);
begin
  FDrawBox.GIS.RepaintViewports;
end;

procedure TfrmLayers.FormPaint(Sender: TObject);
var
  i: Integer;
begin
  for i := 0 to Self.ControlCount - 1 do
    ShadeIt(Self, Self.Controls[i], 3, clGray);
end;

procedure TfrmLayers.Button2Click(Sender: TObject);
var
  ALayer: TEzBaseLayer;
  Index: integer;
begin
  Index := FDrawBox.GIS.Layers.Count - LayerList1.Row;
  if Index < 0 then Exit;
  ALayer:= FDrawBox.GIS.Layers[Index];
  with TfrmLayerOptions.create(application) do
    try
      Enter(ALayer.Name);
    finally
      free;
    end;
end;

procedure TfrmLayers.Standard1Click(Sender: TObject);
var
  NewLayer: TfrmNewLayer;

  procedure CreateTheNewLayer;
  var
    TmpName: string;
  begin
    if not FDrawBox.GIS.MapInfo.Isvalid then exit;
    with NewLayer do
      with FDrawBox.GIS do
      begin
        TmpName:= Trim(Edit1.Text);
        if Layers.IndexOfName(TmpName) >= 0 then
        begin
          ShowMessage('Layer is already on map !');
          Exit;
        end;
        IF ChkAnimated.Checked THEN
          Layers.CreateNewAnimation(ExtractFilePath(FileName) + TmpName)
        ELSE IF ChkCosmethic.Checked THEN
          Layers.CreateNewCosmethic(ExtractFilePath(FileName) + TmpName)
        ELSE
          Layers.CreateNew(ExtractFilePath(FileName) + TmpName, FieldList);
        if Layers.IndexOfName(TmpName) >= 0 then
        begin
          MapInfo.CurrentLayer:= TmpName;
          LayerList1.LayoutChanged;
        end;
        Modified:= true;
      end;
  end;

begin
  NewLayer:= TfrmNewLayer.Create(Nil);
  with NewLayer do
    try
      if Enter( FDrawBox.Gis ) = mrOk then
        CreateTheNewLayer;
    finally
      free;
    end;
end;

procedure TfrmLayers.btnAddClick(Sender: TObject);
var
  TmpPt: TPoint;
begin
  TmpPt := GroupBox1.ClientToScreen(Point(BtnAdd.Left,BtnAdd.Top + BtnAdd.Height));
  Popupmenu1.Popup( TmpPt.x, TmpPt.y );
end;

procedure TfrmLayers.ArcView1Click(Sender: TObject);
var
  Index: Integer;
begin
  If Not OpenDialog1.Execute then Exit;
  Index:= EzBasicCtrls.AddShapeLayer( FDrawBox.GIS, OpenDialog1.FileName, false );
  If Index >= 0 then
    FDrawBox.GIS.Layers[Index].Open;
end;

procedure TfrmLayers.Micro1Click(Sender: TObject);
var
  I, Index: Integer;
  AHeader: TEzDGNHeader;
begin
  If Not OpenDialog2.Execute Then Exit;
  Index:= EzBasicCtrls.AddDGNLayer( FDrawBox.GIS, OpenDialog2.FileName, false );
  If Index>=0 then
  begin
    { Ask for the DGN parameters }
    with TfrmDGNParams.Create(Nil) do
      try
        If ShowModal=mrOk then
        begin
          for I:= 0 to 63 do
            AHeader.IncludedLevels[I]:= chkList1.Checked[I];
          AHeader.UseTrueType:= chkTrueType.Checked;
          AHeader.UseDefaultColorTable:= chkDefColor.Checked;
          AHeader.MemoryLoaded:= chkMemLoaded.Checked;

          TDGNLayer( Self.FDrawBox.GIS.Layers[Index] ).DGNHeader:= AHeader;
        end;
      finally
        free;
      end;
    FDrawBox.GIS.Layers[Index].Open;
  end;
end;

end.
