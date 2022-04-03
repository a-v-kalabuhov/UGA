
(* lexical analyzer template (TP Lex V3.0), V1.0 3-2-91 AG *)

(* global definitions: *)

unit EzscrLex;
(* EzscrLex.L: lexical analyzer for script command line syntax *)

(* lex input file for script scanner *)

{$I EZ_FLAG.PAS}
interface

uses SysUtils, EzLexLib, EzScryacc;

type
    TEzScrLexer = Class(TCustomLexer)
    public
      // utility functions
      function IsKeyword(const id : string; var token : integer) : boolean;
      // Lexer main functions
      function yylex : Integer; override;
      procedure yyaction( yyruleno : integer);
    end;

//===============================================
// reserved words definition
//===============================================

  type
    Trword = record
       rword: string[17];
       token: smallint;
    end;
  const
    rwords : array [1..46] of Trword = (
    (rword:'TRUE';          token: RW_TRUE),
    (rword:'FALSE';         token: RW_FALSE),
    (rword:'PEN';           token: RW_PEN ),
    (rword:'BRUSH';         token: RW_BRUSH ),
    (rword:'FONT';          token: RW_FONT ),
    (rword:'VECTORFONT';    token: RW_VECTORFONT ),
    (rword:'SYMBOL';        token: RW_SYMBOL ),
    (rword:'NONE';          token: RW_NONE ),
    (rword:'POINT';         token: RW_POINT ),
    (rword:'PLACE';         token: RW_PLACE ),
    (rword:'PLINE';         token: RW_POLYLINE ),
    (rword:'POLYGON';       token: RW_POLYGON ),
    (rword:'LINE';          token: RW_LINE ),
    (rword:'RECTANGLE';     token: RW_RECTANGLE ),
    (rword:'ARC';           token: RW_ARC ),
    (rword:'ELLIPSE';       token: RW_ELLIPSE ),
    (rword:'TRUETYPETEXT';  token: RW_TRUETYPETEXT ),
    (rword:'FITTEDTEXT';    token: RW_FITTEDTEXT ),
    (rword:'JUSTIFTEXT';    token: RW_JUSTIFTEXT ),
    (rword:'PICTUREREF';    token: RW_PICTUREREF ),
    (rword:'BANDSBITMAP';   token: RW_BANDSBITMAP ),
    (rword:'PERSISTBITMAP'; token: RW_PERSISTBITMAP ),
    (rword:'CUSTPICT';      token: RW_CUSTPICT ),
    (rword:'SPLINE';        token: RW_SPLINE ),
    (rword:'SPLINETEXT';    token: RW_SPLINETEXT ),
    (rword:'TABLE';         token: RW_TABLE ),
    (rword:'PREVIEW';       token: RW_PREVIEW ),
    (rword:'GROUP';         token: RW_GROUP ),
    (rword:'DIMHORIZONTAL'; token: RW_DIMHORIZONTAL ),
    (rword:'DIMVERTICAL';   token: RW_DIMVERTICAL ),
    (rword:'DIMPARALLEL';   token: RW_DIMPARALLEL ),
    (rword:'INSERT';        token: RW_INSERT ),
    (rword:'NEWLAYER';      token: RW_NEWLAYER ),
    (rword:'ACTIVELAYER';   token: RW_ACTIVELAYER ),
    (rword:'DATA';          token: RW_DATA ),
    (rword:'INFO';          token: RW_INFO ),
    (rword:'CHAR';          token: RW_CHAR ),
    (rword:'FLOAT';         token: RW_FLOAT ),
    (rword:'DATETIME';      token: RW_DATETIME ),
    (rword:'INTEGER';       token: RW_INTEGER ),
    (rword:'LOGIC';         token: RW_LOGIC ),
    (rword:'MEMO';          token: RW_MEMO ),
    (rword:'BINARY';        token: RW_BINARY ),
    (rword:'COORDSYS';      token: RW_COORDSYS ),
    (rword:'TITLE';         token: RW_TITLE ),
    (rword:'COLUMN';        token: RW_COLUMN )
    );

implementation

function TEzScrLexer.IsKeyword(const id : string; var token : integer) : boolean;
(* returns corresponding token number in token *)


var
  k : integer;
begin
  Result:= false;
  for k:= Low(rwords) to High(rwords) do
     if AnsiCompareText(id, rwords[k].rword)=0 then begin
        Result:= True;
        token := rwords[k].token;
        exit;
     end;
end;






procedure TEzScrLexer.yyaction ( yyruleno : Integer );
  (* local definitions: *)

   var
      token: integer;
      c: char;

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

  returni(_NUMERIC);
  3:

  returni(_HEXADECIMAL);
  4:

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
  5:

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
  6:
      returni( _EQ );
  7:
      returni( _COMA );
  8:
      returni( _LPAREN );
  9:
      returni( _RPAREN );
  10:
      returni( _LBRACKET );
  11:
      returni( _RBRACKET );
  12:
      returni( _AT );
  13:
      returni( _LT );
  14:
      returni( _COLON );
  15:
      returni( _SEMICOLON );
  16:

      returni( _COMMENT );
  17:
      returni( _BLANK );
  18:
      returni( _NEWLINE );
  19:
      returni( _TAB );
  20:
      returni( _ILLEGAL );
  end;
end(*yyaction*);

function TEzScrLexer.yylex : Integer;
(* DFA table: *)

type YYTRec = record
                cc : set of Char;
                s  : SmallInt;
              end;

const

yynmarks   = 45;
yynmatches = 45;
yyntrans   = 73;
yynstates  = 39;

yyk : array [1..yynmarks] of SmallInt = (
  { 0: }
  { 1: }
  { 2: }
  1,
  20,
  { 3: }
  2,
  20,
  { 4: }
  20,
  { 5: }
  20,
  { 6: }
  20,
  { 7: }
  20,
  { 8: }
  6,
  20,
  { 9: }
  7,
  20,
  { 10: }
  8,
  20,
  { 11: }
  9,
  20,
  { 12: }
  10,
  20,
  { 13: }
  11,
  20,
  { 14: }
  12,
  20,
  { 15: }
  13,
  20,
  { 16: }
  14,
  20,
  { 17: }
  15,
  20,
  { 18: }
  20,
  { 19: }
  17,
  20,
  { 20: }
  18,
  { 21: }
  19,
  20,
  { 22: }
  20,
  { 23: }
  1,
  { 24: }
  2,
  { 25: }
  2,
  { 26: }
  2,
  { 27: }
  3,
  { 28: }
  { 29: }
  4,
  { 30: }
  { 31: }
  5,
  { 32: }
  { 33: }
  { 34: }
  { 35: }
  { 36: }
  16,
  { 37: }
  20,
  { 38: }
  2
);

yym : array [1..yynmatches] of SmallInt = (
{ 0: }
{ 1: }
{ 2: }
  1,
  20,
{ 3: }
  2,
  20,
{ 4: }
  20,
{ 5: }
  20,
{ 6: }
  20,
{ 7: }
  20,
{ 8: }
  6,
  20,
{ 9: }
  7,
  20,
{ 10: }
  8,
  20,
{ 11: }
  9,
  20,
{ 12: }
  10,
  20,
{ 13: }
  11,
  20,
{ 14: }
  12,
  20,
{ 15: }
  13,
  20,
{ 16: }
  14,
  20,
{ 17: }
  15,
  20,
{ 18: }
  20,
{ 19: }
  17,
  20,
{ 20: }
  18,
{ 21: }
  19,
  20,
{ 22: }
  20,
{ 23: }
  1,
{ 24: }
  2,
{ 25: }
  2,
{ 26: }
  2,
{ 27: }
  3,
{ 28: }
{ 29: }
  4,
{ 30: }
{ 31: }
  5,
{ 32: }
{ 33: }
{ 34: }
{ 35: }
{ 36: }
  16,
{ 37: }
  20,
{ 38: }
  2
);

yyt : array [1..yyntrans] of YYTrec = (
{ 0: }
  ( cc: [ #1..#8,#11..#31,'!','#','%','&','*','>','?',
            '['..'`','|','~'..#255 ]; s: 22),
  ( cc: [ #9 ]; s: 21),
  ( cc: [ #10 ]; s: 20),
  ( cc: [ ' ' ]; s: 19),
  ( cc: [ '"' ]; s: 7),
  ( cc: [ '$' ]; s: 5),
  ( cc: [ '''' ]; s: 6),
  ( cc: [ '(' ]; s: 10),
  ( cc: [ ')' ]; s: 11),
  ( cc: [ '+','-' ]; s: 4),
  ( cc: [ ',' ]; s: 9),
  ( cc: [ '.' ]; s: 37),
  ( cc: [ '/' ]; s: 18),
  ( cc: [ '0'..'9' ]; s: 3),
  ( cc: [ ':' ]; s: 16),
  ( cc: [ ';' ]; s: 17),
  ( cc: [ '<' ]; s: 15),
  ( cc: [ '=' ]; s: 8),
  ( cc: [ '@' ]; s: 14),
  ( cc: [ 'A'..'Z','a'..'z' ]; s: 2),
  ( cc: [ '{' ]; s: 12),
  ( cc: [ '}' ]; s: 13),
{ 1: }
  ( cc: [ #1..#8,#11..#31,'!','#','%','&','*','>','?',
            '['..'`','|','~'..#255 ]; s: 22),
  ( cc: [ #9 ]; s: 21),
  ( cc: [ #10 ]; s: 20),
  ( cc: [ ' ' ]; s: 19),
  ( cc: [ '"' ]; s: 7),
  ( cc: [ '$' ]; s: 5),
  ( cc: [ '''' ]; s: 6),
  ( cc: [ '(' ]; s: 10),
  ( cc: [ ')' ]; s: 11),
  ( cc: [ '+','-' ]; s: 4),
  ( cc: [ ',' ]; s: 9),
  ( cc: [ '.' ]; s: 37),
  ( cc: [ '/' ]; s: 18),
  ( cc: [ '0'..'9' ]; s: 3),
  ( cc: [ ':' ]; s: 16),
  ( cc: [ ';' ]; s: 17),
  ( cc: [ '<' ]; s: 15),
  ( cc: [ '=' ]; s: 8),
  ( cc: [ '@' ]; s: 14),
  ( cc: [ 'A'..'Z','a'..'z' ]; s: 2),
  ( cc: [ '{' ]; s: 12),
  ( cc: [ '}' ]; s: 13),
{ 2: }
  ( cc: [ '0'..'9','A'..'Z','_','a'..'z' ]; s: 23),
{ 3: }
  ( cc: [ '.' ]; s: 25),
  ( cc: [ '0'..'9' ]; s: 24),
{ 4: }
  ( cc: [ '0'..'9' ]; s: 38),
{ 5: }
  ( cc: [ '0'..'9','A'..'Z','a'..'z' ]; s: 27),
{ 6: }
  ( cc: [ #1..'&','('..#255 ]; s: 28),
  ( cc: [ '''' ]; s: 29),
{ 7: }
  ( cc: [ #1..'!','#'..#255 ]; s: 30),
  ( cc: [ '"' ]; s: 31),
{ 8: }
{ 9: }
{ 10: }
{ 11: }
{ 12: }
{ 13: }
{ 14: }
{ 15: }
{ 16: }
{ 17: }
{ 18: }
  ( cc: [ '*' ]; s: 32),
{ 19: }
{ 20: }
{ 21: }
{ 22: }
{ 23: }
  ( cc: [ '0'..'9','A'..'Z','_','a'..'z' ]; s: 23),
{ 24: }
  ( cc: [ '.' ]; s: 25),
  ( cc: [ '0'..'9' ]; s: 24),
{ 25: }
  ( cc: [ '0'..'9' ]; s: 25),
{ 26: }
  ( cc: [ '0'..'9' ]; s: 26),
  ( cc: [ 'E','e' ]; s: 34),
{ 27: }
  ( cc: [ '0'..'9','A'..'Z','a'..'z' ]; s: 27),
{ 28: }
  ( cc: [ #1..'&','('..#255 ]; s: 28),
  ( cc: [ '''' ]; s: 29),
{ 29: }
{ 30: }
  ( cc: [ #1..'!','#'..#255 ]; s: 30),
  ( cc: [ '"' ]; s: 31),
{ 31: }
{ 32: }
  ( cc: [ #1..')','+'..#255 ]; s: 32),
  ( cc: [ '*' ]; s: 35),
{ 33: }
  ( cc: [ '0'..'9' ]; s: 25),
{ 34: }
  ( cc: [ '+','-' ]; s: 33),
{ 35: }
  ( cc: [ '/' ]; s: 36),
{ 36: }
{ 37: }
  ( cc: [ '0'..'9' ]; s: 26),
{ 38: }
  ( cc: [ '.' ]; s: 33),
  ( cc: [ '0'..'9' ]; s: 38)
);

yykl : array [0..yynstates-1] of SmallInt = (
{ 0: } 1,
{ 1: } 1,
{ 2: } 1,
{ 3: } 3,
{ 4: } 5,
{ 5: } 6,
{ 6: } 7,
{ 7: } 8,
{ 8: } 9,
{ 9: } 11,
{ 10: } 13,
{ 11: } 15,
{ 12: } 17,
{ 13: } 19,
{ 14: } 21,
{ 15: } 23,
{ 16: } 25,
{ 17: } 27,
{ 18: } 29,
{ 19: } 30,
{ 20: } 32,
{ 21: } 33,
{ 22: } 35,
{ 23: } 36,
{ 24: } 37,
{ 25: } 38,
{ 26: } 39,
{ 27: } 40,
{ 28: } 41,
{ 29: } 41,
{ 30: } 42,
{ 31: } 42,
{ 32: } 43,
{ 33: } 43,
{ 34: } 43,
{ 35: } 43,
{ 36: } 43,
{ 37: } 44,
{ 38: } 45
);

yykh : array [0..yynstates-1] of SmallInt = (
{ 0: } 0,
{ 1: } 0,
{ 2: } 2,
{ 3: } 4,
{ 4: } 5,
{ 5: } 6,
{ 6: } 7,
{ 7: } 8,
{ 8: } 10,
{ 9: } 12,
{ 10: } 14,
{ 11: } 16,
{ 12: } 18,
{ 13: } 20,
{ 14: } 22,
{ 15: } 24,
{ 16: } 26,
{ 17: } 28,
{ 18: } 29,
{ 19: } 31,
{ 20: } 32,
{ 21: } 34,
{ 22: } 35,
{ 23: } 36,
{ 24: } 37,
{ 25: } 38,
{ 26: } 39,
{ 27: } 40,
{ 28: } 40,
{ 29: } 41,
{ 30: } 41,
{ 31: } 42,
{ 32: } 42,
{ 33: } 42,
{ 34: } 42,
{ 35: } 42,
{ 36: } 43,
{ 37: } 44,
{ 38: } 45
);

yyml : array [0..yynstates-1] of SmallInt = (
{ 0: } 1,
{ 1: } 1,
{ 2: } 1,
{ 3: } 3,
{ 4: } 5,
{ 5: } 6,
{ 6: } 7,
{ 7: } 8,
{ 8: } 9,
{ 9: } 11,
{ 10: } 13,
{ 11: } 15,
{ 12: } 17,
{ 13: } 19,
{ 14: } 21,
{ 15: } 23,
{ 16: } 25,
{ 17: } 27,
{ 18: } 29,
{ 19: } 30,
{ 20: } 32,
{ 21: } 33,
{ 22: } 35,
{ 23: } 36,
{ 24: } 37,
{ 25: } 38,
{ 26: } 39,
{ 27: } 40,
{ 28: } 41,
{ 29: } 41,
{ 30: } 42,
{ 31: } 42,
{ 32: } 43,
{ 33: } 43,
{ 34: } 43,
{ 35: } 43,
{ 36: } 43,
{ 37: } 44,
{ 38: } 45
);

yymh : array [0..yynstates-1] of SmallInt = (
{ 0: } 0,
{ 1: } 0,
{ 2: } 2,
{ 3: } 4,
{ 4: } 5,
{ 5: } 6,
{ 6: } 7,
{ 7: } 8,
{ 8: } 10,
{ 9: } 12,
{ 10: } 14,
{ 11: } 16,
{ 12: } 18,
{ 13: } 20,
{ 14: } 22,
{ 15: } 24,
{ 16: } 26,
{ 17: } 28,
{ 18: } 29,
{ 19: } 31,
{ 20: } 32,
{ 21: } 34,
{ 22: } 35,
{ 23: } 36,
{ 24: } 37,
{ 25: } 38,
{ 26: } 39,
{ 27: } 40,
{ 28: } 40,
{ 29: } 41,
{ 30: } 41,
{ 31: } 42,
{ 32: } 42,
{ 33: } 42,
{ 34: } 42,
{ 35: } 42,
{ 36: } 43,
{ 37: } 44,
{ 38: } 45
);

yytl : array [0..yynstates-1] of SmallInt = (
{ 0: } 1,
{ 1: } 23,
{ 2: } 45,
{ 3: } 46,
{ 4: } 48,
{ 5: } 49,
{ 6: } 50,
{ 7: } 52,
{ 8: } 54,
{ 9: } 54,
{ 10: } 54,
{ 11: } 54,
{ 12: } 54,
{ 13: } 54,
{ 14: } 54,
{ 15: } 54,
{ 16: } 54,
{ 17: } 54,
{ 18: } 54,
{ 19: } 55,
{ 20: } 55,
{ 21: } 55,
{ 22: } 55,
{ 23: } 55,
{ 24: } 56,
{ 25: } 58,
{ 26: } 59,
{ 27: } 61,
{ 28: } 62,
{ 29: } 64,
{ 30: } 64,
{ 31: } 66,
{ 32: } 66,
{ 33: } 68,
{ 34: } 69,
{ 35: } 70,
{ 36: } 71,
{ 37: } 71,
{ 38: } 72
);

yyth : array [0..yynstates-1] of SmallInt = (
{ 0: } 22,
{ 1: } 44,
{ 2: } 45,
{ 3: } 47,
{ 4: } 48,
{ 5: } 49,
{ 6: } 51,
{ 7: } 53,
{ 8: } 53,
{ 9: } 53,
{ 10: } 53,
{ 11: } 53,
{ 12: } 53,
{ 13: } 53,
{ 14: } 53,
{ 15: } 53,
{ 16: } 53,
{ 17: } 53,
{ 18: } 54,
{ 19: } 54,
{ 20: } 54,
{ 21: } 54,
{ 22: } 54,
{ 23: } 55,
{ 24: } 57,
{ 25: } 58,
{ 26: } 60,
{ 27: } 61,
{ 28: } 63,
{ 29: } 63,
{ 30: } 65,
{ 31: } 65,
{ 32: } 67,
{ 33: } 68,
{ 34: } 69,
{ 35: } 70,
{ 36: } 70,
{ 37: } 71,
{ 38: } 73
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