unit fPref;

interface
                                   
uses Windows, SysUtils, Classes, Graphics, Forms, Controls, StdCtrls, 
  Buttons, ExtCtrls, Grids, EzInspect, ezbase;

type
  TfrmPreferences = class(TForm)
    Inspector1: TEzInspector;
    Panel1: TPanel;
    Button1: TButton;
    Button2: TButton;
    BtnExpand: TSpeedButton;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure Button1Click(Sender: TObject);
    procedure BtnExpandClick(Sender: TObject);
  private
    { Private declarations }
    FPref: TEzModifyPreferences;
  public
    { Public declarations }
    procedure Enter(Pref: TEzModifyPreferences);
  end;

implementation

{$R *.DFM}

uses
  ezsystem;

{ TfrmPreferences }

procedure TfrmPreferences.Enter(Pref: TEzModifyPreferences);
var
  bp: TEzBaseProperty;
  ColsString: TStrings;
  tv: TEzTreeViewProperty;
begin
  ColsString:= TStringList.Create;
  try
    RestoreFormPlacement(ExtractFilePath(Application.ExeName) + 'formspos.ini',
      Self, true, ColsString);
    if ColsString.Count = 2 then
    begin
      Inspector1.ColWidths[0]:= StrToInt(ColsString.Values['Col0']);
      Inspector1.ColWidths[1]:= StrToInt(ColsString.Values['Col1']);
    end;
  finally
    ColsString.free;
  end;

  FPref:= Pref;

  tv:= TEzTreeViewProperty.Create('General');
  Inspector1.AddProperty( tv );
  tv.Modified:=true;    { causes to show on bold}

  { fill with properties }

  bp:= TEzBooleanProperty.Create('ShowText');
  bp.ValBoolean:= Pref.ShowText;
  //bp.IndentLevel:= 1;
  bp.Hint:='Toggle if text is shown on drawing';
  tv.AddProperty( bp );


  bp:= TEzIntegerProperty.Create('ControlPointsWidth');
  bp.ValInteger:= Pref.ControlPointsWidth;
  //bp.IndentLevel:= 1;
  bp.Hint:='Define the size of control points in pixels';
  tv.AddProperty( bp );


  bp:= TEzIntegerProperty.Create('ApertureWidth');
  bp.ValInteger:= Pref.ApertureWidth;
  //bp.IndentLevel:= 1;
  bp.Hint:='Define the distance in pixels for considering entities touched';
  tv.AddProperty( bp );

  bp:= TEzIntegerProperty.Create('MinimumDrawLimit');
  bp.ValInteger:= Pref.MinDrawLimit;
  //bp.IndentLevel:= 1;
  bp.Hint:='Entities are not painted if smaller than this size (pixels)';
  tv.AddProperty( bp );

  bp:= TEzIntegerProperty.Create('AerialMinimumDrawLimit');
  bp.ValInteger:= Pref.AerialMinDrawLimit;
  //bp.IndentLevel:= 1;
  bp.Hint:='Entities are not painted if smaller than this size (pixels)';
  tv.AddProperty( bp );

  bp:= TEzIntegerProperty.Create('PointEntitySize');
  bp.ValInteger:= Pref.PointEntitySize;
  //bp.IndentLevel:= 1;
  bp.Hint:='Define the size for point entities in pixels';
  tv.AddProperty( bp );

  bp:= TEzFloatProperty.Create('DirectionArrowSize');
  bp.ValFloat:= Pref.DirectionArrowSize;
  //bp.IndentLevel:= 1;
  bp.Hint:='Define the size for the arrow when showing direction (Points)';
  tv.AddProperty( bp );

  bp:= TEzBooleanProperty.Create('UsePreloadedBlocks');
  bp.ValBoolean:= Pref.UsePreloadedBlocks;
  //bp.IndentLevel:= 1;
  bp.Hint:='Toggle the use of preloaded blocks';
  tv.AddProperty( bp );

  bp:= TEzBooleanProperty.Create('UsePreloadedImages');
  bp.ValBoolean:= Pref.UsePreloadedImages;
  //bp.IndentLevel:= 1;
  bp.Hint:='Toggle the use of preloaded images';
  tv.AddProperty( bp );

  bp:= TEzBooleanProperty.Create('UsePreloadedBandedImages');
  bp.ValBoolean:= Pref.UsePreloadedBandedImages;
  //bp.IndentLevel:= 1;
  bp.Hint:='Toggle the use of preloaded banded images';
  tv.AddProperty( bp );

  bp:= TEzBooleanProperty.Create('PatternPlotterOptimized');
  bp.ValBoolean:= Pref.PatternPlotterOptimized;
  //bp.IndentLevel:= 1;
  bp.Hint:='Define if fill pattern are printed like pixels not bitmaps';
  tv.AddProperty( bp );

  bp:= TEzBooleanProperty.Create('PolylineGen');
  bp.ValBoolean:= Pref.PlineGen;
  //bp.IndentLevel:= 1;
  bp.Hint:='Define if custom line style are continuos';
  tv.AddProperty( bp );

  bp:= TEzIntegerProperty.Create('SplineSegs');
  bp.ValInteger:= Pref.SplineSegs;
  //bp.IndentLevel:= 1;
  bp.Hint:='Define no. of points for generating splines';
  tv.AddProperty( bp );

  bp:= TEzIntegerProperty.Create('EllipseSegs');
  bp.ValInteger:= Pref.EllipseSegs;
  //bp.IndentLevel:= 1;
  bp.Hint:='Define no. of points for generating ellipses/circles';
  tv.AddProperty( bp );

  bp:= TEzIntegerProperty.Create('ArcSegs');
  bp.ValInteger:= Pref.ArcSegs;
  //bp.IndentLevel:= 1;
  bp.Hint:='Define no. of points for generating arcs';
  tv.AddProperty( bp );

  bp:= TEzSelectFolderProperty.Create('CommonSubDir');
  bp.ValString:= Pref.CommonSubDir;
  //bp.IndentLevel:= 1;
  bp.Hint:='Define subdirectory for images/blocks';
  tv.AddProperty( bp );

  bp:= TEzIntegerProperty.Create('BandsBitmapChunkSize');
  bp.ValInteger:= Pref.BandsBitmapChunkSize;
  //bp.IndentLevel:= 1;
  bp.Hint:='Define size of buffer for banded bitmaps';
  tv.AddProperty( bp );



  tv:= TEzTreeViewProperty.Create('Default Pen');
  Inspector1.AddProperty( tv );
  tv.Modified:=true;    { causes to show on bold}

  bp:= TEzLinetypeProperty.Create('DefaultPen.Style');
  bp.ValInteger:= Pref.DefPenStyle.Style;
  //bp.IndentLevel:= 1;
  bp.Hint:='Define style of line for new entities';
  tv.AddProperty( bp );

  bp:= TEzColorProperty.Create('DefaultPen.PenColor');
  bp.ValInteger:= Pref.DefPenStyle.Color;
  //bp.IndentLevel:= 1;
  bp.Hint:='Define color of line for new entities';
  tv.AddProperty( bp );

  bp:= TEzFloatProperty.Create('DefaultPen.PenWidth(Scale)');
  bp.ValFloat:= Pref.DefPenStyle.Scale;
  //bp.IndentLevel:= 1;
  bp.Hint:='Define width/scale of line for new entities';
  tv.AddProperty( bp );


  tv:= TEzTreeViewProperty.Create('Default Brush');
  Inspector1.AddProperty( tv );
  tv.Modified:=true;    { causes to show on bold}

  bp:= TEzBrushstyleProperty.Create('DefaultBrush.Pattern');
  bp.ValInteger:= Pref.DefBrushStyle.Pattern;
  //bp.IndentLevel:= 1;
  bp.Hint:='Define pattern for new entities';
  tv.AddProperty( bp );

  bp:= TEzColorProperty.Create('DefaultBrush.ForeColor');
  bp.ValInteger:= Pref.DefBrushStyle.ForeColor;
  //bp.IndentLevel:= 1;
  bp.Hint:='Define brush fore color for new entities';
  tv.AddProperty( bp );

  bp:= TEzColorProperty.Create('DefaultBrush.BackColor');
  bp.ValInteger:= Pref.DefBrushStyle.BackColor;
  //bp.IndentLevel:= 1;
  bp.Hint:='Define brush back color for new entities';
  tv.AddProperty( bp );



  { symbol style }
  tv:= TEzTreeViewProperty.Create('Default Symbol');
  Inspector1.AddProperty( tv );
  tv.Modified:=true;    { causes to show on bold}

  bp:= TEzSymbolProperty.Create('DefaultSymbol.Index');
  bp.ValInteger:= Pref.DefSymbolStyle.Index;
  //bp.IndentLevel:= 1;
  bp.Hint:='Define symbol to use for new entities';
  tv.AddProperty( bp );

  bp:= TEzAngleProperty.Create('DefaultSymbol.Rotangle');
  bp.ValFloat:= Pref.DefSymbolStyle.Rotangle;
  //bp.IndentLevel:= 1;
  bp.Hint:='Define rotation angle for new entities';
  tv.AddProperty( bp );

  bp:= TEzFloatProperty.Create('DefaultSymbol.Height');
  bp.ValFloat:= Pref.DefSymbolStyle.Height;
  //bp.IndentLevel:= 1;
  bp.Hint:='Define height of symbols for new entities';
  tv.AddProperty( bp );


  { default TT font style }
  tv:= TEzTreeViewProperty.Create('Default TrueType font');
  Inspector1.AddProperty( tv );
  tv.Modified:=true;    { causes to show on bold}

  bp:= TEzFontNameProperty.Create('DefaultTTFont.Name');
  TEzFontNameProperty(bp).TrueType:= true;
  bp.ValString:= Pref.DefTTFontStyle.Name;
  //bp.IndentLevel:= 1;
  bp.Hint:='Define windows true type font name';
  tv.AddProperty( bp );

  bp:= TEzFloatProperty.Create('DefaultTTFont.Height');
  bp.ValFloat:= Pref.DefTTFontStyle.Height;
  //bp.IndentLevel:= 1;
  bp.Hint:='Define height of text';
  tv.AddProperty( bp );

  bp:= TEzColorProperty.Create('DefaultTTFont.Color');
  bp.ValInteger:= Pref.DefTTFontStyle.Color;
  //bp.IndentLevel:= 1;
  bp.Hint:='Define color of text for new entities';
  tv.AddProperty( bp );

  bp:= TEzSetProperty.Create('DefaultTTFont.Style');
  bp.Hint:= 'Define font style';
  with TEzSetProperty(bp) do
  begin
    Strings.BeginUpdate;
    Strings.Add('Bold');
    Strings.Add('Italic');
    Strings.Add('Underline');
    Strings.Add('StrikeOut');
    Strings.EndUpdate;

    Defined[0] := fsBold in Pref.DefTTFontStyle.Style;
    Defined[1] := fsItalic in Pref.DefTTFontStyle.Style;
    Defined[2] := fsUnderline in Pref.DefTTFontStyle.Style;
    Defined[3] := fsStrikeout in Pref.DefTTFontStyle.Style;

  end;
  //bp.IndentLevel:= 1;
  tv.AddProperty( bp );

  { vectorial font defaults }
  tv:= TEzTreeViewProperty.Create('Default Vectorial font');
  Inspector1.AddProperty( tv );
  tv.Modified:=true;    { causes to show on bold}

  bp:= TEzFontNameProperty.Create('DefaultFont.Name');
  bp.ValString:= Pref.DefFontStyle.Name;
  //bp.IndentLevel:= 1;
  bp.Hint:='Define vectorial font name';
  tv.AddProperty( bp );

  bp:= TEzFloatProperty.Create('DefaultFont.Height');
  bp.ValFloat:= Pref.DefTTFontStyle.Height;
  //bp.IndentLevel:= 1;
  bp.Hint:='Define height of text';
  tv.AddProperty( bp );

  bp:= TEzColorProperty.Create('DefaultFont.Color');
  bp.ValInteger:= Pref.DefTTFontStyle.Color;
  //bp.IndentLevel:= 1;
  bp.Hint:='Define color of text for new entities';
  tv.AddProperty( bp );



  { selection pen and brush }
  tv:= TEzTreeViewProperty.Create('Selection');
  Inspector1.AddProperty( tv );
  tv.Modified:=true;    { causes to show on bold}

  bp:= TEzLinetypeProperty.Create('SelectionPen.Style');
  bp.ValInteger:= Pref.SelectionPen.Style;
  //bp.IndentLevel:= 1;
  bp.Hint:='Define style of line for selected entities';
  tv.AddProperty( bp );

  bp:= TEzColorProperty.Create('SelectionPen.PenColor');
  bp.ValInteger:= Pref.SelectionPen.Color;
  //bp.IndentLevel:= 1;
  bp.Hint:='Define color of line for selected entities';
  tv.AddProperty( bp );

  bp:= TEzFloatProperty.Create('SelectionPen.PenWidth(Scale)');
  bp.ValFloat:= Pref.SelectionPen.Scale;
  //bp.IndentLevel:= 1;
  bp.Hint:='Define width/scale of line for selected entities';
  tv.AddProperty( bp );

  bp:= TEzBrushstyleProperty.Create('SelectionBrush.Pattern');
  bp.ValInteger:= Pref.SelectionBrush.Pattern;
  //bp.IndentLevel:= 1;
  bp.Hint:='Define pattern for selected entities';
  tv.AddProperty( bp );

  bp:= TEzColorProperty.Create('SelectionBrush.ForeColor');
  bp.ValInteger:= Pref.SelectionBrush.ForeColor;
  //bp.IndentLevel:= 1;
  bp.Hint:='Define brush fore color for selected entities';
  tv.AddProperty( bp );

  bp:= TEzColorProperty.Create('SelectionBrush.BackColor');
  bp.ValInteger:= Pref.SelectionBrush.BackColor;
  //bp.IndentLevel:= 1;
  bp.Hint:='Define brush back color for selected entities';
  tv.AddProperty( bp );

  bp:= TEzBooleanProperty.Create('SelectPickingInside');
  bp.ValBoolean:= Pref.SelectPickingInside;
  //bp.IndentLevel:= 1;
  bp.Hint:='Determine if closed entities are selected when clicking inside';
  tv.AddProperty( bp );



  { hint font }
  tv:= TEzTreeViewProperty.Create('Hints');
  Inspector1.AddProperty( tv );
  tv.Modified:=true;    { causes to show on bold}

  bp:= TEzColorProperty.Create('HintColor');
  bp.ValInteger:= Pref.HintColor;
  //bp.IndentLevel:= 1;
  bp.Hint:='Determine color for hints';
  tv.AddProperty( bp );

  bp:= TEzFontNameProperty.Create('HintFont.Name');
  TEzFontNameProperty(bp).TrueType:= true;
  bp.ValString:= Pref.HintFont.Name;
  //bp.IndentLevel:= 1;
  bp.Hint:='Define name of hint font';
  tv.AddProperty( bp );

  bp:= TEzIntegerProperty.Create('HintFont.Size');
  bp.ValInteger:= Pref.HintFont.Size;
  //bp.IndentLevel:= 1;
  bp.Hint:='Define height of hint font in points';
  tv.AddProperty( bp );

  bp:= TEzColorProperty.Create('HintFont.Color');
  bp.ValInteger:= Pref.HintFont.Color;
  //bp.IndentLevel:= 1;
  bp.Hint:='Define color of hint font';
  tv.AddProperty( bp );

  bp:= TEzSetProperty.Create('HintFont.Style');
  bp.Hint:= 'Define hint font style';
  with TEzSetProperty(bp) do
  begin
    Strings.BeginUpdate;
    Strings.add('Bold');
    Strings.add('Italic');
    Strings.add('Underline');
    Strings.add('StrikeOut');
    Strings.EndUpdate;

    Defined[0] := fsBold in Pref.HintFont.Style;
    Defined[1] := fsItalic in Pref.HintFont.Style;
    Defined[2] := fsUnderline in Pref.HintFont.Style;
    Defined[3] := fsStrikeout in Pref.HintFont.Style;
  end;
  //bp.IndentLevel:= 1;
  tv.AddProperty( bp );

  Inspector1.FullExpand;

  ShowModal;
end;

procedure TfrmPreferences.FormClose(Sender: TObject;
  var Action: TCloseAction);
var
  ColsString: TStrings;
  I: Integer;
begin
  ColsString:= TStringList.Create;
  try
    for I:= 0 to Inspector1.ColCount-1 do
      ColsString.Add(Format('Col%d=%d', [I,Inspector1.ColWidths[I]] ));
    SaveFormPlacement( ExtractFilePath(Application.ExeName) + 'formspos.ini',
      Self, ColsString );
  finally
    ColsString.Free;
  end;
end;

procedure TfrmPreferences.Button1Click(Sender: TObject);
var
  bp: TEzBaseProperty;
  style: TFontStyles;
  tmpmod: Boolean;
begin
  bp:= Inspector1.GetPropertyByName('PointEntitySize');
  if bp.modified then
    FPref.PointEntitySize:= bp.ValInteger;

  bp:= Inspector1.GetPropertyByName('DirectionArrowSize');
  if bp.modified then
    FPref.DirectionArrowSize:= bp.ValFloat;

  bp:= Inspector1.GetPropertyByName('UsePreloadedBlocks');
  if bp.modified then
    FPref.UsePreloadedBlocks:= bp.ValBoolean;

  bp:= Inspector1.GetPropertyByName('UsePreloadedImages');
  if bp.modified then
    FPref.UsePreloadedImages:= bp.ValBoolean;

  bp:= Inspector1.GetPropertyByName('UsePreloadedBandedImages');
  if bp.modified then
    FPref.UsePreloadedBandedImages:= bp.ValBoolean;

  bp:= Inspector1.GetPropertyByName('PatternPlotterOptimized');
  if bp.modified then
    FPref.PatternPlotterOptimized:= bp.ValBoolean;

  bp:= Inspector1.GetPropertyByName('PolylineGen');
  if bp.modified then
    FPref.PlineGen:= bp.ValBoolean;

  bp:= Inspector1.GetPropertyByName('SplineSegs');
  if bp.modified then
    FPref.SplineSegs:= bp.ValInteger;

  bp:= Inspector1.GetPropertyByName('EllipseSegs');
  if bp.modified then
    FPref.EllipseSegs:=bp.ValInteger;

  bp:= Inspector1.GetPropertyByName('ArcSegs');
  if bp.modified then
    FPref.ArcSegs:=bp.ValInteger;

  bp:= Inspector1.GetPropertyByName('CommonSubDir');
  if bp.modified then
    FPref.CommonSubDir:=bp.ValString;

  bp:= Inspector1.GetPropertyByName('BandsBitmapChunkSize');
  if bp.modified then
    FPref.BandsBitmapChunkSize:=bp.ValInteger;

  bp:= Inspector1.GetPropertyByName('DefaultPen.Style');
  if bp.modified then
    FPref.DefPenStyle.Style:=bp.ValInteger;

  bp:= Inspector1.GetPropertyByName('DefaultPen.PenColor');
  if bp.modified then
    FPref.DefPenStyle.Color:=bp.ValInteger;

  bp:= Inspector1.GetPropertyByName('DefaultPen.PenWidth(Scale)');
  if bp.modified then
    FPref.DefPenStyle.Scale:=bp.ValFloat;

  bp:= Inspector1.GetPropertyByName('DefaultBrush.Pattern');
  if bp.modified then
    FPref.DefBrushStyle.Pattern:=bp.ValInteger;

  bp:= Inspector1.GetPropertyByName('DefaultBrush.ForeColor');
  if bp.modified then
    FPref.DefBrushStyle.ForeColor:=bp.ValInteger;

  bp:= Inspector1.GetPropertyByName('DefaultBrush.BackColor');
  if bp.modified then
    FPref.DefBrushStyle.BackColor:=bp.ValInteger;

  bp:= Inspector1.GetPropertyByName('DefaultSymbol.Index');
  if bp.modified then
    FPref.DefSymbolStyle.Index:=bp.ValInteger;

  bp:= Inspector1.GetPropertyByName('DefaultSymbol.Rotangle');
  if bp.modified then
    FPref.DefSymbolStyle.Rotangle:=bp.ValFloat;

  bp:= Inspector1.GetPropertyByName('DefaultSymbol.Height');
  if bp.modified then
    FPref.DefSymbolStyle.Height:=bp.ValFloat;

  bp:= Inspector1.GetPropertyByName('DefaultTTFont.Name');
  if bp.modified then
    FPref.DefTTFontStyle.Name:=bp.ValString;

  bp:= Inspector1.GetPropertyByName('DefaultTTFont.Height');
  if bp.modified then
    FPref.DefTTFontStyle.Height:=bp.ValFloat;

  bp:= Inspector1.GetPropertyByName('DefaultTTFont.Color');
  if bp.modified then
    FPref.DefTTFontStyle.Color:=bp.ValInteger;

  style:=[];
  tmpmod:=false;

  bp:= Inspector1.GetPropertyByname('DefaultTTFont.Style');
  if bp.modified then
  begin
    with TEzSetProperty(bp) do
    begin
      if Defined[0] then Include(style,fsbold);
      if Defined[1] then Include(style,fsitalic);
      if Defined[2] then Include(style,fsunderline);
      if Defined[3] then Include(style,fsstrikeout);
    end;
    tmpmod:=true;
  end;

  if tmpmod then
    FPref.DefTTFontStyle.style:=style;

  bp:= Inspector1.GetPropertyByName('DefaultFont.Name');
  if bp.modified then
    FPref.DefFontStyle.Name:=bp.ValString;

  bp:= Inspector1.GetPropertyByName('DefaultFont.Height');
  if bp.modified then
    FPref.DefTTFontStyle.Height:=bp.ValFloat;

  bp:= Inspector1.GetPropertyByName('DefaultFont.Color');
  if bp.modified then
    FPref.DefTTFontStyle.Color:=bp.ValInteger;

  bp:= Inspector1.GetPropertyByName('ShowText');
  if bp.modified then
    FPref.ShowText:=bp.ValBoolean;

  bp:= Inspector1.GetPropertyByName('SelectionPen.Style');
  if bp.modified then
    FPref.SelectionPen.Style:=bp.ValInteger;

  bp:= Inspector1.GetPropertyByName('SelectionPen.PenColor');
  if bp.modified then
    FPref.SelectionPen.Color:=bp.ValInteger;

  bp:= Inspector1.GetPropertyByName('SelectionPen.PenWidth(Scale)');
  if bp.modified then
    FPref.SelectionPen.Scale:=bp.ValFloat;

  bp:= Inspector1.GetPropertyByName('SelectionBrush.Pattern');
  if bp.modified then
    FPref.SelectionBrush.Pattern:=bp.ValInteger;

  bp:= Inspector1.GetPropertyByName('SelectionBrush.ForeColor');
  if bp.modified then
    FPref.SelectionBrush.ForeColor:=bp.ValInteger;

  bp:= Inspector1.GetPropertyByName('SelectionBrush.BackColor');
  if bp.modified then
    FPref.SelectionBrush.BackColor:=bp.ValInteger;

  bp:= Inspector1.GetPropertyByName('ControlPointsWidth');
  if bp.modified then
    FPref.ControlPointsWidth:=bp.ValInteger;

  bp:= Inspector1.GetPropertyByName('ApertureWidth');
  if bp.modified then
    FPref.ApertureWidth:=bp.ValInteger;

  bp:= Inspector1.GetPropertyByName('MinimumDrawLimit');
  if bp.modified then
    FPref.MinDrawLimit:=bp.ValInteger;

  bp:= Inspector1.GetPropertyByName('AerialMinimumDrawLimit');
  if bp.modified then
    FPref.AerialMinDrawLimit:=bp.ValInteger;

  bp:= Inspector1.GetPropertyByName('SelectPickingInside');
  if bp.modified then
    FPref.SelectPickingInside:=bp.ValBoolean;

  bp:= Inspector1.GetPropertyByName('HintColor');
  if bp.modified then
    FPref.HintColor:=bp.ValInteger;

  bp:= Inspector1.GetPropertyByName('HintFont.Name');
  if bp.modified then
    FPref.HintFont.Name:=bp.ValString;

  bp:= Inspector1.GetPropertyByName('HintFont.Size');
  if bp.modified then
    FPref.HintFont.Size:=bp.ValInteger;

  bp:= Inspector1.GetPropertyByName('HintFont.Color');
  if bp.modified then
    FPref.HintFont.Color:=bp.ValInteger;

  tmpmod:=false;
  style:=[];

  bp:= Inspector1.GetPropertyByname('HintFont.Style');
  if bp.modified then
  begin
    with TEzSetProperty(bp) do
    begin
      if Defined[0] then Include(style,fsbold);
      if Defined[1] then Include(style,fsitalic);
      if Defined[2] then Include(style,fsunderline);
      if Defined[3] then Include(style,fsstrikeout);
    end;
    tmpmod:=true;
  end;

  if tmpmod then
    FPref.HintFont.style:=style;
end;

procedure TfrmPreferences.BtnExpandClick(Sender: TObject);
begin
  If BtnExpand.Down then
    Inspector1.FullExpand
  else
    Inspector1.FullCompact;
end;

end.
