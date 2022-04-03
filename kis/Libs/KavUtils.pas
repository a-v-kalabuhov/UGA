{*******************************************************}
{                                                       }
{       "ИС МП УГА"                                     }
{       Geomerty Utilities Unit                         }
{                                                       }
{       Copyright (c) 2003, Калабухов А.В.              }
{                                                       }
{       Автор: Калабухов А.В.                           }
{                                                       }
{*******************************************************}

{ Описание:
  Имя модуля:
  Версия: 1.0
  Дата последнего изменения: 16.08.2003
  Цель: содержит геометрические утилиты.
  Используется:
  Использует:   
  Исключения:   
  Вывод в БД:
  Вывод:
  До вызова:
  После вызова:   }
  
unit KavUtils;

interface

uses Classes;

type
  TSquare = record
    X0: Real;
    Y0: Real;
    Crossings: Integer;
    Name: ShortString;
    Checked: Boolean;
    Neighbours: Integer;
  end;

  TSquares = array of TSquare;

  TGeomLineKind = (glkVertical, glkHorizontal, glkOther);

  TGeomLine = record
    case kind: TGeomLineKind of
    glkHorizontal : (X: Real);
    glkVertical : (Y: Real);
    glkOther : (K, A: Real);
  end;


//  function GetMapCaseCoord(const Nomen: String; var x1, y1: Real): Boolean;
  function IsCrossedPieces(A1x, A1y, B1x, B1y, A2x, A2y, B2x, B2y: Real): Boolean;
  procedure CheckMapMatrix(var matrix: array of TSquares);

implementation

uses AProc6, Math, Geodesy, Dialogs, SysUtils, Types, uCommonUtils;

const
  SqSz = 250;

function IsCrossedPieces(A1x, A1y, B1x, B1y, A2x, A2y, B2x, B2y: Real): Boolean;
var
  line1, line2: TGeomLine;
  y, x: Real;

  function Cover(x1, x2, x_1, x_2: Real): Boolean;
  begin
    result := (((x1 >= x_1) and (x1 <= x_2)) or ((x2 >= x_1) and (x2 <= x_2))) or
              (((x_1 >= x1) and (x_1 <= x2)) or ((x_2 >= x1) and (x_2 <= x2))) or
              (((x1 >= x_1) and (x2 <= x_2)) or ((x_1 >= x1) and (x_2 <= x2)));
  end;

begin
  result := False;
  if A1x = B1x then
  begin
    line1.kind := glkHorizontal;
    line1.X := A1x;
  end
  else
  if A1y = B1y then
  begin
    line1.kind := glkVertical;
    line1.Y := A1y;
  end
  else
  begin
    line1.kind := glkOther;
    line1.K := (A1x - B1x) / (A1y - B1y);
    line1.A := A1x - line1.K * A1y;
  end;

  if A2x = B2x then
  begin
    line2.kind := glkHorizontal;
    line2.X := A2x;
  end
  else
  if A2y = B2y then
  begin
    line2.kind := glkVertical;
    line2.Y := A2y;
  end
  else
  begin
  line2.kind := glkOther;
    line2.K := (A2x - B2x) / (A2y - B2y);
    line2.A := A2x - line2.K * A2y;
  end;

  case line1.kind of
  glkHorizontal : begin
                  case line2.kind of
                  glkHorizontal : if line1.X = line2.X then
                                result := Cover(A1x, B1x, A2x, B2x);
                  glkVertical : result := Cover(A1x, B1x, A2x, B2x) and Cover(A1y, B1y, A2y, B2y);
                  glkOther : begin
                               y := (line1.X - line2.A) / line2.K;
                               result := (y >= A1y) and (y <= B1y);
                             end;
                  end;
                end;
  glkVertical : begin
                  case line2.kind of
                  glkHorizontal : result := Cover(A1x, B1x, A2x, B2x) and Cover(A1y, B1y, A2y, B2y);
                  glkVertical : if line1.Y = line2.Y then
                                result := Cover(A1y, B1y, A2y, B2y);
                  glkOther : begin
                               x := line2.A + line2.K * line1.Y;
                               result := (x >= A1x) and (x <= B1x);
                             end;
                  end;
                end;
  glkOther : begin
                case line2.kind of
                glkHorizontal : begin
                                  y := (line2.X - line1.A) / line1.K;
                                  result := (y >= A1y) and (y <= B1y);
                                end;
                glkVertical : begin
                                x := line1.A + line1.K * line2.Y;
                                result := (x >= A1x) and (x <= B1x);
                              end;
                glkOther : begin
                             if line1.K <> line2.K then
                             begin
                               y := (line2.A - line1.A) / (line1.K - line2.K);
                               x := line2.A + line2.K * y;
                               result := (((x >= A1x) and (x <= B1x)) and ((y >= A1y) and (y <= B1y))) and
                                         (((x >= A2x) and (x <= B2x)) and ((y >= A2y) and (y <= B2y)));
                             end
                             else
                               result := Cover(A1x, B1x, A2x, B2x) and Cover(A1y, B1y, A2y, B2y);
                           end;
                end;
             end;
  end;

end;

procedure CheckMapMatrix(var matrix: array of TSquares);
var
  path, begins, suspicious: array of TPoint;
  i, j, k: Integer;
  prev: TPoint;
  path_found, path_is_bad: Boolean;

  function AddToPath(p: TPoint): Boolean;
  var
    i1: Integer;
  begin
    for i1:= 0 to High(Path) do
      if (Path[i1].X = p.X) and (Path[i1].Y = p.Y) then
      begin
        result := False;
        exit;
      end;
    result := True;
    SetLength(path, Length(path) + 1);
    path[High(path)] := p;
  end;

  function AddToBegins(p: TPoint): Boolean;
  var
    i1: Integer;
  begin
    for i1:= 0 to High(Begins) do
      if (Begins[i1].X = p.X) and (Begins[i1].Y = p.Y) then
      begin
        result := False;
        exit;
      end;
    result := True;
    SetLength(Begins, Length(Begins) + 1);
    Begins[High(Begins)] := p;
  end;

  function GetFromBegins(var p: TPoint): Boolean;
  begin
    if Length(begins) > 0 then
    begin
      p := begins[High(begins)];
      SetLength(begins, Length(begins) - 1);
      result := True;
    end
    else
    begin
      result := False;
    end;
  end;

  procedure MarkPath;
  var
    i1, j1, k1: Integer;
    cr: SmallInt;
  begin
    if path_is_bad then cr := 0 else cr := 1;
    for i1 := 0 to High(Path) do
    begin
      matrix[path[i1].X, path[i1].y].Checked := True;
      matrix[path[i1].X, path[i1].y].Crossings := cr;
      for j1 := k to High(suspicious) do
        if (suspicious[j1].X = path[i1].X) and (suspicious[j1].Y = path[i1].Y) then
        begin
          for k1 := j1 to High(suspicious) - 1 do
            suspicious[k1] := suspicious[k1 + 1];
          SetLength(suspicious, Length(suspicious) - 1);
        end;
    end;
  end;

  function InPath(p: TPoint): Boolean;
  var
    i1: Integer;
  begin
    result := False;
    for i1 := 0 to High(path) do
      if (p.X = path[i1].X) and (p.Y = path[i1].Y) then
      begin
        result := True;
        exit;
      end;
  end;

  function FindNext(var pnt: TPoint): Boolean;
  var
    i1, j1: Integer;
  begin
    i1 := -1;
    j1 := -1;
    result := False;
    if (matrix[pnt.X + 1, pnt.Y].Crossings = 0) and
       (not matrix[pnt.X + 1, pnt.Y].Checked)
       and not InPath(Types.Point(pnt.X + 1, pnt.Y)) then
    begin
      result := True;
      i1 := pnt.X + 1;
      j1 := pnt.Y;
    end;
    if (matrix[pnt.X, pnt.Y + 1].Crossings = 0) and
       (not matrix[pnt.X, pnt.Y + 1].Checked) and not InPath(Types.Point(pnt.X, pnt.Y + 1)) then
    begin
      if not result then
      begin
        result := True;
        i1 := pnt.X;
        j1 := pnt.Y + 1;
      end
      else
        AddToBegins(Types.Point(pnt.X, pnt.Y + 1));
    end;
    if (matrix[pnt.X - 1, pnt.Y].Crossings = 0) and
       (not matrix[pnt.X - 1, pnt.Y].Checked) and not InPath(Types.Point(pnt.X - 1, pnt.Y)) then
    begin
      if not result then
      begin
        result := True;
        i1 := pnt.X - 1;
        j1 := pnt.Y;
      end
      else
        AddToBegins(Types.Point(pnt.X - 1, pnt.Y));
    end;
    if (matrix[pnt.X, pnt.Y - 1].Crossings = 0) and
       (not matrix[pnt.X, pnt.Y - 1].Checked) and not InPath(Types.Point(pnt.X, pnt.Y - 1)) then
    begin
      if not result then
      begin
        result := True;
        i1 := pnt.X;
        j1 := pnt.Y - 1;
      end
      else
        AddToBegins(Types.Point(pnt.X, pnt.Y - 1));
    end;
    if result then
    begin
      pnt.X := i1;
      pnt.Y := j1;
    end;
  end;

begin
  SetLength(suspicious, 0);
  // Ищем "подозрительные" планшеты
  for i := 1 to Length(matrix) - 2 do
  for j := 1 to Length(matrix[i]) - 2 do
  begin
    if (matrix[i, j].Crossings = 0) and (matrix[i - 1, j].Crossings = 1) then
    begin
      SetLength(suspicious, Length(suspicious) + 1);
      suspicious[High(suspicious)].X := i;
      suspicious[High(suspicious)].Y := j;
    end;
  end;

  if Length(suspicious) <> 0 then
  begin
    // Просматриваем их
    k := 0;
    while k < Length(suspicious) do
    begin
      SetLength(path, 0);
      SetLength(begins, 0);
      prev := suspicious[k];
      AddToPath(prev);
      path_found := False;
      path_is_bad := False;
      while not path_found do
      begin
        if FindNext(prev) then
        begin
          if not path_is_bad then
            path_is_bad := (prev.X = 0) or (prev.X = High(Matrix)) or
                           (prev.Y = 0) or (prev.Y = High(Matrix[0]));
          AddToPath(prev);
          continue;
        end
        else
        begin
          if GetFromBegins(prev) then
          begin
            if not path_is_bad then
              path_is_bad := (prev.X = 0) or (prev.X = High(Matrix)) or
                             (prev.Y = 0) or (prev.Y = High(Matrix[0]));
            AddToPath(prev);
            continue;
          end
          else
          begin
            MarkPath;
            path_found := True;
            inc(k);
          end;
        end;
      end;
    end;
  end;
end;

end.
