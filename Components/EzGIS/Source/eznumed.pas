Unit EzNumEd;

{***********************************************************}
{     EzGIS/CAD Components                                  }
{   (c) 2002 EzSoft Engineering                             }
{         All Rights Reserved                               }
{***********************************************************}

{$I EZ_FLAG.PAS}
Interface

Uses
  SysUtils, Windows, Messages, Classes, Graphics, Controls, Forms, Menus,
  Ezbase
{$IFNDEF BCB}
  , DB, DBCtrls
{$ENDIF}
  ;

const
  neEditBorderSize = 2;
  neEditShadowSize = 2;

Type

{  Numeric edit control descentand of TCustomControl.
   Key properties:

   TEzNumEd.NumericValue.- Is the numeric value to edit.

   TEzNumEd.EditFormat .- The format used when the control is in focus
     TEzNumEd.Digits is the number of allowed integer digits
     TEzNumEd.Decimals is the number of allowed decimals
     TEzNumEd.UseThousandSeparator define if thousand separator is used
        The thousand separator is taken from global var ThousandSeparator
     TEzNumEd.EditFormat.LeftInfo is any string info shown to the left when editing
        Example, you can add something like "$" to this property and the numeric
          edit control will show a fixed currency symbol to the left.
        One special code is implemented in this version: if you define this property to
        "\c", then this code will be replaced by the currency symbol as is defined in global
        var CurrencyString
     TEzNumEd.EditFormat.RightInfo same as previous, but the string placed here will be
        shown to the right of the numeric value. You can place here something like:
        "Dlls." and when you edit the numeric value will be shown something like this:
        $123,456.78 Dlls.  Here LeftInfo = "\c", or "$" and RightInfo = " Dlls."
     TEzNumEd.EditFormat.NegColor is the color when the numeric value is negative

   TEzNumEd.DisplayFormat.- The format used when the control is out of focus
     same as EditFormat but with three more properties:
     TEzNumEd.DisplayFormat.Show defines if the numeric value is shown when not in focus
     TEzNumEd.DisplayFormat.ZeroValue .-You define here the string you want to show when
        the numericvalue is zero, example "Zero". If you left blank, then a "0" will be used
        Default is blank
    TEzNumEd.DisplayFormat.NegUseParens.- If true, then instead of showing the
        "-" char for negative values, the numeric value will be enclosed in "()" pair.

    TEzNumEd.TabOnEnterKey.- If set to true, when you press enter will be as if
       you pressed the TAB key
    TEzNumEd.Modified.- Indicates if the numeric value was edited.
    TEzNumEd.ReadOnly.- If true, the numeric value cannot be edited.
    TEzNumEd.AcceptNegatives.- If true, end user can type negative values
    TEzNumEd.WidthPad, TEzNumEd.HeightPad.- Is a blank area to the left or right
       of the numeric value inside the control

}


  TEzNumEd = Class;

  TEzEditFormat = class(TPersistent)
  private
    FNumEd: TEzNumEd;
    { the following codes applies:
      - \C = the currency string
      - any literal is displayed as is, like $
    }
    FLeftInfo: string;
    FRightInfo: string;
    procedure InvalidateEditor;
    procedure SetLeftInfo(const Value: string);
    procedure SetRightInfo(const Value: string);
  public
    constructor Create(NumEd: TEzNumEd);
    procedure Assign(Source: TPersistent); Override;
  published
    property LeftInfo: string read FLeftInfo write SetLeftInfo;
    property RightInfo: string read FRightInfo write SetRightInfo;
  end;

  TEzDisplayFormat = class(TEzEditFormat)
  private
    FShow: Boolean;
    FZeroValue: String;
    FNegUseParens: Boolean;
    procedure SetShow(const Value: Boolean);
    procedure SetNegUseParens(const Value: Boolean);
    procedure SetZeroValue(const Value: String);
  {$IFDEF BCB}
    function GetNegUseParens: Boolean;
    function GetShow: Boolean;
    function GetZeroValue: String;
  {$ENDIF}
  public
    constructor Create(NumEd: TEzNumEd);
    procedure Assign(Source: TPersistent); Override;
  published
    property Show: Boolean {$IFDEF BCB} read GetShow {$ELSE} read FShow {$ENDIF} write SetShow default True;
    property ZeroValue: String {$IFDEF BCB} read GetZeroValue {$ELSE} read FZeroValue {$ENDIF} write SetZeroValue;
    property NegUseParens: Boolean {$IFDEF BCB} read GetNegUseParens {$ELSE} read FNegUseParens {$ENDIF} write SetNegUseParens default False;
  end;

  { TEzNumEdit control }
  TEzBorderStyle = (ebsNone, ebsSingle, ebsThick, ebsFlat, ebs3D);

  TEzPartEditing = ( peInteger, peDecimal );

  TEzNumEd = Class( TCustomControl )
  Private
    FDigits: Integer;
    FDecimals: Integer;
    FUseThousandSeparator: Boolean;
    FNegColor: TColor;
    FNumericValue: extended;
    FOriginalValue: extended;
    FAcceptNegatives: boolean;
    FEditFormat: TEzEditFormat;
    FDisplayFormat: TEzDisplayFormat;
    FCaretBm: TBitmap;
    FSelStart: integer;
    FPartEditing: TEzPartEditing;
    FTabOnEnterKey: boolean;
    FModified: boolean;
    FNegFlag: boolean;
    FLastKey: char;
    FOnChange: TNotifyEvent;
    FReadOnly: boolean;
    FSelected: boolean;
    FMouseDown: boolean;
    FHotTrack: Boolean;
    //[KT] - added 12/06/01, FWidthPad, FHeightPad
    FHeightPad: Integer;
    FWidthPad: Integer;
    FDecimalSeparator: Char;
    FThousandSeparator: Char;
    FUseWindowsSeparator: Boolean;
    FMouseInControl: Boolean;
    FShadowed: Boolean;
    FShadowColor: TColor;
    FShadowWidth: Integer;
    FBorderColor: TColor;
    FBorderSize: Integer;
    FBorderStyle: TEzBorderStyle;
    FDrawTextRect: TRect;

    Procedure SetBorderStyle(Value: TEzBorderStyle);
    Procedure SetBorderSize( Value: Integer );
    Procedure SetBorderColor(Value: TColor);
    procedure SetUseThousandSeparator(const Value: Boolean);
    procedure SetNegColor(const Value: TColor);
    procedure SetDecimals(const Value: Integer);
    procedure SetDigits(const Value: Integer);
    procedure RedrawBorder( const Clip: HRGN );
    function MyFormatFloat(const Format: string; const Value: Extended): string;
    Function MyStrToFloat( const S: string ): Extended;
    function ReplaceCodes( const Info: string): string;
    //[KT] - added 12/06/01, FWidthPad, FHeightPad
    Procedure SetHeightPad( Value: Integer );
    Procedure SetWidthPad( Value: Integer );
    Function GetUnformattedText: string;
    Procedure SetNumericValue( Value: extended );
    Procedure SetCursor( Position: integer );
    Procedure SetCursorPos;
    Procedure EditEnter;
    Procedure EditExit;
    procedure WMKillFocus(var Message: TWMKillFocus); message WM_KILLFOCUS;
    procedure WMSetFocus(var Message: TWMSetFocus); message WM_SETFOCUS;
    procedure CMMouseEnter(var Message: TMessage); message CM_MOUSEENTER;
    procedure CMMouseLeave(var Message: TMessage); message CM_MOUSELEAVE;
    //procedure WMNCCalcSize(var Message: TWMNCCalcSize); message WM_NCCALCSIZE;
    procedure WMNCPaint(var Message: TMessage); message WM_NCPAINT;
    Procedure WMActivateApp( Var Message: TWMActivateApp ); Message WM_ACTIVATEAPP;
    Procedure WMActivate( Var Message: TWMActivate ); Message WM_ACTIVATE;
    Procedure CMFontChanged( Var Message: TMessage ); Message CM_FONTCHANGED;
    Procedure WMGetDlgCode( Var Message: TWMGetDlgCode ); Message WM_GETDLGCODE;
    Procedure WMLButtonDown( Var Message: TWMLButtonDown ); Message WM_LBUTTONDOWN;
    function IsDesigning: Boolean;
    procedure SetEditFormat(Value: TEzEditFormat);
    procedure SetDisplayFormat(Value: TEzDisplayFormat);
    Function CreateMask( fm: TEzEditFormat ): string;
    procedure SetDecimalSeparator(const Value: Char);
    procedure SetThousandSeparator(const Value: Char);
    procedure SetUseWindowsSeparator(Value: Boolean);
    procedure SetShadowColor(const Value: TColor);
    procedure SetShadowed(const Value: Boolean);
    procedure SetShadowWidth(const Value: Integer);
  Protected
    Procedure Loaded; Override;
    Procedure Change; Dynamic;
    Procedure Paint; Override;
    //procedure Click; override;
    Procedure DblClick; Override;
    Procedure MouseDown( Button: TMouseButton; Shift: TShiftState;
      X, Y: Integer ); Override;
    Procedure MouseMove( Shift: TShiftState; X, Y: Integer ); Override;
    Procedure MouseUp( Button: TMouseButton; Shift: TShiftState;
      X, Y: Integer ); Override;
    Procedure SetEnabled( Value: Boolean ); Override;
  Public
    Constructor Create( AOwner: TComponent ); Override;
    destructor Destroy; Override;
    Procedure KeyDown( Var Key: Word; Shift: TShiftState ); Override;
    Procedure KeyPress( Var Key: Char ); Override;
    Function AsString: String;
    Property Modified: boolean Read FModified Write FModified;
  Published
    //[KT] - added 12/06/01, FWidthPad, FHeightPad
    property BorderStyle: TEzBorderStyle read FBorderStyle write SetBorderStyle default ebsSingle;
    property BorderSize: Integer read FBorderSize write SetBorderSize default neEditBorderSize;
    property BorderColor: TColor read FBorderColor write SetBorderColor default clHighlight;
    property UseThousandSeparator: Boolean read FUseThousandSeparator write SetUseThousandSeparator default True;
    property NegColor: TColor read FNegColor write SetNegColor default clRed;
    Property Digits: Integer read FDigits write SetDigits default 8;
    Property Decimals: Integer read FDecimals write SetDecimals default 2;
    Property HotTrack: Boolean read FHotTrack write FHotTrack;
    Property HeightPad: Integer Read FHeightPad Write SetHeightPad default 0;
    Property WidthPad: Integer Read FWidthPad Write SetWidthPad default -15;
    Property DecimalSeparator: Char read FDecimalSeparator write SetDecimalSeparator;
    Property ThousandSeparator: Char read FThousandSeparator write SetThousandSeparator;
    Property Shadowed: Boolean read FShadowed write SetShadowed default False;
    Property ShadowColor: TColor read FShadowColor write SetShadowColor default clGray;
    Property ShadowWidth: Integer read FShadowWidth write SetShadowWidth default neEditShadowSize;

    Property AcceptNegatives: boolean Read FAcceptNegatives Write FAcceptNegatives Default true;
    Property ReadOnly: boolean Read FReadOnly Write FReadOnly Default false;
    Property TabOnEnterKey: Boolean Read FTabOnEnterKey Write FTabOnEnterKey Default true;
    Property EditFormat: TEzEditFormat read FEditFormat write SetEditFormat;
    Property DisplayFormat: TEzDisplayFormat read FDisplayFormat write SetDisplayFormat;
    Property NumericValue: extended Read FNumericValue Write SetNumericValue;
    Property UseWindowsSeparator: Boolean read FUseWindowsSeparator write SetUseWindowsSeparator default True;

    Property OnChange: TNotifyEvent Read FOnChange Write FOnChange;

    {publish this properties}
    Property Anchors;
    Property Align;
    Property Color;
    Property Ctl3D;
    Property DragCursor;
    Property DragMode;
    Property Enabled;
    Property Font;
    Property ParentColor;
    Property ParentCtl3D;
    Property ParentFont;
    Property ParentShowHint;
    Property PopupMenu;
    Property ShowHint;
    Property TabOrder;
    Property TabStop Default True;
    Property Visible;
    Property OnClick;
    Property OnDblClick;
    Property OnDragDrop;
    Property OnDragOver;
    Property OnEndDrag;
    Property OnEnter;
    Property OnExit;
    Property OnKeyDown;
    Property OnKeyPress;
    Property OnKeyUp;
    Property OnMouseDown;
    Property OnMouseMove;
    Property OnMouseUp;
  End;

{$IFNDEF BCB}

  { TEzDBNumEd control }
  TEzDBNumEd = Class( TEzNumEd )
  Private
    FDataLink: TFieldDataLink;
    Procedure DataChange( Sender: TObject );
    Procedure EditingChange( Sender: TObject );
    Procedure ActiveChange( Sender: TObject );
    Procedure SetDataField( Const Value: String );
    Function GetDataField: String;
    Function GetDataSource: TDataSource;
    Procedure SetDataSource( Value: TDataSource );
    Function GetReadOnly: Boolean;
    Procedure SetReadOnly( Value: Boolean );
    Procedure UpdateData( Sender: TObject );
    Procedure CheckFieldType( Const Value: String );
  Protected
    Procedure Notification( AComponent: TComponent;
      Operation: TOperation ); Override;
    Procedure CMEnter( Var Message: TCMEnter ); Message CM_ENTER;
    Procedure CMExit( Var Message: TCMExit ); Message CM_EXIT;
    Function GetField: TField;
  Public
    Procedure Change; Override;
    Procedure KeyDown( Var Key: Word; Shift: TShiftState ); Override;
    Procedure KeyPress( Var Key: Char ); Override;
    Constructor Create( AOwner: TComponent ); Override;
    Destructor Destroy; Override;
    Property Field: TField Read GetField;
  Published
    Property ReadOnly: Boolean Read GetReadOnly Write SetReadOnly Default False;
    Property DataField: String Read GetDataField Write SetDataField;
    Property DataSource: TDataSource Read GetDataSource Write SetDataSource;
  End;

{$ENDIF}

Implementation

Uses
  Clipbrd, EzSystem, EzConsts ;

Type

  EInvalidFieldType = Class( Exception );

procedure ShadeIt(f: TCustomForm; c: TControl; Width: Integer; Color: TColor);
var
  rect: TRect;
  old: TColor;
begin
  if c.Visible then
  begin
    rect := c.BoundsRect;
    rect.Left := rect.Left + Width;
    rect.Top := rect.Top + Width;
    rect.Right := rect.Right + Width;
    rect.Bottom := rect.Bottom + Width;
    old := f.Canvas.Brush.Color;
    f.Canvas.Brush.Color := Color;
    f.Canvas.fillrect(rect);
    f.Canvas.Brush.Color := old;
  end;
end;

{ TEzEditFormat }

constructor TEzEditFormat.Create(NumEd: TEzNumEd);
begin
  inherited Create;
  FNumEd:= NumEd;
end;

procedure TEzEditFormat.InvalidateEditor;
begin
  If FNumEd.Focused Then
    FNumEd.SetCursorPos;
  FNumEd.Invalidate;
end;

procedure TEzEditFormat.Assign(Source: TPersistent);
Var
  Src: TEzEditFormat Absolute Source;
Begin
  If Source Is TEzEditFormat Then
  Begin
    FLeftInfo := Src.FLeftInfo;
    FRightInfo := Src.FRightInfo;
  End
  Else
    Inherited;
end;

procedure TEzEditFormat.SetLeftInfo(const Value: string);
begin
  FLeftInfo := Value;
  InvalidateEditor;
end;

procedure TEzEditFormat.SetRightInfo(const Value: string);
begin
  FRightInfo := Value;
  InvalidateEditor;
end;

{ TEzDisplayFormat }

constructor TEzDisplayFormat.Create(NumEd: TEzNumEd);
begin
  inherited Create(NumEd);
  FShow:= true;
end;

procedure TEzDisplayFormat.Assign(Source: TPersistent);
Var
  Src: TEzDisplayFormat Absolute Source;
Begin
  If Source Is TEzEditFormat Then
  Begin
    inherited Assign(Source);
    FShow:= Src.FShow;
    FZeroValue:= Src.FZeroValue;
    FNegUseParens:= Src.FNegUseParens;
  End
  Else
    Inherited;
end;

{$IFDEF BCB}
function TEzDisplayFormat.GetNegUseParens: Boolean;
begin
  Result := FNegUseParens;
end;

function TEzDisplayFormat.GetShow: Boolean;
begin
  Result := FShow;
end;

function TEzDisplayFormat.GetZeroValue: String;
begin
  Result := FZeroValue;
end;
{$ENDIF}

procedure TEzDisplayFormat.SetZeroValue(const Value: String);
begin
  if FZeroValue = Value then Exit;
  FZeroValue:= Value;
  InvalidateEditor;
end;

procedure TEzDisplayFormat.SetNegUseParens(const Value: Boolean);
begin
  if FNegUseParens = Value then exit;
  FNegUseParens := Value;
  InvalidateEditor;
end;

procedure TEzDisplayFormat.SetShow(const Value: Boolean);
begin
  if FShow = Value then Exit;
  FShow := Value;
  InvalidateEditor;
end;

{ TEzNumEd - numeric edit control }

Constructor TEzNumEd.Create( AOwner: TComponent );
Begin
  Inherited Create( AOwner );
  ControlStyle := ControlStyle + [csFramed, csOpaque];
  Width := 121;
  Height := 24;
  TabStop := True;
  FBorderStyle:= ebsSingle;
  FBorderSize:= neEditBorderSize;
  FBorderColor:= clDefault;
  ParentColor := False;
  Cursor := crIBeam;
  FEditFormat:= TEzEditFormat.Create(Self);
  FDisplayFormat:= TEzDisplayFormat.Create(Self);
  FNumericValue := 0.0;
  FOriginalValue := FNumericValue;
  FReadOnly := false;
  FAcceptNegatives := true;
  FTabOnEnterKey := true;
  FDecimalSeparator:= SysUtils.DecimalSeparator;
  FThousandSeparator:= SysUtils.ThousandSeparator;
  FUseWindowsSeparator:= True;
  FShadowed:= False;
  FShadowWidth:= neEditShadowSize;
  FShadowColor:= clGray;
  FDigits:= 8;
  FDecimals:= SysUtils.CurrencyDecimals;
  FUseThousandSeparator:= True;
  FNegColor:= clRed;

  //[KT] - added 12/06/01, FWidthPad, FHeightPad
  FHeightPad := 0;
  FWidthPad := -15;

End;

destructor TEzNumEd.Destroy;
begin
  FEditFormat.Free;
  FDisplayFormat.Free;
  if Assigned( FCaretBm ) then FCaretBm.Free;
  inherited;
end;

procedure TEzNumEd.Loaded;
begin
  inherited;
  if FUseWindowsSeparator then
  begin
    FDecimalSeparator:= SysUtils.DecimalSeparator;
    FThousandSeparator:= SysUtils.ThousandSeparator;
  end;
end;

procedure TEzNumEd.SetUseThousandSeparator(const Value: Boolean);
begin
  FUseThousandSeparator := Value;
  Invalidate;
end;

Procedure TEzNumEd.SetBorderSize( Value: Integer );
begin
  if FBordersize=Value then exit;
  FBordersize:=value;
  Invalidate;
end;

Procedure TEzNumEd.SetBorderColor(Value: TColor);
begin
  if FBorderColor=Value then exit;
  FBorderColor:=Value;
  Invalidate;
end;

procedure TEzNumEd.SetDigits(const Value: Integer);
begin
  if Value < 1 then Exit;
  FDigits := Value;
  Invalidate;
end;

procedure TEzNumEd.SetNegColor(const Value: TColor);
begin
  if Value = FNegColor then exit;
  FNegColor:= Value;
  Invalidate;
end;

procedure TEzNumEd.SetDecimals(const Value: Integer);
begin
  FDecimals := Value;
  Invalidate;
end;

procedure TEzNumEd.SetShadowWidth(const Value: Integer);
begin
  if FShadowWidth = Value then Exit;
  FShadowWidth := Value;
  Invalidate;
end;

procedure TEzNumEd.SetShadowColor(const Value: TColor);
begin
  if FShadowColor = Value then Exit;
  FShadowColor := Value;
  Invalidate;
end;

procedure TEzNumEd.SetShadowed(const Value: Boolean);
begin
  if FShadowed = Value then Exit;
  FShadowed := Value;
  Invalidate;
end;

procedure TEzNumEd.WMSetFocus(var Message: TWMSetFocus);
begin
  inherited;

  EditEnter;
  if not IsDesigning then
    RedrawBorder (0);
end;

procedure TEzNumEd.WMKillFocus(var Message: TWMKillFocus);
begin
  inherited;

  if not IsDesigning then
    RedrawBorder (0);
  EditExit;
end;

procedure TEzNumEd.WMNCPaint(var Message: TMessage);
begin
  inherited;
  RedrawBorder(Message.WParam);
end;

Procedure TEzNumEd.EditEnter;
Begin
  If Not IsDesigning Then
  Begin
    FOriginalValue := FNumericValue;
    { Create the caret }
    if FCaretBm <> Nil then FreeAndNil( FCaretBm );
    FCaretBm := TBitmap.Create;
    FCaretBm.Handle := LoadBitmap( HInstance, 'NUM_CARET' );
    CreateCaret( Handle, FCaretBm.Handle, 0, 0 );
    ShowCaret( Handle );
    FModified := false;
    FPartEditing := peInteger;
    //FSelected := true;
    Invalidate;
    SetCursorPos;
  End;
End;

Procedure TEzNumEd.EditExit;
Begin
  If Not IsDesigning Then
  Begin
    HideCaret( Handle );
    DestroyCaret;
    if FCaretBm <> Nil then
    begin
      DeleteObject( FCaretBm.Handle );
      FreeAndNil( FCaretBm );
    end;
    FSelected := false;
    Invalidate;
  End;
End;

Procedure TEzNumEd.Paint;
Var
  R: TRect;
  s,ls,rs: String;
  fm: TEzEditFormat;
  UsingParens: Boolean;
  temp: Integer;
Begin
  If Not IsDesigning and Focused Then
  begin
    HideCaret( Handle );
    fm:= FEditFormat;
  end else
    fm:= FDisplayFormat;
  Canvas.Font := Font;
  With Canvas Do
  Begin
{$ifdef false}
    R := ClientRect;
    if BorderStyle = ebsFlat then InflateRect( R, -1, -1 );
    If BorderStyle = ebsSingle Then
    Begin
      Brush.Color := clWindowFrame;
      FrameRect( R );
      InflateRect( R, -1, -1 );
    End;
{$endif}
    if Enabled then
      Brush.Color := Color
    else
      Brush.Color := clBtnFace;
    FillRect( ClientRect );
    RedrawBorder(0);
    R:= FDrawTextRect;
    { left and right info }
    ls:= ReplaceCodes( fm.LeftInfo );
    rs:= ReplaceCodes( fm.RightInfo );
    UsingParens:= false;
    if IsDesigning then
      s:= CreateMask( FEditFormat )
    else
      s:= AsString;
    if Not IsDesigning and not Focused and
       TEzDisplayFormat(fm).NegUseParens and (FNumericValue < 0) then
    begin
      ls := '(' + ls;
      rs := ')' + rs;
      UsingParens:= true;
      if (Length(s) > 0) And (s[1] = '-') then System.Delete(s,1,1);
    end;
    s:= ls + s;
    If ( FNumericValue = 0 ) And ( FNegFlag = true ) and Not UsingParens Then
      s := '-' + s;
    If FSelected Then
    Begin
      Brush.Color := clHighlight;
      If FNumericValue < 0 Then
        Font.Color := NegColor
      Else
        Font.Color := clHighlightText;
    End
    Else
    Begin
      If FNumericValue < 0.0 Then
        Font.Color := NegColor;
      If Not Enabled Then
        Font.Color := clGray;
    End;
    if Length(rs) > 0 then
    begin
      Dec( R.Right, Canvas.TextWidth( rs ) );
    end;
    //[KT] - added 12/06/01, adjust for padding
    InflateRect( R, WidthPad, HeightPad );
    Canvas.Font.Color:= clBlack;
    DrawText( Canvas.Handle, @s[1], Length( s ), R, dt_right Or
      dt_singleline Or dt_vcenter );
    if Length(rs) > 0 then
    begin
      temp:= R.Right;
      R:= ClientRect;
      InflateRect( R, 0, HeightPad );
      R.Left:= temp;
      DrawText( Canvas.Handle, @rs[1], Length( rs ), R, dt_left Or
        dt_singleline Or dt_vcenter );
    end;
  End;
  if not IsDesigning And FShadowed then
  begin
    ShadeIt(GetParentForm( Self ), Self, FShadowWidth, FShadowColor);
  end;

  If Focused Then
    ShowCaret( Handle );
End;

{procedure TEzNumEd.WMNCCalcSize(var Message: TWMNCCalcSize);
begin
  inherited;

  if FBorderStyle=ebsFlat and not IsDesigning then
    InflateRect(Message.CalcSize_Params^.rgrc[0], -3, -3);
end; }

procedure TEzNumEd.RedrawBorder(const Clip: HRGN);
var
  //DC: HDC;
  R: TRect;
  NewClipRgn: HRGN;
  FrameBrush, BtnFaceBrush, WindowBrush: HBRUSH;
  I, bsz: Integer;
  bs: TEzBorderStyle;
begin
  //if FBorderStyle <> ebsNone then
  //begin
  If Not IsDesigning and Focused Then
    HideCaret( Handle );
  //DC := GetWindowDC(Handle);
  try
    { Use update region }
    if (Clip <> 0) and (Clip <> 1) then
    begin
      GetWindowRect (Handle, R);
      if SelectClipRgn(Canvas.Handle, Clip) = ERROR then
      begin
        NewClipRgn := CreateRectRgnIndirect(R);
        SelectClipRgn (Canvas.Handle, NewClipRgn);
        DeleteObject (NewClipRgn);
      end;
      OffsetClipRgn (Canvas.Handle, -R.Left, -R.Top);
    end;

    {GetWindowRect(Handle, R);
    OffsetRect(R, -R.Left, -R.Top); }
    R:= ClientRect;
    {if (IsDesigning and Enabled) or
       (not IsDesigning and (Focused or (FMouseInControl and Not Focused))) then }
    if (BorderStyle=ebsFlat) and Not Focused and FMouseInControl then
      bs:= ebs3D
    else
      bs:= BorderStyle;
    Case bs of
      ebsSingle, ebsThick:
        Begin
          FrameBrush := CreateSolidBrush(ColorToRGB(BorderColor));
          if FBorderStyle=ebsSingle then bsz:= 1 else bsz:= FBorderSize;
          for I := 0 to bsz - 1 do
          begin
            FrameRect(Canvas.Handle, R, FrameBrush);
            InflateRect(R, -1, -1);
          end;
          DeleteObject(FrameBrush);
        End;
      ebsFlat:
        Begin
          DrawEdge(Canvas.Handle, R, BDR_SUNKENOUTER, BF_RECT or BF_ADJUST);
          with R do
          begin
            BtnFaceBrush:= CreateSolidBrush(ColorToRGB(clBtnFace));
            FillRect (Canvas.Handle, Rect(Left, Top, Left+1, Bottom-1), BtnFaceBrush);
            FillRect (Canvas.Handle, Rect(Left, Top, Right-1, Top+1), BtnFaceBrush);
            DeleteObject(BtnFaceBrush);
          end;
          DrawEdge (Canvas.Handle, R, BDR_SUNKENINNER, BF_BOTTOMRIGHT);
          InflateRect (R, -1, -1);

          WindowBrush:= CreateSolidBrush(ColorToRGB(clWindow));
          FrameRect (Canvas.Handle, R, WindowBrush);
          DeleteObject(WindowBrush);
        End;
      ebs3D:
        DrawEdge(Canvas.Handle, R, BDR_SUNKENINNER or BDR_SUNKENOUTER,
          BF_LEFT or BF_TOP or BF_RIGHT or BF_BOTTOM);
    end;
    FDrawTextRect:= R;
  finally
    //ReleaseDC (Handle, DC);
    If Focused Then
      ShowCaret( Handle );
  end;
  //end;
end;

procedure TEzNumEd.CMMouseEnter (var Message: TMessage);
begin
  inherited;
  if (FBorderStyle=ebsFlat) and Not Focused then
  begin
    FMouseInControl := True;
    if FHotTrack then RedrawBorder (0);
  end;
end;

procedure TEzNumEd.CMMouseLeave (var Message: TMessage);
begin
  inherited;
  if (FBorderStyle=ebsFlat) and Not Focused then
  begin
    FMouseInControl := False;
    if FHotTrack then RedrawBorder (0);
  end;
end;

procedure TEzNumEd.SetUseWindowsSeparator(Value: Boolean);
begin
  if FUseWindowsSeparator=Value then Exit;
  FUseWindowsSeparator:=Value;
  if Value then
  begin
    FDecimalSeparator:= SysUtils.DecimalSeparator;
    FThousandSeparator:= SysUtils.ThousandSeparator;
  end;
end;

procedure TEzNumEd.SetDecimalSeparator(const Value: Char);
begin
  FDecimalSeparator := Value;
  Invalidate;
end;

procedure TEzNumEd.SetThousandSeparator(const Value: Char);
begin
  FThousandSeparator := Value;
  Invalidate;
end;

procedure TEzNumEd.SetDisplayFormat(Value: TEzDisplayFormat);
begin
  FDisplayFormat.Assign( Value );
end;

procedure TEzNumEd.SetEditFormat(Value: TEzEditFormat);
begin
  FEditFormat.Assign( Value );
end;

Procedure TEzNumEd.SetEnabled( Value: Boolean );
Begin
  Inherited SetEnabled( Value );
  If Value Then
    Invalidate;
End;

Procedure TEzNumEd.SetNumericValue( Value: Extended );
Begin
  If Value <> FNumericValue Then
  Begin
    if Not FAcceptNegatives And (Value < 0) then Value := Abs( Value );
    FNumericValue := Value;
    FOriginalValue := FNumericValue;
    If Focused Then SetCursorPos;
    Invalidate;
    Change;
  End;
End;

Procedure TEzNumEd.DblClick;
Begin
  FSelected := true;
  FModified := false;
  if FPartEditing <> peInteger then
  begin
    FPartEditing := peInteger;
    SetCursorPos;
  end;
  Invalidate;
  Inherited DblClick;
End;

Procedure TEzNumEd.MouseDown( Button: TMouseButton; Shift: TShiftState;
  X, Y: Integer );
Begin
  if not Focused then Windows.SetFocus(Handle);
  If ( Button = mbLeft ) And ( Shift = [ssLeft] ) Then
  begin
    if FSelected then
    begin
      FSelected := false;
      Invalidate;
    end else
      FMouseDown:= true;
  end;
  Inherited MouseDown( Button, Shift, X, Y );
End;

Procedure TEzNumEd.MouseMove( Shift: TShiftState; X, Y: Integer );
Begin
  If FMouseDown Then
  Begin
    FSelected := true;
    Invalidate;
  End;
  Inherited MouseMove( Shift, X, Y );
End;

Procedure TEzNumEd.MouseUp( Button: TMouseButton; Shift: TShiftState;
  X, Y: Integer );
Begin
  FMouseDown := false;
  Inherited MouseUp( Button, Shift, X, Y );
End;

Procedure TEzNumEd.WMActivate( Var Message: TWMActivate );
Var
  ParentForm: TCustomForm;
Begin
  If IsDesigning Then
  Begin
    Inherited;
    Exit;
  End;

  ParentForm := GetParentForm( Self );

  If Assigned( ParentForm ) And ParentForm.HandleAllocated Then
    SendMessage( ParentForm.Handle, WM_NCACTIVATE, Ord( Message.Active <> WA_INACTIVE ), 0 );

  If Message.Active = WA_INACTIVE Then
    EditExit
  Else
    EditEnter;
End;

Function TEzNumEd.CreateMask( fm: TEzEditFormat ): string;
Var
  temp: string;
  I, n: Integer;
begin
  if UseThousandSeparator then
  begin
    n:= Digits div 3;
    if (Digits mod 3) = 0 then Dec(n);
    SetLength(Result, Digits + n);
    for I:= 1 to Length(Result) do
      Result[I]:= '#';
    { add a 0 to the end of formatting string }
    Result[Length(Result)]:= '0';
    I:= Length(Result) - 3;
    while I > 0 do
    begin
      Result[I] := FThousandSeparator;
      Dec(I, 4);
    end;
  end else
  begin
    SetLength(Result, Digits);
    for I:= 1 to Length(Result) do
      Result[I]:= '#';
    Result[Length(Result)]:= '0';
  end;
  if Decimals > 0 then
  begin
    SetLength(temp, Decimals);
    for I:= 1 to Length(temp) do
      temp[I]:= '0';
    Result:= Result + FDecimalSeparator + temp;
  end;
end;

Function TEzNumEd.MyStrToFloat( const S: string ): Extended;
Var
  TmpDecimalSeparator: Char;
  TmpThousandSeparator: Char;
  Modified: Boolean;
Begin
  Modified:= False;
  TmpDecimalSeparator:= SysUtils.DecimalSeparator;
  TmpThousandSeparator:= SysUtils.ThousandSeparator;
  if Not( (FThousandSeparator = SysUtils.ThousandSeparator) And
          (FDecimalSeparator  = SysUtils.DecimalSeparator ) ) then
  begin
    SysUtils.DecimalSeparator:= FDecimalSeparator;
    SysUtils.ThousandSeparator:= FThousandSeparator;
    Modified:= True;
  end;

  Result:= StrToFloat( s );

  if Modified then
  begin
    SysUtils.DecimalSeparator:= TmpDecimalSeparator;
    SysUtils.ThousandSeparator:= TmpThousandSeparator
  end;
End;

function TEzNumEd.MyFormatFloat(const Format: string; const Value: Extended): string;
var
  I: Integer;
  TmpFmt: string;
  TmpDecimalSeparator: Char;
  TmpThousandSeparator: Char;
  Modified: Boolean;
begin
  {if ( FDecimalSeparator = '.' ) And ( FThousandSeparator = ',' ) And
     ( SysUtils.DecimalSeparator = '.' ) And ( SysUtils.ThousandSeparator = ',' ) then
  begin
    Result:= FormatFloat( Format, Value );
    Exit;
  end ; }
  TmpFmt:= Format;
  for I:= 1 to Length(TmpFmt) do
    if TmpFmt[I] = FThousandSeparator then TmpFmt[I] := ','
    else if TmpFmt[I] = FDecimalSeparator then TmpFmt[I] := '.';

  Modified:= False;
  TmpDecimalSeparator:= SysUtils.DecimalSeparator;
  TmpThousandSeparator:= SysUtils.ThousandSeparator;
  if Not( (FThousandSeparator = SysUtils.ThousandSeparator) And
          (FDecimalSeparator  = SysUtils.DecimalSeparator ) ) then
  begin
    SysUtils.DecimalSeparator:= FDecimalSeparator;
    SysUtils.ThousandSeparator:= FThousandSeparator;
    Modified:= True;
  end;

  Result:= FormatFloat( TmpFmt, Value );

  if Modified then
  begin
    SysUtils.DecimalSeparator:= TmpDecimalSeparator;
    SysUtils.ThousandSeparator:= TmpThousandSeparator
  end;
end;

Function TEzNumEd.AsString: String;
Begin
  If Focused Then
  Begin
    { EditFormat }
    Result:= MyFormatFloat( CreateMask( FEditFormat ), FNumericValue );
  End
  Else
  begin
    { DisplayFormat }
    if ( FNumericValue = 0 ) And ( Length( FDisplayFormat.ZeroValue ) > 0 ) then
    begin
      Result:= FDisplayFormat.ZeroValue;
      Exit;
    end;
    Result:= MyFormatFloat( CreateMask( FDisplayFormat ), FNumericValue );
  end;
End;

Procedure TEzNumEd.SetCursor( Position: integer );
Var
  tw, X, Y: integer;
  S: String;
  R: TRect;
  AW, AH: integer;
  rw: Integer;
Begin
  R := ClientRect;
  InflateRect( R, -1, -1 );
  S := AsString;
  If ( Position < 1 ) Or ( Position > Length( S ) ) Then Exit;
  AW := 0;
  If FCaretBm <> Nil Then
    AW := FCaretBm.Width;
  if Focused then
  begin
    if Length( FEditFormat.RightInfo ) > 0 then
      rw := Canvas.TextWidth( FEditFormat.RightInfo )
    else
      rw := 0;
  end else
  begin
    if Length( FDisplayFormat.RightInfo ) > 0 then
      rw := Canvas.TextWidth( FDisplayFormat.RightInfo )
    else
      rw := 0;
  end;
  X := R.Right - Canvas.TextWidth( s ) - ( AW Div 2 ) - rw;
  tw := 0;
  If Position <= Length( s ) Then
    tw := Canvas.TextWidth( s[Position] ) Div 2;
  If Position > 1 Then
    Inc( X, Canvas.TextWidth( Copy( s, 1, Position - 1 ) ) + tw )
  Else
    Inc( X, tw );
  AH := 0;
  If FCaretBm <> Nil Then
    AH := FCaretBm.Height;
  Y := Height - AH - 1;
  //[KT] - added 12/06/01, adjust caret for padding
  SetCaretPos( X + WidthPad, Y );
  FSelStart := Position;
End;

Procedure TEzNumEd.SetCursorPos;
Var
  P, P1: integer;
  s: String;
  Valid: boolean;
Begin
  Repeat
    Valid := true;

    HideCaret( Handle );
    ShowCaret( Handle );
    s := AsString;
    If FPartEditing = peInteger Then
    Begin
      { Editing integer part, place the cursor }
      P := AnsiPos( FDecimalSeparator, s );
      If P = 0 Then
        SetCursor( Length( s ) )
      Else
        SetCursor( P - 1 );
    End
    Else
    Begin
      P := AnsiPos( FDecimalSeparator, s );
      If P = 0 Then
      Begin
        FPartEditing := peInteger;
        Exit;
      End;
      P1 := P;
      If P1 < FSelStart Then
        P1 := FSelStart;
      If FLastKey <> #8 Then
        Inc( P1 )
      Else
        Dec( P1 );
      If P1 > Length( s ) Then
        P1 := Length( s );
      If P1 < P + 1 Then
      Begin
        If FLastKey = #8 Then
        Begin
          FPartEditing := peInteger;
          Valid := false;
          Continue;
        End;
        P1 := P + 1;
      End;
      SetCursor( P1 );
      FSelStart := P1;
    End;
  Until Valid;
End;

Procedure TEzNumEd.WMGetDlgCode( Var Message: TWMGetDlgCode );
Begin
  Inherited;
  Message.Result := Message.Result Or DLGC_WANTALLKEYS Or DLGC_WANTARROWS;
End;

function TEzNumEd.IsDesigning: Boolean;
{$IFDEF ISACTIVEX}
  Function IsControlInDesignMode: Boolean;
  Begin
    Try
      Result := Not ( ( FAXCtrl.ClientSite As IAmbientDispatch ).UserMode );
    Except
      Result := False;
    End;
  End;
{$ENDIF}
Begin
{$IFDEF ISACTIVEX}
  If ( FAXCtrl <> Nil ) Then
    Result := IsControlInDesignMode
  Else
{$ENDIF}
  Result:= csDesigning in ComponentState;
end;

function TEzNumEd.ReplaceCodes( const Info: string): string;
begin
  Result:= StringReplace( Info, '\c', CurrencyString, [rfReplaceAll, rfIgnoreCase])
end;

Procedure TEzNumEd.KeyDown( Var Key: Word; Shift: TShiftState );
Var
  Value: Extended;
Begin
  If Key = VK_INSERT Then
  Begin
    If Shift = [] Then
      FModified := true;
    If ( Shift = [] ) And FSelected Then
    Begin
      FSelected := false;
      Invalidate;
    End;
    {copy}
    If ssCtrl In Shift Then
    Begin
      Clipboard.AsText := FloatToStr( FNumericValue );
      Key := 0;
    End;
    {paste}
    If ( FReadOnly = false ) And ( ssShift In Shift ) Then
    Begin
      Try
        Value := MyStrToFloat( Clipboard.AsText );
        If Not FAcceptNegatives Then
          Value:= Abs(Value);
        FNumericValue := Value;
        FModified := true;
        Change;
        FSelected := false;
        Invalidate;
      Except
        MessageBeep( 0 );
      End;
      Key := 0;
    End;
  End;
  If ( Shift = [] ) And ( Key = VK_DELETE ) And Not ( FReadOnly ) Then
  Begin
    FNumericValue := 0;
    FModified := true;
    Change;
    Invalidate;
  End;
  If ( Shift = [] ) And ( Key = VK_UP ) Then
    PostMessage( GetParentForm( Self ).Handle, WM_NEXTDLGCTL, 1, 0 );
  If ( Shift = [] ) And ( Key = VK_DOWN ) Then
    PostMessage( GetParentForm( Self ).Handle, WM_NEXTDLGCTL, 0, 0 );
  Inherited KeyDown( Key, Shift );
End;

Procedure TEzNumEd.WMLButtonDown( Var Message: TWMLButtonDown );
Begin
  If TabStop Then
    Windows.SetFocus( Handle );
  Inherited;
End;

Function TEzNumEd.GetUnformattedText: string;
var
  temp: boolean;
begin
  temp:= FUseThousandSeparator;
  FUseThousandSeparator:= false;
  Result:= AsString;
  FUseThousandSeparator:= temp;
  Result:= StringReplace(Result, #32,'',[rfReplaceAll]);
end;

Procedure TEzNumEd.KeyPress( Var Key: Char );
Var
  P, P1, P2: integer;
  s, sMask: String;
  Changed: boolean;
  Value: extended;
  OneIntegerDigit: boolean;
Begin
  FSelected := false;
  If ( Key = #13 ) And ( FTabOnEnterKey ) Then
  Begin
    GetParentForm( Self ).Perform( WM_NEXTDLGCTL, 0, 0 );
    Key := #0;
    Exit;
  End;

  If ( FReadOnly = false ) And ( Key = #27 ) Then
  Begin
    If ( FNumericValue = FOriginalValue ) And Not FModified Then
    Begin
      Invalidate;
      Inherited KeyPress( Key );
      Exit;
    End;
    FNumericValue := FOriginalValue;
    FModified := false;
    Invalidate;
    Key := #0;
    Exit;
  End;

  If Key = ^C Then
  Begin {copy}
    Clipboard.AsText := FloatToStr( FNumericValue );
    Key := #0;
    exit;
  End;

  If ( FReadOnly = false ) And ( Key = ^V ) Then
  Begin {paste}
    Try
      Value := MyStrToFloat( Clipboard.AsText );
      If Not FAcceptNegatives Then
        Value := Abs( Value );
      FNumericValue := Value;
      Change;
      Invalidate;
    Except
      MessageBeep( 0 );
    End;
    Key := #0;
    Exit;
  End;

  Inherited KeyPress( Key );

  If FReadOnly Then
  Begin
    Key := #0;
    Exit;
  End;

  If Not ( Key In ['0'..'9', FDecimalSeparator, '-', #8] ) Then
  Begin
    MessageBeep( 0 );
    Key := #0;
    exit;
  End;

  FLastKey := Key;
  Changed := false;
  s := GetUnformattedText;
  sMask:= CreateMask( FEditFormat );
  OneIntegerDigit := false;
  If Length(sMask) = 1 Then
    OneIntegerDigit := true
  Else If ( Length( s ) > 1 ) Then
  Begin
    P := AnsiPos( FDecimalSeparator, s );
    If ( P > 0 ) And ( Copy( sMask, 1, 2 ) = '0' + FDecimalSeparator ) Then
      OneIntegerDigit := true;
  End;
  If Key In ['0'..'9'] Then
  Begin
    {insert the number}
    If Not FModified Then
    Begin
      FNumericValue := 0;
      s := GetUnformattedText;
      FModified := true;
    End;
    If ( FPartEditing = peInteger ) Then
    Begin
      If OneIntegerDigit Or
        ( Length( TrimLeft( AsString ) ) < Length( sMask ) ) Then
      Begin
        P := AnsiPos( FDecimalSeparator, s );
        If P = 0 Then
        Begin
          If sMask <> '0' Then
            s := s + Key
          Else
            s := Key;
        End
        Else
        Begin
          If Copy( sMask, 1, 2 ) = '0' + FDecimalSeparator Then
            s[P - 1] := Key
          Else
            System.Insert( Key, s, P );
        End;
      End;
    End
    Else
    Begin
      p2 := AnsiPos( FDecimalSeparator, AsString ) + 1;
      If FSelStart < p2 Then
        FSelStart := p2;
      P := FSelStart - p2 + 1;
      p1 := AnsiPos( FDecimalSeparator, s );
      s[p1 + p] := Key;
    End;
    FNumericValue := MyStrToFloat( s );
    If FNegFlag Then
    Begin
      FNumericValue := -FNumericValue;
      FNegFlag := false;
    End;
    Changed := true;
    SetCursorPos;
  End;

  If Key = #8 Then
  Begin {BACKSPACE}
    If FPartEditing = peInteger Then
    Begin
      p := AnsiPos( FDecimalSeparator, s );
      If p = 0 Then
        System.delete( s, Length( s ), 1 )
      Else
        System.delete( s, p - 1, 1 );
    End
    Else
    Begin
      p2 := AnsiPos( FDecimalSeparator, AsString ) + 1;
      If FSelStart < p2 Then
        FSelStart := p2;
      P := FSelStart - p2 + 1;
      p1 := AnsiPos( FDecimalSeparator, s );
      s[p1 + p] := '0';
    End;
    If ( s = '' ) Or ( s = '-' ) Then
    Begin
      FNumericValue := 0.0;
      FNegFlag := false;
    End
    Else
      FNumericValue := MyStrToFloat( s );
    FModified := true;
    Changed := true;
    SetCursorPos;
  End;

  If Key = FDecimalSeparator Then
  Begin
    FModified := true;
    If ( FPartEditing = peInteger ) And ( AnsiPos( FDecimalSeparator, sMask ) > 0 ) Then
    Begin
      FPartEditing := peDecimal;
    End
    Else
      FPartEditing := peInteger;
    Changed := true;
    SetCursorPos;
  End;

  If ( Key = '-' ) And FAcceptNegatives Then
  Begin
    If Not FModified Then
    Begin
      FNumericValue := 0;
      FModified := true;
    End;
    FNumericValue := -FNumericValue;
    If FNumericValue = 0 Then
      FNegFlag := Not FNegFlag;
    Changed := true;
  End;
  If Changed Then
  Begin
    Change;
    If Parent <> Nil Then
      SendMessage( Parent.Handle, WM_COMMAND, 0, ( EN_CHANGE Shl 16 ) Or Handle );
  End;
  Invalidate;
End;

Procedure TEzNumEd.SetBorderStyle( Value: TEzBorderStyle );
Begin
  If FBorderStyle <> Value Then
  Begin
    FBorderStyle := Value;
    RecreateWnd;
  End;
End;

Procedure TEzNumEd.CMFontChanged( Var Message: TMessage );
Begin
  Inherited;
  Invalidate;
End;

Procedure TEzNumEd.Change;
Begin
  If Assigned( FOnChange ) Then
    FOnChange( Self );
End;

Procedure TEzNumEd.WMActivateApp( Var Message: TWMActivateApp );
Begin
  Inherited;
  If ( Not Message.Active ) And Focused Then
    EditExit;
End;

Procedure TEzNumEd.SetHeightPad( Value: Integer );
Begin
  If Value <> FHeightPad Then
  Begin
    {if (FAcceptNegatives = false) and (Value < 0) then
       raise Exception.Create('Numeric value must be >= 0');}
    FHeightPad := Value;
    //     if Focused then SetCursorPos;
    Invalidate;
    //     Change;
  End;
End;

Procedure TEzNumEd.SetWidthPad( Value: Integer );
Begin
  If Value <> FWidthPad Then
  Begin
    {if (FAcceptNegatives = false) and (Value < 0) then
       raise Exception.Create('Numeric value must be >= 0');}
    FWidthPad := Value;
    //     if Focused then SetCursorPos;
    Invalidate;
    //     Change;
  End;
End;

{$IFNDEF BCB}

{- TEzDBNumEd control -}

Constructor TEzDBNumEd.Create( AOwner: TComponent );
Begin
  Inherited Create( AOwner );

  Inherited ReadOnly := true;

  FDataLink := TFieldDataLink.Create;
  FDataLink.Control := Self;

  FDataLink.OnDataChange := DataChange;
  FDataLink.OnEditingChange := EditingChange;
  FDataLink.OnUpdateData := UpdateData;
  FDataLink.OnActiveChange := ActiveChange;

End;

Destructor TEzDBNumEd.Destroy;
Begin
  FDataLink.Free;
  FDataLink := Nil;
  Inherited destroy;
End;

Procedure TEzDBNumEd.Change;
Begin
  If FDataLink <> Nil Then
    FDataLink.Modified;
  Inherited Change;
End;

Procedure TEzDBNumEd.DataChange( Sender: TObject );
Var
  TrashText: String;
Begin
  If FDataLink.Field = Nil Then Exit;
  { FDataLink.Field.Alignment is ignored
    also FDataLink.Field.EditMask is ignored.
    EditFormat is used instead}

  If FDataLink.CanModify Then
    If FDataLink.Field.DataType In ( [ftBCD, ftCurrency, ftFloat, ftSmallInt, ftInteger, ftWord] ) Then
    Begin
      If FDataLink.Field.Text = '' Then
      Begin
        NumericValue := 0.0; {accesing the property, update FOriginalValue}
      End
      Else
      Begin
        TrashText := FDataLink.Field.Text;
        While AnsiPos( FThousandSeparator, trashText ) > 0 Do
          Delete( TrashText, AnsiPos( FThousandSeparator, TrashText ), 1 );
        While AnsiPos( CurrencyString, trashText ) > 0 Do
          Delete( TrashText, AnsiPos( CurrencyString, TrashText ), Length( CurrencyString ) );
        {accesing the property, update FOriginalValue}
        NumericValue := MyStrToFloat( TrashText );
      End;
      Invalidate;
      FModified := false;
    End;
End;

Procedure TEzDBNumEd.EditingChange( Sender: TObject );
Begin
  Inherited ReadOnly := Not FDataLink.Editing;
End;

Procedure TEzDBNumEd.ActiveChange( Sender: TObject );
Begin
  If ( FDataLink <> Nil ) And FDatalink.Active Then
    CheckFieldType( DataField );
End;

Procedure TEzDBNumEd.UpdateData( Sender: TObject );
Begin
  If FDataLink = Nil Then
    exit;
  Case FDataLink.Field.DataType Of
    ftBCD: TBCDField( FDataLink.Field ).AsFloat := FNumericValue;
    ftCurrency: TCurrencyField( FDataLink.Field ).AsFloat := FNumericValue;
    ftFloat: TFloatField( FDataLink.Field ).AsFloat := FNumericValue;
    ftSmallInt: TSmallIntField( FDataLink.Field ).AsInteger := round( FNumericValue );
    ftInteger: TIntegerField( FDataLink.Field ).AsInteger := round( FNumericValue );
    ftWord: TWordField( FDataLink.Field ).AsInteger := round( FNumericValue );
  End;
End;

Function TEzDBNumEd.GetDataSource: TDataSource;
Begin
  Result := FDataLink.DataSource;
End;

Procedure TEzDBNumEd.SetDataSource( Value: TDataSource );
Begin
  FDataLink.DataSource := Value;
End;

Function TEzDBNumEd.GetDataField: String;
Begin
  Result := FDataLink.FieldName;
End;

Procedure TEzDBNumEd.SetDataField( Const Value: String );
Begin
  CheckFieldType( Value );
  FDataLink.FieldName := Value;
End;

Procedure TEzDBNumEd.CheckFieldType( Const Value: String );
Var
  FieldType: TFieldType;
Begin
  If ( Value <> '' ) And ( FDataLink <> Nil ) And ( FDataLink.Dataset <> Nil )
    And ( FDataLink.DataSet.Active ) Then
  Begin
    FieldType := FDataLink.DataSet.FieldByName( Value ).DataType;
    If Not ( FieldType In [ftCurrency, ftBCD, ftFloat, ftsmallint, ftinteger, ftword] ) Then
      Raise EInvalidFieldType.Create( 'DataField can only be connected to' +
        ' columns of type Numeric' );
  End
End;

Function TEzDBNumEd.GetReadOnly: Boolean;
Begin
  Result := FDataLink.ReadOnly;
End;

Procedure TEzDBNumEd.SetReadOnly( Value: Boolean );
Begin
  FDataLink.ReadOnly := Value;
End;

Function TEzDBNumEd.GetField: TField;
Begin
  Result := FDataLink.Field;
End;

Procedure TEzDBNumEd.Notification( AComponent: TComponent;
  Operation: TOperation );
Begin
  Inherited Notification( AComponent, Operation );
  If ( Operation = opRemove ) And ( FDataLink <> Nil ) And
    ( AComponent = DataSource ) Then
    DataSource := Nil;
End;

Procedure TEzDBNumEd.CMEnter( Var Message: TCMEnter );
Begin
  FDataLink.Reset;
  Inherited;
End;

Procedure TEzDBNumEd.CMExit( Var Message: TCMExit );
Begin
  Try
    FDataLink.UpdateRecord;
  Except
    Windows.SetFocus( Handle );
    Raise;
  End;
  Inherited;
End;

Procedure TEzDBNumEd.KeyDown( Var Key: Word; Shift: TShiftState );
Begin
  Inherited KeyDown( Key, Shift );
  If ( Key = VK_DELETE ) Or ( ( Key = VK_INSERT ) And ( ssShift In Shift ) ) Then
    FDataLink.Edit;
  If ( Key = VK_DELETE ) And ( Shift = [] ) Then
  Begin
    If FDataLink <> Nil Then
    Begin
      FNumericValue := 0;
      Change;
    End;
  End;
End;

Procedure TEzDBNumEd.KeyPress( Var Key: Char );
Var
  NumericValue_: extended;
Begin
  If ( Key In [#32..#255] ) And ( FDataLink.Field <> Nil ) And
    Not FDataLink.Field.IsValidChar( Key ) Then
  Begin
    MessageBeep( 0 );
    Key := #0;
  End;
  Case Key Of
    ^H, ^V, ^X, #32..#255:
      FDataLink.Edit;
    #27:
      Begin
        FDataLink.Reset;
        FModified := false;
        Key := #0;
      End;
  End;

  NumericValue_ := FNumericValue;

  Inherited KeyPress( Key );

  If FNumericValue <> NumericValue_ Then
    FDataLink.Modified;

End;
{$ENDIF}

End.
