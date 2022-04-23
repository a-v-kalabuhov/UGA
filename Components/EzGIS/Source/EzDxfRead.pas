Unit EzDxfRead;

{***********************************************************}
{     EzGIS/CAD Components                                  }
{   (c) 2002 EzSoft Engineering                             }
{         All Rights Reserved                               }
{***********************************************************}

Interface

// Added for GIS
{$I EZ_FLAG.PAS}

Uses
  Windows, SysUtils, Classes, EzDxfImport, EzDXFUtil, EzBaseGIS, Math;

Const
  EOL = #13#10;

const
  DXF_text_prompt = 3;

  ///////////////////////////////////////////////////////////////////////////////
  // DXF_Reader class definition
  ///////////////////////////////////////////////////////////////////////////////
Const
  MaxSizeOfBuf = 4096;
  //MaxSizeOfBuf = 10240;

Type
  tCharArray = Array[0..MaxSizeOfBuf - 1] Of char;

Type
  abstract_entity = Class;
  abstract_entity14 = Class;

  DXF_Reader = Class
  Private
    FGIS: TEzBaseGIS;
    DxfFile: TEzDxfFile; // belongs to
    BlocksToRead: Integer;
    // used when reading data from the file
    SizeOfBuf: integer;
    ec, fCode: integer;
    Line_num: longint;
    fLine: string;
    // useful bits to make parsing easier...
    marked_pos, File_pos: integer;
    backflag: boolean;
    //datmode    : boolean;
    barposition: integer;
    //MyDlg      : TMifImportDlg;
    Procedure go_back_to_last( code: integer; Const str: string );
    Procedure mark_position;
    Procedure goto_marked_position;
    //
    //procedure   go_back_to_start;
    Function NextGroupCode: integer;
    Function ValStr: string;
    Function ValDbl: Double;
    Function ValInt: integer;
    Function code_and_string( Var group: integer; Var s: String ): boolean;
    Function code_and_double( Var group: integer; Var d: Double ): boolean;
    Function read_2Dpoint( Var p1: Point3D ): boolean;
    Function skip_upto_section( Const name: String ): boolean;
    // lowest level read function
    Function read_entity_data( ent: abstract_entity ): boolean;
    Function read_entity_data14( ent: abstract_entity14 ): boolean;
    Function read_generic( Var layer: integer ): abstract_entity;
    // we can read most entities with this one
    Function general_purpose_read( obj_type: TClass; Var entity: DXF_Entity; Var layer: integer ): boolean;
    // inserts/polylines need a little more complexity
    Function read_insert( Var entity: DXF_Entity; Var layer: integer ): boolean;
    Function read_polyline( Var entity: DXF_Entity; Var layer: integer ): boolean;
    Function read_lwpolyline( Var entity: DXF_Entity; Var layer: integer ): boolean;
    // this calls the others above
    Function read_entity( Const s, endstr: String; Var entity: DXF_Entity; Var layer: integer ): boolean;
    function ConvertUTFLine(): string;
  Public
    DXF_FILE: String;
    Strings: TStringList;
    count_texts: integer;
    // Extents in (x,y) of the dataset
    min_extents: Point3D;
    max_extents: Point3D;
    // We will read the Entities in the layers into this list
    DXF_Layers: TList;
    colour_BYLAYER: boolean;
    Acad_version: integer;
    skipped: TStrings;
    ErrList: TStringlist;
    // Constructors and destructors
    Constructor Create( GIS: TEzBaseGIS; Const aName: string; ADxfFile: TEzDxfFile );
    Destructor Destroy; Override;
    // Header section
    Function move_to_header_section: boolean;
    Function read_header: boolean;
    Function get_min_extent: Point3D;
    Function get_max_extent: Point3D;
    // R14їл
    // Class section
    Function move_to_Class_section: boolean;
    Function read_Class: boolean;
    // Blocks section
    Function move_to_blocks_section: boolean;
    Function read_blocks: boolean;
    Function read_block: boolean;
    Function Blocklayer: DXF_Layer;
    // Tables section
    Function move_to_tables_section: boolean;
    Function read_tables: boolean;
    Function read_layer_information: boolean;
    Function read_vport_information: boolean;
    Function layer_num( Const layername: String ): integer;
    // Entities section
    Function move_to_entity_section: boolean;
    Function read_entities: boolean;
    // These are the main routines to use
    Function read_file: boolean;
    Function remove_empty_layers: boolean;
    Function release_control_of_layers: TList;
    Procedure set_skipped_list( s: TStrings );
    Function findlayer( Const name: String; Var dxflayer: dxf_layer ): boolean;
  End;

  ///////////////////////////////////////////////////////////////////////////////
  // This is a simple class used only during file reads, it should not be used
  // as a base for any objects.
  // It is to allow all entities to be read using the same basic structure
  // even though they all use different group codes
  // Add extra group codes if you need to recognize them
  ///////////////////////////////////////////////////////////////////////////////
  abstract_entity = Class
  Public
    p1, p2, p3, p4: Point3D;
    rad_hgt: Double;
    angle1, angle2: Double;
    fv1, fv2, fv3: Double;
    thickness: Double;
    colour: integer;
    flag_70, flag_71, flag_72, flag_73, flag_74: integer;
    attflag: integer;
    namestr, tagstr, promptstr, text_style: String;
    LineStyle: String;
    layer: String;
    elev: Double;
    OCS_Z: Point3D;
    Procedure clear;
  End;

  //polyline_arc_begin

  abstract_entity14 = Class( abstract_entity )
    vertices: integer;
    polypoints: ppointlist;
    floatvals: ppointlist;
  End;

  //polyline_arc_end

  ///////////////////////////////////////////////////////////////////////////////
  // DXF file read exceptions will be this type
  ///////////////////////////////////////////////////////////////////////////////
Type
  DXF_read_exception = Class( Exception )
    line_number: integer;
    Constructor create( Const err_msg: String; line: integer );
  End;

  // * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
  // implementation
  // * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
Implementation

// Added for GIS
Uses Forms, EzEntities, EzConsts, EzSystem;


// Basic DXF Group code
Const
  message_delay_ms = 1500;

  DXF_start = 0;
  DXF_text_def = 1;
  DXF_name = 2;
  DXF_othername2 = 4;
  DXF_entity_handle = 5;
  DXF_line_type = 6;
  DXF_text_style = 7;
  DXF_layer_name = 8;
  DXF_var_name = 9;
  DXF_primary_X = 10;
  DXF_primary_Y = 20;
  DXF_primary_Z = 30;
  DXF_other_X_1 = 11;
  DXF_other_Y_1 = 21;
  DXF_other_Z_1 = 31;
  DXF_other_X_2 = 12;
  DXF_other_Y_2 = 22;
  DXF_other_Z_2 = 32;
  DXF_other_X_3 = 13;
  DXF_other_Y_3 = 23;
  DXF_other_Z_3 = 33;
  DXF_elevation = 38;
  DXF_thickness = 39;
  DXF_floatval = 40;
  DXF_floatvals1 = 41;
  DXF_floatvals2 = 42;
  DXF_floatvals3 = 43;
  DXF_repeat = 49;
  DXF_angle1 = 50;
  DXF_angle2 = 51;
  DXF_angle3 = 52;
  DXF_angle4 = 53;
  DXF_angle5 = 54;
  DXF_angle6 = 55;
  DXF_angle7 = 56;
  DXF_angle8 = 57;
  DXF_angle9 = 58;
  DXF_visible = 60;
  DXF_colornum = 62;
  DXF_entities_flg = 66;
  DXF_ent_ident = 67;
  DXF_view_state = 69;
  DXF_70Flag = 70;
  DXF_71Flag = 71;
  DXF_72Flag = 72;
  DXF_73Flag = 73;
  DXF_74Flag = 74;
  DXF_extrusionx = 210;
  DXF_extrusiony = 220;
  DXF_extrusionz = 230;
  DXF_comment = 999;



///////////////////////////////////////////////////////////////////////////////
// abstract_entity implementation
// used when reading vertexes - just to make sure all flags are reset
// quicker than using create/destroy for each vertex.
///////////////////////////////////////////////////////////////////////////////

Procedure abstract_entity.clear;
Begin
  InitInstance( self );
End;


type
  TUnicodeConverter = class
  private
    fEncoded: string;
    fBuffer: string;
    fResult: string;
    fCode: string;
    fFound: Boolean;
    function CharIsCode(C: Char): Boolean;
    procedure PutChar(C: Char);
    procedure Stop();
  private
    const Prefix = '\U+';
  public
    constructor Create;
    destructor Destroy; override;
    //
    function ToAnsi(const EncodedStr: string): string;
  end; 

///////////////////////////////////////////////////////////////////////////////
// DXFReader implementation
///////////////////////////////////////////////////////////////////////////////

function DXF_Reader.ConvertUTFLine: string;
var
  Conv: TUnicodeConverter;
begin
  Result := '';
  Conv := TUnicodeConverter.Create;
  try
    Result := Conv.ToAnsi(fLine);
  finally
    Conv.Free;
  end;
end;

Constructor DXF_Reader.Create( GIS: TEzBaseGIS; Const aName: string; ADxfFile: TEzDxfFile );
Begin
  Inherited Create;

  FGIS := GIS;
  DxfFile := ADxfFile;
  Strings := TSTringList.Create;

  Strings.LoadFromFile(aName);

  SizeOfBuf := MaxSizeOfBuf;
  DXF_Layers := TList.Create;
  colour_BYLAYER := false;
  Line_num := 0;
  backflag := false;
  barposition := 0;
  BlocksToRead := Strings.Count;

  min_extents := origin3D;
  max_extents := origin3D;
  Acad_version := 12;
  dxf_file := extractfilename( aname );
  Errlist := TStringlist.create;

  //added for GIS
  AcadColorPal := TAcadColorPal.Create;
  AcadLineStyle := TAcadLineStyle.Create;
End;

Destructor DXF_Reader.Destroy;
Var
  lp1: integer;
Begin
  FreeAndNil(Strings);
  If ( DXF_Layers <> Nil ) Then
    For lp1 := 0 To DXF_Layers.count - 1 Do
      DXF_Layer( DXF_Layers[lp1] ).Free;
  DXF_Layers.Free;
  ErrList.free;

  //Added for GIS
  FreeAndNil( AcadColorPal );
  FreeAndNil( AcadLineStyle );

  //MyDlg.Release ;

  Inherited Destroy;
End;

{ --------------------------------------------------------------------------- }
{ Routines for fetching codes and values
{ --------------------------------------------------------------------------- }
(*procedure DXF_Reader.go_back_to_start;
begin
    Reset(IO_chan,1);
   //IO_Stream.Position := 0;
   num_in_buf := 0;
   ii         := 0;
end;*)

Procedure DXF_Reader.go_back_to_last( code: integer; Const str: string );
Begin
  FCode := code;
  FLine := str;
  backflag := true;
End;

Procedure DXF_Reader.mark_position;
Begin
  marked_pos := File_pos;
End;

Procedure DXF_Reader.goto_marked_position;
Begin
  File_pos := marked_pos;
End;

Function DXF_Reader.NextGroupCode: integer;

  Function GotLine: boolean;
  Begin
    if File_pos < Strings.Count then
    begin
      fLine := Strings[file_pos];
      Inc(file_pos);
      Result := True;
    end
    else
      Result := False;
    inc( Line_num );
  End;

Begin {NextGroupCode}
  If backflag Then
  Begin
    result := fCode;
    backflag := false;
  End
  Else
  Begin
    Repeat
      If Not GotLine Then
      Begin
        fCode := -2;
        Result := fCode;
        exit;
      End;
    Until fLine <> '';
    Val( fLine, fCode, ec );
    If ec <> 0 Then
      fCode := -2
    Else If Not GotLine Then
      fCode := -2;
    Result := fCode;
  End;
End {NextGroupCode};

Function DXF_Reader.ValStr: string;
Begin
  Result := fLine;
  if Acad_version >= 2000 then
  begin
    Result := ConvertUTFLine();
  end;
End;

Function DXF_Reader.ValDbl: Double;
Begin
  Val( TrimRight(fLine), Result, ec );

  If ec <> 0 Then
    errlist.Add( SDXFInvalidFloat + inttostr( line_num ) );
  //    raise DXF_read_exception.Create('Invalid Floating point conversion',line_num);
End;

Function DXF_Reader.ValInt: integer;
Begin
  Val( fLine, Result, ec );

  If ec <> 0 Then
    Errlist.add( SDXFInvalidInteger + inttostr( line_num ) );
  //    raise DXF_read_exception.Create('Invalid Integer conversion',line_num);
End;

Function DXF_Reader.code_and_string( Var group: integer; Var s: String ): boolean;
Begin
  result := true;
  group := NextGroupCode;
  If group >= 0 Then
    s := ValStr
  Else If Not ( ( group = 0 ) And ( valstr = '' ) ) Then
    Result := False;
  // useful in debugging
  //  if (group=0) then begin astr := IntToStr(group)+' '+s; alb.Items.Add(astr); end;
End;

Function DXF_Reader.code_and_double( Var group: integer; Var d: Double ): boolean;
Begin
  Result := true;
  Group := NextGroupCode;
  If Group >= 0 Then
    d := Valdbl
  Else
    Result := false;
End;

// This routine is just for the $EXT(max/min) and should be used with care....

Function DXF_Reader.read_2Dpoint( Var p1: Point3D ): boolean;
Var
  GroupCode: integer;
Begin
  Repeat Groupcode := NextGroupCode;
  Until ( Groupcode = DXF_primary_X ) Or ( Groupcode < 0 );
  If Groupcode < 0 Then
  Begin
    result := false;
    exit;
  End;
  p1.x := Valdbl;
  result := code_and_double( Groupcode, p1.y ); { y next              }
End;

Function DXF_Reader.skip_upto_section( Const name: String ): boolean;
Var
  Group: integer;
  s: String;
Begin
  result := false;
  Repeat
    If Not code_and_string( Group, s ) Then
      break;
    If ( Group = 0 ) Then
    Begin
      If ( s = 'SECTION' ) Then
      Begin
        If Not code_and_string( Group, s ) Then
          break;
        If ( Group = DXF_name ) Then
        Begin
          If ( s = name ) Then
            result := true
          Else
            exit;
        End
        Else If skipped <> Nil Then
          Skipped.Add( s );
      End
      Else If skipped <> Nil Then
        Skipped.Add( s );
    End;
  Until ( result );
End;

{ --------------------------------------------------------------------------- }
{ Header section
{ --------------------------------------------------------------------------- }

Function DXF_Reader.move_to_header_section: boolean;
Begin
  result := skip_upto_section( 'HEADER' );
End;

Function DXF_Reader.read_header: boolean;
Var
  Group: integer;
  s: String;
Begin
  result := false;
  Repeat
    If Not code_and_string( Group, s ) Then
      break;
    // Add for Acadr14
    If ( group = 9 ) And ( s = '$ACADVER' ) Then
    Begin
      If ( NextGroupCode = 1 ) Then
      Begin
        //add for Acad2004
        If ( Valstr = 'AC1018' ) Then
          Acad_version := 2004;
        //add for Acad2000
        If ( Valstr = 'AC1015' ) Then
          Acad_version := 2000;
        If ( Valstr = 'AC1014' ) Then
          Acad_version := 14;
        If ( Valstr = 'AC1012' ) Then
          Acad_version := 13;
        If ( Valstr = 'AC1009' ) Then
          Acad_version := 12;
      End;
    End;

    If ( group = 9 ) And ( s = '$EXTMAX' ) Then
    Begin
      If Not read_2Dpoint( max_extents ) Then
        break;
    End;
    If ( group = 9 ) And ( s = '$EXTMIN' ) Then
    Begin
      If Not read_2Dpoint( min_extents ) Then
        break;
    End;
    If ( group = 9 ) And ( s = '$CECOLOR' ) Then
    Begin
      If ( NextGroupCode = DXF_colornum ) And ( ValInt = 256 ) Then
        colour_BYLAYER := true;
    End;
    result := ( Group = 0 ) And ( s = 'ENDSEC' );
  Until result;
End;

{ --------------------------------------------------------------------------- }
{ Class section
{ --------------------------------------------------------------------------- }

Function DXF_Reader.move_to_Class_section: boolean;
Begin
  result := skip_upto_section( 'CLASSES' );
End;

Function DXF_Reader.read_Class: boolean;
Var
  Group: integer;
  s: String;
Begin
  // Add for Acadr14
  result := false;
  Repeat
    If Not code_and_string( Group, s ) Then
      break;
    result := ( Group = 0 ) And ( s = 'ENDSEC' );
  Until result;
End;

Function DXF_Reader.get_min_extent: Point3D;
Begin
  result := min_extents;
End;

Function DXF_Reader.get_max_extent: Point3D;
Begin
  result := max_extents;
End;
{ --------------------------------------------------------------------------- }
{ Blocks section
{ --------------------------------------------------------------------------- }

Function DXF_Reader.move_to_blocks_section: boolean;
Begin
  result := skip_upto_section( 'BLOCKS' );
End;

Function DXF_Reader.read_blocks: boolean;
Var
  Group: integer;
  s: String;
Begin
  result := false;
  Repeat
    If Not code_and_string( Group, s ) Then
      break;
    If ( Group = 0 ) And ( s = 'BLOCK' ) Then
    Begin
      If Not read_block Then
        break;
    End;
    result := ( Group = 0 ) And ( s = 'ENDSEC' );
  Until result;
End;

Function DXF_Reader.Blocklayer: DXF_Layer;
Var
  lp1: integer;
  layer: DXF_Layer;
Begin
  Result := Nil;
  For lp1 := 0 To DXF_Layers.count - 1 Do
  Begin
    layer := DXF_Layers[lp1];
    If layer.layer_name = 'Block_' Then
    Begin
      result := layer;
      exit;
    End;
  End;
End;

Function DXF_Reader.read_block: boolean;
Var
  Groupcode: integer;
  s: String;
  ent: abstract_entity;
  block: Block_;
  layer: integer;
  entity: DXF_Entity;
  MyLayer: DXF_Layer;

  // prohibit duplicate block name in block list,
  // check block name in block list
  Function checkblockexist( const blockname: String ): block_;
  Var
    bel: DXF_layer;
    bent: dxf_entity;
    lp0: integer;
  Begin
    result := Nil;
    bel := Blocklayer;
    If bel <> Nil Then
    Begin
      For lp0 := 0 To bel.entities.Count - 1 Do
      Begin
        bent := bel.entities[lp0];
        If block_( bent ).name = blockname Then
        Begin
          result := block_( bent );
          break;
        End;
      End;
    End;
  End;

Begin
  result := false;
  ent := read_generic( layer );
  layer := layer_num( 'Block_' ); // ALL BLOCKS GOING TO LAYER 'Block_' (makes things easier)
  If layer < 0 Then
    layer := DXF_Layers.Add( DXF_Layer.create( 'Block_', 7, 'CONTINUOUS' ) );
  If ent <> Nil Then
  Begin
    //if copy(ent.namestr,1,1)<>'$' then begin
    If Not ( ent.namestr[1] In ['*', '$'] ) Then
    Begin
      block := Block_.create( ent.namestr, ent.p1 );
      DXF_Layer( DXF_Layers[layer] ).add_entity_to_layer( block );
      Repeat
        If Not code_and_string( Groupcode, s ) Then
          break;
        If ( Groupcode = 0 ) Then
        Begin
          result := read_entity( s, 'ENDBLK', entity, layer );
          If entity <> Nil Then
          Begin
            If ( dxf_entity( entity ).colour = 0 ) And ( findlayer( ent.layer, Mylayer ) ) Then
              dxf_entity( entity ).setcolour_index( mylayer.Colour );
            //               if copy(block.name,1,1)<>'*' then // reference block check
            block.entities.Add( entity );
          End;
        End;
      Until result;
      ent.Free;
    End
    Else
      Repeat
        If Not code_and_string( Groupcode, s ) Then
          break;
        If ( Groupcode = 0 ) Then
          result := read_entity( s, 'ENDBLK', entity, layer );
      Until result;
  End;
End;

{ --------------------------------------------------------------------------- }
{ Tables (Layers - VPort) section
{ --------------------------------------------------------------------------- }

Function DXF_Reader.move_to_tables_section: boolean;
Begin
  result := skip_upto_section( 'TABLES' );
End;

Function DXF_Reader.read_tables: boolean;
Var
  Group: integer;
  s: String;
Begin
  result := false;
  Repeat
    If Not code_and_string( Group, s ) Then
      break;
    If ( Group = 0 ) And ( s = 'TABLE' ) Then
    Begin
      If Not code_and_string( Group, s ) Then
        break;
      If ( Group = DXF_name ) Then
      Begin
        If ( s = 'LAYER' ) Then
          read_layer_information
        Else If ( s = 'VPORT' ) Then
          read_vport_information
        Else If skipped <> Nil Then
          Skipped.Add( s );
      End;
    End;
    result := ( Group = 0 ) And ( s = 'ENDSEC' );
  Until result;
End;

Function DXF_Reader.read_layer_information: boolean;
Var
  Group, Lay_num: integer;
  s: String;
  NextLayer: Boolean;
Begin
  lay_num := -1;
  result := false;
  //  layerColor := bylayer ;

  Repeat
    If Not code_and_string( Group, s ) Then
      break;
    If ( Group = 0 ) Then
    Begin
      If ( s = 'LAYER' ) Then
      Begin
        Nextlayer := false;
        // Acad R14... lwpolyline...
        Repeat
          If Not code_and_string( Group, s ) Then
            break;
          If ( Group = DXF_colornum ) And ( lay_num <> -1 ) Then
            If ValInt > 255 Then
              DXF_Layer( DXF_Layers[lay_num] ).Colour := 7
            Else
              DXF_Layer( DXF_Layers[lay_num] ).Colour := Valint;
          // Acad Layer Linestyle
          If ( Group = DXF_Line_Type ) And ( lay_num <> -1 ) Then
          Begin
            DXF_Layer( DXF_Layers[lay_num] ).LineStyle := AcadLineStyle.FindLineStyle( S );
            DXF_Layer( DXF_Layers[lay_num] ).LineType := S;
          End;
          // use for making layer if layer isn't
          If ( Group = DXF_name ) Then
            lay_num := DXF_Layers.Add( DXF_Layer.create( s, 7, 'CONTINUOUS' ) );
          // NextLayer := (Group=0);
          NextLayer := ( Group = DXF_Line_Type ) Or ( Group = 0 );
        Until NextLayer;
      End
      Else If ( s = 'ENDTAB' ) Then
        result := true
      Else If skipped <> Nil Then
        Skipped.Add( s );
    End
    Else If ( Group = DXF_colornum ) And ( lay_num <> -1 ) Then
    Begin
      If ValInt > 255 Then
        DXF_Layer( DXF_Layers[lay_num] ).Colour := 7
      Else
        DXF_Layer( DXF_Layers[lay_num] ).Colour := Valint;
    End;
  Until result;
End;

// This no longer does anything !

Function DXF_Reader.read_vport_information: boolean;
Var
  Group: integer;
  s: String;
Begin
  result := false;
  Repeat
    If Not code_and_string( Group, s ) Then
      break;
    If ( Group = 0 ) Then
    Begin
      If ( s = 'VPORT' ) Then
      Begin
        If Not code_and_string( Group, s ) Then
          break;
        //Acad R14
        If Acad_version > 12 Then
          Repeat
            If Not code_and_string( Group, s ) Then
              break;
            result := ( Group = 2 );
          Until ( result );

        If ( Group = DXF_name ) Then
        Begin

          If ( s = '*ACTIVE' ) Then
            Repeat
              If Not code_and_string( Group, s ) Then
                break;
              { removed Aspectratio stuff since it never seems to make any difference
                and sometimes buggers everything up
                          if (Group=DXF_floatvals1) then Aspect := ValDbl;
              }
              result := ( Group = 0 ) And ( s = 'ENDTAB' );
            Until ( result )
          Else If skipped <> Nil Then
            Skipped.Add( s );
        End;
      End
      Else If skipped <> Nil Then
        Skipped.Add( s );
    End
  Until ( result );
End;

Function DXF_Reader.layer_num( Const layername: String ): integer;
Var
  lp1: integer;
Begin
  result := -1;
  For lp1 := 0 To DXF_Layers.count - 1 Do
  Begin
    If DXF_Layer( DXF_Layers[lp1] ).name = layername Then
    Begin
      result := lp1;
      exit;
    End;
  End;
End;
{ --------------------------------------------------------------------------- }
{ Entities section
{ --------------------------------------------------------------------------- }

Function DXF_Reader.move_to_entity_section: boolean;
Begin
  result := skip_upto_section( 'ENTITIES' );
End;

Function DXF_Reader.read_entities: boolean;
Var
  Groupcode, layer: integer;
  s: String;
  //DispText         : array[0..255] of char ;
  entity: DXF_Entity;
  canContinue: Boolean;
Begin
  result := false;
  Repeat
    Try
      If Not code_and_string( Groupcode, s ) Then break;
      If ( Groupcode = 0 ) Then
      Begin
        result := read_entity( s, 'ENDSEC', entity, layer );
        // put the entity in the layer...
        If entity <> Nil Then
          DXF_Layer( DXF_Layers[layer] ).add_entity_to_layer( entity );
        If ( getasynckeystate( vk_escape ) ) <> 0 Then
          result := true;
      End;
    Except
      On E: DXF_read_exception Do
      Begin
        //stopped_thinking;
        If Assigned( FGis ) Then
        If Assigned( FGis.OnError ) Then
        Begin
          CanContinue := true;
          FGis.OnError( FGis, E.Message, esImporting, CanContinue );
          If Not CanContinue Then
            Errlist.add( 'User aborted' );
        End;

        //          raise DXF_read_exception.Create('User aborted',-1);

        //Strpcopy(DispText, DXF_FILE+SDXFFileReadingNow);
        //thinking_bar(nil, DispText );
        If fGIS <> Nil Then
          FGIS.UpdateCaption( DXF_FILE + SDXFFileReadingNow );
      End;
      On E: Exception Do
      Begin
        If Assigned( FGis ) and Assigned( FGis.OnError ) Then
          FGis.OnError( FGIS, E.Message, esImporting, CanContinue );
      End;
    End;
  Until result;
End;
{ --------------------------------------------------------------------------- }
{ Entity reading code
{ --------------------------------------------------------------------------- }

Function DXF_Reader.read_entity_data( ent: abstract_entity ): boolean;
Var
  Groupcode: Integer;
Begin
  ent.OCS_Z := WCS_Z;
  Repeat
    Groupcode := NextGroupCode;
    Case Groupcode Of
      DXF_primary_X: ent.p1.x := Valdbl;
      DXF_primary_Y: ent.p1.y := Valdbl;
      DXF_primary_Z: ent.p1.z := Valdbl;
      DXF_other_X_1: ent.p2.x := Valdbl;
      DXF_other_Y_1: ent.p2.y := Valdbl;
      DXF_other_Z_1: ent.p2.z := Valdbl;
      DXF_other_X_2: ent.p3.x := Valdbl;
      DXF_other_Y_2: ent.p3.y := Valdbl;
      DXF_other_Z_2: ent.p3.z := Valdbl;
      DXF_other_X_3: ent.p4.x := Valdbl;
      DXF_other_Y_3: ent.p4.y := Valdbl;
      DXF_other_Z_3: ent.p4.z := Valdbl;
      DXF_floatval: ent.rad_hgt := Valdbl;
      DXF_floatvals1: ent.fv1 := Valdbl;
      DXF_floatvals2: ent.fv2 := Valdbl;
      DXF_floatvals3: ent.fv3 := Valdbl;
      DXF_angle1: ent.angle1 := Valdbl;
      DXF_angle2: ent.angle2 := Valdbl;
      DXF_thickness: ent.thickness := Valdbl;
      DXF_elevation: ent.elev := Valdbl;
      DXF_70Flag: ent.flag_70 := ValInt;
      DXF_71Flag: ent.flag_71 := ValInt;
      DXF_72Flag: ent.flag_72 := ValInt;
      DXF_73Flag: ent.flag_73 := ValInt;
      DXF_74Flag: ent.flag_74 := ValInt;
      DXF_colornum: ent.colour := ValInt;
      DXF_entities_flg: ent.attflag := ValInt;
      DXF_layer_name: ent.layer := ValStr;
      DXF_name: ent.namestr := ValStr;
      DXF_text_def: ent.tagstr := ValStr;
      DXF_text_prompt: ent.promptstr := ValStr;
      DXF_text_style: ent.text_style := Valstr;
      DXF_line_type: ent.LineStyle := Valstr;
      DXF_extrusionx: ent.OCS_Z.x := Valdbl;
      DXF_extrusiony: ent.OCS_Z.y := Valdbl;
      DXF_extrusionz: ent.OCS_Z.z := Valdbl;
    End;
  Until ( Groupcode <= 0 ); // end or fault;

  If Groupcode < 0 Then
  Begin
    result := false;
    exit;
  End;
  // we need to put the code=0, and valstr back, so the next entity starts
  // with the zero when neccessary
  go_back_to_last( Groupcode, fline );
  ent.OCS_Z := normalize( ent.OCS_Z ); // for safety
  result := true;
End;

//polyline_arc_begin

Function DXF_Reader.read_entity_data14( ent: abstract_entity14 ): boolean;
Var
  Groupcode: integer;
  I, vertices: integer;
  tempvert: Array[0..max_vertices_per_polyline - 1] Of Point3D;
  tempfv: Array[0..max_vertices_per_polyline - 1] Of Point3D;
  ReadCheck: boolean;

Label
  vertex_overflow;

Begin
  ent.OCS_Z := WCS_Z;
  ReadCheck := false;
  Vertices := 0;

  //initialize bulge value
  For i := 0 To max_vertices_per_polyline - 1 Do
  Begin
    tempfv[i].X := 0;
    tempfv[i].Y := 0;
    tempfv[i].Z := 0;
  End;

  Repeat
    Groupcode := NextGroupCode;
    Case Groupcode Of
      DXF_primary_X: ent.p1.x := Valdbl;
      DXF_primary_Y:
        Begin
          ent.p1.y := Valdbl;
          ReadCheck := true;
        End;
      DXF_primary_Z: ent.p1.z := Valdbl;
      DXF_other_X_1: ent.p2.x := Valdbl;
      DXF_other_Y_1: ent.p2.y := Valdbl;
      DXF_other_Z_1: ent.p2.z := Valdbl;
      DXF_other_X_2: ent.p3.x := Valdbl;
      DXF_other_Y_2: ent.p3.y := Valdbl;
      DXF_other_Z_2: ent.p3.z := Valdbl;
      DXF_other_X_3: ent.p4.x := Valdbl;
      DXF_other_Y_3: ent.p4.y := Valdbl;
      DXF_other_Z_3: ent.p4.z := Valdbl;
      DXF_floatval: ent.rad_hgt := Valdbl;
      DXF_floatvals1: ent.fv1 := Valdbl;
      DXF_floatvals2:
        Begin //get polyline's arc bulge value
          ent.fv2 := Valdbl;
          tempfv[vertices - 1].y := ent.fv2;
        End;
      DXF_floatvals3: ent.fv3 := Valdbl;
      DXF_angle1: ent.angle1 := Valdbl;
      DXF_angle2: ent.angle2 := Valdbl;
      DXF_thickness: ent.thickness := Valdbl;
      DXF_elevation: ent.elev := Valdbl;
      DXF_70Flag: ent.flag_70 := ValInt;
      DXF_71Flag: ent.flag_71 := ValInt;
      DXF_72Flag: ent.flag_72 := ValInt;
      DXF_73Flag: ent.flag_73 := ValInt;
      DXF_74Flag: ent.flag_74 := ValInt;
      DXF_colornum: ent.colour := ValInt;
      DXF_entities_flg: ent.attflag := ValInt;
      DXF_layer_name: ent.layer := ValStr;
      DXF_name: ent.namestr := ValStr;
      DXF_text_def: ent.tagstr := ValStr;
      DXF_text_prompt: ent.promptstr := ValStr;
      DXF_text_style: ent.text_style := valstr;
      DXF_extrusionx: ent.OCS_Z.x := Valdbl;
      DXF_extrusiony: ent.OCS_Z.y := Valdbl;
      DXF_extrusionz: ent.OCS_Z.z := Valdbl;
    End;

    If ReadCheck Then
    Begin
      //99.11.18
      ent.p1.z := ent.elev; //»х·ОИч ГЯ°ЎЗТ єОєР.... lwpolylineАЗ °нµµ°Є
      tempvert[vertices] := ent.p1;
      inc( vertices );
      ReadCheck := false;
    End;
  Until ( ( Groupcode <= 0 ) Or ( vertices >= max_vertices_per_polyline ) ); // end or fault;
  If Groupcode < 0 Then
  Begin
    result := false;
    exit;
  End;
  ent.polypoints := @tempvert[0];
  ent.floatvals := @tempfv[0];
  ent.vertices := vertices;
  go_back_to_last( Groupcode, fline );
  ent.OCS_Z := normalize( ent.OCS_Z ); // for safety
  result := true;
  If vertices >= max_vertices_per_polyline Then
    result := false;
End;

//polyline_arc_end

Function DXF_Reader.read_generic( Var layer: integer ): abstract_entity;
Var
  ent: abstract_entity;
Begin
  result := Nil;
  ent := abstract_entity.create; // set everything to zero EVERY time

  If read_entity_data( ent ) Then
  Begin
    layer := layer_num( ent.layer );
    If layer < 0 Then
      layer := DXF_Layers.Add( DXF_Layer.create( ent.layer, 7, ent.LineStyle ) );
    result := ent;
  End
  Else
    ent.free;
End;

{ These ones are straightforward, so we'll use a crafty TClass parameter }

Function DXF_Reader.general_purpose_read( obj_type: TClass; Var entity: DXF_Entity; Var layer: integer ): boolean;
Var
  ent: abstract_entity;
  LS: integer;
Begin
  result := false;
  entity := Nil;
  ent := read_generic( layer );
  // to Match correctly for block's Color
  If ent <> Nil Then
  Begin
    If ( ent.colour = 0 ) And ( layer <> -1 ) Then
      ent.Colour := Dxf_layer( dxf_layers[layer] ).colour;
    If ent.LineStyle = '' Then
      LS := DXF_Layer( DXF_Layers[Layer] ).LineStyle // bylayer
    Else
      LS := AcadLineStyle.FindLineStyle( ent.linestyle );
    With ent Do
    Begin
      If obj_type = Point_ Then
        entity := Point_.create( OCS_Z, p1, colour )
      Else If obj_type = Text_ Then
      Begin
        count_texts := Count_texts + 1;
        entity := Text_.create( OCS_Z, p1, p2, angle1, tagstr, text_style, rad_hgt, colour, flag_72 );
      End
      Else If obj_type = Line_ Then
        entity := Line_.create( p1, p2, colour, LS )
      Else If obj_type = Circle_ Then
        entity := Circle_.create( OCS_Z, p1, rad_hgt, colour, LS )
      Else If obj_type = Arc_ Then
        entity := Arc_.create( OCS_Z, p1, rad_hgt, angle1, angle2, colour, LS )
          // face3ds and solids can have 3 or 4 points, if 4=3, then 3 used
      Else If obj_type = Face3D_ Then
      Begin
        If p1_eq_p2_3d( p3, p4 ) Then
          entity := Face3D_.create( 3, @p1, colour, true, LS )
        Else
          entity := Face3D_.create( 4, @p1, colour, true, LS )
      End
      Else If obj_type = Solid_ Then
      Begin
        If p1_eq_p2_3d( p3, p4 ) Then
          entity := Solid_.create( OCS_Z, 3, @p1, colour, thickness, LS )
        Else
          entity := Solid_.create( OCS_Z, 4, @p1, colour, thickness, LS )
      End
      Else If obj_type = Attdef_ Then
        entity := Attdef_.create( OCS_Z, p1, p2, angle1,
          namestr, text_style, tagstr, promptstr, flag_70, flag_72, rad_hgt, colour )
      Else If obj_type = Attrib_ Then
        entity := Attrib_.create( OCS_Z, p1, p2, angle1,
          namestr, text_style, tagstr, flag_70, flag_72, rad_hgt, colour );
    End;
    ent.Free;
    result := true;
  End;
End;

{ INSERTs may have ATTRIBs + BLOCKs which makes it a little more complicated }

Function DXF_Reader.read_insert( Var entity: DXF_Entity; Var layer: integer ): boolean;
Var
  ent, ent2: abstract_entity;
  num: integer;
  atts: Array[0..255] Of Attrib_;

  Function checkblockName( Const blockname: String; bel: DXF_Layer ): boolean;
  Var
    bent: dxf_entity;
    lp0: integer;
  Begin
    result := false;
    If bel <> Nil Then
    Begin
      For lp0 := 0 To bel.entities.Count - 1 Do
      Begin
        bent := bel.entities[lp0];
        If AnsiUpperCase(block_( bent ).name) = AnsiUpperCase(blockname) Then
        Begin
          result := true;
          break;
        End;
      End;
    End;
  End;

Begin
  result := true;
  entity := Nil;
  num := 0;
  ent := read_generic( layer );
  If ent <> Nil Then
  Begin
    If ent.attflag = 1 Then
    Begin
      Repeat
        result := ( Nextgroupcode = 0 );
        If result And ( ValStr = 'ATTRIB' ) Then
        Begin
          ent2 := read_generic( layer );
          If ent2 <> Nil Then
            With ent2 Do
            Begin
              atts[num] := Attrib_.create( OCS_Z, p1, p2, Angle1,
                namestr, text_style, tagstr, flag_70, flag_72,
                rad_hgt, colour );
              ent2.Free;
              inc( num );
            End
          Else
            result := false;
        End;
      Until ( Not result ) Or ( ValStr = 'SEQEND' );
      If result Then
        Nextgroupcode; // remove the SEQEND put back
    End;

    // if user inserted block which is non exists or reference block,
    //    if ((Checkblockname(ent.namestr, block_list)=false)or(copy(ent.namestr,1,1)='*')) then begin
    If ( ( Checkblockname( ent.namestr, Blocklayer ) = false ) ) Then
    Begin

      Errlist.add( SDXFUndefBlock + inttostr( line_num ) + ' BlockName: ' + ent.namestr );

      Errlist.add( SDXFWrongBlockInfo );
      Errlist.add( '' );
    End
    Else
    Begin

      // if block exists in block list, define block.
      With ent Do
      Begin
        If fv1 = 0 Then
          fv1 := 1;
        If fv2 = 0 Then
          fv2 := 1;
        If fv3 = 0 Then
          fv3 := 1;
        entity := Insert_.create( OCS_Z, p1, aPoint3D( fv1, fv2, fv3 ), angle1, colour, num, @atts[0], namestr );
        Try
          Insert_( entity ).update_block_links( Blocklayer );
        Except
          dxf_entity( entity ).Free;
          entity := Nil;
          //        raise DXF_read_exception.Create('Cannot reference an undefined BLOCK'+EOL+EOL+
          //        '(File may not have been saved with BLOCKs)'+EOL,line_num);
        End;
      End;
    End;
    ent.Free;

  End
  Else
    result := false;
End;

//polyline_arc_begin

Const
  IC_ZRO = 1.0E-10;

Function ic_atan2( yy, xx: double ): double;
Var
  dexp, inf: integer;
  absxx, absyy, dmin, fd1, fd2: double;
Begin
  dexp := 300;
  dmin := 1.0E-300;
  inf := 0;

  absxx := abs( xx );
  absyy := abs( yy );

  If ( absxx < dmin ) Then
  Begin
    If ( absyy < dmin ) Then
    Begin
      result := 0; //* Should give error, too */
      exit;
    End;
    inf := 1;
  End
  Else If ( absyy >= dmin ) Then
  Begin
    fd1 := log10( absyy );
    fd2 := log10( absxx );
    If ( fd1 - fd2 > dexp ) Then
      inf := 1;
  End;
  If ( inf = 1 ) Then
  Begin
    If yy > 0.0 Then
      result := PI / 2.0
    Else
      result := -PI / 2.0;
    exit;
  End;
  fd1 := arctan( yy / xx );
  If ( xx < 0.0 ) Then
  Begin
    If yy < 0.0 Then
      fd1 := fd1 + -PI
    Else
      fd1 := fd1 + PI;
  End;
  result := fd1;
End;

Function bulge2arc( p0, p1: point3d; bulge: double; Var cc: point3d; Var rr, sa, ea: double ): integer;
Var
  fi1: integer;
  dx, dy, sep, ss: double;
  ara: Array[0..1] Of double;
Begin
  {/*
  **  Given an arc defined by two pts and bulge, determines the CCW arc's
  **  center, radius, starting angle and ending angle.
  **
  **  Returns:
  **       0 : OK
  **      -1 : Points coincident
  **       1 : It's a line
  **    -2 : Non planar arc
  */}
  If ( bulge = 0.0 ) Then
  Begin
    result := 1; //* Line */
    exit;
  End;

  //* Points must be nearly planar */
  If ( abs( p0.z ) <= IC_ZRO ) Then
  Begin
    If ( abs( p1.z ) > IC_ZRO ) Then
    Begin
      result := -2;
      exit;
    End;
  End
  Else If ( abs( ( p0.z / p1.z ) - 1.0 ) > IC_ZRO ) Then
  Begin
    result := -2;
    exit;
  End;

  dx := p1.x - p0.x;
  dy := p1.y - p0.y;

  sep := sqrt( dx * dx + dy * dy );

  If ( sep = 0.0 ) Then
  Begin
    result := -1; //* Coincident */
    exit;
  End;

  rr := abs( sep * ( bulge + 1.0 / bulge ) / 4.0 ); //* Radius */
  ss := ( rr ) * ( rr ) - sep * sep / 4.0;
  If ( ss < 0.0 ) Then
    ss := 0.0; // Should never
  ss := sqrt( ss );

  //* Find center: */
  ara[0] := ss / sep;
  If ( ( bulge < -1.0 ) Or ( ( bulge > 0.0 ) And ( bulge < 1.0 ) ) ) Then //* Step left of midpt */
  Begin
    cc.x := ( p0.x + p1.x ) / 2.0 - ara[0] * dy;
    cc.y := ( p0.y + p1.y ) / 2.0 + ara[0] * dx;
  End
  Else
  Begin //* Step left of midpt */
    cc.x := ( p0.x + p1.x ) / 2.0 + ara[0] * dy;
    cc.y := ( p0.y + p1.y ) / 2.0 - ara[0] * dx;
  End;

  cc.z := p0.z + p1.z;
  cc.z := cc.z * 0.5;

  //* Find starting and ending angles: */
  dx := p0.x - cc.x;
  dy := p0.y - cc.y;
  ara[0] := ic_atan2( dy, dx ); //* Avoid METAWARE bug */
  dx := p1.x - cc.x;
  dy := p1.y - cc.y;
  ara[1] := ic_atan2( dy, dx );

  //* If bulge>=0.0, take starting angle from p0: */
  fi1 := integer( bulge < 0.0 );

  sa := ara[fi1];
  If fi1 = 0 Then
    fi1 := 1
  Else
    fi1 := 0;
  ea := ara[fi1];

  //* Make both 0.0<=ang<EzEntities.TwoPI : */
  If bulge > 0 Then
  Begin
    If ( sa < 0.0 ) Then
      sa := sa + EzEntities.TwoPI;
    If ( ea < 0.0 ) Then
      ea := ea + EzEntities.TwoPI;
  End;
  result := 0;
End;

// R14їл

Function DXF_Reader.read_lwpolyline( Var entity: DXF_Entity; Var layer: integer ): boolean;
Var
  ent1: abstract_entity14;
  closed_poly: boolean;
  i, M, N, mn: integer;
  LS: integer;

  //added for lwpolyarc
  CC: Point3D;
  rr, sa, ea: double; //radius, startangle, endangle
  tempvert2: Array[0..max_vertices_per_polyline - 1] Of Point3D;

Label
  vertex_overflow;

  Function CheckBulge: boolean;
  Var
    i: integer;
  Begin
    result := false;
    For i := 0 To ent1.vertices Do
      If ent1.floatvals[i].y <> 0 Then
      Begin //check vertex 42 value. 41=x, 42=y, 43=z
        result := true;
        break;
      End;
  End;

  Procedure arc( xcenter, ycenter, Zvalue, radius, starttheta, endtheta, bulge: double;
    Var VertNo: integer );
  Var
    i, j: integer;
    se, ea: double;
    x, y: Array[0..65] Of double;
    dtheta, dcos, dsin, num: double;
  Begin
    num := 32;
    If ( starttheta < endtheta ) Then
    Begin
      se := endtheta;
      ea := starttheta;
      dtheta := ( ea - Se ) / num;
      dcos := cos( dtheta );
      dsin := sin( dtheta );
      x[0] := radius * cos( Se );
      y[0] := radius * sin( Se );
      For i := 0 To trunc( num ) - 1 Do
      Begin
        x[i + 1] := x[i] * dcos - y[i] * dsin;
        y[i + 1] := x[i] * dsin + y[i] * dCos;
      End;
      If bulge > 0 Then
      Begin
        j := 0;
        For i := trunc( num ) - 1 Downto 0 Do
        Begin
          TempVert2[VertNo + j].x := xcenter + x[i];
          TempVert2[VertNo + j].y := ycenter + y[i];
          TempVert2[VertNo + j].z := Zvalue;
          inc( j );
        End;
      End
      Else
      Begin
        j := 0;
        For i := 0 To trunc( num ) - 1 Do
        Begin
          TempVert2[VertNo + j].x := xcenter + x[i];
          TempVert2[VertNo + j].y := ycenter + y[i];
          TempVert2[VertNo + j].z := Zvalue;
          inc( j );
        End;
      End;
    End
    Else
    Begin
      se := starttheta;
      ea := endtheta;
      ea := ea + pi;
      Se := Se - pi;
      dtheta := ( ea - Se ) / num;

      dcos := cos( dtheta );
      dsin := sin( dtheta );

      x[0] := radius * cos( Se );
      y[0] := radius * sin( Se );
      For i := 0 To trunc( num ) - 1 Do
      Begin
        x[i + 1] := x[i] * dcos - y[i] * dsin;
        y[i + 1] := x[i] * dsin + y[i] * dCos;
      End;
      If bulge < 0 Then
      Begin
        j := 0;
        For i := trunc( num ) - 1 Downto 0 Do
        Begin
          TempVert2[VertNo + j].x := xcenter - x[i];
          TempVert2[VertNo + j].y := ycenter - y[i];
          TempVert2[VertNo + j].z := Zvalue;
          inc( j );
        End;
      End
      Else
      Begin
        j := 0;
        For i := 0 To trunc( num ) - 1 Do
        Begin
          TempVert2[VertNo + j].x := xcenter - x[i];
          TempVert2[VertNo + j].y := ycenter - y[i];
          TempVert2[VertNo + j].z := Zvalue;
          inc( j );
        End;
      End;
    End;
    vertno := vertno + trunc( num );
  End;

Begin
  result := false;
  closed_poly := false;
  entity := Nil;

  ent1 := abstract_entity14.create;
  If Not read_entity_data14( ent1 ) Then
    Goto Vertex_overflow;
  layer := layer_num( ent1.layer );

  If ( ent1.colour = 0 ) And ( layer <> -1 ) Then
    ent1.Colour := Dxf_layer( dxf_layers[layer] ).colour;
  If ( layer = -1 ) Then
    layer := DXF_Layers.Add( DXF_Layer.create( ent1.layer, ent1.colour, ent1.LineStyle ) );

  // THIS IS A NORMAL LWPOLYLINE
  // this should set result to true, because 0 SEQEND is next
  LS := 1;
  If ( ent1.flag_70 And ( 64 + 16 ) ) = 0 Then
  Begin
    result := true;
    If ( ( ent1.flag_70 ) And 1 ) = 1 Then
      closed_poly := true;
    If ent1.LineStyle = '' Then
      LS := DXF_Layer( DXF_Layers[Layer] ).LineStyle // bylayer
    Else
      LS := AcadLineStyle.FindLineStyle( ent1.linestyle );

    entity := Nil;
    If Checkbulge = false Then
      entity := Polyline_.create( ent1.OCS_Z, ent1.vertices, ent1.polypoints, ent1.colour, closed_poly, LS )
    Else
    Begin
      m := 0; //ЗцАз БЎБВЗҐ°Є є№»зА§ДЎ...
      For i := 0 To ent1.vertices - 1 Do
        If ent1.floatvals^[i].Y <> 0 Then
        Begin
          //µОБЎ°ъ ѕЖЕ©ё¦ »эјє...
          If ( i < ( ent1.vertices - 1 ) ) Then
          Begin
            If bulge2arc( ent1.polypoints^[i], ent1.polypoints^[i + 1], ent1.floatvals^[i].Y, cc, rr, sa, ea ) = 0 Then
            Begin
              tempvert2[m] := ent1.polypoints^[i];
              inc( m );
              Arc( cc.x, cc.y, ent1.polypoints^[i].z, rr, sa, ea, ent1.floatvals^[i].Y, m );
            End;
          End
          Else
          Begin
            If closed_poly Then
            Begin
              If bulge2arc( ent1.polypoints^[i], ent1.polypoints^[0], ent1.floatvals^[i].Y, cc, rr, sa, ea ) = 0 Then
              Begin
                tempvert2[m] := ent1.polypoints^[i];
                inc( m );
                Arc( cc.x, cc.y, ent1.polypoints^[i].z, rr, sa, ea, ent1.floatvals^[i].Y, m );
              End;
            End
            Else
            Begin
              tempvert2[m] := ent1.polypoints^[i];
              inc( m );
            End;
          End
        End
        Else
        Begin
          tempvert2[m] := ent1.polypoints^[i];
          inc( m );
        End;
      If m > 0 Then
      Begin
        entity := Polyline_.create( ent1.OCS_Z, m, @tempvert2[0], ent1.colour, closed_poly, LS );
      End;
    End;
  End
    //////////////////////////////////////////
    //////////////////////////////////////////
  Else If ( ent1.flag_70 And 16 ) = 16 Then
  Begin
    // THIS IS A POLYGON MESH - a grid of vertices joined along M & N
    M := ent1.flag_71;
    N := ent1.flag_72;
    mn := 0;
    result := true;
    If mn <> M * N Then
    Begin
      ent1.Free;
      exit;
    End; // error
    entity := Polygon_mesh_.create( ent1.vertices, M, N, ent1.polypoints, ent1.flag_70, ent1.colour, LS );
  End;
  ent1.Free;
  exit; // next bit only when vertices overflow

  vertex_overflow:
  ent1.Free;
  Errlist.Add( Format( SDXFLWPolylineBad, [max_vertices_per_polyline, line_num] ) );
End;

//polyline_arc_end

Function Dxf_Reader.Findlayer( Const name: String; Var dxflayer: dxf_layer ): boolean;
Var
  i: integer;
Begin
  Result := false;
  dxfLayer := Nil;
  For i := 0 To dxf_layers.Count - 1 Do
    If dxf_layer( dxf_layers[i] ).layer_name = name Then
    Begin
      result := true;
      DXFLayer := dxf_layers[i];
      break;
    End;
End;

// POLYLINEs have variable number of points...
// Modified to accept polyface mesh variety of polyline ...
//   I've ignored the invisible flag for edges
// Modified to accept polygon MxN grid mesh ...
// It's a bit messy - you could simplify it a bit - but hey - what do you
// expect from free code.

//polyline_arc_begin

Function DXF_Reader.read_polyline( Var entity: DXF_Entity; Var layer: integer ): boolean;
Var
  ent1, ent2: abstract_entity;
  vertices: integer;
  faces: integer;
  tempvert: Array[0..max_vertices_per_polyline - 1] Of Point3D;
  LS: Integer;

  //polyline arc variable begin
  tempfv: Array[0..max_vertices_per_polyline - 1] Of double;
  tempvert2: Array[0..max_vertices_per_polyline - 1] Of Point3D;
  CC: Point3D;
  rr, sa, ea: double; //radius, startangle, endangle
  //end

  tempface: Array[0..4095] Of polyface;
  closed_poly: boolean;
  M, N, mn, i: integer;

Label
  vertex_overflow;

  Function CheckBulge: boolean;
  Var
    i: integer;
  Begin
    result := false;
    For i := 0 To vertices Do
      If tempfv[i] <> 0 Then
      Begin
        result := true;
        break;
      End;
  End;

  Procedure arc( xcenter, ycenter, Zvalue, radius, starttheta, endtheta, bulge: double; Var VertNo: integer );
  Var
    i, j: integer;
    se, ea: double;
    x, y: Array[0..65] Of double;
    dtheta, dcos, dsin, num: double;
  Begin
    num := 32;
    If ( starttheta < endtheta ) Then
    Begin
      se := endtheta;
      ea := starttheta;
      dtheta := ( ea - Se ) / num;
      dcos := cos( dtheta );
      dsin := sin( dtheta );
      x[0] := radius * cos( Se );
      y[0] := radius * sin( Se );
      For i := 0 To trunc( num ) - 1 Do
      Begin
        x[i + 1] := x[i] * dcos - y[i] * dsin;
        y[i + 1] := x[i] * dsin + y[i] * dCos;
      End;
      If bulge > 0 Then
      Begin
        j := 0;
        For i := trunc( num ) - 1 Downto 0 Do
        Begin
          TempVert2[VertNo + j].x := xcenter + x[i];
          TempVert2[VertNo + j].y := ycenter + y[i];
          TempVert2[VertNo + j].z := Zvalue;
          inc( j );
        End;
      End
      Else
      Begin
        j := 0;
        For i := 0 To trunc( num ) - 1 Do
        Begin
          TempVert2[VertNo + j].x := xcenter + x[i];
          TempVert2[VertNo + j].y := ycenter + y[i];
          TempVert2[VertNo + j].z := Zvalue;
          inc( j );
        End;
      End;
    End
    Else
    Begin
      se := starttheta;
      ea := endtheta;
      ea := ea + pi;
      Se := Se - pi;
      dtheta := ( ea - Se ) / num;
      dcos := cos( dtheta );
      dsin := sin( dtheta );
      x[0] := radius * cos( Se );
      y[0] := radius * sin( Se );
      For i := 0 To trunc( num ) - 1 Do
      Begin
        x[i + 1] := x[i] * dcos - y[i] * dsin;
        y[i + 1] := x[i] * dsin + y[i] * dCos;
      End;
      If bulge < 0 Then
      Begin
        j := 0;
        For i := trunc( num ) - 1 Downto 0 Do
        Begin
          TempVert2[VertNo + j].x := xcenter - x[i];
          TempVert2[VertNo + j].y := ycenter - y[i];
          TempVert2[VertNo + j].z := Zvalue;
          inc( j );
        End;
      End
      Else
      Begin
        j := 0;
        For i := 0 To trunc( num ) - 1 Do
        Begin
          TempVert2[VertNo + j].x := xcenter - x[i];
          TempVert2[VertNo + j].y := ycenter - y[i];
          TempVert2[VertNo + j].z := Zvalue;
          inc( j );
        End;
      End;
    End;
    vertno := vertno + trunc( num );
  End;

Begin
  result := false;
  closed_poly := false;
  entity := Nil;
  ent1 := abstract_entity.create;
  //  ent1.colour := bylayer ;

  // read initial polyline data
  If Not read_entity_data( ent1 ) Then
  Begin
    ent1.Free;
    exit;
  End;
  layer := layer_num( ent1.layer );

  If ( ent1.colour = 0 ) And ( layer <> -1 ) Then
    ent1.Colour := Dxf_layer( dxf_layers[layer] ).colour;
  If ( layer = -1 ) Then
    layer := DXF_Layers.Add( DXF_Layer.create( ent1.layer, ent1.colour, ent1.LineStyle ) );

  vertices := 0;
  faces := 0;
  ent2 := abstract_entity.create;
  //  ent2.colour := bylayer ;

  //////////////////////////////////////////
  //////////////////////////////////////////
  If ( ent1.flag_70 And ( 64 + 16 ) ) = 0 Then
  Begin
    // THIS IS A NORMAL POLYLINE
    Repeat
      If ( NextGroupCode = 0 ) And ( ValStr = 'VERTEX' ) Then
      Begin
        ent2.clear;
        If read_entity_data( ent2 ) Then
        Begin
          tempvert[vertices] := ent2.p1;
          tempfv[vertices] := ent2.fv2;
          inc( vertices );
          If vertices >= max_vertices_per_polyline Then
            Goto vertex_overflow;
        End
        Else
        Begin
          // Errlist.Add('Polyline contained odd vertex'+inttostr(line_num));
          ent1.Free;
          ent2.Free;
          exit;
        End; // error
      End;
    Until fLine = 'SEQEND';
    // this should set result to true, because 0 SEQEND is next
    result := NextGroupCode = 0;
    If ( ( ent1.flag_70 ) And 1 ) = 1 Then
      closed_poly := true;

    // Added for new Polyline Arc...
    entity := Nil;
    If Checkbulge = false Then
      entity := Polyline_.create( ent1.OCS_Z, vertices, @tempvert[0], ent1.colour,
        closed_poly, DXF_Layer( DXF_Layers[Layer] ).LineStyle )
    Else
    Begin
      m := 0; //ЗцАз БЎБВЗҐ°Є є№»зА§ДЎ...
      For i := 0 To vertices - 1 Do
        If tempfv[i] <> 0 Then
        Begin
          If i < ( vertices - 1 ) Then
          Begin
            If bulge2arc( tempvert[i], tempvert[i + 1], tempfv[i], cc, rr, sa, ea ) = 0 Then
            Begin
              tempvert2[m] := tempvert[i];
              inc( m );
              Arc( cc.x, cc.y, tempvert[i].z, rr, sa, ea, tempfv[i], m );
            End;
          End
          Else
          Begin
            If closed_poly Then
            Begin
              If bulge2arc( tempvert[i], tempvert[0], tempfv[i], cc, rr, sa, ea ) = 0 Then
              Begin
                tempvert2[m] := tempvert[i];
                inc( m );
                Arc( cc.x, cc.y, tempvert[i].z, rr, sa, ea, tempfv[i], m );
              End;
            End
            Else
            Begin
              tempvert2[m] := tempvert[i];
              inc( m );
            End;
          End;
        End
        Else
        Begin
          tempvert2[m] := tempvert[i];
          inc( m );
        End;
      If m > 0 Then
        Entity := Polyline_.create( ent1.OCS_Z, m, @tempvert2[0], ent1.colour,
          closed_poly, DXF_Layer( DXF_Layers[Layer] ).LineStyle )
    End;
  End
  Else If ( ent1.flag_70 And 16 ) = 16 Then
  Begin
    // THIS IS A POLYGON MESH - a grid of vertices joined along M & N
    M := ent1.flag_71;
    N := ent1.flag_72;
    mn := 0;
    Repeat
      If ( NextGroupCode = 0 ) And ( ValStr = 'VERTEX' ) Then
      Begin
        If read_entity_data( ent2 ) Then
        Begin
          inc( mn );
          If ( ent2.Flag_70 And 64 ) = 64 Then
          Begin
            tempvert[vertices] := ent2.p1;
            inc( vertices );
            If vertices >= max_vertices_per_polyline Then
              Goto vertex_overflow;
          End
          Else
          Begin
            ent1.Free;
            ent2.Free;
            exit;
          End; // error
        End
        Else
        Begin
          ent1.Free;
          ent2.Free;
          exit;
        End; // error
      End;
    Until fLine = 'SEQEND';
    result := NextGroupCode = 0;
    If mn <> M * N Then
    Begin
      ent1.Free;
      ent2.Free;
      exit;
    End; // error
    If ent1.LineStyle = '' Then
      LS := DXF_Layer( DXF_Layers[Layer] ).LineStyle // bylayer
    Else
      LS := AcadLineStyle.FindLineStyle( ent1.linestyle );
    entity := Polygon_mesh_.create( vertices, M, N, @tempvert[0], ent1.flag_70, ent1.colour, LS );
  End
    //////////////////////////////////////////
    //////////////////////////////////////////
  Else If ( ent1.flag_70 And 64 ) = 64 Then
  Begin
    // THIS IS A POLYFACE MESH - a vertex array with facets
    Repeat
      If ( NextGroupCode = 0 ) And ( ValStr = 'VERTEX' ) Then
      Begin
        If read_entity_data( ent2 ) Then
        Begin
          If ( ent2.Flag_70 And ( 128 + 64 ) ) = ( 128 + 64 ) Then
          Begin
            // this is a normal coordinate vertex
            tempvert[vertices] := ent2.p1;
            inc( vertices );
            If vertices >= max_vertices_per_polyline Then
              Goto vertex_overflow;
          End
          Else If ( ent2.Flag_70 And ( 128 ) ) = ( 128 ) Then
          Begin
            // this is a face definition vertex
            // negative indices indicate invisible edges (ignored for now)
            tempface[faces].nf[0] := Abs( ent2.flag_71 ) - 1; // index 1..n -> 0..n-1
            tempface[faces].nf[1] := Abs( ent2.flag_72 ) - 1;
            tempface[faces].nf[2] := Abs( ent2.flag_73 ) - 1;
            tempface[faces].nf[3] := Abs( ent2.flag_74 ) - 1;
            inc( faces );
          End
          Else
          Begin
            ent1.Free;
            ent2.Free;
            exit;
          End; // error
        End
        Else
        Begin
          ent1.Free;
          ent2.Free;
          exit;
        End; // error
      End;
    Until fLine = 'SEQEND';
    result := NextGroupCode = 0;
    If ent1.LineStyle = '' Then
      LS := DXF_Layer( DXF_Layers[Layer] ).LineStyle // bylayer
    Else
      LS := AcadLineStyle.FindLineStyle( ent1.linestyle );
    entity := Polyface_mesh_.create( vertices, faces, @tempvert[0], @tempface[0], ent1.colour, LS );
  End;
  //////////////////////////////////////////
  //////////////////////////////////////////
  ent1.Free;
  ent2.Free;
  exit; // next bit only when vertices overflow

  vertex_overflow:
  ent1.Free;
  ent2.Free;
  Errlist.Add( Format( SDXFPolylineBad, [max_vertices_per_polyline, line_num] ) );
  {  raise DXF_read_exception.Create('Polyline contained more than '+
      IntToStr(max_vertices_per_polyline)+' vertices',line_num);}
End;

//polyline_arc_end

Function DXF_Reader.read_entity( Const s, endstr: String;
  Var entity: DXF_Entity; Var layer: integer ): boolean;
Begin
  entity := Nil;
  result := false;
  If ( s = 'POINT' ) Then
  Begin
    If Not general_purpose_read( Point_, entity, layer ) Then
      Errlist.add( SDXFPointBad + inttostr( line_num ) );
  End
  Else If ( s = 'INSERT' ) Then
  Begin
    If Not read_insert( entity, layer ) Then
      ErrList.add( SDXFINSERTBad + Inttostr( line_num ) );
  End
  Else If ( s = 'TEXT' ) Then
  Begin
    If Not general_purpose_read( Text_, entity, layer ) Then
      Errlist.add( SDXFTEXTBad + Inttostr( line_num ) );
  End
  Else If ( s = 'LINE' ) Then
  Begin
    If Not general_purpose_read( Line_, entity, layer ) Then
      Errlist.add( SDXFLINEBad + Inttostr( line_num ) );
  End
  Else If ( s = 'POLYLINE' ) Then
  Begin
    If Not read_polyline( entity, layer ) Then
      Errlist.add( SDXFPOLYLINEBad2 + inttostr( line_num ) );
  End
  Else If ( s = 'LWPOLYLINE' ) Then
  Begin
    If Not read_lwpolyline( entity, layer ) Then
      Errlist.add( SDXFLWPOLYLINEBad2 + inttostr( line_num ) );
  End
  Else If ( s = '3DFACE' ) Then
  Begin
    If Not general_purpose_read( Face3D_, entity, layer ) Then
      ErrList.add( SDXF3DFACEBad + Inttostr( line_num ) );
  End
  Else If ( s = 'SOLID' ) Then
  Begin
    If Not general_purpose_read( Solid_, entity, layer ) Then
      ErrList.add( SDXFSOLIDBad + Inttostr( line_num ) );
  End
  Else If ( s = 'CIRCLE' ) Then
  Begin
    If Not general_purpose_read( Circle_, entity, layer ) Then
      Errlist.add( SDXFCIRCLEBad + inttostr( line_num ) );
  End
  Else If ( s = 'ARC' ) Then
  Begin
    If Not general_purpose_read( Arc_, entity, layer ) Then
      ErrList.add( SDXFARCBad + inttostr( line_num ) );
  End
  Else If ( s = 'ATTDEF' ) Then
  Begin
    If Not general_purpose_read( AttDef_, entity, layer ) Then
      Errlist.add( SDXFATTDEFBad + inttostr( line_num ) );
  End
  Else If ( s = 'ATTRIB' ) Then
  Begin
    If Not general_purpose_read( Attrib_, entity, layer ) Then
      Errlist.add( SDXFATTRIBBad + inttostr( line_num ) );
  End
  Else If ( s = endstr ) Then
    result := true
  Else If skipped <> Nil Then
    Skipped.Add( s );

End;
///////////////////////////////////////////////////////////////////////////////
// Main routines to use
///////////////////////////////////////////////////////////////////////////////

Function DXF_Reader.read_file: boolean;
Var
  lp1: integer;
  canContinue: boolean;
Begin
  result := true;
  //Added for GIS
  If fGIS <> Nil Then
    FGIS.UpdateCaption( SDXFReading );
  Try
    mark_position;
    If Not ( move_to_header_section And read_header ) Then
    Begin
      //Added for GIS
      If fGIS <> Nil Then
        FGIS.UpdateCaption( SDXFThereIsNoHeader );

      Sleep( message_delay_ms );
      goto_marked_position;
    End;
    mark_position;

    //Myadd for r14
    If Acad_version > 12 Then
      If Not ( move_to_class_section And read_class ) Then
      Begin
        //Thinking(nil,'No Header or invalid Header section in DXF file');
        // Added for GIS
        If fGIS <> Nil Then
          FGIS.UpdateCaption( SDXFThereIsNoHeader );
        Sleep( message_delay_ms );
        goto_marked_position;
      End;
    mark_position;

    If Not ( move_to_tables_section And read_tables ) Then
    Begin
      // Added for GIS
      If fGIS <> Nil Then
        FGIS.UpdateCaption( SDXFThereIsNoLayers );
      Sleep( message_delay_ms );
      goto_marked_position;
    End;
    mark_position;

    If Not ( move_to_blocks_section And read_blocks ) Then
    Begin
      // Added for GIS
      If fGIS <> Nil Then
        FGIS.UpdateCaption( SDXFThereIsNoBlocks );
      Sleep( message_delay_ms );
      goto_marked_position;
    End;
    mark_position;
    // Added for GIS
    If fGIS <> Nil Then
      FGIS.UpdateCaption( SDXFReading );
    //
    If Not ( move_to_entity_section And read_entities ) Then
      Raise DXF_read_exception.Create( SDXFThereIsNoEntities, -1 );
  Except
    On E: DXF_read_exception Do
    Begin
      If assigned( FGis ) and assigned( FGis.OnError ) Then
      Begin
        FGis.OnError( FGis, E.Message, esImporting, canContinue );
      End;
    End;
    On E: EAccessViolation Do
    Begin
      If assigned( FGis ) and assigned( FGis.OnError ) Then
      Begin
        FGis.OnError( FGis, E.Message, esImporting, canContinue );
      End;
    End;
  End;
  If p1_eq_p2_3D( min_extents, origin3D ) Or p1_eq_p2_3D( max_extents, origin3D )
    Or (min_extents.x > max_extents.x) Or (min_extents.y > max_extents.y) Then
  Begin
    If fGIS <> Nil Then
      FGIS.UpdateCaption( SDXFThereIsNoMaxMin );
    //thinking(nil, 'No Exists Max/Min information in DXF File, Now Searching...');
    //sleep( message_delay_ms ); // just a delay to let the message be visible
    For lp1 := 0 To DXF_layers.count - 1 Do
    Begin
      If DXF_Layer(DXF_Layers[lp1]).layer_name <> 'Block_' then
        DXF_Layer( DXF_Layers[lp1] ).max_min_extents( max_extents, min_extents );
    End;
  End;
  //stopped_thinking;
  // Added for GIS
  //MyDlg.Release;
End;

Function DXF_Reader.remove_empty_layers: boolean;
Var
  lp1: integer;
  layer: DXF_layer;
Begin
  For lp1 := DXF_Layers.count - 1 Downto 0 Do
  Begin
    layer := DXF_Layers[lp1];
    If layer.entities.count = 0 Then
    Begin
      DXF_Layers.Remove( layer );
      layer.Free;
    End;
  End;
  result := ( DXF_Layers.count > 0 );
End;

// Hand over ownership of the layers, the owner of the entity lists
// is now responsible for their destruction

Function DXF_Reader.release_control_of_layers: TList;
Begin
  result := DXF_Layers;
  DXF_Layers := Nil;
End;

// Since we're not reading all groupcodes, we offer the chance
// to dump the main titles into a list so we can see what
// we've missed

Procedure DXF_Reader.set_skipped_list( s: TStrings );
Begin
  skipped := s;
End;
///////////////////////////////////////////////////////////////////////////////
// DXF File exception
///////////////////////////////////////////////////////////////////////////////

Constructor DXF_read_exception.create( Const err_msg: String; line: integer );
Begin
  If line > -1 Then
    message := err_msg + EOL + SDXFErrorInLine + IntToStr( line )
      //message := err_msg + #13#10 + 'Error occured at or near line number ' + IntToStr(line)
  Else
    message := err_msg;
End;

{ TUnicodeConverter }

function TUnicodeConverter.CharIsCode(C: Char): Boolean;
begin
  Result := UpperCase(C)[1] in ['0'..'9', 'A', 'B', 'C', 'D', 'E', 'F'];
end;

constructor TUnicodeConverter.Create;
begin

end;

destructor TUnicodeConverter.Destroy;
begin

  inherited;
end;

procedure TUnicodeConverter.PutChar(C: Char);
var
  Sub: string;
  L: Integer;
  Cd: Word;
begin
  ///  С первого символа
  ///  Если можем, то Берём подстроку
  ///     Если проверяем её
  ///     Если не наша, то переходим в следующему символу
  ///     Если наша, то читаем код после подстроки
  ///       Если код есть, то часть заканчивается началом подстроки
  ///           Если начало подстроки это первый символ, то части нет, значит часть не берём а сразу переходим дальше к формированию части с кодом
  ///       Формируем часть с кодом
  ///           Удаляем обработанный участок строки
  ///           Переходим к первому символу
  ///  Если не можем, то часть будет текущей строкой
  if fFound then
  begin
    if CharIsCode(C) then
    begin
      fCode := AnsiUpperCase(fCode + C);
    end
    else
    begin
      if fCode <> '' then
      begin
        Cd := StrToInt('$' + fCode);
        L := Length(fBuffer);
        if L >= Length(Prefix) then
        begin
          Sub := AnsiUpperCase(Copy(fBuffer, L - Length(Prefix) + 1, Length(Prefix)));
          if Sub = Prefix then
            SetLength(fBuffer, L - Length(Prefix));
        end;
        fResult := fResult + fBuffer + WideChar(Cd);
        fBuffer := '';
        fCode := '';
      end;
      fBuffer := fBuffer + C;
      fFound := False;
    end;
  end
  else
  begin
    fBuffer := fBuffer + C;
    L := Length(fBuffer);
    if L >= 3 then
    begin
      Sub := AnsiUpperCase(Copy(fBuffer, L - Length(Prefix) + 1, Length(Prefix)));
      fFound := Sub = Prefix;
    end
    else
      fFound := False;
  end;
end;

procedure TUnicodeConverter.Stop;
var
  Cd: Word;
  L: Integer;
  Sub: string;
begin
  if fFound then
  begin
    if fCode <> '' then
    begin
      Cd := StrToInt('$' + fCode);
      L := Length(fBuffer);
      if L >= Length(Prefix) then
      begin
        Sub := AnsiUpperCase(Copy(fBuffer, L - Length(Prefix) + 1, Length(Prefix)));
        if Sub = Prefix then
          SetLength(fBuffer, L - Length(Prefix));
      end;
      fResult := fResult + fBuffer + WideChar(Cd);
      fBuffer := '';
      fCode := '';
    end;
    fFound := False;
  end
  else
  begin
    fResult := fResult + fBuffer;
  end;
end;

function TUnicodeConverter.ToAnsi(const EncodedStr: string): string;
var
  I: Integer;
begin
  if Pos(Prefix, EncodedStr) < 1 then
    Result := EncodedStr
  else
  begin
    fEncoded := EncodedStr;
    fFound := False;
    fBuffer := '';
    fResult := '';
    fCode := '';
    for I := 1 to Length(fEncoded) do
      PutChar(fEncoded[I]);
    Stop();
    Result := fResult;
  end;
end;

End.
