unit fBrowse;

interface

{$I EZ_FLAG.PAS}
uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  Buttons, Db, Grids, DBGrids, Menus, ComCtrls, StdCtrls,
  ToolWin, EzBaseGis, Ezsystem, EzBaseExpr,
  EzBase, Ezlib, ExtCtrls, EzTable;

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
    EzTable1: TEzTable;
    procedure FormShow(Sender: TObject);
    procedure DBGrid1DrawColumnCell(Sender: TObject; const Rect: TRect;
      DataCol: Integer; Column: TColumn; State: TGridDrawState);
    procedure Display1Click(Sender: TObject);
    procedure DataSource1DataChange(Sender: TObject; Field: TField);
    procedure Flash1Click(Sender: TObject);
    procedure Undelete1Click(Sender: TObject);
    procedure Edit1Click(Sender: TObject);
    procedure EzTable1BeforeInsert(DataSet: TDataSet);
    procedure CboLayersChange(Sender: TObject);
    procedure AddtoSelection1Click(Sender: TObject);
    procedure ToggleSelection1Click(Sender: TObject);
    procedure EzTable1AfterOpen(DataSet: TDataSet);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
  private
    { Private declarations }
    FDrawBox: TEzBaseDrawBox;
    FLayer: TEzBaseLayer;
    FNeedSave: Boolean;
    FSelLayer: TEzSelectionLayer;
    procedure SetCaption( const Layername: string );
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

var
  BrowseParentHWND: THandle;

implementation

{$R *.DFM}

uses
  EzConsts, fMain;

procedure TfrmDemoBrowse.Enter(DrawBox: TEzBaseDrawBox; Layer: TEzBaseLayer);
var
  I: Integer;
begin
  FDrawBox := DrawBox;
  FLayer:= Layer;
  SetCaption(FLayer.Name);

  EzTable1.GIS:= DrawBox.GIS;
  EzTable1.Active:=False;
  EzTable1.Layername:= Layer.Name;
  EzTable1.Active:=True;

  with DrawBox.GIS do
    for i := 0 to Layers.Count - 1 do
       CboLayers.Items.Add( Layers[i].Name);
  CboLayers.ItemIndex := CboLayers.Items.IndexOf(Layer.Name);

  UpdateSelectionLayer;

  self.Show;
end;

procedure TfrmDemoBrowse.SetCaption( const Layername: string );
Begin
  Caption:= Format('Browse layer %s', [LayerName]);
End;

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
  StatusBar1.simpletext := Format('%d Records. %d Selected (Recno: %d)', [EzTable1.RecordCount,
     FDrawBox.Selection.NumSelectedInLayer(FLayer), EzTable1.SourceRecno]);
end;

procedure TfrmDemoBrowse.CreateParams(var Params: TCreateParams);
begin
  inherited CreateParams( Params );
  with Params do
  begin
    Style := Style or ws_Overlapped;
    WndParent := BrowseParentHWND;
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
     if EzTable1.IsDeleted then
     begin
        DrawField('', Rect, Canvas, Column.Font,
           Column.Alignment, [], clBlack, clRed);
     end else if (FSelLayer<>nil) and FSelLayer.IsSelected(EzTable1.SourceRecno) then
     begin
        DrawField(Column.Field.DisplayText, Rect, Canvas, Column.Font,
           Column.Alignment, [], clBlack, clYellow);
     end else
        DefaultDrawColumnCell(Rect,DataCol,Column,State);
  end;
end;

procedure TfrmDemoBrowse.Display1Click(Sender: TObject);
begin
  FDrawBox.SetEntityInViewEx(
    EzTable1.LayerName,EzTable1.SourceRecno,Extents1.Checked);
end;

procedure TfrmDemoBrowse.DataSource1DataChange(Sender: TObject; Field: TField);
begin
  if Field<>nil then Exit;
  if AutoView1.Checked then
  begin
     FDrawBox.SetEntityInViewEx(EzTable1.LayerName,EzTable1.SourceRecno,Extents1.Checked);
  end;
  UpdateStatusBar;
end;

procedure TfrmDemoBrowse.Flash1Click(Sender: TObject);
begin
  FDrawBox.BlinkEntityEx(EzTable1.LayerName,EzTable1.SourceRecno)
end;

procedure TfrmDemoBrowse.Undelete1Click(Sender: TObject);
begin
  EzTable1.Recall;
  FDrawBox.Repaint;
  DBGrid1.Refresh;
end;

procedure TfrmDemoBrowse.Edit1Click(Sender: TObject);
var xy : tpoint ;
begin
  xy := Edit1.ClientToScreen( point( 0, edit1.height ));
  EditMenu.Popup( xy.x , xy.y );
end;

procedure TfrmDemoBrowse.EzTable1BeforeInsert(DataSet: TDataSet);
begin
  Abort;
end;

procedure TfrmDemoBrowse.CboLayersChange(Sender: TObject);
begin
  EzTable1.Active:=False;
  EzTable1.Layername:= CboLayers.Text;
  SetCaption(CboLayers.Text);
  EzTable1.Active:=True;
end;

procedure TfrmDemoBrowse.AddtoSelection1Click(Sender: TObject);
begin
  with FDrawBox do
  begin
    Selection.Toggle(FLayer, EzTable1.SourceRecno);
    Selection.Add(FLayer, EzTable1.SourceRecno);
    Repaint;
  end;
end;

procedure TfrmDemoBrowse.ToggleSelection1Click(Sender: TObject);
var
  WasSelected: Boolean;
begin
  WasSelected := FDrawBox.Selection.IsSelected(FLayer, EzTable1.SourceRecno);
  FDrawBox.Selection.Clear;
  if not WasSelected then
     FDrawBox.Selection.Add(FLayer, EzTable1.SourceRecno);
  if AutoView1.Checked then
  begin
     {Show in the map only and only when one is selected}
     FDrawBox.SetEntityInViewEx(FLayer.Name, EzTable1.SourceRecno, Extents1.Checked);
  end;
  UpdateSelectionLayer;
  FDrawBox.Repaint;
end;

procedure TfrmDemoBrowse.EzTable1AfterOpen(DataSet: TDataSet);
var
  I: Integer;
begin
  for I:= 0 to EzTable1.MapFields.Count-1 do
    if EzTable1.MapFields[I].IsExpression then
    begin
      DBGrid1.Columns[I].Color:=$0080E6FF;
      DBGrid1.Columns[I].Font.Color:=clBlue;
    end;
end;

procedure TfrmDemoBrowse.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  { this leaves unchecked the menu option that shows the browser }
  fMain.Form1.actBrowse.Checked:= false;
  fMain.Form1.frmBrowse:= Nil;
  Action:= caFree;
end;

end.
