unit fGisInspector;

interface             

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ExtCtrls, Grids, EzInspect, EzBaseGis;

type
  TfrmGisInspector = class(TForm)
    Inspector1: TEzInspector;
    Panel1: TPanel;
    Button1: TButton;
    Button2: TButton;
    procedure Button1Click(Sender: TObject);
  private
    { Private declarations }
    FGis: TEzBaseGis;
  public
    { Public declarations }
    function Enter( Gis: TEzBaseGis ): Word;
  end;

implementation

{$R *.DFM}

uses
  EzSystem, ezbase;

{ TfrmGisInspector }

function TfrmGisInspector.Enter(Gis: TEzBaseGis): Word;
var
  bp: TEzBaseProperty;
  ColsString: TStrings;
  I: Integer;
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

  FGis := Gis;

  bp:= TEzDummyProperty.Create('General');
  bp.readonly:=true;
  Inspector1.AddProperty( bp );
  bp.Modified:=true;    { causes to show on bold}

    bp:= TEzEnumerationProperty.Create('CurrentLayerName');
    with TEzEnumerationProperty(bp).Strings do
    begin
      for I:= 0 to FGis.Layers.Count-1 do
        Add(FGis.Layers[I].Name);
      bp.ValInteger:= IndexOf( FGis.CurrentLayerName );
    end;
    bp.Hint:= 'Define current layer';
    Inspector1.AddProperty( bp );

    bp:= TEzEnumerationProperty.Create('AerialViewLayer');
    with TEzEnumerationProperty(bp).Strings do
    begin
      Add('');
      for I:= 0 to FGis.Layers.Count-1 do
        Add(FGis.Layers[I].Name);
      bp.ValInteger:= IndexOf( FGis.MapInfo.AerialViewLayer );
    end;
    bp.Hint:= 'Define layer used in aerial view';
    Inspector1.AddProperty( bp );

    bp:= TEzColorProperty.Create('FontShadowColor');
    bp.ValInteger:= FGis.FontShadowColor;
    bp.Hint:='Color for TT font shadows';
    Inspector1.AddProperty( bp );

    bp:= TEzIntegerProperty.Create('FontShadowOffset');
    bp.ValInteger:= FGis.FontShadowOffset;
    bp.Hint:='The offset of the shadow in pixels';
    Inspector1.AddProperty( bp );

    bp:= TEzEnumerationProperty.Create('FontShadowStyle');
    with TEzEnumerationProperty(bp).Strings do
    begin
      Add('fssLowerRight');
      Add('fssUpperRight');
      Add('fssLowerLeft');
      Add('fssUpperLeft');
    end;
    bp.ValInteger:= Ord(FGis.FontShadowStyle);
    bp.Hint:= 'Defines the position of the shadow';
    Inspector1.AddProperty( bp );

    bp:= TEzIntegerProperty.Create('PrintTimerFrequency');
    bp.ValInteger:= FGis.PrintTimerFrequency;
    bp.Hint:='No. milliseconds for checking the cancel of a printing';
    Inspector1.AddProperty( bp );

    bp:= TEzBooleanProperty.Create('ReadOnly');
    bp.ValBoolean:= FGis.ReadOnly;
    bp.Hint:='Is readonly ?';
    Inspector1.AddProperty( bp );

    bp:= TEzBooleanProperty.Create('ShowWaitCursor');
    bp.ValBoolean:= FGis.ShowWaitCursor;
    bp.Hint:='Show hourglass cursor in long routines ?';
    Inspector1.AddProperty( bp );

    bp:= TEzIntegerProperty.Create('TimerFrequency');
    bp.ValInteger:= FGis.TimerFrequency;
    bp.Hint:='No. of milliseconds for checking for Windows messages';
    Inspector1.AddProperty( bp );

  bp:= TEzDummyProperty.Create('PolygonClipOperation');
  bp.readonly:=true;
  Inspector1.AddProperty( bp );
  bp.Modified:=true;    { causes to show on bold}

    bp:= TEzEnumerationProperty.Create('Operation');
    with TEzEnumerationProperty(bp).Strings do
    begin
      Add('pcDifference');
      Add('pcIntersect');
      Add('pcXor');
      Add('pcUnion');
      Add('pcSplit');
    end;
    bp.ValInteger:= Ord(FGis.PolygonClipOperation.Operation);
    bp.Hint:= 'Define the action when clipping polygons';
    Inspector1.AddProperty( bp );

    bp:= TEzBooleanProperty.Create('PreserveOriginals');
    bp.ValBoolean:= FGis.PolygonClipOperation.PreserveOriginals;
    bp.Hint:='Preserve originals when clipping a polygon ?';
    Inspector1.AddProperty( bp );

  Result:= ShowModal;

end;

procedure TfrmGisInspector.Button1Click(Sender: TObject);
VAR
  bp:TEzBaseProperty;
begin
  bp:= Inspector1.GetPropertyByName('CurrentLayerName');
  if bp.modified then
    FGis.CurrentLayerName:= TEzEnumerationProperty(bp).Strings[bp.ValInteger];

  bp:= Inspector1.GetPropertyByName('AerialViewLayer');
  if bp.modified then
    FGis.MapInfo.AerialViewLayer:=TEzEnumerationProperty(bp).Strings[bp.ValInteger];

  bp:= Inspector1.GetPropertyByName('FontShadowColor');
  if bp.modified then
    FGis.FontShadowColor:=bp.ValInteger;

  bp:= Inspector1.GetPropertyByName('FontShadowOffset');
  if bp.modified then
    FGis.FontShadowOffset:=bp.ValInteger;

  bp:= Inspector1.GetPropertyByName('FontShadowStyle');
  if bp.modified then
    FGis.FontShadowStyle:=TEzFontShadowStyle( bp.ValInteger );

  bp:= Inspector1.GetPropertyByName('PrintTimerFrequency');
  if bp.modified then
    FGis.PrintTimerFrequency:=bp.ValInteger;

  bp:= Inspector1.GetPropertyByName('ReadOnly');
  if bp.modified then
    FGis.ReadOnly:=bp.ValBoolean;

  bp:= Inspector1.GetPropertyByName('ShowWaitCursor');
  if bp.modified then
    FGis.ShowWaitCursor:=bp.ValBoolean;

  bp:= Inspector1.GetPropertyByName('Operation');
  if bp.modified then
    FGis.PolygonClipOperation.Operation:=TEzPolyClipOp( bp.ValInteger ) ;

  bp:= Inspector1.GetPropertyByName('PreserveOriginals');
  if bp.modified then
    FGis.PolygonClipOperation.PreserveOriginals:=bp.ValBoolean;

  bp:= Inspector1.GetPropertyByName('TimerFrequency');
  if bp.modified then
    FGis.TimerFrequency:=bp.ValInteger;

end;

end.
