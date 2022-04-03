unit EzXMLImport;

interface

uses
  Classes, EzImportBase, XMLDoc, EzBaseGIS, XMLIntf;

type
  TEzXMLExport = Class( TEzBaseExport )
  Private
    FXMLDoc: TXMLDocument;
    FObjectsNode: IXMLNode;
    FLayerName: String;
    procedure SetLayerName(Value: String);
  Public
    Constructor Create( AOwner: TComponent ); Override;
    Destructor Destroy; Override;
    Procedure ExportInitialize; Override;
    Procedure ExportEntity( SourceLayer: TEzBaseLayer; Entity: TEzEntity ); Override;
    Procedure ExportEnd; Override;
  Published
    Property LayerName: String Read FLayerName Write SetLayerName;
  End;

implementation

uses
  uGtUtils;

{ TEzXMLExport }

const
  SEMPTYDOC = '<?xml version="1.0" encoding="WINDOWS-1251"?><objects/>';

constructor TEzXMLExport.Create(AOwner: TComponent);
begin
  inherited;
  FXMLDoc := TXMLDocument.Create(Self);
end;

destructor TEzXMLExport.Destroy;
begin
  FXMLDoc.Free;
  inherited;
end;

procedure TEzXMLExport.ExportEnd;
begin
  inherited;
  FObjectsNode := nil;
  FXMLDoc.SaveToFile(FileName);
end;

procedure TEzXMLExport.ExportEntity(SourceLayer: TEzBaseLayer;
  Entity: TEzEntity);
var
  node, attr_node, point: IXMLNode;
  I: Integer;
  EntType: String;
begin
  inherited;
  node := FObjectsNode.AddChild('object');
  node.Attributes['type'] := EntityID2Name(Entity.EntityID);
{!!! здесь необходино сделать добавление прочих параметров
   в зависимости от типа объекта !!!}
  for I := 0 to Entity.Points.Count - 1 do
  begin
    point := node.AddChild('point');
    point.Attributes['x'] := Entity.Points.X[I];
    point.Attributes['y'] := Entity.Points.Y[I];
  end;
end;

procedure TEzXMLExport.ExportInitialize;
begin
  inherited;
  FXMLDoc.LoadFromXML(SEMPTYDOC);
  FObjectsNode := FXMLDoc.DocumentElement.ChildNodes.First;
end;

procedure TEzXMLExport.SetLayerName(Value: String);
begin
  FLayerName := Value;
end;

end.
