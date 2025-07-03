unit uMStClassesPointsImport;

interface

uses
  SysUtils, Classes, Contnrs, StrUtils;

type
  TmstImportedPointsColumn = class(TStringList)
  private
    function GetCoord(Idx: Integer): Double;
  public
    function IsFloat: Boolean;
    function IsEmpty: Boolean;
    function IsInteger: Boolean;
    //
    property Coord[Idx: Integer]: Double read GetCoord;
  end;

  TmstImportedPointList = class
  private
    FColumns: TObjectList;
    FReplaceOldPoints: Boolean;
    FXIndex: Integer;
    FSeparator: Char;
    FYIndex: Integer;
    FText: String;
    procedure SetReplaceOldPoints(const Value: Boolean);
    function GetColumns(Index: Integer): TmstImportedPointsColumn;
    procedure SetSeparator(const Value: Char);
    procedure SetText(const Value: String);
    procedure Build;
  private
    class var FLastSeparator: Char;
    class procedure SetLastSeparator(const Value: Char); static;
    function GetColCount: Integer;
  public
    class property LastSeparator: Char read FLastSeparator write SetLastSeparator;
  public
    constructor Create;
    destructor Destroy; override;
    //
    property Separator: Char read FSeparator write SetSeparator;
    property ColCount: Integer read GetColCount;
    property Columns[Index: Integer]: TmstImportedPointsColumn read GetColumns;
    property ReplaceOldPoints: Boolean read FReplaceOldPoints write SetReplaceOldPoints;
    property Text: String read FText write SetText;
    property XIndex: Integer read FXIndex write FXIndex;
    property YIndex: Integer read FYIndex write FYIndex;
  end;

implementation

{ TmstImportedPointList }

procedure TmstImportedPointList.Build;
var
  SL: TStringList;
  I, J, K, L, MaxK: Integer;
  S: String;
  Col: TmstImportedPointsColumn;
  NumColIndex: Integer;
begin
  FXIndex := -1;
  FYIndex := -1;
  SL := TStringList.Create;
  try
    SL.Text := Self.FText;
    // Считаем количество колонок для каждой строки
    MaxK := 0;
    for I := 0 to Pred(SL.Count) do
    begin
      K := 0;
      S := SL[I];
      L := Length(S);
      for J := 1 to L do
        if S[J] = FSeparator then
          if J < L then
            Inc(K);
      if K > 200 then
        raise Exception.Create('Неверный формат данных для импорта координат!');
      SL.Objects[I] := Pointer(K);
      if MaxK < K then
        MaxK := K;
    end;
    // Создаем колонки
    FColumns.Clear;
    for I := 0 to MaxK do
    begin
      Col := TmstImportedPointsColumn.Create;
      FColumns.Add(Col);
      Col.Text := DupeString(#13#10, SL.Count);
    end;
    // Заполняем колонки данными
    for I := 0 to Pred(SL.Count) do
    begin
      K := 0;
      S := SL[I];
      J := 1;
      while J <= Length(S) do
//      for J := 1 to Length(S) do
        if S[J] = FSeparator then
        begin
          Self.Columns[K].Strings[I] := Copy(S, 1, Pred(J));
          System.Delete(S, 1, J);
          Inc(K);
          J := 1;
        end
        else
          Inc(J);

      if Length(S) > 0 then
        Self.Columns[K].Strings[I] := S;
    end;
    // Удаляем пустые колонки
    for I := Pred(FColumns.Count) downto 0 do
      if Self.Columns[I].IsEmpty then
        FColumns.Delete(I);
    //
    if Self.ColCount > 1 then
    begin
      NumColIndex := -1;
      // найти номера точек
      for I := 0 to Self.ColCount - 1 do
      begin
        if Self.Columns[I].IsInteger then
        begin
          NumColIndex := I;
          Break;
        end;
      end;
      // найти координаты
      for I := 0 to Self.ColCount - 1 do
      begin
        if I <> NumColIndex then
          if Self.Columns[I].IsFloat then
          begin
            Self.XIndex := I;
            Break;
          end;
      end;
      if Self.XIndex >= 0 then
      begin
        for I := Self.XIndex + 1 to Self.ColCount - 1 do
        begin
          if I <> NumColIndex then
            if Self.Columns[I].IsFloat then
            begin
              Self.YIndex := I;
              Break;
            end;
        end;
      end;
      //
      if (Self.YIndex < 0) and (Self.XIndex >= 0) then
      begin
        for I := 0 to Self.ColCount - 1 do
        begin
          if Self.Columns[I].IsFloat then
          begin
            Self.XIndex := I;
            Break;
          end;
        end;
        if Self.XIndex >= 0 then
        begin
          for I := Self.XIndex + 1 to Self.ColCount - 1 do
          begin
            if Self.Columns[I].IsFloat then
            begin
              Self.YIndex := I;
              Break;
            end;
          end;
        end;
      end;
    end;
  finally
    SL.Free;
  end;
end;

constructor TmstImportedPointList.Create;
begin
  if FLastSeparator = #0 then
    FLastSeparator := ';';
  FColumns := TObjectList.Create;
  FSeparator := FLastSeparator;
  FXIndex := -1;
  FYIndex := -1;
end;

destructor TmstImportedPointList.Destroy;
begin
  FColumns.Free;
  inherited;
end;

function TmstImportedPointList.GetColCount: Integer;
begin
  Result := FColumns.Count;
end;

function TmstImportedPointList.GetColumns(Index: Integer): TmstImportedPointsColumn;
begin
  Result := TmstImportedPointsColumn(FColumns[Index]);
end;

class procedure TmstImportedPointList.SetLastSeparator(const Value: Char);
begin
  FLastSeparator := Value;
end;

procedure TmstImportedPointList.SetReplaceOldPoints(const Value: Boolean);
begin
  FReplaceOldPoints := Value;
end;

procedure TmstImportedPointList.SetSeparator(const Value: Char);
begin
  if FSeparator <> Value then
  begin
    FSeparator := Value;
    Build;
  end;
end;

procedure TmstImportedPointList.SetText(const Value: String);
begin
  if FText <> Value then
  begin
    FText := Value;
    Build;
  end;
end;

{ TmstImportedPointsColumn }

function TmstImportedPointsColumn.GetCoord(Idx: Integer): Double;
var
  S: string;
begin
  Result := -1;
  S := Strings[Idx];
  S := StringReplace(S, '.', DecimalSeparator, []);
  S := StringReplace(S, ',', DecimalSeparator, []);
  TryStrToFloat(S, Result);  
end;

function TmstImportedPointsColumn.IsEmpty: Boolean;
begin
  Result := Trim(Text) = '';
end;

function TmstImportedPointsColumn.IsFloat: Boolean;
var
  I: Integer;
  F: Double;
begin
  Result := False;
  for I := 0 to Pred(Count) do
    if not TryStrToFloat(Strings[I], F) then
      Exit;
  Result := True;
end;

function TmstImportedPointsColumn.IsInteger: Boolean;
var
  I: Integer;
  Dummy: Integer;
begin
  Result := False;
  for I := 0 to Pred(Count) do
    if not TryStrToInt(Strings[I], Dummy) then
      Exit;
  Result := True;
end;

end.
