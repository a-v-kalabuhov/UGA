unit uMStImportMifEntityLoaders;

interface

uses
  SysUtils, Classes, Contnrs, Windows, Graphics, Math,
  //
  EzBaseGIS, EzEntities, EzLib, EzSystem,
  //
  uGC, uGeoTypes, uCK36,
  //
  uMStImportMifBase, uMStImport;

type
  TEzPointObject = class
  public
    FPt: TEzPoint;
  end;

  TmstMifEntityLoader = class
  private
    FMIFLines: TStrings;
    FLineParts: TStringList;
    FGrapher: TEzGrapher;
    FMIFInfo: TMIFInfo;
    procedure SetMIFLines(const Value: TStrings);
    procedure SetLineIndex(const Value: Integer);
    procedure SetGrapher(const Value: TEzGrapher);
    procedure SetMIFInfo(const Value: TMIFInfo);
    procedure SetSettings(const Value: ImstImportSettings);
  protected
    FLineIndex: Integer;
    FBrush: TEzBrushStyle;
    FFont: TEzFontStyle;
    FPen: TEzPenStyle;
    FSymbol: TEzSymbolStyle;
    FSettings: ImstImportSettings;
    function GetColor(Value: Integer): TColor;
    procedure ReadLine();
    function ReadNextLine(): Boolean;
    function ReadBrush(): Boolean;
    function ReadFont(): Boolean;
    function ReadPen(): Boolean;
    function ReadPoint(var Pt: TEzPoint): Boolean;
    function ReadPointObj(): TEzPointObject;
    function ReadSymbol(): Boolean;
    function ReadTwoPoints(var Pt1, Pt2: TEzPoint): Boolean;
    function IntLoad(): TEzEntity; virtual; abstract;
    procedure DoConvertCoords(Entity: TEzEntity);
    procedure DoExchangeCoords(Entity: TEzEntity);
  public
    constructor Create;
    destructor Destroy; override;
    //
    function Load(): TEzEntity;
    //
    property Grapher: TEzGrapher read FGrapher write SetGrapher;
    property LineIndex: Integer read FLineIndex write SetLineIndex;
    property MIFInfo: TMIFInfo read FMIFInfo write SetMIFInfo;
    property MIFLines: TStrings read FMIFLines write SetMIFLines;
    property Settings: ImstImportSettings read FSettings write SetSettings;
  end;

  TEzNoneLoader = class(TmstMifEntityLoader)
  protected
    function IntLoad(): TEzEntity; override;
  end;

  TEzPointLoader = class(TmstMifEntityLoader)
  protected
    function IntLoad(): TEzEntity; override;
  end;

  TEzRegionLoader = class(TmstMifEntityLoader)
  private
    function ReadRegionPart(): TEzVector;
  protected
    function IntLoad(): TEzEntity; override;
  end;

  TEzLineLoader = class(TmstMifEntityLoader)
  protected
    function IntLoad(): TEzEntity; override;
  end;

  TEzPLineLoader = class(TmstMifEntityLoader)
  private
    function LoadPoints(const PartNum, PointCount: Integer): TEzVector;
  protected
    function IntLoad(): TEzEntity; override;
  end;

  TEzTextLoader = class(TmstMifEntityLoader)
  protected
    function IntLoad(): TEzEntity; override;
  end;

  TEzArcLoader = class(TmstMifEntityLoader)
  protected
    function IntLoad(): TEzEntity; override;
  end;

  TEzEllipseLoader = class(TmstMifEntityLoader)
  protected
    function IntLoad(): TEzEntity; override;
  end;

  TEzRectangleLoader = class(TmstMifEntityLoader)
  protected
    function IntLoad(): TEzEntity; override;
  end;

implementation

{ TEzNoneLoader }

function TEzNoneLoader.IntLoad(): TEzEntity;
begin
  Result := TEzNone.CreateEntity;
end;

{ TEzPointLoader }

function TEzPointLoader.IntLoad(): TEzEntity;
var
  P1: TEzPoint;
  aPlace: TEzPlace;
begin
  try
    ReadLine();
    ReadPoint(P1);
    aPlace := TEzPlace.CreateEntity(P1);
    ReadNextLine();
    if ReadSymbol() then
    begin
      aPlace.SymbolTool.Index := FSymbol.Index;
      aPlace.SymbolTool.Height := FGrapher.GetRealSize(Ez_Preferences.DefSymbolStyle.Height);
      aPlace.SymbolTool.Rotangle := FSymbol.Rotangle;
    end;
    Result := aPlace;
  except
    Result := nil;
  end;
end;

{ TmstMifEntityLoader }

constructor TmstMifEntityLoader.Create;
begin
  FLineParts := TStringList.Create;
end;

destructor TmstMifEntityLoader.Destroy;
begin
  FLineParts.Free;
  inherited;
end;

procedure TmstMifEntityLoader.DoConvertCoords(Entity: TEzEntity);
var
  I: Integer;
  X1, X2, Y1, Y2: Double;
begin
  for I := 0 to Entity.Points.Count - 1 do
  begin
    Y1 := Entity.Points[I].x;
    X1 := Entity.Points[I].y;
    ToVrn(X1, Y1, X2, Y2);
    Entity.Points[I] := Point2D(Y2, X2);
  end;
end;

procedure TmstMifEntityLoader.DoExchangeCoords(Entity: TEzEntity);
var
  I: Integer;
begin
  for I := 0 to Entity.Points.Count - 1 do
    Entity.Points[I] := Point2D(Entity.Points[I].y, Entity.Points[I].x);
end;

function TmstMifEntityLoader.GetColor(Value: Integer): TColor;
var
  S: string;
  Code: integer;
begin
  S := IntToHex(Value, 6);
  val('$' + S[5] + S[6] + S[3] + S[4] + S[1] + S[2], Result, Code);
end;

function TmstMifEntityLoader.Load: TEzEntity;
begin
  Result := IntLoad();
  if Assigned(Result) then
  begin
    if Assigned(FSettings) then
    begin
      if FSettings.ExchangeCoords then
        DoExchangeCoords(Result);
      if FSettings.CoordSystem = csMCK36 then
        DoConvertCoords(Result);
    end;
  end;
end;

function TmstMifEntityLoader.ReadBrush: Boolean;
var
  S: string;
  Splitter: TLineSplitter;
  BrushParts: TStringList;
  Idx: Integer;
  Clr: Integer;
begin
  Result := AnsiCompareText(FLineParts[0], 'Brush') = 0;
  if not Result then
    Exit;
  S := FLineParts[1];
  S := Copy(S, 2, Length(S) - 2);
  Splitter.Line := S;
  Splitter.Separator := ',';
  Splitter.AllowEmptyStrings := True;
  BrushParts := TStringList.Create;
  BrushParts.Forget();
  Splitter.Split(BrushParts);

//  With DefBrush Do
  try
    if not TryStrToInt(BrushParts[0], Idx) then
      Idx := 1;
    if Idx = 0 then
      Idx := 1;
    FBrush.Pattern := Idx - 1;
    if not TryStrToInt(BrushParts[1], Clr) then
      Clr := 0;
    FBrush.Color := GetColor(Clr);
    //defbrush.BackColor := MIF2DelphiColor(StrToInt(gslMIF[2]));
  except
    FBrush.Pattern := 0;
    FBrush.ForeColor := clBlack;
  end;
end;

function TmstMifEntityLoader.ReadFont: Boolean;
var
  S: string;
  I: Integer;
  Splitter: TLineSplitter;
  FntStyle: Integer;
  FntLines: TStringList;
  FntH: Integer;
  FntClr: Integer;
  B: Boolean;
begin
  Result := AnsiCompareText(FLineParts[0], 'Font') = 0;
  if not Result then
    Exit;

  S := FLineParts[1];
  for I := 2 to FLineParts.Count - 1 do
    S := S + ' ' + FLineParts[I];
  //
  Splitter.Line := Copy(S, 2, Length(S) - 2);
  Splitter.Separator := ',';
  Splitter.AllowEmptyStrings := True;
  FntLines := TStringList.Create;
  FntLines.Forget();
  Splitter.Split(FntLines);

  try
    FFont.Name := StringReplace(FntLines[0], '"', '', [rfReplaceAll]);
    // Mapinfo Text style
    // 1 - Bold
    // 2 - Italic
    // 4 - underline
    // 32- shadow
    // 512- All Capitals display
    // 1024 - Expand space
    FFont.Style := [];
    if TryStrToInt(FntLines[1], FntStyle) then
    begin
      if (FntStyle div 1024) = 1 then
        FntStyle := FntStyle - 1024;
      if (FntStyle div 512) = 1 then
      begin
        FFont.Name := AnsiUpperCase(FFont.Name);
        FntStyle := FntStyle - 512;
      end;
      if (FntStyle div 4) = 1 then
      begin
        FFont.style := FFont.style + [fsUnderline];
        FntStyle := FntStyle - 4;
      end;
      if (FntStyle div 2) = 1 then
      begin
        FFont.style := FFont.style + [fsitalic];
        FntStyle := FntStyle - 2;
      end;
      if FntStyle = 1 then
        FFont.Style := FFont.Style + [fsbold];
    end;
    if TryStrToInt(FntLines[2], FntH) then
    begin
      FFont.Height := FntH;
    end;
    if FFont.Height = 0 Then
      FFont.Height := -8;
    if TryStrToInt(FntLines[3], FntClr) then
    begin
      FFont.Color := GetColor(FntClr);
      FFont.Angle := 0;
    end;
  except
  end;
  //
  if AnsiCompareText(FLineParts[0], 'Angle') = 0 then
  begin
    TryStrToFloat(FLineParts[1], FFont.Angle);
    B := True;
    while B do
    begin
      ReadNextLine();
      B := (AnsiCompareText(FLineParts[0], 'Spacing') = 0)
            or
           (AnsiCompareText(FLineParts[0], 'Justify') = 0)
            or
           (AnsiCompareText(FLineParts[0], 'Label') = 0);
    end;
  end;
end;

procedure TmstMifEntityLoader.ReadLine;
var
  Splitter: TLineSplitter;
begin
  Splitter.AllowEmptyStrings := False;
  Splitter.Split(FLineParts, MIFLines[LineIndex]);
end;

function TmstMifEntityLoader.ReadNextLine: Boolean;
begin
  Result := FLineIndex < Pred(FMifLines.Count);
  if Result then
  begin
    Inc(FLineIndex);
    ReadLine();
  end;
end;

function TmstMifEntityLoader.ReadPen: Boolean;
var
  S: String;
  aColor: Integer;
  Splitter: TLineSplitter;
  PenLines: TStringList;
begin
  Result := AnsiCompareText(FLineParts[0], 'Pen') = 0;
  if not Result then
    Exit;
  S := FLineParts[1];
  Splitter.Line := Copy(S, 2, Length(S) - 2);
  Splitter.AllowEmptyStrings := True;
  Splitter.Separator := ',';
  PenLines := TStringList.Create;
  PenLines.Forget();
  Splitter.Split(PenLines);
  try
    if TryStrToInt(PenLines[2], aColor) then
    begin
      FPen.Color := GetColor(aColor);
      // TODO : тип линии не устанавливается, всегда сплошная
      FPen.Style := 1; //StrToInt(PenLines[1]) - 1;
      FPen.Width := StrToIntDef(PenLines[0], 0) / 10;
//      if FPen.Width > 0 then
//        FPen.Width := -FPen.Width;
//      FPen.Width := 0
    end;
  except
  end;
end;

function TmstMifEntityLoader.ReadPoint(var Pt: TEzPoint): Boolean;
begin
  Result := (FLineParts.Count > 1) and TryStrToFloat(FLineParts[0], Pt.x) and TryStrToFloat(FLineParts[1], Pt.y);
end;

function TmstMifEntityLoader.ReadPointObj: TEzPointObject;
var
  Tmp: TEzPoint;
begin
  Result := nil;
  if ReadPoint(Tmp) then
  begin
    Result := TEzPointObject.Create;
    Result.FPt := Tmp;
  end;
end;

function TmstMifEntityLoader.ReadSymbol: Boolean;
var
  S1, S2: String;
  Splitter: TLineSplitter;
  Parts: TStrings;
  I: Integer;
  H, Ra: Double;
//  i, j,code: integer;
//  tempf:double;
begin
  Result := AnsiCompareText(FLineParts[0], 'Symbol') = 0;
  if not Result then
    Exit;
  FSymbol.Index := 0;
  FSymbol.Rotangle := 0;
  FSymbol.Height := -12;

  S1 := FLineParts[1];
  S2 := '';
  if FLineParts.Count = 3 then
    S2 := FLineParts[2]
  else
  if FLineParts.count = 5 then
    S1 := FLineParts[1] + FLineParts[2] + FLineParts[3];

  Splitter.AllowEmptyStrings := True;
  Parts := Splitter.Split(Copy(S1, 2, Length(S1) - 2), ',');
  Parts.Forget();
  try
    if TryStrToInt(Parts[0], I) then
      FSymbol.Index := Abs(I - 32)
    else
      FSymbol.Index := 0;
    if TryStrToFloat(Parts[2], H) then
      FSymbol.Height := Round(H);

    if S2 <> '' then
    begin
      Parts := Splitter.Split(Copy(S2, 2, Length(S2) - 2), ',');
      if TryStrToFloat(Parts[2], Ra) then
        FSymbol.Rotangle := Ra;
    end;
  except
    Result := False;
  end;
end;

function TmstMifEntityLoader.ReadTwoPoints(var Pt1, Pt2: TEzPoint): Boolean;
begin
  Result :=
    (FLineParts.Count > 3)
    and
    TryStrToFloat(FLineParts[0], Pt1.x)
    and
    TryStrToFloat(FLineParts[1], Pt1.y)
    and
    TryStrToFloat(FLineParts[2], Pt2.x)
    and
    TryStrToFloat(FLineParts[3], Pt2.y);
end;

procedure TmstMifEntityLoader.SetGrapher(const Value: TEzGrapher);
begin
  FGrapher := Value;
end;

procedure TmstMifEntityLoader.SetLineIndex(const Value: Integer);
begin
  FLineIndex := Value;
end;

procedure TmstMifEntityLoader.SetMIFInfo(const Value: TMIFInfo);
begin
  FMIFInfo := Value;
end;

procedure TmstMifEntityLoader.SetMIFLines(const Value: TStrings);
begin
  FMIFLines := Value;
end;

procedure TmstMifEntityLoader.SetSettings(const Value: ImstImportSettings);
begin
  FSettings := Value;
end;

{ TEzRegionLoader }

function TEzRegionLoader.IntLoad: TEzEntity;
var
  RegionPartCount: Integer;
  PointCount: Integer;
  I: Integer;
  Vectors: TObjectList;
  V: TEzVector;
  Poly: TEzPolygon;
begin
  Result := nil;
  try
    ReadLine();
    RegionPartCount := 0;
    if not TryStrToInt(FLineParts[1], RegionPartCount) then
      Exit;
    ReadNextLine();
    PointCount := 0;
    if not TryStrToInt(FLineParts[0], PointCount) then
      Exit;
    // Get Combined Region Color
    if RegionPartCount > 0 then
    begin
      Vectors := TObjectList.Create;
      Vectors.Forget();
      for I := 1 to RegionPartCount do
      begin
        // читаем часть региона
        V := ReadRegionPart();
        if Assigned(V) and (V.Count > 0) then
        begin
          Vectors.Add(V);
          if I < RegionPartCount then
            ReadNextLine();
        end;
      end;
      if Vectors.Count = 0 then
        Exit;
      Poly := TEzPolygon.Create(10, True);
      Result := Poly;
      Result.BeginUpdate;
      try
        if Vectors.Count = 1 then
        begin
          V := TEzVector(Vectors[0]);
          Poly.Points.AddVector(V);
        end
        else
        begin
          for I := 0 to Vectors.Count - 1 do
          begin
            V := TEzVector(Vectors[I]);
            Poly.Points.AddPart(V);
          end;
        end;
      finally
        Result.EndUpdate;
      end;
      // читаем pen и brush
      ReadNextLine();
      ReadPen();
      Poly.PenTool.FPenStyle := FPen;
      //
      ReadNextLine();
      ReadBrush();
      Poly.BrushTool.FBrushStyle := FBrush;
      //
      ReadNextLine();
      if AnsiCompareText(FLineParts[0], 'Center') = 0 then
        ReadNextLine()
      else
        Dec(FLineIndex);
    end;
  except
    Result := Nil;
  end;
end;

function TEzRegionLoader.ReadRegionPart: TEzVector;
var
  N: Integer;
  S: string;
  I: Integer;
  Pt: TEzPoint;
begin
  Result := TEzVector.Create(1000);
  Result.Clear;
  // читаем количество точек
  S := Trim(FMIFLines[FLineIndex]);
  if TryStrToInt(S, N) then
  begin
    if N > 0 then
    begin
      for I := 1 to N do
      begin
        ReadNextLine();
        if ReadPoint(Pt) then
          Result.Add(Pt);
      end;
    end;
  end;
end;

{ TEzLineLoader }

function TEzLineLoader.IntLoad: TEzEntity;
var
  P1, P2: TEzPoint;
begin
  Result := nil;
  try
    ReadLine();
    if ReadTwoPoints(P1, P2) then
    begin
      Result := TEzPolyLine.CreateEntity([P1, P2]);
      ReadNextLine();
      ReadPen();
      TEzOpenedEntity(Result).Pentool.FPenStyle := FPen;
    end;
  except
  end;
end;

{ TEzPLineLoader }

function TEzPLineLoader.IntLoad: TEzEntity;
var
  PointCount: Integer;
  PartCount: Integer;
  V: TEzVector;
  Smooth: Boolean;
  aPenStyle: TEzPenStyle;
  I: Integer;
  Cnt: Integer;
begin
  Result := nil;
  try
    Smooth := False;
    PartCount := 1;
    PointCount := 0;
    ReadLine();
    case FMIFInfo.FVersion of
      300, 410, 450, 550:
        if FLineParts.Count > 1 then
        begin
          case FLineParts.Count of
            2:
              TryStrToInt(FLineParts[1], PointCount);
            3:
              begin
                TryStrToInt(FLineParts[2], PartCount);
                ReadNextLine();
                TryStrToInt(FLineParts[0], PointCount);
              end;
          end;
        end
        else
        begin
          ReadNextLine();
          TryStrToInt(FLineParts[0], PointCount);
        end;
      1:
        begin
          TryStrToInt(FLineParts[1], PointCount);
        end;
    else
      TryStrToInt(FLineParts[1], PartCount);
      ReadNextLine();
      TryStrToInt(FLineParts[0], PointCount);
    end;
    for I := 1 to PartCount do
    begin
      if I > 1 then
        TryStrToInt(FLineParts[0], PointCount);
      V := LoadPoints(I, PointCount);
      V.Forget();
      //
      if I = PartCount then
      begin
        if ReadNextLine() then
        begin
          if ReadPen() then
          begin
          aPenStyle.Color := FPen.Color;
          aPenStyle.Style := FPen.Style;
          aPenStyle.Width := FPen.Width;
          end
          else
          begin
            Dec(FLineIndex);
          end;
        end;
        if ReadNextLine() then
        begin
          Smooth := AnsiCompareText(FLineParts[0], 'Smooth') = 0;
          if not Smooth then
            Dec(FLineIndex);
        end;
      end;
      //
      if Smooth then
        Result := TEzSpline.Create(V.Count)
      Else
        Result := TEzPolyLine.Create(V.Count);
      TEzOpenedEntity(Result).PenTool.FPenStyle := aPenStyle;
      //
      Cnt := Result.Points.Count;
      Result.Points.AddVector(V);
      if PartCount > 1 then
      begin
        Result.Points.Parts.Add(Cnt);
        if I <> PartCount then
          ReadNextLine();
      end;
    end;
  except
    Result := nil;
  end;
end;

function TEzPLineLoader.LoadPoints(const PartNum, PointCount: Integer): TEzVector;
var
  I: Integer;
  aPt: TEzPoint;
begin
  Result := TEzVector.Create(1000);
  for I := 1 to PointCount do
  begin
    ReadNextLine();
    if ReadPoint(aPt) then
      Result.Add(aPt);
  end;
end;

{ TEzTextLoader }

function TEzTextLoader.IntLoad: TEzEntity;
var
  S: string;
  I: Integer;
  P1, P2, P3: TEzPoint;
begin
  try
    ReadNextLine();
    S := FLineParts[0];
    for I := 1 to FLineParts.Count - 1 Do
      S := S + ' ' + FLineParts[I];
    S := StringReplace(Trim(S), '"', '', [rfReplaceAll]);
    S := StringReplace(S, '\n', sLineBreak, [rfReplaceAll]);
    //
    ReadNextLine();
    ReadTwoPoints(P1, P2);
    P3.x := P1.x;
    P3.y := P2.y;
    //
    ReadNextLine();
    ReadFont();
    //
    Result := TEzFittedVectorText.CreateEntity(P3, S, Abs(P2.y - P1.y), -1, FFont.Angle);
    TEzFittedVectorText(Result).FontColor := FFont.color;
  except
    Result := nil;
  end;
end;

{ TEzArcLoader }

function TEzArcLoader.IntLoad: TEzEntity;
var
  P1, // lower left
  P2, // top right
  Cnt, // center
  Radius: TEzPoint;
  ArcStart, ArcEnd, A: Double;
  Pt1, Pt2, Pt3: TEzPoint;
begin
  try
    ReadNextLine();
    ReadTwoPoints(P1, P2);
    //
    Radius.X := Abs(P2.X - P1.X) / 2; // ellipse radius X
    Radius.Y := Abs(P2.Y - P1.Y) / 2; // ellipse radius Y
    Cnt.X := (P2.X + P1.X) / 2; // ellipse Center X
    Cnt.Y := (P2.Y + P1.Y) / 2; // ellipse center Y
    //
    TryStrToFloat(FLineParts[5], ArcStart);
    TryStrToFloat(FLineParts[6], ArcEnd);
    ArcStart := DegToRad(ArcStart);
    ArcEnd := DegToRad(ArcEnd);
    //
    A := ArcStart;
    Pt1 := Point2D(Cnt.X + Radius.X * cos(A), Cnt.Y + Radius.Y * sin(A));
    if ArcEnd > ArcStart then
    begin
      A := (ArcEnd + ArcStart) / 2;
    end
    else
    begin
      A := ArcEnd;
      while A < ArcEnd do
        A := A + 2 * Pi;
      A := (A - ArcStart) / 2 + ArcStart;
    end;
    //
    Pt2 := Point2D(Cnt.X + Radius.X * cos(A), Cnt.Y + Radius.Y * sin(A));
    A := ArcEnd;
    Pt3 := Point2D(Cnt.X + Radius.X * cos(A), Cnt.Y + Radius.Y * sin(A));
    //
    Result := TEzArc.CreateEntity(Pt1, Pt2, Pt3);
    //
    ReadNextLine();
    ReadPen();
    TEzArc(Result).PenTool.FPenStyle := FPen;
  except
    Result := nil;
  end;
end;

{ TEzEllipseLoader }

function TEzEllipseLoader.IntLoad: TEzEntity;
var
  P1, P2: TEzPoint;
begin
  try
    ReadLine();
    ReadTwoPoints(P1, P2);
    Result := TEzEllipse.CreateEntity(P1, P2);
    //
    ReadNextLine();
    ReadPen();
    ReadNextLine();
    ReadBrush();
    //
    with TEzClosedEntity(Result) do
    begin
      PenTool.FPenStyle := FPen;
      BrushTool.FBrushStyle := FBrush;
    end;
  except
    Result := nil;
  end;
end;

{ TEzRectangleLoader }

function TEzRectangleLoader.IntLoad: TEzEntity;
var
  P1, P2: TEzPoint;
begin
  try
    ReadLine();
    ReadTwoPoints(P1, P2);
    Result := TEzRectangle.CreateEntity(P1, P2);
    //
    ReadNextLine();
    ReadPen();
    ReadBrush();
    with TEzRectangle(Result) do
    begin
      PenTool.FPenStyle := FPen;
      BrushTool.FBrushStyle := FBrush;
    end;
  except
    Result := nil;
  end;
end;

end.
