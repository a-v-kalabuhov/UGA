/* Grammar for EzGis Expression Parser
   NOTES : DON'T FORGET TO MOVE THE GENERATED CONSTANTS TO THE PLACE INDICATED
*/

%{

// Expression parser (c) 2002 EzGis

unit EzExprYacc;

{$I ez_flag.pas}
{$R ezexpryacc.res}
interface

uses
  SysUtils, Classes, Dialogs, Windows, EzYaccLib, EzBaseExpr,
  EzBase, EzSystem, EzExpressions, EzLib, EzBaseGis;

type

  TIdentifierFunctionEvent = procedure( Sender: TObject;
                                        const Group, Identifier: String;
                                        ParameterList: TParameterList;
                                        var Expression: TExpression ) of object;

  TExprParser = class(TCustomParser)
  private
    { belong to }
    FMainExpr: TEzMainExpr;
    { the list of expression as the expression is parsed }
    FExprList: TList;
    { for local use }
    FTempParams: TParameterList;
    FGroupIdent: string;
    FIdentifier: string;
    FGroupIdentList: TStringList;
    FIdentifierList: TStringList;
    { is not this a simple expression ? like TABLE.FIELD
      this is used for detecting if giving the same data type to the
      result set as the original field }
    FIsComplex: Boolean;
    { used to obtain a pair of operators }
    Op1, Op2: TExpression;
    { a stacked list of params referencing to FExprList }
    FStackedParamCount: TList;
    { the number of parameters for the last function }
    FParamCount: Integer;
    { for the case..when..else..end }
    FWhenParamList: TParameterList;
    FThenParamList: TParameterList;
    FElseExpr: TExpression;
    { used when parsing syntax like
      VECTOR( [(0,0),(10,10),(20,20),(0,0)] )  }
    FVector: TEzVector;
    { used in unknown identifiers }
    IDF: TExpression;
    FOnIdentifierFunction: TIdentifierFunctionEvent;
    { for saving configuration}
    FSavedNegCurrFormat: Byte;
    FSavedThousandSeparator: Char;
    FSavedDecimalSeparator: Char;
    FNumRecords: Integer;
    FBufferWidth: Double;
    FVectorType: TEzVectorType;
    FOrderBy: TStrings;
    FDescending: Boolean;
    FClosestMax: Integer;
    function AddExpression(Expression: TExpression): TExpression;
    function GetParamList: TParameterList;
    function ForceParamList(Count: Integer): TParameterList;
    procedure GetTwoOperators;
    procedure GetOneOperator;
    procedure AddParam;
    function GetString( const s: string ): string;
  public
    constructor Create(MainExpr: TEzMainExpr);
    destructor Destroy; override;
    function yyparse : integer; override;
    function GetExpression: TExpression;
    property IsComplex: Boolean read FIsComplex write FIsComplex;
    property OnIdentifierFunction: TIdentifierFunctionEvent read FOnIdentifierFunction write FOnIdentifierFunction;
    property Vector: TEzVector read FVector;
    property OrderBy: TStrings read FOrderBy;
    property ClosestMax: Integer read FClosestMax;
  end;


//
// The generated constants must be placed here
// HERE !!!!
//

implementation

(*----------------------------------------------------------------------------*)
constructor TExprParser.Create(MainExpr: TEzMainExpr);
begin
  inherited Create;
  FMainExpr:= MainExpr; { belongs to }
  FExprList:= TList.Create;
  FStackedParamCount:= TList.Create;
  FGroupIdentList:= TStringList.create;
  FIdentifierList:= TStringList.create;
  FVector:= TEzVector.Create(10);
  FOrderBy:= TStringList.Create;
  { save configuration }
  FSavedNegCurrFormat:= NegCurrFormat;
  FSavedThousandSeparator:= ThousandSeparator;
  FSavedDecimalSeparator:= DecimalSeparator;
  NegCurrFormat:= 1;
  ThousandSeparator:= ',';
  DecimalSeparator:= '.';
end;

destructor TExprParser.Destroy;
var
  I: Integer;
begin
  for I:= 0 to FExprList.Count-1 do
    TObject(FExprList[I]).Free;
  FExprList.Free;
  if FWhenParamList<>nil then
    FWhenParamList.Free;
  if FThenParamList<>nil then
    FThenParamList.Free;
  if FElseExpr<>nil then
    FElseExpr.Free;
  FStackedParamCount.Free;
  FGroupIdentList.free;
  FIdentifierList.free;
  FVector.Free;
  FOrderBy.Free;
  { restore configuration }
  NegCurrFormat:=  FSavedNegCurrFormat;
  ThousandSeparator:= FSavedThousandSeparator;
  DecimalSeparator:= FSavedDecimalSeparator;
  inherited Destroy;
end;

function TExprParser.GetString( const s: string ): string;
begin
  result:= copy( s, 2, length(s) - 2 );
end;

{ this function returns the final expression obtained }
function TExprParser.GetExpression: TExpression;
begin
  Result:= nil;
  if FExprList.Count <> 1 then Exit;
  Result := TExpression( FExprList[0] );
  FExprList.Delete( 0 );
end;

function TExprParser.GetParamList: TParameterList;
var
  I: Integer;
  NumParams: Integer;
begin
  Result:= nil;
  if FStackedParamCount.Count=0 then
    NumParams:= 0
  else
  begin
    NumParams:= Longint(FStackedParamCount[FStackedParamCount.Count-1]);
    FStackedParamCount.Delete(FStackedParamCount.Count-1);
  end;
  if (FExprList.Count=0) or (NumParams=0) or (NumParams>FExprList.Count) then Exit;
  Result:= TParameterList.Create;
  for I:= 0 to NumParams - 1 do
    Result.Add(FExprList[FExprList.Count - NumParams + I]);
  while NumParams > 0 do
  begin
    FExprList.Delete(FExprList.Count-1);
    Dec(NumParams);
  end;
end;

function TExprParser.ForceParamList(Count: Integer): TParameterList;
var
  I: Integer;
  NumParams: Integer;
begin
  Result:= nil;
  NumParams:= Count;
  if (FExprList.Count=0) or (NumParams=0) or (NumParams>FExprList.Count) then Exit;
  Result:= TParameterList.Create;
  for I:= 0 to NumParams - 1 do
    Result.Add(FExprList[FExprList.Count - NumParams + I]);
  while NumParams > 0 do
  begin
    FExprList.Delete(FExprList.Count-1);
    Dec(NumParams);
  end;
end;

procedure TExprParser.GetTwoOperators;
begin
  Op1:= TExpression( FExprList[FExprList.Count - 2] );
  Op2:= TExpression( FExprList[FExprList.Count - 1] );
  FExprList.Delete( FExprList.Count - 1 );
  FExprList.Delete( FExprList.Count - 1 );
end;

procedure TExprParser.GetOneOperator;
begin
  Op1:= TExpression( FExprList[FExprList.Count - 1] );
  FExprList.Delete( FExprList.Count - 1 );
end;

procedure TExprParser.AddParam;
begin
  FParamCount:= Longint(FStackedParamCount[FStackedParamCount.Count-1]);
  Inc(FParamCount);
  FStackedParamCount[FStackedParamCount.Count-1]:= Pointer(FParamCount);
end;

function TExprParser.AddExpression( Expression: TExpression ): TExpression;
begin
  FExprList.Add( Expression );
  FIsComplex:= True;
  Result:= Expression;
end;

%}

%start defined_expr

%token _IDENTIFIER
%token _UINTEGER
%token _SINTEGER
%token _NUMERIC
%token _STRING

%token _COMA
%token _LPAREN
%token _RPAREN
%token _LSQUARE
%token _RSQUARE
%token _PERIOD
%token _SEMICOLON
%token _COMMENT
%token _BLANK
%token _TAB
%token _NEWLINE

%left  RW_OR RW_XOR RW_AND
%left  _EQ _NEQ _GT _LT _GE _LE RW_BETWEEN RW_IN RW_LIKE
%left  _PLUS _SUB
%left  _DIV RW_DIV _MULT RW_MOD RW_SHL RW_SHR
%right UMINUS       /* Negation--unary minus */
%right _EXP         /* exponentiation */
%left  RW_NOT
%token _ILLEGAL


/* other reserved words and tokens */
%token  RW_TRUE
        RW_FALSE
        RW_STRING
        RW_FLOAT
        RW_INTEGER
        RW_BOOLEAN
        RW_IN
        RW_CASE
        RW_WHEN
        RW_THEN
        RW_ELSE
        RW_END
        RW_IF
        RW_CAST
        RW_AS
        RW_ESCAPE

        RW_WITHIN
        RW_ENTIRELY
        RW_CONTAINS
        RW_ENTIRE
        RW_INTERSECTS
        RW_EXTENT
        RW_OVERLAPS
        RW_SHARE
        RW_COMMON
        RW_POINT
        RW_LINE
        RW_CROSS
        RW_EDGE
        RW_TOUCH
        RW_CENTROID
        RW_IDENTICAL

        RW_VECTOR
        RW_ALL
        RW_RECORDS
        RW_ENT
        RW_SCOPE
        RW_POLYLINE
        RW_POLYGON
        RW_BUFFER
        RW_WIDTH
        RW_ORDER
        RW_BY
        RW_DESC
        RW_DESCENDING

%type <string>

%%

defined_expr : basic_expr orderby
             ;

basic_expr : expr_constant
           | define_vector
           | RW_ENT
             { AddExpression( TEntExpr.Create(nil, FMainExpr.Gis, FMainExpr.DefaultLayer) ); }
           | ent_identifier
           | define_identifier parameter_list
             { FGroupIdent:= FGroupIdentList[FGroupIdentList.Count-1];
               FGroupIdentList.Delete(FGroupIdentList.Count-1);
               FIdentifier:= FIdentifierList[FIdentifierList.Count-1];
               FIdentifierList.Delete(FIdentifierList.Count-1);
               FTempParams:= GetParamList;

               IDF:=nil;
               if Assigned(FOnIdentifierFunction) then
                 FOnIdentifierFunction(Self, FGroupIdent, FIdentifier, FTempParams, IDF);
               if IDF <> nil then
               begin
                 if Length(FGroupIdent)=0 then
                   AddExpression(IDF)
                 else
                 begin
                   FExprList.Add(IDF);
                 end;
               end else
               begin
                 if CompareText(FIdentifier,'LTRIM')=0 then
                   IDF:= AddExpression(TStringExpression.Create(FTempParams, sfLTrim))
                 else if CompareText(FIdentifier,'RTRIM')=0 then
                   IDF:= AddExpression(TStringExpression.Create(FTempParams, sfRTrim))
                 else if CompareText(FIdentifier,'TRIM')=0 then
                   IDF:= AddExpression(TStringExpression.Create(FTempParams, sfTrim))
                 else if CompareText(FIdentifier,'TRUNC')=0 then
                   IDF:= AddExpression(TMathExpression.Create(FTempParams, mfTrunc))
                 else if CompareText(FIdentifier,'ROUND')=0 then
                   IDF:= AddExpression(TMathExpression.Create(FTempParams, mfRound))
                 else if CompareText(FIdentifier,'ABS')=0 then
                   IDF:= AddExpression(TMathExpression.Create(FTempParams, mfAbs))
                 else if CompareText(FIdentifier,'ARCTAN')=0 then
                   IDF:= AddExpression(TMathExpression.Create(FTempParams, mfArcTan))
                 else if CompareText(FIdentifier,'COS')=0 then
                   IDF:= AddExpression(TMathExpression.Create(FTempParams, mfCos))
                 else if CompareText(FIdentifier,'SIN')=0 then
                   IDF:= AddExpression(TMathExpression.Create(FTempParams, mfSin))
                 else if CompareText(FIdentifier,'EXP')=0 then
                   IDF:= AddExpression(TMathExpression.Create(FTempParams, mfExp))
                 else if CompareText(FIdentifier,'FRAC')=0 then
                   IDF:= AddExpression(TMathExpression.Create(FTempParams, mfFrac))
                 else if CompareText(FIdentifier,'INT')=0 then
                   IDF:= AddExpression(TMathExpression.Create(FTempParams, mfInt))
                 else if CompareText(FIdentifier,'LN')=0 then
                   IDF:= AddExpression(TMathExpression.Create(FTempParams, mfLn))
                 else if CompareText(FIdentifier,'PI')=0 then
                   IDF:= AddExpression(TMathExpression.Create(FTempParams, mfPi))
                 else if CompareText(FIdentifier,'SQR')=0 then
                   IDF:= AddExpression(TMathExpression.Create(FTempParams, mfSqr))
                 else if CompareText(FIdentifier,'SQRT')=0 then
                   IDF:= AddExpression(TMathExpression.Create(FTempParams, mfSqrt))
                 else if CompareText(FIdentifier,'POWER')=0 then
                   IDF:= AddExpression(TMathExpression.Create(FTempParams, mfPower))
                 else if CompareText(FIdentifier,'UPPER')=0 then
                   IDF:= AddExpression(TStringExpression.Create(FTempParams, sfUpper))
                 else if CompareText(FIdentifier,'LOWER')=0 then
                   IDF:= AddExpression(TStringExpression.Create(FTempParams, sfLower))
                 else if CompareText(FIdentifier,'COPY')=0 then
                   IDF:= AddExpression(TStringExpression.Create(FTempParams, sfCopy))
                 else if CompareText(FIdentifier,'SUBSTRING')=0 then
                   IDF:= AddExpression(TStringExpression.Create(FTempParams, sfCopy))
                 else if CompareText(FIdentifier,'POS')=0 then
                   IDF:= AddExpression(TStringExpression.Create(FTempParams, sfPos))
                 else if CompareText(FIdentifier,'CHARINDEX')=0 then
                   IDF:= AddExpression(TStringExpression.Create(FTempParams, sfPos))
                 else if CompareText(FIdentifier,'LENGTH')=0 then
                   IDF:= AddExpression(TStringExpression.Create(FTempParams, sfLength))
                 else if CompareText(FIdentifier,'LEFT')=0 then
                   IDF:= AddExpression(TLeftExpr.Create(FTempParams))
                 else if CompareText(FIdentifier,'RIGHT')=0 then
                   IDF:= AddExpression(TRightExpr.Create(FTempParams))
                 else if CompareText(FIdentifier,'YEAR')=0 then
                   IDF:= AddExpression(TDecodeDateTimeExpr.Create(FTempParams, dkYear))
                 else if CompareText(FIdentifier,'MONTH')=0 then
                   IDF:= AddExpression(TDecodeDateTimeExpr.Create(FTempParams, dkMonth))
                 else if CompareText(FIdentifier,'DAY')=0 then
                   IDF:= AddExpression(TDecodeDateTimeExpr.Create(FTempParams, dkDay))
                 else if CompareText(FIdentifier,'HOUR')=0 then
                   IDF:= AddExpression(TDecodeDateTimeExpr.Create(FTempParams, dkHour))
                 else if CompareText(FIdentifier,'MIN')=0 then
                   IDF:= AddExpression(TDecodeDateTimeExpr.Create(FTempParams, dkMin))
                 else if CompareText(FIdentifier,'SEC')=0 then
                   IDF:= AddExpression(TDecodeDateTimeExpr.Create(FTempParams, dkSec))
                 else if CompareText(FIdentifier,'MSEC')=0 then
                   IDF:= AddExpression(TDecodeDateTimeExpr.Create(FTempParams, dkMSec))
                 else if CompareText(FIdentifier,'FORMATDATETIME')=0 then
                   IDF:= AddExpression(TFormatDateTimeExpr.Create(FTempParams))
                 else if CompareText(FIdentifier,'FORMATFLOAT')=0 then
                   IDF:= AddExpression(TFormatFloatExpr.Create(FTempParams))
                 else if CompareText(FIdentifier,'FORMAT')=0 then
                   IDF:= AddExpression(TFormatExpr.Create(FTempParams))
                 else if CompareText(FIdentifier,'DECODE')=0 then
                   IDF:= AddExpression(TDecodeExpr.Create(FTempParams))
                 else if CompareText(FIdentifier,'MINOF')=0 then
                   IDF:= AddExpression(TMinMaxOfExpr.Create(FTempParams, True))
                 else if CompareText(FIdentifier,'MAXOF')=0 then
                   IDF:= AddExpression(TMinMaxOfExpr.Create(FTempParams, False))
                 else if CompareText(FIdentifier,'SQLLIKE')=0 then
                   IDF:= AddExpression(TSQLLikeExpr.Create(FTempParams, False))
                 else if CompareText(FIdentifier,'SQLNOTLIKE')=0 then
                   IDF:= AddExpression(TSQLLikeExpr.Create(FTempParams, True))
                 else if CompareText(FIdentifier,'ASCII')=0 then
                   IDF:= AddExpression(TASCIIExpr.Create(FTempParams));
               end;
               if IDF= nil then
               begin
                 FTempParams.Free;
                 yyerror(Format('Unknown Identifier %s', [$<string>1]));
                 yyabort;
                 Exit;
               end;
             }
           | RW_CAST _LPAREN basic_expr RW_AS RW_STRING _RPAREN
             { AddExpression(TTypeCast.Create(ForceParamList(1), ttString)); }
           | RW_FLOAT parameter_list
             { AddExpression(TTypeCast.Create(GetParamList, ttFloat)); }
           | RW_CAST _LPAREN basic_expr RW_AS RW_FLOAT _RPAREN
             { AddExpression(TTypeCast.Create(ForceParamList(1), ttFloat)); }
           | RW_INTEGER parameter_list
             { AddExpression(TTypeCast.Create(GetParamList, ttInteger)); }
           | RW_CAST _LPAREN basic_expr RW_AS RW_INTEGER _RPAREN
             { AddExpression(TTypeCast.Create(ForceParamList(1), ttInteger)); }
           | RW_BOOLEAN parameter_list
             { AddExpression(TTypeCast.Create(GetParamList, ttBoolean)); }
           | RW_CAST _LPAREN basic_expr RW_AS RW_BOOLEAN _RPAREN
             { AddExpression(TTypeCast.Create(ForceParamList(1), ttBoolean)); }
           | RW_IF parameter_list
             { AddExpression(TConditional.Create(GetParamList)); }
           | case_clause
             { AddExpression(TCaseWhenElseExpr.Create(FWhenParamList, FThenParamList, FElseExpr));
               FWhenParamList:= nil;
               FThenParamList:= nil;
               FElseExpr:= nil;
             }
           | basic_expr RW_BETWEEN expr_constant RW_AND expr_constant
             { AddExpression( TBetweenExpr.Create(ForceParamList(3), FALSE) ); }
           | basic_expr RW_NOT RW_BETWEEN expr_constant RW_AND expr_constant
             { AddExpression( TBetweenExpr.Create(ForceParamList(3), TRUE) ); }
           | basic_expr RW_IN parameter_list
             { AddExpression( TSQLInPredicateExpr.Create(ForceParamList(FParamCount + 1), FALSE) ); }
           | basic_expr RW_NOT RW_IN parameter_list
             { AddExpression( TSQLInPredicateExpr.Create(ForceParamList(FParamCount + 1), TRUE) ); }
           | basic_expr RW_LIKE expr_constant escape_character
             { AddExpression(TSQLLikeExpr.Create(ForceParamList(3), FALSE)); }
           | basic_expr RW_NOT RW_LIKE expr_constant escape_character
             { AddExpression(TSQLLikeExpr.Create(ForceParamList(3), TRUE)); }
           | _SUB basic_expr %prec UMINUS
             { GetOneOperator;
               AddExpression(TUnaryOp.Create(opMinus, Op1));
               FIsComplex:= True;}
           | _PLUS basic_expr %prec UMINUS
             { GetOneOperator;
               AddExpression(TUnaryOp.Create(opPlus, Op1));
               FIsComplex:= True;}
           | RW_NOT basic_expr
             { GetOneOperator;
               AddExpression(TUnaryOp.Create(opNot, Op1));
               FIsComplex:= True;}
           | basic_expr _PLUS basic_expr
             { GetTwoOperators;
               AddExpression(TBinaryOp.Create(opPlus, Op1, Op2));
               FIsComplex:= True;}
           | basic_expr _SUB basic_expr
             { GetTwoOperators;
               AddExpression(TBinaryOp.Create(opMinus, Op1, Op2));
               FIsComplex:= True;}
           | basic_expr _MULT basic_expr
             { GetTwoOperators;
               AddExpression(TBinaryOp.Create(opMult, Op1, Op2));
               FIsComplex:= True;}
           | basic_expr _DIV basic_expr
             { GetTwoOperators;
               AddExpression(TBinaryOp.Create(opDivide, Op1, Op2));
               FIsComplex:= True;}
           | basic_expr RW_DIV basic_expr
             { GetTwoOperators;
               AddExpression(TBinaryOp.Create(opDiv, Op1, Op2));
               FIsComplex:= True;}
           | basic_expr _EXP basic_expr
             { GetTwoOperators;
               AddExpression(TBinaryOp.Create(opExp, Op1, Op2));
               FIsComplex:= True;}
           | basic_expr RW_MOD basic_expr
             { GetTwoOperators;
               AddExpression(TBinaryOp.Create(opMod, Op1, Op2));
               FIsComplex:= True;}
           | basic_expr RW_SHL basic_expr
             { GetTwoOperators;
               AddExpression(TBinaryOp.Create(opShl, Op1, Op2));
               FIsComplex:= True;}
           | basic_expr RW_SHR basic_expr
             { GetTwoOperators;
               AddExpression(TBinaryOp.Create(opShr, Op1, Op2));
               FIsComplex:= True;}
           | basic_expr _GE basic_expr
             { GetTwoOperators;
               AddExpression(TRelationalOp.Create(opGTE, Op1, Op2));
               FIsComplex:= True;}
           | basic_expr _LE basic_expr
             { GetTwoOperators;
               AddExpression(TRelationalOp.Create(opLTE, Op1, Op2));
               FIsComplex:= True;}
           | basic_expr _GT basic_expr
             { GetTwoOperators;
               AddExpression(TRelationalOp.Create(opGT, Op1, Op2));
               FIsComplex:= True;}
           | basic_expr _LT basic_expr
             { GetTwoOperators;
               AddExpression(TRelationalOp.Create(opLT, Op1, Op2));
               FIsComplex:= True;}
           | basic_expr _EQ basic_expr
             { GetTwoOperators;
               AddExpression(TRelationalOp.Create(opEQ, Op1, Op2));
               FIsComplex:= True;}
           | basic_expr _NEQ basic_expr
             { GetTwoOperators;
               AddExpression(TRelationalOp.Create(opNEQ, Op1, Op2));
               FIsComplex:= True;}
           | basic_expr RW_AND basic_expr
             { GetTwoOperators;
               AddExpression(TBinaryOp.Create(opAnd, Op1, Op2));
               FIsComplex:= True;}
           | basic_expr RW_OR basic_expr
             { GetTwoOperators;
               AddExpression(TBinaryOp.Create(opOr, Op1, Op2));
               FIsComplex:= True;}
           | basic_expr RW_XOR basic_expr
             { GetTwoOperators;
               AddExpression(TBinaryOp.Create(opXOr, Op1, Op2));
               FIsComplex:= True;}
           | _LPAREN basic_expr _RPAREN
             { FIsComplex:= True; }
           | spatial_query
           ;

parameter_list : /* empty */
                 { FStackedParamCount.Add(Pointer(0)); }
               | start_list _RPAREN
               | start_list list_param _RPAREN
               ;

start_list : _LPAREN
             { FStackedParamCount.Add(Pointer(0)); }
           ;

list_param : basic_expr
             { AddParam; }
           | list_param _COMA basic_expr
             { AddParam; }
           ;

/* CASE...WHEN...THEN...ELSE...END clause */
case_clause : RW_CASE when_list else_clause RW_END
            ;

when_list : when_clause
          | when_list when_clause
          ;

when_clause : RW_WHEN basic_expr RW_THEN basic_expr
              { if FWhenParamList=nil then
                  FWhenParamList:= TParameterList.Create;
                if FThenParamList=nil then
                  FThenParamList:= TParameterList.Create;
                FWhenParamList.Add(FExprList[FExprList.Count-2]);
                FThenParamList.Add(FExprList[FExprList.Count-1]);
                FExprList.Delete(FExprList.Count-1);
                FExprList.Delete(FExprList.Count-1);
              }
            ;

else_clause : /* empty */
            | RW_ELSE basic_expr
              { FElseExpr:= TExpression(FExprList[FExprList.Count-1]);
                FExprList.Delete(FExprList.Count-1);
              }
            ;

define_identifier : _IDENTIFIER
                    { FGroupIdentList.Add('');
                      FIdentifierList.Add(UpperCase($<string>1));
                    }
                  | _IDENTIFIER _PERIOD _IDENTIFIER
                    { FGroupIdentList.Add(UpperCase($<string>1));
                      FIdentifierList.Add(UpperCase($<string>3));
                    }
                  ;

expr_constant : _UINTEGER
                { Val($<string>1, IntVal, Code);
                  if Code=0 then
                    FExprList.Add(TIntegerLiteral.Create(StrToInt($<string>1)))
                  else
                    FExprList.Add(TFloatLiteral.Create(StrToFloat($<string>1)));
                }
              | _SINTEGER
                { Val($<string>1, IntVal, Code);
                  if Code=0 then
                    FExprList.Add(TIntegerLiteral.Create(StrToInt($<string>1)))
                  else
                    FExprList.Add(TFloatLiteral.Create(StrToFloat($<string>1)));
                }
              | _NUMERIC   { FExprList.Add(TFloatLiteral.Create(StrToFloat($<string>1))); }
              | _STRING    { FExprList.Add(TStringLiteral.Create(GetString( $<string>1 ))); }
              | RW_TRUE    { FExprList.Add(TBooleanLiteral.Create(True)); }
              | RW_FALSE   { FExprList.Add(TBooleanLiteral.Create(False)); }
              ;

escape_character : /* empty */
                   { FExprList.Add(TStringLiteral.Create('')); }
                 | RW_ESCAPE _STRING
                   { FExprList.Add(TStringLiteral.Create(GetString( $<string>2 ) )); }
                 ;

/* for expressions involving graphical operators, like WITHIN, CONTAINS,...,etc */

graphic_operator : RW_INTERSECTS
                   { AddExpression( TEzGraphicOperatorExpr.Create(nil, goIntersects) ); }
                 | RW_WITHIN
                   { AddExpression( TEzGraphicOperatorExpr.Create(nil, goWithin) ); }
                 | RW_ENTIRELY RW_WITHIN
                   { AddExpression( TEzGraphicOperatorExpr.Create(nil, goEntirelyWithin) ); }
                 | RW_CONTAINS
                   { AddExpression( TEzGraphicOperatorExpr.Create(nil, goContains) ); }
                 | RW_CONTAINS RW_ENTIRE
                   { AddExpression( TEzGraphicOperatorExpr.Create(nil, goContainsEntire) ); }

                 | RW_ENTIRELY RW_WITHIN RW_NOT RW_EDGE RW_TOUCH
                   { AddExpression( TEzGraphicOperatorExpr.Create(nil, goEntirelyWithinNoEdgeTouched) ); }
                 | RW_CONTAINS RW_ENTIRE RW_NOT RW_EDGE RW_TOUCH
                   { AddExpression( TEzGraphicOperatorExpr.Create(nil, goContainsEntireNoEdgeTouched) ); }
                 | RW_EXTENT RW_OVERLAPS
                   { AddExpression( TEzGraphicOperatorExpr.Create(nil, goExtentOverlaps) ); }
                 | RW_SHARE RW_COMMON RW_POINT
                   { AddExpression( TEzGraphicOperatorExpr.Create(nil, goShareCommonPoint) ); }
                 | RW_SHARE RW_COMMON RW_LINE
                   { AddExpression( TEzGraphicOperatorExpr.Create(nil, goShareCommonLine) ); }
                 | RW_LINE RW_CROSS
                   { AddExpression( TEzGraphicOperatorExpr.Create(nil, goLineCross) ); }
                 | RW_COMMON RW_POINT RW_OR RW_LINE RW_CROSS
                   { AddExpression( TEzGraphicOperatorExpr.Create(nil, goCommonPointOrLineCross) ); }
                 | RW_EDGE RW_TOUCH
                   { AddExpression( TEzGraphicOperatorExpr.Create(nil, goEdgeTouch) ); }
                 | RW_EDGE RW_TOUCH RW_OR RW_INTERSECTS
                   { AddExpression( TEzGraphicOperatorExpr.Create(nil, goEdgeTouchOrIntersect) ); }
                 | RW_POINT RW_IN RW_POLYGON
                   { AddExpression( TEzGraphicOperatorExpr.Create(nil, goPointInPolygon) ); }
                 | RW_CENTROID RW_IN RW_POLYGON
                   { AddExpression( TEzGraphicOperatorExpr.Create(nil, goCentroidInPolygon) ); }
                 | RW_IDENTICAL
                   { AddExpression( TEzGraphicOperatorExpr.Create(nil, goIdentical) ); }

                 ;

define_vector : define_vector_type _LPAREN _LSQUARE multipart_list _RSQUARE _RPAREN buffer_width
                { AddExpression( TEzVectorExpr.Create( Nil, FVector, FVectorType, FBufferWidth ) );
                  FVector.Clear;
                  FBufferWidth:= 0; }
              ;

define_vector_type : RW_VECTOR     { FVectorType:= vtUndefined; }
                   | RW_POLYLINE   { FVectorType:= vtPolyline; }
                   | RW_POLYGON    { FVectorType:= vtPolygon; }
                   | RW_BUFFER     { FVectorType:= vtBuffer; }
                   ;

buffer_width : /* empty */
             | RW_WIDTH numeric_value  { FBufferWidth := StrToFloat( $<string>2 ); }
             ;

multipart_list : points_list
               | multipart_list part_separator points_list
               ;

part_separator : _SEMICOLON
                 { if FVector.Parts.Count=0 then FVector.Parts.Add(0);
                   FVector.Parts.Add(FVector.Count); }

points_list : define_point
            | points_list _COMA define_point
            ;

define_point : _LPAREN numeric_value _COMA numeric_value _RPAREN
               { FVector.AddPoint(StrToFloat($<string>2), StrToFloat($<string>4)); }
             ;

numeric_value : _UINTEGER
              | _SINTEGER
              | _NUMERIC
              ;

record_list : _UINTEGER
              { FExprList.Add(TIntegerLiteral.Create(StrToInt($<string>1)));
                Inc( FNumRecords ); }
            | record_list _COMA _UINTEGER
              { FExprList.Add(TIntegerLiteral.Create(StrToInt($<string>3)));
                Inc( FNumRecords ); }
            ;

ent_identifier : _IDENTIFIER _PERIOD RW_ENT
                 { AddExpression( TEntExpr.Create(nil, FMainExpr.Gis,
                     FMainExpr.Gis.Layers.LayerByName( $<string>1 )) ); }
               ;

spatial_query : ent_identifier graphic_operator define_vector
                { AddExpression( TEzQueryVectorExpr.Create(ForceParamList(3), FMainExpr ) ); }
              | ent_identifier RW_SCOPE _LPAREN basic_expr _RPAREN
                { AddExpression( TEzQueryScopeExpr.Create(ForceParamList(2), FMainExpr ) ); }
              | ent_identifier graphic_operator ent_identifier
                { //!!! pendiente de implementar aqui la comparacion registro a registro para JOINs en SQL!!! }
              | ent_identifier graphic_operator ent_identifier RW_RECORDS _LPAREN record_list _RPAREN
                { AddExpression( TEzQueryLayerExpr.Create(ForceParamList( FNumRecords + 3 ), FMainExpr ) );
                  FNumRecords:= 0; }
              | ent_identifier graphic_operator ent_identifier RW_ALL RW_RECORDS
                { AddExpression( TEzQueryLayerExpr.Create(ForceParamList(3), FMainExpr ) ); }
              | ent_identifier graphic_operator spatial_query
                { AddExpression( TEzQueryLayerExpr.Create(ForceParamList(3), FMainExpr ) ); }
              ;


orderby : /* empty */
        | RW_ORDER RW_BY orderby_list
        ;

orderby_list : orderby_one
             | orderby_list _COMA orderby_one
             ;

orderby_one : basic_expr descending
              { GetOneOperator;
                FreeAndNil( Op1 );
                FOrderBy.AddObject( $<string>1, Pointer( Ord( FDescending ) ) );
                FDescending := False;
              }
            ;

descending : /* empty */
           | RW_DESC       { FDescending := True; }
           | RW_DESCENDING { FDescending := True; }
           ;

%%
