unit uMStFormLayerBrowser;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms, ComCtrls,
  Dialogs, ExtCtrls, Buttons, StdCtrls, Grids, DBGrids, DB, DBCtrls, ValEdit,
  //
  EzBaseGIS, EzTable,
  //
  uFileUtils, uGC,
  //
  uMStKernelClasses, uMStModuleApp, uMStConsts, uMStKernelSemantic;

type
  TMStLayerBrowserForm = class(TForm)
    Panel1: TPanel;
    btnDisplay: TSpeedButton;
    chbAutoDisplay: TCheckBox;
    ComboBox1: TComboBox;
    DataSource1: TDataSource;
    Panel2: TPanel;
    DBGrid1: TDBGrid;
    vleFields: TValueListEditor;
    btnClose: TSpeedButton;
    DBNavigator1: TDBNavigator;
    Splitter1: TSplitter;
    EzTable1: TEzTable;
    Panel3: TPanel;
    chbTransparency: TCheckBox;
    trackAlpha: TTrackBar;
    btnCoords: TSpeedButton;
    procedure DataSource1DataChange(Sender: TObject; Field: TField);
    procedure chbTransparencyClick(Sender: TObject);
    procedure trackAlphaChange(Sender: TObject);
    procedure btnDisplayClick(Sender: TObject);
    procedure btnCloseClick(Sender: TObject);
  private
    FLayer: TmstLayer;
    FDrawBox: TEzBaseDrawBox;
    FEzLayer: TEzBaseLayer;
    procedure SetLayer(const Value: TmstLayer);
    procedure SetDrawBox(const Value: TEzBaseDrawBox);
  strict private
    procedure LoadFields();
  public
    procedure Locate(const ObjectId: string);
    //
    property Layer: TmstLayer read FLayer write SetLayer;
    property DrawBox: TEzBaseDrawBox read FDrawBox write SetDrawBox;
  end;

var
  MStLayerBrowserForm: TMStLayerBrowserForm;

implementation

{$R *.dfm}

{ TMStLayerBrowserForm }

procedure TMStLayerBrowserForm.chbTransparencyClick(Sender: TObject);
begin
  Self.AlphaBlend := chbTransparency.Checked;
  trackAlpha.Visible := chbTransparency.Checked;
end;

procedure TMStLayerBrowserForm.DataSource1DataChange(Sender: TObject; Field: TField);
begin
  if Field <> nil then
    Exit;
  LoadFields();
  if chbAutoDisplay.Checked then
    FDrawBox.SetEntityInViewEx(EzTable1.LayerName, EzTable1.SourceRecno, True);
end;

procedure TMStLayerBrowserForm.LoadFields;
var
  ObjId, S1, S2, LayerFile: string;
  Flds: TmstObjectSemantic;
  I: Integer;
  FldVal: TmstLayerFieldValue;
  Fld: TmstLayerField;
  SemanticCaptions: TStrings;
  B: Boolean;
begin
  ObjId := EzTable1.FieldByName('OBJECT_ID').AsString;
  Flds := mstClientAppModule.MapMngr.GetSemanticFields(ObjId);
  LayerFile := TPath.Finish(mstClientAppModule.GIS.LayersSubdir, FEzLayer.Name + '.flds');
  SemanticCaptions := TFileUtils.LoadFile(LayerFile);
  SemanticCaptions.Forget();
  Flds.LoadFieldCaptions(SemanticCaptions);
  //
  while vleFields.RowCount > 2 do
    vleFields.DeleteRow(1);
  vleFields.Keys[1] := 'нет';
  vleFields.Values['нет'] := 'нет';
  //
  B := False;
  for I := 0 to Flds.FieldValues.Count - 1 do
  begin
    FldVal := Flds.FieldValues.ValueByIdx[I];
    Fld := Flds.Fields.Find(FldVal.FieldName);
    if Assigned(Fld) then
    begin
      S1 := Fld.Caption;
      S2 := FldVal.Value;
      if B then
        vleFields.InsertRow(S1, S2, True)
      else
      begin
        vleFields.Values['нет'] := S2;
        vleFields.Keys[1] := S1;
        B := True;
      end;
    end;
  end;
end;

procedure TMStLayerBrowserForm.Locate(const ObjectId: string);
var
  Rn: Integer;
  Found: Boolean;
begin
  if EzTable1.Active then
  begin
    EzTable1.DisableControls;
    try
      Rn := EzTable1.RecNo;
      EzTable1.First;
      while not EzTable1.Eof do
      begin
        Found := EzTable1.FieldByName('OBJECT_ID').AsString = ObjectId;
        if Found then
          Break;
        EzTable1.Next;
      end;
      if not Found then
        EzTable1.RecNo := Rn;
    finally
      EzTable1.EnableControls;
    end;
  end;
end;

procedure TMStLayerBrowserForm.SetDrawBox(const Value: TEzBaseDrawBox);
begin
  FDrawBox := Value;
end;

procedure TMStLayerBrowserForm.SetLayer(const Value: TmstLayer);
var
  L: TEzBaseLayer;
begin
  FLayer := Value;
  //
  L := mstClientAppModule.GIS.Layers.LayerByName(FLayer.Name);
  FEzLayer := L;
  //
  EzTable1.GIS := mstClientAppModule.GIS;
  EzTable1.Active := False;
  EzTable1.Layername := L.Name;
  EzTable1.Active := True;
  //
  ComboBox1.Items.Clear;
  ComboBox1.Items.Add(FLayer.Caption);
  ComboBox1.ItemIndex := 0;
  //
  DBGrid1.Invalidate;
end;

procedure TMStLayerBrowserForm.btnCloseClick(Sender: TObject);
begin
  EzTable1.Active := False;
  Close;
end;

procedure TMStLayerBrowserForm.btnDisplayClick(Sender: TObject);
begin
  FDrawBox.SetEntityInViewEx(EzTable1.LayerName, EzTable1.SourceRecno, True);
  FDrawBox.BlinkEntityEx(EzTable1.LayerName,EzTable1.SourceRecno)
end;

procedure TMStLayerBrowserForm.trackAlphaChange(Sender: TObject);
begin
  Self.AlphaBlendValue := trackAlpha.Position;
end;

end.
