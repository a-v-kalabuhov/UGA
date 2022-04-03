
%{
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


%}

DIGIT   [0-9]
LOWER   [a-z]
UPPER   [A-Z]
LETTER  ({UPPER}|{LOWER})

UINT    {DIGIT}+
SINT    [+-]{DIGIT}+
HEXA    [$]({DIGIT}|{LETTER})+
ENL     ([+-])?({UINT}"."{UINT})|({UINT}".")|("."{UINT})
ANL     {ENL}[Ee]{SINT}

%%

   var
      token: integer;
      c: char;

{LETTER}("_"|{LETTER}|{DIGIT})*
  if IsKeyword(yylval.yystring, token) then
    returni(token)
  else
    returni(_IDENTIFIER);

({UINT})|({SINT})|({ENL})|({ANL})
  returni(_NUMERIC);
{HEXA}
  returni(_HEXADECIMAL);
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
"="   returni( _EQ );
","   returni( _COMA );
"("   returni( _LPAREN );
")"   returni( _RPAREN );
"{"   returni( _LBRACKET );
"}"   returni( _RBRACKET );
"@"   returni( _AT );
"<"   returni( _LT );
":"   returni( _COLON );
";"   returni( _SEMICOLON );
"/*"[^\*]*"*/"
      returni( _COMMENT );
[ ]   returni( _BLANK );
[\n]  returni( _NEWLINE );
[\t]  returni( _TAB );
.     returni( _ILLEGAL );