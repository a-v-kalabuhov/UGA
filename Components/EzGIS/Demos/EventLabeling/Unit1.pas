unit Unit1;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, Buttons, EzCtrls, EzBaseGIS, ExtCtrls, EzLib, EzBase,
  EzBasicCtrls;

type
  TForm1 = class(TForm)
    Panel1: TPanel;
    EzGIS1: TEzGIS;
    DrawBox1: TEzDrawBox;
    Panel2: TPanel;
    Panel3: TPanel;
    Label1: TLabel;
    AerialView1: TEzAerialView;
    ZoomAll: TSpeedButton;
    ZoomIn: TSpeedButton;
    ZoomOut: TSpeedButton;
    PriorViewBtn: TSpeedButton;
    ChkShow: TCheckBox;
    SpeedButton1: TSpeedButton;
    SpeedButton2: TSpeedButton;
    Label2: TLabel;
    procedure ZoomAllClick(Sender: TObject);
    procedure ZoomInClick(Sender: TObject);
    procedure ZoomOutClick(Sender: TObject);
    procedure PriorViewBtnClick(Sender: TObject);
    procedure ChkShowClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure SpeedButton1Click(Sender: TObject);
    procedure DrawBox1ZoomChange(Sender: TObject; const Scale: Double);
    procedure SpeedButton2Click(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure EzGIS1BeforePaintEntity(Sender: TObject; Layer: TEzBaseLayer;
      Recno: Integer; Entity: TEzEntity; Grapher: TEzGrapher;
      Canvas: TCanvas; const Clip: TEzRect; DrawMode: TEzDrawMode;
      var CanShow: Boolean; var EntList: TEzEntityList;
      var AutoFree: Boolean);
    procedure DrawBox1MouseMove2D(Sender: TObject; Shift: TShiftState; X,
      Y: Integer; const WX, WY: Double);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.DFM}

uses EzSystem, EzGraphics;

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

procedure TForm1.ChkShowClick(Sender: TObject);
begin
  DrawBox1.repaint;
end;

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

  EzGis1.FileName:= Path + 'SampleMap.Ezm';
  EzGis1.Open;
  DrawBox1.BeginUpdate;
  AerialView1.BeginUpdate;
end;

procedure TForm1.SpeedButton1Click(Sender: TObject);
begin
  Close;
end;

procedure TForm1.DrawBox1ZoomChange(Sender: TObject;
  const Scale: Double);
begin
  if EzGis1.Layers.Count=0 then exit;
  AerialView1.Refresh;
end;

procedure TForm1.SpeedButton2Click(Sender: TObject);
begin
  ShowMessage(
'You can label entities by using the OnPaintEntity event and EntList parameter on TEzGis component.'+#13+
'This demo show labels for States_layer by showing its "NAME" database field and in blue color.'+#13+
'Also, Cities_ layers show the "NAME" field in red color.'+#13+
'Check event Gis1.OnLabelEntity on this demo.'
  )
end;

procedure TForm1.FormShow(Sender: TObject);
begin
  DrawBox1.ZoomToExtension;
  DrawBox1.EndUpdate;
  AerialView1.ZoomToExtension;
  AerialView1.EndUpdate;
end;

procedure TForm1.EzGIS1BeforePaintEntity(Sender: TObject;
  Layer: TEzBaseLayer; Recno: Integer; Entity: TEzEntity;
  Grapher: TEzGrapher; Canvas: TCanvas; const Clip: TEzRect;
  DrawMode: TEzDrawMode; var CanShow: Boolean; var EntList: TEzEntityList;
  var AutoFree: Boolean);
var
  LabelEnt: TEzEntity;
  Pt1, Pt2: TEzPoint;
  FontStyle: TEzFontStyle;
begin
  { althoug it is more efficient to disconnect the event, like this:
    Activemap1.OnLabelEntity:= nil;
    Activemap1.OnLabelEntity:= ; }
  if not chkShow.Checked then exit;

  if AnsiCompareText(Layer.Name,'states_')=0 then
  begin
    FontStyle.Name:= 'Verdana';
    FontStyle.Style:= [fsBold];
    FontStyle.Color:= clBlue;
    FontStyle.Height:= 0.35;
    { create the list of label entities (actually only one label entity is added) }

    Pt1 := Entity.FBox.Emin;
    Pt2 := Entity.FBox.Emax;
    Layer.DBTable.Recno:=Recno;
    LabelEnt := EzGraphics.CreateText( Layer.DBTable.StringGet('STATE_NAME'), // the text
                                       lpCenter,  // the position (see ezbase.TEzLabelPos enumeration)
                                       0,   // the angle (0 in this case)
                                       Pt1, // the bounding box points follows
                                       Pt2,
                                       FontStyle,  // the font style
                                       True );    // create true type text
    { a label for polygons is calculated here at the center of the polygon }
    EntList:= TEzEntityList.Create;
    EntList.Add( LabelEnt );
    AutoFree:= True;
  end else if AnsiCompareText(Layer.Name,'cities_')=0 then
  begin
    Layer.DBTable.Recno:=Recno;
    FontStyle.Name:= 'Arial';
    FontStyle.Style:= [fsBold];
    FontStyle.Color:= clRed;
    FontStyle.Height:= 0.35;

    Entity.Centroid( Pt1.X, Pt1.Y );
    Pt2 := Pt1;

    Layer.DBTable.Recno:=Recno;
    LabelEnt := EzGraphics.CreateText( Layer.DBTable.StringGet('CITY_NAME'), // the text
                                       lpCenterDown,  // the position (see ezbase.TEzLabelPos enumeration)
                                       0,   // the angle (0 in this case)
                                       Pt1, // the bounding box points follows
                                       Pt2,
                                       FontStyle,  // the font style
                                       True );    // create true type text
    { a label for polygons is calculated here at the center of the polygon }
    EntList:= TEzEntityList.Create;
    EntList.Add( LabelEnt );
    AutoFree:= True;
  end;
end;

procedure TForm1.DrawBox1MouseMove2D(Sender: TObject; Shift: TShiftState;
  X, Y: Integer; const WX, WY: Double);
begin
  label2.caption:= format('%f, &%f', [Wx,WY]);
end;

end.
