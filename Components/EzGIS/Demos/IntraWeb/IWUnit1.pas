unit IWUnit1;
{PUBDIST}

{$DEFINE USE_INTRAWEB5}

interface

uses
  IWAppForm, IWApplication, IWTypes, DB, DBClient, Classes, Controls,
  IWControl, IWCompLabel, IWCSStdCtrls, IWExtCtrls, IWCompMap, EzBaseGIS,
  EzCtrls, EzBasicCtrls, IWGrids, Graphics, IWHTMLTag, IWCompCheckbox,
  IWCompButton, IWCompMemo, Windows, IWCompEdit, StdCtrls, IWCompListbox,
  IWBaseControl;

type
  TformMain = class(TIWAppForm)
    DrawBox: TEzDrawBox;
    Gis1: TEzGIS;
    Map: TEzIWMap;
    Grid: TIWGrid;
    btnZoomIn: TIWButton;
    btnZoomOut: TIWButton;
    btnPick: TIWButton;
    btnZoomAll: TIWButton;
    Memo: TIWMemo;
    btnZoomWin: TIWButton;
    btnPan: TIWButton;
    btnSelect: TIWButton;
    btnClear: TIWButton;
    btnRemove: TIWButton;
    btnAdd: TIWButton;
    btnCircleSelect: TIWButton;
    IWLabel1: TIWLabel;
    cboOperator: TIWComboBox;
    IWEdit1: TIWEdit;
    EzScaleBar1: TEzScaleBar;
    EzIWScaleBar1: TEzIWScaleBar;
    procedure IWAppFormCreate(Sender: TObject);
    procedure ImageOnClick(Sender: TObject);
    procedure GridRenderCell(ACell: TIWGridCell; const ARow,
      AColumn: Integer);
    procedure MapEntityClick(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer; const WX, WY: Double;
      Layer: TEzBaseLayer; RecNo: Integer; var Processed: Boolean);
    procedure btnClearClick(Sender: TObject);
    procedure btnRemoveClick(Sender: TObject);
    procedure btnZoomInClick(Sender: TObject);
    procedure btnZoomOutClick(Sender: TObject);
    procedure btnPickClick(Sender: TObject);
    procedure btnZoomAllClick(Sender: TObject);
    procedure btnAddClick(Sender: TObject);
    procedure cboOperatorChange(Sender: TObject);
    procedure GridCellClick(const ARow, AColumn: Integer);
  public
  end;

Var
  formMain: TformMain;

implementation
{$R *.dfm}

uses
  ServerController, EzSystem, SysUtils, Dialogs, EzLib, EzProjections, EzBase;


Type
{ This class will be used to display the imagethat indicates if a layer is visible or not
  a TEzBaseGIS must be assigned and a layer name, in order to automatic detection
  of the property Layer.LayerInfo.Visibiel and when you click on it the image will change state }
  TEzIWImageControl = Class( TIWDynamicImage )
  Private
    FGis : TEzBaseGIS;
    FLayerName : String;
  Protected
    procedure MyMouseDown(ASender: TObject; const AX: Integer; const AY: Integer);
  Public
    constructor Create(AOwner : TComponent); Override;
    function RenderHTML: TIWHTMLTag; override;
    Property Gis : TEzBaseGIS Read FGis Write FGis;
    Property LayerName : String Read FLayerName Write FLayerName;
  End;

{ this class inherited from TIWCheckBox and will be used to access to the selectable property
  of a layer, thereof you must assign a TEzBaseHGIS and a layer name}
  TEzIWCheckBox = Class( TIWCheckBox )
  Private
    FGis : TEzBaseGIS;
    FLayerName : String;
  Protected
    Procedure MyClick(Sender : TObject);
  Public
    Constructor Create(AOwner : TComponent); Override;
    function RenderHTML: TIWHTMLTag; override;
    Property Gis : TEzBaseGIS Read FGis Write FGis;
    Property LayerName : String Read FLayerName Write FLayerName;
  End;


{ Images used to represent the visible property for every layer }
Var
  ImgOn : Graphics.TBitMap;
  ImgOff : Graphics.TBitMap;

procedure TformMain.IWAppFormCreate(Sender: TObject);
var
  Path : String;
  i : Integer;
  Ctrl : TEzIWImageControl;
  Check : TEzIWCheckBox;
  Layer : TEzBaseLayer;
begin

  Path := 'C:\EzGIS1\Demos\Data\';

  Ez_Preferences.CommonSubdir:= Path;

  {Cargar las imagenes del archivo de recursos}
  imgOn := Graphics.TBitMap.Create;
  ImgOn.Handle := Windows.LoadBitMap(HInstance, 'VISIBLE');
  imgOn.Transparent := True;
  imgOn.TransparentMode := tmAuto;

  imgOff := Graphics.TBitMap.Create;
  ImgOff.Handle := LoadBitMap(HInstance, 'INVISIBLE');
  imgOff.Transparent := True;
  imgOff.TransparentMode := tmAuto;


  If Not FileExists(Path + 'txt.fnt') Then
    ShowMessage('Font files not found');

  EzSystem.Ez_VectorFonts.AddFontFile(Path + 'Txt.fnt');
  EzSystem.Ez_VectorFonts.AddFontFile(Path + 'Complex.fnt');

  If FileExists(Path + 'Symbols.Ezs') Then
    EzSystem.Ez_Symbols.LoadFromFile(Path + 'Symbol.Ezs');

  Gis1.FileName := Path + 'SampleMap.Ezm';
  Gis1.Open;

  DrawBox.ZoomToExtension;

  {Utilizaremos el Grid para desplegar la informacion de las capas del mapa.}
  {determinamos que el numero de columnas deben de ser tres.}
  {Selectable, Visible, LayerName}
  Grid.ColumnCount := 3;

  Grid.Cell[0, 0].Text := 'Selectable';
  Grid.Cell[0, 1].Text := 'Visible';
  Grid.Cell[0, 2].Text := 'Layer Name';

  {El numero de renglones debe de ser igual al numero de capas en el TEzGIS + 1}
  Grid.RowCount := Gis1.Layers.Count + 1;

  {Ahora crearemos dinamicamente los controles para desplegarlos en el grid.}
  For i := 1 To Gis1.Layers.Count Do
  Begin
    Layer := Gis1.Layers[i - 1];

    {Creamos una instancia de un TEzIWCheckBox y le asignamos la capa actual.}
    Check := TEzIWCheckBox.Create(Self);
    Check.Gis := Gis1;
    Check.LayerName := Layer.Name;
    {Tomando en cuenta el valor de la Selectable, asignamos la leyenda al TEzIWCheckBox}
    If Layer.LayerInfo.Selectable Then
      Check.Text := 'Selectable'
    Else
      Check.Text := 'Unselectable';
    {Cargamos el control a la celda[renglon_actual, primera_columna]}
    Grid.Cell[i, 0].Control := Check;

    {Creamos un TEzIWImageControl y le asiganmos el nombre de la capa actual.}
    Ctrl := TEzIWImageControl.Create(Self);
    Ctrl.Gis := Gis1;
    Ctrl.LayerName := Layer.Name;
    Ctrl.Align := alNone;
    {Y se lo asignamos a la segunda celda del grid en el renglon actual.}
    Grid.Cell[i, 1].Control := Ctrl;

    {En la tercera celda del grid mostramos el nombre de la capa.}
    Grid.Cell[i, 2].Text := Layer.Name;
    {Y le asignamos la propiedad Clickable a true.}
    Grid.Cell[i, 2].Clickable := True;
  End;

end;

procedure TformMain.ImageOnClick(Sender: TObject);
begin
end;



{ TEzIWImageControl }

constructor TEzIWImageControl.Create(AOwner: TComponent);
begin
  inherited;
  FLayerName := '';
  OnMouseDown := MyMouseDown;
end;

procedure TEzIWImageControl.MyMouseDown(ASender: TObject; const AX,
  AY: Integer);
var
  Layer : TEzBaseLayer;
begin
  If Not Assigned(FGis) Or (FLayerName = '') Then Exit;
  Layer := FGis.Layers.LayerByName(FLayerName);
  If Layer <> Nil Then
    Layer.LayerInfo.Visible := Not Layer.LayerInfo.Visible;
  FGis.RepaintViewports;
end;

function TEzIWImageControl.RenderHTML: TIWHTMLTag;
//{$IFDEF USE_INTRAWEB4} string {$ENDIF}
//{$IFDEF USE_INTRAWEB5} TIWHTMLTag {$ENDIF};
Var
  Layer : TEzBaseLayer;
begin
  If Assigned(FGis) And (FLayername <> '') Then Begin
    Layer := FGis.Layers.LayerByName(LayerName);
    If Layer <> Nil Then
      If Layer.LayerInfo.Visible Then
        FPicture.Bitmap.Assign(ImgOn)
        //Handle := ImgOn.Handle
      Else
        FPicture.Bitmap.Assign(ImgOff);
  End;
  Result := Inherited RenderHTML;
end;

{ TEzIWCheckBox }

constructor TEzIWCheckBox.Create(AOwner: TComponent);
begin
  inherited;
  FLayerName := '';
  OnClick := MyClick;
end;

procedure TEzIWCheckBox.MyClick(Sender: TObject);
var
  Layer : TEzBaseLayer;
begin
  If Not Assigned(FGis) Or (FLayerName = '') Then Exit;
  Layer := FGis.Layers.LayerByName(FLayerName);
  Layer.LayerInfo.Selectable := Not Layer.LayerInfo.Selectable;
  If Layer.LayerInfo.Selectable Then Begin
    Text := 'Selectable';
    Checked := True;
  End Else Begin
    Text := 'Unselectable';
    Checked := False;
  End;
end;

function TEzIWCheckBox.RenderHTML: TIWHTMLTag;
Var
  Layer : TEzBaseLayer;
begin
  If Assigned(FGis) And (FLayerName <> '') Then Begin
    Layer := FGis.Layers.LayerByName(FLayerName);
    If Layer <> Nil Then
      Checked := Layer.LayerInfo.Selectable;
  End;
  Result := Inherited RenderHTML;
end;


procedure TformMain.GridRenderCell(ACell: TIWGridCell; const ARow,
  AColumn: Integer);
begin
  if (ARow > 0) And (Gis1.CurrentLayerName = Gis1.Layers[ARow - 1].Name) Then
    ACell.BGColor := clYellow
  else
    ACell.BGColor := clWindow;
  If ARow = 0 Then Begin
    ACell.BGColor := clGray;
    ACell.Font.Style := [fsBold, fsUnderLine];
    ACell.Font.Size := 12;
  End;
end;

procedure TformMain.MapEntityClick(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer; const WX, WY: Double;
  Layer: TEzBaseLayer; RecNo: Integer; var Processed: Boolean);
Var
  i : Integer;
begin
  If Layer = Nil Then Exit;
  Memo.Lines.Clear;
  Memo.Lines.Add('Layer : ' + Layer.Name);
  With Layer.LoadEntityWithRecNo(RecNo) Do
  Try
    Memo.Lines.Add('EntityType: ' + ClassName)
  Finally
    Free
  End;
  Memo.Lines.Add('Recno: ' + IntToStr(RecNo));
  Memo.Lines.Add('<<-- Database info -->> ');
  Layer.DBTable.RecNo := RecNo;
  For i := 1 To Layer.DBTable.FieldCount Do Begin
    Memo.Lines.Add(Layer.DBTable.Field(i) + ': ' + Layer.DBTable.StringGetN(i));
  End;
end;

procedure TformMain.btnClearClick(Sender: TObject);
begin
  DrawBox.Selection.Clear;
  DrawBox.Repaint;
end;

procedure TformMain.btnRemoveClick(Sender: TObject);
begin
  Map.RemoveScriptFrom(Self);
  btnZoomIn.ScriptEvents.Values['OnClick'] := '';
  btnZoomOut.ScriptEvents.Values['OnClick'] := '';
  btnZoomAll.ScriptEvents.Values['OnClick'] := '';
  btnPan.ScriptEvents.Values['OnClick'] := '';
  btnZoomWin.ScriptEvents.Values['OnClick'] := '';
  btnSelect.ScriptEvents.Values['OnClick'] := '';
  btnCircleSelect.ScriptEvents.Values['OnClick'] := '';
  btnPick.ScriptEvents.Values['OnClick'] := '';
  btnAdd.Enabled := True;
  btnRemove.Enabled := False;
  btnPan.Enabled := False;
  btnZoomWin.Enabled := False;
  btnSelect.Enabled := False;
  btnCircleSelect.Enabled := False;
end;

procedure TformMain.btnZoomInClick(Sender: TObject);
begin
  //This method will be fired only when no script is defined
  Map.CurrentAction := caZoomIn;
end;

procedure TformMain.btnZoomOutClick(Sender: TObject);
begin
  //Este metodo solo se disparara cuando no se este usando el script
  Map.CurrentAction := caZoomOut;
end;

procedure TformMain.btnPickClick(Sender: TObject);
begin
  //Este metodo solo se disparara cuando no se este usando el script
  Map.CurrentAction := caPickEntity;
end;

procedure TformMain.btnZoomAllClick(Sender: TObject);
begin
  //Este metodo solo se disparara cuando no se este usando el script
  DrawBox.ZoomToExtension;
end;

procedure TformMain.btnAddClick(Sender: TObject);
begin
  //importante al agregar los eventos al script:
  //Cuidar el uso de mayusculas y minusculas, ya que el script es sensitivo,
  //Agregar solo la llamada a la funcion, "no colocar ; al final de esta"
  //El nombre del metodo SetAction comienza con el nombre del TEzIWMap, se
  //puede obtener con mas confianza del Map.Name
  Map.AddScript(Self);
  btnZoomIn.ScriptEvents.Values['OnClick']  := 'MapSetAction("caZoomIn")';
  btnZoomOut.ScriptEvents.Values['OnClick'] := 'MapSetAction("caZoomOut")';
  btnZoomAll.ScriptEvents.Values['OnClick'] := 'MapSetAction("caZoomExtension")';
  btnZoomWin.ScriptEvents.Values['OnClick'] := 'MapSetAction("caZoomWin")';
  btnPan.ScriptEvents.Values['OnClick']     := 'MapSetAction("caPan")';
  btnSelect.ScriptEvents.Values['OnClick']  := 'MapSetAction("caSelect")';
  btnCircleSelect.ScriptEvents.Values['OnClick']  := 'MapSetAction("caCircleSelect")';
  btnPick.ScriptEvents.Values['OnClick']    := 'MapSetAction("caPickEntity")';
  btnAdd.Enabled := False;
  btnRemove.Enabled := True;
  btnPan.Enabled := True;
  btnZoomWin.Enabled := True;
  btnSelect.Enabled := True;
  btnCircleSelect.Enabled := True;
end;

procedure TformMain.cboOperatorChange(Sender: TObject);
begin
  Map.GraphicOperator := TEzGraphicOperator(cboOperator.ItemIndex);
end;

procedure TformMain.GridCellClick(const ARow, AColumn: Integer);
begin
  If ARow > 0 Then
    Gis1.CurrentLayerName := Gis1.Layers[ARow - 1].Name;
end;

end.

