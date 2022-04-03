
// Template for ExprParser



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


const _IDENTIFIER = 257;
const _UINTEGER = 258;
const _SINTEGER = 259;
const _NUMERIC = 260;
const _STRING = 261;
const _COMA = 262;
const _LPAREN = 263;
const _RPAREN = 264;
const _LSQUARE = 265;
const _RSQUARE = 266;
const _PERIOD = 267;
const _SEMICOLON = 268;
const _COMMENT = 269;
const _BLANK = 270;
const _TAB = 271;
const _NEWLINE = 272;
const RW_OR = 273;
const RW_XOR = 274;
const RW_AND = 275;
const _EQ = 276;
const _NEQ = 277;
const _GT = 278;
const _LT = 279;
const _GE = 280;
const _LE = 281;
const RW_BETWEEN = 282;
const RW_IN = 283;
const RW_LIKE = 284;
const _PLUS = 285;
const _SUB = 286;
const _DIV = 287;
const RW_DIV = 288;
const _MULT = 289;
const RW_MOD = 290;
const RW_SHL = 291;
const RW_SHR = 292;
const UMINUS = 293;
const _EXP = 294;
const RW_NOT = 295;
const _ILLEGAL = 296;
const RW_TRUE = 297;
const RW_FALSE = 298;
const RW_STRING = 299;
const RW_FLOAT = 300;
const RW_INTEGER = 301;
const RW_BOOLEAN = 302;
const RW_CASE = 303;
const RW_WHEN = 304;
const RW_THEN = 305;
const RW_ELSE = 306;
const RW_END = 307;
const RW_IF = 308;
const RW_CAST = 309;
const RW_AS = 310;
const RW_ESCAPE = 311;
const RW_WITHIN = 312;
const RW_ENTIRELY = 313;
const RW_CONTAINS = 314;
const RW_ENTIRE = 315;
const RW_INTERSECTS = 316;
const RW_EXTENT = 317;
const RW_OVERLAPS = 318;
const RW_SHARE = 319;
const RW_COMMON = 320;
const RW_POINT = 321;
const RW_LINE = 322;
const RW_CROSS = 323;
const RW_EDGE = 324;
const RW_TOUCH = 325;
const RW_CENTROID = 326;
const RW_IDENTICAL = 327;
const RW_VECTOR = 328;
const RW_ALL = 329;
const RW_RECORDS = 330;
const RW_ENT = 331;
const RW_SCOPE = 332;
const RW_POLYLINE = 333;
const RW_POLYGON = 334;
const RW_BUFFER = 335;
const RW_WIDTH = 336;
const RW_ORDER = 337;
const RW_BY = 338;
const RW_DESC = 339;
const RW_DESCENDING = 340;

type YYSType = record
               yystring : string
               end(*YYSType*);

// global definitions:

var yylval : YYSType;

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

// function yylex : Integer; forward;  // addition 1

function TExprParser.yyparse : Integer; // addition 2

var yystate, yysp, yyn : SmallInt;
    yys : array [1..yymaxdepth] of SmallInt;
    yyv : array [1..yymaxdepth] of YYSType;
    yyval : YYSType;

procedure yyaction ( yyruleno : Integer );
  (* local definitions: *)
var
  IntVal, Code: Integer;
begin
  (* actions: *)
  case yyruleno of
   1 : begin
         yyval := yyv[yysp-1];
       end;
   2 : begin
         yyval := yyv[yysp-0];
       end;
   3 : begin
         yyval := yyv[yysp-0];
       end;
   4 : begin
         AddExpression( TEntExpr.Create(nil, FMainExpr.Gis, FMainExpr.DefaultLayer) );
       end;
   5 : begin
         yyval := yyv[yysp-0];
       end;
   6 : begin
         FGroupIdent:= FGroupIdentList[FGroupIdentList.Count-1];
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
         yyerror(Format('Unknown Identifier %s', [yyv[yysp-1].yystring]));
         yyabort;
         Exit;
         end;

       end;
   7 : begin
         AddExpression(TTypeCast.Create(ForceParamList(1), ttString));
       end;
   8 : begin
         AddExpression(TTypeCast.Create(GetParamList, ttFloat));
       end;
   9 : begin
         AddExpression(TTypeCast.Create(ForceParamList(1), ttFloat));
       end;
  10 : begin
         AddExpression(TTypeCast.Create(GetParamList, ttInteger));
       end;
  11 : begin
         AddExpression(TTypeCast.Create(ForceParamList(1), ttInteger));
       end;
  12 : begin
         AddExpression(TTypeCast.Create(GetParamList, ttBoolean));
       end;
  13 : begin
         AddExpression(TTypeCast.Create(ForceParamList(1), ttBoolean));
       end;
  14 : begin
         AddExpression(TConditional.Create(GetParamList));
       end;
  15 : begin
         AddExpression(TCaseWhenElseExpr.Create(FWhenParamList, FThenParamList, FElseExpr));
         FWhenParamList:= nil;
         FThenParamList:= nil;
         FElseExpr:= nil;

       end;
  16 : begin
         AddExpression( TBetweenExpr.Create(ForceParamList(3), FALSE) );
       end;
  17 : begin
         AddExpression( TBetweenExpr.Create(ForceParamList(3), TRUE) );
       end;
  18 : begin
         AddExpression( TSQLInPredicateExpr.Create(ForceParamList(FParamCount + 1), FALSE) );
       end;
  19 : begin
         AddExpression( TSQLInPredicateExpr.Create(ForceParamList(FParamCount + 1), TRUE) );
       end;
  20 : begin
         AddExpression(TSQLLikeExpr.Create(ForceParamList(3), FALSE));
       end;
  21 : begin
         AddExpression(TSQLLikeExpr.Create(ForceParamList(3), TRUE));
       end;
  22 : begin
         GetOneOperator;
         AddExpression(TUnaryOp.Create(opMinus, Op1));
         FIsComplex:= True;
       end;
  23 : begin
         GetOneOperator;
         AddExpression(TUnaryOp.Create(opPlus, Op1));
         FIsComplex:= True;
       end;
  24 : begin
         GetOneOperator;
         AddExpression(TUnaryOp.Create(opNot, Op1));
         FIsComplex:= True;
       end;
  25 : begin
         GetTwoOperators;
         AddExpression(TBinaryOp.Create(opPlus, Op1, Op2));
         FIsComplex:= True;
       end;
  26 : begin
         GetTwoOperators;
         AddExpression(TBinaryOp.Create(opMinus, Op1, Op2));
         FIsComplex:= True;
       end;
  27 : begin
         GetTwoOperators;
         AddExpression(TBinaryOp.Create(opMult, Op1, Op2));
         FIsComplex:= True;
       end;
  28 : begin
         GetTwoOperators;
         AddExpression(TBinaryOp.Create(opDivide, Op1, Op2));
         FIsComplex:= True;
       end;
  29 : begin
         GetTwoOperators;
         AddExpression(TBinaryOp.Create(opDiv, Op1, Op2));
         FIsComplex:= True;
       end;
  30 : begin
         GetTwoOperators;
         AddExpression(TBinaryOp.Create(opExp, Op1, Op2));
         FIsComplex:= True;
       end;
  31 : begin
         GetTwoOperators;
         AddExpression(TBinaryOp.Create(opMod, Op1, Op2));
         FIsComplex:= True;
       end;
  32 : begin
         GetTwoOperators;
         AddExpression(TBinaryOp.Create(opShl, Op1, Op2));
         FIsComplex:= True;
       end;
  33 : begin
         GetTwoOperators;
         AddExpression(TBinaryOp.Create(opShr, Op1, Op2));
         FIsComplex:= True;
       end;
  34 : begin
         GetTwoOperators;
         AddExpression(TRelationalOp.Create(opGTE, Op1, Op2));
         FIsComplex:= True;
       end;
  35 : begin
         GetTwoOperators;
         AddExpression(TRelationalOp.Create(opLTE, Op1, Op2));
         FIsComplex:= True;
       end;
  36 : begin
         GetTwoOperators;
         AddExpression(TRelationalOp.Create(opGT, Op1, Op2));
         FIsComplex:= True;
       end;
  37 : begin
         GetTwoOperators;
         AddExpression(TRelationalOp.Create(opLT, Op1, Op2));
         FIsComplex:= True;
       end;
  38 : begin
         GetTwoOperators;
         AddExpression(TRelationalOp.Create(opEQ, Op1, Op2));
         FIsComplex:= True;
       end;
  39 : begin
         GetTwoOperators;
         AddExpression(TRelationalOp.Create(opNEQ, Op1, Op2));
         FIsComplex:= True;
       end;
  40 : begin
         GetTwoOperators;
         AddExpression(TBinaryOp.Create(opAnd, Op1, Op2));
         FIsComplex:= True;
       end;
  41 : begin
         GetTwoOperators;
         AddExpression(TBinaryOp.Create(opOr, Op1, Op2));
         FIsComplex:= True;
       end;
  42 : begin
         GetTwoOperators;
         AddExpression(TBinaryOp.Create(opXOr, Op1, Op2));
         FIsComplex:= True;
       end;
  43 : begin
         FIsComplex:= True;
       end;
  44 : begin
         yyval := yyv[yysp-0];
       end;
  45 : begin
         FStackedParamCount.Add(Pointer(0));
       end;
  46 : begin
         yyval := yyv[yysp-1];
       end;
  47 : begin
         yyval := yyv[yysp-2];
       end;
  48 : begin
         FStackedParamCount.Add(Pointer(0));
       end;
  49 : begin
         AddParam;
       end;
  50 : begin
         AddParam;
       end;
  51 : begin
         yyval := yyv[yysp-3];
       end;
  52 : begin
         yyval := yyv[yysp-0];
       end;
  53 : begin
         yyval := yyv[yysp-1];
       end;
  54 : begin
         if FWhenParamList=nil then
         FWhenParamList:= TParameterList.Create;
         if FThenParamList=nil then
         FThenParamList:= TParameterList.Create;
         FWhenParamList.Add(FExprList[FExprList.Count-2]);
         FThenParamList.Add(FExprList[FExprList.Count-1]);
         FExprList.Delete(FExprList.Count-1);
         FExprList.Delete(FExprList.Count-1);

       end;
  55 : begin
       end;
  56 : begin
         FElseExpr:= TExpression(FExprList[FExprList.Count-1]);
         FExprList.Delete(FExprList.Count-1);

       end;
  57 : begin
         FGroupIdentList.Add('');
         FIdentifierList.Add(UpperCase(yyv[yysp-0].yystring));

       end;
  58 : begin
         FGroupIdentList.Add(UpperCase(yyv[yysp-2].yystring));
         FIdentifierList.Add(UpperCase(yyv[yysp-0].yystring));

       end;
  59 : begin
         Val(yyv[yysp-0].yystring, IntVal, Code);
         if Code=0 then
           FExprList.Add(TIntegerLiteral.Create(IntVal))
         else
           FExprList.Add(TFloatLiteral.Create(StrToFloat(yyv[yysp-0].yystring)));
       end;
  60 : begin
         Val(yyv[yysp-0].yystring, IntVal, Code);
         if Code=0 then
           FExprList.Add(TIntegerLiteral.Create(IntVal))
         else
           FExprList.Add(TFloatLiteral.Create(StrToFloat(yyv[yysp-0].yystring)));
       end;
  61 : begin
         FExprList.Add(TFloatLiteral.Create(StrToFloat(yyv[yysp-0].yystring)));
       end;
  62 : begin
         FExprList.Add(TStringLiteral.Create(GetString( yyv[yysp-0].yystring )));
       end;
  63 : begin
         FExprList.Add(TBooleanLiteral.Create(True));
       end;
  64 : begin
         FExprList.Add(TBooleanLiteral.Create(False));
       end;
  65 : begin
         FExprList.Add(TStringLiteral.Create(''));
       end;
  66 : begin
         FExprList.Add(TStringLiteral.Create(GetString( yyv[yysp-0].yystring ) ));
       end;
  67 : begin
         AddExpression( TEzGraphicOperatorExpr.Create(nil, goIntersects) );
       end;
  68 : begin
         AddExpression( TEzGraphicOperatorExpr.Create(nil, goWithin) );
       end;
  69 : begin
         AddExpression( TEzGraphicOperatorExpr.Create(nil, goEntirelyWithin) );
       end;
  70 : begin
         AddExpression( TEzGraphicOperatorExpr.Create(nil, goContains) );
       end;
  71 : begin
         AddExpression( TEzGraphicOperatorExpr.Create(nil, goContainsEntire) );
       end;
  72 : begin
         AddExpression( TEzGraphicOperatorExpr.Create(nil, goEntirelyWithinNoEdgeTouched) );
       end;
  73 : begin
         AddExpression( TEzGraphicOperatorExpr.Create(nil, goContainsEntireNoEdgeTouched) );
       end;
  74 : begin
         AddExpression( TEzGraphicOperatorExpr.Create(nil, goExtentOverlaps) );
       end;
  75 : begin
         AddExpression( TEzGraphicOperatorExpr.Create(nil, goShareCommonPoint) );
       end;
  76 : begin
         AddExpression( TEzGraphicOperatorExpr.Create(nil, goShareCommonLine) );
       end;
  77 : begin
         AddExpression( TEzGraphicOperatorExpr.Create(nil, goLineCross) );
       end;
  78 : begin
         AddExpression( TEzGraphicOperatorExpr.Create(nil, goCommonPointOrLineCross) );
       end;
  79 : begin
         AddExpression( TEzGraphicOperatorExpr.Create(nil, goEdgeTouch) );
       end;
  80 : begin
         AddExpression( TEzGraphicOperatorExpr.Create(nil, goEdgeTouchOrIntersect) );
       end;
  81 : begin
         AddExpression( TEzGraphicOperatorExpr.Create(nil, goPointInPolygon) );
       end;
  82 : begin
         AddExpression( TEzGraphicOperatorExpr.Create(nil, goCentroidInPolygon) );
       end;
  83 : begin
         AddExpression( TEzGraphicOperatorExpr.Create(nil, goIdentical) );
       end;
  84 : begin
         AddExpression( TEzVectorExpr.Create( Nil, FVector, FVectorType, FBufferWidth ) );
         FVector.Clear;
         FBufferWidth:= 0;
       end;
  85 : begin
         FVectorType:= vtUndefined;
       end;
  86 : begin
         FVectorType:= vtPolyline;
       end;
  87 : begin
         FVectorType:= vtPolygon;
       end;
  88 : begin
         FVectorType:= vtBuffer;
       end;
  89 : begin
       end;
  90 : begin
         FBufferWidth := StrToFloat( yyv[yysp-0].yystring );
       end;
  91 : begin
         yyval := yyv[yysp-0];
       end;
  92 : begin
         yyval := yyv[yysp-2];
       end;
  93 : begin
         if FVector.Parts.Count=0 then FVector.Parts.Add(0);
         FVector.Parts.Add(FVector.Count);
       end;
  94 : begin
         yyval := yyv[yysp-0];
       end;
  95 : begin
         yyval := yyv[yysp-2];
       end;
  96 : begin
         FVector.AddPoint(StrToFloat(yyv[yysp-3].yystring), StrToFloat(yyv[yysp-1].yystring));
       end;
  97 : begin
         yyval := yyv[yysp-0];
       end;
  98 : begin
         yyval := yyv[yysp-0];
       end;
  99 : begin
         yyval := yyv[yysp-0];
       end;
 100 : begin
         FExprList.Add(TIntegerLiteral.Create(StrToInt(yyv[yysp-0].yystring)));
         Inc( FNumRecords );
       end;
 101 : begin
         FExprList.Add(TIntegerLiteral.Create(StrToInt(yyv[yysp-0].yystring)));
         Inc( FNumRecords );
       end;
 102 : begin
         AddExpression( TEntExpr.Create(nil, FMainExpr.Gis,
         FMainExpr.Gis.Layers.LayerByName( yyv[yysp-2].yystring )) );
       end;
 103 : begin
         AddExpression( TEzQueryVectorExpr.Create(ForceParamList(3), FMainExpr ) );
       end;
 104 : begin
         AddExpression( TEzQueryScopeExpr.Create(ForceParamList(2), FMainExpr ) );
       end;
 105 : begin
         //!!! pendiente de implementar aqui la comparacion registro a registro para JOINs en SQL!!!
       end;
 106 : begin
         AddExpression( TEzQueryLayerExpr.Create(ForceParamList( FNumRecords + 3 ), FMainExpr ) );
         FNumRecords:= 0;
       end;
 107 : begin
         AddExpression( TEzQueryLayerExpr.Create(ForceParamList(3), FMainExpr ) );
       end;
 108 : begin
         AddExpression( TEzQueryLayerExpr.Create(ForceParamList(3), FMainExpr ) );
       end;
 109 : begin
       end;
 110 : begin
         yyval := yyv[yysp-2];
       end;
 111 : begin
         yyval := yyv[yysp-0];
       end;
 112 : begin
         yyval := yyv[yysp-2];
       end;
 113 : begin
         GetOneOperator;
         FreeAndNil( Op1 );
         FOrderBy.AddObject( yyv[yysp-1].yystring, Pointer( Ord( FDescending ) ) );
         FDescending := False;

       end;
 114 : begin
       end;
 115 : begin
         FDescending := True;
       end;
 116 : begin
         FDescending := True;
       end;
  end;
end(*yyaction*);

(* parse table: *)

type YYARec = record
                sym, act : SmallInt;
              end;
     YYRRec = record
                len, sym : SmallInt;
              end;

const

yynacts   = 2217;
yyngotos  = 309;
yynstates = 221;
yynrules  = 116;

var

yya : array [1..yynacts    ] of YYARec;
yyg : array [1..yyngotos   ] of YYARec;
yyd : array [0..yynstates-1] of SmallInt;
yyal: array [0..yynstates-1] of SmallInt;
yyah: array [0..yynstates-1] of SmallInt;
yygl: array [0..yynstates-1] of SmallInt;
yygh: array [0..yynstates-1] of SmallInt;
yyr : array [1..yynrules   ] of YYRRec;

procedure LoadResArrays;

  procedure ResLoad(const resname: string; ResourceBuffer: Pointer);
  var
    ResourceSize: Integer;
    ResourcePtr: PChar;
    BinResource: THandle;
    ResInstance: Longint;
    H: THandle;
    Buf: array[0..255] of Char;
  begin
    H := System.FindResourceHInstance(HInstance);
    StrPLCopy(Buf, resname, SizeOf(Buf)-1);
    ResInstance := FindResource(H, Buf, RT_RCDATA);
    if ResInstance = 0 then begin
      H := HInstance;
      {try to find in main binary}
      ResInstance := FindResource(H, Buf, RT_RCDATA);
    end;
    ResourceSize := SizeofResource(H,ResInstance);
    BinResource := LoadResource(H,ResInstance);
    ResourcePtr := LockResource(BinResource);
    Move(ResourcePtr^, ResourceBuffer^, ResourceSize);
    UnlockResource(BinResource);
    FreeResource(BinResource);

  end;
begin

  ResLoad('EzExprYacc_YYA', @yya[1]);
  ResLoad('EzExprYacc_YYG', @yyg[1]);

  ResLoad('EzExprYacc_YYD', @yyd[0]);

  ResLoad('EzExprYacc_YYAL', @yyal[0]);

  ResLoad('EzExprYacc_YYAH', @yyah[0]);

  ResLoad('EzExprYacc_YYGL', @yygl[0]);

  ResLoad('EzExprYacc_YYGH', @yygh[0]);

  ResLoad('EzExprYacc_YYR', @yyr[1]);


end;


const _error = 256; (* error token *)

function yyact(state, sym : Integer; var act : SmallInt) : Boolean;
  (* search action table *)
  var k : Integer;
  begin
    k := yyal[state];
    while (k<=yyah[state]) and (yya[k].sym<>sym) do inc(k);
    if k>yyah[state] then
      yyact := false
    else
      begin
        act := yya[k].act;
        yyact := true;
      end;
  end(*yyact*);

function yygoto(state, sym : Integer; var nstate : SmallInt) : Boolean;
  (* search goto table *)
  var k : Integer;
  begin
    k := yygl[state];
    while (k<=yygh[state]) and (yyg[k].sym<>sym) do inc(k);
    if k>yygh[state] then
      yygoto := false
    else
      begin
        nstate := yyg[k].act;
        yygoto := true;
      end;
  end(*yygoto*);

label parse, next, error, errlab, shift, reduce, accept, abort;

begin(*yyparse*)

  (* load arrays from resource *)
  LoadResArrays;

  yystate := 0; yychar := -1; yynerrs := 0; yyerrflag := 0; yysp := 0;

{$ifdef yydebug}
  yydebug := true;
{$else}
  yydebug := false;
{$endif}

parse:

  (* push state and value: *)

  inc(yysp);
  if yysp>yymaxdepth then
    begin
      yyerror('yyparse stack overflow');
      goto abort;
    end;
  yys[yysp] := yystate; yyv[yysp] := yyval;

next:

  if (yyd[yystate]=0) and (yychar=-1) then
    (* get next symbol *)
    begin
      repeat
         yychar := yyLexer.yylex; if yychar<0 then yychar := 0;
         // ignore comments and blanks [ \n\t]
         if not( (yychar=_COMMENT) or (yychar=_BLANK) or
                 (yychar=_TAB) or (yychar=_NEWLINE) ) then break;
      until false;
      if yychar= _ILLEGAL then goto error;
    end;

  (*
  if yydebug then
    writeln( yyLexer.yyOutput, 'state '+intToStr( yystate)+ ', char '+
                               intToStr( yychar) + ' at line n°'+
                               intToStr(yyLexer.yylineno) + ', col n°' +
                               intToStr( yyLexer.yycolno));
  *)

  (* determine parse action: *)

  yyn := yyd[yystate];
  if yyn<>0 then goto reduce; (* simple state *)

  (* no default action; search parse table *)

  if not yyact(yystate, yychar, yyn) then goto error
  else if yyn>0 then                      goto shift
  else if yyn<0 then                      goto reduce
  else                                    goto accept;

error:

  (* error; start error recovery: *)

  if yyerrflag=0 then yyerror('syntax error');

errlab:

  if yyerrflag=0 then inc(yynerrs);     (* new error *)

  if yyerrflag<=2 then                  (* incomplete recovery; try again *)
    begin
      yyerrflag := 3;
      (* uncover a state with shift action on error token *)
      while (yysp>0) and not ( yyact(yys[yysp], _error, yyn) and
                               (yyn>0) ) do
        begin
          (*
          if yydebug then
            if yysp>1 then
              writeln( yyLexer.yyOutput, 'error recovery pops state ' +
                       intToStr(yys[yysp])+', uncovers '+ intToStr(yys[yysp-1]))
            else
              writeln( yyLexer.yyOutput, 'error recovery fails ... abort');
          *)
          dec(yysp);
        end;
      if yysp=0 then goto abort; (* parser has fallen from stack; abort *)
      yystate := yyn;            (* simulate shift on error *)
      goto parse;
    end
  else                                  (* no shift yet; discard symbol *)
    begin
      (*
      if yydebug then
        writeln( yyLexer.yyOutput, 'error recovery discards char '+
                 intToStr( yychar));
      *)
      if yychar=0 then goto abort; (* end of input; abort *)
      yychar := -1; goto next;     (* clear lookahead char and try again *)
    end;

shift:

  (* go to new state, clear lookahead character: *)

  yystate := yyn; yychar := -1; yyval := yylval;
  if yyerrflag>0 then dec(yyerrflag);

  goto parse;

reduce:

  (* execute action, pop rule from stack, and go to next state: *)

  //if yydebug then writeln( yyLexer.yyOutput, 'reduce '+ intToStr( -yyn));

  yyflag := yyfnone; yyaction(-yyn);
  dec(yysp, yyr[-yyn].len);
  if yygoto(yys[yysp], yyr[-yyn].sym, yyn) then yystate := yyn;

  (* handle action calls to yyaccept, yyabort and yyerror: *)

  case yyflag of
    yyfaccept : goto accept;
    yyfabort  : goto abort;
    yyferror  : goto errlab;
  end;

  goto parse;

accept:

  yyparse := 0; exit;

abort:

  yyparse := 1; exit;

end(*yyparse*);

end.