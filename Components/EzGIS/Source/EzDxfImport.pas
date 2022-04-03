Unit EzDxfImport;

{***********************************************************}
{     EzGIS/CAD Components                                  }
{   (c) 2002 EzSoft Engineering                             }
{         All Rights Reserved                               }
{***********************************************************}

{$I EZ_FLAG.PAS}
Interface

Uses
  Windows, Classes, Graphics, SysUtils, Dialogs, Forms,
  EzDXFUtil, Controls,
  EzBase, EzBaseGIS, EzEntities, EzLib, EzSystem, EzImportBase, Math, EzCadCtrls;

Const
  // AutoCAD places a limit on this, but I don't know what it is
  max_vertices_per_polyline = 8192;
  MaxInt = High( Integer );
  MinInt = Low( Integer );
  max_attribs = 16; // I don't know what it is...
  max_my_attribs = 16;

Type

  Dxf_Object = Class; // forward declare

  { TEzDxfFile }
  TEzDxfFile = Class( TComponent )
  Private
    FFileName: String;
    FDrawBox: TEzBaseDrawBox;
    FDxf_Main: Dxf_Object;

    FOnFileProgress: TEzFileProgressEvent;

    Procedure SetDrawBox( Const Value: TEzBaseDrawBox );
  Protected
    Procedure Notification( AComponent: TComponent; Operation: TOperation ); Override;
  Public
    Destructor Destroy; Override;
    Property Dxf_Main: Dxf_Object Read FDxf_Main;
    Function ProperColor( clr: TColor ): TColor;
  Published
    { properties }
    Property FileName: String Read FFileName Write FFileName;
    Property DrawBox: TEzBaseDrawBox Read FDrawBox Write SetDrawBox;
    { events }
    Property OnFileProgress: TEzFileProgressEvent Read FOnFileProgress Write FOnFileProgress;
  End;

  { TEzDxfImport }
  TEzDxfImport = Class( TEzDxfFile )
  Private
    FConverter: TEzImportConverter;
    FMustDeleteConverter: Boolean;
    FLayerName: String; // LAYERNAME TO IMPORT/EXPORT
    FConfirmProjectionSystem: Boolean;
    FDxf_Emin: Point3D;
    FDxf_Emax: Point3D;
    FLayer: TEzBaseLayer;
    FDxfReferenceX: Double;
    FDxfReferenceY: Double;
    FDestReferenceX: Double;
    FDestReferenceY: Double;
    FImportLayerList: TStrings;
    FFullLayerList: TStrings;
    FTotalEntities: Integer;
    FTotalProcessed: Integer;
    FMsg: String;
    FExplodeBlocks: Boolean;
    FUseTrueType: Boolean;
    FCad: TEzCAD;
    FGenerateMultiLayers: Boolean;
    FTargetNames: TStrings;
    FImportBlocks: Boolean;

    FOnBeforeImport: TNotifyEvent;
    FOnAfterImport: TNotifyEvent;

    Procedure SetLayerName( Const Value: String );
    Procedure SetConverter( Value: TEzImportConverter );
    Function UpdateProgress: Boolean;
    {$IFDEF BCB}
    function GetConfirmProjectionSystem: Boolean;
    function GetDestReferenceX: Double;
    function GetDestReferenceY: Double;
    function GetDxf_Emax: Point3D;
    function GetDxf_Emin: Point3D;
    function GetDxfReferenceX: Double;
    function GetDxfReferenceY: Double;
    function GetExplodeBlocks: Boolean;
    function GetFullLayerList: TStrings;
    function GetImportLayerList: TStrings;
    function GetLayer: TEzBaseLayer;
    function GetLayerName: String;
    function GetOnAfterImport: TNotifyEvent;
    function GetOnBeforeImport: TNotifyEvent;
    function GetUseTrueType: Boolean;
    procedure SetConfirmProjectionSystem(const Value: Boolean);
    procedure SetDestReferenceX(const Value: Double);
    procedure SetDestReferenceY(const Value: Double);
    procedure SetDxf_Emax(const Value: Point3D);
    procedure SetDxf_Emin(const Value: Point3D);
    procedure SetDxfReferenceX(const Value: Double);
    procedure SetDxfReferenceY(const Value: Double);
    procedure SetExplodeBlocks(const Value: Boolean);
    {$ENDIF}
  Public
    Constructor Create( AOwner: TComponent ); Override;
    Destructor Destroy; Override;
    Function ReadDxf: Boolean;
    Function Execute: Boolean;
    Function ImportFiles( FileList: TStrings ): Boolean;

    Property ImportLayerList: TStrings {$IFDEF BCB} Read GetImportLayerList {$ELSE} Read FImportLayerList {$ENDIF};
    Property FullLayerList: TStrings {$IFDEF BCB}  Read GetFullLayerList {$ELSE} Read FFullLayerList{$ENDIF};
    Property Layer: TEzBaseLayer {$IFDEF BCB} Read GetLayer {$ELSE} Read FLayer{$ENDIF};
    Property Dxf_Emin: Point3D {$IFDEF BCB} Read GetDxf_Emin Write SetDxf_Emin {$ELSE} Read FDxf_Emin Write FDxf_Emin{$ENDIF};
    Property Dxf_Emax: Point3D {$IFDEF BCB}  Read GetDxf_Emax Write SetDxf_Emax {$ELSE} Read FDxf_Emax Write FDxf_Emax{$ENDIF};
    Property Converter: TEzImportConverter {$IFDEF BCB}  Read FConverter Write SetConverter {$ELSE} Read FConverter Write SetConverter{$ENDIF};
    Property Cad: TEzCAD read FCad;
    Property TargetNames: TStrings read FTargetNames;
    Property GenerateMultiLayers: Boolean read FGenerateMultiLayers write FGenerateMultiLayers;
  Published
    Property LayerName: String {$IFDEF BCB}  Read GetLayerName Write SetLayerName {$ELSE} Read FLayerName Write SetLayerName{$ENDIF};
    Property ConfirmProjectionSystem: Boolean {$IFDEF BCB} Read GetConfirmProjectionSystem Write SetConfirmProjectionSystem {$ELSE} Read FConfirmProjectionSystem Write FConfirmProjectionSystem{$ENDIF};
    Property DxfReferenceX: Double {$IFDEF BCB}  Read GetDxfReferenceX Write SetDxfReferenceX {$ELSE} Read FDxfReferenceX Write FDxfReferenceX{$ENDIF};
    Property DxfReferenceY: Double {$IFDEF BCB}  Read GetDxfReferenceY Write SetDxfReferenceY{$ELSE} Read FDxfReferenceY Write FDxfReferenceY{$ENDIF};
    Property DestReferenceX: Double {$IFDEF BCB}  Read GetDestReferenceX Write SetDestReferenceX {$ELSE} Read FDestReferenceX Write FDestReferenceX{$ENDIF};
    Property DestReferenceY: Double {$IFDEF BCB}  Read GetDestReferenceY Write SetDestReferenceY {$ELSE} Read FDestReferenceY Write FDestReferenceY{$ENDIF};
    Property ExplodeBlocks: Boolean {$IFDEF BCB}  Read GetExplodeBlocks Write SetExplodeBlocks {$ELSE} Read FExplodeBlocks Write FExplodeBlocks{$ENDIF};
    Property UseTrueType: Boolean {$IFDEF BCB}  read GetUseTrueType write FUseTrueType {$ELSE} read FUseTrueType write FUseTrueType{$ENDIF};
    Property ImportBlocks: Boolean read FImportBlocks write FImportBlocks default True;
    { events }
    Property OnBeforeImport: TNotifyEvent {$IFDEF BCB} Read GetOnBeforeImport Write FOnBeforeImport {$ELSE} Read FOnBeforeImport Write FOnBeforeImport{$ENDIF};
    Property OnAfterImport: TNotifyEvent {$IFDEF BCB}  Read GetOnAfterImport Write FOnAfterImport{$ELSE} Read FOnAfterImport Write FOnAfterImport{$ENDIF};
  End;

  { TEzDxfExport }
  TEzDxfExport = Class( TEzDxfFile )
  Private
    FLayerNames: TStrings;
    Procedure SetLayerNames( Const Value: TStrings );
    {$IFDEF BCB}
    function GetLayerNames: TStrings;
    {$ENDIF}
  Public
    Constructor Create( AOwner: TComponent ); Override;
    Destructor Destroy; Override;
    Function Execute: Boolean;
  Published
    Property LayerNames: TStrings {$IFDEF BCB} Read GetLayerNames {$ELSE} Read FLayerNames {$ENDIF} Write SetLayerNames;
  End;

  { start of original dxf_stru unit }
  polyface = Record
    nf: Array[0..3] Of integer;
  End;

  pfacelist = ^facelist;
  facelist = Array[0..0] Of polyface;

  pintlist = ^intlist;
  intlist = Array[0..0] Of integer;

  pattrlist = ^attrlist;
  attrlist = Array[0..0] Of Extended;

  // note the addition of base and scale factor for drawing blocks
  coord_convert = Function( P: Point3D; OCS: pMatrix ): TPoint Of Object;
  coord_convert3D = Function( P: Point3D; OCS: pMatrix ): Point3D Of Object;

  planar_eq = Record
    a, b, c, d: Double;
  End;
  ///////////////////////////////////////////////////////////////////////////////
  // DXF_Entity - abstract base class - override where neccessary
  // All DXF objects will become sub classes of this
  ///////////////////////////////////////////////////////////////////////////////
  // Added for GIS
  TEllipse2DClass = Class( TEzEllipse );
  //TText2DClass = class(TText2D);

  DXF_Entity = Class
    colour: TColor;
    colinx: integer;
    OCS_WCS: pMatrix;
    OCS_axis: Point3D;
    Constructor create;
    Destructor Destroy; Override;
    Procedure init_OCS_WCS_matrix( OCSaxis: Point3D ); Virtual;
    Procedure update_block_links( blist: TObject ); Virtual;
    Procedure setcolour_index( col: integer ); Virtual;
    Procedure setcolour( col: TColor ); Virtual;
    Procedure translate( T: Point3D ); Virtual;
    Procedure quantize_coords( epsilon: Double; mask: byte ); Virtual;
    Function count_points: integer; Virtual;
    Function count_lines: integer; Virtual;
    Function count_polys_open: integer; Virtual;
    Function count_polys_closed: integer; Virtual;
    Function proper_name: String; Virtual;
    Procedure write_DXF_Point( Var IO: textfile; n: integer; p: Point3D ); Virtual;
    Procedure write_to_DXF( Var IO: textfile; Const layer: String; Lcolor: integer ); Virtual;
    Procedure max_min_extents( Var emax, emin: Point3D ); Virtual;
    Function closest_vertex_square_distance_2D( p: Point3D ): Double; Virtual;
    Function closest_vertex( p: Point3D ): Point3D; Virtual;
    Function is_point_inside_object2D( p: Point3D ): boolean; Virtual;
    Function Move_point( const p, newpoint: Point3D ): boolean; Virtual;

    // Added for GIS
    Procedure AddToGIS( DxfImport: TEzDxfImport; OCS: pM ); Virtual;
  End;
  ///////////////////////////////////////////////////////////////////////////////
  // Block_ Definition - special case - not to be used like other entities
  // Blocks should always appear in layer 'Block_'
  // I'm still not quite sure what to do with them - but here goes anyway...
  ///////////////////////////////////////////////////////////////////////////////
  Block_ = Class( DXF_Entity )
    rotation: Double;
    name: String;
    basepoint: Point3D;
    entities: TList;
    NoOCS_WCS: pMatrix;
    Constructor create( Const bname: String; refpoint: Point3D );
    Destructor Destroy; Override;
    Procedure update_block_links( blist: TObject ); Override;
    Procedure write_to_DXF( Var IO: textfile; Const layer: String; Lcolor: integer ); Override;
    Procedure max_min_extents( Var emax, emin: Point3D ); Override;
    Function closest_vertex_square_distance_2D( p: Point3D ): Double; Override;
    Function closest_vertex( p: Point3D ): Point3D; Override;
    Procedure setcolour( col: TColor ); Override;
    //    Procedure   CreateCopy(var Result : Block_) ;
    // Added for GIS
    Procedure AddToGIS( DxfImport: TEzDxfImport; OCS: pM ); Override;
  End;
  ///////////////////////////////////////////////////////////////////////////////
  // Point Definition
  ///////////////////////////////////////////////////////////////////////////////
  Point_ = Class( DXF_Entity ) // always WCS
    p1: Point3D;
    LineStyle: integer;
    Constructor create( OCSaxis, p: Point3D; col: integer );
    Procedure translate( T: Point3D ); Override;
    Procedure quantize_coords( epsilon: Double; mask: byte ); Override;
    Procedure write_to_DXF( Var IO: textfile; Const layer: String; Lcolor: integer ); Override;
    Procedure max_min_extents( Var emax, emin: Point3D ); Override;
    Function closest_vertex_square_distance_2D( p: Point3D ): Double; Override;
    Function closest_vertex( p: Point3D ): Point3D; Override;
    Function Move_point( const p, newpoint: Point3D ): boolean; Override;

    // Added for GIS
    Procedure AddToGIS( DxfImport: TEzDxfImport; OCS: pM ); Override;
  End;
  ///////////////////////////////////////////////////////////////////////////////
  // Text Definition
  ///////////////////////////////////////////////////////////////////////////////
  Text_ = Class( Point_ ) // always OCS
    h: Double;
    textstr: String;
    style: String;
    align_pt: Point3D; // alignment point
    hor_align: integer; // horizontal justification code
    rotation: Double;
    Constructor create( OCSaxis, p, ap: Point3D; rot: Double; Const ss, s1: String; height: Double; col, ha: integer );
    Procedure write_to_DXF( Var IO: textfile; Const layer: String; Lcolor: integer ); Override;
    Procedure max_min_extents( Var emax, emin: Point3D ); Override;
    // Added for GIS
    Procedure AddToGIS( DxfImport: TEzDxfImport; OCS: pM ); Override;
  End;
  ///////////////////////////////////////////////////////////////////////////////
  // Attrib Definition
  ///////////////////////////////////////////////////////////////////////////////
  Attrib_ = Class( Text_ ) // always OCS
    tagstr: String;
    visible: boolean;
    Constructor create( OCSaxis, p, ap: Point3D; rot: Double; Const ss, s1, tag: String; flag70, flag72: integer; height:
      Double; col: integer );
    Procedure write_to_DXF( Var IO: textfile; Const layer: String; Lcolor: integer ); Override;
    // Added for GIS
    Procedure AddToGIS( DxfImport: TEzDxfImport; OCS: pM ); Override;
  End;
  patt_array = ^att_array;
  att_array = Array[0..0] Of Attrib_;
  ///////////////////////////////////////////////////////////////////////////////
  // Attdef Definition
  ///////////////////////////////////////////////////////////////////////////////
  Attdef_ = Class( Attrib_ ) // always OCS
    promptstr: String;
    Constructor create( OCSaxis, p, ap: Point3D; rot: Double; Const ss, s1, tag, prompt: String; flag70, flag72: integer;
      height: Double; col: integer );
    Procedure write_to_DXF( Var IO: textfile; Const layer: String; Lcolor: integer ); Override;
    // Added for GIS
    Procedure AddToGIS( DxfImport: TEzDxfImport; OCS: pM ); Override;
  End;
  ///////////////////////////////////////////////////////////////////////////////
  // Insert Definition (optionally contains attribs)
  ///////////////////////////////////////////////////////////////////////////////
  Insert_ = Class( Point_ ) // always OCS
    num_attribs: integer;
    attribs: Array[0..max_attribs] Of Attrib_;
    blockname: String;
    scale: Point3D;
    rotation: Double;
    blockptr: Block_; // use carefully
    blocklist: TObject; // to cross reference the blocks
    NoOCS_WCS: pMatrix; //회전안하는 OCS/WCS
    Constructor create( OCSaxis, p, s_f: Point3D; rot: Double; col: integer;
      numatts: integer; atts: patt_array; Const block: String );
    Destructor Destroy; Override;
    Procedure init_OCS_WCS_matrix( OCSaxis: Point3D ); Override;
    Procedure update_block_links( blist: TObject ); Override;
    Function block: Block_;
    Procedure write_to_DXF( Var IO: textfile; Const layer: String; Lcolor: integer ); Override;
    Procedure max_min_extents( Var emax, emin: Point3D ); Override;
    // Added for GIS
    Procedure AddToGIS( DxfImport: TEzDxfImport; OCS: pM ); Override;
  End;
  ///////////////////////////////////////////////////////////////////////////////
  // Line Definition
  ///////////////////////////////////////////////////////////////////////////////
  Line_ = Class( Point_ ) // always WCS
    p2: Point3D;
    Constructor create( p_1, p_2: Point3D; col: integer; LS: integer );
    Procedure translate( T: Point3D ); Override;
    Procedure quantize_coords( epsilon: Double; mask: byte ); Override;
    Function count_points: integer; Override;
    Function count_lines: integer; Override;
    Procedure write_to_DXF( Var IO: textfile; Const layer: String; Lcolor: integer ); Override;
    Procedure max_min_extents( Var emax, emin: Point3D ); Override;
    Function closest_vertex_square_distance_2D( p: Point3D ): Double; Override;
    Function closest_vertex( p: Point3D ): Point3D; Override;
    Function Move_point( const p, newpoint: Point3D ): boolean; Override;
    // Added for GIS
    Procedure AddToGIS( DxfImport: TEzDxfImport; OCS: pM ); Override;
  End;
  ///////////////////////////////////////////////////////////////////////////////
  // Circle Definition
  ///////////////////////////////////////////////////////////////////////////////
  Circle_ = Class( Point_ ) // always OCS
    radius: Double;
    Constructor create( OCSaxis, p_1: Point3D; radius_: Double; col: integer; LS: integer );
    Destructor Destroy; Override;
    Constructor create_from_polyline( ent1: DXF_Entity );
    Procedure write_to_DXF( Var IO: textfile; Const layer: String; Lcolor: integer ); Override;
    Function is_point_inside_object2D( p: Point3D ): boolean; Override;
    Procedure max_min_extents( Var emax, emin: Point3D ); Override;
    // Added for GIS
    Procedure AddToGIS( DxfImport: TEzDxfImport; OCS: pM ); Override;
  End;
  ///////////////////////////////////////////////////////////////////////////////
  // Arc Definition
  ///////////////////////////////////////////////////////////////////////////////
  Arc_ = Class( Circle_ ) // always OCS
    angle1, angle2: Double;
    Constructor create( OCSaxis, p_1: Point3D; radius_, sa, ea: Double; col: integer; LS: integer );
    Procedure write_to_DXF( Var IO: textfile; Const layer: String; Lcolor: integer ); Override;
    Function is_point_inside_object2D( p: Point3D ): boolean; Override;
    Procedure max_min_extents( Var emax, emin: Point3D ); Override;
    // Added for GIS
    Procedure AddToGIS( DxfImport: TEzDxfImport; OCS: pM ); Override;
  End;
  ///////////////////////////////////////////////////////////////////////////////
  // Polyline Definition
  ///////////////////////////////////////////////////////////////////////////////
  Polyline_ = Class( DXF_Entity ) // OCS/WCS depends
    closed: boolean;
    numvertices: integer;
    numtext: integer;
    polypoints: ppointlist;
    numattrs: integer;
    attribs: Array[0..max_my_attribs - 1] Of Double;
    linestyle: integer;
    Constructor create( OCSaxis: Point3D; numpoints: integer; points: ppointlist; col: integer; closed_: boolean; LS: integer
      );
    Destructor Destroy; Override;
    Procedure translate( T: Point3D ); Override;
    Procedure quantize_coords( epsilon: Double; mask: byte ); Override;
    Function count_points: integer; Override;
    Function count_lines: integer; Override;
    Function count_polys_open: integer; Override;
    Function count_polys_closed: integer; Override;
    Procedure write_to_DXF( Var IO: textfile; Const layer: String; Lcolor: integer ); Override;
    Procedure max_min_extents( Var emax, emin: Point3D ); Override;
    Function closest_vertex_square_distance_2D( p: Point3D ): Double; Override;
    Function closest_vertex( p: Point3D ): Point3D; Override;
    // some functions I use...most removed....
    Function Move_point( const p, newpoint: Point3D ): boolean; Override;
    Function is_point_inside_object2D( p: Point3D ): boolean; Override;
    Function triangle_centre: Point3D;
    Procedure set_attrib( i: integer; v: Double );
    Function get_attrib( i: integer ): Double;
    Procedure copy_attribs( p: Polyline_ );
    // Added for GIS
    Procedure AddToGIS( DxfImport: TEzDxfImport; OCS: pM ); Override;
  End;
  ///////////////////////////////////////////////////////////////////////////////
  // Face3D_ Definition - Should be 3DFace but can't name a type starting with 3
  ///////////////////////////////////////////////////////////////////////////////
  Face3D_ = Class( Polyline_ ) // always WCS
    Constructor create( numpoints: integer; points: ppointlist; col: integer; closed_: boolean; LS: Integer );
    Function proper_name: String; Override; // save as 3DFACE not Face3D
    Procedure write_to_DXF( Var IO: textfile; Const layer: String; Lcolor: integer ); Override;
  End;
  ///////////////////////////////////////////////////////////////////////////////
  // Solid_ Definition
  ///////////////////////////////////////////////////////////////////////////////
  Solid_ = Class( Face3D_ ) // always OCS
    thickness: Double;
    Constructor create( OCSaxis: Point3D; numpoints: integer; points: ppointlist; col: integer; t: Double; LS: Integer );
    Function proper_name: String; Override;
    Procedure write_to_DXF( Var IO: textfile; Const layer: String; Lcolor: integer ); Override;
    // Added for GIS
    Procedure AddToGIS( DxfImport: TEzDxfImport; OCS: pM ); Override;
  End;
  ///////////////////////////////////////////////////////////////////////////////
  // Polyline_ (polygon MxN grid mesh) Definition
  ///////////////////////////////////////////////////////////////////////////////
  Polygon_mesh_ = Class( Polyline_ ) // always WCS ???
    M, N: integer;
    closeM, closeN: boolean;
    Constructor create( numpoints, Mc, Nc: integer; points: ppointlist; closebits, col: integer; LS: Integer );
    Function proper_name: String; Override;
    Procedure write_to_DXF( Var IO: textfile; Const layer: String; Lcolor: integer ); Override;
    // Added for GIS
    Procedure AddToGIS( DxfImport: TEzDxfImport; OCS: pM ); Override;
  End;
  ///////////////////////////////////////////////////////////////////////////////
  // Polyline_ (polyface vertex array mesh) Definition
  ///////////////////////////////////////////////////////////////////////////////
  Polyface_mesh_ = Class( Polyline_ ) // always WCS ???
    numfaces: integer;
    facelist: pfacelist;
    Constructor create( numpoints, nfaces: integer;
      points: ppointlist; faces: pfacelist; col: integer; LS: Integer );
    Destructor Destroy; Override;
    Function proper_name: String; Override;
    Procedure write_to_DXF( Var IO: textfile; Const layer: String; Lcolor: integer ); Override;
    // Added for GIS
    Procedure AddToGIS( DxfImport: TEzDxfImport; OCS: pM ); Override;
  End;
  //*****************************************************************************
  // DXF_layer class definition
  // A collection of entity lists. One for each type.
  //*****************************************************************************
  DXF_Layer = Class
    layer_name: String;
    layer_colinx: integer;
    entities: TList;
    LineStyle: integer; //GIS Style
    LineType: String; //AutoCAD LineType
    FContinueProcessing: Boolean;
    Constructor create( Const l_name: String; Lcolor: integer; LS: String );
    Destructor Destroy; Override;

    Function num_entities: integer;
    Procedure AddToGIS( DxfImport: TEzDxfImport; OCS: pM );

    Property Colour: integer Read layer_colinx Write layer_colinx;
    Property name: String Read layer_name Write layer_name;
    Function add_entity_to_layer( entity: DXF_Entity ): boolean;
    // utilities
    Procedure max_min_extents( Var emax, emin: Point3D );
  End;
  //*****************************************************************************
  // DXF_Object class definition
  // A Collection of DXF_Layers - eg a whole DXF file.
  //*****************************************************************************
  DXF_Object = Class
    DxfFile: TEzDxfFile;
    FDXF_name: String;
    layer_lists: TList;
    emax: Point3D;
    emin: Point3D;
    // Create an empty object
    Constructor create( ADxfFile: TEzDxfFile; Const aname: String );
    // Create an object and load from file
    Constructor create_from_file( ADxfFile: TEzDxfFile; Const aname: String; skipped, errlog: Tstrings );
    Procedure save_to_file( Const aname: String );
    Destructor Destroy; Override;

    Procedure ReadDXF( Const aname: String; skipped, errlog: Tstrings );
    Function num_layers: integer;
    // add an empty layer
    Function new_layer( Const aname: String; DUPs_OK: boolean ): DXF_Layer;
    // add a pre-filled layer
    Function add_layer( layer: DXF_Layer ): boolean;
    // return the layer with a given name
    Function layer( Const aname: String ): DXF_Layer;
    // add an entity to a named layer
    Function add_entity_to_layer( entity: DXF_Entity; Const aname: String ): boolean;
    // return layer and create if neccessary
    Function create_or_find_layer( Const aname: String ): DXF_Layer;
    // Useful ones
    Function get_min_extent: Point3D;
    Function get_max_extent: Point3D;
    // update the extents (not really needed)
    Procedure max_min_extents( Var emax, emin: Point3D );

    Property name: String Read FDXF_name Write FDXF_name;

  End;

  // color handling (used only to allocate dynamic memory)
  TAcadColorPal = Class( TObject )
  Private
    FColorData: Array[0..256] Of integer;
    Function GetColors( Index: Integer ): Integer;
  Public
    Constructor Create;
    Function NumColors: Integer;
    Property Colors[Index: Integer]: Integer Read GetColors; Default;
  End;

  // Line Style handling (used only to allocate dynamic memory)
  TAcadLineStyle = Class( TObject )
  Private
    //FLineData: array[0..49] of string;
    //FEzStyle : array[0..49] of Integer;
  Public
    //constructor Create;
    Function NumLineStyles: Integer;
    Function FindLineStyle( const LineStyle: String ): Integer;
    Function GetLineStyle( Index: Integer ): String;
    //Property LineStyles[Index: integer]: String Read GetLineStyle; Default;
    Function ACADLineFromLine( index: integer ): String;
  End;


  ///////////////////////////////////////////////////////////////////////////////
  // Memory check variables
  ///////////////////////////////////////////////////////////////////////////////
Var
  Dxf_Errshow: Integer;
  Dxf_Version: Integer;
  Text_height_control: Integer;
  Text_Small_Display: boolean;

  // Added for GIS
  AcadColorPal: TAcadColorPal = Nil;
  AcadLineStyle: TAcadLineStyle = Nil;

Implementation

Uses
  EzConsts, EzDXFRead, EzDXFWrite;

Const
  BYLAYER = 256;

Type

  ///////////////////////////////////////////////////////////////////////////////
  // DXF exceptions will be this type
  ///////////////////////////////////////////////////////////////////////////////
  EDXF_exception = Class( Exception );
  ///////////////////////////////////////////////////////////////////////////////
  // Default AutoCad layer colours (1..7) - (8..user defined)
  ///////////////////////////////////////////////////////////////////////////////



{ TEzDxfFile }

Destructor TEzDxfFile.Destroy;
Begin
  If Assigned( FDxf_Main ) Then
    FDxf_Main.Free;
  Inherited Destroy;
End;

Procedure TEzDxfFile.Notification( AComponent: TComponent;
  Operation: TOperation );
Begin
  Inherited Notification( AComponent, Operation );
  If ( Operation = opRemove ) And ( AComponent = FDrawBox ) Then
    FDrawBox := Nil;
End;

function TEzDxfFile.ProperColor(clr: TColor): TColor;
begin
  Result:= clr;
  If clr = ColorToRGB( FDrawBox.Color ) then
  begin
    if ColorToRGB( FDrawBox.Color ) = clWhite then
      Result:= clBlack
    else
      Result:= clWhite;
  end;
end;

Procedure TEzDxfFile.SetDrawBox( Const Value: TEzBaseDrawBox );
Begin
{$IFDEF LEVEL5}
  if Assigned( FDrawBox ) then FDrawBox.RemoveFreeNotification( Self );
{$ENDIF}
  If Value <> FDrawBox Then
  Begin
    Value.FreeNotification( Self );
  End;
  FDrawBox := Value;
End;

{ TEzDxfImport }

Constructor TEzDxfImport.Create( AOwner: TComponent );
Begin
  Inherited Create( AOwner );
  FCad:= TEzCad.Create( Nil );
  FCad.CreateNew('dummy');
  FTargetNames:= TStringList.Create;
  FExplodeBlocks := True;

  FConfirmProjectionSystem := True;
  FImportLayerList := TStringList.Create;
  FFullLayerList := TStringList.Create;
  FConverter := TEzImportConverter.Create;
  FMustDeleteConverter := True;
  FUseTrueType:= True;
  FImportBlocks:= True;
End;

Destructor TEzDxfImport.Destroy;
Begin
  FImportLayerList.Free;
  FFullLayerList.Free;
  If FMustDeleteConverter And ( FConverter <> Nil ) Then
    FConverter.free;
  FCad.Free;
  FTargetNames.Free;

  Inherited Destroy;
End;

Procedure TEzDxfImport.SetConverter( Value: TEzImportConverter );
Begin
  If ( FConverter <> Nil ) And FMustDeleteConverter Then
    FreeAndNil( FConverter );
  FConverter := Value;
  FMustDeleteConverter := False;
End;

Function TEzDxfImport.UpdateProgress: Boolean;
Var
  progress: integer;
Begin
  result := True;
  If Not Assigned( OnFileProgress ) Or ( FTotalEntities = 0 ) Then
    Exit;
  progress := round( ( FTotalProcessed / FTotalEntities ) * 100 );
  OnFileProgress( Self, FMsg, progress, FTotalProcessed, 0, result );
End;

Procedure TEzDxfImport.SetLayerName( Const Value: String );
Begin
  FLayerName := ExtractFileName( ChangeFileExt( Value, '' ) );
  if (FDrawBox <> nil) and (FDrawBox.Gis <> Nil) then
  FLayer:= FDrawBox.Gis.Layers.LayerByName( FLayerName );
End;

Function TEzDxfImport.ReadDxf: Boolean;
Var
  alayer: Dxf_layer;
  Layer: TEzBaseLayer;
  i: Integer;
  blk: Block_;
  J: Integer;
  Index: integer;
  Symbol: TEzSymbol;
  K: Integer;
  ent: Dxf_entity;
  Found: Boolean;
  NativeEnt: TEzEntity;
  TempImport: TEzDxfImport;
{$IFDEF FALSE}
  i, j, K, PrevLayerCount: integer;
  ent: Dxf_entity;
  s: String;
  p: TEzPoint;
  Dxf_OffsetX, Dxf_OffsetY: Double;
{$ENDIF}
  Fullname: String;
  Extent: TEzRect;

{$IFDEF FALSE}
  Procedure OffsetPoint( Var p: Point3D );
  Begin
    p.x := p.x + Dxf_OffsetX;
    p.y := p.y + Dxf_OffsetY;
  End;
{$ENDIF}

Begin
  If FDrawBox = Nil Then
    EzGISError( SWrongEzGIS );
  If FConverter = Nil Then
    EzGISError( SWrongProjector );
  result := True;
  FreeAndNil( FDxf_Main );
  Try
    FDxf_Main := Dxf_Object.Create_from_file( self, FFileName, Nil, Nil );
    FDxf_Emin := Dxf_main.get_min_extent;
    FDxf_Emax := Dxf_main.get_max_extent;
    { build the layer list }
    FImportLayerList.Clear;
    With FDxf_Main Do
      For I := 0 To layer_lists.count - 1 Do
      Begin
        alayer := Dxf_layer( layer_lists[I] );
        FImportLayerList.AddObject( alayer.name, alayer );
        FFullLayerList.AddObject( alayer.name, alayer );
      End;
  Except
    result := False;
  End;

  { now convert to EzGis format }

  //Self.ExplodeBlocks := True;

  { set cad extents to map extents as is done in the dialog previously }
  DxfReferenceX := Dxf_Emin.x;
  DxfReferenceY := Dxf_Emin.y;
  DestReferenceX:= Dxf_Emin.x;
  DestReferenceY:= Dxf_Emin.y;

{$IFDEF FALSE}
  Dxf_offsetX := FDestReferenceX - FDxfReferenceX;
  Dxf_offsetY := FDestReferenceY - FDxfReferenceY;
{$ENDIF}

  { causes to set extension to undefined }
  FCAD.UpdateExtension;

  { Offset all entities if requested }
  Screen.Cursor := crHourGlass;
  Try
{$IFDEF FALSE}
    If ( Dxf_offsetX <> 0 ) Or ( Dxf_offsetY <> 0 ) Then
    Begin
      For I := 0 To FImportLayerList.Count - 1 Do
      Begin
        alayer := Dxf_layer( FImportLayerList.Objects[I] );
        If AnsiCompareText( alayer.layer_name, 'Block_' ) = 0 Then
          Continue;
        For J := 0 To alayer.entities.count - 1 Do
        Begin
          ent := Dxf_entity( alayer.entities[J] );
          If ent.classtype = Block_ Then
            With Block_( ent ) Do
            Begin
              OffsetPoint( basepoint );
            End
          Else If ( ent.classtype = Point_ ) Or ( ent.classtype = Circle_ ) Or
                  ( ent.classtype = Arc_ ) Then
            With Point_( ent ) Do
            Begin
              OffsetPoint( p1 );
            End
          Else If ( ent.classtype = Text_ ) Or
            ( ent.classtype = Attrib_ ) Or
            ( ent.classtype = Attdef_ ) Then
            With Text_( ent ) Do
            Begin
              OffsetPoint( p1 );
              OffsetPoint( align_pt );
            End
          Else If ent.classtype = Insert_ Then
            With Insert_( ent ) Do
            Begin
              OffsetPoint( p1 );
            End
          Else If ent.classtype = Line_ Then
            With Line_( ent ) Do
            Begin
              OffsetPoint( p1 );
              OffsetPoint( p2 );
            End
          Else If ent Is Polyline_ Then
            With Polyline_( ent ) Do
            Begin
              For K := 0 To numvertices - 1 Do
              Begin
                OffsetPoint( polypoints^[K] );
              End;
            End;
        End;
      End;
    End;
{$ENDIF}

    If Not FExplodeBlocks and FImportBlocks then
    begin
      Found:= False;
      For I := 0 To FImportLayerList.Count - 1 Do
      Begin
        alayer := Dxf_layer( FImportLayerList.Objects[I] );
        If (AnsiCompareText( alayer.layer_name, 'Block_' ) <> 0) Or
           (alayer.entities.count = 0) Then
          Continue;
        { create a dummy layer for importing}
        for J:= 0 to alayer.entities.count-1 do
        begin
          blk:= Block_(DXF_Entity( alayer.entities[J] ));
          If blk.entities.count = 0 Then
            continue;
          Index := Ez_Symbols.IndexOfName( blk.name );
          If Index >= 0 then
            continue;
          TempImport:= TEzDxfImport.Create(Nil);
          try
            TempImport.FDrawBox:= Self.FDrawBox;
            TempImport.UseTrueType:= Self.UseTrueType;

            Layer := TempImport.FCad.CreateLayer( 'Dummy', ltMemory  );
            Layer.LayerInfo.IsAnimationLayer := True;
            TempImport.FCad.CurrentLayerName:= Layer.Name;
            TempImport.FExplodeBlocks:= True;
            For K := 0 To blk.entities.count - 1 Do
            Begin
              ent := Dxf_entity( blk.entities[K] );
              ent.AddToGIS( TempImport, Nil );
              Found:= True;
            End;
            Symbol := TEzSymbol.Create(Ez_Symbols);
            try
              Symbol.Name := blk.name;
              Layer.First;
              while not Layer.Eof do
              begin
                NativeEnt:= Layer.RecLoadEntity;
                Symbol.Add(NativeEnt);
                Layer.Next;
              end;
              Symbol.UpdateExtension;
              Ez_Symbols.Add(Symbol);
            except
              Symbol.Free;
              TempImport.FDrawBox:= Nil;
              raise;
            end;
          Finally
            TempImport.FDrawBox:= Nil;
            TempImport.Free;
          End;
        end;
      End;
      If Found then
        Ez_Symbols.SaveToFile(Ez_Symbols.FileName);
    End;

    { count the entities to import }
    FTotalEntities := 0;
    For I := 0 To FImportLayerList.Count - 1 Do
    Begin
      alayer := Dxf_layer( FImportLayerList.Objects[I] );
      If AnsiCompareText( alayer.layer_name, 'Block_' ) = 0 Then
        Continue;
      Inc( FTotalEntities, alayer.entities.count );
    End;
    FTotalProcessed := 0;
    FMsg := fullname;
    For I := 0 To FImportLayerList.Count - 1 Do
    Begin

      alayer := Dxf_layer( FImportLayerList.Objects[I] );
      If AnsiCompareText( alayer.layer_name, 'Block_' ) = 0 Then
        Continue;

      Layer := FCad.CreateLayer( alayer.layer_name, ltMemory  );
      Layer.LayerInfo.IsAnimationLayer := True;
      FTargetNames.Add( Layer.Name );
      FCad.CurrentLayerName:= Layer.Name
      ;

      alayer.AddToGIS( Self, Nil );
      If Not alayer.FContinueProcessing Then Break;
    End;

    FCad.MapInfo.Extension := Rect2D( FDxf_Emin.x, FDxf_Emin.y, FDxf_Emax.x, FDxf_Emax.y );
    If FCad.Layers.Count > 0 Then
    Begin
      Extent := FCad.MapInfo.Extension;
      For I := 0 To FCad.Layers.Count - 1 Do
      Begin
        MaxBound( Extent.Emax, FCad.Layers[I].LayerInfo.Extension.Emax );
        MinBound( Extent.Emin, FCad.Layers[I].LayerInfo.Extension.Emin );
      End;
      FCad.MapInfo.Extension := Extent;
    End;
    { free ram memory from the source layers }
    FreeAndNil( FDxf_Main );

  Finally
    Screen.Cursor:= crDefault;
  End;
End;

{ important: this function mus be called after calling ReadDxf method }

Function TEzDxfImport.Execute: Boolean;
var
  temps: string;
  FileWithoutExt: string;
  I, J, Index: Integer;
  LIndex: Integer;
  Layer: TEzBaseLayer;
  wasActive: Boolean;
  FieldList : TStringList;
  SrcLayer: TEzBaseLayer;
  TheRecno: Integer;
  PrevLayerCount: integer;
  DestCoordSystem: TEzCoordSystem;
  DestCoordsUnits: TEzCoordsUnits;
  TmpEntity: TEzEntity;
  //DataIndex: Integer;
  ImportCnt: integer;
  CurrCnt: integer;
  CanContinue: boolean;
Begin
  Result := False;
  Assert( FDrawBox <> Nil );
  Assert( FDrawBox.Gis <> Nil );
  Assert( FConverter <> Nil );

  PrevLayerCount := FDrawBox.GIS.Layers.Count;

  FileWithoutExt := ChangeFileExt( FFileName, '' );

  If PrevLayerCount > 0 Then
  begin
    With FDrawBox.GIS, FConverter Do
    Begin
      FConverter.DestinCoordSystem := MapInfo.CoordSystem;
      FConverter.DestinProjector.Params.Assign( ProjectionParams );
    End;
  end;
  If FConfirmProjectionSystem And
     Not FConverter.EditProjections( PrevLayerCount = 0 ) Then Exit;

  Application.ProcessMessages;

  DestCoordSystem := FConverter.DestinCoordSystem;
  DestCoordsUnits := FConverter.DestinationUnits;
  If PrevLayerCount = 0 Then
    With FDrawBox.GIS Do
    Begin
      MapInfo.CoordSystem := FConverter.DestinCoordSystem;
      MapInfo.CoordsUnits := DestCoordsUnits;
      ProjectionParams.Assign( FConverter.DestinProjector.Params );
      Modified := True;
    End;

  { count the elements to import }
  ImportCnt:= 0;
  For LIndex:= 0 to FCad.Layers.Count-1 do
  begin
    SrcLayer:= FCad.Layers[LIndex];
    If Not SrcLayer.LayerInfo.Visible then Continue;
    Inc( ImportCnt, SrcLayer.RecordCount );
  end;
  CurrCnt:= 0;
  CanContinue:= True;

  If FGenerateMultiLayers then
  begin

    //DataIndex:= -1;

    For LIndex:= 0 to FCad.Layers.Count-1 do
    begin
      SrcLayer:= FCad.Layers[LIndex];
      If Not SrcLayer.LayerInfo.Visible then Continue;

      temps := ezsystem.GetValidLayerName( FTargetNames[LIndex] );
      Index := DrawBox.GIS.Layers.IndexOfName( temps );
      If Index >= 0 Then
      Begin
        // replace existing layer
        With DrawBox.GIS Do
        Begin
          Layer := Layers[Index];
          wasActive := AnsiCompareText( MapInfo.CurrentLayer, Layer.Name ) = 0;
          Layers.Delete( Layer.Name, True );
          If wasActive And ( Layers.Count > 0 ) Then
            MapInfo.CurrentLayer := Layers[0].Name;
          If Layers.Count = 0 Then
            With MapInfo Do
            Begin
              Extension := INVALID_EXTENSION;
              CurrentLayer := '';
            End;
          //Layer.LayerInfo.CoordsUnits := MapInfo.CoordsUnits;
        End
      End;

      FieldList := TStringList.Create;
      Try

        FieldList.Add( 'UID;N;12;0' );
        {FieldList.Add( 'ELE_TYPE;N;2;0' );
        FieldList.Add( 'ELE_STR;C;20;0' );
        FieldList.Add( 'DIMENSION;N;1;0' ); }
        FieldList.Add( 'Z;N;20;4' );

        Layer := DrawBox.GIS.Layers.CreateNewEx(
          ExtractFilePath( DrawBox.GIS.FileName ) + temps, DestCoordSystem,
          DestCoordsUnits, FieldList );

      Finally
        FieldList.Free;
      End;

      If Layer = Nil Then
      Begin
        MessageToUser( SCannotCreateNewLayer, SMsgError, MB_ICONERROR );
        Exit;
      End;

      Layer.ForceOpened;
      Layer.StartBatchInsert;
      try
        SrcLayer.First;
        While Not SrcLayer.Eof do
        begin
          Inc(CurrCnt);
          if Assigned (FOnFileProgress) then
            FOnFileProgress( Self, FFilename, Round( ( ( CurrCnt + 1 ) / ImportCnt ) * 100 ), CurrCnt, 0, CanContinue );
          If Not CanContinue Then Break;

          TmpEntity:= SrcLayer.RecLoadEntity;
          try
            { convert from source coordinate system }
            TmpEntity.BeginUpdate;
            For J := 0 To TmpEntity.Points.Count - 1 Do
              TmpEntity.Points[J] := FConverter.Convert( TmpEntity.Points[J] );
            TmpEntity.EndUpdate;

            TheRecno:= Layer.AddEntity( TmpEntity );

            If Layer.DBTable <> Nil Then
            Begin
              //Inc( DataIndex );
              Layer.DBTable.Recno:= TheRecno;
              Layer.DBTable.Edit;
              //Layer.DBTable.IntegerPut( 'ELE_TYPE', FCol0[DataIndex] );
              //Layer.DBTable.StringPut( 'ELE_STR', FCol1[DataIndex] );
              //Layer.DBTable.IntegerPut( 'DIMENSION', FCol2[DataIndex] );
              Layer.DBTable.FloatPut( 'Z', 0 );
              Layer.DBTable.Post;
            End;

          finally
            TmpEntity.Free;
          end;

          SrcLayer.Next;
        end;
      finally
        Layer.FinishBatchInsert;
      end;
      Layer.Modified := True;
    end;
  end else
  begin
    { Exists a layer with that name already ? }

//    temps := ezsystem.GetValidlayerName( ExtractFileName( FileWithoutExt ) );
    temps := ezsystem.GetValidlayerName(FLayerName);
    Index := DrawBox.GIS.Layers.IndexOfName( temps );
    If Index >= 0 Then
    Begin
      If MessageDlg( Format( SLayerAlreadyExists, [temps] ), mtConfirmation, [mbYes, mbNo], 0 ) = mrYes Then
        // replace existing layer
        With DrawBox.GIS Do
        Begin
          Layer := Layers[Index];
          wasActive := AnsiCompareText( MapInfo.CurrentLayer, Layer.Name ) = 0;
          Layers.Delete( Layer.Name, True );
          If wasActive And ( Layers.Count > 0 ) Then
            MapInfo.CurrentLayer := Layers[0].Name;
          If Layers.Count = 0 Then
            With MapInfo Do
            Begin
              Extension := INVALID_EXTENSION;
              CurrentLayer := '';
            End;
          //Layer.LayerInfo.CoordsUnits := MapInfo.CoordsUnits;
        End
      Else
        Exit;
    End;

    FieldList := TStringList.Create;
    Try

      FieldList.Add( 'UID;N;12;0' );
      {FieldList.Add( 'ELE_TYPE;N;2;0' );
      FieldList.Add( 'ELE_STR;C;20;0' );
      FieldList.Add( 'DIMENSION;N;1;0' ); }
      FieldList.Add( 'Z;N;20;4' );

      Layer := DrawBox.GIS.Layers.CreateNewEx( ExtractFilePath( DrawBox.GIS.FileName ) +
                 temps, DestCoordSystem, DestCoordsUnits, FieldList );

    Finally
      FieldList.Free;
    End;

    If Layer = Nil Then
    Begin
      MessageToUser( SCannotCreateNewLayer, SMsgError, MB_ICONERROR );
      Exit;
    End;

    //DataIndex:= -1;

    Layer.ForceOpened;
    Layer.StartBatchInsert;
    try
      For LIndex:= 0 to FCad.Layers.Count-1 do
      begin
        SrcLayer:= FCad.Layers[LIndex];
        If Not SrcLayer.LayerInfo.Visible then Continue;
        SrcLayer.First;
        While Not SrcLayer.Eof do
        begin
          Inc(CurrCnt);
          if Assigned(FOnFileProgress) then
            FOnFileProgress( Self, FFilename, Round( ( ( CurrCnt + 1 ) / ImportCnt ) * 100 ), CurrCnt, 0, CanContinue );
          If Not CanContinue Then Break;

          TmpEntity:= SrcLayer.RecLoadEntity;
          try
            { convert from source coordinate system }
            TmpEntity.BeginUpdate;
            For J := 0 To TmpEntity.Points.Count - 1 Do
              TmpEntity.Points[J] := FConverter.Convert( TmpEntity.Points[J] );
            TmpEntity.EndUpdate;

            TheRecno:= Layer.AddEntity( TmpEntity );

            If Layer.DBTable <> Nil Then
            Begin
              //Inc( DataIndex );
              Layer.DBTable.Recno:= TheRecno;
              Layer.DBTable.Edit;
              //Layer.DBTable.IntegerPut( 'ELE_TYPE', FCol0[DataIndex] );
              //Layer.DBTable.StringPut( 'ELE_STR', FCol1[DataIndex] );
              //Layer.DBTable.IntegerPut( 'DIMENSION', FCol2[DataIndex] );
              Layer.DBTable.FloatPut( 'Z', 0 );
              Layer.DBTable.Post;
            End;
          finally
            TmpEntity.Free;
          end;

          SrcLayer.Next;
        end;
      end;
    finally
      Layer.FinishBatchInsert;
    end;
    Layer.Modified := True;

  End;

  { sort by name }
  If FGenerateMultiLayers then
    DrawBox.GIS.Layers.Sort;

  DrawBox.GIS.QuickUpdateExtension;
  If PrevLayerCount = 0 Then
    With DrawBox.GIS Do
      For I := 0 To DrawBoxList.Count - 1 Do
        DrawBoxList[I].ZoomToExtension;

End;

Function TEzDxfImport.ImportFiles( FileList: TStrings ): Boolean;
Var
  I: Integer;
  TmpFilename: String;
  TmpBool: Boolean;
Begin
  TmpBool := FConfirmProjectionSystem;
  TmpFilename := FFileName;
  Try
    For I := 0 To FileList.Count - 1 Do
    Begin
      FFileName := FileList[I];
      If Not ReadDxf Then
        Continue;
      Execute;
      FConfirmProjectionSystem := false;
    End;
    result := True;
  Finally
    FFileName := TmpFilename;
    FConfirmProjectionSystem := TmpBool;
  End;
End;

{$IFDEF BCB}
function TEzDxfImport.GetConfirmProjectionSystem: Boolean;
begin
  Result := FConfirmProjectionSystem;
end;

function TEzDxfImport.GetDestReferenceX: Double;
begin
  Result := FDestReferenceX;
end;

function TEzDxfImport.GetDestReferenceY: Double;
begin
  Result := FDestReferenceY;
end;

function TEzDxfImport.GetDxf_Emax: Point3D;
begin
  Result := FDxf_Emax;
end;

function TEzDxfImport.GetDxf_Emin: Point3D;
begin
  Result := FDxf_Emin;
end;

function TEzDxfImport.GetDxfReferenceX: Double;
begin
  Result := FDxfReferenceX;
end;

function TEzDxfImport.GetDxfReferenceY: Double;
begin
  Result := FDxfReferenceY;
end;

function TEzDxfImport.GetExplodeBlocks: Boolean;
begin
  Result := FExplodeBlocks;
end;

function TEzDxfImport.GetFullLayerList: TStrings;
begin
  Result := FFullLayerList;
end;

function TEzDxfImport.GetImportLayerList: TStrings;
begin
  Result := FImportLayerList;
end;

function TEzDxfImport.GetLayer: TEzBaseLayer;
begin
  Result := FLayer;
end;

function TEzDxfImport.GetLayerName: String;
begin
  Result := FLayerName;
end;

function TEzDxfImport.GetOnAfterImport: TNotifyEvent;
begin
  Result := FOnAfterImport;
end;

function TEzDxfImport.GetOnBeforeImport: TNotifyEvent;
begin
  Result := FOnBeforeImport;
end;

function TEzDxfImport.GetUseTrueType: Boolean;
begin
  Result := FUseTrueType;
end;

procedure TEzDxfImport.SetConfirmProjectionSystem(const Value: Boolean);
begin
  FConfirmProjectionSystem := Value;
end;

procedure TEzDxfImport.SetDestReferenceX(const Value: Double);
begin
  FDestReferenceX := Value;
end;

procedure TEzDxfImport.SetDestReferenceY(const Value: Double);
begin
  FDestReferenceY := Value;
end;

procedure TEzDxfImport.SetDxf_Emax(const Value: Point3D);
begin
  FDxf_EMax := Value;
end;

procedure TEzDxfImport.SetDxf_Emin(const Value: Point3D);
begin
  FDxf_EMin := Value;
end;

procedure TEzDxfImport.SetDxfReferenceX(const Value: Double);
begin
  FDxfReferenceX := Value;
end;

procedure TEzDxfImport.SetDxfReferenceY(const Value: Double);
begin
  FDxfReferenceY := Value;
end;

procedure TEzDxfImport.SetExplodeBlocks(const Value: Boolean);
begin
  FExplodeBlocks := Value;
end;

{$ENDIF}

{ TEzDxfExport }

Constructor TEzDxfExport.Create( AOwner: TComponent );
Begin
  Inherited Create( AOwner );
  FLayerNames := TStringList.Create;
End;

Destructor TEzDxfExport.Destroy;
Begin
  FLayerNames.Free;
  Inherited Destroy;
End;

Function TEzDxfExport.Execute: Boolean;
Var
  blocklayer, dxflayer: DXF_Layer; // DXF layer
  layer: TEzBaseLayer; // GIS layer
  I, J: Integer;
  Symbol: TEzSymbol;
  block: Block_;
  s: String;
  dxfentity: DXF_Entity; // DXF entity
  entity: TEzEntity; // GIS entity
  TmpVp: TEzBaseDrawBox;
  SymbolNames: TStrings;

  Function ACADColorFromColor( Color: TColor ): Integer;
  Var
    i: integer;
  Begin
    If Color = clBlack Then
      Color := clWhite;
    Result := 7;
    For i := 0 To 255 Do
      If AcadColorPal[i] = Color Then
      Begin
        Result := i;
        Exit;
      End;
  End;

  Procedure AddGEntityToEntityList( entlist: TList; Ent: TEzEntity );
  Var
    MaxSize, Sx, Sy: Double;
    process: boolean;
    I, n, Idx1, Idx2, cnt: Integer;
    atts: Array[0..255] Of Attrib_;
    p1: Point3D;
    tempvert: Array[0..max_vertices_per_polyline - 1] Of Point3D;
  Begin
    process := True;
    Case Ent.EntityID Of
      idPlace:
        With TEzPlace( Ent ) Do
        Begin
          If ( SymbolTool.Index < 0 ) Or ( SymbolTool.Index > Ez_Symbols.Count - 1 ) Then
            SymbolTool.Index := 0;
          //Exit;
          Symbol := Ez_Symbols[SymbolTool.Index];
          If Symbol.Count = 0 Then Exit; // no entities in symbol
          With Symbol.Extension Do
          Begin
            MaxSize := dMax( Emax.X - Emin.X, Emax.Y - Emin.Y );
            Sx := SymbolTool.height / MaxSize;
            Sy := Sx;
            If Sx = 0 Then
              Sx := 1;
            If Sy = 0 Then
              Sy := 1;
          End;
          //PlaceSize := MaxSize * Sx;
          // now generate an insert
          //p1 := aPoint3D( Points[0].X - PlaceSize / 2, Points[0].Y - PlaceSize / 2, 0 );
          p1 := aPoint3D( Points[0].X, Points[0].Y , 0 );
          S := Trim( Symbol.Name );
          S := StringReplace( S, #32, '', [rfReplaceAll] );
          If Length( S ) = 0 Then
            S := Format(SSymbolCaption, [SymbolTool.Index] );
          dxfentity := Insert_.create( WCS_Z, p1, aPoint3D( Sx, Sy, 1 ), SymbolTool.Rotangle,
            AcadColorFromColor(clWhite), 0, @atts[0], s );
          //Insert_(dxfentity).scale:=aPoint3D(Sx,Sy,0);
        End;
      idPolyline, idPolygon:
        Begin
          { includes multi-part polygons }
          n := 0;
          If Ent.Points.Parts.Count < 2 Then
          Begin
            Idx1 := 0;
            Idx2 := Ent.Points.Count - 1;
          End
          Else
          Begin
            Idx1 := Ent.Points.Parts[n];
            Idx2 := Ent.Points.Parts[n + 1] - 1;
          End;
          Repeat
            For cnt := Idx1 To Idx2 Do
            Begin
              tempvert[cnt-Idx1] := aPoint3D( Ent.Points[cnt].X, Ent.Points[cnt].Y, 0 );
            End;
            dxfentity := Polyline_.create( WCS_Z, Succ( Idx2 - Idx1 ),
              @tempvert, ACADColorFromColor( TEzOpenedEntity( Ent ).PenTool.Color ),
              ( Ent.EntityID = idPolygon ), TEzOpenedEntity( Ent ).PenTool.Style );
            entlist.Add( dxfentity );
            If Ent.Points.Parts.Count < 2 Then Break;
            Inc( n );
            If n >= Ent.Points.Parts.Count Then Break;
            Idx1 := Ent.Points.Parts[n];
            If n < Ent.Points.Parts.Count - 1 Then
              Idx2 := Ent.Points.Parts[n + 1] - 1
            Else
              Idx2 := Ent.Points.Count - 1;
          Until False;
          process:= false;
        End;
      idArc, idRectangle, idEllipse:
        Begin
          For I := 0 To Ent.DrawPoints.Count - 1 Do
            tempvert[I] := aPoint3D( Ent.DrawPoints[I].X, Ent.DrawPoints[I].Y, 0 );
          dxfentity := Polyline_.create( WCS_Z, Ent.DrawPoints.Count,
            @tempvert, ACADColorFromColor( TEzOpenedEntity( Ent ).PenTool.Color ),
            ( Ent.EntityID In [idPolygon, idRectangle, idEllipse] ), TEzOpenedEntity( Ent ).PenTool.Style );
        End;
      idTrueTypeText:
        With TEzTrueTypeText( Ent ) Do
        begin
          dxfentity := Text_.create( WCS_Z,
            aPoint3D( Points[0].X, Points[0].Y - Dist2D( Points[0], Points[1] ), 0 ),
            Origin3D, FontTool.Angle, Text,  '',
            Dist2D( Points[0], Points[1] ),
            ACADColorFromColor( FontTool.Color ), 0 );
        end;
      idFittedVectText:
        With TEzFittedVectorText( Ent ) Do
        Begin
          dxfentity := Text_.create( WCS_Z, aPoint3D( Points[0].X, Points[0].Y, 0 ),
            Origin3D, DegToRad( Angle ), Text, '', Dist2D( Points[0], Points[1] ),
            ACADColorFromColor( FontColor ), 0 );
        End;
      idJustifVectText:
        With TEzJustifVectorText( Ent ) Do
        Begin
          dxfentity := Text_.create( WCS_Z, aPoint3D( Points[0].X, Points[0].Y, 0 ),
            Origin3D, DegToRad( Angle ), Text, '', Dist2D( Points[0], Points[1] ),
            ACADColorFromColor( FontColor ), 0 );
        End;
    Else
      process := false;
    End;

    If process Then
      entlist.Add( dxfentity );
  End;

Begin
  result := false;
  If FDrawBox = Nil Then
    EzGISError( SWrongEzGIS );

  TmpVp := FDrawBox;
  FDXF_Main := DXF_Object.Create( Self, FFileName );
  If ( AcadColorPal = Nil ) Then
    AcadColorPal := TAcadColorPal.Create;
  If ( AcadLineStyle = Nil ) Then
    AcadLineStyle := TAcadLineStyle.Create;
  Screen.Cursor := crHourglass;
  SymbolNames:= TStringList.Create;
  Try
    // first generate a layer of blocks (coming from symbols of GIS)
    blocklayer := FDXF_Main.new_layer( 'Block_', false );
    // Generate block headers (from TEzBaseGIS symbols)
    For I := 0 To Ez_Symbols.Count - 1 Do
    Begin
      Symbol := Ez_Symbols[I];

      S := Trim( Symbol.Name );
      s := StringReplace( s, #32, '', [rfReplaceAll] );
      If Length( S ) = 0 Then
        S := Format(SSymbolCaption, [I] );
      while SymbolNames.IndexOf( S ) >= 0 do
      begin
        s := 'A' + s;
      end;
      SymbolNames.Add( S );
      // create new block
      block := Block_.create( s, Origin3D );
      blocklayer.add_entity_to_layer( block );

      // generate the entities of the block here
      For J := 0 To Symbol.Count - 1 Do
        AddGEntityToEntityList( block.entities, Symbol.Entities[J] );
    End;

    // now generate all requested layers
    For I := 0 To FLayerNames.Count - 1 Do
    Begin
      layer := TmpVp.GIS.Layers.LayerByName( FLayerNames[I] );
      If layer = Nil Then
        Continue;
      dxflayer := FDXF_Main.new_layer( layer.Name, false );
      //nEntities:= layer.RecordCount;

      Layer.First;
      Layer.StartBuffering;
      Try
        While Not Layer.Eof Do
        Begin
          If Layer.RecIsDeleted Then
          Begin
            Layer.Next;
            Continue;
          End;
          //Inc(J);
          //MyDlg.Label3.Caption := inttostr(J)+' Objects Created.';
          //MyDlg.ProgressBar1.Position := J;
          //MyDlg.Update ;
          Entity := Layer.RecLoadEntity;
          If Entity <> Nil Then
          Begin
            AddGEntityToEntityList( dxflayer.entities, Entity );
            Entity.Free;
          End;

          Layer.Next;
        End;
      Finally
        Layer.EndBuffering;
      End;
    End;
    // write the file
    FDXF_Main.save_to_file( FFileName );
  Finally
    If ( AcadColorPal <> Nil ) Then
      FreeAndNil( AcadColorPal );
    If ( AcadLineStyle <> Nil ) Then
      FreeAndNil( AcadLineStyle );
    SymbolNames.Free;
    Screen.Cursor := crDefault;
  End;
End;

{$IFDEF BCB}
function TEzDxfExport.GetLayerNames: TStrings;
begin
  Result := FLayerNames;
end;
{$ENDIF}

Procedure TEzDxfExport.SetLayerNames( Const Value: TStrings );
Begin
  FLayerNames.Assign( Value );
End;

{Procedure ImportVector( DxfImport: TEzDxfImport; Vect: TEzVector );
Var
  cnt: integer;
Begin
  For cnt := 0 To Vect.Count - 1 Do
    Vect[cnt] := DxfImport.Converter.Convert( Vect[cnt] );
End; }

///////////////////////////////////////////////////////////////////////////////
// DXF_Entity - abstract base class - override where neccessary
///////////////////////////////////////////////////////////////////////////////

Constructor DXF_Entity.create;
Begin
  //inc(entities_in_existence);
End;

Destructor DXF_Entity.Destroy;
Begin
  If OCS_WCS <> Nil Then
    deallocate_matrix( OCS_WCS );
  //dec(entities_in_existence);
  Inherited Destroy;
End;

Procedure DXF_Entity.AddToGIS( DxfImport: TEzDxfImport; OCS: pM );
Begin
End;

Procedure DXF_Entity.update_block_links( blist: TObject );
Begin
End;

Procedure DXF_Entity.translate( T: Point3D );
Begin
End;

Procedure DXF_Entity.quantize_coords( epsilon: Double; mask: byte );
Begin
End;

Procedure DXF_Entity.max_min_extents( Var emax, emin: Point3D );
Begin
End;

Function DXF_Entity.closest_vertex_square_distance_2D( p: Point3D ): Double;
Begin
  result := 0;
End;

Function DXF_Entity.closest_vertex( p: Point3D ): Point3D;
Begin
  result := p;
End;

Procedure DXF_Entity.init_OCS_WCS_matrix( OCSaxis: Point3D );
Var
  Ax, Ay: Point3D;
Begin
  OCS_axis := OCSaxis;
  If Not p1_eq_p2_3D( OCSaxis, WCS_Z ) Then
  Begin
    OCS_WCS := allocate_matrix;
    If ( abs( OCSaxis.x ) < 1 / 64 ) And ( abs( OCSaxis.y ) < 1 / 64 ) Then
      Ax := normalize( cross( WCS_Y, OCSaxis ) )
    Else
      Ax := normalize( cross( WCS_Z, OCSaxis ) );
    Ay := normalize( cross( OCSaxis, Ax ) );
    OCS_WCS^ := CreateTransformation( Ax, Ay, OCSaxis );
  End;
End;

Procedure DXF_Entity.setcolour_index( col: integer );
Begin
  colinx := col;
  //colour:= DXF_Layer_Colours[col mod (def_cols+1)];
  // Added for GIS
  colour := AcadColorPal[col];
  //  colour := Colormap[col mod (256+1)];
  //  colour := colormap[col];
  {  if col>def_cols then
      colour := colormap[col]
    else
    colour := DXF_Layer_Colours[col mod (def_cols+1)];}
End;

Procedure DXF_Entity.setcolour( col: TColor );
Var
  lp1: integer;
Begin
  colinx := 0;
  For lp1 := 0 To 255 Do
    //if Dxf_layer_Colours[lp1]=col then begin
    // Added for GIS
    If AcadColorPal[lp1] = col Then
    Begin
      colinx := lp1;
      break;
    End;
  colour := col;
End;

Function DXF_Entity.count_points: integer;
Begin
  result := 1;
End;

Function DXF_Entity.count_lines: integer;
Begin
  result := 0;
End;

Function DXF_Entity.count_polys_open: integer;
Begin
  result := 0;
End;

Function DXF_Entity.count_polys_closed: integer;
Begin
  result := 0;
End;

Function DXF_Entity.proper_name: String;
Var
  temp: String;
Begin
  temp := AnsiUpperCase( ClassName );
  result := Copy( temp, 1, Length( temp ) - 1 );
End;

Procedure DXF_Entity.write_DXF_Point( Var IO: textfile; n: integer; p: Point3D );
Begin
  writeln( IO, n, EOL, float_out( p.x ) );
  writeln( IO, n + 10, EOL, float_out( p.y ) );
  writeln( IO, n + 20, EOL, float_out( p.z ) );
End;

Procedure DXF_Entity.write_to_DXF( Var IO: textfile; Const layer: String; Lcolor: integer );
Begin
  writeln( IO, 0, EOL, proper_name );
  // AcadrR14
  // Write_handle(io);

  writeln( IO, 8, EOL, layer );
  // Check Entity's Color
  // if not defined Bylayer's color, uses entity color
  If Lcolor <> colinx Then
    writeln( IO, 62, EOL, colinx );
  If OCS_WCS <> Nil Then
    write_DXF_Point( IO, 210, OCS_axis );
End;

Function DXF_Entity.is_point_inside_object2D( p: Point3D ): boolean;
Begin
  result := false;
End;

Function DXF_Entity.Move_point( const p, newpoint: Point3D ): boolean;
Begin
  result := false;
End;

///////////////////////////////////////////////////////////////////////////////
// Block_ class implementation
///////////////////////////////////////////////////////////////////////////////

Constructor Block_.create( Const bname: String; refpoint: Point3D );
Begin
  entities := TList.Create;
  basepoint := refpoint;
  If Not p1_eq_p2_3D( basepoint, origin3D ) Then
  Begin
    OCS_WCS := allocate_matrix;
    OCS_WCS^ := TranslateMatrix( p1_minus_p2( origin3D, basepoint ) );
  End;
  name := bname;
End;

Destructor Block_.Destroy;
Var
  lp1: integer;
Begin
  For lp1 := 0 To entities.count - 1 Do
    DXF_Entity( entities[lp1] ).free;
  entities.Free;
End;

Procedure Block_.update_block_links( blist: TObject );
Var
  lp1: integer;
Begin
  For lp1 := 0 To entities.count - 1 Do
    If ( TObject( entities[lp1] ) Is Insert_ ) Then
      Insert_( entities[lp1] ).update_block_links( blist );
End;

// Added for GIS

Procedure Block_.AddToGIS( DxfImport: TEzDxfImport; OCS: pM );
Var
  lp1: integer;
  t_matrix: pMatrix;
  TempMatrix: Matrix;
Begin
  If OCS = Nil Then
    t_matrix := OCS_WCS
  Else If OCS_WCS = Nil Then
    t_matrix := OCS
  Else
  Begin
    TempMatrix := MatrixMultiply( OCS_WCS^, OCS^ );
    t_matrix := @TempMatrix;
  End;
  For lp1 := 0 To entities.count - 1 Do
  Begin
    Try
      DXF_Entity( entities[lp1] ).AddToGIS( DxfImport, t_matrix );
    Except
    End;
  End;
End;

Procedure Block_.setcolour( col: TColor );
(*var lp1        : integer;
   TempMatrix : Matrix; *)
Begin
  (*for lp1:=0 to entities.count-1 do
     DXF_Entity(entities[lp1]).Setcolour(col); *)
End;

Procedure Block_.write_to_DXF( Var IO: textfile; Const layer: String; Lcolor: Integer );
Var
  lp1: integer;
Begin
  writeln( IO, 0, EOL, proper_name );
  writeln( IO, 8, EOL, layer );
  writeln( IO, 2, EOL, name );
  writeln( IO, 70, EOL, 0 );
  write_DXF_Point( IO, 10, basepoint );
  //  writeln(IO,3 ,EOL,name);
  For lp1 := 0 To entities.count - 1 Do
    DXF_Entity( entities[lp1] ).write_to_DXF( IO, layer, lcolor );
  writeln( IO, 0, EOL, 'ENDBLK' );

  // AcadR14
  //  Write_handle(io);
  //  writeln(IO,8 ,EOL,layer);
End;

Procedure Block_.max_min_extents( Var emax, emin: Point3D );
Var
  lp1: integer;
Begin
  For lp1 := 0 To ( entities.Count - 1 ) Do
    DXF_Entity( entities[lp1] ).max_min_extents( emax, emin );
End;

Function Block_.closest_vertex_square_distance_2D( p: Point3D ): Double;
Begin
  result := 1E9;
End;

Function Block_.closest_vertex( p: Point3D ): Point3D;
Begin
  result := aPoint3D( 1E9, 1E9, 1E9 );
End;

///////////////////////////////////////////////////////////////////////////////
// Point
///////////////////////////////////////////////////////////////////////////////

Constructor Point_.create( OCSaxis, p: Point3D; col: integer );
Begin
  Inherited create;
  p1 := p;
  setcolour_index( col );
  init_OCS_WCS_matrix( OCSaxis );
End;

Procedure Point_.translate( T: Point3D );
Begin
  p1 := p1_plus_p2( p1, T );
End;

Procedure Point_.quantize_coords( epsilon: Double; mask: byte );
Begin
  If ( mask And 1 ) = 1 Then
    p1.x := round( p1.x * epsilon ) / epsilon;
  If ( mask And 2 ) = 2 Then
    p1.y := round( p1.y * epsilon ) / epsilon;
  If ( mask And 4 ) = 4 Then
    p1.z := round( p1.z * epsilon ) / epsilon;
End;

// Added for GIS
{transform the point}

Function original_transformed2D( P: Point3D; OCS: pMatrix ): TEzPoint;
Var
  p1: Point3D;
Begin
  If OCS = Nil Then
  Begin
    result.x := P.x;
    result.y := P.y;
  End
  Else
  Begin
    p1 := TransformPoint( OCS^, P );
    result.x := p1.x;
    result.y := p1.y;
  End;
End;

// Added for GIS

Procedure Point_.AddToGIS( DxfImport: TEzDxfImport; OCS: pM );
Var
  t_matrix: pMatrix;
  Entity2D: TEzEntity;
Begin
  //t_matrix := update_transformations(OCS_WCS,OCS);
  // this is not imported (for now)

  t_matrix := update_transformations( OCS_WCS, OCS );
  Entity2D := TEzPointEntity.CreateEntity( original_transformed2D( p1, t_matrix ), colour );
  //ImportVector( DxfImport, Entity2D.Points );

  DxfImport.FCad.CurrentLayer.AddEntity( Entity2D );
  FreeAndNil( Entity2D );
End;

Procedure Point_.write_to_DXF( Var IO: textfile; Const layer: String; Lcolor: Integer );
Begin
  Inherited;
  write_DXF_Point( IO, 10, p1 );
End;

Procedure Point_.max_min_extents( Var emax, emin: Point3D );
Begin
  max_bound( emax, p1 );
  min_bound( emin, p1 );
End;

Function Point_.closest_vertex_square_distance_2D( p: Point3D ): Double;
Begin
  result := sq_dist2D( p1, p );
End;

Function Point_.closest_vertex( p: Point3D ): Point3D;
Begin
  result := p1;
End;

Function Point_.Move_point( const p, newpoint: Point3D ): boolean;
Begin
  If p1_eq_p2_3D( p1, p ) Then
  Begin
    p1 := newpoint;
    result := True;
  End
  Else
    result := false;
End;

///////////////////////////////////////////////////////////////////////////////
// Text
///////////////////////////////////////////////////////////////////////////////

Constructor Text_.create( OCSaxis, p, ap: Point3D; rot: Double;
  Const ss, s1: String; height: Double; col, ha: integer );
Begin
  Inherited create( OCSaxis, p, col );
  h := height;
  If ss <> '' Then
    textstr := ss;
  If s1 <> '' Then
    style := s1;
  If p1_eq_p2_3D( ap, origin3D ) Then
    ap := p;
  align_pt := ap;
  hor_align := ha;
  rotation := rot;
  //  rotation    := DegToRad(rot);
End;

Procedure CanvasTextOutAngle( OutputCanvas: TCanvas; X, Y: integer;
  Angle: Word; Const St: String );
{-prints text at the desired angle}
{-current font must be TrueType!}
Var
  LogRec: TLogFont;
  NewFontHandle: HFont;
  OldFontHandle: HFont;
Begin
  GetObject( OutputCanvas.Font.Handle, SizeOf( LogRec ), Addr( LogRec ) );
  LogRec.lfEscapement := Angle;
  NewFontHandle := CreateFontIndirect( LogRec );
  OldFontHandle := SelectObject( OutputCanvas.Handle, NewFontHandle );
  OutputCanvas.TextOut( x, y, St );
  NewFontHandle := SelectObject( OutputCanvas.Handle, OldFontHandle );
  DeleteObject( NewFontHandle );
End; { CanvasTextOutAngle }

// Added for GIS

Procedure Text_.AddToGIS( DxfImport: TEzDxfImport; OCS: pM );
Var
  t_matrix: pMatrix;
  Entity2D: TEzEntity;
  InsPoint: TEzPoint;
  temph: double;
Begin
  t_matrix := update_transformations( OCS_WCS, OCS );
  InsPoint := original_transformed2D( align_pt, t_matrix );
  InsPoint.Y := InsPoint.Y + h;
  temph := h;

  if DxfImport.UseTrueType then
  begin
    Entity2D := TEzTrueTypeText.CreateEntity( InsPoint, textstr, temph, DegToRad( rotation ) );
    with TEzTrueTypeText( Entity2D ) do
    begin
      BeginUpdate;
      PenTool.style := 0;
      BrushTool.pattern := 0;
      Fonttool.Color := DxfImport.ProperColor( colour );
      EndUpdate;
    end;
  end else
  begin
    Entity2D := TEzFittedVectorText.CreateEntity( InsPoint, textstr, temph, -1, 0 );
    With TEzFittedVectorText( entity2d ) Do
    Begin
      BeginUpdate;
      FontColor := DxfImport.ProperColor( colour );
      Angle := DegToRad( rotation );
      PenTool.style := 0;
      BrushTool.pattern := 0;
      EndUpdate;
    End;
  end;

  DxfImport.FCad.CurrentLayer.AddEntity( Entity2D );
  FreeAndNil( Entity2D );

End;

Procedure Text_.write_to_DXF( Var IO: textfile; Const layer: String; Lcolor: Integer );
Begin
  Inherited;
  writeln( IO, 40, EOL, float_out( h ) );
  writeln( IO, 1, EOL, textstr );
  If trim( style ) <> '' Then
    writeln( IO, 7, EOL, style );

  If hor_align <> 0 Then
  Begin
    write_DXF_Point( IO, 11, align_pt );
    If rotation <> 0 Then
      writeln( IO, 50, EOL, float_out( rotation ) );
    writeln( IO, 72, EOL, hor_align );
  End;
End;

Procedure Text_.max_min_extents( Var emax, emin: Point3D );
Begin
  max_bound( emax, p1 );
  min_bound( emin, p1 );
End;

///////////////////////////////////////////////////////////////////////////////
// Attrib
///////////////////////////////////////////////////////////////////////////////

Constructor Attrib_.create( OCSaxis, p, ap: Point3D; rot: Double; Const ss, s1, tag: String; flag70, flag72: integer; height:
  Double; col: integer );
Begin
  Inherited create( OCSaxis, p, ap, rot, ss, s1, height, col, flag72 );
  tagstr := tag;
  If ( flag70 And 1 ) = 1 Then
    visible := false
  Else
    visible := True;
End;

// Added for GIS

Procedure Attrib_.AddToGIS( DxfImport: TEzDxfImport; OCS: pM );
Var
  t_matrix: pMatrix;
  Entity2D: TEzEntity;
  InsPoint: TEzPoint;
  temph: double;
Begin
  t_matrix := nil;//update_transformations( OCS_WCS, OCS );  is this correct ???
  If Not visible Then Exit;
  InsPoint := original_transformed2D( align_pt, t_matrix );
  InsPoint.Y := InsPoint.Y + h;
  temph := h;

  Entity2D := TEzFittedVectorText.CreateEntity( InsPoint, tagstr, temph, -1, 0 );

  //Entity2D:= TText2D.CreateEntity(InsPoint, tagstr, temph, rotation);

  TEzFittedVectorText( Entity2D ).FontColor := DxfImport.ProperColor( colour );
  { Actually, I don't know if to add attribs to the file }
  DxfImport.FCad.CurrentLayer.AddEntity( Entity2D );
  FreeAndNil( Entity2D );
End;

Procedure Attrib_.write_to_DXF( Var IO: textfile; Const layer: String; Lcolor: Integer );
Begin
  Inherited;
  writeln( IO, 2, EOL, tagstr );
  If visible Then
    writeln( IO, 70, EOL, 0 )
  Else
    writeln( IO, 70, EOL, 1 )
End;

///////////////////////////////////////////////////////////////////////////////
// Attdef
///////////////////////////////////////////////////////////////////////////////

Constructor Attdef_.create( OCSaxis, p, ap: Point3D; rot: Double;
  Const ss, s1, tag, prompt: String; flag70, flag72: integer;
  height: Double; col: integer );
Begin
  Inherited create( OCSaxis, p, ap, rot, ss, s1, tag, flag70, flag72, height, col );
  promptstr := prompt;
End;

// Added for GIS

Procedure Attdef_.AddToGIS( DxfImport: TEzDxfImport; OCS: pM );
Begin
  // Attdefs are used in the blocks section to act as templates for Attribs
  // so no need to draw them as there will be an Attrib in its place
End;

Procedure Attdef_.write_to_DXF( Var IO: textfile; Const layer: String; Lcolor: integer );
Begin
  Inherited;
  writeln( IO, DXF_text_prompt, EOL, promptstr );
End;

///////////////////////////////////////////////////////////////////////////////
// Insert
///////////////////////////////////////////////////////////////////////////////

Constructor Insert_.create( OCSaxis, p, s_f: Point3D; rot: Double; col: integer;
  numatts: integer; atts: patt_array; Const block: String );
Var
  lp1: integer;
Begin
  Inherited create( OCSaxis, p, col );
  blockname := block;
  blockptr := Nil;
  scale := s_f;
  rotation := DegToRad( rot );
  init_OCS_WCS_matrix( OCSaxis );
  num_attribs := numatts;
  If num_attribs > max_attribs Then
    num_attribs := max_attribs;
  //EzGISError('This version only handles '+IntToStr(max_attribs)+' ATTRIBs');
  For lp1 := 0 To num_attribs - 1 Do
    attribs[lp1] := atts^[lp1];
End;

Destructor Insert_.Destroy;
Var
  lp1: integer;
Begin
  For lp1 := 0 To num_attribs - 1 Do
    attribs[lp1].Free;
  If ( rotation <> 0 ) And ( NoOCS_WCS <> Nil ) Then
    deallocate_matrix( NoOCS_WCS );
  Inherited Destroy;
End;

Procedure Insert_.init_OCS_WCS_matrix( OCSaxis: Point3D );
Var
  Ax, Ay: Point3D;
Begin
  // inserts always have a transformation matrix - to allow the translation
  // even when the other parameters are defauls
  OCS_axis := OCSaxis;
  If OCS_WCS = Nil Then
    OCS_WCS := allocate_matrix; // caution for Memory Leak.
  If ( abs( OCSaxis.x ) < 1 / 64 ) And ( abs( OCSaxis.y ) < 1 / 64 ) Then
    Ax := normalize( cross( WCS_Y, OCSaxis ) )
  Else
    Ax := normalize( cross( WCS_Z, OCSaxis ) );
  Ay := normalize( cross( OCSaxis, Ax ) );
  OCS_WCS^ := Identity;
  OCS_WCS^ := MatrixMultiply( OCS_WCS^, ZRotateMatrix( cos( -rotation ), sin( -rotation ) ) );
  OCS_WCS^ := MatrixMultiply( OCS_WCS^, ScaleMatrix( scale ) );
  OCS_WCS^ := MatrixMultiply( OCS_WCS^, TranslateMatrix( p1 ) );
  OCS_WCS^ := MatrixMultiply( OCS_WCS^, CreateTransformation( Ax, Ay, OCSaxis ) );

  If Rotation <> 0 Then
  Begin
    If NoOCS_WCS = Nil Then
      NoOCS_WCS := allocate_matrix; // make no rotation OCS_WCS
    NoOCS_WCS^ := Identity;
    NoOCS_WCS^ := MatrixMultiply( NoOCS_WCS^, ScaleMatrix( scale ) );
    NoOCS_WCS^ := MatrixMultiply( NoOCS_WCS^, TranslateMatrix( p1 ) );
    NoOCS_WCS^ := MatrixMultiply( NoOCS_WCS^, CreateTransformation( Ax, Ay, OCSaxis ) );
  End;
End;

Procedure Insert_.update_block_links( blist: TObject );
Begin
  blocklist := blist;
  If blockname <> '' Then
    block.update_block_links( blist );
End;

// instead of searching for the block every time it's needed, we'll store
// the object pointer after the first time it's used, and return it
// when needed. Only use this function to access it - for safety.

Function Insert_.block: Block_;
Var
  lp1: integer;
  Blck: Block_;
Begin
  result := Nil;
  Try
    If blockptr = Nil Then
    Begin // this bit called once
      For lp1 := 0 To DXF_Layer( blocklist ).entities.count - 1 Do
      Begin
        Blck := Block_( DXF_Layer( blocklist ).entities[lp1] );
        If AnsiUpperCase(Blck.name) = AnsiUpperCase(blockname) Then
        Begin
          blockptr := Block_( DXF_Layer( blocklist ).entities[lp1] );
          result := blockptr;
          exit;
        End;

      End;
    End // this bit every subsequent time
    Else
      result := blockptr;
    //If result = Nil Then
    //Begin // ignoreing Non Exists blocks.
      // showmessage('Error in DXF File!'+#13#13+'Block reference '+blockname+' not found');}
      // EzGISError('Block reference '+blockname+' not found');
    //End;
  Except

  End;
End;

// Added for GIS

Procedure Insert_.AddToGIS( DxfImport: TEzDxfImport; OCS: pM );
Var
  lp1: integer;
  t_matrix: pMatrix;
  TempMatrix: Matrix;

  TmpPlace: TEzPlace;
  TmpP: TEzPoint;
  SymbolIndex: Integer;
  emin, emax: Point3D;
  TmpSize, PlaceSize: double;
Begin
  // we mustn't use the update_transformations call because inserts may be
  // nested inside blocks inside other blocks, and update_transformations uses
  // a temp fixed matrix which will be overwritten.
  If OCS = Nil Then
    t_matrix := OCS_WCS
  Else If OCS_WCS = Nil Then
    t_matrix := OCS
  Else
  Begin
    TempMatrix := MatrixMultiply( OCS_WCS^, OCS^ );
    t_matrix := @TempMatrix;
  End;

  If Not DxfImport.explodeblocks And ( block <> Nil ) Then
  Begin
    SymbolIndex := Ez_Symbols.IndexOfName( blockname );
    If SymbolIndex < 0 Then
      SymbolIndex := 0;
    //t_matrix := update_transformations(OCS_WCS,OCS);  // don't know if this is needed
    //TmpP:= original_transformed2D(p1,t_matrix);
    emax := aPoint3D( -1E20, -1E20, -1E20 );
    emin := aPoint3D( +1E20, +1E20, +1E20 );
    block.max_min_extents( emax, emin );
    TmpSize := dMax( Abs( emax.x - emin.x ), Abs( emax.y - emin.y ) );
    TmpSize := dMax( scale.x * TmpSize, scale.y * TmpSize );
    PlaceSize := DxfImport.Converter.ConvertDistance( TmpSize, Point2D( p1.x, p1.y ) );

    //TmpP := Point2D( p1.X + PlaceSize / 2, p1.Y + PlaceSize / 2 );
    TmpP := Point2d(p1.x,p1.y);
    TmpPlace := TEzPlace.CreateEntity( TmpP );

    With TmpPlace.Symboltool Do
    Begin
      Index := SymbolIndex;
      Rotangle := rotation;
      Height := PlaceSize;
    End;
    //ImportVector( DxfImport, TmpPlace.Points );
    DxfImport.FCad.CurrentLayer.AddEntity( TmpPlace );
    FreeAndNil( TmpPlace );
  End
  Else
  Begin
    For lp1 := 0 To num_attribs - 1 Do
    Begin
      Try
        attribs[lp1].AddToGIS( DxfImport, t_matrix );
      Except
      End;
    End;
    If ( blockname <> '' ) And ( block <> Nil ) Then
    Begin
      Try
        block.AddToGIS( DxfImport, t_matrix );
      Except
      End;
    End;
  End;
End;

Procedure Insert_.write_to_DXF( Var IO: textfile; Const layer: String; Lcolor: integer );
Var
  lp1: integer;
Begin
  Inherited;
  If blockname <> '' Then
    writeln( IO, 2, EOL, blockname );
  writeln( IO, 70, EOL, 0 );

  If ( scale.x <> 1 ) Or ( scale.y <> 1 ) Or ( scale.z <> 1 ) Then
  Begin
    writeln( IO, 41, EOL, float_out( scale.x ) );
    writeln( IO, 42, EOL, float_out( scale.y ) );
    writeln( IO, 43, EOL, float_out( scale.z ) );
  End;

  If rotation <> 0 Then
    writeln( IO, 50, EOL, float_out( RadToDeg( rotation ) ) );
  //    else writeln(IO,50,EOL,0);
  If num_attribs > 0 Then
  Begin
    writeln( IO, 66, EOL, 1 );
    For lp1 := 0 To num_attribs - 1 Do
      attribs[lp1].write_to_DXF( IO, layer, lcolor );
    writeln( IO, 0, EOL, 'SEQEND' );

    // AcadR14
    //   Write_handle(io);
    //   writeln(IO,8 ,EOL,layer);
  End;
  //  else writeln(IO,66,EOL,0);}
End;

Procedure Insert_.max_min_extents( Var emax, emin: Point3D );
Begin
  Inherited;
End;
///////////////////////////////////////////////////////////////////////////////
// Line
///////////////////////////////////////////////////////////////////////////////

Constructor Line_.create( p_1, p_2: Point3D; col: integer; LS: integer );
Begin
  Inherited create( WCS_Z, p_1, col );
  p2 := p_2;
  LineStyle := LS;
End;

Procedure Line_.translate( T: Point3D );
Begin
  p1 := p1_plus_p2( p1, T );
  p2 := p1_plus_p2( p2, T );
End;

Procedure Line_.quantize_coords( epsilon: Double; mask: byte );
Begin
  If ( mask And 1 ) = 1 Then
  Begin
    p1.x := round( p1.x * epsilon ) / epsilon;
    p2.x := round( p2.x * epsilon ) / epsilon;
  End;
  If ( mask And 2 ) = 2 Then
  Begin
    p1.y := round( p1.y * epsilon ) / epsilon;
    p2.y := round( p2.y * epsilon ) / epsilon;
  End;
  If ( mask And 4 ) = 4 Then
  Begin
    p1.z := round( p1.z * epsilon ) / epsilon;
    p2.z := round( p2.z * epsilon ) / epsilon;
  End;
End;

Function Line_.count_points: integer;
Begin
  result := 2;
End;

Function Line_.count_lines: integer;
Begin
  result := 1;
End;

// Added for GIS

Procedure Line_.AddToGIS( DxfImport: TEzDxfImport; OCS: pM );
Var
  t_matrix: pMatrix;
  Entity2D: TEzEntity;
Begin
  t_matrix := update_transformations( OCS_WCS, OCS );

  Entity2D := TEzPolyLine.CreateEntity( [original_transformed2D( p1, t_matrix ), original_transformed2D( p2, t_matrix )] );

  With TEzOpenedEntity( Entity2D ) Do
  Begin
    PenTool.Color := DxfImport.ProperColor( colour );
    PenTool.Style := LineStyle;
  End;
  //ImportVector( DxfImport, Entity2D.Points );
  DxfImport.FCad.CurrentLayer.AddEntity( Entity2D );
  FreeAndNil( Entity2D );
End;

Procedure Line_.write_to_DXF( Var IO: textfile; Const layer: String; Lcolor: integer );
Begin
  Inherited;
  If LineStyle <> 1 Then
    writeln( IO, 6, EOL, AcadlineStyle.GetLineStyle( LineStyle ) );
  write_DXF_Point( IO, 11, p2 );
End;

Procedure Line_.max_min_extents( Var emax, emin: Point3D );
Begin
  max_bound( emax, p1 );
  min_bound( emin, p1 );
  max_bound( emax, p2 );
  min_bound( emin, p2 );
End;

Function Line_.closest_vertex_square_distance_2D( p: Point3D ): Double;
Begin
  result := dmin( sq_dist2D( p1, p ), sq_dist2D( p2, p ) );
End;

Function Line_.closest_vertex( p: Point3D ): Point3D;
Begin
  If sq_dist2D( p1, p ) < sq_dist2D( p2, p ) Then
    result := p1
  Else
    result := p2;
End;

Function Line_.Move_point( const p, newpoint: Point3D ): boolean;
Begin
  If p1_eq_p2_3D( p1, p ) Then
  Begin
    p1 := newpoint;
    result := True;
  End
  Else If p1_eq_p2_3D( p2, p ) Then
  Begin
    p2 := newpoint;
    result := True;
  End
  Else
    result := false;
End;
///////////////////////////////////////////////////////////////////////////////
// Circle
///////////////////////////////////////////////////////////////////////////////

Constructor Circle_.create( OCSaxis, p_1: Point3D; radius_: Double; col: integer; LS: Integer );
Begin
  Inherited create( OCSaxis, p_1, col );
  radius := radius_;
  LineStyle := LS;
End;

Destructor Circle_.Destroy;
Begin
  Inherited Destroy;
End;

Constructor Circle_.create_from_polyline( ent1: DXF_Entity );
Var
  p_1: Point3D;
  d: Double;
  lp1: integer;
Begin
  p_1 := origin3D;
  d := 0;
  With Polyline_( ent1 ) Do
  Begin
    For lp1 := 0 To numvertices - 1 Do
      p_1 := p1_plus_p2( polypoints^[lp1], p_1 );
    p_1.x := p_1.x / numvertices;
    p_1.y := p_1.y / numvertices;
    p_1.z := p_1.z / numvertices;
    For lp1 := 0 To numvertices - 1 Do
      d := d + dist3D( polypoints^[lp1], p_1 );
    d := d / numvertices;
  End;
  Inherited create( ent1.OCS_axis, p_1, ent1.colinx );
  radius := d;
End;

// Added for GIS

Procedure Circle_.AddToGIS( DxfImport: TEzDxfImport; OCS: pM );
Var
  t_matrix: pMatrix;
  Entity2D: TEzEntity;
  tmpP1, tmpP2, tmpCenter: TEzPoint;
  tempradius: double;
Begin
  t_matrix := update_transformations( OCS_WCS, OCS );
  tmpCenter := original_transformed2D( p1, t_matrix );
  tempradius := radius;

  tempradius := DxfImport.Converter.ConvertDistance( tempradius, Point2D( p1.x, p1.y ) );
  tmpP1.X := tmpCenter.X - tempradius;
  tmpP1.Y := tmpCenter.Y - tempradius;
  tmpP2.X := tmpCenter.X + tempradius;
  tmpP2.Y := tmpCenter.Y + tempradius;
  Entity2D := TEzEllipse.CreateEntity( tmpP1, tmpP2 );
  //ImportVector(DxfImport,Entity2D.Points);

  With TEzEllipse( Entity2D ) Do
  Begin
    PenTool.Color := DxfImport.ProperColor( colour );
    PenTool.Style := LineStyle;
  End;
  DxfImport.FCad.CurrentLayer.AddEntity( Entity2D );
  FreeAndNil( Entity2D );
End;

Procedure Circle_.write_to_DXF( Var IO: textfile; Const layer: String; Lcolor: integer );
Begin
  Inherited;
  writeln( IO, 40, EOL, float_out( radius ) );
End;

Function Circle_.is_point_inside_object2D( p: Point3D ): boolean;
Begin
  result := ezdxfutil.dist2D( p, p1 ) <= radius;
End;

Procedure Circle_.max_min_extents( Var emax, emin: Point3D );
Begin
  max_bound( emax, p1_plus_p2( p1, aPoint3D( radius, radius, 0 ) ) );
  min_bound( emin, p1_minus_p2( p1, aPoint3D( radius, radius, 0 ) ) );
End;
///////////////////////////////////////////////////////////////////////////////
// Arc
///////////////////////////////////////////////////////////////////////////////

Constructor Arc_.create( OCSaxis, p_1: Point3D; radius_, sa, ea: Double; col: integer; LS: Integer );
Begin
  Inherited create( OCSaxis, p_1, radius_, col, LS );
  angle1 := DegToRad( sa );
  angle2 := DegToRad( ea );
End;

// Added for GIS

Procedure Arc_.AddToGIS( DxfImport: TEzDxfImport; OCS: pM );
Var
  t_matrix: pMatrix;
  Entity2D: TEzEntity;
  TmpPt, TmpCenter: TEzPoint;
  TmpRadius, ang1, ang2: double;
Begin
  If (radius = 0) Or (angle1 = angle2) Then exit;
  t_matrix := update_transformations(OCS_WCS, OCS);
  TmpCenter := original_transformed2D(p1, t_matrix);
  TmpRadius := DxfImport.Converter.ConvertDistance(radius, Point2D(p1.x, p1.y));
  TmpPt := Point2D(0, 0);
  Entity2D := TEzArc.CreateEntity(TmpPt, TmpPt, TmpPt);
  ang1:= angle1;
  ang2:= angle2;
  while ang2 < ang1 do ang2 := ang2 + System.PI;
  TEzArc(Entity2D).SetArc( TmpCenter.X, TmpCenter.Y, TmpRadius, angle1, ang2 - ang1, True);
  //ImportVector(DxfImport,Entity2D.Points);

  With TEzArc( Entity2D ) Do
  Begin
    PenTool.Color := DxfImport.ProperColor( colour );
    PenTool.Style := LineStyle;
  End;
  DxfImport.FCad.CurrentLayer.AddEntity( Entity2D );
  FreeAndNil( Entity2D );
End;

Procedure Arc_.write_to_DXF( Var IO: textfile; Const layer: String; Lcolor: integer );
Begin
  Inherited;
  writeln( IO, 50, EOL, float_out( RadToDeg( angle1 ) ) );
  writeln( IO, 51, EOL, float_out( RadToDeg( angle2 ) ) );
End;

Function Arc_.is_point_inside_object2D( p: Point3D ): boolean;
Begin
  result := false;
End;

Procedure Arc_.max_min_extents( Var emax, emin: Point3D );
Var
  ax, ay, bx, by: Double;
  thisboundary: integer;
  lastboundary: integer;
Begin
  // the end points of the arc
  ax := p1.x + radius * cos( angle1 );
  ay := p1.y + radius * sin( angle1 );
  bx := p1.x + radius * cos( angle2 );
  by := p1.y + radius * sin( angle2 );
  max_bound( emax, aPoint3D( ax, ay, 0 ) );
  min_bound( emin, aPoint3D( ax, ay, 0 ) );
  max_bound( emax, aPoint3D( bx, by, 0 ) );
  min_bound( emin, aPoint3D( bx, by, 0 ) );
  // long arcs may extend along the axes (quadrants) (eg 1 to 359 ->90,180,270)
  lastboundary := 90 * ( ( trunc( RadToDeg( angle2 ) ) + 89 ) Div 90 );
  If lastboundary = 360 Then
    lastboundary := 0;
  thisboundary := 90 * ( ( trunc( RadToDeg( angle1 ) ) + 90 ) Div 90 );
  If thisboundary = 360 Then
    thisboundary := 0;
  While thisboundary <> lastboundary Do
  Begin
    ax := p1.x + radius * cos( DegToRad( thisboundary ) );
    ay := p1.y + radius * sin( DegToRad( thisboundary ) );
    max_bound( emax, aPoint3D( ax, ay, 0 ) );
    min_bound( emin, aPoint3D( ax, ay, 0 ) );
    thisboundary := thisboundary + 90;
    If thisboundary >= 360 Then
    Begin
      exit;
    End;
  End;
End;
///////////////////////////////////////////////////////////////////////////////
// Polyline
///////////////////////////////////////////////////////////////////////////////

Constructor Polyline_.create( OCSaxis: Point3D; numpoints: integer;
  points: ppointlist; col: integer; closed_: boolean; LS: integer );
Var
  lp1: integer;
Begin
  Inherited create;
  init_OCS_WCS_matrix( OCSaxis );
  numvertices := numpoints;
  If closed_ Then
    closed := True
  Else If p1_eq_p2_3D( points[0], points[numvertices - 1] ) Then
  Begin
    closed := True;
    dec( numvertices );
  End
  Else
    closed := false;
  polypoints := allocate_points( numvertices );
  For lp1 := 0 To numvertices - 1 Do
    polypoints^[lp1] := points^[lp1];
  setcolour_index( col );
  LineStyle := LS;
End;

Destructor Polyline_.Destroy;
Begin
  deallocate_points( polypoints, numvertices );
  Inherited Destroy;
End;

Procedure Polyline_.translate( T: Point3D );
Var
  lp1: integer;
Begin
  For lp1 := 0 To numvertices - 1 Do
    polypoints^[lp1] := p1_plus_p2( polypoints^[lp1], T );
End;

Procedure Polyline_.quantize_coords( epsilon: Double; mask: byte );
Var
  lp1: integer;
Begin
  For lp1 := 0 To numvertices - 1 Do
  Begin
    If ( mask And 1 ) = 1 Then
      polypoints^[lp1].x := round( polypoints^[lp1].x * epsilon ) / epsilon;
    If ( mask And 2 ) = 2 Then
      polypoints^[lp1].y := round( polypoints^[lp1].y * epsilon ) / epsilon;
    If ( mask And 4 ) = 4 Then
      polypoints^[lp1].z := round( polypoints^[lp1].z * epsilon ) / epsilon;
  End;
End;

Function Polyline_.count_points: integer;
Begin
  result := numvertices;
End;

Function Polyline_.count_lines: integer;
Begin
  result := numvertices;
End;

Function Polyline_.count_polys_open: integer;
Begin
  If Not closed Then
    result := 1
  Else
    result := 0;
End;

Function Polyline_.count_polys_closed: integer;
Begin
  If closed Then
    result := 1
  Else
    result := 0;
End;

// Added for GIS

Procedure Polyline_.AddToGIS( DxfImport: TEzDxfImport; OCS: pM );
Var
  cnt: integer;
  t_matrix: pMatrix;
  Entity2D: TEzEntity;
  p1: TEzPoint;
  PointArray: Array[0..max_vertices_per_polyline - 1] Of TEzPoint;
  layer: TEzBaseLayer;
  ZValue: String;
  Passed: Boolean;
  TheRecno: Integer;
Begin

  t_matrix := update_transformations( OCS_WCS, OCS );
  If numvertices < 2 Then Exit;

  Layer := DxfImport.FCad.CurrentLayer ;
  Passed := ( Layer <> Nil ) And ( Layer.DBTable <> Nil ) And ( Layer.DBTable.FieldNo( 'Z' ) > 0 );
  ZValue := '';
  For cnt := 0 To numvertices - 1 Do
  Begin
    p1 := original_transformed2D( polypoints^[cnt], t_matrix );
    PointArray[cnt] := p1;
    If Passed Then
    Begin
      If Cnt <> numvertices - 1 Then
        ZValue := ZValue + Floattostr( polypoints^[cnt].z ) + '|'
      Else
        ZValue := ZValue + Floattostr( polypoints^[cnt].z );
    End;
  End;

  If Closed Then
    Entity2D := TEzPolygon.CreateEntity( Slice( PointArray, numvertices ) )
  Else
    Entity2D := TEzPolyLine.CreateEntity( Slice( PointArray, numvertices ) );
  With TEzOpenedEntity( Entity2D ) Do
  Begin
    PenTool.Color := DxfImport.ProperColor( colour );
    PenTool.Style := LineStyle;
  End;

  //ImportVector( DxfImport, Entity2D.Points );
  TheRecno:= Layer.AddEntity( Entity2D );
  FreeAndNil( Entity2D );

  { Z value }
  If Passed Then
  Begin
    Layer.DBTable.Recno:= TheRecno;
    Layer.DBTable.Edit;
    Layer.DBTable.StringPut( 'Z', ZValue );
    Layer.DBTable.Post;
  End;
End;

Procedure Polyline_.write_to_DXF( Var IO: textfile; Const layer: String; Lcolor: integer );
Var
  lp1: integer;
Begin
  If Numvertices < 2 Then
    exit;

  Inherited;
  If LineStyle <> 1 Then
    writeln( IO, 6, EOL, AcadlineStyle.GetLineStyle( LineStyle ) );
  writeln( IO, 66, EOL, 1 );
  If closed Then
    writeln( IO, 70, EOL, 1 + 8 ) // 1+8 = closed+3D
  Else
    writeln( IO, 70, EOL, 8 );
  For lp1 := 0 To numvertices - 1 Do
  Begin
    writeln( IO, 0, EOL, 'VERTEX' );

    // AcadR14
    // Write_handle(io);

    writeln( IO, 8, EOL, layer );
    writeln( IO, 70, EOL, 32 ); // 3D polyline mesh vertex
    write_DXF_Point( IO, 10, polypoints^[lp1] );
  End;
  writeln( IO, 0, EOL, 'SEQEND' );
End;

Procedure Polyline_.max_min_extents( Var emax, emin: Point3D );
Var
  lp1: integer;
Begin
  For lp1 := 0 To numvertices - 1 Do
  Begin
    max_bound( emax, polypoints^[lp1] );
    min_bound( emin, polypoints^[lp1] );
  End;
End;

Function Polyline_.closest_vertex_square_distance_2D( p: Point3D ): Double;
Var
  lp1: integer;
Begin
  result := 1E10;
  For lp1 := 0 To numvertices - 1 Do
    result := dmin( result, sq_dist2D( polypoints^[lp1], p ) );
End;

Function Polyline_.closest_vertex( p: Point3D ): Point3D;
Var
  lp1: integer;
  d1, d2: Double;
Begin
  d1 := 1E10;
  For lp1 := 0 To numvertices - 1 Do
  Begin
    d2 := sq_dist2D( polypoints^[lp1], p );
    If d2 < d1 Then
    Begin
      result := polypoints^[lp1];
      d1 := d2;
    End;
  End;
End;

Function Polyline_.Move_point( const p, newpoint: Point3D ): boolean;
Var
  lp1: integer;
Begin
  For lp1 := 0 To numvertices - 1 Do
  Begin
    If p1_eq_p2_3D( polypoints^[lp1], p ) Then
    Begin
      polypoints^[lp1] := newpoint;
      result := True;
      exit;
    End;
  End;
  result := false;
End;

Function Polyline_.triangle_centre: Point3D;
Var
  s, t: integer;
Begin
  If numvertices <> 3 Then
    EzGISError( 'Shouldn''t call this for non triangular facets' );
  s := 1;
  t := 2;
  result := p1_plus_p2( polypoints^[0], p1_plus_p2( polypoints^[s], polypoints^[t] ) );
  result := p1_x_n( result, 1 / 3 );
End;

Procedure Polyline_.set_attrib( i: integer; v: Double );
Begin
  If ( i + 1 ) > numattrs Then
    numattrs := ( i + 1 );
  attribs[i] := v;
End;

Function Polyline_.get_attrib( i: integer ): Double;
Begin
  If i >= numattrs Then
    result := 0
  Else
    result := attribs[i];
End;

Procedure Polyline_.copy_attribs( p: Polyline_ );
Var
  lp1: integer;
Begin
  p.numattrs := numattrs;
  For lp1 := 0 To numattrs - 1 Do
    p.attribs[lp1] := attribs[lp1];
End;

Function Polyline_.is_point_inside_object2D( p: Point3D ): boolean;
Var
  i, j: integer;
  p1_i, p1_j: Point3D;
Begin
  result := false;
  If Not closed Then
    exit;
  j := numvertices - 1;
  For i := 0 To numvertices - 1 Do
    With p Do
    Begin
      p1_i := polypoints^[i];
      p1_j := polypoints^[j];
      If ( ( ( ( p1_i.y <= y ) And ( y < p1_j.y ) ) Or
        ( ( p1_j.y <= y ) And ( y < p1_i.y ) ) ) And
        ( x < ( p1_j.x - p1_i.x ) * ( y - p1_i.y ) /
        ( p1_j.y - p1_i.y ) + p1_i.x ) ) Then
        result := Not result;
      j := i;
    End;
End;

///////////////////////////////////////////////////////////////////////////////
// Face3D
///////////////////////////////////////////////////////////////////////////////

Constructor Face3D_.create( numpoints: integer; points: ppointlist; col: integer; closed_: boolean; LS: Integer );
Begin
  Inherited create( WCS_Z, numpoints, points, col, closed_, LS );
End;

Function Face3D_.proper_name: String;
Begin
  result := '3DFACE';
End;

Procedure Face3D_.write_to_DXF( Var IO: textfile; Const layer: String; Lcolor: integer );
Var
  lp1: integer;
Begin
  writeln( IO, 0, EOL, proper_name );

  // AcadR14
  //  Write_handle(io);

  writeln( IO, 8, EOL, layer );
  writeln( IO, 62, EOL, colinx );
  If LineStyle <> 1 Then
    writeln( IO, 6, EOL, AcadlineStyle.GetLineStyle( LineStyle ) );
  For lp1 := 0 To numvertices - 1 Do
    write_DXF_Point( IO, 10 + lp1, polypoints^[lp1] );
  If numvertices = 3 Then
  Begin // 4th point is same as third
    lp1 := 3;
    write_DXF_Point( IO, 10 + lp1, polypoints^[lp1 - 1] );
  End;
End;

///////////////////////////////////////////////////////////////////////////////
// Solid_
///////////////////////////////////////////////////////////////////////////////

Constructor Solid_.create( OCSaxis: Point3D; numpoints: integer; points: ppointlist; col: integer; t: Double; LS: Integer );
Begin
  Inherited create( numpoints, points, col, True, LS );
  thickness := t;
  init_OCS_WCS_matrix( OCSaxis );
End;

Function Solid_.proper_name: String;
Begin
  result := 'SOLID';
End;

// Added for GIS

Procedure Solid_.AddToGIS( DxfImport: TEzDxfImport; OCS: pM );
Var
  cnt: integer;
  t_matrix: pMatrix;
  Entity2D: TEzEntity;
  //p1         : TEzPoint;
  PointArray: Array[0..max_vertices_per_polyline - 1] Of TEzPoint;
  //Lp0,
  //Vertcheck  : integer ;
  //OrgColor   : Tcolor ;
Begin
  t_matrix := update_transformations( OCS_WCS, OCS );
  If numvertices < 2 Then
    exit; //error solid, solid need more then 2 point.
  If numvertices = 3 Then
  Begin
    For cnt := 0 To numvertices - 1 Do
    Begin
      PointArray[cnt] := original_transformed2D( polypoints^[cnt], t_matrix );
    End;
  End
  Else If numvertices = 4 Then
  Begin
    For cnt := 0 To 1 Do
    Begin
      PointArray[cnt] := original_transformed2D( polypoints^[cnt], t_matrix );
    End;
    PointArray[2] := original_transformed2D( polypoints^[3], t_matrix );
    PointArray[3] := original_transformed2D( polypoints^[2], t_matrix );

    (* VertCheck := 2 ; // 2
    lp0 := 2;
    while Vertcheck<numvertices do
    begin
      inc( VertCheck );
      if VertCheck<numvertices then
        PointArray[ lp0 ] := original_transformed2D(polypoints^[ vertcheck ],t_matrix);
      inc( VertCheck );
      inc( lp0 );
    end ;

    VertCheck := numvertices - 2 ; // 2
    while Vertcheck>=0 do
    begin
      if VertCheck>=0 then
        PointArray[ lp0 ] := original_transformed2D(polypoints^[ vertcheck ],t_matrix);
      dec( VertCheck , 2 );
      inc( lp0 );
    end; *)

  End;

  Entity2D := TEzPolygon.CreateEntity( Slice( PointArray, numvertices ) );
  With TEzPolygon( Entity2D ) Do
  Begin
    PenTool.Color := DxfImport.ProperColor( colour );
    PenTool.Style := LineStyle;
    BrushTool.Color := Colour;
    BrushTool.Pattern := 1;
  End;

  //ImportVector( DxfImport, Entity2D.Points );
  DxfImport.FCad.CurrentLayer.AddEntity( Entity2D );
  FreeAndNil( Entity2D );
End;

Procedure Solid_.write_to_DXF( Var IO: textfile; Const layer: String; Lcolor: integer );
Begin
  Inherited;
  writeln( IO, 39, EOL, thickness );
End;

///////////////////////////////////////////////////////////////////////////////
// Polyline_ (polygon MxN grid mesh)
///////////////////////////////////////////////////////////////////////////////

Constructor Polygon_mesh_.create( numpoints, Mc, Nc: integer; points: ppointlist; closebits, col: integer; LS: integer );
Begin
  Inherited create( WCS_Z, numpoints, points, col, false, LS );
  M := Mc;
  N := Nc;
  closeM := ( closebits And 1 ) = 1;
  closeN := ( closebits And 32 ) = 32;
End;

Function Polygon_mesh_.proper_name: String;
Begin
  result := 'POLYLINE';
End;

// Added for GIS

Procedure Polygon_mesh_.AddToGIS( DxfImport: TEzDxfImport; OCS: pM );
Var
  p1: TEzPoint;
  PointArray: ppointlist;
  PointArrayN: ppointlist;
  lp1, lp2, inx, NP: integer;
  t_matrix: pMatrix;
  polyent: Polyline_;
Begin
  t_matrix := update_transformations( OCS_WCS, OCS );
  PointArray := allocate_points( numvertices );
  For lp1 := 0 To numvertices - 1 Do
  Begin
    p1 := original_transformed2D( polypoints^[lp1], t_matrix );
    PointArray^[lp1].x := p1.x;
    PointArray^[lp1].y := p1.y;
    PointArray^[lp1].z := 0;
  End;
  // draw the M N-length polylines - we can use the array directly
  For lp1 := 0 To M - 1 Do
  Begin
    polyent := Polyline_.Create( OCS_axis, N, ppointlist( @PointArray^[N * lp1] ), colinx, closeN, 0 );
    Try
      polyent.AddToGIS( DxfImport, Nil );
    Except
    End;
    polyent.Free;
  End;
  // draw the N M-length polylines - we need to hop along the array in M steps
  For lp1 := 0 To N - 1 Do
  Begin
    NP := 1 + ( M - 1 );
    If closeM Then
      Inc( NP );
    PointArrayN := allocate_points( NP );
    PointArrayN^[0] := PointArray^[lp1];
    inx := 1;
    For lp2 := 1 To M - 1 Do
    Begin
      PointArrayN^[inx] := PointArray^[lp2 * N + lp1];
      Inc( inx );
    End;
    If closeM Then
      PointArrayN^[inx] := PointArray^[lp1];
    polyent := Polyline_.Create( OCS_axis, NP, ppointlist( @PointArrayN^[0] ), colinx, closeM, LineStyle );
    Try
      polyent.AddToGIS( DxfImport, Nil );
    Except
    End;
    polyent.Free;
    deallocate_points( PointArrayN, NP );
  End;

  deallocate_points( PointArray, numvertices );
End;

Procedure Polygon_mesh_.write_to_DXF( Var IO: textfile; Const layer: String; Lcolor: integer );
Var
  lp1, flag: integer;
Begin
  writeln( IO, 0, EOL, proper_name );

  // AcadR14
  //  Write_handle(io);

  writeln( IO, 8, EOL, layer );
  writeln( IO, 62, EOL, colinx );
  If LineStyle <> 1 Then
    writeln( IO, 6, EOL, AcadlineStyle.GetLineStyle( LineStyle ) );
  writeln( IO, 66, EOL, 1 );
  flag := 16;
  If closeM Then
    flag := flag + 1;
  If closeN Then
    flag := flag + 32;
  writeln( IO, 70, EOL, flag );
  writeln( IO, 71, EOL, M );
  writeln( IO, 72, EOL, N );
  For lp1 := 0 To numvertices - 1 Do
  Begin
    writeln( IO, 0, EOL, 'VERTEX' );
    writeln( IO, 8, EOL, layer );
    //    writeln(IO,70 ,EOL,64);    // polygon mesh vertex
    write_DXF_Point( IO, 10, polypoints^[lp1] );
    writeln( IO, 70, EOL, 64 ); // polygon mesh vertex
  End;
  writeln( IO, 0, EOL, 'SEQEND' );
End;

Type
  ptarray = Array[0..max_vertices_per_polyline - 1] Of TPoint;
  pptarray = ^ptarray;

  ///////////////////////////////////////////////////////////////////////////////
  // Polyline_ (polyface vertex array mesh)
  ///////////////////////////////////////////////////////////////////////////////

Constructor Polyface_mesh_.create( numpoints, nfaces: integer;
  points: ppointlist; faces: pfacelist; col: integer; LS: integer );
Var
  lp1: integer;
Begin
  DXF_Entity.create; // don't call polyline_constructor
  numvertices := numpoints;
  numfaces := nfaces;
  polypoints := allocate_points( numvertices );
  For lp1 := 0 To numvertices - 1 Do
    polypoints^[lp1] := points^[lp1];
  Getmem( facelist, numfaces * SizeOf( polyface ) );
  For lp1 := 0 To numfaces - 1 Do
    facelist^[lp1] := faces^[lp1];
  setcolour_index( col );
  LineStyle := LS;
End;

Destructor Polyface_mesh_.Destroy;
Begin
  Freemem( facelist, numfaces * SizeOf( polyface ) );
  Inherited Destroy;
End;

Function Polyface_mesh_.proper_name: String;
Begin
  result := 'POLYLINE';
End;

Procedure Polyface_mesh_.AddToGIS( DxfImport: TEzDxfImport; OCS: pM );
Var
  p1: TEzPoint;
  PointArray: Array[0..3] Of Point3D;
  lp1, lp2, inx: integer;
  t_matrix: pMatrix;
  polyent: Polyline_;
Begin
  t_matrix := update_transformations( OCS_WCS, OCS );
  For lp1 := 0 To numfaces - 1 Do
  Begin
    For lp2 := 0 To 3 Do
    Begin
      inx := facelist^[lp1].nf[lp2];
      If inx < 0 Then
        break; // index -> -1 = end of vertices
      p1 := original_transformed2D( polypoints^[inx], t_matrix );
      PointArray[lp2].x := p1.x;
      PointArray[lp2].y := p1.y;
      PointArray[lp2].z := 0;
    End;
    {crea el poligono}
    polyent := Polyline_.Create( OCS_axis, 4, ppointlist( @PointArray[0] ), colinx, True, LineStyle );
    Try
      polyent.AddToGIS( DxfImport, Nil );
    Except
    End;
    polyent.Free;
  End;
End;

Procedure Polyface_mesh_.write_to_DXF( Var IO: textfile; Const layer: String; Lcolor: integer );
Var
  lp1, lp2: integer;
Begin
  writeln( IO, 0, EOL, proper_name );

  // AcadR14
  //  Write_handle(io);

  writeln( IO, 8, EOL, layer );
  writeln( IO, 62, EOL, colinx );
  If LineStyle <> 1 Then
    writeln( IO, 6, EOL, AcadlineStyle.GetLineStyle( LineStyle ) );
  writeln( IO, 66, EOL, 1 );
  writeln( IO, 70, EOL, 64 );
  writeln( IO, 71, EOL, numvertices );
  writeln( IO, 72, EOL, numfaces );
  For lp1 := 0 To numvertices - 1 Do
  Begin
    writeln( IO, 0, EOL, 'VERTEX' );
    // New added code
    writeln( IO, 8, EOL, layer );
    writeln( IO, 70, EOL, 64 + 128 ); // polyface mesh coordinate vertex
    write_DXF_Point( IO, 10, polypoints^[lp1] )
  End;

  For lp1 := 0 To numfaces - 1 Do
  Begin
    writeln( IO, 0, EOL, 'VERTEX' );

    // Acad R14
    //    Write_handle(io);

    // New Added dxf code
    writeln( IO, 8, EOL, layer );
    writeln( IO, 70, EOL, 128 ); // polyface mesh face vertex
    writeln( IO, 10, EOL, 0 );
    writeln( IO, 20, EOL, 0 );
    writeln( IO, 30, EOL, 0 );
    For lp2 := 0 To 3 Do
      writeln( IO, 71 + lp2, EOL, facelist^[lp1].nf[lp2] + 1 );
  End;
  writeln( IO, 0, EOL, 'SEQEND' );
End;

//*****************************************************************************
// DXF_Layer class implementation
//*****************************************************************************

Constructor DXF_Layer.create( Const l_name: String; Lcolor: integer; LS: String );
Begin
  layer_name := l_name;
  entities := TList.Create;
  If ( Lcolor = 0 ) Or ( Lcolor > 255 ) Then
    Lcolor := 7; {99.10.30}
  layer_colinx := Lcolor;
  If LS = '' Then
    LS := 'CONTINUOUS';
  LineStyle := AcadLineStyle.FindLineStyle( LS );
  LineType := LS;
  FContinueProcessing := True;
End;

Destructor DXF_Layer.Destroy;
Var
  lp1: integer;
Begin
  For lp1 := 0 To entities.Count - 1 Do
    DXF_Entity( entities[lp1] ).Free;
  entities.Free;
  Inherited Destroy;
End;

Function DXF_Layer.add_entity_to_layer( entity: DXF_Entity ): boolean;
Begin
  result := false;
  entities.add( entity );
  If ( ( entity.colour = 0 ) Or ( entity.colour = BYLAYER ) ) Then
    entity.setcolour_index( layer_colinx );
End;

Procedure DXF_Layer.max_min_extents( Var emax, emin: Point3D );
Var
  lp1: integer;
Begin
  For lp1 := 0 To entities.Count - 1 Do
    DXF_Entity( entities[lp1] ).max_min_extents( emax, emin );
End;

Function DXF_Layer.num_entities: integer;
Begin
  result := entities.Count;
End;

Procedure DXF_Layer.AddToGIS( DxfImport: TEzDxfImport; OCS: pM );
Var
  lp1: integer;
Begin
  For lp1 := 0 To entities.Count - 1 Do
  Begin
    Try
      DXF_Entity( entities[lp1] ).AddToGIS( DxfImport, OCS );
      Inc( DxfImport.FTotalProcessed );
      FContinueProcessing := DxfImport.UpdateProgress;
      If Not FContinueProcessing Then
        Break;
    Except
    End;
  End;
End;

///////////////////////////////////////////////////////////////////////////////
// DXF_Object class implementation
///////////////////////////////////////////////////////////////////////////////

Constructor DXF_Object.create( ADxfFile: TEzDxfFile; Const aname: String );
Begin
  DxfFile := ADxfFile;
  layer_lists := TList.create;
  If aname <> '' Then
    FDXF_name := aname
  Else
    FDXF_name := 'Untitled';
  emax := origin3D;
  emin := origin3D;
End;

Constructor DXF_Object.Create_from_file( ADxfFile: TEzDxfFile;
  Const aname: String; skipped, errlog: Tstrings );
Begin
  DxfFile := ADxfFile;
  ReadDXF( aname, skipped, errlog );
End;

Procedure DXF_Object.ReadDXF( Const aname: String; skipped, errlog: Tstrings );
Var
  Reader: DXF_Reader;
  Text: String;
  GIS: TEzBaseGIS;
Begin
  Screen.Cursor := crHourglass;
  Try
    GIS := DxfFile.FDrawBox.GIS;
    Reader := DXF_Reader.Create( GIS, aname, DxfFile );
    With Reader Do
      If read_file Then
      Begin
        name := ExtractFileName( aname );
        emax := get_max_extent;
        emin := get_min_extent;
        layer_lists := release_control_of_layers;
      End
      Else
      Begin
        layer_lists := TList.Create;
        FDXF_name := aname;
        emax := origin3D;
        emin := origin3D;
      End;

    If DXF_ErrShow = 1 Then
      If reader.Acad_version <> 12 Then
      Begin
        Text := aname + #13#13 +
          'DXF file version is ' + Inttostr( reader.Acad_version ) + ' so, you might be' +
          #13#13 + 'see all of dxf files''s entity';
        Application.MessageBox( PChar( Text ), pchar( '' ), MB_OK Or MB_ICONEXCLAMATION )
      End;

    If Dxf_errShow = 0 Then
    Begin
      If reader.Acad_version <> 12 Then
        Dxf_ErrShow := 2;
      Dxf_version := Reader.acad_version;
    End;

    Try
      If Reader.Errlist.count > 0 Then
        If errlog <> Nil Then
          Errlog.Assign( Reader.ErrList );
    Except
    End;
    Reader.Free;
  Finally
    If ( AcadColorPal = Nil ) Then
      AcadColorPal := TAcadColorPal.Create;
    If ( AcadLineStyle = Nil ) Then
      AcadLineStyle := TAcadLineStyle.Create;
    Screen.Cursor := crDefault;
  End;
End;

Destructor DXF_Object.Destroy;
Var
  lp1: integer;
Begin
  If layer_lists <> Nil Then
  Begin
    For lp1 := 0 To layer_lists.Count - 1 Do
      DXF_Layer( layer_lists.Items[lp1] ).Free;
    layer_lists.Free;
  End;
  FreeAndNil( AcadColorPal );
  FreeAndNil( AcadLineStyle );
  Inherited Destroy;
End;

Procedure DXF_Object.save_to_file( Const aname: String );
Var
  Writer: DXF_Writer;
Begin
  Try
    writer := DXF_writer.create( aname, layer_lists );
    writer.write_file;
    writer.free;
  Except
    Showmessage( SDXFCannotSave );
  End;
End;

Function DXF_Object.num_layers: integer;
Begin
  result := layer_lists.Count
End;

Function DXF_Object.new_layer( Const aname: String; DUPs_OK: boolean ): DXF_Layer;
Var
  lp1: integer;
Begin
  For lp1 := 0 To layer_lists.Count - 1 Do
  Begin
    If AnsiCompareText( DXF_Layer( layer_lists[lp1] ).name, aname ) = 0 Then
    Begin
      If Not DUPs_OK Then
        Raise EDXF_exception.Create( SDXFDupLayer );
      result := DXF_Layer( layer_lists[lp1] );
      exit;
    End;
  End;
  result := DXF_Layer.Create( aname, 7, 'CONTINUOUS' );
  layer_lists.Add( result );
End;

Function DXF_Object.add_layer( layer: DXF_Layer ): boolean;
Var
  lp1: integer;
Begin
  result := false;
  For lp1 := 0 To layer_lists.Count - 1 Do
    If DXF_Layer( layer_lists[lp1] ).name = layer.name Then
      Raise EDXF_exception.Create( SDXFDupLayer );
  layer_lists.Add( layer );
End;

Function DXF_Object.layer( Const aname: String ): DXF_Layer;
Var
  lp1: integer;
Begin
  result := Nil;
  For lp1 := 0 To layer_lists.Count - 1 Do
    If DXF_Layer( layer_lists[lp1] ).name = aname Then
    Begin
      result := DXF_Layer( layer_lists[lp1] );
      exit;
    End;
End;

// Avoid using this if possible because we have to search for layer name every time

Function DXF_Object.add_entity_to_layer( entity: DXF_Entity; Const aname: String ): boolean;
Var
  lp1: integer;
Begin
  For lp1 := 0 To layer_lists.Count - 1 Do
    If DXF_Layer( layer_lists[lp1] ).name = aname Then
    Begin
      DXF_Layer( layer_lists[lp1] ).add_entity_to_layer( entity );
      result := True;
      exit;
    End;
  Raise EDXF_exception.Create( SDXFNoName );
End;

Function DXF_Object.Create_or_find_layer( Const aname: String ): DXF_Layer;
Var
  lp1: integer;
Begin
  For lp1 := 0 To layer_lists.Count - 1 Do
    If DXF_Layer( layer_lists[lp1] ).name = aname Then
    Begin
      result := DXF_Layer( layer_lists[lp1] );
      exit;
    End;
  result := new_layer( aname, True );
End;

Function DXF_Object.get_min_extent: Point3D;
Begin
  result := emin;
End;

Function DXF_Object.get_max_extent: Point3D;
Begin
  result := emax;
End;

Procedure DXF_Object.max_min_extents( Var emax, emin: Point3D );
Var
  lp1: integer;
Begin
  For lp1 := 0 To layer_lists.Count - 1 Do
    DXF_Layer( layer_lists[lp1] ).max_min_extents( emax, emin );
End;

//*****************************************************************************

Function TAcadColorPal.GetColors( Index: Integer ): Integer;
Begin
  If Index In [1..255] Then
    Result := FColorData[Index]
  Else
    Result := clBlack;
End;

Function TAcadColorPal.NumColors: Integer;
Begin
  Result := High( FColorData );
End;

Constructor TAcadColorPal.Create;
Var
  Colorno: integer;

  Procedure myRGB( r, g, b: byte );
  Begin
    FColorData[Colorno] := 65536 * b + 256 * g + r;
    inc( Colorno );
  End;

Begin
  Inherited Create;

  Colorno := 0;
  myRGB( 0, 0, 0 ); { black }
  myRGB( 255, 0, 0 ); { red }
  myRGB( 255, 255, 0 ); { yellow }
  myRGB( 0, 255, 0 ); { green }
  myRGB( 0, 255, 255 ); { cyan }
  myRGB( 0, 0, 255 ); { blue }
  myRGB( 255, 0, 255 ); { magenta }
  myRGB( 0, 0, 0 ); { white } //RGB(255, 255, 255);   { white }
  myRGB( 152, 152, 152 ); { grey -- an educated guess }
  myRGB( 192, 192, 192 ); { light grey -- an educated guess }
  myRGB( 255, 0, 0 );
  myRGB( 255, 128, 128 );
  myRGB( 166, 0, 0 );
  myRGB( 166, 83, 83 );
  myRGB( 128, 0, 0 );
  myRGB( 128, 64, 64 );
  myRGB( 76, 0, 0 );
  myRGB( 76, 38, 38 );
  myRGB( 38, 0, 0 );
  myRGB( 38, 19, 19 );
  myRGB( 255, 64, 0 );
  myRGB( 255, 159, 128 );
  myRGB( 166, 41, 0 );
  myRGB( 166, 104, 83 );
  myRGB( 128, 32, 0 );
  myRGB( 128, 80, 64 );
  myRGB( 76, 19, 0 );
  myRGB( 76, 48, 38 );
  myRGB( 38, 10, 0 );
  myRGB( 38, 24, 19 );
  myRGB( 255, 128, 0 );
  myRGB( 255, 191, 128 );
  myRGB( 166, 83, 0 );
  myRGB( 166, 124, 83 );
  myRGB( 128, 64, 0 );
  myRGB( 128, 96, 64 );
  myRGB( 76, 38, 0 );
  myRGB( 76, 57, 38 );
  myRGB( 38, 19, 0 );
  myRGB( 38, 29, 19 );
  myRGB( 255, 191, 0 );
  myRGB( 255, 223, 128 );
  myRGB( 166, 124, 0 );
  myRGB( 166, 145, 83 );
  myRGB( 128, 96, 0 );
  myRGB( 128, 112, 64 );
  myRGB( 76, 57, 0 );
  myRGB( 76, 67, 38 );
  myRGB( 38, 29, 0 );
  myRGB( 38, 33, 19 );
  myRGB( 255, 255, 0 );
  myRGB( 255, 255, 128 );
  myRGB( 166, 166, 0 );
  myRGB( 166, 166, 83 );
  myRGB( 128, 128, 0 );
  myRGB( 128, 128, 64 );
  myRGB( 76, 76, 0 );
  myRGB( 76, 76, 38 );
  myRGB( 38, 38, 0 );
  myRGB( 38, 38, 19 );
  myRGB( 191, 255, 0 );
  myRGB( 223, 255, 128 );
  myRGB( 124, 166, 0 );
  myRGB( 145, 166, 83 );
  myRGB( 96, 128, 0 );
  myRGB( 112, 128, 64 );
  myRGB( 57, 76, 0 );
  myRGB( 67, 76, 38 );
  myRGB( 29, 38, 0 );
  myRGB( 33, 38, 19 );
  myRGB( 128, 255, 0 );
  myRGB( 191, 255, 128 );
  myRGB( 83, 166, 0 );
  myRGB( 124, 166, 83 );
  myRGB( 64, 128, 0 );
  myRGB( 96, 128, 64 );
  myRGB( 38, 76, 0 );
  myRGB( 57, 76, 38 );
  myRGB( 19, 38, 0 );
  myRGB( 29, 38, 19 );
  myRGB( 64, 255, 0 );
  myRGB( 159, 255, 128 );
  myRGB( 41, 166, 0 );
  myRGB( 104, 166, 83 );
  myRGB( 32, 128, 0 );
  myRGB( 80, 128, 64 );
  myRGB( 19, 76, 0 );
  myRGB( 48, 76, 38 );
  myRGB( 10, 38, 0 );
  myRGB( 24, 38, 19 );
  myRGB( 0, 255, 0 );
  myRGB( 128, 255, 128 );
  myRGB( 0, 166, 0 );
  myRGB( 83, 166, 83 );
  myRGB( 0, 128, 0 );
  myRGB( 64, 128, 64 );
  myRGB( 0, 76, 0 );
  myRGB( 38, 76, 38 );
  myRGB( 0, 38, 0 );
  myRGB( 19, 38, 19 );
  myRGB( 0, 255, 64 );
  myRGB( 128, 255, 159 );
  myRGB( 0, 166, 41 );
  myRGB( 83, 166, 104 );
  myRGB( 0, 128, 32 );
  myRGB( 64, 128, 80 );
  myRGB( 0, 76, 19 );
  myRGB( 38, 76, 48 );
  myRGB( 0, 38, 10 );
  myRGB( 19, 38, 24 );
  myRGB( 0, 255, 128 );
  myRGB( 128, 255, 191 );
  myRGB( 0, 166, 83 );
  myRGB( 83, 166, 124 );
  myRGB( 0, 128, 64 );
  myRGB( 64, 128, 96 );
  myRGB( 0, 76, 38 );
  myRGB( 38, 76, 57 );
  myRGB( 0, 38, 19 );
  myRGB( 19, 38, 29 );
  myRGB( 0, 255, 191 );
  myRGB( 128, 255, 223 );
  myRGB( 0, 166, 124 );
  myRGB( 83, 166, 145 );
  myRGB( 0, 128, 96 );
  myRGB( 64, 128, 112 );
  myRGB( 0, 76, 57 );
  myRGB( 38, 76, 67 );
  myRGB( 0, 38, 29 );
  myRGB( 19, 38, 33 );
  myRGB( 0, 255, 255 );
  myRGB( 128, 255, 255 );
  myRGB( 0, 166, 166 );
  myRGB( 83, 166, 166 );
  myRGB( 0, 128, 128 );
  myRGB( 64, 128, 128 );
  myRGB( 0, 76, 76 );
  myRGB( 38, 76, 76 );
  myRGB( 0, 38, 38 );
  myRGB( 19, 38, 38 );
  myRGB( 0, 191, 255 );
  myRGB( 128, 223, 255 );
  myRGB( 0, 124, 166 );
  myRGB( 83, 145, 166 );
  myRGB( 0, 96, 128 );
  myRGB( 64, 112, 128 );
  myRGB( 0, 57, 76 );
  myRGB( 38, 67, 76 );
  myRGB( 0, 29, 38 );
  myRGB( 19, 33, 38 );
  myRGB( 0, 128, 255 );
  myRGB( 128, 191, 255 );
  myRGB( 0, 83, 166 );
  myRGB( 83, 124, 166 );
  myRGB( 0, 64, 128 );
  myRGB( 64, 96, 128 );
  myRGB( 0, 38, 76 );
  myRGB( 38, 57, 76 );
  myRGB( 0, 19, 38 );
  myRGB( 19, 29, 38 );
  myRGB( 0, 64, 255 );
  myRGB( 128, 159, 255 );
  myRGB( 0, 41, 166 );
  myRGB( 83, 104, 166 );
  myRGB( 0, 32, 128 );
  myRGB( 64, 80, 128 );
  myRGB( 0, 19, 76 );
  myRGB( 38, 48, 76 );
  myRGB( 0, 10, 38 );
  myRGB( 19, 24, 38 );
  myRGB( 0, 0, 255 );
  myRGB( 128, 128, 255 );
  myRGB( 0, 0, 166 );
  myRGB( 83, 83, 166 );
  myRGB( 0, 0, 128 );
  myRGB( 64, 64, 128 );
  myRGB( 0, 0, 76 );
  myRGB( 38, 38, 76 );
  myRGB( 0, 0, 38 );
  myRGB( 19, 19, 38 );
  myRGB( 64, 0, 255 );
  myRGB( 159, 128, 255 );
  myRGB( 41, 0, 166 );
  myRGB( 104, 83, 166 );
  myRGB( 32, 0, 128 );
  myRGB( 80, 64, 128 );
  myRGB( 19, 0, 76 );
  myRGB( 48, 38, 76 );
  myRGB( 10, 0, 38 );
  myRGB( 24, 19, 38 );
  myRGB( 128, 0, 255 );
  myRGB( 191, 128, 255 );
  myRGB( 83, 0, 166 );
  myRGB( 124, 83, 166 );
  myRGB( 64, 0, 128 );
  myRGB( 96, 64, 128 );
  myRGB( 38, 0, 76 );
  myRGB( 57, 38, 76 );
  myRGB( 19, 0, 38 );
  myRGB( 29, 19, 38 );
  myRGB( 191, 0, 255 );
  myRGB( 223, 128, 255 );
  myRGB( 124, 0, 166 );
  myRGB( 145, 83, 166 );
  myRGB( 96, 0, 128 );
  myRGB( 112, 64, 128 );
  myRGB( 57, 0, 76 );
  myRGB( 67, 38, 76 );
  myRGB( 29, 0, 38 );
  myRGB( 33, 19, 38 );
  myRGB( 255, 0, 255 );
  myRGB( 255, 128, 255 );
  myRGB( 166, 0, 166 );
  myRGB( 166, 83, 166 );
  myRGB( 128, 0, 128 );
  myRGB( 128, 64, 128 );
  myRGB( 76, 0, 76 );
  myRGB( 76, 38, 76 );
  myRGB( 38, 0, 38 );
  myRGB( 38, 19, 38 );
  myRGB( 255, 0, 191 );
  myRGB( 255, 128, 223 );
  myRGB( 166, 0, 124 );
  myRGB( 166, 83, 145 );
  myRGB( 128, 0, 96 );
  myRGB( 128, 64, 112 );
  myRGB( 76, 0, 57 );
  myRGB( 76, 38, 67 );
  myRGB( 38, 0, 29 );
  myRGB( 38, 19, 33 );
  myRGB( 255, 0, 128 );
  myRGB( 255, 128, 191 );
  myRGB( 166, 0, 83 );
  myRGB( 166, 83, 124 );
  myRGB( 128, 0, 64 );
  myRGB( 128, 64, 96 );
  myRGB( 76, 0, 38 );
  myRGB( 76, 38, 57 );
  myRGB( 38, 0, 19 );
  myRGB( 38, 19, 29 );
  myRGB( 255, 0, 64 );
  myRGB( 255, 128, 159 );
  myRGB( 166, 0, 41 );
  myRGB( 166, 83, 104 );
  myRGB( 128, 0, 32 );
  myRGB( 128, 64, 80 );
  myRGB( 76, 0, 19 );
  myRGB( 76, 38, 48 );
  myRGB( 38, 0, 10 );
  myRGB( 38, 19, 24 );
  myRGB( 84, 84, 84 );
  myRGB( 118, 118, 118 );
  myRGB( 152, 152, 152 );
  myRGB( 187, 187, 187 );
  myRGB( 221, 221, 221 );
  myRGB( 255, 255, 255 );
End;

//*****************************************************************************

Function TAcadLineStyle.NumLineStyles: Integer;
Begin
  Result := 1;
  //Result:= High(FLineData);
End;

Function TAcadLineStyle.FindLineStyle( const LineStyle: String ): Integer;
//var i : integer ;
Begin
  Result := 1;
  Exit;
{$IFDEF FALSE}
  If LineStyle = '' Then
  Begin
    Result := 1;
    Exit;
  End;

  For i := 0 To NumLineStyles Do
  Begin
    If AnsiUppercase( LineStyle ) = FLineData[i] Then
    Begin
      Result := FEzStyle[i];
      exit;
    End;
  End;
  Result := 1;
{$ENDIF}
End;

Function TAcadLineStyle.ACADLineFromLine( index: integer ): String;
//var i : integer ;
Begin
  Result := 'CONTINUOUS';
{$IFDEF FALSE}
  If index = 0 Then
  Begin
    Result := FLineData[1];
    Exit;
  End;

  For i := 0 To NumLineStyles Do
  Begin
    If FEzStyle[i] = index Then
    Begin
      Result := FlineData[i];
      exit;
    End;
  End;
  Result := FLineData[1];
{$ENDIF}
End;

Function TAcadLineStyle.GetLineStyle( Index: integer ): String;
Begin
  Result := 'CONTINUOUS';
  //FLineData[index];
End;

{$IFDEF FALSE}

Constructor TAcadLineStyle.Create;
Var
  Styleno: integer;

  Procedure SetLine( const LineStyle: String; GISStyle: integer );
  Begin
    FLineData[Styleno] := LineStyle;
    FEzStyle[Styleno] := 1; //GISStyle ;
    inc( Styleno );
  End;

Begin
  Inherited Create;

  Styleno := 0;
  Setline( 'CONTINUOUS', 1 );
  Setline( 'BORDER', 34 );
  SetLine( 'BORDER2', 35 );
  SetLine( 'BORDERX2', 36 );
  SetLine( 'CENTER', 51 );
  SetLine( 'CENTER2', 56 );
  SetLine( 'CENTERX2', 63 );
  SetLine( 'DASHDOT', 13 );
  SetLine( 'DASHDOT2', 18 );
  SetLine( 'DASHDOTX2', 14 );
  SetLine( 'DASHED', 11 );
  SetLine( 'DASHED2', 10 );
  SetLine( 'DASHEDX2', 12 );
  SetLine( 'DIVIDE', 17 );
  SetLine( 'DIVIDE2', 16 );
  SetLine( 'DIVIDEX2', 15 );
  SetLine( 'DOT', 3 );
  SetLine( 'DOT2', 2 );
  SetLine( 'DOTX2', 9 );
  SetLine( 'HIDDEN', 5 );
  SetLine( 'HIDDEN2', 4 );
  SetLine( 'HIDDENX2', 6 );
  SetLine( 'PHANTOM', 52 );
  SetLine( 'PHANTOM2', 52 );
  SetLine( 'PHANTOMX2', 52 );
  SetLine( 'ACAD_ISO02W100', 13 );
  SetLine( 'ACAD_ISO03W100', 14 );
  SetLine( 'ACAD_ISO04W100', 13 );
  SetLine( 'ACAD_ISO05W100', 17 );
  SetLine( 'ACAD_ISO06W100', 15 );
  SetLine( 'ACAD_ISO07W100', 3 );
  SetLine( 'ACAD_ISO08W100', 56 );
  SetLine( 'ACAD_ISO09W100', 25 );
  SetLine( 'ACAD_ISO10W100', 14 );
  SetLine( 'ACAD_ISO11W100', 63 );
  SetLine( 'ACAD_ISO12W100', 15 );
  SetLine( 'ACAD_ISO13W100', 63 );
  SetLine( 'ACAD_ISO14W100', 17 );
  SetLine( 'ACAD_ISO15W100', 17 );
  SetLine( 'FENCELINE1', 37 );
  SetLine( 'FENCELINE2', 31 );
  SetLine( 'TRACKS', 21 );
  SetLine( 'BATTING', 38 );
  SetLine( 'HOT_WATER_SUPPLY', 33 );
  SetLine( 'GAS_LINE', 57 );
  SetLine( 'ZIGZAG', 57 );
End;
{$ENDIF}

End.

