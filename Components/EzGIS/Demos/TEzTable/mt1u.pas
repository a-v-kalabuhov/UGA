unit mt1u;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ExtCtrls, StdCtrls, ComCtrls, Grids, DBGrids, Db, Buttons, EzCtrls,
  EzTable, EzBaseGIS, EzBasicCtrls;

type
  TForm1 = class(TForm)
    Gis1: TEzGis;
    Drawbox1: TEzDrawBox;
    Panel1: TPanel;
    Splitter1: TSplitter;
    EzTable1: TEzTable;
    DataSource1: TDataSource;
    Label2: TLabel;
    CboOp: TComboBox;
    ChkUse: TCheckBox;
    Edit1: TEdit;
    CboAction: TComboBox;
    Label1: TLabel;
    ZoomAll: TSpeedButton;
    ZoomIn: TSpeedButton;
    ZoomOut: TSpeedButton;
    PriorViewBtn: TSpeedButton;
    Panel2: TPanel;
    DBGrid1: TDBGrid;
    Panel3: TPanel;
    Edit2: TEdit;
    Label3: TLabel;
    Label4: TLabel;
    Panel4: TPanel;
    Button2: TButton;
    AerialView1: TEzAerialView;
    memoInfo: TMemo;
    SpeedButton1: TSpeedButton;
    Button1: TButton;
    Button3: TButton;
    procedure FormCreate(Sender: TObject);
    procedure CboActionChange(Sender: TObject);
    procedure ZoomAllClick(Sender: TObject);
    procedure ZoomInClick(Sender: TObject);
    procedure ZoomOutClick(Sender: TObject);
    procedure PriorViewBtnClick(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Drawbox1ZoomChange(Sender: TObject; const Scale: Double);
    procedure SpeedButton1Click(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.DFM}

uses
  Ezsystem, ezbase, ezlib, Ezentities;

procedure TForm1.FormCreate(Sender: TObject);
var
  Path: string;
begin
  Path:= AddSlash(ExtractFilePath(ExpandFilename('..\..\data\txt.fnt')));
  if not FileExists(Path+'txt.fnt') then
  begin
    ShowMessage('No font files found !');
  end;
  Ez_VectorFonts.AddFontFile(Path+'complex.fnt');
  Ez_VectorFonts.AddFontFile(Path+'txt.fnt');
  //Ez_VectorFonts.AddFontFile(Path+'romanc.fnt');
  //Ez_VectorFonts.AddFontFile(Path+'arial.fnt');

  { ALWAYS load the symbols after the vectorial fonts
    because the symbols can include vectorial fonts entities and
    if the vector font is not found, then the entity will be configured
    with another font }
  if FileExists(Path + 'symbols.ezs') then
  begin
    Ez_Symbols.FileName:= Path + 'symbols.ezs';
    Ez_Symbols.Open;
  end;

  // load line types
  if FileExists(Path + 'Linetypes.ezl') then
  begin
    Ez_LineTypes.FileName:=Path + 'Linetypes.ezl';
    Ez_LineTypes.Open;
  end;

  Ez_Preferences.CommonSubDir:= Path;

  Gis1.FileName:= Path + 'SampleMap.Ezm';
  Gis1.Open;
  Gis1.Save;
  DrawBox1.ZoomToExtension;
  Aerialview1.ZoomToExtension;

  cboOp.ItemIndex:= 1;
  Ez_preferences.selectionpen.Width:=-2;
end;

procedure TForm1.CboActionChange(Sender: TObject);
var
  e,e1,e2,e3,tmp: TEzEntity;
  p1,p2: TEzPoint;
  s: string;
  L: TIntegerList;
  I: Integer;
begin
  with cboAction do
  begin
    if ItemIndex < 0 then exit;
    DrawBox1.TempEntities.clear;
    DrawBox1.Selection.clear;
    if chkUse.Checked then
    begin
      if ItemIndex=3 then
        s:= Edit2.Text
      else
        s:= Edit1.Text;
    end
    else
      s:='';
    { create the list of the found entities }
    L:= TIntegerList.Create;
    case ItemIndex of
      0:  // rectangle selection
        begin
        p1:=Point2D(-128.612, 57.796);
        p2:=Point2D(-96.400, 20.498);
        e:= TEzRectangle.CreateEntity(p1, p2);
        TEzRectangle(e).Pentool.assign(Ez_Preferences.DefPenStyle);
        DrawBox1.TempEntities.add(e);
        DrawBox1.RectangleSelect(p1.x, p1.y, p2.x, p2.y, 'states_',
          s, TEzGraphicOperator(cboOp.ItemIndex));

        { now found the record numbers of the entities }
        Gis1.QueryRectangle(p1.x,p1.y,p2.x,p2.y,'states_',s,
          TEzGraphicOperator(cboOp.ItemIndex),0,l,true);

        { here, the TMapTable in action }
        EzTable1.Close;
        EzTable1.LayerName:= 'states_';
        EzTable1.RectangleFilter(p1.x,p1.y,p2.x,p2.y, TEzGraphicOperator(cboOp.ItemIndex), s,true);
        EzTable1.Open;

        memoInfo.Lines.Clear;
        memoInfo.Lines.Add('This option will select all entities in "states" layer that area partial'+
                           ' or fully inside the marked rectangle (depending on Operator parameter)');
        end;
      1: // multi-polygon selection
        begin
        { first polygonal area }
        e1:= TEzPolygon.CreateEntity([
           Point2D(-138.28, 72.72),
           Point2D(-150.65, 74.24),
           Point2D(-155.40, 63.56),
           Point2D(-159.64, 47.12),
           Point2D(-150.14, 26.60),
           Point2D(-121.15, 12.19),
           Point2D(-103.52, 14.39),
           Point2D(-91.14, 14.73),
           Point2D(-85.55, 22.02),
           Point2D(-86.91, 28.13),
           Point2D(-85.21, 36.43),
           Point2D(-87.58, 44.57),
           Point2D(-91.99, 55.93),
           Point2D(-99.79, 52.03),
           Point2D(-122.00, 52.20),
           Point2D(-121.66, 60.68),
           Point2D(-138.28, 72.72)
        ]);


        TEzPolygon(e1).Pentool.assign(Ez_Preferences.DefPenStyle);
        DrawBox1.TempEntities.add(e1);
        DrawBox1.PolygonSelect(e1, 'states_', s, TEzGraphicOperator(cboOp.ItemIndex));

        { second polygonal area }
        e2:= TEzPolygon.CreateEntity([
           Point2D(-87.08, 55.93),
           Point2D(-93.18, 51.18),
           Point2D(-94.37, 44.74),
           Point2D(-94.37, 36.60),
           Point2D(-94.54, 32.20),
           Point2D(-94.03, 27.28),
           Point2D(-84.87, 22.36),
           Point2D(-73.68, 19.99),
           Point2D(-66.39, 25.08),
           Point2D(-72.83, 29.48),
           Point2D(-69.61, 33.55),
           Point2D(-70.29, 37.11),
           Point2D(-67.92, 40.50),
           Point2D(-65.88, 42.88),
           Point2D(-64.70, 49.83),
           Point2D(-68.77, 50.34),
           Point2D(-75.72, 48.30),
           Point2D(-87.08, 55.93)
        ]);


        TEzPolygon(e2).Pentool.assign(Ez_Preferences.DefPenStyle);
        DrawBox1.TempEntities.add(e2);
        DrawBox1.PolygonSelect(e2, 'states_', s, TEzGraphicOperator(cboOp.ItemIndex));


        { third polygonal area }
        e3:= TEzPolygon.CreateEntity([
           Point2D(-176.25, 33.04),
           Point2D(-165.23, 37.62),
           Point2D(-157.43, 38.81),
           Point2D(-154.72, 52.20),
           Point2D(-153.36, 67.29),
           Point2D(-161.16, 75.77),
           Point2D(-172.18, 75.26),
           Point2D(-179.13, 67.12),
           Point2D(-179.13, 55.76),
           Point2D(-176.25, 33.04)
        ]);

        TEzPolygon(e3).Pentool.assign( Ez_Preferences.DefPenStyle);
        DrawBox1.TempEntities.add(e3);
        DrawBox1.PolygonSelect(e3, 'states_', s, TEzGraphicOperator(cboOp.ItemIndex));

        { found the entities }
        Gis1.QueryPolygon(e1,'states_',s, TEzGraphicOperator(cboOp.ItemIndex),0,L,true);
        { check the last parameter on this method call }
        Gis1.QueryPolygon(e2,'states_',s, TEzGraphicOperator(cboOp.ItemIndex),0,L,false);
        { and also in this one}
        Gis1.QueryPolygon(e3,'states_',s, TEzGraphicOperator(cboOp.ItemIndex),0,L,false);

        { here, the TMapTable in action }
        EzTable1.Close;
        EzTable1.LayerName:= 'states_';
        EzTable1.PolygonFilter(e1,TEzGraphicOperator(cboOp.ItemIndex),s,true);
        { check the last parameter on this method call }
        EzTable1.PolygonFilter(e2,TEzGraphicOperator(cboOp.ItemIndex),s,false);
        { and also in this one}
        EzTable1.PolygonFilter(e3,TEzGraphicOperator(cboOp.ItemIndex),s,false);
        EzTable1.Open;

        memoInfo.Lines.Clear;
        memoInfo.Lines.Add('This option will select all entities in "states" layer that area partial'+
                           ' or fully inside the marked polygon (depending on Operator parameter)');
        end;
      2:
        begin
        tmp:= TEzPolyline.CreateEntity([
          Point2D(-162.35, 72.55),
          Point2D(-148.62, 53.22),
          Point2D(-98.10, 33.89),
          Point2D(-72.16, 31.01)
        ]);

        e:= Gis1.CreateBufferEntity(tmp, 20, 2.83);

        TEzPolyline(e).Pentool.assign( Ez_Preferences.DefPenStyle);
        DrawBox1.TempEntities.add(e);
        DrawBox1.BufferSelect(tmp, 'states_', s, TEzGraphicOperator(cboOp.ItemIndex), 20, 2.83);

        { found the entities }
        Gis1.QueryBuffer(tmp, 'states_', s,
          TEzGraphicOperator(cboOp.ItemIndex), 0, 20, 2.83, L,true);

        { here, the TMapTable in action }
        EzTable1.Close;
        EzTable1.LayerName:= 'states_';
        EzTable1.BufferFilter(tmp, TEzGraphicOperator(cboOp.ItemIndex), s, 20, 2.83,true);
        EzTable1.Open;

        tmp.free;
        memoInfo.Lines.Clear;
        memoInfo.Lines.Add('This option will select all entities in "states" layer that area partial'+
                           ' or fully inside the marked buffer (depending on Operator parameter)');
        end;
      3:
        begin
        e:= TEzPolyline.CreateEntity([
          Point2D(-143.19, 23.55),
          Point2D(-131.83, 30.50),
          Point2D(-112.68, 23.55),
          Point2D(-107.08, 33.38),
          Point2D(-96.23, 35.25),
          Point2D(-91.99, 40.84),
          Point2D(-87.41, 41.01),
          Point2D(-89.11, 47.28),
          Point2D(-83.85, 53.90)
        ]);

        TEzPolyline(e).Pentool.assign(Ez_Preferences.DefPenStyle);
        DrawBox1.TempEntities.add(e);
        DrawBox1.PolylineSelect(e, 'roads_', s);

        { found the entities }
        Gis1.QueryPolyline(e,'roads_', s, 0, l,true);

        { here, the TMapTable in action }
        EzTable1.Close;
        EzTable1.LayerName:= 'roads_';
        EzTable1.PolylineIntersects(e, s,true);
        EzTable1.Open;

        memoInfo.Lines.Clear;
        memoInfo.Lines.Add('This option will select all roads that intersects to the showed polyline');
        end;
    end;
    memoInfo.Lines.Add('The entities found are the following (record numbers):');
    for I:= 0 to l.count-1 do
      memoInfo.Lines.Add(IntToStr(Integer(l[I])));
    l.free;

    DrawBox1.Repaint;
  end;
end;

procedure TForm1.ZoomAllClick(Sender: TObject);
begin
  DrawBox1.ZoomToExtension;
end;

procedure TForm1.ZoomInClick(Sender: TObject);
begin
  DrawBox1.ZoomIn(85);

end;

procedure TForm1.ZoomOutClick(Sender: TObject);
begin
  DrawBox1.ZoomOut(85);

end;

procedure TForm1.PriorViewBtnClick(Sender: TObject);
begin
  DrawBox1.ZoomPrevious;

end;

procedure TForm1.Button2Click(Sender: TObject);
begin
  EzTable1.DoSelect(DrawBox1.Selection);
end;

procedure TForm1.Drawbox1ZoomChange(Sender: TObject; const Scale: Double);
begin
  AerialView1.Refresh;
end;

procedure TForm1.SpeedButton1Click(Sender: TObject);
begin
  close;
end;

procedure TForm1.Button1Click(Sender: TObject);
begin
  DrawBox1.Selection.Clear;
  DrawBox1.Repaint;
end;

procedure TForm1.Button3Click(Sender: TObject);
var
  TheFilter: string;
begin
  EzTable1.Close;
  EzTable1.LayerName:= 'CITIES_';
  TheFilter :=
    'CITIES_.ENT ENTIRELY WITHIN STATES_.ENT SCOPE (STATES_.STATE_NAME IN ("Oklahoma", "Washington"))';
  Screen.Cursor:= crHourglass;
  try
    EzTable1.ScopeFilter( TheFilter, True );
  finally
    Screen.Cursor:= crDefault;
  end;
  EzTable1.Open;
end;

end.
