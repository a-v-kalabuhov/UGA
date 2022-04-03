unit uLtAdditionalEntities;

interface

uses
  SysUtils, Classes, Graphics,
  EzBase, EzLib, EzEntities, EzSystem, EzBaseGIS;

type
  TEzCadastralBlockEntity = class(TEzPolygon)
  private
    FText: TEzTrueTypeText;
    FBlockName: String;
    FDrawBlockName: Boolean;
    FVisible: Boolean;
    function GetBlockName: String;
    procedure SetBlockName(const Value: String);
    function GetFontTool: TEzFontTool;
    function ArrangeText: Boolean;
    procedure CreateText;
  protected
    function GetEntityID: TEzEntityID; override;
  public
    destructor Destroy; override;
    procedure Initialize; override;
    procedure Draw(Grapher: TEzGrapher; Canvas: TCanvas; Const Clip: TEzRect;
      DrawMode: TEzDrawMode; Data: Pointer = Nil); override;
    procedure LoadFromStream(Stream: TStream); override;
    procedure SaveToStream(Stream: TStream); override;
    function StorageSize: Integer; override;
    property FontTool: TEzFontTool read GetFontTool;
    property BlockName: String read GetBlockName write SetBlockName;
    property DrawBlockName: Boolean read FDrawBlockName write FDrawBlockName;

    property Visible: Boolean read FVisible write FVisible;
  end;

  TEzPrintArea = class(TEzRectangle)
  protected
    function GetEntityID: TEzEntityID; override;
  public
    function GetControlPoints(TransfPts: Boolean; Grapher: TEzGrapher = nil): TEzVector; override;
    function GetControlPointType( Index: Integer ): TEzControlPointType; override;
  end;

implementation

{ TEzCadastralBlockEntity }

function TEzCadastralBlockEntity.ArrangeText: Boolean;
var
  Pt: TEzPoint;
begin
  Result := False;
  if (FBlockName <> '') and (Points.Count > 0) then
  begin
    FText.UpdateExtension;
    Self.Centroid(Pt.x, Pt.y);
    Pt.x := Pt.x - (FText.FBox.xmax - FText.FBox.xmin) / 2;
    Pt.y := Pt.y - (FText.FBox.ymax - FText.FBox.ymin) / 2;
    FText.BasePoint := Pt;
    Result := TRue;
  end;
end;

procedure TEzCadastralBlockEntity.CreateText;
begin
  FText := TEzTrueTypeText.CreateEntity(Point2D(0, 0), FBlockName, 25, 0);
end;

destructor TEzCadastralBlockEntity.Destroy;
begin
  FreeAndNil(FText);
  inherited;
end;

procedure TEzCadastralBlockEntity.Draw(Grapher: TEzGrapher;
  Canvas: TCanvas; const Clip: TEzRect; DrawMode: TEzDrawMode;
  Data: Pointer);
begin
  if not FVisible then
    Exit;
  inherited;
  if Assigned(FText) and FDrawBlockName then
    FText.Draw(Grapher, Canvas, Clip, DrawMode, Data);
end;

function TEzCadastralBlockEntity.GetBlockName: String;
begin
  Result := FBlockName;
end;

function TEzCadastralBlockEntity.GetEntityID: TEzEntityID;
begin
  Result := idCadastralBlock;
end;

function TEzCadastralBlockEntity.GetFontTool: TEzFontTool;
begin
  Result := FText.FontTool;
end;

procedure TEzCadastralBlockEntity.Initialize;
begin
  inherited;
  if not Assigned(FText) then
    CreateText;
  BlockName := '';
  FDrawBlockName := True;
  FVisible := True;
end;

procedure TEzCadastralBlockEntity.LoadFromStream(Stream: TStream);
begin
  inherited;
  FontTool.LoadFromStream(Stream);
  BlockName := EzReadStrFromStream(Stream);
end;

procedure TEzCadastralBlockEntity.SaveToStream(Stream: TStream);
begin
  inherited;
  FontTool.SaveToStream(Stream);
  EzWriteStrToStream(FBlockName, Stream);
end;

procedure TEzCadastralBlockEntity.SetBlockName(const Value: String);
begin
  if FBlockName <> Value then
  begin
    FBlockName := Value;
    Ftext.Text := FBlockName;
    ArrangeText();
  end;
end;

function TEzCadastralBlockEntity.StorageSize: Integer;
begin
  Result := inherited StorageSize;
//  Result := Result + SizeOf(FText.FontTool);
  Result := Result + Length(FBlockName);
end;

{ TEzPage }

function TEzPrintArea.GetControlPoints(TransfPts: Boolean;
  Grapher: TEzGrapher): TEzVector;
begin
  Result := inherited GetControlPoints(TransfPts, Grapher);
  if Result.Count > 0 then
    Result.Delete(Result.Count - 1);
end;

function TEzPrintArea.GetControlPointType(Index: Integer): TEzControlPointType;
begin
  Result := inherited GetControlPointType(Index);
end;

function TEzPrintArea.GetEntityID: TEzEntityID;
begin
  Result := idPrintArea;
end;

end.
