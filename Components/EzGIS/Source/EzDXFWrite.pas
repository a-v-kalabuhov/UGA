Unit EzDXFWrite;

{***********************************************************}
{     EzGIS/CAD Components                                  }
{   (c) 2002 EzSoft Engineering                             }
{         All Rights Reserved                               }
{***********************************************************}

{$I EZ_FLAG.PAS}
Interface

Uses
  SysUtils, Classes, EzDXFUtil, EzDxfImport;

///////////////////////////////////////////////////////////////////////////////
// DXF_Writer class definition
///////////////////////////////////////////////////////////////////////////////
Type
  DXF_Writer = Class
  Private
    IO_Chan: Text;
  Public
    // Extents in (x,y) of the dataset
    min_extents: Point3D;
    max_extents: Point3D;
    DXF_Layers: TList;
    // Constructors and destructors
    Constructor create( Const aname: String; data_list: TList );
    Destructor Destroy; Override;
    Procedure write_file;
    // Header section
    Function write_header: boolean;
    // Tables section
    Function write_tables: boolean;
    Function write_layer_information: boolean;
    Function write_vport_information: boolean;
    // BLocks section
    Function write_blocks: boolean;
    // Entities section
    Function write_entities: boolean;
  End;

  // DXF File write exceptions will be this type
Type
  DXF_write_exception = Class( Exception );

Procedure write_handle( Var IO: textfile );

Implementation

Const
  EOL = #13#10;

Procedure write_handle( Var IO: textfile );
Begin
  {writeln(IO,5 ,EOL, inttohex(Handle,4));
  inc(Handle);}
End;

{ --------------------------------------------------------------------------- }
{ -------------------             DXFWriter           ----------------------- }
{ --------------------------------------------------------------------------- }

Constructor DXF_Writer.Create( Const aname: String; data_list: TList );
Begin
  Inherited Create;
  AssignFile( IO_Chan, aName );
  Rewrite( IO_Chan );
  DXF_Layers := data_list;
End;

Destructor DXF_Writer.Destroy;
Begin
  CloseFile( IO_chan );
  Inherited Destroy;
End;

Procedure DXF_Writer.write_file;
Begin
  write_header;
  write_tables;
  write_blocks;
  write_entities;
  writeln( IO_chan, 0, EOL, 'EOF' );
End;

Function DXF_Writer.write_header: boolean;
Var
  lp1: integer;
  layer: DXF_Layer;
Begin
  result := true;
  min_extents := aPoint3D( 1E10, 1E10, 1E10 );
  max_extents := aPoint3D( -1E10, -1E10, -1E10 );
  writeln( IO_chan, 0, EOL, 'SECTION' );
  writeln( IO_chan, 2, EOL, 'HEADER' );
  writeln( IO_chan, 9, EOL, '$ACADVER' );
  writeln( IO_chan, 1, EOL, 'AC1009' );
  For lp1 := 0 To DXF_layers.count - 1 Do
  Begin
    layer := DXF_Layer( DXF_Layers[lp1] );
    If layer.name = 'Block_' Then
      continue;
    layer.max_min_extents( max_extents, min_extents );
  End;
  writeln( IO_chan, 9, EOL, '$EXTMIN' );
  writeln( IO_chan, 10, EOL, FloatToStr( min_extents.x ) );
  writeln( IO_chan, 20, EOL, FloatToStr( min_extents.y ) );
  writeln( IO_chan, 30, EOL, FloatToStr( min_extents.z ) );
  writeln( IO_chan, 9, EOL, '$EXTMAX' );
  writeln( IO_chan, 10, EOL, FloatToStr( max_extents.x ) );
  writeln( IO_chan, 20, EOL, FloatToStr( max_extents.y ) );
  writeln( IO_chan, 30, EOL, FloatToStr( max_extents.z ) );
  writeln( IO_chan, 0, EOL, 'ENDSEC' );
End;

Function DXF_Writer.write_tables: boolean;
Begin
  writeln( IO_chan, 0, EOL, 'SECTION' );
  writeln( IO_chan, 2, EOL, 'TABLES' );
  write_vport_information;
  write_layer_information;
  writeln( IO_chan, 0, EOL, 'ENDSEC' );
  result := true;
End;

Function DXF_Writer.write_layer_information: boolean;
Var
  lp1: integer;
  layer: DXF_Layer;
Begin
  writeln( IO_chan, 0, EOL, 'TABLE' );
  writeln( IO_chan, 2, EOL, 'LAYER' );
  writeln( IO_chan, format( '%2d', [70] ), EOL, format( '%6d', [DXF_layers.count] ) );
  For lp1 := DXF_layers.count - 1 Downto 0 Do
  Begin
    layer := DXF_Layer( DXF_Layers[lp1] );
    If layer.name = 'Block_' Then
      continue;
    writeln( IO_chan, format( '%2d', [0] ), EOL, 'LAYER' );
    writeln( IO_chan, format( '%2d', [2] ), EOL, layer.name );
    writeln( IO_chan, format( '%2d', [70] ), EOL, format( '%6d', [0] ) );
    writeln( IO_chan, format( '%2d', [62] ), EOL, format( '%6d', [layer.layer_colinx] ) );
    writeln( IO_chan, format( '%2d', [6] ), EOL, layer.lineType );
  End;
  writeln( IO_chan, format( '%2d', [0] ), EOL, 'ENDTAB' );
  result := true;
End;

Function DXF_Writer.write_vport_information: boolean;
Begin
  writeln( IO_chan, 0, EOL, 'TABLE' );
  writeln( IO_chan, 2, EOL, 'VPORT' );
  writeln( IO_chan, 70, EOL, 3 );
  writeln( IO_chan, 0, EOL, 'VPORT' );
  writeln( IO_chan, 2, EOL, '*ACTIVE' );
  writeln( IO_chan, 70, EOL, 0 );
  writeln( IO_chan, 10, EOL, 0 );
  writeln( IO_chan, 20, EOL, 0 );
  writeln( IO_chan, 11, EOL, 1 );
  writeln( IO_chan, 21, EOL, 1 );

  {  writeln(IO_chan,10,EOL,FloatToStr(min_extents.x));
    writeln(IO_chan,20,EOL,FloatToStr(min_extents.y));
    writeln(IO_chan,11,EOL,FloatToStr(max_extents.x));
    writeln(IO_chan,21,EOL,FloatToStr(max_extents.y));  }

  writeln( IO_chan, 12, EOL, FloatToStr( min_extents.x + ( max_extents.x - min_extents.x ) / 2 ) );
  writeln( IO_chan, 22, EOL, FloatToStr( min_extents.y + ( max_extents.y - min_extents.y ) / 2 ) );
  writeln( IO_chan, 13, EOL, 0 );
  writeln( IO_chan, 23, EOL, 0 );
  writeln( IO_chan, 14, EOL, 1 );
  writeln( IO_chan, 24, EOL, 1 );
  writeln( IO_chan, 15, EOL, 0 );
  writeln( IO_chan, 25, EOL, 0 );
  writeln( IO_chan, 16, EOL, 0 );
  writeln( IO_chan, 26, EOL, 0 );
  writeln( IO_chan, 36, EOL, 1 );
  writeln( IO_chan, 17, EOL, 0 );
  writeln( IO_chan, 27, EOL, 0 );
  writeln( IO_chan, 37, EOL, 0 );
  writeln( IO_chan, 40, EOL, ( max_extents.y - min_extents.y ) / 2: 10: 6 );
  writeln( IO_chan, 41, EOL, 1.0: 10: 6 ); //aspect ratio
  writeln( IO_chan, 42, EOL, 50.0: 10: 6 );
  writeln( IO_chan, 43, EOL, 0 );
  writeln( IO_chan, 44, EOL, 0 );
  writeln( IO_chan, 50, EOL, 0 );
  writeln( IO_chan, 51, EOL, 0 );
  writeln( IO_chan, 71, EOL, 0 );
  writeln( IO_chan, 72, EOL, 100 );
  writeln( IO_chan, 73, EOL, 1 );
  writeln( IO_chan, 74, EOL, 1 );
  writeln( IO_chan, 75, EOL, 0 );
  writeln( IO_chan, 76, EOL, 0 );
  writeln( IO_chan, 77, EOL, 0 );
  Writeln( IO_chan, 78, EOL, 1 );

  writeln( IO_chan, 0, EOL, 'ENDTAB' );
  result := true;
End;

Function DXF_Writer.write_blocks: boolean;
Var
  lp1, lp2: integer;
  layer: DXF_Layer;

  { function findblock(const name:string):boolean ;
   var i,j :  integer ;
   begin
     result := false ;
     if blocklist.count>0 then
       for i:=0 to blocklist.count-1 do begin
          if blocklist[i] = name then begin
             result := true ;
             exit ;
          end ;
       end ;
     blocklist.add(name);
   end ;}

Begin
  {  BlockList := Tstringlist.Create ;
    BlockList.Clear ;}

  writeln( IO_chan, 0, EOL, 'SECTION' );
  writeln( IO_chan, 2, EOL, 'BLOCKS' );
  // find the layer with the blocks in it (should be 'Block_')
  layer := Nil;
  For lp1 := 0 To DXF_Layers.count - 1 Do
    If DXF_Layer( DXF_Layers[lp1] ).name = 'Block_' Then
    Begin
      layer := DXF_Layer( DXF_Layers[lp1] );
      Break;
    End;
  If layer <> Nil Then
  Begin
    For lp2 := 0 To layer.entities.count - 1 Do
    Begin
      // if findblock(block_(eList.entities[lp3]).name)=false then
      If ( copy( block_( layer.entities[lp2] ).name, 1, 1 ) <> '*' ) Then //didn't save Refercen block
        DXF_Entity( layer.entities[lp2] ).write_to_DXF( IO_chan, '0', Layer.colour );
    End;
  End;
  writeln( IO_chan, 0, EOL, 'ENDSEC' );

  {  blocklist.free ;
    blocklist:=nil;}
  result := true;
End;

Function DXF_Writer.write_entities: boolean;
Var
  lp1, lp2: integer;
  layer: DXF_Layer;
Begin
  writeln( IO_chan, 0, EOL, 'SECTION' );
  writeln( IO_chan, 2, EOL, 'ENTITIES' );
  For lp1 := 0 To DXF_layers.count - 1 Do
  Begin
    layer := DXF_Layer( DXF_Layers[lp1] );
    If layer.name = 'Block_' Then
      continue;
    For lp2 := 0 To layer.entities.count - 1 Do
      DXF_Entity( layer.entities[lp2] ).write_to_DXF( IO_chan, layer.name, Layer.colour );
  End;
  writeln( IO_chan, 0, EOL, 'ENDSEC' );
  result := true;
End;

End.
