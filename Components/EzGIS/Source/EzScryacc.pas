
(* Yacc parser template (TP Yacc V3.0), V1.2 6-17-91 AG *)

(* global definitions: *)

unit EzScrYacc;

{$I EZ_FLAG.PAS}
{$R Ezscryacc.res}
interface

uses
   SysUtils, Classes, Dialogs, Graphics, Windows, Messages,
   EzYaccLib, EzLib, EzSystem, EzCmdLine, ezbase, EzBaseGIS, EzEntities,
   EzMiscelEntities;

type

  TNewLayerField = class
  private
    FFieldName: String;
    FFieldType: Integer;
    FFieldSize: Integer;
    FFieldDec: Integer;
  public
    property FieldName: String read FFieldName write FFieldName;
    property FieldType: Integer read FFieldType write FFieldType;
    property FieldSize: Integer read FFieldSize write FFieldSize;
    property FieldDec: Integer read FFieldDec write FFieldDec;
  end;

  TNewLayerFields = class
     FItems: TList;
     function GetCount: Integer;
     function GetItem(Index: Integer): TNewLayerField;
  public
     constructor Create;
     destructor Destroy; override;
     function Add: TNewLayerField;
     procedure Clear;
     procedure Delete(Index: Integer);

     property Count: Integer read GetCount;
     property Items[Index: Integer]: TNewLayerField read GetItem; default;
  end;

  TEzScrParser = Class(TCustomParser)
  private
     FDrawBox : TEzBaseDrawBox;
     { This is used for parsing user typed command on command line TEzCmdLine }
     FCmdLine : TEzCmdLine;
     FMustRepaint: Boolean;
     FVector: TEzVector;
     FNewLayerFields: TNewLayerFields;
     FTmpFieldType: Integer;
     FTmpFieldSize: Integer;
     FTmpFieldDec: Integer;
     FSavePenStyle: TEzPenStyle;
     FSaveBrushStyle: TEzBrushStyle;
     FSaveSymbolStyle: TEzSymbolStyle;
     FSaveFontStyle: TEzFontStyle;
     FSaveTTFontStyle: TEzFontStyle;
     FCheckSyntax: Boolean;
     FGroupInProgress: Boolean;
     FGroup: TEzGroupEntity;
     FProjParams: TStringList;
     FJustCreateEntity: Boolean;
     FEntityCreated: TEzEntity;
     { for saving configuration}
     FSavedNegCurrFormat: Byte;
     FSavedThousandSeparator: Char;
     FSavedDecimalSeparator: Char;
     FVectorFontName: string;
     FCode, FIntValue: Integer;
     FTableEntity: TEzTableEntity;
     FNumRows, FNumCols, FColIndex, FDataIndex: Integer;
     Function GetBoolean(const Value: string): Boolean;
     procedure updatefield(const fieldname, fieldvalue:String);
     { the commands executors }
     procedure do_addentity(Ent: TEzEntity;freeit:boolean);
     procedure do_penstyle(St:Integer;Cl:TColor;W,S:Double);
     procedure do_fillstyle(St:Integer;foreClr,backClr:TColor) ;
     procedure do_ttfontstyle(const Fontn:String; bold,ital,under,strike: boolean;
       Cl:TColor; Charset: Integer);
     procedure do_symbolstyle(St:Integer;const RotAng,aSize:Double);
     procedure do_none;
     procedure do_preview(const p1,p2: TEzPoint; FileNo:Integer;
       APlottedUnits, ADrawingUnits: Double; APrintFrame: Boolean;
       AProposedPrintArea: TEzRect );
     procedure do_point(const p:TEzPoint);
     procedure do_place(const p:TEzPoint;const Text:String);
     procedure do_polyline(V:TEzVector);
     procedure do_polygon(V:TEzVector);
     procedure do_line(const p1, p2: TEzPoint );
     procedure do_rectangle(const p1,p2:TEzPoint;const Rotangle:Double);
     procedure do_arc(const p:TEzPoint;
      const radius,start_angle,NumDegrees:Double;IsCounterClockWise:Boolean);
     procedure do_arc2(const p1,p2,p3:TEzPoint);
     procedure do_ellipse(const p1,p2:TEzPoint;const Rotangle:Double);
     procedure do_truetypetext(const BasePt: TEzPoint;
       const Text: string; Align: Integer; Const Height, Angle: Double );
     procedure do_fittedtext(const BasePt: TEzPoint;
       const Text: string; const H,W,Angle: Double; Colr: TColor);
     procedure do_justiftext(const p1,p2:TEzPoint; const Text:String;
       const Height, Angle: Double; Color: TColor; HorzAlign, VertAlign: Byte );
     procedure do_pictureref(const p1,p2:TEzPoint; const filename:String; AlphaChannel: Byte;const Rotangle:Double);
     procedure do_bandsbitmap(const p1,p2:TEzPoint; const filename:String; AlphaChannel: Byte);
     procedure do_custpict(const p1,p2:TEzPoint);
     procedure do_persistbitmap(const p1,p2:TEzPoint; const filename:String);
     procedure do_insert(const p:TEzPoint; const blockname:String;
       const rotangle,scalex,scaley:Double;const replacer:string);
     procedure do_spline(V:TEzVector);
     procedure do_splinetext(IsTrueType: Boolean; const AText: string; V:TEzVector);
     procedure do_dimhorizontal(const p1,p2: TEzPoint; const TextLineY: Double);
     procedure do_dimvertical(const p1,p2: TEzPoint; const TextLineX: Double);
     procedure do_dimparallel(const p1,p2: TEzPoint; const TextLineDistanceApart: Double);
     procedure do_group;
     procedure do_table;
     procedure do_newlayer( const lay:String );
     procedure do_activelayer(const lay:String);

     function GetString( const s: string ): string;
  public
     constructor create;
     destructor Destroy; override;

     function yyparse : integer; override;
     procedure yyerror(const msg : string);

     property DrawBox: TEzBaseDrawBox read FDrawBox write FDrawBox;
     property CheckSyntax: Boolean read FCheckSyntax write FCheckSyntax;
     property Vector: TEzVector read FVector;
     property ProjParams: TStringList read FProjParams;
     property CmdLine: TEzCmdLine read FCmdLine write FCmdLine;
     property MustRepaint: Boolean read FMustRepaint write FMustRepaint;
     property JustCreateEntity: Boolean read FJustCreateEntity write FJustCreateEntity;
     property EntityCreated: TEzEntity read FEntityCreated write FEntityCreated;
  end;

const _IDENTIFIER = 257;
const _NUMERIC = 258;
const _STRING = 259;
const _HEXADECIMAL = 260;
const _EQ = 261;
const _AT = 262;
const _LT = 263;
const _COMA = 264;
const _LPAREN = 265;
const _RPAREN = 266;
const _SEMICOLON = 267;
const _COMMENT = 268;
const _BLANK = 269;
const _TAB = 270;
const _NEWLINE = 271;
const _LBRACKET = 272;
const _RBRACKET = 273;
const _COLON = 274;
const _ILLEGAL = 275;
const RW_TRUE = 276;
const RW_FALSE = 277;
const RW_PEN = 278;
const RW_BRUSH = 279;
const RW_FONT = 280;
const RW_VECTORFONT = 281;
const RW_SYMBOL = 282;
const RW_NONE = 283;
const RW_POINT = 284;
const RW_PLACE = 285;
const RW_POLYLINE = 286;
const RW_POLYGON = 287;
const RW_LINE = 288;
const RW_RECTANGLE = 289;
const RW_ARC = 290;
const RW_ELLIPSE = 291;
const RW_TRUETYPETEXT = 292;
const RW_FITTEDTEXT = 293;
const RW_JUSTIFTEXT = 294;
const RW_PICTUREREF = 295;
const RW_BANDSBITMAP = 296;
const RW_PERSISTBITMAP = 297;
const RW_CUSTPICT = 298;
const RW_TABLE = 299;
const RW_PREVIEW = 300;
const RW_SPLINE = 301;
const RW_SPLINETEXT = 302;
const RW_GROUP = 303;
const RW_DIMHORIZONTAL = 304;
const RW_DIMVERTICAL = 305;
const RW_DIMPARALLEL = 306;
const RW_INSERT = 307;
const RW_NEWLAYER = 308;
const RW_ACTIVELAYER = 309;
const RW_DATA = 310;
const RW_INFO = 311;
const RW_CHAR = 312;
const RW_FLOAT = 313;
const RW_INTEGER = 314;
const RW_DATETIME = 315;
const RW_LOGIC = 316;
const RW_MEMO = 317;
const RW_BINARY = 318;
const RW_COORDSYS = 319;
const RW_COLUMN = 320;
const RW_TITLE = 321;

type YYSType = record
               yystring : string
               end(*YYSType*);

var yylval : YYSType;

implementation

uses
   Math, EzPreview, ezConsts, ezDims, EzScrLex;

(*----------------------------------------------------------------------------*)
constructor TEzScrParser.create;
begin
   inherited Create;
   FVector := TEzVector.Create(4);
   FVector.CanGrow:= True;
   FNewLayerFields:= TNewLayerFields.Create;
   FProjParams:= TStringList.Create;

   With Ez_Preferences Do
   Begin
     FSavePenStyle:= DefPenStyle.FPenStyle;
     FSaveBrushStyle:= DefBrushStyle.FBrushStyle;
     FSaveSymbolStyle:= DefSymbolStyle.FSymbolStyle;
     FSaveFontStyle:= DefFontStyle.FFontStyle;
     FSaveTTFontStyle:= DefTTFontStyle.FFontStyle;
   end;

   { save configuration }
   FSavedNegCurrFormat:= NegCurrFormat;
   FSavedThousandSeparator:= ThousandSeparator;
   FSavedDecimalSeparator:= DecimalSeparator;
   NegCurrFormat:= 1;
   ThousandSeparator:= ',';
   DecimalSeparator:= '.';
   FVectorFontName:= Ez_Preferences.DefFontStyle.Name;

   FGroup:= TEzGroupEntity.CreateEntity;
   FTableEntity:= TEzTableEntity.CreateEntity(Point2d(0,0),Point2d(0,0));
end;

destructor TEzScrParser.Destroy;
begin
   With Ez_Preferences Do
   Begin
     DefPenStyle.FPenStyle:= FSavePenStyle;
     DefBrushStyle.FBrushStyle:= FSaveBrushStyle;
     DefSymbolStyle.FSymbolStyle:= FSaveSymbolStyle;
     DefFontStyle.FFontStyle:= FSaveFontStyle;
     DefTTFontStyle.FFontStyle:= FSaveTTFontStyle;
   End;
   FVector.Free;
   FNewLayerFields.Free;
   FGroup.Free;
   FTableEntity.Free;
   FProjParams.Free;
   if FEntityCreated <> nil then
     FEntityCreated.Free;
   { restore configuration }
   NegCurrFormat:=  FSavedNegCurrFormat;
   ThousandSeparator:= FSavedThousandSeparator;
   DecimalSeparator:= FSavedDecimalSeparator;
   inherited Destroy;
end;

Function TEzScrParser.GetBoolean(const Value: string): Boolean;
Begin
  Result:= AnsiCompareText(Value,'True')=0;
End;

function TEzScrParser.GetString( const s: string ): string;
begin
  Result:= Copy( s, 2, Length(s) - 2 );
end;

procedure TEzScrParser.yyerror(const msg : string);
begin
   yyerrormsg := msg;
   (* MessageToUser(IntToStr(yyLexer.yylineno)+
      ': ' + msg + ' at or before '+ yyLexer.yytext,mtError); *)
end;

// execute the commands - section
procedure TEzScrParser.do_penstyle(St:Integer;Cl:TColor;W,S:Double);
begin
   if FCheckSyntax then exit;
   with Ez_Preferences.DefPenStyle.FPenStyle do
   begin
      style:=St;
      color:=Cl;
      Width:=W;
   end;
end;

procedure TEzScrParser.do_fillstyle(St:Integer;foreClr,backClr:TColor) ;
begin
   if FCheckSyntax then exit;
   with Ez_Preferences.DefBrushstyle.FBrushStyle do
   begin
      pattern:=St;
      forecolor:=foreClr;
      backcolor:=backClr;
      //Scale:=Scl;
      //Angle:=Ang;
   end;
end;

procedure TEzScrParser.do_ttfontstyle(const Fontn:String; bold,ital,under,strike: boolean;
  Cl:TColor; Charset: Integer);
begin
  if FCheckSyntax then exit;
  with Ez_Preferences.DefTTFontStyle.FFontStyle do
  begin
    name:=fontn;
    style:=[];
    if bold then Include(style,fsbold);
    if ital then Include(style,fsitalic);
    if under then Include(style,fsunderline);
    if strike then Include(style,fsstrikeout);
    color:=Cl;
    //CharSet:= aCharset;
  end;
end;

procedure TEzScrParser.do_symbolstyle(St:Integer;const RotAng,aSize:Double);
begin
   if FCheckSyntax then exit;
   with Ez_Preferences.DefSymbolStyle.FSymbolStyle do
   begin
     Index:=St;
     Rotangle:=DegToRad(RotAng);
     Height:=aSize;
   end;
end;

procedure TEzScrParser.do_addentity(Ent: TEzEntity;freeit:boolean);
var
  Layer: TEzBaseLayer;
begin
  if FJustCreateEntity then
  begin
    FEntityCreated:= Ent;
    Exit;
  end;
  Layer:= FDrawBox.GIS.CurrentLayer;
  if Layer = nil then
  begin
     If freeit then Ent.Free;
     Exit;
  end;
  Layer.AddEntity( Ent );
  // this option is only used when parsing a command from the command line
  If FMustRepaint then
    FDrawBox.RepaintRect(Ent.FBox);
  If freeit then Ent.free;
end;

procedure TEzScrParser.do_none;
var
   Ent:TEzEntity;
begin
   if FCheckSyntax then exit;
   Ent:=TEzNone.CreateEntity;
   if FGroupInProgress then
      FGroup.Add(Ent)
   else
     do_addentity(Ent,true);
end;

procedure TEzScrParser.do_point(const p:TEzPoint);
var
   Ent:TEzEntity;
begin
   if FCheckSyntax then exit;
   Ent:=TEzPointEntity.CreateEntity(p,Ez_Preferences.DefPenstyle.Color);
   if FGroupInProgress then
      FGroup.Add(Ent)
   else
     do_addentity(Ent,true);
end;

procedure TEzScrParser.do_place(const p:TEzPoint; const Text: String);
var
   Ent:TEzEntity;
begin
   if FCheckSyntax then exit;
   Ent:=TEzPlace.CreateEntity(p);
   TEzPlace(Ent).Text:=Text;
   with TEzPlace(ent).SymbolTool do
   begin
     Height:= FDrawBox.Grapher.GetRealSize( Height );
   End;
   if FGroupInProgress then
      FGroup.Add(Ent)
   else
     do_addentity(Ent,true);
end;

procedure TEzScrParser.do_polyline(V: TEzVector);
var
   ent:TEzEntity;
begin
   if FCheckSyntax then exit;
   ent:=TEzPolyline.CreateEntity([Point2D(0,0)]);
   ent.Points.assign(V);
   if FGroupInProgress then
      FGroup.Add(ent)
   else
      do_AddEntity(Ent,true);
end;

procedure TEzScrParser.do_polygon(V: TEzVector);
var
   ent:TEzEntity;
begin
   if FCheckSyntax then exit;
   ent:=TEzPolygon.CreateEntity([Point2D(0,0)]);
   ent.Points.assign(V);
   if FGroupInProgress then
      FGroup.Add(ent)
   else
      do_AddEntity(Ent,true);
end;

procedure TEzScrParser.do_line(const p1, p2: TEzPoint );
var
   ent:TEzEntity;
begin
   if FCheckSyntax then exit;
   ent:=TEzPolyLine.CreateEntity([p1,p2]);
   if FGroupInProgress then
      FGroup.Add(ent)
   else
      do_AddEntity(Ent,true);
end;

procedure TEzScrParser.do_rectangle(const p1,p2:TEzPoint;const Rotangle:Double);
var
   ent:TEzEntity;
begin
   if FCheckSyntax then exit;
   ent:=TEzRectangle.CreateEntity(p1,p2);
   TEzRectangle(ent).Rotangle:= DegToRad(Rotangle);
   if FGroupInProgress then
      FGroup.Add(ent)
   else
      do_AddEntity(Ent,true);
end;

procedure TEzScrParser.do_arc(const p:TEzPoint;
  const radius,start_angle,NumDegrees:Double;IsCounterClockWise:Boolean);
var
   Ent: TEzEntity;
begin
   if FCheckSyntax then exit;
   Ent:= TEzArc.CreateEntity(Point2D(0, 0),Point2D(0, 0),Point2D(0, 0));
   TEzArc(Ent).SetArc(p.x,p.y,Radius,DegToRad(Start_Angle),DegToRad(NumDegrees),IsCounterClockWise);
   if FGroupInProgress then
      FGroup.Add(Ent)
   else
      do_AddEntity(Ent,true);
end;

procedure TEzScrParser.do_arc2(const p1,p2,p3:TEzPoint);
var
   Ent: TEzEntity;
begin
   if FCheckSyntax then exit;
   Ent:= TEzArc.CreateEntity(p1,p2,p3);
   if FGroupInProgress then
      FGroup.Add(Ent)
   else
      do_AddEntity(Ent,true);
end;

procedure TEzScrParser.do_ellipse(const p1,p2:TEzPoint;const Rotangle:Double);
var
   ent:TEzEntity;
begin
   if FCheckSyntax then exit;
   ent:=TEzEllipse.CreateEntity(p1,p2);
   TEzEllipse(Ent).Rotangle:=DegToRad(Rotangle);
   if FGroupInProgress then
      FGroup.Add(ent)
   else
      do_AddEntity(Ent,true);
end;

procedure TEzScrParser.do_truetypetext(const BasePt: TEzPoint;
  const Text: string; Align: Integer; Const Height, Angle: Double );
var
  Ent: TEzEntity;
begin
  if FCheckSyntax then exit;
  Ent:= TEzAlignedTTText.CreateEntity(BasePt, Text, Height, DegToRad(Angle));
  TEzAlignedTTText(ent).Alignment:= TAlignment(Align);
  if FGroupInProgress then
     FGroup.Add(Ent)
  else
     do_AddEntity(Ent, true);
end;

procedure TEzScrParser.do_fittedtext(const BasePt: TEzPoint;
  const Text: string; const H,W,Angle: Double; Colr: TColor);
var
   Ent: TEzEntity;
begin
   if FCheckSyntax then exit;
   Ent:= TEzFittedVectorText.CreateEntity(BasePt, Text, H, W, DegToRad(Angle));
   with TEzFittedVectorText(Ent) do
   begin
     FontColor:= Colr;
     FontName:= FVectorFontName;
   end;
   if FGroupInProgress then
      FGroup.Add(Ent)
   else
      do_AddEntity(Ent,true);
end;

procedure TEzScrParser.do_justiftext(const p1,p2:TEzPoint; const Text:String;
  const Height, Angle: Double; Color: TColor; HorzAlign, VertAlign: Byte );
var
   Ent: TEzEntity;
   box: TEzRect;
begin
   if FCheckSyntax then exit;
   box.Emin:=p1;
   box.Emax:=p2;
   box:=ReorderRect2d(box);
   Ent:= TEzJustifVectorText.CreateEntity(box, Height, Text);
   with TEzJustifVectorText(ent) do
   begin
     FontName:= FVectorFontName;
     FontColor:= Color;
     Angle:= DegToRad(Angle);
     HorzAlignment:= TEzHorzAlignment(HorzAlign);
     VertAlignment:= TEzVertAlignment(VertAlign);
   end;
   if FGroupInProgress then
      FGroup.Add(Ent)
   else
      do_AddEntity(Ent,true);
end;

procedure TEzScrParser.do_pictureref(const p1,p2:TEzPoint;
  const filename:String; AlphaChannel: Byte; const Rotangle: Double);
var
   ent:TEzEntity;
begin
   if FCheckSyntax then exit;
   ent:=TEzPictureRef.CreateEntity(p1,p2,FileName);
   TEzPictureRef(ent).Alphachannel:= AlphaChannel;
   TEzPictureRef(ent).Rotangle:= Rotangle;
   if FGroupInProgress then
      FGroup.Add(ent)
   else
      do_AddEntity(Ent,true);
end;

procedure TEzScrParser.do_custpict(const p1,p2:TEzPoint);
var
   ent:TEzEntity;
begin
   if FCheckSyntax then exit;
   ent:=TEzCustomPicture.CreateEntity(p1,p2);
   if FGroupInProgress then
      FGroup.Add(ent)
   else
      do_AddEntity(Ent,true);
end;

procedure TEzScrParser.do_bandsbitmap(const p1,p2:TEzPoint; const filename:String; AlphaChannel: Byte);
var
   ent:TEzEntity;
begin
   if FCheckSyntax then exit;
   ent:=TEzBandsBitmap.CreateEntity(p1,p2,FileName);
   TEzBandsBitmap(ent).AlphaChannel:=AlphaChannel;
   if FGroupInProgress then
      FGroup.Add(ent)
   else
      do_AddEntity(Ent,true);
end;

procedure TEzScrParser.do_persistbitmap(const p1,p2:TEzPoint; const filename:String);
var
   ent:TEzEntity;
begin
   if FCheckSyntax then exit;
   ent:=TEzPersistBitmap.CreateEntity(p1,p2,FileName);
   if FGroupInProgress then
      FGroup.Add(ent)
   else
      do_AddEntity(Ent,true);
end;

procedure TEzScrParser.do_insert(const p:TEzPoint; const blockname:String;
  const rotangle,scalex,scaley:Double;const replacer:string);
var
   ent:TEzEntity;
begin
   if FCheckSyntax then exit;
   ent:=TEzBlockInsert.CreateEntity(blockname,p,DegToRad(rotangle),scalex,scaley);
   TEzBlockInsert(ent).Text:=replacer;
   if FGroupInProgress then
      FGroup.Add(ent)
   else
      do_AddEntity(Ent,true);
end;

procedure TEzScrParser.do_spline(V:TEzVector);
var
   ent:TEzEntity;
begin
   if FCheckSyntax then exit;
   ent:=TEzSpline.CreateEntity([Point2D(0,0)]);
   ent.points.assign(V);
   if FGroupInProgress then
      FGroup.Add(ent)
   else
      do_AddEntity(Ent,true);
end;

procedure TEzScrParser.do_splinetext(IsTrueType: Boolean; const AText: string; V:TEzVector);
var
   ent:TEzEntity;
begin
   if FCheckSyntax then exit;
   ent:=TEzSplineText.CreateEntity(IsTrueType, AText);
   ent.points.assign(V);
   if FGroupInProgress then
      FGroup.Add(ent)
   else
      do_AddEntity(Ent,true);
end;

procedure TEzScrParser.do_dimhorizontal(const p1,p2: TEzPoint; const TextLineY: Double);
var
   ent:TEzEntity;
begin
   if FCheckSyntax then exit;
   ent:=TEzDimHorizontal.CreateEntity(p1,p2,TextLineY);
   if FGroupInProgress then
      FGroup.Add(ent)
   else
      do_AddEntity(Ent,true);
end;

procedure TEzScrParser.do_dimvertical(const p1,p2: TEzPoint; const TextLineX: Double);
var
   ent:TEzEntity;
begin
   if FCheckSyntax then exit;
   ent:=TEzDimVertical.CreateEntity(p1,p2,TextLineX);
   if FGroupInProgress then
      FGroup.Add(ent)
   else
      do_AddEntity(Ent,true);
end;

procedure TEzScrParser.do_dimparallel(const p1,p2: TEzPoint;
  const TextLineDistanceApart: Double);
var
   ent:TEzEntity;
begin
   if FCheckSyntax then exit;
   ent:=TEzDimParallel.CreateEntity(p1,p2,TextLineDistanceApart);
   if FGroupInProgress then
      FGroup.Add(ent)
   else
      do_AddEntity(Ent,true);
end;

procedure TEzScrParser.do_preview(const p1,p2: TEzPoint; FileNo:Integer;
 APlottedUnits, ADrawingUnits: Double; APrintFrame: Boolean;
 AProposedPrintArea: TEzRect );
var
   ent:TEzEntity;
begin
   if FCheckSyntax Or Not(FDrawBox is TEzPreviewBox) then exit;
   ent:=TEzPreviewEntity.CreateEntity(p1,p2,pmAll,FileNo);
   with TEzPreviewEntity(ent) do
   begin
     PlottedUnits:= APlottedUnits;
     DrawingUnits:= ADrawingUnits;
     PrintFrame:= APrintFrame;
     PaperUnits:= TEzPreviewBox( FDrawBox ).PaperUnits;
   end;
   if FGroupInProgress then
      FGroup.Add(ent)
   else
      do_AddEntity(Ent,true);
End;

procedure TEzScrParser.do_table;
begin
   if FCheckSyntax then
   begin
     FTableEntity.Columns.Clear;
     exit;
   end;
   do_addentity( FTableEntity,false );
   FTableEntity.Columns.Clear;
end;

procedure TEzScrParser.do_group;
begin
   if FCheckSyntax then
   begin
     FGroup.Clear;
     exit;
   end;
   do_addentity(FGroup,false);
   FGroup.Clear;
   FGroupInProgress:= False;
end;

procedure TEzScrParser.do_newlayer( const lay:String );
var
  FieldList: TStringList;
  i: Integer;
begin
   if FCheckSyntax then exit;
   with FDrawBox do
   begin
      FieldList:= nil;
      try
        if FNewLayerFields.Count > 0 then
        begin
           FieldList:= TStringList.Create;
           // create a new temp file
           for i:= 0 to FNewLayerFields.Count - 1 do
           begin
              with FNewLayerFields[i] do
                case FieldType of
                  RW_CHAR :
                    FieldList.Add(Format('%s;%s;%d;%d',[FieldName,'C',FieldSize,0]));
                  RW_FLOAT:
                    FieldList.Add(Format('%s;%s;%d;%d',[FieldName,'N',FieldSize,FieldDec]));
                  RW_INTEGER:
                    FieldList.Add(Format('%s;%s;%d;%d',[FieldName,'N',FieldSize,0]));
                  RW_BINARY:
                    FieldList.Add(Format('%s;%s;%d;%d',[FieldName,'B',10,0]));
                  RW_MEMO:
                    FieldList.Add(Format('%s;%s;%d;%d',[FieldName,'M',10,0]));
                  RW_LOGIC:
                    FieldList.Add(Format('%s;%s;%d;%d',[FieldName,'L',1,0]));
                  RW_DATETIME:
                    FieldList.Add(Format('%s;%s;%d;%d',[FieldName,'D',8,0]));
                end;
           end;
        end;
        with GIS do
          layers.CreateNew( lay, FieldList );
      finally
        if FieldList<>nil then FieldList.Free;
      end;
   end;
   FNewLayerFields.Clear;
end;

procedure TEzScrParser.do_activelayer(const lay:String);
begin
   if FCheckSyntax then exit;
   FDrawBox.GIS.CurrentLayerName:=lay;
end;

procedure TEzScrParser.updatefield(const fieldname, fieldvalue:String);
var
  layer: TEzBaseLayer;
begin
  if FCheckSyntax then exit;
  layer := FDrawBox.GIS.CurrentLayer;
  if (layer=nil) or not Assigned(layer.DBTable) then Exit;
  layer.DBTable.Edit;
  layer.DBTable.StringPut(fieldname,fieldvalue);
  layer.DBTable.Post;
end;

{ TNewLayerFields class implementation }
constructor TNewLayerFields.Create;
begin
   inherited Create;
   FItems:= TList.Create;
end;

destructor TNewLayerFields.Destroy;
begin
   Clear;
   FItems.Free;
   inherited Destroy;
end;

function TNewLayerFields.GetCount: Integer;
begin
   Result := FItems.Count;
end;

function TNewLayerFields.GetItem(Index: Integer): TNewLayerField;
begin
   Result := FItems[Index];
end;

function TNewLayerFields.Add: TNewLayerField;
begin
   Result := TNewLayerField.Create;
   FItems.Add(Result);
end;

procedure TNewLayerFields.Clear;
var
   I: Integer;
begin
   for I:= 0 to FItems.Count - 1 do
      TNewLayerField(FItems[I]).Free;
   FItems.Clear;
end;

procedure TNewLayerFields.Delete(Index: Integer);
begin
   TNewLayerField(FItems[Index]).Free;
   FItems.Delete(Index);
end;

// function yylex : Integer; forward;  // addition 1

function TEzScrParser.yyparse : Integer; // addition 2

var yystate, yysp, yyn : SmallInt;
    yys : array [1..yymaxdepth] of SmallInt;
    yyv : array [1..yymaxdepth] of YYSType;
    yyval : YYSType;

    TickStart: DWORD;
    Msg: TMsg;

procedure yyaction ( yyruleno : Integer );
  (* local definitions: *)
  var i: Integer;
      gstyle: TEzTableBorderStyle;
      fnt: TEzFontStyle;
begin
  (* actions: *)
  case yyruleno of
   1 : begin
         yyval := yyv[yysp-0];
       end;
   2 : begin
         yyval := yyv[yysp-1];
       end;
   3 : begin
         yyval := yyv[yysp-0];
       end;
   4 : begin
         yyval := yyv[yysp-0];
       end;
   5 : begin
         yyval := yyv[yysp-0];
       end;
   6 : begin
         yyval := yyv[yysp-0];
       end;
   7 : begin
         yyval := yyv[yysp-0];
       end;
   8 : begin
         yyval := yyv[yysp-0];
       end;
   9 : begin
         yyval := yyv[yysp-0];
       end;
  10 : begin
         yyval := yyv[yysp-0];
       end;
  11 : begin
         yyval := yyv[yysp-0];
       end;
  12 : begin
         yyval := yyv[yysp-0];
       end;
  13 : begin
         if Assigned(FCmdLine) then
         begin
         FCmdLine.AddPointToCurrentAction( Point2D(StrToFloat(yyv[yysp-2].yystring),StrToFloat(yyv[yysp-0].yystring) ) );
         end;
       end;
  14 : begin
         if Assigned(FCmdLine) then
         begin
         FCmdLine.AddRelativePointToCurrentAction(Point2D( StrToFloat(yyv[yysp-2].yystring),StrToFloat(yyv[yysp-0].yystring) ) );
         end;
       end;
  15 : begin
         if Assigned(FCmdLine) then
         begin
         FCmdLine.AddRelativeAngleToCurrentAction( StrToFloat(yyv[yysp-2].yystring),StrToFloat(yyv[yysp-0].yystring) );
         end;
       end;
  16 : begin
         if Assigned(FCmdLine) then
         begin
         FCmdLine.AddPointListToCurrentAction( FVector );
         FVector.Clear;
         end;
       end;
  17 : begin
         if Assigned(FCmdLine) then
         begin
         FCmdLine.CurrentAction.UserValue:= StrToFloat(yyv[yysp-0].yystring);
         FCmdLine.CurrentAction.UserCommand:= itFloatValue;
         end;
       end;
  18 : begin
         if Assigned(FCmdLine) then
         begin
         FCmdLine.CurrentAction.UserString:= GetString( yyv[yysp-0].yystring );
         FCmdLine.CurrentAction.UserCommand:= itString;
         end;
       end;
  19 : begin
         do_penstyle(StrToInt(yyv[yysp-4].yystring), StrToInt(yyv[yysp-2].yystring), StrToFloat(yyv[yysp-0].yystring), StrToFloat(yyv[yysp-5].yystring));
       end;
  20 : begin
         do_fillstyle( StrToInt(yyv[yysp-4].yystring), StrToInt(yyv[yysp-2].yystring), StrToInt(yyv[yysp-0].yystring) ) ;
       end;
  21 : begin
         do_ttfontstyle(GetString( yyv[yysp-12].yystring ), GetBoolean(yyv[yysp-10].yystring),
         GetBoolean(yyv[yysp-8].yystring), GetBoolean(yyv[yysp-6].yystring), GetBoolean(yyv[yysp-4].yystring),
         StrToInt(yyv[yysp-2].yystring), StrToInt(yyv[yysp-0].yystring) );
       end;
  22 : begin
         Ez_Preferences.DefFontStyle.Name:= yyv[yysp-0].yystring;
       end;
  23 : begin
         do_symbolstyle(StrToInt(yyv[yysp-4].yystring), StrToFloat(yyv[yysp-2].yystring), StrToFloat(yyv[yysp-0].yystring));
       end;
  24 : begin
         yyval := yyv[yysp-0];
       end;
  25 : begin
         yyval := yyv[yysp-0];
       end;
  26 : begin
         yyval := yyv[yysp-0];
       end;
  27 : begin
         yyval := yyv[yysp-2];
       end;
  28 : begin
         FVector.AddPoint(StrToFloat(yyv[yysp-3].yystring), StrToFloat(yyv[yysp-1].yystring));
       end;
  29 : begin
         yyval := yyv[yysp-0];
       end;
  30 : begin
         yyval := yyv[yysp-2];
       end;
  31 : begin
         if FVector.Parts.Count=0 then
         FVector.Parts.Add(0);
         FVector.Parts.Add(FVector.Count);
       end;
  32 : begin
         yyval := yyv[yysp-0];
       end;
  33 : begin
         yyval := yyv[yysp-1];
       end;
  34 : begin
         updatefield(yyv[yysp-2].yystring, GetString( yyv[yysp-0].yystring ) );
       end;
  35 : begin
         yyval := yyv[yysp-0];
       end;
  36 : begin
         yyval := yyv[yysp-0];
       end;
  37 : begin
         yyval := yyv[yysp-0];
       end;
  38 : begin
         yyval := yyv[yysp-0];
       end;
  39 : begin
         yyval := yyv[yysp-5];
       end;
  40 : begin
         yyval := yyv[yysp-0];
       end;
  41 : begin
         yyval := yyv[yysp-0];
       end;
  42 : begin
         yyval := yyv[yysp-0];
       end;
  43 : begin
         yyval := yyv[yysp-0];
       end;
  44 : begin
         yyval := yyv[yysp-0];
       end;
  45 : begin
         yyval := yyv[yysp-0];
       end;
  46 : begin
         yyval := yyv[yysp-0];
       end;
  47 : begin
         yyval := yyv[yysp-0];
       end;
  48 : begin
         yyval := yyv[yysp-0];
       end;
  49 : begin
         yyval := yyv[yysp-0];
       end;
  50 : begin
         yyval := yyv[yysp-0];
       end;
  51 : begin
         yyval := yyv[yysp-0];
       end;
  52 : begin
         yyval := yyv[yysp-0];
       end;
  53 : begin
         yyval := yyv[yysp-0];
       end;
  54 : begin
         yyval := yyv[yysp-0];
       end;
  55 : begin
         yyval := yyv[yysp-0];
       end;
  56 : begin
         yyval := yyv[yysp-0];
       end;
  57 : begin
         yyval := yyv[yysp-0];
       end;
  58 : begin
         yyval := yyv[yysp-0];
       end;
  59 : begin
         yyval := yyv[yysp-0];
       end;
  60 : begin
         yyval := yyv[yysp-0];
       end;
  61 : begin
         yyval := yyv[yysp-0];
       end;
  62 : begin
         yyval := yyv[yysp-0];
       end;
  63 : begin
         yyval := yyv[yysp-0];
       end;
  64 : begin
         yyval := yyv[yysp-0];
       end;
  65 : begin
         yyval := yyv[yysp-0];
       end;
  66 : begin
         do_none;
         FVector.Clear;
       end;
  67 : begin
         do_point(FVector[0]);
         FVector.Clear;
       end;
  68 : begin
         do_insert(FVector[0],GetString( yyv[yysp-8].yystring ),StrToFloat(yyv[yysp-6].yystring),
         StrToFloat(yyv[yysp-4].yystring), StrToFloat(yyv[yysp-2].yystring),GetString( yyv[yysp-0].yystring ));
         FVector.Clear;
       end;
  69 : begin
         do_place(FVector[0], GetString( yyv[yysp-0].yystring ) );
         FVector.Clear;
       end;
  70 : begin
         do_polyline(FVector);
         FVector.Clear
       end;
  71 : begin
         do_polygon(FVector);
         FVector.Clear;
       end;
  72 : begin
         do_line(FVector[0], FVector[1] );
         FVector.Clear;
       end;
  73 : begin
         do_rectangle(FVector[0], FVector[1], StrToFloat(yyv[yysp-0].yystring));
         FVector.Clear;
       end;
  74 : begin
         do_arc(FVector[0], strtofloat(yyv[yysp-6].yystring), strtofloat(yyv[yysp-4].yystring),
         strtofloat(yyv[yysp-2].yystring), GetBoolean(yyv[yysp-0].yystring));
         FVector.Clear;
       end;
  75 : begin
         do_arc2(FVector[0], FVector[1], FVector[2]);
         FVector.Clear;
       end;
  76 : begin
         do_ellipse(FVector[0], FVector[1], StrToFloat(yyv[yysp-0].yystring));
         FVector.Clear;
       end;
  77 : begin
         do_truetypetext( FVector[0], GetString( yyv[yysp-6].yystring ),
         StrToInt(yyv[yysp-4].yystring), StrToFloat(yyv[yysp-2].yystring),
         StrToFloat(yyv[yysp-0].yystring) );
         FVector.Clear;
       end;
  78 : begin
         do_fittedtext(FVector[0], GetString( yyv[yysp-8].yystring ),
         StrToFloat(yyv[yysp-6].yystring), StrToFloat(yyv[yysp-4].yystring),
         StrToFloat(yyv[yysp-2].yystring), StrToInt(yyv[yysp-0].yystring));
         FVector.Clear;
       end;
  79 : begin
         do_justiftext(FVector[0], FVector[1], yyv[yysp-10].yystring,
         StrToFloat(yyv[yysp-8].yystring), StrToFloat(yyv[yysp-6].yystring),
         StrToInt(yyv[yysp-4].yystring), StrToInt(yyv[yysp-2].yystring), StrToInt(yyv[yysp-0].yystring));
         FVector.Clear;
       end;
  80 : begin
         do_pictureref(FVector[0], FVector[1], GetString( yyv[yysp-4].yystring ), StrToInt(yyv[yysp-2].yystring), StrToFloat(yyv[yysp-0].yystring) );
         FVector.Clear;
       end;
  81 : begin
         do_bandsbitmap(FVector[0], FVector[1], GetString( yyv[yysp-2].yystring ), StrToInt(yyv[yysp-0].yystring) );
         FVector.Clear;
       end;
  82 : begin
         do_persistbitmap(FVector[0], FVector[1], GetString( yyv[yysp-0].yystring ) );
         FVector.Clear;
       end;
  83 : begin
         do_custpict(FVector[0], FVector[1] );
         FVector.Clear;
       end;
  84 : begin
         do_spline(FVector);
         FVector.Clear;
       end;
  85 : begin
         do_splinetext(GetBoolean(yyv[yysp-4].yystring), yyv[yysp-4].yystring, FVector);
         FVector.Clear;
       end;
  86 : begin
         do_preview(FVector[0], FVector[1], StrToInt(yyv[yysp-14].yystring),
         StrToFloat(yyv[yysp-12].yystring), StrToFloat(yyv[yysp-10].yystring), GetBoolean(yyv[yysp-8].yystring),
         Rect2d(StrToFloat(yyv[yysp-6].yystring), StrToFloat(yyv[yysp-4].yystring),
         StrToFloat(yyv[yysp-2].yystring), StrToFloat(yyv[yysp-0].yystring)) );
         FVector.Clear;
       end;
  87 : begin
         // baselinefrom, baselineto, textlineY
         do_dimhorizontal(FVector[0], FVector[1], StrToFloat(yyv[yysp-0].yystring));
         FVector.Clear;
       end;
  88 : begin
         // baselinefrom, baselineto, textlineX
         do_dimvertical(FVector[0], FVector[1], StrToFloat(yyv[yysp-0].yystring));
         FVector.Clear;
       end;
  89 : begin
         // baselinefrom, baselineto, TextLineDistanceApart
         do_dimparallel(FVector[0], FVector[1], StrToFloat(yyv[yysp-0].yystring));
         FVector.Clear;
       end;
  90 : begin
         yyval := yyv[yysp-2];
       end;
  91 : begin
         FGroupInProgress := True; FGroup.Clear;
       end;
  92 : begin
         do_group;
       end;
  93 : begin
         yyval := yyv[yysp-0];
       end;
  94 : begin
         yyval := yyv[yysp-1];
       end;
  95 : begin
         yyval := yyv[yysp-0];
       end;
  96 : begin
         yyval := yyv[yysp-0];
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
         yyval := yyv[yysp-0];
       end;
 101 : begin
         yyval := yyv[yysp-0];
       end;
 102 : begin
         do_newlayer( GetString( yyv[yysp-0].yystring ) );
       end;
 103 : begin
         do_newlayer( GetString( yyv[yysp-5].yystring ) );
       end;
 104 : begin
         yyval := yyv[yysp-0];
       end;
 105 : begin
         yyval := yyv[yysp-1];
       end;
 106 : begin
         if not FCheckSyntax then
         with FNewLayerFields.Add do
         begin
         FieldName := yyv[yysp-2].yystring;
         FieldType := self.FTmpFieldType;
         FieldSize := self.FTmpFieldSize;
         FieldDec  := self.FTmpFieldDec;
         end;
       end;
 107 : begin
         self.FTmpFieldType := RW_CHAR;
         self.FTmpFieldSize := StrToInt(yyv[yysp-1].yystring);
         self.FTmpFieldDec  := 0;
       end;
 108 : begin
         self.FTmpFieldType := RW_INTEGER;
         self.FTmpFieldSize := StrToInt(yyv[yysp-1].yystring);
         self.FTmpFieldDec  := 0;
       end;
 109 : begin
         self.FTmpFieldType := RW_DATETIME;
         self.FTmpFieldSize := 8;
         self.FTmpFieldDec  := 0;
       end;
 110 : begin
         self.FTmpFieldType := RW_LOGIC;
         self.FTmpFieldSize := 1;
         self.FTmpFieldDec  := 0;
       end;
 111 : begin
         self.FTmpFieldType := RW_FLOAT;
         self.FTmpFieldSize := StrToInt(yyv[yysp-3].yystring);
         self.FTmpFieldDec  := StrToInt(yyv[yysp-1].yystring);
       end;
 112 : begin
         self.FTmpFieldType := RW_MEMO;
         self.FTmpFieldSize := 0;
         self.FTmpFieldDec  := 0;
       end;
 113 : begin
         self.FTmpFieldType := RW_BINARY;
         self.FTmpFieldSize := 0;
         self.FTmpFieldDec  := 0;
       end;
 114 : begin
       end;
 115 : begin
         yyval := yyv[yysp-2];
       end;
 116 : begin
         yyval := yyv[yysp-0];
       end;
 117 : begin
         yyval := yyv[yysp-1];
       end;
 118 : begin
         FProjParams.Add(yyv[yysp-2].yystring + '=' + yyv[yysp-0].yystring);
       end;
 119 : begin
         do_activelayer( GetString( yyv[yysp-0].yystring ) );
       end;
 120 : begin
         Val( yyv[yysp-0].yystring, FIntValue, Fcode );
         yyval.yystring:= IntToStr(FIntValue);
       end;
 121 : begin
         yyval := yyv[yysp-0];
       end;
 122 : begin
         do_table;
       end;
 123 : begin
         FTableEntity.Pentool.FPenStyle:= Ez_Preferences.DefPenStyle.FPenStyle;
         FTableEntity.Brushtool.FBrushStyle:= Ez_Preferences.DefBrushStyle.FBrushStyle;
         FTableEntity.Columns.Clear;
         FColIndex:= 0;
         FDataIndex:= 0;
         FTableEntity.Points[0]:= FVector[0];
         FTableEntity.Points[1]:= FVector[1];
         FNumRows:= StrToInt(yyv[yysp-18].yystring);
         FNumCols:= StrToInt(yyv[yysp-16].yystring);
         For I:= 1 to FNumCols Do
         FTableEntity.Columns.Add;
         FTableEntity.RowCount:= FNumRows;
         FTableEntity.Options:= [];
         If GetBoolean(yyv[yysp-14].yystring) Then
         FTableEntity.Options:= FTableEntity.Options + [ezgoHorzLine];
         If GetBoolean(yyv[yysp-12].yystring) Then
         FTableEntity.Options:= FTableEntity.Options + [ezgoVertLine];
         gstyle.Visible:= GetBoolean(yyv[yysp-10].yystring);
         gstyle.Style:= StrToInt(yyv[yysp-8].yystring);
         gstyle.Color:= StrToInt(yyv[yysp-6].yystring);
         gstyle.Width:= StrToFloat(yyv[yysp-4].yystring);
         FTableEntity.GridStyle:= gstyle;
         FTableEntity.BorderWidth:= StrToFloat(yyv[yysp-2].yystring);
         FTableEntity.LoweredColor:= StrToInt(yyv[yysp-0].yystring);
         FVector.Clear;
       end;
 124 : begin
       end;
 125 : begin
         yyval := yyv[yysp-0];
       end;
 126 : begin
         Inc(FColIndex);
       end;
 127 : begin
         Inc(FColIndex);
       end;
 128 : begin
         yyval := yyv[yysp-5];
       end;
 129 : begin
         with FTableEntity.Columns[FColIndex] do
         begin
         Font:= Ez_Preferences.DefTTFontStyle.FFontStyle;
         Width:= StrToFloat(yyv[yysp-10].yystring);
         Transparent:= GetBoolean(yyv[yysp-8].yystring);
         Color:= StrToInt(yyv[yysp-6].yystring);
         Alignment:= TAlignment(StrToInt(yyv[yysp-4].yystring));
         ColumnType:= TEzColumnType(StrToInt(yyv[yysp-2].yystring));
         fnt:= Font;
         fnt.Height:= StrToFloat(yyv[yysp-0].yystring);
         Font:= fnt;
         end;
         FDataIndex:= 0;
       end;
 130 : begin
         with FTableEntity.Columns[FColIndex] do
         begin
         Title.Font:= Ez_Preferences.DefTTFontStyle.FFontStyle;
         Title.Caption:= GetString(yyv[yysp-8].yystring);
         Title.Alignment:= TAlignment(StrToInt(yyv[yysp-6].yystring));
         Title.Color:= StrToInt(yyv[yysp-4].yystring);
         Title.Transparent:= GetBoolean(yyv[yysp-2].yystring);
         fnt:= Title.Font;
         fnt.Height:= StrToFloat(yyv[yysp-0].yystring);
         Title.Font:= fnt;
         end;
       end;
 131 : begin
         yyval := yyv[yysp-2];
       end;
 132 : begin
         FTableEntity.Columns[FColIndex].Strings[FDataIndex]:= GetString(yyv[yysp-0].yystring);
         Inc(FDataIndex);
       end;
 133 : begin
         FTableEntity.Columns[FColIndex].Strings[FDataIndex]:= GetString(yyv[yysp-0].yystring);
         Inc(FDataIndex);
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

yynacts   = 795;
yyngotos  = 293;
yynstates = 401;
yynrules  = 133;

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

  ResLoad('EzScrYacc_YYA', @yya[1]);
  ResLoad('EzScrYacc_YYG', @yyg[1]);

  ResLoad('EzScrYacc_YYD', @yyd[0]);

  ResLoad('EzScrYacc_YYAL', @yyal[0]);

  ResLoad('EzScrYacc_YYAH', @yyah[0]);

  ResLoad('EzScrYacc_YYGL', @yygl[0]);

  ResLoad('EzScrYacc_YYGH', @yygh[0]);

  ResLoad('EzScrYacc_YYR', @yyr[1]);


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

  (* Initialize the tick counter *)
  TickStart := GetTickCount;

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

         // check for time elapsed in order to be able to cancel parsing
         if GetTickCount>=TickStart+500 then   // 1/2 second the test
         begin
            // check if specific messages are waiting and if so, cancel internal selecting
            PeekMessage(Msg, FDrawBox.Handle, WM_KEYDOWN, WM_KEYDOWN, PM_REMOVE);
            if (Msg.Message=WM_KEYDOWN) and (Msg.WParam=VK_ESCAPE) then begin
               yyerrormsg:= Sscrcanceled;
               goto Abort;
            end;

            TickStart:= GetTickCount;
         end;
      until false;
      if yychar= _ILLEGAL then goto error;
    end;

  {if yydebug then
    writeln( yyLexer.yyOutput, 'state '+intToStr( yystate)+ ', char '+
                               intToStr( yychar) + ' at line n°'+
                               intToStr(yyLexer.yylineno) + ', col n°' +
                               intToStr( yyLexer.yycolno)); }

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
          {if yydebug then
            if yysp>1 then
              writeln( yyLexer.yyOutput, 'error recovery pops state ' +
                       intToStr(yys[yysp])+', uncovers '+ intToStr(yys[yysp-1]))
            else
              writeln( yyLexer.yyOutput, 'error recovery fails ... abort'); }
          dec(yysp);
        end;
      if yysp=0 then goto abort; (* parser has fallen from stack; abort *)
      yystate := yyn;            (* simulate shift on error *)
      goto parse;
    end
  else                                  (* no shift yet; discard symbol *)
    begin
      {if yydebug then
        writeln( yyLexer.yyOutput, 'error recovery discards char '+
                 intToStr( yychar)); }
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