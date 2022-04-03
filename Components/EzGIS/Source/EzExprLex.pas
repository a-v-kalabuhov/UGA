
// lexical analyzer template for Expression Parser

// global definitions:


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





procedure TExprLexer.yyaction ( yyruleno : Integer );
  (* local definitions: *)

   var
      c : Char;
      token, code, value: Integer;
      SaveDate: String;

begin
  GetyyText( yylval.yystring );
  (* actions: *)
  case yyruleno of
  1:

  if IsKeyword(yylval.yystring, token) then
    returni(token)
  else
    returni(_IDENTIFIER);
  2:

  begin
    // extended identifier for using in fields with same name as reserved word
    yylval.yystring := Copy(yylval.yystring, 2, Length(yylval.yystring) - 2);
    returni( _IDENTIFIER );
  end;

  3:
                     returni( _NUMERIC );

  4:
                     returni( _UINTEGER );

  5:
                     returni( _SINTEGER );

  6:

  begin
    Val(yylval.yystring,value,code);
    if code=0 then
    begin
      yylval.yystring:= IntToStr(value);
      returni(_NUMERIC);
    end else
      returni(_ILLEGAL);
  end;

  7:

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
  8:

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
  9:

  if yyTextLen >= 10 then
  begin
    { section to handle dates in the format m/d/yyyy }
    SaveDate := ShortDateFormat;
    ShortDateFormat := SDefaultDateFormat;
    yylval.yystring := FloatToStr(StrToDate(Copy(yylval.yystring, 2, Length(yylval.yystring) - 2)));
    ShortDateFormat := SaveDate;
    returni(_NUMERIC);
  end;
  10:
     returni( _COMA );
  11:
     returni( _LPAREN );
  12:
     returni( _RPAREN );
  13:
     returni( _LSQUARE );
  14:
     returni( _RSQUARE );
  15:
     returni( _GT );
  16:
     returni( _LT );
  17:
     returni( _EQ );
  18:
     returni( _NEQ );
  19:
     returni( _GE );
  20:
     returni( _LE );
  21:
     returni( _SEMICOLON );
  22:
     returni( _PERIOD );
  23:
     returni( _MULT );
  24:
     returni( _PLUS );
  25:
     returni( _SUB );
  26:
     returni( _EXP );
  27:
     returni( _DIV );
  28:
               returni( _COMMENT );
  29:
     returni( _BLANK );
  30:
     returni( _NEWLINE );
  31:
     returni( _TAB );
  32:
     returni( _ILLEGAL );
  end;
end(*yyaction*);

function TExprLexer.yylex : Integer;
(* DFA table: *)

type YYTRec = record
                cc : set of Char;
                s  : SmallInt;
              end;

const

yynmarks   = 58;
yynmatches = 58;
yyntrans   = 90;
yynstates  = 49;

yyk : array [1..yynmarks] of SmallInt = (
  { 0: }
  { 1: }
  { 2: }
  1,
  32,
  { 3: }
  13,
  32,
  { 4: }
  25,
  32,
  { 5: }
  4,
  32,
  { 6: }
  22,
  32,
  { 7: }
  32,
  { 8: }
  32,
  { 9: }
  32,
  { 10: }
  32,
  { 11: }
  10,
  32,
  { 12: }
  11,
  32,
  { 13: }
  12,
  32,
  { 14: }
  14,
  32,
  { 15: }
  15,
  32,
  { 16: }
  16,
  32,
  { 17: }
  17,
  32,
  { 18: }
  21,
  32,
  { 19: }
  23,
  32,
  { 20: }
  24,
  32,
  { 21: }
  26,
  32,
  { 22: }
  27,
  32,
  { 23: }
  29,
  32,
  { 24: }
  30,
  { 25: }
  31,
  32,
  { 26: }
  32,
  { 27: }
  1,
  { 28: }
  { 29: }
  5,
  { 30: }
  4,
  { 31: }
  3,
  { 32: }
  3,
  { 33: }
  6,
  { 34: }
  { 35: }
  7,
  { 36: }
  { 37: }
  8,
  { 38: }
  { 39: }
  9,
  { 40: }
  19,
  { 41: }
  18,
  { 42: }
  20,
  { 43: }
  { 44: }
  2,
  { 45: }
  { 46: }
  { 47: }
  { 48: }
  28
);

yym : array [1..yynmatches] of SmallInt = (
{ 0: }
{ 1: }
{ 2: }
  1,
  32,
{ 3: }
  13,
  32,
{ 4: }
  25,
  32,
{ 5: }
  4,
  32,
{ 6: }
  22,
  32,
{ 7: }
  32,
{ 8: }
  32,
{ 9: }
  32,
{ 10: }
  32,
{ 11: }
  10,
  32,
{ 12: }
  11,
  32,
{ 13: }
  12,
  32,
{ 14: }
  14,
  32,
{ 15: }
  15,
  32,
{ 16: }
  16,
  32,
{ 17: }
  17,
  32,
{ 18: }
  21,
  32,
{ 19: }
  23,
  32,
{ 20: }
  24,
  32,
{ 21: }
  26,
  32,
{ 22: }
  27,
  32,
{ 23: }
  29,
  32,
{ 24: }
  30,
{ 25: }
  31,
  32,
{ 26: }
  32,
{ 27: }
  1,
{ 28: }
{ 29: }
  5,
{ 30: }
  4,
{ 31: }
  3,
{ 32: }
  3,
{ 33: }
  6,
{ 34: }
{ 35: }
  7,
{ 36: }
{ 37: }
  8,
{ 38: }
{ 39: }
  9,
{ 40: }
  19,
{ 41: }
  18,
{ 42: }
  20,
{ 43: }
{ 44: }
  2,
{ 45: }
{ 46: }
{ 47: }
{ 48: }
  28
);

yyt : array [1..yyntrans] of YYTrec = (
{ 0: }
  ( cc: [ #1..#8,#11..#31,'!','%','&',':','?','@','\',
            '_','`','{'..#127 ]; s: 26),
  ( cc: [ #9 ]; s: 25),
  ( cc: [ #10 ]; s: 24),
  ( cc: [ ' ' ]; s: 23),
  ( cc: [ '"' ]; s: 9),
  ( cc: [ '#' ]; s: 10),
  ( cc: [ '$' ]; s: 7),
  ( cc: [ '''' ]; s: 8),
  ( cc: [ '(' ]; s: 12),
  ( cc: [ ')' ]; s: 13),
  ( cc: [ '*' ]; s: 19),
  ( cc: [ '+' ]; s: 20),
  ( cc: [ ',' ]; s: 11),
  ( cc: [ '-' ]; s: 4),
  ( cc: [ '.' ]; s: 6),
  ( cc: [ '/' ]; s: 22),
  ( cc: [ '0'..'9' ]; s: 5),
  ( cc: [ ';' ]; s: 18),
  ( cc: [ '<' ]; s: 16),
  ( cc: [ '=' ]; s: 17),
  ( cc: [ '>' ]; s: 15),
  ( cc: [ 'A'..'Z','a'..'z',#128..#255 ]; s: 2),
  ( cc: [ '[' ]; s: 3),
  ( cc: [ ']' ]; s: 14),
  ( cc: [ '^' ]; s: 21),
{ 1: }
  ( cc: [ #1..#8,#11..#31,'!','%','&',':','?','@','\',
            '_','`','{'..#127 ]; s: 26),
  ( cc: [ #9 ]; s: 25),
  ( cc: [ #10 ]; s: 24),
  ( cc: [ ' ' ]; s: 23),
  ( cc: [ '"' ]; s: 9),
  ( cc: [ '#' ]; s: 10),
  ( cc: [ '$' ]; s: 7),
  ( cc: [ '''' ]; s: 8),
  ( cc: [ '(' ]; s: 12),
  ( cc: [ ')' ]; s: 13),
  ( cc: [ '*' ]; s: 19),
  ( cc: [ '+' ]; s: 20),
  ( cc: [ ',' ]; s: 11),
  ( cc: [ '-' ]; s: 4),
  ( cc: [ '.' ]; s: 6),
  ( cc: [ '/' ]; s: 22),
  ( cc: [ '0'..'9' ]; s: 5),
  ( cc: [ ';' ]; s: 18),
  ( cc: [ '<' ]; s: 16),
  ( cc: [ '=' ]; s: 17),
  ( cc: [ '>' ]; s: 15),
  ( cc: [ 'A'..'Z','a'..'z',#128..#255 ]; s: 2),
  ( cc: [ '[' ]; s: 3),
  ( cc: [ ']' ]; s: 14),
  ( cc: [ '^' ]; s: 21),
{ 2: }
  ( cc: [ '0'..'9','A'..'Z','_','a'..'z',#128..#255 ]; s: 27),
{ 3: }
  ( cc: [ 'A'..'Z','a'..'z',#128..#255 ]; s: 28),
{ 4: }
  ( cc: [ '0'..'9' ]; s: 29),
{ 5: }
  ( cc: [ '.' ]; s: 31),
  ( cc: [ '0'..'9' ]; s: 30),
{ 6: }
  ( cc: [ '0'..'9' ]; s: 32),
{ 7: }
  ( cc: [ '0'..'9','A'..'F','a'..'f' ]; s: 33),
{ 8: }
  ( cc: [ #1..'&','('..#255 ]; s: 34),
  ( cc: [ '''' ]; s: 35),
{ 9: }
  ( cc: [ #1..'!','#'..#255 ]; s: 36),
  ( cc: [ '"' ]; s: 37),
{ 10: }
  ( cc: [ #1..'"','$'..#255 ]; s: 38),
  ( cc: [ '#' ]; s: 39),
{ 11: }
{ 12: }
{ 13: }
{ 14: }
{ 15: }
  ( cc: [ '=' ]; s: 40),
{ 16: }
  ( cc: [ '=' ]; s: 42),
  ( cc: [ '>' ]; s: 41),
{ 17: }
{ 18: }
{ 19: }
{ 20: }
  ( cc: [ '0'..'9' ]; s: 29),
{ 21: }
{ 22: }
  ( cc: [ '*' ]; s: 43),
{ 23: }
{ 24: }
{ 25: }
{ 26: }
{ 27: }
  ( cc: [ '0'..'9','A'..'Z','_','a'..'z',#128..#255 ]; s: 27),
{ 28: }
  ( cc: [ #1..'Z','\','^'..#255 ]; s: 28),
  ( cc: [ ']' ]; s: 44),
{ 29: }
  ( cc: [ '.' ]; s: 45),
  ( cc: [ '0'..'9' ]; s: 29),
{ 30: }
  ( cc: [ '.' ]; s: 31),
  ( cc: [ '0'..'9' ]; s: 30),
{ 31: }
  ( cc: [ '0'..'9' ]; s: 31),
{ 32: }
  ( cc: [ '0'..'9' ]; s: 32),
  ( cc: [ 'E','e' ]; s: 46),
{ 33: }
  ( cc: [ '0'..'9','A'..'F','a'..'f' ]; s: 33),
{ 34: }
  ( cc: [ #1..'&','('..#255 ]; s: 34),
  ( cc: [ '''' ]; s: 35),
{ 35: }
{ 36: }
  ( cc: [ #1..'!','#'..#255 ]; s: 36),
  ( cc: [ '"' ]; s: 37),
{ 37: }
{ 38: }
  ( cc: [ #1..'"','$'..#255 ]; s: 38),
  ( cc: [ '#' ]; s: 39),
{ 39: }
{ 40: }
{ 41: }
{ 42: }
{ 43: }
  ( cc: [ #1..')','+'..#255 ]; s: 43),
  ( cc: [ '*' ]; s: 47),
{ 44: }
{ 45: }
  ( cc: [ '0'..'9' ]; s: 31),
{ 46: }
  ( cc: [ '+','-' ]; s: 45),
{ 47: }
  ( cc: [ '/' ]; s: 48)
{ 48: }
);

yykl : array [0..yynstates-1] of SmallInt = (
{ 0: } 1,
{ 1: } 1,
{ 2: } 1,
{ 3: } 3,
{ 4: } 5,
{ 5: } 7,
{ 6: } 9,
{ 7: } 11,
{ 8: } 12,
{ 9: } 13,
{ 10: } 14,
{ 11: } 15,
{ 12: } 17,
{ 13: } 19,
{ 14: } 21,
{ 15: } 23,
{ 16: } 25,
{ 17: } 27,
{ 18: } 29,
{ 19: } 31,
{ 20: } 33,
{ 21: } 35,
{ 22: } 37,
{ 23: } 39,
{ 24: } 41,
{ 25: } 42,
{ 26: } 44,
{ 27: } 45,
{ 28: } 46,
{ 29: } 46,
{ 30: } 47,
{ 31: } 48,
{ 32: } 49,
{ 33: } 50,
{ 34: } 51,
{ 35: } 51,
{ 36: } 52,
{ 37: } 52,
{ 38: } 53,
{ 39: } 53,
{ 40: } 54,
{ 41: } 55,
{ 42: } 56,
{ 43: } 57,
{ 44: } 57,
{ 45: } 58,
{ 46: } 58,
{ 47: } 58,
{ 48: } 58
);

yykh : array [0..yynstates-1] of SmallInt = (
{ 0: } 0,
{ 1: } 0,
{ 2: } 2,
{ 3: } 4,
{ 4: } 6,
{ 5: } 8,
{ 6: } 10,
{ 7: } 11,
{ 8: } 12,
{ 9: } 13,
{ 10: } 14,
{ 11: } 16,
{ 12: } 18,
{ 13: } 20,
{ 14: } 22,
{ 15: } 24,
{ 16: } 26,
{ 17: } 28,
{ 18: } 30,
{ 19: } 32,
{ 20: } 34,
{ 21: } 36,
{ 22: } 38,
{ 23: } 40,
{ 24: } 41,
{ 25: } 43,
{ 26: } 44,
{ 27: } 45,
{ 28: } 45,
{ 29: } 46,
{ 30: } 47,
{ 31: } 48,
{ 32: } 49,
{ 33: } 50,
{ 34: } 50,
{ 35: } 51,
{ 36: } 51,
{ 37: } 52,
{ 38: } 52,
{ 39: } 53,
{ 40: } 54,
{ 41: } 55,
{ 42: } 56,
{ 43: } 56,
{ 44: } 57,
{ 45: } 57,
{ 46: } 57,
{ 47: } 57,
{ 48: } 58
);

yyml : array [0..yynstates-1] of SmallInt = (
{ 0: } 1,
{ 1: } 1,
{ 2: } 1,
{ 3: } 3,
{ 4: } 5,
{ 5: } 7,
{ 6: } 9,
{ 7: } 11,
{ 8: } 12,
{ 9: } 13,
{ 10: } 14,
{ 11: } 15,
{ 12: } 17,
{ 13: } 19,
{ 14: } 21,
{ 15: } 23,
{ 16: } 25,
{ 17: } 27,
{ 18: } 29,
{ 19: } 31,
{ 20: } 33,
{ 21: } 35,
{ 22: } 37,
{ 23: } 39,
{ 24: } 41,
{ 25: } 42,
{ 26: } 44,
{ 27: } 45,
{ 28: } 46,
{ 29: } 46,
{ 30: } 47,
{ 31: } 48,
{ 32: } 49,
{ 33: } 50,
{ 34: } 51,
{ 35: } 51,
{ 36: } 52,
{ 37: } 52,
{ 38: } 53,
{ 39: } 53,
{ 40: } 54,
{ 41: } 55,
{ 42: } 56,
{ 43: } 57,
{ 44: } 57,
{ 45: } 58,
{ 46: } 58,
{ 47: } 58,
{ 48: } 58
);

yymh : array [0..yynstates-1] of SmallInt = (
{ 0: } 0,
{ 1: } 0,
{ 2: } 2,
{ 3: } 4,
{ 4: } 6,
{ 5: } 8,
{ 6: } 10,
{ 7: } 11,
{ 8: } 12,
{ 9: } 13,
{ 10: } 14,
{ 11: } 16,
{ 12: } 18,
{ 13: } 20,
{ 14: } 22,
{ 15: } 24,
{ 16: } 26,
{ 17: } 28,
{ 18: } 30,
{ 19: } 32,
{ 20: } 34,
{ 21: } 36,
{ 22: } 38,
{ 23: } 40,
{ 24: } 41,
{ 25: } 43,
{ 26: } 44,
{ 27: } 45,
{ 28: } 45,
{ 29: } 46,
{ 30: } 47,
{ 31: } 48,
{ 32: } 49,
{ 33: } 50,
{ 34: } 50,
{ 35: } 51,
{ 36: } 51,
{ 37: } 52,
{ 38: } 52,
{ 39: } 53,
{ 40: } 54,
{ 41: } 55,
{ 42: } 56,
{ 43: } 56,
{ 44: } 57,
{ 45: } 57,
{ 46: } 57,
{ 47: } 57,
{ 48: } 58
);

yytl : array [0..yynstates-1] of SmallInt = (
{ 0: } 1,
{ 1: } 26,
{ 2: } 51,
{ 3: } 52,
{ 4: } 53,
{ 5: } 54,
{ 6: } 56,
{ 7: } 57,
{ 8: } 58,
{ 9: } 60,
{ 10: } 62,
{ 11: } 64,
{ 12: } 64,
{ 13: } 64,
{ 14: } 64,
{ 15: } 64,
{ 16: } 65,
{ 17: } 67,
{ 18: } 67,
{ 19: } 67,
{ 20: } 67,
{ 21: } 68,
{ 22: } 68,
{ 23: } 69,
{ 24: } 69,
{ 25: } 69,
{ 26: } 69,
{ 27: } 69,
{ 28: } 70,
{ 29: } 72,
{ 30: } 74,
{ 31: } 76,
{ 32: } 77,
{ 33: } 79,
{ 34: } 80,
{ 35: } 82,
{ 36: } 82,
{ 37: } 84,
{ 38: } 84,
{ 39: } 86,
{ 40: } 86,
{ 41: } 86,
{ 42: } 86,
{ 43: } 86,
{ 44: } 88,
{ 45: } 88,
{ 46: } 89,
{ 47: } 90,
{ 48: } 91
);

yyth : array [0..yynstates-1] of SmallInt = (
{ 0: } 25,
{ 1: } 50,
{ 2: } 51,
{ 3: } 52,
{ 4: } 53,
{ 5: } 55,
{ 6: } 56,
{ 7: } 57,
{ 8: } 59,
{ 9: } 61,
{ 10: } 63,
{ 11: } 63,
{ 12: } 63,
{ 13: } 63,
{ 14: } 63,
{ 15: } 64,
{ 16: } 66,
{ 17: } 66,
{ 18: } 66,
{ 19: } 66,
{ 20: } 67,
{ 21: } 67,
{ 22: } 68,
{ 23: } 68,
{ 24: } 68,
{ 25: } 68,
{ 26: } 68,
{ 27: } 69,
{ 28: } 71,
{ 29: } 73,
{ 30: } 75,
{ 31: } 76,
{ 32: } 78,
{ 33: } 79,
{ 34: } 81,
{ 35: } 81,
{ 36: } 83,
{ 37: } 83,
{ 38: } 85,
{ 39: } 85,
{ 40: } 85,
{ 41: } 85,
{ 42: } 85,
{ 43: } 87,
{ 44: } 87,
{ 45: } 88,
{ 46: } 89,
{ 47: } 90,
{ 48: } 90
);


var yyn : Integer;

label start, scan, action;

begin

start:

  (* initialize: *)

  yynew;

scan:

  (* mark positions and matches: *)

  for yyn := yykl[yystate] to     yykh[yystate] do yymark(yyk[yyn]);
  for yyn := yymh[yystate] downto yyml[yystate] do yymatch(yym[yyn]);

  if yytl[yystate]>yyth[yystate] then goto action; (* dead state *)

  (* get next character: *)

  yyscan;

  (* determine action: *)

  yyn := yytl[yystate];
  while (yyn<=yyth[yystate]) and not (yyactchar in yyt[yyn].cc) do inc(yyn);
  if yyn>yyth[yystate] then goto action;
    (* no transition on yyactchar in this state *)

  (* switch to new state: *)

  yystate := yyt[yyn].s;

  goto scan;

action:

  (* execute action: *)

  if yyfind(yyrule) then
    begin
      yyaction(yyrule);
      if yyreject then goto action;
    end
  else if not yydefault and yywrap then
    begin
      yyclear;
      returni(0);
    end;

  if not yydone then goto start;

  yylex := yyretval;

end(*yylex*);

end.