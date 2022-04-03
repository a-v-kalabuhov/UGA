unit fDBInspector;

interface

uses Windows, SysUtils, Classes, Graphics, Forms, Controls, StdCtrls,
  Buttons, ExtCtrls, Grids, EzInspect, EzBasicCtrls, EzBaseGis;

type
  TfrmDBInspector = class(TForm)
    Inspector1: TEzInspector;
    Panel1: TPanel;
    Button1: TButton;
    Button2: TButton;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure Button1Click(Sender: TObject);
  private
    { Private declarations }
    FDrawBox: TEzDrawBox;
  public
    { Public declarations }
    function Enter( DrawBox: TEzDrawBox ): Word;
  end;

implementation

{$R *.DFM}

uses
  EzSystem, ezbase, fMain;

{ TfrmDBInspector }

function TfrmDBInspector.Enter(DrawBox: TEzDrawBox): Word;
var
  J: TEzCoordsUnits;
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

  FDrawBox:= Drawbox;

  bp:= TEzDummyProperty.Create('General');
  bp.readonly:=true;
  Inspector1.AddProperty( bp );
  bp.Modified:=true;    { causes to show on bold}

    bp:= TEzIntegerProperty.Create('BlinkCount');
    bp.ValInteger:= FDrawBox.BlinkCount;
    bp.Hint:='No. of blinks for BlinkEntity method';
    Inspector1.AddProperty( bp );

    bp:= TEzIntegerProperty.Create('BlinkRate');
    bp.ValInteger:= FDrawBox.BlinkRate;
    bp.Hint:='No. milliseconds for every blink';
    Inspector1.AddProperty( bp );

    bp:= TEzColorProperty.Create('Color');
    bp.ValInteger:= FDrawBox.Color;
    bp.Hint:='Viewport color';
    Inspector1.AddProperty( bp );

    bp:= TEzIntegerProperty.Create('DelayShowHint');
    bp.ValInteger:= FDrawBox.DelayShowHint;
    bp.Hint:='No. of milliseconds between show hint';
    Inspector1.AddProperty( bp );

    bp:= TEzIntegerProperty.Create('DropRepeat');
    bp.ValInteger:= FDrawBox.DropRepeat;
    bp.Hint:='No. of copies for DROP command';
    Inspector1.AddProperty( bp );

    bp:= TEzBooleanProperty.Create('FlatScrollBar');
    bp.ValBoolean:= FDrawBox.FlatScrollBar;
    bp.Hint:='Show flat scroll bar';
    Inspector1.AddProperty( bp );

    bp:= TEzIntegerProperty.Create('NumDecimals');
    bp.ValInteger:= FDrawBox.NumDecimals;
    bp.Hint:='Define number of decimals shown';
    Inspector1.AddProperty( bp );

    bp:= TEzBooleanProperty.Create('PartialSelect');
    bp.ValBoolean:= FDrawBox.PartialSelect;
    bp.Hint:='Entities must be fully or partially inside when select in polygon';
    Inspector1.AddProperty( bp );

    bp:= TEzSetProperty.Create('NoPickFilter');
    bp.Hint:= 'Define which entities cannot be selected/clicked';
    with TEzSetProperty(bp) do
    begin
      Strings.BeginUpdate;
      Strings.add('idNone');
      Strings.add('idPoint');
      Strings.add('idPlace');
      Strings.add('idPolyline');
      Strings.add('idPolygon');
      Strings.add('idRectangle');
      Strings.add('idArc');
      Strings.add('idEllipse');
      Strings.add('idPictureRef');
      Strings.add('idPersistBitmap');
      Strings.add('idBandsBitmap');
      Strings.add('idBandsTiff');
      Strings.add('idSpline');
      Strings.add('idTable');
      Strings.add('idGroup');
      Strings.add('idTrueTypeText');
      Strings.add('idJustifVectText');
      Strings.add('idFittedVectText');
      Strings.add('idDimHorizontal');
      Strings.add('idDimVertical');
      Strings.add('idDimParallel');
      Strings.add('idRtfText');
      Strings.add('idBlockInsert');
      Strings.add('idSplineText');
      Strings.add('idCustomPicture');
      Strings.add('idPreview');
      Strings.EndUpdate;

      Defined[0] := idNone in FDrawBox.NoPickFilter;
      Defined[1] := idPoint in FDrawBox.NoPickFilter;
      Defined[2] := idPlace in FDrawBox.NoPickFilter;
      Defined[3] := idPolyline in FDrawBox.NoPickFilter;
      Defined[4] := idPolygon in FDrawBox.NoPickFilter;
      Defined[5] := idRectangle in FDrawBox.NoPickFilter;
      Defined[6] := idArc in FDrawBox.NoPickFilter;
      Defined[7] := idEllipse in FDrawBox.NoPickFilter;
      Defined[8] := idPictureRef in FDrawBox.NoPickFilter;
      Defined[9] := idPersistBitmap in FDrawBox.NoPickFilter;
      Defined[10] :=idBandsBitmap in FDrawBox.NoPickFilter;
      Defined[11] :=idSpline in FDrawBox.NoPickFilter;
      Defined[12] :=idTable in FDrawBox.NoPickFilter;
      Defined[13] :=idGroup in FDrawBox.NoPickFilter;
      Defined[14] :=idTrueTypeText in FDrawBox.NoPickFilter;
      Defined[15] :=idJustifVectText in FDrawBox.NoPickFilter;
      Defined[16] :=idFittedVectText in FDrawBox.NoPickFilter;
      Defined[17] :=idDimHorizontal in FDrawBox.NoPickFilter;
      Defined[18] :=idDimVertical in FDrawBox.NoPickFilter;
      Defined[19] :=idDimParallel in FDrawBox.NoPickFilter;
      Defined[20] :=idRtfText in FDrawBox.NoPickFilter;
      Defined[21] :=idBlockInsert in FDrawBox.NoPickFilter;
      Defined[22] :=idSplineText in FDrawBox.NoPickFilter;
      Defined[23] :=idCustomPicture in FDrawBox.NoPickFilter;
      Defined[24] :=idPreview in FDrawBox.NoPickFilter;
    end;
    Inspector1.AddProperty( bp );

    bp:= TEzColorProperty.Create('RubberPenColor');
    bp.ValInteger:= FDrawBox.RubberPen.Color;
    bp.Hint:='Defines the rubber pen color';
    Inspector1.AddProperty( bp );

    bp:= TEzBooleanProperty.Create('ShowLayerExtents');
    bp.ValBoolean:= FDrawBox.ShowLayerExtents;
    bp.Hint:='Show layer extents ?';
    Inspector1.AddProperty( bp );

    bp:= TEzBooleanProperty.Create('ShowMapExtents');
    bp.ValBoolean:= FDrawBox.ShowMapExtents;
    bp.Hint:='Show map extents ?';
    Inspector1.AddProperty( bp );

    bp:= TEzBooleanProperty.Create('SnapToGuideLines');
    bp.ValBoolean:= FDrawBox.SnapToGuideLines;
    bp.Hint:='Snap to guidelines ?';
    Inspector1.AddProperty( bp );

    bp:= TEzFloatProperty.Create('SnapToGuidelinesDist');
    bp.ValFloat:= FDrawbox.SnapToGuidelinesDist;
    bp.Hint:='Defines the minimum distance to snap to a guideline';
    Inspector1.AddProperty( bp );

    bp:= TEzBooleanProperty.Create('StackedSelect');
    bp.ValBoolean:= FDrawBox.StackedSelect;
    bp.Hint:='Entities below top entities can be selected ?';
    Inspector1.AddProperty( bp );

    bp:= TEzSymbolProperty.Create('SymbolMarker');
    bp.ValInteger:= FDrawBox.SymbolMarker;
    bp.Hint:= 'Symbol used when adding markers';
    Inspector1.AddProperty( bp );


  bp:= TEzDummyProperty.Create('GridInfo');
  bp.readonly:=true;
  Inspector1.AddProperty( bp );
  bp.Modified:=true;    { causes to show on bold}

    bp:= TEzBooleanProperty.Create('GridInfo.DrawAsCross');
    bp.ValBoolean:= FDrawBox.GridInfo.DrawAsCross;
    bp.Hint:='Draw grid as cross instead of points';
    Inspector1.AddProperty( bp );

    bp:= TEzFloatProperty.Create('GridInfo.Grid.X');
    bp.ValFloat:= FDrawBox.GridInfo.Grid.X;
    bp.Hint:='Separation of grid X axxis';
    Inspector1.AddProperty( bp );

    bp:= TEzFloatProperty.Create('GridInfo.Grid.Y');
    bp.ValFloat:= FDrawBox.GridInfo.Grid.Y;
    bp.Hint:='Separation of grid Y axxis';
    Inspector1.AddProperty( bp );

    bp:= TEzColorProperty.Create('GridInfo.GridColor');
    bp.ValInteger:= FDrawBox.GridInfo.GridColor;
    bp.Hint:='The grid color';
    Inspector1.AddProperty( bp );

    bp:= TEzFloatProperty.Create('GridInfo.GridOffset.X');
    bp.ValFloat:= FDrawBox.GridInfo.GridOffset.X;
    bp.Hint:='The offset of grid from (0,0) for X axxis';
    Inspector1.AddProperty( bp );

    bp:= TEzFloatProperty.Create('GridInfo.GridOffset.Y');
    bp.ValFloat:= FDrawBox.GridInfo.GridOffset.Y;
    bp.Hint:='The offset of grid from (0,0) for Y axxis';
    Inspector1.AddProperty( bp );

    bp:= TEzFloatProperty.Create('GridInfo.GridSnap.X');
    bp.ValFloat:= FDrawBox.GridInfo.GridSnap.X;
    bp.Hint:='Snap to grid distance X axxis';
    Inspector1.AddProperty( bp );

    bp:= TEzFloatProperty.Create('GridInfo.GridSnap.Y');
    bp.ValFloat:= FDrawBox.GridInfo.GridSnap.Y;
    bp.Hint:='Snap to grid distance Y axxis';
    Inspector1.AddProperty( bp );

    bp:= TEzBooleanProperty.Create('GridInfo.ShowGrid');
    bp.ValBoolean:= FDrawBox.GridInfo.ShowGrid;
    bp.Hint:='Show the grid ?';
    Inspector1.AddProperty( bp );

    bp:= TEzBooleanProperty.Create('GridInfo.SnapToGrid');
    bp.ValBoolean:= FDrawBox.GridInfo.SnapToGrid;
    bp.Hint:='Snap to grid ?';
    Inspector1.AddProperty( bp );

  bp:= TEzDummyProperty.Create('ScreenGrid');
  bp.readonly:=true;
  Inspector1.AddProperty( bp );
  bp.Modified:=true;    { causes to show on bold}

    bp:= TEzColorProperty.Create('ScreenGrid.Color');
    bp.ValInteger:= FDrawBox.ScreenGrid.Color;
    bp.Hint:='Defines the color of screen grid';
    Inspector1.AddProperty( bp );

    bp:= TEzBooleanProperty.Create('ScreenGrid.Show');
    bp.ValBoolean:= FDrawBox.ScreenGrid.Show;
    bp.Hint:='Show screen grid ?';
    Inspector1.AddProperty( bp );

    bp:= TEzFloatProperty.Create('ScreenGrid.Step.X');
    bp.ValFloat:= FDrawBox.ScreenGrid.Step.X;
    bp.Hint:='Screen grid separation X axxis';
    Inspector1.AddProperty( bp );

    bp:= TEzFloatProperty.Create('ScreenGrid.Step.Y');
    bp.ValFloat:= FDrawBox.ScreenGrid.Step.Y;
    bp.Hint:='Screen grid separation Y axxis';
    Inspector1.AddProperty( bp );

  If Assigned( (FDrawBox As TEzDrawbox).ScaleBar ) Then
  Begin
    tv:= TEzTreeViewProperty.Create('ScaleBar');
    Inspector1.AddProperty( tv );
    tv.Modified:=true;    { causes to show on bold}

      bp:= TEzEnumerationProperty.Create('Scalebar.Units');
      with TEzEnumerationProperty(bp).Strings do
      begin
        For J:= Low(pj_units) to High(pj_units) Do
          Add(pj_units[J].name);
      end;
      bp.ValInteger:= Ord(FDrawBox.Scalebar.Units);
      bp.Hint:= 'Units of the scale bar';
      tv.AddProperty( bp );

      bp:= TEzColorProperty.Create('ScaleBar.Color');
      bp.ValInteger:= FDrawBox.ScaleBar.Color;
      bp.Hint:='scale bar color';
      tv.AddProperty( bp );

      bp:= TEzColorProperty.Create('ScaleBar.LinesColor');
      bp.ValInteger:= FDrawBox.ScaleBar.LinesPen.Color;
      bp.Hint:='scale bar lines color';
      tv.AddProperty( bp );

      bp:= TEzColorProperty.Create('ScaleBar.MinorFillColor');
      bp.ValInteger:= FDrawBox.ScaleBar.MinorBrush.Color;
      bp.Hint:='scale bar MinorFill color';
      tv.AddProperty( bp );

      bp:= TEzColorProperty.Create('ScaleBar.MajorFillColor');
      bp.ValInteger:= FDrawBox.ScaleBar.MajorBrush.Color;
      bp.Hint:='scale bar MajorFill color';
      tv.AddProperty( bp );

      bp:= TEzEnumerationProperty.Create('Scalebar.Appearance');
      with TEzEnumerationProperty(bp).Strings do
      begin
        Add('apBlockAlternate');
        Add('apBlock');
        Add('apRuler');
      end;
      bp.ValInteger:= Ord(FDrawBox.Scalebar.Appearance);
      bp.Hint:= 'Appearance of the scale bar';
      tv.AddProperty( bp );

      bp:= TEzEnumerationProperty.Create('Scalebar.IntervalLengthUnits');
      with TEzEnumerationProperty(bp).Strings do
      begin
        Add('suInches');
        Add('suMms');
        Add('suCms');
      end;
      bp.ValInteger:= Ord(FDrawBox.Scalebar.IntervalLengthUnits);
      bp.Hint:= 'Interval length units of the scale bar';
      tv.AddProperty( bp );

      bp:= TEzIntegerProperty.Create('ScaleBar.BarHeight');
      bp.ValInteger:= FDrawBox.ScaleBar.BarHeight;
      bp.Hint:='Bar height of the scale bar';
      tv.AddProperty( bp );

      bp:= TEzIntegerProperty.Create('ScaleBar.IntervalNumber');
      bp.ValInteger:= FDrawBox.ScaleBar.IntervalNumber;
      bp.Hint:='IntervalNumber of the scale bar';
      tv.AddProperty( bp );

      bp:= TEzIntegerProperty.Create('ScaleBar.NumDecimals');
      bp.ValInteger:= FDrawBox.ScaleBar.NumDecimals;
      bp.Hint:='NumDecimals of the scale bar';
      tv.AddProperty( bp );

      bp:= TEzBooleanProperty.Create('ScaleBar.Visible');
      bp.ValBoolean:= FDrawBox.ScaleBar.Visible;
      bp.Hint:='Visibility of the scale bar';
      tv.AddProperty( bp );
  End;

  Result:= ShowModal;
end;

procedure TfrmDBInspector.FormClose(Sender: TObject;
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

procedure TfrmDBInspector.Button1Click(Sender: TObject);
var
  bp: TEzBaseProperty;
  TmpPickFilter: TEzEntityIds;
  I: Integer;
begin

    bp:= Inspector1.GetPropertyByName('BlinkCount');
    if bp.modified then
      FDrawBox.BlinkCount:= bp.ValInteger ;

    bp:= Inspector1.GetPropertyByName('BlinkRate');
    if bp.modified then
      FDrawBox.BlinkRate:=bp.ValInteger;

    bp:= Inspector1.GetPropertyByName('Color');
    if bp.modified then
      FDrawBox.Color:=bp.ValInteger;

    bp:= Inspector1.GetPropertyByName('DelayShowHint');
    if bp.modified then
      FDrawBox.DelayShowHint:= bp.ValInteger;

    bp:= Inspector1.GetPropertyByName('DropRepeat');
    if bp.modified then
      FDrawBox.DropRepeat:=bp.ValInteger;

    bp:= Inspector1.GetPropertyByName('FlatScrollBar');
    if bp.modified then
      FDrawBox.FlatScrollBar:=bp.ValBoolean;

    bp:= Inspector1.GetPropertyByName('NumDecimals');
    if bp.modified then
      FDrawBox.NumDecimals:=bp.ValInteger;

    bp:= Inspector1.GetPropertyByName('PartialSelect');
    if bp.modified then
    FDrawBox.PartialSelect:=bp.ValBoolean;

    bp:= Inspector1.GetPropertyByName('NoPickFilter');
    if bp.modified then
    begin
      TmpPickFilter:= [];
      with TEzSetProperty(bp) do
      begin
        if Defined[0] then  Include(TmpPickFilter, idNone          );
        if Defined[1] then  Include(TmpPickFilter, idPoint         );
        if Defined[2] then  Include(TmpPickFilter, idPlace         );
        if Defined[3] then  Include(TmpPickFilter, idPolyline      );
        if Defined[4] then  Include(TmpPickFilter, idPolygon       );
        if Defined[5] then  Include(TmpPickFilter, idRectangle     );
        if Defined[6] then  Include(TmpPickFilter, idArc           );
        if Defined[7] then  Include(TmpPickFilter, idEllipse       );
        if Defined[8] then  Include(TmpPickFilter, idPictureRef    );
        if Defined[9] then  Include(TmpPickFilter, idPersistBitmap );
        if Defined[10] then Include(TmpPickFilter, idBandsBitmap   );
        if Defined[11] then Include(TmpPickFilter, idSpline        );
        if Defined[12] then Include(TmpPickFilter, idTable         );
        if Defined[13] then Include(TmpPickFilter, idGroup         );
        if Defined[14] then Include(TmpPickFilter, idTrueTypeText  );
        if Defined[15] then Include(TmpPickFilter, idJustifVectText);
        if Defined[16] then Include(TmpPickFilter, idFittedVectText);
        if Defined[17] then Include(TmpPickFilter, idDimHorizontal );
        if Defined[18] then Include(TmpPickFilter, idDimVertical   );
        if Defined[19] then Include(TmpPickFilter, idDimParallel   );
        if Defined[20] then Include(TmpPickFilter, idRtfText       );
        if Defined[21] then Include(TmpPickFilter, idBlockInsert   );
        if Defined[22] then Include(TmpPickFilter, idSplineText    );
        if Defined[23] then Include(TmpPickFilter, idCustomPicture );
        if Defined[24] then Include(TmpPickFilter, idPreview       );
      end;
      FDrawBox.NoPickFilter:= TmpPickFilter;
    end;

    bp:= Inspector1.GetPropertyByName('RubberPenColor');
    if bp.modified then
      FDrawBox.RubberPen.Color:=bp.ValInteger;

    bp:= Inspector1.GetPropertyByName('ShowLayerExtents');
    if bp.modified then
    FDrawBox.ShowLayerExtents:=bp.ValBoolean;

    bp:= Inspector1.GetPropertyByName('ShowMapExtents');
    if bp.modified then
    FDrawBox.ShowMapExtents:=bp.ValBoolean;

    bp:= Inspector1.GetPropertyByName('SnapToGuideLines');
    if bp.modified then
      FDrawBox.SnapToGuideLines:=bp.ValBoolean;

    bp:= Inspector1.GetPropertyByName('SnapToGuidelinesDist');
    if bp.modified then
      FDrawbox.SnapToGuidelinesDist:=bp.ValFloat;

    bp:= Inspector1.GetPropertyByName('StackedSelect');
    if bp.modified then
      FDrawBox.StackedSelect:=bp.ValBoolean;

    bp:= Inspector1.GetPropertyByName('SymbolMarker');
    if bp.modified then
      FDrawBox.SymbolMarker:=bp.ValInteger;


    bp:= Inspector1.GetPropertyByName('GridInfo.DrawAsCross');
    if bp.modified then
      FDrawBox.GridInfo.DrawAsCross:=bp.ValBoolean;

    bp:= Inspector1.GetPropertyByName('GridInfo.Grid.X');
    if bp.modified then
      FDrawBox.GridInfo.Grid.X:=bp.ValFloat;

    bp:= Inspector1.GetPropertyByName('GridInfo.Grid.Y');
    if bp.modified then
      FDrawBox.GridInfo.Grid.Y:=bp.ValFloat;

    bp:= Inspector1.GetPropertyByName('GridInfo.GridColor');
    if bp.modified then
      FDrawBox.GridInfo.GridColor:=bp.ValInteger;

    bp:= Inspector1.GetPropertyByName('GridInfo.GridOffset.X');
    if bp.modified then
      FDrawBox.GridInfo.GridOffset.X:=bp.ValFloat;

    bp:= Inspector1.GetPropertyByName('GridInfo.GridOffset.Y');
    if bp.modified then
      FDrawBox.GridInfo.GridOffset.Y:=bp.ValFloat;

    bp:= Inspector1.GetPropertyByName('GridInfo.GridSnap.X');
    if bp.modified then
      FDrawBox.GridInfo.GridSnap.X:=bp.ValFloat;

    bp:= Inspector1.GetPropertyByName('GridInfo.GridSnap.Y');
    if bp.modified then
      FDrawBox.GridInfo.GridSnap.Y:=bp.ValFloat;

    bp:= Inspector1.GetPropertyByName('GridInfo.ShowGrid');
    if bp.modified then
      FDrawBox.GridInfo.ShowGrid:=bp.ValBoolean;

    bp:= Inspector1.GetPropertyByName('GridInfo.SnapToGrid');
    if bp.modified then
      FDrawBox.GridInfo.SnapToGrid:=bp.ValBoolean;


    bp:= Inspector1.GetPropertyByName('ScreenGrid.Color');
    if bp.modified then
      FDrawBox.ScreenGrid.Color:=bp.ValInteger;

    bp:= Inspector1.GetPropertyByName('ScreenGrid.Show');
    if bp.modified then
      FDrawBox.ScreenGrid.Show:=bp.ValBoolean;

    bp:= Inspector1.GetPropertyByName('ScreenGrid.Step.X');
    if bp.modified then
      FDrawBox.ScreenGrid.Step.X:=bp.ValFloat;

    bp:= Inspector1.GetPropertyByName('ScreenGrid.Step.Y');
    if bp.modified then
      FDrawBox.ScreenGrid.Step.Y:=bp.ValFloat;

    If Assigned( FDrawBox.ScaleBar) then
    begin
      bp:= Inspector1.GetPropertyByName('Scalebar.Units');
      if bp.modified then
        FDrawBox.Scalebar.Units:= TEzCoordsUnits( bp.ValInteger);

      bp:= Inspector1.GetPropertyByName('ScaleBar.Color');
      if bp.modified then
        FDrawBox.ScaleBar.Color:=bp.ValInteger;

      bp:= Inspector1.GetPropertyByName('ScaleBar.LinesColor');
      if bp.modified then
        FDrawBox.ScaleBar.LinesPen.Color:=bp.ValInteger;

      bp:= Inspector1.GetPropertyByName('ScaleBar.MinorFillColor');
      if bp.modified then
        FDrawBox.ScaleBar.MinorBrush.Color:=bp.ValInteger;

      bp:= Inspector1.GetPropertyByName('ScaleBar.MajorFillColor');
      if bp.modified then
        FDrawBox.ScaleBar.MajorBrush.Color:=bp.ValInteger;

      bp:= Inspector1.GetPropertyByName('ScaleBar.Appearance');
      if bp.modified then
        FDrawBox.ScaleBar.Appearance:=TEzBarAppearance(bp.ValInteger);

      bp:= Inspector1.GetPropertyByName('Scalebar.IntervalLengthUnits');
      if bp.modified then
        FDrawBox.Scalebar.IntervalLengthUnits:= TEzScaleUnits(bp.ValInteger) ;


      bp:= Inspector1.GetPropertyByName('Scalebar.BarHeight');
      if bp.modified then
        FDrawBox.Scalebar.BarHeight:= bp.ValInteger ;

      bp:= Inspector1.GetPropertyByName('Scalebar.IntervalNumber');
      if bp.modified then
        FDrawBox.Scalebar.IntervalNumber:= bp.ValInteger ;

      bp:= Inspector1.GetPropertyByName('Scalebar.NumDecimals');
      if bp.modified then
        FDrawBox.Scalebar.NumDecimals:= bp.ValInteger ;

      bp:= Inspector1.GetPropertyByName('Scalebar.Visible');
      if bp.modified then
        FDrawBox.Scalebar.Visible:= bp.ValBoolean ;
    end;

    for I:= 0 to Inspector1.PropertyCount-1 do
      if Inspector1.Proplist[I].Modified then
      begin
        FDrawBox.Repaint;
        Break;
      end;

end;

end.
