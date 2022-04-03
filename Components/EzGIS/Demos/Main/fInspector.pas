unit fInspector;

{$I EZ_FLAG.PAS}
interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ezinspect, StdCtrls, Buttons, ExtCtrls, ezcmdline, ezbasegis,
  EzMiscelEntities, Grids, EzActionLaunch, ComCtrls;

type

  TfrmInspector = class(TForm)
    Panel1: TPanel;
    BtnApply: TSpeedButton;
    LblLayer: TLabel;
    Launcher1: TEzActionLauncher;
    PageControl1: TPageControl;
    TabSheet1: TTabSheet;
    TabSheet2: TTabSheet;
    Panel2: TPanel;
    LblProperty: TLabel;
    LblDesc: TLabel;
    Splitter1: TSplitter;
    Inspector1: TEzInspector;
    Memo1: TMemo;
    procedure FormKeyPress(Sender: TObject; var Key: Char);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure BtnApplyClick(Sender: TObject);
    procedure Inspector1PropertyChange(Sender: TObject;
      const PropertyName: String);
    procedure FormResize(Sender: TObject);
    procedure Launcher1Finished(Sender: TObject);
    procedure Inspector1PropertyHint(Sender: TObject;
      const PropertyName: String);
    procedure Launcher1TrackedEntityClick(Sender: TObject;
      const TrackID: String; Button: TMouseButton; Shift: TShiftState; X,
      Y: Integer; const WX, WY: Double; Layer: TEzBaseLayer;
      Recno: Integer; var Accept: Boolean);
  private
    { Private declarations }
    FCmdLine: TEzCmdLine;
    FLayer: TEzBaseLayer;
    FRecno: Integer;
  public
    { Public declarations }

    procedure CreateParams(var Params: TCreateParams); override;
    procedure Enter(CmdLine: TEzCmdLine);
    procedure ShowClickedEntity(Layer: TEzBaseLayer; Recno: Integer);
    procedure InspectorOff;
  end;

  { for editing the columns in a table }

  TEzTableColumnsProperty = class(TEzBaseProperty)
  private
    FColumns: TEzColumnList;
    FRowCount: Integer;
  public
    constructor Create( const PropName: string ); Override;
    destructor Destroy; Override;
    Procedure Edit(Inspector: TEzInspector); Override;
    function AsString: string; Override;

    property Columns: TEzColumnList read FColumns;
    property RowCount: Integer read FRowCount write FRowCount;
  end;


{ this variable is used for defining which one is the parent of the inspector form }

var
  InspParentHWND: THandle;

implementation

{$R *.DFM}

uses
  fMain, ezsystem, ezlib, ezentities, ezbase, ezconsts, ezgistiff,
  ezdims, fColsEditor, EzNetwork;

{ TEzTableColumnsProperty }

constructor TEzTableColumnsProperty.Create(const PropName: string);
begin
  inherited create(PropName);
  PropType:= ptString;
  UseEditButton:= true;
  FColumns:= TEzColumnList.Create( Nil );
end;

destructor TEzTableColumnsProperty.Destroy;
begin
  FColumns.Free;
  inherited destroy;
end;

function TEzTableColumnsProperty.AsString: string;
begin
  Result:= '(Columns)';
end;

procedure TEzTableColumnsProperty.Edit(Inspector: TEzInspector);
begin
  if ReadOnly then exit;
  with TfrmColumnsEditor.create(Application) do
    try
      if Enter(FRowCount, Self.FColumns)= mrOk then
      begin
        { assign the columns on the form to the columns on this property }
        Self.FColumns.Assign(EditColumns);
        Modified:= true;
        if Assigned(OnChange) then OnChange(Self);
      end;
    finally
      free;
    end;
end;

procedure TfrmInspector.CreateParams(var Params: TCreateParams);
begin
  inherited CreateParams( Params );
  with Params do
  begin
    Style := Style or WS_OVERLAPPED;
    WndParent := InspParentHWND;
  end;
end;

procedure TfrmInspector.InspectorOff;
begin
  Inspector1.ClearPropertyList;
  Inspector1.Visible:= false;
  LblLayer.Caption:= 'NONE';
  Caption:= 'Entity attributes';
  FLayer:= Nil;
  FRecno:= 0;
end;

procedure TfrmInspector.Enter(CmdLine: TEzCmdLine);
var
  ColsString: TStrings;
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

  FCmdLine:= CmdLine;

  Launcher1.CmdLine:= FCmdLine;

  Launcher1.TrackEntityClick( 'GRAPH_INFO', '', true );

  Self.Show;
end;

procedure TfrmInspector.FormKeyPress(Sender: TObject; var Key: Char);
begin
  if Key = #27 then Self.Close;
end;

resourcestring
  SSelColor= 'Select the color for the entity';
  SInsPtX= 'Insertion point X';
  SInsPtY= 'Insertion point Y';
  SSelSYmbol= 'Select the symbol to use';
  SRotangle= 'Define rotation angle in degrees';
  SSymbolHeight= 'Define height of symbol';
  SReplacemText= 'Define a replacement text';
  SPointsInCurve= 'Define no. of points to define curve';
  STransparency= 'Define the transparency level (0-255)';
  SDefinePicture= 'Define the picture file name';
  SDefIfTransparent= 'Define if showed transparent';
  SDefBitmap= 'Define the bitmap';
  SDefineOrder= 'Define the order of the spline';
  SDefIfVertVis= 'Define if vertical line is visible';
  SDefIfHorzVis= 'Define if horizontal line is visible';
  SDefRowH= 'Define row height of grid';
  SDefNOfRows= 'Define no. of rows in grid';
  SDefIfGridVis= 'Define if grid is visible';
  SDefGridColor= 'Define the color of the grid';
  SDefGridLineWidth= 'Define the line widht of the grid';
  SDefGridBorderWidth= 'Define the border width of grid';
  SDefGrid3DColor= 'Define color used to show as 3D grid';
  SDefColProps= 'Define columns properties';
  SDefTTFontname= 'Define windows true type font name';
  SDefTTText= 'Define the text shown';
  SDefTTAlign= 'Define alignment of text';
  SDefTTAngle= 'Define angle of text';
  SDefTTHeight= 'Define height of text';
  SDefTTColor= 'Define color of text';
  SDefFontStyle= 'Define font style';
  SDefBold = 'Define if text is bold';
  SDefItalic= 'Define if text is italic';
  SDefUnderl= 'Define if text is underline';
  SDefStrikeout= 'Define if text is strikeout';
  SDefVectfontname= 'Define vectorial font name';
  SDefHorzAlign= 'Define horizontal alignment';
  SDefVertAlign= 'Define vertical alignment';
  SDefInterCharSp= 'Define the inter character spacing';
  SDefInterlineSpc= 'Define the inter line spacing';
  SDefTextBaseX= 'Define start position X';
  SDefTextBaseY= 'Define start position Y';
  SDefTextWidth= 'Define text width';
  SDefBorderFx= 'Define border special effects';
  SDefPivotX= 'Define pivot point X for callout text';
  SDefPivotY= 'Define pivot point Y for callout text';
  SDefShadow= 'Define if shadow is shown';
  SDefFileBlock= 'Define name of file block';
  SDefScaleX= 'Define scale factor X axxis';
  SDefScaleY= 'Define scale factor Y axxis';
  SDefPaperUnits= 'Define units in paper';
  SDefDwgUnits= 'Define units in drawing';
  SShowFrame= 'Show a frame around ?';
  SDefPrevQuality= 'define quality of preview';
  SMinXCoordSource= 'X min coord of source drawing';
  SMinyCoordSource= 'Y min coord of source drawing';
  SMaxXCoordSource= 'X max coord of source drawing';
  SMaxYCoordSource= 'Y max coord of source drawing';
  SDefFittedToLen= 'Define if the text is fitted along the path';
  SDefCharSpacing= 'Define interchar spacing if text is not fitted to path';
  SShowSpline= 'Show spline ?';

procedure TfrmInspector.ShowClickedEntity(Layer: TEzBaseLayer; Recno: Integer);
var
  Entity: TEzEntity;
  bp: TEzBaseProperty;
  clsname,S: string;
  I: Integer;

  procedure AddOpenedProperties(Pentool: TEzPentool);
  begin
    bp:= TEzLinetypeProperty.Create('PenStyle');
    bp.ValInteger:= PenTool.Style;
    bp.Hint:= 'Select the pen style';
    Inspector1.AddProperty( bp );

    bp:= TEzColorProperty.Create('PenColor');
    bp.ValInteger:= PenTool.Color;
    bp.Hint:= 'Select the pen color';
    Inspector1.AddProperty( bp );

    bp:= TEzFloatProperty.Create('PenWidth(Scale)');
    bp.ValFloat:= PenTool.Scale;
    bp.Hint:= 'Select the pen width or scale';
    Inspector1.AddProperty( bp );
  end;

  procedure AddClosedProperties;
  begin
    with TEzClosedEntity(Entity) do
    begin

      AddOpenedProperties(Pentool);

      bp:= TEzBrushstyleProperty.Create('BrushPattern');
      bp.ValInteger:= TEzClosedEntity(Entity).BrushTool.Pattern;
      bp.Hint:= 'Select the brush pattern';
      Inspector1.AddProperty( bp );

      bp:= TEzColorProperty.Create('BrushForeColor');
      bp.ValInteger:= TEzClosedEntity(Entity).BrushTool.ForeColor;
      bp.Hint:= 'Select the brush foreground color';
      Inspector1.AddProperty( bp );

      bp:= TEzColorProperty.Create('BrushBackColor');
      TEzColorProperty(bp).NoneColorText:= SNoneColorTextInColorPicker;
      TEzColorProperty(bp).ShowSystemColors:= true;
      bp.ValInteger:= TEzClosedEntity(Entity).BrushTool.BackColor;
      bp.Hint:= 'Select the brush background color';
      Inspector1.AddProperty( bp );
    end;
  end;

  procedure AddPointsProperty;
  begin
    { add the points }
    bp:= TEzPointsProperty.Create('Points');
    bp.Hint:= 'Edit the points in text mode';
    TEzPointsProperty(bp).Vector.Assign( Entity.Points );
    TEzPointsProperty(bp).Vector.CanGrow:= Entity.Points.CanGrow;
    Inspector1.AddProperty( bp );
  end;

  procedure AddRectanglePointsProperty;
  begin
    bp:= TEzFloatProperty.Create('Xmin');
    bp.ValFloat:= Entity.Points[0].X;
    bp.Hint:= 'Lower left X';
    Inspector1.AddProperty( bp );

    bp:= TEzFloatProperty.Create('Ymin');
    bp.ValFloat:= Entity.Points[0].Y;
    bp.Hint:= 'Lower left Y';
    Inspector1.AddProperty( bp );

    bp:= TEzFloatProperty.Create('Xmax');
    bp.ValFloat:= Entity.Points[1].X;
    bp.Hint:= 'Upper right X';
    Inspector1.AddProperty( bp );

    bp:= TEzFloatProperty.Create('Ymax');
    bp.ValFloat:= Entity.Points[1].Y;
    bp.Hint:= 'Upper right Y';
    Inspector1.AddProperty( bp );
  end;

  procedure AddOnePointProperty;
  begin
    bp:= TEzFloatProperty.Create('X');
    bp.ValFloat:= Entity.Points[0].X;
    bp.Hint:= SInsPtX;
    Inspector1.AddProperty( bp );

    bp:= TEzFloatProperty.Create('Y');
    bp.ValFloat:= Entity.Points[0].Y;
    bp.Hint:= SInsPtY;
    Inspector1.AddProperty( bp );
  end;

begin
  FLayer:= Layer;
  FRecno:= Recno;
  Entity:= Layer.LoadEntityWithRecNo(RecNo);
  if Entity = nil then
  begin
    // entity is deleted
    FCmdLine.ActiveDrawBox.Refresh;
    Exit;
  end;

  try
    If Assigned( Layer.DbTable ) Then
      Layer.DbTable.Recno:= Recno;
    Memo1.Lines.Text:= Entity.AsString(True,True,Layer.DbTable);

    clsname:= Entity.ClassName;
    clsname:= Copy(clsname, 4,length(clsname)-3);
    Caption:= Format('%s attributes',[clsname]);

    LblLayer.Caption:= Format('%s / %d ', [FLayer.Name, FRecno]);

    { now load the entity }
    Inspector1.ClearPropertyList;
    Inspector1.Visible:= true;
    Panel2.Visible:= true;

    case Entity.EntityID of
      idNone:
        begin
          // nothing to edit
        end;
      idPoint:
        begin
          bp:= TEzColorProperty.Create('Color');
          bp.ValInteger:= TEzPointEntity(Entity).Color;
          bp.Hint:= SSelColor;
          Inspector1.AddProperty( bp );

          AddOnePointProperty;
        end;
      idPlace, idNode:
        begin
          bp:= TEzSymbolProperty.Create('SymbolIndex');
          bp.ValInteger:= TEzPlace(Entity).Symboltool.Index;
          bp.Hint:= SSelSymbol;
          Inspector1.AddProperty( bp );

          bp:= TEzAngleProperty.Create('Rotangle');
          bp.ValFloat:= TEzPlace(Entity).Symboltool.Rotangle;
          bp.Hint:= SRotangle;
          Inspector1.AddProperty( bp );

          bp:= TEzFloatProperty.Create('Height');
          bp.ValFloat:= TEzPlace(Entity).Symboltool.Height;
          bp.Hint:= SSymbolHeight;
          Inspector1.AddProperty( bp );

          bp:= TEzStringProperty.Create('Text');
          bp.ValString:= TEzPlace(Entity).Text;
          bp.Hint:= SReplacemText;
          Inspector1.AddProperty( bp );

          AddOnePointProperty;

          If Entity.EntityID = idNode then
          begin
            bp:= TEzStringProperty.Create('Links');
            S:= '';
            For I:= 0 to TEzNode(Entity).Links.Count-1 do
            begin
              S:= S + IntToStr( TEzNode(Entity).Links[I] );
              if I < TEzNode(Entity).Links.Count-1 then
                S:= s + ',';
            end;
            bp.ValString:= S;
            bp.ReadOnly:= true;
            Inspector1.AddProperty( bp );
          end;
        end;
      idPolyline, idNodeLink:
        begin
          AddOpenedProperties(TEzOpenedEntity(Entity).Pentool);
          AddPointsProperty;
          If Entity.EntityID = idNodeLink then
          begin
            bp:= TEzIntegerProperty.Create('From Node');
            bp.ValInteger:= TEzNodeLink(Entity).FromNode;
            bp.ReadOnly:= true;
            Inspector1.AddProperty( bp );

            bp:= TEzIntegerProperty.Create('To Node');
            bp.ValInteger:= TEzNodeLink(Entity).ToNode;
            bp.ReadOnly:= true;
            Inspector1.AddProperty( bp );

            { travel restriction }
            bp:= TEzEnumerationProperty.Create('Travel Restriction');
            with TEzEnumerationProperty(bp).Strings do
            begin
              Add('Both ways');
              Add('From Start To End Only');
              Add('From End To Start Only');
              Add('Cannot Travel');
            end;
            bp.ValInteger:= Ord(TEzNodeLink(Entity).Restriction);
            //bp.Hint:= SDefTTAlign;
            Inspector1.AddProperty( bp );

          end;
        end;
      idPolygon:
        begin
          AddClosedProperties;
          AddPointsProperty;
        end;
      idRectangle:
        begin
          AddClosedProperties;

          bp:= TEzAngleProperty.Create('Rotangle');
          bp.ValFloat:= TEzRectangle(Entity).Rotangle;
          bp.Hint:= SRotangle;
          Inspector1.AddProperty( bp );

          AddRectanglePointsProperty;
        end;
      idArc:
        begin
          AddOpenedProperties(TEzOpenedEntity(Entity).Pentool);

          bp:= TEzIntegerProperty.Create('PointsInCurve');
          bp.ValInteger:= TEzArc(Entity).PointsInCurve;
          bp.Hint:= SPointsInCurve;
          Inspector1.AddProperty( bp );

          bp:= TEzFloatProperty.Create('X1');
          bp.ValFloat:= Entity.Points[0].X;
          Inspector1.AddProperty( bp );

          bp:= TEzFloatProperty.Create('Y1');
          bp.ValFloat:= Entity.Points[0].Y;
          Inspector1.AddProperty( bp );

          bp:= TEzFloatProperty.Create('X2');
          bp.ValFloat:= Entity.Points[1].X;
          Inspector1.AddProperty( bp );

          bp:= TEzFloatProperty.Create('Y2');
          bp.ValFloat:= Entity.Points[1].Y;
          Inspector1.AddProperty( bp );

          bp:= TEzFloatProperty.Create('X3');
          bp.ValFloat:= Entity.Points[2].X;
          Inspector1.AddProperty( bp );

          bp:= TEzFloatProperty.Create('Y3');
          bp.ValFloat:= Entity.Points[2].Y;
          Inspector1.AddProperty( bp );
        end;
      idEllipse:
        begin
          AddClosedProperties;

          bp:= TEzIntegerProperty.Create('PointsInCurve');
          bp.ValInteger:= TEzEllipse(Entity).PointsInCurve;
          bp.Hint:= SPointsInCurve;
          Inspector1.AddProperty( bp );

          bp:= TEzAngleProperty.Create('Rotangle');
          bp.ValFloat:= TEzEllipse(Entity).Rotangle;
          bp.Hint:= SRotangle;
          Inspector1.AddProperty( bp );

          AddRectanglePointsProperty;
        end;
      idPictureRef:
        begin
          bp:= TEzIntegerProperty.Create('AlphaChannel');
          bp.ValInteger:= TEzPictureRef(Entity).AlphaChannel;
          bp.Hint:= STransparency;
          Inspector1.AddProperty( bp );

          bp:= TEzDefineAnyLocalImageProperty.Create('FileName');
          bp.ValString:= TEzPictureRef(Entity).FileName;
          bp.Hint:= SDefinePicture;
          Inspector1.AddProperty( bp );

          AddRectanglePointsProperty;
        end;
      idPersistBitmap:
        begin
          bp:= TEzBooleanProperty.Create('Transparent');
          bp.ValBoolean:= TEzPersistBitmap(Entity).Transparent;
          bp.Hint:= SDefIfTransparent;
          Inspector1.AddProperty( bp );

          bp:= TEzBitmapProperty.Create('Bitmap');
          TEzBitmapProperty(bp).Bitmap.Assign( TEzPersistBitmap(Entity).Bitmap );
          bp.Hint:= SDefBitmap;
          Inspector1.AddProperty( bp );

          AddRectanglePointsProperty;
        end;
      idBandsBitmap:
        begin
          bp:= TEzIntegerProperty.Create('AlphaChannel');
          bp.ValInteger:= TEzBandsBitmap(Entity).AlphaChannel;
          bp.Hint:= STransparency;
          Inspector1.AddProperty( bp );

          bp:= TEzDefineLocalBitmapProperty.Create('FileName');
          bp.ValString:= TEzBandsBitmap(Entity).FileName;
          bp.Hint:= SDefinePicture;
          Inspector1.AddProperty( bp );

          AddRectanglePointsProperty;
        end;
      idSpline, idSplineText:
        begin
          if (Entity.EntityID = idSpline) or
            ((Entity.EntityID = idSplineText) and TEzSplineText(Entity).ShowSpline) then
          begin
            AddOpenedProperties(TEzOpenedEntity(Entity).Pentool);

            bp:= TEzIntegerProperty.Create('PointsInCurve');
            bp.ValInteger:= TEzSpline(Entity).PointsInCurve;
            bp.Hint:= SPointsInCurve;
            Inspector1.AddProperty( bp );

            bp:= TEzIntegerProperty.Create('Order');
            bp.ValInteger:= TEzSpline(Entity).Order;
            bp.Hint:= SDefineOrder;
            Inspector1.AddProperty( bp );
          end;

          AddPointsProperty;

          if Entity.EntityID = idSplineText then
          begin
            bp:= TEzStringProperty.Create('Text');
            bp.ValString:= TEzSplineText(Entity).Text;
            bp.Hint:= SDefTTText;
            Inspector1.AddProperty( bp );

            bp:= TEzBooleanProperty.Create('FittedToLen');
            bp.ValBoolean:= TEzSplineText(Entity).Fitted;
            bp.Hint:= SDefFittedToLen;
            Inspector1.AddProperty( bp );

            bp:= TEzFloatProperty.Create('InterCharSpacing');
            bp.ValFloat:= TEzSplineText(Entity).CharSpacing;
            bp.Hint:= SDefCharSpacing;
            Inspector1.AddProperty( bp );

            bp:= TEzFontNameProperty.Create('FontName');
            TEzFontNameProperty(bp).TrueType:=
              TEzSplineText(Entity).UseTrueType;
            bp.ValString:= TEzSplineText(Entity).Fonttool.Name;
            bp.Hint:= SDefTTFontname;
            Inspector1.AddProperty( bp );

            bp:= TEzFloatProperty.Create('FontHeight');
            bp.ValFloat:= TEzSplineText(Entity).Fonttool.Height;
            bp.Hint:= SDefTTHeight;
            Inspector1.AddProperty( bp );

            bp:= TEzColorProperty.Create('FontColor');
            bp.ValInteger:= TEzSplineText(Entity).Fonttool.Color;
            bp.Hint:= SDefTTColor;
            Inspector1.AddProperty( bp );

            if TEzSplineText(Entity).UseTrueType then
            begin
              bp:= TEzSetProperty.Create('FontStyle');
              bp.Hint:= SDefFontStyle;
              with TEzSetProperty(bp) do
              begin
                Strings.BeginUpdate;
                Strings.add('Bold');
                Strings.add('Italic');
                Strings.add('Underline');
                Strings.add('StrikeOut');
                Strings.EndUpdate;

                with TEzSplineText(Entity).Fonttool do
                begin
                  Defined[0] := fsBold in Style;
                  Defined[1] := fsItalic in Style;
                  Defined[2] := fsUnderline in Style;
                  Defined[3] := fsStrikeout in Style;
                end;
              end;
              Inspector1.AddProperty( bp );

            end;
            bp:= TEzBooleanProperty.Create('ShowSpline');
            bp.ValBoolean:= TEzSplineText(Entity).ShowSpline;
            bp.Hint:= SShowSpline;
            Inspector1.AddProperty( bp );

          end;
        end;
      idTable:
        begin
          AddClosedProperties;

          bp:= TEzBooleanProperty.Create('VerticalLine');
          bp.ValBoolean:= ezgoVertLine in TEzTableEntity(Entity).Options;
          bp.Hint:= SDefIfVertVis;
          Inspector1.AddProperty( bp );

          bp:= TEzBooleanProperty.Create('HorizontalLine');
          bp.ValBoolean:= ezgoHorzLine in TEzTableEntity(Entity).Options;
          bp.Hint:= SDefIfHorzVis;
          Inspector1.AddProperty( bp );

          bp:= TEzFloatProperty.Create('RowHeight');
          bp.ValFloat:= TEzTableEntity(Entity).RowHeight;
          bp.Hint:= SDefRowH;
          Inspector1.AddProperty( bp );

          bp:= TEzIntegerProperty.Create('RowCount');
          bp.ValInteger:= TEzTableEntity(Entity).RowCount;
          bp.Hint:= SDefNOfRows;
          Inspector1.AddProperty( bp );

          bp:= TEzBooleanProperty.Create('GridVisible');
          bp.ValBoolean:= TEzTableEntity(Entity).GridStyle.Visible;
          bp.Hint:= SDefIfGridVis;
          Inspector1.AddProperty( bp );

          {bp:= TEzLinetypeProperty.Create('GridStyle');
          bp.ValInteger:= TEzTableEntity(Entity).GridStyle.Style;
          Inspector1.AddProperty( bp ); }

          bp:= TEzColorProperty.Create('GridColor');
          bp.ValInteger:= TEzTableEntity(Entity).GridStyle.Color;
          bp.Hint:= SDefGridColor;
          Inspector1.AddProperty( bp );

          bp:= TEzFloatProperty.Create('GridWidth');
          bp.ValFloat:= TEzTableEntity(Entity).GridStyle.Width;
          bp.Hint:= SDefGridLineWidth;
          Inspector1.AddProperty( bp );

          bp:= TEzFloatProperty.Create('BorderWidth');
          bp.ValFloat:= TEzTableEntity(Entity).BorderWidth;
          bp.Hint:= SDefGridBorderWidth;
          Inspector1.AddProperty( bp );

          bp:= TEzColorProperty.Create('LoweredColor');
          bp.ValInteger:= TEzTableEntity(Entity).LoweredColor;
          bp.Hint:= SDefGrid3DColor;
          Inspector1.AddProperty( bp );

          bp:= TEzTableColumnsProperty.Create('TableColumns');
          TEzTableColumnsProperty(bp).Columns.Assign( TEzTableEntity(Entity).Columns );
          TEzTableColumnsProperty(bp).RowCount:= TEzTableEntity(Entity).RowCount;
          bp.Hint:= SDefColProps;
          Inspector1.AddProperty( bp );

          AddRectanglePointsProperty;
        end;
      idGroup:
        begin
          // not yet editable
        end;
      idTrueTypeText:
        begin
          AddClosedProperties;

          bp:= TEzLongTextProperty.Create('Text');
          bp.ValString:= TEzTrueTypeText(Entity).Text;
          bp.Hint:= SDefTTText;
          Inspector1.AddProperty( bp );

          bp:= TEzFontNameProperty.Create('FontName');
          TEzFontNameProperty(bp).TrueType:= true;
          bp.ValString:= TEzTrueTypeText(Entity).Fonttool.Name;
          bp.Hint:= SDefTTFontname;
          Inspector1.AddProperty( bp );

          bp:= TEzEnumerationProperty.Create('Alignment');
          with TEzEnumerationProperty(bp).Strings do
          begin
            Add('taLeftJustify');
            Add('taRightJustify');
            Add('taCenter');
          end;
          bp.ValInteger:= Ord(TEzTrueTypeText(Entity).Alignment);
          bp.Hint:= SDefTTAlign;
          Inspector1.AddProperty( bp );

          bp:= TEzAngleProperty.Create('Angle');
          bp.ValFloat:= TEzTrueTypeText(Entity).Fonttool.Angle;
          bp.Hint:= SDefTTAngle;
          Inspector1.AddProperty( bp );

          bp:= TEzFloatProperty.Create('Height');
          bp.ValFloat:= TEzTrueTypeText(Entity).Fonttool.Height;
          bp.Hint:= SDefTTHeight;
          Inspector1.AddProperty( bp );

          bp:= TEzColorProperty.Create('Color');
          bp.ValInteger:= TEzTrueTypeText(Entity).Fonttool.Color;
          bp.Hint:= SDefTTColor;
          Inspector1.AddProperty( bp );

          bp:= TEzSetProperty.Create('FontStyle');
          bp.Hint:= SDefFontStyle;
          with TEzSetProperty(bp) do
          begin
            Strings.BeginUpdate;
            Strings.add('Bold');
            Strings.add('Italic');
            Strings.add('Underline');
            Strings.add('StrikeOut');
            Strings.EndUpdate;

            with TEzTrueTypeText(Entity).Fonttool do
            begin
              Defined[0] := fsBold in Style;
              Defined[1] := fsItalic in Style;
              Defined[2] := fsUnderline in Style;
              Defined[3] := fsStrikeout in Style;
            end;
          end;
          Inspector1.AddProperty( bp );

          AddOnePointProperty;
        end;
      idJustifVectText:
        begin
          AddClosedProperties;

          bp:= TEzLongTextProperty.Create('Text');
          bp.ValString:= TEzJustifVectorText(Entity).Text;
          bp.Hint:= SDefTTText;
          Inspector1.AddProperty( bp );

          bp:= TEzFloatProperty.Create('Height');
          bp.ValFloat:= TEzJustifVectorText(Entity).Height;
          bp.Hint:= SDefTTHeight;
          Inspector1.AddProperty( bp );

          bp:= TEzAngleProperty.Create('Angle');
          bp.ValFloat:= TEzJustifVectorText(Entity).Angle;
          bp.Hint:= SRotangle;
          Inspector1.AddProperty( bp );

          bp:= TEzColorProperty.Create('FontColor');
          bp.ValInteger:= TEzJustifVectorText(Entity).FontColor;
          bp.Hint:= SDefTTColor;
          Inspector1.AddProperty( bp );

          bp:= TEzFontNameProperty.Create('FontName');
          bp.ValString:= TEzJustifVectorText(Entity).FontName;
          bp.Hint:= SDefVectFontname;
          Inspector1.AddProperty( bp );

          bp:= TEzEnumerationProperty.Create('HorzAlignment');
          with TEzEnumerationProperty(bp).Strings do
          begin
            Add('haLeft');
            Add('haCenter');
            Add('haRight');
          end;
          bp.ValInteger:= Ord(TEzJustifVectorText(Entity).HorzAlignment);
          bp.Hint:= SDefHorzAlign;
          Inspector1.AddProperty( bp );

          bp:= TEzEnumerationProperty.Create('VertAlignment');
          with TEzEnumerationProperty(bp).Strings do
          begin
            Add('vaTop');
            Add('vaCenter');
            Add('vaBottom');
          end;
          bp.ValInteger:= Ord(TEzJustifVectorText(Entity).VertAlignment);
          bp.Hint:= SDefVertAlign;
          Inspector1.AddProperty( bp );

          bp:= TEzFloatProperty.Create('InterCharSpacing');
          bp.ValFloat:= TEzJustifVectorText(Entity).InterCharSpacing;
          bp.Hint:= SDefInterCharSp;
          Inspector1.AddProperty( bp );

          bp:= TEzFloatProperty.Create('InterLineSpacing');
          bp.ValFloat:= TEzJustifVectorText(Entity).InterLineSpacing;
          bp.Hint:= SDefInterlineSpc;
          Inspector1.AddProperty( bp );

          AddRectanglePointsProperty;
        end;
      idFittedVectText:
        begin
          AddClosedProperties;

          bp:= TEzLongTextProperty.Create('Text');
          bp.ValString:= TEzFittedVectorText(Entity).Text;
          bp.Hint:= SDefTTText;
          Inspector1.AddProperty( bp );

          AddOnePointProperty;

          bp:= TEzFloatProperty.Create('Height');
          bp.ValFloat:= TEzFittedVectorText(Entity).Height;
          bp.Hint:= SDefTTHeight;
          Inspector1.AddProperty( bp );

          bp:= TEzFloatProperty.Create('Width');
          bp.ValFloat:= TEzFittedVectorText(Entity).Width;
          bp.Hint:= SDefTextWidth;
          Inspector1.AddProperty( bp );

          bp:= TEzAngleProperty.Create('Angle');
          bp.ValFloat:= TEzFittedVectorText(Entity).Angle;
          bp.Hint:= SDefTTAngle;
          Inspector1.AddProperty( bp );

          bp:= TEzColorProperty.Create('FontColor');
          bp.ValInteger:= TEzFittedVectorText(Entity).FontColor;
          bp.Hint:= SDefTTColor;
          Inspector1.AddProperty( bp );

          bp:= TEzFontNameProperty.Create('FontName');
          bp.ValString:= TEzFittedVectorText(Entity).FontName;
          bp.Hint:= SDefVectfontname;
          Inspector1.AddProperty( bp );

          bp:= TEzFloatProperty.Create('InterCharSpacing');
          bp.ValFloat:= TEzFittedVectorText(Entity).InterCharSpacing;
          bp.Hint:= SDefInterCharSp;
          Inspector1.AddProperty( bp );

          bp:= TEzFloatProperty.Create('InterLineSpacing');
          bp.ValFloat:= TEzFittedVectorText(Entity).InterLineSpacing;
          bp.Hint:= SDefInterlineSpc;
          Inspector1.AddProperty( bp );

          bp:= TEzEnumerationProperty.Create('TextBorderStyle');
          with TEzEnumerationProperty(bp).Strings do
          begin
            Add('tbsNone');
            Add('tbsBanner');
            Add('tbsCallout');
            Add('tbsBulletLeader');
          end;
          bp.ValInteger:= Ord(TEzFittedVectorText(Entity).TextBorderStyle);
          bp.Hint:= SDefBorderFx;
          Inspector1.AddProperty( bp );

          bp:= TEzFloatProperty.Create('PivotX');
          bp.ValFloat:= TEzFittedVectorText(Entity).Pivot.X;
          bp.Hint:= SDefPivotX;
          Inspector1.AddProperty( bp );

          bp:= TEzFloatProperty.Create('PivotY');
          bp.ValFloat:= TEzFittedVectorText(Entity).Pivot.Y;
          bp.Hint:= SDefPivotY;
          Inspector1.AddProperty( bp );

          bp:= TEzBooleanProperty.Create('HideShadow');
          bp.ValBoolean:= TEzFittedVectorText(Entity).HideShadow;
          bp.Hint:= SDefShadow;
          Inspector1.AddProperty( bp );

        end;
      idDimHorizontal:
        begin
          AddOpenedProperties(TEzDimHorizontal(Entity).Pentool);

          bp:= TEzFloatProperty.Create('TextLineY');
          bp.ValFloat:= TEzDimHorizontal(Entity).TextLineY;
          Inspector1.AddProperty( bp );

          bp:= TEzFloatProperty.Create('TextHeight');
          bp.ValFloat:= TEzDimHorizontal(Entity).TextHeight;
          Inspector1.AddProperty( bp );

          bp:= TEzIntegerProperty.Create('NumDecimals');
          bp.ValInteger:= TEzDimHorizontal(Entity).NumDecimals;
          Inspector1.AddProperty( bp );

          bp:= TEzFontNameProperty.Create('FontName');
          bp.ValString:= TEzDimHorizontal(Entity).FontName;
          Inspector1.AddProperty( bp );

          bp:= TEzFloatProperty.Create('BaseLineFromX');
          bp.ValFloat:= TEzDimHorizontal(Entity).BaseLineFrom.X;
          Inspector1.AddProperty( bp );

          bp:= TEzFloatProperty.Create('BaseLineFromY');
          bp.ValFloat:= TEzDimHorizontal(Entity).BaseLineFrom.Y;
          Inspector1.AddProperty( bp );

          bp:= TEzFloatProperty.Create('BaseLineToX');
          bp.ValFloat:= TEzDimHorizontal(Entity).BaseLineTo.X;
          Inspector1.AddProperty( bp );

          bp:= TEzFloatProperty.Create('BaseLineToY');
          bp.ValFloat:= TEzDimHorizontal(Entity).BaseLineTo.Y;
          Inspector1.AddProperty( bp );

          bp:= TEzFloatProperty.Create('TextBasePointX');
          bp.ValFloat:= TEzDimHorizontal(Entity).TextBasePoint.X;
          Inspector1.AddProperty( bp );

          bp:= TEzFloatProperty.Create('TextBasePointY');
          bp.ValFloat:= TEzDimHorizontal(Entity).TextBasePoint.Y;
          Inspector1.AddProperty( bp );

        end;
      idDimVertical:
        begin
          AddOpenedProperties(TEzDimVertical(Entity).Pentool);

          bp:= TEzFloatProperty.Create('TextLineX');
          bp.ValFloat:= TEzDimVertical(Entity).TextLineX;
          Inspector1.AddProperty( bp );

          bp:= TEzFloatProperty.Create('TextHeight');
          bp.ValFloat:= TEzDimVertical(Entity).TextHeight;
          Inspector1.AddProperty( bp );

          bp:= TEzIntegerProperty.Create('NumDecimals');
          bp.ValInteger:= TEzDimVertical(Entity).NumDecimals;
          Inspector1.AddProperty( bp );

          bp:= TEzFontNameProperty.Create('FontName');
          bp.ValString:= TEzDimVertical(Entity).FontName;
          Inspector1.AddProperty( bp );

          bp:= TEzFloatProperty.Create('BaseLineFromX');
          bp.ValFloat:= TEzDimVertical(Entity).BaseLineFrom.X;
          Inspector1.AddProperty( bp );

          bp:= TEzFloatProperty.Create('BaseLineFromY');
          bp.ValFloat:= TEzDimVertical(Entity).BaseLineFrom.Y;
          Inspector1.AddProperty( bp );

          bp:= TEzFloatProperty.Create('BaseLineToX');
          bp.ValFloat:= TEzDimVertical(Entity).BaseLineTo.X;
          Inspector1.AddProperty( bp );

          bp:= TEzFloatProperty.Create('BaseLineToY');
          bp.ValFloat:= TEzDimVertical(Entity).BaseLineTo.Y;
          Inspector1.AddProperty( bp );

          bp:= TEzFloatProperty.Create('TextBasePointX');
          bp.ValFloat:= TEzDimVertical(Entity).TextBasePoint.X;
          Inspector1.AddProperty( bp );

          bp:= TEzFloatProperty.Create('TextBasePointY');
          bp.ValFloat:= TEzDimVertical(Entity).TextBasePoint.Y;
          Inspector1.AddProperty( bp );

        end;
      idDimParallel:
        begin
          AddOpenedProperties(TEzDimParallel(Entity).Pentool);

          bp:= TEzFloatProperty.Create('TextLineDistanceApart');
          bp.ValFloat:= TEzDimParallel(Entity).TextLineDistanceApart;
          Inspector1.AddProperty( bp );

          bp:= TEzFloatProperty.Create('TextHeight');
          bp.ValFloat:= TEzDimParallel(Entity).TextHeight;
          Inspector1.AddProperty( bp );

          bp:= TEzIntegerProperty.Create('NumDecimals');
          bp.ValInteger:= TEzDimParallel(Entity).NumDecimals;
          Inspector1.AddProperty( bp );

          bp:= TEzFontNameProperty.Create('FontName');
          bp.ValString:= TEzDimParallel(Entity).FontName;
          Inspector1.AddProperty( bp );

          bp:= TEzFloatProperty.Create('BaseLineFromX');
          bp.ValFloat:= TEzDimParallel(Entity).BaseLineFrom.X;
          Inspector1.AddProperty( bp );

          bp:= TEzFloatProperty.Create('BaseLineFromY');
          bp.ValFloat:= TEzDimParallel(Entity).BaseLineFrom.Y;
          Inspector1.AddProperty( bp );

          bp:= TEzFloatProperty.Create('BaseLineToX');
          bp.ValFloat:= TEzDimParallel(Entity).BaseLineTo.X;
          Inspector1.AddProperty( bp );

          bp:= TEzFloatProperty.Create('BaseLineToY');
          bp.ValFloat:= TEzDimParallel(Entity).BaseLineTo.Y;
          Inspector1.AddProperty( bp );

          bp:= TEzFloatProperty.Create('TextBasePointX');
          bp.ValFloat:= TEzDimParallel(Entity).TextBasePoint.X;
          Inspector1.AddProperty( bp );

          bp:= TEzFloatProperty.Create('TextBasePointY');
          bp.ValFloat:= TEzDimParallel(Entity).TextBasePoint.Y;
          Inspector1.AddProperty( bp );
        end;
      idRtfText:
        begin
          // not edited yet
        end;
      idBlockInsert:
        begin
          bp:= TEzBlocksProperty.Create('BlockName');
          bp.ValString:= TEzBlockInsert(Entity).BlockName;
          bp.Hint:= SDefFileBlock;
          Inspector1.AddProperty( bp );

          bp:= TEzAngleProperty.Create('Rotangle');
          bp.ValFloat:= TEzBlockInsert(Entity).Rotangle;
          bp.Hint:= SRotangle;
          Inspector1.AddProperty( bp );

          bp:= TEzFloatProperty.Create('ScaleX');
          bp.ValFloat:= TEzBlockInsert(Entity).ScaleX;
          bp.Hint:= SDefScaleX;
          Inspector1.AddProperty( bp );

          bp:= TEzFloatProperty.Create('ScaleY');
          bp.ValFloat:= TEzBlockInsert(Entity).ScaleY;
          bp.Hint:= SDefScaleY;
          Inspector1.AddProperty( bp );

          bp:= TEzStringProperty.Create('Text');
          bp.ValString:= TEzBlockInsert(Entity).Text;
          bp.Hint:= SDefTTText;
          Inspector1.AddProperty( bp );

          AddOnePointProperty;

        end;
      idPreview:
        begin
          AddClosedProperties;

          bp:= TEzFloatProperty.Create('PlottedUnits');
          bp.ValFloat:= TEzPreviewEntity(Entity).PlottedUnits;
          bp.Hint:= SDefPaperUnits;
          Inspector1.AddProperty( bp );

          bp:= TEzFloatProperty.Create('DrawingUnits');
          bp.ValFloat:= TEzPreviewEntity(Entity).DrawingUnits;
          bp.Hint:= SDefDwgUnits;
          Inspector1.AddProperty( bp );

          bp:= TEzEnumerationProperty.Create('PaperUnits');
          with TEzEnumerationProperty(bp).Strings do
          begin
            Add('suInches');
            Add('suMms');
          end;
          bp.ValInteger:= Ord(TEzPreviewEntity(Entity).PaperUnits);
          bp.Hint:= SDefPaperUnits;
          Inspector1.AddProperty( bp );

          bp:= TEzBooleanProperty.Create('PrintFrame');
          bp.ValBoolean:= TEzPreviewEntity(Entity).PrintFrame;
          bp.Hint:= SShowFrame;
          Inspector1.AddProperty( bp );

          bp:= TEzEnumerationProperty.Create('Presentation');
          with TEzEnumerationProperty(bp).Strings do
          begin
            Add('ppQuality');
            Add('ppDraft');
          end;
          bp.ValInteger:= Ord(TEzPreviewEntity(Entity).Presentation);
          bp.Hint:= SDefPrevQuality;
          Inspector1.AddProperty( bp );

          bp:= TEzFloatProperty.Create('AreaToPrintXmin');
          bp.ValFloat:= TEzPreviewEntity(Entity).ProposedPrintArea.X1;
          bp.Hint:= SMinXCoordSource;
          Inspector1.AddProperty( bp );

          bp:= TEzFloatProperty.Create('AreaToPrintYmin');
          bp.ValFloat:= TEzPreviewEntity(Entity).ProposedPrintArea.Y1;
          bp.Hint:= SMinyCoordSource;
          Inspector1.AddProperty( bp );

          bp:= TEzFloatProperty.Create('AreaToPrintXmax');
          bp.ValFloat:= TEzPreviewEntity(Entity).ProposedPrintArea.X2;
          bp.Hint:= SMaxXCoordSource;
          Inspector1.AddProperty( bp );

          bp:= TEzFloatProperty.Create('AreaToPrintYmax');
          bp.ValFloat:= TEzPreviewEntity(Entity).ProposedPrintArea.Y2;
          bp.Hint:= SMaxYCoordSource;
          Inspector1.AddProperty( bp );

          AddRectanglePointsProperty;
        end;
    end;
  finally
    Entity.Free;
  end;
end;

procedure TfrmInspector.FormClose(Sender: TObject;
  var Action: TCloseAction);
var
  ColsString: TStrings;
  I: Integer;
begin
  ColsString:= TStringList.Create;
  try
    for I:= 0 to Inspector1.ColCount-1 do
      ColsString.Add(Format('Col%d=%d', [I,Inspector1.ColWidths[I]] ));
    SaveFormPlacement( ExtractFilePath(Application.ExeName) + 'formspos.ini', Self, ColsString );
  finally
    ColsString.Free;
  end;

  { pop this action }
  if FCmdLine.CurrentActionID = 'GRAPH_INFO' then
    FCmdLine.Pop;
end;

procedure TfrmInspector.BtnApplyClick(Sender: TObject);
var
  bp: TEzBaseProperty;
  TableOptions: TEzGridOptions;
  FontStyles: TFontStyles;
  tempX, tempY: Double;
  tempR: TEzRect;
  tempBorderStyle: TEzTableBorderStyle;
  bbox: TEzRect;
  BaseEntityID: TEzEntityID;
  I, J: Integer;
  SelLayer: TEzSelectionLayer;

  procedure UpdateOpenedProperties(Pentool: TEzPentool);
  begin
    bp:= Inspector1.GetPropertyByName('PenStyle');
    if bp.modified then
      PenTool.Style:= bp.ValInteger;

    bp:= Inspector1.GetPropertyByName('PenColor');
    if bp.modified then
      PenTool.Color:= TColor(bp.ValInteger);

    bp:= Inspector1.GetPropertyByName('PenWidth(Scale)');
    if bp.modified then
      PenTool.Width:= bp.ValFloat;
  end;

  procedure UpdateClosedProperties(Entity: TEzEntity);
  begin
    with TEzClosedEntity(Entity) do
    begin
      UpdateOpenedProperties(Pentool);

      bp:= Inspector1.GetPropertyByName('BrushPattern');
      if bp.modified then
        BrushTool.Pattern:= TColor(bp.ValInteger);

      bp:= Inspector1.GetPropertyByName('BrushForeColor');
      if bp.modified then
        BrushTool.ForeColor:= TColor(bp.ValInteger);

      bp:= Inspector1.GetPropertyByName('BrushBackColor');
      if bp.modified then
        BrushTool.BackColor:= TColor(bp.ValInteger);
    end;
  end;

  procedure UpdatePointsProperty(Entity: TEzEntity);
  begin
    bp:= Inspector1.GetPropertyByName('Points');
    if not bp.modified then exit;
    Entity.Points.Assign( TEzPointsProperty(bp).Vector );
  end;

  procedure UpdateRectanglePointsProperty(Entity: TEzEntity);
  var
    tmppt: TEzPoint;
  begin

    tmppt:= Entity.Points[0];
    bp:= Inspector1.GetPropertyByName('Xmin');
    if bp.modified then
      tmppt.X:= bp.ValFloat;

    bp:= Inspector1.GetPropertyByName('Ymin');
    if bp.modified then
      tmppt.Y:= bp.ValFloat;
    if not EqualPoint2d(Entity.Points[0], tmppt) then
      Entity.Points[0]:= tmppt;

    tmppt:= Entity.Points[1];
    bp:= Inspector1.GetPropertyByName('Xmax');
    if bp.modified then
      tmppt.X:= bp.ValFloat;

    bp:= Inspector1.GetPropertyByName('Ymax');
    if bp.modified then
      tmppt.Y:= bp.ValFloat;
    if not EqualPoint2d(Entity.Points[1], tmppt) then
      Entity.Points[1]:= tmppt;
  end;

  procedure UpdateOnePointProperty(Entity: TEzEntity);
  var
    tmppt: TEzPoint;
  begin
    tmppt:= Entity.Points[0];
    bp:= Inspector1.GetPropertyByName('X');
    if bp.modified then
      tmppt.X:= bp.ValFloat;

    bp:= Inspector1.GetPropertyByName('Y');
    if bp.modified then
      tmppt.Y:= bp.ValFloat;
    if not EqualPoint2d(Entity.Points[0], tmppt) then
      Entity.Points[0]:= tmppt;
  end;

  procedure UpdateEntityProperties( Layer: TEzBaseLayer; Recno: Integer; IsBase: Boolean );
  var
    Entity: TEzEntity;
    tmpmod: boolean;
    tmppt: TEzPoint;
  begin
    Entity:= Layer.LoadEntityWithRecno( Recno );
    if Entity = Nil then Exit;
    if IsBase then
      BaseEntityID := Entity.EntityID
    else if Entity.EntityID <> BaseEntityID then
    begin
      Entity.Free;
      Exit;
    end;
    try
      Entity.BeginUpdate;
      case Entity.EntityID of
        idNone:
          begin
            // nothing to update
          end;
        idPoint:
          begin
            bp:= Inspector1.PropList[0];
            if bp.modified then
              TEzPointEntity(Entity).Color:= bp.ValInteger;

            UpdateOnePointProperty(Entity);
          end;
        idPlace:
          begin
            bp:= Inspector1.PropList[0];
            if bp.modified then
              TEzPlace(Entity).Symboltool.Index:= bp.ValInteger;

            bp:= Inspector1.PropList[1];
            if bp.modified then
              TEzPlace(Entity).Symboltool.Rotangle:= bp.ValFloat;

            bp:= Inspector1.PropList[2];
            if bp.modified then
              TEzPlace(Entity).Symboltool.Height:= bp.ValFloat;

            bp:= Inspector1.PropList[3];
            if bp.modified then
              TEzPlace(Entity).Text:= bp.ValString;

            UpdateOnePointProperty(Entity);

          end;
        idPolyline, idNodeLink:
          begin
            UpdateOpenedProperties(TEzOpenedEntity(Entity).Pentool);
            UpdatePointsProperty(Entity);

            if Entity.EntityID = idNodeLink then
            begin
              bp:= Inspector1.GetPropertyByName('Travel Restriction');
              if bp.modified then
              begin
                TEzNodeLink( Entity ).Restriction:= TEzTravelRestriction( bp.ValInteger );
              end;
            end;
          end;
        idPolygon:
          begin
            UpdateClosedProperties(Entity);
            UpdatePointsProperty(Entity);
          end;
        idRectangle:
          begin
            UpdateClosedProperties(Entity);
            bp:= Inspector1.PropList[6];
            if bp.modified then
              TEzRectangle(Entity).Rotangle:= bp.ValFloat;

            UpdateRectanglePointsProperty(Entity);

          end;
        idArc:
          begin
            UpdateOpenedProperties(TEzOpenedEntity(Entity).Pentool);

            bp:= Inspector1.PropList[3];
            if bp.modified then
              TEzArc(Entity).PointsInCurve:= bp.ValInteger;

            tmppt:= Entity.Points[0];
            bp:= Inspector1.GetPropertyByName('X1');
            if bp.modified then
              tmppt.X:= bp.ValFloat;

            bp:= Inspector1.GetPropertyByName('Y1');
            if bp.modified then
              tmppt.Y:= bp.ValFloat;
            if not EqualPoint2d(Entity.Points[0], tmppt) then
              Entity.Points[0]:= tmppt;

            tmppt:= Entity.Points[1];
            bp:= Inspector1.GetPropertyByName('X2');
            if bp.modified then
              tmppt.X:= bp.ValFloat;

            bp:= Inspector1.GetPropertyByName('Y2');
            if bp.modified then
              tmppt.Y:= bp.ValFloat;
            if not EqualPoint2d(Entity.Points[1], tmppt) then
              Entity.Points[1]:= tmppt;

            tmppt:= Entity.Points[2];
            bp:= Inspector1.GetPropertyByName('X3');
            if bp.modified then
              tmppt.X:= bp.ValFloat;

            bp:= Inspector1.GetPropertyByName('Y3');
            if bp.modified then
              tmppt.Y:= bp.ValFloat;
            if not EqualPoint2d(Entity.Points[2], tmppt) then
              Entity.Points[2]:= tmppt;
          end;
        idEllipse:
          begin
            UpdateClosedProperties(Entity);

            bp:= Inspector1.PropList[6];
            if bp.modified then
              TEzEllipse(Entity).PointsInCurve:= bp.ValInteger;

            bp:= Inspector1.PropList[7];
            if bp.modified then
              TEzEllipse(Entity).Rotangle:= bp.ValFloat;

            UpdateRectanglePointsProperty(Entity);
          end;
        idPictureRef:
          begin
            bp:= Inspector1.PropList[0];
            if bp.modified then
              TEzPictureRef(Entity).AlphaChannel:= bp.ValInteger;

            bp:= Inspector1.PropList[1];
            if bp.modified then
              TEzPictureRef(Entity).FileName:= ExtractFileName(bp.ValString);

            UpdateRectanglePointsProperty(Entity);
          end;
        idPersistBitmap:
          begin
            bp:= Inspector1.PropList[0];
            if bp.modified then
              TEzPersistBitmap(Entity).Transparent:= bp.ValBoolean;

            bp:= Inspector1.PropList[1];
            if bp.modified then
              TEzPersistBitmap(Entity).Bitmap.Assign(TEzBitmapProperty(bp).Bitmap);

            UpdateRectanglePointsProperty(Entity);

          end;
        idBandsBitmap:
          begin
            bp:= Inspector1.PropList[0];
            if bp.modified then
              TEzBandsBitmap(Entity).AlphaChannel:= bp.ValInteger;

            bp:= Inspector1.PropList[1];
            if bp.modified then
              TEzBandsBitmap(Entity).FileName:= ExtractFileName(bp.ValString);

            UpdateRectanglePointsProperty(Entity);
          end;
        idSpline, idSplineText:
          begin
            if (Entity.EntityID = idSpline) or
              ((Entity.EntityID = idSplineText) and TEzSplineText(Entity).ShowSpline) then
            begin
              UpdateOpenedProperties(TEzOpenedEntity(Entity).Pentool);

              bp:= Inspector1.PropList[3];
              if bp.modified then
                TEzSpline(Entity).PointsInCurve:= bp.ValInteger;

              bp:= Inspector1.PropList[4];
              if bp.modified then
                TEzSpline(Entity).Order:= bp.ValInteger;

            end;

            UpdatePointsProperty(Entity);

            if Entity.EntityID = idSplineText then
            begin
              bp:= Inspector1.GetPropertyByName('Text');
              if bp.modified then
                TEzSplineText(Entity).Text:=bp.ValString;

              bp:= Inspector1.GetPropertyByName('FittedToLen');
              if bp.modified then
                TEzSplineText(Entity).Fitted:=bp.ValBoolean;

              bp:= Inspector1.GetPropertyByName('InterCharSpacing');
              if bp.modified then
                TEzSplineText(Entity).CharSpacing:=bp.ValFloat;

              bp:= Inspector1.GetPropertyByName('FontName');
              if bp.modified then
                TEzSplineText(Entity).Fonttool.Name:=bp.ValString;

              bp:= Inspector1.GetPropertyByName('FontHeight');
              if bp.modified then
                TEzSplineText(Entity).Fonttool.Height:=bp.ValFloat;

              bp:= Inspector1.GetPropertyByName('FontColor');
              if bp.modified then
                TEzSplineText(Entity).Fonttool.Color:=bp.ValInteger;

              if TEzSplineText(Entity).UseTrueType then
              begin
                bp:= Inspector1.GetPropertyByname('FontStyle');
                if bp.modified then
                begin
                  FontStyles:= [];
                  with TEzSetProperty(bp) do
                  begin
                    if Defined[0] then Include(FontStyles,fsbold);
                    if Defined[1] then Include(FontStyles,fsitalic);
                    if Defined[2] then Include(FontStyles,fsunderline);
                    if Defined[3] then Include(FontStyles,fsstrikeout);
                  end;
                  TEzSplineText(Entity).Fonttool.Style:=FontStyles;
                end;
              end;
              bp:= Inspector1.GetPropertyByName('ShowSpline');
              if bp.modified then
                TEzSplineText(Entity).ShowSpline:= bp.ValBoolean;

            end;

          end;
        idTable:
          begin
            UpdateClosedProperties(Entity);

            TableOptions:= TEzTableEntity(Entity).Options;

            bp:= Inspector1.GetPropertyByName('VerticalLine');
            tmpmod:= false;
            if bp.modified then
            begin
              if bp.ValBoolean then
                Include(TableOptions, ezgoVertLine)
              else
                Exclude(TableOptions, ezgoVertLine);
              tmpmod:= true;
            end;

            bp:= Inspector1.GetPropertyByName('HorizontalLine');
            if bp.modified then
            begin
              if bp.ValBoolean then
                Include(TableOptions, ezgoHorzLine)
              else
                Exclude(TableOptions, ezgoHorzLine);
              tmpmod:= true;
            end;

            if tmpmod then
              TEzTableEntity(Entity).Options:= TableOptions;

            bp:= Inspector1.GetPropertyByName('RowHeight');
            if bp.modified then
              TEzTableEntity(Entity).RowHeight:=bp.ValFloat;

            bp:= Inspector1.GetPropertyByName('RowCount');
            if bp.modified then
              TEzTableEntity(Entity).RowCount:= bp.ValInteger;

            tempBorderStyle:= TEzTableEntity(Entity).GridStyle;

            bp:= Inspector1.GetPropertyByName('GridVisible');
            tmpmod:=false;
            if bp.modified then
            begin
              tempBorderStyle.Visible:= bp.ValBoolean;
              tmpmod:=true;
            end;

            {bp:= Inspector1.GetPropertyByName('GridStyle');
            if bp.modified then
            begin
              tempBorderStyle.Style:= bp.ValInteger;
              tmpmod:=true;
            end; }

            bp:= Inspector1.GetPropertyByName('GridColor');
            if bp.modified then
            begin
              tempBorderStyle.Color:= bp.ValInteger;
              tmpmod:=true;
            end;

            bp:= Inspector1.GetPropertyByName('GridWidth');
            if bp.modified then
            begin
              tempBorderStyle.Width:= bp.ValFloat;
              tmpmod:=true;
            end;

            if tmpmod then
              TEzTableEntity(Entity).GridStyle:= tempBorderStyle;

            bp:= Inspector1.GetPropertyByName('BorderWidth');
            if bp.modified then
              TEzTableEntity(Entity).BorderWidth:=bp.ValFloat;

            bp:= Inspector1.GetPropertyByName('LoweredColor');
            if bp.modified then
              TEzTableEntity(Entity).LoweredColor:=bp.ValInteger;

            { ahora las columnas }
            bp:= Inspector1.GetPropertyByName('TableColumns');
            with TEzTableColumnsProperty(bp) do
            begin
              TEzTableEntity(Entity).Columns.Assign( Columns );
            end;

            UpdateRectanglePointsProperty(Entity);
          end;
        idGroup:
          begin
            // not yet editable
          end;
        idTrueTypeText:
          begin
            UpdateClosedProperties(Entity);

            bp:= Inspector1.PropList[6];
            if bp.modified then
              TEzTrueTypeText(Entity).Text:=bp.ValString;

            bp:= Inspector1.PropList[7];
            if bp.modified then
              TEzTrueTypeText(Entity).Fonttool.Name:=bp.ValString;

            bp:= Inspector1.PropList[8];
            if bp.modified then
              TEzTrueTypeText(Entity).Alignment:=TAlignment(bp.ValInteger);

            bp:= Inspector1.PropList[9];
            if bp.modified then
              TEzTrueTypeText(Entity).Fonttool.Angle:=bp.ValFloat;

            bp:= Inspector1.PropList[10];
            if bp.modified then
              TEzTrueTypeText(Entity).Fonttool.Height:=bp.ValFloat;

            bp:= Inspector1.PropList[11];
            if bp.modified then
              TEzTrueTypeText(Entity).Fonttool.Color:=bp.ValInteger;

            bp:= Inspector1.GetPropertyByname('FontStyle');
            if bp.modified then
            begin
              FontStyles:= [];
              with TEzSetProperty(bp) do
              begin
                if Defined[0] then Include(FontStyles,fsbold);
                if Defined[1] then Include(FontStyles,fsitalic);
                if Defined[2] then Include(FontStyles,fsunderline);
                if Defined[3] then Include(FontStyles,fsstrikeout);
              end;
              TEzTrueTypeText(Entity).Fonttool.Style:= FontStyles;
            end;

            UpdateOnePointProperty(Entity);

          end;
        idJustifVectText:
          begin
            UpdateClosedProperties(Entity);

            bp:= Inspector1.PropList[6];
            if bp.modified then
              TEzJustifVectorText(Entity).Text:=bp.ValString;

            bp:= Inspector1.PropList[7];
            if bp.modified then
              TEzJustifVectorText(Entity).Height:=bp.ValFloat;

            bp:= Inspector1.PropList[8];
            if bp.modified then
              TEzJustifVectorText(Entity).Angle:= bp.ValFloat;

            bp:= Inspector1.PropList[9];
            if bp.modified then
              TEzJustifVectorText(Entity).FontColor:= bp.ValInteger;

            bp:= Inspector1.PropList[10];
            if bp.modified then
              TEzJustifVectorText(Entity).FontName:= bp.ValString;

            bp:= Inspector1.PropList[11];
            if bp.modified then
              TEzJustifVectorText(Entity).HorzAlignment:= TEzHorzAlignment(bp.ValInteger);

            bp:= Inspector1.PropList[12];
            if bp.modified then
              TEzJustifVectorText(Entity).VertAlignment:=TEzVertAlignment(bp.ValInteger);

            bp:= Inspector1.PropList[13];
            if bp.modified then
              TEzJustifVectorText(Entity).InterCharSpacing:=bp.ValFloat;

            bp:= Inspector1.PropList[14];
            if bp.modified then
              TEzJustifVectorText(Entity).InterLineSpacing:=bp.ValFloat;

            UpdateRectanglePointsProperty(Entity);

          end;
        idFittedVectText:
          begin
            UpdateClosedProperties(Entity);

            bp:= Inspector1.PropList[6];
            if bp.modified then
              TEzFittedVectorText(Entity).Text:=bp.ValString;

            UpdateOnePointProperty(Entity);

            bp:= Inspector1.PropList[9];
            if bp.modified then
              TEzFittedVectorText(Entity).Height:=bp.ValFloat;

            bp:= Inspector1.PropList[10];
            if bp.modified then
              TEzFittedVectorText(Entity).Width:=bp.ValFloat;

            bp:= Inspector1.PropList[11];
            if bp.modified then
              TEzFittedVectorText(Entity).Angle:=bp.ValFloat;

            bp:= Inspector1.PropList[12];
            if bp.modified then
              TEzFittedVectorText(Entity).FontColor:=TColor(bp.ValInteger);

            bp:= Inspector1.PropList[13];
            if bp.modified then
              TEzFittedVectorText(Entity).FontName:=bp.ValString ;

            bp:= Inspector1.PropList[14];
            if bp.modified then
              TEzFittedVectorText(Entity).InterCharSpacing:=bp.ValFloat;

            bp:= Inspector1.PropList[15];
            if bp.modified then
              TEzFittedVectorText(Entity).InterLineSpacing:=bp.ValFloat;

            bp:= Inspector1.PropList[16];
            if bp.modified then
              TEzFittedVectorText(Entity).TextBorderStyle:=TEzTextBorderStyle(bp.ValInteger);

            tempx:= TEzFittedVectorText(Entity).Pivot.x;
            tempy:= TEzFittedVectorText(Entity).Pivot.y;

            bp:= Inspector1.PropList[17];
            tmpmod:=false;
            if bp.modified then
            begin
              tempx:=bp.ValFloat;
              tmpmod:=true;
            end;

            bp:= Inspector1.PropList[18];
            if bp.modified then
            begin
              tempy:=bp.ValFloat;
              tmpmod:=true;
            end;

            if tmpmod then
              TEzFittedVectorText(Entity).Pivot:=Point2d(tempx,tempy);

            bp:= Inspector1.PropList[19];
            if bp.modified then
              TEzFittedVectorText(Entity).HideShadow:=bp.ValBoolean;

          end;
        idDimHorizontal:
          begin
            UpdateOpenedProperties(TEzDimHorizontal(Entity).Pentool);

            bp:= Inspector1.PropList[3];
            if bp.modified then
              TEzDimHorizontal(Entity).TextLineY:=bp.ValFloat;

            bp:= Inspector1.PropList[4];
            if bp.modified then
              TEzDimHorizontal(Entity).TextHeight:=bp.ValFloat;

            bp:= Inspector1.PropList[5];
            if bp.modified then
              TEzDimHorizontal(Entity).NumDecimals:=bp.ValInteger;

            bp:= Inspector1.PropList[6];
            if bp.modified then
              TEzDimHorizontal(Entity).FontName:=bp.ValString;

            tempx:= TEzDimHorizontal(Entity).BaseLineFrom.x;
            tempy:= TEzDimHorizontal(Entity).BaseLineFrom.y;

            bp:= Inspector1.PropList[7];
            tmpmod:=false;
            if bp.modified then
            begin
              tempX:=bp.ValFloat;
              tmpmod:=true;
            end;

            bp:= Inspector1.PropList[8];
            if bp.modified then
            begin
              tempy:=bp.ValFloat;
              tmpmod:=true;
            end;

            if tmpmod then
              TEzDimHorizontal(Entity).BaseLineFrom:=Point2d(tempx,tempy);

            tempx:= TEzDimHorizontal(Entity).BaseLineTo.x;
            tempy:= TEzDimHorizontal(Entity).BaseLineTo.y;

            bp:= Inspector1.PropList[9];
            tmpmod:=false;
            if bp.modified then
            begin
              tempx:=bp.ValFloat ;
              tmpmod:=true;
            end;

            bp:= Inspector1.PropList[10];
            if bp.modified then
            begin
              tempy:=bp.ValFloat ;
              tmpmod:=true;
            end;

            if tmpmod then
              TEzDimHorizontal(Entity).BaseLineTo:=Point2d(tempx,tempy);

            tempx:= TEzDimHorizontal(Entity).TextBasePoint.x;
            tempy:= TEzDimHorizontal(Entity).TextBasePoint.y;

            bp:= Inspector1.PropList[11];
            tmpmod:=false;
            if bp.modified then
            begin
              tempx:=bp.ValFloat;
              tmpmod:=true;
            end;

            bp:= Inspector1.PropList[12];
            if bp.modified then
            begin
              tempy:=bp.ValFloat;
              tmpmod:=true;
            end;

            if tmpmod then
              TEzDimHorizontal(Entity).TextBasePoint:=Point2d(tempx,tempy);

          end;
        idDimVertical:
          begin
            UpdateOpenedProperties(TEzDimVertical(Entity).Pentool);

            bp:= Inspector1.PropList[3];
            if bp.modified then
              TEzDimVertical(Entity).TextLineX:=bp.ValFloat;

            bp:= Inspector1.PropList[4];
            if bp.modified then
              TEzDimVertical(Entity).TextHeight:=bp.ValFloat;

            bp:= Inspector1.PropList[5];
            if bp.modified then
              TEzDimVertical(Entity).NumDecimals:=bp.ValInteger;

            bp:= Inspector1.PropList[6];
            if bp.modified then
              TEzDimVertical(Entity).FontName:=bp.ValString;

            tempx:= TEzDimVertical(Entity).BaseLineFrom.x;
            tempy:= TEzDimVertical(Entity).BaseLineFrom.y;

            bp:= Inspector1.PropList[7];
            tmpmod:=false;
            if bp.modified then
            begin
              tempx:=bp.ValFloat;
              tmpmod:=true;
            end;

            bp:= Inspector1.PropList[8];
            if bp.modified then
            begin
              tempy:=bp.ValFloat;
              tmpmod:=true;
            end;

            if tmpmod then
              TEzDimVertical(Entity).BaseLineFrom:=Point2d(tempx,tempy);

            tempx:= TEzDimVertical(Entity).BaseLineTo.x;
            tempy:= TEzDimVertical(Entity).BaseLineTo.y;

            bp:= Inspector1.PropList[9];
            tmpmod:=false;
            if bp.modified then
            begin
              tempx:=bp.ValFloat;
              tmpmod:=true;
            end;

            bp:= Inspector1.PropList[10];
            if bp.modified then
            begin
              tempy:=bp.ValFloat;
              tmpmod:=true;
            end;

            if tmpmod then
              TEzDimVertical(Entity).BaseLineTo:=Point2d(tempx,tempy);

            tempx:= TEzDimVertical(Entity).TextBasePoint.x;
            tempy:= TEzDimVertical(Entity).TextBasePoint.y;

            bp:= Inspector1.PropList[11];
            tmpmod:=false;
            if bp.modified then
            begin
              tempx:= bp.ValFloat;
              tmpmod:=true;
            end;

            bp:= Inspector1.PropList[12];
            if bp.modified then
            begin
              tempy:= bp.ValFloat;
              tmpmod:=true;
            end;

            if tmpmod then
              TEzDimVertical(Entity).TextBasePoint:=Point2d(tempx,tempY);

          end;
        idDimParallel:
          begin
            UpdateOpenedProperties(TEzDimParallel(Entity).Pentool);

            bp:= Inspector1.PropList[3];
            if bp.modified then
              TEzDimParallel(Entity).TextLineDistanceApart:=bp.ValFloat;

            bp:= Inspector1.PropList[4];
            if bp.modified then
              TEzDimParallel(Entity).TextHeight:=bp.ValFloat;

            bp:= Inspector1.PropList[5];
            if bp.modified then
              TEzDimParallel(Entity).NumDecimals:=bp.ValInteger;

            bp:= Inspector1.PropList[6];
            if bp.modified then
              TEzDimParallel(Entity).FontName:=bp.ValString;

            tempx:= TEzDimParallel(Entity).BaseLineFrom.x;
            tempy:= TEzDimParallel(Entity).BaseLineFrom.y;

            bp:= Inspector1.PropList[7];
            tmpmod:=false;
            if bp.modified then
            begin
              tempx:=bp.ValFloat;
              tmpmod:=true;
            end;

            bp:= Inspector1.PropList[8];
            if bp.modified then
            begin
              tempy:=bp.ValFloat;
              tmpmod:=true;
            end;

            if tmpmod then
              TEzDimParallel(Entity).BaseLineFrom:=Point2d(tempx,tempy);

            tempx:= TEzDimParallel(Entity).BaseLineTo.x;
            tempy:= TEzDimParallel(Entity).BaseLineTo.y;

            bp:= Inspector1.PropList[9];
            tmpmod:=false;
            if bp.modified then
            begin
              tempx:=bp.ValFloat;
              tmpmod:=true;
            end;

            bp:= Inspector1.PropList[10];
            if bp.modified then
            begin
              tempy:=bp.ValFloat;
              tmpmod:=true;
            end;

            if tmpmod then
              TEzDimParallel(Entity).BaseLineTo:=Point2d(tempx,tempy);

            tempx:= TEzDimParallel(Entity).TextBasePoint.x;
            tempy:= TEzDimParallel(Entity).TextBasePoint.y;

            bp:= Inspector1.PropList[11];
            tmpmod:=false;
            if bp.modified then
            begin
              tempx:= bp.ValFloat;
              tmpmod:=true;
            end;

            bp:= Inspector1.PropList[12];
            if bp.modified then
            begin
              tempy:=bp.ValFloat;
              tmpmod:=true;
            end;

            if tmpmod then
              TEzDimParallel(Entity).TextBasePoint:=Point2d(tempx,tempy);
          end;
        idRtfText:
          begin
            // not edited yet
          end;
        idBlockInsert:
          begin
            bp:= Inspector1.PropList[0];
            if bp.modified then
              TEzBlockInsert(Entity).BlockName:=ExtractFileName(bp.ValString);

            bp:= Inspector1.PropList[1];
            if bp.modified then
              TEzBlockInsert(Entity).Rotangle:=bp.ValFloat;

            bp:= Inspector1.PropList[2];
            if bp.modified then
              TEzBlockInsert(Entity).ScaleX:=bp.ValFloat;

            bp:= Inspector1.PropList[3];
            if bp.modified then
              TEzBlockInsert(Entity).ScaleY:=bp.ValFloat;

            bp:= Inspector1.PropList[4];
            if bp.modified then
              TEzBlockInsert(Entity).Text:=bp.ValString;

            UpdateOnePointProperty(Entity);

          end;
        idPreview:
          begin
            UpdateClosedProperties(Entity);

            bp:= Inspector1.PropList[6];
            if bp.modified then
              TEzPreviewEntity(Entity).PlottedUnits:=bp.ValFloat;

            bp:= Inspector1.PropList[7];
            if bp.modified then
              TEzPreviewEntity(Entity).DrawingUnits:=bp.ValFloat;

            bp:= Inspector1.PropList[8];
            if bp.modified then
              TEzPreviewEntity(Entity).PaperUnits:=TEzScaleUnits(bp.ValInteger);

            bp:= Inspector1.PropList[9];
            if bp.modified then
              TEzPreviewEntity(Entity).PrintFrame:=bp.ValBoolean;

            bp:= Inspector1.PropList[10];
            if bp.modified then
              TEzPreviewEntity(Entity).Presentation:=TEzPreviewPresentation(bp.ValInteger);

            tempr:= TEzPreviewEntity(Entity).ProposedPrintArea;

            bp:= Inspector1.PropList[11];
            tmpmod:=false;
            if bp.modified then
            begin
              tempr.x1:= bp.ValFloat;
              tmpmod:=true;
            end;

            bp:= Inspector1.PropList[12];
            if bp.modified then
            begin
              tempr.y1:=bp.ValFloat;
              tmpmod:=true;
            end;

            bp:= Inspector1.PropList[13];
            if bp.modified then
            begin
              tempr.x2:=bp.ValFloat;
              tmpmod:=true;
            end;

            bp:= Inspector1.PropList[14];
            if bp.modified then
            begin
              tempr.y2:=bp.ValFloat;
              tmpmod:=true;
            end;

            if tmpmod then
              TEzPreviewEntity(Entity).ProposedPrintArea:= tempr;

            UpdateRectanglePointsProperty(Entity);

          end;
      end;
      Entity.EndUpdate;
      Layer.UpdateEntity( Recno, Entity );
      MinBound( bbox.Emin, Entity.FBox.Emin );
      MaxBound( bbox.Emax, Entity.FBox.Emax );

      Inspector1.SetModifiedStatus(False);
      Inspector1.Invalidate;
    finally
      Entity.Free;
    end;
  end;

begin
  if FLayer = Nil then Exit;
  bbox:= INVALID_EXTENSION;
  FCmdLine.ActiveDrawBox.Undo.BeginUndo( uaUnTransform );
  Try
    FCmdLine.ActiveDrawBox.Undo.AddUndo( FLayer, FRecno, uaUnTransform );
    UpdateEntityProperties( FLayer, FRecno, True );
    with FCmdLine.ActiveDrawBox do
    begin
      if Selection.Count > 0 then
      begin
        for I:= 0 to Selection.Count-1 do
        begin
          SelLayer:= Selection[I];
          for J:= 0 to SelLayer.SelList.Count-1 do
          Begin
            Undo.AddUndo( SelLayer.Layer, SelLayer.SelList[J], uaUnTransform );
            UpdateEntityProperties( SelLayer.Layer, SelLayer.SelList[J], False );
          End;
        end;
      end;
    end;
    Inspector1.SetModifiedStatus(False);
    with FCmdLine.ActiveDrawBox do
    begin
      { this is for to update the entity on the viewport }
      //TEditGraphicPropsAction(FAction).HiliteClickedEntity(FLayer,FRecno);
      RePaintRect(bbox);
      Refresh;
    end;
  Finally
    FCmdLine.ActiveDrawBox.Undo.EndUndo;
  End;
end;

procedure TfrmInspector.Inspector1PropertyChange(Sender: TObject;
  const PropertyName: String);
var
  bp1, bp2: TEzBaseProperty;
begin
  if AnsiCompareText(PropertyName, 'RowCount') = 0 then
  begin
    bp1:= Inspector1.GetPropertyByName('TableColumns');
    if bp1=nil then exit;
    bp2:= Inspector1.GetPropertyByName('RowCount');
    TEzTableColumnsProperty(bp1).RowCount:= bp2.ValInteger;
  end;
end;

procedure TfrmInspector.FormResize(Sender: TObject);
begin
  Inspector1.AdjustColWidths;
end;

procedure TfrmInspector.Launcher1Finished(Sender: TObject);
begin
  Self.Release;  { do not use Close. Close causes access violation error }
end;

procedure TfrmInspector.Inspector1PropertyHint(Sender: TObject;
  const PropertyName: String);
var
  bp: TEzBaseproperty;
begin
  If Length(PropertyName) = 0 then
  begin
    LblProperty.Caption:= '';
    LblDesc.Caption:= '';
  end else
  begin
    bp:= Inspector1.GetPropertyByName( PropertyName );
    LblProperty.Caption:= PropertyName;
    LblDesc.Caption:= bp.Hint;
  end;
end;

procedure TfrmInspector.Launcher1TrackedEntityClick(Sender: TObject;
  const TrackID: String; Button: TMouseButton; Shift: TShiftState; X,
  Y: Integer; const WX, WY: Double; Layer: TEzBaseLayer; Recno: Integer;
  var Accept: Boolean);
begin
  if Layer <> Nil then
    ShowClickedEntity( Layer, Recno )
  else
  begin
    Inspector1.ClearPropertyList;
    Inspector1.Visible:= false;
    Panel2.Visible:= false;
  end;
end;

end.
