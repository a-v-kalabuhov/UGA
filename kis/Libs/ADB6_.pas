unit ADB6;

interface

uses
  Classes, SysUtils, DB, AProc6, Math, DbGrids, dbctrls, Controls, Windows;

type
  TClauseRecord=record
    Text: string[10];
    Line: ShortInt;
  end;

  TRelationType=(rtNone, rtLeftJoin, rtRightJoin);

  TSQLClause=(scNormalized,scSelect,scFrom,scWhere,scGroupBy,scHaving,scUnion,
    scPlan,scOrderBy,scForUpdate,scAnd,scOr,scLike,scAs);

const
  MemoTypes=[ftBlob,ftMemo,ftFmtMemo];
  StringTypes=[ftString,ftWideString];

  Keywords = 'LEFT,RIGHT,OUTER,JOIN';

  procedure SQLWriteClause(SQL: TStrings; Clause: TSQLClause; Expression: string);
  procedure SQLAddCondition(var Conditions: String; const NewCondition: String);
  procedure SQLDelLastCondition(var Conditions: String);
  function SQLCheckCondition(SQL: TStrings; const Condition: String): Boolean;
  procedure SQLAddWhereCondition(SQL: TStrings; const WhereCondition: String);
  function GetStringCondition(FieldName,FindStr: string; FieldType: TFieldType;
  Options: TFindOptions): string;
  procedure SQLAddWhereByField(SQL: TStrings; Field: TField; FindStr: string;
    FindOptions: TFindOptions);
  procedure ResetDataSet(DataSet: TDataSet);
  function SQLGetPrimaryFieldName(SQL: TStrings; FieldName: string): string;
  function SQLGetPrimaryTable(SQL: TStrings): string;
  function SQLGetTables(SQL: TStrings): String;
  procedure SQLDeleteCondition(var WhereClause: String; const Condition: String);

implementation

uses
  AString6, Strutils;

var
  Clauses: array[Low(TSQLClause)..High(TSQLClause)] of TClauseRecord;
  ClausesLineCount: Integer;

function SQLIsNormalized(SQL: TStrings): Boolean;
begin
  Result:=(SQL.Count>0)and(Pos(Clauses[scNormalized].Text,
    SQL[Clauses[scNormalized].Line])>0);
end;

//читает выражение из запроса
function SQLReadClause(SQL: TStrings; Clause: TSQLClause): string;
var
  Line: Integer;
  SQLLine: String;
begin
  SQLCheckNormalized(SQL);
  Line := Clauses[Clause].Line;
  SQLLine := SQL[Line];
  Delete(SQLLine, 1, Length(Clauses[Clause].Text));
  Result := Trim(SQLLine);
  //Result := Trim(Copy(SQL[Line], Length(Clauses[Clause].Text)+2,Length(SQL[Line])));
end;

//пишет новое выражение в запрос
procedure SQLWriteClause(SQL: TStrings; Clause: TSQLClause; Expression: string);
var
  Line: Integer;
begin
  SQLCheckNormalized(SQL);
  Line:=Clauses[Clause].Line;
  if Empty(Expression) then
    SQL[Line] := ''
  else
    SQL[Line] := Clauses[Clause].Text + ' ' + Expression;
end;

//проверка нормализованности запроса
procedure SQLCheckNormalized(SQL: TStrings);
begin
  if not SQLIsNormalized(SQL) then
    raise Exception.Create(stNotNormalized);
end;

//переоткрывает запрос, например, в случае изменения данных
procedure ResetDataSet(DataSet: TDataSet);
var
  CurId: Integer;
begin
  with DataSet do begin
    DisableControls;
    CurId:=0;
    if UpperCase(Fields[0].FieldName)='ID' then
      CurId := Fields[0].AsInteger;
    Close;
    Open;
    if CurId > 0 then Locate('ID', CurId, []);
    EnableControls;
  end;
end;

//вставляет новое условие в WHERE
procedure SQLAddWhereCondition(SQL: TStrings; const WhereCondition: String);
var
  WhereSt: String;
begin
  WhereSt := SQLReadClause(SQL,scWhere);
  SQLAddCondition(WhereSt, WhereCondition);
  SQLWriteClause(SQL, scWhere, WhereSt);
end;

//вставляет новое условие в условия
procedure SQLAddCondition(var Conditions: String; const NewCondition: String);
begin
  if Conditions = '' then
    Conditions := BracketStr(NewCondition)
  else
    Conditions := Conditions + Clauses[scAnd].Text + BracketStr(NewCondition);
end;

// Проверяет наличие условия
function SQLCheckCondition(SQL: TStrings; const Condition: String): Boolean;
begin
  Result := Pos(Condition, SQLReadClause(SQL, scWhere)) > 0;
end;

//удаляет последнее условие
procedure SQLDelLastCondition(var Conditions: string);
var
  I: Integer;
begin
  I:=RPos(Clauses[scAnd].Text,Conditions);
  if I=0 then
    Conditions:=''
  else
    Conditions:=Trim(Copy(Conditions,1,I-1));
end;

//добавляет в запрос условие поиска
procedure SQLAddWhereByField(SQL: TStrings; Field: TField; FindStr: string;
  FindOptions: TFindOptions);
var
  FieldName: string;
begin
  FieldName:=Field.FieldName;
  if Field.FieldKind in [fkData, fkInternalCalc, fkLookup] then
    FieldName:=SQLGetPrimaryFieldName(SQL,FieldName)
  else
    raise Exception.Create('Поиск по данному полю невозможен');
  SQLAddWhereCondition(SQL,GetStringCondition(FieldName,FindStr,Field.DataType,
    FindOptions));
end;

//возвращает первичную таблицу запроса
function SQLGetPrimaryTable(SQL: TStrings): string;
var
  St: string;
begin
  St:=SQLReadClause(SQL,scFrom);
  Result:=GetNextWord(St);
end;

//возвращает таблицы запроса в виде: 'TABLE1=A;TABLE2=B',
//где NABLE1 - название таблицы, A - ее алиас

function SQLGetTables(SQL: TStrings): string;
var
  I, Pos1, Pos2: Integer;
begin
  Result:=SQLReadClause(SQL,scFrom);
  //меняем 'JOIN' на ','
  ReplaceString('JOIN',',',Result);
  //удаляем ключевые слова
  RemoveWords('LEFT,RIGHT,OUTER',Result);
  //удаляем условия связи ON...
  while DoublePos(' ON ',',',Result,Pos1,Pos2) do
    Delete(Result,Pos1,Pos2-Pos1);
  if Pos1>0 then Delete(Result,Pos1,Length(Result));
  //удаляем ненужные пробелы
  Result:=Trim(Result);
  for I:=Length(Result)-1 downto 2 do
    if (Result[I]=' ')and((Result[I-1]=' ')or(Result[I-1]=',')or(Result[I+1]=',')) then
      Delete(Result,I,1);
  ReplaceString(' ','=',Result);
end;

//возвращает первичное имя поля по итоговому полю запроса, например "NAME" -> "A.NAME"
//предполагается, что все названия результирующих полей задаются вручную
//(родное название или "AS")
function SQLGetPrimaryFieldName(SQL: TStrings; FieldName: string): string;
var
  Fields, Field: string;
  I: Integer;
begin
  SQLCheckNormalized(SQL);
  Fields:=SQLReadClause(SQL,scSelect);
  FieldName:=AnsiUpperCase(Trim(FieldName));
  while Fields<>'' do begin
    I:=Pos(',',Fields);
    if I=0 then I:=Length(Fields)+1;
    Field:=Copy(Fields,1,I-1);
    Fields:=Copy(Fields,I+1,Length(Fields));
    I:=WholeWordPos('AS',Field);
    //если поле переименовано
    if I>0 then begin
      if Copy(Field,I+3,Length(FieldName))=FieldName then
        Result:=Copy(Field,1,I-2);
    end
    else if WholeWordPos(FieldName,Field)>0 then
      Result:=Trim(Field);
    if Result<>'' then Break;
  end;
end;

//строку вида 'городской совет' превращает в строку
//"UPPER(FIELDNAME) LIKE '%ГОРОДСКОЙ%СОВЕТ%'"
function GetStringCondition(FieldName,FindStr: string; FieldType: TFieldType;
  Options: TFindOptions): string;
const
  StringTypes=[ftString,ftMemo,ftFmtMemo,ftWideString];
  QuotedTypes=StringTypes+[ftDate,ftTime,ftDateTime];
var
  Mask,Upper: Boolean;
begin
  FieldName := Trim(FieldName);
  FindStr := Trim(FindStr);
  //определяем, надо ли преобразовывать к верхнему регистру
  Upper:=(FieldType in StringTypes) and not(foCaseSensitive in Options);
  //определяем, будет ли производиться поик по маске
  Mask:=(FieldType in StringTypes) and not(foIdentical in Options);
  if Mask then begin
    FindStr := AnsiQuotedStr(FindStr, '%');
    FindStr := StringReplace(FindStr, ' ' , '%', [rfReplaceAll]);
  end;
  if FieldType in QuotedTypes then FindStr:=AnsiQuotedStr(FindStr,'''');
  if Upper then FindStr:=AnsiUpperCase(FindStr);
  Result := IfThen(Upper, 'UPPER(','') + FieldName + IfThen(Upper, ')', '') +
    IfThen(Mask, ' LIKE ', '=') + FindStr;
end;

//по имени результирующего поля запроса возвращает его таблицу
{function GetTableName(SQL: TStrings; FieldName: string): string;
var
  SelectSt, FromSt, AsSt: string;
  I: Integer;
begin
  FieldName:=AnsiUpperCase(Trim(FieldName));
  SelectSt:=ReadClauseFromSQL(SQL,scSelect);
  FromSt:=ReadClauseFromSQL(SQL,scFrom);
  AsSt:=Clauses[scAs].Text;
  I:=Pos(FieldName,SelectSt);
  //пока находим имя поля
  while I>0 do begin
    //после имени поля ничего не стоит
    if (I+Length(FieldName)-1=Length(FieldName))or
      //после имени поля - разделитель
      ((SelectSt[I+Length(FieldName)] in Delimiters)and
      //потом - не "AS"
      ((Copy(SelectSt,I+Length(FieldName)+1,Length(AsSt))<>AsSt)or
      //потом - то же имя поля
      (GetFistWord(Copy(SelectSt,I+Length(FieldName)+Length(AsSt)+1,
      Length(SelectSt))))=FieldName))) then Exit;
    //удяляем просмотренный кусок
    SelectSt:=Copy(SelectSt,I+Length(FieldName),Length(SelectSt));
    I:=Pos(FieldName,SelectSt);
  end;
  //если не нашли поле, возвращаем первую таблицу в списке
  if I=0 then
end;}

procedure SQLDeleteCondition(var WhereClause: String; const Condition: String);
var
  I, J: Integer;
  S: String;
begin
  I := Pos(Condition, WhereClause);
  if I > 0 then
  begin
    S := Clauses[scAnd].Text + BracketStr(Condition);
    J := Pos(S, WhereClause);
    if J > 0 then
      Delete(WhereClause, J, Length(S))
    else
    begin
      S := BracketStr(Condition);
      J := Pos(S, WhereClause);
      if J > 0 then
        Delete(WhereClause, J, Length(S))
      else
        Delete(WhereClause, I, Length(Condition));
    end;
    if Trim(WhereClause) = Clauses[scWhere].Text then
      WhereClause := '';
    S := Trim(WhereClause);
    if Pos(Clauses[scAnd].Text, S) = 1 then
      Delete(S, 1, Length(Clauses[scAnd].Text))
    else
    if Pos(Clauses[scOr].Text, S) = 1 then
      Delete(S, 1, Length(Clauses[scOr].Text));
    WhereClause := S;
  end;
end;

initialization
  Clauses[scNormalized].Text:='/* NORM */'; Clauses[scNormalized].Line:=0;
  Clauses[scSelect].Text:='SELECT';         Clauses[scSelect].Line:=1;
  Clauses[scFrom].Text:='FROM';             Clauses[scFrom].Line:=2;
  Clauses[scWhere].Text:='WHERE';           Clauses[scWhere].Line:=3;
  Clauses[scGroupBy].Text:='GROUP BY';      Clauses[scGroupBy].Line:=4;
  Clauses[scHaving].Text:='HAVING';         Clauses[scHaving].Line:=5;
  Clauses[scUnion].Text:='UNION';           Clauses[scUnion].Line:=6;
  Clauses[scPlan].Text:='PLAN';             Clauses[scPlan].Line:=7;
  Clauses[scOrderBy].Text:='ORDER BY';      Clauses[scOrderBy].Line:=8;
  Clauses[scForUpdate].Text:='FOR UPDATE';  Clauses[scForUpdate].Line:=9;
  Clauses[scAnd].Text:='AND';               Clauses[scAnd].Line:=-1;
  Clauses[scOr].Text:='OR';                 Clauses[scOr].Line:=-1;
  Clauses[scLike].Text:='LIKE';             Clauses[scLike].Line:=-1;
  Clauses[scAs].Text:='AS';                 Clauses[scAs].Line:=-1;
end.
