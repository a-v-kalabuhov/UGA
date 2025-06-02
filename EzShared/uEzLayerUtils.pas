unit uEzLayerUtils;

interface

uses
  EzBaseGIS;

type
  TLayerRecNoPredicate = function (Layer: TEzBaseLayer; const Recno: Integer): Boolean;
  TLayerRecNoPredicateEvent = function (Layer: TEzBaseLayer; const Recno: Integer): Boolean of object;

  TEzlayerUtils = class
  public
    class procedure ClearLayer(aGis: TEzBaseGis; const aLayerName: string; aPredicate: TLayerRecNoPredicate); overload;
    class procedure ClearLayer(aGis: TEzBaseGis; const aLayer: TEzBaseLayer; aPredicate: TLayerRecNoPredicate); overload;
  end;

implementation

{ TEzlayerUtils }

class procedure TEzlayerUtils.ClearLayer(aGis: TEzBaseGis; const aLayerName: string; aPredicate: TLayerRecNoPredicate);
var
  L: TEzBaseLayer;
begin
  if Assigned(aGIS) then
  begin
    L := aGIS.Layers.LayerByName(aLayerName);
    ClearLayer(aGis, L, aPredicate);
  end;
end;

class procedure TEzlayerUtils.ClearLayer(aGis: TEzBaseGis; const aLayer: TEzBaseLayer;
  aPredicate: TLayerRecNoPredicate);
//var
//  V: Boolean;
begin
  if Assigned(aGIS) and Assigned(aLayer) then
  begin
    aLayer.First;
    while not aLayer.Eof do
    begin
      if not aLayer.RecIsDeleted then
        if not Assigned(aPredicate) or aPredicate(aLayer, aLayer.Recno) then
          aLayer.DeleteEntity(aLayer.Recno);
      aLayer.Next;
    end;
//      V := L.LayerInfo.Visible;
//      L.LayerInfo.Visible := True;
//      try
//        L.Pack(False);
//      finally
//        L.LayerInfo.Visible := V;
//      end;
  end;
end;

end.
