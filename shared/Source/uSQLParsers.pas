{*******************************************************}
{                                                       }
{                                                       }
{       Парсер SQL                                      }
{                                                       }
{       Copyright (c) 2004,2006 Калабухов А.В.          }
{                                                       }
{       Автор: Калабухов А.В.                           }
{       Добавления: Бондырев Р.В.                       }
{                                                       }
{*******************************************************}

{
  Описание:
  Имя модуля: SQL Parser
  Версия: 0.8.1
  Дата последнего изменения: 22.11.2004 (25.07.2006)
  Цель: содержит классы - парсер SELECT запросов SQL, выражений SQL, условий SQL.
  Используется:
  Использует: только системные модули
  Исключения: ESQLFormatError, ETableNotFound }
{
  0.8.1
      - Использование подзапросов в WHERE, обязательно использовать скобки:
        WHERE (ID = 34) AND (ODDICE_ID = (SELECT .....))
      - изменение в процедуре: TSelectSQLParser.ParseText:
        при поиске ключевых слов в подстроке, проверяется не только наличие
        операторов SQL в строке но и расположение (было >0, стало =1)
      - изменение в процедуре: TWheteClause.ParseConditionString:
        при подсчете круглых скобок в строке если счетчик скобок BracketCounter
        не равен 0 символ ')' не добавлялся в Condition 
}

{
  Ограничения:
  1. В WHERE нет поддержки вложенных запросов типа:
    - EXISTS (<select>)
    - SINGULAR (<select>)
    - IN (<select>)
    - ALL | SOME | ANY (<select>)
}

{
  История:
  0.8
     - изменил процедуру BracketedStr
  0.7
     - Поддержка процедур с параметрами в FROM
     - Поддержка JOIN в FROM
}

unit uSQLParsers;

interface

uses
  SysUtils, Classes, Contnrs;

type
  TSelectClauses = (sqlSelect, sqlFrom, sqlWhere, sqlGroupBy, sqlHaving, sqlUnion,
    sqlPlan, sqlOrderBy, sqlForUpdate);

type
  ESQLFormatError = class(Exception)
  end;
  ETableNotFound = class(Exception)
  end;

  TSQLClause = class
  protected
    function GetText: String; virtual; abstract;
    procedure SetText(const Value: String); virtual; abstract;
    function GetParts(Index: Integer): String; virtual; abstract;
    procedure SetParts(Index: Integer; const Value: String); virtual; abstract;
    function GetPartCount: Integer; virtual; abstract;
  public
    constructor Create; virtual;
    procedure AddPart(const APart: String); virtual; abstract;
    procedure DeletePart(Index: Integer); virtual; abstract;
    function IndexOfPart(const APart: String): Integer; virtual; abstract;
    procedure Clear; virtual;
    function IsEmpty: Boolean; virtual; abstract;
    property Text: String read GetText write SetText;
    property Parts[Index: Integer]: String read GetParts write SetParts;
    property PartCount: Integer read GetPartCount;
  end;

  TSQLField = class
  private
    FTableName: String;
    FName: String;
  public
    function AsText: String;
    property TableName: String read FTableName write FTableName;
    property Name: String read FName write FName;
  end;

  TSelectClause = class(TSQLClause)
  private
    FParts: TStringList;
  protected
    function GetText: String; override;
    procedure SetText(const Value: String); override;
    function GetParts(Index: Integer): String; override;
    procedure SetParts(Index: Integer; const Value: String); override;
    function GetPartCount: Integer; override;
  public
    constructor Create; override;
    destructor Destroy; override;
    procedure AddPart(const APart: String); override;
    procedure DeletePart(Index: Integer); override;
    function IsEmpty: Boolean; override;
    procedure ParseColumnName(Str: String; var Table, Name, Pseudonim: String);
  end;

  TSQLJoinType = (
      jtNone,
      jtJoin,
      jtInner,
      jtLeft,
      jtRight,
      jtFull,
      jtLeftOuter,
      jtRightOuter,
      jtFullOuter
  );

var
  SQLJoinStr: array[TSQLJoinType] of String = (
     '',
     'JOIN',
     'INNER JOIN',
     'LEFT JOIN',
     'RIGHT JOIN',
     'FULL JOIN',
     'LEFT OUTER JOIN',
     'RIGHT OUTER JOIN',
     'FULL OUTER JOIN'
  );

type
  TFromObject = class
  private
    FAlias: String;
    FName: String;
  public
    function AsText: String; virtual;
    property Name: String read FName write FName;
    property Alias: String read FAlias write FAlias;
  end;

  TFromJoinCondition = record
    MasterField, SlaveField: String;
  end;

  TFromJoinedTable = class(TFromObject)
  private
    FJoinType: TSQLJoinType;
    FJoinedTo: TFromObject;
    FConditions: array of TFromJoinCondition;
    function GetConditions(Index: Integer): TFromJoinCondition;
    procedure SetConditions(Index: Integer;
      const Value: TFromJoinCondition);
  public
    function AsText: String; override;
    property JoinedTo: TFromObject read FJoinedTo write FJoinedTo;
    property JoinType: TSQLJoinType read FJoinType write FJoinType;
    property Conditions[Index: Integer]: TFromJoinCondition read GetConditions write SetConditions;
    function ConditionCount: Integer;
    procedure Add(Master, Slave: TSQLField);
  end;

  TFromProcedure = class(TFromObject)
  private
    FParams: String;
    procedure SetParams(const Value: String);
  public
    function AsText: String; override;
    property Params: String read FParams write SetParams;
  end;

  TFromClause = class(TSQLClause)
  private
    FObjects: TObjectList;
    function GetTableAlias(Index: Integer): String;
    function GetTableName(Index: Integer): String;
  protected
    function GetText: String; override;
    procedure SetText(const Value: String); override;
    function GetParts(Index: Integer): String; override;
    procedure SetParts(Index: Integer; const Value: String); override;
    function GetPartCount: Integer; override;
    function ParsePart(const APart: String): TFromObject;
    procedure ParseJoinCondition(AJoinedTable: TFromJoinedTable; const Condition: String);
    function SeparateConditions(const AStr: String): TStrings;
  public
    constructor Create; override;
    destructor Destroy; override;
    procedure AddPart(const APart: String); override;
    procedure DeletePart(Index: Integer); override;
    function IsEmpty: Boolean; override;
    property TableName[Index: Integer]: String read GetTableName;
    property TableAlias[Index: Integer]: String read GetTableAlias;
  end;

  TOrderByClause = class(TSQLClause)
  private
    FParts: TStringList;
  protected
    function GetText: String; override;
    procedure SetText(const Value: String); override;
    function GetParts(Index: Integer): String; override;
    procedure SetParts(Index: Integer; const Value: String); override;
    function GetPartCount: Integer; override;
  public
    constructor Create; override;
    destructor Destroy; override;
    procedure AddPart(const APart: String); override;
    procedure DeletePart(Index: Integer); override;
    function IsEmpty: Boolean; override;
    procedure ParsePart(const APart: String; var TableName, FieldName, SortOrder: String);
  end;

  TSQLConditionOperator = (coNone, coAnd, coOr);

  TSQLCondition = class
  private
    FOperator: TSQLConditionOperator;
    FText: String;
    FComment: string;
  public
    /// <summary>
    ///   Это очень плохая реализация - работает только для равенства.
    ///  Т.е. для FieldX = VALUE вернёт FieldX.
    /// </summary>
    function FieldName: String;
    function FullText: String; virtual;
    //
    property Comment: string read FComment write FComment;
    property Text: String read FText write FText;
    property TheOperator: TSQLConditionOperator read FOperator write FOperator;
  end;
{
  TSQLSubquery = class(TSQLCondition)
  private
    FParser: TSelectSQLParser;
  public
    property Parser: TSelectSQLParser read FParser write FParser;
  end;
}
  TWhereClause = class(TSQLClause)
  private
    FParts: TObjectList;
    function NewPart(Value: String): TSQLCondition;
    procedure ParseConditionString(Str: String);
    function GetConditions(const Index: Integer): TSQLCondition;
    procedure SetConditions(const Index: Integer; const Value: TSQLCondition);
  protected
    function GetText: String; override;
    procedure SetText(const Value: String); override;
    function GetParts(Index: Integer): String; override;
    procedure SetParts(Index: Integer; const Value: String); override;
    function GetPartCount: Integer; override;
  public
    constructor Create; override;
    destructor Destroy; override;
    procedure AddCondition(aCondition: TSQLCondition); 
    procedure AddPart(const APart: String); override;
    procedure Clear; override;
    procedure DeletePart(Index: Integer); override;
    function IndexOfPart(const APart: String): Integer; override;
    function IsEmpty: Boolean; override;
    //
    property Conditions[const Index: Integer]: TSQLCondition read GetConditions write SetConditions; default;
  end;

  TGroupByClause = class(TSQLClause)
  protected
    function GetText: String; override;
    procedure SetText(const Value: String); override;
  public
    function IsEmpty: Boolean; override;
  end;

  THavingClause = class(TSQLClause)
  protected
    function GetText: String; override;
    procedure SetText(const Value: String); override;
  public
    function IsEmpty: Boolean; override;
  end;

  TUnionClause = class(TSQLClause)
  protected
    function GetText: String; override;
    procedure SetText(const Value: String); override;
  public
    function IsEmpty: Boolean; override;
  end;

  TPlanClause = class(TSQLClause)
  protected
    function GetText: String; override;
    procedure SetText(const Value: String); override;
  public
    function IsEmpty: Boolean; override;
  end;

  TForUpdateClause = class(TSQLClause)
  protected
    function GetText: String; override;
    procedure SetText(const Value: String); override;
  public
    function IsEmpty: Boolean; override;
  end;

  TSQLParser = class
  protected
    procedure ParseText(const AText: String); virtual; abstract;
  end;

  TSelectSQLParser = class(TSQLParser)
  private
    FClauses: TList;
    function GetClause(Index: TSelectClauses): TSQLClause;
    function GetText: String;
    procedure SetText(const Value: String);
    function GetTableNames(Index: Integer): String;
    function GetTableAliases(Index: Integer): String;
    function GetWhereClause: TWhereClause;
    function GetSelectClause: TSelectClause;
    function GetOrderByClause: TOrderByClause;
  protected
    procedure ParseText(const AText: String); override;
  public
    constructor Create;
    destructor Destroy; override;
    //
    /// <summary>
    /// Проверяет наличие колонки в запросе и возможность обращния к ней по заданному имени.
    /// </summary>
    function ValidColumn(const ColumnName: String): Boolean;
    function IndexOfTableAlias(const ATableName: String): Integer;
    function IndexOfTableName(const ATableName: String): Integer;
    /// <summary>
    /// Пытается добавить часть к ORDER BY, если часть проходит проверки.
    /// Возвращает True, если часть была добавлена.
    /// </summary>
    /// <remarks>
    /// Если поле в APart отсутствует в запросе, то мы не испортим запрос добавлением.
    /// </remarks>
    function SafeAddOrderByPart(const APart: string): Boolean;
    function TableCount: Integer;
    //
    property Text: String read GetText write SetText;
    property Clauses[Index: TSelectClauses]: TSQLClause read GetClause;
    property TableNames[Index: Integer]: String read GetTableNames;
    property TableAliases[Index: Integer]: String read GetTableAliases;
    //
    property Select: TSelectClause read GetSelectClause;
    property From: TSQLClause index sqlFrom read GetClause;
    property Where: TWhereClause read GetWhereClause;
    property GroupBy: TSQLClause index sqlGroupBy read GetClause;
    property Having: TSQLClause index sqlHaving read GetClause;
    property Union: TSQLClause index sqlUnion read GetClause;
    property Plan: TSQLClause index sqlPlan read GetClause;
    property OrderBy: TOrderByClause read GetOrderByClause;
    property ForUpdate: TSQLClause index sqlForUpdate read GetClause;
  end;

  function BracketedStr(const AStr: String): String;

var
  SQLClausesStr: array[Low(TSelectClauses)..High(TSelectClauses)] of String =
  ( 'SELECT', 'FROM', 'WHERE', 'GROUP BY', 'HAVING', 'UNION',
    'PLAN', 'ORDER BY', 'FOR UPDATE' );

implementation

uses
  Math, uGC;

const
  S_TABLE_NOTFOUND = 'Таблица %s не найдена!';

type
  TSQLWhereConditionParseState = (psWaitStartOfCondition, psWaitEndOfCondition, psWaitOperator);

var
  SQLSymblos: set of Char = ['A'..'Z', '_'];
  SQLNumbers: set of Char = ['0'..'9'];

{
  Служебные функции
}

// Заключаем строку в скобки
procedure AddBrackets(var AStr: String);
begin
  if (AStr <> '') and (AStr[1] <> '(') and (AStr[Length(AStr)] <> ')') then
  begin
    // Добавляем скобки вокруг условия
    AStr := '(' + AStr + ')';
  end;
end;

// Заключаем строку в скобки
function BracketedStr(const AStr: String): String;
begin
  if (AStr <> '') and (AStr[1] <> '(') and (AStr[Length(AStr)] <> ')') then
    Result := '(' + AStr + ')'
  else
    if (AStr[1] <> '(') or (AStr[Length(AStr)] <> ')') then
      Result := '(' + AStr + ')'
    else
      Result := AStr;
end;

// Убираем скобки вокруг строки
procedure DeleteBrackets(var AStr: String);
begin
  if (AStr <> '') and (AStr[1] = '(') and (AStr[Length(AStr)] = ')') then
  begin
    Delete(AStr, 1, 1);
    SetLength(AStr, Pred(Length(AStr)));
  end;
end;

{
  Функции разбора строк
}

// Разбор описания поля. Например, TABLE1.FIELD1 
function ParseField(const FieldStr: String): TSQLField;
var
  I: Integer;
  Tbl, Fld, S: String;
begin
  Result := nil;
  S := Trim(FieldStr);
  if S <> '' then
  begin
    if (Pos(' ', S) > 0) then
      raise Exception.Create('Неверное SQL-описание поля ' + FieldStr);
    I := Pos('.', S);
    if I > 0 then
    begin
      if I = 1 then
        raise Exception.Create('Неверное SQL-описание поля ' + FieldStr);
      Tbl := Copy(S, 1, Pred(I));
      Fld := Copy(S, Succ(I), Length(S) - I);
    end
    else
    begin
      Tbl := '';
      Fld := S;
    end;
    Result := TSQLField.Create;
    Result.Name := Fld;
    Result.TableName := Tbl;
  end;
end;

{ TSelectSQLParser }

constructor TSelectSQLParser.Create;
begin
  FClauses := TList.Create;
  FClauses.Add(TSelectClause.Create);
  FClauses.Add(TFromClause.Create);
  FClauses.Add(TWhereClause.Create);
  FClauses.Add(TGroupByClause.Create);
  FClauses.Add(THavingClause.Create);
  FClauses.Add(TUnionClause.Create);
  FClauses.Add(TPlanClause.Create);
  FClauses.Add(TOrderByClause.Create);
  FClauses.Add(TForUpdateClause.Create);
end;

destructor TSelectSQLParser.Destroy;
var
  I, C: Integer;
  TmpObj: TObject;
begin
  C := Pred(FClauses.Count);
  for I := 0 to C do
  begin
    TmpObj := FClauses[I];
    TmpObj.Free;
  end;
  FClauses.Free;
  inherited;
end;

function TSelectSQLParser.GetClause(Index: TSelectClauses): TSQLClause;
begin
  Result := FClauses[Ord(Index)];
end;

function TSelectSQLParser.GetOrderByClause: TOrderByClause;
begin
  Result := GetClause(sqlOrderBy) as TOrderByClause;
end;

function TSelectSQLParser.GetSelectClause: TSelectClause;
begin
  Result := GetClause(sqlSelect) as TSelectClause;
end;

function TSelectSQLParser.GetTableAliases(Index: Integer): String;
begin
  with Clauses[sqlFrom] as TFromClause do
  begin
    Result := TableAlias[Index];
    if (Result = '') and (PartCount > 1) then
      Result := TableName[Index];
  end;
end;

function TSelectSQLParser.GetTableNames(Index: Integer): String;
begin
  Result := TFromClause(Clauses[sqlFrom]).TableName[Index];
end;

function TSelectSQLParser.GetText: String;
var
  I: TSelectClauses;
begin
  for I := Low(TSelectClauses) to High(TSelectClauses) do
  if not Clauses[I].IsEmpty then
  begin
    if Result <> '' then
      Result := Result + #13#10;
    Result := Result + Clauses[I].Text;
  end;
end;

function TSelectSQLParser.GetWhereClause: TWhereClause;
begin
  Result := GetClause(sqlWhere) as TWhereClause;
end;

function TSelectSQLParser.IndexOfTableAlias(const ATableName: String): Integer;
var
  I, PC: Integer;
begin
  with Clauses[sqlFrom] as TFromClause do
  begin
    PC := Pred(PartCount);
    for I := 0 to PC do
    if TableAliases[I] = ATableName then
    begin
      Result := I;
      Exit;
    end;
  end;
  Result := -1;
end;

function TSelectSQLParser.IndexOfTableName(
  const ATableName: String): Integer;
var
  I, PC: Integer;
begin
  with Clauses[sqlFrom] as TFromClause do
  begin
    PC := Pred(PartCount);
    for I := 0 to PC do
    if TableNames[I] = ATableName then
    begin
      Result := I;
      Exit;
    end;
  end;
  Result := -1;
end;

procedure TSelectSQLParser.ParseText(const AText: String);
var
  I: TSelectClauses;
  J, K, L1, L2: Integer;
  S: String;
  SList: TStringList;
begin
  SList := IObject(TStringList.Create).AObject as TStringList;
  with SList do
  begin
    S := '';
    L1 := 1;
    L2 := 1;
    for I := Low(TSelectClauses) to High(TSelectClauses) do
    begin
      if L2 > 0 then
        L1 := L2;
      L2 := Pos(SQLClausesStr[I], AText);
      if (L2 > 0) and (L1 < L2) then
        S := S + Copy(AText, L1, L2 - L1) + #13#10;
    end;
    S := S + Copy(AText, L1, Length(AText) - Pred(L1));
    Text := S;
    for K := Pred(Count) downto 0 do
      if Strings[K] = '' then
        Delete(K);
    for I := Low(TSelectClauses) to High(TSelectClauses) do
    for J := Pred(Count) downto 0 do
      if Pos(SQLClausesStr[I], Strings[J]) = 1 then //>0 ключевое слово SQL должно быть первым
      begin
        Clauses[I].Text := Strings[J];
        Delete(J);
        Break;
      end;
  end;
end;

function TSelectSQLParser.SafeAddOrderByPart(const APart: string): Boolean;
var
  T, F, S, TF: string;
  I: Integer;
begin
  Result := False;
  OrderBy.ParsePart(APart, T, F, S);
  if (T <> '') or (F <> '') then
  begin
    if (T = '') and TryStrToInt(F, I) then
      Result := True
    else
    begin
      if T = '' then
        TF := F
      else
        TF := T + '.' + F;
      Result := ValidColumn(TF)
    end;
    if Result then
      OrderBy.AddPart(APart);
  end;
end;

procedure TSelectSQLParser.SetText(const Value: String);
var
//  Oldtext: String;
  I: TSelectClauses;
begin
//  OldText := GetText;
  for I := Low(TSelectClauses) to High(TSelectClauses) do
  begin
    Clauses[I].Text := '';
  end;
  ParseText(Value);
end;

function TSelectSQLParser.TableCount: Integer;
begin
  Result := Clauses[sqlFrom].PartCount;
end;

function TSelectSQLParser.ValidColumn(const ColumnName: String): Boolean;
var
  I: Integer;
  T, N, P, T1, N1, P1, A: string;
  Clause: TSelectClause;
begin
  Result := True;
  if TryStrToInt(ColumnName, I) then
  begin

  end
  else
  begin
    Clause := Select;
    Clause.ParseColumnName(ColumnName, T, N, P);
    if (T = '') and (N = '') and (P = '') then
      Result := False
    else
    begin
      Result := True;
      A := '';
      if T <> '' then
      begin
        Result := False;
        I := IndexOfTableName(T);
        if I >= 0 then
        begin
          A := TableAliases[I];
          Result := True;
        end
        else
        begin
          I := IndexOfTableAlias(T);
          if I >= 0 then
          begin
            T := TableNames[I];
            A := TableAliases[I];
            Result := True;
          end;
        end;
      end;
      if Result then
      begin
        for I := 0 to Pred(Clause.PartCount) do
        begin
          if Clause.Parts[I] = ColumnName then
            Exit;
          Clause.ParseColumnName(Clause.Parts[I], T1, N1, P1);
          if ((T1 = T) or (T1 = A)) and ((N1 = N) or (P1 = N)) then
            Exit;
        end;
        Result := False;
      end;
    end;
  end;
end;

{ TSQLClause }

procedure TSQLClause.Clear;
begin
  while PartCount > 0 do
    DeletePart(0); 
end;

constructor TSQLClause.Create;
begin

end;

{ TSelectClause }

procedure TSelectClause.AddPart(const APart: String);
begin
  inherited;
  FParts.Add(APart);
end;

constructor TSelectClause.Create;
begin
  inherited;
  FParts := TStringList.Create;
end;

procedure TSelectClause.DeletePart(Index: Integer);
begin
  inherited;
  FParts.Delete(Index);
end;

destructor TSelectClause.Destroy;
begin
  FParts.Free;
  inherited;
end;

function TSelectClause.GetPartCount: Integer;
begin
  Result := FParts.Count;
end;

function TSelectClause.GetParts(Index: Integer): String;
begin
  Result := FParts[Index];
end;

function TSelectClause.GetText: String;
var
  I, PC: Integer;
begin
  if IsEmpty then
    Result := ''
  else
  begin
    Result := 'SELECT ' + FParts[0];
    PC := Pred(FParts.Count);
    for I := 1 to PC do
      Result := Result + ', ' + FParts[I];
  end;
end;

function TSelectClause.IsEmpty: Boolean;
begin
  Result := FParts.Count = 0;
end;

procedure TSelectClause.ParseColumnName(Str: String; var Table, Name,
  Pseudonim: String);
var
  I: Integer;
begin
  I := Pos('.', Str);
  Table := Copy(Str, 1, Pred(I));
  Delete(Str, 1, I);
  I := Pos(' AS ', Str);
  if I > 0 then
  begin
    Name := Copy(Str, 1, Pred(I));
    Delete(Str, 1, I + Length(' AS '));
    Pseudonim := Str;
  end
  else
  begin
    Name := Str;
    Pseudonim := '';
  end;
end;

procedure TSelectClause.SetParts(Index: Integer; const Value: String);
begin
  inherited;
  FParts[Index] := Value;
end;

procedure TSelectClause.SetText(const Value: String);
var
  TmpStr: String;
  I: Integer;
begin
  inherited;
  TmpStr := Trim(Value);
  if TmpStr = '' then
  begin
    FParts.Clear;
    Exit;
  end;
  if Pos('SELECT', TmpStr) <> 1 then
    raise ESQLFormatError.Create(TmpStr);
  FParts.Clear;
  Delete(TmpStr, 1, Length('SELECT'));
  TmpStr := Trim(TmpStr);
  I := Pos(',', TmpStr);
  while (I > 0) and (Length(TmpStr) > 1) do
  begin
    FParts.Add(Copy(TmpStr, 1, Pred(I)));
    Delete(TmpStr, 1, I);
    TmpStr := Trim(TmpStr);
    I := Pos(',', TmpStr);
  end;
  if TmpStr <> '' then
    FParts.Add(TmpStr);
end;

{ TFromClause }

procedure TFromClause.AddPart(const APart: String);
begin
  inherited;
  FObjects.Add(ParsePart(APart));
end;

constructor TFromClause.Create;
begin
  inherited;
  FObjects := TObjectList.Create;
end;

procedure TFromClause.DeletePart(Index: Integer);
begin
  inherited;
  FObjects.Delete(Index);
end;

destructor TFromClause.Destroy;
begin
  FObjects.Free;
  inherited;
end;

function TFromClause.GetPartCount: Integer;
begin
  Result := FObjects.Count;
end;

function TFromClause.GetParts(Index: Integer): String;
begin
  Result := TFromObject(FObjects[Index]).AsText;
end;

function TFromClause.GetTableAlias(Index: Integer): String;
begin
  Result := TFromObject(FObjects[Index]).Alias;
end;

function TFromClause.GetTableName(Index: Integer): String;
begin
  Result := TFromObject(FObjects[Index]).Name;
end;

function TFromClause.GetText: String;
var
  I, PC: Integer;
begin
  if IsEmpty then
    Result := ''
  else
  begin
    Result := 'FROM ' + Parts[0];
    PC :=  Pred(PartCount);
    for I := 1 to PC do
    begin
      if not (FObjects[I] is TFromJoinedTable) then
        Result := Result + ', ';
      Result := Result + ' ' + TFromObject(FObjects[I]).AsText;
    end;
  end;
end;

function TFromClause.IsEmpty: Boolean;
begin
  Result := FObjects.Count = 0;
end;

procedure TFromClause.ParseJoinCondition(AJoinedTable: TFromJoinedTable;
  const Condition: String);
var
  LeftSide, RightSide: String;
  I, Index, C: Integer;
  MFld, SFld: TSQLField;
  Found: Boolean;
begin
  I := Pos('=', Condition);
  if I > 3 then
  begin
    LeftSide := Copy(Condition, 1, Pred(I));
    RightSide := Copy(Condition, Succ(I), Length(Condition) - I);
    MFld := ParseField(LeftSide);
    if Assigned(MFld) then
    begin
      Found := False;
      Index := -1;
      C := Pred(FObjects.Count);
      for I := 0 to C do
        if (TFromObject(FObjects[I]).Name = MFld.TableName)
           or (TFromObject(FObjects[I]).Alias = MFld.TableName) then
        begin
          Found := True;
          Index := I;
          Break;
        end;
      if Found then
      begin
        AJoinedTable.JoinedTo := TFromObject(FObjects[Index]);
      end
      else
        raise Exception.Create('Не найдена ведущая таблица для объединения с условием ' + Condition);
    end;
    // Парсим подчиненное поле
    SFld := ParseField(RightSide);
    if Assigned(SFld) then
    begin
      if not ((AJoinedTable.Name = SFld.TableName)
         or (AJoinedTable.Alias = SFld.TableName)) then
        raise Exception.Create('Не найдена ведомая таблица для объединения с условием ' + Condition)
      else
      begin
        AJoinedTable.Add(MFld, SFld);
        MFld.Free;
        SFld.Free;
      end;
    end;
  end
  else
    raise Exception.Create('Неверное условие объединения ' + Condition);
end;

function TFromClause.ParsePart(const APart: String): TFromObject;
var
  S: String;
  I, F: TSQLJoinType;
  J, K: Integer;
  Found: Boolean; // join found
begin
  S := Trim(APart);
  F := jtJoin;
  for I := jtJoin to High(TSQLJoinType) do
  begin
    Found := Pos(SQLJoinStr[I], S) = 1;
    if Found then
    begin
      F := I;
      Break;
    end;
  end;
  if Found then
  begin
    Result := TFromJoinedTable.Create;
    TFromJoinedTable(Result).JoinType := F;
    Delete(S, 1, Length(SQLJoinStr[F]));
    S := Trim(S);
    K := 1;
    repeat
      Inc(K);
    until (S[K] = ' ') or (K > Length(S));
    if K > Length(S) then
      raise Exception.Create('Неверное SQL выражение ' + APart + '!');
    Result.Name := Copy(S, 1, Pred(K));
    Delete(S, 1, K);
    S := Trim(S);
    K := Pos('ON (', S);
    if K < 1 then
      K := Pos('ON ', S);
    if K > 1 then
    begin
      Result.Alias := Trim(Copy(S, 1, Pred(K)));
      Delete(S, 1, Pred(K));
    end
    else
      Result.Alias := '';
    Delete(S, 1, 3);
    DeleteBrackets(S);
    with SeparateConditions(S) do
    try
      for J := 0 to Pred(Count) do
        ParseJoinCondition(TFromJoinedTable(Result), Strings[J]);
    finally
      Free;
    end;
  end
  else
  begin
    K := Pos('(', S);
    if K > 1 then
    begin
      Result := TFromProcedure.Create;
      Result.Name := Copy(S, 1, Pred(K));
      Delete(S, 1, K);
      K := Pos(')', S);
      if K > 1 then
      begin
        TFromProcedure(Result).Params := Copy(S, 1, Pred(K));
        Delete(S, 1, K);
      end
      else
        raise Exception.Create('Неверное SQL-описание процедуры ' + APart);
      Result.Alias := Trim(S);
    end
    else
    begin
      Result := TFromObject.Create;
      K := Pos(' ', S);
      if K > 1 then
      begin
        Result.Name := Copy(S, 1, Pred(K));
        Result.Alias := Copy(S, Succ(K), Length(S) - K);
      end
      else
        Result.Name := S;
    end;
  end;
end;

procedure TFromClause.SetParts(Index: Integer; const Value: String);
var
  Tmp: TObject;
begin
  inherited;
  Tmp := ParsePart(Value);
  FObjects.Delete(Index);
  FObjects.Insert(Index, Tmp);
end;


procedure TFromClause.SetText(const Value: String);
type
 TsqlFromParseState = (
      fsName,
      fsAlias,
      fsProcedure,
      fsJoin,
      fsJoinName,
      fsJoinAlias,
      fsJoinConditions
  );
var
//  State: TsqlFromParseState;
  I: Integer;
  Str, S: String;
  C: TSQLJoinType;
begin
  Str := Trim(Value);
  if Str = '' then
  begin
    FObjects.Clear;
    Exit;
  end;
  if Pos('FROM ', Str) <> 1 then
    raise ESQLFormatError.Create(Str);
  Delete(Str, 1, Length('FROM '));
  // Ожидаем имя объекта
//  State := fsName;
  I := 1;
  while I <= Length(Str) do
  begin
    if Str[I] = ',' then
    begin
      S := Copy(Str, 1, Pred(I));
      FObjects.Add(ParsePart(S));
      Delete(S, 1, Length(S));
      I := 1;
    end
    else
      for C := jtJoin to High(TSQLJoinType) do
      begin
        if Str[I] = SQLJoinStr[C, 1] then
        begin
          if SQLJoinStr[C] = Copy(Str, I, Length(SQLJoinStr[C])) then
          begin
            S := Copy(Str, 1, Pred(I));
            FObjects.Add(ParsePart(S));
            Delete(Str, 1, Length(S));
            I := Length(SQLJoinStr[C]);
            Break;
          end;
        end;
      end;
    Inc(I);
  end;
  FObjects.Add(ParsePart(Str));
{    case State of
    fsName :
      begin

      end;
    fsAlias :
      begin
      end;
    fsProcedure :
      begin
      end;
    fsJoin :
      begin
      end;
    fsJoinName :
      begin
      end;
    fsJoinAlias :
      begin
      end;
    fsJoinConditions :
      begin
      end;
    end;   }
end;

{
procedure TFromClause.SetText(const Value: String);
var
  TmpStr: String;
  I: Integer;
begin
  inherited;
  TmpStr := Trim(Value);
  if TmpStr = '' then
  begin
    FParts.Clear;
    Exit;
  end;
  if Pos('FROM', TmpStr) <> 1 then
    raise ESQLFormatError.Create(TmpStr);
  FParts.Clear;
  Delete(TmpStr, 1, Length('FROM'));
  TmpStr := Trim(TmpStr);
  I := Pos(',', TmpStr);
  while (I > 0) and (Length(TmpStr) > 1) do
  begin
    FParts.Add(Copy(TmpStr, 1, Pred(I)));
    Delete(TmpStr, 1, I);
    TmpStr := Trim(TmpStr);
    I := Pos(',', TmpStr);
  end;
  if TmpStr <> '' then
    FParts.Add(TmpStr);
end;
    }
{ TOrderByClause }

procedure TOrderByClause.AddPart(const APart: String);
begin
  inherited;
  if FParts.IndexOf(APart) < 0 then
    FParts.Add(APart);
end;

constructor TOrderByClause.Create;
begin
  inherited;
  FParts := TStringList.Create;
end;

procedure TOrderByClause.DeletePart(Index: Integer);
begin
  inherited;
  FParts.Delete(Index);
end;

destructor TOrderByClause.Destroy;
begin
  FParts.Free;
  inherited;
end;

function TOrderByClause.GetPartCount: Integer;
begin
  Result := FParts.Count;
end;

function TOrderByClause.GetParts(Index: Integer): String;
begin
  Result := FParts[Index];
end;

function TOrderByClause.GetText: String;
var
  I, C: Integer;
begin
  if IsEmpty then
    Result := ''
  else
  begin
    Result := 'ORDER BY ' + FParts[0];
    C :=  Pred(FParts.Count);
    for I := 1 to C do
      Result := Result + ', ' + FParts[I];
  end;
end;

function TOrderByClause.IsEmpty: Boolean;
begin
  Result := FParts.Count = 0;
end;

procedure TOrderByClause.ParsePart(const APart: String; var TableName,
  FieldName, SortOrder: String);
var
  P1, P2: String;
  I: Integer;
begin
  I := Pos(' ', APart);
  if I > 0 then
  begin
    P1 := AnsiUpperCase(Copy(APart, 1, Pred(I)));
    P2 := AnsiUpperCase(Copy(APart, I + 1, Length(APart) - I));
  end
  else
  begin
    P1 := AnsiUpperCase(APart);
    P2 := '';
  end;
  //
  if P2 = '' then
    SortOrder := 'ASC'
  else
    if (P2 = 'ASC') or (P2 = 'ASCENDING') or (P2 = 'DESC') or (P2 = 'DESCENDING') then
      SortOrder := P2
    else
      SortOrder := '';
  if P1 <> '' then
  begin
    I := Pos('.', P1);
    if I > 0 then
    begin
      TableName := Copy(P1, 1, Pred(I));
      FieldName := Copy(APart, I + 1, Length(P1) - I);
    end
    else
    begin
      TableName := '';
      FieldName := P1;
    end;
  end;
end;

procedure TOrderByClause.SetParts(Index: Integer; const Value: String);
begin
  inherited;
  FParts[Index] := Value;
end;

procedure TOrderByClause.SetText(const Value: String);
var
  TmpStr: String;
  I: Integer;
begin
  inherited;
  TmpStr := Trim(Value);
  if TmpStr = '' then
  begin
    FParts.Clear;
    Exit;
  end;
  if Pos('ORDER BY', TmpStr) <> 1 then
    raise ESQLFormatError.Create(TmpStr);
  FParts.Clear;
  Delete(TmpStr, 1, Length('ORDER BY'));
  TmpStr := Trim(TmpStr);
  I := Pos(',', TmpStr);
  while (I > 0) and (Length(TmpStr) > 1) do
  begin
    FParts.Add(Copy(TmpStr, 1, Pred(I)));
    Delete(TmpStr, 1, I);
    TmpStr := Trim(TmpStr);
    I := Pos(',', TmpStr);
  end;
  if TmpStr <> '' then
    FParts.Add(TmpStr);
end;

{ TWhereClause }

procedure TWhereClause.AddCondition(aCondition: TSQLCondition);
begin
  FParts.Add(aCondition);
end;

procedure TWhereClause.AddPart(const APart: String);
begin
  inherited;
  FParts.Add(NewPart(APart));
end;

procedure TWhereClause.Clear;
begin
  FParts.Clear;
end;

constructor TWhereClause.Create;
begin
  inherited;
  FParts := TObjectList.Create;
end;

procedure TWhereClause.DeletePart(Index: Integer);
begin
  inherited;
  FParts.Delete(Index);
end;

destructor TWhereClause.Destroy;
begin
  FParts.Free;
  inherited;
end;

function TWhereClause.GetConditions(const Index: Integer): TSQLCondition;
begin
  Result := FParts[Index] as TSQLCondition;
end;

function TWhereClause.GetPartCount: Integer;
begin
  Result := FParts.Count;
end;

function TWhereClause.GetParts(Index: Integer): String;
begin
  Result := TSQLCondition(FParts[Index]).FullText;
end;

function TWhereClause.GetText: String;
var
  I, C: Integer;
begin
  if IsEmpty then
    Result := ''
  else
  begin
    Result := 'WHERE ' + TSQLCondition(FParts[0]).Text;
    C :=  Pred(FParts.Count);
    for I := 1 to C do
    begin
      Result := Result + ' ' + TSQLCondition(FParts[I]).FullText;
    end;
  end;
end;

function TWhereClause.IndexOfPart(const APart: String): Integer;
var
  I: Integer;
begin
  for I := 0 to Pred(FParts.Count) do
    if Self.Parts[I] = APart then
    begin
      Result := I;
      Exit;
    end;
  Result := -1;
end;

function TWhereClause.IsEmpty: Boolean;
begin
  Result := FParts.Count = 0;
end;

function TWhereClause.NewPart(Value: String): TSQLCondition;
var
  ValueUpper, S: String;
begin
  ValueUpper := AnsiUpperCase(Value);
  Result := TSQLCondition.Create;
  try
    if Pos('AND', ValueUpper) = 1 then
      Result.TheOperator := coAnd
    else
    if not Pos('OR', ValueUpper) = 1 then
      Result.TheOperator := coOr
    else
      Result.TheOperator := coNone;
    case Result.TheOperator of
    coAnd:
      S := 'AND';
    coOr:
      S := 'OR';
    else
      S := '';
    end;
    S := Trim(Copy(Value, Succ(Length(S)), Length(Value) - Length(S)));
    AddBrackets(S);
    Result.Text := S;
  except
    FreeAndNil(Result);
    raise;
  end;
end;

procedure TWhereClause.ParseConditionString(Str: String);
var
  Condition, Operator: String;
  I, Start, Current, BracketCounter: Integer;
  State: TSQLWhereConditionParseState;
begin
  Str := UpperCase(Str); 
  Operator := '';
  I := Length(Str);
  Start := 1;
  Current := Start;
  State := psWaitStartOfCondition;
  BracketCounter := 0;
  while Current <= I do
  begin
    case Str[Current] of
    '(' :
      begin
        case State of
        psWaitStartOfCondition :
          begin
            State := psWaitEndOfCondition;
            Condition := Str[Current];
            Inc(BracketCounter);
          end;
        psWaitEndOfCondition :
          begin
            Inc(BracketCounter);
            Condition := Condition + Str[Current];
          end;
        psWaitOperator :
          begin
            raise ESQLFormatError.Create(Str);
          end;
        end;
      end;
    ')' :
      begin
        case State of
        psWaitStartOfCondition, psWaitOperator :
          begin
            raise ESQLFormatError.Create(Str);
          end;
        psWaitEndOfCondition :
          begin
            Dec(BracketCounter);
            if BracketCounter = 0 then
            begin
              State:= psWaitOperator;
              Condition := Condition + Str[Current];
              // Condition Found!!!
              FParts.Add(NewPart(Operator + Condition));
            end
            else
              Condition := Condition + Str[Current];
          end;
        end;
      end;
    ' ' :
      begin
        case State of
        psWaitStartOfCondition, psWaitEndOfCondition :
          begin
            Condition := Condition + Str[Current];
          end;
        psWaitOperator :
          begin
          end;
        end;
      end;
    'O' :
      begin
        if State = psWaitOperator then
        begin
          if Current < Succ(I) then
          if (Str[Current + 1] = 'R') and (Str[Current + 2] in [#32, '(']) then
            Operator := 'OR'
          else
            raise ESQLFormatError.Create(Str);
          Inc(Current);
          State := psWaitStartOfCondition;
//          WriteLn('OPERATOR>', Operator);
        end
        else
          Condition := Condition + Str[Current];
      end;
    'A' :
      begin
        if State = psWaitOperator then
        begin
          if Current < (I - 2) then
          if (Str[Current + 1] = 'N') and (Str[Current + 2] = 'D')
             and (Str[Current + 3] in [#32, '(']) then
            Operator := 'AND'
          else
            raise ESQLFormatError.Create(Str);
          Inc(Current, 2);
          State := psWaitStartOfCondition;
//          WriteLn('OPERATOR>', Operator);
        end
        else
          Condition := Condition + Str[Current];
      end;
    else
      begin
        Condition := Condition + Str[Current];
      end;
    end;
    Inc(Current);
  end;
end;

procedure TWhereClause.SetConditions(const Index: Integer;
  const Value: TSQLCondition);
begin
  FParts[Index] := Value;
end;

procedure TWhereClause.SetParts(Index: Integer; const Value: String);
begin
  inherited;
  FParts[Index] := NewPart(Value);
end;

procedure TWhereClause.SetText(const Value: String);
var
  L: TList;

  procedure Restore;
  var
    TmpObj: TObject;
    I, C: Integer;
  begin
    C := Pred(FParts.Count);
    for I := C downto 0 do
    begin
      TmpObj := FParts[I];
      TmpObj.Free;
    end;
    if Assigned(L) then
      FParts.Assign(L);
    FreeAndNil(L);
  end;

  procedure Commit;
  var
    TmpObj: TObject;
    I, C: Integer;
  begin
    if Assigned(L) then
    begin
      C := Pred(L.Count);
      for I := C downto 0 do
      begin
        TmpObj := L[I];
        TmpObj.Free;
      end;
      L.Free;
    end;
  end;

var  
  TmpStr: String;
begin
  inherited;
  if IsEmpty then
    L := nil
  else
  begin
    L := TList.Create;
    L.Assign(FParts);
  end;
  try
    TmpStr := Trim(Value);
    if TmpStr = '' then
    begin
      FParts.Clear;
      Exit;
    end;
    if Pos('WHERE', TmpStr) <> 1 then
      raise ESQLFormatError.Create(TmpStr);
    FParts.Clear;
    Delete(TmpStr, 1, Length('WHERE'));
    TmpStr := Trim(TmpStr);
    ParseConditionString(TmpStr);
{    while TmpStr <> '' do
    begin
      FParts.Add(NewPart(GetNextCondition(TmpStr)));
    end;  }
    Commit;
  except
    Restore;
    raise;
  end;
end;

{ TSQLCondition }

function TSQLCondition.FieldName: String;
var
  I: Integer;
begin
  Result := '';
  I := Pos('=', FText);
  if I > 0 then
    Result := Trim(Copy(FText, 1, Pred(I)));
end;

function TSQLCondition.FullText: String;
begin
  case FOperator of
  coNone:
    Result := '';
  coAnd:
    Result := 'AND ';
  coOr:
    Result := 'OR ';
  end;
  Result := Result + Text;
end;

{ TGroupByClause }

function TGroupByClause.GetText: String;
begin
  Result := '';
end;

function TGroupByClause.IsEmpty: Boolean;
begin
  Result := True;
end;

procedure TGroupByClause.SetText(const Value: String);
begin

end;

{ THavingClause }

function THavingClause.GetText: String;
begin
  Result := '';
end;

function THavingClause.IsEmpty: Boolean;
begin
  Result := True;
end;

procedure THavingClause.SetText(const Value: String);
begin

end;

{ TUnionClause }

function TUnionClause.GetText: String;
begin
  Result := '';
end;

function TUnionClause.IsEmpty: Boolean;
begin
  Result := True;
end;

procedure TUnionClause.SetText(const Value: String);
begin

end;

{ TPlanClause }

function TPlanClause.GetText: String;
begin
  Result := '';
end;

function TPlanClause.IsEmpty: Boolean;
begin
  Result := True;
end;

procedure TPlanClause.SetText(const Value: String);
begin

end;

{ TForUpdateClause }

function TForUpdateClause.GetText: String;
begin
  Result := '';
end;

function TForUpdateClause.IsEmpty: Boolean;
begin
  Result := True;
end;

procedure TForUpdateClause.SetText(const Value: String);
begin

end;

{ TFromTable }

procedure TFromJoinedTable.Add(Master, Slave: TSQLField);
begin
  SetLength(FConditions, Succ(ConditionCount));
  FConditions[Pred(ConditionCount)].MasterField := Master.Name;
  FConditions[Pred(ConditionCount)].SlaveField := Slave.Name;
end;

function TFromJoinedTable.AsText: String;
var
  Als1, Als2, Cond: String;
  I, C: Integer;
begin
  Result := SQLJoinStr[JoinType] + ' ' + Name + ' ' + Alias;
  if JoinType <> jtNone then
  begin
    if JoinedTo.Alias <> '' then
      Als1 := JoinedTo.Alias
    else
      Als1 := JoinedTo.Name;
    if Self.Alias <> '' then
      Als2 := Self.Alias
    else
      Als2 := Self.Name;
    Cond := '';
    C := Pred(ConditionCount);
    for I := 0 to C do
    begin
      if Cond <> '' then
        Cond := Cond + ' AND ';
      Cond := Cond + Als1 + '.' + FConditions[I].MasterField + '='
        + Als2 + '.' + FConditions[I].SlaveField;
     end;
     Result := ' ' + Result + ' ON ' + BracketedStr(Cond);
  end;
end;

{ TFromObject }

function TFromObject.AsText: String;
begin
  Result := FName;
  if FAlias <> '' then
    Result := Result + ' ' + FAlias;
end;

{ TFromProcedure }

function TFromProcedure.AsText: String;
begin
  Result := Name;
  if FParams <> '' then
    Result := Result + BracketedStr(FParams);
  if Alias <> '' then
    Result := Result + ' ' + Alias;
end;

procedure TFromProcedure.SetParams(const Value: String);
begin
  if Value <> '' then
  begin
    FParams := Value;
    DeleteBrackets(FParams);
  end;
end;

{ TSQLField }

function TSQLField.AsText: String;
begin
  Result := FName;
  if FName <> '' then
    if FTableName <> '' then
     Result := FTableName + '.' + Result;
end;

function TFromJoinedTable.ConditionCount: Integer;
begin
  Result := Length(FConditions);
end;

function TFromJoinedTable.GetConditions(
  Index: Integer): TFromJoinCondition;
begin
  Result := FConditions[Index];
end;

function TFromClause.SeparateConditions(const AStr: String): TStrings;

  procedure AddString(var Str: String);
  begin
    if Trim(Str) <> '' then
    begin
      Result.Add(Trim(Str));
      Str := '';
    end;
  end;


const
  stStart = 0;
  stEndBracketExpected = 1;
  stProcessing = 2;
var
  State: Integer;
  Brackets: Integer;
  I: Integer;
  S: String;
  Between: Boolean;
begin
  Result := TStringList.Create;
  Brackets := 0;
  State := stStart;
  I := 1;
  S := '';
  Between := False;
  while I <= Length(AStr) do
  case State of
  stStart : // ожидаем новую часть условия
    begin
      case AStr[I] of
      '(' :
        begin
          Inc(Brackets);
          State := stEndBracketExpected;
          Inc(I);
        end;
      ' ' :
        begin
          S := S + AStr[I];
          Inc(I);
        end;
      else
        begin
          S := S + AStr[I];
          State := stProcessing;
          Inc(I);
        end;
      end;
    end;
  stEndBracketExpected : // ожидаем закрывающую скобку
    begin
      case AStr[I] of
      '(' :
        begin
          Inc(Brackets);
          if Brackets > 1 then
            S := S + AStr[I];
          Inc(I);
        end;
      ')' :
        begin
          Dec(Brackets);
          if Brackets = 0 then
          begin
            AddString(S);
            Inc(I);
            State := stProcessing;
          end
          else
          begin
            S := S + AStr[I];
            Inc(I);
          end;
        end;
      else
        begin
          S := S + AStr[I];
          Inc(I);
        end;
      end;
    end;
  stProcessing : // идет выборка текущей части условия
    begin
      case AStr[I] of
      'A' :
        begin
          if (Copy(AStr, I, 3) = 'AND') then
          begin
            if (AStr[Pred(I)] in [#32, ')']) and (AStr[I + 3] in [#32, '(']) then
            begin // Нашли AND
              if Between then
              begin
                Between := False;
                S := S + AStr[I];
                Inc(I);
              end
              else
              begin
                AddString(S);
                Inc(I, 3);
                State := stStart;
              end;
            end
          end
          else
          begin
            S := S + AStr[I];
            Inc(I);
          end;
        end;
      'O' :
        begin
          if (AStr[Succ(I)] = 'R') and (AStr[Pred(I)] in [#32, ')']) and (AStr[I + 2] in [#32, '(']) then
          begin
            AddString(S);
            Inc(I, 2);
            State := stStart;
          end
          else
          begin
            S := S + AStr[I];
            Inc(I);
          end;
        end;
      else
        begin
          S := S + AStr[I];
          Inc(I);
        end;
      end;
    end;
  end;
  AddString(S);
end;

procedure TFromJoinedTable.SetConditions(Index: Integer;
  const Value: TFromJoinCondition);
begin
  FConditions[Index] := Value;
end;

end.

