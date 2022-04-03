unit uEzUtils;

interface

uses
  EzEntities, EzMiscelEntities, EzLib, EzBaseGIS, EzIBGIS,
  Classes, Graphics, SysUtils,
  uCommonUtils;

const
  Net500MinX = -20000;
  Net500MinY = -20000;
  Net500MapSize = 250;
  Net2000MinX = -20000;
  Net2000MinY = -20000;
  Net2000MapSize = 1000;

type
  TGtPointRec = record
    Index: Integer;
    Coords: TEzPoint;
    Length: Double;
    Azimuth: Double;
    ToPoint: Integer;
  end;
  TGtPointList = array of TGtPointRec;
  TGtContourList = array of TGtPointList;

  function EmptyEzTrueTypeText: TEzTrueTypeText;
  function EmptyEzPolyline: TEzPolyline;
  function EmptyEzPolygon: TEzPolygon;
  function EzRichText(filename: String; rect: TEzRect): TEzRtfText;
  function EmptyEzRectangle: TEzRectangle;
  function EmptyEzEllipse: TEzEllipse;
  function EmptyEzGroup: TEzGroupEntity;

  procedure CreateNet500(Layer: TEzBaseLayer; NeedClean: Boolean = True);
  procedure CreateNet2000(Layer: TEzBaseLayer; NeedClean: Boolean = True);
  procedure ClearLayer(Layer: TEzBaseLayer; NeedPack: Boolean = True);

  function GetPartPoints(Ent: TEzEntity; Part: Integer): TEzVector;
  function GetPartEntity(Ent: TEzEntity; Part: Integer): TEzEntity;
  procedure BuildEntityFromParts(Ent: TEzEntity; ListOfParts: TList);

  function AddLayer(GIS: TEzBaseGIS; LayerName: String; Path: String = ''): Boolean;
  function AddMemoryLayer(GIS: TEzBaseGIS; const LayerName: String): Boolean;

  function GetPointList(Points: TEzVector; StartWith: Integer): TGtPointList;
  function GetContoursList(Ent: TEzEntity; StartWith: Integer): TGtContourList;

  procedure AddPart(Ent: TEzEntity; Part: TEzVector);
  procedure DeletePart(Ent: TEzEntity; Part: Integer);
  procedure ReplacePart(Ent: TEzEntity; OldPartIndex: Integer; NewPart: TEzVector);

  function Pt(Point: TEzPoint): TEzPoint;

  function Azimuth(P1, P2: TEzPoint): Extended;
  function GroupArea(Ent: TEzEntity): Double;
  function GroupToObject(GroupEntity: TEzEntity): TEzEntity;

  function MaxRect(R1, R2: TEzRect): TEzRect;

var
  PointPrecision: Integer = 2;

implementation

uses
  IBDatabase, IBQuery,
  EzSystem;

function Pt(Point: TEzPoint): TEzPoint;
begin
  Result.x := RoundX(Point.x, PointPrecision);
  Result.y := RoundX(Point.y, PointPrecision);
end;

function EmptyEzTrueTypeText: TEzTrueTypeText;
begin
  result := TEzTrueTypeText.CreateEntity(Point2D(0, 0), 'text', 10, 0);
end;

function EmptyEzPolyline: TEzPolyline;
begin
  result := TEzPolyline.CreateEntity([Point2D(0, 0), Point2D(1, 1)]);
end;

function EmptyEzPolygon: TEzPolygon;
begin
  result := TEzPolygon.CreateEntity([Point2D(0, 0), Point2D(1, 1), Point2D(0, 1)]);
end;

function EmptyEzRectangle: TEzRectangle;
begin
  result := TEzRectangle.CreateEntity(Point2D(0, 0), Point2D(1, 1));
end;

function EmptyEzEllipse: TEzEllipse;
begin
  result := TEzEllipse.CreateEntity(Point2D(0, 0), Point2D(1, 1));
end;

function EzRichText(filename: String; rect: TEzRect): TEzRtfText;
var
  L: TStringList;
begin
  L := TStringList.Create;
  Result := TEzRtfText.CreateEntity(rect.Emin, rect.Emax, l);
  if filename <> '' then
    result.Lines.LoadFromFile(filename);
  l.Free;
end;

function EmptyEzGroup: TEzGroupEntity;
begin
  Result := TEzGroupEntity.CreateEntity;;
end;


procedure CreateNet500(Layer: TEzBaseLayer; NeedClean: Boolean = True);
var
  X, Y, NewX, NewY: Integer;
  S: String;
  Map: TEzGroupEntity;
  Text: TEzTrueTypeText;
  Rectangle: TEzRectangle;
  H: Double;
begin
  if NeedClean then ClearLayer(Layer, True);
  X := Net500MinX + 1;
  while X < (-Net500MinX + 1) do
  begin
    NewX := X + Net500MapSize;
    Y := Net500MinY + 1;
    while Y < (-Net500MinY + 1) do
    begin
      NewY := Y + Net500MapSize;
      S := GetNomenclature500(X, Y);
      Map := TEzGroupEntity.CreateEntity;
      H := Net500MapSize / 5;
      Rectangle := TEzRectangle.CreateEntity(Point2D(Y - 1, X - 1),
                                        Point2d(NewY - 1, NewX - 1));
      Rectangle.PenTool.Color := clMaroon;
      Map.Add(Rectangle);
      Text := TEzTrueTypeText.CreateEntity(Point2D(0, 0), S, H, 0);
      Text.BasePoint := Point2D( (Y - 1)  + ( Net500MapSize - (Text.FBox.xmax - Text.FBox.xmin) ) / 2 ,
         (X - 1) + 3 * H);
         Text.FontTool.Color := clMaroon;
      Map.Add(Text);
      Layer.AddEntity(Map);
      Map.Free;
      Y := NewY;
    end;
    X := NewX;
  end;
end;

procedure CreateNet2000(Layer: TEzBaseLayer; NeedClean: Boolean = True);
var
  X, Y, NewX, NewY: Integer;
  S: String;
  Map: TEzGroupEntity;
  Text: TEzTrueTypeText;
  Rectangle: TEzRectangle;
  H: Double;
begin
  if NeedClean then ClearLayer(Layer, True);
  X := Net2000MinX + 1;
  while X < (-Net2000MinX + 1) do
  begin
    NewX := X + Net2000MapSize;
    Y := Net500MinY + 1;
    while Y < (-Net2000MinY + 1) do
    begin
      NewY := Y + Net2000MapSize;
      S := GetNomenclature2000(X, Y);
      Map := TEzGroupEntity.CreateEntity;
      H := Net2000MapSize / 5;
      Rectangle := TEzRectangle.CreateEntity(Point2D(Y - 1, X - 1),
                                        Point2d(NewY - 1, NewX - 1));
      Rectangle.PenTool.Color := clOlive;
      Map.Add(Rectangle);
      Text := TEzTrueTypeText.CreateEntity(Point2D(0, 0), S, H, 0);
      Text.BasePoint := Point2D( (Y - 1)  + ( Net2000MapSize - (Text.FBox.xmax - Text.FBox.xmin) ) / 2 ,
         (X - 1) + 3 * H);
         Text.FontTool.Color := clOlive;
      Map.Add(Text);
      Layer.AddEntity(Map);
      Map.Free;
      Y := NewY;
    end;
    X := NewX;
  end;
end;

procedure ClearLayer(Layer: TEzBaseLayer; NeedPack: Boolean = True);
var
  List: TList;
  I: Integer;
begin
  List := TList.Create;
  Layer.First;
  while not Layer.Eof do
  begin
    List.Add(Ptr(Layer.Recno));
    Layer.Next;
  end;
  for I := 0 to List.Count - 1 do
    Layer.DeleteEntity(Integer(List.Items[I]));
  if NeedPack then Layer.Pack(False);
  List.Free;
end;

function GetPartPoints(Ent: TEzEntity; Part: Integer): TEzVector;
var
  VList: TList;
begin
  Result := nil;
  VList := GetListOfVectors(Ent);
  if (Part >= 0) or (Part < VList.Count) then
  begin
    Result := TEzVector.Create(TEzVector(VList[Part]).Size);
    Result.Assign(TEzVector(VList[Part]));
  end;
  freelist(VList);
end;

function GetPartEntity(Ent: TEzEntity; Part: Integer): TEzEntity;
var
  V: TEzVector;
begin
  V := GetPartPoints(Ent, Part);
  Result := GetClassFromID(Ent.EntityID).Create(4);
  Result.Points.Assign(V);
  V.Free;
end;

procedure BuildEntityFromParts(Ent: TEzEntity; ListOfParts: TList);
var
  V: TEzVector;
  I: Integer;
begin
  if ListOfParts.Count > 0 then
  begin
    V := TEzVector(ListOfParts.Items[0]);
    Ent.Points.Assign(V);
    ListOfParts[0] := nil;
    for I := 1 to ListOfParts.Count - 1 do
    begin
      V := TEzVector(ListOfParts.Items[I]);
      AddPart(Ent, V);
    end;
  end;
end;

function AddLayer(GIS: TEzBaseGIS; LayerName: String; Path: String = ''): Boolean;
var
  Layer: TEzBaseLayer;
begin
  Layer := GIS.Layers.LayerByName(LayerName);
  {$IFDEF LOG}
  ShowMessage('Layer selected OK!');
  {$ENDIF}

  if Layer = nil then
  begin
  {$IFDEF LOG}
  ShowMessage('Layer not assigned OK!');
  {$ENDIF}
    GIS.Layers.CreateNew(Path + LayerName);
  {$IFDEF LOG}
  ShowMessage('Layer created OK!');
  {$ENDIF}
    Result := True;
  end
  else Result := False;
end;

function AddMemoryLayer(GIS: TEzBaseGIS; const LayerName: String): Boolean;
var
  Layer: TEzBaseLayer;
begin
  Layer := GIS.Layers.LayerByName(LayerName);
  if Layer = nil then
  begin
    GIS.CreateLayer(LayerName, ltMemory);
    Result := True;
  end
  else Result := False;
end;

function GetPointList(Points: TEzVector; StartWith: Integer): TGtPointList;
var
  I, K: Integer;
  Pt1, Pt2: TEzPoint;
begin
  SetLength(Result, 0);
  if Points = nil then exit;
  if EqualPoint2D(Points[0], Points[Points.Count - 1]) then K := 2 else K := 1;
  with Points do
  begin
    for I := 0 to Count - K do
    begin
      SetLength(Result, Length(Result) + 1);
      with Result[High(Result)] do
      begin
        Index := StartWith + I + 1;
        Coords.x := Y[I];
        Coords.y := X[I];
        if Count < 2 then
        begin
          Length := 0;
          ToPoint := 0;
          Azimuth := 0;
        end
        else
          if I = (Count - K) then
          begin
            Length := Sqrt(Sqr(X[I] - X[0]) + Sqr(Y[I] - Y[0]));
            ToPoint := StartWith + 1;
            Pt1 := Point2D(Points[I].y, Points[I].x);
            Pt2 := Point2D(Points[0].y, Points[0].x);
            Azimuth := uEzUtils.Azimuth(Pt1, Pt2);
          end
          else
          begin
            Length := Sqrt(Sqr(X[I] - X[I + 1]) + Sqr(Y[I] - Y[I + 1]));
            ToPoint := StartWith + I + 2;
            Pt1 := Point2D(Points[I].y, Points[I].x);
            Pt2 := Point2D(Points[I + 1].y, Points[I + 1].x);
            Azimuth := uEzUtils.Azimuth(Pt1, Pt2);
          end;
      end;
    end;
  end;
end;

function GetContoursList(Ent: TEzEntity; StartWith: Integer): TGtContourList;

  procedure AddPointList(PL: TGtPointList);
  begin
    SetLength(Result, Length(Result) + 1);
    Result[High(Result)] := PL;
  end;

var
  I, Last: Integer;
  Ent2: TEzEntity;
begin
  SetLength(Result, 0);
  if Ent.Points.Parts.Count = 0 then
    AddPointList( GetPointList(Ent.Points, 0) )
  else
  begin
    Last := 0;
    for I := 0 to Ent.Points.Parts.Count - 1 do
    begin
      Ent2 := GetPartEntity(Ent, I);
      AddPointList( GetPointList(Ent2.Points, Last) );
      Last := Last + Ent2.Points.Count - 1;
      Ent2.Free;
    end;
  end;
end;

function Azimuth(P1, P2: TEzPoint): Extended;
begin
  P1 := Pt(P1);
  P2 := Pt(P2);
  if P2.X = P1.X then
    if P2.Y >= P1.Y then Result := Pi / 2 else Result := - Pi / 2
  else
    Result := ArcTan( (P2.Y - P1.Y) / (P2.X - P1.X) );
  if P2.X >= P1.X then begin
    if P2.Y < P1.Y then Result := Result + 2 * Pi end
  else
    Result := Result + Pi;
end;

procedure AddPart(Ent: TEzEntity; Part: TEzVector);
var
  I, K: Integer;
begin
  K := Ent.Points.Count;
  for I := 0 to Part.Count - 1 do Ent.Points.Add(Part.Points[I]);
  if Ent.Points.Parts.Count = 0 then Ent.Points.Parts.Add(0);
  Ent.Points.Parts.Add(K);
end;

procedure DeletePart(Ent: TEzEntity; Part: Integer);
var
  List: TList;
  V: TEzVector;
//  I: Integer;
begin
  List := GetListOfVectors(Ent);
  try
    if (Part < 0) or (Part >= List.Count) then
    begin

      raise EAbort.Create('Неверный индекс части объекта!');
    end;
    // Уничтожаем объект
    V := TEzVector(List[Part]);
    V.Free;
    // Удаляем из списка уазатель на уничтоженный объект
    List.Delete(Part);
{    if List.Count > 0 then
    begin
      V := TEzVector(List.Items[0]);
      Ent.Points.Assign(V);
      V.Free;
      List[0] := nil;
      for I := 1 to List.Count - 1 do
      begin
        V := TEzVector(List.Items[I]);
        AddPart(Ent, V);
        V.Free;
        List[I] := nil;
      end;
    end;     }
    // Собираем объект
    BuildEntityFromParts(Ent, List);
    if Ent.Points.Parts.Count = 1 then Ent.Points.Parts.Delete(0);
  finally
    FreeList(List);
  end;
end;

procedure ReplacePart(Ent: TEzEntity; OldPartIndex: Integer; NewPart: TEzVector);
var
  List: TList;
  V: TEzVector;
//  I: Integer;
begin
  List := GetListOfVectors(Ent);
  try
    if (OldPartIndex < 0) or (OldPartIndex >= List.Count) then
    begin
      raise EAbort.Create('Неверный индекс части объекта!');
    end;
    // Заменяем старую часть
    V := TEzVector(List[OldPartIndex]);
    V.Assign(NewPart);
    // Собираем объект
    BuildEntityFromParts(Ent, List);
  finally
    FreeList(List);
  end;
end;

function GroupArea(Ent: TEzEntity): Double;
var
  I: Integer;
begin
  Result := -1;
  if Ent is TEzGroupEntity then
  with Ent as TEzGroupEntity do
  begin
    Result := 0;
    for I := 0 to Count - 1 do Result := Result + Entities[I].Area;
  end;
end;

function GroupToObject(GroupEntity: TEzEntity): TEzEntity;
var
  I: Integer;
  Ent: TEzEntity;
begin
  Result := nil;
  try
//    Result := TEzEntity.Create(1);
    with GroupEntity as TEzGroupEntity do
    for I := 0 to Count - 1 do
      if Assigned(Result) then
        AddPart(Result, Entities[I].Points)
      else
      begin
        Result := TEzPolyLine.CreateEntity( [Point2D( 0, 0 )] );
        Result.Assign(Entities[I]);
      end;
  except
    FreeAndNil(Result);
  end;
end;

function MaxRect(R1, R2: TEzRect): TEzRect;
begin
  Result.xmax := dmax(R1.xmax, R2.xmax);
  Result.xmin := dmin(R1.xmin, R2.xmin);
  Result.ymax := dmax(R1.ymax, R2.ymax);
  Result.ymin := dmin(R1.ymin, R2.ymin);
end;

end.
