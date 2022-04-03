unit uKisSQLParser;

interface

type
  TSQLClause = (sqlSelect, sqlFrom, sqlWhere, sqlGroupBy, sqlHaving, sqlUnion,
    sqlPlan, sqlOrderBy, sqlForUpdate);
const
  I_SQLCLAUSECOUNT = 9;

type
  TSelectSQLParser = class
  private
    FClauses: array[0..Pred(I_SQLCLAUSECOUNT)] of String;
    function GetClause(Index: TSQLClause): String;
    procedure SetClause(Index: TSQLClause; const Value: String);
    function GetText: String;
    procedure SetText(const Value: String);
    procedure ParseText(const AText: String);
  public
    property Text: String read GetText write SetText;
    property Clauses[Index: TSQLClause]: String read GetClause write SetClause;
  end;

var
  SQLClauses: array[0..Pred(I_SQLCLAUSECOUNT)] of String =
  ( 'SELECT', 'FROM', 'WHERE', 'GROUP BY', 'HAVING', 'UNION',
    'PLAN', 'ORDER BY', 'FOR UPDATE' );

implementation

{ TSelectSQLParser }

function TSelectSQLParser.GetClause(Index: TSQLClause): String;
begin
  Result := FClauses[Byte(Index)];
end;

function TSelectSQLParser.GetText: String;
var
  I: Byte;
begin
  for I := 0 to High(FClauses) do
    Result := Result + FClauses[I];
end;

procedure TSelectSQLParser.ParseText(const AText: String);
var
  I, L1, L2: Integer;
begin
  L2 := 0;
  for I := Byte(Low(TSQLClause)) to Byte(High(TSQLClause)) do
  begin
    L1 := L2;
    L2 := Pos(SQLClauses[I], AText);
    FClauses[I] := Copy(AText, L1, L2 - L1 - 1);
  end;
end;

procedure TSelectSQLParser.SetClause(Index: TSQLClause; const Value: String);
begin
  FClauses[Byte(Index)] := Value;
end;

procedure TSelectSQLParser.SetText(const Value: String);
begin
  ParseText(Value);
end;

end.
