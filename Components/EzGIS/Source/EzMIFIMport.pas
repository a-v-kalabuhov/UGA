Unit EzMIFImport;

{***********************************************************}
{     EzGIS/CAD Components                                  }
{   (c) 2002 EzSoft Engineering                             }
{         All Rights Reserved                               }
{***********************************************************}

{$I EZ_FLAG.PAS}
Interface

Uses
  Windows, Forms, Controls, SysUtils, Classes, Graphics,
  ezLib, ezbasegis, ezshpimport, ezbase, EzImportBase;

Type

  TEzMIFInfo = Record
    nRecords: integer;
    nMaxRecords: integer;
    ProjectionType: String;
    ProjectionUnit: String;
    ProjectionParam: Array[0..3] Of String;
    adBoundsMin: Array[0..1] Of double;
    adBoundsMax: Array[0..1] Of double;
  End;

  TEzMifImport = Class(TEzBaseImport)
  Private
    { data needed when importing }
    MIFInfo: TEzMIFInfo;
    gsMIDSepChar: String;
    giMIFVersion: integer;

    gslFields, gslMIF, gslMID: TStrings;
    gMIFlines, gMIDlines: TStringList;
    giMIFLinePos, giMIDLinePos: integer;

    {default style set}
    defPen: TEzPenStyle;
    defbrush: TEzBrushStyle;
    deffont: TEzFontStyle;
    defsymbol: TEzSymbolStyle;

    HaveBound: boolean;
    MinX: double;
    Miny: double;
    MaxX: double;
    Maxy: double;
    EntityNo: integer;
    EntitiesCount: integer;

    cDecSep: Char;
    fOK: Boolean;
    ValidMifType: Boolean;
    nEntities: Integer;

    { for progress messages }
    MyEntNo: Integer;

    Procedure CompareBoundary( x, y: double );
    Function FetchMIFdata( bSplit: Boolean ): Boolean;
    Function ReadSymbolObject: Boolean;
    Function ReadPenObject: Boolean;
    Function ReadBrushObject: Boolean;
    Function ReadFontObject: Boolean;
    Function ReadPointObject: TEzEntity;
    Function ReadRegionObject: TEzEntity;
    Function ReadPLineObject: TEzEntity;
    Function ReadLineObject: TEzEntity;
    Function ReadTextObject: TEzEntity;
    Function ReadArcObject: TEzEntity;
    Function ReadEllipseObject: TEzEntity;
    Function ReadRectangleObject: TEzEntity;
    Function MIFDataCount: Longint;
    Procedure MIFOpen;
  Public
    Constructor Create( AOwner: TComponent ); Override;
    Destructor Destroy; Override;
    Procedure ImportInitialize; Override;
    Procedure GetSourceFieldList( FieldList: TStrings ); Override;
    Procedure ImportFirst; Override;
    Procedure AddSourceFieldData(DestLayer: TEzBaseLayer; DestRecno: Integer); Override;
    Function GetSourceExtension: TEzRect; Override;
    Function ImportEof: Boolean; Override;
    Function GetNextEntity(var progress,entno: Integer): TEzEntity; Override;
    Procedure ImportNext; Override;
    Procedure ImportEnd; Override;
  End;

  { TEzMIFExport}
  TEzMIFExport = Class( TEzBaseExport )
  Private
    CharSet: TFontCharSet;
    FMif, FMid: Text;
    SCharset, FMifName, FMidName: String;
    TS: TStringList;
    X1, Y1, X2, Y2: Double;
    FLayer: TEzBaseLayer;
    Function WriteMid( RecNo: Integer ): Boolean;
    Function WMIF( const S: String ): boolean;
    Function WMID( const S: String ): boolean;
  Public
    Procedure ExportInitialize; Override;
    Procedure ExportEntity( SourceLayer: TEzBaseLayer; Entity: TEzEntity ); Override;
    Procedure ExportEnd; Override;
  End;

Implementation

Uses
  ezimpl, ezConsts, ezSystem, ezbasicctrls, ezentities, Math ;

{$R-}
Type

  // for mapinfo.dll
  Ttab2mif = Function( Const fn1, fn2: pchar ): integer; stdcall;

  {------------------------------------------------------------------------------
   StrSplitToList
  ------------------------------------------------------------------------------}

Function StrSplitToList( Const sToSplit, sSeparator: String; tsStrList: TStrings;
  bAllowEmpty: Boolean ): Integer;
Var
  iCurPos, iNoStrings: Integer;
  sTmpRet, sTmpStr: String;
Begin
  sTmpRet := Copy( sToSplit, 1, Length( sToSplit ) );
  iCurPos := AnsiPos( sSeparator, sToSplit );
  tsStrList.Clear;
  iNoStrings := 0;
  If iCurPos > 0 Then
  Begin
    While iCurPos > 0 Do
    Begin
      sTmpStr := Copy( sTmpRet, 0, iCurPos - 1 );
      If ( Length( sTmpStr ) > 0 ) Or bAllowEmpty Then { let user choose to get empty strings}
      Begin
        tsStrList.Add( sTmpStr );
        Inc( iNoStrings, 1 );
      End;
      sTmpRet := Copy( sTmpRet, iCurPos + Length( sSeparator ), Length( sTmpRet ) );
      iCurPos := AnsiPos( sSeparator, sTmpRet );
    End;
    If Length( sTmpRet ) > 0 Then
    Begin
      tsStrList.Add( sTmpRet );
      Inc( iNoStrings, 1 );
    End;
  End
  Else
  Begin
    If ( Length( sTmpRet ) > 0 ) Or bAllowEmpty Then
    Begin
      tsStrList.Add( sTmpRet );
      Inc( iNoStrings, 1 );
    End;
  End;
  Result := iNoStrings;
End;

{------------------------------------------------------------------------------
 StrSplitToList2 MID DataConversion
------------------------------------------------------------------------------}

Function StrSplitToList2( Const sToSplit, sSeparator: String; tsStrList: TStrings;
  bAllowEmpty: Boolean ): Integer;
Var
  iCurPos, iNoStrings: Integer;
  sTmpRet, sTmpStr: String;

  Function CheckString( s1: String ): String;
  Var
    i: integer;
    qc: boolean;
  Begin
    qc := false;
    For i := 1 To length( s1 ) Do
    Begin
      If s1[i] = '"' Then
      Begin
        qc := Not qc;
        continue;
      End;
      If ( qc = true ) And ( s1[i] = ',' ) Then
      Begin
        s1[i] := #1;
        continue;
      End;
    End;
    Result := s1;
  End;

  Function RestoreString( s1: String ): String;
  Var
    i: integer;
  Begin
    For i := 1 To length( s1 ) Do
    Begin
      If s1[i] = #1 Then
      Begin
        s1[i] := ',';
      End;
    End;
    result := s1;
  End;

  Function EraseChar( Const instr: String ): String;
  Var
    i: integer;
  Begin
    result := '';
    If trim( instr ) = '' Then
      exit;
    For i := 1 To length( instr ) Do
      If AnsiPos( instr[i], '",()' ) = 0 Then
        result := result + instr[i];
  End;

Begin
  sTmpRet := CheckString( Copy( sToSplit, 1, Length( sToSplit ) ) );
  iCurPos := AnsiPos( sSeparator, StmpRet );
  tsStrList.Clear;
  iNoStrings := 0;
  If iCurPos > 0 Then
  Begin
    While iCurPos > 0 Do
    Begin
      sTmpStr := Copy( sTmpRet, 0, iCurPos - 1 );
      If ( Length( sTmpStr ) > 0 ) Or bAllowEmpty Then { let user choose to get empty strings}
      Begin
        tsStrList.Add( EraseChar( RestoreString( sTmpStr ) ) );
        Inc( iNoStrings, 1 );
      End;
      sTmpRet := Copy( sTmpRet, iCurPos + Length( sSeparator ), Length( sTmpRet ) );
      iCurPos := AnsiPos( sSeparator, sTmpRet );
    End;
    If Length( sTmpRet ) > 0 Then
    Begin
      tsStrList.Add( EraseChar( RestoreString( sTmpRet ) ) );
      Inc( iNoStrings, 1 );
    End;
  End
  Else
  Begin
    If ( Length( sTmpRet ) > 0 ) Or bAllowEmpty Then
    Begin
      tsStrList.Add( EraseChar( RestoreString( sTmpRet ) ) );
      Inc( iNoStrings, 1 );
    End;
  End;
  Result := iNoStrings;
End;

{------------------------------------------------------------------------------
 MIF2DelphiBrush
------------------------------------------------------------------------------}

Function MIF2DelphiBrush( iStyle: Integer ): TBrushStyle;
Begin
  Case iStyle Of
    1: Result := bsClear;
    3, 19..23: Result := bsHorizontal;
    4, 24..28: Result := bsVertical;
    5, 29..33: Result := bsBDiagonal;
    6, 34..38: Result := bsFDiagonal;
    7, 39..43, 56..60: Result := bsCross;
    8, 44..52, 55, 61..70: Result := bsDiagCross;
  Else
    Result := bsSolid;
  End;
End;

{------------------------------------------------------------------------------
  MIF2DelphiColor
------------------------------------------------------------------------------}

Function MIF2DelphiColor( iColor: Integer ): Integer;
Var
  sTmp: String;
  code: integer;
Begin
  sTmp := IntToHex( iColor, 6 );
  val( '$' + Copy( sTmp, 5, 2 ) + Copy( sTmp, 3, 2 ) + Copy( sTmp, 1, 2 ), result, code );
End;

{------------------------------------------------------------------------------
  FetchMIFdata
------------------------------------------------------------------------------}

Procedure TEzMifImport.CompareBoundary( x, y: double );
Begin
  If x < minx Then
    minx := x;
  If y < miny Then
    miny := y;
  If x > maxx Then
    maxx := x;
  If y > maxy Then
    maxy := y;
End;

Function TEzMifImport.FetchMIFdata( bSplit: Boolean ): Boolean;
Var
  sTmp: String;

  //for Some odd mif compatible files.

  Function MakeSpace( Const S1, S2: String ): String;
  Var
    i: integer;
    ss1, ss2: String;
  Begin
    result := s2;
    i := AnsiPos( s1, AnsiUpperCase( s2 ) ) + Length( s1 );
    If i <> 0 Then
      If S2[i] <> ' ' Then
      Begin
        ss1 := copy( s2, 1, i - 1 );
        ss2 := copy( s2, i, length( s2 ) - i + 1 );
        result := ss1 + ' ' + ss2;
      End;
  End;

  Function strproc( const s: String ): String;
  Begin
    Result := S;
    If AnsiPos( 'PEN', AnsiUpperCase( s ) ) <> 0 Then
    Begin
      Result := MakeSpace( 'PEN', S );
      Exit;
    End
    Else If AnsiPos( 'BRUSH', AnsiUpperCase( S ) ) <> 0 Then
    Begin
      Result := MakeSpace( 'BRUSH', S );
      Exit;
    End;
  End;

Begin
  Repeat
    Inc( giMIFLinePos );
    Result := giMIFLinePos < gMIFlines.Count;
    If Not Result Then
      Exit;
    sTmp := Trim( gMIFlines[giMIFLinePos] );
  Until Length( sTmp ) <> 0;
  If Result And bSplit Then
  Begin
    sTmp := StrProc( sTmp );
    StrSplitToList( sTmp, ' ', gslMIF, False );
  End;
End;

{------------------------------------------------------------------------------
  ReadSymbolObject
------------------------------------------------------------------------------}

Function TEzMifImport.ReadSymbolObject: Boolean;
Var
  sTmp, Stmp2: String;
  i, j,code: integer;
  tempf:double;
Begin
  Result := AnsiCompareText( gslMIF[0], 'Symbol' ) = 0;
  //add for geomania
  If Result = false Then
    result := Pos( 'SYMBOL', uppercase( gslMIF[0] ) ) <> 0;
  If Not Result Then
    Exit;
  Defsymbol.Index := 0;
  Defsymbol.Rotangle := 0;
  //Defsymbol.Height := 0;
  Defsymbol.height := -12;

  sTmp := gslMIF[1];
  stmp2 := '';
  If gslmif.Count = 3 Then
    STmp2 := gslMIF[2]
  Else If gslmif.count = 5 Then
    Stmp := gslMIF[1] + gslMIF[2] + gslMIF[3]; //add for geomania

  StrSplitToList( Copy( sTmp, 2, Length( sTmp ) - 2 ), ',', gslMIF, True );

  Try
    //Defsymbol.Index := (StrToInt(gslMIF[0])) mod Globalinfo.symbols.Count; //index
    //fix for Mif Bitmap Symbol name 2001-10-14 nakijun
    val( gslMIF[0], i, j );
    If j = 0 Then
      Defsymbol.Index := abs( i - 32 )
    Else
      Defsymbol.Index := 0;
    val(gslMIF[2],tempf,code);
    DefSymbol.Height := Round( tempf );

    If Stmp2 <> '' Then
    Begin
      StrSplitToList( Copy( sTmp2, 2, Length( sTmp2 ) - 2 ), ',', gslMIF, True );
      val(gslMIF[2],tempf,code); //rotation
      DefSymbol.Rotangle := tempf;
    End;
  Except
  End;

  FetchMIFdata( True );
End;

{------------------------------------------------------------------------------
  ReadPenObject
------------------------------------------------------------------------------}

Function TEzMifImport.ReadPenObject: Boolean;
Var
  sTmp: String;
  clr,code:integer;
Begin
  Result := AnsiCompareText( gslMIF[0], 'Pen' ) = 0;
  If Not Result Then Exit;
  sTmp := gslMIF[1];
  StrSplitToList( Copy( sTmp, 2, Length( sTmp ) - 2 ), ',', gslMIF, True );

  Try
    val(gslMIF[2],clr,code );
    defpen.Color := MIF2DelphiColor( clr );
    defpen.Style := 1; //StrToInt(gslMIF[1]) - 1;
    defpen.Width := StrToIntDef( gslMIF[0], 0 );
    {If defpen.Width < 8 Then
      defpen.Width := 0
    else
      defpen.Width := defpen.Width / 100 - 0.01; }
    defpen.Width := 0
  Except
  End;

  FetchMIFdata( True );
End;

{------------------------------------------------------------------------------
 ReadBrushObject
------------------------------------------------------------------------------}

Function TEzMifImport.ReadBrushObject: Boolean;
Var
  sTmp: String;
  temp,code:integer;
Begin
  Result := AnsiCompareText( gslMIF[0], 'Brush' ) = 0;
  If Not Result Then
    Exit;
  sTmp := gslMIF[1];
  StrSplitToList( Copy( sTmp, 2, Length( sTmp ) - 2 ), ',', gslMIF, True );

  With DefBrush Do
  Try
    val(gslMIF[0],temp,code); if temp=0 then temp:=1;
    defbrush.Pattern := temp - 1;
    val(gslMIF[1],temp,code);
    defbrush.Color := MIF2DelphiColor( temp );
    //defbrush.BackColor := MIF2DelphiColor(StrToInt(gslMIF[2]));
  Except
    defbrush.Pattern := 0;
    defbrush.ForeColor := clBlack;
  End;
  FetchMIFdata( True );
End;

{------------------------------------------------------------------------------
  ReadFontObject
------------------------------------------------------------------------------}

Function TEzMifImport.ReadFontObject: Boolean;
Var
  sTmp: String;
  idx, temp,code,fstyle: integer;
Begin
  Result := AnsiCompareText( gslMIF[0], 'Font' ) = 0;
  If Result Then
  Begin
    sTmp := gslMIF[1];
    For idx := 2 To gslMIF.Count - 1 Do { put the font line back together }
      sTmp := sTmp + ' ' + gslMIF[idx];

    StrSplitToList( Copy( sTmp, 2, Length( sTmp ) - 2 ), ',', gslMIF, True );
    Try
      deffont.Name := StringReplace( gslMIF[0], '"', '', [rfReplaceAll]);

      // Mapinfo Text style
      // 1 - Bold
      // 2 - Italic
      // 4 - underline
      // 32- shadow
      // 512- All Capitals display
      // 1024 - Expand space
      deffont.Style := [];
      val(gslMIF[1],fstyle,code);
      If ( fstyle Div 1024 ) = 1 Then
        fstyle := fstyle - 1024;
      If ( fstyle Div 512 ) = 1 Then
      Begin
        deffont.Name := AnsiUppercase( deffont.Name );
        fstyle := fstyle - 512;
      End;
      If ( fstyle Div 4 ) = 1 Then
      Begin
        deffont.style := deffont.style + [fsUnderline];
        fstyle := fstyle - 4;
      End;
      If ( fstyle Div 2 ) = 1 Then
      Begin
        deffont.style := deffont.style + [fsitalic];
        fstyle := fstyle - 2;
      End;
      If fstyle = 1 Then
        deffont.style := deffont.style + [fsbold];

      val(gslMIF[2],temp,code);
      deffont.height := temp;
      If deffont.height = 0 Then
        deffont.height := -8;
      val(gslMIF[3],temp,code);
      Deffont.Color := MIF2DelphiColor( temp );
      DefFont.Angle := 0;
    Except
    End;
  End;

  //for Autodesk World Mif!!!
  If AnsiCompareText( gslMIF[0], 'Angle' ) = 0 Then
    dec( giMIFLinePos );
  While FetchMIFdata( True ) Do
  Begin
    If AnsiCompareText( gslMIF[0], 'Angle' ) = 0 Then
    Begin
      val(gslMIF[1],DefFont.Angle,code);
      continue;
    End;
    If AnsiCompareText( gslMIF[0], 'Spacing' ) = 0 Then
      continue;
    If AnsiCompareText( gslMIF[0], 'justify' ) = 0 Then
      continue;
    If AnsiCompareText( gslMIF[0], 'Label' ) = 0 Then
      continue;
    break;
  End;
End;

{------------------------------------------------------------------------------
  ReadPointObject
------------------------------------------------------------------------------}

Function TEzMifImport.ReadPointObject: TEzEntity;
Var
  P1: TEzPoint;
  idx,code: integer;
Begin
  Try
    val(gslMIF[1],P1.x,code);
    val(gslMIF[2],P1.y,code);
    Result := TEzPlace.CreateEntity( p1 );
    FetchMIFdata( True );
    ReadSymbolobject;
    TEzPlace( Result ).Symboltool.Index := DefSymbol.Index;
    With DrawBox Do
      TEzPlace( Result ).Symboltool.Height := grapher.getrealsize( Ez_Preferences.DefSymbolStyle.height );
    TEzPlace( Result ).Symboltool.Rotangle := DefSymbol.Rotangle;
    If Not HaveBound Then
    Begin
      For idx := 0 To Result.Points.Count - 1 Do
        Compareboundary( Result.Points[idx].x, Result.Points[idx].y );
    End;
  Except
    Result := Nil;
  End;
End;

{------------------------------------------------------------------------------
  ReadRegionObject
------------------------------------------------------------------------------}

Function TEzMifImport.ReadRegionObject: TEzEntity;
Var
  ipt, idx, iParts, code,Prvipoints, iPoints: integer;
  AX, AY: double;
  panPoint2D: PEzPoint;
  MifPoints: TList;
  TmpPt: TEzPoint;
  TmpLoc: Longint;
Begin
  Try
    val(gslMIF[1],iParts,code);  { get number of parts to region }
    FetchMIFdata( True );
    val(gslMIF[0],iPoints,code); { get number of points in this region }

    // Get Combined Region Color
    If iparts > 1 Then
    Begin
      Tmploc := giMIFLinePos;
      For ipt := 1 To iparts Do
      Begin
        { get number of points in this multiple region }
        If ipt > 1 Then
          val(gslMIF[0],iPoints,code);
        inc( giMIFLinePOS, ipoints );
        FetchMIFdata( True );
        ReadPenObject;
        ReadBrushObject;
        If AnsiCompareText( gslMIF[0], 'Center' ) = 0 Then
          FetchMIFdata( True );
      End;
      giMIFLinePos := Tmploc - 1;
      FetchMIFdata( True );
      val(gslMIF[0],iPoints,code);
    End;

    // Combined multiple Region process
    MifPoints := TList.Create;
    Result:= TEzPolygon.Create( ipoints );
    // for multy polygon
    prvipoints := 0;

    For ipt := 1 To iparts Do
    Begin
      { get number of points in this multiple region }
      If ipt > 1 Then
        val(gslMIF[0],ipoints,code);
      For idx := 1 To iPoints Do
      Begin
        FetchMIFdata( True );
        //if ipoints <= MAX_POINTS then
        Begin
          val(gslMIF[0],ax,code);
          val(gslMIF[1],ay,code);
          // max/Min Check
          If ( AX < MINCOORD ) Or ( AX > MAXCOORD ) Or
            ( AY < MINCOORD ) Or ( AY > MAXCOORD ) Then
            Continue;
          New( panPoint2D );
          panPoint2D^.x := AX;
          panPoint2D^.y := AY;
          MifPoints.Add( panPoint2D );
        End;
      End;

      { read attributes }
      FetchMIFdata( True );
      If ( iparts = 1 ) Or ( ipt = iparts ) Then
      Begin
        ReadPenObject;
        ReadBrushObject;
        If AnsiCompareText( gslMIF[0], 'Center' ) = 0 Then
          FetchMIFdata( True );
        With TEzClosedEntity( Result ) Do
        Begin
          Pentool.FPenstyle := Defpen;
          Brushtool.FBrushstyle := DefBrush;
        End;
      End;

      Result.BeginUpdate;
      try
        For idx := 0 To MifPoints.Count - 1 Do
        Begin
          TmpPt := PEzPoint( MifPoints[idx] )^;
          Result.Points.Add( TmpPt );
        End;
      finally
        Result.EndUpdate;
      end;

      If iparts > 1 Then
      Begin
        Result.Points.Parts.Add( Prvipoints );
        PrvIpoints := PrvIpoints + ipoints;
      End;
      //clear previous points data
      For idx := 0 To MifPoints.Count - 1 Do
        Dispose( PEzPoint( MifPoints[idx] ) );
      MifPoints.Clear;
    End; // for iparts

    If HaveBound = false Then
      For idx := 0 To Result.Points.Count - 1 Do
        Compareboundary( Result.Points[idx].x, Result.Points[idx].y );

    MifPoints.Clear;
    MifPoints.Free;
    Entityno := iparts;
  Except
    Result := Nil;
  End;

End;

{------------------------------------------------------------------------------
 ReadPLineObject
------------------------------------------------------------------------------}

Function TEzMifImport.ReadPLineObject: TEzEntity;
Var
  ipt, idx, iParts, iPoints, code,prvipoints: integer;
  AX, AY: double;
  panPoint2D: PEzPoint;
  MifPoints: TList;
  Smoothed: boolean;
  TmpPt: TEzPoint;
  PenStyle: TEzPenStyle;
Begin
  Result:= Nil;
  Try
    iParts := 1;
    iPoints := 0;
    {case of Mapinfo Mif data version}
    Case giMIFVersion Of
      300, 410, 450, 550: If gslMIF.Count > 1 Then
        Begin
          Case gslMIF.Count Of
            2:
              val(gslMIF[1],iPoints,code); { get number of points in this region }
            3:
              Begin
                val(gslMIF[2],iparts,code);
                FetchMIFdata( True );
                val(gslMIF[0],iPoints,code);
              End;
          End;
        End
        Else
        Begin
          FetchMIFdata( True );
          val(gslMIF[0],iPoints,code);
        End;
      1:
        val(gslMIF[1],iPoints,code);
    Else
      val(gslMIF[1],iParts,code);
      FetchMIFdata( True );
      val( gslMIF[0], iPoints, code );
    End;

    // Combined multiple pline process
    MifPoints := TList.Create;
    //Result := TEzPolyLine.Create(nil,ipoints);
    prvipoints := 0;

    For ipt := 1 To iparts Do
    Begin
      { get number of points in this multiple region }
      If ipt > 1 Then
        val(gslMIF[0],iPoints,code);

      For idx := 1 To iPoints Do
      Begin
        FetchMIFdata( True );
        //if ipoints <= MAX_POINTS then
        Begin
          val(gslMIF[0],ax,code);
          val(gslMIF[1],ay,code);
          // max/Min Check
          If ( abs( AX ) < 1E-10 ) Or ( abs( AX ) > 1E+10 ) Or
            ( abs( AY ) < 1E-10 ) Or ( abs( AY ) > 1E+10 ) Then
            exit;
          New( panPoint2D );
          panPoint2D^.x := AX;
          panPoint2D^.y := AY;
          MifPoints.Add( panPoint2D );
        End;
      End;

      { read attributes }
      Smoothed := false;
      FetchMIFdata( True );
      If ( iparts = 1 ) Or ( ipt = iparts ) Then
      Begin
        ReadPenObject;
        If AnsiCompareText( gslMIF[0], 'Smooth' ) = 0 Then
        Begin
          Smoothed := true;
          FetchMIFData( True );
        End;
        PenStyle.Color := defpen.Color;
        PenStyle.Style := defpen.Style;
        PenStyle.Width := defpen.Width;
      End;
      //   end else FetchMIFdata( True );

      { error }
      If Smoothed Then
        Result := TEzSpline.Create( iPoints )
      Else
        Result := TEzPolyLine.Create( ipoints );

      TEzOpenedEntity( Result ).Pentool.FPenStyle := PenStyle;

      Result.BeginUpdate;
      try
        For idx := 0 To MifPoints.Count - 1 Do
        Begin
          TmpPt := PEzPoint( MifPoints[idx] )^;
          Result.Points.Add( TmpPt );
        End;
      finally
        Result.EndUpdate;
      end;

      If iparts > 1 Then
      Begin
        Result.Points.Parts.Add( Prvipoints );
        PrvIpoints := PrvIpoints + ipoints;
      End;

      For idx := 0 To MifPoints.Count - 1 Do
        Dispose( PEzPoint( MifPoints[idx] ) );
      MifPoints.Clear;
    End; //end for multiple objects

    If HaveBound = false Then
      For idx := 0 To Result.Points.Count - 1 Do
        Compareboundary( Result.Points[idx].x, Result.Points[idx].y );

    For idx := 0 To MifPoints.Count - 1 Do
      Dispose( PEzPoint( MifPoints[idx] ) );
    MifPoints.Clear;
    MifPoints.Free;
    Entityno := iparts;

  Except
    Result := nil;
  End;

End;

{------------------------------------------------------------------------------
 ReadLineObject
------------------------------------------------------------------------------}

Function TEzMifImport.ReadLineObject: TEzEntity;
Var
  p1, p2: TEzPoint;
  idx,code: integer;
Begin
  Try
    val(gslMIF[1],p1.x,code);
    val(gslMIF[2],p1.y,code);
    val(gslMIF[3],p2.x,code);
    val(gslMIF[4],p2.y,code);
    Result := TEzPolyLine.CreateEntity( [p1, p2] );

    FetchMIFdata( True );
    ReadPenObject;
    TEzOpenedEntity( Result ).Pentool.FPenstyle := defpen;
    If HaveBound = false Then
      For idx := 0 To Result.Points.Count - 1 Do
        Compareboundary( Result.Points[idx].x, Result.Points[idx].y );

  Except
    Result := Nil
  End;
End;

{------------------------------------------------------------------------------
  ReadTextObject
------------------------------------------------------------------------------}

Function TEzMifImport.ReadTextObject: TEzEntity;
Var
  sText: String;
  p1, p2, p3: TEzPoint;
  code,idx: integer;
Begin
  Try
    FetchMIFdata( True );
    sText := gslMIF[0];
    For idx := 1 To gslMIF.Count - 1 Do
      sText := sText + ' ' + gslMIF[idx];
    //sText := ReplaceStr(ReplaceStr(Trim(sText), '"', ''), '\n', ' ');
    sText := StringReplace( StringReplace( Trim( sText ), '"', '', [rfReplaceAll] ), '\n', #13 + #10, [rfReplaceAll] );

    FetchMIFdata( True );
    val(gslMIF[0],p1.x,code);
    val(gslMIF[1],p1.y,code);
    val(gslMIF[2],p2.x,code);
    val(gslMIF[3],p2.y,code);
    p3.x := p1.x;
    p3.y := p2.y;
    FetchMIFdata( True );
    ReadFontObject;
    Result := TEzFittedVectorText.CreateEntity( p3, stext, abs( p2.y - p1.y ), -1, deffont.Angle );
    //ttext2d( Result ).Font2d := deffont ;
    TEzFittedVectorText( Result ).FontColor := deffont.color;

    If HaveBound = false Then
      For idx := 0 To Result.Points.Count - 1 Do
        Compareboundary( Result.Points[idx].x, Result.Points[idx].y );
  Except
    Result := nil
  End;
End;

{------------------------------------------------------------------------------
  ReadArcObject
------------------------------------------------------------------------------}

Function TEzMifImport.ReadArcObject: TEzEntity;
Var
  p1, p2, FirstPt, SecondPt, ThirdPt: TEzPoint;
  code,idx: integer;
  SA, Ea, tmpangle: double;
  RX, RY, CX, CY, WorkAngle: double;
Begin
  Try
    val(gslMIF[1],p1.x,code); // lower left X
    val(gslMIF[2],p1.y,code); // lower left Y
    val(gslMIF[3],p2.x,code); // topright X
    val(gslMIF[4],p2.y,code); // topright Y

    RX := Abs( P2.X - P1.X ) / 2.0; // ellipse radius X
    RY := Abs( P2.Y - P1.Y ) / 2.0; // ellipse radius Y
    CX := ( P2.X + P1.X ) / 2.0; // ellipse Center X
    CY := ( P2.Y + P1.Y ) / 2.0; // ellipse center Y

    val(gslMIF[5],Sa,code); // Start Angle
    val(gslMIF[6],Ea,code); // End Angle
    Sa := DegToRad( Sa ); // start angle in radians
    Ea := DegToRad( Ea ); // end angle in radians

    // calculate first point of start for arc
    WorkAngle := Sa;
    FirstPt := Point2D( CX + RX * Cos( WorkAngle ), CY + RY * Sin( WorkAngle ) );
    // calc second point (at middle)
    If ea > sa Then
    Begin
      WorkAngle := ( sa + ea ) / 2;
    End
    Else
    Begin
      tmpangle := ea;
      While tmpangle < sa Do
        tmpangle := tmpangle + 2 * Pi;
      WorkAngle := ( tmpangle - sa ) / 2 + sa;
    End;
    SecondPt := Point2D( CX + RX * Cos( WorkAngle ), CY + RY * Sin( WorkAngle ) );
    // calc third point
    WorkAngle := ea;
    ThirdPt := Point2D( CX + RX * Cos( WorkAngle ), CY + RY * Sin( WorkAngle ) );

    // now build the arc that will pass for this three points
    Result := TEzArc.CreateEntity( FirstPt, SecondPt, ThirdPt );

    FetchMIFdata( True );
    ReadPenObject;
    TEzArc( Result ).Pentool.FPenstyle := defpen;
    If HaveBound = false Then
      For idx := 0 To Result.Points.Count - 1 Do
        Compareboundary( Result.Points[idx].x, Result.Points[idx].y );
  Except
    Result := nil
  End;
End;

{------------------------------------------------------------------------------
 ReadEllipseObject
------------------------------------------------------------------------------}

Function TEzMifImport.ReadEllipseObject: TEzEntity;
Var
  p1, p2: TEzPoint;
  code,idx: integer;
Begin
  Try
    val(gslMIF[1],p1.x,code);
    val(gslMIF[2],p1.y,code);
    val(gslMIF[3],p2.x,code);
    val(gslMIF[4],p2.y,code);
    Result := TEzEllipse.CreateEntity( p1, p2 );

    FetchMIFdata( True );
    ReadPenObject;
    ReadBrushObject;
    With TEzClosedEntity( Result ) Do
    Begin
      Pentool.FPenstyle := defpen;
      Brushtool.FBrushstyle := defbrush;
    End;
    If HaveBound = false Then
      For idx := 0 To Result.Points.Count - 1 Do
        Compareboundary( Result.Points[idx].x, Result.Points[idx].y );

  Except
    Result := Nil
  End;
End;

{------------------------------------------------------------------------------
 ReadRectangleObject
------------------------------------------------------------------------------}

Function TEzMifImport.ReadRectangleObject: TEzEntity;
Var
  p1, p2: TEzPoint;
  code,idx: integer;
Begin
  Try
    val(gslMIF[1],p1.x,code);
    val(gslMIF[2],p1.y,code);
    val(gslMIF[3],p2.x,code);
    val(gslMIF[4],p2.y,code);
    Result := TEzRectangle.CreateEntity( p1, p2 );

    FetchMIFdata( True );
    ReadPenObject;
    ReadBrushObject;
    With TEzRectangle( Result ) Do
    Begin
      Pentool.FPenstyle := defpen;
      Brushtool.FBrushstyle := defbrush;
    End;
    If HaveBound = false Then
      For idx := 0 To Result.Points.Count - 1 Do
        Compareboundary( Result.Points[idx].x, Result.Points[idx].y );
  Except
    Result := nil
  End;
End;

// Count number of Data in MIF

Function TEzMifImport.MIFDataCount: Longint;
Var
  sTmp, sTmp1, sTmp2: String;
  Fetch: longint;
  i: Longint;

  Function splitSpace( Const ss: String; Var s1, s2: String ): boolean;
  Var
    i: integer;
  Begin
    If AnsiPos( ' ', ss ) = 0 Then
    Begin
      s1 := ss;
      s2 := ss;
      result := false;
      exit;
    End;

    i := AnsiPos( ' ', ss );
    s1 := copy( ss, 1, i - 1 );
    s2 := copy( ss, i + 1, length( ss ) - i );
    result := true;
  End;

Begin
  Result := 0;
  Fetch := 0;

  If gMIFlines.Count = 0 Then
    exit;

  // Skip Header
  While AnsiCompareText( trim( gMIFLines[fetch] ), 'Data' ) <> 0 Do
    inc( Fetch );

  // Scanning Entities
  For i := Fetch To gMIFlines.Count - 1 Do
  Begin
    sTmp := trim( gMIFLines[i] );
    If STmp <> '' Then
    Begin
      splitspace( Stmp, Stmp1, Stmp2 );
      STmp1 := UpperCase( STmp1 );
      If ( AnsiCompareText( sTmp1, 'NONE' ) = 0 ) Or
        ( AnsiCompareText( sTmp1, 'Point' ) = 0 ) Or
        ( AnsiCompareText( sTmp1, 'Region' ) = 0 ) Or
        ( AnsiCompareText( sTmp1, 'Line' ) = 0 ) Or
        ( AnsiCompareText( sTmp1, 'PLine' ) = 0 ) Or
        ( AnsiCompareText( sTmp1, 'Text' ) = 0 ) Or
        ( AnsiCompareText( sTmp1, 'Arc' ) = 0 ) Or
        ( AnsiCompareText( sTmp1, 'Ellipse' ) = 0 ) Or
        ( AnsiCompareText( sTmp1, 'Rect' ) = 0 ) Or
        ( AnsiCompareText( sTmp1, 'Roundrect' ) = 0 ) Then
        inc( result );
    End;
  End;
End;

{------------------------------------------------------------------------------
  ReadMIFHeader
------------------------------------------------------------------------------}

Procedure TEzMifImport.MIFOpen;
Const
  k: integer = 1;
Var
  fldname, szFullName, szBaseName: String;
  code,FieldCount, i, j, N: integer;
  Field, s1, s2, sTmp, prvfield: String;
  DBType: Char;
  dbflist: tstrings;
  test: TStrings;

  Function EraseChar( Const instr: String ): String;
  Var
    i: integer;
  Begin
    result := '';
    If trim( instr ) = '' Then
      exit;
    For i := 1 To length( instr ) Do
      If AnsiPos( instr[i], '",()' ) = 0 Then
        result := result + instr[i];
  End;

  Function EraseChar2( Const instr: String ): String;
  Var
    i: integer;
  Begin
    result := '';
    If trim( instr ) = '' Then
      exit;
    For i := 1 To length( instr ) Do
      If AnsiPos( instr[i], '",()' ) = 0 Then
        result := result + instr[i]
      Else
        Result := Result + ' ';
  End;

  Function splitComma( Const ss: String; Var s1, s2: String ): boolean;
  Var
    i: integer;
  Begin
    If Ansipos( ' ', ss ) = 0 Then
    Begin
      s1 := ss;
      s2 := ss;
      result := false;
      exit;
    End;

    i := Ansipos( ' ', ss );
    s1 := copy( ss, 1, i - 1 );
    s2 := copy( ss, i + 1, length( ss ) - i );
    result := true;
  End;

Begin
  (* initialize the info structure *)
  szBaseName := ChangeFileExt( Filename, '' );

  szFullName := Format( '%s.mif', [szBaseName] );
  If Not FileExists( szFullName ) Then
  Begin
    MessageToUser( Format( SShpFileNotFound, [szFullName] ), smsgerror, MB_ICONERROR );
    Exit;
  End;

  //initialize; <-- added for initialize pen and brush objects. begin
  With Ez_Preferences Do
  Begin
    defPen := DefPenStyle.FPenStyle;
    defbrush := DefBrushStyle.FBrushStyle;
    deffont := DefFontStyle.FFontStyle;
    defsymbol := DefSymbolStyle.FSymbolStyle;
  End;

  MIFInfo.nRecords := MifDataCount;
  MIFInfo.adBoundsMin[0] := 0;
  MIFInfo.adBoundsMin[1] := 0;
  MIFInfo.adBoundsMax[0] := 0;
  MIFInfo.adBoundsMax[1] := 0;
  MIFInfo.nMaxRecords := MIFInfo.nRecords;
  If MIFInfo.nMaxRecords = 0 Then
    MIFInfo.nMaxRecords := 1;

  While FetchMIFdata( True ) Do
  Begin
    sTmp := gslMIF[0];

    If AnsiCompareText( sTmp, 'Version' ) = 0 Then
      val(gslMIF[1],giMIFVersion,code);

    If AnsiCompareText( sTmp, 'Delimiter' ) = 0 Then
      gsMIDSepChar := gslMIF[1][2];

    If AnsiCompareText( sTmp, 'Data' ) = 0 Then
      Break; // Data Section

    If AnsiCompareText( sTmp, 'CoordSys' ) = 0 Then
    Begin
      If AnsiCompareText( gslMIF[1], 'Earth' ) = 0 Then
      Begin
        If gslmif.Count > 1 Then
          Mifinfo.ProjectionType := EraseChar( gslMIF[1] );
        If gslmif.Count > 5 Then
          Mifinfo.ProjectionUnit := EraseChar( gslMIF[5] );
        If gslmif.Count > 3 Then
          Mifinfo.ProjectionParam[0] := EraseChar( gslMIF[3] );
        If gslmif.Count > 4 Then
          Mifinfo.ProjectionParam[1] := EraseChar( gslMIF[4] );
        If gslmif.Count > 6 Then
          Mifinfo.ProjectionParam[2] := EraseChar( gslMIF[6] );
      End
      Else If AnsiCompareText( gslMIF[1], 'NonEarth' ) = 0 Then
      Begin
        Mifinfo.ProjectionType := EraseChar( gslMIF[1] );
        Mifinfo.ProjectionUnit := EraseChar( gslMIF[3] );
        Mifinfo.ProjectionParam[0] := '';
        Mifinfo.ProjectionParam[1] := '';
        Mifinfo.ProjectionParam[2] := '';
      End;
      //Bounds Check
      Havebound := false;
      For i := 0 To gslMIF.Count - 1 Do
        If AnsiCompareText( gslMIF[i], 'Bounds' ) = 0 Then
          HaveBound := true;

      If Havebound = false Then
      Begin
        If FetchMIFdata( True ) = false Then
          exit;
        sTmp := gslMIF[0];
      End;

      If HaveBound Then
      Begin
        For i := 0 To gslMIF.Count - 1 Do
          If AnsiCompareText( gslMIF[i], 'Bounds' ) = 0 Then
          Begin
            val(EraseChar( gslMIF[i + 1] ),MIFInfo.adBoundsMin[0],code);
            val(EraseChar( gslMIF[i + 2] ),MIFInfo.adBoundsMin[1],code);
            val(EraseChar( gslMIF[i + 3] ),MIFInfo.adBoundsMax[0],code);
            val(EraseChar( gslMIF[i + 4] ),MIFInfo.adBoundsMax[1],code);
            break;
          End;
      End
      Else If ( AnsiCompareText( gslMIF[0], 'Bounds' ) = 0 ) And ( gslmif.count = 3 ) Then
      Begin
        Splitcomma( EraseChar( gslMIF[1] ), s1, s2 );
        val(s1,MIFInfo.adBoundsMin[0],code);
        val(s2,MIFInfo.adBoundsMin[1],code);
        Splitcomma( EraseChar( gslMIF[2] ), s1, s2 );
        val(s1,MIFInfo.adBoundsMax[0],code);
        val(s2,MIFInfo.adBoundsMax[1],code);
      End;
    End;
    If AnsiCompareText( sTmp, 'Columns' ) = 0 Then
      Break;
  End;

  //Mapinfo Database Structure...

  If AnsiCompareText( sTmp, 'Columns' ) = 0 Then
  Begin
    val(gslMIF[1],fieldcount,code);

    If fieldCOunt > 0 Then
    Begin
      test:= TStringList.Create;
      try
        For i := 0 To fieldcount - 1 Do
        Begin
          FetchMIFdata( True );

          //fix for mapinfo.dll.   <--- added begin
          If gslMIF[0] = prvfield Then
          Begin
            FetchMIFdata( True );
            prvfield := gslMIF[0];
          End
          Else
            prvfield := gslMIF[0]; //<-- added end

          DBType := #0;
          If gslmif.Count > 2 Then
            s1 := EraseChar2( gslMIF[1] + gslMIF[2] )
          Else
            s1 := EraseChar2( gslMIF[1] );
          dbflist := TStringlist.Create;
          StrSplitToList( s1, ' ', dbflist, True );

          If AnsiCompareText( dbflist[0], 'Char' ) = 0 Then
            DbType := 'C'
          Else If AnsiCompareText( dbflist[0], 'Integer' ) = 0 Then
            Dbtype := 'N'
          Else If AnsiCompareText( dbflist[0], 'Smallint' ) = 0 Then
            DbType := 'N'
          Else If AnsiCompareText( dbflist[0], 'Float' ) = 0 Then
            DbType := 'N'
          Else If AnsiCompareText( dbflist[0], 'Decimal' ) = 0 Then
            DbType := 'N'
          Else If AnsiCompareText( dbflist[0], 'Date' ) = 0 Then
            DbType := 'C'
          //if AnsiCompareText(dbflist[0], 'Date') = 0 then DbType := 'D';
          Else If AnsiCompareText( dbflist[0], 'Logical' ) = 0 Then
            DbType := 'L';

          fldname:= gslMIF[0];//Copy(gslMIF[0],1,10);
          N:= 0;
          while test.IndexOf(fldname) >= 0 do
          begin
            if length(fldname)>=10 then
              fldname:=copy(fldname,1,9);
            fldname := fldname + '_';
            Inc(N);
            if N > 10 then break;
          end;
          fldname:= Copy(fldname,1,10);
          if test.IndexOf(fldname) >= 0 then
            fldname := 'fld' + IntToStr(test.Count);
          test.add(fldname);

          Field := fldname + ';' + Dbtype;

          {if length(gslmif[0]) < 10 then
            Field := gslMIF[0] + ';' + Dbtype
          else
            Field := copy(gslMIF[0], 1, 10) + ';' + Dbtype;}

          s1 := '';
          Case dbflist.count Of
            1: s1 := ';12;2';
            2: s1 := s1 + ';' + dbflist[1] + ';0';
          Else
            For j := 1 To dbflist.count - 1 Do
              s1 := s1 + ';' + dbflist[j];
          End;
          gslFields.Add( Field + s1 );
          dbflist.Free;
        End;
      finally
        test.free;
      end;
      If pos( 'UID', gslFields[0] ) = 0 Then
        gslFields.Insert( 0, 'UID;N;12;0' );
    End
    Else
    Begin
      gslFields.Add( 'UID;N;12;0' );
    End;

    FetchMIFdata( True );

  End;
End;

//Erase Layer

Procedure TEzMifImport.ImportInitialize;
var
  Saved: TCursor;
  emin, emax: TEzPoint;
  filenam: string;
  LibHandle: THandle;
  _tab2mif: Ttab2mif;
Begin
  filenam := Self.FileName;
  // check if it is a TAB file and convert to .MIF if it is
  If AnsiCompareText( ExtractFileExt( filenam ), '.TAB' ) = 0 Then
  Begin
    LibHandle := LoadLibrary( PChar( 'mapinfo.dll' ) );
    If LibHandle < 32 Then
      EzGISError( SDLLLoadError );
    Saved := Screen.Cursor;
    If DrawBox.GIS.ShowWaitCursor Then
      Screen.Cursor := crHourGlass;
    Try
      @_tab2mif := GetProcAddress( LibHandle, PChar( 1 ) );
      _tab2mif( PChar( filenam ), Pchar( changefileext( filenam, '.MIF' ) ) );
    Finally
      FreeLibrary( LibHandle );
      If DrawBox.GIS.ShowWaitCursor Then
        Screen.Cursor := Saved;
    End;

    filenam := changefileext( filenam, '.MIF' );
  End;
  cDecSep := DecimalSeparator;
  DecimalSeparator := '.';

  { Load MIF/MID TEXT file To Strings }
  gMIFlines.Clear;
  gMIFlines.LoadFromFile( FileNam );
  gMIDlines.Clear;
  If FileExists( ChangeFileExt( Filenam, '.mid' ) ) Then
    gMIDlines.LoadFromFile( ChangeFileExt( Filenam, '.mid' ) );
  giMIFLinePos := -1;
  giMIDLinePos := -1;

  MIFOpen;

  If HaveBound Then
  Begin
    emin.x := MifInfo.adBoundsMin[0];
    emin.y := MifInfo.adBoundsMin[1];
    emax.x := MifInfo.adBoundsMax[0];
    emax.y := MifInfo.adBoundsMax[1];
    If Abs(emax.x - emin.x) <= 360 Then
    Begin
      { presumably source file is defined in degrees }
      Converter.SourceCoordSystem := csLatLon;
      If DrawBox.GIS.Layers.Count = 0 Then
        Converter.DestinCoordSystem := csLatLon;
    End;
  End;
  nEntities:= MIFInfo.nRecords;
  MyEntNo:= 0;
End;

Procedure TEzMifImport.GetSourceFieldList( FieldList: TStrings );
Begin
  FieldList.Assign(gslFields);
End;

Procedure TEzMifImport.ImportFirst;
Begin
  { CREATE THE NEW ENTITY }
  fOK:= FetchMIFdata( True );
End;

Function TEzMifImport.ImportEof: Boolean;
Begin
  Result:= (Not fOK) Or (EntitiesCount >= nEntities);
End;

Function TEzMifImport.GetNextEntity(var progress,entno: Integer): TEzEntity;

  Function CheckMifType( Const EntType: String ): boolean;
  Const
    MIFType: Array[0..10] Of String =
    ( 'NONE', 'POINT', 'REGION', 'LINE', 'PLINE', 'TEXT', 'ARC', 'ELLIPSE',
      'ELLIPSE', 'RECT', 'ROUNDRECT' );
  Var
    i: integer;
  Begin
    result := false;
    For i := 0 To high( miftype ) - 1 Do
      If uppercase( EntType ) = MIFType[i] Then
      Begin
        result := true;
        Exit;
      End;
  End;

Var
  sTmp: string;
Begin

  Inc(MyEntNo);
  progress:= Round((MyEntNo / nEntities) * 100);
  entno:= MyEntNo;

  Result:= Nil;
  sTmp := uppercase( gslMIF[0] );
  Inc( giMIDLinePos );
  If giMIDLinePos < gMIDLines.Count Then
    StrSplitToList2( Trim( gMIDLines[giMIDLinePos] ), gsMidSepChar, gslMID, True );

  EntityNo := 1;
  If AnsiCompareText( sTmp, 'NONE' ) = 0 Then
  Begin
    Result:= TEzNone.CreateEntity;
    fOK:= FetchMIFdata( True );
    If Not fOK Then Exit;
    //Inc(giMIDLinePos)
  End
  Else If AnsiCompareText( sTmp, 'Point' ) = 0 Then
  Begin
    // EntityID := idPlace ;
    Result := ReadPointObject( );
  End
  Else If AnsiCompareText( sTmp, 'Region' ) = 0 Then
  Begin
    // EntityID := idPolygon;
    Result := ReadRegionObject( );
  End
  Else If AnsiCompareText( sTmp, 'Line' ) = 0 Then
  Begin
    Result := ReadLineObject( );
  End
  Else If AnsiCompareText( sTmp, 'PLine' ) = 0 Then
  Begin
    // EntityID := idPolyline;
    Result := ReadPlineObject( );
  End
  Else If AnsiCompareText( sTmp, 'Text' ) = 0 Then
  Begin
    // EntityID := idText;
    Result := ReadTextObject( );
  End
  Else If ( AnsiCompareText( sTmp, 'Arc' ) = 0 ) Then
  Begin
    // EntityID := idarc;
    Result := ReadArcObject( );
  End
  Else If ( AnsiCompareText( sTmp, 'Ellipse' ) = 0 ) Then
  Begin
    //EntityID := idellipse ;
    Result := ReadellipseObject( );
  End
  Else If ( AnsiCompareText( sTmp, 'Rect' ) = 0 ) Then
  Begin
    // EntityID := idframe ;
    Result := ReadRectangleObject( );
  End
  Else If ( AnsiCompareText( sTmp, 'Roundrect' ) = 0 ) Then
  Begin
    // EntityID := idFrame;
    Result := ReadRectangleObject( );
  End
  Else
  Begin
    fOK:= FetchMIFdata( True );
    if Not fOK then Exit;
  End;
  ValidMifType:= CheckMifType( sTmp );
  Inc( EntitiesCount );
End;

Procedure TEzMifImport.AddSourceFieldData(DestLayer: TEzBaseLayer; DestRecno: Integer);
var
  j: integer;
  ps: integer;
  fs: string;
Begin
  If ValidMifType And (DestLayer.DBTable <> Nil) Then
  Begin
    If DestLayer.DBTable.FieldCount > gslmid.Count Then
    Begin
      DestLayer.DBTable.Recno:= DestRecno;
      DestLayer.DBTable.BeginTrans;
      try
        DestLayer.DBTable.Edit;
        For j := 0 To gslmid.Count - 1 Do
        Begin
          Try
            ps:= AnsiPos(';', gslFields[j+1]);
            fs:= Copy( gslFields[j+1], 1, ps - 1 );
            DestLayer.DBTable.FieldPut( fs, gslmid[j] );
          Except
            // ignore error in fields in DB file (wrong data)
          End;
        End;
        DestLayer.DBTable.Post;
        DestLayer.DBTable.EndTrans;
      except
        DestLayer.DBTable.RollbackTrans;
        raise;
      end;
    End;
  End;
End;

Procedure TEzMifImport.ImportNext;
Begin
  // nothing to do here
End;

Function TEzMifImport.GetSourceExtension: TEzRect;
Begin
  If HaveBound Then
  Begin
    Result.emin.x := MifInfo.adBoundsMin[0];
    Result.emin.y := MifInfo.adBoundsMin[1];
    Result.emax.x := MifInfo.adBoundsMax[0];
    Result.emax.y := MifInfo.adBoundsMax[1];
  End
  Else
  Begin
    Result.emin.x := minx;
    Result.emin.y := miny;
    Result.emax.x := maxx;
    Result.emax.y := maxy;
  End;
End;

Procedure TEzMifImport.ImportEnd;
Begin
  DecimalSeparator := cDecSep;
End;

Constructor TEzMifImport.Create( AOwner: TComponent );
Begin
  Inherited Create( AOwner );
  { data needed when importing }
  gslMIF := TStringList.Create;
  gslMID := TStringList.Create;
  gMIFlines := TStringList.Create;
  gMIDlines := TStringList.Create;
  gslFields := TStringList.Create;

  gsMIDSepChar := #9;
  HaveBound := false;
  MinX := 9999999999.0;
  Miny := 9999999999.0;
  MaxX := -9999999999.0;
  Maxy := -9999999999.0;

End;

Destructor TEzMifImport.Destroy;
Begin
  gslMIF.Free;
  gslMID.Free;
  gMIFlines.Free;
  gMIDlines.Free;
  gslFields.Free;
  Inherited;
End;

{ TEzMifExport - class implementation }

Const
  //for Export
  ffloatlen: integer = 21;
  fDecsize: integer = 9;

Procedure TEzMIFExport.ExportInitialize;

  Procedure Headerwrite;
  Var
    i: integer;
    S, T: String;
  Begin
    WMIF( 'Version 300' );

    Case CharSet Of
      0: SCharSet := 'WindowsEnglish';
    Else
      SCharSet := 'WindowsEnglish';
    End;

    WMIF( 'Charset "' + SCharSet + '"' );
    WMIF( 'Delimiter ","' );

    //Coordinates section.
    S := 'CoordSys ';
    Case FLayer.LayerInfo.CoordSystem Of
      csCartesian: s := s + 'NonEarth Units "mm" ';
      csLatLon, csProjection:
        Begin
          T := 'Earth Projection 1, 1 ';
          If DrawBox.Gis.ProjectionParams.Count > 0 Then
          Begin
            TS := TStringlist.Create;
            Ts.Assign( DrawBox.Gis.ProjectionParams );
            //Japanese NormalLat/Long
            {if (TS[1]='proj=tmerc')and(ts[2]='ellps=bessel')and(Ts[3]='untis=m')and
               (TS[4]='lon_0=139.83333')and(TS[5]='lat_0=36')and(ts[6]='lat_ts=0.9999')
            then T := 'Earth Projection 1, 97 '; }
          End;
          S := S + T;
        End;
    End;

    S := S + 'Bounds (';
    FLayer.MaxMinExtents( X1, Y1, X2, Y2 );
    S := S + FloatToStrF( X1, fffixed, ffloatlen, fdecsize ) + ', ';
    S := S + FloatToStrF( Y1, fffixed, ffloatlen, fdecsize ) + ') (';
    S := S + FloatToStrF( X2, fffixed, ffloatlen, fdecsize ) + ', ';
    S := S + FloatToStrF( Y2, ffFixed, ffloatlen, fdecsize ) + ')';
    WMIF( S );

    //Field1 Char(10) Field2 Integer Field3 Decimal(10, 2) Field4 Date Field5 Logical
    If FLayer.DBTable <> Nil Then
    Begin
      //Columm writing.
      If FLayer.DBTable.FieldCount > 1 Then
        S := 'Columns ' + IntToStr( FLayer.DBTable.FieldCount - 1 )
      Else
        S := 'Columns ' + IntToStr( FLayer.DBTable.FieldCount );
      WMIF( S );

      If FLayer.DBTable.fieldCount > 1 Then //Exclude UID Field.
      Begin
        For i := 2 To FLayer.DBTable.FieldCount Do
        Begin
          //err s := '  '+FLayer.DBTable.Fields[i].FieldName+ ' ';
          s := '  ' + FLayer.DBTable.Field( i ) + ' ';
          Case FLayer.DBTable.FieldType( i ) Of
            'L': s := s + 'Logical';
            'N':
              Begin
                If FLayer.DBTable.FieldDec( i ) > 0 Then
                  s := s + 'Decimal(' + IntToStr( FLayer.DBTable.FieldLen( i ) ) + ', ' +
                    IntToStr( FLayer.DBTable.FieldDec( i ) ) + ')'
                Else
                  s := s + 'Integer';
              End;
            'C': s := s + 'Char(' + IntToStr( FLayer.DBTable.FieldLen( i ) ) + ')';
            'D': s := s + 'Date';
          End;
          WMIF( S );
        End;
      End
      Else
        WMIF( '  UID Integer' );
    End
    Else
    Begin //2002-2-19 for avoid Mif Export error
      WMIF( 'Columns 1' );
      WMIF( '  UID Integer' );
    End;

    WMIF( 'Data' );
    WMIF( '' );
  End;

Begin
  FLayer:= DrawBox.GIS.Layers.LayerByName( LayerName );
  If FLayer = Nil Then Exit;

  CharSet := 129;

  FMifName := Changefileext( Filename, '.MIF' );
  FMiDName := Changefileext( Filename, '.MID' );
  Assignfile( FMiF, FMifName );
  Assignfile( FMiD, FMidName );

  rewrite( Fmif );
  rewrite( Fmid );
  //Header writeing
  HeaderWrite;

End;

Function TEzMIFExport.WMIF( const S: String ): boolean;
Begin
  result := false;
  Try
    writeln( FMIF, S );
  Except
    result := true;
  End
End;

Function TEzMIFExport.WMID( const S: String ): boolean;
Begin
  result := false;
  Try
    writeln( FMID, S );
  Except
    result := true;
  End
End;

Procedure TEzMIFExport.ExportEnd;
Begin
  Closefile( fmif );
  Closefile( fmid );
End;

Function TEzMIFExport.WriteMid( RecNo: Integer ): Boolean;
Var
  i: integer;
  s, t: String;
  f: Double;
  year, month, day: word;
Begin
  If ( FLayer.DbTable = Nil ) Or ( FLayer.DBTable.FieldCount = 1 ) Then
  Begin
    If FLayer.DBTable <> Nil Then
      Result:=WMID( IntToStr( FLayer.DBTable.IntegerGetN( 1 ) ) )
    Else
      Result:=WMID( IntToStr( RecNO ) );
    Exit; //SKIP UID
  End;
  s := '';
  For i := 2 To FLayer.DBTable.FieldCount Do
  Begin
    Case FLayer.DBTable.FieldType( i ) Of
      'L': If FLayer.DBTable.LogicGetN( i ) Then
          t := 'T'
        Else
          t := 'F';
      'N':
        Begin
          If FLayer.DBTable.FieldDec( i ) > 0 Then
          Begin
            f := FLayer.DBTable.FloatGetN( i );
            t := FloatToStrF( f, fffixed, FLayer.DBTable.FieldLen( i ),
              FLayer.DBTable.FieldDec( i ) );
          End
          Else
            t := IntToStr( FLayer.DBTable.IntegerGetN( i ) );
        End;
      'C': t := '"' + FLayer.DBTable.StringGetN( i ) + '"';
      'D':
        Begin
          If FLayer.DBTable.DateGetN( i ) <> 0 Then
          Begin
            DecodeDate( FLayer.DBTable.DateGetN( i ), Year, Month, Day );
            T := IntToStr( year ) + IntToStr( month ) + IntToStr( day );
          End
          Else
            t := '';
        End;
      'M': t := IntToStr( 0 );
    End;
    If i < FLayer.DBTable.FieldCount Then
      s := s + t + ','
    Else
      s := s + t;
  End;
  Result:=WMID( S );
End;

Procedure TEzMIFExport.ExportEntity( SourceLayer: TEzBaseLayer; Entity: TEzEntity );
Var
  i: integer;
  Err: boolean;

  Function WritePolygonStyle( Ent: TEzEntity ): Boolean;
  Var
    Penwidth, PenPattern, BPattern: integer;
    PenColor, BForeColor, BBackColor: TColor;
    s: String;
    Cx, Cy: Double;
  Begin
    PenWidth := DrawBox.Grapher.RealToDistX( TEzOpenedEntity( Ent ).Pentool.Width );
    If PenWidth = 0 Then
      PenWidth := 1;
    PenPattern := TEzOpenedEntity( Ent ).PenTool.Style + 1;
    PenColor := MIF2DelphiColor( TEzOpenedEntity( Ent ).PenTool.Color );
    BPattern := TEzClosedEntity( Ent ).BrushTool.Pattern + 1;
    BForeColor := MIF2DelphiColor( TEzClosedEntity( Ent ).Brushtool.ForeColor );
    BBackColor := MIF2DelphiColor( TEzClosedEntity( Ent ).Brushtool.BackColor );
    WMIF( '    Pen (' + IntToStr( PenWidth ) + ',' + IntToStr( PenPattern ) + ',' + IntToStr( PenColor ) + ')' );
    Result := WMIF( '    Brush (' + IntToStr( BPattern ) + ',' + IntToStr( BForeColor ) + ',' + IntToStr( BBackColor ) + ')' );
    If Ent.EntityID = idpolygon Then
    Begin
      s := '    Center ';
      Ent.Centroid( CX, CY );
      s := s + FloatToStrF( CX, fffixed, ffloatlen, fdecsize ) + ' ';
      s := s + FloatToStrF( CY, fffixed, ffloatlen, fdecsize );
      Result := WMIF( S );
    End;
  End;

  Function WritePolygon( Ent: TEzEntity ): Boolean;
  Var
    i, j, temp, Parts: integer;
    s: String;
    PartCount, PrvCount: Longint;
  Begin
    Parts := Ent.DrawPoints.Parts.Count;
    //Prevent Wrong Exporting.
    If ( Parts = 0 ) And ( Ent.points.Count = 2 ) Then
      Ent.Points.Add( Ent.points[0] );

    If Parts = 0 Then
      Parts := 1;
    WMIF( 'Region  ' + IntToStr( Parts ) );
    PrvCount := 0;
    For i := 0 To Parts - 1 Do
    Begin
      If Parts = 1 Then
        PartCount := Ent.Points.Count
      Else
      Begin
        If i < ( Parts - 1 ) Then
          PartCount := Ent.Points.Parts[i + 1] - Ent.Points.Parts[i]
        Else
          PartCount := Ent.Points.Count - Ent.Points.Parts[i];
      End;
      WMIF( '  ' + IntToStr( PartCount ) );

      temp:=0;
      For j := PrvCount To PrvCount + PartCount - 1 Do
      Begin
        s := FloatToStrF( Ent.Points.X[j], fffixed, ffloatlen, fdecsize ) + ' ';
        S := S + FloatToStrF( Ent.Points.Y[j], fffixed, ffloatlen, fdecsize );
        Result := WMIF( S );
        temp:=j;
        If Result Then Exit;
      End;
      PrvCount := temp;
    End;
    Result:=WritePolygonStyle( Ent );
  End;

  Function writepolylineStyle( Ent: TEzEntity ): boolean;
  Var
    Penwidth, PenPattern: integer;
    PenColor: TColor;
  Begin
    PenWidth := DrawBox.Grapher.RealToDistX( TEzOpenedEntity( Ent ).Pentool.Width );
    If PenWidth = 0 Then
      PenWidth := 1;
    PenPattern := TEzClosedEntity( Ent ).Pentool.Style + 1;
    PenColor := MIF2DelphiColor( TEzClosedEntity( Ent ).Pentool.Color );
    Result := WMIF( '    Pen (' + IntToStr( PenWidth ) + ',' + IntToStr( PenPattern ) + ',' + IntToStr( PenColor ) + ')' );
    //Spline processing here.
    If Ent.EntityID = idspline Then
      Result := WMIF( '    Smooth' );
  End;

  Function WritePolyline( Ent: TEzEntity ): Boolean;
  Var
    i, j, temp,Parts: integer;
    s: String;
    PartCount, PrvCount: Longint;
  Begin
    Parts := Ent.Points.Parts.Count;
    If Parts = 0 Then
      Parts := 1;
    If Parts > 1 Then
      Result := WMIF( 'Pline Multiple ' + IntToStr( Parts ) )
    Else
      Result := WMIF( 'Pline ' + IntToStr( Ent.Points.Count ) );
    PrvCount := 0;
    For i := 0 To Parts - 1 Do
    Begin
      If Parts = 1 Then
        PartCount := Ent.Points.Count
      Else
      Begin
        If i < ( Parts - 1 ) Then
          PartCount := Ent.Points.Parts[i + 1] - Ent.Points.Parts[i]
        Else
          PartCount := Ent.Points.Count - Ent.Points.Parts[i];
      End;
      If Parts > 1 Then
        Result := WMIF( '  ' + IntToStr( PartCount ) );

      temp:=0;
      For j := PrvCount To PrvCount + PartCount - 1 Do
      Begin
        s := FloatToStrF( Ent.Points.X[j], fffixed, ffloatlen, fdecsize ) + ' ';
        S := S + FloatToStrF( Ent.Points.Y[j], fffixed, ffloatlen, fdecsize );
        Result := WMIF( S );
        temp:=j;
        If Result Then Exit;
      End;
      PrvCount := temp;
    End;
    WritePolylineStyle( ENT );
  End;

  Function WritePoint( Ent: TEzEntity ): Boolean;
  Var
    s: String;
    Style, Size: Integer;
    Color: TColor;
    CX, CY: Double;
  Begin
    s := 'Point ';
    Ent.Centroid( CX, CY );
    s := s + FloatToStrF( CX, fffixed, ffloatlen, fdecsize ) + ' ';
    s := s + FloatToStrF( CY, fffixed, ffloatlen, fdecsize );
    WMIF( S );
    //31 is blank, from 32 mapinfo's symol start.
    Style := 32 + TEzPlace( Ent ).SymbolTool.Index;
    Color := MIF2DelphiColor( clBlack );
    Size := Round( DrawBox.Grapher.DistToPointsY( TEzPlace( Ent ).Symboltool.Height ) );
    Result := WMIF( '    Symbol (' + IntToStr( Style ) + ',' + IntToStr( Color ) + ',' + IntToStr( Size ) + ')' );
  End;

  Function WriteRect( Ent: TEzEntity ): Boolean;
  Var
    s: String;
    X1, Y1, X2, Y2: Double;
  Begin
    s := 'Rect ';
    x1 := Ent.Points.X[0];
    Y1 := Ent.Points.Y[0];
    x2 := Ent.Points.X[1];
    Y2 := Ent.Points.Y[1];
    s := s + FloatToStrF( X1, fffixed, ffloatlen, fdecsize ) + ' ';
    s := s + FloatToStrF( Y1, fffixed, ffloatlen, fdecsize ) + ' ';
    s := s + FloatToStrF( X2, fffixed, ffloatlen, fdecsize ) + ' ';
    s := s + FloatToStrF( Y2, fffixed, ffloatlen, fdecsize );
    WMIF( S );
    Result := WritePolygonStyle( ENT );
  End;

  Function WriteEllipse( Ent: TEzEntity ): Boolean;
  Var
    s: String;
    X1, Y1, X2, Y2: Double;
  Begin
    s := 'Ellipse ';
    x1 := Ent.Points.X[0];
    Y1 := Ent.Points.Y[0];
    x2 := Ent.Points.X[1];
    Y2 := Ent.Points.Y[1];
    s := s + FloatToStrF( X1, fffixed, ffloatlen, fdecsize ) + ' ';
    s := s + FloatToStrF( Y1, fffixed, ffloatlen, fdecsize ) + ' ';
    s := s + FloatToStrF( X2, fffixed, ffloatlen, fdecsize ) + ' ';
    s := s + FloatToStrF( Y2, fffixed, ffloatlen, fdecsize );
    WMIF( S );
    Result := WritePolygonStyle( ENT );
  End;

  Function WriteText( Ent: TEzEntity ): Boolean;
  Var
    s, txt: String;
    X1, Y1, X2, Y2: Double;
    FontStyle, FontSize: Integer;
    FontColor: TColor;
    FontAngle: Double;
    FontName: String;
    FontHeight: Double;
  Begin
    s := 'Text  ';
    Result:= WMIF( S );
    Case Ent.EntityID Of
      idTrueTypeText:
        Begin
          txt := TEzTrueTypeText( Ent ).Text;
          FontAngle := RadToDeg( TEzTrueTypeText( Ent ).Fonttool.Angle );
        End;
      idJustifVectText:
        Begin
          txt := TEzJustifVectorText( Ent ).Text;
          FontAngle := RadToDeg( TEzJustifVectorText( Ent ).Angle );
          FontName := EzSystem.DefaultFontName;
        End;
      idFittedVectText:
        Begin
          txt := TEzFittedVectorText( Ent ).Text;
          FontAngle := RadToDeg( TEzFittedVectorText( Ent ).Angle );
          FontName := EzSystem.DefaultFontName;
        End;
    Else
      exit;
    End;
    //for multiline. Amap used #13#10 for Next line. but Mapinfo used \n.
    Txt := '"' + StringReplace( Txt, #13 + #10, '\n', [rfReplaceAll] ) + '"';
    WMIF( '    ' + Txt );
    x1 := Ent.Points.X[0];
    Y1 := Ent.Points.Y[0];
    x2 := Ent.Points.X[1];
    Y2 := Ent.Points.Y[1];
    s := '    ';
    s := s + FloatToStrF( X1, fffixed, ffloatlen, fdecsize ) + ' ';
    s := s + FloatToStrF( Y1, fffixed, ffloatlen, fdecsize ) + ' ';
    s := s + FloatToStrF( X2, fffixed, ffloatlen, fdecsize ) + ' ';
    s := s + FloatToStrF( Y2, fffixed, ffloatlen, fdecsize );
    WMIF( S );

    //Check Font Style
    FontStyle := 0;
    FontHeight := 0;
    If Ent.EntityID = idTrueTypeText Then
    Begin
      If fsbold In TEzTrueTypeText( Ent ).Fonttool.Style Then
        FontStyle := FontStyle Or 1;
      If fsitalic In TEzTrueTypeText( Ent ).Fonttool.Style Then
        FontStyle := FontStyle Or 2;
      If fsunderline In TEzTrueTypeText( Ent ).Fonttool.Style Then
        FontStyle := FontStyle Or 4;
      FontName := TEzTrueTypeText( Ent ).Fonttool.Name;
      FontHeight := TEzTrueTypeText( Ent ).Fonttool.Height;
    End;
    FontSize := DrawBox.Grapher.RealToDistY( FontHeight );
    FontColor := MIF2DelphiColor( TEzTrueTypeText( ent ).Fonttool.Color );

    S := '    Font ("' + Trim( FontName ) + '",' + IntToStr( FontStyle ) + ',' +
      IntToStr( fontsize ) + ',' + IntToStr( FontColor ) + ')';
    WMIF( S );
    S := '    Angle ' + FloatToStrF( FontAngle, fffixed, ffloatlen, fdecsize );
    Result:=WMIF( S );
  End;

  Function WriteArc( Ent: TEzEntity ): Boolean;
  Var
    s: String;
    X1, Y1, X2, Y2: Double;
    CX, CY, Rad, sangle, eangle, ca: Double;
    pu, pv: TEzPoint;

  Begin
    s := 'Arc ';

    sangle := radtodeg( TEzArc( Ent ).StartAngle );
    eangle := radtodeg( TEzArc( Ent ).EndAngle );
    Rad := TEzArc( Ent ).Radius;
    CX := TEzArc( Ent ).CenterX;
    CY := TEzArc( Ent ).CenterY;

    pu := Point2d( CX - rad, CY - rad );
    pv := Point2d( CX + rad, CY + rad );

    X1 := PU.X;
    Y1 := PU.Y;
    X2 := PV.X;
    Y2 := PV.Y;

    If radtodeg( Angle2D( Ent.Points[0], ent.Points[2] ) ) > 0 Then
    Begin
      ca := sangle;
      sangle := eangle;
      eangle := ca;
    End;

    s := s + FloatToStrF( X1, fffixed, ffloatlen, fdecsize ) + ' ';
    s := s + FloatToStrF( Y1, fffixed, ffloatlen, fdecsize ) + ' ';
    s := s + FloatToStrF( X2, fffixed, ffloatlen, fdecsize ) + ' ';
    s := s + FloatToStrF( Y2, fffixed, ffloatlen, fdecsize ) + ' ';
    s := s + FloatToStrF( sangle, fffixed, ffloatlen, fdecsize ) + ' ';
    s := s + FloatToStrF( eangle, fffixed, ffloatlen, fdecsize ) + ' ';
    WMIF( S );
    Result := WritePolylineStyle( ENT );
  End;

  Function WriteMap500( Ent: TEzEntity ): Boolean;
  Var
    Map: TEzMap500Entity;
  Begin
    Map := Ent as TEzMap500Entity;
    WriteText(Map.Text);
    WriteRect(Map);
    Result := True;
  End;

  Function WriteGroup( Ent: TEzEntity ): Boolean;
  Var
    Group: TEzGroupEntity;
    I: Integer;
  Begin
    Group := Ent as TEzGroupEntity;
    for I := 0 to Group.Count - 1 do
      ExportEntity(SourceLayer, Group.Entities[I]);
    Result := True;
  End;

Begin
  Err := false;
  i:= 0;
  Case Entity.EntityID Of
    idpolygon: Err := Writepolygon( Entity );
    idnone:
      Begin
        WMIF( 'none' );
        Err := False;
      End;
    idPolyline, idSpline: Err := WritePolyline( Entity );
    idPlace, idPoint: Err := WritePoint( Entity );
    idRectangle, idPersistBitmap, idBandsBitmap, idPictureRef,
    idTable: Err := WriteRect( Entity );
    idArc: Err := WriteArc( Entity );
    idEllipse: Err := WriteEllipse( Entity );
    idTrueTypeText, idJustifVectText, idFittedVectText: Err := WriteText( Entity );
    idGroup:  Err := WriteGroup(Entity);
    idMap500 : Err := WriteMap500(Entity);
  End;

  If Not Err Then WriteMid( i );
End;

End.
