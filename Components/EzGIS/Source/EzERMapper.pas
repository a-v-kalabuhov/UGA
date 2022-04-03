unit EzERMapper;

{$I EZ_FLAG.PAS}
{$A+}
interface

Uses
  Controls, Classes, Windows, SysUtils, Graphics, Math,
  EzLib, EzBase, EzBaseGIS, uEcwDecompress;

type

  TCoordSysType = (
    CST_NONE		{= 0},
    CST_RAW			{= 1},	(* Dataset cell x and y coords *)
    CST_UTM			{= 2},	(* Eastings and Northings *)
    CST_LATLONG	{= 3}		(* Longitude and Latitude *)
  );


  TCoordEN = Record
    eastings : double;
    northings : double;
    meters_z : double;
  End;

  TCoordLatLong = Record
    longitude : double;
    latitude : double;
    meters_z : double;
  End;

  TCoordRaw = Record
    meters_x : double;
    meters_y : double;
    meters_z:  double;
  End;

  TDSCoord = Record
    Case Integer Of
      0 : ( en : TCoordEN );
      1 : ( ll : TCoordLatLong );
      2 : ( raw : TCoordRaw );
  End;

  PEzERInfo = ^TEzERInfo;
  TEzERInfo = Record
    m_pAlgorithm : Pointer;
    origin : TDSCoord;
    topleft : TDSCoord;
    bottomright : TDSCoord;
    applytopleft : TDSCoord;
    applybottomright : TDSCoord;
    CoordSys : Integer;
    canvas_width : Integer;
    canvas_height : Integer;
    output_width : Integer;
    output_height : Integer;
    nr_columns : Integer;
    nr_rows : Integer;
    x_rel : double;
    y_rel : double;
    x_dpi : double;
    y_dpi : double;
    XPelsPerMeter : Integer;
    YPelsPerMeter : Integer;
    bitCount : Integer;
    Ok : Integer;
  End;

  TEzERMapper = Class( TEzClosedEntity )
  Private
    FFileName: String;
    FAlphaChannel: Byte;
    FVector: TEzVector;
    FDecompressor: TEcwDecompressor;
    procedure SetFileName(const Value: String);
  {$IFDEF BCB}
    function GetAlphaChannel: byte;
    function GetFileName: String;
    procedure SetAlphaChannel(const Value: byte);
  {$ENDIF}
  Protected
    Function GetDrawPoints: TEzVector; Override;
    Function GetEntityID: TEzEntityID; Override;
    Function BasicInfoAsString: string; Override;
  Public
    Constructor CreateEntity( Const P1, P2: TEzPoint; Const aFileName: String );
    Destructor Destroy; Override;
    Procedure Initialize; Override;
    Procedure LoadFromStream( Stream: TStream ); Override;
    Procedure SaveToStream( Stream: TStream ); Override;
    Procedure Draw( Grapher: TEzGrapher; Canvas: TCanvas; Const Clip: TEzRect;
      DrawMode: TEzDrawMode; Data: Pointer = Nil ); Override;
    Function StorageSize: Integer; Override;
    Procedure UpdateExtension; Override;
    Procedure UpdateControlPoint( Index: Integer; Const Value: TEzPoint; Grapher: TEzGrapher=Nil ); Override;
    Function GetControlPoints(TransfPts: Boolean; Grapher: TEzGrapher=Nil): TEzVector; Override;
    Function GetControlPointType( Index: Integer ): TEzControlPointType; Override;
    Function IsEqualTo( Entity: TEzEntity; IncludeAttribs: Boolean  = false): Boolean; Override;

    { This property determines the AlphaChannel of the image
      0= opaque, 255= transparent }
    Property AlphaChannel: byte {$IFDEF BCB} Read GetAlphaChannel Write SetAlphaChannel {$ELSE} Read FAlphaChannel Write FAlphaChannel {$ENDIF};
    Property FileName: String {$IFDEF BCB} Read GetFileName Write SetFileName {$ELSE} Read FFileName Write SetFileName {$ENDIF};
  End;

  Procedure LoadERMapperDll;
  
Var
  HandleERMapperDll : THandle = 0;
  ERMapperDllLoaded : Boolean = False;

  GetImage : Function (Info : PEzERInfo;
			                 Var m_hBitMap : HBITMAP;
                       Var m_BmpInfo : BITMAPINFO;
			                 m_hDC : THandle;
                       Var bits : Pointer) : Integer cdecl stdcall;
  GetEzERInfo : Function (lpszPathName : PChar) : PEzERInfo cdecl stdcall;
  ERSFreeMem : Procedure(p : Pointer); cdecl stdcall ;
  FreeEzERInfo : Procedure(var p : PEzERInfo) cdecl stdcall ;
  setValues : Procedure(p : PEzERInfo) cdecl stdcall ;
  getERS_error_text: function(): PChar cdecl stdcall;

implementation

Uses
  EzConsts, EzSystem, EzGraphics, Types;

Procedure LoadERMapperDll;
Begin
  HandleERMapperDll := LoadLibrary('ERDll.dll');
  If HandleERMapperDll > 32 Then
  Begin
    ERMapperDllLoaded := True;
    @GetImage := GetProcAddress(HandleERMapperDll, 'getImage');
    Assert( @GetImage <> Nil) ;
    @GetEzERInfo := GetProcAddress(HandleERMapperDll, 'getEzERInfo');
    Assert( @GetEzERInfo <> Nil) ;
    @ERSFreeMem := GetProcAddress(HandleERMapperDll, 'ERSFreeMem');
    Assert( @getEzERInfo <> Nil) ;
    @FreeEzERInfo := GetProcAddress(HandleERMapperDll, 'freeEzERInfo');
    Assert(@FreeEzERInfo <> Nil);
    @setValues := GetProcAddress(HandleERMapperDll, 'setValues');
    Assert(@setValues <> Nil);
    @getERS_error_text := GetProcAddress(HandleERMapperDll, 'getERS_error_text');
    Assert(@getERS_error_text <> Nil);
  End Else
    ERMapperDllLoaded := False;
End;

Constructor TEzERMapper.CreateEntity( Const P1, P2: TEzPoint;
  Const aFileName: String );
Begin
  Inherited CreateEntity( [P1, P2], False );
  FileName := aFileName;
End;

Destructor TEzERMapper.Destroy;
Begin
  FDecompressor.Free;
  FVector.Free;
  Inherited Destroy;
End;

Procedure TEzERMapper.Initialize;
begin
  inherited;
  FVector := TEzVector.Create( 5 );
  FDecompressor := TEcwDecompressor.Create(nil);
{  try
    FDecompressor.FileName := FFileName;
  except
    
  end;  }
end;

Function TEzERMapper.BasicInfoAsString: string;
Begin
  Result:= Format(sERMapperInfo, [FPoints.AsString,FFileName,FAlphaChannel]);
End;

Function TEzERMapper.GetEntityID: TEzEntityID;
Begin
  result := idERMapper;
End;

{$IFDEF BCB}
function TEzERMapper.GetAlphaChannel: byte;
begin
  Result := FAlphaChannel;
end;

function TEzERMapper.GetFileName: String;
begin
  Result := FFileName;
end;

procedure TEzERMapper.SetAlphaChannel(const Value: byte);
begin
  FAlphaChannel := Value;
end;

procedure TEzERMapper.SetFileName(const Value: String);
begin
  FFileName := Value;
end;
{$ENDIF}

Function TEzERMapper.GetControlPoints(TransfPts: Boolean; Grapher: TEzGrapher=Nil): TEzVector;
Var
  TmpR: TEzRect;
  Movept: TEzPoint;
Begin
  Result := TEzVector.Create( 8 );
  TmpR.Emin := FPoints[0];
  TmpR.Emax := FPoints[1];
  TmpR := ReorderRect2D( TmpR );
  With Result Do
  Begin
    Add( TmpR.Emin ); // LOWER LEFT
    AddPoint( ( TmpR.Emin.X + TmpR.Emax.X ) / 2, TmpR.Emin.Y ); // MIDDLE BOTTOM
    AddPoint( TmpR.Emax.X, TmpR.Emin.Y ); // LOWER RIGHT
    AddPoint( TmpR.Emax.X, ( TmpR.Emin.Y + TmpR.Emax.Y ) / 2 ); // MIDDLE RIGHT
    Add( TmpR.Emax ); // UPPER RIGHT
    AddPoint( ( TmpR.Emin.X + TmpR.Emax.X ) / 2, TmpR.Emax.Y ); // MIDDLE TOP
    AddPoint( TmpR.Emin.X, TmpR.Emax.Y ); // UPPER LEFT
    AddPoint( TmpR.Emin.X, ( TmpR.Emin.Y + TmpR.Emax.Y ) / 2 ); // MIDDLE LEFT
    if TransfPts then
    begin
      // the move control point
      MovePt.X := ( TmpR.Emin.X + TmpR.Emax.X ) / 2;
      MovePt.Y := ( TmpR.Emin.Y + TmpR.Emax.Y ) / 2;
      AddPoint( MovePt.X, MovePt.Y );
    end;
  End;
End;

Function TEzERMapper.GetControlPointType( Index: Integer ): TEzControlPointType;
Begin
  If Index = 8 Then
    Result := cptMove
  Else
    Result := cptNode;
End;

Procedure TEzERMapper.UpdateControlPoint( Index: Integer; Const Value: TEzPoint; Grapher: TEzGrapher=Nil );
Var
  TmpR: TEzRect;
  Movept: TEzPoint;
  M: TEzMatrix;
Begin
  FPoints.DisableEvents := True;
  Try
    TmpR.Emin := FPoints[0];
    TmpR.Emax := FPoints[1];
    TmpR := ReorderRect2D( TmpR );
    Case Index Of
      0: // LOWER LEFT
        Begin
          TmpR.Emin := Value;
        End;
      1: // MIDDLE BOTTOM
        Begin
          TmpR.Emin.Y := Value.Y;
        End;
      2: // LOWER RIGHT
        Begin
          TmpR.Emax.X := Value.X;
          TmpR.Emin.Y := Value.Y;
        End;
      3: // MIDDLE RIGHT
        Begin
          TmpR.Emax.X := Value.X;
        End;
      4: // UPPER RIGHT
        Begin
          TmpR.Emax := Value;
        End;
      5: // MIDDLE TOP
        Begin
          TmpR.Emax.Y := Value.Y;
        End;
      6: // UPPER LEFT
        Begin
          TmpR.Emin.X := Value.X;
          TmpR.Emax.Y := Value.Y;
        End;
      7: // MIDDLE LEFT
        Begin
          TmpR.Emin.X := Value.X;
        End;
      8: // MOVE POINT
        Begin
          // calculate current move point
          MovePt.X := ( TmpR.Emin.X + TmpR.Emax.X ) / 2;
          MovePt.Y := ( TmpR.Emin.Y + TmpR.Emax.Y ) / 2;
          M := Translate2d( Value.X - MovePt.X, Value.Y - MovePt.Y );
          TmpR.Emin := TransformPoint2d( TmpR.Emin, M );
          TmpR.Emax := TransformPoint2d( TmpR.Emax, M );
        End;
    End;
    FPoints[0] := TmpR.Emin;
    FPoints[1] := TmpR.Emax;
    UpdateExtension;
  Finally
    FPoints.DisableEvents := false;
  End;
End;

Function TEzERMapper.GetDrawPoints: TEzVector;
Begin
  Result := FVector;
End;

Procedure TEzERMapper.LoadFromStream( Stream: TStream );
Var
  Reserved: Array[0..49] Of byte;
Begin
  Inherited LoadFromStream( stream );
  With Stream Do
  Begin
    Read( FAlphaChannel, SizeOf( Byte ) );
    FFileName := EzReadStrFromStream( stream );
    //FDecompressor.FileName := FFileName;
    Read( Reserved, sizeof( Reserved ) );
  End;
  FPoints.CanGrow := false;
  UpdateExtension;
End;

Procedure TEzERMapper.SaveToStream( Stream: TStream );
Var
  Reserved: Array[0..49] Of byte;
Begin
  Inherited SaveToStream( Stream );
  With Stream Do
  Begin
    Write( fAlphaChannel, SizeOf( Byte ) );
    EzWriteStrToStream( FFileName, stream );
    Write( Reserved, sizeof( Reserved ) );
  End;
End;

procedure TEzERMapper.SetFileName(const Value: String);
begin
  if FFileName <> Value then
  begin
    FFileName := Value;
{    if Assigned(FDecompressor) then
    try
      FDecompressor.FileName := FFileName;
    except
    end;  }
  end;
end;

Function TEzERMapper.StorageSize: Integer;
Begin
  Result := Inherited StorageSize + Length( FFileName );
End;

Procedure TEzERMapper.Draw( Grapher: TEzGrapher; Canvas: TCanvas;
  Const Clip: TEzRect; DrawMode: TEzDrawMode; Data: Pointer = Nil );
Var
  BmpRect, Src, Dest: TRect;
  Work: TEzRect;
  fx, fy: Double;
  L, T, W, H, Y1, Y2: Integer;
  hPaintPal, hOldPal: HPalette;
  Pass: Boolean;

  BackgFormat: TPixelformat;
  scanlin: Pointer;
  p1_24, p2: pRGBTripleArray;
  p1_32: pRGBQuadArray;
  TmpBitmap: TBitmap;
  x, y, bgx, bgy, bgw, bgh: integer;
  BlendTable: Array[SMALLINT] Of Smallint;
  OldStyle: TPenStyle;
  Bmp: TBitmap;
  DestW, DestH: Integer;
  FullRect: TRect;
  PartBox: TRect;
  LPercent: Double;
  TPercent: Double;
  WPercent: Double;
  HPercent: Double;
  Stretched: Boolean;
  ERError: Boolean;
  ErrorText: string;
  R1, R2: TRect;
  W1, W2, H1, H2: Integer;
  aFnt: TFont;
  Sz: TSize;
Begin
  if not Assigned(Canvas) then
    Exit;
  If Not IsBoxInBox2D( FBox, Clip ) Then
    Exit;
  ERError := False;
  If DrawMode <> dmNormal Then
  Begin
    Oldstyle := Canvas.Pen.Style;
    If DrawMode = dmRubberpen Then
      Canvas.Pen.Style := psDot;
    FVector.DrawOpened( Canvas, Clip, FBox, Grapher, PenTool.FPenStyle, PenTool.Scale,
      Self.GetTransformMatrix, DrawMode );
    If DrawMode = dmRubberpen Then
      Canvas.Pen.Style := Oldstyle;
  End
  else
  begin
    FullRect := Grapher.RealToRect( FBox );

    If IsBoxFullInBox2D( FBox, Clip ) Then
      Work := FBox
    else
    begin
      // Calculate image rectangle
      Work := IntersectRect2D( FBox, Clip );
      If IsRectEmpty2D( Work ) Then
        Exit;
    end;
    PartBox := ReorderRect( Grapher.RealToRect( Work ) );

    if not ERError then
    begin
      if FDecompressor.FileName <> FFileName then
        try
          FDecompressor.FileName := FFileName;
        except
          ERError := True;
        end
      else
        ERError := FDecompressor.Error <> '';
    end;

    if not ERError then
    begin
      LPercent := Abs(FBox.xmin - Work.xmin) / (FBox.xmax - FBox.xmin);
      TPercent := (FBox.ymax - Work.ymax) / (FBox.ymax - FBox.ymin);
      WPercent := (Work.xmax - Work.xmin) / (FBox.xmax - FBox.xmin);
      HPercent := (Work.ymax - Work.ymin) / (FBox.ymax - FBox.ymin);

      BmpRect.Left := Trunc(LPercent * FDecompressor.Width);
      BmpRect.Top := Trunc(TPercent * FDecompressor.Height);
      BmpRect.Right := BmpRect.Left + Trunc(WPercent * FDecompressor.Width) - 1;
      BmpRect.Bottom := BmpRect.Top + Trunc(HPercent * FDecompressor.Height) - 1;

      with BmpRect do
      begin
        if Left < 0 then
          Left := 0
        else
          if Left >= FDecompressor.Width then
            Left := FDecompressor.Width - 1;
        if Right < 0 then
          Right := 0
        else
          if Right >= FDecompressor.Width then
            Right := FDecompressor.Width - 1;
        if Top < 0 then
          Top := 0
        else
          if Top >= FDecompressor.Height then
            Top := FDecompressor.Height - 1;
        if Bottom < 0 then
          Bottom := 0
        else
          if Bottom >= FDecompressor.Height then
            Bottom := FDecompressor.Height - 1;
      end;
      if IsRectEmpty(BmpRect) then
        Exit;

      if not FileExists(FFileName) then
        ERError := True;
      if not ERError then
      try
        Bmp := TBitmap.Create;
        try
          W1 := PartBox.Right - PartBox.Left;
          W2 := BmpRect.Right - BmpRect.Left;
          H1 := PartBox.Bottom - PartBox.Top;
          H2 := BmpRect.Bottom - BmpRect.Top;
          if (W1 > W2) or (H1 > H2) then
          begin
            Stretched := True;
            Bmp.Width := W2;
            Bmp.Height := H2;
          end
          else
          begin
            Bmp.Width := W1;
            Bmp.Height := H1;
          end;
          if (Bmp.Width = 0) and (Bmp.Height = 0) then
            Exit;
          //
          try
            FDecompressor.Decompress(Bmp, BmpRect);
          except
            ERError := True;
          end;

          if not ERError then
          begin
            SetStretchBltMode( Canvas.Handle, COLORONCOLOR );

            If FAlphaChannel > 0 Then
            Begin
              For x := -255 To 255 Do
                BlendTable[x] := ( FAlphaChannel * x ) Shr 8;
            End;

            Dest := PartBox;
            If Grapher.Device = adScreen Then
            Begin
              If FAlphaChannel <= 0 Then
                Canvas.StretchDraw( Dest, Bmp )
              Else
              Begin
                TmpBitmap := TBitmap.Create;
                Try
                  TmpBitmap.PixelFormat := pf24bit;
                  TmpBitmap.Width := succ( Dest.Right - Dest.Left );
                  TmpBitmap.Height := succ( Dest.Bottom - Dest.Top );
                  TmpBitmap.Canvas.StretchDraw( Rect( 0, 0, TmpBitmap.Width, TmpBitmap.Height ), Bmp );
                  bgw := BufferBitmap.Width;
                  bgh := BufferBitmap.Height;
                  BackgFormat := BufferBitmap.PixelFormat;
                  For y := 0 To TmpBitmap.Height - 1 Do
                  Begin
                    bgy := y + Dest.Top;
                    If ( bgy < 0 ) Or ( bgy > bgh - 1 ) Then Continue;

                    scanlin := BufferBitmap.ScanLine[bgy];
                    p1_24 := scanlin;
                    p1_32 := scanlin;
                    p2 := TmpBitmap.ScanLine[y];
                    For x := 0 To TmpBitmap.Width - 1 Do
                    Begin
                      bgx := x + Dest.Left;
                      If ( bgx < 0 ) Or ( bgx > bgw - 1 ) Then
                        Continue;
                      Case BackgFormat Of
                        pf24bit:
                          With p1_24^[bgx] Do
                          Begin
                            rgbtBlue := BlendTable[rgbtBlue - p2^[x].rgbtBlue] + p2^[x].rgbtBlue;
                            rgbtGreen := BlendTable[rgbtGreen - p2^[x].rgbtGreen] + p2^[x].rgbtGreen;
                            rgbtRed := BlendTable[rgbtRed - p2^[x].rgbtRed] + p2^[x].rgbtRed;
                          End;
                        pf32bit:
                          With p1_32^[bgx] Do
                          Begin
                            rgbBlue := BlendTable[rgbBlue - p2^[x].rgbtBlue] + p2^[x].rgbtBlue;
                            rgbGreen := BlendTable[rgbGreen - p2^[x].rgbtGreen] + p2^[x].rgbtGreen;
                            rgbRed := BlendTable[rgbRed - p2^[x].rgbtRed] + p2^[x].rgbtRed;
                          End;
                      End;
                    End;
                  End;
                Finally
                  TmpBitmap.free;
                End;
              End;
            End
            Else
              EzGraphics.PrintBitmapEx( Canvas, Dest, Bmp, Rect(0, 0, Bmp.Width, Bmp.Height) );
          end;
        Finally
          Bmp.Free;
        End;
      except
        try
          H := PartBox.Bottom - PartBox.Top;
          W := PartBox.Right - PartBox.Left;
          if H > 500 then
          begin
            Y1 := 0;
            while Y1 < (H - 1) do
            begin
              if (Y1 + 500) < H then
                Y2 := Y1 + 500
              else
                Y2 := H - 1;
              //
              R1 := Rect(PartBox.Left, PartBox.Top + Y1, PartBox.Right, PartBox.Top + Y2);
              R2 := BmpRect;
              TPercent := Y1 / (PartBox.Bottom - PartBox.Top);
              HPercent := (Y2 - Y1) / (PartBox.Bottom - PartBox.Top);
              R2.Top := BmpRect.Top + Round(TPercent * (BmpRect.Bottom - BmpRect.Top));
              R2.Bottom := R2.Top + Round(HPercent * (BmpRect.Bottom - BmpRect.Top));

              Bmp := TBitmap.Create;
              try
                Bmp.Width := R2.Right - R2.Left;
                Bmp.Height := R2.Bottom - R2.Top;
                if (Bmp.Width > (BmpRect.Right - BmpRect.Left)) or
                   (Bmp.Height > (BmpRect.Bottom - BmpRect.Top))
                then
                begin
                  Stretched := True;
                  Bmp.Width := BmpRect.Right - BmpRect.Left;
                  Bmp.Height := BmpRect.Bottom - BmpRect.Top;
                end;
                if (Bmp.Width <> 0) and (Bmp.Height <> 0) then
                try
                  ERError := False;
                  FDecompressor.Decompress(Bmp, R2);
                except
                  ERError := True;
                end;

                if not ERError then
                  EzGraphics.PrintBitmapEx(Canvas, R1, Bmp, Rect(0, 0, Bmp.Width, Bmp.Height));
              finally
                Bmp.Free;
              end;
              //
              Y1 := Y2;
            end;
          end
    //      FDecompressor.Decompress(Canvas, PartBox, BmpRect);
        except
          ERError := True;
        end;
      end;
    end;
  end;

  if ERError then
  begin
    Oldstyle := Canvas.Pen.Style;
    aFnt := TFont.Create;
    try
      aFnt.Assign(Canvas.Font);
      Canvas.Pen.Style := psSolid;
      Canvas.Pen.Color := clGray;
      FVector.DrawOpened( Canvas, Clip, FBox, Grapher, PenTool.FPenStyle,
        PenTool.Scale, Self.GetTransformMatrix, DrawMode );
      ErrorText := 'Îøèáêà' + #13#10 + FFileName;
      while Abs(Canvas.Font.Height) > 1 do
      begin
        Sz := Canvas.TextExtent(ErrorText);
        if (FullRect.Right - FullRect.Left) < Sz.cx then
          Canvas.Font.Height := Canvas.Font.Height - 1 * Sign(Canvas.Font.Height)
        else
          Break;
      end;
      Canvas.TextRect(FullRect, ErrorText, [tfCenter, tfVerticalCenter, tfWordBreak]);
    finally
      Canvas.Font.Assign(aFnt);
      Canvas.Pen.Style:= Oldstyle;
    end;
  end;
End;

Procedure TEzERMapper.UpdateExtension;
Begin
  Inherited UpdateExtension;
  If FPoints.Count <> 2 Then Exit;
  If FVector = Nil Then
    FVector := TEzVector.Create( 5 )
  Else
    FVector.Clear;
  With FVector Do
  Begin
    Add( FPoints[0] );
    Add( Point2D( FPoints[0].X, FPoints[1].Y ) );
    Add( FPoints[1] );
    Add( Point2D( FPoints[1].X, FPoints[0].Y ) );
    Add( FPoints[0] );
  End;
End;

function TEzERMapper.IsEqualTo(Entity: TEzEntity; IncludeAttribs: Boolean  = false): Boolean;
begin
  Result:= False;
  if Not ( Entity.EntityID = idERMapper ) Or
    ( Inherited IsEqualTo( Entity, IncludeAttribs ) = False )
    {$IFDEF FALSE}Or
    ( IncludeAttribs And ( FFileName <> TEzERMapper(Entity).FFileName ) ){$ENDIF} Then Exit;
  Result:= True;
end;

initialization

finalization
  If ERMapperDllLoaded Then
    FreeLibrary(HandleERMapperDll);

end.
