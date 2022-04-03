{***************************************************************************}
{  Date: 17.12.97                                            Time: 17:30:40 }
{  Copyright (c)1996-1997                                                   }
{  © by Dr.Plass                                                DanHint3.0  }
{                                                                           }
{                                                                           }
{  feel free to contact me:                                                 }
{  Peter.Plass@FH-Zwickau.de                                                }
{  http://www.fh-zwickau.de/~pp/tm.htm                                      }
{                                                                           }
{  All Rights Reserved.                                                     }
{  This component can be freely used and distributed in commercial and      }
{  private environments, provided this notice is not modified in any way.   }
{                                                                           }
{      based on Dan Ho's component DanHint v1.02 (4.5.96)                   }
{      --> danho@cs.nthu.edu.tw                                             }
{                                                                           }
{                                                                           }
{                                                                           }
{***************************************************************************}

Unit EzDanhint;

{$I EZ_FLAG.PAS}
Interface

//{$IFDEF WIN32}
//  {$R danhint.r32}
//{$ELSE}
//  {$R danhint.r16}
//{$ENDIF}

Uses
  SysUtils, Windows, Messages, Classes, Graphics, Controls, Forms;

Type
  THintDirection = ( hdUpRight, hdUpLeft, hdDownRight, hdDownLeft );
  TOnSelectHintDirection = Procedure( HintControl: TControl;
    Var HintDirection: THintDirection ) Of Object;

  TDanHint = Class( TComponent )
  Private
    FHintDirection: THintDirection;
    FHintColor: TColor;
    FHintShadowColor: TColor;
    FHintFont: TFont;
    FHintPauseTime: Integer;
    FRound: Integer;
    FAbout: String;
    FActive: Boolean;
    FDepth: Integer;
    FOnSelectHintDirection: TOnSelectHintDirection;

    Procedure SetShowHint( Value: Boolean );
    Procedure SetHintDirection( Value: THintDirection );
    Procedure SetHRound( Value: Integer );
    Procedure SetHActive( Value: Boolean );
    Procedure SetHDepth( Value: Integer );
    Procedure SetHintColor( Value: TColor );
    Procedure SetHintShadowColor( Value: TColor );
    Procedure SetHintFont( Value: TFont );
    Procedure CMFontChanged( Var Message: TMessage ); Message CM_FONTCHANGED;
    Procedure SetHintPauseTime( Value: Integer );
  Public
    Constructor Create( AOwner: TComponent ); Override;
    Destructor Destroy; Override;
    Procedure Loaded; Override;
    Procedure SetNewHintFont;

    Property HintDirection: THintDirection Read FHintDirection Write SetHintDirection Default hdUpRight;
    Property HintColor: TColor Read FHintColor Write SetHintColor Default clYellow;
    Property HintShadowColor: TColor Read FHintShadowColor Write SetHintShadowColor Default clPurple;
    Property HintRadius: Integer Read FRound Write SetHRound Default 9;
    Property HintWidth: Integer Read FDepth Write SetHDepth Default 100;
    Property HintActive: Boolean Read FActive Write SetHActive Default False;
    Property HintFont: TFont Read FHintFont Write SetHintFont;
    Property HintPauseTime: Integer Read FHintPauseTime Write SetHintPauseTime Default 1200;
    Property OnSelectHintDirection: TOnSelectHintDirection Read FOnSelectHintDirection Write FOnSelectHintDirection;
  End;

  TNewHint = Class( THintWindow )
  Private
    FDanHint: TDanHint;
    FHintDirection: THintDirection;

    Procedure SelectProperHintDirection( ARect: TRect );
    Procedure CheckUpRight( Spot: TPoint );
    Procedure CheckUpLeft( Spot: TPoint );
    Procedure CheckDownRight( Spot: TPoint );
    Procedure CheckDownLeft( Spot: TPoint );
  Protected
    Function BetweenToken( Var S: String; Sep: Char ): String;
    Function FindToken( Var S: String; Sep: Char ): String;
    Function TokenCount( S: String; Sep: Char ): Integer;
    Procedure Paint; Override;
    Procedure CreateParams( Var Params: TCreateParams ); Override;
  Public
    Constructor Create( AOwner: TComponent ); Override;
    Destructor Destroy; Override;
    Procedure ActivateHint( Rect: TRect; Const AHint: String ); Override;
    Property HintDirection: THintDirection Read FHintDirection Write FHintDirection Default hdUpRight;
    Property DanHint: TDanHint Read FDanHint;

  End;

  //procedure Register;

Implementation

uses
  EzSystem;
  
Const
  SHADOW_WIDTH = 6;
  N_PIXELS = 2; {frei zwischen cursor und hint}
Var
  MemBmp: TBitmap;
  UpRect, DownRect: TRect;
  SelectHintDirection: THintDirection;
  ShowPos: TPoint;
  HRound: Integer;
  HActive: Boolean;
  HDepth: Integer;

Procedure TDanHint.SetNewHintFont;
Var
  I: Integer;
Begin
  For I := 0 To Application.ComponentCount - 1 Do
    If Application.Components[I] Is TNewHint Then
    Begin
      TNewHint( Application.Components[I] ).Canvas.Font.Assign( FHintFont );
      Exit;
    End;
End;

Constructor TDanHint.Create( AOwner: TComponent );
Begin
  Inherited Create( AOwner );
  FHintDirection := hdUpRight;
  FHintColor := clYellow;
  FHintShadowColor := clPurple;
  {Application.HintPause:=FHintPauseTime;}
  FHintFont := EzSystem.DefaultFont;
  FHintPauseTime := 1000;
  FDepth := 250;
  HDepth := FDepth;
  FRound := 18;
  HRound := FRound;
  HActive := FActive;
  FHintFont.Size := 8;
  FHintFont.Color := clBlack;
  FHintFont.Pitch := fpDefault;
  FHintFont.Style := FHintFont.Style + [fsItalic];
  fAbout := '';
  SetShowHint( HActive );
End;

Destructor TDanHint.Destroy;
Begin
  FHintFont.Free;
  Inherited Destroy;
End;

Procedure TDanHint.Loaded;
Begin
  Inherited Loaded;
  SetShowHint( FActive );
End;

Procedure TDanHint.SetHintDirection( Value: THintDirection );
Begin
  If Value <> FHintDirection Then
    FHintDirection := Value;
End;

Procedure TDanHint.SetHRound( Value: Integer );
Begin
  If Value <> HRound Then
  Begin
    FRound := Value;
    HRound := FRound;
  End;
End;

Procedure TDanHint.SetHActive( Value: Boolean );
Begin
  FActive := Value;
  HActive := FActive;
  SetShowHint( FActive );
End;

Procedure TDanHint.SetShowHint( Value: Boolean );
Begin
  If ( csDesigning In ComponentState ) Then Exit;
  {if Value then HintWindowClass :=TNewHint
  else          HintWindowClass :=THintWindow;
  Application.ShowHint:=not Application.ShowHint;
  Application.ShowHint:=not Application.ShowHint;}
  SetNewHintFont;
End;

Procedure TDanHint.SetHintColor( Value: TColor );
Begin
  If Value <> FHintColor Then
    FHintColor := Value;
End;

Procedure TDanHint.SetHintShadowColor( Value: TColor );
Begin
  If Value <> FHintShadowColor Then
    FHintShadowColor := Value;
End;

Procedure TDanHint.SetHintFont( Value: TFont );
Begin
  FHintFont.Assign( Value );
  SetShowHint( FActive );
End;

Procedure TDanHint.CMFontChanged( Var Message: TMessage );
Begin
  Inherited;
  SetShowHint( FActive );
End;

Procedure TDanHint.SetHDepth( Value: Integer );
Begin
  If Value <> FDepth Then
  Begin
    If Value > 300 Then
      Value := 300;
    FDepth := Value;
    hDepth := FDepth;
  End;
End;

Procedure TDanHint.SetHintPauseTime( Value: Integer );
Begin
  If Value <> FHintPauseTime Then
  Begin
    FHintPauseTime := Value;
    {Application.HintPause:=Value;}
  End;
End;

Constructor TNewHint.Create( AOwner: TComponent );
Begin
  Inherited Create( AOwner );
  ControlStyle := ControlStyle - [csOpaque];
  With Canvas Do
  Begin
    Brush.Style := bsClear;
    Brush.Color := clBackground;
    {Application.HintColor:=clBackground;}
  End;
  FHintDirection := hdUpRight;
  FDanHint := TDanHint.Create( Nil );
End;

Destructor TNewHint.Destroy;
Begin
  FDanHint.Free;
  Inherited Destroy;
End;

Procedure TNewHint.CreateParams( Var Params: TCreateParams );
Begin
  Inherited CreateParams( Params );
  With Params Do
  Begin
    Style := WS_POPUP Or WS_DISABLED {or WS_BORDER};
    {Add the above makes the beneath window overlap hint}
    WindowClass.Style := WindowClass.Style Or CS_SAVEBITS;
  End;
End;

Procedure TNewHint.Paint;
Var
  R: TRect;
  CCaption: Array[0..255] Of Char;
  FillRegion,
    ShadowRgn: HRgn;
  AP: Array[0..2] Of TPoint; {Points of the Arrow }
  SP: Array[0..2] Of TPoint; {Points of the Shadow}
  X, Y: Integer;
  AddNum: Integer; {Added num for hdDownXXX }
Begin
  If ( FDanHint = Nil ) Or ( MemBmp = Nil ) Then
    Exit;
  R := ClientRect; {R is for Text output}
  inc( R.Left, 8 );
  inc( R.Top, 3 );

  AddNum := 0;
  If FHintDirection >= hdDownRight Then
    AddNum := 15;
  Inc( R.Top, AddNum );

  Case HintDirection Of
    hdUpRight:
      Begin
        AP[0] := Point( 10, Height - 15 );
        AP[1] := Point( 20, Height - 15 );
        AP[2] := Point( 0, Height );

        SP[0] := Point( 12, Height - 15 );
        SP[1] := Point( 25, Height - 15 );
        SP[2] := Point( 12, Height );
      End;
    hdUpLeft:
      Begin
        AP[0] := Point( Width - SHADOW_WIDTH - 20, Height - 15 );
        AP[1] := Point( Width - SHADOW_WIDTH - 10, Height - 15 );
        AP[2] := Point( Width - SHADOW_WIDTH, Height );

        SP[0] := Point( Width - SHADOW_WIDTH - 27, Height - 15 );
        SP[1] := Point( Width - SHADOW_WIDTH - 5, Height - 15 );
        SP[2] := Point( Width - SHADOW_WIDTH, Height );
      End;
    hdDownRight:
      Begin
        AP[0] := Point( 10, 15 );
        AP[1] := Point( 20, 15 );
        AP[2] := Point( 0, 0 );

        { for hdDownXXX, SP not used now }
        SP[0] := Point( 12, Height - 15 );
        SP[1] := Point( 25, Height - 15 );
        SP[2] := Point( 12, Height );
      End;
    hdDownLeft:
      Begin
        AP[0] := Point( Width - SHADOW_WIDTH - 20, 15 );
        AP[1] := Point( Width - SHADOW_WIDTH - 10, 15 );
        AP[2] := Point( Width - SHADOW_WIDTH, 0 );

        { for hdDownXXX, SP not used now }
        SP[0] := Point( 12, Height - 15 );
        SP[1] := Point( 25, Height - 15 );
        SP[2] := Point( 12, Height );
      End;
  End;

  {Draw Shadow of the Hint Rect}
  If ( FHintDirection <= hdUpLeft ) Then
  Begin
    ShadowRgn := CreateRoundRectRgn( 10, 8, Width, Height - 8, HRound - 1, HRound - 1 );
    For X := Width - SHADOW_WIDTH - 8 To Width Do
      For Y := 8 To Height - 14 Do
      Begin
        If ( Odd( X ) = Odd( Y ) ) And PtInRegion( ShadowRgn, X, Y ) Then
          MemBmp.Canvas.Pixels[X, Y] := FDanHint.HintShadowColor;
      End;
    For X := 10 To Width Do
      For Y := Height - 14 To Height - 9 Do
      Begin
        If ( Odd( X ) = Odd( Y ) ) And PtInRegion( ShadowRgn, X, Y ) Then
          MemBmp.Canvas.Pixels[X, Y] := FDanHint.HintShadowColor;
      End;

  End
  Else
  Begin { for hdDownXXX }
    ShadowRgn := CreateRoundRectRgn( 10, 8 + 15, Width, Height - 2, HRound - 1, HRound - 1 );
    For X := Width - SHADOW_WIDTH - 8 To Width Do
      For Y := 8 + 15 To Height - 8 Do
      Begin
        If ( Odd( X ) = Odd( Y ) ) And PtInRegion( ShadowRgn, X, Y ) Then
          MemBmp.Canvas.Pixels[X, Y] := FDanHint.HintShadowColor;
      End;
    For X := 10 To Width Do
      For Y := Height - 8 To Height - 2 Do
      Begin
        If ( Odd( X ) = Odd( Y ) ) And PtInRegion( ShadowRgn, X, Y ) Then
          MemBmp.Canvas.Pixels[X, Y] := FDanHint.HintShadowColor;
      End;
  End;
  DeleteObject( ShadowRgn );

  { Draw the shadow of the arrow }
  If ( HintDirection <= hdUpLeft ) Then
  Begin
    ShadowRgn := CreatePolygonRgn( SP, 3, WINDING );
    For X := SP[0].X To SP[1].X Do
      For Y := SP[0].Y To SP[2].Y Do
      Begin
        If ( Odd( X ) = Odd( Y ) ) And PtInRegion( ShadowRgn, X, Y ) Then
          MemBmp.Canvas.Pixels[X, Y] := FDanHint.HintShadowColor;
      End;
    DeleteObject( ShadowRgn );
  End;

  { Draw HintRect }
  MemBmp.Canvas.Pen.Color := clBlack;
  MemBmp.Canvas.Pen.Style := psSolid;
  MemBmp.Canvas.Brush.Color := FDanHint.HintColor;
  MemBmp.Canvas.Brush.Style := bsSolid;
  If ( FHintDirection <= hdUpLeft ) Then
    MemBmp.Canvas.RoundRect( 0, 0, Width - SHADOW_WIDTH, Height - 14, HRound, HRound )
  Else
    MemBmp.Canvas.RoundRect( 0, 0 + AddNum, Width - SHADOW_WIDTH, Height - 14 + 6, HRound, HRound );

  { Draw Hint Arrow }
  MemBmp.Canvas.Pen.Color := FDanHint.HintColor;
  MemBmp.Canvas.MoveTo( AP[0].X, AP[0].Y );
  MemBmp.Canvas.LineTo( AP[1].X, AP[1].Y );
  MemBmp.Canvas.Pen.Color := clBlack;
  FillRegion := CreatePolygonRgn( AP, 3, WINDING );
  FillRgn( MemBmp.Canvas.Handle, FillRegion, MemBmp.Canvas.Brush.Handle );
  DeleteObject( FillRegion );
  MemBmp.Canvas.LineTo( AP[2].X, AP[2].Y );
  MemBmp.Canvas.LineTo( AP[0].X, AP[0].Y );

  {SetBkMode makes DrawText's text be transparent }

  SetBkMode( MemBmp.Canvas.Handle, TRANSPARENT );
  MemBmp.Canvas.Font.Assign( FDanHint.HintFont );
  DrawText( MemBmp.Canvas.Handle, StrPCopy( CCaption, Caption ), -1, R,
    DT_LEFT Or DT_NOPREFIX Or DT_WORDBREAK );
  Canvas.CopyMode := cmSrcCopy;
  Canvas.CopyRect( ClientRect, MemBmp.Canvas, ClientRect );
  MemBmp.Free;
  MemBmp := Nil;
End;

Procedure TNewHint.CheckUpLeft( Spot: TPoint );
Var
  Width, Height: Integer;
Begin
  Dec( Spot.Y, N_PIXELS );
  Width := UpRect.Right - UpRect.Left;
  Height := UpRect.Bottom - UpRect.Top;
  SelectHintDirection := hdUpLeft;
  If ( Spot.X + SHADOW_WIDTH - Width ) < 0 Then
  Begin
    Inc( Spot.Y, N_PIXELS ); {back tp original}
    CheckUpRight( Spot );
    Exit;
  End;
  If ( Spot.Y - Height ) < 0 Then
  Begin
    Inc( Spot.Y, N_PIXELS );
    CheckDownLeft( Spot );
    Exit;
  End;
  ShowPos.X := Spot.X + SHADOW_WIDTH - Width;
  ShowPos.Y := Spot.Y - Height;
End;

Procedure TNewHint.CheckUpRight( Spot: TPoint );
Var
  Width, Height: Integer;
Begin
  Dec( Spot.Y, N_PIXELS );
  Width := UpRect.Right - UpRect.Left;
  Height := UpRect.Bottom - UpRect.Top;
  SelectHintDirection := hdUpRight;
  If ( Spot.X + Width ) > Screen.Width Then
  Begin
    Inc( Spot.Y, N_PIXELS );
    CheckUpLeft( Spot );
    Exit;
  End;
  If ( Spot.Y - Height ) < 0 Then
  Begin
    Inc( Spot.Y, N_PIXELS );
    CheckDownRight( Spot );
    Exit;
  End;
  ShowPos.X := Spot.X;
  ShowPos.Y := Spot.Y - Height;
End;

Procedure TNewHint.CheckDownRight( Spot: TPoint );
Var
  Width, Height: Integer;
Begin
  Inc( Spot.Y, N_PIXELS * 3 );
  Width := DownRect.Right - DownRect.Left;
  Height := DownRect.Bottom - DownRect.Top;
  SelectHintDirection := hdDownRight;
  If ( Spot.X + Width ) > Screen.Width Then
  Begin
    Dec( Spot.Y, N_PIXELS * 3 );
    CheckDownLeft( Spot );
    Exit;
  End;
  If ( Spot.Y + Height ) > Screen.Height Then
  Begin
    Dec( Spot.Y, N_PIXELS * 3 );
    CheckUpRight( Spot );
    Exit;
  End;
  ShowPos.X := Spot.X;
  ShowPos.Y := Spot.Y;
End;

Procedure TNewHint.CheckDownLeft( Spot: TPoint );
Var
  Width, Height: Integer;
Begin
  Inc( Spot.Y, N_PIXELS * 3 );
  Width := DownRect.Right - DownRect.Left;
  Height := DownRect.Bottom - DownRect.Top;
  SelectHintDirection := hdDownLeft;
  If ( Spot.X + SHADOW_WIDTH - Width ) < 0 Then
  Begin
    Dec( Spot.Y, N_PIXELS * 3 );
    CheckDownRight( Spot );
    Exit;
  End;
  If ( Spot.Y + Height ) > Screen.Height Then
  Begin
    Dec( Spot.Y, N_PIXELS * 3 );
    CheckUpLeft( Spot );
    Exit;
  End;
  ShowPos.X := Spot.X + SHADOW_WIDTH - Width;
  ShowPos.Y := Spot.Y;
End;

Procedure TNewHint.SelectProperHintDirection( ARect: TRect );
Var
  Spot: TPoint;
  OldHintDirection,
    SendHintDirection: THintDirection;
  HintControl: TControl;
Begin
  If ( FDanHint = Nil ) Then
    Exit;
  GetCursorPos( Spot );
  HintCOntrol := FindDragTarget( Spot, True );
  Inc( ARect.Right, 10 + SHADOW_WIDTH );
  Inc( ARect.Bottom, 20 );
  UpRect := ARect;
  Inc( ARect.Bottom, 9 );
  DownRect := ARect;
  OldHintDirection := FDanHint.HintDirection;
  SendHintDirection := FDanHint.HintDirection;

  {Tricky, why here can't use FDanHint.OnSe...? }
  If Assigned( FDanHint.FOnSelectHintDirection ) Then
  Begin
    FDanHint.FOnSelectHintDirection( HintControl, SendHintDirection );
    FDanHint.HintDirection := SendHintDirection;
  End;
  Case FDanHint.HintDirection Of
    hdUpRight: CheckUpRight( Spot );
    hdUpLeft: CheckUpLeft( Spot );
    hdDownRight: CheckDownRight( Spot );
    hdDownLeft: CheckDownLeft( Spot );
  End;
  FDanHint.HintDirection := OldHintDirection;
End;

Function TNewHint.FindToken( Var S: String; Sep: Char ): String;
Var {S. rechts nach token Result.links vor}
  I: Word;
Begin
  I := AnsiPos( Sep, S );
  If I <> 0 Then
  Begin
    Result := Copy( S, 1, I - 1 );
    Delete( S, 1, I );
  End
  Else
  Begin
    Result := S;
    S := '';
  End;
End;

Function TNewHint.BetweenToken( Var S: String; Sep: Char ): String;
Var
  Token: String;
Begin
  Token := FindToken( S, Sep );
  Result := FindToken( S, Sep );
End;

Function TNewHint.TokenCount( S: String; Sep: Char ): Integer;
Begin
  Result := 0;
  While S <> '' Do
  Begin
    FindToken( S, Sep );
    inc( Result );
  End;
  dec( Result );
End;

Procedure TNewHint.ActivateHint( Rect: TRect; Const AHint: String );
Var
  ScreenDC: HDC;
  LeftTop: TPoint;
  tmpWidth,
    i, temp,
    old, z, t,
    new, korr,
    tmpHeight: Integer;
  s2: String;
  s: TStringList;
Begin

  //if NOT HActive then exit;
  If hDepth > 300 Then
    hDepth := 300;
  MemBmp := TBitmap.Create;
  Caption := AHint;
  s := TStringList.Create;
  s2 := ' ' + AHint;

  With Rect Do
  Begin
    tmpWidth := Right - Left;
    tmpHeight := Bottom - Top;

    i := Canvas.TextHeight( AHint );
    korr := round( tmpHeight / i ) - 1;
    dec( korr, TokenCount( AHint, #13 ) );

    If ( tmpWidth ) > hDepth Then
    Begin
      caption := '**';
      i := 0;
      While ( caption <> '' ) Do
      Begin
        caption := BetweenToken( s2, ' ' );
        If s2 <> ' ' Then
          s2 := ' ' + s2;
        If caption <> '' Then
        Begin
          s.add( caption );
          inc( i );
        End;
      End;

      old := 0;
      temp := 0;
      For z := 0 To i - 1 Do
      Begin
        temp := Canvas.TextWidth( s.strings[z] ) + 6;
        If temp > old Then
          old := temp;
      End;
      If temp > hDepth Then
        temp := old
      Else
        temp := hDepth;

      old := -1;
      new := 0;
      z := 0;
      While z < i Do
      Begin
        s2 := s.strings[z];
        t := z + 1;

        While ( Canvas.TextWidth( s2 ) <= ( temp - 6 ) ) And ( t < i ) Do
        Begin
          s2 := s2 + ' ' + s[t];
          inc( t )
        End;

        If ( t > z + 1 ) And ( t <= i ) And ( Canvas.TextWidth( s2 ) > ( temp - 6 ) ) Then
        Begin
          Delete( s2, AnsiPos( s[t - 1], s2 ) - 1, length( s[t - 1] ) + 1 );
          z := t - 2;
          dec( t );
        End;
        caption := caption + s2;
        If ( ( z < i - 1 ) And ( t < i ) ) Then
          caption := caption + #13;
        If Canvas.TextWidth( s2 ) + 6 > new Then
          new := Canvas.TextWidth( s2 ) + 6;
        inc( old );
        If ( z >= i - 1 ) Or ( t >= i ) Then
          break;
        inc( z );
      End;

      s.Free;
      Right := Left + new + 6;
      INC( Bottom, ( old - korr ) * Canvas.TextHeight( AHint ) );
    End; {there's no reason to do}
  End; {with rect}

  {add by Dan from Here }
  //FDanHint:=FindDanHint;
  SelectProperHintDirection( Rect );
  HintDirection := SelectHintDirection;

  {if the following changes, make sure to modify
   SelectProperHintDirection also}
  Inc( Rect.Right, 10 + SHADOW_WIDTH );
  Inc( Rect.Bottom, 20 );
  If ( FHintDirection >= hdDownRight ) Then
    Inc( Rect.Bottom, 9 );

  {to expand the rect}
  tmpWidth := Rect.Right - Rect.Left;
  tmpHeight := Rect.Bottom - Rect.Top;
  Rect.Left := ShowPos.X;
  Rect.Top := ShowPos.Y;
  Rect.Right := Rect.Left + tmpWidth;
  Rect.Bottom := Rect.Top + tmpHeight;
  BoundsRect := Rect;

  MemBmp.Width := Width;
  MemBmp.Height := Height;

  ScreenDC := CreateDC( 'DISPLAY', Nil, Nil, Nil );
  LeftTop.X := 0;
  LeftTop.Y := 0;
  LeftTop := ClientToScreen( LeftTop );
  {use MemBmp to store the original bitmap on screen }
  BitBlt( MemBmp.Canvas.Handle, 0, 0, Width, Height, ScreenDC, LeftTop.X, LeftTop.Y, SRCCOPY );
  {SetBkMode(Canvas.Handle,TRANSPARENT);}
  SetWindowPos( Handle, HWND_TOPMOST, ShowPos.X, ShowPos.Y, 0, 0, SWP_SHOWWINDOW Or SWP_NOACTIVATE Or SWP_NOSIZE );
  BitBlt( Canvas.Handle, 0, 0, Width, Height, MemBmp.Canvas.Handle, 0, 0, SRCCOPY );
  DeleteDC( ScreenDC );
End;

End.
