
%{

{**************************************************}
{   Lexical analizer for EzGis Expression Parser   }
{**************************************************}

unit EzExprLex;

{$I ez_flag.pas}
interface

uses
  SysUtils, EzLexLib, EzExprYacc;

type
  TExprLexer = Class(TCustomLexer)
  public
    // utility functions
    function IsKeyword(const id : String; var token : integer) : boolean;
    // Lexer main functions
    function yylex : Integer; override;
    procedure yyaction( yyruleno : integer);
    procedure commenteof;
  end;

//===============================================
// reserved words definition
//===============================================

  TRWord = record
     rword: string[14];
     token: smallint;
  end;

  const
    rwords : array [1..55] of TRword = (
      (rword: 'AND';            token: RW_AND),
      (rword: 'OR';             token: RW_OR),
      (rword: 'XOR';            token: RW_XOR),
      (rword: 'NOT';            token: RW_NOT),
      (rword: 'MOD';            token: RW_MOD),
      (rword: 'TRUE';           token: RW_TRUE),
      (rword: 'FALSE';          token: RW_FALSE),
      (rword: 'LIKE';           token: RW_LIKE),
      (rword: 'STRING';         token: RW_STRING),
      (rword: 'FLOAT';          token: RW_FLOAT),
      (rword: 'INTEGER';        token: RW_INTEGER),
      (rword: 'BOOLEAN';        token: RW_BOOLEAN),
      (rword: 'SHL';            token: RW_SHL),
      (rword: 'SHR';            token: RW_SHR),
      (rword: 'IN';             token: RW_IN),
      (rword: 'BETWEEN';        token: RW_BETWEEN),
      (rword: 'DIV';            token: RW_DIV),
      (rword: 'CASE';           token: RW_CASE),
      (rword: 'WHEN';           token: RW_WHEN),
      (rword: 'THEN';           token: RW_THEN),
      (rword: 'ELSE';           token: RW_ELSE),
      (rword: 'IF';             token: RW_IF),
      (rword: 'CAST';           token: RW_CAST),
      (rword: 'ESCAPE';         token: RW_ESCAPE),
      (rword: 'AS';             token: RW_AS),
      (rword: 'END';            token: RW_END),

      (rword: 'WITHIN';         token: RW_WITHIN),
      (rword: 'ENTIRELY';       token: RW_ENTIRELY),
      (rword: 'CONTAINS';       token: RW_CONTAINS),
      (rword: 'ENTIRE';         token: RW_ENTIRE),
      (rword: 'INTERSECTS';     token: RW_INTERSECTS),
      (rword: 'EXTENT';         token: RW_EXTENT),
      (rword: 'OVERLAPS';       token: RW_OVERLAPS),
      (rword: 'SHARE';          token: RW_SHARE),
      (rword: 'COMMON';         token: RW_COMMON),
      (rword: 'POINT';          token: RW_POINT),
      (rword: 'LINE';           token: RW_LINE),
      (rword: 'CROSS';          token: RW_CROSS),
      (rword: 'EDGE';           token: RW_EDGE),
      (rword: 'TOUCH';          token: RW_TOUCH),
      (rword: 'CENTROID';       token: RW_CENTROID),
      (rword: 'IDENTICAL';      token: RW_IDENTICAL),
      (rword: 'VECTOR';         token: RW_VECTOR),
      (rword: 'ALL';            token: RW_ALL),
      (rword: 'RECORDS';        token: RW_RECORDS),
      (rword: 'SCOPE';          token: RW_SCOPE),
      (rword: 'ENT';            token: RW_ENT),
      (rword: 'POLYLINE';       token: RW_POLYLINE),
      (rword: 'POLYGON';        token: RW_POLYGON),
      (rword: 'BUFFER';         token: RW_BUFFER),
      (rword: 'WIDTH';          token: RW_WIDTH),

      (rword: 'ORDER';          token: RW_ORDER),
      (rword: 'BY';             token: RW_BY),
      (rword: 'DESC';           token: RW_DESC),
      (rword: 'DESCENDING';     token: RW_DESCENDING)
    );

implementation

resourcestring
  SDefaultDateFormat = 'm/d/yyyy';

function TExprLexer.IsKeyword(const id : string; var token : integer) : boolean;
(* returns corresponding token number in token *)

var
  k : integer;
begin
  Result:= false;
  for k:= Low(rwords) to High(rwords) do
     if AnsiCompareText(id, rwords[k].rword)=0 then
     begin
        Result:= True;
        token := rwords[k].token;
        Exit;
     end;
end;

procedure TExprLexer.commenteof;
begin
  writeln(yyErrorfile, 'unexpected EOF inside comment at line ' +intToStr( yylineno));
end;

%}

DIGIT     [0-9]
LOWER     [a-z]
UPPER     [A-Z]
EXTENDED  [\200-\377]
LETTER    ({UPPER}|{LOWER}|{EXTENDED})

UINT      {DIGIT}+
SINT      [+-]{DIGIT}+
HEXA      [$]({DIGIT}|[A-Fa-f])+
ENL       ([+-])?({UINT}"."{UINT})|({UINT}".")|("."{UINT})
ANL       {ENL}[Ee]{SINT}

%%

   var
      c : Char;
      token, code, value: Integer;
      SaveDate: String;

{LETTER}("_"|{LETTER}|{DIGIT})*
  if IsKeyword(yylval.yystring, token) then
    returni(token)
  else
    returni(_IDENTIFIER);
\[{LETTER}[^\[\]]*\]
  begin
    // extended identifier for using in fields with same name as reserved word
    yylval.yystring := Copy(yylval.yystring, 2, Length(yylval.yystring) - 2);
    returni( _IDENTIFIER );
  end;

({ENL})|({ANL})      returni( _NUMERIC );

{UINT}               returni( _UINTEGER );

{SINT}               returni( _SINTEGER );

{HEXA}
  begin
    Val(yylval.yystring,value,code);
    if code=0 then
    begin
      yylval.yystring:= IntToStr(value);
      returni(_NUMERIC);
    end else
      returni(_ILLEGAL);
  end;

\'[^\']*\'
  begin
    c := get_char;
    if c = #39 then
      yymore
    else
    begin
      unget_char(c);
      returni( _STRING );
    end;
  end;
\"[^\"]*\"
  begin
    c := get_char;
    if c = #34 then
      yymore
    else
    begin
      unget_char(c);
      returni( _STRING );
    end;
  end;
\#[^\#]*\#
  if yyTextLen >= 10 then
  begin
    { section to handle dates in the format m/d/yyyy }
    SaveDate := ShortDateFormat;
    ShortDateFormat := SDefaultDateFormat;
    yylval.yystring := FloatToStr(StrToDate(Copy(yylval.yystring, 2, Length(yylval.yystring) - 2)));
    ShortDateFormat := SaveDate;
    returni(_NUMERIC);
  end;
","  returni( _COMA );
"("  returni( _LPAREN );
")"  returni( _RPAREN );
"["  returni( _LSQUARE );
"]"  returni( _RSQUARE );
">"  returni( _GT );
"<"  returni( _LT );
"="  returni( _EQ );
"<>" returni( _NEQ );
">=" returni( _GE );
"<=" returni( _LE );
";"  returni( _SEMICOLON );
"."  returni( _PERIOD );
"*"  returni( _MULT );
"+"  returni( _PLUS );
"-"  returni( _SUB );
"^"  returni( _EXP );
"/"  returni( _DIV );
"/*"[^\*]*"*/" returni( _COMMENT );
[ ]  returni( _BLANK );
[\n] returni( _NEWLINE );
[\t] returni( _TAB );
.    returni( _ILLEGAL );