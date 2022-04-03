unit fTextEditor;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, StdCtrls, Buttons, EzCmdLine, EzColorPicker ;

type
  TfrmTextEditor = class(TForm)
    Panel1: TPanel;
    cboFontName: TComboBox;
    BtnBold: TSpeedButton;
    BtnItal: TSpeedButton;
    BtnUnder: TSpeedButton;
    Memo1: TMemo;
    CboSize: TComboBox;
    ColorBox1: TEzColorBox;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure cboFontNameChange(Sender: TObject);
  private
    FAction: TEzAction;
    FInUpdate: Boolean;
    FOnTextChanged: TNotifyEvent;
    procedure UpdateText;
  public
    procedure CreateParams(var Params: TCreateParams); override;
    procedure Enter(Action: TEzAction);

    procedure CreateText;

    property OnTextChanged: TNotifyEvent read FOnTextChanged write FOnTextChanged;
  end;

Var
  ParentTextEditorHWND: THandle;

implementation

{$R *.dfm}

uses
  Printers, EzSystem, EzBase, EzActionLaunch, EzEntities, EzLib, EzBaseGis;

{ TfrmTextEditor }

procedure TfrmTextEditor.CreateParams(var Params: TCreateParams);
begin
  Inherited CreateParams( Params );
  With Params Do
  Begin
    Style := Style Or ws_Overlapped;
    WndParent := ParentTextEditorHWND;
  end;
end;

function EnumFontsProc(var LogFont: TLogFont; var TextMetric: TTextMetric;
  FontType: Integer; Data: Pointer): Integer; stdcall;
begin
  If (FontType and TRUETYPE_FONTTYPE) <> 0 Then
  begin
    If TStrings(Data).IndexOf( LogFont.lfFaceName ) < 0 Then
      TStrings(Data).Add( LogFont.lfFaceName );
  end;
  Result := 1;
end;

Procedure TfrmTextEditor.Enter(Action: TEzAction);

  procedure EnumFonts(DC: HDC);
  var
    LogFont: TLogFont;
  begin
    with LogFont do
    begin
      lfCharset := DEFAULT_CHARSET;
      lfFaceName := '';
      lfPitchAndFamily := 0;
    end;
    EnumFontFamiliesEx(DC, LogFont, @EnumFontsProc, Integer(CboFontName.Items), 0);
  end;

begin
  FAction:= Action;

  EnumFonts(Printer.Handle);  // change to Self.Handle for screen fonts

  //CboFontName.Items.Assign( Screen.Fonts );
  CboFontName.Sorted:=true;

  FInUpdate:= True;
  CboFontName.ItemIndex:= CboFontName.Items.IndexOf(Ez_Preferences.DefTTFontStyle.Name);
  CboSize.ItemIndex:= 5;
    //CboSize.Items.IndexOf( IntToStr( Trunc( Action.CmdLine.DrawBox.Grapher.PointsToDistY(Ez_Preferences.DefTTFontStyle.Height) ) ));
  If CboSize.ItemIndex < 0 then
    CboSize.ItemIndex:= 2;
  BtnBold.Down:= fsBold in Ez_Preferences.DefTTFontStyle.Style;
  BtnItal.Down:= fsItalic in Ez_Preferences.DefTTFontStyle.Style;
  BtnUnder.Down:= fsUnderline in Ez_Preferences.DefTTFontStyle.Style;
  ColorBox1.Selected:= Ez_Preferences.DefTTFontStyle.Color;
  FInUpdate:= False;

  CreateText;

  Top := Screen.DesktopHeight - Height;
  Left := 0;
  Show;
end;

procedure TfrmTextEditor.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  if FAction is TAddTextAction then
    TAddTextAction( FAction ).FormEditor:= Nil
  else
  if FAction is TAddText500Action then
    TAddText500Action( FAction ).FormEditor:= Nil
  else
  if FAction is TEditTextAction then
    TEditTextAction( FAction ).FormEditor:= Nil;

  FAction.Finished:= True;
  Action:= caFree;
end;

procedure TfrmTextEditor.UpdateText;
var
  Style: TFontStyles;
begin
  If FInUpdate Then Exit;
  if FAction is TAddTextAction then
    with TAddTextAction(FAction), TEzTrueTypeText( TAddTextAction( FAction ).Text ) do
    begin
      BeginUpdate;
      Fonttool.Name := cboFontName.Text;
      Fonttool.Height := CmdLine.ActiveDrawBox.Grapher.PointsToDistY(StrToIntDef(CboSize.Text,8));
      Style := [];
      if BtnBold.Down then
        Include(Style, fsBold);
      if BtnItal.Down then
        Include(Style, fsItalic);
      if BtnUnder.Down then
        Include(Style, fsUnderline);
      Fonttool.Style:= Style;
      Fonttool.Color:= Colorbox1.Selected;
      TEzTrueTypeText( TAddTextAction( FAction ).Text ).Text := TrimCrLf( Memo1.Text );
      EndUpdate;
      CmdLine.All_Invalidate;
    end;
  if Assigned(OnTextChanged) then
    OnTextChanged(Self);
end;

procedure TfrmTextEditor.cboFontNameChange(Sender: TObject);
begin
  UpdateText;
end;

procedure TfrmTextEditor.CreateText;
var
  TmpHeight: Double;
begin
  if FAction is TAddTextAction then
  with TAddTextAction(FAction) do
    If Text = Nil Then
    Begin
      TmpHeight:= FAction.CmdLine.ActiveDrawBox.Grapher.PointsToDistY(StrToIntDef(CboSize.Text,8));
      Text:= TEzTrueTypeText.CreateEntity( Point2d(0,0), Memo1.Text, TmpHeight, 0 );
      with TEzTrueTypeText(Text).Fonttool do
      begin
        Assign( Ez_Preferences.DefTTFontStyle );
        Name:= cboFontname.Text;
        Style:= [];
        If BtnBold.Down then Style:= Style + [fsBold];
        If BtnItal.Down then Style:= Style + [fsItalic];
        If BtnUnder.Down then Style:= Style + [fsUnderline];
        Color:= ColorBox1.Selected;
        Height:= TmpHeight;
      end;
    End;
end;

end.
