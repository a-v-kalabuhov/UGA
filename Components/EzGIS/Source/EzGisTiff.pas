Unit EzGisTiff;

{***********************************************************}
{     EzGIS/CAD Components                                  }
{   (c) 2002 EzSoft Engineering                             }
{         All Rights Reserved                               }
{***********************************************************}

{$I EZ_FLAG.PAS}
Interface

Uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Dialogs,
  EzGraphics, EzEntities, EzLib, EzBase, EzBaseGis
{$IFDEF USE_GRAPHICEX}
  , GraphicEx, GraphicCompression, GraphicStrings, GraphicCOlor
{$ENDIF}
  ;

Type
{.$IFDEF USE_GRAPHICEX}
{.$ENDIF}

  TEzTiffEx = Class( TObject )
  Private
    { Private declarations }
{$IFDEF USE_GRAPHICEX}
    FTIFFGraphic: TEzTIFFGraphic;
{$ENDIF}
    FBlendTable: Array[SMALLINT] Of Smallint;
    { configuration }
    FPainterObject: TEzPainterObject;
    FWasSuspended: Boolean;
    FAlphaChannel: Byte;
    FBufferBitmap: TBitmap;
    FTileGlobalInfo: TEzTileGlobalInfo;
    Function TileStrip( Const CurrentTileRect: TRect ): Boolean;
    Procedure SetAlphaChannel( Value: Byte );
  Public
    { Public declarations }
    Function TiffFromFileInStrips( Const FileName: String;
      Stream: TStream;
      dc: HDC;
      DestLeft, DestTop, DestWidth, DestHeight,
      DestTotalHeight,
      SourceLeft, SourceTop,
      SourceWidth, SourceHeight: integer ): Boolean;
    { properties }
    Property PainterObject: TEzPainterObject Read FPainterObject Write FPainterObject;
    Property WasSuspended: Boolean Read FWasSuspended;
    { AlphaChannel, 0= opaque, >0 = transparent }
    Property AlphaChannel: byte Read FAlphaChannel Write SetAlphaChannel;
    { the bitmap agains with which will be made transparent this bitmap }
    Property BufferBitmap: TBitmap Read FBufferBitmap Write FBufferBitmap;
  End;

{$IFDEF FALSE}    // no longer used, instead a TEzBandsBitmap is used
  TEzBandsTiff = Class( TEzBandsBitmap )
  Protected
    Function GetEntityID: TEzEntityID; Override;
    Function BasicInfoAsString: string; Override;
  Public
    Procedure Draw( Grapher: TEzGrapher; Canvas: TCanvas; Const Clip: TEzRect;
      DrawMode: TEzDrawMode; Data: Pointer = Nil ); Override;
  End;
{$ENDIF}

Function GetTiffDimensions( Const FileName: String; Stream: TStream;
  Var TiffWidth, TiffHeight: Integer; Var IsCompressed: Boolean ): Boolean;

Implementation

Uses
  EzSystem, EzConsts;

{ TEzTiffEx }

Procedure TEzTiffEx.SetAlphaChannel( Value: Byte );
Var
  x: Integer;
Begin
  For x := -255 To 255 Do
    FBlendTable[x] := ( Value * x ) Shr 8;
  FAlphaChannel := Value;
End;

Function TEzTiffEx.TiffFromFileInStrips( Const FileName: String;
  Stream: TStream;
  dc: HDC;
  DestLeft, DestTop, DestWidth, DestHeight,
  DestTotalHeight,
  SourceLeft, SourceTop,
  SourceWidth, SourceHeight: integer ): Boolean;
{$IFDEF USE_GRAPHICEX}
Var
  CurrentTileRect: TRect;
  dest_MaxTileWidth, dest_MaxTileHeight, vdest_TileHeight: Integer;
  dest_MaxScans: Integer;
  dsty_top, vdest_TilesDown, dest_Residual: Integer;
  dy: extended;
  dest_r: TRect;
  SourceScaleY: extended;
{$ENDIF}
Begin
  result := FALSE;
{$IFDEF USE_GRAPHICEX}

  FTIFFGraphic := TEzTIFFGraphic.Create;
  If Stream = Nil Then
    FTIFFGraphic.EzOpen( FileName )
  Else
  Begin
    FTIFFGraphic.EzOpenFromStream( Stream );
    Stream.Position := 0;
  End;
  Try
    FTileGlobalInfo.SourceRect := Rect( SourceLeft, SourceTop, SourceLeft + SourceWidth, SourceTop + SourceHeight );

    { some initialization to TileGlobalInfo record }
    //FTileGlobalInfo.lpBitmapInfo:= Pointer(BMPInfo);

    FTileGlobalInfo.TotalBitmapWidth := FTIFFGraphic.ImageProperties.Width;
    FTileGlobalInfo.TotalBitmapHeight := Abs( FTIFFGraphic.ImageProperties.Height );

    FTileGlobalInfo.dc := dc;
    SourceScaleY := FTileGlobalInfo.TotalBitmapHeight / DestTotalHeight;
    FTileGlobalInfo.SourceLastScanLine := SourceTop;

    dest_MaxScans := FTIFFGraphic.ImageProperties.RowsPerStrip[0];
    dest_MaxScans := Round( dest_MaxScans * ( 1 / SourceScaleY ) );
    If dest_MaxScans < 2 Then
      dest_MaxScans := 2;
    If dest_MaxScans > FTileGlobalInfo.TotalBitmapHeight Then
      dest_MaxScans := FTileGlobalInfo.TotalBitmapHeight;

    { count the tiles down }
    dsty_top := 0;
    vdest_TilesDown := 0;
    While ( dsty_Top + dest_MaxScans ) <= DestTotalHeight Do
    Begin
      Inc( vdest_TilesDown );
      Inc( dsty_top, dest_MaxScans );
    End;
    If vdest_TilesDown = 0 Then
    Begin
      FTileGlobalInfo.SourceBandHeight := 0;
      FTileGlobalInfo.SourceFirstTileHeight := FTileGlobalInfo.TotalBitmapHeight;
    End
    Else
    Begin
      dest_Residual := DestTotalHeight Mod dest_MaxScans;
      FTileGlobalInfo.SourceBandHeight :=
        ( FTileGlobalInfo.TotalBitmapHeight * ( 1 - ( dest_Residual / DestTotalHeight ) ) ) / vdest_TilesDown;
      If SourceTop > 0 Then
      Begin
        dy := 0;
        While dy < SourceTop Do
          dy := dy + FTileGlobalInfo.SourceBandHeight;
        FTileGlobalInfo.SourceFirstTileHeight := ( dy - SourceTop );
      End
      Else
      Begin
        FTileGlobalInfo.SourceFirstTileHeight := 0;
      End;
    End;

    { continues }
    dest_r := rect( DestLeft, DestTop, DestLeft + DestWidth, DestTop + DestHeight );

    dest_MaxTileWidth := DestWidth;
    dest_MaxTileHeight := dest_MaxScans;

    CurrentTileRect.Top := dest_r.Top;
    If FTileGlobalInfo.SourceFirstTileHeight <> 0 Then
    Begin
      vdest_TileHeight := Round( FTileGlobalInfo.SourceFirstTileHeight * ( 1 / SourceScaleY ) );
      If vdest_TileHeight = 0 Then
      Begin
        vdest_TileHeight := dest_MaxTileHeight;
        FTileGlobalInfo.SourceFirstTileHeight := 0;
      End;
    End
    Else
      vdest_TileHeight := dest_MaxTileHeight;

    CurrentTileRect.Bottom := dest_r.Top + vdest_TileHeight;
    If CurrentTileRect.Bottom > dest_r.Bottom Then
    Begin
      CurrentTileRect.Bottom := dest_r.Bottom;
      If FTileGlobalInfo.SourceFirstTileHeight <> 0 Then
        FTileGlobalInfo.SourceFirstTileHeight :=
          FTileGlobalInfo.SourceFirstTileHeight * ( abs(CurrentTileRect.Bottom - CurrentTileRect.Top) / vdest_TileHeight )
      Else
        FTileGlobalInfo.SourceBandHeight :=
          FTileGlobalInfo.SourceBandHeight * ( abs(CurrentTileRect.Bottom - CurrentTileRect.Top) / vdest_TileHeight );
    End;
    CurrentTileRect.Left := dest_r.Left;
    CurrentTileRect.Right := dest_r.Left + dest_MaxTileWidth;

    While CurrentTileRect.Top < dest_r.Bottom Do
    Begin
      If Not Windows.IsRectEmpty( CurrentTileRect ) Then
      Begin
        If Not TileStrip( CurrentTileRect ) Then Break;
      End;
      CurrentTileRect.Top := CurrentTileRect.Bottom;
      CurrentTileRect.Bottom := CurrentTileRect.Top + dest_MaxTileHeight;
      If CurrentTileRect.Bottom > dest_r.Bottom Then
      Begin
        CurrentTileRect.Bottom := dest_r.Bottom;
        FTileGlobalInfo.SourceBandHeight :=
          ( abs(CurrentTileRect.Bottom - CurrentTileRect.Top) / dest_MaxTileHeight ) * FTileGlobalInfo.SourceBandHeight;
      End;

      If PainterObject <> Nil Then
      Begin
        If PainterObject.Thread = Nil Then
        Begin
          If PainterObject.IsTimer And
            ( GetTickCount > Cardinal(PainterObject.TickStart + PainterObject.SourceGis.TimerFrequency )) Then
          Begin
            PainterObject.SourceGis.OnGisTimer( PainterObject.SourceGis, FWasSuspended );
            If FWasSuspended Then Exit;

            PainterObject.TickStart := GetTickCount;
          End;
        End Else If PainterObject.Thread.Terminated Then
        Begin
          FWasSuspended:= True;
          Exit;
        End;
      End;
    End;
  Finally
    If Stream = Nil Then
      FTIFFGraphic.EzClose
    Else
      FTIFFGraphic.EzCloseFromStream;
    FTIFFGraphic.Free;
  End;
{$ENDIF}
End;

Function TEzTiffEx.TileStrip( Const CurrentTileRect: TRect ): Boolean;
{$IFDEF USE_GRAPHICEX}
Var
  img_numscans: integer;
  img_start: integer;
  img_end: integer;
  img_StartStrip: Integer;
  img_StopStrip: Integer;
  img_StripFirstScanLine: Integer;
  TmpBitmap: TBitmap;
  x, y, bgx, bgy, bgw, bgh: Integer;
  p1_32: pRGBQuadArray;
  p1_24, p2: pRGBTripleArray;
  scanlin: Pointer;
  BackgFormat: TPixelformat;
  Info: PBitmapInfo;
  Image: Pointer;
  InfoSize, ImageSize: DWORD;
  Tc: Integer;
{$ENDIF}
Begin
{$IFDEF USE_GRAPHICEX}
  img_start := Round( FTileGlobalInfo.SourceLastScanLine );
  If FTileGlobalInfo.SourceFirstTileHeight <> 0 Then
  Begin
    FTileGlobalInfo.SourceLastScanLine :=
      FTileGlobalInfo.SourceLastScanLine + FTileGlobalInfo.SourceFirstTileHeight;
    FTileGlobalInfo.SourceFirstTileHeight := 0;
  End
  Else
  Begin
    FTileGlobalInfo.SourceLastScanLine :=
      FTileGlobalInfo.SourceLastScanLine + FTileGlobalInfo.SourceBandHeight;
  End;

  img_end := Round( FTileGlobalInfo.SourceLastScanLine );
  If img_end > FTileGlobalInfo.TotalBitmapHeight Then
  Begin
    img_end := FTileGlobalInfo.TotalBitmapHeight;
  End;
  img_numscans := img_end - img_start;
  If img_numscans < 1 Then
  Begin
    result := TRUE;
    Exit;
  End;

  { read from img_start to img_end }
  With FTIFFGraphic.ImageProperties Do
  Begin
    img_StartStrip := img_start Div Integer(RowsPerStrip[0]);
    If img_StartStrip > StripCount - 1 Then
      img_StartStrip := StripCount - 1;
    img_StripFirstScanLine := img_start Mod Integer(RowsPerStrip[0]);

    img_StopStrip := img_end Div Integer(RowsPerStrip[0]);
    If img_StopStrip > StripCount - 1 Then
      img_StopStrip := StripCount - 1;
  End;

  FTIFFGraphic.EzReadStrips( img_StartStrip, img_StopStrip );

  GetDIBSizes( FTIFFGraphic.Handle, InfoSize, ImageSize );
  Info := GetMemEx( InfoSize );
  Image := GetMemEx( ImageSize );
  Try
    GetDIB( FTIFFGraphic.Handle, FTIFFGraphic.Palette, Info^, Image^ );
    If ( AlphaChannel = 0 ) Or ( BufferBitmap = Nil ) Then
    Begin
      // BufferBitmap=nil means we are printing
      { draw the bitmap }
      SetStretchBltMode( FTileGlobalInfo.dc, COLORONCOLOR );
      Tc := img_StripFirstScanLine;
      If Info^.bmiHeader.biHeight > 0 Then
        Tc := Info^.bmiHeader.biHeight - img_numscans - img_StripFirstScanLine;
      StretchDIBits( FTileGlobalInfo.dc,
        CurrentTileRect.Left,
        CurrentTileRect.Top,
        abs(CurrentTileRect.Right - CurrentTileRect.Left),
        abs(CurrentTileRect.Bottom - CurrentTileRect.Top),
        FTileGlobalInfo.SourceRect.Left, // left
        Tc, // top
        FTileGlobalInfo.SourceRect.Right - FTileGlobalInfo.SourceRect.Left, // width
        img_numscans, // height
        Image,
        Info^,
        DIB_RGB_COLORS, SRCCOPY );
    End
    Else If ( AlphaChannel > 0 ) And ( BufferBitmap <> Nil ) And
      ( BufferBitmap.PixelFormat In [pf24bit, pf32bit] ) Then
    Begin
      { will do it transparent }
      TmpBitmap := TBitmap.Create;
      Try
        { create a temporary bitmap }
        TmpBitmap.PixelFormat := pf24bit;
        TmpBitmap.Width := abs(CurrentTileRect.Right - CurrentTileRect.Left);
        TmpBitmap.Height := abs(CurrentTileRect.Bottom - CurrentTileRect.Top);
        { now stretch the original bitmap onto this one }
        SetStretchBltMode( TmpBitmap.Canvas.Handle, COLORONCOLOR );
        Tc := img_StripFirstScanLine;
        If Info^.bmiHeader.biHeight > 0 Then
          Tc := Info^.bmiHeader.biHeight - img_numscans - img_StripFirstScanLine;
        StretchDIBits(
          TmpBitmap.Canvas.Handle,
          0,
          0,
          abs(CurrentTileRect.Right - CurrentTileRect.Left),
          abs(CurrentTileRect.Bottom - CurrentTileRect.Top),
          FTileGlobalInfo.SourceRect.Left, // left
          Tc, // top
          FTileGlobalInfo.SourceRect.Right - FTileGlobalInfo.SourceRect.Left, // width
          img_numscans, // height
          Image,
          Info^,
          DIB_RGB_COLORS, SRCCOPY );
        { now combine the two bitmaps: FBufferBitmap and TmpBitmap }
        BackgFormat := BufferBitmap.PixelFormat;
        bgw := BufferBitmap.Width;
        bgh := BufferBitmap.Height;
        For y := 0 To TmpBitmap.Height - 1 Do
        Begin
          { it is assumed that FBufferBitmap.PixelFormat in [pf24bit, pf32bit] }
          bgy := y + CurrentTileRect.Top;

          If ( bgy < 0 ) Or ( bgy > bgh - 1 ) Then
            Continue;

          scanlin := BufferBitmap.ScanLine[bgy];
          p1_24 := scanlin;
          p1_32 := scanlin;
          p2 := TmpBitmap.ScanLine[y];
          For x := 0 To TmpBitmap.Width - 1 Do
          Begin
            bgx := x + CurrentTileRect.Left;
            If ( bgx < 0 ) Or ( bgx > bgw - 1 ) Then
              Continue;
            Case BackgFormat Of
              pf24bit:
                With p1_24^[bgx] Do
                Begin
                  rgbtBlue := FBlendTable[rgbtBlue - p2^[x].rgbtBlue] + p2^[x].rgbtBlue;
                  rgbtGreen := FBlendTable[rgbtGreen - p2^[x].rgbtGreen] + p2^[x].rgbtGreen;
                  rgbtRed := FBlendTable[rgbtRed - p2^[x].rgbtRed] + p2^[x].rgbtRed;
                End;
              pf32bit:
                With p1_32^[bgx] Do
                Begin
                  rgbBlue := FBlendTable[rgbBlue - p2^[x].rgbtBlue] + p2^[x].rgbtBlue;
                  rgbGreen := FBlendTable[rgbGreen - p2^[x].rgbtGreen] + p2^[x].rgbtGreen;
                  rgbRed := FBlendTable[rgbRed - p2^[x].rgbtRed] + p2^[x].rgbtRed;
                End;
            End;
          End;
        End;
      Finally
        TmpBitmap.free;
      End;
    End;
  Finally
    FreeMemEx( Info );
    FreeMemEx( Image );
  End;
  result := TRUE;
{$ENDIF}
End;

Function GetTiffDimensions( Const FileName: String;
  Stream: TStream;
  Var TiffWidth, TiffHeight: integer;
  Var IsCompressed: Boolean ): Boolean;
{$IFDEF USE_GRAPHICEX}
Var
  FTIFFGraphic: TEzTIFFGraphic;
{$ENDIF}
Begin
{$IFDEF USE_GRAPHICEX}
  IsCompressed := false; // not important
  FTIFFGraphic := TEzTIFFGraphic.Create;
  Try
    If Stream = Nil Then
      FTIFFGraphic.EzOpen( FileName )
    Else
    Begin
      FTIFFGraphic.EzOpenFromStream( Stream );
      Stream.Position := 0;
    End;
    TiffWidth := FTIFFGraphic.ImageProperties.Width;
    TiffHeight := FTIFFGraphic.ImageProperties.Height;
    Result := true;
  Finally
    If Stream = Nil Then
      FTIFFGraphic.EzClose
    Else
      FTIFFGraphic.EzCloseFromStream;
    FTIFFGraphic.Free;
  End;
{$ENDIF}
End;

{$IFDEF FALSE}
{------------------------------------------------------------------------------}
{                  TEzBandsTiff                                               }
{------------------------------------------------------------------------------}

Function TEzBandsTiff.BasicInfoAsString: string;
Begin
  Result:= Format(sBandsTiffInfo, [FPoints.AsString,FileName,AlphaChannel]);
End;

Function TEzBandsTiff.GetEntityID: TEzEntityID;
Begin
  result := idBandsTiff;
End;

Procedure TEzBandsTiff.Draw( Grapher: TEzGrapher; Canvas: TCanvas;
  Const Clip: TEzRect; DrawMode: TEzDrawMode; Data: Pointer = Nil );
Var
  BmpRect, Src, Dest: TRect;
  Work: TEzRect;
  fx, fy: Double;
  BitmapWidth, BitmapHeight, L, T, W, H: Integer;
  TiffEx: TEzTiffEx;
  IsCompressed: boolean;
  filnam: String;
  PreloadedSet: Boolean;
  Index: Integer;

  Procedure DrawAsFrame;
  var
    Oldstyle: TPenstyle;
  Begin
    Oldstyle:= Canvas.Pen.Style;
    If DrawMode = dmRubberpen Then
      Canvas.Pen.Style:= psDot;
    DrawPoints.DrawOpened( Canvas, Clip, FBox, Grapher, PenTool.FPenStyle, self.GetTransformMatrix, DrawMode );
    If DrawMode = dmRubberpen Then
      Canvas.Pen.Style:= Oldstyle;
  End;

Begin
  If Not IsBoxInBox2D( FBox, Clip ) Then Exit;

  If DrawMode <> dmNormal Then
  Begin
    DrawAsFrame;
    Exit;
  End;
{$IFDEF USE_GRAPHICEX}
  PreloadedSet := false;
  If ( Stream = Nil ) And Ez_Preferences.UsePreloadedBandedImages Then
  Begin
    Index := Ez_Preferences.PreloadedBandedImages.IndexOf( FileName );
    If Index >= 0 Then
    Begin
      Stream := TStream( Ez_Preferences.PreloadedBandedImages.Objects[Index] );
      Stream.Position := 0;
      PreloadedSet := true;
    End;
  End;

  If Stream = Nil Then
  Begin
    filnam := AddSlash( Ez_Preferences.CommonSubDir ) + FileName;
    If Not FileExists( filnam ) Then
    Begin
      DrawAsFrame;
      Exit;
    End;
  End;

  If Not GetTiffDimensions( filnam, Stream, BitmapWidth, BitmapHeight, IsCompressed ) Then
  Begin
    If PreloadedSet Then
      Stream := Nil;
    Exit;
  End;

  TiffEx := TEzTiffEx.Create;
  Try
    TiffEx.BufferBitmap := Self.BufferBitmap;
    TiffEx.AlphaChannel := Self.AlphaChannel;
    TiffEx.PainterObject := Self.PainterObject;
    If IsBoxFullInBox2D( fBox, Clip ) Then
    Begin
      Dest := ReorderRect( Grapher.RealToRect( FBox ) );
      With Dest Do
        TiffEx.TiffFromFileInStrips( filnam,
          Stream,
          Canvas.Handle,
          Left,
          Top,
          ( Right - Left ),
          ( Bottom - Top ),
          ( Bottom - Top ),
          0, 0,
          BitmapWidth,
          BitmapHeight );
    End
    Else
    Begin
      // Calculate image rectangle
      Work := IntersectRect2D( FBox, Clip );

      If IsRectEmpty2D( Work ) Then
        Exit;

      Dest := Grapher.RealToRect( Work );
      BmpRect := Grapher.RealToRect( fBox );
      Src := Dest;
      With BmpRect Do
      Begin
        fx := BitmapWidth / ( Right - Left );
        fy := BitmapHeight / ( bottom - top );
        OffsetRect( Src, -Left, -Top );
      End;
      L := round( Src.Left * fx );
      T := round( Src.Top * fy );
      W := round( ( Src.Right - Src.Left ) * fx );
      H := round( ( Src.Bottom - Src.Top ) * fy );

      If ( W = 0 ) Or ( H = 0 ) Then
        Exit;

      With Dest Do
        TiffEx.TiffFromFileInStrips( filnam,
          Stream,
          Canvas.Handle,
          Left,
          Top,
          ( Right - Left ),
          ( Bottom - Top ),
          ( BmpRect.Bottom - BmpRect.Top ),
          L, T, W, H );
    End;
    WasSuspended := TiffEx.WasSuspended;
  Finally
    TiffEx.Free;
    If PreloadedSet Then
      Stream := Nil;
  End;
{$ELSE}
  DrawAsFrame;
{$ENDIF}
End;
{$ENDIF}

{ TEzTIFFGraphic }


End.
