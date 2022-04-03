unit fLayerInspector;

interface
                                    
uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ExtCtrls, Grids, EzInspect, EzBaseGis;

type
  TfrmLayerInspector = class(TForm)
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

{ TfrmLayerInspector }

function TfrmLayerInspector.Enter(Gis: TEzBaseGis): Word;
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

  for I:= 0 to FGis.Layers.Count-1 do
  begin

    bp:= TEzDummyProperty.Create( FGis.Layers[I].Name );
    bp.readonly:=true;
    Inspector1.AddProperty( bp );
    bp.Modified:=true;    { causes to show on bold}

    with FGis.Layers[I] do
    begin
      bp:= TEzBooleanProperty.Create(Name+'.Visible');
      bp.ValBoolean:= Layerinfo.Visible;
      bp.Hint:='Is layer visible ?';
      Inspector1.AddProperty( bp );

      bp:= TEzBooleanProperty.Create(Name+'.Selectable');
      bp.ValBoolean:= Layerinfo.Visible;
      bp.Hint:='Is layer selectable ?';
      Inspector1.AddProperty( bp );

      bp:= TEzBooleanProperty.Create(Name+'.TextHasShadow');
      bp.ValBoolean:= Layerinfo.TextHasShadow;
      bp.Hint:='Show True Type text with a shadow ?';
      Inspector1.AddProperty( bp );

      bp:= TEzIntegerProperty.Create(Name+'.TextFixedSize');
      bp.ValInteger:= LayerInfo.TextFixedSize;
      bp.Hint:='If > 0, text is always the same size (in points)';
      Inspector1.AddProperty( bp );

      bp:= TEzEnumerationProperty.Create(Name+'.OverlappedTextAction');
      with TEzEnumerationProperty(bp).Strings do
      begin
        Add('otaDoNothing');
        Add('otaHideOverlapped');
        Add('otaShowOverlappedOnColor');
      end;
      bp.ValInteger:= Ord(Layerinfo.OverlappedTextAction);
      bp.Hint:= 'Defines how overlapped text is treated';
      Inspector1.AddProperty( bp );

      bp:= TEzColorProperty.Create(Name+'.OverlappedTextColor');
      bp.ValInteger:= Layerinfo.OverlappedTextColor;
      bp.Hint:='Define color when OverlappedTextAction = otaShowOverlappedOnColor';
      Inspector1.AddProperty( bp );

    end;

  end;


  result:= showmodal;
end;

procedure TfrmLayerInspector.Button1Click(Sender: TObject);
var
  I:Integer;
  bp:TEzBaseProperty;
  tmpmod:boolean;
begin
  tmpmod:=false;
  for I:= 0 to FGis.Layers.Count-1 do
  begin

    with FGis.Layers[I] do
    begin
      bp:= Inspector1.GetPropertyByName(Name+'.Visible');
      if bp.modified then
      begin
        Layerinfo.Visible:=bp.ValBoolean;
        tmpmod:=true;
      end;

      bp:= Inspector1.GetPropertyByName(Name+'.Selectable');
      if bp.modified then
      begin
        Layerinfo.Visible:=bp.ValBoolean;
        tmpmod:=true;
      end;

      bp:= Inspector1.GetPropertyByName(Name+'.TextHasShadow');
      if bp.modified then
      begin
        Layerinfo.TextHasShadow:=bp.ValBoolean;
        tmpmod:=true;
      end;

      bp:= Inspector1.GetPropertyByName(Name+'.TextFixedSize');
      if bp.modified then
      begin
        LayerInfo.TextFixedSize:=bp.ValInteger;
        tmpmod:=true;
      end;

      bp:= Inspector1.GetPropertyByName(Name+'.OverlappedTextAction');
      if bp.modified then
      begin
        Layerinfo.OverlappedTextAction:=TEzOverlappedTextAction( bp.ValInteger );
        tmpmod:=true;
      end;

      bp:= Inspector1.GetPropertyByName(Name+'.OverlappedTextColor');
      if bp.modified then
      begin
        Layerinfo.OverlappedTextColor:= bp.ValInteger;
        tmpmod:=true;
      end;

    end;

  end;

  if tmpmod then FGis.RepaintViewports;
end;

end.
