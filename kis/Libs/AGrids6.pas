unit AGrids6;

interface

uses
  SysUtils, Windows, DBGrids, AProc6, AString6, Forms, Classes, IniFiles;

  function GetActiveGrid: TDBGrid;
  function ColumnByFieldName(Grid: TDBGrid; const FieldName: String): TColumn;
//  procedure ReadGridProperties(Grid: TDBGrid; Ini: TIniFile);
//  procedure WriteGridProperties(Grid: TDBGrid; Ini: TIniFile);
  procedure RestoreGridDefaults(Grid: TDBGrid);

implementation

function GetActiveGrid: TDBGrid;
begin
  Result := nil;
  if Assigned(Screen.ActiveForm) then
    Result := TDBGrid(FindChildControlByClass(Screen.ActiveForm, TCustomDBGrid));
end;

function ColumnByFieldName(Grid: TDBGrid; const FieldName: String): TColumn;
var
  I: Integer;
begin
  Result := nil;
  try
//    with Grid.Columns do
      for I := 0 to Pred(Grid.Columns.Count) do
        if AnsiCompareText(Grid.Columns[I].{Field.}FieldName, FieldName) = 0 then
        begin
          Result := Grid.Columns[I];
          Exit;
        end;
  except
  end;
{  if Result = nil then
    raise Exception.Create('Колонка не найдена: '+FieldName);}
end;

function ColumnByFieldOrigin(Grid: TDBGrid; const FieldOrigin: String): TColumn;
var
  I: Integer;
begin
  Result := nil;
  with Grid.Columns do
    for I := 0 to Pred(Count) do
      if AnsiCompareText(Items[I].Field.Origin, FieldOrigin) = 0 then
      begin
        Result := Items[I];
        Exit;
      end;
{  if Result = nil then
    raise Exception.Create('Колонка не найдена: '+FieldName);}
end;
{
procedure ReadGridProperties(Grid: TDBGrid; Ini: TIniFile);
var
  I, J: Integer;
  St: string;
  Col: TColumn;
  Cols: TStringList;
begin
  with Grid do begin
    //устанавливаем сначала положение, потом - ширину,
    //иначе ширина не устанавливается
    //сначала загоняем колонки в Cols, где сортируем
    Cols:=TStringList.Create;
    try
      for I:=0 to Columns.Count-1 do begin
        St := ReadProperty(Grid,'Columns.' + Columns[I].FieldName, varString, Ini);
        if St<>'' then begin
          J:=StrToInt(GetNextWord(St));
          if J in [0..Columns.Count-1] then Cols.Add(Format('%4d',[J])+'='+
            Columns[I].FieldName);
        end;
      end;
      Cols.Sort;
      for I:=0 to Cols.Count-1 do begin
        Col:=ColumnByFieldName(Grid,GetParamValue(Cols[I]));
        if Col<>nil then
          Col.Index:=StrToInt(GetParamName(Cols[I]));
      end;
    finally
      Cols.Free;
    end;
    for I:=0 to Columns.Count-1 do begin
      St:=ReadProperty(Grid,'Columns.'+Columns[I].FieldName,varString, Ini);
      if St<>'' then begin
        GetNextWord(St);
        Columns[I].Width:=StrToInt(GetNextWord(St));
      end;
    end;
  end;
end;

procedure WriteGridProperties(Grid: TDBGrid; Ini: TIniFile);
var
  I: Integer;
begin
  with Grid do
    for I:=0 to Columns.Count-1 do
      WriteProperty(Grid,'Columns.'+Columns[I].FieldName,
        IntToStr(Columns[I].Index)+','+IntToStr(Columns[I].Width), Ini);
end; }

procedure RestoreGridDefaults(Grid: TDBGrid);
var
  I: Integer;
begin
  with Grid.Columns do
    for I := 0 to Pred(Count) do
    begin
      Items[I].Index := Items[I].Id;
      Items[I].Width := Items[I].DefaultWidth;
    end;
end;

end.
