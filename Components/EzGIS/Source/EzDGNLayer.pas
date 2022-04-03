unit EzDGNLayer;

{$I EZ_FLAG.PAS}
interface

Uses
  SysUtils, Windows, Classes, Graphics, Controls, Forms,
  EzBaseGis, EzLib, EzBase, EzShpImport, EzRTree, EzBaseExpr, Dialogs, StdCtrls;

{$DEFINE CPL_LSB}
{$DEFINE WITH_TEMPLATE}   // export option: by using template or not
type

  TPaletteArray = Packed Array[0..255, 0..2] Of Byte;

  T4Byte = Packed Array[0..3] Of Byte;
  T8Byte = Packed Array[0..7] Of Byte;

  TElm_hdr = Packed Record {The element header}
    LevelCmplx: Byte; {Bits 0-6: Level, 7: Reserved, 8: Set if component part of complex elem}
    TypeDeleted: Byte; {Bits 1-7: Type, 8: Set if element is deleted}
    Words: Word; {Words to follow in element, to next element, excluding two words above}
    xLow: DWord; {Element extents - Low}
    yLow: DWord;
    zLow: DWord;
    xHigh: DWord; {Element extents - High}
    yHigh: DWord;
    zHigh: DWord;
  End;

  TDisp_hdr = Packed Record {The display header}
    grphgrp: Word; {Graphic group number}
    attindx: Smallint; {Words between this and attribute linkage}
    props: Word; {Bits 0-3: Class, 4-7: Reserved, 8: Locked, 9: New, 10: Modified, 11: Attrib present}
    {      12: View Independant, 13: Planar, 14: 1=nonsnappable, 15: hole/solid (usually)}
    symb: Word; {Bits 0-2: Line style, 3-7: Line weight, 8-15: Color}
  End;

  TDGNElemTCB = Record { The DGN File TCB }
    Head: TElm_hdr;
    Dimension: byte; // 2 or 3

    sub_per_master: longint; // Subunits per master unit.
    master_units: Array[0..2] Of char; // Name of Master units
    uor_per_subunit: longint; // UOR (Units Of Resolution per subunits.
    sub_units: Array[0..2] Of char; // Name of Sub units

    origin_x: LongInt; // X origin of UOR space in master units(?)
    origin_y: LongInt; // Y origin of UOR space in master units(?)
    origin_z: LongInt; // Z origin of UOR space in master units(?)
  End;

  TDGNPoint2D = Packed Record {A 2D Point}
    x, y: Longint;
  End;

  TDGNPoint3D = Packed Record {A 3D Point}
    x, y, z: Longint;
  End;

  TDPoint3D = Packed Record { A 3D DoublePoint}
    x, y, z: Double;
  End;

  TDPoint2D = TEzPoint;

  TEzConvertPoint = Procedure (Sender: TObject; Var P: TEzPoint ) Of Object;

  { this class is for reading DGN files }
  TEzDGNFile = Class
  Private
    FUseTrueType: Boolean;
    FUseDefaultColorTable: Boolean;
    FOffsets: TIntegerList;
    FFileName: string;
    FIncludedLevels: Array[0..63] Of Boolean;
    FXMin: Double;
    FYMin: Double;
    FXMax: Double;
    FYMax: Double;
    { memory loaded means all entities will be loaded to memory }
    FMemoryLoaded: Boolean;
    FElements: TEzEntityList;

    FActive: Boolean;
    FDGNInputStream: TStream;
    FScale: Double;
    FHeightQuotient: Double;
    FColorTable: TPaletteArray;
    FDGN_TCB: TDGNElemTCB;

    FOnConvertPoint: TEzConvertPoint;

    Procedure EvaluateDisp_Hdr( Const h: TDisp_Hdr;
      Var curpen: TEzPenStyle; var curPenScale: Double; Var curbrush: TEzBrushStyle );
    Function GetRecordCount: Integer;
    function GetIncludedLevels(Index: Integer): Boolean;
    procedure SetIncludedLevels(Index: Integer; const Value: Boolean);
  Public
    Constructor Create;
    Destructor Destroy; Override;
    Procedure Open;
    Procedure Close;
    Function GetElement( n: Integer;
      Var element_type, element_level, PlanOfEle: Integer;
      Var element_str: string; Var _3Dz: Double ): TEzEntity ;

    Property UseTrueType: Boolean read FUseTrueType write FUseTrueType;
    Property UseDefaultColorTable: Boolean read FUseDefaultColorTable write FUseDefaultColorTable;
    Property Offsets: TIntegerList read FOffsets write FOffsets;
    Property FileName: string read FFileName write FFileName;
    Property Active: Boolean read FActive write FActive;
    Property RecordCount : Integer read GetRecordCount ;
    Property IncludedLevels[Index: Integer]: Boolean read GetIncludedLevels write SetIncludedLevels;
    Property XMin: Double read FXMin write FXMin;
    Property YMin: Double read FYMin write FYMin;
    Property XMax: Double read FXMax write FXMax;
    Property YMax: Double read FYMax write FYMax;
    Property MemoryLoaded: Boolean read FMemoryLoaded write FMemoryLoaded;

    Property OnConvertPoint: TEzConvertPoint read FOnConvertPoint write FOnConvertPoint;
  End;


  { now a TDGNLayer class }

{-----------------------------------------------------------------------------}
//                    TDGNLayerInfo
{-----------------------------------------------------------------------------}

  TDGNLayerInfo = Class( TEzBaseLayerInfo )
  Protected
    Function GetOverlappedTextAction: TEzOverlappedTextAction; Override;
    Procedure SetOverlappedTextAction( Value: TEzOverlappedTextAction ); Override;
    Function GetOverlappedTextColor: TColor; Override;
    Procedure SetOverlappedTextColor( Value: TColor ); Override;
    Function GetTextHasShadow: Boolean; Override;
    Procedure SetTextHasShadow( Value: boolean ); Override;
    Function GetTextFixedSize: Byte; Override;
    Procedure SetTextFixedSize( Value: Byte ); Override;
    Function GetVisible: boolean; Override;
    Procedure SetVisible( Value: boolean ); Override;
    Function GetSelectable: boolean; Override;
    Procedure SetSelectable( Value: boolean ); Override;
    Function GetIsCosmethic: boolean; Override;
    Procedure SetIsCosmethic( value: boolean ); Override;
    Function GetExtension: TEzRect; Override;
    Procedure SetExtension( Const Value: TEzRect ); Override;
    Function GetIDCounter: integer; Override;
    Procedure SetIDCounter( Value: integer ); Override;
    Function GetIsAnimationLayer: boolean; Override;
    Procedure SetIsAnimationLayer( Value: boolean ); Override;
    Function GetIsIndexed: boolean; Override;
    Procedure SetIsIndexed( Value: boolean ); Override;
    Function GetCoordsUnits: TEzCoordsUnits; Override;
    Procedure SetCoordsUnits( Value: TEzCoordsUnits ); Override;
    Function GetCoordSystem: TEzCoordSystem; Override;
    Procedure SetCoordSystem( Value: TEzCoordSystem ); Override;
    Function GetUseAttachedDB: Boolean; Override;
    Procedure SetUseAttachedDB( Value: Boolean ); Override;
    Function GetLocked: Boolean; Override;
    Procedure SetLocked( Value: Boolean ); Override;
  End;

  {----------------------------------------------------------------------------}
  //                    TDGNLayer
  {----------------------------------------------------------------------------}

  TEzDGNHeader = Packed record
    IncludedLevels: Array[0..63] Of Boolean;
    UseTrueType: Boolean;
    UseDefaultColorTable: Boolean;
    MemoryLoaded: Boolean;
  end;

  TDGNLayer = Class( TEzBaseLayer )
  Private
    FDGNFile: TEzDGNFile;
    FHeader: TEzLayerHeader;
    FRecno: Integer;
    FDBTable: TEzBaseTable;
    FEofCrack: Boolean;
    FUpdateRtree: Boolean;
    { buffering }
    ol: TIntegerList;
    FFilterRecno: Integer;
    FFiltered: boolean;

    { Information specific to this layer }
    FDGNHeader: TEzDGNHeader;

    Function GetDGNFile: TEzDGNFile;
    //Procedure UpdateMapExtension( Const R: TEzRect );
  Protected
    function GetFiltered: Boolean; Override;
    Function GetRecno: Integer; Override;
    Procedure SetRecno( Value: Integer ); Override;
    Function GetRecordCount: Integer; Override;
    Function GetActive: Boolean; Override;
    Procedure SetActive( Value: Boolean ); Override;
    Function GetDBTable: TEzBaseTable; Override;
  Public
    Constructor Create( Layers: TEzBaseLayers; Const AFileName: String ); Override;
    Destructor Destroy; Override;
    Procedure InitializeOnCreate( Const FileName: String;
      AttachedDB, IsAnimation: Boolean; CoordSystem: TEzCoordSystem;
      CoordsUnits: TEzCoordsUnits; FieldList: TStrings ); Override;
    Procedure StartBatchInsert; Override;
    Procedure FinishBatchInsert; Override;
    Procedure SetGraphicFilter( s: TSearchType; Const VisualWindow: TEzRect ); Override;
    Procedure CancelFilter; Override;
    Procedure GetFieldList( Strings: TStrings ); Override;
    Procedure Assign( Source: TEzBaseLayer ); Override;
    Procedure Open; Override;
    Procedure Close; Override;
    Procedure ForceOpened; Override;
    Procedure WriteHeaders( FlushFiles: Boolean ); Override;
    Function AddEntity( Entity: TEzEntity; Direct: Boolean = False ): Integer; Override;
    Procedure DeleteEntity( RecNo: Integer ); Override;
    Procedure UnDeleteEntity( RecNo: Integer ); Override;
    Function UpdateExtension: TEzRect; Override;
    Function QuickUpdateExtension: TEzRect; Override;
    Function LoadEntityWithRecNo( RecNo: Longint): TEzEntity; Override;
    Procedure UpdateEntity( RecNo: Integer; Entity2D: TEzEntity ); Override;
    Procedure Pack( ShowMessages: Boolean ); Override;
    Procedure Repair; Override;
    Procedure Zap; Override;

    Function Eof: Boolean; Override;
    Procedure First; Override;
    Procedure Last; Override;
    Procedure Next; Override;
    Procedure StartBuffering; Override;
    Procedure EndBuffering; Override;
    Function ContainsDeleted: Boolean; Override;
    Procedure Recall; Override;

    Function GetBookmark: Pointer; Override;
    Procedure GotoBookmark( Bookmark: Pointer ); Override;
    Procedure FreeBookmark( Bookmark: Pointer ); Override;

    Function SendEntityToBack( ARecno: Integer ): Integer; Override;
    Function BringEntityToFront( ARecno: Integer ): Integer; Override;
    Function RecIsDeleted: boolean; Override;
    Procedure RecLoadEntity2( Entity: TEzEntity ); Override;
    Function RecLoadEntity: TEzEntity; Override;
    Function RecExtension: TEzRect; Override;
    Function RecEntityID: TEzEntityID; Override;
    Procedure RebuildTree; Override;
    Procedure CopyRecord( SourceRecno, DestRecno: Integer ); Override;
    Function DefineScope( Const Scope: String ): Boolean; Override;
    Function DefinePolygonScope( Polygon: TEzEntity; Const Scope: String;
      Operator: TEzGraphicOperator ): Boolean; Override;
    Procedure Synchronize; Override;
    function GetExtensionForRecords( List: TIntegerList ): TEzRect; Override;

    Property DGNFile: TEzDGNFile read GetDGNFile;
    Property DGNHeader: TEzDGNHeader read FDGNHeader write FDGNHeader;

  End;


  { Original C++ code translation, implementation and export functionality by :
    Luis Rodrigo YaÒez Gutierrez }

  TDGNFileStream = class (TFileStream)
  Public
    constructor Create(const FileName: string; Mode: Word);
    function DGNRead(Buffer : Pointer; Count: Longint): Longint;
    function DGNWrite(Buffer : Pointer; Count: Longint): Longint;
  End;

  TEzDGNExport = Class(TComponent)
  private
    fp : TDGNFileStream;
    FColorTable : TPaletteArray;
    FUsedColors : SmallInt;
    FTableColorOffset : Longint;
    FTCBOffset: Longint;

    Fsubunits_per_master: integer;
    Fuor_per_subunit: integer;
    FMasterUnits: string;
    FSubUnits: string;
    FDgnScale: integer;

    FBuffer : PByteArray;
    FBuffSize : LongWord;

    Procedure CreateBuffer(Const Size : LongWord);
    Procedure ClearBuffer;
    Procedure FreeBuffer;

    Procedure SaveExtents( Buffer : PByteArray;  Const box: TEzRect );
    Procedure SavePointsToBuffer(Points : TEzVector; Idx1,Idx2: Integer; Buffer : PByteArray);
    Procedure SaveEllipse(Entity : TEzEntity; Level : Byte; var nWords : LongWord);
    Procedure SaveArc(Entity : TEzEntity; Level : Byte; var nWords : LongWord);
    Procedure SaveText(Entity : TEzEntity; Level : Byte; var nWords : LongWord);
    Procedure SavePlace(Entity : TEzEntity; Level : Byte; var nWords : LongWord);
    Procedure SaveComplex(Extension : TEzRect; Level : Byte; ElemCount, ElemLength : Integer; Closed : Boolean);
    Procedure SaveEntity(Points : TEzVector; Color : TColor; Level : Byte; idx1, idx2 : Integer; DGN_TYPE : Integer; Closed : Boolean);
    Procedure SaveMultiPointEntity(Entity : TEzEntity; Level : Byte);
  protected
    Procedure CreateNewTable;
    Function AddColorToTable(Color : TColor) : SmallInt;
    Procedure SetColor(Var Core : Byte; Color : TColor);
    Procedure SetType(Buffer : PByteArray; DGNType : Byte; Level : Byte = 1; Complex : Boolean = False);
    Procedure SetStyle(Pen : TEzPenTool; Core : PByteArray; Closed: Boolean);
    Procedure SaveTCB(Buffer : PByteArray; subunits_per_master, uor_per_subunit : Integer;
                      Const master_units, sub_units : String; const origin_x, origin_y : Double);
    Procedure SaveColorTable(Position : Integer);
    Procedure UpdateColorTable;

  public
    constructor Create(AOwner: TComponent); override;
    Procedure DGNExport(Gis : TEzBaseGis; Layers : TStrings;
      Const FileName, Template : String; ExplodeBlocks: Boolean );
  Published
    Property subunits_per_master: integer read Fsubunits_per_master write Fsubunits_per_master;
    Property uor_per_subunit: integer read Fuor_per_subunit write Fuor_per_subunit;
    Property MasterUnits: string read FMasterUnits write FMasterUnits;
    Property SubUnits: string read FSubUnits write FSubUnits;
  End;

  Procedure ImportDGN( pszFileName : PChar; Gis : TEzBaseGIS; Layer : TEzBaseLayer; Memo : TMemo);

  Procedure vax2ieee(dbl : Pointer);
  Function DGN_INT32(p : Pointer) : Integer;
  Procedure Swap8Bytes(dbl : Pointer);

implementation

uses
  Math, EzSystem, EzConsts, EzEntities, EzMiscelEntities, EzBasicCtrls, EzExpressions;

Const
  DefColorTable: TPaletteArray = (
    ( 0, 0, 0 ), ( 255, 255, 255 ), ( 0, 0, 255 ), ( 0, 255, 0 ), ( 255, 0, 0 ), ( 255, 255, 0 ), ( 255, 0, 255 ), ( 255, 127, 0  ),
    ( 0, 255, 255 ), ( 64, 64, 64 ), ( 192, 192, 192 ), ( 254, 0, 96 ), ( 160, 224, 0 ), ( 0, 254, 160 ), ( 128, 0, 160 ), ( 176, 176, 176 ),
    ( 0, 240, 240 ), ( 240, 240, 240 ), ( 0, 0, 240 ), ( 0, 240, 0 ), ( 240, 0, 0 ), ( 240, 240, 0 ), ( 240, 0, 240 ), ( 240, 122, 0 ),
    ( 0, 240, 240 ), ( 240, 240, 240 ), ( 0, 0, 240 ), ( 0, 240, 0 ), ( 240, 0, 0 ), ( 240, 240, 0 ), ( 240, 0, 240 ), ( 240, 122, 0 ),
    ( 0, 225, 225 ), ( 225, 225, 225 ), ( 0, 0, 225 ), ( 0, 225, 0 ), ( 225, 0, 0 ), ( 225, 225, 0 ), ( 225, 0, 225 ), ( 225, 117, 0 ),
    ( 0, 225, 225 ), ( 225, 225, 225 ), ( 0, 0, 225 ), ( 0, 225, 0 ), ( 225, 0, 0 ), ( 225, 225, 0 ), ( 225, 0, 225 ), ( 225, 117, 0 ),
    ( 0, 210, 210 ), ( 210, 210, 210 ), ( 0, 0, 210 ), ( 0, 210, 0 ), ( 210, 0, 0 ), ( 210, 210, 0 ), ( 210, 0, 210 ), ( 210, 112, 0 ),
    ( 0, 210, 210 ), ( 210, 210, 210 ), ( 0, 0, 210 ), ( 0, 210, 0 ), ( 210, 0, 0 ), ( 210, 210, 0 ), ( 210, 0, 210 ), ( 210, 112, 0 ),
    ( 0, 195, 195 ), ( 195, 195, 195 ), ( 0, 0, 195 ), ( 0, 195, 0 ), ( 195, 0, 0 ), ( 195, 195, 0 ), ( 195, 0, 195 ), ( 195, 107, 0 ),
    ( 0, 195, 195 ), ( 195, 195, 195 ), ( 0, 0, 195 ), ( 0, 195, 0 ), ( 195, 0, 0 ), ( 195, 195, 0 ), ( 195, 0, 195 ), ( 195, 107, 0 ),
    ( 0, 180, 180 ), ( 180, 180, 180 ), ( 0, 0, 180 ), ( 0, 180, 0 ), ( 180, 0, 0 ), ( 180, 180, 0 ), ( 180, 0, 180 ), ( 180, 102, 0 ),
    ( 0, 180, 180 ), ( 180, 180, 180 ), ( 0, 0, 180 ), ( 0, 180, 0 ), ( 180, 0, 0 ), ( 180, 180, 0 ), ( 180, 0, 180 ), ( 180, 102, 0 ),
    ( 0, 165, 165 ), ( 165, 165, 165 ), ( 0, 0, 165 ), ( 0, 165, 0 ), ( 165, 0, 0 ), ( 165, 165, 0 ), ( 165, 0, 165 ), ( 165, 97, 0 ),
    ( 0, 165, 165 ), ( 165, 165, 165 ), ( 0, 0, 165 ), ( 0, 165, 0 ), ( 165, 0, 0 ), ( 165, 165, 0 ), ( 165, 0, 165 ), ( 165, 97, 0 ),
    ( 0, 150, 150 ), ( 150, 150, 150 ), ( 0, 0, 150 ), ( 0, 150, 0 ), ( 150, 0, 0 ), ( 150, 150, 0 ), ( 150, 0, 150 ), ( 150, 92, 0 ),
    ( 0, 150, 150 ), ( 150, 150, 150 ), ( 0, 0, 150 ), ( 0, 150, 0 ), ( 150, 0, 0 ), ( 150, 150, 0 ), ( 150, 0, 150 ), ( 150, 92, 0 ),
    ( 0, 135, 135 ), ( 135, 135, 135 ), ( 0, 0, 135 ), ( 0, 135, 0 ), ( 135, 0, 0 ), ( 135, 135, 0 ), ( 135, 0, 135 ), ( 135, 87, 0 ),
    ( 0, 135, 135 ), ( 135, 135, 135 ), ( 0, 0, 135 ), ( 0, 135, 0 ), ( 135, 0, 0 ), ( 135, 135, 0 ), ( 135, 0, 135 ), ( 135, 87, 0 ),
    ( 0, 120, 120 ), ( 120, 120, 120 ), ( 0, 0, 120 ), ( 0, 120, 0 ), ( 120, 0, 0 ), ( 120, 120, 0 ), ( 120, 0, 120 ), ( 120, 82, 0 ),
    ( 0, 120, 120 ), ( 120, 120, 120 ), ( 0, 0, 120 ), ( 0, 120, 0 ), ( 120, 0, 0 ), ( 120, 120, 0 ), ( 120, 0, 120 ), ( 120, 82, 0 ),
    ( 0, 105, 105 ), ( 105, 105, 105 ), ( 0, 0, 105 ), ( 0, 105, 0 ), ( 105, 0, 0 ), ( 105, 105, 0 ), ( 105, 0, 105 ), ( 105, 77, 0 ),
    ( 0, 105, 105 ), ( 105, 105, 105 ), ( 0, 0, 105 ), ( 0, 105, 0 ), ( 105, 0, 0 ), ( 105, 105, 0 ), ( 105, 0, 105 ), ( 105, 77, 0 ),
    ( 0, 90, 90 ), ( 90, 90, 90 ), ( 0, 0, 90 ), ( 0, 90, 0 ), ( 90, 0, 0 ), ( 90, 90, 0 ), ( 90, 0, 90 ), ( 90, 72, 0 ),
    ( 0, 90, 90 ), ( 90, 90, 90 ), ( 0, 0, 90 ), ( 0, 90, 0 ), ( 90, 0, 0 ), ( 90, 90, 0 ), ( 90, 0, 90 ), ( 90, 72, 0 ),
    ( 0, 75, 75 ), ( 75, 75, 75 ), ( 0, 0, 75 ), ( 0, 75, 0 ), ( 75, 0, 0 ), ( 75, 75, 0 ), ( 75, 0, 75 ), ( 75, 67, 0 ),
    ( 0, 75, 75 ), ( 75, 75, 75 ), ( 0, 0, 75 ), ( 0, 75, 0 ), ( 75, 0, 0 ), ( 75, 75, 0 ), ( 75, 0, 75 ), ( 75, 67, 0 ),
    ( 0, 60, 60 ), ( 60, 60, 60 ), ( 0, 0, 60 ), ( 0, 60, 0 ), ( 60, 0, 0 ), ( 60, 60, 0 ), ( 60, 0, 60 ), ( 60, 62, 0 ),
    ( 0, 60, 60 ), ( 60, 60, 60 ), ( 0, 0, 60 ), ( 0, 60, 0 ), ( 60, 0, 0 ), ( 60, 60, 0 ), ( 60, 0, 60 ), ( 60, 62, 0 ),
    ( 0, 45, 45 ), ( 45, 45, 45 ), ( 0, 0, 45 ), ( 0, 45, 0 ), ( 45, 0, 0 ), ( 45, 45, 0 ), ( 45, 0, 45 ), ( 45, 57, 0 ),
    ( 0, 45, 45 ), ( 45, 45, 45 ), ( 0, 0, 45 ), ( 0, 45, 0 ), ( 45, 0, 0 ), ( 45, 45, 0 ), ( 45, 0, 45 ), ( 45, 57, 0 ),
    ( 0, 30, 30 ), ( 30, 30, 30 ), ( 0, 0, 30 ), ( 0, 30, 0 ), ( 30, 0, 0 ), ( 30, 30, 0 ), ( 30, 0, 30 ), ( 30, 52, 0 ),
    ( 0, 30, 30 ), ( 30, 30, 30 ), ( 0, 0, 30 ), ( 0, 30, 0 ), ( 30, 0, 0 ), ( 30, 30, 0 ), ( 30, 0, 30 ), ( 192, 192, 192 )
    );

Type
  TLA = Array[1..4] Of Byte;

  _dbl = Packed Record
    hi : LongWord;
    lo : LongWord;
  End;

  double64_t = _dbl;

{ helper procedures follows }


Function LSwap( l: Longint ): LongInt;
Begin
  TLA( Result )[1] := TLA( l )[3];
  TLA( Result )[2] := TLA( l )[4];
  TLA( Result )[3] := TLA( l )[1];
  TLA( Result )[4] := TLA( l )[2];

  //Result := TLA( Result )[3] + TLA( Result )[4] * 256 + TLA( Result )[2] * 65536 * 256 + TLA( Result )[1] * 65536 ;

End;

Function HighOf8Byte( Const src: T8Byte ): T4Byte;
Begin
  Result[0] := src[0];
  Result[1] := src[1];
  Result[2] := src[2];
  Result[3] := src[3];
End;

Function LowOf8Byte( Const src: T8Byte ): T4Byte;
Begin
  Result[0] := src[4];
  Result[1] := src[5];
  Result[2] := src[6];
  Result[3] := src[7];
End;

Procedure Make8Byte( Var Dest: T8Byte; Const High, Low: T4Byte );
Begin
  Dest[0] := High[0];
  Dest[1] := High[1];
  Dest[2] := High[2];
  Dest[3] := High[3];
  Dest[4] := Low[0];
  Dest[5] := Low[1];
  Dest[6] := Low[2];
  Dest[7] := Low[3];
End;

(******************************************************************)

Procedure Swap8Bytes(dbl : Pointer);
var
    src : PByteArray;
    dest : PByteArray;
    dt : double64_t;
Begin

(* -------------------------------------------------------------------- *)
(* 	Arrange the VAX double so that it may be accessed by a 		*)
(*	double64_t structure, (two GUInt32s).				*)
(* -------------------------------------------------------------------- *)
    src :=   dbl;
    dest := @dt;
{$IFDEF CPL_LSB}
    dest[2] := src[0];
    dest[3] := src[1];
    dest[0] := src[2];
    dest[1] := src[3];
    dest[6] := src[4];
    dest[7] := src[5];
    dest[4] := src[6];
    dest[5] := src[7];
{$ELSE}
    dest[1] := src[0];
    dest[0] := src[1];
    dest[3] := src[2];
    dest[2] := src[3];
    dest[5] := src[4];
    dest[4] := src[5];
    dest[7] := src[6];
    dest[6] := src[7];
{$ENDIF}
  CopyMemory(dbl, @dt, 8);
end;


(******************************************************************)

Procedure vax2ieee(dbl : Pointer);
var
    dt : double64_t;
    sign : Cardinal;
    exponent : Cardinal;
    rndbits : Cardinal;
    src : PByteArray;
    dest : PByteArray;
Begin

(* -------------------------------------------------------------------- *)
(* 	Arrange the VAX double so that it may be accessed by a 		*)
(*	double64_t structure, (two GUInt32s).				*)
(* -------------------------------------------------------------------- *)
    src :=   dbl;
    dest := @dt;
{$IFDEF CPL_LSB}
    dest[2] := src[0];
    dest[3] := src[1];
    dest[0] := src[2];
    dest[1] := src[3];
    dest[6] := src[4];
    dest[7] := src[5];
    dest[4] := src[6];
    dest[5] := src[7];
{$ELSE}
    dest[1] := src[0];
    dest[0] := src[1];
    dest[3] := src[2];
    dest[2] := src[3];
    dest[5] := src[4];
    dest[4] := src[5];
    dest[7] := src[6];
    dest[6] := src[7];
{$ENDIF}

(* -------------------------------------------------------------------- *)
(*	Save the sign of the double					*)
(* -------------------------------------------------------------------- *)
    sign 	 := dt.hi And $80000000;

(* -------------------------------------------------------------------- *)
(*	Adjust the exponent so that we may work with it			*)
(* -------------------------------------------------------------------- *)
    exponent := dt.hi Shr 23;
    exponent := exponent And $000000ff;

    if (exponent <> 0) Then
        exponent := exponent -129 + 1023;

(* -------------------------------------------------------------------- *)
(*	Save the bits that we are discarding so we can round properly	*)
(* -------------------------------------------------------------------- *)
    rndbits := dt.lo And $00000007;

    dt.lo := dt.lo Shr 3;
    dt.lo := (dt.lo And $1fffffff) Or (dt.hi Shl 29);

    if (rndbits <> 0) Then
        dt.lo := dt.lo Or $00000001;

(* -------------------------------------------------------------------- *)
(*	Shift the hi-order int over 3 and insert the exponent and sign	*)
(* -------------------------------------------------------------------- *)
    dt.hi := dt.hi Shr 3;
    dt.hi := dt.hi And $000fffff;
    dt.hi := dt.hi Or (exponent shl 20) Or sign;



{$IFDEF CPL_LSB}
(* -------------------------------------------------------------------- *)
(*	Change the number to a byte swapped format			*)
(* -------------------------------------------------------------------- *)
    src := @dt;
    dest := dbl;

    dest[0] := src[4];
    dest[1] := src[5];
    dest[2] := src[6];
    dest[3] := src[7];
    dest[4] := src[0];
    dest[5] := src[1];
    dest[6] := src[2];
    dest[7] := src[3];
{$ELSE}
    CopyMemory( dbl, @dt, 8 );
{$ENDIF}
End;

Procedure SWAP(Var A, B : Byte);
Var
  t : Byte;
Begin
  t := A;
  A := B;
  B := t;
End;


Procedure ieee2vax ( d : Pointer );
Type
  _ieee = Record
    Case Integer Of
    0 : (b : Array [0..7] of Byte);
  End;

// VAX format variables.
  _vax = Record
    Case Integer Of
      0 : (b : Array [0..7] Of Byte);
      1 : (w : Array [0..3] Of Word);
  End;

Var
  i : SmallInt;

// IEEE format variables.
			// bits
  sign,		// 0
  expo : Word;		// 1  -  11

  ieee : _ieee;
  vax  : _vax;


Begin

  if( PDouble(d)^ = 0.0) Then 		// both IEEE and VAX zeros have all 8 bytes == 0.
    Exit;

  CopyMemory(@ieee, d, 8);			// "unionize" IEEE format input.

// reverse order of bytes from intel storage method.

  for i := 0 to 3 Do
    SWAP (ieee.b[7-i], ieee.b[i]);

// extract bit patterns.

  sign := Ord((ieee.b[0] And $80) <> 0);
  expo := ((ieee.b[0] And $7f) Shl 4) Or ((ieee.b[1] And $f0) Shr 4);

// fix up first word with sign, exponent and first 7 bits of fraction.

  expo := expo + 128 - 1022;
  vax.w[0] := (expo shl 7) Or ((ieee.b[1] And $0f) shl 3) Or
             (sign shl 15) Or ((ieee.b[2] And $e0) shr 5);

// swap byte order.

  SWAP( vax.b[0], vax.b[1] );

  for i := 2 To  6 Do
    vax.b[i] := ((ieee.b[i] And $1f) Shl 3) Or ((ieee.b[i+1] And $e0) Shr 5);

  vax.b[7] := ((ieee.b[7] And $1f) shl 3);

  i := 0;
  While i < 8 Do Begin
    SWAP( vax.b[i], vax.b[i+1] );
    inc(i, 2);
  End;

  CopyMemory(d, @vax, 8);

End;


{ TEzDGNFile }

constructor TEzDGNFile.Create;
begin
  Inherited;
  FMemoryLoaded:= False;
  FOffsets:= TIntegerList.Create;
  FHeightQuotient := 0.006;
  FScale := 1.0;
  FUseTrueType:= True;
  FillChar( FIncludedLevels, SizeOf( FIncludedLevels ), Ord( True ) );
  FElements:= TEzEntityList.Create;
end;

destructor TEzDGNFile.Destroy;
begin
  If Assigned( FDGNInputStream ) then
    FreeAndNil( FDGNInputStream );
  FOffsets.Free;
  FElements.Free;
  inherited;
end;

Procedure TEzDGNFile.EvaluateDisp_Hdr( Const h: TDisp_Hdr; Var curpen: TEzPenStyle;
  var curPenScale: Double; Var curbrush: TEzBrushStyle );
Var
  ColorIndex: Byte;

  Function getColor( index: byte ): TColor;
  Begin
    Result := RGB( FColorTable[index, 0], FColorTable[Index, 1], FColorTable[Index, 2] );
  End;

Begin
  curpen := Ez_Preferences.DefPenStyle.FPenStyle;
  curbrush := Ez_Preferences.DefBrushStyle.FBrushStyle;

  //
  Case h.symb And $7 Of
    0: curpen.style := 1;
    1: curpen.Style := 3;
    2: curpen.Style := 4;
    3: curpen.Style := 6;
    4: curpen.Style := 13;
    5: curpen.Style := 10;
    6: curpen.Style := 19;
    7: curpen.Style := 61;
  End;

  //  curPen.WidthPts := (h.symb and $F8) shr 3;
  //  curpen.Width := (h.symb and $F8) shr 3;
  //  penwidth := trunc((h.symb and $F8) shr 3);
  //  curpen.Widthpts := trunc(FDrawBox.Grapher.PointsToDistY((h.symb and $F8) shr 3));
  //  curpen.Widthpts := trunc((h.symb and $F8) shr 3);
  curPenScale := ( ( h.symb And $F8 ) Shr 3 ) / 100 - 0.01; //
  If curPenScale < 0 then
    curPenScale := 0.0;

  ColorIndex := ( h.symb And $FF00 ) Shr 8;
  curPen.Color := getColor( ColorIndex + 1 );
  if curPen.Color = clWhite then
    curPen.Color:= ezsystem.ComplColor(curPen.Color);
End;

procedure TEzDGNFile.Open;
var
  Elm_hdr: TElm_hdr ;
  p: Longint;
  l: Longint;
  b: Byte;
  element_type: Byte;
  element_level: byte;
  element_deleted: Boolean;
  OldCursor: TCursor;
  Extents, CurExtents: TEzRect;
  TmpEntity: TEzEntity;
  _3Dz: Double;
  ele_type, ele_level, PlanOfEle: integer;
  element_str: String;
  I: Integer;
  BadList: TIntegerList;
  temp: Boolean;
  origin_x : double;
  origin_y : double;
  origin_z : double;
begin

  Close;

  If Not FileExists( FFileName ) Then
  Begin
    MessageToUser( Format( SShpFileNotFound, [FFileName] ), smsgerror, MB_ICONERROR );
    Exit;
  End;

  FOffsets.Clear;

  FDGNInputStream := TFileStream.Create( FFileName, fmOpenRead Or fmShareDenyNone );

  FDGNInputStream.Position := 0;

  While FDGNInputStream.Position < FDGNInputStream.Size Do
  begin
    p := FDGNInputStream.Position;

    FDGNInputStream.Read( Elm_hdr, SizeOf( Elm_Hdr ) );
    element_Type := Elm_hdr.TypeDeleted And $7F;
    If element_Type = 9 Then // is TCB
    Begin

      FDGN_TCB.Head := Elm_hdr;

      FDGN_TCB.origin_x := FDGN_TCB.Head.xLow;
      FDGN_TCB.origin_y := FDGN_TCB.Head.yLow;
      FDGN_TCB.origin_z := FDGN_TCB.Head.zLow;

      // Units of resolution per subunit.
      FDGNInputStream.Position := 1112;

      FDGNInputStream.Read( l, SizeOf( l ) );
      FDGN_TCB.uor_per_subunit := LSwap( l );

      // Subunits per master unit.
      FDGNInputStream.Read( l, SizeOf( l ) );
      FDGN_TCB.sub_per_master := LSwap( l );

      // Name of subunits
      FDGNInputStream.Read( FDGN_TCB.sub_units, SizeOf( FDGN_TCB.sub_units ) - 1 );
      FDGN_TCB.sub_units[2] := #0;

      // Name of master units
      FDGNInputStream.Read( FDGN_TCB.master_units, SizeOf( FDGN_TCB.master_units ) - 1 );
      FDGN_TCB.master_units[2] := #0;

      FDGNInputStream.Position := 1214;
      FDGNInputStream.Read( b, SizeOf( b ) );

      If ( ( b And $40 ) = $40 ) Then
      Begin
        FDGN_TCB.Dimension := 3;
        //MessageToUser( 'This DGN File is 3-Dimension !!', SMsgWarning, MB_ICONWARNING );
      End
      Else
        FDGN_TCB.Dimension := 2;

      FScale := 1.0 / ( FDGN_TCB.uor_per_subunit * FDGN_TCB.sub_per_master );
      If AnsiCompareText( FDGN_TCB.sub_units , 'M') = 0  Then
      Else If AnsiCompareText( FDGN_TCB.sub_units, 'FT' ) = 0 Then
        FScale := FScale * 0.3048
      Else If AnsiCompareText( FDGN_TCB.sub_units, '''' ) = 0 Then
        FScale := FScale * 0.0254;

      FDGNInputStream.Position := 1240;
      FDGNInputStream.Read( origin_x, sizeof(double) );
      FDGNInputStream.Read( origin_y, sizeof(double) );
      FDGNInputStream.Read( origin_z, sizeof(double) );
      vax2ieee( @origin_x );
      vax2ieee( @origin_y );
      vax2ieee( @origin_z );

      Break;  // no more search

    End;

    FDGNInputStream.Position := p + ( ( Elm_Hdr.Words + 2 ) * SizeOf( Word ) );

  End;

  // Get Color Table
  FDGNInputStream.Position := 0;

  { read color table }
  FColorTable := DefColorTable;
  If Not FUseDefaultColorTable Then
  Begin
    While FDGNInputStream.Position < FDGNInputStream.Size Do
    Begin
      p := FDGNInputStream.Position;
      FDGNInputStream.Read( Elm_hdr, SizeOf( Elm_Hdr ) );
      element_Type := Elm_hdr.TypeDeleted And $7F;
      element_level := Elm_Hdr.LevelCmplx AND $3F;

      If ( element_Type = 5 ) And ( element_level = 1 ) Then
      Begin {Group data elements}
        FDGNInputStream.Position := FDGNInputStream.Position + SizeOf( TDisp_Hdr ) + 2;
        FDGNInputStream.Read( FColorTable, SizeOf( FColorTable ) );
        Break;
      End ;

      FDGNInputStream.Position := p + ( ( Elm_Hdr.Words + 2 ) * SizeOf( Word ) );
    End;
  End;

  Application.ProcessMessages;

  BadList:= TIntegerList.Create;
  OldCursor:= Screen.Cursor;
  Screen.Cursor:= crHourglass;
  Try

    { get offsets of elements }
    FDGNInputStream.Position := 0;
    While FDGNInputStream.Position < FDGNInputStream.Size Do
    begin
      p := FDGNInputStream.Position;

      FDGNInputStream.Read( Elm_hdr, SizeOf( Elm_Hdr ) );

      element_deleted := ( Elm_hdr.TypeDeleted And $80 ) = $80;
      element_Type := Elm_hdr.TypeDeleted And $7F;
      element_level := Elm_Hdr.LevelCmplx AND $3F;

      If Not element_deleted And // is deleted ?
         ( element_level in [0..63] ) And FIncludedLevels[element_level] And  // is in defined level ?
         ( element_Type In [3,4,6,11,15,16,17,21] ) Then  // only useful entities
      Begin
        { the offset }
        FOffsets.Add( p );
      end;

      FDGNInputStream.Position := p + ( 4 + Elm_Hdr.Words * SizeOf( Word ) );

    end;

    { get elements }
    Extents:= INVALID_EXTENSION;
    For I:= 0 to FOffsets.Count-1 do
    begin
      temp:= FMemoryLoaded;
      FMemoryLoaded:=false;
      TmpEntity:= GetElement( I, ele_type, ele_level, PlanOfEle, element_str, _3Dz ) ;
      FMemoryLoaded:=temp;
      If TmpEntity = Nil then
      begin
        BadList.Add( I );
        Continue;
      end;
      If FMemoryLoaded then
        FElements.Add( TmpEntity );
      CurExtents:= TmpEntity.FBox;
      MaxBound( Extents.Emax, CurExtents.Emax );
      MinBound( Extents.Emin, CurExtents.Emin );
    end;

    If FMemoryLoaded then
    begin
      FreeAndNil( FDGNInputStream );
      FOffsets.Clear;
      BadList.Clear;
    end Else
      For I:= BadList.Count-1 downto 0 do
      begin
        FOffsets.Delete( BadList[I] );
      end;

    Self.XMin:= Extents.Xmin;
    Self.YMin:= Extents.Ymin;
    Self.XMax:= Extents.Xmax;
    Self.YMax:= Extents.Ymax;
  Finally
    BadList.Free;
    Screen.Cursor:= OldCursor;
  end;
  FActive:= true;
end;

procedure TEzDGNFile.Close;
begin
  if not FActive then Exit;
  FOffsets.Clear;
  If Assigned( FDGNInputStream ) then
    FreeAndNil( FDGNInputStream );
  FElements.Clear;
  FActive:= False;
end;

Function TEzDGNFile.GetElement( n: Integer;
  Var element_type, element_level, PlanOfEle: Integer;
  Var element_str: string; Var _3Dz: Double ): TEzEntity ;
Var
  Elm_hdr: TElm_hdr; // Head
  Disp_hdr: TDisp_hdr; // Display Head
  si: Smallint;
  b: Byte;
  wrd: Word;
  l: Longint;
  byte8: Double;

  primary, secondary: Double;
  origin: TEzPoint;
  EllipRec: TEzRect;
  Startang, sweepang: double;

  lngthmult, hgntmult, rotation: double;
  RadRotation: Double;
  str: Array[0..255] Of Char;

  curPen: TEzPenStyle;
  curPenScale: Double;
  curbrush: TEzBrushStyle;

  i: integer;
  P2D: TDGNPoint2D;
  P3D: TDGNPoint3D;

  Fp: TEzPoint;
  line1, line2: TEzPoint;

  TextEntityHeight: Double;
  TextEntityPoint: TEzPoint;

  MinX: double;
  Miny: double;
  MaxX: double;
  Maxy: double;
  nSweepVal: Integer;
  EntityCreated: Boolean;
  TmpClass: TEzEntityClass;
  TextWidth: Double;

  Function CompareBoundary( Const p: TEzPoint ): TEzPoint;
  Begin
    If p.x < minx Then
      minx := p.x;
    If p.y < miny Then
      miny := p.y;
    If p.x > maxx Then
      maxx := p.x;
    If p.y > maxy Then
      maxy := p.y;

    Result:= p;

    If Assigned( FOnConvertPoint ) then
      FOnConvertPoint( Self, Result );
  End;

  Function GetRect2DFromEllip( Const primary, secondary: double;
    Const origin: TEzPoint ): TEzRect;
  Var
    tmpRect: TEzRect;
  Begin
    tmpRect.Emin.X := origin.X - primary;
    tmpRect.Emax.X := origin.X + primary;
    tmpRect.Emin.Y := origin.Y - secondary;
    tmpRect.Emax.Y := origin.Y + secondary;

    Result := tmpRect;
  End;

Begin
  Result:= Nil;
  curPenScale := 1;
  If FMemoryLoaded And ( n >= 0 ) And ( n <= FElements.Count - 1) then
  begin
    TmpClass := GetClassFromID( FElements[ n ].EntityID );
    Result := TmpClass.Create( 1 );
    Result.Assign( FElements[ n ] );
    Exit;
  end;

  // don't move from here
  If (FDGNInputStream = Nil) Or (FOffsets.Count = 0) Or (n < 0) or (n > FOffsets.Count - 1) then Exit;

  FDGNInputStream.Seek( FOffsets[n], soFromBeginning );

  FDGNInputStream.Read( Elm_hdr, SizeOf( Elm_Hdr ) );

  element_Type := Elm_hdr.TypeDeleted And $7F;
  element_level := Elm_Hdr.LevelCmplx AND $3F;

  { the element is supposed not to be deleted because it was already checked
    in Open method }

  element_str := '';
  PlanOfEle := 2;
  _3Dz := 0.0;

  MinX := 1E+10;
  Miny := 1E+10;
  MaxX := -1E+10;
  Maxy := -1E+10;

  EntityCreated:= False;

  Result := Nil;
  Case element_Type Of
    3: { Line }
      Begin
        FDGNInputStream.Read( Disp_hdr, SizeOf( Disp_Hdr ) );
        EvaluateDisp_Hdr( Disp_Hdr, curPen, curPenScale, curbrush );
        If ( Disp_Hdr.props And $2000 ) = 0 Then
          PlanOfEle := 2
        Else
          PlanOfEle := 3;
        //
        If FDGN_TCB.Dimension = 2 Then
        Begin
          FDGNInputStream.Read( P2D, SizeOf( P2D ) );
          line1.X := LSwap( p2d.X );
          line1.Y := LSwap( p2d.Y );
          line1.X := line1.X * FScale;
          line1.Y := line1.Y * FScale;
          FDGNInputStream.Read( P2D, SizeOf( P2D ) );
          line2.X := LSwap( p2d.X );
          line2.Y := LSwap( p2d.Y );
          line2.X := line2.X * FScale;
          line2.Y := line2.Y * FScale;
        End
        Else If FDGN_TCB.Dimension = 3 Then
        Begin
          FDGNInputStream.Read( P3D, SizeOf( P3D ) );
          line1.X := LSwap( p3d.X );
          line1.Y := LSwap( p3d.Y );
          line1.X := line1.X * FScale;
          line1.Y := line1.Y * FScale;
          FDGNInputStream.Read( P3D, SizeOf( P3D ) );
          line2.X := LSwap( p3d.X );
          line2.Y := LSwap( p3d.Y );
          line2.X := line2.X * FScale;
          line2.Y := line2.Y * FScale;
        End
        Else
          Exit;

        If ( ( line1.X = line2.X ) And ( line1.Y = line2.Y ) ) Then
        Begin
          element_str := 'Line(Equal Start and End)';
          line1 := CompareBoundary( line1 );
          Result := TEzPointEntity.CreateEntity( line1, curpen.Color );
          EntityCreated := True;
          //cursymbol := Ez_Preferences.DefSymbolStyle.FSymbolStyle;
          //TEzPointEntity( Result ).Color := curpen.Color;
        End
        Else
        Begin
          // line
          element_str := 'Line';
          line1 := CompareBoundary( line1 );
          line2 := CompareBoundary( line2 );
          Result := TEzPolyLine.CreateEntity( [line1, line2] );
          TEzPolyLine(Result).PenTool.Scale := curPenScale;
          EntityCreated := True;
        End;
      End; { end of case 3 }

    4, 6, 11, 21: { Line string, Shape, Curve, B-spline Pole Element }
      Begin
        FDGNInputStream.Read( Disp_hdr, SizeOf( Disp_Hdr ) );
        EvaluateDisp_Hdr( Disp_Hdr, curPen, curPenScale, curbrush );
        If ( Disp_Hdr.props And $2000 ) = 0 Then {Check for Planar, ∆Ú∏È¿Œ∞°? 0 = ∆Ú∏È, 1 = ∫Ò∆Ú∏È }
          PlanOfEle := 2
        Else
          PlanOfEle := 3;

        FDGNInputStream.Read( si, SizeOf( si ) );

        Case element_Type Of
          4:
            Begin
              element_str := 'Line String';
              Result := TEzPolyLine.Create( si );
              TEzPolyLine(Result).PenTool.Scale := curPenScale;
              EntityCreated := True;
            End;
          6:
            Begin
              element_str := 'Shape';
              Result := TEzPolygon.Create( si );
              TEzPolygon(Result).PenTool.Scale := curPenScale;
              EntityCreated := True;
            End;
          11:
            Begin
              element_str := 'Curve';
              // Result := TSpline2D.Create(si);
              Result := TEzPolyLine.Create( si );
              TEzPolyLine(Result).PenTool.Scale := curPenScale;
              EntityCreated := True;
            End;
          21:
            Begin
              element_str := 'B-spline Pole';
              Result := TEzSpline.Create( si );
              TEzSpline(Result).PenTool.Scale := curPenScale;
              EntityCreated := True;
            End;

        End;

        For i := 1 To si Do {Number of vertices}
        Begin
          If FDGN_TCB.Dimension = 2 Then
          Begin
            FDGNInputStream.Read( p2d, SizeOf( p2d ) );
            Fp.X := LSwap( P2D.X );
            Fp.Y := LSwap( P2D.Y );
          End
          Else If FDGN_TCB.Dimension = 3 Then
          Begin
            FDGNInputStream.Read( p3d, SizeOf( p3d ) );
            Fp.X := LSwap( P3D.X );
            Fp.Y := LSwap( P3D.Y );
          End
          Else
            Exit;

          Fp.X := Fp.X * FScale;
          Fp.Y := Fp.Y * FScale;

          If element_Type = 11 Then
          Begin
            If (i=1) Or (i=2) Or (i=si-1) Or (i=si) Then
              Continue;
          End;

          Fp := Compareboundary( Fp );
          Result.Points.Add( Fp );
        End; { end of for i }
      End; { end of case 4, 6, 11, 21 }

    7: //Text Node Header,  Ignoring causes no harm
      Begin
        FDGNInputStream.Read( Disp_hdr, SizeOf( Disp_Hdr ) );
        EvaluateDisp_Hdr( Disp_Hdr, curPen, curPenScale, curbrush );
        If ( Disp_Hdr.props And $2000 ) = 0 Then //Check for Planar, ∆Ú∏È¿Œ∞°? 0 = ∆Ú∏È, 1 = ∫Ò∆Ú∏È
          PlanOfEle := 2
        Else
          PlanOfEle := 3;

        //
        FDGNInputStream.Read( wrd, SizeOf( wrd ) );
        //NextEleOfNode := p + SizeOf( Elm_hdr ) + SizeOf( Disp_hdr ) + 1 + ( wrd * SizeOf( Word ) );

        FDGNInputStream.Read( wrd, SizeOf( wrd ) );

        FDGNInputStream.Read( wrd, SizeOf( wrd ) );

        FDGNInputStream.Read( b, SizeOf( b ) );

        FDGNInputStream.Read( b, SizeOf( b ) );

        FDGNInputStream.Read( b, SizeOf( b ) );

        FDGNInputStream.Read( b, SizeOf( b ) );

        FDGNInputStream.Read( l, SizeOf( l ) );
        //NodeLineSpc := lswap( l ) * FScale;

        {
                      FDGNInputStream.Read(l, SizeOf(l));
                      lngthmult := abs(LSwap(l) * FScale);

                      FDGNInputStream.Read(l, SizeOf(l));
                      hgntmult := abs(LSwap(l) * FScale);

                      FDGNInputStream.Read(l, SizeOf(l)) <> SizeOf(l);
                      rotation := DegToRad(LSwap(l) / 360000);

                      FDGNInputStream.Read(p2d, SizeOf(p2d));
                      Fp.X := LSwap(P2D.X);
                      Fp.Y := LSwap(P2D.Y);
                      Fp.X := Fp.X * FScale;
                      Fp.Y := Fp.Y * FScale;

                      TextEntityHeight := hgntmult * HeightQuotient;

                      TextEntityPoint.X := Fp.X;
                      TextEntityPoint.Y := Fp.Y + TextEntityHeight;

                      TextEntityPoint:=Compareboundary(TextEntityPoint);

                      Result := TText2D.CreateEntity(nil, TextEntityPoint, str, TextEntityHeight, rotation);
                      TText2d(Result).FontColor := curpen.Color;
        //                  EntityCreated := True;
                    }
      End; // end of case 7

    17:
      Begin
        element_str := 'Text';
        rotation := 0;
        FDGNInputStream.Read( Disp_hdr, SizeOf( Disp_Hdr ) );
        EvaluateDisp_Hdr( Disp_Hdr, curPen, curPenScale, curbrush );
        If ( Disp_Hdr.props And $2000 ) = 0 Then { Check for Planar }
          PlanOfEle := 2
        Else
          PlanOfEle := 3;

        {  }
        FDGNInputStream.Read( b, SizeOf( b ) );

        { }
        FDGNInputStream.Read( b, SizeOf( b ) );
        {align := b;
        Case b Of
          0, 1, 2: TextAlign := taLeftJustify;
          6, 7, 8: TextAlign := taCenter;
          12, 13, 14: TextAlign := taRightJustify;
        End; }

        FDGNInputStream.Read( l, SizeOf( l ) );
        lngthmult := LSwap( l ) * FScale;
        FDGNInputStream.Read( l, SizeOf( l ) );
        hgntmult := LSwap( l ) * FScale;

        If FDGN_TCB.Dimension = 2 Then
        Begin
          FDGNInputStream.Read( l, SizeOf( l ) );
          rotation := LSwap( l ) / 360000;

          FDGNInputStream.Read( p2d, SizeOf( p2d ) );
          Fp.X := LSwap( P2D.X );
          Fp.Y := LSwap( P2D.Y );
          Fp.X := Fp.X * FScale;
          Fp.Y := Fp.Y * FScale;
        End
        Else If FDGN_TCB.Dimension = 3 Then
        Begin
          FDGNInputStream.Read( l, SizeOf( l ) );
          FDGNInputStream.Read( l, SizeOf( l ) );
          FDGNInputStream.Read( l, SizeOf( l ) );
          FDGNInputStream.Read( l, SizeOf( l ) );
          FDGNInputStream.Read( p3d, SizeOf( p3d ) );
          Fp.X := LSwap( P3D.X );
          Fp.Y := LSwap( P3D.Y );
          _3Dz := LSwap( P3D.Z );
          Fp.X := Fp.X * FScale;
          Fp.Y := Fp.Y * FScale;
          _3Dz := _3Dz * FScale;
        End
        Else
          Exit;

        str := '';
        FDGNInputStream.Read( b, SizeOf( b ) );
        If b <> 0 Then
        Begin
          FDGNInputStream.Position := FDGNInputStream.Position + 1;

          For l := 0 To b Do
            FDGNInputStream.Read( str[l], SizeOf( Byte ) );
          str[b] := #0;

          TextEntityHeight := hgntmult * FHeightQuotient;
          TextWidth := lngthmult * FHeightQuotient;

          TextEntityPoint.X := Fp.X;
          TextEntityPoint.Y := Fp.Y + TextEntityHeight;
          TextEntityPoint := Compareboundary( TextEntityPoint );

          {                  if p < NextEleOfNode then
                            TextEntityHeight := TextEntityHeight + NodeLineSpc
                          else
                            TextEntityHeight := TextEntityHeight + TextEntityHeight * 0.35;
          }

          rotation := ( Trunc( rotation * 100 ) Mod 36000 ) / 100;
          RadRotation := DegToRad( rotation );

          If ( rotation = 0 ) Then
          Else If ( rotation > 0 ) And ( rotation < 90 ) Then
          Begin
            TextEntityPoint.X := TextEntityPoint.X - Sin( RadRotation ) * TextEntityHeight;
            TextEntityPoint.Y := TextEntityPoint.Y - ( 1 - Cos( RadRotation ) ) * TextEntityHeight;
          End
          Else If ( rotation = 90 ) Then
          Begin
            TextEntityPoint.X := TextEntityPoint.X - TextEntityHeight;
            TextEntityPoint.Y := TextEntityPoint.Y - TextEntityHeight;
          End
          Else If ( rotation > 90 ) And ( rotation < 180 ) Then
          Begin
            TextEntityPoint.X := TextEntityPoint.X - Cos( RadRotation - PI / 2 ) * TextEntityHeight;
            TextEntityPoint.Y := TextEntityPoint.Y - TextEntityHeight;
            TextEntityPoint.Y := TextEntityPoint.Y - Sin( RadRotation - PI / 2 ) * TextEntityHeight;
          End
          Else If ( rotation = 180 ) Then
          Begin
            TextEntityPoint.Y := TextEntityPoint.Y - TextEntityHeight * 2;
          End
          Else If ( rotation > 180 ) And ( rotation < 270 ) Then
          Begin
            TextEntityPoint.X := TextEntityPoint.X + Sin( RadRotation - PI ) * TextEntityHeight;
            TextEntityPoint.Y := TextEntityPoint.Y - TextEntityHeight;
            TextEntityPoint.Y := TextEntityPoint.Y - Cos( RadRotation - PI ) * TextEntityHeight;
          End
          Else If ( rotation = 270 ) Then
          Begin
            TextEntityPoint.X := TextEntityPoint.X + TextEntityHeight;
            TextEntityPoint.Y := TextEntityPoint.Y - TextEntityHeight;
          End
          Else If ( rotation > 270 ) And ( rotation < 360 ) Then
          Begin
            TextEntityPoint.X := TextEntityPoint.X + Cos( RadRotation - PI * ( 3 / 2 ) ) * TextEntityHeight;
            TextEntityPoint.Y := TextEntityPoint.Y - TextEntityHeight;
            TextEntityPoint.Y := TextEntityPoint.Y + Sin( RadRotation - PI * ( 3 / 2 ) ) * TextEntityHeight;
          End;

          TextEntityPoint := CompareBoundary( TextEntityPoint );

          If FUseTrueType Then
          Begin
            Result := TEzTrueTypeText.CreateEntity( TextEntityPoint, str,
              TextEntityHeight, RadRotation );
            with TEzTrueTypeText( Result ) do
            begin
              BeginUpdate;
              PenTool.style := 0;
              BrushTool.pattern := 0;
              Fonttool.Assign(Ez_Preferences.DefTTFontStyle);
              Fonttool.Height:= TextEntityHeight;
              Fonttool.Color := curpen.color;
              Fonttool.Angle:= RadRotation;
              EndUpdate;
            end;
          End Else
          Begin
            Result := TEzFittedVectorText.CreateEntity(
              TextEntityPoint, str, TextEntityHeight, TextWidth, RadRotation );

            {                 Result.FBox.Emin.X := lswap(Elm_hdr.xLow);
                              Result.FBox.Emin.Y := lswap(Elm_hdr.yLow);
                              Result.FBox.Emax.X := lswap(Elm_hdr.xHigh);
                              Result.FBox.Emax.Y := lswap(Elm_hdr.yHigh);
            }

            TEzJustifVectorText( Result ).FontColor := curpen.Color;
            //TEzJustifVectorText(Result).Alignment := TextAlign;
            TEzJustifVectorText( Result ).FontName := Ez_VectorFonts.DefaultFont.Name; //'Courier New';
          End;
          EntityCreated := True;
        End;
      End; { end of case 17 }
    15:
      Begin
        element_str := 'Ellipse';
        FDGNInputStream.Read( Disp_hdr, SizeOf( Disp_Hdr ) );
        EvaluateDisp_Hdr( Disp_Hdr, curPen, curPenScale, curbrush );
        If ( Disp_Hdr.props And $2000 ) = 0 Then {Check for Planar, ∆Ú∏È¿Œ∞°? 0 = ∆Ú∏È, 1 = ∫Ò∆Ú∏È }
          PlanOfEle := 2
        Else
          PlanOfEle := 3;

        FDGNInputStream.Read( byte8, SizeOf( byte8 ) );
        vax2ieee( @Byte8 );
        primary := Byte8 * FScale;

        FDGNInputStream.Read( byte8, SizeOf( byte8 ) );
        vax2ieee( @Byte8 );
        secondary := Byte8 * FScale;

        If FDGN_TCB.Dimension = 2 Then
        Begin
          FDGNInputStream.Read( l, SizeOf( l ) );
          //rotation := DegToRad(LSwap(l) / 360000);
          // ø¯¡°
          FDGNInputStream.Read( Byte8, SizeOf( Byte8 ) );
          vax2ieee( @Byte8 );
          origin.X := Byte8 * FScale;
          FDGNInputStream.Read( Byte8, SizeOf( Byte8 ) );
          vax2ieee( @Byte8 );
          origin.Y := Byte8 * FScale;
        End
        Else If FDGN_TCB.Dimension = 3 Then
        Begin
          // ªÁ∫–∏È »∏¿¸
          FDGNInputStream.Read( l, SizeOf( l ) );
          FDGNInputStream.Read( l, SizeOf( l ) );
          FDGNInputStream.Read( l, SizeOf( l ) );
          FDGNInputStream.Read( l, SizeOf( l ) );

          //
          FDGNInputStream.Read( Byte8, SizeOf( Byte8 ) );
          vax2ieee( @Byte8 );
          origin.X := Byte8 * FScale;
          FDGNInputStream.Read( Byte8, SizeOf( Byte8 ) );
          vax2ieee( @Byte8 );
          origin.Y := Byte8 * FScale;
          FDGNInputStream.Read( Byte8, SizeOf( Byte8 ) );
          vax2ieee( @Byte8 );
          _3Dz := Byte8 * FScale;
        End
        Else
          Exit;

        EllipRec := GetRect2DFromEllip( primary, secondary, origin );
        EllipRec.Emin := CompareBoundary( EllipRec.Emin );
        EllipRec.Emax := CompareBoundary( EllipRec.Emax );
        Result := TEzEllipse.CreateEntity( EllipRec.Emin, EllipRec.Emax );
        TEzEllipse(Result).PenTool.Scale := curPenScale;
        EntityCreated := True;
      End;
    16:
      Begin
        element_str := 'Arc';
        FDGNInputStream.Read( Disp_hdr, SizeOf( Disp_Hdr ) );
        EvaluateDisp_Hdr( Disp_Hdr, curPen, curPenScale, curbrush );
        If ( Disp_Hdr.props And $2000 ) = 0 Then {Check for Planar, ∆Ú∏È¿Œ∞°? 0 = ∆Ú∏È, 1 = ∫Ò∆Ú∏È }
          PlanOfEle := 2
        Else
          PlanOfEle := 3;

        //
        FDGNInputStream.Read( l, SizeOf( l ) );

        Startang := DegToRad( LSwap( l ) / 360000 );

        FDGNInputStream.Read( l, SizeOf( l ) );

        //sweepang := DegToRad( LSwap( l ) / 360000 );
        if (TLA(l)[2] And $80) <> 0 then
        begin
          TLA(l)[2] := TLA(l)[2] And $7F;
          nSweepVal := -1 * LSwap( l );
        end
        else
        begin
          nSweepVal := LSwap( l );
        end;

        if nSweepVal = 0 then
          sweepang := 360.0
        else
          sweepang := nSweepVal / 360000.0;

        sweepang := DegToRad( sweepang );

        //
        FDGNInputStream.Read( byte8, SizeOf( byte8 ) );
        vax2ieee( @Byte8 );
        primary := Byte8 * FScale;

        //
        FDGNInputStream.Read( byte8, SizeOf( byte8 ) );
        vax2ieee( @Byte8 );
        secondary := Byte8 * FScale;

        If FDGN_TCB.Dimension = 2 Then
        Begin
          //
          FDGNInputStream.Read( l, SizeOf( l ) );

          rotation := LSwap(l) / 360000.0;
          RadRotation := DegToRad( rotation );
          //
          FDGNInputStream.Read( Byte8, SizeOf( Byte8 ) );
          vax2ieee( @Byte8 );
          origin.X := Byte8 * FScale;
          FDGNInputStream.Read( Byte8, SizeOf( Byte8 ) );
          vax2ieee( @Byte8 );
          origin.Y := Byte8 * FScale;

          Startang := Startang + RadRotation;
        End
        Else If FDGN_TCB.Dimension = 3 Then
        Begin
          //
          FDGNInputStream.Read( l, SizeOf( l ) );
          FDGNInputStream.Read( l, SizeOf( l ) );
          FDGNInputStream.Read( l, SizeOf( l ) );
          FDGNInputStream.Read( l, SizeOf( l ) );

          // ø¯¡°
          FDGNInputStream.Read( Byte8, SizeOf( Byte8 ) );
          vax2ieee( @Byte8 );
          origin.X := Byte8 * FScale;
          FDGNInputStream.Read( Byte8, SizeOf( Byte8 ) );
          vax2ieee( @Byte8 );
          origin.Y := Byte8 * FScale;
          FDGNInputStream.Read( Byte8, SizeOf( Byte8 ) );
          vax2ieee( @Byte8 );
          _3Dz := Byte8 * FScale;
        End
        Else
          Exit;

        // circular arcs only
        If primary = secondary Then
        Begin
          EllipRec := GetRect2DFromEllip( primary, secondary, origin );
          EllipRec.Emin := CompareBoundary( EllipRec.Emin );
          EllipRec.Emax := CompareBoundary( EllipRec.Emax );
          origin := CompareBoundary( origin );

          Result := TEzArc.CreateEntity( Point2D( 0, 0 ), Point2D( 0, 0 ), Point2D( 0, 0 ) );
          TEzArc(Result).PenTool.Scale := curPenScale;
          TEzArc( Result ).SetArc( origin.X, origin.Y, primary, Startang, sweepang, true );

          EntityCreated := True;
        End;
      End;
  End; { end of case }

  If EntityCreated Then
  Begin
    If Result.Points.Count > 0 Then
    Begin
      If Result.EntityID In [idPolyline,idPolygon,idRectangle,idArc,idEllipse,idSpline,idSplineText] Then
      Begin
        If Result Is TEzOpenedEntity Then
        begin
          TEzOpenedEntity( Result ).Pentool.FPenstyle := curPen;
          TEzOpenedEntity( Result ).Pentool.Scale := curPenScale;
        end;
        If Result Is TEzClosedEntity Then
        begin
          TEzClosedEntity( Result ).Brushtool.FBrushStyle := curbrush;
          TEzClosedEntity( Result ).Pentool.Scale := curPenScale;
        end;
      End;

    End;
  End;

End;

function TEzDGNFile.GetRecordCount: Integer;
begin
  If FMemoryLoaded then
    Result:= FElements.Count
  else
    Result:= FOffsets.Count;
end;

function TEzDGNFile.GetIncludedLevels(Index: Integer): Boolean;
begin
  Result:= False;
  If (Index < 0) Or (Index > 63) then Exit;
  Result:= FIncludedLevels[Index];
end;

procedure TEzDGNFile.SetIncludedLevels(Index: Integer;
  const Value: Boolean);
begin
  If (Index < 0) Or (Index > 63) then Exit;
  FIncludedLevels[Index]:= Value;
end;



Type

  {-----------------------------------------------------------------------------}
  //                    a bookmark for DGN layers
  {-----------------------------------------------------------------------------}

  TEzDGNBookmark = class
  private
    FRecno: Integer;
    FFiltered: Boolean;
    FEofCrack: Boolean;
    FFilterRecno: Integer;
    Fol: TIntegerList;
  Public
    constructor Create;
    destructor Destroy; Override;
  end;


{ TEzDGNBookmark }

constructor TEzDGNBookmark.Create;
begin
  inherited Create;
  Fol:= TIntegerList.Create;
end;

destructor TEzDGNBookmark.Destroy;
begin
  Fol.Free;
  inherited Destroy;
end;


{-------------------------------------------------------------------------------}
{                  TDGNLayerInfo - class implementation                    }
{-------------------------------------------------------------------------------}

Function TDGNLayerInfo.GetIsCosmethic: boolean;
Begin
  result := TDGNLayer( FLayer ).FHeader.IsMemoryLayer;
End;

Procedure TDGNLayerInfo.SetIsCosmethic( value: boolean );
Begin
  If TDGNLayer( FLayer ).FHeader.IsMemoryLayer = value Then Exit;
  TDGNLayer( FLayer ).FHeader.IsMemoryLayer := value;
End;

Function TDGNLayerInfo.GetLocked: Boolean;
Begin
  result := TDGNLayer( FLayer ).FHeader.Locked;
End;

Procedure TDGNLayerInfo.SetLocked( Value: Boolean );
Begin
  TDGNLayer( FLayer ).FHeader.Locked := Value;
End;

Function TDGNLayerInfo.GetUseAttachedDB: boolean;
Begin
  result := TDGNLayer( FLayer ).FHeader.UseAttachedDB;
End;

Procedure TDGNLayerInfo.SetUseAttachedDB( Value: boolean );
Begin
  TDGNLayer( FLayer ).FHeader.UseAttachedDB := Value;
  SetModifiedStatus( FLayer );
End;

Function TDGNLayerInfo.GetVisible: boolean;
Begin
  result := TDGNLayer( FLayer ).FHeader.Visible;
End;

Procedure TDGNLayerInfo.SetVisible( Value: boolean );
Begin
  If TDGNLayer( FLayer ).FHeader.Visible = Value Then Exit;
  TDGNLayer( FLayer ).FHeader.Visible := Value;
  If Assigned( FLayer.Layers.GIS.OnVisibleLayerChange ) Then
    FLayer.Layers.GIS.OnVisibleLayerChange( Self, FLayer.Name );
  SetModifiedStatus( FLayer );
End;

Function TDGNLayerInfo.GetOverlappedTextAction: TEzOverlappedTextAction;
Begin
  result := TDGNLayer( FLayer ).FHeader.OverlappedTextAction;
End;

Procedure TDGNLayerInfo.SetOverlappedTextAction( Value: TEzOverlappedTextAction );
Begin
  If TDGNLayer( FLayer ).FHeader.OverlappedTextAction = Value Then Exit;
  TDGNLayer( FLayer ).FHeader.OverlappedTextAction := Value;
  SetModifiedStatus( FLayer );
End;

Function TDGNLayerInfo.GetOverlappedTextColor: TColor;
Begin
  result := TDGNLayer( FLayer ).FHeader.OverlappedTextColor;
End;

Procedure TDGNLayerInfo.SetOverlappedTextColor( Value: TColor );
Begin
  If TDGNLayer( FLayer ).FHeader.OverlappedTextColor = Value Then Exit;
  TDGNLayer( FLayer ).FHeader.OverlappedTextColor := Value;
  SetModifiedStatus( FLayer );
End;

Function TDGNLayerInfo.GetTextHasShadow: boolean;
Begin
  result := TDGNLayer( FLayer ).FHeader.TextHasShadow;
End;

Procedure TDGNLayerInfo.SetTextHasShadow( Value: boolean );
Begin
  If TDGNLayer( FLayer ).FHeader.TextHasShadow = Value Then Exit;
  TDGNLayer( FLayer ).FHeader.TextHasShadow := Value;
  SetModifiedStatus( FLayer );
End;

Function TDGNLayerInfo.GetTextFixedSize: Byte;
Begin
  result := TDGNLayer( FLayer ).FHeader.TextFixedSize;
End;

Procedure TDGNLayerInfo.SetTextFixedSize( Value: Byte );
Begin
  If TDGNLayer( FLayer ).FHeader.TextFixedSize = Value Then Exit;
  TDGNLayer( FLayer ).FHeader.TextFixedSize := Value;
  SetModifiedStatus( FLayer );
End;

Function TDGNLayerInfo.GetSelectable: boolean;
Begin
  result := TDGNLayer( FLayer ).FHeader.Selectable;
End;

Procedure TDGNLayerInfo.SetSelectable( Value: boolean );
Begin
  If TDGNLayer( FLayer ).FHeader.Selectable = Value Then Exit;
  TDGNLayer( FLayer ).FHeader.Selectable := Value;
  If Assigned( FLayer.Layers.GIS.OnSelectableLayerChange ) Then
    FLayer.Layers.GIS.OnSelectableLayerChange( Self, FLayer.Name );
  SetModifiedStatus( FLayer );
End;

Function TDGNLayerInfo.GetExtension: TEzRect;
Begin
  result := TDGNLayer( FLayer ).FHeader.Extension;
End;

Procedure TDGNLayerInfo.SetExtension( Const Value: TEzRect );
Begin
  If EqualRect2D( Value, TDGNLayer( FLayer ).FHeader.Extension ) Then Exit;
  TDGNLayer( FLayer ).FHeader.Extension := Value;
  SetModifiedStatus( FLayer );
End;

Function TDGNLayerInfo.GetIDCounter: integer;
Begin
  result := TDGNLayer( FLayer ).FHeader.IDCounter;
End;

Procedure TDGNLayerInfo.SetIDCounter( Value: integer );
Begin
  If TDGNLayer( FLayer ).FHeader.IDCounter = Value Then Exit;
  TDGNLayer( FLayer ).FHeader.IDCounter := Value;
  SetModifiedStatus( FLayer );
End;

Function TDGNLayerInfo.GetIsAnimationLayer: boolean;
Begin
  result := TDGNLayer( FLayer ).FHeader.IsAnimationLayer;
End;

Procedure TDGNLayerInfo.SetIsAnimationLayer( Value: boolean );
Begin
  If TDGNLayer( FLayer ).FHeader.IsAnimationLayer = Value Then Exit;
  TDGNLayer( FLayer ).FHeader.IsAnimationLayer := Value;
  SetModifiedStatus( FLayer );
End;

Function TDGNLayerInfo.GetCoordSystem: TEzCoordSystem;
Begin
  result := TDGNLayer( FLayer ).FHeader.CoordSystem;
End;

Procedure TDGNLayerInfo.SetCoordSystem( Value: TEzCoordSystem );
Begin
  If TDGNLayer( FLayer ).FHeader.CoordSystem = Value Then Exit;
  With TDGNLayer( FLayer ) Do
  Begin
    FHeader.CoordSystem := Value;
    If Value = csLatLon Then
    Begin
      CoordMultiplier := DEG_MULTIPLIER;
      FHeader.coordsunits := cuDeg;
    End
    Else
      CoordMultiplier := 1;
  End;
  SetModifiedStatus( FLayer );
End;

Function TDGNLayerInfo.GetCoordsUnits: TEzCoordsUnits;
Begin
  result := TDGNLayer( FLayer ).FHeader.CoordsUnits;
End;

Procedure TDGNLayerInfo.SetCoordsUnits( Value: TEzCoordsUnits );
Begin
  With TDGNLayer( FLayer ) Do
  Begin
    If FHeader.coordsunits = value Then Exit;

    If FHeader.CoordSystem = csLatLon Then
      FHeader.CoordsUnits := cuDeg
    Else
      FHeader.CoordsUnits := Value;
  End;
  SetModifiedStatus( FLayer );
End;

Function TDGNLayerInfo.GetIsIndexed: boolean;
Begin
  With TDGNLayer( FLayer ) Do
    result := FHeader.IsIndexed And ( Frt <> Nil );
End;

Procedure TDGNLayerInfo.SetIsIndexed( Value: boolean );
Begin
  If TDGNLayer( FLayer ).FHeader.IsIndexed = Value Then Exit;
  TDGNLayer( FLayer ).FHeader.IsIndexed := Value;
  SetModifiedStatus( FLayer );
End;

{-------------------------------------------------------------------------------}
{                  TDGNLayer - class implementation                            }
{-------------------------------------------------------------------------------}

Constructor TDGNLayer.Create( Layers: TEzBaseLayers; Const AFileName: String );
Begin
  Inherited Create( Layers, AFileName );
  FLayerInfo := TDGNLayerInfo.Create( Self );
  FUpdateRtree := True;

  Self.FileName := ChangeFileExt( AFileName, '' );
  Self.Name := ExtractFileName( AFileName );
  With FHeader Do
  Begin
    HeaderID := 8003;
    VersionNumber := LAYER_VERSION_NUMBER;
    IDCounter := 0;
    Extension := INVALID_EXTENSION;
    Visible := True;
    Selectable := True;
    FillChar( Reserved, SizeOf( Reserved ), 0 );
  End;
  CoordMultiplier := 1;
End;

Destructor TDGNLayer.Destroy;
Begin
  Close;
  If ol <> Nil Then ol.free;
  // FLayerInfo is destroyed in the inherited class
  If Assigned( FDGNFile ) then
    FreeAndNil( FDGNFile );
  Inherited Destroy;
End;

Function TDGNLayer.GetDGNFile: TEzDGNFile;
Begin
  If FDGNFile = Nil then FDGNFile := TEzDGNFile.Create;
  Result:= FDGNFile ;
End;

Procedure TDGNLayer.InitializeOnCreate( Const FileName: String;
  AttachedDB, IsAnimation: Boolean; CoordSystem: TEzCoordSystem;
  CoordsUnits: TEzCoordsUnits; FieldList: TStrings );
Begin
  // for now, .shp files will not be created with this method
End;

function TDGNLayer.GetBookmark: Pointer;
var
  I: Integer;
  bmrk: TEzDGNBookmark;
begin
  bmrk:= TEzDGNBookmark.Create;
  bmrk.FRecno:= FRecno;
  bmrk.FFiltered:= FFiltered;
  bmrk.FEofCrack:= FEofCrack;
  bmrk.FFilterRecno:= FFilterRecno;
  if (ol <> nil) and (ol.Count > 0) then
  begin
    bmrk.Fol.Capacity:= ol.Count;
    for I:= 0 to ol.Count-1 do
      bmrk.Fol.Add( ol[I] );
  end;
  Result:= bmrk;
end;

procedure TDGNLayer.GotoBookmark(Bookmark: Pointer);
var
  I: Integer;
  bmrk: TEzDGNBookmark;
begin
  bmrk:= TEzDGNBookmark(Bookmark);
  FRecno:= bmrk.FRecno;
  FFiltered:= bmrk.FFiltered;
  FEofCrack:= bmrk.FEofCrack;
  FFilterRecno:= bmrk.FFilterRecno;
  if bmrk.Fol.Count > 0 then
  begin
    if ol = nil then ol := TIntegerList.Create;
    ol.Clear;
    ol.Capacity:= bmrk.Fol.Count;
    for I:= 0 to bmrk.Fol.Count-1 do
      ol.Add( bmrk.Fol[I] );
  end else if ol <> nil then
    ol.Clear;
end;

procedure TDGNLayer.FreeBookmark(Bookmark: Pointer);
begin
  TEzDGNBookmark(Bookmark).Free;
end;

Procedure TDGNLayer.GetFieldList( Strings: TStrings );
Var
  i: Integer;
Begin
  If DBTable <> Nil Then
    For i := 1 To DBTable.FieldCount Do
      Strings.Add( Format( '%s;%s;%d;%d', [DBTable.Field( I ), DBTable.FieldType( I ),
        DBTable.FieldLen( I ), DBTable.FieldDec( I )] ) );
End;

function TDGNLayer.GetFiltered: Boolean;
begin
  Result := False;
end;

Procedure TDGNLayer.StartBatchInsert;
Begin
  FUpdateRtree := False;
End;

Procedure TDGNLayer.FinishBatchInsert;
Begin
  FUpdateRtree := True;
  RebuildTree;
End;

Procedure TDGNLayer.Zap;
Begin
  // nothing to do here
End;

Function TDGNLayer.GetDBTable: TEzBaseTable;
Begin
  Result := FDBTable;
End;

Function TDGNLayer.GetRecno: Integer;
Begin
  If FFiltered Then
    Result := Longint( ol[FFilterRecno] )
  Else
    Result := FRecno;
End;

Procedure TDGNLayer.SetRecno( Value: Integer );
Begin
  If ( Value < 1 ) Or ( Value > FHeader.RecordCount ) Then
    EzGISError( SRecnoInvalid );
  FRecno := Value;
End;

Function TDGNLayer.SendEntityToBack( ARecno: Integer ): Integer;
Begin
  Result := 0;
  // nothing to do here
End;

Function TDGNLayer.BringEntityToFront( ARecno: Integer ): Integer;
Begin
  Result := 0;
  // nothing to do here
End;

Procedure TDGNLayer.SetGraphicFilter( s: TSearchType; Const VisualWindow: TEzRect );
Var
  treeBBox, viewBBox: TRect_rt;
Begin
  FFiltered := False;
  If Not FHeader.IsIndexed Then Exit;

  If ol = Nil Then
    ol := TIntegerList.Create
  Else
    ol.clear;
  treeBBox := Frt.RootExtent;
  viewBBox := FloatRect2Rect( VisualWindow );
  If Contains_rect( viewBBox, treeBBox ) Then
  Begin
    FreeAndNil( ol );
    Exit;
  End;
  Frt.Search( S, viewBBox, ol, DGNFile.RecordCount );
  //SortList(ol);
  FFiltered := True;
  FFilterRecno := -1;
End;

Procedure TDGNLayer.CancelFilter;
Begin
  If ol <> Nil Then FreeAndNil( ol );
  FFiltered := False;
End;

Function TDGNLayer.Eof: Boolean;
Begin
  result := FEofCrack;
End;

Procedure TDGNLayer.First;
Begin
  If FFiltered Then
  Begin
    If ol.Count > 0 Then
    Begin
      FFilterRecno := 0;
      FEofCrack := False;
    End
    Else
    Begin
      FEofCrack := True;
    End
  End
  Else If DGNFile.RecordCount > 0 Then
  Begin
    FRecno := 1;
    FEofCrack := False;
  End
  Else
  Begin
    FEofCrack := True;
  End;
End;

Procedure TDGNLayer.Next;
Var
  N: Integer;
Begin
  If FFiltered Then
  Begin
    N := ol.count;
    If N > 0 Then
    Begin
      If FFilterRecno < N - 1 Then
      Begin
        Inc( FFilterRecno );
        FEofCrack := False;
      End
      Else
      Begin
        FFilterRecno := N - 1;
        FEofCrack := True;
      End;
    End
    Else
    Begin
      FEofCrack := True;
    End
  End
  Else
  Begin
    N := DGNFile.RecordCount;
    If N > 0 Then
    Begin
      If FRecno < N Then
      Begin
        Inc( FRecno );
        FEofCrack := False;
      End
      Else
      Begin
        FRecno := N;
        FEofCrack := True;
      End;
    End
    Else
    Begin
      FEofCrack := True;
    End;
  End;
End;

Procedure TDGNLayer.Synchronize;
Begin
  If FDbTable <> Nil Then
    FDbTable.Recno := Self.Recno;
End;

Procedure TDGNLayer.Last;
Var
  N: Integer;
Begin
  If FFiltered Then
  Begin
    N := ol.count;
    If N > 0 Then
    Begin
      FFilterRecno := N - 1;
      FEofCrack := False;
    End
    Else
    Begin
      FEofCrack := True;
    End;
  End
  Else
  Begin
    N := DGNFile.RecordCount;
    If N > 0 Then
    Begin
      FRecno := N;
      FEofCrack := False;
    End
    Else
    Begin
      FEofCrack := True;
    End;
  End;
End;

Procedure TDGNLayer.StartBuffering;
Begin
End;

Procedure TDGNLayer.EndBuffering;
Begin
End;

Procedure TDGNLayer.Assign( Source: TEzBaseLayer );
Begin
End;

Procedure TDGNLayer.RebuildTree;
Var
  I, j, RecCount: Integer;
  GIS: TEzBaseGIS;
  TmpEntity: TEzEntity;
  element_type,element_level,PlanOfEle: integer;
  element_str: string;
  _3Dz: Double;
  StreamRtc : TFileStream;
  StreamRtx : TFileStream;
  IdxInfo: TRTCatalog;
  dp: PDiskPage;
  Mode: Word;
Begin
  If Layers.GIS.ReadOnly Or Not FHeader.IsIndexed Then Exit;
  ForceOpened;
  If Not Active Then Exit;
  RecCount := Self.RecordCount;
  If Frt <> Nil Then FreeAndNil( Frt );
  Frt := TMemRTree.Create( Self, RTYPE, fmCreate );
  // Create the index
  Frt.CreateIndex( '', CoordMultiplier );
  // Now add all the entities to the tree

  GIS := Layers.GIS;
  Mode := GIS.OpenMode;

  If RecCount > 0 Then
    GIS.StartProgress( Format( SRebuildTree, [Name] ), 1, RecCount );
  Try
    Try
      For I := 1 To RecCount Do
      Begin
        GIS.UpdateProgress( I );
        TmpEntity:= DGNFile.GetElement(I-1,element_type,element_level,PlanOfEle,element_str,_3Dz);
        If TmpEntity= Nil then Continue;
        Try
          Frt.Insert( FloatRect2Rect( TmpEntity.FBox ), I );
        Finally
          TmpEntity.Free;
        End;
      End;
      { now create the files based on the memory r-tree }
      StreamRtc := TFileStream.Create( FileName + RTCEXT, fmCreate );
      StreamRtx := TFileStream.Create( FileName + RTXEXT, fmCreate );
      Try
        FillChar( IdxInfo, sizeof( IdxInfo ), 0 );
        With IdxInfo Do
        Begin
          PageCount := TMemRTree( Frt ).PageCount;
          Depth := TMemRTree( Frt ).Depth;
          FreePageCount := 0;
          RootNode := ( TMemRTree( Frt ).RootId - 1 ) * sizeof( TDiskPage );
          Implementor := 1; // 1=luis, 2=Garry
          TreeType := ttRTree;
          PageSize := 1;
          Version := TREE_VERSION;
          Multiplier := CoordMultiplier;
          BucketSize := ezrtree.BUCKETSIZE;
          LowerBound := ezrtree.LOWERBOUND;
          LastUpdate := Now;
        End;

        StreamRtc.Write( IdxInfo, sizeof( IdxInfo ) );
        { now write all the pages }
        For I := 0 To IdxInfo.PageCount - 1 Do
        Begin
          dp := TMemRTree( Frt ).DiskPagePtr[I];
          If dp^.Parent <> -1 Then
            dp^.Parent := ( dp^.Parent - 1 ) * sizeof( TDiskPage );
          If Not dp^.Leaf Then
            For J := 0 To dp^.FullEntries - 1 Do
              dp^.Entries[J].Child := ( dp^.Entries[J].Child - 1 ) * sizeof( TDiskPage );
          StreamRtx.Write( dp^, sizeof( TDiskPage ) );
        End;
      Finally
        StreamRtc.free;
        StreamRtx.free;
      End;

      Frt.Free; // delete memory rtree
      Frt := TEzRTree.Create( Self, RTYPE, Mode ); // open the disk based r-tree
      Frt.Open( Self.FileName, Mode );

    Except
      On E: Exception Do
      Begin
        MessageToUser( E.message, smsgerror, MB_ICONERROR );
        Raise;
      End;
    End;
  Finally
    If RecCount > 0 Then
      GIS.EndProgress;
  End;
  If Not FHeader.Visible Then
    Frt.Close;
End;

{Procedure TDGNLayer.UpdateMapExtension( Const R: TEzRect );
Var
  MapExt: TEzRect;
Begin
  If ( Layers = Nil ) Or ( Layers.GIS = Nil ) Then Exit;
  With Layers.GIS Do
  Begin
    MapExt := MapInfo.Extension;
    MaxBound( MapExt.Emax, R.Emax );
    MinBound( MapExt.Emin, R.Emin );
    MapInfo.Extension := MapExt;
    Modified := True;
  End;
End; }

Procedure TDGNLayer.Open;
Var
  AFileName: String;
  Mode: Word;
  GIS: TEzBaseGIS;
Begin

  Close;
  If Not FHeader.Visible Then Exit;

  GIS := Layers.GIS;

  Mode := GIS.OpenMode;

  AFileName := FileName + '.EZG'; // DGN Info Header file
  If FileExists( AFileName ) Then
  Begin
    With TFileStream.Create( AFileName, fmOpenRead Or fmShareDenyNone ) Do
      Try
        Read( FHeader, sizeOf( TEzLayerHeader ) );
        Read( FDGNHeader, sizeOf( TEzDGNHeader ) );
      Finally
        Free;
      End;
  End;

  AFileName := FileName + '.DGN';
  If Not FileExists( AFileName ) Then Exit;

  Try
    DGNFile.FileName := AFileName;
    DGNFile.MemoryLoaded:= FDGNHeader.MemoryLoaded;
    DGNFile.UseDefaultColorTable:= FDGNHeader.UseDefaultColorTable;
    DGNFile.UseTrueType:= FDGNHeader.UseTrueType;
    Move( DGNFile.FIncludedLevels, FDGNHeader.IncludedLevels, SizeOf(DGNFile.FIncludedLevels ) );
    DGNFile.Open;
  Except
    On E: Exception Do
    Begin
      MessageToUser( E.Message, smsgerror, MB_ICONERROR );
      Raise;
    End;
  End;

  With FHeader Do  // DGN Info Header file
  Begin
    IsIndexed := True;
    RecordCount := DGNFile.RecordCount;
    If Layers.GIS.MapInfo.CoordSystem = csLatLon Then
      self.CoordMultiplier := DEG_MULTIPLIER
    Else
      self.CoordMultiplier := 1;
    //Extension := FShapeHeader.Extent;
    //UpdateMapExtension( FShapeHeader.Extent );
  End;

  { open the r-tree file }
  Frt := TEzRTree.Create( Self, RTYPE, Mode );
  If Not FileExists( Self.FileName + RTXEXT ) Or
    Not FileExists( Self.FileName + RTCEXT ) Then
    // create the index
    RebuildTree
      //rt.CreateIndex( self.FileName )
  Else
    Frt.Open( Self.FileName, Mode );

  If FHeader.UseAttachedDB Then
  Begin
    if BaseTableClass = Nil then
    begin
      FHeader.UseAttachedDB := False;
      Modified := True;
      EzGISError( SDBFNotFound );
    end;
    with EzBaseGis.BaseTableClass.CreateNoOpen( Layers.Gis ) do
      try
        if not DBTableExists( FileName ) then
        begin
          FHeader.UseAttachedDB := False;
          Modified := True;
          EzGISError( SDBFNotFound );
        end;
      finally
        free;
      end;

    FDBTable := EzBaseGis.BaseTableClass.Create( Gis, AFilename, Not GIS.ReadOnly, true );
    With FDBTable Do
    Begin
      SetUseDeleted( true );
      //Index( AFileName, '' );
    End;
  End;

End;

Procedure TDGNLayer.Close;
var
  Mode: Word;
  AFileName: string;
Begin
  If Not Layers.GIS.ReadOnly And Modified Then
  Begin
    AFileName := FileName + '.EZG';
    If Not FileExists( AFileName ) Then
      Mode := fmCreate
    Else
      Mode := fmOpenReadWrite Or fmShareDenyNone;
    With TFileStream.Create( AFilename, Mode ) Do
      Try
        Write( FHeader, sizeOf( TEzLayerHeader ) );
        Write( FDGNHeader, sizeOf( TEzDGNHeader ) );
      Finally
        Free;
      End;
  End;
  DGNFile.Close;
  // free the r-tree
  If Frt <> Nil Then
    FreeAndNil( Frt );
  If FDbTable <> Nil Then
    FreeAndNil( FDbTable );

  Modified := False;
End;

Function TDGNLayer.GetActive: Boolean;
Begin
  result := DGNFile.Active ;
End;

Procedure TDGNLayer.SetActive( Value: Boolean );
Begin
  If Value Then Open Else Close;
End;

Procedure TDGNLayer.ForceOpened;
Begin
  If Not DGNFile.Active Then Open;
End;

Procedure TDGNLayer.WriteHeaders( FlushFiles: boolean );
Var
  AFilename: String;
  Mode: Word;
Begin
  If Layers.GIS.ReadOnly Or Not DGNFile.Active Then
  Begin
    Modified := False;
    Exit;
  End;
  If Modified Then
  Begin
    AFileName := FileName + '.EZG';
    If Not FileExists( AFilename ) Then
      Mode := fmCreate
    Else
      Mode := fmOpenReadWrite Or fmShareDenyNone;
    With TFileStream.Create( AFilename, Mode ) Do
      Try
        Write( FHeader, sizeOf( TEzLayerHeader ) );
      Finally
        Free;
      End;
    //If FlushFiles Then
    //  Windows.FlushFileBuffers( TFileStream( FDGNStream ).Handle );
  End;
  If ( Frt <> Nil ) And FlushFiles Then Frt.FlushFiles;

  If ( FDbTable <> Nil ) And FlushFiles Then FDbTable.FlushDB;

  Modified := False;
End;

Function TDGNLayer.AddEntity( Entity: TEzEntity; Direct: Boolean = False ): Integer;
Begin
  Result:= 0;
  // nothing to do for now
End;

Procedure TDGNLayer.UndeleteEntity( RecNo: Integer );
Begin
  // nothing to do for now
End;

Procedure TDGNLayer.DeleteEntity( RecNo: Integer );
Begin
  // nothing to do for now
End;

Function TDGNLayer.QuickUpdateExtension: TEzRect;
Begin
  UpdateExtension;
End;

Function TDGNLayer.UpdateExtension: TEzRect;
Var
  I, RecCount: Integer;
  GIS: TEzBaseGIS;
  element_type, element_level, PlanOfEle: Integer;
  element_str: string;
  _3Dz: Double ;
  TmpEntity: TEzEntity;
Begin
  GIS := Layers.GIS;
  If Not DGNFile.Active Or GIS.ReadOnly Then Exit;
  ForceOpened;
  Result := INVALID_EXTENSION;
  RecCount := Self.RecordCount;
  If RecCount > 0 Then
    GIS.StartProgress( Format( SUpdateExtension, [Name] ), 1, RecCount );
  For I := 1 To RecCount Do
  Begin
    GIS.UpdateProgress( I );
    TmpEntity := DGNFile.GetElement( I-1, element_type, element_level,
      PlanOfEle, element_str, _3Dz );
    If TmpEntity = Nil then Continue;
    Try
      MaxBound( Result.Emax, TmpEntity.FBox.Emax );
      MinBound( Result.Emin, TmpEntity.FBox.Emin );
    Finally
      TmpEntity.Free;
    End;
  End;
  // rebuild the r-tree
  RebuildTree;
  If RecCount > 0 Then
    GIS.EndProgress;
  Modified := True;
  FHeader.Extension := Result;
  If AutoFlush Then
    WriteHeaders( True );
End;

Function TDGNLayer.LoadEntityWithRecNo( RecNo: Longint): TEzEntity;
var
  element_type, element_level, PlanOfEle: Integer;
  element_str: string;
  _3Dz: Double ;
Begin
  { RecNo is base 1 }
  Result := Nil;
  If ( RecNo < 1 ) Or ( RecNo > Self.RecordCount ) Then Exit;
  Result:= DGNFile.GetElement( Recno-1, element_type, element_level,
    PlanOfEle, element_str, _3Dz );
End;

Procedure TDGNLayer.UpdateEntity( RecNo: Integer; Entity2D: TEzEntity );
Begin
End;

Procedure TDGNLayer.Pack;
Begin
  // nothing to do
End;

Procedure TDGNLayer.Repair;
Begin
  // nothing to do
End;

Function TDGNLayer.RecExtension: TEzRect;
var
  TmpEntity: TEzEntity;
Begin
  TmpEntity:= RecLoadEntity;
  If TmpEntity = Nil Then
  Begin
    Result:= NULL_EXTENSION;
    Exit;
  End;
  Result:= TmpEntity.FBox;
  TmpEntity.Free;
End;

Function TDGNLayer.RecLoadEntity: TEzEntity;
Var
  N: Integer;
  element_type, element_level, PlanOfEle: Integer;
  element_str: string;
  _3Dz: Double ;
Begin
  If FFiltered Then
    N := Longint( ol[FFilterRecno] )
  Else
    N := FRecno;
  Result:= DGNFile.GetElement( N-1, element_type, element_level,
    PlanOfEle, element_str, _3Dz );
End;

Procedure TDGNLayer.RecLoadEntity2( Entity: TEzEntity );
Var
  TmpEntity: TEzEntity;
Begin
  TmpEntity:= RecLoadEntity;
  Entity.Assign( TmpEntity );
  TmpEntity.Free;
End;

Function TDGNLayer.RecEntityID: TEzEntityID;
var
  TmpEntity: TEzEntity;
Begin
  TmpEntity:= RecLoadEntity;
  Result:= TmpEntity.EntityID;
  TmpEntity.Free;
End;

Function TDGNLayer.RecIsDeleted: boolean;
Begin
  Result:= False; // no deleted entities
End;

Procedure TDGNLayer.CopyRecord( SourceRecno, DestRecno: Integer );
Begin
  // nothing to do here
End;

Function TDGNLayer.ContainsDeleted: boolean;
Begin
  Result := False;
End;

Procedure TDGNLayer.Recall;
Begin
  // nothing to do here
End;

Function TDGNLayer.GetRecordCount: Integer;
Begin
  result := DGNFile.RecordCount;
End;

Function TDGNLayer.DefineScope( Const Scope: String ): Boolean;
Var
  Solver: TEzMainExpr;
Begin
  result := False;
  CancelFilter;
  Solver := TEzMainExpr.Create( Layers.GIS, Self );
  Try
    { ol must be create after this because a call to one of the
      queryxxx expression could cause ol to be set to nil }
    Solver.ParseExpression( Scope );
    If Solver.Expression.ExprType <> ttBoolean Then
      Raise EExpression.Create( SExprFail );

    ol := TIntegerList.Create;

    First;
    While Not Eof Do
    Begin
      Try
        //If RecIsDeleted Then Continue;
        Self.Synchronize;
        If Not Solver.Expression.AsBoolean Then Continue;

        ol.Add( Recno );
      Finally
        Next;
      End;
    End;
    FFiltered := True;
    If ol.count > 0 Then
    Begin
      FFilterRecno := -1;
      { is a sorting defined ? }
      if Solver.OrderByCount > 0 then
      begin
        FFiltered := False;
        SortOrderList( Self, Solver, ol );
        FFiltered := True;
      end;
    End
    Else
    Begin
      FFiltered := False;
      FreeAndNil( ol );
    End;
  Finally
    Solver.Free;
  End;
End;

Function TDGNLayer.DefinePolygonScope( Polygon: TEzEntity; Const Scope: String;
  Operator: TEzGraphicOperator ): Boolean;
Var
  Solver: TEzMainExpr;
  Entity: TEzEntity;
  Pass: Boolean;
  SearchType: TSearchType;
  temp_ol: TIntegerList;
Begin
  Result := False;
  CancelFilter;
  temp_ol := TIntegerList.Create;
  Solver := Nil;
  If Length( Scope ) > 0 Then
    Solver := TEzMainExpr.Create( Layers.GIS, Self );
  Try
    If Solver <> Nil Then
    Begin
      Solver.ParseExpression( Scope );
      If Solver.Expression.ExprType <> ttBoolean Then
        Raise EExpression.Create( SExprFail );
    End;
    Case Operator Of
      goWithin, goContains, goIntersects:
        searchType := stOverlap;
      goEntirelyWithin, goContainsEntire:
        searchType := stEnclosure;
    Else
      searchType := stOverlap;
    End;
    SetGraphicFilter( searchType, Polygon.FBox );
    First;
    While Not Eof Do
    Begin
      Try
        //If RecIsDeleted Then Continue;
        Entity := RecLoadEntity;
        If Entity = Nil Then Continue;
        Try
          Pass := Entity.CompareAgainst( Polygon, Operator );
        Finally
          Entity.Free;
        End;
        If Pass Then
        Begin
          If Solver <> Nil Then
          Begin
            Self.Synchronize;
            If Not Solver.Expression.AsBoolean Then Continue;
          End;
          temp_ol.Add( Recno );
        End;
      Finally
        Next;
      End;
    End;
    CancelFilter;
    FFiltered := True;
    If temp_ol.count > 0 Then
    Begin
      FFilterRecno := -1;
      ol := temp_ol;
      Result := True;
      { is a sorting defined ? }
      if ( Solver <> Nil ) And ( Solver.OrderByCount > 0 ) then
      begin
        FFiltered := False;
        SortOrderList( Self, Solver, ol );
        FFiltered := True;
      end;
    End
    Else
    Begin
      FFiltered := False;
      FreeAndNil( temp_ol );
    End;
  Finally
    If Solver <> Nil Then
      Solver.Free;
  End;
End;

function TDGNLayer.GetExtensionForRecords(List: TIntegerList): TEzRect;
var
  I, TheRecno:Integer;
  TmpEntity: TEzEntity;
  element_type,element_level,PlanOfEle: integer;
  element_str: string;
  _3Dz: Double;
begin
  If Not DGNFile.Active then Exit;
  Result:= INVALID_EXTENSION;
  if (List=nil) or (List.Count=0) then Exit;
  for I:= 0 to List.Count-1 do
  begin
    TheRecno:= List[I];
    if (TheRecno < 1) or (TheRecno > RecordCount) then Continue;
    TmpEntity:= DGNFile.GetElement( TheRecno - 1,element_type,element_level,PlanOfEle,element_str,_3Dz);
    Try
      MaxBound(Result.Emax, TmpEntity.FBox.Emax);
      MinBound(Result.Emin, TmpEntity.FBox.Emin);
    FInally
      TmpEntity.Free;
    End;
  end;
end;



{ Original C++ code translation, implementation and export functionality by :
  Luis Rodrigo YaÒez Gutierrez }

Type

  DGNHandle = Pointer;

  PDGNElementInfo = ^DGNElementInfo;
  PDGNElementInfoArray = ^DGNElementInfoArray;
  PDGNTagDefArray = ^DGNTagDefArray;
  PDGNPointArray = ^DGNPointArray;
  PCharArray  = ^CharArray;
  PPaletteArray = ^TPaletteArray;

  DoubleArray = Array[0..65535] Of Double;
  CharArray = Array [0..65535] Of Char;


  PByte = ^Byte;
  PSmallInt = ^SmallInt;
  PInteger = ^Integer;
  PDouble = ^Double;
  PCardinal = ^Cardinal;

  PDGNInfo = ^DGNInfo;


  DGNInfo = Packed Record
    fp : TDGNFileStream;
    next_element_id : SmallInt;
    nElemBytes : SmallInt;
    abyElem : Array [0..131075] of Byte;
    got_tcb : SmallInt;
    dimension : SmallInt;
    options : SmallInt;
    scale : Double;
    origin_x : Double;
    origin_y : Double;
    origin_z : Double;
    index_built : SmallInt;
    element_count : SmallInt;
    max_element_count : SmallInt;
    element_index : PDGNElementInfoArray;
    got_color_table : SmallInt;
    color_table : TPaletteArray;
    got_bounds : SmallInt;

    min_x : Cardinal;
    min_y : Cardinal;
    min_z : Cardinal;
    max_x : Cardinal;
    max_y : Cardinal;
    max_z : Cardinal;

    has_spatial_filter : Boolean;
    sf_converted_to_uor : Boolean;
    select_complex_group : Boolean;
    in_complex_group : Boolean;

{    has_spatial_filter : SmallInt;
    sf_converted_to_uor : SmallInt;
    select_complex_group : SmallInt;
    in_complex_group : SmallInt;}

    sf_min_x : Cardinal;
    sf_min_y : Cardinal;
    sf_max_x : Cardinal;
    sf_max_y : Cardinal;

    sf_min_x_geo : Double;
    sf_min_y_geo : Double;
    sf_max_x_geo : Double;
    sf_max_y_geo : Double;
  End;

(**
 * Definitions of public structures and API of DGN Library.  *)

(**
 * DGN Point structure.
 *
 * Note that the DGNReadElement() function transforms points into "master"  * coordinate system space when they are in the file in UOR (units of  * resolution) coordinates.
 *)

  PDGNPoint = ^DGNPoint;
  DGNPoint = record
    x : Double;	  (*!< X (normally eastwards) coordinate. *)
    y : Double;   (*!< y (normally northwards) coordinate. *)
    z : Double;   (*!< z, up coordinate.  Zero for 2D objects. *)
  End;

  DGNPointArray = Array [0..65535] of DGNPoint;

(**
 * Element summary information.
 *
 * Minimal information kept about each element if an element summary
 * index is built for a file by DGNGetElementIndex().
 *)

 DGNElementInfo = Packed Record
    level  : Byte;   (*!< Element Level: 0-63 *)
    _type  : Byte;    (*!< Element type (DGNT_* ) *)
    stype  : Byte;   (*!< Structure type (DGNST_* ) *)
    offset : Longint;  (*!< Offset within file (private) *)
    flags  : Byte;   (*!< Other flags *)
  End;

 DGNElementInfoArray = Array [0..65535] Of DGNElementInfo;

(**
 * Core element structure.
 * Core information kept about each element that can be read from a DGN

 * file.  This structure is the first component of each specific element
 * structure (like DGNElemMultiPoint).  Normally the DGNElemCore.stype
 * field would be used to decide what specific structure type to case the
 * DGNElemCore pointer to.
 *
 *)
   PDGNElemCore = ^ DGNElemCore;
   DGNElemCore = Packed Record
    offset : SmallInt;
    size : SmallInt;
    element_id : SmallInt;     (*!< Element number (zero based ) *)
    stype : SmallInt;          (*!< Structure type: (DGNST_* ) *)
    level : SmallInt;		(*!< Element Level: 0-63 *)
    _type : SmallInt;		(*!< Element type (DGNT_) *)
    complex : SmallInt;	(*!< Is element complex? *)
    deleted : SmallInt;	(*!< Is element deleted? *)

    graphic_group : SmallInt;  (*!< Graphic group number *)
    properties : SmallInt;     (*!< Properties: ORing of DGNP_ flags *)
    color : SmallInt;          (*!< Color index (0-255) *)
    weight : SmallInt;         (*!< Line Weight (0-31) *)
    style : SmallInt;          (*!< Line Style: One of DGNS_* values *)

    attr_bytes : SmallInt;	(*!< Bytes of attribute data, usually zero. *)
    attr_data : PByteArray;   (*!< Raw attribute data *)

    raw_bytes : SmallInt;      (*!< Bytes of raw data, usually zero. *)
    raw_data : PByteArray;    (*!< All raw element data including header. *)
  End;

(**
 * Multipoint element
 *
 * The core.stype code is DGNST_MULTIPOINT.
 *
 * Used for: DGNT_LINE(3), DGNT_LINE_STRING(4), DGNT_SHAPE(6), DGNT_CURVE(11),
 * DGNT_BSPLINE(21)
 *)
  PDGNElemMultiPoint = ^DGNElemMultiPoint;
  DGNElemMultiPoint = Packed Record
    core : DGNElemCore;
    num_vertices : SmallInt;  (*!< Number of vertices in "vertices" *)
    vertices : PDGNPointArray;   (*!< Array of two or more vertices *)
  end;

(**
 * Ellipse element
 *
 * The core.stype code is DGNST_ARC.
 *
 * Used for: DGNT_ELLIPSE(15), DGNT_ARC(16)
 *)

  PDGNElemArc = ^DGNElemArc;
  DGNElemArc = Packed Record
    core : DGNElemCore;

    origin : DGNPoint;		(*!< Origin of ellipse *)

    primary_axis  : Double;	(*!< Primary axis length *)
    secondary_axis : Double; (*!< Secondary axis length *)

    rotation : Double;       (*!< Counterclockwise rotation in degrees *)
    quat : Array [0..3] of Longint;

    startang : Double;       (*!< Start angle (degrees counterclockwise of primary axis) *)
    sweepang : Double;       (*!< Sweep angle (degrees) *)
  End;

(**
 * Text element
 *
 * The core.stype code is DGNST_TEXT.
 *
 * NOTE: Currently we are not capturing the "editable fields" information.
 *
 * Used for: DGNT_TEXT(17).
 *)
  PDGNElemText = ^DGNElemText;
  DGNElemText = Packed Record
    core : DGNElemCore;
    font_id : SmallInt;       (*!< Microstation font id, no list available*)
    justification : SmallInt; (*!< Justification, see DGNJ_* *)
    length_mult : Double;   (*!< Char width in master (if square) *)
    height_mult : Double;   (*!< Char height in master units *)
    rotation : Double;      (*!< Counterclockwise rotation in degrees *)
    origin : DGNPoint;        (*!< Bottom left corner of text. *)
    _string : PCharArray;     (*!< Actual text (length varies, \0 terminated*)
  end;

(**
 * Complex header element
 *
 * The core.stype code is DGNST_COMPLEXHEADER.
 *
 * Used for: DGNT_COMPLEX_CHAIN_HEADER(12), DGNT_COMPLEX_SHAPE_HEADER(14).
 *)
  PDGNElemComplexHeader = ^DGNElemComplexHeader;
  DGNElemComplexHeader = Packed Record
    core : DGNElemCore;
    totlength : SmallInt;     (*!< Total length of surface *)
    numelems : SmallInt;      (*!< # of elements in surface *)
  End;

(**
 * Color table.
 *
 * The core.stype code is DGNST_COLORTABLE.
 *
 * Returned for DGNT_GROUP_DATA(5) elements, with a level number of
 * DGN_GDL_COLOR_TABLE(1).
 *)

  PDGNElemColorTable = ^DGNElemColorTable;
  DGNElemColorTable = Packed Record
    core : DGNElemCore;
    screen_flag : SmallInt;
    color_info : TPaletteArray; (*!< Color table, 256 colors by red (0), green(1) and blue(2) component. *)
  End;

(**
 * Terminal Control Block (header).
 *
 * The core.stype code is DGNST_TCB.
 *
 * Returned for DGNT_TCB(9).
 *
 * The first TCB in the file is used to determine the dimension (2D vs. 3D),
 * and transformation from UOR (units of resolution) to subunits, and subunits
 * to master units.  This is handled transparently within DGNReadElement(), so
 * it is not normally necessary to handle this element type at the application
 * level, though it can be useful to get the sub_units, and master_units names.
 *)

  PDGNElemTCB = ^DGNElemTCB;
  DGNElemTCB = Packed Record
    core : DGNElemCore;
    dimension : SmallInt;         (*!< Dimension (2 or 3) *)

    origin_x : Double;       (*!< X origin of UOR space in master units(?)*)
    origin_y : Double;       (*!< Y origin of UOR space in master units(?)*)
    origin_z : Double;       (*!< Z origin of UOR space in master units(?)*)

    uor_per_subunit : Longint;   (*!< UOR per subunit. *)
    sub_units : Array [0..2] of Char;      (*!< User name for subunits (2 chars)*)
    subunits_per_master : Longint; (*!< Subunits per master unit. *)
    master_units : Array [0..2] of char;   (*!< User name for master units (2 chars)*)
  End;

(**
 * Cell Header.
 *
 * The core.stype code is DGNST_CELL_HEADER.
 *
 * Returned for DGNT_CELL_HEADER(2).
 *)
  PDGNElemCellHeader = ^DGNElemCellHeader;
  DGNElemCellHeader = Packed Record
    core : DGNElemCore;

    totlength : SmallInt;         (*!< Total length of cell *)
    name : Array [0..6] of Char;           (*!< Cell name *)
    cclass : Word;            (*!< Class bitmap *)
    levels : Array [0..3] of Word;         (*!< Levels used in cell *)

    rnglow : DGNPoint;            (*!< X/Y/Z minimums for cell *)
    rnghigh : DGNPoint;           (*!< X/Y/Z minimums for cell *)

    trans : Array [0..8] of double;          (*!< 2D/3D Transformation Matrix *)
    origin : DGNPoint;            (*!< Cell Origin *)

    xscale : Double;
    yscale : Double;
    rotation : Double;
  End;

(**
 * Cell Library.
 *
 * The core.stype code is DGNST_CELL_LIBRARY.
 *
 * Returned for DGNT_CELL_LIBRARY(1).
 *)

  PDGNElemCellLibrary = ^DGNElemCellLibrary;
  DGNElemCellLibrary = Packed Record
    core : DGNElemCore;

    celltype : SmallInt;          (*!< Cell type. *)
    attindx : SmallInt;           (*!< Attribute linkage. *)
    name : Array [0..6] of Char;           (*!< Cell name *)

    numwords : SMallInt;          (*!< Number of words in cell definition *)

    dispsymb : SmallInt;          (*!< Display symbol *)
    cclass : Word;            (*!< Class bitmap *)
    levels : Array [0..3] of Word;         (*!< Levels used in cell *)

    description : Array [0..27] Of char;   (*!< Description *)
  End;

(**
 * Tag Value.
 *
 * The core.stype code is DGNST_TAG_VALUE.
 *
 * Returned for DGNT_TAG_VALUE(37).
 *)

  PtagValueUnion = ^tagValueUnion;
  tagValueUnion = Packed Record
    Case Integer Of
      0 : (_String  : PChar);
      1 : (_Integer : Integer);
      2 : (_Real : Double);
  End;

// typedef union { char *string; GInt32 integer; double real; } ;

  PDGNElemTagValue = ^DGNElemTagValue;
  DGNElemTagValue = Packed Record
    core : DGNElemCore;

    tagType : SmallInt;           (*!< Tag type indicator, 1=string *)
    tagSet : SmallInt;            (*!< Which tag set does this relate to? *)
    tagIndex : SmallInt;          (*!< Tag index within tag set. *)
    tagLength : Smallint;         (*!< Length of tag information (text) *)
    tagValue : tagValueUnion;        (*!< Textual value of tag *)

  End;

(**
 * Tag Set.
 *
 * The core.stype code is DGNST_TAG_SET.
 *
 * Returned for DGNT_APPLICATION_ELEM(66), Level: 24.
 *)

  PDGNTagDef = ^DGNTagDef;
  DGNTagDef = Packed Record
    name : PChar;
    id : SmallInt;
    prompt : PChar;
    _type : Smallint;
    defaultValue : tagValueUnion;
  End;

  PDGNElemTagSet = ^DGNElemTagSet;
  DGNElemTagSet = Packed Record
    core : DGNElemCore;
    tagCount : SmallInt;
    tagSet : SmallInt;
    flags : SmallInt;
    tagSetName : PChar;
    tagList : PDGNTagDefArray;
  End;
  DGNTagDefArray = Array [0..65535] Of DGNTagDef;

(* -------------------------------------------------------------------- *)
(*      Structure types                                                 *)
(* -------------------------------------------------------------------- *)

(** DGNElemCore style: Element uses DGNElemCore structure *)
const
  DGNST_CORE = 1;

(** DGNElemCore style: Element uses DGNElemMultiPoint structure *)
  DGNST_MULTIPOINT = 2;

(** DGNElemCore style: Element uses DGNElemColorTable structure *)
  DGNST_COLORTABLE = 3;

(** DGNElemCore style: Element uses DGNElemTCB structure *)
  DGNST_TCB = 4;

(** DGNElemCore style: Element uses DGNElemArc structure *)
  DGNST_ARC = 5;

(** DGNElemCore style: Element uses DGNElemText structure *)
  DGNST_TEXT = 6;

(** DGNElemCore style: Element uses DGNElemComplexHeader structure *)
  DGNST_COMPLEX_HEADER = 7;

(** DGNElemCore style: Element uses DGNElemCellHeader structure *)
  DGNST_CELL_HEADER = 8;

(** DGNElemCore style: Element uses DGNElemTagValue structure *)
  DGNST_TAG_VALUE = 9;

(** DGNElemCore style: Element uses DGNElemTagSet structure *)
  DGNST_TAG_SET = 10;

(** DGNElemCore style: Element uses DGNElemCellLibrary structure *)
  DGNST_CELL_LIBRARY = 11;

(* -------------------------------------------------------------------- *)
(*      Element types                                                   *)
(* -------------------------------------------------------------------- *)
  DGNT_CELL_LIBRARY = 1;
  DGNT_CELL_HEADER = 2;
  DGNT_LINE = 3;
  DGNT_LINE_STRING = 4;
  DGNT_GROUP_DATA = 5;
  DGNT_SHAPE = 6;
  DGNT_TEXT_NODE = 7;
  DGNT_DIGITIZER_SETUP = 8;
  DGNT_TCB = 9;
  DGNT_LEVEL_SYMBOLOGY = 10;
  DGNT_CURVE = 11;
  DGNT_COMPLEX_CHAIN_HEADER = 12;
  DGNT_COMPLEX_SHAPE_HEADER = 14;
  DGNT_ELLIPSE = 15;
  DGNT_ARC = 16;
  DGNT_TEXT = 17;
  DGNT_BSPLINE = 21;
  DGNT_SHARED_CELL_DEFN = 34;
  DGNT_SHARED_CELL_ELEM = 35;
  DGNT_TAG_VALUE = 37;
  DGNT_APPLICATION_ELEM = 66;

(* -------------------------------------------------------------------- *)
(*      Line Styles                                                     *)
(* -------------------------------------------------------------------- *)
  DGNS_SOLID = 0;
  DGNS_DOTTED = 1;
  DGNS_MEDIUM_DASH = 2;
  DGNS_LONG_DASH = 3;
  DGNS_DOT_DASH = 4;
  DGNS_SHORT_DASH = 5;
  DGNS_DASH_DOUBLE_DOT = 6;
  DGNS_LONG_DASH_SHORT_DASH = 7;

(* -------------------------------------------------------------------- *)
(*      Class                                                           *)
(* -------------------------------------------------------------------- *)
  DGNC_PRIMARY = 0;
  DGNC_PATTERN_COMPONENT = 1;
  DGNC_CONSTRUCTION_ELEMENT = 2;
  DGNC_DIMENSION_ELEMENT = 3;
  DGNC_PRIMARY_RULE_ELEMENT = 4;
  DGNC_LINEAR_PATTERNED_ELEMENT  = 5;
  DGNC_CONSTRUCTION_RULE_ELEMENT  = 6;

(* -------------------------------------------------------------------- *)
(*      Group Data level numbers.                                       *)
(*                                                                      *)
(*      These are symbolic values for the type 5 (DGNT_GROUP_DATA)      *)
(*      level values that have special meanings.                        *)
(* -------------------------------------------------------------------- *)
  DGN_GDL_COLOR_TABLE = 1;
  DGN_GDL_NAMED_VIEW =  3;
  DGN_GDL_REF_FILE = 9;

(* -------------------------------------------------------------------- *)
(*      Word 17 property flags.                                         *)
(* -------------------------------------------------------------------- *)
  DGNPF_HOLE = $8000;
  DGNPF_SNAPPABLE = $4000;
  DGNPF_PLANAR = $2000;
  DGNPF_ORIENTATION = $1000;
  DGNPF_ATTRIBUTES = $0800;
  DGNPF_MODIFIED = $0400;
  DGNPF_NEW = $0200;
  DGNPF_LOCKED = $0100;
  DGNPF_CLASS = $000f;

(* -------------------------------------------------------------------- *)
(*      DGNElementInfo flag values.                                     *)
(* -------------------------------------------------------------------- *)
  DGNEIF_DELETED = $01;
  DGNEIF_COMPLEX = $02;

(* -------------------------------------------------------------------- *)
(*      Justifications                                                  *)
(* -------------------------------------------------------------------- *)
  DGNJ_LEFT_TOP = 0;
  DGNJ_LEFT_CENTER = 1;
  DGNJ_LEFT_BOTTOM = 2;
  DGNJ_CENTER_TOP = 3;
  DGNJ_CENTER_CENTER = 4;
  DGNJ_CENTER_BOTTOM = 5;
  DGNJ_RIGHT_TOP = 6;
  DGNJ_RIGHT_CENTER = 7;
  DGNJ_RIGHT_BOTTOM = 8;

(* -------------------------------------------------------------------- *)
(*      DGN file reading options.                                       *)
(* -------------------------------------------------------------------- *)
  DGNO_CAPTURE_RAW_DATA	= $01;

(* -------------------------------------------------------------------- *)
(*      Known attribute linkage types, including my synthetic ones.     *)
(* -------------------------------------------------------------------- *)
  DGNLT_DMRS = $0000;
  DGNLT_INFORMIX = $3848;
  DGNLT_ODBC = $5e62;
  DGNLT_ORACLE = $6091;
  DGNLT_RIS = $71FB;
  DGNLT_SYBASE = $4f58;
  DGNLT_XBASE = $1971;
  DGNLT_SHAPE_FILL = $0041;


{ forward declarations }

//------------------------DGNLib----------------------
//Procedure  memcpy(Dest, Source : Pointer; Count : Integer);
Procedure DGNRad50ToAscii(rad50 : Word; str : PChar); Forward;
Procedure DGNClose( hDGN : DGNHandle ); Forward;
Procedure DGNSpatialFilterToUOR( psDGN : PDGNInfo ); Forward;
Procedure DGNSetSpatialFilter( hDGN : DGNHandle; dfXMin, dfYMin, dfXMax, dfYMax : Double); Forward;
Procedure DGNSetOptions( hDGN : DGNHandle; nOptions : Integer); Forward;
Function DGNOpen( pszFilename : PChar; bUpdate : Integer) : DGNHandle; Forward;
Function DGNTestOpen( pabyHeader : PByteArray; nByteCount : Integer ) : Boolean; Forward;
//Function CPL_LSBWORD32(w : LongInt) : Longint; Forward;
//Function CPL_LSBWORD16(w : SmallInt) : SmallInt; Forward;
//Function DGN_INT32(p : Pointer) : Integer; Forward;
//---------------------------

//-----------DGNRead------------------------
function DGNGotoElement( hDGN : DGNHandle; element_id : SmallInt) : Boolean; Forward;
Procedure DGNBuildIndex( psDGN : PDGNInfo ); Forward;
Function DGNParseCore( psDGN : PDGNInfo; psElement :PDGNElemCore) : Boolean; Forward;
Procedure DGNTransformPoint( psDGN : PDGNInfo; psPoint : PDGNPoint ); Forward;
Function DGNParseColorTable( psDGN : PDGNInfo ) : PDGNElemCore; Forward;
Function DGNParseTCB( psDGN : PDGNInfo) : PDGNElemCore; Forward;
Function CPLStrdup( pszString : PChar) : PChar; Forward;
Function DGNParseTagSet( psDGN : PDGNInfo ) : PDGNElemCore; Forward;
Function DGNLoadRawElement( psDGN : PDGNInfo; pnType, pnLevel : PSmallInt ) : Boolean; Forward;
Procedure DGNInverseTransformPoint( psDGN : PDGNInfo; psPoint : PDGNPoint ); Forward;
Function DGNReadElement( hDGN : DGNHandle ) : PDGNElemCore; Forward;
procedure DGNFreeElement( hDGN : DGNHandle; psElement : PDGNElemCore); Forward;
Function DGNGetExtents( hDGN : DGNHandle; padfExtents : DoubleArray) : Boolean; Forward;
Function DGNGetElementIndex( hDGN : DGNHandle; pnElementCount : PSmallInt) : PDGNElementInfo; Forward;
//--------------------------------------------

//--------------DGNFloat----------------------
//Procedure vax2ieee(dbl : Pointer); Forward;

//Procedure ieee2vax ( d : Pointer ); Forward;
//--------------------------------------------

Function LoadTextEntity(psDGN : PDGNInfo; psText : PDGNElemText ) : TEzFittedVectorText; Forward;
Function GetIndexOfColor(const Table : TPaletteArray; Color : TColor; LastIndex : SmallInt) : LongWord; Forward;
Procedure GetRGB(Color :TColor; Var r, g ,b : Byte); Forward;
Function DGNRGB(hDGN : DGNHandle; Index : SmallInt) : TColor; Forward;


{ Start of implementation section for the original code }

Function CPL_LSBWORD16(w : SmallInt) : SmallInt;
Begin
  Result := ((w And $00FF) Shl 8) Or ((w And $FF00) Shr 8);
End;

Function CPL_LSBWORD32(w : LongInt) : LongInt;
Begin
  Result := ((LongWord(w) And $000000FF) Shl 24) Or ((LongWord(w) And $0000FF00) Shl 8) Or
            ((LongWord(w) And $00FF0000) Shr 8) Or ((LongWord(w) And $FF000000) Shr 24);
End;

Function DGN_INT32(p : Pointer) : Integer;
Var
  //a : PByteArray;
  l: Integer;
Begin
  l:= PInteger(p)^;
  TLA( Result )[1] := TLA( l )[3];
  TLA( Result )[2] := TLA( l )[4];
  TLA( Result )[3] := TLA( l )[1];
  TLA( Result )[4] := TLA( l )[2];

  //exit;
  //a := p;
  //Result :=	a[2] + a[3]*256 + a[1]*65536*256 + a[0]*65536;
End;

{ TDGNFileStream }

constructor TDGNFileStream.Create(const FileName: string; Mode: Word);
begin
  inherited Create(FileName, Mode);
end;

function TDGNFileStream.DGNRead(Buffer: Pointer; Count: Integer): Longint;
begin
  Result := Read(Buffer^, Count);
end;

function TDGNFileStream.DGNWrite(Buffer: Pointer; Count: Integer): Longint;
begin
  Result := Write(Buffer^, Count);
end;

Procedure DGNRad50ToAscii(rad50 : Word; str : PChar);
Var
    cTimes : Byte;

    value : Word;
    temp : Word;
    ch : Char;
    Index : Integer;
Begin
    ch := Chr(0);
    Index := 0;

    while (rad50 > 0) do Begin
        value := rad50;
        cTimes := 0;
        while (value >= 40) do Begin
            value := value Div 40;
            Inc(cTimes);
        End;

        (* Map 0..39 to ASCII *)
        if (value = 0) Then
            ch := ' '          (* space *)
        else if (value >= 1) And (value <= 26) Then
            ch := Char(value - 1 + Ord('A'))  (* printable alpha A..Z *)
        else if (value = 27) Then
            ch := '$'           (* dollar *)
        else if (value = 28) Then
            ch := '.'           (* period *)
        else if (value = 29) Then
            ch := ' '           (* unused char, emit a space instead *)
        else if (value >= 30) And(value <= 39) Then
            ch := Char(value - 30 + Ord('0'));   (* digit 0..9 *)

        str[Index] := ch;
        Inc(Index);

        temp := 1;
        while (cTimes > 0) Do Begin
            temp := temp * 40;
            Dec(cTimes);
        End;


        Dec(rad50, value * temp);
    End;
    (* Do zero-terminate *)
    Str[index] := Chr(0);
End;



(************************************************************************)
(*                            DGNTestOpen()                             *)
(************************************************************************)

(**
 * Test if header is DGN.
 *
 * @param pabyHeader block of header data from beginning of file.
 * @param nByteCount number of bytes in pabyHeader.
 *
 * @return TRUE if the header appears to be from a DGN file, otherwise FALSE.
 *)

Function DGNTestOpen( pabyHeader : PByteArray; nByteCount : Integer ) : Boolean;
Begin
    Result := True;
    if( nByteCount < 4 ) Then
        Exit;

    // Is it a cell library?
    if (pabyHeader[0] = $08) And
       (pabyHeader[1] = $05) And
       (pabyHeader[2] = $17) And
       (pabyHeader[3] = $00) Then
        Exit;

    // Is it not a regular 2D or 3D file?
    if  (pabyHeader[0] <> $08) And (pabyHeader[0] <> $C8) Or
        (pabyHeader[1] <> $09) Or
        (pabyHeader[2] <> $FE) Or (pabyHeader[3] <> $02) Then
          Result := False;
End;

(************************************************************************)
(*                              DGNOpen()                               *)
(************************************************************************)

(**
 * Open a DGN file.
 *
 * The file is opened, and minimally verified to ensure it is a DGN (ISFF)
 * file.  If the file cannot be opened for read access an error with code
 * CPLE_OpenFailed with be reported via CPLError() and NULL returned.
 * If the file header does
 * not appear to be a DGN file, an error with code CPLE_AppDefined will be
 * reported via CPLError(), and NULL returned.
 *
 * If successful a handle for further access is returned.  This should be
 * closed with DGNClose() when no longer needed.
 *
 * DGNOpen() does not scan the file on open, and should be very fast even for
 * large files.
 *
 * @param pszFilename name of file to try opening.
 * @param bUpdate should the file be opened with read+update (r+) mode?
 *
 * @return handle to use for further access to file using DGN API, or NULL
 * if open fails.
 *)

Function DGNOpen( pszFilename : PChar; bUpdate : Integer) : DGNHandle;
Var
    psDGN : PDGNInfo;
    fp : TDGNFileStream;
    abyHeader : Array [0..511] Of Byte;
Begin

(* -------------------------------------------------------------------- *)
(*      Open the file.                                                  *)
(* -------------------------------------------------------------------- *)
    if( bUpdate <> 0) Then
        fp := TDGNFileStream.Create(pszFileName, fmOpenRead)
    else
        fp := TDGNFileStream.Create(pszFileName, fmOpenReadWrite);

(* -------------------------------------------------------------------- *)
(*      Verify the format ... add later.                                *)
(* -------------------------------------------------------------------- *)

    fp.DGNRead(@abyHeader, sizeof(abyHeader));
//    VSIFRead( abyHeader, 1, sizeof(abyHeader), fp );
    if( Not DGNTestOpen( @abyHeader, sizeof(abyHeader) ) ) Then Begin
        MessageToUser(Format(SDGNWrongHeader, [pszFilename]),smsgerror,mb_iconerror );
        fp.Free;
        Result := Nil;
        Exit;
    End;

    fp.Position := 0;

(* -------------------------------------------------------------------- *)
(*      Create the info structure.                                      *)
(* -------------------------------------------------------------------- *)
//    psDGN = (DGNInfo *) CPLCalloc(sizeof(DGNInfo),1);
    GetMem(psDGN, sizeof(DGNInfo));
    psDGN^.fp := fp;
    psDGN^.next_element_id := 0;

    psDGN^.got_tcb := Ord(False);
    psDGN^.scale := 1.0;
    psDGN^.origin_x := 0.0;
    psDGN^.origin_y := 0.0;
    psDGN^.origin_z := 0.0;

    psDGN^.index_built := Ord(false);
    psDGN^.element_count := 0;
    psDGN^.element_index := nil;

    psDGN^.got_bounds := Ord(False);

    if( abyHeader[0] = $C8 ) Then
        psDGN^.dimension := 3
    else
        psDGN^.dimension := 2;

    psDGN^.has_spatial_filter := False;
    psDGN^.sf_converted_to_uor := False;
    psDGN^.select_complex_group := False;
    psDGN^.in_complex_group := false;

    Result := psDGN;
End;

(************************************************************************)
(*                           DGNSetOptions()                            *)
(************************************************************************)

(**
 * Set file access options.
 *
 * @param hDGN handle to file returned by DGNOpen().
 * @param nOptions ORed option flags (currently either 0 or
 * DGNO_CAPTURE_RAW_DATA).
 *
 * Sets options affecting subsequent data reading.
 *)

Procedure DGNSetOptions( hDGN : DGNHandle; nOptions : Integer);
Var
  psDGN : PDGNInfo;
begin
    psDGN := Pointer(hDGN);
    psDGN^.options := nOptions;
End;

(************************************************************************)
(*                       DGNSpatialFilterToUOR()                        *)
(************************************************************************)

Procedure DGNSpatialFilterToUOR( psDGN : PDGNInfo );
var
    sMin, sMax : DGNPoint;
Begin
    if (psDGN^.sf_converted_to_uor) or
       (Not psDGN^.has_spatial_filter) Or
       (psDGN^.got_tcb = 0) Then
        Exit;

    sMin.x := psDGN^.sf_min_x_geo;
    sMin.y := psDGN^.sf_min_y_geo;
    sMin.z := 0;

    sMax.x := psDGN^.sf_max_x_geo;
    sMax.y := psDGN^.sf_max_y_geo;
    sMax.z := 0;

    DGNInverseTransformPoint( psDGN, @sMin );
    DGNInverseTransformPoint( psDGN, @sMax );

    psDGN^.sf_min_x := Trunc(sMin.x + 2147483648.0);
    psDGN^.sf_min_y := Trunc(sMin.y + 2147483648.0);
    psDGN^.sf_max_x := Trunc(sMax.x + 2147483648.0);
    psDGN^.sf_max_y := Trunc(sMax.y + 2147483648.0);

    psDGN^.sf_converted_to_uor := True;
End;

(************************************************************************)
(*                        DGNSetSpatialFilter()                         *)
(************************************************************************)

(**
 * Set rectangle for which features are desired.
 *
 * If a spatial filter is set with this function, DGNReadElement() will
 * only return spatial elements (elements with a known bounding box) and
 * only those elements for which this bounding box overlaps the requested
 * region. 
 *
 * If all four values (dfXMin, dfXMax, dfYMin and dfYMax) are zero, the
 * spatial filter is disabled.   Note that installing a spatial filter
 * won't reduce the amount of data read from disk.  All elements are still
 * scanned, but the amount of processing work for elements outside the
 * spatial filter is minimized.
 *
 * @param hDGN Handle from DGNOpen() for file to update.
 * @param dfXMin minimum x coordinate for extents (georeferenced coordinates).
 * @param dfYMin minimum y coordinate for extents (georeferenced coordinates).
 * @param dfXMax maximum x coordinate for extents (georeferenced coordinates).
 * @param dfYMax maximum y coordinate for extents (georeferenced coordinates).
 *)

Procedure DGNSetSpatialFilter( hDGN : DGNHandle; dfXMin, dfYMin, dfXMax, dfYMax : Double);
Var
    psDGN : PDGNInfo;
Begin
    psDGN := Pointer(hDGN);

    if (dfXMin = 0.0) And (dfXMax = 0.0) And
       (dfYMin = 0.0) And (dfYMax = 0.0) Then Begin
        psDGN^.has_spatial_filter := False;
        Exit;
    End;

    psDGN^.has_spatial_filter := False;
    psDGN^.sf_converted_to_uor := False;

    psDGN^.sf_min_x_geo := dfXMin;
    psDGN^.sf_min_y_geo := dfYMin;
    psDGN^.sf_max_x_geo := dfXMax;
    psDGN^.sf_max_y_geo := dfYMax;

    DGNSpatialFilterToUOR( psDGN );
End;

(************************************************************************)
(*                              DGNClose()                              *)
(************************************************************************)

(**
 * Close DGN file.
 *
 * @param hDGN Handle from DGNOpen() for file to close.
 *)

Procedure DGNClose( hDGN : DGNHandle );
Var
  psDGN : PDGNInfo;
Begin
    psDGN := Pointer(hDGN);

    psDGN^.fp.Free;
    FreeMem( psDGN^.element_index );
    FreeMem( psDGN );
End;


(*******************************************
*  DGNReag
*)

function DGNGotoElement( hDGN : DGNHandle; element_id : SmallInt) : Boolean;
Var
  psDGN : PDGNInfo;
Begin
    psDGN := PDGNInfo(hDGN);

    DGNBuildIndex( psDGN );

    if( element_id < 0) Or (element_id >= psDGN^.element_count) Then Begin
        Result := False;
        Exit;
    End;

    if( psDGN^.fp.Seek(psDGN^.element_index^[element_id].offset, soFromBeginning ) <> 0 ) Then Begin
        Result := False;
        Exit;
    End;

    psDGN^.next_element_id := element_id;
    psDGN^.in_complex_group := False;

    Result := True;
End;

(************************************************************************)
(*                         DGNLoadRawElement()                          *)
(************************************************************************)

Function DGNLoadRawElement( psDGN : PDGNInfo; pnType, pnLevel : PSmallInt ) : Boolean;
var
  nType, nWords, nLevel : SmallInt;
  tmp : SmallInt;
Begin
(* -------------------------------------------------------------------- *)
(*      Read the first four bytes to get the level, type, and word      *)
(*      count.                                                          *)
(* -------------------------------------------------------------------- *)

    if( psDGN^.fp.DGNRead( @psDGN^.abyElem, 4 ) <> 4 ) Then Begin
        Result := False;
        Exit;
    End;

    (* Is this an 0xFFFF endof file marker? *)
    if( psDGN^.abyElem[0] = $ff) And (psDGN^.abyElem[1] = $ff ) Then Begin
        Result := False;
        Exit;
    End;

    nWords := psDGN^.abyElem[2] + psDGN^.abyElem[3]*256;
    nType := psDGN^.abyElem[1] And $7f;
    nLevel := psDGN^.abyElem[0] And $3f;

(* -------------------------------------------------------------------- *)
(*      Read the rest of the element data into the working buffer.      *)
(* -------------------------------------------------------------------- *)
//    CPLAssert( nWords * 2 + 4 <= Smallint(sizeof(psDGN^.abyElem))); //Pendiente
     //Checar
     tmp := psDGN^.fp.DGNRead( @psDGN^.abyElem[4], 2 * nWords);
    if( tmp <> nWords * 2) Then Begin
        Result := False;
        Exit;
    End;

    psDGN^.nElemBytes := nWords * 2 + 4;

    Inc(psDGN^.next_element_id);

(* -------------------------------------------------------------------- *)
(*      Return requested info.                                          *)
(* -------------------------------------------------------------------- *)
    if( pnType <> Nil ) Then
        pnType^ := nType;

    if( pnLevel <> Nil ) Then
        pnLevel^ := nLevel;

    Result := True;
End;

(************************************************************************)
(*                        DGNGetElementExtents()                        *)
(*                                                                      *)
(*      Returns FALSE if the element type does not have reconisable     *)
(*      element extents, other TRUE and the extents will be updated.    *)
(*                                                                      *)
(*      It is assumed the raw element data has been loaded into the     *)
(*      working area by DGNLoadRawElement().                            *)
(************************************************************************)


Function DGNGetElementExtents( psDGN : PDGNInfo; nType : SmallInt;
                      pnXMin, pnYMin, pnZMin,
                      pnXMax, pnYMax, pnZMax : PCardinal ) : Boolean;

Begin
    Case nType  Of
      DGNT_LINE,
      DGNT_LINE_STRING,
      DGNT_SHAPE,
      DGNT_CURVE,
      DGNT_BSPLINE,
      DGNT_ELLIPSE,
      DGNT_ARC,
      DGNT_TEXT,
      DGNT_COMPLEX_CHAIN_HEADER,
      DGNT_COMPLEX_SHAPE_HEADER :
      Begin
        pnXMin^ := DGN_INT32(@psDGN^.abyElem[4]);
        pnYMin^ := DGN_INT32(@psDGN^.abyElem[8]);
        if( pnZMin <> Nil ) Then
            pnZMin^ := DGN_INT32(@psDGN^.abyElem[12]);

        pnXMax^ := DGN_INT32(@psDGN^.abyElem[16]);
        pnYMax^ := DGN_INT32(@psDGN^.abyElem[20]);
        if( pnZMax <> Nil ) Then
            pnZMax^ := DGN_INT32(@psDGN^.abyElem[24]);
        Result := True;
      End
    Else
        Result := False;
    End;
End;

(************************************************************************)
(*                         DGNProcessElement()                          *)
(*                                                                      *)
(*      Assumes the raw element data has already been loaded, and       *)
(*      tries to convert it into an element structure.                  *)
(************************************************************************)

Function DGNProcessElement( psDGN : PDGNInfo; nType, nLevel : SmallInt ) : PDGNElemCore;
Var
    psElement : PDGNElemCore;
    psCellH : PDGNElemCellHeader;
    a, b, c, d, a2, c2, tmp : Double;
    psCell : PDGNElemCellLibrary;
    iWord : Smallint;
    iOffset : SmallInt;
    psLine : PDGNElemMultiPoint;
    i, count : Smallint;
    pntsize : Smallint;
    psEllipse : PDGNElemArc;
    nSweepVal : Integer;
    psText : PDGNElemText;
    num_chars, text_off : SmallInt;
    n : SmallInt;
    w : Word;
    psHdr : PDGNElemComplexHeader;
    psTag : PDGNElemTagValue;
Begin

(* -------------------------------------------------------------------- *)
(*      Handle based on element type.                                   *)
(* -------------------------------------------------------------------- *)
    Case nType Of
      DGNT_CELL_HEADER:
      Begin

          GetMem(psCellH, sizeof(DGNElemCellHeader));
          //FillChar(psCellH^, sizeof(DGNElemCellHeader), 0);
          psElement := PDGNElemCore(psCellH);
          psElement^.raw_data := Nil;
          psElement^.attr_data := Nil;
          psElement^.stype := DGNST_CELL_HEADER;
          DGNParseCore( psDGN, psElement );

          psCellH^.totlength := psDGN^.abyElem[36] + psDGN^.abyElem[37] * 256;

          DGNRad50ToAscii( psDGN^.abyElem[38] + psDGN^.abyElem[39] * 256,
                           psCellH^.name + 0 );
          DGNRad50ToAscii( psDGN^.abyElem[40] + psDGN^.abyElem[41] * 256,
                           psCellH^.name + 3 );

          psCellH^.cclass := psDGN^.abyElem[42] + psDGN^.abyElem[43] * 256;
          psCellH^.levels[0] := psDGN^.abyElem[44] + psDGN^.abyElem[45] * 256;
          psCellH^.levels[1] := psDGN^.abyElem[46] + psDGN^.abyElem[47] * 256;
          psCellH^.levels[2] := psDGN^.abyElem[48] + psDGN^.abyElem[49] * 256;
          psCellH^.levels[3] := psDGN^.abyElem[50] + psDGN^.abyElem[51] * 256;
          psCellH^.core.color := psDGN^.abyElem[35];

          if( psDGN^.dimension = 2 ) Then Begin
              //Last Changes
              psCellH^.rnglow.x := DGN_INT32(@psDGN^.abyElem[52]);
              psCellH^.rnglow.y := DGN_INT32(@psDGN^.abyElem[56]);
              psCellH^.rnghigh.x := DGN_INT32(@psDGN^.abyElem[60]);
              psCellH^.rnghigh.y := DGN_INT32(@psDGN^.abyElem[64]);

              psCellH^.origin.x := DGN_INT32(@psDGN^.abyElem[84]);
              psCellH^.origin.y := DGN_INT32(@psDGN^.abyElem[88]);

              a := DGN_INT32(@psDGN^.abyElem[68]);
              b := DGN_INT32(@psDGN^.abyElem[72]);
              c := DGN_INT32(@psDGN^.abyElem[76]);
              d := DGN_INT32(@psDGN^.abyElem[80]);
              a2 := a * a;
              c2 := c * c;

              psCellH^.xscale := sqrt(a2 + c2) / 214748;
              psCellH^.yscale := sqrt(b*b + d*d) / 214748;
              tmp := a / sqrt(a2 + c2);
              psCellH^.rotation := arccos(tmp);
              if (b <= 0) Then
                  psCellH^.rotation := psCellH^.rotation * 180 / System.PI
              else
                  psCellH^.rotation := 360 - psCellH^.rotation * 180 / System.PI;
          End else Begin  //Last changes
              psCellH^.rnglow.x := DGN_INT32(@psDGN^.abyElem[52]);
              psCellH^.rnglow.y := DGN_INT32(@psDGN^.abyElem[56]);
              psCellH^.rnglow.z := DGN_INT32(@psDGN^.abyElem[60]);
              psCellH^.rnghigh.x := DGN_INT32(@psDGN^.abyElem[64]);
              psCellH^.rnghigh.y := DGN_INT32(@psDGN^.abyElem[68]);
              psCellH^.rnghigh.z := DGN_INT32(@psDGN^.abyElem[72]);

              psCellH^.origin.x := DGN_INT32(@psDGN^.abyElem[112]);
              psCellH^.origin.y := DGN_INT32(@psDGN^.abyElem[116]);
              psCellH^.origin.z := DGN_INT32(@psDGN^.abyElem[120]);
          End;

          DGNTransformPoint( psDGN, @(psCellH^.rnglow) );
          DGNTransformPoint( psDGN, @(psCellH^.rnghigh) );
          DGNTransformPoint( psDGN, @(psCellH^.origin) );
      End;

      DGNT_CELL_LIBRARY:
      Begin
          //psCell := PDGNElemCellLibrary(CPLCalloc(sizeof(DGNElemCellLibrary), 1));
          GetMem(psCell, sizeof(DGNElemCellLibrary));
          //FillChar(psCell^, sizeof(DGNElemCellLibrary), 0);
          psElement := PDGNElemCore(psCell);
          psElement^.raw_data := Nil;
          psElement^.attr_data := Nil;
          psElement^.stype := DGNST_CELL_LIBRARY;
          DGNParseCore( psDGN, psElement );

          DGNRad50ToAscii( psDGN^.abyElem[32] + psDGN^.abyElem[33] * 256,
                           psCell^.name + 0 );
          DGNRad50ToAscii( psDGN^.abyElem[34] + psDGN^.abyElem[35] * 256,
                           psCell^.name + 3 );

          psElement^.properties := psDGN^.abyElem[38]
              + psDGN^.abyElem[39] * 256;

          psCell^.dispsymb := psDGN^.abyElem[40] + psDGN^.abyElem[41] * 256;

          psCell^.cclass := psDGN^.abyElem[42] + psDGN^.abyElem[43] * 256;
          psCell^.levels[0] := psDGN^.abyElem[44] + psDGN^.abyElem[45] * 256;
          psCell^.levels[1] := psDGN^.abyElem[46] + psDGN^.abyElem[47] * 256;
          psCell^.levels[2] := psDGN^.abyElem[48] + psDGN^.abyElem[49] * 256;
          psCell^.levels[3] := psDGN^.abyElem[50] + psDGN^.abyElem[51] * 256;

          psCell^.numwords := psDGN^.abyElem[36] + psDGN^.abyElem[37] * 256;

          //FillChar( psCell^.description, sizeof(psCell^.description), 0 );

          for iWord := 0 To 8 Do Begin
              iOffset := 52 + iWord * 2;
              DGNRad50ToAscii( psDGN^.abyElem[iOffset]
                               + psDGN^.abyElem[iOffset+1] * 256,
                               psCell^.description + iWord * 3 );
          end;
      End;

      DGNT_LINE:
      Begin
//          psLine := PDGNElemMultiPoint(CPLCalloc(sizeof(DGNElemMultiPoint),1));
//          count := psDGN^.abyElem[36] + psDGN^.abyElem[37]*256;
          GetMem(psLine, sizeof(DGNElemMultiPoint));
          GetMem(psLine^.vertices, (2)*sizeof(DGNPoint));
          //FillChar(psLine^, sizeof(DGNElemMultiPoint), 0);
          psElement := PDGNElemCore(psLine);
          psElement^.raw_data := Nil;
          psElement^.attr_data := Nil;
          psElement^.stype := DGNST_MULTIPOINT;
          DGNParseCore( psDGN, psElement );

          psLine^.num_vertices := 2;
          if( psDGN^.dimension = 2 ) then begin
              psLine^.vertices[0].x := DGN_INT32(@psDGN^.abyElem[36]);
              psLine^.vertices[0].y := DGN_INT32(@psDGN^.abyElem[40]);
              psLine^.vertices[1].x := DGN_INT32(@psDGN^.abyElem[44]);
              psLine^.vertices[1].y := DGN_INT32(@psDGN^.abyElem[48]);
              psLine^.vertices[0].z := 0;
              psLine^.vertices[1].z := 0;
          End else Begin
              psLine^.vertices[0].x := DGN_INT32(@psDGN^.abyElem[36]);
              psLine^.vertices[0].y := DGN_INT32(@psDGN^.abyElem[40]);
              psLine^.vertices[0].z := DGN_INT32(@psDGN^.abyElem[44]);
              psLine^.vertices[1].x := DGN_INT32(@psDGN^.abyElem[48]);
              psLine^.vertices[1].y := DGN_INT32(@psDGN^.abyElem[52]);
              psLine^.vertices[1].z := DGN_INT32(@psDGN^.abyElem[56]);
          End;

          DGNTransformPoint( psDGN, @psLine^.vertices[0] );
          DGNTransformPoint( psDGN, @psLine^.vertices[1] );
      End;

      DGNT_LINE_STRING,
      DGNT_SHAPE,
      DGNT_CURVE,
      DGNT_BSPLINE:
      Begin
          pntsize := psDGN^.dimension * 4;
          count := psDGN^.abyElem[36] + psDGN^.abyElem[37]*256;
//          psLine := PDGNElemMultiPoint(CPLCalloc(sizeof(DGNElemMultiPoint)+(count-2)*sizeof(DGNPoint),1));
          GetMem(psLine, sizeof(DGNElemMultiPoint));
          GetMem(psLine^.vertices, (count)*sizeof(DGNPoint));
          //FillChar(psLine^, sizeof(DGNElemMultiPoint), 0);
          psElement := PDGNElemCore(psLine);
          psElement^.raw_data := Nil;
          psElement^.attr_data := Nil;
          psElement^.stype := DGNST_MULTIPOINT;
          DGNParseCore( psDGN, psElement );

          if( psDGN^.nElemBytes < 38 + count * pntsize ) Then begin
              {CPLError( CE_Warning, CPLE_AppDefined,
                        "Trimming multipoint vertices to %d from %d because\n"
                        "element is short.\n",
                        (psDGN^.nElemBytes - 38) / pntsize,
                        count );}
              count := Trunc((psDGN^.nElemBytes - 38) / pntsize);
          End;
          psLine^.num_vertices := count;
          for i := 0 To psLine^.num_vertices - 1 Do Begin
              psLine^.vertices[i].x :=
                  DGN_INT32(@psDGN^.abyElem[38 + i * pntsize]);
              psLine^.vertices[i].y :=
                  DGN_INT32(@psDGN^.abyElem[42 + i * pntsize]);
              if( psDGN^.dimension = 3 )  Then
                  psLine^.vertices[i].z :=
                  DGN_INT32(@psDGN^.abyElem[36 + i * pntsize]);

              DGNTransformPoint( psDGN, @psLine^.vertices[i]);
          End;
      End;

      DGNT_GROUP_DATA:
        if( nLevel = DGN_GDL_COLOR_TABLE ) Then begin
            psElement := DGNParseColorTable( psDGN );
            psElement^.raw_data := Nil;
            psElement^.attr_data := Nil;
        end else begin
//            psElement := PDGNElemCore(CPLCalloc(sizeof(DGNElemCore),1));
            GetMem(psElement, sizeof(DGNElemCore));
            psElement^.raw_data := Nil;
            psElement^.attr_data := Nil;
            //FillChar(psElement^, sizeof(DGNElemCore), 0);
            psElement^.stype := DGNST_CORE;
            DGNParseCore( psDGN, psElement );
        end;

      DGNT_ELLIPSE:
      Begin
//          psEllipse := PDGNElemArc(CPLCalloc(sizeof(DGNElemArc),1));
          GetMem(psEllipse, sizeof(DGNElemArc));
          //FillChar(psEllipse^, sizeof(DGNElemArc), 0);
          psElement := PDGNElemCore(psEllipse);
          psElement^.raw_data := Nil;
          psElement^.attr_data := Nil;
          psElement^.stype := DGNST_ARC;
          DGNParseCore( psDGN, psElement );

          CopyMemory( @(psEllipse^.primary_axis), @psDGN^.abyElem[36], 8 );
          vax2ieee( @(psEllipse^.primary_axis) );
          psEllipse^.primary_axis := psEllipse^.primary_axis * psDGN^.scale;

          CopyMemory( @(psEllipse^.secondary_axis), @psDGN^.abyElem[44] , 8 );
          vax2ieee( @(psEllipse^.secondary_axis) );
          psEllipse^.secondary_axis := psEllipse^.secondary_axis * psDGN^.scale;

          if( psDGN^.dimension = 2 ) Then Begin
              psEllipse^.rotation := DGN_INT32(@psDGN^.abyElem[52]);
              psEllipse^.rotation := psEllipse^.rotation / 360000.0;

              CopyMemory( @(psEllipse^.origin.x), @psDGN^.abyElem[56], 8 );
              vax2ieee( @(psEllipse^.origin.x) );

              CopyMemory( @(psEllipse^.origin.y), @psDGN^.abyElem[64], 8 );
              vax2ieee( @(psEllipse^.origin.y) );
              psEllipse^.origin.z := 0;
          End else Begin
              (* leave quaternion for later *)

              CopyMemory( @(psEllipse^.origin.x), @psDGN^.abyElem[68], 8 );
              vax2ieee( @(psEllipse^.origin.x) );

              CopyMemory( @(psEllipse^.origin.y), @psDGN^.abyElem[76], 8 );
              vax2ieee( @(psEllipse^.origin.y) );

              CopyMemory( @(psEllipse^.origin.z), @psDGN^.abyElem[84], 8 );
              vax2ieee( @(psEllipse^.origin.z) );
          End;

          DGNTransformPoint( psDGN, @(psEllipse^.origin) );

          psEllipse^.startang := 0.0;
          psEllipse^.sweepang := 360.0;
      End;

      DGNT_ARC:
      Begin
//          psEllipse := PDGNElemArc(CPLCalloc(sizeof(DGNElemArc),1));
          GetMem(psEllipse, sizeof(DGNElemArc));
          //FillChar(psEllipse^, sizeof(DGNElemArc), 0);
          psElement := PDGNElemCore(psEllipse);
          psElement^.raw_data := Nil;
          psElement^.attr_data := Nil;
          psElement^.stype := DGNST_ARC;
          DGNParseCore( psDGN, psElement );

          psEllipse^.startang := DGN_INT32(@psDGN^.abyElem[36]);
          psEllipse^.startang := psEllipse^.startang / 360000.0;
          if( (psDGN^.abyElem[41] And $80) <> 0 ) Then Begin
              psDGN^.abyElem[41] := psDGN^.abyElem[41] And $7f;
              nSweepVal := -1 * DGN_INT32(@psDGN^.abyElem[40]);
          End else
              nSweepVal := DGN_INT32(@psDGN^.abyElem[40]);

          if( nSweepVal = 0 ) Then
              psEllipse^.sweepang := 360.0
          else
              psEllipse^.sweepang := nSweepVal / 360000.0;

          CopyMemory( @(psEllipse^.primary_axis), @psDGN^.abyElem[44], 8 );
          vax2ieee( @(psEllipse^.primary_axis) );
          psEllipse^.primary_axis := psEllipse^.primary_axis * psDGN^.scale;

          CopyMemory( @(psEllipse^.secondary_axis), @psDGN^.abyElem[52], 8 );
          vax2ieee( @(psEllipse^.secondary_axis) );
          psEllipse^.secondary_axis := psEllipse^.secondary_axis * psDGN^.scale;

          if( psDGN^.dimension = 2 ) Then Begin
              psEllipse^.rotation := DGN_INT32(@psDGN^.abyElem[60]);
              psEllipse^.rotation := psEllipse^.rotation / 360000.0;

              CopyMemory( @(psEllipse^.origin.x), @psDGN^.abyElem[64], 8 );
              vax2ieee( @(psEllipse^.origin.x) );

              CopyMemory( @(psEllipse^.origin.y), @psDGN^.abyElem[72], 8 );
              vax2ieee( @(psEllipse^.origin.y) );
              psEllipse^.origin.z := 0;
          End else Begin
              (* for now we don't try to handle quaternion *)
              psEllipse^.rotation := 0;

              CopyMemory( @(psEllipse^.origin.x), @psDGN^.abyElem[76], 8 );
              vax2ieee( @(psEllipse^.origin.x) );

              CopyMemory( @(psEllipse^.origin.y), @psDGN^.abyElem[84], 8 );
              vax2ieee( @(psEllipse^.origin.y) );

              CopyMemory( @(psEllipse^.origin.z), @psDGN^.abyElem[92], 8 );
              vax2ieee( @(psEllipse^.origin.z) );
          End;

          DGNTransformPoint( psDGN, @(psEllipse^.origin) );

      End;

      DGNT_TEXT:
      Begin
          if( psDGN^.dimension = 2 ) Then
              num_chars := psDGN^.abyElem[58]
          else
              num_chars := psDGN^.abyElem[74];

//          psText := PDGNElemText(CPLCalloc(sizeof(DGNElemText)+num_chars,1));
          GetMem(psText, sizeof(DGNElemText));
          GetMem(psText^._string, num_chars + 2);
          //FillChar(psText^, sizeof(DGNElemText) + num_chars, 0);
          psElement := PDGNElemCore(psText);
          psElement^.raw_data := Nil;
          psElement^.attr_data := Nil;
          psElement^.stype := DGNST_TEXT;
          DGNParseCore( psDGN, psElement );

          psText^.font_id := psDGN^.abyElem[36];
          psText^.justification := psDGN^.abyElem[37];
          psText^.length_mult := DGN_INT32(@psDGN^.abyElem[38])
              * psDGN^.scale * 6.0 / 1000.0;
          psText^.height_mult := DGN_INT32(@psDGN^.abyElem[42])
              * psDGN^.scale * 6.0 / 1000.0;

          if( psDGN^.dimension = 2 ) then Begin
              psText^.rotation := DGN_INT32(@psDGN^.abyElem[46]);
              psText^.rotation := psText^.rotation / 360000.0;

              psText^.origin.x := DGN_INT32(@psDGN^.abyElem[50]);
              psText^.origin.y := DGN_INT32(@psDGN^.abyElem[54]);
              psText^.origin.z := 0; //DGN_INT32(@psDGN^.abyElem[58]); //Pendiente, no se si va aquu
              text_off := 60;
          End else Begin
              (* leave quaternion for later *)

              psText^.origin.x := DGN_INT32(@psDGN^.abyElem[62]);
              psText^.origin.y := DGN_INT32(@psDGN^.abyElem[66]);
              psText^.origin.z := DGN_INT32(@psDGN^.abyElem[70]);
              text_off := 76;
          End;

          DGNTransformPoint( psDGN, @(psText^.origin) );

          (* experimental multibyte support from Ason Kang (hiska@netian.com)*)
          if (PByte( @psDGN^.abyElem[text_off])^ = $FF) And
               ( PByte( @psDGN^.abyElem[text_off + 1])^ = $FD) Then Begin
              n := 0;  //Pendiente
              for i := 0 To  num_chars Div 2 - 2 do Begin
                  CopyMemory(@w, @psDGN^.abyElem[text_off + 2 + i*2] ,2);
                  w := CPL_LSBWORD16(w); //Pendiente
                  if (w<256) Then begin // if alpa-numeric code area : Normal character
                      Byte(psText^._string^[n]) := w And $FF;
                      //(psText^._string + n)^ := w And $FF;
                      Inc(n); // skip 1 byte;
                  End else Begin // if extend code area : 2 byte Korean character
                      Byte(psText^._string^[n])  := w Shr 8;   // hi
                      Byte(psText^._string^[n + 1]) := w And $FF; // lo
                      Inc(n, 2); // 2 byte
                  End;
              End;
              psText^._string^[n] := Chr(0); // terminate C string //Pendiente
          End else Begin
              CopyMemory( psText^._string, @psDGN^.abyElem[text_off], num_chars );
              psText^._string^[num_chars] := Chr(0); //Pendiente
          End;
      End;

      DGNT_TCB:
        psElement := DGNParseTCB( psDGN );

      DGNT_COMPLEX_CHAIN_HEADER,
      DGNT_COMPLEX_SHAPE_HEADER:
      Begin
//          psHdr := PDGNElemComplexHeader(CPLCalloc(sizeof(DGNElemComplexHeader),1));
          GetMem(psHdr, sizeof(DGNElemComplexHeader));
          //FillChar(psHdr^, sizeof(DGNElemComplexHeader), 0);
          psElement := PDGNElemCore(psHdr);
          psElement^.raw_data := Nil;
          psElement^.attr_data := Nil;
          psElement^.stype := DGNST_COMPLEX_HEADER;
          DGNParseCore( psDGN, psElement );

          psHdr^.totlength := psDGN^.abyElem[36] + psDGN^.abyElem[37] * 256;
          psHdr^.numelems := psDGN^.abyElem[38] + psDGN^.abyElem[39] * 256;
      End;

      DGNT_TAG_VALUE:
      Begin
//          psTag := PDGNElemTagValue(CPLCalloc(sizeof(DGNElemTagValue),1));
          GetMem(psTag, sizeof(DGNElemTagValue));
          //FillChar(psTag^, sizeof(DGNElemTagValue), 0);
          psElement := PDGNElemCore(psTag);
          psElement^.raw_data := Nil;
          psElement^.attr_data := Nil;
          psElement^.stype := DGNST_TAG_VALUE;
          DGNParseCore( psDGN, psElement );

          psTag^.tagType := psDGN^.abyElem[74] + psDGN^.abyElem[75] * 256;
          CopyMemory( @(psTag^.tagSet), @psDGN^.abyElem[68], 4 );
          psTag^.tagSet := Trunc(CPL_LSBWORD32(psTag^.tagSet)); //Pendiente
          psTag^.tagIndex := psDGN^.abyElem[72] + psDGN^.abyElem[73] * 256;
          psTag^.tagLength := psDGN^.abyElem[150] + psDGN^.abyElem[151] * 256;

          if( psTag^.tagType = 1 ) Then begin
              psTag^.tagValue._string :=
                  CPLStrdup( PChar(@psDGN^.abyElem[154]) ); //Pendiente
          End else if( psTag^.tagType = 3 ) Then Begin
              CopyMemory( @(psTag^.tagValue._integer),
                      Pointer(@psDGN^.abyElem[154]), 4 );
              psTag^.tagValue._integer :=
                  CPL_LSBWORD32( psTag^.tagValue._integer ); //Pendiente
          End else if( psTag^.tagType = 4 ) Then begin
              CopyMemory( @(psTag^.tagValue._real),
                      @psDGN^.abyElem[154], 8 );
              vax2ieee( @(psTag^.tagValue._real) );
          end;
      End;

      DGNT_APPLICATION_ELEM:
        if( nLevel = 24 ) Then Begin
            psElement := DGNParseTagSet( psDGN );
        End else Begin
//            psElement := PDGNElemCore(CPLCalloc(sizeof(DGNElemCore),1));
            GetMem(psElement, sizeof(DGNElemCore));
            //FillChar(psElement^, sizeof(DGNElemCore), 0);
            psElement^.stype := DGNST_CORE;
            psElement^.raw_data := Nil;
            psElement^.attr_data := Nil;
            DGNParseCore( psDGN, psElement );
        End;

      Else
      Begin
//          psElement := PDGNElemCore(CPLCalloc(sizeof(DGNElemCore),1));
          GetMem(psElement, sizeof(DGNElemCore));
          //FillChar(psElement^, sizeof(DGNElemCore), 0);
          psElement^.stype := DGNST_CORE;
          DGNParseCore( psDGN, psElement );
      End;
    End;

(* -------------------------------------------------------------------- *)
(*      If the element structure type is "core" or if we are running    *)
(*      in "capture all" mode, record the complete binary image of      *)
(*      the element.                                                    *)
(* -------------------------------------------------------------------- *)
    if ( psElement^.stype = DGNST_CORE) Or
        ((psDGN^.options And DGNO_CAPTURE_RAW_DATA) > 0) Then Begin
        psElement^.raw_bytes := psDGN^.nElemBytes;
//        psElement^.raw_data := PByte(CPLMalloc(psElement^.raw_bytes));
        GetMem(psElement^.raw_data, psElement^.raw_bytes);
        //FillChar(psElement^.raw_data^, psElement^.raw_bytes, 0);
        CopyMemory( psElement^.raw_data, @psDGN^.abyElem, psElement^.raw_bytes );
    End;

(* -------------------------------------------------------------------- *)
(*      Collect some additional generic information.                    *)
(* -------------------------------------------------------------------- *)
    psElement^.element_id := psDGN^.next_element_id - 1;

    psElement^.offset := psDGN^.fp.Position - psDGN^.nElemBytes;
    psElement^.size := psDGN^.nElemBytes;

    Result := psElement;
End;

(************************************************************************)
(*                           DGNReadElement()                           *)
(************************************************************************)

(**
 * Read a DGN element.
 *
 * This function will return the next element in the file, starting with the
 * first.  It is affected by DGNGotoElement() calls.
 *
 * The element is read into a structure which includes the DGNElemCore
 * structure.  It is expected that applications will inspect the stype
 * field of the returned DGNElemCore and use it to cast the pointer to the
 * appropriate element structure type such as DGNElemMultiPoint.
 *
 * @param hDGN the handle of the file to read from.
 *
 * @return pointer to element structure, or NULL on EOF or processing error.
 * The structure should be freed with DGNFreeElement() when no longer needed.
 *)

Function DGNReadElement( hDGN : DGNHandle ) : PDGNElemCore;
Var
    psDGN :PDGNInfo;
    psElement : PDGNElemCore;
    nType, nLevel: SmallInt;
    bInsideFilter : Boolean;
    nXMin, nXMax, nYMin, nYMax : Cardinal;
begin
    psDGN := PDGNInfo(hDGN);

(* -------------------------------------------------------------------- *)
(*      Load the element data into the current buffer.  If a spatial    *)
(*      filter is in effect, loop until we get something within our     *)
(*      spatial constraints.                                            *)
(* -------------------------------------------------------------------- *)
    Repeat
        bInsideFilter := True;

        if( not DGNLoadRawElement( psDGN, @nType, @nLevel )) Then Begin
            Result := Nil;
            Exit;
        End;

        if( psDGN^.has_spatial_filter ) Then Begin
            if( not psDGN^.sf_converted_to_uor) Then ;
                DGNSpatialFilterToUOR( psDGN );

            if( Not DGNGetElementExtents( psDGN, nType,
                                       @nXMin, @nYMin, Nil,
                                       @nXMax, @nYMax, Nil ) ) Then Begin
                (* If we don't have spatial characterists for the element
                   we will pass it through. *)
                bInsideFilter := True;
            End else if( nXMin > psDGN^.sf_max_x) Or
                       (nYMin > psDGN^.sf_max_y) Or
                       (nXMax < psDGN^.sf_min_x) Or
                       (nYMax < psDGN^.sf_min_y ) Then
                bInsideFilter := False;

            (*
            ** We want to select complex elements based on the extents of
            ** the header, not the individual elements.
            *)
            if( (psDGN^.abyElem[0] And $80) <> 0(* complex flag set *) ) Then Begin
                if( nType = DGNT_COMPLEX_CHAIN_HEADER)
                    Or (nType = DGNT_COMPLEX_SHAPE_HEADER ) Then Begin
                    psDGN^.in_complex_group := TRUE;
                    psDGN^.select_complex_group := bInsideFilter;
                End else if( psDGN^.in_complex_group) Then
                    bInsideFilter := psDGN^.select_complex_group;
            End else psDGN^.in_complex_group := False;
        End;
    until bInsideFilter;

(* -------------------------------------------------------------------- *)
(*      Convert into an element structure.                              *)
(* -------------------------------------------------------------------- *)
    psElement := DGNProcessElement( psDGN, nType, nLevel );

    Result := psElement;
end;

(************************************************************************)
(*                            DGNParseCore()                            *)
(************************************************************************)

Function DGNParseCore( psDGN : PDGNInfo; psElement :PDGNElemCore) : Boolean;
Var
  psData : PByteArray;
  nAttIndex : SmallInt;
Begin
    psData := PByteArray(@psDGN^.abyElem);

    psElement^.level := psData[0] And $3f;
    psElement^.complex := psData[0] And $80;
    psElement^.deleted := psData[1] And $80;
    psElement^._type := psData[1] And $7f;

    if( psDGN^.nElemBytes >= 36 )
        And (psElement^._type <> DGNT_CELL_LIBRARY ) Then Begin
        psElement^.graphic_group := psData[28] + psData[29] * 256;
        psElement^.properties := psData[32] + psData[33] * 256;
        psElement^.style := psData[34] And $7;
        psElement^.weight := (psData[34] And $f8) Shr 3;
        psElement^.color := psData[35];
    End;

    if (psElement^.properties And DGNPF_ATTRIBUTES) > 0 Then Begin
        nAttIndex := psData[30] + psData[31] * 256;
        psElement^.attr_bytes := psDGN^.nElemBytes - nAttIndex*2 - 32;
//        psElement^.attr_data := PBYTE(CPLMalloc(psElement^.attr_bytes));
        GetMem(psElement^.attr_data, psElement^.attr_bytes);
        //FillChar(psElement^.attr_data^, psElement^.attr_bytes, 0);
        CopyMemory( psElement^.attr_data, @psData[nAttIndex * 2 + 32],
                psElement^.attr_bytes );
    End Else psElement^.attr_data := Nil;

    Result := True;
end;

(************************************************************************)
(*                         DGNParseColorTable()                         *)
(************************************************************************)

Function DGNParseColorTable( psDGN : PDGNInfo ) : PDGNElemCore;
Var
    psElement : PDGNElemCore;
    psColorTable : PDGNElemColorTable;
Begin

//    psColorTable := PDGNElemColorTable(CPLCalloc(sizeof(DGNElemColorTable),1));
    GetMem(psColorTable, sizeof(DGNElemColorTable));
    //FillChar(psColorTable^, sizeof(DGNElemColorTable), 0);
    psElement := PDGNElemCore(psColorTable);
    psElement^.stype := DGNST_COLORTABLE;

    DGNParseCore( psDGN, psElement );

    psColorTable^.screen_flag :=
        psDGN^.abyElem[36] + psDGN^.abyElem[37] * 256;

    CopyMemory( @psColorTable^.color_info, @psDGN^.abyElem[41], 768 );
    if( psDGN^.got_color_table = 0 ) Then Begin
        CopyMemory( @psDGN^.color_table, @psColorTable^.color_info, 768 );
        psDGN^.got_color_table := 1;
    End;

    Result := psElement;
End;

(************************************************************************)
(*                           DGNParseTagSet()                           *)
(************************************************************************)

Function DGNParseTagSet( psDGN : PDGNInfo ) : PDGNElemCore;
var
    psElement : PDGNElemCore;
    psTagSet : PDGNElemTagSet;
    nDataOffset, iTag : SmallInt;
    tagDef : PDGNTagDef;
Begin

//    psTagSet := PDGNElemTagSet(CPLCalloc(sizeof(DGNElemTagSet),1));
    GetMem(psTagSet, sizeof(DGNElemTagSet));
    //FillChar(psTagSet^, sizeof(DGNElemTagSet), 0);
    psElement := PDGNElemCore(psTagSet);
    psElement^.stype := DGNST_TAG_SET;

    DGNParseCore( psDGN, psElement );

(* -------------------------------------------------------------------- *)
(*      Parse the overall information.                                  *)
(* -------------------------------------------------------------------- *)
    psTagSet^.tagCount :=
        psDGN^.abyElem[44] + psDGN^.abyElem[45] * 256;
    psTagSet^.flags :=
        psDGN^.abyElem[46] + psDGN^.abyElem[47] * 256;
    psTagSet^.tagSetName := CPLStrdup( PChar(@psDGN^.abyElem[48]) ); //Pendiente

(* -------------------------------------------------------------------- *)
(*      Get the tag set number out of the attributes, if available.     *)
(* -------------------------------------------------------------------- *)
    psTagSet^.tagSet := -1;

    if( psElement^.attr_bytes >= 8)
        And (psElement^.attr_data[0] = $03)
        And (psElement^.attr_data[1] = $10)
        And (psElement^.attr_data[2] = $2f)
        And (psElement^.attr_data[3] = $7d ) Then
        psTagSet^.tagSet := psElement^.attr_data[4]
            + psElement^.attr_data[5] * 256;

(* -------------------------------------------------------------------- *)
(*      Parse each of the tag definitions.                              *)
(* -------------------------------------------------------------------- *)
//    psTagSet^.tagList := PDGNTagDef(CPLMalloc(sizeof(DGNTagDef) * psTagSet^.tagCount));
    GetMem(psTagSet^.tagList, sizeof(DGNTagDef) * psTagSet^.tagCount);
    //FillChar(psTagSet^.tagList^, sizeof(DGNTagDef) * psTagSet^.tagCount, 0);

    nDataOffset := 48 + Length(psTagSet^.tagSetName) + 1 + 1;

    for iTag := 0 To psTagSet^.tagCount - 1 Do
    Begin
        tagDef := @psTagSet^.tagList[iTag];

        //CPLAssert( nDataOffset < psDGN^.nElemBytes );

        (* collect tag name. *)
        tagDef^.name := CPLStrdup( PChar(@psDGN^.abyElem[nDataOffset])); //Pendiente
        nDataOffset := nDataOffset + Length(tagDef^.name)+1; //Pendiente

        (* Get tag id *)
        tagDef^.id := psDGN^.abyElem[nDataOffset]
            + psDGN^.abyElem[nDataOffset+1] * 256;
        nDataOffset := nDataOffset + 2;

        (* Get User Prompt *)
        tagDef^.prompt := CPLStrdup( PChar(@psDGN^.abyElem[nDataOffset]));
        nDataOffset := nDataOffset + Length(tagDef^.prompt)+1; //Pendiente


        (* Get type *)
        tagDef^._type := psDGN^.abyElem[nDataOffset]
            + psDGN^.abyElem[nDataOffset+1] * 256;
        nDataOffset := nDataOffset + 2;

        (* skip five zeros *)
        Inc(nDataOffset, 5);

        (* Get the default *)
        if( tagDef^._type = 1 ) Then Begin
            tagDef^.defaultValue._string :=
                CPLStrdup( PChar(@psDGN^.abyElem[nDataOffset]) );
            nDataOffset := nDataOffset + Length(tagDef^.defaultValue._string)+1; //Pendiente
        End else if( tagDef^._type = 3) Or (tagDef^._type = 5 ) Then Begin
            CopyMemory( @(tagDef^.defaultValue._integer),
                    @psDGN^.abyElem[nDataOffset], 4 );
            tagDef^.defaultValue._integer :=
                Trunc(CPL_LSBWORD32( tagDef^.defaultValue._integer )); //Pendiente
            nDataOffset := nDataOffset + 4;
        End else if( tagDef^._type = 4 ) Then Begin
            CopyMemory( @(tagDef^.defaultValue._real),
                    @psDGN^.abyElem[nDataOffset], 8 );
            vax2ieee( @(tagDef^.defaultValue._real) );
            nDataOffset := nDataOffset + 8;
        End else nDataOffset := nDataOffset + 4;
    End;
    result := psElement;
End;

(************************************************************************)
(*                            DGNParseTCB()                             *)
(************************************************************************)

Function DGNParseTCB( psDGN : PDGNInfo) : PDGNElemCore;
Var
    psTCB : PDGNElemTCB;
    psElement : PDGNElemCore;
Begin

//    psTCB := PDGNElemTCB(CPLCalloc(sizeof(DGNElemTCB),1));
    GetMem(psTCB, sizeof(DGNElemTCB));
    //FillChar(psTCB^, sizeof(DGNElemTCB), 0);
    psElement := PDGNElemCore(psTCB);
    psElement^.stype := DGNST_TCB;
    DGNParseCore( psDGN, psElement );

    if( (psDGN^.abyElem[1214] And $40) <> 0 ) Then
        psTCB^.dimension := 3
    else
        psTCB^.dimension := 2;

    psTCB^.subunits_per_master := DGN_INT32(@psDGN^.abyElem[1112]);

    psTCB^.master_units[0] := char(psDGN^.abyElem[1120]);
    psTCB^.master_units[1] := char(psDGN^.abyElem[1121]);
    psTCB^.master_units[2] := Chr(0);

    psTCB^.uor_per_subunit := DGN_INT32(@psDGN^.abyElem[1116]);

    psTCB^.sub_units[0] := char(psDGN^.abyElem[1122]);
    psTCB^.sub_units[1] := char(psDGN^.abyElem[1123]);
    psTCB^.sub_units[2] := Chr(0);

    (* Get global origin *)
    CopyMemory( @(psTCB^.origin_x), @psDGN^.abyElem[1240], 8 );
    CopyMemory( @(psTCB^.origin_y), @psDGN^.abyElem[1248], 8 );
    CopyMemory( @(psTCB^.origin_z), @psDGN^.abyElem[1256], 8 );
       //Cambiar aqui
    (* Transform to IEEE *)
    vax2ieee( @(psTCB^.origin_x) );
    vax2ieee( @(psTCB^.origin_y) );
    vax2ieee( @(psTCB^.origin_z) );

    (* Convert from UORs to master units. *)
    if (psTCB^.uor_per_subunit <> 0)
        And (psTCB^.subunits_per_master <> 0 ) Then Begin
        psTCB^.origin_x := psTCB^.origin_x /
            (psTCB^.uor_per_subunit * psTCB^.subunits_per_master);
        psTCB^.origin_y := psTCB^.origin_y /
            (psTCB^.uor_per_subunit * psTCB^.subunits_per_master);
        psTCB^.origin_z := psTCB^.origin_z /
            (psTCB^.uor_per_subunit * psTCB^.subunits_per_master);
    End;

    if( psDGN^.got_tcb = 0) Then Begin
        psDGN^.got_tcb := Ord(True);
        psDGN^.dimension := psTCB^.dimension;
        psDGN^.origin_x := psTCB^.origin_x;
        psDGN^.origin_y := psTCB^.origin_y;
        psDGN^.origin_z := psTCB^.origin_z;

        if( psTCB^.uor_per_subunit <> 0)
            And (psTCB^.subunits_per_master <> 0 ) Then
            psDGN^.scale := 1 / (psTCB^.uor_per_subunit * psTCB^.subunits_per_master);
    End;

    Result := psElement;
End;

(************************************************************************)
(*                           DGNFreeElement()                           *)
(************************************************************************)

(**
 * Free an element structure.
 *
 * This function will deallocate all resources associated with any element
 * structure returned by DGNReadElement().
 *
 * @param hDGN handle to file from which the element was read.
 * @param psElement the element structure returned by DGNReadElement().
 *)

procedure DGNFreeElement( hDGN : DGNHandle; psElement : PDGNElemCore);
Var
  iTag : SmallInt;
  psTagSet :PDGNElemTagSet;
Begin
    if( psElement^.attr_data <> Nil ) Then
    Begin
        FreeMem(psElement^.attr_data);
        psElement^.attr_data := Nil;
    End;

    if psElement^.raw_data <> Nil Then
    Begin
        FreeMem(psElement^.raw_data);
        psElement^.raw_data := Nil;
    End;

    if psElement^.stype = DGNST_TAG_SET Then
    Begin

        psTagSet := PDGNElemTagSet(psElement);
        FreeMem( psTagSet^.tagSetName );

        for iTag := 0 To  psTagSet^.tagCount - 1 Do
        Begin
            FreeMem( psTagSet^.tagList[iTag].name );
            FreeMem( psTagSet^.tagList[iTag].prompt );

            if( psTagSet^.tagList[iTag]._type = 1 ) Then
                FreeMem( psTagSet^.tagList[iTag].defaultValue._string );
        End;
        FreeMem( psTagSet^.tagList );
    End else if( psElement^.stype = DGNST_TAG_VALUE ) Then
        if( (PDGNElemTagValue(psElement))^.tagType = 4 ) Then
            FreeMem( (PDGNElemTagValue(psElement))^.tagValue._string );

  FreeMem( psElement );
End;

(************************************************************************)
(*                             DGNRewind()                              *)
(************************************************************************)

(**
 * Rewind element reading.
 *
 * Rewind the indicated DGN file, so the next element read with
 * DGNReadElement() will be the first.  Does not require indexing like
 * the more general DGNReadElement() function.
 *
 * @param hDGN handle to file.
 *)

procedure DGNRewind( hDGN : DGNHandle );
Var
  psDGN : PDGNInfo;
Begin
    psDGN := PDGNInfo(hDGN);
    psDGN^.fp.Seek(0, soFromBeginning);
    psDGN^.next_element_id := 0;
    psDGN^.in_complex_group := False;
End;

(************************************************************************)
(*                         DGNTransformPoint()                          *)
(************************************************************************)

Procedure DGNTransformPoint( psDGN : PDGNInfo; psPoint : PDGNPoint );
Begin
    psPoint^.x := psPoint^.x * psDGN^.scale - psDGN^.origin_x;
    psPoint^.y := psPoint^.y * psDGN^.scale - psDGN^.origin_y;
//    psPoint^.z := psPoint^.z * psDGN^.scale - psDGN^.origin_z;
End;

(************************************************************************)
(*                      DGNInverseTransformPoint()                      *)
(************************************************************************)

Procedure DGNInverseTransformPoint( psDGN : PDGNInfo; psPoint : PDGNPoint );
Begin
    psPoint^.x := (psPoint^.x + psDGN^.origin_x) / psDGN^.scale;
    psPoint^.y := (psPoint^.y + psDGN^.origin_y) / psDGN^.scale;
    psPoint^.z := (psPoint^.z + psDGN^.origin_z) / psDGN^.scale;

    psPoint^.x := MAX(-2147483647,MIN(2147483647,psPoint^.x));
    psPoint^.y := MAX(-2147483647,MIN(2147483647,psPoint^.y));
    psPoint^.z := MAX(-2147483647,MIN(2147483647,psPoint^.z));
End;

(************************************************************************)
(*                         DGNGetElementIndex()                         *)
(************************************************************************)

(**
 * Fetch element index.
 *
 * This function will return an array with brief information about every
 * element in a DGN file.  It requires one pass through the entire file to
 * generate (this is not repeated on subsequent calls).
 *
 * The returned array of DGNElementInfo structures contain the level, type,
 * stype, and other flags for each element in the file.  This can facilitate
 * application level code representing the number of elements of various types
 * effeciently.
 *
 * Note that while building the index requires one pass through the whole file,
 * it does not generally request much processing for each element.
 *
 * @param hDGN the file to get an index for.
 * @param pnElementCount the integer to put the total element count into.
 *
 * @return a pointer to an internal array of DGNElementInfo structures (there
 * will be *pnElementCount entries in the array), or NULL on failure.  The
 * returned array should not be modified or freed, and will last only as long
 * as the DGN file remains open.
 *)

Function DGNGetElementIndex( hDGN : DGNHandle; pnElementCount : PSmallInt) : PDGNElementInfo;
Var
  psDGN : PDGNInfo;
Begin
    psDGN := PDGNInfo(hDGN);

    DGNBuildIndex( psDGN );

    if( pnElementCount <> Nil ) Then
        pnElementCount^ := psDGN^.element_count;

    Result := Pointer(@psDGN^.element_index);
End;

(************************************************************************)
(*                           DGNGetExtents()                            *)
(************************************************************************)

(**
 * Fetch overall file extents.
 *
 * The extents are collected for each element while building an index, so
 * if an index has not already been built, it will be built when
 * DGNGetExtents() is called.
 *
 * The Z min/max values are generally meaningless (0 and 0xffffffff in uor
 * space).
 *
 * @param hDGN the file to get extents for.
 * @param padfExtents pointer to an array of six doubles into which are loaded
 * the values xmin, ymin, zmin, xmax, ymax, and zmax.
 *
 * @return TRUE on success or FALSE on failure.
 *)

Function DGNGetExtents( hDGN : DGNHandle; padfExtents : DoubleArray) : Boolean;
Var
    psDGN : PDGNInfo;
    sMin, sMax : DGNPoint;
Begin
    psDGN := PDGNInfo(hDGN);
    DGNBuildIndex( psDGN );

    if( psDGN^.got_bounds = 0) Then Begin
        Result := False;
        Exit;
    End;

    sMin.x := psDGN^.min_x - 2147483648.0;
    sMin.y := psDGN^.min_y - 2147483648.0;
    sMin.z := psDGN^.min_z - 2147483648.0;

    DGNTransformPoint( psDGN, @sMin );

    padfExtents[0] := sMin.x;
    padfExtents[1] := sMin.y;
    padfExtents[2] := sMin.z;

    sMax.x := psDGN^.max_x - 2147483648.0;
    sMax.y := psDGN^.max_y - 2147483648.0;
    sMax.z := psDGN^.max_z - 2147483648.0;

    DGNTransformPoint( psDGN, @sMax );

    padfExtents[3] := sMax.x;
    padfExtents[4] := sMax.y;
    padfExtents[5] := sMax.z;

    Result := True;
End;

(************************************************************************)
(*                           DGNBuildIndex()                            *)
(************************************************************************)

Procedure DGNBuildIndex( psDGN : PDGNInfo );
Var
    nMaxElements, nType, nLevel : Smallint;
    nLastOffset : Longint;
    anRegion : Array [0..5] of Cardinal;
    psEI : PDGNElementInfo;
    psCT : PDGNElemCore;
    psTCB : PDGNElemCore;
Begin

    if( psDGN^.index_built <> 0) Then
        Exit;

    psDGN^.index_built := Ord(True);

    DGNRewind( psDGN );

    nMaxElements := 0;

    nLastOffset := psDGN^.fp.Position;
    while( DGNLoadRawElement( psDGN, @nType, @nLevel )) Do Begin

        if( psDGN^.element_count = nMaxElements ) Then Begin
            nMaxElements := Trunc((nMaxElements * 1.5) + 500);

//            psDGN^.element_index := PDGNElementInfo(CPLRealloc( psDGN^.element_index, nMaxElements * sizeof(DGNElementInfo) ));
            ReallocMem(psDGN^.element_index, nMaxElements * sizeof(DGNElementInfo));
        End;

        psEI := @psDGN^.element_index[psDGN^.element_count];
        psEI^.level := nLevel;
        psEI^._type := nType;
        psEI^.flags := 0;
        psEI^.offset := nLastOffset;

        if( (psDGN^.abyElem[0] And $80) <> 0 ) Then
            psEI^.flags := psEI^.flags Or DGNEIF_COMPLEX;

        if( (psDGN^.abyElem[1] And $80) <> 0 ) Then
            psEI^.flags := psEI^.flags Or DGNEIF_DELETED;

        if( nType = DGNT_LINE) Or (nType = DGNT_LINE_STRING)
            Or (nType = DGNT_SHAPE) Or (nType = DGNT_CURVE)
            Or (nType = DGNT_BSPLINE ) Then
              psEI^.stype := DGNST_MULTIPOINT
        else if( nType = DGNT_GROUP_DATA) And (nLevel = DGN_GDL_COLOR_TABLE ) Then Begin
            psCT := DGNParseColorTable( psDGN );
            DGNFreeElement( DGNHandle(psDGN), psCT );
            psEI^.stype := DGNST_COLORTABLE;

        End else if( nType = DGNT_ELLIPSE) Or ( nType = DGNT_ARC ) then
            psEI^.stype := DGNST_ARC

        else if( nType = DGNT_COMPLEX_SHAPE_HEADER )
                 Or ( nType = DGNT_COMPLEX_CHAIN_HEADER ) Then
            psEI^.stype := DGNST_COMPLEX_HEADER

        else if( nType = DGNT_TEXT ) Then
            psEI^.stype := DGNST_TEXT

        else if( nType = DGNT_TAG_VALUE ) Then
            psEI^.stype := DGNST_TAG_VALUE

        else if( nType = DGNT_APPLICATION_ELEM ) Then Begin
            if( nLevel = 24 ) Then
                psEI^.stype := DGNST_TAG_SET
            else
                psEI^.stype := DGNST_CORE;

        End else if( nType = DGNT_TCB ) Then Begin
            psTCB := DGNParseTCB( psDGN );
            DGNFreeElement( DGNHandle(psDGN), psTCB );
            psEI^.stype := DGNST_TCB;
        End else
            psEI^.stype := DGNST_CORE;

        if( (psEI^.flags And DGNEIF_DELETED) = 0)
            And ((psEI^.flags And DGNEIF_COMPLEX) = 0)
            And (DGNGetElementExtents( psDGN, nType,
                                     @anRegion[0], @anRegion[1], @anRegion[2],
                                     @anRegion[3], @anRegion[4], @anRegion[5] )) Then Begin
            if( psDGN^.got_bounds <> 0) Then Begin
                psDGN^.min_x := MIN(psDGN^.min_x, anRegion[0]);
                psDGN^.min_y := MIN(psDGN^.min_y, anRegion[1]);
                psDGN^.min_z := MIN(psDGN^.min_z, anRegion[2]);
                psDGN^.max_x := MAX(psDGN^.max_x, anRegion[3]);
                psDGN^.max_y := MAX(psDGN^.max_y, anRegion[4]);
                psDGN^.max_z := MAX(psDGN^.max_z, anRegion[5]);
            End else Begin
                CopyMemory( @(psDGN^.min_x), @anRegion, sizeof(Cardinal) * 6 );
                psDGN^.got_bounds := Ord(True);
            End;
        End;

        Inc(psDGN^.element_count);

        nLastOffset := psDGN^.fp.Position;
    End;

    DGNRewind( psDGN );

    psDGN^.max_element_count := nMaxElements;
End;


Function CPLStrdup( pszString : PChar) : PChar;
Begin
    if( pszString = Nil ) Then
        pszString := '';

    GetMem(Result, Length(pszString) + 1);
    //FillChar(Result^, Length(pszString) + 1, 0);
    strCopy(Result, pszString);
End;

(**************************************************
   DGNWrite................
 **************************************************)

Function DGNResizeElement( hDGN : DGNHandle; psElement : PDGNElemCore; nNewSize : SmallInt ) : Boolean;
Var
  psDGN : PDGNInfo;
  nOldFLoc : SmallInt;
  abyLeader : Array [0..1] of Byte;
  nWords : SmallInt;
  index : Integer;
Begin

  psDGN := PDGNInfo(hDGN);

{* -------------------------------------------------------------------- *}
{*      Check various conditions.                                       *}
{* -------------------------------------------------------------------- *}
    if (psElement^.raw_bytes = 0) Or
        (psElement^.raw_bytes <> psElement^.size) Then Begin
{        CPLError( CE_Failure, CPLE_AppDefined,
                  "Raw bytes not loaded, or not matching element size." );}
        Result := FALSE;
        Exit;
    End;

    if( nNewSize Mod 2 = 1 ) Then Begin
{        CPLError( CE_Failure, CPLE_AppDefined,
                  "DGNResizeElement(%d): "
                  "can't change to odd (not divisible by two) size.",
                  nNewSize );}
        Result := False;
        Exit;
    End;

    if( nNewSize = psElement^.raw_bytes ) Then Begin
        Result := True;
        Exit;
    End;

{ -------------------------------------------------------------------- }
{      Mark the existing element as deleted if the element has to      }
{      move to the end of the file.                                    }
{ -------------------------------------------------------------------- }

    if( psElement^.offset <> -1 ) Then Begin
        nOldFLoc := psDGN^.fp.Position;

        if( psDGN^.fp.Seek(psElement^.offset, soFromBeginning ) <> 0) Or
            (psDGN^.fp.DGNRead( @abyLeader, sizeof(abyLeader) ) <> 1 ) Then Begin
            {CPLError( CE_Failure, CPLE_AppDefined,
                      "Failed seek or read when trying to mark existing\n"
                      "element as deleted in DGNResizeElement()\n" );}
            Result := False;
            Exit;
        End;

        abyLeader[1] := abyLeader[1] Or $80;

        if( psDGN^.fp.seek( psElement^.offset, soFromBeginning ) <> 0) Or
            (psDGN^.fp.DGNWrite( @abyLeader, sizeof(abyLeader) ) <> 1 ) Then Begin
{            CPLError( CE_Failure, CPLE_AppDefined,
                      "Failed seek or write when trying to mark existing\n"
                      "element as deleted in DGNResizeElement()\n" );}
            Result := FALSE;
            Exit;
        End;

        psDGN^.fp.Seek( nOldFLoc, soFromBeginning );

        if( psElement^.element_id <> -1) And (psDGN^.index_built <> 0) Then
            psDGN^.element_index^[psElement^.element_id].flags :=
                psDGN^.element_index^[psElement^.element_id].flags Or DGNEIF_DELETED;
    End;

    psElement^.offset := -1; { move to end of file. }
    psElement^.element_id := -1;

{ -------------------------------------------------------------------- }
{      Set the new size information, and realloc the raw data buffer.  }
{ -------------------------------------------------------------------- }
    psElement^.size := nNewSize;
    ReallocMem( psElement^.raw_data, nNewSize );
    psElement^.raw_bytes := nNewSize;

{ -------------------------------------------------------------------- }
{      Update the size information within the raw buffer.              }
{ -------------------------------------------------------------------- }
    nWords := (nNewSize Div 2) - 2;

    Index := 2; psElement^.raw_data^[Index] := nWords Mod 256;
    Index := 3; psElement^.raw_data^[Index] := nWords Div 256;

    Result := True;
End;

{**********************************************************************}
{                          DGNWriteElement()                           }
{**********************************************************************}

Function DGNWriteElement( hDGN : DGNHandle; psElement : PDGNElemCore ) : Boolean;
Var
  psDGN : PDGNInfo;
  nJunk : SmallInt;
  psInfo : PDGNElementInfo;
  abyEOF : Array[0..1] of Byte;
Begin
    psDGN := PDGNInfo(hDGN);

{ ==================================================================== }
{      If this element hasn't been positioned yet, place it at the     }
{      end of the file.                                                }
{ ==================================================================== }
    if ( psElement^.offset = -1 ) Then Begin

        // We must have an index, in order to properly assign the
        // element id of the newly written element.  Ensure it is built.
        if( psDGN^.index_built = 0) Then
            DGNBuildIndex( psDGN );

        // Read the current "last" element.
        if( Not DGNGotoElement( hDGN, psDGN^.element_count-1 ) ) Then Begin
            Result := False;
            Exit;
        End;

        if( Not DGNLoadRawElement( psDGN, @nJunk, @nJunk ) ) Then begin
            Result := FALSE;
            Exit;
        end;

        // Establish the position of the new element.
        psElement^.offset := psDGN^.fp.Position;
        psElement^.element_id := psDGN^.element_count;

        // Grow element buffer if needed.
        if( psDGN^.element_count = psDGN^.max_element_count ) Then Begin
            psDGN^.max_element_count := psDGN^.max_element_count + 500;

{            psDGN^.element_index := PDGNElementInfo(CPLRealloc( psDGN^.element_index,
                            psDGN^.max_element_count * sizeof(DGNElementInfo)));}
            GetMem(psDGN^.element_index, psDGN^.max_element_count * sizeof(DGNElementInfo));
        End;

        // Set up the element info

        psInfo := @psDGN^.element_index[psDGN^.element_count];
        psInfo^.level := psElement^.level;
        psInfo^._type := psElement^._type;
        psInfo^.stype := psElement^.stype;
        psInfo^.offset := psElement^.offset;
        if( psElement^.complex <> 0 ) Then
            psInfo^.flags := DGNEIF_COMPLEX
        else
            psInfo^.flags := 0;

        Inc(psDGN^.element_count);
    End;

{ -------------------------------------------------------------------- }
{      Write out the element.                                          }
{ -------------------------------------------------------------------- }
    if (psDGN^.fp.Seek(psElement^.offset, soFromBeginning) <> 0) Or
        ( psDGN^.fp.DGNWrite(@psElement^.raw_data, psElement^.raw_bytes) <> psElement^.raw_bytes ) Then Begin
{        CPLError( CE_Failure, CPLE_AppDefined,
                  "Error seeking or writing new element of %d bytes at %d.",
                  psElement->offset,
                  psElement->raw_bytes );}
        Result := False;
        Exit;
    End;

    psDGN^.next_element_id := psElement^.element_id + 1;

{ -------------------------------------------------------------------- }
{      Write out the end of file 0xffff marker (if we were             }
{      extending the file), but push the file pointer back before      }
{      this EOF when done.                                             }
{ -------------------------------------------------------------------- }
    if( psDGN^.next_element_id = psDGN^.element_count ) Then Begin
        abyEOF[0] := $ff;
        abyEOF[1] := $ff;

        psDGN^.fp.DGNWrite( @abyEOF, 2);
        psDGN^.fp.Seek(-2, soFromCurrent);
    end;

    Result := True;
End;



(************************************************************************)
(*                            LoadTextEntity                            *)
(************************************************************************)

Function LoadTextEntity(psDGN : PDGNInfo; psText : PDGNElemText ) : TEzFittedVectorText;
Var

  TextEntityPoint: TEzPoint;
  rotation : Extended;
//  TextAlign : TAlignment;
  TextEntityHeight : Double;
  TextWidth : Double;
  minx, miny, maxx, maxy : Double;
  RadRotation : Double;

  Function CompareBoundary( Const p: TEzPoint ): TEzPoint;
  Begin
    If p.x < minx Then
      minx := p.x;
    If p.y < miny Then
      miny := p.y;
    If p.x > maxx Then
      maxx := p.x;
    If p.y > maxy Then
      maxy := p.y;
    result := p; //FConverter.Convert( p );
  End;
Begin
   maxx := 0; maxy := 0; minx := 0; miny := 0;
   rotation := psText^.rotation;
{   Case psText^.Justification Of
     0, 1, 2: TextAlign := taLeftJustify;
     6, 7, 8: TextAlign := taCenter;
     12, 13, 14: TextAlign := taRightJustify;
   End;     }

   //If Length(psText^._string^) > 1 Then
   Begin

     TextEntityHeight := psText^.height_mult;//{hgntmult} * {HeightQuotient} 0.006;
     TextWidth := psText^.length_mult;

     TextEntityPoint.X := psText^.Origin.X;
     TextEntityPoint.Y := psText^.Origin.Y + TextEntityHeight;
     TextEntityPoint := Compareboundary( TextEntityPoint );

     {                  if p < NextEleOfNode then
                       TextEntityHeight := TextEntityHeight + NodeLineSpc
                     else
                       TextEntityHeight := TextEntityHeight + TextEntityHeight * 0.35;
     }

     rotation := ( Round( rotation * 100 ) Mod 36000 ) / 100;
     RadRotation := DegToRad( rotation );

     If ( rotation = 0 ) Then
     Else If ( rotation > 0 ) And ( rotation < 90 ) Then
     Begin
       TextEntityPoint.X := TextEntityPoint.X - Sin( RadRotation ) * TextEntityHeight;
       TextEntityPoint.Y := TextEntityPoint.Y - ( 1 - Cos( RadRotation ) ) * TextEntityHeight;
     End
     Else If ( rotation = 90 ) Then
     Begin
       TextEntityPoint.X := TextEntityPoint.X - TextEntityHeight;
       TextEntityPoint.Y := TextEntityPoint.Y - TextEntityHeight;
     End
     Else If ( rotation > 90 ) And ( rotation < 180 ) Then
     Begin
       TextEntityPoint.X := TextEntityPoint.X - Cos( RadRotation - PI / 2 ) * TextEntityHeight;
       TextEntityPoint.Y := TextEntityPoint.Y - TextEntityHeight;
       TextEntityPoint.Y := TextEntityPoint.Y - Sin( RadRotation - PI / 2 ) * TextEntityHeight;
     End
     Else If ( rotation = 180 ) Then
     Begin
       TextEntityPoint.Y := TextEntityPoint.Y - TextEntityHeight * 2;
     End
     Else If ( rotation > 180 ) And ( rotation < 270 ) Then
     Begin
       TextEntityPoint.X := TextEntityPoint.X + Sin( RadRotation - PI ) * TextEntityHeight;
       TextEntityPoint.Y := TextEntityPoint.Y - TextEntityHeight;
       TextEntityPoint.Y := TextEntityPoint.Y - Cos( RadRotation - PI ) * TextEntityHeight;
     End
     Else If ( rotation = 270 ) Then
     Begin
       TextEntityPoint.X := TextEntityPoint.X + TextEntityHeight;
       TextEntityPoint.Y := TextEntityPoint.Y - TextEntityHeight;
     End
     Else If ( rotation > 270 ) And ( rotation < 360 ) Then
     Begin
       TextEntityPoint.X := TextEntityPoint.X + Cos( RadRotation - PI * ( 3 / 2 ) ) * TextEntityHeight;
       TextEntityPoint.Y := TextEntityPoint.Y - TextEntityHeight;
       TextEntityPoint.Y := TextEntityPoint.Y + Sin( RadRotation - PI * ( 3 / 2 ) ) * TextEntityHeight;
     End;

     TextEntityPoint := CompareBoundary( TextEntityPoint );

     Result := TEzFittedVectorText.CreateEntity(
       TextEntityPoint, psText^._string^, TextEntityHeight, TextWidth, DegToRad( rotation ) );
     Result.FontColor := DGNRGB(psDGN, psText^.core.color);
{    Result.PenTool.Color := RGB(psDGN^.color_table[Byte(psText^.core.color), 0],
                                 psDGN^.color_table[Byte(psText^.core.color), 1],
                                 psDGN^.color_table[Byte(psText^.core.color), 2]);}

     {                    TmpEntity.FBox.Emin.X := lswap(Elm_hdr.xLow);
                       TmpEntity.FBox.Emin.Y := lswap(Elm_hdr.yLow);
                       TmpEntity.FBox.Emax.X := lswap(Elm_hdr.xHigh);
                       TmpEntity.FBox.Emax.Y := lswap(Elm_hdr.yHigh);
     }

     //TEzJustifVectorText( Result ).FontColor := curpen.Color;
     //TEzJustifVectorText(TmpEntity).Alignment := TextAlign;
     TEzJustifVectorText( Result ).FontName := Ez_VectorFonts.DefaultFont.Name; //'Courier New';
   End;
End;

Function DGNRGB(hDGN : DGNHandle; Index : SmallInt) : TColor;
Var
  psInfo : PDGNInfo;
  tmp : Byte;
Begin
  psInfo := PDGNInfo(hDGN);

  if (Index < 0) Or (Index > 255) Then Begin
    Result := clBlack;
    Exit;
  End;

  if psInfo^.got_color_table = 0 Then
  Begin
    Result := RGB(DefColorTable[Index, 0],
                  DefColorTable[Index, 1],
                  DefColorTable[Index, 2]);
  End Else
  Begin
    tmp := psInfo^.color_table[Index, 0];
    Result := RGB(tmp,
                  psInfo^.color_table[Index, 1],
                  psInfo^.color_table[Index, 2]);
  end;
End;

Procedure dspExtent(hDGN : DGNHandle; DGNType : Integer; Memo : TMemo);
var
  pnXMin, pnYMin, pnZMin,
  pnXMax, pnYMax, pnZMax : Cardinal;
begin
  DGNGetElementExtents(hDGN, DGNType, @pnXMin, @pnYMin, @pnZMin,
                             @pnXMax, @pnYMax, @pnZMax);
  Memo.Lines.Add(IntToStr(DGNTYPE)  + ', ' +
                 FloatToStr(pnXMin) + ', ' +
                 FloatToStr(pnYMin) + ', ' +
                 FloatToStr(pnXMax) + ', ' +
                 FloatToStr(pnZMax));
end;


Procedure ImportDGN( pszFileName : PChar; Gis : TEzBaseGIS; Layer : TEzBaseLayer; Memo : TMemo);
Var

    hDGN : DGNHandle;
    psElement : PDGNElemCore;
    bRaw : Integer;
    achRaw : String[64];
    dfSFXMin, dfSFXMax, dfSFYMin, dfSFYMax : Double;

    e : TEzEntity;
    psLine : PDGNElemMultiPoint;
    psEllipse : PDGNElemArc;

    cnt : Integer;
    Rec : TEzRect;


  Function GetRect2DFromEllip( Const primary, secondary: double;
    Const origin: DGNPoint ): TEzRect;
  Begin
    Result.Emin.X := origin.X - primary;
    Result.Emax.X := origin.X + primary;
    Result.Emin.Y := origin.Y - secondary;
    Result.Emax.Y := origin.Y + secondary;
  End;

  Procedure SetPenStyle(Pen : TEzPenTool; Core : DGNElemCore);
  Begin
    With Pen.FPenStyle Do Begin
      Case Core.style Of
        0: style := 1;
        1: Style := 3;
        2: Style := 4;
        3: Style := 6;
        4: Style := 13;
        5: Style := 10;
        6: Style := 19;
        7: Style := 61;
      End;
      Pen.Scale := Core.weight / 100 - 0.01;
    End;
  End;

{$DEFINE SAVETEMPLATE}
{$IFDEF SAVETEMPLATE}
Var
  outfile : TDGNFileStream;
  tcbcnt : integer;
  savethis : Boolean;
{$ENDIF}

Begin
  outFile := nil;
    {$IFDEF SAVETEMPLATE}
    SaveThis := False;
    {$ENDIF}
    bRaw := Ord(False);
    dfSFXMin:=0.0;
    dfSFXMax:=0.0;
    dfSFYMin:=0.0;
    dfSFYMax:=0.0;

    FillChar( achRaw, 0, 64 );


    if( pszFilename = Nil ) Then Exit; //No se especifico el nombre de archivo

    hDGN := DGNOpen( pszFilename, Ord(False) );

    if( hDGN = Nil ) Then Exit;

    if( bRaw <> 0 ) Then DGNSetOptions( hDGN, DGNO_CAPTURE_RAW_DATA );

    DGNSetSpatialFilter( hDGN, dfSFXMin, dfSFYMin, dfSFXMax, dfSFYMax );


{$IFDEF SAVETEMPLATE}
    If SaveThis Then
      outfile := TDGNFileStream.Create('templatex.dgn', fmCreate);
    tcbcnt := 0;
{$ENDIF}
    psElement := DGNReadElement(hDGN);
    while psElement <> Nil Do
    Begin
      try
        if psElement^._type = DGNT_LINE Then
        Begin
          psLine := Pointer(psElement);
          if (psLine.vertices[0].x = psLine.vertices[1].x) And (psLine.vertices[0].y = psLine.vertices[1].y) Then
          Begin
            e := TEzPointEntity.CreateEntity(Point2D(psLine.vertices[1].x, psLine.vertices[0].y), DGNRGB(hDGN, psLine^.core.color));
          End
          Else
          Begin
            e := TEzPolyLine.CreateEntity([Point2D(psLine^.vertices[0].x, psLine^.vertices[0].y), Point2D(psLine^.vertices[1].x, psLine^.vertices[1].y){, Point2D(100, 100)}]);
            TEzPolyLine(e).PenTool.Color := DGNRGB(hDGN, psLine^.core.color);
            SetPenStyle(TEzOpenedEntity(e).PenTool, psLine^.core);
          End;
          Layer.AddEntity(e);
          e.Free;
        End
        else
        If psElement^._type In [DGNT_SHAPE , DGNT_CURVE,  DGNT_BSPLINE, DGNT_LINE_STRING] Then
        Begin
          psLine := Pointer(psElement);
{          If psElement^._type = DGNT_BSPLINE Then
            e := TEzSPLine.CreateEntity([Point2D(psLine^.vertices[0].x, psLine^.vertices[0].y)])
          Else    }
            e := TEzPolyLine.CreateEntity([Point2D(psLine^.vertices[0].x, psLine^.vertices[0].y)]);
          TEzPolyLine(e).PenTool.Color := DGNRGB(hDGN, psLine^.core.color);
          SetPenStyle(TEzOpenedEntity(e).PenTool, psLine^.core);
          For cnt := 1 To psLine^.num_vertices - 1 Do
            e.Points.Add(Point2D(psLine^.vertices[cnt].x, psLine^.vertices[cnt].y));
          Layer.AddEntity(e);
          e.Free;
        End
        else If psElement^._type In [DGNT_TEXT] Then
        Begin
{          e := LoadTextEntity(hDGN, Pointer(psElement));
          Layer.AddEntity(e);
          e.Free;              }
        End
        else If (psElement^._type In [DGNT_ELLIPSE]) Then
        Begin
          psEllipse := Pointer(psElement);
          Rec := GetRect2DFromEllip(psEllipse^.primary_axis, psEllipse^.secondary_axis, psEllipse^.origin);
          e := TEzEllipse.CreateEntity(Rec.Emin, Rec.Emax);
          TEzOpenedEntity(e).PenTool.Color := DGNRGB(hDGN, psEllipse^.core.color);
          SetPenStyle(TEzOpenedEntity(e).PenTool, psEllipse^.core);
          Layer.AddEntity(e);
          e.Free;
        End
        else
        If psElement^._type In [DGNT_ARC] Then
        Begin
          psEllipse := Pointer(psElement);
          e := TEzArc.CreateEntity(Point2D(0, 0), Point2D(0, 0), Point2D(0, 0));
          TEzArc(e).SetArc(psEllipse^.origin.x, psEllipse^.origin.y,
                             psEllipse^.primary_Axis, DegToRad(psEllipse^.Startang + psEllipse^.rotation), DegToRad(psEllipse^.sweepang), true );
          TEzOpenedEntity(e).PenTool.Color := DGNRGB(hDGN, psEllipse^.core.color);
          SetPenStyle(TEzOpenedEntity(e).PenTool, psEllipse^.core);
          Layer.AddEntity(e);
          e.Free;
        End;
      Except
        On Err : Exception Do
          MessageToUser(Err.Message,smsgerror,mb_iconerror);
      End;
{$IFDEF SAVETEMPLATE}
      if SaveThis And (tcbcnt < 1) Then
      Begin
        if psElement^._type = 9 then
          inc(tcbcnt);
        outFile.DGNWrite(@(pDGNInfo(hDGN)^.abyElem), pDGNInfo(hDGN)^.nElemBytes)
      End;
{$ENDIF}
      psElement := DGNReadElement(hDGN);
    End;
    DGNClose( hDGN );

{$IFDEF SAVETEMPLATE}
    if SaveThis Then
      outfile.Free;
{$ENDIF}

    GIS.UpdateExtension;
end;

Procedure GetRGB(Color : TColor; Var r, g ,b : Byte);
Begin
   r := Color And $000000FF;
   g := (Color And $0000FF00) Shr 8;
   b := (Color And $00FF0000) Shr 16;
End;


(*
  Esta funcion busca el color mas parcedido en una tabla de colores, donde LastIndex es la canti
  dad de elementos usados en tabla, en la parte baja de el resultado, regresa el indice del ele-
  mento en la tabla que mas se le acerca al parametro Color, y en la parte alta (del Result) re-
  gresa la dispercion, calculada con la funcion GetDisp, en caso de que se halla encontrado un
  elemento igual, la dispersion sera 0.
*)

Function GetIndexOfColor(Const Table : TPaletteArray; Color : TColor; LastIndex : SmallInt) : LongWord;
Var
  r1, g1, b1: Byte;
  r2, g2, b2 : Byte;
  Disp : Word;
  MinDisp : Word;
  MinDispIndex : SmallInt;
  Index : SmallInt;

  Function GetDisp(r1, r2, g1, g2, b1, b2: Byte) : Word;
  Begin
    Result := Abs(r1 - r2) + Abs(g1 - g2) + Abs(b1 - b2);
  End;

Begin
  MinDisp := $FFFF;
  GetRGB(Color, r1, g1, b1);
  Index := 0;
  MinDispIndex := 0;
  While Index < LastIndex Do
  Begin
    r2 := Table[Index, 0];
    g2 := Table[Index, 1];
    b2 := Table[Index, 2];
    Disp := GetDisp(r1, r2, g1, g2, b1, b2);
    if Disp = 0 Then
    Begin
      Result := Index;
      Exit;
    End Else If Disp < MinDisp Then
    Begin
      MinDisp := Disp;
      MinDispIndex := Index;
    End;
    Inc(Index);
  End;
  Result := (MinDispIndex And $0000FFFF) Or (MinDisp Shl 16);
End;


constructor TEzDGNExport.Create(AOwner: TComponent);
begin
  inherited Create(Aowner);
  Fsubunits_per_master:= 1000;
  Fuor_per_subunit:= 1;
  FMasterUnits:= 'm';
  FSubUnits:= 'mm';
  FBuffer := Nil;
  FBuffSize := 0;
end;

Procedure TEzDGNExport.CreateBuffer(Const Size : LongWord);
begin
  FBuffSize := Size;
  GetMem(FBuffer, Size);
end;

Procedure TEzDGNExport.ClearBuffer;
begin
  FillChar(FBuffer^, FBuffSize, 0);
end;

Procedure TEzDGNExport.FreeBuffer;
begin
  If FBuffSize > 0 Then
    FreeMem(FBuffer, FBuffSize);
end;

Procedure TEzDGNExport.CreateNewTable;
Begin
  if FUsedColors > 0 Then
    //Salvamos la tabla actual, con los cambios de colores que se le hicieron
    UpdateColorTable;
  //Limpiamos la tabla para utilizarla nuevamente
  FillChar(FColorTable, 256 * 3, 0);
  //Salvamos una nueva tabla en la posicion actual para reservar el espacio en disco.
  SaveColorTable(fp.Position);
  FUsedColors := 0;
End;

Function TEzDGNExport.AddColorToTable(Color : TColor) : SmallInt;
Var
  r, g, b : Byte;
  Index: SmallInt;
  dist,mindist,dr,dg,db: Integer;
Begin
  GetRGB(Color, r, g, b);
  If FUsedColors >= 256 Then
  Begin
    { find closest color }
    //CreateNewTable;
    { not found. choose the closest color }
    mindist:= System.MaxInt;
    Result:= 0;
    For Index:= 0 to 255 do
    Begin
      // luminosity = .299 red + .587 green + .114 blue
      dr:= (FColorTable[Index,0] - r) * 30;
      dg:= (FColorTable[Index,1] - g) * 59;
      db:= (FColorTable[Index,2] - b) * 11;
      dist:= dr * dr + dg * dg + db * db;
      If dist < mindist then
      begin
        mindist:= dist;
        Result:= Index;
      end;
    End;
    Exit;
  End;
  FColorTable[FUsedColors, 0] := r;
  FColorTable[FUsedColors, 1] := g;
  FColorTable[FUsedColors, 2] := b;
  result := FUsedColors;
  Inc(FUsedColors, 1);
End;

Procedure TEzDGNExport.SavePointsToBuffer(Points : TEzVector;
  Idx1,Idx2: Integer; Buffer : PByteArray);
Var
  Count : Integer;
  p : TEzPoint;
  tmp : Integer;
Begin
  For Count := Idx1 To Idx2 Do
  Begin
    p := Points[Count];
    tmp := Trunc(p.x * FDgnScale);
    tmp := DGN_INT32(@tmp);
    CopyMemory(@Buffer[(Count-Idx1) * 8], @tmp, 4);

    tmp := Trunc(p.y * FDgnScale);
    tmp := DGN_INT32(@tmp);
    CopyMemory(@Buffer[(Count-Idx1) * 8 + 4], @tmp, 4);
  End;
End;

Procedure TEzDGNExport.SetColor(Var Core : Byte; Color : TColor);
Var
  ColorIndex : LongInt;
  Disp : Word;
Begin
  ColorIndex := GetIndexOfColor(FColorTable, Color, FUsedColors);
  Disp := (ColorIndex And $FFFF0000) Shr 16;
  If Disp > 6 Then
  begin
    ColorIndex := AddColorToTable(Color)
  End Else
    ColorIndex := ColorIndex And $0000FFFF;
  Core := ColorIndex;
End;

Procedure TEzDGNExport.SetType(Buffer : PByteArray; DGNType : Byte;
  Level : Byte = 1; Complex : Boolean = False);
Begin
  If Complex Then
    Buffer[0] := Level Or $80
  Else
    Buffer[0] := Level;
  Buffer[1] := DGNType;
End;

Procedure TEzDGNExport.SetStyle( Pen : TEzPenTool; Core : PByteArray; Closed: Boolean );
Var
  Tmp : Byte;
  //SolidFlag: Byte;
Begin
  With Pen.FPenStyle Do
  Begin
  //weight and style
  Core[34] := Byte(Trunc((Width + 0.01) * 100)) Shl 3;
  //Scale := Core.weight / 100 - 0.01;

    Case style Of
       1: Tmp := 0;
       3: Tmp := 1;
       4: Tmp := 2;
       6: Tmp := 3;
      13: Tmp := 4;
      10: Tmp := 5;
      19: Tmp := 6;
      61: Tmp := 7;
    else
      tmp := 0;
    End;

    Core[34] := Core[34] Or Tmp;

  //Graphic Group
  Core[28] := 0;  Core[29] := 0;

  //Properties
  //SolidFlag:= 0;
  //if Closed then SolidFlag := 0;//128;
  Core[32] := 0;  Core[33] := 0;//2 Or SolidFlag;  // 2=new element 128 = hole(not filled)
  (*_*)//cambiar el SpolidFlag

  //Attributes index
  Core[30] := 0;
  Core[31] := 0;

  //Color
  SetColor(Core[35], Color);
  End;
End;

Procedure TEzDGNExport.SaveExtents( Buffer : PByteArray;  Const box: TEzRect );
var
  tmp:integer;
  {procedure showBytes(x : integer);
  var
    i : integer;
  begin
    for i := 0 To 3 Do
      ShowMessage(IntToStr( ( x And ($000000FF shl (i * 8)) ) shr (i * 8)));
  end; }
begin

  tmp:= Trunc(box.x1 * FDgnScale);
  tmp := DGN_INT32(@tmp);
  CopyMemory(@Buffer[4], @tmp, 4);
  Buffer[5] := Buffer[5] Xor $80;

  tmp:= Trunc(box.y1 * FDgnScale);
  tmp := DGN_INT32(@tmp);
  CopyMemory(@Buffer[8], @tmp, 4);
  Buffer[9] := Buffer[9] Xor $80;

  (*_*)
{  tmp := $0008;
  CopyMemory(@Buffer[12], @tmp, 4);  }

  tmp:= Trunc(box.x2 * FDgnScale);
  tmp := DGN_INT32(@tmp);
  CopyMemory(@Buffer[16], @tmp, 4);
  Buffer[17] := Buffer[17] Xor $80;

  tmp:= Trunc(box.y2 * FDgnScale);
  tmp := DGN_INT32(@tmp);
  CopyMemory(@Buffer[20], @tmp, 4);
  Buffer[21] := Buffer[21] Xor $80;

  (*_*)
{  tmp := $0008;
  CopyMemory(@Buffer[24], @tmp, 4);}

end;

Procedure TEzDGNExport.SaveTCB(Buffer : PByteArray; subunits_per_master, uor_per_subunit : Integer;
                  Const master_units, sub_units : String; const origin_x, origin_y : Double);
Var
  i : SmallInt;
  nWords : LongWord;
Begin

  SetType(Buffer, DGNT_TCB, $08);

  Buffer[1214] := $00; //$40 3 Dimension  others 2 Dimension
  PInteger(@Buffer[1112])^ := subunits_per_master;  PInteger(@Buffer[1112])^ := DGN_INT32(@Buffer[1112]);
  PInteger(@Buffer[1116])^ := uor_per_subunit;  PInteger(@Buffer[1116])^ := DGN_INT32(@Buffer[1116]);

  for i := 0 To 1 Do
    if i < Length(master_units) Then
      Buffer[1120 + i] := Ord(master_units[i+1])
    else
      Buffer[1120 + i] := 0;

  for i := 0 To 1 Do
    if i < Length(sub_units) Then
      Buffer[1122 + i] := Ord(sub_units[i+1])
    else
      Buffer[1122 + i] := 0;

//  PDouble(@Buffer[1240])^ := origin_x; ieee2vax(@Buffer[1240]);
//  PDouble(@Buffer[1248])^ := origin_y; ieee2vax(@Buffer[1248]);
//  PDouble(@Buffer[1256])^ := 0;        ieee2vax(@Buffer[1256]); //origin_z

  nWords := 766; //Default value for TCB
  Buffer[2] := nWords Mod 256;
  Buffer[3] := nWords Div 256;

  fp.Position:= FTCBOffset;
  fp.DGNWrite(Buffer, nWords * 2 + 4);
End;


Procedure TEzDGNExport.DGNExport(Gis : TEzBaseGis; Layers : TStrings;
  Const FileName, Template: String; ExplodeBlocks: Boolean );
Var
  nWords : LongWord;
  e : TEzEntity;
  Level: Integer;
  Layer: TEzBaseLayer;
  //ColorTableCreated: boolean;
  Symbol: TEzSymbol;
  Stream: TMemoryStream;
  Tx,Ty,MaxHeight,Sx,TmpHeight: Double;
  M: TEzMatrix;

  Procedure DoExport( TheEntity: TEzEntity );
  Begin
    nWords := 34;
    ClearBuffer;
    Case TheEntity.EntityID Of
      idPolyLine, idSpline, idRectangle, idPolygon:
        SaveMultiPointEntity(TheEntity, Level);

      idPoint, idPlace:
        SavePlace(TheEntity, Level, nWords);

      idEllipse:
        SaveEllipse(TheEntity, Level, nWords);

      idFittedVectText, idTrueTypeText:
        SaveText(TheEntity, Level, nWords);
        // warning!!! TEzJustifVectorText are not yet exported

      idArc:
        SaveArc(TheEntity, Level, nWords);
    End;
  End;

  Procedure DoExportSymbol( S: TEzSymbol; const Text: string;
    const Transform: TEzMatrix );
  var
    I: Integer;
    Found: Boolean;
    Tmpe: TEzEntity;
  Begin
    Found:= False;
    For I:= 0 to S.Count-1 do
    begin
      Tmpe:= S.Entities[I];
      If ( Length( Text ) > 0 ) And Not Found Then
      Begin
        If Tmpe.EntityID = idJustifVectText Then
        Begin
          TEzJustifVectorText( Tmpe ).Text := Text;
          Found:= true;
        End Else If Tmpe.EntityID = idFittedVectText Then
        Begin
          TEzFittedVectorText( Tmpe ).Text := Text;
          Found:= true;
        End Else If Tmpe.EntityID = idTrueTypeText Then
        Begin
          TEzTrueTypeText( Tmpe ).Text := Text;
          Found:= true;
        End;
      End;
      Tmpe.SetTransformMatrix(Transform);
      Tmpe.ApplyTransform;

      DoExport( Tmpe );

    end;
  End;

Begin

  If ( Layers = Nil ) Or ( Layers.Count = 0 )
    {$IFDEF WITH_TEMPLATE}Or Not FileExists(Template){$ENDIF} Then Exit;

  If FileExists(FileName) Then
  Begin
     SysUtils.DeleteFile(PChar(FileName));
    //ShowMessage('File already exists!!!');
    //Exit;
  End;

{$IFDEF WITH_TEMPLATE}
//  CopyFile( PChar( Template ), PChar( FileName ), False );
{$ENDIF}

{  Fsubunits_per_master := 12;
  Fuor_per_subunit := 25400;   }

  FDgnScale:= Fsubunits_per_master * Fuor_per_subunit;

  FUsedColors := 0;

  CreateBuffer(123456);
  ClearBuffer;

{$IFNDEF WITH_TEMPLATE}
  {Save a TCB <Terminal Control Block>}
  fp := TDGNFileStream.Create(FileName, fmCreate);
  FTCBOffset:= 0;
  SaveTCB(Buffer, Fsubunits_per_master, Fuor_per_subunit, FMasterUnits, FSubUnits, 0, 0);
{$ELSE}
  (*Load a TCB From Template*)
  fp := TDGNFileStream.Create( Template, fmOpenReadWrite or fmShareDenyNone );
  fp.DGNRead(FBuffer, 766 * 2 + 4);
  fp.Free;

  fp := TDGNFileStream.Create( FileName, fmCreate or fmShareDenyNone );
  SaveTCB(FBuffer, Fsubunits_per_master, Fuor_per_subunit, FMasterUnits, FSubUnits, 0, 0);
{$ENDIF}
  Try

{.$IFNDEF WITH_TEMPLATE}
    //ColorTableCreated:= True;
    CreateNewTable;
{.$ENDIF}

    For Level:= 1 to Layers.Count do
    begin
      Layer:= GIS.Layers.LayerByName( Layers[Level - 1] );
      If Layer = Nil then Continue;

      Layer.First;
      While NOt Layer.Eof Do
      Try
        If Layer.RecIsDeleted Then Continue;
        e := Layer.RecLoadEntity;
        If e = Nil Then Continue;
        Try
            If ExplodeBlocks and (e.EntityID=idPlace) And
              (TEzPlace(e).Symboltool.Index >=0) And
              (TEzPlace(e).Symboltool.Index <=Ez_Symbols.Count-1) And
              (TEzPlace(e).Symboltool.Height>0) And
              (Ez_Symbols[TEzPlace(e).Symboltool.Index].Count>0) Then
            Begin
              TmpHeight:= TEzPlace(e).Symboltool.Height;
              Stream:= TMemoryStream.Create;
              Symbol:= TEzSymbol.Create(Nil);
              Try
                Ez_Symbols[TEzPlace(e).Symboltool.Index].SaveToStream( Stream );
                Stream.Position:= 0;
                Symbol.LoadFromStream(Stream);

                { Move the symbol centroid to 0,0 then translate to point of place }
                Tx := -Symbol.Centroid.X + TEzPlace(e).Points[0].X;
                Ty := -Symbol.Centroid.Y + TEzPlace(e).Points[0].Y;
                { Create the scale matrix }
                With Symbol.Extension Do
                Begin
                  MaxHeight := dMax( Emax.X - Emin.X, Emax.Y - Emin.Y );
                  Sx := TmpHeight / MaxHeight;
                End;

                M := BuildTransformationMatrix( Sx, Sx,
                  TEzPlace(e).Symboltool.Rotangle, Tx, Ty, Symbol.Centroid );

                DoExportSymbol( Symbol, TEzPlace(e).Text, M );

              Finally
                Symbol.Free;
                Stream.Free;
              End;
            End Else If ExplodeBlocks and (e.EntityID=idBlockInsert) And
             (TEzBlockInsert(e).Block.Count>0) Then
            Begin
              With TEzBlockInsert(e) do
              begin
                M := BuildTransformationMatrix( ScaleX, ScaleY, Rotangle,
                  -Block.Centroid.X + Points[0].X, -Block.Centroid.Y + Points[0].Y, Block.Centroid );

                DoExportSymbol( Block, Text, M );

              end;
            End Else
            Begin
              DoExport( e );
            End;

        Finally
          e.Free;
        End;
      Finally
        Layer.Next;
      End;

    End;

    if FUsedColors > 0 Then
      UpdateColorTable;

    // Enf of file marker
    fp.Position:= fp.Size;
    FBuffer[0] := $FF;
    FBuffer[1] := $FF;
    fp.DGNWrite(FBuffer, 4);

  Finally
    fp.Free;
    FreeBuffer;
    //FreeMem( FBuffer, FBuffSize );
  End;

End;

procedure TEzDGNExport.SaveColorTable(Position : Integer);
Var
  Tablebuffer : PByteArray;
  BuffSize : Integer;
  nWords : Word;
  aByte : Byte;
begin
  //Apartando memoria para guardar la cabecera del elemento
  BuffSize := 42;
  GetMem(TableBuffer, BuffSize);
  FillChar(TableBuffer^, 0, BuffSize);

  SetType( TableBuffer, DGNT_GROUP_DATA, 1 );
  nWords := BuffSize + 256 * 3 - 4;
  TableBuffer[2] := (nWords Div 2) Mod 256;
  TableBuffer[3] := (nWords Div 2) Div 256;
  TableBuffer[32] := 1024 Mod 256;
  TableBuffer[33] := 1024 Div 256;
  TableBuffer[35] := 1;

  fp.Position := Position;
  fp.DGNWrite(TableBuffer, BuffSize);
  fp.Seek(-1, soFromCurrent);
  FTableColorOffset := fp.Position;
  fp.DGNWrite(@FColorTable, 256 * 3);
  aByte := 0;
  fp.DGNWrite(@aByte, 1);
  FreeMem(TableBuffer, BuffSize);
end;

procedure TEzDGNExport.SaveEllipse(Entity: TEzEntity;
  Level: Byte; var nWords : LongWord);
var
  e : TEzEllipse;
  tmpDouble : Double;
  tmpInt : Integer;
begin
  if Not (Entity is TEzEllipse) Then exit;
  e := Entity As TEzEllipse;
  SetStyle(e.PenTool, Pointer(FBuffer), true);
  SetType(FBuffer, DGNT_ELLIPSE, Level );

  //primary axis
  tmpDouble := (Abs(e.Points[0].x - e.Points[1].x) / 2) * FDgnScale;
  ieee2vax(@tmpDouble);
  CopyMemory(@FBuffer[36], @tmpDouble, 8);

  //Secondary axis
  tmpDouble := (Abs(e.Points[0].y - e.Points[1].y) / 2) * FDgnScale;
  ieee2vax(@tmpDouble);
  CopyMemory(@FBuffer[44], @tmpDouble, 8);

  //Rotation
  tmpInt := Trunc(e.RotAngle * FDgnScale);
  tmpInt := DGN_INT32(@tmpInt);
  CopyMemory(@FBuffer[52], @tmpInt, 4);

  tmpDouble := ((e.Points[0].x + e.Points[1].x) / 2) * FDgnScale;
  ieee2vax(@tmpDouble);
  CopyMemory(@FBuffer[56], @tmpDouble, 8);

  tmpDouble := ((e.Points[0].y + e.Points[1].y) / 2) * FDgnScale;
  ieee2vax(@tmpDouble);
  CopyMemory(@FBuffer[64], @tmpDouble, 8);

  Inc(nWords, 36);
  FBuffer[2] := (nWords Div 2) Mod 256;
  FBuffer[3] := (nWords Div 2) Div 256;

  SaveExtents( FBuffer, e.FBox );
  fp.DGNWrite(FBuffer, nWords + 4);
end;

Procedure TEzDGNExport.SaveArc(Entity : TEzEntity; Level : Byte; var nWords : LongWord);
var
  e : TEzArc;
  tmpDouble : Double;
  tmpInt : Integer;
begin

  If Not (Entity Is TEzArc) Then Exit;
  e := Entity As TEzArc;

  SetStyle(e.PenTool, Pointer(FBuffer), false);
  SetType(FBuffer, DGNT_ARC, Level);

  //Save a start angle
  tmpInt := Trunc(RadToDeg(e.StartAngle) * 360000);
  tmpInt := DGN_INT32(@tmpInt);
  CopyMemory(@FBuffer[36], @tmpInt, 4);

  tmpDouble := e.EndAngle - e.StartAngle;

  //Save a sweep angle
  tmpInt := Trunc(RadToDeg(tmpDouble) * 360000);
  tmpInt := DGN_INT32(@tmpInt);
  CopyMemory(@FBuffer[40], @tmpInt, 4);

  tmpDouble := Trunc(e.Radius * FDgnScale);
  ieee2vax(@tmpDouble);

  //primary axis and secondary axis are same in EzGIS
  CopyMemory(@FBuffer[44], @tmpDouble, 8);
  CopyMemory(@FBuffer[52], @tmpDouble, 8);

  //Rotation
  tmpInt := 0;
  CopyMemory(@FBuffer[60], @tmpInt, 4);

  tmpDouble := e.CenterX * FDgnScale;
  ieee2vax(@tmpDouble);
  CopyMemory(@FBuffer[64], @tmpDouble, 8);

  tmpDouble := e.CenterY * FDgnScale;
  ieee2vax(@tmpDouble);
  CopyMemory(@FBuffer[72], @tmpDouble, 8);

  Inc(nWords, 44);
  FBuffer[2] := (nWords Div 2) Mod 256;
  FBuffer[3] := (nWords Div 2) Div 256;

  SaveExtents( FBuffer, e.FBox );
  fp.DGNWrite(FBuffer, nWords + 4);
end;

procedure TEzDGNExport.SaveText(Entity: TEzEntity;
  Level: Byte; var nWords: LongWord);
var
  tmpDouble : Double;
  tmpInt : Integer;
  charWidth : Real;
  fitted : Boolean;
begin
  SetStyle(TEzOpenedEntity(Entity).PenTool, Pointer(FBuffer), false);
  SetType(FBuffer, DGNT_TEXT, Level);

  fitted := Entity.EntityID = idFittedVectText;

  If fitted Then
    SetColor(FBuffer[35], TEzFittedVectorText(Entity).FontColor)
  Else
    SetColor(FBuffer[35], TEzTrueTypeText(Entity).Fonttool.Color);

  FBuffer[36] := 3; //font_id
  FBuffer[37] := 0; //Justification
  If fitted Then
    FBuffer[58] := Length(TEzFittedVectorText(Entity).Text)
  Else
    FBuffer[58] := Length(TEzTrueTypeText(Entity).Text);

  If fitted Then Begin
    With Entity As TEzFittedVectorText Do
    charWidth := Width / Length(Text);
    tmpInt := Trunc(charWidth * FDgnScale / 6 * FDgnScale ) //width * MasterUntis
  End Else Begin
    With TEzTrueTypeText(Entity) Do
      charWidth := Dist2d(Points[1],Points[2]) / Length(Text);
      tmpInt := Trunc( charWidth * FDgnScale / 6 * FDgnScale); //width * MasterUntis
  End;

  tmpInt := DGN_INT32(@tmpInt);
  CopyMemory(@FBuffer[38], @tmpInt, 4);

  If fitted Then
    tmpInt := Trunc(TEzFittedVectorText(Entity).Height * FDgnScale / 6 * FDgnScale) //Height * MasterUntis
  Else
    tmpInt := Trunc(TEzTrueTypeText(Entity).Fonttool.Height * FDgnScale / 6 * FDgnScale); //Height * MasterUntis
  tmpInt := DGN_INT32(@tmpInt);
  CopyMemory(@FBuffer[42], @tmpInt, 4);

  If fitted then
    tmpDouble := TEzFittedVectorText(Entity).Angle
  else
    tmpDouble := TEzTrueTypeText(Entity).Fonttool.Angle;
  if tmpDouble < 0 Then
    tmpDouble := tmpDouble + twoPI;
  tmpInt := Trunc(RadToDeg(tmpDouble) * 360000);
  tmpInt := DGN_INT32(@tmpInt);
  CopyMemory(@FBuffer[46], @tmpInt, 4);

  tmpInt := Trunc(Entity.Points[1].x * FDgnScale); //1000 master untis
  tmpInt := DGN_INT32(@tmpInt);
  CopyMemory(@FBuffer[50], @tmpInt, 4);

  tmpInt := Trunc(Entity.Points[1].y * FDgnScale);
  tmpInt := DGN_INT32(@tmpInt);
  CopyMemory(@FBuffer[54], @tmpInt, 4);

  If fitted Then
    CopyMemory(@FBuffer[60], PChar(TEzFittedVectorText(Entity).Text), FBuffer[58])
  else
    CopyMemory(@FBuffer[60], PChar(TEzTrueTypeText(Entity).Text), FBuffer[58]);

  Inc(nWords, 60 - 38 + FBuffer[58]);
  if (FBuffer[58] Mod 2 <> 0) Then
    Inc(nWords, 1);
  FBuffer[2] := (nWords Div 2) Mod 256;
  FBuffer[3] := (nWords Div 2) Div 256;

  SaveExtents( FBuffer, Entity.FBox );
  fp.DGNWrite(FBuffer, nWords + 4);
end;

procedure TEzDGNExport.SavePlace(Entity: TEzEntity;
  Level: Byte; var nWords: LongWord);
var
  tmpPt : TEzPoint;
  tmpInt : Integer;
begin
  // This entity will be saved as a line that has two equal points
  SetType(FBuffer, DGNT_LINE, Level);
  tmpPt := Entity.Points[0];
  tmpInt := Trunc(tmpPt.x * FDgnScale);
  tmpInt := DGN_INT32(@tmpInt);
  // the two "x" are copied
  CopyMemory(@FBuffer[36], @tmpInt, 4);
  CopyMemory(@FBuffer[44], @tmpInt, 4);

  tmpInt := Trunc(tmpPt.y * FDgnScale);
  tmpInt := DGN_INT32(@tmpInt);
  // and now the to "y"
  CopyMemory(@FBuffer[40], @tmpInt, 4);
  CopyMemory(@FBuffer[48], @tmpInt, 4);
  Inc(nWords, 4 * 8); //Size of points in file
  //Save the color into FBuffer
  SetColor(FBuffer[35], TEzPointEntity(Entity).Color);
  SaveExtents( FBuffer, Entity.FBox );
  FBuffer[2] := (nWords Div 2) Mod 256;
  FBuffer[3] := (nWords Div 2) Div 256;
  fp.DGNWrite(FBuffer, nWords + 4);
end;

Function GetExtension(Points : TEzVector; Const idx1, idx2 : Integer) : TEzRect;
Var
  I: Integer;
  Item: TEzPoint;
Begin
  Result := INVALID_EXTENSION;
  For I := idx1 To idx2 Do
  Begin
    Item := Points[i];
    If Item.X > Result.X2 Then
      Result.X2 := Item.X;
    If Item.X < Result.X1 Then
      Result.X1 := Item.X;
    If Item.Y > Result.Y2 Then
      Result.Y2 := Item.Y;
    If Item.Y < Result.Y1 Then
      Result.Y1 := Item.Y;
  End;
End;

Procedure TEzDGNExport.SaveMultiPointEntity(Entity : TEzEntity; Level : Byte);
var
  idx1, idx2 : Integer;
  n : integer;
  DGNType : Integer;
  Points : TEzVector;

  Function GetDGNType : Integer;
  Begin
    Result := 0;
    Case Entity.EntityID Of
      idRectangle,
      idPolygon :
        Result := DGNT_SHAPE;

      idPolyLine :
        If Entity.Points.Count = 2 Then
          Result := DGNT_LINE
        Else
          Result := DGNT_LINE_STRING;

      idSPLine :
          Result := DGNT_CURVE;
    End;
  End;

Begin
  idx2 := -1;
  n := 0;
  DGNType := GetDGNType;
  If Entity.EntityID In [idRectangle, idSPLine] Then
    Points := Entity.DrawPoints
  Else
    Points := Entity.Points;
  Repeat
    idx1 := Succ(idx2);
    Inc(n);
    If n < Entity.Points.Parts.Count Then
      idx2 := Pred(Entity.Points.Parts[n])
    Else
      idx2 := Pred(Points.Count);

    SaveEntity(Points, TEzOpenedEntity(Entity).PenTool.Color, Level, idx1, idx2,
      DGNType, Entity Is TEzClosedEntity);

  Until idx2 >= Points.Count - 1;
End;


Procedure TEzDGNExport.SaveComplex(Extension : TEzRect; Level : Byte;
  ElemCount, ElemLength : Integer; Closed : Boolean);
var
  nWords : LongWord;
Begin
  ClearBuffer;
  If Closed Then
    SetType(FBuffer, DGNT_COMPLEX_SHAPE_HEADER, Level, False)
  Else
    SetType(FBuffer, DGNT_COMPLEX_CHAIN_HEADER, Level, False);

  SetColor(FBuffer[35], clBlack);

  FBuffer[36] := ElemLength Mod 256;
  FBuffer[37] := ElemLength Div 256;
  FBuffer[38] := ElemCount Mod 256;
  FBuffer[39] := ElemCount Div 256;

  SaveExtents(FBuffer, Extension);
  nWords := 36;
  FBuffer[2] := (nWords Div 2) Mod 256;
  FBuffer[3] := (nWords Div 2) Div 256;

  fp.DGNWrite(FBuffer, nWords + 4);
End;

Procedure TEzDGNExport.SaveEntity(Points : TEzVector; Color : TColor;
  Level : Byte; idx1, idx2 : Integer; DGN_TYPE : Integer; Closed : Boolean);
Var
  idx : Integer;
  Complex : Boolean;
  NPoints : Integer;
  nWords : LongWord;
  MaxPoints : Integer;
  ElemLength : Integer;
  ElemCount : Integer;
  ComplexExtents : TEzRect;
Begin
  MaxPoints := 90;
  Complex := Succ(idx2 - idx1) >  MaxPoints;
  If Complex Then
  Begin
    ElemCount := (idx2 - idx1) Div MaxPoints + 1;
    ElemLength := (ElemCount * 34 + (idx2 - idx1 + 1) * 8) Div 2 + ElemCount * 4 - 1;
    ComplexExtents := GetExtension(Points, idx1, idx2);
    SaveComplex(ComplexExtents, Level, ElemCount, ElemLength, Closed);
  End;
  While idx1 < idx2 Do Begin
    If idx2 - idx1 > MaxPoints Then
      idx := idx1 + MaxPoints
    Else
      idx := idx2;

    ClearBuffer;
    NPoints := Succ(Idx - idx1);
    If Complex Then
    Begin
      If DGN_TYPE = DGNT_SHAPE Then
        SetType(FBuffer, DGNT_LINE_STRING, Level, Complex)
      Else
        SetType(FBuffer, DGN_TYPE, Level, Complex);
    End Else
      SetType(FBuffer, DGN_TYPE, Level, Complex);

    If NPoints= 2 Then
    Begin { it is a line }
      SavePointsToBuffer(Points, idx1, idx, @FBuffer[36]);
      nWords := 32;
    End Else
    Begin
      nWords := 34;
      FBuffer[36] := NPoints Mod 256;
      FBuffer[37] := NPoints Div 256;
      SavePointsToBuffer(Points, idx1, idx, @FBuffer[38]);
    End;

    SetColor(FBuffer[35], Color);
    SaveExtents( FBuffer, GetExtension(Points, idx1, idx) );

    Inc(nWords, NPoints * 8);
    FBuffer[2] := (nWords Div 2) Mod 256;
    FBuffer[3] := (nWords Div 2) Div 256;

    fp.DGNWrite(FBuffer, nWords + 4);

    idx1 := idx;
  End;
End;

Procedure TEzDGNExport.UpdateColorTable;
Var
  LastPosition  : Integer;
Begin
  LastPosition := fp.Position;
  fp.Position := FTableColorOffset;
  fp.DGNWrite(@FColorTable, 256 * 3);
  fp.Position := LastPosition;
End;


end.


