unit uSQL;

interface

uses
  SysUtils, Classes, Math, DB, StrUtils,
  uClasses;

type
  TIBSQLClause = (
    scNormalized,
    scSelect,
    scFrom,
    scWhere,
    scGroupBy,
    scHaving,
    scUnion,
    scPlan,
    scOrderBy,
    scForUpdate,
    scAnd,
    scOr,
    scLike,
    scAs);
    
  TFindOption = (foIdentical, foCaseSensitive);
  TFindOptions = set of TFindOption;

  ISQL = interface
    ['{D165A505-CD57-4457-B52A-83B8B463D07A}']
    procedure Normalize();
    function ReadClause(Clause: TIBSQLClause): string;
    procedure WriteClause(Clause: TIBSQLClause; Expression: string);
    function CheckCondition(const Condition: String): Boolean;
    procedure AddWhereCondition(const WhereCondition: String);
    procedure AddWhereByField(Field: TField; FindStr: string; FindOptions: TFindOptions);
    function GetPrimaryTable(): string;
    procedure DeleteCondition(var WhereClause: String; const Condition: String);
    function GetStringCondition(FieldName, FindStr: string; FieldType: TFieldType; Options: TFindOptions): string;
  end;

  TSQLFactory = class
  public
    class function CreateNew(aStrings: TStrings): ISQL;
  end;

implementation

type
  TClauseRecord = record
    Text: string[10];
    Line: ShortInt;
  end;

  TSQL = class(TInterfacedObject, ISQL)
  private
    FStrings: TStrings;
  private
    function IsNormalized(): Boolean;
    procedure CheckNormalized();
    procedure NormalizeClause(Clause: TIBSQLClause);
    procedure AddCondition(var Conditions: String; const NewCondition: String);
    function GetPrimaryFieldName(FieldName: string): string;
  public
    constructor Create(aStrings: TStrings);
  private
    procedure Normalize();
    function ReadClause(Clause: TIBSQLClause): string;
    procedure WriteClause(Clause: TIBSQLClause; Expression: string);
    function CheckCondition(const Condition: String): Boolean;
    procedure AddWhereCondition(const WhereCondition: String);
    procedure AddWhereByField(Field: TField; FindStr: string; FindOptions: TFindOptions);
    function GetPrimaryTable(): string;
    procedure DeleteCondition(var WhereClause: String; const Condition: String);
    function GetStringCondition(FieldName, FindStr: string; FieldType: TFieldType; Options: TFindOptions): string;
  end;

const
  stNotNormalized = 'Запрос не нормализован';

var
  Clauses: array[Low(TIBSQLClause)..High(TIBSQLClause)] of TClauseRecord;

function BracketStr(const Str: String): String;
begin
  Result := '(' + Str + ')';
end;

function DelDubbedSpace(const S: string): string;
var
  I: Integer;
begin
  Result := Trim(S);
  for I := Length(Result) downto 2 do
    if (Result[I] = ' ') and (Result[I - 1] = ' ') then
      Delete(Result, I, 1);
end;

const
  DelimitersSet = [' ', ',',';','.','|','/','\','+','-'];

function GetNextWord(var Str: string): string;
var
  InWord: Boolean;
  I, Pos, Count: Integer;
begin
  InWord := False;
  Pos := 0;
  Count := 0;
  for I := 1 to Length(Str) do
  begin
    if Str[I] in DelimitersSet then
    begin
      if InWord then
        Break;
    end
    else
    begin
      if not InWord then
      begin
        InWord := True;
        Pos := I;
      end;
      Inc(Count);
    end;
  end;
  if Pos = 0 then
    Str := ''
  else
  begin
    Result := Copy(Str, Pos, Count);
    Str := Copy(Str, Pos + Count + 1, Length(Str));
  end;
end;

function WholeWordPos(Substr, S: string): Integer;
begin
  Result:=Pos(Substr,S);
  while Result>0 do
  begin
    if (Result=1)
       or
       (S[Result-1] in DelimitersSet)
       and
       (Length(S)=Result+Length(Substr)-1)
       or
       (S[Result+Length(Substr)] in DelimitersSet)
    then
      Break;
    S:=Copy(S,Result+1,Length(S));
    Result:=Pos(Substr,S);
  end;
end;

{ TSQL }

procedure TSQL.AddWhereByField(Field: TField; FindStr: string; FindOptions: TFindOptions);
var
  FieldName: string;
begin
  FieldName := Field.FieldName;
  if Field.FieldKind in [fkData, fkInternalCalc, fkLookup] then
    FieldName := GetPrimaryFieldName(FieldName)
  else
    raise Exception.Create('Поиск по данному полю невозможен');
  AddWhereCondition(GetStringCondition(FieldName, FindStr, Field.DataType, FindOptions));
end;

procedure TSQL.AddWhereCondition(const WhereCondition: String);
var
  WhereSt: String;
begin
  WhereSt := ReadClause(scWhere);
  AddCondition(WhereSt, WhereCondition);
  WriteClause(scWhere, WhereSt);
end;

function TSQL.CheckCondition(const Condition: String): Boolean;
begin
  Result := System.Pos(Condition, ReadClause(scWhere)) > 0;
end;

procedure TSQL.CheckNormalized;
begin
  if not IsNormalized() then
    raise Exception.Create(stNotNormalized);
end;

constructor TSQL.Create(aStrings: TStrings);
begin
  inherited Create;
  FStrings := aStrings;
end;

procedure TSQL.DeleteCondition(var WhereClause: String; const Condition: String);
var
  I, J: Integer;
  S: String;
begin
  I := System.Pos(Condition, WhereClause);
  if I > 0 then
  begin
    S := Clauses[scAnd].Text + BracketStr(Condition);
    J := System.Pos(S, WhereClause);
    if J > 0 then
      System.Delete(WhereClause, J, Length(S))
    else
    begin
      S := BracketStr(Condition);
      J := System.Pos(S, WhereClause);
      if J > 0 then
        System.Delete(WhereClause, J, Length(S))
      else
        System.Delete(WhereClause, I, Length(Condition));
    end;
    if Trim(WhereClause) = Clauses[scWhere].Text then
      WhereClause := '';
    S := Trim(WhereClause);
    if System.Pos(Clauses[scAnd].Text, S) = 1 then
      System.Delete(S, 1, Length(Clauses[scAnd].Text))
    else
    if System.Pos(Clauses[scOr].Text, S) = 1 then
      System.Delete(S, 1, Length(Clauses[scOr].Text));
    WhereClause := S;
  end;
end;

function TSQL.GetPrimaryFieldName(FieldName: string): string;
var
  Fields, Field: string;
  I: Integer;
begin
  CheckNormalized();
  Fields := ReadClause(scSelect);
  FieldName:=AnsiUpperCase(Trim(FieldName));
  while Fields<>'' do
  begin
    I:=System.Pos(',',Fields);
    if I=0 then
      I:=Length(Fields)+1;
    Field:=Copy(Fields,1,I-1);
    Fields:=Copy(Fields,I+1,Length(Fields));
    I := WholeWordPos('AS',Field);
    //если поле переименовано
    if I>0 then
    begin
      if Copy(Field,I+3,Length(FieldName))=FieldName then
        Result:=Copy(Field,1,I-2);
    end
    else
    if WholeWordPos(FieldName,Field)>0 then
      Result:=Trim(Field);
    if Result<>'' then
      Break;
  end;
end;

function TSQL.GetPrimaryTable: string;
var
  St: string;
begin
  St := ReadClause(scFrom);
  Result := GetNextWord(St);
end;

function TSQL.GetStringCondition(FieldName, FindStr: string; FieldType: TFieldType; Options: TFindOptions): string;
const
  StringTypes = [ftString, ftMemo, ftFmtMemo, ftWideString];
  QuotedTypes = StringTypes + [ftDate, ftTime, ftDateTime];
var
  Mask, Upper: Boolean;
begin
  FieldName := Trim(FieldName);
  FindStr := Trim(FindStr);
  //определяем, надо ли преобразовывать к верхнему регистру
  Upper := (FieldType in StringTypes) and not (foCaseSensitive in Options);
  //определяем, будет ли производиться поик по маске
  Mask := (FieldType in StringTypes) and not(foIdentical in Options);
  if Mask then
  begin
    FindStr := AnsiQuotedStr(FindStr, '%');
    FindStr := StringReplace(FindStr, ' ' , '%', [rfReplaceAll]);
  end;
  if FieldType in QuotedTypes then
    FindStr := AnsiQuotedStr(FindStr, '''');
  if Upper then
    FindStr := AnsiUpperCase(FindStr);
  Result := IfThen(Upper, 'UPPER(','') + FieldName +
            IfThen(Upper, ')', '') +
            IfThen(Mask, ' LIKE ', '=') + FindStr;
end;

function TSQL.IsNormalized: Boolean;
begin
  Result:= (FStrings.Count > 0)
           and
           (System.Pos(Clauses[scNormalized].Text, FStrings[Clauses[scNormalized].Line]) > 0);
end;

procedure TSQL.Normalize;
var
  Clause: TIBSQLClause;
  I: Integer;
  ClausesLineCount: Integer;
begin
  ClausesLineCount := 0;
  //если запрос уже нормализован - выходим
  if IsNormalized() then
    Exit;
  //преобразуем запрос к верхнему регистру
  FStrings.ToUpper();
  //нормализуем отдельные фразы
  for Clause := Low(TIBSQLClause) to High(TIBSQLClause) do
    if Clauses[Clause].Line > 0 then
      NormalizeClause(Clause);
  //записываем признак нормализованности
  FStrings[0] := Clauses[scNormalized].Text;
  //удаляем лишние пробелы
  for I:=0 to FStrings.Count-1 do
    FStrings[I] := DelDubbedSpace(FStrings[I]);
  //находим число строк, кторое должно быть в запросе
  if ClausesLineCount = 0 then
    for Clause := Low(TIBSQLClause) to High(TIBSQLClause) do
      ClausesLineCount := Max(ClausesLineCount, Clauses[Clause].Line);
  //добавляем недостающие строки
  for I := 1 to ClausesLineCount - FStrings.Count do
    FStrings.Add('');
end;

procedure TSQL.NormalizeClause(Clause: TIBSQLClause);
var
  I, J, Line: Integer;
  St: string;
begin
  I := -1;
  J := -1;
  if not FStrings.Pos(Clauses[Clause].Text, I, J, False) then
    Exit;  //если не нашли фразу - выходим;
  if J > 1 then
  begin
    //если фраза начинается не с начала строки, переносим ее на новую
    FStrings.Insert(I + 1, Copy(FStrings[I], J, Length(FStrings[I])));
    St := FStrings[I];
    System.Delete(St, J, Length(St));
    FStrings[I] := St;
    Inc(I);
  end;
  Line := Clauses[Clause].Line;
  if I <> Line then  //если фраза стоит не на той строке
  begin
    if I < Line then
    begin
      //если фраза стоит раньше, чем надо, вставляем перед ней пустые строки
      for J := 1 to Line - I do
        FStrings.Insert(I, '')
    end
    else
    begin
      //если фраза стоит позже, чем надо, сливаем лишние строки в одну
      if Line = 0 then
      begin
        //если фраза должна стоять на первой строке, удаляем все предыдущие
        for J := I - 1 downto 0 do
          FStrings.Delete(J);
      end
      else
      begin
        //сливаем "лишние" строки в одну
        for J := 1 to I - Line do
        begin
          FStrings[Line - 1] := FStrings[Line - 1] + ' ' + FStrings[Line];
          FStrings.Delete(Line);
        end;
      end;
    end;
  end;
end;

function TSQL.ReadClause(Clause: TIBSQLClause): string;
var
  Line: Integer;
  SQLLine: String;
begin
  CheckNormalized();
  Line := Clauses[Clause].Line;
  SQLLine := FStrings[Line];
  System.Delete(SQLLine, 1, Length(Clauses[Clause].Text));
  Result := Trim(SQLLine);
end;

procedure TSQL.AddCondition(var Conditions: String; const NewCondition: String);
begin
  if Conditions = '' then
    Conditions := BracketStr(NewCondition)
  else
    Conditions := Conditions + Clauses[scAnd].Text + BracketStr(NewCondition);
end;

procedure TSQL.WriteClause(Clause: TIBSQLClause; Expression: string);
var
  Line: Integer;
begin
  CheckNormalized();
  Line := Clauses[Clause].Line;
  if Trim(Expression) = '' then
    FStrings[Line] := ''
  else
    FStrings[Line] := Clauses[Clause].Text + ' ' + Expression;
end;

{ TSQLFactory }

class function TSQLFactory.CreateNew(aStrings: TStrings): ISQL;
begin
  Result := TSQL.Create(aStrings);
end;

initialization
  Clauses[scNormalized].Text:='/* NORM */';
  Clauses[scNormalized].Line:=0;
  Clauses[scSelect].Text:='SELECT';
  Clauses[scSelect].Line:=1;
  Clauses[scFrom].Text:='FROM';
  Clauses[scFrom].Line:=2;
  Clauses[scWhere].Text:='WHERE';
  Clauses[scWhere].Line:=3;
  Clauses[scGroupBy].Text:='GROUP BY';
  Clauses[scGroupBy].Line:=4;
  Clauses[scHaving].Text:='HAVING';
  Clauses[scHaving].Line:=5;
  Clauses[scUnion].Text:='UNION';
  Clauses[scUnion].Line:=6;
  Clauses[scPlan].Text:='PLAN';
  Clauses[scPlan].Line:=7;
  Clauses[scOrderBy].Text:='ORDER BY';
  Clauses[scOrderBy].Line:=8;
  Clauses[scForUpdate].Text:='FOR UPDATE';
  Clauses[scForUpdate].Line:=9;
  Clauses[scAnd].Text:='AND';
  Clauses[scAnd].Line:=-1;
  Clauses[scOr].Text:='OR';
  Clauses[scOr].Line:=-1;
  Clauses[scLike].Text:='LIKE';
  Clauses[scLike].Line:=-1;
  Clauses[scAs].Text:='AS';
  Clauses[scAs].Line:=-1;
  
end.
