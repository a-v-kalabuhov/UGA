unit fBrowse;

interface

{$I EZ_FLAG.PAS}
uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  Buttons, Db, Grids, DBGrids, Menus, ComCtrls, StdCtrls,
  ToolWin, EzBaseGis, Ezsystem, EzBaseExpr, 
  EzBase, Ezlib, ExtCtrls, EzTable, ADODB;

type
  TfrmDemoBrowse = class(TForm)
    ToolBar1: TToolBar;
    Edit1: TToolButton;
    Display1: TToolButton;
    Flash1: TToolButton;
    Extents1: TCheckBox;
    AutoView1: TCheckBox;
    StatusBar1: TStatusBar;
    DataSource1: TDataSource;
    DBGrid1: TDBGrid;
    CboLayers: TComboBox;
    ToolButton1: TToolButton;
    ToolButton2: TToolButton;
    ToolButton3: TToolButton;
    EditMenu: TPopupMenu;
    Undelete1: TMenuItem;
    N1: TMenuItem;
    ToggleSelection1: TMenuItem;
    AddtoSelection1: TMenuItem;
    ADODataSet1: TADODataSet;
    procedure FormShow(Sender: TObject);
    procedure DBGrid1DrawColumnCell(Sender: TObject; const Rect: TRect;
      DataCol: Integer; Column: TColumn; State: TGridDrawState);
    procedure Display1Click(Sender: TObject);
    procedure DataSource1DataChange(Sender: TObject; Field: TField);
    procedure Flash1Click(Sender: TObject);
    procedure Edit1Click(Sender: TObject);
    procedure CboLayersChange(Sender: TObject);
    procedure AddtoSelection1Click(Sender: TObject);
    procedure ToggleSelection1Click(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure ADODataSet1BeforeInsert(DataSet: TDataSet);
  private
    { Private declarations }
    FDrawBox: TEzBaseDrawBox;
    FLayer: TEzBaseLayer;
    FNeedSave: Boolean;
    FSelLayer: TEzSelectionLayer;
    FLayerRecordCount: Integer;
    procedure UpdateSelectionLayer;
    procedure WMSize(var Message: TWMSize); message WM_SIZE;
    procedure WMMove(var Message: TWMMove); message WM_MOVE;
    procedure UpdateStatusBar;
    procedure DrawField(const Value : String;
      const Rect : TRect; vCanvas : TCanvas; vFont: TFont;
      vAlignment: TAlignment; FontStyle : TFontStyles;
      FontColor : TColor; BGColor : TColor);
  public
    { Public declarations }
    procedure CreateParams(var Params: TCreateParams); override;
    procedure Enter(DrawBox: TEzBaseDrawBox; Layer: TEzBaseLayer);
  end;

implementation

{$R *.DFM}

uses
  fMain, EzConsts, EzADOGIS;

procedure TfrmDemoBrowse.Enter(DrawBox: TEzBaseDrawBox; Layer: TEzBaseLayer);
var
  I: Integer;
begin
  FDrawBox := DrawBox;
  FLayer:= Layer;
  Caption:= Format('Browse layer %s', [Layer.Name]);

  with ADODataset1 do
  begin
    Connection:= (FDrawBox.Gis as TEzADOGis).ADOConnection;
    CacheSize := 2000;
    Close;
    CursorType := ctOpenForwardOnly;
    CommandType := cmdText;
    CommandText := Format( 'SELECT * FROM ent_%s', [Layer.name] );
    Parameters.Clear;
    Open;
  end;
  FLayerRecordCount:= FLayer.RecordCount;

  with DrawBox.GIS do
    for i := 0 to Layers.Count - 1 do
       CboLayers.Items.Add( Layers[i].Name);
  CboLayers.ItemIndex := CboLayers.Items.IndexOf(Layer.Name);

  UpdateSelectionLayer;

  self.Show;
end;

procedure TfrmDemoBrowse.FormShow(Sender: TObject);
begin
  FNeedSave:= False;
end;

procedure TfrmDemoBrowse.WMSize(var Message: TWMSize);
begin
  FNeedSave:= True;
  inherited;
end;

procedure TfrmDemoBrowse.WMMove(var Message: TWMMove);
begin
  FNeedSave:= True;
  inherited;
end;

procedure TfrmDemoBrowse.UpdateSelectionLayer;
var
  Index : Integer;
begin
  FSelLayer := nil;
  Index := FDrawBox.Selection.IndexOf(FLayer);
  if Index >= 0 then
     FSelLayer := FDrawBox.Selection[Index];
  if not (csDestroying in ComponentState) then
     DBGrid1.Invalidate;
end;

procedure TfrmDemoBrowse.UpdateStatusBar;
begin
  StatusBar1.simpletext := Format('%d Records. %d Selected (Recno: %d)', [FLayerRecordCount,
     FDrawBox.Selection.NumSelectedInLayer(FLayer), ADODataset1.FieldByName('uid').AsInteger]);
end;

procedure TfrmDemoBrowse.CreateParams(var Params: TCreateParams);
begin
  inherited CreateParams( Params );
  with Params do
  begin
    Style := Style or ws_Overlapped;
    WndParent := Form1.Handle;
  end;
end;

procedure TfrmDemoBrowse.DrawField(const Value : String;
  const Rect : TRect; vCanvas : TCanvas; vFont: TFont;
  vAlignment: TAlignment; FontStyle : TFontStyles;
  FontColor : TColor; BGColor : TColor);
var
  I : Integer;
begin
  I := 0;

  //First, fill in the background color of the cell
  vCanvas.Brush.Color := BGColor;
  vCanvas.FillRect(Rect);
  //SetBkMode ensures that the background is transparent
  SetBkMode(Canvas.Handle, TRANSPARENT);

  //Set the passed font properties
  vCanvas.Font := vFont;
  vCanvas.Font.Color := FontColor;
  vCanvas.Font.Style := vCanvas.Font.Style + FontStyle;

  //Set Text Alignment
  case vAlignment of
    taRightJustify :
      begin
        SetTextAlign(vCanvas.Handle, TA_RIGHT);
        I := Rect.Right - 2;
      end;

    taLeftJustify :
      begin
        SetTextAlign(vCanvas.Handle, TA_LEFT);
        I := Rect.Left + 2;
      end;

    taCenter      :
      begin
        SetTextAlign(vCanvas.Handle, TA_CENTER);
        I := (Rect.Right + Rect.Left) DIV 2;
      end;
  end;

  //Draw the text
  vCanvas.TextRect(Rect, I, Rect.Top + 2, Value);
  SetTextAlign(vCanvas.Handle, TA_LEFT);

end;

procedure TfrmDemoBrowse.DBGrid1DrawColumnCell(Sender: TObject; const Rect: TRect;
  DataCol: Integer; Column: TColumn; State: TGridDrawState);
begin
  with DBGrid1 do
  begin
     if ADODataset1.FieldByName('deleted').AsBoolean then
     begin
        DrawField('', Rect, Canvas, Column.Font,
           Column.Alignment, [], clBlack, clRed);
     end else if (FSelLayer<>nil) and FSelLayer.IsSelected(ADODataset1.FieldByName('uid').AsInteger) then
     begin
        DrawField(Column.Field.DisplayText, Rect, Canvas, Column.Font,
           Column.Alignment, [], clBlack, clYellow);
     end else
        DefaultDrawColumnCell(Rect,DataCol,Column,State);
  end;
end;

procedure TfrmDemoBrowse.Display1Click(Sender: TObject);
begin
  Form1.DrawBox1.SetEntityInViewEx(FLayer.Name,ADODataset1.FieldByName('uid').AsInteger,Extents1.Checked);
end;

procedure TfrmDemoBrowse.DataSource1DataChange(Sender: TObject; Field: TField);
begin
  if Field<>nil then Exit;
  if AutoView1.Checked then
  begin
     Form1.DrawBox1.SetEntityInViewEx(FLayer.Name,ADODataset1.FieldByName('uid').AsInteger,Extents1.Checked);
  end;
  UpdateStatusBar;
end;

procedure TfrmDemoBrowse.Flash1Click(Sender: TObject);
begin
  Form1.DrawBox1.BlinkEntityEx(Flayer.Name,ADODataset1.FieldByName('uid').AsInteger);
end;

procedure TfrmDemoBrowse.Edit1Click(Sender: TObject);
var xy : tpoint ;
begin
  xy := Edit1.ClientToScreen( point( 0, edit1.height ));
  EditMenu.Popup( xy.x , xy.y );
end;

procedure TfrmDemoBrowse.CboLayersChange(Sender: TObject);
begin
  ADODataset1.Active:=False;
  with ADODataset1 do
  begin
    Connection:= (FDrawBox.Gis as TEzADOGis).ADOConnection;
    CacheSize := 2000;
    Close;
    CursorType := ctOpenForwardOnly;
    CommandType := cmdText;
    CommandText := Format( 'SELECT * FROM ent_%s', [CboLayers.Text] );
    Parameters.Clear;
    Open;
  end;
end;

procedure TfrmDemoBrowse.AddtoSelection1Click(Sender: TObject);
begin
  with FDrawBox do
  begin
    Selection.Toggle(FLayer, ADODataset1.FieldByName('uid').AsInteger);
    Selection.Add(FLayer, ADODataset1.FieldByName('uid').AsInteger);
    Repaint;
  end;
end;

procedure TfrmDemoBrowse.ToggleSelection1Click(Sender: TObject);
var
  WasSelected: Boolean;
begin
  WasSelected := FDrawBox.Selection.IsSelected(FLayer, ADODataset1.FieldByName('uid').AsInteger);
  FDrawBox.Selection.Clear;
  if not WasSelected then
     FDrawBox.Selection.Add(FLayer, ADODataset1.FieldByName('uid').AsInteger);
  if AutoView1.Checked then
  begin
     {Show in the map only and only when one is selected}
     FDrawBox.SetEntityInViewEx(FLayer.Name, ADODataset1.FieldByName('uid').AsInteger, Extents1.Checked);
  end;
  UpdateSelectionLayer;
  FDrawBox.Repaint;
end;

procedure TfrmDemoBrowse.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  Action:= caFree;
end;

procedure TfrmDemoBrowse.ADODataSet1BeforeInsert(DataSet: TDataSet);
begin
  Abort;
end;

end.
