unit uMstImportMidMif;

interface

uses
  SysUtils, Classes, Contnrs, StrUtils,
  //
  EzBaseGIS, EzEntities, EzLib,
  //
  uGC,
  //
  uMstImport, uMStImportMifBase, uMStImportMifEntityLoaders, uMStKernelSemantic;

type
  TmstMidMifImport = class(TInterfacedObject, ImstImportLayer)
  private
    procedure DoImport(aSettings: ImstImportSettings);
    procedure ReadHeader(const aFileName: string; aGrapher: TEzGrapher);
    function GetFields: TmstLayerFields;
    function GetFileName: string;
    function GetRecordCount: Integer;
    function GetOnImport: TImportEntityEvent;
    procedure SetOnImport(Value: TImportEntityEvent);
    function GetOnImportError: TImportErrorEvent;
    procedure SetOnImportError(Value: TImportErrorEvent);
    function GetOnImportData: TImportEntityFieldEvent;
    procedure SetOnImportData(Value: TImportEntityFieldEvent);
  strict private
    FFileName: string;
    FFields: TmstLayerFields;
    FMid, FMif: TStringList;
    FMifInfo: TMIFInfo;
    FGrapher: TEzGrapher;
    FOnImportEntity: TImportEntityEvent;
    FOnImportError: TImportErrorEvent;
    FOnImportField: TImportEntityFieldEvent;
    procedure ReadMifHeader();
    procedure ReadRecordCount();
    procedure ParseMifLine(aLine: string; LineParts: TStrings);
    procedure ProcessMifParam(LineParts: TStrings);
    procedure ParseCoordSys(LineParts: TStrings);
    procedure ParseColumns(Idx: Integer);
    procedure ReadMidData(MidRecNo: Integer; aEntity: TEzEntity);
  strict private
    procedure FireImportSuccessEvent(const EntityNo, FileLineNo: Integer; aEntity: TEzEntity);
    procedure FireImportErrorEvent(const EntityNo, FileLineNo: Integer; aException: Exception);
    procedure FireDataFieldEvent(const MidRecNo: Integer; FldValues: TStrings);
  public
    constructor Create;
    destructor Destroy; override;
  end;

  TmstMifObjectReader = class
  private
    FMifInfo: TMIFInfo;
    FEntity: TEzEntity;
    FGrapher: TEzGrapher;
    procedure SetMifInfo(const Value: TMIFInfo);
    function GetEntityLoader(ObjectName: string): TmstMifEntityLoader;
    procedure SetGrapher(const Value: TEzGrapher);
  public
    procedure Clear();
    function Read(MifLines: TStrings; aSettings: ImstImportSettings; StartIndex: Integer): Integer;
    property Grapher: TEzGrapher read FGrapher write SetGrapher;
    property MifInfo: TMIFInfo read FMifInfo write SetMifInfo;
    property Entity: TEzEntity read FEntity;
  end;

implementation

{ TmstMidMifImport }

constructor TmstMidMifImport.Create;
begin
  FMif := TStringList.Create;
  FMid := TStringList.Create;
  FMifInfo := TMIFInfo.Create;
  FFields := TmstLayerFields.Create;
end;

destructor TmstMidMifImport.Destroy;
begin
  FFields.Free;
  FMifInfo.Free;
  FMid.Free;
  FMif.Free;
  inherited;
end;

procedure TmstMidMifImport.DoImport(aSettings: ImstImportSettings);
var
  Reader: TmstMifObjectReader;
  I, I1: Integer;
  DecSep: Char;
  MidRecNo: Integer;
begin
  DecSep := SysUtils.DecimalSeparator;
  try
    SysUtils.DecimalSeparator := '.';
    I := FMif.IndexOf('Data');
    if I >= 0 then
    begin
      Inc(I);
      MidRecNo := 0;
      Reader := TmstMifObjectReader.Create;
      try
        Reader.MifInfo := FMifInfo;
        Reader.Grapher := FGrapher;
        while I < FMif.Count do
        begin
          Reader.Clear();
          I1 := I;
          try
            I := Reader.Read(FMif, aSettings, I);
            if Assigned(Reader.Entity) then
            begin
              FireImportSuccessEvent(MidRecNo, I1, Reader.Entity);
            end
            else
            begin
              FireImportErrorEvent(MidRecNo, I1, nil);
            end;
          except
            on E: Exception do
            begin
              FireImportErrorEvent(MidRecNo, I1, E);
            end;
          end;
          //
          try
            ReadMidData(MidRecNo, Reader.Entity);
          except
            on E: Exception do
            begin
              ShowException(E, ExceptAddr);
            end;
          end;
          Inc(MidRecNo);
          //
          Inc(I);
        end;
      finally
        Reader.Free;
      end;
    end;
  finally
    SysUtils.DecimalSeparator := DecSep;
  end;
end;

procedure TmstMidMifImport.FireDataFieldEvent(const MidRecNo: Integer; FldValues: TStrings);
begin
  if Assigned(FOnImportField) then
  begin
    FOnImportField(Self, MidRecNo, FldValues);
  end;
end;

procedure TmstMidMifImport.FireImportErrorEvent(const EntityNo, FileLineNo: Integer; aException: Exception);
begin
  if Assigned(FOnImportError) then
  begin
    FOnImportError(Self, EntityNo, FileLineNo, aException);
  end;
end;

procedure TmstMidMifImport.FireImportSuccessEvent(const EntityNo, FileLineNo: Integer; aEntity: TEzEntity);
begin
  if Assigned(FOnImportEntity) then
  begin
    FOnImportEntity(Self, EntityNo, FileLineNo, aEntity);
  end;
end;

function TmstMidMifImport.GetFields: TmstLayerFields;
begin
  Result := FFields;
end;

function TmstMidMifImport.GetFileName: string;
begin
  Result := FFileName;
end;

function TmstMidMifImport.GetOnImport: TImportEntityEvent;
begin
  Result := FOnImportEntity;
end;

function TmstMidMifImport.GetOnImportError: TImportErrorEvent;
begin
  Result := FOnImportError;
end;

function TmstMidMifImport.GetOnImportData: TImportEntityFieldEvent;
begin
  Result := FOnImportField;
end;

function TmstMidMifImport.GetRecordCount: Integer;
begin
  Result := FMifInfo.FRecordCount;
end;

procedure TmstMidMifImport.ParseColumns(Idx: Integer);
var
  Splitter: TLineSplitter;
  I: Integer;
  Parts: TStringList;
  ColCount: Integer;
  ColInfo: TMIDColumn;
begin
  Parts := TStringList.Create;
  Parts.Forget();
  //
  Splitter.Line := Trim(FMif[Idx]);
  Splitter.Separator := ' ';
  Splitter.AllowEmptyStrings := False;
  Splitter.Split(Parts);
  //
  if Parts.Count < 2 then
    Exit;
  ColCount := 0;
  TryStrToInt(Parts[1], ColCount);
  if ColCount = 0 then
    Exit;
  //
  FFields.Clear;
  for I := 1 to ColCount do
  begin
    Splitter.Line := Trim(FMif[Idx + I]);
    Splitter.Split(Parts);
    ColInfo := TMIDColumn.Create;
    ColInfo.FName := Parts[0];
    ColInfo.FDataType := Parts[1];
    FMifInfo.FColumns.Add(ColInfo);
    with FFields.AddNew do
    begin
      Name := Parts[0];
      DataTypeName := Parts[1];
      Length := ColInfo.StringLength();
    end;
  end;
//
//        If AnsiCompareText( dbflist[0], 'Char' ) = 0 Then
//          DbType := 'C'
//        Else If AnsiCompareText( dbflist[0], 'Integer' ) = 0 Then
//          Dbtype := 'N'
//        Else If AnsiCompareText( dbflist[0], 'Smallint' ) = 0 Then
//          DbType := 'N'
//        Else If AnsiCompareText( dbflist[0], 'Float' ) = 0 Then
//          DbType := 'N'
//        Else If AnsiCompareText( dbflist[0], 'Decimal' ) = 0 Then
//          DbType := 'N'
//        Else If AnsiCompareText( dbflist[0], 'Date' ) = 0 Then
//          DbType := 'C'
//        //if AnsiCompareText(dbflist[0], 'Date') = 0 then DbType := 'D';
//        Else If AnsiCompareText( dbflist[0], 'Logical' ) = 0 Then
//          DbType := 'L';
end;

procedure TmstMidMifImport.ParseCoordSys(LineParts: TStrings);
var
//  Splitter: TLineSplitter;
  Params: TStringList;
  Param: TParamHandler;
  I: Integer;
  OldSep: Char;
  S: string;
begin
  Params := TStringList.Create;
  Params.Forget();
  //
//  Splitter.Line := Value;
//  Splitter.Separator := FMifInfo.FDelimiter;
//  Splitter.Split(Params);
  //
  if LineParts[1] = 'Earth' then
  begin
    if LineParts.Count > 1 then
    begin
      FMifInfo.FProjectionType := Param.RemoveDelimiters(LineParts[1]);
    end;
    if LineParts.Count > 5 then
    begin
      FMifInfo.FProjectionUnit := Param.RemoveDelimiters(LineParts[5]);
    end;
    if LineParts.Count > 3 then
    begin
      FMifInfo.FProjectionParam[0] := Param.RemoveDelimiters(LineParts[3]);
    end;
    if LineParts.Count > 4 then
    begin
      FMifInfo.FProjectionParam[1] := Param.RemoveDelimiters(LineParts[4]);
    end;
    if LineParts.Count > 6 then
    begin
      FMifInfo.FProjectionParam[2] := Param.RemoveDelimiters(LineParts[6]);
    end;
  end
  else
  if LineParts[1] = 'NonEarth' then
  begin
    FMifInfo.FProjectionType := Param.RemoveDelimiters(LineParts[1]);
    FMifInfo.FProjectionUnit := Param.RemoveDelimiters(LineParts[3]);
    FMifInfo.FProjectionParam[0] := '';
    FMifInfo.FProjectionParam[1] := '';
    FMifInfo.FProjectionParam[2] := '';
  end;
  //Bounds Check
  I := LineParts.IndexOf('Bounds');
  if I >= 0 then
  begin
    OldSep := SysUtils.DecimalSeparator;
    try
      SysUtils.DecimalSeparator := '.';
      S := Param.RemoveDelimiters(LineParts[I + 1]);
      TryStrToFloat(S, FMifInfo.FBounds.X1);
      S := Param.RemoveDelimiters(LineParts[I + 2]);
      TryStrToFloat(S, FMifInfo.FBounds.Y1);
      S := Param.RemoveDelimiters(LineParts[I + 3]);
      TryStrToFloat(S, FMifInfo.FBounds.X2);
      S := Param.RemoveDelimiters(LineParts[I + 4]);
      TryStrToFloat(S, FMifInfo.FBounds.Y2);
    finally
      SysUtils.DecimalSeparator := OldSep;
    end;
  end;
end;

procedure TmstMidMifImport.ParseMifLine(aLine: string; LineParts: TStrings);
var
  Splitter: TLineSplitter;
begin
  LineParts.Clear;
  Splitter.Line := aLine;
  Splitter.Separator := ' ';
  Splitter.AllowEmptyStrings := False;
  Splitter.Split(LineParts);
end;

procedure TmstMidMifImport.ProcessMifParam(LineParts: TStrings);
begin
  if LineParts.Count = 0 then
    Exit;
  //
  if LineParts[0] = 'Version' then
  begin
    if LineParts.Count > 1 then
      TryStrToInt(LineParts[1], FMifInfo.FVersion);
  end
  else
  if LineParts[0] = 'CoordSys' then
  begin
    ParseCoordSys(LineParts);
  end
  else
  if LineParts[0] = 'Charset' then
  begin
    if LineParts.Count > 1 then
      FMifInfo.FCharset := LineParts[1];
  end
  else
  if LineParts[0] = 'Delimiter' then
  begin
    FMifInfo.FDelimiter := LineParts[1][1];
  end;
end;

procedure TmstMidMifImport.ReadMidData(MidRecNo: Integer; aEntity: TEzEntity);
var
//  FldValue: string;
  Splitter: TLineSplitter;
  FieldValues: TStringList;
//  J: Integer;
//  Col: TMIDColumn;
begin
  if MidRecNo <= Pred(FMid.Count) then
  begin
    Splitter.Line := FMid[MidRecNo];
    Splitter.Separator := FMifInfo.FDelimiter;
    Splitter.AllowEmptyStrings := True;
    FieldValues := TStringList.Create;
    FieldValues.Forget();
    FieldValues.StrictDelimiter := True;
    FieldValues.Delimiter := #0;
    Splitter.Split(FieldValues);
    FireDataFieldEvent(MidRecNo, FieldValues);
//    for J := 0 to FMifInfo.ColumnCount - 1 do
//    begin
//      FldValue := '';
//      Col := FMifInfo.Columns[J];
//      if J < FieldValues.Count then
//        FldValue := FieldValues[J];
//      FireDataFieldEvent(MidRecNo, Col.FName, FldValue);
//    end;
  end;
end;

procedure TmstMidMifImport.ReadMifHeader;
var
  I: Integer;
  S: string;
  LineParts: TStringList;
begin
  LineParts := TStringList.Create;
  LineParts.Forget();
  I := 0;
  while I < FMif.Count do
  begin
    S := Trim(FMif[I]);
    if S = 'Data' then
      Exit;
    if Pos('Columns', S) > 0 then
    begin
      ParseColumns(I);
      Exit;
    end
    else
      if S <> '' then
      begin
        ParseMifLine(S, LineParts);
        ProcessMifParam(LineParts);
      end;
    Inc(I);
  end;
end;

procedure TmstMidMifImport.ReadRecordCount;
var
  I, J, Cnt: Integer;
  S: string;
begin
  FMifInfo.FRecordCount := 0;
  I := FMif.IndexOf('Data');
  if I < 0 then
    Exit;
  Cnt := 0;
  for J := I + 1 to FMIF.Count - 1 do
  begin
    S := Trim(FMIF[J]);
    if S <> '' then
    begin
      S := UpperCase(S);
      if (Pos('NONE', S) = 1)
         or
         (Pos('POINT', S) = 1)
         or
         (Pos('REGION', S) = 1)
         or
         (Pos('LINE', S) = 1)
         or
         (Pos('PLINE', S) = 1)
         or
         (Pos('TEXT', S) = 1)
         or
         (Pos('ARC', S) = 1)
         or
         (Pos('ELLIPSE', S) = 1)
         or
         (Pos('RECT', S) = 1)
         or
         (Pos('ROUNDRECT', S) = 1)
         or
         (Pos('MULTIPOINT', S) = 1)
      then
        Inc(Cnt);
    end;
  end;
  FMifInfo.FRecordCount := Cnt;
end;

procedure TmstMidMifImport.SetOnImport(Value: TImportEntityEvent);
begin
  FOnImportEntity := Value;
end;

procedure TmstMidMifImport.SetOnImportError(Value: TImportErrorEvent);
begin
  FOnImportError := Value;
end;

procedure TmstMidMifImport.SetOnImportData(Value: TImportEntityFieldEvent);
begin
  FOnImportField := Value;
end;

procedure TmstMidMifImport.ReadHeader(const aFileName: string; aGrapher: TEzGrapher);
var
  aFile: string;
begin
  FGrapher := aGrapher;
  //
  FFileName := aFileName;
  aFile := ChangeFileExt(aFilename, '.mif');
  FMif.Clear;
  FMif.LoadFromFile(aFile);
  aFile := ChangeFileExt(aFilename, '.mid');
  FMid.Clear;
  FMid.LoadFromFile(aFile);
  // читаем параметры файла
  ReadMifHeader();
  // подсчитать количество объектов
  ReadRecordCount();
end;

{ TmstMifObjectReader }

procedure TmstMifObjectReader.Clear();
begin
  FreeAndNil(FEntity);
end;

function TmstMifObjectReader.GetEntityLoader(ObjectName: string): TmstMifEntityLoader;
begin
  Result := nil;
  if Pos('NONE ', ObjectName) = 1 then
  begin
    Result := TEzNoneLoader.Create();
  end
  else
  if Pos('POINT ', ObjectName) = 1 then
  begin
    Result := TEzPointLoader.Create();
  end
  else
  if Pos('REGION ', ObjectName) = 1 then
  begin
    Result := TEzRegionLoader.Create;
  end
  else
  if Pos('LINE ', ObjectName) = 1 then
  begin
    Result := TEzLineLoader.Create;
  end
  else
  if Pos('PLINE ', ObjectName) = 1 then
  begin
    Result := TEzPlineLoader.Create;
  end
  else
  if Pos('TEXT ', ObjectName) = 1 then
  begin
    Result := TEzTextLoader.Create;
  end
  else
  if Pos('ARC ', ObjectName) = 1 then
  begin
    Result := TEzArcLoader.Create;
  end
  else
  if Pos('ELLIPSE ', ObjectName) = 1 then
  begin
    Result := TEzEllipseLoader.Create;
  end
  else
  if Pos('RECT ', ObjectName) = 1 then
  begin
    Result := TEzRectangleLoader.Create;
  end
  else
  if Pos('ROUNDRECT ', ObjectName) = 1 then
  begin
    Result := TEzRectangleLoader.Create;
  end;
end;

function TmstMifObjectReader.Read(MifLines: TStrings; aSettings: ImstImportSettings; StartIndex: Integer): Integer;
var
  S: string;
  Loader: TmstMifEntityLoader;
  I: Integer;
begin
  Result := StartIndex;
  //
  S := AnsiUpperCase(MifLines[StartIndex]);
  Loader := GetEntityLoader(S);
  if not Assigned(Loader) then
  begin
    I := StartIndex + 1;
    while I < MifLines.Count do
    begin
      S := AnsiUpperCase(MifLines[I]);
      Loader := GetEntityLoader(S);
      if Assigned(Loader) then
      begin
        Result := I;
        Break;
      end;
      Inc(I);
    end;
    if not Assigned(Loader) then
    begin
      Result := StartIndex;
      Exit;
    end;
  end;
  if Assigned(Loader) then
  begin
    Loader.MIFInfo := FMifInfo;
    Loader.MIFLines := MifLines;
    Loader.LineIndex := StartIndex;
    Loader.Grapher := FGrapher;
    Loader.Settings := aSettings;
    FEntity := Loader.Load();
    Result := Loader.LineIndex;
  end;
end;

procedure TmstMifObjectReader.SetGrapher(const Value: TEzGrapher);
begin
  FGrapher := Value;
end;

procedure TmstMifObjectReader.SetMifInfo(const Value: TMIFInfo);
begin
  FMifInfo := Value;
end;

end.
